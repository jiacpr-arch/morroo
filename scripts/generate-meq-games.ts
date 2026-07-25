/**
 * Batch: แปลงข้อสอบ MEQ (progressive case) เป็นเกมเคสด้วย AI
 * (คู่ขนานกับ scripts/generate-longcase-games.ts — reuse เอนจิน/ตัวละคร/validate
 * ชุดเดียวกัน ต่างแค่แหล่งข้อมูลคือ exams + exam_parts แทน long_cases)
 *
 * บันทึกเป็น draft ใน sim_scenarios ให้รีวิว/ทดลองเล่นใน /admin/sim ก่อน publish
 * slug = meq-<examId>, category = 'meq', source_exam_id = examId
 *
 * รัน:  npm run gen:meqgames -- --limit 3            (ลอง 3 ข้อสอบ เป็น draft)
 *       npm run gen:meqgames -- --dry-run            (ดู prompt + list ข้อสอบ ไม่เรียก AI)
 *       npm run gen:meqgames -- --exam <uuid>        (ข้อสอบเดียว)
 *       npm run gen:meqgames -- --category ศัลยศาสตร์  (เฉพาะสาขา)
 *       npm run gen:meqgames -- --force              (ทับข้อสอบที่มีเกมแล้ว)
 *       npm run gen:meqgames -- --publish            (publish เลย — ไม่แนะนำ ควรรีวิวก่อน)
 *       npm run gen:meqgames -- --model claude-opus-4-7   (โมเดลคุณภาพสูงขึ้น)
 *
 * ต้องมี env: NEXT_PUBLIC_SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, ANTHROPIC_API_KEY
 */

import Anthropic from "@anthropic-ai/sdk";
import { createClient } from "@supabase/supabase-js";
import {
  MEQ_PART_COLUMNS,
  SCENARIO_TOOL,
  meqSystemPrompt,
  type ExtraCharacter,
  type MeqExamRow,
  type MeqPart,
} from "@/lib/sim/generate-meq";
import { describeScenarioError } from "@/lib/sim/validate";

const args = process.argv.slice(2);
const has = (f: string) => args.includes(f);
const val = (f: string): string | undefined => {
  const i = args.indexOf(f);
  return i >= 0 ? args[i + 1] : undefined;
};

const DRY = has("--dry-run");
const FORCE = has("--force");
const PUBLISH = has("--publish");
const LIMIT = val("--limit") ? Number(val("--limit")) : undefined;
const EXAM_ID = val("--exam");
const CATEGORY = val("--category");
const MODELS = [val("--model") ?? "claude-sonnet-4-6", "claude-haiku-4-5"];
// แปลงพร้อมกันกี่เคส — ลำพังเคสละ ~1-2 นาที ถ้าไล่ทีละเคสจะเกิน timeout ของ CI
const CONCURRENCY = Math.max(1, Number(val("--concurrency") ?? 3));

// รับได้ทั้ง NEXT_PUBLIC_SUPABASE_URL (dev/local) และ SUPABASE_URL (CI secret)
const SUPABASE_URL = process.env.NEXT_PUBLIC_SUPABASE_URL ?? process.env.SUPABASE_URL;
const SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const ANTHROPIC_API_KEY = process.env.ANTHROPIC_API_KEY;

if (!SUPABASE_URL || !SERVICE_KEY || (!DRY && !ANTHROPIC_API_KEY)) {
  console.error(
    "Missing env. Need NEXT_PUBLIC_SUPABASE_URL (หรือ SUPABASE_URL), SUPABASE_SERVICE_ROLE_KEY" +
      (DRY ? "" : ", ANTHROPIC_API_KEY"),
  );
  process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SERVICE_KEY, {
  auth: { autoRefreshToken: false, persistSession: false },
});

interface ExamRow {
  id: string;
  title: string;
  category: string | null;
  difficulty: string | null;
}

async function generateOne(
  client: Anthropic,
  exam: MeqExamRow,
  extraCharacters: ExtraCharacter[],
): Promise<Record<string, unknown> | null> {
  const system = meqSystemPrompt(extraCharacters, exam);
  const userPrompt = [
    "แปลงข้อสอบ MEQ ที่ให้ในระบบเป็นเกมเคส ตามโครงเรื่องมาตรฐานและกติกาทุกข้อ",
    "เดินเรื่องตามลำดับตอน (parts) ของข้อสอบ ใช้ answer/key_points สร้างตัวลวงที่เป็นกับดักคลินิกเฉพาะเคส + why เฉพาะเคส (เลียนแบบความลึกของตัวอย่าง torsion)",
  ].join("\n");

  let lastErr: unknown;
  for (const model of MODELS) {
    try {
      // ต้อง stream: max_tokens สูงขนาดนี้ SDK ปฏิเสธ non-streaming
      // ("Streaming is required for operations that may take longer than 10 minutes")
      const res = await client.messages
        .stream({
          model,
          // scenario 9-12 choice พร้อม then/why เต็มรูปแบบยาวเกิน 8k เสมอ —
          // ที่ 8192 เคสส่วนใหญ่ตาย max_tokens (เทียบ generate-meq-weekly ใช้ 32k)
          max_tokens: 32000,
          system,
          tools: [SCENARIO_TOOL],
          tool_choice: { type: "tool", name: "create_sim_scenario" },
          messages: [{ role: "user", content: userPrompt }],
        })
        .finalMessage();
      if (res.stop_reason === "max_tokens") throw new Error("max_tokens — โจทย์ยาวเกิน");
      const tool = res.content.find((b) => b.type === "tool_use");
      if (!tool || tool.type !== "tool_use") throw new Error("AI ไม่ได้ส่ง tool_use");
      return tool.input as Record<string, unknown>;
    } catch (err) {
      lastErr = err;
    }
  }
  throw lastErr;
}

