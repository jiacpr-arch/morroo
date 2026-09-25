-- Fixes for get_mock_percentile (20260925_mock_percentile.sql, already applied
-- — do not edit that file). Idempotent: create or replace + same signature,
-- grants re-stated. Deploy order doesn't matter; the client
-- (components/McqMock.tsx) is unchanged in how it calls the RPC.
--
-- 1) scope 'size' ตัดคนผิด: ของเดิมหา "mock ล่าสุดของแต่ละคน" ทั้ง track ก่อน แล้ว
--    ค่อยกรองจำนวนข้อ — คนที่เคยทำ 50 ข้อ แต่ mock ล่าสุดเป็น 100 ข้อ จะหายไปจาก
--    cohort 50 ข้อทั้งที่มีผลอยู่ ตอนนี้แยก latest-per-user เป็น 2 ชุด:
--      latest_size  = distinct on user_id เฉพาะแถวที่ total_questions เท่าผู้เรียก
--      latest_track = distinct on user_id ทั้ง track (เหมือนเดิม)
--
-- 2) ไม่เชื่อแถวที่คะแนนเป็นไปไม่ได้: mcq_sessions RLS ให้ผู้ใช้ insert/update แถว
--    ของตัวเองได้อิสระ (saveCompletedMockSession ส่ง correct_count จาก browser)
--    จึงตัดแถวที่ correct_count < 0, correct_count > total_questions,
--    total_questions <= 0 หรือ > 300 (mock ใหญ่สุดตอนนี้ = board 200 ข้อ) ทั้งฝั่ง
--    ผู้เรียก (คืน 0 แถว → UI ซ่อนการ์ด) และฝั่ง cohort
--
--    ข้อจำกัดที่ยังเหลือ (ตั้งใจไม่แก้ในรอบนี้): คะแนนที่ "เป็นไปได้" แต่ปลอม (เช่น
--    ส่ง 100/100 ทั้งที่ไม่ได้ทำ) ยังผ่าน — การย้ายไปบันทึกผ่าน API ฝั่ง server ที่
--    ตรวจคำตอบกับ mcq_questions.correct_answer ไม่ช่วยจริง เพราะ correct_answer ถูก
--    ส่งไปกับข้อสอบใน browser อยู่แล้ว (ส่งคำตอบถูกทุกข้อได้) และ RLS ยังเปิดให้
--    เขียน mcq_sessions ตรงๆ อยู่ ถ้าจะปิดจริงต้อง (ก) เลิกส่ง correct_answer ไป
--    client ระหว่างสอบ + (ข) ถอดสิทธิ์ insert/update mode='mock' จาก RLS ให้เขียน
--    ได้เฉพาะ service role ซึ่งกระทบ flow อื่นของ mcq_sessions ผลกระทบของการปลอมคือ
--    ขยับ percentile ของคนอื่นได้คนละไม่เกิน 1 แถว (นับ 1 คน = mock ล่าสุด 1 รอบ)
--
-- Security properties are unchanged: session must belong to auth.uid() and be
-- a submitted mock; returns aggregate counts only; sample < 10 → below/tie
-- null; the caller is excluded from the cohort.

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
      -- plausibility (see header §2)
      and s.total_questions between 1 and 300
      and s.correct_count between 0 and s.total_questions
  ),
  pool as (
    -- mock ที่ส่งแล้วของคนอื่นใน track เดียวกัน เฉพาะแถวที่คะแนนเป็นไปได้
    select o.user_id, o.total_questions, o.correct_count, o.completed_at
    from public.mcq_sessions o, me
    where o.mode = 'mock'
      and o.completed_at is not null
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
    -- mock ล่าสุดของแต่ละคน "ในขนาดเดียวกัน" — กรองขนาดก่อน distinct on
    select distinct on (p.user_id)
           p.total_questions, p.correct_count
    from pool p, me
    where p.total_questions = me.total_questions
    order by p.user_id, p.completed_at desc
  ),
  latest_track as (
    -- mock ล่าสุดของแต่ละคนทั้ง track (ทุกขนาด)
    select distinct on (p.user_id)
           p.total_questions, p.correct_count
    from pool p
    order by p.user_id, p.completed_at desc
  ),
  agg as (
    -- เทียบสัดส่วนด้วยการคูณไขว้ (a/b < c/d <=> a*d < c*b) เลี่ยง float
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
