-- Key-value store for app settings (e.g. auto-refreshing tokens)
CREATE TABLE IF NOT EXISTS app_settings (
  key text PRIMARY KEY,
  value text NOT NULL,
  updated_at timestamptz DEFAULT now()
);
