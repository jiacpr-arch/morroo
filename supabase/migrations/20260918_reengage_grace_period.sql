-- Grace period for the daily MCQ push: anyone who linked LINE in the last 14
-- days gets the card every weekday automatically, before silence counts
-- against them (lib/daily-mcq-line.ts getActiveDailyAudience). Without this,
-- a brand-new follower never received the card that is supposed to get them
-- to play in the first place.
--
-- The A/B cohort (20260918_daily_mcq_reengage_experiment) was frozen before
-- this rule existed and swept in people who were merely new, not dormant.
-- Remove them so the test stays "truly dormant" — allowed because the first
-- Monday send has not happened yet (sent_at is null). Idempotent.
--
-- Already applied to production on 2026-09-18.

delete from experiment_daily_mcq_reengage e
using profiles p
where p.id = e.user_id
  and e.sent_at is null
  and coalesce(p.line_linked_at, p.created_at) > now() - interval '14 days';
