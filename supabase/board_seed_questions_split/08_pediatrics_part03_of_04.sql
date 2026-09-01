-- ===============================================================
-- หมอรู้ — Board seed: กุมารเวชศาสตร์ (pediatrics) — part 3/4 (50 MCQs)
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
  s.id, 'board', NULL, 'เด็กหญิงอายุ 5 ปี แม่พามาเพราะเด็กเล่าว่า ''ลุงเอาของแข็งเข้าไป'' 2 วันก่อน + dysuria + ปัสสาวะมีเลือด เคยปกติมาก่อน

V/S ปกติ, BW 18 kg
PE: anogenital exam — vaginal redness + small laceration introitus + bleeding scant + perianal bruise (yellow-green = > 24h) — no other PE injury

Affect: child anxious, avoids eye contact, hesitant to speak; mother appropriate concern, brought immediately', '[{"label":"A","text":"Discharge — wait + see"},{"label":"B","text":"Suspected Acute Pediatric Sexual Abuse (recent < 72 hr"},{"label":"C","text":"Don''t report"},{"label":"D","text":"Discharge no eval"},{"label":"E","text":"Confront alleged perpetrator"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Suspected Acute Pediatric Sexual Abuse (recent < 72 hr — forensic evidence window) — multidisciplinary urgent response: ENSURE child safety FIRST (do not leave with potential abuser, may need protective custody temporary), keep child with trusted caregiver; mandated reporter — IMMEDIATE report to child protective services (CPS) + law enforcement (legally required, even suspicion = report, no delay); refer to Child Advocacy Center / SANE-Pediatric trained provider for forensic medical evaluation (limit history-taking + exam to one trained interviewer/examiner to reduce trauma + preserve evidence); forensic evidence collection (rape kit) if within window (72-96 hr varies); STI testing (chlamydia, gonorrhea, trichomonas, syphilis, HIV, HBV, HCV) + pregnancy test if menarche; HIV PEP within 72 hr if indicated (28-d antiretroviral); STI prophylaxis (ceftriaxone + azithromycin + metronidazole for older); emergency contraception if post-menarche; hepatitis B vaccination if not immune; counseling — mental health referral immediate + ongoing trauma-focused CBT; medical follow-up 2-6 wk for STI + counseling; document carefully (verbatim quotes, body diagram, photo if SANE) — chain of custody; AAP Section on Child Maltreatment guideline; multidisciplinary team (medical, mental health, legal, social work)

---

Child sexual abuse = mandatory report (all healthcare providers). Child Advocacy Center coordinated multidisciplinary. Limit re-interviewing (trauma + investigation integrity). Forensic eval + evidence within 72-96 hr. STI/HIV PEP + EC. Trauma-informed care. Long-term mental health. Document carefully.', NULL,
  'hard', 'psych_behavior', 'review',
  'pediatrics', 'integrative', 'psych_behavior', 'peds',
  'AAP Clinical Report on Care of Child Sexual Abuse 2023; APSAC Practice Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 5 ปี แม่พามาเพราะเด็กเล่าว่า ''ลุงเอาของแข็งเข้าไป'' 2 วันก่อน + dysuria + ปัสสาวะมีเลือด เคยปกติมาก่อน

V/S ปกติ, BW 18 kg
PE: anogenital exam — vaginal redness + small laceration introitus + bleeding scant + perianal bruise (yellow-green = > 24h) — no other PE injury

Affect: child anxious, avoids eye contact, hesitant to speak; mother appropriate concern, brought immediately'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกชายอายุ 8 เดือน BW 7.2 kg แม่เล่ากลิ้งจากโซฟา 1 ฟุต ทารกร้องไห้ไม่หยุด 1 ชม alert ตอนนี้

PE: bulging fontanelle, ecchymosis right forehead + retinal hemorrhages bilateral (multiple, dot/blot/flame) + grip mark bruise bilateral upper arms + femoral fracture left + multiple healed rib fractures different ages on incidental CXR

CT: bilateral subdural hematoma + different ages
Development normal; SES low; previous CPS reports for sibling
Mother story changes during interview', '[{"label":"A","text":"Discharge home with reassurance"},{"label":"B","text":"Highly suspicious Non-Accidental Trauma (Abusive Head Trauma / Shaken Baby Syndrome)"},{"label":"C","text":"Discharge"},{"label":"D","text":"Don''t report"},{"label":"E","text":"Send home with abuser"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Highly suspicious Non-Accidental Trauma (Abusive Head Trauma / Shaken Baby Syndrome): triad — retinal hemorrhages + subdural hematomas + cerebral edema/injury — pathognomonic when no other explanation; injuries inconsistent with history (8-mo-old not yet rolling cannot generate force of 1-ft fall to cause SDH/retinal hem/long bone Fx); ENSURE child safety FIRST — admit hospital, do not discharge with caregivers under suspicion, may need emergency protective custody; MANDATORY REPORT immediate to CPS + law enforcement (mandatory reporter — no need certainty, suspicion sufficient); medical evaluation — full skeletal survey (XR of every bone — repeat in 2 wk to detect healing fractures), bilateral ophtho exam dilated by ophthalmologist (document retinal hem), brain MRI for parenchymal/axonal injury, abdominal CT or LFT/amylase/lipase to evaluate occult abdominal trauma, coagulation studies + Cl to rule out bleeding disorder (preserve evidence), Cu/Vit C/Cu deficiency rule out bone disease; consult Child Abuse Pediatrician (board-certified subspecialty) for assessment; multidisciplinary team — social work, mental health, law enforcement, hospital legal; siblings — screen + protect (high risk also); detailed documentation + photo + verbatim quotes (chain of custody); long-term: neurological sequelae 80% (developmental delay, seizure, vision, cognitive); legal proceedings; long-term mental health + developmental services

---

AHT/SBS = leading cause death from child abuse. Triad: SDH + retinal hem + brain injury. History inconsistent with injury = key. Mandatory report. Comprehensive workup (skeletal survey, ophtho, MRI). Sibling protection. Long-term sequelae high. Child abuse pediatrician consultation.', NULL,
  'hard', 'trauma', 'review',
  'pediatrics', 'integrative', 'trauma', 'peds',
  'AAP Clinical Report on Abusive Head Trauma 2020; Child Abuse Pediatric Subspecialty', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกชายอายุ 8 เดือน BW 7.2 kg แม่เล่ากลิ้งจากโซฟา 1 ฟุต ทารกร้องไห้ไม่หยุด 1 ชม alert ตอนนี้

PE: bulging fontanelle, ecchymosis right forehead + retinal hemorrhages bilateral (multiple, dot/blot/flame) + grip mark bruise bilateral upper arms + femoral fracture left + multiple healed rib fractures different ages on incidental CXR

CT: bilateral subdural hematoma + different ages
Development normal; SES low; previous CPS reports for sibling
Mother story changes during interview'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 13 ปี น้ำหนักลด 5 kg ใน 3 mo + ใจสั่น + ทนร้อนไม่ได้ + เหงื่อออก + tremor + irritable + insomnia + ผลการเรียนลด

V/S: HR 122 sinus, BP 138/72, BW 38 kg
PE: diffuse goiter symmetric non-tender, ophthalmopathy mild (mild proptosis + lid retraction), warm moist skin, fine tremor, hyperreflexia

TSH < 0.01, Free T4 4.2 (high), Free T3 12 (high), TSI/TRAb HIGH, anti-TPO + thyroid US: diffuse heterogeneous + increased vascularity', '[{"label":"A","text":"Levothyroxine"},{"label":"B","text":"Graves Disease pediatric"},{"label":"C","text":"Surgery first-line all"},{"label":"D","text":"Discharge no treatment"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Graves Disease pediatric: anti-thyroid drug FIRST-LINE (block + replace or titration) — Methimazole 0.2-0.5 mg/kg/d ÷ 1-2 doses (only PTU during pregnancy 1st trimester due to teratogenicity, methimazole preferred otherwise per AAP/ATA 2016) — duration 1-2 yr trial (remission ~25-30% pediatric — lower than adult); beta-blocker (propranolol 1-2 mg/kg/d ÷ 3-4 doses, max 60 mg/d) for symptomatic relief tachycardia/tremor first 2-4 wk; baseline + monthly LFT + CBC (rare agranulocytosis, hepatotoxicity — discontinue + alternative if occur); periodic TSH + Free T4 + Free T3 (TSH lags 6-8 wk); if treatment fails or recurs after 2-yr course → definitive therapy — RAI ablation (preferred in adolescents > 10 yr, post-puberty for fertility) OR total thyroidectomy (skilled surgeon); ophthalmopathy — most mild self-limit, severe → ophtho + steroid + selenium + RAI typically not recommended worsens; reproductive counseling adolescent female (methimazole teratogenic 1st trimester); psychosocial + school accommodation; monitor growth + puberty + bone density

---

Pediatric Graves rare, treatment more conservative than adult initially. Methimazole 1-2 yr trial (remission lower than adult). Beta-blocker symptoms. Monitor LFT/CBC. RAI or surgery if fails. AAP/ATA 2016 guideline.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'pediatrics', 'basic_science', 'endocrine_metabolic', 'peds',
  'ATA Guideline Management of Hyperthyroidism 2016', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 13 ปี น้ำหนักลด 5 kg ใน 3 mo + ใจสั่น + ทนร้อนไม่ได้ + เหงื่อออก + tremor + irritable + insomnia + ผลการเรียนลด

V/S: HR 122 sinus, BP 138/72, BW 38 kg
PE: diffuse goiter symmetric non-tender, ophthalmopathy mild (mild proptosis + lid retraction), warm moist skin, fine tremor, hyperreflexia

TSH < 0.01, Free T4 4.2 (high), Free T3 12 (high), TSI/TRAb HIGH, anti-TPO + thyroid US: diffuse heterogeneous + increased vascularity'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 9 ปี DKA แรกเดิม pH 7.05 glucose 720 ตอนนี้ resuscitation 6 ชม IV fluid + insulin drip ดี glucose ลดมา 280 ตอนนี้

แต่จู่ ๆ ก็มี headache + ซึม + อาเจียน vomiting + GCS ลด 14 → 11 + papilledema + HR 62 + BP 132/88 (Cushing reflex)

ABG: pH 7.28 (ดีขึ้น), Glucose 280, Na corrected 142 (rise from 134 — sign of edema)', '[{"label":"A","text":"Increase insulin drip rate"},{"label":"B","text":"Cerebral Edema in pediatric DKA (most feared complication"},{"label":"C","text":"Stop all fluid"},{"label":"D","text":"Give D50W"},{"label":"E","text":"Increase rate of glucose drop"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cerebral Edema in pediatric DKA (most feared complication — 20-25% mortality if untreated, 25% morbidity in survivors): RECOGNIZE EARLY — clinical signs: headache, vomiting (after initial), altered mental status, bradycardia + HT (Cushing triad), papilledema, sluggish pupil, rapid corrected Na rise (warning sign); STOP IV fluid resuscitation rate (often over-aggressive contributes); reduce IV fluid 1/2 to 2/3 maintenance; head of bed 30°; immediate osmotherapy — 3% Hypertonic Saline 2.5-5 mL/kg over 10-15 min OR Mannitol 0.5-1 g/kg over 20 min (may need re-dose); intubate + mild hyperventilation transient bridge (avoid prolonged hypocapnia → reduce cerebral blood flow worsen ischemia); maintain euvolemia + adequate cerebral perfusion pressure; emergent CT head (rules out hemorrhage but treat clinically — don''t delay osmotherapy for CT); ICU + continuous neuro monitoring + neurosurgery consultation; identify other reversible factors (electrolyte derangement, sepsis); continue cautious diabetic management — extend correction over 48 hr (not 24); risk factors for cerebral edema: severe acidosis at presentation, high BUN, treatment with bicarbonate, rapid sodium drop, young age (< 5), new-onset diabetes; family counsel + long-term neuropsychological evaluation

---

Cerebral edema in DKA = most feared, fatal if missed. Recognize warning signs (HA, vomit, Cushing, falling GCS, papilledema, paradoxical Na rise). Hypertonic saline OR mannitol IMMEDIATELY. Don''t wait for CT. Reduce fluid. Avoid prolonged hyperventilation. Risk factors guide caution.', NULL,
  'hard', 'endocrine_metabolic', 'review',
  'pediatrics', 'clinical_decision', 'endocrine_metabolic', 'peds',
  'ISPAD DKA Guidelines 2022; Glaser PECARN NEJM 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 9 ปี DKA แรกเดิม pH 7.05 glucose 720 ตอนนี้ resuscitation 6 ชม IV fluid + insulin drip ดี glucose ลดมา 280 ตอนนี้

แต่จู่ ๆ ก็มี headache + ซึม + อาเจียน vomiting + GCS ลด 14 → 11 + papilledema + HR 62 + BP 132/88 (Cushing reflex)

ABG: pH 7.28 (ดีขึ้น), Glucose 280, Na corrected 142 (rise from 134 — sign of edema)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกเพศหญิงอายุ 2 wk virilized genitalia (Prader stage III — fused labia, clitoromegaly) อาเจียน + diarrhea + weight loss 200 g + lethargy + tachycardia + hyperpigmentation + dehydration

V/S: HR 178, BP 56/30, RR 48, SpO2 96%, Temp 36.4°C, BW 3.0 kg (เกิด 3.4 kg)

Lab: Na 122, K 7.2, Glucose 38, HCO3 12 (metabolic acidosis), 17-OH-progesterone HIGH, cortisol LOW, ACTH HIGH
Karyotype 46,XX', '[{"label":"A","text":"Surgery for genital correction immediately"},{"label":"B","text":"Salt-wasting CAH (21-hydroxylase deficiency) with adrenal crisis = endocrine emergency"},{"label":"C","text":"Insulin alone"},{"label":"D","text":"Discharge with oral medication"},{"label":"E","text":"No steroid"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Salt-wasting CAH (21-hydroxylase deficiency) with adrenal crisis = endocrine emergency: IMMEDIATE Hydrocortisone IV — 25 mg IV bolus (or 25-50 mg/m² depending source) STAT — STRESS dose for crisis, then 25-50 mg/m²/d ÷ q6h or continuous infusion; aggressive fluid resuscitation 20 mL/kg NSS bolus repeat as needed (severe dehydration) then maintenance + correction over 24-48 hr; correct hypoglycemia — D10W 2-5 mL/kg bolus; treat hyperkalemia — IV insulin + glucose, calcium gluconate (cardiac protection), albuterol nebulizer, kayexalate, dialysis if severe; treat acidosis (usually corrects with volume + glucose + Cortisol); once stable: maintenance regimen — Hydrocortisone 10-15 mg/m²/d PO ÷ TID + Fludrocortisone 50-150 mcg/d PO (mineralocorticoid) + salt supplement 1-2 g/d (NaCl) in infants until intake from food; STRESS dosing education — 3× dose for illness/fever/surgery, IM hydrocortisone for vomiting (kit + training); medical alert bracelet; pediatric endocrinology + multidisciplinary DSD team; gender assignment + psychosocial — discussed with multidisciplinary team + family (not just surgical decision; postpone elective genital surgery — controversial); monitor growth, bone age, virilization, fertility, puberty

---

CAH salt-wasting = leading cause neonatal female virilization + crisis. 21-hydroxylase = 90%. NBS includes 17-OHP. Crisis: emergency hydrocortisone + fluid + glucose + correct K. Lifelong replacement + stress dosing + salt. DSD team for gender + psychosocial. Genital surgery controversial.', NULL,
  'hard', 'endocrine_metabolic', 'review',
  'pediatrics', 'ems_mgmt', 'endocrine_metabolic', 'peds',
  'Endocrine Society CAH Guideline 2018; PES CAH Consensus', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกเพศหญิงอายุ 2 wk virilized genitalia (Prader stage III — fused labia, clitoromegaly) อาเจียน + diarrhea + weight loss 200 g + lethargy + tachycardia + hyperpigmentation + dehydration

V/S: HR 178, BP 56/30, RR 48, SpO2 96%, Temp 36.4°C, BW 3.0 kg (เกิด 3.4 kg)

Lab: Na 122, K 7.2, Glucose 38, HCO3 12 (metabolic acidosis), 17-OH-progesterone HIGH, cortisol LOW, ACTH HIGH
Karyotype 46,XX'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 3 ปี แม่คลำพบก้อนใน abdomen ลูก, ไม่เจ็บ, น้ำหนักไม่ลด, ปัสสาวะเป็นเลือดบ้าง 2 wk, BP สูง

V/S: BP 132/86, HR 102, BW 14 kg
PE: large left flank smooth firm mass, ปกติเด็ก well-appearing, no other abnormality, no aniridia, no hemihypertrophy

US: 8 cm renal mass left kidney + intact capsule, no IVC thrombus
CT chest + abdomen: large renal mass left + no metastasis, contralateral kidney normal
Biopsy NOT performed (would upstage)
Family: no syndrome', '[{"label":"A","text":"Biopsy first then chemo"},{"label":"B","text":"Wilms Tumor (Nephroblastoma)"},{"label":"C","text":"Watchful waiting"},{"label":"D","text":"Antibiotic"},{"label":"E","text":"Steroid alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Wilms Tumor (Nephroblastoma) — most common pediatric renal malignancy peak 2-4 yr (clinical/imaging diagnosis sufficient — biopsy not done in COG/SIOP protocols, upstages tumor): pediatric oncology + pediatric surgery + radiation oncology coordinated; COG approach (North America) — NEPHRECTOMY FIRST (radical nephrectomy with retroperitoneal lymph node sampling) → staging → adjuvant chemotherapy based on stage + histology; SIOP approach (Europe) — neoadjuvant chemotherapy first → nephrectomy → adjuvant; staging — chest CT (lung mets), abdominal CT/MRI (IVC tumor thrombus important), bone scan + brain MRI for rhabdoid/clear cell selected; favorable histology + early stage — excellent prognosis (cure 90%+); chemotherapy regimens — vincristine + actinomycin-D ± doxorubicin ± etoposide depending stage; radiation for higher stage; screening — Beckwith-Wiedemann, hemihypertrophy, WAGR (aniridia + GU + retardation), Denys-Drash — abdominal US q3 mo until age 8; surveillance post-treatment chest + abdomen imaging; long-term: renal function, cardiac (anthracycline), pulmonary (if XRT), secondary malignancy

---

Wilms = most common renal malignancy peds (2-4 yr peak). Biopsy NOT done (upstages). COG: nephrectomy first; SIOP: neoadjuvant. Favorable hist + early stage = > 90% cure. Screen at-risk syndromes. Long-term toxicity monitoring.', NULL,
  'medium', 'hemato_onco', 'review',
  'pediatrics', 'clinical_decision', 'hemato_onco', 'peds',
  'COG/SIOP Wilms Tumor Protocols; AAP Section on Hematology/Oncology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 3 ปี แม่คลำพบก้อนใน abdomen ลูก, ไม่เจ็บ, น้ำหนักไม่ลด, ปัสสาวะเป็นเลือดบ้าง 2 wk, BP สูง

V/S: BP 132/86, HR 102, BW 14 kg
PE: large left flank smooth firm mass, ปกติเด็ก well-appearing, no other abnormality, no aniridia, no hemihypertrophy

US: 8 cm renal mass left kidney + intact capsule, no IVC thrombus
CT chest + abdomen: large renal mass left + no metastasis, contralateral kidney normal
Biopsy NOT performed (would upstage)
Family: no syndrome'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 2 ปี ปวดท้อง + คลำได้ก้อน abdominal + อ่อนเพลีย + เหนื่อยง่าย + bony pain + periorbital ecchymosis (''raccoon eyes'') + small subcutaneous nodule pulsatile + diarrhea (VIP from tumor)

V/S: HR 132, BP 102/68, BW 12 kg
PE: large irregular firm abdominal mass crossing midline, hepatomegaly, opsoclonus-myoclonus (eye + body), no aniridia

Lab: catecholamines (urine VMA + HVA) HIGH, NSE HIGH, LDH HIGH, ferritin HIGH
CT/MIBG scan: large adrenal mass with calcification + para-aortic LN + bony mets vertebra + femur + bone marrow aspirate POSITIVE for neuroblasts
N-MYC amplification: positive (high-risk)', '[{"label":"A","text":"Surgery alone curative"},{"label":"B","text":"High-risk Neuroblastoma (age > 18 mo, stage 4, N-MYC amplified, unfavorable histology)"},{"label":"C","text":"Chemo only no immunotherapy"},{"label":"D","text":"Wait + observe"},{"label":"E","text":"Antibiotic only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** High-risk Neuroblastoma (age > 18 mo, stage 4, N-MYC amplified, unfavorable histology) — multidisciplinary intensive multimodal therapy: pediatric oncology + surgery + radiation oncology + BMT center; intensive induction chemotherapy (cyclophosphamide + topotecan/etoposide + cisplatin + doxorubicin/vincristine) × 5-6 cycles; surgical resection of primary; consolidation with myeloablative chemotherapy + tandem autologous stem cell transplant (recent studies improve EFS); radiation therapy primary site + selected mets; differentiation therapy 13-cis-retinoic acid maintenance; anti-GD2 immunotherapy (dinutuximab + GM-CSF + IL-2) — major advance (COG ANBL0032 trial significantly improved survival); newer: anti-GD2 + chemo upfront; supportive — pain management, nutrition, central line, transfusion support, infection prophylaxis; opsoclonus-myoclonus — IVIG + steroid + rituximab (paraneoplastic); long-term: hearing (cisplatin), cardiac (anthracycline), fertility, secondary malignancy, growth/endocrine, neurocognitive; prognosis high-risk historically 30-50% 5-yr survival, improving with newer therapy; family counseling + comprehensive late effects clinic

---

Neuroblastoma = most common solid tumor < 1 yr. Range: spontaneous regression in infants (stage 4S, MYCN-) to highly aggressive (high-risk MYCN+). Multimodal: chemo + surgery + RT + ASCT + anti-GD2 immunotherapy + retinoic acid. Opsoclonus-myoclonus paraneoplastic. Long-term toxicity monitoring.', NULL,
  'hard', 'hemato_onco', 'review',
  'pediatrics', 'clinical_decision', 'hemato_onco', 'peds',
  'COG Neuroblastoma Protocols (ANBL); Maris JN NEJM 2010', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 2 ปี ปวดท้อง + คลำได้ก้อน abdominal + อ่อนเพลีย + เหนื่อยง่าย + bony pain + periorbital ecchymosis (''raccoon eyes'') + small subcutaneous nodule pulsatile + diarrhea (VIP from tumor)

V/S: HR 132, BP 102/68, BW 12 kg
PE: large irregular firm abdominal mass crossing midline, hepatomegaly, opsoclonus-myoclonus (eye + body), no aniridia

Lab: catecholamines (urine VMA + HVA) HIGH, NSE HIGH, LDH HIGH, ferritin HIGH
CT/MIBG scan: large adrenal mass with calcification + para-aortic LN + bony mets vertebra + femur + bone marrow aspirate POSITIVE for neuroblasts
N-MYC amplification: positive (high-risk)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 8 ปี ก้อนต่อมน้ำเหลืองที่คอข้างขวา 2 cm 3 wk + ไข้ต่ำ ๆ + tender 2 wk ก่อนคุยกับแมวบ้านโดน scratch ที่แขนข้างขวา ตรงนี้มี healed papule 1 cm ที่ข้อมือขวา; ไม่มี night sweat, no weight loss, no other LN

BW 24 kg, no organomegaly
CBC normal, ESR mildly elevated
Bartonella henselae IgG titer +', '[{"label":"A","text":"Aggressive surgery + chemo"},{"label":"B","text":"Cat Scratch Disease (Bartonella henselae)"},{"label":"C","text":"Discharge no diagnosis"},{"label":"D","text":"Surgical excision routine"},{"label":"E","text":"Chemo"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cat Scratch Disease (Bartonella henselae): most cases self-limited (3-4 mo) — supportive care; for typical immunocompetent + mild disease, antibiotic limited benefit (no proven shortening of natural course); however, AAP recommends azithromycin 10 mg/kg PO day 1, then 5 mg/kg × 4 d (PO) for hastens resolution + accepted; warm compresses to LN; analgesia; do NOT incise + drain typically (sinus tract); needle aspiration if suppurative + symptomatic; reassurance; for severe disease (visceral, encephalopathy, neuroretinitis, hepatosplenic, endocarditis, immunocompromised) — antibiotic combination (azithromycin + rifampin/doxycycline) extended duration; cat avoidance not necessary (most resolution), flea control on pet; HIV/immunocompromised need investigation Bartonella bacillary angiomatosis (different organism); follow-up 2-4 wk; rule out other LN causes (mycobacteria atypical, tularemia, lymphoma) if persists > 2 mo, > 3 cm, hard, systemic symptoms → biopsy

---

Cat scratch = Bartonella henselae from cat (especially kittens). Inoculation papule → regional LN 1-3 wk. Most self-limit. Azithromycin may hasten resolution. Severe/immunocompromised → combination antibiotic. Differential lymphadenopathy includes atypical mycobacteria, lymphoma — biopsy if atypical.', NULL,
  'easy', 'id', 'review',
  'pediatrics', 'clinical_decision', 'id', 'peds',
  'AAP Red Book 2024 Bartonellosis', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 8 ปี ก้อนต่อมน้ำเหลืองที่คอข้างขวา 2 cm 3 wk + ไข้ต่ำ ๆ + tender 2 wk ก่อนคุยกับแมวบ้านโดน scratch ที่แขนข้างขวา ตรงนี้มี healed papule 1 cm ที่ข้อมือขวา; ไม่มี night sweat, no weight loss, no other LN

BW 24 kg, no organomegaly
CBC normal, ESR mildly elevated
Bartonella henselae IgG titer +'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกเกิดจากแม่ HIV+ on ART unsuppressed viral load 18,000 copies/mL ที่ delivery (NOT undetectable, NOT ideal) คลอด NL term BW 3,000 g

No prenatal care until trimester 3; baby asymptomatic, no obvious dysmorphism, well-appearing
Birth: HIV PCR sent, awaiting result; CBC normal', '[{"label":"A","text":"No prophylaxis, breastfeed normally"},{"label":"B","text":"Perinatal HIV exposure HIGH-risk (maternal VL > 50, unsuppressed)"},{"label":"C","text":"Single-drug ZDV only"},{"label":"D","text":"No follow-up"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Perinatal HIV exposure HIGH-risk (maternal VL > 50, unsuppressed) — combination antiretroviral prophylaxis: start within 6-12 hr of birth (CRITICAL TIMING) — 3-drug ARV regimen — zidovudine + lamivudine + nevirapine (preferred) OR raltegravir-based per HIV pediatric specialist guidance, duration 6 wk; immediate consultation pediatric HIV specialist; HIV PCR DNA (NAT) at birth, 14-21 d, 1-2 mo, 4-6 mo (definitive exclusion 2 negative tests ≥ 1 mo + ≥ 4 mo); antibody at 18-24 mo confirm; AVOID breastfeeding — replacement feeding (formula) in resource-rich settings; if breastfeeding inevitable (resource-limited) → maternal ART + infant prophylaxis throughout; vaccinations standard except avoid live vaccines (BCG until HIV status known); PCP prophylaxis (TMP-SMX) start age 4-6 wk regardless of CD4 until HIV ruled out; comprehensive primary care + adherence support; partner notification + testing; mental health + social work; if infant infected — start cART immediately, comprehensive HIV care; counsel family + privacy

---

Perinatal HIV exposure: high-risk = 3-drug prophylaxis (vs ZDV monotherapy for low-risk). Start within 6-12 hr. Duration 6 wk. Series of HIV PCR for diagnosis (Ab unreliable < 18 mo). Avoid breastfeeding in resource-rich. PCP prophylaxis. Multidisciplinary.', NULL,
  'hard', 'id', 'review',
  'pediatrics', 'integrative', 'id', 'peds',
  'HHS Perinatal HIV Guidelines 2024; AAP COID HIV Recommendations', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกเกิดจากแม่ HIV+ on ART unsuppressed viral load 18,000 copies/mL ที่ delivery (NOT undetectable, NOT ideal) คลอด NL term BW 3,000 g

No prenatal care until trimester 3; baby asymptomatic, no obvious dysmorphism, well-appearing
Birth: HIV PCR sent, awaiting result; CBC normal'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 7 ปี ไข้ 39.0°C + เจ็บคอ + กลืนเจ็บ × 2 วัน, ไม่ไอ, ไม่คัดจมูก

V/S: HR 102, Temp 39.0°C, BW 22 kg
PE: tonsils enlarged + exudate, tender anterior cervical LN, no cough, no congestion, palate petechiae, strawberry tongue, sandpaper rash trunk (scarlatiniform)

Rapid Strep A: positive
Center score 4-5', '[{"label":"A","text":"No treatment needed"},{"label":"B","text":"Streptococcal Pharyngitis + Scarlet fever (GAS confirmed)"},{"label":"C","text":"Antiviral"},{"label":"D","text":"Antifungal"},{"label":"E","text":"Discharge no antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Streptococcal Pharyngitis + Scarlet fever (GAS confirmed): antibiotic Penicillin V PO 250 mg BID-TID (< 27 kg) or 500 mg BID (≥ 27 kg) × 10 days OR Amoxicillin 50 mg/kg/d (max 1,000 mg) once daily × 10 days (similar efficacy + better adherence) OR Benzathine penicillin G 600,000 U IM single dose (< 27 kg) or 1,200,000 U (≥ 27 kg) — single shot ensures compliance; for true penicillin allergy: cephalexin (non-anaphylactic), clindamycin, azithromycin (resistance rising — verify), clarithromycin; treatment goals — prevent acute rheumatic fever (best evidence within 9 d of symptom onset), reduce suppurative complication (peritonsillar abscess, OM, sinusitis), reduce contagion (24 hr after antibiotic = not contagious — return school); supportive — analgesia/antipyretic, fluids, salt water gargle; treat household contacts ONLY if symptomatic (not routine); recurrence within months — repeat treatment same; chronic carriers (asymptomatic + Rapid+) generally NOT treated; complications — RhF, PSGN, scarlet fever, peritonsillar abscess; follow-up if persistent symptoms; tonsillectomy criteria — recurrent (Paradise criteria) — not first-line

---

GAS pharyngitis = treat to prevent RhF + complications. Centor score helps clinical Dx; confirm with RADT (high specificity). Penicillin or amoxicillin first-line × 10 d. Scarlet fever = GAS + erythrogenic toxin. 24 hr post-abx → return school. Penicillin allergy → cephalexin most safe.', NULL,
  'easy', 'id', 'review',
  'pediatrics', 'clinical_decision', 'id', 'peds',
  'IDSA Guideline Streptococcal Pharyngitis 2012', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 7 ปี ไข้ 39.0°C + เจ็บคอ + กลืนเจ็บ × 2 วัน, ไม่ไอ, ไม่คัดจมูก

V/S: HR 102, Temp 39.0°C, BW 22 kg
PE: tonsils enlarged + exudate, tender anterior cervical LN, no cough, no congestion, palate petechiae, strawberry tongue, sandpaper rash trunk (scarlatiniform)

Rapid Strep A: positive
Center score 4-5'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 4 ปี BW 18 kg พบจมในสระว่ายน้ำ 5-7 นาที EMS เริ่ม CPR pulseless rhythm asystole มา ED ต่อเนื่อง CPR

ณ ED: continued CPR + intubated + IV/IO access; pupils dilated mid-position, no spontaneous breath, no pulse
Monitor: asystole, then PEA
Glucose 80, K 5.2, Temp 32.0°C (mild hypothermia from cold water)', '[{"label":"A","text":"Stop resuscitation immediately"},{"label":"B","text":"Pediatric Drowning Cardiac Arrest with hypothermia"},{"label":"C","text":"Cease CPR before rewarm"},{"label":"D","text":"Discharge"},{"label":"E","text":"Defibrillation asystole"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Drowning Cardiac Arrest with hypothermia: continue aggressive ALS resuscitation — high-quality CPR with minimal interruption, depth 1/3 chest diameter, rate 100-120/min, allow full recoil; airway secured + ventilation 10/min asynchronous with chest compression; IV/IO Epinephrine 0.01 mg/kg (0.1 mL/kg 1:10,000) q3-5 min; manage rhythm per PALS — asystole/PEA = CPR + epi; identify + treat reversible causes (Hs and Ts) — Hypoxia (most important in drowning), Hypothermia (continue resuscitation until rewarm > 32°C — ''not dead until warm and dead''), Hypovolemia, H+ (acidosis), Hyperkalemia, Hypoglycemia, Tension PTX, Tamponade, Toxin, Thrombosis (PE/MI uncommon peds); ACTIVE rewarming — warm IV fluid 38-40°C, warmed humidified O2, bladder + gastric + thoracic lavage warm fluid, ECMO if available (Class I in hypothermia arrest); avoid hyperventilation; correct electrolytes; once ROSC — post-arrest care (targeted temperature management — recent THAPCA trials suggest 32-34°C × 2 days vs strict normothermia debated, AHA peds 2020: maintain 32-34°C OR 36-37.5°C without fever); neuro exam delayed prognostication; long-term — most survivors require comprehensive neuro rehab; consider organ donation if irreversibly nonresponsive; family support; prevention — pool fence, supervision, swim lessons, CPR education

---

Drowning = hypoxia primary mechanism. Hypothermia prolongs viability — continue resuscitation until rewarmed > 32-35°C (''not dead until warm and dead''). Reversible causes (Hs and Ts). Post-arrest TTM. Don''t defibrillate asystole. Prevention = supervision + barriers + CPR education.', NULL,
  'hard', 'trauma', 'review',
  'pediatrics', 'ems_mgmt', 'trauma', 'peds',
  'AHA PALS 2020; Wilderness Medicine Society Drowning', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 4 ปี BW 18 kg พบจมในสระว่ายน้ำ 5-7 นาที EMS เริ่ม CPR pulseless rhythm asystole มา ED ต่อเนื่อง CPR

ณ ED: continued CPR + intubated + IV/IO access; pupils dilated mid-position, no spontaneous breath, no pulse
Monitor: asystole, then PEA
Glucose 80, K 5.2, Temp 32.0°C (mild hypothermia from cold water)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 4 ปี BW 18 kg เกิดเหตุน้ำร้อนจากกาแฟราดลงไหล่ + แขน + อก หน้า L (เด็กล้ม) เผาผิวไหม้ตื้น scattered: full thickness 8% + partial thickness 18% (รวม TBSA burn ~26%)

V/S: HR 138, BP 96/60, RR 32, SpO2 99%, Temp 36.4°C
Gen: alert, pain crying, no airway involvement (no soot, no singed hair, no stridor, no hoarseness)
Weight = 18 kg', '[{"label":"A","text":"Discharge home"},{"label":"B","text":"Pediatric Moderate-Severe Burn 26% TBSA"},{"label":"C","text":"Tubinated outpatient"},{"label":"D","text":"Antibiotic prophylactic"},{"label":"E","text":"Restrict all fluid"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Moderate-Severe Burn 26% TBSA — admit burn unit: airway evaluation (no signs above so observation) — early intubation if any signs inhalation; fluid resuscitation — Parkland formula 4 mL × kg × %TBSA (full + partial thickness, NOT superficial) over 24 hr = 4 × 18 × 26 = 1,872 mL Ringer''s lactate, give 1/2 in first 8 hr from time of burn (not arrival), 1/2 over next 16 hr; pediatric variation — additional MAINTENANCE fluid (often D5LR or D5W after) for children — Galveston (5,000 mL × m²/TBSA + 2,000 mL × m² maintenance) or modified Parkland with maintenance; titrate to urine output 1 mL/kg/hr; analgesia adequate — IV morphine 0.05-0.1 mg/kg q2-4h; wound care — cool tap water cooling 20 min if within 3 hr but AVOID hypothermia; gentle wound cleaning; silver sulfadiazine or bacitracin or biological/synthetic dressings; tetanus prophylaxis (per status); circumferential burn → escharotomy assess; nutrition — high calorie + protein (2-3 g/kg/d); infection prevention; physical therapy early to prevent contracture; multidisciplinary burn center; long-term scarring + functional rehab; psychosocial; report if non-accidental suspected (pattern, history inconsistent)

---

Pediatric burn fluid resus = Parkland or Galveston, NOT just Parkland (kids need MAINTENANCE fluid added). UO target 1 mL/kg/hr. Burn center for major burns. Early analgesia + wound care + nutrition. NAI screen if pattern inconsistent. Multidisciplinary including PT/OT/psych.', NULL,
  'medium', 'trauma', 'review',
  'pediatrics', 'ems_mgmt', 'trauma', 'peds',
  'ABA Practice Guideline; Pediatric Burn Resuscitation Consensus', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 4 ปี BW 18 kg เกิดเหตุน้ำร้อนจากกาแฟราดลงไหล่ + แขน + อก หน้า L (เด็กล้ม) เผาผิวไหม้ตื้น scattered: full thickness 8% + partial thickness 18% (รวม TBSA burn ~26%)

V/S: HR 138, BP 96/60, RR 32, SpO2 99%, Temp 36.4°C
Gen: alert, pain crying, no airway involvement (no soot, no singed hair, no stridor, no hoarseness)
Weight = 18 kg'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 2 ปี กลืนแบตเตอรี่กระดุม (button battery, 20 mm CR2032) 4 ชม ก่อน asymptomatic — เห็นในหลอดอาหารส่วนล่าง 1/3 บน CXR PA + lateral (double halo sign + step-off)', '[{"label":"A","text":"Outpatient observation"},{"label":"B","text":"Esophageal Button Battery = EMERGENCY (alkaline injury caustic necrosis within 2 hr"},{"label":"C","text":"Wait until passes"},{"label":"D","text":"Charcoal"},{"label":"E","text":"Ipecac"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Esophageal Button Battery = EMERGENCY (alkaline injury caustic necrosis within 2 hr — can cause perforation, fistula, vascular injury, death even after hours): IMMEDIATE endoscopic removal in OR ภายใน 2 hours of ingestion regardless symptom (don''t wait or observe) — gastroenterology/ENT urgent; pre-removal mitigation NEW 2023 NASPGHAN/NACER recommendation — administer HONEY 10 mL PO q10 min × up to 6 doses (if > 12 mo + < 12 hr from ingestion + no perforation) OR sucralfate suspension 10 mL q10 min (in hospital) — both shown to neutralize alkaline injury + reduce mucosal damage in delayed presentation; do NOT induce vomiting (corrosive); NPO; airway monitoring; post-removal — assess injury extent + monitor for delayed complications (esophageal stricture, perforation, aortoesophageal fistula → catastrophic hemorrhage, tracheoesophageal fistula); imaging — repeat imaging confirm removal; if perforation/mediastinitis → surgery + ICU; if battery gastric in asymptomatic + no esophageal injury + > 12 mo + > 15 mm → can sometimes observe with follow-up imaging; education prevention (childproof, lock electronics); reportable to National Capital Poison Center battery hotline (US 1-800-498-8666)

---

Esophageal button battery = TIME-CRITICAL emergency (alkaline burn within 2 hr). Immediate endoscopic removal. HONEY (or sucralfate) mitigation 2023 NASPGHAN: 10 mL q10 min × 6 doses for > 12 mo + < 12 hr. Delayed complications (stricture, fistula) up to weeks later. Childproof prevention.', NULL,
  'easy', 'gi', 'review',
  'pediatrics', 'clinical_decision', 'gi', 'peds',
  'NASPGHAN/NACER Button Battery Management 2023; National Capital Poison Center Triage Guideline', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 2 ปี กลืนแบตเตอรี่กระดุม (button battery, 20 mm CR2032) 4 ชม ก่อน asymptomatic — เห็นในหลอดอาหารส่วนล่าง 1/3 บน CXR PA + lateral (double halo sign + step-off)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 5 ปี chronic diarrhea + abdominal distension + ปวดท้องเรื้อรัง + irritable + ผลโรงเรียนตก + growth failure (น้ำหนัก + ส่วนสูง < 3rd percentile) × 1 yr ปกติ unrelated to vaccines or new food

Diet: regular Western diet inc wheat
PE: thin, pot belly, mild pallor, no rash
Family: aunt with type 1 DM, mother autoimmune thyroiditis

CBC: mild iron-deficiency anemia
TTG-IgA HIGH (10× ULN), total IgA normal, anti-EMA + 
Intestinal biopsy: villous atrophy Marsh 3b', '[{"label":"A","text":"Steroid alone forever"},{"label":"B","text":"Celiac Disease (TTG > 10× + biopsy-confirmed villous atrophy)"},{"label":"C","text":"Eliminate dairy only"},{"label":"D","text":"Reduce gluten"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Celiac Disease (TTG > 10× + biopsy-confirmed villous atrophy): STRICT LIFELONG gluten-free diet (avoid wheat, rye, barley + cross-contamination) — only effective treatment; refer pediatric gastroenterologist + dietitian (gluten-free education essential — labels, eating out, hidden gluten); replace nutritional deficiencies — iron, folate, vitamin D, calcium, B12, zinc selectively; monitor symptom resolution (weeks) + serology normalization (TTG falls 6-12 mo); resolution growth catch-up + symptoms; bone density assessment (osteopenia common); screen first-degree relatives (10% prevalence); associated conditions screen — Type 1 DM (5%), autoimmune thyroid (5-10%), Addison, Sjogren, IgA deficiency, dermatitis herpetiformis; pneumococcal vaccine (functional asplenia); psychosocial — adherence challenges adolescence; ESPGHAN 2020 recent: in some children with TTG > 10× ULN + EMA + + HLA-DQ2/DQ8 → can avoid biopsy (Dx without endoscopy) — biopsy still standard most; long-term complications poorly controlled — refractory celiac, EATL lymphoma, infertility, osteoporosis; school + family + restaurant + travel planning

---

Celiac disease = lifelong gluten avoidance only effective treatment. ESPGHAN 2020: no-biopsy diagnosis if TTG > 10× ULN + EMA + + symptoms (select children). Screen relatives + associated autoimmune conditions. Nutritional repletion. Dietitian + family education. Long-term cancer/osteoporosis surveillance.', NULL,
  'medium', 'gi', 'review',
  'pediatrics', 'basic_science', 'gi', 'peds',
  'ESPGHAN Celiac Disease Guidelines 2020; NASPGHAN Position', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 5 ปี chronic diarrhea + abdominal distension + ปวดท้องเรื้อรัง + irritable + ผลโรงเรียนตก + growth failure (น้ำหนัก + ส่วนสูง < 3rd percentile) × 1 yr ปกติ unrelated to vaccines or new food

Diet: regular Western diet inc wheat
PE: thin, pot belly, mild pallor, no rash
Family: aunt with type 1 DM, mother autoimmune thyroiditis

CBC: mild iron-deficiency anemia
TTG-IgA HIGH (10× ULN), total IgA normal, anti-EMA + 
Intestinal biopsy: villous atrophy Marsh 3b'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 13 ปี chronic intermittent abdominal pain RLQ + diarrhea 4-6 ครั้ง/วัน (intermittent bloody) + weight loss 7 kg ใน 6 mo + delayed puberty Tanner 2 + ครั้งล่าสุดมี perianal fistula + ตา anterior uveitis flare

V/S: HR 92, BW 38 kg (had been 45 kg)
PE: cachectic, RLQ tenderness, perianal tag + small fistula, clubbing early, no organomegaly

CBC: Hb 9.8 (microcytic), albumin 2.6, ESR 78, CRP 95, ferritin low
Fecal calprotectin > 1,000 (very high)
Colonoscopy + ileoscopy: skip lesions ileum + terminal colon + perianal disease + cobblestoning + granulomas histology = Crohn disease', '[{"label":"A","text":"Wait — surgery only"},{"label":"B","text":"Pediatric Crohn Disease with growth failure + perianal + extraintestinal"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Steroid forever"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Crohn Disease with growth failure + perianal + extraintestinal — moderate-severe: multidisciplinary pediatric gastroenterology team + dietitian + IBD nurse + psychology + adolescent medicine + ophthalmology; INDUCTION — exclusive enteral nutrition (EEN) 8 weeks (formula only, equally effective as steroid in pediatric CD, improves growth, no steroid side effects — first-line per ESPGHAN/NASPGHAN); OR systemic corticosteroid prednisolone if EEN not tolerated; biologic — Infliximab (anti-TNF) early in moderate-severe pediatric CD with growth failure or fistulizing/perianal (top-down approach evidence improving outcomes vs step-up) + concurrent immunomodulator (azathioprine 1-2.5 mg/kg or methotrexate 15 mg/m²/wk SC) selected to reduce immunogenicity; ALTERNATIVES — adalimumab, ustekinumab, vedolizumab, risankizumab (newer); perianal fistula — combined medical + EUA + seton drainage + antibiotic (cipro + metronidazole) + biologic; treat anemia (iron replacement IV often), nutritional repletion, vitamin D + calcium; growth monitoring + puberty staging; ophthalmology for uveitis (topical steroid + treat IBD); surveillance colonoscopy + cancer screening; immunization including live (varicella/MMR) BEFORE biologic; mental health + transition adult care; surgery — symptomatic fistula not responding, stricture, perforation, abscess, refractory disease, dysplasia

---

Pediatric Crohn = growth + nutrition focus. EEN first-line induction (vs steroid). Early biologic (top-down) for moderate-severe + complicating features improves long-term outcomes + growth. Perianal disease = combined medical + surgical. Multidisciplinary team. Vaccinate before biologic.', NULL,
  'medium', 'gi', 'review',
  'pediatrics', 'integrative', 'gi', 'peds',
  'ESPGHAN/NASPGHAN Pediatric IBD Guidelines 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 13 ปี chronic intermittent abdominal pain RLQ + diarrhea 4-6 ครั้ง/วัน (intermittent bloody) + weight loss 7 kg ใน 6 mo + delayed puberty Tanner 2 + ครั้งล่าสุดมี perianal fistula + ตา anterior uveitis flare

V/S: HR 92, BW 38 kg (had been 45 kg)
PE: cachectic, RLQ tenderness, perianal tag + small fistula, clubbing early, no organomegaly

CBC: Hb 9.8 (microcytic), albumin 2.6, ESR 78, CRP 95, ferritin low
Fecal calprotectin > 1,000 (very high)
Colonoscopy + ileoscopy: skip lesions ileum + terminal colon + perianal disease + cobblestoning + granulomas histology = Crohn disease'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 18 เดือน ไข้ 39°C + irritable + ดึงหู ซ้าย × 2 วัน + URI 4 วันก่อน

V/S: HR 122, RR 28, Temp 39.0°C, BW 11 kg
PE: TM left bulging + erythematous + decreased mobility on pneumatic otoscopy = AOM moderate-severe, no perforation, no posterior auricular swelling
Right TM normal', '[{"label":"A","text":"No treatment"},{"label":"B","text":"Acute Otitis Media (AAP 2013 + 2022 update)"},{"label":"C","text":"Surgery first"},{"label":"D","text":"Antiviral"},{"label":"E","text":"Steroid"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Otitis Media (AAP 2013 + 2022 update): antibiotic indicated < 6 mo all, 6-23 mo with unilateral severe, ≥ 2 yr severe or bilateral ≥ 2 yr if non-severe; this patient (18 mo, unilateral + severe) → antibiotic; Amoxicillin 80-90 mg/kg/d ÷ q12h × 10 days (< 2 yr) — first-line if no recent antibiotic use; Amoxicillin-clavulanate 90 mg/kg/d if: recent antibiotic < 30 d, concurrent conjunctivitis (likely H. flu), prior treatment failure, recurrent AOM, severe disease, child > 2 yr can use 7-day course; alternatives for penicillin allergy (non-anaphylactic) — cefdinir, cefuroxime, cefpodoxime; anaphylaxis — azithromycin (resistance rising); analgesia + antipyretic (ibuprofen + acetaminophen); shared decision-making ''watchful waiting'' (Watch + Wait, with prescription back-up) for non-severe, unilateral, ≥ 2 yr; follow-up if no improvement 48-72 hr → reassess + escalate (amox-clav, ceftriaxone IM × 1-3 d); tympanostomy tubes for recurrent (≥ 3 in 6 mo or ≥ 4 in 12 mo) or chronic effusion + hearing/speech impact; PCV13/15/20 + influenza vaccine reduce AOM; breastfeeding + smoke avoidance preventive

---

AOM = most common kid bacterial infection (Spn, H flu, M cat). AAP 2013/2022: antibiotic for severe or < 2 yr bilateral; amoxicillin first-line. Pain management critical. Watchful waiting in select. Recurrent → tubes. Pneumococcal vaccine prevention.', NULL,
  'easy', 'id', 'review',
  'pediatrics', 'clinical_decision', 'id', 'peds',
  'AAP Clinical Practice Guideline: AOM 2013/2022', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 18 เดือน ไข้ 39°C + irritable + ดึงหู ซ้าย × 2 วัน + URI 4 วันก่อน

V/S: HR 122, RR 28, Temp 39.0°C, BW 11 kg
PE: TM left bulging + erythematous + decreased mobility on pneumatic otoscopy = AOM moderate-severe, no perforation, no posterior auricular swelling
Right TM normal'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 4 ปี untreated AOM 10 วันก่อน ตอนนี้ ไข้สูง 39.5°C + ปวดหลังหู + บวมแดงด้านหลังใบหู ดันใบหูออกข้างหน้า + irritable + drowsy

V/S: HR 132, RR 28, Temp 39.5°C, BW 18 kg
PE: protruding right pinna outward + downward, post-auricular swelling + erythema + tenderness + fluctuance, TM right perforated purulent discharge, ตรวจ neuro ปกติ

CBC: WBC 22,400 (left shift), CRP 168
CT mastoid: opacification mastoid air cells + coalescent destruction bony septae + small subperiosteal abscess + intact intracranial', '[{"label":"A","text":"Outpatient oral antibiotic"},{"label":"B","text":"Acute Mastoiditis (complication AOM)"},{"label":"C","text":"Antiviral alone"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Wait for spontaneous resolution"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Mastoiditis (complication AOM): admit + IV antibiotic urgent — Ceftriaxone 50-100 mg/kg/d (covers Spn, H flu, Strep, GAS) + Vancomycin 60 mg/kg/d if concern MRSA, or Pip-tazo if severe; ENT consultation urgent; if subperiosteal abscess → surgical drainage (myringotomy + tympanostomy tube + cortical mastoidectomy if coalescent or abscess or refractory); imaging — CT temporal bone + intracranial complication screen (epidural abscess, sigmoid sinus thrombosis, meningitis, brain abscess); intracranial complications → emergent neurosurgery + extended antibiotic + anticoagulation for sinus thrombosis (controversial); blood culture + ear discharge culture pre-antibiotic; analgesia + supportive; total antibiotic 2-4 wk IV → oral; hearing test + ENT follow-up; recurrent risk; counsel + education AOM treatment importance

---

Mastoiditis = AOM complication. Protruding pinna + post-auricular swelling = classic. CT for severity + intracranial complication screen. IV antibiotic + ENT + surgery if abscess/coalescent. Sigmoid sinus thrombosis + brain abscess = serious neurological complications.', NULL,
  'medium', 'id', 'review',
  'pediatrics', 'ems_mgmt', 'id', 'peds',
  'AAO-HNS Mastoiditis Clinical Practice', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 4 ปี untreated AOM 10 วันก่อน ตอนนี้ ไข้สูง 39.5°C + ปวดหลังหู + บวมแดงด้านหลังใบหู ดันใบหูออกข้างหน้า + irritable + drowsy

V/S: HR 132, RR 28, Temp 39.5°C, BW 18 kg
PE: protruding right pinna outward + downward, post-auricular swelling + erythema + tenderness + fluctuance, TM right perforated purulent discharge, ตรวจ neuro ปกติ

CBC: WBC 22,400 (left shift), CRP 168
CT mastoid: opacification mastoid air cells + coalescent destruction bony septae + small subperiosteal abscess + intact intracranial'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 6 ปี ไข้ + เหนื่อย 3 วัน 1 wk ago — well-appearing ตอนนี้ มี slapped cheek แดงสด ทั้ง 2 ข้าง + lacy reticular erythematous rash trunk + arms + legs ปรากฏ 2 วัน, ไม่คัน, ไม่มีไข้ ตอนนี้

PE: bilateral malar erythema + lacy rash limbs, no oral lesions, no other findings
Family: father chronic anemia (sickle cell), grandmother elderly
No joint complaint', '[{"label":"A","text":"Aggressive antibiotic"},{"label":"B","text":"Erythema Infectiosum (Fifth Disease, Parvovirus B19)"},{"label":"C","text":"Isolation indefinitely"},{"label":"D","text":"Antiviral 6 weeks"},{"label":"E","text":"Steroid"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Erythema Infectiosum (Fifth Disease, Parvovirus B19): supportive care — no specific antiviral, rash phase = not contagious (contagious during pre-rash febrile illness only); reassurance — self-limited 7-10 days, rash can wax/wane with heat/sun/exercise × wk-mo; antipyretic + comfort; safe return to school (rash phase non-contagious); aplastic crisis precautions — counsel family/contacts with chronic hemolytic anemia (sickle cell father — temporary red cell aplasia, ~2 wk transfusion-dependent crisis) — they may need transfusion + isolation if exposed; pregnant women contacts — counsel about risk fetal hydrops + miscarriage (1st trimester especially) — referral for serology + obstetric monitoring; immunocompromised — chronic infection risk → IVIG treatment; arthritis (especially adults more) self-limit weeks; rare complications — myocarditis, encephalitis; no vaccine available; long-term immunity following infection

---

Parvovirus B19 = fifth disease. Slapped cheek + lacy rash. Self-limit. Concerns: aplastic crisis in chronic hemolytic anemia (sickle cell), fetal hydrops in pregnancy, chronic anemia in immunocompromised. Rash phase NOT contagious — only pre-rash febrile. Supportive care.', NULL,
  'easy', 'id', 'review',
  'pediatrics', 'basic_science', 'id', 'peds',
  'AAP Red Book 2024 Parvovirus B19', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 6 ปี ไข้ + เหนื่อย 3 วัน 1 wk ago — well-appearing ตอนนี้ มี slapped cheek แดงสด ทั้ง 2 ข้าง + lacy reticular erythematous rash trunk + arms + legs ปรากฏ 2 วัน, ไม่คัน, ไม่มีไข้ ตอนนี้

PE: bilateral malar erythema + lacy rash limbs, no oral lesions, no other findings
Family: father chronic anemia (sickle cell), grandmother elderly
No joint complaint'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 8 ปี 4 วัน ก่อนเป็น chickenpox + influenza, แม่ให้ aspirin ลดไข้ ตอนนี้ vomiting persistent 24 ชม + ซึม + irritable → lethargic + confused → in coma, no fever now

V/S: HR 122, BP 132/88, RR 24, Temp 37.0°C
Gen: lethargic, GCS 11, hepatomegaly 3 cm, no jaundice, decerebrate posturing

ALT 850, AST 920, NH3 280 (high), INR 2.4, hypoglycemia 48, glucose, no bilirubin elevation
Brain CT: cerebral edema', '[{"label":"A","text":"Antibiotic only"},{"label":"B","text":"Reye Syndrome (acute encephalopathy + fatty liver, association salicylate + viral illness"},{"label":"C","text":"Steroid alone"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Reye Syndrome (acute encephalopathy + fatty liver, association salicylate + viral illness — varicella/influenza): admit PICU; aggressive management cerebral edema — head of bed 30°, intubation + mild hyperventilation transient, osmotherapy (mannitol 0.25-1 g/kg or 3% hypertonic saline 2.5-5 mL/kg), maintain CPP, monitor ICP (consider invasive ICP monitor), avoid hypotonic fluids; correct hypoglycemia — D10W (often need ongoing infusion + hyperglycemic state target); correct coagulopathy — vitamin K, FFP if bleeding/procedure; correct electrolyte derangements + avoid hyponatremia (worsens edema); manage hyperammonemia — lactulose, neomycin/rifaximin (limited evidence in Reye but tradition); avoid sedatives/hepatotoxic; supportive — temperature regulation, GI prophylaxis, DVT prophylaxis if able, infection surveillance; rule out other causes (inborn errors of metabolism — urine organic acids, acylcarnitine, ammonia, lactate — especially recurrent Reye-like → MCAD/OTC etc); liver transplant evaluation for refractory liver failure; prevention — AVOID aspirin in children with viral illness/varicella/influenza (FDA black box) — use acetaminophen/ibuprofen; reportable to CDC; long-term: high mortality 20-40%, neurologic sequelae in survivors

---

Reye syndrome = aspirin + viral illness (varicella, influenza) classic. Hepatic + brain dysfunction without jaundice + hyperammonemia + hypoglycemia + coagulopathy. Management ICU + cerebral edema + supportive. RULE OUT inborn errors metabolism. PREVENT — no aspirin in kids with viral illness (use acetaminophen).', NULL,
  'hard', 'neurology', 'review',
  'pediatrics', 'basic_science', 'neurology', 'peds',
  'Reye Syndrome Surveillance CDC; AAP Avoidance of Aspirin in Children', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 8 ปี 4 วัน ก่อนเป็น chickenpox + influenza, แม่ให้ aspirin ลดไข้ ตอนนี้ vomiting persistent 24 ชม + ซึม + irritable → lethargic + confused → in coma, no fever now

V/S: HR 122, BP 132/88, RR 24, Temp 37.0°C
Gen: lethargic, GCS 11, hepatomegaly 3 cm, no jaundice, decerebrate posturing

ALT 850, AST 920, NH3 280 (high), INR 2.4, hypoglycemia 48, glucose, no bilirubin elevation
Brain CT: cerebral edema'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกชายอายุ 24 hr ก่อน discharge แม่ถามว่าทำไมต้องเจาะส้นเท้า ผ่านมาสองวันได้รับ heel-stick "PKU test"', '[{"label":"A","text":"Heel-stick tests only PKU"},{"label":"B","text":"Universal Newborn Screening (NBS) per state mandates"},{"label":"C","text":"Optional only"},{"label":"D","text":"Wait until 6 weeks"},{"label":"E","text":"Single disease test"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Universal Newborn Screening (NBS) per state mandates — typically tests > 30 conditions ในแผง expanded screening (US RUSP / Thai NBS): metabolic — phenylketonuria, MSUD, homocystinuria, tyrosinemia, galactosemia, fatty acid oxidation (MCAD, VLCAD, LCHAD), organic acidemias (MMA, PA, IVA, GA1); endocrine — congenital hypothyroidism (CH), congenital adrenal hyperplasia (CAH); hemoglobinopathies — sickle cell, beta-thalassemia; cystic fibrosis (IRT ± DNA), severe combined immunodeficiency (SCID — TREC assay), spinal muscular atrophy (SMA), lysosomal storage disease (Pompe, MPS-I, others — newer additions), critical congenital heart disease (CCHD — pulse oximetry), hearing screen (OAE/AABR); rationale — early detection of treatable disorders to prevent disability + death (success stories — PKU, CH, CAH, MCAD, SCD); collection 24-48 hr to allow milk feeding (avoid false negatives); positive screen = NOT diagnosis (confirmatory testing needed urgent), counsel families carefully; primary care + subspecialty referral for positives; education + family-centered approach; recheck — if early discharge before 24 hr or NICU/transfusion → repeat; coordinated with genetic counseling

---

NBS = public health success — early detection treatable diseases. US RUSP > 30 conditions, varies by state. Heel-stick 24-48 hr + pulse oximetry + hearing screen. Positive screen needs confirmatory testing + urgent subspecialty. Improves outcomes for many treatable conditions.', NULL,
  'easy', 'endocrine_metabolic', 'review',
  'pediatrics', 'basic_science', 'endocrine_metabolic', 'peds',
  'ACMG/HRSA Recommended Uniform Screening Panel (RUSP); Thai NBS Program', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกชายอายุ 24 hr ก่อน discharge แม่ถามว่าทำไมต้องเจาะส้นเท้า ผ่านมาสองวันได้รับ heel-stick "PKU test"'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 18 เดือน BW 11 kg ถ่ายเหลว 8 ครั้ง/วัน + อาเจียน 6 ครั้ง × 2 วัน หลังจากเพื่อน daycare เป็นเหมือนกัน, no blood in stool, ไม่ไข้สูง

V/S: HR 168, BP 88/52, RR 32, Temp 37.6°C, capillary refill 3-4 sec
Gen: lethargic แต่ rousable, sunken eyes, dry mucous membranes, decreased skin turgor, น้ำหนักลด 800 g (~7% loss) — moderate dehydration

Lab: Na 138, K 3.5, HCO3 18, glucose 88, BUN 28
Stool: rotavirus antigen positive', '[{"label":"A","text":"Antibiotic IV broad-spectrum"},{"label":"B","text":"Acute viral gastroenteritis with moderate dehydration"},{"label":"C","text":"Bowel rest NPO 24 hr"},{"label":"D","text":"Antimotility agent"},{"label":"E","text":"Discharge no rehydration"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute viral gastroenteritis with moderate dehydration: ORS (Oral Rehydration Solution) per WHO/AAP — first-line for mild-moderate even with vomiting; calculate deficit ~50-100 mL/kg = 600-1,100 mL replace over 4 hr in small frequent volumes (5 mL q1-2 min, gradually increase); ondansetron oral 0.15 mg/kg single dose (1 dose) reduces vomiting + admission (evidence-based); IV fluid bolus 20 mL/kg NSS only if severe dehydration/shock/failed ORS; reassess hydration q1-2 hr; resume regular age-appropriate diet (BRAT diet not necessary — continued breastfeeding, formula, regular food OK as tolerated, NO dilution); rotavirus vaccine prevention (RV1 or RV5); zinc supplement 10-20 mg/d × 10-14 d (developing world WHO — modest benefit); probiotics (Lactobacillus GG, S. boulardii) shorten duration mild benefit; AVOID — antimotility (loperamide) ในเด็กเล็ก; antiemetic limited to ondansetron; antidiarrheal limited; counsel — return if dehydration worsens, blood, high fever, persistent vomit; admit if cannot tolerate ORS, severe dehydration, electrolyte imbalance, < 6 mo with severe vomiting

---

Viral gastroenteritis = leading cause peds diarrhea. Rotavirus most common (declining with vaccine). ORS first-line — even with vomiting (give small frequent). Ondansetron evidence-based reduces vomit + admission. Resume normal diet ASAP. Avoid antimotility. Hand hygiene + vaccine prevention.', NULL,
  'medium', 'gi', 'review',
  'pediatrics', 'clinical_decision', 'gi', 'peds',
  'AAP Clinical Report Acute Gastroenteritis; WHO IMCI Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 18 เดือน BW 11 kg ถ่ายเหลว 8 ครั้ง/วัน + อาเจียน 6 ครั้ง × 2 วัน หลังจากเพื่อน daycare เป็นเหมือนกัน, no blood in stool, ไม่ไข้สูง

V/S: HR 168, BP 88/52, RR 32, Temp 37.6°C, capillary refill 3-4 sec
Gen: lethargic แต่ rousable, sunken eyes, dry mucous membranes, decreased skin turgor, น้ำหนักลด 800 g (~7% loss) — moderate dehydration

Lab: Na 138, K 3.5, HCO3 18, glucose 88, BUN 28
Stool: rotavirus antigen positive'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 12 mo BW 9 kg ถ่ายเหลว 15 ครั้ง + อาเจียน 8 ครั้ง × 36 ชม นาน 4 วันก่อน (cholera outbreak ในชุมชน) ปัสสาวะไม่ออก 12 ชม, lethargic

V/S: HR 198 (thready), BP 60/30 (palpable), RR 48, SpO2 96%, Temp 36.2°C, capillary refill 6 sec, BW 8 kg (loss 1 kg = ~11% severe)
Gen: lethargic-obtunded, deep sunken eyes, no tears, dry mucous, very poor turgor, cold extremities

Lab: Na 152 (hypernatremic), K 2.8, HCO3 8, BUN 48, Cr 1.4, glucose 60, pH 7.10
Stool RDT: V. cholerae O1 positive', '[{"label":"A","text":"Slow oral rehydration only"},{"label":"B","text":"Severe Hypovolemic Shock + Severe Hypernatremic Dehydration (cholera)"},{"label":"C","text":"Subcutaneous fluid"},{"label":"D","text":"Antiemetic alone"},{"label":"E","text":"Antifungal"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe Hypovolemic Shock + Severe Hypernatremic Dehydration (cholera): URGENT IV/IO access ภายใน 5 นาที (alternative 3-mortar drill); RAPID IV bolus Ringer''s Lactate 20 mL/kg over 5-15 min repeat as needed (typical 60 mL/kg first hour); reassess after EACH bolus (mental status, perfusion, HR, BP, UO); IV antibiotic — Doxycycline 4.4 mg/kg single dose PO/IV OR Azithromycin 20 mg/kg single dose OR Erythromycin (alternative cholera-specific to reduce stool output + duration); for severe HYPERNATREMIA correct slowly to AVOID cerebral edema — once shock resolved, replace remaining deficit + ongoing losses over 48-72 hours, reduce serum Na ≤ 10-12 mEq/L per 24 hr (calculate free water deficit, give D5 ¼-½ NSS depending); correct hypokalemia (caution if renal failure) + acidosis (often self-corrects with perfusion); strict ins/outs; monitor for AKI; transfer to ICU; once tolerating PO, transition ORS + continue antibiotic; isolation + infection control (notifiable disease); public health reporting; family contact prophylaxis if outbreak; long-term: cholera vaccine for outbreak/endemic

---

Severe dehydration + shock = IV/IO emergency. 20 mL/kg LR bolus repeat × reassess. Cholera = rapid massive losses, dyhydration may progress hours. Hypernatremic correction slow (≤ 12 mEq/L per 24 hr) — too fast = cerebral edema. Antibiotic reduces stool output + duration. Notifiable.', NULL,
  'hard', 'gi', 'review',
  'pediatrics', 'ems_mgmt', 'gi', 'peds',
  'WHO Cholera Treatment Guidelines; IMCI', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 12 mo BW 9 kg ถ่ายเหลว 15 ครั้ง + อาเจียน 8 ครั้ง × 36 ชม นาน 4 วันก่อน (cholera outbreak ในชุมชน) ปัสสาวะไม่ออก 12 ชม, lethargic

V/S: HR 198 (thready), BP 60/30 (palpable), RR 48, SpO2 96%, Temp 36.2°C, capillary refill 6 sec, BW 8 kg (loss 1 kg = ~11% severe)
Gen: lethargic-obtunded, deep sunken eyes, no tears, dry mucous, very poor turgor, cold extremities

Lab: Na 152 (hypernatremic), K 2.8, HCO3 8, BUN 48, Cr 1.4, glucose 60, pH 7.10
Stool RDT: V. cholerae O1 positive'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกหญิงอายุ 6 wk term BW 4 kg jaundice ต่อเนื่อง ตั้งแต่ 2 wk + acholic stools (pale/clay-colored) + dark urine + hepatomegaly + คาดว่าเป็น ''physiologic jaundice'' ก่อนหน้านี้

Growth ปกติ, no spleen palpable, alert, no rash
Lab: Total bilirubin 9.2 (DIRECT 5.8 — conjugated/direct > 2 abnormal!), ALT 220, AST 280, GGT 380, ALP 540, albumin 3.6
Abdominal US: gallbladder small/absent, triangular cord sign, no obvious bile duct
HIDA scan: no excretion into bowel after 24 hr (even with phenobarbital priming)
Liver biopsy: bile duct proliferation + ductopenia + portal fibrosis = consistent with biliary atresia', '[{"label":"A","text":"Wait + recheck 3 mo"},{"label":"B","text":"Biliary Atresia (progressive obliterative cholangiopathy)"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Surgery age 1"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Biliary Atresia (progressive obliterative cholangiopathy) — TIME-CRITICAL Dx: Kasai portoenterostomy (hepatic portoenterostomy connecting Roux limb of jejunum to porta hepatis) — outcomes depend strongly on age at surgery — best if < 60 days of age (success bile flow > 70%, vs < 30% if > 90 d); refer urgent hepatobiliary surgical center; pre-op: vitamin K + correct coagulopathy, optimize nutrition; post-op care — fat-soluble vitamin supplementation (ADEK), MCT formula, prophylactic antibiotic (TMP-SMX or neomycin) to prevent cholangitis (common complication post-Kasai); ursodeoxycholic acid 10-20 mg/kg/d may improve bile flow; growth + nutrition monitoring; treat cholangitis with broad-spectrum IV antibiotic + admit; long-term — even successful Kasai 50% require liver transplant by age 20 (chronic liver disease progresses); refer pediatric liver transplant center early; family support + education + transition adult; counsel family — without treatment, biliary cirrhosis + death by 2-3 yr; key teaching: ANY infant with jaundice > 2 wk needs fractionated bilirubin, direct > 2 or > 20% total = pathologic

---

Biliary atresia = #1 indication peds liver transplant. ANY infant jaundice > 2 wk = check direct bilirubin (don''t dismiss). Kasai < 60 days = best outcome. Even with Kasai, 50% need transplant. Multidisciplinary HCC center. Cholangitis prophylaxis. ADEK + nutrition.', NULL,
  'hard', 'gi', 'review',
  'pediatrics', 'clinical_decision', 'gi', 'peds',
  'NASPGHAN/AASLD Guidelines on Cholestasis in Infants 2017; Pediatric Liver Transplant Society', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกหญิงอายุ 6 wk term BW 4 kg jaundice ต่อเนื่อง ตั้งแต่ 2 wk + acholic stools (pale/clay-colored) + dark urine + hepatomegaly + คาดว่าเป็น ''physiologic jaundice'' ก่อนหน้านี้

Growth ปกติ, no spleen palpable, alert, no rash
Lab: Total bilirubin 9.2 (DIRECT 5.8 — conjugated/direct > 2 abnormal!), ALT 220, AST 280, GGT 380, ALP 540, albumin 3.6
Abdominal US: gallbladder small/absent, triangular cord sign, no obvious bile duct
HIDA scan: no excretion into bowel after 24 hr (even with phenobarbital priming)
Liver biopsy: bile duct proliferation + ductopenia + portal fibrosis = consistent with biliary atresia'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 7 ปี ไข้ + คลื่นไส้ + อ่อนเพลีย + ปวดท้อง + เบื่ออาหาร × 1 wk เพิ่งกลับจากเที่ยว rural area กิน street food, น้ำดื่มต่างถิ่น ตอนนี้ตัวเหลือง + ปัสสาวะสีเข้ม + อุจจาระสีอ่อนลง

V/S: BW 22 kg, mild jaundice, hepatomegaly + tender, no encephalopathy, alert

Lab: Total bilirubin 8.5 (mixed elevation, direct 4.5), ALT 1,820, AST 1,640 (very high), ALP 240, INR 1.1, no coagulopathy yet
Anti-HAV IgM POSITIVE, anti-HEV negative, anti-HBV negative, anti-HCV negative', '[{"label":"A","text":"Steroid for hepatitis"},{"label":"B","text":"Acute Hepatitis A (self-limited typically in children)"},{"label":"C","text":"Liver transplant immediately"},{"label":"D","text":"Antibiotic"},{"label":"E","text":"Discharge no follow-up"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Hepatitis A (self-limited typically in children): supportive care — usually completely self-resolving, especially in younger kids; rest as tolerated; adequate nutrition (low-fat diet only as tolerance with nausea, no restriction need); maintain hydration; AVOID hepatotoxic drugs (acetaminophen — restrict to therapeutic doses if needed, NSAIDs, alcohol in adolescents); ANTIVIRAL NOT INDICATED (HAV self-limit); monitor for fulminant hepatitis (rare 0.4%) — daily clinical assessment + LFT + INR + glucose; admit if vomiting can''t maintain hydration, severe pain, signs of coagulopathy or encephalopathy (INR > 1.5 + AMS = pediatric acute liver failure → transplant center referral); isolation — fecal-oral spread; school exclusion 1 wk post-jaundice onset; hand hygiene critical; CONTACTS — post-exposure prophylaxis with HAV vaccine within 14 days (preferred immunocompetent + age 1-40) OR IG for selected (< 12 mo, > 40 yr, immunocompromised, chronic liver dz, pregnant); HAV vaccine routine 12-23 mo (Thai EPI + ACIP); reportable to public health; counsel hygiene + safe food/water + vaccine education

---

HAV = fecal-oral, self-limited in kids (more severe adults). Supportive care. Monitor for fulminant (rare). Post-exposure prophylaxis = HAV vaccine within 14 d most. HAV vaccine routine 12-23 mo + travelers. Hygiene + food/water safety. Reportable.', NULL,
  'easy', 'gi', 'review',
  'pediatrics', 'clinical_decision', 'gi', 'peds',
  'AAP Red Book 2024 Hepatitis A; CDC ACIP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 7 ปี ไข้ + คลื่นไส้ + อ่อนเพลีย + ปวดท้อง + เบื่ออาหาร × 1 wk เพิ่งกลับจากเที่ยว rural area กิน street food, น้ำดื่มต่างถิ่น ตอนนี้ตัวเหลือง + ปัสสาวะสีเข้ม + อุจจาระสีอ่อนลง

V/S: BW 22 kg, mild jaundice, hepatomegaly + tender, no encephalopathy, alert

Lab: Total bilirubin 8.5 (mixed elevation, direct 4.5), ALT 1,820, AST 1,640 (very high), ALP 240, INR 1.1, no coagulopathy yet
Anti-HAV IgM POSITIVE, anti-HEV negative, anti-HBV negative, anti-HCV negative'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารก preterm GA 27 wk BW 850 g อายุ 8 วัน on ventilator + surfactant ตอนแรกดีขึ้น แต่จู่ ๆ ต้อง FiO2 เพิ่มจาก 0.25 → 0.45, RR เพิ่ม, persistent murmur new + bounding pulses + wide pulse pressure (50/25, mean 33) + active precordium

Echo: large PDA 3 mm + L-R shunt + LA/LV enlargement + reverse diastolic flow descending aorta (steal phenomenon)', '[{"label":"A","text":"Wait — PDA closes naturally"},{"label":"B","text":"Hemodynamically significant Patent Ductus Arteriosus (hsPDA) premature"},{"label":"C","text":"Surgery routinely all preemies"},{"label":"D","text":"Antibiotic alone"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hemodynamically significant Patent Ductus Arteriosus (hsPDA) premature: fluid restriction (110-130 mL/kg/d); ventilation optimization (high PEEP); pharmacological closure — Indomethacin 0.2 mg/kg q12h × 3 doses (classical) OR Ibuprofen 10 mg/kg then 5 mg/kg q24h × 2 doses (similar efficacy + fewer renal/GI side effects) OR oral acetaminophen 15 mg/kg q6h × 3-7 days (newer alternative — equally effective in some studies + safer for renal/platelet) — monitor renal function, platelets, NEC, IVH; consider transcatheter PDA closure (Amplatzer Piccolo) increasingly used preterm — particularly if pharm contraindicated/failed; SURGICAL ligation reserved for failed pharm + transcatheter not feasible (now used less due to long-term morbidity); CONSERVATIVE management — many small PDA close spontaneously even in preemies, recent trials (PDA-TOLERATE, BeNeDuctus) question aggressive treatment — selective treatment with hsPDA only; if not hemodynamically significant → observe; monitor RFFD (recurrent BPD, IVH, NEC, mortality); coordinate neonatology + cardiology

---

PDA premature = common, may close spontaneously. Treatment debated — recent trials (BeNeDuctus, PDA-TOLERATE) favor selective for hsPDA. Pharm: indomethacin or ibuprofen (renal/GI risk) or acetaminophen (safer profile). Transcatheter Piccolo emerging. Surgery rarely.', NULL,
  'medium', 'cardiovascular', 'review',
  'pediatrics', 'clinical_decision', 'cardiovascular', 'peds',
  'AAP COFN; BeNeDuctus + PDA-TOLERATE trials; AHA Pediatric', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารก preterm GA 27 wk BW 850 g อายุ 8 วัน on ventilator + surfactant ตอนแรกดีขึ้น แต่จู่ ๆ ต้อง FiO2 เพิ่มจาก 0.25 → 0.45, RR เพิ่ม, persistent murmur new + bounding pulses + wide pulse pressure (50/25, mean 33) + active precordium

Echo: large PDA 3 mm + L-R shunt + LA/LV enlargement + reverse diastolic flow descending aorta (steal phenomenon)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 12 ปี s/p TOF repair 8 ปีที่แล้ว มี residual VSD + AR ไข้ต่ำ ๆ persistent × 3 wk + เหนื่อย + เบื่ออาหาร + weight loss 2 kg ก่อนหน้าทำฟันโดยไม่ได้ antibiotic

V/S: HR 102, BP 102/40 (wide PP from AR), Temp 38.4°C, BW 32 kg
PE: pale, splinter hemorrhages, Roth spots fundus, new murmur AR worse, splenomegaly mild

CBC: WBC 14,200, Hb 9.8 (chronic), CRP 78, ESR 92
Blood culture × 3 separate sites POSITIVE Strep viridans
TTE then TEE: vegetation 8 mm aortic valve + small abscess root', '[{"label":"A","text":"Outpatient oral antibiotic"},{"label":"B","text":"Infective Endocarditis confirmed (modified Duke criteria"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Steroid"},{"label":"E","text":"Surgery without antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Infective Endocarditis confirmed (modified Duke criteria — major: typical organism + echo evidence): admit + IV antibiotic — Penicillin G 200,000-300,000 U/kg/d ÷ q4-6h OR Ceftriaxone 100 mg/kg/d once daily (for penicillin-susceptible Strep viridans) + Gentamicin 3 mg/kg/d ÷ q8h × first 2 weeks (synergy short-course); total duration 4 weeks IV (uncomplicated native valve) or 6 weeks (prosthetic, complications); blood culture follow-up 48-72 hr q week × duration; daily TTE/weekly serial monitoring vegetation + complications; pediatric infectious disease + cardiology + cardiac surgery consultation; SURGICAL INDICATIONS (~50% need surgery): heart failure, abscess, persistent bacteremia despite appropriate antibiotic, large vegetation > 10 mm with embolism, fungal IE, prosthetic dehiscence; complications surveillance — embolic events (stroke, kidney, spleen, mycotic aneurysm), heart failure, abscess; supportive — anti-HF if HF, anticoagulation NOT routine; oral health + dental followup; secondary prevention — AHA 2007/2021: antibiotic prophylaxis for selected dental/respiratory procedures in high-risk lesions only (prosthetic, prior IE, cyanotic unrepaired, < 6 mo post-repair with material, repair with residual defect adjacent to material, transplant valvulopathy); long-term: cardiology follow-up + heart failure monitoring

---

IE in kids with CHD = important consideration. Modified Duke criteria. TEE > TTE for vegetations/abscess. Long-course IV antibiotic + surgical evaluation for indications. AHA 2007/2021: prophylaxis only highest-risk lesions, not all murmurs. Oral hygiene + dental.', NULL,
  'medium', 'cardiovascular', 'review',
  'pediatrics', 'clinical_decision', 'cardiovascular', 'peds',
  'AHA Infective Endocarditis Guidelines 2015 + 2021', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 12 ปี s/p TOF repair 8 ปีที่แล้ว มี residual VSD + AR ไข้ต่ำ ๆ persistent × 3 wk + เหนื่อย + เบื่ออาหาร + weight loss 2 kg ก่อนหน้าทำฟันโดยไม่ได้ antibiotic

V/S: HR 102, BP 102/40 (wide PP from AR), Temp 38.4°C, BW 32 kg
PE: pale, splinter hemorrhages, Roth spots fundus, new murmur AR worse, splenomegaly mild

CBC: WBC 14,200, Hb 9.8 (chronic), CRP 78, ESR 92
Blood culture × 3 separate sites POSITIVE Strep viridans
TTE then TEE: vegetation 8 mm aortic valve + small abscess root'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 8 ปี idiopathic dilated cardiomyopathy ที่ Dx 6 mo ago บน carvedilol + enalapril มา ED ด้วยอาการเหนื่อยมาก ขณะพักไม่หาย + ขาบวม + น้ำหนักเพิ่ม 3 kg ใน 1 wk + ปัสสาวะน้อย

V/S: HR 132, BP 88/58, RR 32, SpO2 92%, BW 28 kg
Gen: cachectic, JVD, S3 gallop, hepatomegaly 5 cm, bilateral pretibial pitting edema, cool extremities, prolonged cap refill 4 sec

Lab: BNP 4,200, Cr 1.2 (baseline 0.6), Na 132, K 4.2
Echo: EF 18% (down from 28%), severe LV dilation, severe MR
INTERMACS profile 3-4', '[{"label":"A","text":"Diuretic alone"},{"label":"B","text":"Pediatric Decompensated Heart Failure (cardiogenic shock approaching)"},{"label":"C","text":"ACEI alone"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Vasodilator only without inotrope"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Decompensated Heart Failure (cardiogenic shock approaching): admit ICU; ABC + supplemental O2 (BiPAP/HFNC, intubation if respiratory failure); hold/pause carvedilol acutely (negative inotrope, restart when compensated); continue ACEI if BP tolerates (otherwise hold); IV diuretic — furosemide 1-2 mg/kg IV bolus then continuous infusion 0.1-0.5 mg/kg/hr titrate UO; correct electrolytes (K, Mg); INOTROPIC SUPPORT — Milrinone 0.25-0.75 mcg/kg/min (preferred — inodilator, reduces afterload + improves cardiac output, less arrhythmogenic, avoid if hypotension or renal failure) OR Dobutamine 5-15 mcg/kg/min OR low-dose epinephrine if hypotension; mechanical circulatory support — ECMO or VAD (Berlin Heart EXCOR pediatric LVAD widely used) if refractory to medical management = bridge to transplant; advanced HF + transplant team referral early (urgent listing); strict ins/outs + daily weight; volume optimization; address arrhythmia (ICD for primary/secondary prevention SCD); long-term once stable — beta-blocker + ACEI/ARB + spironolactone + sometimes ivabradine; sacubitril/valsartan emerging peds (PANORAMA trial); device therapy (ICD, CRT) selected; nutrition + cardiac rehab; psychosocial; transition adult; transplant outcomes peds excellent (1-yr 90%+, 5-yr 80%)

---

Pediatric decompensated HF = ICU + careful balance. Milrinone preferred inotrope. Mechanical support (ECMO, Berlin Heart) bridge to transplant. Hold beta-blocker acutely. Continue ACEI if tolerates. Transplant evaluation early. Long-term: optimize medical + device + transplant.', NULL,
  'hard', 'cardiovascular', 'review',
  'pediatrics', 'clinical_decision', 'cardiovascular', 'peds',
  'AHA Pediatric Heart Failure Guidelines 2021; ISHLT Pediatric', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 8 ปี idiopathic dilated cardiomyopathy ที่ Dx 6 mo ago บน carvedilol + enalapril มา ED ด้วยอาการเหนื่อยมาก ขณะพักไม่หาย + ขาบวม + น้ำหนักเพิ่ม 3 kg ใน 1 wk + ปัสสาวะน้อย

V/S: HR 132, BP 88/58, RR 32, SpO2 92%, BW 28 kg
Gen: cachectic, JVD, S3 gallop, hepatomegaly 5 cm, bilateral pretibial pitting edema, cool extremities, prolonged cap refill 4 sec

Lab: BNP 4,200, Cr 1.2 (baseline 0.6), Na 132, K 4.2
Echo: EF 18% (down from 28%), severe LV dilation, severe MR
INTERMACS profile 3-4'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารก term DOL 3 ยังไม่ถ่ายขี้เทา + วันที่ 2 อาเจียน bilious + abdominal distension + เมื่อใส่ rectal tube → explosive passage gas + meconium then re-distends

Family: cousin with similar history
V/S: HR 152, RR 48, mild distress, distended abdomen, hyperactive bowel sounds, empty rectal vault on DRE, no fistula no anal stenosis

AXR: dilated loops + paucity rectal air
Contrast enema: transition zone sigmoid + delayed emptying
Rectal suction biopsy: AGANGLIONIC + hypertrophied nerve fibers + acetylcholinesterase + = Hirschsprung disease', '[{"label":"A","text":"Wait — outgrow"},{"label":"B","text":"Hirschsprung Disease (congenital aganglionic megacolon, classic)"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Laxative"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hirschsprung Disease (congenital aganglionic megacolon, classic): pediatric surgery referral urgent; initial management — saline rectal irrigations (decompression, prevent enterocolitis) BID-TID until surgery; broad-spectrum antibiotic prophylaxis (Hirschsprung-associated enterocolitis HAEC is life-threatening — fever + distension + bloody/explosive stool, mortality 30%, treat early with IV antibiotic + irrigation + NPO + IV fluids + surgical assessment for perforation/toxic megacolon); definitive surgery — pull-through procedure (Soave, Swenson, Duhamel) — typically performed 3-6 mo of age (single-stage primary pull-through if stable, or staged with colostomy if extensive disease/severe enterocolitis); post-op — irrigation continued first months, monitor for HAEC, soiling/constipation common (manage with bowel program, biofeedback, sphincter assessment); long-term: most achieve near-normal continence (60-80%), but HAEC risk persists; total colonic Hirschsprung worse prognosis; family genetic counseling (RET mutation, 5-10% familial); associated conditions screen — Down syndrome (CRSI), other syndromes; long-term follow-up bowel function + growth; education families about HAEC signs + emergency contact

---

Hirschsprung = delayed passage meconium (> 48 hr term) + bowel obstruction + transition zone. Confirm rectal biopsy (aganglionosis). HAEC = life-threatening complication. Pull-through 3-6 mo. Saline irrigations bridge. Long-term continence usually good. Genetic screening selected.', NULL,
  'hard', 'gi', 'review',
  'pediatrics', 'clinical_decision', 'gi', 'peds',
  'ACP Hirschsprung Disease Consensus; APSA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารก term DOL 3 ยังไม่ถ่ายขี้เทา + วันที่ 2 อาเจียน bilious + abdominal distension + เมื่อใส่ rectal tube → explosive passage gas + meconium then re-distends

Family: cousin with similar history
V/S: HR 152, RR 48, mild distress, distended abdomen, hyperactive bowel sounds, empty rectal vault on DRE, no fistula no anal stenosis

AXR: dilated loops + paucity rectal air
Contrast enema: transition zone sigmoid + delayed emptying
Rectal suction biopsy: AGANGLIONIC + hypertrophied nerve fibers + acetylcholinesterase + = Hirschsprung disease'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 6 ปี ติดเชื้อ Salmonella gastroenteritis 5 วันแล้ว ตอนนี้ปัสสาวะลด < 0.5 mL/kg/hr × 12 hr + edema mild + lethargic

V/S: BP 132/86, HR 102, BW 22 kg
PE: mild dehydration improved but edema developing, no rash, no joint, no purpura

Lab: BUN 64, Cr 2.4 (baseline 0.5), K 5.8, P 6.2, Ca 8.0, HCO3 16, Albumin 3.4
UA: granular casts, mild proteinuria 1+, no RBC, eosinophils negative, Na urine 60 mmol/L, FeNa 3% (intrinsic)
US: kidneys normal size + echogenicity, no obstruction', '[{"label":"A","text":"High-dose diuretic alone"},{"label":"B","text":"AKI Stage 3 (Cr > 3× baseline)"},{"label":"C","text":"Restrict all fluid + protein severely"},{"label":"D","text":"Antibiotic alone"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** AKI Stage 3 (Cr > 3× baseline) — likely intrinsic ATN from prolonged hypovolemic-prerenal then ATN (also consider HUS but no MAHA/thrombocytopenia here, post-infectious GN, drug-induced, NSAID-related): assess + treat reversible factors — adequate volume status (carefully — if hypovolemic give IV fluid challenge 10-20 mL/kg, otherwise restrict to insensible + UO if euvolemic/overloaded); STOP nephrotoxic drugs (NSAID, aminoglycoside, IV contrast, ACEI); manage HYPERKALEMIA — calcium gluconate (cardiac protection if ECG changes), insulin + glucose, albuterol nebulizer, sodium bicarbonate if acidotic, kayexalate (selected pediatric — caution), dialysis if refractory or > 6.5; correct acidosis (sodium bicarb if pH < 7.2 or HCO3 < 12); manage hyperphosphatemia + hypocalcemia — phosphate binder; nutritional support — adequate calorie, restrict K + P + Na, modest protein (1-1.5 g/kg/d, NOT severe protein restriction); RENAL REPLACEMENT THERAPY indications (peds AEIOU): A — Acidosis severe, E — Electrolyte (K refractory), I — Intoxication, O — Overload severe with respiratory compromise, U — Uremia symptomatic; modalities — hemodialysis (typical for child), CRRT (hemodynamically unstable, ICU), peritoneal dialysis (younger, available, hemodynamically tolerant); pediatric nephrology consultation; monitor recovery (typical ATN recovers 1-3 wk); long-term follow-up — CKD risk 30-50% even after recovery, BP monitoring, growth, schooling

---

Pediatric AKI = KDIGO criteria. Common causes: prerenal (dehydration), ATN, HUS, GN, obstruction, drug-induced. Stop nephrotoxin. Manage hyperK + acidosis + fluid carefully. RRT for refractory AEIOU. Long-term CKD risk → follow-up. Multidisciplinary.', NULL,
  'hard', 'renal_gu', 'review',
  'pediatrics', 'clinical_decision', 'renal_gu', 'peds',
  'KDIGO AKI Guidelines; IPNA Pediatric Nephrology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 6 ปี ติดเชื้อ Salmonella gastroenteritis 5 วันแล้ว ตอนนี้ปัสสาวะลด < 0.5 mL/kg/hr × 12 hr + edema mild + lethargic

V/S: BP 132/86, HR 102, BW 22 kg
PE: mild dehydration improved but edema developing, no rash, no joint, no purpura

Lab: BUN 64, Cr 2.4 (baseline 0.5), K 5.8, P 6.2, Ca 8.0, HCO3 16, Albumin 3.4
UA: granular casts, mild proteinuria 1+, no RBC, eosinophils negative, Na urine 60 mmol/L, FeNa 3% (intrinsic)
US: kidneys normal size + echogenicity, no obstruction'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 11 ปี BMI 28 (severe obesity, > 99th percentile) ไม่มีอาการ มา clinic เพื่อ check-up ครู school พบ BP สูงในห้อง infirmary 3 ครั้ง

Clinic BP 3 ครั้ง q1 min: 142/92, 138/90, 140/88 (all > 95th percentile for age/height — confirmed stage 1 HT > 95th + > 1 yr); 24-hr ABPM mean SBP > 95th + > 1 yr — confirmed sustained HT

Hx: father HT, no medication, no symptoms; sleep snoring witnessed apnea by mother
Lab: lipid mildly elevated, glucose 102 (impaired), HbA1c 5.9 (pre-diabetes), Cr normal, no proteinuria, TSH normal
US renal: normal
Echo: mild LVH (LV mass index increased)', '[{"label":"A","text":"Antihypertensive only without lifestyle"},{"label":"B","text":"Pediatric Hypertension Stage 1 (likely primary/essential associated with obesity)"},{"label":"C","text":"Discharge no follow-up"},{"label":"D","text":"Surgery"},{"label":"E","text":"Single BP check sufficient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Hypertension Stage 1 (likely primary/essential associated with obesity) — AAP 2017 Clinical Practice Guideline: confirm BP > 95th percentile on 3 separate occasions OR ABPM; obesity treatment cornerstone — MULTICOMPONENT lifestyle modification (DASH diet, reduce sodium < 1500-2300 mg/d, increase fruits/vegetables/whole grains, limit sugar-sweetened beverages); physical activity ≥ 60 min/d moderate-vigorous, limit screen time < 2 hr/d; weight management + family-based behavioral therapy; address sleep — screen + treat OSA (polysomnography given snoring + apnea, likely contributes); secondary cause workup — UA + Cr + electrolytes + lipids + glucose + insulin + TSH + plasma renin + aldosterone if young/severe, renal US + ECHO for end-organ damage (LVH suggests need treatment); INDICATIONS pharmacological therapy — secondary HT, symptomatic HT, target organ damage (LVH, CKD, retinopathy), Stage 2 HT, lifestyle modification failure for Stage 1, persistent risk; FIRST-LINE drugs — ACE inhibitor (lisinopril) OR ARB (losartan) OR CCB (amlodipine) OR thiazide; AVOID — abrupt withdrawal beta-blocker, ACEI in pregnancy potential; target < 90th percentile (or < 130/80 adolescents); monitor q3-6 mo + adjust; address comorbid CV risk factors (lipid, glucose); transition to adult care; PARENT/family lifestyle support critical

---

Pediatric HT rising prevalence (obesity epidemic). AAP 2017: new lower BP thresholds. Confirm with multiple measurements + ABPM. Lifestyle modification mainstay. Pharm for secondary, symptomatic, end-organ damage, Stage 2, refractory. ACEI/ARB/CCB/thiazide first-line. Address comorbid CV risk.', NULL,
  'medium', 'cardiovascular', 'review',
  'pediatrics', 'clinical_decision', 'cardiovascular', 'peds',
  'AAP Clinical Practice Guideline: Screening and Management of HT in Children and Adolescents 2017', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 11 ปี BMI 28 (severe obesity, > 99th percentile) ไม่มีอาการ มา clinic เพื่อ check-up ครู school พบ BP สูงในห้อง infirmary 3 ครั้ง

Clinic BP 3 ครั้ง q1 min: 142/92, 138/90, 140/88 (all > 95th percentile for age/height — confirmed stage 1 HT > 95th + > 1 yr); 24-hr ABPM mean SBP > 95th + > 1 yr — confirmed sustained HT

Hx: father HT, no medication, no symptoms; sleep snoring witnessed apnea by mother
Lab: lipid mildly elevated, glucose 102 (impaired), HbA1c 5.9 (pre-diabetes), Cr normal, no proteinuria, TSH normal
US renal: normal
Echo: mild LVH (LV mass index increased)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 5 ปี chronic anemia + episodic jaundice + splenomegaly + gallstones (US) + family Hx (father had splenectomy, sister has spherocytosis)

V/S: BW 18 kg, mild scleral icterus, spleen palpable 4 cm BCM, no hepatomegaly

CBC: Hb 9.0, MCV 78, MCHC 38 (HIGH — diagnostic), retic 8%, increased RDW
Smear: spherocytes ++++ no central pallor, polychromasia
Coombs: NEGATIVE (excludes immune hemolysis)
Osmotic fragility increased; Eosin-5''-maleimide (EMA) flow cytometry: decreased fluorescence = HS
Indirect bilirubin elevated 4.5, LDH elevated, haptoglobin low', '[{"label":"A","text":"Splenectomy immediately for all"},{"label":"B","text":"Hereditary Spherocytosis (autosomal dominant most, spectrin/ankyrin defect)"},{"label":"C","text":"Iron supplementation"},{"label":"D","text":"Steroid lifelong"},{"label":"E","text":"Antibiotic prophylaxis only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hereditary Spherocytosis (autosomal dominant most, spectrin/ankyrin defect): folic acid 1 mg/day lifelong (high RBC turnover); blood transfusion only for aplastic crisis (Parvo B19) or severe symptomatic anemia; recheck CBC + reticulocyte q3-6 mo; ultrasound for gallstones (high prevalence — pigmented stone, prophylactic cholecystectomy at time of splenectomy if stones present); growth monitoring; INDICATIONS for SPLENECTOMY (typically delayed until > 6 yr to allow immune maturation, reduce sepsis risk): severe HS (Hb < 8, severe hyperbilirubinemia, growth failure, gallstones, frequent hospitalizations); subtotal/partial splenectomy emerging — preserves some immune function; PRE-SPLENECTOMY immunizations 2 wk before — pneumococcal (PCV13 + PPSV23), meningococcal (MenACWY + MenB), Hib + influenza annual; POST-SPLENECTOMY — penicillin prophylaxis (Pen V 125 mg BID < 5 yr, 250 mg BID > 5 yr) × minimum 5 years OR lifelong (varies), aspirin for thrombocytosis selected; education sepsis emergency response (fever > 38.5 → urgent evaluation, IV antibiotic — septic risk encapsulated organism lifelong); medical alert; family screening + genetic counseling (autosomal dominant 75%); transition adult

---

HS = most common hereditary hemolytic anemia. EMA flow cytometry standard test (+ osmotic fragility classical). Folate + monitoring + splenectomy for severe. Pre-splenectomy immunization critical. Post-splenectomy infection risk lifelong — counsel + prophylaxis + medical alert. Family screen.', NULL,
  'medium', 'hematology', 'review',
  'pediatrics', 'clinical_decision', 'hematology', 'peds',
  'British Society Haematology HS Guidelines 2012; AAP Hematology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 5 ปี chronic anemia + episodic jaundice + splenomegaly + gallstones (US) + family Hx (father had splenectomy, sister has spherocytosis)

V/S: BW 18 kg, mild scleral icterus, spleen palpable 4 cm BCM, no hepatomegaly

CBC: Hb 9.0, MCV 78, MCHC 38 (HIGH — diagnostic), retic 8%, increased RDW
Smear: spherocytes ++++ no central pallor, polychromasia
Coombs: NEGATIVE (excludes immune hemolysis)
Osmotic fragility increased; Eosin-5''-maleimide (EMA) flow cytometry: decreased fluorescence = HS
Indirect bilirubin elevated 4.5, LDH elevated, haptoglobin low'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 8 ปี post-op craniopharyngioma resection 3 วันก่อน, ตอนนี้ confused + lethargic + headache + nausea + ชัก × 1 ครั้ง brief

V/S: BP 110/72, HR 92, BW 26 kg, no signs dehydration, weight gain 1.5 kg post-op

Lab: Na 116 (severe!), K 3.8, Cl 80, HCO3 24, BUN 6, Cr 0.5, glucose 92, osmolality serum 245 (LOW)
Urine: osmolality 380 (HIGHER than serum — inappropriately concentrated), urine Na 60 (HIGH for hyponatremia)
UO normal 1.2 mL/kg/hr; clinically euvolemic
TSH normal, cortisol normal (post-op on stress steroid)', '[{"label":"A","text":"Free water bolus"},{"label":"B","text":"Severe Symptomatic Hyponatremia from SIADH (post-craniopharyngioma surgery"},{"label":"C","text":"Diuretic alone"},{"label":"D","text":"Salt restriction"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe Symptomatic Hyponatremia from SIADH (post-craniopharyngioma surgery — common in neurosurgical pediatrics from posterior pituitary disruption — can be SIADH or CSW or DI): SEIZURE/severe symptoms → administer 3% Hypertonic Saline 4-6 mL/kg IV over 10-20 min (raise Na ~5-6 mEq/L acutely to abort seizure); reassess + may repeat if seizure recurs; AVOID rapid correction (> 8-10 mEq/L per 24 hr → osmotic demyelination, central pontine myelinolysis) — TARGET correction 6-12 mEq/L first 24 hr then 6-8 mEq/L subsequent; FLUID RESTRICTION 50-75% of maintenance once stable (mainstay SIADH); identify cause — post-op CNS, pain, opiates, medications; treat underlying; differentiate SIADH vs CSW (cerebral salt wasting): SIADH = euvolemic + concentrated urine + low Na; CSW = hypovolemic + concentrated urine + low Na — treatment opposite (CSW needs salt + volume!); helpful — orthostatic BP, weight, FENa, JVP, hematocrit; if CSW → hypertonic saline + 3% saline maintenance + fludrocortisone if persistent; consider DDAVP-induced if recent DI episode + DDAVP given (triphasic response common post-surgery); monitor Na q1-2 hr during acute correction, q4-6 hr subsequent; neuro exam frequent; if too rapid correction occurs — REVERSE with D5W + DDAVP (if needed); endocrine + neurosurgery + nephrology coordinated

---

Post-neurosurgical pediatric hyponatremia = differential SIADH vs CSW vs DDAVP-induced — treatment opposite for SIADH (restrict) vs CSW (replenish salt + volume). Severe symptomatic → 3% saline carefully. Avoid overcorrection → ODS/CPM. Triphasic response possible. Multidisciplinary.', NULL,
  'hard', 'endocrine_metabolic', 'review',
  'pediatrics', 'clinical_decision', 'endocrine_metabolic', 'peds',
  'Endocrine Society Hyponatremia Guidelines; Pediatric Critical Care', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 8 ปี post-op craniopharyngioma resection 3 วันก่อน, ตอนนี้ confused + lethargic + headache + nausea + ชัก × 1 ครั้ง brief

V/S: BP 110/72, HR 92, BW 26 kg, no signs dehydration, weight gain 1.5 kg post-op

Lab: Na 116 (severe!), K 3.8, Cl 80, HCO3 24, BUN 6, Cr 0.5, glucose 92, osmolality serum 245 (LOW)
Urine: osmolality 380 (HIGHER than serum — inappropriately concentrated), urine Na 60 (HIGH for hyponatremia)
UO normal 1.2 mL/kg/hr; clinically euvolemic
TSH normal, cortisol normal (post-op on stress steroid)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 10 ปี craniopharyngioma s/p resection 3 wk now มาตรวจกับ endo polyuria 5-7 L/d + polydipsia preferring ice cold water + เริ่มขาดน้ำ

V/S: BW 28 kg, mild dehydration
Lab: Na 152 (high), Urine osm 100 (very dilute despite high serum osm), Serum osm 310 (HIGH)
Water deprivation test (cautious): no concentration with deprivation + Urine osm rises markedly (> 50% increase) after DDAVP = Central DI
MRI: post-op changes, no bright spot posterior pituitary', '[{"label":"A","text":"Restrict fluid only"},{"label":"B","text":"Central Diabetes Insipidus (post-surgical, classic triphasic response"},{"label":"C","text":"Diuretic"},{"label":"D","text":"Limit fluid"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Central Diabetes Insipidus (post-surgical, classic triphasic response — DI immediate then SIADH days 3-7 from cell death then permanent DI): Desmopressin (DDAVP) — synthetic vasopressin analogue — multiple routes; oral starting dose 50-100 mcg BID-TID titrate to effect (children typically PO or intranasal); intranasal 5-10 mcg q12h titrate; subcutaneous 0.05-0.1 mcg q12h-q24h in NPO/perioperative — most precise; ASSESS for triphasic response — initial DI may transition to SIADH (don''t continue DDAVP rigidly — risk hyponatremia + seizure!); MONITOR carefully — Na, fluid balance, weight, UO daily/q12h initially; allow patient access to fluid + free thirst response (most reliable indicator of need); AVOID — set DDAVP doses without monitoring; gradual increase; risk overcorrection → hyponatremia + seizure (worse if also restricted access to fluid); INSTRUCT — drink to thirst, avoid fixed water intake; family education + emergency plan; medical alert; combine with thyroid + cortisol + GH replacement if panhypopit; ophtho + neuro follow-up; transition adult endocrinology; consider partial deficit (no DI permanent, only transient — recheck 1-3 mo); psychosocial support school

---

Central DI = ADH deficiency. Post-pituitary surgery: triphasic response (DI → SIADH → permanent DI). DDAVP replacement + drink to thirst + careful monitoring. Combination panhypopituitarism replacements (cortisol, thyroid, GH, ADH). Education + medical alert.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'pediatrics', 'clinical_decision', 'endocrine_metabolic', 'peds',
  'Endocrine Society Diabetes Insipidus; PES Pediatric Endocrinology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 10 ปี craniopharyngioma s/p resection 3 wk now มาตรวจกับ endo polyuria 5-7 L/d + polydipsia preferring ice cold water + เริ่มขาดน้ำ

V/S: BW 28 kg, mild dehydration
Lab: Na 152 (high), Urine osm 100 (very dilute despite high serum osm), Serum osm 310 (HIGH)
Water deprivation test (cautious): no concentration with deprivation + Urine osm rises markedly (> 50% increase) after DDAVP = Central DI
MRI: post-op changes, no bright spot posterior pituitary'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 6 ปี 6 mo คุณแม่สังเกตว่าเริ่มมีเต้าโผล่ทั้ง 2 ข้าง + pubic hair sparse + อายุ 6 ปี advanced growth velocity (8 cm/yr last year)

V/S: BW 26 kg, height 130 cm (90th percentile, accelerating)
PE: Tanner stage breast 3 + pubic hair 2 + axillary 1, no virilization, no cafe-au-lait spots

Lab: LH basal 2.5 (pubertal range — pubertal LH > 0.3 IU/L), FSH 4, estradiol 35, GnRH stimulation test — LH peak 18 (pubertal); bone age 9 yr (advanced 2-3 yr); brain MRI: normal (no CNS lesion = idiopathic central precocious puberty)', '[{"label":"A","text":"Wait + observe"},{"label":"B","text":"Central Precocious Puberty idiopathic (CPP < 8 yr girls, < 9 yr boys, GnRH-dependent)"},{"label":"C","text":"Surgery"},{"label":"D","text":"Steroid"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Central Precocious Puberty idiopathic (CPP < 8 yr girls, < 9 yr boys, GnRH-dependent): treatment INDICATED in this child because of young age (< 7 yr girls), rapid progression, advanced bone age threatening adult height; GnRH agonist therapy — Leuprolide acetate IM 7.5 mg q1 mo OR Leuprolide depot 11.25-22.5 mg q3 mo OR Histrelin implant SC annual (60-mg implant) — suppress HPG axis + prevent further pubertal progression + preserve adult height; alternatives Triptorelin q1 mo or q3 mo; continue until 11-12 yr girls (after which pubertal progression appropriate); monitor — LH suppressed < 0.3 IU/L 60 min post-injection (or DHEAS for adrenal contribution), estradiol low, growth velocity slows, bone age progression slows; SIDE effects — local injection site, sterile abscess, headache, hot flushes minimal, possible psychological transient mood changes; AVOID — discontinuation without endocrine guidance; PSYCHOSOCIAL support — child + family (advanced physical development + social-emotional issues, body image, social interaction with older-looking peers); investigate for cause if signs concerning (cafe-au-lait → McCune-Albright, neuro findings → CNS lesion, virilization → adrenal/ovarian tumor); peripheral precocious puberty (PPP, GnRH-independent) = different mgmt (treat cause + sometimes letrozole/spironolactone — but this case CPP); long-term: adult height preserved, fertility preserved post-discontinuation, ongoing endocrine follow-up; communication with school

---

Central precocious puberty (CPP) < 8 girls, < 9 boys = GnRH-dependent. Treat with GnRH agonist (leuprolide, histrelin implant, triptorelin) to preserve adult height + delay social/emotional impact. Workup CNS (MRI mandatory), exclude PPP causes (McCune-Albright, tumors). Psychosocial support.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'pediatrics', 'basic_science', 'endocrine_metabolic', 'peds',
  'PES Consensus on Central Precocious Puberty; ESPE Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 6 ปี 6 mo คุณแม่สังเกตว่าเริ่มมีเต้าโผล่ทั้ง 2 ข้าง + pubic hair sparse + อายุ 6 ปี advanced growth velocity (8 cm/yr last year)

V/S: BW 26 kg, height 130 cm (90th percentile, accelerating)
PE: Tanner stage breast 3 + pubic hair 2 + axillary 1, no virilization, no cafe-au-lait spots

Lab: LH basal 2.5 (pubertal range — pubertal LH > 0.3 IU/L), FSH 4, estradiol 35, GnRH stimulation test — LH peak 18 (pubertal); bone age 9 yr (advanced 2-3 yr); brain MRI: normal (no CNS lesion = idiopathic central precocious puberty)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 8 ปี ปวดศีรษะตอนเช้า 6 wk + อาเจียน projectile morning + diplopia + ataxia เดินไม่ตรง + papilledema OD/OS + 6th nerve palsy bilateral + neck stiffness mild

V/S: BP 132/82, HR 62, BW 24 kg
Gen: alert, no focal weakness, dysmetria + truncal ataxia, wide-based gait

MRI brain: posterior fossa midline mass 4 cm enhancing + obstructive hydrocephalus (4th ventricle compressed)
LP CONTRAINDICATED (mass effect)
Likely medulloblastoma (most common malignant peds brain tumor, posterior fossa, 5-9 yr)', '[{"label":"A","text":"Wait — observe"},{"label":"B","text":"Suspected Posterior Fossa Brain Tumor (likely medulloblastoma) + symptomatic obstructive hydrocephalus + increased ICP"},{"label":"C","text":"Antibiotic"},{"label":"D","text":"Discharge home"},{"label":"E","text":"LP first"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Suspected Posterior Fossa Brain Tumor (likely medulloblastoma) + symptomatic obstructive hydrocephalus + increased ICP: admit + ICU; manage increased ICP — head of bed 30°, avoid hyponatremia, mannitol/3% saline if severe symptoms, dexamethasone 0.15-0.25 mg/kg/dose q6h IV (peritumoral edema reduction); neurosurgery URGENT — external ventricular drain (EVD) for hydrocephalus management OR endoscopic third ventriculostomy (ETV) as definitive surgery; staging — total spine MRI before resection (drop metastases CSF) + cytology lumbar CSF post-operative (with intracranial pressure normalized); SURGICAL RESECTION — maximal safe resection by experienced pediatric neurosurgeon; histology + molecular characterization — medulloblastoma WHO 4 subgroups (WNT, SHH, group 3, group 4) with different prognosis + therapy intensity; ADJUVANT THERAPY — craniospinal irradiation 23.4-36 Gy + posterior fossa boost (limited or omitted in young children < 3 yr to reduce neurocognitive sequelae) + chemotherapy (cisplatin, vincristine, cyclophosphamide, lomustine, etoposide per COG); MOLECULAR-guided treatment intensity — WNT subgroup excellent prognosis, can de-intensify; SHH variable; group 3/4 standard-intensive; LONG-TERM — neurocognitive deficits (XRT cerebellum + hippocampus), endocrinopathy (pan-hypopit), hearing loss (cisplatin), secondary malignancy, vasculopathy, growth, posterior fossa syndrome (mutism transient); MULTIDISCIPLINARY late effects clinic

---

Pediatric brain tumor = leading cause cancer death kids. Posterior fossa (medulloblastoma, ependymoma, JPA, brainstem glioma) most common. LP CONTRAINDICATED with mass effect. Steroid + neurosurg + complete staging spine + molecular characterization guide therapy. Long-term sequelae substantial.', NULL,
  'hard', 'hemato_onco', 'review',
  'pediatrics', 'clinical_decision', 'hemato_onco', 'peds',
  'COG Brain Tumor Protocols; SIOPE Pediatric Brain Tumor', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 8 ปี ปวดศีรษะตอนเช้า 6 wk + อาเจียน projectile morning + diplopia + ataxia เดินไม่ตรง + papilledema OD/OS + 6th nerve palsy bilateral + neck stiffness mild

V/S: BP 132/82, HR 62, BW 24 kg
Gen: alert, no focal weakness, dysmetria + truncal ataxia, wide-based gait

MRI brain: posterior fossa midline mass 4 cm enhancing + obstructive hydrocephalus (4th ventricle compressed)
LP CONTRAINDICATED (mass effect)
Likely medulloblastoma (most common malignant peds brain tumor, posterior fossa, 5-9 yr)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 7 ปี BW 22 kg มี motor vehicle accident — passenger seat unbelted, ejected, found unresponsive at scene 30 นาทีก่อน EMS GCS 6 ขณะนำส่ง; arrival ED ตอนนี้ continued unresponsive

V/S arrival: HR 132, BP 76/40, RR irregular shallow, SpO2 84% room air
Gen: GCS 6 (E1V1M4), unequal pupils R 5 mm sluggish/L 3 mm reactive, no obvious external bleeding, scalp hematoma left occipital, abdomen tender RUQ + LUQ, deformity left thigh + pelvis tender

FAST exam: free fluid RUQ + LUQ; pelvic XR: pelvic fracture; CXR: pending', '[{"label":"A","text":"MRI brain first"},{"label":"B","text":"Multi-trauma pediatric polytrauma"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Antibiotic"},{"label":"E","text":"Wait for MRI"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Multi-trauma pediatric polytrauma — ATLS/PALS approach: AIRWAY priority (GCS ≤ 8 = intubate, c-spine immobilization throughout); rapid sequence intubation with c-spine inline stabilization, etomidate 0.3 mg/kg + rocuronium 1 mg/kg (avoid succinylcholine in significant head injury, hyperkalemia); BREATHING — bilateral chest sounds, end-tidal CO2, CXR (rule out PTX/HTX/PE), maintain SpO2 ≥ 94%; CIRCULATION — IV/IO × 2 large-bore, type + cross 10 mL/kg PRBC + crystalloid 20 mL/kg max (avoid over-resuscitation), MTP if exsanguinating (1:1:1 PRBC:FFP:platelet), TXA 15 mg/kg over 10 min then 2 mg/kg/hr (CRASH-3, pediatric extrapolation); control external bleeding + pelvic binder; DISABILITY — pupils + GCS, manage increased ICP (head of bed 30°, gentle hyperventilation transient bridge PaCO2 30-35, hypertonic saline 3% 3-5 mL/kg, mannitol option, target CPP > 40); EXPOSURE + environment — prevent hypothermia, log roll spine exam; FAST + bedside US; pan-CT (head + c-spine + chest + abdomen + pelvis) once stable enough; pediatric trauma center transfer if not already at; neurosurgery + general surgery + orthopedic surgery + pediatric ICU multidisciplinary; abdominal injury — splenic/liver lacerations → most managed non-operative if stable; pelvic fracture significant — bleed risk, may need IR/angiography; head injury — CT head, may need neurosurgery if mass lesion; transfusion goal Hb > 7 (10 if active bleed), Plt > 100 if neuro injury, INR < 1.5; tetanus prophylaxis; family liaison + chaplain; secondary survey systematic; reportable to trauma registry

---

Pediatric polytrauma = ABC primary survey + secondary survey + multidisciplinary trauma center. Pediatric differences: relatively larger head, smaller airway, kids compensate then crash, c-spine, occult internal bleeding. TXA for major hemorrhage. Non-operative for stable splenic/liver. Avoid over-fluid (worsens coagulopathy).', NULL,
  'hard', 'trauma', 'review',
  'pediatrics', 'ems_mgmt', 'trauma', 'peds',
  'ATLS Pediatric Trauma; AHA PALS; PECARN Head Injury', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 7 ปี BW 22 kg มี motor vehicle accident — passenger seat unbelted, ejected, found unresponsive at scene 30 นาทีก่อน EMS GCS 6 ขณะนำส่ง; arrival ED ตอนนี้ continued unresponsive

V/S arrival: HR 132, BP 76/40, RR irregular shallow, SpO2 84% room air
Gen: GCS 6 (E1V1M4), unequal pupils R 5 mm sluggish/L 3 mm reactive, no obvious external bleeding, scalp hematoma left occipital, abdomen tender RUQ + LUQ, deformity left thigh + pelvis tender

FAST exam: free fluid RUQ + LUQ; pelvic XR: pelvic fracture; CXR: pending'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 3 ปี ตกจากที่นั่งกินข้าว 1.2 เมตร ลงพื้น 30 นาทีก่อน — ไม่ตักหรือสลบ ร้องไห้ทันที พ่อแม่บอก ตอนนี้ alert + ตื่นปกติ + ไม่อาเจียน + ไม่ปวดศีรษะ + ไม่ชัก

V/S: HR 102, BP 96/62, Temp ปกติ, BW 14 kg
Gen: alert + playful + no distress, GCS 15
PE: scalp hematoma small frontal (parietal), no obvious skull deformity, no Battle/raccoon sign, no hemotympanum, no CSF leak, no neuro deficit, normal exam อื่น

No Hx coagulopathy, no medication, no bleeding disorder', '[{"label":"A","text":"CT brain mandatory all head injury"},{"label":"B","text":"Minor head trauma in young child"},{"label":"C","text":"Discharge no instruction"},{"label":"D","text":"MRI immediately"},{"label":"E","text":"Skull XR"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Minor head trauma in young child — apply PECARN Pediatric Head Injury Rule (< 2 yr separate criteria, 2-18 yr criteria): age 3 yr (criteria for 2-18 yr) — assess PECARN risk factors: 1) altered mental status (GCS < 15, agitation, somnolence, repetitive questioning, slow response) — NO here, 2) loss of consciousness — NO, 3) vomiting — NO, 4) severe mechanism (MVC ejected, death, rollover; pedestrian/cyclist without helmet struck; fall > 5 ft/1.5 m for > 2 yr; head struck by high-impact object) — fall 1.2 m is below threshold = NO, 5) signs basilar skull fracture — NO, 6) severe headache — NO; ALL PECARN criteria NEGATIVE = very low risk (< 0.05% ciTBI) → recommend observation only, NO CT indicated; explain to family — observe at home × 24-48 hr with return precautions (worsening headache, repeated vomiting, AMS, focal deficit, seizure, irritability not improved, fluid from nose/ear, gait abnormality); injury prevention counseling — safety practices feeding chair, supervision, helmets/seatbelts, fall prevention; consider age + parental concern + injury mechanism + clinician experience in shared decision-making; if observation in ED 4-6 hr selected scenarios; head injury results in concussion → return to learn + play progression

---

PECARN HIR (Kuppermann Lancet 2009) reduces CT use in low-risk pediatric head injury (radiation exposure concern). Risk stratification: very low (no factors) = observe; intermediate (1+ factors) = observe/clinician judgment; high-risk = CT. Family education + return precautions. Shared decision-making.', NULL,
  'medium', 'trauma', 'review',
  'pediatrics', 'clinical_decision', 'trauma', 'peds',
  'PECARN Pediatric Head Injury Rule (Kuppermann Lancet 2009)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 3 ปี ตกจากที่นั่งกินข้าว 1.2 เมตร ลงพื้น 30 นาทีก่อน — ไม่ตักหรือสลบ ร้องไห้ทันที พ่อแม่บอก ตอนนี้ alert + ตื่นปกติ + ไม่อาเจียน + ไม่ปวดศีรษะ + ไม่ชัก

V/S: HR 102, BP 96/62, Temp ปกติ, BW 14 kg
Gen: alert + playful + no distress, GCS 15
PE: scalp hematoma small frontal (parietal), no obvious skull deformity, no Battle/raccoon sign, no hemotympanum, no CSF leak, no neuro deficit, normal exam อื่น

No Hx coagulopathy, no medication, no bleeding disorder'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 14 ปี football เล่นบอลตี + กระทบศีรษะ 5 วันก่อน — short LOC 30 sec + headache, photophobia, dizziness, sleep disturbance, irritability, concentration ลดลง 5 วันแล้ว; ตอนนี้ symptoms มี mild headache + ความเข้มข้นยังไม่ปกติเต็มที่ + tolerating school accommodation

No seizure, no focal deficit, no skull fracture, no LOC > 30 sec, normal exam current; CT brain ที่ ED วันแรก: normal
No h/o multiple concussion
Family wants to know about return to play', '[{"label":"A","text":"Return to play 24 hr after injury"},{"label":"B","text":"Sport-Related Concussion"},{"label":"C","text":"Wait 1 year"},{"label":"D","text":"MRI all concussions"},{"label":"E","text":"Discharge no education"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Sport-Related Concussion — physical + cognitive rest first 24-48 hr then gradual return (CISG/Berlin 2017 + Amsterdam 2022 Consensus): SYMPTOMATIC initially — relative rest 24-48 hr (no school, no athletics, limit screens) then GRADUATED return as symptoms improve, NOT complete rest beyond 48 hr (recent evidence: prolonged rest = worse outcomes); RETURN-TO-LEARN progression — light cognitive activity at home → return school with accommodations (extended time, reduced workload, breaks, no exams, quieter environment) → full school no accommodation → required before return to play; RETURN-TO-PLAY 6-step graduated progression — each step ≥ 24 hr, advance only if symptom-free: 1) symptom-limited activity, 2) light aerobic exercise (walking, stationary bike), 3) sport-specific exercise (running, drills no contact), 4) non-contact training drills (passing, more complex), 5) full contact practice (medical clearance required), 6) return to play; if symptoms recur at any step → drop back one step ≥ 24 hr; medical clearance by trained provider before contact; AVOID — opioids, NSAIDs early (recent concern); manage symptoms — acetaminophen, sleep hygiene, vestibular therapy for dizziness, cervical therapy for neck, neuropsychology assessment for prolonged; SECOND IMPACT SYNDROME — return to contact play before recovery = catastrophic risk, especially adolescent; persistent symptoms > 4 wk = post-concussion syndrome, multidisciplinary team referral; education prevention — helmet, rule changes, safer technique; school + sport responsibility; long-term: most resolve within 1-4 wk pediatric; CTE concern for repetitive head impact long-term

---

Concussion = brain trauma symptom-based diagnosis. Berlin/Amsterdam consensus: brief rest 24-48 hr then gradual return-to-learn + return-to-play 6-step protocol. Second impact syndrome = preventable catastrophic complication especially adolescent. Pediatric recovery typically 1-4 wk. Education + helmet + rule changes.', NULL,
  'easy', 'trauma', 'review',
  'pediatrics', 'integrative', 'trauma', 'peds',
  'CISG Berlin 2017 + Amsterdam 2022 Consensus Statement on Concussion in Sport', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 14 ปี football เล่นบอลตี + กระทบศีรษะ 5 วันก่อน — short LOC 30 sec + headache, photophobia, dizziness, sleep disturbance, irritability, concentration ลดลง 5 วันแล้ว; ตอนนี้ symptoms มี mild headache + ความเข้มข้นยังไม่ปกติเต็มที่ + tolerating school accommodation

No seizure, no focal deficit, no skull fracture, no LOC > 30 sec, normal exam current; CT brain ที่ ED วันแรก: normal
No h/o multiple concussion
Family wants to know about return to play'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 8 ปี BW 26 kg crash bicycle into pole ขณะวันก่อน — no LOC, complains neck pain mild + headache; in c-collar in ED

V/S: GCS 15, normal neurologic exam, no extremity weakness, no sensory deficit, normal reflexes
PE: alert + conversant + cooperative; midline cervical tenderness mild at C5 area, no distracting injuries elsewhere, no obvious deformity, no signs intoxication
No paresthesia, no torticollis', '[{"label":"A","text":"Remove collar immediately without further evaluation"},{"label":"B","text":"Pediatric Cervical Spine clearance (different rules than adult"},{"label":"C","text":"Wait 1 week"},{"label":"D","text":"MRI without XR"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Cervical Spine clearance (different rules than adult — NEXUS less validated, PECARN cervical spine recently): pediatric c-spine clearance criteria + approach: 1) high-risk mechanism + clinical factors (altered mental status, focal neuro deficit, midline cervical tenderness, distracting injury, intoxication, age < 3 + difficult to examine) = imaging; 2) without high-risk → clinical clearance — patient awake + alert + no neuro deficit + no tenderness + ROM intact without pain + able to communicate; THIS PATIENT — has midline tenderness → IMAGING indicated; FIRST imaging — lateral cervical XR (lateral, AP, odontoid if cooperative ≥ 5 yr) — assess prevertebral space, alignment (anterior + posterior longitudinal, spinolaminar, posterior spinous), pseudosubluxation C2-3 normal up to age 8 (50% have); if XR equivocal/abnormal OR high-risk mechanism → CT cervical spine (better bony detail than XR but radiation); if neuro deficit OR persistent symptoms with normal CT → MRI (ligamentous, cord, dynamic); MAINTAIN c-collar until cleared (immobilization continues); KIDS — relatively larger head + ligamentous laxity → SCIWORA (spinal cord injury without radiographic abnormality) possible especially < 8 yr — high index suspicion; if neuro symptoms despite normal imaging → MRI; pediatric trauma center + neurosurgery if instability or neuro injury; family + child education; long-term — outcome depends on injury severity

---

Pediatric c-spine clearance differs from adult (relatively larger head, ligamentous laxity, SCIWORA risk). Tenderness or high-risk = image. Lateral XR first; CT if equivocal; MRI for cord/ligamentous/SCIWORA. Pseudosubluxation C2-3 normal up to age 8. Multidisciplinary care.', NULL,
  'medium', 'trauma', 'review',
  'pediatrics', 'ems_mgmt', 'trauma', 'peds',
  'ATS Pediatric Trauma Society; PECARN Cervical Spine Rule', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 8 ปี BW 26 kg crash bicycle into pole ขณะวันก่อน — no LOC, complains neck pain mild + headache; in c-collar in ED

V/S: GCS 15, normal neurologic exam, no extremity weakness, no sensory deficit, normal reflexes
PE: alert + conversant + cooperative; midline cervical tenderness mild at C5 area, no distracting injuries elsewhere, no obvious deformity, no signs intoxication
No paresthesia, no torticollis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 4 ปี Hx anaphylaxis ต่อ ถั่วลิสง 6 mo ก่อน (Epi pen ใช้ — fine) ตอนนี้ asymptomatic เพื่อ counseling + management plan; family asks about prevention + management + new therapy', '[{"label":"A","text":"Severe restriction + isolation"},{"label":"B","text":"Peanut Allergy long-term management + emerging therapies"},{"label":"C","text":"No further intervention"},{"label":"D","text":"Skin test only"},{"label":"E","text":"Steroid daily"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Peanut Allergy long-term management + emerging therapies: EMERGENCY ACTION PLAN (written, share school + caregivers + family) — recognize anaphylaxis (mucous membranes/skin + respiratory or GI or hypotension), immediate EpiPen Jr 0.15 mg IM thigh (< 25 kg) → repeat in 5-15 min if no improvement → call EMS → transport to ED; education — antigens, reading labels (FALCPA US, EU mandatory labeling), cross-contamination prevention, restaurant communication, travel; STRICT AVOIDANCE remains cornerstone but allergen avoidance alone — high accidental exposure rate; pediatric ALLERGIST referral — confirm with skin prick test + serum IgE + supervised oral food challenge (gold standard); EARLY ORAL IMMUNOTHERAPY (OIT) — landmark LEAP study (Du Toit NEJM 2015): early introduction of peanut at 4-11 mo in high-risk infants (severe eczema, egg allergy) REDUCES peanut allergy by 80% at age 5 — current AAP/NIAID guideline endorses early introduction; FDA-APPROVED peanut OIT — Palforzia (peanut allergen powder), age 4-17 yr — gradual escalation reduces severity of accidental ingestion (not cure, daily maintenance dose lifelong, anaphylaxis can still occur during therapy — requires trained allergist); Omalizumab (anti-IgE) — recent FDA approval 2024 for food allergy adjunct; SUBLINGUAL IMMUNOTHERAPY + epicutaneous (Viaskin patch) — less robust, alternatives; medical alert bracelet; school 504 plan; mental health — anxiety common families; cross-reactivity (other tree nuts, legumes) — assess individually; revaccinate yearly anaphylaxis EpiPen training; future: monoclonal antibodies, gene therapy emerging

---

Food allergy = chronic disease. EpiPen + emergency plan + strict avoidance + education foundational. LEAP study revolutionized — EARLY introduction peanut in high-risk infants reduces allergy 80%. OIT (Palforzia FDA-approved) + omalizumab adjunctive for desensitization. Long-term allergist follow-up.', NULL,
  'easy', 'id', 'review',
  'pediatrics', 'integrative', 'id', 'peds',
  'AAAAI Food Allergy Practice Parameters; NIAID Peanut Allergy Prevention 2017', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 4 ปี Hx anaphylaxis ต่อ ถั่วลิสง 6 mo ก่อน (Epi pen ใช้ — fine) ตอนนี้ asymptomatic เพื่อ counseling + management plan; family asks about prevention + management + new therapy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกอายุ 8 mo BW 8.2 kg มีผื่นแห้งคัน เริ่มที่หน้า + แก้ม 4 mo + ลามไป arms + legs + flexure (popliteal + antecubital) + ดูเหลืองอ่อน scratch marks, ตื่นกลางคืนคันรบกวน sleep; ครอบครัว atopic — แม่ asthma + sister AR

PE: erythematous + scaly + lichenified plaques flexor surfaces, no infection (no honey-crusted, no fluctuance, no pustule)
No wheeze, growth normal; SCORAD moderate', '[{"label":"A","text":"Steroid systemic chronic"},{"label":"B","text":"Atopic Dermatitis (Eczema) moderate, classic atopic march"},{"label":"C","text":"Antibiotic only"},{"label":"D","text":"Avoid all bathing"},{"label":"E","text":"Discharge no education"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Atopic Dermatitis (Eczema) moderate, classic atopic march: EDUCATION + family — chronic relapsing disease, manage rather than cure; SKIN HYDRATION — daily lukewarm bath 10-15 min + immediately apply moisturizer (fragrance-free emollient) within 3 min (soak + seal), thick ointment (petroleum-based) preferred over lotion; bath additive (mild non-soap cleanser like Cetaphil, mild oat); TOPICAL CORTICOSTEROID — first-line antiinflammatory — low-potency (hydrocortisone 1-2.5%) for face/groin, mid-potency (triamcinolone 0.1%) for body, intermittent use 1-2× daily × 7-14 d for flares; PROACTIVE therapy — twice weekly steroid (or tacrolimus) to high-risk areas during quiescent phase reduces flares; TOPICAL CALCINEURIN INHIBITOR — tacrolimus 0.03% (≥ 2 yr) or pimecrolimus 1% — steroid-sparing, safe for face + thin skin; identify + avoid triggers — heat, sweat, harsh detergent, fragrance, wool; treat super-infection — bacterial (Staph 80%) → mupirocin topical or oral cephalexin/clindamycin if widespread, viral eczema herpeticum → URGENT acyclovir + ophtho consult if periocular; ANTIHISTAMINE for pruritus mostly sedating for sleep (hydroxyzine, diphenhydramine HS); bleach bath 2-3×/wk for recurrent infection; new — TOPICAL crisaborole (PDE4 inhibitor), Ruxolitinib (JAK inhibitor topical) for older kids; BIOLOGIC — Dupilumab (anti-IL4Rα) ≥ 6 mo FDA-approved for moderate-severe; Tralokinumab, Lebrikizumab emerging; food allergy + asthma + rhinitis comorbid — allergist + atopic march counseling; psychosocial impact + sleep affected

---

AD = chronic relapsing, atopic march common. Skin hydration + emollient + topical steroid first-line. Tacrolimus alternative thin skin/face. Proactive maintenance for flares prevention. Bleach bath for recurrent infection. Dupilumab biologic moderate-severe ≥ 6 mo. Family-centered education.', NULL,
  'easy', 'id', 'review',
  'pediatrics', 'clinical_decision', 'id', 'peds',
  'AAD Guidelines AD 2024; European Task Force on AD', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกอายุ 8 mo BW 8.2 kg มีผื่นแห้งคัน เริ่มที่หน้า + แก้ม 4 mo + ลามไป arms + legs + flexure (popliteal + antecubital) + ดูเหลืองอ่อน scratch marks, ตื่นกลางคืนคันรบกวน sleep; ครอบครัว atopic — แม่ asthma + sister AR

PE: erythematous + scaly + lichenified plaques flexor surfaces, no infection (no honey-crusted, no fluctuance, no pustule)
No wheeze, growth normal; SCORAD moderate'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 10 ปี ครอบครัว Hx swelling — แม่ + ลุง + พี่ มี attacks intermittent swelling face, hands, feet, abdomen WITHOUT urticaria — ลูกสาวมาตอนนี้ episode 3 — facial + lip swelling + abdominal pain colicky + อาเจียน + ปวดเริ่ม 6 ชม

V/S: HR 102, BP 102/68, no respiratory distress (no laryngeal edema currently), BW 32 kg
PE: significant lip + facial swelling, abdominal tender no peritonitis, no hives, no pruritus, no airway compromise yet

Lab: C4 LOW, C1-INH antigenic LOW, C1-INH functional LOW = HAE type 1
Tryptase normal (excludes mast cell)
Not responding to antihistamine + steroid (prior episodes)', '[{"label":"A","text":"Antihistamine + steroid alone"},{"label":"B","text":"Hereditary Angioedema (HAE) Acute Attack"},{"label":"C","text":"Antibiotic"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hereditary Angioedema (HAE) Acute Attack — C1-INH deficiency, NOT histamine-mediated (no urticaria, no response to standard anaphylaxis treatment): EMERGENCY targeted therapy — C1-INH concentrate (Berinert) IV 20 U/kg (most evidence + first-line acute), OR Ecallantide (kallikrein inhibitor) SC 30 mg in 3 sites, OR Icatibant (bradykinin B2 receptor antagonist) SC 30 mg single dose (self-administer at home) — all FDA-approved acute attacks pediatric; AVOID — antihistamine, steroid, epinephrine (less effective HAE, but EPI can still help if respiratory distress + uncertainty); fresh frozen plasma alternative if specific therapy unavailable (contains C1-INH, can paradoxically worsen by providing substrate); supportive — airway monitoring (LARYNGEAL EDEMA can be fatal — early intubation if signs progression), IV fluid for abdominal attacks (third-spacing), analgesia, antiemetic; admission for laryngeal attacks; PROPHYLAXIS — long-term (≥ 1-2 attacks/mo or severe) — Lanadelumab (anti-kallikrein mAb SC q2 wk, age ≥ 2), Berotralstat (oral kallikrein inhibitor, ≥ 12 yr), C1-INH SC (Haegarda) twice weekly, attenuated androgens (danazol — limited in children due growth/virilization side effects); short-term prophylaxis before procedures (dental, surgery, intubation) — C1-INH 20 U/kg or FFP; AVOID precipitants (estrogen, ACEI, trauma); on-demand therapy patients should have self-administered kit + emergency plan; allergist + immunologist follow-up; education family + medical alert + genetic counseling (autosomal dominant — screen relatives)

---

HAE = bradykinin-mediated, NOT histamine. C1-INH deficiency (or function). Acute: C1-INH concentrate, icatibant, ecallantide. Standard anaphylaxis Rx ineffective. Laryngeal edema can be fatal. Long-term prophylaxis (lanadelumab, berotralstat). Genetic + family screen.', NULL,
  'hard', 'id', 'review',
  'pediatrics', 'basic_science', 'id', 'peds',
  'WAO HAE Guidelines 2021; US HAEA Medical Advisory Board', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 10 ปี ครอบครัว Hx swelling — แม่ + ลุง + พี่ มี attacks intermittent swelling face, hands, feet, abdomen WITHOUT urticaria — ลูกสาวมาตอนนี้ episode 3 — facial + lip swelling + abdominal pain colicky + อาเจียน + ปวดเริ่ม 6 ชม

V/S: HR 102, BP 102/68, no respiratory distress (no laryngeal edema currently), BW 32 kg
PE: significant lip + facial swelling, abdominal tender no peritonitis, no hives, no pruritus, no airway compromise yet

Lab: C4 LOW, C1-INH antigenic LOW, C1-INH functional LOW = HAE type 1
Tryptase normal (excludes mast cell)
Not responding to antihistamine + steroid (prior episodes)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 8 ปี เพิ่งกลับจาก camping ไป East Coast US 3 wk ก่อน บ้าน outdoor 4 wk ก่อนเจอ tick attached arm × หลายชั่วโมง — เพิ่งเห็น 2 wk ก่อนมี expanding circular target-like rash 12 cm diameter inner clearing ที่แขนเดิม + ไข้ต่ำ + ปวดข้อ + headache + arthralgia — ใจเต้น ไม่สม่ำเสมอ

V/S: HR irregular 65 (sinus brady) ECG → second-degree AV block Mobitz I, BW 26 kg
PE: erythema migrans target rash 12 cm right arm, mild knee effusion bilateral, no facial palsy currently

Lab: Lyme ELISA + Western blot — IgM + + IgG +; CBC normal', '[{"label":"A","text":"Antibiotic short course oral"},{"label":"B","text":"Early disseminated Lyme disease with cardiac involvement (AV block) + arthritis"},{"label":"C","text":"Wait — outgrow"},{"label":"D","text":"Antifungal"},{"label":"E","text":"Steroid alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Early disseminated Lyme disease with cardiac involvement (AV block) + arthritis: hospital admission for cardiac monitoring (AV block — may need temporary pacing if symptomatic complete heart block); IV ceftriaxone 50-75 mg/kg/d (max 2 g/d) × 14-21 days for cardiac OR neuro involvement (vs oral for skin/arthritis only); alternative IV penicillin G or cefuroxime; FOR cutaneous + arthritis without cardiac/neuro — oral DOXYCYCLINE 4.4 mg/kg/d ÷ q12h × 10-14 d (now recommended ALL AGES per IDSA 2020 — historically reserved > 8 yr due tooth staining, recent evidence safe < 8 yr for short courses); amoxicillin 50 mg/kg/d alternative all ages; cefuroxime alt; treat ARTHRITIS (Lyme arthritis) — oral doxycycline × 28 d → if persistent → IV ceftriaxone OR oral course again; reassess + repeat ECG; cardiac complications usually resolve with antibiotic but may need temporary pacing; FACIAL PALSY common — oral antibiotic, resolves with time; education + tick prevention (DEET, permethrin, long sleeves, tick checks); vaccine in development (VLA15); reportable; counsel family — Post-Treatment Lyme Disease Syndrome (controversial — fatigue/cognitive symptoms persisting); not contagious person-person

---

Lyme disease = Borrelia burgdorferi via Ixodes tick (US Northeast/upper Midwest, parts of Europe). Stages: early local (EM), early disseminated (multiple EM, neurological — facial palsy, meningitis; cardiac — AV block), late (arthritis). Doxycycline all ages per IDSA 2020. IV ceftriaxone for cardiac/neuro. Tick prevention.', NULL,
  'medium', 'id', 'review',
  'pediatrics', 'basic_science', 'id', 'peds',
  'IDSA Guideline Lyme Disease 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 8 ปี เพิ่งกลับจาก camping ไป East Coast US 3 wk ก่อน บ้าน outdoor 4 wk ก่อนเจอ tick attached arm × หลายชั่วโมง — เพิ่งเห็น 2 wk ก่อนมี expanding circular target-like rash 12 cm diameter inner clearing ที่แขนเดิม + ไข้ต่ำ + ปวดข้อ + headache + arthralgia — ใจเต้น ไม่สม่ำเสมอ

V/S: HR irregular 65 (sinus brady) ECG → second-degree AV block Mobitz I, BW 26 kg
PE: erythema migrans target rash 12 cm right arm, mild knee effusion bilateral, no facial palsy currently

Lab: Lyme ELISA + Western blot — IgM + + IgG +; CBC normal'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 9 ปี BW 28 kg อยู่ Bangkok ไข้สูง 4 วันก่อน + ปวดศีรษะ + ปวดเมื่อย + ปวดเบ้าตา + ผื่นแดง + เลือดออกตามไรฟัน + ตอนนี้วันที่ 5 ของไข้ ไข้ลดแล้วแต่กลับเหนื่อยมาก ปวดท้องรุนแรง + อาเจียน + extremities เย็น + capillary refill ช้า

V/S: HR 132, BP 96/82 (narrow PP 14 mmHg — SHOCK), RR 32, SpO2 96%, Temp 37.0°C (defervescence)
Gen: lethargic + restless, cold extremities, hepatomegaly 4 cm, petechiae multiple, no obvious bleeding

Lab: Hct 50 (rising from 38 — hemoconcentration), Plt 28,000, AST 320, ALT 280, albumin 2.8
NS1 antigen + + IgM +; tourniquet test positive
Dengue Severe (DSS — Dengue Shock Syndrome)', '[{"label":"A","text":"Steroid + antibiotic"},{"label":"B","text":"Severe Dengue with Dengue Shock Syndrome (critical phase, defervescence + plasma leak)"},{"label":"C","text":"Diuretic in shock phase"},{"label":"D","text":"Restrict fluid in shock"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe Dengue with Dengue Shock Syndrome (critical phase, defervescence + plasma leak) — WHO 2009 criteria: ICU admission + cardiovascular monitoring; CRYSTALLOID resuscitation — Ringer''s lactate or NSS 10 mL/kg IV bolus over 10-15 min (more aggressive faster than usual peds shock — 20 mL/kg may worsen plasma leak); reassess after each bolus (HR, BP, PP, cap refill, Hct, UO); if not improved → repeat 10-20 mL/kg over 10-30 min × 1-2 more; if still not improving → consider COLLOID (5% albumin or dextran 6% — pediatric data limited but used in dengue) 10-20 mL/kg; minimize fluid duration (24-48 hr critical phase, then reabsorption pulmonary edema risk) — taper carefully when stable + Hct dropping; avoid over-resuscitation in recovery phase (fluid overload + pulmonary edema common cause death — RAPID withdrawal as stable!); monitor Hct (rise = leak, fall = bleed or recovery), platelet (transfuse only if active bleed not for prophylaxis); supportive — paracetamol (AVOID NSAID + aspirin → bleeding risk), antiemetic; AVOID corticosteroid, immunoglobulin (no evidence); transfuse PRBC for severe bleeding + Hct fall; if hemorrhage suspected → control source; monitor LFTs + AKI; ICU duration 24-48 hr critical phase then convalescent; PREVENTION — vector control (Aedes aegypti — water containers), repellent, long sleeves, screens, vaccine: Dengvaxia (only seropositive prior), Qdenga newer (≥ 4-16 yr, regardless serostatus pre-approved); secondary infection with different serotype = increased severity (ADE — antibody-dependent enhancement); reportable disease

---

Severe dengue — critical phase at defervescence (48 hr plasma leak window). Cautious crystalloid resuscitation (less + faster), reassess Hct/HR/BP, taper rapidly during recovery (fluid overload kills). NO aspirin/NSAID/steroid. Vector control + vaccines (Qdenga newer). Reportable.', NULL,
  'medium', 'id', 'review',
  'pediatrics', 'clinical_decision', 'id', 'peds',
  'WHO Dengue Guidelines 2009 + 2024 updates; Thai Ministry of Public Health Dengue Treatment Protocols', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 9 ปี BW 28 kg อยู่ Bangkok ไข้สูง 4 วันก่อน + ปวดศีรษะ + ปวดเมื่อย + ปวดเบ้าตา + ผื่นแดง + เลือดออกตามไรฟัน + ตอนนี้วันที่ 5 ของไข้ ไข้ลดแล้วแต่กลับเหนื่อยมาก ปวดท้องรุนแรง + อาเจียน + extremities เย็น + capillary refill ช้า

V/S: HR 132, BP 96/82 (narrow PP 14 mmHg — SHOCK), RR 32, SpO2 96%, Temp 37.0°C (defervescence)
Gen: lethargic + restless, cold extremities, hepatomegaly 4 cm, petechiae multiple, no obvious bleeding

Lab: Hct 50 (rising from 38 — hemoconcentration), Plt 28,000, AST 320, ALT 280, albumin 2.8
NS1 antigen + + IgM +; tourniquet test positive
Dengue Severe (DSS — Dengue Shock Syndrome)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกชายอายุ 18 วัน BW 3,400 g มา ED ด้วย ไข้ 38.4°C + irritability + poor feeding + lethargy 12 ชม — vaccine ยังไม่ได้

V/S: HR 178, RR 62, Temp 38.4°C, SpO2 96%
Gen: lethargic, full bulging anterior fontanelle, neck supple (newborns may not), no rash, mottled

Lab: CBC WBC 26,000 (left shift), CRP 95, glucose 75; UA negative
LP: WBC 1,580 (PMN 92%), Protein 285, Glucose 18, Gram stain: gram-positive coccobacilli in chains = Listeria suspicious OR GBS
Blood culture pending; HSV PCR sent', '[{"label":"A","text":"Ceftriaxone alone"},{"label":"B","text":"Neonatal Bacterial Meningitis (< 1 mo"},{"label":"C","text":"Antiviral alone"},{"label":"D","text":"Antifungal alone"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neonatal Bacterial Meningitis (< 1 mo — different empiric coverage than older children): empiric IV antibiotic IMMEDIATELY (within 1 hr) — Ampicillin 75-100 mg/kg/dose q6h IV (covers Listeria + Enterococcus + susceptible GBS) + Gentamicin 4 mg/kg/dose q24h IV (synergy + gram-negative GBS, E. coli, etc.) + Cefotaxime 50-75 mg/kg/dose q6-8h IV (NOT ceftriaxone in newborns < 28 d due to bilirubin displacement + biliary sludging) — triple therapy covers GBS, E. coli, Listeria, enterococci, gram-negatives; ADD ACYCLOVIR 20 mg/kg/dose q8h IV (60 mg/kg/d) if HSV not excluded — newborns at high risk for HSV encephalitis/disseminated (CSF mononuclear pleocytosis, vesicles, seizure, transaminitis — but classic features may be absent — treat empirically until HSV PCR negative + clinical improvement, usually < 21 d); DEXAMETHASONE NOT routinely recommended in neonates (limited evidence + concerns); duration — GBS meningitis 14-21 d, E. coli meningitis 21 d, Listeria meningitis 21 d (longer than older kids); SUPPORTIVE — fluid + electrolytes, glucose, seizure management (load levetiracetam or phenobarbital); ICU monitoring + airway; SEPSIS workup including blood + urine + LP — done; serial neuro exam + imaging (brain MRI eventually for parenchymal involvement, infarct, abscess, hydrocephalus); audiology + ophtho follow-up (hearing loss common); developmental follow-up; family education; isolation if HSV — contact + standard

---

Neonatal meningitis < 28 d = different empiric (ampicillin + cefotaxime/gentamicin) — covers Listeria + GBS + gram-negative. NO ceftriaxone < 28 d (bilirubin displacement). ADD acyclovir until HSV excluded. Longer duration. Long-term sequelae high (hearing, neurological). Sepsis workup mandatory.', NULL,
  'hard', 'id', 'review',
  'pediatrics', 'clinical_decision', 'id', 'peds',
  'AAP Red Book 2024; IDSA Bacterial Meningitis', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกชายอายุ 18 วัน BW 3,400 g มา ED ด้วย ไข้ 38.4°C + irritability + poor feeding + lethargy 12 ชม — vaccine ยังไม่ได้

V/S: HR 178, RR 62, Temp 38.4°C, SpO2 96%
Gen: lethargic, full bulging anterior fontanelle, neck supple (newborns may not), no rash, mottled

Lab: CBC WBC 26,000 (left shift), CRP 95, glucose 75; UA negative
LP: WBC 1,580 (PMN 92%), Protein 285, Glucose 18, Gram stain: gram-positive coccobacilli in chains = Listeria suspicious OR GBS
Blood culture pending; HSV PCR sent'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกชายอายุ 8 mo ครอบครัว Ashkenazi Jewish, ก่อนหน้านี้ปกติ ตอนนี้ developmental regression — เคย smile + roll over + sit เริ่มสูญเสีย skills, abnormal startle + exaggerated to noise (hyperacusis), hypotonia developing

PE: cherry-red spot on macula bilateral (pathognomonic), hypotonia, decreased response to environment
Family: cousin similar condition died age 4

Enzyme: hexosaminidase A activity DEFICIENT in leukocytes — GM2 gangliosidosis (Tay-Sachs)
MRI: developing white matter changes', '[{"label":"A","text":"Curative gene therapy now standard"},{"label":"B","text":"Tay-Sachs Disease (infantile form, HEXA gene, autosomal recessive"},{"label":"C","text":"Surgery"},{"label":"D","text":"Antibiotic prophylaxis only"},{"label":"E","text":"Discharge home no follow-up"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Tay-Sachs Disease (infantile form, HEXA gene, autosomal recessive — Ashkenazi Jewish 1:27 carrier) — NO curative treatment available: SUPPORTIVE PALLIATIVE care multidisciplinary team — pediatric neurology + genetics + palliative care + family support; SEIZURE management (anticonvulsants — levetiracetam, valproate, often refractory); FEEDING support — G-tube as bulbar function deteriorates; RESPIRATORY support — aspiration precautions, suctioning, oxygen, ventilation per family wishes; PAIN + comfort care — opioids, benzodiazepines; PHYSICAL therapy + positioning; AGGRESSIVE management of infections (frequent pneumonia from aspiration); NUTRITIONAL support — high-calorie, gastrostomy; SLEEP support — clonazepam/melatonin; FAMILY counseling — fatal disease (typical death 2-5 yr), grief support, hospice consideration, sibling support, decision-making around invasive intervention + DNR; GENETIC counseling — autosomal recessive 25% risk each pregnancy, carrier screening Ashkenazi Jewish standard + other ethnicities at risk, preimplantation diagnosis available, prenatal diagnosis via CVS or amnio; CARRIER SCREENING — Ashkenazi Jewish, French Canadian, Cajun Louisiana, Pennsylvania Dutch — recommended pre-conception; INVESTIGATIONAL — substrate reduction therapy (miglustat), enzyme replacement (limited brain penetration), gene therapy clinical trials in progress (AAV-based); biomarker tracking; transition to adult/hospice if family decides; respite care; reproductive planning for parents

---

Tay-Sachs = HEXA deficiency → GM2 accumulation. Infantile fatal, no cure. Carrier screening (Ashkenazi Jewish 1:27) preconception standard. Supportive palliative + family + genetic counseling. Cherry-red spot pathognomonic. Gene therapy trials ongoing.', NULL,
  'medium', 'neurology', 'review',
  'pediatrics', 'basic_science', 'neurology', 'peds',
  'ACMG Carrier Screening Guidelines; National Tay-Sachs Disease Association', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกชายอายุ 8 mo ครอบครัว Ashkenazi Jewish, ก่อนหน้านี้ปกติ ตอนนี้ developmental regression — เคย smile + roll over + sit เริ่มสูญเสีย skills, abnormal startle + exaggerated to noise (hyperacusis), hypotonia developing

PE: cherry-red spot on macula bilateral (pathognomonic), hypotonia, decreased response to environment
Family: cousin similar condition died age 4

Enzyme: hexosaminidase A activity DEFICIENT in leukocytes — GM2 gangliosidosis (Tay-Sachs)
MRI: developing white matter changes'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกชายอายุ 5 วัน term BW 3,200 g, ดูปกติแรกคลอด หลัง feeding nasogastric protein-rich formula 2 วันที่ผ่านมา เริ่ม poor feeding + lethargy + recurrent vomiting → unresponsive + opisthotonus + tonic clonic seizure

V/S: HR 178, BP 60/40, RR 62 (Kussmaul-like), Temp 36.4°C
Lab: glucose 65, NH3 850 (very high!), pH 7.30, AG 18 (normal-mildly high), Na 138, K 3.8, urine ketone +
No sepsis features, CRP normal, CBC normal
Urine organic acids — pending; plasma amino acids — pending; acylcarnitine profile — pending
Family: cousin died unexplained newborn', '[{"label":"A","text":"Antibiotic alone"},{"label":"B","text":"Suspected Urea Cycle Defect / Hyperammonemic Crisis (newborn unexplained metabolic crisis post-protein loading + high NH3 + cousin Hx = pattern)"},{"label":"C","text":"Continue regular feeding"},{"label":"D","text":"Antiviral alone"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Suspected Urea Cycle Defect / Hyperammonemic Crisis (newborn unexplained metabolic crisis post-protein loading + high NH3 + cousin Hx = pattern): EMERGENCY pediatric metabolic specialist + ICU; ammonia > 500 = severe → DIALYSIS/CRRT (more rapid than HD) — most effective immediate intervention to clear ammonia; STOP all protein intake immediately (NPO); IV dextrose 10% at high rate to reverse catabolism + provide non-protein calories — GIR 10-15 mg/kg/min (caution glucose > 200 may exacerbate); IV insulin if hyperglycemia + ongoing catabolism (suppresses catabolism); IV lipid 1-2 g/kg/d (non-protein calorie); NITROGEN-SCAVENGING DRUGS — Sodium benzoate + Sodium phenylacetate (Ammonul) IV loading 250 mg/kg over 90 min then 250-500 mg/kg/d infusion — converts ammonia/glycine to hippurate + phenylacetyl-glutamine → renal excretion; alternatively glycerol phenylbutyrate (Ravicti); CARBAGLU (carglumic acid) for NAGS deficiency or propionic acidemia; ARGININE IV 600 mg/kg load then 200-300 mg/kg/d infusion (for urea cycle defects providing intermediates, exception in argininase deficiency); NEUROPROTECTION — manage seizure (levetiracetam preferred not metabolized via affected pathway, AVOID valproate in mitochondrial/urea cycle), ICP management, avoid hyperthermia; gradual reintroduction of protein after ammonia normalized < 80-100 — special metabolic formula; investigations — urine organic acids, plasma amino acids, plasma acylcarnitine, lactate, blood gas, urine orotic acid (helps subtype urea cycle); long-term: protein-restricted diet, supplements, monitor growth + cognitive, liver transplant considered for severe urea cycle defects with recurrent crisis (curative); family genetic counseling + screening + carrier testing + prenatal/preimplantation

---

Newborn metabolic crisis = differential urea cycle defect, organic acidemia, fatty acid oxidation, MSUD, others. High NH3 + post-protein onset + family Hx = urea cycle suspicion. EMERGENCY — STOP protein + dextrose + nitrogen scavengers + dialysis if severe. Hyperammonemia → permanent neurological damage if untreated. Specialist + genetic counseling.', NULL,
  'hard', 'endocrine_metabolic', 'review',
  'pediatrics', 'ems_mgmt', 'endocrine_metabolic', 'peds',
  'ESPN/ASPGHAN Urea Cycle Disorder Guidelines; Mitochondrial/Metabolic Society', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกชายอายุ 5 วัน term BW 3,200 g, ดูปกติแรกคลอด หลัง feeding nasogastric protein-rich formula 2 วันที่ผ่านมา เริ่ม poor feeding + lethargy + recurrent vomiting → unresponsive + opisthotonus + tonic clonic seizure

V/S: HR 178, BP 60/40, RR 62 (Kussmaul-like), Temp 36.4°C
Lab: glucose 65, NH3 850 (very high!), pH 7.30, AG 18 (normal-mildly high), Na 138, K 3.8, urine ketone +
No sepsis features, CRP normal, CBC normal
Urine organic acids — pending; plasma amino acids — pending; acylcarnitine profile — pending
Family: cousin died unexplained newborn'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 7 ปี known hereditary spherocytosis ตอนนี้มา ED ด้วย sudden weakness + pallor + ปวดหัว + tachycardia 2 วัน ก่อนได้รับ parvovirus B19 exposure ที่ school (fifth disease ระบาด)

V/S: HR 152, BP 90/56, RR 28, SpO2 98%, BW 24 kg
PE: severe pallor, mild scleral icterus, splenomegaly 4 cm (baseline), no jaundice severe

Lab: Hb 3.8 (baseline 9.2 — DROP!), MCV 80, retic 0.2% (very LOW — APLASTIC), Plt + WBC normal
Indirect bilirubin slightly elevated, LDH not elevated significantly
Parvovirus B19 PCR + ; smear: spherocytes present, no schistocytes, scarce reticulocytes', '[{"label":"A","text":"Folic acid only"},{"label":"B","text":"Aplastic Crisis (Parvovirus B19) in Hereditary Spherocytosis"},{"label":"C","text":"Iron supplementation"},{"label":"D","text":"Steroid alone"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Aplastic Crisis (Parvovirus B19) in Hereditary Spherocytosis: PRBC TRANSFUSION urgently — 10-15 mL/kg leukoreduced PRBC over 3-4 hr (recheck Hb post-transfusion target Hb 8-10 g/dL minimum, then transfuse periodically until reticulocyte recovery typically 7-14 days as bone marrow recovers from parvovirus B19 transient suppression); cardiac monitoring during transfusion + diuretic if symptomatic CHF; consider IV folate + supportive; ISOLATION — contact precautions (parvovirus B19 transmissible) + protect immunocompromised + pregnant women + others with hemolytic anemia (cross-infection risk in family/school); investigate household for similar conditions at risk; monitor — daily CBC + reticulocyte until reticulocyte > 1% sign recovery; counsel family — aplastic crisis self-limited 1-2 wk in immunocompetent (B19 transient suppression of erythroid precursors); follow-up — chronic management of HS + family screen + future planning splenectomy after age 6+ if not already done; vaccinate pneumococcal/meningococcal/Hib before splenectomy; long-term: most full recovery, but rare progress to chronic infection in immunocompromised → IVIG treatment; education families with chronic hemolytic anemia about parvovirus risks + close monitoring during outbreak

---

Aplastic crisis from Parvovirus B19 in HS or other chronic hemolytic anemia = transient red cell aplasia 1-2 wk. Sudden severe drop + reticulocytopenia = key feature. Transfusion supports until marrow recovers. Isolation (transmissible). Family counsel + pregnant + immunocompromised contacts.', NULL,
  'hard', 'hematology', 'review',
  'pediatrics', 'clinical_decision', 'hematology', 'peds',
  'AAP Red Book 2024 Parvovirus; British Society Haematology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 7 ปี known hereditary spherocytosis ตอนนี้มา ED ด้วย sudden weakness + pallor + ปวดหัว + tachycardia 2 วัน ก่อนได้รับ parvovirus B19 exposure ที่ school (fifth disease ระบาด)

V/S: HR 152, BP 90/56, RR 28, SpO2 98%, BW 24 kg
PE: severe pallor, mild scleral icterus, splenomegaly 4 cm (baseline), no jaundice severe

Lab: Hb 3.8 (baseline 9.2 — DROP!), MCV 80, retic 0.2% (very LOW — APLASTIC), Plt + WBC normal
Indirect bilirubin slightly elevated, LDH not elevated significantly
Parvovirus B19 PCR + ; smear: spherocytes present, no schistocytes, scarce reticulocytes'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 9 ปี known chronic kidney disease (CKD stage 3 จาก reflux nephropathy) ตอนนี้มา ED ปวดศีรษะรุนแรง + ตามัว + อาเจียน + ชัก × 1 ครั้ง brief

V/S: BP 195/132 (severely elevated, > 99th percentile + symptoms = hypertensive EMERGENCY), HR 102, RR 24, SpO2 99%, BW 28 kg
Gen: post-ictal currently, recovering; papilledema bilateral OD/OS, no focal deficit; clinically euvolemic

Lab: Cr 2.4 (baseline 1.6), K 4.8, glucose 102, no acute MI/CHF; UA proteinuria 2+, normal RBC
CT brain: no hemorrhage; consistent with PRES (posterior reversible encephalopathy syndrome) — MRI later', '[{"label":"A","text":"Rapid normalization of BP to normal in 1 hr"},{"label":"B","text":"Pediatric Hypertensive Emergency with end-organ damage (encephalopathy, seizure, PRES)"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Diuretic alone"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Hypertensive Emergency with end-organ damage (encephalopathy, seizure, PRES): ICU admission + continuous BP monitoring (preferably arterial line for accurate q minute monitoring); SLOW + CONTROLLED reduction — reduce 25% of planned reduction over FIRST 8 HOURS (NOT < 25% in first 1 hr to avoid hypoperfusion stroke/ischemic injury), additional 25% over next 8 hr, normal range over 24-48 hr total; first-line IV — Labetalol IV bolus 0.2-1 mg/kg q5-10 min titrate (max 40 mg/dose) OR continuous infusion 0.25-3 mg/kg/hr (avoid in asthma, CHF); OR Nicardipine continuous infusion 0.5-3 mcg/kg/min titrate (avoid in liver dysfunction); OR Sodium nitroprusside infusion 0.3-8 mcg/kg/min (caution cyanide toxicity in renal failure, light-protected) — use if refractory; OR Esmolol short-acting beta-blocker; AVOID sublingual nifedipine + IV hydralazine (less predictable + cause hypotension); manage SEIZURE — benzodiazepines, levetiracetam load; identify + treat underlying cause — CKD, renal artery stenosis (consider MRA renal), pheochromocytoma + neuroblastoma (screen catecholamines + imaging adrenal/sympathetic chain), drug-induced (cocaine/amphetamine, sympathomimetic, OCP), coarctation re-check, glomerulonephritis, endocrine; once BP controlled IV → transition oral antihypertensives — ACEI/ARB (if CKD + proteinuria), CCB, diuretic, beta-blocker per patient comorbid; AVOID — fluid overload, abrupt BP changes; recheck end organ — ophtho + neurology + cardiology + nephrology; long-term — outpatient BP target, address comorbid risk, growth + development monitoring, schooling, transition adult; PRES typically reverses with BP control + supportive (DAYS-WEEKS)

---

Pediatric HT emergency = BP severely elevated + end-organ damage (encephalopathy, retinopathy, AKI, HF, dissection). Lower BP gradually (25% planned in first 8 hr) — avoid hypoperfusion injury. IV labetalol/nicardipine/SNP first-line. PRES reversible with BP control. Investigate cause + long-term oral antihypertensive.', NULL,
  'hard', 'cardiovascular', 'review',
  'pediatrics', 'ems_mgmt', 'cardiovascular', 'peds',
  'AAP HT Guideline 2017; PHTS Pediatric Hypertension Society', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 9 ปี known chronic kidney disease (CKD stage 3 จาก reflux nephropathy) ตอนนี้มา ED ปวดศีรษะรุนแรง + ตามัว + อาเจียน + ชัก × 1 ครั้ง brief

V/S: BP 195/132 (severely elevated, > 99th percentile + symptoms = hypertensive EMERGENCY), HR 102, RR 24, SpO2 99%, BW 28 kg
Gen: post-ictal currently, recovering; papilledema bilateral OD/OS, no focal deficit; clinically euvolemic

Lab: Cr 2.4 (baseline 1.6), K 4.8, glucose 102, no acute MI/CHF; UA proteinuria 2+, normal RBC
CT brain: no hemorrhage; consistent with PRES (posterior reversible encephalopathy syndrome) — MRI later'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 11 ปี BW 78 kg, ส่วนสูง 145 cm, BMI 37.0 (severe obesity > 99th percentile, > 120% of 95th percentile per AAP definition); puberty Tanner 3; ไม่มี endocrine cause; เริ่มมี acanthosis nigricans + acral darkening; sleep ngonggn snoring + witnessed apnea

PE: severe obesity, hypertension borderline 130/82, abdominal striae, acanthosis nigricans; mild gynecomastia (likely lipomastia), no Cushingoid features, normal thyroid; normal genitalia for stage
Lab: HbA1c 5.9 (impaired), fasting glucose 108, fasting insulin elevated, lipid panel — TG 220, LDL 132, HDL 38 (low), ALT 78 (high — likely NAFLD), TSH normal
PSG: moderate OSA (AHI 12)', '[{"label":"A","text":"Discourage discussion of weight"},{"label":"B","text":"Severe Pediatric Obesity with comorbidities (T2DM-risk, OSA, NAFLD, HT)"},{"label":"C","text":"Surgery age 6"},{"label":"D","text":"Restrict all calories severely"},{"label":"E","text":"Discharge no follow"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe Pediatric Obesity with comorbidities (T2DM-risk, OSA, NAFLD, HT) — AAP 2023 Clinical Practice Guideline: comprehensive evidence-based management at any age (no longer ''watchful waiting''); INTENSIVE HEALTH BEHAVIOR + LIFESTYLE TREATMENT (IHBLT) — ≥ 26 contact hours over 3-12 mo, multidisciplinary (clinician + dietitian + behavioral + exercise + social + family) — first-line for ALL ages ≥ 6 yr + offered ≥ 2 yr; address dietary patterns (reduce SSB + ultraprocessed + portion control + family meals + Mediterranean-style + caloric awareness rather than restriction); physical activity — 60 min/d moderate-vigorous; limit screen time < 2 hr/d; sleep hygiene (treat OSA — adenotonsillectomy if appropriate, CPAP); behavioral therapy + family involvement + parent management training; SCREEN for + MANAGE COMORBIDITIES — T2DM (HbA1c, fasting glucose, OGTT if indicated), dyslipidemia (lipid panel), NAFLD (ALT q yr), HT (regular BP), OSA (PSG), depression, body image, eating disorder; PHARMACOTHERAPY now AAP-recommended adjunct ≥ 12 yr with BMI > 95th + comorbidities — Liraglutide ≥ 12 yr OR Phentermine-Topiramate ≥ 12 yr OR Orlistat ≥ 12 yr OR Setmelanotide for specific genetic obesity ≥ 6 yr OR Semaglutide weekly SC ≥ 12 yr (recent FDA approval, dramatic results — STEP TEENS trial 16% BMI reduction over 68 wk); long-term medication + monitoring; METABOLIC + BARIATRIC SURGERY (MBS) — AAP-recommended adolescents ≥ 13 yr with BMI > 35 + significant comorbidities OR > 40 (sleeve gastrectomy or RYGB) at specialized centers — significant durable weight loss + reverse comorbidities; psychosocial support — depression + body image + bullying common; school nutrition + activity advocacy; cardiometabolic risk reduction

---

AAP 2023 Pediatric Obesity Guidelines: paradigm shift — treat early + intensively (no watchful waiting). IHBLT for all ≥ 6 yr. Pharmacotherapy ≥ 12 yr with BMI > 95th + comorbidity (liraglutide, semaglutide, phentermine-topiramate). Bariatric surgery ≥ 13 yr selected severe. Comorbidity screening + multidisciplinary.', NULL,
  'easy', 'endocrine_metabolic', 'review',
  'pediatrics', 'integrative', 'endocrine_metabolic', 'peds',
  'AAP Clinical Practice Guideline: Pediatric Obesity 2023', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 11 ปี BW 78 kg, ส่วนสูง 145 cm, BMI 37.0 (severe obesity > 99th percentile, > 120% of 95th percentile per AAP definition); puberty Tanner 3; ไม่มี endocrine cause; เริ่มมี acanthosis nigricans + acral darkening; sleep ngonggn snoring + witnessed apnea

PE: severe obesity, hypertension borderline 130/82, abdominal striae, acanthosis nigricans; mild gynecomastia (likely lipomastia), no Cushingoid features, normal thyroid; normal genitalia for stage
Lab: HbA1c 5.9 (impaired), fasting glucose 108, fasting insulin elevated, lipid panel — TG 220, LDL 132, HDL 38 (low), ALT 78 (high — likely NAFLD), TSH normal
PSG: moderate OSA (AHI 12)'
  );

commit;

