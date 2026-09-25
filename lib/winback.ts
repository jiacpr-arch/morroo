/**
 * Lapse survey + win-back offer — pure logic (no Supabase), unit-tested in
 * lib/winback.test.ts.
 *
 * morroo memberships are one-time purchases of fixed-length plans (Stripe
 * Checkout `mode: "payment"`, see app/api/billing/checkout) — nothing
 * auto-renews, so there is no subscription to cancel or pause. The
 * "cancellation" moment is when a plan or the 7-day trial runs out and the
 * member doesn't buy again. At that point (/renewal, linked from the profile
 * page and the D+1 expiry message) we:
 *
 *   1. ask why they're not renewing (LAPSE_REASONS + free text),
 *   2. show an offer tailored to the reason (selectWinbackOffer) — a
 *      single-use discount coupon in coupon_codes, restricted to the plan
 *      they'd renew, or no coupon when a discount wouldn't help,
 *   3. record the answer in `cancellation_feedback`
 *      (supabase/migrations/20260925_cancellation_feedback.sql).
 *
 * "Pause until exam date" becomes a long-lived coupon for exam_done: they
 * come back for the next exam round at a discount.
 */

import { PLAN_CATALOG, isPlanType, type PlanType } from "@/lib/membership";

export const LAPSE_REASONS = [
  "exam_done",
  "too_expensive",
  "not_using",
  "content_mismatch",
  "other",
] as const;

export type LapseReason = (typeof LAPSE_REASONS)[number];

export const LAPSE_REASON_LABELS: Record<LapseReason, string> = {
  exam_done: "สอบเสร็จแล้ว",
  too_expensive: "แพงไป",
  not_using: "ไม่ค่อยได้ใช้",
  content_mismatch: "เนื้อหาไม่ตรงกับที่ต้องการ",
  other: "อื่นๆ",
};

export function isLapseReason(value: unknown): value is LapseReason {
  return typeof value === "string" && (LAPSE_REASONS as readonly string[]).includes(value);
}

/** Where the survey was opened from (cancellation_feedback.source). */
export const LAPSE_SOURCES = ["profile", "expiry_line", "expiry_email", "direct"] as const;
export type LapseSource = (typeof LAPSE_SOURCES)[number];

export function parseLapseSource(value: unknown): LapseSource {
  return typeof value === "string" && (LAPSE_SOURCES as readonly string[]).includes(value)
    ? (value as LapseSource)
    : "direct";
}

/** Free-text answer: trimmed, capped, empty → null. */
export const REASON_DETAIL_MAX = 1000;
export function sanitizeReasonDetail(value: unknown): string | null {
  if (typeof value !== "string") return null;
  const s = value.trim().slice(0, REASON_DETAIL_MAX);
  return s ? s : null;
}

export interface LapseContext {
  /** The access that ran out was the free trial (never paid). */
  wasTrial: boolean;
  /** membership_type before the lapse (plan string or null). */
  lastPlan: string | null;
}

export type WinbackOffer =
  | {
      kind: "discount";
      percent: number;
      /** Coupon lifetime from issue. */
      validDays: number;
      /** The only plan the coupon applies to (coupon_codes.plan_type). */
      plan: PlanType;
      headline: string;
      body: string;
    }
  | {
      kind: "none";
      headline: string;
      body: string;
      ctaHref: string;
      ctaLabel: string;
    };

/**
 * Plan a win-back coupon is restricted to: the plan they had, when it's a
 * renewable (time-limited) plan; otherwise the student pack monthly — also
 * what the trial unlocked.
 */
export function winbackPlanFor(lastPlan: string | null | undefined): PlanType {
  if (lastPlan && isPlanType(lastPlan) && PLAN_CATALOG[lastPlan].duration !== "lifetime") {
    return lastPlan;
  }
  return "monthly";
}

/**
 * Offer by reason. Trial users haven't paid yet and already get the
 * first-purchase intro price, so their discounts are smaller.
 */
