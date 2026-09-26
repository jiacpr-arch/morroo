import { PLAN_CATALOG, planDisplayPrice, type PlanType } from "@/lib/membership";
import type { LongCaseResult, PeFinding } from "@/lib/longcase-media";

const PERIOD_TH = { month: "/ เดือน", year: "/ ปี", lifetime: "" } as const;

/**
 * Card price fields for a plan: the first-purchase price as the headline,
 * the regular price struck through, and a note saying what later purchases
 * cost. Keeps every pricing card on PLAN_CATALOG.
 */
export function planCardPrice(plan: PlanType) {
  const d = planDisplayPrice(plan);
  return {
    price: d.price,
    compareAt: d.compareAt,
    note: d.compareAt
      ? `ราคาพิเศษซื้อครั้งแรก · ครั้งถัดไป ฿${d.compareAt.toLocaleString()} ${PERIOD_TH[PLAN_CATALOG[plan].duration]}`.trim()
      : undefined,
  };
}

/** Yearly vs 12× monthly at first-purchase prices: { percent, baht }. */
export function yearlySaving(monthly: PlanType, yearly: PlanType) {
  const m = planDisplayPrice(monthly).price * 12;
  const y = planDisplayPrice(yearly).price;
  return { percent: Math.round((1 - y / m) * 100), baht: m - y };
}

const STUDENT_SAVING = yearlySaving("monthly", "yearly");
const BOARD_SAVING = yearlySaving("board_monthly", "board_yearly");

// A single upcoming exam: which topic ("สอบหัวข้ออะไร") on which date ("วันไหน").
export interface ExamScheduleItem {
  topic: string;
  date: string; // ISO date "YYYY-MM-DD"
}

export interface Profile {
  id: string;
  email: string;
  name: string;
  role: "user" | "admin";
  membership_type:
    | "free"
    | "monthly"
    | "yearly"
    | "bundle"
    | "mcq_monthly"
    | "mcq_yearly"
    | "meq_monthly"
    | "meq_yearly"
    | "longcase_monthly"
    | "longcase_yearly"
    | "board_monthly"
    | "board_yearly"
    | "school_monthly"
    | "school_yearly";
  membership_expires_at: string | null;
  created_at: string;
  onboarding_done: boolean;
  daily_goal: number;
  current_year: 1 | 2 | 3 | 4 | 5 | 6 | null;
  school_daily_goal: number;
  /** XP สะสมฝั่ง school — ใช้คิดยศแพทย์ (lib/school/rank.ts) และ leaderboard */
  school_xp: number;
  target_exam: "NL1" | "NL2" | "both" | "board" | null;
  weak_subjects: string[] | null;
  exam_schedule: ExamScheduleItem[] | null;
  referral_code: string | null;
  referred_by: string | null;
  reporter_points: number;
  reporter_points_spent: number;
  meq_coins: number;
  beta_enrolled_via: "existing_user_upgrade" | "new_signup" | null;
  beta_started_at: string | null;
  beta_expires_at: string | null;
  beta_questions_used: number;
  beta_questions_limit: number;
  has_seen_beta_welcome: boolean;
  beta_coupon_code: string | null;
  beta_coupon_issued_at: string | null;
}

// ============================================================
// Long Case Types
// ============================================================
export interface LongCase {
  id: string;
  title: string;
  specialty: string;
  difficulty: "easy" | "medium" | "hard";
  week_number: number | null;
  is_weekly: boolean;
  is_published: boolean;
  published_at: string;
  patient_info: Record<string, unknown>;
  correct_diagnosis: string;
  created_at: string;
  audience: "student" | "board";
  board_specialty: string | null;
}

export interface LongCaseSession {
  id: string;
  case_id: string;
  user_id: string;
  attempt_number: number;
  phase: "history" | "pe" | "lab" | "ddx" | "management" | "examiner" | "done";
  history_chat: { role: "user" | "assistant"; content: string }[];
  pe_selected: string[];
  lab_ordered: string[];
  student_ddx: string | null;
  student_mgmt: string | null;
  examiner_chat: { role: "user" | "assistant"; content: string }[];
  score_history: number | null;
  score_pe: number | null;
  score_lab: number | null;
  score_ddx: number | null;
  score_management: number | null;
  score_examiner: number | null;
  score_total_pct: number | null;
  feedback: string | null;
  started_at: string;
  completed_at: string | null;
  long_case?: LongCase;
}

