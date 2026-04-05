import { createServerClient } from "@supabase/ssr";
import { cookies } from "next/headers";

export async function createClient() {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const key = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

  if (!url || url === "your-supabase-url" || !key || key === "your-supabase-anon-key") {
    // Return a mock server client when Supabase is not configured
    // Chainable query builder that always resolves to empty data
    const emptyResult = { data: null, error: null };
    const emptyList = { data: [], error: null };
    function mockQuery(isSingle = false): Record<string, unknown> {
      const q: Record<string, unknown> = {
        select: (cols?: string) => {
          void cols;
          return mockQuery(false);
        },
        eq: () => mockQuery(isSingle),
        neq: () => mockQuery(isSingle),
        order: () => mockQuery(isSingle),
        limit: () => mockQuery(isSingle),
        single: () => mockQuery(true),
        insert: () => mockQuery(false),
        upsert: () => mockQuery(false),
        update: () => mockQuery(false),
        delete: () => mockQuery(false),
        then: (resolve: (v: unknown) => unknown) =>
          Promise.resolve(resolve(isSingle ? emptyResult : emptyList)),
      };
      return q;
    }
    return {
      auth: {
        getUser: async () => ({ data: { user: null }, error: null }),
        exchangeCodeForSession: async () => ({ data: { user: null, session: null }, error: { message: "Supabase not configured" } }),
      },
      from: () => mockQuery(),
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
