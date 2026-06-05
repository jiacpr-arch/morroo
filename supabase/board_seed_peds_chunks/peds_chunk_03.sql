-- ===============================================================
-- หมอรู้ — Pediatrics seed: chunk 3/10
-- Questions 41-60 of 200
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
  s.id, 'board', NULL, 'เด็กชายอายุ 4 ปี vaccine incomplete (no Hib) มา ED ด้วยไข้สูง 40°C 6 ชม น้ำลายไหล นั่งโน้มตัวไปข้างหน้า (tripod) เสียงแหบ ดูป่วยมาก ไม่ยอมนอน

V/S: HR 162, RR 32, SpO2 91%, Temp 40°C, BW 18 kg
Gen: toxic appearance, drooling, muffled voice, no cough, anxious
Avoid lateral neck X-ray in ED', '[{"label":"A","text":"Lay flat for direct laryngoscopy"},{"label":"B","text":"Suspected Epiglottitis (incomplete Hib vaccine): KEEP CHILD CALM with parent (no IV, no exam, no X-ray ใน ED ที่อาจทำให้ตื่นกลัว); call anesthesia + ENT + ICU ทันที; transfer to OR for controlled intubation by experienced team (have tracheostomy backup); blood culture + epiglottis swab AFTER airway secured; IV Ceftriaxone 100 mg/kg/d × 7-10 วัน (Hib first then Spn, GAS, Staph); ICU monitoring; rifampin chemoprophylaxis household contacts (unvaccinated < 4 yr); extubate 48-72 hr; vaccinate Hib"},{"label":"C","text":"Oral antibiotic + discharge"},{"label":"D","text":"Force IV before airway"},{"label":"E","text":"CT neck first"}]'::jsonb,
  'B', 'Epiglottitis (Hib mainly, now also Spn, GAS, Staph in vaccinated era) = airway emergency. Don''t disturb child (no agitation = no sudden obstruction). Controlled intubation by expert. Differentiate from croup (toxic, drooling, tripod, no cough). Hib vaccine dramatically reduced incidence.', NULL,
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

CXR inspiratory: normal; CXR expiratory: hyperinflation right lung + mediastinal shift left', '[{"label":"A","text":"Observe + albuterol + discharge"},{"label":"B","text":"Foreign body aspiration (likely right main bronchus — peanut): NPO; pediatric ENT/pulm consultation; urgent rigid bronchoscopy ในห้องผ่าตัดภายใต้ GA — diagnostic + therapeutic (extract FB); avoid blind sweep + back blows ใน conscious child > 1 yr (เสี่ยง ดัน FB ลึก); ถ้า complete obstruction + unconscious → BLS algorithm (5 back blows + 5 chest thrusts < 1 yr, abdominal thrusts > 1 yr); O2 + monitor; antibiotic + steroid post-retrieval ถ้า มี mucosal injury; education on choking hazard"},{"label":"C","text":"Wait 2 weeks observation"},{"label":"D","text":"Heimlich blindly"},{"label":"E","text":"Empiric tuberculosis treatment"}]'::jsonb,
  'B', 'FBA = leading cause unintentional death < 4 yr. Peanut, nuts, grapes, hot dog common. Sudden choking + asymmetric findings = classic. Expiratory CXR (or lateral decubitus) reveals air trapping (ball-valve). Rigid bronchoscopy = diagnostic + therapeutic. Don''t delay.', NULL,
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

