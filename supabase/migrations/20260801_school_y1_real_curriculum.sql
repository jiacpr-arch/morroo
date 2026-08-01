-- ============================================
-- หมอรู้ (MorRoo) — School Mode: Year 1 REAL curriculum (FMMD/พศพบ)
-- ============================================
-- เปลี่ยนโครงวิชาปี 1 จากชุด generic (Cell Biology/Biochem/Anatomy... ผูก
-- system 'foundation') มาเป็น "หลักสูตรจริง" ตามรหัสวิชา FMMD / พศพบ
-- โดยเก็บ รหัสวิชา (code), เทอม (term) และหน่วยกิต (credits) ไว้ด้วย
-- เพื่อให้แสดงบนการ์ดวิชาและแยกเทอม 1/2 ได้
--
-- ชุดข้อมูลนี้ = ปี 1 "เทอม 1" (10 วิชา รวม 18 หน่วยกิต) ตามที่หลักสูตรกำหนด
-- เทอม 2 (และปีอื่น ๆ) เติมทีหลังด้วย migration/แอดมินได้

-- ----------------------------------------------
-- 1. เพิ่มคอลัมน์ metadata ของรายวิชา (nullable — ไม่กระทบข้อมูลเดิม)
-- ----------------------------------------------
alter table public.school_topics
  add column if not exists code text,        -- รหัสวิชาอังกฤษ เช่น 'FMMD 1108'
  add column if not exists code_th text,      -- รหัสวิชาไทย เช่น 'พศพบ 1108'
  add column if not exists term smallint,     -- ภาคการศึกษา 1/2 (3 = ภาคฤดูร้อน)
  add column if not exists credits text;      -- หน่วยกิต เช่น '2 (2-0-4)' (ทฤษฎี-ปฏิบัติ-ค้นคว้า)

alter table public.school_topics
  drop constraint if exists school_topics_term_check;
alter table public.school_topics
  add constraint school_topics_term_check
  check (term is null or term between 1 and 3);

create index if not exists idx_school_topics_year_term
  on public.school_topics(year, term);

-- ----------------------------------------------
-- 2. ลบวิชา generic ของปี 1 (แทนที่ด้วยหลักสูตรจริง)
-- ----------------------------------------------
-- หมายเหตุ: การลบ topic จะ cascade ลบ flashcards/lessons/quizzes/books ที่ผูกอยู่
-- ทำก่อนเริ่มลงเนื้อหาจริง จึงยังไม่มีข้อมูลนักเรียนหาย
delete from public.school_topics
where year = 1
  and slug in (
    'cell-biology', 'biochemistry', 'molecular-genetics', 'gross-anatomy',
    'histology', 'embryology', 'physiology', 'microbiology', 'immunology',
    'pharmacology-basics', 'medical-ethics', 'epidemiology-biostats',
    'community-medicine'
  );

-- ----------------------------------------------
-- 3. Seed หลักสูตรจริงปี 1 เทอม 1 (ผูก system 'foundation')
-- ----------------------------------------------
-- idempotent: รันซ้ำได้ (on conflict → อัปเดต code/term/credits/ชื่อ)
insert into public.school_topics
  (system_id, year, term, slug, code, code_th, name_th, name_en, credits, summary, sort_order)
select s.id, 1, t.term, t.slug, t.code, t.code_th, t.name_th, t.name_en, t.credits, t.summary, t.sort_order
from public.school_systems s
cross join (values
  (1, 'human-life', 'FMMD 1108', 'พศพบ 1108',
   'ชีวิตมนุษย์', 'Human Life', '2 (2-0-4)',
   'พัฒนาการและวงจรชีวิตมนุษย์ มิติกาย จิต สังคม และการเปลี่ยนแปลงตามช่วงวัย', 10),
  (1, 'doctor-society', 'FMMD 1109', 'พศพบ 1109',
   'แพทย์ สังคม และความรับผิดชอบต่อสังคม', 'Doctor, Society and Social Responsibilities', '2 (2-0-4)',
   'บทบาทของแพทย์ต่อสังคม จริยธรรมวิชาชีพ และความรับผิดชอบต่อชุมชนและส่วนรวม', 20),
  (1, 'health-system', 'FMMD 1111', 'พศพบ 1111',
   'ระบบสุขภาพและการดูแลสุขภาพ', 'Health System and Health Care Practice', '2 (2-0-4)',
   'โครงสร้างระบบสุขภาพ การจัดบริการสุขภาพ และหลักการดูแลสุขภาพระดับต่าง ๆ', 30),
  (1, 'medical-terminology', 'FMMD 1101', 'พศพบ 1101',
   'บทนำ คำศัพท์ทางการแพทย์', 'Introduction to Medical Terminology', '1 (1-0-2)',
   'รากศัพท์ คำนำหน้า คำต่อท้าย และการอ่าน-เขียนคำศัพท์ทางการแพทย์เบื้องต้น', 40),
  (1, 'life-skills', 'FMMD 1110', 'พศพบ 1110',
   'การพัฒนาทักษะชีวิตด้วยวิศวกรสังคม', 'Developing Life Skills by Social Engineers', '2 (2-0-4)',
   'ทักษะชีวิต การทำงานเป็นทีม และการแก้ปัญหาชุมชนด้วยแนวคิดวิศวกรสังคม', 50),
  (1, 'math-physics', 'FMMD 1103', 'พศพบ 1103',
   'คณิตศาสตร์และฟิสิกส์สำหรับวิทยาศาสตร์สุขภาพ', 'Mathematics and Physics for Health Science', '2 (2-0-4)',
   'หลักคณิตศาสตร์และฟิสิกส์ที่จำเป็นต่อการเรียนวิทยาศาสตร์สุขภาพและการแพทย์', 60),
  (1, 'chemistry', 'FMMD 1104', 'พศพบ 1104',
   'เคมีสำหรับวิทยาศาสตร์สุขภาพ', 'Chemistry for Health Science', '2 (2-0-4)',
   'เคมีทั่วไปและเคมีอินทรีย์พื้นฐานที่เกี่ยวข้องกับสิ่งมีชีวิตและการแพทย์', 70),
  (1, 'digital-technology', 'FMMD 1105', 'พศพบ 1105',
   'เทคโนโลยีดิจิทัลขั้นแนะนำ', 'Introduction to Digital Technology', '1 (1-0-2)',
   'พื้นฐานเทคโนโลยีดิจิทัลและการประยุกต์ใช้ในงานด้านสุขภาพ', 80),
  (1, 'research-methodology', 'FMMD 1501', 'พศพบ 1501',
   'ระเบียบวิธีวิจัย', 'Research Methodology', '1 (1-0-2)',
   'หลักการตั้งคำถามวิจัย การออกแบบการศึกษา และระเบียบวิธีวิจัยทางการแพทย์เบื้องต้น', 90),
  (1, 'cell-biology', 'FMMD 1201', 'พศพบ 1201',
   'ชีววิทยาของเซลล์', 'Cell Biology', '3 (2-3-4)',
   'โครงสร้างและหน้าที่ของเซลล์ — organelles, เยื่อหุ้มเซลล์, การส่งสัญญาณ, วัฏจักรเซลล์', 100)
) as t(term, slug, code, code_th, name_th, name_en, credits, summary, sort_order)
where s.slug = 'foundation'
on conflict (system_id, year, slug) do update set
  term       = excluded.term,
  code       = excluded.code,
  code_th    = excluded.code_th,
  name_th    = excluded.name_th,
  name_en    = excluded.name_en,
  credits    = excluded.credits,
  summary    = excluded.summary,
  sort_order = excluded.sort_order;
