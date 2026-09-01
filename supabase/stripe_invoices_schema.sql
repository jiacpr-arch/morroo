-- ========================================================
-- Stripe + Invoices Schema Migration
-- ========================================================

-- Add columns to payment_orders
ALTER TABLE public.payment_orders
  ADD COLUMN IF NOT EXISTS payment_method text DEFAULT 'bank_transfer',
  ADD COLUMN IF NOT EXISTS stripe_session_id text;

-- Create invoices table
CREATE TABLE IF NOT EXISTS public.invoices (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  invoice_number text NOT NULL UNIQUE,
  user_id uuid REFERENCES auth.users NOT NULL,
  order_id uuid REFERENCES public.payment_orders,
  payment_method text NOT NULL DEFAULT 'stripe',
  stripe_session_id text,
  plan_type text NOT NULL,
  amount numeric NOT NULL,        -- before VAT
  vat_amount numeric NOT NULL DEFAULT 0,
  total_amount numeric NOT NULL,
  buyer_name text,
  buyer_tax_id text,
  buyer_address text,
  buyer_email text,
  status text DEFAULT 'paid',
  issued_at timestamptz DEFAULT now(),
  created_at timestamptz DEFAULT now()
);

ALTER TABLE public.invoices ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own invoices"
  ON public.invoices FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Service role can insert invoices"
  ON public.invoices FOR INSERT
  WITH CHECK (true);
