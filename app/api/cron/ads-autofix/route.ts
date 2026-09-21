/**
 * Daily ads + landing-page auto-diagnostic cron.
 *
 * Pipeline:
 *   1. fetchPageStats   — analytics_events over the last N days
 *   2. fetchAdInsights  — Meta Marketing API for the same window (optional)
 *   3. diagnosePages + diagnoseAds → findings
 *   4. persist findings → ad_diagnostics_findings
 *   5. executeAutoActions on the safe subset (pause underperforming ads)
 *
 * No LINE push here — results land in ad_diagnostics_runs/_findings and
 * surface in the 08:00 admin digest (/api/cron/admin-digest).
 *
 * Reversible by design: auto-actions are limited to status=PAUSED writes.
 * The original state is stored in ad_auto_actions so the admin can revert
 * from /admin/ads-diagnostics.
 *
 * Auth: dual-mode, matches every other cron route in this repo.
 */

import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import {
  diagnoseAds,
  diagnosePages,
  executeAutoActions,
  fetchAdInsights,
  fetchPageStats,
  reconcileFindings,
  THRESHOLDS,
  type AdInsight,
  type AutoActionRequest,
  type ExistingFindingRow,
  type Finding,
} from "@/lib/ads-diagnostics";

export const runtime = "nodejs";
export const maxDuration = 60;

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

  const supabase = createAdminClient();
  const now = new Date();
  const pageSince = new Date(now.getTime() - THRESHOLDS.pageWindowDays * 86_400_000);
  const adSince = new Date(now.getTime() - THRESHOLDS.adWindowDays * 86_400_000);

  // Open a run row so partial failures still leave a trail.
  const { data: runRow, error: runErr } = await supabase
    .from("ad_diagnostics_runs")
    .insert({ started_at: now.toISOString() })
    .select("id")
    .single();
  if (runErr || !runRow) {
    return NextResponse.json(
      { error: `failed to open run: ${runErr?.message ?? "no row"}` },
      { status: 500 }
    );
  }
  const runId = (runRow as { id: number }).id;

  let pageStats: Awaited<ReturnType<typeof fetchPageStats>> = [];
  let adInsights: AdInsight[] = [];
  const errors: string[] = [];

  try {
    pageStats = await fetchPageStats(supabase, pageSince.toISOString());
  } catch (e) {
    errors.push(`pages: ${(e as Error).message}`);
  }

  // An ad account we could not read must never read as "all clear", but a
  // genuinely quiet account must not cry wolf either. Empty insights are
  // therefore judged against how many ads are actually live right now.
  let adsIdle = false;
  try {
    const result = await fetchAdInsights(adSince.toISOString(), now.toISOString());
    if (!result.ok) {
      errors.push(`ads: ${result.reason}`);
    } else if (result.ads.length === 0) {
      if (result.activeAds === null) {
        errors.push(
          "ads: Meta ตอบกลับ 0 โฆษณา และเช็คไม่ได้ว่ามีโฆษณาวิ่งอยู่ไหม — ผลรอบนี้เชื่อไม่ได้"
        );
      } else if (result.activeAds > 0) {
        errors.push(
          `ads: บัญชีมีโฆษณา ACTIVE ${result.activeAds} ตัว แต่ insights คืน 0 — token/สิทธิ์น่าจะมีปัญหา`
        );
      } else {
        // 0 insights, 0 active ads — nothing is running, so nothing to find.
        adsIdle = true;
      }
    } else {
      adInsights = result.ads;
    }
  } catch (e) {
    errors.push(`ads: ${(e as Error).message}`);
  }

  const findings: Finding[] = [
    ...diagnosePages(pageStats),
    ...diagnoseAds(adInsights),
  ];

  // Reconcile against yesterday's open/recently-resolved rows so a recurring
  // issue supersedes its own old row instead of piling up a fresh one every
  // night, a cleared issue closes itself, and an already-paused ad that
  // still trips a threshold doesn't reopen a finding that's already handled.
  // Query failure fails open (rec = only what diagnose* produced) so a
  // Supabase hiccup never silently closes real open findings.
  let rec: ReturnType<typeof reconcileFindings> = {
    toInsert: findings,
    supersededIds: [],
    clearedIds: [],
    skippedAlreadyHandled: [],
  };
  const { data: existingRows, error: existingErr } = await supabase
    .from("ad_diagnostics_findings")
    .select("id, entity_type, entity_id, category, resolved, resolved_at")
    .or(`resolved.eq.false,resolved_at.gte.${adSince.toISOString()}`)
    .limit(5000);
  if (existingErr) {
    errors.push(`reconcile skipped: ${existingErr.message}`);
  } else {
    rec = reconcileFindings({
      fresh: findings,
      existing: (existingRows ?? []) as ExistingFindingRow[],
      pages: pageStats,
      ads: adInsights,
      now,
    });
  }

  // Persist findings (one batch insert), keep IDs for action linkage.
  const findingIds = new Map<Finding, number>();
  if (rec.toInsert.length) {
    const rows = rec.toInsert.map((f) => ({
      run_id: runId,
      severity: f.severity,
      category: f.category,
      entity_type: f.entityType,
      entity_id: f.entityId,
      entity_label: f.entityLabel ?? null,
      metric_snapshot: f.metricSnapshot,
      recommendation: f.recommendation,
    }));
    const { data, error } = await supabase
      .from("ad_diagnostics_findings")
      .insert(rows)
      .select("id");
    if (error) {
      errors.push(`findings insert: ${error.message}`);
    } else if (data) {
      data.forEach((r, idx) => findingIds.set(rec.toInsert[idx], (r as { id: number }).id));

      // Only close old rows once the fresh ones actually landed — an insert
      // failure must never silently resolve findings nobody re-recorded.
      const toResolve = [...rec.supersededIds, ...rec.clearedIds];
      for (let i = 0; i < toResolve.length; i += 200) {
        const chunk = toResolve.slice(i, i + 200);
        const { error: resolveErr } = await supabase
          .from("ad_diagnostics_findings")
          .update({ resolved: true, resolved_at: now.toISOString() })
          .in("id", chunk);
        if (resolveErr) errors.push(`auto-resolve: ${resolveErr.message}`);
      }
    }
  }

  // Execute auto-actions on the safe subset.
  const actionRequests: { req: AutoActionRequest; findingId: number | null }[] = [];
  for (const f of rec.toInsert) {
    if (!f.autoAction) continue;
    actionRequests.push({ req: f.autoAction, findingId: findingIds.get(f) ?? null });
  }

  let actionsTaken = 0;
  if (actionRequests.length) {
    const results = await executeAutoActions(actionRequests.map((a) => a.req));
    const auditRows = results.map((r, idx) => ({
      finding_id: actionRequests[idx].findingId,
      run_id: runId,
      action: r.request.action,
      entity_type: r.request.entityType,
      entity_id: r.request.entityId,
      prior_state: r.priorState,
      result: { ok: r.ok, body: r.result, error: r.error ?? null },
      ok: r.ok,
    }));
    if (auditRows.length) {
      const { error } = await supabase.from("ad_auto_actions").insert(auditRows);
      if (error) errors.push(`auto_actions insert: ${error.message}`);
    }

    // Mirror the action onto the finding row.
    for (let i = 0; i < results.length; i++) {
      const r = results[i];
      const findingId = actionRequests[i].findingId;
      if (!findingId) continue;
      if (r.ok) {
        actionsTaken += 1;
        await supabase
          .from("ad_diagnostics_findings")
          .update({ auto_action_taken: r.request.action })
          .eq("id", findingId);
      }
    }
  }

  const ok = errors.length === 0;
  const summary = {
    pagesScanned: pageStats.length,
    adsScanned: adInsights.length,
    // Distinguishes "nothing is running" from "we read nothing" for the
    // morning digest; both leave adsScanned at 0.
    adsIdle,
    detected: findings.length,
    findings: rec.toInsert.length,
    bySeverity: {
      critical: rec.toInsert.filter((f) => f.severity === "critical").length,
      warn: rec.toInsert.filter((f) => f.severity === "warn").length,
      info: rec.toInsert.filter((f) => f.severity === "info").length,
    },
    autoResolved: {
      superseded: rec.supersededIds.length,
      cleared: rec.clearedIds.length,
    },
    skippedAlreadyHandled: rec.skippedAlreadyHandled.length,
    actionsTaken,
    errors,
  };

  await supabase
    .from("ad_diagnostics_runs")
    .update({
      finished_at: new Date().toISOString(),
      ok,
      pages_scanned: pageStats.length,
      ads_scanned: adInsights.length,
      findings_count: rec.toInsert.length,
      actions_count: actionsTaken,
      error: errors.length ? errors.join(" | ") : null,
      summary,
    })
    .eq("id", runId);

  return NextResponse.json({ ok, runId, summary });
}
