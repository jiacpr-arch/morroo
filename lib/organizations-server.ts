/**
 * Service-role helpers for group / institution plans. Callers MUST check the
 * requester's rights first (requireAdmin, or `getOrgRole` === "owner") —
 * everything here bypasses RLS.
 */

import { createAdminClient } from "@/lib/supabase/admin";
import {
  generateJoinCode,
  progressFromAggregates,
  summarizeMemberProgress,
  type AttemptLite,
  type MemberProgress,
  type MemberProgressAggregate,
  type OrgRole,
  type Organization,
} from "@/lib/organizations";
import { IN_CHUNK, chunk, fetchAllPages, mapLimit } from "@/lib/paging";

export interface OrgMemberDetail {
  user_id: string;
  role: OrgRole;
  joined_at: string;
  name: string | null;
  email: string | null;
  progress: MemberProgress;
}

export interface OrgDashboardData {
  org: Organization;
  members: OrgMemberDetail[];
  /** Thai message when part of the data failed to load (shown on /org), else null. */
  loadError: string | null;
}

const ORG_COLUMNS = "id, name, seats, plan, expires_at, join_code, created_at";

export async function getOrgRole(orgId: string, userId: string): Promise<OrgRole | null> {
  const admin = createAdminClient();
  const { data } = await admin
    .from("organization_members")
    .select("role")
    .eq("org_id", orgId)
    .eq("user_id", userId)
    .maybeSingle();
  return ((data as { role?: OrgRole } | null)?.role ?? null) as OrgRole | null;
}

/** Orgs the user owns, newest first. */
export async function listOwnedOrgs(userId: string): Promise<Organization[]> {
  const admin = createAdminClient();
  const { data: rows } = await admin
    .from("organization_members")
    .select("org_id")
    .eq("user_id", userId)
    .eq("role", "owner");
  const ids = ((rows ?? []) as { org_id: string }[]).map((r) => r.org_id);
  if (ids.length === 0) return [];
  const { data } = await admin
    .from("organizations")
    .select(ORG_COLUMNS)
    .in("id", ids)
    .order("created_at", { ascending: false });
  return (data ?? []) as Organization[];
}

export async function getOrgByCode(
  code: string
): Promise<{ org: Organization; memberCount: number } | null> {
  const admin = createAdminClient();
  const { data } = await admin
    .from("organizations")
    .select(ORG_COLUMNS)
    .eq("join_code", code)
    .maybeSingle();
  if (!data) return null;
  const org = data as Organization;
  const { count } = await admin
    .from("organization_members")
    .select("user_id", { count: "exact", head: true })
    .eq("org_id", org.id);
  return { org, memberCount: count ?? 0 };
}

export async function countMembers(orgId: string): Promise<number> {
  const admin = createAdminClient();
  const { count } = await admin
    .from("organization_members")
    .select("user_id", { count: "exact", head: true })
    .eq("org_id", orgId);
  return count ?? 0;
}

/** Fallback cap per 100-member chunk when the aggregate RPC isn't deployed. */
const FALLBACK_ATTEMPTS_PER_CHUNK = 20_000;

const PROGRESS_ERROR =
  "โหลดสถิติการทำข้อสอบของสมาชิกไม่สำเร็จ ตัวเลขด้านล่างอาจไม่ครบ กรุณารีเฟรชอีกครั้ง";
const PROGRESS_PARTIAL =
  "สมาชิกบางคนมีประวัติการทำข้อสอบมากเกินกว่าจะโหลดได้ครบ ตัวเลขด้านล่างเป็นข้อมูลบางส่วน";

/** PostgREST "function not found" — migration 20260926_org_member_progress not applied yet. */
function isMissingFunction(error: { code?: string } | null): boolean {
  return error?.code === "PGRST202" || error?.code === "42883";
}

/**
 * Per-member progress. Primary path: the `org_member_progress` RPC
 * (aggregated in SQL, one jsonb row — no row cap, no giant `.in()` URL).
 * If that function isn't deployed yet, fall back to reading raw attempts in
 * 100-member chunks (4 in flight), capped per chunk. Failures are reported,
 * never silently rendered as zeros.
 */
async function fetchMemberProgress(
  orgId: string,
  userIds: string[]
): Promise<{ progress: Record<string, MemberProgress>; error: string | null }> {
  if (userIds.length === 0) return { progress: {}, error: null };
  const admin = createAdminClient();

  const { data, error } = await admin.rpc("org_member_progress", { p_org_id: orgId });
  if (!error) {
    const rows = (Array.isArray(data) ? data : []) as MemberProgressAggregate[];
    return { progress: progressFromAggregates(userIds, rows), error: null };
  }
  if (!isMissingFunction(error)) {
    console.error("org_member_progress failed:", error.message);
    return { progress: progressFromAggregates(userIds, []), error: PROGRESS_ERROR };
  }

  let failed = false;
  let truncated = false;
  const pages = await mapLimit(chunk(userIds, IN_CHUNK), 4, async (ids) => {
    const r = await fetchAllPages<AttemptLite>(
      (from, to) =>
        admin
          .from("mcq_attempts")
          .select("user_id, is_correct, created_at")
          .in("user_id", ids)
          .order("created_at", { ascending: false })
          .order("id", { ascending: true })
          .range(from, to),
      { maxRows: FALLBACK_ATTEMPTS_PER_CHUNK }
    );
    if (r.error) {
      console.error("org fetchAttempts failed:", r.error);
      failed = true;
    }
    if (r.truncated) truncated = true;
    return r.rows;
  });
  return {
    progress: summarizeMemberProgress(userIds, pages.flat()),
    error: failed ? PROGRESS_ERROR : truncated ? PROGRESS_PARTIAL : null,
  };
}

