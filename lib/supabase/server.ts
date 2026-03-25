import { createServerClient } from "@supabase/ssr";
import { cookies } from "next/headers";

export async function createClient() {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const key = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

  if (!url || url === "your-supabase-url" || !key || key === "your-supabase-anon-key") {
    // Return a mock server client when Supabase is not configured
    return {
      auth: {
        getUser: async () => ({ data: { user: null }, error: null }),
        exchangeCodeForSession: async () => ({ data: { user: null, session: null }, error: { message: "Supabase not configured" } }),
      },
      from: () => ({
        select: () => ({ eq: () => ({ single: async () => ({ data: null, error: null }) }) }),
        upsert: async () => ({ data: null, error: null }),
      }),
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
