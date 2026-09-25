-- DEPLOY ORDER: migration first is safest, but either order works —
-- components/McqMock.tsx treats a missing/erroring RPC as "no rank data" and
-- the results screen renders without the percentile card. Idempotent
-- (create-if-not-exists / create-or-replace throughout).
--
-- "คุณทำคะแนนได้ดีกว่า X% ของผู้ที่ทำชุดนี้" ท้าย Mock Exam (/nl/mock,
-- /board/[specialty]/mock)
--
-- กลุ่มเทียบ (cohort): ข้อสอบ mock สุ่มใหม่ทุกรอบ ไม่มี "ชุด" ตายตัว จึงเทียบกับ
-- คนที่ทำ mock ประเภทเดียวกัน:
--   scope 'size'  = audience + exam_type (NL) / board_specialty (board) + จำนวนข้อเท่ากัน
--   scope 'track' = audience + exam_type / board_specialty ทุกขนาด (fallback ตอนตัวอย่างบาง)
-- เทียบด้วยสัดส่วนถูก (correct/total) ไม่ใช่จำนวนข้อดิบ เพราะ board mock จำนวนข้อ
-- ขยับตามคลังข้อสอบที่มี (sampleBoardMock) และ scope track รวมหลายขนาด
--
-- นับ 1 คน = 1 แถว: ใช้ mock ล่าสุดของแต่ละคน (distinct on user_id) ไม่งั้นคนที่
-- สอบซ้ำ 20 รอบจะถ่วง cohort และไม่นับตัวผู้เรียกเอง (เทียบกับ "คนอื่น")
--
-- ความปลอดภัย (SECURITY DEFINER เพราะ RLS ของ mcq_sessions ให้เห็นแค่ของตัวเอง):
--   * รับแค่ p_session_id — ต้องเป็น session ของ auth.uid() เองที่เป็น mock และส่งแล้ว
--     คะแนนกับ cohort ดึงจากแถวนั้น ผู้เรียกกำหนดคะแนนหรือกลุ่มเองไม่ได้
--   * คืนแค่ตัวเลขรวม (sample/below/tie) ไม่มี user_id หรือคะแนนรายคน
--   * sample < 10 คืน below/tie เป็น null — กันการไล่เดาคะแนนของคนไม่กี่คน
--     (เช่น cohort มีอีกแค่ 1 คน below=1 ก็รู้คะแนนเขาทันที)

create index if not exists idx_mcq_sessions_mock_cohort
  on public.mcq_sessions (audience, exam_type, board_specialty, total_questions, completed_at desc)
  where mode = 'mock' and completed_at is not null;

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
      and s.total_questions > 0
  ),
  latest as (
    -- mock ล่าสุดของแต่ละคน (ยกเว้นตัวเอง) ใน track เดียวกัน
    select distinct on (o.user_id)
           o.total_questions, o.correct_count
    from public.mcq_sessions o, me
    where o.mode = 'mock'
      and o.completed_at is not null
      and o.completed_at >= now() - make_interval(days => greatest(p_days, 1))
      and o.total_questions > 0
      and o.user_id is not null
      and o.user_id <> auth.uid()
      and o.audience = me.audience
      and o.exam_type is not distinct from me.exam_type
      and o.board_specialty is not distinct from me.board_specialty
    order by o.user_id, o.completed_at desc
  ),
  agg as (
    -- เทียบสัดส่วนด้วยการคูณไขว้ (a/b < c/d <=> a*d < c*b) เลี่ยง float
    select 'size'::text as scope,
           count(*)::int as sample,
           count(*) filter (where l.correct_count * me.total_questions
                                  < me.correct_count * l.total_questions)::int as below,
           count(*) filter (where l.correct_count * me.total_questions
                                  = me.correct_count * l.total_questions)::int as tie
    from latest l, me
    where l.total_questions = me.total_questions
    union all
    select 'track'::text,
           count(*)::int,
           count(*) filter (where l.correct_count * me.total_questions
                                  < me.correct_count * l.total_questions)::int,
           count(*) filter (where l.correct_count * me.total_questions
                                  = me.correct_count * l.total_questions)::int
    from latest l, me
  )
  select a.scope,
         a.sample,
         case when a.sample >= 10 then a.below end,
         case when a.sample >= 10 then a.tie end
  from agg a
  where exists (select 1 from me);
$$;

-- Callable by signed-in users only: the function itself checks the session
-- belongs to auth.uid(), so a direct PostgREST call can't read anyone else's
-- rows. Guests (anon) never have a mock session to rank.
revoke all on function public.get_mock_percentile(uuid, int) from public, anon;
grant execute on function public.get_mock_percentile(uuid, int) to authenticated;
