-- ===============================================================
-- หมอรู้ — Board seed: อายุรศาสตร์ (internal_medicine) — Part 4/4 (Q151-200)
-- Safe to paste into Supabase SQL Editor. Re-runnable.
-- Apply parts in order: 1, 2, 3, 4
-- ===============================================================

begin;

-- 1/2 ─── mcq_subjects for this specialty (idempotent) ────────
insert into public.mcq_subjects
  (name, name_th, icon, audience, board_specialty, exam_type, question_count)
values
  ('im_clinical_decision', 'อายุรศาสตร์ · การตัดสินใจทางเวชกรรม', '🩺', 'board', 'internal_medicine', NULL, 0),
  ('im_basic_science', 'อายุรศาสตร์ · วิทยาศาสตร์การแพทย์พื้นฐาน', '🧬', 'board', 'internal_medicine', NULL, 0),
  ('im_ems_mgmt', 'อายุรศาสตร์ · การจัดการระบบบริการการแพทย์ฉุกเฉิน', '🚨', 'board', 'internal_medicine', NULL, 0),
  ('im_integrative', 'อายุรศาสตร์ · ข้อสอบบูรณาการ', '🧩', 'board', 'internal_medicine', NULL, 0)
on conflict (name) do nothing;

-- 2/2 ─── 50 mcq_questions (Q151-200) ──────────────

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident เตรียมตอบ board: "กลไก antiretroviral therapy classes + ART mechanism + drug interaction + drug resistance?"', '[{"label":"A","text":"ART = single drug class only"},{"label":"B","text":"ART classes: (1) **NRTI** (nucleoside/nucleotide reverse transcriptase inhibitor): tenofovir disoproxil (TDF), tenofovir alafenamide (TAF, less nephro/bone), emtricitabine (FTC), lamivudine (3TC), abacavir (ABC — HLA-B*5701 hypersensitivity screen), zidovudine (older, anemia); chain terminator after viral DNA polymerase incorporates. (2) **NNRTI** (non-nucleoside RT inhibitor): efavirenz (EFV — CNS SE; less used now), nevirapine, rilpivirine (low VL), doravirine (newer, neutral CV/lipid); allosteric binding. (3) **PI** (protease inhibitor): atazanavir, darunavir, lopinavir; with ritonavir/cobicistat boost; cleavage Gag-Pol polyprotein. SE: lipid, GI, jaundice, drug interactions. (4) **INSTI** (integrase strand transfer inhibitor): bictegravir, dolutegravir (DTG), raltegravir, elvitegravir, cabotegravir; high barrier (DTG, BIC). Preferred frontline. (5) **Entry/fusion**: maraviroc (CCR5 antagonist; need tropism test), enfuvirtide (T20 SC). (6) **Capsid inhibitor**: lenacapavir (long-acting SC q6mo). (7) **Attachment inhibitor**: fostemsavir. Preferred frontline regimens: B/F/TAF (Biktarvy single-tablet INSTI), DTG + TAF/FTC (TLD in Thai NAP), DTG + 3TC (dual). Long-acting injectable cabotegravir + rilpivirine q2mo (Cabenuva). PrEP: TDF/FTC daily or on-demand (2-1-1), cabotegravir LA q2mo, lenacapavir LA q6mo. Resistance: emerges from suboptimal adherence; resistance testing (genotype) at baseline + virologic failure. Drug interactions: PI + cobicistat = CYP3A4 inhibitor — many interactions; rifampin reduces TDF/DTG/PI; TDF + nephrotoxin caution"},{"label":"C","text":"All ART works on same enzyme"},{"label":"D","text":"Resistance = irrelevant"},{"label":"E","text":"Single drug ART = standard"}]'::jsonb,
  'B', 'ART mechanism + classes — core HIV management. (1) HIV life cycle target points: attachment, fusion, reverse transcription, integration, protein synthesis, maturation (protease). (2) NRTI: nucleoside analog phosphorylated to active triphosphate → competes with native dNTP → chain termination by incorporated analog (lack 3''-OH). 2 NRTI form backbone of most regimens (TAF + FTC, TDF + FTC). (3) NNRTI: non-competitive allosteric binding to RT; rapid resistance from single mutation in monotherapy. (4) PI: blocks viral protease → immature non-infectious virion; high genetic barrier alone but boosting with ritonavir/cobicistat (CYP3A4 inhibitor) extends half-life. (5) INSTI: blocks integration of viral DNA into host genome; preferred class (BIC, DTG — high barrier); cabotegravir LA injectable. (6) Entry: maraviroc (CCR5), enfuvirtide (gp41); tropism test needed. (7) Newer: capsid inhibitor lenacapavir (q6mo SC; recently expanded PrEP — PURPOSE-1 trial 100% efficacy in cisgender women); attachment inhibitor fostemsavir. (8) Standard regimen = 3-drug typically (2 NRTI + INSTI) OR 2-drug (DTG + 3TC for stable virologically suppressed). (9) Resistance: low-level viremia → mutation; genotypic resistance testing (Sanger or NGS) at baseline + virologic failure. M184V (3TC/FTC resistance) common. K65R (TDF). T215Y (TAMs — zidovudine). NNRTI K103N. INSTI Q148, N155, R263K. Adherence > 95% needed for INSTI suppression. (10) Drug interactions: PI + cobicistat = CYP3A4 inhibitor — many; PPI + atazanavir absorption; rifampin reduces TDF/DTG/EFV (use rifabutin or boosted regimen); statin interactions (avoid simvastatin with PI). (11) PrEP: TDF/FTC daily; on-demand (2-1-1 for MSM); cabotegravir LA q2mo (HPTN 083); lenacapavir LA q6mo. (12) PEP: TDF/FTC + INSTI × 28 d within 72 hr post-exposure. (13) PMTCT: ART throughout pregnancy; risk-based infant ARV; breastfeeding decisions context-dependent (U=U in suppressed). (14) Monitoring: VL q3-6mo, CD4 less frequent once stable, drug toxicity surveillance.', NULL,
  'medium', 'id', 'review',
  'internal_medicine', 'basic_science', 'id', 'adult',
  'DHHS Adult ART Guideline 2024; WHO Consolidated HIV Guidelines 2023; PURPOSE-1 NEJM 2024 (lenacapavir PrEP)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'Resident เตรียมตอบ board: "กลไก antiretroviral therapy classes + ART mechanism + drug interaction + drug resistance?"'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident เตรียมตอบ board: "กลไก osteoporosis bone remodeling — OPG/RANK/RANKL + Wnt/sclerostin + drug mechanism (bisphosphonate, denosumab, romosozumab, teriparatide)?"', '[{"label":"A","text":"Bone is static tissue"},{"label":"B","text":"Bone remodeling: continuous balanced osteoclast resorption + osteoblast formation throughout life. Cycle: activation (osteocyte signaling) → resorption (osteoclast — bone matrix dissolution by H+ + cathepsin K) → reversal → formation (osteoblast — osteoid → mineralization). **RANK/RANKL/OPG axis**: osteoblast/stromal cell express RANKL (receptor activator of NF-κB ligand) → binds RANK on osteoclast precursor → differentiation + activation; OPG (osteoprotegerin, decoy receptor) blocks RANKL → ↓ resorption. Estrogen ↑ OPG. **Wnt/β-catenin pathway**: critical for osteoblast differentiation + activity; sclerostin (SOST, from osteocyte) inhibits Wnt → ↓ formation. Drug mechanisms: (1) **Bisphosphonate** (alendronate, risedronate, zoledronate): pyrophosphate analog; binds hydroxyapatite; internalized by osteoclast → inhibits farnesyl pyrophosphate synthase (mevalonate pathway) → osteoclast apoptosis + ↓ resorption; long bone half-life (years); jaw osteonecrosis + atypical femur fracture risk; drug holiday after 3-5 yr in low-moderate risk. (2) **Denosumab** (Prolia): monoclonal Ab against RANKL — mimics OPG; SC q6mo; reversible; discontinuation = rebound vertebral fracture (must transition to bisphosphonate); ↑ infection + hypocalcemia. (3) **Romosozumab** (Evenity): monoclonal Ab against sclerostin → Wnt activation → ↑ bone formation + ↓ resorption (dual effect); FRAME, ARCH trials; CV black-box (avoid recent MI/stroke); SC monthly × 12 mo then antiresorptive. (4) **Teriparatide** (PTH 1-34) / abaloparatide (PTH-rP analog): daily SC; pulsatile PTH → anabolic effect; ↑ osteoblast > osteoclast; bone mass + structure improvement; 2-yr lifetime limit (rat osteosarcoma); follow with antiresorptive to retain gains. (5) **Calcitonin**: less effective; rarely used. (6) **SERM** (raloxifene): selective; postmenopausal vertebral; ↑ VTE + hot flash. (7) Calcium + vit D + exercise + fall prevention foundational"},{"label":"C","text":"Bisphosphonate stimulates osteoclasts"},{"label":"D","text":"RANKL inhibits osteoclasts"},{"label":"E","text":"Sclerostin promotes bone formation"}]'::jsonb,
  'B', 'Bone remodeling + osteoporosis drug mechanisms. (1) Bone remodeling cycle (~6 months) — activation, resorption (osteoclast), reversal, formation (osteoblast), mineralization, quiescence. (2) Key pathways: - RANKL/RANK/OPG: osteoblast/stromal RANKL → RANK on osteoclast → differentiation + activation; OPG decoy receptor blocks. Estrogen ↑ OPG (loss of estrogen at menopause → ↑ resorption). - Wnt/β-catenin: osteoblast differentiation + activity; sclerostin from osteocyte inhibits Wnt → ↓ formation. - PTH: continuous PTH → ↑ resorption (hyperPT); pulsatile → ↑ formation (teriparatide). - Vitamin D + calcitriol: ↑ Ca + Phos absorption gut + reabsorb kidney; promotes mineralization. - Thyroid hormone, glucocorticoid, sex steroid modulate. (3) Bisphosphonate mechanism: pyrophosphate analog binds hydroxyapatite (selective for high-turnover sites); osteoclast internalizes via resorption; nitrogen-containing bisphosphonates inhibit farnesyl PP synthase (mevalonate pathway) → ↓ prenylation of GTPase → osteoclast apoptosis; non-nitrogen (etidronate) ATP analog. Long bone half-life. Adverse: GI (oral), ONJ (1/10,000-100,000 standard; higher in oncology dose), atypical femur fracture (long-term > 5 yr), uveitis (IV), acute phase reaction (IV first dose). Drug holiday after 3-5 yr if low-mod risk. (4) Denosumab (Prolia, Xgeva for oncology): anti-RANKL; mimics OPG; SC q6mo; reversible; rebound vertebral fracture on discontinuation = must transition to bisphosphonate; ↑ infection + hypocalcemia + ONJ + atypical fracture. (5) Romosozumab (Evenity): anti-sclerostin; Wnt activation; dual effect ↑ formation + ↓ resorption; FRAME, ARCH; CV black-box; SC monthly × 12 mo then antiresorptive. (6) Teriparatide / abaloparatide: anabolic; daily SC; 2-yr lifetime limit; rat osteosarcoma signal; follow with antiresorptive. (7) Other: SERM (raloxifene — vertebral, ↑ VTE), HRT (limited role), calcitonin (limited efficacy + cancer signal), calcitriol/active vit D (hypopara). (8) Bone biomarkers: P1NP (formation), CTX, NTX (resorption); use for adherence + response monitoring. (9) Falls prevention + nutrition + exercise foundational.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'internal_medicine', 'basic_science', 'endocrine_metabolic', 'adult',
  'Lacey DL — RANKL/OPG; Endocrine Society Osteoporosis Pharmacologic Guideline 2020; ARCH NEJM 2017 (Romosozumab)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'Resident เตรียมตอบ board: "กลไก osteoporosis bone remodeling — OPG/RANK/RANKL + Wnt/sclerostin + drug mechanism (bisphosphonate, denosumab, romosozumab, teriparatide)?"'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident เตรียมตอบ board: "กลไก checkpoint inhibitor immunotherapy + irAE (immune-related adverse events)?"', '[{"label":"A","text":"Checkpoint inhibitor = traditional chemotherapy"},{"label":"B","text":"**Immune checkpoint inhibitors (ICI)**: block inhibitory signals (\"brakes\") on T-cells → restored antitumor immunity. Key targets: (1) **CTLA-4** (cytotoxic T-lymphocyte antigen 4): inhibits early T-cell priming in lymph node; competes with CD28 for B7 (CD80/CD86); blocked by ipilimumab (Yervoy) — first FDA ICI 2011. (2) **PD-1** (programmed death-1): receptor on activated T-cell; engaged by tumor PD-L1/L2 → exhaustion + apoptosis; blockade restores effector function. Anti-PD-1: pembrolizumab (Keytruda), nivolumab (Opdivo), cemiplimab, dostarlimab. Anti-PD-L1: atezolizumab, durvalumab, avelumab. (3) **LAG-3**: relatlimab (combination with nivolumab — Opdualag for melanoma). Indications expanding: melanoma, NSCLC, RCC, urothelial, HNSCC, hepatocellular, gastric, esophageal, MSI-H tumors (KEYNOTE-158 — pembrolizumab tumor-agnostic for MSI-H/dMMR), TNBC, Hodgkin lymphoma, MCC, hairy cell, refractory PCNSL. Biomarkers: PD-L1 (CPS, TPS), MSI-H/dMMR, TMB-H, gene expression signature. **irAEs**: autoimmune-like organ toxicity from broken tolerance; any organ; common: dermatitis (rash, vitiligo, pruritus), colitis, hepatitis, pneumonitis, endocrinopathy (hypothyroid, hypophysitis, T1DM, adrenal insufficiency, hypopara), nephritis, myocarditis (rare but severe), neuro (myasthenia-like, encephalitis, GBS), hematologic (cytopenia), arthritis. Management: grade 1-2 — continue ICI + symptomatic; grade ≥ 3 — hold ICI + high-dose steroid (1-2 mg/kg pred); refractory — infliximab, MMF, IVIG, JAK inhibitor, vedolizumab; permanent discontinuation for severe (myocarditis, severe neuro, refractory). Pre-Rx: thyroid, cortisol, glucose, LFT, lipase baseline + monitor; HIV/HBV/HCV; vaccinations"},{"label":"C","text":"ICI works via DNA damage"},{"label":"D","text":"PD-1 = stimulates T-cell"},{"label":"E","text":"irAE not real"}]'::jsonb,
  'B', 'Immune checkpoint inhibitor mechanism + irAE management — transformative oncology. (1) Targets: CTLA-4 (early priming in LN, B7 competition with CD28), PD-1/PD-L1 (peripheral exhaustion of effector T-cells), LAG-3, TIGIT, TIM-3, VISTA. (2) Approved agents: anti-CTLA-4 (ipilimumab), anti-PD-1 (pembrolizumab, nivolumab, cemiplimab, dostarlimab), anti-PD-L1 (atezolizumab, durvalumab, avelumab), anti-LAG-3 (relatlimab — combo with nivo Opdualag). (3) Combination: ipi-nivo (CheckMate 067 in melanoma) — higher response + higher irAE; nivo + relatlimab (RELATIVITY-047 melanoma). (4) Indications: melanoma, NSCLC, RCC, urothelial, HNSCC, gastric, esophageal, hepatocellular, MCC, Hodgkin lymphoma, cervical, endometrial dMMR, TNBC (atezolizumab), MSI-H/dMMR tumor-agnostic (pembrolizumab KEYNOTE-158), TMB-H, refractory cancers. (5) Biomarkers: PD-L1 expression (CPS combined positive score, TPS tumor proportion score), MSI-H/dMMR, TMB-H (≥ 10 mut/Mb), gene expression. (6) irAE — autoimmune-like organ toxicity from broken tolerance: any organ; onset weeks-months after start. Common: dermatitis (rash, vitiligo, pruritus, lichenoid; rare SJS/TEN), colitis (diarrhea, hematochezia), hepatitis (transaminitis), pneumonitis, endocrinopathy (hypothyroidism most common, hypophysitis, T1DM, primary adrenal insufficiency, hypoparathyroidism), nephritis (interstitial), myocarditis (rare but severe + may be fulminant), neuro (myasthenia-like, encephalitis, GBS, meningitis, neuropathy), hematologic (AIHA, ITP, hemophagocytic), arthritis, sicca syndrome. (7) irAE timing varies; can occur after stopping ICI (long half-life mAb + irreversible immune activation). (8) Management (ASCO + ESMO + NCCN irAE guideline): grade 1-2 — continue ICI + symptomatic; grade ≥ 3 — hold ICI + high-dose corticosteroid (prednisolone 1-2 mg/kg/d) tapered over 4-6 wk; severe + refractory — infliximab (colitis, hepatitis — but worsens hepatitis if used initially; vedolizumab gut-selective; MMF for hepatitis; JAK inhibitor for myocarditis; IVIG/PLEX for neuro; rituximab for hematologic). (9) Permanent discontinuation: severe myocarditis, severe neuro, refractory toxicity, pulmonary fibrosis. (10) Pre-treatment workup: thyroid + cortisol + glucose + LFT + lipase baseline + monitor q cycle; HIV/HBV/HCV screen (HBV reactivation risk); vaccination (avoid live); patient education + irAE recognition. (11) ICI mostly NOT for: autoimmune disease severe + on immunosuppressive (relative contraindication), prior organ transplant (rejection risk), pregnancy.', NULL,
  'medium', 'hemato_onco', 'review',
  'internal_medicine', 'basic_science', 'hemato_onco', 'adult',
  'Allison JP + Honjo T Nobel Prize 2018; ASCO + ESMO + NCCN irAE Management Guidelines 2023; CheckMate 067 NEJM', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'Resident เตรียมตอบ board: "กลไก checkpoint inhibitor immunotherapy + irAE (immune-related adverse events)?"'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident เตรียมตอบ board: "กลไก iron homeostasis + hepcidin + ferritin + ทำไม chronic inflammation cause anemia?"', '[{"label":"A","text":"Iron metabolism independent of inflammation"},{"label":"B","text":"Iron homeostasis: dietary Fe (heme + non-heme) → absorbed in duodenum/proximal jejunum via DMT1 (non-heme) + HCP1 (heme); intracellular Fe stored as ferritin or exported via ferroportin (FPN) on basolateral side → transferrin (Tf) in plasma → tissue uptake via TfR1 (transferrin receptor 1). Iron recycled from old RBC by macrophage (RES). Hepcidin (liver-synthesized peptide hormone): master regulator; binds + degrades ferroportin → traps Fe in enterocyte + macrophage → ↓ plasma iron. Hepcidin regulation: ↑ by iron load (BMP-SMAD pathway), inflammation (IL-6 via STAT3 → ↑ hepcidin); ↓ by ineffective erythropoiesis (erythroferrone from erythroblast), hypoxia. **Anemia of chronic disease/inflammation** (AI/ACD): inflammatory cytokines (IL-6, TNF, IFN-γ) → ↑ hepcidin → ↓ iron absorption + ↓ release from macrophage → functional iron deficiency despite adequate stores (high ferritin, low TSAT, normal-high iron stores by biopsy or labile pool); also: ↓ EPO response, ↓ EPO production, shortened RBC survival, marrow suppression. Distinguish from IDA: ferritin (acute phase — ↑ in AI vs ↓ in IDA — but threshold matters; ferritin > 100 + inflammation usually = AI predominant); TSAT low both; soluble TfR ↑ in IDA, normal AI; reticulocyte Hb content (CHr) low in IDA. Combined IDA + AI common (ferritin can be normal/low-normal but AI inflammation still ↑ hepcidin functionally). Treatment: treat underlying inflammation, iron repletion (oral or IV — IV may be needed in functional iron deficiency from hepcidin block of oral absorption), ESA in severe (CKD, cancer), hepcidin antagonist (rusfertide — for PV, BMP inhibitor — emerging)"},{"label":"C","text":"Hepcidin = pro-absorbing iron"},{"label":"D","text":"Inflammation = ↑ iron absorption"},{"label":"E","text":"Ferritin = transports iron in plasma"}]'::jsonb,
  'B', 'Iron metabolism + hepcidin = central regulator. (1) Absorption: duodenum + proximal jejunum; non-heme Fe via DMT1 after ferric reductase; heme via HCP1. (2) Cellular: ferritin store, ferroportin (FPN) export, ceruloplasmin oxidation, transferrin transport. (3) Recycling: macrophage phagocytoses old RBC, releases Fe via FPN. (4) Hepcidin: liver-secreted 25 aa peptide; master regulator; binds FPN → internalization + degradation → blocks Fe export from enterocyte + macrophage → ↓ plasma Fe. (5) Hepcidin regulation: - ↑ by: iron loading (HFE/TFR2/HJV/BMP-SMAD signaling), inflammation (IL-6 → STAT3 → hepcidin transcription). - ↓ by: ineffective erythropoiesis (erythroferrone from erythroblasts blocks hepcidin), hypoxia (HIF), iron deficiency. (6) Diseases: - Hemochromatosis: hepcidin deficiency or resistance → uncontrolled absorption (already covered). - Anemia of chronic disease/inflammation: ↑ hepcidin → functional Fe deficiency despite stores. - β-thalassemia + sideroblastic: ineffective erythropoiesis → low hepcidin → iron overload (worse with transfusion). (7) Distinguishing IDA vs ACD: - IDA: ↓ Fe + ↓ TSAT + ↑ TIBC + ↓ ferritin + ↓ retic + ↑ sTfR (soluble TfR). - ACD: ↓ Fe + ↓ TSAT + ↓ TIBC + ↑↑ ferritin (acute phase) + ↓ retic + normal sTfR. - Combined: intermediate; sTfR/log ferritin index helpful. - Reticulocyte Hb content (CHr) low in IDA. (8) Treatment: - IDA: oral Fe (ferrous sulfate, gluconate, fumarate); IV (sucrose, ferric carboxymaltose, ferumoxytol, isomaltoside) for malabsorption + intolerance + functional Fe def from hepcidin block (CKD, cancer, IBD). - Vit C ↑ absorption; alternate day dosing better tolerated + same absorption (PROVIDE). - ACD: treat underlying; IV iron + ESA in selected (CKD anemia, cancer chemo); avoid high target Hb (CV harm). (9) Iron overload: transfusional in thal/SCD/MDS; chelation (deferasirox, deferoxamine, deferiprone). (10) Hepcidin therapeutics: rusfertide (hepcidin mimetic) for polycythemia vera; vamifeport (BMP inhibitor) — emerging. (11) Erythroferrone (ERFE): erythroblast-derived hormone suppresses hepcidin; target in β-thal.', NULL,
  'medium', 'hemato_onco', 'review',
  'internal_medicine', 'basic_science', 'hemato_onco', 'adult',
  'Ganz T — Hepcidin and iron regulation; Camaschella C — Iron deficiency anemia NEJM 2015; Weiss G + Goodnough LT — Anemia of inflammation NEJM 2005', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'Resident เตรียมตอบ board: "กลไก iron homeostasis + hepcidin + ferritin + ทำไม chronic inflammation cause anemia?"'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident เตรียมตอบ board: "กลไก HIV virology + viral life cycle + ART target points?"', '[{"label":"A","text":"HIV reproduces independently of host"},{"label":"B","text":"HIV virology: enveloped retrovirus; single-stranded RNA genome (gag, pol, env + regulatory tat, rev, accessory); core proteins p24 capsid + p17 matrix; surface gp120 + gp41 envelope. Life cycle: (1) Attachment — gp120 binds CD4 + CCR5 (or CXCR4) coreceptor — target for maraviroc, ibalizumab; (2) Fusion — gp41 mediates → entry; target for enfuvirtide T20; (3) Uncoating + reverse transcription — viral RT generates dsDNA from RNA (low fidelity → high mutation → resistance); target for NRTI (chain terminator) + NNRTI (allosteric); (4) Nuclear import + integration — viral integrase inserts proviral DNA into host genome; target for INSTI (raltegravir, dolutegravir, bictegravir, cabotegravir); proviral DNA = lifelong reservoir; (5) Transcription + translation — gag-pol polyprotein synthesized; (6) Assembly + budding — viral protease cleaves polyprotein into mature structural + enzymes; target for PI; capsid assembly target for lenacapavir; (7) Maturation — virus becomes infectious. Reservoirs: latent CD4 T-cell (resting memory); lymph node; brain; gut; cure efforts — \"shock and kill\" (latency reversal agents — HDAC inhibitors), gene therapy (CCR5 knockout — Berlin/London patient via stem cell transplant); broadly neutralizing antibodies (bNAbs). Diagnosis: 4th gen Ag/Ab (HIV-1 p24 + antibody — detects ~ 2 wk after infection), 5th gen with HIV-1/2 differentiation; HIV RNA PCR for VL + acute infection; CD4 + CD4/CD8 ratio for staging + prognosis. Stages: acute (CD4 normal-↑, very high VL), chronic (varied), AIDS (CD4 < 200 or AIDS-defining illness). Co-infections (HBV, HCV, syphilis, TB, STI) + cancers (Kaposi, NHL, cervical, anal, HCC) + comorbid (CV, CKD, bone, mental health) = comprehensive care"},{"label":"C","text":"HIV = DNA virus"},{"label":"D","text":"Integrase = optional"},{"label":"E","text":"No latent reservoir"}]'::jsonb,
  'B', 'HIV virology + life cycle + ART targets — fundamental ID + virology. (1) Genome: ssRNA retrovirus; 9 kb; gag (core proteins), pol (RT, integrase, protease), env (gp120, gp41); regulatory tat (transactivator), rev (export); accessory nef, vif, vpr, vpu (HIV-1) / vpx (HIV-2). (2) Life cycle steps + ART targets: - Attachment: gp120 + CD4 + CCR5 or CXCR4 coreceptor. Target: maraviroc (CCR5 antagonist — need tropism assay), ibalizumab (anti-CD4 mAb), fostemsavir (gp120). - Fusion: gp41 conformational change → membrane fusion. Target: enfuvirtide T20 (SC). - Uncoating + reverse transcription: viral RT (high error rate → diversity); target NRTI (chain termination) + NNRTI (allosteric). - Nuclear import + integration: integrase inserts proviral DNA into host genome. Target INSTI. - Capsid: target lenacapavir (long-acting; PURPOSE-1 PrEP, treatment). - Transcription + translation: host RNA pol II; viral tat enhances; Rev exports unspliced + singly spliced. - Assembly + budding: gag polyprotein → virion. - Maturation: viral protease cleaves Gag-Pol polyprotein → mature infectious. Target PI. (3) Reservoirs: latent CD4+ T-cell (resting memory) + macrophage + dendritic + lymph node + brain + gut = barrier to cure; ART suppresses replication but not eradicates. (4) Cure approaches: - Sterilizing cure: Berlin + London + Düsseldorf patients via allogeneic SCT with CCR5-Δ32 homozygous donor. - Functional cure: post-Rx control. - Shock-and-kill: latency reversal (HDAC inhibitor, PKC agonist) + immune killing. - Block-and-lock: deeper latency. - Broadly neutralizing antibody (bNAb): VRC01, 3BNC117, 10-1074. - Gene editing: CCR5 knockout, anti-HIV CAR-T. - Therapeutic vaccine. (5) Diagnosis: - 4th gen Ag/Ab (combo HIV-1/2 Ab + p24 Ag): screening; ~ 2 wk window. - 5th gen: HIV-1/2 differentiation. - HIV RNA PCR: VL + acute infection (1-2 wk; before Ab). - CD4 count + CD4/CD8 ratio: staging, prognosis, ART decisions historically (now treat-all). - Genotype + drug resistance: at diagnosis + virologic failure. (6) Stages: - Acute (1-4 wk post-infection): flu-like; rash; mucocutaneous ulcers; lymphadenopathy; high VL; risk of transmission ↑↑. - Chronic / asymptomatic. - AIDS: CD4 < 200 or AIDS-defining (PJP, candidiasis esophageal, CMV, MAC, KS, cervical CA, TB pulmonary or extrapulm, lymphoma, toxo, crypto). (7) Co-infections + comorbid: HBV, HCV, syphilis, gonorrhea, chlamydia (STI), TB, HPV (cancer), Hep A; mental health + substance use; metabolic + CV + CKD + bone + neurocognitive on ART era. (8) Monitoring: VL q 3-6 mo (suppressed), CD4 q 6 mo until stable, baseline screen + annual STI + cancer screen.', NULL,
  'medium', 'id', 'review',
  'internal_medicine', 'basic_science', 'id', 'adult',
  'Fields Virology; Cohen MS HIV NEJM 2011; DHHS HIV Guideline 2024', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'Resident เตรียมตอบ board: "กลไก HIV virology + viral life cycle + ART target points?"'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident เตรียมตอบ board: "กลไก vitamin K + coagulation + warfarin + DOAC mechanism + reversal agent?"', '[{"label":"A","text":"Warfarin = direct factor Xa inhibitor"},{"label":"B","text":"**Vitamin K cycle**: vit K (phylloquinone K1 from green vegetables, menaquinone K2 from bacteria + animal) → vit K reductase + epoxide reductase (VKORC1 — warfarin target) → vit K hydroquinone (active form) → γ-glutamyl carboxylase converts Glu → Gla (γ-carboxyglutamic acid) on factors II, VII, IX, X + protein C, S, Z = enables Ca2+ binding → membrane anchoring → activation. **Warfarin** (VKA): blocks VKORC1 → ↓ active vit K → ↓ functional Gla-containing factors → anticoagulant effect; delayed onset (factors with different half-lives — VII shortest 6 hr, II longest 60 hr; protein C also short half-life → initial procoagulant state → warfarin-induced skin necrosis without heparin bridging if protein C deficient); narrow therapeutic; INR monitoring; many drug + food interactions (CYP2C9 + VKORC1 polymorphism affect dose); reversal: vitamin K oral/IV (sustained), 4F-PCC (rapid IV), FFP (slow). **DOAC**: - Direct thrombin inhibitor: **dabigatran** (Pradaxa) — oral; reversal: idarucizumab (Praxbind, mAb). - Direct factor Xa inhibitor: **apixaban** (Eliquis), **rivaroxaban** (Xarelto), **edoxaban** (Lixiana), **betrixaban**; reversal: andexanet alfa (Andexxa, recombinant Xa decoy) or 4F-PCC (off-label). - Advantages: fixed dose, no monitoring routine, fewer drug interactions, lower ICH risk vs warfarin; rapid onset. - Limitations: CKD/severe hepatic limitation, mechanical valve (warfarin only — RE-ALIGN dabigatran failed), valvular AF (some restrictions), antiphospholipid (warfarin preferred per TRAPS), pregnancy (warfarin/heparin), high cost. **Heparin**: UFH binds antithrombin → potentiates inhibition of IIa + Xa + IXa + XIa; aPTT monitoring; reversal protamine. LMWH (enoxaparin): inhibits more Xa than IIa; anti-Xa monitoring in select; partial protamine reversal. Fondaparinux: synthetic pentasaccharide; anti-Xa via AT; no protamine reversal. HIT (heparin-induced thrombocytopenia) type II: PF4-heparin antibody → severe paradoxical thrombosis; alternative anticoagulant (argatroban, bivalirudin, fondaparinux off-label)"},{"label":"C","text":"Vitamin K excess = bleeding"},{"label":"D","text":"DOAC needs INR monitoring"},{"label":"E","text":"Idarucizumab reverses apixaban"}]'::jsonb,
  'B', 'Anticoagulation pharmacology essential. (1) Vit K cycle: vit K → VKOR (VKORC1) → reduced vit K → γ-glutamyl carboxylase adds CO2 to Glu → Gla (γ-carboxyglutamic acid) residues on factors II (prothrombin), VII, IX, X, protein C, S, Z. Gla residues bind Ca2+ → membrane anchoring (negatively charged phospholipid on activated platelet) → enzyme assembly + activation. (2) Warfarin: VKORC1 inhibitor → ↓ active vit K → ↓ functional vit K-dependent factors. Delayed onset (factor half-lives: VII 6 hr, IX 24 hr, X 36 hr, II 60 hr; protein C 8 hr). Initial procoagulant state (protein C drops before factor II) → warfarin-induced skin necrosis if heparin not bridging in protein C/S deficient. Narrow therapeutic (INR 2-3 most; 2.5-3.5 for mechanical mitral). Pharmacogenomics: CYP2C9, VKORC1 polymorphism affects dose. Drug + food interactions extensive (CYP2C9 inhibitors/inducers, vit K-rich greens). Reversal: vit K (oral 1-5 mg for mild INR ↑; IV 10 mg slow for severe — anaphylactoid risk); 4F-PCC for major bleed/urgent surgery (Kcentra 25-50 IU/kg); FFP slower + large volume. (3) DOACs: - Dabigatran (Pradaxa): direct thrombin inhibitor; oral prodrug; idarucizumab (Praxbind, Fab against dabigatran) reversal. - Factor Xa inhibitors: apixaban (Eliquis), rivaroxaban (Xarelto), edoxaban (Lixiana), betrixaban (mostly withdrawn). Reversal: andexanet alfa (recombinant Xa decoy, Andexxa); 4F-PCC off-label. - Advantages: fixed dose, no monitoring, less ICH, less food/drug interactions, no warfarin necrosis. - Limitations: severe CKD (eGFR < 15 — case by case; apixaban OK to lower eGFR), severe hepatic, mechanical heart valve (warfarin only — RE-ALIGN trial dabigatran higher thrombosis + bleeding), valvular AF (rheumatic moderate-severe MS: warfarin only — INVICTUS-VKA), antiphospholipid syndrome triple-positive (TRAPS — warfarin), pregnancy + breastfeeding (LMWH, warfarin postpartum). (4) Heparin: UFH potentiates AT → inhibits IIa + Xa + IXa + XIa + XIIa. aPTT monitoring (or anti-Xa in select). Protamine reverses. SE: bleeding, HIT, osteoporosis (long-term). (5) LMWH (enoxaparin, dalteparin, tinzaparin): anti-Xa > anti-IIa; fixed-dose weight-based; renal clearance (avoid in severe CKD; some use anti-Xa monitoring); partial protamine reversal. (6) Fondaparinux: synthetic pentasaccharide; pure anti-Xa via AT; no HIT cross-reactivity; renal; no specific reversal. (7) HIT type II: PF4-heparin Ab → severe paradoxical thrombosis; suspect 5-14 d after exposure + ≥ 50% Plt drop or new thrombosis; 4T score; stop all heparin (including flushes); alternative anticoagulant (argatroban, bivalirudin, fondaparinux). (8) New emerging: factor XI inhibitor (asundexian, abelacimab — INVICTUS trials) — promise of efficacy with less bleeding.', NULL,
  'medium', 'hemato_onco', 'review',
  'internal_medicine', 'basic_science', 'hemato_onco', 'adult',
  'Goodman & Gilman''s Pharmacology; ACCP CHEST Antithrombotic Guideline; Connolly SJ — INVICTUS-VKA NEJM 2023', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'Resident เตรียมตอบ board: "กลไก vitamin K + coagulation + warfarin + DOAC mechanism + reversal agent?"'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident เตรียมตอบ board: "กลไก Cancer hallmarks + immunology of tumor + CAR-T cell therapy?"', '[{"label":"A","text":"All cancers same mechanism"},{"label":"B","text":"**Hanahan-Weinberg cancer hallmarks**: (1) sustained proliferative signaling, (2) evading growth suppressors (TP53, Rb), (3) resisting apoptosis (Bcl-2 up, p53 mutations), (4) replicative immortality (telomerase), (5) inducing angiogenesis (VEGF), (6) activating invasion + metastasis (EMT, MMP), (7) reprogramming energy metabolism (Warburg effect — aerobic glycolysis), (8) evading immune destruction (PD-L1, MHC loss, Treg, MDSC), (9) tumor-promoting inflammation, (10) genome instability + mutation, (11) cancer cell phenotypic plasticity, (12) senescent cells (newer). **Tumor immune evasion**: MHC class I downregulation (CD8 escape), PD-L1 upregulation (T-cell exhaustion), Treg + MDSC recruitment (suppressive microenvironment), TGF-β/IL-10 (immunosuppressive cytokines), tryptophan metabolism (IDO). **Driver mutations + targeted therapy**: KRAS G12C (sotorasib, adagrasib), EGFR (osimertinib, erlotinib), ALK (alectinib, lorlatinib), BRAF V600E (dabrafenib + trametinib), HER2 (trastuzumab + pertuzumab + T-DXd), BRCA (PARP inhibitor — olaparib synthetic lethality), MSI-H/dMMR (pembrolizumab tumor-agnostic), NTRK fusion (larotrectinib, entrectinib), BCR-ABL CML (imatinib + later gens), JAK2 PV/MF (ruxolitinib), BTK CLL (ibrutinib + later gens), FLT3 AML (midostaurin), IDH (ivosidenib, enasidenib), KIT GIST (imatinib). **CAR-T cell**: autologous T-cell engineered to express chimeric antigen receptor (extracellular Ab-derived scFv + intracellular CD3ζ + co-stim 4-1BB or CD28) targeting tumor surface antigen (CD19 — B-ALL, B-NHL; BCMA — MM; CD22 emerging; CD20). FDA-approved: tisagenlecleucel (B-ALL, DLBCL), axicabtagene ciloleucel (DLBCL, FL), brexucabtagene autoleucel (MCL, B-ALL), lisocabtagene maraleucel (DLBCL, CLL), idecabtagene + ciltacabtagene autoleucel (MM). Toxicity: cytokine release syndrome (CRS — IL-6 surge → fever, hypotension, hypoxia; tocilizumab + steroid), ICANS (neurotoxicity — confusion, seizure, cerebral edema; steroid; not tocilizumab), B-cell aplasia + hypogamma + ↑ infection, prolonged cytopenia, secondary CAR-T+ T-cell lymphoma rare. **Bispecific T-cell engager** (BiTE): blinatumomab (CD3 x CD19) for ALL; teclistamab/elranatamab (CD3 x BCMA) for MM; epcoritamab/glofitamab (CD3 x CD20) for DLBCL — off-the-shelf alternative to CAR-T"},{"label":"C","text":"Cancer is non-genetic"},{"label":"D","text":"CAR-T = monoclonal antibody"},{"label":"E","text":"All immunotherapy works the same"}]'::jsonb,
  'B', 'Cancer biology + immunotherapy mechanisms = essential modern oncology. (1) Hanahan-Weinberg hallmarks 2022 update: 14 hallmarks now including phenotypic plasticity, senescence, nonmutational epigenetic reprogramming, polymorphic microbiome. (2) Driver vs passenger mutations; oncogene (RAS, MYC) vs tumor suppressor (TP53, RB, PTEN, BRCA). (3) Targeted therapy by oncogenic driver: - KRAS G12C: sotorasib (Lumakras), adagrasib — NSCLC. - EGFR: osimertinib (3rd gen), erlotinib — NSCLC. - ALK rearrangement: alectinib, lorlatinib — NSCLC. - ROS1: crizotinib, entrectinib. - BRAF V600E: dabrafenib + trametinib — melanoma, NSCLC. - HER2: trastuzumab, pertuzumab, T-DXd (trastuzumab deruxtecan ADC) — breast, gastric, NSCLC. - BCR-ABL: imatinib + later (dasatinib, nilotinib, bosutinib, ponatinib for T315I) — CML, Ph+ ALL. - BTK: ibrutinib + later (zanubrutinib, acalabrutinib, pirtobrutinib) — CLL, MCL, WM. - FLT3: midostaurin (RATIFY), quizartinib (QuANTUM-First) — AML. - IDH1/2: ivosidenib, enasidenib — AML, cholangiocarcinoma. - PARP inhibitor: olaparib, niraparib, talazoparib — BRCA, HRD ovarian/breast/prostate/pancreatic. - PI3K/AKT/mTOR. - CDK 4/6: palbociclib, ribociclib, abemaciclib — HR+ breast. (4) Immune evasion + checkpoint inhibitor (covered). (5) CAR-T: autologous T cell expressing CAR (scFv + CD3ζ + co-stim 4-1BB [tisa-cel, brexu-cel, axi-cel] or CD28 [axi-cel, brexu-cel]). Targets: CD19 (B-cell malignancies — B-ALL, DLBCL, FL, MCL, CLL), BCMA (MM), CD22 emerging, CD20, CD30 (HL trials), CD7 (T-cell), CD33 + CD123 (AML). FDA approved: tisagenlecleucel, axicabtagene ciloleucel, brexucabtagene autoleucel, lisocabtagene maraleucel, idecabtagene vicleucel, ciltacabtagene autoleucel. Process: leukapheresis → manufacture (2-4 wk) → bridging therapy → lymphodepletion (flu/cy) → infusion. Toxicity: - CRS (cytokine release syndrome): days; IL-6 surge → fever, hypotension, hypoxia, organ dysfunction; grade with ASTCT consensus; tocilizumab + steroid. - ICANS (neurotoxicity): confusion, aphasia, seizure, cerebral edema; steroid (not tocilizumab — doesn''t cross BBB). - HLH-like / macrophage activation syndrome. - Prolonged cytopenia + infection. - B-cell aplasia + hypogamma (IVIG). - Secondary malignancy + CAR-T T-cell lymphoma rare. (6) Bispecific T-cell engager (BiTE): CD3 x tumor target; blinatumomab (CD3 x CD19 — ALL), teclistamab + elranatamab (CD3 x BCMA — MM), epcoritamab + glofitamab + mosunetuzumab (CD3 x CD20 — DLBCL, FL), tarlatamab (CD3 x DLL3 — SCLC). Off-the-shelf advantage; CRS less severe than CAR-T; can sequence with CAR-T. (7) Antibody-drug conjugate (ADC): mAb + linker + cytotoxic payload; T-DXd, sacituzumab govitecan (TROP2), enfortumab vedotin (Nectin-4), brentuximab (CD30), gemtuzumab (CD33), inotuzumab (CD22), polatuzumab (CD79b), tisotumab vedotin (TF), datopotamab deruxtecan, mirvetuximab. Bystander effect on neighboring tumor cells. (8) Cancer vaccines: HPV (Cervarix, Gardasil), HBV (HCC prevention), mRNA neoantigen (mRNA-4157 trial for melanoma — emerging therapeutic). (9) Oncolytic virus: T-VEC (HSV-1 modified for melanoma).', NULL,
  'medium', 'hemato_onco', 'review',
  'internal_medicine', 'basic_science', 'hemato_onco', 'adult',
  'Hanahan D + Weinberg RA Hallmarks of Cancer Cell 2011 + 2022; June CH + Sadelain M — CAR T-cell therapy NEJM 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'Resident เตรียมตอบ board: "กลไก Cancer hallmarks + immunology of tumor + CAR-T cell therapy?"'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident เตรียมตอบ board: "กลไก GLP-1 receptor agonist + GIP + dual agonist + weight loss?"', '[{"label":"A","text":"GLP-1 = traditional insulin replacement"},{"label":"B","text":"**Incretin physiology**: gut hormones secreted in response to oral nutrient → glucose-dependent insulin release + gastric emptying delay + appetite suppression. (1) **GLP-1** (glucagon-like peptide-1): from intestinal L cells; binds GLP-1R (Gαs → cAMP) on pancreatic β-cell → ↑ insulin (glucose-dependent), ↓ glucagon, slows gastric emptying, satiety via brainstem + hypothalamus; degraded rapidly by DPP-4. (2) **GIP** (glucose-dependent insulinotropic peptide): from intestinal K cells; β-cell ↑ insulin; complex effects. (3) **GLP-1 receptor agonists** (degradation-resistant analogs): semaglutide (Ozempic SC weekly, Wegovy SC for obesity, Rybelsus oral), liraglutide (Victoza, Saxenda), dulaglutide (Trulicity), exenatide, lixisenatide. Effects: glycemic control (A1c ↓ 1-1.5%), weight loss 5-15% (semaglutide), CV protection (LEADER, SUSTAIN-6, REWIND), renal protection (FLOW with semaglutide 2024 NEJM — 24% RR composite kidney + CV), HFpEF in obese (STEP-HFpEF). Adverse: GI nausea/vomiting (titrate slowly), gallstone, pancreatitis, MTC risk in MEN2 (rat data — black box), retinopathy progression in poorly controlled, injection site, expensive. (4) **Tirzepatide** (Mounjaro/Zepbound): dual GIP + GLP-1 agonist (DUAL); SURPASS + SURMOUNT trials — even greater glycemic + weight loss (15-20%); SE similar GLP-1. (5) **Retatrutide**: triple GLP-1 + GIP + glucagon agonist; Phase 2 weight loss > 24%. (6) **DPP-4 inhibitors** (sitagliptin, linagliptin, saxagliptin): prolong endogenous GLP-1; weight neutral; neutral CV; less robust efficacy vs GLP-1 RA. (7) **GLP-1 use beyond diabetes**: obesity (semaglutide 2.4 mg, tirzepatide 5-15 mg), MASH (semaglutide ESSENCE), CKD (FLOW), HFpEF in obese (STEP-HFpEF), addiction (alcohol use disorder — early data), Alzheimer (trials). Pioneer in metabolic medicine renaissance"},{"label":"C","text":"GLP-1 = direct insulin agonist"},{"label":"D","text":"DPP-4 = activates GLP-1"},{"label":"E","text":"Tirzepatide = pure GLP-1 only"}]'::jsonb,
  'B', 'Incretin pharmacology + emerging weight/metabolic therapy = transformative class. (1) Incretin hormones: GLP-1 (L cells), GIP (K cells) — gut-derived; ~ 50-70% of postprandial insulin response from incretin effect (lost in T2DM). (2) GLP-1R (Gαs → cAMP) on β-cell, brain (hypothalamus, brainstem — satiety), heart, kidney, vasculature; glucose-dependent insulin secretion = low hypoglycemia risk. GIP receptor similar β-cell + adipose. (3) GLP-1 receptor agonists: - Native GLP-1 short half-life (1-2 min); analogs resistant to DPP-4 + albumin-bound. - Semaglutide (Ozempic for DM, Wegovy for obesity, Rybelsus oral for DM); liraglutide; dulaglutide; exenatide (twice daily + weekly long-acting); lixisenatide. - Glycemic: A1c ↓ 1-1.5%. - Weight loss 5-15% (semaglutide 2.4 mg up to 15%; tirzepatide up to 22%). - CV protection: LEADER (liraglutide), SUSTAIN-6 + SELECT (semaglutide — obesity without DM also showed CV benefit), REWIND (dulaglutide), AMPLITUDE-O. ASCVD class effect. - Renal protection: FLOW (semaglutide in DKD — 24% RR composite kidney + CV, NEJM 2024). - HFpEF: STEP-HFpEF (semaglutide in obese HFpEF — symptom + weight benefit). - MASLD/MASH: ESSENCE (semaglutide). - Adverse: GI nausea/vomiting (titrate slowly), gallstone, pancreatitis (small signal), MTC risk in MEN2 (rat — black box; rare humans), retinopathy progression in poorly controlled T2DM rapid glucose ↓, injection site, cost. (4) Tirzepatide (Mounjaro/Zepbound): dual GIP + GLP-1 agonist; SURPASS (DM), SURMOUNT (obesity); 15-22% weight loss; SURMOUNT-OSA (OSA in obese); MASH trial. (5) Retatrutide: triple GLP-1 + GIP + glucagon agonist; Phase 2/3; > 24% weight loss in obesity. (6) Survodutide, mazdutide — additional dual/triple agonists in trials. (7) DPP-4 inhibitors (gliptins): linagliptin, sitagliptin, saxagliptin, alogliptin; prolong endogenous GLP-1; A1c ↓ 0.5-1%; weight neutral; neutral CV; less robust than GLP-1 RA; combine with metformin. (8) Indications expanding: obesity, T2DM, CV protection, CKD, HFpEF, MASLD/MASH, OSA, addiction (alcohol use disorder), Alzheimer + Parkinson trials. (9) Future: oral peptide (Rybelsus), implant, combination, CagriSema (semaglutide + cagrilintide amylin analog) further weight loss. (10) Concerns + monitoring: thyroid (MTC), pancreatitis, gallstone, GI; baseline + during use.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'internal_medicine', 'basic_science', 'endocrine_metabolic', 'adult',
  'FLOW NEJM 2024; SELECT NEJM 2023; SURMOUNT NEJM 2022; STEP-HFpEF NEJM 2023; Drucker DJ — Incretin biology Cell Metab', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'Resident เตรียมตอบ board: "กลไก GLP-1 receptor agonist + GIP + dual agonist + weight loss?"'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident เตรียมตอบ board: "กลไก kidney filtration + tubular function + diuretic targets?"', '[{"label":"A","text":"Kidney function = single mechanism"},{"label":"B","text":"Nephron functional units: (1) **Glomerulus**: filtration based on size + charge; GFR depends on Pcap (capillary pressure — afferent dilation/efferent constriction) + KF (surface area + permeability); RAAS regulates (ACEi/ARB dilate efferent → ↓ GFR transiently — protective long-term; NSAID block afferent dilation prostaglandin → ↓ GFR). Filtration fraction = GFR/RPF (~ 20%). Filtration barrier: endothelium + GBM + podocyte (slit diaphragm — nephrin, podocin); damage → proteinuria (MCD podocyte foot process effacement; FSGS focal; membranous immune complex). (2) **Proximal tubule (PT)**: reabsorbs 65% Na + water + glucose (SGLT2 — target dapa/empa, SGLT1 some), AA, HCO3 (carbonic anhydrase — target acetazolamide), Phos (NHE3, NaPi2), uric acid (URAT1 — target probenecid), Cl; secretes organic acids (penicillin, methotrexate, NSAID) + bases. Targets: acetazolamide (CA inhibitor — bicarb wasting → mild diuresis + alkalinization → for altitude sickness, acute glaucoma, alkalinization of urine; metabolic acidosis), SGLT2i (osmotic diuresis + glucosuria — cardio-renal protection covered). (3) **Thick ascending limb (TAL)**: Na/K/2Cl cotransporter (NKCC2) — target **loop diuretic** (furosemide, bumetanide, torsemide); 25% Na reabsorption; concentrates urine via medullary gradient (countercurrent multiplier); Mg + Ca reabsorption paracellular driven by lumen + charge from NKCC2 — loop diuretic → hypocalciuria, hypoMg, hypoK, hypoNa, hypochloremic metabolic alkalosis (contraction). (4) **Distal convoluted tubule (DCT)**: NaCl cotransporter (NCC) — target **thiazide** (HCTZ, chlorthalidone, indapamide); 5% Na; promotes Ca reabsorption (used for hypercalciuria + stones); hypoK, hypoNa (especially elderly), hyperglycemia, hyperuricemia, hyperlipidemia mild. (5) **Collecting duct**: principal cell — ENaC channel (mineralocorticoid up) — target **K-sparing** (amiloride, triamterene block ENaC; spironolactone, eplerenone, finerenone block aldosterone); 3-5% Na; α-intercalated cell H+ secretion (target distal RTA), β-intercalated HCO3 secretion. ADH/vasopressin acts on V2 receptor → aquaporin-2 insertion → water reabsorption (concentrate urine); target tolvaptan (V2 antagonist for SIADH + ADPKD) + desmopressin (DDAVP for DI + von Willebrand)"},{"label":"C","text":"Loop diuretic acts at glomerulus"},{"label":"D","text":"Thiazide = K-sparing"},{"label":"E","text":"Spironolactone blocks ENaC directly"}]'::jsonb,
  'B', 'Nephron physiology + diuretic targets = high yield. (1) Glomerular filtration: GFR ~ 120 mL/min normal; size + charge selective; afferent dilation/efferent constriction (RAAS) modulates Pcap; NSAID block PG (afferent dilator) → ↓ GFR; ACEi/ARB block efferent constriction → ↓ GFR transiently, reno-protective long-term. (2) Tubular segments + diuretic targets: - PCT: SGLT2 (dapa, empa, cana — cardio-renal protection), CA (acetazolamide), URAT1 (probenecid — uricosuric). - TAL: NKCC2 — loop diuretic (furosemide, bumetanide, torsemide); 25% Na; medullary gradient. - DCT: NCC — thiazide; promotes Ca reabsorption (stone prevention, hypercalciuria); SE hypoK, hypoNa elderly, hyperGlu, hyperUric. - Collecting duct: principal cell ENaC + Na/K ATPase — K-sparing (amiloride, triamterene block ENaC; spironolactone, eplerenone, finerenone block MR); intercalated cell H+/HCO3. Aldosterone ↑ ENaC. - Aquaporin-2 ADH-dependent — V2 antagonist (tolvaptan) for SIADH, ADPKD. (3) Electrolyte handling: - Na: 65% PCT, 25% TAL, 5% DCT, 3-5% CD. - K: secreted in CD (aldosterone, dietary K, flow); reabsorbed in PCT + TAL. - Ca: 65% PCT (paracellular), 25% TAL (paracellular driven by lumen + via CASR), 8% DCT (TRPV5 active — calbindin-D28K, NCX). - Mg: 25% TAL (paracellular, claudin-16/19), some DCT. - Phos: PCT (NaPi2 — PTH-regulated, FGF23-regulated). - Bicarb: PCT 80% (CA-dependent NHE3, Na/HCO3 cotransporter on basolateral); TAL + CD remainder; α-intercalated cell H+ pump. (4) Drug actions: - Loop diuretic: NKCC2 block in TAL — hypoCa-uria → hypercalciuria + hypoMg + hypoK + hypoNa + metabolic alkalosis; treats edema (HF, cirrhosis, nephrotic, AKI), hyperCa, hyperK adjunct. - Thiazide: NCC block in DCT — hypoCa-uria → hypercalcemia mild + hypercalciuria reduces stones; hypoNa especially elderly + frail. - K-sparing: amiloride, triamterene block ENaC; spironolactone (non-selective MR — gynecomastia), eplerenone (selective — less gynecomastia), finerenone (non-steroidal — better cardio-renal in CKD/HF). - SGLT2i: cardio-renal protection independent of glycemic; multiple trials. - ADH-related: tolvaptan (V2 antagonist for SIADH, ADPKD), conivaptan, desmopressin (DI, vWD). - CA inhibitor (acetazolamide): mild diuresis, urine alkalinization, altitude, glaucoma. - Mannitol: osmotic diuresis; cerebral edema, raised ICP. (5) RAAS-blockers (ACEi, ARB, MRA, renin inhibitor, ARNI): synergistic in HF + CKD + DM; risk hyperK + AKI.', NULL,
  'medium', 'renal_gu', 'review',
  'internal_medicine', 'basic_science', 'renal_gu', 'adult',
  'Brenner & Rector''s The Kidney; Ganong''s Physiology; KDIGO; Sherbino DiPaola', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'Resident เตรียมตอบ board: "กลไก kidney filtration + tubular function + diuretic targets?"'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident เตรียมตอบ board: "กลไก acute pain + chronic pain + opioid pharmacology + opioid use disorder + medications for opioid use disorder?"', '[{"label":"A","text":"All pain same mechanism"},{"label":"B","text":"Pain neurophysiology: nociceptors (Aδ + C fibers) → dorsal horn (substance P, glutamate) → spinothalamic tract → thalamus → cortex. Modulation: descending inhibition (PAG → raphe magnus → dorsal horn — serotonin + norepinephrine + endogenous opioids); gate control. **Acute pain** = adaptive; **chronic pain** = maladaptive (> 3 mo); chronic categories — nociceptive (somatic, visceral), neuropathic (nerve damage, central sensitization, allodynia, hyperalgesia), nociplastic (CNS hypersensitivity — fibromyalgia, IBS, chronic pelvic pain), mixed. **Opioid pharmacology**: μ (analgesia, euphoria, respiratory depression, constipation, dependence), κ, δ receptors; G-protein coupled → inhibit cAMP, K+ channel open, Ca2+ channel close → ↓ neuron firing. Full agonist: morphine, oxycodone, hydromorphone, fentanyl, methadone (μ + NMDA antagonist), heroin. Partial agonist: buprenorphine (μ partial, κ antagonist — ceiling on respiratory depression + analgesia). Antagonist: naloxone (short-acting reverse OD), naltrexone (long-acting). Pharmacokinetics: codeine + tramadol = prodrug to active via CYP2D6 (ultra-rapid metabolizer → toxicity; poor metabolizer → no effect; pediatric tonsillectomy fatalities). Methadone QT + drug interactions (CYP3A4) + long half-life accumulation. Fentanyl 100× morphine; transdermal patch + sublingual. **Opioid use disorder (OUD)**: chronic relapsing disorder; DSM-5 criteria; tolerance + withdrawal + craving + loss of control. MOUD/MAT (medications for OUD): (1) **Methadone**: full μ agonist; daily supervised dispensing at OTP; effective ↓ overdose + ↑ retention + ↓ illicit use; QT + interaction concerns. (2) **Buprenorphine** (Suboxone with naloxone, Subutex alone, long-acting SC Sublocade): partial agonist; safer (ceiling effect on respiratory depression); office-based prescribing (X-waiver eliminated 2023). (3) **Naltrexone** (oral, monthly LA Vivitrol): μ antagonist; requires opioid-free period (7-10 d) before start (precipitates withdrawal); also for alcohol use disorder. **Naloxone** (Narcan IM/IN): reverses overdose; widely distributed (\"naloxone OTC 2023\"); short half-life — may need repeat dose. Harm reduction: needle exchange, supervised consumption, fentanyl test strips, MOUD scale-up — public health response to opioid crisis"},{"label":"C","text":"Buprenorphine = full agonist"},{"label":"D","text":"Naloxone = long-acting"},{"label":"E","text":"Methadone = NSAID"}]'::jsonb,
  'B', 'Pain pathophysiology + opioid pharmacology + MOUD = critical topics in epidemic of opioid use disorder. (1) Pain pathways: nociceptor (Aδ fast sharp; C slow dull/burning) → dorsal root ganglion → dorsal horn → spinothalamic (lateral + medial) → thalamus → S1/S2 + insula + ACC + amygdala (emotional). Modulation: descending PAG → raphe → dorsal horn (serotonin, norepi, endogenous opioids); gate control theory; central sensitization in chronic neuropathic + nociplastic pain. (2) Pain types: nociceptive (somatic well-localized, visceral diffuse/referred), neuropathic (nerve damage + allodynia + hyperalgesia + paresthesia — DM, postherpetic, sciatica, post-stroke, chemo-induced; agents — gabapentinoid, TCA, SNRI), nociplastic (CNS hypersensitivity — fibromyalgia, chronic widespread). (3) Opioid pharmacology: - Receptors μ, κ, δ (also nociceptin); G-protein coupled inhibitory. - Full agonist: morphine, hydromorphone, oxycodone, fentanyl (100× MS), heroin, methadone (μ + NMDA antagonist), codeine (prodrug via CYP2D6), tramadol (μ + SNRI). - Partial agonist: buprenorphine — μ partial (ceiling on resp depression), κ antagonist; high affinity (displaces full agonist → precipitates withdrawal if not opioid-free). - Antagonist: naloxone (short-acting OD reversal), naltrexone (long-acting, oral or monthly IM). - Side effects: respiratory depression (FATAL), constipation (universal), nausea/vomiting, sedation, pruritus, urinary retention, tolerance, hyperalgesia, hormonal (hypogonadism, hypocortisol), dependence + OUD risk. - Tolerance + dependence (physiologic) vs OUD (psychiatric disorder of behavior + control). (4) Special: codeine + tramadol prodrug via CYP2D6 — variability; pediatric tonsillectomy deaths from ultra-rapid metabolizer; FDA contraindicated in < 12 yr. Methadone QT prolongation + CYP3A4 interactions + long half-life (accumulation, OD risk during induction). Fentanyl + analogs (carfentanil) — synthetic, illicit market driving overdose deaths. (5) Opioid use disorder (OUD) — DSM-5; chronic relapsing brain disease; tolerance + withdrawal + craving + functional impairment. (6) MOUD (medications for OUD): - **Methadone**: full μ agonist; OTP (opioid treatment program) supervised dispensing in US; effective ↓ OD mortality + retention + ↓ illicit use; QT monitoring; interaction concerns. - **Buprenorphine** (Suboxone = bup + naloxone, Subutex = bup alone, Sublocade SC monthly LA): partial agonist; safer; office-based (X-waiver eliminated 2023 US); precipitates withdrawal if patient on full agonist (induction protocol). - **Naltrexone** (oral PO ReVia; monthly IM Vivitrol XR): μ antagonist; requires opioid-free 7-10 d (otherwise precipitate withdrawal); also for AUD. - All reduce OD mortality; underutilized. (7) Naloxone (Narcan): IM/IN; reverses OD; short half-life (30-60 min) — may need repeat; harm reduction distribution; OTC approved 2023; education for layperson + first responders. (8) Harm reduction: needle/syringe service, supervised consumption sites, fentanyl test strips, drug checking, MOUD on-demand, take-home naloxone. (9) Chronic pain management non-opioid first: multimodal (acetaminophen, NSAID, topical, gabapentinoid, TCA, SNRI [duloxetine], lidocaine patch), physical/behavioral (CBT, exercise, mindfulness, acupuncture), interventional (epidural steroid, nerve block, ablation), addressing comorbid depression/anxiety/sleep. (10) Cancer pain different — escalate per WHO ladder; methadone, fentanyl patch + buccal, opioid rotation, intrathecal pump. (11) End-of-life — escalate per goals; opioid rotation; opioid + benzo for terminal dyspnea + sedation.', NULL,
  'medium', 'psych_behavior', 'review',
  'internal_medicine', 'basic_science', 'psych_behavior', 'adult',
  'Goodman & Gilman''s Pharmacology; ASAM National Practice Guideline OUD 2020; CDC Opioid Prescribing 2022; SAMHSA TIP 63', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'Resident เตรียมตอบ board: "กลไก acute pain + chronic pain + opioid pharmacology + opioid use disorder + medications for opioid use disorder?"'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident เตรียมตอบ board: "กลไก gut microbiome + FMT + IBD pathophysiology + ทำไม microbiome ทำให้ obesity + metabolic disease?"', '[{"label":"A","text":"Microbiome irrelevant to disease"},{"label":"B","text":"**Gut microbiome**: trillions of microbes (bacteria > archaea, fungi, virus); 10× human cells; > 1000 species; genome > 100× human; dominated by Bacteroidetes + Firmicutes; community = microbiota; genes = microbiome. Functions: nutrient extraction (short-chain fatty acid — butyrate, propionate, acetate from fiber fermentation; vit K + B), immune education (Treg induction by SCFA + commensals; oral tolerance), barrier integrity, neurotransmitter (5HT 90% from enterochromaffin influenced by microbiota), drug metabolism, xenobiotic biotransformation. Dysbiosis: low diversity + altered composition associated with IBD, IBS, CDI, obesity, T2DM, MASLD, allergy, asthma, autism, depression, cancer response to immunotherapy. **IBD** (UC, Crohn): genetic susceptibility (NOD2, IL-23R, ATG16L1) + dysbiosis + barrier dysfunction + dysregulated immunity (Th17, Treg imbalance) + environmental (smoking + diet + antibiotic + appendectomy). Loss of beneficial Faecalibacterium prausnitzii (anti-inflammatory), expansion of Proteobacteria + sulfate-reducing bacteria. **FMT** (fecal microbiota transplantation): restore healthy microbiome; FDA-approved for recurrent CDI (Rebyota — rectal, Vowst — oral capsule); > 90% cure recurrent CDI > 2 episodes; routes — colonoscopy, capsule, NG, enema; emerging — IBD (UC > Crohn — mixed evidence; STOP-Colitis trial), hepatic encephalopathy, autism, GVHD. Donor screening + biobanking standardized. **Obesity microbiome**: altered F/B ratio (Firmicutes ↑ Bacteroidetes ↓ in some — heterogeneous); ↑ energy harvest from diet; ↑ inflammation via LPS endotoxemia (\"metabolic endotoxemia\"); ↓ Akkermansia muciniphila (mucin-degrading commensal; barrier integrity; supplementation lowers HbA1c + weight); microbe metabolites (TMAO from L-carnitine → atherosclerosis; bile acids), butyrate as energy + GPR43/41 signaling regulates glucose + insulin sensitivity. Modulators: diet (fiber, fermented, prebiotic), probiotic (strain-specific evidence), prebiotic (inulin), synbiotic, postbiotic (SCFA), FMT, defined microbial consortia, engineered probiotics"},{"label":"C","text":"Microbiome same in all people"},{"label":"D","text":"FMT = useless"},{"label":"E","text":"Antibiotic strengthens microbiome"}]'::jsonb,
  'B', 'Gut microbiome — emerging foundational discipline. (1) Composition: bacteria dominant (Bacteroidetes, Firmicutes 90%, then Proteobacteria, Actinobacteria); archaea (Methanobrevibacter), fungi (Candida), virome (bacteriophage). Site-specific differences (oral, gastric, small bowel, colon — highest diversity + count). 16S rRNA + shotgun metagenomics + metatranscriptomics + metabolomics for analysis. (2) Functions: - Metabolism: SCFA (butyrate — colonocyte energy, anti-inflammatory; propionate — gluconeogenesis; acetate — peripheral), vit K, vit B; bile acid metabolism (primary → secondary by bacterial 7α-dehydroxylation); drug metabolism (digoxin, irinotecan SN-38 reactivation by β-glucuronidase causing GI toxicity). - Immune: Treg induction (Clostridia + SCFA), oral tolerance, IgA secretion. - Barrier: mucin layer, tight junction. - Neurotransmitter: 5HT (90% gut, enterochromaffin influenced by microbiota), GABA, dopamine. - Gut-brain axis: vagal afferent, microbial metabolite, immune. (3) Dysbiosis-associated: - IBD: ↓ Faecalibacterium prausnitzii, ↑ Proteobacteria + adherent-invasive E. coli; genetic susceptibility (NOD2, IL-23R, ATG16L1) + dysbiosis. - C. difficile: post-antibiotic dysbiosis enabling overgrowth + toxin production. - Obesity/T2DM: F/B ratio altered, ↓ Akkermansia, ↑ energy harvest, metabolic endotoxemia. - MASLD/MASH: gut-liver axis, SIBO, dysbiosis, ↑ portal LPS. - Allergy/asthma: hygiene hypothesis, low diversity in infancy. - Depression/anxiety: gut-brain axis. - Cancer: immune surveillance + checkpoint response (Akkermansia + Faecalibacterium associated with response). - GvHD post-allo SCT: dysbiosis worsens. - Autism (limited evidence). (4) FMT: - FDA-approved indication: recurrent CDI ≥ 2 episodes. - Products: Rebyota (rectal), Vowst (oral capsule SER-109 — purified spores) approved 2022-2023. - Stool bank donors screened + frozen. - Routes: colonoscopy, capsule, NG, enema. - Cure rate recurrent CDI > 90%. - Emerging: IBD (UC mixed evidence — STOP-Colitis, FOCUS trials; donor selection key), hepatic encephalopathy, MetS, autism (controversial), GVHD prophylaxis, immunotherapy response augmentation. (5) Modulating microbiome: - Diet: fiber (resistant starch, inulin, pectin), Mediterranean, fermented (yogurt, kimchi, kefir), polyphenol-rich, time-restricted. - Probiotic: live microorganisms; strain-specific evidence (e.g., L. rhamnosus GG, Saccharomyces boulardii for antibiotic-associated diarrhea; ABC News + Lactobacillus). - Prebiotic: fiber selective for beneficial bacteria. - Synbiotic: combination. - Postbiotic: SCFA, butyrate. - Defined microbial consortium. - Engineered probiotics (e.g., bacteria producing therapeutic — emerging). (6) Akkermansia muciniphila — increasing focus; supplementation lowers HbA1c + weight + improves insulin sensitivity in obese pre-diabetic; FDA approved as food in some forms. (7) TMAO (trimethylamine N-oxide) — gut bacterial metabolite from L-carnitine + choline → atherosclerosis + CV events; meat-heavy diet link. (8) Antibiotic stewardship critical — even short courses cause long-term dysbiosis. (9) Mother-to-infant microbiome transfer — vaginal birth + breastfeeding + skin contact established early; C-section + formula → altered; vaginal seeding controversial.', NULL,
  'medium', 'gi', 'review',
  'internal_medicine', 'basic_science', 'gi', 'adult',
  'Sender R + Fuchs S — Microbe cells; Cammarota G et al. FMT Guidelines; Sonnenburg JL Nature 2014', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'Resident เตรียมตอบ board: "กลไก gut microbiome + FMT + IBD pathophysiology + ทำไม microbiome ทำให้ obesity + metabolic disease?"'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident เตรียมตอบ board: "กลไก thyroid hormone synthesis + action + regulation + thyroid testing interpretation?"', '[{"label":"A","text":"Thyroid hormone independent of iodine"},{"label":"B","text":"**Thyroid hormone synthesis**: iodide uptake into thyrocyte via Na/I symporter (NIS — blocked by perchlorate, pertechnetate, thiocyanate); oxidation by thyroid peroxidase (TPO) with H2O2 (TPO blocked by methimazole + PTU — antithyroid drugs); iodination of tyrosine residues on thyroglobulin (Tg, large protein) → MIT + DIT; coupling MIT+DIT → T3 (3,5,3''-triiodothyronine), DIT+DIT → T4 (3,5,3'',5''-tetraiodothyronine); colloid storage; resorption + proteolysis releases T4 (80%) + T3 (20%) into blood. T4 conversion to active T3 in periphery by deiodinase (D1 + D2 — active T3; D3 — inactive rT3); D2 in pituitary mediates feedback. Plasma: 99% bound to TBG + albumin + TTR (transthyretin); free T4 + T3 active. T3 binds nuclear thyroid receptor (TRα + TRβ) → DNA + cofactors → gene transcription; affects basal metabolic rate, thermogenesis, cardiac (chronotropy + inotropy + β-receptor expression), bone (turnover), CNS development, lipid metabolism, growth + maturation. Regulation: TRH (hypothalamus) → TSH (pituitary) → thyroid; T3/T4 negative feedback. **Testing**: - **Primary hypothyroidism**: ↑ TSH + ↓ FT4 (free T4). Subclinical: ↑ TSH + normal FT4. - **Primary hyperthyroidism**: ↓ TSH + ↑ FT4 ± ↑ FT3. Subclinical: ↓ TSH + normal FT4 + FT3. - **Secondary** (pituitary/hypothalamic): inappropriately normal/low TSH + ↓ FT4 (hypo) or ↑ FT4 with normal-↑ TSH (TSH-oma, T-resistance). - **Pregnancy**: ↑ TBG by estrogen → ↑ total T4 + T3; ↑ hCG cross-reacts TSH receptor → ↓ TSH 1st trimester normal. Trimester-specific TSH (< 2.5 1st; < 3.0 2nd-3rd) for hypo; hyperthyroid distinguish from gestational transient + Graves. - **Sick euthyroid (non-thyroidal illness, NTI)**: ↓ T3 (↑ rT3), normal/↓ TSH + FT4 (severe); usually do not treat — adapt to illness. - Anti-TPO + anti-Tg = Hashimoto. TRAb (TSH receptor Ab) = Graves. Tg as tumor marker post-DTC. - Imaging: thyroid US (nodule, malignancy risk by TI-RADS, suspicious features), RAIU (Graves diffuse high; toxic nodule single focal; thyroiditis low; ectopic struma ovarii — rare); fine needle aspiration for suspicious nodules by Bethesda system"},{"label":"C","text":"T3 = inactive metabolite"},{"label":"D","text":"TPO = inhibits hormone"},{"label":"E","text":"Free T4 always > total T4"}]'::jsonb,
  'B', 'Thyroid hormone physiology + testing interpretation = high-yield endocrine. (1) Synthesis steps: iodide trapping (NIS) → organification (TPO + H2O2 + Tg) → coupling (MIT/DIT → T3, T4) → storage (colloid) → secretion (proteolysis of Tg) → peripheral conversion (deiodinase). NIS blocked by anion competitors (perchlorate, thiocyanate, pertechnetate — diagnostic + therapeutic). TPO blocked by methimazole, PTU, propylthiouracil; iodide excess can transiently inhibit organification (Wolff-Chaikoff effect — used in Graves storm prep, AmiOdarone effect). (2) Plasma: 99.97% T4 + 99.7% T3 bound to TBG (75%), TTR + albumin. Free fraction active. TBG ↑: estrogen, OCP, pregnancy, tamoxifen, methadone, opioid, hepatitis; ↓: androgen, nephrotic, severe illness, glucocorticoid, asparaginase, deficiencies. (3) Conversion: T4 → T3 by 5''-deiodinase (D1 liver/kidney; D2 brain/pituitary; D3 inactive — fetal/placental). β-blocker propranolol blocks D1/D2. Amiodarone inhibits D1 → ↑ rT3. (4) Cellular action: TR (α + β isoforms) in nucleus binds T3 with high affinity, T4 low affinity → DNA TRE → gene transcription → BMR, cardiac, bone, CNS, lipid. Heart: ↑ HR, contractility, β-receptor density. Bone: ↑ turnover. (5) Regulation: TRH → TSH → thyroid; feedback. Subclinical = isolated TSH abnormality + normal free hormones. (6) Lab interpretation: - Subclinical hypothyroidism: ↑ TSH + normal FT4. Treat: pregnancy/planning, TSH > 10, anti-TPO+, symptoms, infertility, hyperlipidemia not at goal. TRUST trial — no symptom benefit in mild elderly. - Subclinical hyperthyroidism: ↓ TSH + normal FT4+FT3. Treat: TSH < 0.1 + age > 65 + osteoporosis + AF; observe mild. - Secondary hypothyroidism (pituitary): inappropriately normal/low TSH + ↓ FT4. Look for other pituitary axis (cortisol, gonadal, GH). Replace cortisol BEFORE T4 to prevent adrenal crisis. - Pregnancy: trimester-specific TSH (< 2.5 1st, < 3.0 2nd-3rd); ↑ LT4 dose 30% upon confirmation; gestational transient hyperthyroidism (hCG cross-reactivity) vs Graves; HCG mole + hyperemesis can cause transient hyperT. - NTI: ↓ T3 (↑ rT3), variable TSH, ↓ T4 in severe; usually don''t treat acute. - Drug effects: amiodarone (both hypo + hyper — Wolff-Chaikoff or Jod-Basedow), lithium (hypo), checkpoint inhibitor (auto), TKI (sunitinib, sorafenib — destruction), interferon (Hashimoto + Graves). - Antibodies: anti-TPO + anti-Tg (Hashimoto, sensitivity 95% + 50%); TRAb (Graves; helpful in ophthalmopathy without obvious hyper); thyroglobulin (post-DTC marker — should be undetectable). - Imaging: thyroid US (nodule); TI-RADS (suspicious: hypoechoic, microcalcification, taller-than-wide, irregular margin, extrathyroidal extension); FNA by Bethesda (I-VI; molecular for indeterminate III, IV — Afirma, ThyroSeq); RAIU (Graves diffuse 35-70%; toxic adenoma focal; toxic MNG patchy; thyroiditis low; iodine load suppresses).', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'internal_medicine', 'basic_science', 'endocrine_metabolic', 'adult',
  'Greenspan''s Basic + Clinical Endocrinology; ATA Hyperthyroidism + Hypothyroidism + DTC + Pregnancy Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'Resident เตรียมตอบ board: "กลไก thyroid hormone synthesis + action + regulation + thyroid testing interpretation?"'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident เตรียมตอบ board: "กลไก autoimmunity + tolerance + ทำไม SLE/RA/T1DM เกิด + emerging targeted immunotherapies?"', '[{"label":"A","text":"Autoimmunity คือ infection"},{"label":"B","text":"**Immunological tolerance** mechanisms: (1) Central — thymus negative selection of autoreactive T-cells via AIRE (autoimmune regulator gene; AIRE deficient = APS-1 with adrenal, hypopara, mucocutaneous candidiasis). (2) Central B-cell — bone marrow receptor editing + clonal deletion. (3) Peripheral — anergy, Treg (Foxp3+ regulatory T-cells; IPEX from FOXP3 mutation = severe early autoimmunity), antigen segregation, regulatory cytokines (TGF-β, IL-10), apoptosis. Breakdown → autoimmunity. Triggers: genetic (HLA — HLA-DR3/4 T1DM, HLA-B27 ankylosing spondylitis, HLA-DR15 MS, HLA-DR2/3 SLE), environmental (infection mimicry — Coxsackie/T1DM, GAS/rheumatic fever, Campylobacter/GBS), UV (SLE), drugs (procainamide → lupus), gut microbiome dysbiosis, stress, hormonal (female predominance via estrogen). **SLE**: type II + III hypersensitivity; dsDNA, Sm, RNP, SSA/B autoantibodies; immune complex deposition; complement activation (low C3/C4); diverse manifestations; B-cell, plasmacytoid DC + IFN signature key. **RA**: Th17 + cytokine (TNF, IL-6) driven joint inflammation; ACPA (anti-CCP) + RF; HLA-DR4 shared epitope. **T1DM**: T-cell mediated β-cell destruction; islet autoantibody (GAD65, IA-2, ZnT8, insulin Ab). **Targeted biologics by mechanism**: - Anti-TNF (etanercept, infliximab, adalimumab, certolizumab, golimumab) — RA, AS, IBD, psoriasis. - Anti-IL-6R (tocilizumab, sarilumab) — RA, GCA, CAR-T CRS, systemic JIA. - Anti-IL-17 (secukinumab, ixekizumab) — PsA, AS, psoriasis. - Anti-IL-23 (ustekinumab, risankizumab, guselkumab) — IBD, psoriasis. - Anti-CD20 (rituximab) — RA, AAV, lupus, NMO. - Anti-B cell BAFF (belimumab) — SLE, LN. - JAK inhibitor (tofacitinib, baricitinib, upadacitinib) — RA, UC, atopic dermatitis, alopecia areata. - Anti-α4β7 integrin (vedolizumab) — UC, CD. - Anti-IL-5 (mepolizumab, reslizumab, benralizumab) — eosinophilic asthma, EGPA. - Anti-CD25 (basiliximab) — transplant. - Anti-complement (eculizumab anti-C5, ravulizumab) — aHUS, PNH, MG, NMO. - CAR-T anti-CD19 (lifileucel emerging for SLE refractory). - Anti-thymic stromal (tezepelumab anti-TSLP) — asthma. - Anti-IgE (omalizumab) — allergic asthma, urticaria. - Targeted CRISPR + tolerance-inducing therapies — emerging"},{"label":"C","text":"Tolerance ไม่จำเป็น"},{"label":"D","text":"Anti-TNF for diabetes"},{"label":"E","text":"Rituximab works via TNF"}]'::jsonb,
  'B', 'Autoimmunity + tolerance + targeted immunotherapy. (1) Tolerance: - Central T-cell: thymus negative selection via AIRE-expressing medullary thymic epithelial cells; positive selection in cortex. - Central B-cell: bone marrow receptor editing, clonal deletion. - Peripheral T-cell: anergy (TCR without costim → unresponsive), Treg (Foxp3+ CD4+CD25+), antigen segregation (privileged sites), regulatory cytokines (TGF-β, IL-10), activation-induced cell death (AICD via Fas/FasL). - Peripheral B-cell: anergy, receptor editing, BAFF/BLyS-dependent survival. (2) Autoimmunity mechanism: tolerance breakdown — genetic + environmental. (3) Genetic: HLA association strongest — HLA-DR3/4 (T1DM, AIH), HLA-B27 (AS, reactive, IBD-associated), HLA-DR15 (MS), HLA-DR2/3 (SLE), HLA-B*5701 (abacavir HSR), HLA-B*1502 (carbamazepine SJS Asian), HLA-B*5801 (allopurinol SJS Asian); non-HLA — CTLA4, PTPN22, FCGR, IRF5, BLK. (4) Environmental triggers: infection (molecular mimicry — Coxsackie/T1DM, GAS/rheumatic fever, Campylobacter/GBS, EBV/MS + SLE), UV (SLE), drugs (procainamide/hydralazine/isoniazid → drug-induced lupus; anti-TNF → ANA+; checkpoint inhibitor irAEs), microbiome dysbiosis, smoking (RA — citrullination), stress, hormonal (female 9:1 SLE; estrogen). (5) Major diseases: - SLE: type II (cytotoxic) + III (immune complex); dsDNA, Sm, RNP, SSA/B; complement consumption (↓ C3/C4); B-cell + plasmacytoid DC + IFN-α driven; manifestations diverse (skin, joint, kidney, CNS, lung, cardiac, hematologic); HCQ + immunosuppressive + biologic (belimumab, anifrolumab anti-IFNAR, voclosporin LN, rituximab refractory). - RA: T-cell + B-cell + macrophage + synovial fibroblast; cytokines TNF, IL-6, IL-1; ACPA (anti-CCP) + RF; HLA-DR4 shared epitope; treat to target with MTX + biologic/JAKi. - T1DM: T-cell mediated β-cell loss; autoantibodies (GAD65, IA-2, ZnT8, insulin); HLA-DR3/4. Teplizumab (anti-CD3) delays clinical T1DM in high-risk autoantibody-positive relatives (Provention). - MS: T-cell + B-cell auto; DMT (covered). - Hashimoto: anti-TPO; thyroid B-cell + T-cell. - Graves: TSI agonist Ab activates TSHR; HLA-DR3. - MG: AchR Ab block + degrade. - Goodpasture: anti-GBM. - APS: aPL Ab; thrombosis + pregnancy loss. - IBD: Th17 + dysbiosis; biologics. - Psoriasis: Th17 + IL-23. - Ankylosing spondylitis: IL-17/23 axis; HLA-B27. (6) Targeted biologic + small molecule: cytokine (TNF, IL-6R, IL-17, IL-23, IL-1, IL-5), receptor (CD20, CD19, CD22, BAFF, integrin, complement), intracellular (JAK, BTK), CAR-T cell (lifileucel SLE emerging trials), tolerance-inducing therapies (low-dose IL-2 expand Treg, antigen-specific tolerance, gene editing). (7) Toxicity surveillance: infection (TB + HBV + HCV screening pre-anti-TNF; PCP prophylaxis; PML with rituximab + natalizumab; reactivation), malignancy (lymphoma — anti-TNF debatable), CV (JAKi label), autoimmune secondary (alemtuzumab → thyroid + ITP). (8) Vaccinations pre-immunosuppression: complete inactivated; avoid live; reduced response on biologic.', NULL,
  'medium', 'rheumatology', 'review',
  'internal_medicine', 'basic_science', 'rheumatology', 'adult',
  'Janeway''s Immunobiology; Abbas Cellular Immunology; ACR + EULAR Guidelines; TN10 Teplizumab NEJM 2019', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'Resident เตรียมตอบ board: "กลไก autoimmunity + tolerance + ทำไม SLE/RA/T1DM เกิด + emerging targeted immunotherapies?"'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident เตรียมตอบ board: "กลไก reading EKG — basics of axis, hypertrophy, ischemia, dysrhythmia interpretation?"', '[{"label":"A","text":"EKG interpretation = irrelevant"},{"label":"B","text":"**EKG systematic approach**: (1) Rate — 300/large box for regular; 6-sec strip × 10 for irregular. (2) Rhythm — sinus (P before each QRS, upright I/II/aVF inverted aVR) vs AF (irregularly irregular, no P), atrial flutter (sawtooth, 2:1 or 4:1), SVT, VT, junctional, AV block. (3) Axis — normal -30 to +90; LAD (-30 to -90) — LVH, LBBB, inferior MI, LAFB; RAD (+90 to +180) — RVH, PE, COPD, LPFB; extreme (-90 to -180). (4) Intervals — PR (120-200 ms; long > 200 = 1° AVB; short < 120 = WPW pre-excitation), QRS (< 120 ms; > 120 = BBB or VT), QT (corrected — Bazett QT/√RR; > 480 F, > 470 M concerning; long QT — congenital LQTS, drugs — sotalol, methadone, antipsychotic, ondansetron, antifungal — torsades risk). (5) P wave morphology — RAE (P pulmonale tall in II > 2.5 mm), LAE (P mitrale notched II > 110 ms or biphasic V1 > 1 mm × 40 ms). (6) QRS — LVH (Sokolow S V1 + R V5/6 > 35 mm; Cornell criteria; voltage criteria); RVH (R V1 > 7 mm, R/S V1 > 1); BBB (LBBB — RsR'' V5/6, broad notched I/aVL; RBBB — RsR'' V1, broad S I + V5/6); fascicular block. (7) ST segment — STEMI (≥ 1 mm 2 contiguous limb, ≥ 2 mm 2 contiguous precordial — NEW criteria: ≥ 1.5 mm V2-V3 women < 40; reciprocal changes); pericarditis (diffuse PR depression + STE concave); early repolarization (notched J wave); LBBB obscures ST (modified Sgarbossa criteria). (8) T wave — inversion (ischemia, RV strain, PE — S1Q3T3, intracranial hemorrhage, hypokalemia, electrolyte), peaked (hyperK), flattened (hypoK). (9) U wave — hypoK, drug effect. **MI localization**: anterior (V1-V4 — LAD), lateral (I, aVL, V5-V6 — circumflex), inferior (II, III, aVF — RCA mostly), posterior (V7-V9 reciprocal ST depression V1-V3; isolated posterior MI), right ventricular (V4R — inferior + RV; cautious nitrate). **Arrhythmia patterns**: AF, atrial flutter, AVNRT, VT (wide regular with AV dissociation, fusion + capture beats), VF (chaotic), torsades de pointes (polymorphic VT in long QT), Brugada (RBBB + V1-V3 ST elevation; SCN5A mutation; SCD risk; ICD), WPW (short PR + delta wave + wide QRS). EKG findings of: PE (S1Q3T3, RBBB new, sinus tachy), pericardial effusion (low voltage, electrical alternans), hypothermia (Osborn J wave), hyperK (peaked T → wide QRS → sine wave → arrest), digoxin (sagging ST, short QT, U wave)"},{"label":"C","text":"STEMI = NSTEMI"},{"label":"D","text":"Axis = irrelevant"},{"label":"E","text":"Long QT = benign"}]'::jsonb,
  'B', 'EKG interpretation — high-yield, daily clinical use. (1) Systematic approach (rate, rhythm, axis, intervals, chambers, ST, T, U). (2) STEMI criteria + reciprocal change + localization to coronary territory. (3) Hypertrophy (LVH Sokolow/Cornell; RVH). (4) BBB (LBBB obscures ST diagnosis — modified Sgarbossa criteria: concordant STE ≥ 1 mm, concordant STD ≥ 1 mm V1-V3, discordant STE ≥ 5 mm or ≥ 25% S wave for STEMI). (5) Long QT syndrome — congenital (LQT1-15; KCNQ1, KCNH2, SCN5A) or acquired (drugs, electrolyte) → torsades de pointes; QTc > 480 F, > 470 M concerning; > 500 high-risk; treat hypoK + hypoMg, discontinue offending drug, magnesium IV, isoproterenol or temporary pacing for bradycardia + long pause + torsades, ICD for high-risk congenital + secondary prevention. (6) Brugada syndrome — SCN5A; type 1 coved ST elevation V1-V2; SCD risk; ICD. (7) WPW — short PR + delta wave + wide QRS + ST/T abnormality; AVRT + AF (wide + irregular = pre-excited AF — dangerous, AVOID AV-blocker, use procainamide or DC cardioversion); ablation curative. (8) AV blocks — 1° (PR > 200), 2° Mobitz I (Wenckebach, progressive PR lengthening + dropped beat — usually AV nodal; benign), Mobitz II (constant PR + sudden drop — infranodal; pacemaker), 3° (CHB, complete AV dissociation, escape rhythm; pacemaker). (9) Tachycardias — sinus, atrial (PAC, MAT in COPD, AT), atrial flutter (sawtooth, often 2:1; cavotricuspid isthmus typical; ablation), AF (most common sustained), AVNRT (most common PSVT), AVRT, accelerated junctional, VT (monomorphic — scar; polymorphic torsades — long QT; idiopathic RVOT, idiopathic LV fascicular), VF (chaotic). (10) Bradycardias — sinus brady, sinus pause, sick sinus syndrome, AV block. (11) Other: PE (S1Q3T3, RBBB new, sinus tachy, T inversion V1-V4); pericarditis (diffuse concave STE + PR depression + spodick sign; vs early repolarization vs MI; serial EKG); hypothermia (Osborn J wave, bradycardia); hyperK (peaked T → flattened P → wide QRS → sine wave → asystole/VF; Ca + insulin + glucose + bicarb + dialysis); hypoK (flat T + U wave); digoxin (sagging ST, short QT, U wave, AV block, junctional escape, atrial tachy with block); BB/CCB toxicity (bradycardia, AV block); TCA (wide QRS + RAD + Brugada pattern; sodium bicarbonate).', NULL,
  'medium', 'cardiovascular', 'review',
  'internal_medicine', 'basic_science', 'cardiovascular', 'adult',
  'Goldberger''s Clinical Electrocardiography; ACC/AHA STEMI + NSTEMI + Bradycardia Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'Resident เตรียมตอบ board: "กลไก reading EKG — basics of axis, hypertrophy, ischemia, dysrhythmia interpretation?"'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident เตรียมตอบ board: "กลไก nephrotic vs nephritic syndrome + glomerular disease classification + treatment principles?"', '[{"label":"A","text":"Both syndrome the same"},{"label":"B","text":"**Nephrotic syndrome** (podocyte/GBM injury) features: heavy proteinuria > 3.5 g/24h (UPCR > 3-3.5), hypoalbuminemia < 3, edema, hyperlipidemia, hypercoagulability (loss of antithrombin etc.), infection risk (loss of Ig). Bland urine sediment (no RBC casts). Causes: - **Minimal change disease (MCD)**: children; podocyte foot process effacement EM only; idiopathic, secondary (NSAID, lithium, lymphoma); steroid responsive (1 mg/kg/d × 4-8 wk → taper); relapse common. - **FSGS**: scarring in some glomeruli; APOL1 + HIV + obesity + heroin secondary; collapsing variant aggressive; steroid + CNI + rituximab; recurrence post-transplant. - **Membranous nephropathy**: anti-PLA2R Ab (70%) or anti-THSD7A; subepithelial immune complex; spike-and-dome on EM; spontaneous remission 30%; rituximab preferred (MENTOR trial) vs CNI; cyclophosphamide (Ponticelli regimen) historical. - **Diabetic nephropathy**: Kimmelstiel-Wilson nodules; ACEi/ARB + SGLT2i + finerenone; tight glycemic. - **Amyloidosis** (AL, AA): Congo red apple-green birefringence; AL — bortezomib + dara + auto-SCT; ATTR — tafamidis, patisiran, vutrisiran. **Nephritic syndrome** (inflammation, glomerular hematuria): hematuria (dysmorphic RBC + RBC casts), proteinuria mild-moderate (< 3.5 g), hypertension, AKI, edema. Causes: - **IgA nephropathy (Berger)**: most common world; mesangial IgA deposit; gross hematuria during URI; SUPINE recommendation ACEi/ARB + supportive; budesonide (Tarpeyo, ileal release — NefIgArd) + sparsentan (anti-endothelin/Ang) + finerenone — emerging. - **Post-streptococcal GN**: weeks after GAS; immune complex; low C3 (transient); supportive; resolves. - **MPGN/C3GN**: complement-mediated; chronic; eculizumab in dense deposit + C3GN. - **Crescentic GN / RPGN**: AKI rapid; crescents > 50%; categories — anti-GBM (Goodpasture), pauci-immune (AAV — GPA, MPA, EGPA), immune complex (lupus, IgA, PIGN, MPGN). Treat with steroid + cyclophosphamide or rituximab ± PLEX. - **Lupus nephritis**: ISN/RPS classification I-VI; Class III/IV proliferative most severe; treat with MMF or CYC + steroid + belimumab + voclosporin. - **Alport syndrome**: COL4A3/4/5; hereditary; hematuria + sensorineural hearing loss + lenticonus; X-linked dominant. - **Thin basement membrane**: benign hematuria. Workup: UA + microscopy (RBC morphology + casts), UPCR/24-hr, ANA + dsDNA + complement + ANCA + anti-GBM + anti-PLA2R + cryoglobulin + HBV + HCV + HIV; kidney biopsy = gold standard for diagnosis + classification + prognosis"},{"label":"C","text":"Edema only in nephritic"},{"label":"D","text":"Hematuria diagnostic of nephrotic"},{"label":"E","text":"Biopsy never needed"}]'::jsonb,
  'B', 'Glomerular disease classification = nephrotic + nephritic + asymptomatic. KDIGO Glomerular Disease Guideline 2021. (1) Nephrotic (podocytopathy / GBM injury) classic features: massive proteinuria, hypoalbuminemia, edema, hyperlipidemia, hypercoag, infection risk. (2) Nephrotic causes adult: - Membranous (most common primary in adult, anti-PLA2R, subepithelial spike-dome) - FSGS (HIV, obesity, heroin, APOL1, collapsing variant) - Diabetic nephropathy - MCD - Amyloidosis (AL/AA) (3) Nephritic causes: - IgA nephropathy (mesangial IgA, post-URI gross hematuria) - Post-infectious GN (post-strep — low C3 transient) - MPGN / C3GN (complement-mediated) - Crescentic RPGN (anti-GBM, AAV, immune complex) - Lupus nephritis Class III/IV - Alport (COL4 mutations; hearing loss; lenticonus) (4) Workup: - History (HIV, HCV, HBV, drugs, family Hx, infections) - UA + microscopy (RBC dysmorphic + casts = glomerular) - UPCR (spot) or 24-hr urine protein + Cr - Serology: ANA + dsDNA + complement + ANCA + anti-GBM + anti-PLA2R + cryoglobulin + HBV + HCV + HIV + RPR + SPEP/UPEP + free light chain - Biopsy: definitive — light, IF, EM (5) Treatment principles: - Supportive: BP < 130/80 (ACEi/ARB anti-proteinuric), SGLT2i (DAPA-CKD, EMPA-KIDNEY — multiple etiologies), statin, sodium restriction, anticoagulation if nephrotic + albumin < 2.0-2.5 (especially membranous), diuretic for edema, vaccination. - Specific by histology: - MCD: steroid 1 mg/kg/d × 4-8 wk taper; relapses common — CNI, MMF, rituximab. - FSGS: steroid + CNI; rituximab + plasmapheresis for primary; treat underlying secondary. - Membranous: rituximab (MENTOR) preferred; CNI; cyclophosphamide (Ponticelli); spontaneous remission 30%. - Diabetic: ACEi/ARB + SGLT2i + finerenone; tight glycemic; weight; semaglutide (FLOW). - IgAN: ACEi/ARB + SGLT2i (DAPA-CKD); budesonide MMX (Tarpeyo, NefIgArd); sparsentan (PROTECT); steroid systemic for high-risk (controversial — TESTING trial harm); rituximab for crescentic. - Lupus nephritis Class III/IV: MMF + steroid ± belimumab/voclosporin; CYC alternative (covered). - Lupus nephritis Class V: MMF; CNI add-on. - AAV: steroid + RTX or CYC ± PLEX in selected (PEXIVAS). - Anti-GBM: PLEX + CYC + steroid; rapid; emergency. - Amyloid: targeted (covered). (6) Renal biopsy = standard for diagnosis + classification + prognosis in adult; not always in pediatric MCD (steroid trial); contraindications — bleeding diathesis, single kidney (relative), uncontrolled BP, infection.', NULL,
  'medium', 'renal_gu', 'review',
  'internal_medicine', 'basic_science', 'renal_gu', 'adult',
  'KDIGO Glomerular Disease Guideline 2021; Brenner & Rector''s The Kidney', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'Resident เตรียมตอบ board: "กลไก nephrotic vs nephritic syndrome + glomerular disease classification + treatment principles?"'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident เตรียมตอบ board: "กลไก pharmacokinetics + pharmacodynamics + dose adjustment in elderly + CKD + liver disease + drug-drug interaction?"', '[{"label":"A","text":"All drugs dose the same in all conditions"},{"label":"B","text":"**Pharmacokinetics (PK)**: ADME — Absorption (oral bioavailability F, gastric pH, gastric emptying, P-gp efflux), Distribution (Vd — total body water, protein binding, lipid solubility), Metabolism (Phase I CYP450 oxidation, Phase II conjugation — glucuronidation UGT, sulfation), Elimination (renal — filtration + tubular secretion; biliary; pulmonary). Half-life t½ = 0.693 × Vd / CL; steady state ~ 4-5 t½. **Pharmacodynamics (PD)**: dose-response relationship; receptor binding; efficacy + potency; therapeutic index = TD50/ED50. **Elderly**: ↓ lean mass (water-soluble drug Vd ↓ — digoxin, lithium dose ↓), ↑ fat (lipid-soluble Vd ↑ — benzo + diazepam accumulation), ↓ GFR (renal-cleared drug dose ↓ — antibiotic, DOAC, gabapentin, digoxin), ↓ hepatic blood flow + CYP activity (high extraction drug — propranolol, lidocaine — affected; phase I more than phase II), ↑ receptor sensitivity (benzo, opioid, anticholinergic), polypharmacy + interactions. **CKD**: estimate eGFR (CKD-EPI for adult; Cockcroft-Gault for some dose guides historically); avoid nephrotoxin (NSAID, aminoglycoside, contrast, vancomycin); dose adjust by eGFR — gabapentin, baclofen, allopurinol, digoxin, DOAC (apixaban OK lowest eGFR; rivaroxaban + edoxaban caution; dabigatran avoid), metformin (avoid eGFR < 30), opioid (morphine + meperidine metabolites accumulate; oxycodone + fentanyl preferred; methadone OK), antibiotics (LMW + LMWH, vancomycin, levofloxacin, pip-tazo, cefepime — neurotoxic in CKD high dose). **Liver disease**: phase I CYP affected first; metabolism + first-pass affected; serum albumin ↓ (increased free fraction for highly protein-bound — phenytoin, warfarin); avoid hepatotoxic (acetaminophen ceiling 2-3 g/d in cirrhosis; isoniazid; pyrazinamide; methotrexate; some statin; amiodarone; valproate; tetracycline). **Drug-drug interactions**: - CYP3A4 (most common): inhibitors — macrolide (clarithromycin, erythromycin), azole antifungal (ketoconazole, itraconazole, voriconazole), HIV PI, grapefruit juice, ritonavir, cobicistat, verapamil, diltiazem, amiodarone; inducers — rifampin, rifabutin, carbamazepine, phenytoin, phenobarbital, primidone, St. John''s wort, efavirenz. - CYP2D6 polymorphism: codeine + tramadol prodrug (ultra-rapid metabolizer = toxicity; poor = no effect). - CYP2C9: warfarin, phenytoin. - CYP2C19: clopidogrel (prodrug — poor metabolizer reduced effect — Asians higher prevalence). - P-gp: digoxin, DOAC; verapamil, amiodarone, clarithromycin inhibitors. - QTc additive: methadone + ondansetron + macrolide + azole antifungal + antipsychotic. - Serotonin syndrome: SSRI + tramadol + linezolid + MAOI + ondansetron + lithium + DXM + St. John''s wort. Drug interaction checker (Lexicomp, UpToDate, Liverpool HIV/HCV)"},{"label":"C","text":"Drug interactions ไม่มีจริง"},{"label":"D","text":"CYP irrelevant"},{"label":"E","text":"PK = same as PD"}]'::jsonb,
  'B', 'PK/PD + special populations + drug interactions = essential clinical pharmacology. (1) PK basics: - Absorption: gastric pH (PPI ↓ pH-dependent atazanavir, itraconazole, ketoconazole, iron); gastric emptying (opioid slows; metoclopramide accelerates); first-pass hepatic (high extraction — propranolol, lidocaine — affected by liver disease + hepatic blood flow); P-gp efflux at gut. - Distribution: Vd; total body water 60% adult, lower in elderly; lipid for lipophilic; protein binding (albumin acidic drugs; α1-acid glycoprotein basic drugs); free fraction = pharmacologically active. - Metabolism: Phase I — CYP450 oxidation/reduction/hydrolysis (3A4, 2D6, 2C9, 2C19, 1A2 major); Phase II — conjugation (UGT glucuronidation, SULT sulfation, NAT acetylation — slow vs fast acetylator polymorphism for INH, hydralazine). - Elimination: renal (filtration + secretion — OAT/OCT; reabsorption); biliary + enterohepatic recirculation; pulmonary. (2) Half-life t½ = ln 2 × Vd / Cl; steady state at 4-5 half-lives. Linear vs non-linear (phenytoin, salicylate, ethanol — zero order at therapeutic). (3) Elderly considerations: - ↓ TBW + lean mass: water-soluble drug Vd ↓ — lower dose of digoxin, lithium. - ↑ body fat: lipophilic Vd ↑ + ↑ t½ — benzo, fentanyl, propofol accumulate. - ↓ GFR (1 mL/min/yr after 30): renal drug dose adjustment. - ↓ hepatic blood flow + CYP activity (Phase I more than Phase II): high-extraction drugs affected. - ↑ pharmacodynamic sensitivity (CNS — benzo, opioid, anticholinergic cognitive). - Polypharmacy: average elderly on 5-10 drugs; interactions + adverse + non-adherence. - Beers criteria + STOPP/START for elderly inappropriate medication. (4) CKD: - eGFR (CKD-EPI 2021 race-free preferred for adult); Cockcroft-Gault still used for some dose adjustments historically. - Avoid nephrotoxin: NSAID, aminoglycoside, contrast, vancomycin/amphotericin/colistin overuse, tenofovir TDF (TAF better), tubulotoxic chemo. - Renal-cleared dose adjustment: gabapentin, baclofen, allopurinol, digoxin, DOAC (apixaban OK most CKD; rivaroxaban + edoxaban caution low eGFR; dabigatran avoid eGFR < 30), metformin (avoid eGFR < 30; caution < 45), antiviral, antibiotic, lithium. - Opioid: morphine + codeine metabolites accumulate (M3G, M6G — neurotoxic, sedating); meperidine normeperidine seizure; preferred fentanyl, oxycodone, methadone. - Dialysis: clearance varies by molecular weight, protein binding, Vd. (5) Liver disease: - Phase I affected first (CYP); Phase II later. - ↓ albumin (↑ free fraction phenytoin, warfarin, lidocaine; check free phenytoin). - First-pass ↓ → ↑ bioavailability of propranolol, lidocaine, morphine. - Hepatotoxic to avoid in cirrhosis: high-dose acetaminophen (limit 2-3 g/d), valproate, methotrexate, isoniazid, pyrazinamide (some), amiodarone, statin (caution but mostly OK in non-decompensated; rosuvastatin OK; rare ALT ↑), tetracycline (high IV doses fatal in pregnancy + cirrhosis), ergot, niacin. - Avoid sedative + opioid (HE precipitation). - Child-Pugh + MELD class guides drug avoidance. (6) Drug-drug interactions: - CYP3A4 inhibitor: macrolides (clarithro > erythro > azithro neutral), azole (keto, itra, vori, posa), HIV PI, ritonavir, cobicistat, grapefruit, verapamil, diltiazem, amiodarone, cimetidine. - CYP3A4 inducer: rifampin > rifabutin, carbamazepine, phenytoin, phenobarbital, primidone, St. John''s wort, EFV. - CYP2D6 polymorphism: codeine + tramadol prodrug; ultra-rapid metabolizer (Ethiopia, Saudi) — toxicity, esp pediatric tonsillectomy (FDA contraindicated < 12); poor (Asian, Caucasian) — no effect. - CYP2C9: warfarin (mostly), phenytoin. - CYP2C19: clopidogrel (prodrug — poor metabolizer reduced response; Asian higher prevalence; PPI omeprazole/esomeprazole can interact). - P-gp efflux: digoxin, DOAC, statin; verapamil + amiodarone + clarithro + cyclosporine inhibitors. - UGT polymorphism: irinotecan (UGT1A1 — Gilbert + East Asian neutropenia risk). - QTc prolonging drugs additive: macrolide + azole + methadone + haloperidol + ondansetron + sotalol + amiodarone + antipsychotic + TCA + SSRI (some) + fluoroquinolone (some). Avoid combination in long QT + hypoK + hypoMg. - Serotonin syndrome: SSRI + tramadol + linezolid + MAOI + DXM + St. John''s wort + ondansetron + lithium + meperidine + amphetamine. - HIT, allergy cross-reactivity (sulfa drugs), allopurinol + azathioprine (xanthine oxidase inhibition — purine accumulation, bone marrow). (7) Pharmacogenomics: HLA-B*1502 + carbamazepine (Asian SJS), HLA-B*5801 + allopurinol (Asian SJS), HLA-B*5701 + abacavir (HSR — screen routinely), DPYD + 5-FU/capecitabine toxicity, TPMT/NUDT15 + thiopurine, CYP2C19 + clopidogrel, CYP2D6 + codeine, CYP2C9 + warfarin, G6PD + oxidant drugs.', NULL,
  'hard', 'endocrine_metabolic', 'review',
  'internal_medicine', 'basic_science', 'endocrine_metabolic', 'elderly',
  'Goodman & Gilman''s Pharmacology; Atkinson''s Principles of Clinical Pharmacology; Beers Criteria 2023; KDIGO Drug Dosing in CKD', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'Resident เตรียมตอบ board: "กลไก pharmacokinetics + pharmacodynamics + dose adjustment in elderly + CKD + liver disease + drug-drug interaction?"'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทีมแพทย์โรงพยาบาลแห่งหนึ่งพบว่ามีอัตรา catheter-associated UTI (CAUTI) สูงในหอผู้ป่วยใน + ICU + ต้องการลดอัตรา nosocomial UTI ลง 50% ใน 6 เดือน

