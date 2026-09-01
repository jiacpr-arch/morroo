-- ===============================================================
-- หมอรู้ — Board seed: ศัลยศาสตร์ (surgery) — part 3/4 (50 MCQs)
-- Safe to paste into Supabase SQL Editor. Re-runnable.
-- ===============================================================

begin;

-- mcq_subjects for this specialty (idempotent)
insert into public.mcq_subjects
  (name, name_th, icon, audience, board_specialty, exam_type, question_count)
values
  ('surg_clinical_decision', 'ศัลยศาสตร์ · การตัดสินใจทางเวชกรรม', '🩺', 'board', 'surgery', NULL, 0),
  ('surg_basic_science', 'ศัลยศาสตร์ · วิทยาศาสตร์การแพทย์พื้นฐาน', '🧬', 'board', 'surgery', NULL, 0),
  ('surg_ems_mgmt', 'ศัลยศาสตร์ · การจัดการระบบบริการการแพทย์ฉุกเฉิน', '🚨', 'board', 'surgery', NULL, 0),
  ('surg_integrative', 'ศัลยศาสตร์ · ข้อสอบบูรณาการ', '🧩', 'board', 'surgery', NULL, 0)
on conflict (name) do nothing;

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 45 ปี ใช้เครื่องสายไฟ accidentally ผ่าน high-voltage electricity 11,000 V — เข้าทางมือซ้าย ออกทางเท้าขวา

VS: BP 102/68, HR 132 (sinus tach), Temp 37.0°C
Gen: dazed, alert, cardiac monitor sinus tach
Left hand: contact burn 3 cm + entry wound; deep + extensive
Right foot: exit wound + extensive deep necrosis
Limbs: tense forearm + calf — compartment syndrome suspected

Lab: CK 28,000, urine dark/brown (myoglobinuria), K 5.8, Cr 1.6
ECG: ST changes, no acute MI

