-- ============================================
-- หมอรู้ (MorRoo) — School Mode: หลักสูตรปี 1 ตามรายวิชาจริง (FMMD / พศพบ)
-- ============================================
-- แทนโครงปี 1 แบบทั่วไปใน 20260601_school_y1_curriculum.sql ด้วยรายวิชาจริง
-- ตามเล่มหลักสูตร: 10 รายวิชา รวม 18 หน่วยกิต
--
-- 'cell-biology' (FMMD 1201) ใช้ slug เดิม จึงเก็บบทเรียน/flashcard/quiz/หนังสือ
-- ที่มีอยู่แล้วไว้ครบ — แค่เติมรหัสวิชาและหน่วยกิตให้
--
-- idempotent: รันซ้ำได้ (upsert + ลบเฉพาะวิชาเปล่าที่ไม่อยู่ในหลักสูตร)

-- ----------------------------------------------
-- 1. รหัสวิชา + หน่วยกิต
-- ----------------------------------------------
alter table public.school_topics add column if not exists code text;
alter table public.school_topics add column if not exists code_th text;
alter table public.school_topics add column if not exists credits smallint;
-- credit_hours = (ทฤษฎี-ปฏิบัติ-ค้นคว้า) เช่น '2-3-4'
alter table public.school_topics add column if not exists credit_hours text;

create unique index if not exists idx_school_topics_code
  on public.school_topics(code)
  where code is not null;

-- ----------------------------------------------
-- 2. รายวิชาปี 1 (เรียงตามเล่มหลักสูตร)
-- ----------------------------------------------
insert into public.school_topics
  (system_id, year, slug, name_th, name_en, summary, sort_order,
   code, code_th, credits, credit_hours)
select
  s.id, 1, t.slug, t.name_th, t.name_en, t.summary, t.sort_order,
  t.code, t.code_th, t.credits::smallint, t.credit_hours
