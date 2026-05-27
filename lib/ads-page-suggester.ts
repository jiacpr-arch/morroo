/**
 * AI-driven landing-page rewrite suggestions.
 *
 * Pipeline (called from /api/cron/ads-autofix-suggest):
 *
 *   1. pickFindingsToSuggest()  → recent unresolved page findings without a
 *      live suggest PR + not snoozed
 *   2. for each finding:
 *        - resolve page file (/lp/foo → app/lp/foo/page.tsx)
 *        - load current source via GitHub contents API
 *        - generateSuggestion() — Claude rewrites the JSX file
 *        - runRiskChecks() — verify tracking pixels, events, JSX shape
 *        - if checks pass → openSuggestPR()
 *        - persist row in ad_suggest_prs with baseline_metrics
 *        - push LINE Flex with merge/dismiss postback buttons
 *
 * Never auto-merges. The LINE webhook handles human-confirmed merges.
 */

import Anthropic from "@anthropic-ai/sdk";
import type { SupabaseClient } from "@supabase/supabase-js";
import {
  createBranch,
  getDefaultBranchSha,
  getFileOnBranch,
  getGhConfig,
  openPullRequest,
  putFile,
  type OpenPrResult,
} from "@/lib/github-api";

const SUGGESTER_MODEL = "claude-sonnet-4-6";
const SUGGEST_LABEL = "ads-autofix-suggest";

export interface PageFinding {
  id: number;
  entity_id: string;     // "/lp/foo"
  severity: string;
  category: string;
  metric_snapshot: Record<string, unknown>;
  recommendation: string;
}

export interface RiskCheck {
  name: string;
  ok: boolean;
  detail?: string;
}

// ─── Page file resolution ────────────────────────────────────────────────

/**
 * `/lp/free-trial` → `app/lp/free-trial/page.tsx`
 * `/p/something`    → `app/p/something/page.tsx`
 * Returns null if the path doesn't look like a known LP shape.
 */
export function findPageFile(pagePath: string): string | null {
  const clean = pagePath.split("?")[0];
  const segs = clean.split("/").filter(Boolean);
  if (segs.length === 0) return null;
  const allowedRoots = new Set(["lp", "p"]);
  if (!allowedRoots.has(segs[0])) return null;
  // Refuse dynamic segments like /lp/[hash] — too risky to auto-edit.
  if (segs.some((s) => s.startsWith("["))) return null;
  return `app/${segs.join("/")}/page.tsx`;
}

// ─── Risk checks ─────────────────────────────────────────────────────────

const TRACKING_TOKENS = [
  // Vercel analytics + custom track() — see lib/analytics.ts
  "track(",
  // Common funnel events we don't want AI to silently drop
  "signup_submit",
  "exam_start_click",
  "stripe_checkout_click",
];

const PIXEL_TOKENS = ["sendMetaEvent", "fbq(", "data-pixel", "GTM-", "gtag("];

function countOccurrences(haystack: string, needle: string): number {
  let count = 0;
  let from = 0;
  while (true) {
    const i = haystack.indexOf(needle, from);
    if (i < 0) break;
    count += 1;
    from = i + needle.length;
  }
  return count;
}

export function runRiskChecks(
  originalSrc: string,
  proposedSrc: string
): RiskCheck[] {
  const checks: RiskCheck[] = [];

  // Length sanity: AI shouldn't truncate the page to a stub or balloon it.
  const lenRatio = proposedSrc.length / Math.max(1, originalSrc.length);
  checks.push({
    name: "size within ±40% of original",
    ok: lenRatio >= 0.6 && lenRatio <= 1.4,
    detail: `${(lenRatio * 100).toFixed(0)}% of original`,
  });

  // Each tracking call site present in original must still be present.
  for (const tok of TRACKING_TOKENS) {
    const before = countOccurrences(originalSrc, tok);
    const after = countOccurrences(proposedSrc, tok);
    if (before > 0) {
      checks.push({
        name: `tracking \`${tok}\` preserved`,
        ok: after >= before,
        detail: `before=${before}, after=${after}`,
      });
    }
  }

  // Pixels — same rule: don't lose them.
  for (const tok of PIXEL_TOKENS) {
    const before = countOccurrences(originalSrc, tok);
    if (before === 0) continue;
    const after = countOccurrences(proposedSrc, tok);
    checks.push({
      name: `pixel \`${tok}\` preserved`,
      ok: after >= before,
      detail: `before=${before}, after=${after}`,
    });
  }

  // Imports: anything originally imported must still be either imported or
  // its name still referenced — otherwise the AI likely removed live JSX.
  const importLines = originalSrc.match(/^import[^;]+;$/gm) ?? [];
  for (const line of importLines) {
    if (!proposedSrc.includes(line)) {
      // accept changes if the names are still imported some other way
      const m = line.match(/import\s+(?:type\s+)?(?:\{([^}]+)\}|(\w+))/);
      const names = m
        ? (m[1] ?? m[2] ?? "").split(",").map((s) => s.trim()).filter(Boolean)
        : [];
      const allPresent = names.every((n) => proposedSrc.includes(n));
      if (!allPresent) {
        checks.push({
          name: "imports preserved",
          ok: false,
          detail: `dropped: ${line.trim()}`,
        });
        break;
      }
    }
  }

  // Must still parse as a default-exported page component.
  checks.push({
    name: "exports default function",
    ok: /export\s+default\s+(?:async\s+)?function/.test(proposedSrc),
  });

  // metadata export preserved (SEO)
  if (originalSrc.includes("export const metadata")) {
    checks.push({
      name: "SEO metadata export preserved",
      ok: proposedSrc.includes("export const metadata"),
    });
  }

  return checks;
}

