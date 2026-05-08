import { createClient } from "@supabase/supabase-js";

export function createAdminClient() {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const key = process.env.SUPABASE_SERVICE_ROLE_KEY;

  if (!url || url === "your-supabase-url" || !key) {
    // Return a mock admin client when Supabase is not configured (e.g. during static build).
    const makeQuery = (isSingle: boolean, isCountHead: boolean): unknown => {
      const result = isCountHead
        ? { data: null, error: null, count: 0 }
        : isSingle
          ? { data: null, error: null }
          : { data: [], error: null, count: 0 };
      const handler: ProxyHandler<Record<string, unknown>> = {
        get(_target, prop) {
          if (prop === "then") {
            return (resolve: (v: unknown) => unknown) =>
              Promise.resolve(resolve(result));
          }
          if (prop === "single" || prop === "maybeSingle") {
            return () => makeQuery(true, false);
          }
          if (prop === "select") {
            return (
              _cols?: string,
              opts?: { count?: string; head?: boolean }
            ) => makeQuery(isSingle, !!opts?.head);
          }
          return () => makeQuery(isSingle, isCountHead);
        },
      };
      return new Proxy({}, handler);
    };
    return {
      auth: {
        getUser: async () => ({ data: { user: null }, error: null }),
        admin: {
          listUsers: async () => ({ data: { users: [] }, error: null }),
          createUser: async () => ({ data: { user: null }, error: { message: "Supabase not configured" } }),
          deleteUser: async () => ({ data: null, error: { message: "Supabase not configured" } }),
        },
      },
      from: () => makeQuery(false, false),
      rpc: () => makeQuery(false, false),
    } as unknown as ReturnType<typeof createClient>;
  }

  return createClient(url, key, {
    auth: { autoRefreshToken: false, persistSession: false },
  });
}