คำถาม: implement CAUTI prevention bundle ตาม CDC/IHI ใน healthcare system', '[{"label":"A","text":"ฉีดยาฆ่าเชื้อทุก catheter ทุกคน"},{"label":"B","text":"**CAUTI prevention bundle** (CDC/IHI quality improvement): (1) **Insertion**: appropriate indication (acute retention, accurate monitoring critically ill, surgical procedure, comfort end-of-life — NOT incontinence alone); aseptic insertion (sterile gloves, drape, antiseptic, single-use closed-system catheter); trained personnel; (2) **Maintenance**: closed drainage system; bag below bladder; secure catheter; daily hygiene; avoid manipulation; (3) **DAILY assessment for removal** — most important factor: nurse-driven removal protocol when no longer needed; clinician must justify indication daily; (4) Alternative to indwelling: external catheter (men), intermittent cath, bladder scan + delay; (5) Hand hygiene before/after; (6) Surveillance + feedback (CAUTI rate per 1000 catheter days); (7) Multidisciplinary team + education + audit; CUSP (Comprehensive Unit-based Safety Program); (8) Avoid antibiotic prophylaxis (selection pressure); (9) Treat ASB only in pregnancy + pre-urologic procedure (not indwelling cath unless symptomatic); (10) Catheter culture only when symptomatic UTI suspected — not for surveillance"},{"label":"C","text":"ให้ antibiotic prophylaxis ทุกคนที่ใส่ Foley"},{"label":"D","text":"เก็บ urine culture ทุก 3 วัน"},{"label":"E","text":"ปิด ward ที่มี CAUTI"}]'::jsonb,
  'B', 'CAUTI prevention — most common healthcare-associated infection; mortality + morbidity + cost. CDC HICPAC + IHI bundle + SHEA-IDSA + ANA recommendations. Key principle: most CAUTI prevented by AVOIDING unnecessary catheterization + DAILY removal assessment. Effective programs reduce by 50-70%. Components: appropriate indication, aseptic insertion, closed system, daily review, nurse-driven removal protocol, alternative methods (external, intermittent, bladder scan), surveillance feedback, education, multidisciplinary. NHSN definition for surveillance: positive urine culture + symptoms. Asymptomatic bacteriuria — do NOT treat (except pregnancy + pre-urologic). Antibiotic prophylaxis NOT recommended — selection pressure + resistance.', NULL,
  'easy', 'id', 'review',
  'internal_medicine', 'ems_mgmt', 'id', 'adult',
  'CDC HICPAC Guideline for Prevention of CAUTI 2009 + update; SHEA/IDSA 2014; IHI How-to Guide', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ทีมแพทย์โรงพยาบาลแห่งหนึ่งพบว่ามีอัตรา catheter-associated UTI (CAUTI) สูงในหอผู้ป่วยใน + ICU + ต้องการลดอัตรา nosocomial UTI ลง 50% ใน 6 เดือน

