import { describe, expect, it } from "vitest";
import { SIM_SCENARIOS, lcTorsion, vfArrest } from "./scenarios";
import { describeScenarioError } from "./validate";
import type { StoryNode } from "./types";

// ตรวจว่า node ทุกตัว (รวม then ซ้อน) ไม่มี fx เลย — เกมเคสต้องไม่มี CPR/shock/rhythm
function hasAnyFx(nodes: StoryNode[]): boolean {
  return nodes.some((n) => {
    if ("say" in n && n.say.fx) return true;
    if ("inter" in n && n.fx) return true;
    if ("choice" in n) {
      return n.choice.options.some((o) => o.then && hasAnyFx(o.then));
    }
    return false;
  });
}

describe("built-in sim scenarios", () => {
  it("every built-in scenario passes strict validation", () => {
    for (const s of SIM_SCENARIOS) {
      expect(describeScenarioError(s), `scenario ${s.slug}`).toBeNull();
    }
  });

  it("vfArrest is an ACLS scenario by default", () => {
    expect(vfArrest.category).toBeUndefined();
  });
});

describe("lcTorsion long case game", () => {
  it("passes strict validation", () => {
    expect(describeScenarioError(lcTorsion)).toBeNull();
  });

  it("is tagged as a longcase scenario", () => {
    expect(lcTorsion.category).toBe("longcase");
  });

  it("uses no fx anywhere (ward case, not arrest)", () => {
    expect(hasAnyFx(lcTorsion.story)).toBe(false);
  });
});
