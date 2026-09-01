-- ============================================
-- School Phase 5 — concepts (cross-subject tags) + integrated cases
-- ============================================

-- Concepts: universal cross-curricular tags
-- Example: 'raas' = renin-angiotensin-aldosterone system
-- one concept can be linked to flashcards/quizzes/lessons across
-- multiple topics, years, and systems.
create table if not exists public.school_concepts (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  name_th text not null,
  name_en text not null,
  description text,
  icon text default '🔗',
  created_at timestamptz default now()
);

-- Junction: link a concept to any unit (flashcard / quiz / lesson)
create table if not exists public.school_concept_links (
  concept_id uuid not null references public.school_concepts on delete cascade,
  unit_type text not null check (unit_type in ('flashcard', 'quiz', 'lesson', 'case_stage')),
  unit_id uuid not null,
  primary key (concept_id, unit_type, unit_id)
);

create index if not exists idx_concept_links_unit on public.school_concept_links(unit_type, unit_id);

-- Integrated cases: a single clinical scenario walking through multiple
-- layers (foundation → physio → path → pharm → clinical) across years.
create table if not exists public.school_cases (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  title text not null,
  presentation text not null,
  difficulty text default 'medium' check (difficulty in ('easy', 'medium', 'hard')),
  audience_years smallint[] default '{1,2,3,4,5,6}',
  primary_system_id uuid references public.school_systems,
  status text default 'active' check (status in ('active', 'review', 'disabled')),
  created_at timestamptz default now()
);

create table if not exists public.school_case_stages (
  id uuid primary key default gen_random_uuid(),
  case_id uuid not null references public.school_cases on delete cascade,
  stage_order int not null,
  layer text not null,
  title text not null,
  body_md text not null,
  mini_quiz_stem text,
  mini_quiz_choices jsonb,
  mini_quiz_answer text,
  mini_quiz_explanation text,
  created_at timestamptz default now(),
  unique (case_id, stage_order)
);

create index if not exists idx_case_stages_case on public.school_case_stages(case_id, stage_order);

-- RLS
alter table public.school_concepts enable row level security;
alter table public.school_concept_links enable row level security;
alter table public.school_cases enable row level security;
alter table public.school_case_stages enable row level security;

create policy "Concepts readable by everyone"
  on public.school_concepts for select using (true);
create policy "Concept links readable by everyone"
  on public.school_concept_links for select using (true);
create policy "Active cases readable by everyone"
  on public.school_cases for select using (status = 'active');
create policy "Case stages readable by everyone"
  on public.school_case_stages for select using (true);

create policy "Admins manage concepts"
  on public.school_concepts for all
  using (auth.uid() in (select id from public.profiles where role = 'admin'));
create policy "Admins manage concept links"
  on public.school_concept_links for all
  using (auth.uid() in (select id from public.profiles where role = 'admin'));
create policy "Admins manage cases"
  on public.school_cases for all
  using (auth.uid() in (select id from public.profiles where role = 'admin'));
create policy "Admins manage case stages"
  on public.school_case_stages for all
  using (auth.uid() in (select id from public.profiles where role = 'admin'));

-- Seed a few canonical concepts to bootstrap cross-linking
insert into public.school_concepts (slug, name_th, name_en, description, icon) values
  ('raas',                'ระบบ RAAS',                   'Renin-Angiotensin-Aldosterone System',  'แกนควบคุม BP + Na/H2O — เชื่อม physio Y2, path Y3 (HT), pharm Y3 (ACE-I/ARB), clinical Y4 (CHF/CKD)', '💧'),
  ('action-potential',    'Action Potential',            'Action Potential',                       'พื้นฐานการนำสัญญาณของ neuron + cardiac + skeletal muscle', '⚡'),
  ('inflammation',        'การอักเสบ',                   'Inflammation',                            'cellular response — acute vs chronic; เชื่อม path + immunology + clinical', '🔥'),
  ('apoptosis',           'Apoptosis',                   'Programmed Cell Death',                   'cell biology Y1 + cancer Y3 + immunology', '🧬'),
  ('atherosclerosis',     'Atherosclerosis',             'Atherosclerosis',                         'พื้นฐาน CAD / stroke / PAD — Y3 path + Y4 cardio', '🩸'),
  ('insulin-glucose',     'Insulin / Glucose homeostasis','Insulin & Glucose Homeostasis',          'Y2 physio + Y3 endo + Y5 DM mgmt', '🍯'),
  ('cytokines',           'Cytokines',                   'Cytokines / Inflammation Mediators',      'TNF, IL-1, IL-6 — immune + IBD + sepsis', '🧪'),
  ('starling-curve',      'Starling Curve',              'Frank-Starling Mechanism',                'preload — cardiac physio Y2 + CHF Y4', '❤️'),
  ('clearance',           'Clearance',                   'Renal Clearance / GFR',                   'physio Y2 + path Y3 (CKD) + pharm (dose adjust)', '🚿'),
  ('cell-cycle',          'Cell Cycle',                  'Cell Cycle',                              'cell biology Y1 + cancer Y3 + chemo Y3', '🔁')
on conflict (slug) do nothing;
