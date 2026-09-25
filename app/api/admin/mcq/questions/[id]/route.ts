import { NextRequest, NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";
import { isUuid } from "@/lib/school/ids";
import { MCQ_ADMIN_VIEWS, pickWritableMcqFields } from "@/lib/mcq-admin-api";

// GET /api/admin/mcq/questions/[id] → { question } (รวมเฉลย — service role)
export async function GET(
  _request: NextRequest,
  context: { params: Promise<{ id: string }> },
) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;
  const { id } = await context.params;
  if (!isUuid(id)) return NextResponse.json({ error: "id ไม่ถูกต้อง" }, { status: 400 });

  const admin = createAdminClient();
  const { data, error } = await admin
    .from("mcq_questions")
    .select(MCQ_ADMIN_VIEWS.detail)
    .eq("id", id)
    .maybeSingle();
  if (error) {
    console.error("[admin/mcq/questions/id] get error:", error);
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
  if (!data) return NextResponse.json({ error: "ไม่พบข้อสอบ" }, { status: 404 });
  return NextResponse.json({ question: data }, { headers: { "Cache-Control": "no-store" } });
}

// PATCH /api/admin/mcq/questions/[id]  Body: Partial<McqQuestionInput> → { ok: true }
export async function PATCH(
  request: NextRequest,
  context: { params: Promise<{ id: string }> },
) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;
  const { id } = await context.params;
  if (!isUuid(id)) return NextResponse.json({ error: "id ไม่ถูกต้อง" }, { status: 400 });

  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "Invalid JSON body" }, { status: 400 });
  }
  const patch = pickWritableMcqFields(body);
  if (!patch) return NextResponse.json({ error: "ไม่มีข้อมูลที่จะแก้ไข" }, { status: 400 });

  const admin = createAdminClient();
  const { error } = await admin.from("mcq_questions").update(patch).eq("id", id);
  if (error) {
    console.error("[admin/mcq/questions/id] update error:", error);
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
  return NextResponse.json({ ok: true });
}
