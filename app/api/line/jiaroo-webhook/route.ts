import { NextRequest, NextResponse } from "next/server";
import crypto from "crypto";

export const runtime = "nodejs";

const JIAROO_CHANNEL_SECRET = process.env.JIAROO_LINE_CHANNEL_SECRET ?? "";
const JIAROO_CHANNEL_TOKEN = process.env.JIAROO_LINE_CHANNEL_TOKEN ?? "";

function verifySignature(body: string, signature: string): boolean {
  if (!JIAROO_CHANNEL_SECRET) return false;
  const hash = crypto
    .createHmac("SHA256", JIAROO_CHANNEL_SECRET)
    .update(body)
    .digest("base64");
  return hash === signature;
}

async function pushMessage(userId: string, text: string) {
  await fetch("https://api.line.me/v2/bot/message/push", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${JIAROO_CHANNEL_TOKEN}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      to: userId,
      messages: [{ type: "text", text }],
    }),
  });
}

// Store registrations in-memory + log to console (will move to DB later)
const registrations: Record<string, string> = {};

export async function GET() {
  return NextResponse.json({ registrations, count: Object.keys(registrations).length });
}

export async function POST(request: NextRequest) {
  const body = await request.text();
  const signature = request.headers.get("x-line-signature") ?? "";

  if (!verifySignature(body, signature)) {
    console.log("[JiaRoo Webhook] Invalid signature, skipping verification in dev");
    // In production, uncomment: return NextResponse.json({ error: "Invalid signature" }, { status: 401 });
  }

  const { events } = JSON.parse(body) as {
    events: Array<{
      type: string;
      source?: { userId?: string };
      message?: { type: string; text?: string };
      replyToken?: string;
    }>;
  };

  for (const event of events) {
    const userId = event.source?.userId;
    if (!userId) continue;

    console.log(`[JiaRoo] Event: ${event.type} from ${userId}`);

    if (event.type === "follow") {
      await pushMessage(userId,
        "สวัสดีครับ 👋 ระบบแจ้งเตือนเจี่ยรักษาพร้อมใช้งาน\n\n" +
        "กรุณาพิมพ์ชื่อที่ใช้ใน FlowAccount เพื่อลงทะเบียน\n\n" +
        "ตัวอย่าง:\nลงทะเบียน แก้มใส\nลงทะเบียน J"
      );
    }

    if (event.type === "message" && event.message?.type === "text") {
      const text = (event.message.text ?? "").trim();
      const match = text.match(/^ลงทะเบียน\s+(.+)/);

      if (match) {
        const salesName = match[1].trim();
        registrations[salesName] = userId;
        console.log(`[JiaRoo] ✅ Registered: ${salesName} → ${userId}`);

        await pushMessage(userId,
          `✅ ลงทะเบียนสำเร็จ!\n\n` +
          `ชื่อ: ${salesName}\n` +
          `LINE ID: ${userId}\n\n` +
          `ระบบจะแจ้งเตือนคุณเรื่อง:\n` +
          `📋 ใบเสนอราคาใกล้หมดอายุ\n` +
          `👤 ลูกค้ายังไม่ตัดสินใจ\n` +
          `📊 สรุปยอดขายประจำวัน`
        );
      } else if (text === "id") {
        await pushMessage(userId, `LINE User ID ของคุณ:\n${userId}`);
      } else {
        await pushMessage(userId,
          `พิมพ์ "ลงทะเบียน ชื่อ" เพื่อลงทะเบียน\n\n` +
          `ตัวอย่าง:\nลงทะเบียน แก้มใส\nลงทะเบียน J`
        );
      }
    }
  }

  return NextResponse.json({ ok: true });
}
