-- ============================================
-- หมอรู้ (MorRoo) — Enable RLS on board_gen_jobs
--
-- The table was created (20260602_board_gen_jobs.sql) without RLS, so anyone
-- with the anon key could read/write the AI generation queue. Server paths
-- (cron /api/cron/board-gen, lib/board/enqueue, scripts/generate-board-daily)
-- use the service-role client and bypass RLS, so they are unaffected. The only
-- client-side access is the admin "runs" dashboard (app/admin/board/runs:
-- select + requeueBoardGenJob), so a single admin-scoped policy is enough —
-- matching the pattern used by board_specialties / school_books.
--
-- Public "กำลังจัดทำ" counts keep working: board_specialty_metrics() is
-- SECURITY DEFINER and reads the queue on the caller's behalf.
-- ============================================

alter table public.board_gen_jobs enable row level security;

create policy "Admins manage board_gen_jobs"
  on public.board_gen_jobs for all
  using (auth.uid() in (select id from public.profiles where role = 'admin'));
