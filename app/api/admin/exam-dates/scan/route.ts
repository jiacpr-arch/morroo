import { NextResponse } from "next/server";
import { requireAdmin } from "@/lib/admin-auth";
import { createAdminClient } from "@/lib/supabase/admin";
import { scanExamAnnouncements } from "@/lib/exam-round-scan";

export const runtime = "nodejs";
export const maxDuration = 300;

/** สแกนประกาศ ศรว. ตอนนี้ (ไม่ดูว่าเคยอ่านลิงก์แล้วหรือยัง) แล้วคืนรายงานละเอียด */
export async function POST() {
  const auth = await requireAdmin();
  if (!auth.ok) return auth.response;
  if (!process.env.ANTHROPIC_API_KEY) {
    return NextResponse.json({ error: "ยังไม่ได้ตั้ง ANTHROPIC_API_KEY" }, { status: 500 });
  }
  try {
    const report = await scanExamAnnouncements(createAdminClient(), {
      force: true,
      maxPages: 5,
      alert: false,
    });
    return NextResponse.json({ ok: true, report });
  } catch (err) {
    return NextResponse.json({ error: err instanceof Error ? err.message : String(err) }, { status: 500 });
  }
}
