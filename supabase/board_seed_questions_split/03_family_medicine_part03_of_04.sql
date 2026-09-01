-- ===============================================================
-- หมอรู้ — Board seed: เวชศาสตร์ครอบครัว (family_medicine) — part 3/4 (50 MCQs)
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
  s.id, 'board', NULL, 'ผู้หญิงอายุ 52 ปี — vasomotor symptoms + sleep disturbance + vaginal dryness × 6 mo; last menses 8 mo ago; no breast cancer or VTE history', '[{"label":"A","text":"No treatment for menopause symptoms"},{"label":"B","text":"Menopause + Menopausal Hormone Therapy (NAMS 2022)"},{"label":"C","text":"Long-term oral estrogen for all"},{"label":"D","text":"Avoid all therapy"},{"label":"E","text":"Bioidentical hormones not regulated as superior"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Menopause + Menopausal Hormone Therapy (NAMS 2022): (1) **Menopause definition**: 12 consecutive months amenorrhea; perimenopause symptomatic period before; (2) **Symptoms**: vasomotor (hot flashes, night sweats), genitourinary syndrome of menopause (GSM — dryness, dyspareunia, urinary), sleep, mood, cognition, joint, sexual; (3) **Comprehensive evaluation**: history + cardiovascular risk + breast cancer risk + thromboembolism risk + osteoporosis risk; baseline BP, lipid, mammogram per screening, DXA if indicated; (4) **Menopausal Hormone Therapy (MHT) — NAMS 2022 reaffirmed for symptomatic women < 60 yo or < 10 yr from menopause**: - Most effective for vasomotor symptoms + GSM; - **Benefits**: symptom relief, fracture prevention, possible CV benefit if early (timing hypothesis); - **Risks**: VTE (oral > transdermal), breast cancer (with combined estrogen+progestin > 5 yr; estrogen-only — controversial), stroke (oral); - Individual risk-benefit + shared decision; (5) **Formulation choice**: - **Systemic** for vasomotor: - **Estrogen alone** if hysterectomy; - **Estrogen + progestin** if uterus (endometrial protection); - **Transdermal estrogen** preferred over oral — lower VTE + stroke risk; lipid + BP neutral; - Multiple options: patch, gel, spray, oral; - Continuous combined or sequential; - **Local vaginal** for GSM only: vaginal estrogen tablet/cream/ring (low-dose Estring), DHEA (prasterone), ospemifene (SERM oral) — minimal systemic absorption, safe even in breast cancer history (with onc input), no progestin needed; (6) **Non-hormonal options for vasomotor** (if MHT CI or declined): - **SSRI/SNRI** (paroxetine FDA-approved low-dose, venlafaxine, escitalopram); - **Gabapentin**; - **Clonidine**; - **Fezolinetant** (NK3 receptor antagonist — Veozah) — FDA-approved 2023 — novel non-hormonal; - **Lifestyle**: dressing layers, cool environment, weight, exercise, stress, avoid triggers; - CBT for hot flashes; clinical hypnosis evidence; (7) **Contraindications absolute MHT**: ER+ breast cancer, recent VTE, stroke, CAD, active liver disease, undiagnosed vaginal bleeding, pregnancy; (8) **Bone health**: weight-bearing, calcium, vit D, DXA, treat osteoporosis; (9) **CV risk modification** + cancer screening; (10) **Annual reevaluation** — risk-benefit + symptoms; no fixed duration; many continue beyond 5 yr if benefit > risk; (11) **Multidisciplinary**: PCP + gyn + breast + cardiology if indicated

---

Menopause MHT: NAMS 2022 supports for symptomatic < 60 yo or < 10 yr from menopause. Transdermal preferred (lower VTE). Estrogen alone if no uterus; +progestin if uterus. Local vaginal for GSM. Non-hormonal options (SSRI, gabapentin, fezolinetant). Individualized + shared decision. Multidisciplinary.', NULL,
  'medium', 'obgyn', 'review',
  'family_medicine', 'clinical_decision', 'obgyn', 'adult',
  'NAMS Hormone Therapy 2022', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้หญิงอายุ 52 ปี — vasomotor symptoms + sleep disturbance + vaginal dryness × 6 mo; last menses 8 mo ago; no breast cancer or VTE history'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้หญิงอายุ 25 ปี — irregular menses (5-7/yr) + hirsutism + acne + acanthosis nigricans + BMI 32; pregnancy test negative', '[{"label":"A","text":"No treatment until trying to conceive"},{"label":"B","text":"PCOS Management (Rotterdam + International PCOS Guideline 2023)"},{"label":"C","text":"Surgery first-line"},{"label":"D","text":"Steroid for hyperandrogenism"},{"label":"E","text":"Ignore — cosmetic only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** PCOS Management (Rotterdam + International PCOS Guideline 2023): (1) **Rotterdam criteria** (2 of 3): - Oligo/anovulation; - Clinical or biochemical hyperandrogenism (hirsutism, acne, alopecia; total/free T elevated, DHEAS); - Polycystic ovarian morphology on US (≥ 20 follicles per ovary or volume > 10 mL); - Exclude other (CAH 17-OHP, Cushing, hyperprolactinemia, thyroid, androgen tumor); (2) **Workup**: total T + SHBG + free T, DHEAS, 17-OHP, prolactin, TSH, fasting glucose + lipid + HbA1c, transvaginal US, endometrial assessment if prolonged amenorrhea; (3) **Comorbidities high**: insulin resistance + T2DM, dyslipidemia, NAFLD, OSA, infertility, endometrial hyperplasia/cancer (unopposed estrogen), CV risk, depression/anxiety, eating disorders; (4) **Lifestyle FOUNDATION**: - Weight loss 5-10% — significant improvement in menses, ovulation, metabolic, fertility; - Mediterranean / low-carb diet; - Exercise 150 min/wk; - CBT for weight + mood; (5) **Management by goal**: - **Menstrual regulation + hyperandrogenism + contraception (not fertility currently)** (this patient): - **Combined OCP first-line** — regulates cycles, reduces hyperandrogenism + endometrial protection; less androgenic progestin preferred (drospirenone, desogestrel, norgestimate); - **Spironolactone** add-on for hirsutism (anti-androgen 50-100 mg BID; effective combined with OCP); - Cosmetic measures hair (eflornithine cream, laser, electrolysis); - **Metformin** for metabolic + irregular menses; modest weight loss; useful adjunct esp glucose intolerance; - **GLP-1 RA** emerging for weight + metabolic; - **Inositol** (myo + d-chiro) supplements — some evidence; - **Fertility (when desired)**: - Letrozole first-line ovulation induction (better than clomid per PPCOS II); - Clomiphene; - Metformin add-on; - Gonadotropin; - IVF; - **Bariatric surgery** for severe obesity + comorbidity; (6) **Endometrial protection** if amenorrhea/oligomenorrhea — withdraw progestin q 2-3 mo or continuous OCP/POP/LNG-IUD; (7) **Metabolic screening + management**: OGTT q 1-3 yr, lipids, BP, depression screen; (8) **Pregnancy + obstetric considerations**: T2DM, gestational DM, preeclampsia, preterm; (9) **Multidisciplinary**: PCP + gyn/REI + endocrine + dietitian + behavioral health + dermatology

---

PCOS: Rotterdam criteria + exclude others. Lifestyle foundation. **Combined OCP** for menses + hyperandrogenism + contraception; spironolactone add-on; metformin for metabolic. Letrozole for ovulation induction. Endometrial protection. Screen metabolic + mental health. Multidisciplinary.', NULL,
  'medium', 'obgyn', 'review',
  'family_medicine', 'clinical_decision', 'obgyn', 'adult',
  'International PCOS Guideline 2023; Rotterdam', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้หญิงอายุ 25 ปี — irregular menses (5-7/yr) + hirsutism + acne + acanthosis nigricans + BMI 32; pregnancy test negative'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกอายุ 5 wk — fever 38.5 rectal × 1 d, no source identified, well-appearing', '[{"label":"A","text":"Outpatient observation with no workup"},{"label":"B","text":"Infant Fever Workup (AAP 2021 Guideline: Well-Appearing Febrile Infants 8-60 d)"},{"label":"C","text":"Discharge with reassurance"},{"label":"D","text":"Antibiotic without workup"},{"label":"E","text":"Wait until baby looks ill"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Infant Fever Workup (AAP 2021 Guideline: Well-Appearing Febrile Infants 8-60 d): (1) **All febrile infants < 28 d (this patient — 5 wk = 35 d at edge)**: - Full sepsis workup; - Admit + empiric antibiotics; - **CBC + procalcitonin + blood culture + urinalysis + urine culture + LP (CSF — cell count, glucose, protein, culture, gram stain, HSV PCR), CXR if respiratory sx**; - Empiric IV abx (ampicillin + cefotaxime or gentamicin); add acyclovir if HSV suspected (hypothermia, seizure, vesicles, maternal HSV); (2) **Updated AAP 2021 guideline 22-28 days**: - Inflammatory markers (procal, CRP, ANC); - Risk stratification; - Some can avoid LP if low risk; - Many institutions still aggressive; (3) **29-60 days** (this patient applies): - **Step approach**: vitals + appearance + risk factors; - **Required**: CBC, procalcitonin (or CRP if procal unavailable), ANC, urinalysis + culture, blood culture; - **LP** if any high-risk: ill-appearing, abnormal inflammatory markers (procal > 0.5 or CRP > 20 or ANC > 4000 or > 5200), positive UA; - **Can manage outpatient with close F/U** if low-risk + reliable family; - Empiric ceftriaxone if treating; (4) **Common pathogens**: GBS, E. coli (most common — UTI), Listeria (decreasing with maternal screening), HSV, enterovirus (seasonal), bacteremia, meningitis; (5) **Older infants 3-36 mo well-appearing with fever ≤ 39 without source**: - Less aggressive (post-PCV/Hib era — bacteremia rare); UA in girls < 24 mo + uncircumcised boys < 12 mo; selective bloodwork; observation strategy; close follow-up; (6) **Sources to identify**: UTI, otitis, viral URI, gastroenteritis, pneumonia, skin/soft tissue, occult bacteremia, meningitis; (7) **Specific viral**: enterovirus (seasonal, supportive); HSV (treat IV acyclovir empirically high-risk + sick); RSV; influenza (oseltamivir); COVID; (8) **Family education**: when to return, antipyretics for comfort (acetaminophen, ibuprofen ≥ 6 mo, not aspirin children), fever management; (9) **Multidisciplinary**: PCP + ED + pediatrics + ID consultation if needed

---

Infant fever 29-60 d (AAP 2021): risk-stratify with inflammatory markers. Required workup (CBC, procal, UA, cx, blood cx). LP if high-risk. Empiric ceftriaxone if treating. Pathogens: GBS, E coli, Listeria, HSV. < 28 d: full workup + admit always. Multidisciplinary.', NULL,
  'hard', 'id', 'review',
  'family_medicine', 'clinical_decision', 'id', 'peds',
  'AAP Febrile Infants 2021', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ทารกอายุ 5 wk — fever 38.5 rectal × 1 d, no source identified, well-appearing'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกอายุ 6 mo — cough + congestion + wheezing + tachypnea × 3 d, mild-mod work of breathing, SpO2 94%, hydrated, drinking, no apnea', '[{"label":"A","text":"Routine albuterol for all"},{"label":"B","text":"Bronchiolitis Management (AAP 2014 + Continuing Updates)"},{"label":"C","text":"Antibiotic empirically"},{"label":"D","text":"Routine chest X-ray"},{"label":"E","text":"Oral steroid for bronchiolitis"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bronchiolitis Management (AAP 2014 + Continuing Updates): (1) **Diagnosis clinical**: < 2 yo + viral URI + wheeze/crackles + work of breathing; RSV most common (also rhinovirus, metapneumovirus, parainfluenza, adenovirus); (2) **No routine testing**: chest X-ray (not unless concerned pneumonia/foreign body/cardiac), viral PCR (only if changes management or admitted/cohorting), blood/urine workup (only if febrile young infant or focal); (3) **Management — SUPPORTIVE — what AAP says NOT to do**: - **DO**: hydration (oral, IV/NG if needed), oxygen if SpO2 < 90% sustained, suction (nasal saline ± bulb, deep suction avoided), monitor; nasal CPAP / HFNC for moderate-severe; - **DO NOT routinely**: - **Albuterol/bronchodilator** — no benefit overall (selected response possible — trial only if persistent); - **Racemic epinephrine** outpatient; - **Steroid** (oral/IV/inhaled) — no benefit; - **Antibiotic** (only if confirmed bacterial coinfection); - **Chest physiotherapy**; - **Hypertonic saline** outpatient (mixed evidence inpatient); (4) **Admission indications**: - Persistent SpO2 < 90%; - Severe respiratory distress; - Apnea; - Inability to feed / dehydration; - Toxic appearance; - High-risk (< 12 wk, prematurity, cardiopulmonary, immunocompromised); - Unreliable follow-up; (5) **ICU**: respiratory failure, severe distress, recurrent apnea; (6) **Prevention**: - **RSV monoclonal antibody**: - **Nirsevimab (Beyfortus)** — single dose all infants < 8 mo before/during RSV season (CDC/AAP 2023 — major update); replacing palivizumab for most; - **Palivizumab** — older monthly during season for high-risk; - **Maternal RSV vaccination (Abrysvo)** 32-36 wk gestation — alternative protective strategy; - Hand hygiene, breastfeeding, smoke-free, daycare exposure management; (7) **Family education**: expected course (worst day 3-5, total 14 d), red flags (worsening WOB, poor feeding, dehydration, color change, apnea, fever), return precautions; (8) **Follow-up close**: 24-48 h while symptoms peak; (9) **Multidisciplinary**: PCP + ED + pediatrics + ICU if needed

---

Bronchiolitis: clinical, no routine testing, supportive (hydration, O2 if < 90, suction). **Avoid**: albuterol, steroid, abx routinely. Admit if severe. Prevention: **nirsevimab** all infants + maternal RSV vaccine (2023 update). Family education + follow-up.', NULL,
  'easy', 'respiratory', 'review',
  'family_medicine', 'clinical_decision', 'respiratory', 'peds',
  'AAP Bronchiolitis 2014; CDC RSV 2023', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ทารกอายุ 6 mo — cough + congestion + wheezing + tachypnea × 3 d, mild-mod work of breathing, SpO2 94%, hydrated, drinking, no apnea'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 25 ปี — ear pain + itching + discharge ข้างขวา 3 วันหลังว่ายน้ำ; tragal tenderness + erythematous canal', '[{"label":"A","text":"Oral antibiotic first-line"},{"label":"B","text":"Acute Otitis Externa (AAO-HNS 2014)"},{"label":"C","text":"Surgery for acute OE"},{"label":"D","text":"Q-tip cleaning recommended"},{"label":"E","text":"Ignore — self-resolves"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Otitis Externa (AAO-HNS 2014): (1) **Diagnosis**: rapid onset + canal inflammation + ear pain ± otorrhea ± hearing loss; differentiate from AOM (TM mobility + bulging); (2) **Risk factors**: swimming (swimmer''s ear), trauma, occlusion (hearing aid, ear plug), allergic dermatitis, eczema, DM (higher risk malignant otitis externa); (3) **Common pathogens**: Pseudomonas aeruginosa + Staphylococcus aureus (bacterial); fungal (Aspergillus, Candida) in chronic/refractory; (4) **First-line topical therapy** (most cases): - **Topical antibiotic + steroid combination** (acetic acid + steroid, neomycin-polymyxin-hydrocortisone — OK if intact TM, fluoroquinolone preparations); - **Fluoroquinolone ear drops** (ofloxacin, ciprofloxacin — alone or with steroid) — **safe even with TM perforation or tympanostomy tubes** (NOT ototoxic); preferred when TM status uncertain; - Avoid neomycin-containing if perforation/tubes (potentially ototoxic); - Duration 7-10 days; - Wick (Pope ear wick) if canal swollen + drops cannot enter; (5) **Pain control**: NSAIDs / acetaminophen — adequate for most; opioids rarely needed brief; (6) **Aural toilet**: gentle removal of debris (visualize TM) — ENT if needed; (7) **Avoid water in ear** during treatment (showering — earplug, no swimming); (8) **No oral antibiotic** for uncomplicated otitis externa (topical superior, less resistance); oral abx if: - Extension beyond canal; - Immunocompromised + cellulitis; - DM with severe symptoms or suspected malignant OE; (9) **Malignant (necrotizing) otitis externa** — emergency: - DM, elderly, immunocompromised; - Severe pain, granulation, cranial nerve involvement; - CT/MRI base of skull + culture + IV antipseudomonal (ciprofloxacin oral may suffice mild) + ENT consult; - Risk osteomyelitis + intracranial spread; (10) **Chronic OE**: consider fungal (yellow/black/fluffy debris) — topical antifungal (clotrimazole, gentian violet, acetic acid); dermatitis (steroid); avoid Q-tips; (11) **Prevention**: dry ears after water, ear plugs swimmers, acidifying drops post-swim; (12) **Multidisciplinary**: PCP + ENT if refractory or malignant OE

---

Acute OE: clinical. Pseudomonas + Staph. Topical antibiotic ± steroid (FQ drops safe perforation). Pain control. Avoid water. Oral abx only severe/extension/DM. Malignant OE — emergency. Prevention. Multidisciplinary.', NULL,
  'easy', 'id', 'review',
  'family_medicine', 'clinical_decision', 'id', 'adult',
  'AAO-HNS Otitis Externa 2014', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 25 ปี — ear pain + itching + discharge ข้างขวา 3 วันหลังว่ายน้ำ; tragal tenderness + erythematous canal'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 22 ปี — ER post-overdose attempt acetaminophen 30 tablets; รักษาเสร็จ medical stabilization แล้ว', '[{"label":"A","text":"Discharge with no follow-up"},{"label":"B","text":"Post-Suicide Attempt Assessment + Management (Joint Commission + Zero Suicide)"},{"label":"C","text":"No-suicide contract sufficient"},{"label":"D","text":"Ignore — gesture only"},{"label":"E","text":"Single visit and release"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-Suicide Attempt Assessment + Management (Joint Commission + Zero Suicide): (1) **Universal screening**: Columbia Suicide Severity Rating Scale (C-SSRS) or ASQ (Ask Suicide-Screening Questions) for all behavioral health + medical patients (Joint Commission requirement); (2) **Risk assessment** comprehensive: - **Ideation**: passive vs active, plan, intent, lethality; - **Behavior**: prior attempts (strongest predictor — 30-40x risk), preparatory behavior, rehearsal, aborted/interrupted; - **Risk factors**: mental illness (depression, bipolar, psychosis, anxiety, PTSD, substance use), recent loss, hopelessness, access to means (especially firearms — # 1 suicide method US; lethal means counseling critical), prior attempts, chronic pain, terminal illness, male, age extremes, LGBTQ+ (esp youth), social isolation, family history, prior trauma/ACEs, recent hospitalization, military service; - **Protective factors**: connectedness, religious beliefs, children at home, future orientation, engaged in treatment, problem-solving skills; (3) **Disposition**: - **Inpatient psychiatric admission** for acute high risk: - Persistent SI with plan + intent; - Recent attempt with continued ideation; - Severe mental illness with safety concerns; - Lack of support / safety plan unworkable; - **Outpatient with intensive follow-up** if stabilized + can engage in safety plan + close follow-up + support: - Same-day or 24-48 h followup; - Crisis services + warm handoff; - PHP/IOP options; (4) **Safety planning** (Stanley + Brown — evidence-based): - Warning signs; - Internal coping strategies; - Social distractions + people; - People to contact for help; - Professionals + agencies + crisis line (988 Suicide + Crisis Lifeline US); - **Means restriction** (firearms — secured storage / off-site; medication — locked, limited supplies); (5) **Treatment**: - Underlying mental illness (medications, therapy — DBT for chronic suicidal behavior + BPD, CBT); - **Lithium** for bipolar — anti-suicidal; - **Clozapine** for schizophrenia — anti-suicidal; - Substance use treatment; (6) **Caring contacts** (phone, text, postcards) — reduces re-attempt; (7) **Don''t use no-suicide contracts** — ineffective; (8) **Family + support engagement** with consent; (9) **Documentation comprehensive**; (10) **Reduce stigma + non-judgmental approach**; (11) **Multidisciplinary**: ED + psychiatry + social work + crisis services + outpatient mental health + family

---

