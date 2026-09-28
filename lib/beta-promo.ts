import { unstable_cache } from "next/cache";
import { createAdminClient } from "@/lib/supabase/admin";

/**
 * app_settings.beta_promo_ends_at, read on the server so the layout can render
 * the promo banner in the initial HTML instead of popping it in after a
 * client fetch (which pushed the whole page down — a big CLS hit).
 *
 * Uses the cookie-less admin client + a 5-minute cache so reading it doesn't
 * make every page dynamic.
 */
export const getBetaPromoEndsAt = unstable_cache(
  async (): Promise<string | null> => {
    const { data } = await createAdminClient()
      .from("app_settings")
      .select("value")
      .eq("key", "beta_promo_ends_at")
      .maybeSingle();
    return (data as { value: string } | null)?.value ?? null;
  },
  ["beta-promo-ends-at"],
  { revalidate: 300 }
);
