/**
 * Admin action queue — every item in the morroo admin that is waiting for
 * the admin to do something, with a count and a link to the page where it
 * gets handled.
 *
 * Consumers:
 *  - the daily admin digest (app/api/cron/admin-digest) renders the list as
 *    the "📋 งานรอแอดมิน" section of the morning LINE push
 *  - /admin dashboard (via /api/admin/action-items) shows the same list
 *
 * Each queue is one small bounded query (count via `head: true` where the
 * oldest row isn't needed, `limit(1)` otherwise). A failing query marks only
 * its own item `failed` — it never takes the others down.
 *
 * Queues deliberately NOT included (no "handled" state, or already covered):
 *  - invoices: tax-invoice requests are processed automatically (FlowAccount +
 *    receipt email); there is no admin step or pending status
 *  - feedbacks / long_case_feedback: no handled/read column
 *  - doctor_reports / ad_diagnostics_findings / ad_suggest_prs / cron_runs:
 *    already have their own digest sections
 *  - school_questions: consumed by the school-enrich cron, not the admin
 */

import type { createAdminClient } from "@/lib/supabase/admin";

type AdminClient = ReturnType<typeof createAdminClient>;

export type ActionSeverity = "high" | "medium" | "low";

export interface AdminActionItem {
  key: string;
  /** Thai label shown in LINE and on /admin. */
  label: string;
  count: number;
  /** created_at (or equivalent) of the oldest waiting row, when known. */
  oldestAt?: string | null;
  /** Site-relative admin path, e.g. "/admin/payments". */
  path: string;
  /** Absolute URL of `path` (for LINE URI actions). */
  href: string;
  severity: ActionSeverity;
  /** True when the query for this queue failed — count is unknown (0). */
  failed?: boolean;
}

const HOUR_MS = 60 * 60 * 1000;
const DAY_MS = 24 * HOUR_MS;

/** Leads still in stage 'new' after this long are worth a nudge. */
export const LEAD_STALE_AFTER_MS = DAY_MS;
/** A pending bank-transfer slip older than this is escalated to high. */
export const PAYMENT_URGENT_AFTER_MS = 12 * HOUR_MS;
/** autopost-scheduled runs every 15 min — a pending post this late is stuck. */
export const AUTOPOST_OVERDUE_AFTER_MS = HOUR_MS;
/** Look-back for failure queues that have no "handled" state. */
export const FAILURE_WINDOW_MS = DAY_MS;
/** Organisations whose access ends within this window. */
export const ORG_EXPIRY_WINDOW_MS = 7 * DAY_MS;

/** Bound on report rows scanned for the comment moderation queue. */
const COMMENT_REPORT_SCAN_LIMIT = 2000;

export function adminSiteUrl(): string {
  const raw = (process.env.NEXT_PUBLIC_SITE_URL ?? "").trim().replace(/\/+$/, "");
  return raw || "https://www.morroo.com";
}

export function adminUrl(path: string): string {
  return `${adminSiteUrl()}${path.startsWith("/") ? path : `/${path}`}`;
}

// ─── Pure helpers ────────────────────────────────────────────────────────────

const SEVERITY_RANK: Record<ActionSeverity, number> = { high: 0, medium: 1, low: 2 };

/**
 * Items that need attention first: failed lookups and non-zero counts, then by
 * severity, then biggest queue. Zero-count items are dropped.
 */
export function sortActionItems(items: AdminActionItem[]): AdminActionItem[] {
  return items
    .filter((i) => i.failed || i.count > 0)
    .sort(
      (a, b) =>
        SEVERITY_RANK[a.severity] - SEVERITY_RANK[b.severity] ||
        b.count - a.count ||
        a.key.localeCompare(b.key)
    );
}

export function totalActionCount(items: AdminActionItem[]): number {
  return items.reduce((sum, i) => sum + (i.failed ? 0 : i.count), 0);
}

/** "5 นาที" / "3 ชม." / "4 วัน" — how long the oldest row has waited. */
export function formatWaitAge(oldestAt: string | null | undefined, now: Date): string | null {
  if (!oldestAt) return null;
  const t = Date.parse(oldestAt);
  if (Number.isNaN(t)) return null;
  const ms = Math.max(0, now.getTime() - t);
  if (ms < HOUR_MS) return `${Math.max(1, Math.round(ms / 60_000))} นาที`;
  if (ms < DAY_MS) return `${Math.floor(ms / HOUR_MS)} ชม.`;
  return `${Math.floor(ms / DAY_MS)} วัน`;
}

/** Right-hand side of a digest row: "3 · ค้าง 2 วัน", or "ตรวจไม่ได้". */
export function formatActionItemValue(item: AdminActionItem, now: Date): string {
  if (item.failed) return "ตรวจไม่ได้";
  const age = formatWaitAge(item.oldestAt, now);
  return age ? `${item.count} · ค้าง ${age}` : `${item.count}`;
}

