-- ============================================
-- หมอรู้ (MorRoo) — Database Schema & Seed Data
-- ============================================

-- ตาราง profiles
create table if not exists public.profiles (
  id uuid references auth.users primary key,
  email text,
  name text,
  role text default 'user' check (role in ('user', 'admin')),
  membership_type text default 'free' check (membership_type in ('free', 'bundle', 'monthly', 'yearly', 'mcq_monthly', 'mcq_yearly', 'meq_monthly', 'meq_yearly', 'longcase_monthly', 'longcase_yearly')),
  membership_expires_at timestamptz,
  created_at timestamptz default now()
);

-- ตาราง exams
create table if not exists public.exams (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  category text not null,
  difficulty text check (difficulty in ('easy', 'medium', 'hard')),
  status text default 'draft' check (status in ('draft', 'scheduled', 'published')),
  is_free boolean default false,
  publish_date date,
  created_by text default 'admin',
  created_at timestamptz default now()
);

-- ตาราง exam_parts
create table if not exists public.exam_parts (
  id uuid primary key default gen_random_uuid(),
  exam_id uuid references public.exams on delete cascade,
  part_number int not null,
  title text not null,
  scenario text not null,
  question text not null,
  answer text not null,
  key_points text[] default '{}',
  time_minutes int default 10,
  created_at timestamptz default now()
);

-- RLS
alter table public.profiles enable row level security;
alter table public.exams enable row level security;
alter table public.exam_parts enable row level security;

-- Profiles: users can read/update own profile
create policy "Users can view own profile"
  on public.profiles for select
  using (auth.uid() = id);

create policy "Users can update own profile"
  on public.profiles for update
  using (auth.uid() = id);

create policy "Users can insert own profile"
  on public.profiles for insert
  with check (auth.uid() = id);

-- Exams: published exams viewable by everyone
create policy "Published exams are viewable by everyone"
  on public.exams for select
  using (status = 'published');

-- Exam parts: viewable by everyone (answer hidden at frontend level)
create policy "Exam parts are viewable by everyone"
  on public.exam_parts for select
  using (true);

-- Admin policies
create policy "Admins can manage exams"
  on public.exams for all
  using (auth.uid() in (select id from public.profiles where role = 'admin'));

create policy "Admins can manage exam parts"
  on public.exam_parts for all
  using (auth.uid() in (select id from public.profiles where role = 'admin'));

create policy "Admins can update all profiles"
  on public.profiles for update
  using (auth.uid() in (select id from public.profiles where role = 'admin'));

create policy "Admins can view all profiles"
  on public.profiles for select
  using (auth.uid() in (select id from public.profiles where role = 'admin'));

-- ============================================
-- Seed Data: ข้อสอบตัวอย่าง
-- ============================================

-- ข้อที่ 1: Upper GI Bleeding (ฟรี)
insert into public.exams (id, title, category, difficulty, status, is_free, publish_date, created_by)
values (
  'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
  'ภาวะเลือดออกในทางเดินอาหารส่วนบน (Upper GI Bleeding)',
  'อายุรศาสตร์',
  'hard',
  'published',
  true,
  '2026-03-25',
  'admin'
);

