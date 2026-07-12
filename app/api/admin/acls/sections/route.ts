import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";

// Admin: create a new (blank) section under a chapter, appended at the end.
// Ported from acls-emr's src/services/alsAdminService.js#createSection.

export const runtime = "nodejs";

export async function POST(request: Request) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  let body: { chapterId?: string };
  try {
    body = await request.json();
  } catch {
    body = {};
  }
  const chapterId = body.chapterId;
  if (!chapterId) return NextResponse.json({ error: "chapterId required" }, { status: 400 });

  const supabase = createAdminClient();

  const { data: existing, error: countErr } = await supabase
    .from("acls_sections")
    .select("sort_order")
    .eq("chapter_id", chapterId)
    .order("sort_order", { ascending: false })
    .limit(1);
  if (countErr) return NextResponse.json({ error: countErr.message }, { status: 500 });
  const nextOrder = ((existing?.[0] as { sort_order?: number } | undefined)?.sort_order ?? 0) + 1;

  const { data, error } = await supabase
    .from("acls_sections")
    .insert({ chapter_id: chapterId, sort_order: nextOrder, heading: "", body: "" })
    .select()
    .single();
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  return NextResponse.json({ section: data });
}
