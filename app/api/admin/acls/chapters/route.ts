import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";

// Admin: list ACLS chapters with section counts. Chapters are seeded content
// (fixed set of ids) — this admin surface only edits title/icon, it does not
// create/delete chapters (matches acls-emr's AdminChapters.jsx, which has no
// "add chapter" affordance either).
// Ported from acls-emr's src/services/alsAdminService.js#listChaptersWithCounts.

export const runtime = "nodejs";

interface ChapterRow {
  id: string;
  title: string;
  icon: string | null;
  sort_order: number;
  updated_at: string;
  acls_sections: { count: number }[] | null;
}

export async function GET() {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  const supabase = createAdminClient();
  const { data, error } = await supabase
    .from("acls_chapters")
    .select("id, title, icon, sort_order, updated_at, acls_sections(count)")
    .order("sort_order");
  if (error) {
    console.error("list chapters failed:", error.message);
    return NextResponse.json({ error: "Failed to load chapters" }, { status: 500 });
  }

  const chapters = ((data ?? []) as ChapterRow[]).map((c) => ({
    id: c.id,
    title: c.title,
    icon: c.icon,
    sort_order: c.sort_order,
    updated_at: c.updated_at,
    sectionCount: c.acls_sections?.[0]?.count ?? 0,
  }));
  return NextResponse.json({ chapters });
}
