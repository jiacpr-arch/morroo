import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";

// Admin: read/update the (singleton) Q&A Deep page settings row — title,
// intro, cover image. Creates the row on first read if missing.
// Ported from acls-emr's src/services/qaDeepAdminService.js#getPageSettings/updatePageSettings.

export const runtime = "nodejs";

export async function GET() {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  const supabase = createAdminClient();
  const { data, error } = await supabase.from("acls_qa_deep_page").select("*").limit(1).maybeSingle();
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  if (data) return NextResponse.json({ page: data });

  const { data: created, error: insErr } = await supabase
    .from("acls_qa_deep_page")
    .insert({ title: "Q&A ACLS เชิงลึก", intro: "" })
    .select()
    .single();
  if (insErr) return NextResponse.json({ error: insErr.message }, { status: 500 });

  return NextResponse.json({ page: created });
}

export async function PATCH(request: Request) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  let body: { id?: string; title?: string; intro?: string; cover_image_url?: string | null };
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "invalid body" }, { status: 400 });
  }
  if (!body.id) return NextResponse.json({ error: "id required" }, { status: 400 });

  const patch: Record<string, unknown> = { updated_at: new Date().toISOString() };
  if (body.title !== undefined) patch.title = body.title;
  if (body.intro !== undefined) patch.intro = body.intro;
  if (body.cover_image_url !== undefined) patch.cover_image_url = body.cover_image_url;

  const supabase = createAdminClient();
  const { error } = await supabase.from("acls_qa_deep_page").update(patch).eq("id", body.id);
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  return NextResponse.json({ ok: true });
}
