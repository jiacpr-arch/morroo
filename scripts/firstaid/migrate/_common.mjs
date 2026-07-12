// Shared plumbing for the firstaid → morroo Supabase data migration.
// Every script is idempotent (upsert on natural keys) so the whole set can be
// re-run for the cutover delta pass — and weekly afterwards until Phase 2
// (practical certs issued on the old system keep flowing across).
//
// Required env:
//   OLD_SUPABASE_URL, OLD_SUPABASE_SERVICE_ROLE_KEY   (firstaid project)
//   NEW_SUPABASE_URL, NEW_SUPABASE_SERVICE_ROLE_KEY   (morroo project)
import { createClient } from "@supabase/supabase-js";

function required(name) {
  const v = process.env[name];
  if (!v) {
    console.error(`Missing env ${name}`);
    process.exit(1);
  }
  return v;
}

export function oldClient() {
  return createClient(
    required("OLD_SUPABASE_URL"),
    required("OLD_SUPABASE_SERVICE_ROLE_KEY"),
    { auth: { persistSession: false } },
  );
}

export function newClient() {
  return createClient(
    required("NEW_SUPABASE_URL"),
    required("NEW_SUPABASE_SERVICE_ROLE_KEY"),
    { auth: { persistSession: false } },
  );
}

// Page through an entire table, oldest first, in chunks of 1000.
export async function* pageTable(client, table, orderColumn = "id") {
  const PAGE = 1000;
  let from = 0;
  for (;;) {
    const { data, error } = await client
      .from(table)
      .select("*")
      .order(orderColumn, { ascending: true })
      .range(from, from + PAGE - 1);
    if (error) throw new Error(`${table} page failed: ${error.message}`);
    if (!data || data.length === 0) return;
    yield data;
    if (data.length < PAGE) return;
    from += PAGE;
  }
}

export async function countRows(client, table) {
  const { count, error } = await client
    .from(table)
    .select("*", { count: "exact", head: true });
  if (error) throw new Error(`${table} count failed: ${error.message}`);
  return count ?? 0;
}

export async function reportCounts(oldDb, newDb, pairs) {
  for (const [oldTable, newTable] of pairs) {
    const [a, b] = await Promise.all([
      countRows(oldDb, oldTable),
      countRows(newDb, newTable),
    ]);
    const flag = b >= a ? "OK " : "MISSING";
    console.log(`${flag}  ${oldTable}: old=${a}  ${newTable}: new=${b}`);
  }
}
