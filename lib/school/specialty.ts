/**
 * "เลือกสายเฉพาะทางแบบเกม" — map the student's strengths across body systems
 * onto medical specialties, like picking a class/career in an RPG.
 *
 * Client-safe: pure config + math, no DB access. The caller supplies:
 *   - competency: real performance per system slug, 0–100 (from school_progress)
 *   - interests:  1–5 interest score per system slug (from the questionnaire)
 *
 * System slugs match school_systems.slug seeded in 20260531_school_schema.sql.
 */

export const SYSTEM_SLUGS = [
  "foundation",
  "cardiovascular",
  "respiratory",
  "gi",
  "renal",
  "neuro",
  "endocrine",
  "msk",
  "repro",
  "heme",
  "id",
  "psych",
] as const;

export type SystemSlug = (typeof SYSTEM_SLUGS)[number];

export type CompetencyMap = Partial<Record<string, number>>; // slug -> 0..100
export type InterestMap = Partial<Record<string, number>>; // slug -> 1..5

export interface Specialty {
  id: string;
  name_th: string;
  name_en: string;
  icon: string;
  blurb: string;
  /** How much each system matters for this specialty, 0..1. */
  weights: Partial<Record<SystemSlug, number>>;
}

export const SPECIALTIES: readonly Specialty[] = [
  {
    id: "internal_med",
    name_th: "อายุรศาสตร์",
    name_en: "Internal Medicine",
    icon: "🩺",
    blurb: "เก่งรอบด้าน วินิจฉัยโรคผู้ใหญ่ทั้งระบบ",
    weights: {
      cardiovascular: 0.7, respiratory: 0.6, renal: 0.7, gi: 0.6,
      endocrine: 0.7, heme: 0.6, id: 0.6,
    },
  },
  {
    id: "cardiology",
    name_th: "อายุรศาสตร์โรคหัวใจ",
    name_en: "Cardiology",
    icon: "❤️",
    blurb: "เชี่ยวชาญหัวใจและหลอดเลือด",
    weights: { cardiovascular: 1, renal: 0.5, respiratory: 0.5 },
  },
  {
    id: "neurology",
    name_th: "ประสาทวิทยา",
    name_en: "Neurology",
    icon: "🧠",
    blurb: "สมอง ระบบประสาท และพฤติกรรม",
    weights: { neuro: 1, psych: 0.5, msk: 0.3 },
  },
  {
    id: "general_surgery",
    name_th: "ศัลยศาสตร์",
    name_en: "General Surgery",
    icon: "🔪",
    blurb: "ผ่าตัด — กายวิภาคและช่องท้องต้องแน่น",
    weights: { gi: 0.8, msk: 0.6, cardiovascular: 0.5, heme: 0.4, foundation: 0.5 },
  },
  {
    id: "pediatrics",
    name_th: "กุมารเวชศาสตร์",
    name_en: "Pediatrics",
    icon: "👶",
    blurb: "ดูแลเด็ก — ต้องรอบรู้หลายระบบ",
    weights: { id: 0.7, respiratory: 0.6, repro: 0.5, endocrine: 0.5, heme: 0.5 },
  },
  {
    id: "obgyn",
    name_th: "สูติศาสตร์-นรีเวชวิทยา",
    name_en: "Obstetrics & Gynecology",
    icon: "🤰",
    blurb: "ระบบสืบพันธุ์ การตั้งครรภ์และคลอด",
    weights: { repro: 1, endocrine: 0.5, heme: 0.4 },
  },
  {
    id: "psychiatry",
    name_th: "จิตเวชศาสตร์",
    name_en: "Psychiatry",
    icon: "🧘",
    blurb: "สุขภาพจิตและพฤติกรรมศาสตร์",
    weights: { psych: 1, neuro: 0.5 },
  },
  {
    id: "orthopedics",
    name_th: "ออร์โธปิดิกส์",
    name_en: "Orthopedics",
    icon: "🦴",
    blurb: "กระดูก ข้อ และกล้ามเนื้อ",
    weights: { msk: 1, foundation: 0.3 },
  },
  {
    id: "dermatology",
    name_th: "ตจวิทยา",
    name_en: "Dermatology",
    icon: "🧴",
    blurb: "ผิวหนัง — เชื่อมภูมิคุ้มกันและต่อมไร้ท่อ",
    weights: { id: 0.6, foundation: 0.5, endocrine: 0.4 },
  },
  {
    id: "emergency",
    name_th: "เวชศาสตร์ฉุกเฉิน",
    name_en: "Emergency Medicine",
    icon: "🚑",
    blurb: "ตัดสินใจไว ดูแลภาวะวิกฤตทุกระบบ",
    weights: {
      cardiovascular: 0.7, respiratory: 0.7, neuro: 0.6, msk: 0.5, id: 0.5,
    },
  },
  {
    id: "radiology",
    name_th: "รังสีวิทยา",
    name_en: "Radiology",
    icon: "🩻",
    blurb: "อ่านภาพถ่าย — กายวิภาคต้องแม่น",
    weights: {
      foundation: 0.7, msk: 0.5, cardiovascular: 0.5, respiratory: 0.5, neuro: 0.5,
    },
  },
  {
    id: "anesthesiology",
    name_th: "วิสัญญีวิทยา",
    name_en: "Anesthesiology",
    icon: "💉",
    blurb: "คุมการหายใจ-ไหลเวียนเลือดระหว่างผ่าตัด",
    weights: {
      respiratory: 0.8, cardiovascular: 0.7, renal: 0.5, foundation: 0.5,
    },
  },
] as const;

