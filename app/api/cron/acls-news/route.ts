/**
 * Daily ACLS/BLS medical news curator — ported from acls-emr's
 * api/news/fetch-daily.js. Uses Claude's server-side web_search tool to find
 * recent CPR/ACLS/BLS-relevant news, curates + dedupes it, inserts into
 * acls_news (renamed from the source's `news`), then broadcasts a push
 * notification for the first inserted item.
 *
 * Auth: same pattern as app/api/cron/admin-digest/route.ts — Vercel Cron
 * injects `Authorization: Bearer $CRON_SECRET`; external/manual callers can
 * use `?secret=$BLOG_GENERATE_SECRET`.
 */

import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { createAnthropic } from "@/lib/anthropic";
import { broadcastNewsItem } from "@/lib/courses/push-broadcast";
import type { NewsCourse } from "@/lib/courses/news";

export const runtime = "nodejs";
export const maxDuration = 300;

const MODEL = "claude-sonnet-4-6";
const MAX_ITEMS_PER_RUN = 6;
// A fresh news item must be published within this many days. Anything older is
// treated as "evergreen" reference material (guidelines, landmark research).
const FRESH_MAX_DAYS = 21;
// Evergreen reference is valuable but must never dominate the feed, otherwise the
// top of the (published_at-sorted) feed stops advancing and looks stale. Allow at
// most this many evergreen items per run; the rest of each run must be fresh news.
// Hard rule: if a run already has fewer than MIN_FRESH_PER_RUN fresh items, the
// evergreen cap drops to 0 so the feed never accumulates an evergreen majority.
const MAX_EVERGREEN_PER_RUN = 1;
const MIN_FRESH_PER_RUN = 3;
// Cron now fires 3x/day. The previous 20h dedupe window was sized for a single
// daily run with one sibling project — at 3x/day it would suppress every later run.
// Use a window smaller than the cron interval so each scheduled tick gets a real
// chance to fetch, but still big enough to dedupe the simultaneous sibling project.
const IDEMPOTENCY_WINDOW_HOURS = 5;

