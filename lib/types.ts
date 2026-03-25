export interface Profile {
  id: string;
  email: string;
  name: string;
  role: "user" | "admin";
  membership_type: "free" | "monthly" | "yearly" | "bundle";
  membership_expires_at: string | null;
  created_at: string;
}

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
      "ทำข้อสอบฟรี 2 ข้อ/เดือน",
      "ดูโจทย์ได้ทุกข้อ",
      "ไม่เห็นเฉลย",
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
      "ประหยัด ฿898/ปี",
      "สิทธิ์ก่อนใคร",
    ],
    cta: "สมัครรายปี",
    popular: false,
    type: "yearly" as const,
  },
] as const;
