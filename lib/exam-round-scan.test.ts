import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

const extract = vi.fn();
vi.mock("@/lib/exam-round-ai", () => ({
  extractRoundsFromSource: (...a: unknown[]) => extract(...a),
}));
const sendLine = vi.fn(async () => true);
vi.mock("@/lib/line", () => ({ sendLineMessage: (...a: unknown[]) => sendLine(...(a as [])) }));

import { SCANNED_URLS_SETTINGS_KEY, scanExamAnnouncements } from "./exam-round-scan";

const NOW = new Date("2026-10-03T03:00:00Z");

interface DbState {
  scanned: string[];
  rounds: Record<string, unknown>[];
  roundsError: boolean;
  inserted: Record<string, unknown>[];
  upserts: Record<string, unknown>[];
}
let state: DbState;

function makeDb() {
  return {
    from: (table: string) => {
      if (table === "app_settings") {
        return {
          select: () => ({
            eq: () => ({
              maybeSingle: () => Promise.resolve({ data: { value: JSON.stringify(state.scanned) } }),
            }),
          }),
          upsert: (row: Record<string, unknown>) => {
            state.upserts.push(row);
            return Promise.resolve({ error: null });
          },
        };
      }
      if (table === "exam_rounds") {
        return {
          select: () =>
            Promise.resolve(
              state.roundsError ? { data: null, error: { message: "relation does not exist" } } : { data: state.rounds, error: null }
            ),
          insert: (row: Record<string, unknown>) => {
            state.inserted.push(row);
            return Promise.resolve({ error: null });
          },
          update: () => ({ eq: () => ({ eq: () => Promise.resolve({ error: null }) }) }),
        };
      }
      throw new Error(`unexpected table ${table}`);
    },
  };
}

const LIST_HTML = `<a href="/news/detail/971">ประกาศกำหนดการสอบส่วนที่ 1 ปี 2570</a>
<a href="/news/detail/970">ประกาศสอบ OSCE รอบ 1/2570</a>`;
const BODY =
  "ศูนย์ประเมินและรับรองความรู้ความสามารถฯ ประกาศกำหนดการสอบ ส่วนที่ 1 ครั้งที่ 2 ปี 2570 สอบวันเสาร์ที่ 9 ตุลาคม 2570 ณ ศูนย์สอบทั่วประเทศ ผู้สมัครต้องตรวจสอบรายละเอียดในไฟล์แนบอีกครั้ง รายละเอียดเพิ่มเติม";
const DETAIL_HTML = `<html><body><h1>ประกาศ</h1><p>${BODY}</p><a href="/news_attach/a.pdf">ไฟล์แนบ</a></body></html>`;

const goodRound = {
  kind: "part1",
  label: "ส่วนที่ 1 รอบ 2/2570",
  date: "2027-10-09",
  thai_date_text: "วันเสาร์ที่ 9 ตุลาคม 2570",
  evidence: "สอบวันเสาร์ที่ 9 ตุลาคม 2570",
};

type Route = { ok?: boolean; status?: number; body?: string | ArrayBuffer; url?: string };
function mockNetwork(routes: Record<string, Route>) {
  vi.stubGlobal(
    "fetch",
    vi.fn(async (input: string) => {
      const r = routes[input];
      if (!r) return { ok: false, status: 404, url: input } as unknown as Response;
      return {
        ok: r.ok ?? true,
        status: r.status ?? 200,
        url: r.url ?? input,
        text: async () => (typeof r.body === "string" ? r.body : ""),
        arrayBuffer: async () => (r.body instanceof ArrayBuffer ? r.body : new ArrayBuffer(0)),
      } as unknown as Response;
    })
  );
}

const NEWS = "https://cmathai.org/news";
const D971 = "https://cmathai.org/news/detail/971";
const D970 = "https://cmathai.org/news/detail/970";
const PDF = "https://cmathai.org/news_attach/a.pdf";

beforeEach(() => {
  state = { scanned: [], rounds: [], roundsError: false, inserted: [], upserts: [] };
  extract.mockReset().mockResolvedValue({ rounds: [] });
  sendLine.mockClear();
  vi.spyOn(console, "error").mockImplementation(() => {});
  process.env.ADMIN_LINE_USER_ID = "Uadmin";
});
afterEach(() => {
  vi.unstubAllGlobals();
  vi.restoreAllMocks();
});

const run = (opts = {}) => scanExamAnnouncements(makeDb() as never, { now: NOW, maxPages: 1, ...opts });

