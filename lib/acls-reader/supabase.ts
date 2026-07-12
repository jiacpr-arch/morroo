import { createClient } from "@supabase/supabase-js";

// Read-only client for the ACLS/BLS course content, now served from morroo's
// own Supabase project (the acls_* tables were migrated from the old
// standalone ACLS project — see docs/acls-migration.md).
// Placeholder fallbacks keep createClient from throwing at import time when
// env vars are absent (e.g. forks / CI builds); queries then fail and the
// callers' try/catch paths serve static fallback content instead.
const url = process.env.NEXT_PUBLIC_SUPABASE_URL || "https://placeholder.supabase.co";
const anonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || "placeholder-anon-key";

export const supabase = createClient(url, anonKey, {
  auth: { persistSession: false, autoRefreshToken: false },
});