คำถาม: implement CAUTI prevention bundle ตาม CDC/IHI ใน healthcare system'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทีมพยาบาล + medical staff โรงพยาบาลแห่งหนึ่ง implement "Code Sepsis" program เพื่อปรับปรุง early recognition + treatment ของ sepsis + reduce mortality

คำถาม: components ของ effective sepsis early recognition + treatment system + Surviving Sepsis Campaign hour-1 bundle', '[{"label":"A","text":"Single physician decision-making"},{"label":"B","text":"**Code Sepsis / sepsis bundle system**: (1) Early recognition: screening tool (qSOFA, NEWS2, MEWS, electronic sepsis alerts, sepsis nurse alerts at triage) → activate Code Sepsis; (2) **Hour-1 bundle (SSC 2021)** initiate within 1 hour of recognition: - Measure lactate + remeasure if elevated. - Obtain blood cultures BEFORE antibiotics (if no delay > 45 min). - Broad-spectrum antibiotics within 1 hr. - 30 mL/kg crystalloid (balanced — RL/Plasma-Lyte preferred per SMART) for hypotension or lactate ≥ 4. - Vasopressor (norepinephrine first-line) if MAP < 65 despite fluid resuscitation. (3) Source control within 6-12 hr (abscess drain, foreign body remove, surgical etc.); (4) Ongoing: re-assess perfusion (lactate clearance, dynamic measures — PLR, SVV, IVC, US), de-escalate antibiotic per culture, vasopressor weaning, steroid (hydrocortisone 200 mg/d for vasopressor refractory — ADRENAL, APROCCHSS); (5) Multidisciplinary rapid response: ED + ICU + ward + pharm; (6) Quality metrics: bundle compliance, time-to-antibiotic, mortality, LOS — dashboards + feedback; (7) Education + simulation + protocolized order sets in EHR; (8) Survivorship: post-sepsis syndrome care (cognitive, functional, mental health follow-up — PICS); (9) Antimicrobial stewardship integrated (de-escalation, duration optimization)"},{"label":"C","text":"Antibiotic only after blood culture results"},{"label":"D","text":"Wait until septic shock"},{"label":"E","text":"Manual paper protocol only"}]'::jsonb,
  'B', 'Sepsis bundles + Code Sepsis programs — mortality reduction through early recognition + treatment. Surviving Sepsis Campaign 2021 + 2024 updates. Hour-1 bundle is critical metric. Early antibiotic within 1 hr saves lives (Kumar Crit Care Med — each hour delay ↑ mortality 7-13%). Balanced fluid (SMART, SALT-ED, BaSICS, PLUS trials) — modest benefit. Norepi first-line vasopressor; vasopressin add-on. Steroids for refractory shock. Source control + de-escalation + survivorship. Effective programs require multidisciplinary team, EHR-embedded alerts, education, ongoing feedback + accountability.', NULL,
  'medium', 'id', 'review',
  'internal_medicine', 'ems_mgmt', 'id', 'adult',
  'Surviving Sepsis Campaign 2021; CDC Hospital Sepsis Program Core Elements 2023', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ทีมพยาบาล + medical staff โรงพยาบาลแห่งหนึ่ง implement "Code Sepsis" program เพื่อปรับปรุง early recognition + treatment ของ sepsis + reduce mortality

