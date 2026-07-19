import { describe, expect, it } from "vitest";
import type { LongCaseFull } from "@/lib/types";
import { longCaseToScenario, slugForCase } from "./longcase-to-scenario";
import { describeScenarioError } from "./validate";
import type { ChoiceNode, SimScenario, StoryNode } from "./types";

function mk(over: Partial<LongCaseFull>): LongCaseFull {
  return {
    id: "b88ba108-986b-4842-a5b3-b47c12bf4423",
    title: "เคสทดสอบ",
    specialty: "Medicine",
    difficulty: "medium",
    week_number: null,
    is_weekly: false,
    is_published: true,
    published_at: "",
    patient_info: {},
    correct_diagnosis: "",
    created_at: "",
    audience: "student",
    board_specialty: null,
    history_script: {},
    pe_findings: {},
    lab_results: {},
    imaging_results: null,
    accepted_ddx: [],
    management_plan: "",
    teaching_points: [],
    examiner_questions: [],
    scoring_rubric: {},
    ...over,
  };
}

function choices(s: SimScenario): ChoiceNode["choice"][] {
  return s.story
    .filter((n: StoryNode): n is ChoiceNode => "choice" in n)
    .map((n) => n.choice);
}

// เคสจริง 1: Testicular torsion (student) — abnormal 2, normal 1; ddx 2 distractor
const TORSION = mk({
  id: "b88ba108-986b-4842-a5b3-b47c12bf4423",
  title: "ชาย 19 ปี ปวดท้องร้าวลงอัณฑะ",
  specialty: "Surgery",
  difficulty: "hard",
  audience: "student",
  patient_info: { age: 19, name: "นายสมชาย ใจดี", gender: "ชาย", vitals: { bp: "125/75", hr: 105, rr: 18, temp: 37.2, o2sat: 99 } },
  history_script: {
    cc: "ปวดอัณฑะซ้ายเฉียบพลัน 3 ชั่วโมง",
    pi: "เจ็บปวดอัณฑะซ้ายรุนแรง ร้าวขึ้นท้องน้อยซ้าย คลื่นไส้อาเจียน เคยเป็นแล้วหายเอง 2 เดือนก่อน",
    onset: "เจ็บฉับพลันขณะตื่นนอน ปวดมากขึ้นเรื่อยๆ",
    pmh: "ไม่มีโรคประจำตัว",
    sh: "นักศึกษา ไม่สูบบุหรี่",
  },
  pe_findings: {
    GA: "ดูเจ็บปวดมาก กระสับกระส่าย",
    GU: "อัณฑะซ้ายบวม แดง กดเจ็บ high-riding testis, cremasteric reflex หาย",
    Heart: "Regular, no murmur",
  },
  lab_results: {
    UA: { value: "Normal, no pyuria", isAbnormal: false },
    CBC: { value: "WBC 11,200", isAbnormal: true },
    "Scrotal US": { value: "Decreased blood flow to left testis on Doppler", isAbnormal: true },
  },
  correct_diagnosis: "Testicular Torsion (ลูกอัณฑะบิดขั้ว)",
  accepted_ddx: ["Testicular Torsion", "Epididymo-orchitis", "Incarcerated hernia"],
  management_plan: "Emergency surgical exploration within 6 hours; bilateral orchiopexy; orchiectomy ถ้าเนื้อตาย",
  teaching_points: [
    "Testicular torsion = surgical emergency ต้องผ่าตัดภายใน 6 ชม.",
    "High-riding testis + absent cremasteric reflex = classic signs",
  ],
});

