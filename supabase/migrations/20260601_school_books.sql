-- ============================================
-- หมอรู้ (MorRoo) — School Mode: Full-text Books (หนังสือฉบับเต็ม)
-- ============================================
-- Each topic gets one "book" assembled from its source lectures. Chapters
-- store the lecture body verbatim so students can read the full reference
-- text continuously (with a table of contents), alongside the existing
-- micro-learning Concept Reader + retrieval-practice loop.

-- ----------------------------------------------
-- 1. Book + chapters
-- ----------------------------------------------
create table if not exists public.school_books (
  id uuid primary key default gen_random_uuid(),
  topic_id uuid not null references public.school_topics on delete cascade,
  title text not null,
  description text,
  source text,
  status text default 'active' check (status in ('active', 'review', 'disabled')),
  created_at timestamptz default now(),
  unique (topic_id)                          -- one book per topic
);

create table if not exists public.school_book_chapters (
  id uuid primary key default gen_random_uuid(),
  book_id uuid not null references public.school_books on delete cascade,
  sort_order int default 0,
  title text not null,
  body_md text not null,                     -- full lecture text, verbatim
  source text,
  created_at timestamptz default now()
);

-- ----------------------------------------------
-- 2. Track "chapter read" in the shared progress table
-- ----------------------------------------------
-- Extend the unit_type check so reading a book chapter can be recorded
-- (and XP awarded) the same way lessons/flashcards/quizzes are.
alter table public.school_progress
  drop constraint if exists school_progress_unit_type_check;
alter table public.school_progress
  add constraint school_progress_unit_type_check
  check (unit_type in ('flashcard', 'lesson', 'quiz', 'book_chapter'));

-- ----------------------------------------------
-- 3. Indexes
-- ----------------------------------------------
create index if not exists idx_school_books_topic on public.school_books(topic_id);
create index if not exists idx_school_book_chapters_book on public.school_book_chapters(book_id);

-- ----------------------------------------------
-- 4. Row-level security (mirrors school_lessons)
-- ----------------------------------------------
alter table public.school_books enable row level security;
alter table public.school_book_chapters enable row level security;

create policy "Active school books readable by everyone"
  on public.school_books for select using (status = 'active');
create policy "School book chapters readable by everyone"
  on public.school_book_chapters for select using (true);

create policy "Admins manage school_books"
  on public.school_books for all
  using (auth.uid() in (select id from public.profiles where role = 'admin'));
create policy "Admins manage school_book_chapters"
  on public.school_book_chapters for all
  using (auth.uid() in (select id from public.profiles where role = 'admin'));
