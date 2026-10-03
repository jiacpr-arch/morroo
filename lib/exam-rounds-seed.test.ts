import { readFileSync } from "node:fs";
import { describe, expect, it } from "vitest";
import { NL_EXAM_ROUNDS } from "@/lib/exam-dates";

// migration seed ต้องตรงกับค่าสำรองในโค้ด ไม่งั้นปฏิทินเปลี่ยนเงียบๆ ตอนสลับระหว่าง DB/fallback
describe("exam_rounds seed", () => {
  const sql = readFileSync("supabase/migrations/20261005_exam_rounds.sql", "utf8");
  it("มีทุกรอบของ NL_EXAM_ROUNDS พร้อม kind/วัน/confirmed ตรงกัน", () => {
    for (const r of NL_EXAM_ROUNDS) {
      const line = sql.split("\n").find((l) => l.includes(`'${r.label.replace(/'/g, "''")}'`));
      expect(line, r.label).toBeTruthy();
      expect(line).toContain(`'${r.kind}'`);
      expect(line).toContain(`'${r.date}'`);
      expect(line).toMatch(r.confirmed ? /true/i : /false/i);
    }
  });
});