export interface LongCaseFull extends LongCase {
  history_script: Record<string, unknown>;
  pe_findings: Record<string, string | PeFinding>;
  lab_results: Record<string, LongCaseResult>;
  imaging_results: Record<string, LongCaseResult> | null;
  accepted_ddx: string[];
  management_plan: string;
  teaching_points: string[];
  examiner_questions: { question: string; modelAnswer: string; points: number }[];
  scoring_rubric: Record<string, number>;
}

// ============================================================
// Exam Types
// ============================================================
export interface Exam {
  id: string;
  title: string;
  category: string;
  difficulty: "easy" | "medium" | "hard";
  status: "draft" | "scheduled" | "published";
  is_free: boolean;
  publish_date: string | null;
  created_by: string;
  created_at: string;
}

export interface ExamPart {
  id: string;
  exam_id: string;
  part_number: number;
  title: string;
  scenario: string;
  question: string;
  answer: string;
  key_points: string[];
  time_minutes: number;
  created_at: string;
}

export const CATEGORIES = [
  { name: "อายุรศาสตร์", icon: "🫀", slug: "internal-medicine" },
  { name: "ศัลยศาสตร์", icon: "🔪", slug: "surgery" },
  { name: "กุมารเวชศาสตร์", icon: "👶", slug: "pediatrics" },
  { name: "สูติศาสตร์-นรีเวชวิทยา", icon: "🤰", slug: "obstetrics" },
  { name: "ออร์โธปิดิกส์", icon: "🦴", slug: "orthopedics" },
  { name: "จิตเวชศาสตร์", icon: "🧠", slug: "psychiatry" },
] as const;

export const PRICING_PLANS = [
  {
    name: "ฟรี",
    price: 0,
    period: "",
    description: "เริ่มต้นทดลองใช้งาน",
    features: [
      "ทำข้อสอบฟรี 5 ข้อ/สาขา",
      "เห็นเฉลยสั้น",
      "ไม่มีเฉลยละเอียด",
    ],
    cta: "เริ่มต้นฟรี",
    popular: false,
    type: "free" as const,
  },
  {
    name: "ซื้อเป็นชุด",
    price: 299,
    period: "/ 10 ข้อ",
    description: "เหมาะกับการทดลองก่อนสมัคร",
    features: [
      "เลือกข้อสอบ 10 ข้อ",
      "ดูเฉลยละเอียด",
      "Key Points ทุกข้อ",
      "🤖 AI ตรวจคำตอบอัตโนมัติ",
      "ไม่มีวันหมดอายุ",
    ],
    cta: "ซื้อชุดข้อสอบ",
    popular: false,
    type: "bundle" as const,
  },
  {
    name: "รายเดือน",
    ...planCardPrice("monthly"),
    period: "/ เดือน",
    description: "เข้าถึงข้อสอบทั้งหมด",
    features: [
      "ข้อสอบทั้งหมดไม่จำกัด",
      "เฉลยละเอียดทุกข้อ",
      "Key Points",
      "🤖 AI ตรวจคำตอบไม่จำกัด",
      "🩺 Long Case Exam ไม่จำกัด",
      "ข้อสอบใหม่ทุกสัปดาห์",
    ],
    cta: "สมัครรายเดือน",
    popular: true,
    type: "monthly" as const,
  },
  {
    name: "รายปี",
    ...planCardPrice("yearly"),
    period: "/ ปี",
    description: `ประหยัดกว่ารายเดือน ${STUDENT_SAVING.percent}%`,
    features: [
      "ทุกอย่างในแพ็กรายเดือน",
      "🤖 AI ตรวจคำตอบไม่จำกัด",
      "🩺 Long Case Exam ไม่จำกัด",
      `ประหยัด ฿${STUDENT_SAVING.baht.toLocaleString()}/ปี`,
      "สิทธิ์ก่อนใคร",
    ],
    cta: "สมัครรายปี",
    popular: false,
    badge: "คุ้มที่สุด",
    type: "yearly" as const,
  },
] as const;

/**
 * Per-product pricing — buy one system on its own (MCQ NL / MEQ / Long Case /
 * School). Prices come from PLAN_CATALOG (lib/membership.ts) so checkout,
 * Stripe and these cards never drift apart.
 */
