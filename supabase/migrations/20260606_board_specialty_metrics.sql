-- ============================================
-- หมอรู้ (MorRoo) — Board exam transparency counts ("ความน่าเชื่อถือ")
--
-- ลูกค้าอยากเห็นตัวเลขจริงของแต่ละสาขา ก่อนตัดสินใจสมัคร:
--   • พร้อมฝึก (active)      — ข้อสอบที่ผ่าน QA แล้ว เปิดให้ฝึกได้เลย
--   • กำลังจัดทำ (pending)   — รอตรวจ (status='review') + คิวที่ AI กำลังสร้าง
--   • รวมทั้งหมด (projected) — active + review + ที่เหลือในคิว
--
-- ปัญหา: RLS ของ mcq_questions ให้ผู้ใช้ทั่วไปเห็นเฉพาะ status='active'
-- (mcq_schema.sql: "Active MCQ questions viewable by everyone") จึงนับ
-- ข้อ review ฝั่ง client ไม่ได้ — ใช้ SECURITY DEFINER function รวมยอดให้
-- ฝั่ง server โดยไม่เปิดเผยเนื้อหาข้อสอบ แล้ว grant ให้ anon/authenticated
-- (หน้า /board เป็น public + ISR revalidate 300s)
-- ============================================

create or replace function public.board_specialty_metrics()
returns table (
  specialty_slug   text,
  active_count     bigint,  -- status='active' (เปิดให้ฝึกแล้ว)
  review_count     bigint,  -- status='review' (สร้างแล้ว รอ QA)
  generating_count bigint   -- เป้าที่ยังเหลือในคิว queued/running
)
language sql
stable
security definer
set search_path = public
as $$
  with q as (
    select
      board_specialty as slug,
      count(*) filter (where status = 'active') as active_count,
      count(*) filter (where status = 'review') as review_count
    from public.mcq_questions
    where audience = 'board'
      and board_specialty is not null
    group by board_specialty
  ),
  g as (
    select
      specialty_slug as slug,
      sum(greatest(target_count - coalesce(generated_count, 0), 0)) as generating_count
    from public.board_gen_jobs
    where status in ('queued', 'running')
    group by specialty_slug
  )
  select
    sp.slug as specialty_slug,
    coalesce(q.active_count, 0)     as active_count,
    coalesce(q.review_count, 0)     as review_count,
    coalesce(g.generating_count, 0) as generating_count
  from public.board_specialties sp
  left join q on q.slug = sp.slug
  left join g on g.slug = sp.slug
  where sp.is_active = true;
$$;

grant execute on function public.board_specialty_metrics() to anon, authenticated;
