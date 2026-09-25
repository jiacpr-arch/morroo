-- Mock Exam percentile: นับเฉพาะผลที่ server ตรวจเอง (ปิดช่องปลอมคะแนน)
--
-- DEPLOY ORDER: deploy app ก่อนหรือพร้อมกันกับ migration นี้
--   * app ใหม่ insert คอลัมน์ graded_by_server / mock_token_hash — ถ้า migration
--     ยังไม่ลง insert จะพลาด → /api/mcq/mock/submit ยังคืนคะแนน+เฉลยได้
--     (unrankedReason 'save_failed') แค่ไม่มี percentile
--   * ถ้าลง migration ก่อน app เก่าจะยัง insert แถว mock จาก browser ได้ แต่ trigger
--     บังคับ graded_by_server=false → ไม่ถูกนับ (percentile ของรอบนั้นหายไปเฉยๆ)
-- Idempotent ทั้งไฟล์ (if not exists / create or replace / drop trigger if exists)
--
-- ที่มา: 20260926_mock_percentile_fix.sql §2 — correct_count มาจาก browser และ RLS
-- ของ mcq_sessions ให้ผู้ใช้ insert/update แถวตัวเองได้อิสระ ตอนนี้:
--   * หน้า mock ออก token HMAC ผูกผู้ใช้ + id ข้อสอบ + cohort (lib/mcq-mock-token.ts)
--     และไม่ส่ง correct_answer/คำอธิบายไป browser ระหว่างสอบ
--   * app/api/mcq/mock/submit ตรวจคำตอบกับ mcq_questions แล้ว insert ด้วย
--     service role พร้อม graded_by_server=true และ mock_token_hash (ใช้ได้ครั้งเดียว)
--   * trigger ด้านล่างกันผู้ใช้ตั้ง graded_by_server เอง หรือแก้คะแนน/cohort ของแถว
--     ที่ตรวจแล้วผ่าน PostgREST
--   * get_mock_percentile นับเฉพาะ graded_by_server = true ทั้งฝั่งผู้เรียกและ cohort
--     แถว mock เก่า (บันทึกจาก browser) จึงหยุดถูกนับ
--
-- คงนโยบาย RLS เดิมของ mcq_sessions ไว้ (flow practice ใน components/McqPractice.tsx
-- ยังสร้าง/อัปเดตแถวของตัวเองจาก browser) — trigger คุมแค่คอลัมน์ที่เกี่ยวกับ mock

alter table public.mcq_sessions
  add column if not exists graded_by_server boolean not null default false,
  add column if not exists mock_token_hash text;

-- token หนึ่งใบส่งได้ครั้งเดียว
create unique index if not exists uq_mcq_sessions_mock_token_hash
  on public.mcq_sessions (mock_token_hash)
  where mock_token_hash is not null;

-- cohort index เดิม (20260925_mock_percentile.sql) ครอบทุกแถว mock — ตัวนี้เล็กกว่า
-- และตรงกับเงื่อนไขใหม่ของ RPC
create index if not exists idx_mcq_sessions_mock_cohort_graded
  on public.mcq_sessions (audience, exam_type, board_specialty, total_questions, completed_at desc)
  where mode = 'mock' and completed_at is not null and graded_by_server;

-- ─── Trigger: เฉพาะ service role (หรือ role ฐานข้อมูลที่ไม่ใช่ผู้ใช้ PostgREST) ────
-- ที่ตั้ง graded_by_server / mock_token_hash และแก้คะแนนของแถวที่ตรวจแล้วได้
--
-- ผู้ใช้ผ่าน PostgREST = current_user 'authenticated' / 'anon' → ถูกบังคับ
-- service role (/api/mcq/mock/submit) = auth.role() 'service_role' → ผ่าน
-- SQL editor / migration (postgres) → ผ่าน (auth.role() เป็น null แต่ไม่ใช่ role ผู้ใช้)

