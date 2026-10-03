import { describe, expect, it, vi } from "vitest";
import {
  MAX_ROUNDS_PER_SCAN,
  applyChangePlan,
  buildRoundAlertText,
  planHasChanges,
  planRoundChanges,
  validateExtractedRound,
  type ExistingRound,
  type ValidRound,
} from "./exam-round-extract";

const NOW = new Date("2026-10-03T03:00:00Z"); // 3 ต.ค. 2569 (ICT)

const good = (over: Record<string, unknown> = {}) => ({
  kind: "part1",
  label: "ส่วนที่ 1 รอบ 2/2570",
  date: "2026-10-10",
  thai_date_text: "วันเสาร์ที่ 10 ตุลาคม 2569",
  evidence: "สอบ วันเสาร์ที่ 10 ตุลาคม 2569",
  ...over,
});

describe("validateExtractedRound", () => {
  it("accepts a consistent round and normalises it", () => {
    const res = validateExtractedRound(good({ label: "  ส่วนที่ 1   รอบ 2/2570 " }), { now: NOW });
    expect(res).toEqual({
      ok: true,
      round: {
        kind: "part1",
        label: "ส่วนที่ 1 รอบ 2/2570",
        date: "2026-10-10",
        evidence: "สอบ วันเสาร์ที่ 10 ตุลาคม 2569",
      },
    });
  });

  it("rejects a Buddhist/Gregorian year slip (the most likely AI mistake)", () => {
    const res = validateExtractedRound(good({ date: "2027-10-10" }), { now: NOW });
    expect(res.ok).toBe(false);
    if (!res.ok) expect(res.reason).toContain("ไม่ตรงกับข้อความ");
  });

  it("rejects a weekday that does not match the date", () => {
    const res = validateExtractedRound(good({ thai_date_text: "วันอาทิตย์ที่ 10 ตุลาคม 2569" }), { now: NOW });
    expect(res).toMatchObject({ ok: false, reason: "ชื่อวันในประกาศไม่ตรงกับวันที่" });
  });

  it("rejects unknown kinds, missing labels, bad dates and unreadable date text", () => {
    expect(validateExtractedRound(good({ kind: "step9" }), { now: NOW }).ok).toBe(false);
    expect(validateExtractedRound(good({ label: "  " }), { now: NOW }).ok).toBe(false);
    expect(validateExtractedRound(good({ date: "2026-02-30" }), { now: NOW }).ok).toBe(false);
    expect(validateExtractedRound(good({ thai_date_text: "เร็วๆ นี้" }), { now: NOW }).ok).toBe(false);
    expect(validateExtractedRound(null, { now: NOW }).ok).toBe(false);
    expect(validateExtractedRound("x", { now: NOW }).ok).toBe(false);
  });

  it("rejects dates outside [today-30d, today+24 months]", () => {
    const old = validateExtractedRound(good({ date: "2026-08-01", thai_date_text: "วันเสาร์ที่ 1 สิงหาคม 2569" }), { now: NOW });
    expect(old).toMatchObject({ ok: false, reason: "วันที่อยู่นอกช่วงที่เป็นไปได้" });
    const far = validateExtractedRound(good({ date: "2029-01-13", thai_date_text: "วันเสาร์ที่ 13 มกราคม 2572" }), { now: NOW });
    expect(far).toMatchObject({ ok: false, reason: "วันที่อยู่นอกช่วงที่เป็นไปได้" });
    // วันที่เพิ่งผ่านไปไม่เกิน 30 วันยังรับ (ประกาศย้อนหลัง/ผลสอบ)
    const recent = validateExtractedRound(good({ date: "2026-09-12", thai_date_text: "วันเสาร์ที่ 12 กันยายน 2569" }), { now: NOW });
    expect(recent.ok).toBe(true);
  });

  it("requires the date text to appear in the source when the source text is known", () => {
    const text = "ประกาศ ศรว. สอบวันเสาร์ที่ ๑๐ ตุลาคม ๒๕๖๙ เวลา 09.00 น.";
    expect(validateExtractedRound(good(), { now: NOW, sourceText: text }).ok).toBe(true); // เลขไทยในแหล่งที่มาถูก normalise
    const missing = validateExtractedRound(good(), { now: NOW, sourceText: "ประกาศอื่นที่ไม่มีวันนั้น" });
    expect(missing).toMatchObject({ ok: false, reason: "ไม่พบข้อความวันที่นี้ในประกาศ" });
    // ไม่มี sourceText (PDF) = ข้ามขั้นนี้
    expect(validateExtractedRound(good(), { now: NOW, sourceText: null }).ok).toBe(true);
  });
});

