/**
 * Group / institution plans (B2B) — pure helpers + a client-safe reader.
 *
 * Tables: `organizations` / `organization_members`
 * (supabase/migrations/20260925_organizations.sql).
 *
 * Access model: a member of an unexpired organization gets every product of
 * `organizations.plan` until `organizations.expires_at`. That is expressed as
 * synthetic entitlement rows (`source = 'org'`) which the central resolver
 * (lib/membership.ts resolveAccess) unions on top of personal access — see
 * `orgEntitlementRows` and lib/entitlements.ts fetchEntitlements. Nothing is
 * persisted, so removing the member row or passing the expiry ends access
 * immediately.
 *
 * No server-only imports here: the profile page and the MEQ answer page are
 * client components and read org rows through `fetchOrgEntitlements` too.
 */

import type { SupabaseClient } from "@supabase/supabase-js";
import {
  ORG_ENTITLEMENT_SOURCE,
  PLAN_CATALOG,
  WHOLE_PRODUCT_SCOPE,
  isPlanType,
  type PlanType,
  type Product,
} from "@/lib/membership";

export type OrgRole = "owner" | "member";

export interface Organization {
  id: string;
  name: string;
  seats: number;
  plan: string;
  expires_at: string;
  join_code: string;
  created_at: string;
}

export interface OrgMembershipRow {
  org_id: string;
  role: OrgRole;
  joined_at: string;
  organizations: Pick<Organization, "id" | "name" | "plan" | "expires_at"> | null;
}

/** Default plan for a new organization: the student pack. */
export const DEFAULT_ORG_PLAN: PlanType = "yearly";

export function orgPlan(plan: string | null | undefined): PlanType {
  return isPlanType(plan) ? plan : DEFAULT_ORG_PLAN;
}

export function isOrgActive(
  org: Pick<Organization, "expires_at"> | null | undefined,
  now: Date = new Date()
): boolean {
  if (!org?.expires_at) return false;
  const t = new Date(org.expires_at).getTime();
  return Number.isFinite(t) && t > now.getTime();
}

// ----------------------------------------------------------------------------
// Entitlement merge
// ----------------------------------------------------------------------------

export interface OrgEntitlementRow {
  user_id: string;
  product: Product;
  scope: string;
  expires_at: string;
  source: typeof ORG_ENTITLEMENT_SOURCE;
  /** org id — lets admin / profile UIs say which group granted it. */
  reference: string;
  updated_at: string;
}

/**
 * Synthetic entitlement rows for a user's org memberships: one whole-product
 * row per product of each org's plan, expiring with the org. Expired orgs
 * still yield (expired) rows — harmless, because org rows are additive and
 * never switch off the legacy fallback. When two orgs grant the same product
 * only the later expiry is kept.
 */
export function orgEntitlementRows(
  userId: string,
  memberships: readonly OrgMembershipRow[] | null | undefined
): OrgEntitlementRow[] {
  const byProduct = new Map<Product, OrgEntitlementRow>();
  for (const m of memberships ?? []) {
    const org = m.organizations;
    if (!org?.expires_at) continue;
    for (const product of PLAN_CATALOG[orgPlan(org.plan)].products) {
      const prev = byProduct.get(product);
      if (prev && new Date(prev.expires_at) >= new Date(org.expires_at)) continue;
      byProduct.set(product, {
        user_id: userId,
        product,
        scope: WHOLE_PRODUCT_SCOPE,
        expires_at: org.expires_at,
        source: ORG_ENTITLEMENT_SOURCE,
        reference: org.id,
        updated_at: m.joined_at,
      });
    }
  }
  return [...byProduct.values()];
}

// eslint-disable-next-line @typescript-eslint/no-explicit-any
type AnyClient = SupabaseClient<any, any, any>;