ABG: pH 7.18, PaO2 110, PaCO2 32, HCO3 14', '[{"label":"A","text":"Defibrillation immediately"},{"label":"B","text":"Symptomatic bradycardia post-arrest (PALS 2020): ensure adequate oxygenation + ventilation FIRST (most peds bradycardia hypoxia-driven); if HR < 60 + poor perfusion despite ventilation → start chest compressions; Epinephrine 0.01 mg/kg (0.1 mL/kg of 1:10,000) IV/IO q3-5 min; Atropine 0.02 mg/kg (min 0.1 mg, max 0.5 mg) IF vagal-mediated or AV block; identify + treat reversible causes (Hs and Ts — hypoxia in drowning); pacing only if drug-refractory + likely complete AV block; post-arrest care: targeted temperature, glucose control, family centered"},{"label":"C","text":"Adenosine"},{"label":"D","text":"Cardioversion"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', 'PALS 2020: peds bradycardia mostly hypoxic — fix airway/breathing first. CPR if HR < 60 with poor perfusion despite ventilation. Epi first-line drug. Atropine for vagal/AV block. Post-arrest neuroprotection + targeted temperature management.', NULL,
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
Gen: anxious, generalized urticaria + angioedema, biphasic wheeze, weak pulses', '[{"label":"A","text":"Antihistamine oral + observe"},{"label":"B","text":"Anaphylaxis: IM Epinephrine 1:1000 = 0.01 mg/kg (max 0.3 mg = 0.3 mL) ต้น lateral thigh ทันที — first-line lifesaving; repeat q5-15 min ถ้าไม่ดีขึ้น; supine + legs up; high-flow O2 + airway support + albuterol ถ้า wheeze; IV fluid bolus 20 mL/kg crystalloid ถ้า hypotension; secondary: H1 antihistamine (diphenhydramine), H2 antihistamine, corticosteroid (ไม่ใช่ first-line, ไม่กัน biphasic); observe 4-6 ชม (biphasic 5%); discharge with EpiPen × 2 + allergist referral + action plan + avoidance"},{"label":"C","text":"Steroid IV alone"},{"label":"D","text":"Diphenhydramine alone"},{"label":"E","text":"Watch + wait"}]'::jsonb,
  'B', 'Anaphylaxis = clinical diagnosis. Epinephrine IM = first-line, no contraindication. Delay = mortality. Observation post-treatment 4-6 hr for biphasic reaction (5-20%). Always provide EpiPen × 2 + action plan + allergist referral. Common triggers: foods, insects, drugs, latex.', NULL,
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

Lactate 6.8, glucose 52, WBC 2,800, Plt 78,000, CRP 220, INR 1.8, fibrinogen 95', '[{"label":"A","text":"Antibiotic oral outpatient"},{"label":"B","text":"Pediatric septic shock (likely meningococcemia): IV/IO access × 2 ภายใน 5 นาที; aggressive fluid resuscitation 10-20 mL/kg NSS/LR bolus × repeat up to 60 mL/kg ใน first hour (reassess after each bolus — risk fluid overload, hepatomegaly, rales); empiric Ceftriaxone 100 mg/kg/dose IV ภายใน 1 ชม (after culture if no delay); start epinephrine peripheral 0.05-0.3 mcg/kg/min ถ้า fluid-refractory (cold shock); norepi for warm shock; correct hypoglycemia, hypocalcemia, acidosis; intubate ถ้า impending failure; ICU + central + arterial line; stress dose hydrocortisone ถ้า catecholamine-resistant; transfer pediatric ICU"},{"label":"C","text":"Wait for culture results"},{"label":"D","text":"Diuretic first"},{"label":"E","text":"Discharge with oral antibiotic"}]'::jsonb,
  'B', 'Surviving Sepsis Campaign Pediatric 2020: hour-1 bundle. Recognize early. Fluid resuscitation with reassessment for overload. Empiric antibiotic within 1 hr. Vasoactive support — epi for cold shock (low CO), norepi for warm (low SVR). Goals: normalize MAP, perfusion, lactate. Pediatric ICU.', NULL,
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
Cultures: pending; CBC: WBC 16,500', '[{"label":"A","text":"Outpatient observation"},{"label":"B","text":"Febrile UTI ใน infant: ส่ง urine culture จาก catheterization (suprapubic also acceptable) ก่อนเริ่ม antibiotic; empiric IV Ceftriaxone 50-75 mg/kg/d (admit ถ้า < 2 mo, toxic, vomiting, dehydration); switch oral once afebrile + clinical improvement (total 7-14 วัน); renal/bladder ultrasound ทุกราย first febrile UTI; VCUG ถ้า abnormal US + recurrence + atypical course; ตรวจหา renal scarring (DMSA) selected; counsel hygiene + voiding habits; continuous prophylaxis only selected high-grade VUR/recurrence"},{"label":"C","text":"Bag urine + oral antibiotic"},{"label":"D","text":"Discharge no antibiotic"},{"label":"E","text":"Antifungal first"}]'::jsonb,
  'B', 'AAP 2011/2016 UTI guideline: febrile infant 2-24 mo. Catheter or SPA sample (bag = high false +). E. coli most common. Imaging: US for all, VCUG selective. Long-term scarring risk → prompt treatment + follow-up. Circumcision reduces UTI in male infants.', NULL,
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
BUN 42, Cr 1.2, Albumin 3.6, C3 LOW, C4 normal, ASO HIGH', '[{"label":"A","text":"High-dose immunosuppression immediately"},{"label":"B","text":"Post-streptococcal Glomerulonephritis (PSGN): supportive care mainstay (self-limited 4-6 wk); salt + water restriction; loop diuretic (furosemide) สำหรับ edema + HT; antihypertensive (CCB, ACEI ระวัง AKI) ถ้า HT severe; treat residual strep infection (penicillin หรือ amoxicillin × 10 d); monitor BP + UA + renal function; admit ถ้า severe HT, encephalopathy, oliguria, electrolyte imbalance; recheck C3 ที่ 8 wk (ควรกลับมาปกติ — ถ้าไม่กลับ → คิด C3 glomerulopathy/MPGN); long-term BP + proteinuria follow-up"},{"label":"C","text":"Steroid pulse therapy routinely"},{"label":"D","text":"Plasmapheresis"},{"label":"E","text":"Discharge with no follow-up"}]'::jsonb,
  'B', 'PSGN = classic acute nephritic syndrome เด็ก. ASO + low C3 (transient < 8 wk) + recent strep + hematuria + HT + edema. Most self-limit. Treatment supportive. Persistent low C3 > 8 wk → reconsider Dx (MPGN, C3GN, lupus).', NULL,
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
Albumin 1.8, Cholesterol 380, normal Cr, complement normal', '[{"label":"A","text":"Diuretic alone"},{"label":"B","text":"Idiopathic Nephrotic Syndrome (likely Minimal Change Disease): prednisolone 60 mg/m²/d (max 60 mg) PO × 4-6 wk → 40 mg/m² alternate day × 4-6 wk → taper (total 12 wk standard course); salt restriction + cautious diuretic ถ้า severe edema; albumin 25% + furosemide ถ้า severe edema + low IV volume; penicillin prophylaxis (pneumococcal peritonitis risk); pneumococcal + influenza vaccine; thromboprophylaxis selected (severe albumin < 2); biopsy ถ้า atypical (age < 1 or > 12, hematuria, HT, AKI, low C3, steroid-resistant, frequent relapse + steroid toxic); monitor BP + growth + bone density"},{"label":"C","text":"Cyclophosphamide first-line"},{"label":"D","text":"ACEI alone"},{"label":"E","text":"Discharge no medication"}]'::jsonb,
  'B', 'Pediatric NS = MCD ในเด็กส่วนใหญ่ (> 90%, ages 2-10). Triad: proteinuria, hypoalbuminemia, edema (+ hyperlipidemia). Steroid response = MCD typical. Complications: infection (encapsulated organisms), VTE, AKI. Steroid-resistant → biopsy + alternative immunosuppression.', NULL,
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
LDH 1,840, Uric acid 8.6', '[{"label":"A","text":"Antibiotic alone"},{"label":"B","text":"Acute Lymphoblastic Leukemia (likely B-ALL, most common peds cancer): admit oncology; flow cytometry + cytogenetics + molecular (BCR-ABL, MLL, hyperdiploidy); LP + bone marrow biopsy ใน first week; risk stratification (NCI age 1-10 + WBC < 50K = standard risk); induction chemo (vincristine + dexa/pred + asparaginase + ± anthracycline); tumor lysis prophylaxis — hydration 2× maintenance + allopurinol or rasburicase + monitor K, P, Ca, urate, Cr; transfusion: PRBC for Hb < 7 หรือ symptomatic, platelet for < 10K หรือ bleeding; central line; G-CSF selected; long-term: 2-3 yr therapy + late effects monitoring"},{"label":"C","text":"Steroid alone"},{"label":"D","text":"Watch + wait"},{"label":"E","text":"Splenectomy first"}]'::jsonb,
  'B', 'ALL = most common pediatric cancer (peak 2-5 yr). 5-yr survival > 90% with modern protocols. Tumor lysis = major early complication. CNS prophylaxis intrathecal. Down syndrome + ALL = unique biology. Long-term: cardio, neuro, second malignancy.', NULL,
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
Peripheral smear: large platelets, no blasts, no schistocytes', '[{"label":"A","text":"Splenectomy"},{"label":"B","text":"Acute Immune Thrombocytopenia (ITP, post-viral, typical): ในเด็กที่ no/mild bleeding (skin only) → observation alone ตามแนวทาง ASH 2019 (most spontaneous resolution 4-8 wk); หลีกเลี่ยง contact sports + NSAID/aspirin; education สัญญาณเลือดออกหนัก; first-line ถ้ามี bleeding significant: IVIG 0.8-1 g/kg single dose หรือ anti-D (Rh+ non-splenectomized) หรือ corticosteroid (prednisolone 2-4 mg/kg/d × 5-7 d then taper); platelet transfusion เฉพาะ life-threatening bleed; ถ้า chronic > 12 mo → rituximab, TPO agonists; rule out other causes (smear + family Hx)"},{"label":"C","text":"Bone marrow biopsy mandatory all"},{"label":"D","text":"Chemotherapy"},{"label":"E","text":"Antibiotic prophylaxis"}]'::jsonb,
  'B', 'ITP = isolated thrombocytopenia, typical post-viral. Most peds = acute, self-limit. ASH 2019: observation for skin-only bleeding regardless of platelet count. Treat if significant mucosal bleed. Bone marrow not required if typical features (no atypical labs/exam).', NULL,
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

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 6 ปี known HbSS มาด้วยปวดขา + หลัง 2 ข้าง รุนแรง 8 ชม pain score 9/10 ไข้ 38.2°C

V/S: HR 122, BP 108/72, RR 24, SpO2 96%, BW 22 kg
PE: tender extremities, no swelling, no chest signs

CBC: Hb 7.8 (baseline 8.5), retic 12%, WBC 15,200, Plt 384,000
CXR clear, BCx pending', '[{"label":"A","text":"NSAID only at home"},{"label":"B","text":"Sickle cell vaso-occlusive crisis (VOC): IV access + IV fluid 1-1.5× maintenance (avoid over-hydration → ATS/pulmonary edema); rapid pain assessment + analgesia ภายใน 30 นาที — IV morphine 0.1-0.15 mg/kg q3-4h หรือ PCA + ketorolac (avoid if dehydration/renal); warmth + reassurance + diversion; O2 ถ้า SpO2 < 95%; blood culture + empiric ceftriaxone ถ้าไข้ > 38.5°C (functional asplenia → encapsulated organism); monitor for acute chest syndrome (new infiltrate + symptom); incentive spirometry; transfusion ถ้า severe anemia หรือ ACS; hydroxyurea long-term ถ้ายังไม่ได้; vaccinations + penicillin prophylaxis"},{"label":"C","text":"Discharge home no analgesia"},{"label":"D","text":"Steroid IV high dose"},{"label":"E","text":"Iron supplement"}]'::jsonb,
  'B', 'VOC = most common acute presentation SCD. Prompt analgesia + hydration. Watch for ACS (life-threatening). Functional asplenia → high infection risk → fever requires evaluation. Long-term: hydroxyurea, transcranial Doppler (stroke screen), HSCT/gene therapy considerations.', NULL,
  'medium', 'hematology', 'review',
  'pediatrics', 'clinical_decision', 'hematology', 'peds',
  'NHLBI Sickle Cell Disease Guidelines 2014; ASH 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 6 ปี known HbSS มาด้วยปวดขา + หลัง 2 ข้าง รุนแรง 8 ชม pain score 9/10 ไข้ 38.2°C

V/S: HR 122, BP 108/72, RR 24, SpO2 96%, BW 22 kg
PE: tender extremities, no swelling, no chest signs

CBC: Hb 7.8 (baseline 8.5), retic 12%, WBC 15,200, Plt 384,000
CXR clear, BCx pending'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 14 เดือน ดูดนมวัวเต็มกระป๋อง 1.2 L/วัน ตั้งแต่ 9 เดือน ไม่ค่อยกินอาหารแข็ง ซีด เหนื่อยง่าย

V/S ปกติ, BW 10 kg
PE: pale, koilonychia, no organomegaly, no jaundice

CBC: Hb 7.2, MCV 58, MCH 18, MCHC 27, RDW 19, retic LOW
Ferritin 4, TSAT 4%, TIBC HIGH, serum iron LOW', '[{"label":"A","text":"Folate supplementation"},{"label":"B","text":"Iron deficiency anemia (excess cow milk + dietary insufficient): oral elemental iron 3-6 mg/kg/d (sulfate, fumarate, or gluconate) ÷ 1-3 doses ระหว่างมื้อ + vitamin C (ส้ม) เพื่อช่วยดูดซึม; limit cow milk < 500 mL/d; ส่งเสริม iron-rich food (red meat, beans, fortified cereal); recheck retic 1 wk (เพิ่ม), Hb 4 wk (ขึ้น 1-2 g/dL); ต่อ 3 เดือนหลัง Hb ปกติเติม store; investigate ถ้าไม่ตอบสนอง (compliance, ongoing loss, malabsorption); IV iron sucrose ถ้า oral intolerance/malabsorption; screen Hb at 12 mo (AAP); rule out lead exposure"},{"label":"C","text":"Blood transfusion routine"},{"label":"D","text":"B12 injection"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', 'IDA = most common pediatric anemia. Cow milk > 500-700 mL/d = major risk factor (low iron, GI bleeding, displaces iron-rich foods). AAP universal screen at 12 mo. Microcytic + low ferritin + high RDW. Replenish stores 3 mo post-normalization. Address dietary cause.', NULL,
  'easy', 'hematology', 'review',
  'pediatrics', 'basic_science', 'hematology', 'peds',
  'AAP Clinical Report: Iron Deficiency 2010', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 14 เดือน ดูดนมวัวเต็มกระป๋อง 1.2 L/วัน ตั้งแต่ 9 เดือน ไม่ค่อยกินอาหารแข็ง ซีด เหนื่อยง่าย

V/S ปกติ, BW 10 kg
PE: pale, koilonychia, no organomegaly, no jaundice

CBC: Hb 7.2, MCV 58, MCH 18, MCHC 27, RDW 19, retic LOW
Ferritin 4, TSAT 4%, TIBC HIGH, serum iron LOW'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 18 เดือน breastfed exclusively โดยไม่ได้ supplement vitamin D อยู่ใน apartment ไม่ได้ออกแสงแดด มา clinic ด้วย delay walking + bowing legs + frontal bossing

V/S ปกติ, BW 9.5 kg
PE: rachitic rosary, widened wrists, genu varum, frontal bossing

Lab: Ca 8.0, P 2.4 (low), ALP 980 (high), 25(OH)D 8 (low), PTH 142 (high)
XR wrist: cupping + fraying + widened growth plate', '[{"label":"A","text":"Calcium alone"},{"label":"B","text":"Nutritional Rickets (Vitamin D deficiency): Vitamin D3 (cholecalciferol) — Stoss therapy 600,000 IU PO single dose หรือ daily 2,000-6,000 IU × 8-12 wk depending on age + severity; calcium supplement 500-1000 mg/d elemental เมื่อ intake ต่ำ; expose sunlight (15-30 นาที/วัน arms+face); breastfed infant ต้อง vitamin D 400 IU/d ตั้งแต่ first weeks (AAP); recheck Ca, P, ALP, 25(OH)D, PTH ที่ 1 + 3 เดือน; maintenance 400-1,000 IU/d after; XR healing ใน 4-6 wk; investigate other causes (hypophosphatemic, VDDR) ถ้าไม่ตอบสนอง"},{"label":"C","text":"High-dose calcitriol routinely"},{"label":"D","text":"Steroid"},{"label":"E","text":"Surgery for bowing first"}]'::jsonb,
  'B', 'Nutritional rickets = preventable. AAP recommends vitamin D 400 IU/d all breastfed infants from first weeks. Risk factors: exclusively breastfed without supplement, dark skin, limited sun, maternal deficiency. ALP elevated. Healing on X-ray 4-6 wk after treatment.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'pediatrics', 'basic_science', 'endocrine_metabolic', 'peds',
  'Global Consensus Recommendations on Prevention and Management of Nutritional Rickets 2016', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 18 เดือน breastfed exclusively โดยไม่ได้ supplement vitamin D อยู่ใน apartment ไม่ได้ออกแสงแดด มา clinic ด้วย delay walking + bowing legs + frontal bossing

V/S ปกติ, BW 9.5 kg
PE: rachitic rosary, widened wrists, genu varum, frontal bossing

Lab: Ca 8.0, P 2.4 (low), ALP 980 (high), 25(OH)D 8 (low), PTH 142 (high)
XR wrist: cupping + fraying + widened growth plate'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 10 เดือน BW 6.2 kg (< 3rd percentile) length 65 cm (< 3rd) HC 41 cm (5th) — น้ำหนักลด across 2 percentile lines since 4 mo (was 50th)

Feed: breast milk + porridge mostly water, mother depressed, family low income
PE: thin, decreased subcutaneous fat, alert, no dysmorphism, no organomegaly

No medical illness history; CBC normal, CMP normal, TSH normal, sweat chloride pending', '[{"label":"A","text":"Force feed via NG immediately"},{"label":"B","text":"Failure to Thrive (likely psychosocial + caloric insufficiency): multidisciplinary approach (pediatrician + nutritionist + social worker + lactation/feeding specialist + mental health for mom); detailed dietary + feeding history + 3-day food diary; quantify caloric intake vs need (cal-up to 150 kcal/kg/d catch-up); fortify breast milk + add complementary food calorie-dense (avocado, oil, butter); maternal depression screen + treatment + WIC/government nutrition support; safe environment + nurturing; close growth follow-up q1-2 wk; investigate organic causes selected (celiac, CF, anemia, endocrine, renal); rule out abuse/neglect; hospitalize ถ้า severe (< 80% ideal weight, dehydration, social concern)"},{"label":"C","text":"Discharge without follow-up"},{"label":"D","text":"Steroid"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', 'FTT = inadequate growth velocity. Causes: inadequate intake (most), inadequate absorption, increased need, defective utilization. Most psychosocial + dietary. Multidisciplinary key. Catch-up needs 150 kcal/kg/d. Rule out organic. Address psychosocial.', NULL,
  'medium', 'signs_symptoms', 'review',
  'pediatrics', 'clinical_decision', 'signs_symptoms', 'peds',
  'AAP Section on Developmental and Behavioral Pediatrics; Bright Futures 4th ed', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 10 เดือน BW 6.2 kg (< 3rd percentile) length 65 cm (< 3rd) HC 41 cm (5th) — น้ำหนักลด across 2 percentile lines since 4 mo (was 50th)

Feed: breast milk + porridge mostly water, mother depressed, family low income
PE: thin, decreased subcutaneous fat, alert, no dysmorphism, no organomegaly

No medical illness history; CBC normal, CMP normal, TSH normal, sweat chloride pending'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 2 เดือน term, healthy, exclusively breastfed มา well-child visit ครั้งแรกหลังคลอด (Birth visit ได้ Hep B แล้ว) เพื่อ vaccination', '[{"label":"A","text":"Wait until 6 months for first vaccines"},{"label":"B","text":"2-month routine vaccines (Thai EPI + recommended): DTwP/DTaP, IPV, HepB (2nd dose), Hib, PCV13 (PCV10 also acceptable), Rotavirus (RV1 PO หรือ RV5 first dose, ต้องเริ่มก่อน 15 wk, ครบก่อน 8 mo); สามารถให้ multiple sites ใน same visit; observe 15 นาทีหลังฉีด; ผลข้างเคียงปกติ (low-grade fever, redness/swelling, fussy) ใช้ paracetamol PRN; contraindications absolute น้อย (anaphylaxis ต่อ vaccine; severe immune compromise สำหรับ live vaccines); BCG ให้แรกเกิด (Thai EPI); ครั้งถัดไป 4 mo + 6 mo"},{"label":"C","text":"Only Hepatitis B"},{"label":"D","text":"Defer if mild URI"},{"label":"E","text":"MMR + varicella"}]'::jsonb,
  'B', 'Thai EPI 2 mo: DTP-HB-Hib (5-in-1) + OPV/IPV + PCV + Rotavirus. AAP/CDC similar. Multiple simultaneous safe. Mild illness not contraindication. Live vaccines (MMR, varicella) start 9-12 mo. Catch-up schedule for delays.', NULL,
  'easy', 'id', 'review',
  'pediatrics', 'basic_science', 'id', 'peds',
  'Thailand EPI Schedule 2023; AAP Red Book 2024; CDC ACIP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 2 เดือน term, healthy, exclusively breastfed มา well-child visit ครั้งแรกหลังคลอด (Birth visit ได้ Hep B แล้ว) เพื่อ vaccination'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารก term GA 39 wk BW 3,500 g คลอด emergency C/S for prolonged labor + cord prolapse Apgar 1/3/5 ที่ 1/5/10 นาที ตอนนี้อายุ 30 นาที seizures + hypotonia + poor feeding

V/S: HR 138, RR via vent, SpO2 96%, Temp 36.8°C
Gen: ventilated, depressed level of consciousness, abnormal tone (hypotonia), abnormal reflexes, frequent seizures

Umbilical artery pH 6.95, BE -16, lactate 12
Sarnat stage II', '[{"label":"A","text":"Discharge home"},{"label":"B","text":"Hypoxic-Ischemic Encephalopathy (moderate, Sarnat II): therapeutic hypothermia (selective head หรือ whole-body) start ภายใน 6 ชม of birth, target temp 33.5°C × 72 ชม → rewarm slowly 0.5°C/hr; eligibility: ≥ 36 wk GA, < 6 hr of life, evidence of perinatal acidosis (cord pH ≤ 7 or BE ≤ -16) + Apgar ≤ 5 ที่ 10 นาที หรือ ongoing resuscitation, moderate-severe encephalopathy; supportive care (ventilation, BP, glucose, electrolytes); EEG/aEEG monitor; treat seizures (phenobarbital 20 mg/kg load); avoid hyperthermia + hyperoxia + hypocapnia; MRI day 4-5; long-term developmental + neurology follow-up; counsel family about prognosis"},{"label":"C","text":"Warming actively"},{"label":"D","text":"Steroid only"},{"label":"E","text":"Avoid all medication"}]'::jsonb,
  'B', 'HIE = leading cause neonatal neuro-disability term infants. Therapeutic hypothermia within 6 hr = standard of care, reduces death + disability NNT ~7. Sarnat staging guides treatment. EEG/MRI for prognosis. Multidisciplinary follow-up.', NULL,
  'hard', 'neurology', 'review',
  'pediatrics', 'clinical_decision', 'neurology', 'peds',
  'NICHD Hypothermia Trial; AAP COFN; ILCOR 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารก term GA 39 wk BW 3,500 g คลอด emergency C/S for prolonged labor + cord prolapse Apgar 1/3/5 ที่ 1/5/10 นาที ตอนนี้อายุ 30 นาที seizures + hypotonia + poor feeding

V/S: HR 138, RR via vent, SpO2 96%, Temp 36.8°C
Gen: ventilated, depressed level of consciousness, abnormal tone (hypotonia), abnormal reflexes, frequent seizures

Umbilical artery pH 6.95, BE -16, lactate 12
Sarnat stage II'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Newborn screening positive for elevated TSH at DOL 5 (heel-stick filter paper TSH 80, normal < 20) ทารก term BW 3,400 g ดูปกติ คลำคอไม่พบ goiter

Confirmatory venous: TSH 95, Free T4 0.4 (low)
No dysmorphic features; mother no thyroid disease
US thyroid: athyreosis (no thyroid tissue)', '[{"label":"A","text":"Wait until 6 months to treat"},{"label":"B","text":"Congenital Hypothyroidism (athyreosis): start L-thyroxine 10-15 mcg/kg/d PO ทันที (crushed tablet ใน small breastmilk หรือ water — NOT soy formula, iron, calcium ที่ลด absorption); recheck TSH + free T4 ที่ 2 wk + 4 wk + q1-2 mo first year ปรับ dose; target TSH normal range + free T4 upper half of normal; goal: prevent permanent neurological damage (start ภายใน 2 wk of life critical); imaging (US, scintigraphy) for etiology — athyreosis = permanent; counsel family about lifelong treatment + monitoring; developmental follow-up + audiology + ophthalmology baseline"},{"label":"C","text":"Soy formula only"},{"label":"D","text":"PTU"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', 'CH = most common preventable cause intellectual disability. Newborn screening universal. Start L-thyroxine ASAP (< 2 wk) at high dose 10-15 mcg/kg/d. Avoid soy formula, iron, calcium with dose. Monitor q1-2 mo first year. Athyreosis = permanent; ectopia or dyshormonogenesis variable.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'pediatrics', 'basic_science', 'endocrine_metabolic', 'peds',
  'ESPE/ENDO Consensus on Congenital Hypothyroidism 2021', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'Newborn screening positive for elevated TSH at DOL 5 (heel-stick filter paper TSH 80, normal < 20) ทารก term BW 3,400 g ดูปกติ คลำคอไม่พบ goiter

Confirmatory venous: TSH 95, Free T4 0.4 (low)
No dysmorphic features; mother no thyroid disease
US thyroid: athyreosis (no thyroid tissue)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Newborn screening DOL 5 positive elevated phenylalanine 28 mg/dL (normal < 2) confirmed serum Phe 32 mg/dL with Tyr low normal

ทารก term well-appearing, mother health normal, no family Hx
Confirmatory: BH4 cofactor testing negative (classic PKU not BH4-deficient)', '[{"label":"A","text":"Standard formula"},{"label":"B","text":"Classic Phenylketonuria: start Phe-restricted special medical formula (Lofenalac, Phenex) ทันที + provide essential amino acids except Phe; lifelong dietary management; goal Phe 2-6 mg/dL ตลอดชีวิต; metabolic geneticist + dietitian team; monitor Phe levels weekly first year + q monthly; allow limited natural protein for Tyr; supplement tyrosine, BH4 cofactor responsive trial (sapropterin); avoid aspartame; pregnancy planning critical (maternal PKU syndrome — fetal effects); growth + developmental monitoring; ใหม่: Phenylalanine ammonia lyase (pegvaliase) adults"},{"label":"C","text":"High-protein diet"},{"label":"D","text":"BCAA supplementation"},{"label":"E","text":"Discharge no treatment"}]'::jsonb,
  'B', 'PKU = autosomal recessive PAH deficiency. Untreated → severe intellectual disability, seizures, eczema, musty odor. Newborn screening + lifelong Phe-restricted diet prevents disability. Maternal PKU = teratogenic without strict control pre-conception. Sapropterin for responsive; pegvaliase enzyme replacement adults.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'pediatrics', 'basic_science', 'endocrine_metabolic', 'peds',
  'ACMG PKU Guideline 2014; Vockley J et al. Genet Med 2014', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'Newborn screening DOL 5 positive elevated phenylalanine 28 mg/dL (normal < 2) confirmed serum Phe 32 mg/dL with Tyr low normal

ทารก term well-appearing, mother health normal, no family Hx
Confirmatory: BH4 cofactor testing negative (classic PKU not BH4-deficient)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Newborn term GA 38 wk BW 2,800 g มี features: upslanting palpebral fissures, epicanthal folds, flat nasal bridge, single transverse palmar crease, hypotonia, mild macroglossia, sandal gap toes

Low-set ears, brachycephaly; mother age 38 (no prenatal screening)
PE: heart murmur (II/VI systolic LSB)', '[{"label":"A","text":"Reassure no further evaluation"},{"label":"B","text":"Trisomy 21 (Down syndrome) — coordinated multispecialty care per AAP 2022 health supervision: confirm karyotype + counsel family; echocardiogram ใน first month (40-50% CHD — AVSD common); CBC at birth (transient abnormal myelopoiesis, polycythemia) + repeat first year; TSH at birth + 6 mo + annually (CH risk); ophthalmology + audiology birth + ongoing; cervical spine atlantoaxial instability evaluation before sports; growth chart Down-specific; feeding/swallow eval; developmental + early intervention; screen leukemia, celiac, sleep apnea (PSG at 4 yr), Alzheimer adult; immunizations standard; family education + support resources; long-term primary care coordination"},{"label":"C","text":"Surgery only addresses the issue"},{"label":"D","text":"No intervention needed"},{"label":"E","text":"Aggressive chemotherapy"}]'::jsonb,
  'B', 'DS = most common chromosomal disorder. Multisystem: CHD 50%, GI atresias, leukemia, hypothyroidism, sleep apnea, atlantoaxial instability, AD risk adult. AAP 2022 health supervision guideline. Coordinated team. Family-centered.', NULL,
  'easy', 'signs_symptoms', 'review',
  'pediatrics', 'integrative', 'signs_symptoms', 'peds',
  'AAP Health Supervision for Children and Adolescents With Down Syndrome 2022', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'Newborn term GA 38 wk BW 2,800 g มี features: upslanting palpebral fissures, epicanthal folds, flat nasal bridge, single transverse palmar crease, hypotonia, mild macroglossia, sandal gap toes

Low-set ears, brachycephaly; mother age 38 (no prenatal screening)
PE: heart murmur (II/VI systolic LSB)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 7 ปี short stature (height 110 cm, < 3rd percentile, dropping percentile since age 2) + low posterior hairline + webbed neck + widely spaced nipples + cubitus valgus

Family mid-parental height 160 cm; bone age delayed 1 yr; karyotype 45,XO; renal US: horseshoe kidney; echo: bicuspid aortic valve', '[{"label":"A","text":"Wait until puberty starts spontaneously"},{"label":"B","text":"Turner Syndrome (45,XO) management: rhGH 0.35 mg/kg/wk SC start when growth falls below normal (ideally 4-6 yr) to maximize adult height; estrogen replacement start 11-12 yr low-dose transdermal then increase over 2-3 yr to mimic puberty + induce secondary sex characteristics + bone mineralization; later add progesterone for menstrual cycle; cardiac MRI baseline + echo q3-5 yr (BAV, coarctation, dissection risk); renal US baseline; thyroid + glucose + lipids annually; hearing + ophtho baseline + recurrent; bone density before estrogen + adulthood; ear infections + otitis; psychosocial support; fertility counseling (most infertile, oocyte donation); transition to adult endo; AHA cardiac care plan"},{"label":"C","text":"Testosterone replacement"},{"label":"D","text":"Discharge no follow-up"},{"label":"E","text":"Chemotherapy"}]'::jsonb,
  'B', 'Turner = monosomy X. Short stature + gonadal dysgenesis. Multisystem: cardiac (BAV, coarctation, dissection), renal, hearing, autoimmune. Multidisciplinary lifelong care. GH + estrogen + cardiac surveillance + psychosocial.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'pediatrics', 'integrative', 'endocrine_metabolic', 'peds',
  'Clinical Practice Guidelines for Care of Girls and Women with Turner Syndrome (Gravholt CH 2017)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 7 ปี short stature (height 110 cm, < 3rd percentile, dropping percentile since age 2) + low posterior hairline + webbed neck + widely spaced nipples + cubitus valgus

Family mid-parental height 160 cm; bone age delayed 1 yr; karyotype 45,XO; renal US: horseshoe kidney; echo: bicuspid aortic valve'
  );

commit;

-- verify after this chunk:
select board_section, count(*) from public.mcq_questions
where board_specialty = 'pediatrics' and exam_source = 'AI-generated-board-seed'
group by 1 order by 1;
