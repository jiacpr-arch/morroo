-- analytics_events: server-mirrored copy of the events sent to
-- Vercel Web Analytics, so we can query funnel/conversion data ourselves
-- (Vercel Analytics has no public read API). Inserted via
-- /api/analytics/track when the client also calls @vercel/analytics track().
--
-- Append-only log. RLS denies anon/auth reads — only the service-role
-- crons + admin dashboard read from it.

CREATE TABLE IF NOT EXISTS analytics_events (
  id            bigint      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  event_name    text        NOT NULL,
  properties    jsonb,
  user_id       uuid        REFERENCES auth.users(id) ON DELETE SET NULL,
  session_id    text,
  path          text,
  referrer      text,
  country       text,
  user_agent    text,
  created_at    timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS analytics_events_created_idx
  ON analytics_events (created_at DESC);

CREATE INDEX IF NOT EXISTS analytics_events_event_created_idx
  ON analytics_events (event_name, created_at DESC);

CREATE INDEX IF NOT EXISTS analytics_events_session_idx
  ON analytics_events (session_id, created_at) WHERE session_id IS NOT NULL;

ALTER TABLE analytics_events ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Admins read analytics_events" ON analytics_events;
CREATE POLICY "Admins read analytics_events" ON analytics_events FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid() AND role = 'admin'
    )
  );
