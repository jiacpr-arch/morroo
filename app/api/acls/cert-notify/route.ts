import { NextRequest, NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { sendLineMessage } from "@/lib/line";
import { ipRateLimit } from "@/lib/courses/ip-rate-limit";
import { buildCertMessage } from "@/lib/courses/cert-notify";

// Public endpoint: the student's browser calls this right after generating a
// certificate PDF client-side, so (a) the issuance gets recorded for admin
// stats and (b) the admin LINE OA gets an alert. Best-effort on both counts —
// a failure here must never block the student's already-downloaded PDF.

// Client generates cert ids as `${JIA-ACLS|JIA-BLS}-${Date.now().toString(36).toUpperCase()}`
// — reject anything else so this public endpoint can't be used to stuff
// arbitrary ids into the certificates table.
const CERT_ID_RE = /^JIA-(ACLS|BLS)-[0-9A-Z]{6,16}$/;
const MAX_NAME_LEN = 80;

function numOrNull(v: unknown): number | null {
  const n = Number(v);
  return Number.isFinite(n) ? n : null;
}

export async function POST(req: NextRequest) {
  const rl = ipRateLimit(req, { key: "acls-cert-notify", limit: 5, windowMs: 60_000 });
  if (!rl.ok) {
    return NextResponse.json(
      { error: "Too many requests — please try again later" },
      { status: 429, headers: { "Retry-After": String(rl.retryAfter) } },
    );
  }

  let body: Record<string, unknown>;
  try {
    body = await req.json();
  } catch {
    return NextResponse.json({ error: "invalid_json" }, { status: 400 });
  }

  const studentName = String(body.studentName || "").trim().slice(0, MAX_NAME_LEN);
  const studentPhone = String(body.studentPhone || "").trim().slice(0, 20);
  const studentEmail = String(body.studentEmail || "").trim().slice(0, 120);
  const certId = String(body.certId || "").trim().slice(0, 60);
  const course = body.course === "bls" ? "bls" : "acls";
  const preTestScore = numOrNull(body.preTestScore);
  const postTestScore = numOrNull(body.postTestScore);
  const ekgPassed = !!body.ekgPassed;

  if (!studentName || !certId) {
    return NextResponse.json({ error: "missing studentName or certId" }, { status: 400 });
  }
  if (!CERT_ID_RE.test(certId)) {
    return NextResponse.json({ error: "invalid certId" }, { status: 400 });
  }

  // Best-effort: persist the issuance so the admin stats page can count it.
  // ignoreDuplicates makes this insert-only: retries stay idempotent, but an
  // existing record can never be overwritten by a later (possibly forged)
  // request with the same cert_id.
  let recorded = false;
  try {
    const supabase = createAdminClient();
    const { error } = await supabase.from("acls_certificates").upsert(
      {
        cert_id: certId,
        student_name: studentName,
        student_phone: studentPhone || null,
        student_email: studentEmail || null,
        course_mode: course,
        pre_test_score: preTestScore,
        post_test_score: postTestScore,
        ekg_passed: ekgPassed,
      },
      { onConflict: "cert_id", ignoreDuplicates: true },
    );
    recorded = !error;
  } catch {
    /* Supabase not configured — skip silently */
  }

  let lineResult: { ok: boolean; skipped?: string } = { ok: false, skipped: "not configured" };
  const target = process.env.LINE_ADMIN_USER_ID;
  if (target) {
    const text = buildCertMessage({
      studentName,
      studentPhone,
      certId,
      course,
      courseTitle: String(body.courseTitle || "").trim().slice(0, 120) || null,
      completedAt: (body.completedAt as string) || null,
      preTestScore,
      postTestScore,
      ekgPassed,
    });
    const ok = await sendLineMessage(target, [{ type: "text", text }]);
    lineResult = { ok };
  }

  // Best-effort: even if LINE/Supabase isn't configured or fails, the cert was
  // still issued client-side — don't surface a hard error to the student.
  return NextResponse.json({ ...lineResult, recorded });
}
