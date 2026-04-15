export interface Profile {
  id: string;
  email: string;
  name: string;
  role: "user" | "admin";
  membership_type: "free" | "monthly" | "yearly" | "bundle";
  membership_expires_at: string | null;
  created_at: string;
  onboarding_done: boolean;
  daily_goal: number;
  target_exam: "NL1" | "NL2" | "both" | null;
  weak_subjects: string[] | null;
  referral_code: string | null;
  referred_by: string | null;
  reporter_points: number;
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
    price: 199,
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
    price: 1490,
    period: "/ ปี",
    description: "ประหยัดกว่า 38%",
    features: [
      "ทุกอย่างในแพ็กรายเดือน",
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