// ─── Claude rewrite ──────────────────────────────────────────────────────

const SUGGEST_SYSTEM = `You rewrite Next.js 16 landing-page React Server Components for a Thai
medical exam-prep product called "MorRoo" (หมอรู้).

You are given:
- The current page source
- Analytics findings that indicate poor conversion

You return the COMPLETE rewritten file source code as a single fenced block:

\`\`\`tsx
<full file content here>
\`\`\`

Hard rules — violating any of these will cause the rewrite to be rejected:
1. KEEP every \`track(...)\`, \`sendMetaEvent(...)\`, \`fbq(...)\` call exactly where it was.
2. KEEP every \`import\` line. You may add new imports but never drop.
3. KEEP the \`export const metadata = {...}\` block intact (SEO).
4. KEEP the default-exported function name.
5. NEVER invent specific numbers (e.g. "ใช้แล้ว 10,000 หมอ", "97% ผ่าน")
   — only use claims that already appear in the original.
6. Preserve Thai language register: professional, concise, no excessive emoji.
7. Keep all form components (\`LeadForm\`, etc.) and their props.

What you CAN change:
- Headline / sub-headline / hero copy
- CTA button text
- Feature card ordering and copy
- Trust signal text (testimonials, badges) — within reason
- Visual hierarchy via Tailwind class adjustments

Output ONLY the code fence, no preamble or explanation.`;

export interface SuggestResult {
  ok: boolean;
  proposedSrc?: string;
  rationale?: string;
  error?: string;
}

function extractCodeBlock(text: string): string | null {
  const m = text.match(/```(?:tsx|jsx|typescript|ts|javascript|js)?\n([\s\S]*?)\n```/);
  return m ? m[1] : null;
}

export async function generateSuggestion(
  finding: PageFinding,
  currentSrc: string
): Promise<SuggestResult> {
  const apiKey = process.env.ANTHROPIC_API_KEY;
  if (!apiKey) return { ok: false, error: "ANTHROPIC_API_KEY not configured" };

  const client = new Anthropic({ apiKey });
  const userMessage = `Page path: ${finding.entity_id}
Severity: ${finding.severity}
Category: ${finding.category}
Why this page is flagged: ${finding.recommendation}

Metrics (7-day window):
${JSON.stringify(finding.metric_snapshot, null, 2)}

Current file source:
\`\`\`tsx
${currentSrc}
\`\`\`

Rewrite the file to address the bottleneck above.`;

  const response = await client.messages.create({
    model: SUGGESTER_MODEL,
    max_tokens: 8000,
    system: SUGGEST_SYSTEM,
    messages: [{ role: "user", content: userMessage }],
  });

  const text = response.content
    .filter((b) => b.type === "text")
    .map((b) => (b as { text: string }).text)
    .join("");

  const code = extractCodeBlock(text);
  if (!code) return { ok: false, error: "Claude did not return a code block" };
  return { ok: true, proposedSrc: code };
}

// ─── PR open ─────────────────────────────────────────────────────────────

export interface OpenedSuggestPr {
  pr: OpenPrResult;
  branch: string;
}

function slugify(text: string): string {
  return text
    .toLowerCase()
    .replace(/[^a-z0-9-]/g, "-")
    .replace(/-+/g, "-")
    .replace(/^-|-$/g, "");
}

function buildPrBody(args: {
  finding: PageFinding;
  pagePath: string;
  baseline: Record<string, unknown>;
  checks: RiskCheck[];
}): string {
  const checkLines = args.checks
    .map((c) => `- ${c.ok ? "✅" : "❌"} ${c.name}${c.detail ? ` _(${c.detail})_` : ""}`)
    .join("\n");

  return `## Why this PR exists

หน้า **\`${args.pagePath}\`** ถูก flag โดย ads-autofix:

> ${args.finding.recommendation}

**Severity:** \`${args.finding.severity}\` · **Category:** \`${args.finding.category}\`

### Baseline metrics (7-day window)
\`\`\`json
${JSON.stringify(args.baseline, null, 2)}
\`\`\`

## Risk checks (auto)
${checkLines}

## What happens after merge
- ระบบจะติดตาม signup rate ของหน้านี้อีก 7 วันแบบอัตโนมัติ
- ถ้า conversion ตกลงจาก baseline เกิน 25% → เปิด revert PR + แจ้ง LINE
- ถ้าดีขึ้น → mark finding #${args.finding.id} resolved + ส่งสรุป LINE

---

🤖 Generated by [ads-autofix-suggest](https://www.morroo.com/admin/ads-diagnostics)
Linked finding: #${args.finding.id}
`;
}

