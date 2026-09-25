// แปลง Long Case (ตาราง long_cases) เป็นเกม Code Blue Sim แบบ deterministic
// — ไม่ใช้ AI, ไม่มีต้นทุน, ใช้เนื้อหาที่ตรวจแล้วซ้ำ (ไม่ต้องรีวิวความถูกต้อง)
//
// ทุกจุดตัดสินใจอิง ground truth จริง ไม่มีการเดา/แต่งข้อมูลการแพทย์ —
//   - สั่งตรวจ/แลป: ตัวถูก = ผล isAbnormal (informative), ตัวลวง = ผลปกติ
//   - วินิจฉัย: ตัวถูก = correct_diagnosis, ตัวลวง = accepted_ddx ที่เหลือ
//   - ซักประวัติ: ถาม-ตอบทีละหัวข้อตามลำดับมาตรฐานสากล (HPI → PMH → ยา →
//     แพ้ยา → FH → SH → ROS) ผู้ป่วยตอบทันทีหลังถามถูก (จังหวะเดียวกับเกมร้านยา
//     ของ pharmroo) — ลำดับเป็นมาตรฐาน ไม่ใช่ข้อมูลเฉพาะเคส
//   - ตรวจร่างกาย: เรียงตามลำดับ head-to-toe มาตรฐาน (ใช้กลุ่มเดียวกับ
//     SYNONYM_GROUPS ใน lib/longcase-match.ts) ไม่เดาว่าระบบไหนสำคัญกับเคสนี้
//   - การรักษา: ใช้ลำดับที่ผู้เขียนเคสเขียนไว้เองใน management_plan เป็น
//     ground truth (ไม่ใช่การเดาลำดับใหม่)
//   - อาจารย์ซักถาม: ตัวถูก = modelAnswer ของคำถามนั้น, ตัวลวง = modelAnswer
//     ของคำถามอื่นในเคสเดียวกัน
// ตัวลวงทุกจุดไม่ตั้ง worsen (ไม่ใช่ความผิดพลาดร้ายแรง แค่ลำดับไม่เหมาะ)

