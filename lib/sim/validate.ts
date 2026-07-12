// ตรวจโจทย์แบบเข้ม — ใช้ในเส้นทางแอดมิน/AI ก่อนเซฟลง DB
// (isValidScenario ใน types.ts เป็นตัวหลวมสำหรับ runtime load;
//  ตัวนี้เพิ่มกติกาที่ engine คาดหวังจริง + รายงานตำแหน่งที่ผิดเป็นไทย)

import { SIM_CHARACTERS } from "./characters";
import { isValidScenario, type SimScenario, type StoryNode } from "./types";

const POSE_SET = new Set(["idle", "talk", "panic", "stern", "happy"]);
const RHYTHM_SET = new Set(["flat", "vf", "nsr"]);

function checkNodes(nodes: StoryNode[], path: string): string | null {
  for (let i = 0; i < nodes.length; i++) {
    const node = nodes[i];
    const at = `${path}[${i}]`;

    if ("say" in node) {
      const { who, pose } = node.say;
      if (!SIM_CHARACTERS[who]) {
        return `${at}: ไม่รู้จักตัวละคร "${who}" (ใช้ได้: ${Object.keys(SIM_CHARACTERS).join(", ")})`;
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
      for (const opt of node.choice.options) {
        if (opt.then) {
          const err = checkNodes(opt.then, `${at}.then`);
          if (err) return err;
        }
      }
    }
  }
  return null;
}

/**
 * คืน null เมื่อผ่าน หรือข้อความไทยอธิบายจุดที่ผิดจุดแรก
 */
export function describeScenarioError(scenario: unknown): string | null {
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
  return checkNodes(s.story, "story");
}
