/**
 * Periodic reconciliation job — third fulfillment path.
 *
 * This endpoint covers the one remaining edge case the webhook + success
 * page verify path cannot handle: the user paid AND closed the browser
 * before landing on the success page AND the webhook never arrived.
 *
 * It lists recent Stripe checkout sessions, filters to ones that were
 * paid but do not yet have a corresponding `payment_orders` row, and
 * runs the idempotent fulfillment helper for each. Notifications (LINE,
 * email, FlowAccount) are fired inline because there is no end-user HTTP
 * response to block — cron callers only care about the summary.
 *
 * Authentication (either works):
 *   1) Query string  — `?secret=$BLOG_GENERATE_SECRET`
 *      Matches the existing cron pattern in this codebase and is easy
 *      for external cron runners (cron-job.org, n8n, GitHub Actions).
 *   2) Bearer header — `Authorization: Bearer $CRON_SECRET`
 *      This is how Vercel Cron authenticates automatically — it injects
 *      the header for you when you configure a cron in vercel.json.
 *
 * Supports BOTH GET (Vercel Cron sends GET) and POST (external runners).
 */

import { NextResponse } from "next/server";
import { stripe } from "@/lib/stripe";
import { createAdminClient } from "@/lib/supabase/admin";
import { fulfillCheckoutSession } from "@/lib/billing/fulfill-checkout";
import { sendFulfillmentNotifications } from "@/lib/billing/send-fulfillment-notifications";
import type Stripe from "stripe";

export const runtime = "nodejs";
// Reconciling many sessions can take a while — give Vercel headroom.
export const maxDuration = 300;

// Look back this far when listing Stripe sessions. 2 days gives us
// plenty of slack for a daily cron without returning giant pages.
const LOOKBACK_SECONDS = 2 * 24 * 60 * 60;

// Cap total sessions scanned per run so a bad run can't spin forever.
const MAX_SESSIONS_PER_RUN = 200;

function isAuthorized(request: Request): boolean {
  // 1) Query string secret — matches existing cron endpoints.
  const { searchParams } = new URL(request.url);
  const secret = searchParams.get("secret");
  if (secret && secret === process.env.BLOG_GENERATE_SECRET) return true;

  // 2) Bearer token — Vercel Cron injects this automatically.
  const auth = request.headers.get("authorization");
  if (auth && process.env.CRON_SECRET && auth === `Bearer ${process.env.CRON_SECRET}`) {
    return true;
  }

  return false;
}

async function runReconciliation(request: Request) {
  if (!isAuthorized(request)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const since = Math.floor(Date.now() / 1000) - LOOKBACK_SECONDS;

  const summary = {
    scanned: 0,
    paid: 0,
    alreadyProcessed: 0,
    recovered: 0,
    errors: 0,
  };
  const recoveredSessionIds: string[] = [];

  try {
    // Instantiate the admin client inside the try block — if env vars
    // are misconfigured this would otherwise bubble out as an
    // unstructured 500 instead of a JSON error response.
    const supabase = createAdminClient();

    // Page through checkout sessions created in the lookback window.
    let startingAfter: string | undefined = undefined;
    let keepGoing = true;

    while (keepGoing && summary.scanned < MAX_SESSIONS_PER_RUN) {
      const page: Stripe.ApiList<Stripe.Checkout.Session> =
        await stripe.checkout.sessions.list({
          limit: 100,
          created: { gte: since },
          ...(startingAfter ? { starting_after: startingAfter } : {}),
        });

      for (const session of page.data) {
        summary.scanned++;
        if (summary.scanned >= MAX_SESSIONS_PER_RUN) break;

        if (session.payment_status !== "paid") continue;
        summary.paid++;

        // Fast path: if we already have a payment_order for this session,
        // skip without even calling the helper. This avoids unnecessary
        // Supabase round-trips for the common case (webhook worked fine).
        const { data: existing } = await supabase
          .from("payment_orders")
          .select("id")
          .eq("stripe_session_id", session.id)
          .maybeSingle();

        if (existing) {
          summary.alreadyProcessed++;
          continue;
        }

        // Missing from our DB — run the full idempotent fulfillment.
        try {
          const result = await fulfillCheckoutSession(session);
          if (result.alreadyProcessed) {
            // Race: webhook landed between our SELECT and the helper.
            summary.alreadyProcessed++;
          } else if (result.notify) {
            summary.recovered++;
            recoveredSessionIds.push(session.id);
            // Fire notifications inline — no response to block on here.
            // Each integration has its own try/catch inside the helper.
            await sendFulfillmentNotifications(result.notify);
          }
        } catch (err) {
          summary.errors++;
          console.error(
            `[reconcile] failed to recover session ${session.id}:`,
            err
          );
        }
      }

      if (!page.has_more || page.data.length === 0) {
        keepGoing = false;
      } else {
        startingAfter = page.data[page.data.length - 1].id;
      }
    }

    if (summary.recovered > 0) {
      console.log(
        `[reconcile] recovered ${summary.recovered} session(s):`,
        recoveredSessionIds
      );
    }

    return NextResponse.json({
      ok: true,
      summary,
      recoveredSessionIds,
    });
  } catch (err) {
    const msg = err instanceof Error ? err.message : String(err);
    console.error("[reconcile] fatal error:", msg);
    return NextResponse.json(
      { ok: false, error: msg, summary },
      { status: 500 }
    );
  }
}

// Vercel Cron sends GET. External cron runners typically send POST.
// Both entry points do exactly the same thing.
export async function GET(request: Request) {
  return runReconciliation(request);
}

export async function POST(request: Request) {
  return runReconciliation(request);
}