async function loadParts(examId: string): Promise<MeqPart[]> {
  const { data, error } = await supabase
    .from("exam_parts")
    .select(MEQ_PART_COLUMNS)
    .eq("exam_id", examId)
    .order("part_number", { ascending: true });
  if (error) throw new Error(`โหลด exam_parts ไม่สำเร็จ: ${error.message}`);
  return (data as MeqPart[] | null) ?? [];
}

async function run() {
  // ตัวละครเสริม (สำหรับ prompt + validation)
  const { data: dbChars } = await supabase
    .from("sim_characters")
    .select("slug, name, role, personality")
    .eq("status", "active");
  const extraCharacters: ExtraCharacter[] = (dbChars as ExtraCharacter[] | null) ?? [];
  const extraCharIds = extraCharacters.map((c) => c.slug);

  // ข้อสอบที่มีเกมแล้ว (ข้าม ยกเว้น --force)
  const covered = new Set<string>();
  if (!FORCE) {
    const { data: existing } = await supabase
      .from("sim_scenarios")
      .select("source_exam_id")
      .eq("category", "meq")
      .not("source_exam_id", "is", null);
    for (const r of (existing as { source_exam_id: string | null }[] | null) ?? []) {
      if (r.source_exam_id) covered.add(r.source_exam_id);
    }
  }

  // ข้อสอบที่จะแปลง (เฉพาะ published)
  let q = supabase
    .from("exams")
    .select("id, title, category, difficulty")
    .eq("status", "published")
    .order("publish_date", { ascending: false, nullsFirst: false })
    .order("created_at", { ascending: false });
  if (EXAM_ID) q = q.eq("id", EXAM_ID);
  if (CATEGORY) q = q.eq("category", CATEGORY);
  const { data, error } = await q;
  if (error) {
    console.error("Query error:", error.message);
    process.exit(1);
  }
  let exams = ((data as ExamRow[] | null) ?? []).filter((e) => !covered.has(e.id));
  if (LIMIT && LIMIT > 0) exams = exams.slice(0, LIMIT);

  console.log(
    `พบข้อสอบ MEQ ที่จะแปลง ${exams.length} ข้อ` +
      (covered.size ? ` (ข้ามที่มีเกมแล้ว ${covered.size})` : "") +
      (DRY ? " — DRY RUN" : ` — model ${MODELS[0]}, บันทึกเป็น ${PUBLISH ? "published" : "draft"}`),
  );

  if (DRY) {
    exams.forEach((e) => console.log(`  • ${e.id}  ${e.title} [${e.category ?? "-"}]`));
    if (exams[0]) {
      const examRow: MeqExamRow = {
        title: exams[0].title,
        category: exams[0].category,
        difficulty: exams[0].difficulty,
        parts: await loadParts(exams[0].id),
      };
      console.log("\n===== ตัวอย่าง prompt (ข้อสอบแรก) =====\n");
      console.log(meqSystemPrompt(extraCharacters, examRow).slice(0, 4000));
      console.log("\n... (ตัดให้สั้น) ...");
    }
    return;
  }

  const client = new Anthropic({ apiKey: ANTHROPIC_API_KEY, maxRetries: 4 });
  let ok = 0;
  let fail = 0;

  const convertOne = async (e: ExamRow, i: number) => {
    const label = `[${i + 1}/${exams.length}] ${e.title}`;
    try {
      const parts = await loadParts(e.id);
      if (!parts.length) throw new Error("ไม่มี exam_parts");
      const examRow: MeqExamRow = {
        title: e.title,
        category: e.category,
        difficulty: e.difficulty,
        parts,
      };
      const scenario = await generateOne(client, examRow, extraCharacters);
      if (!scenario) throw new Error("no scenario");
      // บังคับ slug = meq-<examId> เพื่อ URL เสถียร (upsert ทับตัวเดิม)
      scenario.slug = `meq-${e.id}`;
      scenario.category = "meq";
      const invalid = describeScenarioError(scenario, extraCharIds);
      if (invalid) throw new Error(`ไม่ผ่าน validate: ${invalid}`);

      const { error: insErr } = await supabase.from("sim_scenarios").upsert(
        {
          slug: `meq-${e.id}`,
          title: String(scenario.title ?? e.title),
          subtitle: scenario.subtitle ? String(scenario.subtitle) : null,
          difficulty_tag: String(scenario.difficultyTag ?? "basic"),
          category: "meq",
          source_exam_id: e.id,
          status: PUBLISH ? "published" : "draft",
          story: scenario.story,
          source: "ai",
        },
        { onConflict: "slug" },
      );
      if (insErr) throw new Error(`insert: ${insErr.message}`);
      ok += 1;
      console.log(`✓ ${label}`);
    } catch (err) {
      fail += 1;
      console.error(`✗ ${label} — ${err instanceof Error ? err.message : String(err)}`);
    }
  };

  // worker pool: หยิบเคสถัดไปจากคิวเมื่อว่าง (ไม่ยิงพร้อมกันทั้งหมดกัน rate limit)
  let cursor = 0;
  const workers = Array.from({ length: Math.min(CONCURRENCY, exams.length) }, async () => {
    for (;;) {
      const i = cursor++;
      if (i >= exams.length) return;
      await convertOne(exams[i], i);
    }
  });
  await Promise.all(workers);

  console.log(`\nเสร็จ: สำเร็จ ${ok}, ล้มเหลว ${fail}. รีวิว/publish ได้ที่ /admin/sim`);
}

run().catch((err) => {
  console.error("Fatal:", err);
  process.exit(1);
});
