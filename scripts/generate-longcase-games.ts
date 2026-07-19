/**
 * Batch: แปลง Long Case เป็นเกมเคสคุณภาพระดับ torsion ด้วย AI
 * (ใช้ lcTorsion เป็นแม่แบบใน prompt — reuse ตัวเดียวกับ /api/admin/sim/generate)
 *
 * บันทึกเป็น draft ใน sim_scenarios ให้รีวิว/ทดลองเล่นใน /admin/sim ก่อน publish
 * เกม AI ใช้ slug = lc-<caseId> เดียวกับตัว deterministic → พอ publish จะทับ
 * ตัวอัตโนมัติที่ URL เดิมทันที (getSimScenario เจอชั้น DB ก่อน synthesized)
 *
 * รัน:  npm run gen:casegames -- --limit 3            (ลอง 3 เคส เป็น draft)
 *       npm run gen:casegames -- --dry-run            (ดู prompt + list เคส ไม่เรียก AI)
 *       npm run gen:casegames -- --case <uuid>        (เคสเดียว)
 *       npm run gen:casegames -- --specialty Surgery  (เฉพาะสาขา)
 *       npm run gen:casegames -- --force              (ทับเคสที่มีเกมแล้ว)
 *       npm run gen:casegames -- --publish            (publish เลย — ไม่แนะนำ ควรรีวิวก่อน)
 *       npm run gen:casegames -- --model claude-opus-4-7   (โมเดลคุณภาพสูงขึ้น)
 *
 * ต้องมี env: NEXT_PUBLIC_SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, ANTHROPIC_API_KEY
 */

import Anthropic from "@anthropic-ai/sdk";
import { createClient } from "@supabase/supabase-js";
import {
  LONGCASE_CASE_COLUMNS,
  SCENARIO_TOOL,
  longcaseSystemPrompt,
  type ExtraCharacter,
} from "@/lib/sim/generate-longcase";
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
const CASE_ID = val("--case");
const SPECIALTY = val("--specialty");
const MODELS = [val("--model") ?? "claude-sonnet-4-6", "claude-haiku-4-5"];

const SUPABASE_URL = process.env.NEXT_PUBLIC_SUPABASE_URL;
const SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const ANTHROPIC_API_KEY = process.env.ANTHROPIC_API_KEY;

if (!SUPABASE_URL || !SERVICE_KEY || (!DRY && !ANTHROPIC_API_KEY)) {
  console.error(
    "Missing env. Need NEXT_PUBLIC_SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY" +
      (DRY ? "" : ", ANTHROPIC_API_KEY"),
  );
  process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SERVICE_KEY, {
  auth: { autoRefreshToken: false, persistSession: false },
});

interface CaseRow {
  id: string;
  title: string;
  specialty: string | null;
  [k: string]: unknown;
}

