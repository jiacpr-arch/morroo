import { describe, it, expect } from "vitest";
import { matchKey, matchResult, normalizeKey, readHistoryScript } from "@/lib/longcase-match";

describe("normalizeKey", () => {
  it("strips case, spaces and punctuation", () => {
    expect(normalizeKey("Blood Culture")).toBe("bloodculture");
    expect(normalizeKey("12-lead ECG")).toBe("12leadecg");
    expect(normalizeKey("AST / ALT")).toBe("astalt");
  });
});

describe("matchKey", () => {
  it("matches exactly", () => {
    expect(matchKey("CBC", ["CBC", "BMP"])).toBe("CBC");
  });

  it("matches case/spacing/punctuation variants (real DB keys)", () => {
    // grid has "Blood culture", case stored "Blood Culture"
    expect(matchKey("Blood culture", ["Blood Culture", "WBC"])).toBe("Blood Culture");
  });

  it("matches PE synonyms seen in cases", () => {
    expect(matchKey("Heart", ["Cardiovascular", "Abdomen"])).toBe("Cardiovascular");
    expect(matchKey("Heart", ["CVS"])).toBe("CVS");
    expect(matchKey("Lung", ["Respiratory", "HEENT"])).toBe("Respiratory");
    expect(matchKey("Lung", ["Chest"])).toBe("Chest");
    expect(matchKey("Neuro", ["Neurological"])).toBe("Neurological");
    expect(matchKey("GA", ["General Appearance"])).toBe("General Appearance");
  });

  it("matches lab/imaging synonyms seen in cases", () => {
    expect(matchKey("ECG", ["12-lead ECG", "CBC"])).toBe("12-lead ECG");
    expect(matchKey("UA", ["Urinalysis"])).toBe("Urinalysis");
    expect(matchKey("Echo", ["Echocardiography"])).toBe("Echocardiography");
    expect(matchKey("CXR", ["Chest X-Ray (PA)"])).toBe("Chest X-Ray (PA)");
  });

  it("returns undefined for a genuinely absent test", () => {
    expect(matchKey("MRI Brain", ["CBC", "BMP", "CXR"])).toBeUndefined();
    expect(matchKey("CT Head", ["Troponin I"])).toBeUndefined();
  });

  it("prefers an exact key over a fuzzy one", () => {
    expect(matchKey("CBC", ["CBC (Day 3)", "CBC"])).toBe("CBC");
  });
});

describe("matchResult", () => {
  it("resolves a value through a synonym", () => {
    const findings = { Cardiovascular: "Pansystolic murmur grade 3/6" };
    expect(matchResult("Heart", findings)).toBe("Pansystolic murmur grade 3/6");
  });

  it("returns undefined when nothing matches", () => {
    expect(matchResult("MRI Brain", { CBC: { value: "x", isAbnormal: false } })).toBeUndefined();
  });
});

describe("readHistoryScript", () => {
  it("reads hand-authored short keys", () => {
    const hs = readHistoryScript({
      cc: "ไอเรื้อรัง", pi: "ไอมา 3 เดือน", onset: "ค่อยเป็นค่อยไป",
      pmh: "เบาหวาน", fh: "ไม่มี", sh: "สูบบุหรี่", ros: "น้ำหนักลด",
    });
    expect(hs.cc).toBe("ไอเรื้อรัง");
    expect(hs.pi).toBe("ไอมา 3 เดือน");
    expect(hs.sh).toBe("สูบบุหรี่");
  });

  it("reads auto-generated long keys (the bug: these were all dropped)", () => {
    const hs = readHistoryScript({
      chief_complaint: "ไอเรื้อรัง มีเสมหะ มา 3 เดือน",
      hpi: "ผู้ป่วยชายไทย อายุ 54 ปี...",
      past_medical: "ไม่มีโรคประจำตัว",
      medications: "ไม่มี",
      family_history: "พ่อเป็นมะเร็งปอด",
      social_history: "สูบบุหรี่ 30 pack-year",
      review_of_systems: "น้ำหนักลด 5 กก.",
    });
    expect(hs.cc).toBe("ไอเรื้อรัง มีเสมหะ มา 3 เดือน");
    expect(hs.pi).toBe("ผู้ป่วยชายไทย อายุ 54 ปี...");
    expect(hs.pmh).toBe("ไม่มีโรคประจำตัว");
    expect(hs.fh).toBe("พ่อเป็นมะเร็งปอด");
    expect(hs.sh).toBe("สูบบุหรี่ 30 pack-year");
    expect(hs.ros).toBe("น้ำหนักลด 5 กก.");
  });

  it("returns empty strings for missing fields, never undefined", () => {
    const hs = readHistoryScript({ cc: "x" });
    expect(hs.cc).toBe("x");
    expect(hs.ros).toBe("");
    expect(hs.meds).toBe("");
  });

  it("tolerates null/undefined input", () => {
    expect(readHistoryScript(null).cc).toBe("");
    expect(readHistoryScript(undefined).pi).toBe("");
  });
});
