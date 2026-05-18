/**
 * Daily IG story autopost cron.
 *
 * Runs 1 hour after /api/cron/autopost-ig so the feed publish drains first.
 * IG Story rate limits are independent from feed limits but Graph API
 * container-creation calls share a quota, so spacing them out avoids
 * unnecessary contention.
 *
 * Auth: dual-mode (same shape as /api/cron/autopost-ig and
 * /api/cron/lead-followup).
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
    const result = await runAutopostRetry({ platform: "ig_story", limit: 1 });
    return NextResponse.json(result);
  } catch (err) {
    return NextResponse.json({ error: String(err) }, { status: 500 });
  }
}
