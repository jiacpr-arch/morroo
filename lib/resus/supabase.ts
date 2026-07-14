import { createClient } from "@supabase/supabase-js";

// Browser client for the ACLS/BLS course route groups (app/(acls),
// app/(bls)) — both courses live in the same, separate "emr-ai-clinic"
// Supabase project (not morroo's own project, and not merged into it; see
// docs/consolidation-plan.md Phase 1).
//
// Reuses the same NEXT_PUBLIC_ACLS_SUPABASE_* env vars as
// lib/acls-reader/supabase.ts on purpose — both clients point at the same
// physical project, so a second pair of env vars would just be the same
// URL/key under a different name. They are NOT the same client instance
// though: acls-reader's client is read-only and never persists a session
// (`persistSession: false`), while this one is used for the real ACLS/BLS
// course apps (students' pre-course quiz state, admin login) and needs a
// persisted session. A distinct storageKey keeps their localStorage entries
// from ever colliding on the same origin.
const url =
  process.env.NEXT_PUBLIC_ACLS_SUPABASE_URL ??
  "https://elyyijlcjfvhxbpzscnv.supabase.co";
const anonKey =
  process.env.NEXT_PUBLIC_ACLS_SUPABASE_ANON_KEY ??
  "sb_publishable_ie9hrnsxONcotMSqcQF_Og_zXj-8sIp";

export const supabase = createClient(url, anonKey, {
  auth: {
    persistSession: true,
    autoRefreshToken: true,
    storageKey: "resus-emr-auth",
  },
});
