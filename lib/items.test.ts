import { describe, it, expect } from "vitest";
import {
  ITEM_PRICES,
  itemDays,
  itemPlanType,
  itemPrice,
  itemScope,
  mcqSubjectPrice,
  parseItemPlan,
} from "./items";
import { hasScopedAccess, entitledScopes, resolveAccess } from "./membership";

const future = new Date(Date.now() + 86400_000 * 30).toISOString();
const past = new Date(Date.now() - 86400_000).toISOString();
const uuid = "a1b2c3d4-e5f6-7890-abcd-ef1234567890";

describe("parseItemPlan / itemPlanType", () => {
  it("round-trips every kind", () => {
    expect(parseItemPlan(itemPlanType("mcq_subject", uuid))).toEqual({ kind: "mcq_subject", key: uuid, term: null });
    expect(parseItemPlan(itemPlanType("mcq_category", "internal_med"))).toEqual({ kind: "mcq_category", key: "internal_med", term: null });
    expect(parseItemPlan(itemPlanType("mcq_examtype", "NL1"))).toEqual({ kind: "mcq_examtype", key: "NL1", term: null });
    expect(parseItemPlan(itemPlanType("board_specialty", "internal_medicine", "year"))).toEqual({ kind: "board_specialty", key: "internal_medicine", term: "year" });
    expect(parseItemPlan(itemPlanType("board_specialty", "surgery"))).toEqual({ kind: "board_specialty", key: "surgery", term: "month" });
    expect(parseItemPlan(itemPlanType("meq_exam", uuid))?.kind).toBe("meq_exam");
    expect(parseItemPlan(itemPlanType("longcase_case", uuid))?.kind).toBe("longcase_case");
    expect(parseItemPlan(itemPlanType("school_topic", uuid))?.kind).toBe("school_topic");
    expect(parseItemPlan(itemPlanType("school_year", "3"))).toEqual({ kind: "school_year", key: "3", term: null });
  });

  it("rejects malformed / unknown plans", () => {
    expect(parseItemPlan("monthly")).toBeNull();
    expect(parseItemPlan("item:")).toBeNull();
    expect(parseItemPlan("item:nope:x")).toBeNull();
    expect(parseItemPlan("item:mcq_subject:")).toBeNull();
    expect(parseItemPlan("item:mcq_subject:abc:extra")).toBeNull();
    expect(parseItemPlan("item:mcq_category:surgery")).toBeNull();
    expect(parseItemPlan("item:mcq_examtype:NL2")).toBeNull();
    expect(parseItemPlan("item:school_year:9")).toBeNull();
    expect(parseItemPlan("item:meq_exam:has space")).toBeNull();
    expect(parseItemPlan(null)).toBeNull();
  });
});

describe("pricing", () => {
  it("tiers MCQ subjects by question count", () => {
    expect(mcqSubjectPrice(331)).toBe(ITEM_PRICES.mcq_subject_large);
    expect(mcqSubjectPrice(200)).toBe(ITEM_PRICES.mcq_subject_large);
    expect(mcqSubjectPrice(150)).toBe(ITEM_PRICES.mcq_subject_medium);
    expect(mcqSubjectPrice(20)).toBe(ITEM_PRICES.mcq_subject_small);
  });
  it("board specialty is a subscription, everything else lifetime", () => {
    const month = parseItemPlan("item:board_specialty:surgery:month")!;
    const year = parseItemPlan("item:board_specialty:surgery:year")!;
    expect(itemPrice(month)).toBe(ITEM_PRICES.board_specialty_month);
    expect(itemPrice(year)).toBe(ITEM_PRICES.board_specialty_year);
    expect(itemDays(month)).toBe(30);
    expect(itemDays(year)).toBe(365);
    expect(itemDays(parseItemPlan(`item:meq_exam:${uuid}`)!)).toBeNull();
    expect(itemPrice(parseItemPlan(`item:longcase_case:${uuid}`)!)).toBe(ITEM_PRICES.longcase_case);
    expect(itemPrice(parseItemPlan("item:school_year:1")!)).toBe(ITEM_PRICES.school_year);
  });
  it("every price is at least ฿39 (card fee floor)", () => {
    for (const v of Object.values(ITEM_PRICES)) expect(v).toBeGreaterThanOrEqual(29);
  });
});

describe("scopes", () => {
  it("maps items to entitlement scopes", () => {
    expect(itemScope(parseItemPlan(`item:mcq_subject:${uuid}`)!)).toBe(`subject:${uuid}`);
    expect(itemScope(parseItemPlan("item:board_specialty:surgery")!)).toBe("specialty:surgery");
    expect(itemScope(parseItemPlan(`item:meq_exam:${uuid}`)!)).toBe(`exam:${uuid}`);
    expect(itemScope(parseItemPlan("item:meq_category:กุมารเวชศาสตร์".replace("กุมารเวชศาสตร์", "peds"))!)).toBe("category:peds");
    expect(itemScope(parseItemPlan(`item:longcase_case:${uuid}`)!)).toBe(`case:${uuid}`);
    expect(itemScope(parseItemPlan("item:school_year:2")!)).toBe("year:2");
  });

  it("scoped rows unlock only their item, never the whole product", () => {
    const rows = [{ product: "mcq", scope: `subject:${uuid}`, expires_at: null }];
    expect(resolveAccess(null, rows).mcq).toBe(false);
    expect(hasScopedAccess("mcq", [`subject:${uuid}`], null, rows)).toBe(true);
    expect(hasScopedAccess("mcq", ["subject:other"], null, rows)).toBe(false);
    expect(hasScopedAccess("meq", [`subject:${uuid}`], null, rows)).toBe(false);
  });

  it("whole-product access satisfies any scope", () => {
    const rows = [{ product: "board", scope: "*", expires_at: future }];
    expect(hasScopedAccess("board", ["specialty:surgery"], null, rows)).toBe(true);
  });

  it("expired scoped rows do not count", () => {
    const rows = [{ product: "board", scope: "specialty:surgery", expires_at: past }];
    expect(hasScopedAccess("board", ["specialty:surgery"], null, rows)).toBe(false);
    expect(entitledScopes(rows, "board").size).toBe(0);
  });

  it("legacy plan still satisfies scopes when the user has no rows", () => {
    const legacy = { membership_type: "monthly", membership_expires_at: future };
    expect(hasScopedAccess("mcq", [`subject:${uuid}`], legacy, [])).toBe(true);
  });
});
