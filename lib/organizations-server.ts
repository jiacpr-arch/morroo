/**
 * Service-role helpers for group / institution plans. Callers MUST check the
 * requester's rights first (requireAdmin, or `getOrgRole` === "owner") —
 * everything here bypasses RLS.
 */

import { createAdminClient } from "@/lib/supabase/admin";
import {
  generateJoinCode,
  summarizeMemberProgress,
  type AttemptLite,
  type MemberProgress,
  type OrgRole,
  type Organization,
} from "@/lib/organizations";

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

const ATTEMPT_PAGE = 1000;
const ATTEMPT_MAX = 100_000;

/**
 * Every MCQ attempt for these users, paged past PostgREST's 1000-row cap.
 * Only the three columns the dashboard needs.
 */
async function fetchAttempts(userIds: string[]): Promise<AttemptLite[]> {
  if (userIds.length === 0) return [];
  const admin = createAdminClient();
  const out: AttemptLite[] = [];
  for (let from = 0; from < ATTEMPT_MAX; from += ATTEMPT_PAGE) {
    const { data, error } = await admin
      .from("mcq_attempts")
      .select("user_id, is_correct, created_at")
      .in("user_id", userIds)
      .order("created_at", { ascending: false })
      .range(from, from + ATTEMPT_PAGE - 1);
    if (error) {
      console.error("org fetchAttempts failed:", error.message);
      break;
    }
    const page = (data ?? []) as AttemptLite[];
    out.push(...page);
    if (page.length < ATTEMPT_PAGE) break;
  }
  return out;
}

export async function loadOrgDashboard(orgId: string): Promise<OrgDashboardData | null> {
  const admin = createAdminClient();
  const [{ data: org }, { data: memberRows }] = await Promise.all([
    admin.from("organizations").select(ORG_COLUMNS).eq("id", orgId).maybeSingle(),
    admin
      .from("organization_members")
      .select("user_id, role, joined_at")
      .eq("org_id", orgId)
      .order("joined_at", { ascending: true }),
  ]);
  if (!org) return null;
  const members = (memberRows ?? []) as { user_id: string; role: OrgRole; joined_at: string }[];
  const ids = members.map((m) => m.user_id);

  const [{ data: profiles }, attempts] = await Promise.all([
    ids.length
      ? admin.from("profiles").select("id, name, email").in("id", ids)
      : Promise.resolve({ data: [] }),
    fetchAttempts(ids),
  ]);
  const byId = new Map(
    ((profiles ?? []) as { id: string; name: string | null; email: string | null }[]).map((p) => [p.id, p])
  );
  const progress = summarizeMemberProgress(ids, attempts);

  return {
    org: org as Organization,
    members: members.map((m) => ({
      ...m,
      name: byId.get(m.user_id)?.name ?? null,
      email: byId.get(m.user_id)?.email ?? null,
      progress: progress[m.user_id],
    })),
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
