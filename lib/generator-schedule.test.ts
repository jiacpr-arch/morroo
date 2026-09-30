import { describe, it, expect } from "vitest";
import fs from "node:fs";
import path from "node:path";
import { DISPATCH_CRON, GENERATOR_SLOTS, dueWorkflows } from "./generator-schedule";

const at = (iso: string) => new Date(iso);

describe("dueWorkflows", () => {
  it("dispatches the daily generators at their slots", () => {
    expect(dueWorkflows(at("2026-09-30T05:00:00Z"))).toEqual(["generate-blog.yml"]);
    expect(dueWorkflows(at("2026-09-30T19:00:00Z"))).toEqual(["generate-mcq.yml"]);
    expect(dueWorkflows(at("2026-09-30T19:30:00Z"))).toEqual(["generate-board.yml"]);
  });

  it("adds the weekly jobs only on their days", () => {
    // 2026-09-30 is a Wednesday
    expect(dueWorkflows(at("2026-09-30T20:00:00Z"))).toEqual([
      "generate-board-oral.yml",
      "generate-meq.yml",
    ]);
    expect(dueWorkflows(at("2026-09-30T20:30:00Z"))).toEqual(["generate-meq-games.yml"]);
    // Thursday: no MEQ
    expect(dueWorkflows(at("2026-10-01T20:00:00Z"))).toEqual(["generate-board-oral.yml"]);
    expect(dueWorkflows(at("2026-10-01T20:30:00Z"))).toEqual([]);
    // Saturday long case
    expect(dueWorkflows(at("2026-10-03T21:00:00Z"))).toEqual(["generate-longcase.yml"]);
    expect(dueWorkflows(at("2026-10-02T21:00:00Z"))).toEqual([]);
  });

  it("tolerates a late cron within the same half hour", () => {
    expect(dueWorkflows(at("2026-09-30T19:04:00Z"))).toEqual(["generate-mcq.yml"]);
    expect(dueWorkflows(at("2026-09-30T19:33:00Z"))).toEqual(["generate-board.yml"]);
  });

  it("returns nothing outside the slots", () => {
    expect(dueWorkflows(at("2026-09-30T12:00:00Z"))).toEqual([]);
  });
});

describe("DISPATCH_CRON", () => {
  it("fires at every slot time", () => {
    const [minF, hourF] = DISPATCH_CRON.split(" ");
    const minutes = minF.split(",");
    const hours = new Set<string>();
    for (const part of hourF.split(",")) {
      const [a, b] = part.split("-").map(Number);
      for (let h = a; h <= (b ?? a); h++) hours.add(String(h));
    }
    for (const s of GENERATOR_SLOTS) {
      const [h, m] = s.time.split(":");
      expect(hours.has(String(Number(h)))).toBe(true);
      expect(minutes).toContain(String(Number(m)));
    }
  });

  it("every slot workflow exists and has no GitHub schedule of its own", () => {
    const dir = path.resolve(__dirname, "..", ".github", "workflows");
    for (const s of GENERATOR_SLOTS) {
      const src = fs.readFileSync(path.join(dir, s.workflow), "utf8");
      expect(src).toContain("workflow_dispatch");
      // A GitHub `schedule:` trigger would double-run if GitHub cron resumed.
      expect(src).not.toMatch(/^\s*schedule:/m);
    }
  });
});
