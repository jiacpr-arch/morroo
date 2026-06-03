// Board MCQ AI generation agent.
//
// One specialty per invocation:
//   1. Read blueprint topics + section weights
//   2. Fan-out gen calls across sections (parallel, Haiku for easy/medium, Sonnet for hard)
//   3. Self-critique each question with Sonnet → confidence 0..1 + issues
//   4. Map confidence → mcq_questions.status: 'active' | 'review' | drop
//
// Tuning targets (per spec from product):
//   - 30 questions / specialty as starter pack
//   - "เลียนแบบข้อสอบบอร์ดราชวิทยาลัย" — heavy clinical reasoning, real refs
//   - Hybrid quality gate: high confidence → publish, low → admin review

import type { SupabaseClient } from "@supabase/supabase-js";
import { BOARD_SECTIONS } from "@/lib/types-board";

type GenChoice = { label: string; text: string };

export interface GeneratedQuestion {
  scenario: string;
  choices: GenChoice[];
  correct_answer: string;
  explanation: string;
  detailed_explanation?: unknown;
  difficulty: "easy" | "medium" | "hard";
  board_section: string;
  board_topic: string;
  board_age_group?: "peds" | "adult" | "mixed" | null;
  reference_source?: string | null;
}

export interface CritiqueResult {
  confidence: number;
  passes_blueprint: boolean;
  issues: string[];
}

export interface AgentRunResult {
  specialty_slug: string;
  total_generated: number;
  inserted_active: number;
  inserted_review: number;
  dropped: number;
  errors: string[];
}

const ANTHROPIC_API = "https://api.anthropic.com/v1/messages";

interface BlueprintRow {
  specialty_slug: string;
  section_code: string;
  question_count: number;
  topics: { slug: string; name_th: string; peds: number; adult: number; other: number }[];
}

async function loadBlueprint(
  admin: SupabaseClient,
  specialtySlug: string
): Promise<BlueprintRow[]> {
  const { data: blueprints } = await admin
    .from("board_exam_blueprints")
    .select("id, section_code, question_count")
    .eq("specialty_slug", specialtySlug);

  if (!blueprints || blueprints.length === 0) {
    // No blueprint yet — fall back to BOARD_SECTIONS with even weight
    return BOARD_SECTIONS.map((s) => ({
      specialty_slug: specialtySlug,
      section_code: s.code,
      question_count: 25,
      topics: [],
    }));
  }

  const ids = blueprints.map((b) => b.id);
  const { data: topics } = await admin
    .from("board_topic_categories")
    .select("blueprint_id, slug, name_th, peds_count, adult_count, other_count")
    .in("blueprint_id", ids);

  return blueprints.map((b) => ({
    specialty_slug: specialtySlug,
    section_code: b.section_code,
    question_count: b.question_count,
    topics:
      topics
        ?.filter((t) => t.blueprint_id === b.id)
        .map((t) => ({
          slug: t.slug,
          name_th: t.name_th,
          peds: t.peds_count ?? 0,
          adult: t.adult_count ?? 0,
          other: t.other_count ?? 0,
        })) ?? [],
  }));
}

/** Distribute `target` questions across blueprint sections proportional to weight. */
function distributePerSection(
  blueprint: BlueprintRow[],
  target: number
): { section_code: string; count: number; topics: BlueprintRow["topics"] }[] {
  const totalWeight = blueprint.reduce((s, b) => s + b.question_count, 0) || 1;
  const distributed = blueprint.map((b) => ({
    section_code: b.section_code,
    count: Math.max(1, Math.round((b.question_count / totalWeight) * target)),
    topics: b.topics,
  }));
  // Reconcile rounding so total == target
  let sum = distributed.reduce((s, d) => s + d.count, 0);
  let i = 0;
  while (sum > target && distributed.length > 0) {
    if (distributed[i % distributed.length].count > 1) {
      distributed[i % distributed.length].count--;
      sum--;
    }
    i++;
    if (i > 100) break;
  }
  while (sum < target && distributed.length > 0) {
    distributed[i % distributed.length].count++;
    sum++;
    i++;
    if (i > 100) break;
  }
  return distributed;
}