export function getSpecialty(id: string | null | undefined): Specialty | null {
  if (!id) return null;
  return SPECIALTIES.find((s) => s.id === id) ?? null;
}

const COMPETENCY_WEIGHT = 0.6;
const INTEREST_WEIGHT = 0.4;

/**
 * Blended 0..1 profile per system: real performance + stated interest. For a
 * brand-new student (competency all 0) interest carries the signal, so the
 * page is useful from day one.
 */
export function blendProfile(
  competency: CompetencyMap,
  interests: InterestMap | null | undefined
): Record<string, number> {
  const out: Record<string, number> = {};
  for (const slug of SYSTEM_SLUGS) {
    const comp = (competency[slug] ?? 0) / 100; // 0..1
    const intRaw = interests?.[slug];
    const int = intRaw ? (intRaw - 1) / 4 : 0; // 1..5 -> 0..1
    out[slug] = COMPETENCY_WEIGHT * comp + INTEREST_WEIGHT * int;
  }
  return out;
}

export interface SpecialtyMatch {
  specialty: Specialty;
  scorePct: number; // 0..100
}

/**
 * Rank specialties by how strong/interested the student is in exactly the
 * systems each specialty cares about (weighted average of the blended
 * profile over the specialty's weights).
 */
export function computeSpecialtyMatch(
  competency: CompetencyMap,
  interests: InterestMap | null | undefined
): SpecialtyMatch[] {
  const profile = blendProfile(competency, interests);
  return SPECIALTIES.map((specialty) => {
    let num = 0;
    let den = 0;
    for (const [slug, w] of Object.entries(specialty.weights)) {
      if (!w) continue;
      num += w * (profile[slug] ?? 0);
      den += w;
    }
    const scorePct = den ? Math.round((num / den) * 100) : 0;
    return { specialty, scorePct };
  }).sort((a, b) => b.scorePct - a.scorePct);
}

/**
 * Systems this specialty needs most where the student's real competency is
 * still weak — i.e. "วิชาที่ควรเน้น" to pursue this path. Returns slugs.
 */
export function focusSystemsFor(
  specialtyId: string,
  competency: CompetencyMap,
  limit = 3
): string[] {
  const sp = getSpecialty(specialtyId);
  if (!sp) return [];
  return Object.entries(sp.weights)
    .filter(([, w]) => (w ?? 0) >= 0.5)
    .map(([slug, w]) => ({
      slug,
      gap: (w ?? 0) * (1 - (competency[slug] ?? 0) / 100),
    }))
    .filter((x) => x.gap > 0.1)
    .sort((a, b) => b.gap - a.gap)
    .slice(0, limit)
    .map((x) => x.slug);
}
