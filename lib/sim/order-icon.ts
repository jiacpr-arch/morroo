// ไอคอนบนการ์ดชั้น order — เดาหมวดจากข้อความ order (แสดงผลอย่างเดียว ไม่มีผลต่อคะแนน)

const RULES: [RegExp, string][] = [
  [/ครบแล้ว|ส่งเวร/, "📋"],
  [/ปรึกษา|consult|refer|ส่งต่อ/i, "📞"],
  [/ผ่าตัด|surg|explor|ectomy|otomy|pexy|plasty|OR\b/i, "🔪"],
  [/\bIV\b|drip|NSS|saline|LRS|fluid|สารน้ำ|transfus|เลือด/i, "💉"],
  [/\bCT\b|MRI|X-?ray|CXR|ultrasound|\bUS\b|echo|EKG|ECG|angio|lab|CBC|culture|ตรวจ/i, "🧪"],
  [/monitor|observe|vital|เฝ้า|สังเกต|O2|oxygen|ออกซิเจน|admit|ICU/i, "🩺"],
  [/NPO|งดน้ำ|งดอาหาร|diet|อาหาร/i, "🍽️"],
];

export function orderIcon(label: string): string {
  for (const [re, icon] of RULES) if (re.test(label)) return icon;
  return "💊";
}
