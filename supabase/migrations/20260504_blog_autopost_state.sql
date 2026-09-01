-- Track autopost outcomes per blog post for durable retry without duplicate posts.
ALTER TABLE blog_posts ADD COLUMN IF NOT EXISTS fb_post_id text;
ALTER TABLE blog_posts ADD COLUMN IF NOT EXISTS fb_posted_at timestamptz;
ALTER TABLE blog_posts ADD COLUMN IF NOT EXISTS fb_last_error text;
ALTER TABLE blog_posts ADD COLUMN IF NOT EXISTS cover_image_line text;
ALTER TABLE blog_posts ADD COLUMN IF NOT EXISTS line_broadcast_at timestamptz;
ALTER TABLE blog_posts ADD COLUMN IF NOT EXISTS line_last_error text;
ALTER TABLE blog_posts ADD COLUMN IF NOT EXISTS autopost_format text
  CHECK (autopost_format IN ('cover_caption', 'quote_card', 'link_only'));

-- Partial indexes for cheap unposted scans in the retry endpoint.
CREATE INDEX IF NOT EXISTS blog_posts_fb_unposted_idx
  ON blog_posts (published_at DESC) WHERE fb_post_id IS NULL;
CREATE INDEX IF NOT EXISTS blog_posts_line_unposted_idx
  ON blog_posts (published_at DESC) WHERE line_broadcast_at IS NULL;
