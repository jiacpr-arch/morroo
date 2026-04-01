-- ตาราง payment_orders (คำสั่งซื้อ + สลิป)
create table if not exists public.payment_orders (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users not null,
  plan_type text not null check (plan_type in ('bundle', 'monthly', 'yearly', 'mcq_monthly', 'mcq_yearly', 'meq_monthly', 'meq_yearly', 'longcase_monthly', 'longcase_yearly')),
  amount numeric not null,
  status text default 'pending' check (status in ('pending', 'approved', 'rejected')),
  slip_url text,
  note text,
  reviewed_by uuid references auth.users,
  reviewed_at timestamptz,
  created_at timestamptz default now()
);

alter table public.payment_orders enable row level security;

-- Users can view and create their own orders
create policy "Users can view own orders"
  on public.payment_orders for select
  using (auth.uid() = user_id);

create policy "Users can create orders"
  on public.payment_orders for insert
  with check (auth.uid() = user_id);

-- Admins can view and update all orders
create policy "Admins can view all orders"
  on public.payment_orders for select
  using (auth.uid() in (select id from public.profiles where role = 'admin'));

create policy "Admins can update orders"
  on public.payment_orders for update
  using (auth.uid() in (select id from public.profiles where role = 'admin'));

-- Storage bucket for slips
-- Run this in Supabase Dashboard > Storage > New Bucket:
-- Name: slips
-- Public: false
