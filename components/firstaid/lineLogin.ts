"use client";

// LINE Login — client kick-off for the server-side OAuth flow.
//
// The old SPA built the access.line.me authorize URL itself (src/utils/lineAuth.js);
// now the server route /api/firstaid/auth/line owns state/nonce and the callback.
// We only need to (1) hand the anonymous learnerId to the server via a short-lived
// cookie so the callback can reconcile pre-login progress, and (2) do a FULL-WINDOW
// redirect — popups/window.opener are unreliable inside the LINE in-app browser
// and in standalone PWA display mode.
export function startLineLogin(learnerId?: string | null) {
  if (typeof window === "undefined") return;
  if (learnerId) {
    document.cookie = `fa_learner_id=${learnerId}; path=/; max-age=600; samesite=lax`;
  }
  const next = window.location.pathname + window.location.search;
  window.location.href = `/api/firstaid/auth/line?next=${encodeURIComponent(next)}`;
}
