/**
 * Bank-transfer slip verification — provider-pluggable wrapper around slip
 * verification APIs (EasySlip primary, SlipOK stub), plus the pure business
 * rules that decide whether a verified slip actually pays for a plan.
 *
 * Behavior when no provider token is configured: verifySlip() returns
 * { ok: false, reason: "not_configured" } and the submit route falls back to
 * the manual admin-review flow, so the feature is safe to deploy before the
 * owner registers with a provider.
 *
 * Env vars:
 * - SLIP_VERIFY_PROVIDER   "easyslip" (default) | "slipok"
 * - EASYSLIP_API_TOKEN     Bearer token from developer.easyslip.com
 * - SLIPOK_API_KEY         x-authorization key from slipok.com
 * - SLIPOK_BRANCH_ID       SlipOK branch id (path segment)
 * - SLIP_RECEIVER_BANK_CODE   e.g. "004" (KBank)
 * - SLIP_RECEIVER_ACCOUNT_ID  full receiving account number, digits only
 * - SLIP_MAX_AGE_HOURS     how old a slip may be, default 72
 */

export interface SlipData {
  transRef: string;
  /** ISO timestamp of the transfer (providers return +07:00 offsets). */
  transTimestamp: string;
  amount: number;
  receiverBankCode: string | null;
  /** Masked account number as printed on the slip, e.g. "xxx-x-x6394-x". */
  receiverAccountMasked: string | null;
  receiverNameTh: string | null;
  senderNameTh: string | null;
  raw: unknown;
}

export type SlipVerifyResult =
  | { ok: true; provider: string; slip: SlipData }
  | { ok: false; reason: "not_configured" }
  | { ok: false; reason: "provider_error"; detail: string }
  | { ok: false; reason: "invalid_slip"; detail: string };

export interface SlipImage {
  buffer: Buffer;
  contentType: string;
  filename: string;
}

export interface SlipVerifyProvider {
  name: string;
  isConfigured(): boolean;
  verify(img: SlipImage): Promise<SlipVerifyResult>;
}

const VERIFY_TIMEOUT_MS = 15_000;

// ─── EasySlip ────────────────────────────────────────────────────────────────

interface EasySlipResponse {
  status: number;
  data?: {
    transRef?: string;
    date?: string;
    amount?: { amount?: number };
    receiver?: {
      bank?: { id?: string };
      account?: {
        name?: { th?: string };
        bank?: { account?: string };
      };
    };
    sender?: {
      account?: { name?: { th?: string } };
    };
  };
  message?: string;
}

const easySlipProvider: SlipVerifyProvider = {
  name: "easyslip",

  isConfigured() {
    return Boolean(process.env.EASYSLIP_API_TOKEN);
  },

  async verify(img: SlipImage): Promise<SlipVerifyResult> {
    const token = process.env.EASYSLIP_API_TOKEN;
    if (!token) return { ok: false, reason: "not_configured" };

    const form = new FormData();
    form.append(
      "file",
      new Blob([new Uint8Array(img.buffer)], { type: img.contentType }),
      img.filename
    );

    let res: Response;
    try {
      res = await fetch("https://developer.easyslip.com/api/v1/verify", {
        method: "POST",
        headers: { Authorization: `Bearer ${token}` },
        body: form,
        signal: AbortSignal.timeout(VERIFY_TIMEOUT_MS),
      });
    } catch (err) {
      return {
        ok: false,
        reason: "provider_error",
        detail: `easyslip fetch failed: ${err instanceof Error ? err.message : String(err)}`,
      };
    }

    let body: EasySlipResponse;
    try {
      body = (await res.json()) as EasySlipResponse;
    } catch {
      return {
        ok: false,
        reason: "provider_error",
        detail: `easyslip non-JSON response (http ${res.status})`,
      };
    }

    // 5xx / quota problems are provider errors (→ manual review). 4xx with a
    // parseable body means the image is not a readable slip (→ also manual
    // review, but flagged differently for the admin note).
    if (res.status >= 500) {
      return {
        ok: false,
        reason: "provider_error",
        detail: `easyslip http ${res.status}: ${body.message ?? ""}`,
      };
    }
    if (!res.ok || body.status !== 200 || !body.data?.transRef) {
      return {
        ok: false,
        reason: "invalid_slip",
        detail: `easyslip status ${body.status ?? res.status}: ${body.message ?? "unreadable slip"}`,
      };
    }

    const d = body.data;
    return {
      ok: true,
      provider: "easyslip",
      slip: {
        transRef: d.transRef!,
        transTimestamp: d.date ?? "",
        amount: d.amount?.amount ?? 0,
        receiverBankCode: d.receiver?.bank?.id ?? null,
        receiverAccountMasked: d.receiver?.account?.bank?.account ?? null,
        receiverNameTh: d.receiver?.account?.name?.th ?? null,
        senderNameTh: d.sender?.account?.name?.th ?? null,
        raw: body,
      },
    };
  },
};

