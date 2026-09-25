import { describe, it, expect } from "vitest";
import fs from "node:fs";
import path from "node:path";
import { CRON_JOBS, maxIntervalMinutes, staleAfterMinutes } from "./cron-jobs";

const root = path.resolve(__dirname, "..");
const vercel = JSON.parse(fs.readFileSync(path.join(root, "vercel.json"), "utf8")) as {
  crons: { path: string; schedule: string }[];
};

describe("CRON_JOBS registry", () => {
  it("matches vercel.json exactly (paths + schedules)", () => {
    const fromVercel = vercel.crons.map((c) => `${c.path} ${c.schedule}`).sort();
    const fromRegistry = CRON_JOBS.map((j) => `${j.path} ${j.schedule}`).sort();
    expect(fromRegistry).toEqual(fromVercel);
  });

  it("has unique job names", () => {
    expect(new Set(CRON_JOBS.map((j) => j.job)).size).toBe(CRON_JOBS.length);
  });

  it.each(CRON_JOBS.map((j) => [j.job, j.path] as const))(
    "%s route is wrapped with withCronRun under its job name",
    (job, routePath) => {
      const file = path.join(root, "app", routePath, "route.ts");
      const src = fs.readFileSync(file, "utf8");
      expect(src).toContain(`withCronRun("${job}"`);
    }
  );
});

describe("maxIntervalMinutes", () => {
  it.each([
    ["* * * * *", 1],
    ["*/15 * * * *", 15],
    ["0 12 * * *", 1440],
    ["30 0 * * *", 1440],
    ["0 1 * * 1", 10080],
    ["0 5 * * 3", 10080],
    ["0 2 * * 1,3,5", 3 * 1440], // Fri → Mon
    ["0 9-17/4 * * *", 1440 - 8 * 60], // 9, 13, 17 → 17 → 9 next day
  ])("%s → %i min", (schedule, expected) => {
    expect(maxIntervalMinutes(schedule)).toBe(expected);
  });

  it("rejects unsupported expressions", () => {
    expect(() => maxIntervalMinutes("0 0 1 * *")).toThrow();
    expect(() => maxIntervalMinutes("bad")).toThrow();
  });

  it("adds at least 10 minutes of slack", () => {
    expect(staleAfterMinutes("* * * * *")).toBe(11);
    expect(staleAfterMinutes("0 12 * * *")).toBe(1800);
  });
});
