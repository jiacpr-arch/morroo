import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";

// Admin: create a new (blank) Q&A item under a section, appended at the end.
// Ported from acls-emr's src/services/alsAdminService.js#createQa.

export const runtime = "nodejs";

export async function POST(request: Request) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  let body: { sectionId?: string };
  try {
    body = await request.json();
  } catch {
    body = {};
  }
  const sectionId = body.sectionId;
  if (!sectionId) return NextResponse.json({ error: "sectionId required" }, { status: 400 });

  const supabase = createAdminClient();

  const { data: existing, error: countErr } = await supabase
    .from("acls_qa_items")
    .select("sort_order")
    .eq("section_id", sectionId)
    .order("sort_order", { ascending: false })
    .limit(1);
  if (countErr) return NextResponse.json({ error: countErr.message }, { status: 500 });
  const nextOrder = ((existing?.[0] as { sort_order?: number } | undefined)?.sort_order ?? 0) + 1;

  const { data, error } = await supabase
    .from("acls_qa_items")
    .insert({ section_id: sectionId, sort_order: nextOrder, q: "", a: "" })
    .select()
    .single();
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  return NextResponse.json({ item: data });
}
