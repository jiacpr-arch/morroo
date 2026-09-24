/**
 * Central membership access helpers — single source of truth for which
 * product each plan unlocks. Pure functions only (no Supabase) so they can be
 * unit-tested and used on both server and client.
 *
 * Two layers:
 *
 * 1. PRODUCTS — the five independently-billed systems:
 *      school · mcq (NL) · meq · longcase · board
 *    A user holds one entitlement per product in `membership_entitlements`,
 *    each with its own expiry, so buying Board never touches MCQ and so on.
 *
 * 2. PLANS (SKUs) — what is sold at checkout. A plan grants one or more
 *    products for a duration (see PLAN_CATALOG / PLAN_PRODUCTS):
 *      monthly / yearly     → student pack: mcq + meq + longcase (+ school)
 *      bundle               → mcq, lifetime (10-question credits)
 *      <product>_monthly/_yearly → that product only
 *
 * Legacy: `profiles.membership_type` / `membership_expires_at` hold ONE plan.
 * They are kept in sync as a summary (crons / analytics still read them) and
 * are only used for access when the user has no entitlement rows at all
 * (i.e. the backfill migration has not run for them).
 */

export type Product = "school" | "mcq" | "meq" | "longcase" | "board";

export const PRODUCTS: readonly Product[] = [
  "school",
  "mcq",
  "meq",
  "longcase",
  "board",
] as const;

export const PRODUCT_INFO: Record<
  Product,
  { label: string; short: string; description: string; color: string }
> = {
  school: {
    label: "School",
    short: "School",
    description: "Y1–Y6 micro-learning (flashcard / quiz / SRS)",
    color: "bg-emerald-100 text-emerald-700",
  },
  mcq: {
    label: "MCQ (NL)",
    short: "MCQ",
    description: "ข้อสอบ MCQ NL Step 2 ไม่จำกัด + เฉลยละเอียด",
    color: "bg-blue-100 text-blue-700",
  },
  meq: {
    label: "MEQ",
    short: "MEQ",
    description: "ข้อสอบ MEQ + AI ตรวจคำตอบ",
    color: "bg-amber-100 text-amber-700",
  },
  longcase: {
    label: "Long Case",
    short: "Long Case",
    description: "Long Case Exam กับ AI ไม่จำกัด",
    color: "bg-rose-100 text-rose-700",
  },
  board: {
    label: "Board",
    short: "Board",
    description: "MCQ บอร์ดทุกสาขา + Oral Exam",
    color: "bg-purple-100 text-purple-700",
  },
};

export function isProduct(value: unknown): value is Product {
  return typeof value === "string" && (PRODUCTS as readonly string[]).includes(value);
}

export type MembershipType =
  | "free"
  | "bundle"
  | "monthly"
  | "yearly"
  | "mcq_monthly"
  | "mcq_yearly"
  | "meq_monthly"
  | "meq_yearly"
  | "longcase_monthly"
  | "longcase_yearly"
  | "board_monthly"
  | "board_yearly"
  | "school_monthly"
  | "school_yearly";

/** Plans that can be bought / granted (everything except `free`). */
export type PlanType = Exclude<MembershipType, "free">;

export type PlanDuration = "month" | "year" | "lifetime";

export interface PlanSpec {
  /** Thai label used in admin, receipts and LINE notifications. */
  label: string;
  /** Stripe product name. */
  stripeName: string;
  /** Regular price in THB (inclusive of VAT) — what repeat buyers pay. */
  amount: number;
  /**
   * Introductory price for a customer's first purchase (see
   * lib/billing/intro-price.ts). The regular `amount` is shown struck
   * through next to it, so it must be a price people actually pay.
   */
  introAmount?: number;
  products: readonly Product[];
  duration: PlanDuration;
}