export function selectWinbackOffer(reason: LapseReason, ctx: LapseContext): WinbackOffer {
  const plan = winbackPlanFor(ctx.lastPlan);
  const discount = (percent: number, validDays: number, headline: string, body: string): WinbackOffer => ({
    kind: "discount",
    percent,
    validDays,
    plan,
    headline,
    body,
  });

  switch (reason) {
    case "too_expensive":
      return ctx.wasTrial
        ? discount(20, 7, "ลดเพิ่ม 20% สำหรับเดือนแรก", "เราเข้าใจเรื่องงบ — ใช้โค้ดนี้คู่กับราคาซื้อครั้งแรกได้เลย ภายใน 7 วัน")
        : discount(30, 7, "ต่ออายุลด 30%", "เราเข้าใจเรื่องงบ — ใช้โค้ดนี้ต่ออายุแพ็กเดิมได้ภายใน 7 วัน");
    case "not_using":
      return discount(
        15,
        14,
        "กลับมาเริ่มใหม่ ลด 15%",
        "ลองเปิดรับข้อสอบวันละข้อทาง LINE ช่วยให้ฝึกได้สม่ำเสมอขึ้น — โค้ดนี้ใช้ได้ 14 วัน"
      );
    case "exam_done":
      return discount(
        20,
        180,
        "เก็บส่วนลด 20% ไว้ใช้สอบรอบหน้า",
        "ยินดีด้วยที่สอบเสร็จแล้ว! บัญชีและประวัติการทำข้อสอบยังอยู่ครบ — โค้ดนี้ใช้ได้ 6 เดือน ไว้กลับมาเตรียมสอบรอบถัดไป"
      );
    case "content_mismatch":
      return {
        kind: "none",
        headline: "ขอบคุณที่บอกเรา",
        body: "ทีมอ่านทุกความเห็นเพื่อเพิ่มเนื้อหาที่ขาด — ถ้าต้องการแค่บางวิชา ซื้อแยกรายวิชา/รายระบบได้ในราคาที่ถูกกว่า",
        ctaHref: "/pricing",
        ctaLabel: "ดูแพ็กรายระบบ",
      };
    case "other":
      return discount(20, 7, "ต่ออายุลด 20%", "ถ้าเปลี่ยนใจ ใช้โค้ดนี้ได้ภายใน 7 วัน");
  }
}

/** Offer as the /renewal page renders it (app/api/winback). */
export interface WinbackOfferView {
  kind: "discount" | "none";
  headline: string;
  body: string;
  percent: number | null;
  planLabel: string | null;
  code: string | null;
  expiresAt: string | null;
  ctaHref: string;
  ctaLabel: string;
}

/** One new coupon per user per cooldown — re-opening the survey shows the same offer. */
export const WINBACK_COOLDOWN_DAYS = 60;

export function canIssueWinback(
  lastIssuedAt: string | Date | null | undefined,
  now: Date = new Date()
): boolean {
  if (!lastIssuedAt) return true;
  const t = new Date(lastIssuedAt).getTime();
  if (!Number.isFinite(t)) return true;
  return now.getTime() - t >= WINBACK_COOLDOWN_DAYS * 86_400_000;
}

/**
 * Survey is offered when access has run out or will within this many days
 * (short enough that a 7-day trial user only sees it in the trial's last days,
 * and a member deep into a yearly plan can't farm coupons).
 */
export const LAPSE_WINDOW_DAYS = 3;

export function isLapseEligible(
  lastPlan: string | null | undefined,
  expiresAt: string | Date | null | undefined,
  now: Date = new Date()
): boolean {
  if (!lastPlan || lastPlan === "free" || lastPlan === "bundle") return false;
  if (!expiresAt) return false;
  const t = new Date(expiresAt).getTime();
  if (!Number.isFinite(t)) return false;
  return t - now.getTime() <= LAPSE_WINDOW_DAYS * 86_400_000;
}

// ─── Admin aggregates ────────────────────────────────────────────────────

export interface FeedbackRow {
  reason: string;
  offer_kind: string | null;
  offer_response: string | null;
  was_trial: boolean | null;
  source: string | null;
  /** Offer coupon was used at checkout (coupon_redemptions row exists). */
  redeemed?: boolean;
}

export interface FeedbackSummary {
  total: number;
  reasons: { reason: LapseReason; label: string; count: number; pct: number }[];
  offersShown: number;
  offersAccepted: number;
  offersRedeemed: number;
  /** accepted (clicked "use code") / discount offers shown, 0–100. */
  acceptanceRate: number;
  /** redeemed at checkout / discount offers shown, 0–100. */
  redemptionRate: number;
  trialShare: number;
  bySource: Record<string, number>;
}

const pct = (n: number, d: number) => (d > 0 ? Math.round((n / d) * 1000) / 10 : 0);

