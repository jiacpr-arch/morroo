-- ============================================
-- Standard Features: Difficulty + Competition + Coupon
-- Migration for both morroo.com and pharma.morroo.com
-- ============================================

-- ============================================
-- 1. Difficulty Level System
-- ============================================

-- Add difficulty_level to mcq_questions (integer 1-3)
ALTER TABLE mcq_questions ADD COLUMN IF NOT EXISTS difficulty_level INTEGER NOT NULL DEFAULT 1
  CHECK (difficulty_level IN (1, 2, 3));

-- Map existing difficulty text to levels
UPDATE mcq_questions SET difficulty_level = 1 WHERE difficulty = 'easy';
UPDATE mcq_questions SET difficulty_level = 2 WHERE difficulty = 'medium';
UPDATE mcq_questions SET difficulty_level = 3 WHERE difficulty = 'hard';

-- Add display_name column to profiles for leaderboard
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS display_name TEXT;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS avatar_url TEXT;

-- ============================================
-- 2. Competition System
-- ============================================

-- Challenges table
CREATE TABLE IF NOT EXISTS public.challenges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT,
  challenge_type TEXT NOT NULL CHECK (challenge_type IN ('weekly', 'monthly')),
  start_date TIMESTAMPTZ NOT NULL,
  end_date TIMESTAMPTZ NOT NULL,
  question_ids UUID[] NOT NULL DEFAULT '{}',
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Challenge submissions
CREATE TABLE IF NOT EXISTS public.challenge_submissions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  challenge_id UUID REFERENCES public.challenges(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  score INTEGER NOT NULL DEFAULT 0,
  total_questions INTEGER NOT NULL,
  correct_answers INTEGER NOT NULL DEFAULT 0,
  time_taken_seconds INTEGER,
  submitted_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(challenge_id, user_id)
);

-- Badges
CREATE TABLE IF NOT EXISTS public.badges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  name_th TEXT NOT NULL,
  description TEXT NOT NULL,
  description_th TEXT NOT NULL,
  icon_url TEXT,
  condition_type TEXT NOT NULL,
  condition_value INTEGER NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- User badges
CREATE TABLE IF NOT EXISTS public.user_badges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  badge_id UUID REFERENCES public.badges(id) ON DELETE CASCADE,
  earned_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(user_id, badge_id)
);

