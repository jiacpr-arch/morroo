/**
 * Server-side resolver for anything that can be bought: a PLAN
 * (lib/membership.ts PLAN_CATALOG) or an ITEM (lib/items.ts, priced and
 * labelled from the row it points at). Used by checkout, fulfillment and
 * the payment page so a plan string is the only thing that travels.
 */

import { createAdminClient } from "@/lib/supabase/admin";
import { PLAN_CATALOG, isPlanType, type PlanType, type Product } from "@/lib/membership";
import {
  ITEM_KIND_LABEL,
  ITEM_PRODUCT,
  itemDays,
  itemPeriodLabel,
  itemPrice,
  itemScope,
  parseItemPlan,
  type ItemSpec,
} from "@/lib/items";
import { NL_BROAD_SUBJECTS } from "@/lib/nl-subjects";

export type Purchasable =
  | { kind: "plan"; planType: PlanType; label: string; stripeName: string; amount: number; period: string; product: Product | null }
  | { kind: "item"; item: ItemSpec };

const PERIOD: Record<string, string> = { month: "/ เดือน", year: "/ ปี", lifetime: "ซื้อขาด" };

/**
 * Look an item up in the database and price it. Returns null when the plan
 * string is malformed or the referenced row does not exist / is unpublished.
 */
export async function resolveItem(planType: string): Promise<ItemSpec | null> {
  const parsed = parseItemPlan(planType);
  if (!parsed) return null;
  const admin = createAdminClient();

  let name: string | null = null;
  let questionCount = 0;

  switch (parsed.kind) {
    case "mcq_subject": {
      const { data } = await admin
        .from("mcq_subjects")
        .select("id, name_th, question_count, audience")
        .eq("id", parsed.key)
        .maybeSingle();
      if (!data || data.audience === "board") return null;
      name = data.name_th;
      questionCount = data.question_count ?? 0;
      break;
    }
    case "mcq_category":
      name = "อายุรกรรม (ทุก sub-specialty)";
      break;
    case "mcq_examtype":
      name = `${NL_BROAD_SUBJECTS.filter((s) => s.exam_type === "NL1").length} วิชา`;
      break;
    case "board_specialty": {
      const { data } = await admin
        .from("board_specialties")
        .select("slug, name_th, is_active")
        .eq("slug", parsed.key)
        .maybeSingle();
      if (!data || data.is_active === false) return null;
      name = data.name_th;
      break;
    }
    case "meq_exam": {
      const { data } = await admin
        .from("exams")
        .select("id, title, status, is_free")
        .eq("id", parsed.key)
        .maybeSingle();
      if (!data || data.status !== "published" || data.is_free) return null;
      name = data.title;
      break;
    }
    case "meq_category": {
      const { count } = await admin
        .from("exams")
        .select("id", { count: "exact", head: true })
        .eq("category", parsed.key)
        .eq("status", "published");
      if (!count) return null;
      name = `${parsed.key} (${count} ชุด)`;
      break;
    }
    case "longcase_case": {
      const { data } = await admin
        .from("long_cases")
        .select("id, title, is_published, audience")
        .eq("id", parsed.key)
        .maybeSingle();
      if (!data || !data.is_published || data.audience === "board") return null;
      name = data.title;
      break;
    }
    case "longcase_specialty": {
      const { count } = await admin
        .from("long_cases")
        .select("id", { count: "exact", head: true })
        .eq("specialty", parsed.key)
        .eq("audience", "student")
        .eq("is_published", true);
      if (!count) return null;
      name = `${parsed.key} (${count} เคส)`;
      break;
    }
    case "school_topic": {
      const { data } = await admin
        .from("school_topics")
        .select("id, name_th, year")
        .eq("id", parsed.key)
        .maybeSingle();
      if (!data) return null;
      name = `${data.name_th} (ปี ${data.year})`;
      break;
    }
    case "school_year": {
      const { count } = await admin
        .from("school_topics")
        .select("id", { count: "exact", head: true })
        .eq("year", Number(parsed.key));
      if (!count) return null;
      name = `${parsed.key} (${count} บท)`;
      break;
    }
  }
  if (!name) return null;

  const label = `${ITEM_KIND_LABEL[parsed.kind]} ${name}`.trim();
  const period = itemPeriodLabel(parsed);
  return {
    planType,
    kind: parsed.kind,
    key: parsed.key,
    product: ITEM_PRODUCT[parsed.kind],
    scope: itemScope(parsed),
    label,
    stripeName: `MorRoo ${label}${parsed.kind === "board_specialty" ? ` ${period === "/ ปี" ? "รายปี" : "รายเดือน"}` : ""}`,
    amount: itemPrice(parsed, questionCount),
    days: itemDays(parsed),
    period,
  };
}

/** Describe any purchasable plan string (plan or item). */
export async function resolvePurchasable(planType: string): Promise<Purchasable | null> {
  if (isPlanType(planType)) {
    const spec = PLAN_CATALOG[planType];
    return {
      kind: "plan",
      planType,
      label: spec.label,
      stripeName: spec.stripeName,
      amount: spec.amount,
      period: PERIOD[spec.duration],
      product: spec.products.length === 1 ? spec.products[0] : null,
    };
  }
  const item = await resolveItem(planType);
  return item ? { kind: "item", item } : null;
}

/** Display name for receipts / LINE when only the plan string is stored. */
export async function purchasableName(planType: string | null | undefined): Promise<string> {
  if (!planType) return "-";
  const p = await resolvePurchasable(planType);
  if (!p) return planType;
  return p.kind === "plan" ? p.stripeName : p.item.stripeName;
}