function buildGenPrompt(args: {
  specialtyTh: string;
  royalCollege: string | null;
  sectionLabelTh: string;
  sectionCode: string;
  topics: BlueprintRow["topics"];
  count: number;
  difficultyHint: string;
}): string {
  const topicList =
    args.topics.length > 0
      ? args.topics.map((t) => `- ${t.name_th} (${t.slug})`).join("\n")
      : "(ไม่มี topic list — ใช้หัวข้อมาตรฐานของสาขา)";

  return `คุณเป็นอาจารย์แพทย์ผู้ทรงคุณวุฒิที่ออกข้อสอบบอร์ดเฉพาะทาง${args.royalCollege ? ` ของ${args.royalCollege}` : ""} สาขา ${args.specialtyTh}

ภารกิจ: สร้างข้อสอบ MCQ จำนวน ${args.count} ข้อ สำหรับเซกชัน "${args.sectionLabelTh}" ของสาขา ${args.specialtyTh}

หัวข้อใน blueprint:
${topicList}

หลักการสำคัญ (ห้ามผิด):
1. เลียนแบบสไตล์ข้อสอบบอร์ดราชวิทยาลัยจริง — scenario ยาว มี context ครบ (อายุ เพศ underlying disease, presentation, vital signs, lab/imaging ที่จำเป็น)
2. ${args.difficultyHint}
3. ตัวเลือก 5 ข้อ (A–E) — distractor ต้อง plausible ทุกตัว ห้ามมี "เห็นปุ๊บรู้ปั๊บ"
4. คำตอบถูก อิง evidence-based และ standard textbook/guideline จริง (Harrison, Sabiston, Nelson, Williams, Tintinalli, ATLS, ACS, AHA ฯลฯ — ระบุใน reference_source)
5. คำอธิบายเฉลย: ทำไมตัวเลือกที่ถูกถูก + ทำไมแต่ละ distractor ผิด
6. ห้าม leak คำตอบใน stem (เช่น "ผู้ป่วยที่เป็น septic shock" แล้วถามว่าวินิจฉัยอะไร)
7. ใช้ภาษาไทยเป็นหลัก ผสมศัพท์การแพทย์อังกฤษตามมาตรฐาน
8. ระบุ board_topic ตรงกับ slug ใน blueprint (ถ้ามี) หรือสร้าง slug ใหม่ที่สอดคล้อง

ตอบเป็น JSON array เท่านั้น (ห้ามมี markdown หรือคำอธิบายอื่น):
[
  {
    "scenario": "...",
    "choices": [
      {"label":"A","text":"..."},
      {"label":"B","text":"..."},
      {"label":"C","text":"..."},
      {"label":"D","text":"..."},
      {"label":"E","text":"..."}
    ],
    "correct_answer": "A",
    "explanation": "เฉลยสั้น 1-2 ประโยค",
    "detailed_explanation": {
      "summary": "...",
      "reason": "...",
      "choices": [
        {"label":"A","text":"...","is_correct":true,"explanation":"..."},
        {"label":"B","text":"...","is_correct":false,"explanation":"..."},
        {"label":"C","text":"...","is_correct":false,"explanation":"..."},
        {"label":"D","text":"...","is_correct":false,"explanation":"..."},
        {"label":"E","text":"...","is_correct":false,"explanation":"..."}
      ],
      "key_takeaway": "..."
    },
    "difficulty": "easy|medium|hard",
    "board_section": "${args.sectionCode}",
    "board_topic": "slug-ของหัวข้อ",
    "board_age_group": "peds|adult|mixed",
    "reference_source": "ชื่อ textbook + chapter หรือ guideline + ปี"
  }
]`;
}

