import { NextRequest, NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import {
  exchangeLineCode,
  fetchLineProfile,
  verifyOAuthState,
} from "@/lib/line-oauth";

export const runtime = "nodejs";

function redirectWith(request: NextRequest, path: string, params: Record<string, string>) {
  const url = new URL(path, request.url);
  for (const [k, v] of Object.entries(params)) url.searchParams.set(k, v);
  return NextResponse.redirect(url);
}

export async function GET(request: NextRequest) {
  const url = new URL(request.url);
  const code = url.searchParams.get("code");
  const state = url.searchParams.get("state");
  const lineError = url.searchParams.get("error");

  if (lineError) {
    return redirectWith(request, "/dashboard", {
      line_link: "denied",
      reason: lineError,
    });
  }
  if (!code || !state) {
    return redirectWith(request, "/dashboard", { line_link: "missing_params" });
  }

  const verified = verifyOAuthState(state);
  if ("error" in verified) {
    return redirectWith(request, "/dashboard", {
      line_link: "bad_state",
      reason: verified.error,
    });
  }

  const siteUrl = (process.env.NEXT_PUBLIC_SITE_URL ?? url.origin).trim();
  const redirectUri = `${siteUrl}/api/line/oauth/callback`;

  const tokens = await exchangeLineCode(code, redirectUri);
  if (!tokens) {
    return redirectWith(request, "/dashboard", { line_link: "exchange_failed" });
  }

  const profile = await fetchLineProfile(tokens.accessToken);
  if (!profile) {
    return redirectWith(request, "/dashboard", { line_link: "profile_failed" });
  }

  const supabase = createAdminClient();
  const userId = verified.userId;
  const lineUserId = profile.userId;
  const now = new Date().toISOString();

  const { error: profileErr } = await supabase
    .from("profiles")
    .update({ line_user_id: lineUserId, line_linked_at: now })
    .eq("id", userId);
  if (profileErr) {
    console.error("[line-oauth/callback] profile update failed:", profileErr);
    return redirectWith(request, "/dashboard", { line_link: "save_failed" });
  }

  await supabase
    .from("leads")
    .update({ line_user_id: lineUserId })
    .eq("user_id", userId)
    .is("line_user_id", null);

  return redirectWith(request, "/dashboard", {
    line_link: "ok",
    name: profile.displayName,
  });
}
