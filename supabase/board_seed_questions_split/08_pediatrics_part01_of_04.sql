-- ===============================================================
-- หมอรู้ — Board seed: กุมารเวชศาสตร์ (pediatrics) — part 1/4 (50 MCQs)
-- Safe to paste into Supabase SQL Editor. Re-runnable.
-- ===============================================================

begin;

-- mcq_subjects for this specialty (idempotent)
insert into public.mcq_subjects
  (name, name_th, icon, audience, board_specialty, exam_type, question_count)
values
  ('peds_clinical_decision', 'กุมารเวชศาสตร์ · การตัดสินใจทางเวชกรรม', '🩺', 'board', 'pediatrics', NULL, 0),
  ('peds_basic_science', 'กุมารเวชศาสตร์ · วิทยาศาสตร์การแพทย์พื้นฐาน', '🧬', 'board', 'pediatrics', NULL, 0),
  ('peds_ems_mgmt', 'กุมารเวชศาสตร์ · การจัดการระบบบริการการแพทย์ฉุกเฉิน', '🚨', 'board', 'pediatrics', NULL, 0),
  ('peds_integrative', 'กุมารเวชศาสตร์ · ข้อสอบบูรณาการ', '🧩', 'board', 'pediatrics', NULL, 0)
on conflict (name) do nothing;

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 6 เดือน คลอดครบกำหนด มาห้องฉุกเฉินด้วยอาการหอบเหนื่อย ไอ มีเสียง wheeze เป็นมา 3 วัน ก่อนหน้าเป็นหวัด 1 สัปดาห์ พ่อแม่บอกว่าลูกกินนมน้อยลง

V/S: HR 165, RR 65, SpO2 89% room air, Temp 37.8°C, น้ำหนัก 7 kg
Gen: alert but tired, mild cyanosis perioral, nasal flaring, subcostal + intercostal retraction
Lungs: bilateral fine crackles + expiratory wheeze, prolonged expiratory phase

