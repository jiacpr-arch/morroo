-- Track Instagram autopost outcomes alongside FB/LINE.
ALTER TABLE blog_posts ADD COLUMN IF NOT EXISTS ig_post_id text;
ALTER TABLE blog_posts ADD COLUMN IF NOT EXISTS ig_posted_at timestamptz;
ALTER TABLE blog_posts ADD COLUMN IF NOT EXISTS ig_last_error text;
-- IG Graph API requires JPEG (PNG often rejected with "Media format not supported");
-- store a 1080×1080 JPEG variant URL alongside the original PNG cover.
ALTER TABLE blog_posts ADD COLUMN IF NOT EXISTS cover_image_ig text;

CREATE INDEX IF NOT EXISTS blog_posts_ig_unposted_idx
  ON blog_posts (published_at DESC) WHERE ig_post_id IS NULL;
