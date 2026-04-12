-- Add cover_image column to blog_posts
ALTER TABLE blog_posts ADD COLUMN IF NOT EXISTS cover_image text;
