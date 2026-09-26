/**
 * import-ptbxl-ecg — ใส่ "ECG จริง" จาก PTB-XL ให้เคส Long Case
 *
 * PTB-XL (PhysioNet, CC BY 4.0 — Wagner et al., Sci Data 2020) มี ECG 12 ลีดจริง
 * 21,799 รายการ พร้อม SCP code ที่แพทย์ตรวจทาน สคริปต์นี้:
 *   1. โหลด ptbxl_database.csv แล้วคัด record ที่ตรงกับผล ECG ในแต่ละเคส (TARGETS)
 *      ตาม SCP code · เพศ/อายุใกล้เคียง · สัญญาณสะอาด (ไม่มี drift/noise/electrode problem)
 *      · human-validated · อัตราหัวใจอยู่ในช่วงที่เคสบอก
 *   2. โหลด record 500 Hz (.hea/.dat) → วาดกระดาษ ECG มาตรฐาน (lib/ecg-render) → WebP
 *   3. เขียนรูป + ข้อมูลอ้างอิง (ecg_id, scp_codes, report, HR) ลง scripts/ptbxl-ecg-out/
 *      ให้แพทย์ตรวจว่าตรงกับเคสจริงก่อนใช้
 *   APPLY=1 → คัดลอกรูปที่เลือกไป public/images/longcase/ecg/<uuid>.webp (ชื่อสุ่ม ไม่มี
 *   ecg_id — กันนักศึกษาไปเปิดดูคำตอบใน PTB-XL) และพิมพ์ SQL สำหรับผูกรูปกับเคส
 *
 * Network: ต้องเข้า physionet.org ได้  (Node ≥22 หลัง proxy: ตั้ง NODE_USE_ENV_PROXY=1)
 * รัน:  npx tsx scripts/import-ptbxl-ecg.ts            ← เลือก + วาด ให้ดูก่อน
 *       APPLY=1 npx tsx scripts/import-ptbxl-ecg.ts    ← คัดลอกเข้า public/ + พิมพ์ SQL
 *       ONLY=0,2  ทำบางเคส · PICK=0:3  ใช้ candidate อันดับ 3 ของเคส 0 แทนอันดับแรก
 */

import { randomUUID } from "node:crypto";
import { copyFile, mkdir, writeFile } from "node:fs/promises";
import path from "node:path";
import sharp from "sharp";
import { decodeFormat16, estimateHeartRate, parseWfdbHeader, renderEcgSvg } from "@/lib/ecg-render";

const BASE = "https://physionet.org/files/ptb-xl/1.0.3/";
const OUT_DIR = path.join(process.cwd(), "scripts", "ptbxl-ecg-out");
const PUBLIC_DIR = path.join(process.cwd(), "public", "images", "longcase", "ecg");
const CREDIT = "ECG จริงจาก PTB-XL (PhysioNet) · Wagner et al., 2020 · CC BY 4.0";
const APPLY = ["1", "true", "yes"].includes((process.env.APPLY ?? "").toLowerCase());
const ONLY = (process.env.ONLY ?? "").split(",").filter(Boolean).map(Number);
const PICK = new Map(
  (process.env.PICK ?? "")
    .split(",")
    .filter(Boolean)
    .map(p => p.split(":").map(Number) as [number, number]),
);
const CANDIDATES_PER_CASE = 6;

type Scp = Record<string, number>;
interface Row {
  ecg_id: string;
  age: number;
  sex: "M" | "F";
  scp: Scp;
  report: string;
  stadium1: string;
  filename_hr: string;
  clean: boolean;
  validated: boolean;
}

interface Target {
  caseId: string;
  /** key ของผล ECG ใน lab_results/imaging_results ของเคส */
  resultKey: string;
  /** ผลอ่านในเคส (ไว้เทียบตอนตรวจ) */
  caseReading: string;
  sex: "M" | "F";
  age: number;
  hr: [number, number];
  /** คืน score (สูง = ตรงกว่า) หรือ null ถ้าไม่เข้าเกณฑ์ */
  match: (r: Row) => number | null;
}

const ISCHEMIA_OR_INFARCT =
  /^(IMI|AMI|ASMI|ALMI|ILMI|LMI|IPMI|IPLMI|PMI|INJ\w*|ISC\w*|STD_|STE_|NST_|NDT|DIG|LNGQT|ANEUR|EL)$/;
const has = (r: Row, code: string, min = 50) => (r.scp[code] ?? 0) >= min;
const onlyCodes = (r: Row, allowed: string[]) => Object.keys(r.scp).every(c => allowed.includes(c));

