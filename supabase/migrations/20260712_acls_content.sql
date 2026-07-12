-- ACLS teaching content tables, migrated from the emr-ai-clinic project
-- (elyyijlcjfvhxbpzscnv) as part of folding the ACLS/BLS course into morroo.
-- Schema mirrors the live source DB.
--
-- RLS note: the old app let any `authenticated` user write these tables
-- (its only account WAS the admin). In morroo every logged-in member is
-- `authenticated`, so those write policies are intentionally NOT copied —
-- all writes go through admin API routes using the service-role key.
-- Published content stays anon-readable for the student-facing pages.

-- ---------- knowledge reader (ALS chapters) ----------

create table if not exists public.acls_chapters (
  id          text primary key,
  title       text not null,
  icon        text,
  sort_order  integer not null,
  updated_at  timestamptz not null default now()
);

create table if not exists public.acls_sections (
  id          uuid primary key default gen_random_uuid(),
  chapter_id  text not null references public.acls_chapters(id) on delete cascade,
  heading     text,
  body        text,
  sort_order  integer not null,
  updated_at  timestamptz not null default now()
);
create index if not exists idx_acls_sections_chapter
  on public.acls_sections (chapter_id, sort_order);

create table if not exists public.acls_qa_items (
  id          uuid primary key default gen_random_uuid(),
  section_id  uuid not null references public.acls_sections(id) on delete cascade,
  q           text not null,
  a           text,
  sort_order  integer not null,
  updated_at  timestamptz not null default now()
);
create index if not exists idx_acls_qa_section
  on public.acls_qa_items (section_id, sort_order);

-- Images attached to sections / QA items / pre-course steps.
create table if not exists public.acls_images (
  id          uuid primary key default gen_random_uuid(),
  parent_type text not null check (parent_type in ('section','qa','precourse-step','precourse-video')),
  parent_id   text not null,
  src         text not null,
  alt         text,
  caption     text,
  sort_order  integer not null,
  created_at  timestamptz not null default now()
);
create index if not exists idx_acls_images_parent
  on public.acls_images (parent_type, parent_id, sort_order);

-- ---------- Q&A ACLS Deep ----------

create table if not exists public.acls_qa_deep_page (
  id              uuid primary key default gen_random_uuid(),
  title           text not null default 'Q&A ACLS เชิงลึก',
  intro           text,
  cover_image_url text,
  updated_at      timestamptz not null default now()
);

create table if not exists public.acls_qa_deep_items (
  id          uuid primary key default gen_random_uuid(),
  question    text not null default '',
  answer      text not null default '',
  sort_order  integer not null default 0,
  chapter_id  text references public.acls_chapters(id) on delete set null,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);
create index if not exists acls_qa_deep_items_sort_idx
  on public.acls_qa_deep_items (sort_order);
create index if not exists acls_qa_deep_items_chapter_idx
  on public.acls_qa_deep_items (chapter_id, sort_order);

create table if not exists public.acls_qa_deep_images (
  id          uuid primary key default gen_random_uuid(),
  item_id     uuid not null references public.acls_qa_deep_items(id) on delete cascade,
  image_type  text not null check (image_type in ('cover','infographic')),
  src         text not null,
  alt         text,
  caption     text,
  sort_order  integer not null default 0,
  created_at  timestamptz not null default now()
);
create index if not exists acls_qa_deep_images_item_idx
  on public.acls_qa_deep_images (item_id, image_type, sort_order);

-- ---------- student-submitted questions (AI answer pipeline) ----------

create table if not exists public.acls_student_questions (
  id                    uuid primary key default gen_random_uuid(),
  question              text not null,
  student_name          text,
  student_contact       text,
  status                text not null default 'pending'
    check (status in ('pending','processing','draft_ready','published','rejected','failed')),
  deepseek_answer       text,
  suggested_chapter_id  text references public.acls_chapters(id) on delete set null,
  classification_reason text,
  generated_image_url   text,
  image_prompt          text,
  admin_notes           text,
  error_message         text,
  request_ip            text,
  published_item_id     uuid references public.acls_qa_deep_items(id) on delete set null,
  created_at            timestamptz not null default now(),
  processed_at          timestamptz,
  published_at          timestamptz,
  updated_at            timestamptz not null default now()
);
create index if not exists idx_acls_student_questions_status
  on public.acls_student_questions (status, created_at desc);

-- ---------- touch-updated_at trigger ----------

create or replace function public.acls_touch_updated_at()
returns trigger
language plpgsql
set search_path to 'public'
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists trg_acls_chapters_touch on public.acls_chapters;
create trigger trg_acls_chapters_touch
  before update on public.acls_chapters
  for each row execute function public.acls_touch_updated_at();

drop trigger if exists trg_acls_sections_touch on public.acls_sections;
create trigger trg_acls_sections_touch
  before update on public.acls_sections
  for each row execute function public.acls_touch_updated_at();

drop trigger if exists trg_acls_qa_touch on public.acls_qa_items;
create trigger trg_acls_qa_touch
  before update on public.acls_qa_items
  for each row execute function public.acls_touch_updated_at();

-- ---------- RLS ----------

alter table public.acls_chapters          enable row level security;
alter table public.acls_sections          enable row level security;
alter table public.acls_qa_items          enable row level security;
alter table public.acls_images            enable row level security;
alter table public.acls_qa_deep_page      enable row level security;
alter table public.acls_qa_deep_items     enable row level security;
alter table public.acls_qa_deep_images    enable row level security;
alter table public.acls_student_questions enable row level security;

-- Published content: anon read only. Writes = service role (bypasses RLS).
drop policy if exists acls_chapters_public_read on public.acls_chapters;
create policy acls_chapters_public_read on public.acls_chapters
  for select to anon, authenticated using (true);

drop policy if exists acls_sections_public_read on public.acls_sections;
create policy acls_sections_public_read on public.acls_sections
  for select to anon, authenticated using (true);

drop policy if exists acls_qa_public_read on public.acls_qa_items;
create policy acls_qa_public_read on public.acls_qa_items
  for select to anon, authenticated using (true);

drop policy if exists acls_images_public_read on public.acls_images;
create policy acls_images_public_read on public.acls_images
  for select to anon, authenticated using (true);

drop policy if exists acls_qa_deep_page_public_read on public.acls_qa_deep_page;
create policy acls_qa_deep_page_public_read on public.acls_qa_deep_page
  for select to anon, authenticated using (true);

drop policy if exists acls_qa_deep_items_public_read on public.acls_qa_deep_items;
create policy acls_qa_deep_items_public_read on public.acls_qa_deep_items
  for select to anon, authenticated using (true);

drop policy if exists acls_qa_deep_images_public_read on public.acls_qa_deep_images;
create policy acls_qa_deep_images_public_read on public.acls_qa_deep_images
  for select to anon, authenticated using (true);

-- acls_student_questions: no anon policies. Submissions and admin reads go
-- through API routes (service role) — tighter than the old anon-insert model.
