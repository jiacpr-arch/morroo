-- LINE integration schema

ALTER TABLE profiles ADD COLUMN IF NOT EXISTS line_user_id text;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS line_linked_at timestamptz;

CREATE TABLE IF NOT EXISTS line_link_codes (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    uuid REFERENCES auth.users NOT NULL,
  code       text NOT NULL UNIQUE,
  expires_at timestamptz DEFAULT now() + interval '24 hours',
  created_at timestamptz DEFAULT now()
);

ALTER TABLE line_link_codes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own link codes" ON line_link_codes
  FOR SELECT USING (auth.uid() = user_id);

-- Cleanup expired codes (run manually or via pg_cron)
-- DELETE FROM line_link_codes WHERE expires_at < now();
