import { createAdminClient } from "@/lib/supabase/admin";

export type ChatChannelKey = "facebook" | "line";

type GetOrCreateLeadArgs = {
  channel: ChatChannelKey;
  channelUserId: string;
};

const SOURCE_BY_CHANNEL: Record<ChatChannelKey, "fb_messenger" | "line_oa"> = {
  facebook: "fb_messenger",
  line: "line_oa",
};

type AdminClient = ReturnType<typeof createAdminClient>;

type LinkedProfile = {
  id: string;
  membership_type: string | null;
  membership_expires_at: string | null;
};

/**
 * Pipeline stage for a chat contact who already has a MorRoo account: an
 * active paid membership is "paid", anything else is "registered". Either
 * way they are no longer a "new" lead waiting for the admin to reach out.
 */
export function stageForProfile(
  profile: Pick<LinkedProfile, "membership_type" | "membership_expires_at">,
  now: Date = new Date()
): "paid" | "registered" {
  const expires = profile.membership_expires_at
    ? Date.parse(profile.membership_expires_at)
    : NaN;
  const paid =
    !!profile.membership_type &&
    profile.membership_type !== "free" &&
    !Number.isNaN(expires) &&
    expires > now.getTime();
  return paid ? "paid" : "registered";
}

/** The account logged in with this LINE userId, if any. Errors → null. */
async function findProfileByLineId(
  supabase: AdminClient,
  lineUserId: string
): Promise<LinkedProfile | null> {
  const { data, error } = await supabase
    .from("profiles")
    .select("id, membership_type, membership_expires_at")
    .eq("line_user_id", lineUserId)
    .limit(1)
    .maybeSingle();
  if (error) {
    console.error("[lead-channel] profile lookup failed:", error);
    return null;
  }
  return (data as LinkedProfile | null) ?? null;
}

const COLUMN_BY_CHANNEL: Record<ChatChannelKey, "fb_psid" | "line_user_id"> = {
  facebook: "fb_psid",
  line: "line_user_id",
};

/**
 * Look up the lead row keyed by Messenger PSID or LINE userId, creating an
 * embryo lead on first contact so every conversation shows up in the admin
 * pipeline. Embryo leads have no email/phone yet — those are filled in later
 * when the bot collects them or the user redeems a code.
 *
 * LINE contacts who already have an account (same LINE userId on their
 * profile) are linked and staged "registered"/"paid" instead of "new", so the
 * admin's "Lead ใหม่ยังไม่ติดต่อ" queue only holds people worth reaching out to.
 *
 * Returns null only if the database call fails; webhook callers should treat
 * null as "skip lead linking but keep replying" so an outage in this table
 * doesn't break the chat itself.
 */
export async function getOrCreateLeadFromChannel(
  args: GetOrCreateLeadArgs
): Promise<string | null> {
  const supabase = createAdminClient();
  const column = COLUMN_BY_CHANNEL[args.channel];

  const { data: existing, error: lookupError } = await supabase
    .from("leads")
    .select("id, stage")
    .eq(column, args.channelUserId)
    .order("created_at", { ascending: true })
    .limit(1)
    .maybeSingle();

  if (lookupError) {
    console.error("[lead-channel] lookup failed:", lookupError);
    return null;
  }

  if (existing) {
    // Touch updated_at so admins can sort by "most recent activity", and
    // promote a still-"new" LINE lead who has since signed up.
    // Fire-and-forget — a failure here is observability noise, not user-facing.
    const patch: Record<string, unknown> = { updated_at: new Date().toISOString() };
    if (args.channel === "line" && existing.stage === "new") {
      const profile = await findProfileByLineId(supabase, args.channelUserId);
      if (profile) {
        patch.user_id = profile.id;
        patch.stage = stageForProfile(profile);
      }
    }
    supabase
      .from("leads")
      .update(patch)
      .eq("id", existing.id)
      .then(({ error }) => {
        if (error) console.error("[lead-channel] touch failed:", error);
      });
    return existing.id;
  }

  const insertPayload: Record<string, unknown> = {
    source: SOURCE_BY_CHANNEL[args.channel],
    stage: "new",
    consent_pdpa: false,
    [column]: args.channelUserId,
  };
  if (args.channel === "line") {
    const profile = await findProfileByLineId(supabase, args.channelUserId);
    if (profile) {
      insertPayload.user_id = profile.id;
      insertPayload.stage = stageForProfile(profile);
    }
  }

  const { data: created, error: insertError } = await supabase
    .from("leads")
    .insert(insertPayload)
    .select("id")
    .single();

  if (insertError || !created) {
    console.error("[lead-channel] insert failed:", insertError);
    return null;
  }

  return created.id;
}
