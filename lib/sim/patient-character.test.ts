import { describe, expect, it } from "vitest";
import { ageYears, historySpeaker, patientCharId } from "./patient-character";

describe("ageYears", () => {
  it("parses numbers and Thai/English units", () => {
    expect(ageYears(45)).toBe(45);
    expect(ageYears("19 ปี")).toBe(19);
    expect(ageYears("6 เดือน")).toBe(0.5);
    expect(ageYears("ไม่ทราบ")).toBeNull();
  });
});

describe("patientCharId", () => {
  it("buckets by age and gender", () => {
    expect(patientCharId({ age: 8, gender: "หญิง" }, "")).toBe("patient_child");
    expect(patientCharId({ age: 25, gender: "ชาย" }, "")).toBe("patient_young_male");
    expect(patientCharId({ age: 45, gender: "ชาย" }, "")).toBe("patient_generic");
    expect(patientCharId({ age: 70, gender: "male" }, "")).toBe("patient_elderly_male");
    expect(patientCharId({ age: 30, gender: "หญิง" }, "")).toBe("patient_female");
    expect(patientCharId({ age: 72, gender: "หญิง" }, "")).toBe("patient_elderly");
  });

  it("shows pregnancy only when visibly advanced", () => {
    expect(patientCharId({ age: 28, gender: "หญิง" }, "ตั้งครรภ์ 32 สัปดาห์")).toBe("patient_pregnant");
    expect(patientCharId({ age: 28, gender: "หญิง" }, "ตั้งครรภ์ 7 สัปดาห์")).toBe("patient_female");
  });
});

describe("historySpeaker", () => {
  it("lets the mother answer for a young child", () => {
    expect(historySpeaker({ age: "8 เดือน" }, "patient_child")).toBe("mother_rel");
    expect(historySpeaker({ age: 10 }, "patient_child")).toBe("patient_child");
  });
});
