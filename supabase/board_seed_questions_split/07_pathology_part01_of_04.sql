-- ===============================================================
-- หมอรู้ — Board seed: พยาธิวิทยา (pathology) — part 1/4 (50 MCQs)
-- Safe to paste into Supabase SQL Editor. Re-runnable.
-- ===============================================================

begin;

-- mcq_subjects for this specialty (idempotent)
insert into public.mcq_subjects
  (name, name_th, icon, audience, board_specialty, exam_type, question_count)
values
  ('path_clinical_decision', 'พยาธิวิทยา · การตัดสินใจทางเวชกรรม', '🩺', 'board', 'pathology', NULL, 0),
  ('path_basic_science', 'พยาธิวิทยา · วิทยาศาสตร์การแพทย์พื้นฐาน', '🧬', 'board', 'pathology', NULL, 0),
  ('path_ems_mgmt', 'พยาธิวิทยา · การจัดการระบบบริการการแพทย์ฉุกเฉิน', '🚨', 'board', 'pathology', NULL, 0),
  ('path_integrative', 'พยาธิวิทยา · ข้อสอบบูรณาการ', '🧩', 'board', 'pathology', NULL, 0)
on conflict (name) do nothing;

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี breast lump biopsy — histopathology + immunohistochemistry results: invasive ductal carcinoma, grade 2, ER 95%+ PR 70%+ HER2 IHC 3+ confirmed by FISH amplification', '[{"label":"A","text":"No treatment"},{"label":"B","text":"Breast Cancer Pathology Interpretation"},{"label":"C","text":"Surgery only"},{"label":"D","text":"Refuse"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Breast Cancer Pathology Interpretation: (1) **Histologic type**: invasive ductal carcinoma (IDC) — most common; other types — lobular, mucinous, tubular, medullary, metaplastic; (2) **Grade (Nottingham)**: based on tubule formation + nuclear pleomorphism + mitotic count — 1 (well) to 3 (poorly differentiated); (3) **Stage**: AJCC TNM (T size, N nodes, M metastases) + anatomic + prognostic; (4) **Biomarkers** (essential for treatment decisions): - **ER (estrogen receptor)** + percent positive — predicts hormone therapy benefit; - **PR (progesterone receptor)** — confirms ER pathway; - **HER2** by IHC (0, 1+, 2+, 3+) → FISH for 2+ to confirm amplification; this patient HER2+ → targeted therapy; - **Ki-67** proliferation index; (5) **Molecular subtypes**: Luminal A (ER+, HER2-, low Ki-67), Luminal B (ER+, HER2- high Ki-67 or HER2+), HER2-enriched, Triple-negative (TNBC); (6) **Genomic assays**: Oncotype DX 21-gene recurrence score, MammaPrint, PAM50 — guide adjuvant chemo decisions in ER+/HER2-; (7) **HER2+ implications**: trastuzumab + pertuzumab targeted therapy improves survival dramatically; (8) **Triple-negative**: PARP inhibitors if BRCA, immunotherapy (pembrolizumab) for PD-L1+; (9) **Multidisciplinary tumor board**: pathology + surgery + medical oncology + radiation oncology + radiology + genetics; (10) **Genetic counseling**: BRCA + others when criteria met; (11) **Modern**: precision oncology + molecular characterization + targeted therapy

---

Breast cancer pathology: histologic type + grade + stage + biomarkers (ER, PR, HER2, Ki-67) → molecular subtypes → treatment selection. Genomic assays for adjuvant decisions. HER2+ → targeted therapy. Multidisciplinary tumor board. Modern: precision oncology.', NULL,
  'medium', 'hemato_onco', 'review',
  'pathology', 'clinical_decision', 'hemato_onco', 'adult',
  'ASCO/CAP Breast Cancer Biomarkers; NCCN', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี breast lump biopsy — histopathology + immunohistochemistry results: invasive ductal carcinoma, grade 2, ER 95%+ PR 70%+ HER2 IHC 3+ confirmed by FISH amplification'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี — peripheral blood smear shows immature blasts with Auer rods + CBC: WBC 45,000, Hb 8.4, Plt 28,000 — concerned acute leukemia', '[{"label":"A","text":"Ignore"},{"label":"B","text":"Acute Leukemia Pathology Diagnosis"},{"label":"C","text":"Surgery"},{"label":"D","text":"Refuse"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Leukemia Pathology Diagnosis: (1) **Initial workup**: CBC + peripheral smear + bone marrow biopsy + aspirate; (2) **Acute Myeloid Leukemia (AML)**: blasts ≥ 20% in marrow (or PB); Auer rods pathognomonic; (3) **Acute Lymphoblastic Leukemia (ALL)**: blasts ≥ 20% lymphoid lineage; (4) **Distinguishing**: morphology + immunophenotype (flow cytometry — myeloid markers MPO, CD13, CD33, CD117 vs lymphoid markers CD19, CD20, CD10, TdT) + cytochemistry (MPO+ in AML); (5) **Cytogenetics + molecular essential**: - AML good prognosis: t(8;21), inv(16), t(15;17) — APL (acute promyelocytic — treat differently with ATRA + arsenic); - AML poor: complex karyotype, monosomy 5, 7; - AML molecular: FLT3-ITD, NPM1, CEBPA, TP53, IDH1/2 + targeted therapies (gilteritinib, midostaurin for FLT3, venetoclax-azacitidine combos); - ALL: Philadelphia chromosome t(9;22) BCR-ABL — TKI added; (6) **Treatment based on subtype**: - AML: 7+3 induction (cytarabine + anthracycline) → consolidation → consider HCT (hematopoietic cell transplant); - APL: ATRA + arsenic — > 90% cure (don''t miss — DIC risk if delayed); - ALL: multi-agent chemo + CNS prophylaxis + +/- HCT; (7) **Supportive care**: blood products, antibiotic, tumor lysis prophylaxis, fever workup; (8) **Multidisciplinary**: heme-onc + pathology + transplant + ID + ICU; (9) **Modern**: targeted therapies, immunotherapy (CAR-T, blinatumomab for ALL), MRD monitoring; (10) **Long-term survivorship + late effects**

---

Acute leukemia diagnosis: morphology + immunophenotype (flow) + cytochemistry + cytogenetics + molecular. Auer rods → AML. APL (t(15;17)) treated differently (ATRA + arsenic). Subtype-based treatment + targeted therapies + immunotherapy. Multidisciplinary + supportive care.', NULL,
  'hard', 'hemato_onco', 'review',
  'pathology', 'clinical_decision', 'hemato_onco', 'adult',
  'WHO Classification of Hematologic Neoplasms 2022; NCCN AML', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี — peripheral blood smear shows immature blasts with Auer rods + CBC: WBC 45,000, Hb 8.4, Plt 28,000 — concerned acute leukemia'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 45 ปี — chronic diarrhea + weight loss + colonoscopy with biopsy — pathology: chronic active inflammation + crypt distortion + granulomas — IBD workup', '[{"label":"A","text":"Random treatment"},{"label":"B","text":"IBD Pathology + Diagnosis"},{"label":"C","text":"Refuse"},{"label":"D","text":"Discharge"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** IBD Pathology + Diagnosis: (1) **Crohn''s vs UC differentiation**: - **Crohn''s**: transmural inflammation, skip lesions, granulomas (50%), strictures, fistulas, can affect any GI from mouth to anus, terminal ileum most common; - **UC**: continuous mucosal + submucosal inflammation, starts rectum + extends proximally, no granulomas, crypt abscesses, no skip lesions; - **Indeterminate colitis**: features of both; (2) **Histology**: chronic + active inflammation; crypt distortion (chronic); granulomas (Crohn''s); rule out infection + ischemia + drug-induced; (3) **Other workup**: endoscopy + biopsy; CT/MR enterography (small bowel for Crohn''s); fecal calprotectin (active inflammation); stool studies (C. difficile, parasites, bacterial); serologies (ASCA Crohn''s, p-ANCA UC); (4) **Treatment based on type + severity** (ACG + ECCO guidelines): - 5-ASA (mesalamine) for mild UC; - Corticosteroids for moderate-severe induction (not maintenance); - Immunomodulators (azathioprine, methotrexate); - Biologics (anti-TNF — infliximab, adalimumab; anti-integrin — vedolizumab; anti-IL12/23 — ustekinumab, risankizumab; anti-IL23 — risankizumab; JAK inhibitors — tofacitinib, upadacitinib); - Small molecule (S1P — ozanimod); (5) **Surgery**: for refractory + complications; can be curative in UC (proctocolectomy); not curative in Crohn''s; (6) **Surveillance for dysplasia + colon cancer**: increased risk with longstanding colitis, IBD-related cancer differs from sporadic; (7) **Complications**: strictures, fistulas, abscesses, perforation, dysplasia, malnutrition, growth failure (peds), extraintestinal (skin, joints, eyes, liver — PSC); (8) **Multidisciplinary**: GI + surgery + pathology + radiology + nutrition + mental health

---

IBD pathology: Crohn''s (transmural, granulomas, skip lesions) vs UC (mucosal continuous from rectum). Treatment by type + severity. Biologics + small molecules expanded options. Surveillance for dysplasia/cancer. Multidisciplinary. Modern: precision + biologics.', NULL,
  'medium', 'gi', 'review',
  'pathology', 'clinical_decision', 'gi', 'adult',
  'ACG; ECCO IBD Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 45 ปี — chronic diarrhea + weight loss + colonoscopy with biopsy — pathology: chronic active inflammation + crypt distortion + granulomas — IBD workup'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 70 ปี — sputum AFB smear positive + Mycobacterium tuberculosis identified — drug susceptibility testing pending — pulmonary TB workup', '[{"label":"A","text":"Ignore"},{"label":"B","text":"TB Diagnosis + Drug Susceptibility (CDC + WHO)"},{"label":"C","text":"Surgery"},{"label":"D","text":"Refuse"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** TB Diagnosis + Drug Susceptibility (CDC + WHO): (1) **Initial diagnostics**: AFB smear (sensitivity 50-70%, fast), TB culture (gold standard but slow 4-8 wk), NAAT (Xpert MTB/RIF — rapid + detects rifampin resistance); (2) **Drug susceptibility testing (DST)**: essential — phenotypic (slow) + genotypic (rapid — line probe assay, sequencing); (3) **Categories**: drug-susceptible (DS), MDR (multi-drug resistant — resistant to ≥ INH + RIF), pre-XDR/XDR (extensively — adds fluoroquinolone + second-line); (4) **Treatment based on susceptibility**: - **DS-TB**: 6-month standard regimen (RIPE 2 mo intensive + RI 4 mo continuation) OR shorter 4-month regimen rifapentine + moxifloxacin (Study 31, 2022); - **MDR-TB**: longer (9-24 months) all-oral with bedaquiline + linezolid + levofloxacin/moxifloxacin + others (BPaL regimen — bedaquiline + pretomanid + linezolid for 6 months — Nix-TB/ZeNix trials, revolutionary); (5) **Isolation**: airborne precautions in hospitals until non-infectious; (6) **HIV testing all TB** (high co-infection); (7) **DOT (Directly Observed Therapy)** for adherence; (8) **Public health reporting** + contact tracing; (9) **Treatment of contacts** (LTBI — latent TB infection): rifamycin-based shorter regimens (3HP — 12 wk rifapentine + INH preferred; 4R — 4 mo rifampin; 6-9 mo INH); (10) **Monitor**: clinical, sputum AFB, LFT, CBC, vision (ethambutol), uric acid; (11) **Multidisciplinary**: TB program + ID + pulmonology + public health

---

TB pathology: AFB + culture + NAAT (Xpert) + DST essential. DS standard 6-month regimen or 4-month new. MDR — BPaL revolutionary 6-month all-oral. DOT + isolation + public health reporting. Contact tracing + LTBI treatment. Multidisciplinary.', NULL,
  'medium', 'id', 'review',
  'pathology', 'clinical_decision', 'id', 'adult',
  'WHO TB Guidelines; CDC; ATS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 70 ปี — sputum AFB smear positive + Mycobacterium tuberculosis identified — drug susceptibility testing pending — pulmonary TB workup'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี — autoimmune hepatitis workup — labs: AST/ALT elevated + ANA positive + anti-smooth muscle Ab positive + IgG elevated + liver biopsy: interface hepatitis + lymphoplasmacytic infiltrate', '[{"label":"A","text":"Ignore"},{"label":"B","text":"Autoimmune Hepatitis Diagnosis + Management"},{"label":"C","text":"Surgery"},{"label":"D","text":"Refuse"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Autoimmune Hepatitis Diagnosis + Management: (1) **AIH Type 1**: ANA + ASMA + IgG elevation (most common); (2) **AIH Type 2**: anti-LKM1 (children); (3) **Histology**: interface hepatitis (inflammation at limiting plate) + lymphoplasmacytic infiltrate + rosette formation; (4) **Differential**: viral hepatitis (Hep A/B/C/E), drug-induced (DILI), Wilson''s, NAFLD, alcohol, hemochromatosis, PBC, PSC; (5) **Workup**: viral hepatitis serologies, drug history, metabolic (ferritin, ceruloplasmin, alpha-1 antitrypsin), AMA (PBC overlap); (6) **Treatment** (AASLD + EASL): - **Prednisone + Azathioprine** combination first-line; - **Budesonide** alternative initial (less systemic SE — non-cirrhotic only); - **Mycophenolate** for AZA-intolerant; - **Calcineurin inhibitors** (cyclosporine, tacrolimus) for refractory; - **Rituximab** considered; (7) **Goal**: biochemical remission (normal LFTs + IgG); sustained ~ 3-5 yr before trial of discontinuation; high relapse rate (50-80%) — many lifelong therapy; (8) **Monitor**: LFTs + clinical regularly; bone density (steroid risk); pregnancy planning; (9) **Vaccinations**: hepatitis A/B, flu, pneumo, COVID, shingles; (10) **Cirrhosis surveillance**: HCC screening with US + AFP q6 mo; (11) **Transplant** for end-stage; can recur post-transplant; (12) **Multidisciplinary**: hepatology + pathology + rheumatology + pharmacy + transplant + primary care

---

AIH: serology + histology (interface hepatitis + lymphoplasmacytic) + IgG. Rule out other causes. Treatment: pred + AZA; biochemical remission goal. Often lifelong therapy. Monitoring + complications. Multidisciplinary care.', NULL,
  'medium', 'gi', 'review',
  'pathology', 'clinical_decision', 'gi', 'adult',
  'AASLD AIH 2019; EASL', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี — autoimmune hepatitis workup — labs: AST/ALT elevated + ANA positive + anti-smooth muscle Ab positive + IgG elevated + liver biopsy: interface hepatitis + lymphoplasmacytic infiltrate'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 35 ปี — gravid uterus + concerns about gestational trophoblastic disease — hCG very elevated + US — complete hydatidiform mole', '[{"label":"A","text":"Ignore"},{"label":"B","text":"Gestational Trophoblastic Disease Pathology"},{"label":"C","text":"Hysterectomy first"},{"label":"D","text":"Refuse"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Gestational Trophoblastic Disease Pathology: (1) **Spectrum (GTD)**: hydatidiform mole (complete + partial) → invasive mole → gestational trophoblastic neoplasia (GTN — choriocarcinoma, placental site trophoblastic tumor, epithelioid trophoblastic tumor); (2) **Complete mole**: diploid 46,XX or 46,XY all paternal; no fetal tissue; markedly elevated hCG; ''snowstorm'' US; 20% risk progression to GTN; (3) **Partial mole**: triploid (69 chromosomes); some fetal tissue; less elevated hCG; 5% risk progression; (4) **Pathology**: villi with central cisternal cavitation, trophoblastic proliferation, no fetal blood vessels (complete); (5) **Management**: - **Suction D+C** (dilation + curettage) of uterus — primary treatment; - **Anti-D immunoglobulin** if Rh-negative; - **Weekly hCG monitoring** until 3 consecutive undetectable then monthly × 6 months; - **Contraception** essential during follow-up (avoid pregnancy 6 mo — confounds hCG); IUD acceptable per recent evidence; (6) **GTN diagnosis**: persistent hCG plateau or rise after evacuation, hCG > 20,000 4 wk post-evacuation, hCG > 6 months persistence, metastases, histology of choriocarcinoma; (7) **GTN treatment** (highly chemosensitive — excellent prognosis): - Low-risk (WHO score 0-6): methotrexate or actinomycin-D single agent; - High-risk (≥ 7): EMA-CO (etoposide + MTX + actinomycin + cyclophosphamide + vincristine) multi-agent; - Brain metastases: high-dose intrathecal MTX, RT consideration; (8) **Prognosis**: > 95% cure even metastatic; (9) **Multidisciplinary**: OB-GYN + GYN-oncology + medical oncology + pathology

---

GTD: spectrum from mole to GTN. D+C primary; hCG monitoring + contraception. GTN diagnosis criteria; methotrexate or EMA-CO treatment. > 95% cure even metastatic. Multidisciplinary. Modern: chemo highly curative.', NULL,
  'medium', 'obgyn', 'review',
  'pathology', 'clinical_decision', 'obgyn', 'adult',
  'ACOG; FIGO; ESMO GTD', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 35 ปี — gravid uterus + concerns about gestational trophoblastic disease — hCG very elevated + US — complete hydatidiform mole'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี — Hodgkin lymphoma — lymph node biopsy + Reed-Sternberg cells + EBV positive — staging + treatment', '[{"label":"A","text":"Ignore"},{"label":"B","text":"Hodgkin Lymphoma Pathology + Management"},{"label":"C","text":"Surgery only"},{"label":"D","text":"Refuse"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hodgkin Lymphoma Pathology + Management: (1) **Classic Hodgkin Lymphoma (CHL)**: Reed-Sternberg cells (large, multinucleated, mirror image — "owl eye") + lacunar variants; CD30+ CD15+ usually CD45-; B-cell origin; EBV association in some; (2) **Subtypes**: nodular sclerosis (most common), mixed cellularity, lymphocyte-rich, lymphocyte-depleted; (3) **Nodular Lymphocyte-Predominant HL (NLPHL)**: distinct entity — LP/popcorn cells, CD20+ CD45+; treated differently; (4) **Staging (Ann Arbor + Lugano)**: I-IV based on node + organ involvement; A/B symptoms; bulky disease; (5) **Workup**: PET-CT (functional + anatomic), bone marrow biopsy (selective), CBC, LDH, ESR, HIV; (6) **Treatment (excellent overall — 80-90% cure rate)**: - **Early-stage favorable**: ABVD × 2 cycles + 20 Gy IFRT; - **Early-stage unfavorable**: ABVD × 4 cycles + 30 Gy IFRT; - **Advanced (Stage III-IV)**: ABVD × 6 cycles; eBEACOPP for high-risk + poor PET2; brentuximab + AVD (A+AVD) alternative — ECHELON-1 trial; - **PET-adapted therapy**: deintensify if PET2 negative; (7) **Relapsed/refractory**: brentuximab vedotin (anti-CD30 ADC), checkpoint inhibitors (nivolumab, pembrolizumab — KEYNOTE), autologous HCT; (8) **Late effects**: secondary malignancy (breast, lung, etc.), cardiotoxicity (anthracycline + RT), fertility, thyroid, lung fibrosis, infertility; (9) **Survivorship care**: lifelong surveillance for late effects; (10) **Multidisciplinary**: heme-onc + pathology + radiation + cardiology + endocrinology + reproductive + survivorship; (11) **Excellent prognosis** even relapsed with modern therapies

---

Hodgkin lymphoma: Reed-Sternberg cells, CD30/15. PET-adapted therapy. ABVD or A+AVD. Brentuximab + checkpoint inhibitors for relapse. Late effects significant. Multidisciplinary. Modern: high cure rates + reducing toxicity.', NULL,
  'medium', 'hemato_onco', 'review',
  'pathology', 'clinical_decision', 'hemato_onco', 'adult',
  'NCCN Hodgkin Lymphoma; ECHELON-1', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี — Hodgkin lymphoma — lymph node biopsy + Reed-Sternberg cells + EBV positive — staging + treatment'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี — prostate biopsy — Gleason 4+3 = 7 (Grade Group 3) — pathology guides management', '[{"label":"A","text":"Ignore"},{"label":"B","text":"Prostate Cancer Pathology Grading"},{"label":"C","text":"Surgery only"},{"label":"D","text":"Refuse"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Prostate Cancer Pathology Grading: (1) **Gleason grading** (most validated cancer grading): primary + secondary pattern (1-5 each); modern Grade Group system (ISUP 2014): - GG 1: Gleason 3+3 = 6; - GG 2: Gleason 3+4 = 7; - GG 3: Gleason 4+3 = 7; - GG 4: Gleason 4+4 = 8; - GG 5: Gleason 9 or 10; (2) **Grade Group affects prognosis + treatment**; (3) **Other pathologic features**: percentage of involvement, perineural invasion, extraprostatic extension, seminal vesicle invasion, lymph node status; (4) **Risk stratification** (NCCN): - Very low: GG 1, PSA < 10, < 3 cores positive, < 50% in cores; - Low: GG 1, PSA < 10; - Intermediate (favorable vs unfavorable): GG 2-3; - High: GG 4-5 or T3a, PSA > 20; - Very high: T3b-4 or GG 5, etc.; (5) **Treatment based on risk + life expectancy**: - **Active surveillance**: GG 1, selected GG 2 (low-risk) — serial PSA + DRE + MRI + repeat biopsy; reduce overtreatment; - **Surgery (radical prostatectomy)**: open, lap, robotic; - **Radiation**: external beam (IMRT, SBRT, proton), brachytherapy (LDR, HDR); - **ADT (androgen deprivation therapy)**: GnRH agonist/antagonist + antiandrogen; - **Combination ADT + RT** for intermediate-high; - **Combination ADT + chemotherapy or novel hormonals** (abiraterone, enzalutamide, apalutamide) for high-risk + metastatic; (6) **Modern**: precision — genomic classifier (Oncotype, Polaris, Decipher) refines risk; (7) **Recurrent/metastatic**: salvage RT + ADT; novel hormonals (abiraterone, enzalutamide, apalutamide, darolutamide); PARP inhibitors (BRCA); PSMA radioligand therapy (Pluvicto Lu-177); chemotherapy (docetaxel, cabazitaxel); (8) **Multidisciplinary**: urology + radiation oncology + medical oncology + pathology + genetics + survivorship

---

Prostate cancer: Gleason + Grade Group system. Risk stratification (NCCN). Treatment by risk + life expectancy (AS for low, surgery/radiation, ADT, novel hormonals, PARP, PSMA). Modern: genomic classifiers + targeted therapies + precision. Multidisciplinary.', NULL,
  'medium', 'hemato_onco', 'review',
  'pathology', 'clinical_decision', 'hemato_onco', 'adult',
  'NCCN Prostate Cancer; ISUP Gleason 2014', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี — prostate biopsy — Gleason 4+3 = 7 (Grade Group 3) — pathology guides management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 30 ปี — pleural effusion + lymph node biopsy — pathology: caseating granulomas — AFB stain positive — sputum mycobacterium culture pending', '[{"label":"A","text":"No treatment"},{"label":"B","text":"Granulomatous Disease Pathology Workup"},{"label":"C","text":"Surgery"},{"label":"D","text":"Refuse"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Granulomatous Disease Pathology Workup: (1) **Caseating granulomas with AFB+** = TB until proven otherwise; (2) **Differential of granulomatous disease**: - **Infections**: TB (caseating most common), atypical mycobacteria, fungal (histoplasmosis, blastomycosis, coccidioidomycosis, cryptococcosis), parasitic (toxoplasmosis), Brucella, leprosy, syphilis (rare); - **Non-infectious**: sarcoidosis (non-caseating), Crohn''s, granulomatous polyangiitis (GPA), Churg-Strauss, foreign body, drug-induced, primary biliary cholangitis, primary immunodeficiencies, hypersensitivity pneumonitis, berylliosis; (3) **Sarcoidosis** features: non-caseating, multisystem (lung most), young adults Black > White, ACE may be elevated, hilar lymphadenopathy on imaging, often spontaneous remission; (4) **Workup further**: histology + special stains (AFB, GMS for fungi, etc.), culture, NAAT, serologies (autoimmune, fungal), ACE, calcium, eye exam (sarcoid uveitis); (5) **TB treatment** if confirmed: standard regimen + DOT + isolation + contact tracing (already covered); (6) **Sarcoidosis treatment**: observation many spontaneously remit; corticosteroids for symptomatic (lung function, CNS, cardiac, eye, hypercalcemia, severe skin); methotrexate, azathioprine, biologics for refractory; (7) **Multidisciplinary**: pulmonology + ID + pathology + rheumatology + ophthalmology + cardiology if systemic

---

Granulomatous disease: caseating most often TB (AFB +); non-caseating includes sarcoid + others. Workup with stains + culture + NAAT + serology. Treatment by underlying. Multidisciplinary. Modern: precision diagnostics + targeted therapy.', NULL,
  'medium', 'id', 'review',
  'pathology', 'clinical_decision', 'id', 'adult',
  'ATS Sarcoidosis; WHO TB', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 30 ปี — pleural effusion + lymph node biopsy — pathology: caseating granulomas — AFB stain positive — sputum mycobacterium culture pending'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี — surgery for colon cancer — pathology: invasive adenocarcinoma + MMR/MSI testing — needed for treatment + family screening', '[{"label":"A","text":"Ignore molecular"},{"label":"B","text":"Molecular Pathology in Cancer (precision medicine — colon cancer example)"},{"label":"C","text":"Random treatment"},{"label":"D","text":"Refuse"},{"label":"E","text":"No testing"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Molecular Pathology in Cancer (precision medicine — colon cancer example): (1) **Microsatellite instability (MSI) / Mismatch Repair (MMR) testing**: - MSI-H or MMR-deficient (dMMR) — hypermutated phenotype; - MMR proteins: MLH1, MSH2, MSH6, PMS2 IHC; loss of expression = dMMR; - MSI testing by PCR alternative; - **Implications**: better prognosis stage II (no chemo benefit), worse stage IV unless immunotherapy; **PEMBROLIZUMAB or NIVOLUMAB** highly effective in MSI-H/dMMR tumors (KEYNOTE-177 — pembro better than chemo first-line metastatic dMMR); - **Lynch syndrome screening**: MSH/MSH2/MSH6/PMS2 germline mutations — autosomal dominant; family screening; risk-reducing strategies; (2) **RAS testing** (KRAS, NRAS): mutations predict resistance to anti-EGFR (cetuximab, panitumumab) — only RAS wild-type benefit; (3) **BRAF testing** (V600E): poor prognosis; targeted therapy (encorafenib + cetuximab — BEACON trial); (4) **HER2 testing**: amplification — trastuzumab + tucatinib (mountaineer trial); (5) **NTRK fusions** (rare): larotrectinib, entrectinib (tumor agnostic); (6) **Tumor mutational burden (TMB)**: high TMB — checkpoint inhibitor benefit; (7) **Liquid biopsy** (ctDNA): MRD monitoring, treatment response, recurrence detection; (8) **Hereditary cancer testing + counseling**: Lynch, FAP, MUTYH-associated polyposis, Peutz-Jeghers; family implications; (9) **Multidisciplinary tumor board**: pathology + medical oncology + genetics + surgery; (10) **Modern**: precision oncology + biomarker-driven + immunotherapy + tumor-agnostic therapies

---

Molecular pathology: MSI/MMR + RAS + BRAF + HER2 + NTRK + TMB testing — precision oncology. KEYNOTE-177 — pembrolizumab better than chemo for dMMR. Lynch screening implications. Liquid biopsy emerging. Multidisciplinary. Modern: biomarker-driven precision medicine.', NULL,
  'hard', 'hemato_onco', 'review',
  'pathology', 'clinical_decision', 'hemato_onco', 'adult',
  'NCCN Colon Cancer; KEYNOTE-177', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี — surgery for colon cancer — pathology: invasive adenocarcinoma + MMR/MSI testing — needed for treatment + family screening'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี — proteinuria + edema + renal biopsy: thickened glomerular basement membranes + IgG + C3 immunofluorescence + ''spike'' pattern on EM — membranous nephropathy', '[{"label":"A","text":"Random"},{"label":"B","text":"Renal Pathology — Membranous Nephropathy + Glomerular Diseases"},{"label":"C","text":"Surgery"},{"label":"D","text":"Refuse"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Renal Pathology — Membranous Nephropathy + Glomerular Diseases: (1) **Membranous nephropathy (MN)**: subepithelial immune complex deposits → thickening of GBM (basement membrane); ''spike + dome'' on EM; IgG + C3 IF; (2) **PLA2R antibody** (anti-phospholipase A2 receptor): primary (idiopathic) MN — 70-80% positive; serologic marker, helpful for diagnosis + monitoring; (3) **Secondary MN causes**: malignancy (especially solid tumors > 65), hepatitis B/C, autoimmune (SLE), drugs (NSAIDs, gold, penicillamine), infections — workup if PLA2R negative or atypical; (4) **Treatment** (KDIGO 2021): - Risk stratification by proteinuria + GFR + autoantibody; - Low-risk: supportive (ACEi/ARB, salt restriction, lipid, anticoagulation if severe proteinuria); 30% spontaneous remission; - High-risk: immunosuppression (rituximab, cyclophosphamide + steroid alternating Ponticelli, calcineurin inhibitors); rituximab increasingly first-line — MENTOR trial; (5) **Other primary glomerular diseases**: - **Minimal Change Disease**: foot process effacement on EM; treatment steroids — children + adults; - **FSGS**: focal segmental scarring; classic vs secondary causes (HIV, obesity, reflux); steroids + CNIs; - **IgA Nephropathy**: most common GN globally; IgA mesangial deposits; - **MPGN/C3 glomerulopathy**: low C3, complement pathway abnormalities; - **Lupus Nephritis**: 6 classes per ISN/RPS; immunosuppression for class III/IV; (6) **Nephritic vs nephrotic syndrome** classification; (7) **Multidisciplinary**: nephrology + pathology + rheumatology

---

Renal pathology: membranous nephropathy (PLA2R Ab marker), classes of glomerular disease (minimal change, FSGS, IgA, lupus, MPGN). KDIGO 2021 risk-based Rx. Rituximab MENTOR. Multidisciplinary care.', NULL,
  'hard', 'renal_gu', 'review',
  'pathology', 'clinical_decision', 'renal_gu', 'adult',
  'KDIGO Glomerular Diseases 2021', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี — proteinuria + edema + renal biopsy: thickened glomerular basement membranes + IgG + C3 immunofluorescence + ''spike'' pattern on EM — membranous nephropathy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี — thyroid nodule biopsy — papillary thyroid carcinoma classical variant + BRAF V600E mutation', '[{"label":"A","text":"Ignore"},{"label":"B","text":"Thyroid Cancer Pathology + Management"},{"label":"C","text":"Surgery only"},{"label":"D","text":"Refuse"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Thyroid Cancer Pathology + Management: (1) **Differentiated Thyroid Cancer (DTC)**: papillary (most common 80%), follicular (10-15%), Hürthle cell variant; oncocytic features; (2) **Papillary features**: papillae + clear nuclei (Orphan Annie) + nuclear grooves + pseudoinclusions; (3) **Variants of PTC**: classical, follicular variant (more indolent), tall cell (aggressive), columnar cell (aggressive), hobnail (aggressive), diffuse sclerosing (peds); (4) **Molecular**: BRAF V600E (most common, ~ 50%), RET/PTC rearrangements, RAS mutations, TERT promoter mutations (worse prognosis); (5) **Other thyroid cancers**: medullary (C-cell origin, calcitonin elevated, RET mutations — MEN2), anaplastic (highly aggressive — mortality > 90%, BRAF + others), lymphoma (rare); (6) **Risk stratification (ATA)**: low (small intrathyroidal, no nodes), intermediate (vascular invasion, microscopic ETE, small nodes), high (gross ETE, distant metastases, large nodes, aggressive variants); (7) **Treatment**: - Total thyroidectomy vs lobectomy based on size + risk; - Lymph node dissection (central, lateral) per evidence; - RAI (radioactive iodine) ablation based on risk; - TSH suppression with levothyroxine; - Surveillance: TSH + Tg + neck US; (8) **Targeted therapy** for advanced/refractory: - RAI-refractory: lenvatinib, sorafenib (multikinase TKIs); - **BRAF V600E**: dabrafenib + trametinib (selected); - RET fusion/mutation: selpercatinib, pralsetinib; - NTRK fusions: larotrectinib, entrectinib; (9) **Genetic counseling**: MEN2 for medullary; (10) **Multidisciplinary**: thyroid surgery + endocrinology + nuclear medicine + medical oncology + pathology

---

Thyroid cancer pathology: differentiated (papillary majority) + variants + medullary + anaplastic. Molecular (BRAF, RAS, RET, TERT). ATA risk stratification. Treatment by risk. Targeted therapy for advanced (TKIs, BRAF + MEK, RET inhibitors). Multidisciplinary care.', NULL,
  'medium', 'hemato_onco', 'review',
  'pathology', 'clinical_decision', 'hemato_onco', 'adult',
  'ATA Thyroid Cancer 2015; NCCN', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี — thyroid nodule biopsy — papillary thyroid carcinoma classical variant + BRAF V600E mutation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี smoker — lung biopsy: non-small cell lung cancer adenocarcinoma + molecular: EGFR exon 19 deletion + PD-L1 75%', '[{"label":"A","text":"Random treatment"},{"label":"B","text":"NSCLC Pathology + Precision Therapy"},{"label":"C","text":"Surgery only"},{"label":"D","text":"Refuse"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** NSCLC Pathology + Precision Therapy: (1) **NSCLC types**: adenocarcinoma (most common, peripheral, often non-smokers), squamous cell (central, smokers), large cell, NSCLC NOS; (2) **vs SCLC** (small cell — aggressive, neuroendocrine, smoker, central, paraneoplastic); (3) **Biomarker testing essential** for NSCLC adenocarcinoma (NCCN required for advanced): - **EGFR mutations** (exon 19 del, L858R most common, T790M resistance) — osimertinib first-line; - **ALK rearrangements** — alectinib, lorlatinib first-line; - **ROS1 rearrangements** — crizotinib, entrectinib; - **BRAF V600E** — dabrafenib + trametinib; - **KRAS G12C** — sotorasib, adagrasib; - **MET exon 14 skipping** — capmatinib, tepotinib; - **RET fusion** — selpercatinib, pralsetinib; - **NTRK fusion** — larotrectinib, entrectinib; - **HER2 mutations** — T-DXd, trastuzumab; (4) **PD-L1 testing** (TPS — tumor proportion score): immunotherapy decisions; PD-L1 ≥ 50% — pembrolizumab monotherapy first-line; < 50% — combination chemo + immunotherapy; (5) **Staging**: TNM + AJCC 8th edition; PET-CT + brain MRI + biopsy; (6) **Treatment based on stage + biomarker**: - Early (I-II): surgery + adjuvant chemo + osimertinib (EGFR+); - Locally advanced (III): chemoradiation + durvalumab consolidation (PACIFIC); - Metastatic (IV): targeted therapy if driver, immunotherapy if no driver + PD-L1+; (7) **SCLC**: chemo (platinum + etoposide) + atezolizumab/durvalumab + thoracic RT for limited; PCI; (8) **Multidisciplinary tumor board**: pathology + medical oncology + thoracic surgery + radiation oncology + pulmonology + IR + palliative; (9) **Modern**: precision oncology revolutionizing lung cancer — many patients live years with targeted therapy

---

NSCLC: precision oncology — multiple actionable drivers (EGFR, ALK, ROS1, KRAS G12C, BRAF, MET, RET, NTRK, HER2). PD-L1 testing. Targeted therapy for drivers + immunotherapy for non-drivers. Stage-based treatment. Multidisciplinary. Modern: dramatic outcome improvements.', NULL,
  'hard', 'hemato_onco', 'review',
  'pathology', 'clinical_decision', 'hemato_onco', 'adult',
  'NCCN NSCLC; IASLC', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี smoker — lung biopsy: non-small cell lung cancer adenocarcinoma + molecular: EGFR exon 19 deletion + PD-L1 75%'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 30 ปี — pigmented skin lesion biopsy: melanoma + Breslow thickness 2.5mm + ulceration + mitotic rate elevated', '[{"label":"A","text":"Ignore"},{"label":"B","text":"Melanoma Pathology + Staging + Management"},{"label":"C","text":"Surgery only"},{"label":"D","text":"Refuse"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Melanoma Pathology + Staging + Management: (1) **Histology**: atypical melanocytes, asymmetric, pagetoid spread; Breslow thickness — most important prognostic factor; ulceration adverse; mitotic rate; lymphovascular invasion; perineural; satellite/in-transit; (2) **TNM (AJCC 8th)**: - T by thickness + ulceration; - N by nodes + microsatellite/in-transit; - M includes serum LDH; - Stage 0 (in situ) — IV; (3) **Sentinel lymph node biopsy (SLNB)**: standard for T1b+ (≥ 0.8mm or any with ulceration) — staging + prognosis; (4) **Molecular**: BRAF V600 most common (50%), NRAS, KIT (acral, mucosal), GNAQ/GNA11 (uveal); (5) **Treatment**: - Wide local excision (margins based on thickness — 5mm in situ, 1cm for ≤ 1mm, 1-2cm for 1.01-2mm, 2cm for > 2mm); - SLNB for T1b+; - Completion lymph node dissection — limited indication post-MSLT-II (observation acceptable); - Adjuvant immunotherapy (nivolumab, pembrolizumab) for Stage IIB-IV; targeted (dabrafenib + trametinib) for BRAF+ Stage III; (6) **Metastatic treatment**: - **Immunotherapy**: PD-1 inhibitor (nivo, pembro) +/- CTLA-4 (ipi); RELATIVITY-047 — nivolumab + relatlimab; - **Targeted** (BRAF+): dabrafenib + trametinib, encorafenib + binimetinib; - **TIL therapy** (tumor-infiltrating lymphocytes) — FDA approved 2024 (lifileucel); - Combination + sequential; (7) **Brain mets**: SRS + immunotherapy effective; (8) **Long-term**: surveillance for recurrence + new primaries; (9) **Sun protection + skin checks** lifelong; (10) **Multidisciplinary**: dermatology + surgical oncology + medical oncology + radiation + pathology + genetics

---

Melanoma: Breslow thickness key + ulceration + mitoses. SLNB for T1b+. Molecular (BRAF, NRAS). Treatment: wide excision + immunotherapy + targeted + TIL. Adjuvant for advanced. Modern: dramatic outcomes with immunotherapy + targeted. Multidisciplinary.', NULL,
  'medium', 'hemato_onco', 'review',
  'pathology', 'clinical_decision', 'hemato_onco', 'adult',
  'NCCN Melanoma; AJCC 8th', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 30 ปี — pigmented skin lesion biopsy: melanoma + Breslow thickness 2.5mm + ulceration + mitotic rate elevated'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี — bone pain + anemia + renal failure — bone marrow biopsy: plasma cells > 20% + serum protein electrophoresis: M-spike + BJ proteinuria — multiple myeloma', '[{"label":"A","text":"Random"},{"label":"B","text":"Multiple Myeloma Pathology + Diagnosis"},{"label":"C","text":"Surgery"},{"label":"D","text":"Refuse"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Multiple Myeloma Pathology + Diagnosis: (1) **CRAB criteria** (organ damage): hyperCalcemia, Renal failure, Anemia, Bone lesions; or biomarkers (plasma cells ≥ 60%, FLC ratio ≥ 100, MRI ≥ 1 focal lesion); (2) **IMWG criteria 2014**: bone marrow plasma cells ≥ 10% + monoclonal protein + CRAB or biomarkers; (3) **Diagnostic workup**: SPEP/UPEP (M-spike), immunofixation, serum FLC, BMBx + cytogenetics + FISH, skeletal survey or whole-body low-dose CT/MRI/PET-CT, CBC, Cr, Ca, beta-2 microglobulin, albumin, LDH; (4) **Risk stratification (R-ISS)**: cytogenetics (del 17p, t(4;14), t(14;16), 1q gain — poor) + beta-2 microglobulin + albumin + LDH; (5) **Pathology**: plasma cell infiltration; flame cells, Russell bodies; flow cytometry for clonal (κ/λ restriction); (6) **Treatment** (NCCN + IMWG): - **Triplet/quadruplet induction** then transplant: VRD (bortezomib + lenalidomide + dex), KRD (carfilzomib + len + dex), DARA-VRD or DARA-RVd quad (DETERMINATION/GRIFFIN — daratumumab + RVd improves PFS); - **Autologous HCT** for eligible (age + comorbidity); - Consolidation + maintenance (lenalidomide); - **Newer agents**: CD38 (daratumumab, isatuximab), bispecific (teclistamab, talquetamab), BCMA CAR-T (ide-cel, cilta-cel — revolutionary), selinexor; (6) **Smoldering MM**: monitoring vs early treatment for high-risk (PETHEMA, ECOG E3A06); (7) **Bone health**: bisphosphonate + denosumab; vertebroplasty/kyphoplasty for compression fractures; RT for pain; (8) **Renal failure**: hyperhydration, bortezomib (less nephrotoxic), avoid nephrotoxins; (9) **Supportive care**: prophylactic antibiotics, antifungal, antiviral, IVIG selected, vaccinations, hyperCa management, anemia (EPO); (10) **Long-term**: chronic disease with multiple lines of therapy; modern: median survival > 8-10 years

---

Multiple myeloma: CRAB + IMWG criteria + monoclonal protein. Risk stratification (R-ISS). Triplet/quadruplet induction + transplant + maintenance. Modern: CD38 mAb + bispecifics + BCMA CAR-T revolutionary. Median survival 8-10+ years. Multidisciplinary.', NULL,
  'hard', 'hemato_onco', 'review',
  'pathology', 'clinical_decision', 'hemato_onco', 'adult',
  'IMWG; NCCN Myeloma', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี — bone pain + anemia + renal failure — bone marrow biopsy: plasma cells > 20% + serum protein electrophoresis: M-spike + BJ proteinuria — multiple myeloma'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี — lymphadenopathy + lymph node biopsy: small lymphocytes + flow cytometry CD5+ CD19+ CD23+ — CLL', '[{"label":"A","text":"Ignore"},{"label":"B","text":"CLL Pathology + Management"},{"label":"C","text":"Surgery"},{"label":"D","text":"Refuse"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** CLL Pathology + Management: (1) **CLL diagnosis**: lymphocytosis (> 5,000 monoclonal B cells), classic immunophenotype CD5+ CD19+ CD23+ surface Ig dim, ROR1+, light chain restricted; (2) **vs SLL**: lymph nodes prominent vs marrow + blood; (3) **Smudge cells** on peripheral smear; (4) **Workup**: CBC + smear, BMBx selected, lymph node biopsy if atypical, flow cytometry, FISH for chromosomal (del 17p, 11q, 13q, trisomy 12), IGHV mutation status, TP53; (5) **Staging**: Rai (0-IV) or Binet (A-C); (6) **Prognosis**: - Good: IGHV mutated, isolated 13q, low ZAP-70 + CD38; - Poor: IGHV unmutated, del 17p/TP53 mutation, complex karyotype; (7) **Treatment** indicated for symptomatic, advanced stage, cytopenias, B symptoms: - **Targeted therapy first-line revolutionized care**: - **BTK inhibitors**: ibrutinib (1st gen), acalabrutinib + zanubrutinib (2nd gen — less cardiac); - **Venetoclax** (BCL-2 inhibitor) + anti-CD20 (obinutuzumab) — fixed duration; - **Combination** ibrutinib + venetoclax (selected); - **Chemoimmunotherapy** (FCR — fludarabine + cyclophosphamide + rituximab) less used now, selected IGHV mutated younger; (8) **Richter transformation**: aggressive DLBCL — rare but devastating; (9) **Infections**: high risk (hypogammaglobulinemia + immunodeficiency) — vaccines + antibiotic prophylaxis selected; (10) **Vaccinations**: avoid live; pneumo + flu + COVID + shingles (Shingrix); IVIG for recurrent infections + low IgG; (11) **Multidisciplinary**: heme-onc + pathology + ID + transplant for refractory + secondary malignancy surveillance

---

CLL: CD5+ CD19+ CD23+ classic. Risk by IGHV + cytogenetics. Modern treatment: BTK inhibitors + venetoclax — targeted, fixed duration + improved outcomes. Chemoimmunotherapy less. Infection risk + supportive. Multidisciplinary. Modern: precision + chronic disease management.', NULL,
  'medium', 'hemato_onco', 'review',
  'pathology', 'clinical_decision', 'hemato_onco', 'adult',
  'NCCN CLL; ESMO', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี — lymphadenopathy + lymph node biopsy: small lymphocytes + flow cytometry CD5+ CD19+ CD23+ — CLL'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 35 ปี — HIV positive newly diagnosed — CD4 250 + viral load 80,000', '[{"label":"A","text":"Refuse care"},{"label":"B","text":"HIV Diagnosis + Antiretroviral Therapy"},{"label":"C","text":"Surgery"},{"label":"D","text":"Discharge"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** HIV Diagnosis + Antiretroviral Therapy: (1) **Diagnosis**: 4th gen Ag/Ab combination test; confirmation HIV-1/2 antibody differentiation; viral load (HIV RNA); CD4 count; (2) **Baseline workup**: CBC, CMP, LFT, lipid panel, HbA1c, urinalysis, hepatitis A/B/C, syphilis, gonorrhea/chlamydia, TB (IGRA or PPD), pregnancy test, HLA-B*5701 if considering abacavir; (3) **ART recommended for all HIV+ regardless of CD4** (START trial 2015); (4) **First-line regimens (DHHS + IAS-USA)**: - **Integrase inhibitor (INSTI) based**: - Bictegravir/TAF/FTC (Biktarvy) — single pill, well-tolerated, no resistance to first-line; - Dolutegravir + (TAF/FTC or TDF/FTC) — Tivicay + Truvada/Descovy; - Dolutegravir + lamivudine (Dovato) — 2-drug regimen; (5) **Adherence + resistance testing baseline + on failure**: HIV-1 genotype baseline; (6) **Long-acting injectable**: cabotegravir + rilpivirine (Cabenuva) monthly or 2-monthly; (7) **PrEP for partners + at-risk**: TDF/FTC (Truvada), TAF/FTC (Descovy), cabotegravir LA (Apretude) — important prevention; (8) **Opportunistic infection prevention based on CD4**: PJP + Toxo prophylaxis (Bactrim) when CD4 < 200, MAC (azithromycin weekly) when CD4 < 50; (9) **Vaccinations**: hep A/B, flu, COVID, pneumo, Tdap, HPV, MMR + varicella if CD4 > 200 (live), shingles; (10) **Cancer screening**: anal Pap MSM, cervical women, hepatocellular if HBV/HCV; (11) **Mental health screening + support**: stigma, disclosure, partner notification; (12) **Multidisciplinary**: HIV specialist + primary care + pharmacy + mental health + social work + community

---

HIV: 4th gen diagnosis + viral load + CD4. ART for all. INSTI-based first-line (bictegravir, dolutegravir). 2-drug regimens. Long-acting injectables. PrEP. OI prophylaxis by CD4. Vaccinations. Multidisciplinary. Modern: chronic disease with normal life expectancy.', NULL,
  'easy', 'id', 'review',
  'pathology', 'clinical_decision', 'id', 'adult',
  'DHHS HIV Guidelines; IAS-USA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 35 ปี — HIV positive newly diagnosed — CD4 250 + viral load 80,000'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 25 ปี — easy bruising + heavy menstruation + family history bleeding — Coagulation workup: PT normal, aPTT prolonged, vWF antigen + activity reduced', '[{"label":"A","text":"Random"},{"label":"B","text":"Bleeding Disorders Pathology + Workup"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bleeding Disorders Pathology + Workup: (1) **Initial workup**: CBC + smear + PT + aPTT + fibrinogen + bleeding history (ISTH-BAT score); (2) **Pattern of bleeding**: mucocutaneous (vWD, platelet) vs deep soft tissue/joints (factor deficiency); (3) **Common bleeding disorders**: - **Von Willebrand Disease (vWD)**: most common inherited; autosomal dominant most; types 1 (partial deficiency), 2 (qualitative — subtypes 2A, 2B, 2M, 2N), 3 (severe absence); vWF antigen + activity (ristocetin cofactor) + factor VIII + multimer analysis; - **Hemophilia A** (factor VIII deficiency) + **B** (factor IX) — X-linked; deep tissue + joint bleeding; severity by factor level; - **Platelet disorders**: function (Glanzmann, Bernard-Soulier) or number (ITP, TTP, DIC); - **Acquired**: liver disease (multiple factors), warfarin/DOACs, vitamin K deficiency, DIC, ITP, vWD acquired (heart valves, hypothyroidism); (4) **vWD management**: - Desmopressin (DDAVP) for type 1 + some type 2; tachyphylaxis with repeated doses; - vWF concentrate or factor VIII/vWF combination products; - Antifibrinolytics (TXA) for mucosal bleeding + menorrhagia; - Hormonal therapy for menorrhagia; (5) **Hemophilia management**: factor concentrates (recombinant — preferred); emicizumab (FVIII mimetic — Hemlibra) for hemophilia A — revolutionary; gene therapy emerging; (6) **Specialized care center**: hemophilia treatment center improves outcomes; (7) **Multidisciplinary**: hematology + transfusion medicine + dental + obstetrics + orthopedics + genetic counseling + physical therapy

---

Bleeding disorders: vWD most common inherited; hemophilia A/B X-linked; platelet disorders; acquired. Workup: PT + aPTT + factor levels + specific tests. vWD: DDAVP, vWF concentrate, TXA. Hemophilia: factor concentrate, emicizumab revolutionary, gene therapy. Multidisciplinary specialized care.', NULL,
  'medium', 'hematology', 'review',
  'pathology', 'clinical_decision', 'hematology', 'adult',
  'NHF; WFH; ASH vWD', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 25 ปี — easy bruising + heavy menstruation + family history bleeding — Coagulation workup: PT normal, aPTT prolonged, vWF antigen + activity reduced'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยรับ blood transfusion + reaction: chills + fever + back pain + dark urine + hypotension + DIC features during transfusion', '[{"label":"A","text":"Continue transfusion"},{"label":"B","text":"Acute Hemolytic Transfusion Reaction (AHTR) — Anti-A/B IgM mediated severe"},{"label":"C","text":"Refuse"},{"label":"D","text":"Discharge"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Hemolytic Transfusion Reaction (AHTR) — Anti-A/B IgM mediated severe: (1) **STOP transfusion immediately** + maintain IV access; (2) **Send blood bag + tubing + samples** to blood bank for investigation: clerical check (ABO compatibility), repeat ABO + crossmatch on patient + bag, direct antiglobulin test (DAT), bilirubin, haptoglobin, LDH, urinalysis (hemoglobinuria), CBC, coagulation (DIC); (3) **Supportive treatment**: - IV fluids aggressive (maintain UO > 1 mL/kg/hr — prevent AKI from hemoglobinuria); - Vasopressors if hypotension; - Treat DIC (FFP, cryoprecipitate, platelets); - Furosemide for oliguria + volume overload; - Bicarbonate to alkalinize urine (hemoglobinuria); - Monitor renal function, electrolytes, coagulation; - Possibly hemodialysis if AKI severe; (4) **Differential transfusion reactions**: - **AHTR**: ABO incompatibility (often clerical error) — most serious; - **Delayed HTR**: extravascular hemolysis days later; - **Febrile non-hemolytic (FNHTR)**: cytokines; common, less serious; - **Allergic (urticaria)**: minor; antihistamine; - **Anaphylactic** (IgA deficiency with anti-IgA): severe — epinephrine; washed RBCs; - **TRALI (transfusion-related acute lung injury)**: ARDS-like, donor antibodies; - **TACO (transfusion-associated circulatory overload)**: volume overload; - **Septic**: bacterial contamination — antibiotics + supportive; (5) **Reporting + investigation**: transfusion service notification, FDA reporting if severe; (6) **Prevention**: positive patient identification, double-checking, transfusion-safe protocols, leukoreduction, irradiation for at-risk patients; (7) **Multidisciplinary**: transfusion medicine + pathology + intensivist + nephrology

---

Transfusion reactions: AHTR most serious (ABO incompatibility, often clerical error). Stop transfusion + investigation + supportive (fluids, vasopressor, DIC treatment, AKI prevention). Multiple reaction types — differential. Prevention: patient ID + safety protocols. Reporting + investigation. Multidisciplinary.', NULL,
  'medium', 'hematology', 'review',
  'pathology', 'clinical_decision', 'hematology', 'adult',
  'AABB Transfusion Reactions; FDA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยรับ blood transfusion + reaction: chills + fever + back pain + dark urine + hypotension + DIC features during transfusion'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี — chronic diarrhea + recent weight loss — duodenal biopsy: villous blunting + intraepithelial lymphocytes + crypt hyperplasia — celiac workup', '[{"label":"A","text":"Random"},{"label":"B","text":"Celiac Disease Pathology + Diagnosis"},{"label":"C","text":"Surgery"},{"label":"D","text":"Refuse"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Celiac Disease Pathology + Diagnosis: (1) **Histology**: Marsh classification - Marsh 0: normal; - 1: IELs > 25/100 enterocytes; - 2: + crypt hyperplasia; - 3a/b/c: villous atrophy (partial/subtotal/total); (2) **Diagnostic workup**: - **Serology**: TTG IgA (tissue transglutaminase) preferred — high sensitivity + specificity; total IgA (rule out IgA deficiency — common in celiac); DGP IgG (deamidated gliadin peptide) if IgA deficient; EMA (endomysial antibody) — confirmatory; - **Duodenal biopsy** ≥ 4 from descending duodenum + 2 from bulb during EGD — gold standard while on gluten-containing diet; - HLA-DQ2/DQ8 — negative virtually rules out (high negative predictive value); positive non-specific (40% population); (3) **Maintain gluten in diet during workup** (false negatives if gluten-free); (4) **Management**: lifelong gluten-free diet (GFD) — strict (cross-contamination matters); registered dietitian; (5) **Monitoring**: TTG normalization (6-12 mo on GFD), symptom resolution, repeat biopsy in some; bone density (osteoporosis common); micronutrients (iron, B12, folate, vitamin D); (6) **Complications + associated**: malabsorption + nutritional deficiencies, osteoporosis, infertility, dermatitis herpetiformis, neurological (ataxia, neuropathy), liver, refractory celiac (4-15%), enteropathy-associated T-cell lymphoma (EATL — small risk increase); (7) **Associated conditions**: T1DM, autoimmune thyroid, IgA deficiency, Down syndrome, Turner syndrome, Williams syndrome; (8) **Refractory celiac**: types I + II — corticosteroids, immunosuppressants; lymphoma surveillance; (9) **Family screening**: first-degree relatives — increased risk; (10) **Multidisciplinary**: GI + nutrition + endocrinology if associated

---

Celiac: serology (TTG IgA) + duodenal biopsy (Marsh) while on gluten. HLA helpful. Lifelong GFD. Complications + monitoring. Family screening. Refractory rare. Multidisciplinary care. Modern: precision + comprehensive.', NULL,
  'medium', 'gi', 'review',
  'pathology', 'clinical_decision', 'gi', 'adult',
  'ACG Celiac; ESPGHAN', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี — chronic diarrhea + recent weight loss — duodenal biopsy: villous blunting + intraepithelial lymphocytes + crypt hyperplasia — celiac workup'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง pathology techniques + IHC + molecular methods', '[{"label":"A","text":"Random"},{"label":"B","text":"Immunohistochemistry (IHC)"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"No techniques"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pathology Techniques: (1) **Histopathology**: H+E staining standard; special stains (PAS — glycogen + fungi; Gomori — fungi; AFB — mycobacteria; Congo red — amyloid; trichrome — collagen; iron — Perls; Alcian blue — mucin); fresh-frozen + permanent sections; (2) **Immunohistochemistry (IHC)**: antibody-based — specific antigen detection; markers (e.g., cytokeratin — epithelial, CD45 — lymphoid, S100 — melanocytic/neural, vimentin — mesenchymal, chromogranin/synaptophysin — neuroendocrine, TTF1 — lung adenocarcinoma + thyroid, GATA3 — breast + urothelial); (3) **Molecular pathology**: - **PCR + qPCR**: amplification; HIV viral load, BCR-ABL CML, fusion detection; - **FISH (fluorescence in situ hybridization)**: chromosomal + gene rearrangements, HER2 amplification; - **NGS (next-generation sequencing)**: targeted panels, whole exome, whole genome; tumor profiling; resistance testing; - **MSI/MMR**: PCR or IHC; - **Liquid biopsy / ctDNA**: circulating tumor DNA, MRD, treatment response; (4) **Flow cytometry**: hematologic malignancy diagnosis, immunophenotyping; (5) **Cytology**: FNA, Pap, body fluids — minimally invasive; (6) **Digital pathology + AI**: whole-slide imaging, AI assistance — emerging; reduces interobserver variability; (7) **Tumor banking + research**; (8) **Quality**: CLIA + CAP accreditation, proficiency testing, validation, controls; (9) **Multidisciplinary**: pathologist + clinician + IT + research; (10) **Modern**: integrated diagnostics + precision medicine + AI-augmented

---

Pathology techniques: H+E + special stains, IHC, molecular (PCR, FISH, NGS, MSI), flow, cytology, digital pathology + AI. Quality + validation. Modern: integrated diagnostics + precision + AI.', NULL,
  'medium', 'procedures', 'review',
  'pathology', 'basic_science', 'procedures', 'adult',
  'CAP; ASCP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Resident ถามเรื่อง pathology techniques + IHC + molecular methods'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง laboratory medicine + reference ranges + interpretation', '[{"label":"A","text":"Random"},{"label":"B","text":"Laboratory Medicine Principles"},{"label":"C","text":"Random"},{"label":"D","text":"Single test"},{"label":"E","text":"No interpretation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Laboratory Medicine Principles: (1) **Reference intervals**: 2.5-97.5% of healthy population; age, sex, ethnicity, time of day, posture, exercise affect; (2) **Sensitivity + specificity + PPV/NPV**: test characteristics + prevalence-dependent; (3) **Critical values + delta checks + autoverification**; (4) **Common tests + interpretation**: - **CBC + differential**: anemia (microcytic/normocytic/macrocytic), leukocytosis pattern (neutrophilia, lymphocytosis, eosinophilia), thrombocytopenia/cytosis; - **Chemistry**: electrolytes (Na, K, Cl, HCO3, Ca, Mg, phos), renal (BUN, Cr, eGFR), glucose, LFT (AST, ALT, ALP, GGT, bili, albumin, total protein); - **Cardiac**: troponin (high-sensitivity), BNP/NT-proBNP, CK-MB; - **Coagulation**: PT/INR, aPTT, fibrinogen, D-dimer; - **Endocrine**: TSH, free T4, cortisol, ACTH, calcium, PTH, vitamin D, HbA1c; - **Lipid panel**; - **Iron studies**: ferritin, iron, TIBC, transferrin saturation; - **Vitamin levels**: B12, folate, D; - **Inflammatory**: ESR, CRP, ferritin; (5) **Specific test selection by clinical question**: avoid shotgun testing; targeted; (6) **Pre-analytical errors**: collection, transport, storage, hemolysis, lipemia, jaundice; (7) **Point-of-care testing**: rapid bedside; (8) **Quality**: internal QC + external proficiency; (9) **Reflex testing**: e.g., positive HIV → confirmation; (10) **AI + decision support**: automated interpretation, alerts

---

Laboratory medicine: reference intervals + test characteristics + appropriate selection + interpretation + quality. Multiple disciplines tests. Pre-analytical errors. POC testing. Modern: targeted + reflex + AI-supported.', NULL,
  'easy', 'procedures', 'review',
  'pathology', 'basic_science', 'procedures', 'adult',
  'CAP; CLSI', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Resident ถามเรื่อง laboratory medicine + reference ranges + interpretation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง autopsy + forensic + post-mortem', '[{"label":"A","text":"Random"},{"label":"B","text":"Autopsy + Forensic Pathology"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"No examination"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Autopsy + Forensic Pathology: (1) **Autopsy types**: clinical/hospital (consent-based, quality + education), forensic/medical examiner (statutory — suspicious, sudden, accidental, violent, in-custody deaths); (2) **Hospital autopsy benefits**: education, quality improvement, family closure, public health; declining utilization concern; (3) **Forensic autopsy**: examines cause + manner of death (natural, accident, homicide, suicide, undetermined); chain of evidence; toxicology; trauma; (4) **External examination**: documentation, photographs, evidence collection (clothing, fingernails, bite marks, foreign bodies, GSR — gunshot residue, sexual assault kits); (5) **Internal examination**: comprehensive — head, neck, thorax, abdomen, pelvis; organ-by-organ; (6) **Toxicology**: blood, urine, vitreous, gastric, hair, drugs of abuse, alcohol, prescription, illicit; (7) **Histology**: microscopic — confirms gross findings, identifies pathology not visible grossly; (8) **Adjunct studies**: imaging (postmortem CT/MRI), genetics, microbiology, chemistry; (9) **Death certificate**: cause (immediate, intermediate, underlying) + manner; accuracy important for public health statistics; (10) **Multidisciplinary**: pathology + medical examiner + law enforcement + clinical + family; (11) **Specialized autopsies**: pediatric (SIDS workup), athletic + sudden cardiac death (cardiomyopathy, channelopathy genetics), occupational; (12) **Mass casualty + disaster**: forensic anthropology, dental, DNA identification; (13) **Modern**: minimally invasive autopsy (postmortem imaging + targeted biopsy), genetic post-mortem testing

---

Autopsy + forensic: clinical vs forensic. Determine cause + manner of death. External + internal + toxicology + histology + adjuncts. Death certificate accuracy. Multidisciplinary. Modern: minimally invasive + genetic + technology-assisted.', NULL,
  'easy', 'procedures', 'review',
  'pathology', 'basic_science', 'procedures', 'adult',
  'NAME; CAP Autopsy Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Resident ถามเรื่อง autopsy + forensic + post-mortem'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง biomarkers + companion diagnostics', '[{"label":"A","text":"Random"},{"label":"B","text":"Biomarkers + Companion Diagnostics"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"No use"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Biomarkers + Companion Diagnostics: (1) **Biomarker types**: diagnostic (HCG for pregnancy, hCG + AFP for germ cell), prognostic (stage, grade), predictive (HER2 for trastuzumab response), monitoring (PSA recurrence, CA 19-9 pancreatic Ca); (2) **Companion diagnostics**: FDA-approved tests required to identify patients who will benefit from specific therapies; (3) **Cancer biomarkers**: - **HER2** for trastuzumab in breast/gastric Ca; - **BRCA1/2** for PARP inhibitors (olaparib) — breast, ovarian, prostate, pancreatic; - **EGFR + ALK + ROS1** for lung cancer TKIs; - **BRAF V600E** for vemurafenib/dabrafenib in melanoma + NSCLC + thyroid; - **MSI-H/dMMR** for pembrolizumab + immunotherapy; - **PD-L1** for immunotherapy; - **PSMA** for radioligand therapy + PSMA PET; - **KRAS G12C** for sotorasib in NSCLC; (4) **Pharmacogenomics**: - HLA-B*5701 for abacavir hypersensitivity; - DPYD for fluoropyrimidine toxicity; - UGT1A1 for irinotecan; - CYP2D6 for codeine metabolism (slow + ultra-rapid); - CYP2C19 for clopidogrel; - TPMT for thiopurines; (5) **Cardiac markers**: troponin (high-sensitivity), BNP/NT-proBNP, ST2; (6) **Liquid biopsy + ctDNA**: minimal residual disease (MRD), early diagnosis, treatment response, recurrence; (7) **Quality + validation**: analytical + clinical performance; (8) **Multidisciplinary**: pathology + clinical + clinical lab + bioinformatics + IT

---

Biomarkers + companion diagnostics: precision medicine. Multiple cancer biomarkers driving treatment. Pharmacogenomics for safety + efficacy. Liquid biopsy + ctDNA. Modern: precision medicine increasingly biomarker-driven.', NULL,
  'medium', 'procedures', 'review',
  'pathology', 'basic_science', 'procedures', 'adult',
  'FDA Companion Diagnostics; CAP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Resident ถามเรื่อง biomarkers + companion diagnostics'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital implements digital pathology + AI + quality improvement in lab medicine', '[{"label":"A","text":"Traditional only"},{"label":"B","text":"Digital Pathology + AI Integration"},{"label":"C","text":"Random"},{"label":"D","text":"Avoid technology"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Digital Pathology + AI Integration: (1) **Whole-slide imaging (WSI)**: digitize entire glass slides; high resolution; remote viewing + sharing; teleconsultation; (2) **AI applications**: - Cancer detection (lung nodules, breast, prostate, melanoma, GI); - Grading + quantification (Gleason, Ki-67, Her2 IHC, tumor cellularity); - Biomarker prediction from H+E (e.g., MSI status from histology); - Workflow optimization + triage; - Quality control + double reading; (3) **FDA-approved AI in pathology growing** (Paige, PathAI, etc.); (4) **Benefits**: improved accuracy + consistency, productivity, remote work, education, research; (5) **Limitations + concerns**: validation, generalization across populations, bias, integration, regulatory, liability, training, ethics; (6) **Quality + safety improvements**: - Standardized reporting (synoptic reports); - Peer review + double reads for selected; - Critical results communication standards; - Diagnostic concordance audits; - Continuous education; (7) **Lab medicine quality**: CLIA + CAP accreditation, proficiency testing, internal QC, external QA; (8) **Patient safety**: specimen identification (positive ID), labeling, tracking; (9) **Equity**: ensure benefits across populations + reduce disparities; (10) **Multidisciplinary**: pathology + IT + administration + clinical + research; (11) **Modern**: digital + AI transforming pathology workflow + capabilities

---

Digital pathology + AI: whole-slide imaging + AI applications. FDA-approved tools growing. Quality + accuracy improvements. Limitations + ethics. CLIA + CAP quality. Multidisciplinary. Modern: digital + AI transforming pathology.', NULL,
  'easy', 'procedures', 'review',
  'pathology', 'ems_mgmt', 'procedures', 'adult',
  'CAP; ASCP Digital Pathology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Hospital implements digital pathology + AI + quality improvement in lab medicine'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital implements precision medicine program + tumor board + multidisciplinary integration', '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Precision Medicine Program"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Single specialty"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Precision Medicine Program: (1) **Molecular tumor board (MTB)**: multidisciplinary — pathology + medical oncology + surgical oncology + radiation + radiology + clinical genetics + bioinformatics + pharmacy + research; (2) **Workflow**: tissue procurement + adequate quality + comprehensive molecular profiling (NGS panel, IHC, FISH) → interpretation → treatment recommendation → clinical trial matching; (3) **Cancer Genomics**: actionable mutations identification, targeted therapy selection, clinical trial eligibility, off-label use, expanded access; (4) **Hereditary cancer genetics**: germline testing + counseling + family screening; (5) **Liquid biopsy**: minimal residual disease (MRD), monitoring, recurrence detection, resistance evolution; (6) **Pharmacogenomics**: medication selection + dosing + safety; (7) **Specialized pathology**: synoptic reports, molecular sign-out, MDT participation; (8) **Quality + standards**: CAP, ASCO, NCCN guidelines; (9) **Data sharing + registries**: cBioPortal, OncoKB, AACR Project GENIE; (10) **Patient + family education**: complex information, shared decision-making; (11) **Equity considerations**: ensure access + reduce disparities; (12) **Research integration**: clinical trials, translational; (13) **Multidisciplinary infrastructure**: regular meetings, EMR integration, decision support; (14) **Modern**: precision medicine standard in oncology + expanding to other specialties (cardiology, neurology, immunology)

---

Precision medicine: molecular tumor board + multidisciplinary. Comprehensive profiling + interpretation + treatment selection. Hereditary + liquid biopsy + pharmacogenomics. Equity + research integration. Modern: standard in oncology + expanding.', NULL,
  'medium', 'hemato_onco', 'review',
  'pathology', 'ems_mgmt', 'hemato_onco', 'adult',
  'ASCO; NCCN; CAP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Hospital implements precision medicine program + tumor board + multidisciplinary integration'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital implements pathology workforce + telepathology + global pathology', '[{"label":"A","text":"Random"},{"label":"B","text":"Pathology Workforce + Telepathology"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Avoid"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pathology Workforce + Telepathology: (1) **Workforce shortage**: pathology + lab medicine global shortage; rural + developing country access challenges; aging workforce; (2) **Telepathology**: remote consultation, primary diagnosis (with validation), subspecialty consultation, education; reduces geographic disparity; (3) **Telepathology modes**: dynamic (real-time microscope), static (selected images), whole-slide image-based (most comprehensive); (4) **Subspecialty consultation**: rare or difficult cases referred to specialists globally; (5) **Global pathology**: capacity building in LMICs (low- middle-income countries); WHO + ASCP, etc.; (6) **Workforce expansion**: - More residency training positions; - Subspecialty fellowships; - Pathologist assistant + lab technologist; - Cytotechnologists + histotechnologists; (7) **Education + training**: simulation, online learning, webinars, virtual microscopy; (8) **Quality assurance** for telepathology: validation, consistency, lighting + color, network latency, security; (9) **Regulatory + licensing**: cross-state + cross-country; HIPAA + GDPR + local regulations; (10) **Equity + access**: ensure benefits reach underserved + LMIC; affordability; (11) **Multidisciplinary**: pathology + IT + administration + clinical + global health; (12) **Modern**: telepathology + global collaboration + AI + digital transformation expanding access

---

Pathology workforce + telepathology: shortage + access challenges. Telepathology expands access + subspecialty consultation. Global pathology capacity building. Workforce expansion + education. Quality + regulation. Equity. Modern: digital + collaboration transforming.', NULL,
  'easy', 'procedures', 'review',
  'pathology', 'ems_mgmt', 'procedures', 'adult',
  'ASCP; CAP; WHO', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Hospital implements pathology workforce + telepathology + global pathology'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Patient with breast cancer — pathology + multidisciplinary + survivorship integrative care', '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Breast Cancer Pathology Integrative Care"},{"label":"C","text":"Random"},{"label":"D","text":"Single specialty"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Breast Cancer Pathology Integrative Care: (1) **Initial pathology**: core biopsy diagnosis + biomarkers (ER/PR/HER2/Ki-67) → molecular subtype + risk stratification; (2) **Multidisciplinary tumor board**: pathology + breast surgery + medical oncology + radiation oncology + radiology + plastic surgery + genetics + nurse navigator; (3) **Treatment planning**: neoadjuvant vs adjuvant; surgery (BCS vs mastectomy); axillary management; radiation; systemic therapy (chemo + targeted + endocrine); (4) **Post-treatment monitoring + surveillance**: annual mammography, clinical exam, symptoms, biomarkers (selected); (5) **Late effects + survivorship**: - Cardiotoxicity (trastuzumab, anthracycline) — cardio-oncology; - Lymphedema management; - Sexual + reproductive health; - Bone health (aromatase inhibitor — DEXA, bisphosphonate); - Cognitive (chemo brain); - Mental health + body image; - Fatigue + nutrition + exercise; (6) **Genetic counseling**: BRCA + others — family implications + risk-reducing strategies; (7) **Recurrence/metastatic disease**: re-biopsy when accessible — biomarker changes (ER/PR/HER2 conversion), new actionable mutations; (8) **New agents revolutionizing**: CDK4/6 inhibitors (palbociclib, ribociclib, abemaciclib) + endocrine; PARP inhibitors (BRCA); antibody-drug conjugates (T-DXd — HER2 + HER2-low); sacituzumab govitecan (TNBC); immunotherapy (TNBC + PD-L1+); (9) **Patient + family support**: education, peer support, financial counseling, integrative therapies; (10) **Equity considerations** + access

---

Breast cancer integrative pathology + care: multidisciplinary + comprehensive + long-term. Treatment phase + monitoring + survivorship + late effects + genetic counseling + recurrence management. Modern: revolutionary new agents + precision. Patient-centered.', NULL,
  'hard', 'hemato_onco', 'review',
  'pathology', 'integrative', 'hemato_onco', 'adult',
  'NCCN Breast Cancer; ASCO Survivorship', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Patient with breast cancer — pathology + multidisciplinary + survivorship integrative care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Patient with chronic kidney disease — pathology + multidisciplinary integrative care', '[{"label":"A","text":"Single specialty"},{"label":"B","text":"CKD Integrative Multidisciplinary Care"},{"label":"C","text":"Random"},{"label":"D","text":"Single specialty"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** CKD Integrative Multidisciplinary Care: (1) **Pathology role**: kidney biopsy for diagnosis of underlying disease (IgA, lupus nephritis, membranous, FSGS, diabetic nephropathy, etc.) → guides treatment; (2) **CKD staging**: by GFR + albuminuria (KDIGO); (3) **Treatment based on cause + stage**: - Diabetic nephropathy: SGLT2 + RAS blockade + finerenone + glycemic + BP control; - Immune-mediated: immunosuppression + KDIGO 2021; - Inherited (polycystic): tolvaptan for ADPKD; - Other secondary: treat underlying; (4) **Slowing progression** (universal): BP control + RAS blockade + glycemic + SGLT2 + finerenone + lipid + diet + smoking cessation; (5) **Comorbidity management**: CVD (greatest cause of death in CKD), bone-mineral disease (Ca, phos, PTH, vit D), anemia (EPO, iron, oral HIF-PHI roxadustat in some regions), acidosis (bicarbonate), uremia symptoms; (6) **Dialysis planning + transplant evaluation early** (Stage 4 → access, evaluation); (7) **Education + patient empowerment**: nutrition (K, phos, Na, protein, fluid), medication adherence, lifestyle, symptom recognition; (8) **Pharmacy review**: dose adjustment, nephrotoxin avoidance; (9) **Vaccinations**: special considerations (HBV — high doses, pre-dialysis); (10) **Mental health**: depression high in CKD; (11) **Palliative + advance care planning** for advanced; (12) **Multidisciplinary**: nephrology + pathology + primary care + dietitian + pharmacy + social work + transplant + dialysis + mental health; (13) **Modern**: novel agents (SGLT2, finerenone, HIF-PHI) + integrated chronic care

---

CKD integrative care: pathology diagnostic + comprehensive multidisciplinary management. Slowing progression + comorbidity + dialysis/transplant planning + education + palliative for advanced. Modern: SGLT2 + finerenone + HIF-PHI revolutionizing care.', NULL,
  'hard', 'renal_gu', 'review',
  'pathology', 'integrative', 'renal_gu', 'adult',
  'KDIGO CKD; ADA + ACC', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Patient with chronic kidney disease — pathology + multidisciplinary integrative care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Patient with hereditary cancer syndrome (Lynch) + multidisciplinary genetics integrative care', '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Hereditary Cancer Syndrome Integrative Care (Lynch Syndrome example)"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Single specialty"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hereditary Cancer Syndrome Integrative Care (Lynch Syndrome example): (1) **Diagnostic confirmation**: germline MMR gene mutation (MLH1, MSH2, MSH6, PMS2, EPCAM); tumor testing (MSI, IHC for MMR) + Amsterdam/Bethesda criteria + family history; (2) **Surveillance + risk reduction**: - Colon: colonoscopy q1-2 yr starting age 20-25 (or 2-5 yr before youngest relative); - Endometrial + ovarian (women): annual TVS + endometrial sampling 30-35; risk-reducing hysterectomy + BSO 40-45; - Gastric/duodenal: EGD q3-5 yr from age 30-35 (especially Asian + family history); - Urothelial: annual urinalysis from 30-35; - Skin: annual skin exam; - Pancreatic: EUS/MRI in selected; (3) **Family screening**: cascade testing of first-degree relatives at appropriate age; counseling; (4) **Treatment of cancers**: standard but consider immunotherapy (pembrolizumab — MSI-H benefit); chemoprevention (aspirin — CAPP2 trial — reduces CRC + endometrial in Lynch); (5) **Genetic counseling**: complex testing + interpretation + family implications + psychosocial impact; (6) **Reproductive**: preimplantation genetic testing (PGT) consideration; (7) **Multidisciplinary**: medical genetics + GI + GYN + medical oncology + surgical oncology + pathology + primary care + psychology; (8) **Registry + research**: data + future understanding; (9) **Equity considerations**: testing access + cost + underrepresented populations; (10) **Patient + family education + advocacy**; (11) **Modern**: precision + family-centered + comprehensive lifelong care

---

Hereditary cancer syndrome integrative care: diagnosis + surveillance + risk reduction + family screening + treatment + counseling. Multidisciplinary genetics. Chemoprevention (aspirin Lynch). Modern: precision family-centered comprehensive lifelong care.', NULL,
  'hard', 'hemato_onco', 'review',
  'pathology', 'integrative', 'hemato_onco', 'adult',
  'NCCN Genetic/Familial High-Risk Assessment', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Patient with hereditary cancer syndrome (Lynch) + multidisciplinary genetics integrative care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิงอายุ 48 ปี — screening mammogram พบ microcalcifications → stereotactic core biopsy; histology: cribriform + comedo pattern + central necrosis + atypical cells confined to ductal lumens, ไม่ทะลุ basement membrane; IHC: ER+ PR+ HER2 1+, p63 + myoepithelium intact; การวินิจฉัยและการจัดการที่เหมาะสม', '[{"label":"A","text":"Invasive ductal carcinoma"},{"label":"B","text":"Ductal Carcinoma In Situ (DCIS)"},{"label":"C","text":"Atypical ductal hyperplasia"},{"label":"D","text":"Lobular carcinoma in situ"},{"label":"E","text":"Phyllodes tumor"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Ductal Carcinoma In Situ (DCIS): (1) **Definition**: malignant epithelial proliferation confined ใน ductal-lobular system โดย basement membrane intact; pre-invasive lesion; (2) **Histology**: solid, cribriform, papillary, micropapillary, comedo patterns; central necrosis + calcifications บ่อยใน high-grade comedo type; (3) **Grade (nuclear)**: low (1) — mild atypia + uniform; intermediate (2); high (3) — marked pleomorphism + comedonecrosis; (4) **IHC**: myoepithelial layer สำคัญที่สุด — p63, calponin, SMM-HC, CK5/6 intact = DCIS (vs invasive ที่ myoepithelium หายไป); ER/PR/HER2 routinely tested เพื่อ guide therapy + risk; (5) **Risk progression to invasive cancer**: untreated ~ 30-50% over 10 ปี; high grade + comedo + large size = higher risk; (6) **Treatment**: BCS + RT หรือ mastectomy; SLN biopsy ไม่จำเป็น routine (พิจารณาใน mastectomy หรือ large/high grade ที่อาจมี invasion occult); endocrine therapy (tamoxifen หรือ AI) สำหรับ ER+ DCIS หลัง BCS — reduces ipsilateral + contralateral risk; (7) **Margin**: ≥ 2 mm preferred per SSO/ASTRO/ASCO consensus; (8) **Surveillance**: annual mammogram + clinical exam; (9) **Multidisciplinary**: breast surgery + radiation + medical onc + pathology

---

DCIS — pre-invasive ductal neoplasia, myoepithelium intact (p63+/calponin+). BCS+RT or mastectomy; SLN เฉพาะ selected. Endocrine therapy ลด recurrence ใน ER+. Margin ≥ 2 mm.', NULL,
  'medium', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'WHO Breast Tumors 5th ed; SSO/ASTRO/ASCO Margin Consensus; NCCN Breast', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยหญิงอายุ 48 ปี — screening mammogram พบ microcalcifications → stereotactic core biopsy; histology: cribriform + comedo pattern + central necrosis + atypical cells confined to ductal lumens, ไม่ทะลุ basement membrane; IHC: ER+ PR+ HER2 1+, p63 + myoepithelium intact; การวินิจฉัยและการจัดการที่เหมาะสม'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิงอายุ 62 ปี — palpable mass at breast → core biopsy: cells in single-file (Indian file) pattern infiltrating stroma + signet ring cells + lack of cohesion; IHC: ER+ PR+ HER2 0, **E-cadherin negative**, p120 cytoplasmic relocation; การวินิจฉัย', '[{"label":"A","text":"Ductal carcinoma"},{"label":"B","text":"Invasive Lobular Carcinoma (ILC)"},{"label":"C","text":"DCIS"},{"label":"D","text":"Inflammatory carcinoma"},{"label":"E","text":"Metaplastic carcinoma"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Invasive Lobular Carcinoma (ILC): (1) **Distinctive histology**: discohesive cells, single-file (Indian file) pattern, targetoid arrangement around ducts, signet ring cells, low-grade nuclei most cases; (2) **Hallmark molecular**: **loss of E-cadherin** (CDH1 gene mutation/deletion) → discohesive growth; p120 relocates จาก membrane → cytoplasm (E-cadherin loss); (3) **IHC pattern**: E-cadherin negative or fragmented + p120 cytoplasmic = lobular; vs ductal ที่ E-cadherin membrane+; (4) **Biology**: almost all ER+/PR+ HER2-; lower grade typically; (5) **Imaging**: often occult on mammography (no mass effect, no calcifications) → MRI สำคัญ in suspected ILC; (6) **Patterns of spread**: GI tract, ovary, peritoneum, leptomeninges (unique vs ductal); bone bilateral; (7) **Treatment** considerations: BCS challenging due to multifocality + extent; mastectomy more common; endocrine therapy mainstay (ER+); chemo less benefit historically; CDK4/6 + endocrine in advanced; (8) **Lobular Carcinoma In Situ (LCIS)**: marker of bilateral risk, not direct precursor; pleomorphic LCIS more aggressive; (9) **CDH1 germline**: hereditary diffuse gastric cancer syndrome — increased risk of ILC + diffuse gastric ca → consider genetic counseling

---

ILC: discohesive single-file, E-cadherin loss (CDH1), p120 cytoplasmic. Almost always ER+/HER2-. Imaging occult; MRI helpful. Unique metastasis pattern (GI, ovary, LM). Endocrine mainstay. CDH1 germline → HDGC syndrome.', NULL,
  'medium', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'WHO Breast Tumors 5th ed; CAP Breast Cancer Protocol', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยหญิงอายุ 62 ปี — palpable mass at breast → core biopsy: cells in single-file (Indian file) pattern infiltrating stroma + signet ring cells + lack of cohesion; IHC: ER+ PR+ HER2 0, **E-cadherin negative**, p120 cytoplasmic relocation; การวินิจฉัย'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชายอายุ 65 ปี — endoscopic biopsy of gastric ulcer: glands with intestinal differentiation + goblet cells + cohesive nests, vs another patient with poorly cohesive cells + signet ring + diffuse infiltration; การจำแนกตาม Lauren classification และ implications', '[{"label":"A","text":"Same prognosis"},{"label":"B","text":"Gastric Adenocarcinoma — Lauren Classification"},{"label":"C","text":"Skip biopsy"},{"label":"D","text":"Refuse"},{"label":"E","text":"Hospice immediately"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Gastric Adenocarcinoma — Lauren Classification: (1) **Intestinal type**: cohesive glands, intestinal metaplasia background, expansive growth, distal stomach, older men, environmental + H. pylori driven, stepwise progression (chronic gastritis → atrophy → intestinal metaplasia → dysplasia → carcinoma — Correa cascade); (2) **Diffuse type**: discohesive cells, signet ring, linitis plastica, younger, equal sex, **CDH1 (E-cadherin) loss** (sporadic + hereditary — HDGC); worse prognosis; (3) **WHO classification**: tubular, papillary, mucinous, poorly cohesive (incl signet ring), mixed, undifferentiated; (4) **Molecular subtypes (TCGA)**: EBV+ (PIK3CA, PD-L1, CIMP), MSI-high (hypermutated, MMR loss), genomically stable (CDH1, RHOA — diffuse type), chromosomal instability (TP53, intestinal type); (5) **Biomarker testing (essential for advanced)**: **HER2** (IHC + ISH per ToGA criteria — apical/lateral staining acceptable, ≥ 10% threshold) → trastuzumab; **PD-L1 CPS** → immunotherapy (nivolumab + chemo, pembrolizumab); **MSI/MMR** → immunotherapy + Lynch screen; **EBV** ISH → immunotherapy responsive; **Claudin 18.2** IHC → zolbetuximab (new); **FGFR2b**, **NTRK** in select; (6) **Staging**: TNM (AJCC 8th); EUS + CT/PET; staging laparoscopy + peritoneal cytology for advanced; (7) **Treatment**: perioperative chemo (FLOT) + D2 gastrectomy resectable; palliative chemo + targeted/IO for advanced; (8) **Multidisciplinary**

---

Gastric ca Lauren: intestinal (cohesive, H. pylori-driven, Correa cascade) vs diffuse (signet ring, CDH1 loss, worse). TCGA: EBV+/MSI/GS/CIN. Biomarkers: HER2, PD-L1 CPS, MSI, EBV, claudin 18.2. FLOT + D2 resectable.', NULL,
  'hard', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'WHO Digestive System Tumors 5th ed; NCCN Gastric Cancer; ToGA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยชายอายุ 65 ปี — endoscopic biopsy of gastric ulcer: glands with intestinal differentiation + goblet cells + cohesive nests, vs another patient with poorly cohesive cells + signet ring + diffuse infiltration; การจำแนกตาม Lauren classification และ implications'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี — chronic dyspepsia + EGD biopsy from antrum: chronic active inflammation + lymphoid aggregates + curved gram-negative rods at mucus layer; rapid urease test positive', '[{"label":"A","text":"No treatment needed"},{"label":"B","text":"H. pylori Gastritis Pathology + Management"},{"label":"C","text":"Surgery first"},{"label":"D","text":"Steroids"},{"label":"E","text":"Antifungal"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** H. pylori Gastritis Pathology + Management: (1) **Organism**: Helicobacter pylori — gram-negative curved/spiral rod, urease-producing (hydrolyzes urea → ammonia → neutralizes acid); (2) **Diagnostic methods**: histology (Giemsa, Warthin-Starry, IHC) — sensitive; rapid urease test (CLO) on biopsy; urea breath test (non-invasive); stool antigen; serology (cannot distinguish active vs past); culture (special media); (3) **Histology**: chronic active gastritis — lymphoplasmacytic + neutrophils + lymphoid aggregates; bacteria in mucus over surface epithelium; (4) **Associated conditions**: chronic gastritis → atrophic gastritis → intestinal metaplasia → dysplasia → gastric adenocarcinoma (Correa cascade); MALT lymphoma; peptic ulcer disease; iron deficiency; ITP; (5) **WHO Class 1 carcinogen** for gastric cancer + MALT lymphoma; (6) **Treatment**: eradication regimens (resistance-guided): - **Bismuth quadruple** (PPI + bismuth + tetracycline + metronidazole) 10-14 d — increasingly first-line due to clarithromycin resistance; - **Concomitant** (PPI + amox + clarithro + metro) where resistance < 15%; - **Triple** PPI + clarithro + amox phasing out in high-resistance areas; - **Vonoprazan-based** (potassium-competitive acid blocker) newer regimens — vonoprazan + amox dual + clarithro; (7) **Confirm eradication** ≥ 4 wk after Tx: urea breath test or stool antigen (off PPI 2 wk); (8) **MALT lymphoma**: eradication can induce regression of low-grade gastric MALT (depends on t(11;18))

---

H. pylori: gram-neg curved urease+ rod; histology + urease + UBT + stool Ag. Causes gastritis → cancer cascade + MALT. Eradication: bismuth quadruple or vonoprazan-based; confirm cure with UBT/stool Ag.', NULL,
  'easy', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'ACG H. pylori 2024; Maastricht VI', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี — chronic dyspepsia + EGD biopsy from antrum: chronic active inflammation + lymphoid aggregates + curved gram-negative rods at mucus layer; rapid urease test positive'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 58 ปี — right colon adenocarcinoma resection — IHC: **MLH1 loss + PMS2 loss**, MSH2/MSH6 intact; molecular: BRAF V600E mutation present, MLH1 promoter hypermethylation positive; การ interpret และ implications', '[{"label":"A","text":"Lynch syndrome confirmed"},{"label":"B","text":"Colorectal MSI/MMR Interpretation"},{"label":"C","text":"Ignore the IHC"},{"label":"D","text":"Repeat biopsy"},{"label":"E","text":"Refuse treatment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Colorectal MSI/MMR Interpretation: (1) **MMR IHC pattern**: paired loss MLH1+PMS2 OR MSH2+MSH6 (heterodimer partners); isolated PMS2 loss = MLH1 hypomorph or PMS2 mutation; isolated MSH6 loss = MSH6 mutation; (2) **MLH1 loss with BRAF V600E + MLH1 hypermethylation** = sporadic, NOT Lynch — methylation silences MLH1, BRAF mutation associated with serrated pathway; (3) **MLH1 loss WITHOUT BRAF mutation/MLH1 methylation** → germline testing (Lynch); (4) **MSH2, MSH6, PMS2 loss** → germline testing directly (Lynch — BRAF/methylation reflex applies only to MLH1); (5) **MSI testing**: PCR-based (Bethesda panel, pentaplex BAT-25, BAT-26, NR-21, NR-24, MONO-27) — concordant with IHC; NGS-based MSI increasingly used; (6) **Clinical implications**: - **Prognosis**: stage II MSI-H better prognosis, may not benefit from adjuvant 5-FU monotherapy; - **Immunotherapy**: MSI-H/dMMR predicts response to checkpoint inhibitors (pembrolizumab, nivolumab/ipi) — frontline metastatic + neoadjuvant rectal (NICHE, PD-1 alone can yield clinical CR avoiding surgery); - **Lynch syndrome screen**: per universal CRC testing recommendations; (7) **WHO + CAP + NCCN**: universal MMR/MSI testing on all CRC + endometrial cancers; (8) **Multidisciplinary**: pathology + genetic counseling + oncology

---

MLH1 loss + BRAF V600E + MLH1 methylation = sporadic MSI-H, NOT Lynch. MSH2/MSH6/PMS2 loss → germline directly. MSI-H predicts IO response (frontline metastatic, neoadjuvant rectal). Universal CRC + EC testing.', NULL,
  'hard', 'molecular_pathology', 'review',
  'pathology', 'clinical_decision', 'molecular_pathology', 'adult',
  'NCCN CRC; CAP MMR/MSI; WHO Digestive Tumors 5th ed', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 58 ปี — right colon adenocarcinoma resection — IHC: **MLH1 loss + PMS2 loss**, MSH2/MSH6 intact; molecular: BRAF V600E mutation present, MLH1 promoter hypermethylation positive; การ interpret และ implications'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชายอายุ 60 ปี cirrhosis from HBV → liver mass biopsy: trabecular pattern of polygonal cells with eosinophilic cytoplasm, bile production within tumor; IHC: HepPar-1+, arginase-1+, glypican-3+, AFP+; การวินิจฉัย', '[{"label":"A","text":"Cholangiocarcinoma"},{"label":"B","text":"Hepatocellular Carcinoma (HCC)"},{"label":"C","text":"Hemangioma"},{"label":"D","text":"FNH"},{"label":"E","text":"Metastasis"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hepatocellular Carcinoma (HCC): (1) **Histology**: trabecular > 3 cells thick, pseudoglandular, solid, scirrhous patterns; polygonal cells with eosinophilic granular cytoplasm; bile production pathognomonic; sinusoidal capillarization (CD34 +); (2) **IHC panel**: HepPar-1 (hepatocyte specific Ag), arginase-1 (most sensitive + specific), glypican-3 (positive in HCC, negative in benign), AFP (variable); CD34 sinusoidal capillarization; reticulin loss; (3) **Differential**: hepatocellular adenoma (no atypia, reticulin retained, no glypican-3), focal nodular hyperplasia (central scar, map-like GS), cholangiocarcinoma (CK7/19+, mucin+), metastatic adenocarcinoma; (4) **Subtypes**: classic, fibrolamellar (young, no cirrhosis, DNAJB1-PRKACA fusion, lamellar fibrous bands), steatohepatitic, scirrhous, clear cell; (5) **Grading**: WHO/Edmondson-Steiner I-IV; (6) **Risk factors**: HBV, HCV, alcohol, NASH/MASLD increasingly important, aflatoxin, hemochromatosis, alpha-1 antitrypsin; (7) **Surveillance** in cirrhosis: US ± AFP q6 mo; LI-RADS for imaging interpretation; (8) **Treatment (BCLC)**: - 0/A: resection, transplant (Milan), ablation; - B: TACE; - C: systemic — atezolizumab + bevacizumab (IMbrave150) frontline; tremelimumab + durvalumab (HIMALAYA); lenvatinib, sorafenib; later lines regorafenib, cabozantinib, ramucirumab (AFP > 400), nivolumab + ipi; - D: BSC; (9) **Prevention**: HBV vaccination + treatment; HCV cure with DAAs

---

HCC: trabecular + bile production, IHC HepPar-1/arginase-1/GPC3/AFP. Subtypes (fibrolamellar DNAJB1-PRKACA). BCLC-based treatment; atezo-bev frontline systemic. HBV/HCV/MASLD risk; surveillance with US±AFP q6mo + LI-RADS.', NULL,
  'medium', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'WHO Digestive Tumors 5th ed; AASLD HCC; BCLC 2022', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยชายอายุ 60 ปี cirrhosis from HBV → liver mass biopsy: trabecular pattern of polygonal cells with eosinophilic cytoplasm, bile production within tumor; IHC: HepPar-1+, arginase-1+, glypican-3+, AFP+; การวินิจฉัย'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี — pancreatic head mass + obstructive jaundice → EUS-FNA biopsy: malignant glands with mucin in desmoplastic stroma; IHC: CK7+ CK19+ CK20- CDX2-; molecular: KRAS mutation, TP53, CDKN2A, SMAD4 loss; การวินิจฉัย และ implications', '[{"label":"A","text":"Acinar cell carcinoma"},{"label":"B","text":"Pancreatic Ductal Adenocarcinoma (PDAC)"},{"label":"C","text":"Neuroendocrine tumor"},{"label":"D","text":"Solid pseudopapillary"},{"label":"E","text":"Chronic pancreatitis"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pancreatic Ductal Adenocarcinoma (PDAC): (1) **Histology**: malignant glandular structures, mucin production, desmoplastic stroma (fibrous reaction prominent), perineural + lymphovascular invasion common, infiltrative pattern; (2) **IHC**: CK7+, CK19+, CA19-9, MUC1, MUC5AC; loss of SMAD4 (DPC4) in ~ 55% (genomic deletion 18q21); CK20/CDX2 negative (helps distinguish from intestinal mets); (3) **Molecular landscape (TCGA)**: KRAS mutation > 90% (mainly G12D, G12V, G12R), TP53 ~ 70%, CDKN2A ~ 50%, SMAD4 ~ 55%; KRAS G12C minority but actionable (sotorasib, adagrasib); (4) **Actionable alterations (4-15%)**: BRCA1/2, PALB2 (HRD → platinum + PARP — olaparib maintenance POLO trial); MSI-H rare ~ 1% (immunotherapy); NTRK, NRG1 fusions; BRAF; HER2 amplification; (5) **Subtypes (molecular)**: classical, basal-like (squamous) — basal-like worse prognosis; (6) **Precursors**: PanIN, IPMN (intraductal papillary mucinous neoplasm), MCN (mucinous cystic); (7) **Staging + treatment**: resectable < 20% — Whipple/distal panc + adjuvant mFOLFIRINOX (preferred) or gem-cape; borderline/locally advanced — neoadjuvant FOLFIRINOX/gem-NabP; metastatic — FOLFIRINOX (NAPOLI-3 with NALIRIFOX now alternative), gem-NabP; second line nano-liposomal irinotecan + 5-FU; (8) **Germline testing recommended** all patients; (9) **Multidisciplinary** + palliative early + biliary stenting + nutrition

---

PDAC: glands + desmoplasia + perineural; CK7+/CK19+, SMAD4 loss ~55%. KRAS > 90% + TP53/CDKN2A/SMAD4. Actionable: BRCA/PALB2 (PARP), MSI rare, KRAS G12C. NALIRIFOX + FOLFIRINOX. Germline all patients.', NULL,
  'hard', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'WHO Digestive Tumors 5th ed; NCCN Pancreatic; NAPOLI-3', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี — pancreatic head mass + obstructive jaundice → EUS-FNA biopsy: malignant glands with mucin in desmoplastic stroma; IHC: CK7+ CK19+ CK20- CDX2-; molecular: KRAS mutation, TP53, CDKN2A, SMAD4 loss; การวินิจฉัย และ implications'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิงอายุ 42 ปี — abnormal cervical screening → colposcopy + biopsy: full-thickness atypia + koilocytes + mitotic figures throughout epithelium; p16 strong + diffuse block-positive, Ki-67 elevated full thickness; HPV testing: HPV-16 positive', '[{"label":"A","text":"Reactive change"},{"label":"B","text":"Cervical HSIL/CIN3 — Pathology + Management"},{"label":"C","text":"Cervicitis"},{"label":"D","text":"Hysterectomy first"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cervical HSIL/CIN3 — Pathology + Management: (1) **LAST terminology (2012, revised)**: LSIL (low-grade squamous intraepithelial lesion = CIN1, HPV cytopathic effect); HSIL (high-grade = CIN2-3); SCC; AIS (adenocarcinoma in situ); (2) **Histology HSIL**: atypia ≥ 2/3 epithelial thickness; mitoses upper layers; loss of maturation; (3) **IHC**: **p16 block-positive** (strong continuous nuclear + cytoplasmic ≥ 1/3 thickness) = high-risk HPV transcriptionally active → upgrade equivocal lesions; Ki-67 elevated upper levels; (4) **HPV**: high-risk types 16, 18 most common; 31, 33, 45, 52, 58 also; (5) **Screening (USPSTF/ASCCP 2019, updated)**: HPV primary 25-65 q5y preferred; co-testing q5y; cytology alone q3y 21-29; (6) **Risk-based management (ASCCP 2019)**: based on current + past results → estimate CIN3+ risk → treat, colpo, or surveillance; HSIL/CIN3 → excisional treatment (LEEP, cold knife cone) typically; (7) **AIS**: cold knife conization (LEEP can fragment), negative margins essential; hysterectomy after childbearing; (8) **Prevention**: HPV vaccination 9-valent recommended 9-26 (catch-up to 45 shared decision); (9) **Special**: pregnancy, immunocompromised (HIV), adolescents = different algorithms; (10) **Post-treatment surveillance**: HPV testing 6 mo, then per risk

---

HSIL (CIN2-3): full-thickness atypia + p16 block+ + HPV-HR. ASCCP 2019 risk-based mgmt; LEEP/cone treatment. AIS → CKC. HPV vaccine prevention. LAST terminology + p16 IHC standard.', NULL,
  'medium', 'cytopathology', 'review',
  'pathology', 'clinical_decision', 'cytopathology', 'adult',
  'ASCCP 2019 Risk-Based Guidelines; LAST Project; WHO Female Genital Tumors 5th ed', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยหญิงอายุ 42 ปี — abnormal cervical screening → colposcopy + biopsy: full-thickness atypia + koilocytes + mitotic figures throughout epithelium; p16 strong + diffuse block-positive, Ki-67 elevated full thickness; HPV testing: HPV-16 positive'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิงอายุ 67 ปี — postmenopausal bleeding + endometrial biopsy: confluent glands + cribriform + nuclear atypia + squamous differentiation; IHC: ER+ PR+ PTEN loss; MMR IHC retained; การจำแนกและการรักษา', '[{"label":"A","text":"Benign hyperplasia"},{"label":"B","text":"Endometrial Carcinoma Pathology + Molecular Classification"},{"label":"C","text":"Polyp"},{"label":"D","text":"Refuse"},{"label":"E","text":"Cervicitis"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Endometrial Carcinoma Pathology + Molecular Classification: (1) **Histology**: endometrioid adenocarcinoma — confluent glands, cribriform, squamous differentiation common, low-grade nuclei (FIGO 1-2) vs serous + clear cell + carcinosarcoma (high grade); (2) **FIGO grade (endometrioid)**: based on architectural pattern + nuclear atypia; G1 ≤ 5% solid, G2 6-50%, G3 > 50% solid; nuclear atypia upgrades by 1; (3) **TCGA/ProMisE molecular classification (essential, integrated into FIGO 2023 staging)**: - **POLE ultramutated**: best prognosis, may de-escalate; - **MMR-deficient (MSI-H)** ~ 30%: intermediate, immunotherapy candidate, screen for Lynch; - **p53 abnormal (copy number high, serous-like)**: worst prognosis, often serous/G3 endometrioid, HER2 testing (trastuzumab benefit); - **NSMP (no specific molecular profile)**: variable; (4) **Endometrial hyperplasia/EIN** terminology: WHO — hyperplasia without atypia (benign) vs atypical hyperplasia/EIN (precursor) → high progression risk → hysterectomy or progestin; (5) **PTEN loss** common early in endometrioid; (6) **Workup**: TVS, EMB, hysteroscopy; staging surgical (TAH-BSO + LN/SLN); (7) **Treatment**: - Stage I low-risk: surgery alone; - Higher risk: ± adjuvant chemo/RT; - Advanced/metastatic: chemo (carbo-paclitaxel) + pembrolizumab + lenvatinib OR pembro alone if dMMR (KEYNOTE-868, RUBY); - Recurrent: same combos; HER2+ serous → trastuzumab/T-DXd; (8) **Lynch screen** universal

---

Endometrial endometrioid ca: confluent glands + atypia. FIGO 2023 integrates TCGA molecular (POLE/MMRd/p53abn/NSMP) → prognosis + Tx. Pembro + lenvatinib advanced; pembro alone dMMR. Universal Lynch screen; HER2 in serous.', NULL,
  'hard', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'WHO Female Genital Tumors 5th ed; FIGO 2023 EC staging; NCCN; KEYNOTE-868; RUBY', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยหญิงอายุ 67 ปี — postmenopausal bleeding + endometrial biopsy: confluent glands + cribriform + nuclear atypia + squamous differentiation; IHC: ER+ PR+ PTEN loss; MMR IHC retained; การจำแนกและการรักษา'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิงอายุ 58 ปี — pelvic mass + ascites + CA-125 markedly elevated → omental biopsy: papillary architecture + slit-like spaces + marked nuclear atypia + psammoma bodies; IHC: WT1+, PAX8+, p53 diffuse aberrant overexpression, p16 block-positive; การวินิจฉัย', '[{"label":"A","text":"Endometrioid"},{"label":"B","text":"High-Grade Serous Carcinoma (HGSC) — Ovarian/Tubal"},{"label":"C","text":"Mucinous"},{"label":"D","text":"Granulosa cell"},{"label":"E","text":"Teratoma"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** High-Grade Serous Carcinoma (HGSC) — Ovarian/Tubal: (1) **Histology**: papillary, slit-like glandular, solid; marked nuclear atypia + high mitotic rate + psammoma bodies; (2) **IHC**: **WT1+** (Müllerian/serous), PAX8+ (Müllerian), p53 ''aberrant'' (diffuse strong overexpression OR complete null) reflecting TP53 mutation (~ 96% HGSC), p16 block, Ki-67 high, ER variable; (3) **Origin**: most HGSCs arise from fallopian tube fimbriae (STIC — serous tubal intraepithelial carcinoma) — basis for opportunistic salpingectomy + RRSO in BRCA; (4) **Molecular**: TP53 ubiquitous; **homologous recombination deficiency (HRD)** ~ 50% — BRCA1/2 (germline + somatic) ~ 20-25%, other HR genes (RAD51, PALB2, BRIP1, CHEK2, ATM, BARD1); CCNE1 amplification mutually exclusive with HR loss; (5) **Tumor + germline testing** all HGSC (NCCN); (6) **Staging**: FIGO surgical — TAH-BSO + omentectomy + LN + cytoreduction; (7) **Treatment**: - Primary cytoreductive surgery + IV/IP platinum-taxane; - Neoadjuvant chemo + interval debulking acceptable; - Bevacizumab in select; - **PARP inhibitors** (olaparib, niraparib, rucaparib) maintenance — biggest impact in BRCA/HRD+ (SOLO-1, PRIMA, PAOLA-1); - Recurrent platinum-sensitive vs resistant; (8) **Grading**: 2-tier (low vs high grade) per WHO/MD Anderson; LGSC distinct entity (BRAF/KRAS, MAPK pathway, MEK inhibitor); (9) **Multidisciplinary** GYN-onc + medical onc + genetics + path

---

HGSC: papillary + psammoma + p53 aberrant + WT1+/PAX8+. TP53 ~96%; HRD ~50% (BRCA/HR genes). Origin: tubal fimbria (STIC). Treatment: cytoreduction + plat-tax + PARP maintenance (HRD biggest benefit). Universal germline.', NULL,
  'hard', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'WHO Female Genital Tumors 5th ed; NCCN Ovarian; SOLO-1; PAOLA-1', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยหญิงอายุ 58 ปี — pelvic mass + ascites + CA-125 markedly elevated → omental biopsy: papillary architecture + slit-like spaces + marked nuclear atypia + psammoma bodies; IHC: WT1+, PAX8+, p53 diffuse aberrant overexpression, p16 block-positive; การวินิจฉัย'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชายอายุ 68 ปี — elevated PSA → prostate biopsy: small infiltrative glands lacking basal cells, nucleoli prominent; ISUP/Gleason score 4+3=7 (Grade group 3); IHC: AMACR (P504S)+, basal markers (p63, HMWCK) negative; PTEN loss; การ stage และ rxtreatment', '[{"label":"A","text":"Benign"},{"label":"B","text":"Prostate Adenocarcinoma — Grading + Management"},{"label":"C","text":"BPH"},{"label":"D","text":"Refuse"},{"label":"E","text":"Prostatitis only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Prostate Adenocarcinoma — Grading + Management: (1) **Histology**: infiltrative small glands lacking basal cells; nucleoli prominent; (2) **IHC for diagnostic challenge**: AMACR (P504S)+ in cancer; basal cell markers (p63, HMWCK 34βE12, CK5/6) negative in cancer, positive in benign basal cells; (3) **Grading**: **ISUP Grade Groups (2014, integrated 2019)** — replaced sole Gleason reporting; GG1 = 3+3, GG2 = 3+4, GG3 = 4+3, GG4 = 8 (4+4, 3+5, 5+3), GG5 = 9-10; cribriform/intraductal carcinoma adverse features (report explicitly); (4) **Intraductal carcinoma of prostate (IDC-P)**: aggressive feature within ducts/acini; report separately — associated with adverse outcomes + germline DDR mutations; (5) **Staging**: TNM + risk groups (NCCN: very low, low, favorable intermediate, unfavorable intermediate, high, very high, regional, metastatic); PSMA-PET (Ga-68/F-18 piflufolastat) revolutionized staging + biochemical recurrence localization; (6) **Molecular biomarkers**: AR-V7 (resistance), BRCA1/2 + other HRR (germline + somatic — olaparib, rucaparib, talazoparib in mCRPC), MSI-H (rare → pembro), genomic classifiers (Decipher, Prolaris, Oncotype DX Prostate); (7) **Treatment by risk**: - Active surveillance for very low + selected low; - Localized: prostatectomy or RT ± ADT; - Metastatic hormone-sensitive: ADT + ARSI (apa/enza/abi) + chemo (TITAN, LATITUDE, ENZAMET, ARASENS, PEACE-1); - mCRPC: ARSI, docetaxel, cabazitaxel, radium-223 (bone), 177Lu-PSMA (VISION), PARP if HRR+; (8) **Germline testing** for metastatic + high-risk + family history

---

Prostate ca: small glands, no basal, AMACR+/p63-. ISUP grade groups GG1-5. Cribriform/IDC-P adverse. PSMA-PET staging; HRR germline (PARP). Risk-based: AS → RP/RT → ADT+ARSI±chemo → mCRPC ARSI/177Lu-PSMA/PARP.', NULL,
  'hard', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'WHO Urinary + Male Genital 5th ed; ISUP 2019; NCCN Prostate; VISION', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยชายอายุ 68 ปี — elevated PSA → prostate biopsy: small infiltrative glands lacking basal cells, nucleoli prominent; ISUP/Gleason score 4+3=7 (Grade group 3); IHC: AMACR (P504S)+, basal markers (p63, HMWCK) negative; PTEN loss; การ stage และ rxtreatment'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี — renal mass nephrectomy: tumor with clear cytoplasm + delicate vasculature ''chicken wire'' pattern + Fuhrman/WHO-ISUP grade 3; IHC: CAIX+, PAX8+, CD10+, vimentin+, CK7 patchy; molecular: VHL inactivation, 3p loss; การวินิจฉัย', '[{"label":"A","text":"Papillary RCC"},{"label":"B","text":"Clear Cell Renal Cell Carcinoma (ccRCC)"},{"label":"C","text":"Chromophobe"},{"label":"D","text":"Oncocytoma"},{"label":"E","text":"Angiomyolipoma"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Clear Cell Renal Cell Carcinoma (ccRCC): (1) **Histology**: clear cytoplasm (glycogen + lipid dissolved during processing), delicate vascular network ''chicken wire'', solid/alveolar/cystic; (2) **IHC**: CAIX (membranous, hypoxia marker)+, PAX8+, CD10+, vimentin+, RCC marker+; CK7 patchy (helpful vs papillary which CK7+); (3) **Grading**: **WHO/ISUP grade 1-4** (replaced Fuhrman) based on nucleoli prominence + rhabdoid/sarcomatoid features; (4) **Molecular**: **VHL gene inactivation** (3p deletion + somatic mutation/methylation) → HIF accumulation → pro-angiogenic (VEGF, PDGF); other 3p genes PBRM1, BAP1, SETD2; (5) **Hereditary**: VHL syndrome (germline VHL → bilateral multifocal ccRCC + hemangioblastoma + pheo); (6) **Other RCC subtypes (WHO 5th ed)**: papillary RCC (TFE3 — MiTF family translocation, FH-deficient — HLRCC, SDH-deficient, ELOC, SMARCB1-deficient renal medullary carcinoma); papillary type 1 (MET-driven) + type 2; chromophobe (KIT/EGFR, mitochondria-rich); collecting duct; medullary (sickle trait, very aggressive); (7) **Staging**: TNM + size; (8) **Treatment**: - Localized: partial vs radical nephrectomy; small renal masses (≤ 4 cm) — active surveillance considered, ablation, partial; - Metastatic frontline: IO doublet (nivolumab + ipi for intermediate/poor risk) OR IO + TKI (pembro + axitinib, nivo + cabo, pembro + lenvatinib, ave + axitinib) — based on IMDC risk; - Single-agent TKI (sunitinib, cabozantinib, pazopanib) historical; - HIF-2α inhibitor **belzutifan** approved (VHL-associated RCC + advanced RCC after IO/TKI)

---

ccRCC: clear cytoplasm + chicken-wire vessels; CAIX+/PAX8+/CD10+; VHL inactivation + 3p loss. WHO/ISUP grading. Hereditary: VHL syndrome. Treatment: IO doublet or IO+TKI metastatic; belzutifan HIF-2α inhibitor.', NULL,
  'medium', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'WHO Urinary + Male Genital 5th ed; NCCN Kidney', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี — renal mass nephrectomy: tumor with clear cytoplasm + delicate vasculature ''chicken wire'' pattern + Fuhrman/WHO-ISUP grade 3; IHC: CAIX+, PAX8+, CD10+, vimentin+, CK7 patchy; molecular: VHL inactivation, 3p loss; การวินิจฉัย'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชายอายุ 70 ปี — gross hematuria + bladder cystoscopy: papillary tumor → TURBT shows papillary urothelial neoplasm with mild atypia + low mitoses + > 7 cells thick; การจำแนกตาม WHO 2022 + ติดตาม', '[{"label":"A","text":"Carcinoma in situ only"},{"label":"B","text":"Urothelial Carcinoma — Classification + Management"},{"label":"C","text":"Refuse"},{"label":"D","text":"Hospice"},{"label":"E","text":"Routine f/u no Tx"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Urothelial Carcinoma — Classification + Management: (1) **WHO 2022 (5th ed) classification**: - Urothelial papilloma (rare); - **PUNLMP** (papillary urothelial neoplasm of low malignant potential); - **Non-invasive low-grade papillary urothelial carcinoma**; - **Non-invasive high-grade papillary urothelial carcinoma**; - **Urothelial CIS** (flat high-grade); - **Invasive urothelial carcinoma** (Ta — non-invasive, T1 lamina propria, T2+ muscularis propria); (2) **Histologic features**: variants — squamous, glandular, micropapillary (aggressive — early radical), plasmacytoid (aggressive, CDH1 loss), sarcomatoid, nested, lymphoepithelioma-like, lipid-cell; (3) **IHC**: GATA3, p40/p63, CK7+/CK20+ uroplakin+ helpful for site of origin in mets; (4) **Molecular subtypes** (TCGA, Lund — luminal, basal/squamous, neuroendocrine) — increasingly therapy-relevant; (5) **FGFR3 alterations** in ~ 20% (more in NMIBC) → erdafitinib (THOR trial) in metastatic; (6) **Treatment**: - **NMIBC** (Ta, T1, CIS): TURBT + intravesical therapy (BCG for high-risk; mitomycin) + surveillance; BCG-unresponsive — pembrolizumab, nadofaragene firadenovec, oportuzumab monatox; - **MIBC** (T2+): neoadjuvant cisplatin chemo (MVAC/gem-cis) + radical cystectomy + PLND; bladder preservation TMT in select; adjuvant nivolumab (CheckMate 274) ypT2+/N+; - **Metastatic**: now frontline **enfortumab vedotin + pembrolizumab** (EV-302) — superseded chemo; chemo alternative; later sacituzumab govitecan, erdafitinib (FGFR), avelumab maintenance after chemo response; (7) **Multidisciplinary**

---

Urothelial ca WHO 2022: PUNLMP/low-grade/high-grade/CIS/invasive. Variants matter (micropap/plasmacytoid aggressive). FGFR3 — erdafitinib. NMIBC: TURBT+BCG. MIBC: neoadj cis + cystectomy. Metastatic: EV+pembro frontline.', NULL,
  'hard', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'WHO Urinary + Male Genital 5th ed; NCCN Bladder; EV-302', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยชายอายุ 70 ปี — gross hematuria + bladder cystoscopy: papillary tumor → TURBT shows papillary urothelial neoplasm with mild atypia + low mitoses + > 7 cells thick; การจำแนกตาม WHO 2022 + ติดตาม'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชายอายุ 28 ปี — testicular mass orchiectomy: tumor cells with fried-egg cytoplasm + clear glycogen + lymphocytic infiltrate; IHC: OCT3/4+, PLAP+, CD117+, SALL4+, CK negative; serum: AFP normal, beta-hCG mildly elevated, LDH elevated', '[{"label":"A","text":"Yolk sac"},{"label":"B","text":"Testicular Seminoma (Classic)"},{"label":"C","text":"Lymphoma"},{"label":"D","text":"Sertoli cell"},{"label":"E","text":"Refuse Tx"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Testicular Seminoma (Classic): (1) **Histology**: sheets/nests of uniform cells with clear cytoplasm (glycogen — ''fried egg''), prominent central nucleoli, fibrous septa with lymphocytic infiltrate ± granulomas; (2) **IHC**: **OCT3/4**+, PLAP+, **CD117 (KIT)**+, SALL4+, D2-40 (podoplanin)+, CK negative (vs embryonal CK+); CD30 negative (vs embryonal); (3) **Tumor markers**: AFP normal (elevated AFP rules out pure seminoma — indicates yolk sac or mixed); beta-hCG mildly elevated possible (syncytiotrophoblast cells); LDH non-specific; (4) **Differential**: embryonal (CD30+, OCT4+, CK+), yolk sac (AFP+, glypican-3+), choriocarcinoma (hCG markedly elevated), teratoma; spermatocytic tumor (older age, OCT4 negative); (5) **Precursor**: **germ cell neoplasia in situ (GCNIS)** — formerly ITGCN — atypical germ cells in seminiferous tubules; OCT4+, PLAP+; (6) **Staging**: TNM + serum tumor markers (S) + risk groups (IGCCCG); (7) **Treatment** (highly curable): - Stage I: orchiectomy + surveillance (preferred), single-dose carboplatin, or RT (less favored now); - Stage IIA/B: RT or chemo (BEP × 3 / EP × 4); - Stage IIC+/metastatic: BEP × 3 (good risk) or BEP × 4 (intermediate); - Salvage: high-dose chemo + autoSCT or TIP; (8) **Survivorship**: cardiovascular + second malignancy + fertility — sperm banking pre-treatment essential; (9) **Genetic**: isochromosome 12p (i(12p)) characteristic

---

Seminoma: fried-egg + lymphocytic infiltrate; OCT3/4+/CD117+/SALL4+, CK-/CD30-. AFP normal (if AFP↑ → mixed/yolk sac). Precursor GCNIS. Stage I surveillance preferred. BEP chemo highly curative. i(12p) characteristic.', NULL,
  'medium', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'WHO Urinary + Male Genital 5th ed; NCCN Testicular', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยชายอายุ 28 ปี — testicular mass orchiectomy: tumor cells with fried-egg cytoplasm + clear glycogen + lymphocytic infiltrate; IHC: OCT3/4+, PLAP+, CD117+, SALL4+, CK negative; serum: AFP normal, beta-hCG mildly elevated, LDH elevated'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 35 ปี — thyroid nodule FNA → cytology Bethesda VI (malignant); thyroidectomy: papillary architecture + nuclear features (clearing, grooves, intranuclear pseudoinclusions) + psammoma bodies; molecular: BRAF V600E mutation', '[{"label":"A","text":"Anaplastic thyroid ca"},{"label":"B","text":"Papillary Thyroid Carcinoma (PTC)"},{"label":"C","text":"Medullary"},{"label":"D","text":"Hashimoto"},{"label":"E","text":"Adenoma"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Papillary Thyroid Carcinoma (PTC): (1) **Bethesda system for thyroid cytopathology** I-VI; III (AUS/FLUS) + IV (FN/SFN) — molecular testing (Afirma GSC, ThyroSeq, ThyGeNEXT-ThyraMIR) refines risk; V suspicious; VI malignant; (2) **PTC histology**: papillary fronds with fibrovascular cores; **nuclear features** diagnostic — chromatin clearing (''Orphan Annie eyes''), nuclear grooves, intranuclear pseudoinclusions, irregular contours, overlapping; psammoma bodies; (3) **IHC**: TTF1+, thyroglobulin+, CK19+, HBME-1+, galectin-3+; cyclin D1+; (4) **Variants** (some renamed in 2017 reclassification): - **NIFTP** (non-invasive follicular thyroid neoplasm with papillary-like nuclear features) — formerly noninvasive encapsulated FV-PTC — indolent, lobectomy alone; - Classical, follicular variant, tall cell, columnar, hobnail (aggressive), diffuse sclerosing, solid; (5) **Molecular**: **BRAF V600E** ~ 60% (more aggressive, more recurrence); RAS-mutated (more follicular-pattern, less aggressive); RET/PTC rearrangements (radiation-associated, pediatric); TERT promoter (adverse); (6) **Treatment**: lobectomy vs total thyroidectomy based on size + features + risk; selective central neck dissection; RAI for selected (intermediate/high-risk); levothyroxine TSH suppression for higher risk; (7) **Targeted therapy**: dabrafenib + trametinib (BRAF+ advanced); selpercatinib/pralsetinib (RET fusions); larotrectinib/entrectinib (NTRK fusions); cabozantinib, lenvatinib, sorafenib (RAI-refractory); (8) **Active surveillance** for low-risk papillary microcarcinoma (< 1 cm, no concerning features) emerging

---

PTC: papillary + diagnostic nuclear features (clearing, grooves, pseudoinclusions) + psammoma. Bethesda → molecular refines risk. NIFTP carved out. BRAF V600E ~60%; targeted Tx for advanced (BRAF/RET/NTRK). RAI selected.', NULL,
  'medium', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'WHO Endocrine Tumors 5th ed; Bethesda 2023; ATA Thyroid 2015', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 35 ปี — thyroid nodule FNA → cytology Bethesda VI (malignant); thyroidectomy: papillary architecture + nuclear features (clearing, grooves, intranuclear pseudoinclusions) + psammoma bodies; molecular: BRAF V600E mutation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิงอายุ 62 ปี non-smoker — lung mass → biopsy: glandular architecture with lepidic + acinar patterns; IHC: TTF-1+, napsin-A+, CK7+; molecular reflex: EGFR exon 19 deletion mutation positive, ALK negative, ROS1 negative, PD-L1 TPS 5%', '[{"label":"A","text":"SCLC"},{"label":"B","text":"Lung Adenocarcinoma — Pathology + Molecular"},{"label":"C","text":"Mesothelioma"},{"label":"D","text":"Carcinoid"},{"label":"E","text":"Pneumonia"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Lung Adenocarcinoma — Pathology + Molecular: (1) **Histology**: lepidic, acinar, papillary, micropapillary (aggressive), solid, mucinous, colloid; new IASLC grading (G1-3) by predominant + high-grade pattern; (2) **IHC**: TTF-1+ (most), napsin-A+, CK7+; mucinous adenoca may TTF-1 negative; vs squamous (p40+, CK5/6+); SCLC (synaptophysin, chromogranin, INSM1+, TTF-1+, CK dot-like); (3) **Essential biomarker panel (advanced NSCLC, NCCN/CAP)**: **EGFR, ALK, ROS1, BRAF V600E, KRAS (especially G12C), MET exon 14 + amplification, HER2 (ERBB2), RET, NTRK1/2/3, NRG1; PD-L1 TPS**; comprehensive NGS preferred; (4) **Targeted therapy (matched)**: - EGFR (exon 19 del, L858R): osimertinib (3rd-gen) frontline; FLAURA2 osimertinib + chemo; amivantamab + lazertinib (MARIPOSA); exon 20 ins — amivantamab; - ALK: alectinib, brigatinib, lorlatinib (CROWN); - ROS1: entrectinib, repotrectinib (newer), crizotinib; - BRAF V600E: dab + tram; encorafenib + binimetinib; - KRAS G12C: sotorasib, adagrasib; - MET ex14: capmatinib, tepotinib; - RET fusion: selpercatinib, pralsetinib; - NTRK: larotrectinib, entrectinib; - HER2: T-DXd; - NRG1: zenocutuzumab; (5) **No driver mutation**: IO ± chemo based on PD-L1; KEYNOTE-189/407; (6) **Adjuvant** for resected: osimertinib (EGFR — ADAURA), atezolizumab/pembro (PD-L1 ≥ 1%), alectinib (ALK — ALINA); (7) **Re-biopsy on progression** for resistance mechanisms (T790M, C797S, MET amp)

---

Lung adenoca: TTF-1+/napsin-A+. IASLC grading. Essential biomarkers (EGFR/ALK/ROS1/BRAF/KRAS/MET/HER2/RET/NTRK/NRG1/PD-L1). Matched targeted Tx (osimertinib EGFR; alectinib ALK; etc.). Re-biopsy at progression.', NULL,
  'hard', 'molecular_pathology', 'review',
  'pathology', 'clinical_decision', 'molecular_pathology', 'adult',
  'WHO Thoracic Tumors 5th ed; NCCN NSCLC; CAP/IASLC/AMP Lung Biomarker', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยหญิงอายุ 62 ปี non-smoker — lung mass → biopsy: glandular architecture with lepidic + acinar patterns; IHC: TTF-1+, napsin-A+, CK7+; molecular reflex: EGFR exon 19 deletion mutation positive, ALK negative, ROS1 negative, PD-L1 TPS 5%'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 70 ปี heavy smoker — central lung mass → biopsy: keratin pearls + intercellular bridges + cells with abundant eosinophilic cytoplasm; IHC: p40+, p63+, CK5/6+, TTF-1 negative; การวินิจฉัย และ implications', '[{"label":"A","text":"Adenocarcinoma"},{"label":"B","text":"Squamous Cell Carcinoma of Lung"},{"label":"C","text":"SCLC"},{"label":"D","text":"Carcinoid"},{"label":"E","text":"Tuberculosis"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Squamous Cell Carcinoma of Lung: (1) **Histology**: keratinization (keratin pearls), intercellular bridges, eosinophilic dense cytoplasm; central location classically (vs peripheral adenocarcinoma); (2) **IHC**: **p40+** (most specific), p63+, CK5/6+, CK7 variable, TTF-1 negative, napsin-A negative, desmoglein-3+; (3) **Molecular**: PIK3CA, PTEN, FGFR1 amplification, DDR2 — fewer actionable drivers vs adenocarcinoma; (4) **Smoking-related**; tumor mutational burden often high → IO response; (5) **Biomarker testing**: PD-L1 TPS essential; comprehensive NGS still warranted to find rare actionable (rare EGFR/ALK if non-smoker or never-smoker history); (6) **Treatment (advanced)**: - PD-L1 ≥ 50%: pembrolizumab monotherapy or chemo-IO; - PD-L1 < 50%: chemo + pembrolizumab (KEYNOTE-407 with carbo + paclitaxel/nab-paclitaxel); - Other combos: atezolizumab + chemo; cemiplimab; durva + treme + chemo; nivolumab + ipilimumab + chemo; - **Bevacizumab + erlotinib contraindicated** in squamous (cavitation/hemorrhage risk historically — pemetrexed and bevacizumab limited to non-squamous); (7) **Resectable**: surgery + adjuvant cisplatin chemo (+ adjuvant atezolizumab/pembro); neoadjuvant nivo + chemo (CheckMate 816); perioperative pembro/nivo (KEYNOTE-671, AEGEAN); (8) **Locally advanced**: concurrent chemoRT + durvalumab consolidation (PACIFIC); (9) **Distinguishing from adenoca essential** for treatment (pemetrexed/bevacizumab restrictions)

---

Squamous NSCLC: keratinization + bridges; p40+/p63+/CK5/6+, TTF-1-/napsin-. Smoking-related, few drivers. PD-L1 + NGS. Pembro ± chemo (KEYNOTE-407). No pemetrexed/bev (squamous). Perioperative IO + chemo (CheckMate 816).', NULL,
  'medium', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'WHO Thoracic Tumors 5th ed; NCCN NSCLC; KEYNOTE-407', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 70 ปี heavy smoker — central lung mass → biopsy: keratin pearls + intercellular bridges + cells with abundant eosinophilic cytoplasm; IHC: p40+, p63+, CK5/6+, TTF-1 negative; การวินิจฉัย และ implications'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี — pigmented skin lesion excision: atypical melanocytes with pagetoid spread + asymmetry + Breslow thickness 2.3 mm + ulceration present + mitoses 4/mm²; IHC: S100+, SOX10+, HMB-45+, Melan-A+; molecular: BRAF V600E mutation positive', '[{"label":"A","text":"Benign nevus"},{"label":"B","text":"Cutaneous Melanoma — Pathology + Management"},{"label":"C","text":"BCC"},{"label":"D","text":"Seborrheic keratosis"},{"label":"E","text":"Dermatofibroma"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cutaneous Melanoma — Pathology + Management: (1) **Histology**: atypical melanocytes in nests + single cells; pagetoid (upward) spread; lack of maturation; mitoses including deep; ulceration; lymphovascular/perineural invasion; (2) **IHC**: **SOX10** (most sensitive, nuclear), S100+, HMB-45+, Melan-A (MART-1)+, tyrosinase+, **PRAME** emerging (positive in melanoma, helps distinguish from nevus; high specificity); (3) **Critical prognostic features** (AJCC 8th): **Breslow thickness**, **ulceration**, **mitotic rate** (for T1 specifically); (4) **Subtypes**: superficial spreading (most common, BRAF), nodular, lentigo maligna (chronic sun-damage, NF1/KIT), acral (KIT, no BRAF often), mucosal (KIT, NF1), uveal (GNAQ/GNA11 — BAP1 loss aggressive — distinct biology); desmoplastic (TERT promoter, NF1); (5) **Molecular**: **BRAF V600E/K** ~ 50% cutaneous; NRAS, NF1; KIT in acral/mucosal; TERT promoter ubiquitous; (6) **SLNB indication**: T1b (≥ 0.8 mm or ulceration), all T2+; staging — MSLT-II showed CLND no benefit in SLN+ → observation + nodal US; (7) **Treatment by stage**: - In situ: wide local excision; - Stage I-II: WLE + SLNB; adjuvant for IIB+ (pembro/nivo) or BRAF-targeted (dab+tram BRAF+); - Stage III resected: adjuvant nivolumab or pembrolizumab; BRAF+ — dab + tram; - Stage IV metastatic: nivo + ipi or nivo + relatlimab (RELATIVITY-047 LAG3) or pembro; BRAF+ — chemo-IO or targeted; brain mets — combination important; - Neoadjuvant pembro before resection (S1801, NADINA) emerging standard for high-risk resectable; (8) **TIL therapy** (lifileucel) approved 2024 for refractory metastatic

---

Melanoma: pagetoid + atypia + Breslow + ulceration + mitoses. SOX10/S100/HMB-45/Melan-A/PRAME. BRAF V600 ~50%; subtypes differ molecularly. SLNB T1b+. Adjuvant IO IIB+; metastatic nivo+ipi or nivo+rela; neoadjuvant pembro emerging.', NULL,
  'hard', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'WHO Skin Tumors 5th ed; AJCC 8th; NCCN Melanoma; RELATIVITY-047', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี — pigmented skin lesion excision: atypical melanocytes with pagetoid spread + asymmetry + Breslow thickness 2.3 mm + ulceration present + mitoses 4/mm²; IHC: S100+, SOX10+, HMB-45+, Melan-A+; molecular: BRAF V600E mutation positive'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 72 ปี — pearly papule with telangiectasias on nose × 1 year → shave biopsy: nests of basaloid cells with peripheral palisading + cleft (retraction) artifact + myxoid stroma; IHC: BerEP4+, EMA-, CK20-; การวินิจฉัยและการรักษา', '[{"label":"A","text":"Melanoma"},{"label":"B","text":"Basal Cell Carcinoma (BCC)"},{"label":"C","text":"Refuse"},{"label":"D","text":"Hospice"},{"label":"E","text":"Cyst"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Basal Cell Carcinoma (BCC): (1) **Histology**: basaloid cells with peripheral palisading + retraction artifact (cleft between epithelium + stroma due to mucin) + mucinous stroma + variable mitoses; (2) **Subtypes**: nodular (most common), superficial, infiltrative/morpheaform (aggressive — ill-defined margin), micronodular (aggressive), basosquamous (intermediate aggressiveness, can metastasize rarely), pigmented; (3) **IHC**: BerEP4+, BCL2+, EMA negative, CK20 (negative — distinguishes from Merkel cell ca), Ki-67 variable; (4) **Risk factors**: UV exposure cumulative + intermittent, fair skin, immunosuppression (transplant — high frequency + aggressive), prior RT, arsenic, Gorlin (NBCCS — PTCH1, basal cells nevus syndrome — multiple BCCs young); (5) **Molecular pathway**: **Hedgehog (SMO/PTCH1/GLI)** dysregulation; (6) **Behavior**: locally invasive, rarely metastasize; perineural invasion + deep extension important; (7) **Treatment**: - **Low-risk**: surgical excision with margins (4 mm), curettage + electrodesiccation; - **High-risk** (H-zone face, larger > 2 cm trunk, recurrent, aggressive subtypes, PNI, immunosuppressed): **Mohs micrographic surgery** (preferred), wider excision; - **RT** for non-surgical candidates; - **Topical** imiquimod / 5-FU for superficial BCC; PDT; - **Locally advanced/metastatic**: **Hedgehog inhibitors** (vismodegib, sonidegib); - **Immunotherapy** (cemiplimab) approved for HHi-refractory or intolerant; (8) **Surveillance**: yearly full skin exam (high risk for second BCC + other skin ca); sun protection; (9) **Gorlin syndrome**: genetic testing + multi-disciplinary

---

BCC: basaloid + peripheral palisading + cleft; BerEP4+/BCL2+. HH pathway. Subtypes (nodular/infiltrative/morpheaform). Mohs for high-risk facial. HHi (vismodegib) + cemiplimab for advanced. Gorlin if multiple/young.', NULL,
  'easy', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'WHO Skin Tumors 5th ed; NCCN BCC', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 72 ปี — pearly papule with telangiectasias on nose × 1 year → shave biopsy: nests of basaloid cells with peripheral palisading + cleft (retraction) artifact + myxoid stroma; IHC: BerEP4+, EMA-, CK20-; การวินิจฉัยและการรักษา'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'นักศึกษาแพทย์สงสัยหลักการ tissue fixation และ processing: เนื้อเยื่อใส่ใน 10% neutral buffered formalin เกินไป 48 ชม จะมีผลอย่างไร และ alternatives สำหรับ molecular testing', '[{"label":"A","text":"Tissue ดีขึ้น"},{"label":"B","text":"Tissue Fixation Principles"},{"label":"C","text":"Skip fixation"},{"label":"D","text":"Use boiling water"},{"label":"E","text":"Discard"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Tissue Fixation Principles: (1) **10% NBF (neutral buffered formalin)** = standard — cross-links proteins (methylene bridges) — penetrates ~ 1 mm/h — recommended **6-72 hours** fixation (per CAP/ASCO HER2/ER guidelines for breast); **cold ischemia time ≤ 1 hour** breast specimens; (2) **Over-fixation (> 72 h)**: degrades antigenicity (false-negative IHC for ER/HER2), fragments nucleic acids (poor PCR/NGS), but tissue stable for histology; (3) **Under-fixation**: incomplete penetration → autolysis center → poor morphology + variable IHC; (4) **Alternative fixatives**: - Bouin''s (picric acid) — better nuclear detail, but degrades nucleic acids — testes, bones; - Zenker''s (HgCl2) — sharper nuclei but mercury toxic, environmental; - B5 — hematopathology classic, mercury concern, fading use; - Alcohol-based (95% ethanol) — preserves nucleic acid better, used in cytology + molecular pathology — protects RNA; - **PAXgene Tissue System** — preserves DNA/RNA + morphology — for molecular pathology; - Frozen (snap-freeze) — best for molecular + immunofluorescence (renal, muscle, tumor banking); (5) **Processing**: dehydration (graded ethanols) → clearing (xylene) → paraffin infiltration → embedding → microtome sectioning (3-5 μm) → H&E stain; (6) **Decalcification for bone**: EDTA preferred (preserves IHC + molecular) vs acid (faster but damages); (7) **Quality assurance**: cold ischemia, fixation time, processing tracking essential for biomarker accuracy + reproducibility (CAP checklists)

---

10% NBF standard, 6-72h fixation; cold ischemia ≤1h for breast biomarkers. Over-fix degrades IHC + nucleic acids; under-fix → autolysis. Alternatives: Bouin''s (testes/bone), PAXgene (molecular), alcohol (cytology), frozen (IF/molecular). EDTA for bone.', NULL,
  'medium', 'quality_safety', 'review',
  'pathology', 'basic_science', 'quality_safety', 'mixed',
  'CAP Cancer Protocols; ASCO/CAP HER2 + ER Guidelines; AJCP Fixation', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'นักศึกษาแพทย์สงสัยหลักการ tissue fixation และ processing: เนื้อเยื่อใส่ใน 10% neutral buffered formalin เกินไป 48 ชม จะมีผลอย่างไร และ alternatives สำหรับ molecular testing'
  );

commit;

