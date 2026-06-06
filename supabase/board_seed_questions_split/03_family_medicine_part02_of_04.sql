-- ===============================================================
-- หมอรู้ — Board seed: เวชศาสตร์ครอบครัว (family_medicine) — part 2/4 (50 MCQs)
-- Safe to paste into Supabase SQL Editor. Re-runnable.
-- ===============================================================

begin;

-- mcq_subjects for this specialty (idempotent)
insert into public.mcq_subjects
  (name, name_th, icon, audience, board_specialty, exam_type, question_count)
values
  ('fammed_clinical_decision', 'เวชศาสตร์ครอบครัว · การตัดสินใจทางเวชกรรม', '🩺', 'board', 'family_medicine', NULL, 0),
  ('fammed_basic_science', 'เวชศาสตร์ครอบครัว · วิทยาศาสตร์การแพทย์พื้นฐาน', '🧬', 'board', 'family_medicine', NULL, 0),
  ('fammed_ems_mgmt', 'เวชศาสตร์ครอบครัว · การจัดการระบบบริการการแพทย์ฉุกเฉิน', '🚨', 'board', 'family_medicine', NULL, 0),
  ('fammed_integrative', 'เวชศาสตร์ครอบครัว · ข้อสอบบูรณาการ', '🧩', 'board', 'family_medicine', NULL, 0)
