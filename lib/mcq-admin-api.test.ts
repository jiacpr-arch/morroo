import { describe, expect, it } from "vitest";
import {
  isMcqAdminListView,
  parseMcqAdminListFilters,
  pickWritableMcqFields,
} from "./mcq-admin-api";
import { isChoiceLabel, toAnswerKey, toPublicQuestion } from "./mcq-public";

describe("pickWritableMcqFields", () => {
  it("keeps only writable columns", () => {
    expect(
      pickWritableMcqFields({
        id: "x",
        created_at: "now",
        scenario: "s",
        correct_answer: "B",
        status: "review",
        bogus: 1,
      }),
    ).toEqual({ scenario: "s", correct_answer: "B", status: "review" });
  });

  it("rejects non-objects, empty patches and bad statuses", () => {
    expect(pickWritableMcqFields(null)).toBeNull();
    expect(pickWritableMcqFields([1])).toBeNull();
    expect(pickWritableMcqFields({ id: "x" })).toBeNull();
    expect(pickWritableMcqFields({ status: "deleted" })).toBeNull();
  });
});

describe("parseMcqAdminListFilters", () => {
  it("parses and clamps", () => {
    const f = parseMcqAdminListFilters(
      new URLSearchParams(
        "status=review&audience=board&exam_source=%20X%20&missing_detailed=1&order=asc&offset=-5&limit=99999",
      ),
    );
    expect(f).toMatchObject({
      status: "review",
      audience: "board",
      exam_source: "X",
      missing_detailed: true,
      order: "asc",
      offset: 0,
      limit: 1000,
    });
  });

  it("drops invalid enums and defaults", () => {
    const f = parseMcqAdminListFilters(new URLSearchParams("status=nope&audience=x&limit=abc"));
    expect(f.status).toBeUndefined();
    expect(f.audience).toBeUndefined();
    expect(f.order).toBe("desc");
    expect(f.limit).toBe(1000);
    expect(f.missing_detailed).toBe(false);
  });

  it("only list views are accepted on the collection route", () => {
    expect(isMcqAdminListView("list")).toBe(true);
    expect(isMcqAdminListView("detail")).toBe(false);
    expect(isMcqAdminListView(null)).toBe(false);
  });
});

describe("mcq-public helpers", () => {
  it("toPublicQuestion strips every answer column", () => {
    const q = toPublicQuestion({
      id: "1",
      scenario: "s",
      correct_answer: "A",
      explanation: "e",
      detailed_explanation: null,
      ai_notes: "n",
    });
    expect(q).toEqual({ id: "1", scenario: "s" });
  });

  it("toAnswerKey normalises missing explanations", () => {
    expect(
      toAnswerKey({ correct_answer: "C", explanation: undefined as unknown as null, detailed_explanation: null }),
    ).toEqual({ correct_answer: "C", explanation: null, detailed_explanation: null });
  });

  it("isChoiceLabel accepts single A-J letters only", () => {
    expect(isChoiceLabel("A")).toBe(true);
    expect(isChoiceLabel("J")).toBe(true);
    expect(isChoiceLabel("K")).toBe(false);
    expect(isChoiceLabel("a")).toBe(false);
    expect(isChoiceLabel(1)).toBe(false);
  });
});
