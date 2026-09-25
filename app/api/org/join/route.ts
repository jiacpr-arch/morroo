import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { JOIN_RESULT_MESSAGE, isJoinResult, normalizeJoinCode } from "@/lib/organizations";

export const runtime = "nodejs";

/**
 * POST /api/org/join  Body: { code }
 *   → { result: "joined" | "already_member" | "not_found" | "expired" | "full", message }
 *
 * The seat limit is enforced atomically inside the `join_organization` RPC
 * (row lock on the org), so two people using the last seat at the same time
 * cannot both get in.
 */
export async function POST(request: Request) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  let body: { code?: unknown };
  try {
    body = (await request.json()) as { code?: unknown };
  } catch {
    return NextResponse.json({ error: "Invalid JSON" }, { status: 400 });
  }
  const code = normalizeJoinCode(typeof body.code === "string" ? body.code : null);
  if (!code) {
    return NextResponse.json(
      { result: "not_found", message: JOIN_RESULT_MESSAGE.not_found },
      { status: 404 }
    );
  }

  const admin = createAdminClient();
  const { data, error } = await admin.rpc("join_organization", {
    p_join_code: code,
    p_user_id: user.id,
  });
  if (error) {
    console.error("join_organization failed:", error.message);
    return NextResponse.json({ error: "เข้าร่วมกลุ่มไม่สำเร็จ กรุณาลองใหม่" }, { status: 500 });
  }
  const result = isJoinResult(data) ? data : "not_found";
  const status = result === "joined" || result === "already_member" ? 200 : result === "not_found" ? 404 : 409;
  return NextResponse.json({ result, message: JOIN_RESULT_MESSAGE[result] }, { status });
}
