// ตรวจโจทย์แบบเข้ม — ใช้ในเส้นทางแอดมิน/AI ก่อนเซฟลง DB
// (isValidScenario ใน types.ts เป็นตัวหลวมสำหรับ runtime load;
//  ตัวนี้เพิ่มกติกาที่ engine คาดหวังจริง + รายงานตำแหน่งที่ผิดเป็นไทย)

import { SIM_BACKGROUNDS } from "./backgrounds";
import { SIM_CHARACTERS } from "./characters";
import { isValidScenario, type SimScenario, type StoryNode } from "./types";

const POSE_SET = new Set(["idle", "talk", "panic", "stern", "happy"]);
const RHYTHM_SET = new Set(["flat", "vf", "nsr"]);

// ค่าเริ่มต้นกันเดาข้อถูกจากความยาว — คาลิเบรตจากข้อมูลจริง: ลองบังคับ 1.5x/floor 25
// กับเกมที่มีอยู่จริง 161 เกมแล้วพบว่า median ที่เขียนได้จริงคือ ~1.84x (ข้อความคลินิก
// ภาษาไทยที่ถูกต้องมักยาวกว่าตัวลวงสั้นๆ โดยธรรมชาติ) เข้มเกินจนของจริงผ่านแทบไม่ได้
// (ratio: BALANCE_RATIO, floor: BALANCE_FLOOR)
const BALANCE_RATIO = 1.8;
const BALANCE_FLOOR = 30;

function checkNodes(
  nodes: StoryNode[],
  path: string,
  charIds: Set<string>,
  balanceRatio: number,
  balanceFloor: number,
): string | null {
  for (let i = 0; i < nodes.length; i++) {
    const node = nodes[i];
    const at = `${path}[${i}]`;

    if ("say" in node) {
      const { who, pose } = node.say;
      if (!charIds.has(who)) {
        return `${at}: ไม่รู้จักตัวละคร "${who}" (ใช้ได้: ${[...charIds].join(", ")})`;
      }
      if (pose && !POSE_SET.has(pose)) {
        return `${at}: pose "${pose}" ไม่ถูกต้อง (ใช้ได้: ${[...POSE_SET].join(", ")})`;
      }
      if (node.say.fx?.rhythm && !RHYTHM_SET.has(node.say.fx.rhythm)) {
        return `${at}: rhythm "${node.say.fx.rhythm}" ไม่ถูกต้อง (ใช้ได้: ${[...RHYTHM_SET].join(", ")})`;
      }
      if (/<[a-z/!]/i.test(node.say.text)) {
        return `${at}: text ห้ามมี HTML — ใช้ **คำเน้น** แทน`;
      }
    }

    if ("inter" in node && node.fx?.rhythm && !RHYTHM_SET.has(node.fx.rhythm)) {
      return `${at}: rhythm "${node.fx.rhythm}" ไม่ถูกต้อง`;
    }

    if ("choice" in node) {
      const oks = node.choice.options.filter((o) => o.ok === true);
      if (oks.length !== 1) {
        return `${at}: choice "${node.choice.q}" ต้องมีตัวเลือกถูก (ok: true) ตัวเดียว — ตอนนี้มี ${oks.length}`;
      }
      // ห้าม label ซ้ำใน choice เดียว — UI ใช้ label เป็น key ขีดฆ่าข้อที่ตอบผิดแล้ว
      const labels = node.choice.options.map((o) => o.label.trim());
      if (new Set(labels).size !== labels.length) {
        return `${at}: choice "${node.choice.q}" มี label ซ้ำกัน`;
      }
      // กัน "ข้อถูกยาวสุด" — cue ที่ทำให้ผู้เล่นเดาถูกโดยไม่ต้องคิด
      // (floor: ตัวลวงสั้นมากไม่ถือเป็น cue จนกว่าข้อถูกจะยาวจริงๆ)
      const okLen = oks[0].label.trim().length;
      const maxWrongLen = Math.max(
        balanceFloor,
        ...node.choice.options.filter((o) => o.ok !== true).map((o) => o.label.trim().length),
      );
      if (okLen > maxWrongLen * balanceRatio) {
        return `${at}: choice "${node.choice.q}" ข้อถูกยาว ${okLen} ตัวอักษร เกิน ${balanceRatio} เท่าของตัวลวงที่ยาวสุด (${maxWrongLen}) — ผู้เล่นเดาข้อถูกจากความยาวได้ ปรับ label ให้ยาวใกล้เคียงกัน`;
      }
      for (const opt of node.choice.options) {
        if (opt.then) {
          const err = checkNodes(opt.then, `${at}.then`, charIds, balanceRatio, balanceFloor);
          if (err) return err;
        }
      }
    }
  }
  return null;
}

/**
 * คืน null เมื่อผ่าน หรือข้อความไทยอธิบายจุดที่ผิดจุดแรก
 * @param extraCharIds slug ตัวละครจากตาราง sim_characters ที่อนุญาตเพิ่มจาก built-in
 * @param balanceRatio ข้อถูกยาวได้ไม่เกินกี่เท่าของตัวลวงที่ยาวสุด (ดีฟอลต์ BALANCE_RATIO)
 * @param balanceFloor ตัวลวงสั้นกว่านี้ไม่นับเป็นฐานเทียบ (ดีฟอลต์ BALANCE_FLOOR)
 */
export function describeScenarioError(
  scenario: unknown,
  extraCharIds: string[] = [],
  balanceRatio: number = BALANCE_RATIO,
  balanceFloor: number = BALANCE_FLOOR,
): string | null {
  if (!isValidScenario(scenario)) {
    return "โครงสร้างโจทย์ไม่ถูกต้อง — ต้องมี slug, title และ story (array ของ node แบบ say/inter/skip/choice/end โดยทุก choice มี ≥2 ตัวเลือกและมีข้อถูก)";
  }
  const s = scenario as SimScenario;
  if (!/^[a-z0-9]+(-[a-z0-9]+)*$/.test(s.slug)) {
    return `slug "${s.slug}" ต้องเป็น kebab-case (a-z, 0-9, ขีดกลาง)`;
  }
  const last = s.story[s.story.length - 1];
  if (!("end" in last)) {
    return "story ต้องจบด้วย node { end: true }";
  }
  if (s.bg !== undefined && !SIM_BACKGROUNDS[s.bg]) {
    return `bg "${s.bg}" ไม่รู้จัก (ใช้ได้: ${Object.keys(SIM_BACKGROUNDS).join(", ")})`;
  }
  const charIds = new Set([...Object.keys(SIM_CHARACTERS), ...extraCharIds]);
  return checkNodes(s.story, "story", charIds, balanceRatio, balanceFloor);
}
