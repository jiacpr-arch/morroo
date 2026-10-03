/**
 * LINE rich menu ของหมอรู้ — เมนูเดียวสำหรับทุกคน ฝั่ง server ตัดสินระดับเอง
 * (ทำแบบเดียวกับ roodee src/lib/line-menu.ts เพื่อให้ 3 แบรนด์ใช้ grid เดียวกัน)
 *
 * รูป: public/line/rich-menu-main.jpg (2500×1686, ≤ 1 MB) — spec ใน docs/line-rich-menu.md
 * ติดตั้งผ่าน POST /api/admin/line/rich-menu (ปุ่มบน /admin): สร้างเมนู → อัปโหลดรูป
 * → ตั้งเป็น default ให้ทุกคน → ลบเมนู morroo-main* อันเก่า
 * rich menu ที่ตั้งใน LINE OA Manager จะทับเมนูนี้ — ต้องปิดที่นั่นก่อน
 *
 * Postbacks:
 *   action=menu_today  → การ์ดข้อสอบวันนี้ตามระดับ (handleMenuPostback ด้านล่าง)
 *   action=level_menu  → เมนูเลือกระดับ (lib/line-level.ts)
 * ช่องอื่นเป็นลิงก์ LIFF — หน้าเว็บเลือกระดับเอง
 */

import type { SupabaseClient } from "@supabase/supabase-js";
import type { LineMessage } from "@/lib/line";
import { parseData } from "@/lib/ads-autofix-line";
import { buildDailyMcqFlex } from "@/lib/line-flex-templates";
import { liffDeepLink } from "@/lib/line-links";
import { isExamTarget, mcqPoolForTarget } from "@/lib/exam-level";
import {
  bangkokToday,
  dailyPracticeUrl,
  loadDailyQuestion,
  toBubbleQuestionData,
} from "@/lib/daily-mcq-line";

export const RICH_MENU_IMAGE_PATH = "/line/rich-menu-main.jpg";
export const RICH_MENU_NAME_PREFIX = "morroo-main";
export const MENU_TODAY_ACTION = "menu_today";

const TODAY_TEXTS = new Set(["ข้อสอบ", "ข้อสอบวันนี้", "today"]);
/** พิมพ์ "ข้อสอบ" / "ข้อสอบวันนี้" = กดปุ่ม ข้อสอบวันนี้ (เทียบตรงตัวหลัง trim/lowercase) */
export function isTodayText(text: string): boolean {
  return TODAY_TEXTS.has(text.trim().toLowerCase());
}

const SITE_URL = (process.env.NEXT_PUBLIC_SITE_URL ?? "https://www.morroo.com").trim();

// แบรนด์พี่น้องในแถบล่าง
const ROODEE_URL = "https://roodee.me/?utm_source=line&utm_medium=morroo_rich_menu";
const PHARMRU_URL = "https://www.pharmru.com/?utm_source=line&utm_medium=morroo_rich_menu";

// ขอบช่องในรูป 2500×1686 — ตรงกับ roodee ทุกพิกเซล
export const COLS = [0, 835, 1664, 2500] as const;
export const ROWS = [0, 724, 1408, 1686] as const;

function area(col: number, row: number, action: Record<string, unknown>) {
  return {
    bounds: {
      x: COLS[col],
      y: ROWS[row],
      width: COLS[col + 1] - COLS[col],
      height: ROWS[row + 1] - ROWS[row],
    },
    action,
  };
}

/** Rich menu object สำหรับ POST /v2/bot/richmenu */
export function buildRichMenu(): Record<string, unknown> & {
  areas: ReturnType<typeof area>[];
} {
  return {
    size: { width: 2500, height: 1686 },
    selected: true,
    name: `${RICH_MENU_NAME_PREFIX}-v1`,
    chatBarText: "เมนูหมอรู้",
    areas: [
      area(0, 0, { type: "postback", data: `action=${MENU_TODAY_ACTION}`, displayText: "ข้อสอบวันนี้" }),
      area(1, 0, { type: "postback", data: "action=level_menu", displayText: "เปลี่ยนระดับสอบ" }),
      // /practice redirects by level (MEQ → /exams, others → /nl/practice)
      area(2, 0, { type: "uri", uri: liffDeepLink("/practice?utm_source=line&utm_medium=rich_menu") }),
      area(0, 1, { type: "uri", uri: liffDeepLink("/dashboard?utm_source=line&utm_medium=rich_menu") }),
      area(1, 1, { type: "uri", uri: liffDeepLink("/nl/calendar?utm_source=line&utm_medium=rich_menu") }),
      area(2, 1, { type: "uri", uri: liffDeepLink("/pricing?utm_source=line&utm_medium=rich_menu") }),
      area(0, 2, { type: "uri", uri: `${SITE_URL}/?utm_source=line&utm_medium=rich_menu` }),
      area(1, 2, { type: "uri", uri: ROODEE_URL }),
      area(2, 2, { type: "uri", uri: PHARMRU_URL }),
    ],
  };
}

