-- ===============================================================
-- หมอรู้ — Board seed: รังสีวิทยา (radiology) — 30 MCQs
-- Safe to paste into Supabase SQL Editor. Re-runnable.
-- ===============================================================

begin;

-- 1/2 ─── mcq_subjects for this specialty ────────────────────
insert into public.mcq_subjects
  (name, name_th, icon, audience, board_specialty, exam_type, question_count)
values
  ('rad_clinical_decision', 'รังสีวิทยา · การตัดสินใจทางเวชกรรม', '🩺', 'board', 'radiology', NULL, 0),
  ('rad_basic_science', 'รังสีวิทยา · วิทยาศาสตร์การแพทย์พื้นฐาน', '🧬', 'board', 'radiology', NULL, 0),
  ('rad_ems_mgmt', 'รังสีวิทยา · การจัดการระบบบริการการแพทย์ฉุกเฉิน', '🚨', 'board', 'radiology', NULL, 0),
  ('rad_integrative', 'รังสีวิทยา · ข้อสอบบูรณาการ', '🧩', 'board', 'radiology', NULL, 0)
on conflict (name) do nothing;

-- 2/2 ─── 30 mcq_questions for radiology ─────────────

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี acute onset right-sided weakness + aphasia × 45 นาที — ER suspects acute ischemic stroke

No contraindications to IV tPA + window time appropriate
คำถาม: imaging protocol for acute stroke', '[{"label":"A","text":"Wait + observe"},{"label":"B","text":"Acute Stroke Imaging Protocol: (1) **Non-contrast CT head FIRST** — rules out hemorrhage (absolute contraindication to thrombolysis); identifies large established infarct; early ischemic signs (loss of gray-white differentiation, hyperdense MCA sign, sulcal effacement); ASPECTS score; (2) **CT angiography (CTA) head + neck** if LVO (large vessel occlusion) suspected — identifies clot location, planning mechanical thrombectomy; (3) **CT perfusion (CTP)** for extended window thrombectomy (DAWN, DEFUSE-3 — 6-24h) — identifies salvageable penumbra (mismatch between infarct core and ischemic tissue); (4) **MRI alternative**: more sensitive for acute ischemia (DWI restricted diffusion within minutes) but slower + less available; MRI for unclear cases, wake-up stroke (FLAIR/DWI mismatch); (5) **Goals**: minimize door-to-imaging-to-needle/groin time; (6) **Thrombolysis (IV tPA or tenecteplase)** within 4.5h (selected up to 9h with imaging — EXTEND); (7) **Mechanical thrombectomy** within 6h (extended to 24h with CTP for selected LVO); (8) **Multidisciplinary stroke team**: ED + radiology + stroke neurology + IR + neurosurgery; (9) **Stroke center designation** drives outcomes; (10) **Post-imaging**: rapid clinical assessment + treatment decision; (11) **Tele-stroke**: increasingly used to expand expertise; (12) **Modern stroke care**: time = brain (1.9 million neurons lost per minute of stroke)"},{"label":"C","text":"Plain X-ray skull"},{"label":"D","text":"Bone scan"},{"label":"E","text":"No imaging"}]'::jsonb,
  'B', 'Acute stroke imaging: non-contrast CT first (rules out hemorrhage). CTA for LVO. CTP for extended window (DAWN, DEFUSE-3 trials). MRI more sensitive but slower. Time = brain. Multidisciplinary stroke team. Modern: CT + CTA + CTP unified protocol enables thrombectomy decision rapidly.', NULL,
  'medium', 'neurology', 'review',
  'radiology', 'clinical_decision', 'neurology', 'adult',
  'AHA/ASA Stroke Guidelines 2019; ACR Appropriateness Criteria', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี acute onset right-sided weakness + aphasia × 45 นาที — ER suspects acute ischemic stroke

No contraindications to IV tPA + window time appropriate
คำถาม: imaging protocol for acute stroke'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี acute onset chest pain + SOB + tachycardia + hypoxia — clinical suspicion of pulmonary embolism (PE)

