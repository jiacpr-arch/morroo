// Enqueue board MCQ generation jobs.
//
// Called from billing/fulfill-checkout.ts on board_monthly / board_yearly purchase
// (and from admin manual trigger). Idempotent per (stripe_session_id, specialty_slug).
//
// For every active board specialty that has fewer than `targetCount` board
// questions in `mcq_questions` (status in active/review), insert one job row.
// The cron worker picks them up one specialty per minute.

import type { SupabaseClient } from "@supabase/supabase-js";

export interface EnqueueResult {
  enqueued: string[];
  skipped_already_full: string[];
  skipped_already_queued: string[];
}

export async function enqueueBoardGenJobs(args: {
  admin: SupabaseClient;
  userId: string | null;
  stripeSessionId: string | null;
  targetCount?: number;
  trigger?: string;
}): Promise<EnqueueResult> {
  const { admin, userId, stripeSessionId } = args;
  const targetCount = args.targetCount ?? 30;
  const trigger = args.trigger ?? "subscription";

  const out: EnqueueResult = {
    enqueued: [],
    skipped_already_full: [],
    skipped_already_queued: [],
  };

  const { data: specialties } = await admin
    .from("board_specialties")
    .select("slug")
    .eq("is_active", true);

  if (!specialties || specialties.length === 0) return out;

  for (const sp of specialties) {
    const slug = sp.slug as string;

    const { count } = await admin
      .from("mcq_questions")
      .select("id", { count: "exact", head: true })
      .eq("audience", "board")
      .eq("board_specialty", slug)
      .in("status", ["active", "review"]);

    if ((count ?? 0) >= targetCount) {
      out.skipped_already_full.push(slug);
      continue;
    }

    // Idempotency: if there's already a queued/running/done job for this
    // (session, specialty), skip. Different sessions can still re-fill.
    if (stripeSessionId) {
      const { data: existing } = await admin
        .from("board_gen_jobs")
        .select("id, status")
        .eq("stripe_session_id", stripeSessionId)
        .eq("specialty_slug", slug)
        .maybeSingle();
      if (existing) {
        out.skipped_already_queued.push(slug);
        continue;
      }
    }

    const { error: insertErr } = await admin.from("board_gen_jobs").insert({
      user_id: userId,
      trigger,
      specialty_slug: slug,
      target_count: targetCount,
      stripe_session_id: stripeSessionId,
    });

    if (!insertErr) {
      out.enqueued.push(slug);
    }
  }

  return out;
}
