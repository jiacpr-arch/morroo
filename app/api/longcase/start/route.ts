import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { getLongCaseFull, startLongCaseSession } from "@/lib/supabase/queries-longcase";
import { hasLongCaseAccess } from "@/lib/types";

export async function POST(request: NextRequest) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.json({ error: "กรุณาเข้าสู่ระบบก่อน" }, { status: 401 });
  }

  // Check membership
  const { data: profile } = await supabase
    .from("profiles")
    .select("membership_type, membership_expires_at")
    .eq("id", user.id)
    .single();

  const now = new Date();
  const hasActivePlan = profile ? hasLongCaseAccess(profile.membership_type, profile.membership_expires_at) : false;

  // Free users get 1 Long Case per month
  if (!hasActivePlan) {
    const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1).toISOString();
    const { count } = await supabase
      .from("long_case_sessions")
      .select("id", { count: "exact", head: true })
      .eq("user_id", user.id)
      .gte("started_at", startOfMonth);

    if ((count ?? 0) >= 1) {
      return NextResponse.json(
        { error: "ฟรี 1 เคส/เดือน — อัปเกรดเพื่อเล่นไม่จำกัด" },
        { status: 403 }
      );
    }
  }

  const { caseId } = await request.json();
  if (!caseId) {
    return NextResponse.json({ error: "Missing caseId" }, { status: 400 });
  }

  const longCase = await getLongCaseFull(caseId);
  if (!longCase) {
    return NextResponse.json({ error: "Case not found" }, { status: 404 });
  }

  const session = await startLongCaseSession(caseId, user.id);
  if (!session) {
    return NextResponse.json({ error: "ไม่สามารถสร้าง session ได้" }, { status: 500 });
  }

  // Return session + patient info (NO history script / pe_findings / lab_results)
  return NextResponse.json({
    sessionId: session.id,
    patientInfo: longCase.patient_info,
    phase: session.phase,
    alreadyStarted: !!session.started_at,
  });
}
