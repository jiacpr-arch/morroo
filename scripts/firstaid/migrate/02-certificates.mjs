// Copies issued certificates old certificates → new fa_certificates, keyed by
// the public verification code (FA-XXXXXXXX) so old codes keep verifying on
// the new domain. Idempotent — safe to re-run for the cutover delta and
// weekly until Phase 2 moves practical issuance off the old system.
import { oldClient, newClient, pageTable, reportCounts } from "./_common.mjs";

const oldDb = oldClient();
const newDb = newClient();

let copied = 0;

for await (const rows of pageTable(oldDb, "certificates", "issued_at")) {
  const payload = rows.map((r) => ({
    id: r.id,
    learner_id: r.learner_id,
    cohort_id: r.cohort_id,
    kind: r.kind,
    code: r.code,
    issued_at: r.issued_at,
    learner_name: r.learner_name,
    learner_phone: r.learner_phone,
    learner_email: r.learner_email,
    pdpa_consent_at: r.pdpa_consent_at,
    location: r.location,
    source_ref: r.source_ref,
    pdf_url: r.pdf_url,
    revoked_at: r.revoked_at,
  }));
  const { error } = await newDb
    .from("fa_certificates")
    .upsert(payload, { onConflict: "code" });
  if (error) throw new Error(`fa_certificates upsert failed: ${error.message}`);
  copied += payload.length;
  console.log(`…${copied}`);
}

console.log(`Done. upserted=${copied}`);
await reportCounts(oldDb, newDb, [["certificates", "fa_certificates"]]);
