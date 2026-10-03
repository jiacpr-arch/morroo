import { beforeEach, describe, expect, it, vi } from "vitest";

vi.mock("./daily-mcq-line", async (importActual) => {
  const actual = await importActual<typeof import("./daily-mcq-line")>();
  return { ...actual, loadDailyQuestion: vi.fn() };
});

import { loadDailyQuestion } from "./daily-mcq-line";
import { COLS, ROWS, buildRichMenu, handleMenuPostback, isTodayText } from "./line-menu";

const QUESTION = {
  id: "q1",
  subject_id: "s1",
  exam_type: "NL2",
  scenario: "ผู้ป่วยหญิงอายุ 30 ปี",
  choices: ["A", "B", "C", "D", "E"].map((label) => ({ label, text: `ตัวเลือก ${label}` })),
  correct_answer: "B",
  explanation: "",
  difficulty: "medium",
  status: "active",
  audience: "student",
  mcq_subjects: { name: "med", name_th: "อายุรกรรม", icon: "🩺" },
  quiz_date: "2026-10-03",
};

function fakeSupabase(
  profile: { id: string; target_exam: string | null; board_specialty?: string | null } | null
) {
  return {
    from(table: string) {
      if (table !== "profiles") throw new Error(`unexpected table ${table}`);
      return {
        select: () => ({ eq: () => ({ limit: () => Promise.resolve({ data: profile ? [profile] : [] }) }) }),
      };
    },
  };
}

const load = vi.mocked(loadDailyQuestion);

