import type { LineMessage } from "./line";
import type { MarketingSnapshot } from "./marketing-digest";
import type { AdsDailySummary } from "./ads-daily-summary";
import type { WeeklyAnalyticsSummary } from "./analytics-weekly";

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
        spacing: "sm",
        paddingAll: "md",
        contents: [
          {
            type: "button",
            style: "primary",
            color: "#16A085",
            action: {
              type: "uri",
              label: "สมัครฟรี",
              uri: "https://www.morroo.com/register",
            },
          },
          {
            type: "button",
            style: "secondary",
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
  const siteUrl = (process.env.NEXT_PUBLIC_SITE_URL ?? "https://www.morroo.com").trim();

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
// Exam grading result — pushed to LINE after AI grades an MEQ answer.

interface ExamResultData {
  score: number;
  maxScore: number;
  subjectLabel: string;
  questionPreview: string;
  feedback: string;
  matchedCount: number;
  totalKeyPoints: number;
  weakTopics: string[];
}

export function buildExamResultFlex(data: ExamResultData): LineMessage {
  const pct = Math.round((data.score / data.maxScore) * 100);
  const { headerColor, badge } = scoreBand(data.score);
  const siteUrl = (process.env.NEXT_PUBLIC_SITE_URL ?? "https://www.morroo.com").trim();

  const preview =
    data.questionPreview.length > 80
      ? data.questionPreview.slice(0, 77).trimEnd() + "…"
      : data.questionPreview;

  const feedback =
    data.feedback.length > 220
      ? data.feedback.slice(0, 217).trimEnd() + "…"
      : data.feedback;

  return {
    type: "flex",
    altText: `ผลตรวจข้อสอบ: ${data.score}/${data.maxScore} (${pct}%)`,
    contents: {
      type: "bubble",
      size: "kilo",
      header: {
        type: "box",
        layout: "vertical",
        backgroundColor: headerColor,
        paddingAll: "lg",
        contents: [
          {
            type: "text",
            text: `${badge} ผลตรวจข้อสอบ`,
            color: "#FFFFFF",
            weight: "bold",
            size: "lg",
          },
          {
            type: "text",
            text: data.subjectLabel,
            color: "#FFFFFF",
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
          {
            type: "box",
            layout: "baseline",
            contents: [
              {
                type: "text",
                text: `${data.score}`,
                size: "xxl",
                weight: "bold",
                color: headerColor,
                flex: 0,
              },
              {
                type: "text",
                text: ` / ${data.maxScore}  (${pct}%)`,
                size: "md",
                color: "#666666",
                flex: 0,
                margin: "sm",
              },
            ],
          },
          statRow(
            "Key Points",
            `${data.matchedCount}/${data.totalKeyPoints} ข้อ`
          ),
          { type: "separator", margin: "md" },
          {
            type: "text",
            text: "โจทย์",
            size: "xs",
            color: "#888888",
            margin: "md",
          },
          {
            type: "text",
            text: preview,
            size: "sm",
            color: "#444444",
            wrap: true,
          },
          { type: "separator", margin: "md" },
          {
            type: "text",
            text: "วิเคราะห์",
            size: "xs",
            color: "#888888",
            margin: "md",
          },
          {
            type: "text",
            text: feedback,
            size: "sm",
            color: "#444444",
            wrap: true,
          },
          ...(data.weakTopics.length > 0
            ? [
                { type: "separator" as const, margin: "md" as const },
                {
                  type: "text" as const,
                  text: `ควรฝึกเพิ่ม: ${data.weakTopics.slice(0, 3).join(", ")}`,
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
        spacing: "sm",
        paddingAll: "md",
        contents: [
          {
            type: "button",
            action: {
              type: "uri",
              label: "ดู Dashboard",
              uri: `${siteUrl}/dashboard`,
            },
            style: "primary",
            color: "#16A085",
          },
          {
            type: "button",
            action: {
              type: "uri",
              label: "ทำข้อสอบต่อ",
              uri: `${siteUrl}/exams`,
            },
            style: "secondary",
          },
        ],
      },
    },
  };
}

function scoreBand(score: number): { headerColor: string; badge: string } {
  if (score >= 9) return { headerColor: "#16A085", badge: "🏆" };
  if (score >= 7) return { headerColor: "#27AE60", badge: "✅" };
  if (score >= 5) return { headerColor: "#F39C12", badge: "📘" };
  if (score >= 3) return { headerColor: "#E67E22", badge: "⚠️" };
  return { headerColor: "#E74C3C", badge: "🔁" };
}

// ----------------------------------------------------------------------------
// Admin daily digest — the single LINE push the admin gets every morning.
// Combines: today's business numbers, yesterday's web + ads performance,
// the overnight ads-ops pipeline results (autofix / post-merge verdicts /
// suggest PRs), autopilot changes, and — on Mondays — the weekly summary.

export interface AdsOpsSummary {
  /** Latest overnight ads-autofix diagnostics run (last 24h); null if none ran. */
  autofix: {
    ok: boolean;
    findingsCount: number;
    critical: number;
    autoPaused: number;
    topIssues: { label: string; recommendation: string }[];
  } | null;
  /** Merged suggest-PRs whose post-merge verdict resolved in the last 24h. */
  postMerge: {
    pagePath: string;
    prNumber: number;
    outcome: "improved" | "degraded" | "flat";
    revertPrNumber: number | null;
    baselineRate: number | null;
    currentRate: number | null;
  }[];
  /** AI page-fix PRs opened in the last 24h (cards attached after the digest). */
  suggestsNew: number;
  /** All suggest PRs still waiting for merge/dismiss. */
  suggestsOpenTotal: number;
}

interface AdminDigestData {
  dateLabel: string;
  attemptsToday: number;
  activeUsersToday: number;
  newUsersToday: number;
  avgAccuracyToday: number | null;
  totalStudents: number;
  activeUsers7d: number;
  weakestSubject: string | null;
  aiGradeFails24h: number;
  revenueTodayThb: number | null;
  marketing?: MarketingSnapshot | null;
  adsYesterday?: AdsDailySummary | null;
  adsOps?: AdsOpsSummary | null;
  autopilotChanges?: string[];
  weekly?: WeeklyAnalyticsSummary | null;
}

function deltaText(value: number | null): string {
  if (value == null) return "";
  if (value === 0) return " ±0%";
  const sign = value > 0 ? "+" : "";
  return ` ${sign}${value.toFixed(0)}%`;
}

function sectionTitle(text: string) {
  return {
    type: "text" as const,
    text,
    size: "xs" as const,
    color: "#888888",
    weight: "bold" as const,
    margin: "md" as const,
  };
}

function noteLine(text: string, color = "#555555") {
  return {
    type: "text" as const,
    text,
    size: "xs" as const,
    color,
    wrap: true,
    margin: "sm" as const,
  };
}

// Executive view: who came, who converted, where they came from, anything
// on fire. The full breakdown (bounce, hero A/B, per-source) lives in /admin.
function marketingSection(m: MarketingSnapshot) {
  const visitorsText = `${m.visitors} คน${deltaText(m.visitorsDelta)}`;
  const lineClicksText = `${m.lineClicks} ครั้ง${deltaText(m.lineClicksDelta)}`;
  const conversionText =
    m.conversionRate != null
      ? `${m.formSubmits} คน (${m.conversionRate.toFixed(1)}%)`
      : `${m.formSubmits} คน`;
  const pricingViewText =
    m.pricingViewRate != null
      ? `${m.pricingViewers} คน (${m.pricingViewRate.toFixed(0)}%)`
      : `${m.pricingViewers} คน`;
  const topSource = m.topSources[0];

  return [
    { type: "separator" as const, margin: "md" as const },
    sectionTitle(`🌐 เว็บไซต์ (${m.dateLabel})`),
    statRow("คนเข้าเว็บ", visitorsText),
    statRow("สมัครสมาชิก", conversionText),
    statRow("ทักแชท LINE", lineClicksText),
    statRow("เปิดดูราคา", pricingViewText),
    ...(topSource ? [statRow("ช่องทางหลัก", topSource.name)] : []),
    ...m.alerts.map((a) => noteLine(`🚨 ${a}`, "#E74C3C")),
  ];
}

// Overnight ads-ops pipeline (autofix → suggest → post-merge watch).
// Those crons no longer push LINE themselves — this is where their
// results reach the admin.
function adsOpsSection(o: AdsOpsSummary) {
  const lines: ReturnType<typeof noteLine>[] = [];

  if (o.autofix) {
    const a = o.autofix;
    if (!a.ok) {
      lines.push(noteLine("⚠️ รอบตรวจเมื่อคืนมีข้อผิดพลาด — ดูรายละเอียดใน /admin/ads-diagnostics", "#E74C3C"));
    } else if (a.findingsCount === 0) {
      lines.push(noteLine("✅ ตรวจโฆษณาแล้ว ไม่พบปัญหา"));
    } else {
      lines.push(
        noteLine(
          `🔍 พบจุดที่ต้องดู ${a.findingsCount} รายการ` +
            (a.critical > 0 ? ` (วิกฤต ${a.critical})` : ""),
          a.critical > 0 ? "#E74C3C" : "#555555"
        )
      );
    }
    if (a.autoPaused > 0) {
      lines.push(noteLine(`⏸ พักโฆษณาที่ผลแย่ให้แล้ว ${a.autoPaused} ตัว (กู้คืนได้)`));
    }
    for (const issue of a.topIssues) {
      lines.push(noteLine(`• ${issue.label} — ${issue.recommendation}`, "#666666"));
    }
  }

  for (const pm of o.postMerge) {
    const changePct =
      pm.baselineRate != null && pm.currentRate != null && pm.baselineRate > 0
        ? `${(((pm.currentRate - pm.baselineRate) / pm.baselineRate) * 100).toFixed(0)}%`
        : null;
    if (pm.outcome === "degraded") {
      lines.push(
        noteLine(
          `🚨 หน้า ${pm.pagePath} ผลแย่ลงหลังแก้${changePct ? ` (${changePct})` : ""} — ` +
            (pm.revertPrNumber
              ? `เปิด PR ถอนการแก้ #${pm.revertPrNumber} ไว้ให้แล้ว`
              : "ต้องถอนการแก้ด้วยมือ"),
          "#E74C3C"
        )
      );
    } else if (pm.outcome === "improved") {
      lines.push(noteLine(`✅ หน้า ${pm.pagePath} ดีขึ้น${changePct ? ` ${changePct}` : ""} หลังแก้ (ครบ 7 วัน)`, "#16A085"));
    } else {
      lines.push(noteLine(`➡️ หน้า ${pm.pagePath} ผลเท่าเดิมหลังแก้ (ครบ 7 วัน)`));
    }
  }

  if (o.suggestsNew > 0) {
    lines.push(noteLine(`🤖 มีข้อเสนอแก้หน้าเว็บใหม่ ${o.suggestsNew} รายการ — กดอนุมัติได้จากการ์ดถัดไป`));
  } else if (o.suggestsOpenTotal > 0) {
    lines.push(noteLine(`⏳ ข้อเสนอแก้หน้าเว็บค้างอนุมัติ ${o.suggestsOpenTotal} รายการ`));
  }

  if (lines.length === 0) return [];
  return [
    { type: "separator" as const, margin: "md" as const },
    sectionTitle("🛠 ระบบดูแลโฆษณาอัตโนมัติ"),
    ...lines,
  ];
}

function autopilotSection(changes: string[]) {
  if (changes.length === 0) return [];
  return [
    { type: "separator" as const, margin: "md" as const },
    sectionTitle("⚙️ ระบบปรับเว็บอัตโนมัติ (เมื่อคืน)"),
    ...changes.map((c) => noteLine(c)),
  ];
}

function weeklySection(w: WeeklyAnalyticsSummary) {
  const signupText =
    w.signupConversion != null
      ? `${w.signups.toLocaleString()} คน (${w.signupConversion.toFixed(1)}%)`
      : `${w.signups.toLocaleString()} คน`;
  return [
    { type: "separator" as const, margin: "md" as const },
    sectionTitle(`📈 สรุปสัปดาห์ (${w.rangeLabel})`),
    statRow("คนเข้าเว็บ", `${w.uniqueVisitors.toLocaleString()} คน`),
    statRow("สมัครใหม่", signupText),
    statRow("เริ่มทำข้อสอบ", `${w.examStarts.toLocaleString()} ครั้ง`),
    statRow("กดหน้าจ่ายเงิน", `${w.checkoutClicks.toLocaleString()} ครั้ง`),
    ...(w.topPath ? [statRow("หน้ายอดนิยม", w.topPath.path)] : []),
  ];
}

function adsSection(a: AdsDailySummary) {
  const spendText = `฿${a.spendThb.toLocaleString("th-TH", { maximumFractionDigits: 0 })}`;
  const impressionsText =
    a.ctrPct != null
      ? `${a.impressions.toLocaleString("th-TH")} (CTR ${a.ctrPct.toFixed(2)}%)`
      : a.impressions.toLocaleString("th-TH");
  const signupText =
    a.costPerSignupThb != null
      ? `${a.signups} คน (฿${a.costPerSignupThb.toFixed(0)}/คน)`
      : `${a.signups} คน`;

  return [
    { type: "separator" as const, margin: "md" as const },
    sectionTitle(`📣 โฆษณาเมื่อวาน (${a.adsDelivered} ตัว)`),
    statRow("ค่าโฆษณา", spendText),
    statRow("คนเห็นโฆษณา", impressionsText),
    statRow("สมัครจากโฆษณา", signupText),
    ...(a.topAdName ? [statRow("ตัวที่ผลดีสุด", a.topAdName)] : []),
  ];
}

export function buildAdminDigestFlex(data: AdminDigestData): LineMessage {
  const siteUrl = (process.env.NEXT_PUBLIC_SITE_URL ?? "https://www.morroo.com").trim();
  const accuracyText =
    data.avgAccuracyToday != null
      ? `${data.avgAccuracyToday}%`
      : "—";
  const revenueText =
    data.revenueTodayThb != null
      ? `฿${data.revenueTodayThb.toLocaleString("th-TH")}`
      : "—";

  return {
    type: "flex",
    altText: `MorRoo เช้านี้ ${data.dateLabel} — รายได้ ${revenueText} · สมัครใหม่ ${data.newUsersToday} คน`,
    contents: {
      type: "bubble",
      size: "kilo",
      header: {
        type: "box",
        layout: "vertical",
        backgroundColor: "#0EA5E9",
        paddingAll: "lg",
        contents: [
          {
            type: "text",
            text: "📊 MorRoo เช้านี้",
            color: "#FFFFFF",
            weight: "bold",
            size: "lg",
          },
          {
            type: "text",
            text: data.dateLabel,
            color: "#E0F2FE",
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
          sectionTitle("💰 ธุรกิจวันนี้"),
          statRow("รายได้", revenueText),
          statRow("สมาชิกใหม่", `${data.newUsersToday} คน`),
          { type: "separator", margin: "md" },
          sectionTitle("👨‍🎓 นักเรียน"),
          statRow("เข้าใช้วันนี้", `${data.activeUsersToday} คน`),
          statRow("ทำข้อสอบ", `${data.attemptsToday} ข้อ`),
          statRow("คะแนนเฉลี่ย", accuracyText),
          statRow("นักเรียนทั้งหมด", `${data.totalStudents} คน`),
          statRow("Active 7 วัน", `${data.activeUsers7d} คน`),
          ...(data.weakestSubject
            ? [statRow("วิชาที่อ่อนสุด", data.weakestSubject)]
            : []),
          ...(data.aiGradeFails24h > 0
            ? [noteLine(`⚠️ AI ตรวจข้อสอบล้มเหลว ${data.aiGradeFails24h} ครั้งใน 24 ชม.`, "#E74C3C")]
            : []),
          ...(data.adsYesterday ? adsSection(data.adsYesterday) : []),
          ...(data.marketing ? marketingSection(data.marketing) : []),
          ...(data.adsOps ? adsOpsSection(data.adsOps) : []),
          ...autopilotSection(data.autopilotChanges ?? []),
          ...(data.weekly ? weeklySection(data.weekly) : []),
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
              label: "ดูรายละเอียดใน Admin Dashboard",
              uri: `${siteUrl}/admin`,
            },
            style: "primary",
            color: "#0EA5E9",
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

// ─── Ads suggest PR ──────────────────────────────────────────────────────
export interface AdsSuggestData {
  pagePath: string;
  recommendation: string;
  severity: string;
  prNumber: number;
  prUrl: string;
  baseline: Record<string, number | string | null>;
}

export function buildAdsSuggestFlex(data: AdsSuggestData): LineMessage {
  const severityColor =
    data.severity === "critical" ? "#DC2626" : "#F59E0B";
  const baselineLines = Object.entries(data.baseline)
    .filter(([k]) => k !== "captured_at")
    .slice(0, 4)
    .map(([k, v]) => ({
      type: "text" as const,
      text: `${k}: ${v ?? "—"}`,
      size: "xs" as const,
      color: "#666666",
      wrap: true,
    }));

  return {
    type: "flex",
    altText: `AI suggest แก้หน้า ${data.pagePath} — PR #${data.prNumber}`,
    contents: {
      type: "bubble",
      size: "kilo",
      header: {
        type: "box",
        layout: "vertical",
        backgroundColor: severityColor,
        paddingAll: "lg",
        contents: [
          {
            type: "text",
            text: "🤖 AI Suggest แก้หน้า",
            color: "#FFFFFF",
            weight: "bold",
            size: "md",
          },
          {
            type: "text",
            text: data.pagePath,
            color: "#FFFFFF",
            size: "xs",
            wrap: true,
          },
        ],
      },
      body: {
        type: "box",
        layout: "vertical",
        spacing: "sm",
        paddingAll: "lg",
        contents: [
          {
            type: "text",
            text: data.recommendation,
            size: "sm",
            color: "#222222",
            wrap: true,
          },
          { type: "separator", margin: "md" },
          {
            type: "text",
            text: "Baseline metrics",
            size: "xs",
            color: "#888888",
            weight: "bold",
            margin: "md",
          },
          ...baselineLines,
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
            style: "primary",
            color: severityColor,
            height: "sm",
            action: {
              type: "postback",
              label: "Merge ✓",
              data: `action=merge_pr&pr=${data.prNumber}`,
              displayText: `Merge PR #${data.prNumber}`,
            },
          },
          {
            type: "box",
            layout: "horizontal",
            spacing: "sm",
            contents: [
              {
                type: "button",
                style: "secondary",
                height: "sm",
                action: {
                  type: "uri",
                  label: "ดู PR",
                  uri: data.prUrl,
                },
              },
              {
                type: "button",
                style: "secondary",
                height: "sm",
                action: {
                  type: "postback",
                  label: "Dismiss 30d",
                  data: `action=dismiss_pr&pr=${data.prNumber}`,
                  displayText: `Dismiss PR #${data.prNumber}`,
                },
              },
            ],
          },
        ],
      },
    },
  };
}

export function buildAdsMergeConfirmFlex(args: {
  prNumber: number;
  prUrl: string;
  pagePath: string;
}): LineMessage {
  return {
    type: "flex",
    altText: `ยืนยัน merge PR #${args.prNumber}?`,
    contents: {
      type: "bubble",
      size: "micro",
      body: {
        type: "box",
        layout: "vertical",
        spacing: "sm",
        paddingAll: "lg",
        contents: [
          {
            type: "text",
            text: "ยืนยัน merge?",
            weight: "bold",
            color: "#DC2626",
            size: "md",
          },
          {
            type: "text",
            text: `PR #${args.prNumber}`,
            size: "xs",
            color: "#666666",
          },
          {
            type: "text",
            text: args.pagePath,
            size: "xs",
            color: "#666666",
            wrap: true,
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
            style: "primary",
            color: "#DC2626",
            height: "sm",
            action: {
              type: "postback",
              label: "ใช่, merge เลย",
              data: `action=merge_pr_confirm&pr=${args.prNumber}`,
              displayText: `Confirm merge #${args.prNumber}`,
            },
          },
          {
            type: "button",
            style: "secondary",
            height: "sm",
            action: {
              type: "postback",
              label: "ยกเลิก",
              data: `action=cancel&pr=${args.prNumber}`,
              displayText: "Cancel",
            },
          },
        ],
      },
    },
  };
}
