/**
 * Bulk pre-seed Board MCQ questions for ALL active specialties.
 *
 * Bypasses the Stripe webhook + cron pipeline (`board_gen_jobs` queue) and
 * calls `runBoardGenAgent` directly in a loop until every specialty has
 * `TARGET_PER_SPECIALTY` board MCQs (status in active/review).
 *
 * The agent caps itself at MAX_QUESTIONS_PER_RUN=5 per invocation (to fit the
 * 60s cron budget). We loop calls so each "round" generates ≤ 10 questions
 * per specialty — small enough to avoid Anthropic timeouts, large enough that
 * we converge to 200 in ~20 rounds × 12 specialties.
 *
 * Usage:
 *   SUPABASE_URL=… SUPABASE_SERVICE_ROLE_KEY=… ANTHROPIC_API_KEY=… \
 *     npx tsx scripts/seed-all-boards.ts
 *
 * Optional env:
 *   TARGET_PER_SPECIALTY (default 200)
 *   CALLS_PER_ROUND      (default 2 — yields ~10 questions per round)
 *   MAX_ROUNDS           (default 60 — safety stop)
 *   ONLY_SPECIALTY       (comma-separated slugs to limit scope, e.g. "emergency_medicine,surgery")
 */

import { createClient } from "@supabase/supabase-js";
import { runBoardGenAgent } from "@/lib/board/gen-agent";

const SUPABASE_URL = process.env.SUPABASE_URL ?? process.env.NEXT_PUBLIC_SUPABASE_URL;
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const ANTHROPIC_API_KEY = process.env.ANTHROPIC_API_KEY;

if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY || !ANTHROPIC_API_KEY) {
  console.error(
    "Missing env: SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, ANTHROPIC_API_KEY"
  );
  process.exit(1);
}

const TARGET = Number(process.env.TARGET_PER_SPECIALTY ?? 200);
const CALLS_PER_ROUND = Math.max(1, Number(process.env.CALLS_PER_ROUND ?? 2));
const MAX_ROUNDS = Math.max(1, Number(process.env.MAX_ROUNDS ?? 60));
const ONLY = (process.env.ONLY_SPECIALTY ?? "")
  .split(",")
  .map((s) => s.trim())
  .filter(Boolean);

const admin = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, {
  auth: { persistSession: false, autoRefreshToken: false },
});

async function countFor(slug: string): Promise<number> {
  const { count } = await admin
    .from("mcq_questions")
    .select("id", { count: "exact", head: true })
    .eq("audience", "board")
    .eq("board_specialty", slug)
    .in("status", ["active", "review"]);
  return count ?? 0;
}

interface Summary {
  slug: string;
  start: number;
  end: number;
  rounds: number;
  errors: number;
}

async function seedOne(slug: string, nameTh: string): Promise<Summary> {
  const start = await countFor(slug);
  let current = start;
  let rounds = 0;
  let errors = 0;
  let stalledRounds = 0;

  console.log(`\n=== ${slug} (${nameTh}) start=${start}/${TARGET} ===`);

  while (current < TARGET && rounds < MAX_ROUNDS) {
    rounds++;
    let addedThisRound = 0;

    for (let call = 0; call < CALLS_PER_ROUND && current < TARGET; call++) {
      try {
        const result = await runBoardGenAgent({
          admin,
          apiKey: ANTHROPIC_API_KEY!,
          specialtySlug: slug,
          targetCount: TARGET,
        });
        const added = result.inserted_active + result.inserted_review;
        addedThisRound += added;
        if (result.errors.length > 0) {
          errors += result.errors.length;
          console.log(`  [${slug} r${rounds}.${call + 1}] errors: ${result.errors.join(" | ").slice(0, 200)}`);
        }
        current = await countFor(slug);
        console.log(
          `  [${slug} r${rounds}.${call + 1}] +${added} (active=${result.inserted_active} review=${result.inserted_review} dropped=${result.dropped}) → count=${current}/${TARGET}`
        );
      } catch (err) {
        errors++;
        console.error(`  [${slug} r${rounds}.${call + 1}] threw:`, (err as Error).message);
      }
    }

    if (addedThisRound === 0) {
      stalledRounds++;
      if (stalledRounds >= 3) {
        console.warn(`  [${slug}] 3 stalled rounds in a row → giving up`);
        break;
      }
    } else {
      stalledRounds = 0;
    }
  }

  const end = await countFor(slug);
  console.log(`=== ${slug} done: ${start} → ${end} (rounds=${rounds}, errors=${errors}) ===`);
  return { slug, start, end, rounds, errors };
}

async function main() {
  const { data: specialties, error: spErr } = await admin
    .from("board_specialties")
    .select("slug, name_th, is_active")
    .eq("is_active", true)
    .order("slug");

  if (spErr || !specialties || specialties.length === 0) {
    console.error("No active specialties found:", spErr?.message);
    process.exit(1);
  }

  const targets = ONLY.length > 0
    ? specialties.filter((s) => ONLY.includes(s.slug as string))
    : specialties;

  console.log(
    `Seeding ${targets.length} specialt${targets.length === 1 ? "y" : "ies"} to ${TARGET} questions each ` +
    `(${CALLS_PER_ROUND} agent call(s)/round, max ${MAX_ROUNDS} rounds)`
  );

  const summaries: Summary[] = [];
  for (const sp of targets) {
    const s = await seedOne(sp.slug as string, sp.name_th as string);
    summaries.push(s);
  }

  console.log("\n========== SUMMARY ==========");
  console.table(
    summaries.map((s) => ({
      slug: s.slug,
      start: s.start,
      end: s.end,
      added: s.end - s.start,
      target: TARGET,
      reached: s.end >= TARGET ? "OK" : "PARTIAL",
      rounds: s.rounds,
      errors: s.errors,
    }))
  );

  const incomplete = summaries.filter((s) => s.end < TARGET);
  if (incomplete.length > 0) {
    console.log(`\n${incomplete.length} specialt${incomplete.length === 1 ? "y" : "ies"} did not reach target. Re-run to continue.`);
    process.exit(2);
  }
  console.log("\nAll specialties at target. Done.");
}

main().catch((err) => {
  console.error("Fatal:", err);
  process.exit(1);
});
