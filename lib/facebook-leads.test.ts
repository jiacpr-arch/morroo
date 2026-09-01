import { describe, it, expect, afterEach } from "vitest";
import crypto from "crypto";
import {
  verifyWebhookSignature,
  mapFieldData,
  rewardForForm,
} from "./facebook-leads";

describe("verifyWebhookSignature", () => {
  const secret = "test_app_secret_xyz";
  const body = '{"object":"page","entry":[]}';
  const validHeader =
    "sha256=" +
    crypto.createHmac("sha256", secret).update(body, "utf8").digest("hex");

  it("accepts a valid signature", () => {
    expect(verifyWebhookSignature(body, validHeader, secret)).toBe(true);
  });

  it("rejects when the body has been tampered with", () => {
    expect(
      verifyWebhookSignature(body + "tampered", validHeader, secret)
    ).toBe(false);
  });

  it("rejects when the secret is wrong", () => {
    expect(verifyWebhookSignature(body, validHeader, "wrong_secret")).toBe(
      false
    );
  });

  it("rejects when the header is missing", () => {
    expect(verifyWebhookSignature(body, null, secret)).toBe(false);
  });

  it("rejects when the header has the wrong algo prefix", () => {
    expect(
      verifyWebhookSignature(body, "sha1=deadbeef", secret)
    ).toBe(false);
  });

  it("rejects a header with non-hex garbage of matching length", () => {
    const garbage = "sha256=" + "z".repeat(64);
    expect(verifyWebhookSignature(body, garbage, secret)).toBe(false);
  });
});

describe("mapFieldData", () => {
  it("extracts standard FB field names", () => {
    const result = mapFieldData([
      { name: "email", values: ["a@b.co"] },
      { name: "full_name", values: ["Jane Doe"] },
      { name: "phone_number", values: ["0812345678"] },
    ]);
    expect(result.email).toBe("a@b.co");
    expect(result.name).toBe("Jane Doe");
    expect(result.phone).toBe("0812345678");
  });

  it("matches Thai aliases", () => {
    const result = mapFieldData([
      { name: "อีเมล", values: ["a@b.co"] },
      { name: "ชื่อ", values: ["สมชาย"] },
    ]);
    expect(result.email).toBe("a@b.co");
    expect(result.name).toBe("สมชาย");
  });

  it("normalizes exam_target uppercase variants", () => {
    expect(
      mapFieldData([{ name: "exam_target", values: ["nl1"] }]).examTarget
    ).toBe("NL1");
    expect(
      mapFieldData([{ name: "exam_target", values: ["BOTH"] }]).examTarget
    ).toBe("both");
  });

  it("falls back to 'unknown' for unrecognized exam targets", () => {
    expect(
      mapFieldData([{ name: "exam_target", values: ["mai roo"] }]).examTarget
    ).toBe("unknown");
  });

  it("only accepts whitelisted reward_choice values", () => {
    expect(
      mapFieldData([{ name: "reward_choice", values: ["monthly_1m"] }])
        .rewardChoice
    ).toBe("monthly_1m");
    expect(
      mapFieldData([{ name: "reward_choice", values: ["free_lifetime"] }])
        .rewardChoice
    ).toBeUndefined();
  });

  it("returns undefined for missing fields", () => {
    const result = mapFieldData([]);
    expect(result.email).toBeUndefined();
    expect(result.name).toBeUndefined();
  });
});

describe("rewardForForm", () => {
  const original = process.env.FACEBOOK_LEAD_FORM_REWARDS;
  afterEach(() => {
    if (original === undefined) delete process.env.FACEBOOK_LEAD_FORM_REWARDS;
    else process.env.FACEBOOK_LEAD_FORM_REWARDS = original;
  });

  it("uses the env map when form_id matches", () => {
    process.env.FACEBOOK_LEAD_FORM_REWARDS =
      "form_a=monthly_1m,form_b=bundle_10q";
    expect(rewardForForm("form_b")).toBe("bundle_10q");
  });

  it("falls back to monthly_1m when no map or no match", () => {
    delete process.env.FACEBOOK_LEAD_FORM_REWARDS;
    expect(rewardForForm("anything")).toBe("monthly_1m");
    process.env.FACEBOOK_LEAD_FORM_REWARDS = "form_a=monthly_1m";
    expect(rewardForForm("nope")).toBe("monthly_1m");
  });

  it("ignores invalid reward values in the map", () => {
    process.env.FACEBOOK_LEAD_FORM_REWARDS = "form_a=bogus_reward";
    expect(rewardForForm("form_a")).toBe("monthly_1m");
  });
});