export async function openSuggestPR(args: {
  finding: PageFinding;
  pageFile: string;
  proposedSrc: string;
  checks: RiskCheck[];
  baseline: Record<string, unknown>;
}): Promise<OpenedSuggestPr | { error: string }> {
  const cfg = getGhConfig();
  if (!cfg) return { error: "GITHUB_TOKEN not configured" };

  const baseSha = await getDefaultBranchSha(cfg, "main");
  if (!baseSha) return { error: "could not resolve main branch sha" };

  const stamp = new Date().toISOString().slice(0, 10);
  const slug = slugify(args.finding.entity_id);
  const branch = `ads-autofix/suggest-${slug}-${stamp}-${args.finding.id}`;

  if (!(await createBranch(cfg, branch, baseSha))) {
    return { error: `failed to create branch ${branch}` };
  }

  const existing = await getFileOnBranch(cfg, args.pageFile, branch);
  if (!existing) return { error: `cannot read ${args.pageFile} on branch` };

  const putOk = await putFile(
    cfg,
    args.pageFile,
    branch,
    args.proposedSrc,
    existing.sha,
    `feat(lp): AI suggest rewrite ${args.finding.entity_id}\n\nAuto-generated by ads-autofix-suggest. See PR body for rationale.`
  );
  if (!putOk) return { error: "failed to commit suggested rewrite" };

  const pr = await openPullRequest(cfg, {
    title: `🤖 suggest: rewrite ${args.finding.entity_id} (${args.finding.severity})`,
    body: buildPrBody({
      finding: args.finding,
      pagePath: args.finding.entity_id,
      baseline: args.baseline,
      checks: args.checks,
    }),
    head: branch,
    base: "main",
    draft: true,
    labels: [SUGGEST_LABEL],
  });
  if (!pr) return { error: "failed to open PR" };
  return { pr, branch };
}

// ─── Finding selection ───────────────────────────────────────────────────

/**
 * Page-level findings that:
 *   - are unresolved
 *   - don't already have a live suggest PR
 *   - aren't in the snooze list
 *   - belong to a path we can safely edit (LP-style routes only)
 */
export async function pickFindingsToSuggest(
  supabase: SupabaseClient,
  limit = 3
): Promise<PageFinding[]> {
  const { data: findings, error } = await supabase
    .from("ad_diagnostics_findings")
    .select("id, entity_id, entity_type, severity, category, metric_snapshot, recommendation")
    .eq("entity_type", "page")
    .eq("resolved", false)
    .in("severity", ["critical", "warn"])
    .order("severity", { ascending: true })
    .order("created_at", { ascending: false })
    .limit(50);
  if (error) throw new Error(`pickFindingsToSuggest: ${error.message}`);

  if (!findings || findings.length === 0) return [];

  // Block by finding id AND by page path. A daily diagnose run inserts a fresh
  // finding row for the same (page, issue) every day, so de-duping on
  // finding_id alone would let the daily suggest cron reopen a PR for a page
  // that already has one. One open/merged suggest PR per page at a time.
  const { data: openPrs } = await supabase
    .from("ad_suggest_prs")
    .select("finding_id, page_path")
    .in("status", ["open", "merged"]);
  const blockedFindingIds = new Set<number>();
  const blockedPaths = new Set<string>();
  for (const r of openPrs ?? []) {
    if (r.finding_id != null) blockedFindingIds.add(r.finding_id as number);
    if (r.page_path) blockedPaths.add(r.page_path as string);
  }

  const nowIso = new Date().toISOString();
  const { data: snoozes } = await supabase
    .from("ad_finding_snooze")
    .select("entity_id, category")
    .gt("snoozed_until", nowIso);
  const snoozedKeys = new Set(
    (snoozes ?? []).map((s) => `${s.entity_id}::${s.category}`)
  );

  const picked: PageFinding[] = [];
  for (const f of findings) {
    if (picked.length >= limit) break;
    if (blockedFindingIds.has(f.id)) continue;
    if (blockedPaths.has(f.entity_id)) continue;
    if (snoozedKeys.has(`${f.entity_id}::${f.category}`)) continue;
    if (!findPageFile(f.entity_id)) continue;
    picked.push({
      id: f.id,
      entity_id: f.entity_id,
      severity: f.severity,
      category: f.category,
      metric_snapshot: f.metric_snapshot ?? {},
      recommendation: f.recommendation,
    });
  }
  return picked;
}
