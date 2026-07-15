import { describe, expect, it } from "vitest";
import {
  DIFFICULTY,
  MAX_HP,
  armTool,
  createInitialState,
  currentStep,
  currentZone,
  fmtTime,
  getDifficulty,
  gradeFor,
  holdTick,
  pointerDown,
  pointerMove,
  pointerUp,
  scoreFor,
  starsFor,
  tick,
} from "./engine";
import { CASES, getBuiltinCase } from "./cases";
import { tracePoints, zoneCenter } from "./geometry";
import {
  FIELD_H,
  FIELD_W,
  TOOL_CATALOG,
  isValidOperation,
  type Operation,
  type Zone,
} from "./types";

// ด่านสังเคราะห์เล็กๆ ครอบ gesture ทุกแบบ — ใช้เทสต์ flow โดยไม่ผูกกับด่านจริง
const TEST_OP: Operation = {
  slug: "test-op",
  title: "ด่านทดสอบ",
  subtitle: "",
  patient: { name: "ทดสอบ", age: 1, story: "" },
  artId: "laceration",
  tools: ["gauze", "saline", "syringe_lidocaine", "scalpel"],
  parTimeSec: 60,
  hpDrainPerSec: 2,
  wrongToolDamage: 8,
  wrongZoneDamage: 3,
  steps: [
    {
      id: "s1",
      title: "กดห้ามเลือด",
      tool: "gauze",
      zone: { shape: "circle", cx: 100, cy: 100, r: 50 },
      gesture: { kind: "hold", ms: 1000 },
      bleeding: true,
      why: "กดก่อน",
    },
    {
      id: "s2",
      title: "ฉีดยา 2 จุด",
      tool: "syringe_lidocaine",
      zone: { shape: "circle", cx: 300, cy: 100, r: 100 },
      subZones: [
        { shape: "circle", cx: 260, cy: 100, r: 30 },
        { shape: "circle", cx: 340, cy: 100, r: 30 },
      ],
      gesture: { kind: "tap" },
      why: "ฉีดรอบๆ",
    },
    {
      id: "s3",
      title: "ล้างแผล",
      tool: "saline",
      zone: { shape: "rect", x: 0, y: 200, w: 400, h: 100 },
      gesture: { kind: "trace", path: [[50, 250], [350, 250]], tolerance: 30 },
      why: "ล้างให้สะอาด",
    },
  ],
};

const center = (z: Zone) => zoneCenter(z);

function freshState(diff = "normal") {
  const st = createInitialState(diff);
  return st;
}

describe("createInitialState / difficulty", () => {
  it("เริ่มที่ step 0, HP เต็ม, ไม่มีเครื่องมือ", () => {
    const st = freshState();
    expect(st.stepIdx).toBe(0);
    expect(st.hp).toBe(MAX_HP);
    expect(st.activeTool).toBeNull();
    expect(st.done).toBe(false);
  });

  it("difficulty ที่ไม่รู้จัก fallback เป็น normal", () => {
    expect(getDifficulty("nonsense").id).toBe("normal");
  });
});

describe("tick — เลือดไหลเฉพาะ step ที่ bleeding", () => {
  it("step แรก (bleeding) HP ลดตาม drain × ตัวคูณความยาก", () => {
    const st = freshState("normal");
    tick(st, TEST_OP, 1);
    expect(st.hp).toBeCloseTo(MAX_HP - 2);
    const easy = freshState("easy");
    tick(easy, TEST_OP, 1);
    expect(easy.hp).toBeCloseTo(MAX_HP - 1);
    const hard = freshState("hard");
    tick(hard, TEST_OP, 1);
    expect(hard.hp).toBeCloseTo(MAX_HP - 3);
  });

  it("เลือดไหลจนตาย → op_failed และ dead", () => {
    const st = freshState("normal");
    let out = tick(st, TEST_OP, 1);
    for (let i = 0; i < 200 && out.kind !== "op_failed"; i++) {
      out = tick(st, TEST_OP, 1);
    }
    expect(out.kind).toBe("op_failed");
    expect(st.dead).toBe(true);
    expect(st.hp).toBe(0);
  });

  it("step ที่ไม่ bleeding HP คงที่ แต่เวลาเดิน", () => {
    const st = freshState();
    st.stepIdx = 1; // s2 ไม่ bleeding
    tick(st, TEST_OP, 5);
    expect(st.hp).toBe(MAX_HP);
    expect(st.elapsed).toBe(5);
  });
});

