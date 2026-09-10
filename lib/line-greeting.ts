/**
 * Sales-first greetings for the LINE OA bot.
 *
 * Used when the AI has nothing to work with yet — a new follower, or a
 * sticker / image / voice note (the model only handles text). Instead of
 * staying silent, open the sales conversation: one hook, one qualifying
 * question, and the register card follows as a Flex bubble.
 */

/** Human-readable placeholder stored in chat history for non-text events. */
export function describeNonTextMessage(type: string | undefined): string {
  switch (type) {
    case "sticker":
      return "[สติกเกอร์]";
    case "image":
      return "[รูปภาพ]";
    case "video":
      return "[วิดีโอ]";
    case "audio":
      return "[ข้อความเสียง]";
    case "file":
      return "[ไฟล์]";
    case "location":
      return "[ตำแหน่งที่ตั้ง]";
    default:
      return "[ข้อความที่ไม่ใช่ตัวอักษร]";
  }
}

/** True for LINE message types the chatbot cannot read (everything but text). */
export function isNonTextMessage(type: string | undefined): boolean {
  return !!type && type !== "text";
}

/** Greeting sent right after a user adds the OA. */
export function buildFollowGreeting(): string {
  return [
    "สวัสดีครับ พี่หมอรู้จาก MorRoo ยินดีต้อนรับครับ 🩺",
    "",
    "MorRoo ช่วยเตรียมสอบ NL / Board ด้วยข้อสอบ MCQ 3,000+ ข้อ, MEQ และ Long Case จำลองสอบจริง พร้อม AI ตรวจคำตอบทันที",
    "",
    "🎁 ตอนนี้พี่มีโค้ดทดลองใช้ฟรี 1 เดือน (ไม่ต้องใส่บัตรเครดิต) ให้น้องด้วย",
    "",
    "น้องกำลังเตรียมสอบอะไรอยู่ครับ (NL Step 1/2/3 หรือ Board สาขาไหน) พิมพ์บอกพี่ได้เลย เดี๋ยวพี่แนะนำให้ตรงจุด",
  ].join("\n");
}

/** Reply to a sticker / image / other non-text message. */
export function buildNonTextGreeting(): string {
  return [
    "ได้รับแล้วครับ 😊 พี่หมอรู้อ่านได้เฉพาะข้อความตัวอักษรนะครับ",
    "",
    "น้องกำลังเตรียมสอบอะไรอยู่ครับ (NL Step 1/2/3 หรือ Board สาขาไหน) พิมพ์บอกพี่ได้เลย",
    "🎁 มีโค้ดทดลองใช้ MorRoo ฟรี 1 เดือน ไม่ต้องใส่บัตรเครดิต พิมพ์ว่า \"ขอโค้ดทดลอง\" ได้เลยครับ",
  ].join("\n");
}
