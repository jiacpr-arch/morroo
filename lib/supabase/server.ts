import { createServerClient } from "@supabase/ssr";
import { cookies } from "next/headers";

export async function createClient() {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const key = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

  if (!url || url === "your-supabase-url" || !key || key === "your-supabase-anon-key") {
    // Return a mock server client when Supabase is not configured.
    // Use a Proxy so any postgrest chain method (range, gte, in, ...) is supported.
    const makeQuery = (isSingle: boolean, isCountHead: boolean) => {
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
          // Default: return chainable function for any postgrest filter/modifier
          return () => makeQuery(isSingle, isCountHead);
        },
      };
      return new Proxy({}, handler);
    };
    return {
      auth: {
        getUser: async () => ({ data: { user: null }, error: null }),
        exchangeCodeForSession: async () => ({ data: { user: null, session: null }, error: { message: "Supabase not configured" } }),
      },
      from: () => makeQuery(false, false),
      rpc: () => makeQuery(false, false),
    } as unknown as ReturnType<typeof createServerClient>;
  }

  const cookieStore = await cookies();

  return createServerClient(url, key, {
    cookies: {
      getAll() {
        return cookieStore.getAll();
      },
      setAll(cookiesToSet) {
        try {
          cookiesToSet.forEach(({ name, value, options }) =>
            cookieStore.set(name, value, options)
          );
        } catch {
          // The `setAll` method was called from a Server Component.
        }
      },
    },
  });
}
