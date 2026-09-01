-- ============================================================
-- Beta Tester Program
-- ============================================================
-- Adds:
--   * profiles columns — beta quota, expiry, enrollment origin,
--     welcome-modal seen flag, issued coupon
--   * beta_survey_responses — checkpoint_10 / checkpoint_25 / exit
--   * beta_coupons          — 50%-off first-month coupons
--   * trigger on mcq_attempts that increments beta_questions_used
--     on a beta user's FIRST attempt at a given question
--   * one-time back-fill — existing free users become beta testers
-- Idempotent: safe to re-run.
-- ============================================================

-- ----- profiles columns -----
ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS beta_enrolled_via text
    CHECK (beta_enrolled_via IN ('existing_user_upgrade','new_signup'));

ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS beta_started_at timestamptz;

ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS beta_expires_at timestamptz;

ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS beta_questions_used int NOT NULL DEFAULT 0;

ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS beta_questions_limit int NOT NULL DEFAULT 25;

ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS has_seen_beta_welcome boolean NOT NULL DEFAULT false;

ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS beta_coupon_code text;

ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS beta_coupon_issued_at timestamptz;

CREATE INDEX IF NOT EXISTS idx_profiles_beta_expires_at
  ON public.profiles(beta_expires_at)
  WHERE beta_expires_at IS NOT NULL;

-- ----- beta_survey_responses -----
CREATE TABLE IF NOT EXISTS public.beta_survey_responses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  survey_type text NOT NULL CHECK (survey_type IN (
    'checkpoint_10','checkpoint_25','exit'
  )),
  responses jsonb NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_beta_survey_user
  ON public.beta_survey_responses(user_id);
CREATE INDEX IF NOT EXISTS idx_beta_survey_type
  ON public.beta_survey_responses(survey_type);

ALTER TABLE public.beta_survey_responses ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users insert own survey" ON public.beta_survey_responses;
CREATE POLICY "Users insert own survey"
  ON public.beta_survey_responses FOR INSERT
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users view own survey" ON public.beta_survey_responses;
CREATE POLICY "Users view own survey"
  ON public.beta_survey_responses FOR SELECT
  USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Admins read all survey" ON public.beta_survey_responses;
CREATE POLICY "Admins read all survey"
  ON public.beta_survey_responses FOR SELECT
  USING (auth.uid() IN (SELECT id FROM public.profiles WHERE role = 'admin'));

-- ----- beta_coupons -----
CREATE TABLE IF NOT EXISTS public.beta_coupons (
  code text PRIMARY KEY,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  discount_percent int NOT NULL DEFAULT 50,
  expires_at timestamptz NOT NULL,
  redeemed_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (user_id)
);

CREATE INDEX IF NOT EXISTS idx_beta_coupons_user
  ON public.beta_coupons(user_id);

ALTER TABLE public.beta_coupons ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users view own coupon" ON public.beta_coupons;
CREATE POLICY "Users view own coupon"
  ON public.beta_coupons FOR SELECT
  USING (auth.uid() = user_id);

-- ----- mcq_attempts trigger: track beta quota -----
CREATE OR REPLACE FUNCTION public.increment_beta_questions_used()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NEW.user_id IS NULL THEN
    RETURN NEW;
  END IF;

  -- First attempt for this (user, question) pair?
  IF EXISTS (
    SELECT 1 FROM public.mcq_attempts
    WHERE user_id = NEW.user_id
      AND question_id = NEW.question_id
      AND id <> NEW.id
  ) THEN
    RETURN NEW;
  END IF;

  -- Only increment for free-tier users who are enrolled in beta
  UPDATE public.profiles
     SET beta_questions_used = COALESCE(beta_questions_used, 0) + 1
   WHERE id = NEW.user_id
     AND membership_type = 'free'
     AND beta_expires_at IS NOT NULL;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_mcq_attempts_beta_quota ON public.mcq_attempts;
CREATE TRIGGER trg_mcq_attempts_beta_quota
  AFTER INSERT ON public.mcq_attempts
  FOR EACH ROW EXECUTE FUNCTION public.increment_beta_questions_used();

-- ----- promo window config -----
-- Stored in the pre-existing app_settings key/value table.
--   beta_promo_ends_at : ISO-8601 timestamp; new signups before this
--     date are auto-enrolled as beta testers. Default = 2026-05-13
--     (21 days from spec's launch date 2026-04-22).
INSERT INTO public.app_settings (key, value)
VALUES ('beta_promo_ends_at', '2026-05-13T23:59:59+07:00')
ON CONFLICT (key) DO NOTHING;

-- ----- one-time back-fill: upgrade existing free users to beta -----
-- Runs exactly once. Guarded by an app_settings flag so re-running
-- the migration is a no-op.
DO $$
DECLARE
  already_done text;
BEGIN
  SELECT value INTO already_done
    FROM public.app_settings
   WHERE key = 'beta_existing_user_backfill_done';

  IF already_done = 'true' THEN
    RETURN;
  END IF;

  UPDATE public.profiles
     SET beta_enrolled_via   = 'existing_user_upgrade',
         beta_started_at     = now(),
         beta_expires_at     = now() + interval '21 days',
         beta_questions_used = 0,
         beta_questions_limit = 25,
         has_seen_beta_welcome = false
   WHERE membership_type = 'free'
     AND beta_enrolled_via IS NULL;

  INSERT INTO public.app_settings (key, value)
  VALUES ('beta_existing_user_backfill_done', 'true')
  ON CONFLICT (key) DO UPDATE SET value = 'true', updated_at = now();
END
$$;
