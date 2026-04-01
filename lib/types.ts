export interface Profile {
  id: string;
  email: string;
  name: string;
  role: "user" | "admin";
  membership_type: "free" | "monthly" | "yearly" | "bundle" | "mcq_monthly" | "mcq_yearly" | "meq_monthly" | "meq_yearly";
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

// Access control helpers
export const MCQ_PLAN_TYPES = ["monthly", "yearly", "bundle", "mcq_monthly", "mcq_yearly"] as const;
export const MEQ_PLAN_TYPES = ["monthly", "yearly", "meq_monthly", "meq_yearly"] as const;
export const LONGCASE_PLAN_TYPES = ["monthly", "yearly", "bundle"] as const;

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
      "MCQ เลือกข้อสอบ 10 ข้อ",
      "ดูเฉลยละเอียด",
      "Key Points ทุกข้อ",
      "🤖 AI ตรวจคำตอบอัตโนมัติ",
      "🩺 Long Case Exam ไม่จำกัด",
      "หมดอายุใน 30 วัน",
    ],
    cta: "ซื้อชุดข้อสอบ",
    popular: false,
    type: "bundle" as const,
  },
  {
    name: "รายเดือน (ครบ)",
    price: 199,
    period: "/ เดือน",
    description: "MCQ + MEQ + Long Case ครบ",
    features: [
      "MCQ ไม่จำกัด + เฉลยละเอียด",
      "MEQ ทุกข้อไม่จำกัด",
      "🩺 Long Case Exam ไม่จำกัด",
      "🤖 AI ตรวจคำตอบไม่จำกัด",
      "ข้อสอบใหม่ทุกสัปดาห์",
    ],
    cta: "สมัครรายเดือน",
    popular: true,
    type: "monthly" as const,
  },
  {
    name: "รายปี (ครบ)",
    price: 1490,
    period: "/ ปี",
    description: "ประหยัดกว่า 38%",
    features: [
      "MCQ + MEQ + Long Case ครบ",
      "🤖 AI ตรวจคำตอบไม่จำกัด",
      "🩺 Long Case Exam ไม่จำกัด",
      "ประหยัด ฿898/ปี",
      "สิทธิ์ก่อนใคร",
    ],
    cta: "สมัครรายปี",
    popular: false,
    type: "yearly" as const,
  },
] as const;

export const MCQ_ONLY_PLANS = [
  {
    name: "MCQ รายเดือน",
    price: 129,
    period: "/ เดือน",
    description: "ข้อสอบ MCQ เท่านั้น",
    features: [
      "MCQ ไม่จำกัดทุกสาขา",
      "เฉลยละเอียดทุกข้อ",
      "Key Points",
      "ไม่รวม MEQ และ Long Case",
    ],
    cta: "สมัคร MCQ รายเดือน",
    popular: false,
    type: "mcq_monthly" as const,
  },
  {
    name: "MCQ รายปี",
    price: 990,
    period: "/ ปี",
    description: "ประหยัดกว่ารายเดือน 36%",
    features: [
      "MCQ ไม่จำกัดทุกสาขา",
      "เฉลยละเอียดทุกข้อ",
      "Key Points",
      "ประหยัด ฿558/ปี",
      "ไม่รวม MEQ และ Long Case",
    ],
    cta: "สมัคร MCQ รายปี",
    popular: false,
    type: "mcq_yearly" as const,
  },
] as const;

export const MEQ_ONLY_PLANS = [
  {
    name: "MEQ รายเดือน",
    price: 129,
    period: "/ เดือน",
    description: "ข้อสอบ MEQ เท่านั้น",
    features: [
      "MEQ ไม่จำกัดทุกข้อ",
      "🤖 AI ตรวจคำตอบไม่จำกัด",
      "เฉลยและ Key Points",
      "ไม่รวม MCQ และ Long Case",
    ],
    cta: "สมัคร MEQ รายเดือน",
    popular: false,
    type: "meq_monthly" as const,
  },
  {
    name: "MEQ รายปี",
    price: 990,
    period: "/ ปี",
    description: "ประหยัดกว่ารายเดือน 36%",
    features: [
      "MEQ ไม่จำกัดทุกข้อ",
      "🤖 AI ตรวจคำตอบไม่จำกัด",
      "เฉลยและ Key Points",
      "ประหยัด ฿558/ปี",
      "ไม่รวม MCQ และ Long Case",
    ],
    cta: "สมัคร MEQ รายปี",
    popular: false,
    type: "meq_yearly" as const,
  },
] as const;
