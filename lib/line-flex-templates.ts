import type { LineMessage } from "./line";

interface WeeklySummaryData {
  totalQuestions: number;
  correctCount: number;
  accuracy: number;
  bestSubject: string;
  bestSubjectIcon: string;
  streak: number;
  weakTopics?: string[];
}

export function buildWeeklySummaryFlex(data: WeeklySummaryData): LineMessage {
  const weakLine = data.weakTopics?.length
    ? `\n\nต้องเพิ่ม: ${data.weakTopics.slice(0, 2).join(", ")}`
    : "";

  return {
    type: "flex",
    altText: `สรุปประจำสัปดาห์: ทำ ${data.totalQuestions} ข้อ ถูก ${data.accuracy}%`,
    contents: {
      type: "bubble",
      size: "kilo",
      header: {
        type: "box",
        layout: "vertical",
        backgroundColor: "#16A085",
        paddingAll: "lg",
        contents: [
          {
            type: "text",
            text: "สรุปประจำสัปดาห์",
            color: "#FFFFFF",
            weight: "bold",
            size: "lg",
          },
          {
            type: "text",
            text: "MorRoo Weekly Report",
            color: "#D5F5E3",
            size: "xs",
          },
        ],
      },
      body: {
        type: "box",
        layout: "vertical",
        spacing: "md",
        paddingAll: "lg",
        contents: [
          statRow("ทำทั้งหมด", `${data.totalQuestions} ข้อ`),
          statRow("ถูกต้อง", `${data.correctCount}/${data.totalQuestions} (${data.accuracy}%)`),
          statRow("วิชาที่ดีที่สุด", `${data.bestSubjectIcon} ${data.bestSubject}`),
          statRow("Streak", `${data.streak} วันติดต่อกัน`),
          ...(weakLine
            ? [
                { type: "separator" as const, margin: "md" as const },
                {
                  type: "text" as const,
                  text: `ควรฝึกเพิ่ม: ${data.weakTopics!.slice(0, 2).join(", ")}`,
                  size: "sm" as const,
                  color: "#E74C3C",
                  wrap: true,
                  margin: "md" as const,
                },
              ]
            : []),
        ],
      },
      footer: {
        type: "box",
        layout: "vertical",
        paddingAll: "md",
        contents: [
          {
            type: "button",
            action: {
              type: "uri",
              label: "ดู Dashboard",
              uri: "https://www.morroo.com/dashboard",
            },
            style: "primary",
            color: "#16A085",
          },
        ],
      },
    },
  };
}

function statRow(label: string, value: string) {
  return {
    type: "box" as const,
    layout: "horizontal" as const,
    contents: [
      { type: "text" as const, text: label, size: "sm" as const, color: "#888888", flex: 4 },
      { type: "text" as const, text: value, size: "sm" as const, weight: "bold" as const, flex: 6, align: "end" as const },
    ],
  };
}

interface BlogAnnounceData {
  title: string;
  description: string;
  url: string;
  coverImage: string | null;
}

export function buildBlogAnnounceFlex(data: BlogAnnounceData): LineMessage {
  const desc =
    data.description.length > 60
      ? data.description.slice(0, 57).trimEnd() + "…"
      : data.description;

  return {
    type: "flex",
    altText: `บทความใหม่: ${data.title}`,
    contents: {
      type: "bubble",
      size: "kilo",
      ...(data.coverImage
        ? {
            hero: {
              type: "image",
              // cover_image_line: JPEG 1024×536 ≤1024px per LINE Flex v2 spec
              url: data.coverImage,
              size: "full",
              aspectRatio: "1.91:1",
              aspectMode: "cover",
              action: { type: "uri", uri: data.url },
            },
          }
        : {}),
      body: {
        type: "box",
        layout: "vertical",
        spacing: "sm",
        paddingAll: "lg",
        contents: [
          {
            type: "text",
            text: data.title,
            weight: "bold",
            size: "md",
            wrap: true,
          },
          {
            type: "text",
            text: desc,
            size: "sm",
            color: "#666666",
            wrap: true,
            margin: "md",
          },
        ],
      },
      footer: {
        type: "box",
        layout: "vertical",
        paddingAll: "md",
        contents: [
          {
            type: "button",
            style: "primary",
            color: "#16A085",
            action: {
              type: "uri",
              label: "อ่านบทความ",
              uri: data.url,
            },
          },
        ],
      },
    },
  };
}

interface ExpiryWarningData {
  name: string;
  expiresAt: Date;
  membershipType: string;
}

const PLAN_LABELS: Record<string, string> = {
  monthly: "รายเดือน",
  yearly: "รายปี",
  bundle: "ชุดข้อสอบ",
};