คำถาม: components ของ effective sepsis early recognition + treatment system + Surviving Sepsis Campaign hour-1 bundle'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 88 ปี underlying advanced dementia, dependent ADL, recurrent aspiration pneumonia + hospitalization (3rd admission ใน 6 mo), severe functional decline. ครอบครัวต้องการคำแนะนำ goals-of-care + advance care planning

คำถาม: principle ของ palliative + goals-of-care discussion + advance directive ใน advanced dementia', '[{"label":"A","text":"Full code + aggressive interventions for all"},{"label":"B","text":"**Advance care planning + palliative care in advanced dementia**: (1) **Family meeting / shared decision-making**: assess understanding + values + goals (length of life vs quality of life vs comfort), preferences (NIH PrepareForYourCare framework, REMAP framework — Reframe, Expect emotion, Map values, Align, Plan); (2) Education re prognosis (advanced dementia 6-12 mo median survival; aspiration recurrence pattern); (3) Discuss options: aggressive + curative vs comfort-focused (palliative) vs hospice; (4) Honor patient''s previously stated wishes if any (advance directive, healthcare proxy); (5) Goals-concordant care: DNR/DNI orders + POLST (Physician Orders for Life-Sustaining Treatment — actionable orders for code status, hospitalization, antibiotics, artificial nutrition + hydration); (6) Advanced dementia specific decisions: artificial nutrition (PEG no benefit — does NOT prolong life or prevent aspiration; hand feeding preferred), antibiotic for pneumonia (limited benefit; palliative antibiotic for symptom control may be reasonable; declining aggressive Rx for recurrent infection); hospitalization vs home/SNF; (7) Symptom management: dyspnea (opioid, fan, oxygen if hypoxic), pain (often under-recognized in non-verbal — PAINAD scale), agitation (non-pharm first; antipsychotic last resort + black-box warning), constipation, oral care, pressure injury prevention; (8) Caregiver support — high burden + depression + grief; respite; education; bereavement; (9) Hospice referral (life expectancy < 6 mo); not synonymous with stopping care; (10) Documentation + communication across care settings; SNF + home care coordination"},{"label":"C","text":"PEG tube placement always"},{"label":"D","text":"Defer all discussions to surrogate"},{"label":"E","text":"Pursue all life-prolonging measures"}]'::jsonb,
  'B', 'Advanced dementia palliative care + ACP — high-yield ethics + geriatric topic. Mitchell NEJM 2009 + CAPC + AAHPM guidelines. Advanced dementia is terminal illness; median survival 6-12 mo after stage 7. (1) Shared decision-making: REMAP, Ariadne Labs Serious Illness Conversation Guide. (2) PEG tube no benefit — multiple RCTs + observational; does NOT prolong life, prevent aspiration (often increases reflux + aspiration); does NOT reduce pressure injury; risks: tube complications, restraints to prevent self-removal, pneumonia worse outcome, no QoL benefit. Hand feeding preferred. (3) Antibiotic recurrent pneumonia: limited benefit; palliative role for symptom control; involve goals-of-care. (4) POLST / MOLST — actionable medical orders for code status, hospital, ICU, antibiotic, artificial nutrition; travels with patient. (5) Hospice: Medicare-covered if life expectancy < 6 mo + comfort-focused. Different from palliative care (any stage, with curative). (6) Symptom management — pain (PAINAD, hospice-like approach), dyspnea, agitation, oral care, pressure care, mouth care. (7) Caregiver: respite, support group, bereavement, depression screen. (8) Documentation + transition. Antipsychotic for BPSD: black-box warning ↑ mortality + stroke; use last resort + lowest dose + shortest duration; brexpiprazole FDA approved 2023 for AD agitation.', NULL,
  'medium', 'geriatric', 'review',
  'internal_medicine', 'ems_mgmt', 'geriatric', 'elderly',
  'Mitchell SL NEJM 2009; AAHPM + CAPC Palliative Care Guidelines; Mitchell SL JAMA 2012 (PEG dementia)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 88 ปี underlying advanced dementia, dependent ADL, recurrent aspiration pneumonia + hospitalization (3rd admission ใน 6 mo), severe functional decline. ครอบครัวต้องการคำแนะนำ goals-of-care + advance care planning

คำถาม: principle ของ palliative + goals-of-care discussion + advance directive ใน advanced dementia'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ICU แพทย์ + พยาบาลกำลัง implement ICU liberation "ABCDEF" bundle (A2F bundle) เพื่อ improve outcomes

คำถาม: ส่วนประกอบของ ABCDEF bundle + ทำไม implementation รวมกันลด delirium + LOS + mortality', '[{"label":"A","text":"Single-component intervention"},{"label":"B","text":"**ABCDEF (A2F) bundle** = ICU Liberation Collaborative (SCCM): comprehensive evidence-based approach to reduce ICU-acquired weakness, delirium, PTSD, prolonged mechanical ventilation. (A) **Assess + manage + prevent pain**: standardized scale (BPS, CPOT, NRS); analgesia first (analgosedation) — opioid (fentanyl, morphine), non-opioid (acetaminophen, ketamine, gabapentinoid). (B) **Both SAT (Spontaneous Awakening Trial) + SBT (Spontaneous Breathing Trial)** daily — coordinated; SAT — daily sedation interruption; SBT — daily ventilator wean trial; ABC trial Lancet 2008 showed mortality reduction. (C) **Choice of analgesia + sedation**: avoid benzo (delirium ↑, prolonged vent); preferred dexmedetomidine + propofol; light sedation (RASS 0 to -2). (D) **Delirium assess, prevent + manage**: CAM-ICU, ICDSC q shift; non-pharm prevention (orientation, family, mobility, sleep, hearing aids, glasses, hydration, address sensory deprivation); pharm for severe agitation (haloperidol limited; quetiapine; dexmedetomidine for hyperactive); avoid benzo + anticholinergic. (E) **Early mobility + exercise**: PT/OT within 24-48 hr of ICU admission if stable; sit on bed → stand → walk; reduces ICU-AW, vent days, LOS, mortality. (F) **Family engagement + empowerment**: liberal visiting; family meetings; education; involve in care + decision-making; post-ICU syndrome prevention (cognitive + mental + physical). Effective bundle = > 60% compliance correlates with mortality reduction (ICU Liberation collaborative data). Multidisciplinary team — physician + nurse + RT + PT/OT + pharmacist + nutrition + family + patient"},{"label":"C","text":"Deep sedation throughout"},{"label":"D","text":"Bedrest until extubation"},{"label":"E","text":"Restrict family visiting"}]'::jsonb,
  'B', 'ICU Liberation ABCDEF bundle = SCCM evidence-based bundle reducing delirium, ICU-acquired weakness, post-intensive care syndrome. ICU Liberation Collaborative + Pun BT et al. studies. Each component evidence-based; bundle implementation > components alone. Major shift from deep sedation to light-as-possible + early mobilization. Benzo associated with delirium + ↑ mortality — minimize (dexmedetomidine or propofol preferred). Early PT/OT — reduces ICU-AW. Family presence reduces patient + family PTSD. Post-ICU syndrome (PICS): cognitive impairment, mental health (anxiety, depression, PTSD), physical disability — affects patient + family; prevention starts in ICU; survivorship clinic emerging.', NULL,
  'medium', 'respiratory', 'review',
  'internal_medicine', 'ems_mgmt', 'respiratory', 'adult',
  'SCCM ICU Liberation Bundle; Pun BT et al. Crit Care Med 2019; PADIS Guidelines 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ICU แพทย์ + พยาบาลกำลัง implement ICU liberation "ABCDEF" bundle (A2F bundle) เพื่อ improve outcomes

คำถาม: ส่วนประกอบของ ABCDEF bundle + ทำไม implementation รวมกันลด delirium + LOS + mortality'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้บริหารโรงพยาบาลพบว่า readmission rate ภายใน 30 วันสำหรับ heart failure สูง 22%. ผู้บริหารต้องการ implement transition-of-care program เพื่อลด readmission + improve outcomes

คำถาม: components ของ effective transition-of-care program สำหรับ HF', '[{"label":"A","text":"Discharge note alone"},{"label":"B","text":"**Transition-of-care program for HF readmission reduction**: (1) **Pre-discharge**: discharge planning starts at admission; multidisciplinary team (cardiology, nursing, pharmacy, social work, case management); patient education (HF self-management, weight monitoring, low-Na + fluid restriction, medication, when to call, recognize decompensation), teach-back method; optimize GDMT (ACEi/ARB/ARNI + BB + MRA + SGLT2i) before discharge; medication reconciliation; arrange post-discharge care; (2) **Discharge process**: written instructions in plain language + native language; medication list with reason + side effects; scheduled follow-up within 7 days (cardiology or PCP); home health if needed; cardiac rehab referral; (3) **Post-discharge**: telephone follow-up within 48-72 hr by nurse — symptom screen, medication adherence, BP, weight, questions; weight-based diuretic adjustment protocol; home telemonitoring (BP, weight, symptom) — selective; (4) **Outpatient continuity**: HF clinic specialty; titration of GDMT to target doses; MDT team-based care; (5) **Care coordination**: PCP communication, EHR documentation, structured discharge summary; (6) **Specific HF tools**: GDMT optimization protocol, diuretic dosing adjustment, BNP monitoring (controversial — GUIDE-IT neutral), CardioMEMS implantable PA pressure monitor (CHAMPION — reduced HF hosp); (7) **Patient + caregiver engagement** + literacy assessment; (8) **Address SDoH** (food security, transportation, housing, financial); (9) Palliative care for advanced HF; advance care planning; (10) Quality metrics: 30-d readmission, mortality, ED visits, compliance, patient experience"},{"label":"C","text":"Same discharge process for all patients"},{"label":"D","text":"No follow-up needed"},{"label":"E","text":"Antibiotic prophylaxis at discharge"}]'::jsonb,
  'B', 'HF transition of care — major focus of CMS HRRP (Hospital Readmissions Reduction Program). Effective programs reduce 30-day HF readmission 20-30%. Components from BOOST, Project RED, RED + AIDET frameworks. AHA + HFSA HF GDMT. Key elements: GDMT optimization before discharge (4 pillars), patient education, multidisciplinary, early follow-up < 7 d, telephone follow-up, home health, cardiac rehab, MDT outpatient, address SDoH. CardioMEMS implantable PA pressure for selected. Palliative + ACP. Quality metrics + accountability. Coleman''s 4 pillars of care transition: medication self-mgmt, patient-centered health record, follow-up, knowledge of red flags.', NULL,
  'easy', 'cardiovascular', 'review',
  'internal_medicine', 'ems_mgmt', 'cardiovascular', 'elderly',
  'AHA Scientific Statement on Care Transition in HF; Coleman EA Care Transitions; CMS HRRP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ผู้บริหารโรงพยาบาลพบว่า readmission rate ภายใน 30 วันสำหรับ heart failure สูง 22%. ผู้บริหารต้องการ implement transition-of-care program เพื่อลด readmission + improve outcomes

