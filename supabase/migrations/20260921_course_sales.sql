-- Course sales recorded by hand after a chat close.
--
-- CPR / First Aid / ALS are sold over chat with a direct bank transfer — no
-- checkout, no Stripe session, nothing the Part C pipeline can observe. Meta
-- therefore only ever learned "someone started a conversation", never "someone
-- paid", and optimised the ad spend against the weaker signal.
--
-- This table is the missing receipt: one row per paid enrolment, entered by
-- sales on their phone, which immediately fires a Purchase CAPI event.
--
-- Deliberately standalone — no FK into profiles/payment_orders. The buyer
-- usually has no Morroo account at all, and the real certificate system is
-- being built separately at class.jiacpr.com. Keeping this table unattached
-- means it can be retired or migrated later without touching anything else.

CREATE TABLE IF NOT EXISTS course_sales (
  id              bigint      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  customer_name   text        NOT NULL,
  -- Stored as typed so sales can call the customer back. Only ever leaves
  -- this system SHA-256 hashed (see lib/meta/events-api.ts normalizePhone).
  phone           text        NOT NULL,
  course_id       text        NOT NULL CHECK (course_id IN ('cpr', 'first_aid', 'als')),
  course_name     text        NOT NULL,
  -- Actual amount received, not the list price — discounts are common.
  price_thb       numeric(10, 2) NOT NULL CHECK (price_thb >= 0),
  -- Optional, for internal reporting only. Never sent to Meta.
  source_channel  text        CHECK (source_channel IN ('facebook', 'line', 'walk_in', 'referral')),
  sold_on         date        NOT NULL DEFAULT CURRENT_DATE,
  -- Null means the Purchase event never reached Meta — a failed CAPI call must
  -- not lose the sale, so the row is kept and this column marks it retryable.
  capi_sent_at    timestamptz,
  capi_error      text,
  recorded_by     uuid        REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at      timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS course_sales_sold_on_idx
  ON course_sales (sold_on DESC, created_at DESC);
CREATE INDEX IF NOT EXISTS course_sales_course_idx
  ON course_sales (course_id, sold_on DESC);
-- Partial index so a future retry job can find unsent events cheaply.
CREATE INDEX IF NOT EXISTS course_sales_capi_pending_idx
  ON course_sales (created_at) WHERE capi_sent_at IS NULL;

ALTER TABLE course_sales ENABLE ROW LEVEL SECURITY;

-- Writes go through the service-role client in app/api/admin/course-sales,
-- which bypasses RLS; this policy only covers direct admin reads.
DROP POLICY IF EXISTS "Admins read course_sales" ON course_sales;
CREATE POLICY "Admins read course_sales" ON course_sales FOR SELECT
  USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'));
