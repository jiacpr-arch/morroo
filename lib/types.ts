export interface Profile {
  id: string;
  email: string;
  name: string;
  role: "user" | "admin";
  membership_type: "free" | "monthly" | "yearly" | "bundle" | "mcq_monthly" | "mcq_yearly" | "meq_monthly" | "meq_yearly" | "longcase_monthly" | "longcase_yearly";
  membership_expires_at: string | null;
  created_at: string;
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
}

export interface LongCaseSession {
  id: string;
  case_id: string;
  user_id: string;
  phase: "history" | "pe" | "lab" | "ddx" | "management" | "examiner" | "done";
  history_chat: { role: "user" | "assistant"; content: string }[];
  pe_selected: string[];
  lab_ordered: string[];
  student_ddx: string | null;
  student_mgmt: string | null;
  student_notes: string | null;
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
  pe_findings: Record<string, string>;
  lab_results: Record<string, { value: string; isAbnormal: boolean }>;
  imaging_results: Record<string, { value: string; isAbnormal: boolean }> | null;
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

// ============================================================
// Access control helpers
// ============================================================
export const MCQ_PLAN_TYPES = ["monthly", "yearly", "bundle", "mcq_monthly", "mcq_yearly"] as const;
export const MEQ_PLAN_TYPES = ["monthly", "yearly", "bundle", "meq_monthly", "meq_yearly"] as const;
export const LONGCASE_PLAN_TYPES = ["monthly", "yearly", "bundle", "longcase_monthly", "longcase_yearly"] as const;

export function hasMcqAccess(membershipType: string, expiresAt: string | null): boolean {
  if (!MCQ_PLAN_TYPES.includes(membershipType as (typeof MCQ_PLAN_TYPES)[number])) return false;
  if (!expiresAt) return false;
  return new Date(expiresAt) > new Date();
}

export function hasMeqAccess(membershipType: string, expiresAt: string | null): boolean {
  if (!MEQ_PLAN_TYPES.includes(membershipType as (typeof MEQ_PLAN_TYPES)[number])) return false;
  if (!expiresAt) return false;
  return new Date(expiresAt) > new Date();
}

export function hasLongCaseAccess(membershipType: string, expiresAt: string | null): boolean {
  if (!LONGCASE_PLAN_TYPES.includes(membershipType as (typeof LONGCASE_PLAN_TYPES)[number])) return false;
  if (!expiresAt) return false;
  return new Date(expiresAt) > new Date();
}

// ============================================================
// Pricing Plans
// ============================================================

export const FREE_PLAN = {
  name: "ฟรี",
  price: 0,
  originalPrice: null as number | null,
  period: "",
  description: "ทดลองทุกประเภทก่อนตัดสินใจ",
  features: [
    "MCQ 5 ข้อ/สาขา (เฉลยสั้น)",
    "MEQ 2 เคส (feedback สั้น)",
    "Long Case 1 เคส (ไม่เห็นคะแนนละเอียด)",
  ],
  cta: "เริ่มต้นฟรี",
  popular: false,
  type: "free" as const,
};

export const BUNDLE_PLAN = {
  name: "Bundle",
  price: 99,
  originalPrice: null as number | null,
  period: "/ 30 วัน",
  description: "ลองครบทุกอย่างก่อนสมัคร",
  features: [
    "MCQ 20 ข้อที่เลือกเอง (เฉลยละเอียด)",
    "MEQ 5 เคส (เฉลยละเอียด + Key Points)",
    "🩺 Long Case 2 เคส",
    "🤖 AI ตรวจคำตอบ",
    "หมดอายุใน 30 วัน",
  ],
  cta: "ซื้อ Bundle ฿99",
  popular: false,
  type: "bundle" as const,
};

export const SINGLE_PLANS = [
  {
    name: "MCQ",
    price: 99,
    originalPrice: 149 as number | null,
    period: "/ เดือน",
    description: "เตรียมสอบ MCQ โดยเฉพาะ",
    features: [
      "MCQ ไม่จำกัดทุกสาขา",
      "เฉลยละเอียด + Key Points",
      "🤖 AI ตรวจคำตอบไม่จำกัด",
      "ไม่รวม MEQ และ Long Case",
    ],
    cta: "สมัคร MCQ",
    popular: false,
    type: "mcq_monthly" as const,
  },
  {
    name: "MEQ",
    price: 99,
    originalPrice: 149 as number | null,
    period: "/ เดือน",
    description: "เตรียมสอบ MEQ โดยเฉพาะ",
    features: [
      "MEQ ไม่จำกัดทุกข้อ",
      "🤖 AI ตรวจคำตอบไม่จำกัด",
      "เฉลยละเอียด + Key Points",
      "ไม่รวม MCQ และ Long Case",
    ],
    cta: "สมัคร MEQ",
    popular: false,
    type: "meq_monthly" as const,
  },
  {
    name: "Long Case",
    price: 99,
    originalPrice: 149 as number | null,
    period: "/ เดือน",
    description: "เตรียมสอบ Long Case โดยเฉพาะ",
    features: [
      "🩺 Long Case ไม่จำกัด",
      "AI รับบทผู้ป่วยและกรรมการ",
      "คะแนนและ feedback ละเอียด",
      "ไม่รวม MCQ และ MEQ",
    ],
    cta: "สมัคร Long Case",
    popular: false,
    type: "longcase_monthly" as const,
  },
] as const;

export const FULL_PLANS = [
  {
    name: "Full รายเดือน",
    price: 199,
    originalPrice: 299 as number | null,
    period: "/ เดือน",
    description: "MCQ + MEQ + Long Case ครบ",
    features: [
      "MCQ ไม่จำกัดทุกสาขา",
      "MEQ ไม่จำกัดทุกข้อ",
      "🩺 Long Case ไม่จำกัด",
      "🤖 AI ตรวจคำตอบไม่จำกัด",
      "ข้อสอบใหม่ทุกสัปดาห์",
    ],
    cta: "สมัคร Full รายเดือน",
    popular: true,
    type: "monthly" as const,
  },
  {
    name: "Full รายปี",
    price: 1490,
    originalPrice: 2388 as number | null,
    period: "/ ปี",
    description: "ประหยัดกว่า 38%",
    features: [
      "MCQ + MEQ + Long Case ครบ",
      "🤖 AI ตรวจคำตอบไม่จำกัด",
      "ข้อสอบใหม่ทุกสัปดาห์",
      "สิทธิ์ก่อนใคร",
      `ประหยัด ฿${(2388 - 1490).toLocaleString()}/ปี`,
    ],
    cta: "สมัคร Full รายปี",
    popular: false,
    type: "yearly" as const,
  },
] as const;

// Legacy export for backward compat
export const PRICING_PLANS = [FREE_PLAN, BUNDLE_PLAN, ...FULL_PLANS] as const;
export const MCQ_ONLY_PLANS = [SINGLE_PLANS[0]] as const;
export const MEQ_ONLY_PLANS = [SINGLE_PLANS[1]] as const;
