-- ใส่รูปประกอบชุดนำร่องให้วิชา FMMD 1201 ชีววิทยาของเซลล์ (3 บท)
-- รูปอยู่ในรีโปที่ public/lesson-images/school/cell-biology/ — รันหลัง deploy โค้ดที่มีไฟล์เหล่านี้แล้วเท่านั้น
-- Idempotent: บทที่มีรูปชุดนี้แล้วจะไม่ถูกแก้ซ้ำ · สำรอง body_md เดิมไว้ที่ archive.school_lessons_figures_20260920

create schema if not exists archive;
revoke all on schema archive from anon, authenticated;

create table if not exists archive.school_lessons_figures_20260920 as
  select l.* from public.school_lessons l
  join public.school_topics t on t.id = l.topic_id
  where t.code = 'FMMD 1201';

-- ─── บทที่ 1: Concepts in Cell Biology ────────────────────────────────────────
update public.school_lessons set body_md =
  replace(replace(replace(replace(body_md,
    E'# Concepts in Cell Biology: จากทฤษฎีเซลล์ถึง Nucleus\n\n',
    E'# Concepts in Cell Biology: จากทฤษฎีเซลล์ถึง Nucleus\n\n![เซลล์ยูคาริโอตแบบวาดง่าย มีนิวเคลียส ไมโทคอนเดรีย และ ER](/lesson-images/school/cell-biology/cellbio-01-hero.svg "บทนี้พาไปรู้จักหน่วยที่เล็กที่สุดของชีวิต ตั้งแต่ทฤษฎีเซลล์จนถึงศูนย์ควบคุมอย่างนิวเคลียส")\n\n'),
    E'\n\n**ตารางเปรียบเทียบที่ต้องจำ:**',
    E'\n\n![แผนภาพเทียบ prokaryote กับ eukaryote: ขนาด DNA ribosome และการแบ่งตัว](/lesson-images/school/cell-biology/cellbio-01-p1-prokaryote-vs-eukaryote.svg "ดู 4 จุดต่างที่ออกสอบบ่อย: ขนาด รูปแบบ DNA ขนาด ribosome (70S/80S) และวิธีแบ่งตัว")\n\n**ตารางเปรียบเทียบที่ต้องจำ:**'),
    E'### Stem Cells: แบ่งตามความสามารถในการ differentiate\n\n',
    E'### Stem Cells: แบ่งตามความสามารถในการ differentiate\n\n![บันได 5 ขั้นของ stem cell potency จาก totipotent ถึง unipotent](/lesson-images/school/cell-biology/cellbio-01-p2-stem-cell-potency.svg "ไล่จากกว้างสุดไปแคบสุด: Toti → Pluri → Multi → Oligo → Uni พร้อมตัวอย่างเซลล์ของแต่ละขั้น")\n\n'),
    E'### Nuclear Components ทั้ง 7 อย่าง\n\n',
    E'### Nuclear Components ทั้ง 7 อย่าง\n\n![ภาพตัดขวางนิวเคลียส แสดงเยื่อหุ้ม 2 ชั้น รูนิวเคลียส นิวคลีโอลัส และ chromatin](/lesson-images/school/cell-biology/cellbio-01-p3-nucleus.svg "จำตำแหน่งของแต่ละส่วนจากภาพ แล้วค่อยอ่านหน้าที่ทีละข้อด้านล่าง")\n\n')
where id = 'ffec487b-e135-4274-a3b3-c0558189be93'
  and body_md not like '%cell-biology/cellbio-01-%';

-- ─── บทที่ 2: Organelles I ────────────────────────────────────────────────────
update public.school_lessons set body_md =
  replace(replace(replace(replace(body_md,
    E'# โครงสร้างและหน้าที่ของ Organelles I\n\n',
    E'# โครงสร้างและหน้าที่ของ Organelles I\n\n![ไมโทคอนเดรียแบบวาดง่ายกับถุงเวสิเคิลและกอลจิ](/lesson-images/school/cell-biology/cellbio-02-hero.svg "บทนี้ว่าด้วยโรงไฟฟ้า ระบบรับส่งของ และโรงงานแปรรูปโปรตีนของเซลล์")\n\n'),
    E'Mitochondrion ถูกล้อมรอบด้วย **2 membranes** และมี **2 internal compartments** ได้แก่\n\n',
    E'Mitochondrion ถูกล้อมรอบด้วย **2 membranes** และมี **2 internal compartments** ได้แก่\n\n![ภาพตัดขวางไมโทคอนเดรีย แสดงเยื่อ 2 ชั้น matrix และ 3 ขั้นของ cellular respiration](/lesson-images/school/cell-biology/cellbio-02-p1-mitochondrion-respiration.svg "จับคู่ให้ได้ว่าแต่ละขั้นของ respiration เกิดที่ชั้นไหน: cytosol → matrix → inner membrane")\n\n'),
    E'Endosomes ทำหน้าที่ปรับ protein บน membrane ของเซลล์ มี 3 ประเภท:\n\n',
    E'Endosomes ทำหน้าที่ปรับ protein บน membrane ของเซลล์ มี 3 ประเภท:\n\n![เส้นทาง LDL receptor จาก coated pit ผ่าน early endosome แยกไป recycling และ lysosome](/lesson-images/school/cell-biology/cellbio-02-p2-endosome-pathway.svg "จุดสำคัญคือ early endosome แยก receptor (กลับไปใช้ใหม่) ออกจาก ligand (ส่งไปย่อยที่ lysosome)")\n\n'),
    E'**เส้นทางขนส่งจาก ER → Golgi:**\n',
    E'**เส้นทางขนส่งจาก ER → Golgi:**\n\n![ท่อส่งโปรตีนจาก ER ผ่าน COPII ไป Golgi ถึง trans-Golgi network และ COPI ส่งกลับ](/lesson-images/school/cell-biology/cellbio-02-p3-er-golgi-transport.svg "ไปข้างหน้าใช้ COPII ย้อนกลับใช้ COPI และ TGN เป็นจุดคัดแยกปลายทาง")\n\n')
