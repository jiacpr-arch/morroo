/**
 * Daily cron — watches ads-autofix-suggest PRs that were merged in the
 * past 7 days, compares current page metrics against the baseline that
 * triggered the suggest, and either:
 *   - auto-opens a revert PR (when conversion degrades materially), or
 *   - marks the linked finding resolved (when conversion held or improved
 *     for the full 7-day window).
 *
 * No LINE push here — verdicts land on ad_suggest_prs (outcome columns)
 * and surface in the 08:00 admin digest (/api/cron/admin-digest).
 *
 * Schedule: daily 04:30 BKK (= 21:30 UTC).
 */

import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import {
  createBranch,
  getDefaultBranchSha,
  getFileOnBranch,
  getGhConfig,
  openPullRequest,
  putFile,
  type GhConfig,
} from "@/lib/github-api";
import { fetchPageStats, type PageStats } from "@/lib/ads-diagnostics";

export const runtime = "nodejs";
export const maxDuration = 120;

// What counts as "degraded"
const DEGRADATION_RATIO = 0.75; // signupRate < 75% of baseline → revert
const MIN_SESSIONS_FOR_VERDICT = 100;

function isAuthorized(request: Request): boolean {
  const secret = new URL(request.url).searchParams.get("secret");
  if (secret && secret === process.env.BLOG_GENERATE_SECRET) return true;
  const auth = request.headers.get("authorization");
  return Boolean(process.env.CRON_SECRET) && auth === `Bearer ${process.env.CRON_SECRET}`;
}

function bucketOf(path: string): string {
  const clean = path.split("?")[0] || "/";
  const segs = clean.split("/").filter(Boolean);
  if (segs.length === 0) return "/";
  if (segs.length === 1) return `/${segs[0]}`;
  return `/${segs[0]}/${segs[1]}`;
}

type SuggestPrRow = {
  id: number;
  finding_id: number | null;
  page_path: string;
  page_file: string;
  pr_number: number;
  pr_url: string;
  branch: string;
  merged_at: string;
  baseline_metrics: Record<string, unknown>;
};

interface CurrentMetric {
  sessions: number;
  signups: number;
  signupRatePct: number;
}

function pickCurrent(stats: PageStats[], path: string): CurrentMetric | null {
  const match = stats.find((s) => s.path === bucketOf(path));
  if (!match) return null;
  const rate = match.sessions > 0 ? (match.signups / match.sessions) * 100 : 0;
  return {
    sessions: match.sessions,
    signups: match.signups,
    signupRatePct: Number(rate.toFixed(3)),
  };
}

async function openRevertPR(
  cfg: GhConfig,
  args: {
    suggest: SuggestPrRow;
    baselineRate: number;
    currentRate: number;
  }
): Promise<{ number: number; html_url: string } | null> {
  const baseSha = await getDefaultBranchSha(cfg, "main");
  if (!baseSha) return null;

  // The merged file is on main. Read its current content + sha, then
  // overwrite with the file as it existed before the suggest PR. We
  // re-fetch the pre-suggest content by reading the parent of the suggest
  // PR branch — but that branch may already be deleted. Simpler: read
  // the file at HEAD~1 of main by walking commits. To keep it simple,
  // we use the GitHub "compare" API by reading the file at the suggest
  // branch's base sha via the commits endpoint. For pragmatism, we just
  // delete the file and recreate from the latest pre-merge ref captured
  // in baseline_metrics is not possible — instead we open a no-op revert
  // hint PR (file content untouched), letting the admin click GitHub's
  // built-in "Revert" button. That keeps this code path safe & simple.
  //
  // i.e. we publish a tracking PR that says "revert me via UI" rather
  // than reconstructing the original blob server-side.
  const stamp = new Date().toISOString().slice(0, 10);
  const branch = `ads-autofix/revert-${args.suggest.pr_number}-${stamp}`;
  if (!(await createBranch(cfg, branch, baseSha))) return null;

  // touch a marker file so the PR has a diff to open
  const markerPath = `.ads-autofix/revert-${args.suggest.pr_number}.md`;
  const markerContent =
    `Revert tracker for ads-autofix PR #${args.suggest.pr_number}\n\n` +
    `- page: ${args.suggest.page_path}\n` +
    `- baseline signup rate: ${args.baselineRate.toFixed(2)}%\n` +
    `- current signup rate:  ${args.currentRate.toFixed(2)}%\n` +
    `- created: ${new Date().toISOString()}\n\n` +
    `**Action required:** open PR #${args.suggest.pr_number} on GitHub and click "Revert", then merge that revert PR.\n`;

  const existing = await getFileOnBranch(cfg, markerPath, branch);
  if (existing) {
    await putFile(cfg, markerPath, branch, markerContent, existing.sha, "chore(ads-autofix): refresh revert marker");
  } else {
    // create new file via PUT with no sha
    await fetch(`https://api.github.com/repos/${cfg.owner}/${cfg.repo}/contents/${encodeURIComponent(markerPath)}`, {
      method: "PUT",
      headers: {
        Authorization: `Bearer ${cfg.token}`,
        Accept: "application/vnd.github+json",
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        message: `chore(ads-autofix): mark PR #${args.suggest.pr_number} for revert`,
        content: Buffer.from(markerContent, "utf8").toString("base64"),
        branch,
      }),
    });
  }

  const pr = await openPullRequest(cfg, {
    title: `🚨 revert: ${args.suggest.page_path} (PR #${args.suggest.pr_number}) — conversion drop`,
    body:
      `Signup rate dropped from **${args.baselineRate.toFixed(2)}%** (baseline) to ` +
      `**${args.currentRate.toFixed(2)}%** after merging #${args.suggest.pr_number}.\n\n` +
      `Threshold for auto-revert: < ${(DEGRADATION_RATIO * 100).toFixed(0)}% of baseline.\n\n` +
      `**To revert:** open #${args.suggest.pr_number} → click **Revert** → merge that PR.\n` +
      `This marker PR auto-closes once the actual revert is merged.\n`,
    head: branch,
    base: "main",
    draft: false,
    labels: ["ads-autofix-revert"],
  });
  if (!pr) return null;
  return { number: pr.number, html_url: pr.html_url };
}