/**
 * Single source of truth for every sellable plan. STRIPE_PLANS, the
 * /payment/[plan] page, fulfillment labels and admin grant menus all derive
 * from this map.
 *
 * NOTE: prices are set here only and propagate everywhere. Plans with an
 * `introAmount` sell at that price on a customer's first purchase and at
 * `amount` afterwards (lib/billing/intro-price.ts).
 */
export const PLAN_CATALOG: Record<PlanType, PlanSpec> = {
  // ---- Student pack (NL Step 2) ----
  monthly: {
    label: "รายเดือน",
    stripeName: "MorRoo รายเดือน",
    amount: 299,
    introAmount: 199,
    products: ["mcq", "meq", "longcase", "school"],
    duration: "month",
  },
  yearly: {
    label: "รายปี",
    stripeName: "MorRoo รายปี",
    amount: 2490,
    introAmount: 1490,
    products: ["mcq", "meq", "longcase", "school"],
    duration: "year",
  },
  bundle: {
    label: "ชุดข้อสอบ",
    stripeName: "MorRoo ชุดข้อสอบ 10 ข้อ",
    amount: 299,
    products: ["mcq"],
    duration: "lifetime",
  },
  // ---- Board ----
  board_monthly: {
    label: "Board รายเดือน",
    stripeName: "MorRoo Board รายเดือน",
    amount: 699,
    introAmount: 499,
    products: ["board"],
    duration: "month",
  },
  board_yearly: {
    label: "Board รายปี",
    stripeName: "MorRoo Board รายปี",
    amount: 6990,
    introAmount: 4990,
    products: ["board"],
    duration: "year",
  },
  // ---- Per-product ----
  mcq_monthly: {
    label: "MCQ รายเดือน",
    stripeName: "MorRoo MCQ NL รายเดือน",
    amount: 149,
    introAmount: 99,
    products: ["mcq"],
    duration: "month",
  },
  mcq_yearly: {
    label: "MCQ รายปี",
    stripeName: "MorRoo MCQ NL รายปี",
    amount: 1190,
    introAmount: 790,
    products: ["mcq"],
    duration: "year",
  },
  meq_monthly: {
    label: "MEQ รายเดือน",
    stripeName: "MorRoo MEQ รายเดือน",
    amount: 149,
    introAmount: 99,
    products: ["meq"],
    duration: "month",
  },
  meq_yearly: {
    label: "MEQ รายปี",
    stripeName: "MorRoo MEQ รายปี",
    amount: 1190,
    introAmount: 790,
    products: ["meq"],
    duration: "year",
  },
  longcase_monthly: {
    label: "Long Case รายเดือน",
    stripeName: "MorRoo Long Case รายเดือน",
    amount: 199,
    introAmount: 129,
    products: ["longcase"],
    duration: "month",
  },
  longcase_yearly: {
    label: "Long Case รายปี",
    stripeName: "MorRoo Long Case รายปี",
    amount: 1490,
    introAmount: 990,
    products: ["longcase"],
    duration: "year",
  },
  school_monthly: {
    label: "School รายเดือน",
    stripeName: "MorRoo School รายเดือน",
    amount: 149,
    introAmount: 99,
    products: ["school"],
    duration: "month",
  },
  school_yearly: {
    label: "School รายปี",
    stripeName: "MorRoo School รายปี",
    amount: 1190,
    introAmount: 790,
    products: ["school"],
    duration: "year",
  },
};

export const PLAN_TYPES = Object.keys(PLAN_CATALOG) as PlanType[];

/** First-purchase price of a plan (its regular price when it has no intro). */
export function planIntroAmount(plan: PlanType): number {
  return PLAN_CATALOG[plan].introAmount ?? PLAN_CATALOG[plan].amount;
}

export interface PlanDisplayPrice {
  /** Price a first-time buyer pays. */
  price: number;
  /** Regular price to show struck through, or null when there is no intro. */
  compareAt: number | null;
  /** Whole-percent discount of `price` against `compareAt` (0 when none). */
  savePercent: number;
}

