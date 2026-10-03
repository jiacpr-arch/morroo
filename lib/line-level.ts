/**
 * เลือก / เปลี่ยนระดับข้อสอบ (profiles.target_exam) จากแชท LINE.
 *
 * Postbacks (data format ผ่าน parseData):
 *   action=level_menu            → ส่ง quick reply ให้เลือกระดับ
 *   action=set_level&v=<target>  → บันทึกระดับ (ต้องผูกบัญชี morroo แล้ว)
 *                                  เลือก board → ตามด้วยเมนูเลือกสาขา
 *   action=set_board&v=<slug>    → บันทึกสาขา Board (profiles.board_specialty)
 *
 * คืน null ถ้าไม่ใช่ action ของไฟล์นี้ — ต่อ chain ใน webhook ด้วย ?? ได้เลย
 */

import type { SupabaseClient } from "@supabase/supabase-js";
import type { LineMessage } from "@/lib/line";
import { parseData } from "@/lib/ads-autofix-line";
import {
  EXAM_TARGETS,
  examKindsForTarget,
  examTargetLabel,
  isBoardSpecialtySlug,
  isExamTarget,
} from "@/lib/exam-level";
import { formatThaiExamDate, getNextExamRound } from "@/lib/exam-dates";
import { loadExamRounds } from "@/lib/exam-rounds";

const MENU_ACTION = "level_menu";
const SET_ACTION = "set_level";
const BOARD_ACTION = "set_board";
// LINE quick replies hold at most 13 items
const MAX_QUICK_REPLIES = 13;
const MENU_TEXTS = new Set(["ระดับ", "เปลี่ยนระดับ", "ตั้งระดับ", "เลือกระดับ", "level"]);

function txt(text: string): LineMessage {
  return { type: "text", text };
}

/** ข้อความพิมพ์ที่ควรเปิดเมนูระดับ (เทียบแบบตรงตัวหลัง trim/lowercase) */
export function isLevelMenuText(text: string): boolean {
  return MENU_TEXTS.has(text.trim().toLowerCase());
}

const NOT_LINKED_TEXT =
  "ต้องผูกบัญชี MorRoo กับ LINE ก่อนถึงจะเลือกระดับได้ครับ 🔗\n" +
  "สร้างรหัส MORROO-XXXX ที่หน้า Profile ในแอป แล้วพิมพ์ส่งมาที่นี่";

export function buildLevelMenu(current: string | null): LineMessage {
  const currentLabel = examTargetLabel(current);
  return {
    type: "text",
    text:
      "🎯 เลือกระดับข้อสอบที่กำลังเตรียมตัว\n" +
      (currentLabel ? `ตอนนี้: ${currentLabel}\n` : "") +
      "ข้อสอบประจำวันและการเตือนวันสอบจะปรับตามระดับที่เลือก",
    quickReply: {
      items: EXAM_TARGETS.map((t) => ({
        type: "action" as const,
        action: {
          type: "postback" as const,
          label: t.shortLabel.slice(0, 20), // LINE caps quick-reply labels at 20 chars
          data: `action=${SET_ACTION}&v=${t.id}`,
          displayText: `ระดับ ${t.label}`,
        },
      })),
    },
  };
}

interface LevelProfile {
  id: string;
  target_exam: string | null;
  board_specialty: string | null;
}

async function findProfile(
  supabase: SupabaseClient,
  lineUserId: string
): Promise<LevelProfile | null> {
  // profiles.line_user_id has no unique constraint — take at most one row.
  const { data } = await supabase
    .from("profiles")
    .select("id, target_exam, board_specialty")
    .eq("line_user_id", lineUserId)
    .limit(1);
  return (data?.[0] as LevelProfile | undefined) ?? null;
}

export interface BoardSpecialtyOption {
  slug: string;
  name_th: string;
  short_name_th?: string | null;
}

async function loadBoardSpecialties(supabase: SupabaseClient): Promise<BoardSpecialtyOption[]> {
  const { data, error } = await supabase
    .from("board_specialties")
    .select("slug, name_th, short_name_th")
    .eq("is_active", true)
    .order("display_order", { ascending: true });
  if (error) {
    console.error("[line-level] load board_specialties failed:", error);
    return [];
  }
  return (data as BoardSpecialtyOption[] | null) ?? [];
}