const SET_LEVEL_CHIP = {
  items: [
    {
      type: "action" as const,
      action: {
        type: "postback" as const,
        label: "🎯 ตั้งระดับสอบ",
        data: "action=level_menu",
        displayText: "เปลี่ยนระดับ",
      },
    },
  ],
};

/**
 * ปุ่ม "ข้อสอบวันนี้" — การ์ดของระดับผู้ใช้ (ยังไม่ผูกบัญชี = การ์ดผสม ตอบได้เหมือนเดิม).
 * คืน null ถ้าไม่ใช่ action ของไฟล์นี้ — ต่อ chain ใน webhook ด้วย ?? ได้
 */
export async function handleMenuPostback(
  supabase: SupabaseClient,
  lineUserId: string,
  rawData: string
): Promise<LineMessage[] | null> {
  if (parseData(rawData).action !== MENU_TODAY_ACTION) return null;

  // profiles.line_user_id has no unique constraint — take at most one row.
  const { data } = await supabase
    .from("profiles")
    .select("id, target_exam, board_specialty")
    .eq("line_user_id", lineUserId)
    .limit(1);
  const profile =
    (data?.[0] as
      | { id: string; target_exam: string | null; board_specialty: string | null }
      | undefined) ?? null;

  const date = bangkokToday();
  const pool = mcqPoolForTarget(profile?.target_exam, profile?.board_specialty);
  const specialty = pool === "board" ? (profile?.board_specialty ?? null) : null;
  let question = pool ? await loadDailyQuestion(supabase, date, pool, specialty) : null;
  const usedPool = question ? pool : null;
  const usedSpecialty = question ? specialty : null;
  question = question ?? (await loadDailyQuestion(supabase, date));
  if (!question) {
    return [
      {
        type: "text",
        text:
          "วันนี้ยังไม่มีข้อสอบประจำวัน ลองฝึกในเว็บก่อนนะครับ 🙏\n" +
          liffDeepLink("/nl/practice?utm_source=line&utm_medium=rich_menu"),
      },
    ];
  }

  const card = buildDailyMcqFlex({
    question: toBubbleQuestionData(question),
    practiceUrl: dailyPracticeUrl(question.id, date, "rich_menu", usedSpecialty),
    pool: usedPool,
    boardSpecialty: usedSpecialty,
  });
  // ผูกบัญชีแล้วแต่ยังไม่ได้ตั้งระดับตามระบบใหม่ (หรือเป็น Board แต่ยังไม่เลือกสาขา) → ชวนตั้งระดับ
  if (
    profile &&
    (!isExamTarget(profile.target_exam) ||
      (profile.target_exam === "board" && !profile.board_specialty))
  ) {
    return [{ ...card, quickReply: SET_LEVEL_CHIP }];
  }
  return [card];
}

async function lineApi(url: string, init: RequestInit): Promise<Response> {
  const token = (process.env.LINE_CHANNEL_ACCESS_TOKEN ?? "").trim();
  if (!token) throw new Error("LINE_CHANNEL_ACCESS_TOKEN not set");
  const res = await fetch(url, {
    ...init,
    headers: { Authorization: `Bearer ${token}`, ...init.headers },
  });
  if (!res.ok) {
    throw new Error(`${init.method ?? "GET"} ${url} → ${res.status} ${await res.text()}`);
  }
  return res;
}

/**
 * สร้าง rich menu, อัปโหลดรูป, ตั้งเป็น default ให้ทุกคน แล้วลบเมนู
 * morroo-main* อันเก่า. คืน richMenuId ใหม่
 */
export async function installRichMenu(
  image: ArrayBuffer,
  contentType: string
): Promise<{ richMenuId: string; deleted: number }> {
  const created = await lineApi("https://api.line.me/v2/bot/richmenu", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(buildRichMenu()),
  });
  const { richMenuId } = (await created.json()) as { richMenuId: string };

  await lineApi(`https://api-data.line.me/v2/bot/richmenu/${richMenuId}/content`, {
    method: "POST",
    headers: { "Content-Type": contentType },
    body: image,
  });
  await lineApi(`https://api.line.me/v2/bot/user/all/richmenu/${richMenuId}`, { method: "POST" });

  let deleted = 0;
  const list = await lineApi("https://api.line.me/v2/bot/richmenu/list", { method: "GET" });
  const { richmenus = [] } = (await list.json()) as {
    richmenus?: { richMenuId: string; name: string }[];
  };
  for (const m of richmenus) {
    if (m.richMenuId === richMenuId || !m.name.startsWith(RICH_MENU_NAME_PREFIX)) continue;
    try {
      await lineApi(`https://api.line.me/v2/bot/richmenu/${m.richMenuId}`, { method: "DELETE" });
      deleted++;
    } catch (err) {
      console.error("[line-menu] delete old menu failed", m.richMenuId, err);
    }
  }
  return { richMenuId, deleted };
}
