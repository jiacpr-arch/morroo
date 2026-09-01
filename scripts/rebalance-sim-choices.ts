/**
 * Batch: เกลี่ยความยาว label ตัวเลือกในเกมเคสที่มีอยู่แล้ว (sim_scenarios)
 *
 * ปัญหา: ข้อถูกมักยาว/ละเอียดกว่าตัวลวงมาก (88.7% ของ choice ทั้งหมด)
 * ผู้เล่นจึงเดาข้อถูกจากความยาวได้โดยไม่ต้องใช้ clinical reasoning
 * สคริปต์นี้ให้ AI เขียนใหม่ "เฉพาะ label" — ห้ามแตะ ok/tgt/why/then
 * โครงเรื่อง คะแนน และคำอธิบายจึงไม่เปลี่ยนเลย
 *
 * รัน:  npx tsx scripts/rebalance-sim-choices.ts --dry-run     (ดูว่าเกมไหนเข้าข่าย)
 *       npx tsx scripts/rebalance-sim-choices.ts --limit 3     (ลอง 3 เกมแรก)
 *       npx tsx scripts/rebalance-sim-choices.ts --slug lc-xxx (เกมเดียว)
 *       npx tsx scripts/rebalance-sim-choices.ts               (ทุกเกมที่เข้าข่าย)
 *
 * ต้องมี env: NEXT_PUBLIC_SUPABASE_URL (หรือ SUPABASE_URL),
 *             SUPABASE_SERVICE_ROLE_KEY, ANTHROPIC_API_KEY
 */

import Anthropic from "@anthropic-ai/sdk";
import { createClient } from "@supabase/supabase-js";
import { describeScenarioError } from "@/lib/sim/validate";
import type { ChoiceNode, SimScenario, StoryNode } from "@/lib/sim/types";

const args = process.argv.slice(2);
const has = (f: string) => args.includes(f);
const val = (f: string): string | undefined => {
  const i = args.indexOf(f);
  return i >= 0 ? args[i + 1] : undefined;
};

const DRY = has("--dry-run");
const LIMIT = val("--limit") ? Number(val("--limit")) : undefined;
const SLUG = val("--slug");
const MODELS = [val("--model") ?? "claude-sonnet-4-6", "claude-haiku-4-5"];
const CONCURRENCY = Math.max(1, Number(val("--concurrency") ?? 4));

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

// เกณฑ์ "เข้าข่ายต้องเกลี่ย" — หลวมกว่า validator (BALANCE_RATIO ใน validate.ts) เพื่อลบ pattern ให้เกลี้ยง
// (คาลิเบรตจากรันจริงรอบแรก: floor 25/ratio 1.5 เข้มเกินจนของจริงผ่านแทบไม่ได้ — median
// ที่ AI เขียนได้จริงคือ ~1.84x เพราะข้อความคลินิกภาษาไทยที่ถูกต้องมักยาวกว่าตัวลวงสั้นๆ
// โดยธรรมชาติ ดู lib/sim/validate.ts BALANCE_RATIO/BALANCE_FLOOR สำหรับ hard gate ตอน accept)
const REBALANCE_RATIO = 1.25;
const REBALANCE_FLOOR = 30;

/** เดินทั้ง story (รวม then ซ้อน) คืน choice node ทุกตัวตามลำดับพบ */
function collectChoices(nodes: StoryNode[], out: ChoiceNode[] = []): ChoiceNode[] {
  for (const node of nodes) {
    if ("choice" in node) {
      out.push(node);
      for (const opt of node.choice.options) {
        if (opt.then) collectChoices(opt.then, out);
      }
    }
  }
  return out;
}

function isUnbalanced(node: ChoiceNode): boolean {
  const ok = node.choice.options.find((o) => o.ok === true);
  const wrongs = node.choice.options.filter((o) => o.ok !== true);
  if (!ok || !wrongs.length) return false;
  const maxWrong = Math.max(REBALANCE_FLOOR, ...wrongs.map((o) => o.label.trim().length));
  return ok.label.trim().length > maxWrong * REBALANCE_RATIO;
}

