-- Referral system

-- Add referral columns to profiles
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS referral_code text UNIQUE;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS referred_by text;  -- code ที่ใช้ตอน register

-- Referrals table
CREATE TABLE IF NOT EXISTS referrals (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  referrer_id uuid REFERENCES auth.users NOT NULL,  -- คนเชิญ (owner of referral_code)
  referred_id uuid REFERENCES auth.users,            -- คนถูกเชิญ (ใส่ code ตอน register)
  code text NOT NULL,                                -- referral code ที่ใช้
  status text DEFAULT 'pending',                     -- pending | rewarded
  reward_days int DEFAULT 30,                        -- จำนวนวันที่ referrer จะได้รับ
  created_at timestamptz DEFAULT now(),
  rewarded_at timestamptz
);

-- Index สำหรับ lookup
CREATE INDEX IF NOT EXISTS idx_referrals_referrer ON referrals(referrer_id);
CREATE INDEX IF NOT EXISTS idx_referrals_referred ON referrals(referred_id);
CREATE INDEX IF NOT EXISTS idx_referrals_code ON referrals(code);

-- RLS
ALTER TABLE referrals ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own referrals"
  ON referrals FOR SELECT
  USING (referrer_id = auth.uid() OR referred_id = auth.uid());
