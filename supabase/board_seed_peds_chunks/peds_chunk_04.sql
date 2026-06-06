-- ===============================================================
-- หมอรู้ — Pediatrics seed: chunk 4/10
-- Questions 61-80 of 200
-- Safe to paste into Supabase SQL Editor. Re-runnable.
-- Can run chunks in ANY order. Dedup by scenario.
-- ===============================================================

begin;

-- subjects (idempotent, same on every chunk)
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
  s.id, 'board', NULL, 'ทารกอายุ 3 เดือน BW 4.2 kg (จาก BW เกิด 3.4 kg — เพิ่ม < 30 g/d) feed นมไม่ดี sweating ขณะ feed หอบขณะ feed

V/S: HR 158, RR 62, SpO2 96%, BW 4.2 kg
PE: tachypnea, mild retraction, hepatomegaly 3 cm, harsh holosystolic murmur grade 4/6 LLSB + diastolic rumble apex, hyperdynamic precordium
CXR: cardiomegaly + increased pulmonary vascularity
Echo: large perimembranous VSD 8 mm + L→R shunt + LV/LA enlargement', '[{"label":"A","text":"Observe + repeat echo 1 yr"},{"label":"B","text":"Large VSD with congestive heart failure + failure to thrive: anti-HF therapy — furosemide 1-2 mg/kg/dose q8-12h PO + spironolactone 1-2 mg/kg/d + captopril 0.1-0.3 mg/kg/dose q8h (increase as tolerated, monitor BP + renal); high-calorie nutrition (24-27 kcal/oz formula) + may need NG feeds; treat anemia (keep Hb ≥ 10); RSV prophylaxis ในฤดู; immunizations on time; surgical/catheter closure 3-6 mo ของวัย ถ้า: persistent HF/FTT despite therapy, pulmonary HT, large shunt + Qp:Qs > 2; small restrictive VSD ส่วนใหญ่ปิดเอง (35-40%); cardiology follow-up; endocarditis prophylaxis routine NOT recommended unless prior IE/repair < 6 mo"},{"label":"C","text":"Diuretic alone forever"},{"label":"D","text":"Cardiac transplant"},{"label":"E","text":"Discharge no medication"}]'::jsonb,
  'B', 'VSD = most common CHD. Large VSD = HF + FTT. Manage HF medically + nutritional + timed surgical closure. Small VSD often closes spontaneously. AHA 2018 endocarditis prophylaxis only for highest-risk lesions (cyanotic, prosthetic, prior IE, < 6 mo post-repair).', NULL,
  'medium', 'cardiovascular', 'review',
  'pediatrics', 'clinical_decision', 'cardiovascular', 'peds',
  'AHA/ACC 2018 ACHD Guideline; Park Pediatric Cardiology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกอายุ 3 เดือน BW 4.2 kg (จาก BW เกิด 3.4 kg — เพิ่ม < 30 g/d) feed นมไม่ดี sweating ขณะ feed หอบขณะ feed

V/S: HR 158, RR 62, SpO2 96%, BW 4.2 kg
PE: tachypnea, mild retraction, hepatomegaly 3 cm, harsh holosystolic murmur grade 4/6 LLSB + diastolic rumble apex, hyperdynamic precordium
CXR: cardiomegaly + increased pulmonary vascularity
Echo: large perimembranous VSD 8 mm + L→R shunt + LV/LA enlargement'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกชายอายุ 6 เดือน known Tetralogy of Fallot (still pre-repair) ตื่นเช้ามาร้องไห้แล้ว cyanotic วูบลง SpO2 ลดเหลือ 60% หายใจหอบเหนื่อย irritable

