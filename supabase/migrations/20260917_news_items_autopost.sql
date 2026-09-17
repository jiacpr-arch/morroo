-- Track FB/LINE delivery for admin-authored news_items announcements
-- (product_update / exam), mirroring the columns already on blog_posts.
alter table news_items
  add column if not exists fb_post_id text,
  add column if not exists fb_posted_at timestamptz,
  add column if not exists fb_last_error text,
  add column if not exists line_broadcast_at timestamptz,
  add column if not exists line_last_error text;
