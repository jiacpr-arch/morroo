/**
 * Lapse survey + win-back offer ("ไม่ต่ออายุ") — see lib/winback.ts.
 *
 * GET   /api/winback  → { eligible, wasTrial, lastPlan, expiresAt, existing }
 * POST  /api/winback  { reason, detail?, source? } → { id, offer }
 *       Records the answer in cancellation_feedback and issues the tailored
 *       offer (a single-use discount coupon when the reason calls for one).
 *       One offer per lapse (cancellation_feedback is unique on
 *       (user_id, access_expires_at)) and at most one new offer per
 *       WINBACK_COOLDOWN_DAYS — otherwise the previous offer is returned.
 *       Only open from LAPSE_WINDOW_DAYS before to LAPSE_AFTER_DAYS after
 *       the expiry; the coupon is restricted to this user.
 * PATCH /api/winback  { id, response: "accepted" | "declined" }
 *
 * Plans are one-time purchases, so there's nothing to cancel in Stripe —
 * "declined" just means the member confirmed they're not renewing.
 */

import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { planLabel } from "@/lib/membership";
import {
  canIssueWinback,
  isLapseEligible,
  isLapseReason,
  isSameLapse,
  parseLapseSource,
  sanitizeReasonDetail,
  selectWinbackOffer,
  type LapseReason,
  type WinbackOfferView,
} from "@/lib/winback";
import {
  FEEDBACK_COLUMNS,
  deactivateCoupon,
  getFeedbackForLapse,
  getLapseState,
  getLatestFeedback,
  hasActiveOrgAccess,
  issueWinbackCoupon,
  type FeedbackRecord,
  type LapseState,
} from "@/lib/winback-server";

export const runtime = "nodejs";

function toView(row: FeedbackRecord, wasTrial: boolean): WinbackOfferView {
  const reason: LapseReason = isLapseReason(row.reason) ? row.reason : "other";
  const rule = selectWinbackOffer(reason, { wasTrial, lastPlan: row.offer_plan });
  if (row.offer_kind === "discount" && row.offer_coupon_code && row.offer_plan) {
    const percent = row.offer_percent ?? (rule.kind === "discount" ? rule.percent : 0);
    return {
      kind: "discount",
      headline: rule.kind === "discount" ? rule.headline : `ส่วนลด ${percent}%`,
      body: rule.kind === "discount" ? rule.body : "",
      percent,
      planLabel: planLabel(row.offer_plan),
      code: row.offer_coupon_code,
      expiresAt: row.offer_expires_at,
      ctaHref: `/payment/${encodeURIComponent(row.offer_plan)}?coupon=${encodeURIComponent(row.offer_coupon_code)}`,
      ctaLabel: "ต่ออายุด้วยโค้ดนี้",
    };
  }
  const none =
    rule.kind === "none"
      ? rule
      : {
          headline: "ขอบคุณที่บอกเรา",
          body: "ความเห็นของคุณช่วยให้หมอรู้ดีขึ้น — กลับมาใช้ได้ทุกเมื่อ",
          ctaHref: "/pricing",
          ctaLabel: "ดูแพ็กเกจ",
        };
  return {
    kind: "none",
    headline: none.headline,
    body: none.body,
    percent: null,
    planLabel: null,
    code: null,
    expiresAt: null,
    ctaHref: none.ctaHref,
    ctaLabel: none.ctaLabel,
  };
}

/** An earlier answer that still stands: same lapse, or inside the cooldown. */
function standingFeedback(latest: FeedbackRecord | null, state: LapseState): FeedbackRecord | null {
  if (!latest) return null;
  if (isSameLapse(latest.access_expires_at, state.expiresAt)) return latest;
  return canIssueWinback(latest.created_at) ? null : latest;
}

async function currentUser() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  return user;
}

export async function GET() {
  const user = await currentUser();
  if (!user) return NextResponse.json({ error: "กรุณาเข้าสู่ระบบก่อน" }, { status: 401 });

  const [state, latest, inOrg] = await Promise.all([
    getLapseState(user.id),
    getLatestFeedback(user.id),
    hasActiveOrgAccess(user.id),
  ]);
  const existing = standingFeedback(latest, state);

  return NextResponse.json({
    eligible: !inOrg && isLapseEligible(state.lastPlan, state.expiresAt),
    wasTrial: state.wasTrial,
    lastPlan: state.lastPlan,
    lastPlanLabel: state.lastPlan ? planLabel(state.lastPlan) : null,
    expiresAt: state.expiresAt,
    existing: existing
      ? { id: existing.id, response: existing.offer_response, offer: toView(existing, state.wasTrial) }
      : null,
  });
}

