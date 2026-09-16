import { describe, it, expect } from "vitest";
import {
  buildDailyMcqBubble,
  buildDailyMcqFlex,
  buildDailyMcqResultFlex,
  buildDailyMcqCarousel,
  buildCasegameTeaserBubble,
  buildWeekRecapBubble,
  buildBlogAnnounceFlex,
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
