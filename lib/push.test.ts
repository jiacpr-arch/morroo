import { describe, it, expect, vi, beforeEach, afterEach } from "vitest";

vi.mock("web-push", () => {
  const sendNotification = vi.fn();
  const setVapidDetails = vi.fn();
  return { default: { sendNotification, setVapidDetails }, sendNotification, setVapidDetails };
});

import webpush from "web-push";
import {
  isGoneError,
  isPushConfigured,
  parseSubscriptionJson,
  sendPushToSubscriptions,
  sendPushToUser,
  type PushSubscriptionRow,
} from "./push";

const sendNotification = vi.mocked(webpush.sendNotification);
const setVapidDetails = vi.mocked(webpush.setVapidDetails);

const ENV_KEYS = ["NEXT_PUBLIC_VAPID_PUBLIC_KEY", "VAPID_PRIVATE_KEY", "VAPID_SUBJECT"] as const;
const saved: Record<string, string | undefined> = {};

function setVapidEnv() {
  process.env.NEXT_PUBLIC_VAPID_PUBLIC_KEY = "pub";
  process.env.VAPID_PRIVATE_KEY = "priv";
  process.env.VAPID_SUBJECT = "mailto:test@morroo.com";
}

function sub(id: string, userId = "u1"): PushSubscriptionRow {
  return { id, user_id: userId, endpoint: `https://push.example/${id}`, p256dh: "p", auth: "a" };
}

/** Records delete/update calls; select resolves to `rows`. */
function fakeSupabase(rows: PushSubscriptionRow[] = [], deleteError: { message: string } | null = null) {
  const calls = { deleted: [] as string[][], updated: [] as string[][], selectedUser: null as string | null };
  const client = {
    from(table: string) {
      if (table !== "push_subscriptions") throw new Error(`unexpected table ${table}`);
      return {
        delete: () => ({
          in: (_col: string, ids: string[]) => {
            calls.deleted.push(ids);
            return Promise.resolve({ error: deleteError });
          },
        }),
        update: () => ({
          in: (_col: string, ids: string[]) => {
            calls.updated.push(ids);
            return Promise.resolve({ error: null });
          },
        }),
        select: () => ({
          eq: (_col: string, userId: string) => {
            calls.selectedUser = userId;
            return Promise.resolve({ data: rows, error: null });
          },
        }),
      };
    },
  };
  return { client: client as unknown as Parameters<typeof sendPushToSubscriptions>[0], calls };
}

function httpError(statusCode: number) {
  return Object.assign(new Error(`status ${statusCode}`), { statusCode });
}

beforeEach(() => {
  for (const k of ENV_KEYS) saved[k] = process.env[k];
  vi.clearAllMocks();
  vi.spyOn(console, "error").mockImplementation(() => {});
});

afterEach(() => {
  for (const k of ENV_KEYS) {
    if (saved[k] === undefined) delete process.env[k];
    else process.env[k] = saved[k];
  }
  vi.restoreAllMocks();
});

describe("isPushConfigured", () => {
  it("is false without VAPID keys", () => {
    delete process.env.NEXT_PUBLIC_VAPID_PUBLIC_KEY;
    delete process.env.VAPID_PRIVATE_KEY;
    expect(isPushConfigured()).toBe(false);
  });

  it("is false with only the public key", () => {
    process.env.NEXT_PUBLIC_VAPID_PUBLIC_KEY = "pub";
    delete process.env.VAPID_PRIVATE_KEY;
    expect(isPushConfigured()).toBe(false);
  });

  it("is true with both keys (subject optional)", () => {
    setVapidEnv();
    delete process.env.VAPID_SUBJECT;
    expect(isPushConfigured()).toBe(true);
  });
});

describe("isGoneError", () => {
  it("treats 404 and 410 as gone", () => {
    expect(isGoneError(httpError(404))).toBe(true);
    expect(isGoneError(httpError(410))).toBe(true);
  });
  it("does not treat other failures as gone", () => {
    expect(isGoneError(httpError(500))).toBe(false);
    expect(isGoneError(httpError(429))).toBe(false);
    expect(isGoneError(new Error("network"))).toBe(false);
    expect(isGoneError(null)).toBe(false);
  });
});

