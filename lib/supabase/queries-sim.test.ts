import { describe, it, expect, vi, beforeEach, afterEach } from "vitest";

// เกม long case ที่ AI แปลงเก็บใน sim_scenarios ถูกปิด (SERVE_AI_LONGCASE_GAMES)
// — ทุก long case ต้องเล่นผ่านเวอร์ชันสังเคราะห์ lc-<caseId> ที่ได้รูปแบบถาม-ตอบ
// ทีละขั้นล่าสุด ส่วน MEQ (ไม่มีเวอร์ชันสังเคราะห์) ต้องยังอยู่ครบ

const CASE_ID = "0f4e2a9c-3b7d-4c1e-9a55-2d6f8e1b7c30";

const AI_LONGCASE_ROW = {
  slug: "lc-scrotal-pain-01",
  title: "LONG CASE: ปวดอัณฑะ",
  subtitle: "",
  difficulty_tag: "basic",
  category: "longcase",
  source_case_id: CASE_ID,
  bg: null,
  story: [{ say: { who: "att_dech", pose: "talk", text: "เวอร์ชัน AI เดิม" } }, { end: true }],
};
const LONG_EXPLAIN = Array.from({ length: 10 }, (_, i) => `เหตุผลข้อ ${i + 1} ของการวินิจฉัยนี้`).join(" ");
const MEQ_ROW = {
  slug: "meq-fever-01",
  title: "MEQ: ไข้",
  subtitle: "",
  difficulty_tag: "basic",
  category: "meq",
  source_case_id: null,
  bg: null,
  story: [
    { say: { who: "att_dech", pose: "talk", text: "MEQ" } },
    {
      choice: {
        q: "วินิจฉัย",
        options: [
          { tgt: "DX", label: "Dengue", ok: true, then: [{ say: { who: "att_dech", pose: "talk", text: `ถูกต้อง — ${LONG_EXPLAIN}` } }] },
          { tgt: "DX", label: "Flu", ok: false },
        ],
      },
    },
    { inter: "เคสสำเร็จ!!", green: true },
    { end: true },
  ],
};
const LONG_CASE = {
  id: CASE_ID,
  title: "ชาย 19 ปี ปวดอัณฑะ",
  specialty: "Surgery",
  difficulty: "hard",
  audience: "student",
  is_weekly: false,
  is_published: true,
  patient_info: { age: 19, gender: "ชาย" },
  history_script: { cc: "ปวดอัณฑะ", pi: "ปวดมาก 3 ชม.", pmh: "ไม่มี" },
  pe_findings: {},
  lab_results: {},
  imaging_results: null,
  correct_diagnosis: "Testicular torsion",
  accepted_ddx: ["Testicular torsion", "Epididymitis"],
  management_plan: "Surgery; Orchiopexy",
  teaching_points: [],
  examiner_questions: [],
  scoring_rubric: {},
};

/** query builder จำลอง — ทุกเมธอดคืนตัวเอง, await ได้, ตอบตามตาราง + ชนิดคำสั่ง */
function builder(table: string) {
  const state = { single: false, slug: "" };
  const result = () => {
    if (table === "sim_scenarios") {
      const rows = [AI_LONGCASE_ROW, MEQ_ROW];
      if (state.single) return { data: rows.find((r) => r.slug === state.slug) ?? null, error: null };
      return { data: rows, error: null };
    }
    if (table === "long_cases") {
      return { data: state.single ? LONG_CASE : [LONG_CASE], error: null };
    }
    return { data: null, error: null };
  };
  const chain: Record<string, unknown> = {};
  for (const m of ["select", "order", "not", "neq", "limit", "in"]) chain[m] = vi.fn(() => chain);
  chain.eq = vi.fn((col: string, val: unknown) => {
    if (col === "slug") state.slug = String(val);
    return chain;
  });
  chain.maybeSingle = vi.fn(() => {
    state.single = true;
    return Promise.resolve(result());
  });
  chain.single = chain.maybeSingle;
  chain.then = (resolve: (v: unknown) => unknown, reject: (e: unknown) => unknown) =>
    Promise.resolve(result()).then(resolve, reject);
  return chain;
}

const from = vi.fn((table: string) => builder(table));