const R = (over: Partial<ValidRound> = {}): ValidRound => ({
  kind: "part1",
  label: "ส่วนที่ 1 รอบ 2/2570",
  date: "2027-10-09",
  evidence: "e",
  ...over,
});
const E = (over: Partial<ExistingRound> = {}): ExistingRound => ({
  id: "r1",
  kind: "part1",
  label: "ส่วนที่ 1 รอบ 2/2570",
  exam_date: "2027-10-09",
  confirmed: false,
  locked: false,
  ...over,
});

describe("planRoundChanges", () => {
  it("inserts a new round", () => {
    const plan = planRoundChanges([], [R()]);
    expect(plan.inserts).toHaveLength(1);
    expect(planHasChanges(plan)).toBe(true);
  });

  it("confirms a predicted round when the announcement matches", () => {
    const plan = planRoundChanges([E()], [R()]);
    expect(plan.confirms).toEqual([{ id: "r1", round: R() }]);
    expect(plan.inserts).toHaveLength(0);
  });

  it("moves the date of an existing round and remembers the old one", () => {
    const plan = planRoundChanges([E({ confirmed: true })], [R({ date: "2027-10-16" })]);
    expect(plan.dateChanges).toEqual([{ id: "r1", round: R({ date: "2027-10-16" }), previous: "2027-10-09" }]);
  });

  it("never touches a locked round, but reports a conflicting date", () => {
    const same = planRoundChanges([E({ locked: true })], [R()]);
    expect(planHasChanges(same)).toBe(false);
    expect(same.noops).toBe(1);
    const conflict = planRoundChanges([E({ locked: true })], [R({ date: "2027-10-16" })]);
    expect(planHasChanges(conflict)).toBe(false);
    expect(conflict.lockedConflicts).toHaveLength(1);
  });

  it("treats a different label on an existing date as the same round", () => {
    const unconfirmed = planRoundChanges([E({ label: "ชื่ออื่น" })], [R()]);
    expect(unconfirmed.inserts).toHaveLength(0);
    expect(unconfirmed.confirms).toHaveLength(1);
    const confirmed = planRoundChanges([E({ label: "ชื่ออื่น", confirmed: true })], [R()]);
    expect(planHasChanges(confirmed)).toBe(false);
  });

  it("ignores duplicates inside one batch", () => {
    const plan = planRoundChanges([], [R(), R(), R({ label: "อีกชื่อ" })]);
    expect(plan.inserts).toHaveLength(1);
    expect(plan.noops).toBe(2);
  });

  it("applies nothing when the AI returns suspiciously many rounds", () => {
    const many = Array.from({ length: MAX_ROUNDS_PER_SCAN + 1 }, (_, i) =>
      R({ label: `รอบ ${i}`, date: `2027-0${(i % 9) + 1}-10` })
    );
    const plan = planRoundChanges([], many);
    expect(plan.suspicious).toBe(true);
    expect(planHasChanges(plan)).toBe(false);
  });
});