export async function POST(request: Request) {
  const user = await currentUser();
  if (!user) return NextResponse.json({ error: "กรุณาเข้าสู่ระบบก่อน" }, { status: 401 });

  const body = (await request.json().catch(() => null)) as Record<string, unknown> | null;
  if (!body || !isLapseReason(body.reason)) {
    return NextResponse.json({ error: "กรุณาเลือกเหตุผล" }, { status: 400 });
  }
  const reason = body.reason;
  const detail = sanitizeReasonDetail(body.detail);
  const source = parseLapseSource(body.source);

  const [state, latest, inOrg] = await Promise.all([
    getLapseState(user.id),
    getLatestFeedback(user.id),
    hasActiveOrgAccess(user.id),
  ]);
  if (inOrg || !isLapseEligible(state.lastPlan, state.expiresAt)) {
    return NextResponse.json(
      { error: "แบบสอบถามนี้เปิดให้ตอบเมื่อสมาชิกใกล้หมดอายุหรือหมดอายุแล้ว" },
      { status: 403 }
    );
  }
  const standing = standingFeedback(latest, state);
  if (standing) {
    return NextResponse.json({
      id: standing.id,
      reused: true,
      offer: toView(standing, state.wasTrial),
    });
  }

  const offer = selectWinbackOffer(reason, { wasTrial: state.wasTrial, lastPlan: state.lastPlan });
  const coupon = offer.kind === "discount" ? await issueWinbackCoupon(offer, user.id) : null;
  const discount = offer.kind === "discount" && coupon ? offer : null;

  const admin = createAdminClient();
  const { data: row, error } = await admin
    .from("cancellation_feedback")
    .insert({
      user_id: user.id,
      source,
      last_plan: state.lastPlan,
      access_expires_at: state.expiresAt,
      was_trial: state.wasTrial,
      reason,
      reason_detail: detail,
      offer_kind: discount ? "discount" : "none",
      offer_percent: discount?.percent ?? null,
      offer_plan: discount?.plan ?? null,
      offer_coupon_id: coupon?.id ?? null,
      offer_coupon_code: coupon?.code ?? null,
      offer_expires_at: coupon?.expiresAt ?? null,
    })
    .select(FEEDBACK_COLUMNS)
    .single();

  if (error || !row) {
    // Nobody will ever see this coupon — switch it off.
    if (coupon) await deactivateCoupon(coupon.id);
    // Lost a race with a concurrent POST for the same lapse (unique index
    // uq_cancellation_feedback_user_lapse): return the answer that won.
    if (error?.code === "23505" && state.expiresAt) {
      const first = await getFeedbackForLapse(user.id, state.expiresAt);
      if (first) {
        return NextResponse.json({ id: first.id, reused: true, offer: toView(first, state.wasTrial) });
      }
    }
    console.error("[winback] insert failed:", error?.message);
    return NextResponse.json({ error: "บันทึกไม่สำเร็จ กรุณาลองใหม่" }, { status: 500 });
  }

  return NextResponse.json({ id: row.id, offer: toView(row as FeedbackRecord, state.wasTrial) });
}

export async function PATCH(request: Request) {
  const user = await currentUser();
  if (!user) return NextResponse.json({ error: "กรุณาเข้าสู่ระบบก่อน" }, { status: 401 });

  const body = (await request.json().catch(() => null)) as Record<string, unknown> | null;
  const id = typeof body?.id === "string" ? body.id : null;
  const response = body?.response;
  if (!id || (response !== "accepted" && response !== "declined")) {
    return NextResponse.json({ error: "invalid_body" }, { status: 400 });
  }

  const admin = createAdminClient();
  const { error } = await admin
    .from("cancellation_feedback")
    .update({ offer_response: response, responded_at: new Date().toISOString() })
    .eq("id", id)
    .eq("user_id", user.id);
  if (error) {
    console.error("[winback] response update failed:", error.message);
    return NextResponse.json({ error: "บันทึกไม่สำเร็จ" }, { status: 500 });
  }
  return NextResponse.json({ ok: true });
}