V/S: HR 178, BP 78/42, RR 58, SpO2 60% room air, BW 6 kg
Gen: marked cyanosis, irritable, decreased intensity of pulmonic ejection murmur (vs baseline harsh)', '[{"label":"A","text":"Beta agonist nebulizer"},{"label":"B","text":"Tetralogy of Fallot ''tet spell'' (hypercyanotic spell): calm + knee-chest position (เพิ่ม SVR); 100% O2 mask; IV access + Morphine 0.1 mg/kg IM/IV หรือ SC (sedate + decrease respiratory effort + decrease infundibular spasm); IV fluid bolus 10-20 mL/kg NSS (increase preload + RV filling); Phenylephrine 0.02 mg/kg IV หรือ IV infusion ถ้า refractory (increase SVR); sodium bicarbonate ถ้า severe acidosis; Esmolol/Propranolol IV ถ้า spell continues (decrease infundibular contractility); AVOID inotropic agents (worsen RVOT obstruction); urgent cardiology + cardiac surgery — definitive surgical repair recommended now (delayed repair = more spells); admit ICU"},{"label":"C","text":"Diuretic IV"},{"label":"D","text":"Inotropic agent"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', 'Tet spell = acute increase in RVOT obstruction + decrease SVR → severe R→L shunt → hypoxia. Treatment increases SVR + reduces infundibular spasm. Knee-chest position increases SVR + venous return. Phenylephrine for refractory. Avoid inotropes (worsen obstruction). Definitive surgical repair after spell.', NULL,
  'hard', 'cardiovascular', 'review',
  'pediatrics', 'ems_mgmt', 'cardiovascular', 'peds',
  'AHA 2018 ACHD; Park Pediatric Cardiology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกชายอายุ 6 เดือน known Tetralogy of Fallot (still pre-repair) ตื่นเช้ามาร้องไห้แล้ว cyanotic วูบลง SpO2 ลดเหลือ 60% หายใจหอบเหนื่อย irritable

V/S: HR 178, BP 78/42, RR 58, SpO2 60% room air, BW 6 kg
Gen: marked cyanosis, irritable, decreased intensity of pulmonic ejection murmur (vs baseline harsh)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกอายุ 2 เดือน BW 5 kg มาด้วย irritability + poor feeding 6 ชม ก่อน HR fast monitor

V/S: HR 240, BP 75/45, RR 52, SpO2 98%, capillary refill 3 sec
Gen: irritable but alert, no distress
ECG: narrow complex tachycardia rate 240, no P wave, regular rhythm = SVT (likely AVRT)', '[{"label":"A","text":"Immediate unsynchronized defibrillation"},{"label":"B","text":"Pediatric SVT (stable, narrow complex regular tachycardia): vagal maneuvers FIRST — apply ice pack/bag to face × 15-30 sec (diving reflex, most effective ใน infants); ถ้าไม่กลับ → Adenosine 0.1 mg/kg IV rapid push + flush via proximal IV (max 6 mg first dose, repeat 0.2 mg/kg max 12 mg); ถ้า unstable (poor perfusion, AMS, HF) → synchronized cardioversion 0.5-1 J/kg → 2 J/kg; identify + treat reversible causes; cardiology consult; long-term: digoxin หรือ propranolol prophylaxis; ablation for recurrent/refractory; counsel family about recurrence + vagal maneuvers at home"},{"label":"C","text":"Lidocaine bolus"},{"label":"D","text":"Magnesium IV"},{"label":"E","text":"Discharge no treatment"}]'::jsonb,
  'B', 'SVT = most common dysrhythmia infants. Vagal maneuvers (ice to face) first if stable. Adenosine = drug of choice. Synchronized cardioversion if unstable. WPW common substrate in infants. Long-term: medication or ablation.', NULL,
  'medium', 'cardiovascular', 'review',
  'pediatrics', 'ems_mgmt', 'cardiovascular', 'peds',
  'AHA PALS 2020; Pediatric Cardiology guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกอายุ 2 เดือน BW 5 kg มาด้วย irritability + poor feeding 6 ชม ก่อน HR fast monitor

V/S: HR 240, BP 75/45, RR 52, SpO2 98%, capillary refill 3 sec
Gen: irritable but alert, no distress
ECG: narrow complex tachycardia rate 240, no P wave, regular rhythm = SVT (likely AVRT)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 11 ปี ปวดข้อหลายข้อย้ายที่ × 2 สัปดาห์ ไข้ 38.5°C ใจสั่น 3 สัปดาห์ก่อนเคย sore throat untreated

V/S: HR 122, BP 105/68, Temp 38.5°C
PE: migratory polyarthritis (knees, elbows), erythema marginatum, subcutaneous nodules, soft systolic murmur apex new

Lab: ESR 78, CRP 95, ASO HIGH, anti-DNase B HIGH
ECG: PR interval 240 ms (prolonged)
Echo: mild MR + mild AR, no vegetation', '[{"label":"A","text":"NSAID alone"},{"label":"B","text":"Acute Rheumatic Fever (Jones criteria revised 2015 — 2 major + evidence GAS): admit + bed rest until afebrile + ESR normalize; eradication GAS — benzathine penicillin G IM 600,000-1,200,000 U single dose (or PO penicillin V × 10 d); arthritis + carditis — high-dose aspirin 80-100 mg/kg/d ÷ 4 doses (monitor salicylate level, hepatotoxicity); severe carditis (CHF, severe valve insufficiency) — corticosteroid (prednisolone 1-2 mg/kg/d × 2-3 wk taper); Sydenham chorea — supportive ± haloperidol/valproic acid; HF management; ECHO + serial; SECONDARY PROPHYLAXIS critical — benzathine penicillin IM q3-4 wk ต่อ minimum 10 ปี หรือถึง 21 ปี (without carditis) หรือ 40 ปี/lifelong (with carditis); dental prophylaxis only for severe valve disease per AHA"},{"label":"C","text":"Antibiotic only 7 days"},{"label":"D","text":"Cardioversion"},{"label":"E","text":"Anticoagulation high dose"}]'::jsonb,
  'B', 'ARF = post-strep autoimmune. Jones criteria revised 2015 (low + high-risk populations). Major: carditis, arthritis, chorea, erythema marginatum, subcutaneous nodules. Long-term secondary prophylaxis critical — duration depends on carditis severity. Pen V or benzathine IM standard.', NULL,
  'medium', 'cardiovascular', 'review',
  'pediatrics', 'clinical_decision', 'cardiovascular', 'peds',
  'Jones Criteria 2015 (Gewitz MH AHA); WHF Position Statement 2024', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 11 ปี ปวดข้อหลายข้อย้ายที่ × 2 สัปดาห์ ไข้ 38.5°C ใจสั่น 3 สัปดาห์ก่อนเคย sore throat untreated

V/S: HR 122, BP 105/68, Temp 38.5°C
PE: migratory polyarthritis (knees, elbows), erythema marginatum, subcutaneous nodules, soft systolic murmur apex new

Lab: ESR 78, CRP 95, ASO HIGH, anti-DNase B HIGH
ECG: PR interval 240 ms (prolonged)
Echo: mild MR + mild AR, no vegetation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกชายอายุ 6 เดือน เกิด meconium ileus DOL 2 + chronic loose foul-smelling stool + poor weight gain + recurrent pneumonia + chronic cough

BW 5.8 kg (< 3rd percentile), length 60 cm (< 3rd)
PE: clubbing early, wheeze, hyperinflation, decreased subcutaneous fat

Sweat chloride 78 mmol/L (> 60 = positive), CFTR genotype: F508del/F508del (homozygous classic)
Stool elastase: very low (pancreatic insufficient)', '[{"label":"A","text":"Antibiotic only as needed"},{"label":"B","text":"Cystic Fibrosis (classic F508del homozygous) — multidisciplinary CF center care: airway clearance — chest physiotherapy + nebulized hypertonic saline 7% + dornase alfa daily; bronchodilator pre-airway clearance; pancreatic enzyme replacement (PERT) 1500-2500 lipase units/kg/meal — monitor + titrate; high-calorie diet (110-200% of normal need) + fat-soluble vitamin (ADEK) supplement + salt supplement; treat infection — sputum culture q3 mo, treat Staph (anti-staph penicillin), Pseudomonas (inhaled tobramycin or colistin) chronically suppressive; CFTR modulator — elexacaftor/tezacaftor/ivacaftor (Trikafta) ≥ 2 yr F508del = transformative; vaccinations (RSV, flu, COVID); CF-related diabetes screen annually > 10 yr; liver, bone, sinus, fertility monitoring; mental health; psychosocial support"},{"label":"C","text":"Steroid daily"},{"label":"D","text":"Restrict salt"},{"label":"E","text":"Diuretic"}]'::jsonb,
  'B', 'CF = autosomal recessive, F508del most common mutation. Multisystem: lung, pancreas, sweat, sinuses, liver, fertility. Newborn screening (IRT + DNA). CFTR modulators revolutionized care. Median survival now 50+ yr. Center-based multidisciplinary care essential.', NULL,
  'medium', 'respiratory', 'review',
  'pediatrics', 'basic_science', 'respiratory', 'peds',
  'CF Foundation Clinical Practice Guidelines 2024', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกชายอายุ 6 เดือน เกิด meconium ileus DOL 2 + chronic loose foul-smelling stool + poor weight gain + recurrent pneumonia + chronic cough

BW 5.8 kg (< 3rd percentile), length 60 cm (< 3rd)
PE: clubbing early, wheeze, hyperinflation, decreased subcutaneous fat

Sweat chloride 78 mmol/L (> 60 = positive), CFTR genotype: F508del/F508del (homozygous classic)
Stool elastase: very low (pancreatic insufficient)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกชายอายุ 2 เดือน vaccine ยังไม่ครบ (DTaP เพิ่งได้ครั้งแรก) ไอ paroxysmal 2 สัปดาห์ + whooping inspiration หลังไอ + cyanosis ขณะไอ + post-tussive emesis แม่เพิ่งเป็นหวัด chronic cough

V/S: HR 168, RR 52, SpO2 92%, Temp 37.6°C, BW 5 kg
Gen: well between coughing fits, lethargic during, post-tussive cyanosis

CBC: WBC 38,500, lymphocytosis 78% (absolute lymphocyte > 20,000)
Nasopharyngeal PCR for Bordetella pertussis: positive', '[{"label":"A","text":"Discharge home"},{"label":"B","text":"Pertussis < 6 mo = high risk severe: admit (apnea, pulmonary HT, death risk); macrolide (azithromycin 10 mg/kg/d × 5 d preferred ในเด็ก < 1 mo เพื่อหลีกเลี่ยง erythromycin/IHPS); supportive — O2, monitor for apnea/cyanosis (continuous cardiopulmonary), suction, IV fluid, small frequent feeds; consider exchange transfusion ถ้า extreme leukocytosis + pulmonary HT (lifesaving in severe cases); droplet isolation 5 d after start macrolide; ICU + intubation ถ้า respiratory failure; reportable disease; post-exposure prophylaxis household contacts macrolide; Tdap booster mother + cocooning + maternal Tdap during pregnancy (27-36 wk) สำคัญ; complete DTaP catch-up"},{"label":"C","text":"Bronchodilator only"},{"label":"D","text":"Steroid"},{"label":"E","text":"Antiviral"}]'::jsonb,
  'B', 'Pertussis < 6 mo = high mortality. Macrolide reduces shedding (azithromycin first-line). Maternal Tdap during pregnancy + cocooning protects infants until immunized. Extreme leukocytosis (> 50K) + pulmonary HT = exchange transfusion considered. Reportable.', NULL,
  'medium', 'id', 'review',
  'pediatrics', 'clinical_decision', 'id', 'peds',
  'AAP Red Book 2024; CDC Pertussis Treatment Guideline', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกชายอายุ 2 เดือน vaccine ยังไม่ครบ (DTaP เพิ่งได้ครั้งแรก) ไอ paroxysmal 2 สัปดาห์ + whooping inspiration หลังไอ + cyanosis ขณะไอ + post-tussive emesis แม่เพิ่งเป็นหวัด chronic cough

V/S: HR 168, RR 52, SpO2 92%, Temp 37.6°C, BW 5 kg
Gen: well between coughing fits, lethargic during, post-tussive cyanosis

CBC: WBC 38,500, lymphocytosis 78% (absolute lymphocyte > 20,000)
Nasopharyngeal PCR for Bordetella pertussis: positive'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 6 ปี พ่ออยู่บ้านเดียวกันเพิ่ง diagnosis active pulmonary TB smear+ TB clinic ส่งมาประเมิน

เด็ก asymptomatic, no cough, no fever, no weight loss; BW 20 kg, normal exam
CXR: clear (no infiltrate, no LN)
Tuberculin skin test (TST) 12 mm induration, IGRA positive', '[{"label":"A","text":"No treatment indicated"},{"label":"B","text":"Latent TB Infection (LTBI, child < 5 yr or close contact = high priority): start LTBI treatment — INH 10 mg/kg/d × 6-9 mo (standard) หรือ rifampin 15-20 mg/kg/d × 4 mo (shorter, fewer hepatotoxicity) หรือ INH + rifapentine once weekly × 12 wk (3HP, ≥ 2 yr); pyridoxine 1-2 mg/kg/d supplement (prevent INH neuropathy in malnourished, breastfed, vegetarian); monthly clinical evaluation (compliance, hepatotoxicity); LFT baseline + as needed; address index case + screen household; CXR + symptoms re-evaluate ถ้า new symptoms; education + DOTS if compliance concern; report public health; vaccinate BCG not protective against pulmonary TB but reduces meningitis/miliary"},{"label":"C","text":"Active TB regimen 6 months"},{"label":"D","text":"Wait for symptoms"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', 'Pediatric LTBI = critical to treat (high progression to active TB). 6-9 mo INH classic; 4 mo rifampin or 3HP equally effective with fewer side effects + better adherence. Pyridoxine supplement. CDC/WHO recommend LTBI treatment for child close contacts.', NULL,
  'medium', 'id', 'review',
  'pediatrics', 'basic_science', 'id', 'peds',
  'WHO Consolidated Guidelines Tuberculosis 2022; CDC LTBI Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 6 ปี พ่ออยู่บ้านเดียวกันเพิ่ง diagnosis active pulmonary TB smear+ TB clinic ส่งมาประเมิน

เด็ก asymptomatic, no cough, no fever, no weight loss; BW 20 kg, normal exam
CXR: clear (no infiltrate, no LN)
Tuberculin skin test (TST) 12 mm induration, IGRA positive'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 4 ปี ก่อนหน้านี้ healthy 1 สัปดาห์ ก่อนมี viral URI + diarrhea ตอนนี้ดูเหนื่อยง่าย หอบเหนื่อยเวลาเดิน ดูดนมไม่ดี dependent edema

V/S: HR 168 sinus, BP 82/52, RR 48, SpO2 94%, BW 16 kg
PE: gallop S3, jugular distention, hepatomegaly 4 cm, rales, decreased pulses, cap refill 4 sec

CBC normal, troponin HIGH (12 ng/mL), BNP 1,820, CK-MB elevated
CXR: cardiomegaly + pulmonary edema
Echo: dilated LV + EF 22% + global hypokinesis
Viral PCR: enterovirus +', '[{"label":"A","text":"Diuretic alone forever"},{"label":"B","text":"Viral Myocarditis with acute decompensated HF: ICU admission with continuous monitoring; ABC + supplemental O2 + non-invasive ventilation/intubation ถ้า severe; gentle fluid resuscitation (watch for worsening HF); inotropic support — milrinone (preferred — inodilator, less arrhythmogenic) 0.25-0.75 mcg/kg/min หรือ low-dose epinephrine; diuretic furosemide IV; afterload reduction (carvedilol, ACEI) เมื่อ stable; mechanical circulatory support (VAD, ECMO) ถ้า refractory cardiogenic shock; arrhythmia management (avoid digoxin acutely); IVIG controversial — selected cases; routine immunosuppression NOT recommended; treat underlying infection; HF + arrhythmia team + cardiac transplant evaluation ถ้า persistent; long-term: gradual recovery 50-70%, residual cardiomyopathy 20-30%, death/transplant 10%; restrict activity 3-6 mo"},{"label":"C","text":"High-dose steroid mandatory"},{"label":"D","text":"Antibiotic alone"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', 'Viral myocarditis = leading cause acute DCM kids. Enterovirus, parvo, adeno, SARS-CoV-2 common. ICU + inotropic + mechanical support. ECMO bridge to recovery/transplant. Steroid/IVIG limited evidence — selected cases. 3 outcomes: recovery, chronic DCM, death.', NULL,
  'hard', 'cardiovascular', 'review',
  'pediatrics', 'clinical_decision', 'cardiovascular', 'peds',
  'AHA Scientific Statement: Pediatric Myocarditis 2018; ISHLT Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 4 ปี ก่อนหน้านี้ healthy 1 สัปดาห์ ก่อนมี viral URI + diarrhea ตอนนี้ดูเหนื่อยง่าย หอบเหนื่อยเวลาเดิน ดูดนมไม่ดี dependent edema

V/S: HR 168 sinus, BP 82/52, RR 48, SpO2 94%, BW 16 kg
PE: gallop S3, jugular distention, hepatomegaly 4 cm, rales, decreased pulses, cap refill 4 sec

CBC normal, troponin HIGH (12 ng/mL), BNP 1,820, CK-MB elevated
CXR: cardiomegaly + pulmonary edema
Echo: dilated LV + EF 22% + global hypokinesis
Viral PCR: enterovirus +'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 5 ปี diarrhea bloody × 5 วัน หลังกินเนื้อ undercooked วันนี้ปัสสาวะน้อย ซีด เหนื่อยง่าย

V/S: BP 132/86, HR 122, BW 20 kg
PE: pallor, mild edema, petechiae, mild hepatosplenomegaly

CBC: Hb 7.2, Plt 38,000, WBC 14,500
Peripheral smear: schistocytes ++, helmet cells
BUN 68, Cr 2.4, K 5.8, Albumin 3.0
UA: protein 2+, RBC, granular cast
Stool culture: E. coli O157:H7 positive (Shiga toxin)', '[{"label":"A","text":"Antibiotic for EHEC"},{"label":"B","text":"Typical HUS (post-EHEC Shiga toxin): supportive care mainstay (no specific treatment cures); fluid management — careful IV fluid early in disease may prevent oliguric phase, but ONCE oliguric → restrict to insensible + UO; correct electrolytes (K, P, Ca); transfuse PRBC for Hb < 6 หรือ symptomatic; AVOID platelet transfusion (worsens microangiopathy) unless major bleeding/surgery; renal replacement therapy (HD, CRRT, PD) ถ้า severe AKI/uremia/hyperK/volume overload — needed ~50%; treat HT; AVOID antibiotic for EHEC (increases Shiga toxin release + HUS risk in some studies); AVOID antimotility (loperamide, opioid); plasma exchange not indicated typical HUS; eculizumab for atypical HUS (complement dysregulation, recurrent, family Hx); long-term renal + BP follow-up; reportable disease + public health"},{"label":"C","text":"Loperamide"},{"label":"D","text":"Heparin"},{"label":"E","text":"Aspirin"}]'::jsonb,
  'B', 'Typical HUS = MAHA + thrombocytopenia + AKI post-EHEC Shiga toxin. Supportive only. Avoid antibiotic + antimotility (worsen). Atypical HUS (complement) = eculizumab. Long-term CKD risk 25%. Public health reporting (foodborne).', NULL,
  'hard', 'renal_gu', 'review',
  'pediatrics', 'clinical_decision', 'renal_gu', 'peds',
  'KDIGO Glomerular Diseases 2021; AAP Red Book 2024', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 5 ปี diarrhea bloody × 5 วัน หลังกินเนื้อ undercooked วันนี้ปัสสาวะน้อย ซีด เหนื่อยง่าย

V/S: BP 132/86, HR 122, BW 20 kg
PE: pallor, mild edema, petechiae, mild hepatosplenomegaly

CBC: Hb 7.2, Plt 38,000, WBC 14,500
Peripheral smear: schistocytes ++, helmet cells
BUN 68, Cr 2.4, K 5.8, Albumin 3.0
UA: protein 2+, RBC, granular cast
Stool culture: E. coli O157:H7 positive (Shiga toxin)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 10 ปี polyuria + polydipsia + weight loss 4 kg × 6 wk ไม่มีอาเจียน ไม่ซึม

V/S: BP 110/70, HR 92, BW 30 kg
Gen: alert, mild dehydration

Glucose random 320, HbA1c 11.2%, no ketones serum/urine, pH 7.36, HCO3 22
Anti-GAD65 + IA-2 antibodies positive (T1DM autoimmune)', '[{"label":"A","text":"Metformin alone"},{"label":"B","text":"New-onset Type 1 Diabetes without DKA: start subcutaneous insulin — basal-bolus regimen (preferred): glargine/detemir/degludec long-acting once daily (~0.4-0.5 U/kg/d total = 50% basal, 50% bolus) + rapid-acting (lispro, aspart, glulisine) pre-meal based on carb counting + correction; alternative: NPH + regular insulin ทวีติด; start total daily insulin 0.5-1 U/kg/d (peripubertal more); diabetes team education (carb counting, glucose monitoring 4-6×/d or CGM, sick day rules, hypoglycemia recognition + glucagon, exercise, ketone monitoring); HbA1c target < 7.5% (ADA recent: individualize, < 7% if achievable safely); annual screen — TSH, celiac, retinopathy (≥ 11 yr or 2-5 yr post-Dx), microalbuminuria (≥ 11 yr or 2-5 yr), lipid; immunizations (flu, pneumococcal); psychosocial support; transition to adult care; technology — CGM, insulin pump, AID systems greatly improve outcomes"},{"label":"C","text":"Sulfonylurea"},{"label":"D","text":"Lifestyle alone"},{"label":"E","text":"Discharge no treatment"}]'::jsonb,
  'B', 'T1DM = autoimmune β-cell destruction. Insulin mandatory. ISPAD/ADA: basal-bolus or pump = standard. Carb counting + flexible insulin + CGM = modern. Address comorbidities + transition. AID closed-loop systems improve TIR + reduce burden.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'pediatrics', 'clinical_decision', 'endocrine_metabolic', 'peds',
  'ISPAD Guidelines 2022; ADA Standards of Care 2024', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 10 ปี polyuria + polydipsia + weight loss 4 kg × 6 wk ไม่มีอาเจียน ไม่ซึม

V/S: BP 110/70, HR 92, BW 30 kg
Gen: alert, mild dehydration

Glucose random 320, HbA1c 11.2%, no ketones serum/urine, pH 7.36, HCO3 22
Anti-GAD65 + IA-2 antibodies positive (T1DM autoimmune)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารก LGA term BW 4,400 g (IDM — mother GDM A2 on insulin) อายุ 2 ชม jittery + lethargic + poor feeding

V/S: HR 152, RR 48, SpO2 96%, Temp 36.8°C
Gen: alert at moments, jittery, mild distress

Bedside glucose 28 mg/dL (< 47 = abnormal; cutoff < 50 symptomatic according to recent AAP)
No seizure', '[{"label":"A","text":"Wait until 6 hr"},{"label":"B","text":"Neonatal Hypoglycemia (symptomatic, IDM): IV access + start IV dextrose — give bolus D10W 2 mL/kg (200 mg/kg) slow IV push then continuous D10W infusion GIR 6-8 mg/kg/min, titrate up to achieve glucose > 50 mg/dL (< 48h) and > 60 mg/dL (> 48h); recheck glucose 15-30 min after intervention then q1-2h until stable; continue regular feeds (breast or formula) once stable + tolerating; gradually wean IV as PO intake increases (rebound common); if persistent hypoglycemia despite GIR 12-15 mg/kg/min → think hyperinsulinism (diazoxide, octreotide, glucagon), inborn error, hormone deficiency; check critical sample (insulin, cortisol, GH, lactate, ketones, FFA, ammonia, AC profile) ขณะ hypo; long-term: neurodevelopmental follow-up severe/prolonged"},{"label":"C","text":"Glucose oral gel only"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Insulin"}]'::jsonb,
  'B', 'Neonatal hypoglycemia = preventable cause neurodisability. Symptomatic + glucose < 47 (PES 2015) or < 50 (AAP) = treat. IDM = transient hyperinsulinism, screen + feed early. Persistent severe → workup for hyperinsulinism/inborn error. Avoid prolonged hypoglycemia.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'pediatrics', 'clinical_decision', 'endocrine_metabolic', 'peds',
  'AAP Clinical Report on Neonatal Hypoglycemia 2011; PES 2015', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารก LGA term BW 4,400 g (IDM — mother GDM A2 on insulin) อายุ 2 ชม jittery + lethargic + poor feeding

V/S: HR 152, RR 48, SpO2 96%, Temp 36.8°C
Gen: alert at moments, jittery, mild distress

Bedside glucose 28 mg/dL (< 47 = abnormal; cutoff < 50 symptomatic according to recent AAP)
No seizure'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 3 ปี อยู่บ้านเก่าทาสีก่อน 1978 มี pica eating paint chips มา clinic ด้วย irritability + decreased appetite + abdominal pain intermittent + developmental delay (speech)

BW 13 kg, no organomegaly
CBC: Hb 9.8, MCV 70, basophilic stippling +
Blood lead level (BLL) 52 mcg/dL
AXR: paint chip in colon', '[{"label":"A","text":"No treatment if asymptomatic"},{"label":"B","text":"Pediatric Lead Poisoning BLL ≥ 45 mcg/dL = chelation therapy indicated: หา + remove lead source FIRST (critical — re-exposure futile chelation); BLL 45-69 + asymptomatic → outpatient succimer (DMSA) 10 mg/kg/dose q8h × 5 d then q12h × 14 d (oral chelator); BLL ≥ 70 หรือ symptomatic encephalopathy → inpatient + dual IV CaNa2EDTA + IM dimercaprol (BAL) (BAL ก่อน EDTA หลีกเลี่ยง redistribution to brain); whole bowel irrigation/cathartic for chip in GI; iron + calcium + zinc supplement (compete absorption); environmental abatement (Department of Public Health, certified abatement); recheck BLL post-chelation + 2-4 wk; family screen siblings + lead source; public health reporting; developmental + neurology follow-up (irreversible cognitive deficit); CDC 2021 reference value 3.5 mcg/dL — any BLL = action"},{"label":"C","text":"Wait until 100 mcg/dL"},{"label":"D","text":"Discharge home no follow-up"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', 'Lead = potent neurotoxin, no safe level. CDC blood lead reference 3.5 mcg/dL (2021). Chelation ≥ 45 + remove source. Encephalopathy = emergency (BAL + EDTA). Source: old paint, water pipes, soil, imported items. Sources of exposure must be eliminated.', NULL,
  'medium', 'neurology', 'review',
  'pediatrics', 'basic_science', 'neurology', 'peds',
  'AAP Lead Exposure Policy 2016; CDC Lead Reference Value 2021', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 3 ปี อยู่บ้านเก่าทาสีก่อน 1978 มี pica eating paint chips มา clinic ด้วย irritability + decreased appetite + abdominal pain intermittent + developmental delay (speech)

BW 13 kg, no organomegaly
CBC: Hb 9.8, MCV 70, basophilic stippling +
Blood lead level (BLL) 52 mcg/dL
AXR: paint chip in colon'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 5 ปี ชักทั้งตัว tonic-clonic ต่อเนื่อง > 5 นาที EMS ส่งมา ED ขณะที่ชักยังคงอยู่ at ED chair seizure ต่อ + ไข้ 39°C ครอบครัวบอก seizure เริ่ม 25 นาทีก่อน

V/S: HR 168, BP 102/68, RR irregular, SpO2 92%, Temp 39°C, BW 20 kg
Glucose bedside 96, no obvious trauma', '[{"label":"A","text":"Observe + wait"},{"label":"B","text":"Pediatric Status Epilepticus (> 5 min established): ABC — position, suction, jaw thrust, O2 + bag-mask ถ้า inadequate ventilation, monitor; rapid glucose check (give D10W 5 mL/kg ถ้า < 60); IV/IO access; FIRST line = Lorazepam 0.1 mg/kg IV (max 4 mg) หรือ Midazolam 0.2 mg/kg IM/IN/buccal (no IV) — may repeat × 1 ที่ 5 นาที; SECOND line ถ้า persists: fosphenytoin 20 mg PE/kg IV (over 7-10 min, monitor BP/arrhythmia) หรือ Levetiracetam 60 mg/kg IV (max 4.5 g, equally effective per ESETT 2019) หรือ valproate 40 mg/kg IV (avoid age < 2, hepatic dysfunction, metabolic concern); THIRD line ถ้า refractory > 30-60 min: midazolam infusion หรือ pentobarbital coma → intubate + EEG monitor in ICU; treat underlying cause (FS workup, infection, electrolytes, toxic, structural); antipyretic for fever; do NOT delay treatment for diagnostics"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Diuretic"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', 'SE = neurologic emergency. > 5 min = treat. Time = brain. Benzo first (lorazepam IV preferred, midaz IM/buccal/IN if no IV). Second-line: fosphenytoin, leva, valproate equivalent (ESETT 2019). Refractory > 30-60 min = anesthetic infusion + ICU. Treat underlying cause.', NULL,
  'hard', 'neurology', 'review',
  'pediatrics', 'ems_mgmt', 'neurology', 'peds',
  'Neurocritical Care Society Status Epilepticus 2012; ESETT NEJM 2019; AES 2016', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 5 ปี ชักทั้งตัว tonic-clonic ต่อเนื่อง > 5 นาที EMS ส่งมา ED ขณะที่ชักยังคงอยู่ at ED chair seizure ต่อ + ไข้ 39°C ครอบครัวบอก seizure เริ่ม 25 นาทีก่อน

V/S: HR 168, BP 102/68, RR irregular, SpO2 92%, Temp 39°C, BW 20 kg
Glucose bedside 96, no obvious trauma'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 12 ปี ปวดหัวข้างเดียว throbbing × 6 ชม + คลื่นไส้ + กลัวแสง กลัวเสียง ทำให้นอน 3-4 ครั้ง/เดือน × 6 เดือน ครอบครัวแม่มี migraine; เรียนยังปกติ

PE neurologic ปกติ; BMI ปกติ
ไม่มี red flags (no head trauma, no fever, no fixed deficit, no AM headache + vomit, normal exam)', '[{"label":"A","text":"Brain MRI mandatory all kids"},{"label":"B","text":"Pediatric Migraine without aura (ICHD-3 criteria): no neuroimaging needed (no red flags + normal exam); acute treatment — ibuprofen 10 mg/kg PO at onset (most effective NSAID) หรือ acetaminophen 15 mg/kg; triptans (sumatriptan nasal/PO, rizatriptan, almotriptan, zolmitriptan) ≥ 12 yr FDA-approved; antiemetic (ondansetron, metoclopramide) ถ้าคลื่นไส้; rest in dark quiet room; treat early ในตอน aura/onset; prevention ถ้า > 4-6 attacks/mo + functional impact — topiramate, amitriptyline (low dose, off-label), propranolol; CGRP antagonist (rimegepant > 12, atogepant > 12) emerging; behavioral: cognitive behavioral therapy + biofeedback proven effective in peds (CHAMP trial); lifestyle — regular sleep, hydration, meals, exercise, limit screens, trigger diary; education; school accommodation"},{"label":"C","text":"Opioid as needed"},{"label":"D","text":"Antibiotic"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', 'Pediatric migraine common. Ibuprofen + triptan acute. CHAMP trial: behavioral therapy + low-dose preventive equivalent. Imaging only with red flags. Lifestyle + trigger management critical. CGRP class emerging in older adolescents.', NULL,
  'medium', 'neurology', 'review',
  'pediatrics', 'clinical_decision', 'neurology', 'peds',
  'AAN Practice Guideline: Acute Pediatric Migraine 2019; CHAMP NEJM 2017', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 12 ปี ปวดหัวข้างเดียว throbbing × 6 ชม + คลื่นไส้ + กลัวแสง กลัวเสียง ทำให้นอน 3-4 ครั้ง/เดือน × 6 เดือน ครอบครัวแม่มี migraine; เรียนยังปกติ

PE neurologic ปกติ; BMI ปกติ
ไม่มี red flags (no head trauma, no fever, no fixed deficit, no AM headache + vomit, normal exam)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 18 เดือน ประวัติ preterm 28 wk BPD HIE มา clinic ด้วย delay motor — ยังไม่นั่งเองได้ ขาเกร็ง spastic both legs scissoring + toe-walking ปกติ cognition ดูใกล้ปกติ

PE: increased tone lower extremities, scissoring, brisk DTRs, Babinski +, persistent ATNR, no head control issue
MRI brain: periventricular leukomalacia', '[{"label":"A","text":"No intervention needed"},{"label":"B","text":"Spastic diplegic Cerebral Palsy (likely from PVL) — early intervention multidisciplinary: PT/OT/speech therapy intensive — focus motor + functional skills (GMFM, Bayley); orthotics (AFO) prevent contracture + improve gait; spasticity management — oral baclofen, dantrolene, diazepam (titrate); focal — botulinum toxin injection (effective for focal spasticity, repeat q3-6 mo); intrathecal baclofen pump (severe generalized); selective dorsal rhizotomy (GMFCS II-III, ambulatory, age 4-8); orthopedic surgery (tendon lengthening, osteotomy) selected; assistive devices (walker, wheelchair); GMFCS staging; co-morbidities — epilepsy 30-50%, intellectual 50%, hearing/vision, GI/feeding, GERD, sleep, hip surveillance + scoliosis; family-centered + IEP school; address pain + drooling + bone health; nutrition + growth; transition planning"},{"label":"C","text":"Spinal surgery infant"},{"label":"D","text":"Discharge no therapy"},{"label":"E","text":"Chemotherapy"}]'::jsonb,
  'B', 'CP = non-progressive motor disorder, perinatal injury (PVL, HIE common). GMFCS staging guides function. Early intervention + multidisciplinary essential. Spasticity tools: oral, botox, ITB, SDR, surgery. Address comorbidities. Family-centered.', NULL,
  'medium', 'neurology', 'review',
  'pediatrics', 'integrative', 'neurology', 'peds',
  'AACPDM Care Pathway 2022; AAP Section on Developmental Pediatrics', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 18 เดือน ประวัติ preterm 28 wk BPD HIE มา clinic ด้วย delay motor — ยังไม่นั่งเองได้ ขาเกร็ง spastic both legs scissoring + toe-walking ปกติ cognition ดูใกล้ปกติ

PE: increased tone lower extremities, scissoring, brisk DTRs, Babinski +, persistent ATNR, no head control issue
MRI brain: periventricular leukomalacia'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 24 เดือน พ่อแม่กังวล — พูด < 5 คำเดี่ยว, ไม่ตอบเรียก, ไม่พ้นมือ, no joint attention, ตื่นเล่นล้อรถซ้ำ ๆ + hand-flapping, sensory issues (covers ears, food selectivity), tantrums เมื่อ routine change

Developmental: motor normal, fine motor ok, social/language severely delayed
Hearing test: normal; M-CHAT-R high risk
No dysmorphism, normal exam', '[{"label":"A","text":"Reassure ''late talker''"},{"label":"B","text":"Suspected ASD — refer for comprehensive evaluation (developmental pediatrician, psychologist with ADOS-2, speech-language) — diagnosis < 24 mo possible reliable; AAP universal ASD screen 18 + 24 mo with M-CHAT-R; while awaiting eval start early intervention (federal Part C, ages 0-3) — applied behavioral analysis (ABA) intensive 20-40 hr/wk, speech, OT, sensory integration; parent training (Pivotal Response Treatment, ESDM); audiology if not done; genetic evaluation (chromosomal microarray + Fragile X DNA + targeted gene panel if features); medical comorbidities — seizure, sleep, GI, ADHD; immunizations standard (no MMR-autism link, debunked); family support + IEP school transition; medication only for specific symptoms (risperidone/aripiprazole for severe irritability/aggression, melatonin sleep) not core ASD; school IEP/IDEA"},{"label":"C","text":"Discharge — wait 1 yr"},{"label":"D","text":"Steroid"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', 'ASD prevalence 1 in 36 (CDC 2023). Early identification + intervention critical for outcomes. AAP screen 18 + 24 mo. M-CHAT-R/F. Comprehensive eval (ADOS-2 + ADI-R). Multidisciplinary intervention. Medication for comorbid symptoms only. Genetic + medical workup. No vaccine link.', NULL,
  'medium', 'psych_behavior', 'review',
  'pediatrics', 'integrative', 'psych_behavior', 'peds',
  'AAP Clinical Report: Identification, Evaluation, and Management of ASD 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 24 เดือน พ่อแม่กังวล — พูด < 5 คำเดี่ยว, ไม่ตอบเรียก, ไม่พ้นมือ, no joint attention, ตื่นเล่นล้อรถซ้ำ ๆ + hand-flapping, sensory issues (covers ears, food selectivity), tantrums เมื่อ routine change

Developmental: motor normal, fine motor ok, social/language severely delayed
Hearing test: normal; M-CHAT-R high risk
No dysmorphism, normal exam'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 8 ปี ป.2 ครู report ไม่มีสมาธิ ลุกในห้องบ่อย คุยไม่หยุด ขัดจังหวะ ทำการบ้านไม่เสร็จ ลืม supplies เป็นมา > 6 เดือน ที่บ้านก็เป็นเช่นเดียวกัน ไม่เคยมี mood disorder, ทำร้ายตัวเอง

Vanderbilt teacher + parent score: both > cutoff inattention + hyperactivity
DDx normal exam, hearing+vision ok, no learning specifically
Family Hx: father has ADHD', '[{"label":"A","text":"Wait until age 12"},{"label":"B","text":"ADHD combined presentation (DSM-5): multimodal treatment — first-line FDA-approved stimulant medications (methylphenidate, amphetamine derivatives) effective 70-80%, start low + titrate up clinical effect + side effect (appetite, sleep, growth, BP); long-acting preparations preferred adherence; alternative — atomoxetine (NRI), guanfacine ER, clonidine ER (non-stimulant, slower onset); behavioral therapy + parent training (mandatory < 6 yr); IEP/504 school accommodations (extended time, preferred seating, breaks, organizational support); monitor growth, BP, HR; sleep hygiene; address comorbid (anxiety, depression, ODD, learning disability); avoid screen + structured routine; reassess q3-6 mo; long-term: persists 50-65% adult; AAP 2019 + AACAP guideline"},{"label":"C","text":"Antibiotic"},{"label":"D","text":"Surgery"},{"label":"E","text":"Punishment-based"}]'::jsonb,
  'B', 'ADHD = neurodevelopmental, persists adulthood half. DSM-5 criteria: ≥ 6 symptoms either inattention or hyperactivity/impulsivity, ≥ 6 mo, ≥ 2 settings, before 12 yr, impairment. Vanderbilt screening tool. Stimulant first-line 6+ yr; behavioral primary < 6. Multimodal. Address comorbidities + school.', NULL,
  'easy', 'psych_behavior', 'review',
  'pediatrics', 'integrative', 'psych_behavior', 'peds',
  'AAP Clinical Practice Guideline: ADHD 2019', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 8 ปี ป.2 ครู report ไม่มีสมาธิ ลุกในห้องบ่อย คุยไม่หยุด ขัดจังหวะ ทำการบ้านไม่เสร็จ ลืม supplies เป็นมา > 6 เดือน ที่บ้านก็เป็นเช่นเดียวกัน ไม่เคยมี mood disorder, ทำร้ายตัวเอง

Vanderbilt teacher + parent score: both > cutoff inattention + hyperactivity
DDx normal exam, hearing+vision ok, no learning specifically
Family Hx: father has ADHD'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 15 ปี มาคลินิกพ่อแม่กังวล — หลีกเลี่ยงคบเพื่อน 6 เดือน, ผลการเรียนตก, sleep > 12h, นน. ลด 5 kg, ร้องไห้บ่อย, กล่าวว่า ''ไม่อยากตื่นอีก'' ฟังเพลง dark พ่อพบว่ามียาเก็บไว้ใน drawer

PHQ-9 score 22 (severe); SI active ideation ไม่มีแผนเฉพาะแต่เก็บยา; previous self-harm episodes 1; no psychotic Sx
No substance use; no family Hx attempt', '[{"label":"A","text":"Outpatient SSRI alone discharge"},{"label":"B","text":"Adolescent Severe Major Depression with active suicidal ideation + means access: immediate safety assessment — ensure ในที่ปลอดภัย ใน clinic จนกว่า safe disposition; เก็บยาทั้งหมด lock + remove firearms/sharps จากบ้าน (lethal means restriction); psychiatric evaluation urgent + likely admission to inpatient psychiatry (active SI + means + persistent symptoms = high risk); safety plan + crisis hotline (988); start SSRI fluoxetine 10-20 mg/d (only FDA-approved peds depression > 8 yr) — monitor closely first 4 wk for activation/SI (black box warning); evidence-based psychotherapy — CBT or IPT-A; family involvement + psychoeducation; school support; treat comorbidities; ภายใน 1 wk follow-up; sertraline alternative; ความคาดหวัง: response 50-60%, remission 30-40%; persistent → SSRI + CBT (TADS); refractory → augmentation, ECT, ketamine (selected); transition to adult care; suicide risk persists — ongoing monitoring"},{"label":"C","text":"Reassure no follow-up"},{"label":"D","text":"Bupropion as first-line"},{"label":"E","text":"Sleeping pills"}]'::jsonb,
  'B', 'Adolescent depression + active SI with means = high acute risk → admission. Lethal means restriction = #1 evidence-based prevention. SSRI fluoxetine peds depression only FDA-approved < 18 (sertraline > 6 only OCD). Combination CBT + SSRI > monotherapy (TADS). Black box warning monitoring.', NULL,
  'hard', 'psych_behavior', 'review',
  'pediatrics', 'integrative', 'psych_behavior', 'peds',
  'AAP Guidelines for Adolescent Depression in Primary Care (GLAD-PC) 2018; TADS NEJM 2007', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 15 ปี มาคลินิกพ่อแม่กังวล — หลีกเลี่ยงคบเพื่อน 6 เดือน, ผลการเรียนตก, sleep > 12h, นน. ลด 5 kg, ร้องไห้บ่อย, กล่าวว่า ''ไม่อยากตื่นอีก'' ฟังเพลง dark พ่อพบว่ามียาเก็บไว้ใน drawer

PHQ-9 score 22 (severe); SI active ideation ไม่มีแผนเฉพาะแต่เก็บยา; previous self-harm episodes 1; no psychotic Sx
No substance use; no family Hx attempt'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 14 ปี BMI 14.5 น้ำหนักลด 12 kg ใน 6 เดือน amenorrhea 4 mo distorted body image (กลัวอ้วน) restricting calorie + excessive exercise no purging

V/S: HR 42, BP 88/56 standing → 78/50 (orthostatic), Temp 35.6°C, BMI 14.5
PE: lanugo, cachectic, dry skin, bradycardia

ECG: prolonged QTc, sinus brady; K 3.0, Phosphate 2.2, ALT/AST elevated; bone density Z-score -2.1', '[{"label":"A","text":"Outpatient calorie diary only"},{"label":"B","text":"Anorexia Nervosa, restricting type, severe with medical instability — admit for medical stabilization (criteria: HR < 50 day or < 45 night, BP < 90/45, orthostatic, < 75% IBW, electrolyte imbalance, refeeding risk): cardiac monitor; SLOW refeeding to avoid refeeding syndrome — start 1,200-1,400 kcal/d (or 30-40 kcal/kg/d) ค่อยเพิ่ม 200 kcal q1-3 d (newer guidelines: more aggressive start ใน less severe cases); check + correct electrolytes (P, K, Mg) daily + thiamine supplement BEFORE feeding; weight gain target 0.5-1 kg/wk inpatient; calorie progression supervised; multidisciplinary team — pediatrician, dietitian, mental health (Family-Based Treatment Maudsley = first-line ที่อายุ < 18, evidence-based for AN); olanzapine adjunct ของบางอย่าง; SSRI helpful comorbid anxiety/depression (after weight restoration); bone density monitoring + treat with weight restoration not BP/HRT; medical follow-up + long-term: mortality 5%, recovery 50-70%"},{"label":"C","text":"Force feed without medical eval"},{"label":"D","text":"Punitive approach"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', 'AN = high mortality eating disorder (highest of all mental illnesses). Hospitalize for medical instability. Refeeding syndrome = fatal — slow refeed + phosphate/electrolyte/thiamine. FBT (Maudsley) = first-line < 18. Multidisciplinary. Bone, growth, fertility long-term.', NULL,
  'medium', 'psych_behavior', 'review',
  'pediatrics', 'integrative', 'psych_behavior', 'peds',
  'AAP Clinical Report: Identification and Management of Eating Disorders in Children 2021', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 14 ปี BMI 14.5 น้ำหนักลด 12 kg ใน 6 เดือน amenorrhea 4 mo distorted body image (กลัวอ้วน) restricting calorie + excessive exercise no purging

V/S: HR 42, BP 88/56 standing → 78/50 (orthostatic), Temp 35.6°C, BMI 14.5
PE: lanugo, cachectic, dry skin, bradycardia

ECG: prolonged QTc, sinus brady; K 3.0, Phosphate 2.2, ALT/AST elevated; bone density Z-score -2.1'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 16 ปี มี nodulocystic acne รุนแรงทั่วใบหน้า + หลัง + อก หลายปี ใช้ benzoyl peroxide + topical retinoid + tetracycline 6 mo แล้วไม่ดีขึ้น มี scarring + ส่งผลต่อ self-esteem มาก', '[{"label":"A","text":"Continue same regimen"},{"label":"B","text":"Severe nodulocystic acne refractory to standard therapy → consider Isotretinoin (oral) — cumulative dose 120-150 mg/kg over 5-6 mo; pregnancy prevention iPLEDGE program mandatory in females (teratogenic — Category X, 2 effective contraception methods + monthly pregnancy test); baseline + monthly LFT + lipid + CBC; counsel side effects (dry skin/lips/eyes, photosensitivity, depression/suicidal ideation monitor, IBD link not proven, night vision, headache from pseudotumor cerebri, hyperostosis); avoid tetracycline concurrent (pseudotumor); avoid waxing/laser × 6 mo; mental health screen + support; results: clear 70-90%, relapse 30%; alternative oral spironolactone (anti-androgen, females), oral hormonal therapy (COC, anti-androgen), light/laser therapy; multidisciplinary — dermatology + adolescent medicine + mental health"},{"label":"C","text":"Wait + outgrow"},{"label":"D","text":"Steroid systemic chronic"},{"label":"E","text":"Antibiotic 5 years"}]'::jsonb,
  'B', 'Severe nodulocystic acne → isotretinoin = most effective. iPLEDGE registry mandatory (teratogenicity). Monitor LFT/lipid/mental health. Acne scarring + psychosocial impact justifies aggressive treatment. Alternative oral anti-androgens (spironolactone, COC) effective females.', NULL,
  'easy', 'signs_symptoms', 'review',
  'pediatrics', 'integrative', 'signs_symptoms', 'peds',
  'AAD Guidelines of Care for Acne 2024; iPLEDGE REMS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 16 ปี มี nodulocystic acne รุนแรงทั่วใบหน้า + หลัง + อก หลายปี ใช้ benzoyl peroxide + topical retinoid + tetracycline 6 mo แล้วไม่ดีขึ้น มี scarring + ส่งผลต่อ self-esteem มาก'
  );

commit;

-- verify after this chunk:
select board_section, count(*) from public.mcq_questions
where board_specialty = 'pediatrics' and exam_source = 'AI-generated-board-seed'
group by 1 order by 1;