// เคสจริง 2: Aortic dissection (board) — abnormal 3, normal 2; ddx 3 distractor;
// มีค่าที่มีเครื่องหมาย < / > (ต้องไม่ทำ validator no-HTML พัง)
const AORTIC = mk({
  id: "e2d8812a-5cd5-41fa-acaa-c63320bd6c1e",
  title: "ชาย 45 ปี เจ็บอกร้าวหลัง BP ต่างแขนซ้าย-ขวา",
  specialty: "Emergency",
  audience: "board",
  patient_info: { age: 45, name: "นายอนันต์ ใจดี", gender: "ชาย", vitals: { bp: "180/100 (R) / 130/80 (L)", hr: 110, rr: 22, temp: 37, o2sat: 97 } },
  history_script: { cc: "เจ็บอกรุนแรงทันที ร้าวไปหลัง", pi: "เจ็บแน่นกลางอก มี diaphoresis, near-syncope", onset: "ขณะยกของหนัก 90 นาทีก่อน", pmh: "HT ไม่กินยาสม่ำเสมอ" },
  pe_findings: { GA: "หน้าซีด เหงื่อแตก", Heart: "Early diastolic murmur, BP differential >40 mmHg", Pulses: "left radial < right" },
  lab_results: {
    BMP: { value: "Na 138, K 4.0, Cr 1.0", isAbnormal: false },
    CBC: { value: "WBC 11,800", isAbnormal: false },
    "D-dimer": { value: "4,520 ng/mL (>500 markedly elevated)", isAbnormal: true },
  },
  imaging_results: {
    CXR: { value: "Widened mediastinum >8 cm, left pleural cap", isAbnormal: true },
  },
  correct_diagnosis: "Acute Type A Aortic Dissection (Stanford A)",
  accepted_ddx: ["Type A aortic dissection", "STEMI", "Pulmonary embolism", "Esophageal rupture (Boerhaave)"],
  management_plan: "IV labetalol to HR<60 + SBP 100-120; STAT CT angio; ปรึกษา CVT surgery emergent",
  teaching_points: ["Type A = surgical emergency", "Rate control ก่อน BP control", "CXR widened mediastinum + BP differential = classic"],
});