export function buildExpiryWarningMessage(data: ExpiryWarningData): LineMessage {
  const dateStr = data.expiresAt.toLocaleDateString("th-TH", {
    year: "numeric",
    month: "long",
    day: "numeric",
  });
  const planLabel = PLAN_LABELS[data.membershipType] ?? data.membershipType;
  const daysLeft = Math.ceil(
    (data.expiresAt.getTime() - Date.now()) / (1000 * 60 * 60 * 24)
  );
  const renewPath = data.membershipType === "bundle" ? "bundle" : data.membershipType;
  const siteUrl = process.env.NEXT_PUBLIC_SITE_URL ?? "https://www.morroo.com";

  return {
    type: "flex",
    altText: `สมาชิก MorRoo ${planLabel} จะหมดอายุใน ${daysLeft} วัน`,
    contents: {
      type: "bubble",
      size: "kilo",
      header: {
        type: "box",
        layout: "vertical",
        backgroundColor: daysLeft <= 3 ? "#E74C3C" : "#F39C12",
        paddingAll: "lg",
        contents: [
          {
            type: "text",
            text: daysLeft <= 3 ? "⚠️ ใกล้หมดอายุแล้ว!" : "⏰ แจ้งเตือนหมดอายุ",
            color: "#FFFFFF",
            weight: "bold",
            size: "lg",
          },
          {
            type: "text",
            text: "MorRoo Membership",
            color: "#FDEBD0",
            size: "xs",
          },
        ],
      },
      body: {
        type: "box",
        layout: "vertical",
        spacing: "md",
        paddingAll: "lg",
        contents: [
          statRow("แพ็กเกจ", `MorRoo ${planLabel}`),
          statRow("หมดอายุ", dateStr),
          statRow("เหลืออีก", `${daysLeft} วัน`),
          { type: "separator" as const, margin: "md" as const },
          {
            type: "text" as const,
            text: "ต่ออายุเพื่อฝึกทำข้อสอบต่อเนื่อง ไม่พลาดข้อสอบใหม่ทุกวัน!",
            size: "sm" as const,
            color: "#666666",
            wrap: true,
            margin: "md" as const,
          },
        ],
      },
      footer: {
        type: "box",
        layout: "vertical",
        spacing: "sm",
        paddingAll: "md",
        contents: [
          {
            type: "button",
            action: {
              type: "uri",
              label: "🔄 ต่ออายุเลย",
              uri: `${siteUrl}/payment/${renewPath}`,
            },
            style: "primary",
            color: "#0EA5E9",
          },
          {
            type: "button",
            action: {
              type: "uri",
              label: "ดูแพ็กเกจทั้งหมด",
              uri: `${siteUrl}/pricing`,
            },
            style: "secondary",
          },
        ],
      },
    },
  };
}

// ----------------------------------------------------------------------------
// Chatbot CTA cards — appended after a chatbot text reply in LINE
// when the AI emits a [CARD:*] marker.

const SITE = "https://www.morroo.com";
const PRIMARY = "#16A085";

export type ChatbotCardType = "pricing" | "register" | "longcase" | "meq";

export function buildChatbotCard(card: ChatbotCardType): LineMessage {
  switch (card) {
    case "pricing":
      return pricingCard();
    case "register":
      return registerCard();
    case "longcase":
      return longcaseCard();
    case "meq":
      return meqCard();
  }
}

function pricingCard(): LineMessage {
  return {
    type: "flex",
    altText: "ดูแพ็กเกจ MorRoo",
    contents: {
      type: "bubble",
      size: "kilo",
      header: {
        type: "box",
        layout: "vertical",
        backgroundColor: PRIMARY,
        paddingAll: "lg",
        contents: [
          { type: "text", text: "💎 แพ็กเกจ MorRoo", color: "#FFFFFF", weight: "bold", size: "lg" },
          { type: "text", text: "เลือกที่เหมาะกับน้อง", color: "#D5F5E3", size: "xs" },
        ],
      },
      body: {
        type: "box",
        layout: "vertical",
        spacing: "sm",
        paddingAll: "lg",
        contents: [
          planRow("ฟรี", "0 ฿", "5 ข้อ/สาขา"),
          planRow("ซื้อชุด", "299 ฿", "10 ข้อ ไม่หมดอายุ"),
          planRow("รายเดือน ⭐", "199 ฿/ด.", "ไม่จำกัด"),
          planRow("รายปี", "1,490 ฿/ปี", "ประหยัด 38%"),
        ],
      },
      footer: ctaFooter([
        { label: "ดูแพ็กเกจทั้งหมด", uri: `${SITE}/pricing`, style: "primary" },
        { label: "สมัครฟรีก่อน", uri: `${SITE}/register`, style: "secondary" },
      ]),
    },
  };
}