const SYSTEM_PROMPT = `You curate a daily medical news feed for two Thai e-learning sites:
- acls.morroo.com (ACLS — Advanced Cardiac Life Support, ILCOR 2025)
- bls.morroo.com (BLS — Basic Life Support, CPR, AED)

Use the web_search tool to find RECENT news (prefer past 7 days, and for fresh news
NEVER older than ${FRESH_MAX_DAYS} days) that is clinically or educationally relevant
to ACLS / BLS / CPR / cardiac arrest / post-resuscitation care / AED / public access
defibrillation / Thai EMS / 1669 / out-of-hospital cardiac arrest / resuscitation
guidelines / hypothermia / ROSC.

The feed is sorted by publication date, so this run's value is the FRESH news it adds.
The overwhelming majority of items you return MUST be genuine news published within the
last ${FRESH_MAX_DAYS} days. Re-running the same evergreen guideline/research explainers
every day makes the feed look frozen — do not do it.

Search strategy:
1. First search Thai-language sources (เช่น hfocus.org, thairath.co.th, hospital sites,
   ราชวิทยาลัยอายุรแพทย์, สมาคมโรคหัวใจ, สพฉ./1669, hfocus, mgronline สุขภาพ).
   Use Thai queries: "CPR ข่าว", "หัวใจหยุดเต้น", "AED", "ช่วยชีวิต ข่าว 2026",
   "ACLS ประเทศไทย", "ผู้ป่วยวิกฤต ข่าว", "1669 ข่าว".
2. IMPORTANT — actively search for ACLS / advanced-care topics too, not just basic CPR/AED.
   The ACLS feed tends to be starved because most rescue stories get tagged 'bls'.
   Run extra queries: "หัวใจวายเฉียบพลัน ข่าว", "STEMI", "กล้ามเนื้อหัวใจตายเฉียบพลัน",
   "ภาวะหัวใจเต้นผิดจังหวะ", "ICU วิกฤต ข่าว", "post cardiac arrest", "ROSC",
   "resuscitation guideline 2026", "antiarrhythmic amiodarone", "vasopressor sepsis",
   "สมาคมแพทย์โรคหัวใจ แนวทาง", "targeted temperature management".
3. If you find fewer than ${MAX_ITEMS_PER_RUN} good Thai items, supplement with English
   sources (AHA, ERC, Resuscitation journal, NEJM, JAMA, BMJ, Reuters Health).

Balance: every run MUST include at least 2 FRESH (non-evergreen, within ${FRESH_MAX_DAYS}
days) items that are visible to ACLS learners (course 'acls' or 'both'). Run the ACLS /
advanced-care searches in step 2 BEFORE you finalize the list, so clinical items are not
crowded out by the item budget. The ACLS feed only shows 'acls' + 'both' items, so if a run
returns only 'bls' items the ACLS site looks frozen — that is the failure mode to avoid.
Prefer the freshest items; do not pad the list with months-old guideline explainers when
recent news exists.

Evergreen reference material (major guideline updates like AHA/ERC/ILCOR, landmark
trials such as TTM) is allowed but limited: include AT MOST 1 evergreen item, and only
if it is genuinely important and not already a tired re-run. Mark such an item with
"is_evergreen": true. Every other item must be fresh news (is_evergreen false). If you
cannot find fresh news, return fewer items rather than padding with old reference pieces.

Quality bar:
- Skip ads, press releases with no news value, opinion pieces, listicles.
- Each item must have a real, verifiable URL and a real news date.
- The summary must be CONCRETE — what happened, when, where, why it matters
  to an ACLS/BLS learner. No filler.

For EACH item produce:
- title: 60-100 chars, in the article's original language
- summary: 2-3 sentences in THAI (even if source is English — translate),
  written for a Thai clinician/nurse/EMT learner
- source_url: the article URL (must be the actual article, not the homepage)
- source_name: short publisher name e.g. "Hfocus", "AHA", "Reuters"
- language: 'th' if source is Thai, 'en' otherwise
- course: choose carefully — this decides which site(s) the item appears on.
    'bls'  = ONLY purely LOCAL lay-rescuer / community basics with no clinical or
             professional-body angle: a specific school / workplace / police / single-hospital
             CPR drill or staff training session, a local "how to do CPR" explainer for the
             general public.
    'acls' = clearly advanced/clinical only: algorithms, drugs, arrhythmia management, ACS/STEMI,
             post-arrest/ICU/critical care, defibrillation strategy aimed at clinicians.
    'both' = DEFAULT for any real clinical resuscitation event or news — a cardiac-arrest
             rescue/CPR save (in hospital or out), OHCA, ROSC, AED used on a real patient,
             resuscitation research, or guideline updates. ALSO use 'both' for any CPR / AED
             awareness campaign, survey, statement, or guidance from a medical authority or
             professional body (AHA, ERC, ILCOR, Red Cross, สพฉ./1669 national programs,
             สมาคมแพทย์ / ราชวิทยาลัย) — these matter to ACLS learners too, not just lay rescuers.
             When unsure between bls and acls, choose 'both'. Most "หัวใจหยุดเต้น / ช่วยชีวิต"
             news stories are 'both', not 'bls'.
- topics: 1-4 short Thai tags e.g. ["AED", "CPR", "หัวใจหยุดเต้น"]
- published_at: ISO 8601 date of publication (from the article)
- is_evergreen: true ONLY for a major guideline/landmark-research reference that is
  intentionally older than ${FRESH_MAX_DAYS} days; false for genuine fresh news

Return strictly this JSON shape, no prose:
{"items": [ { "title":"...", "summary":"...", "source_url":"...", "source_name":"...",
  "language":"th|en", "course":"acls|bls|both", "topics":["..."], "published_at":"YYYY-MM-DD",
  "is_evergreen": false } ]}

Aim for ${MAX_ITEMS_PER_RUN} items. If you genuinely cannot find that many recent
relevant items, return fewer — never invent.`;

