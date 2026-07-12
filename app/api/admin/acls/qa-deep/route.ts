import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";

// Admin: list all Q&A Deep items (with their cover/infographic images) and
// create a new blank item (appended at the end, optionally pre-assigned to
// a chapter). Ported from acls-emr's
// src/services/qaDeepAdminService.js#listQaItemsFull/createQaItem.

export const runtime = "nodejs";

export async function GET() {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  const supabase = createAdminClient();
  const { data: items, error } = await supabase
    .from("acls_qa_deep_items")
    .select("id, chapter_id, question, answer, sort_order, updated_at")
    .order("sort_order");
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  if (!items || items.length === 0) return NextResponse.json({ items: [] });

  const ids = items.map((i) => (i as { id: string }).id);
  const { data: images, error: imgErr } = await supabase
    .from("acls_qa_deep_images")
    .select("*")
    .in("item_id", ids)
    .order("sort_order");
  if (imgErr) return NextResponse.json({ error: imgErr.message }, { status: 500 });

  const byItem = new Map<string, unknown[]>();
  for (const img of (images ?? []) as { item_id: string }[]) {
    const arr = byItem.get(img.item_id) ?? [];
    arr.push(img);
    byItem.set(img.item_id, arr);
  }

  const full = items.map((it) => ({
    ...(it as Record<string, unknown>),
    images: byItem.get((it as { id: string }).id) ?? [],
  }));

  return NextResponse.json({ items: full });
}

export async function POST(request: Request) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  let body: { chapterId?: string | null };
  try {
    body = await request.json();
  } catch {
    body = {};
  }

  const supabase = createAdminClient();

  const { data: existing, error: countErr } = await supabase
    .from("acls_qa_deep_items")
    .select("sort_order")
    .order("sort_order", { ascending: false })
    .limit(1);
  if (countErr) return NextResponse.json({ error: countErr.message }, { status: 500 });
  const nextOrder = ((existing?.[0] as { sort_order?: number } | undefined)?.sort_order ?? 0) + 1;

  const { data, error } = await supabase
    .from("acls_qa_deep_items")
    .insert({ sort_order: nextOrder, question: "", answer: "", chapter_id: body.chapterId || null })
    .select()
    .single();
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  return NextResponse.json({ item: data });
}
