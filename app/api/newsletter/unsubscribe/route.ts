import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createHmac } from "node:crypto";

function makeToken(userId: string): string {
  const secret = process.env.BLOG_GENERATE_SECRET ?? "fallback-secret";
  return createHmac("sha256", secret).update(userId).digest("hex").slice(0, 32);
}

export function generateUnsubscribeUrl(userId: string, baseUrl = "https://www.morroo.com"): string {
  return `${baseUrl}/api/newsletter/unsubscribe?uid=${userId}&token=${makeToken(userId)}`;
}

export async function GET(request: Request) {
  const { searchParams, origin } = new URL(request.url);
  const uid = searchParams.get("uid") ?? "";
  const token = searchParams.get("token") ?? "";

  if (!uid || !token || token !== makeToken(uid)) {
    return NextResponse.redirect(`${origin}/?unsubscribe=invalid`);
  }

  const supabase = await createClient();
  await supabase
    .from("profiles")
    .update({ newsletter_opted_out: true })
    .eq("id", uid);

  return NextResponse.redirect(`${origin}/?unsubscribe=success`);
}
