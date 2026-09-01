-- ============================================================
-- Extend Beta Tester Program by 30 days
-- ============================================================
-- Adds an extra month to the existing beta program:
--   * Pushes the promo signup window forward 30 days
--     (2026-05-13 -> 2026-06-13) so new free signups are
--     auto-enrolled again.
--   * Adds 30 days to beta_expires_at for every profile that
--     was previously enrolled in beta (active or recently
--     expired), so they get the same extension.
--
-- BETA_DURATION_DAYS (21) for brand-new signups is unchanged.
-- Idempotent: guarded by app_settings flag.
-- ============================================================

DO $$
DECLARE
  already_done text;
BEGIN
  SELECT value INTO already_done
    FROM public.app_settings
   WHERE key = 'beta_extend_30d_done';

  IF already_done = 'true' THEN
    RETURN;
  END IF;

  -- Push the promo signup window forward 30 days.
  INSERT INTO public.app_settings (key, value)
  VALUES ('beta_promo_ends_at', '2026-06-13T23:59:59+07:00')
  ON CONFLICT (key) DO UPDATE
    SET value = '2026-06-13T23:59:59+07:00',
        updated_at = now();

  -- Extend every enrolled beta tester's expiry by 30 days.
  UPDATE public.profiles
     SET beta_expires_at = beta_expires_at + interval '30 days'
   WHERE beta_enrolled_via IS NOT NULL
     AND beta_expires_at IS NOT NULL;

  INSERT INTO public.app_settings (key, value)
  VALUES ('beta_extend_30d_done', 'true')
  ON CONFLICT (key) DO UPDATE
    SET value = 'true',
        updated_at = now();
END
$$;