const REBALANCE_TOOL = {
  name: "submit_rebalanced_labels",
  description: "ส่ง label ที่เขียนใหม่ให้ความยาวสมดุลแล้ว",
  input_schema: {
    type: "object" as const,
    required: ["choices"],
    properties: {
      choices: {
        type: "array",
        description: "ครบทุก choice ที่ได้รับ ตามลำดับเดิม",
        items: {
          type: "object",
          required: ["id", "labels"],
          properties: {
            id: { type: "number", description: "id ของ choice ตามที่ได้รับ" },
            labels: {
              type: "array",
              items: { type: "string" },
              description: "label ใหม่ครบทุกตัวเลือก ตามลำดับ options เดิมเป๊ะๆ",
            },
          },
        },
      },
    },
  },
};

const SYSTEM_PROMPT = `คุณคือแพทย์ผู้เชี่ยวชาญและนักออกข้อสอบ หน้าที่คือแก้ item-writing flaw ในเกมเคสแพทย์: ตอนนี้ "ข้อถูกยาว/ละเอียดกว่าตัวลวงมาก" จนผู้เล่นเดาถูกจากความยาวได้ ให้เขียน label ใหม่ตามกติกา:
1. คงความหมายทางคลินิกของแต่ละตัวเลือกเดิมทุกข้อ — ห้ามเปลี่ยนว่าข้อไหนถูก/ผิด ห้ามสลับลำดับ ห้ามเพิ่ม/ลดตัวเลือก
2. ทุก label ใน choice เดียวกันต้องยาวใกล้เคียงกัน และข้อถูก (ok: true) ต้องยาวไม่เกิน 1.7 เท่าของตัวลวงที่ยาวสุด
3. **วิธีแก้หลักคือเติมรายละเอียดคลินิกให้ตัวลวงที่สั้นเกินไป ไม่ใช่ตัดข้อถูกให้สั้นจนเสียความชัดเจน** — ถ้าตัวลวงเป็นวลีสั้นๆ เช่น "รอดูอาการ" ให้เติมบริบทที่สมจริงและยังผิดเหมือนเดิม เช่น "รอดูอาการที่ห้องสังเกต 2 ชม.ก่อนตัดสินใจ" ไม่ใช่ตัดข้อถูกจนขาดรายละเอียดสำคัญ (รายละเอียดเชิงสอนที่ตัดออกไม่ได้มีใน why/then อยู่แล้ว แต่ label เองต้องอ่านแล้วเข้าใจได้ครบ)
4. ห้ามสร้าง cue ใหม่: ห้ามให้เฉพาะข้อถูกมีตัวเลข/ขนาดยา/หน่วยละเอียด หรือคำระวังแบบ "ประเมินก่อน" ถ้าตัวลวงไม่มีลักษณะเดียวกัน
5. ห้าม label ซ้ำกันภายใน choice เดียว
6. ใช้ภาษาไทยธรรมชาติโทนเดิมของเกม เน้นคำด้วย **คำเน้น** ได้ ห้าม HTML
7. choice ไหนสมดุลอยู่แล้วให้คง label เดิมทุกตัว (ส่งกลับตามเดิม)
ตอบผ่าน tool เท่านั้น — คืน labels ครบทุก choice ตามลำดับ id ที่ได้รับ`;

interface Row {
  slug: string;
  title: string;
  story: StoryNode[];
}