describe("longCaseToScenario", () => {
  it("produces a strictly-valid scenario for a real student case", () => {
    const s = longCaseToScenario(TORSION)!;
    expect(s).not.toBeNull();
    expect(describeScenarioError(s)).toBeNull();
    expect(s.slug).toBe(slugForCase(TORSION.id));
    expect(s.category).toBe("longcase");
    expect(s.sourceCaseId).toBe(TORSION.id);
  });

  it("scores the diagnosis with correct_diagnosis as the one right option", () => {
    const s = longCaseToScenario(TORSION)!;
    const dx = choices(s).find((c) => c.options.some((o) => o.tgt === "DX"))!;
    expect(dx).toBeTruthy();
    const oks = dx.options.filter((o) => o.ok);
    expect(oks).toHaveLength(1);
    expect(oks[0].label).toContain("Testicular Torsion");
    // ตัวลวงมาจาก accepted_ddx ที่เหลือ
    expect(dx.options.some((o) => o.label.includes("Epididymo-orchitis"))).toBe(true);
  });

  it("scores lab ordering only from abnormal vs normal results", () => {
    const s = longCaseToScenario(TORSION)!;
    const lab = choices(s).find((c) => c.options.some((o) => o.tgt === "LAB"))!;
    expect(lab).toBeTruthy();
    const oks = lab.options.filter((o) => o.ok);
    expect(oks).toHaveLength(1);
    // ตัวถูกคือ test ที่ abnormal (CBC มาก่อน Scrotal US ตามลำดับ), ตัวลวง = UA (ปกติ)
    expect(oks[0].label).toContain("CBC");
    expect(lab.options.some((o) => !o.ok && o.label.includes("UA"))).toBe(true);
  });

  it("handles a real board case with < / > in values and imaging", () => {
    const s = longCaseToScenario(AORTIC)!;
    expect(describeScenarioError(s)).toBeNull();
    expect(s.slug).toBe(slugForCase(AORTIC.id));
    const dx = choices(s).find((c) => c.options.some((o) => o.tgt === "DX"))!;
    expect(dx.options.find((o) => o.ok)!.label).toContain("Aortic Dissection");
  });

  it("survives history_script stored as a scalar string", () => {
    const s = longCaseToScenario(
      mk({ history_script: "ผู้ป่วยชายมาด้วยไข้สูง 3 วัน" as unknown as Record<string, unknown>, correct_diagnosis: "Dengue", accepted_ddx: ["Dengue", "Influenza"] }),
    )!;
    expect(s).not.toBeNull();
    expect(describeScenarioError(s)).toBeNull();
  });

  it("degrades to reveal (no scored choice) when data lacks ground truth", () => {
    // แลปทั้งหมด abnormal → ไม่มีตัวลวงปกติ; accepted_ddx มีแต่ correct → ไม่มีตัวลวง ddx
    const s = longCaseToScenario(
      mk({
        correct_diagnosis: "Sepsis",
        accepted_ddx: ["Sepsis"],
        lab_results: { CBC: { value: "WBC 22,000", isAbnormal: true }, Lactate: { value: "4.5", isAbnormal: true } },
        teaching_points: ["Early antibiotics"],
      }),
    )!;
    expect(describeScenarioError(s)).toBeNull();
    expect(choices(s).some((c) => c.options.some((o) => o.tgt === "LAB"))).toBe(false);
    expect(choices(s).some((c) => c.options.some((o) => o.tgt === "DX"))).toBe(false);
  });

  it("adds interactive choices to history-taking, PE, and management — not just lab+dx", () => {
    const s = longCaseToScenario(TORSION)!;
    const all = choices(s);
    // เดิมมีแค่ LAB + DX (2 จุด) — ตอนนี้ต้องมี ASK/PE/MGMT เพิ่มด้วย
    expect(all.length).toBeGreaterThanOrEqual(5);
    const tgts = new Set(all.flatMap((c) => c.options.map((o) => o.tgt)));
    expect(tgts.has("ASK")).toBe(true);
    expect(tgts.has("PE")).toBe(true);
    expect(tgts.has("MGMT")).toBe(true);
    expect(tgts.has("LAB")).toBe(true);
    expect(tgts.has("DX")).toBe(true);
  });

  it("never marks sequencing distractors as worsen (not a real clinical error)", () => {
    const s = longCaseToScenario(TORSION)!;
    const sequencing = choices(s).filter((c) =>
      c.options.some((o) => o.tgt === "ASK" || o.tgt === "PE" || o.tgt === "MGMT"),
    );
    expect(sequencing.length).toBeGreaterThan(0);
    for (const c of sequencing) {
      for (const o of c.options) expect(o.worsen).toBeFalsy();
    }
  });

  it("gates history-taking with HPI before PMH/SH (universal sequence, not case-specific)", () => {
    const s = longCaseToScenario(TORSION)!;
    const askChoices = choices(s).filter((c) => c.options.some((o) => o.tgt === "ASK"));
    expect(askChoices.length).toBeGreaterThanOrEqual(1);
    expect(askChoices[0].options.find((o) => o.ok)!.label).toContain("HPI");
  });

  it("orders physical exam choices head-to-toe (GA before GU)", () => {
    const s = longCaseToScenario(TORSION)!;
    const peChoices = choices(s).filter((c) => c.options.some((o) => o.tgt === "PE"));
    expect(peChoices.length).toBeGreaterThanOrEqual(1);
    expect(peChoices[0].options.find((o) => o.ok)!.label).toContain("GA");
  });

  it("gates management on the case author's own written order (not a guessed order)", () => {
    const s = longCaseToScenario(TORSION)!;
    const mgmt = choices(s).find((c) => c.options.some((o) => o.tgt === "MGMT"))!;
    expect(mgmt).toBeTruthy();
    expect(mgmt.options.find((o) => o.ok)!.label).toContain("Emergency surgical exploration");
  });

  it("still produces a rich choice set for the board case with sparser history data", () => {
    const s = longCaseToScenario(AORTIC)!;
    const all = choices(s);
    expect(all.length).toBeGreaterThanOrEqual(5);
    expect(describeScenarioError(s)).toBeNull();
  });
});
