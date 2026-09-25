import { NextRequest, NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";
import { TRIAL_DURATION_DAYS } from "@/lib/redeem";
import {
  computeTrialConversion,
  summarizeFeedback,
  type FeedbackRow,
  type PaidOrder,
  type TrialStart,
} from "@/lib/winback";

export const runtime = "nodejs";

/**
 * GET /api/admin/winback?days=30
 *
 * Admin-only. Over the window:
 * - lapse survey answers (cancellation_feedback): reasons breakdown, offers
 *   shown / accepted / redeemed at checkout, recent free-text answers
 * - trial → paid conversion: 7-day trials started (redeem_codes monthly_1m)
 *   vs first approved payment_orders row on/after the trial start
 */

const PAGE = 1000;
const IN_CHUNK = 200;

type AdminClient = ReturnType<typeof createAdminClient>;

function chunks<T>(list: T[], size: number): T[][] {
  const out: T[][] = [];
  for (let i = 0; i < list.length; i += size) out.push(list.slice(i, i + size));
  return out;
}

async function fetchTrials(admin: AdminClient, since: string): Promise<TrialStart[]> {
  const out: TrialStart[] = [];
  for (let from = 0; ; from += PAGE) {
    const { data, error } = await admin
      .from("redeem_codes")
      .select("redeemed_by, redeemed_at")
      .eq("reward_type", "monthly_1m")
      .not("redeemed_at", "is", null)
      .gte("redeemed_at", since)
      .order("redeemed_at", { ascending: true })
      .range(from, from + PAGE - 1);
    if (error) throw new Error(error.message);
    for (const r of data ?? []) {
      if (r.redeemed_by && r.redeemed_at) out.push({ userId: r.redeemed_by, startedAt: r.redeemed_at });
    }
    if (!data || data.length < PAGE) break;
  }
  return out;
}

async function fetchPaidOrders(admin: AdminClient, userIds: string[], since: string): Promise<PaidOrder[]> {
  const out: PaidOrder[] = [];
  for (const ids of chunks(userIds, IN_CHUNK)) {
    const { data, error } = await admin
      .from("payment_orders")
      .select("user_id, created_at")
      .eq("status", "approved")
      .in("user_id", ids)
      .gte("created_at", since);
    if (error) throw new Error(error.message);
    for (const r of data ?? []) out.push({ userId: r.user_id, paidAt: r.created_at });
  }
  return out;
}

export async function GET(request: NextRequest) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  const daysParam = Number(request.nextUrl.searchParams.get("days") ?? "30");
  const days = Number.isFinite(daysParam) ? Math.min(Math.max(Math.round(daysParam), 1), 365) : 30;
  const since = new Date(Date.now() - days * 86_400_000).toISOString();
  const admin = createAdminClient();

  try {
    const { data: rows, error } = await admin
      .from("cancellation_feedback")
      .select(
        "id, created_at, source, last_plan, was_trial, reason, reason_detail, offer_kind, offer_percent, offer_coupon_id, offer_response"
      )
      .gte("created_at", since)
      .order("created_at", { ascending: false })
      .limit(5000);
    if (error) throw new Error(error.message);

    const feedback = rows ?? [];
    const couponIds = feedback
      .map((r) => r.offer_coupon_id as string | null)
      .filter((id): id is string => !!id);
    const redeemed = new Set<string>();
    for (const ids of chunks(couponIds, IN_CHUNK)) {
      const { data } = await admin.from("coupon_redemptions").select("coupon_id").in("coupon_id", ids);
      for (const r of data ?? []) if (r.coupon_id) redeemed.add(r.coupon_id as string);
    }

    const summary = summarizeFeedback(
      feedback.map(
        (r): FeedbackRow => ({
          reason: r.reason,
          offer_kind: r.offer_kind,
          offer_response: r.offer_response,
          was_trial: r.was_trial,
          source: r.source,
          redeemed: !!r.offer_coupon_id && redeemed.has(r.offer_coupon_id),
        })
      )
    );

    const recent = feedback
      .filter((r) => r.reason_detail)
      .slice(0, 30)
      .map((r) => ({
        created_at: r.created_at,
        reason: r.reason,
        reason_detail: r.reason_detail,
        was_trial: r.was_trial,
        last_plan: r.last_plan,
        offer_response: r.offer_response,
      }));

    const trials = await fetchTrials(admin, since);
    const orders = await fetchPaidOrders(admin, [...new Set(trials.map((t) => t.userId))], since);
    const conversion = computeTrialConversion(trials, orders, TRIAL_DURATION_DAYS);

    return NextResponse.json({ days, summary, recent, conversion });
  } catch (err) {
    const msg = err instanceof Error ? err.message : String(err);
    console.error("[admin/winback]", msg);
    return NextResponse.json({ error: msg }, { status: 500 });
  }
}
