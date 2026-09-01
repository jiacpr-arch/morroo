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
  THRESHOLDS,
  type AutoActionRequest,
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
  let adInsights: Awaited<ReturnType<typeof fetchAdInsights>> = [];
  const errors: string[] = [];

  try {
    pageStats = await fetchPageStats(supabase, pageSince.toISOString());
  } catch (e) {
    errors.push(`pages: ${(e as Error).message}`);
  }

  try {
    adInsights = await fetchAdInsights(adSince.toISOString(), now.toISOString());
  } catch (e) {
    errors.push(`ads: ${(e as Error).message}`);
  }

  const findings: Finding[] = [
    ...diagnosePages(pageStats),
    ...diagnoseAds(adInsights),
  ];

  // Persist findings (one batch insert), keep IDs for action linkage.
  const findingIds = new Map<Finding, number>();
  if (findings.length) {
    const rows = findings.map((f) => ({
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
      data.forEach((r, idx) => findingIds.set(findings[idx], (r as { id: number }).id));
    }
  }

  // Execute auto-actions on the safe subset.
  const actionRequests: { req: AutoActionRequest; findingId: number | null }[] = [];
  for (const f of findings) {
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
    findings: findings.length,
    bySeverity: {
      critical: findings.filter((f) => f.severity === "critical").length,
      warn: findings.filter((f) => f.severity === "warn").length,
      info: findings.filter((f) => f.severity === "info").length,
    },
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
      findings_count: findings.length,
      actions_count: actionsTaken,
      error: errors.length ? errors.join(" | ") : null,
      summary,
    })
    .eq("id", runId);

  return NextResponse.json({ ok, runId, summary });
}
