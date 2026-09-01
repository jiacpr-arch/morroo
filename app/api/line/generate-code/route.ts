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

  const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const anonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
  if (!supabaseUrl || !anonKey) {
    console.error("Supabase env vars missing for LINE generate-code");
    return NextResponse.json(
      { error: "Server misconfigured" },
      { status: 500 }
    );
  }

  const anonClient = createClient(supabaseUrl, anonKey);
  const { data: { user } } = await anonClient.auth.getUser(
    authHeader.replace("Bearer ", "")
  );
  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const supabase = createAdminClient();

  // Delete any existing codes for this user
  const { error: deleteError } = await supabase
    .from("line_link_codes")
    .delete()
    .eq("user_id", user.id);
  if (deleteError) {
    console.error("Failed to delete previous LINE link codes:", deleteError);
    return NextResponse.json({ error: "Internal error" }, { status: 500 });
  }

  // Generate unique code (retry if collision)
  let code = generateCode();
  for (let i = 0; i < 5; i++) {
    const { data: existing, error: collisionError } = await supabase
      .from("line_link_codes")
      .select("id")
      .eq("code", code)
      .maybeSingle();
    if (collisionError) {
      console.error("LINE link-code collision check failed:", collisionError);
      return NextResponse.json({ error: "Internal error" }, { status: 500 });
    }
    if (!existing) break;
    code = generateCode();
  }

  const expiresAt = new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString();
  const { error: insertError } = await supabase
    .from("line_link_codes")
    .insert({
      user_id: user.id,
      code,
      expires_at: expiresAt,
    });

  if (insertError) {
    console.error("Failed to insert LINE link code:", insertError);
    return NextResponse.json({ error: "Internal error" }, { status: 500 });
  }

  return NextResponse.json({ code, expires_at: expiresAt });
}
