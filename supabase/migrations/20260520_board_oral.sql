-- ============================================================================
-- Board oral exam: extend long_cases with audience discriminator
-- Mirrors mcq_questions pattern — single table, audience-based RLS/queries
-- ============================================================================

-- Add columns (idempotent)
alter table public.long_cases
  add column if not exists audience text not null default 'student',
  add column if not exists board_specialty text references public.board_specialties(slug);

-- audience check
alter table public.long_cases drop constraint if exists long_cases_audience_check;
alter table public.long_cases
  add constraint long_cases_audience_check check (audience in ('student','board'));

-- board cases must have a specialty; student cases must not
alter table public.long_cases drop constraint if exists long_cases_audience_consistency;
alter table public.long_cases
  add constraint long_cases_audience_consistency check (
    (audience = 'student' and board_specialty is null)
    or
    (audience = 'board' and board_specialty is not null)
  );

-- Backfill existing rows defensively
update public.long_cases set audience = 'student' where audience is null;

-- Index for board oral listing queries
create index if not exists idx_long_cases_board_specialty
  on public.long_cases(audience, board_specialty, is_published, published_at desc);
