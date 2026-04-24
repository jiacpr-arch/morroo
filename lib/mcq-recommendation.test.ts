import { describe, it, expect } from "vitest";
import type { SupabaseClient } from "@supabase/supabase-js";
import { getRecommendedQuestions } from "./mcq-recommendation";
import type { McqQuestion } from "./types-mcq";

interface AttemptRow {
  question_id: string;
  is_correct: boolean;
  created_at: string;
  mcq_questions: { subject_id: string | null } | null;
}

// Minimal chainable mock — records which table was queried and returns the
// matching dataset. The recommendation function only uses from/select/eq/
// order/limit/in.
function makeFake(state: {
  attempts: AttemptRow[];
  questions: McqQuestion[];
  subjects: Array<{ id: string; name_th: string; icon: string }>;
}): SupabaseClient {
  let table = "";
  let filterIds: string[] | null = null;
  let filterSubjects: string[] | null = null;

  type Builder = {
    from(t: string): Builder;
    select(): Builder;
    eq(): Builder;
    order(): Builder;
    limit(): Builder;
    in(col: string, values: string[]): Builder;
    then<T>(resolve: (v: { data: unknown; error: null }) => T): Promise<T>;
  };

  const builder: Builder = {
    from(t: string) {
      table = t;
      filterIds = null;
      filterSubjects = null;
      return builder;
    },
    select: () => builder,
    eq: () => builder,
    order: () => builder,
    limit: () => builder,
    in(col: string, values: string[]) {
      if (col === "id") filterIds = values;
      else if (col === "subject_id") filterSubjects = values;
      return builder;
    },
    then(resolve) {
      let data: unknown = null;
      if (table === "mcq_attempts") {
        data = state.attempts;
      } else if (table === "mcq_questions") {
        let qs = state.questions;
        if (filterIds) qs = qs.filter((q) => filterIds!.includes(q.id));
        if (filterSubjects) qs = qs.filter((q) => filterSubjects!.includes(q.subject_id));
        data = qs;
      } else if (table === "mcq_subjects") {
        let s = state.subjects;
        if (filterIds) s = s.filter((x) => filterIds!.includes(x.id));
        data = s;
      }
      return Promise.resolve(resolve({ data, error: null }));
    },
  };

  return builder as unknown as SupabaseClient;
}

function mkQuestion(id: string, subjectId: string): McqQuestion {
  return {
    id,
    subject_id: subjectId,
    exam_type: "NL2",
    exam_source: null,
    question_number: null,
    scenario: `Q ${id}`,
    choices: [],
    correct_answer: "A",
    explanation: null,
    detailed_explanation: null,
    difficulty: "medium",
    is_ai_enhanced: false,
    ai_notes: null,
    status: "active",
    created_at: new Date().toISOString(),
  };
}

function mkAttempt(questionId: string, subjectId: string, isCorrect: boolean, hoursAgo: number): AttemptRow {
  return {
    question_id: questionId,
    is_correct: isCorrect,
    created_at: new Date(Date.now() - hoursAgo * 3600 * 1000).toISOString(),
    mcq_questions: { subject_id: subjectId },
  };
}

