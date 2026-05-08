import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { buildLineAuthorizeUrl, signOAuthState } from "@/lib/line-oauth";

export const runtime = "nodejs";

export async function GET(request: NextRequest) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.redirect(
      new URL(
        `/login?redirect=${encodeURIComponent("/api/line/oauth/start")}`,
        request.url
      )
    );
  }

  const siteUrl = (process.env.NEXT_PUBLIC_SITE_URL ?? new URL(request.url).origin).trim();
  const redirectUri = `${siteUrl}/api/line/oauth/callback`;

  let url: string;
  try {
    const state = signOAuthState(user.id);
    url = buildLineAuthorizeUrl(state, redirectUri);
  } catch (e) {
    const msg = e instanceof Error ? e.message : String(e);
    console.error("[line-oauth/start]", msg);
    return NextResponse.json(
      { error: "LINE Login ยังไม่ได้ตั้งค่า" },
      { status: 500 }
    );
  }

  return NextResponse.redirect(url);
}
