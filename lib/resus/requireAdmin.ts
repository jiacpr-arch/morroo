import { getSupabaseAdmin } from "./supabaseAdmin";

// A valid JWT alone is not enough: any Supabase user of the "emr-ai-clinic"
// project would pass auth.getUser(), so the admin identity must also be on
// this allowlist. Override via ACLS_ADMIN_EMAILS (comma-separated,
// case-insensitive). Shared by both the ACLS and BLS admin panels — same
// Supabase project, same single admin account.
//
// admin@acls-emr.local is the shared admin login account (ported from the
// acls-emr Vite app's src/services/auth.js) — it is only safe on this list
// while that account exists in Supabase Auth, which blocks anyone else from
// registering the same address. If that account is ever deleted, remove it
// here too (or set ACLS_ADMIN_EMAILS) in the same change.
const DEFAULT_ADMIN_EMAILS = "admin@acls-emr.local,jiacpr@gmail.com";

export function getAdminEmails(env: NodeJS.ProcessEnv = process.env): string[] {
  return (env.ACLS_ADMIN_EMAILS || DEFAULT_ADMIN_EMAILS)
    .split(",")
    .map((e) => e.trim().toLowerCase())
    .filter(Boolean);
}

export class AdminAuthError extends Error {
  status: 401 | 403;
  constructor(message: string, status: 401 | 403) {
    super(message);
    this.status = status;
  }
}

/**
 * Verifies the request carries a valid Supabase JWT belonging to an
 * allowlisted admin. Returns the user on success; throws AdminAuthError with
 * status 401 (bad/missing token) or 403 (valid user, not an admin).
 *
 * Callers send: Authorization: Bearer <session.access_token>
 */
export async function requireAdmin(request: Request) {
  const auth = request.headers.get("authorization");
  if (!auth || !auth.startsWith("Bearer ")) {
    throw new AdminAuthError("Missing or malformed Authorization header", 401);
  }
  const token = auth.slice("Bearer ".length).trim();
  const { data, error } = await getSupabaseAdmin().auth.getUser(token);
  if (error || !data?.user) {
    throw new AdminAuthError("Invalid or expired session", 401);
  }
  const email = (data.user.email || "").toLowerCase();
  if (!email || !getAdminEmails().includes(email)) {
    throw new AdminAuthError("Not an admin account", 403);
  }
  return data.user;
}
