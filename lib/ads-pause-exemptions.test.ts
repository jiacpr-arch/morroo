import { describe, it, expect, beforeEach, afterEach } from "vitest";
import {
  EXEMPTIONS,
  activeExemptions,
  pauseExemptAdIds,
  pauseExemptReason,
} from "./ads-pause-exemptions";

const ENV_KEY = "ADS_PAUSE_EXEMPT_AD_IDS";
const original = process.env[ENV_KEY];

beforeEach(() => {
  delete process.env[ENV_KEY];
});

afterEach(() => {
  if (original === undefined) delete process.env[ENV_KEY];
  else process.env[ENV_KEY] = original;
});

describe("checked-in exemptions", () => {
  it("holds P3 (52605554394197) with no expiry", () => {
    const entry = EXEMPTIONS.find((e) => e.adId === "52605554394197");
    expect(entry).toBeDefined();
    // A dated exemption that lapses unnoticed reintroduces the very bug this
    // list exists to prevent — P3 must be removed deliberately, not by clock.
    expect(entry?.until).toBeNull();
    expect(pauseExemptAdIds().has("52605554394197")).toBe(true);
  });

  it("exposes the reason so the finding can explain itself", () => {
    expect(pauseExemptReason("52605554394197")).toContain("P3");
    expect(pauseExemptReason("does-not-exist")).toBeNull();
  });
});

describe("env var merge", () => {
  it("adds ids from ADS_PAUSE_EXEMPT_AD_IDS", () => {
    process.env[ENV_KEY] = "111,222";
    const ids = pauseExemptAdIds();
    expect(ids.has("111")).toBe(true);
    expect(ids.has("222")).toBe(true);
    // checked-in entries survive alongside it
    expect(ids.has("52605554394197")).toBe(true);
  });

  it("tolerates whitespace and trailing commas", () => {
    process.env[ENV_KEY] = " 111 , ,222,";
    const ids = pauseExemptAdIds();
    expect(ids.has("111")).toBe(true);
    expect(ids.has("222")).toBe(true);
    expect(ids.has("")).toBe(false);
  });

  it("is a no-op when unset", () => {
    expect(pauseExemptAdIds().size).toBe(EXEMPTIONS.length);
  });
});

describe("expiry", () => {
  it("keeps undated exemptions no matter how far the clock moves", () => {
    const far = activeExemptions(new Date("2030-01-01T00:00:00Z"));
    expect(far.map((e) => e.adId)).toContain("52605554394197");
  });

  it("every checked-in entry is either undated or a valid YYYY-MM-DD", () => {
    // A malformed date would compare as a plain string and silently either
    // never expire or expire immediately; both are worse than being loud.
    for (const e of EXEMPTIONS) {
      if (e.until === null) continue;
      expect(e.until).toMatch(/^\d{4}-\d{2}-\d{2}$/);
    }
  });

  it("env-supplied ids never expire on their own", () => {
    process.env[ENV_KEY] = "999";
    expect(pauseExemptAdIds(new Date("2030-01-01T00:00:00Z")).has("999")).toBe(
      true
    );
  });
});
