/**
 * Drain pending scheduled_autoposts whose scheduled_for has passed.
 *
 * Runs every 15 minutes. Picks the oldest 5 pending rows, posts each via
 * the existing runAutopostRetry pipeline, then updates the row with result
 * or error. Limit of 5 keeps the cron inside Vercel's 60 s maxDuration even
 * if a Reel transcode poll burns ~40 s.
 *
 * Auth: same dual-mode as /api/cron/autopost-ig.
 */

import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import {
  runAutopostRetry,
  type AutopostPlatform,
} from "@/app/api/autopost/retry/route";

export const runtime = "nodejs";
export const maxDuration = 60;

function isAuthorized(request: Request): boolean {
  const secret = new URL(request.url).searchParams.get("secret");
  if (secret && secret === process.env.BLOG_GENERATE_SECRET) return true;
  const auth = request.headers.get("authorization");
  return Boolean(process.env.CRON_SECRET) && auth === `Bearer ${process.env.CRON_SECRET}`;
}

interface ScheduledRow {
  id: string;
  slug: string;
  platform: string;
}

export async function GET(request: Request) {
  if (!isAuthorized(request)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const supabase = createAdminClient();

  const { data: pending, error } = await supabase
    .from("scheduled_autoposts")
    .select("id, slug, platform")
    .eq("status", "pending")
    .lte("scheduled_for", new Date().toISOString())
    .order("scheduled_for", { ascending: true })
    .limit(5);

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
  if (!pending?.length) {
    return NextResponse.json({ processed: 0, message: "No pending scheduled posts" });
  }

  const results: Array<{ id: string; status: string; detail?: string }> = [];

  for (const row of pending as ScheduledRow[]) {
    try {
      const platform = row.platform as AutopostPlatform;
      const result = await runAutopostRetry({
        platform,
        slug: row.slug,
        limit: 1,
      });
      const first = result.results[0];
      // Extract whichever platform field was populated by the runner.
      const platformField =
        first?.[platform as keyof typeof first] as string | undefined;
      const posted = platformField?.startsWith("posted:");
      const resultId = posted ? platformField!.slice("posted:".length) : null;
      const errorText = !posted ? (platformField ?? "no_result") : null;

      await supabase
        .from("scheduled_autoposts")
        .update({
          status: posted ? "posted" : "failed",
          result_id: resultId,
          error: errorText?.slice(0, 500) ?? null,
          posted_at: new Date().toISOString(),
        })
        .eq("id", row.id);

      results.push({
        id: row.id,
        status: posted ? "posted" : "failed",
        detail: platformField,
      });
    } catch (err) {
      await supabase
        .from("scheduled_autoposts")
        .update({
          status: "failed",
          error: String(err).slice(0, 500),
          posted_at: new Date().toISOString(),
        })
        .eq("id", row.id);
      results.push({ id: row.id, status: "failed", detail: String(err).slice(0, 200) });
    }
  }

  return NextResponse.json({ processed: results.length, results });
}