function buildCritiquePrompt(q: GeneratedQuestion, specialtyTh: string): string {
  return `คุณเป็นกรรมการตรวจข้อสอบบอร์ด สาขา ${specialtyTh}

ตรวจข้อสอบ MCQ ต่อไปนี้แล้วให้คะแนนความพร้อมเผยแพร่ (0.0 - 1.0):

${JSON.stringify(q, null, 2)}

เกณฑ์ตรวจ:
1. คำตอบถูกต้องทางการแพทย์ (อิง evidence-based, guideline ปัจจุบัน)
2. stem ไม่ leak คำตอบ
3. distractor plausible ทุกตัว (ไม่ใช่ตัวเลือก fillter)
4. scenario สมจริง มีรายละเอียดครบ (อายุ เพศ vital signs, lab ที่เกี่ยวข้อง)
5. reference_source ระบุจริง สามารถตรวจสอบได้
6. คำอธิบายเฉลยถูก + อธิบายทุกตัวเลือก
7. เลียนแบบสไตล์ข้อสอบบอร์ดจริง ไม่ใช่ข้อสอบ NL

ตอบเป็น JSON เท่านั้น:
{
  "confidence": 0.0 - 1.0,
  "passes_blueprint": true | false,
  "issues": ["รายการปัญหาเป็น bullet ภาษาไทย"]
}

confidence guideline:
- 0.9+ = พร้อมเผยแพร่ทันที ตรงสไตล์บอร์ด คำตอบแม่นเป๊ะ
- 0.7-0.89 = ดีพอใช้ มี minor issues
- 0.5-0.69 = ต้องให้อาจารย์รีวิว มี issue สำคัญ
- <0.5 = ไม่ผ่าน drop ทิ้ง`;
}

async function callClaude(
  apiKey: string,
  model: string,
  maxTokens: number,
  prompt: string,
  expectArray: boolean
): Promise<unknown> {
  const res = await fetch(ANTHROPIC_API, {
    method: "POST",
    headers: {
      "x-api-key": apiKey,
      "anthropic-version": "2023-06-01",
      "content-type": "application/json",
    },
    body: JSON.stringify({
      model,
      max_tokens: maxTokens,
      messages: [{ role: "user", content: prompt }],
    }),
  });

  if (!res.ok) {
    throw new Error(`Claude ${model} ${res.status}: ${(await res.text()).slice(0, 200)}`);
  }

  const data = await res.json();
  const raw: string = data.content?.[0]?.text ?? "";
  if (!raw) throw new Error(`Empty response from ${model}`);

  let cleaned = raw.trim();
  if (cleaned.startsWith("```")) {
    cleaned = cleaned.replace(/^```\w*\n?/, "").replace(/\n?```$/, "");
  }

  try {
    return JSON.parse(cleaned);
  } catch {
    // Fallback: extract balanced JSON
    const startCh = expectArray ? "[" : "{";
    const endCh = expectArray ? "]" : "}";
    const start = cleaned.indexOf(startCh);
    const end = cleaned.lastIndexOf(endCh);
    if (start >= 0 && end > start) {
      return JSON.parse(cleaned.slice(start, end + 1));
    }
    throw new Error(`Failed to parse JSON from ${model}`);
  }
}

async function generateOneSection(
  apiKey: string,
  args: Parameters<typeof buildGenPrompt>[0]
): Promise<GeneratedQuestion[]> {
  // Split per-section count between Haiku (easy/medium) and Sonnet (hard) when count >= 5,
  // otherwise everything to Sonnet for higher quality on small batches.
  const totalCount = args.count;
  if (totalCount < 5) {
    const out = await callClaude(
      apiKey,
      "claude-haiku-4-5-20251001",
      8000,
      buildGenPrompt(args),
      true
    );
    return Array.isArray(out) ? (out as GeneratedQuestion[]) : [];
  }

  const hardCount = Math.max(1, Math.round(totalCount * 0.4));
  const easyMedCount = totalCount - hardCount;

  const [easyMed, hard] = await Promise.allSettled([
    callClaude(
      apiKey,
      "claude-haiku-4-5-20251001",
      16000,
      buildGenPrompt({
        ...args,
        count: easyMedCount,
        difficultyHint:
          "ความยาก: easy 30% (recall definition, classic presentation) + medium 70% (first-line management, investigation of choice, การวินิจฉัย typical case)",
      }),
      true
    ),
    callClaude(
      apiKey,
      "claude-haiku-4-5-20251001",
      12000,
      buildGenPrompt({
        ...args,
        count: hardCount,
        difficultyHint:
          "ความยาก: hard ทั้งหมด — clinical reasoning ซับซ้อน, differential diagnosis, management ของ case ที่มี comorbidity, lab/imaging interpretation หลายขั้น, ethical/system-based question",
      }),
      true
    ),
  ]);

  const out: GeneratedQuestion[] = [];
  if (easyMed.status === "fulfilled" && Array.isArray(easyMed.value)) {
    out.push(...(easyMed.value as GeneratedQuestion[]));
  }
  if (hard.status === "fulfilled" && Array.isArray(hard.value)) {
    out.push(...(hard.value as GeneratedQuestion[]));
  }
  return out;
}