const USER_PROMPT = `วันนี้คือ ${new Date().toISOString().slice(0, 10)}. ค้นหาและสรุปข่าวล่าสุด ${MAX_ITEMS_PER_RUN} ชิ้นตามเงื่อนไขใน system prompt แล้วตอบเป็น JSON เท่านั้น`;

const RETRY_SYSTEM_PROMPT = `The previous curation pass produced too few fresh items for the Thai
ACLS/BLS news feed. Run a focused retry that ONLY adds genuine fresh news,
no evergreen reference.

Hard rules:
- Every item MUST be published within the last 7 days (published_at within the last week).
- NO guideline summaries, NO landmark trials, NO "is_evergreen": true — set is_evergreen
  to false on every item, and skip anything older than 7 days entirely.
- Prefer Thai-language sources this time: Hfocus, Thai PBS, Thairath, Bangkok Post Thai,
  MGR Online สุขภาพ, Sanook Health, Komchadluek, สพฉ./1669, Department of Disease Control,
  ราชวิทยาลัยอายุรแพทย์, สมาคมโรคหัวใจ, hospital press rooms, university medical schools.
- Run varied queries beyond the obvious: "ฮีโร่ ปั๊มหัวใจ", "CPR ช่วยชีวิต ล่าสุด",
  "AED สนามบิน", "หัวใจวาย ดารา", "ผู้ป่วยฉุกเฉิน 1669", "สพฉ. ข่าว",
  "ราชวิทยาลัยอายุรแพทย์ แถลง", "โรงพยาบาล กู้ชีพ", news from this week on Thai EMS.
- Tag course conservatively: most real rescue/CPR stories are 'both', not 'bls'.

Return the same JSON shape as the system prompt requires:
{"items": [ { "title", "summary", "source_url", "source_name",
  "language", "course", "topics", "published_at", "is_evergreen": false } ]}

Aim for ${MIN_FRESH_PER_RUN}-${MAX_ITEMS_PER_RUN} items. Return fewer rather than padding.
Do NOT repeat URLs from the prior pass.`;

const RETRY_USER_PROMPT = `รอบแรกได้ข่าวสดไม่พอ ค้นใหม่เฉพาะข่าวสด 7 วันล่าสุด ห้ามใส่ evergreen
ตอบ JSON อย่างเดียว`;

export interface AclsNewsItem {
  title: string;
  summary: string;
  source_url: string | null;
  source_name: string | null;
  language: "th" | "en";
  course: NewsCourse;
  topics: string[];
  published_at: string;
  is_evergreen: boolean;
}

function isAuthorized(request: Request): boolean {
  const url = new URL(request.url);
  const secret = url.searchParams.get("secret");
  if (secret && secret === process.env.BLOG_GENERATE_SECRET) return true;

  const auth = request.headers.get("authorization");
  if (
    auth &&
    process.env.CRON_SECRET &&
    auth === `Bearer ${process.env.CRON_SECRET}`
  ) {
    return true;
  }
  return false;
}

