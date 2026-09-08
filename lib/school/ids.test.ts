import { describe, it, expect } from "vitest";
import { isUuid, lessonHref, topicHref } from "./ids";

const ID = "3f2504e0-4f89-11d3-9a0c-0305e82c3301";

describe("isUuid", () => {
  it("accepts a canonical uuid in either case", () => {
    expect(isUuid(ID)).toBe(true);
    expect(isUuid(ID.toUpperCase())).toBe(true);
  });

  it("rejects the values that reach the [id] pages by mistake", () => {
    expect(isUuid("null")).toBe(false);
    expect(isUuid("undefined")).toBe(false);
    expect(isUuid(null)).toBe(false);
    expect(isUuid(undefined)).toBe(false);
    expect(isUuid("")).toBe(false);
    expect(isUuid(`${ID}x`)).toBe(false);
    expect(isUuid(123)).toBe(false);
  });
});

describe("lessonHref / topicHref", () => {
  it("build the route only for a real id", () => {
    expect(lessonHref(ID)).toBe(`/school/lesson/${ID}`);
    expect(lessonHref(ID, "mode=quiz")).toBe(`/school/lesson/${ID}?mode=quiz`);
    expect(topicHref(ID)).toBe(`/school/topic/${ID}`);
  });

  it("return null instead of a /null URL", () => {
    expect(lessonHref(null)).toBeNull();
    expect(lessonHref("null", "mode=read")).toBeNull();
    expect(topicHref(undefined)).toBeNull();
    expect(topicHref("null")).toBeNull();
  });
});