CBC: WBC 12,500, normal differential
CXR: hyperinflation + bilateral perihilar streaking + scattered atelectasis
RSV antigen: positive', '[{"label":"A","text":"IV antibiotics + bronchodilator + steroid"},{"label":"B","text":"Acute Bronchiolitis (RSV) moderate-severe"},{"label":"C","text":"Discharge with oral antibiotic"},{"label":"D","text":"Intubation immediately"},{"label":"E","text":"Restrict fluid completely"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Bronchiolitis (RSV) moderate-severe: supportive care mainstay — O2 to SpO2 ≥ 90%, nasal suctioning, hydration; routine bronchodilators NOT recommended (AAP 2014 — no proven benefit); NO routine steroids or antibiotics (viral); HFNC for moderate distress; hospitalization for severe distress/hypoxia/dehydration/apnea < 3 mo; palivizumab prophylaxis for high-risk (premature, BPD, CHD)

---

Bronchiolitis = viral lower respiratory infection (RSV most common). Peak age 2-6 mo. AAP 2014 + NICE emphasize supportive care. Key: O2, hydration, monitoring. No routine antibiotics, bronchodilators, steroids, chest PT. HFNC may help. Prevention: hand hygiene + palivizumab for high-risk. A wrong — abx + steroid not indicated. C wrong — moderate distress can''t discharge. D wrong — try less invasive. E wrong — fluid needed.', NULL,
  'easy', 'respiratory', 'review',
  'pediatrics', 'clinical_decision', 'respiratory', 'peds',
  'AAP Clinical Practice Guideline: Bronchiolitis 2014 (Ralston SL et al.); NICE NG9', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 6 เดือน คลอดครบกำหนด มาห้องฉุกเฉินด้วยอาการหอบเหนื่อย ไอ มีเสียง wheeze เป็นมา 3 วัน ก่อนหน้าเป็นหวัด 1 สัปดาห์ พ่อแม่บอกว่าลูกกินนมน้อยลง

V/S: HR 165, RR 65, SpO2 89% room air, Temp 37.8°C, น้ำหนัก 7 kg
Gen: alert but tired, mild cyanosis perioral, nasal flaring, subcostal + intercostal retraction
Lungs: bilateral fine crackles + expiratory wheeze, prolonged expiratory phase

CBC: WBC 12,500, normal differential
CXR: hyperinflation + bilateral perihilar streaking + scattered atelectasis
RSV antigen: positive'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 4 ปี ไข้สูง 39.8°C × 6 วัน + ผื่นแดง + ตาแดง 2 ข้าง + ปากแดงสด + แขนขาบวมแดง + ต่อมน้ำเหลืองที่คอข้างเดียว 1.8 cm + irritable

V/S: HR 142, BP 96/64, Temp 39.8°C
PE: cracked lips + strawberry tongue + cervical lymphadenopathy unilateral + bilateral non-purulent conjunctival injection + polymorphous rash + extremity edema + perineal desquamation

Lab: WBC 18,500, CRP 145, Plt 580,000 (rising), Albumin 2.8
Echo: dilated left main coronary (Z-score +3.5)', '[{"label":"A","text":"Discharge with paracetamol for viral exanthem"},{"label":"B","text":"Complete Kawasaki Disease (5/6 criteria) with coronary involvement"},{"label":"C","text":"Antibiotic for streptococcal scarlet fever"},{"label":"D","text":"Observation × 24 hours"},{"label":"E","text":"Hospice care"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Complete Kawasaki Disease (5/6 criteria) with coronary involvement: IVIG 2 g/kg IV over 10-12h within first 10 days (reduces coronary aneurysm 25→5%); high-dose aspirin 80-100 mg/kg/d until afebrile 48-72h then low-dose 3-5 mg/kg/d antiplatelet × 6-8 wk; echo at dx, 2 wk, 6-8 wk; high-risk Kobayashi → adjunctive steroid; IVIG-resistant → 2nd IVIG, infliximab; live vaccines delayed 11 mo post-IVIG

---

Kawasaki = acute vasculitis of medium vessels, leading cause acquired heart disease children. Criteria: fever ≥ 5 d + ≥ 4 of 5: conjunctivitis, oral changes, rash, extremity changes, cervical LN. IVIG + aspirin within first 10 days reduces coronary aneurysm 5×. Echo at dx, 2 wk, 6-8 wk. AHA 2017 guideline. Long-term cardiac surveillance.', NULL,
  'medium', 'cardiovascular', 'review',
  'pediatrics', 'clinical_decision', 'cardiovascular', 'peds',
  'AHA Scientific Statement: Kawasaki Disease 2017 (McCrindle BW et al.)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 4 ปี ไข้สูง 39.8°C × 6 วัน + ผื่นแดง + ตาแดง 2 ข้าง + ปากแดงสด + แขนขาบวมแดง + ต่อมน้ำเหลืองที่คอข้างเดียว 1.8 cm + irritable

V/S: HR 142, BP 96/64, Temp 39.8°C
PE: cracked lips + strawberry tongue + cervical lymphadenopathy unilateral + bilateral non-purulent conjunctival injection + polymorphous rash + extremity edema + perineal desquamation

Lab: WBC 18,500, CRP 145, Plt 580,000 (rising), Albumin 2.8
Echo: dilated left main coronary (Z-score +3.5)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 8 เดือน acute onset ปวดท้อง crying + กระสับกระส่าย 15-20 นาทีแล้วหยุด สลับเป็นรอบ ๆ × 6 ชั่วโมง อาเจียน 3 ครั้ง วันนี้ถ่าย currant jelly stool

V/S: HR 168, lethargic
Abdomen: distended, palpable sausage-shaped mass RUQ

US: target/donut sign + pseudokidney — ileocolic intussusception', '[{"label":"A","text":"Observe + serial exams"},{"label":"B","text":"Ileocolic Intussusception (most common bowel obstruction 6 mo-3 yr)"},{"label":"C","text":"Antibiotic + outpatient"},{"label":"D","text":"Endoscopy"},{"label":"E","text":"MRI abdomen first"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Ileocolic Intussusception (most common bowel obstruction 6 mo-3 yr): IV fluid bolus 20 mL/kg + NG decompression + NPO; pneumatic or hydrostatic enema reduction under fluoroscopy/US guidance (80-90% success, first-line); contraindications: peritonitis, perforation, instability; surgery if enema fails, perforation, identifiable lead point (older children); post-reduction observation 12-24h (recurrence 5-10%)

---

Intussusception (telescoping bowel) — most common obstruction infants 6 mo-3 yr. Classic triad: intermittent crampy pain + currant jelly stool + sausage mass (25-50%). Most ileocolic (95%). Lead point: lymphoid hyperplasia (post-viral, Peyer''s patches). US diagnostic (target sign). Enema reduction first-line. Surgery if fails or contraindicated. Older children: investigate pathological lead point.', NULL,
  'easy', 'gi', 'review',
  'pediatrics', 'clinical_decision', 'gi', 'peds',
  'AAP Section on Surgery; Marsicovetere P et al. Pediatr Rev 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 8 เดือน acute onset ปวดท้อง crying + กระสับกระส่าย 15-20 นาทีแล้วหยุด สลับเป็นรอบ ๆ × 6 ชั่วโมง อาเจียน 3 ครั้ง วันนี้ถ่าย currant jelly stool

V/S: HR 168, lethargic
Abdomen: distended, palpable sausage-shaped mass RUQ

US: target/donut sign + pseudokidney — ileocolic intussusception'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 12 ปี polyuria + polydipsia + น้ำหนักลด 6 kg × 2 เดือน + เหนื่อย + คลื่นไส้ + อาเจียน 6 ชม

V/S: BP 102/64, HR 124, RR 32 (Kussmaul), Temp 36.8°C, DTX HI
Gen: dehydrated, GCS 13, capillary refill 4 sec

ABG: pH 7.10, PaCO2 18, HCO3 6
Lab: Glucose 685, Na 132, K 5.4, BUN 28, Cr 1.0, Ketone urine 3+, AG 30
New DM type 1', '[{"label":"A","text":"Insulin bolus IV high dose + glucose 50% IV"},{"label":"B","text":"Pediatric DKA moderate-severe (ISPAD 2022)"},{"label":"C","text":"Same protocol as adult DKA"},{"label":"D","text":"Restrict all fluid"},{"label":"E","text":"Discharge home with oral hypoglycemic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric DKA moderate-severe (ISPAD 2022): CAUTIOUS fluid resuscitation (high cerebral edema risk!) — 10-20 mL/kg NSS bolus if shock then deficit over 48h (not 24h); insulin drip 0.05-0.1 U/kg/hr start 1-2h AFTER fluid (NO bolus); K replacement in fluid once K < 5.5 + UO established; bicarbonate ONLY if pH < 6.9 + CV compromise; MONITOR for cerebral edema (HA, AMS, bradycardia, HT, sudden change) — mannitol or 3% HTS if suspected; transition to SC insulin when bicarbonate > 18, pH > 7.3, AG closed, eating; diabetes team consultation + family education

---

Pediatric DKA: high risk cerebral edema (mortality 20-25%, most common DKA death in peds). Key differences from adult: cautious fluid over 48h; NO insulin bolus; delayed insulin start; aggressive K replacement; avoid bicarbonate; high suspicion for cerebral edema. Glaser PECARN 2018: fast vs slow fluid + 0.45% vs 0.9% — both safe. Modern: gentle resuscitation + close monitoring + multidisciplinary team.', NULL,
  'hard', 'endocrine_metabolic', 'review',
  'pediatrics', 'clinical_decision', 'endocrine_metabolic', 'peds',
  'ISPAD Guidelines DKA 2022; Glaser PECARN NEJM 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 12 ปี polyuria + polydipsia + น้ำหนักลด 6 kg × 2 เดือน + เหนื่อย + คลื่นไส้ + อาเจียน 6 ชม

V/S: BP 102/64, HR 124, RR 32 (Kussmaul), Temp 36.8°C, DTX HI
Gen: dehydrated, GCS 13, capillary refill 4 sec

ABG: pH 7.10, PaCO2 18, HCO3 6
Lab: Glucose 685, Na 132, K 5.4, BUN 28, Cr 1.0, Ketone urine 3+, AG 30
New DM type 1'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 5 ปี ไข้สูง + คอแข็ง + ปวดศีรษะ + ซึม + กระสับกระส่าย × 24 ชม Vaccine complete

V/S: BP 98/62, HR 142, RR 32, Temp 39.6°C
GCS 12, neck stiffness +, Kernig + Brudzinski +
Mild petechial rash chest

CBC: WBC 22,500, CRP 285, Lactate 4.2
CT brain: normal
LP: WBC 1,850 (PMN 95%), Protein 220, Glucose 18, Gram stain: gram-neg diplococci', '[{"label":"A","text":"Wait for culture before any antibiotic"},{"label":"B","text":"Bacterial Meningitis likely Meningococcus (gram-neg diplococci + petechiae)"},{"label":"C","text":"Discharge with oral antibiotic"},{"label":"D","text":"Acyclovir only"},{"label":"E","text":"Steroid only without antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bacterial Meningitis likely Meningococcus (gram-neg diplococci + petechiae): IMMEDIATE IV antibiotic within 1h — Ceftriaxone 100 mg/kg/d + Vancomycin 60 mg/kg/d (until Spn sens known); Dexamethasone 0.15 mg/kg q6h × 2-4d (give before/with first antibiotic); resuscitation; ICU monitoring; droplet isolation 24h; public health reporting; chemoprophylaxis close contacts (rifampin, cipro, ceftriaxone single dose); audiology follow-up (hearing loss risk)

---

Bacterial meningitis = peds emergency. Gram-neg diplococci → N. meningitidis. Time to antibiotic = key prognostic factor — give within 1h. Empiric ceftriaxone + vancomycin. Dexamethasone before/with antibiotic. Isolation + chemoprophylaxis for meningococcal contacts. Long-term: hearing + developmental follow-up. MenACWY + MenB vaccines.', NULL,
  'medium', 'id', 'review',
  'pediatrics', 'clinical_decision', 'id', 'peds',
  'AAP Red Book 2024; IDSA Bacterial Meningitis Guideline 2004', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 5 ปี ไข้สูง + คอแข็ง + ปวดศีรษะ + ซึม + กระสับกระส่าย × 24 ชม Vaccine complete

V/S: BP 98/62, HR 142, RR 32, Temp 39.6°C
GCS 12, neck stiffness +, Kernig + Brudzinski +
Mild petechial rash chest

CBC: WBC 22,500, CRP 285, Lactate 4.2
CT brain: normal
LP: WBC 1,850 (PMN 95%), Protein 220, Glucose 18, Gram stain: gram-neg diplococci'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 18 เดือน development normal มา ED ชักทั้งตัว tonic-clonic 5 นาที ขณะไข้ 39.8°C จาก URI เริ่ม 2 ชม ก่อน หลังชักซึม 10-15 นาทีแล้วฟื้นปกติ ครอบครัวพ่อมีประวัติ febrile seizure

ไม่มี neuro deficit, neck supple, fontanelle ปกติ, no rash
WBC 9,200, glucose 96', '[{"label":"A","text":"Admit for EEG + MRI + LP mandatory"},{"label":"B","text":"Simple Febrile Seizure (6 mo-5 yr, generalized, < 15 min, single in 24h, normal exam)"},{"label":"C","text":"Long-term phenytoin prophylaxis"},{"label":"D","text":"Discharge without counseling"},{"label":"E","text":"Continuous IV anticonvulsant infusion"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Simple Febrile Seizure (6 mo-5 yr, generalized, < 15 min, single in 24h, normal exam): Reassurance (cornerstone — usually benign, recurrence 30%, epilepsy 2-5%); treat fever source (URI viral here); antipyretics for comfort (NOT to prevent recurrence — proven no benefit); NO routine EEG/MRI/LP for simple FS with normal exam in non-toxic well-vaccinated child > 12 mo; NO anticonvulsant prophylaxis; counsel parents: recurrence, safety, when to call EMS (> 5 min, breathing trouble); complex FS (focal, > 15 min, recurrent in 24h, abnormal exam) → fuller workup

---

Simple Febrile Seizure: 6 mo-5 yr, fever > 38°C, generalized, < 15 min, single in 24h, normal exam, no CNS infection/metabolic cause. Most common peds seizure (3-5%). Strong familial. Recurrence 30%, epilepsy 2-3% (vs 1% baseline). AAP 2011/2018: minimal workup if classic + well-appearing + > 12 mo + vaccines complete. No prophylactic anticonvulsant. Education + reassurance + safety.', NULL,
  'easy', 'neurology', 'review',
  'pediatrics', 'clinical_decision', 'neurology', 'peds',
  'AAP Febrile Seizures Guideline 2011, re-affirmed 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 18 เดือน development normal มา ED ชักทั้งตัว tonic-clonic 5 นาที ขณะไข้ 39.8°C จาก URI เริ่ม 2 ชม ก่อน หลังชักซึม 10-15 นาทีแล้วฟื้นปกติ ครอบครัวพ่อมีประวัติ febrile seizure

ไม่มี neuro deficit, neck supple, fontanelle ปกติ, no rash
WBC 9,200, glucose 96'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 3 ปี healthy มา ED ไอเสียงดังบ่อย ๆ + เหมือนสำลัก + stridor inspiratory × 30 นาที ลดลงเล็กน้อย ยังมีอยู่ ไม่มีไข้ ประวัติเล่นกับถั่วลิสง 30 นาทีก่อน

V/S: HR 132, RR 28, SpO2 94%
Gen: anxious, mild distress
Stridor inspiratory mild, air entry decreased RLL, no wheeze

CXR (expiratory): RLL hyperinflation + slight mediastinal shift', '[{"label":"A","text":"Discharge — likely viral croup"},{"label":"B","text":"Suspected Foreign Body Aspiration (peds emergency)"},{"label":"C","text":"Heimlich maneuver in office"},{"label":"D","text":"Antibiotic + bronchodilator + outpatient"},{"label":"E","text":"Steroid alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Suspected Foreign Body Aspiration (peds emergency): clinical history + asymmetric breath sounds + CXR signs = high suspicion; don''t disturb child (avoid converting partial to complete obstruction); allow comfortable position + O2; avoid blind finger sweep, back blows/abdominal thrust (per AHA peds BLS — only for complete obstruction with no air movement); urgent RIGID bronchoscopy in OR under GA by experienced peds ENT + anesthesia (diagnosis + removal); CT chest if equivocal but don''t delay; post-extraction monitor edema (steroid), pneumonia; prevention counseling — high-risk foods < 4 yr

---

FBA — most common accidental death in toddlers. Peak 1-3 yr. Peanuts, popcorn, grapes, hot dogs, beads. Triad: choking + cough + wheeze (50%). CXR normal in 25% (radiolucent). Asymmetric breath sounds, air trapping, atelectasis, mediastinal shift on expiratory film. Rigid bronchoscopy by experienced team. Don''t agitate child + avoid blind interventions. AHA BLS: back blows/thrusts only for complete obstruction without air movement.', NULL,
  'medium', 'respiratory', 'review',
  'pediatrics', 'clinical_decision', 'respiratory', 'peds',
  'AAP Section on Otolaryngology — FBA; AHA Guidelines CPR 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 3 ปี healthy มา ED ไอเสียงดังบ่อย ๆ + เหมือนสำลัก + stridor inspiratory × 30 นาที ลดลงเล็กน้อย ยังมีอยู่ ไม่มีไข้ ประวัติเล่นกับถั่วลิสง 30 นาทีก่อน

V/S: HR 132, RR 28, SpO2 94%
Gen: anxious, mild distress
Stridor inspiratory mild, air entry decreased RLL, no wheeze

CXR (expiratory): RLL hyperinflation + slight mediastinal shift'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 6 ปี บวมรอบตา + ขา + ท้อง 1 สัปดาห์ ปัสสาวะออกน้อย สีคล้ายเบียร์เข้ม

V/S: BP 138/88 (high for age), HR 92
PE: periorbital + lower extremity pitting edema + mild ascites

Urinalysis: protein 4+, blood 3+, RBC casts + dysmorphic RBCs
Lab: Albumin 1.8, Cr 0.8, Chol 380, C3 ต่ำ, C4 ปกติ, ASO 480 (high)

ก่อน 3 สัปดาห์ pharyngitis ไม่รักษา', '[{"label":"A","text":"Steroid pulse therapy high dose"},{"label":"B","text":"Post-streptococcal AGN (PSGN)"},{"label":"C","text":"Renal transplant evaluation"},{"label":"D","text":"Aggressive immunosuppression"},{"label":"E","text":"Discharge with high-protein diet"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-streptococcal AGN (PSGN) — classic features: nephritic syndrome, low C3 + normal C4, ASO elevated, RBC casts, recent strep: Supportive care (mainstay — usually self-limiting in children > 95% recover): salt + fluid restriction, diuretic (furosemide) for edema + HT, antihypertensive if severe; NO routine steroid; Penicillin × 10 days (eradicate strep + prevent transmission, not change PSGN course); Monitor BP, UO, weight, electrolytes, Cr; C3 normalize within 8 wk — if persistent → biopsy + DDx (MPGN, lupus, dense deposit); long-term follow-up 1-2 yr

---

PSGN — classic peds nephritic syndrome 1-3 wk after GAS infection. Immune complex deposition. Features: hematuria + RBC casts + proteinuria + HT + edema + AKI + LOW C3 + normal C4 + elevated ASO. Self-limiting > 95% children. Supportive care. NO routine steroid. C3 normalize 6-8 wk — if persistent → biopsy. DDx: IgA (C3 normal), MPGN (C3 persistent low), Lupus (C3 + C4 low + ANA), HSP (purpura + GI + joints).', NULL,
  'medium', 'renal_gu', 'review',
  'pediatrics', 'clinical_decision', 'renal_gu', 'peds',
  'KDIGO Glomerulonephritis Guideline 2021; Rodriguez-Iturbe B CJASN 2014', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 6 ปี บวมรอบตา + ขา + ท้อง 1 สัปดาห์ ปัสสาวะออกน้อย สีคล้ายเบียร์เข้ม

V/S: BP 138/88 (high for age), HR 92
PE: periorbital + lower extremity pitting edema + mild ascites

Urinalysis: protein 4+, blood 3+, RBC casts + dysmorphic RBCs
Lab: Albumin 1.8, Cr 0.8, Chol 380, C3 ต่ำ, C4 ปกติ, ASO 480 (high)

ก่อน 3 สัปดาห์ pharyngitis ไม่รักษา'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารก 36h GA 34 wk preterm BW 1,800g มาด้วย apnea + cyanosis + lethargy 2 ชม ก่อน ก่อนหน้านี้กินนมได้ดี

V/S: HR 168, BP 56/32 (hypotensive), RR irregular + apnea, Temp 35.8°C (hypothermia), SpO2 88%
Gen: lethargic, poor perfusion
Mother: GBS unknown, ROM 18h, intrapartum fever 38.4°C

Lab: WBC 4,200 (band 24%, I/T 0.4), Plt 102K
ABG: pH 7.20, HCO3 14, Lactate 4.8
CRP 28 (high for neonate)', '[{"label":"A","text":"Observation 24 hours"},{"label":"B","text":"Early-Onset Neonatal Sepsis (< 72h"},{"label":"C","text":"Discharge home with parental observation"},{"label":"D","text":"Oral antibiotic"},{"label":"E","text":"Hold antibiotic until culture grows"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Early-Onset Neonatal Sepsis (< 72h — likely GBS, E. coli, Listeria from maternal source): Immediate IV antibiotic within 1h — Ampicillin (GBS, Listeria, susceptible E. coli) + Gentamicin (gram-neg + synergy); cefotaxime if meningitis (NOT ceftriaxone in neonates — kernicterus + Ca precipitation); Septic workup: blood culture × 2, CBC, CRP serial, urine culture (if > 6 days), LP if possible, CXR; Resuscitation: warming, fluid bolus 10-20 mL/kg, vasopressor for hypotension, intubation if needed; NICU; Duration: 10-14d bacteremia, 14-21d meningitis; modify per culture; family support; long-term developmental follow-up

---

Neonatal sepsis: early-onset < 72h (vertical from mother — GBS, E. coli, Listeria) vs late-onset > 72h (hospital/community). Risk factors: prematurity, prolonged ROM > 18h, maternal intrapartum fever, GBS unknown. Signs subtle: temperature instability (hypo > hyper), apnea, poor feeding, lethargy. Sepsis screen: CBC + I/T ratio + CRP + culture. Empirical antibiotic ASAP: ampicillin + gentamicin (NOT ceftriaxone). LP if possible. NICU resuscitation. Duration based on organism + culture + clinical.', NULL,
  'hard', 'id', 'review',
  'pediatrics', 'clinical_decision', 'id', 'peds',
  'AAP Red Book 2024; AAP COFN Suspected Early-Onset Sepsis 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารก 36h GA 34 wk preterm BW 1,800g มาด้วย apnea + cyanosis + lethargy 2 ชม ก่อน ก่อนหน้านี้กินนมได้ดี

V/S: HR 168, BP 56/32 (hypotensive), RR irregular + apnea, Temp 35.8°C (hypothermia), SpO2 88%
Gen: lethargic, poor perfusion
Mother: GBS unknown, ROM 18h, intrapartum fever 38.4°C

Lab: WBC 4,200 (band 24%, I/T 0.4), Plt 102K
ABG: pH 7.20, HCO3 14, Lactate 4.8
CRP 28 (high for neonate)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิง 14 เดือน normal development จน 9 เดือน หลังจากนั้นช้าลง: ไม่นั่งจน 14 เดือน, ไม่พูดคำ, ไม่ตอบสนองชื่อ, eye contact ลดลง, head circumference จาก 75th → 25th percentile

ไม่มี dysmorphic features
Family: น้องคนพี่ healthy, ไม่มีประวัติพันธุกรรม', '[{"label":"A","text":"Normal variation, observe"},{"label":"B","text":"Global Developmental Delay + Regression + Microcephaly progression"},{"label":"C","text":"Refer adult psychiatry"},{"label":"D","text":"Lifestyle change only"},{"label":"E","text":"MRI without other workup"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Global Developmental Delay + Regression + Microcephaly progression — neurodegenerative concern (Rett syndrome in girls, mitochondrial, leukodystrophy, neurometabolic): multidisciplinary referral — dev peds, neuro, genetics; Tier 1: chromosomal microarray + Fragile X + MECP2 (Rett — regression 6-18 mo + microcephaly + hand stereotypies + lost purposeful hand use + breathing irregularities); brain MRI; metabolic screen (ammonia, lactate, AA, OA, acylcarnitine, VLCFA, MPS, lysosomal); TSH, CK; Tier 2: whole exome sequencing, mtDNA; Early intervention (don''t wait for dx): PT/OT/speech; Family support + genetic counseling; symptomatic + specific treatments for some metabolic disorders

---

Developmental regression + microcephaly progression = red flag for neurodegenerative disease. Rett syndrome: girls, 6-18 mo regression + lost hand use + stereotypies + microcephaly progression + breathing irregularities + seizures — MECP2 gene (X-linked). Other: neurometabolic, leukodystrophies, neurogenetic syndromes. Tiered workup. Early intervention essential. Multidisciplinary: dev peds, neuro, genetics, therapies, family.', NULL,
  'hard', 'neurology', 'review',
  'pediatrics', 'clinical_decision', 'neurology', 'peds',
  'AAP Comprehensive Evaluation of Children with GDD 2014; RettSearch Consensus Criteria 2010', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิง 14 เดือน normal development จน 9 เดือน หลังจากนั้นช้าลง: ไม่นั่งจน 14 เดือน, ไม่พูดคำ, ไม่ตอบสนองชื่อ, eye contact ลดลง, head circumference จาก 75th → 25th percentile

ไม่มี dysmorphic features
Family: น้องคนพี่ healthy, ไม่มีประวัติพันธุกรรม'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 7 ปี น้ำหนัก 24 kg underlying asthma ICS regular มา ED ด้วยอาการเหนื่อย + wheeze ต่อเนื่อง 6 ชม ก่อนหน้านี้พ่นยา salbutamol ที่บ้านทุก 2 ชม ไม่ดีขึ้น

V/S: HR 142, RR 38, SpO2 88% room air, Temp 36.8°C
Gen: tired, unable to complete sentences
Use accessory muscles, suprasternal + intercostal retraction marked
Wheezing both lungs, expiratory phase prolonged', '[{"label":"A","text":"Salbutamol nebulization × 1 dose then reassess in 20 min"},{"label":"B","text":"Severe asthma exacerbation (PRAM/PASS high score)"},{"label":"C","text":"ICS increased dose + observe 1 hour"},{"label":"D","text":"Subcutaneous epinephrine + heliox"},{"label":"E","text":"Intubate immediately"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe asthma exacerbation (PRAM/PASS high score): continuous nebulized SABA (salbutamol) + ipratropium nebulization (synergistic) × 3 stacked doses; systemic corticosteroid (oral pred 1-2 mg/kg or IV methylprednisolone 1 mg/kg); IV magnesium sulfate 25-50 mg/kg over 20 min (severe not responding); supplemental O2 to SpO2 ≥ 94%; prepare PICU; consider IV terbutaline, ketamine, or NIV/intubation for impending failure; chest X-ray if focal finding or atypical; admit; follow-up: action plan, ICS optimization, allergy + trigger review

---

Severe peds asthma exacerbation: failed home SABA + signs of severe distress (RR ↑, SpO2 < 92%, accessory muscle use, unable to speak in sentences). GINA + AAP: continuous nebulized SABA + ipratropium; systemic steroid (oral if tolerating, IV if not); IV MgSO4 for severe not responding to SABA dose 1; O2 to ≥ 94%; PICU for not improving. Intubation last resort (high barotrauma risk in status asthmaticus).', NULL,
  'medium', 'respiratory', 'review',
  'pediatrics', 'clinical_decision', 'respiratory', 'peds',
  'GINA 2024 Global Strategy for Asthma; AAP Acute Asthma Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 7 ปี น้ำหนัก 24 kg underlying asthma ICS regular มา ED ด้วยอาการเหนื่อย + wheeze ต่อเนื่อง 6 ชม ก่อนหน้านี้พ่นยา salbutamol ที่บ้านทุก 2 ชม ไม่ดีขึ้น

V/S: HR 142, RR 38, SpO2 88% room air, Temp 36.8°C
Gen: tired, unable to complete sentences
Use accessory muscles, suprasternal + intercostal retraction marked
Wheezing both lungs, expiratory phase prolonged'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 2 ปี ก่อนหน้านี้ healthy มาด้วยอาการไอเสียงเห่า (barking) + stridor inspiratory + hoarseness + ไข้ต่ำ 38.2°C เริ่ม 24 ชม ก่อน ก่อนหน้านี้มี URI 2 วัน

V/S: HR 132, RR 32, SpO2 95% room air
Gen: alert, mild distress at rest, no drooling, no toxic appearance
Stridor inspiratory at rest, mild retraction, no cyanosis
Voice hoarse, barking cough

Westley croup score = 4 (moderate)', '[{"label":"A","text":"Intubation immediately"},{"label":"B","text":"Moderate Croup (viral laryngotracheobronchitis, often parainfluenza)"},{"label":"C","text":"IV antibiotic + admit"},{"label":"D","text":"Albuterol + ipratropium"},{"label":"E","text":"Discharge with cough syrup only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Moderate Croup (viral laryngotracheobronchitis, often parainfluenza): Dexamethasone 0.6 mg/kg PO/IV/IM single dose (or budesonide nebulization 2 mg as alternative) — Cochrane evidence reduces revisits, hospitalizations, intubation; Nebulized racemic epinephrine 2.25% 0.5 mL or L-epinephrine 5 mL of 1:1000 for moderate-severe distress at rest (immediate relief but observe 3-4h for rebound); humidified air NOT proven; supportive care, hydration, antipyretic; admit if persistent stridor at rest after Rx, hypoxia, dehydration, comorbidity; discharge home with parental education + return precautions

---

Croup (viral) common 6 mo-6 yr, parainfluenza most. Westley score grades severity: 0-2 mild, 3-5 moderate, 6-11 severe, 12+ impending failure. Mild: dexamethasone + discharge. Moderate-severe: + nebulized epinephrine, observe 3-4h. DDx: epiglottitis (toxic, drooling, tripod — Hib vaccine reduced), bacterial tracheitis, FBA, retropharyngeal abscess. Humidified air debunked. Single-dose dex effective.', NULL,
  'easy', 'respiratory', 'review',
  'pediatrics', 'clinical_decision', 'respiratory', 'peds',
  'AAP Section on Otolaryngology; Bjornson CL et al. NEJM 2004 (Dexamethasone in Croup)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 2 ปี ก่อนหน้านี้ healthy มาด้วยอาการไอเสียงเห่า (barking) + stridor inspiratory + hoarseness + ไข้ต่ำ 38.2°C เริ่ม 24 ชม ก่อน ก่อนหน้านี้มี URI 2 วัน

V/S: HR 132, RR 32, SpO2 95% room air
Gen: alert, mild distress at rest, no drooling, no toxic appearance
Stridor inspiratory at rest, mild retraction, no cyanosis
Voice hoarse, barking cough

Westley croup score = 4 (moderate)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 18 เดือน มาด้วยไข้สูง 39.4°C × 48 ชม ไม่มีอาการระบุชัดเจน irritable + ดื่มน้ำน้อยลง ปัสสาวะออกน้อย

Vaccine complete
V/S: HR 132, BP 92/58, RR 24, Temp 39.4°C
Gen: irritable, well-hydrated mostly
Kidney area: percussion tenderness left

Urinalysis (catheter sample): WBC > 100, nitrite +, leukocyte esterase +, bacteria +
Urine culture: pending
CBC: WBC 16,500, CRP 88', '[{"label":"A","text":"Wait for culture, no treatment"},{"label":"B","text":"Febrile UTI / Pyelonephritis (toddler with positive UA + flank tenderness)"},{"label":"C","text":"Symptomatic only"},{"label":"D","text":"Surgery immediately"},{"label":"E","text":"Long-term prophylactic antibiotic for all"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Febrile UTI / Pyelonephritis (toddler with positive UA + flank tenderness): Empirical antibiotic — oral if tolerating + non-toxic (cefixime, cefpodoxime, amoxicillin-clavulanate) × 7-10 days OR IV if toxic/dehydrated/refusing PO (ceftriaxone 50 mg/kg/d then switch to PO); urine culture to guide; renal/bladder US within 2 weeks (AAP 2011 — first febrile UTI all children 2-24 mo); VCUG only if abnormal US or recurrence (AAP 2011 change from prior recommendation); follow-up: clinical resolution, repeat UA + culture only if persistent symptoms; counsel: hygiene, hydration, recognize recurrence symptoms; long-term: minority develop renal scarring (5-15%) — risk factor VUR

---

Pediatric UTI: 2-24 mo with fever, esp female + uncircumcised male, requires evaluation. Catheterized or suprapubic specimen (bag culture unreliable). E. coli most common. AAP 2011 (revised 2016): empirical antibiotic (oral OK if non-toxic) 7-10 d; US within 2 wk first febrile UTI; VCUG only if abnormal US or recurrence (departed from prior). Long-term: renal scarring risk in minority; VUR association. Counsel hygiene + hydration + recurrence signs.', NULL,
  'easy', 'renal_gu', 'review',
  'pediatrics', 'clinical_decision', 'renal_gu', 'peds',
  'AAP Subcommittee on Urinary Tract Infection — Clinical Practice Guideline 2011, re-affirmed 2016', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 18 เดือน มาด้วยไข้สูง 39.4°C × 48 ชม ไม่มีอาการระบุชัดเจน irritable + ดื่มน้ำน้อยลง ปัสสาวะออกน้อย

Vaccine complete
V/S: HR 132, BP 92/58, RR 24, Temp 39.4°C
Gen: irritable, well-hydrated mostly
Kidney area: percussion tenderness left

Urinalysis (catheter sample): WBC > 100, nitrite +, leukocyte esterase +, bacteria +
Urine culture: pending
CBC: WBC 16,500, CRP 88'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกชายอายุ 5 สัปดาห์ มาด้วยอาการอาเจียนพุ่ง (projectile) ทุกมื้อนม 2 สัปดาห์ น้ำหนักลด 200 g ก่อนหน้านี้กินดี

V/S: HR 142, dehydration moderate
Gen: hungry after vomiting ("hungry vomiter")
Abdomen: visible peristalsis epigastrium + palpable "olive-like" mass RUQ

Lab: Na 134, K 3.2 (low), Cl 92 (low), HCO3 32 (high) — hypochloremic, hypokalemic metabolic alkalosis
US abdomen: pyloric muscle thickness 5 mm, pyloric channel length 18 mm — consistent with hypertrophic pyloric stenosis', '[{"label":"A","text":"Emergent surgery without correction"},{"label":"B","text":"Hypertrophic Pyloric Stenosis"},{"label":"C","text":"Antibiotic + observation"},{"label":"D","text":"Endoscopy"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hypertrophic Pyloric Stenosis: correct electrolyte + dehydration FIRST before surgery (NOT a surgical emergency — metabolic correction critical): IV NSS 20 mL/kg bolus if shock, then D5 1/2 NS + KCl 20-40 mEq/L at 1.5-2× maintenance; goal: Cl > 100, HCO3 < 26-30, K > 3.5, urine Cl > 20; NPO + NG decompression if vomiting; then Ramstedt pyloromyotomy (open or laparoscopic) — definitive, excellent outcomes; post-op: feeds advance within 4-8h; rarely persistent vomiting; counsel parents: not preventable, very good prognosis

---

Hypertrophic Pyloric Stenosis: presents 2-12 wk (peak 3-5 wk), males 4:1, firstborn. Projectile non-bilious vomiting + hungry after + visible peristalsis + olive mass (60%). US diagnostic (muscle > 4 mm, channel > 15 mm). Classic: hypochloremic hypokalemic metabolic alkalosis from loss of HCl. CORRECT METABOLIC DERANGEMENT FIRST (not surgical emergency). Anesthesia risk if not corrected (paradoxic aciduria, post-op apnea). Ramstedt pyloromyotomy curative. Excellent prognosis.', NULL,
  'easy', 'gi', 'review',
  'pediatrics', 'clinical_decision', 'gi', 'peds',
  'AAP Section on Surgery; Pandya S, Heiss K. Pediatr Clin North Am 2012', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกชายอายุ 5 สัปดาห์ มาด้วยอาการอาเจียนพุ่ง (projectile) ทุกมื้อนม 2 สัปดาห์ น้ำหนักลด 200 g ก่อนหน้านี้กินดี

V/S: HR 142, dehydration moderate
Gen: hungry after vomiting ("hungry vomiter")
Abdomen: visible peristalsis epigastrium + palpable "olive-like" mass RUQ

Lab: Na 134, K 3.2 (low), Cl 92 (low), HCO3 32 (high) — hypochloremic, hypokalemic metabolic alkalosis
US abdomen: pyloric muscle thickness 5 mm, pyloric channel length 18 mm — consistent with hypertrophic pyloric stenosis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกแรกเกิด GA 38 wk BW 3.2 kg วันที่ 4 หลังเกิด มีอาการตัวเหลือง พ่อแม่กังวล

V/S: stable, breastfeeding ปานกลาง (น้ำหนักลด 9% ของน้ำหนักแรกเกิด), urine output ปานกลาง
Gen: alert, jaundice ลามถึงท้องและขา

Blood group: mother O+, baby A+, DAT positive
Total bilirubin: 22 mg/dL (high), Direct 0.8
Hb 14.2, retic 4% (high), peripheral smear: spherocytes, microspherocytes', '[{"label":"A","text":"Observation only"},{"label":"B","text":"Neonatal Hyperbilirubinemia from ABO incompatibility hemolysis (high risk per AAP Bhutani nomogram > 95th percentile + risk factors)"},{"label":"C","text":"Discharge with sunlight exposure"},{"label":"D","text":"Stop breastfeeding permanently"},{"label":"E","text":"IV antibiotic only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neonatal Hyperbilirubinemia from ABO incompatibility hemolysis (high risk per AAP Bhutani nomogram > 95th percentile + risk factors): immediate intensive phototherapy (target > 12 cm² body surface); hydration support (continue breastfeeding + supplementation if needed — NOT routine IVF unless dehydrated); exchange transfusion threshold based on age + risk + bilirubin trend (per AAP 2022 guideline curves) — typically TSB > 25 mg/dL in term healthy or > 20 + risk factors; monitor TSB q4-6h; check for ABO/Rh, G6PD, sepsis, sepsis, infection; phototherapy continued until TSB safely below threshold; long-term hearing screen (kernicterus = irreversible brain damage); counsel parents

---

Neonatal hyperbilirubinemia: physiologic (peak day 3-5, < 12 mg/dL term) vs pathologic (early < 24h, rapid rise, prolonged, direct > 20%). Causes: hemolytic (ABO, Rh, G6PD, hereditary spherocytosis), polycythemia, breastfeeding (suboptimal feeding) vs breast milk (later, > 7d), sepsis, hypothyroidism, biliary atresia (direct). AAP 2022 guidelines: TSB-age-based curves. Phototherapy first-line. Exchange for very high TSB. Kernicterus = bilirubin encephalopathy (lethargy, hypertonia, opisthotonos, sensorineural hearing loss).', NULL,
  'medium', 'hematology', 'review',
  'pediatrics', 'clinical_decision', 'hematology', 'peds',
  'AAP Clinical Practice Guideline: Hyperbilirubinemia in the Newborn 2022', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกแรกเกิด GA 38 wk BW 3.2 kg วันที่ 4 หลังเกิด มีอาการตัวเหลือง พ่อแม่กังวล

V/S: stable, breastfeeding ปานกลาง (น้ำหนักลด 9% ของน้ำหนักแรกเกิด), urine output ปานกลาง
Gen: alert, jaundice ลามถึงท้องและขา

Blood group: mother O+, baby A+, DAT positive
Total bilirubin: 22 mg/dL (high), Direct 0.8
Hb 14.2, retic 4% (high), peripheral smear: spherocytes, microspherocytes'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกแรกเกิด GA 39 wk BW 3.4 kg อายุ 2 วัน มีอาการ central cyanosis ต่อเนื่อง SpO2 78% pre-ductal และ 76% post-ductal, ไม่ดีขึ้นด้วย O2 100%

V/S: HR 152, RR 58, BP 64/40, Temp 36.8°C
PE: no respiratory distress, well-perfused, no murmur clearly heard

Hyperoxia test: PaO2 from 38 → 62 (failed to rise > 150 — suggests cardiac cause)
CXR: "egg on a string" appearance + decreased pulmonary vasculature
Echo: D-Transposition of Great Arteries (D-TGA), intact ventricular septum, small PDA, small PFO', '[{"label":"A","text":"Observation 24 hours"},{"label":"B","text":"Critical cyanotic congenital heart disease (D-TGA)"},{"label":"C","text":"Discharge with oxygen at home"},{"label":"D","text":"Diuretic alone"},{"label":"E","text":"Antibiotic only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Critical cyanotic congenital heart disease (D-TGA) — neonatal emergency: Maintain ductal patency — PROSTAGLANDIN E1 (alprostadil) IV infusion 0.05-0.1 mcg/kg/min (start immediately; allows mixing through PDA between parallel circulations); monitor for side effects (apnea, hypotension, fever); NICU/cardiac ICU admission; pediatric cardiology consult — cardiac catheterization + balloon atrial septostomy (Rashkind) within hours (improves mixing at atrial level); definitive surgery — arterial switch operation (ASO/Jatene) within first 2-3 weeks of life; pre-op stabilization: avoid hyperoxia + acidosis + temperature derangement; family counseling + multidisciplinary cardiac team

---

Critical cyanotic CHD presenting early: D-TGA most common (egg-on-string CXR); also TAPVR, Tricuspid atresia, Truncus, Tetralogy + critical PS. Ductal-dependent — PGE1 maintains PDA for circulation mixing/blood flow. Hyperoxia test failed PaO2 < 150 = likely cardiac. Echo confirms. Rashkind balloon atrial septostomy = bridge. Arterial switch (Jatene) within 2-3 weeks. Pulse oximetry screening newborn (post-ductal > 95% + < 3% difference pre/post-ductal) — universal in many countries.', NULL,
  'hard', 'cardiovascular', 'review',
  'pediatrics', 'clinical_decision', 'cardiovascular', 'peds',
  'AHA Scientific Statement: Pediatric Cardiology; AAP Newborn Pulse Oximetry Screening Endorsement', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกแรกเกิด GA 39 wk BW 3.4 kg อายุ 2 วัน มีอาการ central cyanosis ต่อเนื่อง SpO2 78% pre-ductal และ 76% post-ductal, ไม่ดีขึ้นด้วย O2 100%

V/S: HR 152, RR 58, BP 64/40, Temp 36.8°C
PE: no respiratory distress, well-perfused, no murmur clearly heard

Hyperoxia test: PaO2 from 38 → 62 (failed to rise > 150 — suggests cardiac cause)
CXR: "egg on a string" appearance + decreased pulmonary vasculature
Echo: D-Transposition of Great Arteries (D-TGA), intact ventricular septum, small PDA, small PFO'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 8 เดือน มาด้วยผิวซีดมา 2 เดือน อ่อนเพลีย กินอาหารน้อย ส่วนใหญ่ดื่มนมวัวมาก (1.5 L/day) ตั้งแต่ 6 เดือน ไม่กินอาหารแข็ง

V/S: HR 132 (tachycardia), BP 88/52, Temp 36.8°C
Gen: pale, irritable, developmental milestones at age level
Mild systolic murmur grade 2/6 (flow murmur)

Lab: Hb 6.4 (severe anemia), MCV 58 (microcytic), MCH 18 (hypochromic), RDW 22% (high), Reticulocyte 1.0%, Ferritin 4 ng/mL (very low), Iron 18, TIBC 520, Transferrin sat 4%
Thalassemia screening: negative', '[{"label":"A","text":"Transfusion immediately"},{"label":"B","text":"Severe Iron Deficiency Anemia (cow milk excess + low intake of iron-rich food)"},{"label":"C","text":"IV iron infusion immediately"},{"label":"D","text":"Bone marrow biopsy"},{"label":"E","text":"Erythropoietin"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe Iron Deficiency Anemia (cow milk excess + low intake of iron-rich food): correctable nutritional cause: Oral iron supplementation 3-6 mg/kg/day elemental iron in divided doses (or single daily — equivalent efficacy with better adherence per recent evidence); vitamin C to enhance absorption (give with citrus juice not milk); limit cow milk to < 500 mL/day (cow milk inhibits iron absorption + GI microbleeding); introduce iron-rich complementary foods (meat, fortified cereal, beans, dark green vegetables); reassess Hb 4 weeks (expect rise 1-2 g/dL); continue iron 3 months after Hb normal to replete stores; severe symptomatic anemia (HR > 180, CHF, severe pallor): consider transfusion (small aliquots over time to avoid CHF — transfusion-related); investigate other causes if no response (occult blood loss, malabsorption, parasites); developmental follow-up (iron deficiency linked to cognitive deficits)

---

Pediatric IDA: peak 9-24 mo. Causes: cow milk excess > 500 mL/d (low Fe + induces GI microbleeding + low solid food intake); preemie/LBW (low stores); rapid growth. Diagnosis: microcytic hypochromic + low ferritin + low transferrin sat. DDx: thalassemia (high ferritin), anemia of chronic disease (high ferritin). Treatment: oral iron 3-6 mg/kg/d + vitamin C + dietary modification. Reassess 4 wk. Continue 3 mo post-Hb normal. Long-term: cognitive impact — early treatment important. Iron-fortified cereal + meat in complementary feeding (start 6 mo).', NULL,
  'easy', 'hematology', 'review',
  'pediatrics', 'clinical_decision', 'hematology', 'peds',
  'AAP Clinical Report: Diagnosis and Prevention of Iron Deficiency 2010', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 8 เดือน มาด้วยผิวซีดมา 2 เดือน อ่อนเพลีย กินอาหารน้อย ส่วนใหญ่ดื่มนมวัวมาก (1.5 L/day) ตั้งแต่ 6 เดือน ไม่กินอาหารแข็ง

V/S: HR 132 (tachycardia), BP 88/52, Temp 36.8°C
Gen: pale, irritable, developmental milestones at age level
Mild systolic murmur grade 2/6 (flow murmur)

Lab: Hb 6.4 (severe anemia), MCV 58 (microcytic), MCH 18 (hypochromic), RDW 22% (high), Reticulocyte 1.0%, Ferritin 4 ng/mL (very low), Iron 18, TIBC 520, Transferrin sat 4%
Thalassemia screening: negative'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 2 ปี น้ำหนัก 9 kg (< 3rd percentile) ส่งจาก outpatient clinic ด้วยอาการน้ำหนักไม่เพิ่ม 6 เดือน + อาเจียนเป็นๆ หายๆ + กินอาหารน้อย + พัฒนาการช้า (ไม่พูดคำ ไม่เดินมั่นคง)

Family: parents working long hours, ทารกอยู่กับยายอายุ 75 ปี ภาวะเศรษฐกิจไม่ดี

Gen: pale, thin, lethargic, signs of micronutrient deficiency (cheilosis, koilonychia)
Mild abdominal distension
No organomegaly
No dysmorphic features', '[{"label":"A","text":"Discharge with multivitamins"},{"label":"B","text":"Failure to Thrive"},{"label":"C","text":"Operate for suspected obstruction"},{"label":"D","text":"Antibiotic empirical"},{"label":"E","text":"Ignore — will catch up"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Failure to Thrive — multifactorial workup + multidisciplinary management: (1) Comprehensive history: diet (24h recall, food diary), feeding patterns, family + social, medical, GI symptoms; (2) Examination: anthropometrics (weight, height, head circumference, BMI plotted), signs of malnutrition + micronutrient deficiency, developmental assessment; (3) Workup: CBC, electrolytes, BUN, Cr, glucose, LFT, TSH, urinalysis, celiac serology, stool studies (O&P, occult blood); sweat chloride if suspicion CF; HIV; specific tests based on history; (4) Multidisciplinary: pediatrician, dietitian, social worker (food security, family support), developmental specialist, possibly psychiatry (eating disorder, depression), speech therapy (feeding/swallowing); (5) Nutritional rehabilitation: increase calorie density, supplemental feeds, NG/G-tube if severe; (6) Social interventions: food assistance, WIC, family support, evaluate for neglect (rare but consider); (7) Hospitalization criteria: severe malnutrition, refractory weight loss, suspected abuse/neglect, family inability to manage; (8) Re-feeding precaution if severe; (9) Long-term: developmental follow-up, school readiness, prevention of recurrence

---

Failure to Thrive (FTT) = inadequate growth (weight < 3rd or 5th percentile, weight loss, or crossing 2 major percentile lines downward). Causes: organic (5-10% — CF, CHD, GI malabsorption, metabolic, endocrine, neurologic), non-organic (psychosocial — most common — feeding interactions, neglect, food insecurity, depression, postpartum). Workup: history + exam first then targeted labs. Multidisciplinary essential. Treat cause. Nutritional rehab. Social intervention often key. Don''t miss neglect/abuse but don''t assume. Long-term: developmental, cognitive impacts.', NULL,
  'medium', 'signs_symptoms', 'review',
  'pediatrics', 'clinical_decision', 'signs_symptoms', 'peds',
  'AAP Section on Endocrinology; Cole SZ, Lanham JS. Am Fam Physician 2011 (FTT Review)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 2 ปี น้ำหนัก 9 kg (< 3rd percentile) ส่งจาก outpatient clinic ด้วยอาการน้ำหนักไม่เพิ่ม 6 เดือน + อาเจียนเป็นๆ หายๆ + กินอาหารน้อย + พัฒนาการช้า (ไม่พูดคำ ไม่เดินมั่นคง)

Family: parents working long hours, ทารกอยู่กับยายอายุ 75 ปี ภาวะเศรษฐกิจไม่ดี

Gen: pale, thin, lethargic, signs of micronutrient deficiency (cheilosis, koilonychia)
Mild abdominal distension
No organomegaly
No dysmorphic features'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 9 เดือน นำส่งโดยพ่อแม่ด้วยอาการ multiple bruises ที่ขา + แขน + หลัง + ก้น 3 สัปดาห์ ไม่มีประวัติบาดเจ็บที่ชัดเจน หรือเล่ามีแต่ "ตกจากเก้าอี้"

Vaccine partial (delayed)
Development delayed (no sitting at 9 months, no babbling)

V/S: HR 132, BP 88/56, Temp 36.8°C, น้ำหนัก < 5th percentile
PE: multiple bruises ในระยะต่างๆ (different colors — yellow, blue, purple) ที่ป้องและ non-bony sites; subconjunctival hemorrhage; circular bruise คล้ายรอยมือ
Fundoscopy: bilateral retinal hemorrhages multiple layers

Family: father unemployed, mother depressed', '[{"label":"A","text":"Discharge home with vitamin K"},{"label":"B","text":"Non-Accidental Injury (NAI) / Child Abuse"},{"label":"C","text":"Counsel parents and discharge"},{"label":"D","text":"Ignore — accidental"},{"label":"E","text":"Surgical correction of bruises"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Non-Accidental Injury (NAI) / Child Abuse — multiple red flags: history inconsistent with injuries, multiple bruises different ages on non-bony sites, retinal hemorrhages (shaken baby), developmental delay, parental risk factors. Mandatory action: (1) Admit hospital for safety + workup; (2) Comprehensive evaluation: skeletal survey (occult fractures — rib, metaphyseal), head CT (subdural hematoma, edema, axonal injury), abdominal CT if concern, ophthalmology (retinal hemorrhages — specific for abusive head trauma), bone scan if concerning, coagulation studies (rule out bleeding disorder); (3) MANDATORY REPORT to child protective services / police (legally required, do not delay or ask parents'' permission); (4) Multidisciplinary child protection team consultation; (5) Social work + psychiatric assessment of family; (6) Safety plan before discharge — may require foster care, kinship placement, or supervised visits; (7) Court testimony documentation; (8) Long-term: developmental, behavioral, psychological follow-up (high risk PTSD, attachment, future problems); (9) Sibling assessment (others at risk); (10) Treatment + support for non-offending parent if applicable

---

Child abuse / Non-Accidental Injury — high mortality (death in infants common): red flags = history inconsistent with injuries; injuries at different ages; non-bony sites (back, buttocks, ears, neck); patterns (handprint, bite, ligature); retinal hemorrhages bilateral multi-layer (abusive head trauma / shaken baby); rib fractures (esp posterior, in infants); developmental delay + neglect signs. Mandatory reporting (legally required, immediately, do not need parental permission). Skeletal survey + head imaging + ophthalmology. Multidisciplinary: pediatrics, child abuse specialist, social work, CPS, law enforcement, possibly forensics. Safety FIRST. Document carefully. Long-term outcomes worse if unrecognized + return to abusive environment.', NULL,
  'medium', 'trauma', 'review',
  'pediatrics', 'clinical_decision', 'trauma', 'peds',
  'AAP Committee on Child Abuse and Neglect; The Lancet Series on Child Maltreatment 2009', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 9 เดือน นำส่งโดยพ่อแม่ด้วยอาการ multiple bruises ที่ขา + แขน + หลัง + ก้น 3 สัปดาห์ ไม่มีประวัติบาดเจ็บที่ชัดเจน หรือเล่ามีแต่ "ตกจากเก้าอี้"

Vaccine partial (delayed)
Development delayed (no sitting at 9 months, no babbling)

V/S: HR 132, BP 88/56, Temp 36.8°C, น้ำหนัก < 5th percentile
PE: multiple bruises ในระยะต่างๆ (different colors — yellow, blue, purple) ที่ป้องและ non-bony sites; subconjunctival hemorrhage; circular bruise คล้ายรอยมือ
Fundoscopy: bilateral retinal hemorrhages multiple layers

Family: father unemployed, mother depressed'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 5 ปี น้ำหนัก 18 kg มาด้วยอาการ chronic ไอเรื้อรัง + เหนื่อย + น้ำหนักไม่เพิ่ม 6 เดือน + ถ่ายอุจจาระมีน้ำมันมัน + อาเจียน

Vaccine complete
Family: ลูกพี่ลูกน้องสมาชิกครอบครัวมี cystic fibrosis

V/S: HR 102, RR 22, SpO2 96%, ไม่มีไข้
Gen: pale, thin, mild clubbing
Lungs: occasional crackles bilateral, mild expiratory wheeze
Abdomen: distended, mild tenderness, no hepatosplenomegaly
Pilonidal area: bulky stool noted on undergarment

Sweat chloride test: 78 mEq/L (high — > 60 = positive)
CFTR genetic testing: F508del homozygous
Fecal elastase: < 100 (pancreatic insufficiency)', '[{"label":"A","text":"Symptomatic only"},{"label":"B","text":"Cystic Fibrosis"},{"label":"C","text":"Steroid alone"},{"label":"D","text":"Probiotic only"},{"label":"E","text":"Discharge with cough syrup"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cystic Fibrosis — multisystem disease requiring multidisciplinary care: (1) Respiratory: airway clearance (chest physiotherapy, oscillating PEP, hypertonic saline neb, dornase alfa, exercise), CFTR modulator therapy (elexacaftor/tezacaftor/ivacaftor for F508del — "Trikafta" — major outcome improvement), antibiotic (acute exacerbations + chronic suppressive for Pseudomonas), inhaled antibiotics (tobramycin, aztreonam); (2) Pancreatic insufficiency: pancreatic enzyme replacement therapy (PERT — Creon) with meals, fat-soluble vitamin supplements (ADEK), high-calorie diet (120-150% RDA), salt supplementation; (3) Sweat chloride loss prevention: extra salt, hydration; (4) Endocrine: monitor for CF-related diabetes (annual OGTT from age 10), osteoporosis (DEXA); (5) GI: monitor for distal intestinal obstruction syndrome, biliary cirrhosis, GERD; (6) Reproductive: counseling (males infertile due CBAVD, females reduced fertility); (7) Vaccinations: all routine + annual influenza + pneumococcal + COVID; (8) Multidisciplinary CF center care: pediatric pulmonology, gastroenterology, nutritionist, social work, psychology, respiratory therapy; (9) Family genetic counseling (autosomal recessive); (10) Newborn screening confirmation in younger siblings; (11) Long-term: lung transplant evaluation when FEV1 < 30% predicted; survival ~ 50 years modern with Trikafta

---

Cystic Fibrosis: autosomal recessive, CFTR gene (most common F508del), affects exocrine glands. Multisystem: respiratory (chronic infection, bronchiectasis), pancreatic insufficiency (steatorrhea, FTT), CF-related diabetes, sweat chloride loss, infertility (CBAVD males), biliary, sinopulmonary, intestinal obstruction. Diagnosis: newborn screening (immunoreactive trypsinogen), sweat chloride > 60, CFTR genetic testing. Multidisciplinary CF center care. Trikafta (elexacaftor/tezacaftor/ivacaftor) revolutionized care for F508del. Survival ~ 50 yr modern. Lung transplant for end-stage.', NULL,
  'hard', 'respiratory', 'review',
  'pediatrics', 'clinical_decision', 'respiratory', 'peds',
  'Cystic Fibrosis Foundation Guidelines; Middleton PG et al. NEJM 2019 (Trikafta)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 5 ปี น้ำหนัก 18 kg มาด้วยอาการ chronic ไอเรื้อรัง + เหนื่อย + น้ำหนักไม่เพิ่ม 6 เดือน + ถ่ายอุจจาระมีน้ำมันมัน + อาเจียน

Vaccine complete
Family: ลูกพี่ลูกน้องสมาชิกครอบครัวมี cystic fibrosis

V/S: HR 102, RR 22, SpO2 96%, ไม่มีไข้
Gen: pale, thin, mild clubbing
Lungs: occasional crackles bilateral, mild expiratory wheeze
Abdomen: distended, mild tenderness, no hepatosplenomegaly
Pilonidal area: bulky stool noted on undergarment

Sweat chloride test: 78 mEq/L (high — > 60 = positive)
CFTR genetic testing: F508del homozygous
Fecal elastase: < 100 (pancreatic insufficiency)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'อาจารย์อธิบาย pediatric pharmacology — drug dosing differs from adults

คำถาม: หลักการ pediatric drug dosing + key developmental pharmacokinetic differences', '[{"label":"A","text":"Same dose as adult per body weight"},{"label":"B","text":"Pediatric dosing requires consideration of developmental pharmacokinetics"},{"label":"C","text":"Halve adult dose for all children"},{"label":"D","text":"Pediatric-specific dosing not necessary"},{"label":"E","text":"Use weight only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric dosing requires consideration of developmental pharmacokinetics: (1) Absorption — gastric pH higher in neonates (favors penicillin, disfavors weak acids); slower gastric emptying; (2) Distribution — higher % water (neonates 75% water vs adult 60% — increased Vd of water-soluble drugs like aminoglycosides); lower albumin (higher free fraction of bound drugs — bilirubin displacement risk in neonates with ceftriaxone, sulfa); BBB permeable in neonate; (3) Metabolism — CYP450 immature at birth → mature by age 1 (varies); UGT (glucuronidation) immature → ''gray baby syndrome'' with chloramphenicol; (4) Excretion — GFR low at birth, matures by 1 yr → renal drug dose adjustment; (5) Dosing methods: weight-based (mg/kg) for most; body surface area (m²) for chemotherapy; age-band approximations; (6) Special considerations: ceftriaxone CI in neonates < 4 wk (bilirubin displacement + Ca precipitation); chloramphenicol gray baby syndrome; tetracycline tooth/bone deposition < 8 yr; fluoroquinolone cartilage concern; aspirin Reye syndrome with viral illness; codeine/tramadol CI < 12 yr; benzyl alcohol toxicity in preservatives; (7) Always verify dose + use pediatric-specific resources

---

Pediatric pharmacology = different from adult due to developmental changes in ADME. Weight-based dosing standard. Special CI: ceftriaxone < 4 wk (bilirubin, Ca), chloramphenicol (gray baby), tetracycline < 8 yr (tooth, bone), fluoroquinolone (cartilage), aspirin + viral illness (Reye), codeine < 12 yr (variable metabolism, respiratory depression). Verify dose meticulously.', NULL,
  'medium', 'procedures', 'review',
  'pediatrics', 'basic_science', 'procedures', 'peds',
  'AAP Pediatric Clinical Pharmacology; Lexicomp Pediatric Drug Information', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'อาจารย์อธิบาย pediatric pharmacology — drug dosing differs from adults

คำถาม: หลักการ pediatric drug dosing + key developmental pharmacokinetic differences'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถาม physiology — neonatal transitional circulation', '[{"label":"A","text":"Same as adult"},{"label":"B","text":"Neonatal Transitional Circulation"},{"label":"C","text":"No transition occurs"},{"label":"D","text":"PDA never closes"},{"label":"E","text":"Foramen ovale always patent"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neonatal Transitional Circulation: fetal — high pulmonary vascular resistance (PVR), low systemic vascular resistance (SVR), R→L shunting through ductus arteriosus + foramen ovale + ductus venosus; oxygenation from placenta. AT BIRTH: (1) First breath expands lungs → ↓PVR + ↑oxygenation → pulmonary blood flow increases; (2) Cord clamping → loss of placental low-resistance circuit → ↑SVR; (3) Increased pulmonary venous return → ↑LA pressure → functional closure of foramen ovale (anatomic 3 mo-1 yr); (4) Higher PaO2 + ↓ prostaglandins → functional closure of ductus arteriosus (anatomic by 2-3 weeks); (5) Ductus venosus closes when umbilical flow stops; (6) Persistent fetal circulation (PPHN — persistent pulmonary HT of newborn) if PVR fails to drop — causes: meconium aspiration, sepsis, RDS, congenital diaphragmatic hernia — Rx: 100% O2, sedation, mechanical vent, iNO (selective pulmonary vasodilator), milrinone, ECMO; ductal-dependent CHD (HLHS, critical AS/PS, TGA, Tricuspid atresia) — PGE1 maintains PDA until surgery

---

Neonatal transition: fetal R→L shunts + high PVR → newborn L→R adult circulation. Trigger: first breath + cord clamping. PVR drops, SVR rises, shunts close. PPHN if PVR fails to drop (iNO, ECMO). Ductal-dependent CHD: PGE1 maintains PDA (HLHS, critical AS/PS, TGA, Tricuspid atresia). PPS (peripheral pulmonary stenosis) common in newborns from incomplete transition — benign murmur usually.', NULL,
  'medium', 'cardiovascular', 'review',
  'pediatrics', 'basic_science', 'cardiovascular', 'peds',
  'Nelson Textbook of Pediatrics 22nd ed Ch. 461; Avery''s Diseases of the Newborn 11th ed', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'Resident ถาม physiology — neonatal transitional circulation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'อาจารย์อธิบาย immunology — infant immune system + vaccine response', '[{"label":"A","text":"Same as adult"},{"label":"B","text":"Infant immune system maturation"},{"label":"C","text":"Adults respond same as infants"},{"label":"D","text":"No need for vaccination"},{"label":"E","text":"Single dose universal"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Infant immune system maturation: (1) Innate: present at birth but qualitatively + quantitatively immature; (2) Adaptive: passive (maternal IgG transplacentally — protects 6 mo, wanes), active maturing; (3) Maternal IgG falls 6-9 mo while infant own immune building → ''physiologic hypogammaglobulinemia'' (6-9 mo nadir) → susceptibility window; (4) IgA in breast milk — mucosal protection; (5) IgM appears first to new antigen; IgG class switching; (6) T-cell response immature — Th2-biased — atopy susceptibility; (7) Vaccine response: live attenuated (MMR, varicella, rotavirus, BCG) need cellular immunity — given after 6 mo; inactivated/subunit/conjugate (DTaP, Hib, PCV13, Hepatitis B, polio IPV) — given starting birth/2 mo; conjugate vaccines (PCV, Hib, MenACWY) — conjugate protein to polysaccharide for T-cell-dependent response in infants; (8) Polysaccharide unconjugated vaccines (pneumovax 23) poorly immunogenic < 2 yr — give after 2 yr; (9) Live vaccines CI in pregnant, severe immunodeficiency, recent IVIG (delay 11 mo for MMR/varicella)

---

Infant immune system immature + Th2-biased. Maternal IgG protects ~ 6 mo then wanes. Live vaccines after 6-12 mo (cellular immunity needed). Conjugate vaccines key — convert T-independent polysaccharide to T-dependent (PCV, Hib, MenACWY) — effective in infants. Unconjugated polysaccharide (PPSV23) ineffective < 2 yr. Maternal vaccination (Tdap pregnancy, RSV, COVID, influenza) → passive transfer protects infant. Live vaccines CI in pregnancy + immunocompromised.', NULL,
  'easy', 'id', 'review',
  'pediatrics', 'basic_science', 'id', 'peds',
  'CDC Recommended Immunization Schedule; AAP Red Book 2024', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'อาจารย์อธิบาย immunology — infant immune system + vaccine response'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'อาจารย์อธิบาย physiology — pediatric fluid + electrolyte calculation', '[{"label":"A","text":"Same as adult"},{"label":"B","text":"Pediatric Fluid Management"},{"label":"C","text":"8-4-2 rule"},{"label":"D","text":"Always restrict fluid"},{"label":"E","text":"Adult formula"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Fluid Management: (1) Maintenance fluid ''4-2-1 rule'' (Holliday-Segar): 4 mL/kg/hr first 10 kg + 2 mL/kg/hr next 10 kg + 1 mL/kg/hr each additional kg (e.g., 25 kg child = 40 + 20 + 5 = 65 mL/hr); (2) Maintenance fluid composition: isotonic — D5 NS preferred over D5 0.45 NS (Cochrane evidence — hypotonic causes iatrogenic hyponatremia, especially in ill children) — AAP 2018 endorse isotonic; (3) Resuscitation: NSS or LR 20 mL/kg bolus over 15-30 min for shock, may repeat × 2-3 then assess + consider blood/colloid; (4) Dehydration assessment: mild (3-5%), moderate (6-9% — sunken eyes, dry MM, decreased turgor, prolonged capillary refill, tachycardia), severe (≥ 10% — lethargic, sunken fontanelle, very poor perfusion, hypotension late sign in peds); (5) Replacement: 50% deficit + maintenance over first 8h, remaining 50% over next 16h; oral rehydration solution (ORS) preferred for mild-moderate (cheaper, safer, effective); (6) Electrolyte considerations: K based on serum + UO; correct Na slowly (max 10-12 mEq/L/d to avoid central pontine myelinolysis); (7) Special situations: DKA (cautious slow fluid as discussed), burns (Parkland formula for kids), neonatal (different calculations)

---

Pediatric fluid management essential skill. 4-2-1 rule (Holliday-Segar 1957) for maintenance. AAP 2018 + NEJM 2018 (Friedman): isotonic preferred over hypotonic (less iatrogenic hyponatremia, esp ill children). 20 mL/kg bolus for shock (can repeat). Replace deficit over 24h (DKA 48h slower). ORS for mild-moderate dehydration. Cautions: rapid Na correction (CPM), DKA cerebral edema, neonatal special, burns Parkland. Frequent re-assessment + adjustment.', NULL,
  'medium', 'renal_gu', 'review',
  'pediatrics', 'basic_science', 'renal_gu', 'peds',
  'AAP Clinical Practice Guideline: Maintenance IV Fluids in Children 2018 (Feld LG et al.); Holliday MA, Segar WE. Pediatrics 1957', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'อาจารย์อธิบาย physiology — pediatric fluid + electrolyte calculation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital wants to reduce neonatal mortality + improve newborn screening + immunization rates

คำถาม: child health policy + quality metrics', '[{"label":"A","text":"Single intervention solves all"},{"label":"B","text":"Comprehensive Child Health Program"},{"label":"C","text":"Adult medicine principles only"},{"label":"D","text":"Ignore prevention"},{"label":"E","text":"Single specialty manages"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Comprehensive Child Health Program — multi-level intervention: (1) Antenatal: maternal nutrition + iron + folate, vaccination (Tdap, flu, COVID, RSV maternal), screening (gestational diabetes, group B Strep), education; (2) Intrapartum: skilled birth attendant, group B Strep prophylaxis if indicated, immediate skin-to-skin contact, delayed cord clamping (1-3 min — improves iron stores), early breastfeeding initiation; (3) Newborn: routine care (vitamin K, eye prophylaxis, hepatitis B vaccine), newborn screening (heel prick — congenital hypothyroidism, PKU, sickle cell, CF, etc.), pulse oximetry screening (critical CHD), hearing screening; (4) Well-child visits at scheduled intervals: growth + development monitoring, anticipatory guidance, vaccinations per CDC/local schedule, screening (lead, anemia, vision, hearing, autism, depression in adolescents); (5) Vaccination: universal + catch-up programs, education, address vaccine hesitancy, school requirements; (6) Nutrition: breastfeeding promotion (6 mo exclusive), complementary feeding 6 mo, micronutrient programs (iron, vitamin D, vitamin A), school meal programs; (7) Safety: car seats, helmets, water safety, firearm storage, lead paint; (8) Mental health: screening, school-based programs, family support; (9) Equity: address social determinants (food security, housing, education access); (10) Quality metrics: infant mortality, vaccination coverage, well-child visit completion, screening uptake, hospitalization rates

---

Comprehensive child health — life-course approach + multi-level intervention. WHO + AAP + CDC frameworks. Key components: antenatal, intrapartum, newborn screening + immunization, well-child visits, anticipatory guidance, safety, mental health, equity. Quality metrics: infant mortality (key indicator), vaccination coverage, screening uptake. Social determinants of health critical. Multidisciplinary + multi-level. Thailand: maternal + child health policy improved outcomes significantly past decades.', NULL,
  'easy', 'signs_symptoms', 'review',
  'pediatrics', 'ems_mgmt', 'signs_symptoms', 'peds',
  'WHO Reproductive Maternal Newborn Child + Adolescent Health Strategy; AAP Bright Futures Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'Hospital wants to reduce neonatal mortality + improve newborn screening + immunization rates

คำถาม: child health policy + quality metrics'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'PICU implements quality improvement to reduce CLABSI in children — different from adult considerations', '[{"label":"A","text":"Same as adult bundle"},{"label":"B","text":"Pediatric CLABSI Prevention Bundle"},{"label":"C","text":"Avoid all central lines"},{"label":"D","text":"Use all femoral lines"},{"label":"E","text":"No prevention needed in children"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric CLABSI Prevention Bundle: similar adult core (hand hygiene, max barrier, chlorhexidine ≥ 0.5% in alcohol > 2 mo old, site selection — IJ or subclavian preferred over femoral in non-emergent, daily review) + pediatric-specific: (1) Use of central lines minimized — peripheral IV when possible, midline if longer duration; (2) Catheter selection by size + child size (different small catheters); (3) Site selection: in infants/children — IJ often easier than subclavian; femoral acceptable in PICU/post-op cardiac (less infection difference than adults); (4) Insertion checklist + observer; (5) Chlorhexidine bathing daily in PICU (less convincing evidence than adults); (6) Dressing change protocols (transparent q7d or per soil); (7) Hub disinfection ("scrub the hub"); (8) Daily review of necessity — early removal; (9) Antimicrobial-impregnated catheters in selected; (10) Education + ongoing competency assessment; (11) PICU-specific: TPN line designation, sepsis surveillance; (12) Family education + engagement; (13) Tracking + feedback: CLABSI rate per 1000 catheter-days; (14) Multidisciplinary: physicians, nurses, infection prevention, family

---

Pediatric CLABSI prevention — similar core to adult bundle (Pronovost Keystone applies) + pediatric considerations: smaller catheters, site preference varies, chlorhexidine after 2 mo old, family engagement. Pediatric ICU CLABSI lower with bundle implementation (Miller MR Pediatrics 2010 — 40% reduction). Modern: family-centered care, technology, electronic surveillance. Continuous improvement + audit + feedback critical.', NULL,
  'medium', 'id', 'review',
  'pediatrics', 'ems_mgmt', 'id', 'peds',
  'Miller MR et al. Pediatrics 2010 (PICU CLABSI Bundle); CDC HICPAC + PIDS Guidelines for Pediatric', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'PICU implements quality improvement to reduce CLABSI in children — different from adult considerations'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Pediatric department implements ''Family-Centered Care'' (FCC) — partner with families to improve outcomes', '[{"label":"A","text":"Exclude families from care decisions"},{"label":"B","text":"Family-Centered Care (FCC) in pediatric/PICU"},{"label":"C","text":"Visit only 2 hours/day"},{"label":"D","text":"Decisions by physicians alone"},{"label":"E","text":"No family communication"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Family-Centered Care (FCC) in pediatric/PICU — partnership with families improves outcomes: (1) Core principles (Institute for Patient + Family-Centered Care): respect + dignity, information sharing, participation, collaboration; (2) Open visitation 24/7 + family at bedside; (3) Family rounds — daily bedside multidisciplinary rounds including family + child (age-appropriate); (4) Shared decision-making — values, goals, options discussed; (5) Family presence during procedures + resuscitation (AHA + AAP endorse); (6) Parental + caregiver role: comfort, education, advocacy, observation; (7) Sibling support + visitation; (8) Cultural + linguistic competence — interpreters, cultural understanding; (9) Discharge planning involves family early; (10) Family advisory councils — family input on hospital policies + design; (11) Education programs + support groups; (12) Bereavement care for family if child dies; (13) Outcome measures: family satisfaction, length of stay, readmission, error rates (reduced when family engaged), staff satisfaction; (14) Evidence: family presence at resuscitation reduces PTSD in family + does not impair care (Compassionate Connected Care, Doyle Crit Care Med); FCC reduces LOS, complications, costs (Cooper RL Crit Care Med)

---

FCC = evidence-based partnership with families. Core: respect, information, participation, collaboration. Reduces LOS, complications, PTSD, increases satisfaction. Family-centered rounds, presence during resuscitation, shared decision-making, cultural competence. IPFCC framework. AAP, AHA endorse. Modern pediatric care unimaginable without family partnership.', NULL,
  'easy', 'psych_behavior', 'review',
  'pediatrics', 'ems_mgmt', 'psych_behavior', 'peds',
  'Institute for Patient + Family-Centered Care; Committee on Hospital Care + IPFCC. Patient + Family-Centered Care + the Pediatrician''s Role 2012', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'Pediatric department implements ''Family-Centered Care'' (FCC) — partner with families to improve outcomes'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 4 ปี diagnosed ALL (acute lymphoblastic leukemia) — induction phase chemotherapy, multidisciplinary care

คำถาม: pediatric cancer integrative management', '[{"label":"A","text":"Chemotherapy only by oncologist"},{"label":"B","text":"Pediatric Cancer Integrative Multidisciplinary Care"},{"label":"C","text":"Refuse all support"},{"label":"D","text":"Single specialist"},{"label":"E","text":"Ignore long-term effects"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Cancer Integrative Multidisciplinary Care: (1) Oncology team: pediatric hematology-oncology, treatment protocol per COG/UKALL/equivalent; (2) Treatment: induction → consolidation → maintenance for ALL; risk-stratified (cytogenetics, MRD); intrathecal therapy + cranial RT (selected) for CNS prophylaxis; (3) Supportive: tumor lysis syndrome prevention (hydration, allopurinol, rasburicase for high risk), febrile neutropenia management (empirical broad antibiotic within 1h), antifungal prophylaxis selected, antiviral if needed, transfusion support, growth factors (G-CSF); (4) Multidisciplinary team: oncology, infectious disease, nutritionist, PT/OT, psychology, child life, social work, chaplain, school liaison, primary pediatrician coordination; (5) Family support: shared decision-making, anticipatory guidance, sibling support, financial counseling (treatment expensive), respite care; (6) Child life specialist: developmentally appropriate education, coping, distraction, procedural support; (7) School re-integration: maintain education, home/hospital schooling, school nurse coordination, transition back; (8) Long-term survivorship: 90% 5-year survival ALL — surveillance for late effects (secondary malignancy, cardiotoxicity, growth, fertility, cognitive, psychosocial); transition to adult survivor clinic; (9) Palliative care concurrent — improves QOL even in curative intent; (10) End-of-life care if treatment fails — pediatric palliative + hospice integration

---

Pediatric cancer = integrative + multidisciplinary + family-centered. ALL 90% 5-year survival modern. Treatment phases. Risk-stratified (MRD, cytogenetics). Supportive care critical (febrile neutropenia, tumor lysis, transfusions). Multidisciplinary team. Family support essential. Long-term survivorship: late effects screening, transition to adult care. Palliative care concurrent (improves QOL + may extend life). Modern pediatric oncology highly integrated.', NULL,
  'hard', 'hemato_onco', 'review',
  'pediatrics', 'integrative', 'hemato_onco', 'peds',
  'Children''s Oncology Group Protocols; AAP + ASCO Pediatric Cancer Survivorship; ChIPS — Children''s International Project on Palliative + Hospice Services', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 4 ปี diagnosed ALL (acute lymphoblastic leukemia) — induction phase chemotherapy, multidisciplinary care

คำถาม: pediatric cancer integrative management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Adolescent 16-year-old + chronic medical condition — transition to adult care

คำถาม: adolescent transition + multimorbidity', '[{"label":"A","text":"Abrupt transfer at 18"},{"label":"B","text":"Adolescent Transition to Adult Care (integrative + planned process)"},{"label":"C","text":"Pediatric care for life"},{"label":"D","text":"Ignore transition needs"},{"label":"E","text":"Discharge from all care"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Adolescent Transition to Adult Care (integrative + planned process): (1) Begin transition planning in early adolescence (age 12-14) — not abrupt at 18; (2) Joint pediatric + adult provider coordination — written transition plan, shared records; (3) Self-management skills development: medication knowledge + administration, appointment scheduling, insurance navigation, recognizing warning signs, communication with providers; (4) Address adolescent-specific issues: sexuality + reproductive health, mental health (depression, anxiety, substance use higher in chronic illness), school/career planning, peer relationships, identity + autonomy; (5) Family role evolution — from primary decision-maker to support; (6) Confidentiality + assent/consent transition; (7) Specific concerns by condition (DM, CF, cancer survivor, congenital heart, sickle cell, IBD, transplant); (8) Insurance + legal: medical decision-making, conservatorship if cognitive impairment, transition of insurance; (9) Multidisciplinary support: adolescent medicine, social work, mental health, primary care; (10) Outcome metrics: continuity of care, no gap, adherence, satisfaction; (11) Got Transition + Six Core Elements framework (national approach); (12) Special populations: developmental disabilities, autism (specialized adult providers limited), cognitive impairment, complex care

---

Adolescent transition to adult care = critical integrative process. Begin early, planned, not abrupt. Six Core Elements (Got Transition): transition policy, tracking, readiness, planning, transfer, completion. Self-management skill building. Adolescent-specific issues. Family + autonomy balance. Multidisciplinary. Specific to condition (CF, DM, sickle cell, transplant, complex care). Outcomes: continuity, adherence. Gap in transition = poor outcomes. Modern: ''Got Transition'' national framework + AAP/AAFP/ACP joint clinical report.', NULL,
  'medium', 'psych_behavior', 'review',
  'pediatrics', 'integrative', 'psych_behavior', 'peds',
  'AAP/AAFP/ACP Clinical Report: Transitions Clinical Report 2018; Got Transition / National Alliance to Advance Adolescent Health', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'Adolescent 16-year-old + chronic medical condition — transition to adult care

คำถาม: adolescent transition + multimorbidity'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Premature infant ex-32 weeks now 6 months chronological age — chronic lung disease + developmental concerns + family stress

คำถาม: post-NICU follow-up + integrative care', '[{"label":"A","text":"Discharge from all follow-up"},{"label":"B","text":"Premature Infant Follow-up (NICU Graduate)"},{"label":"C","text":"Single specialty manages all"},{"label":"D","text":"Refuse early intervention"},{"label":"E","text":"Use chronological age only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Premature Infant Follow-up (NICU Graduate) — Integrative Multidisciplinary: (1) High-risk infant follow-up clinic (HRIF): developmental assessment, growth, neurological at scheduled intervals up to 2-3 years (corrected age); (2) Subspecialty care: pulmonology (BPD/CLD — chronic lung disease, RSV prophylaxis with palivizumab, weaning O2 home), ophthalmology (ROP — retinopathy of prematurity, follow-up), cardiology (PDA, congenital concerns), neurology (IVH, PVL, hydrocephalus), GI (NEC, feeding difficulties); (3) Developmental: PT, OT, speech therapy, early intervention services (IDEA Part C), assessments (Bayley, AIMS); (4) Nutrition: high-calorie formulas, fortification, weight gain monitoring, feeding therapy; (5) Vaccination: catch-up schedule + RSV prophylaxis (palivizumab) for high-risk; (6) Hearing + vision screening + monitoring; (7) Family support: parental mental health (high postpartum depression + PTSD risk), sibling support, financial counseling (NICU costs, ongoing care), respite care; (8) Coordinate care: medical home with primary pediatrician + specialty consults; (9) Long-term: school readiness assessment, IEP if developmental delays, transition planning; (10) Outcomes: many achieve typical development; some have lasting disabilities — early intervention improves outcomes; family-centered support throughout; corrected age use until 2 yr for milestones

---

NICU graduate follow-up = quintessentially integrative. High-Risk Infant Follow-up clinic standard model. Subspecialty care (pulm, ophtho, cardio, neuro, GI, dev). Early intervention essential — improves outcomes. Family-centered + corrected age use until 2 yr. Long-term outcomes variable — modern care + interventions improve trajectory. Family support critical (parental MH, finances, social). AAP + March of Dimes guidelines. Outcomes registry data informs care.', NULL,
  'medium', 'respiratory', 'review',
  'pediatrics', 'integrative', 'respiratory', 'peds',
  'AAP Section on Perinatal Pediatrics; Follow-up Care of High-Risk Infants 2008 + updates', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'Premature infant ex-32 weeks now 6 months chronological age — chronic lung disease + developmental concerns + family stress

คำถาม: post-NICU follow-up + integrative care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกเกิดก่อนกำหนด GA 30 wk BW 1,400 g คลอด emergency C/S จากแม่ chorioamnionitis ทารกหายใจหอบเหนื่อยตั้งแต่ 30 นาทีหลังคลอด grunting + retraction

V/S: HR 168, RR 78, SpO2 84% room air, Temp 36.4°C
Gen: cyanosis central, severe subcostal + intercostal retraction, nasal flaring, expiratory grunting
CXR: bilateral diffuse ground-glass + air bronchogram + low lung volume', '[{"label":"A","text":"Discharge with home O2"},{"label":"B","text":"Neonatal RDS (surfactant deficiency)"},{"label":"C","text":"Diuretic only"},{"label":"D","text":"Restrict oxygen completely"},{"label":"E","text":"Oral antibiotic outpatient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neonatal RDS (surfactant deficiency): warm + dry + INSURE หรือ early CPAP+selective surfactant; ให้ surfactant (poractant alfa 200 mg/kg หรือ beractant 100 mg/kg) intratracheal ภายใน 2 ชม; nCPAP 5-6 cmH2O เป็น first-line; intubate ถ้า FiO2 > 0.4 + persistent distress; antenatal steroid ถ้ารู้ก่อนคลอด; antibiotic ครอบคลุม sepsis (ampicillin+gentamicin) เพราะ chorioamnionitis; thermoregulation + nutrition + monitor PDA/IVH/ROP/BPD

---

RDS = ภาวะที่พบบ่อยที่สุดในทารกเกิดก่อนกำหนด เกิดจาก surfactant deficiency. ESPR 2023 guideline เน้น less invasive surfactant administration (LISA/MIST) + nCPAP. Antenatal steroid ลด RDS, IVH, death อย่างมีนัยสำคัญ. Caffeine สำหรับ AOP. Antibiotic ครอบคลุม early-onset sepsis ในเด็กที่แม่มี chorioamnionitis.', NULL,
  'easy', 'respiratory', 'review',
  'pediatrics', 'clinical_decision', 'respiratory', 'peds',
  'European Consensus Guidelines on the Management of RDS 2023 (Sweet DG et al.)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกเกิดก่อนกำหนด GA 30 wk BW 1,400 g คลอด emergency C/S จากแม่ chorioamnionitis ทารกหายใจหอบเหนื่อยตั้งแต่ 30 นาทีหลังคลอด grunting + retraction

V/S: HR 168, RR 78, SpO2 84% room air, Temp 36.4°C
Gen: cyanosis central, severe subcostal + intercostal retraction, nasal flaring, expiratory grunting
CXR: bilateral diffuse ground-glass + air bronchogram + low lung volume'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารก preterm GA 28 wk BW 950 g อายุ 14 วัน เริ่ม feed breast milk + fortifier ได้ดี วันนี้มี abdominal distension + bilious vomiting + bloody stool + lethargy + temperature instability

V/S: HR 188, RR 72, SpO2 92%, BP 52/30, Temp 35.8°C
Abd: distended, erythema abdominal wall, absent bowel sounds, tenderness

CBC: WBC 4,200 (left shift), Plt 68,000, Hb 9.2
Lactate 5.8, metabolic acidosis pH 7.21
AXR: pneumatosis intestinalis + portal venous gas', '[{"label":"A","text":"Continue feed + observation"},{"label":"B","text":"Necrotizing Enterocolitis Bell stage IIB-III"},{"label":"C","text":"Increase feed volume"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Oral antibiotic only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Necrotizing Enterocolitis Bell stage IIB-III: NPO ทันที + NG decompression + IV fluid resuscitation + broad-spectrum antibiotic (ampicillin + gentamicin + metronidazole or piperacillin-tazobactam) × 7-14 วัน; bowel rest 7-14 วัน; serial AXR q6h หา pneumoperitoneum; surgical consultation; indications surgery: perforation, fixed loop, clinical deterioration; TPN; correct coagulopathy; platelet transfusion ถ้า < 50,000 + bleeding; long-term watch for strictures + short bowel syndrome

---

NEC = leading cause GI emergency + mortality ใน preterm. Bell staging guides management. Pneumatosis intestinalis = pathognomonic. Portal venous gas = severe. Surgery for perforation/clinical deterioration. Prevention: breast milk feeding, slow advancement, probiotics (selected populations), antenatal steroid.', NULL,
  'medium', 'gi', 'review',
  'pediatrics', 'clinical_decision', 'gi', 'peds',
  'AAP Clinical Report on NEC 2022; Neu J. NEJM 2024', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารก preterm GA 28 wk BW 950 g อายุ 14 วัน เริ่ม feed breast milk + fortifier ได้ดี วันนี้มี abdominal distension + bilious vomiting + bloody stool + lethargy + temperature instability

V/S: HR 188, RR 72, SpO2 92%, BP 52/30, Temp 35.8°C
Abd: distended, erythema abdominal wall, absent bowel sounds, tenderness

CBC: WBC 4,200 (left shift), Plt 68,000, Hb 9.2
Lactate 5.8, metabolic acidosis pH 7.21
AXR: pneumatosis intestinalis + portal venous gas'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกแรกเกิด term GA 39 wk BW 3,200 g คลอด NL แม่ GBS positive ไม่ได้ intrapartum antibiotic prophylaxis อายุ 18 ชม มี temperature instability + poor feeding + tachypnea + grunting

V/S: HR 178, RR 72, Temp 38.4°C, SpO2 94%
Gen: lethargic, mottled skin, capillary refill 4 sec, mild jaundice

CBC: WBC 28,500 (immature/total 0.3), Plt 110,000, CRP 65
Glucose 45, ABG mild metabolic acidosis', '[{"label":"A","text":"Observation only"},{"label":"B","text":"Early-onset neonatal sepsis (likely GBS"},{"label":"C","text":"Antibiotic oral outpatient"},{"label":"D","text":"Discharge with follow-up"},{"label":"E","text":"IVIG only without antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Early-onset neonatal sepsis (likely GBS — inadequate IAP): blood culture + LP + UA + CBC ก่อนให้ antibiotic; empiric Ampicillin 150 mg/kg/dose q12h IV + Gentamicin 4 mg/kg/dose q24h IV; resuscitation fluid 10-20 mL/kg NSS bolus careful; correct glucose + electrolytes; meningitis dose ถ้า LP +; duration: 10 d bacteremia, 14-21 d meningitis (GBS); supportive: thermoregulation, ventilation, vasopressor ถ้า shock

---

Early-onset sepsis (EOS) < 72 ชม. GBS = most common pathogen. Inadequate IAP = risk factor. Kaiser EOS calculator + CDC 2010/2019 guidance. Always rule out meningitis. Antibiotic timing critical. Long-term: developmental follow-up.', NULL,
  'medium', 'id', 'review',
  'pediatrics', 'clinical_decision', 'id', 'peds',
  'AAP COFN/COID Clinical Report: Management of Neonates at Risk for Early-Onset Sepsis 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกแรกเกิด term GA 39 wk BW 3,200 g คลอด NL แม่ GBS positive ไม่ได้ intrapartum antibiotic prophylaxis อายุ 18 ชม มี temperature instability + poor feeding + tachypnea + grunting

V/S: HR 178, RR 72, Temp 38.4°C, SpO2 94%
Gen: lethargic, mottled skin, capillary refill 4 sec, mild jaundice

CBC: WBC 28,500 (immature/total 0.3), Plt 110,000, CRP 65
Glucose 45, ABG mild metabolic acidosis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารก term DOL 4 BW 3,400 g (BW birth 3,500 g, weight loss 2.8%) breastfeeding มา check up พบตัวเหลือง

V/S ปกติ Temp 36.8°C
Gen: jaundice ถึง knees, alert, feed ดี

Total bilirubin 18.2 mg/dL (direct 0.8), Hb 14.5, Hct 44, blood group: mother O+, baby A+
Coombs test: weakly positive
Reticulocyte 4.2%', '[{"label":"A","text":"Observe only"},{"label":"B","text":"Hyperbilirubinemia + ABO incompatibility (Coombs+)"},{"label":"C","text":"Exchange transfusion immediately"},{"label":"D","text":"Stop breastfeeding permanently"},{"label":"E","text":"Discharge home without phototherapy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hyperbilirubinemia + ABO incompatibility (Coombs+): plot on AAP 2022 nomogram by gestational age + risk factors → bilirubin 18.2 at 96h + neuroToxicity risk factors = phototherapy threshold; intensive phototherapy (450-500 nm blue-green LED, body surface > 80%); continue breastfeeding, supplement formula ถ้า dehydration; recheck TSB q6-12h; exchange transfusion ถ้า > exchange threshold หรือ ABE signs; investigate G6PD ในเด็กเอเชีย; IVIG ถ้า isoimmune + rising despite phototherapy; follow-up 24-48h post-discharge

---

AAP 2022 updated nomogram: integrates GA, age in hours, neurotoxicity risk factors (isoimmune disease, G6PD, sepsis, albumin < 3, asphyxia). ABO incompatibility = mild hemolysis. Intensive phototherapy = mainstay. Bilirubin encephalopathy = preventable cause of kernicterus.', NULL,
  'easy', 'hematology', 'review',
  'pediatrics', 'clinical_decision', 'hematology', 'peds',
  'AAP Clinical Practice Guideline Revision: Hyperbilirubinemia 2022 (Kemper AR et al.)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารก term DOL 4 BW 3,400 g (BW birth 3,500 g, weight loss 2.8%) breastfeeding มา check up พบตัวเหลือง

V/S ปกติ Temp 36.8°C
Gen: jaundice ถึง knees, alert, feed ดี

Total bilirubin 18.2 mg/dL (direct 0.8), Hb 14.5, Hct 44, blood group: mother O+, baby A+
Coombs test: weakly positive
Reticulocyte 4.2%'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารก term GA 40 wk meconium-stained fluid + low Apgar (3, 5) อายุ 4 ชม หอบเหนื่อยมาก + cyanosis + เริ่มต้องการ FiO2 100%

V/S: HR 178, RR 75, SpO2 right hand 92% / right foot 78% (pre/post-ductal differential 14%)

ABG (FiO2 1.0): pH 7.22, PaO2 42, PaCO2 58
CXR: clear lung field, normal heart size
Echo: tricuspid regurgitation jet velocity high, RV pressure 65 mmHg + R→L shunting at PFO + PDA', '[{"label":"A","text":"Decrease FiO2 to 21%"},{"label":"B","text":"Persistent Pulmonary Hypertension Newborn (PPHN, MAS-related)"},{"label":"C","text":"Discharge home with oxygen"},{"label":"D","text":"Stop oxygen entirely"},{"label":"E","text":"Beta blocker"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Persistent Pulmonary Hypertension Newborn (PPHN, MAS-related): optimize ventilation + oxygenation (SpO2 95-99%, target PaO2 60-80, gentle ventilation, avoid hypocapnia); correct acidosis + hypoglycemia + hypocalcemia; surfactant ถ้า MAS/parenchymal disease; inhaled Nitric Oxide (iNO) 20 ppm first-line pulmonary vasodilator; sedation (fentanyl) เพื่อลด stress + pulmonary vasoconstriction; vasopressor (milrinone, sildenafil) ถ้า iNO ไม่พอ; ECMO ถ้า refractory (OI > 25-40); avoid hyperoxia; transfer to ECMO center

---

PPHN = failure of normal postnatal fall in PVR → R→L shunt → hypoxemia. Differential SpO2 (pre > post) = key clinical sign. iNO + gentle ventilation + supportive care. ECMO for refractory cases. Common causes: MAS, sepsis, RDS, congenital diaphragmatic hernia, idiopathic.', NULL,
  'hard', 'respiratory', 'review',
  'pediatrics', 'clinical_decision', 'respiratory', 'peds',
  'AAP Clinical Report: Use of Inhaled Nitric Oxide 2014; PPHN Network Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารก term GA 40 wk meconium-stained fluid + low Apgar (3, 5) อายุ 4 ชม หอบเหนื่อยมาก + cyanosis + เริ่มต้องการ FiO2 100%

V/S: HR 178, RR 75, SpO2 right hand 92% / right foot 78% (pre/post-ductal differential 14%)

ABG (FiO2 1.0): pH 7.22, PaO2 42, PaCO2 58
CXR: clear lung field, normal heart size
Echo: tricuspid regurgitation jet velocity high, RV pressure 65 mmHg + R→L shunting at PFO + PDA'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารก term GA 38 wk BW 3,400 g คลอด NL Apgar 8/9 อายุ 6 ชม cyanosis ทั่วตัวไม่ดีขึ้นด้วย O2

V/S: HR 158, RR 62, SpO2 right hand 75% / right foot 78%
Gen: marked central cyanosis ที่ไม่ตอบสนองต่อ O2, mild distress, no murmur
Hyperoxia test: PaO2 < 100 บน FiO2 100%

CXR: ''egg on string'', cardiomegaly, increased pulmonary vascularity
Echo: D-Transposition of Great Arteries (D-TGA) + small PFO + small PDA', '[{"label":"A","text":"Discharge home"},{"label":"B","text":"D-TGA emergency"},{"label":"C","text":"Beta blocker only"},{"label":"D","text":"100% oxygen alone resolves"},{"label":"E","text":"Heart transplant immediately"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** D-TGA emergency: Prostaglandin E1 infusion 0.05-0.1 mcg/kg/min IV ทันที (เปิด PDA เพื่อ allow mixing) + balloon atrial septostomy (Rashkind) ภายใต้ echo ในห้อง cath เพื่อขยาย atrial communication; cardiology + cardiac surgery consultation; transfer to cardiac center; correct metabolic acidosis + glucose; avoid hyperoxia (สามารถปิด PDA); ventilation as needed; arterial switch operation (Jatene) ภายใน 2 weeks of life (เพราะ LV regression); long-term cardiology follow-up

---

D-TGA = most common cyanotic CHD presenting in newborn. Cyanosis refractory to O2 = key sign. PGE1 keeps PDA open for mixing. BAS expands intra-atrial mixing. Definitive: arterial switch within 2 weeks. Hyperoxia test (PaO2 < 100 on 100% O2) suggests cyanotic CHD.', NULL,
  'hard', 'cardiovascular', 'review',
  'pediatrics', 'clinical_decision', 'cardiovascular', 'peds',
  'AHA/ACC Guideline for Management of Adults With Congenital Heart Disease 2018; Park Pediatric Cardiology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารก term GA 38 wk BW 3,400 g คลอด NL Apgar 8/9 อายุ 6 ชม cyanosis ทั่วตัวไม่ดีขึ้นด้วย O2

V/S: HR 158, RR 62, SpO2 right hand 75% / right foot 78%
Gen: marked central cyanosis ที่ไม่ตอบสนองต่อ O2, mild distress, no murmur
Hyperoxia test: PaO2 < 100 บน FiO2 100%

CXR: ''egg on string'', cardiomegaly, increased pulmonary vascularity
Echo: D-Transposition of Great Arteries (D-TGA) + small PFO + small PDA'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารก term DOL 5 lethargic, ดูดนมไม่ดี, ขาเย็น, มา ED

V/S: BP right arm 95/62, BP right leg 60/38 (gradient 35 mmHg), HR 168, RR 68, SpO2 96% right hand / 90% right foot
PE: weak femoral pulses bilateral, brachial-femoral delay, mild hepatomegaly, no murmur

CXR: cardiomegaly + pulmonary edema
Echo: severe juxtaductal coarctation of aorta + bicuspid aortic valve + LV dysfunction, closing PDA', '[{"label":"A","text":"Observe + recheck pulses tomorrow"},{"label":"B","text":"Critical/Ductal-dependent Coarctation of Aorta"},{"label":"C","text":"Antihypertensive medication only"},{"label":"D","text":"Discharge with diuretic"},{"label":"E","text":"Heart transplant"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Critical/Ductal-dependent Coarctation of Aorta: Prostaglandin E1 0.05-0.1 mcg/kg/min IV infusion ทันที (เปิด PDA ฟื้น systemic perfusion); resuscitation + inotropic support (milrinone, dopamine) ถ้า shock; correct metabolic acidosis + hypoglycemia + hypocalcemia; broad-spectrum antibiotic หา sepsis; intubation + ventilation ถ้า respiratory failure; urgent cardiology + cardiac surgery referral; surgical repair (end-to-end, subclavian flap, balloon angioplasty); long-term BP monitoring (residual HT common)

---

Critical coarctation = ductal-dependent. Presents shock as PDA closes (DOL 3-7). BP gradient + weak femoral pulses = classic. PGE1 = lifesaving. Associated bicuspid AV, VSD. Long-term sequelae: residual HT, re-coarctation, aortic dissection.', NULL,
  'medium', 'cardiovascular', 'review',
  'pediatrics', 'clinical_decision', 'cardiovascular', 'peds',
  'AHA 2018 Guideline Adult CHD; Park Pediatric Cardiology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารก term DOL 5 lethargic, ดูดนมไม่ดี, ขาเย็น, มา ED

V/S: BP right arm 95/62, BP right leg 60/38 (gradient 35 mmHg), HR 168, RR 68, SpO2 96% right hand / 90% right foot
PE: weak femoral pulses bilateral, brachial-femoral delay, mild hepatomegaly, no murmur

CXR: cardiomegaly + pulmonary edema
Echo: severe juxtaductal coarctation of aorta + bicuspid aortic valve + LV dysfunction, closing PDA'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 3 ปี ไข้ + ไอ + หอบเหนื่อย 3 วัน ไม่มี wheeze, vaccine ครบ

V/S: HR 152, RR 58, SpO2 91% room air, Temp 39.4°C, BW 14 kg
Gen: alert, mild distress, decreased breath sound + crackles + bronchial breath right lower lobe

CBC: WBC 18,200 (PMN 78%), CRP 158
CXR: right lower lobe consolidation + small parapneumonic effusion', '[{"label":"A","text":"Outpatient azithromycin"},{"label":"B","text":"Pediatric Community-Acquired Pneumonia (likely Strep pneumoniae)"},{"label":"C","text":"Discharge home no antibiotic"},{"label":"D","text":"Antifungal first-line"},{"label":"E","text":"Steroid alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Community-Acquired Pneumonia (likely Strep pneumoniae): IV Ampicillin 50 mg/kg/dose q6h (200 mg/kg/d) เป็น first-line ใน fully immunized child + hospitalized + moderate severity; O2 ให้ SpO2 ≥ 92%; IV fluid maintenance + antipyretic; ถ้า effusion มาก + clinical worse → US chest + drainage + culture; switch oral amoxicillin เมื่อ stable + afebrile 24-48h; duration total 7-10 d; วัคซีน PCV13 + influenza; macrolide ถ้า atypical (Mycoplasma, Chlamydia)

---

PIDS/IDSA 2011 guideline: ampicillin first-line for hospitalized peds CAP (Spn). PCV13 reduced Spn rates. Add macrolide if atypical suspected. Severity: hypoxia, RR, retractions, oral intake guide hospitalization. Effusion → drainage if large/empyema.', NULL,
  'medium', 'respiratory', 'review',
  'pediatrics', 'clinical_decision', 'respiratory', 'peds',
  'PIDS/IDSA Guidelines: Management of CAP in Children 2011 (Bradley JS et al.)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 3 ปี ไข้ + ไอ + หอบเหนื่อย 3 วัน ไม่มี wheeze, vaccine ครบ

V/S: HR 152, RR 58, SpO2 91% room air, Temp 39.4°C, BW 14 kg
Gen: alert, mild distress, decreased breath sound + crackles + bronchial breath right lower lobe

CBC: WBC 18,200 (PMN 78%), CRP 158
CXR: right lower lobe consolidation + small parapneumonic effusion'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 7 ปี known asthma มา ED ด้วยอาการหอบเหนื่อย ไอ wheeze หลังเจอแมว 2 ชม ก่อน ใช้ albuterol MDI ที่บ้าน 4 puff ไม่ดีขึ้น

V/S: HR 142, RR 38, SpO2 89% room air, BW 25 kg
Gen: speaking single words, marked accessory muscle use, audible wheeze, prolonged expiration
PEFR 35% predicted', '[{"label":"A","text":"Antibiotic + discharge"},{"label":"B","text":"Severe asthma exacerbation (GINA 2024)"},{"label":"C","text":"Sedative only"},{"label":"D","text":"Restrict fluid"},{"label":"E","text":"IV diuretic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe asthma exacerbation (GINA 2024): O2 to SpO2 94-98% (kids); albuterol nebulized 2.5-5 mg q20 min × 3 หรือ continuous + ipratropium 250-500 mcg ผสมใน first 3 doses; systemic corticosteroid early — oral prednisolone 1-2 mg/kg (max 60 mg) ภายใน 1 ชม; magnesium sulfate IV 25-50 mg/kg (max 2 g) over 20 min ถ้า refractory; reassess PEFR, work of breathing, SpO2 q15-30 min; IV terbutaline หรือ ICU + ventilation ถ้า impending failure; admit ถ้า incomplete response; discharge plan: action plan, ICS, follow-up 1-2 wk, trigger avoidance

---

GINA 2024 + AAP: ABC ไปก่อน. Early systemic steroid critical (delay = worse outcome). Mg sulfate for severe/refractory. Avoid sedatives (mask deterioration). ICU/intubation for impending respiratory failure (silent chest, exhaustion, CO2 normalizing/rising = late). Long-term: ICS + action plan + trigger control.', NULL,
  'medium', 'respiratory', 'review',
  'pediatrics', 'clinical_decision', 'respiratory', 'peds',
  'GINA Global Strategy 2024; AAP Section on Allergy/Asthma', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 7 ปี known asthma มา ED ด้วยอาการหอบเหนื่อย ไอ wheeze หลังเจอแมว 2 ชม ก่อน ใช้ albuterol MDI ที่บ้าน 4 puff ไม่ดีขึ้น

V/S: HR 142, RR 38, SpO2 89% room air, BW 25 kg
Gen: speaking single words, marked accessory muscle use, audible wheeze, prolonged expiration
PEFR 35% predicted'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 2 ปี เสียงแหบ + ไอเสียงเหมือนเห่า + stridor ขณะร้อง 1 วัน ก่อนหน้าเป็นหวัดเล็กน้อย ไม่มีไข้สูง

V/S: HR 132, RR 36, SpO2 96%, Temp 38.0°C
Gen: alert, comfortable at rest, no drooling, mild stridor only with crying, mild suprasternal retraction
Westley croup score 3 (mild-moderate)', '[{"label":"A","text":"Tracheostomy immediately"},{"label":"B","text":"Croup (laryngotracheobronchitis, parainfluenza)"},{"label":"C","text":"Antibiotic + admit"},{"label":"D","text":"Albuterol nebulizer"},{"label":"E","text":"Intubate routinely"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Croup (laryngotracheobronchitis, parainfluenza): Dexamethasone 0.6 mg/kg PO/IM (max 16 mg) single dose ให้ทุกระดับความรุนแรง (ลด admission + return); humidified air/cool mist ความช่วยเหลือไม่เด่น แต่ comfort; minimize agitation; ถ้า moderate-severe (stridor at rest, retractions) → nebulized racemic epinephrine 0.5 mL of 2.25% (or L-epi) → monitor 3-4 hr (rebound); admit ถ้า persistent stridor, repeated epi, distress; avoid antibiotic (viral); reassurance + return precautions

---

Croup = viral (parainfluenza most common), age 6 mo-3 yr. Single-dose dexamethasone for all severity grades (level 1 evidence). Nebulized epinephrine for moderate-severe with rebound monitoring 3-4 hr. Avoid agitation. Bacterial tracheitis = serious differential (toxic appearance, high fever, no response to epi).', NULL,
  'easy', 'respiratory', 'review',
  'pediatrics', 'clinical_decision', 'respiratory', 'peds',
  'Cochrane: Glucocorticoids for Croup 2018; AAP Section on Emergency Medicine', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 2 ปี เสียงแหบ + ไอเสียงเหมือนเห่า + stridor ขณะร้อง 1 วัน ก่อนหน้าเป็นหวัดเล็กน้อย ไม่มีไข้สูง

V/S: HR 132, RR 36, SpO2 96%, Temp 38.0°C
Gen: alert, comfortable at rest, no drooling, mild stridor only with crying, mild suprasternal retraction
Westley croup score 3 (mild-moderate)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 4 ปี vaccine incomplete (no Hib) มา ED ด้วยไข้สูง 40°C 6 ชม น้ำลายไหล นั่งโน้มตัวไปข้างหน้า (tripod) เสียงแหบ ดูป่วยมาก ไม่ยอมนอน

V/S: HR 162, RR 32, SpO2 91%, Temp 40°C, BW 18 kg
Gen: toxic appearance, drooling, muffled voice, no cough, anxious
Avoid lateral neck X-ray in ED', '[{"label":"A","text":"Lay flat for direct laryngoscopy"},{"label":"B","text":"Suspected Epiglottitis (incomplete Hib vaccine)"},{"label":"C","text":"Oral antibiotic + discharge"},{"label":"D","text":"Force IV before airway"},{"label":"E","text":"CT neck first"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Suspected Epiglottitis (incomplete Hib vaccine): KEEP CHILD CALM with parent (no IV, no exam, no X-ray ใน ED ที่อาจทำให้ตื่นกลัว); call anesthesia + ENT + ICU ทันที; transfer to OR for controlled intubation by experienced team (have tracheostomy backup); blood culture + epiglottis swab AFTER airway secured; IV Ceftriaxone 100 mg/kg/d × 7-10 วัน (Hib first then Spn, GAS, Staph); ICU monitoring; rifampin chemoprophylaxis household contacts (unvaccinated < 4 yr); extubate 48-72 hr; vaccinate Hib

---

Epiglottitis (Hib mainly, now also Spn, GAS, Staph in vaccinated era) = airway emergency. Don''t disturb child (no agitation = no sudden obstruction). Controlled intubation by expert. Differentiate from croup (toxic, drooling, tripod, no cough). Hib vaccine dramatically reduced incidence.', NULL,
  'medium', 'respiratory', 'review',
  'pediatrics', 'ems_mgmt', 'respiratory', 'peds',
  'AAP Red Book 2024; UpToDate Epiglottitis in Children', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 4 ปี vaccine incomplete (no Hib) มา ED ด้วยไข้สูง 40°C 6 ชม น้ำลายไหล นั่งโน้มตัวไปข้างหน้า (tripod) เสียงแหบ ดูป่วยมาก ไม่ยอมนอน

V/S: HR 162, RR 32, SpO2 91%, Temp 40°C, BW 18 kg
Gen: toxic appearance, drooling, muffled voice, no cough, anxious
Avoid lateral neck X-ray in ED'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 18 เดือน ขณะเล่นกินถั่ว สำลักทันที ไอ เริ่ม wheeze ข้างขวา หอบเหนื่อย

V/S: HR 162, RR 48, SpO2 90% room air, Temp 37.0°C
Gen: alert, mild distress, asymmetric breath sound (decreased right) + unilateral expiratory wheeze right, no stridor

CXR inspiratory: normal; CXR expiratory: hyperinflation right lung + mediastinal shift left', '[{"label":"A","text":"Observe + albuterol + discharge"},{"label":"B","text":"Foreign body aspiration (likely right main bronchus"},{"label":"C","text":"Wait 2 weeks observation"},{"label":"D","text":"Heimlich blindly"},{"label":"E","text":"Empiric tuberculosis treatment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Foreign body aspiration (likely right main bronchus — peanut): NPO; pediatric ENT/pulm consultation; urgent rigid bronchoscopy ในห้องผ่าตัดภายใต้ GA — diagnostic + therapeutic (extract FB); avoid blind sweep + back blows ใน conscious child > 1 yr (เสี่ยง ดัน FB ลึก); ถ้า complete obstruction + unconscious → BLS algorithm (5 back blows + 5 chest thrusts < 1 yr, abdominal thrusts > 1 yr); O2 + monitor; antibiotic + steroid post-retrieval ถ้า มี mucosal injury; education on choking hazard

---

FBA = leading cause unintentional death < 4 yr. Peanut, nuts, grapes, hot dog common. Sudden choking + asymmetric findings = classic. Expiratory CXR (or lateral decubitus) reveals air trapping (ball-valve). Rigid bronchoscopy = diagnostic + therapeutic. Don''t delay.', NULL,
  'medium', 'respiratory', 'review',
  'pediatrics', 'ems_mgmt', 'respiratory', 'peds',
  'AAP Choking Prevention 2010; ERS Bronchoscopy Pediatric 2019', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 18 เดือน ขณะเล่นกินถั่ว สำลักทันที ไอ เริ่ม wheeze ข้างขวา หอบเหนื่อย

V/S: HR 162, RR 48, SpO2 90% room air, Temp 37.0°C
Gen: alert, mild distress, asymmetric breath sound (decreased right) + unilateral expiratory wheeze right, no stridor

CXR inspiratory: normal; CXR expiratory: hyperinflation right lung + mediastinal shift left'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 2 ปี BW 12 kg post-drowning rescue หลัง CPR 5 นาที ROSC แต่ HR 48/min พบ poor perfusion + capillary refill 5 sec + altered mental status + weak central pulses

V/S: HR 48, BP 70/40, SpO2 88% on 100% O2
Monitor: sinus bradycardia, no ectopy

ABG: pH 7.18, PaO2 110, PaCO2 32, HCO3 14', '[{"label":"A","text":"Defibrillation immediately"},{"label":"B","text":"Symptomatic bradycardia post-arrest (PALS 2020)"},{"label":"C","text":"Adenosine"},{"label":"D","text":"Cardioversion"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Symptomatic bradycardia post-arrest (PALS 2020): ensure adequate oxygenation + ventilation FIRST (most peds bradycardia hypoxia-driven); if HR < 60 + poor perfusion despite ventilation → start chest compressions; Epinephrine 0.01 mg/kg (0.1 mL/kg of 1:10,000) IV/IO q3-5 min; Atropine 0.02 mg/kg (min 0.1 mg, max 0.5 mg) IF vagal-mediated or AV block; identify + treat reversible causes (Hs and Ts — hypoxia in drowning); pacing only if drug-refractory + likely complete AV block; post-arrest care: targeted temperature, glucose control, family centered

---

PALS 2020: peds bradycardia mostly hypoxic — fix airway/breathing first. CPR if HR < 60 with poor perfusion despite ventilation. Epi first-line drug. Atropine for vagal/AV block. Post-arrest neuroprotection + targeted temperature management.', NULL,
  'medium', 'cardiovascular', 'review',
  'pediatrics', 'ems_mgmt', 'cardiovascular', 'peds',
  'AHA PALS Guidelines 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 2 ปี BW 12 kg post-drowning rescue หลัง CPR 5 นาที ROSC แต่ HR 48/min พบ poor perfusion + capillary refill 5 sec + altered mental status + weak central pulses

V/S: HR 48, BP 70/40, SpO2 88% on 100% O2
Monitor: sinus bradycardia, no ectopy

ABG: pH 7.18, PaO2 110, PaCO2 32, HCO3 14'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 6 ปี BW 22 kg กินกุ้ง 15 นาที ก่อน เริ่มมีลมพิษทั่วตัว + ปากบวม + เสียงแหบ + หอบเหนื่อย + wheeze + อาเจียน 2 ครั้ง

V/S: HR 158, BP 78/42, RR 38, SpO2 92%
Gen: anxious, generalized urticaria + angioedema, biphasic wheeze, weak pulses', '[{"label":"A","text":"Antihistamine oral + observe"},{"label":"B","text":"Anaphylaxis"},{"label":"C","text":"Steroid IV alone"},{"label":"D","text":"Diphenhydramine alone"},{"label":"E","text":"Watch + wait"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Anaphylaxis: IM Epinephrine 1:1000 = 0.01 mg/kg (max 0.3 mg = 0.3 mL) ต้น lateral thigh ทันที — first-line lifesaving; repeat q5-15 min ถ้าไม่ดีขึ้น; supine + legs up; high-flow O2 + airway support + albuterol ถ้า wheeze; IV fluid bolus 20 mL/kg crystalloid ถ้า hypotension; secondary: H1 antihistamine (diphenhydramine), H2 antihistamine, corticosteroid (ไม่ใช่ first-line, ไม่กัน biphasic); observe 4-6 ชม (biphasic 5%); discharge with EpiPen × 2 + allergist referral + action plan + avoidance

---

Anaphylaxis = clinical diagnosis. Epinephrine IM = first-line, no contraindication. Delay = mortality. Observation post-treatment 4-6 hr for biphasic reaction (5-20%). Always provide EpiPen × 2 + action plan + allergist referral. Common triggers: foods, insects, drugs, latex.', NULL,
  'easy', 'id', 'review',
  'pediatrics', 'ems_mgmt', 'id', 'peds',
  'WAO Anaphylaxis Guidance 2020; AAP Clinical Report 2017', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 6 ปี BW 22 kg กินกุ้ง 15 นาที ก่อน เริ่มมีลมพิษทั่วตัว + ปากบวม + เสียงแหบ + หอบเหนื่อย + wheeze + อาเจียน 2 ครั้ง

V/S: HR 158, BP 78/42, RR 38, SpO2 92%
Gen: anxious, generalized urticaria + angioedema, biphasic wheeze, weak pulses'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 3 ปี BW 14 kg ไข้สูง 40°C 24 ชม petechiae purpura ทั่วตัว ซึม ขาเย็น

V/S: HR 178, BP 68/30, RR 42, SpO2 92%, Temp 40°C, capillary refill 6 sec
Gen: lethargic, cold extremities, mottled, weak pulses, oliguria

Lactate 6.8, glucose 52, WBC 2,800, Plt 78,000, CRP 220, INR 1.8, fibrinogen 95', '[{"label":"A","text":"Antibiotic oral outpatient"},{"label":"B","text":"Pediatric septic shock (likely meningococcemia)"},{"label":"C","text":"Wait for culture results"},{"label":"D","text":"Diuretic first"},{"label":"E","text":"Discharge with oral antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric septic shock (likely meningococcemia): IV/IO access × 2 ภายใน 5 นาที; aggressive fluid resuscitation 10-20 mL/kg NSS/LR bolus × repeat up to 60 mL/kg ใน first hour (reassess after each bolus — risk fluid overload, hepatomegaly, rales); empiric Ceftriaxone 100 mg/kg/dose IV ภายใน 1 ชม (after culture if no delay); start epinephrine peripheral 0.05-0.3 mcg/kg/min ถ้า fluid-refractory (cold shock); norepi for warm shock; correct hypoglycemia, hypocalcemia, acidosis; intubate ถ้า impending failure; ICU + central + arterial line; stress dose hydrocortisone ถ้า catecholamine-resistant; transfer pediatric ICU

---

Surviving Sepsis Campaign Pediatric 2020: hour-1 bundle. Recognize early. Fluid resuscitation with reassessment for overload. Empiric antibiotic within 1 hr. Vasoactive support — epi for cold shock (low CO), norepi for warm (low SVR). Goals: normalize MAP, perfusion, lactate. Pediatric ICU.', NULL,
  'hard', 'id', 'review',
  'pediatrics', 'ems_mgmt', 'id', 'peds',
  'Surviving Sepsis Campaign International Guidelines for Pediatric Sepsis 2020 (Weiss SL et al.)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 3 ปี BW 14 kg ไข้สูง 40°C 24 ชม petechiae purpura ทั่วตัว ซึม ขาเย็น

V/S: HR 178, BP 68/30, RR 42, SpO2 92%, Temp 40°C, capillary refill 6 sec
Gen: lethargic, cold extremities, mottled, weak pulses, oliguria

Lactate 6.8, glucose 52, WBC 2,800, Plt 78,000, CRP 220, INR 1.8, fibrinogen 95'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกหญิงอายุ 8 เดือน ไข้สูง 39.4°C 2 วันโดยไม่มี source อาเจียน + irritable

V/S: HR 162, RR 32, Temp 39.4°C, BW 8 kg
Gen: alert, no focal source

UA cath: WBC 80/HPF, leukocyte esterase +++, nitrite +, bacteria ++
Cultures: pending; CBC: WBC 16,500', '[{"label":"A","text":"Outpatient observation"},{"label":"B","text":"Febrile UTI ใน infant"},{"label":"C","text":"Bag urine + oral antibiotic"},{"label":"D","text":"Discharge no antibiotic"},{"label":"E","text":"Antifungal first"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Febrile UTI ใน infant: ส่ง urine culture จาก catheterization (suprapubic also acceptable) ก่อนเริ่ม antibiotic; empiric IV Ceftriaxone 50-75 mg/kg/d (admit ถ้า < 2 mo, toxic, vomiting, dehydration); switch oral once afebrile + clinical improvement (total 7-14 วัน); renal/bladder ultrasound ทุกราย first febrile UTI; VCUG ถ้า abnormal US + recurrence + atypical course; ตรวจหา renal scarring (DMSA) selected; counsel hygiene + voiding habits; continuous prophylaxis only selected high-grade VUR/recurrence

---

AAP 2011/2016 UTI guideline: febrile infant 2-24 mo. Catheter or SPA sample (bag = high false +). E. coli most common. Imaging: US for all, VCUG selective. Long-term scarring risk → prompt treatment + follow-up. Circumcision reduces UTI in male infants.', NULL,
  'medium', 'renal_gu', 'review',
  'pediatrics', 'clinical_decision', 'renal_gu', 'peds',
  'AAP Clinical Practice Guideline: UTI in Febrile Infants 2011/2016', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกหญิงอายุ 8 เดือน ไข้สูง 39.4°C 2 วันโดยไม่มี source อาเจียน + irritable

V/S: HR 162, RR 32, Temp 39.4°C, BW 8 kg
Gen: alert, no focal source

UA cath: WBC 80/HPF, leukocyte esterase +++, nitrite +, bacteria ++
Cultures: pending; CBC: WBC 16,500'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 8 ปี Cola-colored urine + ขาบวม + ปวดศีรษะ 3 วัน 2 สัปดาห์ก่อนเป็น strep throat (untreated)

V/S: BP 142/96, HR 92, BW 28 kg
PE: periorbital edema, mild pretibial edema

UA: RBC 80+, RBC cast +, protein 2+, dysmorphic RBC
BUN 42, Cr 1.2, Albumin 3.6, C3 LOW, C4 normal, ASO HIGH', '[{"label":"A","text":"High-dose immunosuppression immediately"},{"label":"B","text":"Post-streptococcal Glomerulonephritis (PSGN)"},{"label":"C","text":"Steroid pulse therapy routinely"},{"label":"D","text":"Plasmapheresis"},{"label":"E","text":"Discharge with no follow-up"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-streptococcal Glomerulonephritis (PSGN): supportive care mainstay (self-limited 4-6 wk); salt + water restriction; loop diuretic (furosemide) สำหรับ edema + HT; antihypertensive (CCB, ACEI ระวัง AKI) ถ้า HT severe; treat residual strep infection (penicillin หรือ amoxicillin × 10 d); monitor BP + UA + renal function; admit ถ้า severe HT, encephalopathy, oliguria, electrolyte imbalance; recheck C3 ที่ 8 wk (ควรกลับมาปกติ — ถ้าไม่กลับ → คิด C3 glomerulopathy/MPGN); long-term BP + proteinuria follow-up

---

PSGN = classic acute nephritic syndrome เด็ก. ASO + low C3 (transient < 8 wk) + recent strep + hematuria + HT + edema. Most self-limit. Treatment supportive. Persistent low C3 > 8 wk → reconsider Dx (MPGN, C3GN, lupus).', NULL,
  'medium', 'renal_gu', 'review',
  'pediatrics', 'clinical_decision', 'renal_gu', 'peds',
  'KDIGO Glomerular Diseases Guideline 2021', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 8 ปี Cola-colored urine + ขาบวม + ปวดศีรษะ 3 วัน 2 สัปดาห์ก่อนเป็น strep throat (untreated)

V/S: BP 142/96, HR 92, BW 28 kg
PE: periorbital edema, mild pretibial edema

UA: RBC 80+, RBC cast +, protein 2+, dysmorphic RBC
BUN 42, Cr 1.2, Albumin 3.6, C3 LOW, C4 normal, ASO HIGH'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 4 ปี ตื่นเช้ามาตาบวม 1 สัปดาห์ น้ำหนักเพิ่ม 3 kg ใน 2 สัปดาห์ ขาบวมตอนเย็น ปัสสาวะเป็นฟอง

V/S: BP 100/64, HR 102, BW 18 kg (จาก 15 kg)
PE: periorbital + pretibial pitting edema, mild ascites

UA: protein 4+, no hematuria
Urine spot P/Cr 5.6
Albumin 1.8, Cholesterol 380, normal Cr, complement normal', '[{"label":"A","text":"Diuretic alone"},{"label":"B","text":"Idiopathic Nephrotic Syndrome (likely Minimal Change Disease)"},{"label":"C","text":"Cyclophosphamide first-line"},{"label":"D","text":"ACEI alone"},{"label":"E","text":"Discharge no medication"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Idiopathic Nephrotic Syndrome (likely Minimal Change Disease): prednisolone 60 mg/m²/d (max 60 mg) PO × 4-6 wk → 40 mg/m² alternate day × 4-6 wk → taper (total 12 wk standard course); salt restriction + cautious diuretic ถ้า severe edema; albumin 25% + furosemide ถ้า severe edema + low IV volume; penicillin prophylaxis (pneumococcal peritonitis risk); pneumococcal + influenza vaccine; thromboprophylaxis selected (severe albumin < 2); biopsy ถ้า atypical (age < 1 or > 12, hematuria, HT, AKI, low C3, steroid-resistant, frequent relapse + steroid toxic); monitor BP + growth + bone density

---

Pediatric NS = MCD ในเด็กส่วนใหญ่ (> 90%, ages 2-10). Triad: proteinuria, hypoalbuminemia, edema (+ hyperlipidemia). Steroid response = MCD typical. Complications: infection (encapsulated organisms), VTE, AKI. Steroid-resistant → biopsy + alternative immunosuppression.', NULL,
  'medium', 'renal_gu', 'review',
  'pediatrics', 'clinical_decision', 'renal_gu', 'peds',
  'KDIGO Glomerular Diseases Guideline 2021; ISKDC criteria', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 4 ปี ตื่นเช้ามาตาบวม 1 สัปดาห์ น้ำหนักเพิ่ม 3 kg ใน 2 สัปดาห์ ขาบวมตอนเย็น ปัสสาวะเป็นฟอง

V/S: BP 100/64, HR 102, BW 18 kg (จาก 15 kg)
PE: periorbital + pretibial pitting edema, mild ascites

UA: protein 4+, no hematuria
Urine spot P/Cr 5.6
Albumin 1.8, Cholesterol 380, normal Cr, complement normal'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 5 ปี เหนื่อยง่าย + ซีด 3 สัปดาห์ + ปวดขา + petechiae + bruise + ต่อมน้ำเหลืองโต ทั่วตัว + hepatosplenomegaly

V/S: HR 138, Temp 38.4°C, BW 18 kg
PE: pallor, generalized lymphadenopathy, liver 4 cm, spleen 6 cm BCM

CBC: WBC 68,500 (blasts 78%), Hb 6.2, Plt 28,000
Peripheral smear: lymphoblasts
LDH 1,840, Uric acid 8.6', '[{"label":"A","text":"Antibiotic alone"},{"label":"B","text":"Acute Lymphoblastic Leukemia (likely B-ALL, most common peds cancer)"},{"label":"C","text":"Steroid alone"},{"label":"D","text":"Watch + wait"},{"label":"E","text":"Splenectomy first"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Lymphoblastic Leukemia (likely B-ALL, most common peds cancer): admit oncology; flow cytometry + cytogenetics + molecular (BCR-ABL, MLL, hyperdiploidy); LP + bone marrow biopsy ใน first week; risk stratification (NCI age 1-10 + WBC < 50K = standard risk); induction chemo (vincristine + dexa/pred + asparaginase + ± anthracycline); tumor lysis prophylaxis — hydration 2× maintenance + allopurinol or rasburicase + monitor K, P, Ca, urate, Cr; transfusion: PRBC for Hb < 7 หรือ symptomatic, platelet for < 10K หรือ bleeding; central line; G-CSF selected; long-term: 2-3 yr therapy + late effects monitoring

---

ALL = most common pediatric cancer (peak 2-5 yr). 5-yr survival > 90% with modern protocols. Tumor lysis = major early complication. CNS prophylaxis intrathecal. Down syndrome + ALL = unique biology. Long-term: cardio, neuro, second malignancy.', NULL,
  'medium', 'hemato_onco', 'review',
  'pediatrics', 'clinical_decision', 'hemato_onco', 'peds',
  'COG/POG Protocols; Hunger SP NEJM 2015 ALL Review', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 5 ปี เหนื่อยง่าย + ซีด 3 สัปดาห์ + ปวดขา + petechiae + bruise + ต่อมน้ำเหลืองโต ทั่วตัว + hepatosplenomegaly

V/S: HR 138, Temp 38.4°C, BW 18 kg
PE: pallor, generalized lymphadenopathy, liver 4 cm, spleen 6 cm BCM

CBC: WBC 68,500 (blasts 78%), Hb 6.2, Plt 28,000
Peripheral smear: lymphoblasts
LDH 1,840, Uric acid 8.6'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 4 ปี petechiae + bruising เกิดขึ้นเอง 1 สัปดาห์ ก่อนหน้า 2 สัปดาห์เป็น URI well-appearing

V/S ปกติ, BW 16 kg
PE: scattered petechiae arms + legs + trunk, no hepatosplenomegaly, no lymphadenopathy

CBC: WBC 7,200 (normal diff), Hb 12.4, Plt 8,000
Peripheral smear: large platelets, no blasts, no schistocytes', '[{"label":"A","text":"Splenectomy"},{"label":"B","text":"Acute Immune Thrombocytopenia (ITP, post-viral, typical)"},{"label":"C","text":"Bone marrow biopsy mandatory all"},{"label":"D","text":"Chemotherapy"},{"label":"E","text":"Antibiotic prophylaxis"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Immune Thrombocytopenia (ITP, post-viral, typical): ในเด็กที่ no/mild bleeding (skin only) → observation alone ตามแนวทาง ASH 2019 (most spontaneous resolution 4-8 wk); หลีกเลี่ยง contact sports + NSAID/aspirin; education สัญญาณเลือดออกหนัก; first-line ถ้ามี bleeding significant: IVIG 0.8-1 g/kg single dose หรือ anti-D (Rh+ non-splenectomized) หรือ corticosteroid (prednisolone 2-4 mg/kg/d × 5-7 d then taper); platelet transfusion เฉพาะ life-threatening bleed; ถ้า chronic > 12 mo → rituximab, TPO agonists; rule out other causes (smear + family Hx)

---

ITP = isolated thrombocytopenia, typical post-viral. Most peds = acute, self-limit. ASH 2019: observation for skin-only bleeding regardless of platelet count. Treat if significant mucosal bleed. Bone marrow not required if typical features (no atypical labs/exam).', NULL,
  'easy', 'hemato_onco', 'review',
  'pediatrics', 'clinical_decision', 'hemato_onco', 'peds',
  'ASH 2019 ITP Guideline (Neunert C et al.)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 4 ปี petechiae + bruising เกิดขึ้นเอง 1 สัปดาห์ ก่อนหน้า 2 สัปดาห์เป็น URI well-appearing

V/S ปกติ, BW 16 kg
PE: scattered petechiae arms + legs + trunk, no hepatosplenomegaly, no lymphadenopathy

CBC: WBC 7,200 (normal diff), Hb 12.4, Plt 8,000
Peripheral smear: large platelets, no blasts, no schistocytes'
  );

commit;