describe("pointerDown — เครื่องมือ/ตำแหน่ง", () => {
  it("ไม่ arm เครื่องมือ → noop ไม่หัก HP", () => {
    const st = freshState();
    const out = pointerDown(st, TEST_OP, center(TEST_OP.steps[0].zone));
    expect(out.kind).toBe("noop");
    expect(st.hp).toBe(MAX_HP);
  });

  it("เครื่องมือผิด → wrong_tool, หัก HP เต็ม, นับพลาด", () => {
    const st = freshState();
    armTool(st, "scalpel");
    const out = pointerDown(st, TEST_OP, center(TEST_OP.steps[0].zone));
    expect(out.kind).toBe("wrong_tool");
    expect(st.hp).toBe(MAX_HP - 8);
    expect(st.wrong).toBe(1);
  });

  it("ถูกเครื่องมือ ผิดตำแหน่ง → wrong_zone, หักเบา", () => {
    const st = freshState();
    armTool(st, "gauze");
    const out = pointerDown(st, TEST_OP, { x: 900, y: 700 });
    expect(out.kind).toBe("wrong_zone");
    expect(st.hp).toBe(MAX_HP - 3);
    expect(st.wrong).toBe(1);
  });

  it("โหมดง่ายหักดาเมจครึ่งเดียว", () => {
    const st = freshState("easy");
    armTool(st, "scalpel");
    pointerDown(st, TEST_OP, center(TEST_OP.steps[0].zone));
    expect(st.hp).toBe(MAX_HP - 4);
  });

  it("wrongToolWhy ถูกส่งเป็น note เมื่อกำหนดไว้", () => {
    const op = getBuiltinCase("suture-laceration-01")!;
    const st = freshState();
    armTool(st, "suture_set");
    const out = pointerDown(st, op, center(op.steps[0].zone));
    expect(out.kind).toBe("wrong_tool");
    if (out.kind === "wrong_tool") expect(out.note).toContain("ห้ามเลือด");
  });
});

describe("gesture: hold", () => {
  it("กดค้างครบเวลา → step_done และ progress รีเซ็ต", () => {
    const st = freshState();
    armTool(st, "gauze");
    expect(pointerDown(st, TEST_OP, center(TEST_OP.steps[0].zone)).kind).toBe("step_progress");
    let out = holdTick(st, TEST_OP, 500);
    expect(out.kind).toBe("step_progress");
    out = holdTick(st, TEST_OP, 600);
    expect(out.kind).toBe("step_done");
    expect(st.stepIdx).toBe(1);
    expect(st.holdMs).toBe(0);
  });

  it("ปล่อยก่อนครบ → รีเซ็ต ไม่ลงโทษ", () => {
    const st = freshState();
    armTool(st, "gauze");
    pointerDown(st, TEST_OP, center(TEST_OP.steps[0].zone));
    holdTick(st, TEST_OP, 700);
    pointerUp(st);
    expect(st.holdMs).toBe(0);
    expect(st.wrong).toBe(0);
    expect(st.stepIdx).toBe(0);
  });
});

describe("gesture: tap + subZones", () => {
  function toStep2(st = freshState()) {
    st.stepIdx = 1;
    armTool(st, "syringe_lidocaine");
    return st;
  }

  it("เป้าย่อยต้องทำตามลำดับ — จุดสองก่อนจุดหนึ่ง = wrong_zone", () => {
    const st = toStep2();
    const out = pointerDown(st, TEST_OP, { x: 340, y: 100 });
    expect(out.kind).toBe("wrong_zone");
  });

  it("จุดแรก sub_done → จุดสอง step_done", () => {
    const st = toStep2();
    expect(pointerDown(st, TEST_OP, { x: 260, y: 100 }).kind).toBe("sub_done");
    expect(st.subIdx).toBe(1);
    expect(pointerDown(st, TEST_OP, { x: 340, y: 100 }).kind).toBe("step_done");
    expect(st.stepIdx).toBe(2);
    expect(st.subIdx).toBe(0);
  });
});