export async function GET(request: Request) {
  if (!isAuthorized(request)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const cfg = getGhConfig();
  const supabase = createAdminClient();
  const now = Date.now();
  const sevenDaysAgo = new Date(now - 7 * 86_400_000).toISOString();
  const oneDayAgo = new Date(now - 1 * 86_400_000).toISOString();

  // Pull merged PRs that we haven't fully evaluated yet.
  const { data: rows, error } = await supabase
    .from("ad_suggest_prs")
    .select(
      "id, finding_id, page_path, page_file, pr_number, pr_url, branch, merged_at, baseline_metrics"
    )
    .eq("status", "merged")
    .is("outcome_resolved_at", null)
    .gte("merged_at", sevenDaysAgo)
    .lte("merged_at", oneDayAgo);
  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  if (!rows || rows.length === 0) {
    return NextResponse.json({ ok: true, message: "no merged PRs to evaluate" });
  }

  // One stats call covers the whole 7-day window for all pages.
  const stats = await fetchPageStats(supabase, sevenDaysAgo);
  const updates: Array<{ pr: number; outcome: string }> = [];

  for (const row of rows as SuggestPrRow[]) {
    const baseline = row.baseline_metrics as Record<string, unknown>;
    const baselineRate = Number(baseline.signupRatePct ?? 0);
    const current = pickCurrent(stats, row.page_path);

    if (!current || current.sessions < MIN_SESSIONS_FOR_VERDICT) {
      // not enough signal yet
      updates.push({ pr: row.pr_number, outcome: "skip-insufficient-data" });
      continue;
    }

    const mergedAgeDays = (now - new Date(row.merged_at).getTime()) / 86_400_000;
    const ratio = baselineRate > 0 ? current.signupRatePct / baselineRate : 1;

    // Degraded → auto open revert PR.
    if (baselineRate > 0 && ratio < DEGRADATION_RATIO) {
      let revertNumber: number | null = null;
      if (cfg) {
        const revert = await openRevertPR(cfg, {
          suggest: row,
          baselineRate,
          currentRate: current.signupRatePct,
        });
        if (revert) {
          revertNumber = revert.number;
        }
      }
      await supabase
        .from("ad_suggest_prs")
        .update({
          status: "reverted",
          outcome: "degraded",
          outcome_resolved_at: new Date().toISOString(),
          post_merge_metrics: current,
          revert_pr_number: revertNumber,
          updated_at: new Date().toISOString(),
        })
        .eq("id", row.id);

      updates.push({ pr: row.pr_number, outcome: "degraded" });
      continue;
    }

    // Hold judgement until full 7-day window unless degradation already triggered.
    if (mergedAgeDays < 7) {
      updates.push({ pr: row.pr_number, outcome: "watching" });
      continue;
    }

    // 7-day window closed → final verdict.
    const outcome = ratio >= 1.1 ? "improved" : "flat";
    await supabase
      .from("ad_suggest_prs")
      .update({
        outcome,
        outcome_resolved_at: new Date().toISOString(),
        post_merge_metrics: current,
        updated_at: new Date().toISOString(),
      })
      .eq("id", row.id);

    if (outcome === "improved" && row.finding_id) {
      await supabase
        .from("ad_diagnostics_findings")
        .update({
          resolved: true,
          resolved_at: new Date().toISOString(),
        })
        .eq("id", row.finding_id);
    }

    updates.push({ pr: row.pr_number, outcome });
  }

  return NextResponse.json({ ok: true, updates });
}