คำถาม: components ของ effective transition-of-care program สำหรับ HF'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'โรงพยาบาลกำลัง implement antimicrobial stewardship program (ASP). พบว่าการใช้ broad-spectrum antibiotic เพิ่มขึ้น + resistance rate เพิ่ม + C. difficile + cost ↑

คำถาม: core elements ของ effective hospital ASP', '[{"label":"A","text":"Limit ทุก antibiotic ทันที"},{"label":"B","text":"**Antimicrobial Stewardship Program (ASP) core elements** (CDC + IDSA/SHEA 2016 + WHO + Joint Commission): (1) **Leadership commitment**: institutional support, dedicated resources, accountability; (2) **Accountability**: physician leader (ID-trained typically) + pharmacist co-leader (PharmD with ID training); (3) **Drug expertise**: ID pharmacist, ID physician; (4) **Action items** = core interventions: - **Prospective audit + feedback** (PAF): pharmacist reviews broad-spectrum or high-cost antibiotic + recommends adjustments to prescriber. - **Pre-authorization** (formulary restriction): require approval for restricted antibiotics. - **Facility-specific treatment guidelines** for common infections (CAP, UTI, sepsis, surgical prophylaxis, asymptomatic bacteriuria — do NOT treat). - **De-escalation**: narrow spectrum + duration optimization based on culture/clinical response. - **Antibiotic time-outs**: 48-72 hr reassessment by prescriber. - **IV-to-PO switch**: criteria-based when stable + GI absorption intact. - **Allergy reassessment**: penicillin allergy de-labeling (90% \"penicillin allergic\" tolerate). (5) **Tracking**: usage (DDD per 1000 patient-days, days of therapy DOT), resistance patterns (antibiogram annual), C. difficile rate, adverse events, cost, outcomes; (6) **Reporting**: feedback to prescribers + leadership + clinical area; (7) **Education**: prescribers + nurses + pharm + patients + family; (8) **Diagnostic stewardship**: appropriate culture indication, NOT for asymptomatic, MALDI-TOF rapid identification, PCR multiplex syndromic panel, procalcitonin (lower respiratory tract — limited utility outside select). (9) Mortality + outcome neutral or improved while reducing CDI + resistance + cost. Pillar of value-based care + public health"},{"label":"C","text":"Single physician interpretation of every culture"},{"label":"D","text":"No tracking of usage"},{"label":"E","text":"Discontinue all antibiotic in 24 hr regardless"}]'::jsonb,
  'B', 'Antimicrobial Stewardship Program — required by Joint Commission since 2017; CDC Core Elements. Reduces inappropriate antibiotic use, CDI, resistance, cost while maintaining/improving outcomes. ID + pharmacist co-leadership. Prospective audit + feedback most evidence-based; pre-authorization for restricted; facility guidelines + clinical pathways; de-escalation + duration optimization; IV-to-PO; antibiotic time-out 48-72 hr; penicillin allergy de-labeling (90% tolerate after evaluation/skin test/test dose). Diagnostic stewardship: avoid inappropriate culture, rapid identification (MALDI-TOF), multiplex PCR + Film Array — guide therapy. Tracking: DDD, DOT, resistance, CDI rate. Education + accountability + leadership commitment essential. ASP effective in reducing CDI 30%, resistance, cost.', NULL,
  'medium', 'id', 'review',
  'internal_medicine', 'ems_mgmt', 'id', 'adult',
  'CDC Core Elements of Hospital ASP 2019; IDSA/SHEA Antibiotic Stewardship 2016; WHO Antimicrobial Stewardship Toolkit', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'โรงพยาบาลกำลัง implement antimicrobial stewardship program (ASP). พบว่าการใช้ broad-spectrum antibiotic เพิ่มขึ้น + resistance rate เพิ่ม + C. difficile + cost ↑

คำถาม: core elements ของ effective hospital ASP'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident อายุ 28 ปี กำลังปฏิบัติงาน night shift ครั้งที่ 5 ติดต่อกัน นอนน้อย + เครียดสูง + พบ medical error ในการเขียน order ของผู้ป่วย — ผู้ป่วยปลอดภัยแต่เกิด near-miss event

คำถาม: principles of patient safety + handling medical error + just culture', '[{"label":"A","text":"Blame + punish individual"},{"label":"B","text":"**Patient safety + just culture approach**: (1) **Disclosure**: be honest with patient + family about error (if patient harmed); apologize + transparency — multiple studies show reduces litigation + improves trust; \"Sorry program\" + Communication + Resolution Programs (CRP); (2) **Reporting**: confidential incident reporting system (RL Solutions, etc.); near-miss + adverse event; protected from punishment for honest reporting; (3) **Root cause analysis (RCA)**: \"5 whys\" + Fishbone + systems thinking; identify latent error in system (workflow, communication, fatigue, education, technology, EHR, handoff) not just individual; (4) **Just culture** framework (Marx): distinguish - Human error (slip, lapse, mistake) → console + system fix. - At-risk behavior (drift from procedure for perceived benefit) → coach + retrain. - Reckless behavior (conscious disregard) → discipline. (5) **Systems improvement**: CPOE + decision support + alerts, double-check + read-back for high-risk orders, standardization, checklists (WHO surgical, central line — Pronovost), bundles, simulation, FMEA, lean, six sigma; (6) **Resident wellness + fatigue**: ACGME duty hours, sleep, mental health support; physician burnout + 2nd victim phenomenon (caregiver harm after adverse event); EAP; debriefing; peer support; (7) **High reliability organization** (HRO) principles: preoccupation with failure, reluctance to simplify, sensitivity to operations, commitment to resilience, deference to expertise; (8) Continuous improvement + QI projects + dashboards + feedback; (9) Leadership + safety culture survey; (10) Patient + family engagement in safety; PFAC (patient + family advisory council); shared decision-making"},{"label":"C","text":"Hide the error"},{"label":"D","text":"Sue the patient first"},{"label":"E","text":"Ignore systems issues"}]'::jsonb,
  'B', 'Patient safety + just culture = core healthcare quality. To Err is Human (IOM 1999) — preventable medical errors major cause of death; estimates ~ 100K-400K annual US. Just Culture (David Marx): distinguishes human error (system fix), at-risk behavior (coaching), reckless (discipline). Encourages reporting. RCA + systems thinking. Disclosure + apology + CRP — reduces litigation + improves trust + healing. CPOE with decision support + double-check + standardization + checklist + bundle reduces error. Second victim: clinician psychological harm after adverse event — needs support (EAP, peer support, debriefing). HRO principles (Weick + Sutcliffe). Burnout: emotional exhaustion + depersonalization + ↓ accomplishment; affects 30-50% of physicians; impact on safety + quality + retention. ACGME duty hours. Patient + family engagement.', NULL,
  'easy', 'psych_behavior', 'review',
  'internal_medicine', 'ems_mgmt', 'psych_behavior', 'adult',
  'IOM To Err is Human 1999; AHRQ Patient Safety Network; Marx D Just Culture; WHO Patient Safety', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'Resident อายุ 28 ปี กำลังปฏิบัติงาน night shift ครั้งที่ 5 ติดต่อกัน นอนน้อย + เครียดสูง + พบ medical error ในการเขียน order ของผู้ป่วย — ผู้ป่วยปลอดภัยแต่เกิด near-miss event

คำถาม: principles of patient safety + handling medical error + just culture'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย admit หลัง STEMI primary PCI ใน CCU + กำลัง implement "door-to-balloon" (D2B) time monitoring + รพ. ต้องการลด D2B time < 90 นาที + cardiac arrest team

คำถาม: ส่วนประกอบของ STEMI care system regional + RACE program (Regional STEMI program) + ทำไม time-to-treatment critical', '[{"label":"A","text":"Patient stays in any hospital regardless of capability"},{"label":"B","text":"**STEMI care system / regional program**: time-critical — \"time is muscle\"; goal D2B < 90 min in PCI-capable hospital, D2B < 120 min including transfer; door-to-fibrinolysis < 30 min if PCI > 120 min away. Components: (1) **Pre-hospital**: EMS 12-lead EKG, advance notification of STEMI alert + activate cath lab during transport; bypass ED in some systems (\"hub-and-spoke\"); D2B clock starts at first medical contact; (2) **Regional system**: PCI-capable centers receive STEMI patients from non-PCI hospitals; rapid transfer; established protocols; RACE (Reperfusion of Acute MI in North Carolina) successful model; ESC + AHA STEMI systems of care; (3) **In-hospital STEMI activation**: single-call activation; cath lab team mobilized; bypass ED for direct cath lab in some systems; preserve LV — \"time is muscle\" — every 30 min delay associated with ↑ 1-yr mortality; (4) **Reperfusion strategy**: primary PCI preferred if within 90-120 min; fibrinolysis if delay anticipated > 120 min then transfer; rescue PCI for failed lysis; (5) **Pharmacologic**: ASA + P2Y12 (ticagrelor/prasugrel/clopidogrel) loading, anticoagulation, statin, BB; (6) **Quality metrics**: D2B time, in-hospital mortality, 30-d mortality, readmission, GDMT compliance at discharge, cardiac rehab referral; (7) **Post-PCI**: CCU/ICU monitoring 24 hr, secondary prevention (DAPT, statin, BB, ACEi/ARB if HF/HT/DM, MRA if LVEF < 40, smoking cessation, cardiac rehab), reassess LVEF at 3 mo for ICD evaluation; (8) **NSTEMI + UA**: similar systems for early invasive strategy; (9) ACS-OOH cardiac arrest: targeted temperature management, urgent coronary angiography selected (TOMAHAWK + COACT); (10) Multidisciplinary feedback + continuous improvement"},{"label":"C","text":"Wait for clinic appointment"},{"label":"D","text":"No transfer regional system"},{"label":"E","text":"Aspirin alone for STEMI"}]'::jsonb,
  'B', 'STEMI systems of care — regional + hub-and-spoke models reduce mortality. D2B < 90 min Class I; D2B including transfer < 120 min. AHA Mission: Lifeline + ESC + AHA STEMI guideline. Pre-hospital EKG + activation by EMS (cath lab activation during transport) reduces D2B by 30-60 min. Single-call activation. Bypassing ED in selected. Primary PCI preferred reperfusion; fibrinolysis if not possible within window. Pharmacologic + reperfusion + secondary prevention. Quality metrics + accountability + continuous improvement. NCDR/Mission Lifeline registries. ACLS for cardiac arrest. Post-PCI: secondary prevention. NSTEMI early invasive. RACE program in NC = exemplar regional system.', NULL,
  'medium', 'cardiovascular', 'review',
  'internal_medicine', 'ems_mgmt', 'cardiovascular', 'adult',
  'AHA Mission: Lifeline STEMI Systems of Care; ACC/AHA STEMI Guideline 2013 (update 2023); RACE Program NC', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ผู้ป่วย admit หลัง STEMI primary PCI ใน CCU + กำลัง implement "door-to-balloon" (D2B) time monitoring + รพ. ต้องการลด D2B time < 90 นาที + cardiac arrest team

คำถาม: ส่วนประกอบของ STEMI care system regional + RACE program (Regional STEMI program) + ทำไม time-to-treatment critical'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เกิด outbreak ของ MDR organism (CRE) ในหอผู้ป่วยใน แพร่ไป 8 รายใน 4 สัปดาห์ + suspected เกิดจาก inadequate infection control + improper environmental cleaning

คำถาม: outbreak investigation + infection prevention + control (IPC) response', '[{"label":"A","text":"Ignore outbreak + continue normal operation"},{"label":"B","text":"**Outbreak investigation + IPC response (CDC + WHO + Thai DDC)**: (1) **Confirm outbreak**: define case (microbiologic + clinical + temporal); compare to baseline rate; epidemic curve; environmental sampling; molecular typing (PFGE, WGS) to confirm clonality; (2) **Cohorting + isolation**: place infected/colonized patients in contact precaution + dedicated cohort if multiple; private room with private bathroom; gown + glove + dedicated equipment + handwashing (soap + water for CDI; alcohol OK for others); (3) **Active surveillance** of contacts: rectal/perirectal swab for CRE screening on contacts + admitted patients in unit; (4) **Environmental cleaning**: enhanced cleaning (bleach 1:10 for CDI; environmental hygiene), terminal cleaning + UV-C disinfection or hydrogen peroxide vapor for confirmed positive room; monitor cleaning compliance (ATP, fluorescent marker); (5) **Antimicrobial stewardship**: reduce broad-spectrum antibiotic + carbapenem use (selection pressure); use carbapenem-sparing regimens; consult ID for case management; (6) **Hand hygiene** audit + feedback + posted reminders; alcohol-based hand rub at point of care; (7) **Staffing + workload**: avoid sharing between cohort + non-cohort if possible; train + educate; PPE supply; (8) **Devices + procedure**: minimize indwelling devices; aseptic technique; sterile processing audit; endoscope reprocessing audit; (9) **Reporting**: notifiable to public health (Thai DDC + WHO IHR for emerging MDR); communicate to receiving facility if transferred; (10) **Multidisciplinary team**: IPC + ID + microbiology + administration + nursing + housekeeping + lab; daily incident command; (11) **Post-outbreak**: continued surveillance, sustained policy change, education, simulation, root cause analysis + corrective action plan; (12) Patient + family education + decolonization strategies (limited evidence for CRE)"},{"label":"C","text":"Treat each patient independently"},{"label":"D","text":"Antibiotic prophylaxis all staff"},{"label":"E","text":"Close hospital permanently"}]'::jsonb,
  'B', 'Outbreak investigation + IPC = essential public health competency. CDC + WHO + ICN IPC guidelines. Steps: confirm outbreak (case definition, epidemic curve, baseline), descriptive epidemiology, hypothesis, analytic study, molecular typing (PFGE, WGS), environmental sampling, cohorting + isolation, hand hygiene, environmental cleaning + disinfection, antimicrobial stewardship, reporting + notification, education, audit, corrective action. CRE = global health threat; Thailand + SE Asia rising prevalence. Key control: surveillance, contact precaution, hand hygiene, antimicrobial stewardship, environmental cleaning. Cohorting + dedicated staff if multiple. Active screening of contacts to detect colonized. Multidisciplinary team. Notifiable disease + public health reporting. Post-outbreak sustained surveillance + policy + culture change.', NULL,
  'medium', 'id', 'review',
  'internal_medicine', 'ems_mgmt', 'id', 'adult',
  'CDC Healthcare Infection Control Practices Advisory Committee (HICPAC); WHO IPC Guidelines; SHEA Outbreak Investigation', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'เกิด outbreak ของ MDR organism (CRE) ในหอผู้ป่วยใน แพร่ไป 8 รายใน 4 สัปดาห์ + suspected เกิดจาก inadequate infection control + improper environmental cleaning

คำถาม: outbreak investigation + infection prevention + control (IPC) response'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital implementing medication reconciliation process ที่ admission + discharge + transfers to reduce medication errors + adverse drug events

คำถาม: ส่วนประกอบของ effective medication reconciliation', '[{"label":"A","text":"Skip medication review"},{"label":"B","text":"**Medication reconciliation** (Joint Commission NPSG.03.06.01): formal process to compare patient''s current medications with newly ordered to prevent omissions, duplications, dosing errors, interactions, allergies. Steps: (1) Obtain comprehensive medication history at admission — patient + family + caregiver interview + pharmacy records + EHR + medication bottle review (\"brown bag\"); include prescription, OTC, supplements, herbal, marijuana, recreational; (2) **Verify** dose, frequency, route, last dose, indication, response, allergies + reactions; (3) **Compare to new orders + reconcile**: continue, modify, discontinue, hold; document rationale; (4) **Communicate**: discharge medication list with reason + side effects; patient + family + receiving provider; teach-back; (5) **Discharge**: review with patient + family in plain language; medication list provided + sent to PCP within 48 hr; (6) **Special situations**: NPO + restart, surgery, ICU transitions, transfer between facilities, transitions of care most error-prone; (7) **Pharmacist-led** medication reconciliation reduces errors > 40-70%; (8) **High-risk medications**: anticoagulant, insulin, opioid, anti-rejection, antiplatelet, antiepileptic, immunosuppressive — extra vigilance + ISMP high-alert medications protocols; (9) **CPOE + decision support**: electronic systems with alerts for duplicates + interactions + allergies + dosing; (10) **Deprescribing** in elderly: STOPP/START criteria + Beers; address polypharmacy; (11) **Monitoring**: AE reporting, ADR pharmacovigilance, medication error rate, near-miss; (12) **Quality metrics**: med reconciliation completion rate at admission + discharge + transition"},{"label":"C","text":"Single nurse documentation"},{"label":"D","text":"No discharge counseling"},{"label":"E","text":"OTC drugs not part of reconciliation"}]'::jsonb,
  'B', 'Medication reconciliation — Joint Commission NPSG + IHI 5-Million Lives Campaign + WHO High 5s. Prevents 30-40% of medication errors. Critical at transitions of care: admission, transfer, discharge — highest error risk. Pharmacist-led most effective. Includes prescription + OTC + supplements + herbal + recreational. Brown-bag medication review at home. EHR + CPOE + decision support — reduce interaction + duplicate + allergy errors. High-alert medications (ISMP list — anticoag, insulin, opioid, neuromuscular blocker, immunosuppressive, etc.) require extra protocols. Deprescribing in elderly polypharmacy: STOPP/START, Beers criteria; review at every visit. Teach-back at discharge. Patient + caregiver education. Quality metrics + accountability.', NULL,
  'easy', 'geriatric', 'review',
  'internal_medicine', 'ems_mgmt', 'geriatric', 'adult',
  'Joint Commission NPSG.03.06.01; IHI Medication Reconciliation; WHO High 5s; ISMP High-Alert Medications', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'Hospital implementing medication reconciliation process ที่ admission + discharge + transfers to reduce medication errors + adverse drug events

คำถาม: ส่วนประกอบของ effective medication reconciliation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทีมโรงพยาบาลกำลัง implement delirium prevention bundle in elderly hospitalized patients

คำถาม: components ของ delirium prevention + management', '[{"label":"A","text":"Sedation alone"},{"label":"B","text":"**Delirium prevention + management** (HELP = Hospital Elder Life Program; ABCDEF in ICU): non-pharmacologic multicomponent intervention preferred. (1) **Identify risk**: age > 65, dementia, prior delirium, severe illness, polypharmacy, sensory impairment, immobility, dehydration, malnutrition, infection, sleep deprivation; (2) **Non-pharm bundle**: - Orientation: clock, calendar, family photos, reorient verbally + caregivers, white board with date + names. - Sleep + circadian: minimize nighttime interruption, dim light at night, earplug + eye mask, no naps daytime, daytime light. - Mobilize early: out of bed within 24-48 hr, PT/OT, ambulate, avoid restraints + Foley. - Sensory: hearing aids, glasses, dentures available. - Hydration + nutrition: PO when safe, adequate fluid + nutrition assessment. - Family + visitors: companion presence. - Pain control: scheduled analgesic; avoid undertreated pain. - Cognitive activity: conversation, puzzles, reorientation games. (3) **Avoid precipitants**: anticholinergic, benzo, opioid (high-dose), antipsychotic, antihistamine (diphenhydramine), tricyclic, polypharmacy; constipation, urinary retention, electrolyte (Na, Mg, Ca, glucose), hypoxia, infection (UTI, pneumonia), pain, dehydration, sleep deprivation, sensory deprivation; (4) **Screening tools**: CAM (Confusion Assessment Method), CAM-ICU, 4AT (rapid bedside screen); routine screening q shift; (5) **Treatment of established delirium**: address underlying precipitant; supportive non-pharm; pharm only for severe agitation + dangerous behavior — low-dose haloperidol 0.25-0.5 mg or quetiapine 12.5-25 mg; avoid benzo (worsens; exception alcohol/benzo withdrawal); avoid restraints; (6) **Discharge + follow-up**: persistent post-hospital cognitive impairment common; cognitive rehab; family support; (7) **Hospitalization avoidance** in advanced dementia where appropriate; (8) **Outcomes affected**: ↑ mortality, ↑ LOS, ↑ institutionalization, ↑ functional decline, ↑ dementia development; preventable"},{"label":"C","text":"Restraint for safety"},{"label":"D","text":"Routine benzo PRN"},{"label":"E","text":"Diphenhydramine for sleep"}]'::jsonb,
  'B', 'Delirium = acute change in attention + cognition; multifactorial; preventable. Hospital Elder Life Program (HELP, Inouye) + ABCDEF bundle (ICU) = evidence-based multicomponent prevention. Reduces incidence by 30-40%. Key: non-pharm multicomponent — orientation, sleep, mobilization, sensory, hydration, family. Avoid precipitants: anticholinergic, benzo (worsens delirium), opioid high-dose, anti-PD, antipsychotic. Treat underlying. Pharm only for severe agitation/danger — low-dose haloperidol or atypical (quetiapine); avoid benzo except alcohol withdrawal. Screen routinely (CAM, 4AT). Persistent post-hospital cognitive impairment common — long-term sequelae; affects mortality + LOS + institutionalization + dementia progression. Geriatric consultation + interdisciplinary team.', NULL,
  'easy', 'geriatric', 'review',
  'internal_medicine', 'ems_mgmt', 'geriatric', 'elderly',
  'Inouye SK HELP NEJM 1999; AGS Geriatrics Care Online; SCCM PADIS Guideline 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ทีมโรงพยาบาลกำลัง implement delirium prevention bundle in elderly hospitalized patients

คำถาม: components ของ delirium prevention + management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทีมพยาบาล + แพทย์กำลัง implement structured handoff (SBAR or I-PASS) to reduce errors at shift change

คำถาม: components + benefits of structured handoff', '[{"label":"A","text":"No structured process"},{"label":"B","text":"**Structured handoff** prevents communication errors at care transitions (shift, ICU-to-ward, OR-to-ICU, transfer). (1) **SBAR**: Situation (what''s happening), Background (context, history), Assessment (clinical assessment + concern), Recommendation (what''s needed). Concise, focused, action-oriented. (2) **I-PASS** (Stanford pediatric): Illness severity, Patient summary, Action list, Situational awareness + contingency, Synthesis by receiver. STARFISH or 5P also used. (3) **Components of effective handoff**: face-to-face when possible; standardized template; minimum interruption; verify with read-back; current + accurate information; allow time for questions; documentation; (4) **Evidence**: I-PASS implementation studies show 30% reduction in preventable adverse events (Starmer NEJM 2014 — pediatric, replicated other specialties); SBAR widely adopted; (5) **Multidisciplinary**: nursing + physician + RT + pharmacy; cross-discipline; (6) **Transition-specific handoffs**: ED-to-floor (5P or specific), OR-to-PACU, OR-to-ICU, ICU-to-floor (de-escalation), shift change, sign-out (cross-cover lists with pending tasks + anticipated issues + contingency plans); (7) **Avoid**: rushed handoff, distractions, incomplete data, vague language, missing handover at high-risk transitions; (8) **Training**: simulation, communication skills, TeamSTEPPS + CRM principles; (9) **EHR-supported**: standardized templates, structured sign-out tools, sign-out lists (electronic); (10) **Patient + family involvement** in handoff at admission + transfer + discharge — Patient + Family Centered I-PASS adaptation"},{"label":"C","text":"Unstructured verbal only"},{"label":"D","text":"Skip questions"},{"label":"E","text":"Single person sign-out"}]'::jsonb,
  'B', 'Structured handoff = key patient safety intervention. SBAR + I-PASS most studied. I-PASS NEJM 2014 (Starmer + Landrigan) — 30% reduction preventable adverse events. SBAR clinical communication standard. Joint Commission NPSG handoff requirements. WHO High 5s. Components: standardized, face-to-face, minimum interruption, verify with read-back, complete + accurate, allow Q&A. Multidisciplinary: nursing + physician + RT + pharmacy. Transition-specific. EHR support. TeamSTEPPS + CRM (crew resource management) principles. Patient + family involvement. Improves accuracy, reduces error, prevents adverse events, increases safety culture.', NULL,
  'easy', 'psych_behavior', 'review',
  'internal_medicine', 'ems_mgmt', 'psych_behavior', 'adult',
  'I-PASS Starmer A et al. NEJM 2014; SBAR + TeamSTEPPS AHRQ; Joint Commission NPSG', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ทีมพยาบาล + แพทย์กำลัง implement structured handoff (SBAR or I-PASS) to reduce errors at shift change

คำถาม: components + benefits of structured handoff'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 76 ปี on 9 chronic medications (ASA, statin, BB, ACEi, metformin, gabapentin, amitriptyline, diphenhydramine, alprazolam) มา OPD ด้วย confusion + fall + orthostatic hypotension + recent admission

คำถาม: deprescribing approach + identify potentially inappropriate medications (PIMs)', '[{"label":"A","text":"Continue all medications"},{"label":"B","text":"**Deprescribing + polypharmacy review** (Beers Criteria 2023 + STOPP/START 2024): (1) **Identify PIMs**: - **Anticholinergic** (diphenhydramine, amitriptyline) → cognitive impairment, fall, confusion, urinary retention, dry mouth — DEPRESCRIBE; switch amitriptyline (for neuropathic) to duloxetine or gabapentin alone; switch diphenhydramine for sleep to non-pharm + melatonin/trazodone. - **Benzodiazepine** (alprazolam) → fall, cognitive impairment, dependence — taper slowly (10% q 1-2 wk); CBT-I for insomnia; gradually replace. - **Tricyclic** (amitriptyline) — anticholinergic + cardiac + fall risk. (2) **STOPP** (Screening Tool of Older People''s Prescriptions): potentially inappropriate prescriptions to STOP. **START** (Screening Tool to Alert to Right Treatment): potentially appropriate to START in elderly. (3) **Beers Criteria 2023**: list of PIMs; categories — avoid generally, avoid in specific conditions, use with caution, drug-drug interaction. (4) **Approach**: prioritize highest-risk PIMs; one change at a time; assess effectiveness + adverse + symptoms; involve patient + family in shared decision-making; reconcile at every transition. (5) **Medication review tools**: MAI (Medication Appropriateness Index), Beers, STOPP/START. (6) **Deprescribing algorithms** (Scott et al.): identify, ascertain medication, assess risk-benefit, prioritize, taper, monitor. (7) **High-risk drugs in elderly**: benzo, opioid (high-dose), anticholinergic, NSAID, antiplatelet + anticoagulant combo, sulfonylurea (hypoglycemia), digoxin (high dose). (8) **Address underlying**: pain (non-pharm + acetaminophen + topical), sleep (CBT-I + sleep hygiene), depression (SSRI safer than TCA in elderly). (9) **Communicate with PCP** + patient + family; education on rationale; monitor adverse withdrawal. (10) **Outcomes**: reduce fall, hospitalization, cognitive decline, adverse drug events"},{"label":"C","text":"Add more medications"},{"label":"D","text":"Replace all medications new"},{"label":"E","text":"Stop all medications abruptly"}]'::jsonb,
  'B', 'Polypharmacy + deprescribing — essential geriatric. Beers Criteria 2023 (AGS) + STOPP/START 2024 (O''Mahony) major frameworks. Polypharmacy = ≥ 5 chronic medications; harmful adverse drug events + interactions + falls + cognitive impairment + non-adherence + cost. Approach: comprehensive medication review at every visit + transition; identify PIM + risk-benefit reassessment; deprescribing algorithm; prioritize one change at a time + monitor; address underlying with non-pharm + safer alternatives; communicate + involve patient + family. High-risk drugs in elderly: benzo, anticholinergic, opioid, NSAID, antipsychotic, sulfonylurea, digoxin. Replace with safer alternatives (non-pharm sleep + CBT-I; SSRI > TCA for depression; gabapentin or duloxetine for neuropathic; non-anticholinergic urge incontinence — mirabegron). Outcomes: reduce fall, hospitalization, cognitive decline, ADE.', NULL,
  'easy', 'geriatric', 'review',
  'internal_medicine', 'ems_mgmt', 'geriatric', 'elderly',
  'Beers Criteria 2023 (AGS); STOPP/START Criteria 2024; Scott IA et al. JAMA 2015 (Deprescribing)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 76 ปี on 9 chronic medications (ASA, statin, BB, ACEi, metformin, gabapentin, amitriptyline, diphenhydramine, alprazolam) มา OPD ด้วย confusion + fall + orthostatic hypotension + recent admission

คำถาม: deprescribing approach + identify potentially inappropriate medications (PIMs)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี post-major surgery ใน hospital × 5 d + Foley catheter + central line + mechanical ventilation + on multiple antibiotics + diabetes uncontrolled — high-risk for HAI. ทีม implement HAI prevention bundle

