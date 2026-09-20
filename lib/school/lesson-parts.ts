/**
 * Lesson bodies are authored as several reading "parts" separated by a
 * `## ⏸ Mini Quiz` marker line. Each marker is a retrieval gate: the reader must
 * answer a quiz about the part they just read before continuing.
 *
 * Previously the quiz shown at each gate was pulled at random from a topic-wide
 * question pool, so the question rarely matched the part above it. To guarantee
 * a match, the quiz that belongs to a gate is now authored *inline* in the
 * lesson body, right after its marker, as a fenced ```quiz JSON block:
 *
 *   <part 1 content>
 *
 *   ## ⏸ Mini Quiz
 *   ```quiz
 *   { "stem": "...", "choices": [...], "correct_answer": "B", "explanation": "..." }
 *   ```
 *
 *   <part 2 content>
 *
 * `splitLessonParts` returns the reading parts together with the inline quiz for
 * each gate (or null when a lesson hasn't been migrated yet, in which case the
 * reader can fall back to the legacy pool).
 *
 * A lesson body may end on a gate ("trailing gate" — a quiz after the very last
 * part, with nothing following it): `parts.length === gateQuizzes.length` then,
 * instead of the older `parts.length === gateQuizzes.length + 1` shape where the
 * last part has no quiz. Both shapes parse; `joinLessonParts`/`buildLessonBody`
 * both produce and round-trip either one. The "mini class" reader wants every
 * section — including the last — to end on a question, hence the trailing gate.
 */

import type { SchoolDifficulty } from "@/lib/types-school";

export interface InlineQuiz {
  stem: string;
  choices: { label: string; text: string }[];
  correct_answer: string;
  explanation: string | null;
  /**
   * Authored level of this gate quiz. Quizzes should be authored so that the
   * difficulty ramps gradually across a lesson's Parts (easy gates first, harder
   * gates deeper in). Null when a legacy block omits it.
   */
  difficulty: SchoolDifficulty | null;
}

const DIFFICULTIES: SchoolDifficulty[] = ["easy", "medium", "hard"];

export interface LessonParts {
  /** Reading sections, in order. */
  parts: string[];
  /** gateQuizzes[i] is shown after parts[i]; null when none is authored inline. */
  gateQuizzes: (InlineQuiz | null)[];
}

/** Same marker, but capturing so `.split` keeps the exact marker text for lossless reconstruction. */
const MARKER_CAPTURE_RE = /(^##\s*⏸\s*Mini Quiz.*$)/m;
const QUIZ_BLOCK_RE = /^\s*```quiz\s*\n([\s\S]*?)\n```\s*/;

function parseQuiz(raw: string): InlineQuiz | null {
  try {
    const obj = JSON.parse(raw) as Partial<InlineQuiz>;
    if (
      obj &&
      typeof obj.stem === "string" &&
      Array.isArray(obj.choices) &&
      obj.choices.every(
        (c) => c && typeof c.label === "string" && typeof c.text === "string"
      ) &&
      typeof obj.correct_answer === "string"
    ) {
      return {
        stem: obj.stem,
        choices: obj.choices,
        correct_answer: obj.correct_answer,
        explanation:
          typeof obj.explanation === "string" ? obj.explanation : null,
        difficulty:
          typeof obj.difficulty === "string" &&
          DIFFICULTIES.includes(obj.difficulty as SchoolDifficulty)
            ? (obj.difficulty as SchoolDifficulty)
            : null,
      };
    }
  } catch {
    // Malformed block — treat as no inline quiz.
  }
  return null;
}

export function splitLessonParts(md: string): LessonParts {
  const { parts, gateQuizzes } = splitLessonPartsRaw(md);
  return { parts, gateQuizzes };
}

export interface LessonPartsRaw extends LessonParts {
  /**
   * gateRaw[i] is the exact original text (marker line + inline quiz fence,
   * if any) that sat between parts[i] and parts[i+1] — kept verbatim so an
   * editor can rewrite part text without disturbing the marker/quiz it
   * doesn't touch. Pair with `joinLessonParts` to reconstruct `body_md`.
   */
  gateRaw: string[];
}

/** Like `splitLessonParts`, but also keeps the raw separator text for editing round-trips. */
export function splitLessonPartsRaw(md: string): LessonPartsRaw {
  if (!md) return { parts: [""], gateQuizzes: [], gateRaw: [] };

  // Capturing split → [content0, marker1, content1, marker2, content2, ...]
  const chunks = md.split(MARKER_CAPTURE_RE);
  const parts: string[] = [chunks[0].trim()];
  const gateQuizzes: (InlineQuiz | null)[] = [];
  const gateRaw: string[] = [];

  for (let i = 1; i < chunks.length; i += 2) {
    const markerLine = chunks[i];
    const rest = chunks[i + 1] ?? "";
    const block = rest.match(QUIZ_BLOCK_RE);
    const quiz = block ? parseQuiz(block[1]) : null;
    gateQuizzes.push(quiz);
    gateRaw.push(block ? `${markerLine}\n${block[0].trim()}` : markerLine);
    parts.push((block ? rest.slice(block[0].length) : rest).trim());
  }

  // Trailing gate: the body ends right after the last marker/quiz, so the part
  // after it is empty. Drop that empty part so parts.length === gateRaw.length
  // — the last gate's quiz belongs to the last real section, not to a blank one.
  if (gateRaw.length > 0 && parts[parts.length - 1] === "") {
    parts.pop();
  }

  return { parts, gateQuizzes, gateRaw };
}

/** True when `md` ends on a gate (a quiz after the last section, nothing following it). */
export function hasTrailingGate(md: string): boolean {
  const { parts, gateRaw } = splitLessonPartsRaw(md);
  return gateRaw.length > 0 && parts.length === gateRaw.length;
}

/**
 * Inverse of `splitLessonPartsRaw` — rebuilds `body_md` from (possibly edited)
 * parts + the untouched gate separators. Handles both shapes: a trailing gate
 * (`parts.length === gateRaw.length`, produced when the body ends on a quiz)
 * and the legacy shape (`parts.length === gateRaw.length + 1`).
 */
export function joinLessonParts(parts: string[], gateRaw: string[]): string {
  let out = (parts[0] ?? "").trim();
  for (let i = 0; i < gateRaw.length; i++) {
    const next = i + 1 < parts.length ? parts[i + 1].trim() : "";
    out += `\n\n${gateRaw[i]}`;
    if (next) out += `\n\n${next}`;
  }
  return out;
}

/**
 * Build a lesson body from a list of short sections, each ending on a
 * mini-quiz gate — the canonical "mini class" shape (trailing gate, every
 * section including the last has a question). Used by the re-split script and
 * anywhere else that authors a lesson body directly rather than editing an
 * existing one part-by-part.
 */
export function buildLessonBody(
  sections: { body: string; quiz: InlineQuiz }[]
): string {
  const parts = sections.map((s) => s.body.trim());
  const gateRaw = sections.map((s) => {
    const json = JSON.stringify(
      {
        stem: s.quiz.stem,
        choices: s.quiz.choices,
        correct_answer: s.quiz.correct_answer,
        explanation: s.quiz.explanation,
        difficulty: s.quiz.difficulty,
      },
      null,
      2
    );
    return `## ⏸ Mini Quiz\n\`\`\`quiz\n${json}\n\`\`\``;
  });
  return joinLessonParts(parts, gateRaw);
}
