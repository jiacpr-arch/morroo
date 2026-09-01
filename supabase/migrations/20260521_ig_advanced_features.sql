-- IG advanced features: Carousel, Reels, Scheduled posts, Insights.
--
-- Mirrors the column-per-platform pattern already used for feed / story state
-- on blog_posts. Two new tables hold scheduled posts and insight snapshots —
-- both small append-only logs that the admin dashboard reads from.

-- ─── blog_posts: carousel + reel columns ─────────────────────────────────
ALTER TABLE blog_posts ADD COLUMN IF NOT EXISTS ig_carousel_id text;
ALTER TABLE blog_posts ADD COLUMN IF NOT EXISTS ig_carousel_posted_at timestamptz;
ALTER TABLE blog_posts ADD COLUMN IF NOT EXISTS ig_carousel_last_error text;
ALTER TABLE blog_posts ADD COLUMN IF NOT EXISTS ig_carousel_slide_urls jsonb;

ALTER TABLE blog_posts ADD COLUMN IF NOT EXISTS ig_reel_id text;
ALTER TABLE blog_posts ADD COLUMN IF NOT EXISTS ig_reel_posted_at timestamptz;
ALTER TABLE blog_posts ADD COLUMN IF NOT EXISTS ig_reel_last_error text;
ALTER TABLE blog_posts ADD COLUMN IF NOT EXISTS ig_reel_video_url text;

CREATE INDEX IF NOT EXISTS blog_posts_ig_carousel_unposted_idx
  ON blog_posts (published_at DESC) WHERE ig_carousel_id IS NULL;

-- ─── scheduled_autoposts ─────────────────────────────────────────────────
-- Admin can schedule a future post; the autopost-scheduled cron drains
-- pending rows whose scheduled_for has passed. We keep the row even after
-- success so the admin UI can show "what posted, when, with what result".
CREATE TABLE IF NOT EXISTS scheduled_autoposts (
  id              uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  slug            text        NOT NULL REFERENCES blog_posts(slug) ON DELETE CASCADE,
  platform        text        NOT NULL,
  scheduled_for   timestamptz NOT NULL,
  status          text        NOT NULL DEFAULT 'pending',
  result_id       text,
  error           text,
  created_at      timestamptz NOT NULL DEFAULT now(),
  posted_at       timestamptz,
  created_by      uuid        REFERENCES auth.users(id) ON DELETE SET NULL
);

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'scheduled_autoposts_platform_check') THEN
    ALTER TABLE scheduled_autoposts ADD CONSTRAINT scheduled_autoposts_platform_check
      CHECK (platform IN ('ig', 'ig_story', 'ig_carousel', 'fb', 'fb_story'));
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'scheduled_autoposts_status_check') THEN
    ALTER TABLE scheduled_autoposts ADD CONSTRAINT scheduled_autoposts_status_check
      CHECK (status IN ('pending', 'posted', 'failed', 'cancelled'));
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS scheduled_autoposts_pending_due_idx
  ON scheduled_autoposts (scheduled_for) WHERE status = 'pending';
CREATE INDEX IF NOT EXISTS scheduled_autoposts_slug_idx
  ON scheduled_autoposts (slug, created_at DESC);

ALTER TABLE scheduled_autoposts ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Admins read scheduled autoposts" ON scheduled_autoposts;
CREATE POLICY "Admins read scheduled autoposts" ON scheduled_autoposts FOR SELECT
  USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'));

DROP POLICY IF EXISTS "Admins write scheduled autoposts" ON scheduled_autoposts;
CREATE POLICY "Admins write scheduled autoposts" ON scheduled_autoposts FOR ALL
  USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'));

-- ─── ig_insights_snapshots ───────────────────────────────────────────────
-- Daily snapshot of IG insights per media. Stored as separate rows (not
-- columns on blog_posts) so we can chart engagement over time and so the
-- same blog_post row can have feed + story + carousel + reel snapshots.
CREATE TABLE IF NOT EXISTS ig_insights_snapshots (
  id              uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  slug            text        NOT NULL REFERENCES blog_posts(slug) ON DELETE CASCADE,
  media_id        text        NOT NULL,
  media_type      text        NOT NULL,
  reach           integer,
  likes           integer,
  saves           integer,
  comments        integer,
  shares          integer,
  profile_visits  integer,
  video_views     integer,
  raw             jsonb,
  captured_at     timestamptz NOT NULL DEFAULT now()
);

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ig_insights_snapshots_media_type_check') THEN
    ALTER TABLE ig_insights_snapshots ADD CONSTRAINT ig_insights_snapshots_media_type_check
      CHECK (media_type IN ('feed', 'story', 'carousel', 'reel'));
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS ig_insights_snapshots_slug_idx
  ON ig_insights_snapshots (slug, captured_at DESC);
CREATE INDEX IF NOT EXISTS ig_insights_snapshots_media_idx
  ON ig_insights_snapshots (media_id, captured_at DESC);

ALTER TABLE ig_insights_snapshots ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Admins read ig insights" ON ig_insights_snapshots;
CREATE POLICY "Admins read ig insights" ON ig_insights_snapshots FOR SELECT
  USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'));
