/**
 * เลือก / เปลี่ยนระดับข้อสอบ (profiles.target_exam) จากแชท LINE.
 *
 * Postbacks (data format ผ่าน parseData):
 *   action=level_menu            → ส่ง quick reply ให้เลือกระดับ
 *   action=set_level&v=<target>  → บันทึกระดับ (ต้องผูกบัญชี morroo แล้ว)
 *
 * คืน null ถ้าไม่ใช่ action ของไฟล์นี้ — ต่อ chain ใน webhook ด้วย ?? ได้เลย
 */

import type { SupabaseClient } from "@supabase/supabase-js";
import type { LineMessage } from "@/lib/line";
import { parseData } from "@/lib/ads-autofix-line";
import { EXAM_TARGETS, examKindsForTarget, examTargetLabel, isExamTarget } from "@/lib/exam-level";
import { formatThaiExamDate, getNextExamRound } from "@/lib/exam-dates";

const MENU_ACTION = "level_menu";
const SET_ACTION = "set_level";
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

async function findProfile(
  supabase: SupabaseClient,
  lineUserId: string
): Promise<{ id: string; target_exam: string | null } | null> {
  // profiles.line_user_id has no unique constraint — take at most one row.
  const { data } = await supabase
    .from("profiles")
    .select("id, target_exam")
    .eq("line_user_id", lineUserId)
    .limit(1);
  return (data?.[0] as { id: string; target_exam: string | null } | undefined) ?? null;
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

  const kinds = examKindsForTarget(target);
  const next = kinds.length > 0 ? getNextExamRound(now, kinds) : null;
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
