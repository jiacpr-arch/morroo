import { describe, it, expect, vi } from "vitest";
import {
  linePlaceholderEmail,
  resolveOrCreateLineUser,
  linkLineToUser,
  establishSessionFor,
} from "./line-auth";

/** Minimal Supabase query-builder stand-in: any chained call returns itself,
 * `maybeSingle()`/`single()` resolve to `result`, and awaiting the chain
 * directly (as the update/upsert call sites in line-auth.ts do) also
 * resolves to `result`. Mirrors the mock pattern already used for the real
 * admin client in lib/supabase/admin.ts. */
function makeChain(result: { data: unknown; error: unknown }): unknown {
  const handler: ProxyHandler<object> = {
    get(_target, prop) {
      if (prop === "then") {
        return (resolve: (v: unknown) => unknown, reject?: (e: unknown) => unknown) =>
          Promise.resolve(result).then(resolve, reject);
      }
      if (prop === "maybeSingle" || prop === "single") {
        return async () => result;
      }
      return () => makeChain(result);
    },
  };
  return new Proxy({}, handler);
}

interface QueryResult {
  data: unknown;
  error: unknown;
}

/** Fake admin client whose `.from("profiles")` calls consume `profilesQueue`
 * in call order — each test lists exactly the results its code path needs,
 * in the order line-auth.ts issues the queries. */
function makeAdminMock(
  profilesQueue: QueryResult[],
  authAdmin: {
    createUser?: () => Promise<unknown>;
    generateLink?: () => Promise<unknown>;
  } = {}
) {
  const queue = [...profilesQueue];
  return {
    from: vi.fn((_table: string) => {
      const result = queue.shift() ?? { data: null, error: null };
      return makeChain(result);
    }),
    auth: {
      admin: {
        createUser:
          authAdmin.createUser ??
          vi.fn(async () => ({ data: { user: null }, error: { message: "createUser not stubbed" } })),
        generateLink:
          authAdmin.generateLink ??
          vi.fn(async () => ({ data: null, error: { message: "generateLink not stubbed" } })),
      },
    },
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
  } as any;
}

describe("linePlaceholderEmail", () => {
  it("uses the line.morroo.com domain the rest of the codebase already expects", () => {
    // app/api/auth/line/callback/route.ts and the "is this a real email"
    // check in app/api/line/expiry-warning both assume this exact domain.
    expect(linePlaceholderEmail("U123")).toBe("line_U123@line.morroo.com");
  });
});

describe("resolveOrCreateLineUser", () => {
  it("returns the existing account when line_user_id already matches", async () => {
    const admin = makeAdminMock([{ data: { id: "u1", email: "doc@example.com" }, error: null }]);

    const result = await resolveOrCreateLineUser(admin, {
      lineUserId: "U1",
      email: null,
    });

    expect(result).toEqual({ userId: "u1", email: "doc@example.com", isNewSignup: false });
  });

  it("links onto an existing account found by email when line_user_id doesn't match yet", async () => {
    const admin = makeAdminMock([
      { data: null, error: null }, // by line_user_id — not found
      { data: { id: "u2" }, error: null }, // by email — found
      { data: null, error: null }, // update
    ]);

    const result = await resolveOrCreateLineUser(admin, {
      lineUserId: "U2",
      email: "real@example.com",
    });

    expect(result).toEqual({ userId: "u2", email: "real@example.com", isNewSignup: false });
  });

  it("creates a new account with a placeholder email when the ID token has none", async () => {
    const createUser = vi.fn(async () => ({ data: { user: { id: "u3" } }, error: null }));
    const admin = makeAdminMock(
      [
        { data: null, error: null }, // by line_user_id
        { data: null, error: null }, // by email
        { data: null, error: null }, // upsert profile
      ],
      { createUser }
    );

    const result = await resolveOrCreateLineUser(admin, {
      lineUserId: "U9",
      displayName: "Dr. Test",
      email: null,
    });

    expect(result).toEqual({
      userId: "u3",
      email: "line_U9@line.morroo.com",
      isNewSignup: true,
    });
    expect(createUser).toHaveBeenCalledWith(
      expect.objectContaining({ email: "line_U9@line.morroo.com" })
    );
  });

  it("surfaces a lookup error instead of proceeding", async () => {
    const admin = makeAdminMock([{ data: null, error: { message: "db down" } }]);

    const result = await resolveOrCreateLineUser(admin, { lineUserId: "U1", email: null });

    expect(result).toEqual({ error: "line_lookup_failed" });
  });

  it("surfaces a create error when Supabase user creation fails", async () => {
    const createUser = vi.fn(async () => ({ data: { user: null }, error: { message: "conflict" } }));
    const admin = makeAdminMock(
      [
        { data: null, error: null },
        { data: null, error: null },
      ],
      { createUser }
    );

    const result = await resolveOrCreateLineUser(admin, { lineUserId: "U1", email: null });

    expect(result).toEqual({ error: "line_create_failed" });
  });
});

