// แปลง Long Case (ตาราง long_cases) เป็นเกม Code Blue Sim แบบ deterministic
// — ไม่ใช้ AI, ไม่มีต้นทุน, ใช้เนื้อหาที่ตรวจแล้วซ้ำ (ไม่ต้องรีวิวความถูกต้อง)
//
// ทุกช่วงเดินจังหวะ "ถาม → ได้คำตอบทันที → ถามต่อ" แบบเกมร้านยาของ pharmroo
// และทุกจุดตัดสินใจอิง ground truth จริง ไม่มีการเดา/แต่งข้อมูลการแพทย์ —
//   - ซักประวัติ: ทีละหัวข้อตามลำดับมาตรฐานสากล (HPI → PMH → ยา → แพ้ยา → FH
//     → SH → ROS) ผู้ป่วยตอบทันทีหลังถามถูก
//   - ตรวจร่างกาย: ทีละระบบตามลำดับ head-to-toe มาตรฐาน (กลุ่มเดียวกับ
//     SYNONYM_GROUPS ใน lib/longcase-match.ts) เห็นผลทันทีหลังตรวจ
//   - สั่งตรวจ/แลป: ทีละรายการ ตัวถูก = ผล isAbnormal, ตัวลวง = ผลปกติ —
//     ได้ใบรายงานผล (labSheet) สะสมทีละใบ แล้วปิดด้วยใบสรุปรวม
//   - วินิจฉัย: ผู้เล่นตัดสินเอง ไม่มีใครเฉลย ตัวถูก = correct_diagnosis, ตัวลวง =
//     accepted_ddx ที่เหลือ + การวินิจฉัยของเคสอื่นในสาขาเดียวกัน แล้วให้เหตุผล
//     ต่อว่าผลตรวจข้อไหนสนับสนุน (ผิดปกติ = ถูก, ปกติ = ผิด)
//   - การรักษา: เขียน order ทีละข้อจากชั้น order (shelf) ตามลำดับที่ผู้เขียนเคส
//     วางไว้ใน management_plan ตัวหลอก = order ของเคสอื่น — ได้ใบสั่งการรักษาสะสม
//   - อาจารย์ซักถาม: ตัวถูก = modelAnswer ของคำถามนั้น, ตัวลวง = modelAnswer
//     ของคำถามอื่นในเคสเดียวกัน
//   - debrief: ทีละประเด็น เลือก teaching point ของเคสนี้จากของเคสอื่น แล้วค่อยขยายความ
// ตัวลวงทุกจุดไม่ตั้ง worsen (ไม่ใช่ความผิดพลาดร้ายแรง แค่ลำดับ/ข้อบ่งชี้ไม่เหมาะ)

import type { LongCaseFull } from "@/lib/types";
import { matchKey, normalizeKey, readHistoryScript } from "@/lib/longcase-match";
import { chunkLongSays } from "./chunk-says";
import {
  isValidScenario,
  type ChoiceOption,
  type LabSheetRow,
  type Pose,
  type SayNode,
  type SimScenario,
  type StoryNode,
} from "./types";