const TARGETS: Target[] = [
  {
    caseId: "4b63c6ca-cb37-4023-8881-eb2e1f68ea7a", // ชาย 58 ปี เจ็บแน่นหน้าอกร้าวกราม
    resultKey: "12-lead ECG",
    caseReading: "ST elevation 2-3mm II, III, aVF; reciprocal ST depression I, aVL; 1st-degree AV block; HR 52",
    sex: "M",
    age: 58,
    hr: [45, 70],
    match: r => {
      if (!has(r, "IMI")) return null;
      // acute stage (Stadium I / I-II) = ST elevation still present
      if (!/^Stadium I(-II)?$/.test(r.stadium1)) return null;
      let s = 0;
      if (has(r, "1AVB")) s += 3;
      if (Object.keys(r.scp).some(c => /^INJ(IN|IL)$/.test(c))) s += 2;
      if (has(r, "SBRAD", 1)) s += 1;
      if (has(r, "AFIB", 1) || has(r, "CLBBB", 1) || has(r, "CRBBB", 1)) return null;
      return s;
    },
  },
  {
    caseId: "e0671d9b-8375-43c5-8ded-0d62837dabc9", // ชาย 65 ปี แขนขาซ้ายอ่อนแรงเฉียบพลัน
    resultKey: "ECG",
    caseReading: "Atrial fibrillation, rate 85, no ST change",
    sex: "M",
    age: 65,
    hr: [70, 105],
    match: r => {
      if (!has(r, "AFIB", 80)) return null;
      if (Object.keys(r.scp).some(c => ISCHEMIA_OR_INFARCT.test(c))) return null;
      return onlyCodes(r, ["AFIB"]) ? 2 : onlyCodes(r, ["AFIB", "LAFB", "LVOLT"]) ? 1 : null;
    },
  },
  {
    caseId: "3ae55fe9-2851-42f3-b907-d27c3a746541", // หญิง 58 ปี แน่นหน้าอกขณะออกแรง
    resultKey: "ECG",
    caseReading: "NSR 85 bpm, poor R wave progression V1-V3, no acute changes",
    sex: "F",
    age: 58,
    hr: [65, 100],
    match: r => {
      if (!("SR" in r.scp)) return null;
      // old anteroseptal infarct pattern → poor R-wave progression V1-V3, no acute ST change
      if (!has(r, "ASMI")) return null;
      if (!/Stadium (II-III|III)/.test(r.stadium1)) return null;
      if (Object.keys(r.scp).some(c => /^(INJ\w*|STE_|1AVB|AFIB|CLBBB|CRBBB|LVH)$/.test(c))) return null;
      return onlyCodes(r, ["SR", "ASMI"]) ? 2 : 1;
    },
  },
];

// ─── CSV ────────────────────────────────────────────────────────────────────
function parseCsv(text: string): string[][] {
  const rows: string[][] = [];
  let row: string[] = [];
  let field = "";
  let quoted = false;
  for (let i = 0; i < text.length; i++) {
    const ch = text[i];
    if (quoted) {
      if (ch === '"' && text[i + 1] === '"') { field += '"'; i++; }
      else if (ch === '"') quoted = false;
      else field += ch;
    } else if (ch === '"') quoted = true;
    else if (ch === ",") { row.push(field); field = ""; }
    else if (ch === "\n") { row.push(field.replace(/\r$/, "")); rows.push(row); row = []; field = ""; }
    else field += ch;
  }
  if (field || row.length) { row.push(field); rows.push(row); }
  return rows;
}

function parseScp(s: string): Scp {
  const out: Scp = {};
  for (const m of s.matchAll(/'([^']+)':\s*([\d.]+)/g)) out[m[1]] = Number(m[2]);
  return out;
}

function toRows(csv: string[][]): Row[] {
  const [head, ...body] = csv;
  const col = (name: string) => {
    const i = head.indexOf(name);
    if (i < 0) throw new Error(`ptbxl_database.csv: missing column ${name}`);
    return i;
  };
  const c = Object.fromEntries(
    [
      "ecg_id", "age", "sex", "scp_codes", "report", "infarction_stadium1", "filename_hr", "validated_by_human",
      "baseline_drift", "static_noise", "burst_noise", "electrodes_problems", "pacemaker",
    ].map(n => [n, col(n)]),
  ) as Record<string, number>;
  return body
    .filter(r => r.length >= head.length)
    .map(r => ({
      ecg_id: r[c.ecg_id],
      age: Number(r[c.age]),
      sex: r[c.sex] === "1" ? "F" : "M", // PTB-XL: 0 = male, 1 = female
      scp: parseScp(r[c.scp_codes]),
      report: r[c.report],
      stadium1: r[c.infarction_stadium1] ?? "",
      filename_hr: r[c.filename_hr],
      clean: ["baseline_drift", "static_noise", "burst_noise", "electrodes_problems", "pacemaker"].every(k => !r[c[k]]?.trim()),
      validated: r[c.validated_by_human] === "True",
    }));
}