คำถาม: comprehensive HAI prevention strategy', '[{"label":"A","text":"Single intervention"},{"label":"B","text":"**Comprehensive HAI prevention** (CDC + IHI + SHEA + WHO bundles): - **CLABSI** (Central Line-Associated BSI): insertion bundle — hand hygiene, maximal barrier precaution, chlorhexidine skin prep, optimal site (subclavian > IJ > femoral), daily review of necessity + removal; maintenance — daily chlorhexidine bathing, scrub the hub, dedicated lines for TPN/blood products, sterile technique for dressing change. - **CAUTI**: appropriate indication, aseptic insertion, closed system, daily removal review (covered). - **VAP** (Ventilator-Associated Pneumonia): elevate HOB 30°, daily SAT/SBT, oral care with chlorhexidine, subglottic suction ETT, DVT + PUD prophylaxis, hand hygiene. - **SSI** (Surgical Site Infection): pre-op skin antiseptic chlorhexidine, appropriate timing + selection of prophylactic antibiotic, normothermia, glycemic control, smoking cessation pre-op, hair clipping not shaving, sterile technique. - **CDI**: judicious antibiotic + PPI use, contact precaution + private room, soap + water hand hygiene (alcohol ineffective for spores), terminal cleaning with bleach. - **MDRO** (CRE, MRSA, VRE): active surveillance + screening high-risk + chlorhexidine bathing + decolonization (MRSA — mupirocin) + cohorting + contact precaution. - **Hand hygiene**: alcohol-based hand rub at point of care; 5 moments of WHO; audit + feedback + reminder. - **Antimicrobial stewardship**: integrated (covered). - **Environment**: cleaning + disinfection + UV-C or H2O2 vapor; ATP audit. - **Vaccination of HCW**: influenza, COVID, HBV, MMR, varicella, pertussis. - **Surveillance + reporting**: NHSN, hospital benchmarking, public reporting. - **Education + culture**: simulation, training, accountability, leadership commitment"},{"label":"C","text":"Discharge home early"},{"label":"D","text":"Antibiotic prophylaxis weekly"},{"label":"E","text":"Restrict patient room access"}]'::jsonb,
  'B', 'HAI prevention = comprehensive bundled approach. CDC HICPAC + IHI Improvement Map + WHO IPC + SHEA + Joint Commission. Major HAI types: CLABSI, CAUTI, VAP, SSI, CDI, MDRO infections. Each has specific evidence-based prevention bundle. Hand hygiene + antimicrobial stewardship + environmental cleaning + HCW vaccination + surveillance + culture of safety = foundational. CMS hospital-acquired conditions (HAC) penalty + value-based purchasing — financial incentive. NHSN benchmarking. Effective programs reduce HAI 30-70%. Bundles work better than individual interventions. Multidisciplinary + sustained leadership commitment.', NULL,
  'medium', 'id', 'review',
  'internal_medicine', 'ems_mgmt', 'id', 'adult',
  'CDC HICPAC HAI Prevention Guidelines; IHI 5-Million Lives Campaign; SHEA Compendium of Strategies', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี post-major surgery ใน hospital × 5 d + Foley catheter + central line + mechanical ventilation + on multiple antibiotics + diabetes uncontrolled — high-risk for HAI. ทีม implement HAI prevention bundle

คำถาม: comprehensive HAI prevention strategy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย stage IV pancreatic adenocarcinoma + functional decline + symptomatic + near end-of-life. ครอบครัวต้องการคำแนะนำ + ดูแลที่บ้านหรือ hospice

คำถาม: principles ของ palliative + hospice care + symptom management at end-of-life', '[{"label":"A","text":"Continue aggressive chemo"},{"label":"B","text":"**Palliative + hospice care at end-of-life**: (1) **Palliative care**: specialty for serious illness; any stage; alongside curative; symptom + QoL + psychosocial + spiritual + family. Early integration (concurrent with oncology) improves QoL + symptom + mood + survival (Temel NEJM 2010 in NSCLC). (2) **Hospice**: Medicare benefit when life expectancy < 6 mo + opts for comfort focus over curative; home, inpatient, residential; covers medication + DME + nursing + chaplain + counselor; bereavement support. (3) **Symptom management end-of-life**: - **Pain**: opioid (morphine, hydromorphone, fentanyl patch + breakthrough); ESCALATE rapidly to comfort; opioid rotation; oral → SC/IV/buccal as PO declines. - **Dyspnea**: opioid (low-dose morphine), fan, oxygen if hypoxic, anxiolytic. - **Nausea**: ondansetron, metoclopramide, haloperidol, dexamethasone, olanzapine. - **Anxiety + restlessness**: low-dose benzo (lorazepam SC/SL); avoid in confusion. - **Delirium + agitation**: haloperidol; minimize stimuli; family presence. - **Excessive secretions / death rattle**: glycopyrrolate, atropine SL, hyoscine; suction limited. - **Constipation**: senna + osmotic + PEG. - **Anorexia**: not always treated; small frequent if desired; megestrol, dexamethasone for select. - **Oral care**: lip balm, ice chips, mouth swabs, NOT IV hydration solely. (4) **Withholding/withdrawing** life-sustaining treatment when not goals-concordant: comfort-focused IV fluid + nutrition; legal + ethical + religious considerations. (5) **Goals-of-care discussion**: serious illness conversation; REMAP framework; honor preferences. (6) **Spiritual + psychosocial**: chaplain, social work, counselor, family meetings. (7) **Caregiver support**: respite, education, recognize burden + depression. (8) **Bereavement**: continued support for family 12 mo post-death; complicated grief screening. (9) **Cultural + religious** competence + tailoring; (10) **Documentation**: POLST, advance directive, DNR/DNI, organ donation discussion if applicable"},{"label":"C","text":"Defer to surrogate"},{"label":"D","text":"Surgical intervention"},{"label":"E","text":"Pursue all life-prolonging measures"}]'::jsonb,
  'B', 'Palliative + hospice care = essential. Distinction: palliative — any stage + concurrent with curative; hospice — terminal, comfort-focused, life expectancy < 6 mo. Temel NEJM 2010 — early palliative care in metastatic NSCLC improved QoL + mood + survival (PARADIGM). Symptom management focused on pain, dyspnea, nausea, anxiety, delirium, secretions, constipation, anorexia, fatigue. Opioid escalation appropriate at end-of-life; no upper limit for symptom control. Avoid invasive procedure unless symptom benefit clear. Goals-of-care discussion + ACP. Family meetings + spiritual + psychosocial. Caregiver support critical (caregiver burden + depression + bereavement). Multidisciplinary palliative team. Communication + cultural competence + serious illness conversation guide. WHO public health approach to palliative care.', NULL,
  'easy', 'hemato_onco', 'review',
  'internal_medicine', 'ems_mgmt', 'hemato_onco', 'adult',
  'Temel JS NEJM 2010; CAPC + AAHPM Palliative Care Guidelines; WHO Palliative Care; CMS Hospice Benefit', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ผู้ป่วย stage IV pancreatic adenocarcinoma + functional decline + symptomatic + near end-of-life. ครอบครัวต้องการคำแนะนำ + ดูแลที่บ้านหรือ hospice

คำถาม: principles ของ palliative + hospice care + symptom management at end-of-life'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทีมแพทย์โรงพยาบาลกำลัง implement ICU mortality reduction QI project ผ่าน data dashboard + measurement

คำถาม: principles of healthcare quality improvement + measurement', '[{"label":"A","text":"Single physician opinion"},{"label":"B","text":"**Healthcare quality improvement (QI)** methodology: (1) **Six Sigma + Lean**: reduce variation + waste; DMAIC (Define, Measure, Analyze, Improve, Control); Plan-Do-Study-Act (PDSA) cycles. (2) **Donabedian framework**: structure (resources), process (clinical care delivered), outcome (results). (3) **Measure types**: process measures (did we do it?), outcome measures (did it help?), balancing measures (did we cause unintended harm?). (4) **STEEEP** quality domains (IOM): Safe, Timely, Effective, Efficient, Equitable, Patient-centered. (5) **Triple Aim → Quintuple Aim**: improve population health, individual care experience, reduce cost, + clinician well-being, + health equity. (6) **Dashboards + Run Charts + Control Charts**: visualize data over time; identify trends + variation + outliers; common cause vs special cause variation. (7) **QI tools**: Pareto chart, Fishbone (Ishikawa), Process map, Driver diagram, Failure Mode + Effects Analysis (FMEA), Root Cause Analysis (RCA). (8) **Specific ICU mortality QI**: Use national benchmark (APACHE, NHSN); identify gaps; bundles (ABCDEF, sepsis, VAP, CLABSI); process audits + feedback; multidisciplinary review; mortality + morbidity conference. (9) **Behavioral + culture**: leadership, transparency, blame-free reporting, recognition, sustained engagement, change management (Kotter 8 steps), team-based care. (10) **Patient + family engagement**: PFAC, patient experience survey (HCAHPS, NHS), shared decision-making. (11) **Health equity + SDoH**: stratify outcomes by race, ethnicity, language, SES; address disparities; targeted intervention. (12) **EHR + technology + AI**: predictive analytics, sepsis alerts, deterioration scores (NEWS2, eCart), clinical decision support; risk of alert fatigue + bias if not validated. (13) **Public reporting + payment models**: HCAHPS, CMS Star Rating, value-based purchasing, ACO, bundled payment, P4P"},{"label":"C","text":"No measurement"},{"label":"D","text":"Punish low performers"},{"label":"E","text":"Skip data collection"}]'::jsonb,
  'B', 'QI methodology + measurement = core healthcare management. Frameworks: Six Sigma/Lean (DMAIC, PDSA), Donabedian (structure-process-outcome), IOM STEEEP, Triple Aim → Quintuple Aim (Berwick — population health + experience + cost + clinician + equity). Measure types: process, outcome, balancing. QI tools: Pareto, Fishbone, FMEA, RCA, driver diagram, process map. Run + control charts to visualize. Dashboards + data feedback. Multidisciplinary + cultural transformation. Patient + family engagement (PFAC, HCAHPS). Health equity focus. EHR + AI + predictive analytics — validated + bias-aware. Payment + accountability: CMS Star Rating, value-based purchasing, ACO. Continuous improvement vs episodic.', NULL,
  'medium', 'psych_behavior', 'review',
  'internal_medicine', 'ems_mgmt', 'psych_behavior', 'adult',
  'IOM Crossing the Quality Chasm 2001; Berwick Triple Aim Health Affairs 2008; IHI; Donabedian Framework', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ทีมแพทย์โรงพยาบาลกำลัง implement ICU mortality reduction QI project ผ่าน data dashboard + measurement

คำถาม: principles of healthcare quality improvement + measurement'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ภัยพิบัติแผ่นดินไหวขนาด 6.5 ในจังหวัด affecting hospital — multiple casualties + power loss + supply disruption + staff displacement. โรงพยาบาลต้อง activate disaster preparedness plan

คำถาม: components ของ hospital disaster preparedness + response', '[{"label":"A","text":"Wait for direction from government"},{"label":"B","text":"**Hospital disaster preparedness + response** (HICS — Hospital Incident Command System; JCI + Joint Commission EM standards): (1) **Pre-disaster preparedness**: - All-hazards approach (natural, biologic, chemical, radiological, mass casualty, IT failure, supply chain). - Hazard Vulnerability Analysis (HVA) annual. - Emergency Operations Plan (EOP) — comprehensive, all-staff training. - Mock drills + tabletop exercises. - Mutual aid agreements + community partnerships. - Stockpile + supply chain redundancy. - Continuity of operations + business continuity. - Communication systems (radio, satellite, redundant). - Evacuation + sheltering-in-place plans. (2) **Activation + ICS (Incident Command System)**: structured command — Incident Commander + sections (Operations, Planning, Logistics, Finance/Admin); clear chain of command; resource allocation; communication. (3) **Mass casualty response**: - Triage (START — Simple Triage And Rapid Treatment; SALT — Sort/Assess/Lifesaving/Treatment) — categorize Red (immediate), Yellow (delayed), Green (minor walking wounded), Black (expectant). - Triage areas + flow + treatment areas (resuscitation, OR, ICU surge). - Surge capacity: cancel elective surgery, discharge stable, expand monitoring areas, double-up rooms, alternate care sites (school, gym), bring in additional staff (community, retired, students). - Crisis standards of care — when resources < demand; transparent + ethical framework; triage by likelihood of benefit + reversibility (not solely first-come). (4) **Specific scenarios**: - Earthquake: structural integrity assessment + evacuation if compromised; secondary triage in safe area. - Pandemic: infection control + isolation + cohorting + PPE supply + staff health + surge ICU + ventilator allocation framework. - Mass shooting: lockdown + active shooter response + casualty management. - Chemical/biological/radiological: decontamination zone before entering ED. (5) **Communication**: media, public, family reunification, multilingual; coordinate with public health + EMS + government. (6) **Staff welfare**: rest cycle, food, family support, mental health (CISD critical incident stress debriefing). (7) **Recovery**: damage assessment, business continuity, lessons learned, AAR (after-action review). (8) **Reporting + collaboration**: regional + state + federal (CDC, DDC Thailand); WHO IHR for international"},{"label":"C","text":"Continue normal hospital operations"},{"label":"D","text":"Discharge all patients"},{"label":"E","text":"Stop accepting new patients"}]'::jsonb,
  'B', 'Hospital disaster preparedness + response = essential safety. HICS (Hospital Incident Command System) modeled on FEMA NIMS ICS. JCI + Joint Commission Emergency Management standards. All-hazards approach. HVA annual. EOP comprehensive. Mock drills + tabletop. Mutual aid + community partnerships. Stockpile + redundancy. ICS structured response: Incident Commander + Operations + Planning + Logistics + Finance + Liaison + Safety + PIO. Mass casualty triage (START or SALT) — categorize by survivability + treatment time. Surge capacity: cancel elective, discharge stable, alternative sites, additional staff. Crisis standards of care — transparent framework for resource allocation when demand exceeds capacity. Pandemic + chemical/biological/radiological specific protocols. Communication + staff welfare + recovery + AAR. COVID-19 highlighted gaps + reinforced importance of comprehensive preparedness.', NULL,
  'medium', 'psych_behavior', 'review',
  'internal_medicine', 'ems_mgmt', 'psych_behavior', 'adult',
  'HICS Hospital Incident Command System; Joint Commission Emergency Management Standards; AHRQ Hospital Surge Toolkit; WHO Disaster Preparedness', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ภัยพิบัติแผ่นดินไหวขนาด 6.5 ในจังหวัด affecting hospital — multiple casualties + power loss + supply disruption + staff displacement. โรงพยาบาลต้อง activate disaster preparedness plan

คำถาม: components ของ hospital disaster preparedness + response'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี HIV+ × 12 ปี on ART (B/F/TAF — bictegravir/FTC/TAF), VL undetectable, CD4 480, มาด้วยปวดหลังเรื้อรัง + ผอม + คลื่นไส้ + LFT ↑ ALT 240, AST 180, ALP 380. ก่อนหน้านี้ healthy renal eGFR 75. กิน atorvastatin 40 mg + amlodipine 5 mg + sertraline 50 mg + แก้ปวด ibuprofen 400 mg + กิน traditional Chinese herbal เพื่อ "detox" 3 wk ก่อน + recently diagnosed HBsAg positive + anti-HBc IgM positive (new HBV co-infection)

Lab: ALT 240, ALP 380, Bili 1.8, INR 1.0, Cr 1.6 (rise from 1.1), Hb 11.6, A1c 6.0
US abdomen: heterogeneous hepatic with no mass
Fibroscan 11 kPa (F3)', '[{"label":"A","text":"Continue all medications + observation"},{"label":"B","text":"Complex multi-pathology: new HBV co-infection in HIV + likely DILI from herbal + statin interaction + AKI: (1) **Differential**: acute HBV reactivation vs new infection vs DILI from herbal vs ART-related hepatotoxicity vs statin-drug interaction (TAF + ritonavir-free regimen — bictegravir non-CYP3A); cessation of herbal supplement first (most likely DILI; RUCAM scoring); (2) **HBV management**: HBeAg + HBV DNA + HBeAb + HDV check; current ART (TAF + FTC) already covers HBV (dual indication — TAF is anti-HBV); do NOT stop TAF/FTC (HBV flare on discontinuation); add entecavir or TDF if more potent needed; HCC surveillance q6mo (cirrhosis + HBV); (3) **AKI workup**: prerenal vs intrinsic (TAF tubular toxicity rare); NSAID (ibuprofen) discontinuation; volume status assessment; UA + renal sonogram + electrolyte; (4) **Statin + ART interaction**: bictegravir not significant CYP3A4 inhibitor; atorvastatin OK; if PI-based (which not here), would limit/dose-adjust statin; (5) **Stop herbal supplement** (likely contributing to LFT abnormality); stop NSAID + monitor renal recovery; (6) **Multidisciplinary**: ID/HIV + hepatology + nephrology + pharmacist; (7) **Patient education**: drug interactions, herbal supplement risk, importance of disclosing all medications; (8) **F3 fibrosis** progression — monitor; address other contributing factors (alcohol, lipid, metabolic); (9) **HCV co-screen**; opportunistic infection check; vaccinations"},{"label":"C","text":"Stop all medications including ART"},{"label":"D","text":"Liver transplant immediately"},{"label":"E","text":"Increase ART dose"}]'::jsonb,
  'B', 'Complex HIV + new HBV co-infection + DILI + AKI + drug interactions — integrative. HIV-HBV co-infection: TAF + FTC dual-active; never discontinue (HBV flare). Add entecavir if HBV breakthrough. Herbal supplement common DILI in Asian patients. NSAID + AKI in HIV. ART drug interactions: PI + cobicistat are CYP3A inhibitors → multiple drug interactions including statin (avoid simvastatin + lovastatin); bictegravir + dolutegravir minimal CYP3A; rifampin reduces multiple. Multidisciplinary care: ID/HIV + hepatology + nephro + pharmacist. HCC surveillance in HIV-HBV co-infection. Patient education on herbal + supplement risks. Comprehensive multimorbidity management.', NULL,
  'hard', 'id', 'review',
  'internal_medicine', 'integrative', 'id', 'adult',
  'AASLD/IDSA HCV HIV Coinfection 2023; DHHS HIV; Adult HIV Co-Infection HBV Guideline', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี HIV+ × 12 ปี on ART (B/F/TAF — bictegravir/FTC/TAF), VL undetectable, CD4 480, มาด้วยปวดหลังเรื้อรัง + ผอม + คลื่นไส้ + LFT ↑ ALT 240, AST 180, ALP 380. ก่อนหน้านี้ healthy renal eGFR 75. กิน atorvastatin 40 mg + amlodipine 5 mg + sertraline 50 mg + แก้ปวด ibuprofen 400 mg + กิน traditional Chinese herbal เพื่อ "detox" 3 wk ก่อน + recently diagnosed HBsAg positive + anti-HBc IgM positive (new HBV co-infection)

Lab: ALT 240, ALP 380, Bili 1.8, INR 1.0, Cr 1.6 (rise from 1.1), Hb 11.6, A1c 6.0
US abdomen: heterogeneous hepatic with no mass
Fibroscan 11 kPa (F3)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี post heart transplant 5 yr ago on tacrolimus + MMF + low-dose prednisolone มาด้วย acute kidney injury (Cr ↑ from 1.6 → 3.2) + ขาบวม + edema + BP 168/102 + new proteinuria 2.4 g/24h

Lab: Cr 3.2, K 5.8, BUN 64, Albumin 3.4, A1c 7.8% (steroid + tacrolimus DM), glucose 192, lipid TC 280 LDL 168, urine protein 2.4 g, no RBC casts, urinalysis bland, tacrolimus trough 18 (high; target 8-10)
Echo LVEF 55% (preserved post-transplant)
Doppler renal: no stenosis
Kidney biopsy: tacrolimus-induced nephrotoxicity (chronic allograft + arteriolar hyalinosis + tubular vacuolization)
No BK virus, no CMV, no rejection', '[{"label":"A","text":"Stop tacrolimus completely"},{"label":"B","text":"Post-heart-transplant comprehensive management: calcineurin inhibitor nephrotoxicity + secondary hypertension + post-transplant DM + dyslipidemia + need to balance immunosuppression with adverse effects: (1) **Tacrolimus level reduction**: target trough 5-8 (chronic stable transplant); use lower-dose calcineurin + spare with MMF or sirolimus/everolimus (mTOR inhibitor — KIM/Belatacept conversion may help renal but risk of acute rejection — multidisciplinary transplant team decision); (2) **BP control**: target < 130/80; ACEi/ARB (despite K rise — careful titration, lower K with binders if needed; renoprotective); calcium channel blocker (amlodipine — but interacts with tacrolimus, ↑ level); MRA; SGLT2i (DAPA-CKD evidence in CKD non-transplant; emerging in transplant); avoid NSAID; (3) **Glycemic control**: post-transplant DM (PTDM) common (tacro + steroid); insulin or oral (metformin if eGFR appropriate; SGLT2i, GLP-1 RA emerging); minimize steroid; (4) **Lipid**: statin (atorvastatin — interaction with cyclosporine; less with tacro; check level); pravastatin alternative; (5) **Renal monitoring + biopsy** as guided; (6) **Vaccinations** (avoid live; inactivated, recombinant zoster); (7) **Cancer surveillance** — solid + skin + lymphoproliferative (PTLD — EBV-driven); reduce immunosuppression if PTLD; rituximab; (8) **Infection prophylaxis**: TMP-SMX (PCP), CMV monitoring + valganciclovir, fungal in selected; (9) **Bone**: DXA, Ca, Vit D, bisphosphonate; (10) **Mental health + adherence**: depression + cognitive; transition of care; (11) **Multidisciplinary**: transplant cardiologist + nephrologist + ID + endocrinology + pharmacist + nutrition + mental health + social work; (12) Adverse + interactions tracking pharmacist-led; renal protection priority"},{"label":"C","text":"Increase tacrolimus dose"},{"label":"D","text":"Stop ACEi long-term"},{"label":"E","text":"Restart MMF only"}]'::jsonb,
  'B', 'Long-term post-transplant management — multi-organ + multi-comorbid integrative challenge. Calcineurin inhibitor (CNI — tacrolimus, cyclosporine) nephrotoxicity major contributor to CKD post-transplant. Strategy: CNI minimization + sparing (MMF, mTOR inhibitor sirolimus/everolimus, belatacept conversion). BP target < 130/80. ACEi/ARB despite K (renoprotection + proteinuria; use K binders if needed). SGLT2i emerging in CKD + post-transplant. PTDM: insulin, metformin, SGLT2i, GLP-1 RA; minimize steroid. Lipid management with statin (interaction with CNI; pravastatin safer). Vaccination (avoid live). Cancer surveillance — solid + skin + PTLD (EBV). Infection prophylaxis (PCP, CMV). Bone (DXA + bisphosphonate + Ca + Vit D). Mental health + adherence. Multidisciplinary transplant team. Quality of life + long-term function priority.', NULL,
  'hard', 'cardiovascular', 'review',
  'internal_medicine', 'integrative', 'cardiovascular', 'elderly',
  'ISHLT Heart Transplant Recipient Guideline 2010 + updates; KDIGO Care of KT Recipient; AHA Heart Transplant Guideline', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี post heart transplant 5 yr ago on tacrolimus + MMF + low-dose prednisolone มาด้วย acute kidney injury (Cr ↑ from 1.6 → 3.2) + ขาบวม + edema + BP 168/102 + new proteinuria 2.4 g/24h

Lab: Cr 3.2, K 5.8, BUN 64, Albumin 3.4, A1c 7.8% (steroid + tacrolimus DM), glucose 192, lipid TC 280 LDL 168, urine protein 2.4 g, no RBC casts, urinalysis bland, tacrolimus trough 18 (high; target 8-10)
Echo LVEF 55% (preserved post-transplant)
Doppler renal: no stenosis
Kidney biopsy: tacrolimus-induced nephrotoxicity (chronic allograft + arteriolar hyalinosis + tubular vacuolization)
No BK virus, no CMV, no rejection'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 32 ปี ตั้งครรภ์ GA 22 weeks + underlying SLE on hydroxychloroquine + mycophenolate (continued in early pregnancy mistake) + recently DVT + on enoxaparin. Anti-Ro/La positive. Past Hx 2 prior pregnancy losses (1st trimester each)

Lab: ANA 1:640, anti-dsDNA 280 (high), C3/C4 low, anti-Ro positive, anti-La positive, antiphospholipid (lupus anticoagulant) positive, anti-β2-GP1 IgG positive
Proteinuria 1.4 g/24h (new)
Fetal echo at 22 wk: normal sinus rhythm
No prior HF, BP 142/86, mild edema', '[{"label":"A","text":"Continue mycophenolate during pregnancy"},{"label":"B","text":"Complex high-risk pregnancy: SLE + APS + lupus nephritis flare + anti-Ro/La + prior pregnancy losses + DVT: (1) **STOP mycophenolate immediately** — teratogen (cleft lip/palate, ear anomalies, miscarriage); switch to azathioprine 2 mg/kg (compatible) + tacrolimus alternative; continue hydroxychloroquine (HCQ ESSENTIAL — reduces flare, congenital heart block risk, improves outcomes); add low-dose prednisolone if active; (2) **Lupus nephritis active**: nephritic features + proteinuria; renal biopsy if safe (often deferred 3rd trimester); MMF replaced with AZA; cyclophosphamide CONTRAINDICATED; treat with steroid + AZA + HCQ; voclosporin not for pregnancy; (3) **Anticoagulation for DVT + APS** (triple-positive): LMWH (enoxaparin) therapeutic during pregnancy; transition to warfarin postpartum (compatible with breastfeeding); not DOAC (limited data + per TRAPS warfarin preferred in APS); (4) **Anti-Ro/La**: monitor fetal heart for congenital heart block (CHB 1-2% risk; up to 20% with prior affected child); fetal echo q2 wk from 16-26 wk; HCQ may reduce CHB risk; if CHB detected — controversial fluorinated steroid (dexamethasone or beta) to reverse; observation otherwise; (5) **Antiphospholipid**: aspirin 81 mg + therapeutic LMWH (high-risk APS with thrombosis); reduce pregnancy loss; (6) **BP target** < 140/90 in pregnancy; labetalol, methyldopa, nifedipine extended-release (avoid ACEi/ARB — fetal renal/oligohydramnios; avoid MRA; SGLT2i not in pregnancy); (7) **Preeclampsia surveillance**: high-risk (SLE, APS, renal disease); aspirin pre-12 wk to reduce; serial BP, proteinuria, fetal monitoring; (8) **Multidisciplinary**: high-risk OB + rheumatology + nephrology + cardiology (if cardiac involvement) + neonatology + anesthesia (delivery planning); (9) **Pneumococcal + flu + COVID vaccination**; avoid live; (10) **Counsel** re continued breastfeeding (most medications compatible); long-term contraception; future pregnancy planning when stable"},{"label":"C","text":"Stop hydroxychloroquine"},{"label":"D","text":"DOAC for VTE"},{"label":"E","text":"ACE inhibitor for BP"}]'::jsonb,
  'B', 'High-risk pregnancy with autoimmune + thrombophilic + cardio-renal multi-system disease — complex integrative. SLE + APS + Ro/La + DVT + lupus nephritis flare. ACOG + EULAR + ACR Pregnancy in CTD guideline: STOP mycophenolate, cyclophosphamide, MTX, leflunomide (teratogen) before/during pregnancy. CONTINUE hydroxychloroquine (improves outcomes, reduces flare + CHB); azathioprine + tacrolimus + low-dose pred compatible. APS treatment in pregnancy: aspirin + LMWH; reduces pregnancy loss; postpartum transition to warfarin; DOAC inferior in APS (TRAPS). Anti-Ro/La: CHB monitoring q2wk fetal echo 16-26 wk; HCQ may protect; fluorinated steroid for emerging CHB — controversial. ACEi/ARB/MRA/SGLT2i/DOAC/MMF/MTX/CYC contraindicated. Multidisciplinary team essential. Preeclampsia surveillance + aspirin prophylaxis. Vaccinations. Breastfeeding planning. Future pregnancy planning when disease quiescent ≥ 6 mo.', NULL,
  'hard', 'rheumatology', 'review',
  'internal_medicine', 'integrative', 'rheumatology', 'adult',
  'EULAR Recommendations for Women''s Health in CTD 2017; ACR Reproductive Health in Rheumatic Disease 2020; ACOG', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 32 ปี ตั้งครรภ์ GA 22 weeks + underlying SLE on hydroxychloroquine + mycophenolate (continued in early pregnancy mistake) + recently DVT + on enoxaparin. Anti-Ro/La positive. Past Hx 2 prior pregnancy losses (1st trimester each)

Lab: ANA 1:640, anti-dsDNA 280 (high), C3/C4 low, anti-Ro positive, anti-La positive, antiphospholipid (lupus anticoagulant) positive, anti-β2-GP1 IgG positive
Proteinuria 1.4 g/24h (new)
Fetal echo at 22 wk: normal sinus rhythm
No prior HF, BP 142/86, mild edema'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 58 ปี end-stage CKD (eGFR 8) ตัดสินใจกำลังเลือก renal replacement therapy modality. Underlying T2DM, HT, dyslipidemia, mild HF, peripheral vascular disease, depression

Discussion needed: hemodialysis vs peritoneal dialysis vs preemptive transplant vs conservative care + factors to consider', '[{"label":"A","text":"Always hemodialysis"},{"label":"B","text":"**Shared decision-making for ESRD modality** based on medical + lifestyle + social + values (KDIGO 2024 + RPA + KDOQI): (1) **Patient education program** (PEAK + others): structured + multidisciplinary; balanced presentation of options; (2) **Modalities**: - **Hemodialysis (HD)**: in-center (3×/wk × 4 hr) — most common; home HD (more frequent, daily, nocturnal — better outcomes selected). - **Peritoneal dialysis (PD)**: CAPD (4 exchanges/d), APD (cycler nighttime); home-based; flexibility + travel; less hemodynamic stress; peritonitis risk; transition to HD common after years (membrane failure). - **Kidney transplant**: preemptive (before dialysis) BEST outcomes; living donor > deceased; combined kidney-pancreas in T1DM. - **Conservative (non-dialysis) care**: comprehensive symptom + supportive + palliative; appropriate in frail elderly + multiple comorbid + poor prognosis + patient preference; not synonymous with stopping care. (3) **Factors influencing choice**: - **Medical**: HF severity (HD challenging fluid shift; PD may be better), PVD + vascular access difficulty, abdominal surgery hx (PD challenge), residual renal function (PD preserves longer), comorbid, frailty. - **Lifestyle + social**: home situation, support, employment, school, travel desires, self-care capability, family. - **Resource**: cost, geography, transport, dialysis access. - **Cultural + values**: religious, family decisions. (4) **Vascular access for HD**: AVF preferred (lower infection, longer patency, better outcomes vs AVG + CVC); creation 3-6 mo before anticipated start. AVG alternative. Central venous catheter — last resort + high infection + mortality. (5) **PD access**: laparoscopic catheter ≥ 2 wk before use ideally; embedded approach. (6) **Transplant evaluation early** — at eGFR < 20-30; preemptive transplant best outcomes; living donor preferred; cross-match + tissue type + immunological evaluation. (7) **Comprehensive comorbid management**: glycemic, BP, lipid, anemia (EPO + iron), bone-mineral (covered), CV prevention. (8) **Multidisciplinary nephrology + transplant + social work + dietitian + counselor**. (9) **Frailty + cognitive assessment** + advance care planning. (10) **Outcomes data + benchmarks** + transparent counseling + values-aligned"},{"label":"C","text":"Defer all decisions"},{"label":"D","text":"Single modality decision"},{"label":"E","text":"Long-term tunneled central line"}]'::jsonb,
  'B', 'ESRD modality choice — shared decision-making + comprehensive education + multidisciplinary. KDIGO 2024 + KDOQI vascular access guideline. Goals: patient-centered + values-aligned + outcome-optimized. PEAK programs + patient education shown to improve preemptive transplant + home dialysis uptake. Preemptive transplant best outcomes (avoid dialysis exposure); living donor preferred. Home dialysis (PD or home HD) — preserved residual function, lifestyle flexibility, possibly better outcomes selected. In-center HD — most common; least disruption to life; supported. AVF preferred over AVG + CVC. Conservative care appropriate for frail elderly + multiple comorbid + patient preference. Multidisciplinary team + early referral. Comprehensive comorbid management. Frailty + cognitive + ACP. Quality + cost + equity. SDoH affects access.', NULL,
  'hard', 'renal_gu', 'review',
  'internal_medicine', 'integrative', 'renal_gu', 'adult',
  'KDIGO 2024 CKD; KDOQI Vascular Access 2019; RPA Renal Physicians Association Shared Decision-Making', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 58 ปี end-stage CKD (eGFR 8) ตัดสินใจกำลังเลือก renal replacement therapy modality. Underlying T2DM, HT, dyslipidemia, mild HF, peripheral vascular disease, depression