async function critiqueQuestion(
  apiKey: string,
  q: GeneratedQuestion,
  specialtyTh: string
): Promise<CritiqueResult> {
  try {
    const out = (await callClaude(
      apiKey,
      "claude-haiku-4-5-20251001",
      1500,
      buildCritiquePrompt(q, specialtyTh),
      false
    )) as Partial<CritiqueResult>;

    const confidence = typeof out.confidence === "number" ? out.confidence : 0;
    return {
      confidence: Math.max(0, Math.min(1, confidence)),
      passes_blueprint: out.passes_blueprint === true,
      issues: Array.isArray(out.issues) ? out.issues.slice(0, 10) : [],
    };
  } catch (err) {
    return {
      confidence: 0,
      passes_blueprint: false,
      issues: [`critique failed: ${(err as Error).message}`],
    };
  }
}

function isValidQuestion(q: GeneratedQuestion): boolean {
  return Boolean(
    q.scenario &&
      Array.isArray(q.choices) &&
      q.choices.length >= 4 &&
      q.choices.every((c) => c.label && c.text) &&
      q.correct_answer &&
      ["A", "B", "C", "D", "E"].includes(q.correct_answer)
  );
}

export async function runBoardGenAgent(args: {
  admin: SupabaseClient;
  apiKey: string;
  specialtySlug: string;
  targetCount: number;
}): Promise<AgentRunResult> {
  const { admin, apiKey, specialtySlug, targetCount } = args;
  const result: AgentRunResult = {
    specialty_slug: specialtySlug,
    total_generated: 0,
    inserted_active: 0,
    inserted_review: 0,
    dropped: 0,
    errors: [],
  };

  // Idempotency: skip if already at target
  const { count: existingCount } = await admin
    .from("mcq_questions")
    .select("id", { count: "exact", head: true })
    .eq("audience", "board")
    .eq("board_specialty", specialtySlug)
    .in("status", ["active", "review"]);

  const need = Math.max(0, targetCount - (existingCount ?? 0));
  if (need === 0) {
    return result;
  }

  // Load specialty metadata for prompts
  const { data: specialty } = await admin
    .from("board_specialties")
    .select("slug, name_th, royal_college")
    .eq("slug", specialtySlug)
    .single();

  if (!specialty) {
    result.errors.push(`specialty ${specialtySlug} not found`);
    return result;
  }

  const blueprint = await loadBlueprint(admin, specialtySlug);
  const distribution = distributePerSection(blueprint, need);

  // Gen sections in parallel (each section is itself a parallel Haiku+Sonnet split)
  const sectionResults = await Promise.allSettled(
    distribution.map((d) => {
      const sectionMeta = BOARD_SECTIONS.find((s) => s.code === d.section_code);
      const sectionLabel = sectionMeta?.label_th ?? d.section_code;
      return generateOneSection(apiKey, {
        specialtyTh: specialty.name_th,
        royalCollege: specialty.royal_college,
        sectionLabelTh: sectionLabel,
        sectionCode: d.section_code,
        topics: d.topics,
        count: d.count,
        difficultyHint:
          "ความยาก: easy 20% + medium 50% + hard 30% (mix realistic ตามข้อสอบบอร์ดจริง)",
      });
    })
  );

  const allQuestions: GeneratedQuestion[] = [];
  sectionResults.forEach((r, idx) => {
    if (r.status === "fulfilled") {
      allQuestions.push(...r.value);
    } else {
      result.errors.push(`section ${distribution[idx].section_code}: ${r.reason}`);
    }
  });

  result.total_generated = allQuestions.length;
  const valid = allQuestions.filter(isValidQuestion);
  result.dropped = allQuestions.length - valid.length;

  if (valid.length === 0) {
    return result;
  }

  // Map subject_id per section
  const { data: subjectRows } = await admin
    .from("mcq_subjects")
    .select("id, name")
    .eq("audience", "board")
    .eq("board_specialty", specialtySlug);

  const subjectBySection = new Map<string, string>();
  for (const s of subjectRows ?? []) {
    BOARD_SECTIONS.forEach((sec) => {
      if ((s.name as string).endsWith(sec.code)) subjectBySection.set(sec.code, s.id);
    });
  }
  const fallbackSubjectId = subjectRows?.[0]?.id ?? null;

  // INSERT FIRST as status='review' so generation work is committed even if
  // the function times out mid-critique. Critique then promotes
  // high-confidence rows to 'active' best-effort below.
  type InsertPair = { q: GeneratedQuestion; row: Record<string, unknown> };
  const insertRows: InsertPair[] = valid
    .map((q): InsertPair | null => {
      const subjectId = subjectBySection.get(q.board_section) ?? fallbackSubjectId;
      if (!subjectId) return null;
      return {
        q,
        row: {
          subject_id: subjectId,
          audience: "board",
          exam_type: null,
          scenario: q.scenario,
          choices: q.choices,
          correct_answer: q.correct_answer,
          explanation: q.explanation || null,
          detailed_explanation: q.detailed_explanation ?? null,
          difficulty: ["easy", "medium", "hard"].includes(q.difficulty)
            ? q.difficulty
            : "medium",
          topic: q.board_topic || null,
          status: "review" as const,
          board_specialty: specialtySlug,
          board_section: q.board_section,
          board_topic: q.board_topic || "general",
          board_age_group: q.board_age_group ?? null,
          reference_source: q.reference_source ?? null,
          exam_source: "AI-generated-board",
          is_ai_enhanced: true,
          ai_notes: "awaiting critique",
        },
      };
    })
    .filter((x): x is InsertPair => x !== null);

  result.dropped += valid.length - insertRows.length;

  if (insertRows.length === 0) return result;

  const { data: inserted, error: insertErr } = await admin
    .from("mcq_questions")
    .insert(insertRows.map((x) => x.row))
    .select("id");

  if (insertErr || !inserted) {
    result.errors.push(`insert failed: ${insertErr?.message ?? "no rows returned"}`);
    return result;
  }

  result.inserted_review = inserted.length;

  // Critique inline best-effort: promote high-confidence rows to 'active'.
  // If the function times out here, rows stay 'review' (still saved).
  const CRITIQUE_CONCURRENCY = 5;
  const pairs = inserted.map((row, idx) => ({
    id: row.id as string,
    q: insertRows[idx].q,
  }));

  for (let i = 0; i < pairs.length; i += CRITIQUE_CONCURRENCY) {
    const batch = pairs.slice(i, i + CRITIQUE_CONCURRENCY);
    const critiques = await Promise.all(
      batch.map((p) => critiqueQuestion(apiKey, p.q, specialty.name_th))
    );
    await Promise.all(
      critiques.map(async (c, j) => {
        const pair = batch[j];
        const notes = `confidence=${c.confidence.toFixed(2)}${c.issues.length ? ` | issues: ${c.issues.join("; ").slice(0, 300)}` : ""}`;
        if (c.confidence < 0.5) {
          // Quality too low — disable so it doesn't clutter review queue
          await admin
            .from("mcq_questions")
            .update({ status: "disabled", ai_notes: notes })
            .eq("id", pair.id);
          result.inserted_review--;
          result.dropped++;
        } else if (c.confidence >= 0.85) {
          await admin
            .from("mcq_questions")
            .update({ status: "active", ai_notes: notes })
            .eq("id", pair.id);
          result.inserted_review--;
          result.inserted_active++;
        } else {
          // 0.5 <= confidence < 0.85 — keep as 'review', just update notes
          await admin
            .from("mcq_questions")
            .update({ ai_notes: notes })
            .eq("id", pair.id);
        }
      })
    );
  }

  return result;
}
