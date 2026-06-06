-- ===============================================================
-- หมอรู้ — Board seed: รังสีวิทยา (radiology) — part 4/4 (50 MCQs)
-- Safe to paste into Supabase SQL Editor. Re-runnable.
-- ===============================================================

begin;

-- mcq_subjects for this specialty (idempotent)
insert into public.mcq_subjects
  (name, name_th, icon, audience, board_specialty, exam_type, question_count)
values
  ('rad_clinical_decision', 'รังสีวิทยา · การตัดสินใจทางเวชกรรม', '🩺', 'board', 'radiology', NULL, 0),
  ('rad_basic_science', 'รังสีวิทยา · วิทยาศาสตร์การแพทย์พื้นฐาน', '🧬', 'board', 'radiology', NULL, 0),
  ('rad_ems_mgmt', 'รังสีวิทยา · การจัดการระบบบริการการแพทย์ฉุกเฉิน', '🚨', 'board', 'radiology', NULL, 0),
  ('rad_integrative', 'รังสีวิทยา · ข้อสอบบูรณาการ', '🧩', 'board', 'radiology', NULL, 0)
on conflict (name) do nothing;

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 45 ปี hyperthyroidism + diffuse goiter — radioiodine uptake + scan', '[{"label":"A","text":"Discharge"},{"label":"B","text":"Thyroid uptake + scan — I-123 (or I-131 low dose)"},{"label":"C","text":"Single specialty"},{"label":"D","text":"X-ray sufficient"},{"label":"E","text":"No imaging"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Thyroid uptake + scan — I-123 (or I-131 low dose): (1) **Indications**: - Hyperthyroidism etiology — Graves vs toxic multinodular goiter vs toxic adenoma vs thyroiditis; - Cold nodule characterization (10% malignancy risk); - Ectopic thyroid; - Substernal goiter; - Pre-treatment for radioiodine therapy; (2) **Radioiodine uptake (RAIU)**: - I-123 (preferred — gamma camera imaging) or I-131 (lower dose for diagnostic uptake); - Normal 24-hour uptake ~ 10-30% (varies by lab/iodine intake); - **Increased uptake**: Graves disease (diffuse increased), toxic MNG (patchy/multinodular), toxic adenoma (focal hot), early stages of Hashimoto with hyperthyroidism; - **Decreased uptake**: thyroiditis (subacute, postpartum, silent, drug-induced — amiodarone), exogenous thyroid intake, ectopic thyroid hormone (struma ovarii), iodine excess (contrast — washout 4-6+ weeks), Plummer + cold nodules (focal area decreased in nodule); (3) **Thyroid scan** (planar gamma camera): - **Graves**: diffuse increased uptake; - **Toxic MNG**: multiple hot + cold areas; - **Toxic adenoma**: focal hot nodule + suppressed background; - **Cold nodule**: focal decreased uptake in palpable/US-detected nodule — 10% malignancy risk — needs further workup (US + FNA); - **Hot nodule**: ~ < 1% malignancy — observation often; - **Thyroiditis**: low/absent uptake throughout (de Quervain subacute, postpartum, painful + painless); (4) **Differential of hyperthyroidism**: - **High uptake (true hyperthyroidism — endogenous overproduction)**: Graves, toxic MNG, toxic adenoma, hCG-mediated (gestational trophoblastic, choriocarcinoma); - **Low uptake (release of preformed hormone)**: subacute (de Quervain — viral, tender), silent (postpartum, autoimmune), drug-induced (amiodarone — types 1 + 2, lithium, interferon), iodine-induced thyroiditis, factitious (exogenous T4/T3), struma ovarii (ovarian teratoma producing T4); (5) **Treatment of hyperthyroidism**: - **Graves**: methimazole first-line for most (PTU in pregnancy first trimester due to MMI teratogenicity, then switch to MMI second trimester); radioiodine ablation; thyroidectomy (selected); orbitopathy considerations (teprotumumab, steroids, RT, surgery); - **Toxic MNG / adenoma**: radioiodine or surgery; methimazole bridge; - **Thyroiditis**: supportive (NSAIDs, beta-blockers for sx, steroids for severe); usually self-resolves; - **Subclinical**: individualized; (6) **Thyroid storm**: emergency — multimodal (PTU + iodine + beta-blockers + steroids + cooling + supportive); (7) **Multidisciplinary**: endocrinology + nuclear medicine + endocrine surgery + ophthalmology (Graves orbitopathy)

---

Thyroid uptake/scan: I-123 — high uptake (Graves diffuse, MNG patchy, adenoma focal hot) vs low uptake thyroiditis. Cold nodule 10% malig — US + FNA. Treatment by etiology — Graves (MMI/RAI/surgery), MNG/adenoma (RAI/surgery), thyroiditis (supportive). Multidisciplinary.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'radiology', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'ATA Thyroid Guidelines; SNMMI', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 45 ปี hyperthyroidism + diffuse goiter — radioiodine uptake + scan'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี primary hyperparathyroidism + elevated calcium + PTH — sestamibi scan + 4D-CT for parathyroid localization', '[{"label":"A","text":"Surgery without imaging"},{"label":"B","text":"Parathyroid imaging — pre-operative localization"},{"label":"C","text":"Discharge"},{"label":"D","text":"Single specialty"},{"label":"E","text":"X-ray sufficient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Parathyroid imaging — pre-operative localization: (1) **Indications**: pre-surgical localization for parathyroidectomy in primary hyperparathyroidism (PHP); persistent/recurrent PHP after prior failed surgery; (2) **Sestamibi (Tc-99m sestamibi) scan**: - Concentrates in mitochondria-rich tissue — both normal thyroid + parathyroid; - **Dual-phase**: early image shows thyroid + parathyroid; delayed (2-3 hours) washes out of thyroid faster than parathyroid → focal retention identifies adenoma; - **SPECT/CT** improves anatomic localization (combines functional + structural); - **Sensitivity ~ 80-90%** for single adenoma, lower for multigland disease (~ 40-50%); - **Limitations**: large hyperplasia, very small adenomas, ectopic locations may be missed; (3) **4D-CT (multiphase contrast)**: - Modern modality — non-contrast + arterial (~ 25-30s) + venous + delayed phases; - Parathyroid adenomas: typically intense arterial enhancement with washout (compared to thyroid which retains contrast); - **Sensitivity ~ 90%** — equivalent or superior to sestamibi in many studies; more accurate localization; - **Disadvantages**: radiation (especially relevant for younger patients), iodinated contrast; (4) **Ultrasound**: - Adjunctive — high-frequency probe; - Reliable for orthotopic adenomas in lower neck near thyroid; - Misses retrotracheal, mediastinal, intrathyroidal ectopic locations; - Often combined with sestamibi or 4D-CT; (5) **MRI**: less common, useful for ectopic mediastinal; (6) **PET tracers** — **F-18 fluorocholine PET/CT** — emerging — improved sensitivity, especially when sestamibi negative + small adenomas + multigland disease — selected centers; (7) **Selective venous sampling**: invasive — for failed prior surgery + non-localizing imaging — confirms region; (8) **Algorithm**: most centers combine sestamibi + US first; 4D-CT or PET if non-localizing; (9) **Surgery**: - **Minimally invasive parathyroidectomy** — focused exploration when imaging localizes single adenoma + concordance with intraoperative PTH (drop > 50% from baseline confirms cure); - **Bilateral neck exploration** for multi-gland disease, MEN syndromes, secondary/tertiary hyperparathyroidism, non-localizing imaging; (10) **MEN syndromes** (MEN1, MEN2A) — multigland disease, genetic counseling, parallel surveillance for other tumors; (11) **Multidisciplinary**: endocrinology + endocrine surgery + nuclear medicine + radiology + pathology

---

Parathyroid localization: sestamibi + SPECT/CT (~ 80-90% single adenoma); 4D-CT (~ 90%) — arterial enhancement + washout; US adjunctive. Choline PET emerging. Minimally invasive parathyroidectomy with intra-op PTH if localized. Bilateral exploration for multigland. Multidisciplinary.', NULL,
  'hard', 'endocrine_metabolic', 'review',
  'radiology', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'AAES Parathyroid; SNMMI', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี primary hyperparathyroidism + elevated calcium + PTH — sestamibi scan + 4D-CT for parathyroid localization'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี acute mid GI bleed (jejunum/ileum) + hemodynamically stable + ongoing — IR options', '[{"label":"A","text":"Endoscopy alone for all"},{"label":"B","text":"IR for GI bleeding"},{"label":"C","text":"X-ray sufficient"},{"label":"D","text":"Discharge"},{"label":"E","text":"Single specialty"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** IR for GI bleeding: (1) **Imaging modality selection by location + acuity**: - **Upper GI bleed (proximal to ligament of Treitz)**: endoscopy first (EGD therapeutic); - **Lower GI bleed (colon, rectum)**: colonoscopy after prep; - **Mid GI bleed (small bowel — duodenum past ligament of Treitz to ileocecal valve)**: source-finding challenging; - **Massive ongoing bleeding** (transfusion-requiring, hemodynamically unstable): - **CT angiography (CTA) — first-line** in active bleeding: identifies contrast extravasation (~ 0.3 mL/min sensitivity), localizes source (specific vessel + segment), screens for differential; - **Tagged RBC scintigraphy** (Tc-99m labeled RBCs) — sensitive for slow bleeds (~ 0.05-0.1 mL/min), intermittent — multiple sequential images over hours; localizes general region but not specific vessel; - **DSA (catheter angiography)** — diagnostic + therapeutic — selective catheterization (SMA, IMA, celiac branches) — selective embolization; (2) **IR embolization indications**: - **Active bleeding identified on CTA** with hemodynamic significance + endoscopic failure or inaccessible source; - **Failed endoscopic therapy** (rebleeding, persistent); - **Visceral aneurysms / pseudoaneurysms** (pancreatic, splenic, mesenteric — high rupture risk); - **Hemoptysis** (above) — bronchial artery embolization; - **Postpartum hemorrhage** — uterine artery embolization; - **Pelvic trauma** with pelvic vascular injury; (3) **Embolization techniques**: - **Coils** (definitive vessel occlusion); - **Gelfoam / particulates** (temporary occlusion — recanalizes); - **Vascular plugs**; - **Glue (n-BCA, cyanoacrylate)** — for complex AVMs or selected; - **Onyx** — liquid embolic for complex/distal; - **Super-selective** (target distal as possible to preserve adjacent tissue + minimize ischemia); (4) **Complications**: - **Bowel infarction** — main concern for mesenteric embolization (less if super-selective); - Recurrence/rebleeding; - Access site complications (hematoma, pseudoaneurysm, AVF, DVT); - Contrast-related (allergic, CIN); - Non-target embolization; (5) **Other IR options for GI bleed**: - **TIPS (transjugular intrahepatic portosystemic shunt)** for variceal bleeding refractory to endoscopy (next question); - **BRTO (balloon-occluded retrograde transvenous obliteration)** for selected isolated gastric varices; (6) **Multidisciplinary**: ED + IR + GI + general surgery + critical care + transfusion medicine + radiology

---

GI bleed IR: CTA first-line in active bleed (find extravasation); RBC scan for slow/intermittent. DSA Dx + therapeutic (super-selective embolization with coils, gelfoam, particles, glue). Complications — bowel infarction. TIPS for variceal. Multidisciplinary.', NULL,
  'hard', 'gi', 'review',
  'radiology', 'clinical_decision', 'gi', 'adult',
  'SIR + AGA + ACG', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี acute mid GI bleed (jejunum/ileum) + hemodynamically stable + ongoing — IR options'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี cirrhosis + variceal bleeding refractory to endoscopy + Child-Pugh B — TIPS consideration', '[{"label":"A","text":"Always surgical shunt"},{"label":"B","text":"TIPS (transjugular intrahepatic portosystemic shunt)"},{"label":"C","text":"Discharge"},{"label":"D","text":"Single specialty"},{"label":"E","text":"X-ray sufficient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** TIPS (transjugular intrahepatic portosystemic shunt): (1) **Indications**: - **Refractory variceal bleeding** despite endoscopic therapy + medical management (vasoconstrictors); - **Recurrent variceal bleeding** despite secondary prophylaxis (beta-blocker + endoscopic band ligation); - **Refractory ascites** despite diuretics + sodium restriction (most common indication now); - **Hepatic hydrothorax** refractory; - **Hepatorenal syndrome** type 1 (selected — bridge to transplant); - **Budd-Chiari syndrome** with portal hypertension; - **Pre-operative for portal-hypertensive patients undergoing abdominal surgery** (selected); - **Hepatopulmonary syndrome** — selected; (2) **Pre-procedural evaluation**: - Cardiac: echo (TIPS increases RV preload — exclude RHF, severe pulmonary HTN > 45 mmHg); - Coags + platelets; - Liver function (Child-Pugh, MELD); - Imaging (CT or MRI) — portal vein patency, biliary anatomy, mass exclusion, anatomy; - Hepatic encephalopathy risk assessment; (3) **Contraindications**: - **Absolute**: heart failure (right-sided), severe pulmonary HTN, severe tricuspid regurgitation, polycystic liver disease, biliary sepsis, severe hepatic encephalopathy refractory; - **Relative**: portal vein thrombosis (selected can be done), severe coagulopathy (correct first), severe hyperbilirubinemia (> 3-5 mg/dL — predictor of mortality); (4) **Procedure (IR)**: - Right internal jugular venous access; - Catheterization of hepatic vein; - Trans-hepatic puncture to portal vein; - Tract dilation; - Stent (covered ePTFE stent — Viatorr, GORE — improved patency vs bare metal); - Portosystemic gradient measurement — goal < 12 mmHg (or 50% reduction); (5) **Complications**: - **Hepatic encephalopathy** ~ 25-35% — major; risk factors — advanced age, low albumin, prior HE, MELD high; treatable + sometimes regresses; - **Stent dysfunction**: stenosis, occlusion; covered stents reduced; surveillance US Doppler; - **Cardiac decompensation** (RHF, pulmonary edema) — pre-procedural workup critical; - **Hemorrhage** (capsular, intraperitoneal); - **Hepatic infarction** rare; (6) **Outcomes**: - Reduces variceal rebleeding > 50% vs endoscopic alone; - Reduces ascites; - **Mortality** depends on liver function — better outcomes in Child-Pugh A/B vs C; - **Early TIPS (within 72 hours)** for selected high-risk variceal bleeders (Child B with active bleed at endoscopy or Child C ≤ 13) — improves survival per García-Pagán NEJM 2010 + ATLAS RCT; (7) **Liver transplant evaluation** — concurrent for advanced liver disease; (8) **Multidisciplinary**: hepatology + IR + transplant surgery + radiology + critical care + GI

---

TIPS: refractory variceal bleed + ascites + selected (HRS, hydrothorax, BCS). Covered stents — better patency. Goal portosystemic gradient < 12 mmHg. HE in 25-35%. Cardiac evaluation pre-procedure. Early TIPS for high-risk variceal bleed. Concurrent liver transplant evaluation. Multidisciplinary.', NULL,
  'hard', 'gi', 'review',
  'radiology', 'clinical_decision', 'gi', 'adult',
  'AASLD + EASL Portal Hypertension', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี cirrhosis + variceal bleeding refractory to endoscopy + Child-Pugh B — TIPS consideration'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 70 ปี advanced HCC + cirrhosis — Y-90 radioembolization (TARE) for selected', '[{"label":"A","text":"Discharge"},{"label":"B","text":"Y-90 transarterial radioembolization (TARE)"},{"label":"C","text":"Single specialty"},{"label":"D","text":"X-ray sufficient"},{"label":"E","text":"No nuclear options"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Y-90 transarterial radioembolization (TARE): (1) **Principle**: Yttrium-90 (β-emitter — high LET, short range ~ 11 mm tissue) microspheres (resin or glass) injected via hepatic artery — selective delivery to tumor via arterial supply (vs portal venous to normal liver); brachytherapy effect; (2) **Pre-procedural evaluation**: - **Imaging**: CT/MRI for anatomy + extrahepatic disease + tumor burden assessment; - **Pre-treatment Tc-99m MAA (macroaggregated albumin) scan**: simulates Y-90 distribution — identifies extrahepatic shunting (especially to lungs > 20% — risk radiation pneumonitis; to GI tract — risk gastritis/ulcer); calculate lung shunt fraction; - **Catheter angiography pre-treatment** — vascular mapping, embolization of accessory vessels (gastroduodenal, right gastric to prevent non-target embolization to stomach/duodenum); - **Dosimetry** — patient-specific calculation; (3) **Indications**: - **HCC**: BCLC stage B (intermediate) — alternative to TACE — comparable efficacy with less post-embolic syndrome; selected stage C with portal vein invasion (TACE contraindicated); - **Hepatic metastases**: colorectal, neuroendocrine (theranostic counterpart to PRRT), other selected; - **Bridge to transplant** or **downstaging** for HCC; (4) **Contraindications**: - Excessive lung shunting (> 30 Gy or 13% — clinical thresholds vary); - Hepatofugal portal flow (would shunt to GI); - Limited liver reserve (Child-Pugh C, decompensated); - Bilirubin > 2-3 mg/dL (relative); (5) **Complications**: - **Radiation pneumonitis** if excessive lung shunt; - **Radiation gastritis / GI ulcer / cholecystitis** — if non-target embolization; - **REILD (radioembolization-induced liver disease)** — fatigue, jaundice, ascites — within 1-3 months; - **Post-embolization syndrome** — less common than TACE (advantage); - **Lymphopenia / infection**; (6) **Outcomes** (LEGACY, DOSISPHERE-01 trials for HCC): - Local control comparable or superior to TACE; - Quality of life better than TACE (less post-procedural pain); - Outpatient procedure usually; (7) **Theranostic concept**: - Pre-treatment MAA scan (diagnostic surrogate) → Y-90 therapy; - Parallel: PRRT — Ga-68 DOTATATE diagnostic + Lu-177 DOTATATE therapy (neuroendocrine); - PSMA — Ga-68 PSMA diagnostic + Lu-177 PSMA therapy (prostate); - I-123/I-131 thyroid; - Theranostics future of nuclear medicine — combined imaging + therapy; (8) **Multidisciplinary**: IR + medical oncology + hepatology + transplant surgery + nuclear medicine + radiation oncology + radiology + radiation safety officer

---

Y-90 TARE: β-emitter microspheres via hepatic artery for HCC + selected mets. Pre-treatment MAA scan + dosimetry + vascular mapping. Avoid lung shunt + GI non-target. REILD complication. Theranostic concept — pre-tx imaging + therapy. Multidisciplinary.', NULL,
  'hard', 'hemato_onco', 'review',
  'radiology', 'clinical_decision', 'hemato_onco', 'adult',
  'SIR + AASLD HCC; SNMMI', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 70 ปี advanced HCC + cirrhosis — Y-90 radioembolization (TARE) for selected'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี + DVT lower extremity + cannot tolerate anticoagulation due to active GI bleeding — IVC filter', '[{"label":"A","text":"No retrieval needed"},{"label":"B","text":"IVC filter — indications + management"},{"label":"C","text":"Always filter for DVT"},{"label":"D","text":"Single specialty"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** IVC filter — indications + management: (1) **Indications (ACR + SIR + ACCP)**: - **Absolute contraindication to anticoagulation** in patient with acute proximal DVT or PE; - **Active major bleeding** while on anticoagulation requiring discontinuation; - **Failure of anticoagulation** (recurrent VTE despite therapeutic anticoagulation); - **Prophylactic in trauma/spine/orthopedic** — controversial; PREP-IC + PRESERVE registries showed mixed benefit; not routine; (2) **NOT indications** (overused historically): - VTE on anticoagulation without complications; - Routine perioperative prophylaxis in most surgeries; - Asymptomatic IVC clot; - Iliofemoral DVT alone without contraindication to anticoagulation; (3) **Filter types**: - **Retrievable** (Optease, OptionElite, Crux, Cook Celect, Denali) — for short-term use; intended for retrieval when anticoagulation can be resumed; - **Permanent** (Greenfield, TrapEase) — for long-term contraindication to anticoagulation; (4) **Imaging + placement**: - **CT venography** or **IVC venography** to evaluate IVC anatomy + thrombus + accessory veins; assess for renal vein position (filter usually placed below renal veins — infrarenal); - **US-guided femoral or jugular access**; - **Fluoroscopic deployment** below renal veins; (5) **FDA Safety Alert (2010, 2014)** — emphasized importance of retrieval — many filters not retrieved due to lost follow-up — complications increase over time; (6) **Complications**: - **Filter fracture / migration / embolization**; - **IVC penetration** (struts through vena cava wall — into aorta, bowel, organs); - **IVC thrombosis** — paradoxically can cause clot below filter; - **Recurrent DVT or PE** (filter doesn''t prevent extension or upper extremity sources); - **Insertion site complications** (hematoma, infection); (7) **Retrieval considerations**: - **Filter retrieval recommended once anticoagulation can be safely resumed + indications resolved**; - **Retrieval window** varies by filter type — earlier easier; - **Complex retrieval techniques** for embedded filters (laser, jaw forceps) — IR expertise; - **PRESERVE registry** — efforts to improve retrieval rates; (8) **Modern approach**: - Reserve filters for true indications; - Plan retrieval at time of placement (date for resumption of anticoagulation + retrieval); - Tracking system + outreach to patients; - Document filter type + serial number + retrieval plan; (9) **Multidisciplinary**: IR + vascular medicine + hematology + ED + critical care + administration (tracking systems)

---

IVC filter: absolute indication = AC contraindication + acute VTE. Retrievable preferred — plan retrieval at placement + follow-up. FDA safety alert — retrieval critical. Complications: fracture, migration, IVC penetration, IVC thrombosis. Modern: tracking systems. Multidisciplinary.', NULL,
  'medium', 'cardiovascular', 'review',
  'radiology', 'clinical_decision', 'cardiovascular', 'adult',
  'SIR + ACCP + FDA Safety Communications', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี + DVT lower extremity + cannot tolerate anticoagulation due to active GI bleeding — IVC filter'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 80 ปี LVO ischemic stroke + within thrombectomy window + ASPECTS 7 + LVO confirmed on CTA', '[{"label":"A","text":"Discharge"},{"label":"B","text":"Acute ischemic stroke — mechanical thrombectomy"},{"label":"C","text":"Wait for symptoms to resolve"},{"label":"D","text":"Single specialty"},{"label":"E","text":"X-ray sufficient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute ischemic stroke — mechanical thrombectomy: (1) **AHA/ASA 2019 Guidelines + extended window data**: - **Within 6 hours**: - LVO (ICA, M1, M2 — selected, basilar) + NIHSS ≥ 6 + ASPECTS ≥ 6 — mechanical thrombectomy CLASS I (HERMES meta-analysis — MR CLEAN + ESCAPE + EXTEND-IA + REVASCAT + SWIFT-PRIME); - **6-24 hours**: - **DAWN criteria** (6-24h) + **DEFUSE-3 criteria** (6-16h) — selected by mismatch (clinical-imaging — DAWN, or core-penumbra — DEFUSE-3) — thrombectomy IMPROVES outcomes — class I; - **CT perfusion + MRI DWI** for selection — automated software (RAPID, Viz.ai) commonly used; (2) **Modern extended indications** (recent trials): - **Large core (ASPECTS < 6)** — RESCUE-Japan LIMIT, SELECT-2, ANGEL-ASPECT — recent trials showed benefit even for large core in selected — paradigm expanding; - **Distal medium vessel occlusions (M2, M3)** — ongoing research; - **Basilar artery occlusion** — BAOCHE + ATTENTION trials — thrombectomy benefit; (3) **Procedure (neuro-IR)**: - **Stent retriever** (Solitaire, Trevo); - **Aspiration thrombectomy** (Penumbra, AXS Vecta); - **Combination** (BAGUETTE technique — combined stent retriever + aspiration); - First-pass effect important — TICI 2b-3 reperfusion goal; (4) **IV tPA / TNK** still given first-line if within 4.5h (or 9h in selected per EXTEND/Tenecteplase) when eligible — pre-thrombectomy bridging shown beneficial (AURORA, MR CLEAN-NO IV, SWIFT-DIRECT — mixed but most support bridging); (5) **Post-thrombectomy management**: - **ICU monitoring**: BP control (140-180 SBP target post-revasc; tight 140 SBP for hemorrhage risk in some trials); - **Repeat imaging at 24h** — hemorrhagic transformation, infarct size; - **Antiplatelet** started 24h post-tPA + thrombectomy; - **DVT prophylaxis** when bleeding risk acceptable; - **Comprehensive stroke care** (above earlier Q); (6) **Workflow excellence**: - **Door-to-groin ≤ 90 min** (target ≤ 60 min); - **Mobile stroke units** in some cities for pre-hospital evaluation; - **Tele-stroke** for triage to thrombectomy-capable centers; - **Direct-to-CT, CT-to-table approaches** reduce time; - **AI-driven LVO detection** for rapid triage (Viz.ai, RapidAI, Avicenna.AI — multiple FDA-cleared); (7) **Multidisciplinary stroke team**: ED + stroke neurology + neuro-IR + neurosurgery + neurocritical care + radiology + pharmacy + nursing + rehab (PT/OT/SLP) + palliative care + social work — improves outcomes (above QI question)

---

LVO stroke + thrombectomy: AHA 2019 — 6h window (CLASS I), 6-24h (DAWN/DEFUSE-3). Large core (ASPECTS < 6) emerging — RESCUE-Japan LIMIT, SELECT-2. Basilar — BAOCHE/ATTENTION. IV tPA bridging usually beneficial. Goal TICI 2b-3, door-to-groin ≤ 90 min. AI LVO detection. Multidisciplinary stroke team.', NULL,
  'medium', 'neurology', 'review',
  'radiology', 'clinical_decision', 'neurology', 'adult',
  'AHA/ASA Stroke 2019 + Updates', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 80 ปี LVO ischemic stroke + within thrombectomy window + ASPECTS 7 + LVO confirmed on CTA'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 30 ปี polytrauma MVC + hemodynamically unstable + suspected pelvic vascular injury — IR options', '[{"label":"A","text":"Discharge"},{"label":"B","text":"Trauma IR — pelvic + visceral angioembolization"},{"label":"C","text":"Single specialty"},{"label":"D","text":"X-ray sufficient"},{"label":"E","text":"Always immediate surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Trauma IR — pelvic + visceral angioembolization: (1) **Trauma imaging algorithm**: - **Hemodynamically UNSTABLE** + positive FAST → OR for damage control surgery; - **Hemodynamically stable or transient responder** → CT chest-abdomen-pelvis (whole-body ''pan-scan'' for severe mechanism, selective for less); - **CT identifies bleeding source + angiographic intervention candidates**; (2) **IR indications in trauma**: - **Pelvic hemorrhage** — bleeding from pelvic vessels in pelvic fracture (mortality high — ''lethal triad'' acidosis + hypothermia + coagulopathy worsens) — pelvic angioembolization life-saving; selective embolization of bleeding arteries (internal iliac branches); often combined with pelvic binder + sometimes preperitoneal packing → angio; - **Solid organ injuries**: - **Spleen Grade III-V** — angiography + selective embolization of pseudoaneurysm or active bleeding — preserves spleen (non-operative management — NOM — for selected stable patients); - **Liver Grade III-V** — selective embolization for active bleeding or pseudoaneurysm; - **Renal injury** — selective embolization for pseudoaneurysm + active bleeding (preserves kidney); - **Vascular injuries**: - Aortic injury — TEVAR (thoracic endovascular aortic repair) — first-line for blunt thoracic aortic injury per SVS; - Extremity vascular — covered stents, embolization; - **Solid organ pseudoaneurysm** — embolization (high rupture risk if untreated); (3) **Techniques**: - **Coil embolization** (definitive vessel occlusion); - **Gelfoam** (temporary); - **Particles** (PVA, microspheres); - **Glue or Onyx** (selected complex); - **Covered stent** for major vessel injuries; (4) **Outcomes**: - **NOM (non-operative management) rates** ↑ significantly with IR (spleen 70-80% in modern series with hospitals having IR available); - **Mortality reduction** in pelvic fracture patients; - **Spleen + kidney preservation** benefits; (5) **Coordination**: - Trauma surgery primary — decision-making + damage control surgery; - IR — angiographic intervention; - Anesthesia + critical care — resuscitation; - Operating room ready as alternative; (6) **Massive transfusion protocol (MTP)** — coordinated; 1:1:1 ratio of RBC:plasma:platelets; tranexamic acid (CRASH-2 — within 3h); (7) **Hybrid operating rooms** — combine OR + interventional suite — increasing for trauma + complex cases; (8) **Multidisciplinary trauma team** (above earlier trauma Q)

---

Trauma IR: pelvic angio for pelvic fracture bleeding (life-saving); solid organ embolization (spleen, liver, kidney) enables NOM; TEVAR for aortic injury; covered stents + coils + gelfoam. Coordinated with trauma surgery + anesthesia. Hybrid ORs emerging. MTP. Multidisciplinary.', NULL,
  'hard', 'trauma', 'review',
  'radiology', 'clinical_decision', 'trauma', 'adult',
  'SIR + AAST + EAST Trauma Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 30 ปี polytrauma MVC + hemodynamically unstable + suspected pelvic vascular injury — IR options'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 70 ปี lung mass — image-guided percutaneous biopsy for tissue diagnosis', '[{"label":"A","text":"Surgery without biopsy"},{"label":"B","text":"Image-guided lung biopsy"},{"label":"C","text":"Discharge"},{"label":"D","text":"Single specialty"},{"label":"E","text":"X-ray sufficient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Image-guided lung biopsy: (1) **Modality**: - **CT-guided percutaneous transthoracic needle biopsy (PTNB)** — most common; - **Fluoroscopy-guided** for larger central lesions; - **EBUS-TBNA (endobronchial US)** — for hilar/mediastinal lymph nodes + central lesions accessible bronchoscopically; better safety profile for central; - **Navigational bronchoscopy / robotic bronchoscopy** — emerging for peripheral nodules — image-guided, lower pneumothorax rate; (2) **Indications**: - Tissue diagnosis for: lung cancer staging, characterization of indeterminate nodule (Fleischner/Lung-RADS suspicious), suspected infection (TB, fungal — for culture + sensitivities), suspected granulomatous disease (sarcoid, vasculitis); - Pre-treatment for staging (mediastinal nodes via EBUS); - Pre-therapy (molecular profiling); (3) **Pre-procedure**: - Review imaging + plan trajectory (avoid emphysematous bullae, vessels, fissures); - Coagulation (INR, platelets, hold anticoagulants per SIR consensus); - Patient education + informed consent (pneumothorax up to 25%, chest tube up to 10%, hemoptysis, air embolism rare); - NPO; (4) **Technique**: - Local anesthesia + sedation if needed; - Coaxial system — outer guide + inner core needle (multiple cores without retraversing pleura); - **Sample types**: FNA (cytology + smear), core biopsy (histology + IHC + molecular — most sites prefer); - On-site cytology (ROSE — rapid on-site evaluation) — confirms adequacy; (5) **Complications**: - **Pneumothorax** (most common — 20-25%); - **Chest tube** (about 5-10% of pneumothoraces); - **Hemoptysis** (uncommon but reported); - **Air embolism** (rare, life-threatening — left decubitus + 100% O2 + ICU); - **Tumor seeding** along needle tract — rare; - **Mortality** very low (< 0.1%); (6) **Post-procedure**: - **Recovery** with monitoring; - **CXR at 1-2 hours** post-procedure (delayed pneumothorax can develop); - Discharge if no/minimal pneumothorax + stable; - Activity restrictions × 1-2 weeks; - **Patient instructions** for return if SOB, chest pain, fever; (7) **Sample handling**: - Specimens to pathology + cytology + microbiology if infection suspected; - **Molecular adequacy** for NSCLC — increasingly important (NGS); communication with oncology + pathology; (8) **Multidisciplinary**: IR + pulmonology + thoracic surgery + radiation oncology + medical oncology + pathology + nursing + anesthesia

---

CT-guided lung biopsy: tissue Dx for nodule characterization + cancer staging + molecular profiling. EBUS for central + hilar/mediastinal nodes. Navigational bronchoscopy for peripheral emerging. Complications — pneumothorax (20-25%), hemoptysis, air embolism rare. Post-procedure CXR. Multidisciplinary.', NULL,
  'easy', 'respiratory', 'review',
  'radiology', 'clinical_decision', 'respiratory', 'adult',
  'SIR + ACR + AABIP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 70 ปี lung mass — image-guided percutaneous biopsy for tissue diagnosis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี chemotherapy candidate — central venous access (port-a-cath) placement', '[{"label":"A","text":"Discharge"},{"label":"B","text":"Central venous access — IR placement"},{"label":"C","text":"Single specialty"},{"label":"D","text":"X-ray sufficient"},{"label":"E","text":"No central access needed"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Central venous access — IR placement: (1) **Indications**: - **Chemotherapy** — intermittent IV access for months/years (port-a-cath preferred for intermittent intermittent access — subcutaneous, lower infection risk vs tunneled); - **Long-term IV antibiotics** (osteomyelitis, endocarditis); - **TPN** (parenteral nutrition); - **Frequent blood draws** + administration (PICC for shorter-term, weeks to months); - **Hemodialysis** (tunneled dialysis catheter — temporary, bridge to AVF); (2) **Devices**: - **PICC (peripherally inserted central catheter)**: bedside or US-guided + fluoroscopy; basilic/brachial vein → SVC; lower infection rate than CVC; weeks to months use; - **Non-tunneled CVC** (internal jugular, subclavian, femoral) — short-term in ICU; - **Tunneled CVC** (Hickman, Broviac, dialysis catheter): subcutaneous tunnel reduces infection — months use; - **Port-a-cath (totally implanted port)**: subcutaneous reservoir + catheter to SVC — fully implanted, low infection rate, comfortable (no external component) — preferred for long-term intermittent chemotherapy access; (3) **Placement (IR — US + fluoroscopy)**: - US-guided venous access (internal jugular preferred — easier compression if bleeding, less pneumothorax than subclavian); - Catheter tip at SVC-RA junction (fluoroscopic confirmation — important for function + reduces thrombosis); - Subcutaneous tunnel for tunneled / port; - Port pocket creation on chest wall; - All under sterile conditions + local anesthesia ± sedation; (4) **Complications**: - **Pneumothorax** (subclavian > IJ — IJ preferred for IR placement); - **Bleeding** / **hematoma** (arterial puncture if not US-guided); - **Catheter malposition** — coiled, in jugular, against vessel wall; - **Infection** (CLABSI — central line-associated bloodstream infection — major hospital quality metric); rate varies by device + technique + maintenance; - **Thrombosis** (catheter-related upper extremity DVT — symptomatic 5-15%); - **Catheter dysfunction** — occlusion, fibrin sheath, malposition; tPA flush, repositioning; - **Air embolism** (rare with proper technique); - **Migration** — long-term, can dislodge; (5) **Maintenance + best practices**: - **CLABSI prevention bundle**: full barrier precautions during insertion, chlorhexidine skin prep, optimal site selection (avoid femoral), daily review of need, prompt removal when not needed, dressing changes, scrub-the-hub before access; - **Heparin flush** (low concentration) controversial — saline alone may be equivalent for many; - **Care of port** — sterile access, education for patient; (6) **Multidisciplinary**: IR + oncology + nursing + infection control + pharmacy + nutrition (TPN) + nephrology (dialysis access) + vascular surgery (AVF for hemodialysis)

---

Central venous access by IR: PICC (weeks-months), tunneled CVC, port (long-term chemo). US + fluoroscopy for IJ access + tip at SVC-RA. Complications — pneumo, malposition, CLABSI, thrombosis. CLABSI prevention bundle. Care + maintenance education. Multidisciplinary.', NULL,
  'easy', 'procedures', 'review',
  'radiology', 'clinical_decision', 'procedures', 'adult',
  'SIR + INS + IDSA CLABSI Prevention', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี chemotherapy candidate — central venous access (port-a-cath) placement'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 75 ปี malignant biliary obstruction + jaundice + failed ERCP — IR percutaneous biliary drainage', '[{"label":"A","text":"Surgery without IR"},{"label":"B","text":"Percutaneous transhepatic biliary drainage (PTBD)"},{"label":"C","text":"Discharge"},{"label":"D","text":"Single specialty"},{"label":"E","text":"X-ray sufficient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Percutaneous transhepatic biliary drainage (PTBD): (1) **Indications**: - **Failed or technically impossible ERCP** for biliary decompression in obstruction (anatomic — Roux-en-Y, prior gastrectomy/Whipple, ampullary tumor inaccessible); - **Cholangitis with biliary obstruction** when ERCP not available or fails; - **Malignant biliary obstruction** — perihilar (Klatskin tumor, gallbladder cancer, hepatocellular, metastases), distal CBD (pancreatic head cancer, ampullary tumor) — palliative or bridging to surgery; - **Benign strictures** — selected (e.g., post-cholecystectomy bile duct injury, PSC); - **Bile leak post-cholecystectomy** — selected; - **Pre-operative drainage for jaundiced patients** undergoing major hepatobiliary surgery — controversial — selective if bilirubin > 250 µmol/L or > 14.5 mg/dL or cholangitis; (2) **Procedure**: - **US-guided** + fluoroscopy; - Right or left hepatic duct access — left often selected for proximal/Klatskin to avoid lung + better drainage; - **Cholangiography** to define anatomy + obstruction; - **External drain** (initial, often as preliminary), **internal-external drain** (across obstruction into duodenum — preferred long-term), **internal stent only** (metal — covered or uncovered SEMS, plastic — selected); - Combined endoscopic + percutaneous approaches for complex cases; (3) **Complications**: - **Bleeding** — hemobilia (from arterial injury during access — most serious); - **Bile leak / peritonitis** — usually self-limited with drainage in place; - **Infection / cholangitis** (especially with contrast injection without prior drainage in obstructed); - **Pneumothorax / hemothorax** if pleura crossed; - **Tube dysfunction** — clogging, dislodgement; - **Liver injury / hematoma**; - **Pancreatitis** (less common than ERCP); (4) **Drain care + management**: - Daily flushing + monitoring of output; - Exchange every 2-3 months for plastic; metal stents permanent (last 6-12 months depending on disease + complications); - Patient education + nursing support; - Tract maturation 1-2 weeks; (5) **Internal vs external**: - **Internal drainage** (across obstruction, distal end in duodenum) — restores enterohepatic circulation, reduces dehydration + malabsorption (vs external — lose bile salts + fluid), more physiologic; - Preferred when feasible; (6) **Self-expanding metal stents (SEMS)**: - Covered (silicone-coated — for malignancy, may be removable) vs uncovered (allow tissue ingrowth — definitive for malignant obstruction); - 10 mm diameter typical; - Longer patency vs plastic; (7) **Outcomes**: - Symptomatic relief of jaundice + pruritus; - Improved quality of life; - Permits chemotherapy in some patients (otherwise hepatically metabolized + bilirubin contraindication); - Mortality of procedure itself low; (8) **Multidisciplinary**: IR + GI + hepatobiliary surgery + medical oncology + radiation oncology + palliative care + nursing + pharmacy

---

PTBD: failed ERCP + malignant biliary obstruction. US + fluoroscopic access. External → internal-external → internal stent (SEMS for malignant). Complications — hemobilia, leak, cholangitis. Internal drainage preferred. Multidisciplinary palliative or bridging care.', NULL,
  'medium', 'gi', 'review',
  'radiology', 'clinical_decision', 'gi', 'adult',
  'SIR + ACG', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 75 ปี malignant biliary obstruction + jaundice + failed ERCP — IR percutaneous biliary drainage'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี locally advanced pancreatic cancer + intractable upper abdominal/back pain — celiac plexus block by IR', '[{"label":"A","text":"Opioids alone forever"},{"label":"B","text":"Celiac plexus neurolysis (CPN) for cancer pain"},{"label":"C","text":"Discharge"},{"label":"D","text":"Single specialty"},{"label":"E","text":"X-ray sufficient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Celiac plexus neurolysis (CPN) for cancer pain: (1) **Indications**: - Intractable upper abdominal + back pain from pancreatic cancer (most common indication — visceral pain mediated by celiac plexus); - Other upper GI malignancies — gastric, hepatobiliary, retroperitoneal; - Chronic pancreatitis pain (less effective, more selected); (2) **Anatomy**: - Celiac plexus — anterior to aorta at T12-L1 level, around celiac trunk + SMA origins; - Innervates visceral structures upper abdomen (pancreas, liver, gallbladder, stomach, small bowel proximal); - Sympathetic + visceral afferent fibers — pain pathway; (3) **Approach techniques**: - **Percutaneous fluoroscopy or CT-guided** — anterior trans-abdominal or posterior retrocrural; - **EUS-guided celiac plexus neurolysis** — transgastric — increasingly preferred (one-stop diagnostic + therapeutic for pancreatic cancer); - **Surgical celiac plexus neurolysis** during open laparotomy for pancreatic cancer staging if unresectable found; (4) **Agent**: - **Diagnostic block** — local anesthetic (lidocaine + bupivacaine) ± steroid — confirms pain pathway + temporary relief (1-2 days); - **Neurolytic block** — 50-100% absolute alcohol or 6-10% phenol — destroys nerves — relief 2-6+ months; (5) **Efficacy**: - **70-90% effective** for moderate to severe pancreatic cancer pain; - **Reduces opioid use** + opioid-related side effects; - **Improves quality of life**; - **Doesn''t prolong survival** (was studied — no survival benefit); - **Early intervention** considered for newly diagnosed inoperable pancreatic cancer — improves overall pain trajectory; (6) **Complications**: - **Hypotension** (sympathectomy effect — pre-procedure IV hydration + monitoring); - **Diarrhea** (parasympathetic predominance after sympathectomy); - **Local pain** post-procedure; - **Paraplegia** rare but serious (artery of Adamkiewicz injury — anterior spinal artery); minimize with proper technique + CT guidance; - **Pneumothorax** (posterior approach); - **Bleeding** retroperitoneal hematoma; (7) **Other IR pain procedures for cancer**: - **Splanchnic nerve block / RFA** — alternative; - **Intrathecal pump** (programmable drug delivery — morphine, ziconotide); - **Vertebroplasty / kyphoplasty** for vertebral compression fracture pain; - **Bone ablation (cementoplasty, RFA)** for painful bone metastases; - **Cordotomy** historical/rare; (8) **Multidisciplinary palliative pain management**: pain medicine + IR + medical oncology + palliative care + radiation oncology + psychology + nursing + family + spiritual care

---

Celiac plexus neurolysis: intractable upper abdominal/back pain from pancreatic cancer. CT or EUS-guided. Local anesthetic diagnostic, alcohol/phenol neurolytic. 70-90% effective. Early intervention. Complications — hypotension, diarrhea, paraplegia rare. Multimodal palliative pain. Multidisciplinary.', NULL,
  'medium', 'hemato_onco', 'review',
  'radiology', 'clinical_decision', 'hemato_onco', 'adult',
  'ASA + SIR + ASCO Palliative Care', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี locally advanced pancreatic cancer + intractable upper abdominal/back pain — celiac plexus block by IR'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี vertebral compression fracture from osteoporosis + severe pain × 6 สัปดาห์ failed conservative therapy', '[{"label":"A","text":"Discharge"},{"label":"B","text":"Vertebroplasty + kyphoplasty"},{"label":"C","text":"Single specialty"},{"label":"D","text":"X-ray sufficient"},{"label":"E","text":"Always surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Vertebroplasty + kyphoplasty: (1) **Indications**: - **Symptomatic osteoporotic vertebral compression fracture (VCF)** with severe pain refractory to conservative therapy (4-6 weeks); - **Painful VCF in malignancy** — multiple myeloma, metastases (with imaging guidance, often combined with cement); - **Selected acute symptomatic VCFs** to expedite return to function; - **Hemangioma — aggressive symptomatic** (less common); (2) **Vertebroplasty (VP) vs kyphoplasty (KP)**: - **Vertebroplasty**: percutaneous transpedicular injection of PMMA cement into vertebral body — cheaper, faster; cement extravasation risk; - **Kyphoplasty**: balloon inflation creates cavity + height restoration → cement injection — better height restoration, lower extravasation, more expensive; (3) **Evidence**: - **Initial RCTs (2009 NEJM — VERTOS, NEJM — INVEST)** — vertebroplasty NOT superior to sham — controversial; - **VAPOUR (2016)** — subacute VCF in pain — VP better than placebo; - **VERTOS IV (2018)** — VP better than placebo for VCF; - **Recent meta-analyses + Cochrane** — heterogeneous data, debate continues; - **Real-world practice** — many practitioners still offer for refractory pain after shared decision-making; (4) **Pre-procedure**: - Imaging — X-ray, MRI to confirm acute/subacute fracture (STIR/T2 marrow edema present in healing fractures — VP effective; chronic completely healed less effective); - Bone scan + selective; - Coags + INR; - Anticoagulant management; (5) **Procedure (IR or spine surgery)**: - Prone position; - Fluoroscopic + CT-guided percutaneous transpedicular access; - Cement injection slowly under continuous fluoroscopy; - Monitor for extravasation (venous — risk PE; epidural — risk cord/nerve compromise; disc); (6) **Complications**: - **Cement extravasation** (most common — usually asymptomatic; rare cord compression, pulmonary embolism); - **New adjacent vertebral fractures** — biomechanical changes increase load on adjacent vertebrae; - **Infection** rare; - **Bleeding**; (7) **Osteoporosis management — must address underlying disease**: - Bisphosphonates (alendronate, risedronate, zoledronic acid IV annually); - Denosumab (monoclonal — 6-monthly); - Anabolic agents — teriparatide, abaloparatide (PTH analogs), romosozumab (anti-sclerostin); - Calcium + vitamin D + weight-bearing exercise; - Falls prevention; - DXA monitoring; (8) **Pain management adjuncts**: NSAIDs, acetaminophen, neuropathic agents (gabapentin, duloxetine); avoid prolonged opioids; physical therapy; orthotic braces controversial; (9) **Multidisciplinary**: spine surgery / IR + pain medicine + endocrinology + PT + nutrition + falls prevention + primary care

---

VCF: vertebroplasty / kyphoplasty for refractory pain. MRI for acute/subacute (marrow edema). Cement injection under fluoro. Evidence mixed (some RCTs vs sham, recent positive). Complications — extravasation + adjacent fx. MUST address osteoporosis — bisphosphonates, denosumab, anabolic. Multidisciplinary.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'radiology', 'clinical_decision', 'msk_nontrauma', 'adult',
  'SIR + AAOS + ASBMR Osteoporosis', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี vertebral compression fracture from osteoporosis + severe pain × 6 สัปดาห์ failed conservative therapy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี + HCC 2.5 cm in liver — ablation candidate', '[{"label":"A","text":"Surgery only option"},{"label":"B","text":"Tumor ablation — percutaneous"},{"label":"C","text":"Discharge"},{"label":"D","text":"Single specialty"},{"label":"E","text":"X-ray sufficient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Tumor ablation — percutaneous: (1) **Modalities**: - **Radiofrequency ablation (RFA)** — heat-based (50-100°C tissue); historically most common; effective for 3-5 cm; limited by heat sink (adjacent blood vessels dissipate heat); - **Microwave ablation (MWA)** — newer heat-based, faster heating + less heat sink; preferred for larger lesions (3-5+ cm); - **Cryoablation** — extreme cold cycles (freeze-thaw); allows ice ball visualization on CT/US; useful where heat injury to adjacent structures problematic (e.g., bile ducts in liver, ureter in kidney, central airway); less painful in some applications; - **Irreversible electroporation (IRE — NanoKnife)** — non-thermal, electrical pulses disrupt cell membranes; preserves bile ducts + vessels + nerves; for tumors near critical structures (e.g., locally advanced pancreatic cancer near major vessels); - **Laser ablation**, **HIFU (high-intensity focused ultrasound)** — selected; (2) **Indications**: - **HCC** — early stage (BCLC 0-A) — ≤ 3 lesions ≤ 3 cm (Milan criteria-like); cure-intent in selected; bridge to transplant; - **Liver metastases** — colorectal (CRLM oligometastatic — typically ≤ 3 lesions ≤ 3 cm), neuroendocrine; - **Renal cell carcinoma** — T1a (≤ 4 cm) exophytic; alternative to partial nephrectomy in comorbid; - **Lung tumors** — primary stage I NSCLC inoperable, oligometastatic; - **Bone metastases** — painful lesions (palliative); - **Soft tissue tumors** — selected; - **Adrenal — selected** (e.g., functional pheochromocytoma); (3) **Pre-procedure**: - **Imaging** — CT/MRI for tumor + surrounding anatomy + relation to critical structures; - **Multidisciplinary tumor board** — confirm appropriate; - **Patient assessment** — comorbidities, anticoagulants, anesthesia plan; - **Informed consent**; (4) **Procedure**: - **CT, US, or MRI guidance**; - **Multiple needle placements** for larger tumors; - **Sedation or general anesthesia**; - **Pleural displacement** for adjacent tumors (hydrodissection); - **Cooling adjacent structures** when needed; (5) **Complications**: - **Local**: pain, bleeding, infection, abscess, organ injury; - **Specific to liver**: bile duct injury, hepatic infarction, pleural complications (pneumothorax, effusion); - **Specific to lung**: pneumothorax (high — 30-40%), pulmonary hemorrhage, air embolism; - **Specific to kidney**: collecting system injury, hemorrhage; - **Tumor seeding** along needle tract — rare; - **Post-ablation syndrome** — flu-like × 1-2 weeks (heat ablation); (6) **Follow-up imaging**: - **Multiphase CT or MRI at 1 month** — confirm complete ablation (no residual enhancement in ablation zone); - **Surveillance** q3-6 months × 2 years, then less frequent; - **Recurrence treatment** — re-ablation or alternative; (7) **Outcomes**: - **HCC < 3 cm — local control > 90%, 5-yr OS > 70%** comparable to surgical resection; - **CRLM** — 5-yr OS ~ 30-40% in selected; - **RCC T1a — local control > 95%**; (8) **Multidisciplinary**: IR + medical oncology + surgical oncology + radiation oncology + hepatology + urology + pulmonology + radiology + pathology + nursing

---

Tumor ablation: RFA, MWA (less heat sink), cryo (ice ball visible), IRE (preserves critical structures). HCC ≤ 3 cm (cure-intent), CRLM ≤ 3 lesions, RCC T1a, lung stage I inoperable, painful bone mets. CT/US/MRI guidance. Complications by site. 1-month imaging + surveillance. Multidisciplinary tumor board.', NULL,
  'medium', 'hemato_onco', 'review',
  'radiology', 'clinical_decision', 'hemato_onco', 'adult',
  'SIR + AASLD + NCCN', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี + HCC 2.5 cm in liver — ablation candidate'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 45 ปี hydronephrosis + obstruction + pyonephrosis + sepsis — emergent nephrostomy', '[{"label":"A","text":"Discharge"},{"label":"B","text":"Percutaneous nephrostomy (PCN)"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Wait for elective workup"},{"label":"E","text":"X-ray sufficient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Percutaneous nephrostomy (PCN): (1) **Indications**: - **Obstructive uropathy with sepsis (pyonephrosis)** — emergency decompression to source-control infection (along with IV antibiotics + resuscitation) — outcomes superior to ureteral stent for selected (faster decompression of infected system); - **Obstructive uropathy with AKI** (post-renal AKI) — decompression preserves function; - **Failed retrograde ureteral stent** — anatomic or technical impossibility; - **Urinary diversion** — for ureteral injury, fistula, leak, malignant infiltration; - **Pre-procedural access** for percutaneous nephrolithotomy (PCNL) for large stones; - **Antegrade ureteral stent placement** (when retrograde fails); - **Chemotherapy delivery** — selected (intravesical, ureteral); (2) **Pre-procedure**: - **Imaging** — CT/US for hydronephrosis + level of obstruction + collecting system anatomy + perinephric collections; - **Coags + INR**; - **Hydration** if dehydrated; - **Antibiotics** if infection suspected — broad-spectrum (ciprofloxacin + gentamicin or piperacillin-tazobactam) prior to procedure; - **Sepsis resuscitation** before procedure; (3) **Procedure (IR)**: - **US + fluoroscopy guidance**; - Prone or oblique position; - Lower-pole posterior calyx access (less vascular injury); - 21G access needle → wire → dilation → drain placement (8.5 or 10 Fr typically); - **Antegrade pyelogram** to confirm + define anatomy + assess obstruction level; (4) **Complications**: - **Hemorrhage** — perinephric, pseudoaneurysm, AVF — major bleeding rare with proper technique; may require embolization; - **Pneumothorax / hemothorax** — superior pole access risk; - **Bowel injury** — colon (left more posterior, supine vs prone differences); - **Sepsis** — during pyonephrosis decompression (gram-negative bacteremia possible — antibiotics + hemodynamic support); - **Tube dysfunction** — clogging, dislodgement, kink; - **Urinary leak**; (5) **Drain care**: - Daily output monitoring; - Flushing PRN; - Exchange every 2-3 months; - Patient education; (6) **Ureteral stent vs nephrostomy in obstruction**: - **Ureteral stent (retrograde via cystoscopy)** — internal, no external drainage, normal bladder voiding; - **Nephrostomy** — external, can be larger drainage, urgent (no anesthesia for stent placement timing); preserves ureter for later definitive treatment; - **Combined**: nephroureteral stent (drains through ureter + has external safety) — selected complex cases; (7) **Definitive treatment** depends on underlying obstruction cause: - **Stone** — ureteroscopy / lithotripsy / PCNL after stabilization; - **Ureteral stricture** — stent ± dilation, urinary diversion or surgical repair; - **Malignant infiltration** (cervical, prostate, bladder, lymphoma) — palliative diversion vs treatment of primary; - **Retroperitoneal fibrosis** — medical (steroids) + diversion; (8) **Multidisciplinary**: IR + urology + ED + nephrology + ID + critical care

---

Percutaneous nephrostomy: emergent for pyonephrosis (sepsis source control), obstructive uropathy AKI, failed retrograde stent, urinary diversion. US + fluoro lower-pole access. Antibiotics + resuscitation pre-procedure. Complications — bleeding, sepsis decompression. Definitive treatment for underlying. Multidisciplinary.', NULL,
  'easy', 'renal_gu', 'review',
  'radiology', 'clinical_decision', 'renal_gu', 'adult',
  'SIR + AUA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 45 ปี hydronephrosis + obstruction + pyonephrosis + sepsis — emergent nephrostomy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี + uterine fibroids + heavy menstrual bleeding — IR uterine artery embolization (UAE)', '[{"label":"A","text":"Discharge"},{"label":"B","text":"Uterine artery embolization (UAE) — fibroids"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Only hysterectomy option"},{"label":"E","text":"X-ray sufficient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Uterine artery embolization (UAE) — fibroids: (1) **Indications**: - **Symptomatic uterine fibroids** (heavy menstrual bleeding, bulk symptoms — pelvic pressure, urinary frequency) in patients who: prefer uterus-sparing alternative to hysterectomy/myomectomy, want to avoid surgery, completed childbearing (fertility preservation controversial — declining ovarian function risk), have surgical contraindications; - **Postpartum hemorrhage** — emergent UAE for refractory bleeding; - **Adenomyosis** — selected; - **Pelvic congestion syndrome** — gonadal vein embolization (similar concept); (2) **Pre-procedure**: - **MRI pelvis** — characterizes fibroids (size, location, number, signal — degeneration), excludes alternatives (adenomyosis, leiomyosarcoma — rare but contraindication); - **GYN evaluation** — endometrial assessment if abnormal bleeding (rule out cancer); - **Pelvic exam + recent Pap**; - **Fertility goals** + family planning (childbearing implications discussion); - **Coags + INR**; (3) **Procedure (IR)**: - **Femoral artery access** (US-guided); - **Bilateral uterine artery catheterization** + selective embolization with particles (PVA particles 500-700 µm typical, microspheres); - **Endpoint** — sluggish flow in uterine arteries + stasis of contrast in distal vasculature; (4) **Post-procedure**: - **Post-embolization syndrome** (common 1-7 days): pelvic pain (NSAIDs + opioids needed), low-grade fever, nausea — supportive management; - Most patients home next day or same day; - Recovery typically 1-2 weeks; - Improvement in symptoms over weeks to months as fibroids shrink + necrose; (5) **Outcomes**: - **Symptom improvement** in 80-90%; - **Long-term**: 20% may need additional intervention (myomectomy, hysterectomy) over years; - **Fibroid size reduction** ~ 50%; - Compared to myomectomy/hysterectomy — UAE shorter recovery, less morbidity, but slightly higher re-intervention rate (EMMY, REST, FUME trials); (6) **Complications**: - **Premature ovarian failure** (~ 1-3% — collateral embolization to ovarian arteries via arcades — concerns esp. for younger patients wanting fertility); - **Fibroid expulsion** — submucosal fibroid sloughed into uterine cavity → can be retained, painful, septic; - **Infection** — endometritis, abscess; - **Post-embolization syndrome** (above); - **Non-target embolization** — bladder, bowel, gluteal claudication, sexual dysfunction; - **Pregnancy** post-UAE — generally feasible but higher obstetric risks (placental abnormalities); (7) **Alternative treatments**: - **Medical**: GnRH agonists (lupron — temporary), oral contraceptives, hormonal IUD (Mirena — for bleeding only), tranexamic acid; - **Surgical**: hysterectomy (definitive), myomectomy (fertility-sparing — laparoscopic, robotic, open, hysteroscopic for submucosal); - **MR-guided focused ultrasound (MRgFUS) ablation** — non-invasive thermal ablation; selected; - **Endometrial ablation** — for bleeding alone with normal cavity; (8) **Multidisciplinary**: gynecology + IR + radiology + nursing + patient education

---

UAE for symptomatic fibroids: bilateral uterine artery catheterization + particle embolization. MRI pre-procedure. Post-embolization syndrome 1-7 days. 80-90% symptom improvement, 20% re-intervention long-term. Complications — POF, fibroid expulsion, infection. Fertility considerations. Multidisciplinary GYN + IR.', NULL,
  'medium', 'obgyn', 'review',
  'radiology', 'clinical_decision', 'obgyn', 'adult',
  'SIR + ACOG', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี + uterine fibroids + heavy menstrual bleeding — IR uterine artery embolization (UAE)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 40 ปี + acute massive hemoptysis 600 mL/24h — bronchial artery embolization', '[{"label":"A","text":"Discharge"},{"label":"B","text":"Massive hemoptysis — bronchial artery embolization (BAE)"},{"label":"C","text":"Conservative observation"},{"label":"D","text":"Single specialty"},{"label":"E","text":"X-ray sufficient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Massive hemoptysis — bronchial artery embolization (BAE): (1) **Definition + significance**: - **Massive hemoptysis** — variably defined: > 100-600 mL/24h (no universal definition — clinically significant + risk of asphyxiation, hemodynamic compromise); - **Mortality** without intervention up to 50-80%; (2) **Etiologies**: - **Bronchiectasis** (cystic fibrosis, post-TB) — most common cause overall; - **Active TB**, mycetoma in old TB cavity; - **Lung cancer** — primary, metastatic; - **Pulmonary embolism / infarct**; - **Aspergilloma** (mycetoma) in cavity; - **Vasculitis** (GPA, Goodpasture); - **Mitral stenosis** (left heart pressure → pulmonary vein engorgement → bronchial vein anastomoses); - **AVM** (HHT — hereditary hemorrhagic telangiectasia); - **Trauma**; (3) **Initial management — ABCs**: - **Airway protection** — paramount in massive hemoptysis (drowning in own blood is mechanism of death); - **Position** bleeding lung down (lateral decubitus) to protect non-bleeding side from aspiration — if side known; - **Intubation** — selectively, large-bore tube (8.0+) for suctioning; - **Bronchoscopy** — rigid for emergent — diagnostic + therapeutic (topical hemostasis with cold saline, epinephrine, tranexamic acid; balloon tamponade; argon plasma coagulation; double-lumen tube to isolate bleeding lung; selective intubation); - **Resuscitation** — transfusion, correction of coagulopathy, reverse anticoagulants; (4) **Imaging localization**: - **CXR** — initial; - **CT chest with IV contrast (CTA)** — gold standard for localization + etiology + planning embolization; identifies bleeding source + abnormal arteries (hypertrophied bronchial arteries usually); (5) **Bronchial artery embolization (BAE) by IR**: - **Treatment of choice for massive hemoptysis** when not from peripheral pulmonary artery (which would require PA embolization); - Selective catheterization of bronchial arteries; - **Bronchial arteries** typically arise from descending thoracic aorta (T5-T6 typically); anatomic variants common — important to identify; - **Spinal cord protection** — anterior spinal artery (artery of Adamkiewicz) may arise from bronchial or intercostal arteries — careful angiography before embolization to avoid catastrophic paraplegia; - **Embolic agent**: PVA particles 300-700 µm (avoid small particles that could shunt to systemic); - Endpoint — cessation of flow in target vessels; (6) **Outcomes**: - **Immediate cessation of bleeding** > 90%; - **Long-term** — recurrence ~ 10-50% (depending on underlying disease — bronchiectasis, TB high recurrence); repeat BAE often feasible; - **Treat underlying disease** (antibiotics for TB, immunosuppression for vasculitis, surgical resection for selected, lung transplant for end-stage); (7) **Complications**: - **Spinal cord ischemia / infarct** (paraplegia) — devastating; risk minimized with careful technique; - **Non-target embolization** — bronchoesophageal, intercostal, GI vessels; - **Chest pain**, dysphagia (transient); (8) **Multidisciplinary**: pulmonology + IR + thoracic surgery + ED + ICU + ID (if TB/infection) + radiation safety if cancer + anesthesia

---

Massive hemoptysis: airway protection + bronchoscopy + CTA for localization. BAE — embolize bronchial arteries; spinal cord protection (Adamkiewicz). 90% immediate cessation, 10-50% recurrence — repeat feasible. Treat underlying disease. Multidisciplinary.', NULL,
  'hard', 'respiratory', 'review',
  'radiology', 'clinical_decision', 'respiratory', 'adult',
  'SIR + ATS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 40 ปี + acute massive hemoptysis 600 mL/24h — bronchial artery embolization'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Nuclear medicine radioisotopes — properties + half-lives + applications', '[{"label":"A","text":"Single isotope used"},{"label":"B","text":"Nuclear medicine isotopes"},{"label":"C","text":"No nuclear medicine"},{"label":"D","text":"Discharge"},{"label":"E","text":"X-ray equivalent"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Nuclear medicine isotopes: (1) **Common diagnostic radioisotopes**: - **Tc-99m (technetium-99m)** — workhorse: half-life 6 hours, gamma emitter 140 keV (ideal for gamma camera); generator-produced (Mo-99 → Tc-99m); used in bone scan (MDP), HIDA, MAG3 renal, sestamibi cardiac/parathyroid, ventilation (DTPA, Technegas), V/Q lung, brain (HMPAO), WBC labeling; - **I-123** — half-life 13 hours, gamma 159 keV; thyroid uptake/scan, MIBG (neuroendocrine, pheochromocytoma); cyclotron-produced; - **I-131** — half-life 8 days, gamma + beta — diagnostic (low dose) + therapeutic (high dose) — thyroid hyperthyroidism + cancer ablation, MIBG therapy (pheo); - **In-111** — half-life 67 hours, gamma; OctreoScan (somatostatin receptor — pre-cursor to DOTATATE PET), WBC labeling; - **Ga-67** — half-life 78 hours, gamma; older infection + lymphoma imaging (largely replaced by FDG-PET); - **F-18 (fluorine-18)** — PET: half-life 110 minutes, positron emitter; FDG (glucose analog — most common), F-DOPA, F-PSMA, F-fluciclovine, F-NaF (bone), F-MFBG (neuroendocrine new); cyclotron-produced; - **Ga-68 (gallium-68)** — PET: half-life 68 minutes, positron emitter; generator-produced (Ge-68 → Ga-68); DOTATATE/DOTATOC (somatostatin neuroendocrine), PSMA (prostate), FAPI (fibroblast activation protein — emerging cancer imaging); - **C-11** — PET: half-life 20 minutes — only feasible at PET sites with cyclotron; choline (prostate), methionine; - **Cu-64** — PET: half-life 12 hours; DOTATATE, antibodies; - **Zr-89** — PET: half-life 78 hours; antibody imaging (immunoPET — bispecific T cell engager + checkpoint inhibitor); - **N-13, O-15** — short half-life — research; (2) **Therapeutic radioisotopes**: - **I-131** — thyroid; - **Y-90** — radioembolization HCC + mets, radioimmunotherapy lymphoma (Zevalin historical); beta emitter, no gamma — therapeutic dosimetry via MAA surrogate; - **Lu-177** — beta emitter — PRRT (DOTATATE for neuroendocrine), PSMA RLT (prostate) — gamma also present allows post-therapy imaging; - **Ra-223** — alpha emitter — prostate bone mets (Xofigo); - **Sm-153 / Sr-89** — older bone palliation; - **Ho-166 microspheres** — alternative to Y-90 (also imaging); - **At-211** — alpha emitter — emerging; - **Pb-212, Ac-225** — alpha therapy emerging; (3) **Theranostic pairs**: - Ga-68 DOTATATE diagnostic + Lu-177 DOTATATE therapy (neuroendocrine — PRRT); - Ga-68 PSMA + Lu-177 PSMA (prostate); - I-123/I-124 + I-131 (thyroid); - F-18/Ga-68 + alpha emitters (emerging); (4) **Generator concept**: Mo-99 → Tc-99m daily elution; Ge-68 → Ga-68 daily; Sr-82 → Rb-82 for cardiac PET (Sr-82/Rb-82 generator); (5) **Radiation safety** in radiopharmaceuticals: - ALARA — time, distance, shielding; - Spill kits + procedures; - Patient release criteria (especially for I-131 + Lu-177 — radiation safety to family + public — variable by jurisdiction); - Pregnancy + breastfeeding considerations — counseling, delay/cessation of breastfeeding for many tracers; - Radiation safety officer (RSO) oversight; (6) **NRC + state regulations** + facility licensure; (7) **Multidisciplinary**: nuclear medicine physicians + radiopharmacists + medical physics + technologists + radiation safety officer + nursing + clinical specialists

---

Nuclear isotopes: Tc-99m workhorse (6h, gamma camera). I-123/I-131 thyroid. F-18 PET (110 min — FDG, NaF, PSMA, DOPA). Ga-68 PET (68 min generator — DOTATATE, PSMA). Therapeutic — I-131, Y-90, Lu-177 (PRRT + PSMA RLT), Ra-223. Theranostic pairs concept. Radiation safety + RSO. Multidisciplinary.', NULL,
  'medium', 'procedures', 'review',
  'radiology', 'basic_science', 'procedures', 'adult',
  'SNMMI; EANM', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Nuclear medicine radioisotopes — properties + half-lives + applications'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Angiography fundamentals — Seldinger technique + access + complications', '[{"label":"A","text":"No technique standard"},{"label":"B","text":"Angiography basics + Seldinger technique"},{"label":"C","text":"Discharge"},{"label":"D","text":"Single approach"},{"label":"E","text":"X-ray sufficient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Angiography basics + Seldinger technique: (1) **Seldinger technique** (1953 — Sven Ivar Seldinger): - **Step 1**: Needle puncture of vessel; - **Step 2**: Wire passage through needle; - **Step 3**: Remove needle, leave wire; - **Step 4**: Dilator passage over wire; - **Step 5**: Catheter passage over wire; - **Step 6**: Remove wire; - Foundation of all percutaneous catheterization (IR, cardiology, vascular surgery); (2) **Modifications**: - **Modified Seldinger** with sheath placement (more common now) — sheath provides stable access for catheter exchanges; (3) **Access sites**: - **Femoral artery** (common femoral) — traditional, fluoroscopic-guided, US-guided modern; complications: hematoma, pseudoaneurysm, AVF, dissection, retroperitoneal hemorrhage; closure devices (Angio-Seal, Perclose) speed hemostasis; - **Radial artery** — increasing for cardiac + neuro-IR; lower bleeding, earlier ambulation, patient comfort; smaller vessel — limits some procedures; modified Allen test, US-guided; spasm common; risk hand ischemia (rare with patent ulnar); - **Brachial artery** — older alternative; - **Pedal access** for selected peripheral vascular; - **Venous access** — femoral, IJ (US-guided), brachial; (4) **Anticoagulation**: - **Heparin** during procedure (50-100 U/kg typical); activated clotting time (ACT) monitoring; - Reverse with protamine selected; - Bivalirudin alternative; - **Antiplatelet** post-procedure for selected stenting (aspirin + P2Y12); (5) **Catheters + wires**: - Multiple types (5 Fr standard initial diagnostic, smaller for some, larger for therapeutic); - Hydrophilic vs non-hydrophilic; - Wires — 0.035 inch workhorse, 0.014 inch for distal embolization; - Shapes — angled, straight, Cobra, JR, JL, etc., for selective catheterization; (6) **Common procedures** (above questions cover major IR): - Diagnostic angiography; - Therapeutic interventions (PTA, stent, embolization, thrombolysis, atherectomy); - Biopsy + drainage; - Venous + arterial access; (7) **Closure**: - **Manual compression** historical (20-30 minutes femoral artery); - **Closure devices**: Angio-Seal, Perclose ProGlide, MynxGrip — faster ambulation, similar safety; - **Compression bands** (radial — TR Band); (8) **Complications** general: - **Access**: hematoma, pseudoaneurysm, AVF, dissection, retroperitoneal bleed; - **Catheter-related**: vessel dissection, perforation, thrombosis, embolization, distal ischemia (limb, bowel); - **Contrast**: allergic reaction, nephropathy; - **Radiation**: skin injury (high-dose interventional — rare modern); - **Stroke / MI** in cardiovascular procedures; (9) **Imaging during procedure**: - **DSA (digital subtraction angiography)** — gold standard for vascular imaging; - **Roadmapping** — overlay of stationary contrast map; - **Cone-beam CT** — 3D imaging during procedure; - **3D rotational angiography** for complex anatomy; - **US guidance** for access (reduces complications — recommended for many access sites); (10) **Radiation safety** — operators + staff + patients: - **Lead aprons**, thyroid shields, lead glasses, lead glove (selected); - **Dosimetry badges** — monitor exposure; - **ALARA techniques** — minimize fluoroscopy time + pulse rate + magnification + table-detector distance + collimation; (11) **Multidisciplinary**: IR + vascular surgery + cardiology + nursing + technologists + medical physics + radiation safety officer + sterile processing + administration

---

Seldinger: needle → wire → dilator → catheter. Modified with sheath. Access — femoral, radial (increasing), brachial, IJ. Heparin during procedure. Closure manual vs devices. Complications — access + catheter-related + contrast + radiation. DSA + roadmapping + cone-beam CT. Radiation safety. Multidisciplinary.', NULL,
  'easy', 'procedures', 'review',
  'radiology', 'basic_science', 'procedures', 'adult',
  'SIR + SCAI', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Angiography fundamentals — Seldinger technique + access + complications'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'CT trauma protocols — pan-scan vs selective imaging', '[{"label":"A","text":"X-ray sufficient"},{"label":"B","text":"CT trauma protocols"},{"label":"C","text":"Discharge no imaging"},{"label":"D","text":"Single approach"},{"label":"E","text":"Always pan-scan"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** CT trauma protocols: (1) **Whole-body CT (WBCT) ''pan-scan''**: - **Indications**: severe blunt mechanism (high-energy MVC, fall from height, pedestrian struck, motorcycle ejection), polytrauma with multiple injuries, altered mental status preventing reliable exam, hemodynamically transient responder; - **Protocol**: non-contrast head CT + contrast-enhanced cervical spine + chest-abdomen-pelvis (typically single-phase IV contrast, sometimes biphasic for vascular evaluation); - **Benefits**: comprehensive, rapid; identifies unsuspected injuries (~ 10-30% of trauma patients have unexpected injuries on pan-scan); reduces ''missed injury'' (delayed diagnosis); - **Disadvantages**: radiation, contrast, cost, incidental findings; (2) **Selective imaging**: - **Mechanism + clinical exam-guided**; - **NEXUS + Canadian C-spine + Ottawa rules** for selected body regions; - Less radiation + contrast; - Risk missing injuries in altered/distracted patients; (3) **Evidence**: - **REACT-2 trial** (Lancet 2016) — WBCT vs selective in severe trauma — no mortality difference but more findings + uncertainty about clinical benefit of additional findings; - **Pan-scan reduces missed injuries** + may improve mortality in some studies; mixed evidence; - **Risk-stratified approach** — most trauma centers use combination based on mechanism + exam; (4) **Imaging considerations for trauma**: - **Hemodynamically unstable** → OR (not CT — FAST + bedside US, then OR); - **Hemodynamically stable / responder** → CT comprehensive; - **Pediatric** → lower radiation protocols, US/MRI alternatives when possible; selective; - **Pregnant** → US first, selective CT when needed (Maternal-first principle in major trauma); - **Tertiary survey** at 24+ hours — clinical re-evaluation + repeat imaging selected; (5) **Specific trauma CT protocols**: - **Head CT non-contrast** — TBI assessment (PECARN for peds, Canadian CT Head Rule for adults — minor head injury); - **Cervical spine CT** — preferred over X-ray; - **CT chest IV contrast** — aortic injury, pneumothorax, hemothorax, pulmonary contusion, mediastinal hematoma; aortic injury — CTA chest gold standard; - **CT abdomen-pelvis IV contrast** — solid organ injuries, bowel injury, vascular extravasation, pelvic fracture detail; - **CTA neck** — blunt cerebrovascular injury screening (Memphis or Denver criteria + selected); - **Extremity CTA** — vascular injury suspected; - **Pelvic fracture protocol** — bony reconstruction + vascular evaluation; (6) **Contrast considerations**: - **IV contrast** usually given despite limited renal info in trauma — usually clinically necessary; - **Oral contrast** typically NOT given in trauma (slows + risks aspiration); - **Rectal contrast** historical for selective bowel evaluation, less now; (7) **Radiation dose**: - Trauma pan-scan ~ 20-30+ mSv — significant; - ALARA + iterative reconstruction + appropriate kVp + scan range minimization; (8) **Reading + reporting**: - **Structured reporting templates**; - **Critical findings communication**; - **Tertiary survey** with re-reading + clinical correlation for missed injuries; - **Multidisciplinary** with trauma surgery + ED + critical care + radiology

---

CT trauma: pan-scan for severe blunt mechanism + polytrauma + altered exam — comprehensive but radiation + contrast. Selective by mechanism + exam — Ottawa/NEXUS/CCR. Hemodynamically unstable → OR not CT. Specific protocols per body part. Structured reporting + critical findings + tertiary survey. Multidisciplinary.', NULL,
  'medium', 'trauma', 'review',
  'radiology', 'basic_science', 'trauma', 'adult',
  'ACR Appropriateness Trauma; REACT-2', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'CT trauma protocols — pan-scan vs selective imaging'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Theranostics — concept + applications in nuclear medicine + oncology', '[{"label":"A","text":"No theranostics"},{"label":"B","text":"Theranostics — therapy + diagnostic combined"},{"label":"C","text":"Discharge"},{"label":"D","text":"Single specialty"},{"label":"E","text":"Diagnostic only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Theranostics — therapy + diagnostic combined: (1) **Concept**: - ''Theranostic pair'' — diagnostic radioisotope (gamma/PET imaging) + therapeutic radioisotope (alpha/beta emitter) using same or similar molecular target; - Allows patient selection (imaging confirms target expression) + therapy + monitoring (imaging response); - Personalized medicine paradigm; (2) **Established theranostic pairs**: - **Thyroid**: I-123 (or I-124 PET) diagnostic + I-131 therapy — oldest theranostic (since 1940s); thyroid cancer ablation + hyperthyroidism; - **Neuroendocrine tumors (PRRT — peptide receptor radionuclide therapy)**: - Ga-68 DOTATATE (or DOTATOC, DOTANOC) PET — somatostatin receptor (SSTR2) imaging; - Lu-177 DOTATATE — therapy (Lutathera FDA-approved — NETTER-1 trial); - Y-90 DOTATATE — alternative therapy; - For midgut + foregut NETs (well-differentiated grade 1-2); - **Prostate cancer (PSMA — prostate-specific membrane antigen)**: - Ga-68 PSMA-11 / F-18 PSMA (DCFPyL — Pylarify, F-18 PSMA-1007) PET — PSMA imaging; revolutionized staging + recurrence detection (above question); - Lu-177 PSMA-617 (Pluvicto FDA-approved — VISION trial) — mCRPC therapy; - I-131 1095 emerging; - Ac-225 PSMA (alpha emitter) — research/expanded access — for Lu-177 refractory disease; - **Pheochromocytoma + paraganglioma**: - I-123 MIBG diagnostic + I-131 MIBG therapy (AZEDRA — FDA approved for malignant pheo/PGL); - Ga-68 DOTATATE + Lu-177 DOTATATE for SDH-mutated PGL; (3) **Emerging theranostic targets**: - **FAPI (fibroblast activation protein inhibitor)** — pan-cancer (stromal target — sarcoma, pancreatic, head + neck, breast, lung, esophageal, colorectal); F-18 / Ga-68 FAPI PET + Lu-177 / Y-90 / Ac-225 FAPI therapy; - **GRPR (gastrin-releasing peptide receptor)** — prostate, breast; - **CXCR4** — multiple cancers, leukemia; - **Antibody-radionuclide conjugates (radioimmunotherapy)**: - Zevalin (Y-90 ibritumomab) — historically for follicular lymphoma; - Bexxar (I-131 tositumomab) — withdrawn; - Antibody-targeted alpha therapy (TAT) — many in development; - **CAR-T tracking** with radiolabeled CAR-T cells — research; (4) **Alpha emitters in theranostics**: - **Higher LET (linear energy transfer)** than beta — more potent + targeted; - **Short range** (50-100 µm) — less damage to surrounding normal tissue; - **Examples**: Ra-223 (Xofigo — bone mets prostate), Ac-225, Pb-212, At-211, Bi-213; - **Indications expanding** — selected refractory disease (PSMA Ac-225, DOTATATE-Ac-225); - **Logistical challenges** — half-life, supply, regulatory; (5) **Pre-treatment dosimetry**: - **Patient-specific dose calculation** — predicts tumor + normal tissue absorbed doses; - Optimizes efficacy + safety; - Imaging-based (MAA for Y-90 SIRT, Lu-177 SPECT/CT for PRRT); (6) **Multidisciplinary theranostic team**: nuclear medicine + medical oncology + radiation oncology + radiation safety officer + radiopharmacy + medical physics + nursing + IR (some procedures) + supportive care + research (clinical trials); (7) **Patient considerations**: - Pre-treatment criteria (imaging confirms target, performance status, organ function, prior therapies); - Radiation safety education (patient + family) — release criteria + isolation; - Adverse effects management — nausea, fatigue, hematologic, renal (Lu-177 PRRT — nephrotoxicity, amino acid co-infusion for renal protection), parotid (PSMA), bone marrow (cumulative); - Cost + access (expensive, supply limitations in some regions); (8) **Future**: alpha-emitter expansion, novel targets, combination with other systemic therapies, personalized dosimetry standard, broader cancers (FAPI), neuroendocrine + prostate paradigm shifting to other malignancies

---

Theranostics: paired Dx + Tx using same target. Thyroid (I-123/131), NETs (Ga-68 DOTATATE + Lu-177 DOTATATE PRRT — NETTER-1), prostate (Ga-68 PSMA + Lu-177 PSMA-617 — Pluvicto/VISION), pheo (MIBG). Emerging — FAPI, GRPR, antibody-radionuclide. Alpha emitters expanding (Ra-223, Ac-225). Patient-specific dosimetry. Multidisciplinary.', NULL,
  'hard', 'hemato_onco', 'review',
  'radiology', 'basic_science', 'hemato_onco', 'adult',
  'SNMMI Theranostics Initiative; EANM', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Theranostics — concept + applications in nuclear medicine + oncology'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'WHO Surgical Safety Checklist + IR procedural safety + time-out', '[{"label":"A","text":"No checklist needed"},{"label":"B","text":"IR procedural safety"},{"label":"C","text":"Discharge"},{"label":"D","text":"Single approach"},{"label":"E","text":"Skip safety"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** IR procedural safety: (1) **WHO Surgical Safety Checklist** (2009 + revised) — applicable to all invasive procedures including IR: - **Sign In** (before anesthesia): patient identification (name + MRN + DOB + procedure + consent verified), site marked, allergies, airway/aspiration risk, blood loss > 500 mL anticipated; - **Time Out** (before incision/skin puncture): introduce team (names + roles), confirm patient + procedure + site, antibiotic prophylaxis given < 60 min if needed, anticipated critical events, essential imaging displayed; - **Sign Out** (before patient leaves room): instrument + sponge counts, specimen labels, key concerns for recovery; (2) **Universal Protocol** (Joint Commission, ACR): - Pre-procedure verification (patient + procedure + site); - Site marking by procedurist + patient awake when feasible; - Time-out immediately before procedure; (3) **Pre-procedure**: - **Patient identification** — two identifiers; - **Procedure verification** — consent + imaging + history + indication; - **Anesthesia + allergy review**; - **Anticoagulation** — hold per SIR consensus document; - **Antibiotic prophylaxis** if indicated (e.g., biliary, urinary, vascular grafts); - **NPO status**; - **Pregnancy check** for women of childbearing age; - **Renal function** if contrast planned; (4) **During procedure**: - **Sterile technique** — full barrier precautions; - **Continuous monitoring** — vitals, pulse oximetry, ECG, capnography for sedation; - **Sedation depth** appropriate (moderate, deep, MAC, GA — varies); - **Radiation safety** — ALARA, fluoroscopy minimization, lead protection, dosimetry; - **Communication** — closed-loop, structured (SBAR for handoffs); - **Equipment readiness** + back-up; (5) **Sedation safety**: - **Pre-sedation assessment** — ASA class, airway (Mallampati, neck mobility), aspiration risk; - **Monitoring during sedation** — capnography preferred for deep sedation; - **Reversal agents** available (naloxone, flumazenil); - **Recovery monitoring** until baseline; - **Discharge criteria** (Aldrete score, modified); (6) **Post-procedure**: - **Recovery + monitoring**; - **Discharge criteria**; - **Patient education** + instructions + return precautions + follow-up; (7) **Complications + emergencies**: - **ACLS/PALS-trained team**; - **Emergency equipment + medications** (crash cart, reversal agents, antibiotics for septic complications, contrast reaction kit); - **Massive bleeding protocols** + transfusion availability + IR/surgical backup; (8) **Quality + safety culture**: - **Root cause analysis** for adverse events; - **Morbidity + mortality conferences**; - **Reporting near-misses + adverse events** — blame-free; - **Continuous improvement**; - **Just culture** balance individual accountability + system improvement; (9) **Documentation**: - Procedure note (timed, complete, signed); - Critical communication documented; - Image archives + reports; - Medications + doses + times; - Complications + interventions; (10) **Multidisciplinary**: IR + anesthesia + nursing + technologists + administration + quality + patient safety + medical physics + radiation safety officer

---

IR safety: WHO checklist (Sign In + Time Out + Sign Out) + Universal Protocol + site marking. Pre-procedure verification + ABx prophylaxis + AC management. During — sterile + monitoring + radiation safety. Sedation safety. Post — recovery + discharge criteria + education. Adverse events RCA. Just culture. Multidisciplinary.', NULL,
  'easy', 'procedures', 'review',
  'radiology', 'ems_mgmt', 'procedures', 'adult',
  'WHO Surgical Safety Checklist; SIR; Joint Commission', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'WHO Surgical Safety Checklist + IR procedural safety + time-out'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Tele-radiology + after-hours coverage + workflow', '[{"label":"A","text":"No tele-radiology"},{"label":"B","text":"Tele-radiology + after-hours"},{"label":"C","text":"Discharge"},{"label":"D","text":"Single approach"},{"label":"E","text":"On-site only ever"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Tele-radiology + after-hours: (1) **Definition + types**: - **Tele-radiology** — transmission of imaging across distances for interpretation; - **After-hours / nighthawk** — coverage of imaging studies during off-hours (nights, weekends, holidays) when on-site radiologists not available; - **Subspecialty consultation** — connecting community hospitals to academic experts; - **Underserved area coverage** — rural, international; (2) **Models**: - **Internal tele-radiology** — same institution remote reading; - **Outsourced ''nighthawk''** — third-party service (US, India, Australia, Israel — geographic time zones); - **Subspecialty-specific** services — neuroradiology, MSK, pediatric, breast; - **Tele-imaging consultation** — informal between centers; (3) **Benefits**: - **24/7 coverage** without on-call burnout (less night/weekend in-person call for local radiologists); - **Subspecialty access** for community hospitals; - **Rural + underserved** care equity; - **Recruiting + retention** — work-life balance; - **Faster turnaround** during off-hours; (4) **Challenges + concerns**: - **Licensure** — radiologist must be licensed in state where patient is + where reading occurs (US — complex); - **Credentialing** at each receiving hospital — administrative burden; - **Hospital privileges** + medical staff bylaws; - **Continuity of care** — handoff to local radiologist for follow-up; tele-readers may not see prior studies; - **Communication** — direct contact with ordering physician + nursing — may be challenging across distances; - **Liability + malpractice** — coverage across jurisdictions; - **Quality** — varying practices, oversight, peer review difficulty; - **Cybersecurity + HIPAA** — encryption, secure transmission; - **PACS access** + IT infrastructure; - **Final vs preliminary read** — many night reads preliminary, with morning over-read by local radiologist; - **Disagreement / discordance** between preliminary + final read — patient safety implications; - **Cost** — varies; sometimes cost-effective vs in-person night call; (5) **ACR + RSNA Tele-radiology guidelines + standards**: - **Privileged + credentialed** at each facility; - **Final official read** by qualified radiologist; - **PACS + RIS integration**; - **HIPAA compliance**; - **Backup + redundancy**; - **Quality assurance + peer review**; (6) **International tele-radiology**: - **Time-zone advantage** (e.g., night in US = day in India/Australia) — daytime reading by tele-readers; - **Regulatory + licensing complexity**; - **Cost considerations**; - **Quality + cultural / language**; (7) **AI-augmented tele-radiology**: - **Worklist prioritization** (LVO, PE, ICH detection — emergent flagged); - **Quality + safety net** for missed findings; - **Workflow optimization**; (8) **Future**: - Increasing demand + supply mismatch; - AI integration; - Hybrid models combining tele + on-site; - Possible regulatory + reimbursement changes (interstate compact, etc.); (9) **Multidisciplinary**: radiology + administration + IT + medical staff + risk management + quality + patient safety + nursing + ED + ICU

---

Tele-radiology: 24/7 + subspecialty + underserved coverage. Models — internal, outsourced nighthawk, subspecialty. Benefits + challenges (licensure, credentialing, continuity, prelim vs final read). ACR + RSNA standards. International time zones. AI-augmented. Multidisciplinary.', NULL,
  'easy', 'procedures', 'review',
  'radiology', 'ems_mgmt', 'procedures', 'adult',
  'ACR Practice Parameter Telemedicine', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Tele-radiology + after-hours coverage + workflow'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Radiologist-clinician communication + collaborative relationships', '[{"label":"A","text":"No communication needed"},{"label":"B","text":"Radiologist-clinician communication"},{"label":"C","text":"Discharge"},{"label":"D","text":"Single specialty"},{"label":"E","text":"X-ray sufficient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Radiologist-clinician communication: (1) **Effective communication essential**: - **Patient safety** + outcomes — closing communication loops; - **Diagnostic accuracy** — clinical context informs interpretation; - **Workflow efficiency**; - **Education + learning**; (2) **Clinical history on requisitions**: - **Adequate clinical information** essential for appropriate interpretation; vague indications (''rule out pathology'') hinder accurate reading; - **Specific question** + relevant history + symptoms + duration + prior treatments — best practice; - **ACR practice parameter** + Choosing Wisely — providers should include indication + question; - **Two-way street** — radiologists should proactively call/contact for inadequate information; (3) **Imaging appropriateness consultation**: - **Pre-imaging consultation** — radiologist + clinician discuss optimal modality (e.g., is MRI needed or US sufficient? Which protocol?); - **ACR Appropriateness Criteria** + Choosing Wisely as reference; - **Decision support tools** in CPOE (computerized physician order entry) — point-of-order guidance; (4) **Reporting structure**: - **Structured reports** (above) — standardized templates; - **Impressions concise + actionable** — direct answer to clinical question; - **Recommendations** — appropriate, evidence-based, specific (modality + timing); - **Avoid jargon** + ambiguous language; - **Compare with priors** explicitly stated; (5) **Critical findings communication** (above earlier question Q56): - **Direct contact** (phone) for urgent findings; - **Documentation** of communication; - **Closed-loop** confirmation of receipt; - **Critical results management systems**; (6) **Multidisciplinary conferences + tumor boards**: - **Cross-specialty learning**; - **Patient outcomes**; - **Subspecialty radiology input** essential — improves care; - **Pre-meeting preparation** — review imaging + reports; - **Active participation**; (7) **In-person + digital consultation**: - **Reading room visits** by clinicians — collaborative, educational; - **Walk-in consultations**; - **Phone calls** + secure messaging for questions; - **Real-time imaging review** during procedures (e.g., before surgery); (8) **Conflict + disagreement management**: - **Constructive professional discussion** — focus on patient care; - **Second opinions** in radiology — encouraged when uncertainty; - **Peer review** + tumor board for difficult cases; - **Just culture** for errors + learning; (9) **Clinician education**: - **Continuing education** sessions for referring providers; - **''Lunch + learn''** by radiology; - **Newsletters / updates** on new techniques, criteria; - **Department websites** with imaging guides; (10) **Patient-centered communication evolution**: - **Open Notes + patient portals** — patients access reports; - **Plain-language summaries**; - **Direct radiologist-patient communication** — emerging in some practices (e.g., mammography results immediate, breast clinic models); - **Shared decision-making**; (11) **Outpatient settings + virtual consultations**; (12) **Documentation + medicolegal**: - **Detailed documentation** of communication — protects both parties + ensures continuity; - **Acknowledgment** of recommendations; - **Standardized terminology**; (13) **Multidisciplinary**: radiology + referring providers + administration + IT + nursing + patients + caregivers — radiology as ''doctor''s doctor'' historically + increasingly ''patient''s doctor''

---

Radiologist-clinician communication: clinical history on requisitions + pre-imaging consultation + structured reports + critical findings closed-loop + tumor board participation + reading room visits + clinician education + patient-centered (Open Notes + plain language summaries) + documentation. Multidisciplinary.', NULL,
  'easy', 'procedures', 'review',
  'radiology', 'ems_mgmt', 'procedures', 'adult',
  'ACR Practice Parameter Communication; Choosing Wisely', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Radiologist-clinician communication + collaborative relationships'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Comprehensive stroke center — multidisciplinary system', '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Comprehensive stroke center"},{"label":"C","text":"Discharge"},{"label":"D","text":"X-ray sufficient"},{"label":"E","text":"Single hospital model"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Comprehensive stroke center: (1) **Stroke center designation tiers** (Joint Commission + AHA): - **Acute Stroke Ready Hospital (ASRH)** — basic capability — diagnose + start tPA + transfer; - **Primary Stroke Center (PSC)** — 24/7 capabilities + tPA + admit + telemedicine consultation; - **Thrombectomy-capable Stroke Center (TSC)** — adds endovascular thrombectomy + neuro-IR + neurosurgical backup; - **Comprehensive Stroke Center (CSC)** — full capabilities including complex neuro-IR + neurosurgery + neuroICU + research; (2) **Multidisciplinary stroke team**: - **Acute phase**: EMS (pre-hospital) + ED + stroke neurology + neuro-IR + neurosurgery + neurointensivist + radiology + pharmacy + nursing + tele-stroke (when applicable); - **Sub-acute + chronic phases**: rehabilitation (PT/OT/SLP) + PCP + cardiology (for AFib, secondary prevention) + neuropsychology + psychiatry/mental health (post-stroke depression) + endocrinology (DM) + nephrology (CKD) + nutrition + social work + case management + palliative care (severe disability) + survivorship; (3) **Process metrics + benchmarks**: - **Door-to-imaging** ≤ 25 minutes; - **Door-to-needle (tPA/TNK)** ≤ 60 minutes (target ≤ 45 minutes); - **Door-to-groin (thrombectomy)** ≤ 90 minutes; - **Door-in-door-out (transfer)** ≤ 120 minutes; - **AHA Get With The Guidelines-Stroke (GWTG)** — quality reporting + recognition (honor roll); (4) **Quality improvement**: - **Continuous case review** + M&M; - **Time-tracking** (every minute counts — ''1.9 million neurons per minute'' LVO); - **Process improvements** — pre-notification by EMS, single-call activation, parallel processes (registration concurrent with CT), tPA mixing during CT, reverse-flow CT-to-ED bed, premixed weight-based tPA; - **AI-assisted LVO detection + perfusion analysis** (Viz.ai, RapidAI, Avicenna.AI); (5) **Tele-stroke**: - **Hub-and-spoke model** — academic CSC supports community PSC/ASRH; - **Vrobot consultation** — patient evaluation via video + image review; - **Reduces disparity** in rural + underserved areas; - **Decision support** for tPA, thrombectomy transfer; - **Pre-hospital telestroke** (mobile stroke units in some cities — CT + tPA pre-hospital); (6) **Secondary prevention**: - **Antiplatelet** (aspirin, clopidogrel, dual for high-risk minor stroke per CHANCE/POINT/SOCRATES); - **Anticoagulation** for AFib (DOAC preferred); - **High-intensity statin** (LDL < 70 mg/dL target per recent guidelines); - **BP control** < 130/80; - **Diabetes management**; - **Smoking cessation + lifestyle** + cardiac rehab adaptation; - **Carotid revascularization** for symptomatic stenosis 70-99% (earlier the better); - **Sleep apnea screening + treatment**; (7) **Rehabilitation**: - **Early + intensive**; - **PT** (gait, balance, strength); - **OT** (ADLs, fine motor); - **Speech-language pathology** (aphasia, apraxia, dysphagia); - **Neuropsychology** (cognitive remediation, depression); - **Inpatient rehab unit vs SNF vs home with services** — by acuity + needs; (8) **Patient + family education + support**: - **Stroke warning signs** (FAST/BEFAST — Balance, Eyes, Face, Arm, Speech, Time); - **Medication adherence** + secondary prevention; - **Fall prevention**; - **Equipment + adaptive technology**; - **Driving + return to work**; - **Caregiver support + burnout prevention** + respite; - **Community resources** + support groups; (9) **Advance care planning** for severe disability; (10) **Research + clinical trials**: - **Continuous trials** drive evidence + practice; - **Centralized care + protocols** drive consistency

---

Stroke center: tiered designation (ASRH/PSC/TSC/CSC). Multidisciplinary acute + chronic team. Process metrics (DTN ≤ 60). Quality improvement + AI. Tele-stroke hub-and-spoke. Secondary prevention multimodal. Comprehensive rehabilitation. Patient + family education. Multidisciplinary throughout.', NULL,
  'easy', 'neurology', 'review',
  'radiology', 'integrative', 'neurology', 'adult',
  'AHA/ASA + Joint Commission Stroke Centers', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Comprehensive stroke center — multidisciplinary system'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Trauma center — multidisciplinary system + ACS verification', '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Trauma center system"},{"label":"C","text":"Discharge"},{"label":"D","text":"No trauma system"},{"label":"E","text":"X-ray sufficient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Trauma center system: (1) **ACS trauma center verification levels**: - **Level I** — full capability academic; 24/7 in-house all specialties (trauma surgery, anesthesia, OR, IR, neuro, ortho, etc.); research + education; - **Level II** — full capability without research/education requirements; - **Level III** — initial stabilization + transfer capability; - **Level IV/V** — basic stabilization + transfer; (2) **Multidisciplinary trauma team activation**: - **Trauma surgery** (team leader) + emergency medicine + anesthesia + critical care + nursing + respiratory + radiology (in-house for level I + II) + lab + blood bank + IR (24/7 for level I + II); - **Specialty consultation 24/7** — neurosurgery, orthopedic surgery, vascular, urology, cardiothoracic, plastic, ophthalmology, ENT, OB/GYN; - **Pediatric trauma** — peds surgery + peds anesthesia + peds critical care; (3) **Pre-hospital integration**: - **EMS triage protocols** — field trauma criteria (CDC, ACS) — physiological + anatomic + mechanism + special considerations (age, comorbidities, pregnancy); - **Pre-notification** of receiving trauma center; - **Air medical transport** for distant scenes; - **Pre-hospital interventions** — airway, blood products, TXA; (4) **Reception + initial assessment (ATLS-based)**: - **Primary survey (ABCDE)** — airway + breathing + circulation + disability + exposure; - **Adjuncts** — FAST/eFAST, ECG, blood gas, labs, X-rays (CXR + pelvis often); - **Secondary survey** — head-to-toe systematic; - **Tertiary survey** at 24+ hours — re-evaluation + missed injuries; (5) **Imaging integration** (above earlier question): - **Pan-scan for severe**; - **Selective for stable / minor**; - **IR for trauma embolization** (above); - **CT decision rules** to reduce unnecessary imaging in selected (NEXUS, Canadian C-spine, PECARN); (6) **Resuscitation + critical care**: - **Massive transfusion protocol (MTP)** — 1:1:1 (RBC:plasma:platelets) + TXA; - **Damage control resuscitation** — permissive hypotension (for non-TBI), warming, balanced fluid resuscitation; - **Coagulopathy correction** + TEG/ROTEM-guided in select centers; - **Damage control surgery** — abbreviated procedures for unstable, return to OR after stabilization; (7) **Subspecialty integration**: - **Neurosurgery** for severe TBI (ICP monitoring, decompressive craniectomy) + spinal cord injury; - **Orthopedic surgery** for fracture management; - **Vascular + IR** for vascular injuries + embolization; - **Cardiothoracic** for cardiac + great vessel injuries; - **Plastic surgery** for soft tissue + reconstructive; (8) **Critical care + rehabilitation**: - **Trauma ICU** with multidisciplinary rounds; - **Early mobilization + rehab** — PT/OT/SLP; - **Inpatient rehab unit** post-acute for selected (TBI, SCI, multitrauma); - **Nutrition + DVT prophylaxis + infection prevention + delirium management**; (9) **Long-term care + survivorship**: - **PTSD + mental health** screening + treatment (high incidence — military + civilian); - **Chronic pain management**; - **Return to work + community reintegration**; - **Disability + accommodations**; - **Substance use** treatment (often comorbid); - **Family support**; (10) **Quality + research**: - **Trauma registry** (TQIP — Trauma Quality Improvement Program); - **Benchmarking + risk-adjusted outcomes**; - **Continuous quality improvement** — case review + M&M; - **Research + protocol development**; (11) **Injury prevention** — public health: education, legislation (seat belts, helmets, drunk driving, gun safety), engineering (vehicle safety, road design), environmental modifications; (12) **Disaster preparedness + mass casualty** response capability; (13) **Multidisciplinary throughout continuum**: pre-hospital → resuscitation → acute care → rehab → community

---

Trauma center: ACS levels I-V verification. Multidisciplinary 24/7 — trauma surgery leader + many specialties. EMS triage + pre-notification. ATLS primary + secondary + tertiary survey. Imaging integration. MTP + TXA + damage control. Subspecialty + ICU + rehab. PTSD + survivorship. TQIP registry. Prevention + disaster prep. Multidisciplinary.', NULL,
  'medium', 'trauma', 'review',
  'radiology', 'integrative', 'trauma', 'adult',
  'ACS Resources for Optimal Care of Injured; ATLS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Trauma center — multidisciplinary system + ACS verification'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Image-guided palliative care — multidisciplinary', '[{"label":"A","text":"Discharge"},{"label":"B","text":"Image-guided palliative interventions"},{"label":"C","text":"Single specialty"},{"label":"D","text":"No palliative care"},{"label":"E","text":"X-ray sufficient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Image-guided palliative interventions: (1) **Concurrent palliative care** model — from diagnosis, not ''end of life only'' — improves QOL + may improve survival (Temel 2010 NEJM, ASCO 2017 Statement); (2) **Imaging for palliative care goals**: - **Symptom relief** — pain (bone mets — vertebroplasty, ablation; visceral pain — celiac plexus block); - **Function preservation** — biliary drainage, urinary diversion; - **Quality of life**; - **Avoiding more invasive interventions** when possible; (3) **Image-guided palliative IR procedures**: - **Pain management**: - **Vertebroplasty / kyphoplasty** for vertebral compression fracture pain (above earlier Q); - **Bone ablation (RFA, MWA, cryo)** for painful bone metastases + cementoplasty for weight-bearing bones (acetabulum, pelvis, sacrum, long bone); - **Celiac plexus block / neurolysis** for pancreatic + upper abdominal cancer pain (above); - **Splanchnic / superior hypogastric** blocks for selected pelvic pain; - **Intercostal blocks** for chest wall pain; - **Genicular nerve block + RFA** for knee OA pain (cancer-related or non-cancer); - **Drainage of effusions / ascites**: - **Indwelling pleural catheter (IPC)** for recurrent malignant pleural effusion — outpatient drainage; - **Talc pleurodesis** alternative; - **Indwelling peritoneal catheter** for malignant ascites; - **Tunneled drainage** for refractory; - **Mechanical obstruction relief**: - **Biliary stenting (ERCP or PTBD)** for malignant biliary obstruction; - **Esophageal stenting** for malignant dysphagia; - **Tracheobronchial stenting** for malignant airway obstruction; - **GI stenting** for gastric outlet + colonic obstruction; - **Ureteral stenting / nephrostomy** for malignant ureteric obstruction; - **Vascular**: - **SVC syndrome stenting** for malignant SVC obstruction (rapid symptom relief — superior to RT in some studies for relief speed); - **TIPS** for refractory ascites (above) — for cirrhosis + HCC selected; - **Tumor embolization**: - **TACE / TARE** for HCC + selected mets; - **Splenic embolization** for hypersplenism + thrombocytopenia; - **Renal artery embolization** for hematuria from RCC; - **Pelvic embolization** for hematuria from bladder cancer; - **Hemoptysis embolization** for cancer; - **Hemorrhage** from cancer-related bleeding; - **Vascular access**: - **Port placement** (above); - **PICC for shorter-term chemo / antibiotics**; - **Tunneled catheters** for end-stage requiring hemodialysis or other; (4) **Multidisciplinary palliative care team**: - Palliative care physicians + nurses + APPs + chaplains + social workers + child life (peds) + bereavement counselors + ethics committee + IR + medical oncology + radiation oncology + pain management + hospice (when prognosis < 6 months + comfort focus); (5) **Communication + decision-making**: - **Goals of care discussions** — frequent + ongoing; - **Substituted judgment** for incapacitated patients; - **Family meetings** + ethics consultation for conflicts; - **Advance care planning** + advance directives; - **POLST / MOLST** (Physician Orders for Life-Sustaining Treatment) for transitions; (6) **Symptom assessment + management**: - **Pain** (multimodal — opioids + adjuvants + IR procedures + RT + chemo + lifestyle); - **Dyspnea** (opioids low-dose, fan, oxygen if hypoxic, treat reversible causes); - **Nausea** (multimodal antiemetics); - **Constipation** (especially opioid-related); - **Anxiety + depression** + delirium; - **Fatigue**; - **Sleep**; - **Psychosocial + spiritual + existential**; (7) **Family / caregiver support**: - Education + communication; - Anticipatory grief; - Bereavement; - Respite care; - Financial counseling; (8) **End-of-life care**: - Hospice transitions; - Place of death preferences (home, hospice, hospital); - Symptom focus + dignity; - Spiritual care; - Bereavement follow-up for family; (9) **Quality measures**: - **Symptom assessment + management**; - **Goals-of-care discussions documented**; - **Hospice transition timing** appropriate (not too late); - **Family satisfaction**; - **Bereaved family follow-up**; (10) **Multidisciplinary throughout cancer journey — image-guided palliation is integral to comprehensive cancer care, not separate from it**

---

Image-guided palliative care: concurrent from diagnosis. Image-guided IR procedures — vertebroplasty, bone ablation, celiac block, IPC drainage, biliary/ureteral stenting, embolization. Multidisciplinary palliative team. Goals of care + decision-making + family meetings. Symptom management. Family support. End-of-life. Quality measures. Multidisciplinary integral.', NULL,
  'medium', 'hemato_onco', 'review',
  'radiology', 'integrative', 'hemato_onco', 'adult',
  'ASCO Palliative Care 2017; SIR; AAHPM', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Image-guided palliative care — multidisciplinary'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 65 ปี postmenopausal — DXA bone density + FRAX risk assessment for osteoporosis', '[{"label":"A","text":"No screening"},{"label":"B","text":"Osteoporosis screening + management"},{"label":"C","text":"Discharge"},{"label":"D","text":"Single specialty"},{"label":"E","text":"X-ray sufficient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Osteoporosis screening + management: (1) **USPSTF + ISCD + NOF recommendations**: - **Women ≥ 65** — screen with DXA (Grade B); - **Postmenopausal < 65 + risk factors** — selective screening (FRAX > 9.3% 10-year MOF risk or family history, low body weight, smoking, alcohol, prior fracture, steroids, etc.); - **Men ≥ 70** or men 50-70 with risk factors — controversial; AACE, NOF recommend; - **Repeat interval** based on T-score: normal/mild osteopenia (T > -1.5) — q5-10 years; moderate (-1.5 to -1.99) — 3-5 years; advanced (T ≤ -2.0) — 1-2 years; (2) **DXA (dual-energy X-ray absorptiometry)** — gold standard: - **T-score** (compared to young adult of same sex) — definitions: normal ≥ -1.0; osteopenia -1.0 to -2.5; osteoporosis ≤ -2.5; severe osteoporosis ≤ -2.5 + fragility fracture; - **Z-score** (compared to age + sex-matched) — useful in pre-menopausal + young men + children; - **Sites**: hip (femoral neck — most predictive of hip fracture), spine (L1-L4 — affected by degenerative changes, scoliosis), forearm (selected when hip/spine not feasible); (3) **FRAX (Fracture Risk Assessment Tool)** — WHO algorithm: - Calculates 10-year probability of MOF (major osteoporotic fracture: hip, spine, distal radius, proximal humerus) + hip fracture alone; - Inputs: age, sex, BMI, prior fracture, parental hip fx, smoking, glucocorticoids, RA, secondary osteoporosis, alcohol, femoral neck T-score (optional); - **Treatment thresholds**: MOF ≥ 20% OR hip ≥ 3% (NOF) — treat regardless of T-score; (4) **Fragility fracture** = osteoporosis (clinical Dx) regardless of T-score — start treatment; (5) **Secondary causes workup**: vitamin D + calcium + PTH + TSH + 24h urine Ca + serum protein electrophoresis (MM); selected — testosterone (men), celiac antibodies, tryptase (mastocytosis); (6) **Treatment**: - **Lifestyle**: calcium 1200 mg/day, vitamin D 800-2000 IU/day (target serum 25(OH)D > 30 ng/mL), weight-bearing + resistance exercise, fall prevention, smoking cessation, alcohol moderation; - **Pharmacologic**: - **Bisphosphonates first-line** — alendronate, risedronate (oral weekly), zoledronic acid IV annual; reduce vertebral + non-vertebral fracture; concerns — atypical femur fracture (rare, prolonged use), ONJ (osteonecrosis of jaw — dental clearance + monitoring); ''drug holiday'' after 5 years oral / 3 years IV in low-risk; - **Denosumab** (RANKL inhibitor) — SQ q6 months; potent; rebound vertebral fractures if discontinued without alternative; - **Anabolic agents**: teriparatide + abaloparatide (PTH analogs SQ daily × 2 years), romosozumab (anti-sclerostin SQ monthly × 1 year — cardiovascular caution); for severe / high-risk; **followed by anti-resorptive** to maintain gains; - **Estrogen (HRT)** — selected postmenopausal women; - **SERMs** (raloxifene) — postmenopausal; also reduces breast cancer; - **Calcitonin** rarely used; (7) **Monitoring**: DXA q1-3 years on therapy; (8) **Multidisciplinary**: primary care + endocrinology + rheumatology + orthopedics (post-fracture) + nutrition + PT (fall prevention) + dental

---

Osteoporosis: USPSTF — women ≥ 65 (selective < 65). DXA T-score categories. FRAX 10-year fracture risk. Treat fragility fx + DXA ≤ -2.5 + FRAX ≥ 20% MOF / ≥ 3% hip. Treatment — bisphosphonates first-line, denosumab, anabolic (teriparatide, romosozumab) for severe. Lifestyle. Multidisciplinary.', NULL,
  'easy', 'endocrine_metabolic', 'review',
  'radiology', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'USPSTF Osteoporosis; NOF; ACOG; AACE', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'หญิงอายุ 65 ปี postmenopausal — DXA bone density + FRAX risk assessment for osteoporosis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี incidental thyroid nodule on CT — TI-RADS classification + workup', '[{"label":"A","text":"FNA all nodules"},{"label":"B","text":"Thyroid nodule — TI-RADS workup"},{"label":"C","text":"Discharge ignore"},{"label":"D","text":"Single specialty"},{"label":"E","text":"Surgery without biopsy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Thyroid nodule — TI-RADS workup: (1) **Prevalence**: 50% of adults have thyroid nodules on US; majority benign; cancer prevalence ~ 5-10%; (2) **TI-RADS (Thyroid Imaging Reporting and Data System) — ACR 2017**: - **Categorization based on 5 US features**: composition (cystic/spongiform → solid), echogenicity (anechoic → very hypoechoic), shape (taller-than-wide suspicious), margin (smooth → irregular/lobulated/extrathyroidal extension), echogenic foci (none → microcalcifications); - Each feature scored 0-3 points; sum → categories: - TR1 (0 points): benign — no FNA; - TR2 (2 points): not suspicious — no FNA; - TR3 (3 points): mildly suspicious — FNA if ≥ 2.5 cm, follow if ≥ 1.5 cm; - TR4 (4-6 points): moderately suspicious — FNA if ≥ 1.5 cm, follow if ≥ 1.0 cm; - TR5 (≥ 7 points): highly suspicious — FNA if ≥ 1.0 cm, follow if ≥ 0.5 cm; (3) **Other suspicious features**: extrathyroidal extension, abnormal lymph nodes (cystic, microcalcifications, peripheral vascularity); (4) **Suspicious nodule workup**: - **TSH** first (low TSH — toxic nodule, do uptake scan first — autonomously functioning nodules rarely malignant); - **US-guided FNA biopsy** (per TI-RADS or Bethesda criteria) — Bethesda 6 categories: I (non-diagnostic), II (benign), III (AUS/FLUS — atypia of undetermined significance), IV (follicular neoplasm), V (suspicious for malignancy), VI (malignant); - **Molecular testing** (Afirma GSC, ThyroSeq) for Bethesda III + IV indeterminate — refines malignancy risk; - **Calcitonin** — selected for medullary thyroid cancer suspicion (family history MEN, RET mutation); (5) **Choosing Wisely + Image Gently**: - **Don''t biopsy thyroid nodules < 1 cm** unless suspicious + clinical concern (e.g., regional nodes, prior neck RT, family history); - **Avoid imaging-driven cascade** for incidental small nodules; (6) **Treatment**: - **Differentiated thyroid cancer (papillary, follicular)** — usually surgical (lobectomy for low-risk T1-T2, total thyroidectomy for higher risk + LN dissection if N+); RAI for selected (high-risk per ATA); long-term TSH suppression therapy; surveillance imaging + Tg; - **Medullary thyroid cancer** — surgery + careful surveillance; genetic testing (RET); selpercatinib/pralsetinib for RET-altered metastatic; - **Anaplastic thyroid cancer** — aggressive, rapidly fatal; BRAF V600E targeted (dabrafenib + trametinib for selected); - **Active surveillance** for very low-risk small papillary cancers — emerging (Kuma + Memorial Sloan Kettering protocols) — selected; (7) **Multidisciplinary**: endocrinology + endocrine surgery + ENT + radiology + pathology + nuclear medicine + medical oncology

---

Thyroid nodule: TI-RADS US categorization (TR1-5). FNA based on TR + size threshold. Bethesda categories I-VI with molecular testing for indeterminate. Choosing Wisely — avoid biopsy < 1 cm unless suspicious. Treatment by histology + risk. Active surveillance emerging. Multidisciplinary.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'radiology', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'ACR TI-RADS; ATA Thyroid Nodule + Cancer 2015', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี incidental thyroid nodule on CT — TI-RADS classification + workup'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี incidental pancreatic cyst on CT done for other reason — IPMN evaluation', '[{"label":"A","text":"Surgery for all cysts"},{"label":"B","text":"Pancreatic cystic lesions — IPMN + AGA"},{"label":"C","text":"Discharge ignore"},{"label":"D","text":"Single specialty"},{"label":"E","text":"X-ray sufficient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pancreatic cystic lesions — IPMN + AGA: (1) **Common pancreatic cystic lesions**: - **Serous cystadenoma** (microcystic — honeycomb appearance, central calcified scar; benign — no surveillance needed if classic features); - **Mucinous cystic neoplasm (MCN)** — typically women, body/tail, single locule, ovarian-type stroma; **premalignant** — surgical resection generally for size > 4 cm or symptoms; - **IPMN (intraductal papillary mucinous neoplasm)** — communicates with pancreatic duct; subtypes: - **Main-duct (MD-IPMN)** — diffuse duct dilation > 5 mm — **high-risk for malignancy** — surgical resection generally; - **Branch-duct (BD-IPMN)** — communicates with side branch, more common; risk depends on size + features; - **Mixed-type**; - **Solid pseudopapillary neoplasm** — young women, peripheral solid + cystic; low malignant potential; surgical resection; - **Pseudocyst** (post-pancreatitis, no epithelium, communicates with duct sometimes); (2) **AGA + ACR guidelines** for BD-IPMN + indeterminate cysts: - **''Worrisome features'' = MRCP-detected**: cyst ≥ 3 cm, growth ≥ 5 mm/2 years (now ACG threshold), thickened/enhancing cyst wall, MPD 5-9 mm, non-enhancing mural nodule, abrupt change in caliber of MPD with distal pancreatic atrophy, lymphadenopathy, elevated CA 19-9; - **''High-risk stigmata'' (HRS) — surgical indication**: enhancing mural nodule ≥ 5 mm, MPD ≥ 10 mm, obstructive jaundice; - **EUS-FNA** for cysts with worrisome features: aspirate fluid for CEA (> 192 ng/mL — mucinous), cytology, KRAS/GNAS mutations, biomarkers; (3) **Surveillance**: - **Initial cysts < 1 cm, no features**: CT or MRI/MRCP q1-2 years (some guidelines longer interval); - **1-2 cm**: MRI/MRCP q6-12 months × 2 years, then q1-2 years; - **2-3 cm**: MRI/MRCP q3-6 months × 2 years, then less frequent; consider EUS-FNA; - **≥ 3 cm + no HRS**: MRI/MRCP q3-6 months + EUS-FNA; - **HRS**: surgical resection generally; - **Stop surveillance** in elderly + significant comorbidities (Kaiser study — many cysts indolent in elderly); (4) **Modality**: - **MRI + MRCP — preferred** over CT for follow-up (no radiation, better ductal anatomy); - **CT pancreas protocol** initially; - **EUS** for high-resolution + sampling; - **PET selective**; (5) **Surgery**: - **Whipple (pancreaticoduodenectomy)** for pancreatic head; - **Distal pancreatectomy** for body/tail; - **Central pancreatectomy** rarely; - **Multidisciplinary planning** essential; (6) **Adjuvant for invasive component** — chemo similar to PDAC; (7) **Multidisciplinary**: pancreatic surgery + GI + radiology + pathology + medical oncology + nutrition + nursing

---

Pancreatic cysts: IPMN (BD vs MD), MCN, serous. AGA + ACR criteria — worrisome features vs HRS. MRI/MRCP for surveillance + EUS-FNA. Surgery for HRS or worrisome with growth. Surveillance intervals by size + features. Stop in elderly + comorbidities. Multidisciplinary.', NULL,
  'hard', 'gi', 'review',
  'radiology', 'clinical_decision', 'gi', 'adult',
  'AGA + ACR Pancreatic Cyst; Fukuoka + Sendai Criteria', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี incidental pancreatic cyst on CT done for other reason — IPMN evaluation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 70 ปี renal mass — contrast-enhanced US (CEUS) for characterization', '[{"label":"A","text":"Always CT"},{"label":"B","text":"Contrast-enhanced ultrasound (CEUS)"},{"label":"C","text":"Discharge"},{"label":"D","text":"Single specialty"},{"label":"E","text":"No CEUS available"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Contrast-enhanced ultrasound (CEUS): (1) **Concept**: microbubbles (sulfur hexafluoride or perflutren — Lumason, Definity, Sonovue) injected IV — pure intravascular agent (do NOT cross vascular endothelium — true blood pool tracer); imaged with low-MI contrast-specific imaging; visualizes microvasculature in real-time; (2) **Advantages**: - **No radiation**; - **No iodinated contrast** (safe in renal failure — eGFR < 30); - **No gadolinium** (no NSF risk); - **Real-time imaging** + dynamic assessment; - **Repeatable**; - **Bedside** + portable; - **Cost-effective**; - **Safe in pregnancy** (per ACR; off-label but used clinically); (3) **Clinical applications**: - **Focal liver lesions characterization**: hemangiomas (peripheral nodular discontinuous enhancement → centripetal fill-in), HCC (arterial hyperenhancement → washout — similar to CT/MRI), FNH (homogeneous arterial), adenoma, mets (variable), abscess (rim enhancement); - **HCC LI-RADS CEUS** specific category with separate criteria from CT/MRI; - **Renal lesions** (this question): characterizes enhancement of solid component vs proteinaceous cyst (which may be hyperechoic but non-enhancing); avoids iodinated contrast in CKD; - **Vascular**: assessment of endoleaks post-EVAR, vascular access (AVF dysfunction), TIPS patency; - **Cardiac**: LV opacification + cavity definition (echocardiographic contrast); - **Bowel** — Crohn disease activity (vascularity), bowel ischemia (contraindications evolving); - **Pediatric** — vesicoureteral reflux (contrast voiding urosonography — no radiation alternative to VCUG); other applications; - **Trauma** — solid organ injury characterization in selected (alternative to CT for follow-up); - **Spleen, pancreas, testicular** — variable applications; (4) **Adverse reactions**: - **Generally very safe** — anaphylaxis rare (< 1 per 10,000); - **Class III chronic congestive HF, severe pulmonary HTN** — relative caution (right heart shunting concerns); - **Right-to-left cardiac shunt** — contraindication (microbubbles in arterial circulation — paradoxical embolus theoretical concern); - **Most pediatric uses safe** including small infants; (5) **Limitations**: - **Operator-dependent**; - **Body habitus** (obesity); - **Bowel gas + lung**; - **Cannot visualize bone or deep retroperitoneal**; - **Single field-of-view** vs whole-body CT/MRI; - **Quantitative analysis** still developing; (6) **Cost + reimbursement** improving but variable by country; **FDA approvals** expanding (most recent — non-vascular pediatric, focal liver in adult + pediatric); (7) **Multidisciplinary**: radiology + ultrasound + clinical specialists (hepatology, urology, cardiology, GI, pediatrics)

---

CEUS: microbubble intravascular contrast. Advantages — no radiation/iodine/gadolinium, real-time, bedside, safe in CKD + pregnancy. Applications — liver (LI-RADS), renal, vascular, cardiac, pediatric (VCUG alternative), trauma. Very safe, rare anaphylaxis. Multidisciplinary.', NULL,
  'medium', 'renal_gu', 'review',
  'radiology', 'clinical_decision', 'renal_gu', 'adult',
  'ACR CEUS; AIUM; CEUS LI-RADS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 70 ปี renal mass — contrast-enhanced US (CEUS) for characterization'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 30 ปี chronic abdominal pain + bloody diarrhea — UC vs Crohn imaging differentiation + intestinal US', '[{"label":"A","text":"X-ray sufficient"},{"label":"B","text":"Intestinal US in IBD — emerging modality"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Discharge"},{"label":"E","text":"No imaging"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Intestinal US in IBD — emerging modality: (1) **Intestinal US (IUS)** — emerging modality for IBD assessment: - **Operator + center expertise** required; - **No radiation, repeatable, portable, lower cost**; - Particularly useful for: monitoring disease activity, response to treatment, complications screening (abscess, stricture, perforation), severe disease assessment, pregnancy; - **Findings**: bowel wall thickening (> 3 mm), loss of stratification (5 layers normally), hypervascularity (Doppler), mesenteric changes, lymphadenopathy, complications (fistula, abscess, stricture); (2) **Comparison with cross-sectional imaging**: - **MRE / CTE**: comprehensive, validated, but cost + time + radiation (CTE); MRE preferred for young patients; - **IUS**: point-of-care, immediate, real-time; emerging evidence supports use; can assess response within weeks of treatment changes; - **Endoscopy + biopsy**: gold standard for mucosal disease + histology + dysplasia surveillance; - **Multimodal** approach often used; (3) **UC vs Crohn imaging features** (revisited from earlier batch 3 Crohn Q): - **UC**: continuous from rectum, mucosal/superficial (wall thickening + edema, narrowed lumen, loss of haustra), no skip lesions, no fistulas (typically), no creeping fat, ''lead pipe'' colon chronic, perianal disease absent; - **Crohn**: discontinuous skip lesions, transmural (full wall involvement, fistulas, abscesses), terminal ileum involvement common, creeping fat, perianal disease frequent; (4) **Differentiating + indeterminate colitis**: - 10-15% of IBD patients have features overlapping — ''IBD-unclassified'' (IBDU); - Distinction important for medication selection + surgical planning (UC → IPAA; Crohn → no IPAA due to risk of recurrence + pouchitis); (5) **Activity assessment** (treat-to-target): - **Clinical** (symptoms, PROs); - **Laboratory** (CRP, fecal calprotectin); - **Endoscopic** (Mayo for UC, SES-CD for Crohn); - **Imaging** — MRE / IUS / CTE for transmural healing; - **Mucosal healing** + transmural healing (deeper) — best predictors of outcomes; (6) **Treatment escalation based on activity** — STRIDE-II + IBD management paradigms (above batch 3 Q); (7) **Complications imaging + management** (above Q3 covered IBD chronic care extensively); (8) **Modern**: AI-augmented IUS + advanced sonography techniques; multimodal imaging integration; personalized treatment by response monitoring; (9) **Multidisciplinary**: GI + IBD specialist + radiology (cross-sectional + US) + colorectal surgery + IR + nutrition + nursing + mental health

---

Intestinal US (IUS) emerging for IBD monitoring — no radiation, real-time, bedside. Findings — wall thickening, loss of stratification, hypervascularity. UC vs Crohn distinctions on imaging. Treat-to-target with mucosal + transmural healing. Multimodal imaging. Multidisciplinary IBD care.', NULL,
  'medium', 'gi', 'review',
  'radiology', 'clinical_decision', 'gi', 'adult',
  'AGA + ECCO IBD Imaging', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'หญิงอายุ 30 ปี chronic abdominal pain + bloody diarrhea — UC vs Crohn imaging differentiation + intestinal US'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Radiation biology — deterministic vs stochastic effects + dose-response', '[{"label":"A","text":"No biological effects"},{"label":"B","text":"Radiation biology — deterministic vs stochastic"},{"label":"C","text":"Discharge"},{"label":"D","text":"Single approach"},{"label":"E","text":"All radiation same"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Radiation biology — deterministic vs stochastic: (1) **Deterministic effects** (tissue reactions): - **Threshold dose** below which no effect occurs; - Severity increases with dose above threshold; - Predictable, reproducible; - Examples: erythema (~ 2 Gy), epilation (~ 3-5 Gy), cataracts (1-5 Gy cumulative), sterility (transient ~ 0.15 Gy, permanent ~ 3.5-6 Gy gonad), fetal effects (organogenesis 1st trimester — malformations > 100 mGy, microcephaly 8-15 wks > 100 mGy, intellectual deficit > 100 mGy); - **Modern interventional radiology** can cause skin injury with prolonged fluoroscopy (rare with modern practice, but reported); - **Therapy** (radiation oncology) — controlled deterministic effects on tumors; (2) **Stochastic effects** (probability of effect, all-or-none): - **No threshold (per LNT — linear no-threshold model — controversial but adopted regulatory)**; - **Probability** increases with dose; **severity** does NOT depend on dose; - **Latency** years (cancer) to lifetime; - **Examples**: cancer (solid tumors, leukemia), hereditary effects (theoretical, not demonstrated in humans); - **BEIR VII risk estimates**: ~ 1 in 1000 lifetime cancer risk per 10 mSv (varies by age, sex, organ); higher in pediatric, female; (3) **Dose-response models**: - **LNT (linear no-threshold)** — regulatory standard, may overestimate at very low doses; - **Linear quadratic** — DSB repair considerations; - **Threshold/hormesis** — adaptive response at very low doses — controversial; - **At very high doses (RT range)** — different kinetics; (4) **Dose units**: - **Absorbed dose (Gy, gray)** — energy deposited per mass (1 Gy = 1 J/kg); - **Equivalent dose (Sv, sievert)** — biological weighting by radiation type (x-ray/gamma = 1, alpha = 20, neutron = 2-20); - **Effective dose (Sv)** — additional tissue weighting (bone marrow, breast, colon — most weighted); - **DAP (dose-area product)** — fluoroscopy; (5) **Special populations more sensitive**: - **Pediatric** (3-4× adult radiosensitivity per BEIR VII); - **Fetus** (organogenesis, CNS development); - **Women** (breast tissue young, especially); - **Genetic predisposition** (Li-Fraumeni — TP53, ataxia-telangiectasia, BRCA — some studies); (6) **ALARA principle** — As Low As Reasonably Achievable: - **Time**: minimize fluoroscopy + scan time; - **Distance**: inverse square law — doubling distance ↓ dose to 1/4; - **Shielding**: lead aprons, walls, leaded glass; - **Justification + optimization** of imaging studies; (7) **Occupational radiation safety**: - **NCRP + ICRP guidelines**; - **Annual occupational limits**: 50 mSv/year whole body (lower for pregnant workers 0.5 mSv/month — fetus); - **Dosimetry badges** + ALARA program; - **Pregnant workers + radiation** — modified duty options + counseling; (8) **Public dose limit**: 1 mSv/year background-additional; (9) **Patient dose limits**: not set per se (clinical benefit drives), but ALARA + appropriateness criteria + dose monitoring + optimization; (10) **Multidisciplinary**: radiology + medical physics + radiation safety officer + nuclear medicine + radiation oncology + administration + IT (dose monitoring) + nursing + technologists

---

Radiation biology: deterministic (threshold + severity dose-dependent — skin, cataracts, sterility, fetal effects) vs stochastic (no threshold per LNT, probabilistic — cancer). Dose units (Gy, Sv). Pediatric + fetal more sensitive. ALARA — time + distance + shielding + justification. Occupational + public limits. Multidisciplinary.', NULL,
  'medium', 'procedures', 'review',
  'radiology', 'basic_science', 'procedures', 'adult',
  'BEIR VII; ICRP 103; NCRP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Radiation biology — deterministic vs stochastic effects + dose-response'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'PET physics — positron emission + annihilation + image reconstruction', '[{"label":"A","text":"No physics knowledge needed"},{"label":"B","text":"PET physics"},{"label":"C","text":"Discharge"},{"label":"D","text":"Single isotope"},{"label":"E","text":"X-ray equivalent"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** PET physics: (1) **Positron emission** — proton-rich isotopes (cyclotron or generator-produced): - Proton → neutron + positron (β+) + neutrino; - Examples: F-18 (110 min, FDG most common), Ga-68 (68 min generator), C-11 (20 min — local cyclotron only), N-13 (10 min), O-15 (2 min), Cu-64 (12 hours), Zr-89 (78 hours antibody); (2) **Annihilation**: - Positron travels short distance (1-5 mm — ''positron range'' — limits spatial resolution) — loses energy in tissue → encounters electron → annihilation; - Produces **two 511 keV photons** emitted in opposite directions (180° — back-to-back); (3) **Coincidence detection**: - **Ring of scintillation detectors** around patient (BGO, LSO, LYSO crystals); - Two photons detected within narrow time window (~ 4-6 ns ''coincidence window'') along same line of response (LOR); - **Time-of-flight (TOF) PET** — modern scanners (LSO/LYSO faster) — measures slight time difference between two photon arrivals → localizes annihilation event along LOR more precisely → improved image quality + lower noise; (4) **Image reconstruction**: - **Iterative reconstruction** (OSEM — ordered subset expectation maximization) — standard; - **Deep learning reconstruction** — emerging; - **Corrections**: attenuation (CT or transmission scan), scatter, random coincidences, decay; (5) **PET/CT (most common)** vs **PET/MRI**: - **PET/CT** — anatomic CT + functional PET co-registered; standard; - **PET/MRI** — better soft tissue contrast (brain, prostate, liver, pelvis), no radiation from CT; longer scan + cost + technical complexity; emerging — selected applications; (6) **Quantification**: - **SUV (standardized uptake value)** = tissue activity / (injected dose / body weight); semi-quantitative; affected by glucose, time, body composition; - **PERCIST 1.0** — response criteria; - **Total metabolic tumor volume (MTV)** emerging prognostic; (7) **Quality control**: - **Daily QC** — uniformity, sensitivity, cross-calibration; - **Periodic** — spatial resolution, energy resolution, image quality; - **NEMA standards** for performance characterization; (8) **Tracer preparation** — cyclotron production (F-18, C-11, N-13, O-15 — local) or generator (Ga-68); FDG synthesis automated; radio-pharmacy GMP; (9) **Patient preparation for FDG-PET**: - Fasting 4-6 hours (reduce blood glucose); - Glucose check (< 200 ideal); - Quiet + warm environment during uptake (~ 60 minutes) — reduces brown adipose tissue + muscle uptake; - Hydration to clear bladder; (10) **Patient + family education + radiation safety**: dose ~ 5-10 mSv per scan; close contact restrictions short-term post-injection; (11) **Multidisciplinary**: nuclear medicine + radiopharmacist + medical physics + technologists + radiation safety + clinical specialists

---

PET physics: positron + annihilation → 2 × 511 keV photons opposite. Coincidence detection in scintillation detector ring. TOF PET modern. Iterative reconstruction + attenuation correction. SUV semi-quantitative. PET/CT standard, PET/MRI emerging. F-18 cyclotron + Ga-68 generator. Patient prep + radiation safety. Multidisciplinary.', NULL,
  'medium', 'procedures', 'review',
  'radiology', 'basic_science', 'procedures', 'adult',
  'SNMMI PET Standards; NEMA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'PET physics — positron emission + annihilation + image reconstruction'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'CT scanner technology — multi-detector + dual-energy + photon-counting', '[{"label":"A","text":"Single detector best"},{"label":"B","text":"CT scanner technology evolution"},{"label":"C","text":"No technology evolution"},{"label":"D","text":"Discharge"},{"label":"E","text":"X-ray equivalent"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** CT scanner technology evolution: (1) **Conventional CT** (single-detector, axial step-and-shoot): - Historical first generation; - Slow, single slice at a time; (2) **Helical (spiral) CT**: - Continuous patient table movement + rotation → spiral data acquisition; - Faster acquisition + entire organ coverage; (3) **Multi-detector CT (MDCT)** — current standard: - **4, 8, 16, 32, 64, 128, 256, 320 slice scanners**; - Multiple detector rows acquire slices simultaneously; - **Sub-second rotation times** + ECG-gating for cardiac imaging; - **Isotropic resolution** (~ 0.5-0.6 mm) — high-quality multiplanar reformats (MPR), maximum intensity projection (MIP), volume rendering (VR), 3D printing; - **Wide detector** (256-320 slice) — entire heart or organ in single rotation (no helical artifact); cardiac CT, perfusion; (4) **Dual-energy CT (DECT)**: - Two different X-ray energies acquired (dual-source — Siemens; rapid kV switching — GE; dual-layer detector — Philips; sequential scans); - **Material decomposition** — different attenuation at different energies; - **Clinical applications**: - **Gout** — monosodium urate crystals identification (joint involvement); - **Renal stone composition** — uric acid vs calcium (treatment implications); - **Iodine maps** — perfusion, parenchymal enhancement, separation of iodine from calcified plaque or hemorrhage; - **Virtual non-contrast** (subtract iodine — save radiation, single-phase contrast study replaces multiphase non-contrast + contrast); - **Pulmonary perfusion** — surrogate for V/Q, ventilation imaging selective; - **Bone marrow** — edema, characterization; - **Reduced metal artifact**; (5) **Photon-counting CT (PCCT)** — newest technology (Siemens NAEOTOM Alpha FDA-cleared 2021, others coming): - **Detectors** directly count individual photons + measure energy (vs energy-integrating in conventional); - **Advantages**: superior spatial resolution (~ 0.2 mm), inherent dual-/multi-energy capability, lower noise, lower dose, better contrast resolution, K-edge imaging (different contrast agents); - **Clinical applications**: high-resolution chest (small airway, ILD), coronary (high heart rate without beta-blocker), MSK, advanced perfusion, multi-contrast imaging; - **Emerging adoption** + research; (6) **Iterative + AI reconstruction**: - **Iterative reconstruction** — reduces noise vs filtered back projection — enables lower dose; - **Deep learning image reconstruction (DLIR)** — emerging — superior image quality at lower dose; (7) **AI applications in CT**: - **Auto-positioning + protocol selection**; - **Auto-segmentation** of organs + lesions; - **Disease detection + triage** (LVO, PE, ICH, PTX, lung nodules); - **Quantification** (calcium scoring, lung nodule volume, BMD opportunistic, body composition); - **Dose monitoring + tracking**; (8) **Multidisciplinary**: radiology + medical physics + technologists + IT + administration + vendors

---

CT evolution: conventional → helical → MDCT (current standard, isotropic resolution) → dual-energy (gout, stones, iodine maps, virtual non-contrast) → photon-counting (newest — superior resolution + low dose + K-edge). AI + iterative reconstruction. Multidisciplinary.', NULL,
  'medium', 'procedures', 'review',
  'radiology', 'basic_science', 'procedures', 'adult',
  'AAPM + Siemens/GE/Philips Vendor Documentation', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'CT scanner technology — multi-detector + dual-energy + photon-counting'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Digital radiography — DR vs CR + image quality', '[{"label":"A","text":"No digital radiography"},{"label":"B","text":"Computed radiography (CR)"},{"label":"C","text":"Discharge"},{"label":"D","text":"Film equivalent"},{"label":"E","text":"Single technology"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Digital radiography: (1) **Historical evolution**: - **Film-screen radiography** — historical; - **Computed radiography (CR)** — photostimulable storage phosphor plates; imaging plate exposed → laser scanner reads → digital image; introduced 1980s-90s; - **Digital radiography (DR)** — flat-panel detectors (FPD); direct (selenium) or indirect (scintillator + photodiode array); current standard; (2) **DR types**: - **Indirect (scintillator-based)** — CsI scintillator converts X-rays to light → photodiode (most common); - **Direct (semiconductor)** — amorphous selenium directly converts X-rays to electrical signal; - **Wireless detectors** — flexibility; (3) **Advantages of DR over CR**: - **Faster image acquisition** (immediate display vs CR plate reading); - **Higher detective quantum efficiency (DQE)** — better image quality at lower dose; - **Better dose efficiency** — image guidance for technique optimization; - **Improved workflow**; - **Wireless options**; (4) **Image processing**: - **Window/level adjustment** — soft tissue, bone, lung windows; - **Edge enhancement, contrast enhancement**; - **Tomosynthesis** (extension of DR — multiple low-dose acquisitions at angles → reconstructed slices); used in chest, breast (DBT), MSK; (5) **DICOM**: standard format + metadata (above earlier Q on informatics); (6) **Quality**: - **DQE** (detective quantum efficiency) — ratio of squared signal-to-noise out / squared SNR in — measure of detector efficiency; higher = lower dose for same image quality; - **Spatial resolution** — limited by detector pixel size; lower than film but adequate for clinical; - **Contrast resolution** — superior to film; - **Dynamic range** — wide; window/leveling adjusts; (7) **Mobile + bedside DR** — ICU + ER imaging without patient transport; (8) **Fluoroscopy** + **angiography** — similar DR detectors for dynamic imaging; (9) **Image quality optimization**: - **kVp** (penetration, contrast); - **mAs** (quantity, dose); - **Distance** (geometric magnification, dose — inverse square); - **Collimation** (reduces scatter + patient dose); - **Grid** (reduces scatter — high contrast but more dose); - **Patient positioning** + cooperation; - **Anti-scatter techniques** (air gap, grid); (10) **Common artifacts**: - **Motion blur**, **rotation**, **double exposure**, **grid lines**, **dust on detector**, **clipping** (high signal); (11) **Workflow integration**: PACS + RIS + EHR + voice dictation + speech recognition + structured reporting (above earlier QI Q); (12) **Multidisciplinary**: radiology + technologists + medical physics + IT + administration + vendors

---

Digital radiography: DR (flat-panel detector — indirect CsI or direct selenium) replacing CR + film. Advantages: faster, higher DQE, lower dose, better workflow. Image processing + tomosynthesis. DQE + spatial + contrast resolution. Optimization (kVp, mAs, distance, collimation, grid). Multidisciplinary.', NULL,
  'easy', 'procedures', 'review',
  'radiology', 'basic_science', 'procedures', 'adult',
  'AAPM Digital Radiography Standards', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Digital radiography — DR vs CR + image quality'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Iodinated contrast pharmacology — composition + osmolarity + viscosity', '[{"label":"A","text":"No contrast knowledge"},{"label":"B","text":"Iodinated contrast pharmacology"},{"label":"C","text":"Single contrast type"},{"label":"D","text":"Discharge"},{"label":"E","text":"All contrast same"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Iodinated contrast pharmacology: (1) **Composition**: - **Triiodinated benzene ring** core with various substitutions; - **Ionic** (historical — high-osmolar contrast media, HOCM) — dissociate in solution; - **Non-ionic** (current standard — low-osmolar LOCM + iso-osmolar IOCM) — do NOT dissociate; (2) **Generations**: - **First (HOCM, ionic monomer)**: diatrizoate (Hypaque), iothalamate — high osmolarity (~ 2000 mOsm/kg), more adverse reactions; obsolete IV use except specific (oral, intracavitary); - **Second (LOCM, non-ionic monomer)**: iohexol (Omnipaque), iopamidol (Isovue), iopromide (Ultravist), ioversol (Optiray) — osmolarity ~ 600-800 mOsm/kg — current standard for most CT, angiography; - **Third (IOCM, non-ionic dimer)**: iodixanol (Visipaque) — iso-osmolar to plasma (290 mOsm/kg); reduces CIN risk in highest-risk patients per some evidence (not all RCTs); higher viscosity; (3) **Pharmacokinetics**: - IV bolus → extracellular distribution → renal excretion (glomerular filtration); - **Elimination half-life** ~ 1-2 hours (normal renal function); - **Renal failure** — markedly prolonged; - **No significant metabolism**; - **Excreted unchanged**; - **Negligible protein binding**; - **Does NOT cross intact BBB or placenta** significantly (some passage in placenta but limited); (4) **Adverse reactions** (above earlier Q on iodinated contrast): - **Allergic/anaphylactoid** — NOT IgE-mediated true allergy in most; complement + direct mast cell degranulation; - **CIN/PC-AKI** — multifactorial; - **Thyroid** — induce hyperthyroidism in autonomous nodules (Plummer, MNG) — Jod-Basedow phenomenon; - **Pheochromocytoma** — historical concern of hypertensive crisis with ionic — less with non-ionic; recommend alpha-blockade pre-procedure for known pheo; - **Extravasation** — usually conservative; large + at risk → compartment syndrome assessment; (5) **Premedication for prior reactions**: - Prednisone 50 mg PO at 13, 7, 1 hours pre + diphenhydramine 50 mg 1 hour pre (Lasser/Greenberger); - Methylprednisolone IV alternative; - Emergency rapid protocols (less evidence-based); - **Recent evidence + ACR Manual update**: premedication may reduce mild reactions but not severe — selected with shared decision-making; (6) **Contrast extravasation management**: - Small volume — observation, ice/elevation; - Large volume / arm function affected / signs compartment syndrome → surgical consultation; - Most extravasations resolve without sequelae; (7) **CT specific considerations**: - **Injection rate** — 3-5 mL/s typical for CT + CTA; up to 7-8 mL/s for cardiac/CCTA; - **Volume** — body weight-based (1-2 mL/kg typical for routine, less for pediatric, more for CTA); - **Concentration** — 300-400 mg I/mL options; higher concentration for fast injection in CTA; - **Timing** — empiric or bolus tracking (preferred for CTA — automated trigger based on attenuation in target vessel); (8) **Lactation**: continue breastfeeding (minimal transfer); (9) **Hold metformin** in CKD (above earlier Q); (10) **Multidisciplinary**: radiology + nursing + pharmacy + ED + nephrology + endocrinology

---

Iodinated contrast: triiodinated benzene. HOCM (ionic historical) → LOCM (non-ionic monomer, current) → IOCM (non-ionic dimer, iso-osmolar). Renal excretion. Adverse — allergic/anaphylactoid (NOT IgE in most), CIN, thyroid (Jod-Basedow). Premedication protocols. Extravasation management. CT injection parameters. Hold metformin CKD. Multidisciplinary.', NULL,
  'medium', 'procedures', 'review',
  'radiology', 'basic_science', 'procedures', 'adult',
  'ACR Manual on Contrast Media v10.3', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Iodinated contrast pharmacology — composition + osmolarity + viscosity'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Patient-centered radiology — health literacy + accessibility + cultural competence', '[{"label":"A","text":"Single approach"},{"label":"B","text":"Patient-centered radiology"},{"label":"C","text":"No accommodation"},{"label":"D","text":"Discharge"},{"label":"E","text":"X-ray sufficient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Patient-centered radiology: (1) **Health literacy considerations**: - Estimated 1 in 3 adults have limited health literacy; - Affects understanding of preparation instructions, results, follow-up; - **Strategies**: plain language, teach-back method, written materials at 5th-6th grade reading level, pictographs, video instructions, multiple modalities, repetition; (2) **Language barriers**: - **Professional medical interpreters** (in-person, telephonic, video) — NOT family members ideally (especially for informed consent, sensitive topics, children); - **Translated written materials**; - **Bilingual signage**; - Federal regulations (US — Title VI Civil Rights Act) require language access in federally funded healthcare; (3) **Cultural competence + humility**: - **Awareness** of cultural differences in health beliefs, decision-making, gender preferences (some cultures prefer same-gender providers/technologists), religious considerations (modesty during exams, fasting requirements, ritual cleanliness), end-of-life beliefs; - **Cultural humility**: lifelong learning + self-reflection vs static ''competence''; - **Family involvement** patterns vary; - **Disclosure of diagnosis** preferences (some cultures prefer family disclosure first); (4) **Accessibility**: - **Physical**: wheelchair ramps, accessible parking, transfer equipment, bariatric-capable equipment, accessible bathrooms, exam tables; - **Hearing impaired**: ASL interpreters, written communication, captioning; - **Visually impaired**: large print, braille, audio descriptions; - **Cognitive impairments**: simplified communication, support persons, sedation if needed; - **Autism spectrum**: sensory considerations (lighting, sound), routine + predictability, child life specialists; (5) **Cost + insurance navigation**: - **Financial counseling**; - **Charity care** programs; - **Sliding scale fees**; - **Bills + transparency**; - **Insurance pre-authorization** assistance; - **Imaging deserts** (rural, underserved) — mobile units, telehealth; (6) **Transportation barriers**: - Vouchers, partnerships with rideshare; - Mobile units for outreach; (7) **Trauma-informed care**: - Awareness of past trauma (sexual assault, war, medical trauma); - Choices + control during exam; - Trigger awareness (positioning, undressing, sounds); - Trauma-informed sedation discussions; (8) **LGBTQ+ inclusive care**: - **Pronouns + names** asked + used; - **Gender-affirming imaging** — transgender patients (e.g., breast imaging for trans women; reproductive imaging considerations); - **Confidentiality**; - **Training of staff**; (9) **Patient feedback**: surveys, focus groups, patient advisory councils — incorporate into improvement; (10) **Open Notes + patient portals**: - **21st Century Cures Act (US, 2021)** — patients have right to see most clinical notes + reports without delay; - **Implications for radiology**: report wording (patient-friendly + accurate), patients may see findings before physician contact, anxiety considerations, plain-language summaries; (11) **Multidisciplinary**: radiology + administration + patient advocacy + interpreters + social work + clergy + community liaisons + patients + families + DEI offices

---

Patient-centered radiology: health literacy (plain language, teach-back), language access (interpreters), cultural humility, accessibility (physical + sensory + cognitive), cost + transportation, trauma-informed, LGBTQ+ inclusive, Open Notes patient portals (21st Century Cures Act). Patient feedback. Multidisciplinary.', NULL,
  'easy', 'procedures', 'review',
  'radiology', 'ems_mgmt', 'procedures', 'adult',
  'ACR Patient + Family-Centered Care; Joint Commission', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Patient-centered radiology — health literacy + accessibility + cultural competence'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Health disparities + equity in radiology access + outcomes', '[{"label":"A","text":"No disparities exist"},{"label":"B","text":"Health equity in radiology"},{"label":"C","text":"Discharge"},{"label":"D","text":"Single approach"},{"label":"E","text":"Equal access universal"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Health equity in radiology: (1) **Disparities in imaging access**: - **Geographic**: rural + medically underserved areas — fewer scanners, longer wait times, less subspecialty; - **Socioeconomic**: cost barriers, insurance + uninsured, time off work, transportation; - **Racial + ethnic minorities**: documented underuse of screening (mammography, lung cancer screening, colon cancer, CT for stroke); - **Gender**: women historically underdiagnosed in cardiac, less aggressive workup; - **Age**: ageism — elderly underscreened; pediatric specialized care less available; - **Disability**: physical + cognitive barriers; - **Language**: barriers to scheduling, understanding instructions; - **Insurance**: prior authorization barriers, formulary restrictions, narrow networks; (2) **Disparities in outcomes**: - **Cancer outcomes** worse for minorities (later stage at diagnosis, higher mortality) — partly explained by screening + access disparities; - **Stroke outcomes** — disparities in tPA + thrombectomy access; - **Trauma outcomes** — rural mortality higher; - **Maternal mortality** — Black women 3-4× higher in US; imaging access disparities contribute; (3) **AI bias concerns**: - **Training data** disproportionately from certain populations (especially white men in some datasets); - **Performance variation** by race, age, sex documented for some models; - **Need for diverse training datasets + validation across populations**; - **Algorithm transparency + auditing**; - **Equitable benefit distribution**; (4) **Initiatives to address disparities**: - **Universal screening recommendations + insurance coverage** (e.g., Affordable Care Act expanded preventive coverage including mammography in US); - **Community outreach + mobile units**; - **Patient navigation programs**; - **Tele-radiology + tele-stroke** to underserved; - **Community health workers**; - **Lay screenings** + education campaigns; - **Free clinics + safety net hospitals**; - **Cost transparency**; (5) **Workforce diversity**: - **Diversity in radiology workforce** — historically lacking; - **Pipeline programs** (URM in medicine); - **Faculty + leadership diversity** → role models + culturally concordant care; - **Implicit bias training**; (6) **Research + measurement**: - **Disaggregate data** by race, ethnicity, language, sex, gender, income, geography — measure disparities, target interventions; - **Equity dashboards** in QI; - **Patient-reported outcomes** + experience measures by demographic; (7) **Global health considerations**: - **Imaging deserts** worldwide — low-income countries severe shortages; - **WHO + RAD-AID + IAEA** initiatives; - **Sustainable equipment** (refurbished, low-power, less infrastructure-dependent); - **Workforce training programs**; - **Tele-radiology + AI** for under-resourced settings; (8) **Climate + environmental justice**: - Disadvantaged communities often have worse environmental exposures (air pollution → lung disease, cancers); - Imaging burden + access intersect; (9) **Health policy advocacy**: - **ACR + RSNA + societies** advocate for equitable coverage + access; - **Loan forgiveness** for underserved area service; - **Reimbursement reform** for screening + appropriate use; (10) **Multidisciplinary + community**: radiology + public health + primary care + community partners + patients + policy + research + administration + IT + workforce development

---

Health equity radiology: disparities in geographic, SES, racial/ethnic, gender, age, disability, language, insurance access + outcomes. AI bias concerns. Interventions — coverage, outreach, navigation, tele-radiology, workforce diversity. Disaggregate data + measure. Global health (WHO/RAD-AID). Policy advocacy. Multidisciplinary + community.', NULL,
  'medium', 'procedures', 'review',
  'radiology', 'ems_mgmt', 'procedures', 'adult',
  'ACR Health Equity; RSNA Diversity + Inclusion', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Health disparities + equity in radiology access + outcomes'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Quality measures + MIPS + JCAHO reporting in radiology', '[{"label":"A","text":"No quality reporting"},{"label":"B","text":"Quality reporting in radiology"},{"label":"C","text":"Discharge"},{"label":"D","text":"Single measure"},{"label":"E","text":"Quality unimportant"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Quality reporting in radiology: (1) **CMS MIPS (Merit-based Incentive Payment System)** — US value-based payment: - **Four categories**: Quality (30%), Promoting Interoperability (25%), Improvement Activities (15%), Cost (30%); - **Radiology-specific measures**: appropriate imaging utilization, dose monitoring, structured reporting, critical findings communication, follow-up of incidental findings, peer review participation; - **Performance scores** affect Medicare payments (+/− adjustments); (2) **Joint Commission accreditation**: - Standards for hospital + healthcare organizations; - Radiology-relevant: patient safety, infection control, medication management, performance improvement, leadership, environment of care; - **National Patient Safety Goals (NPSGs)** updated annually — relevant to radiology: patient identification, communication of critical results, sentinel events; - **Survey process** — every 3 years + complaint-based; (3) **ACR accreditation programs**: - Modality-specific (CT, MR, US, mammography MQSA, nuclear medicine, radiation oncology); - Facility + equipment + personnel + protocols + image quality + dose + QC; - Voluntary but increasingly required by payers; (4) **National Radiology Data Registry (NRDR)** — ACR: - Multiple subregistries — CTC, DIR (Dose Index Registry), NMD (Nuclear Med), GRID (general), Lung Cancer Screening, IR, NaF/PSMA; - Benchmarking + quality improvement + research; (5) **Dose monitoring + Image Wisely/Image Gently**: - **DICOM dose reporting** automated; - **Dose tracking software** (Radimetrics, DoseWatch, etc.); - **Patient + cumulative dose tracking**; - **Outlier identification + protocol optimization**; (6) **Peer review**: RADPEER + similar (above earlier Q); (7) **Patient safety + sentinel events**: - **Sentinel event reporting** (Joint Commission) — root cause analysis required; - **Near-miss reporting** — voluntary, learning culture; - **Common radiology sentinel events**: wrong-site/patient/procedure, contrast extravasation, MRI safety events (projectiles, burns), medication errors, sedation events, critical findings communication failures; (8) **Quality dashboards**: - **Real-time analytics** — turnaround time, appropriate use, dose, recall rates, peer review concordance, patient satisfaction; - **Department, facility, network, national benchmarks**; - **Drive continuous improvement**; (9) **Cost + appropriateness**: - **PAMA (Protecting Access to Medicare Act)** mandates use of clinical decision support (CDS) for advanced imaging — requires AUC (Appropriate Use Criteria) consultation at point of order in US Medicare; - **Choosing Wisely** + ACR Appropriateness Criteria as references; - **Imaging stewardship** initiatives; (10) **Patient experience + outcomes measures**: - **Press Ganey + similar surveys**; - **NPS (net promoter score)** + comments; - **Patient-reported outcomes (PROs)**; (11) **Equity measures + disaggregation** (above Q) — emerging requirement; (12) **Multidisciplinary**: radiology + administration + quality + medical physics + IT + nursing + technologists + risk management + finance + compliance

---

Radiology quality reporting: MIPS (Quality + Interoperability + Improvement + Cost), Joint Commission + NPSGs, ACR accreditation, NRDR + DIR, dose monitoring (Image Wisely/Gently), peer review (RADPEER), sentinel events + RCA, dashboards, PAMA AUC, patient experience + PROs, equity measures. Multidisciplinary.', NULL,
  'easy', 'procedures', 'review',
  'radiology', 'ems_mgmt', 'procedures', 'adult',
  'CMS MIPS; ACR; Joint Commission', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Quality measures + MIPS + JCAHO reporting in radiology'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Medical malpractice + risk management in radiology', '[{"label":"A","text":"No malpractice concerns"},{"label":"B","text":"Medical malpractice in radiology"},{"label":"C","text":"Discharge"},{"label":"D","text":"Single approach"},{"label":"E","text":"Defensive medicine always"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Medical malpractice in radiology: (1) **Common malpractice claims in radiology**: - **Failure to diagnose** (most common — missed/delayed diagnosis): - Breast cancer (often delayed mammography Dx); - Lung cancer (missed nodules — Fleischner non-adherence; failure to follow up incidentals); - Fractures (subtle, satisfaction of search); - Vascular pathology (PE, AAA); - Other cancers (colorectal CTC, pancreatic, renal); - **Communication failures** — critical findings not communicated, incidental findings not followed up; - **Procedure-related** — IR complications, contrast reactions; - **Wrong site/patient/procedure**; - **Radiation overexposure** — historical concerns less now; - **Patient safety events** in radiology (above QI Q); (2) **Elements of malpractice (negligence)**: - **Duty** of care established (physician-patient relationship); - **Breach** of standard of care; - **Causation** (direct + proximate) — breach caused harm; - **Damages** — actual injury (economic, non-economic, punitive); (3) **Standard of care**: - **Reasonable + prudent radiologist** in similar circumstances; - **Evidence-based + society guidelines** (ACR Appropriateness, Fleischner, BI-RADS, Lung-RADS, etc.); - **Expert testimony**; - **Local + community + national standards**; (4) **Risk mitigation strategies**: - **Thorough + accurate reports** — clear, structured, evidence-based; - **Appropriate recommendations** — specific follow-up; - **Critical findings communication** with documentation; - **Incidental findings tracking systems** (above Q); - **Peer review** participation; - **Continuing education** — current standards; - **Subspecialty consultation** when needed; - **Adequate clinical information** on requisitions; - **Comparison with priors**; - **Tumor board + multidisciplinary** involvement for complex cases; - **Informed consent** for procedures; - **Documentation** thorough + timely; (5) **Apology + disclosure programs**: - **Communication and Resolution Programs (CRPs)** — early disclosure, apology, explanation, compensation when error caused harm; - **Just culture** + reducing defensive medicine; - **Patient-centered approach** to adverse events; - Some states have ''apology statutes'' protecting from use as admission; (6) **Defensive medicine**: - Imaging tests ordered to mitigate perceived legal risk vs clinical benefit; - Estimated 10-20% of imaging utilization; - Contributes to healthcare costs + radiation exposure; - **Choosing Wisely** counters defensive medicine with evidence-based de-implementation; (7) **Insurance + coverage**: - **Professional liability insurance** — required; - **Tail coverage** for changing positions/retirement; - **Premium variation** by specialty (IR + interventional generally higher); (8) **Reporting + learning**: - **Hospital risk management** involvement; - **Root cause analysis** for adverse events; - **System improvements** vs individual accountability; - **National Practitioner Data Bank** reporting for settled cases (US); (9) **Tort reform debates** + state variations; (10) **Multidisciplinary**: radiology + administration + risk management + legal + medical staff + insurance + patient safety + quality + clinical specialists

---

Radiology malpractice: failure to diagnose (breast, lung, fractures, vascular), communication failures, procedure complications. Elements — duty + breach + causation + damages. Risk mitigation — thorough reports, critical findings, tracking, peer review, CME. Apology programs. Defensive medicine vs Choosing Wisely. Just culture. Multidisciplinary.', NULL,
  'medium', 'procedures', 'review',
  'radiology', 'ems_mgmt', 'procedures', 'adult',
  'ACR Risk Management; RSNA Malpractice', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Medical malpractice + risk management in radiology'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Continuing medical education + ABR MOC + lifelong learning in radiology', '[{"label":"A","text":"No CME needed after training"},{"label":"B","text":"Lifelong learning + certification"},{"label":"C","text":"Discharge"},{"label":"D","text":"Single approach"},{"label":"E","text":"Static knowledge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Lifelong learning + certification: (1) **ABR (American Board of Radiology) initial certification**: - **Pathway**: medical school → residency (4 years diagnostic radiology) → fellowship optional → ABR exams (Core Exam after 3rd year residency, Certifying Exam after 4th year + practice transition); - **Subspecialty certifications** — neuroradiology, MSK, pediatric, IR (now separate primary certification), nuclear medicine; (2) **MOC (Maintenance of Certification)** — continuous: - **Component 1**: Professional standing (active license, hospital privileges, peer review participation); - **Component 2**: Lifelong learning (CME credits — minimum 75/3 years including ABR-designated SAMs); - **Component 3**: Cognitive expertise (Online Longitudinal Assessment — OLA — replaced previous high-stakes exam; questions delivered weekly with feedback); - **Component 4**: Practice quality improvement — participation in QI projects; (3) **CME (Continuing Medical Education)**: - **Categories**: Category 1 (formal accredited — conferences, journal articles, online courses, hospital grand rounds); Category 2 (informal — reading, teaching, mentoring); - **Self-Assessment Modules (SAMs)** for ABR — interactive learning with questions; - **Annual requirements** vary by state license (typically 25-50 hours/year); (4) **Subspecialty + advanced training**: - **Fellowships** typically 1-2 years (neuro, MSK, pediatric, breast, body, cardiothoracic, abdominal, IR, nuclear); - **Mini-fellowships + intensive courses** for transitions or new techniques; - **AI + informatics** training emerging — separate fellowships; - **Global health + leadership + research** tracks; (5) **Modes of learning**: - **Traditional**: conferences (RSNA, ACR, ARRS, regional, subspecialty), journal articles + reviews, textbooks, case conferences; - **Modern digital**: online courses (RSNA, ACR Learning Center, STATdx, Radiopaedia, others), podcasts, webinars, social media (#RadEdu, #RadTwitter), apps (radiology cases, anatomy); - **Simulation + cadaver labs** for procedures; - **Peer learning** + tumor boards (above); - **Just-in-time learning** at point of care (PACS-integrated decision support); (6) **Research + scholarly activity** — clinical trials, retrospective studies, case reports, education research; (7) **Teaching + mentoring** — residency + medical school + fellow training; precepting; CME presentation; (8) **Professional networks** — societies (ACR, RSNA, subspecialty), regional chapters, conferences; (9) **Wellness + work-life integration** (above QI Q on burnout); (10) **Career evolution + paths**: clinical, academic, leadership, industry, consulting, global health, AI/informatics, entrepreneurship; (11) **Specific evolving areas requiring ongoing learning**: - **AI + machine learning** in radiology; - **New imaging modalities** (PCCT, PET/MRI, theranostics); - **Genomics + precision medicine**; - **Equity + cultural competence**; - **Communication + patient-centered care**; - **Health policy + economics**; (12) **Multidisciplinary** — radiology + medical education + administration + IT + societies + peers + colleagues

---

Lifelong learning radiology: ABR MOC (4 components — standing, learning, OLA assessment, QI). CME + SAMs. Subspecialty fellowships + advanced training. Multiple modes (traditional + digital). Teaching + research. Professional networks. Evolving areas — AI, PCCT, theranostics, equity. Multidisciplinary.', NULL,
  'easy', 'procedures', 'review',
  'radiology', 'ems_mgmt', 'procedures', 'adult',
  'ABR + ACGME + RSNA; ACR Lifelong Learning', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Continuing medical education + ABR MOC + lifelong learning in radiology'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Disaster preparedness + mass casualty events in radiology', '[{"label":"A","text":"No preparedness needed"},{"label":"B","text":"Disaster preparedness in radiology"},{"label":"C","text":"Discharge"},{"label":"D","text":"Single specialty"},{"label":"E","text":"Routine only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Disaster preparedness in radiology: (1) **Disasters affecting healthcare**: - **Natural**: earthquakes, hurricanes, tornadoes, floods, wildfires, pandemics (COVID-19 pivotal lessons); - **Man-made**: mass shootings, bombings, industrial accidents, transportation crashes, terrorism (CBRN — chemical, biological, radiological, nuclear), cyberattacks (ransomware affecting hospital systems including PACS); - **Healthcare crises**: surge events, supply shortages, staffing crises; (2) **Hospital incident command system (HICS)**: - Standardized command structure during emergencies; - Roles: Incident Commander, Operations, Planning, Logistics, Finance; - Radiology leadership integration; (3) **Surge capacity planning**: - **Imaging surge** — increased trauma volume, COVID respiratory imaging; - **Expanded scanner availability** — extended hours, mobile units; - **Staffing surge** — call-back protocols, mutual aid agreements; - **Tele-radiology** for surge interpretation capacity; - **Modified protocols** for efficiency (e.g., COVID — focused chest CT, US for triage); - **Decompression** of routine to prioritize emergent; (4) **Radiation emergencies (CBRN — R)**: - **Radiological dispersal devices (''dirty bombs'')**, nuclear reactor accidents, medical radiation source loss; - **Triage + decontamination** before imaging when possible; - **Imaging** rarely needed acutely (clinical management); - **Internal contamination** assessment — bioassay, whole-body counters (specialized centers); - **Treatment**: KI (potassium iodide) for I-131 thyroid blockade (within 4 hours best), DTPA (chelation for Pu, Am), Prussian blue (Cs-137 thallium); - **Long-term cancer surveillance** in exposed populations; (5) **Pandemic preparedness (post-COVID lessons)**: - **Infection control** in imaging (PPE, equipment cleaning between patients, plexiglass barriers, scheduling, isolation rooms); - **Modified protocols** (CT chest for COVID screening initially; modified workflow); - **Staff health + safety**; - **PPE supply** + alternative imaging strategies; - **Mental health** of healthcare workers — pandemic burnout; - **Telehealth + tele-radiology** expansion; - **Equity** during shortages; (6) **Mass shooting + bombing response**: - **Multiple trauma victims** — surge protocols; - **Penetrating + blast injury** imaging — high CT volume; - **Damage control** + serial imaging; - **Mental health** of patients + responders + community; (7) **Cybersecurity in radiology**: - **Ransomware attacks** on hospitals — PACS + EHR unavailability; - **Downtime procedures** — paper workflows, hard-copy films, manual scheduling; - **Backup systems + data redundancy**; - **Staff training** on phishing + cyber hygiene; - **Incident response plans**; (8) **Training + drills**: - **Regular simulations** + tabletop exercises; - **Multi-agency coordination** drills; - **Lessons learned** + updates after incidents; (9) **Mutual aid + regional networks**: - **Sharing resources** across institutions during surges; - **MOUs (memoranda of understanding)** + pre-established agreements; - **National Disaster Medical System (NDMS)** in US; (10) **Climate-related preparedness** — increasing weather extremes — infrastructure resilience, backup power, water access, supply chains; (11) **Multidisciplinary**: radiology + emergency management + ED + critical care + administration + IT + security + facilities + public health + government + community + media

---

Disaster preparedness: natural + man-made + healthcare crises. HICS structure. Surge capacity (imaging, staffing, tele-rad). Radiation emergencies (KI, DTPA, Prussian blue). Pandemic preparedness (COVID lessons). Mass casualty trauma response. Cybersecurity (ransomware, downtime procedures). Training + drills + mutual aid. Multidisciplinary.', NULL,
  'medium', 'procedures', 'review',
  'radiology', 'ems_mgmt', 'procedures', 'adult',
  'ASPR; FEMA + Joint Commission Emergency Management; AAPM', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Disaster preparedness + mass casualty events in radiology'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Geriatric imaging — frailty + comprehensive care + Choosing Wisely', '[{"label":"A","text":"Always full workup elderly"},{"label":"B","text":"Comprehensive geriatric assessment"},{"label":"C","text":"Discharge"},{"label":"D","text":"Single specialty"},{"label":"E","text":"Same as young"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Geriatric imaging: (1) **Comprehensive geriatric assessment** drives imaging decisions: - **Medical comorbidities** + medications + polypharmacy; - **Functional status** (ADLs, IADLs, mobility, vision, hearing); - **Cognitive** (MoCA, MMSE — preventing/detecting delirium); - **Psychosocial** (mental health, social support, financial); - **Frailty** (Fried criteria — weakness, slowness, weight loss, exhaustion, low activity; Clinical Frailty Scale — Rockwood) — independent predictor of outcomes; - **Goals of care + values** — what matters most; (2) **Choosing Wisely + Image Wisely for elderly**: - **Don''t screen for cancer when life expectancy < 5-10 years**: - **Mammography** — discontinue when life expectancy < 10 years; - **Colon cancer screening** — generally stop at 75 (USPSTF) or earlier if comorbid; - **Lung cancer screening** — stop at 80 per USPSTF; - **Cervical cancer screening** — stop at 65 if adequate prior; - **Prostate cancer screening** — stop at 70 generally; - **Avoid imaging that won''t change management**; - **Address goals of care first**; (3) **Imaging considerations in frail elderly**: - **Tolerance of procedures** — claustrophobia, ability to lie still, cooperation, sedation risks; - **Transport risks** — falls, delirium worsening, exposure changes; - **Contrast risks** — CIN higher; - **Renal function** — eGFR drops with age (CKD-EPI better than MDRD for elderly); - **Cumulative radiation exposure** less relevant in advanced age (long latency cancers); - **Alternative modalities** — US, MRI preferred when feasible (vs CT contrast + radiation); (4) **Common geriatric imaging scenarios**: - **Falls evaluation** — selective; head CT for select (anticoagulation, neuro deficit, head impact); spine + hip if symptomatic; underlying causes (cardiac, neurologic, orthostatic); - **Cognitive decline** — MRI brain (volumetric assessment, atrophy patterns; vascular changes), PET (FDG, amyloid, tau PET in research/selected); - **Acute change in functional status** — broad differential, sometimes UTI or other reversible causes — workup before imaging if non-specific; - **Failure to thrive** — careful workup, imaging targeted; - **Suspected malignancy** — careful workup considering life expectancy + treatment options; (5) **Delirium prevention + management**: - **Avoid sedation** when possible (use distraction, music, family presence); - **Quiet environment** + sleep-wake support; - **Minimize transports**; - **Multimodal pain control** (avoid benzodiazepines, opioids when possible); - **Hospital Elder Life Program (HELP)** principles; (6) **Polypharmacy + medication considerations**: - **Anticoagulant management** for procedures; - **Metformin hold for contrast**; - **Sedation risks** with benzodiazepines + opioids + anticholinergics; - **Beers Criteria** + STOPP/START for inappropriate medications; (7) **Goals of care + advance care planning**: - **Discussion before imaging** when prognosis limited; - **POLST/MOLST** + advance directives review; - **Substituted judgment** for incapacitated; - **Family meetings** when needed; - **Palliative care** integration concurrent; (8) **Multidisciplinary geriatric care team**: geriatrician + PCP + nursing + PT/OT + pharmacy + social work + family + radiology + medical/surgical specialists + palliative care + chaplaincy; (9) **Health systems approach**: - **Geriatric ED initiatives** (GEDA accreditation); - **ACE (Acute Care for Elders) units**; - **Geriatric peri-operative consultation**; - **Age-friendly health systems (4 Ms — Mentation, Mobility, Medication, What Matters)**

---

Geriatric imaging: CGA + frailty drives decisions. Choosing Wisely — discontinue screening when life expectancy < 5-10 years. Imaging tolerance + transport risks + contrast. Falls + cognitive decline + acute change scenarios. Delirium prevention. Polypharmacy + Beers. Goals of care + substituted judgment. Multidisciplinary geriatric team + age-friendly systems.', NULL,
  'medium', 'neurology', 'review',
  'radiology', 'integrative', 'neurology', 'adult',
  'AGS Choosing Wisely; Beers Criteria; AGS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Geriatric imaging — frailty + comprehensive care + Choosing Wisely'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Cardio-oncology — imaging + multidisciplinary cancer survivorship', '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Cardiotoxicity from cancer therapies — increasing cancer survivorship + recognized late effects"},{"label":"C","text":"No CV monitoring"},{"label":"D","text":"Discharge"},{"label":"E","text":"Refuse care"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cardio-oncology: (1) **Cardiotoxicity from cancer therapies — increasing cancer survivorship + recognized late effects**: - **Anthracyclines** (doxorubicin, daunorubicin, idarubicin, epirubicin) — dose-dependent dilated cardiomyopathy; cumulative dose; - **HER2-targeted** (trastuzumab) — reversible LV dysfunction; - **VEGF inhibitors** (bevacizumab, sunitinib, sorafenib) — hypertension, LV dysfunction, vascular events; - **Chest RT** — coronary disease (1-2 decades post-RT), valvular disease, restrictive cardiomyopathy, conduction system, pericardial; especially mantle field Hodgkin lymphoma, left breast (now reduced with modern techniques); - **Immune checkpoint inhibitors** — myocarditis (rare but fatal), pericarditis; - **TKIs** (BCR-ABL — imatinib, nilotinib — vascular events), BTK (ibrutinib — AFib + ventricular arrhythmias); - **5-FU + capecitabine** — coronary vasospasm, MI; - **Cyclophosphamide** — myocarditis, pericardial effusion; - **CAR-T cell therapy** — cytokine release syndrome with cardiac complications; - **Hormonal therapy** (ADT for prostate — metabolic syndrome; aromatase inhibitors — cardiac events); - **Radiation** to mediastinum, brain (HPA-axis hormonal, cardiovascular); (2) **Pre-treatment cardiovascular assessment**: - **Baseline ECG + echo (LVEF, GLS — global longitudinal strain)** for cardiotoxic regimens; - **Risk stratification** (age, comorbidities, prior CV disease, planned therapy); - **Optimize CV risk factors** (BP, lipids, DM, smoking, weight) — primary prevention; - **Patient education** + shared decision-making; (3) **During-treatment monitoring**: - **Serial echo + GLS** for anthracycline + HER2 — early subclinical dysfunction detected by GLS decline (>15% relative); - **Cardiac MRI** for indeterminate echo, tissue characterization, myocarditis with checkpoint inhibitors; - **Biomarkers** — troponin (sensitive for myocarditis with checkpoint inhibitors, anthracycline early injury), BNP/NT-proBNP; - **Cardiac CT or MRI** for chest RT planning + selected high-risk; - **Cardio-oncology consultation** for high-risk; (4) **Detection + management of cardiotoxicity**: - **Symptomatic LV dysfunction** — modify cancer therapy + GDMT for HF (ACEi/ARB, BB, MRA, SGLT2i); - **Asymptomatic LV dysfunction** — primary prevention with ACEi/ARB + BB; consider continuing cancer therapy with monitoring (case-by-case); - **Severe** — discontinue cardiotoxic agent + cardiology management; - **Myocarditis (checkpoint inhibitors)** — high-dose steroids + secondary immunosuppression (IVIG, infliximab, etc.); discontinue checkpoint inhibitor; (5) **Long-term survivorship imaging**: - **Late cardiac effects** of pediatric/young adult cancer survivors (anthracycline, chest RT) — screening with periodic echo, BMP/NT-proBNP, lipids; CMR + coronary imaging selectively per **COG (Children''s Oncology Group) Long-term Follow-up Guidelines** + adult survivorship guidelines; - **Survivors of Hodgkin lymphoma** + breast cancer with mantle/chest RT — earlier coronary disease + valvular — screening; - **Health behavior counseling** — smoking, diet, exercise, weight; (6) **Cardio-oncology team — multidisciplinary**: - Cardio-oncologist (cardiologist with cardio-oncology expertise) + medical oncologist + radiation oncologist + cancer survivorship + imaging (echo, CMR, nuclear) + cardiac surgery + electrophysiology + nursing + pharmacy + psychology + nutrition + exercise physiology; (7) **Comprehensive cancer survivorship care** beyond cardio-oncology: - **Second cancers** (treatment-related); - **Endocrine effects** (hypogonadism, thyroid, fertility, growth, osteoporosis); - **Cognitive effects** (''chemo brain''); - **Psychosocial** (depression, anxiety, PTSD, fear of recurrence); - **Pain + neuropathy**; - **Lymphedema**; - **Fatigue**; - **Return to work + life**; (8) **Personalized risk + benefit** — informed decision-making for new + ongoing therapies

---

Cardio-oncology: cardiotoxicity from chemo (anthracyclines), HER2, VEGF, checkpoint inhibitors (myocarditis), chest RT (coronary + valvular). Pre-treatment + during-treatment monitoring (echo + GLS, CMR, biomarkers). Cardio-oncology team multidisciplinary. Long-term survivorship — COG follow-up + screening. Comprehensive survivorship beyond CV. Multidisciplinary.', NULL,
  'hard', 'cardiovascular', 'review',
  'radiology', 'integrative', 'cardiovascular', 'adult',
  'ESC + ACC Cardio-Oncology; COG Survivorship', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Cardio-oncology — imaging + multidisciplinary cancer survivorship'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'End-of-life imaging in advanced cancer — palliative goals + hospice', '[{"label":"A","text":"Always image at end-of-life"},{"label":"B","text":"End-of-life imaging considerations"},{"label":"C","text":"Discharge"},{"label":"D","text":"Single specialty"},{"label":"E","text":"X-ray sufficient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** End-of-life imaging considerations: (1) **Imaging philosophy in end-of-life care**: - **Less is often more** — only image when results will change management consistent with patient values; - **Symptom-driven** vs surveillance-driven; - **Avoid imaging cascade** for asymptomatic findings; - **Patient + family centered**; (2) **When imaging is appropriate at end-of-life**: - **Pain assessment** — fracture, bone mets requiring palliative RT, abscess, spinal cord compression (still surgical/RT emergency); - **Mechanical issues** — biliary obstruction (PTBD, stenting if appropriate), ureteric obstruction, GI obstruction (stent vs surgery vs comfort), airway obstruction; - **Acute symptoms** — abdominal pain (ruling out treatable cause vs cancer progression), dyspnea (PE, effusion, infection, progression); - **Treatment planning** for specific interventions (e.g., palliative RT for bone mets — needs imaging for planning); - **Decompression procedures** by IR (above) — biliary, urinary, drainage of effusions/ascites; (3) **When imaging is generally NOT helpful**: - **Surveillance scans** for incurable cancer when patient on best supportive care + not changing treatment; - **Workup of new symptoms** with broad differential when treatment options exhausted; - **Pre-procedure imaging** when patient declining intervention; - **Asymptomatic findings** monitoring; - **Pre-treatment scans** for therapies no longer aligned with patient goals; (4) **Decision-making process**: - **Goals of care discussion** — frequent updates as situation evolves; - **Substituted judgment** for incapacitated; - **Shared decision-making** — patient + family + clinicians; - **Documentation** of rationale; - **Ethics committee** for difficult cases; (5) **Hospice considerations**: - **Hospice eligibility** — prognosis < 6 months in usual course of disease + patient/family acceptance of comfort focus; - **Hospice benefit** restricts certain interventions (chemo, RT often not covered; some palliative procedures allowed by some hospices); - **Imaging in hospice** rarely indicated — focus on comfort; - **Outpatient palliative care** vs hospice transition timing — important continuum; (6) **Specific palliative imaging interventions** (when consistent with goals): - **Palliative RT for bone mets pain** — single fraction 8 Gy effective (RTOG 9714) — minimal imaging needed; - **Palliative chemo response** — limited surveillance imaging if not changing treatment decisions; - **Drainage procedures** — IPC + nephrostomy + biliary drainage — quality of life + symptom relief (above earlier Q); - **Vertebroplasty / kyphoplasty** for painful compression fractures (above); - **Celiac plexus block** for pancreatic cancer pain (above); - **Ablation** for painful bone metastases; - **Embolization** for hemorrhage; (7) **Communication with patients + families about imaging at end-of-life**: - **Plain language** about expected information from imaging + how it will change care; - **Anticipatory grief** + concerns + fears; - **Cultural + spiritual considerations**; - **''Watching for'' specific symptoms** that would prompt imaging; - **Reassurance about not abandoning** — continued symptom focus + palliative care; (8) **Caregiver support**: - **Communication + decision-making support**; - **Bereavement** services for family; - **Family meetings** + multidisciplinary involvement; (9) **Quality measures**: - **Late-term chemotherapy** (within 2 weeks of death) — avoid; - **Late ICU admissions** + invasive procedures end-of-life — measure for QI; - **Hospice timing** — not too late; - **Documentation of goals discussions**; (10) **Multidisciplinary**: palliative care + medical oncology + radiology + IR + radiation oncology + hospice + chaplaincy + social work + nursing + ethics + family + patient

---

End-of-life imaging: image only when results change management consistent with goals. Appropriate — pain, mechanical issues, palliative procedure planning. NOT helpful — surveillance for incurable cancer, asymptomatic findings. Goals of care + shared decision-making. Hospice considerations. Specific palliative interventions OK if aligned. Caregiver communication. Quality measures. Multidisciplinary.', NULL,
  'medium', 'hemato_onco', 'review',
  'radiology', 'integrative', 'hemato_onco', 'adult',
  'ASCO + AAHPM; NCCN Palliative Care', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'End-of-life imaging in advanced cancer — palliative goals + hospice'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'AI in radiology — ethics + integration + bias + future', '[{"label":"A","text":"AI replaces radiologists"},{"label":"B","text":"AI in radiology — ethics + integration"},{"label":"C","text":"No AI in radiology"},{"label":"D","text":"Single approach"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** AI in radiology — ethics + integration: (1) **Current AI applications**: - **Image acquisition + reconstruction**: faster MRI, lower-dose CT (DLIR), motion correction, denoising; - **Detection + triage**: LVO, ICH, PE, pneumothorax, pulmonary nodules, mammography, bone fractures — many FDA-cleared; - **Quantification**: segmentation (organs, tumors), volumetry, calcium scoring, BMD opportunistic, body composition, perfusion analysis (RAPID); - **Workflow + prioritization**: worklist sorting (urgent flagged), study protocoling; - **Reporting + structured data extraction** (NLP); - **Quality + safety**: dose monitoring, error detection, peer review augmentation; (2) **Validation + regulatory**: - **FDA clearance pathways** (510(k), De Novo, PMA) — most via 510(k) substantial equivalence; - **Real-world performance** vs clinical trial — important to assess in target population; - **CONSORT-AI** + **SPIRIT-AI** reporting guidelines; - **Continuous learning systems** — regulatory framework evolving; - **Locked vs adaptive algorithms**; (3) **Bias + equity considerations** (above earlier disparities Q): - **Training data bias** — geographic, demographic, modality, scanner manufacturer; - **Performance variation** by demographic subgroups documented; - **Need for diverse training + external validation across populations**; - **Algorithm auditing**; - **Equitable distribution + access**; (4) **Ethical considerations**: - **Transparency + explainability** — ''black box'' vs interpretable AI; - **Responsibility + liability** — physician + developer + institution distribution; - **Informed consent** — should patients know AI used? - **Privacy + data sharing** — patient data for training; - **Beneficence vs maleficence**; - **Continuous monitoring + post-deployment surveillance**; (5) **Workflow integration**: - **PACS integration**; - **Alert fatigue** — too many AI flags counterproductive; - **Decision support** vs automation — physician in loop; - **Validation in local context** before deployment; - **Training + education** of radiologists + clinicians; (6) **Impact on radiology workforce**: - **Augmentation** vs replacement debates; - **Productivity + efficiency** improvements possible; - **Subspecialty + interpretation skills** still essential; - **New roles** — AI + informatics specialists, validators, developers; - **Education + training** updates needed; (7) **Healthcare economics**: - **Cost of AI systems**; - **Reimbursement** — CMS new payment categories for selected AI (CAD for CT colonography, others); - **Cost-effectiveness analyses**; (8) **Future directions**: - **Foundation models** + generative AI (large language models for reports, multimodal models combining imaging + EHR + genomics); - **Personalized medicine** integration; - **Real-time intra-procedural AI** (surgery, IR); - **Theranostic integration** (imaging-guided therapy planning); - **Patient-facing AI** (educational tools, communication, self-assessment); - **AI for clinical decision support** at point of order (appropriateness); (9) **Governance + societal**: - **AI ethics committees** institutional; - **Regulatory + legal frameworks** evolving (FDA, EU MDR, AIA); - **Professional society guidance** (ACR, RSNA, ESR Data Science Institute); - **Public engagement + trust**; - **Workforce displacement + retraining**; (10) **Multidisciplinary integration**: radiology + AI/informatics + IT + medical physics + administration + legal + ethics + patient advocates + research + clinical specialists + vendors + regulators + global health (for equitable access)

---

AI radiology: detection + triage + quantification + workflow + reconstruction. FDA clearance (mostly 510(k)). Bias + equity concerns. Ethics — transparency, liability, privacy, consent. Workflow integration. Augmentation vs replacement. Cost + reimbursement. Future — foundation models + multimodal + theranostic + clinical decision support. Multidisciplinary governance.', NULL,
  'medium', 'procedures', 'review',
  'radiology', 'integrative', 'procedures', 'adult',
  'ACR + RSNA + ESR AI Statements; FDA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'AI in radiology — ethics + integration + bias + future'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Sustainability + climate change in radiology', '[{"label":"A","text":"No environmental concerns"},{"label":"B","text":"Sustainability + radiology"},{"label":"C","text":"Discharge"},{"label":"D","text":"Single specialty"},{"label":"E","text":"Unrelated to medicine"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Sustainability + radiology: (1) **Healthcare environmental impact**: - Healthcare sector accounts for ~ 4-5% of global greenhouse gas emissions (US ~ 8.5%); - Radiology departments significant contributors (energy-intensive equipment, helium for MRI, contrast agents, disposables); - Climate change health impacts disproportionately affect vulnerable populations (heat, air quality, infectious disease patterns, food + water insecurity, displaced populations); (2) **Radiology-specific environmental considerations**: - **MRI** — high energy consumption, helium use (non-renewable resource — helium shortages periodic), specialized infrastructure; - **CT** — energy + radiation (radiation safety + environmental); - **Nuclear medicine** — radiopharmaceutical disposal, radioactive waste, cyclotron + reactor isotope supply chains; - **PET** — short-half-life isotopes, frequent transport; - **Contrast agents** — environmental persistence (gadolinium in waterways — emerging concern), iodinated contrast; - **Disposable supplies** — sterile drapes, gloves, plastics; - **PACS + IT infrastructure** — energy + e-waste; (3) **Mitigation strategies**: - **Energy efficiency** — modern scanners with eco modes, LED lighting, building efficiency, smart HVAC; - **Renewable energy** — solar, wind, geothermal for hospitals; - **Equipment lifecycle** — refurbishment + reuse vs new; donations to LMIC (low-middle income countries) for needed equipment; - **Reducing helium consumption** — modern ''zero boil-off'' MRI magnets; helium recovery systems; - **Sustainable contrast** — efforts to reduce waste, recover gadolinium; - **Reducing disposables** — reusable instruments where safe, recycling programs; - **Telework + tele-radiology** — reduced commuting + facility footprint; - **Reducing unnecessary imaging** (Choosing Wisely also has environmental benefit); - **Local + regional sourcing** of supplies + isotopes; (4) **''Lean + green'' approaches**: - Eliminating waste in operations also reduces environmental impact; - QI initiatives can drive sustainability; (5) **Climate health adaptation**: - **Disaster preparedness** (above earlier Q) — climate-related events increasing; - **Heat-related illness** + air pollution effects in imaging (cardiovascular, respiratory); - **Infectious disease** patterns shifting (vector-borne, fungal, etc.); - **Population displacement** + refugees → healthcare system pressure; - **Mental health** of climate change (''eco-anxiety''); (6) **Equity considerations**: - Climate change effects disproportionately on disadvantaged communities (Indigenous, low-income, communities of color, LMIC); - Imaging access + equity intersect; - Global health partnerships; (7) **Education + advocacy**: - **Sustainability curriculum** in radiology training; - **Professional society initiatives** — ACR, RSNA, ESR sustainability committees + statements; - **Research + measurement** of carbon footprint; - **Advocacy** for climate-conscious healthcare policy + funding; - **Community education** + patient advocacy; (8) **Personal + institutional choices**: - **Bicycle + transit commuting** + EV vehicles; - **Sustainable food** options; - **Reducing single-use** plastics; - **Engaging in policy + advocacy**; (9) **International cooperation**: - **WHO + UN climate + health agendas**; - **Healthcare without Harm** international organization; - **Sustainable healthcare** — emerging field; (10) **Future of sustainable radiology**: - **Net-zero healthcare** by 2050 targets (UK NHS leading, US joining via Office of Climate Change and Health Equity); - **Innovation** in low-carbon imaging; - **AI for efficiency** can also reduce environmental impact; - **Lifecycle assessment** of new technologies; (11) **Multidisciplinary**: radiology + administration + facilities + IT + sustainability office + public health + community + patients + vendors + policy + global health partners

---

Sustainability radiology: healthcare 4-5% global emissions. Radiology-specific — MRI energy + helium, contrast, disposables. Mitigation — efficiency + renewable + lifecycle + reducing unnecessary imaging + reusable. Climate health adaptation. Equity intersects. Education + advocacy. International cooperation. Net-zero targets. Multidisciplinary.', NULL,
  'medium', 'procedures', 'review',
  'radiology', 'integrative', 'procedures', 'adult',
  'Healthcare Without Harm; NHS Net Zero; ACR Sustainability', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Sustainability + climate change in radiology'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Global health + imaging in resource-limited settings', '[{"label":"A","text":"No global considerations"},{"label":"B","text":"Global health imaging"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Discharge"},{"label":"E","text":"Only domestic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Global health imaging: (1) **Imaging disparities globally**: - ~ 2/3 of world''s population lacks access to medical imaging (WHO + Lancet); - **Imaging deserts** — many LMIC have severe shortages of equipment + trained personnel; - **Radiation oncology** — even more severe disparities; - **Tele-radiology** + AI emerging as partial solutions; (2) **Burden of imaging-amenable diseases globally**: - **Trauma** (largest growing cause of death in young) — imaging critical; - **Maternal + child health** — US, basic radiology, MRI selective; - **Tuberculosis** — CXR central to diagnosis + screening; - **Cancer** — imaging crucial for diagnosis + staging + treatment guidance + response; cancer burden shifting to LMIC; - **Cardiovascular disease** — leading global cause of death; - **Infectious diseases** — HIV, parasitic, fungal; (3) **Initiatives + organizations**: - **WHO Essential Diagnostic Imaging (WHO Generic Essential Emergency Equipment List for primary level)** + **WHO Manual of Diagnostic Imaging** + **List of Priority Medical Devices**; - **Pan American Health Organization (PAHO)**; - **IAEA (International Atomic Energy Agency)** — radiation safety + medical physics + nuclear medicine; - **RAD-AID International** — long-term partnerships with LMIC institutions; equipment + training + tele-radiology + research; - **Radiology Without Borders**; - **Global Radiology + Imaging Initiative (GRII)**; - **Médecins Sans Frontières (MSF)** + similar organizations include imaging in emergency response; - **ISR (International Society of Radiology)** + ESR + RSNA + ACR global outreach committees; (4) **Sustainable approaches**: - **Equipment**: - **Refurbished equipment** donations (with appropriate vendor partnerships + maintenance); - **Low-cost + locally-appropriate** equipment design (sustainable in environment without reliable power, water, infrastructure); - **Mobile imaging units** for outreach; - **Solar-powered + battery-backed equipment**; - **Local maintenance + parts supply chain**; - **Personnel**: - **Twinning programs** — institution-to-institution long-term partnerships; - **Training local radiologists + technologists + medical physicists** — sustainable model; - **Tele-radiology** + tele-mentoring; - **AI-augmented diagnosis** for areas without radiologists; - **Subspecialty + advanced training** when foundation established; - **Standardized protocols + guidelines** adapted for local resources; (5) **Imaging in specific global health priorities**: - **Trauma + emergency** — life-saving imaging; - **Maternal health** — US for obstetric care + complications; - **Tuberculosis** — CXR (digital with AI augmentation emerging — e.g., qXR, CAD4TB tools — WHO endorsed); - **Cancer** — basic CT + MRI for staging + treatment, mammography for screening, US-guided biopsy; - **HIV + opportunistic infections** — CXR + CT for PCP, TB, etc.; - **Maternal-child** — US for pregnancy, congenital conditions; - **Disaster response** — emergency imaging capacity; (6) **AI in global health imaging**: - **Tuberculosis screening** (above); - **Diabetic retinopathy + other ophthalmology** (US-based, similar concepts); - **Maternal-fetal US** with AI guidance; - **Tele-radiology AI augmentation** for shortage settings; - **Bias considerations** — training data should include diverse populations; (7) **Pandemic preparedness lessons** — COVID highlighted need for global preparedness + cooperation; (8) **Equity + justice principles**: - **Avoid imposing** Western-centric models; - **Local leadership** + capacity building; - **Long-term partnerships** vs short-term trips; - **Cultural humility**; - **Community engagement**; (9) **Volunteering + careers**: - **Short-term medical missions** — debated value (some helpful, some criticized); - **Long-term partnerships** + careers in global health more sustainable; - **Academic global health programs**; - **Policy + research careers**; (10) **Multidisciplinary**: radiology + global health + public health + government + NGOs + local partners + community + WHO + IAEA + medical physics + nursing + technologists + vendors + funders + universities

---

Global health radiology: 2/3 world lacks access. Imaging-amenable diseases — trauma, TB, cancer, MCH, CVD. Initiatives — WHO + RAD-AID + IAEA + societies. Sustainable approaches — equipment + training + tele-radiology + AI (e.g., TB CXR AI). Twinning programs. Local leadership + cultural humility. Multidisciplinary global partnerships.', NULL,
  'medium', 'procedures', 'review',
  'radiology', 'integrative', 'procedures', 'adult',
  'WHO Essential Diagnostic Imaging; RAD-AID', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Global health + imaging in resource-limited settings'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Mental health + serious illness — imaging integration + holistic care', '[{"label":"A","text":"Ignore mental health"},{"label":"B","text":"Mental health in serious illness"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Discharge"},{"label":"E","text":"Mental + physical separate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mental health in serious illness: (1) **Mental health comorbidity in patients with serious medical illness**: - **Depression** ~ 25-40% in cancer, chronic disease; - **Anxiety** ~ 25-40%; - **PTSD** — in trauma survivors, ICU survivors, cancer patients; - **Adjustment disorders**; - **Suicide risk** elevated; - **Pre-existing mental illness** affecting medical care + adherence; (2) **Impact on imaging + procedures**: - **Anxiety + claustrophobia** — affecting MRI, prolonged CT, IR procedures (above QI Q); - **Pre-procedural anxiety** — informed consent, decision-making capacity; - **Adherence + follow-through** with recommended imaging + appointments; - **Pain perception + experience** — somatic + emotional components; - **Sedation considerations** — interactions with psychiatric medications; (3) **Screening + assessment**: - **PHQ-9** for depression; **GAD-7** for anxiety; **PHQ-2 + GAD-2** brief; **PC-PTSD-5** for PTSD; **Distress Thermometer** in cancer; - **Routine screening** in cancer + serious illness clinics; - **Awareness + identification** in imaging waiting areas; (4) **Integration of mental health in care**: - **Embedded mental health professionals** in oncology + serious illness clinics; - **Collaborative care models** (PCP + psychiatrist + care manager); - **Tele-mental health** expanding access; - **Peer support + support groups**; (5) **Treatment options**: - **Psychotherapy** — CBT (cognitive behavioral therapy), ACT (acceptance + commitment), mindfulness-based, supportive, problem-solving, narrative; - **Pharmacotherapy** — SSRIs/SNRIs (consider drug-drug interactions with chemo + serious illness meds), benzodiazepines (caution — sedation + falls + dependence); - **Complementary**: meditation, yoga, music therapy, art therapy, animal-assisted; - **Spiritual + chaplaincy** support; (6) **Imaging-specific anxiety + claustrophobia management**: - **Pre-procedural education**: clear explanation, what to expect, duration, what they can/cannot do (move, breathe, talk); - **Environmental modifications**: open MRI scanners, room dimming/lighting choices, music, eye masks, mirrors, prone vs supine; - **Companion present**; - **Distraction techniques**: music, audiobooks, virtual reality, breathing exercises, visualization; - **Pre-medication**: low-dose benzodiazepine (lorazepam, alprazolam) for selected — caution sedation, driving; - **Sedation/anesthesia** for severe or pediatric; - **Wider-bore scanners + shorter protocols** — modern improvements; (7) **Trauma-informed care** in imaging (above Q): - Awareness of past trauma (sexual abuse, military combat, accident, medical trauma); - Positioning, undressing, touch — explanation + choice + control; - **Avoidance of triggers** when possible; - **Recovery + debriefing** if triggered; (8) **Pediatric considerations**: - **Child life specialists** — preparation, play therapy, distraction; - **Parent presence** during exam; - **Caregiver mental health** support (parents, family); - **Developmentally-appropriate explanations**; (9) **Geriatric considerations** (above): - **Cognitive impairment + delirium** prevention; - **Reduce sedation**; - **Familiar caregivers**; - **Environmental simplification**; (10) **Communication of difficult diagnoses + findings**: - **SPIKES protocol** (above Q); - **Compassion + empathy**; - **Setting** — private, time, support persons; - **Cultural + spiritual considerations**; - **Follow-up + resources**; - **Mental health referral** when distress severe; (11) **Provider mental health + wellness** (above burnout Q) — caring for self enables caring for others; (12) **Multidisciplinary holistic care**: medical + mental health + spiritual + social work + family + community — radiology integrated into broader patient experience

---

Mental health + serious illness: high prevalence depression + anxiety + PTSD. Affects imaging tolerance + decision-making. Screen + integrate mental health. Imaging anxiety + claustrophobia management — environmental + behavioral + pre-medication + sedation. Trauma-informed + pediatric + geriatric considerations. SPIKES communication. Holistic multidisciplinary care.', NULL,
  'medium', 'neurology', 'review',
  'radiology', 'integrative', 'neurology', 'adult',
  'NCCN Distress Management; APA + APM Palliative', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Mental health + serious illness — imaging integration + holistic care'
  );

commit;

