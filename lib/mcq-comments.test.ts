import { describe, it, expect } from "vitest";
import {
  ANONYMOUS_DISPLAY_NAME,
  COMMENT_MAX_LENGTH,
  avatarInitial,
  buildThreads,
  countVisible,
  isUuid,
  publicDisplayName,
  relativeTimeTh,
  validateCommentBody,
  validateCreateComment,
  validateReportReason,
  type PublicComment,
} from "./mcq-comments";

const Q = "11111111-1111-4111-8111-111111111111";
const P = "22222222-2222-4222-8222-222222222222";

describe("validateCommentBody", () => {
  it("trims and accepts normal text", () => {
    expect(validateCommentBody("  ข้อนี้ตอบ B เพราะ...  ")).toEqual({
      ok: true,
      value: "ข้อนี้ตอบ B เพราะ...",
    });
  });
  it("rejects empty / whitespace / non-string", () => {
    expect(validateCommentBody("").ok).toBe(false);
    expect(validateCommentBody("   \n\t ").ok).toBe(false);
    expect(validateCommentBody(undefined).ok).toBe(false);
    expect(validateCommentBody(42).ok).toBe(false);
  });
  it("enforces the 2000 char limit after trimming", () => {
    expect(validateCommentBody("a".repeat(COMMENT_MAX_LENGTH)).ok).toBe(true);
    expect(validateCommentBody(`  ${"a".repeat(COMMENT_MAX_LENGTH)}  `).ok).toBe(true);
    expect(validateCommentBody("a".repeat(COMMENT_MAX_LENGTH + 1)).ok).toBe(false);
  });
  it("normalises CRLF and collapses long blank runs", () => {
    const r = validateCommentBody("a\r\n\r\n\r\n\r\nb");
    expect(r).toEqual({ ok: true, value: "a\n\nb" });
  });
});

describe("validateCreateComment", () => {
  it("accepts a top-level comment", () => {
    expect(validateCreateComment({ question_id: Q, body: "hi" })).toEqual({
      ok: true,
      value: { question_id: Q, parent_id: null, body: "hi" },
    });
  });
  it("accepts a reply", () => {
    const r = validateCreateComment({ question_id: Q, parent_id: P, body: "hi" });
    expect(r.ok && r.value.parent_id).toBe(P);
  });
  it("rejects bad ids and bodies", () => {
    expect(validateCreateComment(null).ok).toBe(false);
    expect(validateCreateComment({ question_id: "x", body: "hi" }).ok).toBe(false);
    expect(validateCreateComment({ question_id: Q, parent_id: "nope", body: "hi" }).ok).toBe(false);
    expect(validateCreateComment({ question_id: Q, body: "" }).ok).toBe(false);
  });
});

describe("validateReportReason", () => {
  it("accepts known reasons only", () => {
    expect(validateReportReason("spam")).toEqual({ ok: true, value: "spam" });
    expect(validateReportReason("SPAM").ok).toBe(false);
    expect(validateReportReason(undefined).ok).toBe(false);
  });
});

describe("isUuid", () => {
  it("matches canonical uuids", () => {
    expect(isUuid(Q)).toBe(true);
    expect(isUuid("not-a-uuid")).toBe(false);
    expect(isUuid(null)).toBe(false);
  });
});

describe("publicDisplayName", () => {
  it("shortens to first name + initial", () => {
    expect(publicDisplayName("Somchai Jaidee")).toBe("Somchai J.");
    expect(publicDisplayName("  สมชาย   ใจดี ")).toBe("สมชาย ใ.");
  });
  it("keeps single-word names", () => {
    expect(publicDisplayName("Ploy")).toBe("Ploy");
  });
  it("never exposes emails and falls back to anonymous", () => {
    expect(publicDisplayName("someone@gmail.com")).toBe(ANONYMOUS_DISPLAY_NAME);
    expect(publicDisplayName(null)).toBe(ANONYMOUS_DISPLAY_NAME);
    expect(publicDisplayName("   ")).toBe(ANONYMOUS_DISPLAY_NAME);
  });
  it("avatarInitial uppercases the first char", () => {
    expect(avatarInitial("ploy")).toBe("P");
    expect(avatarInitial("")).toBe("?");
  });
});

function c(
  id: string,
  opts: Partial<PublicComment> & { created_at: string }
): PublicComment {
  return {
    id,
    parent_id: null,
    body: id,
    edited_at: null,
    status: "visible",
    upvotes: 0,
    author: { name: "x", initial: "X", is_admin: false },
    is_mine: false,
    has_voted: false,
    ...opts,
  };
}

describe("buildThreads", () => {
  const list = [
    c("old-top", { created_at: "2026-01-01T00:00:00Z", upvotes: 5 }),
    c("new-top", { created_at: "2026-01-03T00:00:00Z", upvotes: 5 }),
    c("hot-top", { created_at: "2026-01-01T00:00:00Z", upvotes: 9 }),
    c("cold-top", { created_at: "2026-01-05T00:00:00Z", upvotes: 0 }),
    c("r2", { parent_id: "old-top", created_at: "2026-01-02T02:00:00Z" }),
    c("r1", { parent_id: "old-top", created_at: "2026-01-02T01:00:00Z" }),
    c("r-hot", { parent_id: "old-top", created_at: "2026-01-02T03:00:00Z", upvotes: 2 }),
    c("orphan", { parent_id: "missing", created_at: "2026-01-02T00:00:00Z" }),
  ];

  it("sorts top-level by upvotes then newest", () => {
    expect(buildThreads(list).map((t) => t.id)).toEqual([
      "hot-top",
      "new-top",
      "old-top",
      "cold-top",
    ]);
  });

  it("sorts replies by upvotes then oldest and drops orphans", () => {
    const threads = buildThreads(list);
    const old = threads.find((t) => t.id === "old-top")!;
    expect(old.replies.map((r) => r.id)).toEqual(["r-hot", "r1", "r2"]);
    expect(threads.flatMap((t) => t.replies).some((r) => r.id === "orphan")).toBe(false);
  });

  it("counts only visible comments", () => {
    const threads = buildThreads([
      ...list,
      c("hidden-mine", { created_at: "2026-01-01T00:00:00Z", status: "hidden", is_mine: true }),
    ]);
    expect(countVisible(threads)).toBe(7);
  });
});

describe("relativeTimeTh", () => {
  const now = Date.parse("2026-09-25T12:00:00Z");
  it("buckets durations", () => {
    expect(relativeTimeTh("2026-09-25T11:59:30Z", now)).toBe("เมื่อสักครู่");
    expect(relativeTimeTh("2026-09-25T11:55:00Z", now)).toBe("5 นาทีที่แล้ว");
    expect(relativeTimeTh("2026-09-25T09:00:00Z", now)).toBe("3 ชั่วโมงที่แล้ว");
    expect(relativeTimeTh("2026-09-23T12:00:00Z", now)).toBe("2 วันที่แล้ว");
  });
});
