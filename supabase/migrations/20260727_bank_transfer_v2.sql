-- Bank transfer v2: automatic slip verification + duplicate protection.
--
-- Context: a customer paid ฿199 and submitted the same slip 3 times because
-- nothing showed a pending status and nobody was notified. This migration
-- adds the columns the auto-verify flow needs and the unique indexes that
-- make duplicate submissions impossible at the database level.

-- 1) Verification columns
alter table public.payment_orders
  add column if not exists trans_ref text,
  add column if not exists verified_by_provider text,
  add column if not exists verification jsonb;

comment on column public.payment_orders.trans_ref is
  'Bank transaction reference from the slip QR payload (unique per real transfer).';
comment on column public.payment_orders.verified_by_provider is
  'Slip-verification provider that auto-verified this order (easyslip/slipok); null = manual review or Stripe.';
comment on column public.payment_orders.verification is
  'Raw provider response plus validation outcome, kept for audit/debugging.';

-- 2) Widen plan_type CHECK to cover board tiers (Stripe already sells them,
--    so slip payments must accept them too). The live constraint already
--    included mcq/meq/longcase tiers beyond the original repo DDL — keep
--    those, add the board pair.
alter table public.payment_orders
  drop constraint if exists payment_orders_plan_type_check;
alter table public.payment_orders
  add constraint payment_orders_plan_type_check
  check (plan_type in (
    'bundle', 'monthly', 'yearly',
    'mcq_monthly', 'mcq_yearly',
    'meq_monthly', 'meq_yearly',
    'longcase_monthly', 'longcase_yearly',
    'board_monthly', 'board_yearly'
  ));

-- 3) One real bank transaction can only ever pay for one order. Rejected
--    orders are excluded so a wrongly-rejected slip can be resubmitted.
create unique index if not exists payment_orders_trans_ref_uniq
  on public.payment_orders (trans_ref)
  where trans_ref is not null and status <> 'rejected';

-- 4) At most one pending bank-transfer order per (user, plan). Clean up any
--    pre-existing duplicates first: keep the newest pending row per pair,
--    reject the rest.
with ranked as (
  select id,
         row_number() over (
           partition by user_id, plan_type
           order by created_at desc
         ) as rn
  from public.payment_orders
  where status = 'pending' and payment_method = 'bank_transfer'
)
update public.payment_orders po
set status = 'rejected',
    note = coalesce(po.note || ' | ', '') || 'ปิดอัตโนมัติ: รายการซ้ำ (migration 20260727)',
    reviewed_at = now()
from ranked
where po.id = ranked.id and ranked.rn > 1;

create unique index if not exists payment_orders_pending_uniq
  on public.payment_orders (user_id, plan_type)
  where status = 'pending' and payment_method = 'bank_transfer';

-- 5) Slip orders are now created server-side only (service role), so the
--    client INSERT policy goes away. The old policy also had no status
--    restriction, meaning a malicious client could insert status='approved'.
drop policy if exists "Users can create orders" on public.payment_orders;