describe("getRecommendedQuestions", () => {
  it("cold-starts with random mix when the user has no attempts", async () => {
    const questions = Array.from({ length: 30 }, (_, i) => mkQuestion(`q${i}`, `s${i % 3}`));
    const fake = makeFake({ attempts: [], questions, subjects: [] });

    const result = await getRecommendedQuestions(fake, "user-1", { limit: 10 });

    expect(result.questions).toHaveLength(10);
    expect(result.breakdown.review).toBe(0);
    expect(result.breakdown.weak).toBe(0);
    expect(result.breakdown.filler).toBe(10);
    expect(result.breakdown.weakSubjects).toEqual([]);
  });

  it("flags a subject as weak when accuracy < 60% over >=5 attempts", async () => {
    // Subject "weak": 5 attempts, 1 correct → 20%
    const attempts: AttemptRow[] = [
      mkAttempt("w1", "weak", false, 100),
      mkAttempt("w2", "weak", false, 100),
      mkAttempt("w3", "weak", true, 100),
      mkAttempt("w4", "weak", false, 100),
      mkAttempt("w5", "weak", false, 100),
    ];
    const questions = [
      ...Array.from({ length: 20 }, (_, i) => mkQuestion(`fresh${i}`, "weak")),
      ...Array.from({ length: 20 }, (_, i) => mkQuestion(`other${i}`, "strong")),
    ];
    const fake = makeFake({
      attempts,
      questions,
      subjects: [{ id: "weak", name_th: "อายุรศาสตร์", icon: "❤️" }],
    });

    const result = await getRecommendedQuestions(fake, "user-1", { limit: 20 });

    expect(result.breakdown.weakSubjects).toHaveLength(1);
    expect(result.breakdown.weakSubjects[0].subject_id).toBe("weak");
    expect(result.breakdown.weakSubjects[0].accuracy).toBe(20);
    // At 20 limit with weak subject present: weak slots = floor(20*0.5) = 10
    expect(result.breakdown.weak).toBe(10);
  });

  it("does not flag subjects with fewer than 5 attempts even if accuracy is low", async () => {
    const attempts: AttemptRow[] = [
      mkAttempt("a1", "thin", false, 100),
      mkAttempt("a2", "thin", false, 100),
      mkAttempt("a3", "thin", false, 100),
    ];
    const questions = Array.from({ length: 20 }, (_, i) => mkQuestion(`q${i}`, "thin"));
    const fake = makeFake({ attempts, questions, subjects: [] });

    const result = await getRecommendedQuestions(fake, "user-1", { limit: 10 });
    expect(result.breakdown.weakSubjects).toEqual([]);
    expect(result.breakdown.weak).toBe(0);
  });

  it("includes a wrong answer in the review pool only after the 24h cooldown", async () => {
    // Fresh wrong (1 hour ago) — should NOT be reviewable yet.
    const fresh: AttemptRow[] = [mkAttempt("fresh-wrong", "sub", false, 1)];
    const freshQuestions = [mkQuestion("fresh-wrong", "sub"), mkQuestion("other", "sub")];
    const freshResult = await getRecommendedQuestions(
      makeFake({ attempts: fresh, questions: freshQuestions, subjects: [] }),
      "user-1",
      { limit: 10 }
    );
    expect(freshResult.breakdown.review).toBe(0);

    // Stale wrong (48 hours ago) — should be reviewable.
    const stale: AttemptRow[] = [mkAttempt("stale-wrong", "sub", false, 48)];
    const staleQuestions = [mkQuestion("stale-wrong", "sub"), mkQuestion("other", "sub")];
    const staleResult = await getRecommendedQuestions(
      makeFake({ attempts: stale, questions: staleQuestions, subjects: [] }),
      "user-1",
      { limit: 10 }
    );
    expect(staleResult.breakdown.review).toBeGreaterThan(0);
  });

  it("does not re-review a question that was answered correctly after being wrong", async () => {
    // Ordered newest first (matches production query order).
    const attempts: AttemptRow[] = [
      mkAttempt("q1", "sub", true, 25),   // latest: correct
      mkAttempt("q1", "sub", false, 50),  // earlier: wrong
    ];
    const questions = [mkQuestion("q1", "sub"), mkQuestion("filler", "sub")];

    const result = await getRecommendedQuestions(
      makeFake({ attempts, questions, subjects: [] }),
      "user-1",
      { limit: 10 }
    );

    expect(result.breakdown.review).toBe(0);
  });

  it("excludes already-seen questions from the filler pool", async () => {
    const attempts: AttemptRow[] = [
      mkAttempt("seen", "sub", true, 1),
    ];
    // Only "seen" exists — filler pool should be empty.
    const questions = [mkQuestion("seen", "sub")];
    const result = await getRecommendedQuestions(
      makeFake({ attempts, questions, subjects: [] }),
      "user-1",
      { limit: 10 }
    );
    const ids = result.questions.map((q) => q.id);
    expect(ids).not.toContain("seen");
  });

  it("respects the limit parameter", async () => {
    const questions = Array.from({ length: 50 }, (_, i) => mkQuestion(`q${i}`, "sub"));
    const result = await getRecommendedQuestions(
      makeFake({ attempts: [], questions, subjects: [] }),
      "user-1",
      { limit: 5 }
    );
    expect(result.questions).toHaveLength(5);
  });
});
