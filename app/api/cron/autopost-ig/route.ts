/**
 * Daily IG autopost cron.
 *
 * Vercel cron sends `Authorization: Bearer $CRON_SECRET`; manual / external
 * callers may use `?secret=$BLOG_GENERATE_SECRET` (same dual-auth shape as
 * /api/cron/lead-followup).
 *
 * IG rate limits: 1/day soft, 25/day hard. limit=1 keeps us safely under the
 * soft limit and within the Vercel 60s function budget per invocation.
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
    const result = await runAutopostRetry({ platform: "ig", limit: 1 });
    return NextResponse.json(result);
  } catch (err) {
    return NextResponse.json({ error: String(err) }, { status: 500 });
  }
}