export function severityIcon(severity: ActionSeverity): string {
  return severity === "high" ? "🔴" : severity === "medium" ? "🟡" : "⚪";
}

// ─── Queries ────────────────────────────────────────────────────────────────

interface QueueResult {
  count: number;
  oldestAt?: string | null;
  severity?: ActionSeverity;
}

interface QueueDef {
  key: string;
  label: string;
  path: string;
  severity: ActionSeverity;
  run: (admin: AdminClient, now: Date) => Promise<QueueResult>;
}

type CountResult = { count: number | null; error: unknown };
type OldestResult = {
  data: Record<string, unknown>[] | null;
  count: number | null;
  error: unknown;
};

function unwrapCount(res: CountResult): number {
  if (res.error) throw res.error;
  return res.count ?? 0;
}

function unwrapOldest(res: OldestResult, column: string): QueueResult {
  if (res.error) throw res.error;
  const first = res.data?.[0]?.[column];
  return { count: res.count ?? 0, oldestAt: typeof first === "string" ? first : null };
}

const iso = (ms: number) => new Date(ms).toISOString();

const QUEUES: QueueDef[] = [
  {
    key: "payments_pending",
    label: "สลิปโอนเงินรอตรวจ",
    path: "/admin/payments",
    severity: "medium",
    run: async (admin, now) => {
      const res = unwrapOldest(
        (await admin
          .from("payment_orders")
          .select("created_at", { count: "exact" })
          .eq("status", "pending")
          .order("created_at", { ascending: true })
          .limit(1)) as OldestResult,
        "created_at"
      );
      const old =
        res.oldestAt != null &&
        now.getTime() - Date.parse(res.oldestAt) > PAYMENT_URGENT_AFTER_MS;
      return { ...res, severity: old ? "high" : "medium" };
    },
  },
  {
    key: "comments_reported",
    label: "คอมเมนต์ถูกรายงาน/ซ่อนอัตโนมัติ",
    path: "/admin/mcq/comments",
    severity: "medium",
    run: async (admin) => {
      // Same definition as the "open" tab of /admin/mcq/comments: a comment
      // with at least one report filed after its last admin review.
      const { data: reports, error } = await admin
        .from("mcq_comment_reports")
        .select("comment_id, created_at")
        .order("created_at", { ascending: false })
        .limit(COMMENT_REPORT_SCAN_LIMIT);
      if (error) throw error;
      const rows = (reports ?? []) as { comment_id: string; created_at: string }[];
      if (rows.length === 0) return { count: 0 };

      const ids = [...new Set(rows.map((r) => r.comment_id))];
      const { data: comments, error: cErr } = await admin
        .from("mcq_comments")
        .select("id, status, moderated_at")
        .in("id", ids.slice(0, 500));
      if (cErr) throw cErr;
      const byId = new Map(
        ((comments ?? []) as { id: string; status: string; moderated_at: string | null }[]).map(
          (c) => [c.id, c]
        )
      );
      return summarizeOpenCommentReports(rows, byId);
    },
  },
  {
    key: "mcq_reports_pending",
    label: "แจ้งข้อสอบผิดรอตรวจ",
    path: "/admin/mcq/reports",
    severity: "medium",
    run: async (admin) =>
      unwrapOldest(
        (await admin
          .from("mcq_question_reports")
          .select("created_at", { count: "exact" })
          .eq("status", "pending")
          .order("created_at", { ascending: true })
          .limit(1)) as OldestResult,
        "created_at"
      ),
  },
  {
    key: "mcq_review_board",
    label: "ข้อสอบ Board รอ review",
    path: "/admin/board/review",
    severity: "medium",
    run: async (admin) =>
      unwrapOldest(
        (await admin
          .from("mcq_questions")
          .select("created_at", { count: "exact" })
          .eq("status", "review")
          .eq("audience", "board")
          .order("created_at", { ascending: true })
          .limit(1)) as OldestResult,
        "created_at"
      ),
  },
  {
    key: "mcq_review",
    label: "ข้อสอบ MCQ รอ review",
    path: "/admin/mcq",
    severity: "medium",
    run: async (admin) =>
      unwrapOldest(
        (await admin
          .from("mcq_questions")
          .select("created_at", { count: "exact" })
          .eq("status", "review")
          .or("audience.is.null,audience.neq.board")
          .order("created_at", { ascending: true })
          .limit(1)) as OldestResult,
        "created_at"
      ),
  },
  {
    key: "orgs_expiring",
    label: "องค์กรหมดอายุใน 7 วัน",
    path: "/admin/organizations",
    severity: "medium",
    run: async (admin, now) => {
      const res = (await admin
        .from("organizations")
        .select("expires_at", { count: "exact" })
        .gte("expires_at", now.toISOString())
        .lte("expires_at", iso(now.getTime() + ORG_EXPIRY_WINDOW_MS))
        .order("expires_at", { ascending: true })
        .limit(1)) as OldestResult;
      // oldestAt is a waiting age — meaningless for a future expiry date.
      return { count: unwrapOldest(res, "expires_at").count };
    },
  },
  {
    key: "autopost_failed",
    label: "โพสต์อัตโนมัติล้มเหลว (24 ชม.)",
    path: "/admin/autopost",
    severity: "medium",
    run: async (admin, now) => ({
      count: unwrapCount(
        (await admin
          .from("scheduled_autoposts")
          .select("id", { count: "exact", head: true })
          .eq("status", "failed")
          .gte("posted_at", iso(now.getTime() - FAILURE_WINDOW_MS))) as CountResult
      ),
    }),
  },
  {
    key: "autopost_overdue",
    label: "โพสต์ตั้งเวลาค้าง (เลยเวลา)",
    path: "/admin/autopost",
    severity: "medium",
    run: async (admin, now) =>
      unwrapOldest(
        (await admin
          .from("scheduled_autoposts")
          .select("scheduled_for", { count: "exact" })
          .eq("status", "pending")
          .lt("scheduled_for", iso(now.getTime() - AUTOPOST_OVERDUE_AFTER_MS))
          .order("scheduled_for", { ascending: true })
          .limit(1)) as OldestResult,
        "scheduled_for"
      ),
  },
  {
    key: "board_gen_failed",
    label: "สร้างข้อสอบ Board ล้มเหลว (24 ชม.)",
    path: "/admin/board/runs",
    severity: "low",
    run: async (admin, now) => ({
      count: unwrapCount(
        (await admin
          .from("board_gen_jobs")
          .select("id", { count: "exact", head: true })
          .eq("status", "error")
          .gte("completed_at", iso(now.getTime() - FAILURE_WINDOW_MS))) as CountResult
      ),
    }),
  },
  {
    key: "leads_new_stale",
    label: "Lead ใหม่ยังไม่ติดต่อ (>24 ชม.)",
    path: "/admin/leads",
    severity: "low",
    run: async (admin, now) =>
      unwrapOldest(
        (await admin
          .from("leads")
          .select("created_at", { count: "exact" })
          .eq("stage", "new")
          .lt("created_at", iso(now.getTime() - LEAD_STALE_AFTER_MS))
          .order("created_at", { ascending: true })
          .limit(1)) as OldestResult,
        "created_at"
      ),
  },
];

