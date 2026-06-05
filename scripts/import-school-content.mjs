#!/usr/bin/env node
/**
 * Import School content from lecture text → flashcards + bite-sized quizzes.
 *
 * Usage:
 *   SUPABASE_URL=... SUPABASE_SERVICE_ROLE_KEY=... ANTHROPIC_API_KEY=... \
 *     node scripts/import-school-content.mjs --manifest scripts/school-manifest.json
 *
 * Manifest format (JSON):
 *   {
 *     "system_slug": "foundation",
 *     "year": 1,
 *     "topic_slug": "cell-biology",
 *     "layer": "foundation",
 *     "lectures": [
 *       { "title": "Intro", "source": "PCCMS Y1 Cell Biology lecture 1", "body": "..." },
 *       ...
 *     ]
 *   }
 *
 * For each lecture body, calls Claude to extract flashcards + quizzes via tool
 * use, then inserts them under the resolved topic. The full lecture text is
 * ALSO stored as a readable book (school_books + school_book_chapters) so
 * students can read the หนังสือฉบับเต็ม; pass --skip-book to skip that.
 * Generated counts are checked against the lesson-design template
 * (docs/school-lesson-template.md). Run with --dry-run to print generated
 * content without inserting.
 */

import { createClient } from "@supabase/supabase-js";
import { readFile } from "node:fs/promises";
import { parseArgs } from "node:util";

const { values } = parseArgs({
  options: {
    manifest: { type: "string" },
    "dry-run": { type: "boolean", default: false },
    "skip-book": { type: "boolean", default: false },
    model: { type: "string", default: "claude-sonnet-4-6" },
  },
});

// Lesson-design template ranges (see docs/school-lesson-template.md).
const TEMPLATE = {
  flashcardsMin: 10,
  flashcardsMax: 20,
  quizzesMin: 5,
  quizzesMax: 10,
};

if (!values.manifest) {
  console.error("Missing --manifest <path>");
  process.exit(1);
}

const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const ANTHROPIC_KEY = process.env.ANTHROPIC_API_KEY;

if (!values["dry-run"] && (!SUPABASE_URL || !SUPABASE_KEY)) {
  console.error("Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY (set --dry-run to skip insert)");
  process.exit(1);
}
if (!ANTHROPIC_KEY) {
  console.error("Missing ANTHROPIC_API_KEY");
  process.exit(1);
}

const supabase = !values["dry-run"]
  ? createClient(SUPABASE_URL, SUPABASE_KEY)
  : null;

const EXTRACT_TOOL = {
  name: "submit_school_units",
  description:
    "Submit flashcards and quizzes extracted from a medical school lecture.",
  input_schema: {
    type: "object",
    properties: {
      flashcards: {
        type: "array",
        description: "10-20 atomic concept flashcards. Front=concept/question, Back=concise answer.",
        items: {
          type: "object",
          properties: {
            front: { type: "string", description: "Concept or question prompt. Concise (one phrase or question)." },
            back: { type: "string", description: "Answer in 1-3 sentences. Use Thai or English matching source." },
            difficulty: { type: "string", enum: ["easy", "medium", "hard"] },
          },
          required: ["front", "back", "difficulty"],
        },
      },
      quizzes: {
        type: "array",
        description:
          "5-10 multiple-choice questions, each testing one concept. Order them so difficulty ramps gradually: the first quiz must be 'easy', then build up to 'hard' — never put a hard quiz before an easy one.",
        items: {
          type: "object",
          properties: {
            stem: { type: "string", description: "Question stem. Can be scenario-based or recall." },
            choices: {
              type: "array",
              minItems: 4,
              maxItems: 5,
              items: {
                type: "object",
                properties: {
                  label: { type: "string", enum: ["A", "B", "C", "D", "E"] },
                  text: { type: "string" },
                },
                required: ["label", "text"],
              },
            },
            correct_answer: { type: "string", enum: ["A", "B", "C", "D", "E"] },
            explanation: { type: "string", description: "Why the correct answer is right + why others are wrong." },
            difficulty: { type: "string", enum: ["easy", "medium", "hard"] },
          },
          required: ["stem", "choices", "correct_answer", "explanation", "difficulty"],
        },
      },
    },
    required: ["flashcards", "quizzes"],
  },
};

const SYSTEM_PROMPT = `You are a medical educator extracting micro-learning units from a Thai medical school lecture.

Extract:
1. FLASHCARDS (10-20): one concept per card. Front = concept/question; Back = concise definition or mechanism (1-3 sentences). Match the source language (Thai or English).
2. QUIZZES (5-10): single-best-answer MCQs with 4-5 options. Mix recall and application. Include a teaching explanation.

Rules:
- Stay faithful to the source content — do not invent facts.
- Prefer clinically relevant concepts.
- Use Thai medical terminology where natural (Thai med students learn in mixed Thai+English).
- Keep flashcard fronts under 100 chars; backs under 300 chars.
- Difficulty: easy = recall, medium = understanding, hard = application/integration.
- Ramp the quizzes gradually: emit them ordered from easy → hard (start with at least one 'easy', end with the hardest). A learner answers them in order, so a difficulty spike between consecutive quizzes is discouraging — ease them in.

Call the submit_school_units tool with your output.`;