/** Headline price for pricing cards: intro price + struck-through regular. */
export function planDisplayPrice(plan: PlanType): PlanDisplayPrice {
  const { amount } = PLAN_CATALOG[plan];
  const price = planIntroAmount(plan);
  if (price >= amount) return { price: amount, compareAt: null, savePercent: 0 };
  return {
    price,
    compareAt: amount,
    savePercent: Math.round((1 - price / amount) * 100),
  };
}

export function isPlanType(value: unknown): value is PlanType {
  return typeof value === "string" && value in PLAN_CATALOG;
}

/** Thai label for any membership_type value, including `free`. */
export const PLAN_LABELS: Record<MembershipType, string> = {
  free: "ฟรี",
  ...Object.fromEntries(
    PLAN_TYPES.map((p) => [p, PLAN_CATALOG[p].label])
  ),
} as Record<MembershipType, string>;

export function planLabel(plan: string | null | undefined): string {
  if (!plan) return PLAN_LABELS.free;
  return (PLAN_LABELS as Record<string, string>)[plan] ?? plan;
}

/** Products a plan unlocks (`free` → none). */
export function planProducts(plan: string | null | undefined): readonly Product[] {
  if (!plan || !isPlanType(plan)) return [];
  return PLAN_CATALOG[plan].products;
}

/**
 * Days of access a plan grants, used to stack entitlements. `null` = lifetime.
 * 30 / 365 keep the existing "monthly_1m = 30 days" redeem semantics; the
 * calendar-month Stripe expiry is computed separately by `planExpiry`.
 */
export function planDurationDays(plan: PlanType): number | null {
  switch (PLAN_CATALOG[plan].duration) {
    case "month":
      return 30;
    case "year":
      return 365;
    case "lifetime":
      return null;
  }
}

/**
 * Expiry written to the legacy profile columns after a purchase. Mirrors the
 * historical fulfillment behaviour: +1 calendar month / +1 year / +99 years.
 */
export function planExpiry(plan: PlanType, from: Date = new Date()): Date {
  const d = new Date(from);
  switch (PLAN_CATALOG[plan].duration) {
    case "month":
      d.setMonth(d.getMonth() + 1);
      break;
    case "year":
      d.setFullYear(d.getFullYear() + 1);
      break;
    case "lifetime":
      d.setFullYear(d.getFullYear() + 99);
      break;
  }
  return d;
}

// ----------------------------------------------------------------------------
// Access resolution
// ----------------------------------------------------------------------------

export interface MembershipLike {
  membership_type?: string | null;
  membership_expires_at?: string | null;
}

export interface EntitlementLike {
  product: string;
  /** ISO timestamp; null = lifetime */
  expires_at: string | null;
  /**
   * `*` (or missing) = the whole product. Anything else is one item inside
   * the product, e.g. `subject:<id>` / `specialty:<slug>` / `exam:<id>` —
   * see lib/items.ts. Scoped rows never grant product-level access.
   */
  scope?: string | null;
}

export const WHOLE_PRODUCT_SCOPE = "*";

export function isWholeProductRow(e: EntitlementLike): boolean {
  return !e.scope || e.scope === WHOLE_PRODUCT_SCOPE;
}

export interface Access {
  school: boolean;
  mcq: boolean;
  meq: boolean;
  longcase: boolean;
  board: boolean;
  /** Any product active — for generic "premium" UI affordances. */
  anyPaid: boolean;
  /** Products currently active. */
  products: Product[];
}

const NO_ACCESS: Access = {
  school: false,
  mcq: false,
  meq: false,
  longcase: false,
  board: false,
  anyPaid: false,
  products: [],
};

function isExpired(expiresAt: string | null | undefined, now: Date): boolean {
  if (!expiresAt) return false;
  return new Date(expiresAt) < now;
}

function legacyExpired(profile: MembershipLike | null | undefined, now: Date): boolean {
  return isExpired(profile?.membership_expires_at, now);
}

