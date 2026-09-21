/**
 * Ads that auto-pause must never touch.
 *
 * The nightly ads-autofix cron (app/api/cron/ads-autofix) pauses ads that
 * trip a threshold in diagnoseAds(). That is the right default, but it has
 * no memory of intent: an ad re-enabled by hand is ACTIVE again by the next
 * run, trips the same threshold, and gets paused again. Ad 52605554394197
 * went through exactly that loop on 2026-09-17 and again on 2026-09-19.
 *
 * This file is the exemption list. An exempt ad is still diagnosed and still
 * reported in the morning digest — it just never gets an autoAction, so the
 * admin keeps seeing the numbers while staying in control of the switch.
 *
 * Two sources, merged:
 *   1. EXEMPTIONS below — checked in, reviewable, survives a redeploy.
 *   2. ADS_PAUSE_EXEMPT_AD_IDS — comma-separated ad ids, for adding one
 *      mid-incident without shipping a commit.
 *
 * Deliberately not a Supabase table: the list is short, changes rarely, and
 * belongs in review alongside the thresholds it overrides.
 */

export interface PauseExemption {
  adId: string;
  /** Why this ad is hand-held — shown in the finding, so keep it short. */
  reason: string;
  /**
   * ISO date (YYYY-MM-DD) after which the exemption lapses and auto-pause
   * resumes, or null to hold it until someone removes the entry.
   *
   * Prefer null for anything you would not want silently un-protected: an
   * expiry that passes unnoticed looks exactly like the bug this file fixes.
   */
  until: string | null;
}

export const EXEMPTIONS: PauseExemption[] = [
  {
    adId: "52605554394197",
    reason: "กำลังทดสอบ P3 — ห้าม auto-pause ระหว่างเก็บผล",
    until: null,
  },
];

function fromEnv(): PauseExemption[] {
  const raw = process.env.ADS_PAUSE_EXEMPT_AD_IDS;
  if (!raw) return [];
  return raw
    .split(",")
    .map((s) => s.trim())
    .filter(Boolean)
    .map((adId) => ({
      adId,
      reason: "ยกเว้นผ่าน ADS_PAUSE_EXEMPT_AD_IDS",
      until: null,
    }));
}

/**
 * Exemptions in force at `now`. Entries past their `until` date are dropped,
 * so a lapsed exemption behaves as if it were never there.
 */
export function activeExemptions(now: Date = new Date()): PauseExemption[] {
  const today = now.toISOString().slice(0, 10);
  return [...EXEMPTIONS, ...fromEnv()].filter(
    (e) => e.until == null || e.until >= today
  );
}

/** Ad ids currently exempt from auto-pause. */
export function pauseExemptAdIds(now: Date = new Date()): Set<string> {
  return new Set(activeExemptions(now).map((e) => e.adId));
}

/** The reason an ad is exempt, or null when auto-pause may proceed. */
export function pauseExemptReason(
  adId: string,
  now: Date = new Date()
): string | null {
  return activeExemptions(now).find((e) => e.adId === adId)?.reason ?? null;
}
