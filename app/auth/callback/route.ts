import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { sendWelcomeEmail } from "@/lib/email";

export async function GET(request: Request) {
  const { searchParams, origin } = new URL(request.url);
  const code = searchParams.get("code");
  const next = searchParams.get("next") ?? "/profile";

  if (code) {
    const supabase = await createClient();
    const { data, error } = await supabase.auth.exchangeCodeForSession(code);

    if (!error && data.user) {
      // Upsert profile on OAuth login — returns data only when a new row is inserted
      const name =
        data.user.user_metadata?.full_name ||
        data.user.user_metadata?.name ||
        data.user.email ||
        "";
      const { data: upsertData } = await supabase.from("profiles").upsert(
        {
          id: data.user.id,
          email: data.user.email,
          name,
          role: "user",
          membership_type: "free",
        },
        { onConflict: "id", ignoreDuplicates: true }
      ).select("id");

      // Send welcome email for new users only
      if (upsertData && upsertData.length > 0 && data.user.email) {
        await sendWelcomeEmail(data.user.email, name);
      }

      return NextResponse.redirect(`${origin}${next}`);
    }
  }

  // Auth error - redirect to login
  return NextResponse.redirect(`${origin}/login?error=auth`);
}