vi.mock("./server", () => ({ createClient: vi.fn(async () => ({ from })) }));
vi.mock("./admin", () => ({ createAdminClient: vi.fn(() => ({ from })) }));

const {
  getSimScenarios,
  getSimScenario,
  getPolishedLongcaseCards,
  getLongcaseGameCards,
  getLongcaseGameMap,
  simFlags,
} = await import("./queries-sim");

const DEFAULT_SERVE_AI = simFlags.serveAiLongcaseGames;
afterEach(() => {
  simFlags.serveAiLongcaseGames = DEFAULT_SERVE_AI;
});

beforeEach(() => {
  from.mockClear();
});

describe("AI long-case games are replaced by the synthesized step-by-step version", () => {
  beforeEach(() => {
    simFlags.serveAiLongcaseGames = false;
  });

  it("drops AI long-case rows from the scenario list but keeps MEQ", async () => {
    const slugs = (await getSimScenarios()).map((s) => s.slug);
    expect(slugs).not.toContain(AI_LONGCASE_ROW.slug);
    expect(slugs).toContain(MEQ_ROW.slug);
  });

  it("stops listing AI long-case cards", async () => {
    expect(await getPolishedLongcaseCards()).toEqual([]);
  });

  it("lists the case as a synthesized lc-<id> card instead", async () => {
    const cards = await getLongcaseGameCards();
    expect(cards.map((c) => c.slug)).toContain(`lc-${CASE_ID}`);
  });

  it("serves an old AI slug with the synthesized game of its source case", async () => {
    const s = await getSimScenario(AI_LONGCASE_ROW.slug);
    expect(s?.slug).toBe(`lc-${CASE_ID}`);
    expect(s?.story.some((n) => "choice" in n)).toBe(true);
  });

  it("still serves MEQ games from the table", async () => {
    expect((await getSimScenario(MEQ_ROW.slug))?.slug).toBe(MEQ_ROW.slug);
  });

  it("links every published long case to its synthesized game", async () => {
    expect((await getLongcaseGameMap())[CASE_ID]).toBe(`lc-${CASE_ID}`);
  });
});

describe("with AI long-case games switched back on", () => {
  beforeEach(() => {
    simFlags.serveAiLongcaseGames = true;
  });

  it("lists AI long-case rows alongside MEQ", async () => {
    const slugs = (await getSimScenarios()).map((s) => s.slug);
    expect(slugs).toContain(AI_LONGCASE_ROW.slug);
    expect(slugs).toContain(MEQ_ROW.slug);
  });

  it("serves the AI slug as-is", async () => {
    expect((await getSimScenario(AI_LONGCASE_ROW.slug))?.slug).toBe(AI_LONGCASE_ROW.slug);
  });

  it("doesn't also synthesize a card for a case the AI game already covers", async () => {
    const cards = await getLongcaseGameCards();
    expect(cards.map((c) => c.slug)).not.toContain(`lc-${CASE_ID}`);
  });

  it("links the long case to its AI game", async () => {
    expect((await getLongcaseGameMap())[CASE_ID]).toBe(AI_LONGCASE_ROW.slug);
  });

  it("serves stored MEQ games as short reads: no lecture after the diagnosis, long lines split, no 'ถูกต้อง —'", async () => {
    const s = await getSimScenario(MEQ_ROW.slug);
    expect(s).not.toBeNull();
    const story = s!.story;
    const dx = story.find((n) => "choice" in n);
    expect(dx && "choice" in dx && dx.choice.options[0].then).toEqual([]);
    const says = story.flatMap((n) => ("say" in n ? [n.say.text] : []));
    const moved = says.filter((t) => t.includes("เหตุผลข้อ"));
    expect(moved.length).toBeGreaterThan(1);
    for (const t of says) {
      expect(t.length).toBeLessThanOrEqual(110);
      expect(t.startsWith("ถูกต้อง")).toBe(false);
    }
    // ท่อนที่ย้ายมาอยู่ก่อนฉากปิด
    const closeIdx = story.findIndex((n) => "inter" in n);
    const lastMovedIdx = story.findLastIndex((n) => "say" in n && n.say.text.includes("เหตุผลข้อ"));
    expect(lastMovedIdx).toBeLessThan(closeIdx);
  });
});
