-- ===============================================================
-- หมอรู้ — Board seed: กุมารเวชศาสตร์ (pediatrics) — part 2/4 (50 MCQs)
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
  s.id, 'board', NULL, 'เด็กชายอายุ 6 ปี known HbSS มาด้วยปวดขา + หลัง 2 ข้าง รุนแรง 8 ชม pain score 9/10 ไข้ 38.2°C

V/S: HR 122, BP 108/72, RR 24, SpO2 96%, BW 22 kg
PE: tender extremities, no swelling, no chest signs

CBC: Hb 7.8 (baseline 8.5), retic 12%, WBC 15,200, Plt 384,000
CXR clear, BCx pending', '[{"label":"A","text":"NSAID only at home"},{"label":"B","text":"Sickle cell vaso-occlusive crisis (VOC)"},{"label":"C","text":"Discharge home no analgesia"},{"label":"D","text":"Steroid IV high dose"},{"label":"E","text":"Iron supplement"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Sickle cell vaso-occlusive crisis (VOC): IV access + IV fluid 1-1.5× maintenance (avoid over-hydration → ATS/pulmonary edema); rapid pain assessment + analgesia ภายใน 30 นาที — IV morphine 0.1-0.15 mg/kg q3-4h หรือ PCA + ketorolac (avoid if dehydration/renal); warmth + reassurance + diversion; O2 ถ้า SpO2 < 95%; blood culture + empiric ceftriaxone ถ้าไข้ > 38.5°C (functional asplenia → encapsulated organism); monitor for acute chest syndrome (new infiltrate + symptom); incentive spirometry; transfusion ถ้า severe anemia หรือ ACS; hydroxyurea long-term ถ้ายังไม่ได้; vaccinations + penicillin prophylaxis

---

VOC = most common acute presentation SCD. Prompt analgesia + hydration. Watch for ACS (life-threatening). Functional asplenia → high infection risk → fever requires evaluation. Long-term: hydroxyurea, transcranial Doppler (stroke screen), HSCT/gene therapy considerations.', NULL,
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
Ferritin 4, TSAT 4%, TIBC HIGH, serum iron LOW', '[{"label":"A","text":"Folate supplementation"},{"label":"B","text":"Iron deficiency anemia (excess cow milk + dietary insufficient)"},{"label":"C","text":"Blood transfusion routine"},{"label":"D","text":"B12 injection"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Iron deficiency anemia (excess cow milk + dietary insufficient): oral elemental iron 3-6 mg/kg/d (sulfate, fumarate, or gluconate) ÷ 1-3 doses ระหว่างมื้อ + vitamin C (ส้ม) เพื่อช่วยดูดซึม; limit cow milk < 500 mL/d; ส่งเสริม iron-rich food (red meat, beans, fortified cereal); recheck retic 1 wk (เพิ่ม), Hb 4 wk (ขึ้น 1-2 g/dL); ต่อ 3 เดือนหลัง Hb ปกติเติม store; investigate ถ้าไม่ตอบสนอง (compliance, ongoing loss, malabsorption); IV iron sucrose ถ้า oral intolerance/malabsorption; screen Hb at 12 mo (AAP); rule out lead exposure

---

IDA = most common pediatric anemia. Cow milk > 500-700 mL/d = major risk factor (low iron, GI bleeding, displaces iron-rich foods). AAP universal screen at 12 mo. Microcytic + low ferritin + high RDW. Replenish stores 3 mo post-normalization. Address dietary cause.', NULL,
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
XR wrist: cupping + fraying + widened growth plate', '[{"label":"A","text":"Calcium alone"},{"label":"B","text":"Nutritional Rickets (Vitamin D deficiency)"},{"label":"C","text":"High-dose calcitriol routinely"},{"label":"D","text":"Steroid"},{"label":"E","text":"Surgery for bowing first"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Nutritional Rickets (Vitamin D deficiency): Vitamin D3 (cholecalciferol) — Stoss therapy 600,000 IU PO single dose หรือ daily 2,000-6,000 IU × 8-12 wk depending on age + severity; calcium supplement 500-1000 mg/d elemental เมื่อ intake ต่ำ; expose sunlight (15-30 นาที/วัน arms+face); breastfed infant ต้อง vitamin D 400 IU/d ตั้งแต่ first weeks (AAP); recheck Ca, P, ALP, 25(OH)D, PTH ที่ 1 + 3 เดือน; maintenance 400-1,000 IU/d after; XR healing ใน 4-6 wk; investigate other causes (hypophosphatemic, VDDR) ถ้าไม่ตอบสนอง

---

Nutritional rickets = preventable. AAP recommends vitamin D 400 IU/d all breastfed infants from first weeks. Risk factors: exclusively breastfed without supplement, dark skin, limited sun, maternal deficiency. ALP elevated. Healing on X-ray 4-6 wk after treatment.', NULL,
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

No medical illness history; CBC normal, CMP normal, TSH normal, sweat chloride pending', '[{"label":"A","text":"Force feed via NG immediately"},{"label":"B","text":"Failure to Thrive (likely psychosocial + caloric insufficiency)"},{"label":"C","text":"Discharge without follow-up"},{"label":"D","text":"Steroid"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Failure to Thrive (likely psychosocial + caloric insufficiency): multidisciplinary approach (pediatrician + nutritionist + social worker + lactation/feeding specialist + mental health for mom); detailed dietary + feeding history + 3-day food diary; quantify caloric intake vs need (cal-up to 150 kcal/kg/d catch-up); fortify breast milk + add complementary food calorie-dense (avocado, oil, butter); maternal depression screen + treatment + WIC/government nutrition support; safe environment + nurturing; close growth follow-up q1-2 wk; investigate organic causes selected (celiac, CF, anemia, endocrine, renal); rule out abuse/neglect; hospitalize ถ้า severe (< 80% ideal weight, dehydration, social concern)

---

FTT = inadequate growth velocity. Causes: inadequate intake (most), inadequate absorption, increased need, defective utilization. Most psychosocial + dietary. Multidisciplinary key. Catch-up needs 150 kcal/kg/d. Rule out organic. Address psychosocial.', NULL,
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
  s.id, 'board', NULL, 'เด็กหญิงอายุ 2 เดือน term, healthy, exclusively breastfed มา well-child visit ครั้งแรกหลังคลอด (Birth visit ได้ Hep B แล้ว) เพื่อ vaccination', '[{"label":"A","text":"Wait until 6 months for first vaccines"},{"label":"B","text":"month routine vaccines (Thai EPI + recommended)"},{"label":"C","text":"Only Hepatitis B"},{"label":"D","text":"Defer if mild URI"},{"label":"E","text":"MMR + varicella"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** 2-month routine vaccines (Thai EPI + recommended): DTwP/DTaP, IPV, HepB (2nd dose), Hib, PCV13 (PCV10 also acceptable), Rotavirus (RV1 PO หรือ RV5 first dose, ต้องเริ่มก่อน 15 wk, ครบก่อน 8 mo); สามารถให้ multiple sites ใน same visit; observe 15 นาทีหลังฉีด; ผลข้างเคียงปกติ (low-grade fever, redness/swelling, fussy) ใช้ paracetamol PRN; contraindications absolute น้อย (anaphylaxis ต่อ vaccine; severe immune compromise สำหรับ live vaccines); BCG ให้แรกเกิด (Thai EPI); ครั้งถัดไป 4 mo + 6 mo

---

Thai EPI 2 mo: DTP-HB-Hib (5-in-1) + OPV/IPV + PCV + Rotavirus. AAP/CDC similar. Multiple simultaneous safe. Mild illness not contraindication. Live vaccines (MMR, varicella) start 9-12 mo. Catch-up schedule for delays.', NULL,
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
Sarnat stage II', '[{"label":"A","text":"Discharge home"},{"label":"B","text":"Hypoxic-Ischemic Encephalopathy (moderate, Sarnat II)"},{"label":"C","text":"Warming actively"},{"label":"D","text":"Steroid only"},{"label":"E","text":"Avoid all medication"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hypoxic-Ischemic Encephalopathy (moderate, Sarnat II): therapeutic hypothermia (selective head หรือ whole-body) start ภายใน 6 ชม of birth, target temp 33.5°C × 72 ชม → rewarm slowly 0.5°C/hr; eligibility: ≥ 36 wk GA, < 6 hr of life, evidence of perinatal acidosis (cord pH ≤ 7 or BE ≤ -16) + Apgar ≤ 5 ที่ 10 นาที หรือ ongoing resuscitation, moderate-severe encephalopathy; supportive care (ventilation, BP, glucose, electrolytes); EEG/aEEG monitor; treat seizures (phenobarbital 20 mg/kg load); avoid hyperthermia + hyperoxia + hypocapnia; MRI day 4-5; long-term developmental + neurology follow-up; counsel family about prognosis

---

HIE = leading cause neonatal neuro-disability term infants. Therapeutic hypothermia within 6 hr = standard of care, reduces death + disability NNT ~7. Sarnat staging guides treatment. EEG/MRI for prognosis. Multidisciplinary follow-up.', NULL,
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
US thyroid: athyreosis (no thyroid tissue)', '[{"label":"A","text":"Wait until 6 months to treat"},{"label":"B","text":"Congenital Hypothyroidism (athyreosis)"},{"label":"C","text":"Soy formula only"},{"label":"D","text":"PTU"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Congenital Hypothyroidism (athyreosis): start L-thyroxine 10-15 mcg/kg/d PO ทันที (crushed tablet ใน small breastmilk หรือ water — NOT soy formula, iron, calcium ที่ลด absorption); recheck TSH + free T4 ที่ 2 wk + 4 wk + q1-2 mo first year ปรับ dose; target TSH normal range + free T4 upper half of normal; goal: prevent permanent neurological damage (start ภายใน 2 wk of life critical); imaging (US, scintigraphy) for etiology — athyreosis = permanent; counsel family about lifelong treatment + monitoring; developmental follow-up + audiology + ophthalmology baseline

---

CH = most common preventable cause intellectual disability. Newborn screening universal. Start L-thyroxine ASAP (< 2 wk) at high dose 10-15 mcg/kg/d. Avoid soy formula, iron, calcium with dose. Monitor q1-2 mo first year. Athyreosis = permanent; ectopia or dyshormonogenesis variable.', NULL,
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
Confirmatory: BH4 cofactor testing negative (classic PKU not BH4-deficient)', '[{"label":"A","text":"Standard formula"},{"label":"B","text":"Classic Phenylketonuria"},{"label":"C","text":"High-protein diet"},{"label":"D","text":"BCAA supplementation"},{"label":"E","text":"Discharge no treatment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Classic Phenylketonuria: start Phe-restricted special medical formula (Lofenalac, Phenex) ทันที + provide essential amino acids except Phe; lifelong dietary management; goal Phe 2-6 mg/dL ตลอดชีวิต; metabolic geneticist + dietitian team; monitor Phe levels weekly first year + q monthly; allow limited natural protein for Tyr; supplement tyrosine, BH4 cofactor responsive trial (sapropterin); avoid aspartame; pregnancy planning critical (maternal PKU syndrome — fetal effects); growth + developmental monitoring; ใหม่: Phenylalanine ammonia lyase (pegvaliase) adults

---

PKU = autosomal recessive PAH deficiency. Untreated → severe intellectual disability, seizures, eczema, musty odor. Newborn screening + lifelong Phe-restricted diet prevents disability. Maternal PKU = teratogenic without strict control pre-conception. Sapropterin for responsive; pegvaliase enzyme replacement adults.', NULL,
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
PE: heart murmur (II/VI systolic LSB)', '[{"label":"A","text":"Reassure no further evaluation"},{"label":"B","text":"Trisomy 21 (Down syndrome)"},{"label":"C","text":"Surgery only addresses the issue"},{"label":"D","text":"No intervention needed"},{"label":"E","text":"Aggressive chemotherapy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Trisomy 21 (Down syndrome) — coordinated multispecialty care per AAP 2022 health supervision: confirm karyotype + counsel family; echocardiogram ใน first month (40-50% CHD — AVSD common); CBC at birth (transient abnormal myelopoiesis, polycythemia) + repeat first year; TSH at birth + 6 mo + annually (CH risk); ophthalmology + audiology birth + ongoing; cervical spine atlantoaxial instability evaluation before sports; growth chart Down-specific; feeding/swallow eval; developmental + early intervention; screen leukemia, celiac, sleep apnea (PSG at 4 yr), Alzheimer adult; immunizations standard; family education + support resources; long-term primary care coordination

---

DS = most common chromosomal disorder. Multisystem: CHD 50%, GI atresias, leukemia, hypothyroidism, sleep apnea, atlantoaxial instability, AD risk adult. AAP 2022 health supervision guideline. Coordinated team. Family-centered.', NULL,
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

Family mid-parental height 160 cm; bone age delayed 1 yr; karyotype 45,XO; renal US: horseshoe kidney; echo: bicuspid aortic valve', '[{"label":"A","text":"Wait until puberty starts spontaneously"},{"label":"B","text":"Turner Syndrome (45,XO) management"},{"label":"C","text":"Testosterone replacement"},{"label":"D","text":"Discharge no follow-up"},{"label":"E","text":"Chemotherapy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Turner Syndrome (45,XO) management: rhGH 0.35 mg/kg/wk SC start when growth falls below normal (ideally 4-6 yr) to maximize adult height; estrogen replacement start 11-12 yr low-dose transdermal then increase over 2-3 yr to mimic puberty + induce secondary sex characteristics + bone mineralization; later add progesterone for menstrual cycle; cardiac MRI baseline + echo q3-5 yr (BAV, coarctation, dissection risk); renal US baseline; thyroid + glucose + lipids annually; hearing + ophtho baseline + recurrent; bone density before estrogen + adulthood; ear infections + otitis; psychosocial support; fertility counseling (most infertile, oocyte donation); transition to adult endo; AHA cardiac care plan

---

Turner = monosomy X. Short stature + gonadal dysgenesis. Multisystem: cardiac (BAV, coarctation, dissection), renal, hearing, autoimmune. Multidisciplinary lifelong care. GH + estrogen + cardiac surveillance + psychosocial.', NULL,
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
Echo: large perimembranous VSD 8 mm + L→R shunt + LV/LA enlargement', '[{"label":"A","text":"Observe + repeat echo 1 yr"},{"label":"B","text":"Large VSD with congestive heart failure + failure to thrive"},{"label":"C","text":"Diuretic alone forever"},{"label":"D","text":"Cardiac transplant"},{"label":"E","text":"Discharge no medication"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Large VSD with congestive heart failure + failure to thrive: anti-HF therapy — furosemide 1-2 mg/kg/dose q8-12h PO + spironolactone 1-2 mg/kg/d + captopril 0.1-0.3 mg/kg/dose q8h (increase as tolerated, monitor BP + renal); high-calorie nutrition (24-27 kcal/oz formula) + may need NG feeds; treat anemia (keep Hb ≥ 10); RSV prophylaxis ในฤดู; immunizations on time; surgical/catheter closure 3-6 mo ของวัย ถ้า: persistent HF/FTT despite therapy, pulmonary HT, large shunt + Qp:Qs > 2; small restrictive VSD ส่วนใหญ่ปิดเอง (35-40%); cardiology follow-up; endocarditis prophylaxis routine NOT recommended unless prior IE/repair < 6 mo

---

VSD = most common CHD. Large VSD = HF + FTT. Manage HF medically + nutritional + timed surgical closure. Small VSD often closes spontaneously. AHA 2018 endocarditis prophylaxis only for highest-risk lesions (cyanotic, prosthetic, prior IE, < 6 mo post-repair).', NULL,
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
Gen: marked cyanosis, irritable, decreased intensity of pulmonic ejection murmur (vs baseline harsh)', '[{"label":"A","text":"Beta agonist nebulizer"},{"label":"B","text":"Tetralogy of Fallot ''tet spell'' (hypercyanotic spell)"},{"label":"C","text":"Diuretic IV"},{"label":"D","text":"Inotropic agent"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Tetralogy of Fallot ''tet spell'' (hypercyanotic spell): calm + knee-chest position (เพิ่ม SVR); 100% O2 mask; IV access + Morphine 0.1 mg/kg IM/IV หรือ SC (sedate + decrease respiratory effort + decrease infundibular spasm); IV fluid bolus 10-20 mL/kg NSS (increase preload + RV filling); Phenylephrine 0.02 mg/kg IV หรือ IV infusion ถ้า refractory (increase SVR); sodium bicarbonate ถ้า severe acidosis; Esmolol/Propranolol IV ถ้า spell continues (decrease infundibular contractility); AVOID inotropic agents (worsen RVOT obstruction); urgent cardiology + cardiac surgery — definitive surgical repair recommended now (delayed repair = more spells); admit ICU

---

Tet spell = acute increase in RVOT obstruction + decrease SVR → severe R→L shunt → hypoxia. Treatment increases SVR + reduces infundibular spasm. Knee-chest position increases SVR + venous return. Phenylephrine for refractory. Avoid inotropes (worsen obstruction). Definitive surgical repair after spell.', NULL,
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
ECG: narrow complex tachycardia rate 240, no P wave, regular rhythm = SVT (likely AVRT)', '[{"label":"A","text":"Immediate unsynchronized defibrillation"},{"label":"B","text":"Pediatric SVT (stable, narrow complex regular tachycardia)"},{"label":"C","text":"Lidocaine bolus"},{"label":"D","text":"Magnesium IV"},{"label":"E","text":"Discharge no treatment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric SVT (stable, narrow complex regular tachycardia): vagal maneuvers FIRST — apply ice pack/bag to face × 15-30 sec (diving reflex, most effective ใน infants); ถ้าไม่กลับ → Adenosine 0.1 mg/kg IV rapid push + flush via proximal IV (max 6 mg first dose, repeat 0.2 mg/kg max 12 mg); ถ้า unstable (poor perfusion, AMS, HF) → synchronized cardioversion 0.5-1 J/kg → 2 J/kg; identify + treat reversible causes; cardiology consult; long-term: digoxin หรือ propranolol prophylaxis; ablation for recurrent/refractory; counsel family about recurrence + vagal maneuvers at home

---

SVT = most common dysrhythmia infants. Vagal maneuvers (ice to face) first if stable. Adenosine = drug of choice. Synchronized cardioversion if unstable. WPW common substrate in infants. Long-term: medication or ablation.', NULL,
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
Echo: mild MR + mild AR, no vegetation', '[{"label":"A","text":"NSAID alone"},{"label":"B","text":"Acute Rheumatic Fever (Jones criteria revised 2015"},{"label":"C","text":"Antibiotic only 7 days"},{"label":"D","text":"Cardioversion"},{"label":"E","text":"Anticoagulation high dose"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Rheumatic Fever (Jones criteria revised 2015 — 2 major + evidence GAS): admit + bed rest until afebrile + ESR normalize; eradication GAS — benzathine penicillin G IM 600,000-1,200,000 U single dose (or PO penicillin V × 10 d); arthritis + carditis — high-dose aspirin 80-100 mg/kg/d ÷ 4 doses (monitor salicylate level, hepatotoxicity); severe carditis (CHF, severe valve insufficiency) — corticosteroid (prednisolone 1-2 mg/kg/d × 2-3 wk taper); Sydenham chorea — supportive ± haloperidol/valproic acid; HF management; ECHO + serial; SECONDARY PROPHYLAXIS critical — benzathine penicillin IM q3-4 wk ต่อ minimum 10 ปี หรือถึง 21 ปี (without carditis) หรือ 40 ปี/lifelong (with carditis); dental prophylaxis only for severe valve disease per AHA

---

ARF = post-strep autoimmune. Jones criteria revised 2015 (low + high-risk populations). Major: carditis, arthritis, chorea, erythema marginatum, subcutaneous nodules. Long-term secondary prophylaxis critical — duration depends on carditis severity. Pen V or benzathine IM standard.', NULL,
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
Stool elastase: very low (pancreatic insufficient)', '[{"label":"A","text":"Antibiotic only as needed"},{"label":"B","text":"Cystic Fibrosis (classic F508del homozygous)"},{"label":"C","text":"Steroid daily"},{"label":"D","text":"Restrict salt"},{"label":"E","text":"Diuretic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cystic Fibrosis (classic F508del homozygous) — multidisciplinary CF center care: airway clearance — chest physiotherapy + nebulized hypertonic saline 7% + dornase alfa daily; bronchodilator pre-airway clearance; pancreatic enzyme replacement (PERT) 1500-2500 lipase units/kg/meal — monitor + titrate; high-calorie diet (110-200% of normal need) + fat-soluble vitamin (ADEK) supplement + salt supplement; treat infection — sputum culture q3 mo, treat Staph (anti-staph penicillin), Pseudomonas (inhaled tobramycin or colistin) chronically suppressive; CFTR modulator — elexacaftor/tezacaftor/ivacaftor (Trikafta) ≥ 2 yr F508del = transformative; vaccinations (RSV, flu, COVID); CF-related diabetes screen annually > 10 yr; liver, bone, sinus, fertility monitoring; mental health; psychosocial support

---

CF = autosomal recessive, F508del most common mutation. Multisystem: lung, pancreas, sweat, sinuses, liver, fertility. Newborn screening (IRT + DNA). CFTR modulators revolutionized care. Median survival now 50+ yr. Center-based multidisciplinary care essential.', NULL,
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
Nasopharyngeal PCR for Bordetella pertussis: positive', '[{"label":"A","text":"Discharge home"},{"label":"B","text":"Pertussis < 6 mo = high risk severe"},{"label":"C","text":"Bronchodilator only"},{"label":"D","text":"Steroid"},{"label":"E","text":"Antiviral"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pertussis < 6 mo = high risk severe: admit (apnea, pulmonary HT, death risk); macrolide (azithromycin 10 mg/kg/d × 5 d preferred ในเด็ก < 1 mo เพื่อหลีกเลี่ยง erythromycin/IHPS); supportive — O2, monitor for apnea/cyanosis (continuous cardiopulmonary), suction, IV fluid, small frequent feeds; consider exchange transfusion ถ้า extreme leukocytosis + pulmonary HT (lifesaving in severe cases); droplet isolation 5 d after start macrolide; ICU + intubation ถ้า respiratory failure; reportable disease; post-exposure prophylaxis household contacts macrolide; Tdap booster mother + cocooning + maternal Tdap during pregnancy (27-36 wk) สำคัญ; complete DTaP catch-up

---

Pertussis < 6 mo = high mortality. Macrolide reduces shedding (azithromycin first-line). Maternal Tdap during pregnancy + cocooning protects infants until immunized. Extreme leukocytosis (> 50K) + pulmonary HT = exchange transfusion considered. Reportable.', NULL,
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
Tuberculin skin test (TST) 12 mm induration, IGRA positive', '[{"label":"A","text":"No treatment indicated"},{"label":"B","text":"Latent TB Infection (LTBI, child < 5 yr or close contact = high priority)"},{"label":"C","text":"Active TB regimen 6 months"},{"label":"D","text":"Wait for symptoms"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Latent TB Infection (LTBI, child < 5 yr or close contact = high priority): start LTBI treatment — INH 10 mg/kg/d × 6-9 mo (standard) หรือ rifampin 15-20 mg/kg/d × 4 mo (shorter, fewer hepatotoxicity) หรือ INH + rifapentine once weekly × 12 wk (3HP, ≥ 2 yr); pyridoxine 1-2 mg/kg/d supplement (prevent INH neuropathy in malnourished, breastfed, vegetarian); monthly clinical evaluation (compliance, hepatotoxicity); LFT baseline + as needed; address index case + screen household; CXR + symptoms re-evaluate ถ้า new symptoms; education + DOTS if compliance concern; report public health; vaccinate BCG not protective against pulmonary TB but reduces meningitis/miliary

---

Pediatric LTBI = critical to treat (high progression to active TB). 6-9 mo INH classic; 4 mo rifampin or 3HP equally effective with fewer side effects + better adherence. Pyridoxine supplement. CDC/WHO recommend LTBI treatment for child close contacts.', NULL,
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
Viral PCR: enterovirus +', '[{"label":"A","text":"Diuretic alone forever"},{"label":"B","text":"Viral Myocarditis with acute decompensated HF"},{"label":"C","text":"High-dose steroid mandatory"},{"label":"D","text":"Antibiotic alone"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Viral Myocarditis with acute decompensated HF: ICU admission with continuous monitoring; ABC + supplemental O2 + non-invasive ventilation/intubation ถ้า severe; gentle fluid resuscitation (watch for worsening HF); inotropic support — milrinone (preferred — inodilator, less arrhythmogenic) 0.25-0.75 mcg/kg/min หรือ low-dose epinephrine; diuretic furosemide IV; afterload reduction (carvedilol, ACEI) เมื่อ stable; mechanical circulatory support (VAD, ECMO) ถ้า refractory cardiogenic shock; arrhythmia management (avoid digoxin acutely); IVIG controversial — selected cases; routine immunosuppression NOT recommended; treat underlying infection; HF + arrhythmia team + cardiac transplant evaluation ถ้า persistent; long-term: gradual recovery 50-70%, residual cardiomyopathy 20-30%, death/transplant 10%; restrict activity 3-6 mo

---

Viral myocarditis = leading cause acute DCM kids. Enterovirus, parvo, adeno, SARS-CoV-2 common. ICU + inotropic + mechanical support. ECMO bridge to recovery/transplant. Steroid/IVIG limited evidence — selected cases. 3 outcomes: recovery, chronic DCM, death.', NULL,
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
Stool culture: E. coli O157:H7 positive (Shiga toxin)', '[{"label":"A","text":"Antibiotic for EHEC"},{"label":"B","text":"Typical HUS (post-EHEC Shiga toxin)"},{"label":"C","text":"Loperamide"},{"label":"D","text":"Heparin"},{"label":"E","text":"Aspirin"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Typical HUS (post-EHEC Shiga toxin): supportive care mainstay (no specific treatment cures); fluid management — careful IV fluid early in disease may prevent oliguric phase, but ONCE oliguric → restrict to insensible + UO; correct electrolytes (K, P, Ca); transfuse PRBC for Hb < 6 หรือ symptomatic; AVOID platelet transfusion (worsens microangiopathy) unless major bleeding/surgery; renal replacement therapy (HD, CRRT, PD) ถ้า severe AKI/uremia/hyperK/volume overload — needed ~50%; treat HT; AVOID antibiotic for EHEC (increases Shiga toxin release + HUS risk in some studies); AVOID antimotility (loperamide, opioid); plasma exchange not indicated typical HUS; eculizumab for atypical HUS (complement dysregulation, recurrent, family Hx); long-term renal + BP follow-up; reportable disease + public health

---

Typical HUS = MAHA + thrombocytopenia + AKI post-EHEC Shiga toxin. Supportive only. Avoid antibiotic + antimotility (worsen). Atypical HUS (complement) = eculizumab. Long-term CKD risk 25%. Public health reporting (foodborne).', NULL,
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
Anti-GAD65 + IA-2 antibodies positive (T1DM autoimmune)', '[{"label":"A","text":"Metformin alone"},{"label":"B","text":"New-onset Type 1 Diabetes without DKA"},{"label":"C","text":"Sulfonylurea"},{"label":"D","text":"Lifestyle alone"},{"label":"E","text":"Discharge no treatment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** New-onset Type 1 Diabetes without DKA: start subcutaneous insulin — basal-bolus regimen (preferred): glargine/detemir/degludec long-acting once daily (~0.4-0.5 U/kg/d total = 50% basal, 50% bolus) + rapid-acting (lispro, aspart, glulisine) pre-meal based on carb counting + correction; alternative: NPH + regular insulin ทวีติด; start total daily insulin 0.5-1 U/kg/d (peripubertal more); diabetes team education (carb counting, glucose monitoring 4-6×/d or CGM, sick day rules, hypoglycemia recognition + glucagon, exercise, ketone monitoring); HbA1c target < 7.5% (ADA recent: individualize, < 7% if achievable safely); annual screen — TSH, celiac, retinopathy (≥ 11 yr or 2-5 yr post-Dx), microalbuminuria (≥ 11 yr or 2-5 yr), lipid; immunizations (flu, pneumococcal); psychosocial support; transition to adult care; technology — CGM, insulin pump, AID systems greatly improve outcomes

---

T1DM = autoimmune β-cell destruction. Insulin mandatory. ISPAD/ADA: basal-bolus or pump = standard. Carb counting + flexible insulin + CGM = modern. Address comorbidities + transition. AID closed-loop systems improve TIR + reduce burden.', NULL,
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
No seizure', '[{"label":"A","text":"Wait until 6 hr"},{"label":"B","text":"Neonatal Hypoglycemia (symptomatic, IDM)"},{"label":"C","text":"Glucose oral gel only"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Insulin"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neonatal Hypoglycemia (symptomatic, IDM): IV access + start IV dextrose — give bolus D10W 2 mL/kg (200 mg/kg) slow IV push then continuous D10W infusion GIR 6-8 mg/kg/min, titrate up to achieve glucose > 50 mg/dL (< 48h) and > 60 mg/dL (> 48h); recheck glucose 15-30 min after intervention then q1-2h until stable; continue regular feeds (breast or formula) once stable + tolerating; gradually wean IV as PO intake increases (rebound common); if persistent hypoglycemia despite GIR 12-15 mg/kg/min → think hyperinsulinism (diazoxide, octreotide, glucagon), inborn error, hormone deficiency; check critical sample (insulin, cortisol, GH, lactate, ketones, FFA, ammonia, AC profile) ขณะ hypo; long-term: neurodevelopmental follow-up severe/prolonged

---

Neonatal hypoglycemia = preventable cause neurodisability. Symptomatic + glucose < 47 (PES 2015) or < 50 (AAP) = treat. IDM = transient hyperinsulinism, screen + feed early. Persistent severe → workup for hyperinsulinism/inborn error. Avoid prolonged hypoglycemia.', NULL,
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
AXR: paint chip in colon', '[{"label":"A","text":"No treatment if asymptomatic"},{"label":"B","text":"Pediatric Lead Poisoning BLL ≥ 45 mcg/dL = chelation therapy indicated"},{"label":"C","text":"Wait until 100 mcg/dL"},{"label":"D","text":"Discharge home no follow-up"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Lead Poisoning BLL ≥ 45 mcg/dL = chelation therapy indicated: หา + remove lead source FIRST (critical — re-exposure futile chelation); BLL 45-69 + asymptomatic → outpatient succimer (DMSA) 10 mg/kg/dose q8h × 5 d then q12h × 14 d (oral chelator); BLL ≥ 70 หรือ symptomatic encephalopathy → inpatient + dual IV CaNa2EDTA + IM dimercaprol (BAL) (BAL ก่อน EDTA หลีกเลี่ยง redistribution to brain); whole bowel irrigation/cathartic for chip in GI; iron + calcium + zinc supplement (compete absorption); environmental abatement (Department of Public Health, certified abatement); recheck BLL post-chelation + 2-4 wk; family screen siblings + lead source; public health reporting; developmental + neurology follow-up (irreversible cognitive deficit); CDC 2021 reference value 3.5 mcg/dL — any BLL = action

---

Lead = potent neurotoxin, no safe level. CDC blood lead reference 3.5 mcg/dL (2021). Chelation ≥ 45 + remove source. Encephalopathy = emergency (BAL + EDTA). Source: old paint, water pipes, soil, imported items. Sources of exposure must be eliminated.', NULL,
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
Glucose bedside 96, no obvious trauma', '[{"label":"A","text":"Observe + wait"},{"label":"B","text":"Pediatric Status Epilepticus (> 5 min established)"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Diuretic"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Status Epilepticus (> 5 min established): ABC — position, suction, jaw thrust, O2 + bag-mask ถ้า inadequate ventilation, monitor; rapid glucose check (give D10W 5 mL/kg ถ้า < 60); IV/IO access; FIRST line = Lorazepam 0.1 mg/kg IV (max 4 mg) หรือ Midazolam 0.2 mg/kg IM/IN/buccal (no IV) — may repeat × 1 ที่ 5 นาที; SECOND line ถ้า persists: fosphenytoin 20 mg PE/kg IV (over 7-10 min, monitor BP/arrhythmia) หรือ Levetiracetam 60 mg/kg IV (max 4.5 g, equally effective per ESETT 2019) หรือ valproate 40 mg/kg IV (avoid age < 2, hepatic dysfunction, metabolic concern); THIRD line ถ้า refractory > 30-60 min: midazolam infusion หรือ pentobarbital coma → intubate + EEG monitor in ICU; treat underlying cause (FS workup, infection, electrolytes, toxic, structural); antipyretic for fever; do NOT delay treatment for diagnostics

---

SE = neurologic emergency. > 5 min = treat. Time = brain. Benzo first (lorazepam IV preferred, midaz IM/buccal/IN if no IV). Second-line: fosphenytoin, leva, valproate equivalent (ESETT 2019). Refractory > 30-60 min = anesthetic infusion + ICU. Treat underlying cause.', NULL,
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
ไม่มี red flags (no head trauma, no fever, no fixed deficit, no AM headache + vomit, normal exam)', '[{"label":"A","text":"Brain MRI mandatory all kids"},{"label":"B","text":"Pediatric Migraine without aura (ICHD-3 criteria)"},{"label":"C","text":"Opioid as needed"},{"label":"D","text":"Antibiotic"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Migraine without aura (ICHD-3 criteria): no neuroimaging needed (no red flags + normal exam); acute treatment — ibuprofen 10 mg/kg PO at onset (most effective NSAID) หรือ acetaminophen 15 mg/kg; triptans (sumatriptan nasal/PO, rizatriptan, almotriptan, zolmitriptan) ≥ 12 yr FDA-approved; antiemetic (ondansetron, metoclopramide) ถ้าคลื่นไส้; rest in dark quiet room; treat early ในตอน aura/onset; prevention ถ้า > 4-6 attacks/mo + functional impact — topiramate, amitriptyline (low dose, off-label), propranolol; CGRP antagonist (rimegepant > 12, atogepant > 12) emerging; behavioral: cognitive behavioral therapy + biofeedback proven effective in peds (CHAMP trial); lifestyle — regular sleep, hydration, meals, exercise, limit screens, trigger diary; education; school accommodation

---

Pediatric migraine common. Ibuprofen + triptan acute. CHAMP trial: behavioral therapy + low-dose preventive equivalent. Imaging only with red flags. Lifestyle + trigger management critical. CGRP class emerging in older adolescents.', NULL,
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
MRI brain: periventricular leukomalacia', '[{"label":"A","text":"No intervention needed"},{"label":"B","text":"Spastic diplegic Cerebral Palsy (likely from PVL)"},{"label":"C","text":"Spinal surgery infant"},{"label":"D","text":"Discharge no therapy"},{"label":"E","text":"Chemotherapy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Spastic diplegic Cerebral Palsy (likely from PVL) — early intervention multidisciplinary: PT/OT/speech therapy intensive — focus motor + functional skills (GMFM, Bayley); orthotics (AFO) prevent contracture + improve gait; spasticity management — oral baclofen, dantrolene, diazepam (titrate); focal — botulinum toxin injection (effective for focal spasticity, repeat q3-6 mo); intrathecal baclofen pump (severe generalized); selective dorsal rhizotomy (GMFCS II-III, ambulatory, age 4-8); orthopedic surgery (tendon lengthening, osteotomy) selected; assistive devices (walker, wheelchair); GMFCS staging; co-morbidities — epilepsy 30-50%, intellectual 50%, hearing/vision, GI/feeding, GERD, sleep, hip surveillance + scoliosis; family-centered + IEP school; address pain + drooling + bone health; nutrition + growth; transition planning

---

CP = non-progressive motor disorder, perinatal injury (PVL, HIE common). GMFCS staging guides function. Early intervention + multidisciplinary essential. Spasticity tools: oral, botox, ITB, SDR, surgery. Address comorbidities. Family-centered.', NULL,
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
No dysmorphism, normal exam', '[{"label":"A","text":"Reassure ''late talker''"},{"label":"B","text":"Suspected ASD"},{"label":"C","text":"Discharge — wait 1 yr"},{"label":"D","text":"Steroid"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Suspected ASD — refer for comprehensive evaluation (developmental pediatrician, psychologist with ADOS-2, speech-language) — diagnosis < 24 mo possible reliable; AAP universal ASD screen 18 + 24 mo with M-CHAT-R; while awaiting eval start early intervention (federal Part C, ages 0-3) — applied behavioral analysis (ABA) intensive 20-40 hr/wk, speech, OT, sensory integration; parent training (Pivotal Response Treatment, ESDM); audiology if not done; genetic evaluation (chromosomal microarray + Fragile X DNA + targeted gene panel if features); medical comorbidities — seizure, sleep, GI, ADHD; immunizations standard (no MMR-autism link, debunked); family support + IEP school transition; medication only for specific symptoms (risperidone/aripiprazole for severe irritability/aggression, melatonin sleep) not core ASD; school IEP/IDEA

---

ASD prevalence 1 in 36 (CDC 2023). Early identification + intervention critical for outcomes. AAP screen 18 + 24 mo. M-CHAT-R/F. Comprehensive eval (ADOS-2 + ADI-R). Multidisciplinary intervention. Medication for comorbid symptoms only. Genetic + medical workup. No vaccine link.', NULL,
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
Family Hx: father has ADHD', '[{"label":"A","text":"Wait until age 12"},{"label":"B","text":"ADHD combined presentation (DSM-5)"},{"label":"C","text":"Antibiotic"},{"label":"D","text":"Surgery"},{"label":"E","text":"Punishment-based"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** ADHD combined presentation (DSM-5): multimodal treatment — first-line FDA-approved stimulant medications (methylphenidate, amphetamine derivatives) effective 70-80%, start low + titrate up clinical effect + side effect (appetite, sleep, growth, BP); long-acting preparations preferred adherence; alternative — atomoxetine (NRI), guanfacine ER, clonidine ER (non-stimulant, slower onset); behavioral therapy + parent training (mandatory < 6 yr); IEP/504 school accommodations (extended time, preferred seating, breaks, organizational support); monitor growth, BP, HR; sleep hygiene; address comorbid (anxiety, depression, ODD, learning disability); avoid screen + structured routine; reassess q3-6 mo; long-term: persists 50-65% adult; AAP 2019 + AACAP guideline

---

ADHD = neurodevelopmental, persists adulthood half. DSM-5 criteria: ≥ 6 symptoms either inattention or hyperactivity/impulsivity, ≥ 6 mo, ≥ 2 settings, before 12 yr, impairment. Vanderbilt screening tool. Stimulant first-line 6+ yr; behavioral primary < 6. Multimodal. Address comorbidities + school.', NULL,
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
No substance use; no family Hx attempt', '[{"label":"A","text":"Outpatient SSRI alone discharge"},{"label":"B","text":"Adolescent Severe Major Depression with active suicidal ideation + means access"},{"label":"C","text":"Reassure no follow-up"},{"label":"D","text":"Bupropion as first-line"},{"label":"E","text":"Sleeping pills"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Adolescent Severe Major Depression with active suicidal ideation + means access: immediate safety assessment — ensure ในที่ปลอดภัย ใน clinic จนกว่า safe disposition; เก็บยาทั้งหมด lock + remove firearms/sharps จากบ้าน (lethal means restriction); psychiatric evaluation urgent + likely admission to inpatient psychiatry (active SI + means + persistent symptoms = high risk); safety plan + crisis hotline (988); start SSRI fluoxetine 10-20 mg/d (only FDA-approved peds depression > 8 yr) — monitor closely first 4 wk for activation/SI (black box warning); evidence-based psychotherapy — CBT or IPT-A; family involvement + psychoeducation; school support; treat comorbidities; ภายใน 1 wk follow-up; sertraline alternative; ความคาดหวัง: response 50-60%, remission 30-40%; persistent → SSRI + CBT (TADS); refractory → augmentation, ECT, ketamine (selected); transition to adult care; suicide risk persists — ongoing monitoring

---

Adolescent depression + active SI with means = high acute risk → admission. Lethal means restriction = #1 evidence-based prevention. SSRI fluoxetine peds depression only FDA-approved < 18 (sertraline > 6 only OCD). Combination CBT + SSRI > monotherapy (TADS). Black box warning monitoring.', NULL,
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

ECG: prolonged QTc, sinus brady; K 3.0, Phosphate 2.2, ALT/AST elevated; bone density Z-score -2.1', '[{"label":"A","text":"Outpatient calorie diary only"},{"label":"B","text":"Anorexia Nervosa, restricting type, severe with medical instability"},{"label":"C","text":"Force feed without medical eval"},{"label":"D","text":"Punitive approach"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Anorexia Nervosa, restricting type, severe with medical instability — admit for medical stabilization (criteria: HR < 50 day or < 45 night, BP < 90/45, orthostatic, < 75% IBW, electrolyte imbalance, refeeding risk): cardiac monitor; SLOW refeeding to avoid refeeding syndrome — start 1,200-1,400 kcal/d (or 30-40 kcal/kg/d) ค่อยเพิ่ม 200 kcal q1-3 d (newer guidelines: more aggressive start ใน less severe cases); check + correct electrolytes (P, K, Mg) daily + thiamine supplement BEFORE feeding; weight gain target 0.5-1 kg/wk inpatient; calorie progression supervised; multidisciplinary team — pediatrician, dietitian, mental health (Family-Based Treatment Maudsley = first-line ที่อายุ < 18, evidence-based for AN); olanzapine adjunct ของบางอย่าง; SSRI helpful comorbid anxiety/depression (after weight restoration); bone density monitoring + treat with weight restoration not BP/HRT; medical follow-up + long-term: mortality 5%, recovery 50-70%

---

AN = high mortality eating disorder (highest of all mental illnesses). Hospitalize for medical instability. Refeeding syndrome = fatal — slow refeed + phosphate/electrolyte/thiamine. FBT (Maudsley) = first-line < 18. Multidisciplinary. Bone, growth, fertility long-term.', NULL,
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
  s.id, 'board', NULL, 'เด็กหญิงอายุ 16 ปี มี nodulocystic acne รุนแรงทั่วใบหน้า + หลัง + อก หลายปี ใช้ benzoyl peroxide + topical retinoid + tetracycline 6 mo แล้วไม่ดีขึ้น มี scarring + ส่งผลต่อ self-esteem มาก', '[{"label":"A","text":"Continue same regimen"},{"label":"B","text":"Severe nodulocystic acne refractory to standard therapy"},{"label":"C","text":"Wait + outgrow"},{"label":"D","text":"Steroid systemic chronic"},{"label":"E","text":"Antibiotic 5 years"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe nodulocystic acne refractory to standard therapy → consider Isotretinoin (oral) — cumulative dose 120-150 mg/kg over 5-6 mo; pregnancy prevention iPLEDGE program mandatory in females (teratogenic — Category X, 2 effective contraception methods + monthly pregnancy test); baseline + monthly LFT + lipid + CBC; counsel side effects (dry skin/lips/eyes, photosensitivity, depression/suicidal ideation monitor, IBD link not proven, night vision, headache from pseudotumor cerebri, hyperostosis); avoid tetracycline concurrent (pseudotumor); avoid waxing/laser × 6 mo; mental health screen + support; results: clear 70-90%, relapse 30%; alternative oral spironolactone (anti-androgen, females), oral hormonal therapy (COC, anti-androgen), light/laser therapy; multidisciplinary — dermatology + adolescent medicine + mental health

---

Severe nodulocystic acne → isotretinoin = most effective. iPLEDGE registry mandatory (teratogenicity). Monitor LFT/lipid/mental health. Acne scarring + psychosocial impact justifies aggressive treatment. Alternative oral anti-androgens (spironolactone, COC) effective females.', NULL,
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

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกชายอายุ 4 เดือน term, BW 7 kg พบ groin bulge ทั้งสองข้างเมื่อร้องไห้ + ขณะ feeding 2 สัปดาห์ ตอนนี้ฝั่งขวาบวมเริ่มแข็ง 4 ชม ทารกร้องไห้รุนแรง อาเจียน 1 ครั้ง groin red

PE: right groin: tender + non-reducible mass, mild erythema
Left groin: easily reducible bulge
No testicular pain/swelling, abdomen soft non-distended', '[{"label":"A","text":"Elective surgery 1 year"},{"label":"B","text":"Incarcerated right inguinal hernia (surgical emergency) + asymptomatic left reducible hernia"},{"label":"C","text":"Wait + observe"},{"label":"D","text":"Antibiotic alone"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Incarcerated right inguinal hernia (surgical emergency) + asymptomatic left reducible hernia: attempt manual reduction with sedation (morphine + midazolam) + Trendelenburg + gentle steady pressure — successful 80% if reduction within 12 hr of incarceration; ถ้า reduce ได้ → schedule semi-elective surgical repair ภายใน 24-48 ชม (allow edema to subside, reduce recurrent incarceration); ถ้า reduction ไม่สำเร็จ หรือ strangulation/perforation signs (peritonitis, sepsis, bilious vomiting, bloody stool) → emergency surgery; NPO + IV fluid + pediatric surgery consultation; left side — repair simultaneously contralateral exploration controversial ในเด็กเอเชีย exploration recommended (35% contralateral PPV); preterm/high-risk hernia higher complication = repair before discharge from NICU; post-op: testicular check + recurrence monitoring

---

Pediatric inguinal hernia = indirect (patent processus vaginalis). Incarceration risk highest first year. Manual reduction first if no strangulation. Surgery semi-elective post-reduction. Contralateral exploration in young infants debated.', NULL,
  'easy', 'gi', 'review',
  'pediatrics', 'clinical_decision', 'gi', 'peds',
  'AAP/APSA Pediatric Inguinal Hernia', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกชายอายุ 4 เดือน term, BW 7 kg พบ groin bulge ทั้งสองข้างเมื่อร้องไห้ + ขณะ feeding 2 สัปดาห์ ตอนนี้ฝั่งขวาบวมเริ่มแข็ง 4 ชม ทารกร้องไห้รุนแรง อาเจียน 1 ครั้ง groin red

PE: right groin: tender + non-reducible mass, mild erythema
Left groin: easily reducible bulge
No testicular pain/swelling, abdomen soft non-distended'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกชายอายุ 5 สัปดาห์ first-born อาเจียน projectile non-bilious เพิ่มขึ้น × 1 สัปดาห์ หลังกินนม น้ำหนักลด 200 g ดูดนมเก่ง (hungry vomiter)

V/S: HR 162, RR 38, BW 3.8 kg (BW เกิด 3.6 kg)
PE: dehydrated, sunken fontanelle, peristaltic wave visible LUQ → RLQ, palpable olive RUQ, no abdominal distension

Lab: Na 132, K 3.0, Cl 88, HCO3 32 (hypochloremic hypokalemic metabolic alkalosis), BUN 28
US pylorus: muscle thickness 5 mm, length 18 mm = pyloric stenosis', '[{"label":"A","text":"Emergency surgery before correcting electrolytes"},{"label":"B","text":"Hypertrophic Pyloric Stenosis"},{"label":"C","text":"Discharge with formula change"},{"label":"D","text":"Reglan oral"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hypertrophic Pyloric Stenosis: surgery is NEVER emergency — correct fluid + electrolyte FIRST (anesthesia safety): NPO + NG decompression; IV fluid resuscitation D5 1/2 NSS + KCl 20 mEq/L at 1.5-2× maintenance; goal — correct dehydration, normalize Cl > 100, HCO3 < 30, K > 3.5, urine output good; usually 24-48 ชม; THEN surgical pyloromyotomy (Ramstedt) — laparoscopic preferred; feed advancement 6-8 ชม post-op (small volume → full); home POD 1-2; long-term: excellent outcome, no growth issues; education + reassurance

---

HPS = classic first-born male, 3-6 wk, projectile non-bilious vomit, hungry baby. Hypochloremic hypokalemic metabolic alkalosis (paradoxical aciduria). Correct electrolytes FIRST — anesthesia/respiratory safety critical. Pyloromyotomy curative.', NULL,
  'easy', 'gi', 'review',
  'pediatrics', 'clinical_decision', 'gi', 'peds',
  'AAP Section on Surgery; UpToDate Pyloric Stenosis', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกชายอายุ 5 สัปดาห์ first-born อาเจียน projectile non-bilious เพิ่มขึ้น × 1 สัปดาห์ หลังกินนม น้ำหนักลด 200 g ดูดนมเก่ง (hungry vomiter)

V/S: HR 162, RR 38, BW 3.8 kg (BW เกิด 3.6 kg)
PE: dehydrated, sunken fontanelle, peristaltic wave visible LUQ → RLQ, palpable olive RUQ, no abdominal distension

Lab: Na 132, K 3.0, Cl 88, HCO3 32 (hypochloremic hypokalemic metabolic alkalosis), BUN 28
US pylorus: muscle thickness 5 mm, length 18 mm = pyloric stenosis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 12 ปี ปวดท้องเริ่มรอบสะดือ 18 ชม ก่อน ย้ายมา RLQ + ไข้ + คลื่นไส้อาเจียน + เบื่ออาหาร เดินสะเทือนเจ็บ

V/S: HR 122, BP 110/72, Temp 38.4°C, BW 36 kg
PE: RLQ tenderness at McBurney, Rovsing +, psoas +, obturator +, rebound +

CBC: WBC 16,500 (left shift), CRP 78
Pediatric Appendicitis Score 9 (likely)
US abdomen: non-compressible appendix > 7 mm + appendicolith + peri-appendiceal fluid', '[{"label":"A","text":"Discharge antibiotic only"},{"label":"B","text":"Acute Appendicitis (likely non-perforated)"},{"label":"C","text":"MRI before surgery"},{"label":"D","text":"Steroid alone"},{"label":"E","text":"Wait 1 week"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Appendicitis (likely non-perforated): NPO + IV fluid resuscitation + analgesia + IV antibiotic ceftriaxone + metronidazole หรือ piperacillin-tazobactam pre-op; surgical consultation; laparoscopic appendectomy ภายใน 12-24 ชม preferred (less SSI, shorter LOS); short-course antibiotic 24 ชม post-op ถ้า non-perforated; ถ้า perforated/abscess → 5-7 d IV → switch oral; non-operative management (NOM) ด้วย antibiotic + observation = option for selected non-complicated cases (recent evidence shows acceptable in selected); appendectomy still standard ใน complicated cases; post-op: advance diet POD 1, discharge POD 1-2; long-term: rare recurrence in NOM (~30%); educate signs return

---

Appendicitis = most common acute surgical abdomen kids. PAS or Alvarado helpful. US first-line imaging (avoid CT radiation). Laparoscopic appendectomy standard. NOM antibiotic-alone emerging option for non-complicated. Recurrence ~30% after NOM.', NULL,
  'medium', 'gi', 'review',
  'pediatrics', 'clinical_decision', 'gi', 'peds',
  'WSES Pediatric Appendicitis Guideline 2021; AAP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 12 ปี ปวดท้องเริ่มรอบสะดือ 18 ชม ก่อน ย้ายมา RLQ + ไข้ + คลื่นไส้อาเจียน + เบื่ออาหาร เดินสะเทือนเจ็บ

V/S: HR 122, BP 110/72, Temp 38.4°C, BW 36 kg
PE: RLQ tenderness at McBurney, Rovsing +, psoas +, obturator +, rebound +

CBC: WBC 16,500 (left shift), CRP 78
Pediatric Appendicitis Score 9 (likely)
US abdomen: non-compressible appendix > 7 mm + appendicolith + peri-appendiceal fluid'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกอายุ 3 เดือน term BW 6 kg (50th percentile, growing normally) gulp + spit up after most feeds ตั้งแต่อายุ 2 wk ปริมาณน้อย ไม่หลังจาก projectile happy baby, gain weight ดี, feed ดี, ไม่ irritable, no respiratory issue

PE ปกติ, no dehydration, no abdominal mass, no FTT', '[{"label":"A","text":"Start PPI immediately"},{"label":"B","text":"Physiologic Gastroesophageal Reflux (GER, not GERD"},{"label":"C","text":"Surgery fundoplication"},{"label":"D","text":"Stop breastfeeding"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Physiologic Gastroesophageal Reflux (GER, not GERD — ''happy spitter''): reassurance to parents — ~50% infants at 4 mo, peaks 4 mo, resolves > 90% by 12 mo (lower esophageal sphincter immature); positioning — UPRIGHT 20-30 min after feed; AVOID prone or side-lying for sleep (SIDS risk); smaller more frequent feeds; thickened feed (rice cereal, infant rice starch) ถ้า ของเหลวมาก; trial of hypoallergenic formula (extensively hydrolyzed) × 2-4 wk ถ้าสงสัย milk protein allergy; AVOID acid suppression in uncomplicated GER (no benefit, increased infection + fracture risk); review red flag — FTT, projectile, bilious, blood, persistent crying, hematemesis, dysphagia, lethargy → workup; education + follow-up if persists past 12-18 mo or develops GERD complications (esophagitis, FTT, respiratory)

---

Physiologic GER common, resolves spontaneously. No need for acid suppression in uncomplicated ''happy spitter.'' GERD = pathologic when complications (FTT, esophagitis, respiratory). NASPGHAN/ESPGHAN 2018 advise against acid suppression first-line.', NULL,
  'easy', 'gi', 'review',
  'pediatrics', 'clinical_decision', 'gi', 'peds',
  'NASPGHAN/ESPGHAN Joint Guideline on Pediatric GERD 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกอายุ 3 เดือน term BW 6 kg (50th percentile, growing normally) gulp + spit up after most feeds ตั้งแต่อายุ 2 wk ปริมาณน้อย ไม่หลังจาก projectile happy baby, gain weight ดี, feed ดี, ไม่ irritable, no respiratory issue

PE ปกติ, no dehydration, no abdominal mass, no FTT'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 4 ปี ถ่ายอุจจาระแข็งทุก 5-7 วัน × 6 เดือน เจ็บขณะถ่าย retentive posturing soiling underwear 3 ครั้ง/wk หลังจาก toilet trained 3 yr ปกติ

Diet: low fiber, picky eating, ดูดนมวัว 1 L/d, น้ำน้อย, no exercise; emotion อาย
PE: palpable stool LLQ + suprapubic, anal exam normal (no fissure, no tag), no neuro deficit, growth normal

No red flags (no delayed meconium, no FTT, no bloody stool)', '[{"label":"A","text":"Surgery"},{"label":"B","text":"Functional constipation with overflow encopresis (Rome IV criteria)"},{"label":"C","text":"Discharge no treatment"},{"label":"D","text":"Daily enema chronic"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Functional constipation with overflow encopresis (Rome IV criteria): disimpaction — polyethylene glycol (PEG 3350/Miralax) 1-1.5 g/kg/d × 3-6 d (oral preferred over enema, equally effective in studies, less traumatic); maintenance — PEG 0.4-0.8 g/kg/d titrate to soft daily stool × minimum 6 months; behavior modification — scheduled toilet sits 5-10 min after meals (gastrocolic reflex) × 2-3 ครั้ง/วัน, positive reinforcement (sticker chart), foot stool, calm + non-punitive; dietary — increase fiber gradually (age + 5 = grams/d) + adequate water + limit cow milk < 500 mL/d; physical activity; education that this is medical condition + retraining takes months — relapse common; alarm features for further evaluation (FTT, blood, FH Hirschsprung, abnormal anus/neuro) → workup; mental health support if needed

---

Functional constipation = most common kids constipation. Encopresis from retentive behavior + overflow. Rome IV diagnosis. PEG = first-line (oral disimpaction + maintenance). Behavior modification + dietary essential. Long-term commitment, relapse common.', NULL,
  'easy', 'gi', 'review',
  'pediatrics', 'clinical_decision', 'gi', 'peds',
  'NASPGHAN/ESPGHAN Constipation Guidelines 2014; Rome IV', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 4 ปี ถ่ายอุจจาระแข็งทุก 5-7 วัน × 6 เดือน เจ็บขณะถ่าย retentive posturing soiling underwear 3 ครั้ง/wk หลังจาก toilet trained 3 yr ปกติ

Diet: low fiber, picky eating, ดูดนมวัว 1 L/d, น้ำน้อย, no exercise; emotion อาย
PE: palpable stool LLQ + suprapubic, anal exam normal (no fissure, no tag), no neuro deficit, growth normal

No red flags (no delayed meconium, no FTT, no bloody stool)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 7 ปี 2 สัปดาห์ก่อนเป็น URI ตอนนี้ palpable purpura ที่ขา + ก้น + ปวดท้องตื้น ๆ + ปวดข้อเข่า + ข้อเท้า + ปัสสาวะสีเข้ม

V/S: BP 110/72, HR 102, Temp 37.4°C, BW 24 kg
PE: palpable purpura lower extremities + buttocks, no thrombocytopenia, mild knee + ankle effusion

CBC: Plt 384,000 normal, WBC 12,200
UA: RBC 30/HPF, Protein 1+
BUN 14, Cr 0.5, complement normal
ABD US: bowel wall thickening, no intussusception', '[{"label":"A","text":"Bone marrow biopsy"},{"label":"B","text":"IgA Vasculitis (HSP, EULAR/PRINTO/PReS criteria)"},{"label":"C","text":"Aggressive cytotoxic all"},{"label":"D","text":"Discharge no follow"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** IgA Vasculitis (HSP, EULAR/PRINTO/PReS criteria): supportive care most cases (self-limited 4-6 wk, monitor 6 mo); rest + elevate legs + analgesia (NSAID for arthralgia, avoid ถ้า renal involvement); hydration; AVOID activity that could exacerbate purpura; monitor for complications — abdominal pain (intussusception risk 3-4%, usually ileo-ileal — US monitoring), GI bleeding, renal (any presentation — hematuria/proteinuria 30-50% within 4 wk); BP + UA + Cr q1-2 wk × 6 mo (nephritis can be delayed up to 6 mo); corticosteroid (prednisolone 1-2 mg/kg/d) NOT for cutaneous/arthritis (no prevention of nephritis) but consider for severe abdominal pain or rapidly progressive nephritis; ถ้า severe nephritis (nephrotic, RPGN) → MMF, cyclophosphamide, ACEI; recurrence 30%

---

HSP/IgAV = most common pediatric vasculitis. Tetrad: palpable purpura (always), arthritis, abdominal pain, nephritis. Most self-limit. Steroid for severe abdominal pain not skin/joint. Long-term renal follow-up 6 mo (nephritis predictor outcome). Intussusception ileo-ileal.', NULL,
  'medium', 'renal_gu', 'review',
  'pediatrics', 'integrative', 'renal_gu', 'peds',
  'EULAR/PRINTO/PReS Criteria 2010; SHARE Initiative HSP 2019', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 7 ปี 2 สัปดาห์ก่อนเป็น URI ตอนนี้ palpable purpura ที่ขา + ก้น + ปวดท้องตื้น ๆ + ปวดข้อเข่า + ข้อเท้า + ปัสสาวะสีเข้ม

V/S: BP 110/72, HR 102, Temp 37.4°C, BW 24 kg
PE: palpable purpura lower extremities + buttocks, no thrombocytopenia, mild knee + ankle effusion

CBC: Plt 384,000 normal, WBC 12,200
UA: RBC 30/HPF, Protein 1+
BUN 14, Cr 0.5, complement normal
ABD US: bowel wall thickening, no intussusception'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 3 ปี ขาขวาเข่าบวม 6 wk + ตื่นมาขาเกร็ง morning stiffness 30 นาที + เดินขาเขลงเล็กน้อย ไม่มีไข้ ไม่มีรอย rash

V/S ปกติ, BW 14 kg
PE: right knee effusion + warm, slight flexion contracture 10°, no other joint, no rash, no organomegaly

CBC normal, CRP mild elevated, ANA + 1:160 (speckled), RF negative, HLA-B27 negative, anti-CCP negative
XR: soft tissue swelling, no erosion
Ophtho slit lamp: ASYMPTOMATIC anterior uveitis +', '[{"label":"A","text":"Methotrexate IV without ophthalmology evaluation"},{"label":"B","text":"Oligoarticular JIA (≤ 4 joints first 6 mo) + ANA + ที่มี asymptomatic uveitis (high risk especially ANA+ young female)"},{"label":"C","text":"Wait — outgrow"},{"label":"D","text":"Antibiotic"},{"label":"E","text":"Surgery only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Oligoarticular JIA (≤ 4 joints first 6 mo) + ANA + ที่มี asymptomatic uveitis (high risk especially ANA+ young female): NSAID (naproxen 10 mg/kg/dose q12h) first-line for joint inflammation; intra-articular corticosteroid injection (triamcinolone hexacetonide) — effective + can sustain remission joint; methotrexate 10-15 mg/m²/wk PO or SC (preferred SC) ถ้า persistent/polyarticular evolution or uveitis not controlled — both joint + uveitis; for uveitis topical corticosteroid (prednisolone acetate) + mydriatic ophtho-managed; biologic — adalimumab (anti-TNF, best for uveitis) ถ้า uveitis refractory; SCHEDULED slit lamp screen q3 mo × first 4 yr (ANA+ < 7 yr highest risk → high screening frequency); PT + OT; education + activity; long-term: remission 50-75%, uveitis blindness preventable with screening + treatment

---

JIA oligoarticular = most common subtype. Young ANA+ girl = highest uveitis risk → scheduled screen (asymptomatic chronic anterior uveitis = blindness risk). MTX disease-modifying. Adalimumab gold standard for uveitis. PT/OT functional. Screening prevents irreversible vision loss.', NULL,
  'medium', 'signs_symptoms', 'review',
  'pediatrics', 'integrative', 'signs_symptoms', 'peds',
  'ACR/AF Treatment Guideline JIA 2019; AAP Ophthalmologic Screening JIA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 3 ปี ขาขวาเข่าบวม 6 wk + ตื่นมาขาเกร็ง morning stiffness 30 นาที + เดินขาเขลงเล็กน้อย ไม่มีไข้ ไม่มีรอย rash

V/S ปกติ, BW 14 kg
PE: right knee effusion + warm, slight flexion contracture 10°, no other joint, no rash, no organomegaly

CBC normal, CRP mild elevated, ANA + 1:160 (speckled), RF negative, HLA-B27 negative, anti-CCP negative
XR: soft tissue swelling, no erosion
Ophtho slit lamp: ASYMPTOMATIC anterior uveitis +'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกเดิม preterm GA 26 wk BW 700 g ตอนนี้อายุ corrected gestational 36 wk (postnatal age 10 wk) ยังต้องการ O2 supplemental 28% via nasal cannula (FiO2 ≥ 0.21 + > 28 d cumulative oxygen need); CXR: hyperinflation + cystic changes

Feed full enteral, growing slowly, no acute illness
Echo: mild pulmonary HT', '[{"label":"A","text":"Discontinue O2 immediately"},{"label":"B","text":"Bronchopulmonary Dysplasia (Moderate-Severe per NIH 2018 criteria"},{"label":"C","text":"High-dose steroid week 1"},{"label":"D","text":"Restrict calories"},{"label":"E","text":"Discharge no follow-up"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bronchopulmonary Dysplasia (Moderate-Severe per NIH 2018 criteria — O2 + GA 36 wk PMA): optimize ventilation + O2 (target SpO2 90-95%, avoid hyperoxia); high-calorie nutrition (target 130-150 kcal/kg/d) + protein-fortified human milk + multivitamin; cautious fluid (avoid overload); diuretic (furosemide intermittent or thiazide + spironolactone) selected ถ้า worsening pulmonary edema or HT; bronchodilator (inhaled albuterol) selected ถ้า reversible airway obstruction; systemic corticosteroid (DART low-dose dexamethasone) controversial — only for ventilator-dependent BPD (consider risk neurodevelopmental); inhaled corticosteroid mixed evidence; immunizations + RSV palivizumab prophylaxis (high risk); home O2 wean by oximetry; early intervention developmental services; treat pulmonary HT (sildenafil); ophtho + audio + neurodevelopmental follow-up; long-term: improve pulmonary function over years but increased asthma + reduced exercise tolerance

---

BPD = chronic lung disease premature infants. NIH 2018 criteria. Multifactorial — surfactant deficient, oxygen toxicity, volutrauma, infection, inflammation. Nutritional + O2 + judicious diuretics + RSV prophylaxis. Long-term respiratory + neurodevelopmental follow-up.', NULL,
  'medium', 'respiratory', 'review',
  'pediatrics', 'basic_science', 'respiratory', 'peds',
  'AAP COFN; NIH BPD Workshop 2018 (Higgins RD)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกเดิม preterm GA 26 wk BW 700 g ตอนนี้อายุ corrected gestational 36 wk (postnatal age 10 wk) ยังต้องการ O2 supplemental 28% via nasal cannula (FiO2 ≥ 0.21 + > 28 d cumulative oxygen need); CXR: hyperinflation + cystic changes

Feed full enteral, growing slowly, no acute illness
Echo: mild pulmonary HT'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารก term DOL 2 BW 2,800 g แม่ใช้ methadone 80 mg/d ตลอด pregnancy ทารกตื่นกลางคืน irritable + high-pitched cry + tremor + sweating + sneezing + feeding difficulty + loose stool

Finnegan score 12 (moderate-severe, > 8 = treatment threshold ที่ 3 consecutive scores)
Vitals stable
No signs sepsis, no jaundice severe', '[{"label":"A","text":"Discharge home with mother"},{"label":"B","text":"Neonatal Abstinence Syndrome (NAS, opioid exposure)"},{"label":"C","text":"Naloxone routinely"},{"label":"D","text":"Restrict breastfeeding"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neonatal Abstinence Syndrome (NAS, opioid exposure) — utilize Eat, Sleep, Console (ESC) function-based approach (newer, reduces pharmacotherapy + LOS) OR Finnegan score; non-pharmacologic FIRST — swaddling, low stimulation environment, dim lighting, calm room, breastfeeding promotion (allowed in methadone/buprenorphine), skin-to-skin, on-demand feeds, small frequent, hypercaloric formula ถ้า not breastfeeding; pharmacotherapy ถ้า non-pharm fails — morphine 0.04 mg/kg q3-4h titrate (or methadone or buprenorphine sublingual, recent buprenorphine sublingual showing shorter treatment); clonidine adjunct/monotherapy non-opioid; phenobarbital ถ้า polysubstance; observe minimum 4-7 d for opioid (longer for methadone 5-7 d); discharge — child welfare/social work involvement, follow-up 1-2 wk, ophtho + auditory + developmental, breastfeeding support, naloxone training, address maternal substance use disorder + mental health

---

NAS rising incidence (opioid epidemic). Non-pharm first (ESC model = function-based, less pharm + LOS, AAP endorsed). Morphine or methadone first-line pharm. Breastfeeding allowed in methadone/buprenorphine — recommended. Address maternal SUD.', NULL,
  'medium', 'psych_behavior', 'review',
  'pediatrics', 'basic_science', 'psych_behavior', 'peds',
  'AAP Clinical Report on NAS 2020; ESC Approach Grossman 2017', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารก term DOL 2 BW 2,800 g แม่ใช้ methadone 80 mg/d ตลอด pregnancy ทารกตื่นกลางคืน irritable + high-pitched cry + tremor + sweating + sneezing + feeding difficulty + loose stool

Finnegan score 12 (moderate-severe, > 8 = treatment threshold ที่ 3 consecutive scores)
Vitals stable
No signs sepsis, no jaundice severe'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 14 ปี ขณะยืน assembly เช้า > 30 นาที + ร้อน + อดอาหาร feeling lightheaded + nausea + visual gray-out → faints to ground 5 sec then rapid recovery, อาเจียนเล็กน้อย

V/S after: HR 78, BP 110/72 (no orthostatic later), Temp normal
PE: normal, no neuro deficit, no murmur

ECG: sinus, QTc 410 ms normal, normal axis + intervals
Hx: family no sudden death, no syncope with exercise, no chest pain', '[{"label":"A","text":"Implant pacemaker"},{"label":"B","text":"Vasovagal (neurocardiogenic) Syncope (clinical Dx + reassuring features)"},{"label":"C","text":"Cardiac catheterization"},{"label":"D","text":"Antiarrhythmic"},{"label":"E","text":"Discharge no instruction"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Vasovagal (neurocardiogenic) Syncope (clinical Dx + reassuring features): reassurance — common benign in adolescents (15% age 15); identify + avoid triggers (prolonged standing, hot environment, dehydration, fasting, fear/pain, blood/needles, micturition); preventive — increase fluid 2-3 L/d + salt liberalization 6-10 g/d (low sodium common adolescents); counterpressure maneuvers (leg crossing, fist clenching, squat) when prodromal; AVOID prolonged standing/hot/skip meals; postural changes slowly; education about prodrome — sit/lie immediately; ECG normal sufficient most cases (no need echo/MRI/tilt table routinely if classic features + normal ECG + no red flags); RED FLAGS for cardiac syncope warranting workup: exertional, no prodrome, supine, family Hx SCD, chest pain, palpitation, prolonged QT, structural heart disease — refer cardiology; refractory → midodrine, fludrocortisone, beta blocker controversial

---

Vasovagal = most common syncope adolescents. Diagnosis clinical with classic prodrome + triggers + reassuring exam/ECG. Red flags = cardiac eval. Lifestyle (fluid/salt/avoid trigger) effective most. Pharmacology rarely needed. AAP/AHA: ECG initial; further testing only if red flags.', NULL,
  'easy', 'cardiovascular', 'review',
  'pediatrics', 'clinical_decision', 'cardiovascular', 'peds',
  'AHA/ACC/HRS Syncope Guideline 2017; Pediatric Heart Network', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 14 ปี ขณะยืน assembly เช้า > 30 นาที + ร้อน + อดอาหาร feeling lightheaded + nausea + visual gray-out → faints to ground 5 sec then rapid recovery, อาเจียนเล็กน้อย

V/S after: HR 78, BP 110/72 (no orthostatic later), Temp normal
PE: normal, no neuro deficit, no murmur

ECG: sinus, QTc 410 ms normal, normal axis + intervals
Hx: family no sudden death, no syncope with exercise, no chest pain'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 15 ปี (BW 50 kg) กิน Tylenol 50 เม็ด (500 mg/tablet = 25 g, 500 mg/kg) 4 ชม ก่อน หลังทะเลาะ ตอนนี้คลื่นไส้อาเจียน หลังกิน 90 นาทีให้ activated charcoal ไม่ได้ (ไม่ใช่ ED)

V/S: HR 102, BP 116/78, RR 18, SpO2 99%, Temp 37.0°C
Gen: alert, no jaundice yet

4-hr acetaminophen level: 240 mcg/mL (Rumack-Matthew nomogram = above ''probable hepatotoxicity'' line)
LFT: AST 32, ALT 38 (still normal), INR 1.0, Cr 0.7
Glucose 92, no other co-ingestion', '[{"label":"A","text":"Observe + recheck 12 hr"},{"label":"B","text":"Acetaminophen toxicity (above treatment line at 4 hr)"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Flumazenil"},{"label":"E","text":"Naloxone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acetaminophen toxicity (above treatment line at 4 hr): N-Acetylcysteine (NAC) — IV protocol (preferred for hepatic concern): 150 mg/kg in 200 mL D5W over 60 min, then 50 mg/kg in 500 mL D5W over 4 hr, then 100 mg/kg in 1 L D5W over 16 hr (total 21 hr, 300 mg/kg cumulative); may extend if persistent injury at end of standard course (LFT or APAP still detectable); monitor for anaphylactoid reaction during infusion (slow rate, antihistamine) — true allergy rare; alternative oral PO NAC 140 mg/kg loading then 70 mg/kg q4h × 17 doses (less preferred when vomiting); transfer to liver transplant center if King''s College criteria positive (pH < 7.3, INR > 6.5, Cr > 3.4, Stage III encephalopathy); supportive — fluids, electrolytes, antiemetic ondansetron; psychiatric eval after stabilization (this is suicide attempt); social work + safety plan + lethal means restriction

---

Acetaminophen = leading cause acute liver failure US/UK. Rumack-Matthew nomogram (4-24 hr) guides NAC need. NAC effective if < 8-10 hr. IV NAC standard 21-hr regimen. King''s College criteria for transplant. Psychiatric eval mandatory after intentional ingestion (lethal means + safety).', NULL,
  'hard', 'psych_behavior', 'review',
  'pediatrics', 'ems_mgmt', 'psych_behavior', 'peds',
  'AACT/EAPCCT Position Paper Acetaminophen 2014; Rumack-Matthew Nomogram', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 15 ปี (BW 50 kg) กิน Tylenol 50 เม็ด (500 mg/tablet = 25 g, 500 mg/kg) 4 ชม ก่อน หลังทะเลาะ ตอนนี้คลื่นไส้อาเจียน หลังกิน 90 นาทีให้ activated charcoal ไม่ได้ (ไม่ใช่ ED)

V/S: HR 102, BP 116/78, RR 18, SpO2 99%, Temp 37.0°C
Gen: alert, no jaundice yet

4-hr acetaminophen level: 240 mcg/mL (Rumack-Matthew nomogram = above ''probable hepatotoxicity'' line)
LFT: AST 32, ALT 38 (still normal), INR 1.0, Cr 0.7
Glucose 92, no other co-ingestion'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 2 ปี BW 12 kg พบเปิดขวด adult prenatal vitamin iron 80 mg/tablet กิน 30 เม็ด (2,400 mg = 200 mg/kg elemental iron — ในขวด FeSO4 elemental ≈ 65 mg/tablet = ~108 mg/kg) 2 ชม ก่อน อาเจียนหลายครั้ง bloody, lethargic

V/S: HR 168, BP 78/40, RR 38, SpO2 96%, BW 12 kg
Gen: lethargic, abdominal tenderness, vomiting, melena

ABG: pH 7.20, HCO3 12 (high AGMA), lactate 8
Serum iron 1,200 mcg/dL (4 hr level — toxic > 500), AST 240, ALT 180
AXR: radiopaque tablets in stomach + small bowel', '[{"label":"A","text":"Activated charcoal"},{"label":"B","text":"Severe Iron Toxicity (ingestion > 60 mg/kg elemental, peak 4-6 hr, serum > 500 mcg/dL or symptoms)"},{"label":"C","text":"Outpatient observation"},{"label":"D","text":"Naloxone"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe Iron Toxicity (ingestion > 60 mg/kg elemental, peak 4-6 hr, serum > 500 mcg/dL or symptoms): activated charcoal NOT effective (doesn''t bind iron); GI decontamination — whole bowel irrigation with PEG-electrolyte solution (25-40 mL/kg/hr via NG) if tablets visible on KUB + significant ingestion; gastric lavage controversial selective; aggressive IV crystalloid resuscitation (large losses GI + 3rd space + capillary leak); IV Deferoxamine chelation — 15 mg/kg/hr IV continuous infusion (max 6 g/24 hr) when serum iron > 500, severe symptoms, metabolic acidosis, or shock; classic ''vin rose'' urine indicates chelation; continue until clinical improvement, serum iron < 350, urine returns clear, acidosis resolved (typically 24 hr); side effects deferoxamine — hypotension (slow rate), pulmonary toxicity, anaphylactoid; correct acidosis, glucose, coagulopathy; LFT monitoring; ICU admission; child safety — accidental childproof packaging counseling

---

Iron = leading cause peds poisoning death (historically). Stages: GI (0-6 hr), latent (6-24), shock/metabolic (12-48), hepatotoxicity (2-5 d), late scarring (4-6 wk). > 60 mg/kg = toxic, > 500 mcg/dL serum = severe. Deferoxamine for severe. Charcoal ineffective. WBI for radiopaque pills. Childproof packaging.', NULL,
  'hard', 'gi', 'review',
  'pediatrics', 'ems_mgmt', 'gi', 'peds',
  'AACT/EAPCCT Position Paper Iron Toxicity; Tintinalli Emergency Medicine', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 2 ปี BW 12 kg พบเปิดขวด adult prenatal vitamin iron 80 mg/tablet กิน 30 เม็ด (2,400 mg = 200 mg/kg elemental iron — ในขวด FeSO4 elemental ≈ 65 mg/tablet = ~108 mg/kg) 2 ชม ก่อน อาเจียนหลายครั้ง bloody, lethargic

V/S: HR 168, BP 78/40, RR 38, SpO2 96%, BW 12 kg
Gen: lethargic, abdominal tenderness, vomiting, melena

ABG: pH 7.20, HCO3 12 (high AGMA), lactate 8
Serum iron 1,200 mcg/dL (4 hr level — toxic > 500), AST 240, ALT 180
AXR: radiopaque tablets in stomach + small bowel'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 6 ปี known severe Hemophilia A (factor VIII < 1%) สะดุดตกบันได 4 ชม ก่อน อาเจียน 2 ครั้ง ปวดศีรษะ + ง่วงซึม + walk unsteady

V/S: HR 92, BP 110/72, GCS 14 (E4V4M6), pupil R 4 mm sluggish, L 3 mm reactive

CT brain: small (1.5 cm) subdural hematoma right frontoparietal, no midline shift, no mass effect
No previous inhibitor', '[{"label":"A","text":"Wait + observe before factor replacement"},{"label":"B","text":"Severe Hemophilia A with intracranial bleed (life-threatening = highest priority)"},{"label":"C","text":"Aspirin"},{"label":"D","text":"Surgery without factor first"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe Hemophilia A with intracranial bleed (life-threatening = highest priority): IMMEDIATE Factor VIII replacement BEFORE any imaging if strongly suspected ICH (history alone enough — clinical context > confirmatory imaging delay); dose for major/CNS bleed — Factor VIII 50 IU/kg IV bolus (target factor level 100%, formula: 1 IU/kg raises factor by 2%), then continuous infusion 3-4 IU/kg/hr OR q8-12h dosing to maintain trough 50-100% × 14 days for CNS bleed; admit pediatric ICU + neurosurgery consultation; serial neuro exams + repeat CT; AVOID NSAIDs, antiplatelets, IM injection; if inhibitor present → bypassing agents — rFVIIa 90-120 mcg/kg q2-3h OR FEIBA 50-100 IU/kg q6-12h; emicizumab not for acute bleed treatment (prophylaxis only); long-term prophylaxis emicizumab subQ q1-2 wk if not already; comprehensive hemophilia center; PT/OT post-recovery; education + medical alert; counsel about activity

---

Hemophilia + suspected ICH = factor replacement BEFORE imaging (don''t delay). Target 100% for CNS bleed, maintain 50-100% × 14 d. WFH 2020 guideline. Inhibitor → bypassing agents (rFVIIa, FEIBA). Emicizumab = prophylaxis only. Comprehensive care center coordination.', NULL,
  'hard', 'hematology', 'review',
  'pediatrics', 'clinical_decision', 'hematology', 'peds',
  'WFH Guidelines for the Management of Hemophilia 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 6 ปี known severe Hemophilia A (factor VIII < 1%) สะดุดตกบันได 4 ชม ก่อน อาเจียน 2 ครั้ง ปวดศีรษะ + ง่วงซึม + walk unsteady

V/S: HR 92, BP 110/72, GCS 14 (E4V4M6), pupil R 4 mm sluggish, L 3 mm reactive

CT brain: small (1.5 cm) subdural hematoma right frontoparietal, no midline shift, no mass effect
No previous inhibitor'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 4 ปี ซีดเรื้อรัง ตั้งแต่อายุ 6 mo, ต้องได้ blood transfusion ทุก 3-4 wk ตับโต ม้ามโต face thalassemic ''chipmunk'' frontal bossing maxillary prominence

Family: parents both beta-thalassemia trait
Hb electrophoresis: HbF 92%, HbA2 elevated, no HbA = beta-thalassemia major

Current Hb 6.8 (pre-transfusion), ferritin 1,200 (rising 1 yr post-transfusion), Hb 9.2 post-transfusion baseline
Growth chart < 3rd percentile', '[{"label":"A","text":"No transfusion needed"},{"label":"B","text":"Beta-Thalassemia Major (Cooley anemia)"},{"label":"C","text":"Splenectomy mandatory all"},{"label":"D","text":"Iron supplement"},{"label":"E","text":"Discharge no follow-up"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Beta-Thalassemia Major (Cooley anemia) — comprehensive care: hypertransfusion regimen — PRBC q3-4 wk maintain pre-transfusion Hb 9-10.5 g/dL (suppresses endogenous erythropoiesis → reduces extramedullary hematopoiesis + skeletal deformity + improves growth/quality of life); iron chelation MANDATORY once cumulative transfusion ≥ 20 units OR ferritin > 1,000 — deferasirox PO 14-28 mg/kg/d OR deferoxamine SC 8-12 hr × 5 nights/wk OR deferiprone PO TID; baseline + annual cardiac MRI T2* (iron-induced cardiomyopathy = leading death), liver MRI; endocrine — growth, puberty, thyroid, parathyroid, gonadal, glucose monitor + treat; bone density + osteoporosis prophylaxis; folate supplement; immunizations including pneumococcal/meningococcal/Hib (functional asplenia if splenectomy); HCV screening (transfusion); HSCT = potentially curative (HLA-matched sibling preferred, age < 14); gene therapy (lentiviral lovo-cel, CRISPR exa-cel) FDA-approved emerging curative; counseling family for siblings; psychosocial support; transition adult care

---

Beta-thal major = severe transfusion-dependent. Hypertransfusion + iron chelation cornerstones. Iron overload = cardiac/endocrine/liver toxicity. Cardiac MRI T2* monitors. HSCT curative. Gene therapy emerging (exa-cel, lovo-cel). Comprehensive care.', NULL,
  'medium', 'hematology', 'review',
  'pediatrics', 'basic_science', 'hematology', 'peds',
  'TIF Guidelines for Management of Transfusion-Dependent Thalassemia 2021', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 4 ปี ซีดเรื้อรัง ตั้งแต่อายุ 6 mo, ต้องได้ blood transfusion ทุก 3-4 wk ตับโต ม้ามโต face thalassemic ''chipmunk'' frontal bossing maxillary prominence

Family: parents both beta-thalassemia trait
Hb electrophoresis: HbF 92%, HbA2 elevated, no HbA = beta-thalassemia major

Current Hb 6.8 (pre-transfusion), ferritin 1,200 (rising 1 yr post-transfusion), Hb 9.2 post-transfusion baseline
Growth chart < 3rd percentile'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 4 ปี ไข้ + ปวดศีรษะ + สับสน 3 วัน + ชัก focal right side × 5 นาที × 2 ครั้ง วันนี้

V/S: HR 132, BP 108/70, RR 24, SpO2 96%, Temp 39.4°C, BW 16 kg
Gen: lethargic, GCS 12, no neck stiffness obvious, occasional focal twitches right face

CT brain: temporal lobe hypodensity bilateral (R > L) + edema
MRI brain: temporal lobe T2/FLAIR hyperintensity bilateral asymmetric + cingulate involvement
LP: WBC 250 (lymphocyte 80%), Protein 95, Glucose 56 (normal), RBC 850 (! suggests hemorrhagic temporal lobe)
CSF HSV PCR: pending
EEG: PLEDs (periodic lateralized epileptiform discharges) right temporal', '[{"label":"A","text":"Wait for PCR before treatment"},{"label":"B","text":"HSV Encephalitis (classic features"},{"label":"C","text":"Steroid alone"},{"label":"D","text":"Antibiotic only"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** HSV Encephalitis (classic features — temporal lobe, hemorrhagic, focal seizure, PLEDs) = empirically treat IMMEDIATELY (don''t wait PCR — delay = worse outcome): IV Acyclovir 60 mg/kg/d ÷ q8h (20 mg/kg/dose) × 14-21 days (peds higher dose than adult); ensure adequate hydration to prevent crystalline nephrotoxicity (renal monitoring + good UO); seizure management — load levetiracetam or fosphenytoin + ongoing maintenance; ICU monitoring + airway protection; treat increased ICP (head-up, mannitol, hypertonic saline) if signs; repeat LP at end of treatment with HSV PCR (negative before stop); EEG monitoring; AVOID delay — HSE has 70% mortality untreated, < 30% with treatment; counsel family — neurological sequelae common (memory, seizure, behavioral, cognitive); long-term neuro + neuropsych + epilepsy follow-up; family education home seizure plan

---

HSV encephalitis = most common sporadic encephalitis, treatable. Temporal lobe involvement + focal seizure + PLEDs + hemorrhagic = classic. Empiric acyclovir EARLY = standard (mortality 70 → 20% with treatment). 14-21 d treatment + repeat LP. Long-term neuro sequelae common.', NULL,
  'hard', 'id', 'review',
  'pediatrics', 'clinical_decision', 'id', 'peds',
  'IDSA Encephalitis Guideline 2008; Tunkel CID 2008', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 4 ปี ไข้ + ปวดศีรษะ + สับสน 3 วัน + ชัก focal right side × 5 นาที × 2 ครั้ง วันนี้

V/S: HR 132, BP 108/70, RR 24, SpO2 96%, Temp 39.4°C, BW 16 kg
Gen: lethargic, GCS 12, no neck stiffness obvious, occasional focal twitches right face

CT brain: temporal lobe hypodensity bilateral (R > L) + edema
MRI brain: temporal lobe T2/FLAIR hyperintensity bilateral asymmetric + cingulate involvement
LP: WBC 250 (lymphocyte 80%), Protein 95, Glucose 56 (normal), RBC 850 (! suggests hemorrhagic temporal lobe)
CSF HSV PCR: pending
EEG: PLEDs (periodic lateralized epileptiform discharges) right temporal'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 18 เดือน 3rd febrile UTI ใน 6 mo (E. coli ทั้งหมด) ระหว่าง episodes ดีปกติ

VCUG: bilateral Grade IV VUR (gross dilation ureter + pelvis + calyces with blunting of fornices)
DMSA: small focal scarring left kidney
Renal US: hydronephrosis bilateral mild-moderate
BP normal, growth normal, no neurogenic bladder', '[{"label":"A","text":"No intervention needed"},{"label":"B","text":"Bilateral high-grade VUR with breakthrough UTIs + scarring"},{"label":"C","text":"Immediate kidney transplant"},{"label":"D","text":"Discharge no follow-up"},{"label":"E","text":"Chronic high-dose ibuprofen"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bilateral high-grade VUR with breakthrough UTIs + scarring: continuous antibiotic prophylaxis (CAP) — trimethoprim-sulfamethoxazole 2-3 mg/kg/d trimethoprim OR nitrofurantoin 1-2 mg/kg/d at bedtime (reduces febrile UTI; RIVUR trial 50% reduction); manage voiding dysfunction + constipation aggressively (treat any bowel-bladder dysfunction); monitor — annual US + selective DMSA, BP, growth; recheck VCUG 12-24 mo (resolution rate decreases with higher grade — Grade IV ~30-40% resolve); surgical or endoscopic correction (subureteral injection Deflux, ureteral reimplantation) considered if: breakthrough infection on CAP, progressive scarring, parental preference, persistent high-grade after age 5-6, non-compliance; long-term: BP, proteinuria, renal function monitoring (risk CKD, HT, pregnancy complication); patient + family education + voiding hygiene

---

VUR + recurrent febrile UTI + scarring = treat. AAP/AUA: CAP for selected high-grade VUR + recurrent UTI (RIVUR trial). Address bowel-bladder dysfunction. Surgical/endoscopic for breakthrough/persistent. Long-term renal/BP follow-up. Voiding habits matter.', NULL,
  'medium', 'renal_gu', 'review',
  'pediatrics', 'integrative', 'renal_gu', 'peds',
  'AAP/AUA Guideline VUR 2010 (updated); RIVUR Trial NEJM 2014', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 18 เดือน 3rd febrile UTI ใน 6 mo (E. coli ทั้งหมด) ระหว่าง episodes ดีปกติ

VCUG: bilateral Grade IV VUR (gross dilation ureter + pelvis + calyces with blunting of fornices)
DMSA: small focal scarring left kidney
Renal US: hydronephrosis bilateral mild-moderate
BP normal, growth normal, no neurogenic bladder'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกชายแรกเกิด term BW 3,200 g พบ urethral meatus opening ที่ ventral surface penis (mid-shaft) + ventral curvature (chordee) + hooded foreskin (dorsal incomplete)

ไม่มี ambiguous genitalia, scrotum normal, testes palpable bilateral descended
No other dysmorphism, normal fontanelle, normal exam อื่น', '[{"label":"A","text":"Circumcise routinely at 1 wk"},{"label":"B","text":"Mid-shaft Hypospadias with chordee"},{"label":"C","text":"Surgery at age 10"},{"label":"D","text":"Hormone alone"},{"label":"E","text":"Discharge no follow-up"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mid-shaft Hypospadias with chordee — DO NOT circumcise (foreskin needed for surgical repair); pediatric urology referral; surgical repair typically 6-18 months of age (single or staged tubularized incised plate, urethroplasty); pre-op assessment — rule out DSD if also undescended testes or ambiguous genitalia (karyotype + endo workup); post-op care: stent/catheter management, antibiotic prophylaxis, follow-up complications (fistula 5-15%, meatal stenosis, dehiscence); counsel family — cosmetic + functional good results, ongoing follow-up to puberty; psychosocial support; school + adolescent transition counseling

---

Hypospadias = ~1 in 200-300 male births. Severity by meatal position. AVOID circumcision (foreskin for repair). Repair 6-18 mo. Pediatric urology. Rule out DSD if bilateral cryptorchidism or ambiguous. Excellent outcomes most.', NULL,
  'easy', 'renal_gu', 'review',
  'pediatrics', 'basic_science', 'renal_gu', 'peds',
  'AAP Section on Urology; EAU Pediatric Urology Guidelines 2024', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกชายแรกเกิด term BW 3,200 g พบ urethral meatus opening ที่ ventral surface penis (mid-shaft) + ventral curvature (chordee) + hooded foreskin (dorsal incomplete)

ไม่มี ambiguous genitalia, scrotum normal, testes palpable bilateral descended
No other dysmorphism, normal fontanelle, normal exam อื่น'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกชายอายุ 9 เดือน term, BW 4 kg (เกิด 3.5 kg) มา check up พบ right testis อยู่ใน inguinal canal palpable but undescended ไม่สามารถดึงลง scrotum left testis ปกติใน scrotum

ไม่มี hypospadias, ไม่มี ambiguous genitalia, normal phallus length
No previous descent attempted
US confirms right testis in inguinal canal', '[{"label":"A","text":"Wait until puberty"},{"label":"B","text":"Cryptorchidism (undescended testis)"},{"label":"C","text":"hCG injection only"},{"label":"D","text":"Discharge — outgrow"},{"label":"E","text":"Chemotherapy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cryptorchidism (undescended testis): natural descent rare after 6 mo of age — refer pediatric urology for surgical management; orchiopexy recommended ที่อายุ 6-18 months (optimal window before age 1 yr per AUA 2014 + EAU); surgery — open inguinal vs laparoscopic (impalpable testes); benefits early orchiopexy — better fertility (preserve germ cells), easier examination for malignancy (testicular cancer 4-10× elevated risk vs general — surveillance lifelong), normal growth; hormonal therapy hCG/GnRH analogues NOT recommended first-line (low success + side effects); if impalpable bilateral testes + < 3 mo old + signs of virilization → URGENT endocrine + DSD workup (CAH karyotype 46,XX masculinized); counsel — lifelong testicular self-exam; semen analysis later in life if needed; address comorbid inguinal hernia (often coexistent)

---

Cryptorchidism ~3% term, ~30% preterm. Natural descent first 6 mo. Orchiopexy 6-18 mo optimal — reduces infertility + cancer risk. Hormonal therapy not first-line. Bilateral impalpable = endo + DSD workup. Lifelong cancer surveillance.', NULL,
  'medium', 'renal_gu', 'review',
  'pediatrics', 'basic_science', 'renal_gu', 'peds',
  'AUA Guideline Cryptorchidism 2014; EAU Pediatric Urology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกชายอายุ 9 เดือน term, BW 4 kg (เกิด 3.5 kg) มา check up พบ right testis อยู่ใน inguinal canal palpable but undescended ไม่สามารถดึงลง scrotum left testis ปกติใน scrotum

ไม่มี hypospadias, ไม่มี ambiguous genitalia, normal phallus length
No previous descent attempted
US confirms right testis in inguinal canal'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 6 ปี ไข้สูง 40°C + ปวดเมื่อยกล้ามเนื้อ + ไอ + หอบเหนื่อย 2 วัน + อาเจียน เริ่มหอบเหนื่อยมากขึ้น 6 ชม ก่อนมา ED

V/S: HR 152, BP 92/58, RR 48, SpO2 88% room air, Temp 39.6°C, BW 22 kg
Gen: alert but distress, accessory muscle use, bilateral crackles

Rapid Influenza A positive (H1N1); CXR: bilateral interstitial infiltrate + RLL consolidation
CBC: WBC 4,200 (lymphopenia)
Community outbreak Influenza A current', '[{"label":"A","text":"Bronchodilator only"},{"label":"B","text":"Severe Influenza pneumonia (high-risk + hospitalization criteria)"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Aspirin"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe Influenza pneumonia (high-risk + hospitalization criteria): IV Oseltamivir 3 mg/kg/dose q12h × 5 days (start as soon as suspect, best within 48 hr but still benefit later in severe disease); admit + O2 support to SpO2 ≥ 92%; supportive — fluid management, antipyretic; consider concurrent bacterial superinfection (Strep pneumo, Staph aureus including MRSA, GAS) — empiric ceftriaxone + vancomycin if persistent fever, worsening, lobar consolidation, leukocytosis; ICU + HFNC/CPAP/intubation if severe respiratory failure; ECMO selected; isolation droplet + standard precautions; chemoprophylaxis household + close contacts at high risk (immunocompromised, < 5 yr, pregnant, chronic illness) — oseltamivir 1× daily × 7-10 d; influenza vaccine annually (best prevention); avoid aspirin (Reye syndrome); long-term: counsel post-influenza pneumonia surveillance

---

Severe influenza = hospitalize. Oseltamivir within 48 hr ideal but benefit even later in severe. Watch bacterial superinfection (Staph especially). Annual vaccination prevention. Reye syndrome — no aspirin. Chemoprophylaxis household high-risk.', NULL,
  'medium', 'respiratory', 'review',
  'pediatrics', 'clinical_decision', 'respiratory', 'peds',
  'AAP Influenza Recommendations 2024-2025; IDSA Influenza Guideline 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 6 ปี ไข้สูง 40°C + ปวดเมื่อยกล้ามเนื้อ + ไอ + หอบเหนื่อย 2 วัน + อาเจียน เริ่มหอบเหนื่อยมากขึ้น 6 ชม ก่อนมา ED

V/S: HR 152, BP 92/58, RR 48, SpO2 88% room air, Temp 39.6°C, BW 22 kg
Gen: alert but distress, accessory muscle use, bilateral crackles

Rapid Influenza A positive (H1N1); CXR: bilateral interstitial infiltrate + RLL consolidation
CBC: WBC 4,200 (lymphopenia)
Community outbreak Influenza A current'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 16 ปี มาคลินิก ขอคุมกำเนิด มี sexual activity 6 mo unprotected ครั้ง bf ใช้ withdrawal เคยขาดประจำเดือน 2 mo (UPT neg, MIA normal cycles since)

BP 116/72, BMI 22, no contraindication migraine with aura, no smoking, no DVT Hx, no breast/cervical cancer family
No current STI symptoms; agrees to STI screen', '[{"label":"A","text":"Don''t discuss"},{"label":"B","text":"Adolescent contraception counseling (confidential, evidence-based per AAP/ACOG)"},{"label":"C","text":"Refuse counseling"},{"label":"D","text":"Only abstinence"},{"label":"E","text":"Force parental consent"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Adolescent contraception counseling (confidential, evidence-based per AAP/ACOG): assess preferences + medical eligibility (CDC US-MEC 2024); ALL options + LARC = first-line offer per AAP — most effective, top-tier (IUD copper or LNG, etonogestrel implant); etonogestrel implant Nexplanon — most effective adolescent option (failure < 1%, 3 yr), reversible, no estrogen, can use breastfeeding; LNG-IUD or copper IUD — also top-tier, > 99% effective, 3-12 yr depending on type, can place in adolescents per ACOG; tier 2: DMPA injection q3 mo (bone density caution, weight gain), combined oral contraceptive pill, patch, ring (need adherence); always counsel about STI prevention — condoms PLUS LARC (dual protection); emergency contraception availability (ulipristal, LNG, copper IUD); screen + offer STI testing (chlamydia/gonorrhea, HIV, syphilis, hepatitis B); Pap smear start 21 yr; HPV vaccination; preventive counseling — alcohol/drug, mental health, safety; confidentiality unless harm to self/others

---

AAP/ACOG: confidential adolescent contraception counseling. LARC (implant, IUD) = first-line (most effective). Dual protection (LARC + condom) for STI. CDC US-MEC for safety. STI screening + HPV vaccine + mental health screen. Confidentiality (varies by state).', NULL,
  'medium', 'renal_gu', 'review',
  'pediatrics', 'integrative', 'renal_gu', 'peds',
  'AAP Clinical Report on Contraception for Adolescents 2014; ACOG Committee Opinion; CDC US-MEC 2024', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 16 ปี มาคลินิก ขอคุมกำเนิด มี sexual activity 6 mo unprotected ครั้ง bf ใช้ withdrawal เคยขาดประจำเดือน 2 mo (UPT neg, MIA normal cycles since)

BP 116/72, BMI 22, no contraindication migraine with aura, no smoking, no DVT Hx, no breast/cervical cancer family
No current STI symptoms; agrees to STI screen'
  );

commit;

