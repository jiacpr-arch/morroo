/**
 * Moving School content that was imported into the wrong subject (topic).
 *
 * The AI import writes one lesson + its flashcards + quizzes per uploaded file,
 * all sharing `topic_id` and `source` (the file name). Moving a "batch" moves
 * everything from that file; moving a "lesson" moves just that lesson. Either
 * way the lessons' Visual Summary cards (school_visuals.lesson_id) move with
 * them so the card doesn't stay locked behind the old subject.
 */
import { isUuid } from "./ids";

export type MoveScope =
  | { kind: "batch"; source: string | null }
  | { kind: "lesson"; id: string };

export interface MoveRequest {
  fromTopicId: string;
  toTopicId: string;
  scope: MoveScope;
}

export interface MoveResult {
  ok: true;
  lessons: number;
  flashcards: number;
  quizzes: number;
}

export type ParseResult =
  | { ok: true; value: MoveRequest }
  | { ok: false; error: string };

function isRecord(v: unknown): v is Record<string, unknown> {
  return typeof v === "object" && v !== null && !Array.isArray(v);
}

/** Validate the JSON body of POST /api/admin/school/move. */
export function parseMoveRequest(body: unknown): ParseResult {
  if (!isRecord(body)) return { ok: false, error: "invalid body" };
  const from = body.from_topic_id;
  const to = body.to_topic_id;
  if (!isUuid(from)) return { ok: false, error: "from_topic_id must be a uuid" };
  if (!isUuid(to)) return { ok: false, error: "to_topic_id must be a uuid" };
  if (from.toLowerCase() === to.toLowerCase()) {
    return { ok: false, error: "วิชาปลายทางต้องไม่ใช่วิชาเดิม" };
  }

  const scope = body.scope;
  if (!isRecord(scope)) return { ok: false, error: "scope required" };
  if (scope.kind === "lesson") {
    if (!isUuid(scope.id)) return { ok: false, error: "scope.id must be a uuid" };
    return { ok: true, value: { fromTopicId: from, toTopicId: to, scope: { kind: "lesson", id: scope.id } } };
  }
  if (scope.kind === "batch") {
    // `source` is the uploaded file name, or null for rows imported without one.
    if (scope.source !== null && typeof scope.source !== "string") {
      return { ok: false, error: "scope.source must be a string or null" };
    }
    return {
      ok: true,
      value: { fromTopicId: from, toTopicId: to, scope: { kind: "batch", source: scope.source } },
    };
  }
  return { ok: false, error: "scope.kind must be 'batch' or 'lesson'" };
}