/** เมนูเลือกสาขา Board (quick reply) — เปลี่ยนสาขาได้ทุกเมื่อโดยเลือก Board ใหม่ในเมนูระดับ */
export function buildBoardMenu(
  specialties: BoardSpecialtyOption[],
  currentSlug: string | null
): LineMessage {
  const current = specialties.find((s) => s.slug === currentSlug);
  return {
    type: "text",
    text:
      "🎓 เลือกสาขา Board ที่กำลังเตรียมสอบ\n" +
      (current ? `ตอนนี้: ${current.name_th}\n` : "") +
      "ข้อสอบประจำวันจะเป็นข้อของสาขานี้",
    quickReply: {
      items: specialties.slice(0, MAX_QUICK_REPLIES).map((s) => ({
        type: "action" as const,
        action: {
          type: "postback" as const,
          label: (s.short_name_th ?? s.name_th).slice(0, 20), // LINE caps quick-reply labels at 20 chars
          data: `action=${BOARD_ACTION}&v=${s.slug}`,
          displayText: s.name_th,
        },
      })),
    },
  };
}

/** เมนูระดับสำหรับ LINE user (ใช้ทั้ง postback และข้อความพิมพ์) */
export async function levelMenuFor(
  supabase: SupabaseClient,
  lineUserId: string
): Promise<LineMessage[]> {
  const profile = await findProfile(supabase, lineUserId);
  if (!profile) return [txt(NOT_LINKED_TEXT)];
  return [buildLevelMenu(profile.target_exam)];
}

export async function handleLevelPostback(
  supabase: SupabaseClient,
  lineUserId: string,
  rawData: string,
  now: Date = new Date()
): Promise<LineMessage[] | null> {
  const params = parseData(rawData);

  if (params.action === MENU_ACTION) return levelMenuFor(supabase, lineUserId);
  if (params.action === BOARD_ACTION) return handleSetBoard(supabase, lineUserId, params.v);
  if (params.action !== SET_ACTION) return null;

  const target = params.v;
  if (!isExamTarget(target)) return [txt("ไม่รู้จักระดับนี้ครับ ลองเลือกใหม่อีกครั้งนะ 🙏")];

  const profile = await findProfile(supabase, lineUserId);
  if (!profile) return [txt(NOT_LINKED_TEXT)];

  const { error } = await supabase
    .from("profiles")
    .update({ target_exam: target })
    .eq("id", profile.id);
  if (error) {
    console.error("[line-level] update target_exam failed:", error);
    return [txt("บันทึกระดับไม่สำเร็จ ลองใหม่อีกครั้งนะครับ 🙏")];
  }

  // Board has many specialties — ask which one next (the daily card is per specialty).
  if (target === "board") {
    const specialties = await loadBoardSpecialties(supabase);
    if (specialties.length > 0) {
      return [
        txt("✅ ตั้งระดับเป็น Board เฉพาะทางแล้ว"),
        buildBoardMenu(specialties, profile.board_specialty),
      ];
    }
  }

  const kinds = examKindsForTarget(target);
  const next =
    kinds.length > 0 ? getNextExamRound(now, kinds, await loadExamRounds(supabase)) : null;
  const lines = [
    `✅ ตั้งระดับเป็น ${examTargetLabel(target)} แล้ว`,
    "ข้อสอบประจำวันครั้งต่อไปจะตรงกับระดับนี้",
  ];
  if (next) {
    lines.push(
      `📅 สอบถัดไป: ${next.label}\n${formatThaiExamDate(next.date)}${next.confirmed ? "" : " (รอประกาศ ศรว.)"}`
    );
  }
  return [txt(lines.join("\n"))];
}

async function handleSetBoard(
  supabase: SupabaseClient,
  lineUserId: string,
  slug: string | undefined
): Promise<LineMessage[]> {
  const profile = await findProfile(supabase, lineUserId);
  if (!profile) return [txt(NOT_LINKED_TEXT)];

  const specialties = await loadBoardSpecialties(supabase);
  const chosen = isBoardSpecialtySlug(slug) ? specialties.find((s) => s.slug === slug) : undefined;
  if (!chosen) {
    return specialties.length > 0
      ? [buildBoardMenu(specialties, profile.board_specialty)]
      : [txt("ยังเลือกสาขาไม่ได้ในตอนนี้ ลองใหม่อีกครั้งนะครับ 🙏")];
  }

  const { error } = await supabase
    .from("profiles")
    .update({ target_exam: "board", board_specialty: chosen.slug })
    .eq("id", profile.id);
  if (error) {
    console.error("[line-level] update board_specialty failed:", error);
    return [txt("บันทึกสาขาไม่สำเร็จ ลองใหม่อีกครั้งนะครับ 🙏")];
  }
  return [
    txt(
      `✅ ตั้งเป็น Board ${chosen.name_th} แล้ว\nข้อสอบประจำวันครั้งต่อไปจะเป็นข้อของสาขานี้ — เปลี่ยนสาขาได้ตลอดโดยพิมพ์ "ระดับ"`
    ),
  ];
}
