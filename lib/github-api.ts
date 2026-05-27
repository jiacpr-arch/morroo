/**
 * Thin GitHub REST API wrapper for server-side Vercel functions.
 *
 * Used by the ads-autofix-suggest cron (open PR) and the LINE webhook
 * (merge PR / close PR) — both run inside Vercel Cloud Functions where
 * the GitHub MCP tool is unavailable.
 *
 * Required env:
 *   GITHUB_TOKEN  — fine-grained PAT scoped to jiacpr-arch/morroo with
 *                   Contents=Write + Pull requests=Write
 *
 * Optional:
 *   GITHUB_REPO   — defaults to "jiacpr-arch/morroo"
 */

const API_BASE = "https://api.github.com";

export interface GhConfig {
  token: string;
  owner: string;
  repo: string;
}

export function getGhConfig(): GhConfig | null {
  const token = process.env.GITHUB_TOKEN;
  if (!token) return null;
  const repoEnv = (process.env.GITHUB_REPO ?? "jiacpr-arch/morroo").trim();
  const [owner, repo] = repoEnv.split("/");
  if (!owner || !repo) return null;
  return { token, owner, repo };
}

async function gh<T = unknown>(
  cfg: GhConfig,
  path: string,
  init?: RequestInit
): Promise<{ ok: boolean; status: number; data: T; raw: Response }> {
  const res = await fetch(`${API_BASE}${path}`, {
    ...init,
    headers: {
      Authorization: `Bearer ${cfg.token}`,
      Accept: "application/vnd.github+json",
      "X-GitHub-Api-Version": "2022-11-28",
      "Content-Type": "application/json",
      ...(init?.headers ?? {}),
    },
  });
  const text = await res.text();
  let data: unknown = null;
  try { data = text ? JSON.parse(text) : null; } catch { data = text; }
  return { ok: res.ok, status: res.status, data: data as T, raw: res };
}

export async function getDefaultBranchSha(cfg: GhConfig, branch = "main"): Promise<string | null> {
  const r = await gh<{ object?: { sha?: string } }>(cfg, `/repos/${cfg.owner}/${cfg.repo}/git/refs/heads/${branch}`);
  return r.ok ? r.data.object?.sha ?? null : null;
}

export async function createBranch(
  cfg: GhConfig,
  newBranch: string,
  fromSha: string
): Promise<boolean> {
  const r = await gh(cfg, `/repos/${cfg.owner}/${cfg.repo}/git/refs`, {
    method: "POST",
    body: JSON.stringify({ ref: `refs/heads/${newBranch}`, sha: fromSha }),
  });
  return r.ok;
}

export async function getFileOnBranch(
  cfg: GhConfig,
  path: string,
  branch: string
): Promise<{ content: string; sha: string } | null> {
  const r = await gh<{ content?: string; sha?: string; encoding?: string }>(
    cfg,
    `/repos/${cfg.owner}/${cfg.repo}/contents/${encodeURIComponent(path)}?ref=${branch}`
  );
  if (!r.ok || !r.data.content || !r.data.sha) return null;
  const content =
    r.data.encoding === "base64"
      ? Buffer.from(r.data.content, "base64").toString("utf8")
      : r.data.content;
  return { content, sha: r.data.sha };
}

export async function putFile(
  cfg: GhConfig,
  path: string,
  branch: string,
  newContent: string,
  sha: string,
  message: string
): Promise<boolean> {
  const r = await gh(cfg, `/repos/${cfg.owner}/${cfg.repo}/contents/${encodeURIComponent(path)}`, {
    method: "PUT",
    body: JSON.stringify({
      message,
      content: Buffer.from(newContent, "utf8").toString("base64"),
      sha,
      branch,
    }),
  });
  return r.ok;
}

export interface OpenPrResult {
  number: number;
  html_url: string;
  head: { sha: string };
}

export async function openPullRequest(
  cfg: GhConfig,
  args: { title: string; body: string; head: string; base?: string; draft?: boolean; labels?: string[] }
): Promise<OpenPrResult | null> {
  const r = await gh<OpenPrResult>(cfg, `/repos/${cfg.owner}/${cfg.repo}/pulls`, {
    method: "POST",
    body: JSON.stringify({
      title: args.title,
      body: args.body,
      head: args.head,
      base: args.base ?? "main",
      draft: args.draft ?? true,
    }),
  });
  if (!r.ok) return null;

  if (args.labels?.length) {
    await gh(cfg, `/repos/${cfg.owner}/${cfg.repo}/issues/${r.data.number}/labels`, {
      method: "POST",
      body: JSON.stringify({ labels: args.labels }),
    });
  }
  return r.data;
}

export async function getPull(
  cfg: GhConfig,
  prNumber: number
): Promise<{ state: string; merged: boolean; head: { ref: string; sha: string }; labels: { name: string }[] } | null> {
  const r = await gh<{
    state: string;
    merged: boolean;
    head: { ref: string; sha: string };
    labels: { name: string }[];
  }>(cfg, `/repos/${cfg.owner}/${cfg.repo}/pulls/${prNumber}`);
  return r.ok ? r.data : null;
}

export async function getCombinedStatus(
  cfg: GhConfig,
  sha: string
): Promise<{ state: string; total_count: number }> {
  const r = await gh<{ state: string; total_count: number }>(
    cfg,
    `/repos/${cfg.owner}/${cfg.repo}/commits/${sha}/status`
  );
  return r.ok ? r.data : { state: "unknown", total_count: 0 };
}

export async function mergePullRequest(
  cfg: GhConfig,
  prNumber: number,
  opts?: { method?: "merge" | "squash" | "rebase"; commitTitle?: string }
): Promise<{ ok: boolean; error?: string; sha?: string }> {
  const r = await gh<{ sha?: string; message?: string }>(
    cfg,
    `/repos/${cfg.owner}/${cfg.repo}/pulls/${prNumber}/merge`,
    {
      method: "PUT",
      body: JSON.stringify({
        merge_method: opts?.method ?? "squash",
        ...(opts?.commitTitle ? { commit_title: opts.commitTitle } : {}),
      }),
    }
  );
  if (!r.ok) return { ok: false, error: `HTTP ${r.status}: ${r.data?.message ?? "unknown"}` };
  return { ok: true, sha: r.data.sha };
}

export async function closePullRequest(cfg: GhConfig, prNumber: number): Promise<boolean> {
  const r = await gh(cfg, `/repos/${cfg.owner}/${cfg.repo}/pulls/${prNumber}`, {
    method: "PATCH",
    body: JSON.stringify({ state: "closed" }),
  });
  return r.ok;
}

export async function deleteBranch(cfg: GhConfig, branch: string): Promise<boolean> {
  const r = await gh(cfg, `/repos/${cfg.owner}/${cfg.repo}/git/refs/heads/${encodeURIComponent(branch)}`, {
    method: "DELETE",
  });
  return r.ok;
}

/** Mark a draft PR as ready-for-review so it shows up as a merge candidate. */
export async function markReady(cfg: GhConfig, prNodeId: string): Promise<boolean> {
  const query = `mutation($id: ID!) { markPullRequestReadyForReview(input:{pullRequestId:$id}) { clientMutationId } }`;
  const res = await fetch(`${API_BASE}/graphql`, {
    method: "POST",
    headers: {
      Authorization: `Bearer ${cfg.token}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ query, variables: { id: prNodeId } }),
  });
  return res.ok;
}
