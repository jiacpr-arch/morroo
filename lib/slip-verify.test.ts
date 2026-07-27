/**
 * Unit tests for slip verification: the pure validation rules and the
 * EasySlip adapter (mocked fetch).
 */
import { describe, it, expect, vi, beforeEach, afterEach } from "vitest";
import {
  maskedAccountMatches,
  validateSlip,
  verifySlip,
  type SlipData,
} from "./slip-verify";

const KBANK_ACCOUNT = "4392763940";

function makeSlip(overrides: Partial<SlipData> = {}): SlipData {
  return {
    transRef: "TX123456789",
    transTimestamp: "2026-07-27T10:00:00+07:00",
    amount: 199,
    receiverBankCode: "004",
    receiverAccountMasked: "xxx-x-x6394-x",
    receiverNameTh: "บจก. เจี่ยรักษา",
    senderNameTh: "ณัฐภัทร บ.",
    raw: {},
    ...overrides,
  };
}

const BASE_INPUT = {
  expectedAmount: 199,
  receiverBankCode: "004",
  receiverAccount: KBANK_ACCOUNT,
  maxAgeHours: 72,
  now: new Date("2026-07-27T12:00:00+07:00"),
};

describe("maskedAccountMatches", () => {
  it("matches a KBank-style mask against the full account", () => {
    expect(maskedAccountMatches("xxx-x-x6394-x", KBANK_ACCOUNT)).toBe(true);
  });

  it("matches uppercase X wildcards and no separators", () => {
    expect(maskedAccountMatches("XXXXX63940", KBANK_ACCOUNT)).toBe(true);
  });

  it("rejects when a revealed digit differs", () => {
    expect(maskedAccountMatches("xxx-x-x9999-x", KBANK_ACCOUNT)).toBe(false);
  });

  it("rejects when lengths differ", () => {
    expect(maskedAccountMatches("xxx6394", KBANK_ACCOUNT)).toBe(false);
  });

  it("rejects empty inputs", () => {
    expect(maskedAccountMatches("", KBANK_ACCOUNT)).toBe(false);
    expect(maskedAccountMatches("xxx-x-x6394-x", "")).toBe(false);
  });
});

describe("validateSlip", () => {
  it("passes a slip with exact amount, right account, fresh timestamp", () => {
    expect(validateSlip({ ...BASE_INPUT, slip: makeSlip() })).toEqual({ valid: true });
  });

  it("passes an overpaid slip", () => {
    const result = validateSlip({ ...BASE_INPUT, slip: makeSlip({ amount: 250 }) });
    expect(result.valid).toBe(true);
  });

  it("fails an underpaid slip with amount_mismatch", () => {
    const result = validateSlip({ ...BASE_INPUT, slip: makeSlip({ amount: 100 }) });
    expect(result).toMatchObject({ valid: false, code: "amount_mismatch" });
  });

  it("fails on wrong receiving bank", () => {
    const result = validateSlip({
      ...BASE_INPUT,
      slip: makeSlip({ receiverBankCode: "014" }),
    });
    expect(result).toMatchObject({ valid: false, code: "wrong_receiver" });
  });

  it("fails on wrong receiving account", () => {
    const result = validateSlip({
      ...BASE_INPUT,
      slip: makeSlip({ receiverAccountMasked: "xxx-x-x1111-x" }),
    });
    expect(result).toMatchObject({ valid: false, code: "wrong_receiver" });
  });

  it("fails when the masked account is missing", () => {
    const result = validateSlip({
      ...BASE_INPUT,
      slip: makeSlip({ receiverAccountMasked: null }),
    });
    expect(result).toMatchObject({ valid: false, code: "wrong_receiver" });
  });

  it("fails a slip older than maxAgeHours (timezone-aware)", () => {
    const result = validateSlip({
      ...BASE_INPUT,
      slip: makeSlip({ transTimestamp: "2026-07-23T10:00:00+07:00" }),
    });
    expect(result).toMatchObject({ valid: false, code: "stale_slip" });
  });

  it("accepts a slip just inside the age window", () => {
    const result = validateSlip({
      ...BASE_INPUT,
      slip: makeSlip({ transTimestamp: "2026-07-24T13:00:00+07:00" }),
    });
    expect(result.valid).toBe(true);
  });

  it("fails an unparseable timestamp as stale_slip (manual review)", () => {
    const result = validateSlip({
      ...BASE_INPUT,
      slip: makeSlip({ transTimestamp: "not-a-date" }),
    });
    expect(result).toMatchObject({ valid: false, code: "stale_slip" });
  });
});

describe("verifySlip (EasySlip adapter)", () => {
  const IMG = {
    buffer: Buffer.from("fake-image"),
    contentType: "image/jpeg",
    filename: "slip.jpg",
  };

  beforeEach(() => {
    vi.unstubAllEnvs();
    vi.stubEnv("SLIP_VERIFY_PROVIDER", "easyslip");
  });

  afterEach(() => {
    vi.unstubAllEnvs();
    vi.unstubAllGlobals();
  });

  it("returns not_configured when the token env is missing", async () => {
    vi.stubEnv("EASYSLIP_API_TOKEN", "");
    const result = await verifySlip(IMG);
    expect(result).toEqual({ ok: false, reason: "not_configured" });
  });

  it("maps a successful response into SlipData", async () => {
    vi.stubEnv("EASYSLIP_API_TOKEN", "token");
    vi.stubGlobal(
      "fetch",
      vi.fn(async () =>
        new Response(
          JSON.stringify({
            status: 200,
            data: {
              transRef: "TXREF001",
              date: "2026-07-27T10:00:00+07:00",
              amount: { amount: 199 },
              receiver: {
                bank: { id: "004" },
                account: {
                  name: { th: "บจก. เจี่ยรักษา" },
                  bank: { account: "xxx-x-x6394-x" },
                },
              },
              sender: { account: { name: { th: "ผู้โอน" } } },
            },
          }),
          { status: 200 }
        )
      )
    );

    const result = await verifySlip(IMG);
    expect(result.ok).toBe(true);
    if (result.ok) {
      expect(result.provider).toBe("easyslip");
      expect(result.slip.transRef).toBe("TXREF001");
      expect(result.slip.amount).toBe(199);
      expect(result.slip.receiverBankCode).toBe("004");
      expect(result.slip.receiverAccountMasked).toBe("xxx-x-x6394-x");
    }
  });

  it("maps a 4xx unreadable-slip response to invalid_slip", async () => {
    vi.stubEnv("EASYSLIP_API_TOKEN", "token");
    vi.stubGlobal(
      "fetch",
      vi.fn(async () =>
        new Response(JSON.stringify({ status: 400, message: "invalid image" }), {
          status: 400,
        })
      )
    );

    const result = await verifySlip(IMG);
    expect(result).toMatchObject({ ok: false, reason: "invalid_slip" });
  });

  it("maps a 5xx response to provider_error", async () => {
    vi.stubEnv("EASYSLIP_API_TOKEN", "token");
    vi.stubGlobal(
      "fetch",
      vi.fn(async () =>
        new Response(JSON.stringify({ status: 500, message: "boom" }), { status: 500 })
      )
    );

    const result = await verifySlip(IMG);
    expect(result).toMatchObject({ ok: false, reason: "provider_error" });
  });

  it("maps a network failure to provider_error", async () => {
    vi.stubEnv("EASYSLIP_API_TOKEN", "token");
    vi.stubGlobal(
      "fetch",
      vi.fn(async () => {
        throw new Error("network down");
      })
    );

    const result = await verifySlip(IMG);
    expect(result).toMatchObject({ ok: false, reason: "provider_error" });
  });
});