describe("linkLineToUser", () => {
  it("no-ops when the LINE identity is already linked to this same user", async () => {
    const admin = makeAdminMock([{ data: { id: "u1" }, error: null }]);

    const result = await linkLineToUser(admin, "u1", "LINE1");

    expect(result).toEqual({ ok: true });
  });

  it("refuses to steal a LINE identity already linked to a different account", async () => {
    const admin = makeAdminMock([{ data: { id: "other-user" }, error: null }]);

    const result = await linkLineToUser(admin, "u1", "LINE1");

    expect(result).toEqual({ ok: false, reason: "already_linked_other" });
  });

  it("links an unlinked LINE identity onto the given user", async () => {
    const admin = makeAdminMock([
      { data: null, error: null }, // no existing link
      { data: null, error: null }, // update
    ]);

    const result = await linkLineToUser(admin, "u1", "LINE1");

    expect(result).toEqual({ ok: true });
  });

  it("reports an error when the existing-link lookup fails", async () => {
    const admin = makeAdminMock([{ data: null, error: { message: "db down" } }]);

    const result = await linkLineToUser(admin, "u1", "LINE1");

    expect(result).toEqual({ ok: false, reason: "error" });
  });

  it("reports an error when the update itself fails", async () => {
    const admin = makeAdminMock([
      { data: null, error: null },
      { data: null, error: { message: "db down" } },
    ]);

    const result = await linkLineToUser(admin, "u1", "LINE1");

    expect(result).toEqual({ ok: false, reason: "error" });
  });
});

describe("establishSessionFor", () => {
  it("verifies the generated magic link and reports success", async () => {
    const generateLink = vi.fn(async () => ({
      data: { properties: { hashed_token: "hashed-token" } },
      error: null,
    }));
    const admin = makeAdminMock([], { generateLink });
    const verifyOtp = vi.fn(async () => ({ error: null }));
    const serverSupabase = { auth: { verifyOtp } } as unknown as Parameters<
      typeof establishSessionFor
    >[1];

    const result = await establishSessionFor(
      admin,
      serverSupabase,
      "doc@example.com",
      "https://www.morroo.com/auth/callback"
    );

    expect(result).toEqual({ ok: true });
    expect(generateLink).toHaveBeenCalledWith(
      expect.objectContaining({
        type: "magiclink",
        email: "doc@example.com",
        options: { redirectTo: "https://www.morroo.com/auth/callback" },
      })
    );
    expect(verifyOtp).toHaveBeenCalledWith({
      type: "magiclink",
      token_hash: "hashed-token",
    });
  });

  it("fails when generateLink doesn't return a usable token", async () => {
    const generateLink = vi.fn(async () => ({ data: null, error: { message: "boom" } }));
    const admin = makeAdminMock([], { generateLink });
    const serverSupabase = {
      auth: { verifyOtp: vi.fn() },
    } as unknown as Parameters<typeof establishSessionFor>[1];

    const result = await establishSessionFor(admin, serverSupabase, "doc@example.com", "https://x/y");

    expect(result).toEqual({ ok: false, error: "line_session_failed" });
  });

  it("fails when verifyOtp rejects the token", async () => {
    const generateLink = vi.fn(async () => ({
      data: { properties: { hashed_token: "hashed-token" } },
      error: null,
    }));
    const admin = makeAdminMock([], { generateLink });
    const verifyOtp = vi.fn(async () => ({ error: { message: "expired" } }));
    const serverSupabase = { auth: { verifyOtp } } as unknown as Parameters<
      typeof establishSessionFor
    >[1];

    const result = await establishSessionFor(admin, serverSupabase, "doc@example.com", "https://x/y");

    expect(result).toEqual({ ok: false, error: "line_session_failed" });
  });
});