-- ตอนที่ 1
insert into public.exam_parts (exam_id, part_number, title, scenario, question, answer, key_points, time_minutes)
values (
  'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
  1,
  'ตอนที่ 1: ประวัติและการตรวจเบื้องต้น',
  'ชายไทยอายุ 55 ปี มาห้องฉุกเฉินด้วยอาการอาเจียนเป็นเลือดสดประมาณ 2 แก้ว เมื่อ 3 ชั่วโมงก่อนมาโรงพยาบาล มีประวัติปวดข้อเข่าเรื้อรัง ซื้อยา NSAIDs (Ibuprofen) กินเองมานาน 6 เดือน ดื่มเหล้าเป็นประจำ 1-2 แก้ว/วัน

ตรวจร่างกาย: BP 90/60 mmHg, HR 120 bpm, RR 24, Temp 37.2°C
ลักษณะทั่วไป: ซีด เหงื่อออก กระสับกระส่าย
ท้อง: กดเจ็บบริเวณ epigastrium ไม่มี guarding',
  'จงระบุปัญหาเร่งด่วนที่สุดของผู้ป่วยรายนี้ และแนวทางการ resuscitate เบื้องต้น',
  'ปัญหาเร่งด่วนที่สุด: Hypovolemic shock จาก Upper GI bleeding

แนวทาง Resuscitation:
1. Airway: ประเมินทางเดินหายใจ วางท่าศีรษะสูง ป้องกัน aspiration
2. Breathing: ให้ O2 supplement
3. Circulation:
   - เปิดเส้นเลือด IV 2 เส้น (large bore 16-18G)
   - ให้ NSS หรือ Ringer''s lactate bolus 1-2 L
   - ส่ง CBC, BUN, Cr, Coagulation, Cross-match blood 4 units
   - เตรียม Packed Red Cell สำหรับ transfusion
4. ใส่ NG tube เพื่อ confirm upper GI source และ lavage
5. ใส่ Foley catheter วัด urine output
6. NPO
7. เริ่ม IV PPI: Omeprazole 80 mg IV bolus แล้วตามด้วย 8 mg/hr drip',
  ARRAY['Hematemesis + Hypotension + Tachycardia = Hypovolemic shock', 'ABC approach ต้องทำทันที', 'IV PPI high dose ลด rebleeding rate', 'Cross-match blood เตรียมไว้เสมอ'],
  10
);

-- ตอนที่ 2
insert into public.exam_parts (exam_id, part_number, title, scenario, question, answer, key_points, time_minutes)
values (
  'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
  2,
  'ตอนที่ 2: การส่งตรวจและผลการตรวจ',
  'หลังให้สารน้ำ 2,000 mL: BP 100/70 mmHg, HR 100 bpm

ผล Lab:
- Hb 7.2 g/dL (baseline ไม่ทราบ)
- Hct 22%
- Platelet 180,000
- BUN 45 mg/dL, Cr 1.1 mg/dL
- PT/INR ปกติ

NG tube aspiration: ได้เลือดสดและ coffee-ground material ประมาณ 500 mL',
  'จงวิเคราะห์ผลการตรวจและวางแผนการรักษาต่อไป รวมถึงระบุ timing สำหรับ endoscopy',
  'วิเคราะห์ผล:
- Hb 7.2: severe anemia ต้อง transfuse PRC
- BUN/Cr ratio สูง (>20:1): สนับสนุน upper GI bleeding
- Coagulation ปกติ: ไม่มี coagulopathy
- NG aspirate เป็นเลือดสด: active bleeding

แผนการรักษา:
1. Transfuse PRC เป้า Hb > 7-8 g/dL (อย่างน้อย 2 units)
2. ต่อ IV PPI drip
3. ปรึกษา GI สำหรับ Emergency EGD
4. Timing: EGD ควรทำภายใน 12-24 ชั่วโมง (urgent endoscopy)
5. แจ้ง ICU เตรียม admit
6. งด NSAIDs ทันที',
  ARRAY['BUN/Cr ratio >20:1 ชี้นำ upper GI source', 'Transfusion threshold: Hb < 7 g/dL ในคนปกติ', 'Urgent EGD ภายใน 12-24 ชม.', 'หยุด NSAIDs ทันที — เป็นสาเหตุสำคัญ'],
  10
);

