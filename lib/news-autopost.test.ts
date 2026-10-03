import { beforeEach, describe, expect, it, vi } from "vitest";

const postToFacebook = vi.fn();
const broadcast = vi.fn();
let row: Record<string, unknown> | null = null;

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: () => ({
    from: () => ({
      select: () => ({ eq: () => ({ single: () => Promise.resolve({ data: row, error: row ? null : { message: "x" } }) }) }),
      update: () => ({ eq: () => Promise.resolve({ error: null }) }),
    }),
  }),
}));
vi.mock("@/lib/facebook", () => ({ postToFacebook: (...a: unknown[]) => postToFacebook(...a) }));
vi.mock("@/lib/line", () => ({ broadcastLineMessages: (...a: unknown[]) => broadcast(...a) }));

import { autopostNewsItem } from "./news-autopost";

beforeEach(() => {
  postToFacebook.mockReset().mockResolvedValue("fb1");
  broadcast.mockReset().mockResolvedValue({ ok: true });
  process.env.LINE_AUTOPOST_ENABLED = "true";
});

const base = { id: "n1", title: "t", summary: "s", cover_image: null, fb_post_id: null, line_broadcast_at: null };

describe("autopostNewsItem", () => {
  it("never posts an auto-ingested item to Facebook or LINE", async () => {
    row = { ...base, origin: "auto" };
    const res = await autopostNewsItem("n1");
    expect(res).toEqual({ fb: "skipped:auto_origin", line: "skipped:auto_origin" });
    expect(postToFacebook).not.toHaveBeenCalled();
    expect(broadcast).not.toHaveBeenCalled();
  });

  it("still posts a manual item", async () => {
    row = { ...base, origin: "manual" };
    const res = await autopostNewsItem("n1");
    expect(res.fb).toBe("posted:fb1");
    expect(postToFacebook).toHaveBeenCalledTimes(1);
    expect(broadcast).toHaveBeenCalledTimes(1);
  });
});
