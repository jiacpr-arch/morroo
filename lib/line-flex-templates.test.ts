import { describe, it, expect, afterEach } from "vitest";
import {
  buildDailyMcqBubble,
  buildDailyMcqFlex,
  buildDailyMcqResultFlex,
  buildDailyMcqCarousel,
  buildCasegameTeaserBubble,
  buildWeekRecapBubble,
  buildBlogAnnounceFlex,
  buildBlogDigestCarousel,
  BLOG_DIGEST_MAX_POSTS,
  buildWeeklyNewsletterFlex,
  buildWeeklyHardMcqFlex,
  buildNewLongCaseBubble,
  buildAdminDigestFlex,
  buildAdsSuggestFlex,
  buildWeeklySummaryFlex,
  buildExpiryWarningMessage,
  buildStreakNudgeFlex,
  buildMcqReviewReminderFlex,
  buildExamResultFlex,
  buildChatbotCard,
  abbreviateRunError,
  type AdsOpsSummary,
  type DailyMcqQuestionData,
} from "./line-flex-templates";

const LONG_SCENARIO = "ผู้ป่วยชายอายุ 45 ปี ".repeat(60); // > 350 chars

const QUESTION: DailyMcqQuestionData = {
  id: "11111111-1111-1111-1111-111111111111",
  scenario: LONG_SCENARIO,
  difficulty: "medium",
  examType: "NL2",
  subjectNameTh: "ประสาทวิทยา",
  subjectIcon: "🧠",
  quizDate: "2026-09-16",
  choices: [
    { label: "A", text: "Paracetamol เป็นยาแก้ปวดกลุ่ม non-opioid analgesic ที่ใช้กันแพร่หลาย" },
    { label: "B", text: "Sumatriptan" },
    { label: "C", text: "Aspirin" },
    { label: "D", text: "Morphine" },
    { label: "E", text: "Codeine" },
  ],
};

function collectPostbackData(bubble: Record<string, unknown>): string[] {
  return JSON.stringify(bubble).match(/"data":"([^"]*)"/g)?.map((m) => m.slice(8, -1)) ?? [];
}

type FlexAction = { label?: string; data?: string; uri?: string };
function collectActions(node: unknown, out: FlexAction[] = []): FlexAction[] {
  if (Array.isArray(node)) {
    for (const item of node) collectActions(item, out);
  } else if (node && typeof node === "object") {
    const obj = node as Record<string, unknown>;
    if (obj.action && typeof obj.action === "object") out.push(obj.action as FlexAction);
    for (const value of Object.values(obj)) collectActions(value, out);
  }
  return out;
}

describe("buildDailyMcqBubble", () => {
  it("truncates a long scenario instead of sending it whole", () => {
    const bubble = buildDailyMcqBubble({ question: QUESTION, practiceUrl: "https://x.test" });
    expect(JSON.stringify(bubble)).not.toContain(LONG_SCENARIO);
  });

  it("keeps every postback button's data under LINE's 300-char limit", () => {
    const bubble = buildDailyMcqBubble({ question: QUESTION, practiceUrl: "https://x.test" });
    const dataStrings = collectPostbackData(bubble);
    expect(dataStrings.length).toBe(5);
    for (const d of dataStrings) {
      expect(d.length).toBeLessThan(300);
      expect(d).toMatch(/^action=daily_answer&d=2026-09-16&c=[A-E]&q=/);
    }
  });

  // Regression test: LINE's live API rejects the whole Flex message (nothing
  // gets sent to anyone) if any action label exceeds 40 chars. Caught a real
  // production incident where the cap was set to 60 and the truncator had an
  // off-by-one that could still emit max+1 chars.
  it("keeps every button label within LINE's real 40-char limit", () => {
    const bubble = buildDailyMcqBubble({ question: QUESTION, practiceUrl: "https://x.test" });
    const labels = collectActions(bubble)
      .map((a) => a.label)
      .filter((l): l is string => typeof l === "string");
    expect(labels.length).toBeGreaterThan(0);
    for (const label of labels) {
      expect(label.length).toBeLessThanOrEqual(40);
    }
    // The long "Paracetamol..." choice must actually have been truncated,
    // not just happen to fit — otherwise this test would pass vacuously.
    const choiceALabel = labels.find((l) => l.startsWith("A. "));
    expect(choiceALabel).toBeDefined();
    expect(choiceALabel).toContain("…");
  });

  it("shows yesterday's percent-correct only at >= 10 answers", () => {
    const withFew = buildDailyMcqBubble({
      question: QUESTION,
      practiceUrl: "https://x.test",
      yesterdayStats: { total: 4, correct: 3 },
    });
    expect(JSON.stringify(withFew)).not.toContain("เมื่อวานตอบถูก");

    const withMany = buildDailyMcqBubble({
      question: QUESTION,
      practiceUrl: "https://x.test",
      yesterdayStats: { total: 20, correct: 15 },
    });
    expect(JSON.stringify(withMany)).toContain("เมื่อวานตอบถูก");
  });
});

