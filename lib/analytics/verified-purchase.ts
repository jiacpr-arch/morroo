import { trackPurchase } from "./conversions";

const trackedInPage = new Set<string>();

/** Only call with the authenticated billing/verify response, never URL amounts. */
export function trackVerifiedPurchase(sessionId: string, data: {
  status?: string;
  amount?: number;
  currency?: string;
}): data is { status: "ok"; amount: number; currency: string } {
  if (typeof window === "undefined" || data.status !== "ok" || !sessionId ||
      typeof data.amount !== "number" || !Number.isFinite(data.amount) || data.amount < 0 ||
      !data.currency || !/^[A-Z]{3}$/.test(data.currency)) return false;

  const key = `purchase_tracked:${sessionId}`;
  if (trackedInPage.has(key)) return false;
  try {
    if (window.sessionStorage.getItem(key) !== null) return false;
  } catch { /* Storage restrictions must not turn a paid order into an error. */ }

  trackPurchase({ transactionId: sessionId, value: data.amount, currency: data.currency });
  trackedInPage.add(key);
  try {
    window.sessionStorage.setItem(key, "1");
  } catch { /* GA4 also receives the stable transaction_id for deduplication. */ }
  return true;
}
