-- Migration: Add new plan types for MCQ-only, MEQ-only, and Long Case-only plans
-- Run this in Supabase SQL editor

-- 1. Update CHECK constraint on profiles.membership_type
ALTER TABLE profiles
  DROP CONSTRAINT IF EXISTS profiles_membership_type_check;

ALTER TABLE profiles
  ADD CONSTRAINT profiles_membership_type_check
  CHECK (membership_type IN (
    'free',
    'bundle',
    'monthly',
    'yearly',
    'mcq_monthly',
    'mcq_yearly',
    'meq_monthly',
    'meq_yearly',
    'longcase_monthly',
    'longcase_yearly'
  ));

-- 2. Update CHECK constraint on payment_orders.plan_type
ALTER TABLE payment_orders
  DROP CONSTRAINT IF EXISTS payment_orders_plan_type_check;

ALTER TABLE payment_orders
  ADD CONSTRAINT payment_orders_plan_type_check
  CHECK (plan_type IN (
    'bundle',
    'monthly',
    'yearly',
    'mcq_monthly',
    'mcq_yearly',
    'meq_monthly',
    'meq_yearly',
    'longcase_monthly',
    'longcase_yearly'
  ));
