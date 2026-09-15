import { describe, expect, it } from "vitest";
import {
  attributionEventProps,
  captureAttribution,
  parseAttribution,
  persistAttribution,
  readAttribution,
  vercelAttributionProps,
  type Attribution,
  type StorageLike,
} from "./attribution";

function memoryStore(throwing = false): StorageLike {
  const map = new Map<string, string>();
  return {
    getItem: (key) => {
      if (throwing) throw new Error("blocked");
      return map.get(key) ?? null;
    },
    setItem: (key, value) => {
      if (throwing) throw new Error("blocked");
      map.set(key, value);
    },
  };
}

describe("parseAttribution", () => {
  it("captures the full utm set plus fbclid", () => {
    const attr = parseAttribution(
      "?utm_source=fb&utm_medium=paid&utm_campaign=casegame&utm_content=feed_a&utm_term=meq&fbclid=abc123",
      "/sim/vf-arrest-01",
    );
    expect(attr).toMatchObject({
      utm_source: "fb",
      utm_medium: "paid",
      utm_campaign: "casegame",
      utm_content: "feed_a",
      utm_term: "meq",
      fbclid: "abc123",
      landing_path: "/sim/vf-arrest-01",
    });
  });

  it("leaves absent keys null rather than undefined", () => {
    const attr = parseAttribution("?utm_campaign=chk", "/");
    expect(attr?.utm_source).toBeNull();
    expect(attr?.utm_medium).toBeNull();
    expect("utm_source" in (attr as Attribution)).toBe(true);
  });

  it("returns null when there is nothing to attribute", () => {
    expect(parseAttribution("", "/")).toBeNull();
    expect(parseAttribution("?ref=ABC123", "/")).toBeNull();
  });

  it("ignores internal self-referral sources (e.g. the games hub)", () => {
    expect(parseAttribution("?utm_source=morroo&utm_medium=games_hub", "/casegame")).toBeNull();
  });

  it("clamps values so a malicious query string cannot bloat analytics_events", () => {
    const long = "x".repeat(500);
    const attr = parseAttribution(`?utm_campaign=${long}`, "/");
    expect(attr?.utm_campaign?.length).toBe(120);
  });

  it("keeps landing_path free of query params", () => {
    const attr = parseAttribution("?utm_source=fb", "/sim/vf-arrest-01");
    expect(attr?.landing_path).toBe("/sim/vf-arrest-01");
  });
});

describe("persistAttribution / readAttribution", () => {
  it("writes first-touch once and last-touch every time", () => {
    const local = memoryStore();
    const session = memoryStore();
    const first = parseAttribution("?utm_campaign=launch", "/")!;
    const second = parseAttribution("?utm_campaign=retarget", "/pricing")!;

    persistAttribution(first, { local, session });
    persistAttribution(second, { local, session });

    const { first: storedFirst, last: storedLast } = readAttribution({ local, session });
    expect(storedFirst?.utm_campaign).toBe("launch");
    expect(storedLast?.utm_campaign).toBe("retarget");
  });

  it("never throws when storage is blocked (private mode / in-app browser)", () => {
    const local = memoryStore(true);
    const session = memoryStore(true);
    const attr = parseAttribution("?utm_campaign=chk", "/")!;
    expect(() => persistAttribution(attr, { local, session })).not.toThrow();
    expect(() => readAttribution({ local, session })).not.toThrow();
  });
});

describe("attributionEventProps", () => {
  it("returns null when nothing was ever captured", () => {
    const stores = { local: memoryStore(), session: memoryStore() };
    expect(attributionEventProps(stores)).toBeNull();
  });

  it("prefers last-touch when both exist", () => {
    const stores = { local: memoryStore(), session: memoryStore() };
    captureAttribution({ search: "?utm_campaign=first", pathname: "/" }, stores);
    captureAttribution({ search: "?utm_campaign=second", pathname: "/pricing" }, stores);
    const props = attributionEventProps(stores);
    expect(props?.utm_campaign).toBe("second");
    expect(props?.utm_touch).toBe("last");
  });

  it("falls back to first-touch when the session copy is gone (new tab)", () => {
    const local = memoryStore();
    const session = memoryStore();
    captureAttribution({ search: "?utm_campaign=launch", pathname: "/" }, { local, session });
    // simulate a fresh tab: session storage empty, local storage kept
    const freshSession = memoryStore();
    const props = attributionEventProps({ local, session: freshSession });
    expect(props?.utm_campaign).toBe("launch");
    expect(props?.utm_touch).toBe("first");
  });

  it("always includes every utm key, even when null, and never leaks fbclid", () => {
    const stores = { local: memoryStore(), session: memoryStore() };
    captureAttribution({ search: "?utm_campaign=chk", pathname: "/" }, stores);
    const props = attributionEventProps(stores)!;
    expect(Object.keys(props).sort()).toEqual(
      ["landing_path", "utm_campaign", "utm_content", "utm_medium", "utm_source", "utm_term", "utm_touch"].sort(),
    );
  });
});

describe("vercelAttributionProps", () => {
  it("passes through null unchanged", () => {
    expect(vercelAttributionProps(null)).toBeNull();
  });

  it("keeps only the 4 main utm keys", () => {
    const stores = { local: memoryStore(), session: memoryStore() };
    captureAttribution(
      { search: "?utm_source=fb&utm_medium=paid&utm_campaign=c&utm_content=x&utm_term=t", pathname: "/" },
      stores,
    );
    const props = vercelAttributionProps(attributionEventProps(stores));
    expect(Object.keys(props ?? {}).sort()).toEqual(
      ["utm_campaign", "utm_content", "utm_medium", "utm_source"].sort(),
    );
  });
});
