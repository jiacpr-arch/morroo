import { describe, expect, it } from "vitest";
import { illustrationPrompt, illustrationSceneError } from "@/lib/longcase-illustration";

describe("illustrationSceneError", () => {
  it("accepts a physical-exam sign", () => {
    expect(illustrationSceneError("Both lower legs with bilateral pitting edema up to the knees")).toBeNull();
  });

  it("rejects investigation images", () => {
    for (const s of [
      "12-lead ECG showing ST elevation in V1-V4",
      "Chest X-ray with right lower lobe consolidation",
      "CXR with cardiomegaly and pleural effusion",
      "CT brain showing hyperdense MCA sign",
      "Abdominal ultrasound with gallstones",
    ]) {
      expect(illustrationSceneError(s)).not.toBeNull();
    }
  });

  it("rejects too short or too long scenes", () => {
    expect(illustrationSceneError("rash")).not.toBeNull();
    expect(illustrationSceneError("a".repeat(801))).not.toBeNull();
  });
});

describe("illustrationPrompt", () => {
  it("embeds the scene and forbids text", () => {
    const p = illustrationPrompt("  erythema marginatum on the trunk ");
    expect(p).toContain("SIGN TO SHOW: erythema marginatum on the trunk");
    expect(p).toMatch(/no text/i);
  });
});