-- Rewards
CREATE TABLE IF NOT EXISTS public.rewards (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  challenge_id UUID REFERENCES public.challenges(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  reward_type TEXT NOT NULL CHECK (reward_type IN ('free_month', 'discount_50', 'certificate', 'badge')),
  coupon_code TEXT,
  is_claimed BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Leaderboard view (weekly)
CREATE OR REPLACE VIEW leaderboard_weekly AS
SELECT
  cs.user_id,
  p.display_name,
  p.name,
  p.avatar_url,
  cs.score,
  cs.correct_answers,
  cs.total_questions,
  cs.time_taken_seconds,
  c.id AS challenge_id,
  c.title AS challenge_title,
  c.start_date,
  c.end_date,
  RANK() OVER (PARTITION BY cs.challenge_id ORDER BY cs.score DESC, cs.time_taken_seconds ASC) AS rank
FROM challenge_submissions cs
JOIN challenges c ON cs.challenge_id = c.id
JOIN profiles p ON cs.user_id = p.id
WHERE c.challenge_type = 'weekly' AND c.is_active = true;

-- Leaderboard view (monthly)
CREATE OR REPLACE VIEW leaderboard_monthly AS
SELECT
  cs.user_id,
  p.display_name,
  p.name,
  p.avatar_url,
  cs.score,
  cs.correct_answers,
  cs.total_questions,
  cs.time_taken_seconds,
  c.id AS challenge_id,
  c.title AS challenge_title,
  c.start_date,
  c.end_date,
  RANK() OVER (PARTITION BY cs.challenge_id ORDER BY cs.score DESC, cs.time_taken_seconds ASC) AS rank
FROM challenge_submissions cs
JOIN challenges c ON cs.challenge_id = c.id
JOIN profiles p ON cs.user_id = p.id
WHERE c.challenge_type = 'monthly' AND c.is_active = true;

-- ============================================
-- 3. Coupon Code System
-- ============================================

CREATE TABLE IF NOT EXISTS public.coupon_codes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code TEXT NOT NULL UNIQUE,
  description TEXT,
  coupon_type TEXT NOT NULL CHECK (coupon_type IN (
    'free_trial', 'discount_percent', 'discount_fixed', 'free_month'
  )),
  value INTEGER NOT NULL,
  platform TEXT NOT NULL CHECK (platform IN ('medical', 'pharmacy', 'all')),
  max_uses INTEGER,
  max_uses_per_user INTEGER DEFAULT 1,
  current_uses INTEGER DEFAULT 0,
  starts_at TIMESTAMPTZ DEFAULT now(),
  expires_at TIMESTAMPTZ,
  source TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now(),
  created_by UUID REFERENCES auth.users(id)
);

CREATE TABLE IF NOT EXISTS public.coupon_redemptions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  coupon_id UUID REFERENCES public.coupon_codes(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  redeemed_at TIMESTAMPTZ DEFAULT now(),
  platform TEXT NOT NULL CHECK (platform IN ('medical', 'pharmacy')),
  UNIQUE(coupon_id, user_id)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_coupon_codes_code ON coupon_codes(code);
CREATE INDEX IF NOT EXISTS idx_coupon_codes_source ON coupon_codes(source);
CREATE INDEX IF NOT EXISTS idx_challenge_submissions_challenge ON challenge_submissions(challenge_id);
CREATE INDEX IF NOT EXISTS idx_challenge_submissions_user ON challenge_submissions(user_id);
CREATE INDEX IF NOT EXISTS idx_user_badges_user ON user_badges(user_id);

-- ============================================
-- RLS Policies
-- ============================================

ALTER TABLE public.challenges ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.challenge_submissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.badges ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_badges ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.rewards ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.coupon_codes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.coupon_redemptions ENABLE ROW LEVEL SECURITY;

-- Challenges: public read, admin manage
CREATE POLICY "Challenges are viewable by everyone"
  ON public.challenges FOR SELECT USING (true);

CREATE POLICY "Admins can manage challenges"
  ON public.challenges FOR ALL
  USING (public.is_admin());

-- Challenge submissions: user sees own, leaderboard is via view
CREATE POLICY "Users can view own submissions"
  ON public.challenge_submissions FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own submissions"
  ON public.challenge_submissions FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Admins can view all submissions"
  ON public.challenge_submissions FOR SELECT
  USING (public.is_admin());

-- Badges: public read
CREATE POLICY "Badges are viewable by everyone"
  ON public.badges FOR SELECT USING (true);

CREATE POLICY "Admins can manage badges"
  ON public.badges FOR ALL
  USING (public.is_admin());

-- User badges: public read (for leaderboard/profile)
CREATE POLICY "User badges are viewable by everyone"
  ON public.user_badges FOR SELECT USING (true);

CREATE POLICY "Admins can manage user badges"
  ON public.user_badges FOR ALL
  USING (public.is_admin());

-- Rewards: user sees own
CREATE POLICY "Users can view own rewards"
  ON public.rewards FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Admins can manage rewards"
  ON public.rewards FOR ALL
  USING (public.is_admin());

-- Coupon codes: everyone can read (for validation), admin manages
CREATE POLICY "Coupon codes are viewable by everyone"
  ON public.coupon_codes FOR SELECT USING (true);

CREATE POLICY "Admins can manage coupon codes"
  ON public.coupon_codes FOR ALL
  USING (public.is_admin());

-- Coupon redemptions: user sees own
CREATE POLICY "Users can view own redemptions"
  ON public.coupon_redemptions FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own redemptions"
  ON public.coupon_redemptions FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Admins can view all redemptions"
  ON public.coupon_redemptions FOR SELECT
  USING (public.is_admin());

-- ============================================
-- Seed Data: Badges
-- ============================================

INSERT INTO public.badges (name, name_th, description, description_th, icon_url, condition_type, condition_value) VALUES
  ('Streak Master', 'สายแม่น', 'Answer 10 questions correctly in a row', 'ตอบถูกติดต่อกัน 10 ข้อ', NULL, 'streak', 10),
  ('Century', 'ร้อยข้อ', 'Answer 100 questions correctly', 'ตอบถูก 100 ข้อ', NULL, 'total_correct', 100),
  ('Top 3 Weekly', 'Top 3 ประจำสัปดาห์', 'Finish in the top 3 of a weekly challenge', 'ติด Top 3 ใน Weekly Challenge', NULL, 'top_rank', 3),
  ('Speed Demon', 'สายเร็ว', 'Complete a challenge in 50% of the allotted time', 'ทำ Challenge เสร็จใน 50% ของเวลา', NULL, 'speed', 50),
  ('Perfect Score', 'คะแนนเต็ม', 'Get a perfect score on a challenge', 'ได้คะแนนเต็มใน Challenge', NULL, 'challenge_complete', 100),
  ('Dedicated Learner', 'นักเรียนตัวยง', 'Answer 500 questions correctly', 'ตอบถูก 500 ข้อ', NULL, 'total_correct', 500),
  ('Advanced Solver', 'เซียนข้อยาก', 'Answer 50 advanced questions correctly', 'ตอบข้อ Advanced ถูก 50 ข้อ', NULL, 'total_correct_advanced', 50)
ON CONFLICT DO NOTHING;