/**
 * Pure part of the comment queue: count comments with ≥1 report newer than
 * their last admin review. Auto-hidden comments (status 'hidden' with open
 * reports) bump the severity to high — content is already gone from
 * students' view and the author may have been wrongly silenced.
 */
export function summarizeOpenCommentReports(
  reports: { comment_id: string; created_at: string }[],
  comments: Map<string, { status: string; moderated_at: string | null }>
): QueueResult {
  const open = new Map<string, string>(); // comment_id → oldest open report
  for (const r of reports) {
    const c = comments.get(r.comment_id);
    if (!c) continue;
    if (c.moderated_at && Date.parse(r.created_at) <= Date.parse(c.moderated_at)) continue;
    const prev = open.get(r.comment_id);
    if (!prev || r.created_at < prev) open.set(r.comment_id, r.created_at);
  }
  let oldestAt: string | null = null;
  let anyHidden = false;
  for (const [id, at] of open) {
    if (!oldestAt || at < oldestAt) oldestAt = at;
    if (comments.get(id)?.status === "hidden") anyHidden = true;
  }
  return { count: open.size, oldestAt, severity: anyHidden ? "high" : "medium" };
}

/**
 * Run every queue in parallel. Never throws: a failing queue comes back with
 * `failed: true` and count 0. Returns ALL queues (including zero counts) in
 * definition order — use sortActionItems() for display.
 */
export async function getAdminActionItems(
  admin: AdminClient,
  now: Date = new Date()
): Promise<AdminActionItem[]> {
  const results = await Promise.allSettled(QUEUES.map((q) => q.run(admin, now)));
  return QUEUES.map((q, i) => {
    const base = {
      key: q.key,
      label: q.label,
      path: q.path,
      href: adminUrl(q.path),
      severity: q.severity,
    };
    const r = results[i];
    if (r.status === "rejected") {
      console.error(`[admin-action-items] ${q.key} failed:`, r.reason);
      return { ...base, count: 0, failed: true };
    }
    return {
      ...base,
      count: r.value.count,
      oldestAt: r.value.oldestAt ?? null,
      severity: r.value.severity ?? q.severity,
    };
  });
}
