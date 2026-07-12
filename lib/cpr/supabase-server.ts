// Server-only client ของ Supabase โปรเจกต์ CPR (tpoiyykbgsgnrdwzgzvn) — ใช้ service role
// สำหรับ route handlers /api/cpr/* (Phase 3) และ SSR blog (Phase 2)
// pattern เดียวกับ lib/supabase/admin.ts: คืน mock ตอน build ที่ยังไม่มี env
import { createClient } from "@supabase/supabase-js";

export function createCprAdminClient() {
  const url = process.env.NEXT_PUBLIC_CPR_SUPABASE_URL;
  const key = process.env.CPR_SUPABASE_SERVICE_ROLE_KEY;

  if (!url || !key) {
    const makeQuery = (isSingle: boolean): unknown => {
      const result = isSingle ? { data: null, error: null } : { data: [], error: null, count: 0 };
      const handler: ProxyHandler<Record<string, unknown>> = {
        get(_target, prop) {
          if (prop === "then") {
            return (resolve: (v: unknown) => unknown) => Promise.resolve(resolve(result));
          }
          if (prop === "single" || prop === "maybeSingle") {
            return () => makeQuery(true);
          }
          return () => makeQuery(isSingle);
        },
      };
      return new Proxy({}, handler);
    };
    return {
      from: () => makeQuery(false),
      rpc: () => makeQuery(false),
    } as unknown as ReturnType<typeof createClient>;
  }

  return createClient(url, key, {
    auth: { autoRefreshToken: false, persistSession: false },
  });
}