import type { LongCaseFull } from "@/lib/types";
import { matchKey, normalizeKey, readHistoryScript } from "@/lib/longcase-match";
import {
  isValidScenario,
  type ChoiceOption,
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

export function longCaseToScenario(lc: LongCaseFull): SimScenario | null {
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
      tgt: "PE",
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

  // ---- Act 2: ตรวจร่างกาย (choice: ลำดับ head-to-toe มาตรฐาน) ----
  const peEntries = orderPeEntries(
    Object.entries(asObj(lc.pe_findings))
      .map(([k, v]) => [k, asStr(v)] as [string, string])
      .filter(([, v]) => v),
  );
  let peIdx = 0;
  const maxPeGates = 2;
  while (peIdx < maxPeGates && peEntries.length - peIdx >= 2) {
    const [okSystem, okFinding] = peEntries[peIdx];
    const [distSystem] = peEntries[peIdx + 1];
    story.push({
      choice: {
        q: "จะตรวจระบบไหนก่อน",
        options: [
          {
            tgt: "PE",
            label: truncate(`ตรวจ ${okSystem}`, okLabelCap([`ตรวจ ${distSystem}`], 70)),
            ok: true,
            then: [say("fon_defib", "talk", `ตรวจ ${okSystem}: ${okFinding}`, 5)],
          },
          {
            tgt: "PE",
            label: `ตรวจ ${distSystem}`,
            ok: false,
            why: "ตรวจตามลำดับ head-to-toe ก่อน ระบบนี้ตรวจทีหลังได้",
          },
        ],
      },
    });
    peIdx += 1;
  }
  for (const [system, finding] of peEntries.slice(peIdx, peIdx + 4)) {
    story.push(say("fon_defib", "talk", `ตรวจ ${system}: ${finding}`, 5));
  }

  // ---- Act 3: สั่งตรวจ/แลป (SCORED เมื่อข้อมูลรองรับ) ----
  const invs = investigations(lc);
  const abnormal = invs.filter((i) => i.abnormal);
  const normal = invs.filter((i) => !i.abnormal);
  if (abnormal.length >= 1 && normal.length >= 1) {
    const ok = abnormal[0];
    const reveal: StoryNode[] = abnormal.map((a) =>
      say("nurse_mint", "talk", `${a.name}: ${a.value}`, 5),
    );
    const wrongLabLabels = normal.slice(0, 2).map((d) => txt(truncate(`สั่ง ${d.name}`, 60)));
    const options: ChoiceOption[] = [
      {
        tgt: "LAB",
        label: txt(truncate(`สั่ง ${ok.name}`, okLabelCap(wrongLabLabels, 60))),
        ok: true,
        then: reveal,
      },
      ...wrongLabLabels.map(
        (label): ChoiceOption => ({
          tgt: "LAB",
          label,
          ok: false,
          why: "ผลออกมาปกติ ไม่ช่วยแยกโรคในเคสนี้",
        }),
      ),
    ];
    story.push({ choice: { q: "จะสั่งตรวจอะไรที่ช่วยยืนยันการวินิจฉัยมากที่สุด", options } });
  } else {
    for (const i of invs.slice(0, 5)) {
      story.push(say("nurse_mint", "talk", `${i.name}: ${i.value}`, 4));
    }
  }

  // teaching points — ใช้ทั้งตอนเฉลยวินิจฉัย (ข้อแรก) และ debrief (ที่เหลือ)
  const teachingPoints = asArr(lc.teaching_points).map((t) => txt(asStr(t))).filter(Boolean);
  let tpUsedInDx = false;

  // ---- Act 4: วินิจฉัย (SCORED — จุดหลัก) ----
  const correct = txt(asStr(lc.correct_diagnosis));
  const nCorrect = normalizeKey(correct);
  const distractorsDx = asArr(lc.accepted_ddx)
    .map((d) => txt(asStr(d)))
    .filter((d) => {
      const nd = normalizeKey(d);
      return nd && nd !== nCorrect && !nd.includes(nCorrect) && !nCorrect.includes(nd);
    });
  if (correct && distractorsDx.length >= 1) {
    // เฉลยแล้วสอนเหตุผลตรงจุดทันทีด้วย teaching point ข้อแรก (ถ้ามี)
    const dxThen: StoryNode[] = [say("att_dech", "happy", `ถูกต้อง — ${correct}`, 5)];
    if (teachingPoints[0]) {
      dxThen.push(say("att_dech", "happy", truncate(teachingPoints[0], 220), 4));
      tpUsedInDx = true;
    }
    const wrongDxLabels = distractorsDx.slice(0, 3).map((d) => truncate(d, 70));
    const options: ChoiceOption[] = [
      {
        tgt: "DX",
        label: truncate(correct, okLabelCap(wrongDxLabels, 70)),
        ok: true,
        then: dxThen,
      },
      ...wrongDxLabels.map(
        (label): ChoiceOption => ({
          tgt: "DX",
          label,
          ok: false,
          why: "เป็น DDx ที่ต้องนึกถึง แต่ไม่ใช่การวินิจฉัยหลักของเคสนี้",
        }),
      ),
    ];
    story.push({ choice: { q: "การวินิจฉัยที่น่าจะเป็นที่สุด", options } });
  } else if (correct) {
    story.push(say("att_dech", "stern", `การวินิจฉัย: ${correct}`, 5));
  }

  // ---- Act 5: การรักษา (choice: ลำดับตามที่ผู้เขียนเคสเขียนไว้จริง) ----
  const mgmt = txt(asStr(lc.management_plan));
  if (mgmt) {
    const parts = mgmt.split(/[;\n]+/).map((s) => s.trim()).filter(Boolean);
    if (parts.length >= 2) {
      const [first, second, ...restParts] = parts;
      story.push({
        choice: {
          q: "จะทำอะไรก่อน",
          options: [
            {
              tgt: "MGMT",
              label: truncate(first, okLabelCap([truncate(second, 70)], 70)),
              ok: true,
              then: [say("att_dech", "talk", `แผนการรักษา: ${truncate(first, 220)}`, 5)],
            },
            {
              tgt: "MGMT",
              label: truncate(second, 70),
              ok: false,
              why: "เป็นขั้นตอนที่ถูกต้อง แต่ควรทำตามลำดับความเร่งด่วนที่วางแผนไว้ก่อน",
            },
          ],
        },
      });
      const rest = [second, ...restParts].join("; ");
      story.push(say("att_dech", "talk", `แผนการรักษา (ต่อ): ${truncate(rest, 220)}`, 5));
    } else {
      story.push(say("att_dech", "talk", `แผนการรักษา: ${truncate(mgmt, 220)}`, 5));
    }
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

  // ---- Act 6: debrief (teaching points ที่เหลือ — ไม่ซ้ำกับที่โชว์ตอนเฉลยวินิจฉัย) ----
  const debriefTps = (tpUsedInDx ? teachingPoints.slice(1) : teachingPoints).slice(0, 3);
  for (const tp of debriefTps) {
    story.push(say("att_dech", "happy", truncate(tp, 220), 4));
  }
  story.push({ inter: "เคสสำเร็จ!!", green: true, t: 0 });
  story.push({ end: true });

  const scenario: SimScenario = {
    slug: slugForCase(lc.id),
    title: txt(lc.title || "Long Case"),
    subtitle: txt(truncate(hx.cc || asStr(lc.correct_diagnosis), 140)),
    difficultyTag: "basic",
    category: "longcase",
    sourceCaseId: lc.id,
    story,
  };

  return isValidScenario(scenario) ? scenario : null;
}
