// Migrates LINE identities: old line_identities → fa_migrated_learners (a
// staging map with no FK to auth.users). Old auth users are NOT copied —
// when a migrated learner logs in with LINE on the new system, the callback
// (app/api/firstaid/auth/line/callback) finds their row here, adopts the old
// learner_id, and creates the real auth user + fa_learner_links row on the
// spot. Their progress/certificates (keyed by learner_id) reconnect
// automatically.
//
// Must run before the other copy scripts only by convention (nothing breaks
// otherwise). Idempotent — upsert on line_user_id, re-runnable for the
// cutover delta.
import { oldClient, newClient, pageTable, reportCounts } from "./_common.mjs";

const oldDb = oldClient();
const newDb = newClient();

let copied = 0;

for await (const rows of pageTable(oldDb, "line_identities", "created_at")) {
  const payload = rows.map((r) => ({
    line_user_id: r.line_user_id,
    learner_id: r.learner_id,
    email: r.email ?? null,
    display_name: r.display_name ?? null,
    picture_url: r.picture_url ?? null,
    nurture_opted_out: r.nurture_opted_out ?? false,
    nurture_opted_out_at: r.nurture_opted_out_at ?? null,
    created_at: r.created_at,
  }));
  const { error } = await newDb
    .from("fa_migrated_learners")
    .upsert(payload, { onConflict: "line_user_id" });
  if (error)
    throw new Error(`fa_migrated_learners upsert failed: ${error.message}`);
  copied += payload.length;
  console.log(`…${copied}`);
}

console.log(`Done. upserted=${copied}`);
await reportCounts(oldDb, newDb, [["line_identities", "fa_migrated_learners"]]);
