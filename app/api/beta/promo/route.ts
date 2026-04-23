import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { isPromoActive } from "@/lib/beta";

export const dynamic = "force-dynamic";

export async function GET() {
  const supabase = await createClient();
  const { data } = await supabase
    .from("app_settings")
    .select("value")
    .eq("key", "beta_promo_ends_at")
    .single();

  const endsAt = (data as { value: string } | null)?.value ?? null;
  return NextResponse.json({
    endsAt,
    isActive: isPromoActive(endsAt),
  });
}