describe("buildDailyMcqFlex", () => {
  it("keeps altText under LINE's 400-char cap", () => {
    const msg = buildDailyMcqFlex({ question: QUESTION, practiceUrl: "https://x.test" });
    expect(msg.type).toBe("flex");
    expect((msg as { altText: string }).altText.length).toBeLessThan(400);
  });
});

describe("buildDailyMcqCarousel", () => {
  it("wraps bubbles in a carousel contents object", () => {
    const bubble = buildDailyMcqBubble({ question: QUESTION, practiceUrl: "https://x.test" });
    const msg = buildDailyMcqCarousel([buildCasegameTeaserBubble(), bubble], "test alt");
    const contents = (msg as unknown as { contents: { type: string; contents: unknown[] } })
      .contents;
    expect(contents.type).toBe("carousel");
    expect(contents.contents.length).toBe(2);
  });
});

describe("buildDailyMcqResultFlex", () => {
  const base = {
    isCorrect: true,
    correctLabel: "B",
    correctText: "Sumatriptan",
    explanation: "เพราะเป็น first-line สำหรับ migraine เฉียบพลัน",
    streak: 3,
    stats: { total: 8, correct: 5 },
    practiceUrl: "https://x.test/practice",
    shareUrl: "https://line.me/R/share?text=hello",
    needsLink: true,
    liffUrl: "https://x.test/line/liff",
  };

  it("shows the streak-5 teaser only below the target", () => {
    const below = buildDailyMcqResultFlex({ ...base, streak: 3 });
    expect(JSON.stringify(below)).toContain("อีก 2 วันติด");

    const atTarget = buildDailyMcqResultFlex({ ...base, streak: 5 });
    expect(JSON.stringify(atTarget)).not.toContain("วันติด รับสิทธิ์ทดลองใช้ฟรี 1 เดือน");
  });

  it("includes the account-link button only when needsLink is true", () => {
    const linked = buildDailyMcqResultFlex({ ...base, needsLink: false });
    expect(JSON.stringify(linked)).not.toContain("เชื่อมบัญชี");

    const unlinked = buildDailyMcqResultFlex({ ...base, needsLink: true });
    expect(JSON.stringify(unlinked)).toContain("เชื่อมบัญชี");
  });

  it("keeps the share uri well under LINE's ~1000-char practical limit", () => {
    const msg = buildDailyMcqResultFlex(base);
    expect(base.shareUrl.length).toBeLessThan(1000);
    expect(JSON.stringify(msg)).toContain(base.shareUrl);
  });

  it("keeps every button label within LINE's 40-char limit and every uri absolute", () => {
    const msg = buildDailyMcqResultFlex({ ...base, needsLink: true });
    const actions = collectActions(msg);
    expect(actions.length).toBeGreaterThan(0);
    for (const a of actions) {
      if (a.label) expect(a.label.length).toBeLessThanOrEqual(40);
      if (a.uri) expect(a.uri).toMatch(/^https?:\/\//);
    }
  });
});

describe("buildWeekRecapBubble", () => {
  it("omits the hardest-day line when there's no qualifying day", () => {
    const bubble = buildWeekRecapBubble({
      answers: 40,
      participants: 12,
      hardestDate: null,
      hardestPct: null,
      streak5Count: 0,
    });
    expect(JSON.stringify(bubble)).not.toContain("วันยากสุด");
  });
});

describe("buildBlogAnnounceFlex", () => {
  const BASE = {
    title: "หัวข้อทดสอบ",
    description: "คำอธิบายสั้นๆ สำหรับทดสอบ",
    url: "https://www.morroo.com/blog/test-slug",
    coverImage: null,
  };

  it("defaults to blog wording", () => {
    const flex = buildBlogAnnounceFlex(BASE);
    if (flex.type !== "flex") throw new Error("expected flex message");
    expect(flex.altText).toContain("บทความใหม่");
    expect(JSON.stringify(flex.contents)).toContain("อ่านบทความ");
  });

  it("uses news wording when kind is 'news'", () => {
    const flex = buildBlogAnnounceFlex({ ...BASE, kind: "news", url: "https://www.morroo.com/news/abc" });
    if (flex.type !== "flex") throw new Error("expected flex message");
    expect(flex.altText).toContain("ข่าวใหม่");
    expect(JSON.stringify(flex.contents)).toContain("อ่านข่าว");
  });
});

describe("buildBlogDigestCarousel", () => {
  const post = (i: number) => ({
    title: `บทความ ${i}`,
    description: `คำอธิบาย ${i}`,
    url: `https://www.morroo.com/blog/post-${i}`,
    coverImage: i % 2 ? `https://cdn.example/${i}.jpg` : null,
  });

  it("packs one bubble per post into a single carousel message", () => {
    const msg = buildBlogDigestCarousel([post(1), post(2), post(3)]);
    if (msg.type !== "flex") throw new Error("expected flex message");
    const carousel = msg.contents as { type: string; contents: unknown[] };
    expect(carousel.type).toBe("carousel");
    expect(carousel.contents).toHaveLength(3);
    expect(msg.altText).toContain("3 เรื่อง");
    expect(msg.altText.length).toBeLessThanOrEqual(400);
    // Every bubble links back to its own article.
    for (let i = 1; i <= 3; i++) {
      expect(JSON.stringify(carousel.contents[i - 1])).toContain(`/blog/post-${i}`);
    }
  });

  it("caps at LINE's carousel limit", () => {
    const many = Array.from({ length: BLOG_DIGEST_MAX_POSTS + 5 }, (_, i) => post(i));
    const msg = buildBlogDigestCarousel(many);
    if (msg.type !== "flex") throw new Error("expected flex message");
    const carousel = msg.contents as { contents: unknown[] };
    expect(carousel.contents).toHaveLength(BLOG_DIGEST_MAX_POSTS);
    expect(msg.altText).toContain(`${BLOG_DIGEST_MAX_POSTS} เรื่อง`);
  });
});

describe("buildWeeklyNewsletterFlex", () => {
  const BASE = {
    tip: "ฝึกคิด DD จากอาการก่อนอ่านคำถาม",
    articles: [
      { title: "บทความ 1", url: "https://www.morroo.com/blog/post-1" },
      { title: "บทความ 2", url: "https://www.morroo.com/blog/post-2" },
    ],
    examsUrl: "https://www.morroo.com/exams",
  };

  it("sends a single flex bubble, not raw text", () => {
    const msg = buildWeeklyNewsletterFlex(BASE);
    expect(msg.type).toBe("flex");
    if (msg.type !== "flex") throw new Error("expected flex message");
    const bubble = msg.contents as { type: string };
    expect(bubble.type).toBe("bubble");
  });

  it("links each article and the exams CTA", () => {
    const msg = buildWeeklyNewsletterFlex(BASE);
    if (msg.type !== "flex") throw new Error("expected flex message");
    const json = JSON.stringify(msg.contents);
    expect(json).toContain("/blog/post-1");
    expect(json).toContain("/blog/post-2");
    expect(json).toContain(BASE.examsUrl);
  });

  it("still renders a card with no articles", () => {
    const msg = buildWeeklyNewsletterFlex({ ...BASE, articles: [] });
    if (msg.type !== "flex") throw new Error("expected flex message");
    expect(JSON.stringify(msg.contents)).not.toContain("บทความใหม่");
  });

  it("caps altText length", () => {
    const msg = buildWeeklyNewsletterFlex(BASE);
    if (msg.type !== "flex") throw new Error("expected flex message");
    expect(msg.altText.length).toBeLessThanOrEqual(150);
  });
});

describe("buildWeeklyHardMcqFlex", () => {
  const args = {
    question: {
      id: "q1",
      scenario: "ผู้ป่วยชาย 60 ปี มาด้วยอาการเจ็บหน้าอก",
      difficulty: "hard",
      examType: "NL2",
      subjectNameTh: "อายุรศาสตร์",
      subjectIcon: "🫀",
      quizDate: "2026-09-18",
      choices: [
        { label: "A", text: "STEMI" },
        { label: "B", text: "NSTEMI" },
      ],
    },
    practiceUrl: "https://www.morroo.com/nl/practice?q=q1",
  };

  it("personalizes the weekly-answered count per recipient", () => {
    const flex = buildWeeklyHardMcqFlex({ ...args, weeklyAnswered: 4 });
    if (flex.type !== "flex") throw new Error("expected flex message");
    expect(JSON.stringify(flex.contents)).toContain("4 ข้อ");
    expect(flex.altText).toContain("ข้อยากประจำสัปดาห์");
  });

  it("uses encouraging copy when the recipient hasn't answered anything yet", () => {
    const flex = buildWeeklyHardMcqFlex({ ...args, weeklyAnswered: 0 });
    if (flex.type !== "flex") throw new Error("expected flex message");
    expect(JSON.stringify(flex.contents)).toContain("ยังไม่ได้ตอบสักข้อ");
  });

  it("includes a postback button per answer choice", () => {
    const flex = buildWeeklyHardMcqFlex({ ...args, weeklyAnswered: 1 });
    if (flex.type !== "flex") throw new Error("expected flex message");
    const json = JSON.stringify(flex.contents);
    expect(json).toContain("action=daily_answer&d=2026-09-18&c=A&q=q1");
    expect(json).toContain("action=daily_answer&d=2026-09-18&c=B&q=q1");
  });
});

describe("buildAdminDigestFlex — reengage experiment readout", () => {
  const BASE = {
    dateLabel: "จ. 21 ก.ย.",
    attemptsToday: 0,
    activeUsersToday: 0,
    newUsersToday: 0,
    avgAccuracyToday: null,
    totalStudents: 0,
    activeUsers7d: 0,
    weakestSubject: null,
    aiGradeFails24h: 0,
    revenueTodayThb: null,
  };
  const arm = (size: number, blocked = 0, answered = 0, converted = 0) => ({
    size,
    blocked,
    answered,
    converted,
  });

  it("shows a waiting line before the first Monday send", () => {
    const msg = buildAdminDigestFlex({
      ...BASE,
      reengageExperiment: { startedAt: null, dayN: 0, testDays: 7, test: arm(100), control: arm(98) },
    });
    const json = JSON.stringify(msg.type === "flex" ? msg.contents : {});
    expect(json).toContain("รอส่งใบแรก");
    expect(json).toContain("100 คน");
    expect(json).not.toContain("ครบ 1 สัปดาห์");
  });

  it("shows per-arm counts mid-test without the decision prompt", () => {
    const msg = buildAdminDigestFlex({
      ...BASE,
      reengageExperiment: {
        startedAt: "2026-09-21T00:00:00Z",
        dayN: 3,
        testDays: 7,
        test: arm(100, 1, 6, 0),
        control: arm(98, 0, 2, 0),
      },
    });
    const json = JSON.stringify(msg.type === "flex" ? msg.contents : {});
    expect(json).toContain("วันที่ 3/7");
    expect(json).toContain("บล็อก 1 · ตอบ 6");
    expect(json).not.toContain("ครบ 1 สัปดาห์");
  });

  it("adds the decision prompt on day 7 and caps the day counter", () => {
    const msg = buildAdminDigestFlex({
      ...BASE,
      reengageExperiment: {
        startedAt: "2026-09-21T00:00:00Z",
        dayN: 9,
        testDays: 7,
        test: arm(100),
        control: arm(98),
      },
    });
    const json = JSON.stringify(msg.type === "flex" ? msg.contents : {});
    expect(json).toContain("วันที่ 7/7");
    expect(json).toContain("ครบ 1 สัปดาห์");
  });

  it("renders nothing about the experiment when there is none", () => {
    const msg = buildAdminDigestFlex({ ...BASE, reengageExperiment: null });
    expect(JSON.stringify(msg.type === "flex" ? msg.contents : {})).not.toContain("ทดลอง MCQ");
  });
});

describe("buildNewLongCaseBubble", () => {
  it("links to the given long case URL", () => {
    const bubble = buildNewLongCaseBubble({
      title: "หญิง 45 ปี ปวดท้องเฉียบพลัน",
      specialty: "General Surgery",
      url: "https://www.morroo.com/longcase/abc-123",
    });
    const json = JSON.stringify(bubble);
    expect(json).toContain("https://www.morroo.com/longcase/abc-123");
    expect(json).toContain("หญิง 45 ปี ปวดท้องเฉียบพลัน");
    expect(json).toContain("General Surgery");
  });
});

describe("abbreviateRunError", () => {
  it("pulls the human message out of a Graph API error envelope", () => {
    const raw =
      'ads: Meta insights failed 403: {"error":{"message":"(#200) Ad account owner has NOT grant ads_management or ads_read permission, refer to https://developers.facebook.com/docs/marketing-api/get-started/authorization/#permissions-and-features for details.","type":"OAuthException","code":200,"fbtrace_id":"Ao2dY3S9mBAiXR"}}';
    const out = abbreviateRunError(raw);
    expect(out).toContain("(#200)");
    expect(out).toContain("ads: Meta insights failed 403:");
    // the JSON scaffolding and trace id must not reach the digest bubble
    expect(out).not.toContain("fbtrace_id");
    expect(out).not.toContain('"type"');
    expect(out.length).toBeLessThanOrEqual(110);
  });

  it("passes a short plain message through untouched", () => {
    const msg = "ads: ยังไม่ได้ตั้งค่า META_AD_ACCOUNT_ID";
    expect(abbreviateRunError(msg)).toBe(msg);
  });

  it("truncates anything past the cap with an ellipsis", () => {
    const out = abbreviateRunError("x".repeat(500));
    expect(out).toHaveLength(110);
    expect(out.endsWith("…")).toBe(true);
  });

  it("collapses newlines so the bubble stays on one line", () => {
    expect(abbreviateRunError("line one\n  line two")).toBe("line one line two");
  });

  it("has a fallback for null and blank", () => {
    expect(abbreviateRunError(null)).toBe("ไม่มีรายละเอียดข้อผิดพลาด");
    expect(abbreviateRunError("   ")).toBe("ไม่มีรายละเอียดข้อผิดพลาด");
  });
});

describe("adsOps autofix — the four outcomes must stay distinguishable", () => {
  const BASE = {
    dateLabel: "จ. 21 ก.ย.",
    attemptsToday: 0,
    activeUsersToday: 0,
    newUsersToday: 0,
    avgAccuracyToday: null,
    totalStudents: 0,
    activeUsers7d: 0,
    weakestSubject: null,
    aiGradeFails24h: 0,
    revenueTodayThb: null,
  };

  type Autofix = NonNullable<AdsOpsSummary["autofix"]>;
  const render = (autofix: Autofix) => {
    const msg = buildAdminDigestFlex({
      ...BASE,
      adsOps: {
        autofix,
        postMerge: [],
        suggestsNew: 0,
        suggestsOpenTotal: 0,
      },
    });
    return JSON.stringify(msg.type === "flex" ? msg.contents : {});
  };

  const CLEAN = {
    ok: true,
    adsScanned: 19,
    adsIdle: false,
    error: null,
    findingsCount: 0,
    critical: 0,
    autoPaused: 0,
    topIssues: [],
  };

  it("a failed run shows the real reason, never a ✅", () => {
    const json = render({
      ...CLEAN,
      ok: false,
      adsScanned: 0,
      error:
        'ads: Meta insights failed 403: {"error":{"message":"(#200) Ad account owner has NOT grant ads_management or ads_read permission","code":200}}',
    });
    expect(json).toContain("ไม่สำเร็จ");
    expect(json).toContain("(#200)");
    expect(json).not.toContain("ไม่พบปัญหา");
  });

  it("a quiet account reads as idle, not as a failure", () => {
    const json = render({ ...CLEAN, adsScanned: 0, adsIdle: true });
    expect(json).toContain("ไม่มีโฆษณาที่กำลังวิ่ง");
    expect(json).not.toContain("เชื่อไม่ได้");
    expect(json).not.toContain("ไม่พบปัญหา");
  });

  it("a blind scan is flagged even when the run says ok", () => {
    const json = render({ ...CLEAN, adsScanned: 0, adsIdle: false });
    expect(json).toContain("เชื่อไม่ได้");
    expect(json).not.toContain("ไม่พบปัญหา");
  });

  it("only a real scan earns the ✅, and it states the count", () => {
    const json = render(CLEAN);
    expect(json).toContain("ตรวจโฆษณา 19 ตัวแล้ว ไม่พบปัญหา");
    expect(json).not.toContain("เชื่อไม่ได้");
  });
});

// LIFF rollout (lib/line-links.ts) regression guard: every customer-facing
// button must open as a LIFF deep link when NEXT_PUBLIC_LIFF_ID is set (so
// tapping it from inside LINE lands the visitor signed in), while internal
// admin/ops cards (never opened from a customer's LINE) must stay untouched.
describe("LIFF deep links on customer-facing Flex buttons", () => {
  const LIFF_ID = "2010009663-BMDYoMQk";
  const ORIGINAL_LIFF_ID = process.env.NEXT_PUBLIC_LIFF_ID;

  afterEach(() => {
    if (ORIGINAL_LIFF_ID === undefined) delete process.env.NEXT_PUBLIC_LIFF_ID;
    else process.env.NEXT_PUBLIC_LIFF_ID = ORIGINAL_LIFF_ID;
  });

  it("rewrites the dashboard/exams buttons on the weekly summary card", () => {
    process.env.NEXT_PUBLIC_LIFF_ID = LIFF_ID;
    const flex = buildWeeklySummaryFlex({
      totalQuestions: 10,
      correctCount: 7,
      accuracy: 70,
      bestSubject: "ประสาทวิทยา",
      bestSubjectIcon: "🧠",
      streak: 3,
    });
    const uris = collectActions((flex as { contents: unknown }).contents).map((a) => a.uri);
    expect(uris).toContain(`https://liff.line.me/${LIFF_ID}/dashboard`);
  });

  it("rewrites the register + read-article buttons on a blog/news announce card", () => {
    process.env.NEXT_PUBLIC_LIFF_ID = LIFF_ID;
    const flex = buildBlogAnnounceFlex({
      title: "บทความทดสอบ",
      description: "รายละเอียด",
      url: "https://www.morroo.com/blog/test-slug",
      coverImage: null,
    });
    const uris = collectActions((flex as { contents: unknown }).contents).map((a) => a.uri);
    expect(uris).toContain(`https://liff.line.me/${LIFF_ID}/register`);
    expect(uris).toContain(`https://liff.line.me/${LIFF_ID}/blog/test-slug`);
  });

  it("rewrites the renew/pricing buttons on the expiry-warning card", () => {
    process.env.NEXT_PUBLIC_LIFF_ID = LIFF_ID;
    const flex = buildExpiryWarningMessage({
      name: "หมอตัวอย่าง",
      expiresAt: new Date(Date.now() + 3 * 86400_000),
      membershipType: "monthly",
    });
    const uris = collectActions((flex as { contents: unknown }).contents).map((a) => a.uri);
    expect(uris.some((u) => u === `https://liff.line.me/${LIFF_ID}/payment/monthly`)).toBe(true);
    expect(uris).toContain(`https://liff.line.me/${LIFF_ID}/pricing`);
  });

  it("rewrites the practice button on the streak-nudge card", () => {
    process.env.NEXT_PUBLIC_LIFF_ID = LIFF_ID;
    const flex = buildStreakNudgeFlex({
      name: "หมอตัวอย่าง",
      streak: 2,
      practiceUrl: "https://www.morroo.com/nl/practice?utm_source=line",
    });
    const uris = collectActions((flex as { contents: unknown }).contents).map((a) => a.uri);
    expect(uris).toContain(`https://liff.line.me/${LIFF_ID}/nl/practice?utm_source=line`);
  });

  it("rewrites the review button and states the due count on the mcq-review reminder", () => {
    process.env.NEXT_PUBLIC_LIFF_ID = LIFF_ID;
    const flex = buildMcqReviewReminderFlex({
      name: "หมอตัวอย่าง",
      dueCount: 7,
      reviewUrl: "https://www.morroo.com/nl/practice?mode=review&utm_source=line",
    });
    expect((flex as { altText: string }).altText).toBe("วันนี้มี 7 ข้อที่ถึงรอบทบทวน");
    const uris = collectActions((flex as { contents: unknown }).contents).map((a) => a.uri);
    expect(uris).toContain(
      `https://liff.line.me/${LIFF_ID}/nl/practice?mode=review&utm_source=line`
    );
  });

  it("rewrites the dashboard/exams buttons on an exam-result card", () => {
    process.env.NEXT_PUBLIC_LIFF_ID = LIFF_ID;
    const flex = buildExamResultFlex({
      score: 8,
      maxScore: 10,
      subjectLabel: "ประสาทวิทยา",
      questionPreview: "โจทย์ตัวอย่าง",
      feedback: "ทำได้ดี",
      matchedCount: 4,
      totalKeyPoints: 5,
      weakTopics: [],
    });
    const uris = collectActions((flex as { contents: unknown }).contents).map((a) => a.uri);
    expect(uris).toContain(`https://liff.line.me/${LIFF_ID}/dashboard`);
    expect(uris).toContain(`https://liff.line.me/${LIFF_ID}/exams`);
  });

  it("rewrites every chatbot CTA card's buttons", () => {
    process.env.NEXT_PUBLIC_LIFF_ID = LIFF_ID;
    for (const card of ["pricing", "register", "longcase", "meq"] as const) {
      const flex = buildChatbotCard(card);
      const uris = collectActions((flex as { contents: unknown }).contents).map((a) => a.uri);
      expect(uris.length).toBeGreaterThan(0);
      for (const uri of uris) {
        expect(uri).toMatch(new RegExp(`^https://liff\\.line\\.me/${LIFF_ID}/`));
      }
    }
  });

  it("falls back to plain morroo.com URLs when NEXT_PUBLIC_LIFF_ID is unset", () => {
    delete process.env.NEXT_PUBLIC_LIFF_ID;
    const flex = buildChatbotCard("register");
    const uris = collectActions((flex as { contents: unknown }).contents).map((a) => a.uri);
    expect(uris).toContain("https://www.morroo.com/register");
    expect(JSON.stringify(flex)).not.toContain("liff.line.me");
  });

  it("never rewrites the admin digest card, even with a LIFF ID configured", () => {
    process.env.NEXT_PUBLIC_LIFF_ID = LIFF_ID;
    const flex = buildAdminDigestFlex({
      dateLabel: "จ. 21 ก.ย.",
      attemptsToday: 0,
      activeUsersToday: 0,
      newUsersToday: 0,
      avgAccuracyToday: null,
      totalStudents: 0,
      activeUsers7d: 0,
      weakestSubject: null,
      aiGradeFails24h: 0,
      revenueTodayThb: null,
    });
    expect(JSON.stringify(flex)).not.toContain("liff.line.me");
    expect(JSON.stringify(flex)).toContain("https://www.morroo.com/admin");
  });

  it("never rewrites the ads-autofix suggestion card, even with a LIFF ID configured", () => {
    process.env.NEXT_PUBLIC_LIFF_ID = LIFF_ID;
    const flex = buildAdsSuggestFlex({
      pagePath: "/lp/free-trial",
      recommendation: "ลดงบ 20%",
      severity: "warning",
      prNumber: 123,
      prUrl: "https://github.com/jiacpr-arch/morroo/pull/123",
      baseline: {},
    });
    expect(JSON.stringify(flex)).not.toContain("liff.line.me");
  });
});