from public.school_systems s
cross join (values
  ('human-life',
   'ชีวิตมนุษย์', 'Human Life',
   'ภาพรวมชีวิตมนุษย์ตั้งแต่ระดับเซลล์ถึงระดับบุคคล พัฒนาการและวงจรชีวิต',
   0, 'FMMD 1108', 'พศพบ 1108', 2, '2-0-4'),
  ('doctor-society',
   'แพทย์ สังคม และความรับผิดชอบต่อสังคม', 'Doctor, Society and Social Responsibilities',
   'บทบาทของแพทย์ต่อสังคม จริยธรรมวิชาชีพ และความรับผิดชอบต่อชุมชน',
   10, 'FMMD 1109', 'พศพบ 1109', 2, '2-0-4'),
  ('health-system',
   'ระบบสุขภาพและการดูแลสุขภาพ', 'Health System and Health Care Practice',
   'โครงสร้างระบบสุขภาพไทย การส่งต่อ หลักประกันสุขภาพ และการดูแลสุขภาพระดับปฐมภูมิ',
   20, 'FMMD 1111', 'พศพบ 1111', 2, '2-0-4'),
  ('medical-terminology',
   'บทนำ คำศัพท์ทางการแพทย์', 'Introduction to Medical Terminology',
   'รากศัพท์ คำอุปสรรค คำปัจจัย และการอ่าน-เขียนศัพท์แพทย์อย่างเป็นระบบ',
   30, 'FMMD 1101', 'พศพบ 1101', 1, '1-0-2'),
  ('life-skills-social-engineer',
   'การพัฒนาทักษะชีวิตด้วยวิศวกรสังคม', 'Developing Life Skills by Social Engineers',
   'ทักษะคิดวิเคราะห์ สื่อสาร ทำงานเป็นทีม และการแก้ปัญหาชุมชนแบบวิศวกรสังคม',
   40, 'FMMD 1110', 'พศพบ 1110', 2, '2-0-4'),
  ('math-physics-health',
   'คณิตศาสตร์และฟิสิกส์สำหรับวิทยาศาสตร์สุขภาพ', 'Mathematics and Physics for Health Science',
   'คณิตศาสตร์และฟิสิกส์พื้นฐานที่ใช้อธิบายปรากฏการณ์ทางการแพทย์ เช่น กลศาสตร์ ของไหล ไฟฟ้า รังสี',
   50, 'FMMD 1103', 'พศพบ 1103', 2, '2-0-4'),
  ('chemistry-health',
   'เคมีสำหรับวิทยาศาสตร์สุขภาพ', 'Chemistry for Health Science',
   'เคมีทั่วไปและเคมีอินทรีย์พื้นฐาน สารละลาย กรด-เบส และหมู่ฟังก์ชันที่พบในชีวโมเลกุล',
   60, 'FMMD 1104', 'พศพบ 1104', 2, '2-0-4'),
  ('digital-technology',
   'เทคโนโลยีดิจิทัลขั้นแนะนำ', 'Introduction to Digital Technology',
   'การใช้เทคโนโลยีดิจิทัลและข้อมูลสารสนเทศทางการแพทย์เบื้องต้น',
   70, 'FMMD 1105', 'พศพบ 1105', 1, '1-0-2'),
  ('research-methodology',
   'ระเบียบวิธีวิจัย', 'Research Methodology',
   'ขั้นตอนการทำวิจัย การตั้งคำถาม การออกแบบการศึกษา และการอ่านงานวิจัยทางการแพทย์',
   80, 'FMMD 1501', 'พศพบ 1501', 1, '1-0-2'),
  ('cell-biology',
   'ชีววิทยาของเซลล์', 'Cell Biology',
   'โครงสร้างและหน้าที่ของเซลล์ — organelles, เยื่อหุ้มเซลล์, การส่งสัญญาณ, วัฏจักรเซลล์',
   90, 'FMMD 1201', 'พศพบ 1201', 3, '2-3-4')
) as t(slug, name_th, name_en, summary, sort_order, code, code_th, credits, credit_hours)
where s.slug = 'foundation'
on conflict (system_id, year, slug) do update set
  name_th      = excluded.name_th,
  name_en      = excluded.name_en,
  summary      = excluded.summary,
  sort_order   = excluded.sort_order,
  code         = excluded.code,
  code_th      = excluded.code_th,
  credits      = excluded.credits,
  credit_hours = excluded.credit_hours;

-- ----------------------------------------------
-- 3. เก็บกวาดวิชาปี 1 ชุดเดิมที่ไม่อยู่ในหลักสูตรนี้
-- ----------------------------------------------
-- ลบเฉพาะวิชาที่ "ยังไม่มีเนื้อหาและยังไม่มีใครเรียน" เท่านั้น — ถ้ามี lesson/
-- flashcard/quiz/book/question/session ผูกอยู่จะข้ามไป ไม่ทำข้อมูลหาย
-- (ค่อยย้ายไปชั้นปีที่ถูกต้องเอง)
delete from public.school_topics t
using public.school_systems s
where t.system_id = s.id
  and s.slug = 'foundation'
  and t.year = 1
  and t.slug not in (
    'human-life', 'doctor-society', 'health-system', 'medical-terminology',
    'life-skills-social-engineer', 'math-physics-health', 'chemistry-health',
    'digital-technology', 'research-methodology', 'cell-biology'
  )
  and not exists (select 1 from public.school_lessons    x where x.topic_id = t.id)
  and not exists (select 1 from public.school_flashcards x where x.topic_id = t.id)
  and not exists (select 1 from public.school_quizzes    x where x.topic_id = t.id)
  and not exists (select 1 from public.school_books      x where x.topic_id = t.id)
  and not exists (select 1 from public.school_questions  x where x.topic_id = t.id)
  and not exists (select 1 from public.school_sessions   x where x.topic_id = t.id);
