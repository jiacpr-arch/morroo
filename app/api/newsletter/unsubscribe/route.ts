import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { makeUnsubscribeToken } from "@/lib/newsletter-unsubscribe";

export async function GET(request: Request) {
  const { searchParams, origin } = new URL(request.url);
  const uid = searchParams.get("uid") ?? "";
  const token = searchParams.get("token") ?? "";

  if (!uid || !token || token !== makeUnsubscribeToken(uid)) {
    return NextResponse.redirect(`${origin}/?unsubscribe=invalid`);
  }

  const supabase = await createClient();
  await supabase
    .from("profiles")
    .update({ newsletter_opted_out: true })
    .eq("id", uid);

  return NextResponse.redirect(`${origin}/?unsubscribe=success`);
}
