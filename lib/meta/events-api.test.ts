import { afterEach, describe, expect, it, vi } from "vitest";
import { sendMetaEvent } from "./events-api";

/**
 * เทสคุมด่านเดียวที่กัน test_event_code หลุดขึ้น production
 *
 * เหตุที่ต้องมี: event ที่แนบ test_event_code จะไม่ถูกนับเป็น conversion จริง
 * ของ Meta ซึ่งพังแบบเงียบสนิท — โฆษณายังวิ่ง เงินยังหมด แต่ optimize ไม่ได้
 * และไม่มี error ให้เห็นที่ไหนเลย (เกิดขึ้นจริงกับ production ตั้งแต่ 14 พ.ค.
 * ถึง 27 ก.ค. 2026)
 */

function stubFetch() {
  const fetchMock = vi.fn(async () => new Response("{}", { status: 200 }));
  vi.stubGlobal("fetch", fetchMock);
  return fetchMock;
}

function payloadOf(fetchMock: ReturnType<typeof stubFetch>) {
  const [, init] = fetchMock.mock.calls[0] as unknown as [string, RequestInit];
  return JSON.parse(String(init.body)) as Record<string, unknown>;
}

afterEach(() => {
  vi.unstubAllGlobals();
  vi.unstubAllEnvs();
});

describe("sendMetaEvent — test_event_code gate", () => {
  it("ไม่แนบ test_event_code เมื่อรันบน production แม้ env จะตั้งไว้", async () => {
    vi.stubEnv("META_CAPI_ACCESS_TOKEN", "token");
    vi.stubEnv("META_TEST_EVENT_CODE", "TEST31694");
    vi.stubEnv("VERCEL_ENV", "production");
    const fetchMock = stubFetch();

    await sendMetaEvent({ event: "ViewContent", contentType: "casegame" });

    expect(fetchMock).toHaveBeenCalledOnce();
    expect(payloadOf(fetchMock)).not.toHaveProperty("test_event_code");
  });

  it("ยังแนบ test_event_code บน preview เพื่อให้ทดสอบได้", async () => {
    vi.stubEnv("META_CAPI_ACCESS_TOKEN", "token");
    vi.stubEnv("META_TEST_EVENT_CODE", "TEST31694");
    vi.stubEnv("VERCEL_ENV", "preview");
    const fetchMock = stubFetch();

    await sendMetaEvent({ event: "ViewContent", contentType: "casegame" });

    expect(payloadOf(fetchMock)).toMatchObject({ test_event_code: "TEST31694" });
  });

  it("ไม่แนบเมื่อ env เป็นค่าว่าง (ตั้งไว้แต่ลบค่าออก)", async () => {
    vi.stubEnv("META_CAPI_ACCESS_TOKEN", "token");
    vi.stubEnv("META_TEST_EVENT_CODE", "   ");
    vi.stubEnv("VERCEL_ENV", "preview");
    const fetchMock = stubFetch();

    await sendMetaEvent({ event: "ViewContent" });

    expect(payloadOf(fetchMock)).not.toHaveProperty("test_event_code");
  });

  it("ไม่ยิงอะไรเลยเมื่อไม่มี access token", async () => {
    vi.stubEnv("META_CAPI_ACCESS_TOKEN", "");
    const fetchMock = stubFetch();

    await sendMetaEvent({ event: "ViewContent" });

    expect(fetchMock).not.toHaveBeenCalled();
  });
});
