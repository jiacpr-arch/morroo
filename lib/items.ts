/**
 * Sellable ITEMS — one subject / specialty / exam / case / topic inside a
 * product, as opposed to PLANS (lib/membership.ts) that unlock a whole
 * product. Pure module (no Supabase) so it works on client and server.
 *
 * An item is addressed by a plan string that flows through the normal
 * checkout → Stripe metadata → fulfillment path unchanged:
 *
 *   item:<kind>:<key>[:<term>]
 *
 *   item:mcq_subject:<mcq_subjects.id>        scope subject:<id>
 *   item:mcq_category:internal_med            scope category:internal_med
 *   item:mcq_examtype:NL1                     scope examtype:NL1  (all preclinic)
 *   item:board_specialty:<slug>:month|year    scope specialty:<slug>
 *   item:meq_exam:<exams.id>                  scope exam:<id>
 *   item:meq_category:<category>              scope category:<category>
 *   item:longcase_case:<long_cases.id>        scope case:<id>
 *   item:longcase_specialty:<specialty>       scope specialty:<specialty>
 *   item:school_topic:<school_topics.id>      scope topic:<id>
 *   item:school_year:<1-6>                    scope year:<n>
 *
 * Prices live here (ITEM_PRICES) — change once, propagates to checkout,
 * the payment page and every upsell card.
 */

import type { Product } from "@/lib/membership";

export type ItemKind =
  | "mcq_subject"
  | "mcq_category"
  | "mcq_examtype"
  | "board_specialty"
  | "meq_exam"
  | "meq_category"
  | "longcase_case"
  | "longcase_specialty"
  | "school_topic"
  | "school_year";

export const ITEM_KINDS: readonly ItemKind[] = [
  "mcq_subject",
  "mcq_category",
  "mcq_examtype",
  "board_specialty",
  "meq_exam",
  "meq_category",
  "longcase_case",
  "longcase_specialty",
  "school_topic",
  "school_year",
];

export const ITEM_PRODUCT: Record<ItemKind, Product> = {
  mcq_subject: "mcq",
  mcq_category: "mcq",
  mcq_examtype: "mcq",
  board_specialty: "board",
  meq_exam: "meq",
  meq_category: "meq",
  longcase_case: "longcase",
  longcase_specialty: "longcase",
  school_topic: "school",
  school_year: "school",
};

/** THB, VAT-inclusive. `null` days = lifetime ("ซื้อขาด"). */
export const ITEM_PRICES = {
  // MCQ NL — by question count so tiny subjects aren't overpriced
  mcq_subject_large: 79, // ≥ 200 questions
  mcq_subject_medium: 59, // 100–199
  mcq_subject_small: 39, // < 100
  mcq_category_internal_med: 99, // all internal-medicine sub-specialties
  mcq_examtype_nl1: 99, // every preclinic (NL1) subject
  // Board — per specialty, subscription
  board_specialty_month: 299,
  board_specialty_year: 1990,
  // MEQ
  meq_exam: 29,
  meq_category: 149,
  // Long Case
  longcase_case: 49,
  longcase_specialty: 129,
  // School
  school_topic: 39,
  school_year: 199,
} as const;

/** Retakes allowed on a single purchased Long Case (AI cost per session). */
export const LONGCASE_ITEM_MAX_ATTEMPTS = 3;

export const ITEM_PLAN_PREFIX = "item:";

export interface ParsedItemPlan {
  kind: ItemKind;
  key: string;
  term: "month" | "year" | null;
}

export function isItemPlan(planType: string | null | undefined): boolean {
  return !!planType && planType.startsWith(ITEM_PLAN_PREFIX);
}

/** Parse `item:<kind>:<key>[:<term>]`; null when malformed. */
export function parseItemPlan(planType: string | null | undefined): ParsedItemPlan | null {
  if (!planType || !planType.startsWith(ITEM_PLAN_PREFIX)) return null;
  const parts = planType.slice(ITEM_PLAN_PREFIX.length).split(":");
  const kind = parts[0] as ItemKind;
  if (!ITEM_KINDS.includes(kind)) return null;
  const key = parts[1] ?? "";
  if (!key || !/^[A-Za-z0-9_\-]{1,64}$/.test(key)) return null;
  let term: "month" | "year" | null = null;
  if (kind === "board_specialty") {
    term = parts[2] === "year" ? "year" : "month";
  } else if (parts.length > 2) {
    return null;
  }
  if (kind === "mcq_category" && key !== "internal_med") return null;
  if (kind === "mcq_examtype" && key !== "NL1") return null;
  if (kind === "school_year" && !/^[1-6]$/.test(key)) return null;
  return { kind, key, term };
}

