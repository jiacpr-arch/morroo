-- Video lessons (YouTube-based) for the ACLS/BLS course, migrated from
-- emr-ai-clinic. Public read; writes via admin API routes (service role) —
-- the old project's email-allowlist write policy is intentionally dropped.

create table if not exists public.video_lessons (
  id            uuid primary key default gen_random_uuid(),
  topic         text not null,
  title         text not null,
  youtube_id    text not null,
  orientation   text not null default 'portrait',
  start_sec     integer,
  end_sec       integer,
  required      boolean not null default true,
  key_points    text not null default '',
  chapters      jsonb not null default '[]'::jsonb,
  quiz          jsonb not null default '[]'::jsonb,
  related_path  text,
  related_label text,
  sort_order    integer not null default 0,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);
create index if not exists video_lessons_topic_sort_idx
  on public.video_lessons (topic, sort_order);

create or replace function public.video_lessons_touch_updated_at()
returns trigger
language plpgsql
set search_path to 'public'
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists video_lessons_set_updated_at on public.video_lessons;
create trigger video_lessons_set_updated_at
  before update on public.video_lessons
  for each row execute function public.video_lessons_touch_updated_at();

alter table public.video_lessons enable row level security;

drop policy if exists video_lessons_public_read on public.video_lessons;
create policy video_lessons_public_read on public.video_lessons
  for select using (true);
