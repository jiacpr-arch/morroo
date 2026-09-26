/**
 * generate-longcase-pe-images — รูปประกอบ "ตรวจร่างกาย" ของ Long Case ด้วย AI
 *
 * สร้างเฉพาะ sign ที่ "เห็นด้วยตา" (ผื่น, บวมกดบุ๋ม, ตาเหลือง, facial droop) ตามรายการ
 * ITEMS ด้านล่าง → อัปขึ้น bucket `longcase-media/pe/` → เปลี่ยนผลตรวจระบบนั้นใน
 * pe_findings จาก string เป็น { text, image_url, image_credit } (ข้อความเดิมไม่แตะ)
 *
 * ขอบเขตโดยเจตนา: ไม่สร้าง ECG / CXR / imaging ด้วย AI — รูปแบบนั้นต้องมาจากผลจริง
 * (ดูการคุยใน PR) สคริปต์นี้ทำแค่ "ภาพประกอบ" สไตล์ตำรา และติดป้ายว่าสร้างด้วย AI เสมอ
 *
 * Env ที่ต้องมี: OPENAI_API_KEY, SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY
 * ควบคุม:   DRY=1    สร้างรูปเก็บใน scripts/longcase-pe-images-out/ อย่างเดียว ไม่อัป/ไม่แก้ DB
 *           FORCE=1  ทำซ้ำแม้ระบบนั้นมีรูปแล้ว
 *           ONLY=<index,index>  ทำเฉพาะบางรายการ (index เริ่ม 0)
 *
 * รัน:  DRY=1 npx tsx scripts/generate-longcase-pe-images.ts   ← ดูรูปก่อน
 *       npx tsx scripts/generate-longcase-pe-images.ts         ← อัปจริง
 * หลังรัน: ให้แพทย์ดูทุกรูปในหน้าเคสจริงก่อนปล่อย รูปไหนไม่ถูก ลบ image_url ออกจาก
 * pe_findings ในหน้า /admin/longcases/[id] (ไฟล์ backup pe_findings เดิมอยู่ใน out dir)
 */

import { randomUUID } from "node:crypto";
import { mkdir, writeFile } from "node:fs/promises";
import path from "node:path";
import { createClient } from "@supabase/supabase-js";
import sharp from "sharp";
import { toPeFinding } from "@/lib/longcase-media";

const OPENAI_API_KEY = process.env.OPENAI_API_KEY;
const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const DRY = flag("DRY");
const FORCE = flag("FORCE");
const ONLY = (process.env.ONLY ?? "").split(",").filter(Boolean).map(Number);

const BUCKET = "longcase-media";
const OUT_DIR = path.join(process.cwd(), "scripts", "longcase-pe-images-out");
const MODEL = "gpt-image-2.5-flare";
const MODEL_FALLBACK = "gpt-image-1";
const CREDIT = "ภาพประกอบสร้างด้วย AI (ไม่ใช่ภาพผู้ป่วยจริง)";

function flag(name: string): boolean {
  return ["1", "true", "yes"].includes((process.env[name] ?? "").toLowerCase());
}

interface Item {
  caseId: string;
  /** key ใน pe_findings ตามที่เก็บจริงในเคส */
  system: string;
  /** ฉาก — ภาษาอังกฤษ บรรยายเฉพาะ sign ที่ต้องเห็น ตรงกับข้อความผลตรวจในเคส */
  scene: string;
}

// เคสนักศึกษา (audience=student) ที่ผลตรวจร่างกายเป็น sign ที่เห็นด้วยตาชัด
const ITEMS: Item[] = [
  {
    caseId: "39bcad8b-3116-44ff-ab1d-c98d376635ca", // เด็กชาย 8 ขวบ ไข้สูง ผื่น ปวดข้อ
    system: "Skin",
    scene:
      "Trunk and upper arm of an 8-year-old Southeast Asian boy showing erythema marginatum: several pink-red ring-shaped patches 2-5 cm across with sharp, slightly raised serpiginous edges and pale centres, on the trunk and proximal upper arm only. Face not shown.",
  },
  {
    caseId: "d10b33a6-11a1-4234-8e7e-62659631f924", // หญิง 16 ปี ไข้สูง 5 วัน ปวดท้อง ซึมลง
    system: "Skin",
    scene:
      "Forearm and inner elbow of a 16-year-old Southeast Asian girl showing many scattered pinpoint red-purple petechiae on the forearm, and a small purple bruise (ecchymosis) at the antecubital venipuncture site. Face not shown.",
  },
  {
    caseId: "26078bc1-3c2e-4673-a3bd-0df38bb0207c", // ชายวัยกลางคน บวมขา หอบ ท้องโต
    system: "Extremities",
    scene:
      "Both lower legs of a middle-aged Southeast Asian man with bilateral pitting edema up to the knees: swollen shins and ankles, and a gloved examiner's thumb just lifted from the shin leaving a clear, persistent pit (dimple) in the skin. Skin not red.",
  },
  {
    caseId: "26078bc1-3c2e-4673-a3bd-0df38bb0207c",
    system: "HEENT",
    scene:
      "Close-up of both eyes of a middle-aged Southeast Asian man looking slightly upward, cropped from eyebrows to the bridge of the nose, showing mild yellow discoloration of the sclera (mild scleral icterus) and slightly pale lower-lid conjunctiva.",
  },
  {
    caseId: "495b73a4-edc6-4529-9bac-ac3c37da7aff", // หญิง 58 ปี เหนื่อยหอบ ขาบวม
    system: "Extremities",
    scene:
      "Both lower legs of a 58-year-old Southeast Asian woman with bilateral pitting edema reaching the knees, a gloved examiner's thumb pressing the shin and a visible persistent pit beside it. Feet look slightly pale.",
  },
  {
    caseId: "e0671d9b-8375-43c5-8ded-0d62837dabc9", // ชาย 65 ปี แขนขาซ้ายอ่อนแรงเฉียบพลัน
    system: "Neuro",
    scene:
      "Face of a 65-year-old Southeast Asian man in a hospital gown attempting to smile, showing drooping of the lower face on the patient's LEFT side (viewer's right): the left corner of the mouth droops and the left nasolabial fold is flattened, while forehead wrinkles are preserved on both sides (upper motor neuron pattern).",
  },
];

