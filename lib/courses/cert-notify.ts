// Builds the LINE admin alert text for a newly issued ACLS/BLS certificate.
// Pure function (no I/O) so it's unit-testable; sending happens in the API
// route via lib/line.ts's sendLineMessage.

export interface CertNotifyPayload {
  studentName?: string | null;
  studentPhone?: string | null;
  course?: "acls" | "bls";
  courseTitle?: string | null;
  certId?: string | null;
  completedAt?: string | null;
  preTestScore?: number | null;
  postTestScore?: number | null;
  ekgPassed?: boolean | null;
}

const MAX_NAME_LEN = 80;
const MAX_ID_LEN = 60;

export function buildCertMessage(payload: CertNotifyPayload = {}): string {
  const name = String(payload.studentName || "").trim().slice(0, MAX_NAME_LEN) || "(ไม่ระบุชื่อ)";
  const phone = String(payload.studentPhone || "").trim().slice(0, 20);
  const isBls = payload.course === "bls";
  const title = String(payload.courseTitle || (isBls ? "BLS" : "ACLS")).trim();
  const certId = String(payload.certId || "").trim().slice(0, MAX_ID_LEN) || "—";
  const date = formatThaiDate(payload.completedAt);

  const scoreParts: string[] = [];
  if (!isBls && payload.preTestScore != null) scoreParts.push(`Pre-test ${payload.preTestScore}%`);
  if (payload.postTestScore != null) scoreParts.push(`Post-test ${payload.postTestScore}%`);
  if (!isBls) scoreParts.push(`EKG ${payload.ekgPassed ? "ผ่าน" : "—"}`);

  const lines = ["🎓 มีนักเรียนได้รับใบประกาศนียบัตรใหม่", `คอร์ส: ${title}`, `ชื่อ: ${name}`];
  if (phone) lines.push(`เบอร์โทร: ${phone}`);
  if (scoreParts.length) lines.push(scoreParts.join(" · "));
  lines.push(`รหัสใบ: ${certId}`);
  lines.push(`วันที่: ${date}`);
  return lines.join("\n");
}

function formatThaiDate(iso?: string | null): string {
  const d = iso ? new Date(iso) : new Date();
  if (Number.isNaN(d.getTime())) return "—";
  const dd = String(d.getDate()).padStart(2, "0");
  const mm = String(d.getMonth() + 1).padStart(2, "0");
  return `${dd}/${mm}/${d.getFullYear()}`;
}
