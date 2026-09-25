import { describe, it, expect, vi, beforeEach, afterEach } from "vitest";
import { NextRequest } from "next/server";

const updateSession = vi.fn();
vi.mock("@/lib/supabase/middleware", () => ({
  updateSession: (...args: unknown[]) => updateSession(...args),
}));
vi.mock("@/lib/meta/events-api", () => ({ sendMetaEvent: vi.fn() }));

import { middleware } from "./middleware";

const savedUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;

beforeEach(() => {
  updateSession.mockReset();
  // Stand-in for a logged-in user with onboarding_done = false.
  updateSession.mockImplementation(async (req: NextRequest) =>
    Response.redirect(new URL("/onboarding", req.url), 307)
  );
  process.env.NEXT_PUBLIC_SUPABASE_URL = "https://example.supabase.co";
});

afterEach(() => {
  if (savedUrl === undefined) delete process.env.NEXT_PUBLIC_SUPABASE_URL;
  else process.env.NEXT_PUBLIC_SUPABASE_URL = savedUrl;
});

function req(url: string) {
  const u = new URL(url);
  return new NextRequest(u, { headers: { host: u.host } });
}

describe("middleware PWA assets", () => {
  it("serves /sw.js and the manifest without touching the session", async () => {
    for (const path of ["/sw.js", "/manifest.webmanifest"]) {
      const res = await middleware(req(`https://www.morroo.com${path}`));
      expect(res.status).toBe(200);
      expect(res.headers.get("location")).toBeNull();
    }
    expect(updateSession).not.toHaveBeenCalled();
  });

  it("keeps the firstaid host rewrite for /sw.js", async () => {
    const res = await middleware(req("https://firstaid.morroo.com/sw.js"));
    expect(res.headers.get("x-middleware-rewrite")).toBe(
      "https://firstaid.morroo.com/firstaid/sw.js"
    );
    expect(updateSession).not.toHaveBeenCalled();
  });

  it("still runs the session refresh for pages", async () => {
    const res = await middleware(req("https://www.morroo.com/profile"));
    expect(res.status).toBe(307);
    expect(updateSession).toHaveBeenCalledTimes(1);
  });
});