export function itemPlanType(kind: ItemKind, key: string, term?: "month" | "year"): string {
  return kind === "board_specialty"
    ? `${ITEM_PLAN_PREFIX}${kind}:${key}:${term ?? "month"}`
    : `${ITEM_PLAN_PREFIX}${kind}:${key}`;
}

/** Entitlement scope string a parsed item grants. */
export function itemScope(p: ParsedItemPlan): string {
  switch (p.kind) {
    case "mcq_subject":
      return `subject:${p.key}`;
    case "mcq_category":
      return `category:${p.key}`;
    case "mcq_examtype":
      return `examtype:${p.key}`;
    case "board_specialty":
      return `specialty:${p.key}`;
    case "meq_exam":
      return `exam:${p.key}`;
    case "meq_category":
      return `category:${p.key}`;
    case "longcase_case":
      return `case:${p.key}`;
    case "longcase_specialty":
      return `specialty:${p.key}`;
    case "school_topic":
      return `topic:${p.key}`;
    case "school_year":
      return `year:${p.key}`;
  }
}

/** Days of access an item grants; null = lifetime. */
export function itemDays(p: ParsedItemPlan): number | null {
  if (p.kind === "board_specialty") return p.term === "year" ? 365 : 30;
  return null;
}

export function mcqSubjectPrice(questionCount: number): number {
  if (questionCount >= 200) return ITEM_PRICES.mcq_subject_large;
  if (questionCount >= 100) return ITEM_PRICES.mcq_subject_medium;
  return ITEM_PRICES.mcq_subject_small;
}

/**
 * Price for an item. `questionCount` is only needed for mcq_subject
 * (callers that have the subject row pass it; the server resolver looks it up).
 */
export function itemPrice(p: ParsedItemPlan, questionCount = 0): number {
  switch (p.kind) {
    case "mcq_subject":
      return mcqSubjectPrice(questionCount);
    case "mcq_category":
      return ITEM_PRICES.mcq_category_internal_med;
    case "mcq_examtype":
      return ITEM_PRICES.mcq_examtype_nl1;
    case "board_specialty":
      return p.term === "year"
        ? ITEM_PRICES.board_specialty_year
        : ITEM_PRICES.board_specialty_month;
    case "meq_exam":
      return ITEM_PRICES.meq_exam;
    case "meq_category":
      return ITEM_PRICES.meq_category;
    case "longcase_case":
      return ITEM_PRICES.longcase_case;
    case "longcase_specialty":
      return ITEM_PRICES.longcase_specialty;
    case "school_topic":
      return ITEM_PRICES.school_topic;
    case "school_year":
      return ITEM_PRICES.school_year;
  }
}

export function itemPeriodLabel(p: ParsedItemPlan): string {
  if (p.kind === "board_specialty") return p.term === "year" ? "/ ปี" : "/ เดือน";
  return "ซื้อขาด";
}

/** Human label prefix per kind (the resolver appends the item's own name). */
export const ITEM_KIND_LABEL: Record<ItemKind, string> = {
  mcq_subject: "MCQ NL วิชา",
  mcq_category: "MCQ NL หมวด",
  mcq_examtype: "MCQ NL preclinic ทุกวิชา",
  board_specialty: "Board สาขา",
  meq_exam: "MEQ ชุด",
  meq_category: "MEQ วิชา",
  longcase_case: "Long Case เคส",
  longcase_specialty: "Long Case วิชา",
  school_topic: "School บท",
  school_year: "School ปี",
};

/** Fully described item, as produced by the server resolver. */
export interface ItemSpec {
  planType: string;
  kind: ItemKind;
  key: string;
  product: Product;
  scope: string;
  /** e.g. "MCQ NL วิชา สูติศาสตร์-นรีเวชวิทยา" */
  label: string;
  /** Stripe product name */
  stripeName: string;
  amount: number;
  days: number | null;
  period: string;
}