Post-suicide attempt: comprehensive risk assessment (C-SSRS), risk + protective factors. Inpatient vs intensive outpatient. Safety planning + means restriction (firearms #1). Treat underlying. Lithium/clozapine anti-suicidal. Caring contacts. Multidisciplinary.', NULL,
  'hard', 'psych_behavior', 'review',
  'family_medicine', 'clinical_decision', 'psych_behavior', 'adult',
  'Joint Commission Suicide; Zero Suicide; Stanley-Brown', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 22 ปี — ER post-overdose attempt acetaminophen 30 tablets; รักษาเสร็จ medical stabilization แล้ว'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'วัยรุ่นหญิง 17 ปี — BMI 16, amenorrhea × 6 mo, restrictive eating, exercise obsessive, body image distortion', '[{"label":"A","text":"Force feeding only"},{"label":"B","text":"Eating Disorder (Anorexia Nervosa) — Primary Care (AAP + APA)"},{"label":"C","text":"Hospital not needed for severe"},{"label":"D","text":"Single visit reassurance"},{"label":"E","text":"Antidepressant alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Eating Disorder (Anorexia Nervosa) — Primary Care (AAP + APA): (1) **Diagnosis DSM-5 AN**: restriction of intake → significantly low weight, intense fear of gaining weight, body image disturbance; subtypes — restricting, binge-purge; severity by BMI; (2) **High mortality** (~ 5-10%) — highest of psychiatric disorders; medical complications + suicide; (3) **Comprehensive medical assessment**: - Vitals (orthostatic, bradycardia < 50, hypothermia); BMI; - Cardiac (ECG — QTc, arrhythmia); - Electrolytes (hypokalemia from purging), glucose, BUN, Cr, Mg, phos; - CBC; - LFT; - TSH, FSH/LH/estradiol; - DXA bone density (osteoporosis common); - Dental (purging erosion); - EKG; (4) **Screening tools**: SCOFF questionnaire; EAT-26; comprehensive interview; (5) **Hospitalization criteria** (AAP + APA — any): - HR < 50, orthostatic, hypotension, hypothermia < 36; - Severe electrolyte imbalance; - Cardiac complications (arrhythmia, prolonged QT); - Acute medical complications; - Severe weight loss (< 75% expected; < 85% with rapid loss); - Inability to gain weight outpatient; - Comorbidity needing inpatient (suicidal, severe depression, severe substance abuse); - **Refeeding syndrome risk** (severely malnourished) — careful monitoring electrolytes (esp phos), gradual reintroduction, thiamine; (6) **Outpatient treatment** stable patients: - **Multidisciplinary team mandatory** — primary care + mental health + nutrition; - **Family-Based Treatment (FBT, Maudsley)** — first-line for adolescent AN (strong evidence); - **CBT-E (enhanced)** for adult or non-adolescent; - **IPT, DBT** alternatives; - Nutritional rehabilitation — weight restoration goal; - **Pharmacotherapy LIMITED in AN** — olanzapine modest weight gain evidence; SSRI for depression/anxiety after weight restoration (less effective when severely underweight); (7) **Bulimia nervosa + binge eating disorder**: more medication evidence (fluoxetine high-dose for BN; lisdexamfetamine for BED; topiramate); CBT effective both; (8) **Refeeding syndrome prevention**: start low calories + advance slowly + electrolyte monitoring + thiamine + phosphorus supplementation; (9) **Bone health**: weight restoration primary; calcium + vit D; not OCP (suppresses bone formation; pulses dehydroepiandrosterone + transdermal estradiol some evidence adolescents); (10) **Family + school involvement + support**; (11) **Specialty eating disorder programs**: residential, PHP, IOP, outpatient — match to severity; (12) **Multidisciplinary**: PCP + adolescent medicine + psychiatry + therapist + dietitian + family + school + medical specialists + ED program

---

Anorexia: high mortality. Comprehensive medical eval + hospitalization criteria. Multidisciplinary care mandatory. Adolescent — FBT first-line. CBT-E adult. Pharm limited AN (olanzapine some). Refeeding syndrome prevention. Bone health. Specialty programs.', NULL,
  'hard', 'psych_behavior', 'review',
  'family_medicine', 'clinical_decision', 'psych_behavior', 'peds',
  'AAP Eating Disorders; APA 2023', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'วัยรุ่นหญิง 17 ปี — BMI 16, amenorrhea × 6 mo, restrictive eating, exercise obsessive, body image distortion'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 72 ปี — new severe temporal headache + jaw claudication + visual symptoms (transient); proximal muscle pain + stiffness; ESR 92, CRP 8', '[{"label":"A","text":"Outpatient routine — biopsy first then treat"},{"label":"B","text":"Giant Cell Arteritis (GCA / Temporal Arteritis) + PMR — EMERGENCY (ACR 2022 + EULAR)"},{"label":"C","text":"Wait for ESR result before treating"},{"label":"D","text":"NSAIDs alone for GCA"},{"label":"E","text":"No imaging for surveillance"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Giant Cell Arteritis (GCA / Temporal Arteritis) + PMR — EMERGENCY (ACR 2022 + EULAR): (1) **GCA medical emergency**: risk of permanent blindness (ischemic optic neuropathy); start treatment IMMEDIATELY on clinical suspicion — don''t wait for biopsy; (2) **Classic features GCA**: > 50 yo, new headache (temporal area), scalp tenderness, jaw claudication (highly specific), visual symptoms (transient monocular blindness — amaurosis, diplopia, vision loss permanent), temporal artery abnormality (tender, beaded, decreased pulse), constitutional symptoms (fever, fatigue, weight loss); (3) **Overlap with PMR** (~ 50% of GCA): bilateral shoulder + pelvic girdle pain + stiffness > 45 min, ESR/CRP elevated; (4) **Diagnostic workup**: - **ESR + CRP** elevated (normal ~ 10% — don''t rule out alone); - Anemia, thrombocytosis often; - **Temporal artery biopsy** — gold standard, but treat first; specimen ≥ 1-2 cm, contralateral if negative + high suspicion; skip lesions; can be positive up to 2 wk after starting steroid; - **Imaging**: temporal artery US (halo sign), MRI/MRA, PET — increasingly used + supplement biopsy; - Ophthalmology consult urgent for visual symptoms; (5) **Treatment GCA**: - **High-dose oral prednisone 60 mg/d** (1 mg/kg) immediately on suspicion; if vision loss → IV methylprednisolone 1g/d × 3 d then oral; - Slow taper over months-years (12-24 mo+); monitor symptoms + ESR/CRP; - **Tocilizumab (IL-6 inhibitor)** — FDA approved 2017 — steroid-sparing, reduce flare, dual therapy; can shorten/reduce steroid; - **Methotrexate** — alternative steroid-sparing; - Prednisone tapered to lowest effective; (6) **Treatment PMR**: - Low-dose prednisone 15-20 mg/d → response rapid (often dramatic) → taper slowly over 1-2 yr; - Methotrexate steroid-sparing for relapse; - Tocilizumab in selected (especially GCA + PMR); (7) **Steroid management**: - Bone protection (calcium + vit D + bisphosphonate if appropriate); - PCP prophylaxis (TMP-SMX) for high-dose chronic steroid; - Glucose monitoring (steroid DM); - BP monitoring; - Weight, mood, sleep, infection screening; - Cataract, glaucoma watch; - Gradual taper to prevent adrenal insufficiency; (8) **Aortitis surveillance**: large vessel involvement common in GCA (~ 20%) — aortic aneurysm risk; serial imaging (CT, MRA, US) per protocol; (9) **Patient education**: red flag symptoms (vision change, jaw claudication during taper); (10) **Multidisciplinary**: PCP + rheumatology urgent + ophthalmology + ENT + biopsy surgeon

---

GCA = emergency (blindness risk) — start high-dose prednisone IMMEDIATELY on suspicion; biopsy after. Tocilizumab steroid-sparing. PMR — prednisone 15-20 mg, slow taper. Aortitis surveillance. Steroid management + bone. Multidisciplinary.', NULL,
  'hard', 'msk_nontrauma', 'review',
  'family_medicine', 'clinical_decision', 'msk_nontrauma', 'adult',
  'ACR/EULAR GCA 2022', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 72 ปี — new severe temporal headache + jaw claudication + visual symptoms (transient); proximal muscle pain + stiffness; ESR 92, CRP 8'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้หญิงอายุ 45 ปี — fatigue, pallor; CBC: Hb 8.5, MCV 72 (low), RDW 18; ferritin 8 (low)', '[{"label":"A","text":"Iron infusion only — never oral"},{"label":"B","text":"Iron Deficiency Anemia (IDA) Workup + Management"},{"label":"C","text":"Transfusion for any anemia"},{"label":"D","text":"No workup for cause"},{"label":"E","text":"Steroid for IDA"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Iron Deficiency Anemia (IDA) Workup + Management: (1) **Diagnosis**: microcytic anemia (low MCV) + low ferritin (gold standard if < 30; functional iron deficiency may have normal ferritin + low TSAT) + low TSAT (< 20%); RDW elevated; (2) **Always identify CAUSE**: - **Menstrual blood loss** — most common in premenopausal women (heavy menstrual bleeding — workup gynecologic if heavy); - **GI blood loss** — must rule out in: men, postmenopausal women, weight loss, GI symptoms, hemoccult positive, family history; **endoscopy + colonoscopy** for these; - **Malabsorption**: celiac disease (test tTG-IgA), atrophic gastritis (with PPI or H. pylori), bariatric surgery; - **Inadequate intake**: vegetarian/vegan, restrictive; - **Pregnancy + lactation** increased demand; - **Frequent blood donation**; - **Hemoglobinopathy** screen (mimics microcytic — Hb electrophoresis if Asian, Mediterranean, African); (3) **Workup for THIS patient (premenopausal women, severe IDA)**: - Menstrual history (HMB → gyn workup); - Celiac serology; - GI workup if: irregular bleeding, age > 50, family history, GI symptoms, no obvious source; - Reticulocyte count; - B12, folate (concurrent deficiency); - Hb electrophoresis if indicated; (4) **Treatment iron repletion**: - **Oral iron** first-line: - Ferrous sulfate 325 mg (65 mg elemental) daily or every other day (alternate-day improves absorption, less SE — emerging evidence); - Take with vitamin C, avoid with calcium / dairy / tea / coffee / PPI / antacids; - SE: nausea, constipation, dark stools; - Alternative formulations: ferrous gluconate, fumarate, iron polysaccharide; - Duration: until Hb normalizes + 3-6 mo to replete stores (typically 3-6 mo total); - **IV iron** if oral fails / intolerant / malabsorption (celiac, IBD, bariatric) / urgent (severe, pregnancy, pre-surgery): - Iron sucrose, ferric gluconate, ferric carboxymaltose (FCM), ferumoxytol, iron isomaltoside; - Outpatient infusion; - Test dose + monitoring (rare anaphylaxis); - **Transfusion** only acute symptomatic severe; - **Monitor**: Hb recheck 2-4 wk (expect rise > 1 g/dL); ferritin after course; (5) **Treat underlying cause**; (6) **Vitamin co-supplementation** if deficient (B12, folate); (7) **Multidisciplinary**: PCP + GI (workup), gyn (HMB), hematology (refractory), surgery, transfusion service

---

IDA: low ferritin + low TSAT + microcytic. Always find cause: menstrual, GI (endoscopy if older/male/no source), malabsorption (celiac), diet. Oral iron first-line (alternate-day improves absorption). IV iron if oral fails. Treat cause. Recheck Hb 2-4 wk.', NULL,
  'easy', 'hemato_onco', 'review',
  'family_medicine', 'clinical_decision', 'hemato_onco', 'adult',
  'AAFP IDA; ASH', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้หญิงอายุ 45 ปี — fatigue, pallor; CBC: Hb 8.5, MCV 72 (low), RDW 18; ferritin 8 (low)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 30 ปี — LDL 280, TC 350, normal TG, HDL ปกติ; father MI age 42, uncle MI age 45; tendinous xanthomas', '[{"label":"A","text":"Statin alone — no escalation"},{"label":"B","text":"Familial Hypercholesterolemia (FH) (NLA + AHA)"},{"label":"C","text":"Wait until first MI"},{"label":"D","text":"No family screening"},{"label":"E","text":"Avoid PCSK9i regardless of severity"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Familial Hypercholesterolemia (FH) (NLA + AHA): (1) **High suspicion**: severe LDL (> 190 untreated adult, > 160 child), family history premature CAD, physical findings (tendinous xanthomas, arcus cornealis < 45 yo, xanthelasma); (2) **Clinical criteria**: Dutch Lipid Clinic Network (DLCN) Score, Simon Broome, MEDPED; - Premature CAD < 55 men / < 60 women in 1st-degree relative; - LDL very high; - Physical findings; - Genetic confirmation (LDLR, ApoB, PCSK9 mutations — most common LDLR); (3) **Heterozygous FH (HeFH)**: ~ 1:250 — most common autosomal codominant condition; lifetime CAD risk very high if untreated; (4) **Homozygous FH (HoFH)** rare: extremely severe, early childhood disease, often need lipid apheresis + advanced therapy; (5) **CV risk assessment**: ASCVD risk underestimates FH — treat all as high-risk regardless of calculator; CAC scoring may add; consider stress test, carotid US selected; (6) **Treatment goals**: - **LDL < 100 (FH without ASCVD)**; - **LDL < 70 (FH with ASCVD or other major risk)** — modern AHA + ESC even < 55; - At minimum ≥ 50% LDL reduction; (7) **Pharmacotherapy AGGRESSIVE — start early**: - **High-intensity statin first-line** — rosuvastatin 20-40 or atorvastatin 40-80 — typically 40-50% LDL reduction; - **Ezetimibe 10 mg** add — additional 18-20% reduction; combination very effective; - **PCSK9 inhibitors** (alirocumab, evolocumab) — additional 50-60% reduction; SC q 2-4 wk; for FH + insufficient on statin/ezetimibe (esp ASCVD); high cost + insurance pre-auth; - **Inclisiran** (siRNA — Leqvio) — twice-yearly SC injection; emerging option; - **Bempedoic acid** alternative; - **Lomitapide, mipomersen, evinacumab** for HoFH; - **Lipid apheresis** weekly/biweekly for HoFH or refractory severe; (8) **Cascade family screening** essential — 1st-degree relatives + extended; offered to all; genetic testing + lipid panel; (9) **Pediatric**: screen children 9-11 yo + repeat 17-21 yo + earlier if family history; treat from age 8-10 with high LDL (statin safe pediatric); (10) **Comprehensive CV risk modification**: BP, glucose, smoking cessation, exercise, diet (Mediterranean preferred), weight; (11) **Pregnancy**: stop statin + ezetimibe + PCSK9i (limited safety data); apheresis for severe; resume postpartum + lactation considerations; (12) **Multidisciplinary**: PCP + lipidology + genetics + cardiology + pediatric (children) + family education

---

FH: high suspicion (severe LDL + family history + xanthoma). Treat very high-risk. Goals LDL < 100 (or < 70 if ASCVD). Aggressive: high-intensity statin + ezetimibe + PCSK9i / inclisiran. Cascade family screening + pediatric. Multidisciplinary.', NULL,
  'medium', 'cardiovascular', 'review',
  'family_medicine', 'clinical_decision', 'cardiovascular', 'adult',
  'NLA FH 2015', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 30 ปี — LDL 280, TC 350, normal TG, HDL ปกติ; father MI age 42, uncle MI age 45; tendinous xanthomas'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง pharmacogenomics + precision medicine in primary care', '[{"label":"A","text":"Same dose for all patients"},{"label":"B","text":"Pharmacogenomics in Primary Care (CPIC + PharmGKB)"},{"label":"C","text":"Random selection"},{"label":"D","text":"Ignore genetics"},{"label":"E","text":"Only oncology applicable"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pharmacogenomics in Primary Care (CPIC + PharmGKB): (1) **Pharmacogenomics (PGx)**: tailoring drug + dose based on genetic variants affecting metabolism, transport, target, or immune response; (2) **CPIC Guidelines** (Clinical Pharmacogenetics Implementation Consortium) — evidence-based, primary resource for clinical translation; (3) **Key examples relevant primary care**: - **CYP2C19** + clopidogrel — poor metabolizers reduced antiplatelet effect (high CV risk); consider prasugrel/ticagrelor; - **CYP2C19** + PPI (esp omeprazole) — poor metabolizers higher exposure; ultra-rapid metabolizers reduced; - **CYP2C19** + voriconazole, SSRIs (citalopram, escitalopram); - **CYP2D6** + opioids: codeine + tramadol — ultra-rapid metabolizers → toxicity risk (avoid in breastfeeding mothers, children < 12); poor metabolizers → ineffective analgesia; - **CYP2D6** + SSRIs, TCAs, antipsychotics (risperidone), tamoxifen (need active metabolite endoxifen); - **CYP2C9 + VKORC1** + warfarin — dose prediction algorithms (e.g., warfarindosing.org); - **HLA-B*5701** + abacavir — severe hypersensitivity (mandatory screen before); - **HLA-B*1502** + carbamazepine — SJS/TEN risk (esp Asian populations — screen Thai, Han Chinese, Korean); - **HLA-B*5801** + allopurinol — SJS/TEN risk (Asian populations); - **TPMT** / **NUDT15** + thiopurines (azathioprine, mercaptopurine) — myelosuppression; - **DPYD** + fluoropyrimidines (5-FU, capecitabine) — severe toxicity; - **G6PD** + several drugs (rasburicase, dapsone, primaquine, sulfa, nitrofurantoin); - **UGT1A1** + irinotecan; - **SLCO1B1** + statins — myopathy risk (especially simvastatin); (4) **When to test**: pre-emptive (before prescribing — increasingly available, some institutions panel testing), reactive (after adverse event), high-risk drug initiation, race/ethnicity-specific (HLA, CYP variants more common); (5) **Limitations**: not all variants known, gene-drug interactions complex, environmental + drug interactions also affect, cost + insurance coverage, interpretation requires training; (6) **Resources**: CPIC.org, PharmGKB, FDA Table of Pharmacogenomic Biomarkers, FDA label information; (7) **Documentation + EHR integration**: clinical decision support; carry forward results lifetime; (8) **Health equity**: ensure equitable access; population-specific variants; (9) **Patient education**: results lifelong relevance; (10) **Multidisciplinary**: PCP + pharmacy (key partner) + genetics + specialist when needed

---

Pharmacogenomics: CPIC + PharmGKB. Key in primary care: CYP2C19 + clopidogrel/PPI/SSRI; CYP2D6 + codeine; CYP2C9 + warfarin; HLA-B*1502/5801 (Asian) + CBZ/allopurinol; TPMT thiopurines; G6PD; SLCO1B1 statins. EHR integration. Multidisciplinary with pharmacy.', NULL,
  'hard', 'procedures', 'review',
  'family_medicine', 'basic_science', 'procedures', 'adult',
  'CPIC; PharmGKB; FDA PGx', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'Resident ถามเรื่อง pharmacogenomics + precision medicine in primary care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ตีความ RCT — drug X reduced cardiovascular events from 5.2% to 4.1%, p = 0.02, NNT 91 over 5 yr', '[{"label":"A","text":"Just use p-value"},{"label":"B","text":"RCT Statistical Interpretation + Clinical Application"},{"label":"C","text":"Ignore numbers"},{"label":"D","text":"Apply universally without consideration"},{"label":"E","text":"Larger N always better"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** RCT Statistical Interpretation + Clinical Application: (1) **Absolute risk reduction (ARR)**: 5.2 - 4.1 = 1.1%; (2) **Relative risk reduction (RRR)**: 1.1/5.2 = 21%; (3) **NNT (Number Needed to Treat)**: 1/ARR = 1/0.011 ≈ 91 — treat 91 patients to prevent 1 event over study duration (5 yr here); (4) **Statistical significance (p-value)**: p < 0.05 = unlikely due to chance; doesn''t = clinically significant; **confidence interval (95% CI)** more informative — width = precision, includes 1 (HR/RR/OR) or 0 (mean difference) = not significant; (5) **Statistical vs clinical significance**: p value can be significant for trivial effect (especially large N); ARR + NNT more clinically meaningful; (6) **Need to consider**: - **Magnitude** of benefit; - **Cost**, side effects, harms — calculate NNH; - **External validity** — population studied vs your patient; - **Baseline risk** — same RRR translates to different ARR; - **Duration** of follow-up; - **Outcome importance** (mortality > surrogate); - **Composite endpoints** — examine components; - **Subgroup analyses** — hypothesis-generating only; - **Funding bias**, publication bias; (7) **Bayesian thinking**: integrate with prior probability + patient values; (8) **Number needed to harm (NNH)**: 1/ARI (absolute risk increase of adverse event); (9) **Likelihood ratio (LR)** for diagnostic tests: LR > 10 strong + evidence, < 0.1 strong - evidence; LR + sens/spec for evaluation; (10) **Cost-effectiveness**: QALY, cost per QALY thresholds; (11) **GRADE methodology**: certainty of evidence (high to very low) + strength of recommendation (strong vs conditional); (12) **Application to patient**: shared decision-making integrating evidence + values + circumstances; this drug — moderate benefit, NNT 91 over 5 yr — substantial number to treat for 1 event; need to weigh against cost, side effects, alternatives, baseline risk; (13) **Multidisciplinary clinical decision-making**

---

RCT interpretation: ARR, RRR, NNT essential. Statistical vs clinical significance differ. Need: magnitude, harms, external validity, baseline risk, duration, outcomes, subgroups. Bayesian + patient values. NNH for harm. GRADE. Shared decision-making.', NULL,
  'medium', 'signs_symptoms', 'review',
  'family_medicine', 'basic_science', 'signs_symptoms', 'adult',
  'JAMA Users'' Guides; GRADE', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'Resident ตีความ RCT — drug X reduced cardiovascular events from 5.2% to 4.1%, p = 0.02, NNT 91 over 5 yr'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง screening + intervention IPV (intimate partner violence) + child abuse + elder abuse in primary care', '[{"label":"A","text":"No screening — patient will tell"},{"label":"B","text":"Family Violence Screening + Intervention (USPSTF + AAFP + ACOG)"},{"label":"C","text":"Random asking"},{"label":"D","text":"Single visit — no follow-up"},{"label":"E","text":"Confront alleged abuser"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Family Violence Screening + Intervention (USPSTF + AAFP + ACOG): (1) **IPV (Intimate Partner Violence) screening**: - **USPSTF B recommendation**: women of reproductive age; - **Tools**: HITS (Hurt, Insult, Threaten, Scream), HARK, OAS, WAST; - Universal vs targeted — most recommend universal; - Privacy + confidentiality (limits — mandatory reporting in some jurisdictions); ask alone; - Consider in: chronic pain, mental health, substance use, headaches, GI sx, frequent visits, behavioral changes; (2) **IPV intervention** — LIVES framework (WHO): - **L**isten — empathic non-judgmental; - **I**nquire about needs + concerns; - **V**alidate; - **E**nhance safety — safety plan + danger assessment; - **S**upport — referrals (shelter, hotline 1-800-799-7233, legal aid, mental health, social work); - Documentation careful (legal); - Universal education even if screen negative; (3) **Child abuse + neglect** — mandatory reporting (all states US, all healthcare): - Suspicion-based (not proof) → CPS/social work; - **Red flags physical abuse**: bruises in non-mobile, patterned injuries, multiple stages of healing, inconsistent history, delayed presentation; metaphyseal fractures, posterior rib fractures, retinal hemorrhages, classic injury patterns; - **Sexual abuse**: behavior changes, STI in prepubertal, genital trauma, disclosure; - **Neglect**: poor hygiene, malnutrition, missed appointments, untreated medical, school absenteeism; - **Emotional abuse** + exposure to violence; - **Workup**: skeletal survey (< 2 yo), head CT/MRI, fundoscopy, labs as indicated; - **Avoid leading questions** if disclosure suspected — refer forensic interview; - Multidisciplinary child protection teams; (4) **Elder abuse** (1 in 10 elderly): - Physical, sexual, emotional, neglect, financial, abandonment; - **Tools**: EASI, BMI; - **Red flags**: unexplained injuries, malnutrition, dehydration, medication mismanagement, withdrawal, financial irregularities, fear of caregiver; - **Workup**: thorough exam, labs; - **Reporting**: APS (Adult Protective Services) — mandatory in most jurisdictions (varies); - Address caregiver burden, social isolation, cognitive decline; (5) **Trauma-informed care** universal: - Safety + trust + choice + collaboration + empowerment; - Recognize ubiquity; - Avoid retraumatization; - ACEs (Adverse Childhood Experiences) screening + addressing; (6) **Vicarious trauma + provider wellness** — self-care + supervision; (7) **Multidisciplinary**: PCP + social work + behavioral health + legal + law enforcement + advocacy + community + child/adult protective services + emergency services

---

Family violence: IPV — USPSTF screen reproductive women, LIVES intervention. Child abuse — mandatory reporting, red flags, multidisciplinary teams. Elder abuse — EASI screen, APS reporting. Trauma-informed care universal. ACEs. Provider wellness. Multidisciplinary.', NULL,
  'medium', 'psych_behavior', 'review',
  'family_medicine', 'basic_science', 'psych_behavior', 'adult',
  'USPSTF IPV 2018; AAP Child Abuse; NIA Elder Abuse', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'Resident ถามเรื่อง screening + intervention IPV (intimate partner violence) + child abuse + elder abuse in primary care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident — community ที่ดูแล multicultural population (immigrant, refugee, LGBTQ+, racial/ethnic minorities) — competent + equitable care', '[{"label":"A","text":"One-size-fits-all approach"},{"label":"B","text":"Cultural Humility + Health Equity (NIH + AAFP + AAMC)"},{"label":"C","text":"Family interpreter always"},{"label":"D","text":"Avoid asking about identity"},{"label":"E","text":"Ignore cultural factors"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cultural Humility + Health Equity (NIH + AAFP + AAMC): (1) **Cultural humility** (Tervalon + Murray-García) — lifelong learning + self-reflection + recognizing power imbalances + community partnerships (vs traditional ''cultural competency'' which implies achievable endpoint); (2) **LEARN framework cross-cultural communication**: Listen + Explain + Acknowledge + Recommend + Negotiate; ETHNIC framework similar; (3) **Health disparities**: differences in health outcomes between populations; structural racism + SDOH + discrimination + access; (4) **Specific population considerations**: - **Immigrant + refugee**: pre-migration trauma, screening (TB, hepatitis, HIV, STIs, parasites, vaccinations status, mental health, language access, legal/immigration concerns affecting healthcare access, cultural beliefs); - **LGBTQ+**: ask about sexual orientation + gender identity + practices (SO/GI/SPA); appropriate language; healthcare disparities (mental health, substance use, suicide, STI risk, healthcare avoidance from past discrimination); affirming care; transition support if applicable; partner involvement; chosen family; - **Racial/ethnic minorities**: implicit bias awareness, structural racism, disparities (Black maternal mortality 3-4x white; differences in BP, DM, mental health, cancer screening); culturally competent care; community partnership; - **Religious/spiritual**: respect + integration; Jehovah''s Witness (blood products), Muslim (Ramadan, modesty, Halal medications), Jewish (kosher, Sabbath), Christian Science, etc.; - **Indigenous**: historical trauma, sovereignty, traditional healing integration, tribal health systems; - **Rural**: access barriers, transportation, broadband, workforce shortage, agricultural exposures; - **Persons with disabilities**: accessibility, communication, accommodations, autonomy; - **Older adults**: ageism, cognitive considerations, family involvement; (5) **Language access**: professional interpreter (in-person, video, phone) — NOT family/children; Title VI legal requirement (CMS, federally-funded); written materials in patient language; (6) **Implicit bias training + reflection**: IAT (Implicit Association Test), regular self-assessment; structured decision aids reduce bias; diverse workforce; (7) **Trauma-informed care**: ACEs, structural violence; (8) **Community health worker (CHW) / promotores** programs — bridge community + healthcare; effective for many conditions; (9) **Workforce diversity + pipeline**: critical for representation + cultural concordance benefits; (10) **Quality improvement** with equity lens: stratified outcomes, equity dashboard, root cause analysis; (11) **Advocacy + policy** beyond clinic; (12) **Multidisciplinary**: PCP + social work + community health workers + interpreters + community partners + leadership + advocacy

---

Cultural humility: lifelong reflection + community partnerships. LEARN framework. Specific populations (immigrant, LGBTQ+, racial/ethnic, religious, indigenous, rural). Professional interpreters mandatory. Implicit bias training. CHW programs. Equity-focused QI. Multidisciplinary.', NULL,
  'easy', 'signs_symptoms', 'review',
  'family_medicine', 'basic_science', 'signs_symptoms', 'adult',
  'Tervalon Cultural Humility; AAFP Health Equity', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'Resident — community ที่ดูแล multicultural population (immigrant, refugee, LGBTQ+, racial/ethnic minorities) — competent + equitable care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง medical ethics + decision-making in challenging primary care scenarios', '[{"label":"A","text":"Doctor decides alone always"},{"label":"B","text":"Medical Ethics + Decision-Making in Primary Care"},{"label":"C","text":"Ignore patient preferences"},{"label":"D","text":"No documentation needed"},{"label":"E","text":"Family decision overrides patient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Medical Ethics + Decision-Making in Primary Care: (1) **Four principles (Beauchamp + Childress)**: autonomy + beneficence + non-maleficence + justice; (2) **Informed consent components**: capacity (assess if questioned — informed, understand, appreciate, reason), voluntariness, information (diagnosis, options, risks/benefits, alternatives, prognosis), comprehension, documentation; (3) **Decision-making capacity assessment**: condition-specific, not global; can have capacity for some decisions not others; assess: understand information, appreciate situation, reason with information, communicate choice; consult psychiatry/ethics if unclear; (4) **Surrogate decision-making** when capacity lacks: - **Hierarchy** (varies by state): healthcare POA → court-appointed guardian → spouse → adult children → parents → siblings → close friend; - **Substituted judgment standard** (what patient would want) > best interests (when patient wishes unknown); - **Advance directives** + living will + POLST/MOLST guide; - **Surrogate decision-making conflict** — ethics consultation; (5) **End-of-life care + advance care planning**: - **Palliative care** integrated early in serious illness; - **Hospice** prognosis ≤ 6 mo if disease takes natural course; - **POLST/MOLST** forms — actionable medical orders; - **Goals of care discussions**: VitalTalk, Serious Illness Conversation Guide (Ariadne); ''I wish'' + ''I worry'' + ''I wonder''; - **Code status**: full code, DNR/DNI, partial; - **Voluntary stopping eating + drinking (VSED)** option in some jurisdictions; - **Medical aid in dying (MAID)** legal in 10 US states + DC; varies internationally; - **Withdrawing vs withholding** — ethically equivalent; (6) **Confidentiality + privacy**: HIPAA framework; limits — court order, mandatory reporting (abuse, certain infections, gunshot/stab, suicide/homicide intent in some), threat to others (Tarasoff); (7) **Adolescent confidentiality**: complex — sensitive services (mental health, sexual, substance) often confidential; varies by state; (8) **Conscientious objection** vs duty to refer; (9) **Resource allocation + justice**: triage during scarcity (COVID ventilator allocation), access disparities, advocacy; (10) **Patient-physician relationship**: - Boundaries (especially in small communities/rural — dual relationships); - Gifts (small OK, large concerning); - Social media + electronic communication policies; - Treating family/friends (avoid except urgent); - Sexual relationships absolutely prohibited; - Bias + discrimination; (11) **Conflicts of interest**: pharma, devices, financial — disclose + manage; (12) **Mistakes + adverse events**: disclosure ethically required (also legally most jurisdictions); transparency improves trust + reduces litigation; (13) **Professional integrity**: honesty in documentation, billing, with patients; ethics consultation when needed; (14) **Multidisciplinary**: PCP + ethics committee + palliative care + legal + social work + chaplaincy + family

---

Medical ethics: 4 principles. Informed consent + capacity assessment. Surrogate decision-making (substituted judgment > best interests). Advance directives, POLST. Palliative + hospice. Confidentiality with limits. Conscientious objection. Justice. Multidisciplinary.', NULL,
  'easy', 'signs_symptoms', 'review',
  'family_medicine', 'basic_science', 'signs_symptoms', 'adult',
  'Beauchamp + Childress; ACP Ethics Manual', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'Resident ถามเรื่อง medical ethics + decision-making in challenging primary care scenarios'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital — implement quality improvement (QI) program for chronic disease management', '[{"label":"A","text":"No measurement of quality"},{"label":"B","text":"Quality Improvement (QI) in Primary Care (IHI + ACGME)"},{"label":"C","text":"Single intervention without iteration"},{"label":"D","text":"Top-down without team"},{"label":"E","text":"Random change"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Quality Improvement (QI) in Primary Care (IHI + ACGME): (1) **Frameworks**: - **PDSA cycle** (Plan-Do-Study-Act) — iterative small tests of change; - **Model for Improvement** (IHI): aim + measure + change → PDSA; - **Lean** (Toyota production): waste reduction + value stream; - **Six Sigma**: variation reduction; - **Triple/Quadruple/Quintuple Aim**: better population health + experience + lower cost + clinician well-being + equity; (2) **Measure types**: - **Process**: % patients screened, % vaccinated, time to follow-up; - **Outcome**: HbA1c control rate, BP control, hospitalization, mortality; - **Balancing**: unintended consequences; - **Patient experience**: PROMs, satisfaction; - **Cost**: total cost of care, utilization; - **Equity**: stratified outcomes; (3) **Quality measures programs**: - **HEDIS** (NCQA) — most widely used; - **CMS Stars** (Medicare); - **MIPS** (Medicare Merit-based Incentive); - **UDS** (Uniform Data System — FQHCs); - Custom EHR-based registries; (4) **Population health management**: - **Risk stratification** of panel; - **Registries** (disease-specific or risk-based); - **Care gaps** identification + outreach; - **Care management** for high-risk; (5) **Practice transformation**: - **PCMH** (Patient-Centered Medical Home); - **Health home models**; - **Team-based care**; - **Integrated behavioral health**; - **Community partnerships** addressing SDOH; (6) **Data + analytics**: EHR data, claims data, registries, dashboards real-time; (7) **Implementation science**: bridging research to practice; barriers + facilitators; spread + scale; sustainability; (8) **Value-based payment**: alignment with quality + outcomes vs volume; ACOs (Accountable Care Organizations), shared savings, capitation, bundled payments; (9) **Patient + family engagement** in QI: PFACs (Patient + Family Advisory Councils), co-design, surveys, patient stories; (10) **Equity-focused QI**: stratify outcomes by race/ethnicity, language, SES, geography; address disparities; community-based participatory research; (11) **Continuous learning health system**: data → knowledge → practice → outcomes feedback loop; (12) **Workforce + culture**: psychological safety, just culture, learning orientation; (13) **Multidisciplinary QI team**: leadership + clinicians + nurses + MAs + data analytics + quality + IT + administration + patients + community

---

QI: PDSA cycles + Model for Improvement. Triple/Quadruple/Quintuple Aim. Process + outcome + balancing + experience + cost + equity measures. HEDIS, CMS Stars, MIPS. Population health, PCMH, value-based. Equity-focused. Multidisciplinary team.', NULL,
  'medium', 'signs_symptoms', 'review',
  'family_medicine', 'ems_mgmt', 'signs_symptoms', 'adult',
  'IHI Model for Improvement; NCQA; CMS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'Hospital — implement quality improvement (QI) program for chronic disease management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital — implement EHR-based clinical decision support (CDS) — improve quality + safety', '[{"label":"A","text":"Random alerts for everything"},{"label":"B","text":"EHR + Clinical Decision Support (CDS) (ONC + AMIA)"},{"label":"C","text":"Avoid all technology"},{"label":"D","text":"Single CDS rule without monitoring"},{"label":"E","text":"Ignore alert fatigue"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** EHR + Clinical Decision Support (CDS) (ONC + AMIA): (1) **CDS types**: - **Alerts + warnings**: drug-drug interactions, allergies, dose adjustments, abnormal lab follow-up; - **Order sets**: standardized for conditions (sepsis, ACS, asthma admission); - **Smart forms / templates**: structured data, decision support embedded; - **Reminders**: preventive care, follow-up, missed appointments; - **Documentation tools**: SmartPhrases, templates; - **Real-time risk calculators**: ASCVD, FRAX, Wells, HEART; - **Diagnostic assistance**: differential generators, image AI; - **Predictive analytics + ML/AI**: deterioration, readmission, sepsis (e.g., Epic Sepsis Score); - **Population health dashboards**: care gaps, registry; - **Patient-facing CDS**: portal + apps; (2) **Five Rights of CDS** (Bates + Osheroff): right information + right person + right format + right channel + right point in workflow; (3) **Alert fatigue**: too many alerts → ignored; rationalize + customize; high-yield only; severity tiers; (4) **EHR optimization**: usability — top clinician burden; redesign for workflow; voice recognition; ambient AI scribes (Dax, Suki, Abridge) — major emerging — reduces documentation burden + burnout; (5) **Interoperability**: - **FHIR** (Fast Healthcare Interoperability Resources) — standard; - **TEFCA** (Trusted Exchange Framework + Common Agreement); - **Health Information Exchanges** (HIEs); - **CMS interoperability rules**: information blocking prohibition + patient API access; - **USCDI** (US Core Data for Interoperability); (6) **Patient portal + digital tools**: - Messaging (asynchronous); - Lab results; - Appointment + scheduling; - Refills; - Bill pay; - Self-management apps + connected devices (BP, glucose, weight, fitness); - Remote monitoring; (7) **Telemedicine integration**: synchronous (video, audio) + asynchronous; (8) **AI + machine learning**: imaging (radiology, ophthalmology — diabetic retinopathy, dermatology), risk prediction, NLP for documentation, ambient scribing, drug discovery; need: validation, equity (no biased training data), explainability, regulation; (9) **Cybersecurity**: HIPAA compliance, ransomware threats, breach response; (10) **Privacy + ethics**: data ownership, consent, secondary use, equity; (11) **EHR + provider well-being**: usability + meaningful use lead to burnout; optimization + workflow + scribe + AI assistance critical; (12) **Implementation considerations**: change management, training, super-users, ongoing optimization, governance; (13) **Multidisciplinary**: clinicians + IT + informatics + nursing + administration + patients + regulatory

---

CDS: 5 rights. Types (alerts, order sets, reminders, calculators, AI). Alert fatigue management. Optimization + ambient AI scribes for burden. FHIR + interoperability + TEFCA. Patient portal + digital tools. AI considerations. Cybersecurity. Multidisciplinary.', NULL,
  'medium', 'signs_symptoms', 'review',
  'family_medicine', 'ems_mgmt', 'signs_symptoms', 'adult',
  'ONC; AMIA; HIMSS; Bates CDS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'Hospital — implement EHR-based clinical decision support (CDS) — improve quality + safety'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital — high physician + nurse burnout, leadership wants comprehensive wellness program', '[{"label":"A","text":"Yoga sessions only"},{"label":"B","text":"Clinician Burnout + Well-Being (National Academy of Medicine + AMA + AAMC)"},{"label":"C","text":"Just hire more staff temporarily"},{"label":"D","text":"Blame individuals"},{"label":"E","text":"Ignore — natural part of job"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Clinician Burnout + Well-Being (National Academy of Medicine + AMA + AAMC): (1) **Burnout = system problem, not individual failing** — Stanford WellMD framework + NAM report; ~ 50% physicians + nurses meet criteria; (2) **3 dimensions Maslach**: emotional exhaustion + depersonalization + reduced personal accomplishment; (3) **Consequences**: clinician suicide (higher than general population), depression, substance use, turnover, errors, decreased quality, patient experience, cost; quintuple aim added clinician well-being; (4) **Drivers (systems-level)**: - **EHR + documentation burden** — top driver; - **Excessive workload + work-home imbalance**; - **Loss of autonomy + control**; - **Bureaucratic burden**: prior auths, billing, regulations; - **Inefficient workflow**; - **Lack of teamwork support**; - **Practice inefficiency**; - **Values misalignment**; - **Moral injury** (being prevented from doing right thing for patient); - **COVID-19** exacerbated; - **Workplace incivility, microaggressions, harassment**; - **Pay disparities + financial stress** (especially trainees); (5) **System-level interventions (must address — not just individual wellness)**: - **EHR optimization** + ambient AI scribes (major emerging) — reduces documentation; - **Reduce administrative burden** — pre-auth reform, decrease low-value mandates; - **Team-based care** — share workload, top-of-license; - **Workflow optimization**: standing orders, panel management, support staff; - **Adequate staffing + reasonable workload**; - **Schedule flexibility** + part-time options + paid leave; - **Compensation + financial wellness**; - **Mental health resources** + reduce stigma + remove credentialing barriers (state licensure questions about mental health treatment — major issue); - **Peer support programs** + Schwartz Rounds; - **Leadership development + commitment**; - **Just culture** + psychological safety; - **DEI** + anti-discrimination; (6) **Individual interventions** (necessary but not sufficient): - Mindfulness, exercise, sleep, nutrition; - Hobbies + relationships; - Therapy + EAP; - Boundary-setting; - Self-compassion; - Peer support; (7) **Measurement**: Maslach Burnout Inventory, Mini Z, Professional Fulfillment Index, regular surveys; (8) **Chief Wellness Officer** model + dedicated resources; (9) **Trainee wellness**: specific attention residents + students; (10) **Suicide prevention** for clinicians: 988, physician-specific resources, addressing barriers to help-seeking; (11) **Workforce shortages** worsening — burnout drives; pipeline + retention; (12) **Multidisciplinary**: leadership + clinicians + HR + IT + administration + employee assistance + mental health + national advocacy

---

Burnout: system problem (NAM). EHR/admin burden top drivers. System interventions: EHR optimization + ambient AI scribes, reduce admin, team-based, workflow, staffing, mental health access, peer support, leadership commitment. Individual necessary but insufficient. Multidisciplinary.', NULL,
  'easy', 'signs_symptoms', 'review',
  'family_medicine', 'ems_mgmt', 'signs_symptoms', 'adult',
  'NAM Clinician Burnout 2019; AMA; AAMC', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'Hospital — high physician + nurse burnout, leadership wants comprehensive wellness program'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี multimorbid (T2DM + HTN + obesity + depression) — multiple challenging behavior changes (diet, exercise, smoking, adherence)', '[{"label":"A","text":"Lecture patient"},{"label":"B","text":"Behavior Change + Health Coaching (Motivational Interviewing + Lifestyle Medicine)"},{"label":"C","text":"Single visit advice"},{"label":"D","text":"Punitive approach"},{"label":"E","text":"Ignore — patient must want to change"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Behavior Change + Health Coaching (Motivational Interviewing + Lifestyle Medicine): (1) **Transtheoretical Model (stages of change)**: precontemplation → contemplation → preparation → action → maintenance → (relapse common, part of process); identify stage + match intervention; (2) **Motivational Interviewing (MI) — evidence-based for many conditions**: - **Spirit**: partnership + acceptance + compassion + evocation; - **OARS skills**: Open-ended questions + Affirmations + Reflective listening + Summaries; - **Eliciting change talk** + responding to sustain talk; - **Importance + confidence rulers** + decisional balance; - **Develop discrepancy** between current behavior + values/goals; - **Respect autonomy + roll with resistance**; - Effective brief in primary care; (3) **Goal-setting SMART**: Specific + Measurable + Achievable + Relevant + Time-bound; small wins build momentum; (4) **Health coaching model** (CDC, NBHWC certified): - Patient-centered, partnership; - Strengths-based; - Health behavior change focus; - Multiple sessions over time; - Often non-physician coach (RN, social worker, CHW, certified coach); - Evidence for chronic disease management; (5) **Habit formation (BJ Fogg, James Clear)**: - **Tiny habits** + behavior anchoring; - **Cue-routine-reward** framework; - **Environment design** (make easy what want, hard what don''t); - **Identity-based change** (''I am a non-smoker''); - **Implementation intentions** (if-then plans); (6) **Self-efficacy (Bandura)**: mastery experiences + vicarious + verbal persuasion + emotional state; foundation; (7) **Social ecological model**: individual + interpersonal + organizational + community + policy; address multiple levels; (8) **Group-based programs evidence-based**: - **Diabetes Prevention Program (DPP)** — 58% T2DM reduction; CDC-recognized; - **Living Well with Chronic Conditions** (Stanford CDSMP); - **MOVE!** (VA weight management); - **Cardiac rehab**; - **Pulmonary rehab**; (9) **Technology-supported**: apps (Headspace, MyFitnessPal, Calm, etc.), wearables, text-based programs, virtual coaching, gamification; (10) **Address SDOH barriers** — food security, transportation, financial, housing, social support; (11) **Treat comorbidity**: depression interferes with behavior change → CoCM; (12) **Family + social involvement**; (13) **Multidisciplinary integrative**: PCP + health coach + dietitian + behavioral health + community resources + family + group programs

---

Behavior change: stages (TTM). MI skills (OARS). SMART goals. Health coaching. Habit formation. Self-efficacy. Group programs (DPP). Technology-supported. SDOH + comorbidity. Multidisciplinary integrative.', NULL,
  'easy', 'psych_behavior', 'review',
  'family_medicine', 'integrative', 'psych_behavior', 'adult',
  'Miller + Rollnick MI; ACLM', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี multimorbid (T2DM + HTN + obesity + depression) — multiple challenging behavior changes (diet, exercise, smoking, adherence)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 75 ปี multimorbid (HF + COPD + DM + dementia) — D/C from hospital — high readmission risk; primary care responsibility', '[{"label":"A","text":"No follow-up needed"},{"label":"B","text":"Care Transitions (Hospital to Home) — Integrative Primary Care (CMS + Coleman Care Transitions)"},{"label":"C","text":"Send to ER for issues"},{"label":"D","text":"Discharge to nursing home only"},{"label":"E","text":"Single specialist handles all"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Care Transitions (Hospital to Home) — Integrative Primary Care (CMS + Coleman Care Transitions): (1) **High-risk for 30-d readmission** (~ 25-30% Medicare): multimorbid, elderly, prior admissions, complex meds, social isolation, low health literacy, mental health, SDOH challenges, dementia; (2) **Evidence-based care transitions interventions**: - **Care Transitions Intervention (Coleman)** — coach over 4 wk + 4 pillars: medication self-management + PHR (personal health record) + follow-up + red flags + role of PCP; - **Project RED** (Re-Engineered Discharge); - **Transitional Care Model** (Naylor) — APN-led, evidence for older adults with HF + others; - **BOOST** (Better Outcomes by Optimizing Safe Transitions); - All show ~ 20-50% readmission reduction; (3) **Hospital → primary care handoff**: - Discharge summary timely (ideally before first PCP visit); structured + complete (diagnosis, hospital course, meds + reconciliation, follow-up needs, pending tests, contingency plans); - Direct communication (call, secure message) for complex; - Warm handoff for high-risk; (4) **Early follow-up (within 7-14 days)** PCP visit — telemedicine acceptable some; sooner for highest-risk; (5) **Medication reconciliation** — high error point: - List from multiple sources (hospital, prior med list, patient/family, pharmacy); - Identify discrepancies + clarify; - Simplify regimen; - Address cost; - Patient/family understanding of changes; - Pharmacist involvement valuable; (6) **Care management** for high-risk: - Telephonic outreach; - Home visits selected; - RN/social work coordinator; - Risk stratification; (7) **Patient + family education**: - Teach-back method; - Health literacy considerations; - Written + visual materials; - Action plan / red flags / when to call; - Self-management skills; (8) **Address SDOH**: transportation, food security, home environment, caregiver burden, financial; (9) **Connect to community resources**: meals, transportation, social services, support groups, faith community; (10) **Behavioral health**: depression common post-hospital; CoCM; (11) **Advance care planning + goals of care**; (12) **Coordination with specialists + post-acute (SNF, home health, hospice)** — continuity; (13) **Health IT**: EHR alerts for ED visits/admissions, ADT (admission discharge transfer) notifications; (14) **Quality measures**: 30-d readmission, follow-up timeliness; CMS programs; (15) **Family medicine well-positioned** for integrative transitions — relationship continuity + comprehensive view; (16) **Multidisciplinary**: PCP + care manager + pharmacy + social work + home health + specialty + family + community + behavioral health

---

Care transitions: high-risk readmission. Evidence-based (Coleman, Project RED, TCM). Hospital → PCP handoff. Early F/U 7-14 d. Medication reconciliation. Care management high-risk. Patient/family education + teach-back. SDOH + behavioral + ACP. Multidisciplinary.', NULL,
  'medium', 'signs_symptoms', 'review',
  'family_medicine', 'integrative', 'signs_symptoms', 'adult',
  'Coleman Care Transitions; Naylor TCM; CMS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 75 ปี multimorbid (HF + COPD + DM + dementia) — D/C from hospital — high readmission risk; primary care responsibility'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี BMI 35 — snoring, witnessed apneas, daytime sleepiness; Epworth 14; STOP-BANG 6', '[{"label":"A","text":"Ignore — just snoring"},{"label":"B","text":"OSA Diagnosis + Management (AASM 2017 + AAFP)"},{"label":"C","text":"Long-term sedative"},{"label":"D","text":"Single CPAP without follow-up"},{"label":"E","text":"Surgery first-line for all"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** OSA Diagnosis + Management (AASM 2017 + AAFP): (1) **High-risk screening**: STOP-BANG ≥ 3 = increased risk (≥ 5 high), Epworth Sleepiness Scale > 10 = excessive daytime sleepiness; (2) **Diagnostic test**: - **Home sleep apnea testing (HSAT)** — first-line in uncomplicated suspected OSA without comorbidity; - **In-lab polysomnography** for: complex comorbidity (HF, COPD, neuro), suspected non-OSA sleep disorder, HSAT negative with persistent symptoms, central apnea suspected, pediatric; (3) **AHI severity**: mild 5-14, moderate 15-29, severe ≥ 30; oxygen desaturation index also; (4) **Treatment**: - **CPAP first-line** — most effective; adherence challenge (~ 50%); auto-titrating (APAP) acceptable for most; - **Mask fit critical**: nasal pillows, nasal mask, full-face — patient preference + comfort; - **Heated humidification, ramp, EPR** improve comfort; - **Oral appliance** (mandibular advancement device) for mild-moderate, CPAP intolerant, positional OSA; dental sleep medicine; - **Positional therapy** for positional-dependent (sleep on side); - **Weight loss** — major impact (10% weight = ~ 26% AHI reduction); structured programs; bariatric surgery for severe obesity; - **Hypoglossal nerve stimulator** (Inspire) — for moderate-severe + CPAP-intolerant + BMI < 35 + non-concentric collapse; - **Surgical** (UPPP, maxillomandibular advancement) — selected, ENT/oral surgery; - **GLP-1 RA** (tirzepatide approved for OSA in obese 2024) — major emerging option (SURMOUNT-OSA); (5) **Address comorbidity**: HTN (resistant — OSA strongly associated), DM, AFib, HF, depression, GERD, stroke risk; (6) **Driver safety counseling** — sleepy driving, motor vehicle crash risk; mandatory reporting (commercial drivers); (7) **Avoid worsening factors**: alcohol, sedatives, supine sleep; (8) **CPAP adherence**: education, mask refit, troubleshoot side effects (nasal congestion, dry mouth, leak), behavioral support, monitoring via wireless data; (9) **Follow-up**: 1-3 mo initially with adherence data + symptoms; q 6-12 mo when stable; (10) **Central sleep apnea** — different (HF, opioid, stroke, idiopathic) — ASV (adaptive servo-ventilation) avoid in HFrEF (SERVE-HF mortality); (11) **Multidisciplinary**: PCP + sleep medicine + ENT + dental sleep + dietitian + bariatric + behavioral health

---

OSA: STOP-BANG screen, HSAT or PSG diagnosis. CPAP first-line (adherence challenge — support). Oral appliance, positional, weight loss alternatives/adjuncts. Hypoglossal stim selected. GLP-1 (tirzepatide) emerging. Address comorbidity + driver safety. Multidisciplinary.', NULL,
  'easy', 'respiratory', 'review',
  'family_medicine', 'clinical_decision', 'respiratory', 'adult',
  'AASM OSA 2017; AAFP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี BMI 35 — snoring, witnessed apneas, daytime sleepiness; Epworth 14; STOP-BANG 6'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 30 ปี — fever 39.5 + severe headache + retro-orbital pain + myalgia + petechiae × 4 d; Bangkok, มีคนใน ครัวเรือนป่วยคล้ายกัน; CBC: Hb 14, Hct 48, Plt 95k, WBC 3.2', '[{"label":"A","text":"Aspirin + ibuprofen for fever"},{"label":"B","text":"Dengue Fever Outpatient Management (WHO 2009 + Thai MOH)"},{"label":"C","text":"Ignore — common cold"},{"label":"D","text":"Antibiotic empirically"},{"label":"E","text":"Discharge without follow-up CBC"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Dengue Fever Outpatient Management (WHO 2009 + Thai MOH): (1) **High prevalence Southeast Asia** — major concern Thai primary care; 4 serotypes (DENV 1-4) — secondary infection different serotype = higher severe risk (ADE); (2) **Phases**: febrile (1-3 d) → critical (4-7 d — plasma leak risk) → recovery; (3) **WHO 2009 classification**: - **Dengue without warning signs**: fever + 2 of (NV, rash, aches, leukopenia, +tourniquet) + endemic area; - **Dengue with warning signs**: abd pain, persistent vomit, fluid accumulation, mucosal bleed, lethargy, hepatomegaly, ↑ Hct + ↓ Plt; - **Severe dengue**: plasma leak shock, severe bleed, organ impairment; (4) **Diagnosis**: NS1 antigen (early, 1-7 d), IgM (after 5 d), IgG (secondary infection or past), RT-PCR; CBC trends critical (Hct rising + Plt dropping = warning); (5) **Outpatient management** (no warning signs, can drink, urinating, stable): - **Hydration** oral (ORS, water, juice); avoid dark drinks (mask hemorrhage); - **Antipyretic acetaminophen** (paracetamol) — NEVER aspirin, NEVER NSAIDs (bleeding + Reye); - **Daily monitoring**: CBC (esp days 3-7) — track Hct + Plt; clinical reassessment; - **Warning signs education** — return to ER (esp days 4-6); - Rest; (6) **Admission indications**: - Warning signs (any); - Severe dehydration / inability to drink; - Hct rising (plasma leak); - Plt < 20-50k; - Mucosal bleeding; - Pregnant; - Comorbidity (DM, HT, CKD, hemoglobinopathy); - Social / access issues; - Infants, elderly; (7) **Severe dengue treatment** (inpatient): IV crystalloid carefully titrated; transfusion if severe bleed; ICU; (8) **Prevention**: Aedes mosquito control (eliminate breeding sites, repellent, screens, larvicide); community engagement; (9) **Dengue vaccines**: - **Dengvaxia (CYD-TDV)** — only for seropositive (prior dengue) — Sanofi; complex use; - **Qdenga (TAK-003)** — Takeda — approved many countries 2022-2023 (Thailand approved) — for prior dengue + dengue-naive (broader); 2-dose schedule; - Vaccine ongoing evaluation; (10) **Other arboviruses** differential (Thailand): chikungunya, Zika, malaria, leptospirosis, scrub typhus; (11) **Public health reporting** mandatory; (12) **Multidisciplinary**: PCP + ID + ICU + public health + vector control + community

---

Dengue (Thai context): WHO classification. Outpatient if no warning signs — oral hydration, paracetamol ONLY (no NSAIDs/aspirin), daily CBC monitoring days 3-7. Warning signs → admit. Severe → ICU. Aedes control + new vaccines (Qdenga). Multidisciplinary + public health.', NULL,
  'medium', 'id', 'review',
  'family_medicine', 'clinical_decision', 'id', 'adult',
  'WHO Dengue 2009; Thai MOH', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 30 ปี — fever 39.5 + severe headache + retro-orbital pain + myalgia + petechiae × 4 d; Bangkok, มีคนใน ครัวเรือนป่วยคล้ายกัน; CBC: Hb 14, Hct 48, Plt 95k, WBC 3.2'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี ชาวนา northeast Thailand T2DM — fever + cough + lung infiltrate × 1 wk, history of soil/water exposure', '[{"label":"A","text":"Standard CAP antibiotic"},{"label":"B","text":"Melioidosis (Burkholderia pseudomallei) — Endemic SE Asia (esp NE Thailand)"},{"label":"C","text":"Single-dose antibiotic"},{"label":"D","text":"No specific therapy"},{"label":"E","text":"Avoid culture — clinical only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Melioidosis (Burkholderia pseudomallei) — Endemic SE Asia (esp NE Thailand): (1) **Epidemiology**: B. pseudomallei in soil + water; endemic Thailand (esp Northeast — major TB-like illness), N. Australia, Vietnam, Cambodia, Laos, Malaysia; rainy season peak; high mortality (~ 40% untreated); (2) **Risk factors**: **DM (major — 50%+)**, alcohol use, CKD, chronic lung disease, thalassemia, immunosuppression; occupational soil/water exposure (rice farmers, construction); (3) **Clinical spectrum**: - **Pneumonia** — most common (this patient); - **Bacteremia / septic shock**; - **Soft tissue / skin abscess**; - **Internal organ abscess** (liver, spleen, prostate); - **Disseminated**; - **Localized** (chronic ulcers, lymphadenitis); - **Latent / reactivation** (years later — Vietnam war veterans); (4) **Diagnosis**: - **Culture gold standard** — blood, sputum, pus, throat swab, urine; specific media (Ashdown); lab notify (specific handling — BSL-3); - **Immunofluorescence + PCR** at reference labs; - **IHA (indirect hemagglutination)** serology — limited utility in endemic (background seropositivity); (5) **Treatment** — biphasic, prolonged: - **Intensive phase (2 wk minimum, longer if severe)**: - **Ceftazidime IV** (preferred — first-line) OR; - **Meropenem IV** (severe, septic shock, neuromelioidosis); - TMP-SMX may be added for severe / organ involvement; - **Eradication phase (3-6 mo)**: - **TMP-SMX (Bactrim) PO** first-line; - Alternatives: doxycycline (less effective), amox-clavulanate; - Adherence critical — relapse common with inadequate therapy; (6) **Source control**: drain abscesses, surgical if needed; (7) **Diabetes control** — critical comorbidity; (8) **Avoid**: aminoglycosides + 1st-gen cephalosporins + penicillins (intrinsic resistance); (9) **Follow-up**: clinical + imaging; relapse monitoring; cure rates improving with proper treatment; (10) **Prevention**: occupational protection (gloves, boots, masks for high-risk activities), wound care after soil exposure, DM control; vaccine in development; (11) **Public health reporting** in Thailand; (12) **Differential**: TB (chronic forms similar — coexist often), pyogenic abscess, fungal, glanders, plague; (13) **Multidisciplinary**: PCP + ID + surgery (drainage) + ICU + public health + occupational health

---

Melioidosis: B. pseudomallei endemic NE Thailand. DM + soil exposure key. Pneumonia/sepsis/abscess. Culture diagnosis. Treatment: ceftazidime/meropenem IV intensive 2 wk → TMP-SMX PO 3-6 mo eradication. Source control. DM control. Multidisciplinary.', NULL,
  'hard', 'id', 'review',
  'family_medicine', 'clinical_decision', 'id', 'adult',
  'Thai Melioidosis Guidelines; WHO', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี ชาวนา northeast Thailand T2DM — fever + cough + lung infiltrate × 1 wk, history of soil/water exposure'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 30 ปี healthcare worker immigrated from high-prevalence TB country — annual screening; asymptomatic; CXR normal; PPD induration 12 mm; IGRA positive', '[{"label":"A","text":"No treatment for LTBI"},{"label":"B","text":"Latent TB Infection (LTBI) Management (CDC + ATS + IDSA 2020)"},{"label":"C","text":"9H only — never short-course"},{"label":"D","text":"Antibiotic indefinitely"},{"label":"E","text":"Wait until active TB develops"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Latent TB Infection (LTBI) Management (CDC + ATS + IDSA 2020): (1) **LTBI diagnosis**: positive **TST** (PPD; ≥ 5 mm immunocompromised/recent contact, ≥ 10 mm high-risk, ≥ 15 mm low-risk) OR **IGRA** (QuantiFERON-TB Gold, T-SPOT) — preferred in BCG-vaccinated, less false positive; + no signs/symptoms active TB + normal CXR; (2) **Rule out active TB**: thorough symptoms (cough > 3 wk, fever, night sweats, weight loss, hemoptysis), exam, CXR; sputum AFB + culture + NAAT if any concern; (3) **High-risk for progression** (treat priority): - Recent infection (contact); - HIV + immunocompromised (TNF-i, steroid, organ transplant); - Children < 5 yo; - Silicosis, CKD/dialysis, DM, malnutrition; - Healthcare workers (this patient); - Substance use; - Recent immigration from high-prevalence; (4) **Treatment regimens 2020 CDC update — short-course preferred**: - **3HP** (3 mo): **isoniazid + rifapentine weekly × 12 doses (DOT or SAT)** — preferred adults + children ≥ 2 yo; - **4R** (4 mo): **rifampin daily** — alternative, preferred in HIV + drug interactions of rifapentine; - **3HR** (3 mo): isoniazid + rifampin daily; - **6H or 9H** (older standard): isoniazid daily 6-9 mo — still acceptable + cheaper but longer + lower completion; **2HP** also exists; - **Avoid**: 2RZ (rifampin-pyrazinamide) — hepatotoxicity; (5) **Baseline + monitoring**: LFT (esp pre-existing liver, alcohol, age > 35, HIV), CBC; clinical monitoring + symptom review every visit; stop if LFT > 5x ULN asymptomatic or 3x with symptoms; (6) **Drug interactions** especially rifampin (CYP3A4 inducer — OCP, warfarin, HIV ART, methadone, etc.); (7) **Adherence support** — DOT (directly observed therapy), video DOT, electronic reminders, incentives; (8) **Education**: complete full course (prevents active TB), HIV testing, contact investigation; (9) **Pregnancy**: 9H or 4R; avoid 3HP in pregnancy + breastfeeding (limited data); (10) **HIV testing** for all LTBI (treatment differs, urgent priority); (11) **BCG vaccination history**: doesn''t reliably affect TST interpretation; IGRA preferred; (12) **Contact investigation** + public health collaboration; (13) **Multidisciplinary**: PCP + ID/TB program + public health + occupational health + pharmacy

---

LTBI: TST or IGRA + rule out active TB. **Short-course preferred** — 3HP (weekly INH-rifapentine) or 4R (rifampin daily). Baseline LFT + monitoring. Drug interactions (rifampin). Adherence support. HIV testing. Contact investigation. Multidisciplinary.', NULL,
  'medium', 'id', 'review',
  'family_medicine', 'clinical_decision', 'id', 'adult',
  'CDC LTBI 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 30 ปี healthcare worker immigrated from high-prevalence TB country — annual screening; asymptomatic; CXR normal; PPD induration 12 mm; IGRA positive'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 27 ปี — สนใจ HIV PrEP; high-risk MSM; HIV neg, no chronic conditions', '[{"label":"A","text":"Only condoms — no PrEP"},{"label":"B","text":"HIV PrEP in Primary Care (CDC 2021 + WHO)"},{"label":"C","text":"Single antibiotic for prevention"},{"label":"D","text":"Avoid all sexual health discussion"},{"label":"E","text":"No follow-up needed"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** HIV PrEP in Primary Care (CDC 2021 + WHO): (1) **Indications PrEP**: - Sexually active adults + adolescents at substantial risk for HIV; - MSM/TGW (multiple/anonymous partners, condomless, recent STI, sex while substance use); - Heterosexual (partner HIV+ not virally suppressed, multiple partners, condomless, recent STI, sex worker); - PWID (people who inject drugs — sharing, partners HIV+); - Anyone who requests; (2) **Pre-PrEP screening**: - HIV test (4th gen Ag/Ab) — confirm negative within 7 days of starting; - HIV viral load if recent exposure (acute HIV could be Ab-negative); - HBV (HBsAg, anti-HBs, anti-HBc) — vaccinate if not immune; tenofovir treats HBV (be aware reactivation if stops); - Hepatitis C screening; - STI screening (syphilis, chlamydia, gonorrhea — multi-site MSM); - Pregnancy test if applicable (PrEP safe in pregnancy); - Renal function (eGFR ≥ 60 for Truvada; ≥ 30 for Descovy); - Bone density if osteoporosis risk; (3) **PrEP regimens**: - **Daily oral**: - **Truvada (TDF/FTC 300/200 mg)** — FDA-approved 2012; available generic + low-cost; renal monitoring; modest bone density loss; - **Descovy (TAF/FTC 25/200 mg)** — FDA-approved 2019 for MSM/TGW (not for cisgender women receptive vaginal — efficacy not established); better renal + bone profile; more expensive; - **On-demand 2-1-1 (event-driven)** — for MSM only — 2 pills 2-24 h before sex + 1 pill 24 h after first dose + 1 pill 24 h after that (IPERGAY/PROUD); not for cisgender women, vaginal/anal heterosexual sex; - **Long-acting injectable**: - **Cabotegravir (Apretude)** — FDA-approved 2021 — IM injection q 2 mo (after 1 mo loading); high efficacy + adherence; cost + access barriers; - **Future**: lenacapavir SC q 6 mo (PURPOSE-1 + 2 trials 2024); (4) **Monitoring on PrEP**: - HIV test q 3 mo; - STI q 3-6 mo; - Renal (CrCl) q 6 mo; - HBV before; - Pregnancy if applicable; - Adherence + support; (5) **Risk-reduction counseling** + condom use + STI prevention + behavioral support; (6) **DoxyPEP** complement for syphilis + chlamydia/gonorrhea prevention (CDC 2024 — MSM/TGW); (7) **HPV + HepA/B + Mpox vaccination** as appropriate; (8) **Address mental health, substance use, social factors** that affect adherence; (9) **Equity considerations**: black + Latino MSM most affected — access gaps; community programs + Ready, Set, PrEP federal program; trans-affirming care; (10) **PEP** (post-exposure prophylaxis) for unanticipated exposures: 3-drug regimen × 28 days within 72 h; (11) **Multidisciplinary**: PCP + ID + sexual health clinic + pharmacy + community-based organizations + behavioral health

---

HIV PrEP: high-risk individuals. Daily Truvada / Descovy; on-demand 2-1-1 MSM; LAI cabotegravir bimonthly. Pre-screening (HIV, HBV, renal, STI). Monitor q 3-6 mo. Counseling + STI prevention + DoxyPEP + vaccines. Equity. Multidisciplinary.', NULL,
  'easy', 'id', 'review',
  'family_medicine', 'clinical_decision', 'id', 'adult',
  'CDC PrEP 2021', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 27 ปี — สนใจ HIV PrEP; high-risk MSM; HIV neg, no chronic conditions'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี — acute substernal chest pressure radiating to left arm + diaphoresis × 30 min at home; presents to primary care clinic', '[{"label":"A","text":"Outpatient evaluation in 2 weeks"},{"label":"B","text":"Acute Chest Pain — Outpatient Triage (AHA/ACC 2021 Chest Pain)"},{"label":"C","text":"Send home — likely musculoskeletal"},{"label":"D","text":"PO antibiotic"},{"label":"E","text":"Ibuprofen for chest pain"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Chest Pain — Outpatient Triage (AHA/ACC 2021 Chest Pain): (1) **Acute chest pain in OPD = emergency** until ACS, PE, dissection, tension pneumo, esophageal rupture excluded; (2) **Immediate actions in primary care clinic**: - **ECG within 10 min** of presentation; - **ASA 325 mg chewed** (if no allergy + no bleeding) immediately for suspected ACS; - **Call EMS for transport** (don''t drive); - Sublingual NTG if not hypotensive + no PDE5i within 24-48 h; - IV access, oxygen if SpO2 < 90% (avoid hyperoxia), monitor; - Brief history + exam while awaiting EMS; (3) **High-risk features (red flags)**: chest pressure/squeezing, radiation to arm/jaw/neck/back, diaphoresis, dyspnea, NV, syncope, hemodynamic instability, exertional onset, age + CV risk factors (especially DM + women atypical), prior CAD; (4) **Differential life-threatening**: - **ACS** (STEMI, NSTEMI, UA) — ECG + troponin; - **PE** — Wells, D-dimer, CTPA; - **Aortic dissection** — sudden tearing pain, HTN, BP asymmetry, widened mediastinum, CTA; - **Tension pneumothorax** — sudden dyspnea, asymmetric, hemodynamic; - **Esophageal rupture** (Boerhaave); - **Cardiac tamponade**; (5) **Decision tools**: - **HEART score** for ED chest pain risk stratification (history, ECG, age, risk factors, troponin); 0-3 low (discharge), 4-6 moderate (observation), ≥ 7 high (admission); - **TIMI risk score**; - **CCS** angina classification; (6) **Disposition** based on risk: - High risk → ED + cath lab; - Intermediate → ED for further workup; - Low risk → outpatient evaluation (stress test, CCTA) within days; - For ANY uncertain — ED; (7) **STEMI specifically — time-critical**: - Goal door-to-balloon ≤ 90 min PCI capable; - Door-to-needle ≤ 30 min if thrombolytics (PCI > 120 min); - Pre-hospital ECG + STEMI activation; (8) **Outpatient evaluation low-risk** after acute exclude: - Stress test, CCTA per pretest probability; - OMT initiation pending; (9) **Modifiable risk factors** counseling: BP, lipid, glucose, smoking, weight, exercise, diet, mental health; (10) **Cardiac rehab** referral post-event; (11) **Multidisciplinary**: PCP + EMS + ED + cardiology + cath lab + ICU + cardiothoracic surgery + cardiac rehab

---

Acute chest pain in OPD: ECG < 10 min, ASA, EMS, IV access. High-risk → ED. Differential life-threatening (ACS/PE/dissection). HEART/TIMI risk. STEMI time-critical (door-to-balloon ≤ 90 min). Low-risk outpatient evaluation. Multidisciplinary.', NULL,
  'medium', 'cardiovascular', 'review',
  'family_medicine', 'clinical_decision', 'cardiovascular', 'adult',
  'AHA/ACC Chest Pain 2021', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี — acute substernal chest pressure radiating to left arm + diaphoresis × 30 min at home; presents to primary care clinic'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี — unilateral calf swelling + tenderness × 3 d after long flight; no malignancy; Wells score 3 (moderate); D-dimer elevated', '[{"label":"A","text":"Admit all DVT"},{"label":"B","text":"DVT Outpatient Diagnosis + Treatment (CHEST 2021)"},{"label":"C","text":"Aspirin alone for DVT"},{"label":"D","text":"No treatment"},{"label":"E","text":"IVC filter first-line"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** DVT Outpatient Diagnosis + Treatment (CHEST 2021): (1) **Pretest probability — Wells score**: - **Low (0)**: D-dimer negative rules out; - **Moderate (1-2)**: D-dimer; if negative rules out; if positive → US; - **High (≥ 3)** or this patient: **proceed to compression US directly**; - D-dimer less useful in pregnancy, malignancy, surgery, elderly; (2) **Whole-leg vs proximal compression US**: serial proximal US if negative + high suspicion; (3) **Treatment outpatient when stable + reliable**: - **DOACs first-line preferred**: - **Apixaban** 10 mg BID × 7 d → 5 mg BID; - **Rivaroxaban** 15 mg BID × 21 d → 20 mg daily; - **Edoxaban** + **dabigatran** require 5-day initial parenteral anticoagulation; - **Warfarin** with parenteral overlap (LMWH bridge — INR goal 2-3); used less now; - **LMWH** (enoxaparin) — preferred in malignancy (CARAVAGGIO + others show DOACs comparable for many), pregnancy; (4) **Duration**: - **Provoked transient risk factor**: 3 months; - **Provoked persistent / cancer**: indefinite while risk; - **Unprovoked**: 3-6 mo, then reassess for indefinite; - **Recurrent**: indefinite; (5) **Cancer screening** for unprovoked VTE — age-appropriate not extensive; (6) **Inferior vena cava filter** rare — only acute proximal DVT + absolute anticoagulation contraindication; retrievable preferred; (7) **Compression stockings** — no longer routinely recommended for PTS prevention (SOX trial); use for symptoms; (8) **Outpatient eligibility**: stable, no PE / massive DVT, no major bleeding risk, reliable follow-up, access to care, family support; (9) **Patient education**: medication adherence, bleeding signs, drug interactions, lifestyle (avoid prolonged immobility, hydration during travel), recurrence warning signs (new DVT, PE symptoms — sudden dyspnea, pleuritic CP); (10) **Special populations**: - **Pregnancy** — LMWH (DOACs CI); - **Cancer** — DOAC or LMWH; - **Renal impairment** — adjusted dosing; - **Antiphospholipid syndrome** — warfarin preferred (not DOAC per TRAPS); (11) **Post-thrombotic syndrome** prevention + management; (12) **Hypercoagulable workup** selected (young, unusual sites, recurrent, family history); (13) **Multidisciplinary**: PCP + hematology + anticoagulation clinic + pharmacy

---

DVT: Wells + D-dimer or US. Outpatient with DOAC first-line (apixaban, rivaroxaban). Duration based on provocation. LMWH cancer + pregnancy. Patient education + monitoring + anticoagulation clinic. Multidisciplinary.', NULL,
  'medium', 'cardiovascular', 'review',
  'family_medicine', 'clinical_decision', 'cardiovascular', 'adult',
  'CHEST VTE 2021', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี — unilateral calf swelling + tenderness × 3 d after long flight; no malignancy; Wells score 3 (moderate); D-dimer elevated'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 70 ปี — transient left arm weakness + dysarthria × 30 min, resolved; HTN, DM, smoker; ABCD2 score 5', '[{"label":"A","text":"Outpatient management of acute TIA"},{"label":"B","text":"TIA / Minor Stroke Management (AHA/ASA 2021)"},{"label":"C","text":"No imaging needed"},{"label":"D","text":"Aspirin alone for all"},{"label":"E","text":"Discharge with reassurance"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** TIA / Minor Stroke Management (AHA/ASA 2021): (1) **TIA definition** (modern): transient neuro deficit without infarction on imaging; even brief = high stroke risk; (2) **Urgent evaluation**: ED — must rule out stroke (MRI DWI sensitive for small infarct), stratify risk, initiate prevention; - **ABCD2 score** — older risk stratification; now more about workup completeness + treatment within 24-48 h regardless; (3) **Imaging**: - **MRI brain with DWI** preferred (CT misses small infarcts); - **CTA or MRA neck + brain** — extracranial carotid + intracranial; - **Echo** (TTE + bubble study; TEE if cardioembolic suspected); - **Telemetry / Holter / loop monitor for AFib** detection (longer monitoring catches paroxysmal); (4) **Lab workup**: glucose, lipid, A1c, CBC, coag, RPR, TSH; selected hypercoagulable workup younger; (5) **Acute treatment if stroke confirmed acute**: tPA within 4.5 h (extended window possible with imaging); thrombectomy up to 24 h with imaging selection; (6) **TIA/minor stroke acute medical**: - **Antiplatelet**: - **Aspirin** 325 mg loading then 81 mg daily; - **Dual antiplatelet (DAPT)**: ASA + clopidogrel × 21-90 days for minor stroke / high-risk TIA (CHANCE, POINT) then aspirin alone; - **Aspirin + ticagrelor** (THALES) alternative; - **Statin** high-intensity; - **BP management**: control but avoid acute aggressive lowering in acute stroke; target chronic < 130/80; - **Glycemic control**; (7) **Etiology-specific**: - **Carotid stenosis** > 70% symptomatic → CEA or CAS within 14 d; - **AFib → anticoagulation** (DOAC preferred); - **PFO** selected — closure for cryptogenic stroke; - **Aortic / arch atherosclerosis** — antiplatelet + statin; - **Hypercoagulable** — anticoagulation; (8) **Lifestyle modification + risk factor**: smoking cessation, BP, DM, lipid, weight, exercise, diet (Mediterranean), alcohol; (9) **Patient + family education**: stroke warning signs (BE FAST), call 911 immediately, no driving until cleared, secondary prevention adherence; (10) **Rehabilitation** if deficits + cognitive evaluation; (11) **Mood screening + treatment** — depression common post-stroke; (12) **Driving evaluation** + return-to-work planning; (13) **Multidisciplinary**: PCP + neurology (stroke specialist) + cardiology + vascular surgery + neuroradiology + rehab + behavioral health

---

TIA = high stroke risk — urgent ED workup. MRI DWI + CTA + echo + AFib monitoring. Acute: aspirin + statin + DAPT for high-risk × 21-90 d. Etiology-specific (CEA, anticoag for AFib). Risk factor modification. Multidisciplinary.', NULL,
  'medium', 'neurology', 'review',
  'family_medicine', 'clinical_decision', 'neurology', 'adult',
  'AHA/ASA Stroke 2021', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 70 ปี — transient left arm weakness + dysarthria × 30 min, resolved; HTN, DM, smoker; ABCD2 score 5'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี — brief positional vertigo + nausea × 1 wk, esp when turning over in bed; no hearing loss; Dix-Hallpike positive right', '[{"label":"A","text":"Long-term meclizine daily"},{"label":"B","text":"BPPV (Benign Paroxysmal Positional Vertigo) (AAO-HNS 2017)"},{"label":"C","text":"MRI brain for all dizziness"},{"label":"D","text":"Surgery for BPPV"},{"label":"E","text":"Discharge without maneuver"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** BPPV (Benign Paroxysmal Positional Vertigo) (AAO-HNS 2017): (1) **Most common cause peripheral vertigo**; brief (< 1 min) positional vertigo; otoliths displaced into semicircular canal (most posterior — > 90%); (2) **Diagnosis clinical**: - **Dix-Hallpike maneuver** for posterior canal — classic upbeat-torsional nystagmus, latency 5-20 s, fatigability, duration < 1 min; - **Supine roll test** for horizontal canal; - **Anterior canal** rare; (3) **No imaging routinely** — only for atypical features or red flags; (4) **Differential** (HiNTS to rule out central): - Vestibular neuritis (continuous vertigo, no positional); - Meniere''s (vertigo + hearing loss + tinnitus); - Vestibular migraine; - Cerebellar stroke (HiNTS exam — head impulse, nystagmus, test skew); - Acoustic neuroma (slow progression hearing loss); - MS; (5) **HiNTS Plus exam** for acute vestibular syndrome differentiating peripheral vs central (more accurate than MRI in first 24-48 h): - Head impulse test: abnormal = peripheral; - Nystagmus: direction-changing = central; - Test of skew: present = central; - + new hearing loss = central possible (AICA stroke); (6) **Treatment BPPV — canalith repositioning** (highly effective): - **Epley maneuver** for posterior canal BPPV — first-line; multiple cycles if needed; ~ 80% success first attempt; can teach home self-Epley; - **Semont** alternative posterior; - **Lempert (BBQ roll)** or Gufoni for horizontal canal; - Don''t routinely restrict activity after (post-Epley restrictions removed in updated guideline); (7) **Vestibular suppressants (meclizine, benzodiazepines)** — LIMITED use; avoid as primary treatment (don''t address pathology; slow vestibular compensation; falls in elderly); short-term symptom relief only; (8) **Vestibular rehabilitation** if persistent, recurrent, or non-classic; PT-vestibular therapist; (9) **Recurrent BPPV**: re-treat + investigate underlying (vitamin D deficiency association, head trauma, viral, vestibular neuritis, age); supplementation vit D may help recurrences; (10) **Patient education**: condition benign, recurrence possible, when to seek; (11) **Multidisciplinary**: PCP + vestibular PT + ENT/otology + neurology if uncertain

---

BPPV: brief positional vertigo. Dix-Hallpike diagnosis posterior canal. **Epley maneuver** first-line — highly effective. Differentiate central (HiNTS). Vestibular suppressants limited role. Vestibular rehab for persistent. Multidisciplinary.', NULL,
  'easy', 'neurology', 'review',
  'family_medicine', 'clinical_decision', 'neurology', 'adult',
  'AAO-HNS BPPV 2017', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี — brief positional vertigo + nausea × 1 wk, esp when turning over in bed; no hearing loss; Dix-Hallpike positive right'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 25 ปี — chronic nasal congestion + sneezing + clear rhinorrhea + itchy eyes — perennial, worse spring + fall', '[{"label":"A","text":"Long-term first-gen antihistamine"},{"label":"B","text":"Allergic Rhinitis Management (ARIA + AAAAI + ACAAI 2017)"},{"label":"C","text":"Oral steroid daily"},{"label":"D","text":"Long-term oxymetazoline"},{"label":"E","text":"No treatment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Allergic Rhinitis Management (ARIA + AAAAI + ACAAI 2017): (1) **Classification ARIA**: intermittent vs persistent; mild vs moderate-severe based on QOL impact; perennial vs seasonal less used; (2) **Workup**: history + exam (pale boggy turbinates, allergic shiners, nasal crease, postnasal drip); allergy testing (skin prick or serum specific IgE) for refractory or immunotherapy consideration; rule out other (vasomotor, infection, atrophic, drug-induced — rebound from oxymetazoline / cocaine / chronic decongestants); (3) **Stepwise treatment**: - **Allergen avoidance** (variable feasibility): HEPA filters, mattress + pillow encasings, weekly hot wash bedding, vacuum w/ HEPA, indoor humidity 30-50%, pet exposure reduction, pollen exposure (close windows, AC, shower after outdoor); - **First-line single agent**: - **Intranasal corticosteroid (INCS)** — fluticasone, mometasone, budesonide, triamcinolone — most effective overall (PARS recommends as first-line monotherapy); start before pollen season; correct technique critical (aim laterally, not septum, no sniff); - **Oral 2nd-gen antihistamines** (cetirizine, loratadine, fexofenadine, desloratadine, levocetirizine) — for mild + adjunct; less effective than INCS for congestion; - **Combination**: INCS + oral antihistamine OR INCS + intranasal antihistamine (azelastine) for moderate-severe; - **Leukotriene receptor antagonist** (montelustinakast) — less effective alone; FDA Black Box for neuropsychiatric — avoid first-line; - **Saline irrigation** (Neti pot, sinus rinse) — adjunct; (4) **Eye symptoms**: topical antihistamine-mast cell stabilizer (olopatadine, ketotifen), oral antihistamine; (5) **Refractory**: - **Allergen immunotherapy (AIT)** — subcutaneous (SCIT) or sublingual (SLIT — tablets for grass, ragweed, dust mite, others); 3-5 yr course; modifies disease + reduces asthma development; refer allergist; - **Anti-IgE (omalizumab)** for severe with asthma; - **Biologics** emerging; - Surgery for nasal obstruction (septal, polyps, turbinate); (6) **First-gen antihistamines** (diphenhydramine, chlorpheniramine, hydroxyzine) — avoid for routine (sedation, anticholinergic, falls, cognition); Beers Criteria PIM; (7) **Avoid prolonged oxymetazoline** > 3-5 days (rhinitis medicamentosa rebound); (8) **Comorbidity**: asthma (allergic rhinitis is risk factor + comorbidity — treat both), atopic dermatitis, conjunctivitis, sinusitis, sleep disordered breathing, OSA; (9) **Pregnancy**: INCS + 2nd-gen antihistamines (loratadine, cetirizine) generally safe; (10) **Multidisciplinary**: PCP + allergy/immunology + ENT (refractory, structural) + ophthalmology

---

Allergic rhinitis: ARIA classification. INCS first-line (correct technique). Oral 2nd-gen antihistamine adjunct. Saline irrigation. Avoid first-gen antihistamines + chronic decongestants. Allergen immunotherapy for refractory + modifies disease. Treat comorbidities. Multidisciplinary.', NULL,
  'easy', 'id', 'review',
  'family_medicine', 'clinical_decision', 'id', 'adult',
  'ARIA 2017; AAAAI', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 25 ปี — chronic nasal congestion + sneezing + clear rhinorrhea + itchy eyes — perennial, worse spring + fall'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'นักเรียนอายุ 16 ปี รักบี้ — fall + helmet impact + brief LOC + headache + confusion × 2 hr, no focal deficit; ER imaging negative; F/U PCP', '[{"label":"A","text":"Same-day return to play if asymptomatic"},{"label":"B","text":"Sport-Related Concussion (Berlin/Amsterdam Consensus + AAN)"},{"label":"C","text":"Strict bed rest 2 weeks"},{"label":"D","text":"MRI for every concussion"},{"label":"E","text":"Ignore — kids are resilient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Sport-Related Concussion (Berlin/Amsterdam Consensus + AAN): (1) **Definition**: traumatic brain injury induced by biomechanical forces, with rapid onset of neurological dysfunction; may or may not include LOC; (2) **Acute assessment**: SCAT5 / SCAT6 (Sport Concussion Assessment Tool); rule out cervical spine injury + intracranial bleed; CT for red flags only (LOC > 5 min, GCS < 15, focal deficit, seizure, vomiting, severe headache, skull fracture suspected, anticoagulation); (3) **Symptoms multi-domain**: physical (headache, dizziness, nausea, balance, light/noise sensitivity, fatigue), cognitive (confusion, slowed thinking, memory, concentration), emotional (irritability, sadness, anxiety), sleep; (4) **Management major shift — early active rehabilitation, NOT prolonged rest** (modern evidence): - **Brief initial rest 24-48 h** (relative — light activity OK), then; - **Light aerobic exercise** below symptom threshold (Buffalo Concussion Treadmill Test guides) — strong evidence accelerates recovery; - **Stepwise graduated return to play (GRTP)** — Berlin 6 stages (rest → light → sport-specific → noncontact → contact → return); - Earlier graduated return to learn (RTL) — school accommodations: shorter days, breaks, reduced cognitive load, no testing, quiet environment; - **No same-day return to play** for any suspected concussion (any level + age); (5) **Symptom-specific treatment**: - Vestibular/cervicogenic — vestibular + cervical rehab (PT); - Vision dysfunction — vision therapy; - Headache management; - Sleep hygiene; - Mood — counseling, CBT; - Cognitive rehab; (6) **Most recover within 2-4 weeks** (children may take longer); **persistent post-concussion symptoms (PPCS)** > 4 wk children / > 1 mo adults — multidisciplinary clinic; (7) **Repeat concussion considerations**: - Increased recovery time + risk for prolonged symptoms; - **Second impact syndrome** — rare, catastrophic — return-to-play before recovery; - **CTE (chronic traumatic encephalopathy)** — long-term concern repeated head impacts; - Career considerations if recurrent; (8) **Pediatric considerations**: longer recovery + more conservative; school + family support critical; (9) **Equipment + rules** for prevention; mouthguards limited evidence; helmets reduce skull fracture not concussion; (10) **Documentation**: every concussion documented; return-to-play medical clearance required; (11) **Mental health screening + management** if persistent or pre-existing; (12) **Multidisciplinary**: PCP + sports medicine + neurology + vestibular PT + vision therapy + neuropsych + mental health + ATC + school + family

---

Concussion: SCAT assessment + rule out cervical/ICH. **Brief rest then early active rehab** (NOT prolonged rest). Graduated return to play + learn. Symptom-specific treatment. Multidisciplinary. **NO same-day RTP**. Watch persistent + repeat. Multidisciplinary.', NULL,
  'medium', 'neurology', 'review',
  'family_medicine', 'clinical_decision', 'neurology', 'peds',
  'Berlin/Amsterdam Concussion Consensus', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'นักเรียนอายุ 16 ปี รักบี้ — fall + helmet impact + brief LOC + headache + confusion × 2 hr, no focal deficit; ER imaging negative; F/U PCP'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี — fatigue, muscle weakness; 25-OH vitamin D = 14 ng/mL', '[{"label":"A","text":"High-dose long-term for all"},{"label":"B","text":"Vitamin D Deficiency Management (Endocrine Society 2024 + IOM)"},{"label":"C","text":"No treatment for deficiency"},{"label":"D","text":"Universal screening all adults"},{"label":"E","text":"IV vitamin D for mild deficiency"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Vitamin D Deficiency Management (Endocrine Society 2024 + IOM): (1) **Definitions** (controversy): - **Endocrine Society**: deficiency < 20 ng/mL (50 nmol/L), insufficiency 20-29; goal > 30; - **IOM/USPSTF**: deficiency < 12, sufficient ≥ 20; lower thresholds; - **Endocrine Society 2024 updated guidelines**: less aggressive screening + supplementation than 2011; (2) **Screening — USPSTF + Endocrine Society 2024**: NOT routine for asymptomatic adults; targeted high-risk: - Symptoms (fatigue, bone pain, weakness, falls); - Osteoporosis/fracture; - Malabsorption (celiac, IBD, post-bariatric); - CKD, hepatic disease; - Obesity (sequestration); - Limited sun exposure / dark skin / elderly housebound; - Medications (anticonvulsants, glucocorticoids, antiretrovirals, antifungals); - Hypercalcemia / hypocalcemia / PTH abnormalities; (3) **Causes**: limited sun, dark skin, latitude, age (skin synthesis ↓), obesity, malabsorption, CKD/liver disease, medications, hereditary; (4) **Replacement**: - **Vitamin D3 (cholecalciferol)** preferred over D2 (ergocalciferol) — more potent + longer half-life; - **Loading**: 50,000 IU weekly × 8 wk OR 6,000 IU daily × 8 wk for deficiency; - **Maintenance**: 1,000-2,000 IU daily (some recommend up to 4,000 IU); obese may need more; - **Recheck 25-OH** 8-12 wk; goal > 30 (or > 20 per IOM); - **Calcium**: dietary preferred (dairy, fortified, leafy greens); supplement if intake inadequate (1000-1200 mg total daily — recent caution CV calcium supplements); (5) **Toxicity rare**: > 100 ng/mL associated with hypercalcemia, nephrolithiasis, vascular calcification; usually require > 10,000 IU daily for months; (6) **Outcomes evidence — modest**: - **Falls + fracture prevention** — most evidence in deficient + elderly + institutionalized; modest in community-dwelling sufficient; - **Bone health** — clear with deficiency; - **VITAL trial** — no cardiovascular or cancer overall benefit in vitamin D sufficient population (negative trial); - **COVID, depression, autoimmune** — limited evidence; (7) **Don''t over-supplement** — avoid mega-doses if not deficient; (8) **Address other causes** of symptoms (TSH, B12, iron, depression, sleep, OSA, anemia, electrolyte); (9) **Lifestyle**: moderate sun exposure (10-15 min midday face + arms several times/wk balanced with skin cancer prevention), weight-bearing exercise, balanced diet; (10) **Pregnancy + lactation**: 600-1,500 IU daily; lactation maternal high-dose can replete infant; (11) **Multidisciplinary**: PCP + endocrine if refractory + dietitian

---

Vitamin D deficiency: targeted screening (Endocrine 2024 less aggressive). D3 preferred. Loading 50,000 IU weekly × 8 wk; maintenance 1,000-2,000 IU daily. Recheck. Address other symptom causes. Lifestyle + sun. VITAL — no CV/cancer benefit in sufficient. Multidisciplinary.', NULL,
  'easy', 'endocrine_metabolic', 'review',
  'family_medicine', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'Endocrine Society Vit D 2024; IOM', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี — fatigue, muscle weakness; 25-OH vitamin D = 14 ng/mL'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิงอายุ 35 ปี — Pap smear: HSIL; high-risk HPV positive', '[{"label":"A","text":"Hysterectomy for all HSIL"},{"label":"B","text":"Abnormal Pap Smear Management (ASCCP 2019 Risk-Based Guidelines)"},{"label":"C","text":"Repeat Pap in 1 yr"},{"label":"D","text":"No further evaluation"},{"label":"E","text":"Topical cream only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Abnormal Pap Smear Management (ASCCP 2019 Risk-Based Guidelines): (1) **ASCCP 2019 shift to risk-based** (not just result-based) — uses prior history + current screen + HPV result; (2) **HSIL Pap with HPV+** — high CIN3+ risk: - **Colposcopy with biopsy** — direct visualization + targeted biopsy + endocervical sampling; - Alternative: see-and-treat (immediate excision) for some adults; (3) **Excisional treatment if CIN2/3 confirmed**: - **LEEP (loop electrosurgical excision procedure)** — most common, outpatient, local anesthesia; - **Cold knife conization** — alternative; - **Ablative** (cryotherapy, laser, thermal) for selected CIN2 — must rule out invasion first; - For young + want fertility — consider observation CIN2 (regression possible); (4) **Other Pap results management** (ASCCP 2019): - **ASC-US**: HPV reflex; if positive → colposcopy or repeat 1 yr based on risk; - **LSIL**: colposcopy; - **HSIL or ASC-H**: colposcopy + biopsy; - **AGC (atypical glandular)**: colposcopy + endocervical sampling + endometrial sampling if ≥ 35 or abnormal bleeding; (5) **Special populations**: - **Pregnancy**: colposcopy OK (no ECC); excision only if invasion suspected; defer to postpartum if CIN; - **Adolescents** (< 21): no screening (HPV rapid clearance); - **Post-menopausal**: same screening criteria; (6) **Post-treatment surveillance**: 6 mo HPV + cytology + colposcopy; then per risk; lifelong increased surveillance even after; (7) **HPV vaccination** — primary prevention + can offer post-treatment (limited evidence reduce recurrence; CDC + ACS recommend through age 26, shared decision 27-45); 9-valent Gardasil (HPV 6, 11, 16, 18, 31, 33, 45, 52, 58) — most effective; (8) **Cervical cancer screening modernization**: - **HPV primary screening** every 5 yr starting age 25 (ACS 2020 update — earlier transition); - Co-testing or cytology alone still acceptable; - Stop screening > 65 if adequate prior negative; - Hysterectomy with cervix removed for benign → stop; (9) **Patient counseling**: HPV common, most clears, treatment effective, smoking cessation (cofactor); (10) **Cervical cancer 2030 elimination goal (WHO)** — vaccination + screening + treatment; (11) **Multidisciplinary**: PCP + gyn / gyn-onc + colposcopist + cytopathology + patient

---

Abnormal Pap: ASCCP 2019 risk-based. HSIL → colposcopy + biopsy + LEEP/conization if CIN2/3. Post-treatment surveillance. HPV vaccination primary prevention. HPV primary screening modernization. Pregnancy considerations. Multidisciplinary.', NULL,
  'medium', 'obgyn', 'review',
  'family_medicine', 'clinical_decision', 'obgyn', 'adult',
  'ASCCP 2019; ACS 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยหญิงอายุ 35 ปี — Pap smear: HSIL; high-risk HPV positive'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิงอายุ 22 ปี — condom break 12 hr ago; LMP 14 d ago; ขอ emergency contraception (EC)', '[{"label":"A","text":"Refuse — not within 24 hours"},{"label":"B","text":"Emergency Contraception (ACOG + WHO 2024)"},{"label":"C","text":"Wait until pregnancy confirmed"},{"label":"D","text":"Random pill"},{"label":"E","text":"Only married women"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Emergency Contraception (ACOG + WHO 2024): (1) **Options effectiveness (most to least)**: - **Copper IUD (Cu-IUD)** — most effective EC (~ 99%); insert within 5 days (some up to 7); ongoing contraception 10+ years bonus; can be inserted any time in cycle; - **Levonorgestrel (LNG) 52 mg IUD** (Mirena, Liletta) — recent evidence equally effective as Cu-IUD (Turok 2021); ongoing contraception; - **Ulipristal acetate (UPA, Ella) 30 mg PO** — effective up to 120 hr (5 d); more effective than LNG, especially BMI > 25 or close to ovulation; - **Levonorgestrel 1.5 mg PO** (Plan B, Next Choice) — effective up to 72 hr (declining); OTC US, less effective if BMI > 25; - **Yuzpe (combined OCP)** — older, less effective + more SE (nausea); rarely used now; (2) **Mechanism**: primarily delay or inhibit ovulation; not abortifacient (does not affect established pregnancy); (3) **Counseling**: - Effectiveness varies by timing (sooner better); - Resume regular contraception immediately; - Quick start hormonal contraception after LNG (wait 5 d after UPA — anti-progestin effect); - Next menses may be early/late ± 7 d; if > 1 wk late — pregnancy test; - Side effects (nausea, headache, fatigue); - Confidentiality + access (some pharmacies); - Not for ongoing contraception; (4) **Repeat use OK** within same cycle if needed; (5) **Sexual assault** — additional considerations: STI prophylaxis, HIV PEP if indicated, forensic exam (SANE), mental health support, mandatory reporting if minor + jurisdiction; (6) **Cu-IUD specific benefit**: high BMI (LNG less effective; UPA modest effect), close to ovulation (when oral EC less effective), wanting ongoing LARC; (7) **Contraindications**: known pregnancy (just won''t work, not harmful), UPA + LNG IUDs avoid in undiagnosed bleeding; (8) **OTC + Rx access**: LNG OTC US all ages (Plan B); UPA Rx-only US (Ella); IUDs require provider; (9) **Address ongoing contraceptive needs** — LARC counseling; (10) **STI screening** + offer testing; (11) **Multidisciplinary**: PCP + pharmacy + gyn / family planning + community resources

---

EC: most effective Cu-IUD (or LNG-IUD) within 5 d. UPA up to 120 hr (better BMI > 25). LNG up to 72 hr (OTC). Mechanism — delay ovulation. Address ongoing contraception. STI screening. Sexual assault considerations. Multidisciplinary.', NULL,
  'easy', 'obgyn', 'review',
  'family_medicine', 'clinical_decision', 'obgyn', 'adult',
  'ACOG EC; WHO 2024', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยหญิงอายุ 22 ปี — condom break 12 hr ago; LMP 14 d ago; ขอ emergency contraception (EC)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 40 ปี — incidental HBsAg positive; ALT normal; HBeAg neg, anti-HBe pos; HBV DNA 8000 IU/mL; clinically asymptomatic', '[{"label":"A","text":"Treat all HBsAg+ regardless"},{"label":"B","text":"Chronic Hepatitis B Management (AASLD 2018 + 2022 updates)"},{"label":"C","text":"No monitoring"},{"label":"D","text":"Stop antiviral whenever"},{"label":"E","text":"Single test — no follow-up"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Chronic Hepatitis B Management (AASLD 2018 + 2022 updates): (1) **Phases CHB**: - Immune tolerant (HBeAg+, high VL, normal ALT, minimal liver disease — usually young); - HBeAg+ chronic hepatitis (HBeAg+, high VL, elevated ALT, active disease); - HBeAg- chronic infection / inactive carrier (HBeAg-, anti-HBe+, low VL < 2000, normal ALT — this patient close); - HBeAg- chronic hepatitis (HBeAg-, fluctuating VL, ALT — pre-core mutant); - HBsAg- (resolved) but still possible reactivation with immunosuppression; (2) **Baseline workup**: - HBV DNA (quantitative); - HBeAg / anti-HBe; - ALT / AST + LFT; - HBsAg + quantitative; - HCV / HDV / HIV co-infection screen; - Imaging — liver US ± elastography (FibroScan) for fibrosis; - HCC screening baseline (AFP + US); - Liver biopsy selected; - Vaccination — HAV; (3) **Treatment indications** (AASLD 2018): - HBV DNA > 2000 IU/mL + ALT > 2x ULN + active liver disease; - Cirrhosis (regardless of DNA/ALT); - Reactivation risk (immunosuppression — universal prophylaxis); - HBeAg+ with high DNA + ALT (immune active phase); - This patient — inactive carrier-like; **observation reasonable** with close monitoring; (4) **Treatment options**: - **First-line oral antivirals (high barrier to resistance)**: - **Entecavir** (Baraclude); - **Tenofovir disoproxil fumarate (TDF) (Viread)**; - **Tenofovir alafenamide (TAF) (Vemlidy)** — better renal + bone profile; - **Peginterferon alfa-2a** — finite course (48 wk) with possible HBeAg seroconversion; limited use due to side effects; - Lifelong therapy typical for most chronic; cure rare; aiming for HBsAg loss (functional cure); (5) **Surveillance** — every 6 mo: - ALT, HBV DNA; - HBeAg / anti-HBe if applicable; - HCC screening US ± AFP every 6 mo (in cirrhosis + Asian men > 40 / Asian women > 50 / family CA history); - HBsAg quantitative selected; (6) **Reactivation prevention** before immunosuppression: - Screen all (HBsAg + anti-HBc) before chemotherapy, rituximab, anti-TNF, steroids prolonged, HCV DAAs; - Prophylactic entecavir or TAF if HBsAg+ or selected anti-HBc+; (7) **Pregnancy**: - HBsAg+ mothers — infant HBIG + HepB vaccine at birth (effective ~ 95% prevention); - HBV DNA > 200,000 IU/mL — maternal TDF in 3rd trimester to reduce vertical transmission; (8) **HBV vaccination** for negative + at-risk; universal infant; catch-up adults; (9) **Counseling**: transmission (sexual, blood, vertical, household), no sharing needles/razors/toothbrushes, partner testing + vaccination; (10) **HCV co-infection** treat HCV first (DAAs) with HBV monitoring (reactivation risk); (11) **Multidisciplinary**: PCP + hepatology + ID + OB if pregnant + transplant if cirrhosis decompensated

---

CHB: phases-based. Workup + screen co-infection. Treat if active disease / cirrhosis / immunosuppression. First-line entecavir or TDF/TAF. Surveillance q 6 mo + HCC screening. Reactivation prophylaxis. Pregnancy prevention. Vaccination + counseling. Multidisciplinary.', NULL,
  'medium', 'id', 'review',
  'family_medicine', 'clinical_decision', 'id', 'adult',
  'AASLD HBV 2018 + 2022 updates', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 40 ปี — incidental HBsAg positive; ALT normal; HBeAg neg, anti-HBe pos; HBV DNA 8000 IU/mL; clinically asymptomatic'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง wound healing physiology + clinical implications primary care', '[{"label":"A","text":"No moisture wound healing"},{"label":"B","text":"Wound Healing Physiology + Primary Care"},{"label":"C","text":"Antibiotic all wounds"},{"label":"D","text":"Single cleansing only"},{"label":"E","text":"Ignore systemic factors"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Wound Healing Physiology + Primary Care: (1) **Phases**: - **Hemostasis** (immediate — vasoconstriction, platelet plug, fibrin clot); - **Inflammation** (0-3 d — neutrophils + macrophages clean); - **Proliferation** (3 d - 3 wk — fibroblast collagen, angiogenesis, epithelialization, granulation); - **Remodeling** (3 wk - 1+ yr — collagen Type III → I, scar maturation); (2) **Types healing**: - **Primary intention** — clean wound edges approximated (suture, glue, staple, tape); fastest, least scar; - **Secondary intention** — wound left open to heal by granulation + contraction; for contaminated, infected, large; - **Tertiary (delayed primary)** — initially left open then closed after infection control; (3) **Wound assessment**: TIME — Tissue + Infection + Moisture + Edges; (4) **Factors impairing healing**: - **Local**: infection, foreign body, ischemia (PAD), pressure, repeat trauma, radiation, moisture imbalance, mechanical force; - **Systemic**: DM (multiple mechanisms — hyperglycemia, microvascular, neuropathy, immune dysfunction), malnutrition (protein, vitamin C + A + zinc), age, smoking (vasoconstriction, oxygen), alcohol, immunosuppression, medications (steroids, chemo, biologics, anticoagulants), comorbidities (CKD, anemia, CHF, autoimmune); - **Genetic**: collagen disorders (EDS), keloid susceptibility; (5) **Wound types primary care**: - **Acute**: laceration, abrasion, surgical, traumatic; - **Chronic** (> 4 wk no healing): diabetic foot, venous, arterial, pressure injury, atypical (pyoderma gangrenosum, malignant); (6) **Optimal wound care principles**: - **Cleansing**: saline or tap water; avoid harsh antiseptics on healing tissue; - **Debridement**: necrotic tissue removal (sharp, mechanical, enzymatic, autolytic, biological — maggot); - **Moisture balance**: moist wound healing optimal (films, hydrocolloids, foams, alginates); not too wet (maceration) or dry (eschar); - **Infection control**: clinical signs + culture only if needed; topical (silver, iodine) + systemic abx if cellulitis; - **Offloading + pressure relief** for pressure + diabetic foot; - **Compression** for venous; - **Revascularization** for arterial; - **Glycemic control** for diabetic; - **Nutrition optimization** (protein, vit C, zinc, B); - **Smoking cessation**; (7) **Modern advanced therapies**: NPWT (negative pressure), bioengineered skin substitutes, growth factors (becaplermin), HBO selected, cellular and tissue products; (8) **Closure**: - Sutures (absorbable vs not; size; technique); - Staples (scalp, trunk); - Tissue adhesive (face, low-tension); - Skin tape (Steri-strips); - Negative pressure for incisional; (9) **Tetanus prophylaxis** per CDC algorithm; (10) **Multidisciplinary**: PCP + wound care nurse + vascular + ID + endocrine + nutrition + plastic surgery + podiatry

---

Wound healing: 4 phases. Primary/secondary/tertiary intention. Local + systemic factors. TIME assessment. Moist wound healing, debridement, infection control, offloading. Modern advanced (NPWT, biologics). Tetanus. Multidisciplinary.', NULL,
  'medium', 'procedures', 'review',
  'family_medicine', 'basic_science', 'procedures', 'adult',
  'AAFP Wound Healing; AHRQ', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'Resident ถามเรื่อง wound healing physiology + clinical implications primary care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง antimicrobial stewardship principles + resistance prevention primary care', '[{"label":"A","text":"Broad-spectrum routine"},{"label":"B","text":"Antimicrobial Stewardship in Primary Care (CDC AS + IDSA + WHO)"},{"label":"C","text":"Long-course always"},{"label":"D","text":"Skip diagnostics"},{"label":"E","text":"Patient request mandates antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Antimicrobial Stewardship in Primary Care (CDC AS + IDSA + WHO): (1) **Antimicrobial resistance global crisis** — leading cause death ~ 1.3M annually; mostly preventable; primary care drives majority of outpatient antibiotic use (~ 60% outpatient prescriptions, much inappropriate); (2) **Core elements outpatient stewardship**: - **Commitment** (leadership + practice-wide); - **Action**: clinical decision support, delayed prescription, watch-and-wait, evidence-based diagnosis (RADT for strep, urine culture for complicated UTI, NAAT for STI); - **Tracking + reporting**: prescriber benchmarking, antibiogram review; - **Education** for clinicians + patients; (3) **Targeted conditions for outpatient stewardship**: - Acute respiratory infections (viral URI, bronchitis, sinusitis, OM, pharyngitis) — most inappropriate prescribing; - UTI (right drug + duration); - Skin/soft tissue (avoid MRSA empiric if not indicated); (4) **Communication strategies**: - Address patient expectations (often misperceive need); - Watchful waiting / delayed prescription; - Patient education on viral vs bacterial; - Symptomatic management plan; - Return precautions; - Decision aids; (5) **Right drug + dose + duration**: - **Shorter is better** for many (5 vs 10-14 d for many) — DURATION trials shows non-inferiority; - **Right spectrum** — narrow when possible; - **Right route** — oral preferred when adequate; (6) **Pre-prescribing considerations**: - Allergy history (true vs side effect); - Renal/hepatic dose adjustment; - Drug interactions; - Pregnancy + lactation; - Age (pediatric, elderly); - Cost; - Adherence (frequency, formulation, palatability); (7) **Avoid + dispel myths**: - Z-Pak (azithromycin) for everything — high resistance + cardiac risk; - Fluoroquinolones first-line for uncomplicated infections — FDA warnings + collateral damage; - Broad-spectrum when narrow works; - Long courses unnecessarily; (8) **Specific resistance patterns**: - MRSA: in community, varies by region; - **ESBL** (extended-spectrum beta-lactamase) — community-acquired emerging; - **CRE** (carbapenem-resistant Enterobacteriaceae) — healthcare-associated; - **C. difficile** — antibiotic-associated; - Gonorrhea — concerning ceftriaxone-resistant globally; - Tuberculosis MDR/XDR; - Fungi (Candida auris); (9) **Diagnostic stewardship**: - Don''t test asymptomatic bacteriuria (except pregnancy + pre-urologic); - Don''t test ASB; - Test for sore throat with Centor (avoid testing low-risk); - Stool culture only indicated; (10) **Vaccination** as prevention — pneumococcal, flu, COVID, RSV reduces infection + antibiotic need; (11) **Infection prevention**: hand hygiene, vaccines, environmental cleaning, contact precautions; (12) **Public health surveillance + reporting**; (13) **One Health approach** — human + animal + environment; (14) **Multidisciplinary**: PCP + pharmacy + ID + lab + nursing + infection prevention + public health

---

Antimicrobial stewardship: leading cause death. Outpatient drives majority. Right drug/dose/duration. **Shorter is better**. Avoid for viral URI. Communication with patients. Diagnostic stewardship. Vaccination prevention. One Health. Multidisciplinary.', NULL,
  'medium', 'id', 'review',
  'family_medicine', 'basic_science', 'id', 'adult',
  'CDC AS Outpatient; IDSA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'Resident ถามเรื่อง antimicrobial stewardship principles + resistance prevention primary care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง genetics + family history + genetic testing in primary care', '[{"label":"A","text":"No family history needed"},{"label":"B","text":"Genetics + Family History + Genetic Testing in Primary Care"},{"label":"C","text":"Random genetic testing"},{"label":"D","text":"Avoid all genetic testing"},{"label":"E","text":"Family history irrelevant"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Genetics + Family History + Genetic Testing in Primary Care: (1) **Family history = most important and underused genetic tool**; CDC Family Health Portrait, MyFamily.Healthfinder.gov; (2) **3-generation pedigree**: medical conditions, age at diagnosis, cause + age at death, ethnicity; identify patterns; (3) **Red flags for hereditary syndromes**: - Multiple relatives with same/related conditions; - Early age at onset; - Bilateral / multifocal disease; - Specific ethnicity (Ashkenazi Jewish — BRCA, Tay-Sachs); - Constellation of features in individual; - Genetic conditions in family; (4) **Common hereditary cancer syndromes**: - **HBOC (BRCA1/2)** — breast, ovarian, prostate, pancreatic; - **Lynch syndrome (HNPCC)** — colorectal, endometrial, ovarian, urinary, brain; MLH1, MSH2, MSH6, PMS2, EPCAM; - **FAP (APC)** — many adenomas + colorectal cancer; - **Li-Fraumeni (TP53)** — sarcoma, breast, brain, adrenal, leukemia; - **Cowden (PTEN)** — breast, thyroid, endometrial, others; - **MEN1, MEN2** — multiple endocrine neoplasia; - **VHL** — RCC, pheo, hemangioblastoma; - **NF1, NF2**; (5) **Other common hereditary conditions screen primary care**: - **Familial hypercholesterolemia** (LDLR, ApoB, PCSK9); - **HCM, ARVD, long QT** — cardiac genetic; - **Hemochromatosis (HFE)**; - **Alpha-1 antitrypsin**; - **Cystic fibrosis** (carrier screen); - **Sickle cell + thalassemia** (carrier screen high-risk populations); - **Fragile X**; - **Marfan, EDS, OI** — connective tissue; (6) **Genetic testing approach**: - **Pre-test genetic counseling** essential (informed consent, implications, family); - **Direct-to-consumer (23andMe, Ancestry)** — clinical interpretation needed, often incomplete, not diagnostic; - **Multigene panels** — increasingly used; - **Whole-exome / whole-genome** for complex; - **Reflex testing** based on results; (7) **Insurance + privacy**: - **GINA** (Genetic Information Nondiscrimination Act) — protects employment + health insurance discrimination based on genetic; - Not life, disability, long-term care insurance; - Disclose genetic results carefully; (8) **Cascade testing**: identify at-risk relatives — most impactful preventive intervention; (9) **Pharmacogenomics** — see separate (CYP2D6, CYP2C19, HLA, TPMT, etc.); (10) **Prenatal + reproductive genetics**: - Expanded carrier screening; - Cell-free fetal DNA (NIPT); - PGT (preimplantation testing); - CVS, amniocentesis for diagnostic; - Counseling for options; (11) **Newborn screening**: state-mandated panel; (12) **Resources**: GeneReviews, OMIM, ClinGen, NSGC find a counselor; (13) **Multidisciplinary**: PCP + genetic counselor + medical geneticist + specialists + ethicist + family

---

Family history = key genetic tool; 3-gen pedigree. Red flags (early, multiple, bilateral, ethnic). Common syndromes (BRCA, Lynch, FAP). Genetic testing with counseling. GINA protections (limited). Cascade testing impactful. Resources. Multidisciplinary.', NULL,
  'easy', 'signs_symptoms', 'review',
  'family_medicine', 'basic_science', 'signs_symptoms', 'adult',
  'ACMG; NCCN; NSGC; CDC', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'Resident ถามเรื่อง genetics + family history + genetic testing in primary care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง principles of laboratory testing — choosing, interpreting, addressing incidental', '[{"label":"A","text":"More tests always better"},{"label":"B","text":"Lab Test Selection + Interpretation Principles"},{"label":"C","text":"Ignore reference ranges"},{"label":"D","text":"No follow-up of abnormal"},{"label":"E","text":"Random ordering"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Lab Test Selection + Interpretation Principles: (1) **Pre-test probability + Bayesian thinking**: test characteristics + clinical context > test results alone; low pretest probability + positive test = likely false positive; (2) **Test characteristics**: - **Sensitivity** = true positives / all disease (SnNOUT — high Sn rules OUT if negative); - **Specificity** = true negatives / all healthy (SpPIN — high Sp rules IN if positive); - **PPV / NPV** depends on prevalence; - **Likelihood ratios (LR)** — apply across populations: LR+ = Sn/(1-Sp), LR- = (1-Sn)/Sp; LR > 10 strong + evidence, < 0.1 strong - evidence; LR independent of prevalence; - **AUC / ROC** for continuous tests; (3) **Choosing wisely**: order tests only when results will change management; Choosing Wisely Campaign — > 600 don''t do recommendations; common: - Don''t routine annual EKG asymptomatic; - Don''t routine PFT for screening; - Don''t routine vitamin D in asymptomatic; - Don''t screen TSH if asymptomatic per USPSTF; - Don''t routine PSA without shared decision; - Don''t order DEXA for women < 65 without risk; - Don''t routine ANA without features; (4) **Reference ranges**: - Population-based, typically 95% (2 SD); 5% of healthy outside; - **Critical values** require immediate notification; - **Age, sex, race-specific** ranges some tests; - **Diurnal variation** (cortisol, testosterone); - **Postprandial** (glucose, lipid); - **Medications** affect (TSH on biotin, BNP on neprilysin inhibitor); (5) **Incidentaloma management** — common in modern medicine: - **Adrenal**: 1 mm imaging follow-up + hormone screen (metanephrine, aldosterone:renin, dexamethasone suppression); biopsy only specific situations; - **Pulmonary nodule** (Fleischner Society guidelines based on size + risk); - **Thyroid nodule**: TI-RADS US, FNA criteria; - **Renal cyst**: Bosniak classification; - **Adnexal mass**: O-RADS; - **Pituitary microadenoma**: prolactin + visual field; - **Liver lesion**: LI-RADS; - **Pancreatic cyst**: ACG/AGA guidelines; - **Renal mass**: solid → workup; - Discuss with patient — anxiety vs informed; (6) **Common lab patterns**: - **Macrocytic anemia**: B12, folate, thyroid, alcohol, MDS; - **Microcytic**: iron deficiency, thalassemia, lead; - **Pancytopenia**: BM failure, infiltration, drug, autoimmune; - **Elevated AST/ALT**: hepatitis (viral, alcohol, NAFLD, drug, ischemic), muscle (CK); - **Cholestatic (ALK PHOS + GGT)**: biliary obstruction, infiltrative; - **Elevated Cr**: AKI vs CKD context; - **Hyponatremia**: volume status approach; - **Hyperkalemia**: causes + ECG; - **TSH**: subclinical considerations; (7) **Lab errors**: pre-analytical (specimen, timing, hemolysis), analytical (interference, calibration), post-analytical (transcription, missed); discrepancies — repeat; (8) **Communicating results**: timely (especially abnormal), structured, patient-centered, written copy, follow-up plan, MyChart access; (9) **Cost considerations**: choose wisely, generic alternative, value over volume; (10) **Multidisciplinary**: PCP + lab + specialists when indicated

---

Lab testing: pretest probability + Bayesian + LR + Choosing Wisely. Order to change management. Critical values + reference ranges + medications/timing. Incidentalomas guidelines (adrenal, pulm nodule, thyroid). Lab errors. Communication. Cost. Multidisciplinary.', NULL,
  'medium', 'procedures', 'review',
  'family_medicine', 'basic_science', 'procedures', 'adult',
  'Choosing Wisely; JAMA Rational Clinical Exam', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'Resident ถามเรื่อง principles of laboratory testing — choosing, interpreting, addressing incidental'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง patient-centered communication + shared decision-making + difficult conversations', '[{"label":"A","text":"Just deliver information"},{"label":"B","text":"Patient-Centered Communication + Shared Decision-Making (Calgary-Cambridge + Ariadne + Vital Talk)"},{"label":"C","text":"Avoid emotional discussions"},{"label":"D","text":"Make all decisions for patient"},{"label":"E","text":"Single approach for all"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Patient-Centered Communication + Shared Decision-Making (Calgary-Cambridge + Ariadne + Vital Talk): (1) **Patient-centered communication** essential for outcomes + experience + adherence + reduced malpractice: - **Calgary-Cambridge model**: initiate session + gather information + physical exam + explanation + planning + close + build relationship throughout; - **NURSE** for empathy: Name (emotion) + Understand + Respect + Support + Explore; - **BATHE** brief: Background + Affect + Trouble + Handling + Empathy; - **SPIKES** for delivering bad news: Setting + Perception + Invitation + Knowledge + Empathy + Strategy/Summary; - **Ask-Tell-Ask** for explanation; - **Teach-back** for confirmation; (2) **Active listening**: silence, reflection, paraphrasing, open questions, attend to verbal + non-verbal cues; (3) **Empathy + presence**: non-judgmental, acknowledge emotions, sit at eye level, undivided attention; (4) **Health literacy considerations**: 36% adults limited; use plain language (5th grade), avoid jargon, teach-back, written + visual aids; (5) **Cultural humility** — see separate; LEARN/ETHNIC framework; professional interpreters; (6) **Shared decision-making (SDM)** — preferred for preference-sensitive decisions: - **3-talk model** (Elwyn): team talk + option talk + decision talk; - **Decision aids** (Mayo, Cochrane DA inventory) for many conditions; - Aligns with patient values + preferences + circumstances; - Documentation; (7) **Difficult conversations** (serious illness, dying, errors): - **Serious Illness Conversation Guide** (Ariadne Labs): scheduled time, hopes + worries + tradeoffs + family + functional priorities; - **Vital Talk** training; - ''I wish'' + ''I worry'' + ''I wonder'' phrases; - ''Hope for the best, prepare for the worst''; - Address spiritual + emotional needs; - Family meetings; (8) **Breaking bad news (SPIKES)**: setting + perception + invitation + knowledge + emotions + strategy; (9) **Disclosure of medical errors**: ethical + legal duty; honest + transparent + empathic + system improvement focus; reduces litigation; CANDOR program; (10) **Goals-of-care discussions**: triggers (advanced illness, life-limiting diagnosis, repeated hospitalizations, surrogate not designated, prognostic uncertainty); ongoing not single conversation; (11) **Telemedicine communication**: eye contact (camera), introduce participants, presence despite remote; (12) **Patient experience matters**: outcomes, adherence, satisfaction, reduced legal risk; HCAHPS metrics; (13) **Provider self-care + reflection**: vicarious trauma, moral injury, debriefing; (14) **Multidisciplinary**: physicians + APPs + nurses + social work + chaplaincy + palliative care + interpreters + ethics + family

---

Communication: Calgary-Cambridge, NURSE, SPIKES, Ask-Tell-Ask, teach-back. SDM with decision aids + 3-talk. Serious illness conversation (Ariadne + Vital Talk). Health literacy + cultural humility. Disclosure of errors. Goals-of-care. Multidisciplinary.', NULL,
  'easy', 'psych_behavior', 'review',
  'family_medicine', 'basic_science', 'psych_behavior', 'adult',
  'Calgary-Cambridge; Ariadne; Vital Talk; SDM', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'Resident ถามเรื่อง patient-centered communication + shared decision-making + difficult conversations'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident — primary care role in public health emergencies (pandemic, disaster, outbreak)', '[{"label":"A","text":"Ignore reporting"},{"label":"B","text":"Public Health + Primary Care Integration (CDC + AAFP)"},{"label":"C","text":"No connection to public health"},{"label":"D","text":"Single emergency only"},{"label":"E","text":"Private practice unaffected"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Public Health + Primary Care Integration (CDC + AAFP): (1) **Primary care role in public health**: - Surveillance (reportable diseases — STI, TB, vaccine-preventable, foodborne, healthcare-associated); - Outbreak detection + response; - Population health management; - Vaccination delivery; - Health education; - Screening + early detection; - Community engagement; - Emergency preparedness; - Mental health support; (2) **Reportable conditions** (vary by jurisdiction): notifiable infectious diseases (CDC NNDSS), cancer registries, birth defects, injuries, occupational, environmental; mandated by law; - HIV, syphilis, gonorrhea, chlamydia, hepatitis, TB; - Meningococcal, measles, mumps, rubella, pertussis, varicella; - Foodborne (Salmonella, Listeria, E. coli, etc.); - Animal bites, rabies exposure; - Vector-borne (Lyme, RMSF, dengue, malaria, Zika); - Lead poisoning; - Suspected bioterrorism; (3) **Pandemic preparedness lessons (COVID-19)**: - Surge capacity + telemedicine + workforce flexibility; - Infection prevention (PPE, ventilation, distancing, vaccination, testing); - Vulnerable populations focus (elderly, immunocompromised, social isolation); - Mental health crisis response; - Health equity disparities; - Communication + counter-misinformation; - Long COVID management; (4) **Disaster preparedness + response**: - Continuity of care planning; - Medication continuity, dialysis, oxygen; - Mental health (acute trauma + chronic); - Vulnerable populations (homebound, elderly, disabilities); - Coordination with EMS + public health + ESF #8 (health and medical); - Community resilience; (5) **Vaccine delivery**: - Routine + catch-up + travel; - Outbreak response vaccination; - Mass vaccination clinics; - Vaccine hesitancy address; - Equity in access; (6) **Environmental health**: - Lead exposure (children especially) — screening + abatement; - Air quality (asthma, COPD, CV); - Water (PFAS, contamination); - Climate change health impacts (heat, vector-borne, respiratory); - Occupational; (7) **Health equity + social justice**: - Address SDOH; - Structural racism; - Community-based participatory; - Policy advocacy; (8) **Maternal + child health programs**: WIC, home visiting (Healthy Families, NFP), early intervention, school health; (9) **Public health career integration**: - State + local health departments; - CDC EIS, AHRQ; - Academic public health; - Global health; - Policy + advocacy; - Community-based; (10) **Practice-level**: incorporate PH lens in daily practice, partner with health department, contribute data, advocate; (11) **Multidisciplinary public health**: PCP + public health professionals + epidemiology + lab + nursing + community health workers + policy + community + government + NGO + academia

---

Public health + primary care integration: surveillance, reportable diseases, outbreak response, vaccination, screening, emergency preparedness, vulnerable populations. Pandemic lessons (COVID). Disaster preparedness. Environment + equity. Multidisciplinary.', NULL,
  'easy', 'id', 'review',
  'family_medicine', 'basic_science', 'id', 'adult',
  'CDC; APHA; AAFP Public Health', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'Resident — primary care role in public health emergencies (pandemic, disaster, outbreak)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง primary care practice business + finance basics + payment models', '[{"label":"A","text":"Random billing"},{"label":"B","text":"Primary Care Practice Business + Finance + Payment (AAFP + ACP)"},{"label":"C","text":"Ignore quality metrics"},{"label":"D","text":"Fee-for-service only future"},{"label":"E","text":"No coding knowledge needed"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Primary Care Practice Business + Finance + Payment (AAFP + ACP): (1) **Payment models evolution**: - **Fee-for-service (FFS)** — volume-based, dominant historically; - **Capitation** — per-member per-month fixed; risk-adjusted; - **Pay-for-performance (P4P)** — quality bonuses on FFS; - **Bundled payments** — episode of care; - **Shared savings** — ACO (Accountable Care Organization) models; - **Hybrid** — base FFS + quality + risk-sharing; - **Direct primary care (DPC)** — monthly membership, no insurance billing, lower admin burden, growing model; (2) **CPT + ICD-10 + HCC coding**: - **E/M codes** (99202-99215 etc.) — based on MDM (medical decision-making) complexity OR total time (2021 update); - Documentation requirements simplified 2021 — focus on MDM or time; - **Modifier 25** for separate problem on procedure day; - **Preventive vs problem-oriented** visits; - **Behavioral health integration** codes (G0444, 99492-99494); - **Chronic care management (CCM)** 99490 + complex (99487); - **Transitional care management (TCM)** 99495-99496; - **Advance care planning (ACP)** 99497-99498; - **Annual wellness visit (AWV)** G0438/G0439; - **Behavioral health screening** G0444; - **HCC coding** for risk adjustment — Medicare Advantage; document all chronic conditions annually; (3) **Practice models**: - **Solo private practice**; - **Group practice** (single or multispecialty); - **Federally Qualified Health Center (FQHC)** — sliding fee, mission-driven, enhanced reimbursement; - **Hospital-employed**; - **Concierge / DPC**; - **Telemedicine-only**; - **Academic + research**; (4) **Revenue cycle management**: - Charge capture; - Claims submission; - Denials management; - Patient billing + collections; - Prior authorization (huge burden); - Insurance verification; (5) **Cost management**: - Staffing (largest cost ~ 50%); - EHR + IT; - Supplies; - Lease; - Insurance; (6) **Productivity metrics**: - **wRVUs** (work RVUs) — physician productivity; - Panel size + visits/day; - Revenue per visit; - **No-show rate**; - **AR days**; (7) **Quality + value metrics**: - **HEDIS** (NCQA); - **CMS Stars** (Medicare Advantage); - **MIPS** (Merit-based Incentive Payment System) — quality + cost + improvement + interoperability; replaced PQRS, MU, VBM; - APMs (Alternative Payment Models); (8) **Practice transformation**: - PCMH recognition; - Team-based care; - Behavioral health integration; - Pharmacy collaboration; - Telemedicine; - Population health tools; (9) **Workforce**: - APP integration (NPs, PAs); - Care managers; - CHWs; - Pharmacists; - Behavioral health; - MA optimization; - Scribes / AI ambient; (10) **Practice valuation + transactions**: buy/sell, group joining, partnership; (11) **Legal + regulatory**: - Stark, Anti-kickback; - HIPAA; - State licensure + scope; - CMS regulations; - Liability insurance; (12) **Loan repayment + workforce programs**: NHSC, IHS, state programs, employer-based; (13) **Burnout + sustainability**: workflow optimization, AI scribes, team support, financial security; (14) **Multidisciplinary**: PCP + practice manager + billing + IT + HR + legal + accounting + financial advisor

---

Practice business: payment models evolving (FFS → value-based, DPC growing). CPT + ICD-10 + HCC coding. Practice models. Revenue cycle. Productivity (wRVUs). Quality (HEDIS, MIPS). Transformation. Workforce. Legal. Burnout. Multidisciplinary.', NULL,
  'medium', 'signs_symptoms', 'review',
  'family_medicine', 'ems_mgmt', 'signs_symptoms', 'adult',
  'AAFP Practice Management; ACP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'Resident ถามเรื่อง primary care practice business + finance basics + payment models'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital — admission + hospitalist model — collaboration with primary care', '[{"label":"A","text":"No PCP involvement"},{"label":"B","text":"Hospitalist-PCP Collaboration + Admission Process"},{"label":"C","text":"Single discharge note only"},{"label":"D","text":"Ignore PCP completely"},{"label":"E","text":"Random handoff"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hospitalist-PCP Collaboration + Admission Process: (1) **Hospitalist model dominant** — most hospitals now hospitalist-staffed for general medicine: - PCPs less likely to round in hospital (efficiency, payment, cross-coverage challenges); - Continuity loss is risk — care transitions critical; - 24/7 in-house presence + procedure-trained; (2) **Admission communication**: - PCP-hospitalist warm handoff (especially complex, recent labs/imaging, baseline function, advance directives, family contacts, key info); - EHR shared records help when on same system; - Direct call/secure message for complex; - Avoid information gap; (3) **During hospitalization**: - PCP notification of admission (via EHR alerts, faxes, phone); - PCP may visit / consult / be reached; - Specialist consults coordinate; - Discharge planning early — include PCP; - Family meetings PCP may join; (4) **Discharge handoff** — see care transitions: - Discharge summary timely + complete; - Medication reconciliation critical; - Pending tests + follow-up; - PCP appointment 7-14 d arranged; - Patient teach-back; - Caregiver involvement; (5) **Co-management models**: - **Cardiology + hospitalist** post-MI/CHF; - **Orthopedic + medicine** for hip fracture; - **Oncology + medicine** for complications; - **Surgery + medicine** comorbidity management; - **Psychiatry + medicine** for substance/SI; - **Palliative care + primary team** for serious illness; (6) **Specialty PCP**: - **Family medicine inpatient** — declining but valuable model, especially OB + peds + adult continuity (rural settings); - **Med-peds**; - **Adult medicine** track family medicine; - **Hospitalist with primary care relationship** (continuity hospitalist model); (7) **Quality + safety in handoffs**: - I-PASS (Illness severity + Patient summary + Action list + Situation awareness + Synthesis by receiver) — evidence-based; - SBAR (Situation + Background + Assessment + Recommendation); - Critical info passed; - Avoid distractions; (8) **Avoid bouncebacks (30-day readmissions)**: - Strong handoff; - Early follow-up; - Medication reconciliation; - Address SDOH; - Care management for high-risk; - Patient education; - CMS Hospital Readmissions Reduction Program (HRRP) — financial penalties; (9) **Length of stay + utilization**: - PCP knowledge of pre-hospital baseline informs discharge timing; - Avoid premature + delayed discharge; - Post-acute decisions (home, home health, SNF, IRF, LTAC, hospice); (10) **Pediatrics + OB**: - Family medicine still often inpatient + maternity in many practices; - Newborn care + postpartum integrated; (11) **ICU coordination**: PCP info valuable; family ICU meetings; goals-of-care; (12) **End-of-life care**: PCP role for goals-of-care + family relationships even if not bedside attending; (13) **Multidisciplinary**: PCP + hospitalist + specialists + nursing + case manager + social work + pharmacy + physical therapy + family + chaplaincy

---

Hospitalist-PCP collaboration: warm handoffs, admission notification, discharge planning together, medication reconciliation. Co-management models. I-PASS / SBAR. Avoid bouncebacks (HRRP). PCP role even if not bedside. Multidisciplinary.', NULL,
  'medium', 'signs_symptoms', 'review',
  'family_medicine', 'ems_mgmt', 'signs_symptoms', 'adult',
  'SHM Hospitalist; CMS HRRP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'Hospital — admission + hospitalist model — collaboration with primary care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital — risk management + medical malpractice prevention + patient safety', '[{"label":"A","text":"Defensive medicine reduces risk"},{"label":"B","text":"Medical Malpractice + Risk Management (AAFP + Common Knowledge)"},{"label":"C","text":"Hide adverse events"},{"label":"D","text":"Skip documentation"},{"label":"E","text":"Avoid all litigation by avoiding patients"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Medical Malpractice + Risk Management (AAFP + Common Knowledge): (1) **Most common malpractice claims primary care**: - **Missed/delayed diagnosis** — cancer (breast, colon, lung, skin, prostate), MI, stroke, infection (meningitis, sepsis), PE; major source; - **Medication errors** (interactions, allergies, dosing, monitoring); - **Failure to refer / consult**; - **Failure to communicate** results (esp abnormal); - **Procedural complications**; - **Failure to obtain informed consent**; - **Failure to follow up** (no-shows, abnormal results); (2) **Risk reduction strategies**: - **Communication** with patients + colleagues — most malpractice = communication failures; - **Documentation thorough but appropriate**: clinical reasoning, differentials considered + ruled out, shared decisions, follow-up plans; not just data; - **Closed-loop communication**: results → patient → action → confirmation; - **Robust safety net systems**: missed results, no-show follow-up, referral tracking, recall systems; - **Standardization + checklists** for routine; - **Time / attention** + reduced cognitive overload; (3) **Disclosure of adverse events / errors**: - Ethical + legal duty (most jurisdictions); - **CANDOR program** (Communication and Optimal Resolution) — apology + transparency + early resolution; - Reduces litigation; - Apology laws in many states (don''t admit fault in many); - Maintain medical record without alteration; (4) **Patient safety culture**: - **Just culture** — system focus, not blame; distinguish human error + at-risk behavior + reckless; - **Psychological safety** + speaking up; - **High-reliability organizations (HRO)** principles; - **Incident reporting** systems; - **Root cause analysis (RCA)** for serious events; - **Failure modes + effects analysis (FMEA)** prospective; (5) **Common safety priorities**: - **Sepsis screening + early treatment**; - **VTE prophylaxis**; - **Anticoagulation safety**; - **Insulin safety**; - **Opioid safety**; - **Hand hygiene + infection prevention**; - **Surgical safety checklists** (WHO); - **Patient identification**; - **Handoff communication**; - **Look-alike sound-alike medications**; (6) **Specific high-risk situations primary care**: - Phone advice — document, low threshold to see in person; - After-hours coverage — cross-coverage protocols; - Pediatric — special considerations; - Pregnancy — dual responsibility; - Mental health — suicide risk; - Substance use — controlled substance prescribing; (7) **Liability insurance**: malpractice (occurrence vs claims-made + tail), umbrella, cyber, employment; (8) **Boundary issues**: - Treating family/friends (avoid except urgent); - Dual relationships; - Social media; - Personal information sharing; (9) **Records management**: retention (varies, generally 7-10 yr adult + 7-10 yr after age of majority for peds), HIPAA-compliant disposal; (10) **Personal wellness**: burnout linked to errors; physician health programs; (11) **Quality + safety reporting**: AHRQ, CMS, state, hospital, certification bodies; (12) **Multidisciplinary**: physicians + risk management + quality + legal + nursing + pharmacy + insurance + administration + patients (advisory councils)

---

Risk management: missed diagnosis + medication + communication top claims. Documentation + closed-loop + safety nets. CANDOR disclosure. Just culture + HRO. Common safety priorities. Boundaries. Records. Wellness. Multidisciplinary.', NULL,
  'medium', 'signs_symptoms', 'review',
  'family_medicine', 'ems_mgmt', 'signs_symptoms', 'adult',
  'AAFP; CANDOR; AHRQ', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'Hospital — risk management + medical malpractice prevention + patient safety'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital — primary care workforce shortage — recruitment + retention + practice models', '[{"label":"A","text":"Single physician model only"},{"label":"B","text":"Primary Care Workforce Crisis + Solutions"},{"label":"C","text":"Avoid technology"},{"label":"D","text":"No team-based care"},{"label":"E","text":"Maintain status quo"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Primary Care Workforce Crisis + Solutions: (1) **Crisis**: severe shortage primary care physicians US — projected 17,800 to 48,000 by 2034 (AAMC); rural worst; majority current PCPs > 50 yo; burnout drives early exit; medical students choosing specialties for lifestyle + income; (2) **Drivers**: - Compensation gap vs specialists (50%+ less); - Administrative burden + EHR + prior auths; - Burnout high; - Loan burden vs income; - Lifestyle perception; - Lack of mentorship + visibility in training; - Insufficient training program slots (GME funding limited); - Maldistribution (rural, urban underserved); (3) **Workforce expansion**: - **Advanced Practice Providers (APPs)** — NPs + PAs: scope of practice variable by state; effective + valued team members; full practice authority in many states; - **Pharmacists** — drug therapy management, chronic disease (BP, DM, anticoagulation, lipid), vaccinations, MTM; growing scope; - **Behavioral health** — psychologists + LCSWs + therapists integrated; - **Community Health Workers (CHWs)** — bridge healthcare-community; evidence for many conditions; - **Medical Assistants (MAs)** — expanded roles (panel management, motivational interviewing, education); - **Care managers** (RN, SW); - **Health coaches**; - **Scribes** + ambient AI scribing — reduces documentation burden; (4) **Team-based care models**: - **Patient-Centered Medical Home (PCMH)** — see separate; - **Direct Primary Care (DPC)** — membership-based, no insurance, lower volume + higher engagement, growing rapidly; - **FQHC (Federally Qualified Health Centers)** — mission-driven, sliding fee, enhanced funding; - **Concierge medicine**; - **Telemedicine-first** primary care (One Medical, Forward, others); - **Virtual + AI-enabled** care; (5) **Recruitment**: - Loan repayment (NHSC, state programs, employer); - J-1 + Conrad 30 waivers (international medical graduates); - Visa programs; - Community connections; - Spousal employment; - Lifestyle fit; - Mentorship; (6) **Retention**: - Compensation competitive; - Workload manageable + flexibility (part-time, shared positions, sabbaticals); - Practice culture + autonomy; - Professional development; - Wellness initiatives; - Reducing admin burden (scribes, AI, decision support); - EHR optimization; - Leadership opportunities; (7) **GME expansion + funding**: - Increase residency slots; - Focus on rural + underserved; - HRSA Title VII funding; - Teaching Health Centers (THC) model; (8) **Pipeline**: - K-12 STEM + medical exposure; - Pre-med + medical school primary care exposure + role models; - Family medicine track programs; - Community-based training; - Diverse workforce (race, ethnicity, language); (9) **Scope of practice + practice transformation**: - Top-of-license for all team members; - Standardized workflows; - Technology leverage (telemedicine, asynchronous, AI); - Value-based payment alignment; (10) **Rural + underserved**: - Federal designations (HPSA, MUA/P); - Loan repayment + scholarship; - Rural Residency Planning + Development (RRPD); - Telehealth-supported; - Critical access hospitals; - Community health centers; (11) **Global**: similar shortages worldwide; international migration considerations; (12) **Advocacy**: AAFP, ACP, AAP, AOA, others — policy + payment reform + workforce; (13) **Multidisciplinary**: PCP + APP + pharmacy + behavioral health + nursing + admin + workforce + HR + community + government

---

PC workforce crisis: severe shortage + maldistribution. APPs + pharmacists + CHWs + behavioral + scribes/AI expand team. New models (DPC, FQHC, telemedicine). Recruitment (loan repayment, visa). Retention (burden reduction, wellness). GME expansion. Pipeline. Rural focus. Multidisciplinary.', NULL,
  'easy', 'signs_symptoms', 'review',
  'family_medicine', 'ems_mgmt', 'signs_symptoms', 'adult',
  'AAMC; AAFP Workforce; HRSA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'Hospital — primary care workforce shortage — recruitment + retention + practice models'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital — moving from volume to value — implementation primary care', '[{"label":"A","text":"Fee-for-service only"},{"label":"B","text":"Value-Based Care Implementation Primary Care (CMS + AAFP)"},{"label":"C","text":"Ignore quality metrics"},{"label":"D","text":"Single value measure"},{"label":"E","text":"No team-based care"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Value-Based Care Implementation Primary Care (CMS + AAFP): (1) **Value = Outcomes / Cost** — focus on what matters to patients + populations; (2) **CMS pathway**: traditional FFS → Pay-for-Performance → APMs (Alternative Payment Models) — gradual progression; (3) **Major value-based payment models**: - **MIPS (Merit-based Incentive Payment System)** — quality + cost + improvement + interoperability; majority of Medicare PCPs; - **MIPS Value Pathways (MVPs)** — condition + specialty-specific; - **APMs**: - **ACO (Accountable Care Organization)** — group of providers accountable for quality + cost of population: - **MSSP (Medicare Shared Savings Program)** — most common; - **REACH (Realizing Equity, Access, Community Health)** model — equity-focused; - **Direct Contracting** (transitioning); - **NextGen ACO** (previous); - **Pioneer ACO** (historical); - **Primary Care First (PCF)** — capitation + performance bonus; - **Comprehensive Primary Care Plus (CPC+)** — historical; - **MA Direct Contracting**; - **Bundled payments** for episodes; - **Health home models** — Medicaid; (4) **Population health management infrastructure**: - **Data + analytics** + EHR + claims; - **Registries** chronic disease; - **Risk stratification** of panel; - **Care management** high-risk; - **Care gaps** identification + outreach; - **Dashboards** real-time; - **Predictive analytics** for high-risk identification; (5) **Quality measures**: - **HEDIS** (NCQA, commercial); - **CMS Stars** (Medicare Advantage); - **MIPS quality measures**; - Process: preventive screening, vaccination, chronic disease management; - Outcome: HbA1c, BP control, readmissions, mortality; - Patient experience (CAHPS); - Equity (stratified); (6) **Cost measures**: - **TCOC (Total Cost of Care)** per member; - Utilization (ED, hospitalization, readmission); - **Per Beneficiary Spending**; - **MIPS cost measures**; (7) **High-value care examples**: - Avoid low-value care (Choosing Wisely); - Generic prescribing; - Preferred drug lists; - Same-day access reduces ED use; - Behavioral health integration; - Care management for high-risk; - Transitions of care; - SDOH interventions; (8) **Equity-focused value**: - **Health equity quality measures**; - **Stratified outcomes** by race, ethnicity, language, SES; - **REACH model** ACO equity component; - **CHW + SDOH interventions** count + valued; (9) **Patient + family engagement** — co-design + advisory + value of care; (10) **Practice transformation**: - PCMH; - Team-based care; - Behavioral health integration; - Pharmacy collaboration; - Telemedicine; - Quality improvement (PDSA); - Workforce; - Technology; (11) **Workforce alignment**: incentives + culture + training + leadership development; (12) **Challenges**: data infrastructure, risk adjustment accuracy, attribution, downside risk, small practice barriers, equity reporting; (13) **Future direction**: increasing risk + capitation + population focus + equity integration + patient experience + clinician well-being; (14) **Multidisciplinary**: PCP + practice manager + data analytics + quality + IT + care management + behavioral health + pharmacy + admin + leadership + patients + community

---

Value-based care: outcomes/cost. Transition FFS → P4P → APM. MIPS + ACOs (MSSP, REACH). PCF. Bundled payments. Population health infrastructure. Quality + cost + equity measures. High-value care examples. Practice transformation. Challenges + future. Multidisciplinary.', NULL,
  'medium', 'signs_symptoms', 'review',
  'family_medicine', 'ems_mgmt', 'signs_symptoms', 'adult',
  'CMS Innovation; AAFP Value-Based', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'Hospital — moving from volume to value — implementation primary care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'วัยรุ่นหญิงอายุ 17 ปี — annual visit + sensitive topics (sexual, substance, mental health, body image, family conflict)', '[{"label":"A","text":"Parent always present"},{"label":"B","text":"Adolescent Integrative Comprehensive Care (AAP + SAHM + AAFP)"},{"label":"C","text":"No confidential discussion"},{"label":"D","text":"Avoid sensitive topics"},{"label":"E","text":"Single specialty only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Adolescent Integrative Comprehensive Care (AAP + SAHM + AAFP): (1) **Adolescent-specific assessment HEEADSSS**: Home + Education/Employment + Eating + Activities + Drugs + Sexuality + Suicide/depression + Safety; comprehensive social + behavioral; (2) **Confidentiality + consent**: - Discuss limits + boundaries upfront; - Confidential time alone with adolescent (without parent) starting around age 12; - Sensitive services laws vary by state — most allow confidential care for mental health, sexual + reproductive health, substance use; - **Mandatory reporting limits** confidentiality: abuse, suicide/homicide risk, certain infections; (3) **Mental health screening**: - **PHQ-9 adolescent (PHQ-A)** — universal screening; - **Suicide screening (ASQ, Columbia)** — high mortality cause adolescent; - **Anxiety (GAD-7, SCARED)**; - **Eating disorders (SCOFF)**; - **Substance use (CRAFFT 2.1+)**; - **ADHD** if concerns; - **Bullying** including cyber; - **LGBTQ+ identity + acceptance**; - **Body image + body composition**; - **Trauma + ACEs**; (4) **Sexual + reproductive health**: - SSHADESS (Sexual orientation, behaviors, partners, practices); - STI screening risk-based; HIV, HCV per CDC; - Contraception counseling — LARC most effective + safe adolescent; emergency contraception; - HPV vaccination; - Pregnancy testing if applicable + options counseling (non-directive); - LGBTQ+-affirming care including gender-diverse + transgender support; - Healthy relationships + IPV; (5) **Substance use**: - Universal CRAFFT screening; - Tobacco / vaping (rising concern); - Alcohol; - Marijuana (legal status varies); - Other substances including opioid + stimulant; - Brief intervention (SBIRT); - Treatment referral (counseling, MOUD for OUD); (6) **Nutrition + activity + sleep + screen**: 5-2-1-0 (5 fruits/veg, < 2 h screen, 1 h activity, 0 sugary drinks); athletic considerations; eating disorder screen; (7) **Driving safety + injury prevention**; firearms, helmets, drugs/alcohol; (8) **Vaccinations**: HPV, meningococcal (ACWY + B), Tdap, flu, COVID, RSV; catch-up; (9) **Chronic condition management**: developmental tasks of adolescence + chronic illness (DM, asthma, mental health) — transition planning; (10) **Transition to adult care**: 14-26 yo gradual process; transition policy; teach self-management skills; communication with adult provider; written summary; (11) **Family involvement balance**: developmentally appropriate, respect autonomy + family role; family-centered when possible; family therapy when needed; (12) **School + community resources**: 504, IEP, school counselor, sports, community mentors, mental health resources; (13) **Trauma-informed care + ACEs**; LGBTQ+ minority stress; (14) **Reproductive + parental considerations** for minors (in care, foster, juvenile justice); (15) **Multidisciplinary integrative**: PCP + adolescent medicine + behavioral health + nutrition + school + family + community + reproductive health + LGBTQ+ resources + addiction services

---

Adolescent integrative care: HEEADSSS, confidential time, sensitive topics. Mental health (PHQ-A, suicide, EDs, substance — CRAFFT). Sexual + repro health + LGBTQ+ affirming. Vaccinations + lifestyle. Transition to adult care. Family balance. Trauma-informed. Multidisciplinary.', NULL,
  'medium', 'psych_behavior', 'review',
  'family_medicine', 'integrative', 'psych_behavior', 'peds',
  'AAP HEEADSSS; SAHM', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'วัยรุ่นหญิงอายุ 17 ปี — annual visit + sensitive topics (sexual, substance, mental health, body image, family conflict)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี — chronic LBP + fibromyalgia × 5 yr + depression + sleep + opioid dependence + functional limitation', '[{"label":"A","text":"Opioid escalation only"},{"label":"B","text":"Chronic Pain Integrative Management (CDC 2022 Pain Guideline + ACP)"},{"label":"C","text":"Single-modality treatment"},{"label":"D","text":"Stop opioids abruptly"},{"label":"E","text":"Ignore mental health"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Chronic Pain Integrative Management (CDC 2022 Pain Guideline + ACP): (1) **Comprehensive biopsychosocial assessment**: - Pain characterization, neuropathic features, central sensitization; - Functional impact (work, ADL, mood, sleep, relationships); - Mental health (depression, anxiety, PTSD common comorbid); - Substance use; - Trauma + ACEs; - SDOH; - Treatment history + response; (2) **Multimodal approach core principle** — multiple modalities address multiple mechanisms: - **Active management** + **patient self-management** central; (3) **Non-pharmacologic FIRST + foundation**: - **Movement / exercise** — aerobic, strength, flexibility (yoga, tai chi); strong evidence chronic pain; - **PT** — manual therapy, exercise; - **CBT for chronic pain** — strong evidence; available in-person + digital; - **Acceptance + Commitment Therapy (ACT)**; - **Mindfulness-Based Stress Reduction (MBSR)**; - **Acupuncture** — strong evidence many conditions; - **Massage**; - **Sleep optimization** — CBT-I, hygiene; - **Stress management**; - **Heat / cold**; - **Patient education + pain neuroscience education**; (4) **Pharmacologic — non-opioid first + scheduled multimodal**: - **Acetaminophen** + **NSAIDs** (topical + oral) cautious; - **Antidepressants**: - **SNRI** (duloxetine, milnacipran) — neuropathic + fibromyalgia + chronic MSK + depression; - **TCA** (amitriptyline, nortriptyline) — neuropathic + sleep + chronic pain; cautious cardiac; - **SSRI** less effective for pain but useful comorbid depression; - **Anticonvulsants** (gabapentin, pregabalin) — neuropathic + fibromyalgia; sedation; - **Topical**: capsaicin, lidocaine, NSAIDs; - **Cannabis / CBD** — limited evidence variable, regulatory considerations; - **Muscle relaxants** short-term selected; (5) **Opioid considerations (CDC 2022 nuanced update from 2016)**: - **For chronic pain — generally not first-line**, but **legitimate role for selected** (cancer, end-of-life, palliative; selected chronic non-cancer when benefits outweigh harm); - **Avoid abrupt discontinuation** in established users — taper carefully (CDC 2022 critical update — 2016 misinterpretation caused harm); - **Multimodal** approach with opioids when used; - **Lowest effective dose + duration**; - **Risk mitigation**: PDMP check, UDS, naloxone co-Rx, treatment agreement, mental health screen; - **Monitor function + pain + adverse effects**; - **Don''t increase opioid for tolerance without reassessment**; - **OUD screening + treatment** if applicable — MOUD (buprenorphine especially compatible with chronic pain); - **Avoid combination opioid + benzo / gabapentinoid / sedative when possible** (overdose risk); (6) **Interventional pain management** selected: - Trigger point injections; - Epidural steroid injection (radiculopathy, short-term); - Facet RFA (refractory); - Joint injections; - Sympathetic blocks; - Spinal cord stimulation; - Intrathecal pumps (severe refractory); (7) **Mental health integration mandatory** — depression + anxiety + PTSD + substance use treatment alongside pain — improves both; Collaborative Care Model; (8) **Address SDOH**: work, finances, housing, social support, transportation; (9) **Family + caregiver involvement + support**; (10) **Goals**: function + quality of life > pain elimination; SMART goals; (11) **Self-management programs**: Chronic Pain Self-Management Program (Stanford); (12) **Specialty referral**: pain medicine, rehab medicine, behavioral health, addiction medicine; (13) **Multidisciplinary integrative**: PCP + pain medicine + PT/OT + behavioral health + psychiatry + addiction medicine + pharmacy + family + community resources + complementary providers

---

Chronic pain integrative: biopsychosocial. Non-pharm foundation (exercise, CBT, ACT, mindfulness, PT, acupuncture). Multimodal pharm (acetaminophen, NSAIDs, SNRI, TCA, gabapentinoids, topicals). Opioids selected + cautious (CDC 2022 nuanced). Mental health integration. SDOH. Function goals. Multidisciplinary.', NULL,
  'hard', 'psych_behavior', 'review',
  'family_medicine', 'integrative', 'psych_behavior', 'adult',
  'CDC Pain 2022; ACP Chronic LBP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี — chronic LBP + fibromyalgia × 5 yr + depression + sleep + opioid dependence + functional limitation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 28 ปี transgender woman (assigned male at birth, female gender identity) — establishing primary care + interested gender-affirming care', '[{"label":"A","text":"Refuse care"},{"label":"B","text":"LGBTQ+ + Transgender Primary Care (WPATH SOC 8 + AMA + Endocrine Society)"},{"label":"C","text":"Single visit no follow-up"},{"label":"D","text":"Use birth-assigned identity"},{"label":"E","text":"Avoid affirming care"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** LGBTQ+ + Transgender Primary Care (WPATH SOC 8 + AMA + Endocrine Society): (1) **Affirming care principles**: - Use correct name + pronouns; - Avoid assumptions; - Inclusive intake forms (sexual orientation, gender identity, sex assigned at birth, pronouns); - Confidentiality + privacy; - Address minority stress + discrimination history; - Trauma-informed; (2) **Comprehensive primary care**: - **Routine preventive care per organs present** (not gender identity): - Cervical CA screening if has cervix; - Breast screening if breast tissue (consider age + GAHT); - Prostate screening if has prostate; - **Mental health** — high rates depression, anxiety, suicide (especially adolescents) — supportive + affirming care reduces; **Trevor Project**, **Trans Lifeline**; - **HIV / STI screening** — risk-based, multi-site; - **PrEP** for high-risk MSM, trans women MSM; - **Substance use** — higher rates; - **Vaccinations**: HPV (all ages), HepA/B, COVID, Mpox high-risk; - **Sexual + reproductive health** — fertility considerations before GAHT/surgery + ongoing; (3) **Gender-affirming hormone therapy (GAHT) for transgender women** (estrogen-based feminization, per WPATH SOC 8 + Endocrine Society): - **Estrogen**: estradiol (oral, transdermal, IM, SC); transdermal preferred for VTE + age + smoker; serum levels guide; goal premenopausal female range; - **Anti-androgen**: spironolactone first-line US (testosterone reduction + diuretic awareness K, BP); alternatives: cyproterone (not US), GnRH agonist (leuprolide — expensive); finasteride / dutasteride limited; - **Progestin** controversial — some add for chest development + libido (micronized progesterone); - **Effects timeline** education: breast development (3 mo - 2 yr), softer skin (3-6 mo), fat redistribution (3-6 mo), libido decrease (1-3 mo); permanent (breast growth, some genital) vs reversible (most others); - **Monitoring**: estradiol + testosterone q 3 mo year 1, then q 6-12 mo; lipids; LFT; glucose; K (if spironolactone); BP; mood; VTE risk; cardiovascular; bone (long-term); breast (if older + estrogen exposure); (4) **For transgender men**: - **Testosterone** (IM, SC, transdermal, gel, pellet); - **Effects**: deepening voice (permanent), facial hair (permanent), clitoromegaly (permanent), menstruation cessation (1-6 mo), fat redistribution; - **Monitoring**: testosterone, lipid, Hct (erythrocytosis), LFT, BP, mental health; - Continued cervical + breast screening if applicable; - **Contraception** consideration if uterus + ovaries + sexual activity with sperm-producing partner (pregnancy possible despite testosterone); (5) **Surgical gender-affirming options**: - Facial feminization / masculinization; - Top surgery (breast augmentation / mastectomy); - Bottom surgery (vaginoplasty, phalloplasty, metoidioplasty, hysterectomy + orophorectomy); - Voice surgery; - Body contouring; - Multidisciplinary care + experienced surgeons; - Specific post-op care + monitoring; (6) **Adolescent gender-affirming care** (controversial politically, supported by major medical organizations): - **WPATH SOC 8** adolescents: assessment by qualified clinician, consideration developmental + family, puberty blockers (GnRH agonists) for early-pubertal as reversible bridge, GAHT later, surgery generally adulthood (some exceptions); - Family + school + community support; - Mental health support; - Affirming care reduces suicide, depression, anxiety; (7) **Legal + ID changes** — navigation; (8) **Insurance coverage** — variable; advocacy; (9) **Mental health support** — affirming therapist; specific resources; (10) **Family + community involvement**; (11) **Multidisciplinary**: PCP + endocrinology + mental health + surgery (multidisciplinary GAS team) + voice therapist + reproductive medicine + advocacy + community + family

---

LGBTQ+ + transgender care: affirming + correct name/pronouns + inclusive forms. Preventive care per organs present. Mental health support critical. GAHT per WPATH SOC 8 — estrogen + anti-androgen feminization; testosterone masculinization. Adolescent GAC affirming. Surgical options. Multidisciplinary.', NULL,
  'hard', 'obgyn', 'review',
  'family_medicine', 'integrative', 'obgyn', 'adult',
  'WPATH SOC 8; Endocrine Society Transgender 2017', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 28 ปี transgender woman (assigned male at birth, female gender identity) — establishing primary care + interested gender-affirming care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 70 ปี advanced HF (NYHA IV) + multimorbid + decline + caregiver burnout — primary care + palliative + family-centered', '[{"label":"A","text":"Hospice only end of life"},{"label":"B","text":"Palliative Care in Primary Care (NHPCO + CAPC + Center to Advance Palliative Care)"},{"label":"C","text":"No symptom management"},{"label":"D","text":"Single visit referral"},{"label":"E","text":"Curative treatment only until death"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Palliative Care in Primary Care (NHPCO + CAPC + Center to Advance Palliative Care): (1) **Palliative care = serious illness care** — at any stage, alongside curative treatment; not just end-of-life; specialty workforce limited so primary care palliative care critical; (2) **Symptom management**: - **Pain** — multimodal opioid + adjuvant; - **Dyspnea** — treat underlying + opioids low-dose effective + fan + position + O2 if hypoxic + benzo if anxiety component; - **Nausea** — etiology-targeted; - **Constipation** — universal opioid users; - **Anorexia / cachexia** — explore + avoid forced feeding; - **Fatigue**; - **Anxiety + depression**; - **Insomnia**; - **Delirium**; - **Spiritual distress**; (3) **Advance care planning (ACP)**: - **Goals of care** discussions (Serious Illness Conversation Guide); - **POLST / MOLST** actionable medical orders; - **Advance directive** + living will + healthcare POA; - **Code status**; - **Surrogate decision-maker**; - **Cultural + religious considerations**; - **Five Wishes** patient-friendly tool; - Ongoing conversations as conditions change; (4) **Hospice eligibility + referral**: - **Prognosis ≤ 6 mo** if disease takes natural course; - Disease-specific guidelines (NHPCO LCD); - Medicare hospice benefit + most insurance; - Goals shift to comfort + quality of life; - Multidisciplinary team (MD, RN, SW, chaplain, aide, volunteer, bereavement); - Home, nursing facility, inpatient hospice, hospital; - Curative treatment generally discontinued (some integration emerging); (5) **HF-specific palliative**: - Specific symptom management (diuretics, opioids for dyspnea, anxiolytics); - Device deactivation discussions (ICD, LVAD); - Disposition (home, hospice, LTAC); - Inpatient palliative consult for complex; - Specialist HF + palliative co-management; (6) **Caregiver support critical**: - Education + skills training; - Respite care (in-home, adult day care, short-term residential); - Support groups + counseling; - Address caregiver burnout (Zarit Burden); - **Family meetings**; - Grief + bereavement support during + after; - Practical help (Meals on Wheels, transportation); - Financial counseling; (7) **Spiritual + cultural care**: chaplain + faith community + cultural humility; (8) **Existential + emotional**: meaning-making, life review, dignity therapy, art/music therapy, complementary practices; (9) **Coordinated transitions** + communication across settings; (10) **Bereavement support** for family — typically 13 months hospice; (11) **Pediatric palliative care + perinatal palliative care** — specialized but similar principles; (12) **Equity in palliative + hospice access** — disparities by race, ethnicity, geography, language; address; (13) **Provider self-care** + grief — accumulating loss; debrief + support; (14) **Multidisciplinary integrative**: PCP + palliative care specialist + hospice + cardiology (HF specialist) + nursing + social work + chaplain + caregivers + family + community + behavioral health + pharmacy + nutritionist + therapists

---

Palliative care = serious illness care any stage. Symptom management (pain, dyspnea — opioids effective, NV, constipation, fatigue, mood). Advance care planning + hospice if ≤ 6 mo. HF-specific. Caregiver support critical. Spiritual + bereavement. Equity. Multidisciplinary integrative.', NULL,
  'medium', 'signs_symptoms', 'review',
  'family_medicine', 'integrative', 'signs_symptoms', 'adult',
  'NHPCO; CAPC; Ariadne SI', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'fammed_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'family_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 70 ปี advanced HF (NYHA IV) + multimorbid + decline + caregiver burnout — primary care + palliative + family-centered'
  );

commit;

