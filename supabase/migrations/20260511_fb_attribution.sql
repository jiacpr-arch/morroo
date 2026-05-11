-- Facebook Pixel / CAPI attribution columns.
--
-- Mirrors the Google Ads attribution columns added in 20260510_ads_attribution.sql
-- but for Meta:
--   fbclid              raw click identifier from URL
--   fbc                 _fbc cookie value (Meta requires raw, not hashed)
--   fbp                 _fbp cookie value
--   fb_event_id         UUID for browser/server CAPI dedup (one per conversion)
--   fb_capi_uploaded_at timestamp the CAPI mirror was sent successfully
--
-- Idempotent — safe to re-run.

ALTER TABLE leads
  ADD COLUMN IF NOT EXISTS fbclid              text,
  ADD COLUMN IF NOT EXISTS fbc                 text,
  ADD COLUMN IF NOT EXISTS fbp                 text,
  ADD COLUMN IF NOT EXISTS fb_event_id         text,
  ADD COLUMN IF NOT EXISTS fb_capi_uploaded_at timestamptz;

CREATE INDEX IF NOT EXISTS leads_fb_event_id_idx
  ON leads(fb_event_id) WHERE fb_event_id IS NOT NULL;

ALTER TABLE payment_orders
  ADD COLUMN IF NOT EXISTS fbclid              text,
  ADD COLUMN IF NOT EXISTS fbc                 text,
  ADD COLUMN IF NOT EXISTS fbp                 text,
  ADD COLUMN IF NOT EXISTS fb_event_id         text,
  ADD COLUMN IF NOT EXISTS fb_capi_uploaded_at timestamptz;

CREATE INDEX IF NOT EXISTS payment_orders_fb_event_id_idx
  ON payment_orders(fb_event_id) WHERE fb_event_id IS NOT NULL;
