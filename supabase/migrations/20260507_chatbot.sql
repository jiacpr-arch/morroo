-- Chatbot conversations across channels (web, line, facebook).
-- One row per turn (user or assistant). Conversation is grouped by (channel, channel_user_id).
CREATE TABLE IF NOT EXISTS chat_messages (
  id          bigserial PRIMARY KEY,
  channel     text NOT NULL CHECK (channel IN ('web', 'line', 'facebook')),
  -- web: anonymous browser session id (uuid) OR auth user id; line: lineUserId; facebook: PSID
  channel_user_id text NOT NULL,
  -- optional FK to profiles.id when user is logged in (web channel)
  user_id     uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  role        text NOT NULL CHECK (role IN ('user', 'assistant')),
  content     text NOT NULL,
  created_at  timestamptz NOT NULL DEFAULT now()
);

-- Fast lookup: most recent N messages for a given conversation.
CREATE INDEX IF NOT EXISTS chat_messages_conv_idx
  ON chat_messages (channel, channel_user_id, created_at DESC);

-- For analytics: messages by user.
CREATE INDEX IF NOT EXISTS chat_messages_user_idx
  ON chat_messages (user_id, created_at DESC) WHERE user_id IS NOT NULL;

-- RLS: only service role writes/reads. Web client never touches this table directly.
ALTER TABLE chat_messages ENABLE ROW LEVEL SECURITY;
