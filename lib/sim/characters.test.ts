import { describe, expect, it } from "vitest";
import { resolveCharacter, type SimDbCharacter } from "./characters";

const dbChar: SimDbCharacter = {
  slug: "pharmacist_pim",
  name: "เภสัชพิม",
  role: "Pharmacist",
  plate: ["#E05297", "#9C2960"],
  images: { idle: "https://x/idle.webp" },
  motion: "bob",
};

describe("resolveCharacter", () => {
  it("resolves built-in characters with placeholder and no images", () => {
    const c = resolveCharacter("nurse_mint");
    expect(c?.name).toBe("พยาบาลมิ้นท์");
    expect(c?.Placeholder).toBeDefined();
    expect(c?.images).toBeUndefined();
    expect(c?.motion).toBe("none");
  });

  it("built-in wins over db character with same slug", () => {
    const clash = new Map([["nurse_mint", { ...dbChar, slug: "nurse_mint" }]]);
    const c = resolveCharacter("nurse_mint", clash);
    expect(c?.name).toBe("พยาบาลมิ้นท์");
  });

  it("resolves db characters with images and motion", () => {
    const map = new Map([[dbChar.slug, dbChar]]);
    const c = resolveCharacter("pharmacist_pim", map);
    expect(c?.name).toBe("เภสัชพิม");
    expect(c?.images?.idle).toContain("idle.webp");
    expect(c?.motion).toBe("bob");
    expect(c?.Placeholder).toBeUndefined();
  });

  it("returns null for unknown ids", () => {
    expect(resolveCharacter("nope")).toBeNull();
  });
});
