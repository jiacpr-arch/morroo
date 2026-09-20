import { afterEach, describe, expect, it, vi } from "vitest";
import {
  __resetMissingTokenWarning,
  normalizePhone,
  sendMetaEvent,
} from "./events-api";

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
  vi.restoreAllMocks();
  __resetMissingTokenWarning();
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

describe("normalizePhone", () => {
  it("ทำเบอร์ไทยในบ้านให้เป็นรูปแบบสากล (0 → 66)", () => {
    expect(normalizePhone("081-234-5678")).toBe("66812345678");
    expect(normalizePhone("08 1234 5678")).toBe("66812345678");
    expect(normalizePhone("0812345678")).toBe("66812345678");
  });

  it("เบอร์ 06x ที่ขึ้นต้น 066 ไม่โดนนับรหัสประเทศซ้ำ", () => {
    // 0661234567 = เบอร์มือถือ 06x ปกติ ไม่ใช่เบอร์ที่มี 66 นำอยู่แล้ว
    expect(normalizePhone("066-123-4567")).toBe("66661234567");
  });

  it("เบอร์ที่เป็นสากลอยู่แล้วไม่ถูกแตะ", () => {
    expect(normalizePhone("+66 81 234 5678")).toBe("66812345678");
    expect(normalizePhone("66812345678")).toBe("66812345678");
  });

  it("ตัดรหัสโทรออกนอกประเทศ 00 ทิ้ง", () => {
    expect(normalizePhone("0066812345678")).toBe("66812345678");
    expect(normalizePhone("+001 415 555 1234")).toBe("14155551234");
  });

  it("เบอร์ต่างประเทศปล่อยผ่าน ไม่เดารหัสประเทศให้", () => {
    expect(normalizePhone("+1 415 555 1234")).toBe("14155551234");
    expect(normalizePhone("+44 20 7946 0958")).toBe("442079460958");
  });

  it("เบอร์บ้าน 9 หลักก็แปลงได้", () => {
    expect(normalizePhone("02-123-4567")).toBe("6621234567");
  });

  it("คืน null เมื่อไม่มีตัวเลขเลย", () => {
    expect(normalizePhone("")).toBeNull();
    expect(normalizePhone("ไม่ระบุ")).toBeNull();
    expect(normalizePhone("---")).toBeNull();
  });

  it("เลขยาว/สั้นผิดรูปไม่โดนเติม 66 มั่ว", () => {
    // 0 นำหน้าแต่ยาวผิดรูป — ปล่อยไว้ดีกว่าเดาผิดแล้ว hash ไม่ตรงใคร
    expect(normalizePhone("0123")).toBe("0123");
  });
});

describe("action_source", () => {
  it("ยังเป็น website เมื่อไม่ได้ระบุ (caller เดิมไม่กระทบ)", async () => {
    vi.stubEnv("META_CAPI_ACCESS_TOKEN", "token");
    const fetchMock = stubFetch();

    await sendMetaEvent({ event: "Purchase" });

    const data = (payloadOf(fetchMock).data as Record<string, unknown>[])[0];
    expect(data.action_source).toBe("website");
  });

  it("ส่ง system_generated ได้สำหรับการปิดการขายในแชท", async () => {
    vi.stubEnv("META_CAPI_ACCESS_TOKEN", "token");
    const fetchMock = stubFetch();

    await sendMetaEvent({
      event: "Purchase",
      actionSource: "system_generated",
      phone: "081-234-5678",
      value: 5900,
      currency: "THB",
    });

    const data = (payloadOf(fetchMock).data as Record<string, unknown>[])[0];
    expect(data.action_source).toBe("system_generated");
    // เบอร์ต้องถูก hash เสมอ ห้ามหลุดเป็น plain text
    const userData = data.user_data as Record<string, string[]>;
    expect(userData.ph[0]).toMatch(/^[0-9a-f]{64}$/);
    expect(JSON.stringify(data)).not.toContain("081");
    expect(JSON.stringify(data)).not.toContain("66812345678");
  });
});

describe("token ที่หายไปต้องไม่เงียบ", () => {
  it("log ข้อผิดพลาดพร้อมชื่อ event ตัวแรกที่ถูกทิ้ง", async () => {
    vi.stubEnv("META_CAPI_ACCESS_TOKEN", "");
    const err = vi.spyOn(console, "error").mockImplementation(() => {});
    const fetchMock = stubFetch();

    await sendMetaEvent({ event: "Purchase" });

    expect(fetchMock).not.toHaveBeenCalled();
    expect(err).toHaveBeenCalledOnce();
    const msg = String(err.mock.calls[0][0]);
    expect(msg).toContain("META_CAPI_ACCESS_TOKEN");
    expect(msg).toContain("Purchase");
  });

  it("เตือนครั้งเดียวต่อ instance ไม่ท่วม log", async () => {
    vi.stubEnv("META_CAPI_ACCESS_TOKEN", "");
    const err = vi.spyOn(console, "error").mockImplementation(() => {});
    stubFetch();

    await sendMetaEvent({ event: "Purchase" });
    await sendMetaEvent({ event: "ViewContent" });
    await sendMetaEvent({ event: "Lead" });

    expect(err).toHaveBeenCalledOnce();
  });

  it("ไม่เตือนเมื่อ token ปกติ", async () => {
    vi.stubEnv("META_CAPI_ACCESS_TOKEN", "token");
    const err = vi.spyOn(console, "error").mockImplementation(() => {});
    stubFetch();

    await sendMetaEvent({ event: "Purchase" });

    expect(err).not.toHaveBeenCalled();
  });
});

describe("API version", () => {
  it("ยิงไปที่ v24.0 ให้ตรงกับ ads-diagnostics", async () => {
    vi.stubEnv("META_CAPI_ACCESS_TOKEN", "token");
    const fetchMock = stubFetch();

    await sendMetaEvent({ event: "Purchase" });

    const [url] = fetchMock.mock.calls[0] as unknown as [string];
    expect(url).toContain("/v24.0/");
    expect(url).not.toContain("v18.0");
  });
});
