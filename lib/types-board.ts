import type { McqQuestion } from "./types-mcq";

export interface BoardSpecialty {
  slug: string;
  name_th: string;
  name_en: string;
  short_name_th: string | null;
  icon: string;
  royal_college: string | null;
  description_th: string | null;
  exam_format: string | null;
  total_mcq_count: number | null;
  display_order: number;
  has_long_case: boolean;
  has_osce: boolean;
  has_oral: boolean;
  is_active: boolean;
  is_published: boolean;
  created_at: string;
}

export interface BoardExamBlueprint {
  id: string;
  specialty_slug: string;
  exam_year: number;
  section_code: string;
  section_label_th: string;
  section_label_en: string | null;
  question_count: number;
  display_order: number;
  notes: string | null;
}

export interface BoardTopicCategory {
  id: string;
  blueprint_id: string;
  slug: string;
  name_th: string;
  name_en: string | null;
  peds_count: number;
  adult_count: number;
  other_count: number;
  total_count: number;
  display_order: number;
}

export interface BlueprintWithTopics extends BoardExamBlueprint {
  topics: BoardTopicCategory[];
}

/** Narrow type — board question always has board_specialty + section */
export type BoardQuestion = McqQuestion & {
  audience: "board";
  board_specialty: string;
  board_section: string;
};

/** 4 sections of the EM blueprint — also valid for other specialties' sections */
export const BOARD_SECTIONS = [
  { code: "clinical_decision", label_th: "การตัดสินใจทางเวชกรรม", label_en: "Clinical Decision Making" },
  { code: "basic_science",     label_th: "วิทยาศาสตร์การแพทย์พื้นฐาน", label_en: "Basic Science" },
  { code: "ems_mgmt",          label_th: "การจัดการระบบบริการการแพทย์ฉุกเฉิน", label_en: "EMS Management" },
  { code: "integrative",       label_th: "ข้อสอบบูรณาการ", label_en: "Integrative" },
] as const;

/** Static list of all 12 specialties — kept here for build-time generation
 * (sitemap, generateStaticParams). Source of truth is `board_specialties` table. */
export const BOARD_SPECIALTY_SLUGS = [
  "internal_medicine",
  "surgery",
  "pediatrics",
  "ob_gyn",
  "orthopedics",
  "psychiatry",
  "emergency_medicine",
  "anesthesiology",
  "radiology",
  "family_medicine",
  "pathology",
  "rehab_medicine",
] as const;

export type BoardSpecialtySlug = (typeof BOARD_SPECIALTY_SLUGS)[number];