/** slug ของเกมที่สังเคราะห์จากเคส — uuid เป็น kebab-case ที่ valid อยู่แล้ว */
export const LONGCASE_GAME_SLUG_RE = /^lc-[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/;
export const slugForCase = (id: string): string => `lc-${id}`;
export const caseIdFromSlug = (slug: string): string | null =>
  LONGCASE_GAME_SLUG_RE.test(slug) ? slug.slice(3) : null;

// ---- helper: guard ชนิดข้อมูล (บาง field เก็บเป็น scalar ไม่ใช่ object) ----
function asObj(x: unknown): Record<string, unknown> {
  return x && typeof x === "object" && !Array.isArray(x) ? (x as Record<string, unknown>) : {};
}
function asArr(x: unknown): unknown[] {
  return Array.isArray(x) ? x : [];
}
function asStr(x: unknown): string {
  return typeof x === "string" ? x : x == null ? "" : String(x);
}
/** ทำความสะอาดข้อความ: กัน `<tag` (ผ่านกฎ no-HTML) + ยุบ whitespace */
function txt(s: string): string {
  return s.replace(/<(?=[a-zA-Z/!])/g, "‹").replace(/\s+/g, " ").trim();
}
function truncate(s: string, n: number): string {
  return s.length > n ? `${s.slice(0, n - 1)}…` : s;
}
/**
 * เพดานความยาว label ข้อถูก ไม่ให้เกิน BALANCE_RATIO เท่าของตัวลวงที่ยาวสุด
 * (กติกาเดียวกับ validate.ts — กันผู้เล่นเดาข้อถูกจากความยาว)
 */
function okLabelCap(wrongLabels: string[], hardCap: number): number {
  const maxWrong = Math.max(30, ...wrongLabels.map((l) => l.length));
  return Math.min(hardCap, Math.floor(maxWrong * 1.8));
}
function say(who: string, pose: Pose, text: string, t = 5): SayNode {
  return { say: { who, pose, text: txt(text) }, t };
}

/** อายุเป็นปี (ทศนิยมได้) — รองรับทั้งตัวเลขล้วนและ string แบบ "8 เดือน"/"19 ปี" */
function ageYears(raw: unknown): number | null {
  if (typeof raw === "number" && Number.isFinite(raw)) return raw;
  const s = asStr(raw);
  const m = s.match(/([\d.]+)/);
  if (!m) return null;
  const n = Number(m[1]);
  if (!Number.isFinite(n)) return null;
  if (/เดือน|month/i.test(s)) return n / 12;
  if (/วัน|day/i.test(s)) return n / 365;
  return n;
}

/**
 * เลือก sprite ผู้ป่วยให้ตรงเพศ/วัยจาก patient_info + ประวัติ
 * (แก้บั๊กเดิมที่ hardcode patient_generic ทำให้เด็ก 8 เดือนโผล่เป็นชายวัย 50 —
 * และแก้บั๊กที่ตามมาว่าชายหนุ่ม เช่น 19 ปี ปวดอัณฑะ ก็โผล่เป็น patient_generic
 * ซึ่งวาดเป็นชายวัยกลางคน ~50 ปีเหมือนกันหมด ไม่ว่าอายุจริงจะเท่าไร)
 * - แสดงครรภ์เฉพาะเมื่อข้อความบอกชัดว่าท้องแก่/GA ≥ 20 สัปดาห์ — ครรภ์อ่อน
 *   (เช่น ectopic 7 สัปดาห์) ยังไม่เห็นท้อง ใช้ sprite หญิงปกติถูกกว่า
 * - ชาย: อายุ <35 ใช้ patient_young_male, 35-59 ใช้ patient_generic (ชายวัยกลางคน),
 *   ≥60 ใช้ patient_elderly_male
 */
function patientCharId(pi: Record<string, unknown>, hxText: string): string {
  const age = ageYears(pi.age);
  const female = /หญิง|female/i.test(asStr(pi.gender));
  if (age !== null && age < 15) return "patient_child";
  if (female) {
    const ga = hxText.match(/(?:GA|อายุครรภ์|ตั้งครรภ์|ครรภ์)\D{0,10}(\d{1,2})\s*(?:สัปดาห์|wk|week)/i);
    if (/ท้องแก่|ครรภ์แก่|ใกล้คลอด/.test(hxText) || (ga && Number(ga[1]) >= 20)) return "patient_pregnant";
    if (age !== null && age >= 60) return "patient_elderly";
    return "patient_female";
  }
  if (age !== null && age >= 60) return "patient_elderly_male";
  if (age !== null && age < 35) return "patient_young_male";
  return "patient_generic";
}

/** เด็กเล็ก/ทารกพูดเองไม่ได้ — ให้แม่/ญาติเป็นคนตอบซักประวัติแทน */
function historySpeaker(pi: Record<string, unknown>, patientChar: string): string {
  const age = ageYears(pi.age);
  return patientChar === "patient_child" && age !== null && age < 7 ? "mother_rel" : patientChar;
}

function vitalsLine(pi: Record<string, unknown>): string {
  const v = asObj(pi.vitals);
  const parts: string[] = [];
  if (v.bp) parts.push(`BP ${asStr(v.bp)}`);
  if (v.hr) parts.push(`HR ${asStr(v.hr)}`);
  if (v.rr) parts.push(`RR ${asStr(v.rr)}`);
  if (v.temp) parts.push(`T ${asStr(v.temp)}°C`);
  if (v.o2sat) parts.push(`O₂ ${asStr(v.o2sat)}%`);
  return parts.join(", ");
}

/** ลำดับตรวจร่างกายมาตรฐานสากล (head-to-toe) — กลุ่มเดียวกับ SYNONYM_GROUPS */
const PE_CANONICAL_ORDER = ["GA", "HEENT", "Heart", "Lung", "Abdomen", "GU", "Extremities", "Neuro", "Skin"];

/** เรียง pe_findings ตามลำดับตรวจมาตรฐาน — ระบบที่จับคู่ไม่ได้ต่อท้ายตามลำดับเดิม */
function orderPeEntries(entries: [string, string][]): [string, string][] {
  const remaining = new Map(entries);
  const ordered: [string, string][] = [];
  for (const label of PE_CANONICAL_ORDER) {
    const key = matchKey(label, [...remaining.keys()]);
    if (key !== undefined && remaining.has(key)) {
      ordered.push([key, remaining.get(key)!]);
      remaining.delete(key);
    }
  }
  for (const [k, v] of entries) {
    if (remaining.has(k)) ordered.push([k, v]);
  }
  return ordered;
}

interface Inv {
  name: string;
  value: string;
  abnormal: boolean;
}

/** รวม lab_results + imaging_results เป็นชุด investigation เดียว */
function investigations(lc: LongCaseFull): Inv[] {
  const out: Inv[] = [];
  for (const src of [asObj(lc.lab_results), asObj(lc.imaging_results)]) {
    for (const [name, raw] of Object.entries(src)) {
      const o = asObj(raw);
      const value = asStr(o.value);
      if (!value) continue;
      out.push({ name, value, abnormal: o.isAbnormal === true });
    }
  }
  return out;
}

/** เคสอื่น (สาขาเดียวกัน) ที่ใช้เป็นแหล่งตัวลวงการวินิจฉัย/บทเรียน — ground truth ของเคสนั้น */
export interface OtherCaseRef {
  diagnosis: string;
  teachingPoints: unknown[];
  managementPlan?: string;
}

const MAX_PE_STEPS = 6;
const MAX_LAB_STEPS = 4;
const MAX_MGMT_STEPS = 4;
/** order ของเคสอื่นที่ใส่เป็นตัวหลอกบนชั้น order ต่อข้อ */
const ORDER_DECOYS_PER_STEP = 3;
/** ตัวลวงวินิจฉัยสูงสุด (รวม accepted_ddx) → ตัวเลือกรวมไม่เกิน 5 */
const MAX_DX_DISTRACTORS = 4;

/** hash สตริงแบบง่าย (FNV-1a) — ให้ลำดับตัวลวงคงที่ต่อเคส ไม่สุ่มใหม่ทุกครั้งที่โหลด */
function hash(s: string): number {
  let h = 0x811c9dc5;
  for (let i = 0; i < s.length; i++) {
    h ^= s.charCodeAt(i);
    h = Math.imul(h, 0x01000193);
  }
  return h >>> 0;
}
function stableOrder<T>(items: T[], seed: string, keyOf: (x: T) => string): T[] {
  return [...items].sort((a, b) => hash(`${seed}|${keyOf(a)}`) - hash(`${seed}|${keyOf(b)}`));
}

export function longCaseToScenario(lc: LongCaseFull, others: OtherCaseRef[] = []): SimScenario | null {
  const pi = asObj(lc.patient_info);
  // history_script เป็น string ได้ (1 เคส) — ถ้าเป็น string ถือเป็น pi
  const hx = readHistoryScript(
    typeof lc.history_script === "string" ? { pi: lc.history_script } : asObj(lc.history_script),
  );
  const story: StoryNode[] = [];
  const patientChar = patientCharId(pi, [hx.cc, hx.pi, hx.onset, hx.pmh].filter(Boolean).join(" "));
  const hxSpeaker = historySpeaker(pi, patientChar);

  // ---- Act 0: เปิดเรื่อง ----
  const ageStr = asStr(pi.age);
  const demo = [
    asStr(pi.name) || "ผู้ป่วย",
    ageStr && (/ปี|เดือน|วัน/.test(ageStr) ? `อายุ ${ageStr}` : `อายุ ${ageStr} ปี`),
    asStr(pi.gender),
  ]
    .filter(Boolean)
    .join(" · ");
  const vit = vitalsLine(pi);
  story.push(say("nurse_mint", "talk", `ผู้ป่วย ${demo}${vit ? ` — V/S: ${vit}` : ""}`));
  if (hx.cc) story.push({ inter: txt(truncate(hx.cc, 60)), t: 0 });
  story.push(say("att_dech", "stern", "คุณคือแพทย์เวรที่รับเคสนี้ — ประเมินและตัดสินใจให้ตรงจุด", 4));

  // ---- Act 1: ซักประวัติ — จังหวะถาม-ตอบต่อเนื่องแบบเกมร้านยา (pharmroo) ----
  // ทุกหัวข้อที่มีข้อมูลกลายเป็น 1 choice: เลือกถามถูก → ผู้ป่วยตอบทันที →
  // คำถามถัดไปเกริ่นจากคำตอบล่าสุด (ถาม → ตอบ → ถามต่อ แทนการบรรยายยาวรวดเดียว)
  // ลำดับซักประวัติมาตรฐานสากล (HPI → PMH → ยา → แพ้ยา → FH → SH → ROS)
  // ไม่ใช่ข้อมูลเฉพาะเคส; ตัวลวง = ถามข้ามลำดับ / หยุดซักแล้วไปตรวจร่างกายเลย
  interface HxStep { label: string; topic: string; answer: string }
  const hxSteps: HxStep[] = [];
  const hpiText = [hx.pi, hx.onset].filter(Boolean).join(" ");
  if (hpiText) hxSteps.push({ label: "ซักประวัติปัจจุบัน (HPI)", topic: "ประวัติปัจจุบัน", answer: hpiText });
  if (hx.pmh) hxSteps.push({ label: "ซักประวัติโรคประจำตัว (PMH)", topic: "โรคประจำตัว", answer: hx.pmh });
  if (hx.meds) hxSteps.push({ label: "ซักประวัติการใช้ยา", topic: "ยาที่ใช้อยู่", answer: hx.meds });
  if (hx.allergies) hxSteps.push({ label: "ถามประวัติแพ้ยา", topic: "ประวัติแพ้ยา", answer: hx.allergies });
  if (hx.fh) hxSteps.push({ label: "ซักประวัติครอบครัว (FH)", topic: "ประวัติครอบครัว", answer: hx.fh });
  if (hx.sh) hxSteps.push({ label: "ซักประวัติสังคม (SH)", topic: "ประวัติสังคม", answer: hx.sh });
  if (hx.ros) hxSteps.push({ label: "ทบทวนอาการตามระบบ (ROS)", topic: "อาการตามระบบ", answer: hx.ros });

  const HX_STOP_LABEL = "พอแล้ว ข้ามไปตรวจร่างกายเลย";
  hxSteps.forEach((step, i) => {
    const next = hxSteps[i + 1];
    const prev = hxSteps[i - 1];
    const answer = txt(step.answer);
    const options: ChoiceOption[] = [
      {
        tgt: "ASK",
        label: step.label,
        ok: true,
        then: [say(hxSpeaker, i === 0 ? "talk" : "idle", truncate(answer, i === 0 ? 300 : 240), 6)],
      },
    ];
    if (next) {
      options.push({
        tgt: "ASK",
        label: next.label,
        ok: false,
        why: `ถามตามลำดับ — ต้องได้${step.topic}ก่อน แล้วค่อยถาม${next.topic}`,
      });
    }
    options.push({
      tgt: "ASK",
      label: HX_STOP_LABEL,
      ok: false,
      why: `ประวัติยังไม่ครบ — ยังไม่ได้ถาม${hxSteps.slice(i).map((s) => s.topic).join(", ")}`,
    });
    story.push({
      choice: {
        q: prev ? `${prev.topic}: ${truncate(txt(prev.answer), 40)} — จะถามอะไรต่อ` : "จะซักประวัติเรื่องอะไรก่อน",
        options,
      },
    });
  });
  if (hxSteps.length >= 2) {
    story.push(say("att_dech", "talk", "ซักประวัติครบแล้ว — ต่อไป**ตรวจร่างกาย**", 3));
  }

  // ---- Act 2: ตรวจร่างกาย — ตรวจทีละระบบแบบถาม-ตอบ (head-to-toe มาตรฐาน) ----
  // ตรวจถูกระบบ → เห็นผลทันที → ข้อถัดไปเกริ่นจากสิ่งที่เพิ่งตรวจเจอ
  // ตัวลวง = ตรวจข้ามลำดับ / หยุดตรวจแล้วไปส่งแลปเลย
  const peSteps = orderPeEntries(
    Object.entries(asObj(lc.pe_findings))
      .map(([k, v]) => [txt(k), txt(asStr(v))] as [string, string])
      .filter(([k, v]) => k && v),
  ).slice(0, MAX_PE_STEPS);
  const PE_STOP_LABEL = "พอแล้ว ไปส่งตรวจเพิ่มเติมเลย";
  peSteps.forEach(([system, finding], i) => {
    const next = peSteps[i + 1];
    const prev = peSteps[i - 1];
    const okLabel = `ตรวจ ${system}`;
    const wrongs: ChoiceOption[] = [];
    if (next) {
      wrongs.push({
        tgt: "PE",
        label: truncate(`ตรวจ ${next[0]}`, 60),
        ok: false,
        why: `ตรวจตามลำดับ head-to-toe — ตรวจ ${system} ก่อน แล้วค่อยตรวจ ${next[0]}`,
      });
    }
    wrongs.push({
      tgt: "PE",
      label: PE_STOP_LABEL,
      ok: false,
      why: `ตรวจร่างกายยังไม่ครบ — ยังไม่ได้ตรวจ ${peSteps.slice(i).map(([sys]) => sys).join(", ")}`,
    });
    story.push({
      choice: {
        q: prev ? `${prev[0]}: ${truncate(prev[1], 40)} — จะตรวจอะไรต่อ` : "จะเริ่มตรวจร่างกายจากตรงไหน",
        options: [
          {
            tgt: "PE",
            label: truncate(okLabel, okLabelCap(wrongs.map((w) => w.label), 60)),
            ok: true,
            then: [say("fon_defib", "talk", `ตรวจ ${system}: ${truncate(finding, 240)}`, 5)],
          },
          ...wrongs,
        ],
      },
    });
  });

  // ---- Act 3: ส่งตรวจเพิ่มเติม — สั่งทีละรายการ ได้ใบรายงานผลทีละใบ ----
  // ตัวถูก = ผล isAbnormal (informative), ตัวลวง = ผลปกติ / หยุดสั่งก่อนได้ผลสำคัญครบ
  // ผลแต่ละข้อออกมาเป็น "ใบรายงานผล" สะสม (ผลใหม่ไฮไลต์) แล้วปิดด้วยใบสรุปรวม
  const invs = investigations(lc);
  const abnormal = invs.filter((i) => i.abnormal).slice(0, MAX_LAB_STEPS);
  const normal = invs.filter((i) => !i.abnormal);
  const labPatient = demo;
  const LAB_STOP_LABEL = "พอแล้ว ไปสรุปการวินิจฉัยเลย";
  const toRow = (inv: Inv, isNew = false): LabSheetRow => ({
    name: txt(inv.name),
    value: txt(truncate(inv.value, 160)),
    abnormal: inv.abnormal,
    ...(isNew ? { isNew: true } : {}),
  });
  abnormal.forEach((inv, i) => {
    const prev = abnormal[i - 1];
    // หมุนผลปกติเป็นตัวลวง (ไม่ให้ตัวลวงเดิมซ้ำทุกข้อ)
    const normalPicks = normal.length
      ? [...normal.slice(i % normal.length), ...normal.slice(0, i % normal.length)].slice(0, 2)
      : [];
    const wrongs: ChoiceOption[] = normalPicks.map((n) => ({
      tgt: "LAB",
      label: txt(truncate(`สั่ง ${n.name}`, 60)),
      ok: false,
      why: `ผล ${txt(n.name)} ออกมาปกติ — ไม่ช่วยแยกโรคในเคสนี้`,
    }));
    wrongs.push({
      tgt: "LAB",
      label: LAB_STOP_LABEL,
      ok: false,
      why: `ยังขาดผลตรวจสำคัญ — ยังไม่ได้ส่ง ${abnormal.slice(i).map((x) => txt(x.name)).join(", ")}`,
    });
    const sheet: StoryNode = {
      labSheet: {
        title: "ใบรายงานผลตรวจ",
        patient: labPatient,
        rows: abnormal.slice(0, i + 1).map((x, j) => toRow(x, j === i)),
      },
      t: 10,
    };
    story.push({
      choice: {
        q: prev
          ? `${txt(prev.name)}: ${truncate(txt(prev.value), 40)} — จะส่งตรวจอะไรต่อ`
          : "จะส่งตรวจอะไรที่ช่วยยืนยันการวินิจฉัย",
        options: [
          {
            tgt: "LAB",
            label: txt(truncate(`สั่ง ${inv.name}`, okLabelCap(wrongs.map((w) => w.label), 60))),
            ok: true,
            then: [sheet],
          },
          ...wrongs,
        ],
      },
    });
  });
  // ใบสรุปผลทั้งหมด — ผลผิดปกติขึ้นก่อน ตามด้วยผลอื่นที่ส่งตรวจ (ปกติ)
  const summaryRows = [...abnormal, ...normal].slice(0, 10).map((x) => toRow(x));
  if (summaryRows.length) {
    story.push({ labSheet: { title: "สรุปผลตรวจทั้งหมด", patient: labPatient, rows: summaryRows } });
  }

  // ---- Act 4: วินิจฉัย — ผู้เล่นตัดสินเอง ไม่มีใครเฉลยให้ ----
  // ตัวถูก = correct_diagnosis; ตัวลวง = accepted_ddx ที่เหลือ + การวินิจฉัยของเคสอื่น
  // ในสาขาเดียวกัน (ground truth จริงของเคสอื่น) เติมให้ได้ตัวเลือกครบ
  const correct = txt(asStr(lc.correct_diagnosis));
  const nCorrect = normalizeKey(correct);
  const usedDx: string[] = [nCorrect];
  const clashes = (d: string) => {
    const nd = normalizeKey(d);
    return !nd || usedDx.some((u) => u === nd || u.includes(nd) || nd.includes(u));
  };
  const dxWrongs: ChoiceOption[] = [];
  for (const d of asArr(lc.accepted_ddx).map((x) => txt(asStr(x)))) {
    if (dxWrongs.length >= 3 || clashes(d)) continue;
    usedDx.push(normalizeKey(d));
    dxWrongs.push({
      tgt: "DX",
      label: truncate(d, 70),
      ok: false,
      why: "เป็น DDx ที่ต้องนึกถึง แต่ไม่เข้ากับอาการและผลตรวจของเคสนี้เท่าการวินิจฉัยหลัก",
    });
  }
  const pool = stableOrder(others, lc.id, (o) => o.diagnosis);
  for (const o of pool) {
    if (dxWrongs.length >= MAX_DX_DISTRACTORS) break;
    const d = txt(o.diagnosis);
    if (clashes(d)) continue;
    usedDx.push(normalizeKey(d));
    dxWrongs.push({
      tgt: "DX",
      label: truncate(d, 70),
      ok: false,
      why: "ไม่เข้ากับอาการ ผลตรวจร่างกาย และผลแลปของเคสนี้ — ย้อนดูข้อมูลที่เก็บมาอีกครั้ง",
    });
  }
  if (correct && dxWrongs.length >= 1) {
    story.push({
      choice: {
        q: "จากข้อมูลทั้งหมด — การวินิจฉัยที่น่าจะเป็นที่สุดคือ",
        options: [
          {
            tgt: "DX",
            label: truncate(correct, okLabelCap(dxWrongs.map((w) => w.label), 70)),
            ok: true,
          },
          ...dxWrongs,
        ],
      },
    });
    // ให้ผู้เล่นให้เหตุผลเอง: ผลผิดปกติสนับสนุน, ผลปกติไม่สนับสนุน (ground truth isAbnormal)
    if (abnormal.length >= 1 && normal.length >= 1) {
      const key = abnormal[0];
      const evWrongs = normal.slice(0, 2).map(
        (n): ChoiceOption => ({
          tgt: "DX",
          label: txt(truncate(`${n.name}: ${n.value}`, 70)),
          ok: false,
          why: `ผล ${txt(n.name)} ปกติ — ไม่ได้สนับสนุนการวินิจฉัยนี้`,
        }),
      );
      story.push({
        choice: {
          q: "ผลตรวจข้อไหนสนับสนุนการวินิจฉัยนี้",
          options: [
            {
              tgt: "DX",
              label: txt(truncate(`${key.name}: ${key.value}`, okLabelCap(evWrongs.map((w) => w.label), 70))),
              ok: true,
            },
            ...evWrongs,
          ],
        },
      });
    }
  } else if (correct) {
    // ไม่มีตัวลวงจากข้อมูลจริงเลย (หายาก) — บอกผลตรงๆ ดีกว่าแต่งตัวเลือก
    story.push(say("att_dech", "stern", `การวินิจฉัย: ${correct}`, 5));
  }

  // ---- Act 5: การรักษา — เขียน order ทีละข้อจาก "ชั้น order" (แบบชั้นยาของเกมร้านยา) ----
  // ตัวถูก = order ถัดไปตาม management_plan (ลำดับที่ผู้เขียนเคสวางไว้เอง)
  // ตัวหลอก = ข้ามลำดับ / หยุดก่อนครบ / order ของเคสอื่นในสาขาเดียวกัน (ground truth
  // ของโรคอื่น ไม่ใช่ข้อบ่งชี้ของเคสนี้) — หลังสั่งถูกได้ใบสั่งการรักษาสะสมให้เห็นว่าสั่งอะไรไป
  const splitPlan = (plan: unknown) =>
    txt(asStr(plan))
      .split(/[;\n]+/)
      .map((x) => x.trim())
      .filter(Boolean);
  const mgmtSteps = splitPlan(lc.management_plan).slice(0, MAX_MGMT_STEPS);
  const nMgmt = mgmtSteps.map((m) => normalizeKey(m));
  const overlapsCaseOrder = (x: string) => {
    const n = normalizeKey(x);
    return !n || nMgmt.some((m) => m === n || m.includes(n) || n.includes(m));
  };
  const orderDecoys: string[] = [];
  const decoySeen = new Set<string>();
  for (const o of pool) {
    for (const step of splitPlan(o.managementPlan)) {
      const n = normalizeKey(step);
      if (overlapsCaseOrder(step) || decoySeen.has(n)) continue;
      decoySeen.add(n);
      orderDecoys.push(step);
    }
  }
  const MGMT_STOP_LABEL = "order ครบแล้ว ส่งเวรได้";
  let decoyIdx = 0;
  mgmtSteps.forEach((step, i) => {
    const next = mgmtSteps[i + 1];
    const wrongs: ChoiceOption[] = [];
    if (next) {
      wrongs.push({
        tgt: "MGMT",
        label: truncate(next, 70),
        ok: false,
        why: "เป็น order ที่ถูกต้อง แต่ควรสั่งตามลำดับความเร่งด่วนที่วางแผนไว้ก่อน",
      });
    }
    wrongs.push({
      tgt: "MGMT",
      label: MGMT_STOP_LABEL,
      ok: false,
      why: `order ยังไม่ครบ — ยังขาด: ${truncate(mgmtSteps.slice(i).join("; "), 160)}`,
    });
    for (let k = 0; k < ORDER_DECOYS_PER_STEP && orderDecoys.length; k++) {
      const d = orderDecoys[decoyIdx++ % orderDecoys.length];
      const label = truncate(d, 70);
      if (wrongs.some((w) => w.label === label)) continue;
      wrongs.push({
        tgt: "MGMT",
        label,
        ok: false,
        why: "เป็นการรักษาของโรคอื่น — ไม่มีข้อบ่งชี้ในเคสนี้",
      });
    }
    story.push({
      choice: {
        q: i === 0 ? "เขียน order การรักษา — ข้อแรกสั่งอะไร" : `order ข้อ ${i + 1} — สั่งอะไรต่อ`,
        shelf: true,
        options: [
          {
            tgt: "MGMT",
            label: truncate(step, okLabelCap(wrongs.map((w) => w.label), 70)),
            ok: true,
            then: [
              {
                orderSheet: {
                  patient: demo,
                  orders: mgmtSteps.slice(0, i + 1).map((m, j) => ({
                    text: truncate(m, 220),
                    ...(j === i ? { isNew: true } : {}),
                  })),
                },
                t: 5,
              },
            ],
          },
          ...wrongs,
        ],
      },
    });
  });
  if (mgmtSteps.length) {
    story.push(say("nurse_mint", "talk", "รับ order ครบแล้วค่ะ — จะดำเนินการตามนี้เลยนะคะ", 4));
  }

  // ---- Act 5.5: อาจารย์ซักถาม (retrieval practice จาก examiner_questions) ----
  // แหล่งเดียวในข้อมูลที่เก็บ clinical reasoning เฉพาะเคสไว้จริง (คำถามสอบ + เฉลย)
  // โครง active recall: ถามก่อน → ผู้เรียนคิดคำตอบในใจ → แตะดูแนวทางคำตอบ
  const examinerQs = asArr(lc.examiner_questions)
    .map((q) => asObj(q))
    .map((q) => ({ question: asStr(q.question), modelAnswer: asStr(q.modelAnswer), points: typeof q.points === "number" ? q.points : 0 }))
    .filter((q) => q.question && q.modelAnswer)
    .sort((a, b) => b.points - a.points)
    .slice(0, 4);
  if (examinerQs.length >= 2) {
    // ≥2 ข้อ → ถามทีละข้อเป็น choice (จังหวะถาม-ตอบแบบเกมร้านยา): ข้อถูก = modelAnswer
    // ของข้อนั้น, ตัวลวง = modelAnswer ของคำถามอื่นในเคสเดียวกัน (ground truth จริง
    // แต่ตอบคนละคำถาม) → เฉลยเต็มใน then ทันทีหลังตอบถูก
    story.push(say("att_dech", "stern", "ถึงช่วงอาจารย์ซักถาม — เลือกแนวทางคำตอบที่ตรงคำถามที่สุด", 4));
    examinerQs.forEach((q, i) => {
      const pts = q.points > 0 ? ` [${q.points} คะแนน]` : "";
      const nOk = normalizeKey(q.modelAnswer);
      const seen = new Set([nOk]);
      const wrongLabels: string[] = [];
      for (const other of [...examinerQs.slice(i + 1), ...examinerQs.slice(0, i)]) {
        const n = normalizeKey(other.modelAnswer);
        if (seen.has(n)) continue;
        seen.add(n);
        wrongLabels.push(truncate(txt(other.modelAnswer), 90));
        if (wrongLabels.length >= 2) break;
      }
      const reveal = say("att_dech", "happy", `💡 แนวทางคำตอบ: ${truncate(q.modelAnswer, 260)}`, 5);
      if (!wrongLabels.length) {
        story.push(say("att_dech", "stern", `❓ ${truncate(q.question, 260)}${pts}`, 5));
        story.push(reveal);
        return;
      }
      story.push({
        choice: {
          q: txt(`❓ ${truncate(q.question, 160)}${pts}`),
          options: [
            {
              tgt: "EXAM",
              label: truncate(txt(q.modelAnswer), okLabelCap(wrongLabels, 90)),
              ok: true,
              then: [reveal],
            },
            ...wrongLabels.map(
              (label): ChoiceOption => ({
                tgt: "EXAM",
                label,
                ok: false,
                why: "เป็นแนวทางคำตอบของอีกคำถามหนึ่ง — ยังไม่ได้ตอบสิ่งที่อาจารย์ถาม",
              }),
            ),
          ],
        },
      });
    });
  } else if (examinerQs.length === 1) {
    // ข้อเดียวไม่มีตัวลวงจากข้อมูลจริง → active recall: ถามก่อน แล้วแตะดูแนวทางคำตอบ
    const [q] = examinerQs;
    const pts = q.points > 0 ? ` [${q.points} คะแนน]` : "";
    story.push(say("att_dech", "stern", "ถึงช่วงอาจารย์ซักถาม — ลองตอบในใจก่อน แล้วแตะดูแนวทางคำตอบ", 4));
    story.push(say("att_dech", "stern", `❓ ${truncate(q.question, 260)}${pts}`, 5));
    story.push(say("att_dech", "talk", `💡 แนวทางคำตอบ: ${truncate(q.modelAnswer, 260)}`, 5));
  }

  // ---- Act 6: debrief ทีละขั้น — ผู้เล่นเลือกบทเรียนของเคสเอง ก่อนอาจารย์ขยายความ ----
  // ตัวถูก = teaching point ของเคสนี้, ตัวลวง = teaching point ของเคสอื่นในสาขาเดียวกัน
  // (ประเด็นจริงแต่เป็นของโรคอื่น) — ไม่มีตัวลวงก็แสดงทีละข้อแบบแตะไปต่อ
  const teachingPoints = asArr(lc.teaching_points).map((t) => txt(asStr(t))).filter(Boolean).slice(0, 3);
  const otherTps = pool.flatMap((o) =>
    asArr(o.teachingPoints)
      .map((t) => txt(asStr(t)))
      .filter(Boolean)
      .map((tp) => ({ tp, dx: txt(o.diagnosis) })),
  );
  if (teachingPoints.length) {
    story.push(say("att_dech", "talk", "มาทบทวนเคสนี้**ทีละประเด็น**กัน — เลือกข้อที่เป็นบทเรียนของเคสนี้", 4));
  }
  const tpSeen = new Set(teachingPoints.map((t) => normalizeKey(t)));
  let otherIdx = 0;
  teachingPoints.forEach((tp, i) => {
    const reveal = say("att_dech", "happy", `💡 ${truncate(tp, 240)}`, 4);
    const wrongs: ChoiceOption[] = [];
    while (wrongs.length < 2 && otherIdx < otherTps.length) {
      const o = otherTps[otherIdx++];
      const n = normalizeKey(o.tp);
      if (!n || tpSeen.has(n)) continue;
      tpSeen.add(n);
      wrongs.push({
        tgt: "LEARN",
        label: truncate(o.tp, 90),
        ok: false,
        why: `เป็นประเด็นของอีกโรคหนึ่ง${o.dx ? ` (${truncate(o.dx, 40)})` : ""} — ไม่ใช่บทเรียนของเคสนี้`,
      });
    }
    if (!wrongs.length) {
      story.push(reveal);
      return;
    }
    story.push({
      choice: {
        q: `ทบทวนข้อ ${i + 1}/${teachingPoints.length} — ข้อไหนเป็นบทเรียนของเคสนี้`,
        options: [
          {
            tgt: "LEARN",
            label: truncate(tp, okLabelCap(wrongs.map((w) => w.label), 90)),
            ok: true,
            then: [reveal],
          },
          ...wrongs,
        ],
      },
    });
  });
  story.push({ inter: "เคสสำเร็จ!!", green: true, t: 0 });
  story.push({ end: true });

  const scenario: SimScenario = {
    slug: slugForCase(lc.id),
    title: txt(lc.title || "Long Case"),
    subtitle: txt(truncate(hx.cc || asStr(lc.correct_diagnosis), 140)),
    difficultyTag: "basic",
    category: "longcase",
    sourceCaseId: lc.id,
    // อ่านน้อยแต่บ่อย: บทพูดยาวแตกเป็นหลายท่อนสั้นๆ แตะทีละท่อน
    story: chunkLongSays(story),
  };

  return isValidScenario(scenario) ? scenario : null;
}