export const PRODUCT_PRICING_PLANS = [
  {
    name: "MCQ NL",
    ...planCardPrice("mcq_monthly"),
    period: "/ เดือน",
    description: `หรือรายปี ฿${planDisplayPrice("mcq_yearly").price.toLocaleString()}`,
    features: [
      "ข้อสอบ MCQ NL Step 2 ไม่จำกัด",
      "เฉลยละเอียด + Key Points ทุกข้อ",
      "ข้อสอบใหม่ทุกสัปดาห์",
    ],
    cta: "สมัคร MCQ",
    popular: false,
    type: "mcq_monthly" as const,
    yearlyType: "mcq_yearly" as const,
  },
  {
    name: "MEQ",
    ...planCardPrice("meq_monthly"),
    period: "/ เดือน",
    description: `หรือรายปี ฿${planDisplayPrice("meq_yearly").price.toLocaleString()}`,
    features: [
      "ข้อสอบ MEQ ทุกชุด",
      "🤖 AI ตรวจคำตอบไม่จำกัด",
      "Key Points ทุกตอน",
    ],
    cta: "สมัคร MEQ",
    popular: false,
    type: "meq_monthly" as const,
    yearlyType: "meq_yearly" as const,
  },
  {
    name: "Long Case",
    ...planCardPrice("longcase_monthly"),
    period: "/ เดือน",
    description: `หรือรายปี ฿${planDisplayPrice("longcase_yearly").price.toLocaleString()}`,
    features: [
      "🩺 Long Case Exam กับ AI ไม่จำกัด",
      "ทำซ้ำเคสเดิมได้",
      "Feedback รายเคส",
    ],
    cta: "สมัคร Long Case",
    popular: false,
    type: "longcase_monthly" as const,
    yearlyType: "longcase_yearly" as const,
  },
  {
    name: "School (Y1–Y6)",
    ...planCardPrice("school_monthly"),
    period: "/ เดือน",
    description: `หรือรายปี ฿${planDisplayPrice("school_yearly").price.toLocaleString()}`,
    features: [
      "Flashcard / Quiz ไม่จำกัด",
      "บทเรียนรายวัน + SRS review",
      "ตาม curriculum ปี 1–6",
    ],
    cta: "สมัคร School",
    popular: false,
    type: "school_monthly" as const,
    yearlyType: "school_yearly" as const,
  },
] as const;

/**
 * Board exam pricing — separate from student pricing because the target
 * audience and AI cost profile is different (oral examiner uses Sonnet
 * heavily, plus Opus scoring per session).
 */
export const BOARD_PRICING_PLANS = [
  {
    name: "Board รายเดือน",
    ...planCardPrice("board_monthly"),
    period: "/ เดือน",
    description: "เตรียมสอบบอร์ดราชวิทยาลัยฯ ครบทุกสาขา",
    features: [
      "📚 MCQ บอร์ดทุกสาขาไม่จำกัด",
      "🎙️ Oral Exam (Long Case) กับ อ.บอร์ด AI ไม่จำกัด",
      "📊 จำลองสอบจริง (Mock) ตาม Blueprint",
      "ข้อสอบใหม่ทุกวัน",
      "อ้างอิงตำราหลักของสาขา (Tintinalli/Harrison/ฯลฯ)",
    ],
    cta: "สมัคร Board รายเดือน",
    popular: true,
    type: "board_monthly" as const,
  },
  {
    name: "Board รายปี",
    ...planCardPrice("board_yearly"),
    period: "/ ปี",
    description: `ประหยัดกว่ารายเดือน ${BOARD_SAVING.percent}% — เหมาะกับเตรียมสอบ 1 รอบเต็ม`,
    features: [
      "ทุกอย่างในแพ็ก Board รายเดือน",
      `ประหยัด ฿${BOARD_SAVING.baht.toLocaleString()}/ปี`,
      "ใช้เตรียมสอบทั้งปีไม่จำกัด",
      "สิทธิ์ทดลอง feature ใหม่ก่อนใคร",
    ],
    cta: "สมัคร Board รายปี",
    popular: false,
    badge: "คุ้มที่สุด",
    type: "board_yearly" as const,
  },
] as const;
