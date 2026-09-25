/**
 * Helpers for reading more rows than one PostgREST request returns.
 *
 * PostgREST silently caps every response at `max-rows` (1000 on Supabase),
 * and a long `.in("col", ids)` list becomes a URL the gateway rejects. These
 * keep both bounded: page with `.range()` until a short page, and split id
 * lists into chunks run with limited concurrency. Pure — no Supabase import.
 */

/** Supabase's default `max-rows`; a page shorter than this is the last one. */
export const PAGE_SIZE = 1000;

/** ids per `.in()` filter — ~100 uuids keep the URL well under 8 KB. */
export const IN_CHUNK = 100;

export function chunk<T>(items: readonly T[], size: number): T[][] {
  if (size < 1) throw new Error("chunk size must be >= 1");
  const out: T[][] = [];
  for (let i = 0; i < items.length; i += size) out.push(items.slice(i, i + size));
  return out;
}

/** `Promise.all(items.map(fn))`, but at most `limit` calls in flight. Order kept. */
export async function mapLimit<T, R>(
  items: readonly T[],
  limit: number,
  fn: (item: T, index: number) => Promise<R>
): Promise<R[]> {
  const out = new Array<R>(items.length);
  let next = 0;
  const worker = async () => {
    while (next < items.length) {
      const i = next++;
      out[i] = await fn(items[i], i);
    }
  };
  await Promise.all(Array.from({ length: Math.min(Math.max(1, limit), items.length) }, worker));
  return out;
}

type PageResult<T> = { data: T[] | null; error: { message: string } | null };

/**
 * Read every row of a query page by page. `page(from, to)` must apply a
 * stable `.order()` and `.range(from, to)`. Stops at a short page or at
 * `maxRows` (then `truncated` is true). An error is returned, never swallowed
 * as "no more data".
 */
export async function fetchAllPages<T>(
  page: (from: number, to: number) => PromiseLike<PageResult<T>>,
  opts: { pageSize?: number; maxRows?: number } = {}
): Promise<{ rows: T[]; error: string | null; truncated: boolean }> {
  const size = opts.pageSize ?? PAGE_SIZE;
  const max = opts.maxRows ?? Infinity;
  const rows: T[] = [];
  for (let from = 0; from < max; from += size) {
    const { data, error } = await page(from, from + size - 1);
    if (error) return { rows, error: error.message, truncated: false };
    const got = data ?? [];
    rows.push(...got);
    if (got.length < size) return { rows, error: null, truncated: false };
  }
  return { rows, error: null, truncated: true };
}
