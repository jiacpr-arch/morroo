/**
 * Long Case investigation results may carry an image (ECG strip, CXR film…)
 * alongside the text report. Both fields are optional so older cases that
 * only store `{ value, isAbnormal }` keep working unchanged.
 */
export interface LongCaseResult {
  value: string;
  isAbnormal: boolean;
  /** https:// URL or site-relative path (e.g. /images/longcase/ecg-stemi.webp) */
  image_url?: string;
  /** Source / license attribution shown under the image */
  image_credit?: string;
}

/**
 * Accept only https URLs and site-relative paths. Case JSON is hand-edited
 * by admins, so guard against `javascript:` / `data:` / protocol-relative
 * values ending up in an <img src> or <a href>.
 */
export function safeImageUrl(raw: unknown): string | undefined {
  if (typeof raw !== "string") return undefined;
  const url = raw.trim();
  if (!url) return undefined;
  if (url.startsWith("/") && !url.startsWith("//")) return url;
  try {
    return new URL(url).protocol === "https:" ? url : undefined;
  } catch {
    return undefined;
  }
}

/** Normalize a raw result entry (string or object) into a LongCaseResult. */
export function toLongCaseResult(raw: unknown): LongCaseResult | undefined {
  if (typeof raw === "string") return raw ? { value: raw, isAbnormal: false } : undefined;
  if (!raw || typeof raw !== "object") return undefined;
  const o = raw as Record<string, unknown>;
  const value = typeof o.value === "string" ? o.value : "";
  const image_url = safeImageUrl(o.image_url);
  if (!value && !image_url) return undefined;
  const credit = typeof o.image_credit === "string" ? o.image_credit.trim() : "";
  return {
    value,
    isAbnormal: o.isAbnormal === true,
    ...(image_url ? { image_url } : {}),
    ...(image_url && credit ? { image_credit: credit } : {}),
  };
}
