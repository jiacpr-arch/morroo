-- Share-to-earn: users get +5 MEQ coins/week for sharing their weekly
-- result externally. Dedup'd on (user_id, week_start) so they can only
-- claim once per ISO week.

-- Extend the CHECK constraint on meq_coin_transactions.source to allow
-- the new award type.
ALTER TABLE public.meq_coin_transactions
  DROP CONSTRAINT IF EXISTS meq_coin_transactions_source_check;

ALTER TABLE public.meq_coin_transactions
  ADD CONSTRAINT meq_coin_transactions_source_check
  CHECK (source IN (
    'longcase_complete',
    'longcase_high_score',
    'longcase_feedback',
    'share_weekly_result'
  ));

-- Partial unique index: one weekly_result award per (user, week).
CREATE UNIQUE INDEX IF NOT EXISTS idx_meq_share_weekly_unique
  ON public.meq_coin_transactions (user_id, ((meta->>'week_start')))
  WHERE source = 'share_weekly_result';

-- claim_weekly_share_reward:
--   Awards +5 MEQ coins once per ISO week per user. Returns the resulting
--   balance or indicates that this week was already claimed.
CREATE OR REPLACE FUNCTION claim_weekly_share_reward(p_user_id uuid)
RETURNS json
LANGUAGE plpgsql SECURITY DEFINER
AS $$
DECLARE
  v_week_start date;
  v_reward int := 5;
  v_new_balance int;
BEGIN
  v_week_start := date_trunc('week', current_date)::date;

  BEGIN
    INSERT INTO public.meq_coin_transactions (user_id, source, amount, meta)
    VALUES (
      p_user_id,
      'share_weekly_result',
      v_reward,
      jsonb_build_object('week_start', v_week_start)
    );
  EXCEPTION WHEN unique_violation THEN
    RETURN json_build_object(
      'awarded', 0,
      'already_claimed', true,
      'week_start', v_week_start,
      'next_claim_at', v_week_start + interval '7 days'
    );
  END;

  UPDATE public.profiles
  SET meq_coins = COALESCE(meq_coins, 0) + v_reward
  WHERE id = p_user_id
  RETURNING meq_coins INTO v_new_balance;

  RETURN json_build_object(
    'awarded', v_reward,
    'new_balance', v_new_balance,
    'week_start', v_week_start,
    'next_claim_at', v_week_start + interval '7 days'
  );
END;
$$;

GRANT EXECUTE ON FUNCTION claim_weekly_share_reward(uuid) TO authenticated;
