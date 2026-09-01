// Copies the paywall state: lesson_entitlements → fa_lesson_entitlements and
// vouchers → fa_vouchers. Vouchers are copied in EVERY status — a code
// redeemed on the old system must not be replayable on the new one.
import { oldClient, newClient, pageTable, reportCounts } from "./_common.mjs";

const oldDb = oldClient();
const newDb = newClient();

let entitlements = 0;
for await (const rows of pageTable(oldDb, "lesson_entitlements", "granted_at")) {
  const { error } = await newDb.from("fa_lesson_entitlements").upsert(
    rows.map((r) => ({
      learner_id: r.learner_id,
      chapter: r.chapter,
      source: r.source,
      order_ref: r.order_ref,
      granted_at: r.granted_at,
    })),
    { onConflict: "learner_id,chapter" },
  );
  if (error)
    throw new Error(`fa_lesson_entitlements upsert failed: ${error.message}`);
  entitlements += rows.length;
}
console.log(`lesson_entitlements → fa_lesson_entitlements: ${entitlements}`);

let vouchers = 0;
for await (const rows of pageTable(oldDb, "vouchers", "created_at")) {
  const { error } = await newDb.from("fa_vouchers").upsert(
    rows.map((r) => ({
      code: r.code,
      chapter: r.chapter,
      status: r.status,
      price_thb: r.price_thb,
      redeemed_by: r.redeemed_by,
      redeemed_at: r.redeemed_at,
      // created_by references old-project auth users — drop the FK value
      // rather than import instructor accounts in Phase 1.
      created_by: null,
      created_at: r.created_at,
    })),
    { onConflict: "code" },
  );
  if (error) throw new Error(`fa_vouchers upsert failed: ${error.message}`);
  vouchers += rows.length;
}
console.log(`vouchers → fa_vouchers: ${vouchers}`);

await reportCounts(oldDb, newDb, [
  ["lesson_entitlements", "fa_lesson_entitlements"],
  ["vouchers", "fa_vouchers"],
]);