async function extractWithClaude(lectureTitle, lectureBody) {
  const res = await fetch("https://api.anthropic.com/v1/messages", {
    method: "POST",
    headers: {
      "x-api-key": ANTHROPIC_KEY,
      "anthropic-version": "2023-06-01",
      "content-type": "application/json",
    },
    body: JSON.stringify({
      model: values.model,
      max_tokens: 16000,
      system: SYSTEM_PROMPT,
      tools: [EXTRACT_TOOL],
      tool_choice: { type: "tool", name: "submit_school_units" },
      messages: [
        {
          role: "user",
          content: `Lecture: ${lectureTitle}\n\n---\n\n${lectureBody}\n\n---\n\nExtract micro-learning units now.`,
        },
      ],
    }),
  });

  if (!res.ok) {
    const text = await res.text();
    throw new Error(`Anthropic API error ${res.status}: ${text}`);
  }
  const data = await res.json();
  const tool = data.content?.find((c) => c.type === "tool_use");
  if (!tool) throw new Error("No tool_use in response");
  return tool.input;
}

async function resolveTopicId(systemSlug, year, topicSlug) {
  const { data: sys } = await supabase
    .from("school_systems")
    .select("id")
    .eq("slug", systemSlug)
    .maybeSingle();
  if (!sys) throw new Error(`System not found: ${systemSlug}`);

  const { data: topic } = await supabase
    .from("school_topics")
    .select("id, name_th, name_en")
    .eq("system_id", sys.id)
    .eq("year", year)
    .eq("slug", topicSlug)
    .maybeSingle();
  if (!topic) throw new Error(`Topic not found: ${systemSlug}/${year}/${topicSlug}`);
  return topic;
}

/**
 * Store the full lecture text as a readable book for this topic. Upserts one
 * school_books row per topic, then replaces its chapters with the manifest
 * lectures verbatim (idempotent re-runs). Returns the inserted chapter count.
 */
async function storeBook(topicId, bookTitle, lectures) {
  const { data: existing } = await supabase
    .from("school_books")
    .select("id")
    .eq("topic_id", topicId)
    .maybeSingle();

  let bookId = existing?.id;
  if (!bookId) {
    const { data: created, error } = await supabase
      .from("school_books")
      .insert({ topic_id: topicId, title: bookTitle })
      .select("id")
      .single();
    if (error) throw new Error(`Book insert error: ${error.message}`);
    bookId = created.id;
  } else {
    // Refresh chapters on re-import
    await supabase.from("school_book_chapters").delete().eq("book_id", bookId);
  }

  const chapterRows = lectures.map((lec, i) => ({
    book_id: bookId,
    sort_order: i,
    title: lec.title,
    body_md: lec.body,
    source: lec.source ?? lec.title,
  }));
  const { error: chErr } = await supabase
    .from("school_book_chapters")
    .insert(chapterRows);
  if (chErr) throw new Error(`Book chapters insert error: ${chErr.message}`);
  return chapterRows.length;
}

/** Warn when generated counts fall outside the lesson-design template. */
function checkTemplate(title, units) {
  const fc = units.flashcards.length;
  const qz = units.quizzes.length;
  if (fc < TEMPLATE.flashcardsMin || fc > TEMPLATE.flashcardsMax) {
    console.warn(
      `  ⚠ "${title}": ${fc} flashcards (template ${TEMPLATE.flashcardsMin}-${TEMPLATE.flashcardsMax})`
    );
  }
  if (qz < TEMPLATE.quizzesMin || qz > TEMPLATE.quizzesMax) {
    console.warn(
      `  ⚠ "${title}": ${qz} quizzes (template ${TEMPLATE.quizzesMin}-${TEMPLATE.quizzesMax})`
    );
  }
}

async function main() {
  const manifest = JSON.parse(await readFile(values.manifest, "utf-8"));
  const { system_slug, year, topic_slug, layer, lectures } = manifest;

  let topicId = null;
  let topicMeta = null;
  if (!values["dry-run"]) {
    topicMeta = await resolveTopicId(system_slug, year, topic_slug);
    topicId = topicMeta.id;
    console.log(`Resolved topic: ${topicId}`);

    // Store the full lecture text as a readable book (หนังสือฉบับเต็ม).
    if (!values["skip-book"]) {
      const bookTitle = topicMeta.name_th || topicMeta.name_en || topic_slug;
      const chapters = await storeBook(topicId, bookTitle, lectures);
      console.log(`  📖 stored full-text book: ${chapters} chapters`);
    }
  }

  let totalFc = 0;
  let totalQz = 0;

  for (const lec of lectures) {
    console.log(`\n→ Extracting: ${lec.title}`);
    const units = await extractWithClaude(lec.title, lec.body);
    console.log(`  flashcards: ${units.flashcards.length}, quizzes: ${units.quizzes.length}`);
    checkTemplate(lec.title, units);

    if (values["dry-run"]) {
      console.log(JSON.stringify(units, null, 2).slice(0, 800) + "...");
      totalFc += units.flashcards.length;
      totalQz += units.quizzes.length;
      continue;
    }

    const flashcardRows = units.flashcards.map((fc) => ({
      topic_id: topicId,
      layer,
      front: fc.front,
      back: fc.back,
      difficulty: fc.difficulty,
      source: lec.source ?? lec.title,
    }));
    const quizRows = units.quizzes.map((q) => ({
      topic_id: topicId,
      layer,
      stem: q.stem,
      choices: q.choices,
      correct_answer: q.correct_answer,
      explanation: q.explanation,
      difficulty: q.difficulty,
      source: lec.source ?? lec.title,
    }));

    const [{ error: fcErr }, { error: qzErr }] = await Promise.all([
      supabase.from("school_flashcards").insert(flashcardRows),
      supabase.from("school_quizzes").insert(quizRows),
    ]);
    if (fcErr) console.error(`  flashcard insert error: ${fcErr.message}`);
    if (qzErr) console.error(`  quiz insert error: ${qzErr.message}`);

    totalFc += flashcardRows.length;
    totalQz += quizRows.length;
  }

  console.log(`\nDone. Inserted ${totalFc} flashcards + ${totalQz} quizzes.`);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