-- ตอนที่ 3
insert into public.exam_parts (exam_id, part_number, title, scenario, question, answer, key_points, time_minutes)
values (
  'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
  3,
  'ตอนที่ 3: ผลการส่องกล้อง (EGD)',
  'ผล EGD พบ:
- Gastric ulcer ขนาด 2 cm ที่ lesser curvature ของ stomach
- Forrest classification IIa (visible vessel without active bleeding)
- ไม่พบ esophageal varices
- Duodenum ปกติ',
  'จง interpret ผล EGD และระบุแนวทางการรักษาผ่านการส่องกล้อง (endoscopic treatment) ที่เหมาะสม',
  'Interpretation:
- Gastric ulcer Forrest IIa: มี visible vessel = high risk for rebleeding (43%)
- ไม่มี varices → ตัด portal hypertension ออก
- สาเหตุน่าจะมาจาก NSAID-induced gastropathy

Endoscopic Treatment:
1. Dual therapy:
   - Epinephrine injection (1:10,000) รอบแผล
   - ตามด้วย Thermal coagulation หรือ Hemoclip
2. Forrest IIa จำเป็นต้องได้รับ endoscopic hemostasis
3. หลังทำ: ต่อ IV PPI high dose drip 72 ชม.
4. ส่ง biopsy ขอบแผลเพื่อ:
   - ตรวจ H. pylori (CLO test)
   - R/O malignancy (gastric ulcer ต้อง biopsy เสมอ)',
  ARRAY['Forrest IIa = visible vessel = high rebleed risk', 'Dual endoscopic therapy ดีกว่า monotherapy', 'Gastric ulcer ต้อง biopsy ทุกครั้ง R/O malignancy', 'IV PPI drip ต่อ 72 ชม. หลัง endoscopic hemostasis'],
  10
);

-- ตอนที่ 4
insert into public.exam_parts (exam_id, part_number, title, scenario, question, answer, key_points, time_minutes)
values (
  'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
  4,
  'ตอนที่ 4: การรักษาหลัง Endoscopy',
  'หลัง endoscopic treatment สำเร็จ ผู้ป่วย admit ICU

วันที่ 2: Vital signs stable, ไม่มี rebleeding
ผล CLO test: Positive for H. pylori
Pathology: Chronic gastritis with no malignancy',
  'วางแผนการรักษาต่อเนื่อง ทั้ง short-term และ long-term',
  'Short-term:
1. ต่อ IV PPI drip ครบ 72 ชม. แล้วเปลี่ยนเป็น oral PPI
2. เริ่มจิบน้ำ → liquid diet → soft diet
3. Monitor: vital signs, Hb ทุก 12-24 ชม.
4. ย้ายออกจาก ICU เมื่อ stable 24-48 ชม.

Long-term:
1. H. pylori eradication: Triple therapy 14 วัน
   - PPI (Omeprazole 20 mg bid)
   - Amoxicillin 1 g bid
   - Clarithromycin 500 mg bid
2. ต่อ PPI อีก 8 สัปดาห์เพื่อ ulcer healing
3. Follow-up EGD ที่ 8-12 สัปดาห์
4. Confirm H. pylori eradication
5. หยุด NSAIDs ถาวร → เปลี่ยนเป็น Paracetamol',
  ARRAY['H. pylori eradication: Triple therapy 14 วัน', 'PPI ต้องกินต่อ 8 สัปดาห์ healing ulcer', 'Follow-up EGD + biopsy จำเป็นสำหรับ gastric ulcer', 'หยุด NSAIDs และหา alternative'],
  10
);

-- ตอนที่ 5
insert into public.exam_parts (exam_id, part_number, title, scenario, question, answer, key_points, time_minutes)
values (
  'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
  5,
  'ตอนที่ 5: ภาวะแทรกซ้อน',
  'วันที่ 3 ขณะ ward: ผู้ป่วยอาเจียนเป็นเลือดสดอีกครั้งประมาณ 300 mL
BP ลดลงเป็น 85/55 mmHg, HR 125 bpm
Hb ลดจาก 9.2 เป็น 7.5 g/dL',
  'วินิจฉัยภาวะแทรกซ้อนและวางแผนการจัดการ',
  'วินิจฉัย: Rebleeding จาก gastric ulcer

การจัดการ:
1. Resuscitate ใหม่: IV fluid bolus + Transfuse PRC + ย้าย ICU
2. ปรึกษา GI สำหรับ Repeat endoscopy
3. Repeat EGD: ลอง endoscopic hemostasis อีกครั้ง
4. หาก endoscopic treatment ล้มเหลว:
   - Interventional radiology: Angiographic embolization
   - หรือ Surgery: Partial gastrectomy
5. Risk factors: Large ulcer (>2 cm), Forrest IIa, Hemodynamic instability',
  ARRAY['Rebleeding rate หลัง endoscopic Rx ~10-20%', 'Repeat endoscopy ก่อน surgery', 'Angiographic embolization เป็น alternative ก่อน surgery', 'Risk factors: ulcer size >2cm, Forrest IIa, hemodynamic instability'],
  10
);

