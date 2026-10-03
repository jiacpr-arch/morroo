/**
 * ดึงข่าวสอบแพทย์จาก FEED_SOURCES (RSS) → กรองคำสำคัญ → AI คัด/สรุป → ลง news_items
 *
 * ข่าวที่เกี่ยวข้อง (และเป็นของไทย) ขึ้นหน้า /news ทันที (origin = 'auto', is_active = true);
 * ที่ไม่เกี่ยวข้องเก็บแบบซ่อนและตรวจแล้ว จะไม่ถูกสรุปซ้ำ แอดมินซ่อน/แสดง/แก้ได้ที่ /admin/news
 * ข่าวอัตโนมัติ "ไม่" ถูกโพสต์ Facebook/LINE เอง (autopost กรอง origin = manual) และไม่มีการแจ้งนักศึกษา
 * — มีแค่ข้อความ LINE แจ้งแอดมิน; ข่าวกำหนดการ/เกณฑ์สอบจะเตือนให้เช็ก lib/exam-dates.ts
 *
 * dedupe ด้วย external_ref = "auto:<guid>" (unique) — cron ยิงซ้ำ ฟีดซ้อนกัน หรือกดปุ่มซ้ำ ก็ไม่ลงซ้ำ
 * ใช้โดย cron /api/cron/exam-news-fetch และปุ่ม "ดึงข่าวตอนนี้"
 */

import { createAdminClient } from "@/lib/supabase/admin";
import { sendLineMessage } from "@/lib/line";
import { FEED_SOURCES, parseRss, type FeedItem } from "@/lib/exam-news-feed";
import {
  isPublishableExamNews,
  looksExamRelated,
  summarizeExamNews,
} from "@/lib/exam-news-ai";

export interface ExamNewsFetchResult {
  feeds: number;
  feedErrors: string[];
  candidates: number;
  fresh: number;
  added: number;
  skipped: number;
  /** ข่าวใหม่ที่เป็นกำหนดการ/เกณฑ์สอบ — ต้องให้แอดมินเช็ก lib/exam-dates.ts */
  examScheduleAdded: number;
}

const MAX_AGE_MS = 7 * 86_400_000;
const MAX_AI_CALLS = 15;
const SITE_URL = (process.env.NEXT_PUBLIC_SITE_URL ?? "https://www.morroo.com").trim();

async function fetchFeed(url: string, errors: string[]): Promise<FeedItem[]> {
  try {
    const res = await fetch(url, {
      headers: { "User-Agent": "MorrooNewsBot/1.0 (+https://www.morroo.com)" },
      signal: AbortSignal.timeout(10_000),
      cache: "no-store",
    });
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    return parseRss(await res.text());
  } catch (err) {
    console.error("[exam-news-fetch] feed failed", url, err);
    errors.push(`${new URL(url).hostname}: ${err instanceof Error ? err.message : String(err)}`);
    return [];
  }
}

export function buildAdminAlertText(titles: string[], examScheduleAdded: number): string {
  const shown = titles.slice(0, 5);
  const more = titles.length - shown.length;
  return [
    `📰 เผยแพร่ข่าวสอบแพทย์ใหม่ ${titles.length} ข่าวแล้ว`,
    ...shown.map((t) => `• ${t}`),
    ...(more > 0 ? [`…และอีก ${more} ข่าว`] : []),
    ...(examScheduleAdded > 0
      ? [
          "",
          `📅 ${examScheduleAdded} ข่าวเกี่ยวกับกำหนดการ/เกณฑ์สอบ — ตรวจแล้วอัปเดต lib/exam-dates.ts (วันที่ + confirmed: true)`,
        ]
      : []),
    "",
    `ซ่อน/แก้ไขได้ที่ ${SITE_URL}/admin/news`,
  ].join("\n");
}

export async function runExamNewsFetch(): Promise<ExamNewsFetchResult> {
  const db = createAdminClient();
  const feedErrors: string[] = [];
  const now = Date.now();
  const feeds = await Promise.all(
    FEED_SOURCES.map(async (s) => ({ source: s, items: await fetchFeed(s.url, feedErrors) }))
  );

  const candidates = feeds.flatMap(({ items }) =>
    items
      .filter((i) => !i.pubDate || now - Date.parse(i.pubDate) <= MAX_AGE_MS)
      .map((i) => ({ ...i, ref: `auto:${i.guid}` }))
  );

  // ข้ามรายการที่เคยนำเข้าแล้ว (ทั้งที่แสดงและที่ซ่อน)
  const refs = [...new Set(candidates.map((c) => c.ref))];
  const seen = new Set<string>();
  for (let i = 0; i < refs.length; i += 100) {
    const { data } = await db
      .from("news_items")
      .select("external_ref")
      .in("external_ref", refs.slice(i, i + 100));
    for (const r of data ?? []) if (r.external_ref) seen.add(r.external_ref as string);
  }
  const fresh = candidates.filter(
    (c, idx) =>
      !seen.has(c.ref) &&
      candidates.findIndex((o) => o.ref === c.ref) === idx &&
      looksExamRelated(`${c.title}\n${c.description}`)
  );

  let added = 0;
  let skipped = 0;
  let examScheduleAdded = 0;
  const addedTitles: string[] = [];

  for (const item of fresh.slice(0, MAX_AI_CALLS)) {
    try {
      const draft = await summarizeExamNews(`หัวข้อ: ${item.title}\n\n${item.description}`);
      const publish = isPublishableExamNews(draft);
      const { error } = await db.from("news_items").insert({
        source_type: "exam",
        source_section: draft.section,
        title: draft.title || item.title.slice(0, 160),
        summary: draft.summary || item.title,
        link: item.link,
        published_at: item.pubDate ?? new Date().toISOString(),
        external_ref: item.ref,
        origin: "auto",
        // ข่าวที่เกี่ยวข้องขึ้นทันที; ที่ไม่เกี่ยวเก็บซ่อน + ตรวจแล้ว จะไม่ถูกสรุปซ้ำ
        is_active: publish,
        reviewed_at: new Date().toISOString(),
        exam_schedule: publish && draft.exam_schedule,
        source_name: item.sourceName,
      });
      if (error && error.code !== "23505") throw error;
      if (!error && publish) {
        added++;
        addedTitles.push(draft.title || item.title);
        if (draft.exam_schedule) examScheduleAdded++;
      } else {
        skipped++;
      }
    } catch (err) {
      // ไม่ลงแถว = รอบหน้าลองใหม่ (จนกว่าข่าวจะเก่าเกิน MAX_AGE)
      console.error("[exam-news-fetch] item failed", item.link, err);
      skipped++;
    }
  }

  if (added > 0) {
    const adminLineId = process.env.ADMIN_LINE_USER_ID;
    if (adminLineId) {
      await sendLineMessage(adminLineId, [
        { type: "text", text: buildAdminAlertText(addedTitles, examScheduleAdded) },
      ]).catch((err) => console.error("[exam-news-fetch] admin alert failed", err));
    } else {
      console.error("[exam-news-fetch] ADMIN_LINE_USER_ID not set — cannot notify");
    }
  }

  return {
    feeds: FEED_SOURCES.length,
    feedErrors,
    candidates: candidates.length,
    fresh: fresh.length,
    added,
    skipped,
    examScheduleAdded,
  };
}