Discussion needed: hemodialysis vs peritoneal dialysis vs preemptive transplant vs conservative care + factors to consider'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 62 ปี underlying T2DM (A1c 7.8%) + CKD stage 3 + CAD post-PCI + ischemic HFrEF (LVEF 35%) + COPD + obesity BMI 36 + OSA + chronic pain on opioid + depression + obstructive sleep apnea on CPAP + recurrent gout. Polypharmacy 16 medications

คำถาม: comprehensive multimorbidity management approach + how to integrate care', '[{"label":"A","text":"Single-organ approach"},{"label":"B","text":"**Comprehensive multimorbidity management** (NICE Multimorbidity Guideline + AGS Geriatric Care + Care Coordination Models): (1) **Goals-of-care + patient-centered priorities**: what matters most to patient; functional vs longevity vs symptom focus; (2) **Medication review + deprescribing**: STOPP/START + Beers; identify PIMs (anticholinergic, benzo, NSAID, opioid high-dose); minimize duplicate; align with priorities; (3) **Care coordination + interdisciplinary team**: cardiology + nephrology + endocrinology + pulmonology + pain + psychiatry + sleep + primary care + pharmacist + nutrition + PT + social work; communication via shared EHR + care plan; (4) **Holistic GDMT** for HFrEF + DM + CKD + CAD: SGLT2i (multi-system benefit), ARNI (or ACEi/ARB), BB, MRA, statin, ASA + P2Y12 (if applicable), high-intensity statin, glycemic individualized A1c 7-8% (avoid hypoglycemia); (5) **CKD-specific**: SGLT2i, ACEi/ARB, finerenone, dietary protein, vit D, Ca + Phos binder, EPO, dialysis planning if progressing; (6) **HF**: GDMT optimization, diuretic, exercise (cardiac rehab), CPAP for OSA (improves HF), low-Na diet; (7) **CAD**: secondary prevention, DAPT (or post-DAPT ASA mono), statin, BB, ACEi/ARB; (8) **COPD**: bronchodilator, ICS-LABA if indicated, vaccination, pulm rehab, smoking cessation; (9) **OSA**: CPAP adherence; (10) **Chronic pain**: multimodal (acetaminophen, topical, gabapentin if neuropathic, low-dose duloxetine, PT, mind-body); minimize opioid; (11) **Depression**: SSRI (sertraline safe in CV; not paroxetine — anticholinergic + interaction), CBT, exercise; (12) **Gout**: urate-lowering (allopurinol with HLA-B*5801 screen, febuxostat); avoid NSAID in CKD; flare colchicine; (13) **Obesity**: weight loss (lifestyle, GLP-1 RA, bariatric eval); (14) **Sleep + mental health + social**: address SDoH, support; (15) **Vaccinations**: annual flu, COVID, pneumococcal, RSV ≥ 60, shingles; (16) **Advance care planning** in advanced disease; (17) **Quality + outcome monitoring + patient experience**; transition of care across settings; (18) **Health literacy + self-management + caregiver support**"},{"label":"C","text":"Single specialist only"},{"label":"D","text":"Maximum disease guidelines for each independently"},{"label":"E","text":"Avoid disease-modifying treatments"}]'::jsonb,
  'B', 'Multimorbidity = > 2 chronic conditions; common + complex; standard guideline approaches insufficient; require patient-centered + integrative approach. NICE Multimorbidity Guideline + Boyd Multimorbidity, AGS Geriatric Care Online. Key: align with patient priorities (functional, longevity, symptom, QoL), deprescribe, address polypharmacy, integrate GDMT that serves multiple conditions (SGLT2i for HFrEF + CKD + DM; weight loss for HF + DM + OSA + CAD), multidisciplinary care coordination + shared EHR + transitions. Vaccinations + lifestyle + mental health + SDoH. ACP for advanced disease. Quality of life > rigorous single-disease maximization. Health literacy + self-management + caregiver + financial. Avoid harm from cumulative aggressive disease-specific approach in elderly multimorbid.', NULL,
  'medium', 'geriatric', 'review',
  'internal_medicine', 'integrative', 'geriatric', 'elderly',
  'NICE Multimorbidity Guideline NG56; Boyd CM Multimorbidity JAMA; AGS Geriatric Care Online', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 62 ปี underlying T2DM (A1c 7.8%) + CKD stage 3 + CAD post-PCI + ischemic HFrEF (LVEF 35%) + COPD + obesity BMI 36 + OSA + chronic pain on opioid + depression + obstructive sleep apnea on CPAP + recurrent gout. Polypharmacy 16 medications

คำถาม: comprehensive multimorbidity management approach + how to integrate care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 28 ปี ไม่มีโรค post-acute COVID-19 (mild infection 3 mo ก่อน) มาด้วยอาการ persistent fatigue + post-exertional malaise + brain fog + tachycardia on standing (POTS-like) + chest pain + dyspnea + sleep + anxiety + 6-mo persistence despite recovery from acute illness

คำถาม: approach to Long COVID / Post-Acute Sequelae of SARS-CoV-2 (PASC)', '[{"label":"A","text":"Antibiotic for long COVID"},{"label":"B","text":"**Long COVID / PASC** management: (1) **Definition**: symptoms persisting ≥ 4 wk (CDC) or ≥ 12 wk (WHO) post-acute SARS-CoV-2; multi-organ; > 200 symptoms reported; mechanisms include viral persistence, microvascular dysfunction, dysautonomia, mast cell activation, microclots, immune dysregulation, mitochondrial dysfunction. (2) **Comprehensive evaluation**: detailed history, systems review, exam, baseline labs (CBC, BMP, LFT, CRP, ESR, TSH, ferritin, B12, vit D, cortisol, troponin if cardiac), EKG, orthostatic BP/HR (POTS: HR ↑ > 30 bpm on standing × 10 min without OH), echo if cardiac symptoms, PFT + chest imaging if pulmonary, neurocognitive testing if cognitive, sleep study; rule out alternative diagnoses (thyroid, anemia, depression, autoimmune). (3) **Symptom-based management**: - **Post-exertional malaise (PEM)**: pacing + energy conservation; avoid graded exercise (worsens ME/CFS-like presentations); only gradual increase if tolerated. - **Fatigue**: prioritize, sleep optimization, low-dose stimulant in some, address anemia/thyroid/sleep apnea. - **POTS / dysautonomia**: increase fluid + salt + compression stockings; midodrine, fludrocortisone, ivabradine, low-dose β-blocker selected; gradual exercise rehab (recumbent first). - **Brain fog + cognitive**: cognitive rehab, sleep, treat depression/anxiety. - **Chest pain + palpitation**: cardiac workup; treat after exclusion. - **Dyspnea**: pulmonary rehab; PFT + imaging; treat OSA/asthma. - **Sleep**: CBT-I, sleep hygiene, treat OSA, melatonin. - **Anxiety/depression**: CBT, SSRI/SNRI, mindfulness. - **GI**: probiotic + diet; rule out IBS, gastroparesis. (4) **Multidisciplinary clinic** + specialty input (cardio, pulm, neuro, rheum, psych, PT/OT); (5) **Patient education + validation** — symptoms real + recovery possible; pace + don''t overdo; (6) **Vaccination + reinfection prevention** (some report improvement after vaccination — controversial); (7) **Research participation** + advocacy; (8) **Disability accommodation** + return-to-work planning; (9) **Cardiac MRI** for myocarditis (rare; selected); (10) **Exclude post-acute mimics**: thyroid, anemia, sleep apnea, depression, cardiac arrhythmia, lung dysfunction"},{"label":"C","text":"Steroid IV pulse for all"},{"label":"D","text":"Sole rest indefinitely"},{"label":"E","text":"Antiviral indefinitely"}]'::jsonb,
  'B', 'Long COVID/PASC = post-acute symptoms ≥ 4-12 wk after SARS-CoV-2; affects 5-30% post-infection; women + middle-aged + severe acute disease + obesity + diabetes higher risk. Mechanisms: viral persistence, dysautonomia, microvascular, immune dysregulation, mast cell, microclots, mitochondrial. Management: comprehensive multisystem evaluation, rule out alternative + treatable causes, symptom-based supportive care, multidisciplinary clinic. Pacing + energy management for ME/CFS-like (avoid graded exercise — worsens). POTS treatment for dysautonomia. CBT-I for sleep. Pulm rehab for dyspnea. Cognitive rehab + treat mental health. Validation + education + support. Disability + return-to-work. Research + clinical trials. RECOVER study + post-COVID clinics emerging. Vaccination may help. No specific FDA-approved therapy; supportive + symptom-based.', NULL,
  'medium', 'id', 'review',
  'internal_medicine', 'integrative', 'id', 'adult',
  'WHO Definition Long COVID 2021; CDC PASC; Davis HE Nature Reviews Microbiology 2023 (Long COVID Mechanisms + Management)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 28 ปี ไม่มีโรค post-acute COVID-19 (mild infection 3 mo ก่อน) มาด้วยอาการ persistent fatigue + post-exertional malaise + brain fog + tachycardia on standing (POTS-like) + chest pain + dyspnea + sleep + anxiety + 6-mo persistence despite recovery from acute illness

คำถาม: approach to Long COVID / Post-Acute Sequelae of SARS-CoV-2 (PASC)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 45 ปี survivor of breast cancer (stage III, HER2+, completed neoadjuvant TCHP + adjuvant pertuzumab/trastuzumab/lapatinib + radiation + tamoxifen 5 yr ago) ตอนนี้ healthy from cancer + มาด้วย CV risk + obesity + premature ovarian failure from chemo + bone health + anxiety/PTSD

คำถาม: comprehensive cancer survivorship care plan', '[{"label":"A","text":"Discharge from oncology + no follow-up"},{"label":"B","text":"**Cancer survivorship care plan** (ASCO + IOM + NCCN Survivorship Guidelines): (1) **Surveillance** for recurrence: H&P q3-6mo for 3 yr → q6-12mo for 5 yr → annually; mammogram annual; symptom-based imaging; tumor markers selected; (2) **Cardio-oncology**: long-term cardiotoxicity (anthracycline, trastuzumab, lapatinib, radiation cardiac); echo q1-3y baseline; manage CV risk aggressively (BP, lipid, glucose, weight, smoking, exercise); cardiac rehab; (3) **Endocrine + bone + menopause**: premature ovarian failure → estrogen deficiency → osteoporosis, CV, vasomotor; bone health (DXA, Ca, Vit D, exercise, bisphosphonate if needed); non-hormonal vasomotor (SSRI, gabapentin, clonidine — avoid HRT in HR+ cancer); sexual health (vaginal moisturizer, lubricant, ospemifene non-hormonal); (4) **Mental health**: anxiety + depression + PTSD common; CBT, mindfulness, antidepressant; survivorship clinic + support groups; (5) **Lymphedema**: surveillance + early intervention + compression; PT specialist; (6) **Cognitive impairment** (\"chemo brain\"): cognitive rehab + supportive; (7) **Sexual + reproductive**: counseling, fertility issues; (8) **Second cancer surveillance** + age-appropriate (colon, lung, cervical, skin); (9) **Lifestyle**: weight management + exercise (150 min/wk moderate; aerobic + resistance); diet (Mediterranean); alcohol moderation; smoking cessation; sun protection; (10) **Vaccinations**: flu, COVID, pneumococcal, RSV, HPV (if eligible age), Tdap, shingles; (11) **Care plan document** + share with PCP + patient + family; (12) **Survivorship clinic** in cancer center; coordinated care PCP + oncology; (13) **Long-term medication management** (tamoxifen 5-10 yr in HR+; AI in postmenopausal HR+); (14) **Insurance + financial + return-to-work** support; (15) **Caregiver + family** considerations + support; (16) **Disparities + equity** in survivorship outcomes"},{"label":"C","text":"Continue chemotherapy"},{"label":"D","text":"HRT for menopause"},{"label":"E","text":"Avoid all imaging"}]'::jsonb,
  'B', 'Cancer survivorship = comprehensive long-term care. ASCO + NCCN + IOM Survivorship Guidelines. Components: surveillance recurrence + 2nd cancer, late + long-term effects (cardiotoxicity, neurotoxicity, fertility, cognitive, mental health, bone, lymphedema), comorbidity management, healthy lifestyle, immunizations, psychosocial + caregiver support, financial + return-to-work, care coordination between oncology + PCP + survivorship clinic. Cardio-oncology essential for anthracycline + HER2-targeted + radiation. Endocrine effects from chemo-induced menopause. Mental health prevalent. Bone health + non-hormonal vasomotor. Sexual health. Lifestyle modification. Survivorship care plan document + handoff to PCP + patient. Quality of life + functional outcomes + equity priorities. Long-term tamoxifen/AI for HR+ breast cancer 5-10 yr.', NULL,
  'medium', 'hemato_onco', 'review',
  'internal_medicine', 'integrative', 'hemato_onco', 'adult',
  'ASCO Cancer Survivorship; IOM From Cancer Patient to Cancer Survivor; NCCN Survivorship Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 45 ปี survivor of breast cancer (stage III, HER2+, completed neoadjuvant TCHP + adjuvant pertuzumab/trastuzumab/lapatinib + radiation + tamoxifen 5 yr ago) ตอนนี้ healthy from cancer + มาด้วย CV risk + obesity + premature ovarian failure from chemo + bone health + anxiety/PTSD

คำถาม: comprehensive cancer survivorship care plan'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 30 ปี underlying severe sickle cell disease (HbSS) on hydroxyurea + chronic transfusion (for stroke prevention) มาด้วย acute chest syndrome + pneumonia + AKI + severe pain crisis. Multidisciplinary care needed

Lab: Hb 6.4, retic 12%, WBC 18K, Cr 2.4 (baseline 1.0), Bili 6.2, LDH 1,820, Plt 380K, troponin negative
ABG: PaO2 58 RA, PaCO2 32, pH 7.38
CXR: bilateral RUL + LLL infiltrates
MRI brain: prior infarct stable
Vision: retinopathy known
Iron overload from transfusion (ferritin 4,800)', '[{"label":"A","text":"Single-issue management"},{"label":"B","text":"**Sickle cell disease comprehensive management** + acute crisis + chronic comorbidities: (1) **Acute chest syndrome (ACS)** treatment: empirical antibiotic (ceftriaxone + azithromycin for atypical), bronchodilator, oxygen, **simple or exchange transfusion** (exchange for severe — target HbS < 30%); incentive spirometry; pain control (opioid + adjunct; PCA); hydration; (2) **Severe VOC**: opioid IV (morphine/hydromorphone) titrate; PCA pump; non-opioid adjunct; supportive; (3) **AKI workup**: prerenal (dehydration, hemolysis), contrast-related (avoid if possible), sickle nephropathy (microalbuminuria + reduced concentrating ability + glomerulopathy + papillary necrosis); supportive + hydration + nephrology; (4) **Address comorbidities**: - Hemolysis + transfusion → iron overload (ferritin 4,800 — high; chelation with deferasirox PO or deferoxamine SC); cardiac + endocrine + liver iron monitoring (T2* MRI). - Stroke prevention: chronic transfusion (STOP trial in pediatric; selected adult; primary prevention by TCD pediatric); newer voxelotor (HOPE — Hb increase) discontinued 2024 post-marketing. - Retinopathy: annual ophthalmology; laser if proliferative. - AVN: hip + shoulder common; pain + functional; consider arthroplasty; bisphosphonate. - Bone marrow + cardiac iron monitoring. - Pulmonary HT: echo screen; right heart cath confirm; treat as Group 5 (multifactorial) or Group 1 if confirmed PAH. - Cholelithiasis + biliary disease. - Leg ulcers. - Priapism. - Renal medullary carcinoma rare. (5) **Disease-modifying**: hydroxyurea (continue + optimize); L-glutamine (Endari); crizanlizumab (SUSTAIN); voxelotor (HOPE — withdrawn 2024). (6) **Curative emerging**: allogeneic SCT (matched sibling pediatric best); gene therapy (lovo-cel Lyfgenia — withdrawn for ALI signal; CRISPR exa-cel Casgevy approved 2024). (7) **Vaccinations** (functional asplenia): pneumococcal PCV20 + booster PPSV23, Hib, meningococcal, flu, COVID, RSV, shingles ≥ 50. (8) **Penicillin prophylaxis** childhood. (9) **Pain management plan** + multimodal + minimize chronic opioid (assessment + risk stratification). (10) **Mental health + adherence + transition + comprehensive SCD clinic**. (11) **Pregnancy planning** + complications; reproductive counseling"},{"label":"C","text":"Single antibiotic + observation"},{"label":"D","text":"Avoid blood transfusion always"},{"label":"E","text":"Stop hydroxyurea"}]'::jsonb,
  'B', 'Adult sickle cell disease = chronic multi-organ involvement; lifetime + complex. NHLBI 2014 + ASH 2020 + Thai Hematology Society. Acute crisis (VOC, ACS, splenic sequestration, stroke, aplastic, hemolytic, AKI, MOF). Chronic complications (anemia, hemolysis, iron overload, retinopathy, AVN, PH, nephropathy, cardiomegaly, mental health). Disease-modifying (hydroxyurea cornerstone; L-glutamine; crizanlizumab; voxelotor — withdrawn 2024). Curative emerging: HSCT, gene therapy (Casgevy CRISPR + Lyfgenia — Lyfgenia hematologic malignancy + ALI signal). Vaccinations + prophylaxis + functional asplenia consideration. Iron chelation post-transfusion. Multidisciplinary comprehensive sickle cell clinic + adult transition. Mental health + pain management + opioid stewardship + cognitive support. Pregnancy + reproductive planning. Survivorship priorities + quality of life.', NULL,
  'hard', 'hemato_onco', 'review',
  'internal_medicine', 'integrative', 'hemato_onco', 'adult',
  'NHLBI SCD 2014; ASH 2020 SCD Guideline; Thai Hematology Society', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 30 ปี underlying severe sickle cell disease (HbSS) on hydroxyurea + chronic transfusion (for stroke prevention) มาด้วย acute chest syndrome + pneumonia + AKI + severe pain crisis. Multidisciplinary care needed

Lab: Hb 6.4, retic 12%, WBC 18K, Cr 2.4 (baseline 1.0), Bili 6.2, LDH 1,820, Plt 380K, troponin negative
ABG: PaO2 58 RA, PaCO2 32, pH 7.38
CXR: bilateral RUL + LLL infiltrates
MRI brain: prior infarct stable
Vision: retinopathy known
Iron overload from transfusion (ferritin 4,800)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้บริหารโรงพยาบาลพิจารณานำเสนอ value-based care strategy → ผูก outcomes กับ payment + reduce cost + improve patient outcomes

คำถาม: principles of value-based healthcare + how internal medicine practice apply', '[{"label":"A","text":"Fee-for-service maximum"},{"label":"B","text":"**Value-based healthcare** (Porter Harvard Business School + IHI Triple/Quintuple Aim + CMS): Value = Health Outcomes / Cost (per unit of money spent). Move from volume → value. (1) **Pillars**: outcomes that matter to patients, cost, equity, experience. (2) **Models** (CMS + commercial): - Pay-for-performance (P4P): bonus for quality metrics. - Bundled payment: single payment for episode of care (joint replacement, CABG, maternity); cost + quality accountability. - Accountable Care Organization (ACO): shared savings if reduce cost + meet quality; MSSP, REACH, Direct Contracting. - Patient-centered medical home (PCMH): primary care–based; care coordination, prevention, mental health integration. - Capitated/global payment: full risk; population-based. - Value-based purchasing (VBP) hospital + physician. (3) **IM practice application**: - Chronic disease management: diabetes, HF, CKD, CAD bundles; team-based care; population health management (registry, outreach, panel management). - Care coordination: between PCP + specialty + hospital + post-acute; care navigators. - Transition of care: discharge planning, post-discharge follow-up, readmission prevention (covered). - Preventive care: screening, vaccination, lifestyle counseling, USPSTF + ACIP. - High-cost case management (5% patients = 50% spend): targeted intervention; high-risk care management. - Behavioral health integration: collaborative care model; co-located. - SDoH: screening + addressing food insecurity + housing + transportation + financial. (4) **Outcomes that matter to patients (PROs — patient-reported outcomes)**: ICHOM standard sets; functional status, symptom, QoL, patient experience. (5) **Health equity**: disparity assessment + stratification + targeted intervention; health equity in quality metrics. (6) **Data + analytics**: EHR + registry + population health platform; dashboards; transparent. (7) **Multidisciplinary team**: physician + APP + nurse + pharmacist + nutrition + behavioral + social work + community health worker + care manager + navigator. (8) **Patient + family engagement**: shared decision-making + advance care planning + self-management; PFAC. (9) **Continuous improvement** + cultural transformation + leadership commitment + alignment of incentives. (10) **Equity, efficiency, effectiveness, patient-centeredness, safety, timeliness** (STEEEP)"},{"label":"C","text":"Maximum testing for revenue"},{"label":"D","text":"Avoid measurement"},{"label":"E","text":"Single specialty model"}]'::jsonb,
  'B', 'Value-based healthcare = paradigm shift from fee-for-service volume to value (outcomes/cost). Porter + Teisberg Harvard. Models: P4P, bundled, ACO, PCMH, capitated, VBP. CMS aggressive shift. Value = (Outcomes that matter to patients) / Cost. IM application: chronic disease management with team-based care + population health, care coordination, transition of care, preventive care, high-cost case management, behavioral health integration, SDoH. ICHOM PROs (patient-reported outcomes). Health equity central. Data + analytics + EHR + dashboards. Multidisciplinary team + APP + care navigator. Patient + family engagement + shared decision-making + ACP. Continuous improvement. Quintuple Aim: health + experience + cost + clinician well-being + equity. Internal medicine physicians at center of value-based primary care + chronic disease.', NULL,
  'medium', 'psych_behavior', 'review',
  'internal_medicine', 'integrative', 'psych_behavior', 'adult',
  'Porter ME — Value-Based Healthcare HBR; CMS Value-Based Care; IHI Quintuple Aim; ICHOM', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ผู้บริหารโรงพยาบาลพิจารณานำเสนอ value-based care strategy → ผูก outcomes กับ payment + reduce cost + improve patient outcomes

คำถาม: principles of value-based healthcare + how internal medicine practice apply'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Researcher publishing meta-analysis on novel therapy for HF + intervention''s claimed benefit. Evidence synthesis needed for clinical guideline

คำถาม: principles of evidence-based medicine + GRADE + critical appraisal of clinical trial + applying evidence to practice', '[{"label":"A","text":"Trust all published studies"},{"label":"B","text":"**Evidence-Based Medicine + GRADE**: (1) **5 steps**: Ask focused clinical question (PICO — Population, Intervention, Comparison, Outcome), Acquire best evidence, Appraise critically, Apply to patient, Assess outcomes. (2) **Hierarchy of evidence**: meta-analysis + systematic review of RCTs > individual RCT > cohort > case-control > case series > expert opinion (varies by question — for harm + diagnosis + prognosis hierarchies differ). (3) **GRADE methodology** (Grading of Recommendations Assessment, Development and Evaluation): quality of evidence (High, Moderate, Low, Very Low) downgraded for risk of bias, inconsistency, indirectness, imprecision, publication bias; upgraded for large effect, dose-response, plausible confounding minimizing effect. Recommendation strength (Strong vs Conditional/Weak) based on certainty + balance benefit-harm-cost-values. (4) **Critical appraisal**: - RCT: randomization + concealment + blinding + outcome measure + ITT + completeness; CONSORT reporting. - Observational: confounding, selection, measurement bias; propensity score; STROBE. - Systematic review: PRISMA; comprehensive search, study selection, risk of bias (RoB 2.0 + ROBINS-I); meta-analysis + heterogeneity (I²). - Diagnostic test: STARD; sensitivity + specificity + LR + PPV/NPV. (5) **Statistical understanding**: p-value, CI, RR, OR, HR, NNT/NNH, absolute vs relative; type I + II error; intention-to-treat. (6) **Apply to patient**: external validity, similarity to study population, individual values + preferences + comorbidity + cost + access. (7) **Shared decision-making**: communicate benefit + harm in absolute + understandable terms; decision aids. (8) **Clinical guidelines**: GRADE-based + transparent + conflicts of interest + multidisciplinary panel + patient involvement; ACR, NICE, USPSTF, AHA, ESC examples. (9) **Tools**: UpToDate, DynaMed, ACP Smart Medicine, BMJ Best Practice, JBI, Cochrane; PICO + EBM bedside teaching. (10) **Avoid**: cherry-picking, surrogate endpoints overinterpretation, post-hoc subgroup analysis, conflicts of interest unrecognized. (11) **Health equity in evidence + guidelines**: representation in trials, applicability to diverse populations"},{"label":"C","text":"Single study sufficient"},{"label":"D","text":"Ignore patient preferences"},{"label":"E","text":"Statistical significance = clinical"}]'::jsonb,
  'B', 'EBM + GRADE = foundational to modern clinical practice + guideline development. Sackett''s definition: integration of best evidence + clinical expertise + patient values. 5 steps: Ask, Acquire, Appraise, Apply, Assess. Evidence hierarchy: meta-analysis/SR > RCT > cohort > case-control > case series > expert. GRADE quality of evidence + strength of recommendation. Critical appraisal: RoB 2.0 (RCT), ROBINS-I (observational), PRISMA (SR), CONSORT (RCT reporting), STROBE (observational), STARD (diagnostic). Statistics: p, CI, RR, OR, HR, NNT, ITT, external validity. Apply to patient considering individual factors + values. Shared decision-making + decision aids. Guidelines: GRADE-based, multidisciplinary, patient involvement. Avoid pitfalls + conflicts of interest. Health equity in evidence + practice.', NULL,
  'medium', 'psych_behavior', 'review',
  'internal_medicine', 'integrative', 'psych_behavior', 'adult',
  'Sackett DL Evidence-Based Medicine; GRADE Working Group; Cochrane Handbook; AHRQ EPC + USPSTF Methods', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'Researcher publishing meta-analysis on novel therapy for HF + intervention''s claimed benefit. Evidence synthesis needed for clinical guideline

คำถาม: principles of evidence-based medicine + GRADE + critical appraisal of clinical trial + applying evidence to practice'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 24 ปี recently diagnosed T1DM (DKA presentation) + family Hx of T1DM + celiac + Hashimoto + recently started insulin therapy. Concerns about long-term care + complications + technology + mental health + reproduction

คำถาม: comprehensive young adult T1DM care', '[{"label":"A","text":"Insulin alone"},{"label":"B","text":"**Comprehensive young adult T1DM care** (ADA + ISPAD + Thai Endocrine Society): (1) **Multidisciplinary team**: endocrinologist + diabetes educator + dietitian + mental health + ophthalmologist + nephrologist + transition + reproductive specialist; (2) **Insulin regimen**: basal-bolus MDI (multiple daily injection) OR insulin pump (CSII — continuous subcutaneous insulin infusion); automated insulin delivery (AID) / hybrid closed-loop systems (Tandem Control-IQ, Omnipod 5, MiniMed 780G, iLet — emerging) — significant improvement glycemic + QoL; (3) **CGM (continuous glucose monitoring)**: Dexcom G7, Libre 3 + 4 — standard of care; targets — TIR (time in range 70-180) ≥ 70%, < 4% time below 70, < 1% time below 54, < 25% above 180; A1c < 7%; (4) **Adjunctive therapy**: low-carb dietary, structured education (DAFNE, DESMOND), exercise (glucose management), sick-day rules, hypoglycemia prevention + glucagon (Baqsimi nasal, GVOKE, Zegalogue) + family training, dual-hormone systems emerging; (5) **Screening for associated autoimmune conditions** (T1DM polyautoimmune): - Thyroid (TSH + anti-TPO) at diagnosis + annual. - Celiac (tTG IgA + total IgA) at diagnosis + every 1-2 yr or symptoms. - Vit B12, adrenal, gonadal, rheumatic. - APS-2 if multiple. (6) **Complication screening**: - Retinopathy: dilated eye annual from 5 yr post-diagnosis. - Nephropathy: urine albumin/Cr annual + eGFR. - Neuropathy: monofilament + vibration + autonomic. - CV: BP target < 130/80, lipid (statin per ADA), aspirin not routine primary. - Foot care + dental + bone (CDC). (7) **Mental health**: depression + diabetes distress + eating disorder (\"diabulimia\" — insulin omission) + adherence; routine screening; CBT + SSRI; peer support; (8) **Reproductive health**: contraception (any modality + non-hormonal options), pre-conception planning (target A1c < 6.5% + folic acid + ACEi/ARB d/c if planning + complications stabilization); pregnancy planning + GDM in subsequent (covered); (9) **Transition** from pediatric to adult care; education + self-management + insurance; (10) **Vaccinations** (immune normal); (11) **Technology + access + cost** considerations; equity in CGM + pump access; (12) **Emerging therapies**: teplizumab (anti-CD3) FDA-approved 2022 for delay of clinical T1DM in autoantibody+ relatives; islet cell transplant (Lantidra approved 2023); beta-cell replacement therapy emerging; immune-modulation in research"},{"label":"C","text":"Single specialist + no education"},{"label":"D","text":"Stop insulin during stress"},{"label":"E","text":"Avoid pregnancy planning"}]'::jsonb,
  'B', 'Young adult T1DM = chronic disease requiring lifelong comprehensive management; emerging technologies + complications + mental health + reproductive considerations. ADA 2024 + ISPAD + Thai Endocrine. Multidisciplinary team + comprehensive education. Insulin: MDI or pump + AID hybrid closed-loop (game-changing 2020s). CGM standard of care. TIR target ≥ 70%. Associated autoimmunity screening (thyroid, celiac, others). Complication screening (eye, kidney, neuropathy, CV, foot, dental). Mental health critical — diabetes distress, depression, eating disorder. Reproductive planning + contraception + pre-conception. Transition from pediatric. Emerging: teplizumab anti-CD3 (delay clinical T1DM in high-risk autoantibody+ relatives); islet cell transplant (Lantidra). Technology + cost + equity in access.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'internal_medicine', 'integrative', 'endocrine_metabolic', 'adult',
  'ADA Standards of Care 2024; ISPAD Guideline; ATTD International Consensus on CGM', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 24 ปี recently diagnosed T1DM (DKA presentation) + family Hx of T1DM + celiac + Hashimoto + recently started insulin therapy. Concerns about long-term care + complications + technology + mental health + reproduction