/** The user's org memberships with their org (RLS: own rows + own orgs). */
export async function fetchOrgMemberships(
  supabase: AnyClient,
  userId: string
): Promise<OrgMembershipRow[]> {
  const { data, error } = await supabase
    .from("organization_members")
    .select("org_id, role, joined_at, organizations(id, name, plan, expires_at)")
    .eq("user_id", userId);
  if (error) {
    // Table missing (migration not applied yet) → no org access, no crash.
    console.error("fetchOrgMemberships failed:", error.message);
    return [];
  }
  return ((data ?? []) as unknown as OrgMembershipRow[]).map((r) => ({
    ...r,
    // PostgREST returns a to-one embed as an object, but be lenient.
    organizations: Array.isArray(r.organizations)
      ? ((r.organizations[0] ?? null) as OrgMembershipRow["organizations"])
      : r.organizations,
  }));
}

/** Org-derived entitlement rows for one user, ready to append to personal rows. */
export async function fetchOrgEntitlements(
  supabase: AnyClient,
  userId: string
): Promise<OrgEntitlementRow[]> {
  return orgEntitlementRows(userId, await fetchOrgMemberships(supabase, userId));
}

// ----------------------------------------------------------------------------
// Seats & join codes
// ----------------------------------------------------------------------------

export type JoinResult = "joined" | "already_member" | "not_found" | "expired" | "full";

export const JOIN_RESULT_MESSAGE: Record<JoinResult, string> = {
  joined: "เข้าร่วมกลุ่มเรียบร้อย — ใช้งานแบบพรีเมียมได้ทันที",
  already_member: "คุณเป็นสมาชิกกลุ่มนี้อยู่แล้ว",
  not_found: "ไม่พบรหัสกลุ่มนี้ กรุณาตรวจสอบลิงก์อีกครั้ง",
  expired: "แพ็กเกจของกลุ่มนี้หมดอายุแล้ว กรุณาติดต่อผู้ดูแลกลุ่ม",
  full: "ที่นั่งของกลุ่มนี้เต็มแล้ว กรุณาติดต่อผู้ดูแลกลุ่มเพื่อเพิ่มที่นั่ง",
};

export function isJoinResult(v: unknown): v is JoinResult {
  return typeof v === "string" && v in JOIN_RESULT_MESSAGE;
}

export function seatsRemaining(seats: number, memberCount: number): number {
  return Math.max(0, seats - memberCount);
}

/**
 * Pure mirror of the SQL `join_organization` checks (the RPC is the
 * authority — it re-checks under a row lock). Used to render the join page
 * before the user clicks.
 */
export function checkJoin(
  org: Pick<Organization, "seats" | "expires_at"> | null | undefined,
  memberCount: number,
  alreadyMember: boolean,
  now: Date = new Date()
): JoinResult {
  if (!org) return "not_found";
  if (alreadyMember) return "already_member";
  if (!isOrgActive(org, now)) return "expired";
  if (memberCount >= org.seats) return "full";
  return "joined";
}

/** Seats can be lowered, but never below the members already in the org. */
export function validateSeats(
  seats: unknown,
  memberCount = 0
): { ok: true; seats: number } | { ok: false; error: string } {
  const n = typeof seats === "string" ? Number(seats) : seats;
  if (typeof n !== "number" || !Number.isInteger(n) || n < 1 || n > 10000) {
    return { ok: false, error: "จำนวนที่นั่งต้องเป็นจำนวนเต็ม 1–10000" };
  }
  if (n < memberCount) {
    return { ok: false, error: `มีสมาชิกอยู่แล้ว ${memberCount} คน — ตั้งที่นั่งน้อยกว่านี้ไม่ได้` };
  }
  return { ok: true, seats: n };
}

// No 0/O/1/I — join codes get read out loud and typed from slides.
const JOIN_CODE_ALPHABET = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
export const JOIN_CODE_LENGTH = 8;

export function generateJoinCode(
  random: (n: number) => Uint8Array = (n) => crypto.getRandomValues(new Uint8Array(n))
): string {
  const bytes = random(JOIN_CODE_LENGTH);
  let out = "";
  for (let i = 0; i < JOIN_CODE_LENGTH; i++) {
    out += JOIN_CODE_ALPHABET[bytes[i] % JOIN_CODE_ALPHABET.length];
  }
  return out;
}