describe("gesture: trace", () => {
  function toStep3(st = freshState()) {
    st.stepIdx = 2;
    armTool(st, "saline");
    return st;
  }

  it("ลากครบเส้น → op_done (step สุดท้าย) และ done", () => {
    const st = toStep3();
    expect(pointerDown(st, TEST_OP, { x: 50, y: 250 }).kind).toBe("step_progress");
    let last = "";
    for (let x = 60; x <= 350; x += 10) {
      const out = pointerMove(st, TEST_OP, { x, y: 250 });
      last = out.kind;
      if (out.kind === "op_done") break;
    }
    expect(last).toBe("op_done");
    expect(st.done).toBe(true);
  });

  it("ลากนอกเส้น — progress ไม่เดิน ไม่ลงโทษ", () => {
    const st = toStep3();
    pointerDown(st, TEST_OP, { x: 50, y: 250 });
    const before = st.tracePct;
    pointerMove(st, TEST_OP, { x: 200, y: 290 }); // ใน zone แต่ไกลเส้นเกิน tolerance
    expect(st.tracePct).toBe(before);
    expect(st.wrong).toBe(0);
  });

  it("timeline บันทึกขั้นตอนที่สำเร็จพร้อม why", () => {
    const st = toStep3();
    pointerDown(st, TEST_OP, { x: 50, y: 250 });
    for (let x = 60; x <= 350; x += 10) pointerMove(st, TEST_OP, { x, y: 250 });
    const okItems = st.timeline.filter((t) => t.ok);
    expect(okItems.length).toBe(1);
    expect(okItems[0].note).toBe("ล้างให้สะอาด");
  });
});

describe("จบเกม: เกรด/ดาว/คะแนน", () => {
  it("gradeFor ปกติ: 0=S, 1=A, ≤3=B, else C; แพ้ = C", () => {
    const st = freshState();
    expect(gradeFor(st, true)).toBe("S");
    st.wrong = 1;
    expect(gradeFor(st, true)).toBe("A");
    st.wrong = 3;
    expect(gradeFor(st, true)).toBe("B");
    st.wrong = 4;
    expect(gradeFor(st, true)).toBe("C");
    expect(gradeFor(st, false)).toBe("C");
  });

  it("โหมดยากเข้มกว่า: 1 พลาด = B", () => {
    const st = freshState("hard");
    st.wrong = 1;
    expect(gradeFor(st, true)).toBe("B");
  });

  it("ดาว: S=3, A/B=2, C=1, แพ้=0", () => {
    expect(starsFor("S", true)).toBe(3);
    expect(starsFor("A", true)).toBe(2);
    expect(starsFor("B", true)).toBe(2);
    expect(starsFor("C", true)).toBe(1);
    expect(starsFor("S", false)).toBe(0);
  });

  it("score: เพอร์เฟกต์เร็วกว่า par = 150, แพ้ = 0, มี floor 10", () => {
    const st = freshState();
    st.elapsed = 30;
    expect(scoreFor(st, TEST_OP, true)).toBe(150);
    expect(scoreFor(st, TEST_OP, false)).toBe(0);
    st.wrong = 20;
    st.hp = 0;
    st.elapsed = 500;
    expect(scoreFor(st, TEST_OP, true)).toBe(10);
  });

  it("timeBonus ลดลงเชิงเส้นหลัง par และหมดที่ 2×par", () => {
    const st = freshState();
    st.hp = 0; // ตัด hpBonus ออกให้เทสต์ชัด
    st.elapsed = TEST_OP.parTimeSec * 1.5;
    expect(scoreFor(st, TEST_OP, true)).toBe(100 + 15);
    st.elapsed = TEST_OP.parTimeSec * 2;
    expect(scoreFor(st, TEST_OP, true)).toBe(100);
  });
});

describe("fmtTime", () => {
  it("format mm:ss และค่าติดลบเป็น --:--", () => {
    expect(fmtTime(0)).toBe("00:00");
    expect(fmtTime(95)).toBe("01:35");
    expect(fmtTime(-1)).toBe("--:--");
  });
});

