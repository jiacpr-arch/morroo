/**
 * LINE postback handlers for the ads-autofix-suggest PR flow.
 *
 * Wires up the buttons rendered by buildAdsSuggestFlex /
 * buildAdsMergeConfirmFlex (in lib/line-flex-templates.ts):
 *
 *   merge_pr           → reply with 2-step confirm flex
 *   merge_pr_confirm   → call GitHub merge API, reply with result
 *   dismiss_pr         → close PR, snooze finding for 30d
 *   cancel             → reply "ยกเลิกแล้ว"
 *
 * All actions are gated on lineUserId === ADMIN_LINE_USER_ID, since LINE
 * postbacks have no other authentication surface.
 */

import type { SupabaseClient } from "@supabase/supabase-js";
import type { LineMessage } from "@/lib/line";
import {
  closePullRequest,
  getCombinedStatus,
  getGhConfig,
  getPull,
  mergePullRequest,
} from "@/lib/github-api";

const SUGGEST_LABEL = "ads-autofix-suggest";
const SNOOZE_DAYS = 30;

function parseData(data: string): Record<string, string> {
  const out: Record<string, string> = {};
  for (const part of data.split("&")) {
    const [k, v] = part.split("=");
    if (k) out[decodeURIComponent(k)] = decodeURIComponent(v ?? "");
  }
  return out;
}

function txt(text: string): LineMessage {
  return { type: "text", text };
}

type SuggestRow = {
  id: number;
  finding_id: number | null;
  page_path: string;
  pr_number: number;
  pr_url: string;
  branch: string;
  status: string;
};

async function loadSuggestRow(
  supabase: SupabaseClient,
  prNumber: number
): Promise<SuggestRow | null> {
  const { data } = await supabase
    .from("ad_suggest_prs")
    .select("id, finding_id, page_path, pr_number, pr_url, branch, status")
    .eq("pr_number", prNumber)
    .maybeSingle();
  return (data as SuggestRow | null) ?? null;
}

export async function handleAdsAutofixPostback(
  supabase: SupabaseClient,
  lineUserId: string,
  rawData: string,
  buildConfirmFlex: (args: {
    prNumber: number;
    prUrl: string;
    pagePath: string;
  }) => LineMessage
): Promise<LineMessage[] | null> {
  const params = parseData(rawData);
  const action = params.action;
  if (!action) return null;

  // Only ads-autofix actions; all other postbacks fall through.
  const isAdsAction =
    action === "merge_pr" ||
    action === "merge_pr_confirm" ||
    action === "dismiss_pr" ||
    (action === "cancel" && params.pr);
  if (!isAdsAction) return null;

  const adminLineId = process.env.ADMIN_LINE_USER_ID;
  if (!adminLineId || lineUserId !== adminLineId) {
    return [txt("⛔ การกระทำนี้สำหรับแอดมินเท่านั้น")];
  }

  const prNumber = Number(params.pr);
  if (!Number.isFinite(prNumber)) {
    return [txt("PR number ไม่ถูกต้อง")];
  }

  if (action === "cancel") {
    return [txt("ยกเลิกแล้ว")];
  }

  const suggest = await loadSuggestRow(supabase, prNumber);
  if (!suggest) {
    return [txt(`ไม่พบ ads-autofix PR #${prNumber} ในฐานข้อมูล`)];
  }

  // Step 1: show confirm flex
  if (action === "merge_pr") {
    return [
      buildConfirmFlex({
        prNumber: suggest.pr_number,
        prUrl: suggest.pr_url,
        pagePath: suggest.page_path,
      }),
    ];
  }

  const cfg = getGhConfig();
  if (!cfg) return [txt("⚠️ GITHUB_TOKEN ยังไม่ตั้งใน env — merge ผ่าน LINE ไม่ได้")];

  // Step 2: confirmed merge
  if (action === "merge_pr_confirm") {
    const pull = await getPull(cfg, prNumber);
    if (!pull) return [txt(`เปิด PR #${prNumber} ไม่เจอบน GitHub`)];
    if (pull.merged) return [txt(`PR #${prNumber} merged แล้ว`)];
    if (pull.state !== "open") return [txt(`PR #${prNumber} ปิดไปแล้ว (${pull.state})`)];

    // Gate: only auto-managed PRs
    if (!pull.labels.some((l) => l.name === SUGGEST_LABEL)) {
      return [txt(`PR #${prNumber} ไม่มี label \`${SUGGEST_LABEL}\` — refusing to merge`)];
    }

    const status = await getCombinedStatus(cfg, pull.head.sha);
    if (status.state === "pending") {
      return [txt(`CI ยัง pending — รอ check ผ่านก่อนนะครับ`)];
    }
    if (status.state === "failure" || status.state === "error") {
      return [txt(`CI fail (${status.state}) — แก้ก่อน merge`)];
    }

    const result = await mergePullRequest(cfg, prNumber, {
      method: "squash",
      commitTitle: `feat(lp): AI-suggested rewrite ${suggest.page_path} (#${prNumber})`,
    });
    if (!result.ok) {
      return [txt(`❌ Merge ล้มเหลว: ${result.error}`)];
    }

    await supabase
      .from("ad_suggest_prs")
      .update({
        status: "merged",
        merged_at: new Date().toISOString(),
        updated_at: new Date().toISOString(),
      })
      .eq("pr_number", prNumber);

    return [
      txt(
        `✅ Merged PR #${prNumber}\n${suggest.page_path}\nVercel deploy ~2 นาที — ระบบจะติดตาม conversion 7 วัน`
      ),
    ];
  }

  // Dismiss: close PR, snooze
  if (action === "dismiss_pr") {
    const pull = await getPull(cfg, prNumber);
    if (pull && pull.state === "open") {
      await closePullRequest(cfg, prNumber);
    }

    const until = new Date(Date.now() + SNOOZE_DAYS * 86_400_000).toISOString();

    if (suggest.finding_id) {
      const { data: finding } = await supabase
        .from("ad_diagnostics_findings")
        .select("entity_id, category")
        .eq("id", suggest.finding_id)
        .maybeSingle();
      if (finding) {
        await supabase
          .from("ad_finding_snooze")
          .upsert(
            {
              entity_id: (finding as { entity_id: string }).entity_id,
              category: (finding as { category: string }).category,
              snoozed_until: until,
              reason: `dismissed via LINE on PR #${prNumber}`,
            },
            { onConflict: "entity_id,category" }
          );
      }
    }

    await supabase
      .from("ad_suggest_prs")
      .update({
        status: "snoozed",
        updated_at: new Date().toISOString(),
      })
      .eq("pr_number", prNumber);

    return [
      txt(`👋 Dismissed PR #${prNumber} — snooze ${SNOOZE_DAYS} วัน`),
    ];
  }

  return null;
}
