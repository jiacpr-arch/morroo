/**
 * Exam-news-fetch cron — ดึงข่าวสอบแพทย์ (ศรว./แพทยสภา/วุฒิบัตร/แพทย์ใช้ทุน) จาก RSS วันละครั้ง
 * ให้ AI คัด+สรุป แล้วลง news_items ทันที (ดู lib/exam-news-fetch.ts)
 *
 * Schedule via vercel.json: "15 23 * * *" (06:15 เวลาไทย)
 * Auth: Authorization: Bearer $CRON_SECRET (or ?secret=$BLOG_GENERATE_SECRET).
 */

import { NextResponse } from "next/server";
import { withCronRun } from "@/lib/cron-runs";
import { runExamNewsFetch } from "@/lib/exam-news-fetch";

export const runtime = "nodejs";
export const maxDuration = 120;

function isAuthorized(request: Request): boolean {
  const url = new URL(request.url);
  const secret = url.searchParams.get("secret");
  if (secret && secret === process.env.BLOG_GENERATE_SECRET) return true;

  const auth = request.headers.get("authorization");
  return !!(auth && process.env.CRON_SECRET && auth === `Bearer ${process.env.CRON_SECRET}`);
}

async function handleGet(_request: Request) {
  if (!process.env.ANTHROPIC_API_KEY) {
    return NextResponse.json({ ok: false, error: "ANTHROPIC_API_KEY not set" }, { status: 500 });
  }
  const result = await runExamNewsFetch();
  return NextResponse.json({ ok: true, data: result });
}

export const GET = withCronRun("exam-news-fetch", handleGet, { authorize: isAuthorized });
