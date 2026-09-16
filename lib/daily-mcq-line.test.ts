import { describe, it, expect, vi, beforeEach } from "vitest";
import {
  handleDailyMcqPostback,
  bangkokToday,
  shiftQuizDate,
} from "./daily-mcq-line";

vi.mock("./redeem", () => ({
  issueRedeemCode: vi.fn(async () => ({
    code: "MORROO-TEST-CODE",
    rewardType: "monthly_1m",
    expiresAt: new Date(),
  })),
}));
vi.mock("./lead-channel", () => ({
  getOrCreateLeadFromChannel: vi.fn(async () => "lead_1"),
}));

import { issueRedeemCode } from "./redeem";
import { getOrCreateLeadFromChannel } from "./lead-channel";

const LINE_USER = "U_test_user";
const TODAY = bangkokToday();

const QUESTION = {
  id: "q1",
  subject_id: "s1",
  exam_type: "NL2",
  scenario: "ผู้ป่วยชายอายุ 45 ปี มาด้วยอาการปวดศีรษะเฉียบพลัน",
  choices: [
    { label: "A", text: "Paracetamol" },
    { label: "B", text: "Sumatriptan" },
    { label: "C", text: "Aspirin" },
    { label: "D", text: "Morphine" },
    { label: "E", text: "Codeine" },
  ],
  correct_answer: "B",
  explanation: "Sumatriptan เป็น first-line สำหรับ migraine เฉียบพลัน",
  detailed_explanation: null,
  difficulty: "medium",
  status: "active",
  audience: "student",
  mcq_subjects: { name: "neuro", name_th: "ประสาทวิทยา", icon: "🧠" },
};

type FakeOpts = {
  linkedUserId?: string | null;
  isNewAnswer?: boolean; // true = upsert inserted a row; false = duplicate tap
  existingAnswer?: { selected_answer: string; is_correct: boolean } | null;
  streak?: number;
  stats?: { total: number; correct: number } | null;
  leadStage?: string | null;
  existingRewardCode?: string | null;
};

function fakeSupabase(opts: FakeOpts = {}) {
  const {
    linkedUserId = null,
    isNewAnswer = true,
    existingAnswer = null,
    streak = 1,
    stats = { total: 3, correct: 2 },
    leadStage = null,
    existingRewardCode = null,
  } = opts;

  const mcqAttemptsInsert = vi.fn(() => Promise.resolve({ error: null }));

  const client = {
    rpc(name: string, args: Record<string, unknown>) {
      if (name === "get_daily_mcq") {
        return Promise.resolve({ data: [{ id: QUESTION.id, quiz_date: args.p_date }], error: null });
      }
      if (name === "daily_quiz_streak") {
        return Promise.resolve({ data: streak, error: null });
      }
      if (name === "daily_quiz_stats") {
        return Promise.resolve({ data: stats ? [stats] : [{ total: 0, correct: 0 }], error: null });
      }
      throw new Error(`unexpected rpc: ${name}`);
    },
    from(table: string) {
      if (table === "mcq_questions") {
        return {
          select: () => ({
            eq: () => ({
              single: () => Promise.resolve({ data: QUESTION, error: null }),
            }),
          }),
        };
      }
      if (table === "profiles") {
        return {
          select: () => ({
            eq: () => ({
              limit: () =>
                Promise.resolve({
                  data: linkedUserId ? [{ id: linkedUserId }] : [],
                }),
            }),
          }),
        };
      }
      if (table === "daily_quiz_answers") {
        return {
          upsert: () => ({
            select: () =>
              Promise.resolve({
                data: isNewAnswer ? [{ id: "row_1" }] : [],
                error: null,
              }),
          }),
          select: () => ({
            eq: () => ({
              eq: () => ({
                maybeSingle: () => Promise.resolve({ data: existingAnswer }),
              }),
            }),
          }),
        };
      }
      if (table === "mcq_attempts") {
        return { insert: mcqAttemptsInsert };
      }
      if (table === "leads") {
        return {
          select: () => ({
            eq: () => ({
              maybeSingle: () =>
                Promise.resolve({ data: leadStage ? { stage: leadStage } : null }),
            }),
          }),
          update: () => ({ eq: () => Promise.resolve({ error: null }) }),
        };
      }
      if (table === "redeem_codes") {
        return {
          select: () => ({
            eq: () => ({
              eq: () => ({
                limit: () => ({
                  maybeSingle: () =>
                    Promise.resolve({
                      data: existingRewardCode ? { code: existingRewardCode } : null,
                    }),
                }),
              }),
            }),
          }),
        };
      }
      throw new Error(`unexpected table: ${table}`);
    },
  };

  return { client, mcqAttemptsInsert };
}

