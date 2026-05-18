/**
 * Session-gated retry endpoint for the admin autopost dashboard.
 *
 * Auth via Supabase session + `profiles.role === "admin"` (same pattern as
 * /api/admin/recommendation-stats), so admins don't need to know
 * BLOG_GENERATE_SECRET to click "Retry" in the UI.
 */

import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { runAutopostRetry, type AutopostPlatform } from "@/app/api/autopost/retry/route";

export const runtime = "nodejs";
export const maxDuration = 60;

const ALLOWED_PLATFORMS: AutopostPlatform[] = [
  "fb",
  "line",
  "ig",
  "fb_story",
  "ig_story",
  "stories",
  "both",
  "all",
];

export async function POST(request: Request) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const { data: profile } = await supabase
    .from("profiles")
    .select("role")
    .eq("id", user.id)
    .single();

  if ((profile as { role?: string } | null)?.role !== "admin") {
    return NextResponse.json({ error: "Admin only" }, { status: 403 });
  }

  let body: { slug?: string; platform?: string } = {};
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "Invalid JSON body" }, { status: 400 });
  }

  const platform = body.platform as AutopostPlatform | undefined;
  if (!platform || !ALLOWED_PLATFORMS.includes(platform)) {
    return NextResponse.json({ error: "Invalid platform" }, { status: 400 });
  }

  try {
    const result = await runAutopostRetry({
      platform,
      limit: 1,
      slug: body.slug ?? null,
    });
    return NextResponse.json(result);
  } catch (err) {
    return NextResponse.json({ error: String(err) }, { status: 500 });
  }
}
