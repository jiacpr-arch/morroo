-- Fixed-window rate limiter backed by Supabase. Each (user, route, window)
-- pair maps to a single row; check_and_increment_rate_limit does an upsert
-- and returns whether the caller is allowed.

CREATE TABLE IF NOT EXISTS public.api_rate_limits (
  user_id uuid NOT NULL,
  route_key text NOT NULL,
  window_start timestamptz NOT NULL,
  count int NOT NULL DEFAULT 1,
  PRIMARY KEY (user_id, route_key, window_start)
);

CREATE INDEX IF NOT EXISTS idx_api_rate_limits_window
  ON public.api_rate_limits (window_start);

ALTER TABLE public.api_rate_limits ENABLE ROW LEVEL SECURITY;

-- No direct client access — the RPC is SECURITY DEFINER and takes care of writes.
CREATE POLICY "no direct access"
  ON public.api_rate_limits FOR ALL
  USING (false)
  WITH CHECK (false);

-- check_and_increment_rate_limit:
--   Atomically bumps the counter for the current window and returns the
--   caller's standing. Windows are aligned to fixed boundaries of p_window_seconds
--   so bursts can't slide across windows by a few ms.
CREATE OR REPLACE FUNCTION check_and_increment_rate_limit(
  p_user_id uuid,
  p_route_key text,
  p_max int,
  p_window_seconds int
) RETURNS json
LANGUAGE plpgsql SECURITY DEFINER
AS $$
DECLARE
  v_epoch bigint;
  v_window_start timestamptz;
  v_count int;
BEGIN
  v_epoch := EXTRACT(EPOCH FROM now())::bigint;
  v_window_start := to_timestamp(v_epoch - (v_epoch % p_window_seconds));

  INSERT INTO public.api_rate_limits (user_id, route_key, window_start, count)
  VALUES (p_user_id, p_route_key, v_window_start, 1)
  ON CONFLICT (user_id, route_key, window_start)
  DO UPDATE SET count = public.api_rate_limits.count + 1
  RETURNING count INTO v_count;

  RETURN json_build_object(
    'allowed', v_count <= p_max,
    'count', v_count,
    'remaining', GREATEST(0, p_max - v_count),
    'reset_at', v_window_start + (p_window_seconds * interval '1 second')
  );
END;
$$;

GRANT EXECUTE ON FUNCTION check_and_increment_rate_limit(uuid, text, int, int) TO authenticated;

-- Housekeeping: purge rows older than 2 days. Call from a cron or manually.
CREATE OR REPLACE FUNCTION prune_api_rate_limits()
RETURNS void
LANGUAGE sql SECURITY DEFINER
AS $$
  DELETE FROM public.api_rate_limits
  WHERE window_start < now() - interval '2 days';
$$;

GRANT EXECUTE ON FUNCTION prune_api_rate_limits() TO service_role;
