-- ===============================================================
-- หมอรู้ — Pediatrics seed: chunk 7/10
-- Questions 121-140 of 200
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
  s.id, 'board', NULL, 'เด็กชายอายุ 18 เดือน BW 11 kg ถ่ายเหลว 8 ครั้ง/วัน + อาเจียน 6 ครั้ง × 2 วัน หลังจากเพื่อน daycare เป็นเหมือนกัน, no blood in stool, ไม่ไข้สูง

V/S: HR 168, BP 88/52, RR 32, Temp 37.6°C, capillary refill 3-4 sec
Gen: lethargic แต่ rousable, sunken eyes, dry mucous membranes, decreased skin turgor, น้ำหนักลด 800 g (~7% loss) — moderate dehydration

Lab: Na 138, K 3.5, HCO3 18, glucose 88, BUN 28
Stool: rotavirus antigen positive', '[{"label":"A","text":"Antibiotic IV broad-spectrum"},{"label":"B","text":"Acute viral gastroenteritis with moderate dehydration: ORS (Oral Rehydration Solution) per WHO/AAP — first-line for mild-moderate even with vomiting; calculate deficit ~50-100 mL/kg = 600-1,100 mL replace over 4 hr in small frequent volumes (5 mL q1-2 min, gradually increase); ondansetron oral 0.15 mg/kg single dose (1 dose) reduces vomiting + admission (evidence-based); IV fluid bolus 20 mL/kg NSS only if severe dehydration/shock/failed ORS; reassess hydration q1-2 hr; resume regular age-appropriate diet (BRAT diet not necessary — continued breastfeeding, formula, regular food OK as tolerated, NO dilution); rotavirus vaccine prevention (RV1 or RV5); zinc supplement 10-20 mg/d × 10-14 d (developing world WHO — modest benefit); probiotics (Lactobacillus GG, S. boulardii) shorten duration mild benefit; AVOID — antimotility (loperamide) ในเด็กเล็ก; antiemetic limited to ondansetron; antidiarrheal limited; counsel — return if dehydration worsens, blood, high fever, persistent vomit; admit if cannot tolerate ORS, severe dehydration, electrolyte imbalance, < 6 mo with severe vomiting"},{"label":"C","text":"Bowel rest NPO 24 hr"},{"label":"D","text":"Antimotility agent"},{"label":"E","text":"Discharge no rehydration"}]'::jsonb,
  'B', 'Viral gastroenteritis = leading cause peds diarrhea. Rotavirus most common (declining with vaccine). ORS first-line — even with vomiting (give small frequent). Ondansetron evidence-based reduces vomit + admission. Resume normal diet ASAP. Avoid antimotility. Hand hygiene + vaccine prevention.', NULL,
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
Stool RDT: V. cholerae O1 positive', '[{"label":"A","text":"Slow oral rehydration only"},{"label":"B","text":"Severe Hypovolemic Shock + Severe Hypernatremic Dehydration (cholera): URGENT IV/IO access ภายใน 5 นาที (alternative 3-mortar drill); RAPID IV bolus Ringer''s Lactate 20 mL/kg over 5-15 min repeat as needed (typical 60 mL/kg first hour); reassess after EACH bolus (mental status, perfusion, HR, BP, UO); IV antibiotic — Doxycycline 4.4 mg/kg single dose PO/IV OR Azithromycin 20 mg/kg single dose OR Erythromycin (alternative cholera-specific to reduce stool output + duration); for severe HYPERNATREMIA correct slowly to AVOID cerebral edema — once shock resolved, replace remaining deficit + ongoing losses over 48-72 hours, reduce serum Na ≤ 10-12 mEq/L per 24 hr (calculate free water deficit, give D5 ¼-½ NSS depending); correct hypokalemia (caution if renal failure) + acidosis (often self-corrects with perfusion); strict ins/outs; monitor for AKI; transfer to ICU; once tolerating PO, transition ORS + continue antibiotic; isolation + infection control (notifiable disease); public health reporting; family contact prophylaxis if outbreak; long-term: cholera vaccine for outbreak/endemic"},{"label":"C","text":"Subcutaneous fluid"},{"label":"D","text":"Antiemetic alone"},{"label":"E","text":"Antifungal"}]'::jsonb,
  'B', 'Severe dehydration + shock = IV/IO emergency. 20 mL/kg LR bolus repeat × reassess. Cholera = rapid massive losses, dyhydration may progress hours. Hypernatremic correction slow (≤ 12 mEq/L per 24 hr) — too fast = cerebral edema. Antibiotic reduces stool output + duration. Notifiable.', NULL,
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
Liver biopsy: bile duct proliferation + ductopenia + portal fibrosis = consistent with biliary atresia', '[{"label":"A","text":"Wait + recheck 3 mo"},{"label":"B","text":"Biliary Atresia (progressive obliterative cholangiopathy) — TIME-CRITICAL Dx: Kasai portoenterostomy (hepatic portoenterostomy connecting Roux limb of jejunum to porta hepatis) — outcomes depend strongly on age at surgery — best if < 60 days of age (success bile flow > 70%, vs < 30% if > 90 d); refer urgent hepatobiliary surgical center; pre-op: vitamin K + correct coagulopathy, optimize nutrition; post-op care — fat-soluble vitamin supplementation (ADEK), MCT formula, prophylactic antibiotic (TMP-SMX or neomycin) to prevent cholangitis (common complication post-Kasai); ursodeoxycholic acid 10-20 mg/kg/d may improve bile flow; growth + nutrition monitoring; treat cholangitis with broad-spectrum IV antibiotic + admit; long-term — even successful Kasai 50% require liver transplant by age 20 (chronic liver disease progresses); refer pediatric liver transplant center early; family support + education + transition adult; counsel family — without treatment, biliary cirrhosis + death by 2-3 yr; key teaching: ANY infant with jaundice > 2 wk needs fractionated bilirubin, direct > 2 or > 20% total = pathologic"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Surgery age 1"}]'::jsonb,
  'B', 'Biliary atresia = #1 indication peds liver transplant. ANY infant jaundice > 2 wk = check direct bilirubin (don''t dismiss). Kasai < 60 days = best outcome. Even with Kasai, 50% need transplant. Multidisciplinary HCC center. Cholangitis prophylaxis. ADEK + nutrition.', NULL,
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
Anti-HAV IgM POSITIVE, anti-HEV negative, anti-HBV negative, anti-HCV negative', '[{"label":"A","text":"Steroid for hepatitis"},{"label":"B","text":"Acute Hepatitis A (self-limited typically in children): supportive care — usually completely self-resolving, especially in younger kids; rest as tolerated; adequate nutrition (low-fat diet only as tolerance with nausea, no restriction need); maintain hydration; AVOID hepatotoxic drugs (acetaminophen — restrict to therapeutic doses if needed, NSAIDs, alcohol in adolescents); ANTIVIRAL NOT INDICATED (HAV self-limit); monitor for fulminant hepatitis (rare 0.4%) — daily clinical assessment + LFT + INR + glucose; admit if vomiting can''t maintain hydration, severe pain, signs of coagulopathy or encephalopathy (INR > 1.5 + AMS = pediatric acute liver failure → transplant center referral); isolation — fecal-oral spread; school exclusion 1 wk post-jaundice onset; hand hygiene critical; CONTACTS — post-exposure prophylaxis with HAV vaccine within 14 days (preferred immunocompetent + age 1-40) OR IG for selected (< 12 mo, > 40 yr, immunocompromised, chronic liver dz, pregnant); HAV vaccine routine 12-23 mo (Thai EPI + ACIP); reportable to public health; counsel hygiene + safe food/water + vaccine education"},{"label":"C","text":"Liver transplant immediately"},{"label":"D","text":"Antibiotic"},{"label":"E","text":"Discharge no follow-up"}]'::jsonb,
  'B', 'HAV = fecal-oral, self-limited in kids (more severe adults). Supportive care. Monitor for fulminant (rare). Post-exposure prophylaxis = HAV vaccine within 14 d most. HAV vaccine routine 12-23 mo + travelers. Hygiene + food/water safety. Reportable.', NULL,
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

Echo: large PDA 3 mm + L-R shunt + LA/LV enlargement + reverse diastolic flow descending aorta (steal phenomenon)', '[{"label":"A","text":"Wait — PDA closes naturally"},{"label":"B","text":"Hemodynamically significant Patent Ductus Arteriosus (hsPDA) premature: fluid restriction (110-130 mL/kg/d); ventilation optimization (high PEEP); pharmacological closure — Indomethacin 0.2 mg/kg q12h × 3 doses (classical) OR Ibuprofen 10 mg/kg then 5 mg/kg q24h × 2 doses (similar efficacy + fewer renal/GI side effects) OR oral acetaminophen 15 mg/kg q6h × 3-7 days (newer alternative — equally effective in some studies + safer for renal/platelet) — monitor renal function, platelets, NEC, IVH; consider transcatheter PDA closure (Amplatzer Piccolo) increasingly used preterm — particularly if pharm contraindicated/failed; SURGICAL ligation reserved for failed pharm + transcatheter not feasible (now used less due to long-term morbidity); CONSERVATIVE management — many small PDA close spontaneously even in preemies, recent trials (PDA-TOLERATE, BeNeDuctus) question aggressive treatment — selective treatment with hsPDA only; if not hemodynamically significant → observe; monitor RFFD (recurrent BPD, IVH, NEC, mortality); coordinate neonatology + cardiology"},{"label":"C","text":"Surgery routinely all preemies"},{"label":"D","text":"Antibiotic alone"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', 'PDA premature = common, may close spontaneously. Treatment debated — recent trials (BeNeDuctus, PDA-TOLERATE) favor selective for hsPDA. Pharm: indomethacin or ibuprofen (renal/GI risk) or acetaminophen (safer profile). Transcatheter Piccolo emerging. Surgery rarely.', NULL,
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
TTE then TEE: vegetation 8 mm aortic valve + small abscess root', '[{"label":"A","text":"Outpatient oral antibiotic"},{"label":"B","text":"Infective Endocarditis confirmed (modified Duke criteria — major: typical organism + echo evidence): admit + IV antibiotic — Penicillin G 200,000-300,000 U/kg/d ÷ q4-6h OR Ceftriaxone 100 mg/kg/d once daily (for penicillin-susceptible Strep viridans) + Gentamicin 3 mg/kg/d ÷ q8h × first 2 weeks (synergy short-course); total duration 4 weeks IV (uncomplicated native valve) or 6 weeks (prosthetic, complications); blood culture follow-up 48-72 hr q week × duration; daily TTE/weekly serial monitoring vegetation + complications; pediatric infectious disease + cardiology + cardiac surgery consultation; SURGICAL INDICATIONS (~50% need surgery): heart failure, abscess, persistent bacteremia despite appropriate antibiotic, large vegetation > 10 mm with embolism, fungal IE, prosthetic dehiscence; complications surveillance — embolic events (stroke, kidney, spleen, mycotic aneurysm), heart failure, abscess; supportive — anti-HF if HF, anticoagulation NOT routine; oral health + dental followup; secondary prevention — AHA 2007/2021: antibiotic prophylaxis for selected dental/respiratory procedures in high-risk lesions only (prosthetic, prior IE, cyanotic unrepaired, < 6 mo post-repair with material, repair with residual defect adjacent to material, transplant valvulopathy); long-term: cardiology follow-up + heart failure monitoring"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Steroid"},{"label":"E","text":"Surgery without antibiotic"}]'::jsonb,
  'B', 'IE in kids with CHD = important consideration. Modified Duke criteria. TEE > TTE for vegetations/abscess. Long-course IV antibiotic + surgical evaluation for indications. AHA 2007/2021: prophylaxis only highest-risk lesions, not all murmurs. Oral hygiene + dental.', NULL,
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
INTERMACS profile 3-4', '[{"label":"A","text":"Diuretic alone"},{"label":"B","text":"Pediatric Decompensated Heart Failure (cardiogenic shock approaching): admit ICU; ABC + supplemental O2 (BiPAP/HFNC, intubation if respiratory failure); hold/pause carvedilol acutely (negative inotrope, restart when compensated); continue ACEI if BP tolerates (otherwise hold); IV diuretic — furosemide 1-2 mg/kg IV bolus then continuous infusion 0.1-0.5 mg/kg/hr titrate UO; correct electrolytes (K, Mg); INOTROPIC SUPPORT — Milrinone 0.25-0.75 mcg/kg/min (preferred — inodilator, reduces afterload + improves cardiac output, less arrhythmogenic, avoid if hypotension or renal failure) OR Dobutamine 5-15 mcg/kg/min OR low-dose epinephrine if hypotension; mechanical circulatory support — ECMO or VAD (Berlin Heart EXCOR pediatric LVAD widely used) if refractory to medical management = bridge to transplant; advanced HF + transplant team referral early (urgent listing); strict ins/outs + daily weight; volume optimization; address arrhythmia (ICD for primary/secondary prevention SCD); long-term once stable — beta-blocker + ACEI/ARB + spironolactone + sometimes ivabradine; sacubitril/valsartan emerging peds (PANORAMA trial); device therapy (ICD, CRT) selected; nutrition + cardiac rehab; psychosocial; transition adult; transplant outcomes peds excellent (1-yr 90%+, 5-yr 80%)"},{"label":"C","text":"ACEI alone"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Vasodilator only without inotrope"}]'::jsonb,
  'B', 'Pediatric decompensated HF = ICU + careful balance. Milrinone preferred inotrope. Mechanical support (ECMO, Berlin Heart) bridge to transplant. Hold beta-blocker acutely. Continue ACEI if tolerates. Transplant evaluation early. Long-term: optimize medical + device + transplant.', NULL,
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
Rectal suction biopsy: AGANGLIONIC + hypertrophied nerve fibers + acetylcholinesterase + = Hirschsprung disease', '[{"label":"A","text":"Wait — outgrow"},{"label":"B","text":"Hirschsprung Disease (congenital aganglionic megacolon, classic): pediatric surgery referral urgent; initial management — saline rectal irrigations (decompression, prevent enterocolitis) BID-TID until surgery; broad-spectrum antibiotic prophylaxis (Hirschsprung-associated enterocolitis HAEC is life-threatening — fever + distension + bloody/explosive stool, mortality 30%, treat early with IV antibiotic + irrigation + NPO + IV fluids + surgical assessment for perforation/toxic megacolon); definitive surgery — pull-through procedure (Soave, Swenson, Duhamel) — typically performed 3-6 mo of age (single-stage primary pull-through if stable, or staged with colostomy if extensive disease/severe enterocolitis); post-op — irrigation continued first months, monitor for HAEC, soiling/constipation common (manage with bowel program, biofeedback, sphincter assessment); long-term: most achieve near-normal continence (60-80%), but HAEC risk persists; total colonic Hirschsprung worse prognosis; family genetic counseling (RET mutation, 5-10% familial); associated conditions screen — Down syndrome (CRSI), other syndromes; long-term follow-up bowel function + growth; education families about HAEC signs + emergency contact"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Laxative"}]'::jsonb,
  'B', 'Hirschsprung = delayed passage meconium (> 48 hr term) + bowel obstruction + transition zone. Confirm rectal biopsy (aganglionosis). HAEC = life-threatening complication. Pull-through 3-6 mo. Saline irrigations bridge. Long-term continence usually good. Genetic screening selected.', NULL,
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
US: kidneys normal size + echogenicity, no obstruction', '[{"label":"A","text":"High-dose diuretic alone"},{"label":"B","text":"AKI Stage 3 (Cr > 3× baseline) — likely intrinsic ATN from prolonged hypovolemic-prerenal then ATN (also consider HUS but no MAHA/thrombocytopenia here, post-infectious GN, drug-induced, NSAID-related): assess + treat reversible factors — adequate volume status (carefully — if hypovolemic give IV fluid challenge 10-20 mL/kg, otherwise restrict to insensible + UO if euvolemic/overloaded); STOP nephrotoxic drugs (NSAID, aminoglycoside, IV contrast, ACEI); manage HYPERKALEMIA — calcium gluconate (cardiac protection if ECG changes), insulin + glucose, albuterol nebulizer, sodium bicarbonate if acidotic, kayexalate (selected pediatric — caution), dialysis if refractory or > 6.5; correct acidosis (sodium bicarb if pH < 7.2 or HCO3 < 12); manage hyperphosphatemia + hypocalcemia — phosphate binder; nutritional support — adequate calorie, restrict K + P + Na, modest protein (1-1.5 g/kg/d, NOT severe protein restriction); RENAL REPLACEMENT THERAPY indications (peds AEIOU): A — Acidosis severe, E — Electrolyte (K refractory), I — Intoxication, O — Overload severe with respiratory compromise, U — Uremia symptomatic; modalities — hemodialysis (typical for child), CRRT (hemodynamically unstable, ICU), peritoneal dialysis (younger, available, hemodynamically tolerant); pediatric nephrology consultation; monitor recovery (typical ATN recovers 1-3 wk); long-term follow-up — CKD risk 30-50% even after recovery, BP monitoring, growth, schooling"},{"label":"C","text":"Restrict all fluid + protein severely"},{"label":"D","text":"Antibiotic alone"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', 'Pediatric AKI = KDIGO criteria. Common causes: prerenal (dehydration), ATN, HUS, GN, obstruction, drug-induced. Stop nephrotoxin. Manage hyperK + acidosis + fluid carefully. RRT for refractory AEIOU. Long-term CKD risk → follow-up. Multidisciplinary.', NULL,
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
Echo: mild LVH (LV mass index increased)', '[{"label":"A","text":"Antihypertensive only without lifestyle"},{"label":"B","text":"Pediatric Hypertension Stage 1 (likely primary/essential associated with obesity) — AAP 2017 Clinical Practice Guideline: confirm BP > 95th percentile on 3 separate occasions OR ABPM; obesity treatment cornerstone — MULTICOMPONENT lifestyle modification (DASH diet, reduce sodium < 1500-2300 mg/d, increase fruits/vegetables/whole grains, limit sugar-sweetened beverages); physical activity ≥ 60 min/d moderate-vigorous, limit screen time < 2 hr/d; weight management + family-based behavioral therapy; address sleep — screen + treat OSA (polysomnography given snoring + apnea, likely contributes); secondary cause workup — UA + Cr + electrolytes + lipids + glucose + insulin + TSH + plasma renin + aldosterone if young/severe, renal US + ECHO for end-organ damage (LVH suggests need treatment); INDICATIONS pharmacological therapy — secondary HT, symptomatic HT, target organ damage (LVH, CKD, retinopathy), Stage 2 HT, lifestyle modification failure for Stage 1, persistent risk; FIRST-LINE drugs — ACE inhibitor (lisinopril) OR ARB (losartan) OR CCB (amlodipine) OR thiazide; AVOID — abrupt withdrawal beta-blocker, ACEI in pregnancy potential; target < 90th percentile (or < 130/80 adolescents); monitor q3-6 mo + adjust; address comorbid CV risk factors (lipid, glucose); transition to adult care; PARENT/family lifestyle support critical"},{"label":"C","text":"Discharge no follow-up"},{"label":"D","text":"Surgery"},{"label":"E","text":"Single BP check sufficient"}]'::jsonb,
  'B', 'Pediatric HT rising prevalence (obesity epidemic). AAP 2017: new lower BP thresholds. Confirm with multiple measurements + ABPM. Lifestyle modification mainstay. Pharm for secondary, symptomatic, end-organ damage, Stage 2, refractory. ACEI/ARB/CCB/thiazide first-line. Address comorbid CV risk.', NULL,
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
Indirect bilirubin elevated 4.5, LDH elevated, haptoglobin low', '[{"label":"A","text":"Splenectomy immediately for all"},{"label":"B","text":"Hereditary Spherocytosis (autosomal dominant most, spectrin/ankyrin defect): folic acid 1 mg/day lifelong (high RBC turnover); blood transfusion only for aplastic crisis (Parvo B19) or severe symptomatic anemia; recheck CBC + reticulocyte q3-6 mo; ultrasound for gallstones (high prevalence — pigmented stone, prophylactic cholecystectomy at time of splenectomy if stones present); growth monitoring; INDICATIONS for SPLENECTOMY (typically delayed until > 6 yr to allow immune maturation, reduce sepsis risk): severe HS (Hb < 8, severe hyperbilirubinemia, growth failure, gallstones, frequent hospitalizations); subtotal/partial splenectomy emerging — preserves some immune function; PRE-SPLENECTOMY immunizations 2 wk before — pneumococcal (PCV13 + PPSV23), meningococcal (MenACWY + MenB), Hib + influenza annual; POST-SPLENECTOMY — penicillin prophylaxis (Pen V 125 mg BID < 5 yr, 250 mg BID > 5 yr) × minimum 5 years OR lifelong (varies), aspirin for thrombocytosis selected; education sepsis emergency response (fever > 38.5 → urgent evaluation, IV antibiotic — septic risk encapsulated organism lifelong); medical alert; family screening + genetic counseling (autosomal dominant 75%); transition adult"},{"label":"C","text":"Iron supplementation"},{"label":"D","text":"Steroid lifelong"},{"label":"E","text":"Antibiotic prophylaxis only"}]'::jsonb,
  'B', 'HS = most common hereditary hemolytic anemia. EMA flow cytometry standard test (+ osmotic fragility classical). Folate + monitoring + splenectomy for severe. Pre-splenectomy immunization critical. Post-splenectomy infection risk lifelong — counsel + prophylaxis + medical alert. Family screen.', NULL,
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
TSH normal, cortisol normal (post-op on stress steroid)', '[{"label":"A","text":"Free water bolus"},{"label":"B","text":"Severe Symptomatic Hyponatremia from SIADH (post-craniopharyngioma surgery — common in neurosurgical pediatrics from posterior pituitary disruption — can be SIADH or CSW or DI): SEIZURE/severe symptoms → administer 3% Hypertonic Saline 4-6 mL/kg IV over 10-20 min (raise Na ~5-6 mEq/L acutely to abort seizure); reassess + may repeat if seizure recurs; AVOID rapid correction (> 8-10 mEq/L per 24 hr → osmotic demyelination, central pontine myelinolysis) — TARGET correction 6-12 mEq/L first 24 hr then 6-8 mEq/L subsequent; FLUID RESTRICTION 50-75% of maintenance once stable (mainstay SIADH); identify cause — post-op CNS, pain, opiates, medications; treat underlying; differentiate SIADH vs CSW (cerebral salt wasting): SIADH = euvolemic + concentrated urine + low Na; CSW = hypovolemic + concentrated urine + low Na — treatment opposite (CSW needs salt + volume!); helpful — orthostatic BP, weight, FENa, JVP, hematocrit; if CSW → hypertonic saline + 3% saline maintenance + fludrocortisone if persistent; consider DDAVP-induced if recent DI episode + DDAVP given (triphasic response common post-surgery); monitor Na q1-2 hr during acute correction, q4-6 hr subsequent; neuro exam frequent; if too rapid correction occurs — REVERSE with D5W + DDAVP (if needed); endocrine + neurosurgery + nephrology coordinated"},{"label":"C","text":"Diuretic alone"},{"label":"D","text":"Salt restriction"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', 'Post-neurosurgical pediatric hyponatremia = differential SIADH vs CSW vs DDAVP-induced — treatment opposite for SIADH (restrict) vs CSW (replenish salt + volume). Severe symptomatic → 3% saline carefully. Avoid overcorrection → ODS/CPM. Triphasic response possible. Multidisciplinary.', NULL,
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
MRI: post-op changes, no bright spot posterior pituitary', '[{"label":"A","text":"Restrict fluid only"},{"label":"B","text":"Central Diabetes Insipidus (post-surgical, classic triphasic response — DI immediate then SIADH days 3-7 from cell death then permanent DI): Desmopressin (DDAVP) — synthetic vasopressin analogue — multiple routes; oral starting dose 50-100 mcg BID-TID titrate to effect (children typically PO or intranasal); intranasal 5-10 mcg q12h titrate; subcutaneous 0.05-0.1 mcg q12h-q24h in NPO/perioperative — most precise; ASSESS for triphasic response — initial DI may transition to SIADH (don''t continue DDAVP rigidly — risk hyponatremia + seizure!); MONITOR carefully — Na, fluid balance, weight, UO daily/q12h initially; allow patient access to fluid + free thirst response (most reliable indicator of need); AVOID — set DDAVP doses without monitoring; gradual increase; risk overcorrection → hyponatremia + seizure (worse if also restricted access to fluid); INSTRUCT — drink to thirst, avoid fixed water intake; family education + emergency plan; medical alert; combine with thyroid + cortisol + GH replacement if panhypopit; ophtho + neuro follow-up; transition adult endocrinology; consider partial deficit (no DI permanent, only transient — recheck 1-3 mo); psychosocial support school"},{"label":"C","text":"Diuretic"},{"label":"D","text":"Limit fluid"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', 'Central DI = ADH deficiency. Post-pituitary surgery: triphasic response (DI → SIADH → permanent DI). DDAVP replacement + drink to thirst + careful monitoring. Combination panhypopituitarism replacements (cortisol, thyroid, GH, ADH). Education + medical alert.', NULL,
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

Lab: LH basal 2.5 (pubertal range — pubertal LH > 0.3 IU/L), FSH 4, estradiol 35, GnRH stimulation test — LH peak 18 (pubertal); bone age 9 yr (advanced 2-3 yr); brain MRI: normal (no CNS lesion = idiopathic central precocious puberty)', '[{"label":"A","text":"Wait + observe"},{"label":"B","text":"Central Precocious Puberty idiopathic (CPP < 8 yr girls, < 9 yr boys, GnRH-dependent): treatment INDICATED in this child because of young age (< 7 yr girls), rapid progression, advanced bone age threatening adult height; GnRH agonist therapy — Leuprolide acetate IM 7.5 mg q1 mo OR Leuprolide depot 11.25-22.5 mg q3 mo OR Histrelin implant SC annual (60-mg implant) — suppress HPG axis + prevent further pubertal progression + preserve adult height; alternatives Triptorelin q1 mo or q3 mo; continue until 11-12 yr girls (after which pubertal progression appropriate); monitor — LH suppressed < 0.3 IU/L 60 min post-injection (or DHEAS for adrenal contribution), estradiol low, growth velocity slows, bone age progression slows; SIDE effects — local injection site, sterile abscess, headache, hot flushes minimal, possible psychological transient mood changes; AVOID — discontinuation without endocrine guidance; PSYCHOSOCIAL support — child + family (advanced physical development + social-emotional issues, body image, social interaction with older-looking peers); investigate for cause if signs concerning (cafe-au-lait → McCune-Albright, neuro findings → CNS lesion, virilization → adrenal/ovarian tumor); peripheral precocious puberty (PPP, GnRH-independent) = different mgmt (treat cause + sometimes letrozole/spironolactone — but this case CPP); long-term: adult height preserved, fertility preserved post-discontinuation, ongoing endocrine follow-up; communication with school"},{"label":"C","text":"Surgery"},{"label":"D","text":"Steroid"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', 'Central precocious puberty (CPP) < 8 girls, < 9 boys = GnRH-dependent. Treat with GnRH agonist (leuprolide, histrelin implant, triptorelin) to preserve adult height + delay social/emotional impact. Workup CNS (MRI mandatory), exclude PPP causes (McCune-Albright, tumors). Psychosocial support.', NULL,
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
Likely medulloblastoma (most common malignant peds brain tumor, posterior fossa, 5-9 yr)', '[{"label":"A","text":"Wait — observe"},{"label":"B","text":"Suspected Posterior Fossa Brain Tumor (likely medulloblastoma) + symptomatic obstructive hydrocephalus + increased ICP: admit + ICU; manage increased ICP — head of bed 30°, avoid hyponatremia, mannitol/3% saline if severe symptoms, dexamethasone 0.15-0.25 mg/kg/dose q6h IV (peritumoral edema reduction); neurosurgery URGENT — external ventricular drain (EVD) for hydrocephalus management OR endoscopic third ventriculostomy (ETV) as definitive surgery; staging — total spine MRI before resection (drop metastases CSF) + cytology lumbar CSF post-operative (with intracranial pressure normalized); SURGICAL RESECTION — maximal safe resection by experienced pediatric neurosurgeon; histology + molecular characterization — medulloblastoma WHO 4 subgroups (WNT, SHH, group 3, group 4) with different prognosis + therapy intensity; ADJUVANT THERAPY — craniospinal irradiation 23.4-36 Gy + posterior fossa boost (limited or omitted in young children < 3 yr to reduce neurocognitive sequelae) + chemotherapy (cisplatin, vincristine, cyclophosphamide, lomustine, etoposide per COG); MOLECULAR-guided treatment intensity — WNT subgroup excellent prognosis, can de-intensify; SHH variable; group 3/4 standard-intensive; LONG-TERM — neurocognitive deficits (XRT cerebellum + hippocampus), endocrinopathy (pan-hypopit), hearing loss (cisplatin), secondary malignancy, vasculopathy, growth, posterior fossa syndrome (mutism transient); MULTIDISCIPLINARY late effects clinic"},{"label":"C","text":"Antibiotic"},{"label":"D","text":"Discharge home"},{"label":"E","text":"LP first"}]'::jsonb,
  'B', 'Pediatric brain tumor = leading cause cancer death kids. Posterior fossa (medulloblastoma, ependymoma, JPA, brainstem glioma) most common. LP CONTRAINDICATED with mass effect. Steroid + neurosurg + complete staging spine + molecular characterization guide therapy. Long-term sequelae substantial.', NULL,
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

FAST exam: free fluid RUQ + LUQ; pelvic XR: pelvic fracture; CXR: pending', '[{"label":"A","text":"MRI brain first"},{"label":"B","text":"Multi-trauma pediatric polytrauma — ATLS/PALS approach: AIRWAY priority (GCS ≤ 8 = intubate, c-spine immobilization throughout); rapid sequence intubation with c-spine inline stabilization, etomidate 0.3 mg/kg + rocuronium 1 mg/kg (avoid succinylcholine in significant head injury, hyperkalemia); BREATHING — bilateral chest sounds, end-tidal CO2, CXR (rule out PTX/HTX/PE), maintain SpO2 ≥ 94%; CIRCULATION — IV/IO × 2 large-bore, type + cross 10 mL/kg PRBC + crystalloid 20 mL/kg max (avoid over-resuscitation), MTP if exsanguinating (1:1:1 PRBC:FFP:platelet), TXA 15 mg/kg over 10 min then 2 mg/kg/hr (CRASH-3, pediatric extrapolation); control external bleeding + pelvic binder; DISABILITY — pupils + GCS, manage increased ICP (head of bed 30°, gentle hyperventilation transient bridge PaCO2 30-35, hypertonic saline 3% 3-5 mL/kg, mannitol option, target CPP > 40); EXPOSURE + environment — prevent hypothermia, log roll spine exam; FAST + bedside US; pan-CT (head + c-spine + chest + abdomen + pelvis) once stable enough; pediatric trauma center transfer if not already at; neurosurgery + general surgery + orthopedic surgery + pediatric ICU multidisciplinary; abdominal injury — splenic/liver lacerations → most managed non-operative if stable; pelvic fracture significant — bleed risk, may need IR/angiography; head injury — CT head, may need neurosurgery if mass lesion; transfusion goal Hb > 7 (10 if active bleed), Plt > 100 if neuro injury, INR < 1.5; tetanus prophylaxis; family liaison + chaplain; secondary survey systematic; reportable to trauma registry"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Antibiotic"},{"label":"E","text":"Wait for MRI"}]'::jsonb,
  'B', 'Pediatric polytrauma = ABC primary survey + secondary survey + multidisciplinary trauma center. Pediatric differences: relatively larger head, smaller airway, kids compensate then crash, c-spine, occult internal bleeding. TXA for major hemorrhage. Non-operative for stable splenic/liver. Avoid over-fluid (worsens coagulopathy).', NULL,
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

No Hx coagulopathy, no medication, no bleeding disorder', '[{"label":"A","text":"CT brain mandatory all head injury"},{"label":"B","text":"Minor head trauma in young child — apply PECARN Pediatric Head Injury Rule (< 2 yr separate criteria, 2-18 yr criteria): age 3 yr (criteria for 2-18 yr) — assess PECARN risk factors: 1) altered mental status (GCS < 15, agitation, somnolence, repetitive questioning, slow response) — NO here, 2) loss of consciousness — NO, 3) vomiting — NO, 4) severe mechanism (MVC ejected, death, rollover; pedestrian/cyclist without helmet struck; fall > 5 ft/1.5 m for > 2 yr; head struck by high-impact object) — fall 1.2 m is below threshold = NO, 5) signs basilar skull fracture — NO, 6) severe headache — NO; ALL PECARN criteria NEGATIVE = very low risk (< 0.05% ciTBI) → recommend observation only, NO CT indicated; explain to family — observe at home × 24-48 hr with return precautions (worsening headache, repeated vomiting, AMS, focal deficit, seizure, irritability not improved, fluid from nose/ear, gait abnormality); injury prevention counseling — safety practices feeding chair, supervision, helmets/seatbelts, fall prevention; consider age + parental concern + injury mechanism + clinician experience in shared decision-making; if observation in ED 4-6 hr selected scenarios; head injury results in concussion → return to learn + play progression"},{"label":"C","text":"Discharge no instruction"},{"label":"D","text":"MRI immediately"},{"label":"E","text":"Skull XR"}]'::jsonb,
  'B', 'PECARN HIR (Kuppermann Lancet 2009) reduces CT use in low-risk pediatric head injury (radiation exposure concern). Risk stratification: very low (no factors) = observe; intermediate (1+ factors) = observe/clinician judgment; high-risk = CT. Family education + return precautions. Shared decision-making.', NULL,
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
Family wants to know about return to play', '[{"label":"A","text":"Return to play 24 hr after injury"},{"label":"B","text":"Sport-Related Concussion — physical + cognitive rest first 24-48 hr then gradual return (CISG/Berlin 2017 + Amsterdam 2022 Consensus): SYMPTOMATIC initially — relative rest 24-48 hr (no school, no athletics, limit screens) then GRADUATED return as symptoms improve, NOT complete rest beyond 48 hr (recent evidence: prolonged rest = worse outcomes); RETURN-TO-LEARN progression — light cognitive activity at home → return school with accommodations (extended time, reduced workload, breaks, no exams, quieter environment) → full school no accommodation → required before return to play; RETURN-TO-PLAY 6-step graduated progression — each step ≥ 24 hr, advance only if symptom-free: 1) symptom-limited activity, 2) light aerobic exercise (walking, stationary bike), 3) sport-specific exercise (running, drills no contact), 4) non-contact training drills (passing, more complex), 5) full contact practice (medical clearance required), 6) return to play; if symptoms recur at any step → drop back one step ≥ 24 hr; medical clearance by trained provider before contact; AVOID — opioids, NSAIDs early (recent concern); manage symptoms — acetaminophen, sleep hygiene, vestibular therapy for dizziness, cervical therapy for neck, neuropsychology assessment for prolonged; SECOND IMPACT SYNDROME — return to contact play before recovery = catastrophic risk, especially adolescent; persistent symptoms > 4 wk = post-concussion syndrome, multidisciplinary team referral; education prevention — helmet, rule changes, safer technique; school + sport responsibility; long-term: most resolve within 1-4 wk pediatric; CTE concern for repetitive head impact long-term"},{"label":"C","text":"Wait 1 year"},{"label":"D","text":"MRI all concussions"},{"label":"E","text":"Discharge no education"}]'::jsonb,
  'B', 'Concussion = brain trauma symptom-based diagnosis. Berlin/Amsterdam consensus: brief rest 24-48 hr then gradual return-to-learn + return-to-play 6-step protocol. Second impact syndrome = preventable catastrophic complication especially adolescent. Pediatric recovery typically 1-4 wk. Education + helmet + rule changes.', NULL,
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
No paresthesia, no torticollis', '[{"label":"A","text":"Remove collar immediately without further evaluation"},{"label":"B","text":"Pediatric Cervical Spine clearance (different rules than adult — NEXUS less validated, PECARN cervical spine recently): pediatric c-spine clearance criteria + approach: 1) high-risk mechanism + clinical factors (altered mental status, focal neuro deficit, midline cervical tenderness, distracting injury, intoxication, age < 3 + difficult to examine) = imaging; 2) without high-risk → clinical clearance — patient awake + alert + no neuro deficit + no tenderness + ROM intact without pain + able to communicate; THIS PATIENT — has midline tenderness → IMAGING indicated; FIRST imaging — lateral cervical XR (lateral, AP, odontoid if cooperative ≥ 5 yr) — assess prevertebral space, alignment (anterior + posterior longitudinal, spinolaminar, posterior spinous), pseudosubluxation C2-3 normal up to age 8 (50% have); if XR equivocal/abnormal OR high-risk mechanism → CT cervical spine (better bony detail than XR but radiation); if neuro deficit OR persistent symptoms with normal CT → MRI (ligamentous, cord, dynamic); MAINTAIN c-collar until cleared (immobilization continues); KIDS — relatively larger head + ligamentous laxity → SCIWORA (spinal cord injury without radiographic abnormality) possible especially < 8 yr — high index suspicion; if neuro symptoms despite normal imaging → MRI; pediatric trauma center + neurosurgery if instability or neuro injury; family + child education; long-term — outcome depends on injury severity"},{"label":"C","text":"Wait 1 week"},{"label":"D","text":"MRI without XR"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', 'Pediatric c-spine clearance differs from adult (relatively larger head, ligamentous laxity, SCIWORA risk). Tenderness or high-risk = image. Lateral XR first; CT if equivocal; MRI for cord/ligamentous/SCIWORA. Pseudosubluxation C2-3 normal up to age 8. Multidisciplinary care.', NULL,
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
  s.id, 'board', NULL, 'เด็กชายอายุ 4 ปี Hx anaphylaxis ต่อ ถั่วลิสง 6 mo ก่อน (Epi pen ใช้ — fine) ตอนนี้ asymptomatic เพื่อ counseling + management plan; family asks about prevention + management + new therapy', '[{"label":"A","text":"Severe restriction + isolation"},{"label":"B","text":"Peanut Allergy long-term management + emerging therapies: EMERGENCY ACTION PLAN (written, share school + caregivers + family) — recognize anaphylaxis (mucous membranes/skin + respiratory or GI or hypotension), immediate EpiPen Jr 0.15 mg IM thigh (< 25 kg) → repeat in 5-15 min if no improvement → call EMS → transport to ED; education — antigens, reading labels (FALCPA US, EU mandatory labeling), cross-contamination prevention, restaurant communication, travel; STRICT AVOIDANCE remains cornerstone but allergen avoidance alone — high accidental exposure rate; pediatric ALLERGIST referral — confirm with skin prick test + serum IgE + supervised oral food challenge (gold standard); EARLY ORAL IMMUNOTHERAPY (OIT) — landmark LEAP study (Du Toit NEJM 2015): early introduction of peanut at 4-11 mo in high-risk infants (severe eczema, egg allergy) REDUCES peanut allergy by 80% at age 5 — current AAP/NIAID guideline endorses early introduction; FDA-APPROVED peanut OIT — Palforzia (peanut allergen powder), age 4-17 yr — gradual escalation reduces severity of accidental ingestion (not cure, daily maintenance dose lifelong, anaphylaxis can still occur during therapy — requires trained allergist); Omalizumab (anti-IgE) — recent FDA approval 2024 for food allergy adjunct; SUBLINGUAL IMMUNOTHERAPY + epicutaneous (Viaskin patch) — less robust, alternatives; medical alert bracelet; school 504 plan; mental health — anxiety common families; cross-reactivity (other tree nuts, legumes) — assess individually; revaccinate yearly anaphylaxis EpiPen training; future: monoclonal antibodies, gene therapy emerging"},{"label":"C","text":"No further intervention"},{"label":"D","text":"Skin test only"},{"label":"E","text":"Steroid daily"}]'::jsonb,
  'B', 'Food allergy = chronic disease. EpiPen + emergency plan + strict avoidance + education foundational. LEAP study revolutionized — EARLY introduction peanut in high-risk infants reduces allergy 80%. OIT (Palforzia FDA-approved) + omalizumab adjunctive for desensitization. Long-term allergist follow-up.', NULL,
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

commit;

-- verify after this chunk:
select board_section, count(*) from public.mcq_questions
where board_specialty = 'pediatrics' and exam_source = 'AI-generated-board-seed'
group by 1 order by 1;
