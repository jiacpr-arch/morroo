import { describe, expect, it } from "vitest";
import {
  applyFx,
  createInitialState,
  currentEtco2,
  fmtTime,
  getDifficulty,
  gradeFor,
  nextNode,
  recordCorrect,
  recordWrong,
  scoreFor,
  shuffled,
} from "./engine";
import { isValidScenario, parseEmphasis } from "./types";
import { SIM_SCENARIOS } from "./scenarios";
import type { StoryNode } from "./types";

describe("createInitialState", () => {
  it("uses difficulty hp and defaults", () => {
    const easy = createInitialState("easy");
    expect(easy.hp).toBe(7);
    expect(easy.maxHp).toBe(7);
    expect(easy.rhythm).toBe("flat");
    const unknown = createInitialState("nope");
    expect(unknown.difficulty).toBe("normal");
    expect(unknown.hp).toBe(getDifficulty("normal").hp);
  });
});

describe("applyFx", () => {
  it("records first CPR/shock times once", () => {
    const st = createInitialState();
    st.simTime = 30;
    applyFx(st, { cpr: true, firstCPR: true });
    expect(st.cpr).toBe(true);
    expect(st.firstCPRAt).toBe(30);
    st.simTime = 90;
    applyFx(st, { firstCPR: true });
    expect(st.firstCPRAt).toBe(30);
    applyFx(st, { shock: true });
    expect(st.shocks).toBe(1);
    expect(st.firstShockAt).toBe(90);
    expect(st.cpr).toBe(false); // shock หยุด CPR ชั่วคราว
  });

  it("rosc normalises rhythm and stops cpr/alarm", () => {
    const st = createInitialState();
    applyFx(st, { alarm: true, cpr: true, rhythm: "vf" });
    applyFx(st, { rosc: true });
    expect(st.rosc).toBe(true);
    expect(st.rhythm).toBe("nsr");
    expect(st.cpr).toBe(false);
    expect(st.alarm).toBe(false);
  });
});

describe("nextNode", () => {
  it("drains queue before main story", () => {
    const st = createInitialState();
    const story: StoryNode[] = [{ inter: "A" }, { end: true }];
    const queued: StoryNode = { inter: "Q" };
    st.queue.push(queued);
    expect(nextNode(st, story)).toBe(queued);
    expect(nextNode(st, story)).toEqual({ inter: "A" });
    expect(nextNode(st, story)).toEqual({ end: true });
    expect(nextNode(st, story)).toBeNull();
  });
});

describe("record + grade + score", () => {
  it("correct answers push then-nodes and advance clock", () => {
    const st = createInitialState();
    const then: StoryNode[] = [{ inter: "X" }];
    recordCorrect(st, { tgt: "YOU", label: "ok", ok: true, then });
    expect(st.simTime).toBe(8);
    expect(st.queue).toEqual(then);
    expect(st.timeline[0].ok).toBe(true);
  });

  it("wrong answers cost hp and time; hp floors at 0", () => {
    const st = createInitialState("hard"); // hp 3
    for (let i = 0; i < 5; i++) {
      recordWrong(st, { tgt: "X", label: "bad", ok: false, why: "เหตุผล" });
    }
    expect(st.hp).toBe(0);
    expect(st.wrong).toBe(5);
    expect(st.simTime).toBe(100);
    expect(st.timeline.every((t) => !t.ok)).toBe(true);
  });

  it("grades by wrong count, stricter on hard", () => {
    const st = createInitialState("normal");
    expect(gradeFor(st, false)).toBe("C");
    expect(gradeFor(st, true)).toBe("S");
    st.wrong = 1;
    expect(gradeFor(st, true)).toBe("A");
    st.wrong = 3;
    expect(gradeFor(st, true)).toBe("B");
    st.wrong = 4;
    expect(gradeFor(st, true)).toBe("C");
    const hard = createInitialState("hard");
    hard.wrong = 1;
    expect(gradeFor(hard, true)).toBe("B");
  });

  it("score decays with mistakes, zero on loss", () => {
    const st = createInitialState();
    expect(scoreFor(st, true)).toBe(100);
    st.wrong = 2;
    expect(scoreFor(st, true)).toBe(70);
    st.wrong = 99;
    expect(scoreFor(st, true)).toBe(10);
    expect(scoreFor(st, false)).toBe(0);
  });
});

describe("etco2 model", () => {
  it("tracks cpr quality and rosc", () => {
    const st = createInitialState();
    expect(currentEtco2(st)).toBe(0);
    st.cpr = true;
    expect(currentEtco2(st)).toBe(16);
    st.wrong = 3;
    expect(currentEtco2(st)).toBe(10);
    st.wrong = 10;
    expect(currentEtco2(st)).toBe(6); // floor
    st.rosc = true;
    expect(currentEtco2(st)).toBe(40);
  });
});

describe("fmtTime / shuffled", () => {
  it("formats mm:ss and dashes for negatives", () => {
    expect(fmtTime(-1)).toBe("--:--");
    expect(fmtTime(0)).toBe("00:00");
    expect(fmtTime(125)).toBe("02:05");
  });

  it("shuffled keeps all members", () => {
    const arr = [1, 2, 3, 4, 5];
    expect([...shuffled(arr)].sort()).toEqual(arr);
  });
});

describe("parseEmphasis", () => {
  it("splits **em** segments without HTML", () => {
    expect(parseEmphasis("ก่อน **เน้น** หลัง")).toEqual([
      { em: false, text: "ก่อน " },
      { em: true, text: "เน้น" },
      { em: false, text: " หลัง" },
    ]);
    expect(parseEmphasis("ธรรมดา")).toEqual([{ em: false, text: "ธรรมดา" }]);
  });
});

describe("built-in scenarios", () => {
  it("all pass the scenario validator", () => {
    for (const s of SIM_SCENARIOS) {
      expect(isValidScenario(s)).toBe(true);
    }
  });

  it("every choice has exactly one correct option and playable happy path", () => {
    for (const s of SIM_SCENARIOS) {
      const st = createInitialState();
      let node = nextNode(st, s.story);
      let ended = false;
      let guard = 0;
      while (node && guard++ < 500) {
        if ("say" in node) applyFx(st, node.say.fx);
        if ("inter" in node) applyFx(st, node.fx);
        if ("choice" in node) {
          const oks = node.choice.options.filter((o) => o.ok);
          expect(oks).toHaveLength(1);
          recordCorrect(st, oks[0]);
        }
        if ("end" in node) ended = true;
        node = nextNode(st, s.story);
      }
      expect(ended).toBe(true);
      expect(st.rosc).toBe(true); // เดินทางถูกทุกข้อต้องจบด้วย ROSC
    }
  });
});
