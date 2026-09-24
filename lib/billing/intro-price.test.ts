import { describe, it, expect, vi } from "vitest";

vi.mock("@/lib/supabase/admin", () => ({ createAdminClient: vi.fn() }));

import { priceFor } from "./intro-price";
import type { Purchasable } from "./plan-resolver";
import type { ItemSpec } from "@/lib/items";

const monthly: Purchasable = {
  kind: "plan",
  planType: "monthly",
  label: "รายเดือน",
  stripeName: "MorRoo รายเดือน",
  amount: 299,
  period: "/ เดือน",
  product: null,
};

describe("priceFor", () => {
  it("charges the intro price on a first purchase", () => {
    expect(priceFor(monthly, true)).toEqual({ amount: 199, regularAmount: 299, intro: true });
  });
  it("charges the regular price on a repeat purchase", () => {
    expect(priceFor(monthly, false)).toEqual({ amount: 299, regularAmount: 299, intro: false });
  });
  it("never discounts plans without an intro price", () => {
    const bundle: Purchasable = { ...monthly, planType: "bundle", amount: 299 };
    expect(priceFor(bundle, true).intro).toBe(false);
  });
  it("never discounts items", () => {
    const item = { kind: "item", item: { amount: 79 } as ItemSpec } as Purchasable;
    expect(priceFor(item, true)).toEqual({ amount: 79, regularAmount: 79, intro: false });
  });
});