// ---- data integrity ของด่าน built-in ทุกด่าน ----

describe("CASES — ความถูกต้องของข้อมูลด่าน", () => {
  it("มี 3 ด่าน slug ไม่ซ้ำ", () => {
    expect(CASES.length).toBe(3);
    expect(new Set(CASES.map((o) => o.slug)).size).toBe(3);
  });

  it.each(CASES.map((op) => [op.slug, op] as const))("%s ผ่าน isValidOperation", (_slug, op) => {
    expect(isValidOperation(op)).toBe(true);
  });

  it.each(CASES.map((op) => [op.slug, op] as const))(
    "%s: tool ของทุก step อยู่บนถาด และทุก tool มีใน TOOL_CATALOG",
    (_slug, op) => {
      for (const tool of op.tools) expect(TOOL_CATALOG[tool]).toBeDefined();
      for (const step of op.steps) {
        expect(op.tools).toContain(step.tool);
        for (const wrongTool of Object.keys(step.wrongToolWhy ?? {})) {
          expect(op.tools).toContain(wrongTool);
        }
      }
    },
  );

  it.each(CASES.map((op) => [op.slug, op] as const))(
    "%s: zone/subZones/trace path อยู่ในกรอบ viewBox",
    (_slug, op) => {
      const inField = (x: number, y: number) =>
        x >= 0 && x <= FIELD_W && y >= 0 && y <= FIELD_H;
      const checkZone = (z: Zone) => {
        const c = zoneCenter(z);
        expect(inField(c.x, c.y)).toBe(true);
      };
      for (const step of op.steps) {
        checkZone(step.zone);
        step.subZones?.forEach(checkZone);
        if (step.gesture.kind === "trace") {
          for (const [x, y] of step.gesture.path) expect(inField(x, y)).toBe(true);
        }
      }
    },
  );

  it.each(CASES.map((op) => [op.slug, op] as const))(
    "%s: trace path เริ่มในเป้า (pointerDown บนจุดแรกของเส้นต้องไม่เป็น wrong_zone)",
    (_slug, op) => {
      for (let i = 0; i < op.steps.length; i++) {
        const step = op.steps[i];
        if (step.gesture.kind !== "trace") continue;
        const st = createInitialState("normal");
        st.stepIdx = i;
        armTool(st, step.tool);
        const [x, y] = step.gesture.path[0];
        const out = pointerDown(st, op, { x, y });
        expect(out.kind, `${op.slug}/${step.id}`).not.toBe("wrong_zone");
      }
    },
  );

  it.each(CASES.map((op) => [op.slug, op] as const))(
    "%s: เล่นจบได้จริงด้วยการทำถูกทุกขั้น (simulation)",
    (_slug, op) => {
      const st = createInitialState("normal");
      let guard = 0;
      while (!st.done && !st.dead && guard++ < 500) {
        const step = currentStep(op, st)!;
        armTool(st, step.tool);
        if (st.activeTool !== step.tool) armTool(st, step.tool); // toggle กลับถ้าปิดเอง
        const zone = currentZone(op, st)!;
        const g = step.gesture;
        if (g.kind === "tap" || g.kind === "taps") {
          pointerDown(st, op, zoneCenter(zone));
        } else if (g.kind === "hold") {
          pointerDown(st, op, zoneCenter(zone));
          holdTick(st, op, g.ms + 50);
        } else {
          const pts = tracePoints(g.path, 12);
          pointerDown(st, op, pts[0]);
          for (const p of pts) pointerMove(st, op, p);
        }
        st.activeTool = null;
      }
      expect(st.done, `${op.slug} เล่นไม่จบใน ${guard} รอบ`).toBe(true);
      expect(st.wrong).toBe(0);
      expect(gradeFor(st, true)).toBe("S");
    },
  );
});

describe("DIFFICULTY มีครบ 3 ระดับ", () => {
  it("easy/normal/hard และ label ไทย", () => {
    expect(Object.keys(DIFFICULTY)).toEqual(["easy", "normal", "hard"]);
    expect(DIFFICULTY.easy.label).toBe("ง่าย");
  });
});
