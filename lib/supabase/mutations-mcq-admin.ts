import type { McqChoice, McqChoiceExplanation } from "../types-mcq";
import type { McqAdminListFilters, McqAdminView } from "../mcq-admin-api";

// Admin-only MCQ CRUD — ใช้จากหน้า admin ในเบราว์เซอร์ ยิงไป
// /api/admin/mcq/questions (requireAdmin + service role) เพราะคอลัมน์เฉลย
// (correct_answer / explanation / detailed_explanation / ai_notes) ถูก revoke
// จาก anon/authenticated — ห้ามอ่านเฉลยผ่าน supabase client ของเบราว์เซอร์

export interface McqDetailedExplanation {
  summary: string;
  reason: string;
  choices: McqChoiceExplanation[];
  key_takeaway: string;
}

export interface McqQuestionInput {
  subject_id: string;
  // Student-only — null for board questions
  exam_type?: "NL1" | "NL2" | null;
  exam_source?: string | null;
  question_number?: number | null;
  scenario: string;
  choices: McqChoice[];
  correct_answer: string;
  explanation?: string | null;
  // Per-choice "why" reasoning shown on the answer pages (jsonb column).
  detailed_explanation?: McqDetailedExplanation | null;
  is_ai_enhanced?: boolean;
  ai_notes?: string | null;
  difficulty: "easy" | "medium" | "hard";
  topic?: string | null;
  status: "active" | "review" | "disabled";
  // Board fields — set when audience='board'
  audience?: "student" | "board";
  board_specialty?: string | null;
  board_subspecialty?: string | null;
  board_section?: string | null;
  board_topic?: string | null;
  board_age_group?: "peds" | "adult" | "mixed" | null;
  board_level?: number | null;
  reference_source?: string | null;
}

const BASE = "/api/admin/mcq/questions";

async function send(url: string, method: string, body: unknown): Promise<Response | null> {
  try {
    return await fetch(url, {
      method,
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(body),
    });
  } catch (err) {
    console.error(`MCQ admin ${method} ${url} failed:`, err);
    return null;
  }
}

export async function createMcqQuestion(
  data: McqQuestionInput
): Promise<{ id: string } | null> {
  const res = await send(BASE, "POST", data);
  const json = (await res?.json().catch(() => null)) as { id?: string; error?: string } | null;
  if (!res?.ok || !json?.id) {
    console.error("Error creating MCQ question:", json?.error ?? res?.status);
    return null;
  }
  return { id: json.id };
}

export async function updateMcqQuestion(
  id: string,
  data: Partial<McqQuestionInput>
): Promise<boolean> {
  const res = await send(`${BASE}/${encodeURIComponent(id)}`, "PATCH", data);
  if (!res?.ok) {
    const json = (await res?.json().catch(() => null)) as { error?: string } | null;
    console.error("Error updating MCQ question:", json?.error ?? res?.status);
    return false;
  }
  return true;
}

export async function updateMcqQuestionStatus(
  id: string,
  status: "active" | "review" | "disabled"
): Promise<boolean> {
  return updateMcqQuestion(id, { status });
}

export async function deleteMcqQuestion(id: string): Promise<boolean> {
  // Soft delete: set status = 'disabled'
  return updateMcqQuestionStatus(id, "disabled");
}

export async function bulkUpdateMcqQuestionStatus(
  ids: string[],
  status: "active" | "review" | "disabled"
): Promise<{ ok: number; failed: number }> {
  if (ids.length === 0) return { ok: 0, failed: 0 };
  const res = await send(BASE, "PATCH", { ids, status });
  const json = (await res?.json().catch(() => null)) as { ok?: number; failed?: number } | null;
  if (!res?.ok || typeof json?.ok !== "number") {
    console.error("Bulk status update failed:", res?.status);
    return { ok: 0, failed: ids.length };
  }
  return { ok: json.ok, failed: json.failed ?? ids.length - json.ok };
}

/** ข้อสอบ 1 ข้อพร้อมเฉลย สำหรับฟอร์มแก้ไข (null = ไม่พบ/ไม่มีสิทธิ์) */
export async function fetchAdminMcqQuestion(id: string): Promise<Record<string, unknown> | null> {
  try {
    const res = await fetch(`${BASE}/${encodeURIComponent(id)}`, { cache: "no-store" });
    if (!res.ok) return null;
    const json = (await res.json()) as { question?: Record<string, unknown> };
    return json.question ?? null;
  } catch (err) {
    console.error("Error fetching MCQ question:", err);
    return null;
  }
}

/**
 * อ่านรายการข้อสอบ (รวมเฉลยตาม view) ผ่าน service role หนึ่งหน้า (≤1000 แถว)
 * คืน { rows } หรือ { error }
 */
export async function fetchAdminMcqQuestions<T>(
  view: Exclude<McqAdminView, "detail">,
  filters: Partial<McqAdminListFilters> = {}
): Promise<{ rows: T[]; error: null } | { rows: null; error: string }> {
  const params = new URLSearchParams({ view });
  for (const [k, v] of Object.entries(filters)) {
    if (v === undefined || v === null || v === "" || v === false) continue;
    params.set(k, v === true ? "1" : String(v));
  }
  try {
    const res = await fetch(`${BASE}?${params.toString()}`, { cache: "no-store" });
    const json = (await res.json().catch(() => null)) as { rows?: T[]; error?: string } | null;
    if (!res.ok || !json?.rows) return { rows: null, error: json?.error ?? `HTTP ${res.status}` };
    return { rows: json.rows, error: null };
  } catch (err) {
    return { rows: null, error: String(err) };
  }
}
