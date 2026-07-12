import { NextResponse } from "next/server";
import { requireAdmin } from "@/lib/admin-auth";
import { createAdminClient } from "@/lib/supabase/admin";
import { SIM_SCENARIOS } from "@/lib/sim/scenarios";
import { describeScenarioError } from "@/lib/sim/validate";

export const runtime = "nodejs";

type Ctx = { params: Promise<{ id: string }> };

const STATUSES = ["draft", "published", "archived"] as const;
const BUILTIN_SLUGS = new Set(SIM_SCENARIOS.map((s) => s.slug));

export async function GET(_request: Request, context: Ctx) {
  const auth = await requireAdmin();
  if (!auth.ok) return auth.response;
  const { id } = await context.params;

  const admin = createAdminClient();
  const { data, error } = await admin
    .from("sim_scenarios")
    .select("*")
    .eq("id", id)
    .maybeSingle();
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  if (!data) return NextResponse.json({ error: "ไม่พบเคสนี้" }, { status: 404 });
  return NextResponse.json({ scenario: data });
}

export async function PATCH(request: Request, context: Ctx) {
  const auth = await requireAdmin();
  if (!auth.ok) return auth.response;
  const { id } = await context.params;

  let body: Record<string, unknown>;
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "Invalid JSON" }, { status: 400 });
  }

  const allowedKeys = ["slug", "title", "subtitle", "difficulty_tag", "status", "story"] as const;
  const update: Record<string, unknown> = {};
  for (const key of allowedKeys) {
    if (key in body) update[key] = body[key];
  }
  if (Object.keys(update).length === 0) {
    return NextResponse.json({ error: "ไม่มีข้อมูลให้แก้ไข" }, { status: 400 });
  }
  if (update.status && !STATUSES.includes(update.status as (typeof STATUSES)[number])) {
    return NextResponse.json({ error: "status ไม่ถูกต้อง" }, { status: 400 });
  }
  if (typeof update.slug === "string" && BUILTIN_SLUGS.has(update.slug)) {
    return NextResponse.json(
      { error: `slug "${update.slug}" ซ้ำกับเคส built-in — ใช้ชื่ออื่น` },
      { status: 409 },
    );
  }

  const admin = createAdminClient();

  // ถ้าแตะ slug/title/story ต้อง validate โจทย์เต็มด้วยค่าที่ merge แล้ว
  if ("story" in update || "slug" in update || "title" in update) {
    const { data: current } = await admin
      .from("sim_scenarios")
      .select("slug, title, subtitle, difficulty_tag, story")
      .eq("id", id)
      .maybeSingle();
    if (!current) return NextResponse.json({ error: "ไม่พบเคสนี้" }, { status: 404 });
    const merged = {
      slug: (update.slug ?? current.slug) as string,
      title: (update.title ?? current.title) as string,
      subtitle: (update.subtitle ?? current.subtitle ?? "") as string,
      difficultyTag: (update.difficulty_tag ?? current.difficulty_tag ?? "basic") as string,
      story: update.story ?? current.story,
    };
    const { data: dbChars } = await admin
      .from("sim_characters")
      .select("slug")
      .eq("status", "active");
    const invalid = describeScenarioError(merged, (dbChars ?? []).map((c) => c.slug));
    if (invalid) return NextResponse.json({ error: invalid }, { status: 400 });
  }

  update.updated_at = new Date().toISOString();
  const { data, error } = await admin
    .from("sim_scenarios")
    .update(update)
    .eq("id", id)
    .select("id, status")
    .single();
  if (error) {
    if (error.code === "23505") {
      return NextResponse.json({ error: "slug นี้มีอยู่แล้ว" }, { status: 409 });
    }
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
  return NextResponse.json({ scenario: data });
}

export async function DELETE(_request: Request, context: Ctx) {
  const auth = await requireAdmin();
  if (!auth.ok) return auth.response;
  const { id } = await context.params;

  const admin = createAdminClient();
  const { error } = await admin.from("sim_scenarios").delete().eq("id", id);
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  return NextResponse.json({ ok: true });
}