/** Products the legacy profile columns unlock right now. */
export function legacyProducts(
  profile: MembershipLike | null | undefined,
  now: Date = new Date()
): Product[] {
  if (!profile?.membership_type || profile.membership_type === "free") return [];
  if (legacyExpired(profile, now)) return [];
  return [...planProducts(profile.membership_type)];
}

/** Products the (whole-product) entitlement rows unlock right now. */
export function entitledProducts(
  entitlements: readonly EntitlementLike[] | null | undefined,
  now: Date = new Date()
): Product[] {
  const out: Product[] = [];
  for (const e of entitlements ?? []) {
    if (!isProduct(e.product)) continue;
    if (!isWholeProductRow(e)) continue;
    if (isExpired(e.expires_at, now)) continue;
    if (!out.includes(e.product)) out.push(e.product);
  }
  return out;
}

/** Active item scopes the user holds inside one product (excludes `*`). */
export function entitledScopes(
  entitlements: readonly EntitlementLike[] | null | undefined,
  product: Product,
  now: Date = new Date()
): Set<string> {
  const out = new Set<string>();
  for (const e of entitlements ?? []) {
    if (e.product !== product) continue;
    if (isWholeProductRow(e)) continue;
    if (isExpired(e.expires_at, now)) continue;
    out.add(e.scope as string);
  }
  return out;
}

/**
 * Whole-product access OR any of `scopes` bought individually. Use this on
 * pages that show one subject / specialty / exam / case / topic.
 */
export function hasScopedAccess(
  product: Product,
  scopes: readonly string[],
  profile: MembershipLike | null | undefined,
  entitlements?: readonly EntitlementLike[] | null,
  now: Date = new Date()
): boolean {
  if (resolveAccess(profile, entitlements, now)[product]) return true;
  if (!scopes.length) return false;
  const owned = entitledScopes(entitlements, product, now);
  return scopes.some((s) => owned.has(s));
}

/**
 * Resolve access from a profile plus its entitlement rows.
 *
 * Rule: once a user has ANY entitlement row (active or expired) the rows are
 * authoritative — the legacy columns are ignored so an admin revoke can never
 * be re-opened by a stale `membership_type`. Users with no rows at all fall
 * back to the legacy plan mapping.
 */
export function resolveAccess(
  profile: MembershipLike | null | undefined,
  entitlements?: readonly EntitlementLike[] | null,
  now: Date = new Date()
): Access {
  const hasRows = !!entitlements && entitlements.length > 0;
  const products = hasRows
    ? entitledProducts(entitlements, now)
    : legacyProducts(profile, now);
  if (products.length === 0) return NO_ACCESS;
  return {
    school: products.includes("school"),
    mcq: products.includes("mcq"),
    meq: products.includes("meq"),
    longcase: products.includes("longcase"),
    board: products.includes("board"),
    anyPaid: true,
    products,
  };
}

export function hasProductAccess(
  product: Product,
  profile: MembershipLike | null | undefined,
  entitlements?: readonly EntitlementLike[] | null
): boolean {
  return resolveAccess(profile, entitlements)[product];
}

// ----------------------------------------------------------------------------
// Named helpers (kept for existing call sites). All accept optional
// entitlement rows; without them they behave exactly as before (legacy plan).
// ----------------------------------------------------------------------------

/** NL MCQ — unlimited questions + detailed explanations */
export function hasMcqAccess(
  profile: MembershipLike | null | undefined,
  entitlements?: readonly EntitlementLike[] | null
): boolean {
  return hasProductAccess("mcq", profile, entitlements);
}

/** MEQ exams + AI grading */
export function hasMeqAccess(
  profile: MembershipLike | null | undefined,
  entitlements?: readonly EntitlementLike[] | null
): boolean {
  return hasProductAccess("meq", profile, entitlements);
}

/** Long Case (student audience) — unlimited sessions, retries */
export function hasLongcaseAccess(
  profile: MembershipLike | null | undefined,
  entitlements?: readonly EntitlementLike[] | null
): boolean {
  return hasProductAccess("longcase", profile, entitlements);
}