-- ตอนที่ 6
insert into public.exam_parts (exam_id, part_number, title, scenario, question, answer, key_points, time_minutes)
values (
  'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
  6,
  'ตอนที่ 6: การดูแลก่อนจำหน่าย',
  'หลัง repeat endoscopy สำเร็จ ผู้ป่วย stable ไม่มี rebleeding อีก 5 วัน
รับประทานอาหารได้ดี เตรียมจำหน่ายกลับบ้าน',
  'วางแผน discharge plan และ patient education',
  'Discharge Plan:
1. ยากลับบ้าน: Omeprazole 20 mg bid + H. pylori triple therapy 14 วัน + Paracetamol prn
2. นัดตรวจ: 2 สัปดาห์, 4 สัปดาห์ (UBT), 8-12 สัปดาห์ (Follow-up EGD)

Patient Education:
1. หยุด NSAIDs ถาวร
2. ลด/หยุดแอลกอฮอล์
3. อาการที่ต้องมาพบแพทย์ทันที: อาเจียนเป็นเลือด, ถ่ายดำ, เวียนศีรษะ หน้ามืด
4. กินยาครบตามแพทย์สั่ง โดยเฉพาะ antibiotic',
  ARRAY['Discharge medications ต้องครบ: PPI + H. pylori Rx', 'Follow-up EGD จำเป็นสำหรับ gastric ulcer', 'Patient education เรื่องหยุด NSAIDs สำคัญมาก', 'Red flags ที่ต้องมาพบแพทย์ทันที'],
  10
);

-- ============================================
-- ข้อที่ 2: Severe CAP (Premium)
-- ============================================

insert into public.exams (id, title, category, difficulty, status, is_free, publish_date, created_by)
values (
  'b2c3d4e5-f6a7-8901-bcde-f12345678901',
  'โรคปอดอักเสบรุนแรง (Severe Community-Acquired Pneumonia)',
  'อายุรศาสตร์',
  'hard',
  'published',
  false,
  '2026-03-24',
  'admin'
);

-- ตอนที่ 1
insert into public.exam_parts (exam_id, part_number, title, scenario, question, answer, key_points, time_minutes)
values (
  'b2c3d4e5-f6a7-8901-bcde-f12345678901',
  1,
  'ตอนที่ 1: การซักประวัติและตรวจร่างกาย',
  'ชายไทยอายุ 68 ปี โรคประจำตัว: เบาหวานชนิดที่ 2 (15 ปี) และ COPD (สูบบุหรี่ 40 pack-years) มาห้องฉุกเฉินด้วยไข้สูง 39.5°C หนาวสั่น 2 วัน ไอมีเสมหะเหลืองเขียวข้น หายใจหอบเหนื่อย

ตรวจร่างกาย: BP 85/50 mmHg, HR 130 bpm, RR 32, SpO2 85% RA
ปอด: Crackles Lt lower lobe, bronchial breath sound
Extremities: Capillary refill > 3 sec',
  'จงวิเคราะห์ปัญหาของผู้ป่วย ประเมินความรุนแรง และวางแผน initial management',
  'วิเคราะห์: CAP with Septic Shock, Underlying DM + COPD

ประเมินความรุนแรง (CURB-65): อย่างน้อย 3 → Severe, ICU admission

Initial Management:
1. O2 high flow, target SpO2 ≥ 92%
2. Sepsis bundle Hour-1:
   - IV fluid bolus 30 mL/kg
   - Blood culture 2 sets ก่อนให้ ATB
   - IV antibiotics ภายใน 1 ชั่วโมง
   - วัด Lactate
   - ถ้า MAP < 65 หลังให้ fluid → start Norepinephrine
3. Lab: CBC, BUN, Cr, Electrolytes, LFT, Lactate, ABG, Procalcitonin
4. CXR portable',
  ARRAY['CAP + Septic shock = medical emergency', 'CURB-65 ≥ 3 → ICU admission', 'Hour-1 Sepsis Bundle: culture → ATB → fluid → lactate → vasopressor', 'DM + COPD = risk factors for severe CAP'],
  10
);

