-- ============================================
-- หมอรู้ (MorRoo) — Board MCQ AI generation queue
--
-- เมื่อมีคนซื้อ board_monthly / board_yearly:
--   1. fulfill-checkout enqueue 1 row ต่อ specialty ที่ยังมีข้อสอบ < target
--   2. cron /api/cron/board-gen หยิบ row 'queued' ทีละตัว (1 specialty / tick)
--   3. agent gen + self-critique → insert เข้า mcq_questions
--      - critique pass สูง → status='active' (publish ทันที)
--      - critique pass กลาง → status='review' (รอ admin)
-- ============================================

create table if not exists public.board_gen_jobs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles(id) on delete set null,
  trigger text not null default 'subscription',
  specialty_slug text not null references public.board_specialties(slug) on delete cascade,
  target_count int not null default 30,
  status text not null default 'queued'
    check (status in ('queued', 'running', 'done', 'error', 'skipped')),
  generated_count int default 0,
  drafted_count int default 0,
  error text,
  attempts int default 0,
  stripe_session_id text,
  created_at timestamptz default now(),
  started_at timestamptz,
  completed_at timestamptz
);

create index if not exists board_gen_jobs_queue_idx
  on public.board_gen_jobs (status, created_at)
  where status in ('queued', 'running');

create index if not exists board_gen_jobs_session_idx
  on public.board_gen_jobs (stripe_session_id)
  where stripe_session_id is not null;

create unique index if not exists board_gen_jobs_unique_session_specialty
  on public.board_gen_jobs (stripe_session_id, specialty_slug)
  where stripe_session_id is not null;

-- ─── Seed mcq_subjects rows สำหรับสาขาที่ยังไม่มี ──────
--
-- agent gen จะ insert mcq_questions โดยอ้าง subject_id ตาม (specialty × section)
-- ปัจจุบัน board_seed.sql seed ไว้แค่ emergency_medicine — สาขาอื่นต้องสร้างก่อน

insert into public.mcq_subjects (name, name_th, icon, audience, board_specialty, exam_type, question_count)
select
  sp.slug || '_' || sec.code as name,
  sp.short_name_th || ' · ' || sec.label_th as name_th,
  sp.icon,
  'board',
  sp.slug,
  null,
  0
from public.board_specialties sp
cross join (values
  ('clinical_decision', 'การตัดสินใจทางเวชกรรม'),
  ('basic_science',     'วิทยาศาสตร์การแพทย์พื้นฐาน'),
  ('integrative',       'ข้อสอบบูรณาการ')
) as sec(code, label_th)
where sp.is_active = true
on conflict (name) do nothing;
