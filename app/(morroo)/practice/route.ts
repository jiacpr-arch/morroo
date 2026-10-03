// GET /practice — "ฝึกทำข้อสอบ" ตามระดับของผู้ใช้ (ใช้จาก LINE rich menu):
// MEQ + Long case → /exams, ระดับอื่น / ยังไม่ login → /nl/practice. ส่ง query string ต่อ (utm)

import { NextResponse, type NextRequest } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { practicePathForTarget } from "@/lib/exam-level";

export async function GET(request: NextRequest) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  let target: string | null = null;
  if (user) {
    const { data } = await supabase.from("profiles").select("target_exam").eq("id", user.id).single();
    target = (data as { target_exam?: string | null } | null)?.target_exam ?? null;
  }

  const url = new URL(practicePathForTarget(target), request.url);
  url.search = request.nextUrl.search;
  return NextResponse.redirect(url);
}