function registerCard(): LineMessage {
  return {
    type: "flex",
    altText: "สมัครฟรีไม่ใช้บัตรเครดิต",
    contents: {
      type: "bubble",
      size: "kilo",
      header: {
        type: "box",
        layout: "vertical",
        backgroundColor: PRIMARY,
        paddingAll: "lg",
        contents: [
          { type: "text", text: "🎁 ทดลองฟรี", color: "#FFFFFF", weight: "bold", size: "lg" },
          { type: "text", text: "ไม่ใช้บัตรเครดิต", color: "#D5F5E3", size: "xs" },
        ],
      },
      body: {
        type: "box",
        layout: "vertical",
        spacing: "sm",
        paddingAll: "lg",
        contents: [
          bulletRow("✓", "ทำข้อสอบ 5 ข้อ/สาขา"),
          bulletRow("✓", "MEQ Progressive Case"),
          bulletRow("✓", "Long Case 1 เคส"),
          bulletRow("✓", "AI ตรวจคำตอบ"),
        ],
      },
      footer: ctaFooter([
        { label: "สมัครฟรีเลย", uri: `${SITE}/register`, style: "primary" },
      ]),
    },
  };
}

function longcaseCard(): LineMessage {
  return {
    type: "flex",
    altText: "Long Case Exam ด้วย AI",
    contents: {
      type: "bubble",
      size: "kilo",
      header: {
        type: "box",
        layout: "vertical",
        backgroundColor: PRIMARY,
        paddingAll: "lg",
        contents: [
          { type: "text", text: "🩺 Long Case Exam", color: "#FFFFFF", weight: "bold", size: "lg" },
          { type: "text", text: "AI Patient + AI Examiner", color: "#D5F5E3", size: "xs" },
        ],
      },
      body: {
        type: "box",
        layout: "vertical",
        spacing: "sm",
        paddingAll: "lg",
        contents: [
          { type: "text", text: "จำลองสอบ Long Case เสมือนจริง — AI คนไข้ตอบทุกอย่างเหมือนสอบจริง อาจารย์ AI ถามต่อยอดและให้ feedback ทันที", size: "sm", wrap: true, color: "#444444" },
        ],
      },
      footer: ctaFooter([
        { label: "ลอง Long Case", uri: `${SITE}/longcase`, style: "primary" },
        { label: "สมัครฟรี", uri: `${SITE}/register`, style: "secondary" },
      ]),
    },
  };
}

function meqCard(): LineMessage {
  return {
    type: "flex",
    altText: "ข้อสอบ MEQ Progressive Case",
    contents: {
      type: "bubble",
      size: "kilo",
      header: {
        type: "box",
        layout: "vertical",
        backgroundColor: PRIMARY,
        paddingAll: "lg",
        contents: [
          { type: "text", text: "📚 MEQ Progressive Case", color: "#FFFFFF", weight: "bold", size: "lg" },
          { type: "text", text: "สำหรับสอบ NL Step 3", color: "#D5F5E3", size: "xs" },
        ],
      },
      body: {
        type: "box",
        layout: "vertical",
        spacing: "sm",
        paddingAll: "lg",
        contents: [
          { type: "text", text: "ข้อสอบอัตนัยประยุกต์แบบให้ข้อมูลผู้ป่วยทีละส่วน + AI ตรวจคำตอบทันที พร้อม Key Points", size: "sm", wrap: true, color: "#444444" },
        ],
      },
      footer: ctaFooter([
        { label: "ลองทำ MEQ", uri: `${SITE}/exams`, style: "primary" },
        { label: "ดูแพ็กเกจ", uri: `${SITE}/pricing`, style: "secondary" },
      ]),
    },
  };
}

// ---- helpers ----

function planRow(label: string, price: string, note: string) {
  return {
    type: "box" as const,
    layout: "horizontal" as const,
    contents: [
      { type: "text" as const, text: label, size: "sm" as const, weight: "bold" as const, flex: 4 },
      { type: "text" as const, text: price, size: "sm" as const, color: PRIMARY, weight: "bold" as const, flex: 3, align: "end" as const },
      { type: "text" as const, text: note, size: "xs" as const, color: "#888888", flex: 5, align: "end" as const },
    ],
  };
}

function bulletRow(bullet: string, text: string) {
  return {
    type: "box" as const,
    layout: "horizontal" as const,
    contents: [
      { type: "text" as const, text: bullet, size: "sm" as const, color: PRIMARY, flex: 1 },
      { type: "text" as const, text, size: "sm" as const, color: "#444444", flex: 9, wrap: true },
    ],
  };
}

function ctaFooter(buttons: { label: string; uri: string; style: "primary" | "secondary" }[]) {
  return {
    type: "box" as const,
    layout: "vertical" as const,
    spacing: "sm" as const,
    paddingAll: "md" as const,
    contents: buttons.map((b) => ({
      type: "button" as const,
      action: { type: "uri" as const, label: b.label, uri: b.uri },
      style: b.style,
      ...(b.style === "primary" ? { color: PRIMARY } : {}),
    })),
  };
}