คำถาม: management of high-voltage electrical injury', '[{"label":"A","text":"Standard fluid resuscitation per Parkland formula based on visible burns only"},{"label":"B","text":"High-voltage electrical injury — distinct management vs thermal burns"},{"label":"C","text":"Observation outpatient"},{"label":"D","text":"Antibiotic prophylaxis only"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **High-voltage electrical injury — distinct management vs thermal burns**: (1) **ABCDE primary survey** — secure airway, monitor cardiac (arrhythmia early — VF most common cause of death; delayed arrhythmia uncommon; cardiac monitoring 24h if abnormal ECG/significant exposure); (2) **Aggressive IV fluid resuscitation** — NOT based on visible burns (Parkland underestimates); target urine output **1-2 mL/kg/hr** (higher than thermal burn) until clear urine; rhabdomyolysis-induced AKI prevention; (3) **Rhabdomyolysis management**: - Massive IV fluid (LR 500-1000 mL/h initially) - Maintain UO 1-2 mL/kg/hr - Urinary alkalinization (sodium bicarbonate) to pH > 6.5 — controversial; - Avoid mannitol (no proven benefit, risks); - Monitor K, Ca, PO4, CK; (4) **Compartment syndrome surveillance** — high-voltage causes deep tissue damage often disproportionate to surface burn; check compartments: forearm, calf — **fasciotomy** if elevated pressure or clinical signs; escharotomy for circumferential eschar; (5) **Cardiac monitoring** — admit, telemetry; troponin if abnormal ECG; cardiac echo selective; (6) **Neurologic surveillance** — initial + delayed cataract, neuropathy, spinal cord injury, peripheral neuropathy; CT brain if loss of consciousness; (7) **Wound management** — extensive debridement of necrotic tissue (often staged), amputation may be needed; tetanus prophylaxis; antibiotics; nutritional optimization; (8) **Renal**: AKI from myoglobin + direct injury — early dialysis if severe; (9) **Cataract** — long-term complication (months later) — eye exam baseline + follow-up; (10) **Psychological**: PTSD common, support; rehabilitation extensive

---

**Electrical injury** — unique vs thermal burns: damage often beyond visible skin (deep, internal). **Classification**: - **Low-voltage** < 1000 V (household 110-240 V) — usually local burn, less systemic - **High-voltage** ≥ 1000 V (industrial, lightning > 1 million V) — extensive deep tissue damage, multi-system **Mechanism of injury**: - Direct electrothermal (Joule heating in tissue resistance — bone, fat highest) - Cardiac (arrhythmia — VF most common cause of death) - Muscle damage → rhabdomyolysis → AKI - Neurologic (CNS + peripheral) - Eye (cataract — delayed) - Compartment syndrome (deep muscle damage in dense fascial compartments) **Lightning** — separate entity: massive instantaneous energy, atmospheric pressure (blast), ''Lichtenberg figures'' fern-like skin pattern, often less deep tissue damage than industrial high-voltage but high mortality from cardiac. **Management priorities**: 1. ABCDE — cardiac monitoring (VF, asystole, arrhythmia common immediately; delayed arrhythmia rare) 2. Aggressive fluid resuscitation — TARGET UO 1-2 mL/kg/hr (not based on visible burn area — Parkland underestimates deep injury) 3. Rhabdomyolysis prevention: fluid, urinary alkalinization controversial, monitor labs 4. Compartment syndrome: surveillance, fasciotomy if needed (often) 5. Wound debridement (extensive, often staged amputation considered) 6. Tetanus + antibiotics 7. Delayed complications: cataract (eye exam baseline + 6 mo), neuropathy (months later) **Admission criteria** — any high-voltage; loss of consciousness; tetany; arrhythmia; abnormal ECG; rhabdo; extensive burn; compartment signs. **Cardiac monitoring** duration: at least 24h if any abnormality; 6h observation if normal asymptomatic.', NULL,
  'medium', 'trauma', 'review',
  'surgery', 'clinical_decision', 'trauma', 'adult',
  'ABA Burn Care Guidelines Electrical Injuries; ISBI Practice Guidelines; Koumbourlis AC. Crit Care Med', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 45 ปี ใช้เครื่องสายไฟ accidentally ผ่าน high-voltage electricity 11,000 V — เข้าทางมือซ้าย ออกทางเท้าขวา

VS: BP 102/68, HR 132 (sinus tach), Temp 37.0°C
Gen: dazed, alert, cardiac monitor sinus tach
Left hand: contact burn 3 cm + entry wound; deep + extensive
Right foot: exit wound + extensive deep necrosis
Limbs: tense forearm + calf — compartment syndrome suspected

Lab: CK 28,000, urine dark/brown (myoglobinuria), K 5.8, Cr 1.6
ECG: ST changes, no acute MI

คำถาม: management of high-voltage electrical injury'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 22 ปี ตรวจ self-exam พบก้อนเต้านมข้างขวา ขนาด 2 cm ไม่เจ็บ; ไม่มี nipple discharge

Family history: mother breast cancer age 42, maternal aunt ovarian cancer
Exam: 2 cm firm mobile mass UOQ right breast, no axillary lymphadenopathy
US: well-circumscribed solid mass with smooth margin BI-RADS 3 (likely fibroadenoma)

คำถาม: management', '[{"label":"A","text":"Observation 6 months follow-up only"},{"label":"B","text":"Young woman with breast mass + significant family history — comprehensive workup"},{"label":"C","text":"Bilateral mastectomy immediately"},{"label":"D","text":"Tamoxifen 10 years before workup"},{"label":"E","text":"No follow-up needed"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Young woman with breast mass + significant family history — comprehensive workup**: (1) **Initial assessment**: clinical exam + US (mammogram less useful in dense young breast — adjunct if needed; MRI for high-risk surveillance); (2) **Biopsy** despite BI-RADS 3 appearance — strong family history warrants tissue diagnosis: - **Core needle biopsy** preferred over FNA — provides histology, receptor status, full pathology - **Excisional biopsy** alternative if core inadequate or mass features changing; (3) **Genetic counseling + testing** — strong indication given: - First-degree relative breast Ca < 50 (mother 42) - Second-degree ovarian Ca (maternal aunt) - Young age proband - Test: BRCA1/2 + multi-gene panel (PALB2, ATM, CHEK2, TP53, CDH1, PTEN, STK11) - Confirmed mutation → personalized risk management for patient + family; (4) **If fibroadenoma confirmed**: - Observation acceptable for small (< 2-3 cm), asymptomatic, stable, young - Excision (lumpectomy or vacuum-assisted) for symptomatic, large, enlarging, patient preference - ''Juvenile fibroadenoma'' larger, more cellular — usually still benign but excise to confirm; (5) **High-risk surveillance** if BRCA+ or significant family history (without confirmed mutation): - Annual MRI + mammogram alternating q6 mo - Clinical exam q6 mo - Consider chemoprevention (tamoxifen 5 yr — reduces ER+ breast Ca risk 50%) - Risk-reducing surgery (mastectomy ± oophorectomy after childbearing) in BRCA+ — patient counseling - Ovarian surveillance: TVUS + CA-125 (limited sensitivity — counseling for prophylactic salpingo-oophorectomy at 35-40 in BRCA1, 40-45 in BRCA2 after childbearing); (6) **Lifestyle** + reproductive choices (early childbearing, breastfeeding reduce risk) — discussion

---

**Breast mass in young woman with family history** — although fibroadenoma is most common cause of breast mass in young women, strong family history warrants additional workup. **Fibroadenoma** — most common benign breast tumor in women < 30. Hormonally responsive — enlarges in pregnancy/lactation, regresses postmenopause. Phyllodes tumor — important DDx (variable behavior, may be malignant). **Triple assessment**: clinical + imaging + biopsy (gold standard). **Family history red flags** suggesting hereditary breast/ovarian Ca syndrome (BRCA1/2 + others): - Breast Ca < 50 (especially < 40) - Bilateral or multiple primaries - Male breast Ca - Ovarian Ca any age - Triple-negative breast Ca < 60 - Pancreatic Ca - Prostate Ca metastatic / high-grade - Ashkenazi Jewish ancestry - 2+ relatives with breast/ovarian/pancreatic/prostate **Genetic testing approach**: - Multi-gene panel (more sensitive than BRCA-only) — BRCA1/2, PALB2, ATM, CHEK2, TP53, CDH1, PTEN, STK11 - Cascade testing for family members **BRCA1 vs BRCA2**: - BRCA1: lifetime breast Ca 55-72%, ovarian 39-44%, triple-negative more often, earlier age - BRCA2: breast 45-69%, ovarian 11-17%, male breast Ca, prostate, pancreatic **Risk management for BRCA+**: 1. Enhanced surveillance — annual MRI + mammogram (alternating q6 mo), clinical exam q6 mo from 25 (MRI) / 30 (mammo) 2. Chemoprevention — tamoxifen 5 yr (reduces ER+ Ca 50%); aromatase inhibitor postmenopausal 3. Risk-reducing mastectomy — bilateral; reduces risk 90%+ 4. Risk-reducing salpingo-oophorectomy — at 35-40 BRCA1, 40-45 BRCA2 (after childbearing); reduces ovarian Ca > 80% + breast Ca ~ 50% (if premenopausal) 5. Lifestyle, reproductive **Phyllodes tumor** — distinguishes from fibroadenoma; treat: wide excision + 1 cm margin (benign), wider for borderline/malignant.', NULL,
  'medium', 'hemato_onco', 'review',
  'surgery', 'clinical_decision', 'hemato_onco', 'adult',
  'NCCN Genetic/Familial High-Risk Assessment Breast/Ovarian/Pancreatic 2024; ASCO Guidelines; Tung NM et al. JCO', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 22 ปี ตรวจ self-exam พบก้อนเต้านมข้างขวา ขนาด 2 cm ไม่เจ็บ; ไม่มี nipple discharge

Family history: mother breast cancer age 42, maternal aunt ovarian cancer
Exam: 2 cm firm mobile mass UOQ right breast, no axillary lymphadenopathy
US: well-circumscribed solid mass with smooth margin BI-RADS 3 (likely fibroadenoma)

คำถาม: management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี ผ่า lumpectomy + axillary surgery + radiation + adjuvant therapy for stage II breast cancer 5 ปีก่อน — ทุกอย่างปกติ

Month ago ตรวจ routine surveillance: serum AST 88, ALT 76, ALP 320, GGT 240; CT chest: 2 lung nodules 8-10 mm; CT abdomen: 3 liver lesions 1-2 cm enhancing; tumor markers CEA, CA 15-3 elevated

Biopsy of liver lesion: metastatic adenocarcinoma, ER 80%+, PR 20%+, HER2 0
No brain disease on MRI brain', '[{"label":"A","text":"Surgery + chemotherapy + radiation again"},{"label":"B","text":"Metastatic breast cancer (recurrent, ER+/HER2-) — palliative systemic therapy + supportive care"},{"label":"C","text":"Discharge to hospice immediately"},{"label":"D","text":"Cure-intent treatment same as primary"},{"label":"E","text":"Observation only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Metastatic breast cancer (recurrent, ER+/HER2-) — palliative systemic therapy + supportive care**: (1) **Multidisciplinary tumor board**: medical oncology, surgical oncology, radiation, palliative care; (2) **Biopsy + biomarker reassessment** done — receptor status can change in metastases; ER 80%+, HER2- → endocrine-sensitive (luminal); (3) **First-line systemic therapy** for HR+/HER2- metastatic breast Ca: - **CDK4/6 inhibitor + aromatase inhibitor** (or fulvestrant) — palbociclib, ribociclib, abemaciclib + letrozole/anastrozole/exemestane OR fulvestrant — preferred first-line postmenopausal; OS benefit per PALOMA-2, MONALEESA-2, MONARCH-3 trials - **Ovarian suppression + AI/tamoxifen + CDK4/6** for premenopausal - **PI3K inhibitor (alpelisib + fulvestrant)** if PIK3CA mutation - **mTOR inhibitor (everolimus + exemestane)** — alternative line - **AKT inhibitor (capivasertib + fulvestrant)** — emerging if PI3K-AKT-PTEN pathway altered (CAPItello-291); (4) **Subsequent lines**: switch endocrine + new targeted; chemotherapy when endocrine resistant (capecitabine, eribulin, gemcitabine, taxane); **antibody-drug conjugates** (trastuzumab deruxtecan for HER2-low — DESTINY-Breast04; sacituzumab govitecan TROP2-targeted) — emerging important options; (5) **Local therapy considerations** for oligometastatic — SBRT or surgery for limited mets in select cases; debated value vs systemic alone; (6) **Bone-modifying agents** if bone mets — zoledronic acid OR denosumab — reduces skeletal events; (7) **Supportive care**: pain, fatigue, emotional support, fertility (premenopausal), bone health, cardiac (anthracycline-based prior); (8) **Concurrent palliative care from diagnosis** of metastatic disease — improves QOL, symptom management; (9) **Genetic testing** if not done — PARP inhibitor (olaparib, talazoparib) if BRCA+; (10) **Goals of care discussion** — incurable but treatable chronic disease; survival measured years not months in luminal MBC

---

**Metastatic Breast Cancer (MBC)** — incurable but increasingly treatable as chronic disease. Median OS HR+/HER2- MBC: 4-5+ years modern era. **Subtype-driven first-line**: 1. **HR+/HER2-**: CDK4/6 inhibitor + AI or fulvestrant — standard 2. **HER2+**: trastuzumab + pertuzumab + taxane (CLEOPATRA); subsequent: T-DXd (trastuzumab deruxtecan — DESTINY-Breast03 superior), T-DM1, tucatinib + capecitabine 3. **Triple-negative**: - PD-L1+: pembrolizumab + chemo (KEYNOTE-355) - BRCA+: olaparib, talazoparib - Other: sacituzumab govitecan (TROP2-ADC), chemo **Re-biopsy at metastasis** — receptor status can change (discordance ~ 20-40%); guides therapy. **CDK4/6 inhibitors** (palbociclib, ribociclib, abemaciclib): - Combined with endocrine — dramatic PFS + OS benefit - Side effects: neutropenia (palbo), QT (ribo), diarrhea (abema) - Monitor CBC, LFTs **PIK3CA mutation** → alpelisib + fulvestrant (SOLAR-1); side effects hyperglycemia, rash. **Antibody-drug conjugates**: - HER2-low (1+, 2+/FISH-): T-DXd (DESTINY-Breast04 — practice-changing) - TROP2: sacituzumab govitecan **Oligometastatic disease**: aggressive local + systemic considered in select; data evolving (SABR-COMET; NRG-BR002). **Bone mets**: bisphosphonate or denosumab + vitamin D/Ca; dental clearance (osteonecrosis of jaw). **Palliative care integration from diagnosis** of metastatic — improves QOL + may improve OS (Temel data). A C D E ผิด — palliative chronic disease model.', NULL,
  'hard', 'hemato_onco', 'review',
  'surgery', 'clinical_decision', 'hemato_onco', 'adult',
  'ABC6 Consensus on Advanced Breast Cancer 2024; NCCN Breast 2024; Finn RS et al. NEJM 2016 (PALOMA-2); Modi S et al. NEJM 2022 (DESTINY-Breast04)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี ผ่า lumpectomy + axillary surgery + radiation + adjuvant therapy for stage II breast cancer 5 ปีก่อน — ทุกอย่างปกติ

Month ago ตรวจ routine surveillance: serum AST 88, ALT 76, ALP 320, GGT 240; CT chest: 2 lung nodules 8-10 mm; CT abdomen: 3 liver lesions 1-2 cm enhancing; tumor markers CEA, CA 15-3 elevated

Biopsy of liver lesion: metastatic adenocarcinoma, ER 80%+, PR 20%+, HER2 0
No brain disease on MRI brain'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 28 ปี testicular swelling + heaviness 4 สัปดาห์ + ไม่ปวด

Exam: 4 cm firm non-tender mass left testis, no transillumination; no inguinal lymphadenopathy
US scrotum: solid hypoechoic mass at left testis; right testis normal
Tumor markers: AFP 88 (elevated), β-hCG 240 (elevated), LDH 540 (elevated)
Staging CT chest/abd: 2 cm retroperitoneal lymph nodes
MRI brain: normal

คำถาม: management of testicular germ cell tumor', '[{"label":"A","text":"Biopsy testis first"},{"label":"B","text":"Testicular germ cell tumor — non-seminoma (markers suggest) — staged management"},{"label":"C","text":"Observation only"},{"label":"D","text":"Scrotal biopsy"},{"label":"E","text":"Radiation only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Testicular germ cell tumor — non-seminoma (markers suggest) — staged management**: (1) **NEVER biopsy testis** — scrotal violation increases recurrence + alters lymphatic drainage; (2) **Radical inguinal orchiectomy** = both diagnostic + therapeutic; inguinal approach (NOT scrotal — for proper lymphatic drainage to retroperitoneal nodes); (3) **Sperm banking PRE-treatment** — chemotherapy + RT + RPLND all can impair fertility; (4) **Staging post-orchiectomy**: - Tumor markers (post-op decline → AFP half-life 5-7 days; β-hCG 24-36 hr) - CT chest/abdomen/pelvis - Brain MRI if symptomatic / advanced; (5) **Histology determination** from orchiectomy specimen: - Pure seminoma vs non-seminoma (NSGCT) - Elevated AFP indicates NSGCT (even if histology ''pure seminoma'' — call NSGCT for treatment) - NSGCT includes: embryonal, yolk sac, choriocarcinoma, teratoma, mixed; (6) **IGCCCG risk stratification** (good/intermediate/poor) — based on markers + mediastinal primary + non-pulmonary visceral mets; (7) **Stage I NSGCT** (clinical disease confined testis after orchiectomy): - Surveillance — preferred (low compliance issues; recurrence ~ 25-30%, salvageable) - Chemo (BEP 1 cycle) — risk-adapted - RPLND (retroperitoneal lymph node dissection) — selective; (8) **Stage II NSGCT** (retroperitoneal nodes): - 3-4 cycles BEP (bleomycin, etoposide, cisplatin) - Post-chemo RPLND for residual mass > 1 cm; (9) **Stage III / metastatic**: BEP 3-4 cycles + post-chemo surgery for residuals; (10) **High cure rates** even in metastatic (> 80% even with poor risk); modern era → testicular Ca curable in vast majority

---

**Testicular germ cell tumor (GCT)** — most common solid tumor in young men (15-35 yr). Highly curable even in advanced stages (modern OS > 95% overall; > 80% in poor-risk metastatic). **Two main types**: 1. **Seminoma** — 50%; radiosensitive + chemosensitive; doesn''t elevate AFP (β-hCG occasionally mildly elevated) 2. **Non-seminoma (NSGCT)** — 50%; embryonal, yolk sac, choriocarcinoma, teratoma, mixed; markers elevated **Tumor markers**: - **AFP** — yolk sac, embryonal; elevation = NSGCT (even if histology pure seminoma) - **β-hCG** — choriocarcinoma, embryonal, some seminomas - **LDH** — non-specific tumor burden indicator **Clinical**: painless testicular mass; back pain (RP nodes); gynecomastia (β-hCG); pulmonary symptoms (mets). **Diagnostic approach**: 1. **US** — confirm intratesticular solid mass 2. **Tumor markers** before + after orchiectomy 3. **Radical inguinal orchiectomy** — NOT scrotal biopsy/orchiectomy (alters lymphatic drainage, increases recurrence) 4. **Staging**: CT chest/abd/pelvis; brain MRI if symptomatic 5. **Sperm banking** before treatment **Staging (TNM)**: - I — testis only - II — retroperitoneal nodes (IIA < 2 cm, IIB 2-5 cm, IIC > 5 cm) - III — distant (lung, brain, liver) **IGCCCG risk** (metastatic): good/intermediate/poor — guides chemotherapy intensity. **Treatment**: - **Stage I Seminoma**: surveillance preferred / carboplatin 1-2 cycles / para-aortic RT - **Stage I NSGCT**: surveillance / 1 cycle BEP / RPLND - **Stage II**: chemo (BEP 3-4 cycles) ± RPLND for NSGCT residuals; RT for seminoma IIA-B - **Stage III**: BEP 3-4 cycles + surgery residuals **BEP** = Bleomycin + Etoposide + Platinum (cisplatin) — backbone for advanced GCT. **Post-chemo surgery (RPLND)**: residual masses ≥ 1 cm in NSGCT (15% necrosis, 40% teratoma, 45% viable GCT). **Long-term issues**: cardiovascular (cisplatin), secondary cancers, hypogonadism, infertility, neuropathy.', NULL,
  'medium', 'renal_gu', 'review',
  'surgery', 'clinical_decision', 'renal_gu', 'adult',
  'NCCN Testicular Cancer 2024; ESMO Testicular Seminoma + NSGCT Guidelines; Albers P et al. Eur Urol', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 28 ปี testicular swelling + heaviness 4 สัปดาห์ + ไม่ปวด

Exam: 4 cm firm non-tender mass left testis, no transillumination; no inguinal lymphadenopathy
US scrotum: solid hypoechoic mass at left testis; right testis normal
Tumor markers: AFP 88 (elevated), β-hCG 240 (elevated), LDH 540 (elevated)
Staging CT chest/abd: 2 cm retroperitoneal lymph nodes
MRI brain: normal

คำถาม: management of testicular germ cell tumor'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Question on physiology + basic science: ผู้ป่วย hypovolemic shock จาก major hemorrhage 2 L blood loss

คำถาม: physiologic responses + management principles', '[{"label":"A","text":"Only IV fluid resuscitation matters"},{"label":"B","text":"Physiology of hemorrhagic shock (ATLS classification)"},{"label":"C","text":"Vasopressor first-line"},{"label":"D","text":"Steroid IV high dose"},{"label":"E","text":"Observation only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Physiology of hemorrhagic shock (ATLS classification)**: - **Class I** < 15% blood loss (< 750 mL): minimal symptoms, normal vitals - **Class II** 15-30% (750-1500 mL): tachycardia, tachypnea, narrowed pulse pressure, anxiety, urine output normal-decreased - **Class III** 30-40% (1500-2000 mL): hypotension, tachycardia, decreased UO, confusion - **Class IV** > 40% (> 2000 mL): profound hypotension, tachycardia, no UO, lethargic/unconscious; **Compensatory mechanisms**: 1. Baroreceptor reflex — ↓ BP → ↑ sympathetic → vasoconstriction + tachycardia + ↑ contractility 2. RAAS activation — angiotensin II vasoconstriction + aldosterone Na/H2O retention 3. ADH (vasopressin) release — water retention 4. Splanchnic + skin vasoconstriction (preserve brain/heart) — pallor, oliguria, ileus 5. Transcapillary refill — fluid from interstitium into intravascular 6. Erythropoietin (delayed) **Modern resuscitation principles**: 1. **Damage control resuscitation** (DCR): - Permissive hypotension (SBP 80-90, avoid in TBI) - Balanced transfusion 1:1:1 PRC:FFP:Plt early (PROPPR trial) - Limit crystalloid (worsens coagulopathy + dilution) - TXA early (CRASH-2 — within 3h reduces mortality) - Avoid hypothermia, acidosis (lethal triad: coagulopathy + hypothermia + acidosis) 2. **Damage control surgery** if unstable: control hemorrhage + contamination, temporary closure, ICU, return for definitive 24-72h 3. **Massive transfusion protocol** activation 4. **Source control** — surgical, IR (angioembolization), endoscopic 5. **Identify shock etiology** — hemorrhagic vs other (cardiogenic, distributive, obstructive); FAST, CT, OR

---

**Hemorrhagic shock physiology + management** — fundamental surgical knowledge. **ATLS hemorrhage classes** — mnemonic by volume %: I (15%), II (30%), III (40%), IV (>40%). Each tier has progressive physiologic compromise. **Compensatory mechanisms** as described — sympathetic (acute), RAAS (intermediate), erythropoiesis (delayed). **Lethal triad of trauma**: coagulopathy + hypothermia + acidosis — synergistically worsens bleeding + outcomes. **Damage control resuscitation (DCR)** — modern paradigm shift from large crystalloid: - Permissive hypotension (caution with TBI — maintain CPP) - Balanced blood product 1:1:1 (PROPPR JAMA 2015) - Limit crystalloid (especially > 1.5 L) - Hemostatic adjuncts: TXA (CRASH-2 Lancet 2010 — early TXA reduces mortality), calcium (citrate binds Ca during transfusion), fibrinogen (cryoprecipitate or concentrate), prothrombin complex - Goal-directed: TEG/ROTEM-guided **Damage control surgery (DCS)** — abbreviated initial operation for control of hemorrhage + contamination + temporary closure (Bogota bag, vacuum) → ICU resuscitation → return for definitive 24-72h. **Massive transfusion**: definition variable (10+ units PRC/24h, 4+ units/hour); MTP activation criteria, fixed ratios; avoid Class IV-induced consumptive coagulopathy. **Endpoints of resuscitation** beyond BP/HR — lactate clearance, base deficit normalization, UO, mental status, mixed venous SvO2. **Adjuncts**: vasopressors (norepi if persistent shock + ongoing resuscitation), TXA, calcium, hypertonic saline (TBI-specific). **Pediatric**: 20 mL/kg crystalloid initial; transfuse after 40 mL/kg failed; weight-based fluid + blood products.', NULL,
  'medium', 'trauma', 'review',
  'surgery', 'basic_science', 'trauma', 'adult',
  'ATLS 10th Edition; Holcomb JB et al. JAMA 2015 (PROPPR); Roberts I et al. Lancet 2010 (CRASH-2); Brohi K et al. Ann Surg 2007', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'Question on physiology + basic science: ผู้ป่วย hypovolemic shock จาก major hemorrhage 2 L blood loss

คำถาม: physiologic responses + management principles'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Question on basic science: surgical wound healing + scar formation

ผู้ป่วย post-operative wound healing — physiology + factors that impact', '[{"label":"A","text":"Wound healing is single-step linear process"},{"label":"B","text":"Wound healing — overlapping phases"},{"label":"C","text":"Only sutures matter"},{"label":"D","text":"Steroids improve healing"},{"label":"E","text":"No relevance to outcomes"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Wound healing — overlapping phases**: (1) **Hemostasis** (immediate): platelet plug + clot + vasoconstriction → vasodilation + chemotactic signals (PDGF, TGF-β); (2) **Inflammation** (24h-7 days): neutrophils (24-48h) → macrophages (48-72h, peak 3-5 days — central role) → lymphocytes; macrophage = orchestrates next phase + secretes growth factors (PDGF, VEGF, FGF); (3) **Proliferation** (day 4 - week 3): - **Granulation tissue** formation: fibroblasts + new ECM + neovascularization (angiogenesis VEGF-driven) - **Epithelialization** — keratinocyte migration from wound edges - **Wound contraction** — myofibroblasts; (4) **Remodeling / maturation** (3 weeks - 1+ year): - Type III collagen → type I collagen - Collagen cross-linking, fibril reorientation along stress lines - Scar maturation — initially red/raised → flatten + pale over months - **Tensile strength**: 3% baseline at 1 wk, 30% at 3 wk, 60% at 4 wk, 80% peak (never 100%); **Factors impairing wound healing**: - Local: infection, necrotic tissue, foreign body, ischemia (poor blood supply, peripheral vascular disease, RT-treated tissue), tension, mechanical disruption - Systemic: malnutrition (protein, vit C, zinc, vit A), diabetes (especially hyperglycemia, glycation, microvascular), smoking (nicotine vasoconstriction + hypoxia), steroid/immunosuppression, chemotherapy, anemia, hypoxia, hypothermia, age - Special: keloid (genetic predisposition — beyond original scar borders, common dark skin, ear/chest/shoulder/upper back), hypertrophic scar (within original wound border); **Optimization principles**: - Pre-op: nutritional repletion, glycemic control, smoking cessation 4 weeks pre + 4 weeks post, optimize medical conditions - Intra-op: aseptic, minimize tissue trauma, hemostasis, tension-free closure - Post-op: clean dressing, monitor infection, nutrition, avoid disruption, manage comorbidities - Advanced wound care: negative pressure wound therapy (NPWT/wound VAC), bioengineered dressings, growth factor (PDGF — becaplermin), hyperbaric O2 for select

---

**Wound healing phases + physiology** — fundamental surgical knowledge: 1. **Hemostasis** (immediate): vasoconstriction, platelet plug, coagulation cascade, clot 2. **Inflammation** (24h-7 days): - Neutrophils (24-48h) — phagocytose bacteria + debris - Macrophages (peak 3-5 days) — central orchestrator; phagocytosis + GF release (PDGF, VEGF, TGF-β, FGF) - Lymphocytes 3. **Proliferation** (day 4 - week 3): - Fibroblast proliferation + collagen deposition (initially type III) - Angiogenesis (VEGF) - Epithelialization (keratinocyte migration from edges) - Contraction (myofibroblasts) 4. **Remodeling** (3 weeks - 1+ year): - Collagen reorganization, type III → type I - Cross-linking, alignment - Scar maturation - Tensile strength: never > 80% of original; 30% at 3 weeks, 80% peak **Local factors impairing healing**: infection, necrosis, ischemia, tension, foreign body, RT, mechanical disruption. **Systemic factors**: malnutrition (protein, micronutrients — vit C, A, zinc), DM (hyperglycemia, glycation), smoking (nicotine vasoconstriction + hypoxia), steroids/immunosuppression (impair inflammation + collagen), chemotherapy, anemia/hypoxia, age, obesity, vasculopathy. **Smoking**: smoking cessation 4 weeks pre + 4 weeks post-operation reduces wound complications dramatically (RCT evidence). **Diabetes**: target HbA1c < 7-8 pre-elective; perioperative glycemic control 140-180 (not too tight). **Wound types + closure**: - Primary intention: clean, sutured immediately - Secondary intention: open, granulate from base (contaminated or after debridement) - Tertiary (delayed primary): initially open, closed days later after contamination resolved **Hypertrophic vs keloid**: hypertrophic stays within wound, regresses; keloid extends beyond, grows, doesn''t regress. **NPWT (vacuum-assisted closure)**: granulation + drainage + perfusion; particularly useful for diabetic ulcer, large wounds, post-debridement.', NULL,
  'easy', 'procedures', 'review',
  'surgery', 'basic_science', 'procedures', 'adult',
  'Surgical Wound Healing Reviews; Velnar T et al. Int Wound J; Sabiston Textbook of Surgery', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'Question on basic science: surgical wound healing + scar formation

ผู้ป่วย post-operative wound healing — physiology + factors that impact'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Basic science / physiology question: blood transfusion + immune reactions

ผู้ป่วยอายุ 50 ปี received PRC 2 units, ภายใน 30 นาทีเริ่มมี fever 38.8°C, chills, urticaria, BP 88/52, dyspnea

คำถาม: transfusion reactions', '[{"label":"A","text":"All transfusion reactions are mild"},{"label":"B","text":"Transfusion reactions — categories + management"},{"label":"C","text":"Continue transfusion regardless"},{"label":"D","text":"Steroid IV for all"},{"label":"E","text":"No monitoring needed"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Transfusion reactions — categories + management**: (1) **Acute hemolytic transfusion reaction (AHTR)** — IgM ABO incompatibility → intravascular hemolysis; fever + chills + back/flank pain + hypotension + hemoglobinuria + DIC; mortality up to 25%; **STOP transfusion immediately**, save bag + tubing, IV fluid, vasopressors, monitor renal function + DIC; (2) **Febrile non-hemolytic transfusion reaction (FNHTR)** — cytokines from donor WBC or anti-HLA Ab; fever + chills only, no hemolysis; treat: stop, antipyretic, leukoreduction prevents; (3) **Allergic / urticarial** — IgE to donor plasma proteins; mild → hives, itch — give antihistamine; severe → anaphylaxis (IgA-deficient recipient with anti-IgA Ab) → STOP, epi, fluid, support, future use washed/IgA-deficient products; (4) **TRALI (Transfusion-Related Acute Lung Injury)** — donor anti-HLA/HNA Ab attack recipient neutrophils + pulmonary endothelium; within 6h of transfusion — bilateral pulmonary edema + hypoxia + fever + hypotension (vs TACO from volume overload); supportive (ventilation, may need ECMO), no diuretic; prevention: predominantly male plasma donors (less alloimmunization from pregnancy); (5) **TACO (Transfusion-Associated Circulatory Overload)** — volume overload, HTN + dyspnea + pulmonary edema, BNP elevated; diuretic; prevention: slow transfusion, monitor volume status especially elderly + cardiac; (6) **Delayed hemolytic transfusion reaction (DHTR)** — anamnestic response to non-ABO antigen days-weeks later; mild hemolysis + anemia + bilirubin rise; prevention: extended Ab screening; (7) **Bacterial contamination** — gram-pos (platelets — room temp storage) or gram-neg; fever + chills + shock within hours; STOP, blood culture, antibiotic; (8) **GVHD (Graft-versus-Host Disease)** post-transfusion — viable donor T cells in immunocompromised recipient; rash + diarrhea + bone marrow failure; prevention: irradiate cellular products for immunocompromised; (9) **Iron overload** — multi-transfused (thalassemia, MDS); chelation (deferasirox, deferoxamine); (10) **Infections** — HIV, HCV, HBV (rare with NAT); CMV (CMV-neg for high-risk), bacterial, prion, emerging pathogens (Zika)

---

**Transfusion reactions** — important surgical knowledge. **Categories**: 1. **Acute hemolytic (AHTR)** — intravascular hemolysis from ABO incompatibility (mostly clerical error); fever, back pain, hemoglobinuria, hypotension, DIC; mortality 10-25%; STOP, supportive, identify error 2. **Febrile non-hemolytic (FNHTR)** — most common (1-3%); cytokines; benign; antipyretic; leukoreduction prevention 3. **Allergic** — urticaria, anaphylaxis (IgA-deficient + anti-IgA); range from mild to severe; antihistamine, epi if anaphylaxis 4. **TRALI** — within 6h, bilateral pulmonary edema + hypoxia, no volume overload features; donor antibody against recipient WBC/HLA; supportive (lung-protective ventilation); modern incidence reduced by male-predominant plasma donor policy 5. **TACO** — volume overload, elderly + cardiac risk; pulmonary edema with HTN + BNP elevation; diuretic 6. **Delayed hemolytic** — non-ABO antigen exposure, anamnestic response 7-14 days later 7. **Bacterial contamination** — platelets (room temp) > RBC; sepsis-like 8. **GVHD** — irradiate products for immunocompromised (BMT, premature, CMV, etc.) 9. **Iron overload** — repeated transfusions 10. **Infection** — HIV/HCV/HBV (very low with NAT screening), CMV, bacterial **Pre-transfusion testing**: ABO/Rh, antibody screen, crossmatch (electronic crossmatch if antibody-negative). **Identification protocol** — 2-person verification at bedside critical to prevent ABO mismatch. **Massive transfusion**: dilutional coagulopathy, hypocalcemia (citrate), hypothermia, hyperkalemia (stored RBC release K), acidosis. **Restrictive transfusion** — Hb 7-8 g/dL trigger (TRICC, TRISS, FOCUS trials) for most stable patients; cardiac 8 g/dL; symptomatic individualized. **Storage**: RBC 42 days refrigerated; platelets 5-7 days room temperature; FFP frozen.', NULL,
  'medium', 'id', 'review',
  'surgery', 'basic_science', 'id', 'adult',
  'AABB Standards for Blood Banks; ASA Practice Guidelines Perioperative Blood Management; Hod EA et al. Transfusion', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'Basic science / physiology question: blood transfusion + immune reactions

ผู้ป่วยอายุ 50 ปี received PRC 2 units, ภายใน 30 นาทีเริ่มมี fever 38.8°C, chills, urticaria, BP 88/52, dyspnea

คำถาม: transfusion reactions'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ระบบ trauma ของจังหวัด — review หลังเกิด earthquake ทำให้มี mass casualty 80 ราย ในเขตจังหวัดที่มี trauma center 1 แห่ง

คำถาม: regional trauma system + disaster response', '[{"label":"A","text":"All patients to single hospital"},{"label":"B","text":"Regional trauma system + disaster response — coordinated multi-level"},{"label":"C","text":"No coordinated response needed"},{"label":"D","text":"Operate on all simultaneously"},{"label":"E","text":"Discharge all home"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Regional trauma system + disaster response — coordinated multi-level**: (1) **Trauma center designation (ACS levels)**: - **Level I**: comprehensive, 24/7 all specialties + research + education; tertiary referral - **Level II**: similar care but no requirement for research; supports Level I - **Level III**: emergency resuscitation + surgical capability; transfer to higher for definitive - **Level IV**: rural; resuscitation + stabilization + transfer - **Level V**: small, transfer all - **Pediatric trauma centers**: dedicated; (2) **Triage + transport** to appropriate level based on severity + capabilities — field triage criteria (CDC 2021): vital signs + anatomy + mechanism + special considerations (age, anticoagulation, pregnancy); (3) **Inter-facility transfer protocols** — direct from scene to highest appropriate; secondary transfer if higher level needed; (4) **Disaster preparedness**: - **Incident Command System (ICS)** - **Unified command** for multi-agency response - **Mutual aid agreements** between regions - **Resource sharing** (personnel, supplies, transport) - **Triage in mass casualty**: START (adult), JumpSTART (pediatric), SALT — see prior - **Surge capacity** planning: convert non-clinical space, additional staff, supply caching - **Communication** redundant systems; (5) **Disaster phases**: - **Preparedness** — drills, plans, training - **Response** — activation, triage, treatment, evacuation - **Recovery** — return to normal operations, debrief, mental health - **Mitigation** — lessons learned, system improvement; (6) **Mental health**: psychological first aid, debriefing teams, long-term PTSD support for survivors + responders; (7) **Public health integration**: epidemiology, surveillance, communicable disease prevention; (8) **Special populations**: pediatric, elderly, pregnant, disabled, prisoners — pre-planned protocols

---

**Regional trauma system** — designed for optimal outcomes through tiered care + appropriate routing. **ACS Committee on Trauma — Verification + Levels**: - **Level I**: full-spectrum, research, education; usually academic - **Level II**: comprehensive care, no research requirement - **Level III**: surgical + ED capability + transfer for higher - **Level IV-V**: stabilization + transfer **Field triage** (CDC 2021 criteria) — 4-step decision: 1. Physiologic: GCS ≤ 13, SBP < 90 (or < 110 elderly), RR < 10 or > 29 → transport to highest level 2. Anatomic: penetrating to head/neck/torso/extremity proximal, flail, > 2 long bone fractures, paralysis, amputation, pelvic, open/depressed skull, mangled limb 3. Mechanism: falls, high-risk MVC, auto-pedestrian, motorcycle 4. Special: age extremes, anticoagulation, burn, pregnancy, EMS judgment **Mass Casualty Incident (MCI)** management: - Triage systems (START, SALT, JumpSTART) - ICS command structure - Hospital disaster plan activation - Surge capacity (staff, space, supplies) - Mutual aid - Inter-facility transfer - Resource allocation ''greatest good for greatest number'' **System outcomes**: trauma systems reduce mortality 20-25% (MacKenzie NEJM 2006 + others). **Pediatric trauma centers**: dedicated pediatric or pediatric capability within adult trauma center; lower mortality in dedicated pediatric centers for severely injured children. **Quality improvement**: trauma registry (NTDB, ITR), morbidity + mortality conferences, performance improvement, evidence-based protocols (massive transfusion, REBOA criteria, TXA, etc.). **Disaster recovery + mental health**: post-incident debriefing, psychological first aid (PFA), long-term PTSD support for victims, families, and first responders — vital component often under-resourced.', NULL,
  'medium', 'trauma', 'review',
  'surgery', 'ems_mgmt', 'trauma', 'adult',
  'ACS Resources for Optimal Care of the Injured Patient (Orange Book); CDC Field Triage Criteria 2021; MacKenzie EJ et al. NEJM 2006', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ระบบ trauma ของจังหวัด — review หลังเกิด earthquake ทำให้มี mass casualty 80 ราย ในเขตจังหวัดที่มี trauma center 1 แห่ง

คำถาม: regional trauma system + disaster response'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 78 ปี end-stage GBM (glioblastoma) post-WBRT + TMZ + Bev failed, now ECOG 3, ปวด headache + cognitive decline + symptomatic dehydration; family meeting requested

คำถาม: end-of-life + palliative integration', '[{"label":"A","text":"Aggressive chemotherapy 3rd line"},{"label":"B","text":"End-of-life palliative care — integrated approach"},{"label":"C","text":"Continue aggressive curative therapy"},{"label":"D","text":"Discharge home without follow-up"},{"label":"E","text":"Surgery for primary tumor"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **End-of-life palliative care — integrated approach**: (1) **Goals of care discussion** — family meeting with patient (if capacitated) + family + multidisciplinary team: clarify prognosis (likely weeks), patient values, preferences for treatment; (2) **Honor patient autonomy** — advance directive review; healthcare proxy/surrogate decision-maker if patient lacks capacity; (3) **Hospice eligibility** assessment — Medicare criteria: life expectancy ≤ 6 months if disease takes usual course; focus on comfort vs cure; (4) **Symptom management**: - **Pain**: WHO analgesic ladder; chronic opioids titrate; methadone for refractory; consider rotation; coadjuvants (NSAID, steroid, anticonvulsant for neuropathic) - **Dyspnea**: oxygen, opioid (low-dose morphine — central effect), fan, positioning, anxiolytic - **Nausea**: identify cause; haloperidol, metoclopramide, ondansetron - **Constipation** (opioid-induced): laxative regimen prophylactic - **Delirium**: identify reversible cause; haloperidol, olanzapine; non-pharmacologic - **Anxiety/agitation**: benzodiazepine selective - **Secretions** (''death rattle''): glycopyrrolate, scopolamine - **Seizures**: anti-epileptic (levetiracetam if not already), benzodiazepine acute; (5) **Hydration / nutrition at end of life**: - Artificial hydration controversial — may worsen secretions, edema, decrease comfort - Family education + meticulous mouth care critical (more comfort than IV fluid) - Tube feeding: not beneficial in advanced disease (no survival improvement, complications); (6) **Discontinue non-beneficial therapy**: stop chemotherapy, antibiotics (depending on goals), labs, imaging — focus on comfort; (7) **Spiritual + cultural support**: chaplain, family rituals, cultural practices respected; (8) **Family support**: anticipatory grief, communication, respite, social work, financial support; (9) **Caregiver wellbeing** — burden, mental health, support; (10) **After death**: bereavement support 1+ years; legacy work; (11) **Care location**: hospice (inpatient unit, residential), home with hospice services, hospital — patient/family preference + capabilities

---

**End-of-life palliative care + hospice** — essential domain of medical practice. **Palliative care** vs **hospice**: - Palliative care: any stage of serious illness, alongside curative therapy; symptom management + QoL; specialty consult or primary palliative - Hospice: end-of-life (typically expected < 6 months); comfort-focused; Medicare benefit in US **Goals of care conversation principles** (e.g., SPIKES, NURSE)**: - Setting: appropriate environment, private, allow time - Perception: assess understanding - Invitation: ask permission - Knowledge: deliver in chunks, avoid jargon - Empathy: acknowledge emotions - Summary + strategy: clarify next steps **Symptom management at end of life**: 1. Pain — opioid mainstay; tolerance manageable; methadone for complex 2. Dyspnea — opioid + anxiolytic; non-pharm (fan, position) 3. Nausea — identify cause; haloperidol, metoclopramide, ondansetron 4. Constipation — prophylactic laxative regimen for any patient on opioid 5. Delirium — identify reversible (infection, dehydration, metabolic, drug); haloperidol, olanzapine; benzodiazepine only if anxiety predominant (paradoxical worse delirium otherwise) 6. Secretions — glycopyrrolate, scopolamine 7. Seizures, agitation, anxiety — symptom-specific **Hydration + nutrition at end of life**: artificial hydration and feeding generally don''t improve comfort or survival in advanced disease; family education + meticulous mouth care. Decision based on goals + patient preference. **Withdrawal of life-sustaining therapy**: ventilator, dialysis, antibiotics — ethical + legal (autonomy + beneficence); proper symptom control during withdrawal (opioid, benzo for dyspnea/anxiety). **Discontinuation of non-beneficial therapy** distinct from euthanasia/assisted suicide. **Bereavement support**: anticipatory grief, post-death follow-up, complicated grief screening. **Communication** with team + family: ongoing, consistent, sensitive.', NULL,
  'easy', 'hemato_onco', 'review',
  'surgery', 'ems_mgmt', 'hemato_onco', 'adult',
  'WHO Palliative Care Definition; AAHPM Hospice Care Guidelines; Temel JS et al. NEJM 2010 (Early Palliative Care); ASCO Palliative Care Integration', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ผู้ป่วยอายุ 78 ปี end-stage GBM (glioblastoma) post-WBRT + TMZ + Bev failed, now ECOG 3, ปวด headache + cognitive decline + symptomatic dehydration; family meeting requested

คำถาม: end-of-life + palliative integration'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 35 ปี IV drug user มาด้วยไข้ + back pain 2 สัปดาห์ + ปวดหลังรุนแรง + paraparesis lower limbs 1 วัน + bladder dysfunction

VS: BP 102/68, HR 102, Temp 38.6°C
Motor: lower limb 2/5, sensory loss below T8, bladder distended

Lab: WBC 16,800, CRP 240, blood culture growing S. aureus MSSA
MRI spine: T7-T8 epidural abscess + vertebral osteomyelitis + cord compression', '[{"label":"A","text":"Antibiotic alone outpatient"},{"label":"B","text":"Spinal epidural abscess + osteomyelitis + cord compression — urgent neurosurgical + medical"},{"label":"C","text":"Observation only"},{"label":"D","text":"Steroid IV only"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Spinal epidural abscess + osteomyelitis + cord compression — urgent neurosurgical + medical**: (1) **Immediate consultation**: neurosurgery, infectious disease, internal medicine; (2) **MRI confirms**: location, extent, cord compression, vertebral involvement; (3) **Urgent surgical decompression** indicated for: - Neurological deficit (this patient has paraparesis + bladder dysfunction) — emergent within hours to optimize recovery - Failure of antibiotic therapy - Progressive disease - Pus/abscess that needs drainage; (4) **Surgical approach**: laminectomy + decompression + drainage + tissue culture + send for histology; debridement of necrotic vertebral bone if needed; spinal stabilization if mechanical instability; (5) **IV antibiotic** — initially broad-spectrum then targeted: - MRSA cover: vancomycin (or daptomycin); MSSA: nafcillin/cefazolin - Gram-negative cover: depending on risk (cefepime, piperacillin-tazobactam) - 4-8 weeks IV typically; longer if osteomyelitis (6-12 weeks); de-escalate per cultures; (6) **IV drug use complications**: - Endocarditis surveillance (echo) — same patient at high risk - HIV, HCV, HBV screening - Other infectious complications (septic pulmonary emboli, joint infection); (7) **Addiction medicine**: refer for medication-assisted treatment (methadone, buprenorphine), harm reduction, social work, psychiatry, peer support; (8) **Rehabilitation**: PT, OT, bladder management, mobility, vocational; long-term spinal cord injury care; (9) **Long-term**: spinal surveillance, anti-coagulation if VTE, prevention of decubitus ulcers, bladder/bowel program, mental health; (10) **Public health**: linkage to needle exchange, harm reduction, social services

---

**Spinal epidural abscess (SEA)** — relatively rare but serious; incidence increasing with IVDU + diabetes + immunocompromise. **Classic triad** (only ~10% present with all): - Fever - Back pain - Neurological deficit (in stages — radiculopathy → motor weakness → paralysis with bladder/bowel dysfunction) **Risk factors**: IVDU, DM, immunocompromise, alcoholism, recent spinal procedure (epidural, surgery), distant infection (endocarditis, skin, urinary), age **Pathogens**: - Staphylococcus aureus (60-70% — including MRSA in many regions, MSSA in this case) - Gram-negative (E. coli, Pseudomonas — IVDU, UTI) - Streptococcus - TB (Pott''s disease) — endemic regions, chronic presentation **Diagnosis**: clinical + MRI with contrast (gold standard); CT myelogram alternative; CT-guided biopsy if blood cultures negative. **Management**: 1. **Surgical decompression** indicated for: - Neurological deficit (any) - Progression of neuro deficit despite antibiotics - Failure of medical therapy - Abscess > 50% canal compression - Large abscess - Vertebral instability 2. **Conservative (antibiotic alone)** considered in: - No neuro deficit - Identified organism - Small abscess - Reliable patient + close monitoring 3. **IV antibiotic** 4-8 weeks (longer if osteomyelitis); empiric: vanco + ceftriaxone (or anti-Pseudomonal cefepime/pip-tazo); de-escalate per culture **Neurological recovery**: depends on duration + severity of deficit pre-decompression; early surgery (< 24h ideally) optimizes recovery. **IVDU integrative care**: medication-assisted treatment (methadone, buprenorphine), harm reduction (clean needles, naloxone), HIV/HCV testing + treatment, mental health, social services, peer support. Treating addiction alongside acute infection essential to prevent recurrence + maximize long-term outcomes.', NULL,
  'hard', 'id', 'review',
  'surgery', 'integrative', 'id', 'adult',
  'IDSA Native Vertebral Osteomyelitis Guidelines 2015; Reihsaus E et al. Neurosurg Rev; Darouiche RO. NEJM 2006', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ผู้ป่วยอายุ 35 ปี IV drug user มาด้วยไข้ + back pain 2 สัปดาห์ + ปวดหลังรุนแรง + paraparesis lower limbs 1 วัน + bladder dysfunction

VS: BP 102/68, HR 102, Temp 38.6°C
Motor: lower limb 2/5, sensory loss below T8, bladder distended

Lab: WBC 16,800, CRP 240, blood culture growing S. aureus MSSA
MRI spine: T7-T8 epidural abscess + vertebral osteomyelitis + cord compression'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี post-Whipple 6 เดือน + adjuvant chemotherapy completed, pancreatic adenocarcinoma R0 resection, stage II

Now มาด้วยอาการ DM control deteriorating (HbA1c 9.5, was 7.2 pre-op), steatorrhea, weight loss 8 kg, fatigue

Lab: glucose 280 fasting, fecal elastase 70 (low — severe exocrine insufficiency)

คำถาม: integrative management', '[{"label":"A","text":"Standard DM management only"},{"label":"B","text":"Post-Whipple integrative survivorship — pancreatic insufficiency + diabetes type 3c + nutritional + surveillance"},{"label":"C","text":"Refer to hospice immediately"},{"label":"D","text":"Restart chemotherapy alone"},{"label":"E","text":"No follow-up needed"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Post-Whipple integrative survivorship — pancreatic insufficiency + diabetes type 3c + nutritional + surveillance**: (1) **Pancreatic exocrine insufficiency (PEI)** — diagnosed by low fecal elastase + steatorrhea: - **Pancreatic Enzyme Replacement Therapy (PERT)** — pancrelipase 25,000-50,000 units lipase per meal, 10,000-25,000 per snack; titrate symptoms + weight; take with meals; - Fat-soluble vitamin (ADEK) supplementation - Smaller more frequent meals - Avoid very-high-fat meals - PPI as adjunct (acid reduces enzyme efficacy if uncoated); (2) **Pancreatogenic DM (Type 3c)** — distinct from type 1 + 2: - Insulin deficiency + impaired glucose counter-regulation (loss of glucagon-producing alpha cells) - Brittle DM — hypoglycemia + hyperglycemia variability - Treatment: insulin often required; metformin OK; SGLT2 (caution DKA in low insulin reserve); GLP-1 (caution — slow gastric emptying may worsen if post-Whipple GI changes); - Close glucose monitoring (CGM helpful); educate hypoglycemia awareness, glucagon kit; (3) **Nutritional optimization**: dietitian, high-calorie + high-protein + portioned, vitamin/mineral supplementation comprehensive (vit ADEK, B12 if total gastrectomy, iron, calcium); body composition + sarcopenia surveillance; (4) **Cancer surveillance**: per NCCN — CT chest/abd q3-6 mo × 2 yr, then q6 mo × 3 yr, then annual; CA 19-9 if elevated initially; (5) **Late toxicity monitoring**: cardiac (gemcitabine, 5-FU), renal (oxaliplatin), neuropathy (oxali — chronic), secondary cancer; (6) **Psychosocial**: depression, anxiety, fear of recurrence common; support groups, mental health, social work; (7) **Lifestyle**: smoking cessation, moderate alcohol, regular exercise, sleep, vaccination (pneumococcal, influenza, COVID); (8) **Family + genetic**: 10-15% pancreatic Ca have hereditary component (BRCA, Lynch, PALB2, ATM, CDKN2A, PRSS1); genetic counseling for proband + family; (9) **Survivorship care plan** written summary + transitions; (10) **Bone health**: DEXA, calcium + vit D, weight-bearing exercise — PEI + chemo + DM all impair

---

**Post-pancreaticoduodenectomy (Whipple) survivorship** — complex integrative care. **Pancreatic exocrine insufficiency (PEI)**: - Diagnosis: fecal elastase < 200 (< 100 severe); clinical (steatorrhea, weight loss) - Treatment: PERT (pancrelipase) — 25-50k units lipase/meal, dose-adjusted; with meals (not after); enteric-coated PPI as adjunct - Untreated PEI: weight loss, malnutrition, fat-soluble vitamin deficiency (ADEK), osteoporosis, decreased QoL **Pancreatogenic DM (Type 3c)**: - Distinct from type 1/2 - Insulin + glucagon deficiency → brittle, variable - Often requires insulin - CGM helpful for variability - SGLT2 caution DKA risk; GLP-1 caution GI side effects + delayed emptying - Hypoglycemia awareness education + glucagon kit **Nutritional surveillance + optimization**: - Dietitian early + ongoing - High-calorie, high-protein, small frequent - Vitamin/mineral supplementation - Body composition + sarcopenia screening - Address dumping/dysmotility if Roux reconstruction **Cancer surveillance** per NCCN — risk of recurrence (local, regional, distant — liver, lung, peritoneum), second primary. **Genetic testing**: increasingly indicated — BRCA1/2 (PARP inhibitor olaparib if metastatic), PALB2, ATM, Lynch syndrome (MSI-H → immunotherapy), CDKN2A, PRSS1 (familial). Family screening if positive. **Late effects of treatment**: chemotherapy long-term (cardiotoxicity, neuropathy, fatigue, secondary cancer), radiation (rare in pancreatic Ca), psychological. **Survivorship care plan** — IOM recommendation: written summary + ongoing surveillance + transition. **Multidisciplinary survivorship clinic**: oncology, endocrinology, nutrition, mental health, primary care, IR/surgery as needed.', NULL,
  'hard', 'hemato_onco', 'review',
  'surgery', 'integrative', 'hemato_onco', 'adult',
  'NCCN Pancreatic Adenocarcinoma 2024 + Survivorship; ASCO Pancreatic Survivorship; Permert J et al. Pancreatology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี post-Whipple 6 เดือน + adjuvant chemotherapy completed, pancreatic adenocarcinoma R0 resection, stage II

Now มาด้วยอาการ DM control deteriorating (HbA1c 9.5, was 7.2 pre-op), steatorrhea, weight loss 8 kg, fatigue

Lab: glucose 280 fasting, fecal elastase 70 (low — severe exocrine insufficiency)

คำถาม: integrative management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 55 ปี smoker, alcoholic chronic มาด้วยอาการ severe vomiting ตามมาด้วย hematemesis 800 mL ใน 2 ชั่วโมง + chest pain + subcutaneous emphysema ที่คอ

VS: BP 92/58, HR 124, RR 24, Temp 37.6°C, SpO2 91%
Chest: subcutaneous emphysema bilateral neck + supraclavicular, decreased breath sound left base
CXR: pneumomediastinum + left pleural effusion + subdiaphragmatic free air absent
CT chest with contrast oral: contrast extravasation at distal esophagus left side + pneumomediastinum', '[{"label":"A","text":"PPI alone"},{"label":"B","text":"Boerhaave syndrome (spontaneous esophageal rupture) — surgical emergency"},{"label":"C","text":"Observation"},{"label":"D","text":"Heimlich maneuver"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Boerhaave syndrome (spontaneous esophageal rupture) — surgical emergency**: (1) **Stabilize**: 2 large-bore IV, type & cross, NPO, IV antibiotic (broad-spectrum covering oral + gram-neg + anaerobes — pip-tazo OR cefepime + metronidazole + vanco), PPI IV; (2) **Antifungal** if delayed presentation (Candida); (3) **Operative timing critical** — outcomes best with intervention within 24h: - **Early < 24h**: **primary repair** (left thoracotomy if distal esophagus most common; right thoracotomy for mid-esophagus) — debride necrotic edges, primary closure in 2 layers, reinforce with pleural/intercostal muscle flap, wide drainage; - **Delayed > 24h or unstable**: consider **esophageal exclusion + diversion** (cervical esophagostomy + gastrostomy or jejunostomy + drainage) — staged reconstruction later vs **damage control with drainage + T-tube**; (4) **Endoscopic management** alternative for contained perforations / poor surgical candidates: covered esophageal stent + drainage + antibiotic; success in selected cases; (5) **Postop**: NPO + drainage 7-14 days, contrast study before resuming intake, nutrition (NJ tube past site, or TPN); (6) **Mortality** very high if delayed (50-70%); early 10-20%; (7) **Underlying cause** consideration (achalasia, esophageal cancer, Barrett''s, foreign body)

---

**Esophageal perforation** — surgical emergency, high mortality. Causes: 1. **Iatrogenic** (most common 60%) — endoscopy (especially with intervention), dilation, biopsy 2. **Spontaneous (Boerhaave syndrome)** — forceful vomiting against closed glottis (Mackler triad: vomiting + chest pain + subcutaneous emphysema); usually distal left posterolateral esophagus; alcohol common precipitant 3. **Foreign body, food impaction** — straining 4. **Trauma** — penetrating, blunt, ingestion (lye, acid) 5. **Malignancy** — tumor rupture **Locations**: cervical (after instrumentation usually), thoracic (Boerhaave + iatrogenic), abdominal (after fundoplication etc.). **Diagnosis**: - CXR — pneumomediastinum, pleural effusion, subcutaneous emphysema - Esophagram with water-soluble contrast (Gastrografin), follow with barium if negative + high suspicion (barium more sensitive but more reactive in pleura) - CT with oral contrast — increasingly used, sensitive **Management principles**: 1. NPO, NG decompression carefully (or avoid in suspected upper perforation) 2. IV broad-spectrum antibiotic + antifungal 3. PPI IV 4. Source control — surgical or endoscopic 5. Drainage — pleural, mediastinal 6. Nutrition — TPN or distal enteral (NJ past leak) **Surgical options**: - Primary repair < 24h — best outcomes; reinforce with flap - Exclusion + diversion — delayed presentation, sepsis, friable - Esophagectomy — selected with malignancy / chronic damage - Damage control — T-tube, wide drainage **Endoscopic stenting** + drainage — emerging alternative for selected (contained perforation, surgical risk, recent post-bariatric leak). **Pittsburgh perforation severity score** — helps stratify. **Outcomes** strongly time-dependent: < 24h ~ 10-15% mortality; > 24h 30-50%; > 48h up to 70%.', NULL,
  'hard', 'gi', 'review',
  'surgery', 'clinical_decision', 'gi', 'adult',
  'SAGES Guidelines Esophageal Perforation; Brinster CJ et al. Ann Thorac Surg; Schweigert M et al. World J Surg', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 55 ปี smoker, alcoholic chronic มาด้วยอาการ severe vomiting ตามมาด้วย hematemesis 800 mL ใน 2 ชั่วโมง + chest pain + subcutaneous emphysema ที่คอ

VS: BP 92/58, HR 124, RR 24, Temp 37.6°C, SpO2 91%
Chest: subcutaneous emphysema bilateral neck + supraclavicular, decreased breath sound left base
CXR: pneumomediastinum + left pleural effusion + subdiaphragmatic free air absent
CT chest with contrast oral: contrast extravasation at distal esophagus left side + pneumomediastinum'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 28 ปี post-laparoscopic appendectomy 4 ชั่วโมง วันนี้ มาด้วยปวดท้อง + tachycardia + ill-looking

VS: BP 88/52, HR 132, Temp 38.0°C
Abdomen: distended, tender; bedside US: large free fluid + drop in Hb 2 g/dL from preop

คำถาม: management', '[{"label":"A","text":"Observation"},{"label":"B","text":"Postoperative intra-abdominal bleeding — emergent re-exploration"},{"label":"C","text":"Antibiotic only"},{"label":"D","text":"Observation 24 hr"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Postoperative intra-abdominal bleeding — emergent re-exploration**: (1) **Immediate resuscitation**: 2 large-bore IV, type & cross, MTP activation if ongoing instability; (2) **Emergent return to OR**: laparoscopic or open re-exploration — identify + control bleeding source: - Common sites post-appendectomy: appendiceal stump, mesoappendix vessel slip, trocar site, omental vessel - Inspect systematically + control hemorrhage; (3) **CT abdomen** if hemodynamically stable + diagnosis unclear (not for unstable — delay = more bleeding); (4) **IR angioembolization** alternative if isolated arterial source + stable + IR available — selected; (5) **Blood products**: PRC, FFP, platelets balanced (1:1:1); TXA consider (acute hemorrhage within 3h); (6) **Postop**: ICU, monitor for ongoing bleeding, coagulopathy management, antibiotic continue; (7) **Lessons learned + M&M conference** — review technique, prevention; (8) **Other postop differentials** — anastomotic leak (less common in appendectomy), missed injury, retained foreign body, surgical site infection — workup as needed

---

**Postoperative bleeding** — important early surgical complication. **Sources** vary by procedure: - Laparoscopic appendectomy: mesoappendix vessel slip, appendiceal stump, trocar site (epigastric), retroperitoneum - Laparoscopic cholecystectomy: cystic artery slip, liver bed - Bariatric: staple line, mesentery - Hemicolectomy: anastomotic, mesentery, retroperitoneum - Hepatic resection: cut surface oozing, hepatic vein/IVC injury - Splenectomy: short gastric, splenic hilum, raw surface **Clinical signs**: tachycardia (early), hypotension, drop in Hb, distention, increased drain output (sanguineous), oliguria. **Diagnosis**: 1. Clinical + vital trend 2. CT angiography — if stable + identify source 3. Bedside US (FAST) — free fluid 4. Diagnostic laparoscopy if unclear 5. Angiogram + embolization — selected (single arterial source, stable enough) **Management**: - Stable + identified focal arterial source → IR embolization - Unstable or diffuse bleeding → return to OR — laparoscopic or open exploration - Balanced resuscitation (avoid massive crystalloid) - Correct coagulopathy if present - TXA within 3h of hemorrhage (CRASH-2 — surgical patients may benefit similarly) **Specific concerns**: - Hemodynamic instability after recent operation = bleeding until proven otherwise - Time-sensitive — delay → consumptive coagulopathy + worsening shock - Don''t be falsely reassured by initial vitals (compensation) - Trend matters more than single value Prevention: meticulous hemostasis, secure ligation of vessels (clips, energy device, staples, suture), inspect at end of procedure, postop monitoring.', NULL,
  'easy', 'trauma', 'review',
  'surgery', 'clinical_decision', 'trauma', 'adult',
  'ACS Surgery Principles + Practice; ACS NSQIP Complications Database; Mariani A et al. World J Surg', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 28 ปี post-laparoscopic appendectomy 4 ชั่วโมง วันนี้ มาด้วยปวดท้อง + tachycardia + ill-looking

VS: BP 88/52, HR 132, Temp 38.0°C
Abdomen: distended, tender; bedside US: large free fluid + drop in Hb 2 g/dL from preop

คำถาม: management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 45 ปี post-thyroidectomy total 8 ชั่วโมง — มา ED ด้วยอาการ stridor + dyspnea + neck swelling progressive + ผิวเป็นสีฟ้า

VS: BP 96/62, HR 132, RR 32, SpO2 86%
Neck: large hematoma ขนาด > 8 cm + skin tension + tracheal deviation; drain output minimal

คำถาม: emergent management', '[{"label":"A","text":"Observation + steroid"},{"label":"B","text":"Post-thyroidectomy expanding cervical hematoma with airway compromise — true surgical emergency"},{"label":"C","text":"Wait for OR availability"},{"label":"D","text":"Diuretic alone"},{"label":"E","text":"Antibiotic only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Post-thyroidectomy expanding cervical hematoma with airway compromise — true surgical emergency**: (1) **Immediate bedside intervention** — DO NOT wait for transport to OR: a. **Open the wound + evacuate hematoma at bedside** — release skin sutures + remove staples + open strap muscles to relieve compression; this can be life-saving; ENT consult emergency; b. Simultaneously secure airway — call anesthesia for emergent intubation (anticipate difficult — laryngeal + tracheal edema + distortion); (2) **Then transport to OR**: re-exploration + identify bleeding source (often superior thyroid artery branch, vein) + ligate + irrigation; (3) **Avoid** delays for imaging; (4) **Anesthesia considerations**: difficult airway anticipated — awake fiberoptic intubation if possible; surgical airway (tracheostomy or cricothyroidotomy) ready; succinylcholine + RSI riskier (airway loss may be unrecoverable); (5) **Post-op**: ICU, monitor for re-bleed, calcium (hypoparathyroidism), recurrent laryngeal nerve function (voice), respiratory; (6) **Hospital protocols** — many institutions have ''neck hematoma kit'' at bedside post-thyroid/parathyroid surgery for immediate use; preventive education for staff; (7) **Risk factors**: HT, anticoagulation, larger thyroid, Graves, surgeon experience, drain malfunction; (8) **Prevention**: meticulous hemostasis, valsalva test at end of surgery, controlled BP postop, prophylactic placement of drain not proven to prevent

---

**Post-thyroidectomy neck hematoma with airway compromise** — life-threatening complication (incidence 1-2%, peak first 6-24h). Pathophysiology: bleeding within confined neck space → tracheal compression + venous congestion + laryngeal edema → airway obstruction. Edema from venous obstruction worsens even after hematoma evacuated. **Recognition signs**: - Neck swelling (rapid) - Stridor, dyspnea - Anxiety, restlessness - Drain malfunction or sudden bleeding through drain - Tracheal deviation **Critical principle**: OPEN THE WOUND IMMEDIATELY AT BEDSIDE — do not wait for OR transport. Releases pressure + relieves obstruction. **Steps**: 1. Remove skin sutures/staples 2. Open platysma + strap muscles 3. Evacuate clot 4. Compress vessel if accessible 5. Concurrent airway management — anesthesia anticipate difficult airway 6. Then OR for definitive control **Difficult airway anticipated**: - Tissue distortion + edema + bleeding obscure landmarks - Awake fiberoptic intubation preferred if time permits - RSI risky — failure may be unrecoverable - Surgical airway (cricothyroidotomy, tracheostomy) backup readily available **Prevention + protocols**: - Meticulous intraoperative hemostasis - Valsalva test before closure - BP control postop - Bedside ''neck hematoma kit'' (suture removers, scissors, gauze, hemostat) at high-volume centers - Staff education + drills - Drain placement: controversial, doesn''t reliably prevent **Post-op monitoring**: q15 min × 2h, then q30 min × 4h, then less frequent; early mobilization OK but careful HD control. **Other thyroidectomy complications** (recap): - Recurrent laryngeal nerve injury (1-2% transient, 1% permanent) — hoarseness, voice change - Hypocalcemia (10-30% transient, 1-3% permanent) - Hematoma (1-2%) - Wound infection, scar.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'surgery', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'AAES Thyroid Surgery Guidelines; Liu J et al. Am J Surg; Promberger R et al. Br J Surg (Hematoma)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 45 ปี post-thyroidectomy total 8 ชั่วโมง — มา ED ด้วยอาการ stridor + dyspnea + neck swelling progressive + ผิวเป็นสีฟ้า

VS: BP 96/62, HR 132, RR 32, SpO2 86%
Neck: large hematoma ขนาด > 8 cm + skin tension + tracheal deviation; drain output minimal

คำถาม: emergent management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี ผ่า colorectal cancer 6 weeks ago, completed adjuvant chemo. CEA rising 8 → 22 → 56 within 3 months; CT thorax/abdomen pelvis: 3 cm liver mass segment VI + no other disease; PET: SUV 11 liver + no extrahepatic

Liver function normal, performance status 1

คำถาม: management of metachronous liver metastasis', '[{"label":"A","text":"Palliative chemotherapy alone"},{"label":"B","text":"Resectable solitary metachronous liver metastasis — potentially curative resection"},{"label":"C","text":"Refuse all treatment"},{"label":"D","text":"Total colectomy again"},{"label":"E","text":"TACE alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Resectable solitary metachronous liver metastasis — potentially curative resection**: (1) **Multidisciplinary tumor board** — hepatobiliary surgery, medical oncology, radiation oncology, IR, gastroenterology; (2) **Assessment of resectability**: - Anatomic — segment VI lesion isolated, future liver remnant adequate (> 25-30% if normal, > 40% if chemo-injured) - Biological — disease-free interval, response to prior chemo, molecular markers (RAS, BRAF) - Patient factors — fitness, comorbidity; (3) **Approach options**: a. **Perioperative chemotherapy** (EPOC paradigm — 3 cycles pre + 3 cycles post) — FOLFOX +/- biologic (cetuximab if RAS WT + left-sided) — debated benefit; b. **Upfront resection** — for isolated technically straightforward + already had adjuvant; c. **Two-stage hepatectomy / ALPPS / PVE** — for inadequate FLR with bilobar disease; (4) **Surgical resection** — segmentectomy VI (parenchymal-sparing) or wedge resection with negative margin (1 cm ideal but R0 critical, mm-margins acceptable in modern era); minimally invasive (laparoscopic / robotic) increasingly used; (5) **Adjuvant chemotherapy** — modified FOLFOX-6 × 6 mo (or completing 12 cycles total perioperative) — based on response + tolerability; (6) **Alternative if not surgical candidate**: thermal ablation (RFA, MWA) — for tumors ≤ 3 cm; comparable to resection in small lesions per recent data; SBRT alternative; (7) **Surveillance**: CEA + CT q3 mo × 2 yr, then q6 mo; colonoscopy 1 yr post-resection of primary, then per surveillance; (8) **Repeat resection** for recurrence acceptable in selected — 5-yr survival 30-40% after second liver resection; (9) **Outcomes**: 5-yr OS resected liver mets ~ 30-50%; vs 5-yr OS unresected metastatic CRC < 10%

---

**Liver metastases from colorectal cancer (CRLM)** — 50% of CRC patients develop liver mets; subset resectable + potentially curable. **Resectability assessment**: - Anatomic — adequate FLR after resection (> 25-30% normal liver, > 40% chemo-injured/cirrhotic); R0 margin achievable; preserve sufficient vascular + biliary supply to remnant - Biological — disease-free interval, response to chemo, tumor markers - Patient — fitness, comorbidity **Key concepts**: 1. **Synchronous** (present at primary dx) vs **metachronous** (develops later) — both can be resected with curative intent 2. **Resectable from outset**: upfront or perioperative chemo + resection 3. **Initially unresectable but converted** with chemo: chemo response → resection 4. **Borderline / technically unresectable but biology favorable**: aggressive approach with two-stage hepatectomy, ALPPS, portal vein embolization (PVE), liver vein embolization (LVE) **Modern paradigm shifts**: - Parenchymal-sparing resection > major hepatectomy when oncologically equivalent (preserve future re-resectability) - Margin: R0 critical but mm-margins acceptable (resection margin > 0 mm), wider not necessary - Two-stage hepatectomy + PVE for bilobar disease with inadequate FLR - ALPPS (Associating Liver Partition + Portal Vein Ligation for Staged Hepatectomy) — rapid hypertrophy alternative - Minimally invasive (lap/robotic) liver resection — increasingly mainstream **Adjunctive ablation** (RFA, MWA): for small (≤ 3 cm) lesions + complementary in combination with resection. **Adjuvant chemotherapy** post-resection — improves DFS (EPOC), OS controversial; typically 6 months total perioperative or adjuvant. **Outcomes**: 5-yr OS post-resection ~ 30-50% (vs < 10% non-resected metastatic). Repeat resection feasible + reasonable outcomes if recurrent isolated. **Multidisciplinary** essential — outcomes better in dedicated HPB centers.', NULL,
  'medium', 'hemato_onco', 'review',
  'surgery', 'clinical_decision', 'hemato_onco', 'adult',
  'NCCN Colon Cancer 2024; Nordlinger B et al. Lancet 2013 (EPOC); Vauthey JN et al. Ann Surg; Adams RB et al. HPB', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี ผ่า colorectal cancer 6 weeks ago, completed adjuvant chemo. CEA rising 8 → 22 → 56 within 3 months; CT thorax/abdomen pelvis: 3 cm liver mass segment VI + no other disease; PET: SUV 11 liver + no extrahepatic

Liver function normal, performance status 1

คำถาม: management of metachronous liver metastasis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 4 ปี ตกบันได ปวด RUQ rebound positive แต่ไม่มี shock

VS: BP 96/64, HR 124, RR 26, Temp 36.8°C
FAST: positive free fluid, Hb 9.2 stable on serial check

CT abdomen: grade III splenic injury + no contrast extravasation + no other injury', '[{"label":"A","text":"Emergency splenectomy"},{"label":"B","text":"Pediatric splenic injury — non-operative management (NOM) — preferred strategy in children"},{"label":"C","text":"Discharge home outpatient"},{"label":"D","text":"Total colectomy"},{"label":"E","text":"Antibiotic alone, no monitoring"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Pediatric splenic injury — non-operative management (NOM) — preferred strategy in children**: (1) **Higher success rate of NOM in pediatric** (90-98%) than adult — splenic preservation important to avoid OPSI (Overwhelming Post-Splenectomy Infection); (2) **APSA pediatric NOM guidelines**: - Hemodynamic stability requirement - Grade I-V can be managed NOM if stable; even high-grade often stable - Activity restriction proportional to grade (Grade I-II: 3 wk; III: 4-5 wk; IV-V: 6 wk + before contact sports); (3) **Monitoring**: ICU initially if higher grade; serial vital signs, abdominal exams, Hb monitoring; reduced from older more aggressive protocols (shorter bed rest, ICU, hospitalization per evidence); (4) **Activity restriction** post-discharge — same period as bed rest historically + return-to-play protocols; (5) **Operative indications**: - Hemodynamic instability not responsive to resuscitation - Ongoing transfusion need - Other operative indications (concomitant injury) - Failed NOM (rare in pediatric); (6) **Operative**: try splenic preservation (splenorrhaphy, partial splenectomy, mesh wrap, topical hemostatic) > total splenectomy when feasible; total splenectomy only if necessary; (7) **Post-splenectomy considerations** (if performed): vaccinations (S. pneumoniae, H. influenzae b, N. meningitidis, influenza annually) before surgery if elective or within 14 days post; prophylactic penicillin daily × 3-5 years (younger) or longer; awareness of OPSI; medical alert; (8) **Pediatric trauma center referral** improves outcomes

---

**Pediatric splenic injury** — NOM is the gold standard. NOM success ≥ 90% in stable pediatric patients across all grades (higher than adult). Pediatric spleen has thicker capsule + more elastic stroma + better hemostasis. **APSA NOM protocol** (modernized — shorter durations vs older protocols): - Hemodynamic stability essential - Bed rest: grade + 1 day - Hospital stay: grade + 1 day - Activity restriction (no contact sports): grade × 1 week post-discharge - Imaging follow-up not routinely needed for low-grade **Pediatric vs adult NOM**: pediatric higher success across all grades; angioembolization role less established than in adults but used in selected. **OPSI (Overwhelming Post-Splenectomy Infection)** — devastating complication of asplenia: - Highest risk in young children + asplenia + encapsulated organisms (S. pneumoniae, H. influenzae, N. meningitidis) - Mortality 50-70% when occurs - Risk highest first 2 years post-splenectomy but lifelong - Prevention: vaccination + prophylactic antibiotic + patient education + medical alert **Vaccination schedule (post-splenectomy)**: - Pneumococcal: PCV13 + PPSV23 (PCV13 first, then PPSV23 8 weeks later, booster q5 yr) - Haemophilus influenzae type b (Hib) — if not previously vaccinated - Meningococcal: ACWY + B (different vaccines) - Annual influenza - Updated COVID **Timing**: ideally 14+ days before elective splenectomy; if emergent, immediately after surgery + ensure completion of series + boosters. **Prophylactic antibiotic**: penicillin V daily — younger children at least 3-5 years post-splenectomy; some advocate lifelong in high-risk. Patient education + emergency antibiotic ''stand-by'' (amoxicillin-clavulanate) to start at first sign of febrile illness while seeking care.', NULL,
  'medium', 'trauma', 'review',
  'surgery', 'clinical_decision', 'trauma', 'peds',
  'APSA Splenic Injury NOM Guidelines; EAST Pediatric Splenic Injury PMG; Holmes JH et al. J Pediatr Surg', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'เด็กชายอายุ 4 ปี ตกบันได ปวด RUQ rebound positive แต่ไม่มี shock

VS: BP 96/64, HR 124, RR 26, Temp 36.8°C
FAST: positive free fluid, Hb 9.2 stable on serial check

CT abdomen: grade III splenic injury + no contrast extravasation + no other injury'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Basic science question: surgical antibiotic prophylaxis

ผู้ป่วยอายุ 55 ปี กำหนดผ่าตัด elective sigmoidectomy for diverticulitis chronic; HT controlled

คำถาม: antibiotic prophylaxis principles', '[{"label":"A","text":"No antibiotic needed for elective surgery"},{"label":"B","text":"Surgical antibiotic prophylaxis principles"},{"label":"C","text":"5-day antibiotic course for all"},{"label":"D","text":"Antibiotic after wound infection only"},{"label":"E","text":"Topical antibiotic alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Surgical antibiotic prophylaxis principles**: (1) **Timing — within 60 min before incision** (vancomycin, fluoroquinolone: 120 min due to slower infusion); single dose pre-op preferred; re-dose if surgery > 4h or > 1500 mL blood loss or 2 half-lives elapsed; (2) **Antibiotic choice** — narrow-spectrum covering most likely pathogens: - **Clean (cardiac, ortho, vascular non-GI)**: cefazolin (skin flora — staph) - **Clean-contaminated GI**: cefoxitin, cefazolin + metronidazole, or piperacillin (for colorectal: cover gram-neg + anaerobes) - **Genitourinary**: ciprofloxacin, cefazolin; check urine culture - **Contaminated (perforation, trauma)**: therapeutic course (cefoxitin, pip-tazo, ceftriaxone + metronidazole) × 4-7 days; (3) **Discontinuation — within 24 hours post-op** for prophylaxis (continuing longer = no benefit, increases resistance, C. difficile risk) — exceptions: contaminated case, ongoing source; (4) **Special considerations**: - **Penicillin allergy**: clindamycin + aminoglycoside OR vancomycin (true PCN allergy IgE-mediated; many self-reported are not true allergies — re-evaluate) - **MRSA risk** (institution prevalence > 10-20%, nasal colonization, prior MRSA): add vancomycin to cefazolin (combination — not replacement) - **Obesity**: cefazolin 2 g if weight > 80 kg, 3 g if > 120 kg - **Renal/hepatic**: dose-adjust - **Recent antibiotic exposure**: may need broader spectrum; (5) **Mechanical bowel preparation + oral antibiotics** before colorectal surgery: combined approach (polyethylene glycol + neomycin + erythromycin or metronidazole) — recent evidence (multiple RCTs, meta-analyses, ACS NSQIP data) supports as reducing SSI + anastomotic leak; (6) **Specific procedures**: cardiac (cefazolin + vanco), ortho joint (cefazolin), neuro (cefazolin), urologic (ciprofloxacin), OB-gyn cesarean (cefazolin pre-incision); (7) **SCIP measures + WHO checklist** drive compliance — quality metric; (8) **Avoid prolonged prophylaxis** — does not prevent SSI, promotes resistance + C. difficile

---

**Surgical Antibiotic Prophylaxis** — fundamental + standard of care. Major principles (ASHP/IDSA/SHEA guidelines): 1. **Indication based on procedure risk** (Mangram/CDC wound classification): - Clean: low risk; selective prophylaxis (cardiac, ortho with hardware, vascular) - Clean-contaminated: prophylaxis indicated (GI, GU, gyn, head/neck) - Contaminated: therapeutic antibiotic course - Dirty/infected: therapeutic course 2. **Timing — within 60 min pre-incision** (within 120 min for vanco/fluoroquinolone); single pre-op dose; redose if long procedure or blood loss 3. **Choice — narrow-spectrum** covering likely pathogens; cefazolin most common; modify for institution + patient-specific 4. **Duration — limited** (within 24h) for prophylaxis; therapeutic course for contaminated/infected 5. **Dose — weight-adjusted** (cefazolin 2 g if > 80 kg, 3 g if > 120 kg); renal dose-adjust as needed 6. **Allergy management** — true IgE allergy: clinda + AG or vanco; many self-reported PCN allergies are not true — re-evaluate where possible 7. **MRSA decolonization** + addition of vancomycin in high-risk patients/institutions for hardware procedures **Specific procedure recommendations** (examples): - Colorectal: cefoxitin OR cefazolin + metronidazole; combined with mechanical + oral abx prep - Cardiac: cefazolin + vancomycin (if MRSA risk) - Joint replacement: cefazolin - Cesarean: cefazolin pre-incision (improves SSI vs post-cord-clamp) - Urologic: ciprofloxacin based on urine culture - Head/neck: cefazolin + metronidazole (clean-contaminated) **Pediatric**: same principles, weight-based dosing **Quality measures**: SCIP (Surgical Care Improvement Project), WHO Safe Surgery Checklist drive adherence. Antimicrobial stewardship principles apply — avoid unnecessary prolonged use which increases resistance, C. difficile risk.', NULL,
  'easy', 'id', 'review',
  'surgery', 'basic_science', 'id', 'adult',
  'ASHP-IDSA-SIS-SHEA Clinical Practice Guidelines for Antimicrobial Prophylaxis in Surgery 2013; WHO Global Guidelines SSI Prevention; CDC SSI Prevention', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'Basic science question: surgical antibiotic prophylaxis

ผู้ป่วยอายุ 55 ปี กำหนดผ่าตัด elective sigmoidectomy for diverticulitis chronic; HT controlled

คำถาม: antibiotic prophylaxis principles'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Basic science: surgical hemostasis + coagulation

ผู้ป่วยอายุ 65 ปี on apixaban for AF, scheduled elective inguinal hernia repair

คำถาม: perioperative anticoagulation management', '[{"label":"A","text":"Continue all medications"},{"label":"B","text":"Perioperative anticoagulation management"},{"label":"C","text":"Stop all anticoagulation 4 weeks pre-op"},{"label":"D","text":"Bridge with heparin in all DOAC patients"},{"label":"E","text":"Use FFP routinely"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Perioperative anticoagulation management**: (1) **Assess thrombotic + bleeding risks**: - Thrombotic risk based on indication: AF (CHA2DS2-VASc — low/mod/high), mechanical valve, recent VTE - Bleeding risk based on procedure: HAS-BLED, procedure-specific bleeding categories; (2) **Procedure bleeding risk categories**: - Low (no/minimal expected bleeding — dental, cataract, minor skin, endoscopy without biopsy): continue anticoagulation or minimal interruption - Medium (most general/orthopedic): typically interrupt - High (cardiothoracic, neurosurgery, major abdominal, hepatic resection, prostatectomy, extensive cancer): definitely interrupt; (3) **DOACs (apixaban, rivaroxaban, dabigatran, edoxaban)**: - **No bridging needed routinely** (short half-life) - **Stop timing based on CrCl + procedure bleeding risk** (PAUSE Trial Mayo Clin Proc 2019 — Douketis): * Low bleeding risk: hold 1 day pre-op (24h) * High bleeding risk: hold 2 days pre-op (48h) * Renal impairment (CrCl < 50): extend hold * Restart 24h post-low-risk; 48-72h high-risk procedures; (4) **Warfarin**: - Stop 5 days pre-op (INR normalize) - Check INR day before; vitamin K if elevated - Bridge with LMWH for high-risk thrombotic patients (mechanical mitral valve, recent VTE < 3 mo, prior CVA on warfarin) — BRIDGE trial showed routine bridging in AF without high-risk doesn''t help + increases bleeding - Restart warfarin within 24h post-op + bridging LMWH for high-risk until INR therapeutic; (5) **Antiplatelet (aspirin, clopidogrel)**: - Aspirin: typically continue except high-bleed procedures (POISE-2) - DAPT post-coronary stent: defer elective surgery until 6-12 months DES, 30 days BMS; if emergent, multidisciplinary (cardiology, surgery, hematology) - Clopidogrel: stop 5-7 days pre-op for elective if needed; (6) **Heparin**: - UFH: stop 4-6h pre-op (short half-life) - LMWH: prophylactic dose 12h pre-op; therapeutic 24h pre-op; (7) **Reversal** if emergent surgery needed: - DOAC: idarucizumab (dabigatran), andexanet alfa (factor Xa inhibitors) - Warfarin: 4F-PCC + vitamin K - Heparin: protamine (UFH); LMWH partial reversal protamine - Antiplatelet: platelet transfusion (efficacy limited); DDAVP

---

**Perioperative anticoagulation management** — balance thrombotic vs bleeding risk. **Risk stratification**: - Thrombotic: AF (CHA2DS2-VASc), mechanical valve (mitral > aortic, multiple > single), recent VTE (< 3 mo highest risk, then 3-12 mo, then > 12 mo) - Bleeding: HAS-BLED score; procedure-specific (ASGE, ASA, AAGBL classifications); intracranial / spinal / posterior chamber eye / cardiac / large vessel = high bleeding risk **Decision framework**: 1. Low bleeding risk + any thrombotic risk: continue anticoagulation or minimal interruption (no bridging) 2. Medium-high bleeding risk + low thrombotic risk: hold anticoagulation without bridging; restart when hemostasis 3. Medium-high bleeding risk + high thrombotic risk: hold + bridge (warfarin only — not DOAC) **Bridging**: - Indicated for: mechanical mitral valve, recent stroke (< 3 mo) on warfarin, recent VTE (< 3 mo) - Not routinely needed for AF (BRIDGE Trial NEJM 2015 — no benefit, more bleeding) - LMWH (enoxaparin 1 mg/kg q12h therapeutic) - Start when INR < 2; last dose 24h pre-op - Restart post-op when hemostasis adequate (typically 24h low-risk procedures, 48-72h high-risk) **DOAC specific** (PAUSE trial protocol — simple + safe): - No bridging - Stop 1-2 days pre-op based on procedure bleeding risk + renal function - Restart 24-72h post-op depending on bleeding risk **DOAC reversal**: - Dabigatran: idarucizumab (Praxbind) - Apixaban / rivaroxaban: andexanet alfa (Andexxa) or 4F-PCC if andexanet unavailable - Edoxaban: 4F-PCC or andexanet **Warfarin reversal** (urgent): - 4-factor PCC (preferred over FFP — faster, lower volume) - Vitamin K 5-10 mg IV - FFP if PCC unavailable **DAPT after coronary stent**: defer elective non-cardiac surgery: - BMS: 30 days minimum on DAPT - DES: 6 months minimum (12 months ideal) - Continue aspirin throughout if possible - Stop P2Y12 inhibitor 5-7 days pre-op if needed - Multidisciplinary input if conflict.', NULL,
  'medium', 'cardiovascular', 'review',
  'surgery', 'basic_science', 'cardiovascular', 'adult',
  'ACCP Antithrombotic Therapy 2022; ACC/AHA Perioperative Cardiac Management 2014; Douketis JD et al. JAMA Intern Med 2019 (PAUSE); Douketis JD et al. NEJM 2015 (BRIDGE)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'Basic science: surgical hemostasis + coagulation

ผู้ป่วยอายุ 65 ปี on apixaban for AF, scheduled elective inguinal hernia repair

คำถาม: perioperative anticoagulation management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Basic science: nutrition + perioperative care

ผู้ป่วยอายุ 70 ปี cachectic with malnutrition (BMI 18, albumin 2.4, prealbumin low, weight loss 12% in 3 mo) gold standard pre-op for elective major surgery (sigmoidectomy for cancer)

คำถาม: pre-op nutritional optimization', '[{"label":"A","text":"Proceed with surgery immediately"},{"label":"B","text":"Severe malnutrition with high surgical risk — pre-op nutritional optimization (ERAS principle)"},{"label":"C","text":"NPO until surgery"},{"label":"D","text":"TPN immediately"},{"label":"E","text":"Surgery delayed indefinitely"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Severe malnutrition with high surgical risk — pre-op nutritional optimization (ERAS principle)**: (1) **Assess malnutrition severity** — multiple tools: - **SGA (Subjective Global Assessment)** - **MNA-SF** elderly - **NRS-2002** (Nutritional Risk Screening) - **GLIM** (Global Leadership Initiative on Malnutrition) — phenotypic (weight loss, BMI low, muscle mass low) + etiological (reduced intake, inflammation/disease) - **Lab markers**: albumin (acute phase reactant — not pure nutrition), prealbumin (shorter half-life), CRP - **Body composition** — bioimpedance, hand grip strength; (2) **Sarcopenia + frailty** assessment — CT psoas measurement, hand grip, gait speed (Fried frailty criteria); independent predictor of postoperative outcomes; (3) **Optimization strategies** (target 7-14 days, longer if severe + tolerable delay): - **Oral nutritional supplements (ONS)** — high protein + calorie; aim 1.5-2 g/kg/day protein + 30-35 kcal/kg/day - **Immunonutrition** — arginine, omega-3 PUFA, ribonucleotides (Impact, Oxepa) — 5-7 days pre-op + continue post-op; reduces SSI + LOS in elective major GI surgery per multiple RCTs (Drover meta-analysis) - **Enteral feeding** (NJ, PEG, gastrostomy) if oral intake inadequate - **Parenteral nutrition (TPN)** only when enteral not feasible + significant malnutrition + ≥ 7 days pre-op feasibility — ASPEN/ESPEN guidelines; (4) **Treat underlying contributors**: - Dental issues, dysphagia, malabsorption - Depression, social factors - Tumor-related anorexia (corticosteroid short-term, mirtazapine, megestrol — selected) - Inflammation reduction; (5) **Concomitant prehabilitation** — exercise (aerobic + resistance), psychological, smoking/alcohol cessation, optimize comorbidities; (6) **Postoperative**: ERAS protocol — early oral intake (no traditional NPO), early mobilization, optimize pain control + multimodal analgesia opioid-sparing, glycemic control; (7) **Monitor**: refeeding syndrome in severely malnourished — phosphate, magnesium, K, thiamine — slow advancement of feeds; (8) **Long-term**: nutrition follow-up post-surgery + during recovery + survivorship

---

**Pre-operative nutritional optimization** — modifiable risk factor with substantial impact on surgical outcomes. **Malnutrition + surgical outcomes**: malnutrition associated with SSI ↑, anastomotic leak ↑, wound dehiscence ↑, pneumonia ↑, LOS ↑, mortality ↑. **Assessment tools** (validated): - NRS-2002 — screening for hospital admissions - MUST (Malnutrition Universal Screening Tool) - SGA (Subjective Global Assessment) — A/B/C - MNA-SF — older adults - GLIM (Global Leadership Initiative on Malnutrition) — modern consensus: phenotypic criteria (weight loss, low BMI, low muscle mass) + etiological (reduced intake or assimilation, inflammation/disease) **Labs**: albumin (acute phase reactant — declines in inflammation, not specific to nutrition), prealbumin (transthyretin — 2-day half-life, better short-term marker), CRP (inflammation), lymphocyte count, retinol-binding protein. **Sarcopenia** (loss of muscle mass + function) — increasing recognition as independent surgical risk factor. Measured: CT psoas at L3, DEXA, hand grip, gait speed. **ERAS (Enhanced Recovery After Surgery)** principles: 1. Pre-op: nutritional optimization, prehabilitation, education, no prolonged fasting (clear fluid up to 2h, solids 6h), carb loading drink pre-op (improves insulin sensitivity, reduces stress) 2. Intra-op: minimally invasive, normothermia, goal-directed fluid, multimodal analgesia 3. Post-op: early oral intake, early mobilization, early Foley + drain removal, no routine NG, multimodal opioid-sparing analgesia **Immunonutrition** (arginine, omega-3, nucleotides) — reduces complications in major GI cancer surgery per Drover meta-analysis (Ann Surg 2011); 5-7 days pre-op + continue post-op. **Pre-op carb loading** (clear carb drink 2h pre-op): reduces insulin resistance + surgical stress (RECOVER trial + others). **Refeeding syndrome**: severely malnourished — phosphate (PO4), magnesium, potassium drops + thiamine deficiency → cardiac + neurologic symptoms; supplement thiamine BEFORE refeed; advance slowly + monitor electrolytes. **Prehabilitation programs**: aerobic + resistance exercise + nutrition + psychological + smoking/alcohol cessation — 2-6 weeks pre-op; improves outcomes especially in cancer surgery, frail elderly.', NULL,
  'medium', 'gi', 'review',
  'surgery', 'basic_science', 'gi', 'adult',
  'ASPEN-ESPEN Surgical Nutrition Guidelines; ERAS Society Guidelines; Weimann A et al. Clin Nutr; Drover JW et al. Ann Surg', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'Basic science: nutrition + perioperative care

ผู้ป่วยอายุ 70 ปี cachectic with malnutrition (BMI 18, albumin 2.4, prealbumin low, weight loss 12% in 3 mo) gold standard pre-op for elective major surgery (sigmoidectomy for cancer)

คำถาม: pre-op nutritional optimization'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Basic science: surgical site infection prevention

ผู้ป่วยกำหนดผ่าตัด elective colorectal surgery, มี DM controlled HbA1c 7.0, smoker active

คำถาม: SSI prevention bundle', '[{"label":"A","text":"Antibiotic prophylaxis alone sufficient"},{"label":"B","text":"Multi-modal SSI prevention bundle (evidence-based)"},{"label":"C","text":"Single intervention is sufficient"},{"label":"D","text":"No special preparation needed"},{"label":"E","text":"Razor shave morning of surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Multi-modal SSI prevention bundle (evidence-based)**: (1) **Pre-operative**: - **Skin antiseptic shower** night before + morning (chlorhexidine 4% — controversial benefit; soap acceptable) - **Hair removal** — clipper (NOT razor — razor increases SSI); just before incision - **Skin antisepsis at incision site**: chlorhexidine-alcohol (preferred over povidone-iodine per RCT evidence — Darouiche NEJM 2010) - **Smoking cessation** 4 weeks pre-op + 4 weeks post (RCT — significant SSI reduction) - **Glycemic control** — perioperative target 140-180 mg/dL; HbA1c < 7-8 pre-elective ideal but doesn''t delay surgery if mildly elevated - **Nutritional optimization** (see prior) - **MRSA screening + decolonization** (mupirocin nasal + chlorhexidine bath) in high-risk patients/procedures - **Mechanical bowel prep + oral antibiotics** for colorectal (combined PEG + neomycin + erythromycin/metronidazole — reduces SSI per recent evidence, ACS NSQIP); (2) **Intra-operative**: - **Antibiotic prophylaxis** within 60 min pre-incision, redose if long surgery/blood loss - **Normothermia** (core temp > 36°C — warming devices, IV fluid warmers) - **Normoxia / hyperoxia** — FiO2 50-80% intraop + 2h postop (PROXI trial mixed but consensus higher FiO2 reasonable) - **Glycemic control intra-op** - **Surgical technique** — minimally invasive when feasible (lower SSI than open), gentle tissue handling, hemostasis, avoid excessive electrocautery, irrigation (debated benefit) - **Wound protector device** (Alexis) — reduces SSI in colorectal per RCTs - **Triclosan-coated sutures** for fascia closure — reduces SSI per meta-analyses - **Change gloves** before fascia closure; (3) **Post-operative**: - **Wound care** — clean technique, dressing, monitor - **Glycemic control** - **Early oral intake + mobilization** - **Discharge education** signs of infection; (4) **Surveillance + reporting**: SSI tracking, NSQIP feedback, benchmarking; (5) **Bundles vs single intervention**: bundled approach (multiple measures) more effective than individual interventions

---

**Surgical Site Infection (SSI)** — most common HAI in surgical patients. **Categories** (CDC NHSN definition): - **Superficial incisional** — skin + subcutaneous - **Deep incisional** — fascia + muscle - **Organ/space** — beyond fascia (e.g., intra-abdominal abscess, anastomotic leak) **Risk factors**: - Patient: age, DM, obesity, malnutrition, smoking, immunosuppression, MRSA colonization - Procedure: type (clean to dirty), duration, emergency, contamination - Microbial: virulence, inoculum size, MRSA prevalence **Evidence-based SSI prevention bundle** (CDC, WHO, ACS): 1. **Pre-op**: - Smoking cessation 4 wk pre + post (significant impact) - Glycemic control - Nutrition optimization - Chlorhexidine bath / shower (controversial individual benefit, low risk) - Hair removal: clip > shave > don''t remove; just before incision - Skin antisepsis: chlorhexidine-alcohol > povidone-iodine (Darouiche NEJM 2010) - MRSA decolonization (mupirocin + chlorhexidine) high-risk - Bowel prep (mechanical + oral abx) colorectal — recent evidence supports combined 2. **Intra-op**: - Antibiotic prophylaxis (timing + dose + redosing) - Normothermia (Kurz NEJM 1996 — hypothermia ↑ SSI) - Goal-directed fluid - Higher FiO2 (50-80% intraop + 2h post) - Glycemic control - Minimally invasive when feasible - Wound protector for clean-contaminated (colorectal) - Triclosan sutures - Glove change before fascia closure - Pre-closure irrigation (debated benefit, but consensus) 3. **Post-op**: - Wound dressing maintained 24-48h - Glycemic control - Early mobilization - Discharge education **Quality improvement**: SCIP, ACS NSQIP — track + feedback drives improvement. Bundles outperform individual interventions. **Specific procedure considerations**: - Cesarean: skin prep + vaginal prep (chlorhexidine) - Joint replacement: MRSA decolonization, FRP - Cardiac: vanco for MRSA risk + cefazolin - Colorectal: combined bowel prep + oral antibiotics.', NULL,
  'easy', 'id', 'review',
  'surgery', 'basic_science', 'id', 'adult',
  'CDC SSI Prevention Guidelines 2017; WHO Global Guidelines for Prevention of SSI 2018; Darouiche RO et al. NEJM 2010; Kurz A et al. NEJM 1996', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'Basic science: surgical site infection prevention

ผู้ป่วยกำหนดผ่าตัด elective colorectal surgery, มี DM controlled HbA1c 7.0, smoker active

คำถาม: SSI prevention bundle'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Basic science: surgical anatomy + nerve injury

ผู้ป่วยอายุ 45 ปี post-laparoscopic inguinal hernia repair (TEP) มา 6 weeks มาด้วยอาการ chronic groin pain + numbness ที่ medial thigh

คำถาม: nerve injury + management', '[{"label":"A","text":"All groin pain is normal"},{"label":"B","text":"Chronic post-herniorrhaphy groin pain — nerve injury / entrapment likely"},{"label":"C","text":"Re-operate immediately for any pain"},{"label":"D","text":"Discharge with no follow-up"},{"label":"E","text":"Opioids alone long-term"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Chronic post-herniorrhaphy groin pain — nerve injury / entrapment likely**: (1) **Nerves at risk in inguinal hernia repair**: - **Ilioinguinal nerve (L1)** — sensation: skin of upper medial thigh + base of penis/labia + anterior scrotum/mons - **Iliohypogastric nerve (L1)** — sensation: skin above pubis + anterior gluteal - **Genitofemoral nerve (L1-L2)** — genital branch (cremaster, anterior scrotum), femoral branch (skin of femoral triangle) - **Lateral femoral cutaneous nerve (L2-L3)** — lateral thigh sensation (meralgia paresthetica if injured); (2) **Mechanism of injury**: nerve transection, ligation, tack/clip placement (especially below iliopubic tract in TEP/TAPP), entrapment in mesh fixation, neuroma formation, mesh-induced inflammation/fibrosis; (3) **Clinical**: chronic groin pain, paresthesia, hypesthesia, burning, allodynia, hyperalgesia, dysfunction (sexual, gait); (4) **Definition**: chronic post-herniorrhaphy pain — > 3-6 months post-op; incidence 10-15% overall, severe 1-3%; (5) **Diagnosis**: - Clinical history + exam — sensory mapping - Nerve block (diagnostic + therapeutic) — local anesthetic at suspected nerve - MRI / US — exclude mass, mesh complication, nerve enlargement - EMG/NCS — supportive; (6) **Management — stepwise**: a. **Conservative**: NSAIDs, gabapentinoids (gabapentin, pregabalin), TCAs, topical agents (lidocaine, capsaicin), physical therapy; b. **Nerve blocks** — local anesthetic ± steroid; multiple if effective; c. **Pulsed radiofrequency ablation** — emerging d. **Surgical exploration + neurectomy/triple neurectomy** — refractory severe cases; remove all 3 nerves (ilioinguinal, iliohypogastric, genitofemoral); mesh removal selectively e. **Spinal cord stimulator** — refractory chronic pain; (7) **Prevention** in hernia repair: identify + preserve nerves; avoid tacks in ''triangle of pain'' (below iliopubic tract, lateral to spermatic vessels); lightweight mesh; minimize mesh fixation; (8) **Multidisciplinary** pain clinic + surgeon collaboration

---

**Chronic post-herniorrhaphy pain (CPHP)** — significant complication; incidence 10-15% any chronic pain, 1-3% severe (interferes with daily activity). Now leading cause of long-term morbidity after inguinal hernia repair (vs recurrence which has dropped with mesh). **Inguinal anatomy** — 3 nerves at risk in inguinal canal: 1. **Ilioinguinal (L1)** — passes through inguinal canal, supplies anterior cremasteric, upper medial thigh, anterior scrotum/labia 2. **Iliohypogastric (L1)** — anterior cutaneous branch above inguinal ring, supplies suprapubic skin + lower abdomen 3. **Genitofemoral (L1-L2)** — genital branch through deep ring with spermatic cord (cremaster + scrotum/labia anterior); femoral branch through femoral sheath (skin of upper thigh) Plus **lateral femoral cutaneous (L2-L3)** — lateral aspect; meralgia paresthetica if injured (more often in laparoscopic, retroperitoneal procedures). **''Triangle of pain'' (laparoscopic)**: bounded by spermatic vessels medially, iliopubic tract superiorly, peritoneal reflection laterally — contains lateral femoral cutaneous + femoral branch of genitofemoral + femoral nerve → AVOID tacks here. **''Triangle of doom''**: medial to spermatic vessels — external iliac vessels + vas deferens. **Mechanisms** of chronic pain post-herniorrhaphy: nerve injury (transection, ligation, traction, entrapment in mesh/fixation), neuroma, mesh inflammation, recurrence, sports hernia/osteitis pubis differential. **Management ladder** — conservative → nerve block → surgical neurectomy. **Triple neurectomy** (Amid technique): resect ilioinguinal, iliohypogastric, genital branch of genitofemoral nerves — for refractory severe cases; success ~ 80%. **Prevention**: identify + protect nerves; avoid blind tacking; lightweight mesh; minimize fixation; experienced surgeon. **Multidisciplinary**: pain medicine, neurology, surgery, psychology, PT.', NULL,
  'hard', 'procedures', 'review',
  'surgery', 'basic_science', 'procedures', 'adult',
  'Amid PK. Hernia 2004; HerniaSurge 2018; Lange JF et al. Br J Surg; Andresen K et al. Surg Endosc', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'Basic science: surgical anatomy + nerve injury

ผู้ป่วยอายุ 45 ปี post-laparoscopic inguinal hernia repair (TEP) มา 6 weeks มาด้วยอาการ chronic groin pain + numbness ที่ medial thigh

คำถาม: nerve injury + management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Basic science: ICU + critical care

ผู้ป่วยอายุ 65 ปี post-Whipple POD 5 ICU มี ARDS develop — bilateral pulmonary infiltrates + PaO2/FiO2 ratio 120 + no cardiac cause + intubated

คำถาม: ARDS management', '[{"label":"A","text":"High tidal volume ventilation 10 mL/kg"},{"label":"B","text":"ARDS management — lung-protective ventilation + supportive"},{"label":"C","text":"Withhold all sedation"},{"label":"D","text":"Diuretic high dose alone"},{"label":"E","text":"Steroid IV high dose for all"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **ARDS management — lung-protective ventilation + supportive**: (1) **Berlin definition of ARDS**: acute onset within 1 week, bilateral opacities, not fully explained by cardiac failure/fluid overload, PaO2/FiO2 ≤ 300 with PEEP ≥ 5 (mild: 200-300, moderate: 100-200, severe: ≤ 100); (2) **Lung-protective ventilation** (ARDSnet, NEJM 2000 — landmark): - **Low tidal volume 4-6 mL/kg ideal body weight** (predicted, not actual) — reduces mortality - **Plateau pressure ≤ 30 cmH2O** — limit barotrauma - **Driving pressure ≤ 15 cmH2O** (Amato et al — independent mortality predictor) - **PEEP titration** — open lung approach; ARDSnet PEEP/FiO2 table OR esophageal pressure-guided OR best compliance PEEP - Permissive hypercapnia (pH > 7.20-7.25 acceptable to avoid high TV); (3) **Adjunctive therapies for moderate-severe ARDS (P/F < 150)**: - **Prone positioning** — 16+ hours/day; reduces mortality (PROSEVA NEJM 2013) - **Neuromuscular blockade** (cisatracurium) — early 48h in severe (ACURASYS NEJM 2010; ROSE trial showed no benefit so individualize); use if asynchrony despite sedation - **High PEEP + lung recruitment** maneuvers — selected (LOVS, ALVEOLI mixed; Open Lung Trial harmed in some); (4) **Refractory hypoxia (P/F < 80)**: - **ECMO (VV)** — for severe refractory; CESAR + EOLIA trials (EOLIA stopped early — Bayesian post-hoc favorable; selected centers improve outcomes); transfer to ECMO center early; (5) **Fluid management**: conservative fluid strategy post-resuscitation (FACTT — ARDSnet); negative fluid balance after stable; (6) **Nutritional**: enteral preferred; avoid overfeeding; (7) **Treat underlying cause**: sepsis (broad-spectrum antibiotic, source control), pneumonia, aspiration, trauma, transfusion (TRALI); (8) **Avoid harmful**: steroids controversial (RCTs mixed — DEXA-ARDS may benefit, but pre-COVID debate; in COVID-related ARDS steroids beneficial per RECOVERY); routine inhaled NO doesn''t improve mortality; (9) **Weaning + recovery**: spontaneous breathing trial, ABCDEF bundle (Awakening + Breathing + Choice + Delirium + Early mobility + Family); (10) **Long-term**: post-ICU syndrome (physical, cognitive, psychological) — rehab, follow-up clinic

---

**Acute Respiratory Distress Syndrome (ARDS)** — heterogeneous syndrome of acute hypoxic respiratory failure. **Berlin definition** (2012): 1. Acute onset within 1 week 2. Bilateral opacities on chest imaging 3. Not fully explained by cardiac failure (echocardiogram if uncertain) 4. PaO2/FiO2 ratio (with PEEP ≥ 5): - Mild: 200-300 - Moderate: 100-200 - Severe: < 100 **Etiology**: direct lung injury (pneumonia, aspiration, inhalation), indirect (sepsis, trauma, transfusion — TRALI, pancreatitis, DKA, drug overdose, near drowning). **Lung-protective ventilation (ARDSnet)** — landmark ARMA trial (NEJM 2000): - TV 4-6 mL/kg IBW (predicted body weight) - Plateau pressure ≤ 30 - PEEP titrated (low PEEP/high PEEP both options) - Permissive hypercapnia (pH > 7.2 OK) - Reduced mortality 9% absolute **Adjuncts for moderate-severe ARDS**: 1. **Prone positioning** ≥ 16h (PROSEVA NEJM 2013 — mortality benefit) — first-line for P/F < 150 2. **Neuromuscular blockade** — ACURASYS positive but ROSE no benefit; individualize for asynchrony 3. **High PEEP** — selected (mixed data; LOVS, ALVEOLI, ART) 4. **Recruitment maneuvers** — controversial 5. **ECMO (VV)** — refractory P/F < 80 despite optimization; CESAR + EOLIA (Bayesian post-hoc favors); transfer to ECMO center 6. **iNO** — temporary rescue but no mortality benefit **Fluid management**: conservative post-initial resuscitation — FACTT (ARDSnet) — improved oxygenation + LOS. **Steroids**: pre-COVID era controversial; DEXA-ARDS (Villar 2020) showed mortality benefit. COVID-ARDS: steroids beneficial (RECOVERY). Apply cautiously based on etiology + timing. **Ventilator-induced lung injury** mechanisms: - Volutrauma (over-distension) - Barotrauma (high pressure) - Atelectrauma (cyclical opening/closing) - Biotrauma (inflammatory mediators) **ABCDEF bundle** in ICU — reduces delirium, LOS, mortality, post-ICU syndrome. **Recovery**: post-ICU syndrome (physical weakness, cognitive impairment, PTSD) common — rehab + multidisciplinary follow-up.', NULL,
  'hard', 'cardiovascular', 'review',
  'surgery', 'basic_science', 'cardiovascular', 'adult',
  'ARDS Berlin Definition JAMA 2012; ARDSnet NEJM 2000 (ARMA); PROSEVA NEJM 2013; Combes A et al. NEJM 2018 (EOLIA)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'Basic science: ICU + critical care

ผู้ป่วยอายุ 65 ปี post-Whipple POD 5 ICU มี ARDS develop — bilateral pulmonary infiltrates + PaO2/FiO2 ratio 120 + no cardiac cause + intubated

คำถาม: ARDS management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ระบบ trauma quality improvement / patient safety in surgery

คำถาม: surgical safety + WHO checklist + handoff', '[{"label":"A","text":"Surgical errors rare, no system needed"},{"label":"B","text":"Surgical safety + quality improvement systems"},{"label":"C","text":"No quality measures needed"},{"label":"D","text":"Individual blame culture"},{"label":"E","text":"Single-step process"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Surgical safety + quality improvement systems**: (1) **WHO Surgical Safety Checklist** (Haynes NEJM 2009 — 36% mortality reduction): - **Sign-in (before anesthesia)**: patient ID, surgical site marking, anesthesia check, allergies, airway/aspiration risk, blood loss risk + access - **Time-out (before incision)**: team introductions, confirm patient + procedure + site, antibiotic given, imaging displayed, anticipated critical events, equipment availability - **Sign-out (before patient leaves OR)**: counts (instruments, sponges, sharps), specimen labeling, equipment issues, recovery + post-op plan; (2) **WHO Safe Surgery Saves Lives** — 10 essential surgical safety objectives globally; (3) **Standardized handoff communication**: - SBAR (Situation, Background, Assessment, Recommendation) - I-PASS (Illness severity, Patient summary, Action list, Situation awareness, Synthesis) - Anesthesia → recovery → ward handoffs; (4) **Crew Resource Management (CRM) / TeamSTEPPS** — borrowed from aviation: - Mutual support, shared mental model, situation awareness, communication, leadership, debrief - Reduces communication errors; (5) **Surgical adverse events**: - Wrong-site surgery — Universal Protocol + site marking + time-out - Retained foreign object (gossypiboma) — counts + radio-frequency tags + imaging if discrepancy - Surgical fire — 3 elements (fuel, oxidizer, ignition) — alcohol antiseptic drying, lower FiO2 in face/airway surgery - Medication errors — barcode, dual verification, look-alike/sound-alike awareness; (6) **Quality measurement**: - **ACS NSQIP** — risk-adjusted outcomes benchmark - **MBSAQIP** — bariatric - **STS Database** — cardiothoracic - **Hospital-acquired conditions (HAC)** — CMS measures - **Patient safety indicators (PSI)** — AHRQ; (7) **Just culture** — distinguish system errors from individual blame; encourages reporting + learning; (8) **Root Cause Analysis (RCA)** + M&M conferences for adverse events; (9) **Simulation training** — improves performance + retention; (10) **Continuous quality improvement** cycle — Plan-Do-Study-Act (PDSA)

---

**Surgical safety + quality improvement** — central modern surgical practice. **WHO Surgical Safety Checklist** (2008-) — 19-item checklist: 1. **Sign-in** (before anesthesia): - Patient identification - Site marking confirmed - Anesthesia machine + medication safety check - Pulse oximeter on patient - Allergies known - Airway / aspiration risk - Blood loss risk (> 500 mL adult, 7 mL/kg child) — IV access + fluids ready 2. **Time-out** (before incision): - Team introductions - Confirm: patient, procedure, site - Critical events anticipated (steps, blood loss, special needs) - Antibiotic prophylaxis within 60 min - Imaging displayed - Equipment available + functional 3. **Sign-out** (before leaving OR): - Procedure recorded - Counts complete (sponges, sharps, instruments) - Specimens labeled correctly - Equipment issues addressed - Recovery + post-op management plan **Evidence**: Haynes NEJM 2009 — global pilot — major complications 11% → 7%, mortality 1.5% → 0.8%. **Universal Protocol** (Joint Commission) — prevents wrong-site/patient/procedure: pre-procedure verification + site marking + time-out. **Communication tools**: - SBAR — Situation/Background/Assessment/Recommendation - I-PASS — Illness severity/Patient summary/Action list/Situation awareness/Synthesis by receiver - CUS — Concerned/Uncomfortable/Stop (escalation language) **Team training**: - TeamSTEPPS (AHRQ) — team strategies + tools to enhance performance + patient safety - Crew Resource Management (CRM) — aviation-derived **Quality metrics**: - ACS NSQIP — risk-adjusted complications benchmark - STS Database — cardiothoracic - SCIP — process measures - HAC — CMS Hospital-Acquired Conditions - PSI — AHRQ Patient Safety Indicators - HCAHPS — patient experience **Adverse event analysis**: - M&M conferences — case-based learning - Root Cause Analysis (RCA) — systematic event analysis - Failure Mode + Effects Analysis (FMEA) — proactive risk - Just culture — distinguish individual error vs system contribution **Simulation training** — improves performance + reduces errors; in residency + ongoing professional development.', NULL,
  'easy', 'procedures', 'review',
  'surgery', 'ems_mgmt', 'procedures', 'adult',
  'WHO Surgical Safety Checklist; Haynes AB et al. NEJM 2009; Joint Commission Universal Protocol; ACS NSQIP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ระบบ trauma quality improvement / patient safety in surgery

คำถาม: surgical safety + WHO checklist + handoff'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ระบบ EMS — tele-trauma + transfer protocols

คำถาม: รถ ambulance รับผู้ป่วย rural area severe TBI + multi-trauma — ทำอย่างไรในการประสานงาน + transfer', '[{"label":"A","text":"Take to nearest hospital regardless"},{"label":"B","text":"Pre-hospital trauma care + inter-facility transfer"},{"label":"C","text":"No transfer ever"},{"label":"D","text":"Operate at rural ED"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Pre-hospital trauma care + inter-facility transfer**: (1) **Pre-hospital management** (EMS principles): - **Scene safety** — primary - **Primary survey ABCDE** — airway with C-spine, breathing, circulation, disability, exposure - **Identify life threats** + intervene: airway (intubation if needed, supraglottic, surgical airway), tension pneumothorax (needle/finger decompression), hemorrhage (direct pressure, tourniquet for limbs, pelvic binder, hemostatic gauze for junctional, TXA per protocol — UK MERIT), shock (IV access, fluid resuscitation cautious — permissive hypotension if no head injury) - **Spine immobilization** — collar + backboard for short transport; selective spinal immobilization protocols (NEXUS, Canadian C-spine) emerging - **Vital signs trend**, GCS, neuro exam - **Communication** with destination hospital pre-arrival (advanced notice); (2) **Triage to appropriate facility** per field trauma triage criteria (CDC 2021) — physiologic + anatomic + mechanism + special; transport to: - Highest level trauma center within timely distance - Helicopter EMS for distance > 30 min vs ground - Step-down only if higher unreachable; (3) **Inter-facility transfer** — when initial facility lacks capability: - **Stabilize before transfer** when feasible (airway secured, hemorrhage controlled, hemodynamic stable) but DO NOT delay critical needs at receiving facility (definitive operative care, blood, IR) - **Communicate** — direct physician-to-physician + nursing handoff - **Transport mode**: ground, fixed-wing, helicopter (rapid critical care; weather, distance, patient stability) - **Documentation**: complete records, imaging on portable media, blood products if available - **Personnel**: paramedic, nurse, physician depending on patient acuity - **Protocols** standardized (EMTALA in US, similar in other systems); (4) **Tele-medicine + tele-trauma**: - Remote trauma surgeon consultation for rural EDs - Real-time decision support, ultrasound interpretation, OR planning - Mobile applications + telemedicine systems integrated; (5) **Damage control resuscitation** during transfer: balanced products, TXA, hypothermia prevention, permissive hypotension (no TBI); (6) **Receiving team activation** pre-arrival — trauma team, blood bank, OR, IR, neurosurgery on standby; (7) **Quality + outcome tracking** — trauma registry; benchmark; (8) **Special populations**: pediatric, pregnant, elderly, burns — dedicated centers; geriatric trauma underestimated severity (anatomical, physiologic, medication); pediatric weight-based dosing + dedicated centers improve outcomes

---

**Pre-hospital + inter-facility trauma transfer** — system-level component of trauma care. **Pre-hospital priorities**: 1. **Scene safety** 2. **Primary survey ABCDE** 3. **Identify + treat immediate life threats**: - Airway: jaw thrust, oral/nasal airway, supraglottic, intubation, surgical (cricothyroidotomy) - Breathing: needle decompression tension pneumothorax (now 5th ICS AAL per ATLS 10), occlusive dressing open pneumothorax, oxygen - Circulation: hemorrhage control (direct pressure → tourniquet → wound packing/hemostatic gauze → pelvic binder), IV access, fluid (permissive hypotension if no TBI), TXA — pre-hospital TXA reduces mortality (MERIT, CRASH-2) - Disability: GCS, pupil, gross motor - Exposure: prevent hypothermia 4. **Spine immobilization** with selective protocols (NEXUS, Canadian C-spine — pre-hospital implementation increasing) 5. **Vital signs trend** 6. **Communication** with receiving facility — provide age, mechanism, injuries, vital signs, interventions, ETA **Field triage to appropriate facility** (CDC 2021 criteria) — physiologic + anatomic + mechanism + special considerations; air vs ground transport. **Inter-facility transfer**: - Stabilize life-threats (airway, hemorrhage control) - Don''t delay critical interventions at definitive facility - Physician-physician communication + handoff - Documentation + imaging shared - Personnel matched to patient acuity - Protocols (EMTALA, regional) - Damage control during transfer **Tele-trauma**: real-time remote support; valuable in rural / resource-limited; improves outcomes (Latifi et al studies). **Trauma system outcomes**: established trauma systems reduce preventable death 25-35%; mortality reduction in dedicated centers 20-25% (MacKenzie NEJM 2006). **Pediatric considerations**: dedicated pediatric trauma centers improve outcomes; weight-based dosing, atomized resuscitation; family centered. **Geriatric considerations**: trauma in elderly with normal vital signs is dangerous (anatomic, physiologic, medication blunt symptoms); under-triage common; lower threshold for trauma center.', NULL,
  'medium', 'trauma', 'review',
  'surgery', 'ems_mgmt', 'trauma', 'adult',
  'ACS Resources for Optimal Care of the Injured Patient; CDC Field Triage Criteria 2021; MacKenzie EJ et al. NEJM 2006', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ระบบ EMS — tele-trauma + transfer protocols

คำถาม: รถ ambulance รับผู้ป่วย rural area severe TBI + multi-trauma — ทำอย่างไรในการประสานงาน + transfer'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 75 ปี end-stage COPD + IHD + CKD post-emergency Hartmann''s procedure for perforated colorectal cancer 1 month ago — now in subacute rehab + stoma adjustment + nutritional issues + family meeting requested

คำถาม: post-emergency surgery in elderly + frailty + multimorbidity', '[{"label":"A","text":"Standard hospital discharge"},{"label":"B","text":"Integrative post-acute care of frail elderly with complex multimorbidity post-emergency surgery"},{"label":"C","text":"Aggressive curative chemotherapy"},{"label":"D","text":"Repeat surgery for stoma reversal immediately"},{"label":"E","text":"Discharge to nursing home without follow-up"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Integrative post-acute care of frail elderly with complex multimorbidity post-emergency surgery**: (1) **Frailty assessment**: - **Clinical Frailty Scale (CFS)** — Rockwood (1-9 scale) - **Fried Frailty Phenotype** — weight loss, exhaustion, weakness, slowness, low activity (3+ of 5 = frail) - Frailty associated with: increased mortality, complications, readmission, functional decline, mortality post-emergency surgery substantially higher; (2) **Comprehensive Geriatric Assessment (CGA)** — multidisciplinary: medical, functional, cognitive, psychological, social, environmental, nutrition, polypharmacy review; (3) **Stoma care + rehabilitation**: stoma nurse education (intensive!), peristomal skin care, appliance fit, dietary, body image, sexual function discussion; (4) **Nutrition**: optimize (high protein, calorie; assess for sarcopenia; consider oral supplements; tube feeding if oral inadequate); body composition; (5) **Functional rehabilitation**: PT, OT, mobility, ADL training, fall prevention; goal-setting; (6) **Cardiopulmonary optimization**: pulmonary rehab, COPD management (inhaler, bronchodilator, smoking cessation if not already), cardiac optimization (heart failure, IHD), DM control; (7) **Renal**: medication dose adjust, avoid nephrotoxic, fluid balance, electrolyte; (8) **Polypharmacy**: STOPP/START criteria, deprescribing inappropriate medications, simplify regimens; (9) **Goals of care discussion**: - Patient preferences + values - Realistic expectations for recovery / functional outcomes - Advance care planning + healthcare proxy - Code status discussion - Cancer surveillance considering competing risks (limited life expectancy with COPD/IHD/CKD) - Future surgery (reversal of Hartmann''s? not necessary if quality of life adequate with stoma) - Hospice/palliative integration as appropriate; (10) **Family + caregiver support**: caregiver burden, respite, community resources, social work; (11) **Cancer follow-up**: adjuvant chemo considerations (often not pursued in frail elderly with limited life expectancy); colonoscopy surveillance balanced with comorbidity; (12) **Discharge planning**: home with services OR subacute rehab OR long-term care — patient + family choice; coordination of services; (13) **Mental health**: depression screen, anxiety, cognitive screen; (14) **Future surgical decisions**: prehabilitation if planned procedures; shared decision-making with full risk discussion

---

**Geriatric surgery + frailty** — distinct paradigm for older adults. Heterogeneity of older adults — biological age ≠ chronological age. **Frailty**: clinical syndrome of decreased physiologic reserve + increased vulnerability to stressors. Associated with: post-op complications ↑ 2-3x, mortality ↑, readmission ↑, functional decline ↑, institutionalization ↑. **Assessment tools**: 1. **Clinical Frailty Scale (CFS)** — Rockwood 1-9; visual + clinical 2. **Fried Frailty Phenotype** — 5 criteria (3+ = frail) 3. **Modified Frailty Index** — comorbidity-based 4. **Edmonton Frail Scale** **Comprehensive Geriatric Assessment (CGA)** — multidisciplinary: 1. Medical — disease management + cognition 2. Functional — ADLs, IADLs, mobility 3. Psychological — depression, cognition (MMSE, MoCA), delirium screen 4. Social — caregiver, isolation, financial 5. Environmental — home safety 6. Nutrition — MNA-SF 7. Medication — polypharmacy review + deprescribing (STOPP/START) **Pre-op optimization (prehabilitation)** for frail elderly facing elective surgery: - 4-6 weeks exercise + nutrition + psychological preparation - Improves functional outcome, complications, recovery **Post-op care** — geriatric surgery models (ACS-NSQIP-Geriatric, ACS Geriatric Surgery Verification Program): - Delirium prevention (HELP, ABCDEF bundles, early mobility, sleep, avoid restraints/Foley/restrictive meds) - Pain management (multimodal, opioid-sparing, avoid benzodiazepines) - Mobility early - Nutrition - Functional + cognitive monitoring **Stoma care** — intensive education + ongoing support critical for patient acceptance + quality of life. **Decision-making**: - Shared decision-making with full disclosure of risks + outcomes including QALY/functional - Goals of care alignment with patient values - Advance care planning - Healthcare proxy - Hospice/palliative when appropriate **Multi-disciplinary follow-up**: surgeon, primary care, geriatrician, oncologist, palliative, mental health, social work, rehab — coordinated to address whole person.', NULL,
  'hard', 'gi', 'review',
  'surgery', 'integrative', 'gi', 'adult',
  'ACS Geriatric Surgery Verification Program; Robinson TN et al. Ann Surg; Hall DE et al. JAMA Surg; Rockwood K et al. CMAJ', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ผู้ป่วยอายุ 75 ปี end-stage COPD + IHD + CKD post-emergency Hartmann''s procedure for perforated colorectal cancer 1 month ago — now in subacute rehab + stoma adjustment + nutritional issues + family meeting requested

คำถาม: post-emergency surgery in elderly + frailty + multimorbidity'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 28 ปี post-bariatric gastric bypass 1 ปี + ตั้งครรภ์ 24 weeks GA แรกหลังผ่าตัด มา outpatient ปกติ

คำถาม: integrative management', '[{"label":"A","text":"Standard pregnancy care only"},{"label":"B","text":"Pregnancy after bariatric surgery — integrative high-risk obstetric care"},{"label":"C","text":"Reverse bariatric surgery for pregnancy"},{"label":"D","text":"Standard prenatal vitamins alone"},{"label":"E","text":"No follow-up needed"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Pregnancy after bariatric surgery — integrative high-risk obstetric care**: (1) **Timing recommendation** — wait 12-18 months post-bariatric for weight stabilization + nutritional repletion before conceiving; this patient at 1 yr is borderline; (2) **Nutritional considerations** (intensive in pregnancy + post-bariatric): - **Vitamin/mineral deficiency screening + supplementation comprehensive**: B12 (often parenteral monthly post-RYGB/sleeve), folate (5 mg/day if RYGB), iron (oral or IV), calcium + vitamin D, thiamine, vitamin A (caution teratogenic high dose), vitamin E, K - **Avoid**: prenatal vitamins with retinol > 5000 IU (use β-carotene) - **High-quality protein** — focus 60-80 g/day - **Prenatal multivitamin** specific for bariatric patients (Bariatric Advantage, others) - **Monitor**: q trimester labs (CBC, ferritin, iron, B12, folate, vit D, A, calcium, albumin, prealbumin); (3) **Glucose tolerance** — modified screening: - Standard 50-g glucose challenge → 75-g 3-h OGTT problematic post-bariatric (dumping); - Use **fasting + 2-hr postprandial glucose monitoring** week 24-28 or earlier - Pregnancy + bariatric: gestational DM less common but undiagnosable by standard tests; (4) **Symptoms to monitor**: - Nausea/vomiting beyond typical hyperemesis — consider internal hernia (life-threatening, classic post-RYGB pregnancy risk!) - Abdominal pain — internal hernia, SBO from adhesions, dumping - Hypoglycemia (post-bariatric hypoglycemia worsened in pregnancy) - Reflux exacerbation - Difficulty swallowing; (5) **Surgical emergency consideration**: internal hernia high index of suspicion in pregnant post-RYGB — pregnancy + weight loss → mesenteric defects opening; misdiagnosed often → fetal/maternal death; threshold for diagnostic laparoscopy lower; multidisciplinary OB + bariatric/general surgery; (6) **Obstetric considerations**: - Lower risk: GDM, hypertensive disorders, macrosomia (vs obese non-bariatric) - Higher risk: SGA (small for gestational age), preterm birth, fetal anomalies if nutritional deficiency, IUGR; - More C-section in some studies; - Fetal growth monitoring critical; (7) **Breastfeeding** — encourage, but monitor for hypoglycemia + nutritional adequacy; (8) **Long-term** — maternal weight management post-pregnancy + future pregnancies + lifetime nutritional supplementation; (9) **Family + lifestyle**: psychological, social support, partner involvement, contraception planning between pregnancies

---

**Pregnancy after bariatric surgery** — increasingly common (bariatric prevalence growing in reproductive-age women). **Timing recommendations**: - Wait 12-18 months post-bariatric (especially RYGB, sleeve) for weight stabilization + nutritional repletion - Contraception during this period important (oral contraception efficacy may be reduced post-malabsorptive bariatric) **Nutritional vulnerability**: - Restrictive (sleeve, gastric band): less malabsorption but reduced intake - Malabsorptive (RYGB, BPD-DS): both reduced intake + bypassed nutrient absorption - Pregnancy ↑ nutrient demands × baseline post-bariatric deficiency = high-risk **Key deficiencies + supplementation**: 1. B12 — parenteral monthly often needed (RYGB > sleeve > band) 2. Folate — 5 mg/day for RYGB (vs 0.4 mg standard) — neural tube defect prevention 3. Iron — IV or aggressive oral; iron-deficiency anemia common 4. Calcium + Vit D — citrate form (better absorbed without acid), high-dose vit D 5. Thiamine — Wernicke risk with hyperemesis 6. Vit A — careful (teratogenic high dose); use β-carotene; deficiency → night blindness + birth defects 7. Protein — focus 60-80 g/day **Glucose screening** in pregnancy post-bariatric: - Standard OGTT problematic (dumping syndrome) - Use fasting + 2-h postprandial monitoring instead - GDM diagnosed by alternative means **Symptoms requiring intervention**: - Abdominal pain — internal hernia high suspicion (life-threatening!) — diagnostic laparoscopy threshold lower; CT signs may be subtle - Hypoglycemia (post-bariatric reactive) — exacerbated in pregnancy - Persistent nausea/vomiting beyond typical — workup - Reflux — PPI safe in pregnancy **Obstetric outcomes**: - **Reduced**: gestational DM, hypertensive disorders, macrosomia, C-section in some studies (vs obese non-bariatric controls) - **Increased**: SGA, preterm birth, IUGR, anemia, vitamin deficiency — close fetal growth monitoring **Internal hernia in pregnancy** — surgical emergency: presents as pain, vomiting; CT may miss; do NOT delay diagnostic laparoscopy; fetal + maternal mortality if delayed.', NULL,
  'medium', 'obgyn', 'review',
  'surgery', 'integrative', 'obgyn', 'adult',
  'ACOG Committee Opinion 549 — Bariatric Surgery + Pregnancy; ASMBS Pregnancy after Bariatric Surgery Guidelines; Mead NC et al. Surg Obes Relat Dis', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ผู้ป่วยอายุ 28 ปี post-bariatric gastric bypass 1 ปี + ตั้งครรภ์ 24 weeks GA แรกหลังผ่าตัด มา outpatient ปกติ

คำถาม: integrative management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 70 ปี smoker, HT, DM มา routine clinic; carotid US screening: > 70% stenosis right ICA + asymptomatic

คำถาม: management of asymptomatic carotid stenosis', '[{"label":"A","text":"Immediate carotid endarterectomy (CEA) for all"},{"label":"B","text":"Asymptomatic carotid stenosis > 70% — modern management balancing intervention vs medical"},{"label":"C","text":"No treatment needed"},{"label":"D","text":"Anticoagulation alone"},{"label":"E","text":"Repeat US 5 years"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Asymptomatic carotid stenosis > 70% — modern management balancing intervention vs medical**: (1) **Optimize medical therapy first** — modern outcomes much better than CEA/CAS era trials (ACAS 1995, ACST 2004): - **Antiplatelet** (aspirin 81-100 mg or clopidogrel 75 mg) - **High-intensity statin** (atorvastatin 40-80 mg or rosuvastatin 20-40 mg) — target LDL < 70 - **BP control** target < 130/80 - **Glycemic control** (HbA1c < 7-8%) - **Smoking cessation absolute** - **Lifestyle**: diet, exercise, weight; (2) **Decision for intervention** (CEA or CAS) — increasingly nuanced: - **Old recommendations** (ACAS/ACST): CEA if > 60-70% stenosis + life expectancy > 5 yr + low perioperative risk (< 3%) - **Modern era** — medical therapy improvements have reduced stroke rate in asymptomatic; benefit of intervention smaller; CREST-2 trial ongoing to clarify - **Patient-specific factors**: imaging features (plaque morphology, microembolic signal on TCD), age, life expectancy, comorbidity, patient preference; (3) **Symptomatic carotid stenosis** (TIA/stroke with > 50-70% stenosis ipsilateral) — clear benefit of intervention within 2 weeks of event (NASCET, ECST trials); (4) **Procedural options**: - **CEA (Carotid Endarterectomy)** — gold standard; 1.5-3% perioperative stroke/death in asymptomatic - **CAS (Carotid Artery Stenting)** with embolic protection — alternative for high-risk surgical patients (CREST trial NEJM 2010); higher stroke risk especially in elderly; - **Transcarotid Artery Revascularization (TCAR)** — newer hybrid (open + endovascular with flow reversal); reduced stroke vs CAS; promising; (5) **Surveillance**: annual US duplex if not intervened; (6) **Multidisciplinary**: neurology, vascular surgery, IR, medical; (7) **Patient education**: TIA symptoms — call immediately + emergency evaluation; (8) **Long-term medical optimization** lifelong regardless of intervention

---

**Carotid artery stenosis** — atherosclerotic stenosis at carotid bifurcation; risk of ipsilateral ischemic stroke. **Symptomatic vs asymptomatic — different management thresholds**: 1. **Symptomatic (recent TIA / ischemic stroke / amaurosis fugax in ipsilateral territory)**: - 50-69% stenosis: moderate benefit from CEA - 70-99% stenosis: significant benefit from CEA — intervene within 2 weeks of event - 100% (occluded): no intervention (NASCET 1991, ECST 1998) 2. **Asymptomatic**: - > 60-70% stenosis traditionally: CEA benefit modest (ACAS 1995 — 5% absolute risk reduction over 5 yr if perioperative risk < 3%) - Modern medical therapy era: medical alone increasingly competitive — CREST-2 ongoing - Decision individualized **Imaging**: duplex US (screening + initial), CTA or MRA (confirm), digital subtraction angiography (rare now). **Procedural options**: 1. **Carotid Endarterectomy (CEA)** — gold standard; open surgery to remove plaque; perioperative stroke/death: < 3% asymptomatic, < 6% symptomatic accepted 2. **Carotid Artery Stenting (CAS)** — endovascular; alternative for high-risk surgical patients (radiation neck, prior CEA, contralateral cranial nerve palsy, anatomic considerations); higher stroke risk in elderly + CREST trial (NEJM 2010) — equivalent composite endpoint but CAS more stroke, CEA more MI 3. **TCAR (Transcarotid Artery Revascularization)** — hybrid: open transcarotid access + flow reversal + stenting; reduced stroke vs traditional CAS; growing adoption **Patient selection**: - High-risk for CEA (consider CAS/TCAR): radiation neck, prior CEA, contralateral cranial nerve palsy, high lesion, hostile neck - Standard risk: CEA preferred per most guidelines **Medical therapy + lifestyle** — backbone for all patients regardless of intervention: antiplatelet, high-intensity statin, BP control, smoking cessation, diabetes control, exercise, diet. **Imaging surveillance** for asymptomatic — annual US duplex; reassess intervention decision.', NULL,
  'medium', 'vascular', 'review',
  'surgery', 'clinical_decision', 'vascular', 'adult',
  'AHA/ASA Carotid Disease Guidelines 2014; SVS Carotid Guidelines; Brott TG et al. NEJM 2010 (CREST); CREST-2 ongoing', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 70 ปี smoker, HT, DM มา routine clinic; carotid US screening: > 70% stenosis right ICA + asymptomatic

คำถาม: management of asymptomatic carotid stenosis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 32 ปี G1P0 6 weeks postpartum มาด้วยอาการ bilateral leg edema + dyspnea + chest pain progressive 1 สัปดาห์ + orthopnea

VS: BP 84/52, HR 124, RR 28, SpO2 92% room air
Leg: bilateral pitting edema; lung crackles bilateral; JVP elevated; S3 gallop

Echo: dilated cardiomyopathy, LVEF 22%, no significant valve disease
NT-proBNP markedly elevated

Diagnosis: peripartum cardiomyopathy

คำถาม: management', '[{"label":"A","text":"Observation outpatient"},{"label":"B","text":"Peripartum cardiomyopathy (PPCM) — heart failure with reduced EF in late pregnancy/postpartum"},{"label":"C","text":"Discharge home"},{"label":"D","text":"No medication"},{"label":"E","text":"Wait for spontaneous resolution"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Peripartum cardiomyopathy (PPCM) — heart failure with reduced EF in late pregnancy/postpartum**: (1) **Definition**: HF with LVEF < 45% developing in last month of pregnancy or up to 5 months postpartum, without other identifiable cause; incidence 1:2,000-4,000 live births; (2) **Acute management** — standard HF: - Diuretic (furosemide IV) for volume overload - Vasodilator (nitroglycerin, nitroprusside) for afterload - Inotrope (dobutamine, milrinone) for low output - Avoid ACE-I/ARB during pregnancy (teratogenic) — OK postpartum + breastfeeding compatible (enalapril, captopril breast-milk-safe) - Beta-blocker (carvedilol, metoprolol — safe in pregnancy + breastfeeding) - Spironolactone (postpartum) - SGLT2 inhibitor — emerging (dapagliflozin per DAPA-HF) - Mechanical circulatory support (IABP, ECMO, LVAD) — refractory cardiogenic shock; (3) **Bromocriptine** — emerging treatment specifically for PPCM (per German PPCM Registry — Sliwa, Hilfiker-Kleiner) — based on hypothesis that abnormal prolactin cleavage product (16-kDa prolactin) is cardiotoxic; bromocriptine inhibits prolactin; 2.5 mg BID × 1 week then daily × 6 weeks; concomitant anticoagulation (bromocriptine + low EF = thrombosis risk); not universally accepted but increasingly used; precludes breastfeeding; (4) **Anticoagulation** — LV thrombus risk with EF < 30%; LMWH (pregnancy/breastfeeding safe); warfarin postpartum + breastfeeding OK; DOACs avoid breastfeeding; (5) **Multidisciplinary**: cardiology, OB, MFM, anesthesia, neonatology, ICU; (6) **Future pregnancies**: high recurrence risk especially if LV function not normalized; counsel against if persistent LV dysfunction; need pre-conception evaluation; (7) **Prognosis**: ~50% recover EF > 50% within 6-12 months; 20% need transplant or LVAD; 5-10% mortality; (8) **Genetic** — emerging recognition (TTN, MYH7, others) — consider testing in selected

---

**Peripartum Cardiomyopathy (PPCM)** — defined: heart failure with LVEF < 45% in last month of pregnancy or up to 5 months postpartum, no other identifiable cause. Incidence ~1:2,000-4,000 live births (higher in Africa, Haiti); race + ethnic disparities. **Pathophysiology** (emerging): - Oxidative stress + abnormal prolactin processing → 16-kDa anti-angiogenic prolactin fragment → microvascular damage + cardiomyocyte injury - Genetic predisposition (TTN, MYH7, SCN5A variants) - Viral myocarditis, autoimmune **Risk factors**: African descent, multiparity, age > 30, multiple gestation, hypertensive disorders of pregnancy, prolonged tocolysis, malnutrition. **Presentation**: HF symptoms — dyspnea, orthopnea, edema, fatigue; often missed early (overlaps physiologic pregnancy). **Diagnosis**: clinical + echocardiogram (LVEF, LV dilation, no other cause); BNP elevated; rule out PE, MI, valvular, thyroid. **Management** — standard HF guidelines with pregnancy adjustments: - Diuretic (furosemide — pregnancy + breastfeeding OK) - Beta-blocker (metoprolol, carvedilol — OK in pregnancy + breastfeeding) - ACE-I/ARB (avoid pregnancy — teratogen; OK postpartum + breastfeeding-safe: enalapril, captopril) - Spironolactone (postpartum) - Sacubitril/valsartan (postpartum only) - SGLT2 (postpartum) **Bromocriptine** — specifically considered for PPCM: - Mechanism: blocks abnormal prolactin processing - Evidence: small RCTs (BROAH-Africa, German Registry) suggest benefit on LV recovery - Risk: thrombosis (combined low EF + bromocriptine) → anticoagulate concurrently; precludes breastfeeding - Controversial — increasingly used in Europe + Africa; less in US **Anticoagulation**: - LMWH during pregnancy + first weeks postpartum if EF < 30% - Warfarin postpartum/breastfeeding OK - DOAC avoid breastfeeding **Severe refractory disease**: IABP, ECMO, LVAD, transplant. **Future pregnancies** — high-risk: recurrence 20-50% if LV recovered; 50% if persistent dysfunction; mortality risk. Counseling pre-conception.', NULL,
  'hard', 'cardiovascular', 'review',
  'surgery', 'clinical_decision', 'cardiovascular', 'adult',
  'ESC HF Pregnancy 2018; ACOG; Sliwa K et al. Eur J Heart Fail (PPCM Registry); Hilfiker-Kleiner D et al. Cell', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 32 ปี G1P0 6 weeks postpartum มาด้วยอาการ bilateral leg edema + dyspnea + chest pain progressive 1 สัปดาห์ + orthopnea

VS: BP 84/52, HR 124, RR 28, SpO2 92% room air
Leg: bilateral pitting edema; lung crackles bilateral; JVP elevated; S3 gallop

Echo: dilated cardiomyopathy, LVEF 22%, no significant valve disease
NT-proBNP markedly elevated

Diagnosis: peripartum cardiomyopathy

คำถาม: management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี end-stage renal disease on hemodialysis 5 ปี + secondary hyperparathyroidism severe + persistent hypercalcemia + bone pain + pruritus + cardiovascular calcification

Lab: PTH 2,400, Ca 10.8, PO4 6.8, vitamin D low, ALP elevated
Sestamibi scan: 4-gland hyperplasia

Medical therapy failed (vitamin D analogs, phosphate binders, calcimimetic cinacalcet)

คำถาม: management', '[{"label":"A","text":"Increase cinacalcet dose only"},{"label":"B","text":"Tertiary hyperparathyroidism — failed medical therapy → parathyroidectomy"},{"label":"C","text":"Total nephrectomy"},{"label":"D","text":"Increase dialysis sessions"},{"label":"E","text":"Observation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Tertiary hyperparathyroidism — failed medical therapy → parathyroidectomy**: (1) **Tertiary hyperparathyroidism** — secondary HPT becomes autonomous after long-term ESRD/dialysis or post-transplant; failure of feedback regulation; persistent + hypercalcemia + high PTH despite normal Ca/PO4; (2) **Indications for surgical parathyroidectomy in CKD/ESRD**: - Failed medical (cinacalcet, vit D analogs, phosphate binders, dialysate Ca optimization) - Persistent PTH > 800-1000 despite max medical - Symptomatic (bone pain, fractures, calciphylaxis, vascular calcification progression, pruritus refractory) - Calciphylaxis (calcific uremic arteriolopathy) - Severe hypercalcemia - Quality of life impacted; (3) **Surgical options for 4-gland hyperplasia**: - **Subtotal (3.5-gland) parathyroidectomy** — leave ~50 mg of one gland for residual function - **Total parathyroidectomy + autotransplantation** — implant fragments into forearm muscle (more accessible if recurrence) - **Total parathyroidectomy without autotransplant** — patient becomes permanently hypoparathyroid; requires lifelong Ca + active vit D; some advocate for transplant candidates (clean slate); (4) **Pre-op localization**: sestamibi + US neck; ectopic glands sometimes (mediastinal, intrathyroidal); 4D-CT if discordant; (5) **Intra-op PTH monitoring** — drop > 80% from baseline + into normal range or < 100 = adequate; (6) **Post-op hungry bone syndrome** — common in tertiary HPT with severe bone disease; rapid Ca/PO4/Mg drop into bones; aggressive IV Ca gluconate + vit D + Mg replacement; ICU monitoring; can be prolonged weeks-months; (7) **Long-term**: continue PO4 binders, dialysis, monitor PTH, Ca, PO4; cardiovascular risk reduction; bone health (DEXA, bisphosphonate if indicated); (8) **Post-renal transplant**: parathyroidectomy may be needed if persistent tertiary HPT after transplant — typically considered if PTH > 200 + hypercalcemia or other complications > 1 yr post-transplant + cinacalcet failed

---

**Hyperparathyroidism spectrum**: - **Primary** — autonomous adenoma/hyperplasia/cancer; high Ca + high PTH; surgery indicated per criteria - **Secondary** — physiologic response to hypocalcemia, vit D deficiency, hyperphosphatemia (CKD); high PTH, low/normal Ca; treat underlying - **Tertiary** — secondary becomes autonomous (long-standing CKD); high PTH + high Ca; failed feedback; surgery often needed **Secondary HPT in CKD** — multifactorial: 1. ↓ 1,25-vit D production (kidney failure to activate) 2. ↓ Ca → ↑ PTH 3. ↑ PO4 → ↑ FGF23 → ↓ 1α-hydroxylase → ↓ vit D 4. Skeletal resistance to PTH **Medical therapy** for secondary HPT: - Phosphate restriction + binders (calcium acetate, sevelamer, lanthanum, ferric citrate, sucroferric oxyhydroxide) - Vitamin D analogs (calcitriol, paricalcitol, doxercalciferol) - Calcimimetic (cinacalcet, etelcalcetide IV) — sensitizes Ca-sensing receptor → ↓ PTH - Dialysate Ca optimization **Indications for parathyroidectomy in CKD/ESRD**: - Failed medical therapy - Persistent PTH > 800-1000 - Symptomatic (bone pain, fractures, calciphylaxis, refractory pruritus) - Severe hypercalcemia - Vascular calcification progression - Quality of life impacted **Surgical options for 4-gland hyperplasia** (secondary/tertiary HPT — usually all 4 glands hyperplastic): 1. **Subtotal parathyroidectomy** (3.5 gland) — leave small remnant of one gland 2. **Total parathyroidectomy + autotransplantation** — implant fragments into forearm muscle (easy access if recurrence) 3. **Total parathyroidectomy alone** — patient permanently hypoparathyroid (especially if young transplant candidate to clean slate) **Pre-op localization**: sestamibi + US; 4D-CT if discordant; intraoperative PTH monitoring critical. **Hungry bone syndrome**: rapid Ca/PO4/Mg uptake into bones post-surgery in patients with severe pre-op bone disease; aggressive IV Ca + active vit D + Mg replacement; weeks-months. **Calciphylaxis** (calcific uremic arteriolopathy) — devastating complication of dialysis + HPT: painful skin lesions + necrosis; mortality 50-80%; treat: sodium thiosulfate IV, debridement, parathyroidectomy in selected, address underlying.', NULL,
  'hard', 'endocrine_metabolic', 'review',
  'surgery', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'KDIGO Mineral Bone Disorder Guidelines 2017; AAES Parathyroidectomy Guidelines; Lau WL, Obi Y et al. Curr Opin Nephrol Hypertens', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี end-stage renal disease on hemodialysis 5 ปี + secondary hyperparathyroidism severe + persistent hypercalcemia + bone pain + pruritus + cardiovascular calcification

Lab: PTH 2,400, Ca 10.8, PO4 6.8, vitamin D low, ALP elevated
Sestamibi scan: 4-gland hyperplasia

Medical therapy failed (vitamin D analogs, phosphate binders, calcimimetic cinacalcet)

คำถาม: management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี post-liver transplant 6 ปี on tacrolimus + mycophenolate + low-dose prednisone — มาด้วย persistent shoulder + back pain + new lump on cheek 2 weeks

Exam: 2 cm firm mobile mass at parotid area, no overlying skin changes
Skin: multiple actinic keratoses + sun damage; 1 scaly lesion 8 mm on dorsum hand

Biopsy of parotid mass: squamous cell carcinoma
Skin lesion biopsy: cutaneous SCC + perineural invasion

คำถาม: management', '[{"label":"A","text":"Continue current immunosuppression unchanged"},{"label":"B","text":"Multiple cutaneous + parotid SCC in transplant recipient — high-risk for aggressive disease + multimodal management"},{"label":"C","text":"Discharge to hospice"},{"label":"D","text":"Stop transplant medications"},{"label":"E","text":"Single modality treatment for both"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Multiple cutaneous + parotid SCC in transplant recipient — high-risk for aggressive disease + multimodal management**: (1) **Multidisciplinary**: transplant surgery, hepatology, oncology, dermatology, surgical oncology (H&N), radiation oncology, pathology; (2) **Immunosuppression adjustment**: - **Reduce overall immunosuppression** cautiously (balance graft vs cancer) - **Switch from calcineurin inhibitor (tacrolimus) to mTOR inhibitor (sirolimus or everolimus)** — reduces skin cancer risk + has anti-tumor activity (Euler study + others) - **Reduce mycophenolate** dose - **Continue low-dose prednisone**; (3) **Cutaneous SCC management**: - Wide local excision with appropriate margins (4-6 mm low-risk, 6-10 mm high-risk per NCCN) - Mohs surgery for high-risk site (face, perineural, recurrent) — preserve tissue + margin control - Adjuvant radiation for perineural invasion / large / aggressive / positive margins - Sentinel lymph node biopsy controversial in transplant SCC — often forgo - Systemic therapy for advanced/metastatic: cemiplimab (PD-1) — caution graft rejection; pembrolizumab alternative; cetuximab; chemo; (4) **Parotid SCC (likely metastatic from cutaneous)**: - Total or superficial parotidectomy + neck dissection (level I-V) - Adjuvant radiation post-op (likely high-risk features) ± concurrent chemo for residual/high-risk - Facial nerve preservation when feasible; (5) **Immune checkpoint inhibitors** in transplant — risk of graft rejection 40-50% per case series; weigh risk/benefit carefully; close transplant monitoring; (6) **Dermatology** lifelong intensive surveillance + sun protection + treat field cancerization (5-FU, imiquimod, PDT for actinic keratoses, low-dose retinoid prophylaxis); educate patient + skin self-exam; (7) **Other cancer surveillance** intensified — PTLD, anal, cervical, urologic, lung, GI; (8) **Counsel patient** on increased cancer risk lifelong post-transplant; aggressive sun protection (SPF 50+, clothing, shade); regular dermatology; (9) **Vaccination** updated; (10) **Goals of care** — balance cancer treatment intensity with overall prognosis + graft survival

---

**Malignancy in transplant recipients** — increased 2-5x vs general population due to immunosuppression + viral oncogenesis (HPV, HHV-8, EBV) + chronic inflammation + UV exposure (skin). **Common cancers post-transplant** (lifetime cumulative incidence): - **Cutaneous SCC** — 65-100x increased (vs 10x basal cell, 3x melanoma) - PTLD (EBV) - Kaposi''s sarcoma (HHV-8) - HPV-related (cervical, anal, oropharyngeal) - Renal cell, urothelial - Other solid organs slightly increased **Cutaneous SCC in transplant patient — aggressive features**: - More numerous - More aggressive (perineural, vascular invasion, depth) - Higher metastatic rate (5-10% vs 1-2% general) - Field cancerization (multiple primary lesions in sun-exposed areas) - Treatment-resistant **Management**: 1. **Adjust immunosuppression** — reduce overall burden, switch CNI to mTOR (sirolimus) which has anti-skin cancer effect 2. **Surgical excision** with appropriate margins (4-6 mm low-risk, 6-10 mm or Mohs for high-risk) 3. **Adjuvant radiation** for perineural, positive margin, large 4. **Systemic for advanced/metastatic**: - Cemiplimab (anti-PD-1) — first-line approved 2018; high response 50%; risk graft rejection in transplant - Pembrolizumab alternative - Cetuximab (anti-EGFR) - Chemotherapy (cisplatin-based) **mTOR inhibitor switch** (sirolimus, everolimus) post-transplant in patient with skin cancer history — reduces new lesion development + has anti-tumor effect (Euler N Engl J Med 2012 RESCUE trial). **Prevention** — lifelong: - Strict sun protection (SPF 50+, clothing, shade, avoid peak hours) - Self skin exam monthly - Dermatology q6-12 mo - Field treatment of actinic keratoses (5-FU, imiquimod, PDT) - Oral nicotinamide (vit B3) — reduces NMSC risk in immunocompetent (ONTRAC trial) - Low-dose retinoid (acitretin) prophylaxis in high-risk **Parotid + neck SCC** — often metastatic from cutaneous (perineural spread); treatment: surgery + RT (post-op); chemo / IO for advanced.', NULL,
  'hard', 'hemato_onco', 'review',
  'surgery', 'integrative', 'hemato_onco', 'adult',
  'AST Transplant Malignancy Working Group; NCCN Squamous Cell Skin Cancer; Migden MR et al. NEJM 2018 (Cemiplimab)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี post-liver transplant 6 ปี on tacrolimus + mycophenolate + low-dose prednisone — มาด้วย persistent shoulder + back pain + new lump on cheek 2 weeks

Exam: 2 cm firm mobile mass at parotid area, no overlying skin changes
Skin: multiple actinic keratoses + sun damage; 1 scaly lesion 8 mm on dorsum hand

Biopsy of parotid mass: squamous cell carcinoma
Skin lesion biopsy: cutaneous SCC + perineural invasion

คำถาม: management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Basic science: shock + hemodynamic monitoring

ผู้ป่วย ICU post-op major colorectal surgery มี persistent hypotension MAP 58 despite IV fluid 4 L NSS

คำถาม: classification of shock + management', '[{"label":"A","text":"Continue same management"},{"label":"B","text":"Differential diagnosis of shock + targeted management"},{"label":"C","text":"Discontinue all fluid"},{"label":"D","text":"Steroid alone"},{"label":"E","text":"Observation only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Differential diagnosis of shock + targeted management**: (1) **Classification (4 types)**: - **Hypovolemic** — blood/fluid loss; cold extremities, narrow pulse pressure, ↓ CVP, ↑ SVR, ↓ CO; e.g., hemorrhage, dehydration - **Cardiogenic** — pump failure; cold, ↑ CVP, ↑ SVR, ↓ CO, pulmonary edema; e.g., MI, HF, valve, arrhythmia - **Obstructive** — mechanical obstruction; ↓ CO; e.g., PE (acute RV failure), cardiac tamponade, tension pneumothorax - **Distributive (vasodilatory)** — ↓ SVR with ↑ or normal CO; warm extremities (early), wide pulse pressure; e.g., septic (most common), neurogenic, anaphylactic; (2) **Bedside assessment**: - Clinical: skin (cold/warm), capillary refill, JVP, lung crackles, abdominal exam - Vitals: BP, HR, RR, SpO2, MAP, pulse pressure - Hemodynamic markers: lactate, base deficit, ScvO2 (or SvO2), CVP (less utility now) - **Bedside echo + ultrasound (POCUS / RUSH protocol)**: - Cardiac (LV function, RV, tamponade, IVC) - Lung (B-lines, pneumothorax) - Aorta (AAA) - DVT scan; (3) **Dynamic measures of fluid responsiveness**: - **Passive leg raise** — temporary autotransfusion; ↑ stroke volume 10% indicates responsiveness - **Pulse pressure variation (PPV) / stroke volume variation (SVV)** — > 12-13% suggests responsiveness; requires sinus rhythm + mechanical ventilation + ARDS-net TV - **Lung US B-lines** — surrogate for fluid status; (4) **Targeted management**: - **Hypovolemic**: fluid (crystalloid then blood if hemorrhage); identify + control source - **Cardiogenic**: inotrope (dobutamine, milrinone); pump support (IABP, ECMO, LVAD); coronary revascularization if MI; valve intervention if needed - **Obstructive**: relieve obstruction — chest tube tension pneumo, pericardiocentesis tamponade, thrombolysis/thrombectomy PE - **Distributive (sepsis most common)**: - IV fluid 30 mL/kg crystalloid (Surviving Sepsis 2021) - Broad-spectrum antibiotic within 1h - Source control - Vasopressor (norepinephrine first-line; vasopressin, epinephrine, phenylephrine as adjuncts) - Hydrocortisone if refractory shock (ADRENAL, APROCCHSS trials) - Goal: MAP ≥ 65 + lactate clearance; (5) **Source control** essential — surgical, IR, antibiotic; (6) **Critical care**: ABCDEF bundle, lung-protective ventilation, glycemic control, DVT prophylaxis, nutrition

---

**Shock classification + management** — fundamental critical care + surgical knowledge. **4 types of shock** (with hemodynamic profile): 1. **Hypovolemic** — ↓ preload, ↑ SVR, ↓ CO; cold, dry; hemorrhage, dehydration; treat with fluid/blood + source control 2. **Cardiogenic** — ↑ preload, ↑ SVR, ↓ CO; cold, wet (pulmonary edema); MI, HF, arrhythmia, valve; inotrope, pump support 3. **Obstructive** — ↑ preload (or ↓ depending on cause), ↑ SVR, ↓ CO; cold; PE, tamponade, tension pneumo; relieve obstruction 4. **Distributive** — ↓ SVR, ↑ or normal CO; warm (early); septic, neurogenic, anaphylactic; vasopressor + cause-specific **Sepsis** (most common ICU shock): - Sepsis-3 definition: life-threatening organ dysfunction from dysregulated host response to infection - Septic shock: vasopressor required for MAP ≥ 65 + lactate > 2 despite fluid - Surviving Sepsis 1h bundle: lactate, blood cultures BEFORE antibiotic, broad-spectrum antibiotic, 30 mL/kg crystalloid (for hypotension or lactate ≥ 4), vasopressor for refractory MAP **Hemodynamic monitoring evolution**: - CVP / Swan-Ganz catheter — declining utility (poor fluid responsiveness predictor) - Dynamic measures preferred: PPV/SVV (ventilated, sinus rhythm), PLR (any patient), POCUS - Lactate clearance, ScvO2 — targets - POCUS / RUSH (Rapid Ultrasound for Shock + Hypotension) — bedside diagnosis of shock etiology **Fluid management** — restrictive trend (avoid over-resuscitation): - Initial 30 mL/kg crystalloid for septic shock per Surviving Sepsis - Reassess at each bolus - Use dynamic measures of responsiveness - Stop when no longer responsive **Vasopressors**: - **Norepinephrine** — first-line for septic shock (Surviving Sepsis); α + minor β - **Vasopressin** — second-line; adjunct (VANISH, VASST) - **Epinephrine** — refractory; β > α at lower doses; α dominant high - **Phenylephrine** — pure α; for tachyarrhythmia - **Dopamine** — fallen out of favor (more arrhythmia per De Backer NEJM 2010) **Inotropes**: dobutamine (β1 > β2 + α), milrinone (PDE3 inhibitor, vasodilator, inodilator). **Steroids**: hydrocortisone 200 mg/day in refractory septic shock (ADRENAL trial NEJM 2018, APROCCHSS).', NULL,
  'medium', 'cardiovascular', 'review',
  'surgery', 'basic_science', 'cardiovascular', 'adult',
  'Surviving Sepsis Campaign 2021; ACS Surgery Principles + Practice; Vincent JL et al. NEJM 2014; Annane D et al. NEJM 2018 (APROCCHSS)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'Basic science: shock + hemodynamic monitoring

ผู้ป่วย ICU post-op major colorectal surgery มี persistent hypotension MAP 58 despite IV fluid 4 L NSS

คำถาม: classification of shock + management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Basic science: surgical oncology principles

คำถาม: principles of surgical oncology + cancer staging + multidisciplinary care', '[{"label":"A","text":"Surgery alone is sufficient for all cancers"},{"label":"B","text":"Principles of surgical oncology + multimodality cancer care"},{"label":"C","text":"Avoid all multidisciplinary input"},{"label":"D","text":"Surgery only after metastasis develops"},{"label":"E","text":"Surgery never indicated for cancer"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Principles of surgical oncology + multimodality cancer care**: (1) **Cancer staging** — drives treatment: - **TNM staging** (AJCC 8th edition latest): T (tumor size/extent), N (nodal), M (distant mets) - Anatomic stage groupings (I-IV) - Prognostic markers (grade, biomarkers, molecular) integrated for some cancers (breast — Ki-67, ER/PR/HER2; thyroid — RAI risk; colon — MSI, KRAS) - Pathologic stage (post-resection) most accurate; (2) **Multidisciplinary team (MDT) tumor board** — standard of care: medical oncology, surgical oncology, radiation oncology, pathology, radiology, palliative, social work, nursing; (3) **Surgical principles**: - **R0 resection** (no residual tumor) — primary goal — improves survival in most cancers - R1 (microscopic residual), R2 (macroscopic residual) — adjuvant therapy considered to optimize outcomes - **Lymphadenectomy** — staging + therapeutic; minimum nodes per cancer type for adequate staging (e.g., colon ≥ 12 nodes, gastric ≥ 16) - **Sentinel node** — replaces full dissection in selected (melanoma, breast cN0); reduces morbidity - **Margins**: vary by cancer (e.g., ''no ink on tumor'' breast invasive; 1-2 cm melanoma; 5 cm gastric — guided by evidence) - **Tumor spillage avoidance** — touch + grasp tumor cautiously; en-bloc resection - **Cytoreduction** — when complete resection impossible (ovarian, peritoneal carcinomatosis) - **Minimally invasive vs open** — laparoscopic/robotic vs open — oncologic equivalence demonstrated in many (COLOR I-II for colon, ROLARR for rectum, LACC for cervix surprised inferior, others); (4) **Neoadjuvant therapy** — chemotherapy ± RT before surgery: - Downsize tumor (resectability) - Treat micrometastases - Assess in-vivo response (biology) - Improve sphincter/organ preservation (rectum, anus, larynx) - Examples: rectal (TNT — total neoadjuvant therapy), esophageal (CROSS), bladder, breast HER2+/TNBC; (5) **Adjuvant therapy** — post-resection: - Reduce recurrence risk based on stage + biology - Chemotherapy, RT, endocrine, targeted, immunotherapy - Evidence-based (e.g., colon stage III chemo, breast HER2+ trastuzumab); (6) **Palliative surgery** — symptom relief in incurable disease — bypass obstruction, hemorrhage control, fixation pathologic fractures; (7) **Survivorship**: surveillance, late effects monitoring, secondary prevention, lifestyle, psychological, vocational; (8) **Precision medicine**: molecular profiling guides targeted therapy + immunotherapy + clinical trials; (9) **Research + clinical trials** integration into care; (10) **Outcomes** measurement: OS, DFS, PFS, quality of life, patient-reported outcomes (PROs)

---

**Surgical Oncology Principles** — backbone of cancer care along with medical + radiation oncology. **Cancer staging — TNM (AJCC 8th ed 2017)**: - **T** — primary tumor (size, depth, invasion) - **N** — regional lymph nodes (number, location) - **M** — distant metastasis - **Stage groupings I-IV** — broad prognostic categories - Cancer-specific modifications + prognostic markers integrated **Clinical (cTNM) vs pathological (pTNM) vs post-treatment (ycTNM after neoadjuvant)**: - cTNM — pre-treatment clinical assessment - pTNM — post-resection pathological (most accurate) - ycTNM — after neoadjuvant therapy **Resection categories** (R classification): - R0 — no residual tumor (microscopic margins clear) - R1 — microscopic residual - R2 — macroscopic residual **Surgical principles**: 1. **R0 resection** is primary oncologic goal — improves OS in most cancers 2. **Adequate margin** — cancer-specific (NCCN guidelines) 3. **Adequate lymphadenectomy** — accurate staging + therapeutic 4. **En-bloc resection** — avoid tumor spillage 5. **No-touch principles** for vascular control (selected cancers) 6. **Multidisciplinary** team for treatment planning **Neoadjuvant therapy** indications: - Downsize for resectability - Test biology (in-vivo response) - Treat micrometastases early - Organ preservation - Examples: rectal cancer (TNT), breast HER2+/TNBC, esophageal (CROSS), pancreatic (borderline-resectable), gastric (FLOT), bladder (cisplatin-based) **Adjuvant therapy** — risk-based: - Chemotherapy: stage III colon (oxaliplatin-based 3-6 mo), pancreatic (modified FOLFIRINOX PRODIGE 24), gastric, breast - RT: post-mastectomy (T3, N+, positive margin); post-BCS (always); rectal selected; H&N; lung selected - Endocrine: HR+ breast (5-10 yr); prostate (LHRH agonist) - Targeted: trastuzumab HER2+; sotorasib KRAS G12C; etc - Immunotherapy: nivolumab for melanoma (stage III), bladder, lung adjuvant **Sentinel lymph node biopsy** — selected cancers (melanoma, breast, others) — accurate staging without morbidity of full dissection; positive → completion lymphadenectomy historically, now often omitted with adjuvant systemic therapy (e.g., MSLT-II melanoma — completion dissection no survival benefit). **Precision medicine**: molecular profiling — NGS panels, single-gene assays, liquid biopsy — guides therapy selection, identifies actionable mutations, predicts immunotherapy response (MSI-H, TMB), enables clinical trial enrollment.', NULL,
  'medium', 'hemato_onco', 'review',
  'surgery', 'basic_science', 'hemato_onco', 'adult',
  'AJCC Cancer Staging Manual 8th Edition; NCCN Clinical Practice Guidelines in Oncology; ASCO; Halsted W et al. (Classical Surgical Oncology Principles)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'Basic science: surgical oncology principles

คำถาม: principles of surgical oncology + cancer staging + multidisciplinary care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Basic science: postoperative pain management

ผู้ป่วยอายุ 60 ปี post-open colectomy POD 1 — ความเจ็บปวด VAS 7/10 มีการให้ morphine PCA + acetaminophen scheduled but pain inadequate

คำถาม: multimodal analgesia + ERAS pain management', '[{"label":"A","text":"Increase opioid only"},{"label":"B","text":"Multimodal analgesia (ERAS principle) — opioid-sparing approach"},{"label":"C","text":"Stop all medications"},{"label":"D","text":"IM injections only"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Multimodal analgesia (ERAS principle) — opioid-sparing approach**: (1) **Multimodal regimen components**: - **Acetaminophen** scheduled (1 g q6h, max 4 g/day) — non-opioid baseline; covers somatic pain - **NSAIDs** (ketorolac IV, celecoxib oral, ibuprofen) — anti-inflammatory; balance bleeding + anastomotic concerns + renal — many ERAS protocols include despite traditional concerns (recent evidence supports safety in selected) - **Gabapentinoids** (gabapentin, pregabalin) — neuropathic component, opioid-sparing; sedation + dizziness side effects - **Local + regional anesthesia**: - **Local infiltration** at incision (bupivacaine, liposomal bupivacaine) - **TAP (Transversus Abdominis Plane) block** — abdominal surgery; under US guidance - **Quadratus lumborum block, rectus sheath block** — alternatives - **Epidural** — gold standard for major thoracic/upper abdominal; controversial for lower abdominal (less benefit, more risk in laparoscopic); thoracic epidural reduces pulmonary complications + ileus - **Spinal opioid** alternative - **Erector spinae plane block** — newer, simpler; (2) **Opioid** — short course + minimize: - Morphine, hydromorphone, oxycodone — for breakthrough - PCA for severe acute - Avoid in pre-existing dependence / OSA / opioid-induced respiratory depression risk - Constipation prophylaxis (laxative) + nausea management; (3) **Other adjuncts**: - Ketamine low-dose infusion (sub-anesthetic 0.1-0.3 mg/kg/h) — opioid-sparing, NMDA antagonist; chronic pain - Lidocaine IV infusion — opioid-sparing, anti-inflammatory; abdominal surgery - α2-agonists (dexmedetomidine, clonidine) — sedation-analgesia balance - Tramadol — partial agonist + SNRI; mixed opioid + non-opioid mechanism; (4) **Non-pharmacologic**: positioning, splinting, ice, mobilization, music, meditation, TENS; (5) **ERAS for colorectal** specifically: thoracic epidural (open) or TAP/QL block (lap), acetaminophen + NSAID + gabapentinoid baseline, opioid for breakthrough; (6) **Chronic pain prevention**: aggressive acute pain management reduces chronic post-surgical pain; multimodal early; (7) **Opioid stewardship**: discharge with limited supply, education on disposal, screening for misuse risk; (8) **Special populations**: pre-existing opioid use, addiction recovery, OSA, elderly, pediatric — modify approach

---

**Multimodal analgesia** — cornerstone of modern surgical pain management + ERAS protocols. Goal: effective pain control with minimal opioid (opioid-sparing) → reduce side effects (constipation, ileus, sedation, respiratory depression, nausea, opioid-induced hyperalgesia, dependence/addiction). **Pillars** (combine for additive/synergistic effect): 1. **Acetaminophen** — scheduled IV or PO; baseline 2. **NSAID** — celecoxib, ibuprofen, ketorolac (short-course due to renal/bleeding); concerns about anastomotic healing largely refuted by recent meta-analyses (acceptable in elective colorectal surgery) 3. **Gabapentinoid** (gabapentin, pregabalin) — perioperative; sedation + dizziness; controversial benefit per recent RCTs but used in some ERAS protocols 4. **Regional anesthesia** — local + neuraxial: - Wound infiltration (bupivacaine, liposomal bupivacaine — Exparel) - TAP block — abdominal - Erector spinae block - Quadratus lumborum, rectus sheath - Epidural (thoracic for upper abdominal/thoracic surgery) - Spinal - Peripheral nerve blocks (interscalene shoulder, femoral knee, etc.) 5. **Opioid** — for breakthrough, short-term, low-dose; not first-line scheduled 6. **Adjuncts**: ketamine, lidocaine IV, dexmedetomidine, magnesium **ERAS pain management** — protocol-driven, predictable, multimodal: - Pre-op: acetaminophen, gabapentinoid, NSAID; counseling - Intra-op: regional anesthesia, low-dose opioid sparing, dexmedetomidine, ketamine - Post-op: scheduled multimodal + breakthrough only opioid + early mobility **Opioid stewardship** — opioid epidemic concerns: - Minimize duration + dose - Limit discharge supply (typically 7 days or less) - Education on safe storage + disposal - Screening for misuse risk - Naloxone co-prescription for at-risk - Multimodal + non-pharm alternatives **Pre-existing opioid use** — challenging: continue baseline + add adjuncts; multidisciplinary including pain medicine + addiction; avoid abrupt withdrawal. **Special populations**: elderly (lower doses, fall risk), OSA (avoid respiratory depression — multimodal), pediatric (weight-based, dexmedetomidine common, IV NSAID + acetaminophen + regional). **Chronic post-surgical pain prevention** — aggressive acute pain management + regional anesthesia reduces development.', NULL,
  'easy', 'procedures', 'review',
  'surgery', 'basic_science', 'procedures', 'adult',
  'ERAS Society Pain Management; ASA Multimodal Analgesia Guidelines; PROSPECT (Procedure-Specific Postoperative Pain Management); Joshi GP et al. Br J Anaesth', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'Basic science: postoperative pain management

ผู้ป่วยอายุ 60 ปี post-open colectomy POD 1 — ความเจ็บปวด VAS 7/10 มีการให้ morphine PCA + acetaminophen scheduled but pain inadequate

คำถาม: multimodal analgesia + ERAS pain management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Basic science: thyroid + parathyroid pathology

คำถาม: thyroid nodule workup principles', '[{"label":"A","text":"All thyroid nodules need surgery"},{"label":"B","text":"Thyroid nodule workup — algorithm"},{"label":"C","text":"No workup ever needed"},{"label":"D","text":"Total thyroidectomy for all nodules"},{"label":"E","text":"Observation only without imaging"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Thyroid nodule workup — algorithm**: (1) **Initial assessment**: - History + exam (rapid growth, hoarseness, prior neck radiation, family history thyroid Ca / MEN2 / FAP / Cowden) - TSH (suppressed → functional ''hot'' nodule — likely benign; normal/elevated → workup further) - Calcitonin if family history MEN2 / suspicious for medullary thyroid cancer - Neck US with TI-RADS scoring; (2) **TI-RADS (ACR Thyroid Imaging Reporting and Data System)** — risk stratification: - **TR1 (benign)**: 0 points — no FNA - **TR2 (not suspicious)**: 2 points — no FNA - **TR3 (mildly suspicious)**: 3 points — FNA if ≥ 2.5 cm; follow if 1.5-2.5 cm - **TR4 (moderately suspicious)**: 4-6 points — FNA if ≥ 1.5 cm; follow if 1.0-1.5 cm - **TR5 (highly suspicious)**: ≥ 7 points — FNA if ≥ 1.0 cm Features scored: composition (cystic/solid/spongiform), echogenicity (hyper/iso/hypo/very hypo), shape (taller-than-wide), margin (irregular/lobulated), echogenic foci (microcalcifications/macrocalcifications/peripheral); (3) **FNA + Bethesda cytology classification**: - I: nondiagnostic — repeat FNA - II: benign — clinical follow-up - III: AUS/FLUS (atypia/follicular lesion of undetermined significance) — molecular testing or repeat FNA - IV: follicular neoplasm — surgery (lobectomy) or molecular testing - V: suspicious for malignancy — surgery - VI: malignant — surgery (per cancer type — PTC, FTC, MTC, anaplastic, lymphoma); (4) **Molecular testing** (Afirma GSC, ThyroSeq v3, ThyGenX/ThyraMIR) — for indeterminate Bethesda III-IV: rule out malignancy → avoid unnecessary surgery; (5) **Treatment by histology**: - Papillary (PTC) 80% — lobectomy if ≤ 4 cm, intrathyroidal, no nodes vs total thyroidectomy if larger/nodes/ETE/etc; RAI selectively; LT4 - Follicular (FTC) — lobectomy for diagnosis (capsular invasion = malignant); total thyroidectomy if confirmed; hematogenous mets → RAI - Medullary (MTC) — total thyroidectomy + central neck dissection ± lateral; calcitonin marker; consider RET testing (MEN2); no RAI - Anaplastic — rapidly fatal; multimodal (BRAF V600E targeted if positive — dabrafenib + trametinib breakthrough); palliative often - Lymphoma — chemotherapy primary (CHOP-R); (6) **Active surveillance** — micropapillary (≤ 1 cm) PTC without aggressive features in selected patients (Miyauchi protocol Japan; spreading globally); (7) **Substernal goiter / compressive** — surgery for symptoms or rapid growth

---

**Thyroid nodule** — common (60% of adults have nodule on imaging), majority benign (~95%). Cancer risk ~5-10% of nodules. **Algorithm**: 1. **History + exam** — risk factors: prior head/neck RT, family history thyroid Ca, MEN2 (RET), Cowden (PTEN), FAP, age extremes, male, rapid growth, hoarseness, lymphadenopathy 2. **TSH** — suppressed → ''hot'' (functional) — RAI uptake scan to confirm; rarely malignant; treat hyperthyroidism (RAI ablation, surgery, antithyroid drug) - Normal/elevated → cold/warm — workup with US 3. **Neck US with TI-RADS scoring** (or ATA risk stratification) — assigns FNA indication 4. **FNA biopsy** if indicated by TI-RADS + size threshold 5. **Bethesda cytology classification** (I-VI) — guides next step 6. **Molecular testing** (Afirma, ThyroSeq, ThyGenX) for indeterminate Bethesda III-IV — reduces unnecessary surgery 7. **Definitive treatment** by histology + risk **Thyroid cancers**: 1. **Papillary (PTC) 80%** — most common, lymphatic spread, excellent prognosis; lobectomy or total thyroidectomy based on size + risk; RAI selectively; LT4 suppression 2. **Follicular (FTC) 10%** — hematogenous mets (bone, lung); diagnosis by capsular/vascular invasion (FNA cannot distinguish benign vs malignant follicular); lobectomy first then complete if confirmed 3. **Medullary (MTC) 3-5%** — parafollicular C cells; calcitonin + CEA markers; total thyroidectomy + central neck dissection; familial in MEN2 (RET) — test RET; screen family 4. **Anaplastic 1-2%** — undifferentiated, rapidly fatal weeks-months; multimodal — BRAF V600E targeted (dabrafenib + trametinib) for positive cases now standard of care; palliative often 5. **Lymphoma** (rare) — usually arises in Hashimoto thyroiditis background; chemotherapy primary; rarely surgery **Active surveillance for low-risk micropapillary cancer (≤ 1 cm)** — selected centers Japan + globally; Miyauchi data — most stable or slow growth; surgery deferred to progression or patient preference; growing acceptance.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'surgery', 'basic_science', 'endocrine_metabolic', 'adult',
  'ATA Thyroid Nodule + Cancer Guidelines 2015; ACR TI-RADS White Paper 2017; Bethesda System for Reporting Thyroid Cytopathology 2017', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'Basic science: thyroid + parathyroid pathology

คำถาม: thyroid nodule workup principles'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ระบบ EMS: international + low-resource emergencies

คำถาม: emergency surgery in low-resource setting + global health surgery', '[{"label":"A","text":"Same standards as developed world"},{"label":"B","text":"Global surgery + emergency surgical care in low-resource settings"},{"label":"C","text":"Surgery unnecessary in poor countries"},{"label":"D","text":"Single approach for all settings"},{"label":"E","text":"Refuse to operate without resources"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Global surgery + emergency surgical care in low-resource settings**: (1) **Lancet Commission on Global Surgery 2015** — established surgery as essential health system component: - 5 billion people lack access to safe surgical care - 143 million additional surgical procedures needed annually - Surgical care included in UHC (Universal Health Coverage) - Indicators: timely access, surgical workforce density, surgical volume, perioperative mortality rate, financial protection; (2) **Bellwether procedures** (proxy for essential surgical capacity): - Cesarean delivery - Laparotomy for emergency abdominal surgery - Open fracture management Hospital capable of performing these provides core surgical care; (3) **Three delays model** (Thaddeus + Maine — obstetric care, applied broadly): - Delay in deciding to seek care (community, awareness, financial) - Delay in reaching facility (transport, distance, infrastructure) - Delay in receiving care at facility (resources, personnel, supplies); (4) **WHO Surgical Safety Checklist** — applicable globally; reduces mortality across resource settings (Haynes NEJM 2009); (5) **Task-shifting + task-sharing**: non-physician clinicians (e.g., associate clinicians in Mozambique, Ethiopia, others) trained in surgical procedures (cesarean, hernia repair, others) — extends reach where surgeons scarce; (6) **Essential resources**: - WHO Emergency Care + Trauma Toolkit - Surgical safety - WHO Model List of Essential Medicines + Devices - Blood + transfusion services - Anesthesia (essential drugs + monitoring); (7) **Common emergent surgical conditions in LMIC**: - Obstetric (PPH, obstructed labor → C-section, ectopic) - Trauma (RTA — road traffic injuries are leading global cause of disability + death in young adults) - Acute abdomen (appendicitis, perforation, obstruction, hernia incarceration) - Sepsis - Cancer (presents late) - Burns (especially children) - Tropical surgery (typhoid perforation, amoebic abscess, hydatid, schistosomiasis); (8) **Capacity building**: - Education + training (residency programs, fellowships, short courses) - Mentorship + telemedicine - Research capacity - Bidirectional partnerships (vs traditional unidirectional aid) - Sustainable infrastructure; (9) **Disaster response**: - Foreign medical teams (FMT) per WHO Emergency Medical Teams standards - Coordination with local health authority - Build local capacity rather than parallel system - Long-term commitment; (10) **Ethics**: avoid medical tourism harm, training on locals, sustainability, local leadership, cultural sensitivity, language

---

**Global Surgery** — emerging field recognizing surgery as essential component of universal health coverage. **Lancet Commission on Global Surgery 2015** (Meara et al, Lancet) — landmark document: - 5 billion people lack access to safe, affordable surgical and anesthesia care - 143 million additional surgical procedures needed annually - Surgical care historically neglected — ''neglected stepchild of global health'' - 33% global disease burden requires surgery (largely traumatic) **Indicators** (DCP3 — Disease Control Priorities, WHO): - Timely access to bellwether procedures (cesarean, laparotomy, open fracture) within 2h - Surgical, anesthetic, obstetric (SAO) workforce density ≥ 20/100,000 - Surgical volume ≥ 5,000 procedures/100,000/year - Perioperative mortality rate (PMR) - Risk of impoverishment from surgery - Risk of catastrophic expenditure **Three delays model** (Thaddeus + Maine 1994): 1. Decision to seek care (cultural, financial, awareness) 2. Reaching facility (transport, distance) 3. Receiving care (facility resources, personnel) Applies to obstetric emergencies + broader emergency surgical care. **Task-shifting**: non-physician clinicians performing essential surgical procedures (e.g., medical officers, surgical assistant medical officers in Tanzania, Ethiopia, Mozambique) — extends reach where formal surgeons scarce; equivalent or near-equivalent outcomes for selected procedures with proper training + supervision (cesarean, hernia, hydrocele, others). **Bellwether procedures** — hospital capable of these can handle most emergency surgical needs: 1. Cesarean delivery 2. Laparotomy (emergency abdominal surgery) 3. Open fracture management **WHO essential lists** + standards: - WHO Surgical Safety Checklist - WHO Emergency Care + Trauma Toolkit - WHO Model List of Essential Medicines - WHO Emergency Medical Teams (EMT) standards for disaster response **Common emergent surgical conditions in LMIC**: trauma (road traffic injuries leading cause of disability + death in young adults globally), obstetric (PPH, obstructed labor, ectopic), acute abdomen, burns (especially children), tropical (typhoid perforation, amoebic abscess), late-presenting cancer. **Sustainable partnerships**: bidirectional, local capacity building, ethics, language, cultural sensitivity, long-term commitment vs short-term surgical mission tourism.', NULL,
  'easy', 'trauma', 'review',
  'surgery', 'ems_mgmt', 'trauma', 'adult',
  'Lancet Commission on Global Surgery 2015 (Meara JG et al.); WHO Emergency Care + Trauma; DCP3 — Disease Control Priorities', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ระบบ EMS: international + low-resource emergencies

คำถาม: emergency surgery in low-resource setting + global health surgery'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 60 ปี smoker, HT มา ED ด้วยอาการ severe abdominal pain + back pain + acute leg ischemia bilateral ขาเย็น + numbness 2 ชั่วโมง

VS: BP 180/110 right arm; 110/70 left arm; HR 110; both legs cold + pulseless

CXR: widened mediastinum
CT angiography aorta: type B aortic dissection with extension to abdominal aorta + bilateral common iliac occlusion + malperfusion of bilateral legs', '[{"label":"A","text":"Beta-blocker alone outpatient"},{"label":"B","text":"Complicated Type B aortic dissection with malperfusion — emergent intervention"},{"label":"C","text":"Anticoagulation alone"},{"label":"D","text":"Observation only"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Complicated Type B aortic dissection with malperfusion — emergent intervention**: (1) **Initial medical**: ICU + IV impulse control (beta-blocker first — esmolol or labetalol — to ↓ dP/dt + shear; then vasodilator if BP still high — nitroprusside) — target HR < 60-80, SBP 100-120; pain control; (2) **Type B dissection classification (Stanford / DeBakey)**: - Stanford A: ascending aorta involved — SURGERY emergent - Stanford B: descending only (distal to L subclavian) - DeBakey I (ascending + descending), II (ascending only), III (descending only); (3) **Complicated Type B = malperfusion / rupture / refractory pain / refractory HTN / rapid expansion / aneurysm** — **TEVAR (Thoracic Endovascular Aortic Repair) emergent**: - Cover proximal entry tear → re-pressurize true lumen → relieve malperfusion - Lower mortality vs open in modern era (INSTEAD-XL trial; IRAD data) - May require LSCA coverage (revascularize selectively); (4) **Adjunct fenestration / branch interventions**: - Visceral / renal / iliac branch stenting if persistent malperfusion - Open surgical fenestration alternative; (5) **Uncomplicated Type B** — initially medical: impulse control + BP control + follow-up; preemptive TEVAR considered in selected (INSTEAD trial — late benefit on aortic remodeling); (6) **Surveillance**: lifelong CT q6 mo first year then annual; complications: aneurysmal dilation, retrograde extension, secondary entry tear; (7) **Risk factor optimization**: BP control absolute (target < 120/80), statin, smoking cessation, exercise modified

---

**Aortic dissection** — life-threatening: intimal tear → blood enters media → false lumen propagates. Mortality untreated: 1-2% per HOUR initially for Type A. **Stanford classification**: - **Type A**: involves ascending aorta — surgical emergency (open repair — composite valve graft, hemi-arch, etc.) - **Type B**: descending only (distal to L subclavian) — initially medical unless complicated **DeBakey**: - I: entire aorta (ascending + arch + descending) - II: ascending only - III: descending only **Classification by acuity** (now): - Hyperacute (< 24h), acute (1-14 days), subacute (15-90 days), chronic (> 90 days) **Type B complications** (''complicated Type B''): - Malperfusion (visceral, renal, limb) — surgical indication - Rupture / impending - Refractory pain - Refractory hypertension - Rapid aortic expansion - Aneurysmal dilation >5.5 cm **Medical management** all dissections (anti-impulse): - β-blocker first (esmolol, labetalol) — reduces dP/dt + shear stress - Vasodilator second (nitroprusside, nicardipine) - Target: HR < 60-80, SBP 100-120 - Pain control (opioid) **TEVAR for Type B**: - Complicated Type B — emergency (INSTEAD-XL, IRAD data show benefit) - Uncomplicated Type B — selected preemptive intervention - Cover proximal entry tear; depressurize false lumen → true lumen re-expands → malperfusion resolves - Risks: paraplegia, stroke, retrograde Type A, endoleak **Surveillance** — lifelong (CT q6 mo first yr, annual). Risk: late aneurysm formation 25-40%. **Long-term medical**: BP control (target < 120/80 — ACEi/ARB/CCB + beta-blocker), statin, smoking cessation, avoid heavy lifting/isometric exercise, genetic counseling (Marfan, Loeys-Dietz, vEDS, Turner, FTAAD) if young / family history.', NULL,
  'hard', 'vascular', 'review',
  'surgery', 'clinical_decision', 'vascular', 'adult',
  'ESC Aortic Diseases Guidelines 2014; ACC/AHA Aortic Disease 2022; Nienaber CA et al. JACC (INSTEAD-XL)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 60 ปี smoker, HT มา ED ด้วยอาการ severe abdominal pain + back pain + acute leg ischemia bilateral ขาเย็น + numbness 2 ชั่วโมง

VS: BP 180/110 right arm; 110/70 left arm; HR 110; both legs cold + pulseless

CXR: widened mediastinum
CT angiography aorta: type B aortic dissection with extension to abdominal aorta + bilateral common iliac occlusion + malperfusion of bilateral legs'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 75 ปี on warfarin for AF + fell at home — มีบริเวณ groin large pulsatile mass + bruit + thrill 2 days; recent femoral artery cath 5 days ago

VS stable
US Doppler: pseudoaneurysm right common femoral artery 3 cm + bidirectional flow pattern + neck 4 mm
Anti-coagulated INR 2.8

คำถาม: management', '[{"label":"A","text":"Observation 6 weeks"},{"label":"B","text":"Post-catheterization femoral pseudoaneurysm + anticoagulated — management options"},{"label":"C","text":"Reverse anticoagulation immediately + observation"},{"label":"D","text":"Total leg amputation"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Post-catheterization femoral pseudoaneurysm + anticoagulated — management options**: (1) **Risk factors**: anticoagulation, large catheters, low/high arterial puncture, obesity, female, calcified vessels, multiple punctures; (2) **Treatment options based on size + symptoms + anticoagulation**: a. **Small (< 2 cm) asymptomatic uncomplicated**: observation + serial US — many thrombose spontaneously b. **Ultrasound-guided thrombin injection** — first-line for most: ~5% of normal thrombin units (e.g., 500-1000 units) injected into sac under US guidance; success rate 90-95%; quick; complications: distal embolization, recurrence, infection — contraindicated if narrow neck < 3 mm + wide sac (risk of arterial thrombosis), infected pseudoaneurysm, mycotic - This patient: 3 cm + 4 mm neck + anticoagulated — ideal candidate c. **Ultrasound-guided manual compression** — older method; 30-60 min × multiple sessions; success 60-80%; lower in anticoagulated; painful d. **Surgical repair** — for: large > 3-4 cm with poor anatomy, failed US-guided thrombin/compression, expanding, infected, hemodynamically unstable, distal ischemia; primary repair, patch, bypass; (3) **Anticoagulation considerations**: - Hold warfarin temporarily during procedure if possible (balance AF risk) - Bridge with LMWH if high-risk - Resume after pseudoaneurysm thrombosed; (4) **Post-procedure**: serial US to confirm thrombosis, monitor for re-expansion, arterial flow distal; (5) **Prevention**: meticulous technique, US-guided puncture, proper sheath size, adequate post-procedure compression, closure device use, careful in anticoagulated patients; (6) **Differentials**: hematoma (without bidirectional flow), AV fistula (continuous bruit, audible thrill); both managed differently

---

**Femoral artery pseudoaneurysm** — common complication of arterial access (cardiac cath, vascular procedures). Incidence 0.5-9%; risk factors as listed. **Pseudoaneurysm vs hematoma vs AV fistula**: - **Pseudoaneurysm**: pulsatile, expanding mass with bidirectional flow on Doppler (''yin-yang'' sign) + neck connecting to artery - **Hematoma**: non-pulsatile, no flow on Doppler - **AV fistula**: continuous bruit + thrill, color Doppler shows arterial flow into vein **Diagnosis**: US Doppler — gold standard. **Treatment hierarchy**: 1. **Small (< 2 cm) uncomplicated**: observation + serial US (many thrombose spontaneously) 2. **Ultrasound-guided thrombin injection** — first-line for most: - Small dose (500-1000 units thrombin) into sac under US guidance - 90-95% success - Contraindications: narrow neck < 3 mm with wide sac (thrombosis risk into artery), infected, mycotic - Complications: distal embolization (rare), recurrence, anaphylaxis 3. **US-guided compression** — older, declining use; success 60-80%; less effective in anticoagulated; time-consuming + painful 4. **Surgical repair** — for failed minimally invasive, large > 3-4 cm with poor anatomy for injection, expanding rapidly, infected (mycotic), distal ischemia, severe symptoms; primary repair, patch angioplasty, bypass as needed 5. **Covered stent** — alternative for select large or complex **Anticoagulation management** — balance underlying indication vs intervention bleeding risk; hold temporarily if possible; resume after pseudoaneurysm thrombosed. **Prevention**: meticulous technique — single anterior wall puncture, micropuncture, US-guided access, proper sheath size, adequate compression post-removal, closure devices, careful in anticoagulated.', NULL,
  'medium', 'vascular', 'review',
  'surgery', 'clinical_decision', 'vascular', 'adult',
  'SVS Practice Guidelines; Webber GW et al. Circulation; Vlachou PA et al. Eur Radiol', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 75 ปี on warfarin for AF + fell at home — มีบริเวณ groin large pulsatile mass + bruit + thrill 2 days; recent femoral artery cath 5 days ago

VS stable
US Doppler: pseudoaneurysm right common femoral artery 3 cm + bidirectional flow pattern + neck 4 mm
Anti-coagulated INR 2.8

คำถาม: management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 28 ปี IVDU มาด้วย acute abdominal pain RUQ + ไข้สูง + diarrhea bloody 5 วัน + เพิ่งเดินทางกลับจากชนบทเหนือ

VS: BP 96/62, HR 116, Temp 39.4°C
Abdomen: tender hepatomegaly, RUQ guarding

US abdomen: hepatic lesion 8 cm right lobe with internal echoes — abscess; mild ascites
Lab: WBC 22,400, AST 220, ALT 168, ALP 320; Entamoeba histolytica serology positive; stool ova + parasites trophozoites observed

คำถาม: management', '[{"label":"A","text":"Surgical drainage immediately"},{"label":"B","text":"Amebic liver abscess — primarily medical"},{"label":"C","text":"Antibiotic without addressing intestinal carriage"},{"label":"D","text":"Observation only"},{"label":"E","text":"Hepatectomy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Amebic liver abscess — primarily medical**: (1) **Metronidazole** 750 mg PO/IV TID × 7-10 days (first-line — amebicidal in tissue) — OR tinidazole 2 g/day × 3-5 days; (2) **Luminal agent** AFTER tissue therapy — paromomycin OR iodoquinol OR diloxanide furoate × 7-10 days — eradicates intestinal cysts (prevents re-infection + clears asymptomatic carriers); (3) **Drainage indications** (only ~ 15% of amebic abscesses need drainage): - Large (> 5 cm, especially > 10 cm) - Left lobe (proximity to pericardium — rupture catastrophic) - Failure to respond to antibiotic 5-7 days - Imminent rupture (very large, peripheral, thin wall) - Pyogenic component cannot be excluded (mixed abscess) - Diagnostic uncertainty; (4) **Drainage method**: percutaneous catheter drainage (US/CT-guided) > surgical; aspiration if small; (5) **Distinguish from pyogenic abscess**: - Amebic: travel/endemic area, single, right lobe predominant, serology + (90-95%), stool trophozoites/cysts, ''anchovy paste'' aspirate, less septic appearance, younger - Pyogenic: older, biliary source, multiple often, sicker, polymicrobial cultures, leukocytosis higher; (6) **IVDU considerations**: HIV/HCV/HBV screening; endocarditis surveillance (right-sided IE); addiction medicine; (7) **Public health**: report; trace contacts in family/household; treat asymptomatic carriers; (8) **Follow-up**: clinical + LFT + US weekly until resolution (may take 6 months for radiologic resolution); (9) **Complications**: rupture into peritoneum/pleura/pericardium (emergency drainage), pleural effusion (sympathetic vs amebic empyema), bacterial superinfection

---

**Liver abscess** — two main types: amebic vs pyogenic. **Amebic liver abscess** (E. histolytica): - Endemic regions: Mexico, South America, Asia, Africa - Fecal-oral transmission — invasive trophozoite reaches liver via portal vein - Typically single, right lobe (60-70%), younger males - Subacute onset over weeks — fever, RUQ pain, hepatomegaly - Lab: leukocytosis, mild LFT abnormalities, eosinophilia uncommon - Diagnosis: serology (95-99% sensitive for invasive disease), stool exam (trophozoites/cysts), imaging - Treatment: metronidazole + luminal agent **Pyogenic liver abscess**: - Common in West, older - Biliary source most common (cholangitis), portal pyemia (appendicitis, diverticulitis), hematogenous, direct - Polymicrobial often (gram-neg + anaerobes); Klebsiella pneumoniae monomicrobial in Asia (associated with cryptogenic, DM, metastatic infection — endogenous endophthalmitis, brain abscess) - Treatment: IV broad-spectrum antibiotic (ceftriaxone + metronidazole or piperacillin-tazobactam) + drainage (almost always required) **Imaging — both look similar on US/CT**; serology + epidemiology + clinical distinguishes. **Treatment of amebic abscess**: 1. **Metronidazole** (or tinidazole) — first-line; usually clinical response in 3-5 days 2. **Luminal agent** — paromomycin (preferred), iodoquinol, diloxanide furoate — after tissue therapy to eradicate cysts (otherwise risk of recurrence + spread) 3. **Drainage** — only 10-15% need it: - Large > 10 cm (controversial > 5-7 cm) - Left lobe (pericardial rupture risk) - Failure of medical 5-7 d - Imminent rupture - Diagnostic uncertainty - Pyogenic superinfection 4. **Percutaneous** preferred over surgical Aspirate appearance: ''anchovy paste'' (necrotic hepatocytes) — classic for amebic; bacterial culture negative; trophozoites at wall (rarely in pus). **Complications**: rupture (pericardial = catastrophic; pleural = empyema/sympathetic effusion; peritoneal); secondary bacterial infection.', NULL,
  'medium', 'id', 'review',
  'surgery', 'clinical_decision', 'id', 'adult',
  'WHO Treatment of Amebiasis; IDSA Liver Abscess; Salles JM et al. Braz J Infect Dis', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 28 ปี IVDU มาด้วย acute abdominal pain RUQ + ไข้สูง + diarrhea bloody 5 วัน + เพิ่งเดินทางกลับจากชนบทเหนือ

VS: BP 96/62, HR 116, Temp 39.4°C
Abdomen: tender hepatomegaly, RUQ guarding

US abdomen: hepatic lesion 8 cm right lobe with internal echoes — abscess; mild ascites
Lab: WBC 22,400, AST 220, ALT 168, ALP 320; Entamoeba histolytica serology positive; stool ova + parasites trophozoites observed

คำถาม: management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 45 ปี post-cholecystectomy 3 ชั่วโมง พบอาเจียน bilious + abdominal distention + ไม่สามารถ tolerate clear liquids + abdomen tender + decreased bowel sounds + ขาขวา leg pain

VS: BP 116/72, HR 108, Temp 37.4°C
Abdomen: distended, mild tender; not peritonitis
Lab: WBC 11,000, electrolytes normal, lactate 1.8
CT abdomen: dilated stomach + duodenal C-loop dilated + retroperitoneal hematoma at uncinate process + no free air

คำถาม: differential + management', '[{"label":"A","text":"Observation + IV fluid"},{"label":"B","text":"Postoperative ileus + suspected duodenal injury / retroperitoneal hematoma"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Steroid IV"},{"label":"E","text":"Antibiotic without imaging"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Postoperative ileus + suspected duodenal injury / retroperitoneal hematoma**: (1) **Differential**: - Postop ileus (common, self-limited 24-72h) - Mechanical SBO (rare immediate postop) - Anastomotic leak (if any) - **Duodenal injury** — rare laparoscopic chole complication (uncinate process trauma during retraction or cautery); high mortality if missed - Hemorrhage / hematoma; (2) **Initial steps**: - NPO + NG decompression - IV fluid + electrolyte correction - Hold opioids if possible (worsens ileus); use multimodal analgesia - Monitor: vitals, output (NG, drain, urine), labs (Hb, lactate, electrolytes, lipase if suspect pancreatic injury) - Repeat exam serially + imaging if concern; (3) **Duodenal injury suspicion**: oral contrast study (Gastrografin) or CT with oral + IV contrast to evaluate for leak; biliary tree, retroperitoneal anatomy; (4) **Management of duodenal injury**: - Small contained leak — drainage + NPO + TPN + IV antibiotic; some heal - Large / uncontained leak — surgical exploration + primary repair (if early, healthy edges) OR pyloric exclusion + gastrojejunostomy OR diverting / damage control depending on severity + location; biliary access; - Retroperitoneal hematoma — observe if not expanding; surgical exploration if expanding, infected, mass effect; (5) **Differential of bilious vomiting post-chole**: - Postop ileus most common — usually resolves - Acalculous cholecystitis (rare post-chole — no GB) - Retained CBD stone — cholangitis, jaundice - Biliary leak / biloma — RUQ pain, fever - Surgical complication (injury, hematoma) - Adhesions / mechanical obstruction; (6) **Watch for**: development of sepsis, peritonitis, hemodynamic instability — escalate; multidisciplinary; (7) **Documentation + M&M** if complication confirmed

---

**Post-cholecystectomy complications** — early recognition critical. **Common immediate post-op complications**: - Ileus (transient — manage supportive) - Bile leak (cystic duct stump, accessory ducts, CBD injury) - Hemorrhage (cystic artery slip, liver bed, port site) - Retained CBD stones (5-15%) - Bowel injury (rare — Veress needle, trocar, energy) - **Duodenal injury** (rare — uncinate process trauma during retraction or cautery; CBD exploration) - Wound infection - DVT/PE **Postoperative ileus**: - Physiologic delay in GI motility post-surgery - Resolves within 24-72h typically - Risk factors: opioids, prolonged surgery, fluid overload, electrolyte abnormalities - Management: supportive (NPO, NG if needed, IV fluid, electrolyte, hold opioids, mobilize) - Mechanism: inflammation, sympathetic, opioid; multimodal analgesia + ERAS reduce **Differential bilious vomiting post-cholecystectomy**: - Ileus (most common) - Mechanical obstruction (adhesions, retained instrument) - Bile leak / biloma - Bowel injury - SMA syndrome (rare) - Retained CBD stone + cholangitis - Acute pancreatitis (post-ERCP related, rare without ERCP) **Workup**: vital trend, exam, labs (CBC, LFT, lipase, electrolytes, lactate), imaging (US first; CT with oral + IV contrast if concern). **Bile duct injury** — Strasberg classification — important to recognize early (see prior question on this topic). **Bowel injury** — delayed presentation often (3-5 days post-op) — fever, peritonitis, sepsis; manage emergent exploration. **Hemorrhage** — drop in Hb, tachycardia → emergent imaging or exploration. **Prevention**: meticulous technique, identify critical structures (Calot''s triangle, critical view of safety), avoid blind cautery, gentle retraction.', NULL,
  'medium', 'gi', 'review',
  'surgery', 'clinical_decision', 'gi', 'adult',
  'SAGES Safe Cholecystectomy Program 2018; Strasberg SM et al. J Am Coll Surg; ACS Surgery Principles + Practice', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 45 ปี post-cholecystectomy 3 ชั่วโมง พบอาเจียน bilious + abdominal distention + ไม่สามารถ tolerate clear liquids + abdomen tender + decreased bowel sounds + ขาขวา leg pain

VS: BP 116/72, HR 108, Temp 37.4°C
Abdomen: distended, mild tender; not peritonitis
Lab: WBC 11,000, electrolytes normal, lactate 1.8
CT abdomen: dilated stomach + duodenal C-loop dilated + retroperitoneal hematoma at uncinate process + no free air

คำถาม: differential + management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 65 ปี HT, DM, CKD stage 3 มา ED ด้วย acute abdominal pain + hematuria + ปวดข้างขวา + ไข้

VS: BP 142/86, HR 102, Temp 38.4°C
Abdomen: right flank tender, no peritonitis, no costovertebral angle tenderness on left

Lab: WBC 18,400, Cr 2.4 (baseline 1.6), lactate 2.2; urine: WBC 50, RBC 100, leukocyte esterase positive, nitrite positive, urine culture pending
US / CT urography: 8 mm obstructing stone at right ureteropelvic junction + hydronephrosis severe + perinephric fat stranding

คำถาม: emergent management', '[{"label":"A","text":"Outpatient antibiotic + medical expulsive therapy"},{"label":"B","text":"Obstructed infected upper urinary tract (obstructive uropathy with UTI / pyelonephritis) — urgent decompression"},{"label":"C","text":"Observation 24 hr"},{"label":"D","text":"Surgical stone removal immediately"},{"label":"E","text":"Antibiotic alone, no decompression"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Obstructed infected upper urinary tract (obstructive uropathy with UTI / pyelonephritis) — urgent decompression**: (1) **Surgical / urologic emergency** — obstructed + infected urinary system has high risk of sepsis + bacteremia + multi-organ dysfunction; (2) **Initial resuscitation**: IV fluid, broad-spectrum IV antibiotic (ceftriaxone OR pip-tazo OR cefepime; cover gram-negative; consider ESBL/Pseudomonas risk factors); blood cultures; urine culture (already taken); (3) **Urgent decompression** of obstructed system — within hours: - **Percutaneous nephrostomy (PCN)** — placed by IR; preferred when patient unstable, large hydronephrosis, sepsis (decompresses upper tract immediately) - **Ureteral stent (DJ stent)** retrograde via cystoscopy — alternative; may be difficult if severe obstruction or anatomy unfavorable - In sepsis: PCN often preferred (cleaner, more reliable decompression); (4) **Definitive stone management — DELAYED** until infection resolved + stable: - 7-14 days post-decompression - Options: ureteroscopy + laser lithotripsy (URS + Holmium laser), extracorporeal shock wave lithotripsy (ESWL), percutaneous nephrolithotomy (PCNL — large stones); - 8 mm UPJ stone — likely needs surgical removal (low likelihood of spontaneous passage); (5) **Stone analysis** + metabolic workup post-stone passage; (6) **Underlying conditions**: HT, DM control, CKD progression slow with stone disease; (7) **Prevention** lifelong: hydration > 2.5 L/day, dietary (depends on stone composition — Ca oxalate most common; reduce sodium + animal protein + oxalate; not reduce calcium); thiazide for hypercalciuria; allopurinol for uric acid; potassium citrate; (8) **Monitoring**: imaging q1-2 yr for recurrence; 50% recur within 5-10 yr without prevention

---

**Obstructed infected urinary tract** — urologic emergency; high risk of sepsis + multi-organ dysfunction + permanent renal damage if delayed. **Management principles**: 1. **Antibiotic + resuscitation** immediately 2. **Urgent decompression** within hours (PCN or ureteral stent) 3. **Definitive stone treatment DELAYED** until infection resolved (7-14 days) — operating on infected obstructed system → bacteremia, sepsis, death **Decompression options**: - **Percutaneous nephrostomy (PCN)**: IR-placed external drain through skin into renal pelvis; rapid, effective, doesn''t require crossing obstruction; preferred in unstable patient, sepsis, severe hydronephrosis - **Ureteral stent (DJ stent)**: retrograde via cystoscopy + ureteroscopy; less invasive; may fail in severe obstruction or anatomic issues; risk of pushing infection further with manipulation **Why decompress?**: obstructed pyelonephritis bacterial proliferation + endotoxin release accelerated; without decompression, antibiotic alone inadequate; sepsis + emphysematous pyelonephritis (gas-forming infection — often DM) + renal damage. **Stone management options** (elective, after infection cleared): - **Ureteroscopy + Holmium laser lithotripsy (URS)** — small stones (< 2 cm); good for distal/mid ureter, growing for kidney; outpatient often - **Extracorporeal shock wave lithotripsy (ESWL)** — non-invasive; stones < 2 cm; success depends on location + composition (uric acid + calcium oxalate respond; cystine, brushite resistant); contraindications: pregnancy, anticoagulation, aneurysm - **Percutaneous nephrolithotomy (PCNL)** — large stones > 2 cm, staghorn, complex anatomy; through small flank incision - **Open / laparoscopic** — rare now; complex anatomy, failed minimally invasive **Stone composition** (analysis when passed): - Calcium oxalate (~70%) — most common - Calcium phosphate (~15%) - Uric acid (~10%) — radiolucent, treat with alkalinization (K citrate) - Struvite (~5%) — infection stone (urea-splitting Proteus, Klebsiella) - Cystine (~1%) — genetic **Metabolic workup**: 24h urine x 2 (Ca, oxalate, citrate, uric acid, Na, Mg, volume), serum (Ca, PTH, uric acid), stone analysis. **Lifestyle prevention**: hydration > 2.5 L/day, moderate Na + animal protein, normal calcium intake (not low — increases stone risk), reduce oxalate-rich foods if hyperoxaluria.', NULL,
  'medium', 'renal_gu', 'review',
  'surgery', 'clinical_decision', 'renal_gu', 'adult',
  'AUA Surgical Management of Stones 2016; EAU Urolithiasis Guidelines; ACR Appropriateness Criteria Urinary Stone', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 65 ปี HT, DM, CKD stage 3 มา ED ด้วย acute abdominal pain + hematuria + ปวดข้างขวา + ไข้

VS: BP 142/86, HR 102, Temp 38.4°C
Abdomen: right flank tender, no peritonitis, no costovertebral angle tenderness on left

Lab: WBC 18,400, Cr 2.4 (baseline 1.6), lactate 2.2; urine: WBC 50, RBC 100, leukocyte esterase positive, nitrite positive, urine culture pending
US / CT urography: 8 mm obstructing stone at right ureteropelvic junction + hydronephrosis severe + perinephric fat stranding

คำถาม: emergent management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 32 ปี G3P2 มา ED ด้วยอาการ ปวดท้องน้อย + เลือดออกทางช่องคลอด 5 สัปดาห์ post-cesarean section

VS: BP 102/64, HR 118, Temp 37.2°C
Lochia foul smelling, abundant
Abdomen: tender lower abdomen, no peritonitis

Lab: WBC 17,200, CRP 178, Hb 9.2
US pelvis: enlarged uterus with retained products of conception 4 cm + fluid collection 6 cm in cul-de-sac suspicious abscess
No signs of bowel injury

คำถาม: management', '[{"label":"A","text":"Outpatient antibiotic"},{"label":"B","text":"Post-cesarean endometritis + pelvic abscess + retained products — multimodal"},{"label":"C","text":"Observation only"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Total abdominal hysterectomy immediately"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Post-cesarean endometritis + pelvic abscess + retained products — multimodal**: (1) **Resuscitation + IV broad-spectrum antibiotic** — cover gram-positive + gram-negative + anaerobes: typical regimens: - Clindamycin + gentamicin (classical) - Ampicillin-sulbactam OR piperacillin-tazobactam OR cefoxitin + metronidazole - Add ampicillin if Enterococcus suspected (post-cesarean often) - Cover Group B strep, anaerobes, E. coli; (2) **Source control**: - **Retained products** → uterine evacuation (D&C or suction curettage) — under US guidance to avoid uterine perforation - **Pelvic abscess** → percutaneous drainage (IR-guided) preferred over surgery for accessible collections; transvaginal, transabdominal, transgluteal approaches; surgery if multiloculated/inaccessible/failed/peritonitis/sepsis - **Septic pelvic thrombophlebitis** consideration if persistent fever despite antibiotic + drainage → CT/MRI for pelvic vein thrombosis → anticoagulation; (3) **Surgical hysterectomy** — last resort for refractory: necrotic infected uterus, failed source control, hemorrhagic, severe sepsis; counseling re: fertility; (4) **Supportive care**: ICU if septic, blood products as needed, VTE prophylaxis (pregnancy postpartum + sepsis = high VTE risk; consider therapeutic if septic pelvic thrombophlebitis suspected); (5) **Follow-up**: clinical response, repeat US/CT to confirm resolution, complete antibiotic course (typically IV until afebrile 48-72h then transition oral, total 10-14 days), pelvic exam; (6) **Lactation considerations**: most antibiotics compatible; metronidazole controversial briefly; check Lactmed; (7) **Counseling for future pregnancies**: increased risk of recurrence + adhesion + Asherman syndrome (from D&C); follow-up consideration of hysteroscopy

---

**Post-cesarean endometritis + abscess** — common postpartum infection. Risk factors: cesarean (10-50× more than vaginal delivery), prolonged ROM, prolonged labor, multiple vaginal exams, manual placental extraction, retained products, low SES, BV/STI. **Pathogens**: polymicrobial — Group B strep, E. coli, Enterococcus, anaerobes (Bacteroides, Prevotella), Mycoplasma. **Clinical**: fever > 24h postpartum + foul lochia + uterine tenderness + leukocytosis. **Diagnosis**: clinical; US for retained products or abscess; CT for unclear pelvic process. **Treatment**: 1. IV broad-spectrum antibiotic — clindamycin + gentamicin (classic, low cost) OR ampicillin-sulbactam OR pip-tazo; cover anaerobes critical 2. Source control: - Retained products: D&C (suction curettage under US) - Abscess: percutaneous drainage (IR) preferred over surgical exploration when feasible 3. Continue IV until afebrile + clinically improved 48-72h, then transition oral 4. Total duration typically 10-14 days **Septic pelvic thrombophlebitis (SPT)**: complication of pelvic infection — thrombus in ovarian or pelvic veins seeded with bacteria; persistent fever despite antibiotic + drainage; CT/MRI venogram diagnostic; treatment: continue antibiotic + anticoagulation (LMWH or UFH then warfarin 4-6 weeks); typically resolves with treatment. **Asherman syndrome**: intrauterine adhesions from infection + curettage → infertility / menstrual abnormalities → hysteroscopic adhesiolysis. **Hysterectomy** — last resort if refractory or hemorrhagic; fertility counseling. **Prevention**: pre-op antibiotic at cesarean (cefazolin before incision, not delayed); meticulous technique.', NULL,
  'medium', 'obgyn', 'review',
  'surgery', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin 199 — Use of Prophylactic Antibiotics; Faro S et al. Antimicrob Agents Chemother; Watts DH et al. Obstet Gynecol', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 32 ปี G3P2 มา ED ด้วยอาการ ปวดท้องน้อย + เลือดออกทางช่องคลอด 5 สัปดาห์ post-cesarean section

VS: BP 102/64, HR 118, Temp 37.2°C
Lochia foul smelling, abundant
Abdomen: tender lower abdomen, no peritonitis

Lab: WBC 17,200, CRP 178, Hb 9.2
US pelvis: enlarged uterus with retained products of conception 4 cm + fluid collection 6 cm in cul-de-sac suspicious abscess
No signs of bowel injury

คำถาม: management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารก male อายุ 4 สัปดาห์ มาด้วยอาการ aspiration during feed + recurrent pneumonia + cough during feed + cyanosis sometimes

Exam: distress, normal weight
CXR: bilateral lower lobe atelectasis + suggestive aspiration
Esophagography: H-type tracheoesophageal fistula confirmed', '[{"label":"A","text":"Observation"},{"label":"B","text":"H-type TEF (Gross type E, ~ 5% of TEF) — surgical repair"},{"label":"C","text":"Observation only"},{"label":"D","text":"Endoscopic stent"},{"label":"E","text":"Total esophagectomy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **H-type TEF (Gross type E, ~ 5% of TEF) — surgical repair**: (1) **Distinct presentation** — H-type has esophageal continuity but abnormal connection to trachea; presents later with: aspiration, coughing/choking with feeds, recurrent pneumonia, cyanosis; (2) **Diagnosis**: - Esophagram (modified — pull-back with prone position + injection while imaging) - Rigid or flexible bronchoscopy + esophagoscopy — visualize fistula directly + may catheterize; (3) **Surgical approach**: - **Right cervical incision** — most H-type are in cervical/upper thoracic; - Identify fistula (often with bronchoscopy assistance — methylene blue or balloon catheter) - Divide + close both ends (esophagus + trachea) - Interposition of muscle (sternohyoid) between to prevent recurrence; (4) **Postoperative**: - Voice / RLN function monitoring (recurrent laryngeal nerve at risk) - Feeding gradual restart - Imaging confirmation of no leak - Esophagram before discharge; (5) **Complications**: - Recurrent fistula (5-10%) - Anastomotic leak (less since not anastomosis) - RLN injury — hoarseness, voice changes - Tracheomalacia / stenosis; (6) **VACTERL workup** — same as other TEF (echo, spine, kidney, anorectal, limb); (7) **Long-term**: feeding, growth, respiratory follow-up; symptoms recurrent fistula (cough with feeds, recurrent pneumonia) → re-evaluate

---

**H-type TEF (Gross E)** — esophageal continuity + tracheoesophageal fistula without esophageal atresia. Rare (~ 5% of TEF). **Distinct from other types** of EA/TEF — esophagus is patent, but abnormal communication with trachea. **Presentation** later (weeks to months) than EA-TEF (which presents at birth): - Coughing / choking with feeds - Cyanosis / aspiration episodes - Recurrent pneumonia - Failure to thrive - Abdominal distention (air enters via fistula) **Diagnosis often delayed** — high index of suspicion in infant with recurrent pneumonia + feeding issues. **Diagnostic approach**: 1. **Esophagram** with modified technique: - Standard supine may miss - Prone position with NG tube pull-back + contrast injection - Multiple views 2. **Rigid bronchoscopy** — gold standard; direct visualization; may catheterize fistula for surgical identification 3. **Flexible bronchoscopy + esophagoscopy** combined approach **Surgical approach**: - **Cervical incision** (right neck) — most fistulas at C7-T2 level - **Right thoracotomy** if fistula thoracic - **Thoracoscopic** alternative experienced centers - Identify fistula (bronchoscopy assistance + balloon catheter / methylene blue) - Divide + close both esophageal + tracheal sides - Interposition tissue (muscle flap) between - Vocal cord monitoring (RLN at risk in cervical) **Postop**: feed cautiously, imaging confirm no leak, monitor voice. **Complications**: recurrent fistula (5-10%), RLN injury (hoarseness), tracheomalacia, anastomotic issues uncommon. **VACTERL screening** same as other EA/TEF — echocardiogram + spine + kidney + anorectal + limb exam. **Long-term**: monitor for growth, recurrent fistula symptoms (cough, choking with feeds, recurrent pneumonia), reflux.', NULL,
  'hard', 'pediatrics', 'review',
  'surgery', 'clinical_decision', 'pediatrics', 'peds',
  'APSA Pediatric Surgery Handbook; Spitz L. Br J Surg; Holland AJ et al. Semin Pediatr Surg', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ทารก male อายุ 4 สัปดาห์ มาด้วยอาการ aspiration during feed + recurrent pneumonia + cough during feed + cyanosis sometimes

Exam: distress, normal weight
CXR: bilateral lower lobe atelectasis + suggestive aspiration
Esophagography: H-type tracheoesophageal fistula confirmed'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 8 ปี เด็กชาย มา ED ปวดท้อง periumbilical 8 ชั่วโมง + อาเจียน + ไข้ + แม่กังวลภาวะเรื้อรัง — ภาวะที่ผ่านมา anorexia ไม่ผ่ายลง 2 วัน

VS: BP 102/68, HR 124, Temp 38.4°C
Abdomen: RLQ tender + guarding + Rovsing''s positive + heel tap positive

Lab: WBC 16,000, CRP 88
US abdomen: non-compressible appendix 8 mm + periappendiceal fluid

คำถาม: management', '[{"label":"A","text":"Antibiotic alone, no surgery"},{"label":"B","text":"Pediatric acute appendicitis — laparoscopic appendectomy preferred"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Outpatient follow-up next week"},{"label":"E","text":"MRI alone, no treatment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Pediatric acute appendicitis — laparoscopic appendectomy preferred**: (1) **Diagnosis**: Pediatric Appendicitis Score (PAS, similar to Alvarado): nausea/vomiting, anorexia, migration of pain, RLQ tenderness, cough/hop/percussion tenderness, fever > 38, WBC > 10k, neutrophilia — high PAS + US findings = appendicitis; (2) **Imaging strategy** (avoid radiation in pediatric): - **US first-line** — sensitivity 80-90%, specificity 90-95% in pediatric (operator-dependent); look for non-compressible blind-ended tubular structure ≥ 6 mm with surrounding fluid, fecalith, hyperemia - **MRI** — if US equivocal — no radiation - **CT** — last resort due to radiation; reserved if MRI unavailable + US inadequate; (3) **Treatment**: - **Laparoscopic appendectomy** — gold standard; faster recovery, less pain, lower SSI vs open; - **Open appendectomy** — alternative in unstable, severely complicated, or surgeon preference; - **Pre-op antibiotic prophylaxis** — single pre-op dose (cefoxitin OR ampicillin-sulbactam OR cefazolin + metronidazole) - **Non-operative management (NOM) with antibiotics alone** — emerging option in pediatric uncomplicated; recent RCTs (APPY trial, others) show ~ 60-70% success at 1 yr; not first-line widely but acceptable for selected; (4) **Complicated appendicitis** (perforation, abscess, gangrene): - Phlegmon/small abscess: IV antibiotic + interval appendectomy 6-8 wk (controversial — increasing trend toward early appendectomy even complicated) - Large abscess: percutaneous drainage + IV antibiotic + interval appendectomy; (5) **Postop**: most discharge same/next day uncomplicated; complicated longer + antibiotic continuation; (6) **Outcomes** excellent — mortality < 0.1% in modern era for uncomplicated

---

**Pediatric appendicitis** — most common pediatric surgical emergency. Peak age 10-12. **Diagnostic challenges in pediatric**: - Atypical presentation - Difficulty examining young children - Higher perforation rate (20-35% by presentation; > 50% in < 5 yr) due to delayed presentation - Communication challenges **Pediatric Appendicitis Score (PAS)** — Samuel 2002: - Nausea/vomiting: 1 - Anorexia: 1 - Migration pain: 1 - RLQ tender: 2 - Cough/hop/percussion tender: 2 - Fever ≥ 38: 1 - WBC > 10k: 1 - Neutrophilia: 1 Total 10; ≥ 7 high probability **Imaging strategy** (radiation avoidance): 1. US first-line — pediatric trained sonographer; sensitivity 80-90% 2. MRI if US equivocal — no radiation, sensitive + specific 3. CT — reserved if needed; modern low-dose protocols for pediatric **Treatment**: 1. **Laparoscopic appendectomy** — preferred (lower SSI, faster recovery) 2. **Open** — alternative 3. **NOM with antibiotic alone** — emerging option in pediatric (APPY-1, EAGER, others); ~ 60-80% short-term success; ~ 60-70% durable at 1 yr; selected uncomplicated only; growing acceptance in selected centers; informed family discussion **Complicated (perforation, abscess)**: - Phlegmon (no defined abscess): IV antibiotic - Small abscess (< 3 cm): IV antibiotic - Large abscess (> 3-4 cm): percutaneous drainage + IV antibiotic - Generalized peritonitis: emergent laparotomy / laparoscopy + washout + appendectomy **Timing**: emergent within hours for perforation/sepsis; semi-urgent < 24h for uncomplicated (some delay acceptable for organization + pre-op preparation per evidence). **Interval appendectomy** post-medical-management of complicated — historical practice; trend now toward observation only (recurrence ~ 15% over 1-2 yr) vs interval appendectomy; case-by-case. **Outcomes**: mortality < 0.1% modern era uncomplicated; perforated 0.5-1%. Complications: SSI (3-10%, higher in perforated), abscess, ileus, stump appendicitis.', NULL,
  'easy', 'pediatrics', 'review',
  'surgery', 'clinical_decision', 'pediatrics', 'peds',
  'APSA Pediatric Appendicitis Guidelines; Samuel M Pediatr Surg Int; Minneci PC et al. JAMA (NOM Pediatric); WSES Acute Appendicitis 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ผู้ป่วยอายุ 8 ปี เด็กชาย มา ED ปวดท้อง periumbilical 8 ชั่วโมง + อาเจียน + ไข้ + แม่กังวลภาวะเรื้อรัง — ภาวะที่ผ่านมา anorexia ไม่ผ่ายลง 2 วัน

VS: BP 102/68, HR 124, Temp 38.4°C
Abdomen: RLQ tender + guarding + Rovsing''s positive + heel tap positive

Lab: WBC 16,000, CRP 88
US abdomen: non-compressible appendix 8 mm + periappendiceal fluid

คำถาม: management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 14 ปี มาด้วย acute scrotal pain LEFT ขึ้นมาทันที 4 ชั่วโมง + คลื่นไส้อาเจียน + ไม่มีอาการก่อนหน้านี้

Exam: left testis swollen + tender + high-riding + horizontal lie + absent cremasteric reflex; right testis normal
US Doppler scrotum: absent blood flow left testis; right testis normal; small reactive hydrocele', '[{"label":"A","text":"Observation + analgesics"},{"label":"B","text":"Testicular torsion — emergent scrotal exploration + detorsion + bilateral orchiopexy"},{"label":"C","text":"Antibiotic only"},{"label":"D","text":"Outpatient referral"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Testicular torsion — emergent scrotal exploration + detorsion + bilateral orchiopexy**: (1) **Time-critical** — testicular viability decreases with each hour: < 6h ~ 90-100% salvage; 6-12h ~ 50%; > 24h ~ rarely salvageable; (2) **Clinical diagnosis** + Doppler US confirms (absent flow); do NOT delay surgery for imaging if clinical features clear; (3) **Manual detorsion** (bedside, while preparing OR) — temporizing only — rotate testicle outward + upward (''opening a book'' — most torsion is medial rotation, so detorse lateral); ''whirlpool'' sign assists; if successful → still proceed with definitive bilateral orchiopexy; (4) **OR — scrotal exploration**: - Transverse scrotal incision affected side - Deliver testis, evaluate viability after detorsion + warming with saline-soaked gauze - **Viable** (regains color, bleeds with incision): orchiopexy with 3-point fixation using non-absorbable suture - **Non-viable**: orchiectomy + counseling; - **Bilateral fixation** — always — contralateral testicle at similar risk (bell-clapper deformity often bilateral); (5) **Differential**: - Torsion of testicular appendix (Hydatid of Morgagni) — milder, ''blue dot'' sign, lower abdomen pain, normal flow; conservative - Epididymo-orchitis — gradual onset, urinary symptoms, fever, age dependent (post-puberty STI vs pre-puberty UTI); antibiotic + supportive - Incarcerated hernia - Trauma - Henoch-Schönlein purpura scrotal involvement - Idiopathic scrotal edema; (6) **Counseling** + follow-up: future fertility, reproduce; (7) **Education** — patient + parents on signs + need for emergent care if recurrent

---

**Testicular torsion** — urologic emergency; time-sensitive for testicular salvage. **Peak ages**: bimodal — perinatal (extravaginal) + adolescent (intravaginal, bell-clapper deformity — testis not properly fixed in tunica vaginalis). **Salvage rates by time**: - < 6h: 90-100% - 6-12h: ~50% - 12-24h: ~ 20-50% - > 24h: rarely salvageable Decision to operate should not be delayed for imaging if clinical features clear. **Clinical features**: - Acute scrotal pain (often awakens at night) - Nausea/vomiting - Swelling, tenderness - High-riding testis - Horizontal lie - Absent cremasteric reflex (highly sensitive — Pacik review) - Negative Prehn sign (relief with elevation is positive in epididymitis) **TWIST score** (Testicular Workup for Ischemia + Suspected Torsion): hard mass, swelling, absent cremasteric, nausea/vomiting, high-riding testis — predicts torsion. **Imaging**: - **Color Doppler US** scrotum — absent / reduced flow in torsion; reactive flow in epididymo-orchitis; high sensitivity in expert hands; consider operator + equipment - **Scintigraphy** — historical; rarely used now **Manual detorsion** (bedside while preparing OR — temporizing): - Most torsions are medial rotation → detorse outward (laterally) — ''opening a book'' to outside - Success: pain relief, descent of testis - Confirm with US Doppler if available - Even if successful → STILL needs definitive surgical orchiopexy **Surgical management**: - Transverse scrotal incision - Deliver testis, detorse, warm + evaluate viability - **Viable** (color returns, bleeds): orchiopexy with 3-point fixation, non-absorbable suture (or Dartos pouch fixation) - **Non-viable**: orchiectomy + counseling - **Bilateral fixation** ALWAYS — contralateral side has same anatomic risk **Counseling**: future fertility — single-testis fertility usually preserved; risk of contralateral torsion eliminated by bilateral fixation. **Differential — distinguish**: epididymo-orchitis (gradual, urinary symptoms, flow normal/increased, antibiotic responsive), torsion of testicular appendix (milder, blue dot sign, conservative).', NULL,
  'easy', 'renal_gu', 'review',
  'surgery', 'clinical_decision', 'renal_gu', 'peds',
  'AUA Pediatric Urology Guidelines; Sharp VJ et al. Am Fam Physician; Mansbach JM et al. Pediatrics', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'เด็กชายอายุ 14 ปี มาด้วย acute scrotal pain LEFT ขึ้นมาทันที 4 ชั่วโมง + คลื่นไส้อาเจียน + ไม่มีอาการก่อนหน้านี้

Exam: left testis swollen + tender + high-riding + horizontal lie + absent cremasteric reflex; right testis normal
US Doppler scrotum: absent blood flow left testis; right testis normal; small reactive hydrocele'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 65 ปี post-cardiac surgery (CABG + AVR) day 7 มาด้วย sternal wound dehiscence + drainage purulent + fever

VS: BP 116/72, HR 102, RR 18, Temp 38.4°C
Sternum: dehiscence partial + drainage + erythema + crepitus on palpation
CBC: WBC 18,400, CRP 240
Blood culture: gram-positive cocci growing
CT chest: mediastinal fluid + air + sternal nonunion', '[{"label":"A","text":"Outpatient antibiotic only"},{"label":"B","text":"Deep sternal wound infection (DSWI) / mediastinitis — surgical emergency"},{"label":"C","text":"Observation"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Single-stage closure without debridement"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Deep sternal wound infection (DSWI) / mediastinitis — surgical emergency**: (1) **High mortality** (10-25% with mediastinitis); urgent intervention required; (2) **Immediate**: - IV broad-spectrum antibiotic — coverage MRSA + gram-negative + anaerobes initially → vancomycin + ceftriaxone or cefepime; tailored per cultures; - Blood cultures + tissue cultures - Imaging confirmed CT - Multidisciplinary: CT surgery, ID, plastic surgery; (3) **Surgical management — staged approach**: - **Debridement** of necrotic + infected sternum + tissue + cartilage if involved; remove infected wires/hardware if possible - **Open wound management** initially with frequent dressing changes OR - **Vacuum-assisted closure (VAC therapy / NPWT)** — improves wound granulation + drainage; common modern approach (Sjogren et al evidence — reduces mortality vs conventional) - Continue IV antibiotic — long course (4-6 weeks for mediastinitis with bone involvement); (4) **Definitive reconstruction** after infection controlled (clinically + culture-negative): - **Pectoralis major muscle flap** — most common; bilateral if defect large - **Rectus abdominis flap** — alternative; risks if internal mammary artery used (CABG often) - **Omental flap** — selected, especially recurrent or large defects - Sternal hardware (cables, plates) for rigid fixation if needed; (5) **MRSA decolonization** considered (mupirocin + chlorhexidine); (6) **Glycemic control** strict — DM major risk factor; (7) **Risk factors for DSWI** (modifiable + non): DM (especially uncontrolled), obesity, COPD, smoking, prolonged surgery, bilateral IMA harvest, low cardiac output, transfusion, immunosuppression, hemodialysis; (8) **Prevention**: glycemic control, single IMA in DM/obese, skin prep, antibiotic prophylaxis (vanco + cefazolin in MRSA-prevalent), surgical technique, postop care, NPWT prophylactic in high-risk emerging

---

**Deep Sternal Wound Infection (DSWI) / Mediastinitis** — feared complication of cardiac surgery; incidence 1-5%; mortality 10-25% (lower with modern management). **Classification (CDC)**: - **Superficial sternal**: skin + subcutaneous only - **Deep sternal**: bone involved (mediastinitis if extends to mediastinal organs) **Risk factors**: 1. **Patient**: DM (especially uncontrolled HbA1c), obesity, smoking, COPD, malnutrition, immunosuppression, hemodialysis, age, female 2. **Surgical**: bilateral internal mammary artery (IMA) harvest (reduces sternal blood supply — single IMA preferred in DM/obese), prolonged operation, re-exploration for bleeding, intraoperative transfusion, low cardiac output 3. **Postop**: prolonged ventilation, ICU stay, glycemic control **Microbiology**: Staphylococcus aureus (including MRSA, MSSA) 70-80%; Coagulase-negative Staph; gram-negative; polymicrobial 15-20%. **Diagnosis**: clinical (wound drainage, dehiscence, instability, fever) + imaging (CT chest — gas, fluid, sternal disruption) + cultures (blood + tissue/wound). **Management**: 1. **Immediate IV antibiotic** — empiric vancomycin + cefepime/ceftriaxone → de-escalate per culture; long duration 4-6 weeks for bony involvement 2. **Surgical debridement** — devitalized bone + cartilage + infected hardware (some wires may need removal) 3. **Wound management options**: a. **Open wound** with frequent dressing change — traditional b. **Vacuum-assisted closure (NPWT — Wound VAC)** — modern preferred; faster granulation, less morbidity, lower mortality (Sjogren et al, others); apply over open chest after debridement; change q2-3 days c. **Closed irrigation** — older method 4. **Definitive reconstruction** when infection controlled: - Pectoralis major muscle flap — workhorse; unilateral or bilateral - Rectus abdominis flap — alternative; consider IMA use (CABG) - Omental flap — selected complex - Sternal rigid fixation (plates) if needed **Prevention**: strict glycemic control perioperative (140-180), antibiotic prophylaxis (vancomycin + cefazolin if MRSA prevalent), single IMA in high-risk, skin prep (chlorhexidine-alcohol), MRSA decolonization, surgical technique, postop care, prophylactic NPWT in high-risk patients emerging (Pi-NPWT trial mixed but promising).', NULL,
  'hard', 'id', 'review',
  'surgery', 'clinical_decision', 'id', 'adult',
  'STS Guidelines Sternal Wound Infection; Sjogren J et al. Ann Thorac Surg (NPWT); Robicsek F. J Thorac Cardiovasc Surg', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 65 ปี post-cardiac surgery (CABG + AVR) day 7 มาด้วย sternal wound dehiscence + drainage purulent + fever

VS: BP 116/72, HR 102, RR 18, Temp 38.4°C
Sternum: dehiscence partial + drainage + erythema + crepitus on palpation
CBC: WBC 18,400, CRP 240
Blood culture: gram-positive cocci growing
CT chest: mediastinal fluid + air + sternal nonunion'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 35 ปี มาด้วย neck mass ขนาด 4 cm lateral cervical ระยะ III LATERAL บริเวณ jugulodigastric area; ไม่เจ็บ ไม่เคลื่อนไหวเวลากลืน

คำถาม: differential + workup', '[{"label":"A","text":"Observation alone"},{"label":"B","text":"Lateral neck mass in adult — systematic workup"},{"label":"C","text":"Antibiotic empirically only"},{"label":"D","text":"Open biopsy first"},{"label":"E","text":"No workup needed"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Lateral neck mass in adult — systematic workup**: (1) **Differential by age + location**: - **Adult**: malignancy until proven otherwise (especially > 40, smoker, drinker, lateral, hard, fixed) - **Pediatric**: usually benign (reactive node, branchial cleft cyst, dermoid); (2) **Differential categories** for lateral neck mass: a. **Lymphadenopathy**: - Reactive (infection nearby) - Lymphoma (Hodgkin, NHL) - Metastatic from primary (thyroid, oropharynx, larynx, salivary, esophagus, distant — lung, breast, GI, skin); cervical metastases especially from H&N + thyroid b. **Congenital**: branchial cleft cyst (2nd most common — lateral to SCM, congenital), thyroglossal duct (midline), dermoid c. **Inflammatory**: TB (scrofula), cat scratch disease, atypical mycobacteria, HIV-associated lymphadenopathy, viral d. **Salivary gland**: parotid (in front of ear), submandibular — mass, may be benign (pleomorphic adenoma) or malignant (mucoepidermoid, ACC, others) e. **Vascular**: carotid body tumor (paraganglioma — pulsatile, mobile side-to-side not up-down), vascular malformation f. **Neurogenic**: schwannoma, neurofibroma g. **Thyroid lateral (rare)**: ectopic thyroid; (3) **Workup approach**: - **History**: duration, growth rate, B symptoms, alcohol, smoking, dental hygiene, travel, animal exposure, HIV, family history - **Physical**: full H&N exam — oral cavity, oropharynx, larynx (flexible scope), nasopharynx (endoscope), thyroid, skin, lymph nodes - **Imaging**: US neck first-line (cystic vs solid, vascular, characterize); CT/MRI for deeper structures + staging if cancer suspected; PET-CT for unknown primary - **FNA biopsy** of mass — first-line for tissue diagnosis (avoid open biopsy of suspected metastatic neck node — disrupts planes for definitive surgery); core biopsy if FNA inadequate; - **Lab**: CBC + diff, infectious workup if suspected (HIV, EBV, CMV, TB skin test/IGRA, Bartonella, toxoplasma), thyroid function; (4) **If FNA = metastatic squamous cell carcinoma** — work up primary: panendoscopy (laryngoscopy, esophagoscopy, bronchoscopy), CT/PET, tonsillectomy (often occult tonsil primary), HPV/EBV testing (HPV+ oropharyngeal — different prognosis + management); (5) **If FNA = malignant thyroid**: thyroid US + management as thyroid Ca; (6) **If FNA = lymphoma**: excisional biopsy for definitive diagnosis + classification (FNA inadequate for lymphoma typing); (7) **Multidisciplinary** if cancer: H&N surgery, medical onc, radiation onc, pathology, radiology

---

**Neck mass workup** — common clinical scenario; differential depends on age + location + clinical features. **General principle (adult)**: lateral neck mass in adult > 40 = malignancy until proven otherwise (epidemiologic rule). **Anatomic location guides differential**: - **Anterior midline**: thyroid, thyroglossal duct cyst, dermoid - **Anterior triangle (lateral but anterior to SCM)**: lymph node, branchial cleft, salivary - **Posterior triangle**: lymph node, schwannoma, lipoma - **Submental**: salivary, lymph node - **Submandibular**: salivary gland mass, lymph node **Differential by age**: - **Pediatric**: usually benign (~ 80%) — reactive lymphadenopathy, branchial cleft cyst, dermoid, thyroglossal, lymphangioma, infection - **Adult > 40**: malignancy more likely (~ 80% with chronic mass) — metastatic to cervical nodes most common, lymphoma, primary head/neck **Workup steps**: 1. **History + exam** — risk factors, full ENT exam, flexible nasopharyngoscopy 2. **US** — initial imaging; cystic vs solid, vascular characteristics 3. **FNA biopsy** — first-line for tissue; avoid open biopsy of suspected metastatic cervical node (disrupts surgical planes, lymphatic anatomy, can violate tumor planes) 4. **CT/MRI** — for deeper assessment, staging if cancer, anatomy 5. **PET-CT** — unknown primary, staging 6. **Panendoscopy + EUA** if metastatic SCC + unknown primary 7. **Excisional biopsy** if lymphoma suspected (FNA inadequate for typing) 8. **Definitive surgical resection** based on diagnosis **Head + neck cancer metastatic to cervical node** common — primaries: oral cavity, oropharynx (HPV+ — base of tongue, tonsil; HPV-), larynx, hypopharynx, nasopharynx, thyroid, salivary, skin. HPV-related oropharyngeal Ca — distinct prognosis (better) + management considerations (de-escalation trials). **Carotid body tumor (paraganglioma)** — pulsatile lateral mass; mobile side-to-side, not up-down (vs lymph node mobile both directions); ''splays'' internal + external carotid on imaging — DON''T biopsy (vascular — can bleed); diagnosis on imaging (CTA, MRA); managed surgically (or observation, radiation in selected) by vascular + H&N surgery; genetic syndrome workup (SDH mutations — hereditary paraganglioma).', NULL,
  'medium', 'hemato_onco', 'review',
  'surgery', 'clinical_decision', 'hemato_onco', 'adult',
  'ASCO H&N Cancer Guidelines; NCCN H&N Cancer; AAO-HNS Neck Mass Adult Guideline 2017', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 35 ปี มาด้วย neck mass ขนาด 4 cm lateral cervical ระยะ III LATERAL บริเวณ jugulodigastric area; ไม่เจ็บ ไม่เคลื่อนไหวเวลากลืน

คำถาม: differential + workup'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 70 ปี SUDDEN abdominal pain + nausea + vomiting + bowel distention 24 hr; previous appendectomy + cesarean + 2 abdominal hernia repairs

VS: BP 142/86, HR 102, Temp 37.4°C
Abdomen: distended, mild tender, no peritonitis, prior surgical scars
Lab: WBC 14,200, lactate 2.4, BUN 28, Cr 1.4
CT abdomen: small bowel obstruction with transition point in mid-abdomen + closed-loop configuration + bowel wall thickening + free fluid + decreased enhancement

คำถาม: management', '[{"label":"A","text":"Conservative NG decompression + serial exam"},{"label":"B","text":"Closed-loop small bowel obstruction with concerning ischemia signs — emergent exploration"},{"label":"C","text":"Outpatient laxatives"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Observation 48 hr"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Closed-loop small bowel obstruction with concerning ischemia signs — emergent exploration**: (1) **Closed-loop obstruction** — both ends occluded; can rapidly progress to ischemia + perforation; surgical emergency; (2) **Imaging signs of bowel ischemia** (red flags): - Decreased bowel wall enhancement - Bowel wall thickening (> 3 mm) - Pneumatosis intestinalis - Portal venous gas - Free fluid (especially with closed loop) - Mesenteric stranding / edema - ''Whirl'' sign of mesentery; (3) **Closed-loop on CT**: U-shaped or C-shaped dilated loop with converging mesenteric vessels; high risk volvulus / strangulation; (4) **Resuscitation + emergent operative exploration**: - IV fluid + electrolyte correction (NG decompression in adjunct, not replace surgery) - IV broad-spectrum antibiotic - Type & crossmatch - Emergent OR — laparoscopic or open exploration; (5) **Operative findings + decisions**: - Identify obstruction + cause - Reduce volvulus / release adhesions - Assess bowel viability — color, perfusion, peristalsis, Doppler; warm compress + observation - Non-viable bowel → resection + primary anastomosis or stoma per stability/contamination - Address etiology (hernia repair, adhesiolysis, mass) - Avoid extensive enterolysis if not needed (recurrence) - Damage control if hemodynamically unstable; (6) **High-grade SBO without closed loop / ischemia signs**: NG + IV fluid trial with Gastrografin challenge; 70-80% resolve; surgery if persistent / worsening; (7) **Postop**: NG until function returns, gradual feeding, monitor for short gut if extensive resection; (8) **Prevention**: meticulous adhesion-prone surgery, adhesion barriers (e.g., hyaluronic acid SeprafilM); but adhesions still common

---

**Closed-loop small bowel obstruction (CLSBO)** — both ends of bowel segment occluded; high risk of strangulation, ischemia, perforation; surgical emergency. **Causes**: - Adhesive bands (most common — 60-75%) - Hernia (incarcerated with kinking) - Volvulus - Internal hernia - Intussusception **Imaging signs of CLSBO on CT**: - U or C-shaped dilated bowel loop - Converging mesenteric vessels at apex - ''Whirl'' sign of twisted mesentery - Bowel wall thickening - Decreased bowel wall enhancement (ischemia) - Free fluid - Mesenteric edema **Ischemia signs (red flags) on CT**: 1. Reduced bowel wall enhancement (most specific) 2. Wall thickening > 3 mm 3. Pneumatosis intestinalis 4. Portal venous gas 5. Free fluid in mesentery / peritoneum 6. Mesenteric stranding / edema 7. Whirl sign These signs + clinical (fever, leukocytosis, lactate, peritonitis) = surgical urgency. **Management of SBO** — risk-stratified: 1. **Uncomplicated adhesive SBO** (no closed loop, no ischemia): - NG decompression + IV fluid + electrolyte correction - Gastrografin challenge (NEJM diagnosis + therapeutic per WSES Bologna) - 70-80% resolve in 48-72h - Surgery if failed conservative or signs of complication 2. **Complicated SBO** (closed loop, ischemia, strangulation, perforation, peritonitis): - Emergent surgical exploration - Don''t wait - Resuscitate + go to OR 3. **SBO in ''virgin abdomen''** (no prior surgery): higher index of suspicion for malignancy / inflammatory cause; threshold for surgery lower **Bowel viability assessment intraoperatively**: - Color (pink vs dusky / black) - Peristalsis - Mesenteric pulse - Doppler at antimesenteric border - Warm saline compress + reassess 20 min after detorsion - ICG (indocyanine green) fluorescence — emerging; perfusion imaging - Second-look 24-48h if uncertain **Prevention of adhesions** — adhesion barriers (Seprafilm — hyaluronic acid CMC) reduce adhesion formation at experimental + clinical level; selected use. Laparoscopic surgery — less adhesion than open. Meticulous technique — minimize tissue handling, avoid foreign body, achieve hemostasis.', NULL,
  'medium', 'gi', 'review',
  'surgery', 'clinical_decision', 'gi', 'adult',
  'WSES Bologna Guidelines ASBO 2017; Maung AA et al. EAST PMG SBO; Di Saverio S et al. World J Emerg Surg', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ผู้ป่วยอายุ 70 ปี SUDDEN abdominal pain + nausea + vomiting + bowel distention 24 hr; previous appendectomy + cesarean + 2 abdominal hernia repairs

VS: BP 142/86, HR 102, Temp 37.4°C
Abdomen: distended, mild tender, no peritonitis, prior surgical scars
Lab: WBC 14,200, lactate 2.4, BUN 28, Cr 1.4
CT abdomen: small bowel obstruction with transition point in mid-abdomen + closed-loop configuration + bowel wall thickening + free fluid + decreased enhancement

คำถาม: management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 40 ปี รักษาที่บ้านโดย heating pad ที่หลังขณะตื่นเช้า พบ deep burn skin damage ที่หลังขนาดประมาณ 6%; ทำงานคนเดียวลำพัง — ที่บ้านมีคนช่วยช่วยน้อย

คำถาม: outpatient management + indications for hospitalization', '[{"label":"A","text":"Surgery immediately"},{"label":"B","text":"Burn management — assessment + disposition"},{"label":"C","text":"No treatment needed"},{"label":"D","text":"Discharge immediately without follow-up"},{"label":"E","text":"Long-term opioids"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Burn management — assessment + disposition**: (1) **Burn evaluation**: - Size: 6% TBSA total - Depth: superficial vs partial-thickness vs deep partial vs full-thickness; - This case: heating pad — typically deep partial / full thickness if prolonged contact + sleep / unable to feel; - Location: back (less critical than face/hands/feet/genitalia); (2) **Burn Center Referral Criteria (ABA)** — refer to burn center if: - Partial-thickness > 10% TBSA - Full-thickness any size (especially face, hands, feet, perineum, joints) - Chemical, electrical burns - Inhalation injury - Special needs (preexisting medical conditions, traumatic injury) - Pediatric/elderly - Inadequate social/psychological support - Indications: outpatient mgmt may be appropriate for small partial-thickness, but deep + isolation = consider admission; (3) **Outpatient management** for small partial-thickness burns: - Wound care: cleanse with mild soap + water, gentle debridement of loose skin, topical agents (silver sulfadiazine — controversial in modern; alternative silver-based dressings, bacitracin, mupirocin for small areas); - Dressings: non-adherent, change daily or per dressing type; - Pain control: oral analgesic, scheduled - Tetanus prophylaxis update - Follow-up clinic 48-72h then weekly; (4) **Surgical management** for full-thickness / deep partial: - Early excision + grafting (5-7 days) — improves outcome vs delayed; - Split-thickness skin graft from donor site (thigh) - Alternative: dermal regenerative templates (Integra) for full-thickness without immediate autograft availability; (5) **Hospitalization indicated** for: large/deep burns, poor social support (inability to do wound care, transportation), special locations, comorbidities, inhalation, infection signs, severe pain not controlled, age extremes; (6) **Nutritional + rehabilitation** — for larger / deep burns; (7) **Long-term**: scarring (hypertrophic, keloid), contracture (physical therapy, splinting), pruritus, psychological (PTSD), pigmentation; (8) **Burn types**: thermal (most common), scald, contact (this case), chemical, electrical, radiation, friction; (9) **Special considerations**: - Heating pad burns: often deep due to prolonged contact + low temp + lack of pain feedback (especially in DM neuropathy, alcoholic, drug overdose, falling asleep) - Suspect deeper than appears; (10) **Abuse / neglect** consideration if circumstances suspicious — pediatric, elderly, dependent adult — investigation + reporting

---

**Burn management** — outpatient vs hospitalization. **Burn Center Referral Criteria** (American Burn Association — ABA): 1. Partial-thickness burns > 10% TBSA (any age) 2. Burns involving face, hands, feet, genitalia, perineum, major joints 3. Full-thickness burns any size in any age 4. Electrical burns including lightning 5. Chemical burns 6. Inhalation injury 7. Burn patients with preexisting medical disorders complicating mgmt 8. Burn + concomitant trauma 9. Burn injuries in children + hospitals without qualified personnel/equipment 10. Burns requiring special social/psychological/long-term rehabilitative support **Outpatient burn care criteria**: - Small (< 10% TBSA) partial-thickness in adults - No special area involvement - Patient/caregiver capable of wound care - Adequate access to follow-up - No significant comorbidities **Outpatient wound care**: 1. Cleansing: mild soap + water, irrigation 2. Debridement: gentle, loose dead skin 3. Topical: - Silver sulfadiazine (SSD) — traditional; concerns about pseudo-eschar, delayed healing; rarely used in modern practice - Silver-based dressings (Aquacel Ag, Mepilex Ag) — less frequent changes - Bacitracin / mupirocin — small areas - Hydrogels, hydrocolloid — superficial 4. Dressings: non-adherent, foam, antimicrobial 5. Pain control 6. Tetanus prophylaxis 7. Follow-up 48-72h, then weekly **Surgical management for deep/full-thickness**: - **Early excision + grafting** (5-7 days) — improves outcomes; reduces hospital stay, complications, scarring - **Split-thickness skin graft** — donor: thigh, back; allows healing both sites - **Dermal regenerative templates** (Integra, AlloDerm) — full-thickness without donor; second-stage thin skin graft - **Cultured epithelial autograft (CEA)** — extensive burns; lab-grown - **Allograft (cadaveric)** — temporary coverage extensive burns - **Pediatric**: similar principles; pay attention to growth + scar contracture **Heating pad / contact burns** — special considerations: - Prolonged low-grade heat → deep tissue damage despite small surface area - Often patient unaware (sleeping, drugs, neuropathy, intoxication) - Higher rate of full-thickness than expected - Common in DM with peripheral neuropathy → counsel against use - Abuse consideration in vulnerable populations.', NULL,
  'easy', 'trauma', 'review',
  'surgery', 'clinical_decision', 'trauma', 'adult',
  'ABA Burn Center Referral Criteria; ISBI Practice Guidelines for Burn Care 2016; Strock LL et al. J Burn Care Res', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ผู้ป่วยอายุ 40 ปี รักษาที่บ้านโดย heating pad ที่หลังขณะตื่นเช้า พบ deep burn skin damage ที่หลังขนาดประมาณ 6%; ทำงานคนเดียวลำพัง — ที่บ้านมีคนช่วยช่วยน้อย

คำถาม: outpatient management + indications for hospitalization'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Basic science: surgical pathology + tumor markers

คำถาม: tumor markers in clinical practice', '[{"label":"A","text":"Tumor markers are diagnostic alone"},{"label":"B","text":"Tumor markers — uses + limitations"},{"label":"C","text":"All tumor markers are specific"},{"label":"D","text":"Markers replace imaging"},{"label":"E","text":"Single elevated marker confirms cancer"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Tumor markers — uses + limitations**: (1) **Roles**: - Diagnosis support (rarely sufficient alone) - Staging adjunct - Prognosis - Treatment monitoring - Surveillance for recurrence; (2) **Limitations**: most have low sensitivity (miss disease) + specificity (false positives from non-malignant conditions); not screening tools (except in selected — PSA controversially in selected men); (3) **Common surgical tumor markers**: a. **CEA (Carcinoembryonic Antigen)**: - Colorectal — most useful application; baseline + post-resection + surveillance (rising = recurrence) - Also elevated in: smoking, IBD, hepatitis, other GI cancers, breast, lung b. **CA 19-9**: - Pancreatic cancer — most useful; surveillance + response - Also: cholangiocarcinoma, gallbladder, gastric, colorectal; - Lewis-negative blood group (5-10%) → false-negative c. **CA 125**: - Ovarian — surveillance + response - Also: endometriosis, pregnancy, menstruation, peritonitis, ascites, pleural effusion, other GI/lung cancers d. **CA 15-3, CA 27.29**: - Breast cancer — metastatic monitoring (not for primary screening) e. **AFP (Alpha-fetoprotein)**: - HCC, non-seminoma germ cell tumor - Hepatocellular Ca: surveillance in cirrhosis + diagnosis support (LI-RADS) - Testicular GCT: elevation = NSGCT (even if pure seminoma histology) f. **β-hCG**: - Trophoblastic disease (gestational, choriocarcinoma) - Germ cell tumor (some) - Pregnancy normal g. **PSA (Prostate-Specific Antigen)**: - Prostate Ca screening (controversial — overdiagnosis), monitoring - Elevated also: BPH, prostatitis, instrumentation, ejaculation h. **Calcitonin**: - Medullary thyroid Ca — secretes; baseline + surveillance - Elevated in: C-cell hyperplasia, MEN2 family screening, ESRD i. **Chromogranin A**: - Neuroendocrine tumors — pheochromocytoma, carcinoid, gastrinoma, neuroendocrine pancreatic - Also elevated: PPI use, ESRD, severe HF, atrophic gastritis j. **Thyroglobulin (Tg)**: - Differentiated thyroid Ca (PTC, FTC) — post-thyroidectomy surveillance marker; high anti-Tg Ab may interfere k. **LDH**: - Germ cell tumors, lymphoma — prognostic + response l. **5-HIAA**: - Carcinoid (urine 24h) m. **Catecholamines + metanephrines**: - Pheochromocytoma — plasma free metanephrine most sensitive (~ 99%); n. **Inhibin B, AMH**: - Ovarian sex cord-stromal tumors o. **HE4 + CA 125 + ROMA**: - Ovarian Ca risk algorithm; (4) **Liquid biopsy / circulating tumor DNA (ctDNA)** — emerging: - Treatment response monitoring - Resistance mutations detection (e.g., EGFR T790M in NSCLC) - Surveillance for MRD (minimal residual disease) - Stage I/II colorectal — MRD detection + adjuvant decision; (5) **Interpretation principles**: - Use trends, not single value - Combine with imaging + clinical context - Disease-specific cutoffs + validation - Don''t overinterpret minor fluctuations - Confounders: liver disease, smoking, inflammation, ESRD, gender, age

---

**Tumor markers** — biological substances elevated in malignancy; useful for diagnosis support, staging, prognosis, treatment monitoring, surveillance. Almost never diagnostic alone — combined with imaging + biopsy + clinical context. **Major tumor markers** with primary surgical use: 1. **CEA** — colorectal (surveillance), also breast, lung, GI; baseline + post-op + q3-6 mo × 5 yr 2. **CA 19-9** — pancreatic, cholangio, gastric; Lewis-negative blood group (5-10%) → no CA 19-9 production 3. **CA 125** — ovarian; many false positives (endometriosis, menstruation, pregnancy, peritoneal inflammation) 4. **CA 15-3 / CA 27.29** — breast metastatic monitoring 5. **AFP** — HCC + non-seminoma GCT 6. **β-hCG** — trophoblastic + GCT 7. **PSA** — prostate 8. **Calcitonin** — medullary thyroid Ca 9. **Thyroglobulin** — differentiated thyroid Ca post-thyroidectomy surveillance 10. **Chromogranin A** — neuroendocrine 11. **LDH** — GCT, lymphoma 12. **5-HIAA** (urine) — carcinoid 13. **Metanephrines** — pheochromocytoma **Interpretation principles**: - Trend over time more valuable than single value - Disease-specific cutoffs + validation - Half-life informs interpretation (AFP 5-7d, hCG 24-36h) - Confounders: smoking elevates CEA, liver disease elevates many, ESRD chromogranin, gender + age **Liquid biopsy (ctDNA, CTCs)** — emerging: - Tumor genotyping non-invasively - Detection of resistance mutations (e.g., EGFR T790M, HER2 amplification) - MRD (minimal residual disease) detection post-resection — adjuvant therapy decision (e.g., DYNAMIC trial colorectal) - Surveillance — earlier recurrence detection - Limitations: shedding variable, sensitivity, cost **Caveats**: tumor markers should NOT be used for general population screening (except selected — PSA controversial in some; AFP + US for HCC in cirrhotic); false positives + overdiagnosis common in low-prevalence settings.', NULL,
  'medium', 'hemato_onco', 'review',
  'surgery', 'basic_science', 'hemato_onco', 'adult',
  'NCCN Tumor Marker Guidelines; ASCO Tumor Marker Guidelines; Locker GY et al. JCO', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'Basic science: surgical pathology + tumor markers

คำถาม: tumor markers in clinical practice'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Basic science: anesthesia + airway management

คำถาม: difficult airway management', '[{"label":"A","text":"Use direct laryngoscopy for all"},{"label":"B","text":"Difficult airway management — ASA Algorithm"},{"label":"C","text":"Sedate heavily without airway plan"},{"label":"D","text":"Avoid surgical airway always"},{"label":"E","text":"Single technique for all situations"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Difficult airway management — ASA Algorithm**: (1) **Pre-op assessment** — predict difficult airway: - **LEMON criteria**: Look (anatomy, beard, dentition, scars), Evaluate 3-3-2 (3 fingers mouth, 3 fingers chin-hyoid, 2 fingers hyoid-thyroid), Mallampati (I-IV — class III-IV difficult), Obstruction (mass, infection, edema, FB), Neck mobility - Mallampati: I (full uvula visible), II (partial), III (only soft palate), IV (only hard palate) - Thyromental distance: < 6 cm = difficult - Sternomental: < 12.5 cm difficult - History of difficult intubation - Prior surgery, RT, anatomy abnormalities - OSA, obesity (BMI > 30), pregnancy, beard; (2) **ASA Difficult Airway Algorithm**: - Awake intubation if predicted difficult (preferred — patient breathing) - Asleep approach if airway unlikely difficult; (3) **Awake fiberoptic intubation (AFOI)** — gold standard for predicted difficult: - Topical anesthesia (lidocaine 4% — atomized, gargle, transtracheal, glossopharyngeal block) - Antisialagogue (glycopyrrolate) - Minimal sedation (dexmedetomidine ideal — preserves respiration; remifentanil; midazolam moderate) - Flexible bronchoscope intubation - Awake provides safety net; (4) **Direct laryngoscopy (DL)** — traditional; Macintosh or Miller blade; Cormack-Lehane view I-IV; difficult if III-IV; (5) **Video laryngoscopy (VL)** — increasingly first-line: - GlideScope, McGRATH, C-MAC - Better view especially anterior larynx - May not improve intubation success if technique not adapted - First-line in pediatric some centers; (6) **Supraglottic airway (LMA)** — rescue + primary in selected: - LMA Classic, LMA ProSeal, LMA Supreme, i-gel, LMA Fastrach (intubating LMA) - Bridge to intubation, surgical airway, emergency oxygenation; (7) **Combitube / King LT** — emergency airway; pre-hospital + difficult airway rescue; (8) **Surgical airway** — failed intubation + cannot ventilate: - **Cricothyroidotomy** — fastest; through cricothyroid membrane; needle (transtracheal) or open surgical - **Tracheostomy** — definitive but slower; emergent if cricothyroidotomy not feasible (children, anatomy distortion); (9) **''Cannot intubate, cannot oxygenate (CICO)''** scenario: - Surgical airway is mandated - Train and equipment readily available; (10) **Special situations**: - Anaphylaxis with angioedema - Burn / inhalation injury - Trauma C-spine immobilized - Pediatric (different anatomy — larger tongue, more anterior larynx, large occiput) - Pregnant (Mallampati increases, edema, aspiration risk) - Morbidly obese; (11) **Post-intubation**: confirm with capnography (end-tidal CO2 — gold standard), auscultation, CXR

---

**Difficult Airway Management** — critical clinical skill spanning anesthesia + emergency + critical care + trauma surgery. **Pre-op assessment**: 1. **History**: prior difficult intubation, surgery, radiation, OSA, snoring, ankylosing spondylitis, RA, obesity, pregnancy 2. **Examination**: - Mallampati class (I-IV) - Thyromental distance (≥ 6 cm) - Sternomental distance - Mouth opening (≥ 3 cm) - Neck mobility - Mandibular protrusion - Dentition, beard, anatomy 3. **LEMON mnemonic**: Look, Evaluate 3-3-2, Mallampati, Obstruction, Neck **ASA Difficult Airway Algorithm (2022 update)**: - Predicted difficult → awake intubation considered first - Anticipated difficult → optimize positioning, equipment, expertise, plan B/C/D - Unanticipated difficult → ramp-up tools + call for help **Awake fiberoptic intubation (AFOI)**: gold standard for predicted difficult; topical local anesthesia + minimal sedation + flexible bronchoscope. **Video laryngoscopy (VL)**: increasingly first-line; better view for anterior larynx; AIRWAYS-2 trial showed mixed results but generally favorable. **Supraglottic airway (LMA)**: rescue + bridge; not definitive in vomiting/regurgitation; primary in selected (short procedures, ambulatory). **Bougie + stylet** — adjuncts. **Surgical airway** — failed intubation + cannot ventilate (CICO scenario): - **Cricothyroidotomy** — preferred emergency: needle (transtracheal jet ventilation — temporary 30 min); surgical (open) — definitive - **Tracheostomy** — definitive; slower; difficult in emergency; pediatric — high tracheal can be safer **Pediatric airway differences**: large tongue, more anterior + cephalad larynx (C3-C4 vs C5-C6 adult), funnel-shaped airway (narrow at cricoid until age 8), large occiput (positioning), softer cartilages. **Trauma**: C-spine precautions (collar, in-line stabilization), bag-mask + jaw thrust without head tilt, video laryngoscopy advantageous. **Confirmation post-intubation**: end-tidal CO2 (capnography) — gold standard; auscultation; chest rise; CXR (depth + position). **Crew Resource Management**: closed-loop communication, role assignment, calling for help early, debriefing.', NULL,
  'medium', 'procedures', 'review',
  'surgery', 'basic_science', 'procedures', 'adult',
  'ASA Difficult Airway Management Guidelines 2022; DAS UK Guidelines; Apfelbaum JL et al. Anesthesiology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'Basic science: anesthesia + airway management

คำถาม: difficult airway management'
  );

commit;

