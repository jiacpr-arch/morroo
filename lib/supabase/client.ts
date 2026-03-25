import { createBrowserClient } from "@supabase/ssr";

export function createClient() {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const key = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

  if (!url || url === "your-supabase-url" || !key || key === "your-supabase-anon-key") {
    // Return a mock client that does nothing when Supabase is not configured
    return {
      auth: {
        getUser: async () => ({ data: { user: null }, error: null }),
        signInWithPassword: async () => ({ data: { user: null, session: null }, error: { message: "Supabase ยังไม่ได้ตั้งค่า กรุณาตั้งค่า .env.local" } }),
        signUp: async () => ({ data: { user: null, session: null }, error: { message: "Supabase ยังไม่ได้ตั้งค่า กรุณาตั้งค่า .env.local" } }),
        signInWithOAuth: async () => ({ data: { url: null, provider: null }, error: { message: "Supabase ยังไม่ได้ตั้งค่า" } }),
        signOut: async () => ({ error: null }),
        onAuthStateChange: (_event: string, _callback: unknown) => ({
          data: { subscription: { unsubscribe: () => {} } },
        }),
      },
      from: () => ({
        select: () => ({ eq: () => ({ single: async () => ({ data: null, error: null }) }) }),
        upsert: async () => ({ data: null, error: null }),
      }),
    } as unknown as ReturnType<typeof createBrowserClient>;
  }

  return createBrowserClient(url, key);
}