function prompt(scene: string): string {
  return `Medical textbook illustration for teaching physical examination to medical students — clean digital painting, realistic proportions and anatomy, soft even clinical lighting, plain light neutral background, close-up framed on the body region. Clearly an illustration, NOT a photograph of a real patient.
SIGN TO SHOW: ${scene}
RULES: show only the described sign accurately; no blood or gore; no text, letters, numbers, arrows, labels, watermarks or captions; no identifiable real person.`;
}

async function callImageApi(model: string, text: string): Promise<Response> {
  return fetch("https://api.openai.com/v1/images/generations", {
    method: "POST",
    headers: { Authorization: `Bearer ${OPENAI_API_KEY}`, "Content-Type": "application/json" },
    // same size/quality shape as generate-lesson-figures (verified against the live API)
    body: JSON.stringify({ model, prompt: text, size: "1536x1024", quality: "high" }),
  });
}

async function render(scene: string): Promise<Buffer> {
  const text = prompt(scene);
  let res = await callImageApi(MODEL, text);
  if (!res.ok && res.status >= 400 && res.status < 500) {
    console.warn(`  ${MODEL} rejected (${res.status}: ${await res.text()}) — falling back to ${MODEL_FALLBACK}`);
    res = await callImageApi(MODEL_FALLBACK, text);
  }
  if (!res.ok) throw new Error(`OpenAI image error ${res.status}: ${await res.text()}`);
  const json = (await res.json()) as { data?: { b64_json?: string }[] };
  const b64 = json.data?.[0]?.b64_json;
  if (!b64) throw new Error("OpenAI image: empty response");
  return sharp(Buffer.from(b64, "base64")).resize({ width: 1200 }).webp({ quality: 82 }).toBuffer();
}

async function main() {
  if (!OPENAI_API_KEY) throw new Error("Missing OPENAI_API_KEY");
  if (!DRY && (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY)) {
    throw new Error("Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY (or run with DRY=1)");
  }
  await mkdir(OUT_DIR, { recursive: true });
  const db = SUPABASE_URL && SUPABASE_SERVICE_ROLE_KEY ? createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY) : null;

  const items = ITEMS.map((item, i) => ({ item, i })).filter(({ i }) => ONLY.length === 0 || ONLY.includes(i));
  let done = 0;
  for (const { item, i } of items) {
    const label = `[${i}] ${item.caseId.slice(0, 8)} ${item.system}`;
    try {
      let findings: Record<string, unknown> | null = null;
      if (db) {
        const { data, error } = await db.from("long_cases").select("pe_findings").eq("id", item.caseId).single();
        if (error || !data) throw new Error(`load case: ${error?.message ?? "not found"}`);
        findings = (data.pe_findings ?? {}) as Record<string, unknown>;
        const current = toPeFinding(findings[item.system]);
        if (!current) throw new Error(`pe_findings has no "${item.system}"`);
        if (current.image_url && !FORCE) {
          console.log(`${label}: already has an image — skip (FORCE=1 to redo)`);
          continue;
        }
      }

      console.log(`${label}: generating…`);
      const webp = await render(item.scene);
      const file = path.join(OUT_DIR, `${i}-${item.caseId.slice(0, 8)}-${item.system}.webp`);
      await writeFile(file, webp);
      console.log(`  saved ${path.relative(process.cwd(), file)}`);
      if (DRY || !db || !findings) continue;

      await writeFile(
        path.join(OUT_DIR, `${item.caseId}.pe_findings.backup.json`),
        JSON.stringify(findings, null, 2),
      );
      // ชื่อไฟล์สุ่ม — ไม่มีชื่อโรคใน URL
      const objectPath = `pe/${randomUUID()}.webp`;
      const up = await db.storage.from(BUCKET).upload(objectPath, webp, { contentType: "image/webp" });
      if (up.error) throw new Error(`upload: ${up.error.message}`);
      const url = db.storage.from(BUCKET).getPublicUrl(objectPath).data.publicUrl;

      const text = toPeFinding(findings[item.system])!.text;
      const next = { ...findings, [item.system]: { text, image_url: url, image_credit: CREDIT } };
      const { error } = await db.from("long_cases").update({ pe_findings: next }).eq("id", item.caseId);
      if (error) throw new Error(`update case: ${error.message}`);
      console.log(`  uploaded + attached → ${url}`);
      done++;
    } catch (err) {
      console.error(`${label}: FAILED — ${err instanceof Error ? err.message : err}`);
    }
  }
  console.log(DRY ? `DRY run — images in ${path.relative(process.cwd(), OUT_DIR)}` : `attached ${done} image(s)`);
}

main().catch(err => {
  console.error(err);
  process.exit(1);
});
