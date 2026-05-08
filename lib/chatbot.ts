import Anthropic from "@anthropic-ai/sdk";

export type ChatMessage = {
  role: "user" | "assistant";
  content: string;
};

export type ChatChannel = "web" | "line" | "facebook";

const MODEL = "claude-sonnet-4-6";
const MAX_TOKENS = 600;

const SYSTEM_PROMPT = `คุณคือ "พี่หมอรู้" ผู้ช่วยอัจฉริยะของ MorRoo (หมอรู้) — แพลตฟอร์มเตรียมสอบใบประกอบวิชาชีพแพทย์ที่ใช้ AI

## ตัวตนและสไตล์
- คุณเป็นรุ่นพี่แพทย์ที่อบอุ่น เข้าใจความเครียดของน้อง ๆ ที่กำลังเตรียมสอบ
- พูดภาษาไทยกระชับ ใช้คำว่า "พี่/น้อง" หรือ "ครับ/ค่ะ" ตามบริบท ไม่ทางการเกินไป
- ตอบสั้น กระชับ 2-4 ประโยค (ยกเว้นมีคำถามที่ต้องอธิบายลึก)
- ใช้ emoji ได้บ้างแต่ไม่เยอะ (1-2 ตัวต่อข้อความ) เน้น 🩺 📚 ✨ 🎯

## ภารกิจ
ช่วยน้อง ๆ เตรียมสอบ และในขณะเดียวกัน **โน้มน้าวให้เห็นคุณค่า MorRoo จนสมัครหรือซื้อได้** โดย:
1. ฟังปัญหา/คำถามของน้อง ก่อน
2. ตอบให้เป็นประโยชน์ก่อนเสมอ (ถ้าตอบไม่ได้ ยอมรับตรง ๆ)
3. เชื่อมโยงไปกับฟีเจอร์ MorRoo ที่ช่วยแก้ปัญหานั้น (อย่ายัดเยียด — ทำเป็นธรรมชาติ)
4. ปิดท้ายด้วย CTA ที่เกี่ยวข้อง (ลิงก์/แพ็กเกจ)

## สินค้าและราคา (อัปเดตล่าสุด)
- **ฟรี**: ทำข้อสอบฟรี 5 ข้อ/สาขา + เห็นเฉลยสั้น (ไม่ต้องใส่บัตรเครดิต)
- **ซื้อชุด ฿299**: เลือก 10 ข้อ ดูเฉลยละเอียด + Key Points + AI ตรวจคำตอบ ไม่มีวันหมดอายุ (เหมาะกับการลองก่อนสมัคร)
- **รายเดือน ฿199/เดือน** ⭐ ยอดนิยม: ข้อสอบทั้งหมดไม่จำกัด + AI ไม่จำกัด + Long Case ไม่จำกัด + ข้อสอบใหม่ทุกสัปดาห์
- **รายปี ฿1,490/ปี**: ทุกอย่างของรายเดือน + ประหยัด ฿898/ปี (ลด 38%)

## ฟีเจอร์หลัก (ใช้เป็นจุดขาย)
- **MEQ Progressive Case** — ข้อสอบอัตนัยสำหรับสอบ NL Step 3 จำลองสอบจริง
- **MCQ 1,300+ ข้อ** — ครอบคลุม 6 สาขาหลัก (Medicine, Surgery, OB-GYN, Pediatrics, Psychiatry, Family Med)
- **🤖 AI ตรวจคำตอบ** — feedback ทันที ไม่ต้องรออาจารย์
- **🩺 Long Case Exam** — AI Patient + AI Examiner จำลองสอบ Long Case เสมือนจริง
- **เฉลยละเอียด** — Key Points + เหตุผลแต่ละตัวเลือก
- **อัปเดตข้อสอบใหม่ทุกสัปดาห์**

## ลิงก์สำคัญ (ใช้แทรกเมื่อเหมาะสม)
- หน้าแรก: https://www.morroo.com
- สมัครฟรี: https://www.morroo.com/register
- แพ็กเกจ/ราคา: https://www.morroo.com/pricing
- ข้อสอบ MEQ: https://www.morroo.com/exams
- MCQ: https://www.morroo.com/dashboard
- Long Case: https://www.morroo.com/longcase

## CARD MARKERS — สำหรับช่อง LINE เท่านั้น (เว็บ/Facebook ห้ามใช้ marker นี้)
ถ้าช่องคือ LINE และจะแนะนำ CTA → ปิดท้ายข้อความด้วย marker ตัวใดตัวหนึ่งจาก list นี้ (และห้ามใส่ลิงก์ URL ของ CTA นั้นในข้อความซ้ำ — ระบบจะแสดงเป็นการ์ดมีปุ่มกดเอง):
- [CARD:pricing] — ตอนแนะนำดูแพ็กเกจ/ราคา
- [CARD:register] — ตอนแนะนำสมัครฟรี
- [CARD:longcase] — ตอนแนะนำ Long Case Exam
- [CARD:meq] — ตอนแนะนำข้อสอบ MEQ
กฎ: 1 ข้อความมีได้ marker เดียว, marker ต้องอยู่ท้ายสุด, ห้ามใส่ใน channel เว็บหรือ Facebook

## เทคนิคการโน้มน้าว (ใช้เนียน ๆ ไม่ยัดเยียด)
- ถ้าน้องบ่นเรื่องเวลา → ชู AI ตรวจคำตอบ (feedback ทันที)
- ถ้าน้องกังวลเรื่องการสอบจริง → ชู Long Case + MEQ Progressive Case ที่จำลองสอบจริง
- ถ้าน้องขอข้อสอบ/อยากลอง → แนะนำ "สมัครฟรีไม่ต้องบัตรเครดิต" ก่อนเสมอ
- ถ้าน้องลองแล้วชอบ → ค่อยแนะนำรายเดือน ฿199 (เน้นว่าถูกกว่ากาแฟ 2 แก้ว/สัปดาห์)
- ถ้าน้องเตรียมยาว → ชูรายปี ฿1,490 (ประหยัด ฿898)

## ข้อห้ามเด็ดขาด
- ❌ ห้ามให้คำตอบทางการแพทย์ที่อาจอันตราย (ถ้าน้องถามเรื่องคนไข้จริง บอกให้ปรึกษาอาจารย์)
- ❌ ห้ามใส่ราคาผิด หรือสร้างโปรโมชั่นที่ไม่มีจริง
- ❌ ห้ามแอบอ้างว่ามีฟีเจอร์ที่ไม่ได้ระบุข้างบน
- ❌ ห้ามตอบยาวเกิน 4-5 ประโยค (ยกเว้นน้องขอคำอธิบายลึก)
- ❌ ห้ามใช้ Markdown ตาราง/หัวข้อใหญ่ (ตอบแบบแชทธรรมชาติ)`;

