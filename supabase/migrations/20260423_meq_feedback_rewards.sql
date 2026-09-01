-- ============================================================
-- MEQ Long Case: post-exam feedback + coin rewards
-- ============================================================
-- After a student finishes a long case (completed_at set), they
-- receive coins and can submit feedback about the case for more
-- coins. Coins live on profiles.meq_coins and every award is
-- audited in meq_coin_transactions.
-- ============================================================

-- 1) Running coin balance on each profile
ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS meq_coins int NOT NULL DEFAULT 0;

-- 2) Feedback table — one row per completed session
CREATE TABLE IF NOT EXISTS public.long_case_feedback (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id uuid NOT NULL UNIQUE
    REFERENCES public.long_case_sessions(id) ON DELETE CASCADE,
  case_id uuid NOT NULL
    REFERENCES public.long_cases(id) ON DELETE CASCADE,
  user_id uuid NOT NULL
    REFERENCES auth.users(id) ON DELETE CASCADE,

  case_rating int NOT NULL CHECK (case_rating BETWEEN 1 AND 5),
  difficulty_vote text NOT NULL CHECK (difficulty_vote IN (
    'too_easy', 'just_right', 'too_hard'
  )),
  examiner_fairness int NOT NULL CHECK (examiner_fairness BETWEEN 1 AND 5),
  comment text,
  flag_issue boolean NOT NULL DEFAULT false,

  coins_awarded int NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_long_case_feedback_case
  ON public.long_case_feedback(case_id);
CREATE INDEX IF NOT EXISTS idx_long_case_feedback_user
  ON public.long_case_feedback(user_id);
CREATE INDEX IF NOT EXISTS idx_long_case_feedback_flag
  ON public.long_case_feedback(flag_issue) WHERE flag_issue = true;

-- 3) Coin transaction ledger (audit trail)
CREATE TABLE IF NOT EXISTS public.meq_coin_transactions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  source text NOT NULL CHECK (source IN (
    'longcase_complete',    -- finished a case
    'longcase_high_score',  -- bonus for ≥70%
    'longcase_feedback'     -- submitted feedback
  )),
  amount int NOT NULL,
  session_id uuid REFERENCES public.long_case_sessions(id) ON DELETE SET NULL,
  meta jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  -- One award per (user, session, source) — prevents double-crediting
  UNIQUE (user_id, session_id, source)
);

CREATE INDEX IF NOT EXISTS idx_meq_coin_tx_user
  ON public.meq_coin_transactions(user_id, created_at DESC);

-- 4) Trigger: award coins when a session is marked completed
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

  -- Bonus for scoring ≥70%
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

DROP TRIGGER IF EXISTS trg_longcase_award_completion
  ON public.long_case_sessions;
CREATE TRIGGER trg_longcase_award_completion
  AFTER UPDATE OF completed_at ON public.long_case_sessions
  FOR EACH ROW EXECUTE FUNCTION public.award_longcase_completion_coins();

-- 5) Trigger: award coins when feedback is submitted
CREATE OR REPLACE FUNCTION public.award_longcase_feedback_coins()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  feedback_amount int := 10;
BEGIN
  IF NEW.user_id IS NULL THEN
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

DROP TRIGGER IF EXISTS trg_longcase_feedback_award
  ON public.long_case_feedback;
CREATE TRIGGER trg_longcase_feedback_award
  BEFORE INSERT ON public.long_case_feedback
  FOR EACH ROW EXECUTE FUNCTION public.award_longcase_feedback_coins();

-- 6) RLS for feedback — users can submit and see their own
ALTER TABLE public.long_case_feedback ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users insert own longcase feedback" ON public.long_case_feedback;
CREATE POLICY "Users insert own longcase feedback"
  ON public.long_case_feedback FOR INSERT
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users view own longcase feedback" ON public.long_case_feedback;
CREATE POLICY "Users view own longcase feedback"
  ON public.long_case_feedback FOR SELECT
  USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Admins manage longcase feedback" ON public.long_case_feedback;
CREATE POLICY "Admins manage longcase feedback"
  ON public.long_case_feedback FOR ALL
  USING (
    auth.uid() IN (SELECT id FROM public.profiles WHERE role = 'admin')
  );

-- 7) RLS for coin transactions — read-only view of own ledger
ALTER TABLE public.meq_coin_transactions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users view own coin transactions" ON public.meq_coin_transactions;
CREATE POLICY "Users view own coin transactions"
  ON public.meq_coin_transactions FOR SELECT
  USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Admins view all coin transactions" ON public.meq_coin_transactions;
CREATE POLICY "Admins view all coin transactions"
  ON public.meq_coin_transactions FOR SELECT
  USING (
    auth.uid() IN (SELECT id FROM public.profiles WHERE role = 'admin')
  );
