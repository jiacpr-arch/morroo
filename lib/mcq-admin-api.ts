// ตัวช่วย pure ของ /api/admin/mcq/questions — admin อ่าน/เขียนข้อสอบ MCQ
// ผ่าน service role แทน client ในเบราว์เซอร์ (คอลัมน์เฉลยถูก revoke จาก
// anon/authenticated ดู supabase/migrations/20260927_hide_mcq_answers.sql)

export const MCQ_STATUSES = ["active", "review", "disabled"] as const;
export type McqStatus = (typeof MCQ_STATUSES)[number];

export function isMcqStatus(v: unknown): v is McqStatus {
  return typeof v === "string" && (MCQ_STATUSES as readonly string[]).includes(v);
}

/** คอลัมน์ที่ admin เขียนได้ (ตรงกับ McqQuestionInput) — กัน id/created_at/คอลัมน์แปลกๆ */
export const MCQ_WRITABLE_COLUMNS = [
  "subject_id",
  "exam_type",
  "exam_source",
  "question_number",
  "scenario",
  "choices",
  "correct_answer",
  "explanation",
  "detailed_explanation",
  "is_ai_enhanced",
  "ai_notes",
  "difficulty",
  "difficulty_level",
  "topic",
  "status",
  "audience",
  "board_specialty",
  "board_subspecialty",
  "board_section",
  "board_topic",
  "board_age_group",
  "board_level",
  "reference_source",
] as const;

/** เก็บเฉพาะคอลัมน์ที่เขียนได้; null ถ้า body ไม่ใช่ object หรือไม่เหลืออะไรเลย */
export function pickWritableMcqFields(raw: unknown): Record<string, unknown> | null {
  if (!raw || typeof raw !== "object" || Array.isArray(raw)) return null;
  const src = raw as Record<string, unknown>;
  const out: Record<string, unknown> = {};
  for (const col of MCQ_WRITABLE_COLUMNS) {
    if (Object.prototype.hasOwnProperty.call(src, col) && src[col] !== undefined) {
      out[col] = src[col];
    }
  }
  if (out.status !== undefined && !isMcqStatus(out.status)) return null;
  return Object.keys(out).length > 0 ? out : null;
}

/** ชุดคอลัมน์ที่หน้า admin แต่ละหน้าใช้ (GET /api/admin/mcq/questions?view=...) */
export const MCQ_ADMIN_VIEWS = {
  /** /admin/mcq — ตารางรวม */
  list: "id, subject_id, exam_type, scenario, correct_answer, difficulty, status, topic, audience, board_specialty, board_section, created_at, mcq_subjects(name_th, icon)",
  /** /admin/mcq/csv — export CSV ข้อที่รอตรวจ */
  export:
    "id, exam_source, exam_type, scenario, choices, correct_answer, explanation, detailed_explanation, mcq_subjects(name_th)",
  /** /admin/board/review — คิวตรวจข้อบอร์ด (ReviewQuestionCard ใช้ทั้งแถว) */
  review: "*",
  /** /admin/mcq/auto-answer — โจทย์ที่จะส่งให้ AI เฉลย */
  answer: "id, scenario, choices",
  /** /admin/mcq/[id] — ฟอร์มแก้ไข */
  detail:
    "id, subject_id, exam_type, exam_source, scenario, choices, correct_answer, explanation, detailed_explanation, difficulty, topic, status, audience, board_section, board_topic, board_age_group, board_level, reference_source",
} as const;

export type McqAdminView = keyof typeof MCQ_ADMIN_VIEWS;

export function isMcqAdminListView(v: unknown): v is Exclude<McqAdminView, "detail"> {
  return v === "list" || v === "export" || v === "review" || v === "answer";
}

export interface McqAdminListFilters {
  status?: McqStatus;
  audience?: "student" | "board";
  exam_source?: string;
  subject_id?: string;
  board_specialty?: string;
  board_section?: string;
  /** เฉพาะข้อที่ยังไม่มี detailed_explanation */
  missing_detailed?: boolean;
  order: "asc" | "desc";
  offset: number;
  limit: number;
}

export const MCQ_ADMIN_MAX_PAGE = 1000;

export function parseMcqAdminListFilters(params: URLSearchParams): McqAdminListFilters {
  const str = (k: string) => {
    const v = params.get(k);
    return v && v.trim() ? v.trim() : undefined;
  };
  const status = str("status");
  const audience = str("audience");
  const offset = Math.max(0, Math.floor(Number(params.get("offset") ?? 0)) || 0);
  const rawLimit = Math.floor(Number(params.get("limit") ?? MCQ_ADMIN_MAX_PAGE)) || MCQ_ADMIN_MAX_PAGE;
  return {
    status: isMcqStatus(status) ? status : undefined,
    audience: audience === "student" || audience === "board" ? audience : undefined,
    exam_source: str("exam_source"),
    subject_id: str("subject_id"),
    board_specialty: str("board_specialty"),
    board_section: str("board_section"),
    missing_detailed: params.get("missing_detailed") === "1",
    order: params.get("order") === "asc" ? "asc" : "desc",
    offset,
    limit: Math.min(Math.max(rawLimit, 1), MCQ_ADMIN_MAX_PAGE),
  };
}
