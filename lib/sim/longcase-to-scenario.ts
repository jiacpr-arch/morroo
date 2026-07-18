// แปลง Long Case (ตาราง long_cases) เป็นเกม Code Blue Sim แบบ deterministic
// — ไม่ใช้ AI, ไม่มีต้นทุน, ใช้เนื้อหาที่ตรวจแล้วซ้ำ (ไม่ต้องรีวิวความถูกต้อง)
//
// หลักการให้คะแนน: สกอร์เฉพาะจุดที่ข้อมูลมี ground truth ชัดเจน —
//   - สั่งตรวจ/แลป: ตัวถูก = ผล isAbnormal (informative), ตัวลวง = ผลปกติ
//   - วินิจฉัย: ตัวถูก = correct_diagnosis, ตัวลวง = accepted_ddx ที่เหลือ
// ส่วนซักประวัติ / ตรวจร่างกาย / การรักษา เป็นฉากเล่าเรื่อง (แตะไปต่อ ไม่มี
// ตัวลวงปลอม) เพื่อไม่สร้าง "ตัวเลือกผิด" ที่จริงไม่ผิดในเนื้อหาการแพทย์

import type { LongCaseFull } from "@/lib/types";
import { normalizeKey, readHistoryScript } from "@/lib/longcase-match";
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
function say(who: string, pose: Pose, text: string, t = 5): SayNode {
  return { say: { who, pose, text: txt(text) }, t };
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

  // ---- Act 0: เปิดเรื่อง ----
  const demo = [asStr(pi.name) || "ผู้ป่วย", asStr(pi.age) && `อายุ ${asStr(pi.age)} ปี`, asStr(pi.gender)]
    .filter(Boolean)
    .join(" · ");
  const vit = vitalsLine(pi);
  story.push(say("nurse_mint", "talk", `ผู้ป่วย ${demo}${vit ? ` — V/S: ${vit}` : ""}`));
  if (hx.cc) story.push({ inter: txt(truncate(hx.cc, 60)), t: 0 });
  story.push(say("att_dech", "stern", "คุณคือแพทย์เวรที่รับเคสนี้ — ประเมินและตัดสินใจให้ตรงจุด", 4));

  // ---- Act 1: ซักประวัติ (reveal) ----
  if (hx.pi) story.push(say("patient_generic", "talk", truncate(hx.pi, 240), 6));
  if (hx.onset) story.push(say("patient_generic", "talk", truncate(hx.onset, 200), 6));
  const bg = [hx.pmh && `PMH: ${hx.pmh}`, hx.sh && `SH: ${hx.sh}`].filter(Boolean).join(" · ");
  if (bg) story.push(say("att_dech", "idle", truncate(bg, 220), 4));

  // ---- Act 2: ตรวจร่างกาย (reveal) ----
  const peEntries = Object.entries(asObj(lc.pe_findings))
    .map(([k, v]) => [k, asStr(v)] as [string, string])
    .filter(([, v]) => v);
  for (const [system, finding] of peEntries.slice(0, 4)) {
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
    const options: ChoiceOption[] = [
      { tgt: "LAB", label: txt(truncate(`สั่ง ${ok.name}`, 60)), ok: true, then: reveal },
      ...normal.slice(0, 2).map(
        (d): ChoiceOption => ({
          tgt: "LAB",
          label: txt(truncate(`สั่ง ${d.name}`, 60)),
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
    const options: ChoiceOption[] = [
      {
        tgt: "DX",
        label: truncate(correct, 70),
        ok: true,
        then: [say("att_dech", "happy", `ถูกต้อง — ${correct}`, 5)],
      },
      ...distractorsDx.slice(0, 3).map(
        (d): ChoiceOption => ({
          tgt: "DX",
          label: truncate(d, 70),
          ok: false,
          why: "เป็น DDx ที่ต้องนึกถึง แต่ไม่ใช่การวินิจฉัยหลักของเคสนี้",
        }),
      ),
    ];
    story.push({ choice: { q: "การวินิจฉัยที่น่าจะเป็นที่สุด", options } });
  } else if (correct) {
    story.push(say("att_dech", "stern", `การวินิจฉัย: ${correct}`, 5));
  }

  // ---- Act 5: การรักษา (reveal) ----
  const mgmt = txt(asStr(lc.management_plan));
  if (mgmt) {
    const parts = mgmt.split(/[;\n]+/).map((s) => s.trim()).filter(Boolean);
    const chunks =
      parts.length > 3
        ? [
            parts.slice(0, Math.ceil(parts.length / 2)).join("; "),
            parts.slice(Math.ceil(parts.length / 2)).join("; "),
          ]
        : [mgmt];
    for (const c of chunks) {
      story.push(say("att_dech", "talk", `แผนการรักษา: ${truncate(c, 220)}`, 5));
    }
  }

  // ---- Act 6: debrief ----
  const tps = asArr(lc.teaching_points).map((t) => txt(asStr(t))).filter(Boolean).slice(0, 3);
  for (const tp of tps) {
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
