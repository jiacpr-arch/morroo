// เลือกตัวละครผู้ป่วย (sprite) จากเพศ/วัยของเคส — ใช้ร่วมกันทั้ง Code Blue Sim
// (longcase-to-scenario) และหน้าผู้ป่วยใน Long Case session

function asStr(x: unknown): string {
  return typeof x === "string" ? x : x == null ? "" : String(x);
}

/** อายุเป็นปี (ทศนิยมได้) — รองรับทั้งตัวเลขล้วนและ string แบบ "8 เดือน"/"19 ปี" */
export function ageYears(raw: unknown): number | null {
  if (typeof raw === "number" && Number.isFinite(raw)) return raw;
  const s = asStr(raw);
  const m = s.match(/([\d.]+)/);
  if (!m) return null;
  const n = Number(m[1]);
  if (!Number.isFinite(n)) return null;
  if (/เดือน|month/i.test(s)) return n / 12;
  if (/วัน|day/i.test(s)) return n / 365;
  return n;
}

/**
 * เลือก sprite ผู้ป่วยให้ตรงเพศ/วัยจาก patient_info + ประวัติ
 * (แก้บั๊กเดิมที่ hardcode patient_generic ทำให้เด็ก 8 เดือนโผล่เป็นชายวัย 50 —
 * และแก้บั๊กที่ตามมาว่าชายหนุ่ม เช่น 19 ปี ปวดอัณฑะ ก็โผล่เป็น patient_generic
 * ซึ่งวาดเป็นชายวัยกลางคน ~50 ปีเหมือนกันหมด ไม่ว่าอายุจริงจะเท่าไร)
 * - แสดงครรภ์เฉพาะเมื่อข้อความบอกชัดว่าท้องแก่/GA ≥ 20 สัปดาห์ — ครรภ์อ่อน
 *   (เช่น ectopic 7 สัปดาห์) ยังไม่เห็นท้อง ใช้ sprite หญิงปกติถูกกว่า
 * - ชาย: อายุ <35 ใช้ patient_young_male, 35-59 ใช้ patient_generic (ชายวัยกลางคน),
 *   ≥60 ใช้ patient_elderly_male
 */
export function patientCharId(pi: Record<string, unknown>, hxText: string): string {
  const age = ageYears(pi.age);
  const female = /หญิง|female/i.test(asStr(pi.gender));
  if (age !== null && age < 15) return "patient_child";
  if (female) {
    const ga = hxText.match(/(?:GA|อายุครรภ์|ตั้งครรภ์|ครรภ์)\D{0,10}(\d{1,2})\s*(?:สัปดาห์|wk|week)/i);
    if (/ท้องแก่|ครรภ์แก่|ใกล้คลอด/.test(hxText) || (ga && Number(ga[1]) >= 20)) return "patient_pregnant";
    if (age !== null && age >= 60) return "patient_elderly";
    return "patient_female";
  }
  if (age !== null && age >= 60) return "patient_elderly_male";
  if (age !== null && age < 35) return "patient_young_male";
  return "patient_generic";
}

/** เด็กเล็ก/ทารกพูดเองไม่ได้ — ให้แม่/ญาติเป็นคนตอบซักประวัติแทน */
export function historySpeaker(pi: Record<string, unknown>, patientChar: string): string {
  const age = ageYears(pi.age);
  return patientChar === "patient_child" && age !== null && age < 7 ? "mother_rel" : patientChar;
}