async function rebalanceOne(client: Anthropic, row: Row, label: string): Promise<boolean> {
  const scenario: SimScenario = {
    slug: row.slug,
    title: row.title,
    subtitle: "",
    story: row.story,
  } as SimScenario;
  const choices = collectChoices(scenario.story);
  if (!choices.some(isUnbalanced)) return false;

  const payload = choices.map((node, id) => ({
    id,
    q: node.choice.q,
    options: node.choice.options.map((o) => ({ label: o.label, ok: o.ok === true })),
  }));

  let lastErr: unknown;
  for (const model of MODELS) {
    try {
      const res = await client.messages.create({
        model,
        max_tokens: 8192,
        system: SYSTEM_PROMPT,
        tools: [REBALANCE_TOOL],
        tool_choice: { type: "tool", name: "submit_rebalanced_labels" },
        messages: [{ role: "user", content: JSON.stringify({ choices: payload }) }],
      });
      if (res.stop_reason === "max_tokens") throw new Error("max_tokens");
      const tool = res.content.find((b) => b.type === "tool_use");
      if (!tool || tool.type !== "tool_use") throw new Error("AI ไม่ได้ส่ง tool_use");
      const out = tool.input as { choices?: { id: number; labels: string[] }[] };
      const byId = new Map((out.choices ?? []).map((c) => [c.id, c.labels]));

      // apply เฉพาะ label — ทุกอย่างอื่นในโหนดเดิมคงที่โดยโครงสร้าง
      choices.forEach((node, id) => {
        const labels = byId.get(id);
        if (!labels || labels.length !== node.choice.options.length) {
          throw new Error(`choice ${id} ได้ labels ไม่ครบ`);
        }
        node.choice.options.forEach((opt, j) => {
          const next = String(labels[j]).trim();
          if (!next) throw new Error(`choice ${id} label ${j} ว่าง`);
          opt.label = next;
        });
      });

      // ตัวตัดสินคือ describeScenarioError (BALANCE_RATIO/BALANCE_FLOOR ใน validate.ts —
      // คาลิเบรตจากข้อมูลจริงแล้ว) ไม่ต้องมีเกณฑ์ซ้อนที่เข้มกว่านี้อีกชั้น
      const invalid = describeScenarioError(scenario, EXTRA_CHAR_IDS);
      if (invalid) throw new Error(`ไม่ผ่าน validate: ${invalid}`);

      const { error } = await supabase
        .from("sim_scenarios")
        .update({ story: scenario.story })
        .eq("slug", row.slug);
      if (error) throw new Error(`update: ${error.message}`);
      console.log(`✓ ${label} — เกลี่ย ${choices.length} choice`);
      return true;
    } catch (err) {
      lastErr = err;
    }
  }
  throw lastErr;
}

let EXTRA_CHAR_IDS: string[] = [];

async function run() {
  const { data: dbChars } = await supabase
    .from("sim_characters")
    .select("slug")
    .eq("status", "active");
  EXTRA_CHAR_IDS = ((dbChars as { slug: string }[] | null) ?? []).map((c) => c.slug);

  let q = supabase
    .from("sim_scenarios")
    .select("slug, title, story")
    .eq("status", "published")
    .order("slug");
  if (SLUG) q = q.eq("slug", SLUG);
  const { data, error } = await q;
  if (error) {
    console.error("Query error:", error.message);
    process.exit(1);
  }

  let rows = ((data as Row[] | null) ?? []).filter((r) =>
    collectChoices(r.story).some(isUnbalanced),
  );
  if (LIMIT && LIMIT > 0) rows = rows.slice(0, LIMIT);

  console.log(
    `พบเกมที่ข้อถูกยาวผิดสังเกต ${rows.length} เกม` +
      (DRY ? " — DRY RUN" : ` — model ${MODELS[0]}, concurrency ${CONCURRENCY}`),
  );
  if (DRY) {
    rows.forEach((r) => {
      const unbalanced = collectChoices(r.story).filter(isUnbalanced).length;
      console.log(`  • ${r.slug}  ${r.title} (${unbalanced} choice)`);
    });
    return;
  }

  const client = new Anthropic({ apiKey: ANTHROPIC_API_KEY, maxRetries: 4 });
  let ok = 0;
  let fail = 0;
  let cursor = 0;
  const workers = Array.from({ length: Math.min(CONCURRENCY, rows.length) }, async () => {
    for (;;) {
      const i = cursor++;
      if (i >= rows.length) return;
      const label = `[${i + 1}/${rows.length}] ${rows[i].slug}`;
      try {
        await rebalanceOne(client, rows[i], label);
        ok += 1;
      } catch (err) {
        fail += 1;
        console.error(`✗ ${label} — ${err instanceof Error ? err.message : String(err)}`);
      }
    }
  });
  await Promise.all(workers);

  console.log(`\nเสร็จ: สำเร็จ ${ok}, ล้มเหลว ${fail}`);
}

run().catch((err) => {
  console.error("Fatal:", err);
  process.exit(1);
});
