import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

type AdminCheckOk = { ok: true; userId: string };
type AdminCheckErr = { ok: false; response: NextResponse };

/**
 * Server-side guard for admin-only API routes.
 *
 * On success returns `{ ok: true, userId }`. On failure returns a
 * pre-built JSON `NextResponse` (401 unauthenticated / 403 not admin)
 * the caller should return verbatim.
 */
export async function requireAdmin(): Promise<AdminCheckOk | AdminCheckErr> {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return {
      ok: false,
      response: NextResponse.json({ error: "Unauthorized" }, { status: 401 }),
    };
  }

  const { data: profile } = await supabase
    .from("profiles")
    .select("role")
    .eq("id", user.id)
    .single();

  if ((profile as { role?: string } | null)?.role !== "admin") {
    return {
      ok: false,
      response: NextResponse.json({ error: "Admin only" }, { status: 403 }),
    };
  }

  return { ok: true, userId: user.id };
}
