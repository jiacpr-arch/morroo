/**
 * TikTok Pixel client-side helpers.
 *
 * The pixel base script is injected once in app/layout.tsx (gated on
 * NEXT_PUBLIC_TIKTOK_PIXEL_ID). These helpers are no-ops when the script
 * hasn't loaded — safe to call from any client component without checks.
 *
 * Standard event names follow TikTok's spec:
 *   https://business-api.tiktok.com/portal/docs?id=1701890979375106
 */

declare global {
  interface Window {
    ttq?: {
      track: (event: string, params?: Record<string, unknown>) => void;
      page: () => void;
      identify: (params: Record<string, unknown>) => void;
    };
  }
}

export type TikTokStandardEvent =
  | "ViewContent"
  | "ClickButton"
  | "Search"
  | "AddToWishlist"
  | "AddToCart"
  | "InitiateCheckout"
  | "AddPaymentInfo"
  | "PlaceAnOrder"
  | "CompletePayment"
  | "Contact"
  | "Download"
  | "SubmitForm"
  | "CompleteRegistration"
  | "Subscribe";

export function track(
  event: TikTokStandardEvent | string,
  params?: { value?: number; currency?: string; content_name?: string; content_id?: string }
): void {
  if (typeof window === "undefined") return;
  window.ttq?.track(event, params);
}
