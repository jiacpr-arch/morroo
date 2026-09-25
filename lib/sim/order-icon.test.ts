import { describe, expect, it } from "vitest";
import { orderIcon } from "./order-icon";

describe("orderIcon", () => {
  it("maps common order types to an icon", () => {
    expect(orderIcon("Emergency surgical exploration within 6 hours")).toBe("🔪");
    expect(orderIcon("IV labetalol to HR<60")).toBe("💉");
    expect(orderIcon("STAT CT angio")).toBe("🧪");
    expect(orderIcon("ปรึกษา CVT surgery emergent")).toBe("📞");
    expect(orderIcon("แผนการรักษาครบแล้ว ส่งเวรได้")).toBe("📋");
    expect(orderIcon("Paracetamol 500 mg oral prn")).toBe("💊");
  });
});