describe("scanExamAnnouncements", () => {
  it("reads the announcement, validates the round, adds it and alerts the admin", async () => {
    mockNetwork({ [NEWS]: { body: LIST_HTML }, [D971]: { body: DETAIL_HTML }, [PDF]: { body: new ArrayBuffer(10) } });
    extract.mockImplementation(async (src: { text: string | null }) => ({ rounds: src.text ? [goodRound] : [] }));

    const report = await run();
    expect(report).toMatchObject({ listFetched: true, linksFound: 2 });
    expect(report.pages[0]).toMatchObject({ url: D971, fetched: true, accepted: ["ส่วนที่ 1 รอบ 2/2570"] });
    expect(state.inserted).toHaveLength(1);
    expect(state.inserted[0]).toMatchObject({
      kind: "part1",
      exam_date: "2027-10-09",
      source: "auto",
      source_url: D971,
      confirmed: true,
    });
    expect(sendLine).toHaveBeenCalledTimes(1);
    expect((sendLine.mock.calls[0] as unknown as [string, { text: string }[]])[1][0].text).toContain("เพิ่ม: ส่วนที่ 1 รอบ 2/2570");
    // marked as read
    const saved = JSON.parse(state.upserts[0].value as string) as string[];
    expect(saved).toContain(D971);
    expect(state.upserts[0].key).toBe(SCANNED_URLS_SETTINGS_KEY);
  });

  it("rejects a round whose year does not match the announcement text and tells the admin", async () => {
    mockNetwork({ [NEWS]: { body: LIST_HTML }, [D971]: { body: DETAIL_HTML } });
    // AI ตอบวันที่ปี 2027 แต่ข้อความในประกาศเขียน พ.ศ. 2569 (= 2026) — ปีคลาดในช่วงที่เป็นไปได้
    extract.mockResolvedValue({
      rounds: [{ ...goodRound, thai_date_text: "วันศุกร์ที่ 9 ตุลาคม 2569" }],
    });
    const report = await run();
    expect(state.inserted).toHaveLength(0);
    expect(report.pages[0].rejected[0].reason).toContain("ไม่ตรงกับข้อความ");
    expect((sendLine.mock.calls[0] as unknown as [string, { text: string }[]])[1][0].text).toContain("ข้ามรอบ");
  });

  it("rejects a date that does not appear in the page text", async () => {
    mockNetwork({ [NEWS]: { body: LIST_HTML }, [D971]: { body: DETAIL_HTML } });
    extract.mockResolvedValue({
      rounds: [{ ...goodRound, date: "2027-11-06", thai_date_text: "วันเสาร์ที่ 6 พฤศจิกายน 2570" }],
    });
    const report = await run();
    expect(state.inserted).toHaveLength(0);
    expect(report.pages[0].rejected[0].reason).toBe("ไม่พบข้อความวันที่นี้ในประกาศ");
  });

  it("accepts a round read from a PDF (no source text to cross-check)", async () => {
    mockNetwork({ [NEWS]: { body: LIST_HTML }, [D971]: { body: `<a href="/news_attach/a.pdf">x</a>` }, [PDF]: { body: new ArrayBuffer(10) } });
    extract.mockResolvedValue({ rounds: [goodRound] });
    const report = await run();
    expect(report.pages[0].pdfs).toEqual([{ url: PDF, ok: true, bytes: 10 }]);
    expect(state.inserted).toHaveLength(1);
    // text page was too short to send, so only the PDF source was read
    expect(extract).toHaveBeenCalledTimes(1);
    expect((extract.mock.calls[0][0] as { pdfBase64: string | null }).pdfBase64).toBeTruthy();
  });

  it("skips PDFs over 5 MB and reports it", async () => {
    mockNetwork({
      [NEWS]: { body: LIST_HTML },
      [D971]: { body: DETAIL_HTML },
      [PDF]: { body: new ArrayBuffer(6 * 1024 * 1024) },
    });
    const report = await run();
    expect(report.pages[0].pdfs[0]).toMatchObject({ ok: false });
    expect(report.pages[0].pdfs[0].error).toContain("ใหญ่เกิน");
  });

  it("does not re-read announcements it already scanned, unless forced", async () => {
    state.scanned = [D971];
    mockNetwork({ [NEWS]: { body: LIST_HTML }, [D970]: { body: DETAIL_HTML }, [D971]: { body: DETAIL_HTML } });
    const normal = await run();
    expect(normal.pages.map((p) => p.url)).toEqual([D970]);
    expect(normal.alreadyScanned).toBe(1);

    extract.mockClear();
    const forced = await run({ force: true });
    expect(forced.pages.map((p) => p.url)).toEqual([D971]);
  });

  it("leaves the announcement unread when the AI call fails, so it is retried", async () => {
    mockNetwork({ [NEWS]: { body: LIST_HTML }, [D971]: { body: DETAIL_HTML } });
    extract.mockResolvedValue({ rounds: [], error: "overloaded" });
    const report = await run();
    expect(report.pages[0].aiErrors).toEqual(["overloaded"]);
    const saved = JSON.parse(state.upserts[0].value as string) as string[];
    expect(saved).not.toContain(D971);
  });

  it("reports a failed list fetch without touching anything", async () => {
    mockNetwork({ [NEWS]: { ok: false, status: 503 } });
    const report = await run();
    expect(report).toMatchObject({ listFetched: false, listError: "HTTP 503", pages: [] });
    expect(state.upserts).toHaveLength(0);
    expect(sendLine).not.toHaveBeenCalled();
  });

  it("refuses a redirect that leaves the CMA host", async () => {
    mockNetwork({ [NEWS]: { body: LIST_HTML }, [D971]: { body: DETAIL_HTML, url: "https://evil.example.com/x" } });
    const report = await run();
    expect(report.pages[0]).toMatchObject({ fetched: false, error: "redirect ออกนอก host ที่อนุญาต" });
    expect(extract).not.toHaveBeenCalled();
  });

  it("stops without marking anything when exam_rounds is unavailable", async () => {
    state.roundsError = true;
    mockNetwork({ [NEWS]: { body: LIST_HTML }, [D971]: { body: DETAIL_HTML } });
    const report = await run();
    expect(report.pages[0].error).toContain("exam_rounds");
    expect(state.upserts).toHaveLength(0);
  });

  it("does not message the admin when alert is off (manual scan shows the report instead)", async () => {
    mockNetwork({ [NEWS]: { body: LIST_HTML }, [D971]: { body: DETAIL_HTML } });
    extract.mockResolvedValue({ rounds: [goodRound] });
    await run({ alert: false });
    expect(state.inserted).toHaveLength(1);
    expect(sendLine).not.toHaveBeenCalled();
  });

  it("stays quiet when nothing changed and nothing was rejected", async () => {
    mockNetwork({ [NEWS]: { body: LIST_HTML }, [D971]: { body: DETAIL_HTML } });
    extract.mockResolvedValue({ rounds: [] });
    await run();
    expect(sendLine).not.toHaveBeenCalled();
  });
});
