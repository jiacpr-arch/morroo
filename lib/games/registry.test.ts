import { describe, expect, it } from "vitest";
import { AUDIENCE_GROUPS, HUB_GAMES, gamesForAudience } from "./registry";

describe("games hub registry", () => {
  it("has unique game ids (used as analytics target + utm_content)", () => {
    const ids = HUB_GAMES.map((g) => g.id);
    expect(new Set(ids).size).toBe(ids.length);
  });

  it("only links to https URLs under *.morroo.com", () => {
    // hub เป็นป้ายบอกทางของ constellation เดียวกัน — กันลิงก์หลุดไปโดเมนอื่น
    // และกัน href แบบ relative ที่จะพังเมื่อเสิร์ฟบน subdomain
    for (const g of HUB_GAMES) {
      expect(g.href, g.id).toMatch(/^https:\/\/([a-z0-9-]+\.)*morroo\.com(\/|$)/);
    }
  });

  it("every audience group has at least one featured game", () => {
    for (const group of AUDIENCE_GROUPS) {
      const { featured } = gamesForAudience(group.id);
      expect(featured.length, group.id).toBeGreaterThan(0);
    }
  });

  it("every game belongs to a declared audience group", () => {
    const groupIds = new Set(AUDIENCE_GROUPS.map((g) => g.id));
    for (const g of HUB_GAMES) {
      expect(groupIds.has(g.audience), `${g.id} → ${g.audience}`).toBe(true);
    }
  });
});
