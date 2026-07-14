import { createClient, type SupabaseClient } from "@supabase/supabase-js";

// Server-only service-role client for the ACLS/BLS "emr-ai-clinic" Supabase
// project — used by admin write endpoints and the AI content-generation
// routes ported from the acls-emr Vite app's api/_lib/supabaseAdmin.js.
// Never import this from a client component; the service-role key must
// never reach the browser.
//
// Lazily constructed (not at module load) so a missing env var doesn't break
// the build — it only throws if an admin endpoint actually calls this
// without being configured.
let cached: SupabaseClient | null = null;

export function getSupabaseAdmin(): SupabaseClient {
  if (cached) return cached;
  const url =
    process.env.NEXT_PUBLIC_ACLS_SUPABASE_URL ??
    "https://elyyijlcjfvhxbpzscnv.supabase.co";
  const serviceKey = process.env.ACLS_SUPABASE_SERVICE_ROLE_KEY;
  if (!serviceKey) {
    throw new Error(
      "Resus admin Supabase client not configured (ACLS_SUPABASE_SERVICE_ROLE_KEY)"
    );
  }
  cached = createClient(url, serviceKey, {
    auth: { persistSession: false, autoRefreshToken: false },
  });
  return cached;
}
