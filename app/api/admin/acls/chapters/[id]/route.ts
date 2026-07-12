import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";

// Admin: full chapter detail (sections, each with nested Q&A items and
// images) for the chapter editor page, plus PATCH for chapter meta
// (title/icon only — chapters aren't created/deleted here).
// Ported from acls-emr's src/services/alsAdminService.js#getChapterFull/updateChapter.

export const runtime = "nodejs";

export async function GET(
  _request: Request,
  { params }: { params: Promise<{ id: string }> },
) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;
  const { id } = await params;

  const supabase = createAdminClient();

  const [cRes, sRes] = await Promise.all([
    supabase.from("acls_chapters").select("*").eq("id", id).maybeSingle(),
    supabase.from("acls_sections").select("*").eq("chapter_id", id).order("sort_order"),
  ]);
  if (cRes.error) return NextResponse.json({ error: cRes.error.message }, { status: 500 });
  if (!cRes.data) return NextResponse.json({ error: "not found" }, { status: 404 });
  if (sRes.error) return NextResponse.json({ error: sRes.error.message }, { status: 500 });

  const sections = (sRes.data ?? []) as { id: string }[];
  const sectionIds = sections.map((s) => s.id);

  let qaItems: { id: string; section_id: string }[] = [];
  let images: { id: string; parent_type: string; parent_id: string }[] = [];
  if (sectionIds.length) {
    const qRes = await supabase
      .from("acls_qa_items")
      .select("*")
      .in("section_id", sectionIds)
      .order("sort_order");
    if (qRes.error) return NextResponse.json({ error: qRes.error.message }, { status: 500 });
    qaItems = (qRes.data ?? []) as typeof qaItems;

    const qaIds = qaItems.map((q) => q.id);
    const parentIds = [...sectionIds, ...qaIds];
    if (parentIds.length) {
      const iRes = await supabase
        .from("acls_images")
        .select("*")
        .in("parent_id", parentIds)
        .order("sort_order");
      if (iRes.error) return NextResponse.json({ error: iRes.error.message }, { status: 500 });
      images = (iRes.data ?? []) as typeof images;
    }
  }

  const qaBySection = new Map<string, unknown[]>();
  for (const q of qaItems as Record<string, unknown>[]) {
    const sectionId = q.section_id as string;
    const arr = qaBySection.get(sectionId) ?? [];
    arr.push({
      ...q,
      images: images.filter((i) => i.parent_type === "qa" && i.parent_id === (q.id as string)),
    });
    qaBySection.set(sectionId, arr);
  }

  const chapter = {
    ...(cRes.data as Record<string, unknown>),
    sections: sections.map((s) => ({
      ...(s as Record<string, unknown>),
      images: images.filter((i) => i.parent_type === "section" && i.parent_id === s.id),
      qa: qaBySection.get(s.id) ?? [],
    })),
  };

  return NextResponse.json({ chapter });
}

export async function PATCH(
  request: Request,
  { params }: { params: Promise<{ id: string }> },
) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;
  const { id } = await params;

  let body: { title?: string; icon?: string };
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "invalid body" }, { status: 400 });
  }

  const patch: Record<string, unknown> = {};
  if (body.title !== undefined) patch.title = body.title;
  if (body.icon !== undefined) patch.icon = body.icon;

  const supabase = createAdminClient();
  const { error } = await supabase.from("acls_chapters").update(patch).eq("id", id);
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  return NextResponse.json({ ok: true });
}
