import { createClient } from "@supabase/supabase-js";

// Dedicated read-only client for the EXISTING ACLS content project.
// Hardcoded public anon values on purpose: do NOT read morroo's own
// NEXT_PUBLIC_SUPABASE_* env vars — those point at a different (morroo)
// project that has no acls_* tables. Allow an ACLS-specific override.
const url =
  process.env.NEXT_PUBLIC_ACLS_SUPABASE_URL ?? "https://elyyijlcjfvhxbpzscnv.supabase.co";
const anonKey =
  process.env.NEXT_PUBLIC_ACLS_SUPABASE_ANON_KEY ??
  "sb_publishable_ie9hrnsxONcotMSqcQF_Og_zXj-8sIp";

export const supabase = createClient(url, anonKey, {
  auth: { persistSession: false, autoRefreshToken: false },
});