on conflict (name) do nothing;

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย อายุ 60 ปี healthy, no family history, no LUTS; มาถามเรื่อง PSA screening', '[{"label":"A","text":"Universal PSA screening for all men"},{"label":"B","text":"Prostate Cancer Screening Shared Decision-Making (USPSTF + AUA + ACS)"},{"label":"C","text":"Never screen — too harmful"},{"label":"D","text":"Force decision without information"},{"label":"E","text":"DRE alone — sufficient screening"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Prostate Cancer Screening Shared Decision-Making (USPSTF + AUA + ACS): (1) **USPSTF 2018**: ages 55-69 — **individual shared decision**; > 70 — recommend against routine; (2) **Race + family history**: Black, family history early/lethal, BRCA1/2, Lynch — discuss earlier (45-50); (3) **Shared decision-making components**: - **Benefits**: ~ 1 in 1000 men aged 55-69 screened with PSA may avoid death from PC over 13 yr (ERSPC); - **Harms**: false positives (~ 75% of biopsies negative); overdiagnosis (~ 30-50%) → overtreatment (incontinence ~ 5-15%, ED ~ 30-70%, urinary/bowel from radiation/surgery); biopsy complications (bleeding, infection, sepsis 1-2%); anxiety; - Patient values + life expectancy ≥ 10 yr; (4) **PSA testing approach if chosen**: baseline + interval based on PSA (lower risk longer interval, 2-4 yr); free PSA, PSA density, PSA velocity, PHI, 4Kscore for ambiguous; (5) **Multi-parametric MRI prostate** before biopsy increasingly preferred (PRECISION trial); reduces unnecessary biopsy; (6) **Active surveillance** for low-risk PC (Gleason 6, low volume) — preferred over immediate treatment in most; avoids overtreatment harms; (7) **DRE** — independent value low; sometimes performed; (8) **Documentation** of shared decision; (9) **Multidisciplinary**: PCP + urology + radiation oncology + medical oncology + patient

---

Prostate screening: USPSTF — shared decision 55-69 yo. Discuss benefits + harms + values + life expectancy. Black + family history earlier. MRI before biopsy increasingly preferred. Active surveillance for low-risk. Multidisciplinary.', NULL,
  'easy', 'hemato_onco', 'review',
  'family_medicine', 'clinical_decision', 'hemato_onco', 'adult',
  'USPSTF Prostate 2018; AUA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยชาย อายุ 60 ปี healthy, no family history, no LUTS; มาถามเรื่อง PSA screening'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้หญิงอายุ 40 ปี — mother + sister with breast cancer (age 45, 50); แม่ + ป้าได้รับ BRCA1 mutation', '[{"label":"A","text":"Routine screening only"},{"label":"B","text":"Hereditary Breast Cancer Risk + Management (NCCN + USPSTF)"},{"label":"C","text":"Avoid genetic testing"},{"label":"D","text":"Wait until cancer develops"},{"label":"E","text":"Single mastectomy only — no genetic eval"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hereditary Breast Cancer Risk + Management (NCCN + USPSTF): (1) **Genetic counseling + testing** — refer all with family history suggestive (USPSTF 2019): - 1st-degree relatives with BC ≤ 50, ovarian, male BC, bilateral, multiple in family, Ashkenazi Jewish; - Risk assessment tools (Tyrer-Cuzick, BRCAPRO); - Pre-test counseling on implications; (2) **BRCA1/2 carriers — lifetime risk**: breast ~ 60-70%, ovarian 40-60% (BRCA1) or 15-30% (BRCA2); also pancreatic, prostate, melanoma; (3) **High-risk surveillance**: - **Breast MRI annually** + mammogram annually starting **age 25-30** (alternate 6 mo apart); clinical breast exam q 6-12 mo; - **Ovarian** — transvaginal US + CA-125 q 6 mo from age 30 (suboptimal — RRSO preferred); (4) **Risk-reducing strategies**: - **Risk-reducing salpingo-oophorectomy (RRSO)** age 35-40 (BRCA1) or 40-45 (BRCA2) after childbearing — reduces ovarian + breast risk; - **Risk-reducing mastectomy** — 90%+ risk reduction; bilateral with/without reconstruction; - **Chemoprevention** (tamoxifen, raloxifene, aromatase inhibitor) — 50% risk reduction; (5) **Lifestyle**: physical activity, weight, alcohol limit, breastfeeding; (6) **Family cascade testing**: at-risk relatives; (7) **Lynch syndrome consideration** + other hereditary syndromes; (8) **Psychosocial support**: high anxiety; counseling, support groups; (9) **Insurance coverage** for genetic + screening (GINA prohibits discrimination); (10) **Multidisciplinary**: PCP + genetic counselor + breast surgery + gyn oncology + medical oncology + plastic surgery + mental health

---

BRCA family history: genetic counseling + testing. Carriers — MRI + mammo annually from 25-30; RRSO 35-45; risk-reducing mastectomy; chemoprevention. Cascade testing. Multidisciplinary high-risk clinic.', NULL,
  'medium', 'hemato_onco', 'review',
  'family_medicine', 'clinical_decision', 'hemato_onco', 'adult',
  'NCCN Genetic/Familial 2024; USPSTF BRCA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้หญิงอายุ 40 ปี — mother + sister with breast cancer (age 45, 50); แม่ + ป้าได้รับ BRCA1 mutation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี average risk, ไม่อยากทำ colonoscopy; ถามทางเลือก', '[{"label":"A","text":"Colonoscopy only or no screening"},{"label":"B","text":"CRC Screening Modality Choice (USPSTF + ACS)"},{"label":"C","text":"MRI as primary screen"},{"label":"D","text":"Abdominal X-ray screening"},{"label":"E","text":"No screening if family history negative"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** CRC Screening Modality Choice (USPSTF + ACS): (1) **Start age 45** (USPSTF + ACS 2021 — lowered from 50 due to young-onset CRC rise) through age 75; ages 76-85 individualized; > 85 not recommended; (2) **Multiple effective modalities** — best test = one patient will do consistently: - **Colonoscopy q 10 yr** — gold standard, can remove polyps, longest interval, requires prep + sedation + day off + small perforation risk; - **FIT (fecal immunochemical test)** annual — stool antigen, no prep, mail-in, low cost; abnormal → colonoscopy; - **gFOBT (guaiac)** annual — older, less sensitive than FIT, dietary restrictions; - **FIT-DNA (Cologuard)** q 3 yr — combined FIT + DNA mutations; higher sensitivity, higher cost + false positives; abnormal → colonoscopy; - **CT colonography** q 5 yr — non-invasive imaging, prep, incidental findings, radiation; abnormal → colonoscopy; - **Flexible sigmoidoscopy** q 5 yr (or q 10 + FIT annual) — limited to distal colon; (3) **Programmatic approach** — annual FIT in many primary care; high participation = best outcomes; (4) **Shared decision** — discuss options, preferences; (5) **High-risk (family history, IBD, polyposis, Lynch)** — earlier + more frequent + colonoscopy preferred; (6) **Reminders + outreach** in EHR + population health; (7) **Multidisciplinary**: PCP + GI + pathology + surgery + cancer center

---

CRC screening: start 45 (USPSTF 2021). Multiple options — best = one patient does. FIT annual common primary care; colonoscopy q 10 yr gold standard; FIT-DNA, CT colonography, sigmoidoscopy alternatives. Shared decision. Programmatic approach.', NULL,
  'easy', 'hemato_onco', 'review',
  'family_medicine', 'clinical_decision', 'hemato_onco', 'adult',
  'USPSTF CRC 2021; ACS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี average risk, ไม่อยากทำ colonoscopy; ถามทางเลือก'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชาย 5 ปี ย้ายมาจากต่างประเทศ — ไม่มีบันทึกวัคซีน, healthy', '[{"label":"A","text":"Start vaccines from birth"},{"label":"B","text":"Pediatric Catch-Up Vaccination (CDC + ACIP)"},{"label":"C","text":"Skip vaccines — child too old"},{"label":"D","text":"One vaccine at a time over years"},{"label":"E","text":"Wait for school requirement"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Catch-Up Vaccination (CDC + ACIP): (1) **General principles**: vaccinate immediately + complete catch-up; minimum intervals between doses; live vaccines together or 4 wk apart; documented vaccines accepted even from other countries (if written + dates match schedule); (2) **Approach to no records**: assume unvaccinated; CDC catch-up schedule; serologic testing limited role (controversial — extra cost, not for all); (3) **At age 5 — catch-up to give**: - **DTaP** — 4 doses (4-6 wk apart × 3, then 6 mo); 5th dose age 4-6; - **IPV (polio)** — 4 doses; - **MMR** — 2 doses 28 d apart; - **Varicella** — 2 doses 3 mo apart; - **HepB** — 3-dose series (0, 1, 6 mo); - **HepA** — 2 doses 6 mo apart; - **Hib** — usually not needed > 59 mo unless immunocompromised/asplenic; - **PCV (pneumococcal conjugate)** — usually not > 59 mo unless high-risk; - **Influenza** annually (first time: 2 doses 4 wk apart); - **COVID-19** per current recommendations; (4) **Future per schedule**: HPV starting 9-11, Tdap age 11, meningococcal 11 + 16, COVID, flu; (5) **Address parental concerns + vaccine hesitancy**: presumptive approach, motivational interviewing, evidence-based information, share own decisions, school requirements; (6) **Multiple vaccines same visit OK + recommended**; (7) **Document** in state immunization registry; (8) **Insurance + VFC (Vaccines for Children)** — free for eligible; (9) **Multidisciplinary**: PCP + pharmacy + public health + school nurse

---

Pediatric catch-up: CDC schedule, assume unvaccinated, start immediately. Multiple vaccines safe + recommended. Document + state registry. Address hesitancy. VFC free for eligible. Multidisciplinary.', NULL,
  'easy', 'id', 'review',
  'family_medicine', 'clinical_decision', 'id', 'peds',
  'CDC ACIP Catch-Up Schedule 2024', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'เด็กชาย 5 ปี ย้ายมาจากต่างประเทศ — ไม่มีบันทึกวัคซีน, healthy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 66 ปี COPD + DM, ยังไม่เคยฉีด pneumococcal vaccine', '[{"label":"A","text":"No pneumococcal vaccine needed"},{"label":"B","text":"Adult Pneumococcal Vaccination (ACIP 2024 Update)"},{"label":"C","text":"PPSV23 alone only"},{"label":"D","text":"Wait until acute pneumonia"},{"label":"E","text":"Repeat every year"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Adult Pneumococcal Vaccination (ACIP 2024 Update): (1) **2 vaccines available**: - **PCV (pneumococcal conjugate)**: PCV15, PCV20 (now preferred over older PCV13); - **PPSV23 (polysaccharide)**: 23 serotypes; (2) **2022-2024 ACIP simplification**: - **Adults ≥ 65 yo** (or 19-64 + high-risk condition) who have not received pneumococcal vaccine: - **Option 1 (preferred — simpler)**: **PCV20 alone (single dose)**; - **Option 2**: **PCV15 followed by PPSV23** ≥ 1 yr later (8 wk if immunocompromised, CSF leak, cochlear implant); - Patient นี้: COPD + DM + age 66 → PCV20 single dose preferred; (3) **Previously vaccinated complex algorithms** — refer CDC chart; PCV20 single dose often appropriate to update; (4) **High-risk 19-64 yo indications**: chronic heart/lung/liver disease, DM, smokers, alcoholism, asplenia, CSF leak, cochlear implant, immunocompromised, CKD/dialysis, HIV, malignancy; (5) **Co-administration**: can give with flu, COVID, RSV, Tdap, shingles — different sites; (6) **Documentation** + state registry; (7) **Address hesitancy + concerns**: efficacy data, safety profile (mild local reaction common, serious AE rare); (8) **Cost coverage**: Medicare Part B + most insurance; (9) **Pharmacist role** — significant in adult vaccinations; (10) **Multidisciplinary**: PCP + pharmacy + public health

---

Pneumococcal vaccine adult ACIP 2024 simplified: PCV20 single dose preferred for vaccine-naive ≥ 65 or 19-64 high-risk. Alternative PCV15 + PPSV23. Co-admin with other vaccines OK. Pharmacist role.', NULL,
  'easy', 'id', 'review',
  'family_medicine', 'clinical_decision', 'id', 'adult',
  'ACIP Pneumococcal 2024 Update', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 66 ปี COPD + DM, ยังไม่เคยฉีด pneumococcal vaccine'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 35 ปี ไอ + เจ็บคอ + คัดจมูก × 4 วัน, no fever, no purulent sputum; ขอ antibiotic', '[{"label":"A","text":"Broad-spectrum antibiotic for all URIs"},{"label":"B","text":"Acute Viral URI — Antibiotic Stewardship (CDC + ACP + IDSA)"},{"label":"C","text":"Steroid taper for cold symptoms"},{"label":"D","text":"Refer to ED for any URI"},{"label":"E","text":"Antiviral for all viral URIs regardless"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Viral URI — Antibiotic Stewardship (CDC + ACP + IDSA): (1) **Most acute URI = viral** (rhinovirus, coronavirus, RSV, influenza, parainfluenza) — antibiotic NOT effective + harmful; common cold typically 7-10 d, cough may last 3 wk; (2) **No antibiotic for**: acute bronchitis, common cold, viral pharyngitis, sinusitis < 10 d without severe/worsening symptoms, viral conjunctivitis; (3) **Bacterial considerations**: - **Strep pharyngitis**: Centor/McIsaac score (fever, tonsillar exudate, anterior cervical LN, no cough, age 3-14) — RADT/throat culture if ≥ 2-3; treat penicillin/amoxicillin × 10 d; - **Acute bacterial sinusitis**: > 10 d, severe (fever > 39, purulent + facial pain ≥ 3 d), worsening after improving; amoxicillin-clavulanate first-line; - **Acute otitis media**: amox high-dose; - **Influenza**: oseltamivir if within 48 h + high-risk; - **COVID**: Paxlovid + Pediatric considerations; (4) **Symptomatic treatment**: rest, fluids, humidified air, saline nasal, OTC decongestant/antihistamine/NSAIDs (use with caution in elderly + HT), throat lozenge, honey for cough (> 1 yr); (5) **Patient counseling**: viral nature, expected duration, when to return (worsening, high fever, severe symptoms, > 10 d no improvement); (6) **Antibiotic stewardship**: shared decision aids, communication training, delayed prescription strategy (give script but try without first); (7) **Public health**: hand hygiene, mask in vulnerable, stay home, vaccination (flu, COVID); (8) **Multidisciplinary**: PCP + pharmacy + public health

---

Acute URI: mostly viral — NO antibiotic. Treat symptoms. Distinguish bacterial (strep, sinusitis ≥ 10d/severe, AOM) — specific abx. Antibiotic stewardship. Patient counseling on expected course + return criteria.', NULL,
  'easy', 'id', 'review',
  'family_medicine', 'clinical_decision', 'id', 'adult',
  'CDC Antibiotic Stewardship; IDSA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 35 ปี ไอ + เจ็บคอ + คัดจมูก × 4 วัน, no fever, no purulent sputum; ขอ antibiotic'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้หญิงอายุ 28 ปี healthy non-pregnant — dysuria + frequency × 2 d; no flank pain, no fever; first episode', '[{"label":"A","text":"Fluoroquinolone first-line for simple cystitis"},{"label":"B","text":"Uncomplicated Acute Cystitis (IDSA 2010 + Updates)"},{"label":"C","text":"Long-course IV antibiotic"},{"label":"D","text":"No antibiotic — observe"},{"label":"E","text":"Cystoscopy for first UTI"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Uncomplicated Acute Cystitis (IDSA 2010 + Updates): (1) **Diagnosis clinical** for classic symptoms (dysuria, frequency, urgency) in healthy non-pregnant women; urine dipstick (nitrite + leukocyte esterase) supports; routine culture not needed for uncomplicated first episode; (2) **First-line antibiotic** (consider local resistance): - **Nitrofurantoin** 100 mg BID × 5 d (avoid eGFR < 30, late pregnancy near term); - **TMP-SMX** DS BID × 3 d (avoid if local resistance > 20%, sulfa allergy, pregnancy 1st trimester + near term); - **Fosfomycin** 3 g single dose (less effective but convenient, expensive); - **Pivmecillinam** (where available); (3) **Avoid** for uncomplicated cystitis: - **Fluoroquinolones** (collateral damage, resistance, FDA warning — tendinopathy, AAA, peripheral neuropathy, mental health, hypoglycemia); - Beta-lactams (less effective than above) — only if alternatives unavailable; (4) **Phenazopyridine** symptomatic relief × 2-3 d (orange urine); (5) **Hydration + voiding**; (6) **Recurrent UTI** (≥ 2 in 6 mo or ≥ 3 in 12 mo): - Lifestyle (post-coital voiding, wiping, hydration, avoid spermicide); - Vaginal estrogen postmenopausal; - **Cranberry products** — modest evidence; - Methenamine hippurate alternative non-antibiotic; - Prophylactic antibiotic continuous or post-coital (select patients); (7) **Complicated UTI considerations**: pregnancy, male, structural/functional abnormality, immunocompromised, recent instrumentation, indwelling catheter → culture + longer course; (8) **Pyelonephritis features**: fever, flank pain, NV → admit or outpatient FQ/cipro × 7-14 d; (9) **Multidisciplinary**: PCP + urology if recurrent/complicated

---

Uncomplicated cystitis: clinical diagnosis. First-line nitrofurantoin / TMP-SMX (if local resist < 20%) / fosfomycin. Avoid FQ (collateral). Recurrent UTI: behavioral + vaginal estrogen + cranberry + non-abx options. Pyelo + complicated different.', NULL,
  'easy', 'id', 'review',
  'family_medicine', 'clinical_decision', 'id', 'adult',
  'IDSA Uncomplicated UTI 2010; AAFP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้หญิงอายุ 28 ปี healthy non-pregnant — dysuria + frequency × 2 d; no flank pain, no fever; first episode'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 45 ปี — headache ใหม่ × 1 wk + worst ever; fever 38.5, neck stiffness, photophobia', '[{"label":"A","text":"Outpatient management with NSAIDs"},{"label":"B","text":"Headache Red Flags + Acute Workup (AHS + AAN — SNOOP4 mnemonic)"},{"label":"C","text":"Migraine treatment without workup"},{"label":"D","text":"Discharge home — follow up 1 wk"},{"label":"E","text":"Treat as tension headache"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Headache Red Flags + Acute Workup (AHS + AAN — SNOOP4 mnemonic): (1) **Red flags (SNOOP4)**: - **S**ystemic: fever, weight loss, immunocompromised, malignancy → infection, vasculitis, malignancy; - **N**eurological: focal deficit, papilledema, AMS, seizure → stroke, mass, hemorrhage; - **O**nset sudden (thunderclap < 1 min to max) → SAH, RCVS, dissection; - **O**lder > 50 new → temporal arteritis, malignancy; - **P**ositional / **P**recipitated by Valsalva → ICP changes; - **P**apilledema; - **P**rogressive worsening; - **P**regnancy / postpartum → eclampsia, CVT, PRES; ผู้ป่วยนี้: fever + neck stiffness + photophobia = **meningitis** (bacterial, viral, fungal); (2) **Acute workup**: - **LP** (after CT if focal/AMS/papilledema) — CSF for cells, glucose, protein, culture, PCR (HSV, enterovirus, meningococcal), cryptococcal Ag (immunocompromised); - **CT head non-contrast** to rule out mass effect/herniation pre-LP; CT angiography if SAH suspected; - **MRI/MRA** more sensitive, esp meningitis complications, CVT, mass; - **Labs**: CBC, CMP, blood cultures × 2, coag; (3) **Empiric treatment IMMEDIATELY** if bacterial meningitis suspected (don''t delay for LP): - **Ceftriaxone 2 g IV + Vancomycin** for typical adult; - **Add ampicillin** if > 50 yo or immunocompromised (Listeria); - **Dexamethasone 10 mg IV** before/with first abx — reduces neuro sequelae (esp pneumococcal); - **Acyclovir IV** if HSV suspected; (4) **Isolation** until bacterial cause excluded; (5) **Post-exposure prophylaxis** for close contacts (meningococcal — rifampin, ciprofloxacin, ceftriaxone); (6) **Public health notification** for reportable meningitis (meningococcal, others); (7) **ICU admission** for severe; (8) **Multidisciplinary**: PCP/ER + neurology + ID + ICU + public health

---

Headache SNOOP4 red flags → emergent workup. Fever + neck stiffness + photophobia = meningitis. Empiric ceftriaxone + vanco + dex IMMEDIATELY (+ ampi > 50 yo); LP after CT if focal. Post-exposure prophylaxis. Public health.', NULL,
  'medium', 'neurology', 'review',
  'family_medicine', 'clinical_decision', 'neurology', 'adult',
  'AHS Headache; IDSA Meningitis', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 45 ปี — headache ใหม่ × 1 wk + worst ever; fever 38.5, neck stiffness, photophobia'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 35 ปี — bilateral pressing headache × 2-3 ครั้ง/wk × หลายเดือน, mild-moderate, no nausea, no aura; stress at work', '[{"label":"A","text":"Daily opioid for chronic headache"},{"label":"B","text":"Tension-Type Headache Management (AHS + IHS)"},{"label":"C","text":"Triptan for tension headache"},{"label":"D","text":"MRI for all headaches"},{"label":"E","text":"Long-term daily NSAIDs without monitoring"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Tension-Type Headache Management (AHS + IHS): (1) **Diagnosis**: bilateral, pressing/tightening, mild-moderate, not aggravated by activity; ≥ 10 episodes; no NV (mild possible); photophobia OR phonophobia possible (not both); not better explained by other; (2) **Subtypes**: infrequent episodic (< 1/mo), frequent episodic (1-14/mo), chronic (≥ 15/mo); (3) **Rule out red flags**: SNOOP4; this patient features classic; (4) **Acute treatment**: - **NSAIDs** (ibuprofen 400-800, naproxen 500) first-line; - **Acetaminophen** alternative; - **Combination analgesics with caffeine** — limit due to medication overuse headache risk; - **Avoid**: opioids, butalbital, frequent over-the-counter (> 10-15 d/mo → medication overuse headache); (5) **Preventive if frequent/chronic**: - **Amitriptyline** 10-100 mg HS first-line (TCA); - Mirtazapine, venlafaxine alternatives; - **Behavioral therapy**: CBT, biofeedback, relaxation; - **Physical therapy** — neck/shoulder + posture; - **Acupuncture, massage**; - **Mindfulness, yoga**; (6) **Address triggers**: stress (CBT, mindfulness), sleep (regular), caffeine, dehydration, posture, eye strain (vision check), TMJ; (7) **Comorbidity**: depression, anxiety, insomnia, chronic neck pain; (8) **Medication overuse headache** workup + management — withdraw overused, transitional therapy; (9) **Multidisciplinary**: PCP + behavioral health + PT + neurology if refractory

---

Tension headache: bilateral pressing, mild-mod. Acute NSAIDs/acetaminophen; avoid opioids. Preventive amitriptyline + behavioral (CBT, biofeedback, relaxation) + PT + acupuncture. Address triggers + comorbidity. MOH important. Multidisciplinary.', NULL,
  'easy', 'neurology', 'review',
  'family_medicine', 'clinical_decision', 'neurology', 'adult',
  'AHS Tension Headache; IHS ICHD-3', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 35 ปี — bilateral pressing headache × 2-3 ครั้ง/wk × หลายเดือน, mild-moderate, no nausea, no aura; stress at work'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี — LBP + saddle anesthesia + new urinary retention × 2 d; recent fall', '[{"label":"A","text":"NSAIDs and outpatient PT"},{"label":"B","text":"Cauda Equina Syndrome — Emergency (ACP + AANS)"},{"label":"C","text":"MRI in 2 weeks routine"},{"label":"D","text":"Discharge with bedrest"},{"label":"E","text":"Chiropractic adjustment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cauda Equina Syndrome — Emergency (ACP + AANS): (1) **Red flag emergency**: cauda equina syndrome (CES) — surgical emergency to prevent permanent dysfunction; (2) **Classic features**: - Saddle anesthesia (perineum, perianal, genitals); - Bladder dysfunction (urinary retention with overflow, or incontinence); - Bowel dysfunction (incontinence, decreased tone); - Bilateral lower extremity radiculopathy + weakness; - Sexual dysfunction; - Reduced anal tone, decreased rectal sensation; (3) **Other LBP red flags** beyond mechanical: - Trauma (this patient — fall); - Malignancy (history, weight loss, > 50 yo, refractory pain); - Infection (fever, IV drugs, immunocompromised); - Fracture (osteoporosis, steroid, trauma); - AAA (pulsatile mass, > 60 yo, vascular risk); - Ankylosing spondylitis (young, morning stiffness, improves with exercise); (4) **Emergency workup**: - **Urgent MRI lumbar spine** — emergent; CT myelography if MRI CI; - Post-void residual; - Neurologic exam — sensory (perineal), motor, reflexes, anal tone, anal wink; - Labs as indicated; (5) **Emergent neurosurgery consult**: surgical decompression within 24-48 h for best outcomes (some advocate < 24 h); (6) **Bladder catheterization** for retention; (7) **Avoid sending home** — admit; (8) **Documentation** of exam + timing; (9) **Multidisciplinary**: PCP/ED + neurosurgery/ortho spine + radiology + urology + rehab

---

Cauda equina syndrome = surgical emergency. Saddle anesthesia + bladder/bowel + bilateral leg deficit. URGENT MRI + neurosurgery within 24-48 h for decompression. Catheterize. Admit. Don''t miss in primary care.', NULL,
  'hard', 'msk_nontrauma', 'review',
  'family_medicine', 'clinical_decision', 'msk_nontrauma', 'adult',
  'ACP LBP; AANS Cauda Equina', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี — LBP + saddle anesthesia + new urinary retention × 2 d; recent fall'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 25 ปี — เจ็บคอ × 2 d, fever 38.8, tonsillar exudate, anterior cervical LN tenderness, no cough, no coryza; Centor 4', '[{"label":"A","text":"Empiric antibiotic for all sore throats"},{"label":"B","text":"Acute Pharyngitis — Strep Workup + Treatment (IDSA + AAP)"},{"label":"C","text":"Skip test — clinical alone"},{"label":"D","text":"Fluoroquinolone first-line"},{"label":"E","text":"No treatment if positive"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Pharyngitis — Strep Workup + Treatment (IDSA + AAP): (1) **Centor/McIsaac score**: fever > 38, no cough, anterior cervical LN, tonsillar exudate, age (3-14 +1, > 45 -1); score ≥ 2-3 → test; (2) **Testing**: **RADT (rapid antigen detection test)** first; if negative + Centor ≥ 3 in adolescents/children → throat culture; ในผู้ใหญ่ negative RADT มัก reliable; PCR available; (3) **Don''t treat empirically without test** unless contraindications testing; (4) **Treatment if positive GAS**: - **Penicillin V 500 mg BID/TID × 10 d** first-line (gold standard); - **Amoxicillin 1g daily × 10 d** alternative (better taste pediatric); - **PCN allergy**: cephalexin (low cross-reactivity if no anaphylaxis), azithromycin × 5 d, clindamycin; resistance increasing; (5) **Goals of treatment**: reduce duration symptoms 1-2 d, reduce transmission, prevent acute rheumatic fever (rare in resourced settings), prevent suppurative complications (PTA, lymphadenitis), reduce post-strep GN (limited); (6) **Symptomatic**: NSAIDs/acetaminophen, hydration, throat lozenge, saltwater gargle; (7) **Return to school/work**: 24 h after antibiotic + afebrile; (8) **Recurrent pharyngitis**: consider carrier vs true infection; tonsillectomy criteria (Paradise — ≥ 7 episodes in 1 yr, ≥ 5/yr × 2 yr, ≥ 3/yr × 3 yr); (9) **Complications watch**: PTA (peritonsillar abscess) — needs drainage; scarlet fever, post-strep GN, rheumatic fever; (10) **Multidisciplinary**: PCP + ENT if recurrent

---

Pharyngitis: Centor + RADT (culture if negative children). Positive GAS → penicillin V × 10 d (amox alternative). Pen allergy: cephalosporin/macrolide. Reduces sx duration + transmission + complications. Symptomatic care. Recurrent: tonsillectomy criteria.', NULL,
  'easy', 'id', 'review',
  'family_medicine', 'clinical_decision', 'id', 'adult',
  'IDSA Pharyngitis 2012', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 25 ปี — เจ็บคอ × 2 d, fever 38.8, tonsillar exudate, anterior cervical LN tenderness, no cough, no coryza; Centor 4'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชาย 2 ปี — fever 39.0 + ear pain + bulging TM with effusion; severe symptoms', '[{"label":"A","text":"No treatment ever"},{"label":"B","text":"Acute Otitis Media Pediatric (AAP 2013 + 2022 Update)"},{"label":"C","text":"Topical drops only for AOM"},{"label":"D","text":"Long-term prophylactic antibiotic routine"},{"label":"E","text":"Immediate tympanostomy for first episode"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Otitis Media Pediatric (AAP 2013 + 2022 Update): (1) **Diagnostic criteria**: middle ear effusion + signs of inflammation (bulging TM, otorrhea not from external) + moderate-severe symptoms; (2) **Severe AOM**: T > 39, severe otalgia ≥ 48 h, otorrhea, bilateral (< 2 yo); (3) **Treatment decision**: - **< 6 mo**: always treat; - **6 mo - 2 yo**: treat if certain diagnosis + bilateral or severe; observation option if non-severe + unilateral + reliable follow-up; - **≥ 2 yo**: observation option × 48-72 h with rescue Rx prescription (SNAP — Safety Net Antibiotic Prescription) if non-severe; treat if severe; - ผู้ป่วยนี้: 2 yo + severe → **treat**; (4) **Antibiotic of choice**: - **Amoxicillin high-dose 80-90 mg/kg/d divided BID × 10 d** first-line; (≤ 5 yo or severe — 10 d; > 6 yo non-severe — 5-7 d); - **Amoxicillin-clavulanate** if recent abx (90 d), concurrent purulent conjunctivitis (likely H. influenzae), treatment failure 48-72 h; - **PCN allergy**: cefdinir, cefuroxime, cefpodoxime (low cross-reactivity); macrolide (azithromycin × 5 d) — increasing resistance; ceftriaxone IM × 1-3 d severe; (5) **Symptomatic**: ibuprofen/acetaminophen for pain; **avoid topical analgesics in unperforated TM** (controversial); (6) **Follow-up**: improvement 48-72 h; if not → reassess + change abx; (7) **Recurrent AOM** (≥ 3 in 6 mo or ≥ 4 in 12 mo): consider tympanostomy tubes; (8) **Prevention**: pneumococcal + flu vaccine, breastfeeding, avoid tobacco smoke, daycare considerations, no bottle while supine; (9) **Multidisciplinary**: PCP + ENT if recurrent/persistent effusion

---

Pediatric AOM: criteria (effusion + inflammation + sx). Treat < 6 mo, severe, bilateral young. Observation option non-severe + reliable F/U. **Amoxicillin high-dose** first-line × 10 d; amox-clav if treatment failure/recent abx. Vaccines for prevention.', NULL,
  'medium', 'id', 'review',
  'family_medicine', 'clinical_decision', 'id', 'peds',
  'AAP AOM 2013 + 2022', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'เด็กชาย 2 ปี — fever 39.0 + ear pain + bulging TM with effusion; severe symptoms'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 40 ปี — nasal congestion + facial pain × 12 d, ไม่ดีขึ้น, purulent rhinorrhea เพิ่ม + fever กลับมา; no severe sx initially', '[{"label":"A","text":"Antibiotic for any sinusitis < 10 days"},{"label":"B","text":"Acute Sinusitis (IDSA + AAFP 2012 + ICAR 2021)"},{"label":"C","text":"No antibiotic ever — always viral"},{"label":"D","text":"CT imaging for every case"},{"label":"E","text":"Steroid burst alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Sinusitis (IDSA + AAFP 2012 + ICAR 2021): (1) **Acute bacterial rhinosinusitis (ABRS) criteria** — any 1 of: - **Persistent** symptoms ≥ 10 d without improvement; - **Severe** symptoms (T > 39, purulent + facial pain ≥ 3-4 d at onset); - **Worsening** after initial improvement (double-sickening — this patient); (2) **No imaging** for uncomplicated; CT only for complications, surgical, or recurrent/chronic; (3) **Common pathogens**: S. pneumoniae, H. influenzae, M. catarrhalis; (4) **Antibiotic first-line**: - **Amoxicillin-clavulanate** standard adult dose 875/125 BID × 5-7 d (or 5-10 d kids); IDSA prefers amox-clav over amox alone for better H. flu coverage + beta-lactamase; - **PCN allergy**: doxycycline (adult), respiratory fluoroquinolone (levofloxacin) — reserve; pediatric — cefuroxime, cefpodoxime, cefdinir, clindamycin + cefixime combo; - Macrolides + TMP-SMX — high resistance, NOT recommended empirically; (5) **High-dose amox-clav (2g/125 BID)** if: severe, > 65 yo, recent hospitalization, recent antibiotics, immunocompromised, daycare; (6) **Symptomatic adjuncts**: saline irrigation (good evidence), intranasal steroid (modest), decongestants (limit < 3 d, rebound), analgesics; (7) **Reassess 48-72 h**: if no improvement → change abx (amox-clav high-dose, FQ); (8) **Complications watch** (rare but serious): orbital cellulitis, cavernous sinus thrombosis, meningitis, brain abscess, Pott''s puffy tumor — urgent CT + ENT/neurosurgery + IV abx; (9) **Chronic sinusitis (> 12 wk)**: different management, ENT referral, intranasal steroids, irrigation, possibly endoscopic surgery; (10) **Multidisciplinary**: PCP + ENT chronic/complications

---

ABRS criteria: persistent ≥ 10 d, severe ≥ 3-4 d at onset, or worsening (double-sickening). Amox-clav first-line. Saline irrigation + intranasal steroid. Reassess 48-72 h. Watch complications. Chronic sinusitis — ENT.', NULL,
  'easy', 'id', 'review',
  'family_medicine', 'clinical_decision', 'id', 'adult',
  'IDSA Sinusitis 2012; ICAR 2021', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 40 ปี — nasal congestion + facial pain × 12 d, ไม่ดีขึ้น, purulent rhinorrhea เพิ่ม + fever กลับมา; no severe sx initially'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 8 ปี — bilateral red eye + watery discharge × 2 d, no pain, no vision change; URI symptoms; ไม่มี contact lens', '[{"label":"A","text":"Topical antibiotic for all conjunctivitis"},{"label":"B","text":"Conjunctivitis Differential + Management (AAO + AAFP)"},{"label":"C","text":"Topical steroid first-line"},{"label":"D","text":"Patch eye for treatment"},{"label":"E","text":"Ignore vision change"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Conjunctivitis Differential + Management (AAO + AAFP): (1) **Differentiate by features**: - **Viral** (most common — adenovirus): watery discharge, often URI + preauricular LN, bilateral progression, highly contagious; - **Bacterial**: purulent thick discharge, usually unilateral start, sticky lids; - **Allergic**: itching prominent, bilateral, watery, often other atopy; - **Gonococcal/chlamydial**: severe purulent, sexually active, neonatal; - **Herpes simplex/zoster**: vesicles, dendritic ulcer, severe — refer urgent; (2) **Red flags requiring ophthalmology**: severe pain, vision loss, photophobia (vs comfort), contact lens use (Pseudomonas, Acanthamoeba), corneal involvement, herpes suspected, hyperacute purulent (gonococcal), failure to improve; (3) **Viral conjunctivitis**: - Supportive: cool compress, artificial tears, hand hygiene, separate towels, no shared items; - Contagious 10-14 d; school/work return when discharge resolved (controversial); - No antibiotic effective; (4) **Bacterial conjunctivitis**: - Most self-limited; abx shortens duration; - **Topical**: erythromycin ointment, polymyxin-trimethoprim, gentamicin, fluoroquinolone (moxifloxacin, ofloxacin) — reserve for contact lens or severe; - Avoid neomycin (allergy), gentamicin can be corneal-toxic; - Pediatric concurrent otitis (H. flu) → systemic abx; (5) **Allergic**: topical antihistamine-mast cell stabilizer (olopatadine, ketotifen), cold compress, allergen avoidance; oral antihistamine; severe — topical steroid by ophthalmology; (6) **STI-related** (gonococcal/chlamydial): adult + sexual exposure → IM ceftriaxone + oral azithromycin/doxy + ophthalmology; neonatal → admit + IV abx; (7) **Multidisciplinary**: PCP + ophthalmology referral red flags; STI + public health if relevant

---

Conjunctivitis: differentiate viral (watery, URI, preauricular LN) vs bacterial (purulent) vs allergic (itchy) vs HSV/gonococcal (urgent). Red flags → ophthalmology. Viral — supportive. Bacterial — topical abx selective. Allergic — topical antihistamine.', NULL,
  'easy', 'id', 'review',
  'family_medicine', 'clinical_decision', 'id', 'peds',
  'AAO Conjunctivitis 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 8 ปี — bilateral red eye + watery discharge × 2 d, no pain, no vision change; URI symptoms; ไม่มี contact lens'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 30 ปี — acute watery diarrhea 6-8 ครั้ง/d + cramping × 2 d, no fever, no blood, no recent travel/abx, mild dehydration', '[{"label":"A","text":"Broad-spectrum antibiotic empirically"},{"label":"B","text":"Acute Infectious Gastroenteritis (IDSA 2017 + WHO)"},{"label":"C","text":"IV fluids only — no oral"},{"label":"D","text":"Strict BRAT diet × 1 week"},{"label":"E","text":"Anti-motility for bloody diarrhea"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Infectious Gastroenteritis (IDSA 2017 + WHO): (1) **Most acute diarrhea = viral self-limited** (norovirus, rotavirus, adenovirus); no abx needed; (2) **Severity assessment**: dehydration (vital signs, mucous membranes, skin turgor, urine output, mental status, weight loss); (3) **Oral rehydration therapy (ORT) first-line** — WHO ORS or commercial; preferred over IV for mild-moderate; small frequent sips; (4) **Diet**: resume regular diet ASAP (BRAT diet outdated); avoid lactose if intolerance, sugary drinks alone, alcohol; (5) **Anti-motility (loperamide)** — OK for non-bloody, non-febrile adult diarrhea; reduce duration + frequency; avoid in suspected invasive (fever, bloody) — risk megacolon, HUS extension (e.g., EHEC, C. diff); (6) **Antiemetic**: ondansetron for nausea; (7) **Antibiotic indications limited**: - Severe/persistent symptoms; - Immunocompromised; - Suspected/confirmed specific pathogens (Shigella, Salmonella severe, Campylobacter severe, traveler''s, cholera, C. diff); - Sepsis features; - **Empiric** ciprofloxacin/azithromycin not routinely recommended without specific indication; - **Avoid in suspected EHEC** (Shiga toxin) — increases HUS risk; (8) **Workup**: usually not needed if mild; stool studies (culture, O&P, C. diff PCR, viral PCR) for severe, prolonged > 7 d, bloody, immunocompromised, recent abx (C. diff), hospitalized, travel, outbreak; (9) **C. diff considerations**: recent abx, hospitalization, age > 65 — PCR/EIA stool toxin; treat oral vanco or fidaxomicin; (10) **Public health**: report outbreaks; food-handler exclusions; (11) **Prevention**: hand hygiene, food safety, water safety, vaccines (rotavirus pediatric, cholera selected, typhoid travel); (12) **Multidisciplinary**: PCP + ID + public health

---

Acute GE: mostly viral self-limited. ORT first. Resume diet ASAP. Loperamide for non-bloody adult OK; avoid invasive/EHEC. Antibiotic targeted not empiric. Workup for severe/prolonged/bloody/immunocompromised. C. diff considerations.', NULL,
  'easy', 'id', 'review',
  'family_medicine', 'clinical_decision', 'id', 'adult',
  'IDSA Diarrhea 2017', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 30 ปี — acute watery diarrhea 6-8 ครั้ง/d + cramping × 2 d, no fever, no blood, no recent travel/abx, mild dehydration'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 45 ปี — insomnia × 6 mo, difficulty initiating sleep + frequent awakenings + daytime fatigue; ขอ benzodiazepine', '[{"label":"A","text":"Long-term benzodiazepine daily"},{"label":"B","text":"Chronic Insomnia Management (AASM 2017 + ACP)"},{"label":"C","text":"Diphenhydramine nightly"},{"label":"D","text":"Ignore — just need sleep"},{"label":"E","text":"Increase caffeine to function"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Chronic Insomnia Management (AASM 2017 + ACP): (1) **Diagnosis chronic insomnia disorder**: difficulty initiating/maintaining sleep ≥ 3x/wk × ≥ 3 mo + daytime impairment + not better explained by other; (2) **Comprehensive evaluation**: - Sleep diary 1-2 wk; - Comorbidity screen: depression, anxiety, OSA (STOP-BANG), RLS, chronic pain, medications (caffeine, alcohol, decongestant, BB, steroid), substances; - Medical: thyroid, menopause, prostate, CV; - Lifestyle: screen time, shift work, naps; (3) **First-line: CBT-I (Cognitive Behavioral Therapy for Insomnia)** — gold standard (ACP strong recommendation): - Stimulus control, sleep restriction, cognitive restructuring, sleep hygiene, relaxation; - In-person, group, digital (CBT-I apps — SHUTi, Sleepio, Somryst FDA-approved); - More effective than meds long-term + no SE; (4) **Sleep hygiene** important adjunct: regular schedule, dark cool bedroom, limit caffeine/alcohol/screens before bed, exercise (not late), bed for sleep + sex only; (5) **Pharmacotherapy if CBT-I unavailable/inadequate** — short-term + targeted: - **Newer agents preferred**: ramelteon (melatonin agonist), doxepin low-dose (sleep maintenance), suvorexant + lemborexant (DORAs — dual orexin receptor antagonists — newer + safer); - **Z-drugs** (zolpidem, eszopiclone) — short-term; risks: complex sleep behavior, falls elderly, dependence; - **Benzodiazepines AVOID** in chronic insomnia: addiction, falls, cognition, MV accidents, mortality (Beers criteria PIM); (6) **Avoid** OTC antihistamines (diphenhydramine — anticholinergic, tolerance, Beers); (7) **Address comorbidity**: depression (SSRI), pain, OSA (CPAP); (8) **Mindfulness, exercise, light therapy** evidence-based adjuncts; (9) **Patient education + non-stigmatizing**; (10) **Multidisciplinary**: PCP + behavioral health/sleep psychology + sleep medicine if refractory

---

Chronic insomnia: CBT-I first-line (ACP). Sleep hygiene. Pharmacotherapy short-term — DORAs/ramelteon/doxepin preferred; avoid benzo + diphenhydramine (Beers). Address comorbidity. Digital CBT-I accessible. Multidisciplinary.', NULL,
  'medium', 'psych_behavior', 'review',
  'family_medicine', 'clinical_decision', 'psych_behavior', 'adult',
  'AASM Insomnia 2017; ACP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 45 ปี — insomnia × 6 mo, difficulty initiating sleep + frequent awakenings + daytime fatigue; ขอ benzodiazepine'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 28 ปี — recurrent unexpected panic attacks (chest tightness, palpitation, choking, fear of dying) + persistent worry; medical workup negative', '[{"label":"A","text":"Long-term benzodiazepine daily"},{"label":"B","text":"Panic Disorder Management (APA + AAFP)"},{"label":"C","text":"Ignore — panic harmless"},{"label":"D","text":"Cardiac workup repeated indefinitely"},{"label":"E","text":"Avoidance behavior — stay home"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Panic Disorder Management (APA + AAFP): (1) **Diagnosis DSM-5**: recurrent unexpected panic attacks + ≥ 1 mo of persistent worry about attacks or maladaptive behavior change + not attributable to other; (2) **Medical workup**: TSH, EKG, electrolytes, CBC; ECG for chest sx; rule out cardiac, thyroid, pheochromocytoma (selected), substance use; (3) **First-line treatment** — combination preferred: - **SSRI** (sertraline, escitalopram, paroxetine FDA-approved) or SNRI (venlafaxine) — start LOW (e.g., sertraline 12.5-25 mg) to avoid initial activation; titrate weekly; full effect 4-6 wk; continue 1-2 yr after remission; - **CBT** for panic disorder — interoceptive exposure, cognitive restructuring, breathing retraining; equally effective as SSRI, more durable; - Combination CBT + SSRI most effective severe; (4) **Avoid long-term benzodiazepines**: short-term bridge OK (alprazolam, clonazepam) for severe acute, but addiction + tolerance + rebound; preferred short-acting low-dose; (5) **Lifestyle**: exercise, sleep, caffeine reduction, alcohol avoidance, mindfulness; (6) **Acute panic attack**: breathing techniques, grounding (5-4-3-2-1), reassurance, safe place; do not avoid; (7) **Comorbidity**: depression (high), other anxiety, substance use — screen + treat; (8) **Patient education**: panic not dangerous, sensations explained, avoidance maintains anxiety; (9) **Telehealth + apps** options for CBT (Woebot, Calm, Headspace, NICE-recommended digital CBT); (10) **Multidisciplinary**: PCP + behavioral health/psychiatry if complex + Collaborative Care

---

Panic disorder: SSRI/SNRI + CBT first-line. Avoid long-term benzo (bridge only). Lifestyle (caffeine, exercise). Education + breathing. Comorbidity. Digital CBT + Collaborative Care. Effective treatment widely available.', NULL,
  'easy', 'psych_behavior', 'review',
  'family_medicine', 'clinical_decision', 'psych_behavior', 'adult',
  'APA Panic Disorder; AAFP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 28 ปี — recurrent unexpected panic attacks (chest tightness, palpitation, choking, fear of dying) + persistent worry; medical workup negative'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 30 ปี — chronic inattention + disorganization + impulsivity ตั้งแต่เด็ก + ส่งผลต่อ work + relationships', '[{"label":"A","text":"Ignore — childhood condition only"},{"label":"B","text":"Adult ADHD Diagnosis + Treatment (DIVA + ACEM + APA)"},{"label":"C","text":"Long-term opioid for focus"},{"label":"D","text":"Random antidepressant without workup"},{"label":"E","text":"Avoid all medications"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Adult ADHD Diagnosis + Treatment (DIVA + ACEM + APA): (1) **DSM-5 criteria adult**: ≥ 5 of 9 inattention or hyperactivity-impulsivity symptoms persistent ≥ 6 mo + onset before age 12 + multiple settings + functional impairment + not better explained by other; (2) **Diagnostic workup**: clinical interview (DIVA-5 structured), self-report scales (ASRS), collateral history (parent, partner), school records if available; rule out mood, anxiety, sleep, substance use, hearing, thyroid; (3) **Comorbidity common** (~ 70%): depression, anxiety, substance use, learning disability, sleep disorder, autism spectrum; treat concurrently; (4) **Pharmacotherapy first-line**: - **Stimulants** (most effective) — methylphenidate (Ritalin, Concerta — long-acting preferred adult), amphetamine (Adderall, Vyvanse); start low + titrate; side effects (appetite, sleep, BP, HR, anxiety, rebound, abuse potential — Schedule II); BP/HR monitoring; - **Non-stimulants**: **atomoxetine** (Strattera — SNRI, non-controlled), **viloxazine** (Qelbree — newer), alpha-2 agonists (guanfacine, clonidine); useful if stimulant contraindicated, substance use risk, comorbidity (anxiety); - **Bupropion** off-label option; (5) **Behavioral interventions**: CBT for ADHD (specialized), coaching, executive function strategies, environmental modifications, mindfulness; (6) **Workplace/educational accommodations**: ADA; quiet space, breaks, written instructions; (7) **Cardiovascular evaluation** before stimulants: HR, BP, family/personal cardiac history; ECG if concerns; (8) **Substance use** screen + monitor (extended-release stimulants + non-stimulants if risk); (9) **Driving safety** counseling; (10) **Adult ADHD undertreated** — significant functional + QOL impact; (11) **Multidisciplinary**: PCP + psychiatry/psychology + ADHD coach + workplace/school + family + Collaborative Care

---

Adult ADHD: DSM-5 + structured interview + collateral. Stimulants first-line (long-acting preferred); non-stimulants (atomoxetine, viloxazine, alpha-2) alternatives. CBT + accommodations. Comorbidity. CV evaluation. Underdiagnosed adult.', NULL,
  'medium', 'psych_behavior', 'review',
  'family_medicine', 'clinical_decision', 'psych_behavior', 'adult',
  'DIVA-5; APA ADHD', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 30 ปี — chronic inattention + disorganization + impulsivity ตั้งแต่เด็ก + ส่งผลต่อ work + relationships'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี — drinks 6-8 drinks/d × 10 yr, wants to cut down; AUDIT-C 8; LFT mild elevation', '[{"label":"A","text":"Ignore alcohol use"},{"label":"B","text":"Alcohol Use Disorder (AUD) Primary Care Management (USPSTF + APA + SAMHSA)"},{"label":"C","text":"Long-term benzodiazepine maintenance"},{"label":"D","text":"Single intervention — no follow-up"},{"label":"E","text":"Cold-turkey withdrawal at home for severe AUD"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Alcohol Use Disorder (AUD) Primary Care Management (USPSTF + APA + SAMHSA): (1) **Screening**: USPSTF — all adults; AUDIT-C (3-item, ≥ 4 men, ≥ 3 women positive) or AUDIT (10-item, ≥ 8 risky); single-item NIAAA (heavy drinking day in past year); (2) **Brief intervention** (SBIRT framework) effective in primary care: - Personalized feedback, motivational interviewing, goal-setting, follow-up; - Even brief counseling reduces consumption; (3) **AUD diagnosis DSM-5**: ≥ 2 of 11 criteria over 12 mo; mild (2-3), moderate (4-5), severe (≥ 6); (4) **Pharmacotherapy (underused — only ~ 2% AUD treated with meds)**: - **Naltrexone** (oral 50 mg daily or **monthly injection Vivitrol**) — reduces cravings + heavy drinking; first-line; CI in opioid use; - **Acamprosate** — for abstinence maintenance; CI severe renal; - **Disulfiram** — aversion (vomiting with alcohol); requires motivation + supervision; - **Off-label**: topiramate, gabapentin, baclofen; (5) **Behavioral therapy**: CBT, motivational enhancement, 12-step facilitation (AA), group therapy, contingency management; combination meds + therapy best; (6) **Withdrawal management**: CIWA assessment; mild-moderate outpatient with benzodiazepine taper (e.g., chlordiazepoxide, lorazepam) + thiamine + folate + magnesium; severe / risk DTs / seizure history / pregnancy → inpatient; (7) **Address comorbidity**: depression (high), anxiety, PTSD, other substance use, chronic pain; (8) **Medical complications screen**: LFTs, hepatitis (HCV common), peripheral neuropathy, thiamine deficiency (Wernicke prevention), pancreatitis, cardiomyopathy, cancers, falls; (9) **Vaccinations**: HAV, HBV, pneumococcal; (10) **Recovery support**: AA, SMART Recovery, recovery housing, peer support specialists; (11) **Multidisciplinary**: PCP + behavioral health + addiction medicine + hepatology + social work

---

AUD: USPSTF screening (AUDIT-C). SBIRT brief intervention. **Naltrexone** first-line pharmacotherapy (underused). Acamprosate, disulfiram options. Behavioral therapy combo best. Withdrawal management. Comorbidity + complications. Multidisciplinary.', NULL,
  'easy', 'psych_behavior', 'review',
  'family_medicine', 'clinical_decision', 'psych_behavior', 'adult',
  'USPSTF AUD; APA AUD 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี — drinks 6-8 drinks/d × 10 yr, wants to cut down; AUDIT-C 8; LFT mild elevation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 35 ปี — chronic opioid use, wants to stop; tolerance + withdrawal; +urine drug screen positive opioids', '[{"label":"A","text":"Detoxification alone — no medication"},{"label":"B","text":"Opioid Use Disorder (OUD) Treatment (SAMHSA + ASAM)"},{"label":"C","text":"Long taper without MOUD"},{"label":"D","text":"Refuse to treat — moral failing"},{"label":"E","text":"Single-modality detox"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Opioid Use Disorder (OUD) Treatment (SAMHSA + ASAM): (1) **Diagnosis DSM-5**: ≥ 2 of 11 criteria over 12 mo; severity mild/moderate/severe; (2) **Medications for OUD (MOUD)** — gold standard, life-saving; > 50% reduction in mortality vs no medication: - **Buprenorphine** (sublingual, mono or with naloxone — Suboxone) — partial mu agonist; ceiling effect (safer); X-waiver REMOVED 2023 — any DEA-licensed prescriber can prescribe (MAJOR access expansion); start when in withdrawal (avoid precipitated); - **Methadone** — full mu agonist; opioid treatment programs (OTPs) only currently in US; effective; - **Naltrexone** (Vivitrol monthly injection) — opioid antagonist; requires 7-14 d abstinence first; less effective adherence-dependent; (3) **Choose based on**: patient preference, prior treatment, severity, comorbidity, access, pregnancy (methadone or buprenorphine preferred); (4) **Behavioral therapy adjunct**: CBT, contingency management, MI; but MOUD alone reduces mortality — don''t withhold for lack of therapy access; (5) **Harm reduction**: - **Naloxone** prescription/distribution — universal for opioid users + close contacts; intranasal Narcan, IM; OTC approved 2023; - Syringe service programs; - Drug checking (fentanyl test strips); - Safe consumption sites (limited US); (6) **Address comorbidity**: HIV, HCV (treat as Tx as P!), pain, mental health (depression, anxiety, PTSD), social (housing, employment); (7) **Pregnancy**: MOUD preferred (buprenorphine, methadone) over abstinence (relapse risk); manage neonatal opioid withdrawal; (8) **Avoid**: detoxification alone without MOUD (high relapse + mortality), shaming, stigma; (9) **Stigma reduction**: language matters (person-first, ''person with OUD'' not ''addict''); (10) **Multidisciplinary**: PCP + addiction medicine + behavioral health + ID + OB if pregnant + social work + recovery community

---

OUD: MOUD = buprenorphine (X-waiver removed 2023 — major access expansion), methadone (OTP), naltrexone — life-saving. Naloxone universal harm reduction. Behavioral adjunct. Pregnancy MOUD preferred. Address comorbidity + stigma. Multidisciplinary.', NULL,
  'medium', 'psych_behavior', 'review',
  'family_medicine', 'clinical_decision', 'psych_behavior', 'adult',
  'SAMHSA TIP 63; ASAM 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 35 ปี — chronic opioid use, wants to stop; tolerance + withdrawal; +urine drug screen positive opioids'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 30 ปี G1P1 postpartum 4 wk — sadness + tearfulness + insomnia + difficulty bonding with baby; EPDS 16; ไม่มี thoughts harming baby', '[{"label":"A","text":"Wait — should resolve naturally"},{"label":"B","text":"Postpartum Depression (PPD) (ACOG + AAP + USPSTF)"},{"label":"C","text":"Stop SSRI — unsafe for breastfeeding"},{"label":"D","text":"Single visit — no follow-up"},{"label":"E","text":"Ignore screening — too sensitive"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Postpartum Depression (PPD) (ACOG + AAP + USPSTF): (1) **Universal screening** — pregnancy + postpartum + well-child visits (mother) — USPSTF recommendation; **EPDS (Edinburgh Postnatal Depression Scale)** ≥ 10 positive screen, ≥ 13 likely depression; PHQ-9 alternative; (2) **Assess safety**: suicidal ideation (especially passive; suicide leading cause of postpartum mortality), thoughts of harming baby (postpartum psychosis emergency — different from PPD); (3) **Differential**: postpartum blues (transient < 2 wk), PPD, postpartum anxiety, postpartum OCD, postpartum PTSD, postpartum psychosis (rare 0.1% — emergency, psychiatric admission), bipolar (mood disorder may present postpartum); rule out medical (thyroid, anemia, sleep deprivation); (4) **Treatment**: - **Mild-moderate**: psychotherapy first-line (CBT, IPT); group, telehealth options; - **Moderate-severe**: SSRI + therapy combination: - **Sertraline first-line** in lactation (minimal breast milk transfer); - Other options: escitalopram, paroxetine; - **Brexanolone** (Zulresso) IV infusion — FDA-approved for PPD severe; - **Zuranolone** (Zurzuvae) — oral; FDA-approved 2023; faster onset; - Continue medications already taking effective (don''t stop SSRI for breastfeeding — risks of untreated depression > minimal medication effects); (5) **Lifestyle support**: sleep (challenging), exercise, social support, baby care help; (6) **Address SDOH**: childcare, financial, partner support, IPV; (7) **Lactation support** + breastfeeding continuation (safe with most SSRIs); (8) **Father postpartum depression** also common — screen; (9) **Postpartum visit comprehensive** — ACOG 2018 — ongoing care for 12 wk + transition; (10) **Multidisciplinary**: family medicine + OB + pediatrics + behavioral health + lactation + social work + family + peer support

---

PPD: universal screening (EPDS). Assess safety + rule out psychosis. Mild-mod — psychotherapy; mod-severe — SSRI (sertraline first-line lactation) + therapy; brexanolone/zuranolone severe new options. SDOH + lactation + father screening. Multidisciplinary.', NULL,
  'easy', 'psych_behavior', 'review',
  'family_medicine', 'clinical_decision', 'psych_behavior', 'adult',
  'ACOG PPD 2018; USPSTF', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 30 ปี G1P1 postpartum 4 wk — sadness + tearfulness + insomnia + difficulty bonding with baby; EPDS 16; ไม่มี thoughts harming baby'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 30 ปี G2P2 — 4 wk postpartum, breastfeeding, ต้องการคุมกำเนิด; HTN + DM history', '[{"label":"A","text":"Combined OCP first-line postpartum < 21 days"},{"label":"B","text":"Postpartum Contraception (CDC US MEC + ACOG)"},{"label":"C","text":"No contraception until breastfeeding stops"},{"label":"D","text":"Surgery only option"},{"label":"E","text":"Same as pre-pregnancy regardless"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Postpartum Contraception (CDC US MEC + ACOG): (1) **Counseling**: discuss prenatal + postpartum + at first postpartum visit; LARC (long-acting reversible contraception) most effective; interpregnancy spacing 18-24 mo for best outcomes; (2) **Lactational Amenorrhea Method (LAM)** — exclusively breastfeeding + amenorrhea + < 6 mo postpartum → ~ 98% effective; but limited applicability; (3) **CDC US MEC categories**: 1 (no restriction), 2 (advantages > risks), 3 (risks > advantages — usually avoid), 4 (unacceptable risk); breastfeeding + postpartum + medical conditions affect choice; (4) **Options by timing**: - **Immediate postpartum (post-placental — within 10 min)**: IUD (Cu or LNG) — OK (slight ↑ expulsion); permanent (BTL); - **0-21 days postpartum**: avoid combined hormonal (estrogen) — VTE risk; **progestin-only OK** (POPs, DMPA, implant, LNG-IUD); (5) **3-6 wk postpartum**: combined hormonal contraception OK if no VTE risk + breastfeeding OK (concern milk supply less now); (6) **Permanent contraception**: BTL postpartum, salpingectomy, vasectomy partner; (7) **For this patient (HTN + DM history, breastfeeding)**: - **LARC preferred**: LNG-IUD (Mirena, Liletta, Kyleena, Skyla) or Cu-IUD or etonogestrel implant (Nexplanon); - Avoid combined hormonal (HTN US MEC 3-4 depending severity); - POPs OK; DMPA OK but consider DM (variable glucose effect); - Discuss permanent if family complete; (8) **Address barriers**: cost (most covered Medicaid + ACA), access, partner involvement; (9) **STI screening + condom use** for prevention; (10) **Future fertility planning**; (11) **Multidisciplinary**: family medicine + OB + pediatrics + nursing + family planning specialist if complex

---

Postpartum contraception: LARC preferred. CDC US MEC. Immediate postpartum IUD OK. 0-21 d avoid combined hormonal (VTE); progestin OK. HTN history → avoid combined; LARC, POPs OK. Counseling prenatal + postpartum.', NULL,
  'medium', 'obgyn', 'review',
  'family_medicine', 'clinical_decision', 'obgyn', 'adult',
  'CDC US MEC; ACOG Postpartum Contraception', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 30 ปี G2P2 — 4 wk postpartum, breastfeeding, ต้องการคุมกำเนิด; HTN + DM history'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกอายุ 2 mo — first well-baby visit หลังคลอด, breastfed + thriving', '[{"label":"A","text":"Skip vaccines at 2 mo"},{"label":"B","text":"Month Well-Baby Visit (AAP Bright Futures)"},{"label":"C","text":"No anticipatory guidance"},{"label":"D","text":"Discharge — return age 1"},{"label":"E","text":"Solid food starting 2 mo"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** 2-Month Well-Baby Visit (AAP Bright Futures): (1) **Growth + nutrition**: weight, length, HC plotted; breastfeeding adequacy (8-12 feeds/d, wet diapers, weight gain); supplementation: vitamin D 400 IU/d breastfed (or partially), iron consider 4 mo; (2) **Vaccinations 2 mo (CDC schedule)**: - DTaP, IPV, Hib, PCV15/20, RV (rotavirus), HepB #2; - 4-6 simultaneous injections OK + recommended; combination vaccines available; - Pre-vaccination counseling: side effects (low-grade fever, irritability, local), benefit, schedule; acetaminophen pre-medication not recommended (may blunt immune response); (3) **Developmental surveillance**: social smile, cooing, head control improving, tracks; (4) **Anticipatory guidance**: - Sleep (back to sleep — SIDS prevention, no co-sleeping in same bed, safe sleep environment), - Feeding (continue breast or formula), - Safety (car seat rear-facing, smoke-free home, water temperature, hand hygiene), - Tummy time, - Reading + interaction, - Maternal mental health screening (PPD); (5) **Screen for**: maternal depression (EPDS/PHQ-9), domestic violence, smoking household, food/housing insecurity (SDOH); (6) **Newborn screen results** review (hearing, metabolic, CCHD); (7) **Bilirubin** post-discharge if not done; (8) **Dental + oral health** education early; first dental visit by age 1; (9) **Address concerns**: colic, reflux, sleep, behavior; reassurance + guidance; (10) **Schedule next**: 4 mo visit; sick visit education + when to call; (11) **Multidisciplinary**: PCP + lactation + maternal mental health + early intervention + social work as needed

---

2-mo WCV: growth + nutrition (vit D supplementation breastfed). Vaccines per CDC (DTaP, IPV, Hib, PCV, RV, HepB). Developmental surveillance. Anticipatory guidance (safe sleep, car seat). Maternal mental health + SDOH screening.', NULL,
  'easy', 'signs_symptoms', 'review',
  'family_medicine', 'clinical_decision', 'signs_symptoms', 'peds',
  'AAP Bright Futures', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ทารกอายุ 2 mo — first well-baby visit หลังคลอด, breastfed + thriving'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 24 mo — ยังไม่พูด 2-word phrase, vocab < 20 คำ, no joint attention, limited eye contact', '[{"label":"A","text":"Wait and see — boys talk later"},{"label":"B","text":"Developmental Delay + Autism Screening (AAP + AAFP)"},{"label":"C","text":"MRI brain immediately for all"},{"label":"D","text":"No intervention until school age"},{"label":"E","text":"Single workup test only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Developmental Delay + Autism Screening (AAP + AAFP): (1) **Surveillance + screening**: developmental surveillance every WCV; **formal screening** at 9, 18, 30 mo (ASQ, PEDS); **autism-specific M-CHAT-R/F** at 18 + 24 mo; (2) **Red flags this child**: language delay (< 50 words age 2 + no 2-word phrases) + social communication concerns (joint attention, eye contact) — high autism concern; (3) **Workup approach**: - **Refer simultaneously** (don''t wait for evaluation to complete): - **Early Intervention (EI — Part C of IDEA)** — free under age 3, comprehensive evaluation, therapies (speech, OT, PT, ABA, family training); - **Audiology** — rule out hearing loss; - **Developmental-behavioral pediatrics or autism specialist** — formal evaluation with ADOS-2, ADI-R; - **Vision** evaluation if concerns; (4) **Medical workup**: comprehensive history + exam (dysmorphic features, neurological); selectively: - **Genetic**: chromosomal microarray (CMA — first-line), Fragile X testing; whole exome if specific features; - **Metabolic**: targeted if regression, dysmorphic, family history; - **Lead level** if exposure risk; - **TSH**; - **EEG** if seizures or regression; - **MRI brain** selected (microcephaly, neuro deficits); (5) **Family support**: education, resources, advocacy (CDC Learn the Signs); (6) **Address comorbidities**: GI, sleep, feeding issues, behavior (sensory, self-injury), anxiety; (7) **Don''t say wait-and-see** for delays at this age — early intervention has best evidence for outcomes; (8) **School transition** age 3 → Part B (IDEA) school services + IEP; (9) **Multidisciplinary**: PCP + EI team + DBP + speech-language pathologist + OT + audiology + genetics + family + community resources

---

Developmental delay + autism concern: don''t wait. Refer EI + audiology + DBP simultaneously. Workup: CMA + Fragile X + targeted. M-CHAT-R/F screening 18 + 24 mo. Family support + comorbidity. Early intervention critical. Multidisciplinary.', NULL,
  'medium', 'signs_symptoms', 'review',
  'family_medicine', 'clinical_decision', 'signs_symptoms', 'peds',
  'AAP Autism Screening 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'เด็กชายอายุ 24 mo — ยังไม่พูด 2-word phrase, vocab < 20 คำ, no joint attention, limited eye contact'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชาย 8 ปี — ครูสังเกตเห็น inattention + impulsivity + hyperactivity at school + home; school performance ลดลง; symptoms ≥ 6 mo', '[{"label":"A","text":"Medication alone — no behavior therapy"},{"label":"B","text":"Pediatric ADHD Diagnosis + Treatment (AAP 2019 + AACAP)"},{"label":"C","text":"Avoid all medication"},{"label":"D","text":"Single visit without school input"},{"label":"E","text":"Send to special school only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric ADHD Diagnosis + Treatment (AAP 2019 + AACAP): (1) **DSM-5 criteria pediatric (< 17 yo)**: ≥ 6 of 9 inattention or hyperactivity-impulsivity symptoms × ≥ 6 mo + onset < age 12 + ≥ 2 settings + functional impairment; (2) **Diagnostic process**: clinical interview + standardized scales from multiple settings (Vanderbilt, Conners — parent + teacher); medical + developmental + behavioral history; observation; (3) **Rule out / co-occurring**: hearing, vision, sleep (OSA — adenoidectomy may help), iron deficiency, thyroid, lead, learning disability, anxiety, depression, trauma, autism spectrum, oppositional defiant, conduct, tic disorder; (4) **Age-based treatment AAP 2019**: - **4-5 yo**: **Behavioral therapy FIRST-LINE** (parent training in behavior management); methylphenidate only if behavioral inadequate + significant impairment; - **6-11 yo (this patient)**: **FDA-approved medication + behavioral therapy** + school accommodations; - **≥ 12 yo**: medication + behavioral + school; (5) **Medications**: - **Stimulants first-line** (methylphenidate or amphetamine) — extended-release preferred for adherence + diversion reduction; titrate to optimal; - **Non-stimulants**: atomoxetine, viloxazine, alpha-2 agonists (guanfacine ER, clonidine ER); for non-responders, side effects, comorbidity; (6) **Behavioral therapy**: parent training (Triple P, Incredible Years, PCIT), CBT older children, social skills, school-based; (7) **School**: 504 plan or IEP; accommodations (preferred seating, breaks, extended time, modified assignments); (8) **Monitor**: response, side effects, growth (height + weight every visit on stimulants), BP/HR, sleep, mood; (9) **Family support + education**: psychoeducation, parent training, family therapy as needed; (10) **Vision/hearing** evaluation; (11) **Multidisciplinary**: PCP + pediatric psychiatry/psychology + school (teachers, counselors) + family + community resources

---

Pediatric ADHD: DSM-5 + multi-setting scales (Vanderbilt, Conners). 4-5 yo behavioral first; 6+ yo medication + behavioral + school. Stimulants first-line (ER preferred). Monitor growth, BP, mood. School accommodations. Family training. Multidisciplinary.', NULL,
  'easy', 'psych_behavior', 'review',
  'family_medicine', 'clinical_decision', 'psych_behavior', 'peds',
  'AAP ADHD 2019', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'เด็กชาย 8 ปี — ครูสังเกตเห็น inattention + impulsivity + hyperactivity at school + home; school performance ลดลง; symptoms ≥ 6 mo'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 28 ปี G1P0 GA 10 wk — severe nausea + vomiting × 3 wk, weight loss 4 kg, dehydration', '[{"label":"A","text":"Ignore — pregnancy resolves it"},{"label":"B","text":"Hyperemesis Gravidarum vs Common NV in Pregnancy (ACOG)"},{"label":"C","text":"Anti-anxiety only"},{"label":"D","text":"Termination of pregnancy"},{"label":"E","text":"Long-term corticosteroid in 1st trimester"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hyperemesis Gravidarum vs Common NV in Pregnancy (ACOG): (1) **NV of pregnancy (NVP)**: ~ 70-80% pregnancies, peak 6-12 wk, usually self-limited; (2) **Hyperemesis gravidarum (HG)**: severe NV + weight loss > 5% pregravid + dehydration + electrolyte/acid-base/ketones; affects 0.5-3%; (3) **PUQE score** (Pregnancy-Unique Quantification of Emesis) — assess severity, guide treatment; (4) **Workup**: vital signs, urine ketones, electrolytes, LFT, TSH (HCG cross-reactivity → hyperthyroid mimic), pregnancy US (rule out molar, multifetal); (5) **Stepwise treatment ACOG**: - **Lifestyle**: small frequent meals, bland/cold foods, ginger (effective), avoid triggers, hydration; - **Pyridoxine (B6) 10-25 mg q 6-8 h** first-line; - **+ doxylamine (combination Diclegis/Bonjesta)** FDA-approved pregnancy; - **Antihistamine**: dimenhydrinate, diphenhydramine; - **Dopamine antagonist**: promethazine, metoclopramide (Reglan — caution prolonged use); - **5HT3 antagonist**: ondansetron — effective but small ↑ risk birth defects (CHD, oral cleft) data mixed; use after others, after 10 wk preferred; - **Corticosteroid** (methylprednisolone) — severe refractory; avoid 1st trimester (oral cleft); - **IV hydration + electrolyte correction** + thiamine (Wernicke prevention) when dehydrated; - **Inpatient** if dehydration, electrolyte imbalance, weight loss not responding; (6) **Nutrition**: enteral tube feeding or TPN rarely needed; (7) **Comorbidity**: depression, anxiety screening; (8) **Antiemetics avoid**: ergot derivatives; phenothiazines selective; (9) **Multidisciplinary**: family medicine + OB + nutrition + behavioral health if needed

---

Pregnancy NV: stepwise. B6 + doxylamine first-line. Antihistamine + promethazine/metoclopramide. Ondansetron after others. IV hydration + thiamine if dehydrated. HG (> 5% weight loss) admit if needed. Multidisciplinary.', NULL,
  'medium', 'obgyn', 'review',
  'family_medicine', 'clinical_decision', 'obgyn', 'adult',
  'ACOG NV Pregnancy 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 28 ปี G1P0 GA 10 wk — severe nausea + vomiting × 3 wk, weight loss 4 kg, dehydration'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย G1P1 — 5 d postpartum — sore cracked nipples + low milk supply concerns + considering formula', '[{"label":"A","text":"Switch to formula immediately"},{"label":"B","text":"Breastfeeding Support + Common Issues (USBC + AAP + ABM)"},{"label":"C","text":"No lactation support — figure it out"},{"label":"D","text":"Stop all medications"},{"label":"E","text":"Single visit advice — no follow-up"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Breastfeeding Support + Common Issues (USBC + AAP + ABM): (1) **Universal counseling pregnancy + postpartum**: exclusive breastfeeding 6 mo + continued through 1-2 yr + complementary foods (WHO + AAP); benefits maternal + infant (decrease infection, allergy, obesity, SIDS, BC + ovarian CA); (2) **Common early issues**: - **Latch problems** — most common cause of nipple pain + low supply; lactation consultant urgent referral; correct latch + positioning; - **Engorgement** — frequent feeding, warm before, cold after, massage, no tight bra; - **Sore/cracked nipples** — latch correction (root cause), lanolin, expressed milk on nipples, brief drying, hydrogel pads; - **Tongue tie (ankyloglossia)** — assessment, frenotomy if functional; - **Mastitis** — pain + redness + warmth + fever; continue feeding (won''t harm baby), warm compress, anti-inflammatories, abx (dicloxacillin/cephalexin) if no improvement 12-24 h or systemic; rule out abscess; - **Plugged duct** — massage, warm, feed/pump; - **Low supply** — increase frequency, hydration, address latch + emptying, galactagogues (fenugreek limited evidence, domperidone outside US); rule out: insufficient glandular tissue, retained placenta, thyroid; (3) **Lactation consultant (IBCLC)** referral early; (4) **Workplace support**: pumping breaks, refrigeration, ACA workplace protections; (5) **Family education**: partner support, household help, realistic expectations; (6) **Maternal medications**: most safe (LactMed reference); avoid pseudoephedrine (decreases supply), some psych meds need consideration (sertraline preferred), chemotherapy CI; (7) **Special situations**: relactation, induced lactation (adoption), milk donation/banks; (8) **Maternal mental health**: postpartum depression affects breastfeeding + vice versa; treat both; (9) **Avoid early supplementation** unless medically indicated (decreases supply, nipple confusion); (10) **Multidisciplinary**: family medicine + OB + pediatrics + IBCLC + WIC + peer support (La Leche)

---

Lactation: latch + positioning most common cause of pain/low supply. IBCLC early. Mastitis: continue feeding + abx if needed. Workplace support. Most meds safe (LactMed). Avoid early supplementation. Address PPD. Multidisciplinary.', NULL,
  'easy', 'obgyn', 'review',
  'family_medicine', 'clinical_decision', 'obgyn', 'adult',
  'AAP Breastfeeding 2022; ABM', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วย G1P1 — 5 d postpartum — sore cracked nipples + low milk supply concerns + considering formula'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 80 ปี — fall × 2 in past 6 mo, gait unsteady, on multiple medications, vision changes', '[{"label":"A","text":"Bed rest to prevent falls"},{"label":"B","text":"Geriatric Falls Assessment + Prevention (CDC STEADI + AGS)"},{"label":"C","text":"Single intervention only"},{"label":"D","text":"Restrict all activity"},{"label":"E","text":"Ignore — falls expected age"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Geriatric Falls Assessment + Prevention (CDC STEADI + AGS): (1) **Falls leading cause of injury death** > 65 yo + significant morbidity; (2) **Screening** annually all ≥ 65 yo: fall in past year, fear of falling, gait/balance problem; (3) **Assessment if positive**: - **Gait + balance**: Timed Up and Go (TUG) > 12 sec, 30-sec chair stand, 4-stage balance; - **Medications** (FRIDs — Fall Risk-Increasing Drugs): benzodiazepines, opioids, anticholinergics, antihypertensives, antidepressants, antipsychotics, sleep aids; deprescribe (Beers, STOPP); - **Vision** (cataract, refractive, glaucoma); - **Feet + footwear**; - **Postural BP** (orthostatic hypotension); - **Cognitive** screen (MoCA, Mini-Cog); - **Comorbidity**: cardiac (arrhythmia, syncope), Parkinson''s, peripheral neuropathy, anemia, alcohol, depression; - **Home safety** assessment (lighting, rugs, stairs, bathroom — grab bars, raised seat); - **Vitamin D** (deficiency contributes); (4) **Multifactorial intervention** — most effective: - **Exercise** (strength, balance — tai chi, Otago, multifactorial PT programs); - Medication review + deprescribe; - Vision correction; - Home modification (OT home assessment); - Vitamin D supplementation if deficient; - Treat underlying conditions; (5) **Bone health**: DXA + osteoporosis treatment to prevent fracture from falls (fracture risk = falls × bone fragility); (6) **Assistive devices** appropriately (cane, walker — PT fit); avoid premature wheelchair (decreases mobility); (7) **Fear of falling** addressed (CBT, exercise programs); (8) **Post-fall syndrome** prevention; (9) **Caregiver education** + family involvement; (10) **Documentation in EHR + community resources** (senior centers, SilverSneakers); (11) **Multidisciplinary**: PCP + PT + OT + pharmacy + ophthalmology + community fall prevention programs (CDC STEADI implementation)

---

Geriatric falls: STEADI screening. Multifactorial assessment (gait, meds, vision, BP, cognition, home, vit D). Multifactorial intervention (exercise — tai chi, deprescribe, vision, home mods). Bone health. Multidisciplinary.', NULL,
  'easy', 'signs_symptoms', 'review',
  'family_medicine', 'clinical_decision', 'signs_symptoms', 'adult',
  'CDC STEADI; AGS Falls 2010', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 80 ปี — fall × 2 in past 6 mo, gait unsteady, on multiple medications, vision changes'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 78 ปี — family concerns about memory + repetition × 1 yr, missed appointments, gets lost in familiar areas; ADL ลดลง', '[{"label":"A","text":"No workup — old age"},{"label":"B","text":"Dementia Workup Primary Care (AAN + Alzheimer''s Association)"},{"label":"C","text":"MMSE alone — sufficient"},{"label":"D","text":"Single visit referral to nursing home"},{"label":"E","text":"Antipsychotic first-line for BPSD"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Dementia Workup Primary Care (AAN + Alzheimer''s Association): (1) **Cognitive assessment**: - **Brief screening**: Mini-Cog (3-word recall + clock draw, ~ 3 min), MoCA (Montreal Cognitive Assessment, 30-pt, more sensitive than MMSE for MCI), MMSE; - **Formal neuropsychology** for unclear or specific subtype; (2) **Functional assessment**: ADL (Katz), IADL (Lawton) — IADL impaired before ADL; (3) **History from collateral source** essential (family, friend); insight often impaired; (4) **Diagnostic workup** rule out reversible causes (~10% — actually contributing more often, less commonly fully reversible): - **Labs**: TSH, B12, CBC, CMP, RPR (selected), HIV (selected); - **Imaging**: MRI brain (or CT) — rule out NPH (normal pressure hydrocephalus — gait, urinary, cognition triad), tumor, stroke, hematoma; structural; - **Depression screening** (pseudodementia mimics); - **Medication review** — anticholinergics, sedatives, opioids worsen cognition; - **Sleep apnea** screen; alcohol/substance; (5) **Subtype evaluation**: Alzheimer''s most common (insidious, memory predominant), vascular (stepwise, vascular risk), Lewy body (visual hallucinations, parkinsonism, REM behavior, fluctuations), frontotemporal (younger, behavior/language), mixed common; (6) **Newer biomarkers** (specialist): - CSF Aβ42, p-tau, t-tau; - Amyloid PET (rarely covered); - **Blood-based biomarkers** emerging (p-tau217 — very promising) — primary care use coming; (7) **Disclosure of diagnosis** to patient + family + planning; (8) **Treatment**: - **Cholinesterase inhibitors** (donepezil, rivastigmine, galantamine) — modest symptomatic benefit AD/Lewy; - **NMDA antagonist** memantine — moderate-severe AD; - **Anti-amyloid antibodies** (lecanemab Leqembi, donanemab) — disease-modifying for early AD with confirmed amyloid; specialist + monitoring (ARIA — amyloid-related imaging abnormalities); access + cost barriers; - **Non-pharmacologic**: cognitive engagement, exercise, social, music, environment, sleep, caregiver education; - **BPSD (behavioral + psychological symptoms)**: address triggers + non-pharm first; antipsychotic LAST resort (Black Box mortality); SSRI for depression; (9) **Caregiver support** essential — counseling, support groups, respite, education (REACH, Savvy Caregiver); (10) **Advance care planning + legal**: POA, advance directive, driving safety, financial planning; (11) **Safety**: driving evaluation, home safety, wandering (MedicAlert + Safe Return), medication safety; (12) **Multidisciplinary**: PCP + neurology/geriatrics + neuropsychology + social work + occupational therapy + caregiver + community (Alzheimer''s Association)

---

Dementia workup: cognitive (Mini-Cog/MoCA) + functional (ADL/IADL) + collateral. Rule out reversible (TSH, B12, MRI, depression, meds). Subtype matters. Treatment: ChEI/memantine; new anti-amyloid early AD. Non-pharm + caregiver support + advance care planning. Multidisciplinary.', NULL,
  'medium', 'neurology', 'review',
  'family_medicine', 'clinical_decision', 'neurology', 'adult',
  'AAN Dementia 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 78 ปี — family concerns about memory + repetition × 1 yr, missed appointments, gets lost in familiar areas; ADL ลดลง'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 82 ปี — acute change in mental status × 3 d, fluctuating, inattention, disorganized thinking; baseline mild MCI', '[{"label":"A","text":"Benzodiazepine first-line for agitation"},{"label":"B","text":"Delirium Recognition + Management (American Geriatrics Society + CAM)"},{"label":"C","text":"Restrain patient"},{"label":"D","text":"No workup — confusion expected"},{"label":"E","text":"Antipsychotic monotherapy long-term"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Delirium Recognition + Management (American Geriatrics Society + CAM): (1) **CAM (Confusion Assessment Method)** for diagnosis: - 1. Acute onset + fluctuating course (required); - 2. Inattention (required); - 3. Disorganized thinking OR 4. Altered LOC; - 1+2 + (3 or 4) = delirium; (2) **Subtypes**: hyperactive (agitated — easier to recognize), hypoactive (lethargic — often missed, worse prognosis), mixed; (3) **Identify cause(s) — usually multifactorial**: - **DELIRIUMS mnemonic** / common: - **Drugs** (anticholinergic, sedatives, opioids, polypharmacy, withdrawal — alcohol, benzo); - **Electrolyte** (Na, Ca, glucose); - **Lack of drugs** (withdrawal); - **Infection** (UTI, pneumonia, sepsis — most common in elderly!); - **Reduced sensory input** (vision, hearing — provide aids); - **Intracranial** (stroke, hemorrhage, mass, meningitis); - **Urinary retention / fecal impaction**; - **Myocardial / metabolic** (MI, hypoxia, CO2 retention, thyroid); - **Sleep deprivation**; (4) **Workup** (targeted): vital signs + O2 + glucose, CBC, CMP, urinalysis + culture, CXR, EKG, TSH, B12; selected (CT head, LP, blood culture, drug levels); (5) **Non-pharmacologic FIRST + ALWAYS**: - **HELP (Hospital Elder Life Program)** + ABCDEF bundle; - Reorientation (clock, calendar, family); - Sensory aids (glasses, hearing aids); - Mobility + PT; - Sleep hygiene (minimize nighttime disruptions); - Hydration + nutrition; - Familiar caregivers + family at bedside; - Avoid restraints (worsen delirium); - Minimize tubes/lines; (6) **Pharmacologic LAST resort** for severe agitation + safety: - **Low-dose antipsychotic** (haloperidol 0.25-0.5 mg, risperidone, quetiapine) — short-term only; Black Box dementia mortality; QTc monitoring; - **Avoid benzodiazepines** (worsen delirium) EXCEPT alcohol/benzo withdrawal; (7) **Treat underlying cause**; (8) **Prognosis**: ~ 50% mortality 1 yr; functional decline; persistent cognitive impairment; (9) **Prevention** more important than treatment — multicomponent (HELP); (10) **Family education + caregiver support**; (11) **Multidisciplinary**: PCP + geriatrics + nursing + PT/OT + pharmacy + behavioral health + family

---

Delirium: CAM diagnosis. Hyperactive vs hypoactive (often missed). Multifactorial — identify causes (UTI, drugs, electrolyte, sensory). Non-pharm FIRST (HELP, ABCDEF, reorient, mobility, sleep). Antipsychotic LAST resort. Avoid benzo (except withdrawal). Prognosis serious. Multidisciplinary.', NULL,
  'medium', 'neurology', 'review',
  'family_medicine', 'clinical_decision', 'neurology', 'adult',
  'AGS Delirium 2015', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 82 ปี — acute change in mental status × 3 d, fluctuating, inattention, disorganized thinking; baseline mild MCI'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 28 ปี MSM — multiple partners + condomless anal sex × 6 mo; ขอ STI screening', '[{"label":"A","text":"Annual screening only"},{"label":"B","text":"MSM STI Screening + Prevention (CDC STI Treatment Guidelines 2021 + USPHS)"},{"label":"C","text":"Refuse to discuss sexual practices"},{"label":"D","text":"PrEP not needed for MSM"},{"label":"E","text":"Urethral only NAAT"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** MSM STI Screening + Prevention (CDC STI Treatment Guidelines 2021 + USPHS): (1) **Screening interval q 3-6 mo** if multiple/anonymous partners + condomless sex: - **HIV**: + 4th gen Ag/Ab; q 3-6 mo high-risk; - **Syphilis**: serology q 3-6 mo; - **Chlamydia + gonorrhea**: NAAT all anatomical sites where sex occurs (oropharyngeal, rectal, urethral); ~ 80% of asymptomatic infection at non-urethral sites; - **Hepatitis A + B + C**: HCV q 6-12 mo if HIV+ or PrEP user; vaccinate HAV/HBV if not immune; HCV more frequent if HIV +; - **HPV**: anal pap selective; (2) **PrEP (Pre-Exposure Prophylaxis)** for HIV — strongly recommend high-risk MSM: - **Daily oral** tenofovir-emtricitabine (Truvada or Descovy); - **On-demand** 2-1-1 dosing (PROUD/IPERGAY) — alternative for MSM; - **LAI cabotegravir** (Apretude) — bimonthly injection — FDA-approved 2021; better adherence; - 99% effective if adherent; - Screening before + during (HIV, renal, HBV, STI); - Counseling, condoms, partner services; (3) **DoxyPEP (doxycycline post-exposure prophylaxis)** — 200 mg within 72 h of condomless sex — reduces syphilis + chlamydia + gonorrhea ~ 60-80% (DoxyPEP, IPERGAY studies); CDC guideline 2024 — recommend selected MSM/TGW; (4) **HPV vaccination** through age 26 (catch-up 27-45 shared decision); (5) **Mpox (monkeypox) vaccination** — Jynneos for high-risk; (6) **Behavioral interventions**: condom use, partner notification + EPT where legal, harm reduction; (7) **Hepatitis A/B vaccination** if not immune; (8) **Substance use screening** + connect care; (9) **Mental health screen** + connect care; (10) **Stigma-free environment + competent care**: training, intake forms (sexual orientation, gender identity, partners, practices), confidentiality; (11) **Multidisciplinary**: PCP + ID/HIV + sexual health clinic + behavioral health + community + public health

---

MSM STI screening: q 3-6 mo HIV + syphilis + GC/CT NAAT all sites + HCV q 6-12. PrEP strongly recommended (daily, 2-1-1, LAI cabotegravir). DoxyPEP. HPV, HepA/B, Mpox vaccination. Stigma-free competent care. Multidisciplinary.', NULL,
  'medium', 'id', 'review',
  'family_medicine', 'clinical_decision', 'id', 'adult',
  'CDC STI 2021; CDC PrEP 2021; CDC DoxyPEP 2024', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 28 ปี MSM — multiple partners + condomless anal sex × 6 mo; ขอ STI screening'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'วัยรุ่นอายุ 16 ปี — moderate inflammatory acne + comedones บนหน้า + chest + back × 1 yr, fail OTC benzoyl peroxide', '[{"label":"A","text":"Oral antibiotic alone long-term"},{"label":"B","text":"Acne Vulgaris Stepwise Management (AAD 2024)"},{"label":"C","text":"Topical antibiotic monotherapy long-term"},{"label":"D","text":"Aggressive scrub + drying agents"},{"label":"E","text":"No treatment — will outgrow"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acne Vulgaris Stepwise Management (AAD 2024): (1) **Severity assessment**: mild (comedonal, few inflammatory), moderate (extensive comedonal + inflammatory papulopustules), severe (nodulocystic, scarring); psychosocial impact assessment important; (2) **Stepwise approach AAD**: - **Mild**: topical retinoid (adapalene OTC, tretinoin Rx, tazarotene) ± benzoyl peroxide (BP); topical antibiotic (clindamycin, erythromycin — always combine with BP to reduce resistance); azelaic acid; - **Moderate (this patient)**: combination topical retinoid + BP + topical antibiotic; or add **oral antibiotic** (doxycycline 100 mg BID or minocycline) × 3-4 mo + topical regimen; combined oral contraceptive (women) — estrogen-containing approved for acne; spironolactone (women — anti-androgen, off-label common); - **Severe / nodulocystic / scarring / refractory**: refer dermatology for **isotretinoin (Accutane)**; iPLEDGE program (US); pregnancy test + 2 forms contraception (severe teratogen); monitor LFT, lipids, mood; (3) **Cycle through topicals**: 3-month trial each combination before escalating; (4) **Avoid**: topical antibiotic monotherapy (resistance), oral antibiotic monotherapy long-term (resistance), aggressive scrubbing, picking, excessive sun exposure with retinoid; (5) **Adjuncts**: gentle skincare, non-comedogenic cosmetics, mineral SPF (sun protection — many acne meds photosensitize); (6) **Procedural**: comedone extraction, chemical peels, light therapy (limited evidence); (7) **Psychosocial impact**: anxiety, depression, body image — screen + address; (8) **Scarring management**: prevention primary, treatment after acne controlled (laser, microneedling, fillers, surgery — dermatology); (9) **Hormonal evaluation** if signs androgen excess (irregular menses, hirsutism, alopecia) — PCOS workup; (10) **Pregnancy considerations** if applicable; (11) **Multidisciplinary**: PCP + dermatology (especially isotretinoin) + mental health if affected

---

Acne: stepwise. Mild — topical retinoid ± BP ± topical abx (combined w/ BP). Moderate — combination + oral doxycycline + OCP/spironolactone (women). Severe — isotretinoin (dermatology + iPLEDGE). Avoid abx monotherapy. Psychosocial + adjuncts. Multidisciplinary.', NULL,
  'easy', 'dermatology', 'review',
  'family_medicine', 'clinical_decision', 'dermatology', 'adult',
  'AAD Acne 2024', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'วัยรุ่นอายุ 16 ปี — moderate inflammatory acne + comedones บนหน้า + chest + back × 1 yr, fail OTC benzoyl peroxide'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี fair skin + history sunburns + family history melanoma; new asymmetric, irregular, dark pigmented lesion 8 mm', '[{"label":"A","text":"No biopsy — observe"},{"label":"B","text":"Suspicious Skin Lesion + Melanoma Approach (AAD + NCCN)"},{"label":"C","text":"Shave biopsy only"},{"label":"D","text":"Refer in 3 months"},{"label":"E","text":"Topical steroid trial"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Suspicious Skin Lesion + Melanoma Approach (AAD + NCCN): (1) **ABCDE criteria** for melanoma: - **A**symmetry; - **B**order irregular; - **C**olor variegated; - **D**iameter > 6 mm; - **E**volving (changes); - This patient: multiple criteria present + risk factors → **biopsy**; (2) **High-risk features**: fair skin, sunburns, family history (CDKN2A, BRCA, BAP1), personal history melanoma/NMSC, atypical nevi, > 50 nevi, immunosuppression, age, occupational/recreational UV; (3) **Biopsy approach**: - **Excisional biopsy with narrow margin (1-3 mm)** preferred for suspicious pigmented lesions — accurate staging; - **Punch biopsy through deepest part** if large; - Avoid shave (may miss depth/Breslow); - Avoid partial sampling if possible; - Document location, photo; (4) **Histopathology features**: Breslow depth (most important prognostic), ulceration, mitotic rate, regression, lymphovascular invasion, margins; (5) **Staging if melanoma confirmed**: dermatology + onc — wide local excision (margins depend on Breslow), SLNB (sentinel lymph node biopsy) if T1b+ (Breslow > 0.8 mm or ulceration); imaging (CT, PET, brain MRI) for stage III+; LDH; (6) **Treatment**: - Local: wide excision; - Adjuvant systemic stage III: immunotherapy (anti-PD-1 nivolumab/pembrolizumab), targeted (BRAF + MEK if BRAF V600 mutant); - Metastatic: immunotherapy (combo nivo + ipilimumab), BRAF/MEK inhibitors, novel; - LAG-3 inhibitor (relatlimab); (7) **NMSC (BCC, SCC)**: more common, less deadly; biopsy + excision/Mohs + topicals selected; (8) **Sun protection counseling**: SPF 30+, broad-spectrum, reapply, shade, protective clothing, sunglasses, avoid tanning beds; (9) **Self-skin exam** monthly; **professional full skin exam** annually for high-risk; (10) **Genetic counseling** if hereditary risk; (11) **Multidisciplinary**: PCP + dermatology + dermatopathology + surgical oncology + medical oncology + radiation oncology + cancer center

---

Suspicious pigmented lesion: ABCDE + risk factors → biopsy. Excisional with narrow margin preferred (not shave). Breslow depth key. Staging + treatment if melanoma (WLE + SLNB + adjuvant). Sun protection + screening. Multidisciplinary.', NULL,
  'medium', 'dermatology', 'review',
  'family_medicine', 'clinical_decision', 'dermatology', 'adult',
  'AAD Melanoma; NCCN Melanoma 2024', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี fair skin + history sunburns + family history melanoma; new asymmetric, irregular, dark pigmented lesion 8 mm'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 45 ปี — overhead worker — shoulder pain + weakness × 2 mo; positive impingement signs; no trauma', '[{"label":"A","text":"Long-term opioid"},{"label":"B","text":"Rotator Cuff Tendinopathy / Subacromial Impingement (AAOS + Cochrane)"},{"label":"C","text":"Immediate surgery for all"},{"label":"D","text":"Bed rest with sling × 6 weeks"},{"label":"E","text":"MRI for all initial cases"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Rotator Cuff Tendinopathy / Subacromial Impingement (AAOS + Cochrane): (1) **Diagnosis clinical**: pain with overhead activity, lateral arm pain, night pain; Neer + Hawkins-Kennedy + Empty Can + Drop Arm tests; (2) **Imaging**: not routine for initial; X-ray if no improvement (rule out arthritis, calcific tendonitis, AC joint); **MRI or US** for: persistent symptoms > 4-6 wk, suspected tear (sudden weakness, trauma, age), pre-surgical planning; US increasingly used in primary care; (3) **Conservative management first-line (4-6 wk)**: - **Activity modification** (avoid overhead aggravators); - **Physical therapy** — gold standard: rotator cuff strengthening, scapular stabilization, posture, manual therapy, stretching; - **NSAIDs** short-course; - **Acetaminophen**; - **Topical analgesics**; - **Ice/heat**; - **Home exercise program** + education; (4) **Subacromial corticosteroid injection** if persistent: - Modest short-term benefit, repeated injections cumulative risk (tendon weakening, rupture); maximum 2-3/year; - US-guided improves accuracy; (5) **Refractory cases**: orthopedic referral for further imaging, possible arthroscopic decompression or rotator cuff repair (full-thickness tear, especially acute traumatic younger; degenerative ≥ 60 yo conservative often successful); (6) **Adjuncts (variable evidence)**: PRP (platelet-rich plasma), prolotherapy, dry needling, acupuncture; (7) **Workplace considerations**: ergonomics, work hardening, return-to-work planning; (8) **Risk factor modification**: smoking (impairs tendon healing), DM (worse outcomes), obesity; (9) **Bilateral / refractory** — consider systemic: spondyloarthritis, polymyalgia rheumatica, diabetes-related; (10) **Multidisciplinary**: PCP + PT + orthopedics + occupational/sports medicine + workplace

---

Shoulder impingement / RC tendinopathy: clinical diagnosis. Conservative first (4-6 wk) — PT gold standard + NSAIDs + activity mod. Subacromial steroid if persistent. Surgery for refractory or specific tears. Workplace + risk factors. Multidisciplinary.', NULL,
  'easy', 'msk_nontrauma', 'review',
  'family_medicine', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AAOS Rotator Cuff 2019', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 45 ปี — overhead worker — shoulder pain + weakness × 2 mo; positive impingement signs; no trauma'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี runner — heel pain (medial calcaneal) worst with first steps morning + after rest × 3 mo', '[{"label":"A","text":"Surgery first-line"},{"label":"B","text":"Plantar Fasciitis (APTA + AAOS)"},{"label":"C","text":"Long-term opioid"},{"label":"D","text":"Immobilization in cast × 6 wks"},{"label":"E","text":"No treatment — ignore"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Plantar Fasciitis (APTA + AAOS): (1) **Clinical diagnosis**: heel pain medial calcaneal, worst first steps morning + after rest (post-static dyskinesia), insertion of plantar fascia; (2) **Differential**: heel pad atrophy, tarsal tunnel, calcaneal stress fracture (point tender, swelling), nerve entrapment (Baxter''s), seronegative arthropathy, infection; (3) **Imaging usually not needed** initial; X-ray if persistent (rule out fracture, heel spur — spur common in normal, not cause); MRI/US for refractory; (4) **Risk factors**: overuse, weight (obesity), tight Achilles/calf, pes planus or cavus, occupation standing, inappropriate footwear, sudden activity increase, age 40-60; (5) **Conservative management first-line (90%+ resolve within 1 yr)**: - **Stretching**: plantar fascia-specific (toe extension) + Achilles + calf — most evidence; - **Activity modification**: reduce impact, cross-train, return gradually; - **Footwear**: supportive with cushioning, avoid going barefoot/flat; - **OTC arch support / orthotic** (custom usually not needed); - **NSAIDs** short-term; - **Ice massage** after activity; - **Night splints** for refractory (dorsiflexion to maintain stretch); - **PT** — manual therapy, taping, exercise; (6) **Weight loss** if BMI elevated; (7) **Second-line if persistent ≥ 6-12 mo**: - **Corticosteroid injection** US-guided (modest short-term, risk fascia rupture + heel pad atrophy — limit); - **PRP** (platelet-rich plasma) — modest evidence, increasing use; - **ESWT (extracorporeal shock wave)** — moderate evidence; - **Botulinum toxin** — emerging; (8) **Surgery rare** (< 5%): plantar fascia release (open or endoscopic) — only after exhaustive conservative; (9) **Address contributors**: ergonomics, training schedule (runner), shoes; (10) **Patient education + expectations**: 6-18 months recovery common; (11) **Multidisciplinary**: PCP + PT + sports medicine + podiatry + orthopedics if refractory

---

Plantar fasciitis: clinical diagnosis. Conservative first (90%+ resolve): stretching + footwear + activity mod + NSAIDs + PT. Refractory — steroid injection (limit), ESWT, PRP. Surgery rare. Weight, training, ergonomics. Multidisciplinary.', NULL,
  'easy', 'msk_nontrauma', 'review',
  'family_medicine', 'clinical_decision', 'msk_nontrauma', 'adult',
  'APTA Plantar Fasciitis 2014', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี runner — heel pain (medial calcaneal) worst with first steps morning + after rest × 3 mo'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี BMI 33 — bilateral knee pain + crepitus + morning stiffness < 30 min × 1 yr, X-ray joint space narrowing', '[{"label":"A","text":"Long-term opioid"},{"label":"B","text":"Knee OA Management Primary Care (AAOS 2021 + ACR/AF 2019 + OARSI)"},{"label":"C","text":"Arthroscopic debridement for all OA"},{"label":"D","text":"Rest only — avoid exercise"},{"label":"E","text":"Single intervention"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Knee OA Management Primary Care (AAOS 2021 + ACR/AF 2019 + OARSI): (1) **Diagnosis**: clinical + X-ray (joint space narrowing, osteophytes, subchondral sclerosis); MRI usually not needed; rule out inflammatory (RA — symmetric, prolonged morning stiffness, systemic); (2) **Non-pharmacologic FOUNDATION (essential for all)**: - **Weight loss** ≥ 5-10% — each pound reduces 4 lb knee load; most impactful intervention; - **Exercise** (aerobic + strengthening — quadriceps especially) — strong evidence; supervised PT > home alone; aquatic for severe; Tai chi; - **Education** + self-management programs (ACPA, Arthritis Foundation); - **Cane/walking aid** opposite hand; - **Bracing** (medial unloader); - **Footwear** modifications; (3) **Pharmacologic stepwise**: - **Topical NSAIDs** (diclofenac gel) — first-line (less systemic SE, especially elderly + comorbidity); - **Oral NSAIDs** — short course; cautious renal, GI (PPI co-Rx high-risk), CV; consider celecoxib if needed; - **Acetaminophen** — limited efficacy (NEJM, BMJ), but safe adjunct; - **Duloxetine** — chronic OA pain (evidence in chronic MSK pain); - **Capsaicin topical**; - **Avoid opioids** for chronic OA (CDC + ACR/AF 2019 strong against — minimal benefit, significant harm); - **Glucosamine + chondroitin** — controversial, ACR/AF strongly against; - **Hyaluronate intra-articular** — controversial, AAOS recommends against, ACR/AF conditional against; (4) **Intra-articular corticosteroid injection** — modest short-term benefit; ACR/AF strong support; conflicting (small meta-analysis cartilage concern); maximum 3-4/yr; avoid if planning surgery soon; (5) **Surgery** (refractory + significant impairment): - **Total knee arthroplasty (TKA)** — highly effective; eligibility based on symptoms + function not just imaging; bilateral simultaneous vs staged; - Arthroscopic debridement / partial meniscectomy NOT recommended for OA without mechanical symptoms (multiple RCTs negative); (6) **Multimodal**: PT, weight, lifestyle, medication; (7) **Mental health screening** — chronic pain comorbidity; (8) **Multidisciplinary**: PCP + PT/OT + orthopedics + behavioral health + nutritional + community exercise programs

---

Knee OA: weight loss + exercise FOUNDATION. Topical NSAIDs first-line; oral NSAIDs caution; duloxetine + capsaicin; AVOID opioids. Intra-articular steroid short-term. TKA for refractory + impairment. Arthroscopy for OA NOT recommended. Multidisciplinary.', NULL,
  'easy', 'msk_nontrauma', 'review',
  'family_medicine', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AAOS Knee OA 2021; ACR/AF OA 2019', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี BMI 33 — bilateral knee pain + crepitus + morning stiffness < 30 min × 1 yr, X-ray joint space narrowing'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กอายุ 4 ปี — chronic itchy + dry rash + flexural surfaces + family history atopy; failing OTC moisturizers', '[{"label":"A","text":"Long-term high-potency steroid daily"},{"label":"B","text":"Atopic Dermatitis Stepwise (AAD 2014 + AAAAI 2023)"},{"label":"C","text":"Oral steroid burst chronic"},{"label":"D","text":"No moisturizer needed"},{"label":"E","text":"Avoid bathing entirely"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Atopic Dermatitis Stepwise (AAD 2014 + AAAAI 2023): (1) **Diagnosis clinical**: chronic relapsing, pruritus, typical distribution (flexural older), personal/family atopy, age-related distribution; (2) **Severity assessment**: EASI, SCORAD; impact (sleep, school, mental health); (3) **Stepwise approach**: - **Foundation for all**: - **Emollients** — apply liberally + frequently (within 3 min after bath); thick creams/ointments preferred over lotions; - **Bathing**: daily warm short, mild non-soap cleanser, moisturize immediately; bleach baths for recurrent infections (¼ cup bleach in tub); - **Trigger avoidance**: irritants (wool, fragrance, harsh soap), allergens (dust mite, pet, food selective), stress, sweat, climate; - **Education**: chronic condition, flares, written action plan; - **Mild**: low-potency topical steroid (hydrocortisone 1-2.5% face/groin/young children); topical calcineurin inhibitor (tacrolimus, pimecrolimus) — steroid-sparing; - **Moderate (this patient)**: mid-potency topical steroid (triamcinolone 0.1%) extremities + low-potency face; topical calcineurin alternate or maintenance; **proactive therapy** (intermittent 2x/wk steroid/calcineurin to prevent flare); - **Severe / refractory**: - **Topical PDE-4 inhibitor** (crisaborole, roflumilast); - **Topical JAK inhibitor** (ruxolitinib); - **Phototherapy** (NBUVB); - **Systemic** (refer dermatology): - **Dupilumab** (IL-4/13 antibody) — FDA approved ≥ 6 mo; highly effective + safety profile; - Other biologics: tralokinumab (IL-13); nemolizumab (IL-31); - **Oral JAK inhibitors**: abrocitinib, upadacitinib (≥ 12 yo); monitoring; - Cyclosporine, methotrexate, mycophenolate (less used now with biologics); (4) **Treat secondary infection**: bacterial (Staph — topical mupirocin, oral cephalexin), viral (HSV eczema herpeticum — emergency, IV acyclovir), fungal; (5) **Address comorbidity**: asthma, allergic rhinitis, food allergy (referral if severe), mental health (sleep, anxiety, depression), school impact; (6) **Avoid**: chronic high-potency steroid (atrophy, striae), systemic steroid for chronic (rebound), oral antihistamine routinely (limited efficacy beyond sedation); (7) **Allergy testing** selective for moderate-severe; (8) **Multidisciplinary**: PCP + dermatology + allergy + mental health + school nurse

---

Atopic dermatitis: emollient foundation + bathing routine + trigger avoidance. Stepwise topical (low/mid/high potency steroid + calcineurin inhibitor proactive). Severe: dupilumab + JAK + phototherapy. Treat secondary infection. Multidisciplinary.', NULL,
  'medium', 'dermatology', 'review',
  'family_medicine', 'clinical_decision', 'dermatology', 'peds',
  'AAD Atopic Dermatitis 2014; AAAAI 2023', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'เด็กอายุ 4 ปี — chronic itchy + dry rash + flexural surfaces + family history atopy; failing OTC moisturizers'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 35 ปี planning trip ไป sub-Saharan Africa × 4 wk — safari, urban, rural; ไม่ได้ฉีดวัคซีน travel มาก่อน', '[{"label":"A","text":"No preparation needed — wing it"},{"label":"B","text":"Travel Medicine Pre-Travel Visit (CDC Yellow Book + ISTM)"},{"label":"C","text":"Single vaccine for all destinations"},{"label":"D","text":"Antibiotic prophylaxis prevent malaria"},{"label":"E","text":"Avoid all vaccines abroad"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Travel Medicine Pre-Travel Visit (CDC Yellow Book + ISTM): (1) **Pre-travel assessment ideally 4-6 wk prior**: itinerary (countries, regions, urban/rural, duration, season, accommodations, activities), traveler factors (age, comorbidity, pregnancy, immunosuppression, medications, prior travel, vaccines); (2) **Vaccines** (CDC destination-specific): - **Routine update**: Tdap, MMR, polio booster, flu, COVID; - **Required (entry conditions)**: yellow fever (sub-Saharan + S America — single dose lifelong, ICVP certificate; 10-d wait); meningococcal (ACWY for Hajj/Umrah, meningitis belt during dry season); polio (some countries); - **Recommended**: typhoid (oral or injectable, areas with poor sanitation), hepatitis A + B (most travelers), rabies (high-risk activity rural), Japanese encephalitis (rural Asia), cholera (selected — newer Vaxchora oral); (3) **Malaria prevention** (chemoprophylaxis + bite avoidance critical): - Region-specific resistance pattern; CDC malaria map; - **Atovaquone-proguanil** (Malarone) — daily, 1-2 d before + 1 wk after; - **Doxycycline** — daily, cheap, also tick-borne prophylaxis; - **Mefloquine** — weekly; neuropsychiatric SE; - **Chloroquine** (only chloroquine-sensitive areas, increasingly rare); - **Tafenoquine** (Krintafel/Arakoda) — single-dose presumptive therapy + radical cure; - **Primaquine + tafenoquine** — radical cure P. vivax/ovale (G6PD test required first); - **Bite avoidance**: DEET 20-30% / picaridin / IR3535 (apply skin) + permethrin (clothing) + bed nets (permethrin-treated) + air-conditioned/screened rooms; (4) **Traveler''s diarrhea**: food + water safety education (Boil it, cook it, peel it, or forget it); self-treatment kit with antibiotic (azithromycin 500 mg × 1-3 d) + loperamide (mild); avoid FQ in many regions (resistance); ORT; (5) **Other infections**: schistosomiasis (avoid fresh water in Africa), Zika/dengue/chikungunya (mosquito-borne, daytime + nighttime), STIs (condoms), HIV PrEP/PEP, leishmaniasis, tick-borne; (6) **Altitude sickness** (acetazolamide if high altitude travel); (7) **DVT prevention** long flights (mobilization, hydration); (8) **Insurance** travel + medical evacuation; (9) **Personal medications** — letter from physician, original containers, sufficient supply; (10) **Mental health, sun, road safety**; (11) **Post-travel evaluation** if symptoms (fever, diarrhea, rash); (12) **Multidisciplinary**: PCP + travel medicine specialist + pharmacy + CDC Travel website

---

Travel medicine: pre-travel 4-6 wk. Routine + required (yellow fever, meningococcal) + recommended (typhoid, HepA/B, rabies, JE) vaccines. Malaria chemoprophylaxis + bite avoidance. Traveler''s diarrhea self-Rx + food safety. Other risks. Multidisciplinary.', NULL,
  'medium', 'id', 'review',
  'family_medicine', 'clinical_decision', 'id', 'adult',
  'CDC Yellow Book 2024; ISTM', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 35 ปี planning trip ไป sub-Saharan Africa × 4 wk — safari, urban, rural; ไม่ได้ฉีดวัคซีน travel มาก่อน'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 40 ปี construction worker — acute LBP after lifting at work; ขอใบลา + workers'' compensation', '[{"label":"A","text":"Total disability — no return to work"},{"label":"B","text":"Workplace Injury + Occupational Medicine"},{"label":"C","text":"Long-term opioid for pain"},{"label":"D","text":"Imaging immediately for all"},{"label":"E","text":"Ignore workers'' comp"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Workplace Injury + Occupational Medicine: (1) **Initial assessment**: thorough history (mechanism, prior injuries, work demands), full exam, red flags (cauda equina, fracture); X-ray only if red flags or significant trauma; (2) **Workers'' Compensation system understanding**: - Documentation: mechanism + work-relatedness + functional impact + impairment; - Maximum medical improvement (MMI), impairment rating, return-to-work status; - State-specific regulations + insurance carriers; - Communication with employer + insurer; (3) **Treatment LBP** per ACP (similar to non-occupational): - Activity modification (modified duty better than total off); - NSAIDs; - Heat; - Exercise + PT (early); - Education (favorable prognosis); - Avoid opioids (CDC + ACOEM); - Avoid prolonged bed rest; - Acupuncture, manipulation acceptable; (4) **Return-to-work (RTW) approach**: - **Modified duty / restricted work** preferred over total disability (faster recovery + return); - Specific restrictions (lifting limit, posture, frequency); - Graded RTW progression; - Functional capacity evaluation (FCE) if persistent; - Vocational rehab if cannot return to original job; (5) **Workplace assessment**: ergonomic evaluation, training, prevention of recurrence; OSHA + employer responsibility; (6) **Psychosocial assessment** — Yellow Flags for chronicity: belief work harmful, fear-avoidance, depression, distress, job dissatisfaction, secondary gain, system distrust, prolonged disability; CBT for chronic; (7) **Workers'' comp + disability** specific considerations + advocacy; (8) **Coordination with employer**: confidentiality (limited in WC), education, accommodations, return-to-work planning; (9) **Prevention**: ergonomics, training, lifting techniques, equipment, regular health surveillance; (10) **Other occupational considerations**: hearing conservation, respiratory protection, ergonomics, mental health, shift work, toxic exposures, infection control (healthcare); (11) **Multidisciplinary**: PCP + occupational medicine + PT + ergonomist + employer + insurance + behavioral health (if yellow flags) + vocational rehab

---

Workplace LBP: same evidence-based treatment as non-occupational — early activity + PT + NSAIDs, avoid opioids. **Modified duty + RTW** preferred. Functional restrictions. Address yellow flags (chronicity). Workers'' comp documentation. Ergonomic prevention. Multidisciplinary.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'family_medicine', 'clinical_decision', 'msk_nontrauma', 'adult',
  'ACOEM Guidelines; ACP LBP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 40 ปี construction worker — acute LBP after lifting at work; ขอใบลา + workers'' compensation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี smoker 30 pack-years — past failed attempts NRT patch + cold turkey; ขอ med ที่ effective ที่สุด', '[{"label":"A","text":"NRT patch alone — same as before"},{"label":"B","text":"Smoking Cessation Pharmacotherapy Selection (USPSTF + AAFP + EAGLES)"},{"label":"C","text":"Long-term opioid for cravings"},{"label":"D","text":"Single counseling session"},{"label":"E","text":"No medication ever"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Smoking Cessation Pharmacotherapy Selection (USPSTF + AAFP + EAGLES): (1) **Combination most effective**: pharmacotherapy + behavioral; both individually ↑ cessation but combination doubles; (2) **First-line pharmacotherapy options**: - **Varenicline (Chantix)** — most effective single agent + (a4b2 nicotinic partial agonist); start 1 wk before quit date; titrate up over 1 wk; continue 12-24 wk; **EAGLES trial** — cardiovascular + neuropsychiatric safety reaffirmed (Black Box warning removed); FDA reapproved 2016; recently temporarily off market (nitrosamine impurity 2021) — now available again; - **NRT (Nicotine Replacement Therapy)**: combination patch (long-acting baseline) + short-acting (gum, lozenge, inhaler, spray for cravings) — more effective than single; OTC; safer than smoking; - **Bupropion (Zyban/Wellbutrin SR)** 150 mg BID; start 1-2 wk before quit; dual benefit if depression; CI seizure disorder, eating disorder; - **Combination varenicline + NRT** — emerging evidence; - **Combination bupropion + NRT** — also effective; (3) **Second-line / alternatives**: nortriptyline, clonidine (off-label); (4) **Cytisine** — partial agonist (like varenicline); cheaper; available in some countries; (5) **E-cigarettes**: mixed evidence; UK NICE supports as cessation aid; US position more cautious (FDA not approved as cessation); some evidence (~ 18% vs 9.9% NRT cessation in Cochrane review); youth concerns, EVALI risk; (6) **Behavioral support critical**: brief counseling at every visit (5As); quitline 1-800-QUIT-NOW; text-based (SmokefreeTXT); apps; in-person counseling; group programs; (7) **Address triggers**: stress (mindfulness, CBT), alcohol, social, mental health (depression high comorbidity); (8) **Relapse common — multiple attempts typical**; don''t discourage; (9) **Special populations**: pregnant (behavioral first; NRT if needed; varenicline + bupropion limited data), cardiovascular (varenicline + NRT safe per EAGLES + meta-analyses), mental health (varenicline + bupropion safety reaffirmed EAGLES), opioid/methadone, adolescents (limited pharm — behavioral + NRT cautious); (10) **Cost**: many insurance covers; generic; manufacturer assistance; (11) **Multidisciplinary**: PCP + pharmacy + tobacco treatment specialist + quitline + behavioral health

---

Smoking cessation: combination > monotherapy. Varenicline most effective single (EAGLES safe). Combination NRT (patch + short-acting). Bupropion + NRT also effective. Behavioral critical. Address triggers + comorbidity. Multiple attempts common.', NULL,
  'easy', 'psych_behavior', 'review',
  'family_medicine', 'clinical_decision', 'psych_behavior', 'adult',
  'USPSTF Tobacco 2021; EAGLES', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี smoker 30 pack-years — past failed attempts NRT patch + cold turkey; ขอ med ที่ effective ที่สุด'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี — fatigue + weight gain + constipation + cold intolerance; TSH 12.8, free T4 0.7 (low)', '[{"label":"A","text":"Start T3 alone — no levothyroxine"},{"label":"B","text":"Hypothyroidism Management (ATA + AACE 2014 + 2022)"},{"label":"C","text":"Treat all subclinical with TSH 6"},{"label":"D","text":"No treatment — wait"},{"label":"E","text":"Long-term steroid for thyroid"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hypothyroidism Management (ATA + AACE 2014 + 2022): (1) **Diagnosis**: overt — TSH ↑ + free T4 ↓; subclinical — TSH ↑ + free T4 normal; (2) **Etiology workup**: anti-TPO antibody (Hashimoto''s = most common in iodine-sufficient areas); other causes: post-radioactive iodine, post-thyroidectomy, central (rare — TSH normal/low + T4 low), drugs (amiodarone, lithium, immune checkpoint inhibitors), congenital, iodine deficiency; (3) **Treatment overt hypothyroidism**: - **Levothyroxine** weight-based 1.6 mcg/kg/d in healthy; lower in elderly, CAD, frail (start 25-50 mcg, titrate); - Take fasting, 30-60 min before breakfast OR bedtime ≥ 3 h after last meal; consistent timing; - Separate from Ca, iron, PPI, soy, fiber (absorption); separate from levothyroxine 4 h; - Recheck TSH 6-8 wk after initiation/dose change; target TSH 0.5-2.5 most (slightly higher in elderly); - Brand vs generic: bioequivalence variable — stick to same; (4) **Subclinical hypothyroidism**: - Treat if TSH > 10, symptoms, positive antibodies + planning pregnancy, infertility; - Observation reasonable < 10 + asymptomatic; (5) **Pregnancy**: - Pre-pregnancy optimize TSH < 2.5; - During pregnancy ↑ dose ~ 30% (more thyroid demand); - Trimester-specific TSH ranges; (6) **Older adults**: less aggressive — TSH 4-6 acceptable; avoid overtreatment (AFib, osteoporosis, mortality); (7) **Treatment failure / persistent symptoms despite normalized TSH**: assess adherence, absorption (celiac, atrophic gastritis, PPI), other causes (depression, sleep apnea, anemia, polycystic); T3 addition controversial — most evidence shows no benefit (selected may try liothyronine combination); (8) **Myxedema coma** rare emergency — IV levothyroxine + T3 + steroid; (9) **Monitor**: TSH q 6-12 mo when stable; (10) **Multidisciplinary**: PCP + endocrine if complex / pregnancy / refractory

---

Hypothyroidism: TSH ↑ + T4 ↓ overt; levothyroxine weight-based fasting consistent timing. Recheck 6-8 wk. Subclinical — treat if TSH > 10 / sx / pregnancy. Elderly less aggressive. Pregnancy ↑ dose. Multidisciplinary.', NULL,
  'easy', 'endocrine_metabolic', 'review',
  'family_medicine', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'ATA Hypothyroidism 2014; AACE 2022', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี — fatigue + weight gain + constipation + cold intolerance; TSH 12.8, free T4 0.7 (low)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิงอายุ 35 ปี — palpitations + weight loss + heat intolerance + tremor + diffuse goiter + mild ophthalmopathy; TSH < 0.01, T4 ↑, T3 ↑; TRAb positive', '[{"label":"A","text":"No treatment — self-resolves"},{"label":"B","text":"Graves Disease Management (ATA 2016)"},{"label":"C","text":"Levothyroxine for hyperthyroid"},{"label":"D","text":"Beta-blocker alone long-term"},{"label":"E","text":"Surgery first-line for all"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Graves Disease Management (ATA 2016): (1) **Diagnosis**: clinical + TSH suppressed + T4/T3 ↑ + TRAb (TSI) positive; thyroid US — diffuse vascular goiter; RAIU if uncertain (↑ uniform); (2) **3 main treatment options — patient preference + factors**: - **Antithyroid drugs (ATDs)** — first-line many, especially mild + young + small goiter + planning pregnancy: - **Methimazole (MMI)** preferred — 5-30 mg daily; LFT + CBC baseline + as needed; ~ 50% remission after 12-18 mo (continue ≥ 12 mo before considering taper); - **PTU** for 1st trimester pregnancy (MMI teratogen 1st trim — aplasia cutis), thyroid storm; hepatotoxicity higher; - SE: rash, hepatitis (PTU), agranulocytosis (RARE — STOP for fever/sore throat → CBC), arthralgia; - **Radioactive iodine (RAI)** — definitive, simple outpatient; CI in pregnancy + lactation + young children + severe orbitopathy (may worsen); usually leads to hypothyroidism → lifelong levothyroxine; - **Thyroidectomy** — definitive, for large goiter, suspicious nodules, severe orbitopathy, pregnancy 2nd trim if needed, patient preference; risk recurrent laryngeal nerve + hypoparathyroidism; experienced surgeon; (3) **Symptom management**: **beta-blocker (propranolol, atenolol)** for tachycardia, tremor, anxiety; (4) **Graves orbitopathy management**: refer ophthalmology; smoking cessation critical (worsens); IV steroids for moderate-severe active; **teprotumumab** (Tepezza — IGF-1R antibody) FDA-approved 2020 — game changer; orbital radiation, decompression surgery selected; (5) **Pregnancy**: PTU 1st trimester, MMI 2nd-3rd; close monitoring; (6) **Thyroid storm**: emergency — ICU; beta-blocker, PTU, iodine, steroid, supportive; (7) **Monitor**: TFT q 4-6 wk during titration, q 3-6 mo stable; TRAb if considering ATD withdrawal; (8) **Multidisciplinary**: PCP + endocrine + nuclear medicine + ENT/surgery + ophthalmology + smoking cessation

---

Graves: TSH ↓ + T4/T3 ↑ + TRAb +. 3 options: ATD (MMI; PTU 1st trim) / RAI / surgery — based on factors. Beta-blocker for sx. Orbitopathy — smoking cessation + steroid + teprotumumab. Pregnancy considerations. Multidisciplinary.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'family_medicine', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'ATA Hyperthyroidism 2016', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยหญิงอายุ 35 ปี — palpitations + weight loss + heat intolerance + tremor + diffuse goiter + mild ophthalmopathy; TSH < 0.01, T4 ↑, T3 ↑; TRAb positive'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี — heartburn + regurgitation × 3 wk, no alarm symptoms; BMI 32', '[{"label":"A","text":"Long-term PPI without lifestyle"},{"label":"B","text":"GERD Management (ACG 2022)"},{"label":"C","text":"Surgery first-line for typical GERD"},{"label":"D","text":"Antacid PRN only for chronic"},{"label":"E","text":"No treatment for moderate symptoms"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** GERD Management (ACG 2022): (1) **Diagnosis**: clinical with typical symptoms (heartburn, regurgitation); rule out alarm symptoms (dysphagia, odynophagia, weight loss, anemia, hematemesis, melena, vomiting) → EGD; (2) **EGD indications**: alarm symptoms, refractory PPI, > 50 yo first onset, Barrett''s surveillance, screening high-risk (chronic GERD + 2 risk factors — white male > 50, obese, smoker, family history); (3) **Lifestyle modification (foundation)**: - Weight loss (most impactful in obese — strong evidence); - Elevate head of bed 6-8 inches (gravity); - Avoid late meals (< 3 h before bed); - Smaller meals; - Avoid trigger foods individually (spicy, fatty, citrus, mint, chocolate, caffeine, alcohol — variable); - Smoking cessation; - Loose clothing; (4) **Pharmacotherapy stepwise**: - **PPI standard dose × 8 wk** — first-line (omeprazole 20-40, esomeprazole, pantoprazole, lansoprazole); take 30-60 min before breakfast; - **H2RA** (famotidine) — alternative; less effective; tachyphylaxis; useful for nocturnal breakthrough or maintenance; - **Antacid** symptomatic only; - **Step-down approach** — once controlled, reduce to lowest effective dose, PRN, or discontinue; - **Refractory** (despite optimized PPI): - Compliance + timing check; - Switch PPI brand; - BID dosing; - Add H2RA at bedtime; - Refer GI — pH-impedance testing, manometry, consider P-CAB (potassium-competitive acid blocker — vonoprazan FDA-approved 2022); (5) **Long-term PPI considerations**: - Generally safe; - Possible associations (low quality): CKD, fracture, dementia, infections (C diff, pneumonia), hypomagnesemia, B12 deficiency, gastric polyps — discuss but don''t deprive when indicated; - Minimum effective dose; (6) **Anti-reflux surgery** (Nissen fundoplication, magnetic sphincter augmentation — LINX) for: refractory + objective reflux + non-acid reflux predominant + young, regurgitation predominant; less common with effective PPIs; (7) **Barrett''s surveillance**: q 3-5 yr based on dysplasia; (8) **Multidisciplinary**: PCP + GI + nutritionist + surgery selected

---

GERD: lifestyle (weight, HOB, late meals) + PPI 8 wk first-line. EGD for alarms / refractory / Barrett''s screen. H2RA + antacid roles. Refractory — GI eval. Long-term PPI generally safe. Surgery selective. Multidisciplinary.', NULL,
  'easy', 'signs_symptoms', 'review',
  'family_medicine', 'clinical_decision', 'signs_symptoms', 'adult',
  'ACG GERD 2022', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี — heartburn + regurgitation × 3 wk, no alarm symptoms; BMI 32'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี — dyspepsia + EGD พบ gastric ulcer + biopsy positive H. pylori', '[{"label":"A","text":"No treatment — bacteria normal"},{"label":"B","text":"H. pylori Eradication (ACG 2017 + Maastricht VI 2022)"},{"label":"C","text":"Short 3-day course"},{"label":"D","text":"Single antibiotic alone"},{"label":"E","text":"Surgery for ulcer first"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** H. pylori Eradication (ACG 2017 + Maastricht VI 2022): (1) **Testing indications**: PUD, MALT lymphoma, atrophic gastritis, gastric cancer family history, post-gastric cancer resection, uninvestigated dyspepsia in low-risk, before long-term NSAID/aspirin (selected), iron-deficiency anemia unexplained, ITP, vitamin B12 deficiency unexplained; (2) **Testing methods**: - **Non-invasive**: urea breath test, stool antigen — first choice non-EGD; serology — has been used but cannot distinguish current vs past; - **Invasive (EGD)**: rapid urease test, histology, culture; - Hold PPI ≥ 1-2 wk + antibiotic ≥ 4 wk before testing (false neg); (3) **Treatment** — empiric based on local resistance: - **Bismuth quadruple × 14 d** (preferred first-line per ACG 2017 + Maastricht VI in areas with clarithromycin resistance > 15%): PPI BID + bismuth + tetracycline + metronidazole; - **Clarithromycin-based triple** × 14 d (PPI + amox + clarithro) — only if local clarithro resistance < 15% AND no prior macrolide exposure; - **Levofloxacin triple** × 10-14 d (PPI + amox + levo) — alternative; - **Concomitant** quadruple (PPI + amox + clarithro + metronidazole) × 10-14 d; - **Rifabutin triple** (rifabutin + amox + omeprazole — Talicia) salvage; - Vonoprazan-amox dual / triple emerging; (4) **Test of cure** ≥ 4 wk after completing therapy + ≥ 1-2 wk off PPI — urea breath test or stool antigen (NOT serology); (5) **Treatment failure** ~ 20-30%: use different regimen (avoid prior abx); resistance testing if available; (6) **Counseling**: complete full course; SE warning (taste, GI); confirm cure (PUD risk reduction); (7) **Family considerations**: gastric cancer family history — discuss screening; (8) **Multidisciplinary**: PCP + GI

---

H. pylori PUD: bismuth quadruple × 14 d first-line (or clarithro triple if local resist < 15%). Hold PPI/abx before testing. Test of cure 4 wk post-tx (UBT or stool Ag, not serology). Treatment failure — different regimen.', NULL,
  'medium', 'id', 'review',
  'family_medicine', 'clinical_decision', 'id', 'adult',
  'ACG H. pylori 2017; Maastricht VI 2022', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี — dyspepsia + EGD พบ gastric ulcer + biopsy positive H. pylori'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 30 ปี — recurrent abdominal pain + altered bowel habits (diarrhea predominant) × 6 mo, no alarm features, normal physical exam, normal labs', '[{"label":"A","text":"Repeat colonoscopy q 6 mo"},{"label":"B","text":"IBS Management (ACG 2021 + Rome IV)"},{"label":"C","text":"Single antibiotic course indefinitely"},{"label":"D","text":"Ignore — psychological only"},{"label":"E","text":"Long-term opioid"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** IBS Management (ACG 2021 + Rome IV): (1) **Diagnosis Rome IV**: recurrent abdominal pain ≥ 1 d/wk in past 3 mo + ≥ 2 of: related to defecation, change in frequency, change in form; (2) **Subtypes by Bristol stool**: IBS-D (diarrhea), IBS-C (constipation), IBS-M (mixed), IBS-U (unsubtyped); (3) **Workup limited if no alarms**: - CBC, CRP/ESR; - Celiac serology (tTG-IgA); - Stool studies if diarrhea (Giardia, infection); - **Calprotectin** — to rule out IBD; - **No routine colonoscopy** if no alarms + age < 45 (or 50); - Lactose breath test if suspected; (4) **Patient education** — chronic relapsing, gut-brain disorder, not progressive, not life-threatening; therapeutic relationship key; (5) **Dietary**: - **Low FODMAP diet** (with dietitian) — strong evidence for symptom improvement, especially IBS-D; structured elimination + reintroduction; - Soluble fiber (psyllium) — IBS-C and some IBS-D; - Avoid trigger foods individual; - Gluten-free trial selected (non-celiac gluten sensitivity overlap); (6) **Pharmacotherapy by subtype**: - **IBS-D**: - Loperamide for diarrhea; - **Rifaximin** 550 mg TID × 14 d (TARGET trials); can repeat 2 more cycles if symptomatic recurrence; - **Eluxadoline** (Viberzi) — mixed mu/kappa; CI no gallbladder or alcohol; - **Alosetron** (5HT3 antagonist) — restricted; - TCA low-dose (amitriptyline, nortriptyline) — visceral pain modulation + sleep; - **IBS-C**: - PEG; - **Linaclotide, plecanatide** (guanylate cyclase agonists); - **Lubiprostone** (chloride channel activator); - **Tenapanor** (NHE3 inhibitor) — newer; - SSRI; - Prucalopride (5HT4 agonist) selected; (7) **Behavioral therapy**: CBT, gut-directed hypnotherapy — strong evidence; mindfulness; (8) **Probiotics** — limited evidence overall; specific strains may help; (9) **Address psychosocial**: stress, anxiety, depression, trauma, FODMAP triggers; (10) **Mental health screening + collaborative care**; (11) **Multidisciplinary**: PCP + GI + dietitian + behavioral health

---

IBS: Rome IV diagnosis + limited workup (no alarms). Education + dietary (low FODMAP, fiber). Subtype-specific pharm (IBS-D — rifaximin/loperamide/TCA; IBS-C — PEG/linaclotide). Behavioral therapy strong evidence. Address psychosocial. Multidisciplinary.', NULL,
  'medium', 'signs_symptoms', 'review',
  'family_medicine', 'clinical_decision', 'signs_symptoms', 'adult',
  'ACG IBS 2021; Rome IV', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 30 ปี — recurrent abdominal pain + altered bowel habits (diarrhea predominant) × 6 mo, no alarm features, normal physical exam, normal labs'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 40 ปี — leg redness + warmth + swelling × 2 d after minor scratch, no purulent drainage, no abscess, no fever; stable vitals', '[{"label":"A","text":"Empiric IV vancomycin for all cellulitis"},{"label":"B","text":"Cellulitis Outpatient Management (IDSA SSTI 2014)"},{"label":"C","text":"MRI all cellulitis"},{"label":"D","text":"No antibiotic — observe"},{"label":"E","text":"Hospitalize all cellulitis"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cellulitis Outpatient Management (IDSA SSTI 2014): (1) **Diagnosis clinical**: erythema + warmth + edema + tenderness; mark borders; demarcate; (2) **Differentiate**: - **Non-purulent cellulitis** (this patient) — typically beta-hemolytic strep (GAS, GBS) and MSSA; - **Purulent cellulitis / abscess** — typically MRSA; I&D first; abx if larger; - **Mimics**: DVT, stasis dermatitis, contact dermatitis, gout, erysipelas (more raised + sharp border — strep), necrotizing fasciitis (severe pain out of proportion, crepitus, hemorrhagic bullae — surgical emergency); (3) **Severity classification**: - **Mild** (this patient — afebrile, stable, no comorbidity) — outpatient oral; - **Moderate** — systemic signs, more extensive — outpatient IV or hospitalization; - **Severe** — sepsis, deep infection, fail outpatient — admit IV; (4) **Outpatient antibiotic for non-purulent cellulitis** (cover strep ± MSSA): - **Cephalexin 500 mg QID × 5-10 d** (5 days often sufficient — DICTATES study); or - **Dicloxacillin** 500 mg QID; or - **Penicillin V** 500 mg QID if clear strep; - **PCN allergy**: clindamycin 300-450 mg QID, doxycycline; - **MRSA coverage** (purulent or risk factors): TMP-SMX, doxycycline, clindamycin; (5) **Adjuncts**: - Elevation of affected limb; - Mark borders + reassess 24-48 h; - Cool compresses; - Treat tinea pedis (common entry); skin care; - Address venous insufficiency, lymphedema (recurrence prevention); (6) **Hospital admission indications**: severe systemic signs, immunocompromised, rapid progression, failed outpatient, suspect necrotizing fasciitis (URGENT surgery + IV abx), facial cellulitis (esp orbital), special hosts; (7) **Follow-up 24-72 h**: expect improvement; worsening → re-evaluate (abscess, resistant, alternative diagnosis); (8) **Recurrence prevention**: treat predisposing (tinea, venous, lymphedema); long-term prophylaxis (penicillin) for frequent recurrences; (9) **Multidisciplinary**: PCP + ID/dermatology + vascular if venous + surgery if necrotizing

---

Non-purulent cellulitis: clinical diagnosis, mark borders. Cephalexin (strep ± MSSA) 5-10 d outpatient if mild. Cover MRSA only if purulent / risk factors. Address entry (tinea), elevation. Watch necrotizing fasciitis. Follow-up 24-72 h.', NULL,
  'easy', 'id', 'review',
  'family_medicine', 'clinical_decision', 'id', 'adult',
  'IDSA SSTI 2014', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 40 ปี — leg redness + warmth + swelling × 2 d after minor scratch, no purulent drainage, no abscess, no fever; stable vitals'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี HTN — acute monoarthritis of 1st MTP joint, red + hot + extremely tender × 1 d; serum uric acid 9.8; first episode', '[{"label":"A","text":"Allopurinol during acute attack alone"},{"label":"B","text":"Acute Gout + Long-term Management (ACR 2020)"},{"label":"C","text":"Long-term opioid for gout pain"},{"label":"D","text":"No treatment — self-resolves"},{"label":"E","text":"Surgery for tophi only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Gout + Long-term Management (ACR 2020): (1) **Acute attack diagnosis**: classic (1st MTP — podagra), monoarthritis, rapid onset, red/hot/tender; gold standard = joint aspiration + monosodium urate crystals (negatively birefringent needles) under polarized light; uric acid often elevated but may be normal during attack; rule out septic arthritis (always consider with monoarthritis — culture); (2) **Acute treatment** (start ASAP, within 24 h best): - **NSAIDs** (naproxen 500 BID, indomethacin, ibuprofen) — first-line if no CI; consider PPI; - **Colchicine** (1.2 mg → 0.6 mg in 1 h → 0.6 mg BID-TID until resolved; max ~ 5-7 d) — best within 24 h of onset; less effective if delayed; dose-reduce in CKD; - **Corticosteroid** (prednisone 30-40 mg taper over 7-10 d) — first-line if NSAID/colchicine CI (CKD, GI bleed, anticoagulation, HF); intra-articular for single joint; IM as alternative; - **IL-1 inhibitor** (anakinra, canakinumab) for refractory or contraindications to others; - Combination therapy for severe (NSAID + colchicine or steroid + colchicine); - Don''t start/stop urate-lowering during acute (but continue if already on); (3) **Long-term urate-lowering therapy (ULT)** indications (ACR 2020): - ≥ 2 attacks/yr; - Tophi; - Radiographic damage; - Stage 3 CKD; - Uric acid > 9; - Discuss with first attack + risk factors; (4) **ULT options**: - **Allopurinol first-line** — start 100 mg/d (50 if CKD), titrate q 2-5 wk to uric acid < 6 (< 5 if tophi); HLA-B*5801 testing in Asian (esp Han Chinese, Korean, Thai) + African — severe hypersensitivity (SJS/TEN) risk; - **Febuxostat** alternative; CV warning (FDA 2019 — black box vs allopurinol — CARES trial); - **Probenecid** uricosuric (CI overproducers, kidney stones, CKD); - **Pegloticase** (uricase IV) — refractory + tophaceous; - **ULT initiation during acute attack OK** (modern recommendation, with anti-inflammatory bridge — colchicine 0.6 mg daily or low-dose NSAID/steroid × 3-6 mo while titrating ULT — prevents paradoxical flares); (5) **Lifestyle**: weight loss, alcohol limit (especially beer, spirits), purine moderation (red meat, organ, shellfish), low-fructose, dairy + cherries beneficial, hydration; (6) **Address comorbidities** (high CV risk): HTN — losartan + amlodipine preferred (uric acid neutral), DM, lipid, CKD, NAFLD; AVOID — thiazide, loop diuretic, low-dose aspirin (raise uric acid); (7) **Patient education**: chronic disease, attack action plan, ULT adherence; (8) **Multidisciplinary**: PCP + rheumatology if refractory + nutrition

---

Gout: acute — NSAID/colchicine/steroid (start < 24 h). Joint aspiration if uncertain. Long-term ULT (allopurinol — HLA-B*5801 high-risk pop; febuxostat alt) — start during attack OK with anti-inflam bridge. Target uric acid < 6. Lifestyle + CV risk + meds.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'family_medicine', 'clinical_decision', 'msk_nontrauma', 'adult',
  'ACR Gout 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี HTN — acute monoarthritis of 1st MTP joint, red + hot + extremely tender × 1 d; serum uric acid 9.8; first episode'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 45 ปี — bilateral symmetric MCP + PIP joint pain + morning stiffness > 1 h × 6 wk; positive RF + anti-CCP; ESR 55', '[{"label":"A","text":"Long-term NSAIDs alone"},{"label":"B","text":"Rheumatoid Arthritis Initial Management (ACR 2021)"},{"label":"C","text":"Steroid monotherapy long-term"},{"label":"D","text":"Wait 1 yr before DMARD"},{"label":"E","text":"No treatment until severe deformity"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Rheumatoid Arthritis Initial Management (ACR 2021): (1) **Diagnosis** — ACR/EULAR 2010 criteria; clinical + serology (RF, anti-CCP) + acute phase + duration; (2) **Workup**: CBC, LFT, Cr, hepatitis B+C, TB screen, CXR; pregnancy if applicable; (3) **Refer rheumatology urgently** — early initiation of DMARD (within 3 mo) — improves outcomes, prevents joint damage (window of opportunity); (4) **Treatment principle: treat-to-target** (remission or low disease activity); monitor disease activity (CDAI, DAS28) regularly + escalate as needed; (5) **DMARDs**: - **Methotrexate first-line** (csDMARD) — start 7.5-15 mg/wk + folate 1 mg/d (or 5 mg/wk); titrate to 20-25 mg/wk; SC if oral GI intolerance or insufficient; baseline + monitoring CBC, LFT, Cr; avoid alcohol; - **Hydroxychloroquine** mild disease or combination; baseline + annual eye exam (retinopathy); - **Sulfasalazine** alternative; - **Leflunomide** alternative; - **Triple therapy** (MTX + HCQ + SSZ) for inadequate MTX response; (6) **Biologics + JAK inhibitors (b/tsDMARDs)** for MTX-inadequate response: - **TNF inhibitors** (adalimumab, etanercept, infliximab, golimumab, certolizumab) — first-line biologic; - **Non-TNF biologics**: IL-6 (tocilizumab, sarilumab), B-cell (rituximab), T-cell (abatacept); - **JAK inhibitors** (tofacitinib, baricitinib, upadacitinib) — Boxed warning for CV + cancer (ORAL Surveillance) — secondary now in many; - Screen + treat latent TB before biologics; - Hepatitis B screening + prophylaxis; - Live vaccines avoid on biologics; (7) **Bridging therapy**: low-dose corticosteroid (prednisone 5-10 mg or intra-articular) for symptom control during DMARD onset; taper ASAP; avoid chronic; (8) **NSAIDs** for symptoms — adjunct; cautious CV + GI + renal; (9) **Comorbidities**: CV risk ↑ (treat aggressively), depression, osteoporosis (steroid + disease), interstitial lung disease screen; (10) **Vaccinations**: pneumococcal, flu, COVID, shingles (Shingrix recombinant OK), HPV — update before immunosuppression ideally; (11) **Lifestyle**: exercise, smoking cessation (worsens RA + decreases response), Mediterranean diet, weight; (12) **Patient education**: chronic disease, adherence, infection signs; (13) **Multidisciplinary**: PCP + rheumatology + PT/OT + orthopedic + ophthalmology (HCQ) + behavioral health + cardiac

---

RA: early DMARD critical (window of opportunity). MTX first-line + folate. Hydroxychloroquine + SSZ + leflunomide alternatives. Biologics/JAK for refractory. Treat-to-target. Steroid bridge. CV/osteoporosis/lung screening. Vaccines. Multidisciplinary.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'family_medicine', 'clinical_decision', 'msk_nontrauma', 'adult',
  'ACR RA 2021', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 45 ปี — bilateral symmetric MCP + PIP joint pain + morning stiffness > 1 h × 6 wk; positive RF + anti-CCP; ESR 55'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชายอายุ 65 ปี — LUTS (urgency + frequency + nocturia 3x + weak stream) × 1 yr; AUA-SI 18 (moderate-severe); no hematuria; PSA 3.2', '[{"label":"A","text":"Surgery first-line for moderate BPH"},{"label":"B","text":"BPH Management (AUA + Canadian Urological Association)"},{"label":"C","text":"Long-term Foley catheter"},{"label":"D","text":"Anticholinergic for retention"},{"label":"E","text":"No treatment ever"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** BPH Management (AUA + Canadian Urological Association): (1) **Evaluation**: AUA-SI (Symptom Index) score (mild < 8, moderate 8-19, severe 20-35); history including red flags (hematuria, retention, recurrent UTI, stones, CKD), digital rectal exam (size + nodularity), urinalysis, PSA (with shared decision discussion), Cr; uroflowmetry, post-void residual (PVR), US optional; (2) **Rule out**: prostate cancer (PSA + DRE — shared decision), bladder cancer, overactive bladder, stricture, urinary tract infection, medication causes (anticholinergic, sympathomimetic), neuro causes, polyuria; (3) **Behavioral / lifestyle (mild + moderate)**: - Limit fluids before bed; - Avoid caffeine + alcohol (especially evening); - Double voiding; - Avoid anticholinergics, decongestants; - Bladder training (timed voiding); - Pelvic floor exercises; - Weight loss; (4) **Pharmacotherapy moderate-severe**: - **Alpha-1 blockers** (tamsulosin, alfuzosin, silodosin, doxazosin, terazosin) — first-line; relax smooth muscle; rapid effect; SE: orthostatic hypotension, ejaculatory dysfunction; non-selective (doxazosin) — BP-lowering; floppy iris syndrome (alert ophthalmology before cataract surgery); - **5-alpha reductase inhibitors (5-ARI)** (finasteride, dutasteride) — shrink prostate; for larger prostates (> 40 g); slow effect (6+ mo); SE: sexual dysfunction (libido, ED, ejaculatory), depression rare; lowers PSA ~ 50% (multiply x 2 for interpretation); - **Combination** (alpha + 5-ARI) — CombAT trial; for moderate-severe + large prostate; better than monotherapy; - **Anticholinergic / beta-3 agonist** (mirabegron) — for irritative symptoms + low PVR; - **PDE5 inhibitor** (tadalafil 5 mg daily) — for BPH + ED — dual benefit; (5) **Surgical / procedural** for refractory + complications: - **TURP** (transurethral resection) — gold standard; - **HoLEP** (Holmium laser enucleation), **GreenLight laser** — alternatives; - **Minimally invasive**: UroLift (prostatic urethral lift), Rezum (water vapor), iTind, Aquablation, prostatic artery embolization; - Open / robotic simple prostatectomy for very large; (6) **Complications watch**: urinary retention, recurrent UTI, hematuria, bladder stones, hydronephrosis, AKI; (7) **Multidisciplinary**: PCP + urology referral for refractory / complications / surgical candidate

---

BPH: AUA-SI severity. Behavioral + medical first. Alpha-blocker first-line moderate-severe. 5-ARI for large prostate. Combination for both. PDE5 if also ED. Mirabegron irritative. Surgical for refractory. Multidisciplinary.', NULL,
  'medium', 'signs_symptoms', 'review',
  'family_medicine', 'clinical_decision', 'signs_symptoms', 'adult',
  'AUA BPH 2023', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยชายอายุ 65 ปี — LUTS (urgency + frequency + nocturia 3x + weak stream) × 1 yr; AUA-SI 18 (moderate-severe); no hematuria; PSA 3.2'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชายอายุ 55 ปี HTN + DM + smoker — gradual decrease in erection × 1 yr; embarrassed', '[{"label":"A","text":"Ignore — not important"},{"label":"B","text":"Erectile Dysfunction (ED) Evaluation + Management (AUA + ISSM)"},{"label":"C","text":"Testosterone for all ED"},{"label":"D","text":"Surgery first-line for all"},{"label":"E","text":"Long-term opioid for relationship issues"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Erectile Dysfunction (ED) Evaluation + Management (AUA + ISSM): (1) **ED as window to systemic disease** — strong marker of CV disease, often precedes by 3-5 yr; comprehensive CV evaluation + risk modification; (2) **History + exam**: onset, progression, situational (psychogenic) vs all settings (organic), morning erections (preserved suggests psychogenic), medications, comorbidities, partner factors, mental health, sexual orientation/identity, substance use; testicular + genital exam; (3) **Workup**: testosterone (total + free if low; AM); fasting glucose / A1c; lipids; TSH if indicated; prolactin if low T; (4) **Comprehensive CV risk evaluation + management** — HT, lipid, DM control, smoking cessation; ASCVD calculator; exercise; (5) **First-line: PDE5 inhibitors** (highly effective ~ 70%): - **Sildenafil** (Viagra) — 25-100 mg PRN 1 h before; with empty stomach better; - **Tadalafil** (Cialis) — 5-20 mg PRN or **5 mg daily** (also BPH dual benefit); long half-life 36 h; food-independent; - **Vardenafil**, avanafil alternatives; - **Absolute CI**: concurrent nitrates (life-threatening hypotension), severe hypotension; - Caution: alpha-blockers (lower dose), CYP3A4 interactions, retinitis pigmentosa; - Side effects: headache, flushing, dyspepsia, blue vision (sildenafil), rare priapism > 4 h emergency; (6) **Address medications causing ED**: SSRI (bupropion alternative), beta-blocker (except nebivolol/carvedilol), thiazide, finasteride, opioids; (7) **Testosterone replacement** only if confirmed hypogonadism (low + symptoms); not for normal T; risks: erythrocytosis, prostate growth, possible CV (current data more reassuring per TRAVERSE); (8) **Second-line**: - **Intraurethral alprostadil** (MUSE); - **Intracavernosal injection** (alprostadil, papaverine, phentolamine combo) — urology training; - **Vacuum erection device**; - **Penile prosthesis** — surgical, very effective, satisfaction high; (9) **Psychosexual counseling / sex therapy** — alone or combined with medical; address partner; (10) **Lifestyle**: exercise (significant ED improvement), weight loss, Mediterranean diet, sleep, stress; (11) **Multidisciplinary**: PCP + urology + endocrinology + cardiology + behavioral health + sex therapy

---

ED: marker of CVD — comprehensive risk eval. PDE5 inhibitors first-line (avoid w/ nitrates). Address meds + low T (only if confirmed). Lifestyle + CV risk. Second-line: alprostadil, vacuum, prosthesis. Psychosexual counseling. Multidisciplinary.', NULL,
  'easy', 'signs_symptoms', 'review',
  'family_medicine', 'clinical_decision', 'signs_symptoms', 'adult',
  'AUA ED 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยชายอายุ 55 ปี HTN + DM + smoker — gradual decrease in erection × 1 yr; embarrassed'
  );

commit;