/** Uppercase + strip anything outside [A-Z0-9]; null when it can't be a code. */
export function normalizeJoinCode(raw: string | null | undefined): string | null {
  const code = (raw ?? "").toUpperCase().replace(/[^A-Z0-9]/g, "");
  return /^[A-Z0-9]{6,16}$/.test(code) ? code : null;
}

export function joinPath(code: string): string {
  return `/org/join/${code}`;
}

// ----------------------------------------------------------------------------
// Member progress (org owner dashboard)
// ----------------------------------------------------------------------------

export interface AttemptLite {
  user_id: string;
  is_correct: boolean | null;
  created_at: string;
}

export interface MemberProgress {
  attempts: number;
  correct: number;
  /** 0–100, rounded to 1 decimal; 0 when no attempts. */
  accuracy: number;
  lastActive: string | null;
  /** Consecutive Bangkok days with ≥1 MCQ attempt ending today or yesterday. */
  streak: number;
}

const BANGKOK_OFFSET_MS = 7 * 3600_000;
const DAY_MS = 86_400_000;

/** Day number (days since epoch) in Asia/Bangkok — Thailand has no DST. */
export function bangkokDay(iso: string | Date): number {
  const t = typeof iso === "string" ? new Date(iso).getTime() : iso.getTime();
  return Math.floor((t + BANGKOK_OFFSET_MS) / DAY_MS);
}

/**
 * Same rule as the `get_user_streak` SQL function: the latest run of
 * consecutive active days counts only if it ends today or yesterday.
 */
export function streakFromDays(days: Iterable<number>, today: number): number {
  const set = new Set(days);
  let start: number;
  if (set.has(today)) start = today;
  else if (set.has(today - 1)) start = today - 1;
  else return 0;
  let n = 0;
  while (set.has(start - n)) n++;
  return n;
}

/** Bucket MCQ attempts per member — one bulk query, not N RPC calls. */
export function summarizeMemberProgress(
  userIds: readonly string[],
  attempts: readonly AttemptLite[],
  now: Date = new Date()
): Record<string, MemberProgress> {
  const acc = new Map<string, { attempts: number; correct: number; last: number; days: Set<number> }>();
  for (const id of userIds) acc.set(id, { attempts: 0, correct: 0, last: 0, days: new Set() });
  for (const a of attempts) {
    const s = acc.get(a.user_id);
    if (!s) continue;
    const t = new Date(a.created_at).getTime();
    if (!Number.isFinite(t)) continue;
    s.attempts++;
    if (a.is_correct) s.correct++;
    if (t > s.last) s.last = t;
    s.days.add(bangkokDay(new Date(t)));
  }
  const today = bangkokDay(now);
  const out: Record<string, MemberProgress> = {};
  for (const [id, s] of acc) {
    out[id] = {
      attempts: s.attempts,
      correct: s.correct,
      accuracy: s.attempts ? Math.round((s.correct / s.attempts) * 1000) / 10 : 0,
      lastActive: s.last ? new Date(s.last).toISOString() : null,
      streak: streakFromDays(s.days, today),
    };
  }
  return out;
}

// ----------------------------------------------------------------------------
// CSV export
// ----------------------------------------------------------------------------

function csvCell(v: string | number | null | undefined): string {
  let s = v == null ? "" : String(v);
  // Neutralise spreadsheet formula injection from user-controlled names.
  if (/^[=+\-@\t\r]/.test(s)) s = `'${s}`;
  return /[",\r\n]/.test(s) ? `"${s.replace(/"/g, '""')}"` : s;
}

export function toCsv(
  header: readonly string[],
  rows: ReadonlyArray<ReadonlyArray<string | number | null | undefined>>
): string {
  return [header, ...rows].map((r) => r.map(csvCell).join(",")).join("\r\n");
}