async function handler(request: Request, method: "GET" | "POST") {
  if (!isAuthorized(request)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const apiKey = process.env.ANTHROPIC_API_KEY;
  if (!apiKey) {
    return NextResponse.json({ error: "ANTHROPIC_API_KEY not configured" }, { status: 500 });
  }

  // Idempotent: skip if a sibling cron already filled this window with fresh news.
  // Only fresh items count toward the threshold so a window stuffed with
  // evergreen doesn't suppress a real news pull.
  const supabase = createAdminClient();
  const since = new Date(Date.now() - IDEMPOTENCY_WINDOW_HOURS * 60 * 60 * 1000).toISOString();
  const { count: recentFreshCount } = await supabase
    .from("acls_news")
    .select("id", { count: "exact", head: true })
    .gte("fetched_at", since)
    .eq("is_evergreen", false);
  if ((recentFreshCount || 0) >= MIN_FRESH_PER_RUN && method === "GET") {
    return NextResponse.json({ skipped: true, recentFreshCount });
  }

  const client = createAnthropic();

  let normalized: AclsNewsItem[] | null;
  try {
    normalized = await runCuration(client, SYSTEM_PROMPT, USER_PROMPT);
  } catch (err) {
    return NextResponse.json(
      { error: "anthropic call failed", detail: String((err as Error)?.message || err) },
      { status: 502 },
    );
  }
  if (!normalized) {
    return NextResponse.json({ error: "no items parsed (initial)" }, { status: 502 });
  }

  // If the initial run came back fresh-thin, retry once with a Thai-only,
  // last-7-days, no-evergreen prompt. The retry runs against different
  // search hints so it isn't just re-rolling the same queries.
  let retryFresh = 0;
  if (normalized.filter((r) => !r.is_evergreen).length < MIN_FRESH_PER_RUN) {
    try {
      const retry = await runCuration(client, RETRY_SYSTEM_PROMPT, RETRY_USER_PROMPT);
      if (retry && retry.length) {
        retryFresh = retry.filter((r) => !r.is_evergreen).length;
        normalized = mergeUnique(normalized, retry);
      }
    } catch {
      // Retry is best-effort; fall through with what we have.
    }
  }

  // Keep all fresh items. Evergreen is capped — and when this run is already short
  // on fresh news, evergreen is forbidden entirely so the feed never tilts toward
  // old reference material.
  const freshItems = normalized.filter((r) => !r.is_evergreen);
  const evergreenAllowed = freshItems.length >= MIN_FRESH_PER_RUN ? MAX_EVERGREEN_PER_RUN : 0;
  const evergreenItems = normalized.filter((r) => r.is_evergreen).slice(0, evergreenAllowed);
  const rows = [...freshItems, ...evergreenItems].slice(0, MAX_ITEMS_PER_RUN);

  if (!rows.length) {
    return NextResponse.json({ inserted: 0, parsed: normalized.length });
  }

  // De-dupe against existing source_url
  const urls = rows.map((r) => r.source_url).filter((u): u is string => Boolean(u));
  const { data: existing } = await supabase
    .from("acls_news")
    .select("source_url")
    .in("source_url", urls);
  const existingSet = new Set(
    ((existing ?? []) as { source_url: string }[]).map((e) => e.source_url),
  );
  const toInsert = rows.filter((r) => !r.source_url || !existingSet.has(r.source_url));

  if (!toInsert.length) {
    return NextResponse.json({ inserted: 0, skipped: rows.length, reason: "all duplicates" });
  }

  const { data: inserted, error } = await supabase
    .from("acls_news")
    .insert(toInsert)
    .select("id, title, summary, source_url, course, language");
  if (error) {
    return NextResponse.json(
      { error: error.message, attempted: toInsert.length },
      { status: 500 },
    );
  }

  const insertedRows = (inserted ?? []) as {
    id: string;
    title: string;
    summary: string;
    source_url: string | null;
    course: NewsCourse;
    language: string;
  }[];

  // Broadcast push notification for the first (most relevant) item.
  // Don't spam — pushing more than one per day will fatigue users.
  let pushResult: unknown = null;
  if (insertedRows.length > 0) {
    try {
      pushResult = await broadcastNewsItem(insertedRows[0]);
    } catch (e) {
      pushResult = { error: String((e as Error)?.message || e) };
    }
  }

  // How many inserted items are visible to the ACLS feed ('acls' or 'both'). The ACLS
  // site looks stale when this is 0, so surface it for monitoring the balance requirement.
  const aclsVisible = insertedRows.filter((r) => r.course === "acls" || r.course === "both").length;

  return NextResponse.json({
    inserted: insertedRows.length,
    deduped: rows.length - toInsert.length,
    evergreen: evergreenItems.length,
    aclsVisible,
    retryFresh,
    items: insertedRows.map(({ summary, source_url, ...rest }) => {
      void summary;
      void source_url;
      return rest;
    }),
    push: pushResult,
  });
}

export async function GET(request: Request) {
  return handler(request, "GET");
}

export async function POST(request: Request) {
  return handler(request, "POST");
}

async function runCuration(
  client: ReturnType<typeof createAnthropic>,
  systemPrompt: string,
  userPrompt: string,
): Promise<AclsNewsItem[] | null> {
  const response = await client.messages.create({
    model: MODEL,
    max_tokens: 4096,
    system: systemPrompt,
    tools: [{ type: "web_search_20250305", name: "web_search", max_uses: 10 }],
    messages: [{ role: "user", content: userPrompt }],
  });
  const textBlocks = response.content.filter((b) => b.type === "text");
  const lastText = textBlocks[textBlocks.length - 1]?.text || "";
  const items = extractItems(lastText);
  if (!items.length) return null;
  return items.map(normalizeItem).filter((i): i is AclsNewsItem => i !== null);
}

function mergeUnique(a: AclsNewsItem[], b: AclsNewsItem[]): AclsNewsItem[] {
  const seen = new Set(a.map((r) => r.source_url).filter(Boolean));
  const out = [...a];
  for (const r of b) {
    if (r.source_url && seen.has(r.source_url)) continue;
    if (r.source_url) seen.add(r.source_url);
    out.push(r);
  }
  return out;
}

function extractItems(text: string): unknown[] {
  if (!text) return [];
  // Try fenced JSON block first
  const fenced = text.match(/```json\s*([\s\S]*?)```/i) || text.match(/```\s*([\s\S]*?)```/);
  const candidate = fenced ? fenced[1] : text;
  // Find the first { and last }
  const first = candidate.indexOf("{");
  const last = candidate.lastIndexOf("}");
  if (first === -1 || last === -1) return [];
  const slice = candidate.slice(first, last + 1);
  try {
    const parsed = JSON.parse(slice);
    if (Array.isArray(parsed.items)) return parsed.items;
    if (Array.isArray(parsed)) return parsed;
    return [];
  } catch {
    return [];
  }
}

function normalizeItem(it: unknown): AclsNewsItem | null {
  if (!it || typeof it !== "object") return null;
  const raw = it as Record<string, unknown>;
  const title = String(raw.title || "").trim().slice(0, 300);
  const summary = String(raw.summary || "").trim().slice(0, 2000);
  if (!title || !summary) return null;

  const url = String(raw.source_url || "").trim();
  const source_url = /^https?:\/\//.test(url) ? url.slice(0, 800) : null;

  const language: "th" | "en" = raw.language === "en" ? "en" : "th";
  const course: NewsCourse = ["acls", "bls", "both"].includes(raw.course as string)
    ? (raw.course as NewsCourse)
    : "both";

  const topics = Array.isArray(raw.topics)
    ? (raw.topics as unknown[])
        .map((t) => String(t).trim().slice(0, 40))
        .filter(Boolean)
        .slice(0, 6)
    : [];

  let published_at: string | null = null;
  if (raw.published_at) {
    const d = new Date(raw.published_at as string);
    if (!Number.isNaN(d.getTime())) published_at = d.toISOString();
  }
  const publishedIso = published_at || new Date().toISOString();

  // An item is evergreen if the model flagged it, OR if its publication date is
  // already older than the fresh window — this stops old-dated reference pieces
  // from sneaking in disguised as fresh news.
  const ageMs = Date.now() - new Date(publishedIso).getTime();
  const tooOldToBeFresh = ageMs > FRESH_MAX_DAYS * 24 * 60 * 60 * 1000;
  const is_evergreen = raw.is_evergreen === true || tooOldToBeFresh;

  return {
    title,
    summary,
    source_url,
    source_name: String(raw.source_name || "").trim().slice(0, 120) || null,
    language,
    course,
    topics,
    published_at: publishedIso,
    is_evergreen,
  };
}