export async function loadOrgDashboard(orgId: string): Promise<OrgDashboardData | null> {
  const admin = createAdminClient();
  const [{ data: org }, memberPage] = await Promise.all([
    admin.from("organizations").select(ORG_COLUMNS).eq("id", orgId).maybeSingle(),
    // Paged: seats go up to 10000, past PostgREST's 1000-row cap.
    fetchAllPages<{ user_id: string; role: OrgRole; joined_at: string }>((from, to) =>
      admin
        .from("organization_members")
        .select("user_id, role, joined_at")
        .eq("org_id", orgId)
        .order("joined_at", { ascending: true })
        .order("user_id", { ascending: true })
        .range(from, to)
    ),
  ]);
  if (!org) return null;
  if (memberPage.error) console.error("org members load failed:", memberPage.error);
  const members = memberPage.rows;
  const ids = members.map((m) => m.user_id);

  let profilesFailed = false;
  const [profilePages, progress] = await Promise.all([
    mapLimit(chunk(ids, IN_CHUNK), 4, async (chunkIds) => {
      const { data, error } = await admin
        .from("profiles")
        .select("id, name, email")
        .in("id", chunkIds);
      if (error) {
        console.error("org member profiles failed:", error.message);
        profilesFailed = true;
      }
      return (data ?? []) as { id: string; name: string | null; email: string | null }[];
    }),
    fetchMemberProgress(orgId, ids),
  ]);
  const byId = new Map(profilePages.flat().map((p) => [p.id, p]));

  const loadError = memberPage.error
    ? "โหลดรายชื่อสมาชิกไม่สำเร็จ รายชื่อด้านล่างอาจไม่ครบ กรุณารีเฟรชอีกครั้ง"
    : (progress.error ??
      (profilesFailed ? "โหลดชื่อ/อีเมลของสมาชิกบางคนไม่สำเร็จ กรุณารีเฟรชอีกครั้ง" : null));

  return {
    org: org as Organization,
    members: members.map((m) => ({
      ...m,
      name: byId.get(m.user_id)?.name ?? null,
      email: byId.get(m.user_id)?.email ?? null,
      progress: progress.progress[m.user_id],
    })),
    loadError,
  };
}

/** Insert with a fresh join code, retrying on the (unlikely) unique clash. */
export async function insertOrgWithCode(
  row: Omit<Organization, "id" | "join_code" | "created_at"> & {
    note?: string | null;
    created_by?: string | null;
  }
): Promise<{ org: Organization | null; error: string | null }> {
  const admin = createAdminClient();
  for (let i = 0; i < 5; i++) {
    const { data, error } = await admin
      .from("organizations")
      .insert({ ...row, join_code: generateJoinCode() })
      .select(ORG_COLUMNS)
      .single();
    if (!error) return { org: data as Organization, error: null };
    if (error.code !== "23505") return { org: null, error: error.message };
  }
  return { org: null, error: "join_code_collision" };
}

export async function regenerateJoinCode(orgId: string): Promise<string | null> {
  const admin = createAdminClient();
  for (let i = 0; i < 5; i++) {
    const code = generateJoinCode();
    const { error } = await admin.from("organizations").update({ join_code: code }).eq("id", orgId);
    if (!error) return code;
    if (error.code !== "23505") {
      console.error("regenerateJoinCode failed:", error.message);
      return null;
    }
  }
  return null;
}

/** Find a profile by email (case-insensitive, exact). */
export async function findProfileByEmail(
  email: string
): Promise<{ id: string; email: string | null; name: string | null } | null> {
  const clean = email.trim();
  if (!clean || !clean.includes("@")) return null;
  const admin = createAdminClient();
  // Escape LIKE wildcards — `_` is common in emails.
  const pattern = clean.replace(/[\\%_]/g, (c) => `\\${c}`);
  const { data } = await admin
    .from("profiles")
    .select("id, email, name")
    .ilike("email", pattern)
    .limit(1)
    .maybeSingle();
  return (data as { id: string; email: string | null; name: string | null } | null) ?? null;
}

/**
 * Make `userId` an owner of the org (upsert — an existing member is promoted).
 * Admin action, so it is allowed to go over the seat count; the admin UI
 * warns when it does.
 */
export async function assignOwner(orgId: string, userId: string): Promise<string | null> {
  const admin = createAdminClient();
  const { error } = await admin
    .from("organization_members")
    .upsert({ org_id: orgId, user_id: userId, role: "owner" }, { onConflict: "org_id,user_id" });
  return error ? error.message : null;
}