export function summarizeFeedback(rows: readonly FeedbackRow[]): FeedbackSummary {
  const counts = new Map<LapseReason, number>(LAPSE_REASONS.map((r) => [r, 0]));
  const bySource: Record<string, number> = {};
  let offersShown = 0;
  let offersAccepted = 0;
  let offersRedeemed = 0;
  let trial = 0;

  for (const r of rows) {
    const reason: LapseReason = isLapseReason(r.reason) ? r.reason : "other";
    counts.set(reason, (counts.get(reason) ?? 0) + 1);
    const src = r.source ?? "direct";
    bySource[src] = (bySource[src] ?? 0) + 1;
    if (r.was_trial) trial++;
    if (r.offer_kind === "discount") {
      offersShown++;
      if (r.offer_response === "accepted") offersAccepted++;
      if (r.redeemed) offersRedeemed++;
    }
  }

  const total = rows.length;
  return {
    total,
    reasons: LAPSE_REASONS.map((reason) => ({
      reason,
      label: LAPSE_REASON_LABELS[reason],
      count: counts.get(reason) ?? 0,
      pct: pct(counts.get(reason) ?? 0, total),
    })).sort((a, b) => b.count - a.count),
    offersShown,
    offersAccepted,
    offersRedeemed,
    acceptanceRate: pct(offersAccepted, offersShown),
    redemptionRate: pct(offersRedeemed, offersShown),
    trialShare: pct(trial, total),
    bySource,
  };
}

export interface TrialStart {
  userId: string;
  startedAt: string;
}

export interface PaidOrder {
  userId: string;
  paidAt: string;
}

export interface TrialConversion {
  /** Trials started in the window. */
  started: number;
  /** Trials still running (excluded from the rate). */
  running: number;
  /** Trials that have ended — the rate's denominator. */
  ended: number;
  /** Ended trials whose user paid on/after the trial start. */
  converted: number;
  /** Of those, paid before the trial ran out or within 7 days after. */
  convertedEarly: number;
  /** converted / ended, 0–100. */
  rate: number;
  /** Median days from trial start to first payment (null if none). */
  medianDaysToPay: number | null;
}

/**
 * Trial → paid conversion. A trial counts once per user (earliest start);
 * the first payment on/after that start is the conversion.
 */
export function computeTrialConversion(
  trials: readonly TrialStart[],
  orders: readonly PaidOrder[],
  trialDays: number,
  now: Date = new Date()
): TrialConversion {
  const DAY = 86_400_000;
  const firstTrial = new Map<string, number>();
  for (const t of trials) {
    const ts = new Date(t.startedAt).getTime();
    if (!Number.isFinite(ts)) continue;
    const prev = firstTrial.get(t.userId);
    if (prev === undefined || ts < prev) firstTrial.set(t.userId, ts);
  }

  const paysByUser = new Map<string, number[]>();
  for (const o of orders) {
    const ts = new Date(o.paidAt).getTime();
    if (!Number.isFinite(ts)) continue;
    const list = paysByUser.get(o.userId) ?? [];
    list.push(ts);
    paysByUser.set(o.userId, list);
  }

  let running = 0;
  let ended = 0;
  let converted = 0;
  let convertedEarly = 0;
  const daysToPay: number[] = [];

  for (const [userId, start] of firstTrial) {
    const end = start + trialDays * DAY;
    const firstPay = (paysByUser.get(userId) ?? [])
      .filter((p) => p >= start)
      .sort((a, b) => a - b)[0];

    // A trial that already converted counts as ended even if days remain.
    if (end > now.getTime() && firstPay === undefined) {
      running++;
      continue;
    }
    ended++;
    if (firstPay !== undefined) {
      converted++;
      if (firstPay <= end + 7 * DAY) convertedEarly++;
      daysToPay.push((firstPay - start) / DAY);
    }
  }

  daysToPay.sort((a, b) => a - b);
  const mid = Math.floor(daysToPay.length / 2);
  const median =
    daysToPay.length === 0
      ? null
      : daysToPay.length % 2
        ? daysToPay[mid]
        : (daysToPay[mid - 1] + daysToPay[mid]) / 2;

  return {
    started: firstTrial.size,
    running,
    ended,
    converted,
    convertedEarly,
    rate: pct(converted, ended),
    medianDaysToPay: median === null ? null : Math.round(median * 10) / 10,
  };
}
