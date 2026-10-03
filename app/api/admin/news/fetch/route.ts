// POST — ปุ่ม "ดึงข่าวตอนนี้" ใน /admin/news: รัน runExamNewsFetch ทันที (เหมือน cron). Admin only.

import { NextResponse } from "next/server";
import { requireAdmin } from "@/lib/admin-auth";
import { runExamNewsFetch } from "@/lib/exam-news-fetch";

export const runtime = "nodejs";
export const maxDuration = 120;

export async function POST() {
  const admin = await requireAdmin();
  if (!admin.ok) return admin.response;

  if (!process.env.ANTHROPIC_API_KEY) {
    return NextResponse.json({ error: "ยังไม่ได้ตั้ง ANTHROPIC_API_KEY" }, { status: 500 });
  }
  try {
    const data = await runExamNewsFetch();
    return NextResponse.json({ ok: true, data });
  } catch (err) {
    console.error("[admin/news/fetch]", err);
    return NextResponse.json({ error: "ดึงข่าวไม่สำเร็จ — ดู log" }, { status: 500 });
  }
}
