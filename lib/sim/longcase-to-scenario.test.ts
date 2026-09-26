import { describe, expect, it } from "vitest";
import type { LongCaseFull } from "@/lib/types";
import { longCaseToScenario, slugForCase } from "./longcase-to-scenario";
import { describeScenarioError } from "./validate";
import type { ChoiceNode, SimScenario, StoryNode } from "./types";
import { SAY_MAX_CHARS } from "./chunk-says";

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
  examiner_questions: [
    { question: "บอกสาเหตุที่ cremasteric reflex หายไปในเคสนี้", modelAnswer: "spermatic cord ถูกบิด ทำให้ reflex arc ขาดออก", points: 15 },
    { question: "ถ้า Doppler US ปกติ คุณจะยังผ่าตัดไหม เพราะอะไร", modelAnswer: "ใช่ เพราะ clinical diagnosis สำคัญกว่า imaging — Doppler อาจ false negative", points: 20 },
    { question: "bilateral orchiopexy ทำไมต้องทำทั้งสองข้าง", modelAnswer: "Bell-clapper deformity เป็น bilateral เสี่ยงบิดอีกข้าง", points: 15 },
    { question: "ถ้ามาหลัง 24 ชม. ผลของ testis จะเป็นอย่างไร", modelAnswer: "Testicular necrosis สูง ต้อง orchiectomy", points: 10 },
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
  examiner_questions: [
    { question: "ทำไมต้อง rate control ก่อน BP control", modelAnswer: "ลด aortic wall stress (dP/dt) ก่อน มิฉะนั้น reflex tachycardia จะเพิ่ม shear", points: 20 },
    { question: "gold standard imaging ของภาวะนี้คืออะไร", modelAnswer: "CT angiography; ถ้า unstable ใช้ TEE ข้างเตียง", points: 15 },
  ],
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

  it("without normal results or DDx distractors: labs still chain (stop-early distractor), dx is not a choice", () => {
    // แลปทั้งหมด abnormal → ไม่มีตัวลวงผลปกติ แต่ยังมีตัวลวง "หยุดสั่งก่อนครบ";
    // accepted_ddx มีแต่ correct และไม่มีเคสอื่น → ไม่มีตัวลวง ddx
    const s = longCaseToScenario(
      mk({
        correct_diagnosis: "Sepsis",
        accepted_ddx: ["Sepsis"],
        lab_results: { CBC: { value: "WBC 22,000", isAbnormal: true }, Lactate: { value: "4.5", isAbnormal: true } },
        teaching_points: ["Early antibiotics"],
      }),
    )!;
    expect(describeScenarioError(s)).toBeNull();
    const lab = choices(s).filter((c) => c.options.some((o) => o.ok && o.tgt === "LAB"));
    expect(lab).toHaveLength(2);
    for (const c of lab) expect(c.options.some((o) => !o.ok && o.label.includes("ไปสรุปการวินิจฉัย"))).toBe(true);
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
    const peChoices = choices(s).filter((c) => c.options.some((o) => o.ok && o.tgt === "PE"));
    expect(peChoices.length).toBeGreaterThanOrEqual(1);
    expect(peChoices[0].options.find((o) => o.ok)!.label).toContain("GA");
  });

  it("keeps PE steps whose finding carries a photo (object form)", () => {
    const withPhoto = mk({
      ...TORSION,
      pe_findings: { ...TORSION.pe_findings, GA: { text: "Pale, sweating", image_url: "/images/longcase/ga.webp" } },
    });
    const s = longCaseToScenario(withPhoto)!;
    const peChoices = choices(s).filter((c) => c.options.some((o) => o.ok && o.tgt === "PE"));
    expect(peChoices[0].options.find((o) => o.ok)!.label).toContain("GA");
    expect(JSON.stringify(s)).toContain("Pale, sweating");
    expect(JSON.stringify(s)).not.toContain("image_url");
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

  // ---- examiner Q&A (retrieval practice จากคำถามสอบจริงเฉพาะเคส) ----
  function sayTexts(s: SimScenario): string[] {
    return s.story.flatMap((n) => ("say" in n ? [n.say.text] : []));
  }
  /** ข้อความทั้งหมดตามลำดับที่ผู้เล่นเห็นเมื่อตอบถูกทุกข้อ (say + คำถาม choice + then ของข้อถูก) */
  function playthrough(nodes: StoryNode[]): string[] {
    return nodes.flatMap((n) => {
      if ("say" in n) return [n.say.text];
      if ("choice" in n) {
        const ok = n.choice.options.find((o) => o.ok);
        return [n.choice.q, ...playthrough(ok?.then ?? [])];
      }
      return [];
    });
  }
  function examChoices(s: SimScenario): ChoiceNode["choice"][] {
    return choices(s).filter((c) => c.options.some((o) => o.tgt === "EXAM"));
  }

  it("adds an examiner Q&A phase surfacing the case's real questions AND model answers", () => {
    const s = longCaseToScenario(TORSION)!;
    const texts = playthrough(s.story);
    // คำถามสอบจริงต้องปรากฏ
    expect(texts.some((t) => t.includes("cremasteric reflex หายไป"))).toBe(true);
    // เฉลยจริงต้องปรากฏด้วย (ไม่ใช่แค่ถามลอยๆ)
    expect(texts.some((t) => t.includes("clinical diagnosis สำคัญกว่า imaging"))).toBe(true);
    // มี intro นำเข้าช่วงซักถาม
    expect(texts.some((t) => t.includes("ช่วงอาจารย์ซักถาม"))).toBe(true);
  });

  it("asks each examiner question as a choice: its own model answer is right, other questions' answers are distractors", () => {
    const s = longCaseToScenario(TORSION)!;
    const exam = examChoices(s);
    expect(exam.length).toBe(4);
    const crem = exam.find((c) => c.q.includes("cremasteric reflex หายไป"))!;
    expect(crem.options.filter((o) => o.ok)).toHaveLength(1);
    expect(crem.options.find((o) => o.ok)!.label).toContain("reflex arc ขาดออก");
    for (const o of crem.options.filter((x) => !x.ok)) {
      expect(o.label).not.toContain("reflex arc");
      expect(o.worsen).toBeFalsy();
    }
  });

  it("shows each examiner question before its model answer (retrieval-practice order)", () => {
    const s = longCaseToScenario(TORSION)!;
    const texts = playthrough(s.story);
    const qIdx = texts.findIndex((t) => t.includes("cremasteric reflex หายไป"));
    const aIdx = texts.findIndex((t) => t.startsWith("💡") && t.includes("reflex arc ขาดออก"));
    expect(qIdx).toBeGreaterThanOrEqual(0);
    expect(aIdx).toBeGreaterThan(qIdx);
  });

  it("caps examiner questions at 4 and orders them by points (highest first)", () => {
    const s = longCaseToScenario(TORSION)!;
    const qs = examChoices(s).map((c) => c.q);
    expect(qs.length).toBeLessThanOrEqual(4);
    // ข้อ points สูงสุด (Doppler = 20) ต้องมาก่อนข้อ points ต่ำกว่า (cremasteric = 15)
    const dopplerIdx = qs.findIndex((t) => t.includes("Doppler US ปกติ"));
    const cremIdx = qs.findIndex((t) => t.includes("cremasteric reflex หายไป"));
    expect(dopplerIdx).toBeGreaterThanOrEqual(0);
    expect(dopplerIdx).toBeLessThan(cremIdx);
  });

  it("falls back to ask-then-reveal when the case has only one examiner question", () => {
    const s = longCaseToScenario(
      mk({
        correct_diagnosis: "X",
        accepted_ddx: ["X", "Y"],
        examiner_questions: [{ question: "กลไกคืออะไร", modelAnswer: "เพราะ Z", points: 10 }],
      }),
    )!;
    expect(describeScenarioError(s)).toBeNull();
    expect(examChoices(s)).toHaveLength(0);
    const texts = sayTexts(s);
    expect(texts.findIndex((t) => t.includes("เพราะ Z"))).toBeGreaterThan(texts.findIndex((t) => t.includes("กลไกคืออะไร")));
  });

  // ---- ซักประวัติแบบถาม-ตอบต่อเนื่อง (จังหวะเดียวกับเกมร้านยา pharmroo) ----
  it("turns every history topic into its own ask → patient-answers choice, in standard order", () => {
    const s = longCaseToScenario(TORSION)!;
    const ask = choices(s).filter((c) => c.options.some((o) => o.ok && o.tgt === "ASK"));
    // TORSION มี HPI, PMH, SH → 3 จุดถาม
    expect(ask.map((c) => c.options.find((o) => o.ok)!.label)).toEqual([
      "ซักประวัติปัจจุบัน (HPI)",
      "ซักประวัติโรคประจำตัว (PMH)",
      "ซักประวัติสังคม (SH)",
    ]);
    // ผู้ป่วยตอบเองทันทีหลังถามถูก
    const pmhThen = ask[1].options.find((o) => o.ok)!.then!;
    expect(pmhThen).toHaveLength(1);
    expect("say" in pmhThen[0] && pmhThen[0].say.who).toBe("patient_young_male");
    expect("say" in pmhThen[0] && pmhThen[0].say.text).toContain("ไม่มีโรคประจำตัว");
    // คำถามถัดไปเกริ่นจากคำตอบล่าสุด
    expect(ask[2].q).toContain("ไม่มีโรคประจำตัว");
    // ตัวลวง: ถามข้ามลำดับ + หยุดซักประวัติก่อนครบ
    expect(ask[0].options.some((o) => !o.ok && o.label.includes("PMH"))).toBe(true);
    for (const c of ask) expect(c.options.some((o) => !o.ok && o.label.includes("ตรวจร่างกาย"))).toBe(true);
  });

  it("no longer narrates PMH/SH as a monologue by the attending", () => {
    const s = longCaseToScenario(TORSION)!;
    expect(sayTexts(s).some((t) => t.startsWith("PMH:") || t.startsWith("SH:"))).toBe(false);
  });

  // ---- ตรวจร่างกาย / แลป / วินิจฉัย / รักษา / debrief แบบถาม-ตอบทีละขั้น ----
  const OTHERS = [
    { diagnosis: "Acute appendicitis", teachingPoints: ["Alvarado score ช่วยประเมินความน่าจะเป็นของไส้ติ่งอักเสบ"], managementPlan: "NPO, IV fluid; Appendectomy" },
    { diagnosis: "Renal colic", teachingPoints: ["NSAIDs เป็น first-line สำหรับปวดนิ่วในไต", "CT KUB non-contrast เป็น gold standard"], managementPlan: "Ketorolac 30 mg IV; Tamsulosin 0.4 mg OD; bilateral orchiopexy" },
    { diagnosis: "Epididymo-orchitis", teachingPoints: ["ซ้ำกับ DDx — ต้องไม่ถูกใช้ซ้ำ"] },
  ];

  it("examines one system at a time head-to-toe, each finding revealed right after the pick", () => {
    const s = longCaseToScenario(TORSION)!;
    const pe = choices(s).filter((c) => c.options.some((o) => o.ok && o.tgt === "PE"));
    expect(pe.map((c) => c.options.find((o) => o.ok)!.label)).toEqual(["ตรวจ GA", "ตรวจ Heart", "ตรวจ GU"]);
    const guThen = pe[2].options.find((o) => o.ok)!.then!;
    expect("say" in guThen[0] && guThen[0].say.text).toContain("high-riding testis");
    expect(pe[1].q).toContain("GA");
    for (const c of pe) expect(c.options.some((o) => !o.ok && o.label.includes("ส่งตรวจเพิ่มเติม"))).toBe(true);
  });

  it("orders labs one at a time and hands back a cumulative lab report sheet, then a full summary", () => {
    const s = longCaseToScenario(TORSION)!;
    const lab = choices(s).filter((c) => c.options.some((o) => o.ok && o.tgt === "LAB"));
    expect(lab.map((c) => c.options.find((o) => o.ok)!.label)).toEqual(["สั่ง CBC", "สั่ง Scrotal US"]);
    const sheet2 = lab[1].options.find((o) => o.ok)!.then![0];
    expect("labSheet" in sheet2).toBe(true);
    if (!("labSheet" in sheet2)) return;
    expect(sheet2.labSheet.rows.map((r) => r.name)).toEqual(["CBC", "Scrotal US"]);
    expect(sheet2.labSheet.rows[1]).toMatchObject({ abnormal: true, isNew: true });
    expect(sheet2.labSheet.rows[0].isNew).toBeFalsy();
    expect(sheet2.labSheet.patient).toContain("นายสมชาย");
    const summary = s.story.find((n) => "labSheet" in n && n.labSheet.title.includes("สรุป"));
    expect(summary && "labSheet" in summary && summary.labSheet.rows.map((r) => r.name)).toEqual(["CBC", "Scrotal US", "UA"]);
  });

  it("lets the player diagnose with no attending reveal, padding options with other cases' diagnoses", () => {
    const s = longCaseToScenario(TORSION, OTHERS)!;
    expect(describeScenarioError(s)).toBeNull();
    const dx = choices(s).find((c) => c.options.some((o) => o.ok && o.tgt === "DX"))!;
    expect(dx.options.length).toBe(5);
    expect(dx.options.find((o) => o.ok)!.then ?? []).toHaveLength(0);
    // DDx ของเคสเอง + dx ของเคสอื่น (Epididymo-orchitis ไม่ซ้ำ)
    const labels = dx.options.map((o) => o.label);
    expect(labels).toContain("Acute appendicitis");
    expect(labels).toContain("Renal colic");
    expect(labels.filter((l) => l.includes("Epididymo-orchitis"))).toHaveLength(1);
    // ไม่มีอาจารย์พูด "ถูกต้อง — <dx>"
    expect(playthrough(s.story).some((t) => t.startsWith("ถูกต้อง"))).toBe(false);
  });

  it("asks which result supports the diagnosis (abnormal right, normal wrong)", () => {
    const s = longCaseToScenario(TORSION)!;
    const ev = choices(s).find((c) => c.q.includes("สนับสนุน"))!;
    expect(ev.options.find((o) => o.ok)!.label).toContain("CBC");
    expect(ev.options.some((o) => !o.ok && o.label.includes("UA"))).toBe(true);
  });

  it("writes orders one at a time from an order shelf, handing back a cumulative doctor's order sheet", () => {
    const s = longCaseToScenario(TORSION)!;
    const mg = choices(s).filter((c) => c.options.some((o) => o.ok && o.tgt === "MGMT"));
    expect(mg).toHaveLength(3);
    for (const c of mg) expect(c.shelf).toBe(true);
    expect(mg[1].options.find((o) => o.ok)!.label).toContain("bilateral orchiopexy");
    const sheet = mg[1].options.find((o) => o.ok)!.then![0];
    expect("orderSheet" in sheet).toBe(true);
    if (!("orderSheet" in sheet)) return;
    expect(sheet.orderSheet.orders).toHaveLength(2);
    expect(sheet.orderSheet.orders[0].text).toContain("Emergency surgical exploration");
    expect(sheet.orderSheet.orders[1]).toMatchObject({ isNew: true });
    expect(mg[2].options.some((o) => !o.ok && o.label.includes("ครบแล้ว"))).toBe(true);
  });

  it("stocks the order shelf with other cases' orders as decoys, never this case's own orders", () => {
    const s = longCaseToScenario(TORSION, OTHERS)!;
    expect(describeScenarioError(s)).toBeNull();
    const mg = choices(s).filter((c) => c.options.some((o) => o.ok && o.tgt === "MGMT"));
    const decoys = mg.flatMap((c) => c.options.filter((o) => o.why?.includes("โรคอื่น")).map((o) => o.label));
    expect(decoys.length).toBeGreaterThan(0);
    expect(decoys).toContain("Appendectomy");
    // "bilateral orchiopexy" เป็น order ของเคสนี้เอง — ห้ามโผล่เป็นตัวหลอก
    expect(decoys.some((d) => d.includes("orchiopexy"))).toBe(false);
    expect(mg[0].options.length).toBeGreaterThanOrEqual(5);
  });

  it("debriefs one point at a time: pick this case's lesson over other cases' lessons, then the reveal", () => {
    const s = longCaseToScenario(TORSION, OTHERS)!;
    expect(describeScenarioError(s)).toBeNull();
    const learn = choices(s).filter((c) => c.options.some((o) => o.tgt === "LEARN"));
    expect(learn).toHaveLength(2);
    const ok = learn[0].options.find((o) => o.ok)!;
    expect(ok.label).toContain("surgical emergency");
    expect(learn[0].options.filter((o) => !o.ok).every((o) => !o.label.includes("Testicular"))).toBe(true);
    expect("say" in ok.then![0] && ok.then![0].say.text).toContain("💡");
    // ไม่มีเคสอื่น → ทีละข้อแบบแตะไปต่อ (ไม่ทิ้งรวดเดียวใน node เดียว)
    const plain = longCaseToScenario(TORSION)!;
    expect(sayTexts(plain).filter((t) => t.startsWith("💡"))).toHaveLength(2);
  });

  it("stays valid when examiner_questions is missing or malformed", () => {
    const missing = longCaseToScenario(mk({ correct_diagnosis: "X", accepted_ddx: ["X", "Y"], examiner_questions: [] }))!;
    expect(describeScenarioError(missing)).toBeNull();
    const malformed = longCaseToScenario(
      mk({
        correct_diagnosis: "X",
        accepted_ddx: ["X", "Y"],
        examiner_questions: [{ foo: "bar" }, { question: "ok?", modelAnswer: "" }] as unknown as LongCaseFull["examiner_questions"],
      }),
    )!;
    expect(describeScenarioError(malformed)).toBeNull();
    // element ที่ malformed (ไม่มี modelAnswer) ต้องถูกข้าม → ไม่มีช่วงซักถาม
    expect(sayTexts(malformed).some((t) => t.includes("ช่วงอาจารย์ซักถาม"))).toBe(false);
  });

  // ---- sprite ผู้ป่วยต้องตรงเพศ/วัย (บั๊กเดิม: hardcode patient_generic ทุกเคส) ----
  function hxWho(s: SimScenario): string[] {
    // คนที่ตอบ HPI — อยู่ใน then ของข้อถูก choice ซักประวัติ หรือเป็น say ตรงๆ
    const out: string[] = [];
    for (const n of s.story) {
      if ("say" in n) out.push(n.say.who);
      if ("choice" in n) {
        for (const o of n.choice.options) {
          for (const t of o.then ?? []) if ("say" in t) out.push(t.say.who);
        }
      }
    }
    return out;
  }
  const hxCase = (patient_info: Record<string, unknown>, pi = "มีอาการมา 2 วัน") =>
    longCaseToScenario(
      mk({ correct_diagnosis: "X", accepted_ddx: ["X", "Y"], patient_info, history_script: { cc: "อาการนำ", pi, pmh: "ไม่มีโรคประจำตัว" } }),
    )!;

  it("voices the history with a sprite matching the patient's sex and age", () => {
    expect(hxWho(hxCase({ age: 58, gender: "ชาย" }))).toContain("patient_generic");
    expect(hxWho(hxCase({ age: 32, gender: "หญิง" }))).toContain("patient_female");
    expect(hxWho(hxCase({ age: 72, gender: "หญิง" }))).toContain("patient_elderly");
    const boy = hxWho(hxCase({ age: 10, gender: "ชาย" }));
    expect(boy).toContain("patient_child");
    expect(boy).not.toContain("patient_generic");
  });

  it("doesn't put a middle-aged patient_generic sprite on young or elderly men (บั๊กเดิม: ชาย 19 ปี ปวดอัณฑะ โผล่เป็นลุงวัย 50)", () => {
    const young = hxWho(hxCase({ age: 19, gender: "ชาย" }));
    expect(young).toContain("patient_young_male");
    expect(young).not.toContain("patient_generic");
    // ขอบเขต: <35 เป็นหนุ่ม, 35-59 เป็น patient_generic, ≥60 เป็นชายสูงอายุ
    expect(hxWho(hxCase({ age: 34, gender: "ชาย" }))).toContain("patient_young_male");
    expect(hxWho(hxCase({ age: 35, gender: "ชาย" }))).toContain("patient_generic");
    const elderly = hxWho(hxCase({ age: 72, gender: "ชาย" }));
    expect(elderly).toContain("patient_elderly_male");
    expect(elderly).not.toContain("patient_generic");
    expect(hxWho(hxCase({ age: 60, gender: "ชาย" }))).toContain("patient_elderly_male");
  });

  it("lets the mother answer for infants and toddlers who cannot speak", () => {
    const infant = hxWho(hxCase({ age: "8 เดือน", gender: "ชาย" }));
    expect(infant).toContain("mother_rel");
    expect(infant).not.toContain("patient_generic");
    expect(hxWho(hxCase({ age: 4, gender: "หญิง" }))).toContain("mother_rel");
  });

  it("uses the pregnant sprite only for visibly pregnant patients", () => {
    expect(hxWho(hxCase({ age: 28, gender: "หญิง" }, "ตั้งครรภ์ GA 34 สัปดาห์ เจ็บครรภ์"))).toContain("patient_pregnant");
    // ครรภ์อ่อน (ectopic 7 สัปดาห์) ยังไม่เห็นท้อง → sprite หญิงปกติ
    expect(hxWho(hxCase({ age: 26, gender: "หญิง" }, "ประจำเดือนขาด ตั้งครรภ์ 7 สัปดาห์ ปวดท้องน้อย"))).toContain("patient_female");
  });

  it("keeps every line short — long speech is split into several short taps (read little, often)", () => {
    const longPi = Array.from({ length: 12 }, (_, i) => `อาการข้อที่ ${i + 1} เป็นมากขึ้นเรื่อยๆ`).join(" ");
    const s = longCaseToScenario(
      mk({ correct_diagnosis: "X", accepted_ddx: ["X", "Y"], history_script: { cc: "ไข้", pi: longPi, pmh: "ไม่มี" } }),
    )!;
    expect(describeScenarioError(s)).toBeNull();
    const all = (nodes: StoryNode[]): string[] =>
      nodes.flatMap((n) =>
        "say" in n ? [n.say.text] : "choice" in n ? n.choice.options.flatMap((o) => all(o.then ?? [])) : [],
      );
    const texts = all(s.story);
    for (const t of texts) expect(t.length).toBeLessThanOrEqual(SAY_MAX_CHARS);
    // HPI ยาวถูกแตกเป็นหลายท่อน ไม่ใช่ถูกตัดทิ้ง
    expect(texts.filter((t) => t.includes("อาการข้อที่")).length).toBeGreaterThan(1);
  });
});