beforeEach(() => {
  vi.clearAllMocks();
});

describe("handleDailyMcqPostback — routing", () => {
  it("returns null for unrelated postback actions", async () => {
    const { client } = fakeSupabase();
    const reply = await handleDailyMcqPostback(
      client as never,
      LINE_USER,
      "action=merge_pr&pr=1"
    );
    expect(reply).toBeNull();
  });
});

describe("handleDailyMcqPostback — validity window", () => {
  it("rejects a quiz_date older than yesterday", async () => {
    const { client } = fakeSupabase();
    const stale = shiftQuizDate(TODAY, -2);
    const reply = await handleDailyMcqPostback(
      client as never,
      LINE_USER,
      `action=daily_answer&d=${stale}&c=A&q=${QUESTION.id}`
    );
    expect(reply).not.toBeNull();
    expect(JSON.stringify(reply)).toContain("หมดเวลา");
  });

  it("accepts yesterday's date (grace window)", async () => {
    const { client } = fakeSupabase();
    const yesterday = shiftQuizDate(TODAY, -1);
    const reply = await handleDailyMcqPostback(
      client as never,
      LINE_USER,
      `action=daily_answer&d=${yesterday}&c=B&q=${QUESTION.id}`
    );
    expect(reply).not.toBeNull();
    expect(JSON.stringify(reply)).not.toContain("หมดเวลา");
  });

  it("ignores an invalid answer letter", async () => {
    const { client } = fakeSupabase();
    const reply = await handleDailyMcqPostback(
      client as never,
      LINE_USER,
      `action=daily_answer&d=${TODAY}&c=Z&q=${QUESTION.id}`
    );
    expect(reply).toBeNull();
  });
});

describe("handleDailyMcqPostback — scoring is server-derived, not from `q`", () => {
  it("grades against get_daily_mcq(d)'s question even with a forged `q`", async () => {
    const { client } = fakeSupabase();
    const reply = await handleDailyMcqPostback(
      client as never,
      LINE_USER,
      `action=daily_answer&d=${TODAY}&c=B&q=some-other-question-id`
    );
    // B is QUESTION.correct_answer — scored correct because the handler
    // resolved the question via get_daily_mcq(d), not the forged `q`.
    expect(JSON.stringify(reply)).toContain("ถูกต้อง");
  });

  it("marks a wrong letter incorrect and still shows the right answer text", async () => {
    const { client } = fakeSupabase();
    const reply = await handleDailyMcqPostback(
      client as never,
      LINE_USER,
      `action=daily_answer&d=${TODAY}&c=A&q=${QUESTION.id}`
    );
    const json = JSON.stringify(reply);
    expect(json).toContain("ยังไม่ถูก");
    expect(json).toContain("Sumatriptan");
  });
});

describe("handleDailyMcqPostback — idempotency", () => {
  it("a repeat tap replies with the first stored answer, doesn't mirror to mcq_attempts, doesn't re-issue a reward", async () => {
    const { client, mcqAttemptsInsert } = fakeSupabase({
      linkedUserId: "user_1",
      isNewAnswer: false,
      existingAnswer: { selected_answer: "B", is_correct: true },
      streak: 5,
    });
    const reply = await handleDailyMcqPostback(
      client as never,
      LINE_USER,
      // Second tap claims a different (wrong) letter — should be ignored;
      // the reply must reflect the originally stored answer (correct).
      `action=daily_answer&d=${TODAY}&c=A&q=${QUESTION.id}`
    );
    expect(JSON.stringify(reply)).toContain("ถูกต้อง");
    expect(mcqAttemptsInsert).not.toHaveBeenCalled();
    expect(issueRedeemCode).not.toHaveBeenCalled();
  });
});

