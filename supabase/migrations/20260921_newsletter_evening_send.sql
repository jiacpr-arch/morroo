-- Move send-weekly-newsletter from Monday 09:00 ICT to Monday 19:00 ICT.
-- Morning broadcast felt intrusive at the start of the work/school day;
-- evening matches the send time already used by the other engagement
-- broadcasts (streak-nudge 19:00, school-streak-reminder 20:00).
select cron.alter_job(
  (select jobid from cron.job where jobname = 'send-weekly-newsletter'),
  schedule := '0 12 * * 1'
);
