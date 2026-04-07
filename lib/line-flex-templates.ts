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

  return {
    type: "text",
    text: [
      `สมาชิก MorRoo ${planLabel} ของคุณจะหมดอายุใน ${daysLeft} วัน`,
      `(${dateStr})`,
      ``,
      `ต่ออายุเพื่อฝึกทำข้อสอบต่อเนื่อง`,
      `https://www.morroo.com/pricing`,
    ].join("\n"),
  };
}