// ─── SlipOK (stub adapter, same interface) ──────────────────────────────────

interface SlipOkResponse {
  success?: boolean;
  data?: {
    transRef?: string;
    transTimestamp?: string;
    amount?: number;
    receivingBank?: string;
    receiver?: { account?: { value?: string }; displayName?: string };
    sender?: { displayName?: string };
  };
  message?: string;
}

const slipOkProvider: SlipVerifyProvider = {
  name: "slipok",

  isConfigured() {
    return Boolean(process.env.SLIPOK_API_KEY && process.env.SLIPOK_BRANCH_ID);
  },

  async verify(img: SlipImage): Promise<SlipVerifyResult> {
    const apiKey = process.env.SLIPOK_API_KEY;
    const branchId = process.env.SLIPOK_BRANCH_ID;
    if (!apiKey || !branchId) return { ok: false, reason: "not_configured" };

    const form = new FormData();
    form.append(
      "files",
      new Blob([new Uint8Array(img.buffer)], { type: img.contentType }),
      img.filename
    );

    let res: Response;
    try {
      res = await fetch(`https://api.slipok.com/api/line/apikey/${branchId}`, {
        method: "POST",
        headers: { "x-authorization": apiKey },
        body: form,
        signal: AbortSignal.timeout(VERIFY_TIMEOUT_MS),
      });
    } catch (err) {
      return {
        ok: false,
        reason: "provider_error",
        detail: `slipok fetch failed: ${err instanceof Error ? err.message : String(err)}`,
      };
    }

    let body: SlipOkResponse;
    try {
      body = (await res.json()) as SlipOkResponse;
    } catch {
      return {
        ok: false,
        reason: "provider_error",
        detail: `slipok non-JSON response (http ${res.status})`,
      };
    }

    if (res.status >= 500) {
      return {
        ok: false,
        reason: "provider_error",
        detail: `slipok http ${res.status}: ${body.message ?? ""}`,
      };
    }
    if (!res.ok || !body.success || !body.data?.transRef) {
      return {
        ok: false,
        reason: "invalid_slip",
        detail: `slipok: ${body.message ?? "unreadable slip"}`,
      };
    }

    const d = body.data;
    return {
      ok: true,
      provider: "slipok",
      slip: {
        transRef: d.transRef!,
        transTimestamp: d.transTimestamp ?? "",
        amount: d.amount ?? 0,
        receiverBankCode: d.receivingBank ?? null,
        receiverAccountMasked: d.receiver?.account?.value ?? null,
        receiverNameTh: d.receiver?.displayName ?? null,
        senderNameTh: d.sender?.displayName ?? null,
        raw: body,
      },
    };
  },
};

// ─── Provider selection ──────────────────────────────────────────────────────

const PROVIDERS: Record<string, SlipVerifyProvider> = {
  easyslip: easySlipProvider,
  slipok: slipOkProvider,
};

