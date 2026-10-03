import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

const inserted: Record<string, unknown>[] = [];
let existingRefs = new Set<string>();
let insertError: { code: string } | null = null;

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: () => ({
    from: (table: string) => {
      if (table !== "news_items") throw new Error(`unexpected table ${table}`);
      return {
        select: () => ({
          in: (_col: string, refs: string[]) =>
            Promise.resolve({
              data: refs.filter((r) => existingRefs.has(r)).map((r) => ({ external_ref: r })),
            }),
        }),
        insert: (row: Record<string, unknown>) => {
          if (!insertError) inserted.push(row);
          return Promise.resolve({ error: insertError });
        },
      };
    },
  }),
}));

const sendLineMessage = vi.fn(async () => true);
vi.mock("@/lib/line", () => ({ sendLineMessage: (...a: unknown[]) => sendLineMessage(...(a as [])) }));

const summarize = vi.fn();
vi.mock("@/lib/exam-news-ai", async (importActual) => {
  const actual = await importActual<typeof import("./exam-news-ai")>();
  return { ...actual, summarizeExamNews: (...a: unknown[]) => summarize(...a) };
});

import { buildAdminAlertText, runExamNewsFetch } from "./exam-news-fetch";

function item(n: number, opts: { title?: string; ageDays?: number; guid?: string } = {}) {
  const date = new Date(Date.now() - (opts.ageDays ?? 1) * 86_400_000).toUTCString();
  return `<item><title>${opts.title ?? `ศรว. ประกาศข่าว ${n}`}</title>
    <link>https://news.example.org/a/${n}</link><guid>${opts.guid ?? `g${n}`}</guid>
    <pubDate>${date}</pubDate><description>รายละเอียดสอบ NL ข่าวที่ ${n}</description>
    <source url="https://x.test">สำนักข่าว</source></item>`;
}
const rss = (...items: string[]) => `<rss><channel>${items.join("")}</channel></rss>`;

function mockFeeds(xml: string | (() => Response)) {
  vi.stubGlobal(
    "fetch",
    vi.fn(async () => (typeof xml === "string" ? new Response(xml) : xml()))
  );
}

const good = (over = {}) => ({
  relevant: true,
  title: "หัวข้อสรุป",
  summary: "สรุป",
  country: "th" as const,
  exam_schedule: false,
  section: "nl" as const,
  ...over,
});

beforeEach(() => {
  inserted.length = 0;
  existingRefs = new Set();
  insertError = null;
  summarize.mockReset();
  sendLineMessage.mockClear();
  vi.spyOn(console, "error").mockImplementation(() => {});
  process.env.ADMIN_LINE_USER_ID = "Uadmin";
});
afterEach(() => {
  vi.unstubAllGlobals();
  vi.restoreAllMocks();
});

describe("runExamNewsFetch", () => {
  it("publishes relevant Thai news as an auto, active, exam item", async () => {
    mockFeeds(rss(item(1)));
    summarize.mockResolvedValue(good({ exam_schedule: true }));
    const res = await runExamNewsFetch();
    expect(res).toMatchObject({ added: 1, skipped: 0, examScheduleAdded: 1 });
    expect(inserted).toHaveLength(1);
    expect(inserted[0]).toMatchObject({
      source_type: "exam",
      source_section: "nl",
      origin: "auto",
      is_active: true,
      exam_schedule: true,
      external_ref: "auto:g1",
      source_name: "สำนักข่าว",
      link: "https://news.example.org/a/1",
    });
    expect(inserted[0].reviewed_at).toBeTruthy();
  });

  it("stores irrelevant or foreign news hidden (and never counts it as added)", async () => {
    mockFeeds(rss(item(1), item(2)));
    summarize
      .mockResolvedValueOnce(good({ relevant: false }))
      .mockResolvedValueOnce(good({ country: "foreign" }));
    const res = await runExamNewsFetch();
    expect(res).toMatchObject({ added: 0, skipped: 2 });
    expect(inserted.map((r) => r.is_active)).toEqual([false, false]);
    expect(sendLineMessage).not.toHaveBeenCalled();
  });

  it("dedupes across the feeds that return the same article", async () => {
    mockFeeds(rss(item(1))); // every feed returns the same item
    summarize.mockResolvedValue(good());
    const res = await runExamNewsFetch();
    expect(res.candidates).toBeGreaterThan(1);
    expect(res.fresh).toBe(1);
    expect(summarize).toHaveBeenCalledTimes(1);
  });

  it("skips items already imported, old items and keyword misses without calling the AI", async () => {
    existingRefs = new Set(["auto:g1"]);
    mockFeeds(
      rss(
        item(1), // already imported
        item(2, { ageDays: 30 }), // too old
        item(3, { title: "ราคาน้ำมันวันนี้" }).replace("สอบ NL", "ข่าวทั่วไป") // no exam keyword
      )
    );
    const res = await runExamNewsFetch();
    expect(summarize).not.toHaveBeenCalled();
    expect(res).toMatchObject({ added: 0, skipped: 0 });
  });

  it("calls the AI at most 15 times per run", async () => {
    mockFeeds(rss(...Array.from({ length: 25 }, (_, i) => item(i + 1))));
    summarize.mockResolvedValue(good());
    const res = await runExamNewsFetch();
    expect(summarize).toHaveBeenCalledTimes(15);
    expect(res.added).toBe(15);
    expect(res.fresh).toBe(25);
  });

  it("counts a unique-violation as skipped and a thrown AI error as retryable (not inserted)", async () => {
    mockFeeds(rss(item(1)));
    summarize.mockResolvedValue(good());
    insertError = { code: "23505" };
    expect(await runExamNewsFetch()).toMatchObject({ added: 0, skipped: 1 });

    insertError = null;
    summarize.mockRejectedValue(new Error("AI down"));
    const res = await runExamNewsFetch();
    expect(res).toMatchObject({ added: 0, skipped: 1 });
    expect(inserted).toHaveLength(0);
  });

  it("records feed failures and carries on", async () => {
    mockFeeds(() => new Response("nope", { status: 503 }));
    const res = await runExamNewsFetch();
    expect(res.feedErrors).toHaveLength(res.feeds);
    expect(res).toMatchObject({ candidates: 0, added: 0 });
  });

  it("alerts the admin on LINE only when something was published, and flags exam-date news", async () => {
    mockFeeds(rss(item(1)));
    summarize.mockResolvedValue(good({ exam_schedule: true }));
    await runExamNewsFetch();
    expect(sendLineMessage).toHaveBeenCalledTimes(1);
    const [to, messages] = sendLineMessage.mock.calls[0] as unknown as [string, { text: string }[]];
    expect(to).toBe("Uadmin");
    expect(messages[0].text).toContain("exam-dates");
    expect(messages[0].text).toContain("/admin/news");
  });

  it("does not crash without ADMIN_LINE_USER_ID", async () => {
    delete process.env.ADMIN_LINE_USER_ID;
    mockFeeds(rss(item(1)));
    summarize.mockResolvedValue(good());
    expect((await runExamNewsFetch()).added).toBe(1);
    expect(sendLineMessage).not.toHaveBeenCalled();
  });
});

describe("buildAdminAlertText", () => {
  it("lists up to 5 titles and summarises the rest", () => {
    const text = buildAdminAlertText(Array.from({ length: 8 }, (_, i) => `ข่าว ${i + 1}`), 0);
    expect(text).toContain("8 ข่าว");
    expect(text).toContain("• ข่าว 5");
    expect(text).not.toContain("• ข่าว 6");
    expect(text).toContain("และอีก 3 ข่าว");
    expect(text).not.toContain("exam-dates");
  });
});