/** Board access — board MCQ unlimited, oral exam */
export function hasBoardAccess(
  profile: MembershipLike | null | undefined,
  entitlements?: readonly EntitlementLike[] | null
): boolean {
  return hasProductAccess("board", profile, entitlements);
}

/** School mode (Y1–Y6 micro-learning) — unlimited flashcards / quizzes / SRS review */
export function hasSchoolAccess(
  profile: MembershipLike | null | undefined,
  entitlements?: readonly EntitlementLike[] | null
): boolean {
  return hasProductAccess("school", profile, entitlements);
}

/**
 * Full student pack — mcq + meq + longcase all active. With legacy columns
 * only this is exactly the old `monthly | yearly | bundle` check.
 */
export function hasFullStudentAccess(
  profile: MembershipLike | null | undefined,
  entitlements?: readonly EntitlementLike[] | null
): boolean {
  const hasRows = !!entitlements && entitlements.length > 0;
  if (!hasRows) {
    // Legacy semantics: bundle counted as full student access.
    const t = profile?.membership_type;
    if (!t || legacyExpired(profile, new Date())) return false;
    return t === "monthly" || t === "yearly" || t === "bundle";
  }
  const a = resolveAccess(profile, entitlements);
  return a.mcq && a.meq && a.longcase;
}

/** Any paid product active, used for some UI affordances */
export function isPremium(
  profile: MembershipLike | null | undefined,
  entitlements?: readonly EntitlementLike[] | null
): boolean {
  return resolveAccess(profile, entitlements).anyPaid;
}

/**
 * Derive the legacy summary (membership_type + expiry) from entitlement rows
 * so crons / analytics keep working. Chooses the widest plan whose products
 * are ALL active, preferring the user's current plan when it still fits;
 * expiry = latest expiry among the plan's products (null = lifetime).
 */
export function deriveLegacyMembership(
  entitlements: readonly EntitlementLike[],
  currentType?: string | null,
  now: Date = new Date()
): { membership_type: MembershipType; membership_expires_at: string | null } {
  const active = entitledProducts(entitlements, now);
  if (active.length === 0) {
    return { membership_type: "free", membership_expires_at: null };
  }
  const fits = (plan: PlanType) =>
    PLAN_CATALOG[plan].products.every((p) => active.includes(p));

  let plan: PlanType | null = null;
  if (currentType && isPlanType(currentType) && fits(currentType)) {
    plan = currentType;
  } else {
    // Widest first: student pack, then board, then single products. Monthly
    // labels by default; keep a yearly label when the user's current plan is
    // a yearly variant.
    const order: PlanType[] = [
      "monthly",
      "board_monthly",
      "mcq_monthly",
      "meq_monthly",
      "longcase_monthly",
      "school_monthly",
    ];
    const yearlyPref = currentType === "yearly" || !!currentType?.endsWith("_yearly");
    for (const candidate of order) {
      if (!fits(candidate)) continue;
      plan = candidate;
      if (yearlyPref) {
        const y = (candidate === "monthly" ? "yearly" : candidate.replace("_monthly", "_yearly")) as PlanType;
        if (isPlanType(y)) plan = y;
      }
      break;
    }
  }
  if (!plan) {
    // Should not happen (every single product has a plan), but be safe.
    plan = `${active[0]}_monthly` as PlanType;
  }

  let expires: string | null | undefined;
  for (const p of PLAN_CATALOG[plan].products) {
    const row = entitlements.find(
      (e) => e.product === p && isWholeProductRow(e) && !isExpired(e.expires_at, now)
    );
    if (!row) continue;
    if (row.expires_at === null) {
      expires = null;
      break;
    }
    if (!expires || new Date(row.expires_at) > new Date(expires)) {
      expires = row.expires_at;
    }
  }
  return { membership_type: plan, membership_expires_at: expires ?? null };
}
