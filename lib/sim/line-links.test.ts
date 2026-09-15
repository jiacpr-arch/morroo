import { describe, expect, it } from "vitest";
import { CASEGAME_LINE_OA_ID, LINE_TRIAL_INTENT_LINE, lineOaTrialUrl, lineTrialMessage } from "./line-links";
import { detectTrialIntent } from "@/lib/bot-intent";

describe("lineTrialMessage", () => {
  it("keeps the bot's trigger phrase as the exact first line", () => {
    const msg = lineTrialMessage({ slug: "vf-arrest-01", grade: "S" });
    expect(msg.split("\n")[0]).toBe(LINE_TRIAL_INTENT_LINE);
  });

  it("still matches the bot's trial-intent detector after adding a source line", () => {
    // regression: lib/bot-intent.ts scans the whole message with .test(), but a
    // future edit that reorders lines or trims the trigger phrase would break
    // the bot's auto-issued trial code silently
    expect(detectTrialIntent(lineTrialMessage({ slug: "vf-arrest-01", grade: "S" }))).toBe(true);
    expect(detectTrialIntent(lineTrialMessage({ slug: "lc-testicular-torsion-01", grade: null }))).toBe(true);
  });

  it("omits the grade clause when grade is null", () => {
    const msg = lineTrialMessage({ slug: "vf-arrest-01", grade: null });
    expect(msg).not.toContain("เกรด");
    expect(msg).toContain("มาจากเกมเคส vf-arrest-01");
  });

  it("includes the grade when present", () => {
    const msg = lineTrialMessage({ slug: "vf-arrest-01", grade: "A" });
    expect(msg).toContain("เกรด A");
  });
});

describe("lineOaTrialUrl", () => {
  it("builds an oaMessage deep link to the casegame LINE OA with the encoded message", () => {
    const url = lineOaTrialUrl({ slug: "vf-arrest-01", grade: "S" });
    expect(url.startsWith(`https://line.me/R/oaMessage/${CASEGAME_LINE_OA_ID}/?`)).toBe(true);
    const decoded = decodeURIComponent(url.split("?")[1]);
    expect(decoded).toBe(lineTrialMessage({ slug: "vf-arrest-01", grade: "S" }));
  });
});
