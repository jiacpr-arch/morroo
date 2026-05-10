-- Google Ads attribution columns for lead → purchase tracking.
--
-- gclid / gbraid / wbraid are click identifiers passed back to Google Ads
-- with offline conversion uploads (Enhanced Conversions for Leads, etc).
-- utm_* and referrer let us reconstruct the acquisition channel in the
-- admin dashboard.
--
-- Idempotent — safe on environments where the columns already exist.

ALTER TABLE leads
  ADD COLUMN IF NOT EXISTS gclid          text,
  ADD COLUMN IF NOT EXISTS gbraid         text,
  ADD COLUMN IF NOT EXISTS wbraid         text,
  ADD COLUMN IF NOT EXISTS utm_source     text,
  ADD COLUMN IF NOT EXISTS utm_medium     text,
  ADD COLUMN IF NOT EXISTS utm_campaign   text,
  ADD COLUMN IF NOT EXISTS utm_term       text,
  ADD COLUMN IF NOT EXISTS utm_content    text,
  ADD COLUMN IF NOT EXISTS landing_page   text,
  ADD COLUMN IF NOT EXISTS conv_uploaded_at timestamptz;

CREATE INDEX IF NOT EXISTS leads_gclid_idx ON leads(gclid) WHERE gclid IS NOT NULL;

-- payment_orders: keep ad attribution snapshot at the moment of checkout so
-- offline conversion uploads on purchase can match the original click.
ALTER TABLE payment_orders
  ADD COLUMN IF NOT EXISTS gclid            text,
  ADD COLUMN IF NOT EXISTS gbraid           text,
  ADD COLUMN IF NOT EXISTS wbraid           text,
  ADD COLUMN IF NOT EXISTS utm_source       text,
  ADD COLUMN IF NOT EXISTS utm_medium       text,
  ADD COLUMN IF NOT EXISTS utm_campaign     text,
  ADD COLUMN IF NOT EXISTS conv_uploaded_at timestamptz;

CREATE INDEX IF NOT EXISTS payment_orders_gclid_idx
  ON payment_orders(gclid) WHERE gclid IS NOT NULL;