-- ตอนที่ 2
insert into public.exam_parts (exam_id, part_number, title, scenario, question, answer, key_points, time_minutes)
values (
  'b2c3d4e5-f6a7-8901-bcde-f12345678901',
  2,
  'ตอนที่ 2: ผลการตรวจทางห้องปฏิบัติการ',
  'ผล Lab:
- WBC 22,000 (Neutrophil 90%)
- Hb 11.5, Plt 145,000
- BUN 38, Cr 2.1 (baseline 1.0)
- Lactate 4.5 mmol/L
- Procalcitonin 15.2 ng/mL
- ABG: pH 7.28, PaO2 55, PaCO2 50, HCO3 18
- CXR: Dense consolidation left lower lobe with air bronchogram
- Blood glucose: 385 mg/dL',
  'วิเคราะห์ผล lab ทั้งหมดและเลือก empirical antibiotics ที่เหมาะสม',
  'วิเคราะห์:
1. Leukocytosis + Left shift: bacterial infection
2. AKI (Cr 2.1 จาก 1.0): sepsis-related
3. Lactate 4.5: tissue hypoperfusion → septic shock
4. ABG: Mixed respiratory + metabolic acidosis
5. CXR: Lobar consolidation → typical bacterial pneumonia
6. Hyperglycemia: DM decompensation จาก sepsis

Empirical ATB สำหรับ Severe CAP (ICU):
- Ceftriaxone 2 g IV OD + Azithromycin 500 mg IV OD
- หรือ Beta-lactam + Respiratory fluoroquinolone
- Insulin drip สำหรับ hyperglycemia
- Consider BiPAP หรือ intubation',
  ARRAY['Lactate >4 = severe sepsis/septic shock', 'Severe CAP: Beta-lactam + Macrolide หรือ Respiratory FQ', 'ABG mixed acidosis = poor prognosis', 'ต้อง control blood sugar ใน sepsis + DM'],
  10
);

-- ตอนที่ 3
insert into public.exam_parts (exam_id, part_number, title, scenario, question, answer, key_points, time_minutes)
values (
  'b2c3d4e5-f6a7-8901-bcde-f12345678901',
  3,
  'ตอนที่ 3: การจัดการใน ICU',
  'หลังให้ IV fluid 2L + Norepinephrine: MAP 68 mmHg
หลังใส่ BiPAP: SpO2 92%, PaCO2 ลดเป็น 42
ให้ Ceftriaxone + Azithromycin IV แล้ว

6 ชม.ต่อมา: ผู้ป่วยสับสน GCS ลดจาก 14 เป็น 10
SpO2 ลดเป็น 86% แม้อยู่บน BiPAP',
  'ประเมินสถานการณ์ที่เปลี่ยนแปลงและวางแผนการจัดการ',
  'Clinical deterioration: GCS ลดลง + SpO2 ลดลง

การจัดการ:
1. Intubation + Mechanical ventilation (GCS ≤ 10)
2. เช็ค blood sugar STAT (R/O hypoglycemia)
3. Lung protective ventilation: TV 6-8 mL/kg IBW, PEEP 5-10
4. Reassess: Repeat CXR, Sputum culture
5. ถ้า P/F ratio < 200 → moderate-severe ARDS
6. พิจารณา broaden antibiotic coverage',
  ARRAY['GCS ≤ 10 + Respiratory failure → intubate', 'Lung protective ventilation: TV 6-8 mL/kg IBW', 'ต้อง R/O hypoglycemia ใน DM on insulin drip', 'P/F ratio < 200 = moderate-severe ARDS'],
  10
);

