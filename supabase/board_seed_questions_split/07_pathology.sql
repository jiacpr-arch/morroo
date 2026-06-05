-- ===============================================================
-- หมอรู้ — Board seed: พยาธิวิทยา (pathology) — 30 MCQs
-- Safe to paste into Supabase SQL Editor. Re-runnable.
-- ===============================================================

begin;

-- 1/2 ─── mcq_subjects for this specialty ────────────────────
insert into public.mcq_subjects
  (name, name_th, icon, audience, board_specialty, exam_type, question_count)
values
  ('path_clinical_decision', 'พยาธิวิทยา · การตัดสินใจทางเวชกรรม', '🩺', 'board', 'pathology', NULL, 0),
  ('path_basic_science', 'พยาธิวิทยา · วิทยาศาสตร์การแพทย์พื้นฐาน', '🧬', 'board', 'pathology', NULL, 0),
  ('path_ems_mgmt', 'พยาธิวิทยา · การจัดการระบบบริการการแพทย์ฉุกเฉิน', '🚨', 'board', 'pathology', NULL, 0),
  ('path_integrative', 'พยาธิวิทยา · ข้อสอบบูรณาการ', '🧩', 'board', 'pathology', NULL, 0)
on conflict (name) do nothing;

-- 2/2 ─── 30 mcq_questions for pathology ─────────────

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี breast lump biopsy — histopathology + immunohistochemistry results: invasive ductal carcinoma, grade 2, ER 95%+ PR 70%+ HER2 IHC 3+ confirmed by FISH amplification', '[{"label":"A","text":"No treatment"},{"label":"B","text":"Breast Cancer Pathology Interpretation: (1) **Histologic type**: invasive ductal carcinoma (IDC) — most common; other types — lobular, mucinous, tubular, medullary, metaplastic; (2) **Grade (Nottingham)**: based on tubule formation + nuclear pleomorphism + mitotic count — 1 (well) to 3 (poorly differentiated); (3) **Stage**: AJCC TNM (T size, N nodes, M metastases) + anatomic + prognostic; (4) **Biomarkers** (essential for treatment decisions): - **ER (estrogen receptor)** + percent positive — predicts hormone therapy benefit; - **PR (progesterone receptor)** — confirms ER pathway; - **HER2** by IHC (0, 1+, 2+, 3+) → FISH for 2+ to confirm amplification; this patient HER2+ → targeted therapy; - **Ki-67** proliferation index; (5) **Molecular subtypes**: Luminal A (ER+, HER2-, low Ki-67), Luminal B (ER+, HER2- high Ki-67 or HER2+), HER2-enriched, Triple-negative (TNBC); (6) **Genomic assays**: Oncotype DX 21-gene recurrence score, MammaPrint, PAM50 — guide adjuvant chemo decisions in ER+/HER2-; (7) **HER2+ implications**: trastuzumab + pertuzumab targeted therapy improves survival dramatically; (8) **Triple-negative**: PARP inhibitors if BRCA, immunotherapy (pembrolizumab) for PD-L1+; (9) **Multidisciplinary tumor board**: pathology + surgery + medical oncology + radiation oncology + radiology + genetics; (10) **Genetic counseling**: BRCA + others when criteria met; (11) **Modern**: precision oncology + molecular characterization + targeted therapy"},{"label":"C","text":"Surgery only"},{"label":"D","text":"Refuse"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', 'Breast cancer pathology: histologic type + grade + stage + biomarkers (ER, PR, HER2, Ki-67) → molecular subtypes → treatment selection. Genomic assays for adjuvant decisions. HER2+ → targeted therapy. Multidisciplinary tumor board. Modern: precision oncology.', NULL,
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
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี — peripheral blood smear shows immature blasts with Auer rods + CBC: WBC 45,000, Hb 8.4, Plt 28,000 — concerned acute leukemia', '[{"label":"A","text":"Ignore"},{"label":"B","text":"Acute Leukemia Pathology Diagnosis: (1) **Initial workup**: CBC + peripheral smear + bone marrow biopsy + aspirate; (2) **Acute Myeloid Leukemia (AML)**: blasts ≥ 20% in marrow (or PB); Auer rods pathognomonic; (3) **Acute Lymphoblastic Leukemia (ALL)**: blasts ≥ 20% lymphoid lineage; (4) **Distinguishing**: morphology + immunophenotype (flow cytometry — myeloid markers MPO, CD13, CD33, CD117 vs lymphoid markers CD19, CD20, CD10, TdT) + cytochemistry (MPO+ in AML); (5) **Cytogenetics + molecular essential**: - AML good prognosis: t(8;21), inv(16), t(15;17) — APL (acute promyelocytic — treat differently with ATRA + arsenic); - AML poor: complex karyotype, monosomy 5, 7; - AML molecular: FLT3-ITD, NPM1, CEBPA, TP53, IDH1/2 + targeted therapies (gilteritinib, midostaurin for FLT3, venetoclax-azacitidine combos); - ALL: Philadelphia chromosome t(9;22) BCR-ABL — TKI added; (6) **Treatment based on subtype**: - AML: 7+3 induction (cytarabine + anthracycline) → consolidation → consider HCT (hematopoietic cell transplant); - APL: ATRA + arsenic — > 90% cure (don''t miss — DIC risk if delayed); - ALL: multi-agent chemo + CNS prophylaxis + +/- HCT; (7) **Supportive care**: blood products, antibiotic, tumor lysis prophylaxis, fever workup; (8) **Multidisciplinary**: heme-onc + pathology + transplant + ID + ICU; (9) **Modern**: targeted therapies, immunotherapy (CAR-T, blinatumomab for ALL), MRD monitoring; (10) **Long-term survivorship + late effects**"},{"label":"C","text":"Surgery"},{"label":"D","text":"Refuse"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', 'Acute leukemia diagnosis: morphology + immunophenotype (flow) + cytochemistry + cytogenetics + molecular. Auer rods → AML. APL (t(15;17)) treated differently (ATRA + arsenic). Subtype-based treatment + targeted therapies + immunotherapy. Multidisciplinary + supportive care.', NULL,
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
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 45 ปี — chronic diarrhea + weight loss + colonoscopy with biopsy — pathology: chronic active inflammation + crypt distortion + granulomas — IBD workup', '[{"label":"A","text":"Random treatment"},{"label":"B","text":"IBD Pathology + Diagnosis: (1) **Crohn''s vs UC differentiation**: - **Crohn''s**: transmural inflammation, skip lesions, granulomas (50%), strictures, fistulas, can affect any GI from mouth to anus, terminal ileum most common; - **UC**: continuous mucosal + submucosal inflammation, starts rectum + extends proximally, no granulomas, crypt abscesses, no skip lesions; - **Indeterminate colitis**: features of both; (2) **Histology**: chronic + active inflammation; crypt distortion (chronic); granulomas (Crohn''s); rule out infection + ischemia + drug-induced; (3) **Other workup**: endoscopy + biopsy; CT/MR enterography (small bowel for Crohn''s); fecal calprotectin (active inflammation); stool studies (C. difficile, parasites, bacterial); serologies (ASCA Crohn''s, p-ANCA UC); (4) **Treatment based on type + severity** (ACG + ECCO guidelines): - 5-ASA (mesalamine) for mild UC; - Corticosteroids for moderate-severe induction (not maintenance); - Immunomodulators (azathioprine, methotrexate); - Biologics (anti-TNF — infliximab, adalimumab; anti-integrin — vedolizumab; anti-IL12/23 — ustekinumab, risankizumab; anti-IL23 — risankizumab; JAK inhibitors — tofacitinib, upadacitinib); - Small molecule (S1P — ozanimod); (5) **Surgery**: for refractory + complications; can be curative in UC (proctocolectomy); not curative in Crohn''s; (6) **Surveillance for dysplasia + colon cancer**: increased risk with longstanding colitis, IBD-related cancer differs from sporadic; (7) **Complications**: strictures, fistulas, abscesses, perforation, dysplasia, malnutrition, growth failure (peds), extraintestinal (skin, joints, eyes, liver — PSC); (8) **Multidisciplinary**: GI + surgery + pathology + radiology + nutrition + mental health"},{"label":"C","text":"Refuse"},{"label":"D","text":"Discharge"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', 'IBD pathology: Crohn''s (transmural, granulomas, skip lesions) vs UC (mucosal continuous from rectum). Treatment by type + severity. Biologics + small molecules expanded options. Surveillance for dysplasia/cancer. Multidisciplinary. Modern: precision + biologics.', NULL,
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
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 70 ปี — sputum AFB smear positive + Mycobacterium tuberculosis identified — drug susceptibility testing pending — pulmonary TB workup', '[{"label":"A","text":"Ignore"},{"label":"B","text":"TB Diagnosis + Drug Susceptibility (CDC + WHO): (1) **Initial diagnostics**: AFB smear (sensitivity 50-70%, fast), TB culture (gold standard but slow 4-8 wk), NAAT (Xpert MTB/RIF — rapid + detects rifampin resistance); (2) **Drug susceptibility testing (DST)**: essential — phenotypic (slow) + genotypic (rapid — line probe assay, sequencing); (3) **Categories**: drug-susceptible (DS), MDR (multi-drug resistant — resistant to ≥ INH + RIF), pre-XDR/XDR (extensively — adds fluoroquinolone + second-line); (4) **Treatment based on susceptibility**: - **DS-TB**: 6-month standard regimen (RIPE 2 mo intensive + RI 4 mo continuation) OR shorter 4-month regimen rifapentine + moxifloxacin (Study 31, 2022); - **MDR-TB**: longer (9-24 months) all-oral with bedaquiline + linezolid + levofloxacin/moxifloxacin + others (BPaL regimen — bedaquiline + pretomanid + linezolid for 6 months — Nix-TB/ZeNix trials, revolutionary); (5) **Isolation**: airborne precautions in hospitals until non-infectious; (6) **HIV testing all TB** (high co-infection); (7) **DOT (Directly Observed Therapy)** for adherence; (8) **Public health reporting** + contact tracing; (9) **Treatment of contacts** (LTBI — latent TB infection): rifamycin-based shorter regimens (3HP — 12 wk rifapentine + INH preferred; 4R — 4 mo rifampin; 6-9 mo INH); (10) **Monitor**: clinical, sputum AFB, LFT, CBC, vision (ethambutol), uric acid; (11) **Multidisciplinary**: TB program + ID + pulmonology + public health"},{"label":"C","text":"Surgery"},{"label":"D","text":"Refuse"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', 'TB pathology: AFB + culture + NAAT (Xpert) + DST essential. DS standard 6-month regimen or 4-month new. MDR — BPaL revolutionary 6-month all-oral. DOT + isolation + public health reporting. Contact tracing + LTBI treatment. Multidisciplinary.', NULL,
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
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี — autoimmune hepatitis workup — labs: AST/ALT elevated + ANA positive + anti-smooth muscle Ab positive + IgG elevated + liver biopsy: interface hepatitis + lymphoplasmacytic infiltrate', '[{"label":"A","text":"Ignore"},{"label":"B","text":"Autoimmune Hepatitis Diagnosis + Management: (1) **AIH Type 1**: ANA + ASMA + IgG elevation (most common); (2) **AIH Type 2**: anti-LKM1 (children); (3) **Histology**: interface hepatitis (inflammation at limiting plate) + lymphoplasmacytic infiltrate + rosette formation; (4) **Differential**: viral hepatitis (Hep A/B/C/E), drug-induced (DILI), Wilson''s, NAFLD, alcohol, hemochromatosis, PBC, PSC; (5) **Workup**: viral hepatitis serologies, drug history, metabolic (ferritin, ceruloplasmin, alpha-1 antitrypsin), AMA (PBC overlap); (6) **Treatment** (AASLD + EASL): - **Prednisone + Azathioprine** combination first-line; - **Budesonide** alternative initial (less systemic SE — non-cirrhotic only); - **Mycophenolate** for AZA-intolerant; - **Calcineurin inhibitors** (cyclosporine, tacrolimus) for refractory; - **Rituximab** considered; (7) **Goal**: biochemical remission (normal LFTs + IgG); sustained ~ 3-5 yr before trial of discontinuation; high relapse rate (50-80%) — many lifelong therapy; (8) **Monitor**: LFTs + clinical regularly; bone density (steroid risk); pregnancy planning; (9) **Vaccinations**: hepatitis A/B, flu, pneumo, COVID, shingles; (10) **Cirrhosis surveillance**: HCC screening with US + AFP q6 mo; (11) **Transplant** for end-stage; can recur post-transplant; (12) **Multidisciplinary**: hepatology + pathology + rheumatology + pharmacy + transplant + primary care"},{"label":"C","text":"Surgery"},{"label":"D","text":"Refuse"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', 'AIH: serology + histology (interface hepatitis + lymphoplasmacytic) + IgG. Rule out other causes. Treatment: pred + AZA; biochemical remission goal. Often lifelong therapy. Monitoring + complications. Multidisciplinary care.', NULL,
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
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 35 ปี — gravid uterus + concerns about gestational trophoblastic disease — hCG very elevated + US — complete hydatidiform mole', '[{"label":"A","text":"Ignore"},{"label":"B","text":"Gestational Trophoblastic Disease Pathology: (1) **Spectrum (GTD)**: hydatidiform mole (complete + partial) → invasive mole → gestational trophoblastic neoplasia (GTN — choriocarcinoma, placental site trophoblastic tumor, epithelioid trophoblastic tumor); (2) **Complete mole**: diploid 46,XX or 46,XY all paternal; no fetal tissue; markedly elevated hCG; ''snowstorm'' US; 20% risk progression to GTN; (3) **Partial mole**: triploid (69 chromosomes); some fetal tissue; less elevated hCG; 5% risk progression; (4) **Pathology**: villi with central cisternal cavitation, trophoblastic proliferation, no fetal blood vessels (complete); (5) **Management**: - **Suction D+C** (dilation + curettage) of uterus — primary treatment; - **Anti-D immunoglobulin** if Rh-negative; - **Weekly hCG monitoring** until 3 consecutive undetectable then monthly × 6 months; - **Contraception** essential during follow-up (avoid pregnancy 6 mo — confounds hCG); IUD acceptable per recent evidence; (6) **GTN diagnosis**: persistent hCG plateau or rise after evacuation, hCG > 20,000 4 wk post-evacuation, hCG > 6 months persistence, metastases, histology of choriocarcinoma; (7) **GTN treatment** (highly chemosensitive — excellent prognosis): - Low-risk (WHO score 0-6): methotrexate or actinomycin-D single agent; - High-risk (≥ 7): EMA-CO (etoposide + MTX + actinomycin + cyclophosphamide + vincristine) multi-agent; - Brain metastases: high-dose intrathecal MTX, RT consideration; (8) **Prognosis**: > 95% cure even metastatic; (9) **Multidisciplinary**: OB-GYN + GYN-oncology + medical oncology + pathology"},{"label":"C","text":"Hysterectomy first"},{"label":"D","text":"Refuse"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', 'GTD: spectrum from mole to GTN. D+C primary; hCG monitoring + contraception. GTN diagnosis criteria; methotrexate or EMA-CO treatment. > 95% cure even metastatic. Multidisciplinary. Modern: chemo highly curative.', NULL,
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
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี — Hodgkin lymphoma — lymph node biopsy + Reed-Sternberg cells + EBV positive — staging + treatment', '[{"label":"A","text":"Ignore"},{"label":"B","text":"Hodgkin Lymphoma Pathology + Management: (1) **Classic Hodgkin Lymphoma (CHL)**: Reed-Sternberg cells (large, multinucleated, mirror image — \"owl eye\") + lacunar variants; CD30+ CD15+ usually CD45-; B-cell origin; EBV association in some; (2) **Subtypes**: nodular sclerosis (most common), mixed cellularity, lymphocyte-rich, lymphocyte-depleted; (3) **Nodular Lymphocyte-Predominant HL (NLPHL)**: distinct entity — LP/popcorn cells, CD20+ CD45+; treated differently; (4) **Staging (Ann Arbor + Lugano)**: I-IV based on node + organ involvement; A/B symptoms; bulky disease; (5) **Workup**: PET-CT (functional + anatomic), bone marrow biopsy (selective), CBC, LDH, ESR, HIV; (6) **Treatment (excellent overall — 80-90% cure rate)**: - **Early-stage favorable**: ABVD × 2 cycles + 20 Gy IFRT; - **Early-stage unfavorable**: ABVD × 4 cycles + 30 Gy IFRT; - **Advanced (Stage III-IV)**: ABVD × 6 cycles; eBEACOPP for high-risk + poor PET2; brentuximab + AVD (A+AVD) alternative — ECHELON-1 trial; - **PET-adapted therapy**: deintensify if PET2 negative; (7) **Relapsed/refractory**: brentuximab vedotin (anti-CD30 ADC), checkpoint inhibitors (nivolumab, pembrolizumab — KEYNOTE), autologous HCT; (8) **Late effects**: secondary malignancy (breast, lung, etc.), cardiotoxicity (anthracycline + RT), fertility, thyroid, lung fibrosis, infertility; (9) **Survivorship care**: lifelong surveillance for late effects; (10) **Multidisciplinary**: heme-onc + pathology + radiation + cardiology + endocrinology + reproductive + survivorship; (11) **Excellent prognosis** even relapsed with modern therapies"},{"label":"C","text":"Surgery only"},{"label":"D","text":"Refuse"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', 'Hodgkin lymphoma: Reed-Sternberg cells, CD30/15. PET-adapted therapy. ABVD or A+AVD. Brentuximab + checkpoint inhibitors for relapse. Late effects significant. Multidisciplinary. Modern: high cure rates + reducing toxicity.', NULL,
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
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี — prostate biopsy — Gleason 4+3 = 7 (Grade Group 3) — pathology guides management', '[{"label":"A","text":"Ignore"},{"label":"B","text":"Prostate Cancer Pathology Grading: (1) **Gleason grading** (most validated cancer grading): primary + secondary pattern (1-5 each); modern Grade Group system (ISUP 2014): - GG 1: Gleason 3+3 = 6; - GG 2: Gleason 3+4 = 7; - GG 3: Gleason 4+3 = 7; - GG 4: Gleason 4+4 = 8; - GG 5: Gleason 9 or 10; (2) **Grade Group affects prognosis + treatment**; (3) **Other pathologic features**: percentage of involvement, perineural invasion, extraprostatic extension, seminal vesicle invasion, lymph node status; (4) **Risk stratification** (NCCN): - Very low: GG 1, PSA < 10, < 3 cores positive, < 50% in cores; - Low: GG 1, PSA < 10; - Intermediate (favorable vs unfavorable): GG 2-3; - High: GG 4-5 or T3a, PSA > 20; - Very high: T3b-4 or GG 5, etc.; (5) **Treatment based on risk + life expectancy**: - **Active surveillance**: GG 1, selected GG 2 (low-risk) — serial PSA + DRE + MRI + repeat biopsy; reduce overtreatment; - **Surgery (radical prostatectomy)**: open, lap, robotic; - **Radiation**: external beam (IMRT, SBRT, proton), brachytherapy (LDR, HDR); - **ADT (androgen deprivation therapy)**: GnRH agonist/antagonist + antiandrogen; - **Combination ADT + RT** for intermediate-high; - **Combination ADT + chemotherapy or novel hormonals** (abiraterone, enzalutamide, apalutamide) for high-risk + metastatic; (6) **Modern**: precision — genomic classifier (Oncotype, Polaris, Decipher) refines risk; (7) **Recurrent/metastatic**: salvage RT + ADT; novel hormonals (abiraterone, enzalutamide, apalutamide, darolutamide); PARP inhibitors (BRCA); PSMA radioligand therapy (Pluvicto Lu-177); chemotherapy (docetaxel, cabazitaxel); (8) **Multidisciplinary**: urology + radiation oncology + medical oncology + pathology + genetics + survivorship"},{"label":"C","text":"Surgery only"},{"label":"D","text":"Refuse"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', 'Prostate cancer: Gleason + Grade Group system. Risk stratification (NCCN). Treatment by risk + life expectancy (AS for low, surgery/radiation, ADT, novel hormonals, PARP, PSMA). Modern: genomic classifiers + targeted therapies + precision. Multidisciplinary.', NULL,
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
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 30 ปี — pleural effusion + lymph node biopsy — pathology: caseating granulomas — AFB stain positive — sputum mycobacterium culture pending', '[{"label":"A","text":"No treatment"},{"label":"B","text":"Granulomatous Disease Pathology Workup: (1) **Caseating granulomas with AFB+** = TB until proven otherwise; (2) **Differential of granulomatous disease**: - **Infections**: TB (caseating most common), atypical mycobacteria, fungal (histoplasmosis, blastomycosis, coccidioidomycosis, cryptococcosis), parasitic (toxoplasmosis), Brucella, leprosy, syphilis (rare); - **Non-infectious**: sarcoidosis (non-caseating), Crohn''s, granulomatous polyangiitis (GPA), Churg-Strauss, foreign body, drug-induced, primary biliary cholangitis, primary immunodeficiencies, hypersensitivity pneumonitis, berylliosis; (3) **Sarcoidosis** features: non-caseating, multisystem (lung most), young adults Black > White, ACE may be elevated, hilar lymphadenopathy on imaging, often spontaneous remission; (4) **Workup further**: histology + special stains (AFB, GMS for fungi, etc.), culture, NAAT, serologies (autoimmune, fungal), ACE, calcium, eye exam (sarcoid uveitis); (5) **TB treatment** if confirmed: standard regimen + DOT + isolation + contact tracing (already covered); (6) **Sarcoidosis treatment**: observation many spontaneously remit; corticosteroids for symptomatic (lung function, CNS, cardiac, eye, hypercalcemia, severe skin); methotrexate, azathioprine, biologics for refractory; (7) **Multidisciplinary**: pulmonology + ID + pathology + rheumatology + ophthalmology + cardiology if systemic"},{"label":"C","text":"Surgery"},{"label":"D","text":"Refuse"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', 'Granulomatous disease: caseating most often TB (AFB +); non-caseating includes sarcoid + others. Workup with stains + culture + NAAT + serology. Treatment by underlying. Multidisciplinary. Modern: precision diagnostics + targeted therapy.', NULL,
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
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี — surgery for colon cancer — pathology: invasive adenocarcinoma + MMR/MSI testing — needed for treatment + family screening', '[{"label":"A","text":"Ignore molecular"},{"label":"B","text":"Molecular Pathology in Cancer (precision medicine — colon cancer example): (1) **Microsatellite instability (MSI) / Mismatch Repair (MMR) testing**: - MSI-H or MMR-deficient (dMMR) — hypermutated phenotype; - MMR proteins: MLH1, MSH2, MSH6, PMS2 IHC; loss of expression = dMMR; - MSI testing by PCR alternative; - **Implications**: better prognosis stage II (no chemo benefit), worse stage IV unless immunotherapy; **PEMBROLIZUMAB or NIVOLUMAB** highly effective in MSI-H/dMMR tumors (KEYNOTE-177 — pembro better than chemo first-line metastatic dMMR); - **Lynch syndrome screening**: MSH/MSH2/MSH6/PMS2 germline mutations — autosomal dominant; family screening; risk-reducing strategies; (2) **RAS testing** (KRAS, NRAS): mutations predict resistance to anti-EGFR (cetuximab, panitumumab) — only RAS wild-type benefit; (3) **BRAF testing** (V600E): poor prognosis; targeted therapy (encorafenib + cetuximab — BEACON trial); (4) **HER2 testing**: amplification — trastuzumab + tucatinib (mountaineer trial); (5) **NTRK fusions** (rare): larotrectinib, entrectinib (tumor agnostic); (6) **Tumor mutational burden (TMB)**: high TMB — checkpoint inhibitor benefit; (7) **Liquid biopsy** (ctDNA): MRD monitoring, treatment response, recurrence detection; (8) **Hereditary cancer testing + counseling**: Lynch, FAP, MUTYH-associated polyposis, Peutz-Jeghers; family implications; (9) **Multidisciplinary tumor board**: pathology + medical oncology + genetics + surgery; (10) **Modern**: precision oncology + biomarker-driven + immunotherapy + tumor-agnostic therapies"},{"label":"C","text":"Random treatment"},{"label":"D","text":"Refuse"},{"label":"E","text":"No testing"}]'::jsonb,
  'B', 'Molecular pathology: MSI/MMR + RAS + BRAF + HER2 + NTRK + TMB testing — precision oncology. KEYNOTE-177 — pembrolizumab better than chemo for dMMR. Lynch screening implications. Liquid biopsy emerging. Multidisciplinary. Modern: biomarker-driven precision medicine.', NULL,
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
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี — proteinuria + edema + renal biopsy: thickened glomerular basement membranes + IgG + C3 immunofluorescence + ''spike'' pattern on EM — membranous nephropathy', '[{"label":"A","text":"Random"},{"label":"B","text":"Renal Pathology — Membranous Nephropathy + Glomerular Diseases: (1) **Membranous nephropathy (MN)**: subepithelial immune complex deposits → thickening of GBM (basement membrane); ''spike + dome'' on EM; IgG + C3 IF; (2) **PLA2R antibody** (anti-phospholipase A2 receptor): primary (idiopathic) MN — 70-80% positive; serologic marker, helpful for diagnosis + monitoring; (3) **Secondary MN causes**: malignancy (especially solid tumors > 65), hepatitis B/C, autoimmune (SLE), drugs (NSAIDs, gold, penicillamine), infections — workup if PLA2R negative or atypical; (4) **Treatment** (KDIGO 2021): - Risk stratification by proteinuria + GFR + autoantibody; - Low-risk: supportive (ACEi/ARB, salt restriction, lipid, anticoagulation if severe proteinuria); 30% spontaneous remission; - High-risk: immunosuppression (rituximab, cyclophosphamide + steroid alternating Ponticelli, calcineurin inhibitors); rituximab increasingly first-line — MENTOR trial; (5) **Other primary glomerular diseases**: - **Minimal Change Disease**: foot process effacement on EM; treatment steroids — children + adults; - **FSGS**: focal segmental scarring; classic vs secondary causes (HIV, obesity, reflux); steroids + CNIs; - **IgA Nephropathy**: most common GN globally; IgA mesangial deposits; - **MPGN/C3 glomerulopathy**: low C3, complement pathway abnormalities; - **Lupus Nephritis**: 6 classes per ISN/RPS; immunosuppression for class III/IV; (6) **Nephritic vs nephrotic syndrome** classification; (7) **Multidisciplinary**: nephrology + pathology + rheumatology"},{"label":"C","text":"Surgery"},{"label":"D","text":"Refuse"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', 'Renal pathology: membranous nephropathy (PLA2R Ab marker), classes of glomerular disease (minimal change, FSGS, IgA, lupus, MPGN). KDIGO 2021 risk-based Rx. Rituximab MENTOR. Multidisciplinary care.', NULL,
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
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี — thyroid nodule biopsy — papillary thyroid carcinoma classical variant + BRAF V600E mutation', '[{"label":"A","text":"Ignore"},{"label":"B","text":"Thyroid Cancer Pathology + Management: (1) **Differentiated Thyroid Cancer (DTC)**: papillary (most common 80%), follicular (10-15%), Hürthle cell variant; oncocytic features; (2) **Papillary features**: papillae + clear nuclei (Orphan Annie) + nuclear grooves + pseudoinclusions; (3) **Variants of PTC**: classical, follicular variant (more indolent), tall cell (aggressive), columnar cell (aggressive), hobnail (aggressive), diffuse sclerosing (peds); (4) **Molecular**: BRAF V600E (most common, ~ 50%), RET/PTC rearrangements, RAS mutations, TERT promoter mutations (worse prognosis); (5) **Other thyroid cancers**: medullary (C-cell origin, calcitonin elevated, RET mutations — MEN2), anaplastic (highly aggressive — mortality > 90%, BRAF + others), lymphoma (rare); (6) **Risk stratification (ATA)**: low (small intrathyroidal, no nodes), intermediate (vascular invasion, microscopic ETE, small nodes), high (gross ETE, distant metastases, large nodes, aggressive variants); (7) **Treatment**: - Total thyroidectomy vs lobectomy based on size + risk; - Lymph node dissection (central, lateral) per evidence; - RAI (radioactive iodine) ablation based on risk; - TSH suppression with levothyroxine; - Surveillance: TSH + Tg + neck US; (8) **Targeted therapy** for advanced/refractory: - RAI-refractory: lenvatinib, sorafenib (multikinase TKIs); - **BRAF V600E**: dabrafenib + trametinib (selected); - RET fusion/mutation: selpercatinib, pralsetinib; - NTRK fusions: larotrectinib, entrectinib; (9) **Genetic counseling**: MEN2 for medullary; (10) **Multidisciplinary**: thyroid surgery + endocrinology + nuclear medicine + medical oncology + pathology"},{"label":"C","text":"Surgery only"},{"label":"D","text":"Refuse"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', 'Thyroid cancer pathology: differentiated (papillary majority) + variants + medullary + anaplastic. Molecular (BRAF, RAS, RET, TERT). ATA risk stratification. Treatment by risk. Targeted therapy for advanced (TKIs, BRAF + MEK, RET inhibitors). Multidisciplinary care.', NULL,
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
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี smoker — lung biopsy: non-small cell lung cancer adenocarcinoma + molecular: EGFR exon 19 deletion + PD-L1 75%', '[{"label":"A","text":"Random treatment"},{"label":"B","text":"NSCLC Pathology + Precision Therapy: (1) **NSCLC types**: adenocarcinoma (most common, peripheral, often non-smokers), squamous cell (central, smokers), large cell, NSCLC NOS; (2) **vs SCLC** (small cell — aggressive, neuroendocrine, smoker, central, paraneoplastic); (3) **Biomarker testing essential** for NSCLC adenocarcinoma (NCCN required for advanced): - **EGFR mutations** (exon 19 del, L858R most common, T790M resistance) — osimertinib first-line; - **ALK rearrangements** — alectinib, lorlatinib first-line; - **ROS1 rearrangements** — crizotinib, entrectinib; - **BRAF V600E** — dabrafenib + trametinib; - **KRAS G12C** — sotorasib, adagrasib; - **MET exon 14 skipping** — capmatinib, tepotinib; - **RET fusion** — selpercatinib, pralsetinib; - **NTRK fusion** — larotrectinib, entrectinib; - **HER2 mutations** — T-DXd, trastuzumab; (4) **PD-L1 testing** (TPS — tumor proportion score): immunotherapy decisions; PD-L1 ≥ 50% — pembrolizumab monotherapy first-line; < 50% — combination chemo + immunotherapy; (5) **Staging**: TNM + AJCC 8th edition; PET-CT + brain MRI + biopsy; (6) **Treatment based on stage + biomarker**: - Early (I-II): surgery + adjuvant chemo + osimertinib (EGFR+); - Locally advanced (III): chemoradiation + durvalumab consolidation (PACIFIC); - Metastatic (IV): targeted therapy if driver, immunotherapy if no driver + PD-L1+; (7) **SCLC**: chemo (platinum + etoposide) + atezolizumab/durvalumab + thoracic RT for limited; PCI; (8) **Multidisciplinary tumor board**: pathology + medical oncology + thoracic surgery + radiation oncology + pulmonology + IR + palliative; (9) **Modern**: precision oncology revolutionizing lung cancer — many patients live years with targeted therapy"},{"label":"C","text":"Surgery only"},{"label":"D","text":"Refuse"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', 'NSCLC: precision oncology — multiple actionable drivers (EGFR, ALK, ROS1, KRAS G12C, BRAF, MET, RET, NTRK, HER2). PD-L1 testing. Targeted therapy for drivers + immunotherapy for non-drivers. Stage-based treatment. Multidisciplinary. Modern: dramatic outcome improvements.', NULL,
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
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 30 ปี — pigmented skin lesion biopsy: melanoma + Breslow thickness 2.5mm + ulceration + mitotic rate elevated', '[{"label":"A","text":"Ignore"},{"label":"B","text":"Melanoma Pathology + Staging + Management: (1) **Histology**: atypical melanocytes, asymmetric, pagetoid spread; Breslow thickness — most important prognostic factor; ulceration adverse; mitotic rate; lymphovascular invasion; perineural; satellite/in-transit; (2) **TNM (AJCC 8th)**: - T by thickness + ulceration; - N by nodes + microsatellite/in-transit; - M includes serum LDH; - Stage 0 (in situ) — IV; (3) **Sentinel lymph node biopsy (SLNB)**: standard for T1b+ (≥ 0.8mm or any with ulceration) — staging + prognosis; (4) **Molecular**: BRAF V600 most common (50%), NRAS, KIT (acral, mucosal), GNAQ/GNA11 (uveal); (5) **Treatment**: - Wide local excision (margins based on thickness — 5mm in situ, 1cm for ≤ 1mm, 1-2cm for 1.01-2mm, 2cm for > 2mm); - SLNB for T1b+; - Completion lymph node dissection — limited indication post-MSLT-II (observation acceptable); - Adjuvant immunotherapy (nivolumab, pembrolizumab) for Stage IIB-IV; targeted (dabrafenib + trametinib) for BRAF+ Stage III; (6) **Metastatic treatment**: - **Immunotherapy**: PD-1 inhibitor (nivo, pembro) +/- CTLA-4 (ipi); RELATIVITY-047 — nivolumab + relatlimab; - **Targeted** (BRAF+): dabrafenib + trametinib, encorafenib + binimetinib; - **TIL therapy** (tumor-infiltrating lymphocytes) — FDA approved 2024 (lifileucel); - Combination + sequential; (7) **Brain mets**: SRS + immunotherapy effective; (8) **Long-term**: surveillance for recurrence + new primaries; (9) **Sun protection + skin checks** lifelong; (10) **Multidisciplinary**: dermatology + surgical oncology + medical oncology + radiation + pathology + genetics"},{"label":"C","text":"Surgery only"},{"label":"D","text":"Refuse"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', 'Melanoma: Breslow thickness key + ulceration + mitoses. SLNB for T1b+. Molecular (BRAF, NRAS). Treatment: wide excision + immunotherapy + targeted + TIL. Adjuvant for advanced. Modern: dramatic outcomes with immunotherapy + targeted. Multidisciplinary.', NULL,
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
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี — bone pain + anemia + renal failure — bone marrow biopsy: plasma cells > 20% + serum protein electrophoresis: M-spike + BJ proteinuria — multiple myeloma', '[{"label":"A","text":"Random"},{"label":"B","text":"Multiple Myeloma Pathology + Diagnosis: (1) **CRAB criteria** (organ damage): hyperCalcemia, Renal failure, Anemia, Bone lesions; or biomarkers (plasma cells ≥ 60%, FLC ratio ≥ 100, MRI ≥ 1 focal lesion); (2) **IMWG criteria 2014**: bone marrow plasma cells ≥ 10% + monoclonal protein + CRAB or biomarkers; (3) **Diagnostic workup**: SPEP/UPEP (M-spike), immunofixation, serum FLC, BMBx + cytogenetics + FISH, skeletal survey or whole-body low-dose CT/MRI/PET-CT, CBC, Cr, Ca, beta-2 microglobulin, albumin, LDH; (4) **Risk stratification (R-ISS)**: cytogenetics (del 17p, t(4;14), t(14;16), 1q gain — poor) + beta-2 microglobulin + albumin + LDH; (5) **Pathology**: plasma cell infiltration; flame cells, Russell bodies; flow cytometry for clonal (κ/λ restriction); (6) **Treatment** (NCCN + IMWG): - **Triplet/quadruplet induction** then transplant: VRD (bortezomib + lenalidomide + dex), KRD (carfilzomib + len + dex), DARA-VRD or DARA-RVd quad (DETERMINATION/GRIFFIN — daratumumab + RVd improves PFS); - **Autologous HCT** for eligible (age + comorbidity); - Consolidation + maintenance (lenalidomide); - **Newer agents**: CD38 (daratumumab, isatuximab), bispecific (teclistamab, talquetamab), BCMA CAR-T (ide-cel, cilta-cel — revolutionary), selinexor; (6) **Smoldering MM**: monitoring vs early treatment for high-risk (PETHEMA, ECOG E3A06); (7) **Bone health**: bisphosphonate + denosumab; vertebroplasty/kyphoplasty for compression fractures; RT for pain; (8) **Renal failure**: hyperhydration, bortezomib (less nephrotoxic), avoid nephrotoxins; (9) **Supportive care**: prophylactic antibiotics, antifungal, antiviral, IVIG selected, vaccinations, hyperCa management, anemia (EPO); (10) **Long-term**: chronic disease with multiple lines of therapy; modern: median survival > 8-10 years"},{"label":"C","text":"Surgery"},{"label":"D","text":"Refuse"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', 'Multiple myeloma: CRAB + IMWG criteria + monoclonal protein. Risk stratification (R-ISS). Triplet/quadruplet induction + transplant + maintenance. Modern: CD38 mAb + bispecifics + BCMA CAR-T revolutionary. Median survival 8-10+ years. Multidisciplinary.', NULL,
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
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี — lymphadenopathy + lymph node biopsy: small lymphocytes + flow cytometry CD5+ CD19+ CD23+ — CLL', '[{"label":"A","text":"Ignore"},{"label":"B","text":"CLL Pathology + Management: (1) **CLL diagnosis**: lymphocytosis (> 5,000 monoclonal B cells), classic immunophenotype CD5+ CD19+ CD23+ surface Ig dim, ROR1+, light chain restricted; (2) **vs SLL**: lymph nodes prominent vs marrow + blood; (3) **Smudge cells** on peripheral smear; (4) **Workup**: CBC + smear, BMBx selected, lymph node biopsy if atypical, flow cytometry, FISH for chromosomal (del 17p, 11q, 13q, trisomy 12), IGHV mutation status, TP53; (5) **Staging**: Rai (0-IV) or Binet (A-C); (6) **Prognosis**: - Good: IGHV mutated, isolated 13q, low ZAP-70 + CD38; - Poor: IGHV unmutated, del 17p/TP53 mutation, complex karyotype; (7) **Treatment** indicated for symptomatic, advanced stage, cytopenias, B symptoms: - **Targeted therapy first-line revolutionized care**: - **BTK inhibitors**: ibrutinib (1st gen), acalabrutinib + zanubrutinib (2nd gen — less cardiac); - **Venetoclax** (BCL-2 inhibitor) + anti-CD20 (obinutuzumab) — fixed duration; - **Combination** ibrutinib + venetoclax (selected); - **Chemoimmunotherapy** (FCR — fludarabine + cyclophosphamide + rituximab) less used now, selected IGHV mutated younger; (8) **Richter transformation**: aggressive DLBCL — rare but devastating; (9) **Infections**: high risk (hypogammaglobulinemia + immunodeficiency) — vaccines + antibiotic prophylaxis selected; (10) **Vaccinations**: avoid live; pneumo + flu + COVID + shingles (Shingrix); IVIG for recurrent infections + low IgG; (11) **Multidisciplinary**: heme-onc + pathology + ID + transplant for refractory + secondary malignancy surveillance"},{"label":"C","text":"Surgery"},{"label":"D","text":"Refuse"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', 'CLL: CD5+ CD19+ CD23+ classic. Risk by IGHV + cytogenetics. Modern treatment: BTK inhibitors + venetoclax — targeted, fixed duration + improved outcomes. Chemoimmunotherapy less. Infection risk + supportive. Multidisciplinary. Modern: precision + chronic disease management.', NULL,
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
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 35 ปี — HIV positive newly diagnosed — CD4 250 + viral load 80,000', '[{"label":"A","text":"Refuse care"},{"label":"B","text":"HIV Diagnosis + Antiretroviral Therapy: (1) **Diagnosis**: 4th gen Ag/Ab combination test; confirmation HIV-1/2 antibody differentiation; viral load (HIV RNA); CD4 count; (2) **Baseline workup**: CBC, CMP, LFT, lipid panel, HbA1c, urinalysis, hepatitis A/B/C, syphilis, gonorrhea/chlamydia, TB (IGRA or PPD), pregnancy test, HLA-B*5701 if considering abacavir; (3) **ART recommended for all HIV+ regardless of CD4** (START trial 2015); (4) **First-line regimens (DHHS + IAS-USA)**: - **Integrase inhibitor (INSTI) based**: - Bictegravir/TAF/FTC (Biktarvy) — single pill, well-tolerated, no resistance to first-line; - Dolutegravir + (TAF/FTC or TDF/FTC) — Tivicay + Truvada/Descovy; - Dolutegravir + lamivudine (Dovato) — 2-drug regimen; (5) **Adherence + resistance testing baseline + on failure**: HIV-1 genotype baseline; (6) **Long-acting injectable**: cabotegravir + rilpivirine (Cabenuva) monthly or 2-monthly; (7) **PrEP for partners + at-risk**: TDF/FTC (Truvada), TAF/FTC (Descovy), cabotegravir LA (Apretude) — important prevention; (8) **Opportunistic infection prevention based on CD4**: PJP + Toxo prophylaxis (Bactrim) when CD4 < 200, MAC (azithromycin weekly) when CD4 < 50; (9) **Vaccinations**: hep A/B, flu, COVID, pneumo, Tdap, HPV, MMR + varicella if CD4 > 200 (live), shingles; (10) **Cancer screening**: anal Pap MSM, cervical women, hepatocellular if HBV/HCV; (11) **Mental health screening + support**: stigma, disclosure, partner notification; (12) **Multidisciplinary**: HIV specialist + primary care + pharmacy + mental health + social work + community"},{"label":"C","text":"Surgery"},{"label":"D","text":"Discharge"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', 'HIV: 4th gen diagnosis + viral load + CD4. ART for all. INSTI-based first-line (bictegravir, dolutegravir). 2-drug regimens. Long-acting injectables. PrEP. OI prophylaxis by CD4. Vaccinations. Multidisciplinary. Modern: chronic disease with normal life expectancy.', NULL,
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
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 25 ปี — easy bruising + heavy menstruation + family history bleeding — Coagulation workup: PT normal, aPTT prolonged, vWF antigen + activity reduced', '[{"label":"A","text":"Random"},{"label":"B","text":"Bleeding Disorders Pathology + Workup: (1) **Initial workup**: CBC + smear + PT + aPTT + fibrinogen + bleeding history (ISTH-BAT score); (2) **Pattern of bleeding**: mucocutaneous (vWD, platelet) vs deep soft tissue/joints (factor deficiency); (3) **Common bleeding disorders**: - **Von Willebrand Disease (vWD)**: most common inherited; autosomal dominant most; types 1 (partial deficiency), 2 (qualitative — subtypes 2A, 2B, 2M, 2N), 3 (severe absence); vWF antigen + activity (ristocetin cofactor) + factor VIII + multimer analysis; - **Hemophilia A** (factor VIII deficiency) + **B** (factor IX) — X-linked; deep tissue + joint bleeding; severity by factor level; - **Platelet disorders**: function (Glanzmann, Bernard-Soulier) or number (ITP, TTP, DIC); - **Acquired**: liver disease (multiple factors), warfarin/DOACs, vitamin K deficiency, DIC, ITP, vWD acquired (heart valves, hypothyroidism); (4) **vWD management**: - Desmopressin (DDAVP) for type 1 + some type 2; tachyphylaxis with repeated doses; - vWF concentrate or factor VIII/vWF combination products; - Antifibrinolytics (TXA) for mucosal bleeding + menorrhagia; - Hormonal therapy for menorrhagia; (5) **Hemophilia management**: factor concentrates (recombinant — preferred); emicizumab (FVIII mimetic — Hemlibra) for hemophilia A — revolutionary; gene therapy emerging; (6) **Specialized care center**: hemophilia treatment center improves outcomes; (7) **Multidisciplinary**: hematology + transfusion medicine + dental + obstetrics + orthopedics + genetic counseling + physical therapy"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', 'Bleeding disorders: vWD most common inherited; hemophilia A/B X-linked; platelet disorders; acquired. Workup: PT + aPTT + factor levels + specific tests. vWD: DDAVP, vWF concentrate, TXA. Hemophilia: factor concentrate, emicizumab revolutionary, gene therapy. Multidisciplinary specialized care.', NULL,
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
  s.id, 'board', NULL, 'ผู้ป่วยรับ blood transfusion + reaction: chills + fever + back pain + dark urine + hypotension + DIC features during transfusion', '[{"label":"A","text":"Continue transfusion"},{"label":"B","text":"Acute Hemolytic Transfusion Reaction (AHTR) — Anti-A/B IgM mediated severe: (1) **STOP transfusion immediately** + maintain IV access; (2) **Send blood bag + tubing + samples** to blood bank for investigation: clerical check (ABO compatibility), repeat ABO + crossmatch on patient + bag, direct antiglobulin test (DAT), bilirubin, haptoglobin, LDH, urinalysis (hemoglobinuria), CBC, coagulation (DIC); (3) **Supportive treatment**: - IV fluids aggressive (maintain UO > 1 mL/kg/hr — prevent AKI from hemoglobinuria); - Vasopressors if hypotension; - Treat DIC (FFP, cryoprecipitate, platelets); - Furosemide for oliguria + volume overload; - Bicarbonate to alkalinize urine (hemoglobinuria); - Monitor renal function, electrolytes, coagulation; - Possibly hemodialysis if AKI severe; (4) **Differential transfusion reactions**: - **AHTR**: ABO incompatibility (often clerical error) — most serious; - **Delayed HTR**: extravascular hemolysis days later; - **Febrile non-hemolytic (FNHTR)**: cytokines; common, less serious; - **Allergic (urticaria)**: minor; antihistamine; - **Anaphylactic** (IgA deficiency with anti-IgA): severe — epinephrine; washed RBCs; - **TRALI (transfusion-related acute lung injury)**: ARDS-like, donor antibodies; - **TACO (transfusion-associated circulatory overload)**: volume overload; - **Septic**: bacterial contamination — antibiotics + supportive; (5) **Reporting + investigation**: transfusion service notification, FDA reporting if severe; (6) **Prevention**: positive patient identification, double-checking, transfusion-safe protocols, leukoreduction, irradiation for at-risk patients; (7) **Multidisciplinary**: transfusion medicine + pathology + intensivist + nephrology"},{"label":"C","text":"Refuse"},{"label":"D","text":"Discharge"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', 'Transfusion reactions: AHTR most serious (ABO incompatibility, often clerical error). Stop transfusion + investigation + supportive (fluids, vasopressor, DIC treatment, AKI prevention). Multiple reaction types — differential. Prevention: patient ID + safety protocols. Reporting + investigation. Multidisciplinary.', NULL,
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
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี — chronic diarrhea + recent weight loss — duodenal biopsy: villous blunting + intraepithelial lymphocytes + crypt hyperplasia — celiac workup', '[{"label":"A","text":"Random"},{"label":"B","text":"Celiac Disease Pathology + Diagnosis: (1) **Histology**: Marsh classification - Marsh 0: normal; - 1: IELs > 25/100 enterocytes; - 2: + crypt hyperplasia; - 3a/b/c: villous atrophy (partial/subtotal/total); (2) **Diagnostic workup**: - **Serology**: TTG IgA (tissue transglutaminase) preferred — high sensitivity + specificity; total IgA (rule out IgA deficiency — common in celiac); DGP IgG (deamidated gliadin peptide) if IgA deficient; EMA (endomysial antibody) — confirmatory; - **Duodenal biopsy** ≥ 4 from descending duodenum + 2 from bulb during EGD — gold standard while on gluten-containing diet; - HLA-DQ2/DQ8 — negative virtually rules out (high negative predictive value); positive non-specific (40% population); (3) **Maintain gluten in diet during workup** (false negatives if gluten-free); (4) **Management**: lifelong gluten-free diet (GFD) — strict (cross-contamination matters); registered dietitian; (5) **Monitoring**: TTG normalization (6-12 mo on GFD), symptom resolution, repeat biopsy in some; bone density (osteoporosis common); micronutrients (iron, B12, folate, vitamin D); (6) **Complications + associated**: malabsorption + nutritional deficiencies, osteoporosis, infertility, dermatitis herpetiformis, neurological (ataxia, neuropathy), liver, refractory celiac (4-15%), enteropathy-associated T-cell lymphoma (EATL — small risk increase); (7) **Associated conditions**: T1DM, autoimmune thyroid, IgA deficiency, Down syndrome, Turner syndrome, Williams syndrome; (8) **Refractory celiac**: types I + II — corticosteroids, immunosuppressants; lymphoma surveillance; (9) **Family screening**: first-degree relatives — increased risk; (10) **Multidisciplinary**: GI + nutrition + endocrinology if associated"},{"label":"C","text":"Surgery"},{"label":"D","text":"Refuse"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', 'Celiac: serology (TTG IgA) + duodenal biopsy (Marsh) while on gluten. HLA helpful. Lifelong GFD. Complications + monitoring. Family screening. Refractory rare. Multidisciplinary care. Modern: precision + comprehensive.', NULL,
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
  s.id, 'board', NULL, 'Resident ถามเรื่อง pathology techniques + IHC + molecular methods', '[{"label":"A","text":"Random"},{"label":"B","text":"Pathology Techniques: (1) **Histopathology**: H+E staining standard; special stains (PAS — glycogen + fungi; Gomori — fungi; AFB — mycobacteria; Congo red — amyloid; trichrome — collagen; iron — Perls; Alcian blue — mucin); fresh-frozen + permanent sections; (2) **Immunohistochemistry (IHC)**: antibody-based — specific antigen detection; markers (e.g., cytokeratin — epithelial, CD45 — lymphoid, S100 — melanocytic/neural, vimentin — mesenchymal, chromogranin/synaptophysin — neuroendocrine, TTF1 — lung adenocarcinoma + thyroid, GATA3 — breast + urothelial); (3) **Molecular pathology**: - **PCR + qPCR**: amplification; HIV viral load, BCR-ABL CML, fusion detection; - **FISH (fluorescence in situ hybridization)**: chromosomal + gene rearrangements, HER2 amplification; - **NGS (next-generation sequencing)**: targeted panels, whole exome, whole genome; tumor profiling; resistance testing; - **MSI/MMR**: PCR or IHC; - **Liquid biopsy / ctDNA**: circulating tumor DNA, MRD, treatment response; (4) **Flow cytometry**: hematologic malignancy diagnosis, immunophenotyping; (5) **Cytology**: FNA, Pap, body fluids — minimally invasive; (6) **Digital pathology + AI**: whole-slide imaging, AI assistance — emerging; reduces interobserver variability; (7) **Tumor banking + research**; (8) **Quality**: CLIA + CAP accreditation, proficiency testing, validation, controls; (9) **Multidisciplinary**: pathologist + clinician + IT + research; (10) **Modern**: integrated diagnostics + precision medicine + AI-augmented"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"No techniques"}]'::jsonb,
  'B', 'Pathology techniques: H+E + special stains, IHC, molecular (PCR, FISH, NGS, MSI), flow, cytology, digital pathology + AI. Quality + validation. Modern: integrated diagnostics + precision + AI.', NULL,
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
  s.id, 'board', NULL, 'Resident ถามเรื่อง laboratory medicine + reference ranges + interpretation', '[{"label":"A","text":"Random"},{"label":"B","text":"Laboratory Medicine Principles: (1) **Reference intervals**: 2.5-97.5% of healthy population; age, sex, ethnicity, time of day, posture, exercise affect; (2) **Sensitivity + specificity + PPV/NPV**: test characteristics + prevalence-dependent; (3) **Critical values + delta checks + autoverification**; (4) **Common tests + interpretation**: - **CBC + differential**: anemia (microcytic/normocytic/macrocytic), leukocytosis pattern (neutrophilia, lymphocytosis, eosinophilia), thrombocytopenia/cytosis; - **Chemistry**: electrolytes (Na, K, Cl, HCO3, Ca, Mg, phos), renal (BUN, Cr, eGFR), glucose, LFT (AST, ALT, ALP, GGT, bili, albumin, total protein); - **Cardiac**: troponin (high-sensitivity), BNP/NT-proBNP, CK-MB; - **Coagulation**: PT/INR, aPTT, fibrinogen, D-dimer; - **Endocrine**: TSH, free T4, cortisol, ACTH, calcium, PTH, vitamin D, HbA1c; - **Lipid panel**; - **Iron studies**: ferritin, iron, TIBC, transferrin saturation; - **Vitamin levels**: B12, folate, D; - **Inflammatory**: ESR, CRP, ferritin; (5) **Specific test selection by clinical question**: avoid shotgun testing; targeted; (6) **Pre-analytical errors**: collection, transport, storage, hemolysis, lipemia, jaundice; (7) **Point-of-care testing**: rapid bedside; (8) **Quality**: internal QC + external proficiency; (9) **Reflex testing**: e.g., positive HIV → confirmation; (10) **AI + decision support**: automated interpretation, alerts"},{"label":"C","text":"Random"},{"label":"D","text":"Single test"},{"label":"E","text":"No interpretation"}]'::jsonb,
  'B', 'Laboratory medicine: reference intervals + test characteristics + appropriate selection + interpretation + quality. Multiple disciplines tests. Pre-analytical errors. POC testing. Modern: targeted + reflex + AI-supported.', NULL,
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
  s.id, 'board', NULL, 'Resident ถามเรื่อง autopsy + forensic + post-mortem', '[{"label":"A","text":"Random"},{"label":"B","text":"Autopsy + Forensic Pathology: (1) **Autopsy types**: clinical/hospital (consent-based, quality + education), forensic/medical examiner (statutory — suspicious, sudden, accidental, violent, in-custody deaths); (2) **Hospital autopsy benefits**: education, quality improvement, family closure, public health; declining utilization concern; (3) **Forensic autopsy**: examines cause + manner of death (natural, accident, homicide, suicide, undetermined); chain of evidence; toxicology; trauma; (4) **External examination**: documentation, photographs, evidence collection (clothing, fingernails, bite marks, foreign bodies, GSR — gunshot residue, sexual assault kits); (5) **Internal examination**: comprehensive — head, neck, thorax, abdomen, pelvis; organ-by-organ; (6) **Toxicology**: blood, urine, vitreous, gastric, hair, drugs of abuse, alcohol, prescription, illicit; (7) **Histology**: microscopic — confirms gross findings, identifies pathology not visible grossly; (8) **Adjunct studies**: imaging (postmortem CT/MRI), genetics, microbiology, chemistry; (9) **Death certificate**: cause (immediate, intermediate, underlying) + manner; accuracy important for public health statistics; (10) **Multidisciplinary**: pathology + medical examiner + law enforcement + clinical + family; (11) **Specialized autopsies**: pediatric (SIDS workup), athletic + sudden cardiac death (cardiomyopathy, channelopathy genetics), occupational; (12) **Mass casualty + disaster**: forensic anthropology, dental, DNA identification; (13) **Modern**: minimally invasive autopsy (postmortem imaging + targeted biopsy), genetic post-mortem testing"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"No examination"}]'::jsonb,
  'B', 'Autopsy + forensic: clinical vs forensic. Determine cause + manner of death. External + internal + toxicology + histology + adjuncts. Death certificate accuracy. Multidisciplinary. Modern: minimally invasive + genetic + technology-assisted.', NULL,
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
  s.id, 'board', NULL, 'Resident ถามเรื่อง biomarkers + companion diagnostics', '[{"label":"A","text":"Random"},{"label":"B","text":"Biomarkers + Companion Diagnostics: (1) **Biomarker types**: diagnostic (HCG for pregnancy, hCG + AFP for germ cell), prognostic (stage, grade), predictive (HER2 for trastuzumab response), monitoring (PSA recurrence, CA 19-9 pancreatic Ca); (2) **Companion diagnostics**: FDA-approved tests required to identify patients who will benefit from specific therapies; (3) **Cancer biomarkers**: - **HER2** for trastuzumab in breast/gastric Ca; - **BRCA1/2** for PARP inhibitors (olaparib) — breast, ovarian, prostate, pancreatic; - **EGFR + ALK + ROS1** for lung cancer TKIs; - **BRAF V600E** for vemurafenib/dabrafenib in melanoma + NSCLC + thyroid; - **MSI-H/dMMR** for pembrolizumab + immunotherapy; - **PD-L1** for immunotherapy; - **PSMA** for radioligand therapy + PSMA PET; - **KRAS G12C** for sotorasib in NSCLC; (4) **Pharmacogenomics**: - HLA-B*5701 for abacavir hypersensitivity; - DPYD for fluoropyrimidine toxicity; - UGT1A1 for irinotecan; - CYP2D6 for codeine metabolism (slow + ultra-rapid); - CYP2C19 for clopidogrel; - TPMT for thiopurines; (5) **Cardiac markers**: troponin (high-sensitivity), BNP/NT-proBNP, ST2; (6) **Liquid biopsy + ctDNA**: minimal residual disease (MRD), early diagnosis, treatment response, recurrence; (7) **Quality + validation**: analytical + clinical performance; (8) **Multidisciplinary**: pathology + clinical + clinical lab + bioinformatics + IT"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"No use"}]'::jsonb,
  'B', 'Biomarkers + companion diagnostics: precision medicine. Multiple cancer biomarkers driving treatment. Pharmacogenomics for safety + efficacy. Liquid biopsy + ctDNA. Modern: precision medicine increasingly biomarker-driven.', NULL,
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
  s.id, 'board', NULL, 'Hospital implements digital pathology + AI + quality improvement in lab medicine', '[{"label":"A","text":"Traditional only"},{"label":"B","text":"Digital Pathology + AI Integration: (1) **Whole-slide imaging (WSI)**: digitize entire glass slides; high resolution; remote viewing + sharing; teleconsultation; (2) **AI applications**: - Cancer detection (lung nodules, breast, prostate, melanoma, GI); - Grading + quantification (Gleason, Ki-67, Her2 IHC, tumor cellularity); - Biomarker prediction from H+E (e.g., MSI status from histology); - Workflow optimization + triage; - Quality control + double reading; (3) **FDA-approved AI in pathology growing** (Paige, PathAI, etc.); (4) **Benefits**: improved accuracy + consistency, productivity, remote work, education, research; (5) **Limitations + concerns**: validation, generalization across populations, bias, integration, regulatory, liability, training, ethics; (6) **Quality + safety improvements**: - Standardized reporting (synoptic reports); - Peer review + double reads for selected; - Critical results communication standards; - Diagnostic concordance audits; - Continuous education; (7) **Lab medicine quality**: CLIA + CAP accreditation, proficiency testing, internal QC, external QA; (8) **Patient safety**: specimen identification (positive ID), labeling, tracking; (9) **Equity**: ensure benefits across populations + reduce disparities; (10) **Multidisciplinary**: pathology + IT + administration + clinical + research; (11) **Modern**: digital + AI transforming pathology workflow + capabilities"},{"label":"C","text":"Random"},{"label":"D","text":"Avoid technology"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', 'Digital pathology + AI: whole-slide imaging + AI applications. FDA-approved tools growing. Quality + accuracy improvements. Limitations + ethics. CLIA + CAP quality. Multidisciplinary. Modern: digital + AI transforming pathology.', NULL,
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
  s.id, 'board', NULL, 'Hospital implements precision medicine program + tumor board + multidisciplinary integration', '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Precision Medicine Program: (1) **Molecular tumor board (MTB)**: multidisciplinary — pathology + medical oncology + surgical oncology + radiation + radiology + clinical genetics + bioinformatics + pharmacy + research; (2) **Workflow**: tissue procurement + adequate quality + comprehensive molecular profiling (NGS panel, IHC, FISH) → interpretation → treatment recommendation → clinical trial matching; (3) **Cancer Genomics**: actionable mutations identification, targeted therapy selection, clinical trial eligibility, off-label use, expanded access; (4) **Hereditary cancer genetics**: germline testing + counseling + family screening; (5) **Liquid biopsy**: minimal residual disease (MRD), monitoring, recurrence detection, resistance evolution; (6) **Pharmacogenomics**: medication selection + dosing + safety; (7) **Specialized pathology**: synoptic reports, molecular sign-out, MDT participation; (8) **Quality + standards**: CAP, ASCO, NCCN guidelines; (9) **Data sharing + registries**: cBioPortal, OncoKB, AACR Project GENIE; (10) **Patient + family education**: complex information, shared decision-making; (11) **Equity considerations**: ensure access + reduce disparities; (12) **Research integration**: clinical trials, translational; (13) **Multidisciplinary infrastructure**: regular meetings, EMR integration, decision support; (14) **Modern**: precision medicine standard in oncology + expanding to other specialties (cardiology, neurology, immunology)"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Single specialty"}]'::jsonb,
  'B', 'Precision medicine: molecular tumor board + multidisciplinary. Comprehensive profiling + interpretation + treatment selection. Hereditary + liquid biopsy + pharmacogenomics. Equity + research integration. Modern: standard in oncology + expanding.', NULL,
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
  s.id, 'board', NULL, 'Hospital implements pathology workforce + telepathology + global pathology', '[{"label":"A","text":"Random"},{"label":"B","text":"Pathology Workforce + Telepathology: (1) **Workforce shortage**: pathology + lab medicine global shortage; rural + developing country access challenges; aging workforce; (2) **Telepathology**: remote consultation, primary diagnosis (with validation), subspecialty consultation, education; reduces geographic disparity; (3) **Telepathology modes**: dynamic (real-time microscope), static (selected images), whole-slide image-based (most comprehensive); (4) **Subspecialty consultation**: rare or difficult cases referred to specialists globally; (5) **Global pathology**: capacity building in LMICs (low- middle-income countries); WHO + ASCP, etc.; (6) **Workforce expansion**: - More residency training positions; - Subspecialty fellowships; - Pathologist assistant + lab technologist; - Cytotechnologists + histotechnologists; (7) **Education + training**: simulation, online learning, webinars, virtual microscopy; (8) **Quality assurance** for telepathology: validation, consistency, lighting + color, network latency, security; (9) **Regulatory + licensing**: cross-state + cross-country; HIPAA + GDPR + local regulations; (10) **Equity + access**: ensure benefits reach underserved + LMIC; affordability; (11) **Multidisciplinary**: pathology + IT + administration + clinical + global health; (12) **Modern**: telepathology + global collaboration + AI + digital transformation expanding access"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Avoid"}]'::jsonb,
  'B', 'Pathology workforce + telepathology: shortage + access challenges. Telepathology expands access + subspecialty consultation. Global pathology capacity building. Workforce expansion + education. Quality + regulation. Equity. Modern: digital + collaboration transforming.', NULL,
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
  s.id, 'board', NULL, 'Patient with breast cancer — pathology + multidisciplinary + survivorship integrative care', '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Breast Cancer Pathology Integrative Care: (1) **Initial pathology**: core biopsy diagnosis + biomarkers (ER/PR/HER2/Ki-67) → molecular subtype + risk stratification; (2) **Multidisciplinary tumor board**: pathology + breast surgery + medical oncology + radiation oncology + radiology + plastic surgery + genetics + nurse navigator; (3) **Treatment planning**: neoadjuvant vs adjuvant; surgery (BCS vs mastectomy); axillary management; radiation; systemic therapy (chemo + targeted + endocrine); (4) **Post-treatment monitoring + surveillance**: annual mammography, clinical exam, symptoms, biomarkers (selected); (5) **Late effects + survivorship**: - Cardiotoxicity (trastuzumab, anthracycline) — cardio-oncology; - Lymphedema management; - Sexual + reproductive health; - Bone health (aromatase inhibitor — DEXA, bisphosphonate); - Cognitive (chemo brain); - Mental health + body image; - Fatigue + nutrition + exercise; (6) **Genetic counseling**: BRCA + others — family implications + risk-reducing strategies; (7) **Recurrence/metastatic disease**: re-biopsy when accessible — biomarker changes (ER/PR/HER2 conversion), new actionable mutations; (8) **New agents revolutionizing**: CDK4/6 inhibitors (palbociclib, ribociclib, abemaciclib) + endocrine; PARP inhibitors (BRCA); antibody-drug conjugates (T-DXd — HER2 + HER2-low); sacituzumab govitecan (TNBC); immunotherapy (TNBC + PD-L1+); (9) **Patient + family support**: education, peer support, financial counseling, integrative therapies; (10) **Equity considerations** + access"},{"label":"C","text":"Random"},{"label":"D","text":"Single specialty"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', 'Breast cancer integrative pathology + care: multidisciplinary + comprehensive + long-term. Treatment phase + monitoring + survivorship + late effects + genetic counseling + recurrence management. Modern: revolutionary new agents + precision. Patient-centered.', NULL,
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
  s.id, 'board', NULL, 'Patient with chronic kidney disease — pathology + multidisciplinary integrative care', '[{"label":"A","text":"Single specialty"},{"label":"B","text":"CKD Integrative Multidisciplinary Care: (1) **Pathology role**: kidney biopsy for diagnosis of underlying disease (IgA, lupus nephritis, membranous, FSGS, diabetic nephropathy, etc.) → guides treatment; (2) **CKD staging**: by GFR + albuminuria (KDIGO); (3) **Treatment based on cause + stage**: - Diabetic nephropathy: SGLT2 + RAS blockade + finerenone + glycemic + BP control; - Immune-mediated: immunosuppression + KDIGO 2021; - Inherited (polycystic): tolvaptan for ADPKD; - Other secondary: treat underlying; (4) **Slowing progression** (universal): BP control + RAS blockade + glycemic + SGLT2 + finerenone + lipid + diet + smoking cessation; (5) **Comorbidity management**: CVD (greatest cause of death in CKD), bone-mineral disease (Ca, phos, PTH, vit D), anemia (EPO, iron, oral HIF-PHI roxadustat in some regions), acidosis (bicarbonate), uremia symptoms; (6) **Dialysis planning + transplant evaluation early** (Stage 4 → access, evaluation); (7) **Education + patient empowerment**: nutrition (K, phos, Na, protein, fluid), medication adherence, lifestyle, symptom recognition; (8) **Pharmacy review**: dose adjustment, nephrotoxin avoidance; (9) **Vaccinations**: special considerations (HBV — high doses, pre-dialysis); (10) **Mental health**: depression high in CKD; (11) **Palliative + advance care planning** for advanced; (12) **Multidisciplinary**: nephrology + pathology + primary care + dietitian + pharmacy + social work + transplant + dialysis + mental health; (13) **Modern**: novel agents (SGLT2, finerenone, HIF-PHI) + integrated chronic care"},{"label":"C","text":"Random"},{"label":"D","text":"Single specialty"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', 'CKD integrative care: pathology diagnostic + comprehensive multidisciplinary management. Slowing progression + comorbidity + dialysis/transplant planning + education + palliative for advanced. Modern: SGLT2 + finerenone + HIF-PHI revolutionizing care.', NULL,
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
  s.id, 'board', NULL, 'Patient with hereditary cancer syndrome (Lynch) + multidisciplinary genetics integrative care', '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Hereditary Cancer Syndrome Integrative Care (Lynch Syndrome example): (1) **Diagnostic confirmation**: germline MMR gene mutation (MLH1, MSH2, MSH6, PMS2, EPCAM); tumor testing (MSI, IHC for MMR) + Amsterdam/Bethesda criteria + family history; (2) **Surveillance + risk reduction**: - Colon: colonoscopy q1-2 yr starting age 20-25 (or 2-5 yr before youngest relative); - Endometrial + ovarian (women): annual TVS + endometrial sampling 30-35; risk-reducing hysterectomy + BSO 40-45; - Gastric/duodenal: EGD q3-5 yr from age 30-35 (especially Asian + family history); - Urothelial: annual urinalysis from 30-35; - Skin: annual skin exam; - Pancreatic: EUS/MRI in selected; (3) **Family screening**: cascade testing of first-degree relatives at appropriate age; counseling; (4) **Treatment of cancers**: standard but consider immunotherapy (pembrolizumab — MSI-H benefit); chemoprevention (aspirin — CAPP2 trial — reduces CRC + endometrial in Lynch); (5) **Genetic counseling**: complex testing + interpretation + family implications + psychosocial impact; (6) **Reproductive**: preimplantation genetic testing (PGT) consideration; (7) **Multidisciplinary**: medical genetics + GI + GYN + medical oncology + surgical oncology + pathology + primary care + psychology; (8) **Registry + research**: data + future understanding; (9) **Equity considerations**: testing access + cost + underrepresented populations; (10) **Patient + family education + advocacy**; (11) **Modern**: precision + family-centered + comprehensive lifelong care"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Single specialty"}]'::jsonb,
  'B', 'Hereditary cancer syndrome integrative care: diagnosis + surveillance + risk reduction + family screening + treatment + counseling. Multidisciplinary genetics. Chemoprevention (aspirin Lynch). Modern: precision family-centered comprehensive lifelong care.', NULL,
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

commit;

-- verify
select board_section, count(*) from public.mcq_questions
where board_specialty = 'pathology' and exam_source = 'AI-generated-board-seed'
group by 1 order by 1;