function fakeDb(opts: { insertError?: { code: string; message: string } | null } = {}) {
  const calls: { op: string; row?: Record<string, unknown>; eq: [string, unknown][] }[] = [];
  const db = {
    from: (table: string) => {
      if (table !== "exam_rounds") throw new Error(`unexpected ${table}`);
      return {
        insert: (row: Record<string, unknown>) => {
          calls.push({ op: "insert", row, eq: [] });
          return Promise.resolve({ error: opts.insertError ?? null });
        },
        update: (row: Record<string, unknown>) => {
          const call = { op: "update", row, eq: [] as [string, unknown][] };
          calls.push(call);
          const chain = {
            eq: (col: string, val: unknown) => {
              call.eq.push([col, val]);
              return call.eq.length >= 2 ? Promise.resolve({ error: null }) : chain;
            },
          };
          return chain;
        },
      };
    },
  };
  return { db, calls };
}

describe("applyChangePlan", () => {
  it("writes inserts, date changes and confirmations; updates are guarded by locked = false", async () => {
    const { db, calls } = fakeDb();
    const plan = planRoundChanges(
      [E({ id: "a", label: "รอบ A", exam_date: "2027-05-01", confirmed: true }), E({ id: "b", label: "รอบ B", exam_date: "2027-10-09" })],
      [
        R({ label: "รอบ A", date: "2027-05-08" }), // เลื่อนวัน
        R({ label: "รอบ B", date: "2027-10-09" }), // ยืนยัน
        R({ label: "รอบ C", date: "2027-11-06" }), // ใหม่
      ]
    );
    const res = await applyChangePlan(db as never, plan, "https://cmathai.org/news/detail/1");
    expect(res).toEqual({ inserted: 1, changed: 1, confirmed: 1, errors: [] });

    const insert = calls.find((c) => c.op === "insert")!;
    expect(insert.row).toMatchObject({ source: "auto", confirmed: true, is_active: true, locked: false, exam_date: "2027-11-06" });

    const updates = calls.filter((c) => c.op === "update");
    expect(updates).toHaveLength(2);
    for (const u of updates) expect(u.eq).toContainEqual(["locked", false]);
    expect(updates[0].row).toMatchObject({ exam_date: "2027-05-08", previous_date: "2027-05-01" });
  });

  it("treats a unique violation as already-applied and reports other errors", async () => {
    const dup = fakeDb({ insertError: { code: "23505", message: "dup" } });
    expect((await applyChangePlan(dup.db as never, planRoundChanges([], [R()]), "u")).errors).toEqual([]);
    const bad = fakeDb({ insertError: { code: "XX000", message: "boom" } });
    const res = await applyChangePlan(bad.db as never, planRoundChanges([], [R()]), "u");
    expect(res.inserted).toBe(0);
    expect(res.errors).toHaveLength(1);
  });
});

describe("buildRoundAlertText", () => {
  it("describes every kind of change, the skips and the source", () => {
    const plan = planRoundChanges(
      [E({ id: "a", label: "รอบ A", exam_date: "2027-05-01", confirmed: true }), E({ id: "l", label: "รอบ L", exam_date: "2027-03-06", locked: true, confirmed: true })],
      [R({ label: "รอบ A", date: "2027-05-08" }), R({ label: "รอบ N", date: "2027-11-06" }), R({ label: "รอบ L", date: "2027-03-13" })]
    );
    const text = buildRoundAlertText(plan, [{ label: "รอบ X", reason: "วันที่ไม่ถูกต้อง" }], ["https://cmathai.org/news/detail/9"]);
    expect(text).toContain("เพิ่ม: รอบ N");
    expect(text).toContain("เปลี่ยนวัน: รอบ A");
    expect(text).toContain("ที่คุณล็อกไว้");
    expect(text).toContain('ข้ามรอบ "รอบ X": วันที่ไม่ถูกต้อง');
    expect(text).toContain("https://cmathai.org/news/detail/9");
    expect(text).toContain("/admin/exam-dates");
  });

  it("flags a suspicious batch", () => {
    const many = Array.from({ length: 7 }, (_, i) => R({ label: `รอบ ${i}`, date: `2027-0${(i % 9) + 1}-10` }));
    expect(buildRoundAlertText(planRoundChanges([], many), [], [])).toContain("มากผิดปกติ");
  });
});

vi.restoreAllMocks();
