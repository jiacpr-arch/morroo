import { NextRequest, NextResponse } from "next/server";
import { requireAdmin } from "@/lib/admin-auth";
import { createAdminClient } from "@/lib/supabase/admin";
import { SIM_SCENARIOS } from "@/lib/sim/scenarios";
import { describeScenarioError } from "@/lib/sim/validate";

export const runtime = "nodejs";

const STATUSES = ["draft", "published", "archived"] as const;
const BUILTIN_SLUGS = new Set(SIM_SCENARIOS.map((s) => s.slug));

export async function GET(request: NextRequest) {
  const auth = await requireAdmin();
  if (!auth.ok) return auth.response;

  const status = request.nextUrl.searchParams.get("status");
  const admin = createAdminClient();
  let query = admin
    .from("sim_scenarios")
    // ไม่ส่ง story ในลิสต์ — jsonb ใหญ่
    .select("id, slug, title, subtitle, difficulty_tag, status, source, created_at, updated_at")
    .order("updated_at", { ascending: false })
    .limit(200);
  if (status && STATUSES.includes(status as (typeof STATUSES)[number])) {
    query = query.eq("status", status);
  }
  const { data, error } = await query;
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  return NextResponse.json({ scenarios: data ?? [] });
}

export async function POST(request: Request) {
  const auth = await requireAdmin();
  if (!auth.ok) return auth.response;

  let body: {
    slug?: string;
    title?: string;
    subtitle?: string;
    difficultyTag?: string;
    status?: string;
    story?: unknown;
    source?: string;
  };
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "Invalid JSON" }, { status: 400 });
  }

  const scenario = {
    slug: body.slug?.trim() ?? "",
    title: body.title?.trim() ?? "",
    subtitle: body.subtitle?.trim() ?? "",
    difficultyTag: body.difficultyTag?.trim() || "basic",
    story: body.story,
  };

  const invalid = describeScenarioError(scenario);
  if (invalid) return NextResponse.json({ error: invalid }, { status: 400 });

  // slug ชนกับเคส built-in จะโดน shadow โดย queries-sim (built-in ชนะเสมอ)
  if (BUILTIN_SLUGS.has(scenario.slug)) {
    return NextResponse.json(
      { error: `slug "${scenario.slug}" ซ้ำกับเคส built-in — ใช้ชื่ออื่น` },
      { status: 409 },
    );
  }

  const status = STATUSES.includes(body.status as (typeof STATUSES)[number])
    ? body.status
    : "draft";
  const source = body.source === "ai" ? "ai" : "manual";

  const admin = createAdminClient();
  const { data, error } = await admin
    .from("sim_scenarios")
    .insert({
      slug: scenario.slug,
      title: scenario.title,
      subtitle: scenario.subtitle || null,
      difficulty_tag: scenario.difficultyTag,
      status,
      story: scenario.story,
      source,
      created_by: auth.userId,
    })
    .select("id")
    .single();
  if (error) {
    if (error.code === "23505") {
      return NextResponse.json({ error: `slug "${scenario.slug}" มีอยู่แล้ว` }, { status: 409 });
    }
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
  return NextResponse.json({ id: data.id });
}