คำถาม: comprehensive young adult T1DM care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 75 ปี planned for elective hip arthroplasty for severe OA + underlying CAD (post-PCI 6 mo ago on DAPT) + HFrEF (LVEF 32%) + CKD + DM + COPD + anticoagulant (DOAC for AF) + chronic opioid + nutritional issues + multiple medications

คำถาม: comprehensive perioperative risk assessment + optimization for elective surgery', '[{"label":"A","text":"Proceed without optimization"},{"label":"B","text":"**Comprehensive perioperative risk assessment + optimization** (ACC/AHA + ESC + ESA Cardiovascular Risk Assessment + Choosing Wisely): (1) **Risk stratification**: surgical risk (hip arthroplasty intermediate); patient risk (RCRI Revised Cardiac Risk Index — CAD, HF, CVA, DM on insulin, Cr > 2; this patient ≥ 3 high-risk); ACS-NSQIP risk calculator; functional capacity (METs < 4 = poor); (2) **Cardiac**: continue beta-blocker (NOT starting new — POISE ↑ mortality with new BB); statin continue; ACEi/ARB hold morning of surgery (hypotension); ASA continue or stop based on indication + bleeding risk + cardiology consult (post-PCI < 12 mo high risk in-stent thrombosis → continue DAPT if possible; if must stop P2Y12 — bridge with platelet GP IIb/IIIa selected, minimize duration); cardiology consult for borderline + recent stent + low EF; (3) **DOAC management**: hold 1-2 d before surgery (apixaban 24-48 hr; rivaroxaban 24 hr; dabigatran 48 hr in normal renal — longer in CKD); bridge with LMWH if very high-risk (mechanical valve, recent CVA); resume 24-48 hr post-op based on bleeding; check anti-Xa levels in CKD; CHA2DS2-VASc balanced against bleeding; (4) **HF + LVEF 32%**: optimize GDMT; diuresis if volume overloaded; ACEi/ARB hold morning; BB continue; consider invasive hemodynamic monitoring (PA cath rarely; non-invasive — CVP, fluid response, lactate, urine output); cardiology + cardiac anesthesia consult; (5) **CKD**: monitor for AKI; avoid nephrotoxin (contrast, NSAID); dose adjust; (6) **DM**: hold metformin (SAGE recently — re-evaluating; previously 48 hr), insulin adjustment; avoid hyper/hypoglycemia; resume post-op once eating; (7) **COPD**: optimize bronchodilator; chest PT; smoking cessation > 4-8 wk if possible (best); pulm consult + PFT if needed; spirometry pre-op; (8) **Anticoagulant + antiplatelet** detailed plan; (9) **Anemia + nutrition**: pre-op Hb optimization (IV iron if Fe-deficient — STOP-AKI; Hb target ≥ 13); albumin > 3.5; nutritional support; protein 1.5 g/kg/d; counsel weight + nutrition; (10) **Frailty + functional**: 6MWT, gait, grip, ECOG, CSHA scale; prehab (exercise + nutrition + mental + medical optimization 4-8 wk) reduces complications; (11) **Mental health + cognition**: baseline MoCA + assess delirium risk; minimize anticholinergic + benzo; ACP discussion; (12) **Opioid management**: continue baseline; multimodal post-op (PCA + non-opioid adjunct + regional anesthesia — peripheral nerve block); avoid opioid escalation; transition off pre-op chronic if possible; (13) **Medications + reconciliation** + pharmacist; (14) **DVT prophylaxis** + mechanical + chemical; (15) **Vaccinations** if relevant; (16) **Surgical timing**: elective vs urgent; balance with optimization; (17) **Multidisciplinary**: surgery + anesthesia + cardiology + nephrology + pulmonology + geriatrics + PT/OT + nutrition + pharmacy + ACP"},{"label":"C","text":"Single specialist clearance"},{"label":"D","text":"Stop all medications"},{"label":"E","text":"Avoid surgery indefinitely"}]'::jsonb,
  'B', 'Comprehensive perioperative risk assessment + optimization in high-risk elderly = complex multidisciplinary. ACC/AHA 2014 + ESC 2022 + ASA. RCRI + ACS-NSQIP risk calculators. Cardiac: continue BB + statin + ASA (selectively); hold ACEi/ARB morning; manage DOAC by half-life + renal; bridge for very high-risk only. HFrEF optimize GDMT + cardiology + cardiac anesthesia. CKD: avoid nephrotoxin + dose adjust. DM: insulin adjustment + glycemic control. COPD: optimize + smoking cessation + PFT. Anemia + nutrition: pre-op IV iron + albumin + protein. Frailty + functional: prehab (exercise + nutrition + 4-8 wk) reduces complications. Cognition + delirium prevention + ACP. Opioid + multimodal + regional anesthesia. Medication reconciliation. DVT prophylaxis. Multidisciplinary team + surgery + anesthesia + cardiology + nephro + pulm + geriatrics + PT/OT + nutrition + pharmacy + social. ERAS (Enhanced Recovery After Surgery) protocols.', NULL,
  'hard', 'cardiovascular', 'review',
  'internal_medicine', 'integrative', 'cardiovascular', 'elderly',
  'ACC/AHA 2014 Perioperative CV Evaluation; ESC 2022 Perioperative CV Assessment; ASA Practice Advisory', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 75 ปี planned for elective hip arthroplasty for severe OA + underlying CAD (post-PCI 6 mo ago on DAPT) + HFrEF (LVEF 32%) + CKD + DM + COPD + anticoagulant (DOAC for AF) + chronic opioid + nutritional issues + multiple medications

คำถาม: comprehensive perioperative risk assessment + optimization for elective surgery'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 72 ปี underlying advanced HF (NYHA IV, LVEF 22%) + multiple hospitalizations + functional decline + cardiac cachexia + recurrent diuretic-resistant edema + multiple comorbidities + family discussing options

คำถาม: advanced HF management approach + when to consider advanced therapies vs comfort-focused', '[{"label":"A","text":"Continue same therapy"},{"label":"B","text":"**Advanced HF (Stage D)** management requires careful assessment + shared decision-making (AHA/ACC/HFSA 2022 HF + ISHLT + REMATCH-style): (1) **Confirm advanced HF**: NYHA III-IV symptoms despite optimal GDMT; LVEF persistently low; recurrent hospitalization; refractory edema; cachexia (cardiac); intolerant to GDMT (hypotension, AKI); ventricular arrhythmia; right HF; secondary organ dysfunction; (2) **Advanced therapy candidates evaluated**: - **Cardiac transplant**: gold standard; eligibility — < 70-75 yr, no severe comorbid, social support, adherent, no active malignancy, controlled diabetes, no irreversible PH, BMI < 35, no active substance abuse; UNOS waiting list; - **LVAD (Left Ventricular Assist Device)** — durable mechanical circulatory support: bridge-to-transplant, bridge-to-decision, or destination therapy (DT) in non-transplant candidates; HeartMate 3 most current (MOMENTUM 3); risks — bleeding (GI, intracranial), thrombosis, stroke, infection (driveline + device), aortic insufficiency; significant lifestyle changes; - **Total artificial heart** rare. (3) **Non-transplant candidates with severe functional decline + refractory symptoms** despite GDMT and not LVAD candidate: - **Inotrope therapy** (chronic — dobutamine + milrinone): symptomatic + functional improvement but mortality concern; bridge to transplant or palliative; - **Palliative care + hospice**: comfort-focused; symptom management (dyspnea — low-dose opioid, oxygen, fan; pain; anxiety; depression; nausea; secretions; constipation); ICD deactivation consideration; discontinue device shocks at end-of-life. (4) **Decision-making framework**: - Patient values + goals + preferences. - Functional + cognitive status (frailty scale). - Comorbidity burden. - Social support + caregiver. - Quality of life + symptom burden. - Realistic discussion of risks + benefits + survival + QoL trade-offs. - Multidisciplinary team meeting + family meeting + Serious Illness Conversation Guide. - Advance care planning + POLST + healthcare surrogate. (5) **Optimize GDMT**: continue + max tolerated; - SGLT2i for HF + comorbid - ARNI replace ACEi/ARB - BB - MRA - Loop diuretic + adjunctive thiazide + tolvaptan for refractory + spironolactone - Hydralazine + nitrate in African ancestry + intolerant ACEi/ARB - Ivabradine if HR > 70 sinus - Vericiguat (sGC stimulator) for HFrEF + recent decompensation (VICTORIA) (6) **Device therapy**: CRT-D if LBBB + LVEF < 35 + NYHA III-IV; ICD primary prevention if not already + life expectancy > 1 yr meaningful QoL; cardiac contractility modulation (CCM, Optimizer) selected; (7) **CardioMEMS implantable PA pressure monitoring**: HF hospital reduction (CHAMPION); (8) **Multidisciplinary HF clinic**: cardio + cardio-renal + transplant + LVAD + nurse + pharm + social work + palliative + cardio-rehab; (9) **Hospice referral** if comfort-focused + life expectancy < 6 mo"},{"label":"C","text":"Aggressive surgery first-line"},{"label":"D","text":"Increase diuretic indefinitely"},{"label":"E","text":"Withhold all therapy"}]'::jsonb,
  'B', 'Advanced HF (Stage D) = high mortality + complex management + integration of disease-modifying + advanced therapies + palliative. AHA/ACC/HFSA 2022 + ISHLT + REMATCH (LVAD) + MOMENTUM 3 (HM3) + CardioMEMS CHAMPION. Cardiac transplant gold standard for eligible. LVAD durable MCS — bridge or destination. HM3 reduced stroke + thrombotic. Inotrope therapy as bridge or palliative — mortality concern. Palliative care + hospice — symptom focused; ICD deactivation discussion; comfort medication + multidisciplinary. Decision-making: patient values + goals + functional status + comorbidity + QoL trade-offs + family + serious illness conversation. ACP + POLST. GDMT optimization: ARNI + BB + MRA + SGLT2i + diuretic + ivabradine + vericiguat. Device therapy (CRT, ICD). Multidisciplinary advanced HF clinic. Cardio-renal-metabolic integrative + cardio-oncology if relevant + cardio-obstetric + cardio-psychiatry. Quintuple aim.', NULL,
  'hard', 'cardiovascular', 'review',
  'internal_medicine', 'integrative', 'cardiovascular', 'elderly',
  'AHA/ACC/HFSA 2022 HF Guideline; ISHLT Advanced HF Listing; MOMENTUM 3 NEJM 2019', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 72 ปี underlying advanced HF (NYHA IV, LVEF 22%) + multiple hospitalizations + functional decline + cardiac cachexia + recurrent diuretic-resistant edema + multiple comorbidities + family discussing options

คำถาม: advanced HF management approach + when to consider advanced therapies vs comfort-focused'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 38 ปี adult survivor of congenital heart disease (ToF — tetralogy of Fallot, surgical repair age 3) มา OPD ด้วยอาการ exercise intolerance + palpitation + dyspnea + plans for pregnancy + concerns

Lab: BNP 380, EKG sinus + RBBB + intermittent NSVT, Echo: severe pulmonary regurgitation, RV enlarged + dysfunction RVEF 35%, LVEF 50%, mild residual VSD, no other defect
CMR: RV end-diastolic volume 180 mL/m² (severely dilated), late gadolinium enhancement at RVOT patch site
CPET: VO2 max 60% predicted
No significant cyanosis at rest', '[{"label":"A","text":"General cardiology only + no further evaluation"},{"label":"B","text":"**Adult congenital heart disease (ACHD)** comprehensive management (ACC/AHA + ESC 2020 + ISACHD): (1) **ACHD specialist + multidisciplinary**: ACHD-trained cardiologist + cardiac surgeon (or interventional structural) + electrophysiologist + cardio-obstetrician + nursing + counselor; specialized adult CHD centers (level III); (2) **Tetralogy of Fallot post-repair sequelae**: - Pulmonary regurgitation (PR): progressive over decades → RV volume overload → RV dilation + dysfunction + RVOT aneurysm. - **Pulmonary valve replacement (PVR)** indications (ESC): severe PR + symptoms (NYHA II+), RV EDV ≥ 160 mL/m² (some say ≥ 150) or RV ESV ≥ 80, decreased exercise capacity (VO2 max < 70% predicted), sustained VT, progressive RV dysfunction, severe RVOT obstruction. Surgical vs transcatheter (TPVR — Melody, Sapien) — based on anatomy. - Earlier intervention if symptoms or progressive RV dysfunction. (3) **Arrhythmia management**: - NSVT + sustained VT — ICD selected (high-risk: RV dysfunction, prior PVR, RVEF < 35%, QRS > 180, LV dysfunction, inducible VT); EPS + ablation considered. - Atrial flutter + AF common — antiarrhythmic + ablation. (4) **Pregnancy planning** (ACC/AHA + ESC + ROPAC): - Pre-conception evaluation: assess functional status + cardiac reserve + comorbidities; risk stratify (mWHO classification — ToF post-repair = mWHO II-III; severe PR + RV dysfunction increases risk). - Genetic counseling (recurrence risk in offspring 3-5%; chromosome 22q11.2 microdeletion 15% of ToF). - Anticoagulation management if needed. - Multidisciplinary cardio-obstetric care; planned delivery + anesthesia consult; postpartum monitoring + heart failure surveillance. (5) **CV risk reduction**: BP + lipid + glucose + smoking + lifestyle; many ACHD develop traditional CV risk factors superimposed. (6) **Endocarditis prophylaxis**: post-repair with residual defect, prior IE, prosthetic material — dental procedures only; not routine. (7) **Exercise**: supervised cardiac rehabilitation; tailored exercise prescription; sports participation based on Bethesda + ESC. (8) **Mental health + transition**: many ACHD experience anxiety, depression, PTSD related to childhood surgeries + chronic condition; transition from pediatric to adult care. (9) **Anticoagulation** if AF, prior thrombosis, intracardiac shunt + paradoxical embolism risk. (10) **Lifelong follow-up**: serial imaging (echo + CMR), CPET, BNP, EKG, Holter — frequency depending on lesion. (11) **Multidisciplinary IE prevention, vaccinations, dental care**, comprehensive primary care + ACHD specialty"},{"label":"C","text":"Single visit clinic"},{"label":"D","text":"Avoid pregnancy categorically"},{"label":"E","text":"Pulmonary valve replacement immediately regardless"}]'::jsonb,
  'B', 'Adult congenital heart disease (ACHD) — growing population due to pediatric surgical success; complex multi-system + lifelong specialty care. ACC/AHA 2018 + ESC 2020 + ISACHD + WHO ACHD. ToF most common cyanotic CHD; post-repair sequelae primarily PR + RV dysfunction. PVR indications based on RV dimensions + function + symptoms + arrhythmia + exercise capacity. Transcatheter (Melody, Sapien) vs surgical. Arrhythmia management — VT, atrial flutter, AF, ICD selected. Pregnancy: mWHO classification, multidisciplinary cardio-obstetric, recurrence risk in offspring (3-5%, higher 22q11.2 deletion), genetic counseling. CV risk reduction. Endocarditis prophylaxis selective. Exercise + rehab. Mental health + transition + multidisciplinary lifelong care. ACHD centers (level III).', NULL,
  'hard', 'cardiovascular', 'review',
  'internal_medicine', 'integrative', 'cardiovascular', 'adult',
  'ACC/AHA 2018 ACHD Guideline; ESC 2020 Adult CHD Guideline; ISACHD', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 38 ปี adult survivor of congenital heart disease (ToF — tetralogy of Fallot, surgical repair age 3) มา OPD ด้วยอาการ exercise intolerance + palpitation + dyspnea + plans for pregnancy + concerns

Lab: BNP 380, EKG sinus + RBBB + intermittent NSVT, Echo: severe pulmonary regurgitation, RV enlarged + dysfunction RVEF 35%, LVEF 50%, mild residual VSD, no other defect
CMR: RV end-diastolic volume 180 mL/m² (severely dilated), late gadolinium enhancement at RVOT patch site
CPET: VO2 max 60% predicted
No significant cyanosis at rest'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี advanced cirrhosis (HBV-related) Child-Pugh C MELD 22 + ascites refractory + recent SBP + HRS + esophageal varices ligated + Hepatic encephalopathy (HE) recurrent + HCC small lesion BCLC A (2 cm) + family discussion re liver transplant

คำถาม: comprehensive end-stage liver disease management + transplant evaluation', '[{"label":"A","text":"Watchful waiting"},{"label":"B","text":"**End-stage liver disease (ESLD)** + HCC + transplant evaluation (AASLD + EASL + ILTS): (1) **MELD score** (now MELD 3.0 including sex + albumin): MELD 22 = severe; transplant indication eGFR < 15-20 + decompensation; HCC exception points within Milan criteria boost MELD; (2) **Liver transplant evaluation**: comprehensive multidisciplinary — hepatology + transplant surgeon + anesthesia + ID + nephrology + cardiology + psychiatry + social work + financial; medical eligibility (cardiac, pulmonary, infection, cancer); social support; psychological + substance use evaluation; insurance; living donor + DDLT (deceased donor) options; (3) **HCC management** (within Milan criteria: single ≤ 5 cm or up to 3 lesions ≤ 3 cm; no vascular invasion + extrahepatic): - LT first-line — recurrence rare + curative. - Bridging while waiting: TACE (transarterial chemoembolization), RFA (radiofrequency ablation), MWA (microwave), TARE (Y-90), SBRT. - Downstaging if outside Milan criteria with hope of transplant. (4) **Decompensation management**: - Ascites: low-Na diet + loop diuretic + spironolactone; large-volume paracentesis + albumin; TIPS in refractory (risk of HE); avoid NSAID + nephrotoxin. - SBP secondary prophylaxis (norfloxacin) lifelong; primary prophylaxis high-risk. - HE: lactulose + rifaximin (already covered). - Variceal bleeding: NSBB (propranolol, carvedilol) + EVL secondary; primary prophylaxis NSBB or EVL. - HRS: terlipressin + albumin (CONFIRM). - Hyponatremia: water restriction; tolvaptan selective. (5) **HBV management on antiviral**: TDF or TAF (TAF preferred renal + bone protection); never stop (severe flare). (6) **Anti-HBV immunoglobulin (HBIG) + antiviral** post-transplant to prevent recurrence; oral antivirals long-term. (7) **HCC after transplant**: low recurrence within Milan; surveillance + intervention if recurrence. (8) **Cardiopulmonary assessment**: cirrhotic cardiomyopathy, portopulmonary HT, hepatopulmonary syndrome (target oxygen saturation + transplant indication). (9) **Renal optimization** pre-transplant. (10) **Mental health + substance use** evaluation + treatment; abstinence requirement varies by program for alcohol. (11) **Vaccinations** pre-transplant: HBV, HAV, pneumococcal, flu, COVID, RSV, shingles. (12) **Post-transplant**: long-term immunosuppression (CNI + MMF + steroid taper); rejection surveillance; infection prophylaxis; CV risk; metabolic + bone + cancer surveillance; renal + DM management. (13) **Palliative care + ACP** consideration if not transplant candidate. (14) **Multidisciplinary lifelong care**"},{"label":"C","text":"Aggressive chemotherapy first"},{"label":"D","text":"TIPS placement immediately"},{"label":"E","text":"Single intervention"}]'::jsonb,
  'B', 'End-stage liver disease + HCC = complex integrative multidisciplinary. AASLD + EASL + ILTS. MELD 3.0 (sex + albumin added 2023). LT for ESLD + HCC within Milan criteria = curative. Bridging while waiting (TACE, RFA, SBRT, Y-90). Downstaging if beyond Milan. Comprehensive evaluation (medical, social, psychosocial). HCC surveillance q6mo US + AFP. HBV antiviral lifelong + HBIG post-transplant. Decompensation management — ascites, SBP, HE, varices, HRS, hyponatremia. Cardio-pulmonary assessment + renal optimization. Mental health + substance use eval. Vaccinations pre-transplant. Post-transplant: immunosuppression, rejection, infection prophylaxis, comorbid management, surveillance. Palliative if not candidate. Multidisciplinary lifelong + transition.', NULL,
  'hard', 'gi', 'review',
  'internal_medicine', 'integrative', 'gi', 'elderly',
  'AASLD Practice Guidance HCC 2023; EASL HCC Guideline; OPTN/UNOS Allocation; ILTS Standards', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี advanced cirrhosis (HBV-related) Child-Pugh C MELD 22 + ascites refractory + recent SBP + HRS + esophageal varices ligated + Hepatic encephalopathy (HE) recurrent + HCC small lesion BCLC A (2 cm) + family discussion re liver transplant

คำถาม: comprehensive end-stage liver disease management + transplant evaluation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี African ancestry underlying HIV controlled, recently diagnosed with hepatocellular carcinoma + HCV (post-DAA cured 3 yr ago, SVR maintained) + multifocal cirrhosis Child-Pugh B + 5 cm HCC + portal vein thrombosis + extrahepatic LN metastasis. BCLC stage C/D

คำถาม: HCC management beyond Milan + locally advanced + metastatic', '[{"label":"A","text":"Single TACE only"},{"label":"B","text":"**Advanced HCC (BCLC C-D) management**: (1) **Multidisciplinary tumor board**: hepatology + interventional radiology + hepatobiliary surgery + medical oncology + radiation oncology; (2) **Systemic therapy first-line** (locally advanced + metastatic): - **Atezolizumab + bevacizumab** (anti-PD-L1 + anti-VEGF) — IMbrave 150 NEJM 2020 — superior OS vs sorafenib; checkpoint inhibitor + VEGF; contraindicated severe varices (UGIB risk — screen + treat varices first); CTP A preferred (some B); - **Durvalumab + tremelimumab (single dose) — STRIDE regimen**: HIMALAYA — alternative; checkpoint inhibitor only — better for those with bleeding risk; CTP A preferred; - Sorafenib + lenvatinib + cabozantinib (TKI) — historical first-line; second-line; - Pembrolizumab + nivolumab + ipilimumab — checkpoint inhibitor combinations; - Regorafenib + ramucirumab + tivozanib (later lines); (3) **Locoregional + systemic combinations**: TACE + atezo-bev or TARE (Y-90) emerging; (4) **Surgical** for selected: resection for limited disease + preserved function; rare in advanced; (5) **Liver transplant** (LT): not typically for advanced HCC outside extended criteria (UCSF, downstaging); HIV + HCC + cirrhosis is unique consideration; HIV controlled + good performance + no extrahepatic + within criteria — possible; HIV + HCV history (cured) does not preclude; (6) **HIV management**: continue ART; ensure VL suppression; assess drug interactions with systemic HCC therapy (sorafenib, lenvatinib + PI minimal; CCR5 inhibitor no interaction; bictegravir minimal); avoid hepatotoxic interactions; (7) **HCV/HBV**: HCV cured (SVR maintained); monitor for HCC despite SVR (residual risk); HBV — confirm reactivation status + treat if HBsAg+; (8) **Symptom management**: pain control (opioid + adjunct), abdominal symptoms, ascites, fatigue, GI; palliative + supportive care early; (9) **Variceal screening + management** before checkpoint inhibitor (UGIB risk); (10) **Cardiac + pulmonary + renal** assessment for systemic therapy; (11) **Decision-making**: patient values + goals + comorbidities + cost + access + family + support + cultural; shared decision-making; ACP; (12) **Multidisciplinary HCC clinic** + tumor board + early palliative care integration + clinical trial enrollment; (13) Survivorship + monitoring + quality of life priorities"},{"label":"C","text":"Sorafenib alone forever"},{"label":"D","text":"Surgery for all"},{"label":"E","text":"Wait until end-stage"}]'::jsonb,
  'B', 'Advanced HCC = era of immunotherapy revolution. NCCN + ESMO + APASL + BCLC. First-line: atezo-bev (IMbrave 150 — practice-changing) OR durvalumab-tremelimumab (HIMALAYA STRIDE — alternative + bleeding risk concerns). TKI (sorafenib, lenvatinib, cabozantinib) — first-line or second-line. Locoregional + systemic combos emerging. Surgery + LT for highly selected. HIV + HCC management: continue ART, drug interactions, HIV-HCC integration. HCV cured but HCC risk persists. HBV management. Variceal screening before checkpoint inhibitor. Cardiac/pulm/renal eval. Multidisciplinary tumor board. Palliative care integration early. Shared decision-making + values + ACP. Clinical trial. Multidisciplinary lifelong. HCC has > 30% improvement in survival over decade due to checkpoint inhibitors.', NULL,
  'hard', 'hemato_onco', 'review',
  'internal_medicine', 'integrative', 'hemato_onco', 'elderly',
  'NCCN HCC Guideline; IMbrave 150 NEJM 2020; HIMALAYA NEJM 2022; BCLC Strategy 2022', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี African ancestry underlying HIV controlled, recently diagnosed with hepatocellular carcinoma + HCV (post-DAA cured 3 yr ago, SVR maintained) + multifocal cirrhosis Child-Pugh B + 5 cm HCC + portal vein thrombosis + extrahepatic LN metastasis. BCLC stage C/D

คำถาม: HCC management beyond Milan + locally advanced + metastatic'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทีมแพทย์ ICU พิจารณา withdraw life-sustaining treatment ของผู้ป่วยอายุ 72 ปี multi-organ failure + cardiogenic shock + ARDS on vent + CRRT + multiple pressors + persistent neurological deficit from anoxic brain injury post-arrest + family conflicted re continued aggressive care

คำถาม: ethical + legal + clinical principles in withdrawal of life-sustaining treatment + family discussion', '[{"label":"A","text":"Continue all interventions indefinitely"},{"label":"B","text":"**Withdrawal of life-sustaining treatment (WLST)** = ethically + legally acceptable when continued treatment not goals-concordant + not benefiting patient (NEJM ICU End-of-Life + WHO + ASA + ACP + WMA WLST principles): (1) **Ethical principles**: - Autonomy: patient''s previously expressed wishes via advance directive or surrogate. - Beneficence + non-maleficence: balance benefit + harm + suffering. - Justice: fair resource allocation. - Double effect doctrine: relieving suffering acceptable even if hastens death (e.g., opioid for dyspnea). (2) **Legal framework**: - Patient''s right to refuse treatment (autonomy). - Surrogate decision-making in incapacity. - Living will + healthcare proxy. - Court intervention rarely. (3) **Clinical assessment**: - Prognosis assessment (multidisciplinary) — severity + reversibility. - Goals-of-care alignment with patient values + previously stated preferences. - Quality of life trajectory. - Disagreement among family members → mediation. (4) **Family meeting** (Family-Centered Care): - Multidisciplinary team — physician + nursing + social work + chaplain + ethics consult if needed. - Use Serious Illness Conversation Guide (Ariadne Labs). - REMAP framework: Reframe, Expect emotion, Map values, Align, Plan. - Explore patient''s values + what made life meaningful. - Avoid \"there''s nothing more we can do\" — reframe goals + comfort. - Allow time for understanding + emotion + questions. - Multiple meetings often needed. (5) **Implementation of withdrawal**: - Comfort-focused: aggressive symptom management — opioid (dyspnea, pain — high doses appropriate; double-effect doctrine), benzo (anxiety, agitation), antimuscarinic (secretions), antiemetic. - Discontinue: vasopressor, mechanical ventilation (terminal extubation or ventilator wean), dialysis, antibiotic (unless symptom palliation), IV fluid (per goals), nutrition (per goals). - ICD/pacemaker deactivation discussion. - Maintain dignity + privacy + family presence + cultural + spiritual support. (6) **Spiritual + cultural** competence: respect different traditions (Buddhism, Islam, Christianity, etc. each have specific perspectives on death + dying); chaplain involvement. (7) **Cultural + family considerations**: in some cultures (Thailand + many Asian), family-centered decision-making is normative; involve family + respect cultural framing. (8) **Documentation** + clear order set + communication to all staff. (9) **Post-withdrawal**: comfort care, family bereavement support, debriefing for staff (2nd victim). (10) **Disagreement resolution**: ethics committee + mediation + Time-Limited Trial approach in uncertainty. (11) **Resident education** + simulation + reflection. (12) **Equity + disparities** in end-of-life care; address SDoH"},{"label":"C","text":"Continue without discussion"},{"label":"D","text":"Ignore family input"},{"label":"E","text":"Discontinue all care including symptoms"}]'::jsonb,
  'B', 'Withdrawal of life-sustaining treatment (WLST) = ethically + legally acceptable + common end-of-life practice in ICU. Principles: autonomy, beneficence/non-maleficence, justice, double effect. Legal: patient''s right to refuse + surrogate decision-making + advance directive. Clinical: prognosis + goals-of-care + multidisciplinary assessment. Family meeting essential: REMAP, Serious Illness Conversation Guide, Ariadne Labs framework, time + emotion + questions; multiple meetings often. Implementation: comfort-focused — high-dose opioid + benzo + secretion management + dignity + family presence; discontinue ventilator, pressors, dialysis, etc. Cultural + spiritual + religious considerations critical (Thailand family-centered). Documentation + communication. Post-withdrawal: bereavement + staff debriefing (2nd victim — high moral distress). Ethics committee for disagreement. Resident education + simulation. Equity in EOL.', NULL,
  'medium', 'psych_behavior', 'review',
  'internal_medicine', 'integrative', 'psych_behavior', 'elderly',
  'Truog RD NEJM ICU End-of-Life Care 2008; WMA Declaration on End-of-Life; ACP Position on EOL', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ทีมแพทย์ ICU พิจารณา withdraw life-sustaining treatment ของผู้ป่วยอายุ 72 ปี multi-organ failure + cardiogenic shock + ARDS on vent + CRRT + multiple pressors + persistent neurological deficit from anoxic brain injury post-arrest + family conflicted re continued aggressive care

คำถาม: ethical + legal + clinical principles in withdrawal of life-sustaining treatment + family discussion'
  );

commit;

-- verify partial progress
select board_section, count(*) from public.mcq_questions
where board_specialty = 'internal_medicine' and exam_source = 'AI-generated-board-seed'
group by 1 order by 1;
