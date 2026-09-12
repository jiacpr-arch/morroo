import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { fetchAccess } from "@/lib/entitlements";
import {
  getLongCaseFull,
  getLatestLongCaseAttempt,
  startLongCaseSession,
  retryLongCaseSession,
} from "@/lib/supabase/queries-longcase";
import type { LongCaseSession } from "@/lib/types";

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

  const access = await fetchAccess(supabase, user.id, profile);
  const now = new Date();

  const { caseId, retry } = await request.json();
  if (!caseId) {
    return NextResponse.json({ error: "Missing caseId" }, { status: 400 });
  }

  const longCase = await getLongCaseFull(caseId);
  if (!longCase) {
    return NextResponse.json({ error: "Case not found" }, { status: 404 });
  }

  // Board oral cases are unlocked by the Board product; student long cases
  // by the Long Case product (student pack includes it).
  const hasActivePlan =
    longCase.audience === "board" ? access.board : access.longcase;

  let session: LongCaseSession | null = null;
  let resumed = false;

  if (retry) {
    // Retaking a case is a paid-member feature
    if (!hasActivePlan) {
      return NextResponse.json(
        { error: "ทำซ้ำเคสเดิมได้เฉพาะสมาชิก — อัปเกรดเพื่อปลดล็อก" },
        { status: 403 }
      );
    }

    const result = await retryLongCaseSession(caseId, user.id);
    if (!result.ok) {
      if (result.reason === "no_prior_attempt") {
        return NextResponse.json(
          { error: "ยังไม่เคยทำเคสนี้ — กดเริ่มสอบแบบปกติได้เลย" },
          { status: 400 }
        );
      }
      return NextResponse.json({ error: "ไม่สามารถสร้าง session ได้" }, { status: 500 });
    }
    session = result.session;
    resumed = result.resumed;
  } else {
    // Resuming your own existing session is always allowed, on any plan
    try {
      session = await getLatestLongCaseAttempt(caseId, user.id);
    } catch {
      session = null;
    }
    if (session) {
      resumed = true;
    } else {
      if (!hasActivePlan) {
        // Free users get 1 new Long Case per month (retry rows don't count)
        const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1).toISOString();
        const { count } = await supabase
          .from("long_case_sessions")
          .select("id", { count: "exact", head: true })
          .eq("user_id", user.id)
          .eq("attempt_number", 1)
          .gte("started_at", startOfMonth);

        if ((count ?? 0) >= 1) {
          return NextResponse.json(
            { error: "ฟรี 1 เคส/เดือน — อัปเกรดเพื่อเล่นไม่จำกัด" },
            { status: 403 }
          );
        }
      }
      session = await startLongCaseSession(caseId, user.id);
    }
  }

  if (!session) {
    return NextResponse.json({ error: "ไม่สามารถสร้าง session ได้" }, { status: 500 });
  }

  // Return session + patient info (NO history script / pe_findings / lab_results)
  return NextResponse.json({
    sessionId: session.id,
    patientInfo: longCase.patient_info,
    phase: session.phase,
    alreadyStarted: resumed,
    attemptNumber: session.attempt_number,
  });
}
