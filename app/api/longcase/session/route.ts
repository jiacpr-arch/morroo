import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { getLongCaseSession, updateLongCaseSession } from "@/lib/supabase/queries-longcase";

// GET /api/longcase/session?id=xxx&includePe=true&includeLab=true
export async function GET(request: NextRequest) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const { searchParams } = new URL(request.url);
  const sessionId = searchParams.get("id");
  const includePe = searchParams.get("includePe") === "true";
  const includeLab = searchParams.get("includeLab") === "true";
  const includeLabKeys = searchParams.get("includeLabKeys") === "true";
  const includeAcceptedDdx = searchParams.get("includeAcceptedDdx") === "true";

  if (!sessionId) return NextResponse.json({ error: "Missing id" }, { status: 400 });

  const session = await getLongCaseSession(sessionId);
  if (!session || session.user_id !== user.id) {
    return NextResponse.json({ error: "Session not found" }, { status: 404 });
  }

  // Strip sensitive case data unless explicitly requested
  const caseData = { ...session.long_case };
  if (!includePe) delete (caseData as Record<string, unknown>).pe_findings;
  if (includeLabKeys && !includeLab) {
    // Return only lab names (keys), not values — for hint display
    const labResults = (caseData as Record<string, unknown>).lab_results as Record<string, unknown> | undefined;
    const imagingResults = (caseData as Record<string, unknown>).imaging_results as Record<string, unknown> | undefined;
    (caseData as Record<string, unknown>).lab_keys = labResults ? Object.keys(labResults) : [];
    (caseData as Record<string, unknown>).imaging_keys = imagingResults ? Object.keys(imagingResults) : [];
    delete (caseData as Record<string, unknown>).lab_results;
    delete (caseData as Record<string, unknown>).imaging_results;
  } else if (!includeLab) {
    delete (caseData as Record<string, unknown>).lab_results;
    delete (caseData as Record<string, unknown>).imaging_results;
  }
  // Never expose history_script to client
  delete (caseData as Record<string, unknown>).history_script;
  delete (caseData as Record<string, unknown>).correct_diagnosis;
  // Only expose accepted_ddx after scoring is done
  if (!includeAcceptedDdx || session.phase !== "done") {
    delete (caseData as Record<string, unknown>).accepted_ddx;
  }
  delete (caseData as Record<string, unknown>).examiner_questions;
  delete (caseData as Record<string, unknown>).scoring_rubric;

  return NextResponse.json({ ...session, long_case: caseData });
}

// PUT /api/longcase/session — update session fields
export async function PUT(request: NextRequest) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const { sessionId, ...updates } = await request.json();
  if (!sessionId) return NextResponse.json({ error: "Missing sessionId" }, { status: 400 });

  // Verify ownership
  const session = await getLongCaseSession(sessionId);
  if (!session || session.user_id !== user.id) {
    return NextResponse.json({ error: "Session not found" }, { status: 404 });
  }

  const ok = await updateLongCaseSession(sessionId, updates);
  if (!ok) return NextResponse.json({ error: "Update failed" }, { status: 500 });

  return NextResponse.json({ success: true });
}
