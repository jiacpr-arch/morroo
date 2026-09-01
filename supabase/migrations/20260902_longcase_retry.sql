-- ============================================================
-- Long Case retry: paid members can retake a case; every attempt
-- is kept as history via long_case_sessions.attempt_number.
-- ============================================================
-- DEPLOY ORDER: run this SQL in Supabase BEFORE deploying the app
-- code — the new code inserts and orders by attempt_number, so the
-- Long Case feature 500s until this migration has been applied.
-- (The reverse — SQL applied while old code still serves — is safe.)
-- Every statement is idempotent; safe to run twice.
-- ============================================================

-- 1) attempt_number — existing rows become attempt 1
ALTER TABLE public.long_case_sessions
  ADD COLUMN IF NOT EXISTS attempt_number INT NOT NULL DEFAULT 1;

-- 2) Replace UNIQUE(case_id, user_id) with UNIQUE(case_id, user_id, attempt_number).
-- The old constraint is found by its definition, not a guessed name, so this
-- works even if production named it differently than the schema file would.
DO $$
DECLARE con record;
BEGIN
  FOR con IN
    SELECT c.conname
      FROM pg_constraint c
     WHERE c.conrelid = 'public.long_case_sessions'::regclass
       AND c.contype = 'u'
       AND (SELECT array_agg(a.attname::text ORDER BY a.attname)
              FROM unnest(c.conkey) AS k(attnum)
              JOIN pg_attribute a
                ON a.attrelid = c.conrelid AND a.attnum = k.attnum)
           = ARRAY['case_id', 'user_id']
  LOOP
    EXECUTE format('ALTER TABLE public.long_case_sessions DROP CONSTRAINT %I', con.conname);
  END LOOP;
END $$;

CREATE UNIQUE INDEX IF NOT EXISTS long_case_sessions_case_user_attempt_key
  ON public.long_case_sessions(case_id, user_id, attempt_number);

-- 3) Coins are earned once per case, on the first attempt only.
-- The ledger dedup in meq_coin_transactions is per (user, session, source);
-- every retry is a new session row, so without this guard each retake
-- would mint fresh completion/bonus/feedback coins without bound.
CREATE OR REPLACE FUNCTION public.award_longcase_completion_coins()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  base_amount int := 20;
  bonus_amount int := 10;
  pct int;
BEGIN
  -- Only fire when completed_at transitions NULL -> NOT NULL
  IF OLD.completed_at IS NOT NULL OR NEW.completed_at IS NULL THEN
    RETURN NEW;
  END IF;
  IF NEW.user_id IS NULL THEN
    RETURN NEW;
  END IF;
  -- Retry attempts never re-award
  IF COALESCE(NEW.attempt_number, 1) > 1 THEN
    RETURN NEW;
  END IF;

  -- Base completion coins (idempotent via UNIQUE constraint)
  INSERT INTO public.meq_coin_transactions (user_id, source, amount, session_id, meta)
  VALUES (NEW.user_id, 'longcase_complete', base_amount, NEW.id,
          jsonb_build_object('case_id', NEW.case_id))
  ON CONFLICT (user_id, session_id, source) DO NOTHING;

  IF FOUND THEN
    UPDATE public.profiles
       SET meq_coins = COALESCE(meq_coins, 0) + base_amount
     WHERE id = NEW.user_id;
  END IF;

  -- Bonus for scoring >=70%
  pct := COALESCE(NEW.score_total_pct, 0);
  IF pct >= 70 THEN
    INSERT INTO public.meq_coin_transactions (user_id, source, amount, session_id, meta)
    VALUES (NEW.user_id, 'longcase_high_score', bonus_amount, NEW.id,
            jsonb_build_object('score_total_pct', pct))
    ON CONFLICT (user_id, session_id, source) DO NOTHING;

    IF FOUND THEN
      UPDATE public.profiles
         SET meq_coins = COALESCE(meq_coins, 0) + bonus_amount
       WHERE id = NEW.user_id;
    END IF;
  END IF;

  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.award_longcase_feedback_coins()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  feedback_amount int := 10;
  session_attempt int;
BEGIN
  IF NEW.user_id IS NULL THEN
    RETURN NEW;
  END IF;

  -- Feedback on retry attempts is recorded but earns no coins
  SELECT attempt_number INTO session_attempt
    FROM public.long_case_sessions WHERE id = NEW.session_id;
  IF COALESCE(session_attempt, 1) > 1 THEN
    RETURN NEW;
  END IF;

  INSERT INTO public.meq_coin_transactions (user_id, source, amount, session_id, meta)
  VALUES (NEW.user_id, 'longcase_feedback', feedback_amount, NEW.session_id,
          jsonb_build_object('case_id', NEW.case_id,
                             'case_rating', NEW.case_rating,
                             'difficulty_vote', NEW.difficulty_vote,
                             'flag_issue', NEW.flag_issue))
  ON CONFLICT (user_id, session_id, source) DO NOTHING;

  IF FOUND THEN
    UPDATE public.profiles
       SET meq_coins = COALESCE(meq_coins, 0) + feedback_amount
     WHERE id = NEW.user_id;
    NEW.coins_awarded := feedback_amount;
  END IF;

  RETURN NEW;
END;
$$;

-- 4) Membership fields are server-set only. The paid-only retry gate reads
-- profiles.membership_type / membership_expires_at, and the existing
-- "Users can update own profile" RLS policy would let a client set them
-- directly. Block that for regular end users. Admins are exempt — the
-- admin pages (/admin/payments, /admin/users) update membership from the
-- browser client as the authenticated role. Service role and direct SQL
-- are unaffected.
CREATE OR REPLACE FUNCTION public.protect_membership_columns()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF (NEW.membership_type IS DISTINCT FROM OLD.membership_type
      OR NEW.membership_expires_at IS DISTINCT FROM OLD.membership_expires_at)
     AND COALESCE(auth.role(), 'postgres') IN ('authenticated', 'anon')
     AND NOT EXISTS (
       SELECT 1 FROM public.profiles
        WHERE id = auth.uid() AND role = 'admin'
     ) THEN
    RAISE EXCEPTION 'membership fields can only be changed by the server';
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_protect_membership ON public.profiles;
CREATE TRIGGER trg_protect_membership
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.protect_membership_columns();
