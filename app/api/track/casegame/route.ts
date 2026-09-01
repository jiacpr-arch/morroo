/**
 * Server-side CAPI สำหรับเกมเคส — เหตุการณ์ "เริ่มเล่น" / "เล่นจบ"
 *
 * ทำไมต้องมี route นี้: ตัวเกม (components/sim/SimRunner) เป็น client component
 * และ conversion ที่แคมเปญโฆษณาจะ optimize ต้องไปถึง Meta ให้ได้แม้ ad blocker
 * จะบล็อก browser pixel (ตาม middleware.ts เคยพบว่า ~97% ของคลิกโฆษณามองไม่เห็น)
 * จึงยิงจากฝั่ง server ทางเดียว — ไม่มี browser copy ให้ต้อง dedupe
 *
 * ส่งเป็น standard event `ViewContent` + convention ของ content_name แทนการเพิ่ม
 * custom event ใหม่ เพราะ Meta สร้าง Custom Conversion จาก standard event +
 * กติกา content_name/content_type ได้อยู่แล้ว และใช้เป็น optimization target ได้
 * เต็มรูปแบบ (แพตเทิร์นเดียวกับ app/(morroo)/register/layout.tsx)
 *
 * Public POST — ไม่ต้องล็อกอิน เพราะเล่นเกมโดยไม่ล็อกอินคือทั้งหมดของกลยุทธ์นี้
 * กันสแปมด้วย rate limit ต่อ IP + ตรวจว่า slug เป็นเคสที่มีอยู่จริง มิฉะนั้น
 * ใครก็ยิง conversion ปลอมเข้ามาจนอัลกอริทึมโฆษณาเรียนรู้ผิดได้
 */

import { NextResponse } from "next/server";
import { sendMetaEvent } from "@/lib/meta/events-api";
import { getSimScenario } from "@/lib/supabase/queries-sim";
import {
  capiContentName, capiEventId, caseGameCategory, type CaseGameCapiEvent,
} from "@/lib/sim/track";
import { rateLimited } from "@/lib/firstaid/server/rateLimit";

export const runtime = "nodejs";

// รอบเล่นหนึ่งยิงแค่ 2 ครั้ง (start + complete) — 40/นาที เผื่อคนเล่นรัวและ
// เผื่อหลายคนหลัง NAT เดียวกัน แต่ยังตัดการยิงถล่มทิ้ง
const RATE_LIMIT = { key: "casegame-track", limit: 40, windowMs: 60_000 };

const EVENTS = new Set(["start", "first_decision", "complete"]);
const SLUG_RE = /^[a-z0-9][a-z0-9-]{0,63}$/i;
// runId มาจาก crypto.randomUUID() ฝั่ง client
const RUN_ID_RE = /^[0-9a-z-]{8,64}$/i;

export async function POST(request: Request) {
  const limitedResponse = rateLimited(request, RATE_LIMIT);
  if (limitedResponse) return limitedResponse;

  let body: { event?: unknown; slug?: unknown; runId?: unknown };
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ ok: false }, { status: 400 });
  }

  const event = typeof body.event === "string" ? body.event : "";
  const slug = typeof body.slug === "string" ? body.slug : "";
  const runId = typeof body.runId === "string" ? body.runId : "";

  if (!EVENTS.has(event) || !SLUG_RE.test(slug) || !RUN_ID_RE.test(runId)) {
    return NextResponse.json({ ok: false }, { status: 400 });
  }

  // เคสต้องมีจริง — กันคนยิง slug มั่วเพื่อปั่นยอด conversion
  const scenario = await getSimScenario(slug);
  if (!scenario) return NextResponse.json({ ok: true });

  const capiEvent = event as CaseGameCapiEvent;
  const cookies = request.headers.get("cookie") ?? "";
  const readCookie = (name: string): string | null => {
    const match = cookies.match(new RegExp(`(?:^|;\\s*)${name}=([^;]+)`));
    return match ? decodeURIComponent(match[1]) : null;
  };

  // เดิมใช้ after() แต่ยิงหายไปเกือบหมด (~97%) บน production — after() ยืด
  // อายุ serverless invocation ผ่าน waitUntil ก็จริง แต่ในทางปฏิบัติ instance
  // ยังถูกดับก่อน fetch ไปถึง graph.facebook.com เสร็จอยู่ดีเวลามีทราฟฟิกสูง
  // (เจอวันที่ 2026-07-29: ระบบยิง 922 ครั้ง Meta ได้รับแค่ 5 — ไม่ใช่
  // META_TEST_EVENT_CODE เพราะแก้ไปแล้วใน #375 และไม่มี error log แม้แต่บรรทัด
  // เดียว แปลว่างานถูกตัดตอนเงียบๆ ไม่ใช่ fail) แลก latency นิดหน่อยเพื่อความ
  // ชัวร์ว่ายิงถึงจริงก่อนตอบ response ดีกว่า
  await sendMetaEvent({
    event: "ViewContent",
    eventId: capiEventId(capiEvent, runId),
    ip: request.headers.get("x-forwarded-for")?.split(",")[0]?.trim() ?? null,
    userAgent: request.headers.get("user-agent"),
    fbc: readCookie("_fbc"),
    fbp: readCookie("_fbp"),
    url: request.headers.get("referer"),
    contentType: "casegame",
    contentName: capiContentName(capiEvent, slug),
    contentIds: [`${caseGameCategory(scenario.category)}:${slug}`],
  });

  return NextResponse.json({ ok: true });
}
