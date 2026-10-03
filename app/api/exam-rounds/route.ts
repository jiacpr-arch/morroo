// GET /api/exam-rounds — รอบสอบ ศรว. สำหรับ banner นับถอยหลัง (client component). Public, cache 10 นาที.

import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { loadExamRounds } from "@/lib/exam-rounds";

export const runtime = "nodejs";

export async function GET() {
  const rounds = await loadExamRounds(createAdminClient());
  return NextResponse.json(
    { rounds },
    { headers: { "Cache-Control": "public, s-maxage=600, stale-while-revalidate=3600" } }
  );
}
