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
    .select("id")
    .eq(column, args.channelUserId)
    .order("created_at", { ascending: true })
    .limit(1)
    .maybeSingle();

  if (lookupError) {
    console.error("[lead-channel] lookup failed:", lookupError);
    return null;
  }

  if (existing) {
    // Touch updated_at so admins can sort by "most recent activity".
    // Fire-and-forget — a failure here is observability noise, not user-facing.
    supabase
      .from("leads")
      .update({ updated_at: new Date().toISOString() })
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
