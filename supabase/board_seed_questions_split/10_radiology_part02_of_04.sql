-- ===============================================================
-- หมอรู้ — Board seed: รังสีวิทยา (radiology) — part 2/4 (50 MCQs)
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
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี new-onset seizure — MRI พบ popcorn-appearance lesion with mixed signal (T2 hyperintense center, T2 hypointense rim — hemosiderin) without surrounding edema', '[{"label":"A","text":"AVM — embolize"},{"label":"B","text":"Cerebral cavernous malformation (cavernoma)"},{"label":"C","text":"Tumor — biopsy"},{"label":"D","text":"Stroke"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cerebral cavernous malformation (cavernoma): (1) **Imaging characteristic**: ''popcorn'' appearance — heterogeneous mixed-signal core (different ages of blood products on T1 + T2 — methemoglobin, deoxyhemoglobin), surrounding rim of hemosiderin (low signal on T2 + GRE/SWI — ''blooming''); **GRE / SWI ESSENTIAL** — most sensitive for hemosiderin + multiple lesions detection; (2) **Differential**: cavernoma (popcorn + hemosiderin rim, NO early enhancement), AVM (high flow, contrast enhancement, vascular nidus), hemorrhagic neoplasm (mass effect, edema), developmental venous anomaly (DVA — caput medusae, often co-exists with cavernoma), micro-hemorrhages of CAA (elderly, lobar, no popcorn appearance); (3) **DSA — typically negative** (low flow lesion) — distinguishes from AVM; (4) **Familial CCM** (KRIT1, CCM2, CCM3 mutations) — multiple lesions, autosomal dominant — genetic counseling; (5) **Hemorrhage risk**: 0.5-2% per year (untreated, supratentorial), higher in brainstem, prior hemorrhage, infratentorial location, deep venous drainage; (6) **Management**: - Asymptomatic incidental → observation + serial MRI; - **Seizures controlled with AED** + observation if surgically inaccessible; - **Surgical resection** for: recurrent symptomatic hemorrhage, drug-resistant epilepsy attributable to cavernoma, severe progressive neuro deficit, accessible location (avoid eloquent cortex/brainstem unless absolutely needed); - **SRS** controversial — not first-line, some role for inaccessible recurrent bleeders; (7) **Multidisciplinary**: neurology + neurosurgery + radiology + genetics if familial

---

Cavernoma: ''popcorn'' + hemosiderin rim on GRE/SWI. DSA negative (vs AVM). Familial CCM (multiple). Surgery for symptomatic accessible; SRS controversial. Multidisciplinary.', NULL,
  'medium', 'neurology', 'review',
  'radiology', 'clinical_decision', 'neurology', 'adult',
  'AHA Cavernoma Statement; Angioma Alliance Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี new-onset seizure — MRI พบ popcorn-appearance lesion with mixed signal (T2 hyperintense center, T2 hypointense rim — hemosiderin) without surrounding edema'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 40 ปี recurrent stroke + headache + cognitive decline — MRI พบ multiple infarcts in different vascular territories + segmental beading on MRA + CSF lymphocytic pleocytosis', '[{"label":"A","text":"Likely migraine"},{"label":"B","text":"Primary CNS vasculitis (PACNS) — imaging + workup"},{"label":"C","text":"Stroke - aspirin"},{"label":"D","text":"Discharge"},{"label":"E","text":"Single specialty"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Primary CNS vasculitis (PACNS) — imaging + workup: (1) **Imaging features**: multiple infarcts in different vascular territories (suggests systemic embolic source vs vasculitis if no cardiac source), segmental narrowing + dilatation (''beading'') on MRA/CTA/DSA — vessel caliber irregularity, gadolinium enhancement of vessel wall on high-resolution vessel wall MRI (modern technique — distinguishes from RCVS, atherosclerosis), parenchymal contrast enhancement (granulomatous form), microhemorrhages on SWI; (2) **DSA** gold standard for angiographic findings — but limited sensitivity (< 60%) for small-vessel PACNS, low specificity (atherosclerosis, RCVS, infectious vasculitis, vasospasm look similar); high-resolution vessel wall MRI helps differentiate (PACNS — concentric thickening + enhancement; RCVS — minimal/no wall enhancement; atherosclerosis — eccentric); (3) **Workup to exclude mimics**: - CSF — lymphocytic pleocytosis, elevated protein common in PACNS (helps distinguish from RCVS, atherosclerosis); - Serology — ANA, ANCA, RF, CCP, dsDNA, complement, cryoglobulins, HIV, syphilis (RPR), hepatitis serologies, ESR, CRP (PACNS — systemic markers usually normal!); - Echo + telemetry — exclude embolic source; - **Brain biopsy** — gold standard for PACNS diagnosis (granulomatous, lymphocytic, or necrotizing) but invasive; reserved for atypical / severe / progressive cases with negative workup; (4) **Differential**: RCVS (reversible cerebral vasoconstriction — thunderclap HA, postpartum, vasoactive substances, resolves in 1-3 months), systemic vasculitis with CNS involvement (GPA, EGPA, PAN, Behcet), infectious vasculitis (VZV, syphilis, TB), atherosclerosis, Moyamoya, lymphoma; (5) **Treatment** (if PACNS confirmed): high-dose steroids + cyclophosphamide induction (rituximab alternative), maintenance with MTX/azathioprine/MMF; (6) **Multidisciplinary**: rheumatology + neurology + neuroradiology

---

PACNS: multiple infarcts + beading on angiogram. High-res vessel wall MRI helps differentiate from RCVS. Brain biopsy gold standard. Steroids + cyclophosphamide. Exclude mimics. Multidisciplinary.', NULL,
  'hard', 'neurology', 'review',
  'radiology', 'clinical_decision', 'neurology', 'adult',
  'ACR Vasculitis Guidelines; AAN PACNS Review', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 40 ปี recurrent stroke + headache + cognitive decline — MRI พบ multiple infarcts in different vascular territories + segmental beading on MRA + CSF lymphocytic pleocytosis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'MRI brain sequences — แต่ละ sequence เหมาะกับ pathology ใด

คำถาม: characteristics + indications', '[{"label":"A","text":"Single sequence sufficient"},{"label":"B","text":"MRI brain sequences — clinical applications"},{"label":"C","text":"X-ray only"},{"label":"D","text":"CT only"},{"label":"E","text":"No imaging"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** MRI brain sequences — clinical applications: (1) **T1-weighted**: anatomy, fat bright, fluid (CSF) dark, gray matter darker than white matter; post-contrast (gadolinium) — enhancement reflects BBB breakdown (tumor, infection, demyelination active, vascular); (2) **T2-weighted**: pathology bright (edema, gliosis, demyelination, tumor); CSF bright; differentiate gray/white matter; (3) **FLAIR (Fluid Attenuated Inversion Recovery)**: suppresses CSF — periventricular + cortical lesions seen better than T2 (MS plaques, subarachnoid blood, infection); (4) **DWI (diffusion-weighted imaging)** + ADC map: restricted diffusion — bright DWI + dark ADC — acute ischemia (within minutes — hyperacute marker), abscess (pus restricts), hypercellular tumor (lymphoma, GBM, epidermoid — bright on DWI), early stroke; (5) **GRE (gradient echo) / SWI (susceptibility-weighted)**: blood products (hemosiderin, deoxyhemoglobin), calcification, iron — micro-hemorrhages (CAA, hypertensive, DAI), cavernoma, hemorrhagic stroke; SWI more sensitive than GRE; (6) **MR angiography (MRA)**: TOF (no contrast) — flow imaging; contrast-enhanced MRA (gadolinium); MR venography (MRV) for venous; (7) **MR perfusion (PWI)**: CBV, CBF, MTT — penumbra in stroke, tumor grading (high rCBV = high-grade glioma); (8) **MR spectroscopy (MRS)**: metabolites — NAA (neuronal), choline (cell turnover — increased in tumors), creatine (energy), lactate (anaerobic), lipid (necrosis); (9) **DTI (diffusion tensor)**: white matter tracts for surgical planning; (10) **Functional MRI (fMRI)**: BOLD signal — language + motor mapping pre-op

---

MRI sequences: T1 (anatomy + contrast), T2 (edema), FLAIR (CSF-suppressed), DWI (stroke + abscess + cellular tumor), GRE/SWI (hemorrhage), MRA (vessels), perfusion, spectroscopy, DTI, fMRI. Tailor sequences to question.', NULL,
  'easy', 'neurology', 'review',
  'radiology', 'basic_science', 'neurology', 'adult',
  'Radiology Textbook MRI Physics; ACR', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'MRI brain sequences — แต่ละ sequence เหมาะกับ pathology ใด

คำถาม: characteristics + indications'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hounsfield units (HU) on CT — typical values for brain pathology

คำถาม: HU value differences across tissues', '[{"label":"A","text":"No standard values"},{"label":"B","text":"Hounsfield Units (HU) — CT density values calibrated water = 0, air = -1000, dense bone = +1000+"},{"label":"C","text":"All tissues same HU"},{"label":"D","text":"Bone is negative HU"},{"label":"E","text":"Air positive HU"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hounsfield Units (HU) — CT density values calibrated water = 0, air = -1000, dense bone = +1000+: (1) **Brain CT typical HU values**: - Air: -1000; - Fat: -100 to -50; - Water/CSF: 0; - White matter: 22-32 HU (slightly lower than gray); - Gray matter: 32-44 HU; - Acute blood: 50-80 HU (hyperdense); - Subacute blood: 30-40 HU (isodense, easier to miss); - Chronic blood/old hemorrhage: 0-30 HU (hypodense); - Calcification: > 100-200+ HU; - Cortical bone: > 1000 HU; (2) **Clinical pearls**: - Hyperdense MCA sign — thrombus 70-90 HU vs normal vessel 35-50 HU; - Loss of gray-white differentiation in acute ischemia (gray matter HU drops toward white matter); - Acute ICH is hyperdense (clot retraction) — fresh blood; over days becomes isodense then hypodense (rim); - Subdural hematoma: acute hyperdense → subacute isodense (~ 1-3 weeks — easy to miss, look for mass effect) → chronic hypodense; mixed-density suggests acute on chronic or active bleeding; - Contrast extravasation in trauma — 80-200 HU dependent on phase; (3) **CT brain window**: brain window (level 35, width 80) for parenchyma; bone window for skull fractures; subdural window (level 75, width 200) for thin hyperdense SDH along skull

---

HU: water 0, air -1000, bone +1000. Brain parenchyma 20-40, acute blood 50-80, calcification > 100, fat negative. Subacute SDH isodense — easy to miss. Use windows appropriately.', NULL,
  'easy', 'neurology', 'review',
  'radiology', 'basic_science', 'neurology', 'adult',
  'Radiology Physics Fundamentals; ACR', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Hounsfield units (HU) on CT — typical values for brain pathology

คำถาม: HU value differences across tissues'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Functional MRI (fMRI) + diffusion tensor imaging (DTI) — applications in brain tumor pre-op planning', '[{"label":"A","text":"Plain X-ray sufficient"},{"label":"B","text":"Advanced MRI for neurosurgical planning"},{"label":"C","text":"No advanced imaging"},{"label":"D","text":"CT alone"},{"label":"E","text":"Bone scan"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Advanced MRI for neurosurgical planning: (1) **fMRI (BOLD signal — Blood Oxygen Level Dependent)**: detects changes in deoxyhemoglobin during neuronal activity; - **Task-based fMRI**: patient performs task (finger tapping, language) during scan — localizes motor cortex, language (Broca, Wernicke), visual areas; - **Resting-state fMRI**: networks (default mode, salience, attention) identified without task — useful when patient can''t cooperate; (2) **Clinical applications**: - Pre-op localization of eloquent cortex for tumor resection planning — maximizes safe resection extent while preserving function; - Pre-op for epilepsy surgery — language lateralization (alternative to Wada test), seizure focus characterization; - Stroke recovery monitoring; (3) **DTI (Diffusion Tensor Imaging)** + tractography: directionality of water diffusion along white matter tracts (anisotropic) — visualizes white matter pathways (corticospinal tract, arcuate fasciculus, optic radiations); (4) **Clinical applications DTI**: - Pre-op tract mapping — tumor relationship to corticospinal tract, language tracts, visual pathways; - Stroke/TBI — Wallerian degeneration assessment; - Connectome research; (5) **Integration with intraoperative**: fMRI/DTI fused with stereotactic neuronavigation + intraoperative awake mapping (direct cortical stimulation) = modern brain tumor surgery; (6) **Limitations**: BOLD signal altered near tumors (neurovascular uncoupling), patient cooperation needed for task-based, motion artifacts; (7) **Multidisciplinary**: neurosurgery + neuroradiology + neuropsychology + speech therapy

---

fMRI (BOLD) + DTI (tractography) for pre-op brain tumor planning — eloquent cortex + white matter tracts. Maximizes safe resection. Integrated with intraoperative awake mapping + neuronavigation.', NULL,
  'medium', 'neurology', 'review',
  'radiology', 'basic_science', 'neurology', 'adult',
  'Neurosurgical fMRI Standards; ASFNR Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Functional MRI (fMRI) + diffusion tensor imaging (DTI) — applications in brain tumor pre-op planning'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Gadolinium contrast — safety considerations + nephrogenic systemic fibrosis (NSF)', '[{"label":"A","text":"Always safe — no precautions"},{"label":"B","text":"Gadolinium-based contrast agents (GBCAs) — safety"},{"label":"C","text":"Discharge without screening"},{"label":"D","text":"Contraindicated in everyone"},{"label":"E","text":"Same as iodinated contrast"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Gadolinium-based contrast agents (GBCAs) — safety: (1) **NSF (nephrogenic systemic fibrosis)** — rare but severe fibrosing disorder of skin + organs in patients with severe renal impairment (eGFR < 30) exposed to GBCAs, especially older linear (non-ionic) agents (gadodiamide — Omniscan, gadoversetamide); (2) **Risk stratification by group**: - **Group I (high-risk linear)** — restricted in CKD; - **Group II (macrocyclic — stable)** — gadobutrol (Gadavist), gadoteridol (ProHance), gadoterate (Dotarem) — very low NSF risk, used preferentially; - **Group III (linear stable)**: gadoxetate (Eovist — liver-specific); (3) **ACR + Manufacturer recommendations**: screening for renal function (eGFR or GFR estimate) before GBCA in at-risk patients (CKD, dialysis, AKI, > 60 years, DM, HTN); macrocyclic agents (Group II) preferred — many institutions use only Group II; in dialysis patients on Group II → dialysis after exam may help clear contrast (does not eliminate NSF risk per recent guidelines but commonly practiced); (4) **Gadolinium retention in brain (dentate nucleus, globus pallidus)** — linear > macrocyclic; clinical significance uncertain but FDA warning 2017; preference for macrocyclic; (5) **Allergic reactions**: less common than iodinated CT contrast; treat similarly (epinephrine, antihistamine, steroids); premedication for known prior reaction; (6) **Pregnancy**: GBCAs cross placenta — only if essential, no alternative, benefits outweigh risk (ACR not contraindicated absolutely); (7) **Breastfeeding**: ACR — continue breastfeeding (minimal transfer); (8) **Pediatric**: lower doses, weight-based; macrocyclic preferred

---

GBCAs: NSF risk in CKD eGFR < 30 — linear agents higher risk; macrocyclic Group II preferred. Renal screening before. Brain retention noted (clinical significance uncertain). Allergic reactions less common than iodinated.', NULL,
  'medium', 'renal_gu', 'review',
  'radiology', 'basic_science', 'renal_gu', 'adult',
  'ACR Manual on Contrast Media v10.3; FDA Communications', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Gadolinium contrast — safety considerations + nephrogenic systemic fibrosis (NSF)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Critical findings communication — radiology workflow + safety

คำถาม: communicating life-threatening findings', '[{"label":"A","text":"Email only"},{"label":"B","text":"Critical findings communication — ACR + IOM standards"},{"label":"C","text":"Defer to next day"},{"label":"D","text":"No direct contact needed"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Critical findings communication — ACR + IOM standards: (1) **Critical / actionable findings** require direct communication beyond report: imminent life-threatening (pneumothorax under tension, free air, pulmonary embolism, AAA leak, ICH, stroke, acute aortic dissection, fracture risking instability, ectopic pregnancy), urgent (new mass, fracture, abscess); (2) **ACR Practice Parameter for Communication of Diagnostic Imaging Findings (2020)**: - **Level 1 (Red — within minutes)**: directly threatens patient survival or limb — call referring provider; document time, person spoken to, content; - **Level 2 (Orange — within hours)**: requires medical attention to avoid significant morbidity — phone/secure messaging; - **Level 3 (Yellow — within days)**: requires follow-up but not emergent — automated alerts, secure portals, follow-up systems; (3) **Methods**: phone call (most reliable for Level 1), secure messaging, EHR alerts, closed-loop communication confirming receipt; (4) **Documentation in report + audit trail**: when, how, who, content; (5) **Closing the loop**: tracking + follow-up systems for incidental findings (lung nodules — Fleischner, adnexal cysts, etc.) — avoid ''fall through cracks''; (6) **Safety culture**: blame-free reporting of near misses; (7) **Modern tools**: AI-assisted prioritization of worklists (flag PE/pneumothorax/ICH to top), automated alerts, dashboards, structured reporting; (8) **Multidisciplinary**: radiology + ordering provider + IT + quality + administration; (9) **Standards bodies**: ACR, Joint Commission, ABR; (10) **Continuous improvement**: case reviews, root cause analysis when communication failures lead to harm

---

Critical findings: direct communication required (phone for Level 1). ACR levels Red/Orange/Yellow + timing. Document method + person + content + closed loop. Modern AI-prioritization. Multidisciplinary safety culture.', NULL,
  'easy', 'procedures', 'review',
  'radiology', 'ems_mgmt', 'procedures', 'adult',
  'ACR Practice Parameter Communication 2020; Joint Commission', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Critical findings communication — radiology workflow + safety

คำถาม: communicating life-threatening findings'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Door-to-needle (DTN) + door-to-imaging time for acute stroke — quality metrics', '[{"label":"A","text":"No time pressure"},{"label":"B","text":"Stroke imaging quality metrics + DTN"},{"label":"C","text":"Discharge"},{"label":"D","text":"Wait next day"},{"label":"E","text":"Single specialty"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Stroke imaging quality metrics + DTN: (1) **AHA Get With The Guidelines-Stroke (GWTG)** + Joint Commission standards: - **Door-to-CT initiation** ≤ 25 minutes (ideal < 20); - **Door-to-CT interpretation** ≤ 45 minutes; - **Door-to-needle (DTN)** ≤ 60 minutes (target ≤ 45 minutes for highest tier); - **Door-to-groin puncture** for thrombectomy ≤ 90 minutes (≤ 60 minutes ideal); - **Door-in-door-out** for transfers ≤ 120 minutes; (2) **Process improvements proven to reduce DTN** (Target: Stroke campaign): pre-notification by EMS, single-call activation, parallel processes (registration concurrent with imaging), tPA mixing during CT, CT to ED bed reverse flow, point-of-care testing (INR), team meeting at scanner, premixed weight-based tPA dosing; (3) **Comprehensive Stroke Center criteria** vs Primary Stroke Center; (4) **Tele-stroke** expands access — vRobot consultation; (5) **Imaging protocols**: integrated CT + CTA + CTP rapid scan (''one-stop'' acquisition < 5 minutes); standardized post-processing automated (RAPID, Viz.ai, AI-assisted LVO detection); (6) **Multidisciplinary stroke team**: ED + neurology + radiology + IR + neurocritical care + pharmacy + nursing; (7) **Quality reporting**: GWTG, internal dashboards, AHA Stroke Honor Roll; (8) **Outcomes tied to time**: every 15 minutes saved = improved functional outcome (mRS shift); time is brain (1.9 million neurons lost per minute LVO); (9) **Continuous improvement**: monthly stroke team meetings + case review; (10) **Modern**: AI-driven LVO detection, mobile stroke units in some cities, ambulance bypass protocols

---

Stroke imaging metrics: DTN ≤ 60 (target 45), door-to-CT ≤ 25, door-to-groin ≤ 90 minutes. Target: Stroke processes (pre-notification, single-call, parallel processes). AI-assisted LVO detection. Multidisciplinary.', NULL,
  'easy', 'neurology', 'review',
  'radiology', 'ems_mgmt', 'neurology', 'adult',
  'AHA Get With The Guidelines-Stroke; Target: Stroke', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Door-to-needle (DTN) + door-to-imaging time for acute stroke — quality metrics'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี acute LVO stroke + successful thrombectomy — comprehensive post-stroke care', '[{"label":"A","text":"Single specialty discharge"},{"label":"B","text":"Post-stroke integrative care"},{"label":"C","text":"No follow-up"},{"label":"D","text":"Refuse care"},{"label":"E","text":"Hospice immediately"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-stroke integrative care: (1) **Acute (24-48 hours)**: ICU/stroke unit monitoring — BP control (post-thrombectomy 140-180 SBP typically — avoid hypoperfusion + hemorrhage), neuro checks, repeat imaging 24h (assess hemorrhagic transformation), dysphagia screen before PO (NPO until cleared — aspiration prevention), DVT prophylaxis; (2) **Sub-acute (days-weeks)**: comprehensive workup for etiology — ECG/Holter for AFib (cryptogenic — extended monitoring 30 days, implantable loop recorder consideration), echo (TTE then TEE if cryptogenic — PFO, LV thrombus, valve, ASD), vessel imaging (carotid + intracranial), labs (lipids, HbA1c, hypercoagulable if young/atypical), CHA2DS2-VASc; (3) **Secondary prevention based on etiology**: - Atherosclerotic — antiplatelet (aspirin/clopidogrel; DAPT × 21-90 days for high-risk minor stroke per CHANCE/POINT/SOCRATES), high-intensity statin (target LDL < 70), BP control (< 130/80), DM, smoking cessation; - Cardioembolic (AFib) — anticoagulation (DOAC preferred or warfarin); - Other (PFO, dissection, hypercoagulable) — individualized; (4) **Rehabilitation** early + intensive: PT (gait, balance), OT (ADLs), speech therapy (aphasia, dysphagia), neuropsychology (cognitive deficits, depression), recreational therapy; inpatient rehab vs SNF vs home with services; (5) **Post-stroke depression** (~ 30%) — screen + treat (SSRI); cognitive impairment screening; (6) **Modifiable risk factor management** lifelong: BP, lipids, DM, weight, exercise, diet, smoking, alcohol; (7) **Family + caregiver support + education**: stroke warning signs, medication adherence, fall prevention, transportation, equipment; (8) **Multidisciplinary stroke clinic** follow-up: neurology + PCP + cardiology if AFib + PT/OT + speech + social work + nutrition + nursing; (9) **Advance care planning** if severe deficit; (10) **Return to work + driving + community reintegration**

---

Post-stroke care: acute monitoring + etiology workup + secondary prevention by mechanism + intensive rehab + depression/cognitive screening + risk factor management + multidisciplinary stroke clinic + family support.', NULL,
  'easy', 'neurology', 'review',
  'radiology', 'integrative', 'neurology', 'adult',
  'AHA Stroke Survivors Statement; AAN Post-stroke Care', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี acute LVO stroke + successful thrombectomy — comprehensive post-stroke care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 85 ปี severe dementia + new acute symptoms + family disagreement — goals of imaging discussion', '[{"label":"A","text":"Always image"},{"label":"B","text":"Goals of care + imaging in advanced dementia"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Discharge without discussion"},{"label":"E","text":"Refuse care"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Goals of care + imaging in advanced dementia: (1) **First step — goals of care discussion BEFORE imaging**: imaging guided by what will change management consistent with patient values + prognosis; ALWAYS ask: ''Will this scan change what we do? Is what we''d do aligned with patient values?''; (2) **Comprehensive geriatric assessment**: medical (comorbidities), functional (ADLs/IADLs), cognitive (severity of dementia — Global Deterioration Scale, FAST), psychosocial, advance directives review; (3) **Family conflict navigation**: - Identify legal surrogate decision-maker (HCPOA, next of kin per state law); - Substituted judgment standard (what would patient want, not what family wants); - Family meeting with palliative care if available — explore values, concerns, fears, misunderstandings; - Time-limited trial of treatment with predetermined goals + reassessment may help; - Mediation, ethics committee if persistent conflict; (4) **Considerations against extensive imaging in severe dementia**: - Patient may not tolerate (cooperation, claustrophobia, anxiety); - Transport risk (falls, delirium worsening, exposure to noise/stress); - Sedation risks (delirium, aspiration); - Findings may not change management (e.g., new cancer found but patient too frail for treatment); - Avoid ''imaging cascade'' — incidental findings → more tests → more interventions → potential harm; (5) **Considerations FOR imaging when changes management**: - Acute pain — fracture (would impact pain control + positioning); - Suspected reversible cause of decline (UTI, infection, treatable mass causing pain); - Comfort interventions (palliative XRT for bone mets pain — yes, would need imaging for planning); (6) **Palliative imaging philosophy**: limited but purposeful imaging consistent with comfort + dignity goals; concurrent palliative care services; (7) **Hospice consideration** when prognosis < 6 months + focus on comfort; (8) **Documentation**: detailed shared decision-making conversation, surrogate involvement, rationale; (9) **Multidisciplinary**: PCP + geriatrics + palliative care + radiology + nursing + social work + ethics + chaplaincy + family

---

Goals of care drive imaging decisions in advanced dementia. Substituted judgment for surrogate decision. Will imaging change management? Family meeting, palliative care involvement, ethics if needed. Limited purposeful imaging.', NULL,
  'medium', 'neurology', 'review',
  'radiology', 'integrative', 'neurology', 'adult',
  'AGS Choosing Wisely; ASCO Palliative Care; ACR', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 85 ปี severe dementia + new acute symptoms + family disagreement — goals of imaging discussion'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 30 ปี post-MVC + acute SOB + tracheal deviation + decreased breath sounds R + hypotension — clinical tension pneumothorax suspected', '[{"label":"A","text":"X-ray first then decompress"},{"label":"B","text":"Tension pneumothorax — CLINICAL diagnosis + immediate decompression BEFORE imaging"},{"label":"C","text":"MRI"},{"label":"D","text":"Observation only"},{"label":"E","text":"CT prior to any intervention"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Tension pneumothorax — CLINICAL diagnosis + immediate decompression BEFORE imaging: (1) **Clinical diagnosis** — do NOT wait for imaging: respiratory distress + tracheal deviation away from affected side + absent breath sounds + hyperresonance + hypotension + JVD + hypoxia; (2) **Immediate intervention**: needle decompression (14-gauge, 2nd intercostal space midclavicular line OR 5th ICS anterior axillary line per recent ATLS — depends on body habitus, larger studies show better) → tube thoracostomy (chest tube) — definitive; (3) **Imaging AFTER initial stabilization**: - **CXR (upright when stable)**: deep sulcus sign on supine (lateral costophrenic angle deepened), visceral pleural line + absence of lung markings peripheral, mediastinal shift away, depressed hemidiaphragm; - **CT chest** — most sensitive for small/occult pneumothorax (eFAST may detect ~ 50%); - **eFAST/POCUS** at bedside — absence of lung sliding + absence of B-lines + lung point (specific) — high sensitivity in trained hands, faster than imaging transport; (4) **Simple pneumothorax management** (no tension): - Small (< 2 cm rim) + asymptomatic → observation + repeat CXR + supplemental oxygen (accelerates resorption); - Larger or symptomatic → catheter aspiration or chest tube; - Persistent air leak > 5-7 days or recurrent → surgical (VATS bleb resection + pleurodesis); (5) **Pneumothorax risk factors**: trauma, iatrogenic (CVC, biopsy, mechanical ventilation barotrauma), spontaneous (tall thin males — primary; COPD/cystic lung disease — secondary), procedures

---

Tension pneumothorax = CLINICAL diagnosis — needle decompression THEN chest tube, then imaging. eFAST at bedside (lung sliding + lung point). CT for occult/small. Simple PTX — small + asymptomatic observation; larger needs aspiration/chest tube.', NULL,
  'easy', 'trauma', 'review',
  'radiology', 'clinical_decision', 'trauma', 'adult',
  'ATLS 10th ed; BTS Pleural Disease Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 30 ปี post-MVC + acute SOB + tracheal deviation + decreased breath sounds R + hypotension — clinical tension pneumothorax suspected'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 45 ปี post-stab wound to chest + hemodynamically unstable + decreased breath sounds L — clinical hemothorax suspected', '[{"label":"A","text":"Discharge"},{"label":"B","text":"Hemothorax — clinical + imaging + management"},{"label":"C","text":"Observation no chest tube"},{"label":"D","text":"MRI emergent"},{"label":"E","text":"Single specialty"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hemothorax — clinical + imaging + management: (1) **Imaging**: - **eFAST at bedside** — first: free fluid in pleural space (FAST views), pneumothorax screen; - **CXR upright** — blunting of costophrenic angle (~ 200 mL needed for blunting on PA upright; less on lateral decubitus — as little as 50 mL); supine CXR — diffuse haziness over hemithorax; large hemothorax — opacification, mediastinal shift away (significant volume); - **CT chest** — most sensitive + identifies source + associated injuries (lung, vascular, diaphragm, esophagus); (2) **Initial management**: - Hemodynamically stable + small (< 300 mL) → observation; - Larger / symptomatic → **tube thoracostomy** (28-32 Fr large bore for hemothorax — drainage + monitoring of ongoing bleeding); - **Indications for thoracotomy/VATS**: > 1500 mL immediate drainage OR ongoing bleeding > 200 mL/hr × 3-4 hours; persistent hemothorax (retained) → VATS evacuation within 3-7 days to prevent empyema + fibrothorax; (3) **Retained hemothorax** complications: empyema, fibrothorax, restrictive ventilatory defect, chronic pain; (4) **Coagulopathy correction**: transfusion (1:1:1 ratio in massive — MTP), TXA in trauma (CRASH-2/3); (5) **Penetrating chest trauma decision tree**: ABCDE + eFAST + CXR + decision for OR (massive hemothorax, persistent hemodynamic instability, cardiac tamponade) vs CT (stable, comprehensive evaluation); (6) **Multidisciplinary**: trauma surgery + ED + radiology + critical care + anesthesia

---

Hemothorax: eFAST + CXR + CT. Large-bore chest tube. Thoracotomy if > 1500 mL initial or > 200 mL/hr × 3-4h. Retained hemothorax → VATS evacuation. MTP + TXA. Multidisciplinary trauma.', NULL,
  'medium', 'trauma', 'review',
  'radiology', 'clinical_decision', 'trauma', 'adult',
  'ATLS; EAST Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 45 ปี post-stab wound to chest + hemodynamically unstable + decreased breath sounds L — clinical hemothorax suspected'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี incidental finding 6 mm solid pulmonary nodule on chest CT done for other reason — non-smoker, no malignancy history

คำถาม: Fleischner Society 2017 management', '[{"label":"A","text":"Biopsy immediately"},{"label":"B","text":"Fleischner Society 2017 Guidelines — incidental pulmonary nodules ≥ 35 years"},{"label":"C","text":"Discharge no follow-up"},{"label":"D","text":"Surgery for all nodules"},{"label":"E","text":"X-ray annual"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Fleischner Society 2017 Guidelines — incidental pulmonary nodules ≥ 35 years: (1) **For solid nodules**: - **< 6 mm**: low-risk (non-smoker, no other risk) → no routine follow-up; high-risk (smoker, occupational exposure, family hx) → optional CT at 12 months; - **6-8 mm**: low-risk → CT at 6-12 months, then 18-24 months; high-risk → CT at 6-12 months + 18-24 months; - **> 8 mm**: CT at 3 months + PET/CT + biopsy/resection — individualized; (2) **Multiple solid nodules**: < 6 mm — no follow-up (low) / 12 mo (high); ≥ 6 mm — CT 3-6 mo + consider follow-up at 18-24 mo; (3) **Subsolid nodules**: - Pure ground glass: < 6 mm — no follow-up; ≥ 6 mm — CT at 6-12 mo to confirm persistence, then q2y × 5 years; - Part-solid: solid component < 6 mm — same as ground glass; solid component ≥ 6 mm — CT at 3-6 mo, then management of solid component drives decisions (suspicious — biopsy/resect); (4) **Application**: incidentally found nodules in routine imaging (NOT lung cancer screening — those follow Lung-RADS); (5) **Considerations**: nodule growth (volume doubling time — solid < 400 days suspicious), morphology (spiculation, lobulation, pleural retraction suspicious), location (upper lobe suspicious), patient factors (age, smoking, occupational, family hx); (6) **Modern**: AI-assisted nodule detection + volumetry + characterization emerging; standardized reporting; (7) **Documentation + tracking** of incidental findings — closed-loop systems to avoid lost follow-up

---

Fleischner 2017: solid nodule < 6 mm low-risk → no follow-up; 6-8 mm → CT 6-12 mo; > 8 mm → CT 3 mo + PET + biopsy. Subsolid nodules longer follow-up (q2y × 5 yrs). Track + close loop. Differentiate from Lung-RADS (screening).', NULL,
  'easy', 'respiratory', 'review',
  'radiology', 'clinical_decision', 'respiratory', 'adult',
  'Fleischner Society 2017 (MacMahon); ACR', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี incidental finding 6 mm solid pulmonary nodule on chest CT done for other reason — non-smoker, no malignancy history

คำถาม: Fleischner Society 2017 management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี smoker + new lung mass — pathology confirmed NSCLC adenocarcinoma

คำถาม: staging workup', '[{"label":"A","text":"No staging needed"},{"label":"B","text":"NSCLC staging — TNM 8th edition (effective 2017)"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Discharge"},{"label":"E","text":"Always surgery without staging"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** NSCLC staging — TNM 8th edition (effective 2017): (1) **Imaging staging algorithm**: - **CT chest/abdomen (through adrenals)** with IV contrast: primary tumor (T — size, invasion of mediastinum/pleura/diaphragm/chest wall), N1-3 lymph nodes (hilar, mediastinal — short axis ≥ 1 cm by CT, but CT not specific — biopsy needed), liver + adrenal mets (M); - **PET/CT FDG** — mediastinal nodes + distant mets (extracranial); upstages 15% of patients vs CT alone; - **MRI brain** with contrast — exclude brain mets in all stage II+ (high incidence even asymptomatic); CT brain alternative; - **MRI Pancoast tumor** — superior sulcus, brachial plexus + subclavian vessels invasion; - **Bone scan** — if PET not done; (2) **Tissue diagnosis + molecular**: image-guided biopsy (transthoracic CT-guided, EBUS-TBNA for mediastinal nodes, navigational bronchoscopy); molecular markers — EGFR, ALK, ROS1, BRAF, MET, RET, KRAS G12C, NTRK, HER2 (targeted therapies), PD-L1 (immunotherapy); (3) **Mediastinal staging**: EBUS-TBNA (preferred — minimally invasive, samples lymph nodes), mediastinoscopy for selected (sensitivity for paratracheal stations); (4) **PFTs** for surgical planning (predicted post-op FEV1, DLCO); cardiac evaluation if surgery; (5) **Multidisciplinary tumor board** — radiology, pulmonology, thoracic surgery, medical oncology, radiation oncology, pathology, palliative care; (6) **Stage-based treatment**: I-II — surgery (lobectomy + LN dissection) + adjuvant chemo for selected (osimertinib for EGFR adjuvant ADAURA); III — concurrent chemoradiation + durvalumab consolidation (PACIFIC); IV — systemic (targeted, immunotherapy, chemo)

---

NSCLC staging: TNM 8th ed. CT chest/abd + PET/CT + brain MRI + EBUS-TBNA. Molecular markers (EGFR, ALK, ROS1, KRAS G12C, PD-L1). Multidisciplinary tumor board. Stage-based therapy with osimertinib/durvalumab.', NULL,
  'medium', 'respiratory', 'review',
  'radiology', 'clinical_decision', 'respiratory', 'adult',
  'NCCN NSCLC; IASLC TNM 8th ed', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี smoker + new lung mass — pathology confirmed NSCLC adenocarcinoma

คำถาม: staging workup'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี 8 mm solitary pulmonary nodule + non-smoker — PET/CT for characterization

คำถาม: interpretation', '[{"label":"A","text":"Always negative is benign"},{"label":"B","text":"FDG-PET/CT for pulmonary nodules"},{"label":"C","text":"Discharge"},{"label":"D","text":"X-ray more sensitive"},{"label":"E","text":"Bone scan"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** FDG-PET/CT for pulmonary nodules: (1) **Mechanism**: FDG (fluorodeoxyglucose) — glucose analog uptake reflects metabolic activity; malignant tumors typically hypermetabolic; (2) **Standardized uptake value (SUV)** — semi-quantitative; SUVmax > 2.5 suggests malignancy (cut-off variable; high-grade tumors > 4-5 common); SUV affected by blood glucose, time of imaging, body composition; (3) **Sensitivity for nodules**: - Solid > 8-10 mm — sensitivity 90-95%, specificity 80%; - **Small nodules (< 8 mm) — UNRELIABLE** (false negatives due to partial volume effect); - Ground glass / subsolid nodules — FALSE NEGATIVES — adenocarcinoma in situ + minimally invasive adenocarcinoma often FDG-low; (4) **False positives**: granulomatous infections (TB, fungal — endemic regions), sarcoidosis, infection, inflammation, post-radiation; (5) **False negatives**: subsolid nodules, low-grade tumors (carcinoid — neuroendocrine, mucinous adenocarcinoma in situ), small lesions; (6) **Clinical use**: - Characterize indeterminate solid nodule ≥ 8 mm (Fleischner); - **Staging** NSCLC (T, N, M) — upstages 15-25%, prevents futile surgery; - **Re-staging** post-treatment (PERCIST criteria); - **Recurrence detection**; (7) **Limitations**: brain mets — PET poor (high background brain glucose uptake) — need MRI brain; bone marrow background; (8) **Combined PET/CT** standard — anatomic + functional fused; (9) **Newer tracers**: FDG most common, but specialized — DOTATATE for neuroendocrine, F-DOPA, FAPI emerging

---

PET/CT for nodules: SUVmax > 2.5 suggests malignancy. UNRELIABLE for < 8 mm + subsolid/GGN (false negatives). False positives — granulomatous infection in endemic regions. Useful for staging + recurrence. PET/CT standard combined.', NULL,
  'medium', 'respiratory', 'review',
  'radiology', 'clinical_decision', 'respiratory', 'adult',
  'ACR Appropriateness Criteria; SNMMI Procedure Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี 8 mm solitary pulmonary nodule + non-smoker — PET/CT for characterization

คำถาม: interpretation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี progressive dyspnea + dry cough × 6 เดือน — HRCT พบ subpleural reticulation + honeycombing + traction bronchiectasis + basal posterior predominance ไม่มี ground glass

คำถาม: ILD diagnosis', '[{"label":"A","text":"NSIP"},{"label":"B","text":"UIP pattern (Usual Interstitial Pneumonia) on HRCT — diagnostic for IPF in clinical context"},{"label":"C","text":"Lung cancer"},{"label":"D","text":"Acute pneumonia"},{"label":"E","text":"Single specialty"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** UIP pattern (Usual Interstitial Pneumonia) on HRCT — diagnostic for IPF in clinical context: (1) **UIP pattern criteria (ATS/ERS/JRS/ALAT 2018)**: - **Definite UIP** (all 4): subpleural + basal predominance, honeycombing (clustered cystic airspaces 3-10 mm with thick walls), reticulation + traction bronchiectasis, absence of features suggesting alternative diagnosis; - **Probable UIP**: subpleural basal + reticulation + traction bronchiectasis WITHOUT definite honeycombing; - **Indeterminate**: features not clearly UIP or alternative; - **Alternative diagnosis**: features suggesting other ILD (extensive ground glass, micronodules, peribronchovascular, upper/midzonal); (2) **Confidence for IPF diagnosis**: definite UIP on HRCT + appropriate clinical context (age > 60, no exposure/CTD/drug) — diagnostic for IPF, lung biopsy NOT needed; probable UIP — multidisciplinary discussion + may need surgical lung biopsy or transbronchial cryobiopsy; (3) **Differential diagnosis of UIP pattern**: IPF (most common), chronic hypersensitivity pneumonitis (upper-mid lobe predominance, mosaic attenuation), CTD-ILD (especially RA, scleroderma — autoantibodies, esophageal dilation), asbestosis (exposure history, pleural plaques), drug-induced (amiodarone, methotrexate, nitrofurantoin), familial IPF (telomere, surfactant gene mutations); (4) **NSIP pattern** (different — more responsive to immunosuppression): ground glass + reticulation, peripheral + basal, subpleural sparing, no honeycombing (usually) — younger, female, CTD common; (5) **Workup IPF**: HRCT + clinical + serologies (ANA, RF, anti-CCP, myositis panel — exclude CTD), serum precipitins for HP, occupational/environmental history; (6) **Treatment IPF**: **antifibrotics — pirfenidone, nintedanib** (slow FVC decline + reduce mortality — ASCEND, INPULSIS); lung transplant for selected; clinical trials; multidisciplinary; (7) **Multidisciplinary ILD clinic** — pulmonology + radiology + rheumatology + pathology + thoracic surgery

---

UIP pattern: subpleural + basal + honeycombing + traction bronchiectasis = IPF in appropriate clinical context (no biopsy needed). NSIP — different (ground glass, peripheral basal, no honeycombing). Antifibrotics (pirfenidone, nintedanib). Multidisciplinary ILD.', NULL,
  'hard', 'respiratory', 'review',
  'radiology', 'clinical_decision', 'respiratory', 'adult',
  'ATS/ERS IPF 2018 + 2022 update', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี progressive dyspnea + dry cough × 6 เดือน — HRCT พบ subpleural reticulation + honeycombing + traction bronchiectasis + basal posterior predominance ไม่มี ground glass

คำถาม: ILD diagnosis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 35 ปี dry cough + dyspnea + hilar adenopathy bilateral symmetric on CXR + erythema nodosum + uveitis', '[{"label":"A","text":"Lung cancer"},{"label":"B","text":"Sarcoidosis — Lofgren syndrome variant"},{"label":"C","text":"TB"},{"label":"D","text":"Pneumonia"},{"label":"E","text":"CHF"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Sarcoidosis — Lofgren syndrome variant: (1) **Imaging features**: - **CXR Scadding staging**: Stage 0 normal; Stage I bilateral hilar lymphadenopathy alone; Stage II BHL + parenchymal infiltrates; Stage III parenchymal only; Stage IV pulmonary fibrosis; - **HRCT**: bilateral symmetric hilar + mediastinal lymphadenopathy (HALLMARK), perilymphatic nodules along bronchovascular bundles + fissures + subpleural, upper-mid lobe predominance, eventual fibrosis, calcified nodes (eggshell pattern); (2) **PET-CT**: hypermetabolic nodes + lesions — extrapulmonary disease assessment (cardiac, neuro, eye, skin); (3) **Tissue diagnosis** (usually needed): EBUS-TBNA of mediastinal nodes (high yield) > skin biopsy (cutaneous lesions); shows **non-caseating granulomas**; exclude TB (AFB, PPD/IGRA), fungal, lymphoma; (4) **Lofgren syndrome** = BHL + erythema nodosum + arthralgias + uveitis — often resolves spontaneously (90% remission); good prognosis; biopsy not always needed; (5) **Heerfordt syndrome** = uveoparotid fever + fever + facial nerve palsy + parotid enlargement; (6) **Extrapulmonary involvement** — eye (uveitis), heart (conduction blocks, cardiomyopathy — cardiac MRI + PET for diagnosis), CNS (meningitis, neurosarcoidosis), skin (lupus pernio, plaques), kidney (hypercalcemia + nephrolithiasis), liver, spleen, bone marrow; (7) **Workup**: ACE level (limited utility — not for diagnosis), serum + 24h urine calcium (hypercalcemia from extrarenal calcitriol), eye exam, ECG + echo + cardiac MRI (50% subclinical cardiac involvement), neurologic exam; (8) **Treatment**: observation for asymptomatic limited disease; **corticosteroids** for symptomatic / organ-threatening (lung, eye, cardiac, neuro, skin) + steroid-sparing (MTX, azathioprine, mycophenolate, biologics — TNF inhibitors); (9) **Multidisciplinary** — pulmonology + cardiology + ophthalmology + dermatology + neurology

---

Sarcoidosis: bilateral symmetric hilar adenopathy. Scadding stages I-IV. Lofgren syndrome (BHL + EN + uveitis) — often spontaneous remission. Non-caseating granulomas. ACE not diagnostic. Steroids for symptomatic/organ-threatening. Multidisciplinary.', NULL,
  'medium', 'respiratory', 'review',
  'radiology', 'clinical_decision', 'respiratory', 'adult',
  'ATS/ERS/WASOG Sarcoidosis', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 35 ปี dry cough + dyspnea + hilar adenopathy bilateral symmetric on CXR + erythema nodosum + uveitis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี farmer + chronic cough + progressive dyspnea + weight loss — HRCT พบ centrilobular ground glass nodules + mosaic attenuation + air trapping + mid-upper lobe predominance', '[{"label":"A","text":"IPF"},{"label":"B","text":"Hypersensitivity pneumonitis (HP) — chronic farmer''s lung"},{"label":"C","text":"Asthma"},{"label":"D","text":"Bronchitis"},{"label":"E","text":"Pneumonia"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hypersensitivity pneumonitis (HP) — chronic farmer''s lung: (1) **Imaging features**: - **Acute/subacute HP**: ground glass opacities + centrilobular nodules (poorly defined), upper-mid lobe + central distribution; - **Chronic HP**: superimposed fibrosis (reticulation, traction bronchiectasis, honeycombing — may mimic IPF/UIP — distinguishing features below), mosaic attenuation on expiration (small airway disease + air trapping), ''three-density sign'' (normal lung + ground glass + lobular air trapping) characteristic; (2) **Distinguishing chronic HP from IPF**: - HP — upper-mid lobe predominance, mosaic attenuation, air trapping on expiration, ground glass abundant; - IPF — lower lobe + basal + subpleural predominance, honeycombing, no significant ground glass; sparing of basal areas in HP vs IPF where they are heavily involved; (3) **History essential**: exposure history (birds, mold, hot tubs, occupation — farming, lumber mill, metal working fluids, etc.); identifying antigen sometimes difficult; (4) **Workup**: HRCT + clinical exposure history + bronchoalveolar lavage (lymphocytosis > 30%, low CD4/CD8 ratio typical), serum precipitins for known antigens (limited test characteristics — exposure marker not diagnosis), transbronchial cryobiopsy or surgical lung biopsy in selected cases; (5) **Treatment**: - **Antigen avoidance** — most important — without it, treatment fails; - Corticosteroids for symptomatic acute/subacute; - Chronic fibrotic HP — antifibrotics (nintedanib — INBUILD trial for progressive pulmonary fibrosis including HP); MMF + azathioprine alternatives; - Lung transplant for advanced; (6) **Prevention**: occupational hygiene, ventilation, avoiding exposure; (7) **Multidisciplinary**: pulmonology + allergy/immunology + occupational medicine + radiology + pathology

---

HP: centrilobular GGNs + mosaic attenuation + air trapping + upper-mid lobe in chronic. Exposure history essential. BAL lymphocytosis. Antigen avoidance MOST important. Nintedanib for progressive fibrotic. Multidisciplinary.', NULL,
  'hard', 'respiratory', 'review',
  'radiology', 'clinical_decision', 'respiratory', 'adult',
  'ATS/JRS/ALAT HP Guideline 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี farmer + chronic cough + progressive dyspnea + weight loss — HRCT พบ centrilobular ground glass nodules + mosaic attenuation + air trapping + mid-upper lobe predominance'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 70 ปี occupational asbestos exposure 30 ปีก่อน + worsening chest pain + dyspnea + unilateral pleural effusion — CT พบ nodular pleural thickening + pleural masses', '[{"label":"A","text":"Benign — discharge"},{"label":"B","text":"Mesothelioma — workup + management"},{"label":"C","text":"X-ray only sufficient"},{"label":"D","text":"Single specialty"},{"label":"E","text":"Refuse care"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mesothelioma — workup + management: (1) **Imaging features**: - **CXR/CT**: unilateral pleural effusion (often large, recurrent), nodular pleural thickening (> 1 cm), pleural masses, encasement of lung (''rind-like''), volume loss of hemithorax, pleural calcifications + plaques (asbestos exposure marker, NOT mesothelioma itself), chest wall invasion, mediastinal involvement; - **MRI** — extent of chest wall + diaphragm + mediastinal invasion (better than CT for soft tissue resectability); - **PET/CT** — distant metastases + nodal staging + biopsy target; (2) **Tissue diagnosis** REQUIRED: thoracoscopic (VATS) pleural biopsy preferred (high yield); image-guided pleural biopsy with closed needle technique (Abrams or Cope) — lower yield; cytology of pleural fluid alone insensitive; immunohistochemistry essential (calretinin+, WT1+, cytokeratin 5/6+, CK7+, negative TTF-1 — distinguishes from adenocarcinoma); histologic subtypes — epithelioid (best prognosis), sarcomatoid (worst), biphasic; (3) **Staging**: TNM 8th ed for mesothelioma; (4) **Treatment**: - **Multimodal — multidisciplinary tumor board**: thoracic surgery + medical oncology + radiation oncology + radiology + pathology + palliative care; - **Selected resectable epithelioid** — surgery (extrapleural pneumonectomy EPP or pleurectomy/decortication — less morbid) + chemotherapy + RT; - **Immunotherapy** — nivolumab + ipilimumab (CheckMate 743 — improved OS first-line); - **Chemotherapy** — cisplatin/carboplatin + pemetrexed; bevacizumab; - **Palliative** — pleural drainage (indwelling pleural catheter — IPC), talc pleurodesis; (5) **Asbestos exposure documentation** — compensation, prevention, screening of other exposed workers; (6) **Prognosis** poor — median OS 12-18 months without treatment, ~ 24+ months with multimodal in selected; (7) **Prevention**: ban asbestos use, surveillance of exposed workers, awareness

---

Mesothelioma: asbestos exposure + unilateral pleural effusion + nodular pleural thickening. VATS biopsy + IHC essential. Multimodal multidisciplinary. Nivolumab + ipilimumab first-line (CheckMate 743). Palliative IPC.', NULL,
  'hard', 'respiratory', 'review',
  'radiology', 'clinical_decision', 'respiratory', 'adult',
  'NCCN Mesothelioma; ASCO Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 70 ปี occupational asbestos exposure 30 ปีก่อน + worsening chest pain + dyspnea + unilateral pleural effusion — CT พบ nodular pleural thickening + pleural masses'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี fever + productive cough + lobar consolidation R lower lobe on CXR — community-acquired pneumonia

คำถาม: imaging role + when to repeat', '[{"label":"A","text":"Repeat CXR daily"},{"label":"B","text":"CT findings + DDx"},{"label":"C","text":"MRI immediately"},{"label":"D","text":"Discharge without imaging"},{"label":"E","text":"X-ray monthly"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pneumonia imaging: (1) **Diagnosis**: clinical + CXR (lobar consolidation, infiltrates) usually sufficient for CAP; CT not routine but indicated if: - Complications suspected (effusion, empyema, abscess, necrotizing PNA); - Immunocompromised + unusual organisms; - Treatment failure; - Underlying lung disease (e.g., COPD with infiltrate); - Recurrent or non-resolving (suspect underlying mass — endobronchial obstruction); (2) **CT findings + DDx**: - Lobar consolidation (bacterial — pneumococcus, Klebsiella); - Bronchopneumonia/lobular (staph, gram-negatives); - Cavity (anaerobic, TB, fungal, septic emboli, lung cancer); - Tree-in-bud (small airway disease — endobronchial spread, TB, bronchiolitis); - Ground glass + organizing patterns (viral — COVID, influenza, PCP — perihilar in HIV); - Halo + reverse halo signs (angioinvasive aspergillosis — neutropenic); (3) **Follow-up CXR**: - Resolution often slow — clinical recovery precedes radiographic by weeks (full clearance 6-8 weeks for some); - **Repeat CXR at 6-8 weeks** for patients > 50 or smokers — exclude occult underlying lung cancer; recent ATS/IDSA — selective based on risk; (4) **Complications imaging**: - **Parapneumonic effusion** (US-guided thoracentesis — pH < 7.2, glucose < 60, LDH > 1000, presence of bacteria/pus = complicated → chest tube drainage); - **Empyema** — thick-walled, septated; VATS evacuation; - **Lung abscess** — cavity with air-fluid level; - **Necrotizing pneumonia** — multiple small cavities within consolidation (PVL-Staph, Klebsiella); (5) **Treatment per IDSA/ATS CAP 2019**: outpatient (amoxicillin or doxycycline or macrolide); inpatient non-ICU (beta-lactam + macrolide or respiratory fluoroquinolone); inpatient ICU (beta-lactam + macrolide or fluoroquinolone); MRSA + Pseudomonas coverage selectively

---

Pneumonia: CXR usually sufficient for CAP; CT for complications/failure/immunocompromised/non-resolving. Repeat CXR 6-8 wks selective (smokers, > 50). Complications: parapneumonic effusion (tap), empyema, abscess, necrotizing. IDSA/ATS treatment.', NULL,
  'easy', 'respiratory', 'review',
  'radiology', 'clinical_decision', 'respiratory', 'adult',
  'IDSA/ATS CAP Guidelines 2019', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี fever + productive cough + lobar consolidation R lower lobe on CXR — community-acquired pneumonia

คำถาม: imaging role + when to repeat'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 40 ปี chronic cough + weight loss + night sweats + hemoptysis — CXR พบ upper lobe cavitary lesion with tree-in-bud opacities — TB suspected', '[{"label":"A","text":"Bacterial pneumonia"},{"label":"B","text":"Pulmonary TB — imaging features"},{"label":"C","text":"Lung cancer alone"},{"label":"D","text":"Sarcoidosis"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pulmonary TB — imaging features: (1) **Primary TB**: lower/middle lobe consolidation + ipsilateral hilar/mediastinal lymphadenopathy (Ghon complex if calcified); often resolves spontaneously in immunocompetent; may calcify; (2) **Post-primary (reactivation) TB**: upper lobe cavitary disease (apical-posterior segments of upper lobes + superior segments of lower lobes — well-aerated favors mycobacteria), tree-in-bud (endobronchial spread — small airway involvement with mucus + inflammation), centrilobular nodules, consolidation, pleural effusion, miliary (tiny 1-3 mm nodules diffusely — disseminated, hematogenous spread); (3) **Differential of cavitary lung lesion**: TB (most common chronic infectious cause worldwide), bacterial abscess (anaerobic, Klebsiella, Staph), fungal (Aspergillus — mycetoma in pre-existing cavity, endemic mycoses), septic emboli, lung cancer (squamous most often), Wegener (now GPA — multiple cavities), rheumatoid nodule, sarcoidosis (rare), pneumocystis (uncommon); (4) **Active vs latent TB on imaging** — not reliable distinction; active disease may have minimal findings; sputum + clinical + epidemiologic correlation needed; (5) **Workup**: AFB smear (low sensitivity), culture (gold standard, 6-8 weeks), Xpert MTB/RIF (rapid, detects rifampin resistance — preferred initial test now), IGRA / PPD (exposure marker — does not distinguish active vs latent); (6) **Sequelae imaging**: post-TB fibrosis, bronchiectasis (especially upper lobes), tracheobronchial stenosis, calcified granulomas + lymph nodes, aspergilloma in old cavities, broncholiths; (7) **Treatment** (drug-susceptible): 2 months HRZE + 4 months HR (RIPE), DOT recommended; MDR-TB longer regimens; (8) **Infection control + public health** — isolation airborne precautions, contact tracing, reporting; (9) **Multidisciplinary**: ID + pulmonology + public health + radiology

---

Reactivation TB: upper lobe cavity + tree-in-bud + apical-posterior. Differential cavitary lung lesion. Xpert MTB/RIF rapid Dx. RIPE 6-month treatment + DOT. Airborne isolation. Multidisciplinary.', NULL,
  'easy', 'respiratory', 'review',
  'radiology', 'clinical_decision', 'respiratory', 'adult',
  'WHO TB Guidelines; CDC/ATS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 40 ปี chronic cough + weight loss + night sweats + hemoptysis — CXR พบ upper lobe cavitary lesion with tree-in-bud opacities — TB suspected'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี severe chest pain radiating to back + hypertension — CT angiography aorta พบ intimal flap extending from ascending aorta to descending — Stanford A dissection', '[{"label":"A","text":"Discharge"},{"label":"B","text":"Acute aortic dissection — imaging + management"},{"label":"C","text":"Medical only for all dissection"},{"label":"D","text":"Wait for next day surgery"},{"label":"E","text":"Single specialty"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute aortic dissection — imaging + management: (1) **Imaging modality choice**: - **CT angiography aorta (CTA) — first-line in hemodynamically stable** — fast, widely available, comprehensive (extent, branch vessels, complications); ECG-gated CTA reduces motion artifact in ascending aorta; - **TEE** (transesophageal echo) — alternative for unstable patients (bedside), excellent for ascending aorta + valve; limited descending visualization, requires sedation; - **MRA** — selected stable patients, follow-up; (2) **Classification**: - **Stanford A** — involves ascending aorta (with or without descending) — SURGICAL EMERGENCY (high mortality from rupture into pericardium, tamponade, AI, stroke, MI from coronary involvement); - **Stanford B** — descending only (distal to left subclavian) — usually medical management with antihypertensives unless complications (malperfusion, rupture, refractory pain, expansion — TEVAR endovascular preferred); - **DeBakey** I-III — anatomic; (3) **Imaging features**: intimal flap separating true (typically smaller, faster flow) + false lumens, intramural hematoma variant (no flap — crescent of high attenuation in vessel wall), penetrating atherosclerotic ulcer (focal contrast outpouching), aortic root involvement → coronary involvement + AI + tamponade, branch vessel involvement → malperfusion (carotid, mesenteric, renal, iliac); (4) **Management Stanford A**: - **Emergency cardiothoracic surgery** — replace ascending aorta + aortic valve (Bentall procedure) ± hemiarch / total arch; - BP control while preparing (esmolol → SBP 100-120, HR < 60) — beta-blocker first (reduce shear stress); (5) **Management Stanford B**: - Uncomplicated — anti-impulse therapy (BP + HR control); - Complicated (malperfusion, expansion, refractory pain, rupture) — **TEVAR** (thoracic endovascular aortic repair) preferred over open; (6) **Multidisciplinary**: cardiothoracic surgery + vascular surgery + cardiology + IR + critical care + anesthesia + radiology

---

Aortic dissection: CTA first-line. Stanford A (ascending) = EMERGENCY surgery (Bentall). Stanford B (descending) = medical (HR + BP control) unless complications → TEVAR. Multidisciplinary.', NULL,
  'easy', 'cardiovascular', 'review',
  'radiology', 'clinical_decision', 'cardiovascular', 'adult',
  'ESC Aortic Diseases 2024; AHA/ACC Aortic', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี severe chest pain radiating to back + hypertension — CT angiography aorta พบ intimal flap extending from ascending aorta to descending — Stanford A dissection'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายอายุ 70 ปี USPSTF screening + smoker — abdominal aortic aneurysm screening', '[{"label":"A","text":"Annual CT all adults"},{"label":"B","text":"AAA screening"},{"label":"C","text":"No screening ever"},{"label":"D","text":"Discharge"},{"label":"E","text":"MRI screening"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** AAA screening: (1) **USPSTF Grade B recommendation**: one-time abdominal US screening for AAA in men aged 65-75 who have ever smoked; (2) **For men 65-75 never smoked**: USPSTF grade C — selective screening based on risk (family history of AAA, vascular disease); (3) **For women**: USPSTF — **insufficient evidence** for screening; consider in selected (smokers, family history); some guidelines (SVS) recommend screening women 65-75 who have smoked or have family history; (4) **Modality**: **abdominal ultrasound** — first-line: no radiation, no contrast, accurate for diameter, low cost; CT for definitive sizing + surgical planning + complications; MRA alternative; (5) **AAA threshold definitions**: > 3.0 cm aortic diameter = aneurysm; treatment threshold > 5.5 cm men, > 5.0 cm women (smaller diameter to wall ratio); rapid expansion > 0.5 cm/6 months also indication; (6) **Surveillance based on size**: 3.0-3.9 cm — US q3 years; 4.0-4.9 cm — q1 year; 5.0-5.4 cm — q6 months; (7) **Treatment options**: - **Endovascular aneurysm repair (EVAR)** — preferred for most anatomically suitable AAAs (lower 30-day mortality vs open, similar long-term, requires lifelong surveillance for endoleaks); - **Open surgical repair** — for complex anatomy, young patients with longer life expectancy, infected AAA, EVAR failure; - Medical — BP control + smoking cessation + statin + antiplatelet; (8) **Ruptured AAA** — emergent — surgical or EVAR (depending on stability + anatomy); high mortality; (9) **Multidisciplinary**: vascular surgery + radiology + cardiology + primary care

---

AAA screening: one-time abdominal US for men 65-75 ever smoked (USPSTF B). Surveillance interval by size. Treat > 5.5 cm men, > 5.0 cm women, or rapid expansion. EVAR preferred for most. Multidisciplinary.', NULL,
  'easy', 'cardiovascular', 'review',
  'radiology', 'clinical_decision', 'cardiovascular', 'adult',
  'USPSTF AAA 2019; SVS AAA Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ชายอายุ 70 ปี USPSTF screening + smoker — abdominal aortic aneurysm screening'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี atypical chest pain + intermediate pre-test probability for CAD — CCTA performed

คำถาม: CCTA strengths + interpretation', '[{"label":"A","text":"Discharge"},{"label":"B","text":"Coronary CT angiography (CCTA) — stable chest pain"},{"label":"C","text":"Always invasive cath"},{"label":"D","text":"X-ray sufficient"},{"label":"E","text":"Stress test only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Coronary CT angiography (CCTA) — stable chest pain: (1) **Indications per AHA/ACC 2021 Chest Pain Guidelines + ESC 2019**: stable chest pain + intermediate pre-test probability of CAD (15-65% per ESC, 15-50% intermediate per ACC) — CCTA Class I; alternative to stress testing; **ISCHEMIA** + **SCOT-HEART** + **PROMISE** trials support CCTA-first strategy; (2) **Strengths**: high negative predictive value (> 95%) — excludes obstructive CAD reliably; detects non-obstructive plaque (prognostic), high-risk plaque features (positive remodeling, low attenuation < 30 HU = lipid core, spotty calcification, napkin-ring sign — vulnerable plaque); anatomic information; (3) **Limitations**: severely calcified coronaries (overestimate stenosis), arrhythmia (motion — though modern scanners handle), high heart rates (beta-blocker to HR < 65), pregnancy/young women (radiation — risk-benefit), prior stent (artifact), CABG patients (graft assessment OK but limited native vessel); (4) **FFR-CT** (fractional flow reserve from CCTA) — physiologic significance of anatomic stenosis from same dataset using computational fluid dynamics — reduces unnecessary cath; (5) **Reporting standards** — CAD-RADS classification (0-5) for systematic assessment; (6) **Coronary calcium scoring (CAC, Agatston)** — separate non-contrast scan, prognostic for asymptomatic risk stratification (CAC = 0 very low risk; CAC > 100 elevated risk — consider statin per ACC 2018 cholesterol guidelines); (7) **Acute chest pain CCTA** — selective in low-intermediate risk in some EDs (rapid rule-out — ROMICAT, ACRIN), but high-sensitivity troponin pathways often preferred now; (8) **Radiation dose**: prospective ECG-triggering, iterative reconstruction reduce to 1-3 mSv (modern); (9) **Multidisciplinary**: cardiology + radiology + ED

---

CCTA: stable chest pain intermediate PTP CAD. High NPV. CAD-RADS reporting. FFR-CT for physiology. CAC scoring separate for asymptomatic risk. ISCHEMIA/SCOT-HEART/PROMISE support. Multidisciplinary.', NULL,
  'medium', 'cardiovascular', 'review',
  'radiology', 'clinical_decision', 'cardiovascular', 'adult',
  'AHA/ACC Chest Pain 2021; ESC CCS 2019', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี atypical chest pain + intermediate pre-test probability for CAD — CCTA performed

คำถาม: CCTA strengths + interpretation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี non-ischemic cardiomyopathy + LVEF 25% — CMR for tissue characterization + viability', '[{"label":"A","text":"No tissue characterization possible"},{"label":"B","text":"Cardiac MRI (CMR) — comprehensive characterization"},{"label":"C","text":"X-ray sufficient"},{"label":"D","text":"Discharge"},{"label":"E","text":"PET only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cardiac MRI (CMR) — comprehensive characterization: (1) **Strengths**: gold standard for ventricular volumes + EF (reproducible), tissue characterization (myocardial fibrosis, edema, iron, fat infiltration), flow quantification, perfusion + viability; no radiation; (2) **Late gadolinium enhancement (LGE)**: extracellular gadolinium accumulates in expanded extracellular space (fibrosis, infarct) — appears bright on inversion-recovery imaging; patterns differentiate etiologies: - **Subendocardial/transmural** = infarct (vascular distribution); - **Mid-wall / patchy** = non-ischemic cardiomyopathy (DCM, sarcoid, myocarditis); - **Subepicardial/lateral wall** = myocarditis; - **Diffuse global** = amyloid (also characteristic — difficult to null myocardium); - **Septal/mid-wall stripe** = hypertrophic cardiomyopathy + DCM; (3) **T1 mapping + ECV (extracellular volume)**: quantitative measure of diffuse fibrosis (without need for LGE which detects only focal); native T1 elevated in fibrosis, amyloid, edema; (4) **T2 mapping + STIR**: edema (myocarditis, acute MI, sarcoidosis, takotsubo); (5) **T2*** for iron quantification (thalassemia, hemochromatosis); (6) **Stress CMR** (vasodilator — adenosine, regadenoson): perfusion + viability — alternative to nuclear stress test; (7) **Viability assessment**: hibernating myocardium (akinetic but viable — < 50% wall thickness LGE typically recovers post-revascularization); STICH trial — viability didn''t predict CABG benefit, but CMR remains useful clinically; (8) **Specific conditions**: - **Hypertrophic cardiomyopathy** — LV mass, LGE pattern, apical involvement; - **Cardiac amyloid** — characteristic LGE pattern + difficulty nulling + diffuse ECV elevation; transthyretin (TTR) PYP scan for ATTR; - **Sarcoidosis** — patchy LGE + FDG-PET correlation; - **Myocarditis** — Lake Louise criteria (edema + early gad + LGE); - **ARVC** — fatty infiltration RV + dyskinesia + fibrosis; (9) **Multidisciplinary**: cardiology + cardiac imaging + electrophysiology + cardiothoracic surgery

---

CMR: gold standard volumes/EF + tissue characterization. LGE pattern differentiates ischemic (subendo/transmural) vs non-ischemic (mid-wall, subepi) cardiomyopathy. T1/T2/T2* mapping. Viability + stress perfusion. Lake Louise myocarditis.', NULL,
  'hard', 'cardiovascular', 'review',
  'radiology', 'clinical_decision', 'cardiovascular', 'adult',
  'SCMR Guidelines; AHA Cardiomyopathy', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี non-ischemic cardiomyopathy + LVEF 25% — CMR for tissue characterization + viability'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 75 ปี acute SOB + bilateral leg edema + S3 + JVD — CXR พบ cardiomegaly + cephalization + Kerley B lines + bilateral interstitial edema', '[{"label":"A","text":"Discharge"},{"label":"B","text":"Acute decompensated heart failure (ADHF) — imaging + workup"},{"label":"C","text":"Single specialty"},{"label":"D","text":"X-ray only sufficient"},{"label":"E","text":"Refuse care"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute decompensated heart failure (ADHF) — imaging + workup: (1) **CXR features**: cardiomegaly (cardiothoracic ratio > 0.5), upper lobe pulmonary venous diversion (cephalization — chronic), interstitial edema (Kerley B lines — peripheral horizontal lines in lower lobes, peribronchial cuffing, prominent interstitial markings — bat-wing distribution central), alveolar edema (perihilar ''bat wing''), pleural effusions (often right > left), valve calcifications; (2) **POCUS** (lung + cardiac): - **Lung**: B-lines (multiple — pulmonary edema, > 3 per intercostal space + bilateral diffuse), pleural effusions; - **Cardiac**: LV function (visual estimate of EF), wall motion abnormalities, RV size, pericardial effusion, IVC size + collapsibility (volume status — large + non-collapsing = high pressure); (3) **Echocardiogram** — comprehensive: LVEF, regional WMA, valves, diastolic function, RV, PA pressure estimation; classify HFrEF vs HFpEF (preserved EF ≥ 50%); (4) **CMR** for cardiomyopathy etiology (above question); (5) **Workup acute**: BNP/NT-proBNP, troponin (concurrent ischemia), CBC, BMP, TFTs, iron studies (cardiac iron overload), HIV, drug screen if appropriate; (6) **Treatment ADHF**: IV diuretics (loop — furosemide, doses titrated; DOSE trial), vasodilators (nitroglycerin for pulmonary edema + hypertension), inotropes (dobutamine, milrinone — for cardiogenic shock low EF), positive pressure ventilation (BiPAP — reduces preload + afterload + work of breathing); (7) **HFrEF chronic**: GDMT — ARNI (sacubitril/valsartan), beta-blocker (carvedilol, metoprolol succinate, bisoprolol), MRA (spironolactone, eplerenone), SGLT2 inhibitor (dapagliflozin, empagliflozin — improves outcomes regardless of DM); device — ICD, CRT for selected; advanced — LVAD, transplant; (8) **HFpEF** — empagliflozin/dapagliflozin (EMPEROR-Preserved, DELIVER); diuretics for symptoms; comorbidity management; (9) **Multidisciplinary HF clinic**: cardiology + HF specialist + PCP + nursing + nutrition + pharmacy + palliative care

---

ADHF: CXR cardiomegaly + Kerley B + bilateral edema. POCUS B-lines + cardiac. Echo for HFrEF/HFpEF + etiology. GDMT — ARNI + BB + MRA + SGLT2i (4 pillars). Multidisciplinary HF clinic.', NULL,
  'easy', 'cardiovascular', 'review',
  'radiology', 'clinical_decision', 'cardiovascular', 'adult',
  'ACC/AHA HF Guidelines 2022; ESC HF 2021', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 75 ปี acute SOB + bilateral leg edema + S3 + JVD — CXR พบ cardiomegaly + cephalization + Kerley B lines + bilateral interstitial edema'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี acute SOB + hypotension + JVD + muffled heart sounds (Beck''s triad) — pericardial effusion + tamponade physiology', '[{"label":"A","text":"Single specialty discharge"},{"label":"B","text":"Pericardial tamponade — imaging + management"},{"label":"C","text":"Wait for elective workup"},{"label":"D","text":"Refuse care"},{"label":"E","text":"X-ray only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pericardial tamponade — imaging + management: (1) **POCUS / echocardiogram** — first-line emergent: large pericardial effusion (anechoic space around heart > 1 cm typically), tamponade signs — RV diastolic collapse, RA systolic collapse (more sensitive), septal bounce, IVC plethora (dilated, non-collapsing with respiration), respiratory variation in transvalvular flows (> 25% mitral, > 60% tricuspid — flow paradoxus); (2) **CXR**: ''water bottle'' cardiac silhouette (large globular heart) — slow accumulation; small effusions don''t change CXR; (3) **CT/MRI**: pericardial effusion characterization (hemorrhagic high attenuation, malignant masses, fibrin strands suggesting hemorrhagic/purulent); pericardial thickening (constrictive pericarditis differential); (4) **Etiology**: - Malignancy (most common cause large effusion + tamponade in adults — lung, breast, lymphoma, leukemia); - Infectious (TB endemic regions, viral, purulent); - Uremia (advanced renal failure); - Post-pericardiotomy syndrome; - Post-MI (Dressler, free wall rupture - small effusion can tamponade in acute); - Aortic dissection (extension into pericardium); - Hemorrhagic (anticoagulants, trauma, post-procedure); - Autoimmune (lupus, RA); - Hypothyroidism; (5) **Management emergent tamponade**: - **Pericardiocentesis** — subxiphoid + echo-guided; pigtail catheter for ongoing drainage (~24-48 hours); send fluid for cytology, gram + AFB stain + culture, protein, LDH, glucose, triglycerides; - **Surgical pericardiotomy / pericardial window** for malignant recurrent (subxiphoid window vs VATS — long-term drainage to pleural space); - Treat underlying cause; (6) **Constrictive pericarditis** (chronic): pericardial thickening + calcification + septal bounce + ventricular interdependence (D-shaped LV in inspiration) — distinguish from restrictive cardiomyopathy (CT/CMR critical) — pericardiectomy curative; (7) **Multidisciplinary**: cardiology + cardiac surgery + IR + oncology if malignant

---

Tamponade: echo first-line — large effusion + RV/RA collapse + IVC plethora + flow paradoxus. Emergent pericardiocentesis. Etiology workup. Surgical window for recurrent malignant. CT/CMR differentiate constrictive vs restrictive. Multidisciplinary.', NULL,
  'medium', 'cardiovascular', 'review',
  'radiology', 'clinical_decision', 'cardiovascular', 'adult',
  'ESC Pericardial Diseases 2015', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี acute SOB + hypotension + JVD + muffled heart sounds (Beck''s triad) — pericardial effusion + tamponade physiology'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี IVDU + fever + new murmur + embolic phenomena — infective endocarditis workup', '[{"label":"A","text":"Single specialty discharge"},{"label":"B","text":"Infective endocarditis (IE) imaging"},{"label":"C","text":"X-ray only"},{"label":"D","text":"Refuse care"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Infective endocarditis (IE) imaging: (1) **Duke Criteria 2023 modified** (Major + minor): need 2 major OR 1 major + 3 minor OR 5 minor for definite IE; (2) **Major criteria — imaging-based**: - **Echocardiogram**: vegetation, abscess, prosthetic valve dehiscence/regurgitation, new valvular regurgitation; - **18F-FDG PET/CT or radiolabeled WBC SPECT/CT**: abnormal activity on prosthetic valve (≥ 3 months post-implant) — added in 2023 update; - **Cardiac CT**: definite paravalvular lesions; (3) **Echocardiogram approach**: - **TTE first** — sensitivity ~ 60% native valve, lower for prosthetic; - **TEE if negative TTE + clinical suspicion** OR initial in high-risk (prosthetic valve, IVDU with high suspicion, complications suspected) — sensitivity > 90%; - **Repeat TEE in 5-7 days** if initial negative + persistent suspicion; - Surveillance TEE for complications (abscess, dehiscence, perforation) + response monitoring; (4) **Other imaging**: - **Brain MRI** — embolic strokes + mycotic aneurysms (rupture risk — high in unruptured); routinely indicated even if asymptomatic per recent guidelines; - **CTA brain** — mycotic aneurysm screening; - **Whole-body imaging** — FDG PET/CT or labeled WBC for prosthetic valve + cardiac implantable device IE — sensitivity for prosthetic IE; (5) **Embolic phenomena imaging**: splenic infarcts, mycotic aneurysms (brain, mesenteric, splenic), Janeway lesions, Osler nodes, Roth spots, septic pulmonary emboli (right-sided IE — IVDU); (6) **Microbiology**: blood cultures × 3 from different sites BEFORE antibiotics, then empiric therapy modified by sensitivities; culture-negative IE (Coxiella, Bartonella, HACEK, Brucella — serology); (7) **Treatment**: prolonged IV antibiotics (4-6 weeks); surgery indications — CHF from valve destruction, persistent bacteremia, large vegetation > 10 mm with embolic events, paravalvular abscess, prosthetic valve IE, fungal IE; (8) **Multidisciplinary ''Endocarditis Team''**: cardiology + ID + cardiothoracic surgery + radiology + microbiology — improves outcomes per ESC + AHA

---

IE: Duke criteria 2023. TTE → TEE if negative + suspicion. Brain MRI for emboli. FDG-PET/CT or WBC SPECT for prosthetic valve. Multidisciplinary Endocarditis Team. Surgery for selected. Prolonged antibiotics.', NULL,
  'hard', 'cardiovascular', 'review',
  'radiology', 'clinical_decision', 'cardiovascular', 'adult',
  'ESC IE 2023; AHA IE Statement', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี IVDU + fever + new murmur + embolic phenomena — infective endocarditis workup'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี asymptomatic — preventive cardiology — coronary artery calcium (CAC) scoring', '[{"label":"A","text":"Discharge"},{"label":"B","text":"Coronary artery calcium (CAC) scoring (Agatston)"},{"label":"C","text":"X-ray sufficient"},{"label":"D","text":"Always treat with statin"},{"label":"E","text":"Bone scan"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Coronary artery calcium (CAC) scoring (Agatston): (1) **Method**: non-contrast prospectively ECG-gated CT chest, low radiation (~ 1 mSv), no contrast needed; calculates Agatston score based on calcified plaque area + density; (2) **Score categories**: - **CAC = 0** — very low risk (~ 1% MACE 10-year — ''power of zero'') — defer statin in low-intermediate risk; - **CAC 1-99** — mild; - **CAC 100-399** — moderate elevated risk; - **CAC ≥ 400** — severely elevated, equivalent to known CAD risk; (3) **Indications per ACC/AHA 2018 Cholesterol Guidelines** (Class IIa): asymptomatic intermediate ASCVD risk (10-year risk 5-20%, especially 7.5-20%) with uncertainty about statin benefit — CAC for risk reclassification + shared decision-making; also reasonable in selected low-borderline (5-7.5%) with risk enhancers (family history, etc.); (4) **NOT recommended** for: very low risk (< 5%), high risk already (already statin indicated), known CAD, symptomatic (use CCTA or stress test); (5) **Pitfalls**: detects calcified plaque only — does NOT detect non-calcified vulnerable plaque (younger patients), so ''zero'' less reliable in symptomatic; race/sex differences (lower in women, certain ethnicities); (6) **MESA Risk Score** integrates CAC with traditional risk factors — better prediction than risk calculators alone; (7) **Management based on CAC**: lifestyle (DASH/Mediterranean diet, exercise, weight, smoking cessation) for all; statin (moderate-high intensity) for CAC ≥ 100 (or per MESA estimate); aspirin individualized (ASCVD risk vs bleeding); BP + DM control; (8) **Patient education**: visual representation of risk often motivates lifestyle change; (9) **Multidisciplinary**: cardiology + primary care + radiology

---

CAC scoring: non-contrast CT for asymptomatic intermediate risk reclassification (ACC/AHA 2018 IIa). ''Power of zero'' very low risk. CAC ≥ 100 → statin. Not for symptomatic (use CCTA). MESA Risk Score integrates. Multidisciplinary preventive cardiology.', NULL,
  'easy', 'cardiovascular', 'review',
  'radiology', 'clinical_decision', 'cardiovascular', 'adult',
  'ACC/AHA Cholesterol 2018; MESA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี asymptomatic — preventive cardiology — coronary artery calcium (CAC) scoring'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี acute chest pain + shock + ECG พบ ST elevation anterior + RV strain — pulmonary embolism vs MI vs aortic dissection — triple rule-out CT', '[{"label":"A","text":"Always TRO for all chest pain"},{"label":"B","text":"Triple rule-out CT (TRO) — comprehensive"},{"label":"C","text":"MRI"},{"label":"D","text":"X-ray sufficient"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Triple rule-out CT (TRO) — comprehensive: (1) **Indication**: ED chest pain with unclear etiology — possible PE, ACS, aortic dissection — when clinical picture is mixed; controversial — most ED workups use targeted imaging based on clinical pre-test probabilities + biomarkers; (2) **Protocol**: ECG-gated CT chest with optimized IV contrast bolus timing to opacify pulmonary arteries + coronary arteries + thoracic aorta simultaneously (typically biphasic injection); higher radiation + contrast vs single-purpose CT; (3) **Strengths**: rapid (< 30 min imaging + reading), one-stop; (4) **Limitations**: higher radiation + contrast, complex protocols, requires expertise, may not be best for any single indication individually; not validated in highest-risk patients; (5) **Modern alternative**: high-sensitivity troponin pathways (rapid rule-out — 0/1 h algorithms per ESC) + risk-stratified imaging based on clinical scores; (6) **When TRO useful**: equivocal presentations with mixed differentials + need to expedite; (7) **Single-purpose CT preferred for most**: - **CTPA** for PE — Wells + D-dimer first; - **CCTA** for stable chest pain + intermediate PTP CAD; - **CTA aorta** for high clinical suspicion dissection; (8) **Modern imaging diagnostics**: AI-assisted detection (PE, LVO, calcium scoring) + structured reporting + closed-loop communication; (9) **Multidisciplinary**: ED + cardiology + radiology + critical care

---

Triple rule-out CT: combined PE/ACS/dissection — useful selected; ECG-gated; higher radiation + contrast. Modern practice — targeted imaging based on clinical PTP + hs-troponin pathways. AI-assisted detection. Multidisciplinary.', NULL,
  'medium', 'cardiovascular', 'review',
  'radiology', 'clinical_decision', 'cardiovascular', 'adult',
  'ACR Appropriateness Criteria; AHA/ACC Chest Pain 2021', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี acute chest pain + shock + ECG พบ ST elevation anterior + RV strain — pulmonary embolism vs MI vs aortic dissection — triple rule-out CT'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 70 ปี severe AS + planning for TAVR — pre-procedural imaging', '[{"label":"A","text":"Discharge"},{"label":"B","text":"TAVR pre-procedural imaging"},{"label":"C","text":"Single specialty"},{"label":"D","text":"X-ray only"},{"label":"E","text":"Refuse care"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** TAVR pre-procedural imaging: (1) **Comprehensive multimodality imaging**: - **TTE (echo)** — confirm severe AS (mean gradient ≥ 40 mmHg, peak velocity ≥ 4 m/s, AVA ≤ 1 cm² or AVAi ≤ 0.6 cm²/m²), LV function, other valves, RV function; - **TEE** if poor TTE windows or low-flow low-gradient AS (dobutamine stress echo to assess true vs pseudo-severe); - **Cardiac CT (multiphase ECG-gated)** — STANDARD for TAVR planning: annulus sizing (3D circumference + area + perimeter for valve size selection — undersizing → paravalvular leak, oversizing → annular rupture), aortic root + sinotubular junction geometry, coronary ostial heights (low ostia < 10-12 mm risk coronary occlusion), aortic + iliofemoral access vessel evaluation (caliber > 5-6 mm typically needed for transfemoral, tortuosity, calcification), aortic valve calcification distribution (asymmetric — paravalvular leak risk); - **Coronary angiography** — pre-TAVR for revascularization decisions in significant CAD (PCI before TAVR for proximal/large vessel disease, especially LM/LAD); - **Carotid imaging** for stroke risk; - **PFTs + renal function** + frailty assessment; (2) **Heart team evaluation** — multidisciplinary: cardiology, interventional cardiology, cardiothoracic surgery, anesthesia, imaging, nursing — assess STS-PROM, frailty (essential frailty toolset), patient preference; (3) **TAVR vs SAVR decision** (PARTNER + EVOLUT trials): - **Low risk** (STS < 4%) — TAVR non-inferior to SAVR (PARTNER 3, EVOLUT Low Risk) — increasingly TAVR preferred; - **Intermediate risk** — TAVR equivalent or better; - **High/extreme risk** — TAVR superior to medical (no SAVR option); - Younger patients (< 65) — SAVR still preferred (limited TAVR durability data > 10 years); valve-in-valve TAVR option for failed bioprosthetic SAVR; (4) **Procedural imaging**: fluoroscopy + TEE intra-op for positioning + paravalvular leak assessment; (5) **Post-TAVR follow-up**: echo at discharge, 30 days, 1 year, then annual; (6) **Modern**: increasing TAVR indications; bicuspid AV — anatomic challenges; mitral + tricuspid transcatheter therapies

---

TAVR pre-procedural imaging: TTE/TEE for severity, cardiac CT for annulus + access + coronary heights, coronary angio for CAD. Heart team evaluation. TAVR vs SAVR by risk + age. PARTNER + EVOLUT trials. Multidisciplinary.', NULL,
  'hard', 'cardiovascular', 'review',
  'radiology', 'clinical_decision', 'cardiovascular', 'adult',
  'ACC/AHA Valvular Heart Disease 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 70 ปี severe AS + planning for TAVR — pre-procedural imaging'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี acute STEMI + cardiogenic shock — coronary angiography + PCI', '[{"label":"A","text":"No imaging"},{"label":"B","text":"Acute STEMI — imaging + treatment"},{"label":"C","text":"Discharge"},{"label":"D","text":"X-ray sufficient"},{"label":"E","text":"Single specialty"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute STEMI — imaging + treatment: (1) **STEMI diagnosis**: clinical + ECG (ST elevation in 2 contiguous leads or new LBBB) + troponin elevation; (2) **Primary PCI is gold standard** (vs fibrinolytics): - **Door-to-balloon (D2B) ≤ 90 minutes** (PCI-capable hospital); - **Door-to-needle ≤ 30 minutes** for fibrinolytics if no PCI available + transfer time > 120 minutes; - **Pre-hospital fibrinolytics** in some systems; - Door-in-door-out ≤ 30 minutes for transfer; (3) **Coronary angiography findings**: culprit vessel occlusion (typical patterns — LAD → anterior STEMI, RCA → inferior, LCx → lateral/posterior); other lesions (multi-vessel disease); (4) **Complete revascularization** — multi-vessel disease (non-culprit lesions): - **COMPLETE trial** + meta-analyses — staged complete revasc improves outcomes vs culprit-only; - Timing — during index admission or shortly after; - Cardiogenic shock — culprit-only first (CULPRIT-SHOCK); (5) **Adjuncts**: aspirin + P2Y12 (ticagrelor or prasugrel — DAPT 12 months), heparin (UFH or bivalirudin), high-intensity statin; (6) **Cardiogenic shock — mechanical support**: IABP (controversial — IABP-SHOCK II showed no mortality benefit), Impella (ongoing trials — RECOVER IV), ECMO for refractory; (7) **Post-STEMI imaging**: echo at 24-48h (LVEF, complications — VSD, free wall rupture, papillary muscle rupture with MR, LV thrombus); repeat echo at discharge + outpatient; cardiac MRI for tissue characterization (microvascular obstruction — MVO, intramyocardial hemorrhage, infarct size — prognostic); (8) **Mechanical complications of MI**: free wall rupture (cardiac tamponade), VSD (loud holosystolic murmur), papillary muscle rupture (severe MR + pulmonary edema), LV aneurysm (delayed), LV thrombus (anterior MI — anticoagulate); (9) **Multidisciplinary**: cardiology + interventional cardiology + critical care + cardiac surgery + ED

---

STEMI: primary PCI D2B ≤ 90 minutes. Coronary angio + culprit vessel identification. COMPLETE revasc improves outcomes (vs culprit only — except CULPRIT-SHOCK). Echo + CMR for prognosis + complications. Multidisciplinary.', NULL,
  'easy', 'cardiovascular', 'review',
  'radiology', 'clinical_decision', 'cardiovascular', 'adult',
  'AHA/ACC STEMI 2013 + ESC STEMI 2023', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี acute STEMI + cardiogenic shock — coronary angiography + PCI'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'CT radiation dose — concepts + ALARA principle', '[{"label":"A","text":"Radiation safe regardless of dose"},{"label":"B","text":"CT radiation dose — concepts"},{"label":"C","text":"Always avoid CT"},{"label":"D","text":"X-ray always preferred"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** CT radiation dose — concepts: (1) **Dose metrics**: - **CTDIvol** (CT dose index volume — mGy) — dose to phantom, indicator of scanner output; - **DLP** (dose-length product — mGy·cm) = CTDIvol × scan length; - **Effective dose** (mSv) — biological effect, weighted by tissue radiosensitivity (k-factor varies by body region — chest ~ 0.014, abdomen ~ 0.015); (2) **Typical effective doses**: CXR 0.02 mSv, mammogram 0.4 mSv, CT head 2 mSv, CT chest 7 mSv, CT abdomen-pelvis 10 mSv, coronary CT 3-5 mSv (prospective gating), nuclear cardiac stress 10-20 mSv, PET/CT 10-25 mSv; cumulative annual background ~ 3 mSv; (3) **Radiation risks (LNT model — linear no-threshold)**: - Stochastic — cancer (lifetime attributable risk: estimated 0.1% per 10 mSv) — pediatric, young adults higher; - Deterministic — skin injuries, cataracts (high dose); (4) **Dose reduction strategies (ALARA)**: - **Automatic tube current modulation (ATCM)** — based on patient size; - **Tube voltage reduction** (kVp — lower for smaller patients, vascular studies); - **Iterative reconstruction** (vs filtered back projection) — reduces noise at lower dose; - **AI/deep learning reconstruction** — emerging; - **Prospective ECG-gating** for cardiac CT (vs retrospective); - **Limiting scan length** to area of interest; - **Avoiding multiphase** when not needed; - **Bismuth shielding** for breast, thyroid, gonads — controversial recently, may worsen image quality + dose; (5) **Image Gently** (pediatric) + **Image Wisely** (adult) campaigns — promote appropriate use; (6) **Pediatric considerations**: 3-4× more radiosensitive than adults — child-sized protocols mandatory; (7) **Pregnancy**: ACR — diagnostic imaging rarely contraindicated in pregnancy when needed; cumulative fetal dose typically < 50 mGy threshold; informed discussion; (8) **Documentation + dose monitoring**: real-time + cumulative tracking; (9) **Multidisciplinary**: radiology + medical physics + ordering providers + patient education

---

CT radiation: CTDIvol, DLP, effective dose (mSv). Risks — stochastic cancer. ALARA strategies: tube current/voltage modulation, iterative reconstruction, AI, prospective gating, limiting scan length. Image Gently/Wisely. Pediatric particularly sensitive.', NULL,
  'easy', 'procedures', 'review',
  'radiology', 'basic_science', 'procedures', 'adult',
  'ACR + AAPM Dose Index Registry; Image Gently/Wisely', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'CT radiation dose — concepts + ALARA principle'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Iodinated CT contrast — safety + contrast-induced nephropathy (CIN)', '[{"label":"A","text":"No safety concerns"},{"label":"B","text":"Iodinated CT contrast safety"},{"label":"C","text":"X-ray equivalent radiation"},{"label":"D","text":"Always contraindicated"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Iodinated CT contrast safety: (1) **Types**: low-osmolar non-ionic (iohexol, iopamidol, iopromide) — current standard; iso-osmolar (iodixanol — selected high-risk renal); high-osmolar replaced; (2) **Adverse reactions**: - **Allergic/anaphylactoid** (NOT true allergy in most cases — not IgE-mediated, but presents similarly): mild (urticaria, mild bronchospasm) 0.6%, moderate-severe 0.04-0.04%, fatal 1-3 per million; - **Premedication for prior reaction**: prednisone 50 mg PO 13h, 7h, 1h pre + diphenhydramine 50 mg 1h pre (Lasser/Greenberger regimen); methylprednisolone IV alternative; emergency protocols faster; - **Cross-reactivity** with gadolinium minimal; shellfish allergy NOT predictive (despite myth); (3) **Contrast-Induced Nephropathy (CIN) / Post-Contrast AKI (PC-AKI)**: - **Definition**: ≥ 25% or 0.3-0.5 mg/dL rise in creatinine within 48-72h; - **Risk factors**: pre-existing CKD (eGFR < 30 highest risk, 30-44 moderate), diabetes, dehydration, advanced age, CHF, large contrast volume, recent contrast within 48-72h, concurrent nephrotoxins; - **Recent evidence**: incidence overestimated in observational studies (confounded by underlying disease); RCTs (PRESERVE) showed no benefit of N-acetylcysteine; mostly avoided in emergencies if clinically needed; - **Prevention**: hydration with IV normal saline 1 mL/kg/h × 6-12h pre + post (best evidence intervention); minimize contrast volume; iso-osmolar in highest-risk; assess eGFR; discontinue nephrotoxins; - **Metformin**: stop before contrast in CKD (eGFR < 30) — risk lactic acidosis; resume 48h after if renal function preserved; (4) **Extravasation**: monitor for swelling at injection site — small extravasations conservative; large or compartment-syndrome risk — surgical evaluation; (5) **Pregnancy**: iodinated contrast crosses placenta — fetal thyroid concerns minimal with single exposure; use if clinically essential; (6) **Breastfeeding**: continue (minimal transfer); (7) **Multidisciplinary**: radiology + ED + pharmacy + nursing + nephrology

---

Iodinated contrast: low-osmolar non-ionic standard. Anaphylactoid reactions (NOT true allergy) — premedication if prior. CIN risk in CKD/DM — IV hydration prevention. Metformin hold in CKD. Pregnancy/breastfeeding generally OK.', NULL,
  'easy', 'renal_gu', 'review',
  'radiology', 'basic_science', 'renal_gu', 'adult',
  'ACR Manual on Contrast Media v10.3', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Iodinated CT contrast — safety + contrast-induced nephropathy (CIN)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Chest X-ray interpretation — systematic approach', '[{"label":"A","text":"No systematic approach needed"},{"label":"B","text":"Systematic CXR interpretation"},{"label":"C","text":"Read in 5 seconds"},{"label":"D","text":"Discharge"},{"label":"E","text":"Single area only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Systematic CXR interpretation: (1) **Quality assessment first**: - **Rotation** — clavicles equidistant from spinous processes; - **Inspiration** — diaphragm at 10th posterior rib / 8th anterior rib; - **Penetration** — vertebrae visible behind heart; - **Angulation** — clavicles project below 4th rib (PA); - **Patient demographics + side markers + technique** (PA preferred to AP — AP magnifies heart); (2) **Systematic ''ABCDEFGHI'' or similar approach**: - **A — Airway**: trachea midline, carina, mainstem bronchi; - **B — Bones**: ribs (fractures), clavicles, spine, scapulae; - **C — Cardiac**: cardiothoracic ratio (< 0.5 PA), borders distinct; - **D — Diaphragm**: contour, free air below, costophrenic angles sharp; - **E — Edges + Effusions**: lateral, costophrenic angles, paravertebral; - **F — Fields (lung)**: zones (upper/middle/lower), compared bilaterally — opacities (consolidation, atelectasis, mass), lucencies (pneumothorax, bullae, emphysema), interstitial (Kerley B, reticulation, septal thickening), vascular markings; - **G — Gastric bubble** + bowel loops; - **H — Hila**: size, density (vascular vs lymphadenopathy), symmetry; - **I — Implants + tubes + lines + iatrogenic**: ETT (3-5 cm above carina), NG/OG tube position (subdiaphragmatic, NOT in lung), CVC (SVC-RA junction, not in heart, no PTX), Foley/PICC, pacemaker leads, surgical clips, chest tubes; (3) **Common pitfalls + tricks**: - **Silhouette sign**: loss of border = pathology adjacent (RML pneumonia obscures right heart border, lingula obscures left); - **Air bronchograms**: consolidation around patent airways; - **Deep sulcus sign**: pneumothorax on supine; - **Hampton hump + Westermark sign**: PE (rare but specific); - **Three Bs**: bones, breasts, base of lung — check edges; (4) **Comparison with priors** — essential; (5) **Documentation + structured reporting**: standardized helps consistency; (6) **Modern**: AI-assisted detection (PTX, nodules, consolidation) — adjunct to radiologist read

---

CXR interpretation: quality first (rotation, inspiration, penetration). Systematic ABCDEFGHI. Silhouette sign + air bronchograms. Compare with priors. AI-assisted detection adjunctive. Structured reporting.', NULL,
  'easy', 'respiratory', 'review',
  'radiology', 'basic_science', 'respiratory', 'adult',
  'Radiology Textbook; ACR Practice Parameter', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Chest X-ray interpretation — systematic approach'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Pulmonary anatomy on CT — segmental bronchopulmonary anatomy', '[{"label":"A","text":"Anatomy unimportant"},{"label":"B","text":"Bronchopulmonary anatomy — CT"},{"label":"C","text":"Single lobe per lung"},{"label":"D","text":"X-ray only sufficient"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bronchopulmonary anatomy — CT: (1) **Lobar anatomy**: - **Right lung**: 3 lobes (RUL, RML, RLL) separated by oblique (major) + horizontal (minor — only on right) fissures; - **Left lung**: 2 lobes (LUL with lingula functionally analogous to RML, LLL) separated by oblique fissure; (2) **Segmental anatomy (10 segments per lung — except left often 8 due to combined apicoposterior + anteromedial basal)**: - **RUL**: apical (S1), posterior (S2), anterior (S3); - **RML**: lateral (S4), medial (S5); - **RLL**: superior (S6), medial basal (S7), anterior basal (S8), lateral basal (S9), posterior basal (S10); - **LUL**: apicoposterior (S1+2), anterior (S3); - **Lingula**: superior (S4), inferior (S5); - **LLL**: superior (S6), anteromedial basal (S7+8), lateral basal (S9), posterior basal (S10); (3) **Vascular anatomy**: pulmonary arteries (deoxygenated, follow bronchi — bronchovascular bundle), pulmonary veins (oxygenated, drain interlobular septa, return to LA — anatomy important for pulmonary vein isolation in AFib ablation); bronchial arteries (systemic from aorta — bronchial circulation); (4) **Secondary pulmonary lobule** — anatomic-functional unit (1-2.5 cm, polyhedral, with terminal bronchiole + arteriole centrally, lymphatics + veins in interlobular septa) — basis for HRCT pattern interpretation: - **Centrilobular** distribution (small airway disease — RB-ILD, HP, infection); - **Perilymphatic** (along bronchovascular bundles + interlobular septa + subpleural — sarcoid, lymphangitic carcinomatosis); - **Random** (miliary TB, hematogenous mets); (5) **Mediastinal compartments** (IASLC 2014): superior (above thoracic inlet), prevascular (anterior), visceral (middle), paravertebral (posterior); (6) **Lymph node stations** (IASLC) — important for lung cancer staging — N stations 1-14 with subgroups; (7) **CT planes + windows**: axial standard, MPR (coronal, sagittal) for orientation, MIP for vessels + nodules, MinIP for airways/lucent lesions; lung window (level -600, width 1500), mediastinal (level 50, width 350), bone (level 400, width 1500)

---

Pulmonary anatomy: 3 lobes right, 2 left; 10 segments each side. Secondary pulmonary lobule = HRCT pattern unit (centrilobular, perilymphatic, random). Bronchovascular bundle. IASLC mediastinal + lymph node stations for lung cancer staging.', NULL,
  'medium', 'respiratory', 'review',
  'radiology', 'basic_science', 'respiratory', 'adult',
  'Anatomy textbook; IASLC Lung Cancer Staging', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Pulmonary anatomy on CT — segmental bronchopulmonary anatomy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Structured reporting in radiology — RADS classifications + benefits', '[{"label":"A","text":"No standardization needed"},{"label":"B","text":"Structured reporting + RADS systems"},{"label":"C","text":"Free text always preferred"},{"label":"D","text":"Discharge"},{"label":"E","text":"Single specialty"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Structured reporting + RADS systems: (1) **Benefits**: standardized communication, reduced ambiguity, comparable across institutions + readers, integration with EHR, quality improvement (compliance, outcomes), patient + referrer education; (2) **Major RADS systems**: - **BI-RADS** (Breast Imaging) — categories 0-6, longest established + most validated; - **Lung-RADS** — lung cancer screening LDCT (1-4X + S); - **LI-RADS** — liver imaging hepatocellular carcinoma (LR-1 definitely benign to LR-5 definitely HCC + LR-M malignant non-HCC); - **PI-RADS** — prostate MRI (1-5); - **TI-RADS** — thyroid nodule US (TR1-5); - **O-RADS** — ovarian/adnexal (1-5 US, with separate MRI version); - **C-RADS** — CT colonography colon polyps; - **CAD-RADS** — coronary CTA (0-5); - **NI-RADS** — head + neck post-treatment surveillance; - **Bone-RADS, ACR Lex-RADS, etc.** emerging; (3) **Components of structured report**: - Indication; - Technique; - Comparison; - Findings (organ-by-organ template); - Impression with management recommendations; - RADS classification + follow-up; - Critical findings communication documented; (4) **Implementation**: report templates in PACS / RIS; ACR Assist or similar embedded; (5) **Limitations**: rigid templates may miss nuances; require ongoing training + updates; (6) **Quality improvement**: peer review, RADPEER, dashboards, MIPS reporting, audits; (7) **Modern**: AI-augmented structured reporting + natural language processing + auto-population of fields; (8) **Patient-centered**: standardized impressions + plain-language summaries (Open Notes, patient portals) — increasingly common; (9) **Multidisciplinary**: radiology + ordering providers + EHR + IT + administration + quality + research

---

Structured reporting + RADS: BI-RADS, Lung-RADS, LI-RADS, PI-RADS, TI-RADS, O-RADS, CAD-RADS, C-RADS. Standardized communication + categories + follow-up. Quality improvement + EHR integration. AI augmentation emerging.', NULL,
  'easy', 'procedures', 'review',
  'radiology', 'ems_mgmt', 'procedures', 'adult',
  'ACR Reporting Initiative; Radiology Society Reports', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Structured reporting in radiology — RADS classifications + benefits'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Peer review + radiology quality assurance programs', '[{"label":"A","text":"No quality programs needed"},{"label":"B","text":"Radiology peer review + QA"},{"label":"C","text":"Single individual responsibility"},{"label":"D","text":"Discharge"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Radiology peer review + QA: (1) **Peer review programs**: - **RADPEER (ACR)** — anonymized random peer review of prior reports during current interpretation; categorize concordance (1-4) — agree, minor disagreement, clinically important disagreement, major; - **Discrepancy / error tracking** — root cause analysis, system + individual learning; - **Just culture** — distinguish system errors from individual negligence; (2) **Quality metrics**: - **Process measures**: turnaround time, critical findings communication, addendum/amendment rates, recommendation for follow-up adherence; - **Outcomes measures**: missed diagnoses, complications of procedures, patient satisfaction; - **Continuous quality improvement (CQI)**: PDSA cycles, lean methodology; (3) **Patient safety initiatives**: - **Wrong-side / wrong-patient prevention** — time-out before procedure, two patient identifiers; - **Contrast reaction management** — protocols, simulation; - **Radiation dose monitoring** — DICOM tags, ACR DIR (Dose Index Registry); - **Critical findings communication** — closed-loop systems with documentation; (4) **Accreditation**: ACR accreditation programs (CT, MR, US, mammography — MQSA, etc.) — facility + equipment + personnel + protocols + QC; (5) **Mammography Quality Standards Act (MQSA, FDA)** — federal regulation for mammography facilities; (6) **MIPS / Value-based reporting**: CMS quality reporting in US; (7) **Continuous Certification (ABR MOC)**: ongoing learning + assessment; (8) **Tumor boards + multidisciplinary conferences**: peer learning, quality, patient outcomes; (9) **Modern**: AI-assisted error detection, structured reporting, dashboards, transparency, patient-reported outcomes; (10) **Reporting near-misses + adverse events**: voluntary, blame-free, focused on systems improvement; (11) **Multidisciplinary**: radiology + administration + IT + risk management + patient safety + quality + medical physics + technologists

---

Radiology QA: RADPEER + discrepancy review + just culture. Process + outcome metrics. ACR accreditation + MQSA + MIPS. AI-assisted error detection. Multidisciplinary tumor boards + safety culture + near-miss reporting.', NULL,
  'medium', 'procedures', 'review',
  'radiology', 'ems_mgmt', 'procedures', 'adult',
  'ACR RADPEER; Joint Commission; MQSA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Peer review + radiology quality assurance programs'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 70 ปี advanced NSCLC + multiple complications + family — comprehensive multidisciplinary care', '[{"label":"A","text":"Single specialty discharge"},{"label":"B","text":"Advanced lung cancer integrative care"},{"label":"C","text":"Avoid palliative care"},{"label":"D","text":"Refuse treatment"},{"label":"E","text":"No multidisciplinary"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Advanced lung cancer integrative care: (1) **Multidisciplinary tumor board**: thoracic medical oncology, radiation oncology, thoracic surgery, pulmonology, radiology, pathology, palliative care, social work, nutrition, pharmacy, nursing, interventional radiology/pulmonology; (2) **Imaging staging + restaging**: PET/CT + brain MRI initial; ongoing CT for response (RECIST 1.1), brain MRI for surveillance; (3) **Molecular characterization**: comprehensive genomic profiling (NGS) for all advanced NSCLC — EGFR, ALK, ROS1, BRAF, MET, RET, KRAS G12C, HER2, NTRK; tumor mutational burden (TMB), PD-L1 IHC; liquid biopsy (ctDNA) for monitoring; (4) **Targeted therapy** for driver mutations — superior to chemotherapy: osimertinib for EGFR, alectinib/lorlatinib for ALK, etc.; CNS-active for brain mets; (5) **Immunotherapy** — pembrolizumab, nivolumab, atezolizumab (anti-PD-1/L1) for PD-L1 high or in combination with chemo; durvalumab consolidation after chemoradiation in stage III; (6) **Local therapies**: - **SBRT** for early-stage NSCLC inoperable, oligometastatic disease, brain mets (SRS); - **Surgery** for early stage; - **RFA / cryoablation / microwave** for selected; - **Bronchoscopic interventions** — stenting for airway obstruction, brachytherapy, photodynamic therapy; (7) **Symptom management**: - Pain (multimodal — opioids, adjuvants, IR procedures — celiac plexus block for chest wall pain, vertebroplasty for spine mets); - Dyspnea (opioids, oxygen, fan, treat reversible causes — effusion drainage, malignant airway obstruction); - Cough; - Hemoptysis (bronchoscopic intervention, IR embolization); - Pleural effusion — drainage + indwelling pleural catheter (IPC) or pleurodesis; (8) **Palliative care integration** — concurrent from diagnosis, not ''end of life only'' — improves QOL + may improve survival (Temel 2010); (9) **Advance care planning** — early discussions, repeat conversations; (10) **Survivorship + support**: smoking cessation (even at diagnosis improves outcomes), nutrition, exercise, mental health, financial counseling, support groups; (11) **Family communication**: realistic prognosis + values + goals + grief support; (12) **Hospice when appropriate** (prognosis < 6 mo + comfort focus)

---

Advanced lung cancer: multidisciplinary tumor board. Molecular profiling drives therapy. Targeted + immunotherapy + chemo + local therapy (SBRT, ablation, bronchoscopic). Symptom management + IR procedures. EARLY palliative care integration. Family communication.', NULL,
  'easy', 'hemato_onco', 'review',
  'radiology', 'integrative', 'hemato_onco', 'adult',
  'NCCN NSCLC; ASCO Palliative Care Statement 2017', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 70 ปี advanced NSCLC + multiple complications + family — comprehensive multidisciplinary care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี chronic HFrEF + multimorbidity — team-based HF care', '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Comprehensive heart failure care"},{"label":"C","text":"No team needed"},{"label":"D","text":"Discharge"},{"label":"E","text":"Refuse treatment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Comprehensive heart failure care: (1) **Multidisciplinary HF clinic / team**: HF cardiologist, primary care, advanced practice nurses, pharmacists, dietitians, social work, palliative care, exercise physiology, mental health, cardiac surgery (when transplant/LVAD), electrophysiology (ICD/CRT), nephrology (cardiorenal); (2) **Imaging**: serial echo (LVEF, dimensions, valves, RV); CMR for etiology + viability; cardiac PET for sarcoid + viability; coronary imaging (ischemic evaluation when appropriate); (3) **GDMT (Guideline-Directed Medical Therapy) — 4 pillars (HFrEF)**: - **ARNI** (sacubitril/valsartan) — preferred over ACEi/ARB (PARADIGM-HF); - **Beta-blocker** — carvedilol, metoprolol succinate, bisoprolol; - **MRA** — spironolactone or eplerenone; - **SGLT2 inhibitor** — dapagliflozin or empagliflozin (DAPA-HF, EMPEROR — benefit even without DM); titrate to target doses; (4) **Additional therapies in selected**: ivabradine (SR + HR > 70 on max BB), hydralazine + nitrates (African Americans or ACEi/ARB intolerance), digoxin (symptoms despite GDMT), vericiguat (worsening HF), omecamtiv mecarbil (severe LV dysfunction); (5) **Device therapy**: - **ICD** primary prevention for LVEF ≤ 35% NYHA II-III on optimal GDMT ≥ 3 months (or LVEF ≤ 30% NYHA I post-MI ≥ 40 days), expected survival > 1 year; - **CRT** for LVEF ≤ 35% + LBBB QRS ≥ 150 ms (or non-LBBB ≥ 150 ms); - **CRT-D** combines both; (6) **Advanced therapies**: - **LVAD** (HeartMate 3) — bridge to transplant or destination therapy in NYHA IIIB-IV refractory; - **Heart transplant** for selected younger patients; - **MitraClip / TEER** for secondary MR (COAPT — selected); (7) **Comorbidity management**: AFib, sleep apnea (CPAP), CKD, anemia + iron deficiency (IV iron — FAIR-HF, AFFIRM-AHF), diabetes (SGLT2i), COPD, depression; (8) **Lifestyle**: low sodium, fluid restriction (cautious), exercise (cardiac rehab — HF-ACTION), weight monitoring (daily weights), avoid NSAIDs; (9) **Patient education + self-management**: medication adherence, symptom recognition, action plans; (10) **Telemedicine + remote monitoring**: implantable hemodynamic monitors (CardioMEMS — CHAMPION trial), weight scales, BP cuffs; (11) **Palliative care + advance care planning** integrated; (12) **Hospice** for end-stage when curative options exhausted

---

HFrEF comprehensive care: multidisciplinary HF clinic. 4 GDMT pillars (ARNI + BB + MRA + SGLT2i). ICD/CRT for selected. LVAD + transplant for refractory. Comorbidity management. Remote monitoring. Palliative care integrated.', NULL,
  'medium', 'cardiovascular', 'review',
  'radiology', 'integrative', 'cardiovascular', 'adult',
  'ACC/AHA HF 2022; ESC HF 2021', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี chronic HFrEF + multimorbidity — team-based HF care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี acute severe abdominal pain + peritoneal signs + sepsis — CXR upright พบ subdiaphragmatic free air', '[{"label":"A","text":"Discharge"},{"label":"B","text":"Hollow viscus perforation — pneumoperitoneum"},{"label":"C","text":"X-ray sufficient diagnosis alone"},{"label":"D","text":"Observation always"},{"label":"E","text":"Single specialty"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hollow viscus perforation — pneumoperitoneum: (1) **Imaging features**: - **Upright CXR**: free air under right hemidiaphragm (most sensitive view — left obscured by gastric bubble); detects as little as 1-2 mL; - **Left lateral decubitus** alternative for unable-to-stand patient; - **CT abdomen-pelvis with IV contrast**: most sensitive — tiny pneumoperitoneum (extraluminal gas adjacent to perforation), focal bowel wall thickening + discontinuity, focal fat stranding, fluid collections, contrast extravasation; (2) **Etiology**: peptic ulcer perforation (anterior duodenal — most common; gastric), diverticulitis perforation, malignancy perforation, ischemic bowel, foreign body, post-procedure (post-endoscopy/colonoscopy, post-laparoscopy retained air normal up to several days), trauma, iatrogenic; (3) **Localizing signs CT**: - Foregut perforation — air anterior/around stomach/duodenum; - Mid/hindgut — pericolic abscess + free air; - Retroperitoneal perforation — retroperitoneal air (duodenal D2-3, sigmoid posterior); (4) **Sealed vs free perforation**: contained (small focal collection — may manage conservatively in selected — peptic ulcer, diverticulitis), gross peritonitis → emergent surgery; (5) **Management**: - **Resuscitation** — IV fluids, broad-spectrum antibiotics (piperacillin-tazobactam, meropenem for severe; cover Gram-negative + anaerobes), NG decompression, NPO; - **Emergent surgical consultation** — laparotomy / laparoscopy for definitive repair; - **Selective non-operative** — contained perforation (sealed) + clinically stable + appropriate antibiotic coverage + close monitoring (e.g., contained diverticulitis Hinchey I-II, contained peptic perforation with no peritonitis); - **Image-guided drainage** for abscess (Hinchey II); (6) **Multidisciplinary**: ED + general surgery + radiology + IR + critical care

---

Hollow viscus perforation: upright CXR free air under right hemidiaphragm. CT for source + extent. Surgical + IR + IDD management. Selective non-operative for contained. Resuscitate + broad-spectrum antibiotics. Multidisciplinary.', NULL,
  'easy', 'gi', 'review',
  'radiology', 'clinical_decision', 'gi', 'adult',
  'WSES Guidelines; ACS Surgery', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี acute severe abdominal pain + peritoneal signs + sepsis — CXR upright พบ subdiaphragmatic free air'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 25 ปี RLQ pain + fever + N/V + leukocytosis — acute appendicitis suspected

คำถาม: imaging modality choice', '[{"label":"A","text":"Always CT every patient"},{"label":"B","text":"Acute appendicitis imaging — ACR Appropriateness"},{"label":"C","text":"X-ray sufficient"},{"label":"D","text":"Discharge"},{"label":"E","text":"Bone scan"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute appendicitis imaging — ACR Appropriateness: (1) **Adult**: - **CT abdomen-pelvis with IV contrast** — first-line, sensitivity + specificity > 95%; findings: dilated appendix > 6 mm, wall thickening + enhancement, fat stranding, appendicolith, abscess, free air (perforation); - **US** alternative in young/thin/pregnant — operator-dependent, sensitivity ~ 80% (less sensitive than CT); positive findings: non-compressible blind-ending tubular structure > 6-7 mm, target sign on cross-section, periappendiceal fat echogenic; (2) **Pregnant women**: **US first** (no radiation); if non-diagnostic → **MRI without gadolinium** (sensitive + no radiation); CT only if MRI not available + clinical concern high; (3) **Pediatric**: **US first** (no radiation, often diagnostic in thin patients); MRI alternative; CT reserved for non-diagnostic US + persistent clinical concern; (4) **Alvarado score** (clinical decision tool) — pre-test probability; high (≥ 7) — surgery without imaging may be appropriate, intermediate — image, low — observe / alternative diagnosis; (5) **Complications imaging**: perforation, abscess (image-guided drainage), peritonitis; (6) **Management**: - **Appendectomy** — laparoscopic preferred (lower wound infection, shorter LOS); - **Antibiotics-first strategy** — controversial but supported by recent trials (CODA, APPAC) for uncomplicated appendicitis — selected patients, with awareness of higher recurrence + appendectomy at 1 year ~ 25-40%; informed shared decision-making; - **Interval appendectomy** after percutaneous drainage of large abscess (Hinchey-like — phlegmon/abscess > 3-4 cm) — usual practice though increasingly questioned by recent data; (7) **Multidisciplinary**: ED + surgery + radiology + pediatrics if children

---

Appendicitis: ACR — adult CT first-line; pregnant US first then MRI; pediatric US first. Surgery laparoscopic standard. Antibiotics-first emerging for uncomplicated (CODA trial). Multidisciplinary.', NULL,
  'easy', 'gi', 'review',
  'radiology', 'clinical_decision', 'gi', 'adult',
  'ACR Appropriateness; CODA Trial NEJM', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 25 ปี RLQ pain + fever + N/V + leukocytosis — acute appendicitis suspected

คำถาม: imaging modality choice'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 70 ปี abdominal distension + bilious vomiting + obstipation — CT พบ dilated small bowel loops with transition point + decompressed distal bowel + adhesive band', '[{"label":"A","text":"X-ray sufficient"},{"label":"B","text":"Small bowel obstruction (SBO) imaging + management"},{"label":"C","text":"Discharge"},{"label":"D","text":"Always surgery first"},{"label":"E","text":"Single specialty"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Small bowel obstruction (SBO) imaging + management: (1) **Imaging findings CT**: dilated proximal small bowel (> 2.5-3 cm) with collapsed distal — transition point identification critical; etiology — adhesions (most common, no mass — bands), hernia (always check ventral + groin), tumor (intussusception in adults often pathologic — mass at lead point), gallstone ileus (pneumobilia + ectopic gallstone — Rigler triad), volvulus (whirl sign — twisted mesentery), foreign body, internal hernia (post-gastric bypass — important DDx); (2) **Severity findings (closed-loop, strangulation, perforation)**: - **Closed-loop obstruction** — radial distribution of dilated loops + whirl sign + mesenteric edema; - **Strangulation** (compromised blood supply) — bowel wall thickening + wall enhancement decreased or absent (key — compare to non-affected loops), pneumatosis intestinalis, portal venous gas, mesenteric edema/haziness, ascites; - **Perforation** — extraluminal gas, focal contrast leak; (3) **CT vs other modalities**: CT IV contrast — gold standard; oral contrast not necessary (delays + may not be tolerated); plain X-ray screen only (limited); US selective; (4) **Management**: - **Stable + uncomplicated (adhesions)** — initial conservative: NG decompression, IV fluids, NPO, electrolyte correction, monitor; ~ 60-80% resolve with conservative care in 24-72 h; **Gastrografin challenge** (water-soluble contrast) — both diagnostic + therapeutic (may resolve adhesive SBO); - **Closed-loop / strangulation / perforation / failure of conservative ≥ 72 h** → emergent surgery; - **Hernia** with incarceration → reduction + repair; - **Tumor / cancer-related** — depends on stage (palliative bypass, stenting in colon, resection); (5) **Large bowel obstruction differs**: most often colon cancer (left-sided) — imaging often CT + colonic decompression via tube/stent often bridge to surgery; sigmoid volvulus (coffee bean sign on X-ray) — decompression via endoscopy + elective surgery; cecal volvulus — surgical (no endoscopic option); (6) **Multidisciplinary**: ED + surgery + radiology + critical care

---

SBO: CT shows transition point + etiology + complications (closed-loop, strangulation). Conservative for stable adhesive (NG, fluids, gastrografin). Surgery for closed-loop/strangulation/failed conservative. LBO often cancer — stent then surgery. Multidisciplinary.', NULL,
  'medium', 'gi', 'review',
  'radiology', 'clinical_decision', 'gi', 'adult',
  'WSES SBO Guidelines; ASCRS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 70 ปี abdominal distension + bilious vomiting + obstipation — CT พบ dilated small bowel loops with transition point + decompressed distal bowel + adhesive band'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี F + obese + acute RUQ pain + fever + Murphy sign + leukocytosis — acute cholecystitis suspected', '[{"label":"A","text":"Discharge"},{"label":"B","text":"Acute cholecystitis — imaging + management"},{"label":"C","text":"X-ray sufficient"},{"label":"D","text":"Delayed surgery weeks later"},{"label":"E","text":"Single specialty"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute cholecystitis — imaging + management: (1) **US (first-line per ACR + Tokyo Guidelines)**: gallstones, gallbladder wall thickening > 3 mm, pericholecystic fluid, sonographic Murphy sign (focal tenderness over GB on probe — specific), GB distension, sometimes wall hyperemia on Doppler; sensitivity ~ 88%, specificity ~ 80%; (2) **HIDA scan (cholescintigraphy)**: non-visualization of GB at 4 hours = acute cholecystitis (cystic duct obstruction blocks tracer); sensitivity > 95%; useful when US equivocal or acalculous cholecystitis suspected; (3) **CT** — less sensitive than US but identifies complications + alternative diagnoses (perforation, abscess, gangrenous, emphysematous, mass causing obstruction, Mirizzi syndrome — stone in cystic duct compressing CHD); (4) **MRI/MRCP** — high resolution + non-invasive evaluation of biliary tree; for complications or alternative diagnoses; (5) **Tokyo Guidelines 2018 (TG18)** severity grading: - Grade I (mild) — uncomplicated, healthy patient — early laparoscopic cholecystectomy preferred; - Grade II (moderate) — local complications (gangrene, abscess, peritonitis, > 72h symptoms, marked leukocytosis); - Grade III (severe) — organ dysfunction — antibiotics + drainage (percutaneous cholecystostomy by IR if poor surgical candidate), delayed cholecystectomy; (6) **Management**: NPO + IV fluids + antibiotics (ceftriaxone + metronidazole or piperacillin-tazobactam); early laparoscopic cholecystectomy (within 72 hours — ChoCo, ACDC trials); percutaneous cholecystostomy alternative for high-risk surgical candidates; (7) **Complications**: gangrene, perforation, emphysematous cholecystitis (diabetes — clostridial), Mirizzi syndrome, cholecystoenteric fistula → gallstone ileus; (8) **Acalculous cholecystitis** — critically ill, elderly, post-op, fasting — HIDA helpful; high mortality — percutaneous cholecystostomy often initial; (9) **Multidisciplinary**: ED + surgery + radiology + IR + GI

---

Acute cholecystitis: US first-line. HIDA when equivocal/acalculous. CT for complications. Tokyo Guidelines severity grading. Early laparoscopic cholecystectomy (< 72h). Percutaneous cholecystostomy by IR for high-risk. Multidisciplinary.', NULL,
  'easy', 'gi', 'review',
  'radiology', 'clinical_decision', 'gi', 'adult',
  'Tokyo Guidelines 2018; ACR Appropriateness', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี F + obese + acute RUQ pain + fever + Murphy sign + leukocytosis — acute cholecystitis suspected'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี jaundice + RUQ pain + dilated CBD on US + elevated bilirubin — choledocholithiasis suspected — MRCP confirms', '[{"label":"A","text":"X-ray sufficient"},{"label":"B","text":"Choledocholithiasis + biliary obstruction imaging"},{"label":"C","text":"Discharge"},{"label":"D","text":"Surgery always before ERCP"},{"label":"E","text":"Single specialty"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Choledocholithiasis + biliary obstruction imaging: (1) **Imaging algorithm per ASGE risk stratification**: - **High probability** (CBD stone visualized on US, cholangitis, bilirubin > 4 mg/dL with CBD > 6 mm) — ERCP directly for diagnosis + therapy; - **Intermediate probability** — MRCP or EUS first → ERCP if positive; - **Low probability** — imaging or operative cholangiography during cholecystectomy; (2) **Modalities**: - **US** — initial: gallstones, CBD dilation (> 6 mm post-cholecystectomy normal, > 8 mm elderly, > 4-6 mm typical reference); stones may not be visible in CBD (overlying bowel gas); - **MRCP (magnetic resonance cholangiopancreatography)** — non-invasive: T2-weighted thick-slab images of biliary + pancreatic ducts; high sensitivity for stones (~ 90%); excellent anatomic detail; - **EUS (endoscopic ultrasound)** — sensitive for distal CBD stones, ampullary lesions, small stones (< 5 mm); - **ERCP** — diagnostic + therapeutic (stone extraction via sphincterotomy + balloon/basket); risks — pancreatitis (5-10%, mitigated by rectal indomethacin), bleeding, perforation, cholangitis; (3) **Cholangitis** (Charcot triad — fever + jaundice + RUQ pain; Reynolds pentad adds hypotension + AMS) — surgical emergency: emergent ERCP for biliary decompression (within 24h, sooner if Reynolds pentad); broad-spectrum antibiotics; resuscitation; (4) **Cholecystocholedocholithiasis** — stones in both GB + CBD: ERCP first to clear CBD + sphincterotomy, then laparoscopic cholecystectomy (preferably same admission per Lancet Cholgate trial); alternative: laparoscopic cholecystectomy + intraoperative cholangiogram + CBD exploration; (5) **Mirizzi syndrome** — stone impacted in cystic duct/Hartmann pouch compressing CHD — variable management (open conversion may be needed); (6) **Multidisciplinary**: GI + surgery + radiology + IR (when ERCP fails — percutaneous transhepatic cholangiography PTC drainage)

---

Choledocholithiasis: US first; MRCP or EUS for intermediate risk; ERCP for high risk (Dx + therapy). Cholangitis = emergency — ERCP < 24h + antibiotics. Cholecystocholedocholithiasis = ERCP + cholecystectomy same admission. PTC if ERCP fails.', NULL,
  'medium', 'gi', 'review',
  'radiology', 'clinical_decision', 'gi', 'adult',
  'ASGE Guidelines; ESGE', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี jaundice + RUQ pain + dilated CBD on US + elevated bilirubin — choledocholithiasis suspected — MRCP confirms'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี severe epigastric pain radiating to back + N/V + elevated lipase 5× ULN — acute pancreatitis confirmed clinically + lab

คำถาม: role of imaging', '[{"label":"A","text":"Always CT on admission"},{"label":"B","text":"Acute pancreatitis — Atlanta 2012 + imaging"},{"label":"C","text":"Discharge"},{"label":"D","text":"Antibiotics for all"},{"label":"E","text":"Single specialty"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute pancreatitis — Atlanta 2012 + imaging: (1) **Atlanta 2012 classification**: - **Interstitial edematous pancreatitis (80%)**: parenchymal enhancement preserved, peripancreatic edema/fat stranding, no necrosis; - **Necrotizing pancreatitis (20%)**: non-enhancing pancreatic tissue ± peripancreatic necrosis; **higher complication + mortality**; - **Complications**: acute peripancreatic fluid collection (APFC < 4 weeks, no wall), pseudocyst (> 4 weeks, defined wall, no solid debris), acute necrotic collection (ANC < 4 wks, heterogeneous), walled-off necrosis (WON > 4 wks, encapsulated necrosis); (2) **CT timing**: - **NOT routine on admission** — diagnosis is clinical + lab (lipase > 3× ULN); CT on day 1 may underestimate necrosis; - **CT abdomen-pelvis with IV contrast at 72 hours (or earlier if clinical deterioration)** — accurate necrosis assessment, complications, CTSI (CT severity index — Balthazar), Modified CTSI; - **Earlier CT if alternative diagnosis suspected** or unclear; - **MRCP** in selected (biliary pancreatitis with persistent obstruction); (3) **US** — initial workup for **etiology** — gallstones (most common cause acute pancreatitis worldwide), CBD dilation; (4) **Etiology workup**: gallstones (US — most common), alcohol (history), hypertriglyceridemia (> 1000 mg/dL — TGs trigger), hypercalcemia, post-ERCP, drugs (azathioprine, valproate, GLP-1 agonists controversial), trauma, autoimmune (AIP — IgG4), genetic (PRSS1, SPINK1), idiopathic; (5) **Severity assessment**: BISAP, APACHE II, Atlanta severity (mild, moderate, severe with persistent organ failure > 48h); (6) **Management**: - **Aggressive fluid resuscitation** initially (recent evidence — moderate not aggressive may be better per WATERFALL trial 2022 — Ringer lactate 1.5 mL/kg/h after bolus); - **Pain control**, antiemetics, early enteral feeding (within 72h — no NPO unless severe ileus); - **Gallstone pancreatitis** — ERCP for cholangitis or persistent obstruction within 24-72h; cholecystectomy same admission for mild gallstone pancreatitis; - **Antibiotics ONLY for infected necrosis** (NOT prophylactic — no benefit); diagnosis by FNA culture or clinical deterioration; - **Infected necrosis** — step-up approach (percutaneous drainage → minimally invasive necrosectomy → open) — PANTER trial; endoscopic transluminal drainage emerging; - **Pseudocyst** — drain if symptomatic, infected, > 5-6 cm persistent — endoscopic (EUS-guided) preferred; (7) **Multidisciplinary**: GI + general surgery + IR + radiology + critical care + nutrition + endocrinology (post-pancreatitis DM)

---

Acute pancreatitis: clinical + lab Dx. CT at 72h for necrosis (not admission). MRCP for biliary. Aggressive (moderate) fluids. ERCP for gallstone + cholangitis. Antibiotics ONLY infected necrosis. Step-up approach for necrosis. Multidisciplinary.', NULL,
  'medium', 'gi', 'review',
  'radiology', 'clinical_decision', 'gi', 'adult',
  'Atlanta 2012; AGA Acute Pancreatitis Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี severe epigastric pain radiating to back + N/V + elevated lipase 5× ULN — acute pancreatitis confirmed clinically + lab

คำถาม: role of imaging'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี LLQ pain + fever + leukocytosis — CT พบ sigmoid wall thickening + pericolic fat stranding + small pericolic abscess 2 cm — diverticulitis with abscess (Hinchey Ib)', '[{"label":"A","text":"X-ray sufficient"},{"label":"B","text":"Acute diverticulitis — Hinchey classification + imaging"},{"label":"C","text":"Discharge no follow-up"},{"label":"D","text":"Always surgery"},{"label":"E","text":"Single specialty"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute diverticulitis — Hinchey classification + imaging: (1) **CT** — gold standard: sigmoid wall thickening, pericolic fat stranding, diverticula, abscess, free air, free fluid, distant complications; (2) **Hinchey classification**: - **I**: pericolic abscess (Ia phlegmon, Ib < 4 cm); - **II**: pelvic/distant abscess (≥ 4 cm); - **III**: purulent peritonitis; - **IV**: feculent peritonitis; (3) **Modified Hinchey + radiologic classification (Wasvary)**: more granular for treatment decisions; (4) **Management by severity**: - **Uncomplicated (Hinchey 0/Ia phlegmon)** — outpatient management trial in selected (per AGA 2015) — antibiotics may not be required (DIABOLO + AVOD trials in Europe showed no benefit of antibiotics for uncomplicated — paradigm shift); - **Complicated**: - Ib (abscess < 4 cm) — IV antibiotics, often resolves; - II (abscess ≥ 4 cm) — IV antibiotics + percutaneous drainage by IR; - III-IV — emergency surgery (Hartmann''s procedure or laparoscopic lavage in selected, primary anastomosis with diverting ileostomy increasingly); (5) **Antibiotics** when used: cover gram-negative + anaerobes (ciprofloxacin + metronidazole outpatient; piperacillin-tazobactam inpatient); (6) **Follow-up colonoscopy** — 6-8 weeks after acute episode in selected (rule out cancer — incidence ~ 1-2%) — recent evidence — selective (not all patients per ASCRS); (7) **Elective surgery** for: recurrent (≥ 2 episodes traditionally, now individualized — quality of life, complications, immunocompromised), complicated (fistula, stenosis, persistent abscess); (8) **Complications**: fistulae (colovesical — pneumaturia, fecaluria; colovaginal — vaginal discharge), stricture, perforation, bleeding; (9) **Right-sided diverticulitis** more common in Asian populations — often Mecillinam-treated; (10) **Multidisciplinary**: ED + surgery + radiology + IR + GI

---

Diverticulitis: CT + Hinchey classification. Uncomplicated — antibiotics may not be needed (DIABOLO/AVOD). Abscess > 4 cm — IR drainage. Peritonitis — surgery. Colonoscopy 6-8 wks selectively. Elective surgery individualized. Multidisciplinary.', NULL,
  'easy', 'gi', 'review',
  'radiology', 'clinical_decision', 'gi', 'adult',
  'ASCRS Diverticulitis Guidelines; AGA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี LLQ pain + fever + leukocytosis — CT พบ sigmoid wall thickening + pericolic fat stranding + small pericolic abscess 2 cm — diverticulitis with abscess (Hinchey Ib)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 75 ปี AFib not on anticoagulant + acute severe abdominal pain out of proportion to exam + lactic acidosis — acute mesenteric ischemia (AMI) suspected', '[{"label":"A","text":"Discharge"},{"label":"B","text":"Acute mesenteric ischemia (AMI) — high mortality + delayed diagnosis common"},{"label":"C","text":"X-ray sufficient"},{"label":"D","text":"Observation only"},{"label":"E","text":"Single specialty"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute mesenteric ischemia (AMI) — high mortality + delayed diagnosis common: (1) **Etiologies** (Brunt classification): - **Arterial embolic (50%)**: AFib, recent MI (mural thrombus), endocarditis — typically SMA mid-segment; sudden onset, severe pain out of proportion; - **Arterial thrombotic (15-25%)**: atherosclerotic plaque rupture, usually history of chronic mesenteric ischemia symptoms (postprandial pain, weight loss, food fear); - **Non-occlusive mesenteric ischemia (NOMI) (20-30%)**: low-flow state (shock, sepsis, cardiac failure, vasoconstrictors); - **Venous thrombosis (5-15%)**: hypercoagulable, portal HTN, malignancy, pancreatitis, inflammatory; (2) **Imaging**: - **CT angiography (CTA) — first-line**: arterial occlusion / thrombus, bowel wall changes (early — thickening with hyperemia; late — pneumatosis intestinalis, portal venous gas, lack of mucosal enhancement, hypoperfusion, bowel dilation), mesenteric edema, ascites, infarction signs; - **MR angiography** alternative; - **DSA** for selected — diagnostic + therapeutic; - Lab — lactic acidosis (late), D-dimer elevated (non-specific); (3) **Management — time-critical**: - **Resuscitation** — aggressive fluids, correct acidosis, hemodynamic support; - **Heparin anticoagulation**; - **Broad-spectrum antibiotics**; - **Emergent surgery** for peritonitis, infarction, perforation — explore + resect non-viable bowel, second-look laparotomy if borderline; - **Endovascular therapy** for arterial occlusions: catheter thrombolysis, mechanical thrombectomy, stenting (SMA); selected — early without peritonitis; - **NOMI** — improve hemodynamics + intra-arterial papaverine infusion (vasodilator); - **Venous thrombosis** — anticoagulation primary; surgery if peritonitis; (4) **Outcomes** — early diagnosis + revascularization (< 6 hours from onset) critical; mortality 50-80% historically, improved with endovascular era; (5) **Chronic mesenteric ischemia (CMI)** — chronic atherosclerosis of mesenteric arteries — postprandial pain, weight loss; CTA + DSA; revascularization (stenting preferred over open bypass for most); (6) **Multidisciplinary**: vascular surgery + IR + general surgery + GI + critical care + radiology

---

AMI: pain out of proportion + lactic acidosis + AFib. CTA first-line. Heparin + resuscitation + emergent surgery for peritonitis; endovascular for selected without peritonitis. Time-critical (< 6h). NOMI — improve hemodynamics. Multidisciplinary.', NULL,
  'hard', 'gi', 'review',
  'radiology', 'clinical_decision', 'gi', 'adult',
  'AGA AMI Guidelines; ESVS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 75 ปี AFib not on anticoagulant + acute severe abdominal pain out of proportion to exam + lactic acidosis — acute mesenteric ischemia (AMI) suspected'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี cirrhosis HCV + AFP rising — surveillance MRI พบ 3 cm hyperenhancing arterial-phase nodule with washout in portal venous + capsule — LI-RADS classification', '[{"label":"A","text":"Biopsy mandatory before treatment"},{"label":"B","text":"HCC — LI-RADS classification + management"},{"label":"C","text":"Discharge"},{"label":"D","text":"Single specialty"},{"label":"E","text":"X-ray sufficient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** HCC — LI-RADS classification + management: (1) **LI-RADS** standardized reporting for HCC: - **LR-1**: definitely benign; - **LR-2**: probably benign; - **LR-3**: intermediate probability; - **LR-4**: probably HCC; - **LR-5**: **DEFINITELY HCC** (≥ 10 mm, arterial-phase hyperenhancement + ≥ 1 of: washout, capsule, threshold growth) — pathognomonic in cirrhotic context, biopsy NOT required; - **LR-M**: malignant non-HCC (e.g., cholangiocarcinoma); - **LR-TIV**: tumor in vein; (2) **Major imaging features for HCC**: - Arterial-phase hyperenhancement (APHE) — non-rim hyperenhancement; - Washout — relative hypoenhancement compared to liver in portal venous or delayed phase; - Capsule — peripheral rim of enhancement; - Threshold growth — ≥ 50% increase in 6 months or new ≥ 10 mm; (3) **Surveillance**: cirrhotic + high-risk chronic HBV (Asian males > 40, Asian females > 50, African > 20, family history HCC) — US ± AFP q6 months; CT/MRI if US inadequate (obese, fatty liver); (4) **Staging**: BCLC (Barcelona Clinic Liver Cancer): - 0/A — early — curative options (resection, transplant, ablation); - B — intermediate — TACE; - C — advanced (vascular invasion or extrahepatic spread) — systemic; - D — terminal — best supportive care; (5) **Treatment options**: - **Resection** — well-compensated cirrhosis (Child-Pugh A), no portal HTN, single tumor; - **Transplant** — within Milan criteria (single < 5 cm or up to 3 lesions all < 3 cm, no vascular invasion) — only definitive cure for cirrhosis + HCC; UCSF + downstaging expanding criteria; - **Locoregional therapies**: ablation (RFA, MWA) for ≤ 3 cm; **TACE** (transarterial chemoembolization) for intermediate stage; **TARE** (Y-90 radioembolization) — also for selected; - **Systemic**: atezolizumab + bevacizumab (IMbrave150 — improved OS vs sorafenib first-line); pembrolizumab + lenvatinib; lenvatinib; sorafenib; tremelimumab + durvalumab (HIMALAYA); (6) **Multidisciplinary HCC tumor board**: hepatology + transplant surgery + medical oncology + IR + radiation oncology + radiology + pathology + nursing + palliative care

---

HCC: LI-RADS LR-5 in cirrhotic context = HCC, no biopsy needed. Arterial enhancement + washout + capsule + threshold growth. BCLC staging guides treatment (resection, transplant Milan, ablation, TACE, systemic). Atezo + bev first-line systemic. Multidisciplinary tumor board.', NULL,
  'hard', 'gi', 'review',
  'radiology', 'clinical_decision', 'gi', 'adult',
  'ACR LI-RADS v2018; AASLD HCC 2023', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี cirrhosis HCV + AFP rising — surveillance MRI พบ 3 cm hyperenhancing arterial-phase nodule with washout in portal venous + capsule — LI-RADS classification'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี colorectal cancer + liver mets on staging CT — workup + management', '[{"label":"A","text":"Hospice immediately"},{"label":"B","text":"Colorectal liver metastases (CRLM) — multimodal"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Discharge"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Colorectal liver metastases (CRLM) — multimodal: (1) **Imaging**: - **CT chest-abdomen-pelvis with IV contrast (portal venous phase)** — staging modality of choice for CRC; - **MRI liver with hepatocyte-specific contrast (Eovist/Primovist, gadoxetate)** — superior for detecting + characterizing liver lesions, distinguishing FNH/adenoma/HCC/mets, in steatotic liver; recommended for surgical planning of liver mets resection (changes management ~ 20-30%); - **PET/CT** — when extra-hepatic disease changes management (pre-resection of CRLM); not sensitive for small or mucinous mets; (2) **Resectability assessment**: - Sufficient future liver remnant (FLR) > 25-30% normal liver, > 30-40% chemo-injured, > 40% cirrhotic; - Adequate vascular inflow + outflow; - Negative margins achievable; - Acceptable performance status; - Synchronous primary — concurrent vs staged resection (multidisciplinary decision); (3) **Multidisciplinary tumor board** essential — paradigm change with effective systemic therapy + advanced techniques; many initially ''unresectable'' downstaged to resectable; (4) **Resectability conversion strategies**: - **Chemotherapy** (FOLFOX/FOLFIRI ± biologics) — convert ~ 15-20% to resectable; - **Portal vein embolization (PVE) by IR** — induces FLR hypertrophy ~ 30% in 4-6 weeks before extended resection; - **ALPPS** (associating liver partition + portal vein ligation for staged hepatectomy) — selected; - **Ablation** for unresectable small lesions; - **Hepatic arterial infusion chemotherapy (HAIC)** — pump-based, selected centers; (5) **Locoregional therapies for unresectable CRLM**: ablation (RFA, MWA) for small (< 3 cm); TARE (Y-90 radioembolization); HAIC; (6) **Systemic therapy**: - First-line FOLFOX or FOLFIRI; biologics — bevacizumab (anti-VEGF — for all) vs anti-EGFR (cetuximab, panitumumab — only RAS/BRAF wild-type left-sided); - Second-line crossover; immunotherapy for MSI-H (pembrolizumab, ipi-nivo); KRAS G12C inhibitors emerging; (7) **Survival in resected CRLM** — 5-year ~ 40-50% (~ 25-30% cured); vs 20% with chemotherapy alone — multimodal critical; (8) **Multidisciplinary**: hepatobiliary surgery + medical oncology + IR + radiation oncology + radiology + pathology + nursing + palliative care

---

CRLM: CT staging + MRI liver hepatocyte-specific contrast for surgical planning. PET/CT selectively. Resectability assessment FLR. PVE/ALPPS to enlarge FLR. Convert with chemo. Ablation + TARE for selected. 5-yr survival 40-50% in resected. Multidisciplinary tumor board.', NULL,
  'hard', 'gi', 'review',
  'radiology', 'clinical_decision', 'gi', 'adult',
  'NCCN Colorectal; ACR Appropriateness', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี colorectal cancer + liver mets on staging CT — workup + management'
  );

commit;

