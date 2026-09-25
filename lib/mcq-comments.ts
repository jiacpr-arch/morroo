// Shared, framework-free logic for MCQ discussion threads
// (tables: mcq_comments / mcq_comment_votes / mcq_comment_reports —
// see supabase/migrations/20260925_mcq_discussions.sql).
//
// Kept pure so both the API routes and the client component can use it and
// it can be unit-tested without Supabase.

export const COMMENT_MIN_LENGTH = 1;
export const COMMENT_MAX_LENGTH = 2000;

/** Reports at or above this count auto-hide a comment (DB trigger). */
export const AUTO_HIDE_REPORT_THRESHOLD = 3;

// Keep in sync with the CHECK constraint on mcq_comment_reports.reason.
export const COMMENT_REPORT_REASONS = [
  "spam",
  "offensive",
  "spoiler",
  "misinformation",
  "other",
] as const;
export type CommentReportReason = (typeof COMMENT_REPORT_REASONS)[number];

export const COMMENT_REPORT_REASON_LABELS: Record<CommentReportReason, string> = {
  spam: "สแปม / โฆษณา",
  offensive: "ไม่สุภาพ / คุกคาม",
  spoiler: "เปิดเผยเฉลยข้ออื่น",
  misinformation: "ข้อมูลทางการแพทย์ผิด",
  other: "อื่น ๆ",
};

export type CommentStatus = "visible" | "hidden";

const UUID_RE =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

export function isUuid(value: unknown): value is string {
  return typeof value === "string" && UUID_RE.test(value);
}

type Result<T> = { ok: true; value: T } | { ok: false; error: string };

/**
 * Normalises and validates a comment body. Trims surrounding whitespace,
 * normalises Windows newlines and collapses runs of 3+ blank lines so a
 * single comment can't push the thread off-screen.
 */
export function validateCommentBody(raw: unknown): Result<string> {
  if (typeof raw !== "string") {
    return { ok: false, error: "กรุณาพิมพ์ข้อความ" };
  }
  const body = raw
    .replace(/\r\n?/g, "\n")
    .replace(/\n{3,}/g, "\n\n")
    .trim();
  if (body.length < COMMENT_MIN_LENGTH) {
    return { ok: false, error: "กรุณาพิมพ์ข้อความ" };
  }
  if (body.length > COMMENT_MAX_LENGTH) {
    return {
      ok: false,
      error: `ข้อความยาวเกิน ${COMMENT_MAX_LENGTH.toLocaleString("en-US")} ตัวอักษร`,
    };
  }
  return { ok: true, value: body };
}

export interface CreateCommentInput {
  question_id: string;
  parent_id: string | null;
  body: string;
}

/** Validates the POST /api/mcq/comments payload. */
export function validateCreateComment(input: unknown): Result<CreateCommentInput> {
  if (!input || typeof input !== "object") {
    return { ok: false, error: "Invalid JSON body" };
  }
  const { question_id, parent_id, body } = input as Record<string, unknown>;
  if (!isUuid(question_id)) {
    return { ok: false, error: "question_id ไม่ถูกต้อง" };
  }
  if (parent_id !== undefined && parent_id !== null && !isUuid(parent_id)) {
    return { ok: false, error: "parent_id ไม่ถูกต้อง" };
  }
  const b = validateCommentBody(body);
  if (!b.ok) return b;
  return {
    ok: true,
    value: {
      question_id,
      parent_id: (parent_id as string | null | undefined) ?? null,
      body: b.value,
    },
  };
}

export function validateReportReason(raw: unknown): Result<CommentReportReason> {
  if (
    typeof raw === "string" &&
    (COMMENT_REPORT_REASONS as readonly string[]).includes(raw)
  ) {
    return { ok: true, value: raw as CommentReportReason };
  }
  return {
    ok: false,
    error: `reason must be one of: ${COMMENT_REPORT_REASONS.join(", ")}`,
  };
}

export const ANONYMOUS_DISPLAY_NAME = "สมาชิก morroo";

/**
 * Public display name for a commenter. Follows the leaderboard convention
 * (first word + initial of the second, e.g. "Alice S.") but never falls back
 * to the email address — comments are visible to every signed-in user.
 */
