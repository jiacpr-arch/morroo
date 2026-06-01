-- ============================================
-- หมอรู้ (MorRoo) — School Mode: Student questions + self-improving content
-- ============================================
-- Students can "ask more" on a topic's book/lesson. Questions are stored here;
-- a background job (app/api/cron/school-enrich) later reads unprocessed
-- questions per topic, grounds Claude on the topic's full-text book, and
-- auto-publishes new flashcards/quizzes (tagged source 'student-driven:<slug>')
-- so the content gets more detailed where students actually struggle.

create table if not exists public.school_questions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users on delete set null,
  topic_id uuid not null references public.school_topics on delete cascade,
  chapter_id uuid references public.school_book_chapters on delete set null,
  question text not null,
  ai_answer text,
  status text default 'open' check (status in ('open', 'processed', 'dismissed')),
  processed_at timestamptz,
  created_at timestamptz default now()
);

create index if not exists idx_school_questions_topic_status
  on public.school_questions(topic_id, status);
create index if not exists idx_school_questions_user
  on public.school_questions(user_id);

alter table public.school_questions enable row level security;

create policy "Users insert own school questions"
  on public.school_questions for insert with check (auth.uid() = user_id);
create policy "Users read own school questions"
  on public.school_questions for select using (auth.uid() = user_id);
create policy "Admins manage school_questions"
  on public.school_questions for all
  using (auth.uid() in (select id from public.profiles where role = 'admin'));
