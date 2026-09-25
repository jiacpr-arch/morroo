import { describe, expect, it } from "vitest";
import { parseMoveRequest } from "./move-content";

const A = "11111111-1111-4111-8111-111111111111";
const B = "22222222-2222-4222-8222-222222222222";
const L = "33333333-3333-4333-8333-333333333333";

describe("parseMoveRequest", () => {
  it("accepts a batch move with a file name", () => {
    expect(
      parseMoveRequest({ from_topic_id: A, to_topic_id: B, scope: { kind: "batch", source: "cardio.pdf" } }),
    ).toEqual({
      ok: true,
      value: { fromTopicId: A, toTopicId: B, scope: { kind: "batch", source: "cardio.pdf" } },
    });
  });

  it("accepts a batch move for rows imported without a file name", () => {
    const r = parseMoveRequest({ from_topic_id: A, to_topic_id: B, scope: { kind: "batch", source: null } });
    expect(r).toEqual({
      ok: true,
      value: { fromTopicId: A, toTopicId: B, scope: { kind: "batch", source: null } },
    });
  });

  it("accepts a single-lesson move", () => {
    const r = parseMoveRequest({ from_topic_id: A, to_topic_id: B, scope: { kind: "lesson", id: L } });
    expect(r).toEqual({
      ok: true,
      value: { fromTopicId: A, toTopicId: B, scope: { kind: "lesson", id: L } },
    });
  });

  it("rejects moving into the same subject, case-insensitively", () => {
    const r = parseMoveRequest({ from_topic_id: A, to_topic_id: A.toUpperCase(), scope: { kind: "batch", source: null } });
    expect(r.ok).toBe(false);
  });

  it("rejects non-uuid topic ids such as a literal \"null\"", () => {
    expect(parseMoveRequest({ from_topic_id: "null", to_topic_id: B, scope: { kind: "batch", source: null } }).ok).toBe(false);
    expect(parseMoveRequest({ from_topic_id: A, to_topic_id: null, scope: { kind: "batch", source: null } }).ok).toBe(false);
  });

  it("rejects a lesson move without a uuid lesson id", () => {
    expect(parseMoveRequest({ from_topic_id: A, to_topic_id: B, scope: { kind: "lesson", id: "x" } }).ok).toBe(false);
  });

  it("rejects a batch move whose source is missing or not a string", () => {
    expect(parseMoveRequest({ from_topic_id: A, to_topic_id: B, scope: { kind: "batch" } }).ok).toBe(false);
    expect(parseMoveRequest({ from_topic_id: A, to_topic_id: B, scope: { kind: "batch", source: 3 } }).ok).toBe(false);
  });

  it("rejects unknown scope kinds and malformed bodies", () => {
    expect(parseMoveRequest({ from_topic_id: A, to_topic_id: B, scope: { kind: "all" } }).ok).toBe(false);
    expect(parseMoveRequest({ from_topic_id: A, to_topic_id: B }).ok).toBe(false);
    expect(parseMoveRequest(null).ok).toBe(false);
    expect(parseMoveRequest([]).ok).toBe(false);
  });
});
