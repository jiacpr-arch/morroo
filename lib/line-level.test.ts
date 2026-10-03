import { describe, expect, it, vi } from "vitest";
import { buildLevelMenu, handleLevelPostback, isLevelMenuText, levelMenuFor } from "./line-level";

function fakeSupabase(opts: { profile?: { id: string; target_exam: string | null } | null; updateError?: boolean } = {}) {
  const { profile = { id: "u1", target_exam: null }, updateError = false } = opts;
  const eqUpdate = vi.fn(() => Promise.resolve({ error: updateError ? { message: "boom" } : null }));
  const update = vi.fn(() => ({ eq: eqUpdate }));
  const client = {
    from(table: string) {
      if (table !== "profiles") throw new Error(`unexpected table: ${table}`);
      return {
        select: () => ({
          eq: () => ({ limit: () => Promise.resolve({ data: profile ? [profile] : [] }) }),
        }),
        update,
      };
    },
  };
  return { client, update, eqUpdate };
}

const NOW = new Date("2026-10-03T03:00:00Z");

describe("isLevelMenuText", () => {
  it("matches exact menu words only", () => {
    expect(isLevelMenuText(" เปลี่ยนระดับ ")).toBe(true);
    expect(isLevelMenuText("Level")).toBe(true);
    expect(isLevelMenuText("ระดับ NL1 ต้องอ่านอะไร")).toBe(false);
  });
});

describe("buildLevelMenu", () => {
  it("offers every level as a quick reply within LINE's 20-char label cap", () => {
    const msg = buildLevelMenu("both"); // legacy value shows its new name
    if (msg.type !== "text") throw new Error("expected text");
    const items = msg.quickReply?.items ?? [];
    expect(items).toHaveLength(5);
    for (const i of items) {
      if (i.action.type !== "postback") throw new Error("expected postback");
      expect(i.action.label.length).toBeLessThanOrEqual(20);
      expect(i.action.data).toMatch(/^action=set_level&v=/);
    }
    expect(msg.text).toContain("ส่วนที่ 1");
  });
});

describe("handleLevelPostback", () => {
  it("returns null for other actions", async () => {
    const { client } = fakeSupabase();
    expect(await handleLevelPostback(client as never, "U1", "action=daily_answer&c=A")).toBeNull();
  });

  it("shows the menu for a linked user and asks to link otherwise", async () => {
    const linked = await handleLevelPostback(fakeSupabase().client as never, "U1", "action=level_menu");
    expect(linked?.[0]).toMatchObject({ type: "text" });
    expect((linked?.[0] as { quickReply?: unknown }).quickReply).toBeTruthy();

    const unlinked = await levelMenuFor(fakeSupabase({ profile: null }).client as never, "U1");
    expect((unlinked[0] as { text: string }).text).toContain("MORROO-");
  });

  it("saves a valid level and reports the next exam for it", async () => {
    const { client, update, eqUpdate } = fakeSupabase();
    const reply = await handleLevelPostback(client as never, "U1", "action=set_level&v=NL2", NOW);
    expect(update).toHaveBeenCalledWith({ target_exam: "NL2" });
    expect(eqUpdate).toHaveBeenCalledWith("id", "u1");
    const text = (reply?.[0] as { text: string }).text;
    expect(text).toContain("NL2 เดิม");
    expect(text).toContain("NL ขั้นตอนที่ 2 รอบ 4/2569"); // next nl2 round after 3 Oct 2026
  });

  it("rejects an unknown level without touching the DB", async () => {
    const { client, update } = fakeSupabase();
    const reply = await handleLevelPostback(client as never, "U1", "action=set_level&v=NL1", NOW); // retired level
    expect(update).not.toHaveBeenCalled();
    expect((reply?.[0] as { text: string }).text).toContain("ไม่รู้จัก");
  });

  it("does not save for an unlinked LINE user", async () => {
    const { client, update } = fakeSupabase({ profile: null });
    const reply = await handleLevelPostback(client as never, "U1", "action=set_level&v=part1", NOW);
    expect(update).not.toHaveBeenCalled();
    expect((reply?.[0] as { text: string }).text).toContain("MORROO-");
  });

  it("reports a failed save", async () => {
    const { client } = fakeSupabase({ updateError: true });
    vi.spyOn(console, "error").mockImplementation(() => {});
    const reply = await handleLevelPostback(client as never, "U1", "action=set_level&v=part1", NOW);
    expect((reply?.[0] as { text: string }).text).toContain("ไม่สำเร็จ");
  });
});