where id = '5705ca70-489c-4de0-a210-88039729b12f'
  and body_md not like '%cell-biology/cellbio-02-%';

-- ─── บทที่ 3: Peroxisome, Lysosome, Vacuole, Autophagosome ────────────────────
update public.school_lessons set body_md =
  replace(replace(replace(replace(body_md,
    E'# Peroxisome, Lysosome, Vacuole และ Autophagosome\n\n',
    E'# Peroxisome, Lysosome, Vacuole และ Autophagosome\n\n![ไลโซโซมและ autophagosome เยื่อ 2 ชั้นกำลังโอบไมโทคอนเดรียเก่า](/lesson-images/school/cell-biology/cellbio-03-hero.svg "บทนี้ว่าด้วยระบบกำจัดของเสียและรีไซเคิลของเซลล์ และโรคที่เกิดเมื่อระบบนี้พัง")\n\n'),
    E'### หน้าที่หลักของ Peroxisome\n\n',
    E'### หน้าที่หลักของ Peroxisome\n\n![peroxisome เยื่อชั้นเดียว แสดงปฏิกิริยา catalase และ β-oxidation พร้อมโรค 3 โรค](/lesson-images/school/cell-biology/cellbio-03-p1-peroxisome.svg "จำ 2 หน้าที่ (กำจัด H₂O₂, ย่อย VLCFA) แล้วโยงไปโรคที่พังคนละจุด: Zellweger, ALD, Refsum")\n\n'),
    E'นี่คือ pathway ที่สำคัญมาก ต้องเข้าใจ step by step:\n\n',
    E'นี่คือ pathway ที่สำคัญมาก ต้องเข้าใจ step by step:\n\n![4 สถานีของ M6P pathway จาก cis-Golgi ถึง lysosome พร้อม safety lock เรื่อง pH](/lesson-images/school/cell-biology/cellbio-03-p2-m6p-pathway.svg "ไล่ 4 สถานีตามลูกศร แล้วดูว่า I-cell disease พังที่สถานีแรก")\n\n'),
    E'**Autophagy** คือกระบวนการที่เซลล์ย่อยสลายส่วนประกอบของตัวเอง มี 4 ขั้นตอน:\n\n',
    E'**Autophagy** คือกระบวนการที่เซลล์ย่อยสลายส่วนประกอบของตัวเอง มี 4 ขั้นตอน:\n\n![4 ขั้นของ autophagy: โอบ ปิด รวมกับ lysosome และย่อย](/lesson-images/school/cell-biology/cellbio-03-p3-autophagy.svg "สังเกตว่า autophagosome มีเยื่อ 2 ชั้น และเยื่อชั้นในถูกย่อยไปพร้อมของข้างใน")\n\n')
where id = '2c73cfb9-ad71-46ec-9b71-82da8c11ce49'
  and body_md not like '%cell-biology/cellbio-03-%';

-- ─── การ์ดสรุปท้ายบท (school_visuals ผูก lesson_id) ─────────────────────────
insert into public.school_visuals
  (topic_id, lesson_id, layer, title, image_url, caption, notes_md, check_questions, linked_flashcard_ids, source, sort_order, status)
