// Small fetch helpers shared by the ACLS admin components. Unlike
// acls-emr's `authedFetch` (which attached a Supabase bearer token), morroo's
// admin API routes are guarded by `requireAdmin()` reading the Supabase
// session cookie — same-origin `fetch` sends it automatically, so no auth
// header plumbing is needed here.

async function parseJson(res: Response) {
  return res.json().catch(() => ({}));
}

export class ApiError extends Error {}

export async function apiGet<T = unknown>(path: string): Promise<T> {
  const res = await fetch(path);
  const json = await parseJson(res);
  if (!res.ok) throw new ApiError(json?.error || `HTTP ${res.status}`);
  return json as T;
}

export async function apiPost<T = unknown>(path: string, body?: unknown): Promise<T> {
  const res = await fetch(path, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body ?? {}),
  });
  const json = await parseJson(res);
  if (!res.ok) throw new ApiError(json?.error || `HTTP ${res.status}`);
  return json as T;
}

export async function apiPatch<T = unknown>(path: string, body?: unknown): Promise<T> {
  const res = await fetch(path, {
    method: "PATCH",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body ?? {}),
  });
  const json = await parseJson(res);
  if (!res.ok) throw new ApiError(json?.error || `HTTP ${res.status}`);
  return json as T;
}

export async function apiDelete<T = unknown>(path: string): Promise<T> {
  const res = await fetch(path, { method: "DELETE" });
  const json = await parseJson(res);
  if (!res.ok) throw new ApiError(json?.error || `HTTP ${res.status}`);
  return json as T;
}

export async function apiUpload<T = unknown>(path: string, form: FormData): Promise<T> {
  const res = await fetch(path, { method: "POST", body: form });
  const json = await parseJson(res);
  if (!res.ok) throw new ApiError(json?.error || `HTTP ${res.status}`);
  return json as T;
}

function errMsg(err: unknown): string {
  return err instanceof Error ? err.message : String(err);
}

export { errMsg };