describe("handleDailyMcqPostback — mcq_attempts mirror", () => {
  it("mirrors into mcq_attempts only for a new answer from a linked account", async () => {
    const { client, mcqAttemptsInsert } = fakeSupabase({
      linkedUserId: "user_1",
      isNewAnswer: true,
    });
    await handleDailyMcqPostback(
      client as never,
      LINE_USER,
      `action=daily_answer&d=${TODAY}&c=B&q=${QUESTION.id}`
    );
    expect(mcqAttemptsInsert).toHaveBeenCalledWith(
      expect.objectContaining({ user_id: "user_1", question_id: QUESTION.id, is_correct: true })
    );
  });

  it("skips the mirror when the LINE user has no linked account", async () => {
    const { client, mcqAttemptsInsert } = fakeSupabase({
      linkedUserId: null,
      isNewAnswer: true,
    });
    const reply = await handleDailyMcqPostback(
      client as never,
      LINE_USER,
      `action=daily_answer&d=${TODAY}&c=B&q=${QUESTION.id}`
    );
    expect(mcqAttemptsInsert).not.toHaveBeenCalled();
    expect(JSON.stringify(reply)).toContain("เชื่อมบัญชี");
  });
});

describe("handleDailyMcqPostback — streak-5 reward", () => {
  it("issues a trial code the first time streak hits 5", async () => {
    const { client } = fakeSupabase({ isNewAnswer: true, streak: 5 });
    const reply = await handleDailyMcqPostback(
      client as never,
      LINE_USER,
      `action=daily_answer&d=${TODAY}&c=B&q=${QUESTION.id}`
    );
    expect(issueRedeemCode).toHaveBeenCalledTimes(1);
    expect(issueRedeemCode).toHaveBeenCalledWith(
      expect.objectContaining({ campaign: "daily_mcq_streak5", leadId: "lead_1" })
    );
    expect(JSON.stringify(reply)).toContain("MORROO-TEST-CODE");
  });

  it("does not re-issue when a streak-5 code already exists for this lead", async () => {
    const { client } = fakeSupabase({
      isNewAnswer: true,
      streak: 5,
      existingRewardCode: "MORROO-OLD-CODE",
    });
    await handleDailyMcqPostback(
      client as never,
      LINE_USER,
      `action=daily_answer&d=${TODAY}&c=B&q=${QUESTION.id}`
    );
    expect(issueRedeemCode).not.toHaveBeenCalled();
  });

  it("skips the reward for a lead that has already converted", async () => {
    const { client } = fakeSupabase({
      isNewAnswer: true,
      streak: 5,
      leadStage: "paid",
    });
    await handleDailyMcqPostback(
      client as never,
      LINE_USER,
      `action=daily_answer&d=${TODAY}&c=B&q=${QUESTION.id}`
    );
    expect(issueRedeemCode).not.toHaveBeenCalled();
  });

  it("does not issue a reward on a streak below 5", async () => {
    const { client } = fakeSupabase({ isNewAnswer: true, streak: 3 });
    await handleDailyMcqPostback(
      client as never,
      LINE_USER,
      `action=daily_answer&d=${TODAY}&c=B&q=${QUESTION.id}`
    );
    expect(issueRedeemCode).not.toHaveBeenCalled();
    expect(getOrCreateLeadFromChannel).not.toHaveBeenCalled();
  });
});

describe("handleDailyMcqPostback — social proof gating", () => {
  it("hides the percent-correct line when fewer than 5 people have answered", async () => {
    const { client } = fakeSupabase({ stats: { total: 2, correct: 1 } });
    const reply = await handleDailyMcqPostback(
      client as never,
      LINE_USER,
      `action=daily_answer&d=${TODAY}&c=B&q=${QUESTION.id}`
    );
    expect(JSON.stringify(reply)).not.toContain("วันนี้มีคนตอบ");
  });

  it("shows the percent-correct line at 5 or more answers", async () => {
    const { client } = fakeSupabase({ stats: { total: 5, correct: 4 } });
    const reply = await handleDailyMcqPostback(
      client as never,
      LINE_USER,
      `action=daily_answer&d=${TODAY}&c=B&q=${QUESTION.id}`
    );
    expect(JSON.stringify(reply)).toContain("วันนี้มีคนตอบ");
  });
});
