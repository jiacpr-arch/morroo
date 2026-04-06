-- Referral system
-- Run this in Supabase SQL Editor

CREATE TABLE IF NOT EXISTS referrals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  referrer_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  referred_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  reward_given_at TIMESTAMPTZ,
  UNIQUE (referred_id) -- each new user can only be referred once
);

-- Index for fast lookup
CREATE INDEX IF NOT EXISTS referrals_referrer_id_idx ON referrals (referrer_id);

-- RLS: users can read their own referrals
ALTER TABLE referrals ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own referrals" ON referrals
  FOR SELECT USING (auth.uid() = referrer_id OR auth.uid() = referred_id);

-- Service role can insert (for API route)
CREATE POLICY "Service role can insert referrals" ON referrals
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Service role can update referrals" ON referrals
  FOR UPDATE USING (true);
