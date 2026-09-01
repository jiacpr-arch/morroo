/**
 * Schedule CRUD for the admin autopost dashboard.
 *
 *   GET    — list scheduled posts (newest first, limit 50)
 *   POST   — create a scheduled post  { slug, platform, scheduledFor }
 *   DELETE — cancel a scheduled post  ?id=<uuid>
 *
 * The /api/cron/autopost-scheduled cron drains pending rows whose
 * scheduled_for has passed.
 */

import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

export const runtime = "nodejs";

const SCHEDULABLE_PLATFORMS = [
  "ig",
  "ig_story",
  "ig_carousel",
  "fb",
  "fb_story",
] as const;
type SchedulablePlatform = (typeof SCHEDULABLE_PLATFORMS)[number];

async function requireAdmin(supabase: Awaited<ReturnType<typeof createClient>>) {
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { ok: false as const, status: 401, error: "Unauthorized" };
  const { data: profile } = await supabase
    .from("profiles")
    .select("role")
    .eq("id", user.id)
    .single();
  if ((profile as { role?: string } | null)?.role !== "admin") {
    return { ok: false as const, status: 403, error: "Admin only" };
  }
  return { ok: true as const, userId: user.id };
}

export async function GET() {
  const supabase = await createClient();
  const auth = await requireAdmin(supabase);
  if (!auth.ok) return NextResponse.json({ error: auth.error }, { status: auth.status });

  const { data, error } = await supabase
    .from("scheduled_autoposts")
    .select("id, slug, platform, scheduled_for, status, result_id, error, created_at, posted_at")
    .order("scheduled_for", { ascending: false })
    .limit(50);

  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  return NextResponse.json({ items: data ?? [] });
}

export async function POST(request: Request) {
  const supabase = await createClient();
  const auth = await requireAdmin(supabase);
  if (!auth.ok) return NextResponse.json({ error: auth.error }, { status: auth.status });

  let body: { slug?: string; platform?: string; scheduledFor?: string } = {};
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "Invalid JSON body" }, { status: 400 });
  }

  const slug = body.slug?.trim();
  const platform = body.platform as SchedulablePlatform | undefined;
  const scheduledForRaw = body.scheduledFor?.trim();

  if (!slug || !platform || !scheduledForRaw) {
    return NextResponse.json(
      { error: "slug, platform, scheduledFor required" },
      { status: 400 },
    );
  }
  if (!SCHEDULABLE_PLATFORMS.includes(platform)) {
    return NextResponse.json({ error: "Invalid platform" }, { status: 400 });
  }

  const when = new Date(scheduledForRaw);
  if (Number.isNaN(when.getTime())) {
    return NextResponse.json({ error: "scheduledFor is not a valid date" }, { status: 400 });
  }
  // Allow 30s slack so an admin scheduling "now" doesn't immediately fail.
  if (when.getTime() < Date.now() - 30_000) {
    return NextResponse.json({ error: "scheduledFor must be in the future" }, { status: 400 });
  }

  // Reject scheduling onto a slug that has no row yet (FK guard makes this
  // explicit instead of a 500 on insert).
  const { data: blogPost, error: blogErr } = await supabase
    .from("blog_posts")
    .select("slug")
    .eq("slug", slug)
    .maybeSingle();
  if (blogErr) return NextResponse.json({ error: blogErr.message }, { status: 500 });
  if (!blogPost) return NextResponse.json({ error: "Unknown slug" }, { status: 404 });

  const { data, error } = await supabase
    .from("scheduled_autoposts")
    .insert({
      slug,
      platform,
      scheduled_for: when.toISOString(),
      status: "pending",
      created_by: auth.userId,
    })
    .select("id, slug, platform, scheduled_for, status, created_at")
    .single();

  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  return NextResponse.json({ item: data });
}

export async function DELETE(request: Request) {
  const supabase = await createClient();
  const auth = await requireAdmin(supabase);
  if (!auth.ok) return NextResponse.json({ error: auth.error }, { status: auth.status });

  const id = new URL(request.url).searchParams.get("id");
  if (!id) return NextResponse.json({ error: "id query param required" }, { status: 400 });

  // Cancel rather than delete — keeps the audit trail intact.
  const { error } = await supabase
    .from("scheduled_autoposts")
    .update({ status: "cancelled" })
    .eq("id", id)
    .eq("status", "pending");

  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  return NextResponse.json({ cancelled: id });
}
