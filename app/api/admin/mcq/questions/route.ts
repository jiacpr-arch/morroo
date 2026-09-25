import { NextRequest, NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";
import {
  MCQ_ADMIN_VIEWS,
  isMcqAdminListView,
  isMcqStatus,
  parseMcqAdminListFilters,
  pickWritableMcqFields,
} from "@/lib/mcq-admin-api";

// Admin MCQ bank — service role เท่านั้น เพราะคอลัมน์เฉลยของ mcq_questions ถูก
// revoke จาก anon/authenticated (supabase/migrations/20260927_hide_mcq_answers.sql)
// หน้า admin ในเบราว์เซอร์จึงอ่าน/เขียนผ่าน route นี้แทน supabase client
// (ดู lib/supabase/mutations-mcq-admin.ts)

// GET /api/admin/mcq/questions?view=list|export|review|answer
//   &status=&audience=&exam_source=&subject_id=&board_specialty=&board_section=
//   &missing_detailed=1&order=asc|desc&offset=&limit=(≤1000)
// → { rows }
export async function GET(request: NextRequest) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  const params = request.nextUrl.searchParams;
  const view = params.get("view");
  if (!isMcqAdminListView(view)) {
    return NextResponse.json({ error: "view ไม่ถูกต้อง" }, { status: 400 });
  }
  const f = parseMcqAdminListFilters(params);

  const admin = createAdminClient();
  let q = admin
    .from("mcq_questions")
    .select(MCQ_ADMIN_VIEWS[view])
    .order("created_at", { ascending: f.order === "asc" })
    .range(f.offset, f.offset + f.limit - 1);
  if (f.status) q = q.eq("status", f.status);
  if (f.audience) q = q.eq("audience", f.audience);
  if (f.exam_source) q = q.eq("exam_source", f.exam_source);
  if (f.subject_id) q = q.eq("subject_id", f.subject_id);
  if (f.board_specialty) q = q.eq("board_specialty", f.board_specialty);
  if (f.board_section) q = q.eq("board_section", f.board_section);
  if (f.missing_detailed) q = q.is("detailed_explanation", null);

  const { data, error } = await q;
  if (error) {
    console.error("[admin/mcq/questions] list error:", error);
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
  return NextResponse.json({ rows: data ?? [] }, { headers: { "Cache-Control": "no-store" } });
}

// POST /api/admin/mcq/questions  Body: McqQuestionInput → { id }
export async function POST(request: NextRequest) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "Invalid JSON body" }, { status: 400 });
  }
  const row = pickWritableMcqFields(body);
  if (!row || typeof row.scenario !== "string" || typeof row.subject_id !== "string") {
    return NextResponse.json({ error: "ข้อมูลข้อสอบไม่ครบ" }, { status: 400 });
  }

  const admin = createAdminClient();
  const { data, error } = await admin.from("mcq_questions").insert(row).select("id").single();
  if (error || !data) {
    console.error("[admin/mcq/questions] create error:", error);
    return NextResponse.json({ error: error?.message ?? "สร้างข้อสอบไม่สำเร็จ" }, { status: 500 });
  }
  return NextResponse.json({ id: (data as { id: string }).id });
}

// PATCH /api/admin/mcq/questions  Body: { ids: string[], status } → { ok, failed }
export async function PATCH(request: NextRequest) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  let body: { ids?: unknown; status?: unknown };
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "Invalid JSON body" }, { status: 400 });
  }
  const ids = Array.isArray(body?.ids)
    ? body.ids.filter((x): x is string => typeof x === "string" && x.length > 0)
    : [];
  if (ids.length === 0 || ids.length > 5000 || !isMcqStatus(body?.status)) {
    return NextResponse.json({ error: "ids / status ไม่ถูกต้อง" }, { status: 400 });
  }

  const admin = createAdminClient();
  const { error, count } = await admin
    .from("mcq_questions")
    .update({ status: body.status }, { count: "exact" })
    .in("id", ids);
  if (error) {
    console.error("[admin/mcq/questions] bulk status error:", error);
    return NextResponse.json({ ok: 0, failed: ids.length, error: error.message }, { status: 500 });
  }
  const ok = count ?? ids.length;
  return NextResponse.json({ ok, failed: ids.length - ok });
}