export function getSlipProvider(): SlipVerifyProvider {
  const name = process.env.SLIP_VERIFY_PROVIDER ?? "easyslip";
  return PROVIDERS[name] ?? easySlipProvider;
}

export async function verifySlip(img: SlipImage): Promise<SlipVerifyResult> {
  const provider = getSlipProvider();
  if (!provider.isConfigured()) return { ok: false, reason: "not_configured" };
  return provider.verify(img);
}

// ─── Validation rules (pure, unit-testable) ──────────────────────────────────

export type SlipValidationFailure = "amount_mismatch" | "wrong_receiver" | "stale_slip";

export interface SlipValidationInput {
  slip: SlipData;
  expectedAmount: number;
  receiverBankCode: string;
  /** Full receiving account number, digits only (e.g. "4392763940"). */
  receiverAccount: string;
  maxAgeHours: number;
  now?: Date;
}

export type SlipValidationResult =
  | { valid: true }
  | { valid: false; code: SlipValidationFailure; detail: string };

/**
 * Compare a masked account number from a slip ("xxx-x-x6394-x") against the
 * full configured account. Digits must match position-for-position from the
 * right; 'x'/'X' are wildcards. Separators are stripped. Fails safe: a
 * mismatch only sends the order to manual review, never auto-rejects.
 */
export function maskedAccountMatches(masked: string, full: string): boolean {
  const cleanMasked = masked.replace(/[^0-9xX]/g, "");
  const cleanFull = full.replace(/\D/g, "");
  if (!cleanMasked || !cleanFull) return false;
  if (cleanMasked.length !== cleanFull.length) return false;
  for (let i = 0; i < cleanMasked.length; i++) {
    const m = cleanMasked[i];
    if (m === "x" || m === "X") continue;
    if (m !== cleanFull[i]) return false;
  }
  return true;
}

export function validateSlip(input: SlipValidationInput): SlipValidationResult {
  const { slip, expectedAmount, receiverBankCode, receiverAccount, maxAgeHours } = input;
  const now = input.now ?? new Date();

  // Overpaying is fine; underpaying goes to manual review.
  if (slip.amount < expectedAmount) {
    return {
      valid: false,
      code: "amount_mismatch",
      detail: `ยอดโอน ${slip.amount} < ราคาแพ็กเกจ ${expectedAmount}`,
    };
  }

  const bankOk = slip.receiverBankCode === receiverBankCode;
  const accountOk =
    slip.receiverAccountMasked !== null &&
    maskedAccountMatches(slip.receiverAccountMasked, receiverAccount);
  if (!bankOk || !accountOk) {
    return {
      valid: false,
      code: "wrong_receiver",
      detail: `บัญชีผู้รับไม่ตรง (bank=${slip.receiverBankCode ?? "?"}, account=${slip.receiverAccountMasked ?? "?"})`,
    };
  }

  // Provider timestamps carry their own offset (+07:00), so Date parsing is
  // timezone-safe. An unparseable date goes to manual review.
  const transTime = new Date(slip.transTimestamp);
  if (Number.isNaN(transTime.getTime())) {
    return {
      valid: false,
      code: "stale_slip",
      detail: `อ่านเวลาโอนไม่ได้ (${slip.transTimestamp})`,
    };
  }
  const ageMs = now.getTime() - transTime.getTime();
  if (ageMs > maxAgeHours * 3600_000) {
    return {
      valid: false,
      code: "stale_slip",
      detail: `สลิปเก่าเกิน ${maxAgeHours} ชม. (โอนเมื่อ ${slip.transTimestamp})`,
    };
  }

  return { valid: true };
}

export function getSlipConfig() {
  return {
    receiverBankCode: process.env.SLIP_RECEIVER_BANK_CODE ?? "004",
    receiverAccount: process.env.SLIP_RECEIVER_ACCOUNT_ID ?? "4392763940",
    maxAgeHours: Number(process.env.SLIP_MAX_AGE_HOURS ?? 72),
  };
}