export function publicDisplayName(name: string | null | undefined): string {
  const clean = (name ?? "").replace(/\s+/g, " ").trim();
  if (!clean || clean.includes("@")) return ANONYMOUS_DISPLAY_NAME;
  const [first, second] = clean.split(" ");
  const firstPart = first.slice(0, 40);
  if (!second) return firstPart;
  return `${firstPart} ${Array.from(second)[0]}.`;
}

/** First grapheme-ish character for the avatar bubble. */
export function avatarInitial(displayName: string): string {
  const ch = Array.from(displayName.trim())[0];
  return ch ? ch.toUpperCase() : "?";
}

// ---------------------------------------------------------------------------
// Threading
// ---------------------------------------------------------------------------

export interface CommentRow {
  id: string;
  question_id: string;
  user_id: string;
  parent_id: string | null;
  body: string;
  created_at: string;
  edited_at: string | null;
  status: CommentStatus;
  upvotes: number;
}

/** What the API sends to the browser — no raw user_id/email. */
export interface PublicComment {
  id: string;
  parent_id: string | null;
  body: string;
  created_at: string;
  edited_at: string | null;
  status: CommentStatus;
  upvotes: number;
  author: { name: string; initial: string; is_admin: boolean };
  is_mine: boolean;
  has_voted: boolean;
}

export interface CommentThread extends PublicComment {
  replies: PublicComment[];
}

/** Top-level order: most upvoted first, then newest. */
export function compareTopLevel(
  a: Pick<CommentRow, "upvotes" | "created_at">,
  b: Pick<CommentRow, "upvotes" | "created_at">
): number {
  if (b.upvotes !== a.upvotes) return b.upvotes - a.upvotes;
  return Date.parse(b.created_at) - Date.parse(a.created_at);
}

/**
 * Replies read as a conversation: most upvoted first, then oldest first so
 * the back-and-forth stays in order among equally-voted replies.
 */
export function compareReplies(
  a: Pick<CommentRow, "upvotes" | "created_at">,
  b: Pick<CommentRow, "upvotes" | "created_at">
): number {
  if (b.upvotes !== a.upvotes) return b.upvotes - a.upvotes;
  return Date.parse(a.created_at) - Date.parse(b.created_at);
}

/**
 * Groups a flat list into top-level threads with one level of replies.
 * Replies whose parent isn't in the list (e.g. parent hidden and not ours)
 * are dropped rather than promoted, so hidden context doesn't leak.
 */
export function buildThreads<T extends PublicComment>(
  comments: T[]
): (T & { replies: T[] })[] {
  const tops = new Map<string, T & { replies: T[] }>();
  for (const c of comments) {
    if (!c.parent_id) tops.set(c.id, { ...c, replies: [] });
  }
  for (const c of comments) {
    if (c.parent_id) tops.get(c.parent_id)?.replies.push(c);
  }
  const threads = [...tops.values()].sort(compareTopLevel);
  for (const t of threads) t.replies.sort(compareReplies);
  return threads;
}

/** Count shown in the "💬 อภิปราย (N)" header: visible comments + replies. */
export function countVisible(threads: CommentThread[]): number {
  let n = 0;
  for (const t of threads) {
    if (t.status === "visible") n += 1;
    for (const r of t.replies) if (r.status === "visible") n += 1;
  }
  return n;
}

/** Thai relative time — "เมื่อสักครู่", "5 นาทีที่แล้ว", … */
export function relativeTimeTh(iso: string, now: number = Date.now()): string {
  const diffSec = Math.max(0, Math.floor((now - Date.parse(iso)) / 1000));
  if (diffSec < 60) return "เมื่อสักครู่";
  const min = Math.floor(diffSec / 60);
  if (min < 60) return `${min} นาทีที่แล้ว`;
  const hr = Math.floor(min / 60);
  if (hr < 24) return `${hr} ชั่วโมงที่แล้ว`;
  const day = Math.floor(hr / 24);
  if (day < 30) return `${day} วันที่แล้ว`;
  return new Date(iso).toLocaleDateString("th-TH", {
    day: "numeric",
    month: "short",
    year: "2-digit",
  });
}