async function generateOne(
  client: Anthropic,
  caseRow: Record<string, unknown>,
  extraCharacters: ExtraCharacter[],
): Promise<Record<string, unknown> | null> {
  const system = longcaseSystemPrompt(extraCharacters, caseRow);
  const userPrompt = [
    "แปลงเคส Long Case ที่ให้ในระบบเป็นเกมเคส ตามโครงเรื่องมาตรฐานและกติกาทุกข้อ",
    "เน้นตัวลวงที่เป็นกับดักคลินิกเฉพาะเคสนี้ + why เฉพาะเคส (เลียนแบบความลึกของตัวอย่าง torsion)",
  ].join("\n");

  let lastErr: unknown;
  for (const model of MODELS) {
    try {
      const res = await client.messages.create({
        model,
        max_tokens: 8192,
        system,
        tools: [SCENARIO_TOOL],
        tool_choice: { type: "tool", name: "create_sim_scenario" },
        messages: [{ role: "user", content: userPrompt }],
      });
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

async function run() {
  // ตัวละครเสริม (สำหรับ prompt + validation)
  const { data: dbChars } = await supabase
    .from("sim_characters")
    .select("slug, name, role, personality")
    .eq("status", "active");
  const extraCharacters: ExtraCharacter[] = (dbChars as ExtraCharacter[] | null) ?? [];
  const extraCharIds = extraCharacters.map((c) => c.slug);

  // เคสที่มีเกมแล้ว (ข้าม ยกเว้น --force)
  const covered = new Set<string>();
  if (!FORCE) {
    const { data: existing } = await supabase
      .from("sim_scenarios")
      .select("source_case_id")
      .eq("category", "longcase")
      .not("source_case_id", "is", null);
    for (const r of (existing as { source_case_id: string | null }[] | null) ?? []) {
      if (r.source_case_id) covered.add(r.source_case_id);
    }
  }

  // เคสที่จะแปลง
  let q = supabase
    .from("long_cases")
    .select(`id, ${LONGCASE_CASE_COLUMNS}`)
    .eq("is_published", true)
    .order("is_weekly", { ascending: false })
    .order("created_at", { ascending: false });
  if (CASE_ID) q = q.eq("id", CASE_ID);
  if (SPECIALTY) q = q.eq("specialty", SPECIALTY);
  const { data, error } = await q;
  if (error) {
    console.error("Query error:", error.message);
    process.exit(1);
  }
  let cases = ((data as CaseRow[] | null) ?? []).filter((c) => !covered.has(c.id));
  if (LIMIT && LIMIT > 0) cases = cases.slice(0, LIMIT);

  console.log(
    `พบเคสที่จะแปลง ${cases.length} เคส` +
      (covered.size ? ` (ข้ามที่มีเกมแล้ว ${covered.size})` : "") +
      (DRY ? " — DRY RUN" : ` — model ${MODELS[0]}, บันทึกเป็น ${PUBLISH ? "published" : "draft"}`),
  );

  if (DRY) {
    cases.forEach((c) => console.log(`  • ${c.id}  ${c.title} [${c.specialty ?? "-"}]`));
    if (cases[0]) {
      const { id: _omit, ...caseRow } = cases[0];
      void _omit;
      console.log("\n===== ตัวอย่าง prompt (เคสแรก) =====\n");
      console.log(longcaseSystemPrompt(extraCharacters, caseRow).slice(0, 4000));
      console.log("\n... (ตัดให้สั้น) ...");
    }
    return;
  }

  const client = new Anthropic({ apiKey: ANTHROPIC_API_KEY, maxRetries: 4 });
  let ok = 0;
  let fail = 0;
  for (const [i, c] of cases.entries()) {
    const { id, ...caseRow } = c;
    const label = `[${i + 1}/${cases.length}] ${c.title}`;
    try {
      const scenario = await generateOne(client, caseRow, extraCharacters);
      if (!scenario) throw new Error("no scenario");
      // บังคับ slug = lc-<caseId> เพื่อทับตัว deterministic ที่ URL เดิม
      scenario.slug = `lc-${id}`;
      scenario.category = "longcase";
      scenario.sourceCaseId = id;
      const invalid = describeScenarioError(scenario, extraCharIds);
      if (invalid) throw new Error(`ไม่ผ่าน validate: ${invalid}`);

      const { error: insErr } = await supabase.from("sim_scenarios").upsert(
        {
          slug: `lc-${id}`,
          title: String(scenario.title ?? c.title),
          subtitle: scenario.subtitle ? String(scenario.subtitle) : null,
          difficulty_tag: String(scenario.difficultyTag ?? "basic"),
          category: "longcase",
          source_case_id: id,
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
  }
  console.log(`\nเสร็จ: สำเร็จ ${ok}, ล้มเหลว ${fail}. รีวิว/publish ได้ที่ /admin/sim`);
}

run().catch((err) => {
  console.error("Fatal:", err);
  process.exit(1);
});
