/**
 * Course catalogue and input validation for hand-entered sales.
 *
 * Pure on purpose: the API route owns the database and the Meta call, this
 * file owns "what counts as a valid sale". Prices live here rather than in the
 * form so the server never trusts a number the browser invented — the client
 * only picks a course id and may override the amount actually received.
 *
 * See docs/spec-capi-conversion-tracking.md, Part A.
 */

export type CourseId = "cpr" | "first_aid" | "als";

export interface Course {
  id: CourseId;
  /** Sent to Meta as custom_data.content_name. */
  name: string;
  /** List price in THB; the form pre-fills it, sales may discount. */
  priceThb: number;
}

export const COURSES: readonly Course[] = [
  { id: "cpr", name: "CPR", priceThb: 500 },
  { id: "first_aid", name: "First Aid", priceThb: 999 },
  { id: "als", name: "ALS", priceThb: 5900 },
] as const;

export function findCourse(id: string): Course | null {
  return COURSES.find((c) => c.id === id) ?? null;
}

export const SOURCE_CHANNELS = [
  { id: "facebook", label: "ทัก Facebook" },
  { id: "line", label: "ทัก LINE" },
  { id: "walk_in", label: "เดินมาเอง" },
  { id: "referral", label: "เพื่อนแนะนำ" },
] as const;

export type SourceChannel = (typeof SOURCE_CHANNELS)[number]["id"];

function isSourceChannel(v: string): v is SourceChannel {
  return SOURCE_CHANNELS.some((s) => s.id === v);
}

export interface CourseSaleInput {
  customerName?: unknown;
  phone?: unknown;
  courseId?: unknown;
  priceThb?: unknown;
  sourceChannel?: unknown;
  soldOn?: unknown;
}

export interface ValidCourseSale {
  customerName: string;
  phone: string;
  course: Course;
  priceThb: number;
  sourceChannel: SourceChannel | null;
  soldOn: string;
}

export type ValidationResult =
  | { ok: true; sale: ValidCourseSale }
  | { ok: false; errors: string[] };

/** A Thai phone has at least 9 digits once punctuation is stripped. */
const MIN_PHONE_DIGITS = 9;
const ISO_DATE = /^\d{4}-\d{2}-\d{2}$/;

/**
 * Validate one submitted sale.
 *
 * Collects every problem rather than failing on the first, so a phone typed
 * on a bus doesn't cost four round trips to fix.
 */
export function validateCourseSale(input: CourseSaleInput): ValidationResult {
  const errors: string[] = [];

  const customerName =
    typeof input.customerName === "string" ? input.customerName.trim() : "";
  if (!customerName) errors.push("กรุณากรอกชื่อลูกค้า");

  const phone = typeof input.phone === "string" ? input.phone.trim() : "";
  if (!phone) {
    errors.push("กรุณากรอกเบอร์โทร");
  } else if (phone.replace(/\D/g, "").length < MIN_PHONE_DIGITS) {
    // The phone is the only identifier Meta can match on for a chat sale —
    // a wrong one silently costs the whole conversion.
    errors.push("เบอร์โทรไม่ครบ ตรวจสอบอีกครั้ง");
  }

  const course =
    typeof input.courseId === "string" ? findCourse(input.courseId) : null;
  if (!course) errors.push("กรุณาเลือกคอร์ส");

  // Blank means "no discount" — fall back to list price rather than reject.
  let priceThb = course?.priceThb ?? 0;
  if (input.priceThb !== undefined && input.priceThb !== null && input.priceThb !== "") {
    const parsed = Number(input.priceThb);
    if (!Number.isFinite(parsed) || parsed < 0) {
      errors.push("ราคาไม่ถูกต้อง");
    } else {
      priceThb = Math.round(parsed * 100) / 100;
    }
  }

  let sourceChannel: SourceChannel | null = null;
  if (typeof input.sourceChannel === "string" && input.sourceChannel !== "") {
    if (isSourceChannel(input.sourceChannel)) sourceChannel = input.sourceChannel;
    else errors.push("ช่องทางที่มาไม่ถูกต้อง");
  }

  let soldOn = todayInBangkok();
  if (typeof input.soldOn === "string" && input.soldOn !== "") {
    if (!ISO_DATE.test(input.soldOn) || Number.isNaN(Date.parse(input.soldOn))) {
      errors.push("วันที่ไม่ถูกต้อง");
    } else {
      soldOn = input.soldOn;
    }
  }

  if (errors.length || !course) return { ok: false, errors };

  return {
    ok: true,
    sale: { customerName, phone, course, priceThb, sourceChannel, soldOn },
  };
}

/**
 * Today's date in Bangkok, as YYYY-MM-DD.
 *
 * Vercel runs in UTC, so `new Date().toISOString()` rolls over at 07:00 local
 * and would file an evening sale under tomorrow.
 */
export function todayInBangkok(now: Date = new Date()): string {
  return new Intl.DateTimeFormat("en-CA", {
    timeZone: "Asia/Bangkok",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).format(now);
}

/**
 * Deduplication key for the Purchase event.
 *
 * Derived from the row id, so re-sending the same sale (a retry, or the
 * future certificate system firing its own copy — Part A step 3) collapses
 * into one conversion on Meta's side instead of double-counting revenue.
 */
export function courseSaleEventId(saleId: number | string): string {
  return `course_sale:${saleId}`;
}
