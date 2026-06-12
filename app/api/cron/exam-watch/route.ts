/**
 * Exam-watch cron — เฝ้าหน้าข่าว ศรว. (cmathai.org/news) วันละครั้ง
 *
 * เจอบรรทัดประกาศใหม่ (เทียบ snapshot ใน app_settings) → push LINE หา admin
 * เพื่อให้มาอัพเดทกำหนดการสอบใน lib/exam-dates.ts — ปฏิทิน /nl/calendar
 * และแบนเนอร์นับถอยหลังอ่านจากไฟล์นั้นไฟล์เดียว
 *
 * ครั้งแรก (ยังไม่มี snapshot) จะเก็บ baseline เงียบๆ ไม่แจ้งเตือน
 *
 * Schedule via vercel.json: "30 0 * * *" (07:30 เวลาไทย)
 * Auth: Authorization: Bearer $CRON_SECRET (or ?secret=$BLOG_GENERATE_SECRET).
 */

import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { sendLineMessage } from "@/lib/line";
import {
  EXAM_WATCH_SETTINGS_KEY,
  buildAdminAlert,
  diffNewLines,
  extractAnnouncementLines,
} from "@/lib/exam-watch";

export const runtime = "nodejs";
export const maxDuration = 60;

const WATCH_URL = "https://cmathai.org/news";

function isAuthorized(request: Request): boolean {
  const url = new URL(request.url);
  const secret = url.searchParams.get("secret");
  if (secret && secret === process.env.BLOG_GENERATE_SECRET) return true;

  const auth = request.headers.get("authorization");
  if (
    auth &&
    process.env.CRON_SECRET &&
    auth === `Bearer ${process.env.CRON_SECRET}`
  ) {
    return true;
  }
  return false;
}

export async function GET(request: Request) {
  if (!isAuthorized(request)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  let html: string;
  try {
    const res = await fetch(WATCH_URL, {
      headers: {
        "User-Agent":
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0 Safari/537.36",
      },
      signal: AbortSignal.timeout(15_000),
      cache: "no-store",
    });
    if (!res.ok) throw new Error(`status ${res.status}`);
    html = await res.text();
  } catch (e) {
    // เว็บ ศรว. ล่มชั่วคราวไม่ใช่เหตุต้องปลุก admin — log ไว้พอ พรุ่งนี้ลองใหม่
    console.error("[exam-watch] fetch failed:", e);
    return NextResponse.json({ ok: false, error: "fetch failed" });
  }

  const current = extractAnnouncementLines(html);
  if (current.length === 0) {
    // สกัดอะไรไม่ได้เลย = layout เปลี่ยนใหญ่หรือโดน block — อย่าทับ snapshot เดิม
    console.error("[exam-watch] extracted 0 lines — keeping old snapshot");
    return NextResponse.json({ ok: false, error: "no lines extracted" });
  }

  const supabase = createAdminClient();
  const { data: row } = await supabase
    .from("app_settings")
    .select("value")
    .eq("key", EXAM_WATCH_SETTINGS_KEY)
    .maybeSingle();

  let prev: string[] | null = null;
  if (row?.value) {
    try {
      prev = JSON.parse(row.value) as string[];
    } catch {
      prev = null;
    }
  }

  const newLines = prev ? diffNewLines(prev, current) : [];
  let notified = false;

  if (prev && newLines.length > 0) {
    const adminLineId = process.env.ADMIN_LINE_USER_ID;
    if (adminLineId) {
      notified = await sendLineMessage(adminLineId, [
        { type: "text", text: buildAdminAlert(newLines) },
      ]);
    } else {
      console.error("[exam-watch] ADMIN_LINE_USER_ID not set — cannot notify");
    }
  }

  // เก็บ snapshot ใหม่ (รวมบรรทัดเดิมที่หายไปด้วย — หน้า news เป็น feed
  // บรรทัดเก่าตกหน้าได้ ไม่ถือว่าเป็นข่าวใหม่รอบหน้า)
  const merged = prev ? [...new Set([...prev, ...current])].slice(-300) : current;
  const { error: upsertErr } = await supabase.from("app_settings").upsert({
    key: EXAM_WATCH_SETTINGS_KEY,
    value: JSON.stringify(merged),
    updated_at: new Date().toISOString(),
  });
  if (upsertErr) {
    return NextResponse.json({ error: upsertErr.message }, { status: 500 });
  }

  return NextResponse.json({
    ok: true,
    baseline: !prev,
    linesOnPage: current.length,
    newLines,
    notified,
  });
}