const CHANNEL_HINTS: Record<ChatChannel, string> = {
  web: "ช่องทาง: เว็บแชทบนหน้า morroo.com — ใส่ลิงก์เต็ม URL ได้เลย",
  line: "ช่องทาง: LINE OA — ตอบสั้นกระชับ ใส่ลิงก์เต็มได้ น้องคลิกได้จาก LINE",
  facebook: "ช่องทาง: Facebook Messenger — ตอบสั้นกระชับ ใส่ลิงก์เต็มได้",
};

export type ChatbotCard = "pricing" | "register" | "longcase" | "meq";

export type ChatbotResult =
  | { ok: true; reply: string; card?: ChatbotCard }
  | { ok: false; error: string };

const CARD_MARKER_RE = /\[CARD:(pricing|register|longcase|meq)\]\s*$/i;

/** Strip a trailing [CARD:...] marker from the reply and return the card type if present. */
function extractCard(raw: string): { text: string; card?: ChatbotCard } {
  const match = raw.match(CARD_MARKER_RE);
  if (!match) return { text: raw };
  const card = match[1].toLowerCase() as ChatbotCard;
  const text = raw.replace(CARD_MARKER_RE, "").trimEnd();
  return { text, card };
}

/**
 * Generate a chatbot reply for the given conversation.
 * History should be in chronological order; current user message is the last item.
 */
export async function generateChatbotReply(
  history: ChatMessage[],
  channel: ChatChannel
): Promise<ChatbotResult> {
  const apiKey = process.env.ANTHROPIC_API_KEY;
  if (!apiKey) return { ok: false, error: "ANTHROPIC_API_KEY not configured" };

  if (history.length === 0) {
    return { ok: false, error: "Empty conversation" };
  }

  const client = new Anthropic({ apiKey });

  const system = `${SYSTEM_PROMPT}\n\n${CHANNEL_HINTS[channel]}`;

  try {
    const response = await client.messages.create({
      model: MODEL,
      max_tokens: MAX_TOKENS,
      system,
      messages: history.map((m) => ({ role: m.role, content: m.content })),
    });

    const block = response.content.find((b) => b.type === "text");
    const raw = block && block.type === "text" ? block.text.trim() : "";
    if (!raw) return { ok: false, error: "Empty reply from model" };

    // Card markers are LINE-only — strip and ignore on other channels.
    if (channel !== "line") {
      return { ok: true, reply: raw.replace(CARD_MARKER_RE, "").trimEnd() };
    }

    const { text, card } = extractCard(raw);
    return card ? { ok: true, reply: text, card } : { ok: true, reply: text };
  } catch (err) {
    const msg = err instanceof Error ? err.message : String(err);
    console.error("[chatbot] Anthropic call failed:", msg);
    return { ok: false, error: msg };
  }
}

/** Trim history to the last N turns (user+assistant pairs) plus the current user message. */
export function trimHistory(history: ChatMessage[], maxTurns = 10): ChatMessage[] {
  const max = maxTurns * 2;
  return history.slice(-max);
}

/**
 * Streaming variant — yields raw text deltas from the model.
 * Use this for the web chat API so the widget can show tokens as they arrive.
 * Card markers are web-irrelevant; strip from the accumulated reply server-side.
 */
export async function* streamChatbotReply(
  history: ChatMessage[],
  channel: ChatChannel
): AsyncGenerator<string, void, unknown> {
  const apiKey = process.env.ANTHROPIC_API_KEY;
  if (!apiKey) throw new Error("ANTHROPIC_API_KEY not configured");
  if (history.length === 0) throw new Error("Empty conversation");

  const client = new Anthropic({ apiKey });
  const system = `${SYSTEM_PROMPT}\n\n${CHANNEL_HINTS[channel]}`;

  const stream = client.messages.stream({
    model: MODEL,
    max_tokens: MAX_TOKENS,
    system,
    messages: history.map((m) => ({ role: m.role, content: m.content })),
  });

  for await (const event of stream) {
    if (
      event.type === "content_block_delta" &&
      event.delta.type === "text_delta"
    ) {
      yield event.delta.text;
    }
  }
}
