// Background registry — Code Blue Sim
//
// ฉากหลังเป็น "ข้อมูล" เหมือนตัวละคร:
//   - โจทย์เลือกฉากด้วย field `bg` (id ด้านล่าง) — ไม่ระบุ = er_bay
//   - รูปจริงวางที่ public/images/sim/backgrounds/{id}.webp (แนวนอน 1536x1024)
//   - id ที่ประกาศไว้แต่ยังไม่มีไฟล์รูป ให้คงอยู่นอก SIM_BG_READY ก่อน —
//     เกมจะ fallback เป็น er_bay จนกว่าจะวางไฟล์แล้วย้าย id เข้า SIM_BG_READY
//     (โจทย์ใน DB ติด bg ไว้ล่วงหน้าได้เลย ไม่ต้องรอรูป)

/** ฉากทั้งหมดที่โจทย์อ้างถึงได้ (validate ยึดตามนี้) */
export const SIM_BACKGROUNDS: Record<string, { name: string }> = {
  er_bay: { name: "ห้องฉุกเฉิน (Resuscitation Bay)" },
  opd_room: { name: "ห้องตรวจ OPD" },
  ward_day: { name: "หอผู้ป่วยใน (กลางวัน)" },
  ward_night: { name: "หอผู้ป่วยใน (เวรดึก)" },
  labor_room: { name: "ห้องคลอด" },
  nursery: { name: "หอทารกแรกเกิด" },
  icu: { name: "ICU" },
};

/** ฉากที่มีไฟล์รูปแล้ว — เพิ่ม id ที่นี่เมื่อวางรูปใน public/images/sim/backgrounds/ */
const SIM_BG_READY = new Set(["er_bay", "opd_room"]);

export const DEFAULT_BG = "er_bay";

/** URL รูปฉากของโจทย์ — ฉากที่ยังไม่มีรูป (หรือ id แปลกๆ) ใช้ er_bay ไปก่อน */
export function simBgUrl(bg?: string): string {
  const id = bg && SIM_BG_READY.has(bg) ? bg : DEFAULT_BG;
  return `/images/sim/backgrounds/${id}.webp`;
}
