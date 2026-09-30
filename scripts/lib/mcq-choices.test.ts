import { describe, it, expect } from "vitest";
import { normalizeMcqChoices } from "./mcq-choices.mjs";

const five = ["A", "B", "C", "D", "E"].map((label) => ({ label, text: `choice ${label}` }));

describe("normalizeMcqChoices", () => {
  it("drops a duplicated 6th choice", () => {
    expect(normalizeMcqChoices([...five, { ...five[4] }])).toEqual(five);
    expect(normalizeMcqChoices([...five, { ...five[0] }])).toEqual(five);
  });

  it("drops a blank or placeholder 6th choice", () => {
    expect(normalizeMcqChoices([...five, { label: "A", text: "" }])).toEqual(five);
    expect(normalizeMcqChoices([...five, { label: "C", text: "placeholder" }])).toEqual(five);
  });

  it("returns clean choices in A-E order", () => {
    const shuffled = [five[2], five[0], five[4], five[1], five[3]];
    expect(normalizeMcqChoices(shuffled)).toEqual(five);
  });

  it("leaves genuinely malformed sets for the DB gate to flag", () => {
    const four = five.slice(0, 4);
    expect(normalizeMcqChoices(four)).toBe(four);
    const sixDistinct = [...five, { label: "F", text: "choice F" }];
    expect(normalizeMcqChoices(sixDistinct)).toBe(sixDistinct);
    // Same label, different text: we can't tell which one the answer refers to.
    const clash = [...five.slice(0, 4), { label: "D", text: "other D" }];
    expect(normalizeMcqChoices(clash)).toBe(clash);
  });
});
