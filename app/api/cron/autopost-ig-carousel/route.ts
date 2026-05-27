/**
 * Daily IG carousel autopost cron.
 *
 * Runs 30 min after autopost-ig-story (12:30 ICT) so the feed + story crons
 * drain first — Graph API container creation shares a per-account quota and
 * IG's soft rate limit is ~1 publish/day. Picking up 1 carousel per day on
 * top of feed + story stays well under the 25/day hard cap.
 *
 * Auth: dual-mode (same shape as the other autopost crons).
 */

import { NextResponse } from "next/server";
import { runAutopostRetry } from "@/app/api/autopost/retry/route";

export const runtime = "nodejs";
export const maxDuration = 60;

function isAuthorized(request: Request): boolean {
  const secret = new URL(request.url).searchParams.get("secret");
  if (secret && secret === process.env.BLOG_GENERATE_SECRET) return true;
  const auth = request.headers.get("authorization");
  return Boolean(process.env.CRON_SECRET) && auth === `Bearer ${process.env.CRON_SECRET}`;
}

export async function GET(request: Request) {
  if (!isAuthorized(request)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }
  try {
    const result = await runAutopostRetry({ platform: "ig_carousel", limit: 1 });
    return NextResponse.json(result);
  } catch (err) {
    return NextResponse.json({ error: String(err) }, { status: 500 });
  }
}