select v.topic_id, v.lesson_id, v.layer, v.title, v.image_url, v.caption, v.notes_md, v.check_questions::jsonb, '{}'::uuid[], 'pilot:cell-biology-20260920', v.sort_order, 'active'
from (values
  ('a0af1ea4-cf9b-4d1e-979d-8664b3fa93e5'::uuid, 'ffec487b-e135-4274-a3b3-c0558189be93'::uuid, 'foundation',
   'สรุปบทที่ 1: Cell Theory → Nucleus',
   '/lesson-images/school/cell-biology/cellbio-01-summary.svg',
   'Cell theory 3 ข้อ · Prokaryote vs Eukaryote · Stem cell potency · ส่วนประกอบ nucleus',
   E'- Cell theory 3 ข้อ: ทุกชีวิตประกอบด้วยเซลล์ · เซลล์เกิดจากเซลล์ · เซลล์คือหน่วยพื้นฐาน\n- Prokaryote ไม่มี nucleus, ribosome 70S · Eukaryote มี nucleus, ribosome 80S\n- ยกเว้น: mitochondria/chloroplast ของ eukaryote ยังใช้ ribosome 70S\n- Stem cell: Toti → Pluri → Multi → Oligo → Uni (แคบลงเรื่อย ๆ)\n- Nucleus: envelope 2 ชั้น + pore + nucleolus (สร้าง ribosome) + chromatin + lamina',
   '[{"q":"Ribosome ของ prokaryote กับ eukaryote ต่างกันอย่างไร และข้อยกเว้นคืออะไร","a":"70S vs 80S — แต่ mitochondria และ chloroplast ของ eukaryote ยังเป็น 70S"},{"q":"Stem cell ชนิดไหนสร้าง placenta ได้","a":"Totipotent (zygote) เท่านั้น"},{"q":"Nucleolus ทำหน้าที่อะไร","a":"ribosome biogenesis — สังเคราะห์ rRNA และประกอบ ribosome subunits"}]',
   0),
  ('a0af1ea4-cf9b-4d1e-979d-8664b3fa93e5'::uuid, '5705ca70-489c-4de0-a210-88039729b12f'::uuid, 'anatomy',
   'สรุปบทที่ 2: Mitochondria · Endosome · ER · Golgi',
   '/lesson-images/school/cell-biology/cellbio-02-summary.svg',
   'โครงสร้าง mitochondrion · 3 ขั้น respiration · endosome แยก receptor/ligand · ER → Golgi',
   E'- Mitochondrion: outer (porin) · inner/cristae (ETC + ATP synthase) · matrix (Krebs, β-oxidation, 70S)\n- Respiration 3 ขั้น: Glycolysis (cytosol) → Krebs (matrix) → OxPhos (inner membrane)\n- Early endosome แยก receptor (recycle) ออกจาก ligand (→ late endosome → lysosome)\n- RER มี ribosome สร้าง protein · SER ไม่มี สร้าง lipid\n- ER → COPII → Golgi (cis→trans) → TGN คัดแยก · COPI ส่งกลับ ER',
   '[{"q":"Oxidative phosphorylation เกิดที่ส่วนไหนของ mitochondrion","a":"Inner mitochondrial membrane (cristae)"},{"q":"LDL receptor ไปไหนหลังแยกจาก LDL ใน early endosome","a":"กลับไปที่ plasma membrane ผ่าน recycling endosome"},{"q":"COPII กับ COPI ต่างกันอย่างไร","a":"COPII ส่งไปข้างหน้า ER → Golgi · COPI ส่งย้อนกลับ Golgi → ER"}]',
   1),
  ('a0af1ea4-cf9b-4d1e-979d-8664b3fa93e5'::uuid, '2c73cfb9-ad71-46ec-9b71-82da8c11ce49'::uuid, 'anatomy',
   'สรุปบทที่ 3: Peroxisome · Lysosome · Autophagy',
   '/lesson-images/school/cell-biology/cellbio-03-summary.svg',
   'Peroxisome กับ 3 โรค · Lysosome และ M6P pathway · Autophagy 4 ขั้น',
   E'- Peroxisome: เยื่อชั้นเดียว · catalase กำจัด H₂O₂ · β-oxidation ของ VLCFA\n- โรค peroxisome: Zellweger (import) · ALD (ABCD1, VLCFA) · Refsum (phytanic acid)\n- Lysosome: pH 4.5–5.0 · acid hydrolase ~40 ชนิด · ทำงานเฉพาะที่กรด (safety lock)\n- M6P pathway: ติดป้ายที่ cis-Golgi → receptor ที่ TGN → ปล่อยใน endosome → lysosome\n- Autophagy 4 ขั้น: โอบ → ปิด (เยื่อ 2 ชั้น) → รวม lysosome → ย่อย',
   '[{"q":"Catalase ใน peroxisome ทำอะไร","a":"2H₂O₂ → 2H₂O + O₂ กำจัด hydrogen peroxide ที่เป็นพิษ"},{"q":"I-cell disease พังที่ขั้นไหนของ M6P pathway","a":"ขาด GlcNAc phosphotransferase ที่ Golgi → enzyme ไม่มีป้าย M6P → หลุดออกนอกเซลล์"},{"q":"Autophagosome มีเยื่อกี่ชั้น","a":"2 ชั้น — เยื่อชั้นในถูกย่อยพร้อมของข้างในเมื่อรวมกับ lysosome"}]',
   2)
) as v(topic_id, lesson_id, layer, title, image_url, caption, notes_md, check_questions, sort_order)
where not exists (
  select 1 from public.school_visuals s where s.lesson_id = v.lesson_id
);
