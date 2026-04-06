-- Onboarding fields for profiles table
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS onboarding_done boolean DEFAULT false;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS daily_goal int DEFAULT 20;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS target_exam text;        -- 'NL1' | 'NL2' | 'both'
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS weak_subjects text[];    -- subject slugs เลือกตอน onboarding
