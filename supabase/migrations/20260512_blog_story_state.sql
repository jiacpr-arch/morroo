-- Track Facebook Story + Instagram Story autopost outcomes alongside feed posts.
ALTER TABLE blog_posts ADD COLUMN IF NOT EXISTS fb_story_id text;
ALTER TABLE blog_posts ADD COLUMN IF NOT EXISTS fb_story_posted_at timestamptz;
ALTER TABLE blog_posts ADD COLUMN IF NOT EXISTS fb_story_last_error text;
ALTER TABLE blog_posts ADD COLUMN IF NOT EXISTS ig_story_id text;
ALTER TABLE blog_posts ADD COLUMN IF NOT EXISTS ig_story_posted_at timestamptz;
ALTER TABLE blog_posts ADD COLUMN IF NOT EXISTS ig_story_last_error text;
-- 9:16 (1080×1920) JPEG variant; Stories need portrait, both FB & IG share this asset.
ALTER TABLE blog_posts ADD COLUMN IF NOT EXISTS cover_image_story text;

CREATE INDEX IF NOT EXISTS blog_posts_fb_story_unposted_idx
  ON blog_posts (published_at DESC) WHERE fb_story_id IS NULL;
CREATE INDEX IF NOT EXISTS blog_posts_ig_story_unposted_idx
  ON blog_posts (published_at DESC) WHERE ig_story_id IS NULL;
