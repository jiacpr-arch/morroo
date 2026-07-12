// Migrates LINE identities: old line_identities → new auth.users + profiles +
// fa_learner_links. Must run FIRST (later scripts copy rows keyed by the same
// learner_id values, and logins on the new system resolve through
// fa_learner_links).
//
// Email note: old accounts without a LINE-shared email used the synthetic
// form line_<uid>@line.firstaid.local — we keep whatever email the old auth
// user had so re-login finds the same account. New signups on the new system
// use @line.morroo.com, but identity resolution is by fa_learner_links
// (line_user_id) first, so the two conventions coexist safely.
import { oldClient, newClient, pageTable, reportCounts } from "./_common.mjs";

const oldDb = oldClient();
const newDb = newClient();

// Find an existing new-project auth user by email via the profiles table
// (avoids paginating the whole auth.users list).
async function findUserIdByEmail(email) {
  const { data, error } = await newDb
    .from("profiles")
    .select("id")
    .eq("email", email)
    .maybeSingle();
  if (error) throw new Error(`profiles lookup failed: ${error.message}`);
  return data?.id ?? null;
}

let migrated = 0;
let skipped = 0;

for await (const rows of pageTable(oldDb, "line_identities", "created_at")) {
  for (const row of rows) {
    // Already linked in the new project? (idempotent re-run)
    const { data: existingLink } = await newDb
      .from("fa_learner_links")
      .select("line_user_id")
      .eq("line_user_id", row.line_user_id)
      .maybeSingle();
    if (existingLink) {
      skipped++;
      continue;
    }

    const email = row.email || `line_${row.line_user_id}@line.firstaid.local`;

    let userId = await findUserIdByEmail(email);
    if (!userId) {
      const { data: created, error: createError } =
        await newDb.auth.admin.createUser({
          email,
          email_confirm: true,
          user_metadata: {
            name: row.display_name ?? "",
            avatar_url: row.picture_url ?? undefined,
            provider: "line",
            migrated_from: "firstaid",
          },
        });
      if (createError) {
        // Race/re-run tolerance: user may exist without a profile row yet.
        if (`${createError.message}`.includes("already")) {
          userId = await findUserIdByEmail(email);
        }
        if (!userId) {
          console.error(
            `createUser failed for ${row.line_user_id}: ${createError.message}`,
          );
          continue;
        }
      } else {
        userId = created.user.id;
      }
    }

    // firstaid users must never be trapped in morroo's onboarding flow.
    const { error: profileError } = await newDb.from("profiles").upsert(
      {
        id: userId,
        email,
        name: row.display_name ?? "",
        role: "user",
        membership_type: "free",
        onboarding_done: true,
        line_user_id: row.line_user_id,
        line_linked_at: row.created_at,
      },
      { onConflict: "id" },
    );
    if (profileError) {
      console.error(
        `profiles upsert failed for ${row.line_user_id}: ${profileError.message}`,
      );
      continue;
    }

    const { error: linkError } = await newDb.from("fa_learner_links").upsert(
      {
        line_user_id: row.line_user_id,
        auth_user_id: userId,
        learner_id: row.learner_id,
        email: row.email ?? null,
        display_name: row.display_name ?? null,
        picture_url: row.picture_url ?? null,
        nurture_opted_out: row.nurture_opted_out ?? false,
        nurture_opted_out_at: row.nurture_opted_out_at ?? null,
        created_at: row.created_at,
      },
      { onConflict: "line_user_id" },
    );
    if (linkError) {
      console.error(
        `fa_learner_links upsert failed for ${row.line_user_id}: ${linkError.message}`,
      );
      continue;
    }
    migrated++;
  }
  console.log(`…migrated ${migrated} (skipped ${skipped} already-linked)`);
}

console.log(`Done. migrated=${migrated} skipped=${skipped}`);
await reportCounts(oldDb, newDb, [["line_identities", "fa_learner_links"]]);
