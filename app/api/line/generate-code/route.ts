import { NextRequest, NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@supabase/supabase-js";

export const runtime = "nodejs";

const CHARS = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";

function generateCode(): string {
  return (
    "MORROO-" +
    Array.from(
      { length: 6 },
      () => CHARS[Math.floor(Math.random() * CHARS.length)]
    ).join("")
  );
}

export async function POST(request: NextRequest) {
  // Verify user via Authorization header
  const authHeader = request.headers.get("Authorization");
  if (!authHeader?.startsWith("Bearer ")) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const anonClient = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  );
  const { data: { user } } = await anonClient.auth.getUser(
    authHeader.replace("Bearer ", "")
  );
  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const supabase = createAdminClient();

  // Delete any existing codes for this user
  await supabase.from("line_link_codes").delete().eq("user_id", user.id);

  // Generate unique code (retry if collision)
  let code = generateCode();
  for (let i = 0; i < 5; i++) {
    const { data: existing } = await supabase
      .from("line_link_codes")
      .select("id")
      .eq("code", code)
      .single();
    if (!existing) break;
    code = generateCode();
  }

  const expiresAt = new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString();
  await supabase.from("line_link_codes").insert({
    user_id: user.id,
    code,
    expires_at: expiresAt,
  });

  return NextResponse.json({ code, expires_at: expiresAt });
}