-- ตอนที่ 4
insert into public.exam_parts (exam_id, part_number, title, scenario, question, answer, key_points, time_minutes)
values (
  'b2c3d4e5-f6a7-8901-bcde-f12345678901',
  4,
  'ตอนที่ 4: ผลเพาะเชื้อและปรับยา',
  'วันที่ 3 ใน ICU:
- Blood culture (2/2 ขวด): Streptococcus pneumoniae — Penicillin sensitive
- Sputum culture: S. pneumoniae (consistent)
- CXR: ลุกลามเป็น bilateral infiltrates
- P/F ratio: 180 → Moderate ARDS
- Cr คงที่ที่ 1.8 (ดีขึ้นจาก 2.1)',
  'ปรับแผนการรักษาตามผลเพาะเชื้อ และจัดการ ARDS',
  'De-escalation:
1. เปลี่ยนเป็น Penicillin G IV หรือ Ampicillin IV (Pen-sensitive)
2. หยุด Azithromycin ได้
3. ระยะเวลา: 5-7 วัน

จัดการ ARDS:
1. Lung protective ventilation ต่อ
2. Conservative fluid strategy
3. Prone positioning 12-16 ชม./วัน
4. ICU bundle: DVT prophylaxis, stress ulcer prophylaxis, early nutrition',
  ARRAY['De-escalation เมื่อรู้เชื้อ = antibiotic stewardship', 'S. pneumoniae = common cause of severe CAP', 'Moderate ARDS: prone positioning มี evidence', 'ICU bundle: DVT, stress ulcer, nutrition'],
  10
);

-- ตอนที่ 5
insert into public.exam_parts (exam_id, part_number, title, scenario, question, answer, key_points, time_minutes)
values (
  'b2c3d4e5-f6a7-8901-bcde-f12345678901',
  5,
  'ตอนที่ 5: การหย่าเครื่องช่วยหายใจ',
  'วันที่ 7: ผู้ป่วยดีขึ้นมาก
- ไข้หาย 48 ชม.
- P/F ratio 280, FiO2 0.4, PEEP 5
- GCS 15, hemodynamically stable
- หยุด vasopressor แล้ว 24 ชม.',
  'อธิบาย criteria และขั้นตอนการ weaning จากเครื่องช่วยหายใจ',
  'SBT Criteria: ผ่านทุกข้อ ✓

ขั้นตอน SBT:
1. T-piece trial หรือ PSV 5-7 cmH2O 30-120 นาที
2. สังเกต: RR < 35, SpO2 ≥ 90%, RSBI < 105
3. ถ้าผ่าน → Extubation
4. Pre-extubation: Cuff leak test, HOB elevation
5. Post-extubation: O2 supplement, เตรียม NIV standby (COPD patient)',
  ARRAY['SBT criteria: cause resolved, oxygenation OK, hemodynamic stable', 'RSBI < 105 = favorable for extubation', 'COPD patients: เตรียม NIV standby หลัง extubation', 'Monitor 24-48 ชม. หลัง extubation'],
  10
);

-- ตอนที่ 6
insert into public.exam_parts (exam_id, part_number, title, scenario, question, answer, key_points, time_minutes)
values (
  'b2c3d4e5-f6a7-8901-bcde-f12345678901',
  6,
  'ตอนที่ 6: การวางแผนจำหน่ายและป้องกัน',
  'วันที่ 15: เดินได้ ไม่มีไข้ รับประทานอาหารได้ดี
SpO2 95% room air, CXR: infiltrate ลดลงมาก, Cr กลับมา 1.1',
  'วางแผน discharge plan, follow-up, และมาตรการป้องกัน',
  'Discharge Plan:
1. ATB oral ครบ course 7-10 วัน
2. ปรับ DM medications + COPD inhalers

มาตรการป้องกัน:
1. Vaccination: Pneumococcal + Influenza + COVID-19
2. Smoking cessation
3. DM optimization: HbA1c < 7-8%
4. COPD optimization: LABA/LAMA, Pulmonary rehabilitation
5. Follow-up CXR ที่ 4-6 สัปดาห์',
  ARRAY['Pneumococcal + Influenza vaccine ป้องกัน recurrent CAP', 'Smoking cessation = single most important for COPD', 'Follow-up CXR confirm resolution สำคัญ', 'DM + COPD optimization ลด risk of recurrence'],
  10
);