No renal disease, no contrast allergy, can lie still', '[{"label":"A","text":"No imaging"},{"label":"B","text":"PE Imaging Protocol: (1) **Risk stratification first**: Wells score or revised Geneva → low/intermediate/high; - **Low Wells**: D-dimer first (if low → exclude PE); if positive → imaging; - **High Wells**: skip D-dimer (high false-positive) → direct imaging; (2) **CT Pulmonary Angiography (CTPA) — gold standard imaging**: high sensitivity + specificity; identifies clot location + alternative diagnoses (pneumonia, dissection, pneumothorax); requires contrast (caution in CKD); rapid; widely available; (3) **V/Q scan alternative**: pregnancy (preferred — lower radiation than CTPA per some, controversial — CTPA breast shielding reduces breast radiation); CTPA contraindications (severe allergy, AKI); pediatric; (4) **MRI angiography**: limited use — slow, expensive, motion artifacts; pregnancy/contrast allergy alternative; (5) **Doppler US lower extremity**: alternative for confirming DVT (treat same as PE if positive); selected — pregnant, contrast issues; (6) **Pulmonary angiography (traditional)**: rarely used anymore (invasive, gold standard historically); (7) **Echocardiogram bedside**: right heart strain in massive PE — guides management urgency (thrombolysis vs anticoagulation); (8) **Imaging during pregnancy**: low-dose CTPA (lung doses < V/Q), V/Q (preferred by some); doesn''t justify withholding diagnosis; (9) **Risk-benefit**: contrast nephropathy, radiation (lifetime risk), allergy; (10) **Diagnosis decision**: PE rule-in or rule-out; (11) **Post-diagnosis**: severity stratification (sPESI score) → outpatient vs inpatient + thrombolysis vs anticoagulation alone"},{"label":"C","text":"Bone scan"},{"label":"D","text":"X-ray skull"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', 'PE imaging: risk stratification + D-dimer first for low Wells. CTPA gold standard. V/Q for contrast issues + pregnancy alternative. Bedside echo for hemodynamic significance. Imaging decisions individualized. Modern: CTPA mainstream. Multidisciplinary care.', NULL,
  'easy', 'respiratory', 'review',
  'radiology', 'clinical_decision', 'respiratory', 'adult',
  'ACR Appropriateness Criteria PE; ESC Guidelines PE 2019', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี acute onset chest pain + SOB + tachycardia + hypoxia — clinical suspicion of pulmonary embolism (PE)

No renal disease, no contrast allergy, can lie still'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 45 ปี post-MVC — acute abdominal pain + hypotension + suspected intra-abdominal injury

คำถาม: trauma imaging modality choices', '[{"label":"A","text":"X-ray only"},{"label":"B","text":"Trauma Imaging Protocol: (1) **eFAST (Extended Focused Assessment with Sonography for Trauma)** — bedside US: rapid, no radiation, identifies free fluid (intraperitoneal, pericardial, pleural), pneumothorax (lung sliding); SENSITIVITY HIGH for hemoperitoneum, specific for hemodynamically unstable to OR; LIMITATIONS — operator-dependent, retroperitoneal injuries missed, solid organ injury detection limited; (2) **CT abdomen-pelvis with IV contrast** — gold standard for hemodynamically stable; identifies solid organ injuries (liver, spleen, kidney), bowel injury, vascular injury (extravasation = active bleeding), mesenteric injury, retroperitoneal hemorrhage; high sensitivity + specificity; (3) **CT angiography** for vascular injury suspected (aorta, pelvic vessels); (4) **CT chest** for thoracic injuries; (5) **CT head** for TBI suspicion (GCS < 15, LOC, focal neuro, vomiting, seizure); (6) **Pan-scan vs selective** debate: pan-scan (CT head + neck + chest + abdomen/pelvis) for severe mechanism; selective for minor; modern trend toward more selective + lower radiation; (7) **DPL (diagnostic peritoneal lavage)** essentially replaced by FAST + CT; (8) **Hemodynamically unstable** → OR (no time for CT, FAST guides decision) — laparotomy; (9) **Repeat imaging**: serial CT, US for ongoing changes; (10) **Pediatric**: lower threshold, radiation concerns — MRI more, US first; (11) **Radiation considerations**: ALARA, focused exams when possible; (12) **Multidisciplinary**: trauma surgery + radiology + ED + IR + critical care"},{"label":"C","text":"MRI only"},{"label":"D","text":"Bone scan"},{"label":"E","text":"No imaging"}]'::jsonb,
  'B', 'Trauma imaging: FAST bedside (rapid, no radiation, hemoperitoneum + pneumo); CT gold standard for stable patient (solid organ, bowel, vascular). Hemodynamically unstable → OR. Multidisciplinary trauma team. Radiation considerations. Modern: integrated trauma imaging protocols.', NULL,
  'easy', 'trauma', 'review',
  'radiology', 'clinical_decision', 'trauma', 'adult',
  'ATLS 10th ed; ACR Appropriateness Criteria', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 45 ปี post-MVC — acute abdominal pain + hypotension + suspected intra-abdominal injury

คำถาม: trauma imaging modality choices'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี smoker × 30 pack-year — annual lung cancer screening per USPSTF criteria

คำถาม: lung cancer screening protocol', '[{"label":"A","text":"Chest X-ray annual"},{"label":"B","text":"Lung Cancer Screening — Low-Dose CT (LDCT): (1) **USPSTF 2021 + ACR criteria**: age 50-80 (was 55-77, expanded 2021), ≥ 20 pack-year smoking history (was ≥ 30), current smoker or quit < 15 years; (2) **Modality**: low-dose CT (LDCT) annual — radiation dose 1.5 mSv (vs diagnostic CT 7 mSv); higher sensitivity than CXR; (3) **NLST trial** (NEJM 2011) — 20% reduction in lung cancer mortality vs CXR; (4) **Lung-RADS classification** (1-4 + S category) for nodule management: - 1: < 6 mm — annual screening; - 2: 6-8 mm solid or 6-10 mm part-solid solid component < 6mm — annual; - 3: 8-15 mm solid — 6-month follow-up; - 4A: ≥ 15 mm solid or 8-15 mm growing — short-term follow-up + possible biopsy; - 4B: highly suspicious — tissue diagnosis (biopsy, surgery); - 4X: large + clinical concern — definite intervention; - S: non-lung cancer significant finding (incidental); (5) **Shared decision-making** required by CMS for coverage; (6) **Smoking cessation counseling** at every screening visit — most important intervention; (7) **Multidisciplinary**: primary care + pulmonary + thoracic surgery + radiology; (8) **Adverse effects**: false positives, anxiety, complications from workup, overdiagnosis (some indolent cancers found), radiation exposure cumulative; (9) **Tracking**: registry, follow-up, communication; (10) **Modern**: AI-assisted reading + nodule characterization emerging"},{"label":"C","text":"Bronchoscopy"},{"label":"D","text":"Sputum cytology"},{"label":"E","text":"No screening"}]'::jsonb,
  'B', 'Lung cancer screening: LDCT annual for high-risk (USPSTF 2021 — age 50-80, ≥ 20 pack-yr, < 15 yr quit). NLST 20% mortality reduction. Lung-RADS for nodule management. Shared decision-making. Smoking cessation. Multidisciplinary. Modern: expanded eligibility 2021 + AI-assisted reading.', NULL,
  'easy', 'respiratory', 'review',
  'radiology', 'clinical_decision', 'respiratory', 'adult',
  'USPSTF Lung Cancer Screening 2021; Lung-RADS; NLST NEJM 2011', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี smoker × 30 pack-year — annual lung cancer screening per USPSTF criteria

คำถาม: lung cancer screening protocol'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 55 ปี routine mammography screening — finding: BI-RADS 4 (suspicious calcifications + spiculated mass)

คำถาม: breast imaging workup + management', '[{"label":"A","text":"Ignore"},{"label":"B","text":"Breast Imaging Workup BI-RADS 4 (Suspicious): (1) **BI-RADS Classification** (0-6): - 0: incomplete — additional imaging needed; - 1: negative; - 2: benign; - 3: probably benign (< 2% malignancy) — short-interval follow-up 6 months; - 4: suspicious (2-95% malignancy — broad range, subcategories 4A/B/C) — tissue diagnosis; - 5: highly suggestive (> 95% malignancy) — tissue diagnosis + surgical planning; - 6: known biopsy-proven malignancy; (2) **BI-RADS 4 management = tissue biopsy**: - Image-guided core needle biopsy preferred (stereotactic for calcifications, US-guided for masses); - Vacuum-assisted biopsy more tissue; - Fine needle aspiration (FNA) less preferred (cytology only — not architecture); (3) **Pre-biopsy imaging optimization**: diagnostic mammogram + US correlation; MRI in selected cases (high-risk, extensive disease, dense breasts); (4) **Pathology results**: benign (concordance — review imaging vs path), atypical hyperplasia (excisional biopsy — upgrade to malignancy 20%), DCIS, invasive cancer; (5) **Multidisciplinary tumor board** for any malignancy or atypia; (6) **Genetic counseling/testing** if young, family history, certain pathology (triple-negative); (7) **Risk assessment**: BRCA, Tyrer-Cuzick model; (8) **Surveillance**: post-treatment annual mammogram + clinical breast exam; possibly supplemental imaging for dense breasts; (9) **High-risk screening**: BRCA+, prior chest radiation, 5-yr Gail risk > 20% → annual MRI + mammogram alternating q6 months; (10) **Multidisciplinary**: radiology, breast surgery, medical oncology, pathology, genetics, primary care, psychology"},{"label":"C","text":"Refuse care"},{"label":"D","text":"Mastectomy without biopsy"},{"label":"E","text":"Avoid mammography"}]'::jsonb,
  'B', 'BI-RADS 4 (suspicious): tissue diagnosis required. Image-guided core biopsy preferred. Subcategories 4A-C reflect malignancy probability. Multidisciplinary tumor board for findings. Genetic counseling. High-risk surveillance. Modern: standardized BI-RADS + multidisciplinary care.', NULL,
  'medium', 'hemato_onco', 'review',
  'radiology', 'clinical_decision', 'hemato_onco', 'adult',
  'ACR BI-RADS 5th Edition; NCCN Breast Cancer Screening', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'หญิงอายุ 55 ปี routine mammography screening — finding: BI-RADS 4 (suspicious calcifications + spiculated mass)

คำถาม: breast imaging workup + management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 5 ปี trauma to head from fall — ED suspects head injury — pediatric imaging considerations

GCS 13, vomiting × 2, no LOC, no focal neuro deficit + no seizure', '[{"label":"A","text":"CT immediately"},{"label":"B","text":"Pediatric Imaging — Radiation Considerations + PECARN Rules: (1) **Pediatric radiation concerns**: cancer risk per dose 3-4× higher than adult (BEIR VII); cumulative exposure lifetime risk; ALARA principle; alternatives when possible (US, MRI); (2) **PECARN Head Injury Rules** (validated decision tools — reduce CT use): - Age < 2: high-risk features (GCS < 15, AMS, palpable skull fracture, loss of consciousness ≥ 5s, severe MOI, non-frontal scalp hematoma, behavior change per parents) → CT; - Age 2-18: high-risk features (GCS < 15, AMS, signs of basilar skull fracture, vomiting, severe headache, LOC, severe MOI) → CT; - No high-risk → observation; (3) **Selective imaging**: observation in lower-risk + reassurance + return precautions; (4) **Imaging modalities for pediatric**: - **US first-line** for many indications (appendicitis, intussusception, DDH, lumbar puncture guidance, pyloric stenosis); no radiation; - **MRI** when possible (no radiation but sedation needed in young, longer); - **CT** when needed for trauma, vascular, complicated infection — use low-dose protocols, pediatric-specific (Image Gently campaign); - **Plain X-ray** for selected (chest, skeletal survey for abuse, foreign body); (5) **Image Gently campaign** (Alliance for Radiation Safety in Pediatric Imaging) — child-sized doses, fewer scans, image only when needed; (6) **Multidisciplinary**: pediatric ED + radiology + surgery + neurology; (7) **Family counseling**: radiation risks + benefits; (8) **Documentation**: track cumulative radiation in child"},{"label":"C","text":"X-ray skull"},{"label":"D","text":"MRI emergent"},{"label":"E","text":"No imaging"}]'::jsonb,
  'B', 'Pediatric imaging: radiation safety paramount. PECARN rules for head injury reduce unnecessary CT. US first-line for many. MRI alternative when feasible. Image Gently campaign. Multidisciplinary care. Family counseling. Modern: validated rules + low-dose protocols + alternative modalities.', NULL,
  'medium', 'trauma', 'review',
  'radiology', 'clinical_decision', 'trauma', 'peds',
  'Image Gently; PECARN Rules; ACR Pediatric Imaging', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'เด็กชายอายุ 5 ปี trauma to head from fall — ED suspects head injury — pediatric imaging considerations

GCS 13, vomiting × 2, no LOC, no focal neuro deficit + no seizure'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 70 ปี acute abdominal pain + distension + N/V — concerned bowel obstruction

คำถาม: abdominal imaging selection', '[{"label":"A","text":"X-ray only"},{"label":"B","text":"Acute Abdomen Imaging: (1) **Plain abdominal X-ray (upright + supine)**: bowel obstruction (dilated loops, air-fluid levels), free air (under diaphragm — perforation), foreign body, calcification (gallstone, urolith); limited sensitivity but quick + cheap; (2) **CT abdomen-pelvis with IV + oral contrast** — gold standard for most acute abdomen: bowel obstruction (point of transition, mechanism), perforation, ischemia, appendicitis, diverticulitis, pancreatitis, abscess, mass, vascular; high sensitivity + specificity; risk: contrast nephropathy, radiation; (3) **CT angiography**: mesenteric ischemia, vascular pathology, GI bleeding source (CTA + active extravasation); (4) **US abdomen** for selected: gallstones + cholecystitis (sensitivity 95% for stones), AAA, bladder, hydronephrosis, ovarian, pregnancy, pediatric; operator-dependent; no radiation — preferred pediatric + pregnant; (5) **MRI** for selected: pregnancy (better characterization than US), complex liver/pancreas/biliary, pelvic; no radiation; longer; (6) **MRCP** for biliary; (7) **HIDA scan** for cholecystitis when US equivocal; (8) **ERCP** therapeutic for biliary (after diagnosis); (9) **Selection factors**: clinical suspicion, hemodynamic stability, pregnancy, renal function, allergy; (10) **For SBO (small bowel obstruction)**: CT identifies cause (adhesions most common — 60%, hernia 15%, tumor 15%, IBD); guides surgery vs conservative; (11) **For appendicitis**: US first in pediatric/pregnant/young female; CT if equivocal; (12) **Multidisciplinary**: ED + surgery + radiology + GI"},{"label":"C","text":"MRI only"},{"label":"D","text":"Bone scan"},{"label":"E","text":"No imaging"}]'::jsonb,
  'B', 'Acute abdomen imaging: X-ray quick screening (obstruction, perf). CT gold standard most. US for selected (gallstones, pregnancy, peds). MRI for special. Selection by clinical scenario + contraindications. Multidisciplinary care. Modern: CT mainstay but US + MRI selective.', NULL,
  'easy', 'gi', 'review',
  'radiology', 'clinical_decision', 'gi', 'adult',
  'ACR Appropriateness Criteria Acute Abdomen', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 70 ปี acute abdominal pain + distension + N/V — concerned bowel obstruction

คำถาม: abdominal imaging selection'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี known HCC (hepatocellular carcinoma) — going for interventional radiology procedure

คำถาม: IR procedure options for HCC', '[{"label":"A","text":"Surgery only"},{"label":"B","text":"Interventional Radiology for HCC: (1) **Multidisciplinary tumor board** decides treatment per BCLC (Barcelona Clinic Liver Cancer) staging: very early/early — resection, transplant, ablation; intermediate — TACE; advanced — systemic; terminal — palliative; (2) **Locoregional therapies (IR)**: - **Radiofrequency ablation (RFA) or microwave ablation**: small tumors < 3 cm (or selected up to 5 cm) — curative-intent percutaneous; - **Transarterial Chemoembolization (TACE)**: standard for intermediate-stage HCC (Child-Pugh A-B, multinodular, no vascular invasion); conventional with lipiodol + chemo, or drug-eluting beads (DEB-TACE); HEPS to deliver chemo selectively to tumor via hepatic artery (HCC blood supply); - **TARE (Transarterial Radioembolization) / Yttrium-90**: radiation delivered via microspheres into hepatic artery; alternative to TACE; useful in larger tumors, portal vein thrombosis; - **Stereotactic Body Radiation Therapy (SBRT)**: external; selected; - **Hepatic Artery Infusion (HAI)** chemo less common; (3) **Selection**: tumor characteristics (size, number, location, vascular invasion), liver function (Child-Pugh, MELD), performance status, comorbidity, transplant candidacy; (4) **Bridging to transplant**: TACE/RFA prevent dropout; (5) **Combined modalities**: TACE + RFA, sequential systemic + locoregional; (6) **Systemic therapy** (BCLC advanced): atezolizumab + bevacizumab (IMbrave150 — first-line), sorafenib historic, lenvatinib alternative, multiple TKIs second-line; emerging immunotherapy combinations; (7) **Outcomes**: BCLC stage-based; modern: significantly improved with new IR + systemic; (8) **Surveillance**: AFP + imaging (US + alternating MRI/CT) every 6 months in cirrhosis; (9) **Multidisciplinary**: hepatology + GI surgery + IR + medical oncology + transplant + pathology"},{"label":"C","text":"Refuse"},{"label":"D","text":"No treatment"},{"label":"E","text":"Hospice only"}]'::jsonb,
  'B', 'IR for HCC: multidisciplinary BCLC-based. RFA/MWA for early. TACE for intermediate. TARE/Y90 alternative + portal vein thrombosis. Bridging to transplant. Combined modalities. Modern systemic (atezolizumab + bevacizumab IMbrave150). Multidisciplinary essential.', NULL,
  'hard', 'hemato_onco', 'review',
  'radiology', 'clinical_decision', 'hemato_onco', 'adult',
  'AASLD HCC Guidelines; BCLC Staging', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี known HCC (hepatocellular carcinoma) — going for interventional radiology procedure

คำถาม: IR procedure options for HCC'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี acute massive GI bleeding (hematemesis + melena) — hemodynamically unstable + multiple units PRC needed

คำถาม: imaging + intervention', '[{"label":"A","text":"Wait + observe"},{"label":"B","text":"Acute GI Bleeding Imaging + IR: (1) **Initial**: resuscitation + endoscopy (UGIB → EGD; LGIB → colonoscopy after prep — except massive); (2) **CT angiography (CTA)**: identifies active bleeding (extravasation of contrast), localizes source, guides angiography; useful when endoscopy fails, unable to localize, or as planning for IR; rapid + non-invasive; (3) **Conventional angiography + transcatheter intervention**: - Diagnostic catheterization of celiac, SMA, IMA; - Identifies extravasation, pseudoaneurysm, AVM; - **Therapeutic options**: - Coil embolization (most common); - Particle embolization (PVA particles); - Glue embolization; - Vasopressin infusion (less common modern); - Stent for vessel injury; (4) **Specific scenarios**: - Variceal bleeding — endoscopy first (banding); TIPS for refractory; - Peptic ulcer — endoscopy first; embolize gastroduodenal artery if persistent; - Diverticular bleeding — endoscopy + embolization if continuous; - Lower GI bleeding — angiography may localize when colonoscopy difficult; - Aortoenteric fistula — surgical; (5) **TIPS (Transjugular Intrahepatic Portosystemic Shunt)**: variceal bleeding refractory, refractory ascites; reduces portal pressure; (6) **Tagged RBC scan**: detects slower bleeding (0.1-0.5 mL/min) — guides angiography; less specific but sensitive for intermittent; (7) **Multidisciplinary**: GI + IR + surgery + ICU + transfusion; (8) **Massive transfusion**: balanced products + TXA + reversal of anticoagulation; (9) **Endoscopic + IR + surgical** options coordinated; (10) **Outcomes**: mortality higher with delay"},{"label":"C","text":"Surgery first"},{"label":"D","text":"Refuse intervention"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', 'Acute GIB IR: endoscopy first then CTA/angiography for unstable or unlocalized. Transcatheter embolization for persistent bleeding. TIPS for varices. Tagged RBC scan for slow. Multidisciplinary GI + IR + surgery. Modern: minimally invasive, organ-preserving approach.', NULL,
  'medium', 'gi', 'review',
  'radiology', 'clinical_decision', 'gi', 'adult',
  'SIR Guidelines; ACR Appropriateness Criteria', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี acute massive GI bleeding (hematemesis + melena) — hemodynamically unstable + multiple units PRC needed

คำถาม: imaging + intervention'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 65 ปี — colonoscopy finds mass + biopsy confirms adenocarcinoma + needs staging

คำถาม: oncology staging imaging', '[{"label":"A","text":"No staging"},{"label":"B","text":"Colorectal Cancer Staging Imaging: (1) **CT chest/abdomen/pelvis with IV + oral contrast** — gold standard for staging: - Local extent (T) + nodal (N) + distant metastases (M — liver most common, lung second); (2) **MRI pelvis with rectal protocol**: specifically for rectal cancer (vs colon) — better local staging (T category + nodes + circumferential margin + extramural vascular invasion); guides neoadjuvant + surgical approach; (3) **MRI liver** with hepatobiliary contrast (gadoxetate) for equivocal liver lesions or planning resection of mets; (4) **CEA (Carcinoembryonic Antigen)**: tumor marker, baseline + follow-up; (5) **PET-CT (FDG-PET)** indications: equivocal lesions on CT, recurrence workup, before metastasectomy planning, rising CEA without visible disease; not routine for initial staging; (6) **Endoscopic ultrasound (EUS)** for rectal cancer — T staging; (7) **AJCC TNM staging**: Stage I-IV with subcategories — guides treatment; (8) **Molecular testing**: KRAS, NRAS, BRAF, MSI/MMR, HER2 — guides targeted therapy; (9) **Genetic testing**: Lynch syndrome (MSI-H or family history); (10) **Multidisciplinary tumor board**: GI + surgery (colorectal) + medical oncology + radiation oncology + radiology + pathology + genetics; (11) **Treatment based on stage**: Stage I — surgery; Stage II — surgery + adjuvant chemo for high-risk; Stage III — surgery + adjuvant chemo (FOLFOX or CapeOx, IDEA duration); Stage IV — multidisciplinary + systemic + locoregional + selective resection of mets; (12) **Surveillance after treatment**: CT + CEA q3-6 mo × 5 yr; colonoscopy 1 yr + every 3-5 yr"},{"label":"C","text":"Bone scan only"},{"label":"D","text":"Refuse care"},{"label":"E","text":"Surgery without staging"}]'::jsonb,
  'B', 'Colorectal cancer staging: CT chest/abdomen/pelvis standard. MRI pelvis for rectal. MRI liver for mets characterization. CEA baseline. PET-CT for selected. EUS for rectal. Molecular testing essential modern. Multidisciplinary tumor board. Stage-based treatment.', NULL,
  'medium', 'hemato_onco', 'review',
  'radiology', 'clinical_decision', 'hemato_onco', 'adult',
  'NCCN Colon + Rectal Cancer 2024; ACR Appropriateness Criteria', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'หญิงอายุ 65 ปี — colonoscopy finds mass + biopsy confirms adenocarcinoma + needs staging

คำถาม: oncology staging imaging'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 45 ปี acute renal colic — severe flank pain + hematuria — concerned ureterolithiasis

คำถาม: imaging selection', '[{"label":"A","text":"X-ray only"},{"label":"B","text":"Renal Colic Imaging: (1) **Non-contrast CT abdomen-pelvis (CT-KUB)** — gold standard, > 95% sensitivity + specificity for stones; identifies size, location, hydronephrosis, complications; alternative diagnoses if equivocal; (2) **Low-dose CT** preferred for known recurrent stone formers — reduce radiation; (3) **Ultrasound** alternative: pregnant, pediatric, suspected lower risk — detects hydronephrosis, larger stones, but lower sensitivity for ureteral stones; (4) **KUB plain film** — limited (only radiopaque stones — calcium, struvite seen; uric acid invisible); used for follow-up of known stones; (5) **MRI** rarely needed (slow, not great for stones); (6) **Management based on size + location**: < 5 mm — usually passes spontaneously + medical expulsive therapy (alpha-blockers — controversial), hydration, analgesia; 5-10 mm — may need intervention if pain/obstruction persists; > 10 mm or obstructing — urology consult (ureteroscopy, shock wave lithotripsy SWL, percutaneous nephrolithotomy PCNL); (7) **Complications**: infection (obstructed + infected — emergency), AKI, stone obstruction; (8) **Imaging follow-up**: confirm passage or guide intervention; (9) **Stone workup**: 24-hr urine, stone composition analysis, metabolic workup for recurrent; (10) **Hydration + dietary** for prevention; (11) **Multidisciplinary**: ED + urology + radiology + sometimes IR"},{"label":"C","text":"MRI only"},{"label":"D","text":"Bone scan"},{"label":"E","text":"No imaging"}]'::jsonb,
  'B', 'Renal colic: non-contrast CT gold standard. Low-dose CT for recurrent stone formers. US for pregnancy + pediatric. Management based on size + location. Multidisciplinary urology care. Modern: low-dose protocols + selective imaging.', NULL,
  'easy', 'renal_gu', 'review',
  'radiology', 'clinical_decision', 'renal_gu', 'adult',
  'AUA Surgical Stone Disease Guideline; ACR Appropriateness', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 45 ปี acute renal colic — severe flank pain + hematuria — concerned ureterolithiasis

คำถาม: imaging selection'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี severe chest pain radiating to back — concerned acute aortic dissection

คำถาม: imaging for aortic dissection', '[{"label":"A","text":"Wait + observe"},{"label":"B","text":"Acute Aortic Dissection Imaging: (1) **CT angiography (CTA) chest/abdomen/pelvis** — gold standard, rapid, widely available, identifies intimal flap + true/false lumen + extent + branch vessel involvement + complications (rupture, pericardial effusion, malperfusion); (2) **Stanford classification**: - Type A (involves ascending aorta) — surgical emergency (open repair); - Type B (descending only, distal to subclavian) — usually medical management (BP control, beta-blocker, esmolol or labetalol; target HR < 60, SBP 100-120); endovascular (TEVAR) for complicated B; (3) **TEE (transesophageal echocardiogram)**: bedside alternative for unstable patient or contrast contraindication; high sensitivity for Type A; intra-operative monitoring; (4) **MRI** alternative when contrast contraindicated or pregnancy — slower, less widely available emergently; (5) **D-dimer**: highly sensitive (98%) — exclusion in low-risk; nonspecific; (6) **Risk factors**: HT (most), Marfan, Ehlers-Danlos, bicuspid aortic valve, pregnancy, cocaine, trauma, prior aortic surgery; (7) **Initial management while imaging**: BP control + HR control (esmolol or labetalol IV, target HR 60, SBP 100-120); pain control; surgical/IR consult; (8) **Multidisciplinary urgent**: ED + cardiothoracic surgery + radiology + ICU + IR + anesthesia; (9) **High mortality** if Type A unrepaired (1% per hour); (10) **Long-term**: lifelong surveillance imaging, BP control, beta-blocker, genetic counseling if syndromic; (11) **Bedside echocardiogram** rules out pericardial tamponade urgent; (12) **Modern**: aggressive surgical + endovascular care + improved outcomes"},{"label":"C","text":"Refuse"},{"label":"D","text":"Discharge"},{"label":"E","text":"X-ray only"}]'::jsonb,
  'B', 'Aortic dissection: CTA gold standard. Stanford A surgical emergency; B medical/endovascular. TEE bedside alternative. BP + HR control critical. Multidisciplinary urgent care. High mortality without treatment. Modern: aggressive surgical + endovascular + improved outcomes.', NULL,
  'medium', 'cardiovascular', 'review',
  'radiology', 'clinical_decision', 'cardiovascular', 'adult',
  'AHA/ACC Aortic Disease Guidelines; ESC Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี severe chest pain radiating to back — concerned acute aortic dissection

คำถาม: imaging for aortic dissection'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี — knee pain + recent sports injury — clinical exam suggests ACL tear + meniscal injury

คำถาม: knee imaging modality', '[{"label":"A","text":"X-ray only"},{"label":"B","text":"Knee MRI: (1) **X-ray first** to rule out fracture (lateral, AP, sunrise, weight-bearing for OA); (2) **MRI knee** — gold standard for soft tissue + cartilage + bone marrow edema: - ACL/PCL/MCL/LCL ligaments; - Menisci (medial + lateral); - Cartilage; - Bone marrow edema (suggests recent injury, AVN); - Tendons; - Effusion; - Fractures (occult); - Cysts; (3) **MR arthrography**: contrast injected into joint — improves sensitivity for: labral tears (shoulder, hip), meniscal repair vs re-tear, post-surgical evaluation; (4) **US knee**: superficial structures (tendons, ligaments — collateral), effusion; operator-dependent; dynamic; alternative to MRI for some; (5) **CT knee**: bony detail (fractures, loose bodies, surgical planning); not soft tissue; (6) **Bone scan**: stress fractures, infection, AVN — selected; (7) **Clinical-MRI correlation**: clinical exam + history + MRI guides treatment; (8) **Modern**: 3T MRI improved resolution; (9) **Selection**: clinical scenario, expected pathology, contraindications (pacemaker, metallic implants — some MRI-compatible), claustrophobia, cost; (10) **Multidisciplinary**: ortho + sports medicine + radiology + PT"},{"label":"C","text":"Bone scan only"},{"label":"D","text":"Refuse"},{"label":"E","text":"No imaging"}]'::jsonb,
  'B', 'Knee MRI: gold standard for soft tissue + meniscus + cartilage + bone marrow edema. X-ray first for fracture. MR arthrography for selected. US for superficial + dynamic. CT for bone detail. Clinical-MRI correlation. Modern: 3T MRI improved resolution.', NULL,
  'easy', 'trauma', 'review',
  'radiology', 'clinical_decision', 'trauma', 'adult',
  'ACR Appropriateness Criteria', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี — knee pain + recent sports injury — clinical exam suggests ACL tear + meniscal injury

คำถาม: knee imaging modality'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี — chest pain + EKG inconclusive + serial troponins negative — chest pain rule out ACS

คำถาม: cardiac imaging for ACS workup', '[{"label":"A","text":"No imaging"},{"label":"B","text":"Cardiac Imaging for ACS Workup: (1) **Stress echocardiogram**: exercise + dobutamine stress — assesses LV function + regional wall motion at rest + stress; useful for moderate pre-test probability; non-invasive, no radiation; (2) **Stress nuclear (SPECT) myocardial perfusion**: dipyridamole, adenosine, regadenoson + radiotracer — perfusion at rest + stress; radiation exposure; well-established; (3) **Stress MRI**: dobutamine — wall motion; vasodilator — perfusion; no radiation, high resolution; not widely available; (4) **Coronary CT angiography (CCTA)**: detailed coronary anatomy; high sensitivity but lower specificity for hemodynamically significant stenosis; PROMISE trial — non-inferior + identifies non-cardiac causes; preferred in low-intermediate risk; modern advantage; (5) **Invasive coronary angiography**: gold standard for high pre-test probability + intervention planning; (6) **Selection factors**: pre-test probability of CAD (CAD Consortium), patient factors (renal, allergy, ability to exercise, BMI), local availability, cost; (7) **Pre-test probability low**: CCTA or stress imaging (reduces unnecessary invasive); (8) **Pre-test probability high**: invasive angiography directly; (9) **HEART score**: ED chest pain risk stratification (history, EKG, age, risk factors, troponin) — guides imaging decisions; (10) **Modern**: CCTA increasing role + AI-assisted analysis; CT-FFR (fractional flow reserve from CT) emerging; FAME 3 trial; (11) **Multidisciplinary**: ED + cardiology + radiology"},{"label":"C","text":"Refuse"},{"label":"D","text":"Surgery"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', 'Cardiac imaging for ACS: pre-test probability based. CCTA for low-intermediate (PROMISE). Stress echo, nuclear, MRI alternatives. Invasive angiography for high pre-test probability. HEART score guides. Modern: CCTA + AI + CT-FFR emerging. Multidisciplinary.', NULL,
  'medium', 'cardiovascular', 'review',
  'radiology', 'clinical_decision', 'cardiovascular', 'adult',
  'AHA/ACC + ESC Chest Pain Guidelines; PROMISE NEJM 2015', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี — chest pain + EKG inconclusive + serial troponins negative — chest pain rule out ACS

คำถาม: cardiac imaging for ACS workup'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี — palpable thyroid nodule on physical exam — workup', '[{"label":"A","text":"Ignore"},{"label":"B","text":"Thyroid Nodule Imaging Workup: (1) **TSH + Free T4** — first (rule out functional nodule; hyperfunctioning nodules — \\"hot\\" — rarely malignant, less aggressive workup); (2) **Thyroid US** — first-line imaging: nodule characterization, additional nodules, lymph nodes; TI-RADS classification (1-5) by features (composition, echogenicity, shape, margin, calcifications) → guides FNA biopsy decision; ATA + ACR-TIRADS systems; (3) **Indications for FNA biopsy** by TI-RADS + size: highly suspicious (TI-RADS 5) — FNA if ≥ 1 cm; moderately suspicious (TI-RADS 4) — FNA if ≥ 1.5 cm; mildly suspicious — FNA if ≥ 2.5 cm; benign features — no FNA usually; (4) **FNA cytology** Bethesda Classification (I-VI) guides management: - I non-diagnostic; II benign; III AUS/FLUS; IV FN/SFN; V suspicious; VI malignant; (5) **Radioactive iodine uptake (RAIU) scan** for thyrotoxicosis + nodule (functional?); not for nodule characterization alone; (6) **CT/MRI**: large or retrosternal extension, lymph node assessment for known malignancy; (7) **Surgery**: lobectomy or total thyroidectomy + central neck dissection for malignancy; (8) **Modern**: molecular testing (Afirma, ThyroSeq) for indeterminate cytology (Bethesda III/IV) — reduce unnecessary surgery; (9) **Surveillance**: US periodic, growth (per ATA criteria); (10) **Multidisciplinary**: endocrinology + radiology + endocrine surgery + pathology + nuclear medicine"},{"label":"C","text":"Surgery first"},{"label":"D","text":"Refuse care"},{"label":"E","text":"Antibiotic only"}]'::jsonb,
  'B', 'Thyroid nodule: TSH + US first. TI-RADS classification guides FNA. Bethesda cytology classification guides surgery. Modern: molecular testing reduces unnecessary surgery. Multidisciplinary care.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'radiology', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'ATA Thyroid Nodule + Cancer 2015 Guidelines; ACR TI-RADS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี — palpable thyroid nodule on physical exam — workup'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี post-MVC neck pain + neurologic deficit — concerned spinal cord injury

คำถาม: spine imaging trauma', '[{"label":"A","text":"X-ray only"},{"label":"B","text":"Trauma Spine Imaging: (1) **NEXUS criteria + Canadian C-Spine Rule** — identify patients who don''t need imaging (low risk); (2) **CT cervical spine** — first-line for trauma: high sensitivity for bony injury (fractures, dislocations); rapid; widely available; replaces routine X-ray for trauma; (3) **CT thoracic + lumbar spine** for high-energy or focal symptoms; (4) **MRI spine** if: neurologic deficit, suspected ligamentous injury (CT negative but clinical concern), suspected cord injury, evaluate disc + spinal cord + soft tissues; (5) **Plain X-ray**: limited role modern — replaced by CT for trauma; selected (suspected fracture in single area, follow-up); (6) **CT angiography neck**: blunt cerebrovascular injury (BCVI) screening — high-risk mechanism (cervical hyperextension/rotation/distraction, cervical fracture involving foramen, GCS ≤ 8 without explanation, LeFort II/III, basal skull fracture with petrous involvement, neurologic deficit + CT brain inconsistent, near-hanging, severe seatbelt sign) — Denver criteria; (7) **MRI for cord injury**: assess hematoma, edema, contusion, prognosis; (8) **Bedside US**: limited; (9) **Multidisciplinary**: trauma + neurosurgery + orthopedics + radiology + critical care; (10) **C-collar precautions** until cleared; (11) **Treatment based on findings**: stable/unstable fracture, dislocation, cord injury, ligamentous injury; (12) **Modern**: NEXUS rules reduce unnecessary CT; pan-scan for severe mechanism"},{"label":"C","text":"MRI only"},{"label":"D","text":"Refuse"},{"label":"E","text":"No imaging"}]'::jsonb,
  'B', 'Spine trauma imaging: NEXUS/Canadian rules + CT first-line + MRI for neuro deficit/ligamentous. CT angiography for BCVI screen (Denver criteria). Multidisciplinary trauma care. C-collar precautions. Modern: validated decision rules + CT mainstay + MRI selective.', NULL,
  'medium', 'trauma', 'review',
  'radiology', 'clinical_decision', 'trauma', 'adult',
  'EAST + AAST Spine Trauma; NEXUS Rules', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี post-MVC neck pain + neurologic deficit — concerned spinal cord injury

คำถาม: spine imaging trauma'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 70 ปี — elevated PSA 8.2 + abnormal DRE — concerned prostate cancer

คำถาม: prostate imaging + biopsy', '[{"label":"A","text":"Refuse care"},{"label":"B","text":"Prostate Cancer Imaging + Biopsy: (1) **MRI prostate (multiparametric mpMRI)** before biopsy increasingly standard (PRECISION trial NEJM 2018): - T2-weighted (anatomy); - Diffusion-weighted (DWI — apparent diffusion coefficient ADC); - Dynamic contrast-enhanced (DCE — perfusion); - Optional spectroscopy; - **PI-RADS classification** (1-5): probability of clinically significant cancer; (2) **Biopsy approach**: - **Targeted biopsy** (cognitive, fusion, in-bore) of PI-RADS ≥ 3 lesions; - **Systematic biopsy** (12-core template) + targeted = combination approach (best yield); - **Transperineal biopsy** alternative to transrectal (lower infection rate); (3) **Bone scan + CT abdomen/pelvis** for staging if intermediate/high-risk cancer (Gleason ≥ 7, PSA > 20, T3+); (4) **PSMA PET-CT** — emerging: high sensitivity for staging + recurrence detection; FDA approved 2020 (Pylarify, Locametz); (5) **Risk stratification**: NCCN risk groups (very low to very high) — guide treatment; (6) **Treatment options**: active surveillance (low-risk), surgery (radical prostatectomy), radiation (external beam, brachytherapy), focal therapy (HIFU, cryotherapy — selected); androgen deprivation therapy; chemotherapy; targeted; (7) **Multidisciplinary**: urology + radiology + medical oncology + radiation oncology + pathology + primary care; (8) **Genetic counseling**: BRCA + Lynch + others for advanced + family history; (9) **Modern**: MRI before biopsy reduces unnecessary biopsies + finds clinically significant; PSMA PET for staging"},{"label":"C","text":"Ignore"},{"label":"D","text":"Surgery without staging"},{"label":"E","text":"Refuse care"}]'::jsonb,
  'B', 'Prostate cancer: mpMRI before biopsy (PRECISION trial). PI-RADS classification + targeted + systematic biopsy. Bone scan + CT for intermediate/high-risk. PSMA PET emerging. Risk stratification + treatment options. Multidisciplinary. Genetic counseling. Modern: MRI standard + PSMA PET growing.', NULL,
  'medium', 'hemato_onco', 'review',
  'radiology', 'clinical_decision', 'hemato_onco', 'adult',
  'NCCN Prostate Cancer; PRECISION Trial NEJM 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 70 ปี — elevated PSA 8.2 + abnormal DRE — concerned prostate cancer

คำถาม: prostate imaging + biopsy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี post-knee surgery 1 week + acute calf swelling + pain — concerned DVT

คำถาม: DVT imaging', '[{"label":"A","text":"X-ray leg"},{"label":"B","text":"DVT Imaging Diagnosis: (1) **Compression Ultrasound (CUS)** — gold standard imaging: lack of vein compressibility = thrombus; high sensitivity + specificity proximal DVT; can extend to whole leg (whole-leg vs proximal CUS — different protocols); (2) **D-dimer + Wells score** for risk stratification — low Wells + negative D-dimer = exclude DVT; high Wells or positive D-dimer → CUS; (3) **CT venography** alternative — when US technically limited or pelvic/IVC suspected; (4) **MR venography** — pelvic, abdominal, IVC clot characterization; (5) **Contrast venography** historical gold standard — invasive, rarely used; (6) **Initial management while imaging**: anticoagulation if high suspicion (LMWH or DOAC); (7) **Confirmed DVT**: - Anticoagulation (DOAC first-line for most — apixaban, rivaroxaban; LMWH for cancer-associated; warfarin for selected) duration based on provoked vs unprovoked, comorbidity, bleeding risk; - IVC filter for absolute anticoagulation contraindication; - Catheter-directed thrombolysis for selected (extensive proximal — ATTRACT trial); (8) **Risk factors**: surgery, immobilization, malignancy, OCP, pregnancy, thrombophilia, prior VTE; (9) **Workup unprovoked DVT**: age-appropriate cancer screening; thrombophilia testing selected (recurrent, young, family history); (10) **Multidisciplinary**: vascular medicine, hematology, IR, primary care; (11) **Prevention**: VTE prophylaxis (mechanical + chemical) post-surgery + immobilized"},{"label":"C","text":"Bone scan"},{"label":"D","text":"Refuse"},{"label":"E","text":"No imaging"}]'::jsonb,
  'B', 'DVT: CUS gold standard. Wells + D-dimer risk stratification. CT/MR venography alternatives. Anticoagulation treatment (DOAC first-line most). IVC filter selected. Thrombolysis for extensive (ATTRACT). Multidisciplinary care. Prevention essential.', NULL,
  'easy', 'cardiovascular', 'review',
  'radiology', 'clinical_decision', 'cardiovascular', 'adult',
  'ACCP CHEST Antithrombotic 2016; ASH Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี post-knee surgery 1 week + acute calf swelling + pain — concerned DVT

คำถาม: DVT imaging'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 75 ปี with CKD3 (eGFR 35) — needs CT scan for cancer staging with IV contrast

คำถาม: contrast considerations + alternatives', '[{"label":"A","text":"No precautions"},{"label":"B","text":"Contrast-Induced Nephropathy (CIN) Risk + Management: (1) **Risk factors**: pre-existing CKD (most important), DM, age > 75, dehydration, contrast volume + osmolality, repeated within 72h, nephrotoxic medications (NSAIDs, ACE/ARB controversial); (2) **Risk stratification**: eGFR > 60 — low risk; 30-60 — moderate; < 30 or dialysis — high risk; (3) **Prevention strategies**: - **IV hydration** with normal saline (Cochrane evidence — most effective) — typically 1 mL/kg/hr × 6-12h pre + post; isotonic bicarbonate alternative (less evidence); - **Use lowest contrast dose** needed; - **Iso-osmolar or low-osmolar contrast** preferred; - **N-acetylcysteine (NAC)** — debated, AMACING trial showed no benefit, recent evidence weak; - **Hold nephrotoxic medications** if possible (NSAIDs, diuretics — although diuretics controversial); - **Hold metformin** day of contrast (lactic acidosis risk if AKI develops); - **Re-dose adjustment** based on Cr; (4) **Alternative imaging** when possible: - **MRI** (gadolinium-based contrast — own risks including nephrogenic systemic fibrosis NSF in severe CKD/dialysis with linear gadolinium agents — use macrocyclic if needed); - **Non-contrast CT** for many indications; - **Ultrasound** for selected; (5) **Contrast allergy** considerations: prior reaction (mild — premedication; moderate/severe — strongly consider alternative or different agent); steroid + diphenhydramine premedication protocol; (6) **Modern**: limited consensus on benefit of NAC; emphasis on hydration + lowest dose + alternatives when possible; (7) **Documentation** + post-contrast Cr monitoring 48-72h; (8) **Multidisciplinary**: radiology + nephrology + ordering physician"},{"label":"C","text":"Refuse imaging"},{"label":"D","text":"Surgery without imaging"},{"label":"E","text":"Random approach"}]'::jsonb,
  'B', 'CIN: risk factors + risk stratification + prevention (IV hydration + low dose). Alternatives (MRI, non-contrast, US). Allergy management. Hold metformin. NAC debated. Documentation + Cr monitoring. Multidisciplinary. Modern: hydration + lowest dose + alternatives when possible.', NULL,
  'medium', 'renal_gu', 'review',
  'radiology', 'clinical_decision', 'renal_gu', 'adult',
  'ACR Contrast Manual; KDIGO AKI', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 75 ปี with CKD3 (eGFR 35) — needs CT scan for cancer staging with IV contrast

คำถาม: contrast considerations + alternatives'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 28 ปี G1P0 GA 24 wk — fever + cough + SOB — concerned pneumonia + considering imaging in pregnancy', '[{"label":"A","text":"Refuse imaging"},{"label":"B","text":"Imaging in Pregnancy — Risk-Benefit: (1) **Principles**: don''t withhold necessary imaging due to pregnancy; risks of undiagnosed disease often exceed imaging risks; informed consent; (2) **Radiation considerations**: - Most diagnostic imaging well below threshold for teratogenic + carcinogenic effects (50 mGy threshold for organogenesis effects, single CXR ~ 0.01 mGy, abdominal CT ~ 10 mGy); - Cumulative dose matters; - Highest sensitivity 8-15 weeks (organogenesis); - Discuss with patient — informed consent; (3) **Imaging selection in pregnancy** (lowest first): - **US** — no radiation, first-line for many; - **MRI without gadolinium** — no radiation, safe in pregnancy (gadolinium relative contraindication — animal data NSF risk); - **CXR** — minimal radiation, lead shielding; for respiratory symptoms; - **CTPA** for PE if needed — low dose (< 10 mGy abdomen), lead shielding breast/abdomen; - **CT abdomen** — if necessary, weigh benefits, lead shielding when feasible; - **Nuclear medicine + interventional radiology** — selective; - **Iodinated contrast** — generally OK if needed (low fetal thyroid risk — check neonatal TFT post-natal if exposed); (4) **Specific scenarios**: - Suspected pneumonia → CXR (minimal radiation); - Suspected PE → V/Q vs CTPA — both reasonable; - Appendicitis → US first, MRI if equivocal; - Trauma → as needed; - Suspected pulmonary edema, dissection — necessary imaging; (5) **Documentation + counseling**: explain to patient, informed consent, document; (6) **Multidisciplinary**: OB + radiology + treating team; (7) **Modern**: pregnant patients should receive appropriate medical care including imaging when indicated"},{"label":"C","text":"Surgery without imaging"},{"label":"D","text":"Ignore symptoms"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', 'Pregnancy imaging: don''t withhold necessary imaging. Most diagnostic imaging well below teratogenic threshold. US/MRI without contrast preferred. CXR safe. CT when indicated with shielding. Risks of undiagnosed disease often exceed imaging risks. Informed consent. Multidisciplinary care.', NULL,
  'medium', 'obgyn', 'review',
  'radiology', 'clinical_decision', 'obgyn', 'adult',
  'ACR Imaging in Pregnancy; ACOG Committee Opinion', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 28 ปี G1P0 GA 24 wk — fever + cough + SOB — concerned pneumonia + considering imaging in pregnancy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง physics — CT imaging principles + dose', '[{"label":"A","text":"No physics relevant"},{"label":"B","text":"CT Physics + Dose: (1) **Principles**: X-ray attenuation through tissues — multiple angles reconstructed into cross-sectional image; Hounsfield Units (HU): air -1000, fat -100, water 0, soft tissue ~ 30-70, bone +1000+; (2) **Image acquisition**: collimation, beam pitch, rotation time, kV (kilovoltage), mA (tube current); (3) **Dose metrics**: - **CTDI (Computed Tomography Dose Index)** — measured in phantom (mGy); - **CTDIvol** — volume CTDI (per slice); - **DLP (Dose Length Product)** — total dose × length (mGy·cm); - **Effective dose** (mSv) — tissue weighting factors per organ; typical chest CT 7 mSv (~ 2 years background radiation); abdomen 10 mSv; head 2 mSv; (4) **Dose optimization (ALARA)**: lower kV (for smaller patients — exponential dose reduction; 100 kV vs 120 = ~ 33% less dose); lower mA + automatic mA modulation (auto-mA, CARE Dose); higher pitch; iterative reconstruction (50-70% dose reduction with similar image quality); pediatric-specific protocols (Image Gently); avoid repeat scans; limit z-axis coverage; (5) **Image quality vs dose trade-off**: noise, contrast, resolution; lower dose = more noise; (6) **Radiation risk**: lifetime cancer risk from radiation (especially young patients, repeat scans); BEIR VII estimates; small individual risk but cumulative; (7) **Modern techniques**: dual-energy CT (material decomposition), spectral CT, AI noise reduction, photon-counting CT (emerging); (8) **Clinical considerations**: dose tracking (cumulative), risk-benefit communication, alternatives when possible (MRI, US)"},{"label":"C","text":"Same as MRI"},{"label":"D","text":"No dose"},{"label":"E","text":"Random"}]'::jsonb,
  'B', 'CT physics: X-ray attenuation + reconstruction. HU values. Dose metrics (CTDI, DLP, effective). ALARA optimization (kV, mA, pitch, iterative reconstruction). Modern: dual-energy, AI noise reduction, photon-counting. Dose tracking + risk communication.', NULL,
  'medium', 'procedures', 'review',
  'radiology', 'basic_science', 'procedures', 'adult',
  'AAPM TG-204; ACR Dose Index Registry', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Resident ถามเรื่อง physics — CT imaging principles + dose'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง physics — MRI principles + safety', '[{"label":"A","text":"Random"},{"label":"B","text":"MRI Physics + Safety: (1) **Principles**: strong magnetic field (1.5T - 7T) aligns hydrogen protons; RF pulse excites; relaxation back to equilibrium emits signal; T1 + T2 relaxation times differ by tissue; gradients localize signal; reconstruction; (2) **Sequences**: T1-weighted (fat bright, fluid dark — anatomy), T2-weighted (fluid bright — pathology, edema), FLAIR (T2 + suppressed CSF — brain lesions), DWI (diffusion — stroke, abscess, tumor), perfusion, MRA (angiography), MRS (spectroscopy), functional MRI; (3) **Contrast**: gadolinium chelates (linear vs macrocyclic — macrocyclic safer in CKD/dialysis due to less NSF — nephrogenic systemic fibrosis); other contrasts (USPIO, gadoxetate for liver); (4) **Safety**: - **Projectile risk** — ferromagnetic objects pulled into magnet (catastrophic); - **MR-conditional vs MR-unsafe** — devices, implants assessed individually; pacemakers + ICDs (newer MR-conditional, requires protocols); cochlear implants, metallic foreign bodies (especially in eye — pre-screen), aneurysm clips, drug pumps; - **Heat (SAR)** specific absorption rate — RF heating, tissue burns risk; - **Acoustic noise** — > 100 dB; ear protection; - **Cryogen quench** — emergency vent; - **Claustrophobia** — open MRI, sedation; (5) **Patient screening**: questionnaire + interview + metal detector; (6) **Pediatric**: sedation often needed (slow + claustrophobic for young); (7) **Pregnancy**: MRI safe at any trimester without gadolinium; gadolinium relative contraindication (avoid unless essential); (8) **Modern**: 3T mainstream; 7T research; AI reconstruction (Compressed Sensing); portable MRI (Hyperfine); functional + connectivity imaging"},{"label":"C","text":"X-ray"},{"label":"D","text":"No safety"},{"label":"E","text":"Same as CT"}]'::jsonb,
  'B', 'MRI: strong magnetic field + RF + gradients + reconstruction. Multiple sequences. Gadolinium contrast — NSF risk in CKD (macrocyclic safer). Safety: projectile, implants, SAR, noise, claustrophobia, cryogen. Patient screening. Pregnancy safe without gadolinium. Modern: higher field strength, AI, portable.', NULL,
  'medium', 'procedures', 'review',
  'radiology', 'basic_science', 'procedures', 'adult',
  'ACR MR Safety; ISMRM', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Resident ถามเรื่อง physics — MRI principles + safety'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง ultrasound principles + applications', '[{"label":"A","text":"Random"},{"label":"B","text":"Ultrasound Principles + Applications: (1) **Physics**: high-frequency sound waves (1-20 MHz) emitted + reflected at tissue interfaces; piezoelectric crystals; differential reflection by tissue density; (2) **Probes**: linear (high frequency, superficial — vascular, MSK, breast), curved/convex (low frequency, deep — abdomen, OB), phased array (cardiac), endocavitary (transvaginal, transrectal); (3) **Modes**: 2D, M-mode (motion over time — cardiac), Doppler (color, pulsed, continuous — flow), 3D/4D, contrast-enhanced US (CEUS — microbubbles); (4) **Advantages**: no ionizing radiation, real-time, portable, repeatable, dynamic, lower cost, bedside POCUS, fetal/pediatric safe; (5) **Limitations**: operator-dependent, bone + air poor transmission, body habitus, limited depth penetration; (6) **Common applications**: abdominal (gallbladder, kidney, aorta, liver, spleen), pelvic (OB, gyn), thyroid, breast, MSK, vascular (Doppler), cardiac (echo), interventional guidance (CVC placement, biopsy, regional anesthesia), trauma (FAST), POCUS (lung, cardiac, abdominal, IVC); (7) **POCUS (Point-of-Care US)**: clinician-performed at bedside — focused, problem-specific; integrated into many specialties; (8) **Training**: hands-on essential; certification programs; (9) **Modern**: handheld US (Butterfly, GE Vscan), AI-assisted image acquisition + interpretation, telemedicine; (10) **Multidisciplinary**: radiology, emergency medicine, critical care, OB, cardiology, anesthesia, family medicine"},{"label":"C","text":"X-ray"},{"label":"D","text":"Random"},{"label":"E","text":"MRI"}]'::jsonb,
  'B', 'US: high-frequency sound waves + piezoelectric crystals. Multiple probes + modes. No radiation, real-time, portable. Bone + air poor transmission. Multiple applications. POCUS integrated into specialties. Modern: handheld + AI + telemedicine.', NULL,
  'easy', 'procedures', 'review',
  'radiology', 'basic_science', 'procedures', 'adult',
  'AIUM Guidelines; SonoSim Curriculum', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Resident ถามเรื่อง ultrasound principles + applications'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง nuclear medicine + PET-CT', '[{"label":"A","text":"Random"},{"label":"B","text":"Nuclear Medicine + PET-CT: (1) **Principles**: radiotracers (radiopharmaceuticals) injected → preferentially accumulate in target tissue → detection of emitted radiation → image; (2) **SPECT (Single Photon Emission CT)**: gamma emitters (Tc-99m most common, I-123, I-131); applications — bone scan, myocardial perfusion, lung V/Q, thyroid scan, parathyroid, sentinel node mapping, DAT scan; (3) **PET (Positron Emission Tomography)**: positron emitters (F-18, Ga-68, C-11); coincidence detection; higher resolution than SPECT; (4) **FDG-PET** (fluorodeoxyglucose F-18): glucose analog — accumulates in metabolically active cells (tumors, inflammation, infection); applications: oncology (staging, treatment response, recurrence), infection/inflammation (FUO, sarcoid, vasculitis, IBD), neurology (dementia — pattern, epilepsy), cardiology (sarcoid, viability); (5) **PET-CT** combined: PET (functional) + CT (anatomic) co-registered; standard now; (6) **Other PET tracers**: 68Ga-PSMA + 68Ga-DOTATATE for prostate cancer + NET; 18F-FAPI emerging; amyloid PET (Pittsburgh compound, florbetapir) for AD; tau PET; (7) **Theranostics**: combination of therapy + diagnostics with same compound — Lu-177 PSMA for metastatic prostate cancer (VISION trial), Lu-177 DOTATATE for NET (NETTER-1); growing field; (8) **Radiation considerations**: doses (FDG-PET ~ 7 mSv body), pregnancy + breastfeeding precautions; (9) **PET-MRI** hybrid emerging; (10) **Modern**: precision medicine + targeted molecular imaging + radioligand therapy"},{"label":"C","text":"X-ray"},{"label":"D","text":"MRI"},{"label":"E","text":"Random"}]'::jsonb,
  'B', 'Nuclear medicine + PET: molecular imaging with radiotracers. FDG-PET widespread oncology + others. PSMA + DOTATATE for prostate + NET. Theranostics emerging (Lu-177 therapy). PET-CT standard; PET-MRI emerging. Modern: precision medicine + radioligand therapy.', NULL,
  'medium', 'procedures', 'review',
  'radiology', 'basic_science', 'procedures', 'adult',
  'SNMMI Guidelines; NCCN', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Resident ถามเรื่อง nuclear medicine + PET-CT'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital implements imaging utilization management + appropriateness criteria', '[{"label":"A","text":"Random ordering"},{"label":"B","text":"Imaging Utilization Management: (1) **Appropriateness criteria** (ACR Appropriateness Criteria, CDS — Clinical Decision Support): evidence-based ratings for imaging by clinical scenario; (2) **CDS at point of order entry**: EMR-integrated; recommendations based on clinical indication + patient factors + alternatives; (3) **Choosing Wisely** initiative: avoid imaging without clinical justification (LBP without red flags, headache without red flags, sinusitis acute uncomplicated, pre-op chest X-ray routine, syncope simple); (4) **Radiation safety**: image only when needed, ALARA, alternatives (US, MRI), pediatric considerations, cumulative dose tracking; (5) **Contrast safety**: CKD screening, allergy management, alternatives; (6) **Reading workflow + quality**: standardized reports, structured reporting, peer review, double reads for selected, AI-assisted; (7) **Communication of findings**: critical results — direct + documented; ACR communication guidelines; (8) **Multidisciplinary collaboration**: ordering physicians, radiologists, imaging staff, IT; (9) **Patient + family education**: indications, alternatives, what to expect; (10) **Quality metrics**: appropriateness, accuracy, turnaround time, patient satisfaction, complication rates, dose; (11) **Equity considerations**: ensure access + reduce disparities; (12) **Modern**: AI assistance, structured reporting, value-based imaging; (13) **Healthcare cost considerations**: high-value imaging"},{"label":"C","text":"No guidelines"},{"label":"D","text":"Random"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', 'Imaging utilization management: ACR Appropriateness Criteria + CDS integrated EMR. Choosing Wisely + ALARA + dose tracking. Critical results communication. Quality metrics. Multidisciplinary. Modern: AI, structured reporting, value-based imaging.', NULL,
  'easy', 'procedures', 'review',
  'radiology', 'ems_mgmt', 'procedures', 'adult',
  'ACR Appropriateness Criteria; Choosing Wisely', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Hospital implements imaging utilization management + appropriateness criteria'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital implements teleradiology + AI in radiology', '[{"label":"A","text":"No technology"},{"label":"B","text":"Teleradiology + AI in Radiology: (1) **Teleradiology**: remote reading of imaging — expands access, after-hours coverage, subspecialty expertise; modern: most major imaging read across distances; (2) **PACS (Picture Archiving + Communication System) + RIS (Radiology Information System)**: digital workflow; integration with EMR; standardized; (3) **AI applications**: - **Triage**: prioritize urgent (intracranial hemorrhage, PE, pneumothorax); - **Detection**: lung nodules, breast lesions, fractures, hemorrhage, embolism; - **Quantification**: lesion measurement, organ volume, bone density, cardiac function; - **Image quality**: noise reduction, motion correction, reconstruction; - **Workflow**: protocoling, hanging protocols, structured reports; (4) **FDA-cleared AI applications growing** (> 500 + as of 2024); (5) **Limitations + concerns**: bias, generalizability, validation, regulatory, integration, training, liability, ethics; (6) **Human-AI collaboration**: AI augments not replaces radiologist; emphasis on subtle findings + workflow efficiency; (7) **Quality + validation**: prospective trials, real-world evidence, post-market surveillance; (8) **Education + training**: residents + practicing radiologists need familiarity; (9) **Patient-facing AI**: explanation, communication; (10) **Equity**: ensure benefits across populations + reduce disparities; (11) **Multidisciplinary**: radiology + IT + leadership + regulatory + patient; (12) **Modern**: AI transforming imaging — increased throughput, missed findings, structured + actionable reports"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Avoid technology"}]'::jsonb,
  'B', 'Teleradiology + AI: expanding access + capabilities. Multiple AI applications: triage, detection, quantification, workflow. FDA-cleared growing. Human-AI collaboration. Limitations: bias, validation, integration. Education + ethics. Modern: AI transforming radiology workflow.', NULL,
  'easy', 'procedures', 'review',
  'radiology', 'ems_mgmt', 'procedures', 'adult',
  'ACR Data Science Institute; RSNA AI Initiative', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Hospital implements teleradiology + AI in radiology'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital implements interventional radiology + image-guided procedures expansion', '[{"label":"A","text":"Random"},{"label":"B","text":"Interventional Radiology (IR) — Image-Guided Minimally Invasive: (1) **Scope**: image-guided diagnostic + therapeutic procedures; replacing many surgeries; (2) **Procedures**: - **Vascular**: angioplasty + stent (peripheral, renal, mesenteric, intracranial), embolization (GI bleeding, uterine fibroids — UFE, AVM, aneurysm coiling, varicocele, tumor — TACE for HCC, splenic artery for hypersplenism), thrombolysis (DVT, PE, stroke — mechanical thrombectomy), IVC filter, central venous access (PICC, port, CVC); - **Non-vascular**: percutaneous biopsy (US, CT-guided), drainage (abscess, biliary, urinary, ascites, pleural), ablation (RFA, microwave, cryo for tumors), vertebroplasty + kyphoplasty (compression fractures), nephrostomy, gastrostomy (PEG/PIG), feeding tubes, TIPS (portal HT), pain procedures (sympathetic blocks, RFA spine); - **Neurointerventional**: aneurysm coiling, AVM embolization, stroke mechanical thrombectomy, carotid stenting; (3) **Multidisciplinary**: IR + referring specialties (oncology, GI, urology, neurology, cardiology, surgery); (4) **Outcomes**: minimally invasive — less morbidity, faster recovery, shorter hospital stay vs open surgery; (5) **Specialization**: IR is a recognized specialty with fellowship training (or IR/DR pathway combined); (6) **Complications**: bleeding, infection, contrast nephropathy, vessel injury, organ injury; (7) **Patient + family education** + informed consent; (8) **Modern**: AI guidance, image fusion, robotic assistance, advanced imaging; (9) **Healthcare value**: cost-effective + improved patient experience"},{"label":"C","text":"Random"},{"label":"D","text":"Avoid"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', 'IR: image-guided minimally invasive — replacing many surgeries. Vascular + non-vascular + neurointerventional procedures. Multidisciplinary. Less morbidity + faster recovery. Recognized specialty. Modern: AI + robotics + advanced imaging. Cost-effective + improved patient experience.', NULL,
  'easy', 'procedures', 'review',
  'radiology', 'ems_mgmt', 'procedures', 'adult',
  'SIR + CIRSE Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Hospital implements interventional radiology + image-guided procedures expansion'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี advanced cancer + chronic pain + multiple complications — integrative imaging + IR care', '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Integrative Imaging + IR for Advanced Cancer Care: (1) **Multidisciplinary tumor board** coordinated approach; (2) **Diagnostic imaging**: staging (CT + PET + MRI), tumor response (RECIST, iRECIST for immunotherapy), surveillance for recurrence; (3) **Image-guided biopsy** for diagnosis + molecular characterization (precision medicine); (4) **Therapeutic IR options based on cancer type**: - Tumor embolization (HCC — TACE, UFE for fibroids — palliation, splenic for hypersplenism); - Ablation (RFA, MWA, cryo) for local control; - Y-90 radioembolization for liver metastases; - Pain procedures (celiac plexus block for pancreatic Ca pain, vertebroplasty for spine mets, peripheral nerve blocks); - Central venous access for chemo (port, PICC); - Biliary stenting for obstruction; - Nephrostomy for ureteral obstruction; - Drainage of effusions, ascites (PleurX catheter for recurrent); - Hemostatic procedures for bleeding (hemoptysis, GI bleed); (5) **Palliative imaging + IR**: focus on quality of life, symptom relief; (6) **Multidisciplinary palliative care** integrated; (7) **Cost-effectiveness**: minimally invasive often replaces more morbid surgery; (8) **Patient + family communication**: realistic expectations, decision-making, advance care planning; (9) **Quality of life metrics**: pain scores, functional, satisfaction; (10) **Long-term care**: ongoing imaging surveillance + IR procedures as needed + transitions to hospice when appropriate"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Refuse care"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', 'Integrative imaging + IR for cancer care = multidisciplinary. Diagnostic + therapeutic. Many IR options for palliation + local control. Quality of life focus. Concurrent palliative care. Cost-effective. Modern: precision + minimally invasive + integrated care.', NULL,
  'hard', 'hemato_onco', 'review',
  'radiology', 'integrative', 'hemato_onco', 'adult',
  'NCCN Survivorship; ASCO + SIR Palliative IR', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี advanced cancer + chronic pain + multiple complications — integrative imaging + IR care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 78 ปี multimorbid + dementia + functional decline + new symptoms — diagnostic + management complexity + multidisciplinary', '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Complex Elderly Patient Integrative Imaging Care: (1) **Goals of care discussion first** — imaging guided by what will change management + values + prognosis; (2) **Comprehensive geriatric assessment**: medical, functional, cognitive, psychosocial; (3) **Imaging selection considerations**: - Can patient tolerate (cooperation, claustrophobia, ability to lie still); - Will imaging change management (avoid imaging not changing care); - Risks of imaging (contrast, radiation, transportation, transition to new environment — confusion, falls); - Sedation needed (additional risk); - Alternatives (less invasive); (4) **Multidisciplinary**: primary care + geriatric medicine + specialists + radiology + nursing + family + palliative care; (5) **Shared decision-making**: patient (if cognitively able), family, surrogate; values + preferences; quality vs quantity of life; (6) **Common scenarios + considerations**: - New symptoms in advanced dementia — careful workup; - Falls — minimal vs full workup; - Acute change — DDx + workup; - Screening cancer — discontinuation often appropriate based on life expectancy; (7) **Imaging modifications**: low-dose protocols, alternatives (US > CT for some), sedation only if essential, mobile imaging when possible; (8) **Family communication**: explain rationale, alternatives, expectations; (9) **Modern**: integrated care + value-based + patient-centered + advance care planning + palliative care concurrent"},{"label":"C","text":"Refuse"},{"label":"D","text":"Always image"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', 'Complex elderly imaging: goals-of-care-driven. CGA + multidisciplinary + shared decision-making. Image selection considers tolerability + will change management + risks + alternatives. Screening discontinuation appropriate based on life expectancy. Modifications for elderly. Family communication. Modern: patient-centered + value-based.', NULL,
  'medium', 'neurology', 'review',
  'radiology', 'integrative', 'neurology', 'adult',
  'AGS Choosing Wisely; ACR', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 78 ปี multimorbid + dementia + functional decline + new symptoms — diagnostic + management complexity + multidisciplinary'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 40 ปี chronic pain syndrome — multidisciplinary diagnostic + therapeutic IR + pain management', '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Chronic Pain — Integrative Diagnostic + IR + Multidisciplinary Care: (1) **Diagnosis + characterization**: comprehensive imaging when needed (MRI for spine, joints; nerve imaging — high-resolution MR neurography or US); (2) **Multidisciplinary pain team**: pain medicine + IR + anesthesia + neurology + orthopedics + PT/OT + psychology + primary care; (3) **IR pain procedures**: - **Spine procedures**: epidural steroid injection (cervical, lumbar; transforaminal, interlaminar), medial branch blocks + RFA for facet pain, sacroiliac joint injections, vertebroplasty/kyphoplasty for compression fractures; - **Peripheral nerve blocks** (image-guided ultrasound or fluoroscopy): occipital nerve, intercostal, sciatic, etc.; - **Sympathetic blocks**: stellate ganglion (CRPS upper extremity), lumbar sympathetic (CRPS lower), celiac plexus (pancreatic cancer pain), superior hypogastric (pelvic pain); - **Joint injections** (US or fluoroscopic guidance): shoulder, hip, knee — corticosteroid, hyaluronic acid; - **Genicular nerve block + RFA** for knee OA pain; - **PRP, prolotherapy** for selected tendon/joint; (4) **Cognitive Behavioral Therapy** for chronic pain — evidence-based; (5) **Multimodal pharmacologic + non-pharmacologic** (per CDC pain guidelines 2022): - Acetaminophen + NSAID (topical preferred for localized); - SNRI (duloxetine) for chronic pain; - Anticonvulsants (gabapentinoids — caution misuse); - Avoid long-term opioids (epidemic, addiction, hyperalgesia); - Topical agents; - Acupuncture; - Mindfulness + meditation; (6) **Functional goals** over pain elimination; (7) **Mental health integration**: depression + anxiety + sleep + trauma history; (8) **Substance use screening**; (9) **Family + work support**: vocational rehabilitation, accommodations; (10) **Modern**: biopsychosocial + multidisciplinary + opioid-sparing + minimally invasive + functional focus"},{"label":"C","text":"Long-term opioids"},{"label":"D","text":"Refuse"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', 'Chronic pain integrative care = multidisciplinary biopsychosocial. Imaging diagnosis. IR procedures (spine, peripheral nerves, sympathetic, joints). CBT + multimodal pharmacologic + non-pharmacologic. Avoid long-term opioids. Functional goals. Mental health integration. Modern: comprehensive opioid-sparing approach.', NULL,
  'hard', 'msk_nontrauma', 'review',
  'radiology', 'integrative', 'msk_nontrauma', 'adult',
  'CDC Pain Guidelines 2022; SIR + ASRA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 40 ปี chronic pain syndrome — multidisciplinary diagnostic + therapeutic IR + pain management'
  );

commit;

-- verify
select board_section, count(*) from public.mcq_questions
where board_specialty = 'radiology' and exam_source = 'AI-generated-board-seed'
group by 1 order by 1;
