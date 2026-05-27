import { createAdminClient } from "@/lib/supabase/admin";
import { getLineCtaLevel } from "@/lib/line-cta-config";
import FloatingLineButton from "@/components/FloatingLineButton";

/**
 * Server wrapper that reads the Tier-1 autopilot level from app_settings and
 * hands it to the client bubble. Rendered inside <Suspense> in the root layout
 * so the DB read streams instead of blocking the shell.
 */
export default async function FloatingLineCta() {
  const level = await getLineCtaLevel(createAdminClient());
  return <FloatingLineButton level={level} />;
}
