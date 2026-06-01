-- ============================================
-- หมอรู้ (MorRoo) — School Mode: Year 1 curriculum structure
-- ============================================
-- เติมโครงหลักสูตรปี 1 (พื้นฐานวิทยาศาสตร์การแพทย์ / pre-clinical)
-- ให้หน้า /school/1 แสดงว่า "ปี 1 เรียนอะไรบ้าง"
-- หัวข้อทั้งหมดผูกกับระบบ 'foundation' ที่ seed ไว้แล้วใน 20260531_school_schema.sql
-- เป็นโครงมาตรฐานที่แอดมินแก้เพิ่ม-ลบทีหลังได้ (idempotent ด้วย on conflict do nothing)

insert into public.school_topics (system_id, year, slug, name_th, name_en, summary, sort_order)
select s.id, 1, t.slug, t.name_th, t.name_en, t.summary, t.sort_order
from public.school_systems s
cross join (values
  ('cell-biology',
   'ชีววิทยาของเซลล์', 'Cell Biology',
   'โครงสร้างและหน้าที่ของเซลล์ — organelles, เยื่อหุ้มเซลล์, การส่งสัญญาณ, วัฏจักรเซลล์', 0),
  ('biochemistry',
   'ชีวเคมีการแพทย์', 'Medical Biochemistry',
   'ชีวโมเลกุล เอนไซม์ และเมแทบอลิซึมของคาร์โบไฮเดรต ไขมัน โปรตีน', 10),
  ('molecular-genetics',
   'อณูชีววิทยาและพันธุศาสตร์การแพทย์', 'Molecular Biology & Genetics',
   'DNA/RNA การแสดงออกของยีน การถ่ายทอดทางพันธุกรรม และโรคทางพันธุกรรม', 20),
  ('gross-anatomy',
   'มหกายวิภาคศาสตร์', 'Gross Anatomy',
   'โครงสร้างร่างกายตามภูมิภาค ระบบกล้ามเนื้อ กระดูก และเส้นประสาทพื้นฐาน', 30),
  ('histology',
   'จุลกายวิภาคศาสตร์/เนื้อเยื่อวิทยา', 'Histology',
   'เนื้อเยื่อพื้นฐาน 4 ชนิด และโครงสร้างระดับจุลภาคของอวัยวะ', 40),
  ('embryology',
   'คัพภวิทยา', 'Embryology',
   'การเจริญของตัวอ่อนตั้งแต่ปฏิสนธิจนถึงการสร้างอวัยวะ', 50),
  ('physiology',
   'สรีรวิทยาพื้นฐาน', 'General Physiology',
   'หลักการ homeostasis การขนส่งผ่านเยื่อหุ้มเซลล์ ศักย์ไฟฟ้า และการทำงานของเซลล์', 60),
  ('microbiology',
   'จุลชีววิทยาและปรสิตวิทยาเบื้องต้น', 'Microbiology & Parasitology',
   'แบคทีเรีย ไวรัส เชื้อรา และปรสิตที่ก่อโรคในมนุษย์เบื้องต้น', 70),
  ('immunology',
   'ภูมิคุ้มกันวิทยาเบื้องต้น', 'Basic Immunology',
   'ระบบภูมิคุ้มกันโดยกำเนิดและแบบจำเพาะ เซลล์และกลไกการตอบสนอง', 80),
  ('pharmacology-basics',
   'เภสัชวิทยาพื้นฐาน', 'Basic Pharmacology',
   'หลักเภสัชจลนศาสตร์และเภสัชพลศาสตร์ การออกฤทธิ์ของยาเบื้องต้น', 90),
  ('medical-ethics',
   'เวชจริยศาสตร์และวิชาชีพแพทย์', 'Medical Ethics & Professionalism',
   'หลักจริยธรรมการแพทย์ การสื่อสาร และความเป็นวิชาชีพแพทย์', 100),
  ('epidemiology-biostats',
   'ระบาดวิทยาและชีวสถิติเบื้องต้น', 'Epidemiology & Biostatistics',
   'หลักการศึกษาทางระบาดวิทยาและการวิเคราะห์ข้อมูลทางการแพทย์เบื้องต้น', 110),
  ('community-medicine',
   'เวชศาสตร์ชุมชนเบื้องต้น', 'Introduction to Community Medicine',
   'ระบบสุขภาพ การสร้างเสริมสุขภาพ และการดูแลสุขภาพระดับชุมชน', 120)
) as t(slug, name_th, name_en, summary, sort_order)
where s.slug = 'foundation'
on conflict (system_id, year, slug) do nothing;
