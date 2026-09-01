/**
 * Daily cron — generates AI rewrite suggestions for the worst open
 * landing-page findings. Each suggestion is opened as a draft PR and
 * recorded in ad_suggest_prs.
 *
 * No LINE push here — the 08:00 admin digest (/api/cron/admin-digest)
 * attaches new PRs as interactive cards with merge / dismiss buttons.
 *
 * Schedule: 06:00 BKK (= 23:00 UTC), after the daily ads diagnose (22:00 UTC).
 * pickFindingsToSuggest de-dupes per page, so a persistent finding won't
 * reopen a PR for a page that already has an open/merged one.
 *
 * Never merges anything itself. Merging happens via:
 *   - GitHub web UI, or
 *   - LINE postback button → app/api/line/webhook (admin-only)
 */

import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { getFileOnBranch, getGhConfig } from "@/lib/github-api";
import {
  findPageFile,
  generateSuggestion,
  openSuggestPR,
  pickFindingsToSuggest,
  runRiskChecks,
} from "@/lib/ads-page-suggester";

export const runtime = "nodejs";
export const maxDuration = 300;

function isAuthorized(request: Request): boolean {
  const secret = new URL(request.url).searchParams.get("secret");
  if (secret && secret === process.env.BLOG_GENERATE_SECRET) return true;
  const auth = request.headers.get("authorization");
  return Boolean(process.env.CRON_SECRET) && auth === `Bearer ${process.env.CRON_SECRET}`;
}

export async function GET(request: Request) {
  if (!isAuthorized(request)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const cfg = getGhConfig();
  if (!cfg) {
    return NextResponse.json(
      { error: "GITHUB_TOKEN not configured — cannot open PRs" },
      { status: 500 }
    );
  }

  const supabase = createAdminClient();
  const findings = await pickFindingsToSuggest(supabase, 3);
  if (findings.length === 0) {
    return NextResponse.json({ ok: true, message: "no findings to suggest" });
  }

  const opened: Array<{ findingId: number; pr: number; url: string }> = [];
  const errors: Array<{ findingId: number; error: string }> = [];

  for (const finding of findings) {
    const pageFile = findPageFile(finding.entity_id);
    if (!pageFile) {
      errors.push({ findingId: finding.id, error: "no matching page file" });
      continue;
    }

    const file = await getFileOnBranch(cfg, pageFile, "main");
    if (!file) {
      errors.push({ findingId: finding.id, error: `cannot read ${pageFile}` });
      continue;
    }

    const suggestion = await generateSuggestion(finding, file.content);
    if (!suggestion.ok || !suggestion.proposedSrc) {
      errors.push({ findingId: finding.id, error: suggestion.error ?? "claude failed" });
      continue;
    }

    const checks = runRiskChecks(file.content, suggestion.proposedSrc);
    const allPassed = checks.every((c) => c.ok);
    if (!allPassed) {
      errors.push({
        findingId: finding.id,
        error: `risk checks failed: ${checks.filter((c) => !c.ok).map((c) => c.name).join(", ")}`,
      });
      continue;
    }

    const baseline = {
      ...finding.metric_snapshot,
      captured_at: new Date().toISOString(),
    };

    const result = await openSuggestPR({
      finding,
      pageFile,
      proposedSrc: suggestion.proposedSrc,
      checks,
      baseline,
    });
    if ("error" in result) {
      errors.push({ findingId: finding.id, error: result.error });
      continue;
    }

    const { error: insertErr } = await supabase.from("ad_suggest_prs").insert({
      finding_id: finding.id,
      page_path: finding.entity_id,
      page_file: pageFile,
      pr_number: result.pr.number,
      pr_url: result.pr.html_url,
      branch: result.branch,
      baseline_metrics: baseline,
      risk_checks: checks,
      status: "open",
    });
    if (insertErr) {
      errors.push({ findingId: finding.id, error: `db insert: ${insertErr.message}` });
    }

    opened.push({
      findingId: finding.id,
      pr: result.pr.number,
      url: result.pr.html_url,
    });
  }

  return NextResponse.json({
    ok: errors.length === 0,
    opened,
    errors,
  });
}
