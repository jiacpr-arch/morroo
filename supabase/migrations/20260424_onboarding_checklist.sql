-- Track when a user dismisses the onboarding checklist on the dashboard.
-- null = still showing, timestamp = dismissed.

ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS onboarding_checklist_dismissed_at timestamptz;
