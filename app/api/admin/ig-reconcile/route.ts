/**
 * One-shot reconciliation: find blog_posts rows whose IG feed post is marked
 * pending/failed (`ig_post_id IS NULL`) but is actually live on the IG account,
 * and patch the row with the real media ID so the cron stops republishing it.
 *
 * Triggered the duplicates we found on 2026-05-23 — see PR #169 for the
 * upstream `lib/instagram.ts` fix that prevents new occurrences.
 *
 * GET  /api/admin/ig-reconcile           → dry-run, returns suggested matches
 * POST /api/admin/ig-reconcile {apply:true} → patches DB
 *
 * Matching: tokenise the blog title, score each IG caption by how many tokens
 * appear (case-insensitive substring). Need ≥2 matching tokens to claim a
 * match — avoids matching unrelated posts that happen to share one keyword.
 */

import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { getLatestUserToken } from "@/lib/facebook";

export const runtime = "nodejs";
export const maxDuration = 60;

interface IgMedia {
  id: string;
  caption?: string;
  timestamp?: string;
  permalink?: string;
}

interface PendingRow {
  slug: string;
  title: string;
}

interface Match {
  slug: string;
  title: string;
  igId: string;
  igTimestamp: string;
  permalink: string | null;
  matchedTokens: string[];
}

const TITLE_STOPWORDS = new Set([
  "the", "and", "for", "with", "ให้", "ได้", "ใน", "ที่", "และ", "หรือ", "—", "-",
  "ก่อน", "ก่อนสอบแพทย์", "แม่น", "ครบ", "จบ",
]);

function titleTokens(title: string): string[] {
  return title
    .split(/[\s\-—,()]+/u)
    .map((t) => t.trim())
    .filter((t) => t.length >= 4 && !TITLE_STOPWORDS.has(t.toLowerCase()));
}

function scoreMatch(caption: string, tokens: string[]): string[] {
  const text = caption.toLowerCase();
  return tokens.filter((t) => text.includes(t.toLowerCase()));
}

async function fetchRecentIgMedia(
  igAccountId: string,
  token: string,
): Promise<IgMedia[]> {
  const res = await fetch(
    `https://graph.facebook.com/v24.0/${igAccountId}/media?fields=id,caption,timestamp,permalink&limit=50&access_token=${encodeURIComponent(token)}`,
  );
  const data = await res.json();
  if (!res.ok || !Array.isArray(data.data)) {
    throw new Error(data.error?.message ?? `HTTP ${res.status}`);
  }
  return data.data as IgMedia[];
}

async function requireAdmin(): Promise<NextResponse | null> {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  const { data: profile } = await supabase
    .from("profiles")
    .select("role")
    .eq("id", user.id)
    .single();
  if ((profile as { role?: string } | null)?.role !== "admin") {
    return NextResponse.json({ error: "Admin only" }, { status: 403 });
  }
  return null;
}

async function buildReconciliation(): Promise<{
  matches: Match[];
  unmatchedMedia: Array<{ id: string; captionStart: string; timestamp: string }>;
  unmatchedRows: PendingRow[];
}> {
  const igAccountId = process.env.INSTAGRAM_BUSINESS_ACCOUNT_ID;
  if (!igAccountId) throw new Error("INSTAGRAM_BUSINESS_ACCOUNT_ID not set");
  const token = await getLatestUserToken();
  if (!token) throw new Error("No Facebook user token found");

  const admin = createAdminClient();
  const { data: rows, error } = await admin
    .from("blog_posts")
    .select("slug, title")
    .is("ig_post_id", null)
    .order("published_at", { ascending: false })
    .limit(60);
  if (error) throw new Error(error.message);
  const pending: PendingRow[] = (rows ?? []) as PendingRow[];

  const media = await fetchRecentIgMedia(igAccountId, token);

  const claimedMediaIds = new Set<string>();
  const claimedSlugs = new Set<string>();
  const matches: Match[] = [];

  for (const row of pending) {
    const tokens = titleTokens(row.title);
    if (tokens.length === 0) continue;
    let best: { media: IgMedia; matched: string[] } | null = null;
    for (const m of media) {
      if (claimedMediaIds.has(m.id) || !m.caption || !m.timestamp) continue;
      const matched = scoreMatch(m.caption, tokens);
      if (matched.length >= 2 && (!best || matched.length > best.matched.length)) {
        best = { media: m, matched };
      }
    }
    if (best) {
      claimedMediaIds.add(best.media.id);
      claimedSlugs.add(row.slug);
      matches.push({
        slug: row.slug,
        title: row.title,
        igId: best.media.id,
        igTimestamp: best.media.timestamp!,
        permalink: best.media.permalink ?? null,
        matchedTokens: best.matched,
      });
    }
  }

  const unmatchedMedia = media
    .filter((m) => !claimedMediaIds.has(m.id))
    .map((m) => ({
      id: m.id,
      captionStart: (m.caption ?? "").slice(0, 120),
      timestamp: m.timestamp ?? "",
    }));
  const unmatchedRows = pending.filter((r) => !claimedSlugs.has(r.slug));

  return { matches, unmatchedMedia, unmatchedRows };
}

export async function GET() {
  const denied = await requireAdmin();
  if (denied) return denied;
  try {
    const result = await buildReconciliation();
    return NextResponse.json({ dryRun: true, ...result });
  } catch (err) {
    return NextResponse.json({ error: String(err) }, { status: 500 });
  }
}

export async function POST(request: Request) {
  const denied = await requireAdmin();
  if (denied) return denied;

  let body: { apply?: boolean } = {};
  try {
    body = await request.json();
  } catch {
    // empty body is fine — treat as dry-run
  }

  try {
    const result = await buildReconciliation();
    if (!body.apply) {
      return NextResponse.json({ dryRun: true, ...result });
    }

    const admin = createAdminClient();
    const applied: string[] = [];
    const errors: Array<{ slug: string; error: string }> = [];
    for (const m of result.matches) {
      const { error } = await admin
        .from("blog_posts")
        .update({
          ig_post_id: m.igId,
          ig_posted_at: m.igTimestamp,
          ig_last_error: null,
        })
        .eq("slug", m.slug);
      if (error) errors.push({ slug: m.slug, error: error.message });
      else applied.push(m.slug);
    }

    return NextResponse.json({
      dryRun: false,
      applied,
      errors,
      matched: result.matches,
      unmatchedMedia: result.unmatchedMedia,
      unmatchedRows: result.unmatchedRows,
    });
  } catch (err) {
    return NextResponse.json({ error: String(err) }, { status: 500 });
  }
}
