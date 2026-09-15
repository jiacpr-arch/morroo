-- ============================================================
-- coupon_codes.plan_type — what a voucher unlocks / applies to
--
--   free_trial / free_month : the plan or item to grant
--                             (NULL = legacy behaviour = student pack "monthly")
--                             e.g. 'board_monthly', 'mcq_monthly',
--                                  'item:board_specialty:internal_medicine:month'
--   discount_percent / _fixed: restrict the discount to one plan / item
--                             (NULL = any plan at checkout)
--
-- Values are plan strings understood by lib/billing/plan-resolver.ts.
-- Idempotent: safe to re-run.
-- ============================================================

ALTER TABLE public.coupon_codes
  ADD COLUMN IF NOT EXISTS plan_type text;

-- Link a discount redemption to the Stripe session that used it (audit).
ALTER TABLE public.coupon_redemptions
  ADD COLUMN IF NOT EXISTS stripe_session_id text;
