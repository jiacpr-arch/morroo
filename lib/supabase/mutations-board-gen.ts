import { createClient } from "./client";

export async function requeueBoardGenJob(
  originalId: string
): Promise<{ id: string } | null> {
  const supabase = createClient();
  const { data: original, error: readErr } = await supabase
    .from("board_gen_jobs")
    .select("specialty_slug, target_count, trigger, user_id, stripe_session_id")
    .eq("id", originalId)
    .single();
  if (readErr || !original) {
    console.error("Could not read original job:", readErr);
    return null;
  }
  const { data: row, error: insertErr } = await supabase
    .from("board_gen_jobs")
    .insert({
      specialty_slug: original.specialty_slug,
      target_count: original.target_count,
      trigger: original.trigger,
      user_id: original.user_id,
      // stripe_session_id is intentionally null on retry — the unique
      // (stripe_session_id, specialty_slug) index would block requeues
      // and we just want a fresh attempt.
      status: "queued",
      attempts: 0,
    })
    .select("id")
    .single();
  if (insertErr) {
    console.error("Could not requeue job:", insertErr);
    return null;
  }
  return row as { id: string };
}
