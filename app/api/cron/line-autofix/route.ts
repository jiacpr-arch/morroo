/**
 * Tier-1 LINE-CTA autopilot cron.
 *
 * Reads yesterday's marketing snapshot and adjusts the site-wide LINE CTA
 * level in app_settings (no deploy): boost when click-through is low, step
 * back down once it recovers. Fully reversible — the prior level is kept in
 * app_settings and every change is announced to the admin's LINE.
 *
 * Driven daily by the admin-digest report (which calls runLineCtaAutopilot
 * inline). This route stays as a manual / on-demand trigger — no separate
 * Vercel cron schedule.
 * Auth: dual-mode, matches every other cron route in this repo.
 */

import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { sendLineMessage } from "@/lib/line";
import { buildMarketingSnapshot } from "@/lib/marketing-digest";
import { runLineCtaAutopilot } from "@/lib/line-cta-config";

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

  const supabase = createAdminClient();
  const snapshot = await buildMarketingSnapshot(supabase);
  const { previousLevel, decision } = await runLineCtaAutopilot(supabase, snapshot);

  if (decision.changed) {
    const adminLineId = process.env.ADMIN_LINE_USER_ID;
    if (adminLineId) {
      const arrow = decision.level > previousLevel ? "⬆️ ดันขึ้น" : "⬇️ ลดลง";
      const text =
        `🤖 LINE CTA autopilot (${snapshot.dateLabel})\n` +
        `${arrow} level ${previousLevel} → ${decision.level}\n` +
        `${decision.reason}\n` +
        `(visitors ${snapshot.visitors}, LINE clicks ${snapshot.lineClicks})`;
      await sendLineMessage(adminLineId, [{ type: "text", text }]);
    }
  }

  return NextResponse.json({
    ok: true,
    previousLevel,
    decision,
    snapshot: {
      dateLabel: snapshot.dateLabel,
      visitors: snapshot.visitors,
      lineClicks: snapshot.lineClicks,
    },
  });
}
