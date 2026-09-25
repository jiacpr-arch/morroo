-- "ทบทวนข้อที่ผิด" queue is NL-only (20260925_mcq_review_queue.sql, already
-- applied — do not edit that file). Idempotent.
--
-- Bug: the toggle badge (lib/mcq-review.ts getMcqReviewDueCount) and the LINE
-- reminder (this RPC) counted every active queued question, but
-- /nl/practice?mode=review (getDueReviewQuestions) only serves
-- audience='student' — and the LINE daily-quiz path enqueued without checking
-- audience. A queued board question would be counted forever but never shown
-- (so never answered, never graduated).
--
-- Fix here: (1) the RPC counts student-audience questions only; (2) drop any
-- non-student rows already queued. The app side (badge filter + LINE enqueue
-- guard, lib/mcq-review.ts isReviewQueueAudience) ships with the same change.

create or replace function public.mcq_review_due_counts(
  p_cutoff timestamptz,
  p_active_since timestamptz
)
returns table (user_id uuid, line_user_id text, name text, due_count bigint)
language sql
stable
set search_path = public
as $$
  select p.id, p.line_user_id, p.name, count(*) as due_count
  from public.mcq_review_queue r
  join public.mcq_questions q
    on q.id = r.question_id
   and q.status = 'active'
   and q.audience = 'student'
  join public.profiles p on p.id = r.user_id and p.line_user_id is not null
  where r.due_at < p_cutoff
    and exists (
      select 1 from public.mcq_attempts a
      where a.user_id = r.user_id and a.created_at >= p_active_since
    )
  group by p.id, p.line_user_id, p.name;
$$;

-- Cron-only (service role). Never callable from the browser.
revoke all on function public.mcq_review_due_counts(timestamptz, timestamptz) from public, anon, authenticated;
grant execute on function public.mcq_review_due_counts(timestamptz, timestamptz) to service_role;

-- Cleanup: rows for questions that aren't student-audience can never be served
-- by ?mode=review. Safe to re-run.
delete from public.mcq_review_queue r
using public.mcq_questions q
where q.id = r.question_id
  and q.audience is distinct from 'student';
