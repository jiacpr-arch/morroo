-- ซ่อนเฉลย MCQ จาก anon/authenticated (PostgREST) + ตารางชุด Mock ที่กำลังสอบ
--
-- !!! DEPLOY ORDER: APPLY THIS MIGRATION ONLY AFTER THE APP CODE IS DEPLOYED !!!
--   app เก่าอ่าน mcq_questions ด้วย select("*") / select(... correct_answer ...)
--   ผ่าน client ของผู้ใช้ — ถ้าลง migration ก่อน หน้า /nl/practice, /board/*/practice,
--   /nl/mock, หน้า admin MCQ ฯลฯ จะพัง (permission denied for column ...)
--   app ใหม่: ผู้ใช้อ่านเฉพาะคอลัมน์สาธารณะ (lib/mcq-public.ts), เฉลยอ่านด้วย
--   service role ฝั่ง server เท่านั้น (/api/mcq/reveal, /api/mcq/mock/submit,
--   /api/ai/mcq-chat, /api/admin/mcq/questions, LINE daily quiz, /nl/try)
--   ส่วน mock_active_sets: app ใหม่ทนได้ถ้าตารางยังไม่มี (log แล้วปล่อยผ่าน)
-- Idempotent ทั้งไฟล์
--
-- ที่มา: RLS "Active MCQ questions viewable by everyone" (status = 'active') ให้
-- anon/authenticated อ่านได้ทุกคอลัมน์ → ใครก็ดึง correct_answer ทั้งคลังผ่าน REST
-- ได้ รวมถึงระหว่างสอบ Mock ที่ตอนนี้ server เป็นคนตรวจ (20260926_mock_server_graded.sql)
--
-- คอลัมน์ที่ซ่อน: correct_answer, explanation, detailed_explanation, ai_notes
-- (choices เก็บแค่ {label, text} — ไม่มีธง is_correct ในข้อมูลจริง ณ 2026-09-25 จึงเปิดได้)
--
-- ไม่แตะสิทธิ์ insert/update/delete (RLS "Admins can manage mcq_questions" คุมอยู่)
-- — แต่ app ใหม่ย้ายการเขียนของ admin ไป /api/admin/mcq/questions (service role)
-- แล้ว เพราะ update/insert ที่ return คอลัมน์เฉลย หรือ filter ด้วยคอลัมน์เฉลย
-- จาก client ของผู้ใช้จะโดนปฏิเสธหลัง migration นี้

-- ─── 1. mcq_questions: column-level SELECT ──────────────────────────────────

revoke select on table public.mcq_questions from anon, authenticated;

grant select (
  id,
  subject_id,
  exam_type,
  exam_source,
  question_number,
  scenario,
  choices,
  difficulty,
  is_ai_enhanced,
  status,
  created_at,
  difficulty_level,
  topic,
  audience,
  board_specialty,
  board_subspecialty,
  board_section,
  board_topic,
  board_age_group,
  board_level,
  reference_source
) on public.mcq_questions to anon, authenticated;

-- service_role / postgres คงสิทธิ์เต็ม (ไม่ได้แตะ)
-- คอลัมน์ใหม่ที่เพิ่มในอนาคตจะไม่ถูก grant อัตโนมัติ — ถ้าเป็นข้อมูลสาธารณะให้
-- grant select (<col>) เพิ่ม และเพิ่มใน MCQ_PUBLIC_COLUMN_LIST (lib/mcq-public.ts)

-- ─── 2. mock_active_sets: ชุด Mock ที่ออก token แล้วยังไม่ส่ง ─────────────────
-- เขียน/อ่านด้วย service role เท่านั้น (lib/mcq-active-mock.ts):
--   * หน้า mock ออก token → insert (question_ids ตามลำดับใน token)
--   * /api/mcq/mock/submit → delete ตาม token_hash
--   * /api/mcq/reveal, /api/ai/mcq-chat, GET /api/mcq/comments → ปฏิเสธข้อที่อยู่ใน
--     ชุดที่ยังไม่หมดอายุ (expires_at = ออก token + เวลาสอบ + grace 10 นาที)

create table if not exists public.mock_active_sets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  question_ids uuid[] not null,
  token_hash text not null unique,
  expires_at timestamptz not null,
  created_at timestamptz not null default now()
);

create index if not exists idx_mock_active_sets_user_expires
  on public.mock_active_sets (user_id, expires_at);

alter table public.mock_active_sets enable row level security;
-- ไม่มี policy = anon/authenticated ทำอะไรไม่ได้เลย; ตัด grant ทิ้งด้วยอีกชั้น
revoke all on table public.mock_active_sets from anon, authenticated;
grant all on table public.mock_active_sets to service_role;