describe("sendPushToSubscriptions", () => {
  it("no-ops when VAPID is not configured", async () => {
    delete process.env.NEXT_PUBLIC_VAPID_PUBLIC_KEY;
    delete process.env.VAPID_PRIVATE_KEY;
    const { client, calls } = fakeSupabase();
    const res = await sendPushToSubscriptions(client, [sub("s1")], { title: "t", body: "b" });
    expect(res).toEqual({ skipped: true, sent: 0, failed: 0, removed: 0 });
    expect(sendNotification).not.toHaveBeenCalled();
    expect(setVapidDetails).not.toHaveBeenCalled();
    expect(calls.deleted).toEqual([]);
  });

  it("sends the JSON payload to every subscription and stamps last_used_at", async () => {
    setVapidEnv();
    sendNotification.mockResolvedValue({ statusCode: 201, body: "", headers: {} });
    const { client, calls } = fakeSupabase();
    const payload = { title: "หัวข้อ", body: "ข้อความ", url: "/nl/practice", tag: "x" };
    const res = await sendPushToSubscriptions(client, [sub("s1"), sub("s2")], payload);

    expect(res).toEqual({ skipped: false, sent: 2, failed: 0, removed: 0 });
    expect(setVapidDetails).toHaveBeenCalledWith("mailto:test@morroo.com", "pub", "priv");
    expect(sendNotification).toHaveBeenCalledTimes(2);
    const [target, body] = sendNotification.mock.calls[0];
    expect(target).toEqual({ endpoint: "https://push.example/s1", keys: { p256dh: "p", auth: "a" } });
    expect(JSON.parse(body as string)).toEqual(payload);
    expect(calls.updated).toEqual([["s1", "s2"]]);
    expect(calls.deleted).toEqual([]);
  });

  it("deletes subscriptions the push service reports as 404/410", async () => {
    setVapidEnv();
    sendNotification.mockImplementation(async (s) => {
      if (s.endpoint.endsWith("gone410")) throw httpError(410);
      if (s.endpoint.endsWith("gone404")) throw httpError(404);
      return { statusCode: 201, body: "", headers: {} };
    });
    const { client, calls } = fakeSupabase();
    const res = await sendPushToSubscriptions(
      client,
      [sub("ok"), sub("gone410"), sub("gone404")],
      { title: "t", body: "b" }
    );

    expect(res).toEqual({ skipped: false, sent: 1, failed: 0, removed: 2 });
    expect(calls.deleted).toHaveLength(1);
    expect([...calls.deleted[0]].sort()).toEqual(["gone404", "gone410"]);
    expect(calls.updated).toEqual([["ok"]]);
  });

  it("counts other errors as failed without deleting the subscription", async () => {
    setVapidEnv();
    sendNotification.mockRejectedValue(httpError(500));
    const { client, calls } = fakeSupabase();
    const res = await sendPushToSubscriptions(client, [sub("s1")], { title: "t", body: "b" });

    expect(res).toEqual({ skipped: false, sent: 0, failed: 1, removed: 0 });
    expect(calls.deleted).toEqual([]);
    expect(calls.updated).toEqual([]);
  });

  it("reports removed=0 when pruning fails", async () => {
    setVapidEnv();
    sendNotification.mockRejectedValue(httpError(410));
    const { client } = fakeSupabase([], { message: "boom" });
    const res = await sendPushToSubscriptions(client, [sub("s1")], { title: "t", body: "b" });
    expect(res.removed).toBe(0);
  });

  it("returns early for an empty list", async () => {
    setVapidEnv();
    const { client } = fakeSupabase();
    const res = await sendPushToSubscriptions(client, [], { title: "t", body: "b" });
    expect(res).toEqual({ skipped: false, sent: 0, failed: 0, removed: 0 });
    expect(sendNotification).not.toHaveBeenCalled();
  });
});

describe("sendPushToUser", () => {
  it("skips the DB lookup entirely when not configured", async () => {
    delete process.env.NEXT_PUBLIC_VAPID_PUBLIC_KEY;
    delete process.env.VAPID_PRIVATE_KEY;
    const { client, calls } = fakeSupabase([sub("s1")]);
    const res = await sendPushToUser(client, "u1", { title: "t", body: "b" });
    expect(res.skipped).toBe(true);
    expect(calls.selectedUser).toBeNull();
  });

  it("loads the user's subscriptions and sends to each", async () => {
    setVapidEnv();
    sendNotification.mockResolvedValue({ statusCode: 201, body: "", headers: {} });
    const { client, calls } = fakeSupabase([sub("a"), sub("b")]);
    const res = await sendPushToUser(client, "u1", { title: "t", body: "b" });
    expect(calls.selectedUser).toBe("u1");
    expect(res.sent).toBe(2);
  });
});

describe("parseSubscriptionJson", () => {
  const valid = {
    endpoint: "https://fcm.googleapis.com/fcm/send/abc",
    expirationTime: null,
    keys: { p256dh: "BEl6", auth: "k8J" },
  };

  it("accepts a browser PushSubscription JSON", () => {
    expect(parseSubscriptionJson(valid)).toEqual({
      endpoint: valid.endpoint,
      p256dh: "BEl6",
      auth: "k8J",
    });
  });

  it("rejects missing keys or endpoint", () => {
    expect(parseSubscriptionJson(null)).toBeNull();
    expect(parseSubscriptionJson({ endpoint: valid.endpoint })).toBeNull();
    expect(parseSubscriptionJson({ ...valid, endpoint: "" })).toBeNull();
    expect(parseSubscriptionJson({ ...valid, keys: { p256dh: "x" } })).toBeNull();
  });

  it("rejects non-https endpoints", () => {
    expect(parseSubscriptionJson({ ...valid, endpoint: "http://localhost:5432/x" })).toBeNull();
    expect(parseSubscriptionJson({ ...valid, endpoint: "not a url" })).toBeNull();
  });
});