create or replace function public.mcq_sessions_guard_server_grading()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  if coalesce(auth.role(), '') = 'service_role'
     or current_user not in ('authenticated', 'anon') then
    return new;
  end if;

  if tg_op = 'INSERT' then
    new.graded_by_server := false;
    new.mock_token_hash := null;
    return new;
  end if;

  -- UPDATE: ผู้ใช้เปลี่ยน flag/hash เองไม่ได้ (เงียบๆ คงค่าเดิม)
  new.graded_by_server := old.graded_by_server;
  new.mock_token_hash := old.mock_token_hash;

  -- แถวที่ server ตรวจแล้ว: คะแนน/cohort/เจ้าของ ห้ามแก้
  if old.graded_by_server and (
       new.user_id is distinct from old.user_id
    or new.mode is distinct from old.mode
    or new.audience is distinct from old.audience
    or new.exam_type is distinct from old.exam_type
    or new.board_specialty is distinct from old.board_specialty
    or new.board_section is distinct from old.board_section
    or new.subject_id is distinct from old.subject_id
    or new.total_questions is distinct from old.total_questions
    or new.correct_count is distinct from old.correct_count
    or new.time_limit_minutes is distinct from old.time_limit_minutes
    or new.completed_at is distinct from old.completed_at
    or new.created_at is distinct from old.created_at
  ) then
    raise exception 'mcq_sessions: server-graded mock rows are read-only'
      using errcode = '42501';
  end if;

  return new;
end;
$$;

revoke all on function public.mcq_sessions_guard_server_grading() from public, anon, authenticated;

drop trigger if exists trg_mcq_sessions_guard_server_grading on public.mcq_sessions;
create trigger trg_mcq_sessions_guard_server_grading
  before insert or update on public.mcq_sessions
  for each row execute function public.mcq_sessions_guard_server_grading();

-- ─── get_mock_percentile: นับเฉพาะแถวที่ server ตรวจ ──────────────────────────
-- เหมือน 20260926_mock_percentile_fix.sql ทุกอย่าง (signature, security definer,
-- search_path, ต้องเป็น session ของ auth.uid() เอง, คืนแค่ตัวเลขรวม, sample < 10
-- → below/tie null, ไม่นับตัวผู้เรียก, plausibility, latest-per-user แยก size/track)
-- เพิ่มแค่ graded_by_server ทั้งใน me และ pool

create or replace function public.get_mock_percentile(
  p_session_id uuid,
  p_days int default 365
)
returns table (scope text, sample int, below int, tie int)
language sql
stable
security definer
set search_path = public
as $$
  with me as (
    select s.audience, s.exam_type, s.board_specialty,
           s.total_questions, s.correct_count
    from public.mcq_sessions s
    where s.id = p_session_id
      and s.user_id = auth.uid()
      and s.mode = 'mock'
      and s.completed_at is not null
      and s.graded_by_server
      and s.total_questions between 1 and 300
      and s.correct_count between 0 and s.total_questions
  ),
  pool as (
    select o.user_id, o.total_questions, o.correct_count, o.completed_at
    from public.mcq_sessions o, me
    where o.mode = 'mock'
      and o.completed_at is not null
      and o.graded_by_server
      and o.completed_at >= now() - make_interval(days => greatest(p_days, 1))
      and o.total_questions between 1 and 300
      and o.correct_count between 0 and o.total_questions
      and o.user_id is not null
      and o.user_id <> auth.uid()
      and o.audience = me.audience
      and o.exam_type is not distinct from me.exam_type
      and o.board_specialty is not distinct from me.board_specialty
  ),
  latest_size as (
    select distinct on (p.user_id)
           p.total_questions, p.correct_count
    from pool p, me
    where p.total_questions = me.total_questions
    order by p.user_id, p.completed_at desc
  ),
  latest_track as (
    select distinct on (p.user_id)
           p.total_questions, p.correct_count
    from pool p
    order by p.user_id, p.completed_at desc
  ),
  agg as (
    select 'size'::text as scope,
           count(*)::int as sample,
           count(*) filter (where l.correct_count * me.total_questions
                                  < me.correct_count * l.total_questions)::int as below,
           count(*) filter (where l.correct_count * me.total_questions
                                  = me.correct_count * l.total_questions)::int as tie
    from latest_size l, me
    union all
    select 'track'::text,
           count(*)::int,
           count(*) filter (where l.correct_count * me.total_questions
                                  < me.correct_count * l.total_questions)::int,
           count(*) filter (where l.correct_count * me.total_questions
                                  = me.correct_count * l.total_questions)::int
    from latest_track l, me
  )
  select a.scope,
         a.sample,
         case when a.sample >= 10 then a.below end,
         case when a.sample >= 10 then a.tie end
  from agg a
  where exists (select 1 from me);
$$;

revoke all on function public.get_mock_percentile(uuid, int) from public, anon;
grant execute on function public.get_mock_percentile(uuid, int) to authenticated;
