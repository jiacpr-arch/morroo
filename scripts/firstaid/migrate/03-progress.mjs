// Copies learner progress: lesson_progress, quiz_attempts, exam_attempts,
// simulation_runs → fa_* equivalents. Upserts on natural keys
// (learner_id+lesson_id / uuid) — idempotent, re-runnable for the delta pass.
import { oldClient, newClient, pageTable, reportCounts } from "./_common.mjs";

const oldDb = oldClient();
const newDb = newClient();

async function copyTable(oldTable, newTable, mapRow, onConflict) {
  let copied = 0;
  for await (const rows of pageTable(oldDb, oldTable)) {
    const { error } = await newDb
      .from(newTable)
      .upsert(rows.map(mapRow), { onConflict });
    if (error) throw new Error(`${newTable} upsert failed: ${error.message}`);
    copied += rows.length;
  }
  console.log(`${oldTable} → ${newTable}: ${copied}`);
}

await copyTable(
  "lesson_progress",
  "fa_lesson_progress",
  (r) => ({ learner_id: r.learner_id, lesson_id: r.lesson_id, read_at: r.read_at }),
  "learner_id,lesson_id",
);

await copyTable(
  "quiz_attempts",
  "fa_quiz_attempts",
  (r) => ({
    uuid: r.uuid,
    learner_id: r.learner_id,
    lesson_id: r.lesson_id,
    score: r.score,
    correct: r.correct,
    total: r.total,
    passed: r.passed,
    finished_at: r.finished_at,
  }),
  "uuid",
);

await copyTable(
  "exam_attempts",
  "fa_exam_attempts",
  (r) => ({
    uuid: r.uuid,
    learner_id: r.learner_id,
    kind: r.kind,
    score: r.score,
    correct: r.correct,
    total: r.total,
    passed: r.passed,
    finished_at: r.finished_at,
  }),
  "uuid",
);

await copyTable(
  "simulation_runs",
  "fa_simulation_runs",
  (r) => ({
    uuid: r.uuid,
    learner_id: r.learner_id,
    scenario_id: r.scenario_id,
    score: r.score,
    total: r.total,
    passed: r.passed,
    finished_at: r.finished_at,
  }),
  "uuid",
);

await reportCounts(oldDb, newDb, [
  ["lesson_progress", "fa_lesson_progress"],
  ["quiz_attempts", "fa_quiz_attempts"],
  ["exam_attempts", "fa_exam_attempts"],
  ["simulation_runs", "fa_simulation_runs"],
]);