function answerData(reply: unknown): string[] {
  return JSON.stringify(reply).match(/action=daily_answer[^"]*/g) ?? [];
}

beforeEach(() => {
  load.mockReset();
});

describe("buildRichMenu", () => {
  const menu = buildRichMenu();

  it("uses the shared 2500×1686 grid and LINE's limits", () => {
    expect(menu.size).toEqual({ width: 2500, height: 1686 });
    expect(menu.areas.length).toBe(9);
    expect(menu.areas.length).toBeLessThanOrEqual(20);
    expect((menu.chatBarText as string).length).toBeLessThanOrEqual(14);
    expect(COLS).toEqual([0, 840, 1662, 2500]);
    expect(ROWS).toEqual([0, 620, 1223, 1686]);
  });

  it("tiles the whole image without overlap", () => {
    const total = menu.areas.reduce((s, a) => s + a.bounds.width * a.bounds.height, 0);
    expect(total).toBe(2500 * 1686);
    for (const a of menu.areas) {
      expect(a.bounds.x + a.bounds.width).toBeLessThanOrEqual(2500);
      expect(a.bounds.y + a.bounds.height).toBeLessThanOrEqual(1686);
    }
  });

  it("wires postbacks to the handlers and links over https", () => {
    const postbacks = menu.areas
      .map((a) => a.action)
      .filter((a) => a.type === "postback")
      .map((a) => a.data);
    expect(postbacks).toEqual(["action=menu_today", "action=level_menu"]);
    for (const a of menu.areas.map((x) => x.action).filter((a) => a.type === "uri")) {
      expect(String(a.uri)).toMatch(/^https:\/\//);
    }
  });
});

describe("handleMenuPostback", () => {
  it("ignores other actions", async () => {
    expect(await handleMenuPostback(fakeSupabase(null) as never, "U1", "action=level_menu")).toBeNull();
    expect(load).not.toHaveBeenCalled();
  });

  it("sends the level's pool card to a linked user", async () => {
    load.mockResolvedValue(QUESTION as never);
    const reply = await handleMenuPostback(
      fakeSupabase({ id: "u1", target_exam: "NL2" }) as never,
      "U1",
      "action=menu_today"
    );
    expect(load).toHaveBeenCalledWith(expect.anything(), expect.any(String), "NL2", null);
    const data = answerData(reply);
    expect(data).toHaveLength(5);
    for (const d of data) expect(d).toMatch(/&p=NL2$/);
    expect((reply?.[0] as { quickReply?: unknown }).quickReply).toBeUndefined();
  });

  it("sends the mixed card to an unlinked user", async () => {
    load.mockResolvedValue(QUESTION as never);
    const reply = await handleMenuPostback(fakeSupabase(null) as never, "U1", "action=menu_today");
    expect(load).toHaveBeenCalledTimes(1);
    expect(load.mock.calls[0]).toHaveLength(2); // no pool
    for (const d of answerData(reply)) expect(d).not.toContain("&p=");
  });

  it("falls back to the mixed card when the pool is empty", async () => {
    load.mockImplementation(async (_s, _d, pool) => (pool ? null : (QUESTION as never)));
    const reply = await handleMenuPostback(
      fakeSupabase({ id: "u1", target_exam: "part2" }) as never,
      "U1",
      "action=menu_today"
    );
    expect(load).toHaveBeenCalledTimes(2);
    for (const d of answerData(reply)) expect(d).not.toContain("&p=");
  });

  it("nudges a linked user still on a pre-2570 level to pick one", async () => {
    load.mockResolvedValue(QUESTION as never);
    const reply = await handleMenuPostback(
      fakeSupabase({ id: "u1", target_exam: "NL1" }) as never,
      "U1",
      "action=menu_today"
    );
    expect(JSON.stringify((reply?.[0] as { quickReply?: unknown }).quickReply)).toContain("action=level_menu");
  });

  it("explains when there is no question at all", async () => {
    load.mockResolvedValue(null);
    const reply = await handleMenuPostback(fakeSupabase(null) as never, "U1", "action=menu_today");
    expect((reply?.[0] as { text: string }).text).toContain("ยังไม่มีข้อสอบ");
  });
});

describe("board users", () => {
  it("gets today's card from their specialty, linked to that specialty's practice page", async () => {
    load.mockResolvedValue({ ...QUESTION, audience: "board", board_specialty: "surgery", exam_type: null } as never);
    const reply = await handleMenuPostback(
      fakeSupabase({ id: "u1", target_exam: "board", board_specialty: "surgery" }) as never,
      "U1",
      "action=menu_today"
    );
    expect(load).toHaveBeenCalledWith(expect.anything(), expect.any(String), "board", "surgery");
    const json = JSON.stringify(reply);
    for (const d of json.match(/action=daily_answer[^"]*/g) ?? []) expect(d).toMatch(/&p=board&s=surgery$/);
    expect(json).toContain("/board/surgery/practice");
    expect(json).toContain("Board"); // header shows Board, not NL2
    expect((reply?.[0] as { quickReply?: unknown }).quickReply).toBeUndefined();
  });

  it("falls back to the mixed card when the specialty has no question", async () => {
    load.mockImplementation(async (_s, _d, pool) => (pool ? null : (QUESTION as never)));
    const reply = await handleMenuPostback(
      fakeSupabase({ id: "u1", target_exam: "board", board_specialty: "radiology" }) as never,
      "U1",
      "action=menu_today"
    );
    expect(load).toHaveBeenCalledTimes(2);
    expect(JSON.stringify(reply)).not.toContain("&s=");
    expect(JSON.stringify(reply)).not.toContain("/board/");
  });

  it("asks a board user without a specialty to pick one", async () => {
    load.mockResolvedValue(QUESTION as never);
    const reply = await handleMenuPostback(
      fakeSupabase({ id: "u1", target_exam: "board", board_specialty: null }) as never,
      "U1",
      "action=menu_today"
    );
    expect(load).toHaveBeenCalledTimes(1); // no specialty → mixed card, no pool lookup
    expect(JSON.stringify((reply?.[0] as { quickReply?: unknown }).quickReply)).toContain("action=level_menu");
  });
});

describe("isTodayText", () => {
  it("matches the exact words only", () => {
    expect(isTodayText(" ข้อสอบวันนี้ ")).toBe(true);
    expect(isTodayText("ข้อสอบ")).toBe(true);
    expect(isTodayText("ข้อสอบ NL2 ออกอะไรบ้าง")).toBe(false);
  });
});
