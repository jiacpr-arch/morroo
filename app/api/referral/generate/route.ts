import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";

function generateCode(): string {
  const chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"; // ไม่มี I, O, 0, 1 กันสับสน
  let code = "MR-";
  for (let i = 0; i < 6; i++) {
    code += chars[Math.floor(Math.random() * chars.length)];
  }
  return code;
}

export async function POST() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  // ถ้ามี code อยู่แล้ว return เลย
  const { data: profile } = await supabase
    .from("profiles")
    .select("referral_code")
    .eq("id", user.id)
    .single();

  if (profile?.referral_code) {
    return NextResponse.json({ code: profile.referral_code });
  }

  // Generate unique code
  const admin = createAdminClient();
  let code: string;
  let attempts = 0;

  while (true) {
    code = generateCode();
    const { data: existing } = await admin
      .from("profiles")
      .select("id")
      .eq("referral_code", code)
      .single();

    if (!existing) break;
    if (++attempts > 10) {
      return NextResponse.json({ error: "Failed to generate unique code" }, { status: 500 });
    }
  }

  await admin.from("profiles").update({ referral_code: code! }).eq("id", user.id);

  return NextResponse.json({ code: code! });
}
