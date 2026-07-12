// Shared class-string constants for the ported ACLS/BLS course components.
//
// The source app (acls-emr) styled these with a custom design-token CSS layer
// (dash-card, btn btn-primary, text-headline, bg-bg-secondary, --radius-*).
// morroo is Tailwind v4 + shadcn tokens, so the tokens are translated here
// once and reused by every ported component to keep the look consistent.

// --- surfaces ---
export const dashCard =
  "rounded-xl border border-border bg-card p-4 shadow-sm dark:bg-card";

export const modalOverlay =
  "fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4 backdrop-blur-sm";

export const modalPanel =
  "w-full max-w-md space-y-4 rounded-2xl border border-border bg-card p-5 shadow-xl";

// --- typography (source: text-headline / text-caption / text-2xs / …) ---
export const textHeadline = "text-base font-bold text-foreground";
export const textOverline =
  "text-[11px] font-semibold uppercase tracking-wider text-muted-foreground";
export const text2xs = "text-[11px]";
export const textCaption = "text-xs";

// --- buttons (source: btn btn-primary btn-block etc.) ---
export const btnBase =
  "inline-flex items-center justify-center gap-1.5 rounded-lg font-semibold transition-colors disabled:cursor-not-allowed disabled:opacity-50";
export const btnPrimary = `${btnBase} bg-blue-600 text-white hover:bg-blue-700`;
export const btnWarning = `${btnBase} bg-amber-500 text-white hover:bg-amber-600`;
export const btnSuccess = `${btnBase} bg-emerald-600 text-white hover:bg-emerald-700`;
export const btnGhost = `${btnBase} text-muted-foreground hover:bg-muted hover:text-foreground`;
export const btnMd = "px-4 py-2.5 text-sm";
export const btnSm = "px-2.5 py-1.5 text-xs";
export const btnLg = "px-4 py-3 text-sm";
export const btnXl = "px-5 py-3.5 text-base";
export const btnBlock = "w-full";

// --- form inputs ---
export const inputBase =
  "w-full rounded-lg border border-border bg-background px-3 py-2 text-foreground outline-none placeholder:text-muted-foreground/60 focus:border-blue-500 focus:ring-2 focus:ring-blue-500/30";

// --- semantic tones (source: success / warning / info / danger tokens) ---
export const errorBox =
  "inline-flex w-full items-center gap-2 rounded-lg border border-red-500/30 bg-red-500/10 p-2 text-xs text-red-600 dark:text-red-400";

// LINE OA add-friend link used by the voucher gate (from acls-emr's
// jiacprCourse.lineUrl).
export const COURSE_LINE_URL = "https://line.me/R/ti/p/@jiacpr";