// ─── network ────────────────────────────────────────────────────────────────
async function get(url: string): Promise<Uint8Array> {
  const res = await fetch(url);
  if (!res.ok) throw new Error(`GET ${url} → ${res.status}`);
  return new Uint8Array(await res.arrayBuffer());
}

async function main() {
  await mkdir(OUT_DIR, { recursive: true });
  console.log("downloading ptbxl_database.csv …");
  const rows = toRows(parseCsv(new TextDecoder().decode(await get(BASE + "ptbxl_database.csv"))));
  console.log(`  ${rows.length} records`);

  const sql: string[] = [];
  for (const [ti, t] of TARGETS.entries()) {
    if (ONLY.length && !ONLY.includes(ti)) continue;
    console.log(`\n[${ti}] ${t.caseId.slice(0, 8)} — case: ${t.caseReading}`);
    const ranked = rows
      .filter(r => r.clean && r.validated && r.sex === t.sex && r.age >= t.age - 15 && r.age <= t.age + 15)
      .map(r => ({ r, score: t.match(r) }))
      .filter((x): x is { r: Row; score: number } => x.score !== null)
      .sort((a, b) => b.score - a.score || Math.abs(a.r.age - t.age) - Math.abs(b.r.age - t.age));
    console.log(`  ${ranked.length} matching records`);

    const picked: { file: string; meta: Record<string, unknown> }[] = [];
    for (const { r, score } of ranked) {
      if (picked.length >= CANDIDATES_PER_CASE) break;
      try {
        const hea = new TextDecoder().decode(await get(`${BASE}${r.filename_hr}.hea`));
        const header = parseWfdbHeader(hea);
        const leads = decodeFormat16(await get(`${BASE}${r.filename_hr}.dat`), header);
        const ii = header.signals.findIndex(s => s.name.toUpperCase() === "II");
        const hr = estimateHeartRate(leads[ii], header.fs);
        if (hr === null || hr < t.hr[0] || hr > t.hr[1]) continue;
        const svg = renderEcgSvg(header, leads, { caption: "PTB-XL (PhysioNet) · CC BY 4.0" });
        const file = path.join(OUT_DIR, `${ti}-cand${picked.length}.webp`);
        await writeFile(file, await sharp(Buffer.from(svg)).webp({ quality: 88 }).toBuffer());
        const meta = { ecg_id: r.ecg_id, age: r.age, sex: r.sex, scp_codes: r.scp, stadium1: r.stadium1, report: r.report, hr_estimate: hr, score };
        await writeFile(file.replace(/\.webp$/, ".json"), JSON.stringify(meta, null, 2));
        picked.push({ file, meta });
        console.log(`  cand${picked.length - 1}: ecg_id ${r.ecg_id} · ${r.age}${r.sex} · HR≈${hr} · ${Object.keys(r.scp).join(",")} · "${r.report.slice(0, 70)}"`);
      } catch (err) {
        console.warn(`  skip ecg_id ${r.ecg_id}: ${err instanceof Error ? err.message : err}`);
      }
    }
    if (!picked.length) {
      console.warn("  no usable record — loosen the criteria for this case");
      continue;
    }
    if (!APPLY) continue;

    const choice = picked[PICK.get(ti) ?? 0] ?? picked[0];
    await mkdir(PUBLIC_DIR, { recursive: true });
    const name = `${randomUUID()}.webp`;
    await copyFile(choice.file, path.join(PUBLIC_DIR, name));
    console.log(`  → public/images/longcase/ecg/${name} (ecg_id ${choice.meta.ecg_id})`);
    const url = `/images/longcase/ecg/${name}`;
    const patch = JSON.stringify({ image_url: url, image_credit: CREDIT }).replace(/'/g, "''");
    const k = t.resultKey.replace(/'/g, "''");
    // the key lives in lab_results or imaging_results — patch whichever holds it
    for (const colName of ["lab_results", "imaging_results"]) {
      sql.push(
        `update long_cases set ${colName} = jsonb_set(${colName}, '{${k}}', (${colName}->'${k}') || '${patch}'::jsonb) ` +
          `where id = '${t.caseId}' and ${colName} ? '${k}';`,
      );
    }
  }
  if (APPLY && sql.length) {
    const file = path.join(OUT_DIR, "attach.sql");
    await writeFile(file, sql.join("\n") + "\n");
    console.log(`\nSQL to attach the images → ${path.relative(process.cwd(), file)}\n${sql.join("\n")}`);
  }
}

main().catch(err => {
  console.error(err);
  process.exit(1);
});
