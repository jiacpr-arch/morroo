-- ===============================================================
-- หมอรู้ — Board seed: พยาธิวิทยา (pathology) — part 4/4 (50 MCQs)
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
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี — dry eyes + dry mouth + parotid swelling; labs: ANA+, anti-Ro/SSA+, anti-La/SSB+; lip salivary biopsy: focal lymphocytic sialadenitis (focus score ≥ 1); การวินิจฉัยและการรักษา', '[{"label":"A","text":"RA"},{"label":"B","text":"Sjögren Syndrome (SS)"},{"label":"C","text":"SLE"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Sjögren Syndrome (SS): (1) **Definition**: chronic autoimmune disease primarily affecting exocrine glands (salivary, lacrimal) → sicca symptoms (dry eyes, mouth); systemic involvement common; (2) **Subtypes**: - **Primary Sjögren** — without other autoimmune; - **Secondary Sjögren** — with RA, SLE, scleroderma, MCTD, PBC; (3) **Clinical**: - Dry eyes (xerophthalmia — Schirmer test < 5 mm/5 min), keratoconjunctivitis sicca; - Dry mouth (xerostomia, dental caries, candidiasis); - Parotid + submandibular gland swelling (recurrent); - **Extraglandular**: fatigue, arthralgia, Raynaud, vasculitis, ILD, interstitial nephritis (renal tubular acidosis classic), neuropathy, CNS involvement, lymphoproliferative; - **Increased risk MALT lymphoma** (parotid) + DLBCL — 5-10% lifetime — biopsy persistent salivary mass; (4) **Diagnostic criteria (ACR/EULAR 2016)**: weighted criteria — needs ≥ 4 points: - Labial salivary gland focus score ≥ 1 (3 points); - Anti-SSA/Ro positive (3 points); - Ocular staining score ≥ 5 (1 point); - Schirmer ≤ 5 mm (1 point); - Unstimulated salivary flow rate ≤ 0.1 mL/min (1 point); (5) **Pathology — labial salivary gland biopsy**: - **Focal lymphocytic sialadenitis (FLS)** — focal aggregates ≥ 50 lymphocytes around ducts in periductal/perivascular distribution; - **Focus score** = number of foci per 4 mm² — **≥ 1 supports SS**; - Distinguishes from chronic sialadenitis, drug-induced, age-related changes; (6) **Other workup**: - **Anti-Ro/SSA + Anti-La/SSB** — antibodies; - **ANA**; rheumatoid factor; - **Immunoglobulins** (often elevated polyclonal IgG); - **Complement** (C3, C4); - Cryoglobulins (associated with lymphoma risk); - **Imaging**: salivary gland US, MRI sialography; - **Rule out hepatitis C, HIV, IgG4-RD** (mimics); (7) **Treatment** (mostly symptomatic + emerging targeted): - **Symptomatic**: artificial tears, lubricants, cyclosporine drops, pilocarpine/cevimeline (cholinergics — increase secretion), oral hygiene + fluoride + saliva substitutes; - **HCQ** for fatigue + arthralgia + mild systemic; - **Steroids + immunosuppressants** for severe systemic; - **Rituximab** — selected severe disease (cryoglobulinemic vasculitis, ILD); - **B-cell-directed novel agents** under study: belimumab + rituximab, iscalimab (anti-CD40), ianalumab (anti-BAFF-R), telitacicept (BAFF + APRIL); - **Lymphoma surveillance** in chronic gland enlargement; (8) **Multidisciplinary**: rheum + ophth + dental + ENT + pathology + heme-onc (lymphoma surveillance)

---

Sjögren: sicca + glandular + extraglandular + MALT lymphoma risk. Labial salivary biopsy focus score ≥1 + anti-Ro/La + ocular staining. 2016 ACR/EULAR criteria. Symptomatic Tx + HCQ + rituximab for severe. Novel B-cell agents emerging. Surveil for lymphoma (parotid mass).', NULL,
  'medium', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'ACR/EULAR Sjögren 2016', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี — dry eyes + dry mouth + parotid swelling; labs: ANA+, anti-Ro/SSA+, anti-La/SSB+; lip salivary biopsy: focal lymphocytic sialadenitis (focus score ≥ 1); การวินิจฉัยและการรักษา'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี — multi-organ involvement (autoimmune pancreatitis + IgG4 elevation + retroperitoneal fibrosis + sialadenitis); biopsy: lymphoplasmacytic infiltrate + storiform fibrosis + obliterative phlebitis + IgG4+/IgG plasma cells > 40%', '[{"label":"A","text":"Sjögren"},{"label":"B","text":"IgG4-Related Disease (IgG4-RD)"},{"label":"C","text":"Sarcoidosis"},{"label":"D","text":"Refuse"},{"label":"E","text":"Cancer"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** IgG4-Related Disease (IgG4-RD): (1) **Definition**: systemic immune-mediated fibroinflammatory condition with tumefactive (mass-like) lesions in multiple organs; mimics neoplasm, infection, other autoimmune diseases; (2) **Common organ involvement**: - **Pancreatic** — autoimmune pancreatitis type 1; - **Biliary** — IgG4 sclerosing cholangitis (mimics PSC + cholangiocarcinoma); - **Salivary glands** — Küttner tumor (chronic sclerosing sialadenitis), Mikulicz disease (formerly); - **Lacrimal/orbital**; - **Retroperitoneal fibrosis** (Ormond disease subset); - **Kidney** — tubulointerstitial nephritis; - **Lung** — interstitial pneumonia, mass-like lesions; - **Aorta** — periaortitis, aortitis; - **Lymph nodes** — variable patterns; - **Skin, mediastinum, pituitary, mesentery, breast, prostate**; (3) **Histology — pathology essential** (Mayo Clinic + others diagnostic criteria): - **Lymphoplasmacytic infiltrate** (dense, mature lymphocytes + plasma cells); - **Storiform fibrosis** (''cartwheel'' pattern) — characteristic; - **Obliterative phlebitis** — venous lumens occluded by inflammation; - **Increased IgG4+ plasma cells** — IHC double-stain (IgG4 + IgG total); - **IgG4+/IgG total ratio > 40%** + **IgG4+ count > 10-200/HPF** (varies by organ — kidney > 30, lung > 20, lymph node > 50, others); - **Eosinophilic infiltrate** present often; - **No granulomas, vasculitis (other than obliterative), or necrosis**; (4) **Serum IgG4 elevated** in many but not all (~ 60-80%) — not diagnostic alone; complement low possible; (5) **Differential**: - **Malignancy** — pancreatic ca, cholangiocarcinoma, lymphoma, salivary tumor; - **Multicentric Castleman**, **Erdheim-Chester**, **Rosai-Dorfman**; - **Granulomatosis with polyangiitis**, **Sjögren**, **PSC**, **sarcoidosis**; - **Lymphoma**; (6) **Diagnostic approach**: - Tissue biopsy + immunohistochemistry — **gold standard**; - Imaging features (organ-specific — e.g., ''sausage'' pancreas, halo of pancreatic IgG4); - Serum IgG4 + IgE; - Response to corticosteroids; (7) **Treatment**: - **Glucocorticoids** — initial — usually rapidly responsive; - **Immunosuppressants** (azathioprine, MMF, methotrexate) for maintenance + steroid-sparing; - **Rituximab** — effective steroid-refractory + relapsing, frequently used; - **Novel** under development: inebilizumab, dazucorvimab, anti-CD19/CD20; (8) **Relapse common** — long-term monitoring; (9) **Multidisciplinary** essential given multi-organ

---

IgG4-RD: systemic fibroinflammatory; multi-organ (pancreatic, biliary, salivary, RPF, kidney, etc.). Histology triad: lymphoplasmacytic + storiform fibrosis + obliterative phlebitis; IgG4+/IgG > 40% + threshold counts. Serum IgG4 supportive. Steroids first-line; rituximab refractory. Relapse common.', NULL,
  'hard', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'Boston Consensus 2012; ACR/EULAR IgG4-RD 2019', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี — multi-organ involvement (autoimmune pancreatitis + IgG4 elevation + retroperitoneal fibrosis + sialadenitis); biopsy: lymphoplasmacytic infiltrate + storiform fibrosis + obliterative phlebitis + IgG4+/IgG plasma cells > 40%'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 35 ปี — bilateral hilar adenopathy + skin nodules + uveitis; biopsy: non-caseating epithelioid granulomas without necrosis; ACE elevated; การวินิจฉัยและการรักษา', '[{"label":"A","text":"TB"},{"label":"B","text":"Schaumann + asteroid bodies"},{"label":"C","text":"Lymphoma"},{"label":"D","text":"TB"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Sarcoidosis: (1) **Definition**: multisystem granulomatous disease of unknown cause; non-caseating epithelioid granulomas; diagnosis of exclusion (rule out infection + other granulomatous diseases); (2) **Epidemiology**: African Americans + Scandinavians higher prevalence; 20-40 yr peak; (3) **Histology**: - **Non-caseating granulomas** — well-formed, compact, epithelioid macrophages + multinucleated giant cells + lymphocytes; - **No necrosis** (vs caseating in TB); - **Schaumann + asteroid bodies** in giant cells (not specific); - Hyalinization with time; - Distribution along lymphatics; (4) **Differential — must rule out (since ''non-caseating granuloma'' is non-specific)**: - **Infection**: TB (Z-N stain + culture + PCR + Quantiferon), fungal (Histo, Crypto, Cocci — GMS, PAS, cultures), atypical mycobacteria, syphilis, brucellosis, leishmaniasis; - **Other**: Crohn''s, primary biliary cholangitis, berylliosis, hypersensitivity pneumonitis, granulomatous reactions to malignancy, foreign body, drugs, common variable immunodeficiency (CVID), GLILD; - **Other autoimmune**: GPA (necrotizing + vasculitis), EGPA; (5) **Clinical (heterogeneous)**: - Asymptomatic incidental hilar adenopathy (~ 30%); - **Löfgren syndrome** — acute self-limited — bilateral hilar adenopathy + erythema nodosum + arthralgia/uveitis; - Pulmonary (90% — interstitial, fibrosis advanced); - Cardiac (conduction abnormalities, heart failure, sudden death — significant cause of mortality); - Neurologic (cranial nerve palsy, hypothalamic); - Skin (erythema nodosum, lupus pernio, papules, scars); - Ocular (uveitis); - Hepatic, splenic, renal, hypercalcemia (vit D activation by granulomas), bone marrow, parotid; (6) **Workup**: - **Tissue biopsy** confirming non-caseating granuloma; **Endobronchial ultrasound TBNA (EBUS-TBNA)** of mediastinal nodes increasingly preferred; - **Rule out infection extensively** (essential before steroids); - **Imaging**: CXR (Scadding stage 0-IV), HRCT, cardiac MRI/PET for cardiac, brain MRI; - **PFTs** including DLCO; - **ECG + cardiac monitoring** (Holter, echocardiography) — for cardiac sarcoid; - **ACE level** — elevated ~ 60% but non-specific + non-diagnostic; - **24-h urine calcium**; (7) **Treatment**: - **Many asymptomatic** + Löfgren — observation; spontaneous remission common; - **Active organ disease** — corticosteroids first-line; - **Steroid-sparing**: methotrexate, azathioprine, MMF, leflunomide; - **Severe/refractory**: anti-TNF (**infliximab**) — effective for refractory; **JAK inhibitors (tofacitinib)** emerging; - **Cardiac sarcoid**: corticosteroid + immunosuppressant + ICD if indicated; - **Pulmonary fibrosis advanced**: antifibrotic (nintedanib) considered; - **Hypercalcemia**: hydration + bisphosphonate; avoid vitamin D supplementation; (8) **Multidisciplinary**: pulm + cardiology + neurology + ophth + rheum + path; (9) **Pulmonary rehab** + chronic care

---

Sarcoidosis: non-caseating granulomas; multisystem (pulm, cardiac, skin, ocular, neuro, calcium). Diagnosis of exclusion — rule out infection extensively. ACE non-specific. Scadding stage CXR. Steroids first-line for active; steroid-sparing + anti-TNF (infliximab) refractory. Multidisciplinary.', NULL,
  'medium', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'ATS/ERS/WASOG Sarcoidosis', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 35 ปี — bilateral hilar adenopathy + skin nodules + uveitis; biopsy: non-caseating epithelioid granulomas without necrosis; ACE elevated; การวินิจฉัยและการรักษา'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident — autopsy of patient died from COVID-19 — pathologic findings of acute + late COVID + multidisciplinary lessons learned + biosafety during autopsy', '[{"label":"A","text":"Skip"},{"label":"B","text":"COVID-19 Autopsy Pathology"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** COVID-19 Autopsy Pathology: (1) **Biosafety in autopsy**: - SARS-CoV-2 RG-3 agent but autopsy can be performed in BSL-2/-3-enhanced with appropriate PPE; - **PPE**: N95/PAPR, double gloves, fluid-resistant gown, eye protection, face shield, dedicated room with negative pressure ideal, limited personnel; - **Power tools** (oscillating saws — aerosols) — use hand tools when possible or with HEPA-filtered enclosures; - **Minimal procedure approach** for confirmed COVID — needle biopsy or limited autopsy when full exam not feasible; - **Specimen handling** with infection control protocols; (2) **Acute COVID-19 pulmonary pathology**: - **Diffuse alveolar damage (DAD)**: hyaline membranes (acute exudative phase), edema, type II pneumocyte hyperplasia, organizing pneumonia (proliferative phase), fibrosis (chronic); - **Vascular**: microthrombi + pulmonary embolism + endothelial injury — distinguishes from typical ARDS; angiocentric inflammation; - **Megakaryocytes** in pulmonary capillaries; - **Variable inflammatory infiltrate** (lymphocytes, macrophages); - **Hemorrhagic features**; (3) **Extrapulmonary findings**: - **Cardiac**: myocarditis, microthrombi, infarction; - **Renal**: acute tubular injury, FSGS-collapsing (especially APOL1 high-risk), thrombotic microangiopathy; - **Liver**: steatosis, mild necrosis, vascular thrombosis; - **CNS**: hypoxic injury, microhemorrhages, vasculitis-like, viral encephalitis rare, brainstem involvement debated; - **Skin**: vasculopathy, thrombotic; - **GI**: ischemia, viral infection; (4) **Post-mortem virologic studies**: - SARS-CoV-2 RNA detection by RT-PCR in tissues; - IHC for viral antigens; - Distinguish acute infection from post-mortem secondary findings; (5) **Long COVID + post-acute sequelae (PASC) pathology**: - Pulmonary fibrosis progression; - Cardiac (myocarditis, pericarditis, autonomic); - Neurologic (cognitive, neuropathy, fatigue); - Multi-organ — research ongoing; - Limited autopsy data — research cohorts; (6) **Multidisciplinary lessons learned**: - **Therapeutics**: dexamethasone (RECOVERY), anticoagulation (UH/LMWH for hospitalized), tocilizumab/baricitinib (IL-6/JAK), remdesivir, oral antivirals (Paxlovid, molnupiravir) — pathology contributing biology understanding; - **Vaccines** + boosters + variant tracking; - **Pediatric MIS-C** distinct entity — multisystem inflammatory; - **Healthcare worker** safety + community public health; - **Pandemic preparedness** investment + lab capacity; (7) **Tissue banking + research consortia** essential for understanding emerging diseases; (8) **Communication + family**: empathy + clear information about cause + sequelae for survivors; (9) **Public health reporting + surveillance**: deaths from COVID + cause; vital statistics integration; (10) **Equity considerations**: disparities in COVID outcomes (race, ethnicity, age, comorbidity, socioeconomic) reflected in autopsy populations + lessons for future

---

COVID-19 autopsy: BSL-2/-3 enhanced PPE, minimize aerosol. Pathology: DAD + microthrombi + vascular (distinguishes from typical ARDS) + multi-organ (cardiac, renal, CNS, GI). Long COVID research. Therapeutics evolved (dex, anticoagulation, IL-6/JAK, antivirals, vaccines). Tissue banking critical for emerging disease.', NULL,
  'medium', 'forensic', 'review',
  'pathology', 'clinical_decision', 'forensic', 'adult',
  'CDC COVID Autopsy; AJP COVID Studies', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Resident — autopsy of patient died from COVID-19 — pathologic findings of acute + late COVID + multidisciplinary lessons learned + biosafety during autopsy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident question — fundamentals of histotechnology — tissue grossing + sampling principles + cassette labeling + cassettes + processing workflow', '[{"label":"A","text":"Random"},{"label":"B","text":"CAP cancer protocols"},{"label":"C","text":"Skip"},{"label":"D","text":"Random"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Histotechnology Workflow: (1) **Gross examination**: - Specimen identification + verification; - Orient + describe (size, color, consistency, lesions); - Ink margins (if applicable for margin assessment — different colors per orientation); - Section + select representative samples per CAP cancer protocols + ADASP guidelines; - Cassette + label uniquely; - Document grossing notes; (2) **Sampling principles**: - **Margins**: shave (en face) vs perpendicular (radial — measures distance more accurately for tumors); - **Lymph nodes**: bisect through hilum; multiple cassettes if many; - **Tumors**: representative sections of tumor + tumor-normal interface + closest margins + special features (nerves, vessels); - **CAP cancer protocols** specify minimum sections per type; - **Inadequate sampling** → reportable findings missed (e.g., capsular invasion in thyroid, depth of invasion in cancers); (3) **Cassette workflow**: - Unique identifier (case + block number + technologist initial); - Tissue + chemical processing in batches; - **Embed**: paraffin orientation matters (oriented to show full thickness, all layers, specific structures); biopsies must be embedded on edge for proper layers; (4) **Microtomy**: - Section thickness 3-5 μm typical; thinner for some IHC; - **Microtome** types: rotary (standard), sliding (large blocks), cryostat (frozen); - Section onto warm water bath then slides; - **Levels** taken for diagnostic depth + ribbon for IHC + special stains; (5) **Slide labeling**: barcoded; matched to cassette + case; (6) **Staining**: routine H&E auto-stainers; special stains separate; IHC auto-stainers (Ventana, Leica); (7) **Quality + safety**: - **Sharps** — microtome blades + needles — proper handling + disposal; - **Chemical** — xylene, alcohol, formalin — ventilation + PPE + waste; - **Tissue identification** — verify match throughout workflow (mismatched tissue catastrophic); - **Cross-contamination** (''floater'') prevention — clean instruments, water bath surface, environment; - **Documentation + chain of custody**; (8) **Turnaround**: routine biopsy ~ 24 hr to slide; surgical resection 1-3 d; large complex specimens longer; (9) **Special techniques**: - **Decalcification** for bone (EDTA preferred for IHC + molecular); - **Frozen section** intraoperative — cryostat, fast H&E or toluidine blue; - **Plastic embedding** for high-resolution (renal, BM, EM); - **EM** for ultrastructure (kidney, neurology, ciliary dyskinesia); (10) **CAP histology checklist** — comprehensive requirements; (11) **Modern advances**: digital workflow tracking, automation, AI-assisted gross + microscopy

---

Histo workflow: gross (ID, ink, sample per CAP) → cassette → process → embed (orientation matters) → microtomy (3-5 μm) → stain. Sampling principles. Safety: sharps + chemical + tissue ID + floater prevention. Special: decal, frozen, plastic, EM. CAP histology checklist. Modern automation + tracking.', NULL,
  'easy', 'quality_safety', 'review',
  'pathology', 'basic_science', 'quality_safety', 'mixed',
  'CAP Histology; ADASP; Bancroft', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Resident question — fundamentals of histotechnology — tissue grossing + sampling principles + cassette labeling + cassettes + processing workflow'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident — fundamentals of special histochemical stains beyond H&E — PAS, GMS, mucicarmine, trichrome, reticulin, Congo red, iron stain — applications + interpretation', '[{"label":"A","text":"Random"},{"label":"B","text":"Special Histochemical Stains"},{"label":"C","text":"Random"},{"label":"D","text":"Skip"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Special Histochemical Stains: (1) **PAS (Periodic Acid-Schiff)**: - Stains carbohydrates (glycogen, glycoproteins, basement membranes, fungi cell wall, mucin); - PAS-positive (pink-magenta); - **PAS with diastase (PAS-D)** — diastase digests glycogen → distinguishes glycogen from other PAS+ material (e.g., alpha-1 antitrypsin globules in liver — PAS+, diastase-resistant; clear cell tumors glycogen — PAS+, diastase-cleared); - Applications: basement membrane (renal — thickening in diabetic nephropathy), fungi (with GMS), liver disorders, glycogen storage; (2) **GMS (Grocott methenamine silver)**: - Silver stain for fungi cell wall + Pneumocystis jirovecii — black against pale background; - Best stain for visualizing fungal elements in tissue; - **PJP (Pneumocystis)** — disk-shaped cysts (''crushed ping pong ball'' or ''helmet''); - Aspergillus septate hyphae 45°, Mucor broad ribbon-like 90°, Candida budding yeast + pseudohyphae, Cryptococcus capsule (also mucicarmine + Fontana-Masson); (3) **Mucicarmine**: - Stains mucin red (Mayer mucicarmine); - **Cryptococcus capsule** stains red (helpful), differentiates from other yeast; - Mucinous tumors; (4) **Alcian Blue**: - Acidic mucins blue (vs PAS for neutral); - Combined Alcian blue/PAS distinguishes mucin types; - Sulfated GAGs at low pH; (5) **Masson''s Trichrome**: - Collagen blue/green, muscle red, nuclei dark; - Used for fibrosis assessment — liver fibrosis (Ishak/METAVIR staging), pulmonary fibrosis, kidney; (6) **Reticulin (Gordon-Sweet or Wilder)**: - Reticular fibers (type III collagen) black on silver background; - **Loss of reticulin framework in hepatocellular carcinoma** (distinguishes from benign hepatocyte lesions); - **BM thickness assessment**, lymph node architecture; - **MF (myelofibrosis) grading** in BM; (7) **Congo Red**: - **Amyloid** — orange/red on standard light; **apple-green birefringence** under polarized light — diagnostic; - Workup further for amyloid typing (mass spectrometry preferred over IHC for accurate typing — AA, AL, ATTR, etc.); (8) **Prussian Blue**: - Iron (hemosiderin) — blue; - Hemosiderosis, hemochromatosis (liver + heart + other), iron-deficiency screening (BM iron stores); (9) **Other useful stains**: - **Verhoeff-Van Gieson (VVG)**: elastic fibers (black) + collagen (red) — vasculitis assessment, dissection; - **Toluidine blue**: mast cells (metachromatic), bone biopsy (mineralization); - **Giemsa**: bone marrow, blood smear, Helicobacter, Leishmania, Histoplasma; - **Warthin-Starry**: spirochetes (syphilis), Bartonella; - **Oil Red O**: lipids (frozen sections); - **Von Kossa**: calcium (bone, calcifications); - **Periodic Acid-Methenamine Silver (PAMS, Jones)**: renal GBM; (10) **Selecting stain**: based on clinical question + initial findings; modern complement of IHC + molecular but still essential

---

Special stains: PAS (carbs, BM, fungi), PAS-D (distinguish glycogen), GMS (fungi+PJP), mucicarmine (mucin+Cryptococcus), Alcian blue (acid mucin), trichrome (collagen), reticulin (HCC loss + MF grading + BM), Congo red (amyloid apple-green), Prussian blue (iron), VVG (elastic), Giemsa (BM+organisms), Warthin-Starry (spirochetes).', NULL,
  'medium', 'quality_safety', 'review',
  'pathology', 'basic_science', 'quality_safety', 'mixed',
  'Bancroft Theory + Practice; CAP Histology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Resident — fundamentals of special histochemical stains beyond H&E — PAS, GMS, mucicarmine, trichrome, reticulin, Congo red, iron stain — applications + interpretation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident — fundamentals of electron microscopy in pathology — applications in renal, neurology, cilia, infectious + tumor diagnosis + sample preparation + limitations vs IHC + molecular', '[{"label":"A","text":"Random"},{"label":"B","text":"Electron Microscopy in Pathology"},{"label":"C","text":"Random"},{"label":"D","text":"Skip"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Electron Microscopy in Pathology: (1) **Concept**: uses electron beam (much shorter wavelength than light) → high-resolution imaging of ultrastructure (nanometer-level resolution); reveals subcellular detail invisible by LM; (2) **Sample preparation** (specialized + time-consuming): - **Glutaraldehyde fixation** (better ultrastructural preservation than formalin); - **Post-fix osmium tetroxide**; - **Dehydration + epoxy resin embedding** (smaller blocks); - **Semi-thin sections** (~ 1 μm) on toluidine blue — used for orientation + selection; - **Ultra-thin sections** (~ 60-100 nm) cut on ultramicrotome; - **Stain** uranyl acetate + lead citrate; - **TEM (transmission EM)** standard for pathology — image is projection through thin section; - **SEM (scanning EM)** — surface imaging — less common in path; (3) **Major clinical applications** (still ''gold standard'' in some areas despite IHC + molecular advances): - **Renal pathology**: - Glomerular disorders — diabetic nephropathy (thickened GBM), MN (subepithelial deposits + spikes), MPGN (subendothelial), IgA (mesangial), Alport (alternating thick + thin GBM with lamellation), TBM disease, lupus (variable + ''fingerprint'' deposits); - **Distinguishing podocyte injury patterns** (foot process effacement); - **Inclusions** — tubuloreticular (interferon — lupus, viral); - **Neuropathology**: - Nerve biopsy — myelin assessment (CIDP, CMT, vasculitis), axonal vs demyelinating, onion bulbs; - Muscle biopsy — mitochondrial (ragged red, paracrystalline inclusions), inclusion body myositis, glycogen storage, lipid disorders; - Brain biopsy — viral inclusions, prion (vacuolation), storage diseases; - **Cilia disorders (primary ciliary dyskinesia)**: examination of axoneme structure (9+2 microtubular arrangement, dynein arms, central pair, radial spokes) — confirms PCD; - **Tumor diagnosis** (selected — IHC + molecular largely replaced): - Neuroendocrine — dense-core granules; - Melanoma — melanosomes (premelanosomes); - Histiocytic — Birbeck granules (Langerhans cell), lysosomes; - Rhabdoid (intermediate filament whorls); - Mesothelioma — long thin microvilli (vs adenocarcinoma); - Storage disorders + lysosomal diseases — characteristic inclusions; - **Infectious diseases**: viral inclusions (CMV, HSV, polyomavirus, HPV, COVID), bacterial localization, parasites; - **Platelet disorders**: dense granule deficiency (storage pool disease); (4) **Limitations**: - Specialized equipment + skilled personnel — limited to academic/reference centers; - Time-consuming + expensive; - Small sample area (subsampling); - Static morphology (no functional info); - Largely superseded by IHC + molecular in tumor diagnosis; (5) **Modern complement**: - Immune EM (gold-labeled Ab) — research mostly; - Correlative light + EM (CLEM) — emerging; - Cryo-EM — research/structural biology; - Connectomics in neurology; (6) **Future role**: smaller, faster microscopes; AI-assisted analysis; complementary to molecular for ultrastructural details

---

EM: ultrastructural resolution; specialized prep (glutaraldehyde, osmium, epoxy, ultra-thin). Applications: renal (GBM, deposits, podocyte FPE, inclusions), nerve/muscle, cilia (PCD), tumor (neuroendocrine granules, melanosomes, Birbeck, mesothelioma microvilli), viral, storage. Largely replaced for tumors but gold-standard in renal/cilia/nerve-muscle.', NULL,
  'medium', 'renal_pathology', 'review',
  'pathology', 'basic_science', 'renal_pathology', 'mixed',
  'Bancroft; Ghadially Diagnostic EM', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Resident — fundamentals of electron microscopy in pathology — applications in renal, neurology, cilia, infectious + tumor diagnosis + sample preparation + limitations vs IHC + molecular'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident — fundamentals of qPCR + ddPCR (droplet digital PCR) for molecular diagnostics — principles + applications + advantages of ddPCR over qPCR + clinical use', '[{"label":"A","text":"Same as Sanger"},{"label":"B","text":"qPCR + ddPCR for Clinical Diagnostics"},{"label":"C","text":"Random"},{"label":"D","text":"Skip"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** qPCR + ddPCR for Clinical Diagnostics: (1) **qPCR (quantitative real-time PCR)**: - Amplifies + quantifies DNA in real-time using fluorescent reporters; - **TaqMan probes** (5''-nuclease — releases reporter from quencher), SYBR Green (binds dsDNA non-specifically); - **Threshold cycle (Ct)** = cycle at which fluorescence crosses threshold — proportional to starting template (log scale); - **Quantification**: relative (delta-delta Ct vs reference) or absolute (standard curve); - **Multiplex** — multiple targets in one reaction with different fluorochromes; - **Sensitivity**: ~ 1 in 10⁴-10⁵; (2) **ddPCR (droplet digital PCR)**: - DNA template partitioned into ~ 20,000 oil-in-water droplets (each tiny reaction); - PCR runs in each droplet → end-point + counted as positive (template present) or negative; - **Poisson statistics** → absolute concentration without standard curve; - **Higher precision + sensitivity** (~ 1 in 10⁵-10⁶) vs qPCR; - Less inhibitor sensitive; (3) **Clinical applications**: - **BCR-ABL1 quantification (CML monitoring)** — qPCR + IS standardization for MRD; ddPCR emerging more sensitive for DMR + treatment-free remission; - **HIV viral load** — qPCR clinical standard; ddPCR for low-level reservoir; - **CMV viral load** post-transplant; - **HBV, HCV viral loads**; - **Tumor mutation detection in ctDNA (liquid biopsy)**: - **EGFR T790M, C797S** monitoring resistance; - **KRAS G12C**, **BRAF V600E**, **PIK3CA**; - **MRD monitoring** in solid tumors (CRC, breast, lung) + heme — ddPCR or NGS-based; - **CSF tumor DNA** (CNS lymphoma, brain tumors); - **Cell-free fetal DNA (NIPT)** — non-invasive prenatal aneuploidy screening; - **Microbial loads**; - **Gene expression** quantification; - **Copy number variation** (HER2, MET); (4) **Comparison qPCR vs ddPCR**: - qPCR — faster, cheaper, well-established, broader equipment availability; standard for many viral loads; - ddPCR — higher sensitivity + precision for rare events, MRD, ctDNA, CNV; absolute quantitation; (5) **Sample types**: serum/plasma (cell-free DNA), tissue (FFPE — DNA fragmented, optimized assays needed), blood/marrow cells; (6) **Pre-analytical**: blood collection tubes (Streck/cell-free DNA preservation tubes for ctDNA), processing timing, DNA extraction methods; (7) **Quality**: validation, controls (positive, negative, no-template), reference materials, EQA/PT (NIST standards available); CAP/CLIA validation requirements; (8) **Future**: combined with NGS, point-of-care molecular, multiplex panels, more sensitive ctDNA approaches; (9) **Limitations**: - qPCR — limited dynamic range, standard curve required; - ddPCR — small dynamic range, equipment-specific; - Both — target known (vs NGS discovery)

---

qPCR: real-time amplification with fluorescent reporters; Ct values; multiplex. ddPCR: droplet partition + end-point + Poisson → absolute quant + higher sensitivity. Applications: BCR-ABL MRD, viral loads (HIV/CMV/HBV), ctDNA mutations (EGFR T790M), MRD solid tumor, NIPT. ddPCR for rare events; qPCR broader use.', NULL,
  'medium', 'molecular_pathology', 'review',
  'pathology', 'basic_science', 'molecular_pathology', 'mixed',
  'AMP/CAP Molecular Pathology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Resident — fundamentals of qPCR + ddPCR (droplet digital PCR) for molecular diagnostics — principles + applications + advantages of ddPCR over qPCR + clinical use'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Lab manager — implementing IVD/LDT (in-vitro diagnostic vs laboratory-developed test) validation + verification + analytical performance characteristics + clinical validity + regulatory pathway (FDA IVD-R, VALID Act)', '[{"label":"A","text":"Random"},{"label":"B","text":"IVD/LDT Validation + Regulatory Framework"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** IVD/LDT Validation + Regulatory Framework: (1) **Definitions**: - **IVD (In Vitro Diagnostic)** — manufacturer-developed + FDA-cleared/approved or CE-marked; sold for diagnostic use; - **LDT (Laboratory Developed Test)** — developed + validated + performed in single CLIA-certified lab; modified IVDs also can be LDT; - **PMA, 510(k), de novo** — FDA pathways for IVDs; (2) **Validation (LDT) vs verification (IVD)**: - **Validation** — full evaluation of performance characteristics (LDTs + modified IVDs): - **Accuracy** — agreement with reference method (correlation, bias); - **Precision** — reproducibility (intra-day, inter-day, between operators, between instruments — coefficient of variation); - **Analytical sensitivity** — lowest detectable concentration (LoD, LoQ); - **Analytical specificity** — interference + cross-reactivity; - **Reportable range** — linearity + dynamic range; - **Reference intervals** — population-specific or verify manufacturer''s; - **Sample stability + collection conditions**; - **Verification** (IVDs in your lab) — abbreviated: confirm manufacturer claims in your environment with smaller sample size; (3) **Sample requirements** (CLSI EP guidance): - Accuracy — 40+ samples spanning range, comparison with reference; - Precision — multiple replicates over days; - Sensitivity — diluted samples near LoD; - Specificity — interfering substances + cross-reactivity panel; (4) **Clinical validity + utility**: - **Clinical sensitivity + specificity** — performance in target population; - **Predictive values** + likelihood ratios; - **Outcome impact** — guides clinical decision + improves outcome; - **Health technology assessment** for adoption decisions; (5) **Documentation**: - Validation/verification plan; - Standard operating procedure (SOP); - Test characteristics summary; - Lab director signoff; - **Regular performance monitoring** ongoing (QC, PT, occurrence management); (6) **Regulatory landscape**: - **CLIA + CMS** — minimum federal lab standards (US); - **CAP** accreditation + checklists; - **FDA traditional ''enforcement discretion'' for LDTs** historically; - **FDA rule 2024** — moving toward FDA oversight of LDTs in phased approach; - **VALID Act** (proposed US legislation) — proposed risk-based framework; - **EU IVDR (In Vitro Diagnostic Regulation)** — implemented + risk-based; - **Country-specific** — Thai FDA, others; (7) **Companion diagnostics**: - Developed alongside therapeutic; - FDA cleared/approved; - Linked to specific drug labeling; - E.g., HER2 IHC + FISH for trastuzumab; EGFR mutation testing for osimertinib; PD-L1 + IO drugs; (8) **Modifications**: - **Modified FDA-cleared test** = LDT validation required; - **Unmodified IVD use only requires verification**; (9) **Sample storage + biobanking**: ethical + regulatory + research considerations; (10) **Quality improvement**: validation findings + ongoing performance feed back to improvement

---

IVD vs LDT: validation (LDT — full) vs verification (IVD — abbreviated). Characteristics: accuracy, precision, sensitivity (LoD), specificity, range, reference intervals. CLSI EP. Clinical validity + utility. Companion Dx FDA-linked. Regulatory: CLIA, CAP, FDA LDT rule 2024, EU IVDR, VALID Act. Documentation + ongoing performance.', NULL,
  'hard', 'quality_safety', 'review',
  'pathology', 'ems_mgmt', 'quality_safety', 'mixed',
  'CLSI EP series; CAP All Common; FDA IVD', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Lab manager — implementing IVD/LDT (in-vitro diagnostic vs laboratory-developed test) validation + verification + analytical performance characteristics + clinical validity + regulatory pathway (FDA IVD-R, VALID Act)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Lab manager — implementing reagent + supply management + inventory control + lot-to-lot verification + expiration + minimum vs maximum stock + just-in-time vs buffer + supply chain risk', '[{"label":"A","text":"Random"},{"label":"B","text":"Lab Reagent + Supply Management"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Lab Reagent + Supply Management: (1) **Inventory control**: - **Reagent + consumable tracking** — barcoded, dated, lot tracked; - **First-in-first-out (FIFO)** rotation; - **Expiration monitoring** — alerts before expiry, use older first; - **Min/max stock levels** — ensure availability vs avoid waste; - **Reorder points** based on usage + lead time + buffer; - **Just-in-time vs buffer stock** — balance cost + risk; supply chain risk demands more buffer for critical reagents; (2) **Lot-to-lot verification**: - **CLSI guidelines** (EP26 — user evaluation of acceptability); - **CAP requirement**: each new lot of reagent must be validated/verified before clinical use — different acceptability for different test types (chemistry, IHC, microbiology, molecular); - **Methods**: parallel testing with old lot using patient samples + controls; analyze means, biases, precision; statistical tests (Bland-Altman, mountain plot, Deming regression); - **Document** acceptance criteria + decisions; - **Reject lots** — investigate + alternative supply; (3) **Reagent storage**: - **Temperature monitoring** continuous (refrigerators 2-8°C, freezers -20°C/-80°C, room temp 15-30°C); - **Alarms** for excursions; - **Backup power** + plan for failures; - **Calibrated thermometers** + traceable; - **Logs** + reviews; (4) **Supply chain risk management** (highlighted post-COVID-19, geopolitical, natural disasters): - **Multiple suppliers** when possible; - **Inventory buffer** for critical items; - **Vendor performance monitoring** + service-level agreements; - **Alternative methods/platforms** identified in advance; - **Mutual aid agreements** with other labs; - **Tracking + communication** during shortages; (5) **Cost control**: - **Standardization** of reagents across platforms; - **Bulk purchase agreements**; - **Waste reduction** (FIFO, right-sizing, smart reagent design); - **Cost per result** + total cost of ownership analysis; - **Reagent share networks** for rare/expensive tests; (6) **Quality**: - **Receipt inspection** — temperature integrity (cold chain), packaging intact, documentation; - **Quarantine** until lot acceptance; - **Reagent rental + service contracts** — vendor accountability; - **Service + maintenance** schedules; (7) **Special considerations**: - **Hazardous chemicals** — SDS available, training, PPE, segregated storage; - **Controlled substances** (e.g., narcotic standards) — DEA registration + tracking; - **Radioactive reagents** — Nuclear Regulatory Commission + radiation safety; - **Biologics** — cold chain, infectious risk; - **Custom oligos/primers** — design + verification; (8) **Vendor management**: - **Approved vendor list**; - **Performance reviews**; - **Contracts** + pricing; - **Compliance** (FDA-registered, ISO-certified); (9) **Disposal**: - **Hazardous waste** segregation + manifests; - **Biological waste** — autoclave/incinerator; - **Sharps**; - **Confidential** specimens; (10) **Technology**: laboratory inventory management software, RFID tracking, automated ordering

---

Lab reagent management: inventory (FIFO, expiry alerts, min/max, reorder points). Lot-to-lot verification (CLSI EP26, CAP) — parallel testing + statistical comparison. Storage temp monitoring + backup. Supply chain risk — multiple suppliers + buffer. Cost control + waste reduction. Hazardous + biologic + sharps disposal.', NULL,
  'medium', 'quality_safety', 'review',
  'pathology', 'ems_mgmt', 'quality_safety', 'mixed',
  'CAP All Common; CLSI EP26', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Lab manager — implementing reagent + supply management + inventory control + lot-to-lot verification + expiration + minimum vs maximum stock + just-in-time vs buffer + supply chain risk'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Lab personnel — competency assessment + continuing education + workforce planning + diversity + equity inclusion + leadership development + retention', '[{"label":"A","text":"Random"},{"label":"B","text":"Lab Workforce Management"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Lab Workforce Management: (1) **Competency assessment**: - **CLIA 6 elements** required annually for clinical lab personnel: (1) direct observation of routine work, (2) monitoring/review of patient results/recording, (3) review of QC/instrument maintenance, (4) blinded sample analysis, (5) problem-solving evaluation, (6) review of test performance/SOP knowledge; - Documented + signed by supervisor; - **Initial competency** for new staff; - **Annual competency** for ongoing; - **6-month competency** within first year (CLIA 2024 update); - **Pre-employment** training + tracking; - **Remediation** for performance issues; (2) **Continuing education**: - Required for licensure/certification maintenance (varies by state + role); - CMP credits (continuing medical/professional); - Conferences, journals, online modules, webinars; - In-house training + grand rounds; - Online platforms (CAP, ASCP, etc.); (3) **Workforce planning**: - **Skill mix** — pathologists, lab managers, technologists (MLS — medical lab scientist, MLT — medical lab technician), pathologist assistants, cytotechnologists, histotechnologists, phlebotomists, IT, admin; - **Staffing models** matched to volume + complexity + 24/7 demands; - **Succession planning** for leadership + critical roles; - **Cross-training** for flexibility + coverage; - **Growing shortage** — workforce gaps significant in US + globally + Thailand; (4) **Diversity, Equity, Inclusion (DEI)**: - Diverse workforce reflects + serves diverse patients; - Recruitment from underrepresented groups; - Equitable advancement + promotion; - **Inclusive culture** — psychological safety, bias training; - **Mentorship + sponsorship**; - Pay equity audits; (5) **Leadership development**: - **Identify + develop emerging leaders** — formal programs, stretch assignments, mentorship; - **Pathology informatics, transfusion, molecular** subspecialty leaders; - **Diversity in leadership** — pipeline; - **Lab director** roles (board-certified pathologist with management); - **Soft skills**: communication, change management, financial literacy, EQ; (6) **Retention**: - **Engagement surveys** + action; - **Career pathways** + advancement opportunities; - **Compensation** competitive + transparent; - **Work-life balance** + flexibility; - **Recognition** + appreciation; - **Wellness + mental health** support; - **Burnout prevention** — adequate staffing, workflow design, voice in decisions; (7) **Pathology workforce specifically**: - **Pathologist shortage** worldwide; aging workforce; - **AI + digital pathology** transforming roles — augmented intelligence + workflow; - **Subspecialization** vs generalist balance; - **Telepathology** expanding access + flexibility; (8) **Training pipeline**: - **MLS/MLT programs** — needed expansion; - **Pathology residency + fellowship** — workforce planning; - **Public investment in training**; - **Loan repayment** programs incentivize; (9) **Regulatory compliance**: - Personnel records, licensure verification, immunizations, health screens; - **CLIA personnel requirements** by test complexity (waived, moderate, high); (10) **Healthy workplace culture** essential — drives quality + retention + innovation

---

Lab workforce: CLIA 6-element competency assessment (annual). Continuing ed. Skill mix + staffing + succession + cross-training. DEI + mentorship. Leadership development. Retention via engagement + advancement + wellness + adequate staffing. Pathology workforce shortage; AI + digital + telepath transforming. Training pipeline investment.', NULL,
  'medium', 'quality_safety', 'review',
  'pathology', 'ems_mgmt', 'quality_safety', 'mixed',
  'CLIA Personnel; CAP HR', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Lab personnel — competency assessment + continuing education + workforce planning + diversity + equity inclusion + leadership development + retention'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Patient with checkpoint inhibitor (immunotherapy) — pembrolizumab — developed colitis + thyroiditis + pneumonitis (irAE — immune-related adverse events); multidisciplinary pathology + integrative management', '[{"label":"A","text":"Random"},{"label":"B","text":"Immune Checkpoint Inhibitor (ICI) Toxicities — Pathology + Management"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Immune Checkpoint Inhibitor (ICI) Toxicities — Pathology + Management: (1) **Background**: ICIs (anti-PD-1: pembrolizumab, nivolumab; anti-PD-L1: atezolizumab, durvalumab; anti-CTLA-4: ipilimumab; anti-LAG-3: relatlimab) revolutionized oncology; immune-related adverse events (irAEs) common, can affect any organ; (2) **Common irAEs by organ + pathology**: - **Colitis** (~ 10-25%, more with anti-CTLA-4 + combinations): - Biopsy: acute + chronic inflammation, intraepithelial lymphocytosis, crypt apoptosis (apoptotic bodies — increased in basal crypts), neutrophilic infiltrate, ulceration; - Pattern variable — diffuse, focal active, mimics IBD; - **Thyroiditis**: hypothyroidism (more common) or hyperthyroidism (transient → hypothyroidism); silent thyroiditis pattern; - **Pneumonitis** (~ 5%, often severe — leading cause of ICI mortality): - Imaging: ground-glass, consolidation, organizing pneumonia, NSIP-like, COP, AIP/DAD severe; - Biopsy: cellular interstitial inflammation, lymphocytic alveolitis ± organizing pneumonia ± DAD; - **Hepatitis**: lobular + portal hepatitis with mixed inflammation, granulomas possible, lobular ± central; mimics autoimmune hepatitis but DRESS or other patterns; - **Endocrinopathies**: hypophysitis (pituitary — anti-CTLA-4 > anti-PD-1), thyroiditis, adrenal insufficiency, type 1 diabetes (rapid onset, often DKA at presentation); - **Dermatologic**: rash, pruritus, vitiligo, bullous pemphigoid, lichenoid, SJS/TEN; - **Nephritis** (interstitial nephritis); - **Cardiac**: myocarditis (rare but severe, high mortality — biopsy: lymphocytic infiltrate); - **Neurologic**: myasthenia gravis, encephalitis, neuropathies; - **Hematologic**: AIHA, ITP, neutropenia; - **Musculoskeletal**: arthritis, myositis (overlap with myocarditis + myasthenia — ''triple-M'' syndrome); - **Ocular**: uveitis; (3) **Diagnosis**: - **High clinical suspicion** — symptoms during ICI; - **Rule out infection** + progression; - **Biopsy** when indicated to confirm + grade; - **Labs** organ-specific (TSH, ACTH, cortisol, glucose, LFTs, Cr); (4) **Grading (CTCAE)**: G1 mild — G4 life-threatening; (5) **Management** (NCCN, ASCO, ESMO, SITC guidelines): - **G1-2**: continue ICI ± symptomatic; - **G2 (moderate)**: hold ICI; topical/oral steroids; - **G3-4 (severe)**: hospitalize, high-dose IV steroids (1-2 mg/kg/d prednisone equivalent), if no response in 48-72 h → **steroid-refractory** — biologics: infliximab/vedolizumab (colitis), MMF/tacrolimus (hepatitis), IVIG/PLEX (neurologic, myocarditis), tocilizumab (myocarditis emerging); - **ICI discontinuation** decisions case-by-case — sometimes resume after resolution if benefit > risk; some irAEs preclude restart (myocarditis, pneumonitis severe); - **Endocrinopathies** — usually managed with hormone replacement + ICI continued (unlike other irAEs); (6) **Multidisciplinary ''irAE team''**: medical oncology + organ-specialist + pathology + endocrinology + dermatology + ID + pharmacy + supportive; (7) **Pathology role**: distinguish irAE from progression, infection, secondary cause; help in steroid-refractory decisions

---

ICI irAEs: any organ. Pathology: colitis (apoptotic bodies, mixed inflammation), pneumonitis (cellular interstitial + OP), hepatitis (lobular inflammation), thyroiditis, hypophysitis, type 1 DM (rapid DKA), myocarditis (severe), ''triple-M''. NCCN/ASCO guidelines: hold + steroids; biologics for refractory. Multidisciplinary irAE team.', NULL,
  'hard', 'hemato_onco', 'review',
  'pathology', 'integrative', 'hemato_onco', 'adult',
  'NCCN/ASCO/ESMO/SITC irAE Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Patient with checkpoint inhibitor (immunotherapy) — pembrolizumab — developed colitis + thyroiditis + pneumonitis (irAE — immune-related adverse events); multidisciplinary pathology + integrative management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 80 ปี — multiple comorbidities + frailty + cancer diagnosis; geriatric assessment + integrative care + treatment decision-making + multidisciplinary', '[{"label":"A","text":"Random"},{"label":"B","text":"Geriatric Oncology + Integrative Care"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Geriatric Oncology + Integrative Care: (1) **Increasing relevance**: > 60% cancers in age ≥ 65; aging population + complex treatments; need for individualized geriatric-focused approach; (2) **Comprehensive Geriatric Assessment (CGA)** (ASCO recommends for adults ≥ 65 starting chemo): - **Functional status**: ADLs, IADLs, gait + balance, falls; - **Comorbidity burden**: CIRS-G, Charlson; - **Cognitive function**: Mini-Cog, MMSE, MoCA; - **Psychological**: GDS for depression, anxiety; - **Nutrition**: weight loss, BMI, Mini Nutritional Assessment; - **Social support**: caregiver, isolation, finances; - **Polypharmacy** + Beers criteria for inappropriate medications; - **Frailty** assessment — phenotype (Fried) or deficit accumulation (Rockwood); (3) **Implementation**: - **CGA-derived interventions** (GAIN, GAP70+ trials) reduce chemotherapy toxicity + improve outcomes; - **CARG (Cancer + Aging Research Group) toxicity score**, **CRASH** score for predicting chemo toxicity; - **G8 screening tool** + abbreviated forms for clinic flow; (4) **Treatment decision-making**: - **Goals of care discussion** integral — life expectancy, treatment goals (cure vs prolonging life vs palliation); - **Match treatment intensity to functional reserve** — modified regimens for vulnerable/frail patients; - **Drug interactions** + dosing adjustments (renal/hepatic function — age-related decline); - **Supportive care upfront**: granulocyte CSF + antiemetic + hydration; - **Geriatrician + oncologist co-management**; - **Patient + family preferences** central; (5) **Pathology considerations in elderly**: - Biopsy considerations — frailty + procedure tolerance; - Specimen handling + interpretation similar but consider co-morbidities; - **Indolent vs aggressive disease** decisions — observe vs treat — pathologic features inform; - **Older patients underrepresented in trials** — extrapolating evidence; - Increased prevalence of MGUS, low-grade lymphomas, indolent prostate ca, well-diff thyroid ca — over-treatment risk; (6) **Multidisciplinary integrative team**: - Geriatrician + medical onc + nurses (geriatric oncology nurses) + social work + pharmacy + nutrition + PT/OT + mental health + palliative + family + caregiver; - Care coordination + navigation; - **Home care + hospice transitions**; (7) **Survivorship + chronic care**: - Long-term cancer survivors with comorbidity + late effects; - Integrated primary care + oncology; - Bone health, cardio-onc, psychosocial; (8) **Equity**: - Older adults disparities — access, ageism in treatment, financial; - Diverse older populations including Thai contextual considerations (family-centered, hierarchical decision-making, religious/spiritual); (9) **Research + evidence**: - Aging-related research increasing; - Inclusion of older adults in trials advocated (ASCO/FDA initiatives); (10) **Cultural sensitivity**: Asian + Thai cultural context — family decisions, elders'' autonomy, end-of-life beliefs; (11) **Workforce**: geriatricians + geriatric oncology specialists scarce — training pipelines + integration into general oncology + primary care

---

Geriatric oncology: CGA (functional, comorbidity, cognitive, psychological, nutrition, social, polypharmacy, frailty). CARG + CRASH toxicity prediction. Match intensity to reserve; goals of care central. Pathology — biopsy + indolent vs aggressive considerations + over-treatment risk. Multidisciplinary + equity + cultural sensitivity.', NULL,
  'medium', 'hemato_onco', 'review',
  'pathology', 'integrative', 'hemato_onco', 'adult',
  'ASCO Geriatric; SIOG', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 80 ปี — multiple comorbidities + frailty + cancer diagnosis; geriatric assessment + integrative care + treatment decision-making + multidisciplinary'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี — multinodular goiter + biopsy: medullary thyroid carcinoma — C-cells; IHC: calcitonin+, CEA+, chromogranin+, TTF-1+, thyroglobulin negative; molecular: RET mutation; การวินิจฉัยและการรักษา', '[{"label":"A","text":"Papillary thyroid"},{"label":"B","text":"Medullary Thyroid Carcinoma (MTC)"},{"label":"C","text":"Anaplastic"},{"label":"D","text":"Refuse"},{"label":"E","text":"Lymphoma"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Medullary Thyroid Carcinoma (MTC): (1) **Origin**: parafollicular **C-cells** (neuroendocrine — produce calcitonin); ~ 1-2% of thyroid cancers; (2) **Histology**: - Sheets, nests, trabeculae, lobules of polygonal/spindle cells; - **Amyloid** stroma (Congo red + apple-green birefringence) — characteristic; - ''Salt-and-pepper'' chromatin (neuroendocrine); - Nuclear features distinct from papillary (no clearing/grooves); (3) **IHC**: **calcitonin+ (specific)**, **CEA+**, chromogranin+, synaptophysin+, TTF-1+, **thyroglobulin negative** (vs follicular-derived); (4) **Molecular**: - **RET proto-oncogene mutations** — drive ~ 100% MTC; activating gain-of-function; - **Hereditary (~ 25%)** — MEN2 syndromes (autosomal dominant): - **MEN2A**: MTC + pheo + primary hyperparathyroidism (~ 95% MTC); RET codon 634 most common; - **MEN2B (formerly MEN3)**: MTC + pheo + mucosal neuromas + Marfanoid; RET M918T — earliest onset + most aggressive; prophylactic thyroidectomy in infancy/early childhood; - **Familial MTC** — MTC only — variable RET mutations; - **Sporadic (~ 75%)**: somatic RET mutations (M918T most common — aggressive); RAS mutations subset; (5) **Biomarkers**: serum calcitonin (elevated, prognostic — doubling time predicts progression), CEA (also marker); calcitonin doubling time + CEA doubling time prognostic; (6) **Workup**: - **All MTC — germline RET testing** (regardless of family history — many sporadic appearances are actually new germline); - **MEN2 screen**: pheochromocytoma (plasma metanephrines), hyperparathyroidism (Ca, PTH); pheo BEFORE thyroidectomy (alpha-blockade first); - **Imaging**: neck US, CT/MRI neck-chest-liver-bones (mets), 68Ga-DOTATATE PET; - **Family screening** for RET if positive; (7) **Treatment**: - **Surgery**: total thyroidectomy + central neck dissection (level VI) — mainstay; lateral neck per extent; - **Calcitonin + CEA follow-up**; - **RAI not effective** (C-cells don''t take up iodine); - **TSH suppression not needed** (different from differentiated thyroid cancer); - **External beam RT** for selected unresectable, palliative; - **Locally advanced/metastatic**: **selpercatinib** (LIBRETTO-001) + **pralsetinib** — RET-selective inhibitors — durable + tolerable, FIRST-LINE; - Multi-kinase inhibitors (cabozantinib, vandetanib) — historical, more toxicity; - **Immunotherapy** limited role; (8) **Prophylactic surgery** for MEN2 carriers per RET mutation risk + screening; (9) **Multidisciplinary**: endocrinology + surgery + medical oncology + genetics + pediatrics (for MEN2 families)

---

MTC: C-cell neuroendocrine; calcitonin+/CEA+/chromog+/TTF-1+; amyloid stroma; RET-driven (germline MEN2 ~25%; sporadic somatic ~75%). Universal germline RET testing. MEN2 screen pheo + HPT before thyroidectomy. Total thyroidectomy + central LN. Selpercatinib/pralsetinib (RET-selective) first-line for advanced.', NULL,
  'hard', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'mixed',
  'ATA MTC 2015; LIBRETTO-001; NCCN', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี — multinodular goiter + biopsy: medullary thyroid carcinoma — C-cells; IHC: calcitonin+, CEA+, chromogranin+, TTF-1+, thyroglobulin negative; molecular: RET mutation; การวินิจฉัยและการรักษา'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 45 ปี — small bowel mass — biopsy + IHC: neuroendocrine tumor (well-differentiated NET); chromogranin+, synaptophysin+, Ki-67 5%, CDX2+; staining for serotonin + 5-HIAA elevated in urine; การ stage + grade + Tx', '[{"label":"A","text":"Adenocarcinoma"},{"label":"B","text":"Neuroendocrine Tumor (NET) — Pathology + Management"},{"label":"C","text":"Lymphoma"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neuroendocrine Tumor (NET) — Pathology + Management: (1) **WHO classification (2019 updated 2022)** — **divides by differentiation + grade**: - **Well-differentiated NET** (G1, G2, G3 — added in 2017): organoid architecture, uniform cells; - **G1**: mitoses < 2/2 mm² AND Ki-67 < 3%; - **G2**: mitoses 2-20 AND/OR Ki-67 3-20%; - **G3**: mitoses > 20 AND/OR Ki-67 > 20% — but well-differentiated morphology; - **Poorly-differentiated Neuroendocrine Carcinoma (NEC)**: small cell or large cell — aggressive, behaves like SCLC; - **MiNEN** (mixed neuroendocrine-non-neuroendocrine neoplasm) — ≥ 30% each; (2) **Sites**: - **GI/pancreatic** — common sites: pancreas, small bowel (jejunoileal — well-diff, serotonin-secreting → carcinoid syndrome), stomach, duodenum, appendix, rectum; - **Lung** carcinoid (typical, atypical), pulmonary NEC (small cell, large cell); - **Other**: thymus, paraganglia, skin (Merkel cell), pituitary, parathyroid, thyroid (medullary — distinct entity); (3) **IHC**: **chromogranin A+, synaptophysin+, INSM1+** (newer broad marker), CD56+; site-specific markers (CDX2 — GI, TTF-1 — lung/thyroid, PAX8 — pancreas/Müllerian, ISL-1 — pancreatic), Ki-67 essential for grading; (4) **Functional vs non-functional**: - **Functional NETs**: produce hormones causing syndromes — insulinoma (insulin → hypoglycemia), gastrinoma (Zollinger-Ellison), glucagonoma, somatostatinoma, VIPoma, carcinoid (serotonin); - **Non-functional**: hormones not secreted clinically detectable; (5) **Workup**: - **Biopsy + IHC + Ki-67**; - **Biomarkers**: chromogranin A serum (limited sensitivity), 5-HIAA 24-h urine (carcinoid syndrome), specific hormones if functional; - **Imaging**: cross-sectional (CT/MRI); **68Ga-DOTATATE PET** — somatostatin receptor imaging — excellent sensitivity + treatment selection; - **Hereditary syndromes**: MEN1 (parathyroid + pancreas/duodenum NET + pituitary), MEN2 (medullary thyroid), VHL (pancreas NET + RCC + pheo), NF1, tuberous sclerosis; germline testing selected; (6) **Treatment** (by site + grade + stage + functional status): - **Localized**: surgery (curative for well-differentiated low-grade); - **Functional symptom control**: - **Somatostatin analogs (octreotide, lanreotide)** — control symptoms + slow growth (CLARINET, PROMID); - **Telotristat** for carcinoid diarrhea (peripheral TPH inhibitor); - **PPI** for ZES (gastrinoma); - **Locally advanced/metastatic well-differentiated**: - Surgery — debulking, primary resection, liver mets resection; - **Liver-directed**: TACE, radioembolization (Y-90), RFA, ablation; - **Everolimus (mTOR), sunitinib** (pancreatic NET); - **PRRT — 177Lu-DOTATATE (Lutathera)** — somatostatin receptor radiotherapy — NETTER-1 trial — landmark for midgut NETs; NETTER-2 frontline for G2/G3 small intestine + pancreas; - **High-grade NEC**: platinum + etoposide (like SCLC); chemo-IO combinations; - **MiNEN**: complex — treat dominant component; (7) **Multidisciplinary**: medical onc + surgery + IR + nuclear medicine + path + endocrinology

---

NET: WHO well-diff (G1/G2/G3 by Ki-67 + mitoses) vs NEC (small/large cell) vs MiNEN. Chromog/synapto/INSM1+; CDX2 site-specific. Functional (carcinoid, insulinoma, ZES) vs non. DOTATATE PET. Tx: surgery + somatostatin analogs + everolimus/sunitinib + Lutathera (PRRT NETTER-1/2) for advanced; platinum-etoposide for NEC.', NULL,
  'hard', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'WHO Digestive Tumors 5th ed; NETTER-1/2; ENETS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 45 ปี — small bowel mass — biopsy + IHC: neuroendocrine tumor (well-differentiated NET); chromogranin+, synaptophysin+, Ki-67 5%, CDX2+; staining for serotonin + 5-HIAA elevated in urine; การ stage + grade + Tx'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิงอายุ 50 ปี — pituitary mass + amenorrhea + galactorrhea; prolactin 250 (high); MRI: pituitary macroadenoma; resection: monomorphic chromophobe cells + amyloid; IHC: prolactin+ (specific), other pituitary hormones negative; การวินิจฉัยและการรักษา', '[{"label":"A","text":"Random"},{"label":"B","text":"Pituitary Tumors — Pathology + Classification (WHO 2022)"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pituitary Tumors — Pathology + Classification (WHO 2022): (1) **Major categories**: - **Pituitary neuroendocrine tumors (PitNETs)** — formerly pituitary adenomas — terminology change reflecting neuroendocrine biology; - **Pituitary carcinomas** — rare, defined by metastasis (CNS or systemic); - **Craniopharyngioma** (epithelial, suprasellar — adamantinomatous BRAF V600E in pediatric vs papillary BRAF V600E adult) — distinct entity; - **Posterior pituitary tumors** — pituicytoma, granular cell tumor — rare; - **Cysts**, others; (2) **PitNET classification (WHO 2022)** — based on transcription factor lineage + hormone expression: - **PIT1 lineage** (somatotroph, lactotroph, thyrotroph): GH-secreting (acromegaly), prolactin-secreting (prolactinoma — this case), TSH-secreting (hyperthyroidism); - **TPIT lineage** (corticotroph): ACTH-secreting (Cushing disease), silent corticotroph; - **SF1 lineage** (gonadotroph): FSH/LH-secreting (often clinically silent, large at presentation); - **Plurihormonal** or **null cell** — without specific lineage; (3) **Aggressive behavior markers**: - High Ki-67 (≥ 3% concerning, ≥ 10% high-risk); - p53 expression; - High mitotic count; - Sparsely granulated GH (more aggressive); - Crooke cell ACTH (atypical Cushing); - Silent corticotroph (aggressive); (4) **Prolactinoma** (this case — most common PitNET): - Adenoma producing prolactin; - **Clinical**: women — amenorrhea + galactorrhea + infertility; men — hypogonadism, headache, mass effects; macroadenomas (> 1 cm) more in men due to later presentation; - **Diagnosis**: prolactin elevated (> 200 ng/mL highly suggestive of prolactinoma); rule out other causes of hyperprolactinemia (pregnancy/lactation, drugs — D2 antagonists, antipsychotics, metoclopramide, opioids, estrogen, hypothyroidism, renal failure, stress, idiopathic, stalk effect from non-prolactinoma sellar mass); - **Hook effect**: very high prolactin can falsely appear normal — request dilution if discrepant; - **MRI sella with + without contrast** — gold standard; (5) **Workup for any sellar mass**: - Full pituitary axis (TSH, free T4, ACTH, cortisol AM, IGF-1, GH, LH, FSH, testosterone/estradiol); - Visual fields + ophthalmology (chiasm compression); - MRI characteristics; (6) **Treatment**: - **Prolactinoma**: - **DOPAMINE AGONISTS (cabergoline > bromocriptine)** — first-line for ALL prolactinoma sizes — shrink + lower PRL — surgery rarely needed unless cabergoline-resistant, intolerant, large with vision loss; - **Cabergoline > bromocriptine** efficacy + tolerability; - Reduce/withdraw after long remission considered; - **Other adenomas (Cushing, acromegaly, gonadotropinoma, TSHoma)**: - Transsphenoidal surgery primary; - Adjuvant medical (somatostatin analogs for acromegaly, cabergoline; metyrapone/ketoconazole/osilodrostat for Cushing; pasireotide for both); - RT for refractory; - **Aggressive/carcinoma**: temozolomide (alkylating — TIDE); evolving targeted; (7) **Multidisciplinary**: endocrinology + neurosurgery + pathology + radiation onc + ophthalmology + genetics (MEN1, AIP)

---

PitNET (WHO 2022 — terminology replaces pituitary adenoma): classified by transcription factor lineage (PIT1, TPIT, SF1) + hormone. Aggressive markers: Ki-67/p53/silent corticotroph/sparsely granulated GH. Prolactinoma — cabergoline first-line (all sizes). Other adenomas — TSS primary. Multidisciplinary.', NULL,
  'medium', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'WHO Endocrine Tumors 5th ed; Endocrine Society', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยหญิงอายุ 50 ปี — pituitary mass + amenorrhea + galactorrhea; prolactin 250 (high); MRI: pituitary macroadenoma; resection: monomorphic chromophobe cells + amyloid; IHC: prolactin+ (specific), other pituitary hormones negative; การวินิจฉัยและการรักษา'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี — vertebral collapse + bone pain + protein electrophoresis: monoclonal IgA lambda 3 g/dL + bone marrow with 70% plasma cells + bone lesions; การวินิจฉัย — vs primary amyloidosis + MGUS + solitary plasmacytoma + multiple myeloma', '[{"label":"A","text":"Random"},{"label":"B","text":"Plasma Cell Neoplasms — Spectrum + Pathology"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Plasma Cell Neoplasms — Spectrum + Pathology: (1) **MGUS (Monoclonal Gammopathy of Undetermined Significance)** — precursor: - M-protein < 3 g/dL; - BM plasma cells < 10%; - No CRAB/SLiM features; - ~ 1%/yr progression to MM; - Subtypes: IgG, IgA, IgM (IgM MGUS → Waldenstrom progression), light chain (LC-MGUS); (2) **Smoldering Multiple Myeloma (SMM)** — intermediate: - M-protein ≥ 3 OR BM plasma cells 10-60%; - No CRAB/SLiM/biomarkers; - High-risk SMM: ≥ 2 of (M-protein ≥ 2, BM PC > 20%, FLC ratio > 20) — risk progression ~ 50% in 2 yr; - Treatment for high-risk SMM with lenalidomide ± dara now considered (E3A06, ITAREZ); (3) **Multiple Myeloma (MM)** — see prior question; (4) **Solitary plasmacytoma**: - **Solitary bone plasmacytoma (SBP)**: single bone lesion, no systemic MM features, RT curative ~ 50% (rest progress to MM); - **Extramedullary plasmacytoma**: head/neck most common, soft tissue, GI; RT + surgery; (5) **Primary AL Amyloidosis**: - Light-chain (AL) deposition in tissues — cardiac, renal, neurologic, hepatic, soft tissue; - Diagnosed by tissue biopsy + Congo red (apple-green birefringence) + LC mass spectrometry (preferred over IHC for typing); - Free light chain (FLC) ratio + SPEP + immunofixation; - Cardiac biomarkers (NT-proBNP, troponin) — Mayo staging prognostic; - Treatment: **daratumumab + CyBorD** (ANDROMEDA trial) — frontline standard; auto-HCT for eligible; new agents (CAEL-101 anti-amyloid Ab, others); (6) **AL amyloidosis vs MM with amyloid**: - AL amyloidosis = clonal plasma cell disorder with end-organ amyloid; often low % BM PCs; - MM with amyloid = MM that has amyloid deposition — combined; - Distinguish from ATTR (transthyretin — wild-type or mutant — different treatment), AA (secondary — chronic inflammation), other rare; mass spec essential for typing; (7) **POEMS syndrome**: - Polyneuropathy + Organomegaly + Endocrinopathy + Monoclonal protein + Skin changes; - Osteosclerotic myeloma variant; - **VEGF elevated**; - Treatment: radiation for localized, melphalan + auto-HCT, lenalidomide; (8) **Waldenstrom Macroglobulinemia (WM)**: distinct entity — lymphoplasmacytic lymphoma + IgM monoclonal protein + MYD88 L265P mutation; treatment — BTK inhibitors (ibrutinib, zanubrutinib), bendamustine + rituximab; (9) **Pathology + workup considerations**: - SPEP + immunofixation + serum free light chains; - 24-h urine protein + immunofixation; - BM biopsy + cytogenetics + FISH (high-risk: t(4;14), t(14;16), t(14;20), del(17p), gain 1q21); - Imaging: skeletal survey (whole-body low-dose CT or MRI/PET — replaces plain X-ray); - Cardiac evaluation for AL; (10) **Multidisciplinary** + genetic considerations (rare familial); modern era — many patients living years with these conditions

---

Plasma cell neoplasm spectrum: MGUS (precursor) → SMM (high-risk Tx considered) → MM. Solitary plasmacytoma (bone/extramedullary) — RT curative subset. AL amyloidosis — clonal LC + tissue deposition; daratumumab + CyBorD frontline (ANDROMEDA). POEMS (VEGF↑). WM (MYD88+). Imaging WBLD-CT/MRI/PET; mass spec for amyloid typing.', NULL,
  'hard', 'hematopathology', 'review',
  'pathology', 'clinical_decision', 'hematopathology', 'adult',
  'IMWG 2014/updates; ANDROMEDA; Mayo AL', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี — vertebral collapse + bone pain + protein electrophoresis: monoclonal IgA lambda 3 g/dL + bone marrow with 70% plasma cells + bone lesions; การวินิจฉัย — vs primary amyloidosis + MGUS + solitary plasmacytoma + multiple myeloma'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident — fundamentals of clonality testing in lymphoma + leukemia — B-cell + T-cell + NK assessment; PCR-based + flow + NGS approaches', '[{"label":"A","text":"Random"},{"label":"B","text":"Clonality Testing in Hematopathology"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Clonality Testing in Hematopathology: (1) **Concept**: lymphoid neoplasms typically arise from single transformed lymphocyte → clonal proliferation → monoclonal antigen receptor (Ig for B-cells, TCR for T-cells); reactive lymphoproliferations are polyclonal; (2) **B-cell clonality**: - **Light chain restriction by flow cytometry** — gold standard for surface Ig+ B-cells; kappa or lambda only (vs polyclonal mixed kappa + lambda ~ 60:40); - **Light chain ISH/IHC** on tissue — kappa/lambda mRNA or protein; - **Ig gene rearrangement PCR (BIOMED-2 / EuroClonality)**: - **IGH** (immunoglobulin heavy chain) — primary target; FR1, FR2, FR3 primer sets; - **IGK** + **IGL** (light chains) — secondary if IGH equivocal; - **GeneScan + heteroduplex analysis** — discrete peak vs polyclonal smear; - Sensitivity ~ 75-95% B-cell lymphomas with combined targets; - **NGS-based Ig rearrangement** (clonoSEQ, similar) — high sensitivity for MRD monitoring (CLL, ALL, MM); FDA-cleared assay; (3) **T-cell clonality**: - **No light chain restriction** (unlike B-cells) — flow can show abnormal phenotype (loss of CD7, abnormal CD4:CD8) but doesn''t directly show clonality; - **TCR gene rearrangement PCR** — TCR-gamma (TCRG) easiest target (~ 90% T-cell neoplasms); TCR-beta (TCRB) complementary; - **NGS-based TCR rearrangement** — high sensitivity, hi-resolution; - **EuroClonality / BIOMED-2 protocols** standardized; (4) **NK-cell**: - No clonal receptor rearrangement; difficult to prove clonality; - **EBV+ ISH** suggests EBV-driven NK/T disease; - **HLA class I haplotype expression patterns**; - **KIR** patterns by flow; - Clinical + morphologic + IHC essential; (5) **Interpretation cautions** (pitfalls): - **Pseudoclonality**: limited samples, low cellularity, or low-quality DNA can produce small numbers of clones mimicking monoclonal pattern — confirm with multiple targets + repeat; - **Oligoclonality** in immunodeficiency, viral infections, autoimmune; - **Restricted oligoclonality** post-stem cell transplant, immune reconstitution; - **B-cell receptor revision** in MALT lymphoma; - **Plasma cell neoplasms** — often surface Ig low — light chain restriction may be hard by flow → CD138-gated cytoplasmic light chain ISH/IHC; - **Hodgkin lymphoma** — RS cells rare in background — clonality only by microdissection or specialized methods (not routine); (6) **Newer applications**: - **MRD in B-ALL, CLL, MM** — NGS Ig rearrangement clonoSEQ approved; - **MRD T-ALL** — TCR-based NGS; - **Lymphoma serial monitoring**; (7) **Quality**: tumor cellularity, DNA quality, reference materials, controls (positive monoclonal, negative polyclonal), NMR (ISH/sentinels); (8) **Integration with other findings**: morphology + IHC + flow + cytogenetics + molecular — clonality supports but doesn''t define malignancy; clinical correlation essential; (9) **EuroClonality + LymphoTrack** — standardized assays + interpretation guidelines

---

Clonality: B-cell — kappa/lambda restriction (flow + ISH) + Ig gene rearrangement PCR (BIOMED-2 IGH/IGK/IGL) + NGS (clonoSEQ MRD); T-cell — TCR-gamma + beta PCR + NGS (no light chain restriction); NK — difficult. Cautions: pseudoclonality, oligoclonality, plasma cell challenges. EuroClonality standards. Integration with morphology + IHC essential.', NULL,
  'hard', 'molecular_pathology', 'review',
  'pathology', 'basic_science', 'molecular_pathology', 'mixed',
  'BIOMED-2/EuroClonality; AMP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Resident — fundamentals of clonality testing in lymphoma + leukemia — B-cell + T-cell + NK assessment; PCR-based + flow + NGS approaches'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident — fundamentals of serum protein electrophoresis (SPEP), immunofixation electrophoresis (IFE), serum free light chains (sFLC), and HFE — combined applied to monoclonal gammopathy + hemochromatosis screening', '[{"label":"A","text":"Skip"},{"label":"B","text":"SPEP + IFE + sFLC + Hemochromatosis Screening"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** SPEP + IFE + sFLC + Hemochromatosis Screening: (1) **Serum Protein Electrophoresis (SPEP)**: - Separates proteins by charge + size on gel/capillary; - **Fractions**: albumin → α1 (alpha-1 antitrypsin) → α2 (haptoglobin, ceruloplasmin, alpha-2 macroglobulin) → β1 (transferrin) → β2 (C3, β2-microglobulin) → γ (immunoglobulins); - **Abnormalities**: - **M-spike (monoclonal)** — discrete peak in γ region (or β if IgA) — quantified for MGUS, MM, WM; - **Polyclonal gammopathy** — broad γ increase — chronic infection, autoimmune (lupus, RA), cirrhosis, HIV; - **Hypogammaglobulinemia** — CVID, post-rituximab, MM (paradoxical immunoparesis); - **α2 increase** — inflammation (haptoglobin), nephrotic syndrome (α2 macroglobulin retained); - **β1 increase** — iron deficiency (transferrin elevated); - **Nephrotic** pattern — albumin low, α2 high; - **Cirrhosis** — albumin low, polyclonal γ with β-γ bridging; (2) **Immunofixation electrophoresis (IFE)** or **immunosubtraction**: - Confirms + types monoclonal proteins — IgG/A/M/D/E heavy chain + kappa/lambda light chain identification; - **More sensitive than SPEP** alone for small M-proteins; - Required to confirm diagnosis when SPEP suggests; (3) **Serum Free Light Chains (sFLC) — kappa + lambda**: - Measures unbound (free) light chains by nephelometry; - **κ/λ ratio (normal ~ 0.26-1.65)** — abnormal ratio suggests clonal disease; - **Highly sensitive** for **non-secretory + light-chain-only MM, AL amyloidosis, light chain MGUS**; - Used for **iSTOP-MM screening, MGUS surveillance, MM response monitoring, AL amyloidosis**; - **MGUS risk stratification**: M-protein size + isotype (non-IgG worse) + sFLC ratio (abnormal worse); - Renal failure affects (both Ka + La rise, ratio less impacted); (4) **24-h urine protein electrophoresis (UPEP) + urine IFE**: - For **Bence-Jones protein** (light chains in urine); - Now sFLC largely replaces but still used; (5) **Hemochromatosis Screening**: - **Hereditary hemochromatosis (HH)** — iron overload disease; - **Genetics**: - **HFE C282Y homozygous** — most common European; - **C282Y/H63D compound heterozygous** — variable penetrance; - **Non-HFE hemochromatosis** — TFR2, HFE2 (juvenile), SLC40A1 (ferroportin); - **Workup**: - **Transferrin saturation (TSAT) > 45%** + **ferritin elevated** — initial screen — TSAT > 50% (men) or > 45% (women) is suggestive; - **HFE genotyping** for confirmation when TSAT/ferritin elevated; - **Hepatic iron concentration** + biopsy (Perls Prussian blue) — for index of severity, complications; - **Liver MRI T2*** alternative; - **Family screening** for HFE carriers; (6) **Treatment HH**: phlebotomy until ferritin < 50-100; maintenance; iron chelation for selected; avoid iron supplements + alcohol; (7) **Other causes of iron overload**: thalassemia + transfusion (treated with chelation), excess intake (rare), porphyria cutanea tarda; (8) **Multidisciplinary**: hematology + gastroenterology + cardiology + endocrinology

---

SPEP: albumin → α1/2 → β → γ. M-spike = monoclonal. IFE confirms + types heavy/light chains. sFLC κ/λ ratio sensitive for non-secretory MM + AL amyloid + LC MGUS. Urine IFE for Bence-Jones (largely replaced). Hemochromatosis: TSAT > 45% + ferritin → HFE C282Y/H63D genotype. Phlebotomy treatment + family screening.', NULL,
  'medium', 'clinical_chemistry', 'review',
  'pathology', 'basic_science', 'clinical_chemistry', 'mixed',
  'IMWG; AASLD HH', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Resident — fundamentals of serum protein electrophoresis (SPEP), immunofixation electrophoresis (IFE), serum free light chains (sFLC), and HFE — combined applied to monoclonal gammopathy + hemochromatosis screening'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Lab manager — implementing pre-analytic phase improvements (specimen collection + transport + accessioning) — common errors + mitigation + accreditation findings + RCA', '[{"label":"A","text":"Skip"},{"label":"B","text":"Pre-Analytic Quality Improvements"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pre-Analytic Quality Improvements: (1) **Pre-analytic phase importance**: - **60-70% of laboratory errors** occur here (Plebani); - Difficult to detect downstream; - Direct patient safety impact (mislabel + transfusion catastrophe); (2) **Common pre-analytic errors**: - **Mislabeling** — wrong patient sample (catastrophic): - Active patient identification with 2 identifiers (name + DOB or MRN); - Patient ID band + scan; - **Label at bedside** (NOT later in workflow); - Pre-printed labels via barcode-scanned wristband (best practice); - Patient state name back (active verification); - **Wrong tube type** (e.g., EDTA for coag instead of citrate; - lithium heparin for ammonia); - **Hemolysis** (vigorous draw, traumatic, line draw without discard, sitting too long, hemolyzed transport); - **Insufficient volume** (clot tube vs additive mixing); - **Clot in EDTA tube** (failure to mix); - **Cold ischemia/delayed fixation** (impacts biomarkers, IHC, RNA); - **Specimen mixup** during processing; - **Wrong test ordered** (CPOE confusion, similar names); - **Verbal orders** misheard; - **Wrong patient label** transcription; - **Temperature excursions** during transport; - **Contamination** (skin flora in blood culture, false-positive sterile site cultures); (3) **Patient identification standards (TJC NPSGs)**: - **Two patient identifiers** verified at every point (collection, labeling, accessioning, result); - Patient name + DOB/MRN — not bed/room number; - **Active verification** (ask patient or family); - **Pediatric** + sedated + altered consciousness — extra caution + use band; (4) **Specimen collection**: - **Education + competency** of phlebotomists; - **Tourniquet** time minimized; - **Correct tubes** (color-coded by institution + standardized); - **Order of draw** to avoid additive carryover (blood culture → coagulation → serum tubes → heparin → EDTA → fluoride/oxalate per CLSI); - **Mixing** by gentle inversions; - **Special considerations**: cold ischemia for breast biomarkers, special transport for cryoglobulins (37°C), light protection (bilirubin), special tubes (Streck for ctDNA); (5) **Transport**: - Time + temperature monitoring; - Pneumatic tube acceptable for most (validation for special tests — sensitive analytes like potassium, ammonia, may need manual); - **Specimen tracking** systems — RFID, barcoded chain of custody; (6) **Accessioning**: - **Barcode scanning** vs manual entry; - **Specimen rejection criteria** standardized + tracked; - **Linked LIS-EHR**; (7) **Mitigation strategies**: - **Forcing functions**: barcoded scanning preventing mismatch; positive ID systems with integrated mobile cart/POC device blocking incompatible procedures; - **Standardized SOPs** + training + competency assessment; - **Continuous monitoring + feedback** to collectors + units; - **Root cause analysis** for events; - **Multidisciplinary collaboration** (nursing, lab, IT, risk); - **Patient + family engagement** in identification; (8) **Metrics for monitoring**: mislabel rate, hemolysis rate, rejection rate, TAT delays, complaints, sentinel events; (9) **Accreditation focus areas**: CAP All Common checklist, ISO 15189, TJC NPSGs, CMS; pre-analytics increasingly emphasized in surveys; (10) **Continuous improvement**: lean methodology, A3 problem-solving, kaizen events focused on phlebotomy/pre-analytic workflow

---

Pre-analytics 60-70% lab errors. Errors: mislabel (most catastrophic), wrong tube/volume, hemolysis, cold ischemia, contamination. Mitigation: 2-ID verification, barcoded wristband, bedside labeling, CLSI order of draw, transport monitoring, electronic systems. Metrics + RCA. CAP/ISO/TJC focus.', NULL,
  'medium', 'quality_safety', 'review',
  'pathology', 'ems_mgmt', 'quality_safety', 'mixed',
  'Plebani Clin Chem Acta; CAP All Common; TJC NPSGs', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Lab manager — implementing pre-analytic phase improvements (specimen collection + transport + accessioning) — common errors + mitigation + accreditation findings + RCA'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Integrative pathology — transgender + gender-diverse health — laboratory considerations + reference ranges + cancer screening + pathology + multidisciplinary affirming care', '[{"label":"A","text":"Random"},{"label":"B","text":"Transgender + Gender-Diverse Health Lab + Pathology"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Transgender + Gender-Diverse Health Lab + Pathology: (1) **Background**: increasing recognition of transgender + gender-diverse (TGD) populations; affirming care improves outcomes; lab/pathology must adapt; (2) **Gender-affirming hormone therapy (GAHT)**: - **Feminizing**: estradiol + anti-androgen (spironolactone, GnRH agonist, finasteride) — for trans women + non-binary; - **Masculinizing**: testosterone — for trans men + non-binary; - **Effects on lab values + tissues**; (3) **Reference intervals** — challenge: - Many reference ranges sex-stratified based on cisgender data; - **Post-GAHT lab values often align with affirmed gender** for hormone-influenced parameters (Hgb, ferritin, creatinine), but variable; - **Specific guidance** from UCSF Trans Care + Endocrine Society for management; - **Inclusive lab reporting** (some institutions add both ranges or annotation); (4) **Lab considerations**: - **Identify patients** appropriately + sensitively — preferred name + pronouns + sex on insurance vs gender identity; - **Test selection** based on **anatomy + hormones + history**, NOT solely on legal sex/gender marker (e.g., trans man with cervix needs cervical cancer screening; trans woman with prostate needs PSA monitoring if indicated); - **Communicate sensitively** with patients about needed tests; (5) **Cancer screening adaptations**: - **Cervical**: trans men with cervix continue cervical cancer screening per guidelines; - **Breast**: trans women on GAHT ≥ 5 yr — consider breast cancer screening; trans men post-mastectomy — chest wall surveillance; - **Prostate**: trans women — screening per organ retained + hormone exposure; - **Endometrial**: trans men on testosterone — withdrawal bleeding monitoring; - **Routine cancer surveillance applies to relevant retained organs**; (6) **Pathology considerations**: - **Hormone-treated tissues** — testosterone in trans men → endometrial atrophy + ovarian changes; estrogen in trans women → gynecomastia + atrophic prostate; - **Gender-affirming surgical specimens** — vaginectomy, hysterectomy/oophorectomy, mastectomy/top surgery, orchiectomy + vaginoplasty, phalloplasty — pathology assesses for incidental findings; - **Reporting** — use patient''s preferred name + appropriate language; - **Education for pathologists** on TGD anatomy + surgical procedures; (7) **Endocrine + biochemistry**: - Lipid changes (T → ↑LDL slightly; estradiol → ↓LDL but ↑TG); - Hematologic (T → ↑Hgb; estradiol → ↓Hgb); - Bone density (declines without sex hormones — ensure adequate replacement); - Cardiovascular monitoring; (8) **Mental health**: high rates of depression + anxiety + suicidality without affirming care + societal acceptance; mental health support integral; (9) **Multidisciplinary affirming care**: - PCP + endocrinology + mental health + surgery (gender-affirming) + pathology + nursing + social work + voice therapy + pharmacy + administrative (ID name changes); - Trans-competent providers; (10) **Equity**: - Disparities in healthcare access; - Trans-specific barriers (insurance, providers, stigma); - Cultural sensitivity + inclusion; - WPATH (World Professional Association for Transgender Health) Standards of Care 8 — comprehensive framework; (11) **Research + data**: improve representation + data on trans health

---

Trans health lab/path: GAHT (feminizing/masculinizing); reference intervals challenge — anatomy + hormones-based test selection. Cancer screening per retained organs (cervix in trans men, prostate in trans women). Gender-affirming surgical pathology. Affirming language + multidisciplinary team. WPATH SOC8. Equity + mental health integral.', NULL,
  'medium', 'quality_safety', 'review',
  'pathology', 'integrative', 'quality_safety', 'adult',
  'WPATH SOC8; UCSF Trans Care; Endocrine Society', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Integrative pathology — transgender + gender-diverse health — laboratory considerations + reference ranges + cancer screening + pathology + multidisciplinary affirming care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี — vasculitis workup; biopsy small/medium vessel: necrotizing inflammation; IHC: ANCA-positive (PR3 — cANCA pattern); การจำแนกและการรักษา', '[{"label":"A","text":"TB"},{"label":"B","text":"ANCA-Associated Vasculitis (AAV) — Pathology + Management"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** ANCA-Associated Vasculitis (AAV) — Pathology + Management: (1) **Categories (CHCC 2012 classification)**: - **Granulomatosis with polyangiitis (GPA — formerly Wegener)** — necrotizing granulomatous + small/medium vessel vasculitis; **PR3-ANCA / cANCA** (~ 80%); ENT + lung + kidney involvement classic; - **Microscopic polyangiitis (MPA)** — necrotizing small vessel vasculitis without granulomas; **MPO-ANCA / pANCA** (~ 70%); pulmonary capillaritis + glomerulonephritis common; - **Eosinophilic granulomatosis with polyangiitis (EGPA — formerly Churg-Strauss)** — asthma + eosinophilia + granulomas + vasculitis; ANCA in ~ 40% (MPO-ANCA when present); - **Renal-limited vasculitis** (kidney only, ANCA+); (2) **Pathology — kidney biopsy** (commonest organ biopsied): - **Pauci-immune necrotizing crescentic GN** — segmental fibrinoid necrosis + crescents; - **IF**: paucity of immune complex deposits (vs lupus, IgA, MN with prominent deposits); - **EM**: no immune deposits; - Tubulointerstitial inflammation + fibrinoid arteriolitis often; (3) **Lung biopsy** in GPA: necrotizing granulomas + vasculitis + geographic necrosis + multinucleated giant cells; (4) **ENT biopsy** (GPA): necrosis + granulomas + vasculitis (often subtle); (5) **Workup**: - **ANCA testing**: indirect immunofluorescence (IFA) for cANCA/pANCA pattern + ELISA for **PR3** + **MPO** specificity (specific antigen testing); - **Renal**: UA + UPCR + Cr + biopsy when indicated; - **Imaging**: CXR/CT chest, sinus imaging; - **Other organ assessment**: peripheral nerve (EMG), cardiac, GI, CNS; - **Differential**: infection (especially endocarditis with embolic complications + ANCA mimicker), drug-induced (levamisole-cocaine, hydralazine, propylthiouracil), other vasculitides (anti-GBM/Goodpasture overlap — co-test essential, IgA vasculitis, polyarteritis nodosa, Behçet, cryoglobulinemic — secondary to HCV), connective tissue diseases; (6) **Treatment** (KDIGO 2021 + EULAR/ACR 2022 recommendations) — phased: - **Induction (3-6 mo)**: - **Rituximab** (RAVE, RITUXVAS, PEXIVAS) — preferred for most + relapsing + young (fertility-sparing) — equivalent or superior to cyclophosphamide; - **Cyclophosphamide** (PO or IV) — alternative + severe disease; - **High-dose corticosteroids** initially — PEXIVAS showed reduced-dose steroid regimen non-inferior + less infectious complications; - **Plasma exchange** — controversial — PEXIVAS no benefit overall but considered selectively for severe (pulmonary hemorrhage + dialysis-requiring + anti-GBM co-positive); - **Avacopan (C5aR inhibitor)** approved — reduces steroid exposure (ADVOCATE trial) — increasingly first-line; - **Maintenance**: rituximab (preferred), azathioprine, methotrexate; durations + tapers refined; - **EGPA specific**: mepolizumab (anti-IL-5) for refractory; reslizumab + benralizumab + dupilumab under study; (7) **Monitoring**: ANCA titer trends (variable utility), clinical, organ function; (8) **Complications**: relapse common, infection (heavy immunosuppression), malignancy, drug toxicity; (9) **Multidisciplinary**: rheumatology + nephrology + pulm + ENT + ID + dermatology + neurology + ophth + pharmacy

---

AAV: GPA (PR3-ANCA, granulomas) + MPA (MPO-ANCA, no granulomas) + EGPA (eosinophils + asthma). Pauci-immune crescentic GN (renal IF: no deposits). PR3/MPO ANCA + IF patterns. Induction: rituximab + reduced-dose steroids (PEXIVAS); avacopan (ADVOCATE) reduces steroid. Maintenance rituximab. Mepolizumab for refractory EGPA.', NULL,
  'hard', 'renal_pathology', 'review',
  'pathology', 'clinical_decision', 'renal_pathology', 'adult',
  'CHCC 2012; KDIGO 2021; EULAR/ACR 2022; PEXIVAS; ADVOCATE', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี — vasculitis workup; biopsy small/medium vessel: necrotizing inflammation; IHC: ANCA-positive (PR3 — cANCA pattern); การจำแนกและการรักษา'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident — fundamentals of peripheral blood smear review + key morphological findings + when to escalate + integration with CBC results', '[{"label":"A","text":"Skip"},{"label":"B","text":"Peripheral Blood Smear Review"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Peripheral Blood Smear Review: (1) **Indications**: abnormal CBC, suspected hematologic disorder, infection, malignancy, anemia workup, pediatric routine, hereditary suspicion; (2) **Approach**: - **Low-power scan**: cellular density appropriate area (not too thin/thick), distribution, identify clumps + platelet clumps; - **High-power**: systematic morphology evaluation; - **WBC differential**: 100-200 cell count, classify, identify abnormal; - **Platelets**: count estimate (1 platelet per RBC field ~ 15-20 × 10⁹/L), morphology (large, dysmorphic, clumping); - **RBCs**: size, shape, color, inclusions; (3) **Key RBC morphology**: - **Microcytic**: IDA, thalassemia, ACD, sideroblastic, lead; - **Macrocytic**: B12/folate (oval macros + hyperseg neutros — megaloblastic), liver disease, alcohol, MDS, drugs, reticulocytosis; - **Anisocytosis**: RDW; - **Hypochromic**: IDA, thal; - **Polychromasia**: reticulocytes (hemolysis, blood loss response); - **Target cells**: thalassemia, HbC, liver disease, post-splenectomy; - **Spherocytes**: hereditary spherocytosis, AIHA (warm), burns, ABO transfusion incompatibility; - **Schistocytes**: MAHA (TTP, HUS, DIC, malignant HTN, mechanical valve, scleroderma renal crisis); - **Sickle cells**: SCD, SC, S-thal; - **Teardrops (dacrocytes)**: myelofibrosis, thalassemia, infiltrated marrow, megaloblastic; - **Pencil/cigar cells**: severe IDA; - **Acanthocytes** (spur cells): liver disease, abetalipoproteinemia, McLeod, Huntington; - **Echinocytes** (burr cells): uremia, pyruvate kinase deficiency, drying artifact; - **Howell-Jolly bodies**: post-splenectomy, functional asplenia (SCD), megaloblastic; - **Basophilic stippling**: lead poisoning, thalassemia, megaloblastic; - **Pappenheimer bodies (iron)**: sideroblastic, post-splenectomy; - **Heinz bodies**: G6PD deficiency, unstable Hb (need specific stain); - **Cabot rings**: severe anemia, lead; (4) **WBC morphology**: - **Neutrophil**: bands vs segments; **hypersegmented** (B12/folate); **toxic granulation + Döhle bodies + vacuoles** (sepsis); **Pelger-Huët** (segmentation defect — congenital or acquired in MDS); **left shift** (infection, marrow stress); **blasts** (acute leukemia, MDS); - **Auer rods**: AML pathognomonic (especially APL — bundles); - **Faggot cells**: APL; - **Atypical lymphocytes**: viral (EBV, CMV, hepatitis), drug; - **Plasmacytoid lymphs**: viral, B-cell neoplasm; - **Smudge cells**: CLL (Gumprecht); - **Hairy cells**: HCL; - **Sézary cells**: cerebriform nuclei, CTCL; - **Smear lymphocytes**: artifact common; (5) **Platelet morphology**: - **Large platelets**: ITP, MPN, Bernard-Soulier, MYH9-related disorders, May-Hegglin; - **Giant**: MPN, MDS; - **Hypogranular**: MDS, MPN; - **Clumps**: EDTA-dependent pseudothrombocytopenia (rerun in citrate); - **Mean platelet volume (MPV)** correlates; (6) **Special findings**: - **Parasites**: malaria (ring forms, schizonts, gametocytes — species-specific), babesia (''Maltese cross''), trypanosomes (extracellular flagellates), filaria, Leishmania (in macrophages); - **Bacteria**: rare (overwhelming sepsis); - **Plasmodium falciparum** severe — banana gametocytes, multiply infected RBCs, > 5% parasitemia critical; (7) **Reporting + escalation**: communicate critical findings (blasts, parasites, marked dysmorphology) — pathologist review + reflexive testing; flag for hematopathologist consultation; (8) **Quality**: peripheral smear is a window onto systemic disease — fundamental skill

---

PB smear: systematic — WBC diff + RBC (size/shape/color/inclusions) + plt. Key morphology: targets/sickle/schistos/spheros/teardrops/acanthos/Howell-Jolly/basoph stipping/Heinz; Auer rods (AML/APL); hyperseg (B12/folate); smudge (CLL); hairy; Sezary; atypical lymphs (viral). Parasites (malaria, babesia). EDTA platelet clump artifact. Critical → escalate.', NULL,
  'medium', 'hematopathology', 'review',
  'pathology', 'basic_science', 'hematopathology', 'mixed',
  'ASH Pocket Companion; Bain Blood Cells Atlas', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Resident — fundamentals of peripheral blood smear review + key morphological findings + when to escalate + integration with CBC results'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 75 ปี — UV-exposed forehead nodule + biopsy: small round blue cells with neuroendocrine features + paranuclear dot CK20+ + chromogranin+ synaptophysin+; molecular: Merkel cell polyomavirus (MCPyV)+; การวินิจฉัย', '[{"label":"A","text":"BCC"},{"label":"B","text":"Merkel Cell Carcinoma (MCC)"},{"label":"C","text":"Cyst"},{"label":"D","text":"Refuse"},{"label":"E","text":"SCC"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Merkel Cell Carcinoma (MCC): (1) **Epidemiology**: aggressive cutaneous neuroendocrine carcinoma; elderly, UV-exposed sites (head/neck > extremities); immunosuppressed at higher risk (HIV, transplant, CLL); rising incidence; (2) **Pathogenesis (dual etiology)**: - **Merkel cell polyomavirus (MCPyV)-positive** ~ 80% — integrated viral DNA + truncated large T antigen drives transformation; - **UV-driven (MCPyV-negative)** ~ 20% — high mutational burden + UV signature mutations (TP53, RB1); (3) **Histology**: - Sheets + nests of small to medium round blue cells; - High mitoses + apoptosis; - ''Salt-and-pepper'' chromatin (neuroendocrine); - Trabecular, nodular, diffuse architectures; - Vascular + lymphatic invasion common; - Sometimes intraepidermal Pautrier-like; (4) **IHC**: - **CK20+ paranuclear dot pattern** — characteristic; - Chromogranin+, synaptophysin+, INSM1+ (neuroendocrine); - **TTF-1 negative** (vs small cell lung CA); CK7 negative; - CD56+, neurofilament+; - Ki-67 high; - **CM2B4 IHC** for MCPyV large T antigen (positive in MCPyV+ MCC); (5) **Differential**: small cell lung carcinoma metastasis (TTF-1+, CK7 variable, CK20 negative typically), melanoma (S100/SOX10/HMB-45+), lymphoma (CD45/CD20/CD3+), basal cell carcinoma (BerEP4+ but not neuroendocrine); (6) **Staging (AJCC 8th)**: TNM; clinical stage I-IV; SLN biopsy for clinically negative neck; (7) **Treatment**: - **Localized**: wide local excision + SLN biopsy; adjuvant RT often given (high local recurrence rate); - **Locally advanced/metastatic**: - **Immunotherapy first-line** — **avelumab (anti-PD-L1 — JAVELIN Merkel 200)**, **pembrolizumab (KEYNOTE-017)**, **retifanlimab** (anti-PD-1) — robust response rates (~ 50%); landmark approvals; - Chemotherapy (platinum + etoposide — like SCLC) — limited responses, used if IO failed/contraindicated; - Locally advanced — combination IO + RT + surgery considered; (8) **Prognosis**: stage-dependent; high recurrence rate; immunotherapy era improved survival; (9) **Multidisciplinary**: dermatology + surgical onc + medical onc + RT + dermatopathology

---

Merkel cell carcinoma: aggressive neuroendocrine; CK20 paranuclear dot + chromog/synapto/INSM1+; TTF-1 negative. MCPyV+ (80%) vs UV-driven (20%). Avelumab (JAVELIN) + pembro (KEYNOTE-017) + retifanlimab — IO first-line metastatic (revolutionary). WLE + SLN + adjuvant RT for localized. Multidisciplinary.', NULL,
  'medium', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'WHO Skin Tumors 5th ed; NCCN MCC; JAVELIN Merkel 200', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 75 ปี — UV-exposed forehead nodule + biopsy: small round blue cells with neuroendocrine features + paranuclear dot CK20+ + chromogranin+ synaptophysin+; molecular: Merkel cell polyomavirus (MCPyV)+; การวินิจฉัย'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 40 ปี — extremity soft tissue mass deep — biopsy: biphasic tumor with epithelioid + spindle cells; IHC: keratin+, EMA+, TLE1+ nuclear+; molecular: SS18 (SYT) gene rearrangement; การวินิจฉัย', '[{"label":"A","text":"MFH"},{"label":"B","text":"TLE1+ nuclear"},{"label":"C","text":"Lipoma"},{"label":"D","text":"Schwannoma"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Synovial Sarcoma: (1) **Epidemiology**: young adults; extremities (especially around knee), trunk; not derived from synovium (misnomer — name from histologic resemblance); (2) **Histology subtypes**: - **Biphasic** — spindle + epithelial (glandular) components — classic; - **Monophasic** — spindle only — most common; - **Poorly differentiated** — small cell or epithelioid — aggressive; (3) **IHC**: - **TLE1+ nuclear** — sensitive (also some other tumors); - **Keratin+, EMA+** in epithelial component (and monophasic); - CD99+, BCL2+; - **SS18-SSX fusion-specific IHC** emerging (highly specific); - SOX10 negative (vs MPNST), S100 variable; - **Calretinin focal+** (vs mesothelioma diffuse); (4) **Molecular (defining)**: - **t(X;18)(p11;q11) SS18-SSX1/SSX2/SSX4** fusion (FISH or RT-PCR or NGS) — ~ 95%; - **SSX1 vs SSX2** — possible prognostic difference (SSX2 may be better); (5) **Differential**: malignant peripheral nerve sheath tumor (S100+, NF1), epithelioid sarcoma (INI1/SMARCB1 loss), spindle cell carcinoma (other keratins), other sarcomas; (6) **Treatment**: - **Wide local excision** with negative margins primary; - **Adjuvant RT** for high-risk + close margins; - **Chemotherapy** controversial but increasingly used: - Doxorubicin + ifosfamide (most active in synovial sarcoma vs other STS); - Neoadjuvant or adjuvant; - **Pazopanib** for metastatic STS (PALETTE); - **Trabectedin, eribulin** later lines; - **Pembrolizumab + chemo** in selected; - **TCR-engineered T-cell therapy** — afami-cel (NY-ESO-1-directed — first FDA-approved engineered TCR therapy for advanced synovial sarcoma 2024); - Clinical trials emerging — TCR-T, IO + chemo, others; (7) **Prognosis**: variable; size, depth, grade, margin, fusion type, age; (8) **Multidisciplinary**: orthopedic onc + surgical onc + RT + medical onc + pathology + radiology

---

Synovial sarcoma: biphasic/monophasic/poorly diff; TLE1+/keratin+/EMA+; SS18-SSX fusion (t(X;18)) diagnostic; SS18-SSX fusion IHC emerging. Wide excision + RT + chemo (doxo + ifos active). Pazopanib/trabectedin metastatic. Afami-cel TCR-T (NY-ESO-1) first FDA TCR-T for synovial 2024.', NULL,
  'medium', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'WHO Soft Tissue + Bone 5th ed; NCCN Soft Tissue Sarcoma', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 40 ปี — extremity soft tissue mass deep — biopsy: biphasic tumor with epithelioid + spindle cells; IHC: keratin+, EMA+, TLE1+ nuclear+; molecular: SS18 (SYT) gene rearrangement; การวินิจฉัย'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี — neurofibromatosis 1 (NF1) — deep extremity mass + rapid growth → biopsy: hypercellular spindle cell tumor with marked atypia + mitoses + necrosis; IHC: S100 focal+, SOX10 focal+, **H3K27me3 LOSS** (~ 70%), p53 abnormal', '[{"label":"A","text":"Schwannoma"},{"label":"B","text":"Malignant Peripheral Nerve Sheath Tumor (MPNST)"},{"label":"C","text":"Lipoma"},{"label":"D","text":"Skip"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Malignant Peripheral Nerve Sheath Tumor (MPNST): (1) **Background**: 50% arise in NF1 patients (germline NF1 mutation); 50% sporadic or post-radiation; aggressive soft tissue sarcoma; (2) **Histology**: - High-grade spindle cell sarcoma — fascicular pattern; - Marked atypia + mitoses + necrosis; - Hypercellular alternating with myxoid + hypocellular; - Geographic necrosis; - Perivascular condensation; - Heterologous elements possible (rhabdomyo → ''malignant Triton tumor''); (3) **IHC**: - **S100 focal/patchy+** (in ~ 50%, less diffuse than schwannoma); - **SOX10 patchy** in subset; - **H3K27me3 LOSS** (loss of trimethylation due to PRC2 dysfunction) — ~ 70% MPNST — highly useful diagnostic + distinguishes from cellular schwannoma + neurofibroma; - Ki-67 high; - p53 often abnormal; - Loss of CD34; (4) **Molecular**: - **PRC2 (Polycomb Repressive Complex 2) inactivation** — SUZ12 or EED loss/mutation → loss of H3K27me3; - **NF1** germline (NF1 patients) + somatic; - **CDKN2A loss**; - **TP53** mutations; - **Complex karyotype** typical; (5) **Differential**: cellular schwannoma (S100 diffuse, H3K27me3 retained, no necrosis, no high mitoses), low-grade nerve sheath tumors, neurofibroma + variants, monophasic synovial sarcoma (TLE1+, SS18 fusion), spindle cell carcinoma, leiomyosarcoma, melanoma (S100+ but malignant melanocytic markers); (6) **NF1 considerations**: - Patients with neurofibromas at risk for MPNST transformation (lifetime ~ 10% NF1); - Rapid growth in pre-existing plexiform neurofibroma + new pain + neuro deficit = warning; - 18F-FDG PET useful — SUV cutoff for biopsy; - Surveillance imaging recommended for high-risk; (7) **Treatment**: - **Wide local excision** with negative margins (often challenging — extensive plexiform involvement, nerve sacrifice); - **Adjuvant RT** for high-risk; - **Chemotherapy**: doxorubicin + ifosfamide — limited but standard; less effective vs other sarcomas; - **Limb-sparing surgery** vs amputation; - **Metastatic disease**: chemo + clinical trials; novel targeted (MEK inhibitors — selumetinib approved for inoperable plexiform NF in pediatric NF1 — prevents transformation studies); - **Future**: PRC2/EZH2 inhibition under study (tazemetostat); (8) **Multidisciplinary**: orthopedic onc + medical onc + RT + pathology + medical genetics (NF1) + neurology + rehab; (9) **NF1 genetic counseling** + family screening + multidisciplinary NF1 clinic

---

MPNST: 50% NF1-associated. High-grade spindle + necrosis. IHC: S100/SOX10 focal/patchy; H3K27me3 LOSS (~70%) distinguishes from schwannoma; PRC2 inactivation (SUZ12/EED). NF1 surveillance for transformation (PET-FDG). Wide excision + RT + doxo/ifos chemo. Selumetinib for inoperable plexiform NF1 (prevention).', NULL,
  'hard', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'WHO Soft Tissue + Bone 5th ed; NF1 Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี — neurofibromatosis 1 (NF1) — deep extremity mass + rapid growth → biopsy: hypercellular spindle cell tumor with marked atypia + mitoses + necrosis; IHC: S100 focal+, SOX10 focal+, **H3K27me3 LOSS** (~ 70%), p53 abnormal'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 35 ปี — anterior mediastinal mass + dyspnea; biopsy: large B-cell lymphoma in fibrotic background + sclerotic compartments + ''clear cells''; IHC: CD20+, CD23+, CD30+ variable, MAL+, PD-L1+, CD15-; การวินิจฉัย', '[{"label":"A","text":"Hodgkin"},{"label":"B","text":"Primary Mediastinal Large B-cell Lymphoma (PMBL)"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Primary Mediastinal Large B-cell Lymphoma (PMBL): (1) **Epidemiology**: young adults (median 30s), women > men; mediastinal (thymic) origin; locally advanced at presentation often; rapidly growing — superior vena cava syndrome + airway compression; (2) **Histology**: - **Large B-cells** in compartmentalizing fibrosis pattern; - ''Clear cell'' or pale cytoplasm common; - Heterogeneous cytology; - **Distinguishing from classic Hodgkin** can be challenging — overlap entities (''grey zone lymphoma'' — recognized WHO 2022); (3) **IHC**: - **CD20+** (B-cell), CD79a+, PAX5+; - **CD30+ variable** (different from CHL where strong); - **CD15 negative** (vs CHL CD15+); - **CD23+ (~ 70%)** + **MAL+** + **CD200+** — markers favoring PMBL; - **PD-L1+** + **PD-L2+** — frequent due to **9p24.1 amplification** (CD274/PDCD1LG2/JAK2 region); - **BCL6 variable**, **MUM1+**, **CD10 variable**; (4) **Molecular**: - **9p24.1 amplification** with PD-L1/L2/JAK2 — drives immune evasion + IO sensitivity; - Shares molecular features with classic Hodgkin (mediastinal grey zone); - NFKB pathway activation; - JAK-STAT pathway constitutive; - Differentially expressed from typical DLBCL (PMBL gene signature); (5) **Workup**: - PET-CT for staging — mediastinum dominant; - Pleural + pericardial effusions; - SVC syndrome assessment; - Biopsy difficult (mediastinal — image-guided core, mediastinoscopy, VATS); - CNS workup if symptoms; (6) **Treatment**: - **Frontline DA-EPOCH-R** (dose-adjusted etoposide-prednisone-vincristine-cyclophosphamide-doxorubicin + rituximab) — without consolidative RT — Wilson study + others — > 90% cure with reduced late RT effects in chest (cardiovascular, breast cancer); - Alternative R-CHOP × 6 + RT — older paradigm with RT exposure concerns; - **End-of-treatment PET — Deauville scoring** — important for response assessment; (7) **Refractory/relapsed**: - **Pembrolizumab/nivolumab** — PD-L1+ amplified status → excellent response — approved 3L+ in PMBL; - **CAR-T (axi-cel, liso-cel)** approved relapsed/refractory; - **Brentuximab vedotin** for CD30+; - High-dose chemo + auto-HCT historically; (8) **Grey zone lymphoma (PMBL + CHL features)** — distinct entity per WHO HAEM5 2022 — typically DA-EPOCH-R + brentuximab vedotin; (9) **Multidisciplinary**: hematology + RT + pulm + cardiology + path; (10) **Survivorship** — young patients — minimize RT to mediastinum due to long-term cardiac + breast cancer risk

---

PMBL: young adults, mediastinal/thymic origin. Large B-cells in sclerotic compartments. CD20+/CD23+/CD30 variable/MAL+; CD15-. 9p24.1 amp → PD-L1/L2/JAK2 → IO sensitivity. DA-EPOCH-R without RT preferred (Wilson) — > 90% cure. PD-1 inhibitors + CAR-T for R/R. Grey zone lymphoma distinct.', NULL,
  'hard', 'hematopathology', 'review',
  'pathology', 'clinical_decision', 'hematopathology', 'adult',
  'WHO HAEM5 2022; Wilson DA-EPOCH-R PMBL', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 35 ปี — anterior mediastinal mass + dyspnea; biopsy: large B-cell lymphoma in fibrotic background + sclerotic compartments + ''clear cells''; IHC: CD20+, CD23+, CD30+ variable, MAL+, PD-L1+, CD15-; การวินิจฉัย'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 30 ปี Lupus + nephritis + hemoptysis → kidney + lung biopsies; renal IF: linear IgG along GBM; serum anti-GBM (alpha-3 NC1 collagen IV) positive; การวินิจฉัย', '[{"label":"A","text":"Lupus"},{"label":"B","text":"Anti-GBM (Goodpasture) Disease"},{"label":"C","text":"ANCA only"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Anti-GBM (Goodpasture) Disease: (1) **Pathogenesis**: autoantibodies against α3 chain of type IV collagen (Goodpasture antigen) in glomerular + alveolar basement membranes → linear deposition + complement activation → glomerulonephritis + pulmonary hemorrhage; (2) **Histology**: - **Kidney biopsy**: necrotizing + crescentic glomerulonephritis (often > 50% crescents); rapid progression; - **IF**: **strong linear IgG along GBM** — pathognomonic; (vs lupus ''full house'' granular, vs ANCA pauci-immune); - C3 may be linear; - **EM**: no immune complex deposits (unlike lupus, MN); - **Lung biopsy** (rarely done): alveolar hemorrhage + iron-laden macrophages + capillaritis; (3) **Clinical**: - **Rapidly progressive glomerulonephritis** (RPGN); - **Pulmonary hemorrhage** (~ 60%, especially smokers) — life-threatening hemoptysis + hypoxia; - **Anemia** from hemorrhage + AKI; (4) **Workup**: - **Serum anti-GBM antibody** (ELISA — sensitive + specific); - **ANCA — co-positive ~ 20-40%** (often MPO-ANCA — ''double-positive'') — important to test both since management differs subtly; - Kidney biopsy essential; - Bronchoalveolar lavage if pulmonary hemorrhage suspected — bloody returns getting progressively bloodier; - CXR/CT chest; (5) **Differential — pulmonary-renal syndromes**: - **ANCA-associated vasculitis** (GPA, MPA, EGPA); - **Lupus** + other immune complex (cryoglobulinemia, IgA, MN); - **Anti-GBM disease**; - **Distinguishing essential** for treatment + prognosis; (6) **Treatment** (medical emergency — delay → end-stage renal disease + death): - **Combined therapy** (Pusey + early reports): - **Plasma exchange daily until anti-GBM undetectable** (~ 2-3 wk) — removes circulating Ab; - **Cyclophosphamide** (oral or IV) — suppresses Ab production; - **High-dose corticosteroids** + taper; - **PEXIVAS data — anti-GBM excluded** but plasma exchange supported for anti-GBM; - **Rituximab** considered (less evidence than CYC); - **Dialysis** support as needed — ESRD requirement at presentation portends very poor renal recovery — late presenters often dialysis-dependent permanently; - **Lung treatment**: smoking cessation; supportive; (7) **Monitoring**: anti-GBM titer trends, renal function, pulmonary status; (8) **Relapse rare** (vs ANCA frequent) — typically single episode; long-term maintenance immunosuppression less typical; (9) **Kidney transplant**: wait ~ 6-12 mo with anti-GBM undetectable to avoid recurrence; (10) **Multidisciplinary**: nephrology + pulmonology + rheumatology + ICU + path + apheresis

---

Anti-GBM (Goodpasture): anti-α3 type IV collagen → linear IgG along GBM (pathognomonic). RPGN + pulm hemorrhage. Test anti-GBM + ANCA (double-positive ~20-40%). Tx EMERGENCY: PLEX daily + cyclophos + steroids; high recurrence transplant if active. Monitor titers; dialysis at presentation = poor renal recovery.', NULL,
  'hard', 'renal_pathology', 'review',
  'pathology', 'clinical_decision', 'renal_pathology', 'adult',
  'KDIGO Glomerular 2021; Pusey Lancet', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 30 ปี Lupus + nephritis + hemoptysis → kidney + lung biopsies; renal IF: linear IgG along GBM; serum anti-GBM (alpha-3 NC1 collagen IV) positive; การวินิจฉัย'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย septic shock — ABG: pH 7.20, pCO2 25, HCO3 10, anion gap 25, lactate 6; mixed acid-base disorder + interpretation + Tx', '[{"label":"A","text":"Normal"},{"label":"B","text":"Acid-Base + Lactic Acidosis Interpretation"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acid-Base + Lactic Acidosis Interpretation: (1) **Stepwise approach to ABG**: - **Step 1: Acidemia or alkalemia?** pH (normal 7.35-7.45); this case 7.20 = acidemia; - **Step 2: Primary disorder?** Look at pCO2 + HCO3 simultaneously: - **Metabolic acidosis** if HCO3 ↓ + pCO2 ↓ (compensatory); - **Respiratory acidosis** if pCO2 ↑ + HCO3 ↑ (compensatory if chronic); - **Metabolic alkalosis** if HCO3 ↑ + pCO2 ↑ (compensatory); - **Respiratory alkalosis** if pCO2 ↓ + HCO3 ↓ (compensatory if chronic); - **Step 3: Compensation appropriate?** - **Winters formula** for metabolic acidosis: expected pCO2 = 1.5 × HCO3 + 8 ± 2; - If different — mixed disorder; - This case: expected pCO2 = 1.5 × 10 + 8 = 23 ± 2 → actual 25 — appropriate compensation; - **Step 4: Anion gap?** - AG = Na - (Cl + HCO3); normal 8-12; - This case AG 25 = high anion gap metabolic acidosis (HAGMA); - **Step 5: HAGMA causes (MUDPILES / GOLDMARK)**: - **Methanol**; - **Uremia**; - **DKA + alcoholic KA + starvation KA**; - **Propylene glycol** (lorazepam infusion); - **Iron, INH**; - **Lactic acidosis** (this case — sepsis + Type A from hypoperfusion); - **Ethylene glycol**; - **Salicylates**; - **Glycols, Oxoproline (acetaminophen + malnutrition), L-lactate, D-lactate (short gut), Methanol, ASA, Renal failure, Ketoacidosis** (GOLDMARK); - **Step 6: Delta-delta** for additional acid-base disorders: - ΔAG = current AG - normal AG (12); - ΔHCO3 = normal HCO3 (24) - current HCO3; - Δ/Δ ratio close to 1 = pure HAGMA; - > 2 = HAGMA + metabolic alkalosis; - < 1 = HAGMA + non-AG (NAG) metabolic acidosis; (2) **Non-anion gap metabolic acidosis**: GI loss bicarb (diarrhea), renal tubular acidosis, recovery DKA, hyperalimentation, ureteral diversion; **USED CAR P** mnemonic; - Urinary anion gap helps distinguish renal vs GI cause; (3) **Lactic acidosis specifics**: - **Type A (hypoperfusion)**: sepsis, shock, ischemia, severe hypoxia — most common, ICU; - **Type B**: thiamine deficiency (Wernicke + beriberi), drugs (linezolid, metformin in renal failure, propofol, NRTIs, isoniazid, salicylate), congenital metabolic, malignancy (Warburg effect, leukemia), HIV; - **D-lactic acidosis** — short bowel; - **Lactate trend** + **clearance** prognostic; - **Treat underlying** + supportive (fluids, vasopressors, oxygenation); - **Bicarbonate** controversial — may give for pH < 7.1-7.15 in severe + ongoing acidosis; (4) **Sepsis specifically**: - Fluid resuscitation + early antibiotics + source control + vasopressors (norepi); - Surviving Sepsis Campaign bundles; - Lactate trends monitor response; (5) **Vital signs + arterial line** for serial assessment; (6) **Multidisciplinary**: ED + ICU + ID + nephrology + nutrition + critical care; (7) **Don''t forget electrolyte disturbances** — potassium shifts with acidosis correction

---

ABG: pH → metab vs resp → compensation (Winters: expected pCO2 = 1.5×HCO3+8) → AG → delta-delta. HAGMA causes: MUDPILES/GOLDMARK incl lactic acidosis (sepsis = Type A). Treat underlying + sepsis bundles. Lactate trend prognostic. Bicarb controversial (severe + persistent). NAGMA: USED CAR P.', NULL,
  'medium', 'clinical_chemistry', 'review',
  'pathology', 'clinical_decision', 'clinical_chemistry', 'adult',
  'SCCM Surviving Sepsis Campaign 2021', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วย septic shock — ABG: pH 7.20, pCO2 25, HCO3 10, anion gap 25, lactate 6; mixed acid-base disorder + interpretation + Tx'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident — fundamentals of mass spectrometry in clinical pathology (LC-MS/MS for steroid hormones + vitamin D, MALDI-TOF for microbe ID + protein typing) applications', '[{"label":"A","text":"Random"},{"label":"B","text":"Mass Spectrometry in Clinical Path"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mass Spectrometry in Clinical Path: (1) **Principles**: mass spec ionizes molecules → separates ions by mass-to-charge (m/z) ratio → detector counts; highly specific + sensitive identification + quantification; (2) **Major ionization + separation modes**: - **LC-MS/MS (liquid chromatography tandem mass spectrometry)** — small molecules; quantitative; multiple reaction monitoring (MRM); - **GC-MS** (gas chromatography) — volatile compounds; - **MALDI-TOF (matrix-assisted laser desorption/ionization-time of flight)** — large molecules (proteins, peptides, organisms); identification + typing; - **HRMS (high-resolution)** — accurate mass, discovery; (3) **Clinical applications**: - **Steroid hormones**: testosterone (definitive method especially women/children — immunoassay interference), estradiol, 17-OH-progesterone (CAH), aldosterone, cortisol, vitamin D (1,25 + 25-OH), DHEAS, androstenedione — comprehensive steroid panels; - **Therapeutic drug monitoring (TDM)**: immunosuppressants (tacrolimus, cyclosporine, sirolimus, everolimus), antifungals (voriconazole, posaconazole), antibiotics (vancomycin emerging), antivirals, antiretrovirals; - **Toxicology**: comprehensive drug + metabolite screening + confirmation; pain management; postmortem tox; designer drugs; - **Newborn screening**: tandem MS — acylcarnitines + amino acids — detects > 40 inborn errors of metabolism in 1 drop of blood; - **Amyloid typing**: laser-capture microdissection of Congo red+ deposits → trypsin digest → LC-MS/MS — definitive AL/ATTR/AA/other amyloid typing (more accurate than IHC); - **Microbial identification (MALDI-TOF)**: identifies bacteria, fungi, mycobacteria in minutes from colonies — revolutionary in clinical micro since ~ 2010s; - **Hemoglobinopathy** detection — Hb variants; - **Protein characterization**: HPLC + MS for monoclonal proteins, FLC, others; - **Proteomics** in research; - **Pharmacogenomics phenotyping**; (4) **Pre-analytics**: matrix (serum, plasma, urine, dried blood spot, tissue), collection timing (diurnal hormones), avoid contamination (e.g., bottle plasticizers, sample contact); (5) **Validation + QC**: - Specificity + linearity + recovery + matrix effects + carryover; - Internal standards (stable-isotope labeled); - Calibration curves; - QC across range; - Proficiency testing; - CLIA-validated; (6) **Advantages over immunoassay**: - **Higher specificity** (no cross-reactivity from similar molecules) — gold standard for steroids especially women + children + transgender population; - Multiplex (many analytes in one run); - No antibody reagent needed for many assays; (7) **Limitations**: - Equipment cost + expertise + maintenance; - Slower than immunoassay typically (LC step); - Method development complex; (8) **Examples revolutionizing care**: - Testosterone in women + children — old immunoassays unreliable; - Aldosterone-to-renin ratio screening primary aldosteronism; - 17-OH-progesterone CAH screening; - Amyloid typing changing diagnosis paradigm; - MALDI-TOF transforming clinical micro turnaround + identification accuracy; (9) **Future**: more clinical adoption, AI for data interpretation, portable spectrometers, integration with NGS for proteogenomics

---

Mass spec: LC-MS/MS (small mol — steroids/TDM/tox/newborn screen), MALDI-TOF (large mol — micro ID + amyloid typing). Higher specificity than immunoassay (gold standard for steroids in women/children + amyloid typing). MS revolutionized clinical micro + amyloid Dx. Equipment + expertise barriers but expanding clinical use.', NULL,
  'medium', 'clinical_chemistry', 'review',
  'pathology', 'basic_science', 'clinical_chemistry', 'mixed',
  'AACC; CLSI Mass Spec', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Resident — fundamentals of mass spectrometry in clinical pathology (LC-MS/MS for steroid hormones + vitamin D, MALDI-TOF for microbe ID + protein typing) applications'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี ABG + electrolytes — Na 142, K 2.8, Cl 92, HCO3 35; BP 180/110; renin low, aldosterone high; primary aldosteronism workup', '[{"label":"A","text":"Random"},{"label":"B","text":"Primary Aldosteronism (PA, Conn Syndrome)"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Primary Aldosteronism (PA, Conn Syndrome): (1) **Most common secondary HTN** — under-recognized — ~ 5-15% of HTN; (2) **Pathophysiology**: autonomous aldosterone secretion → Na retention + K wasting + metabolic alkalosis + HTN + suppressed renin; (3) **Causes**: - **Aldosterone-producing adenoma (APA)** ~ 35% — surgical cure possible; - **Bilateral idiopathic hyperaldosteronism (BIH)** ~ 60% — medical management; - **Unilateral adrenal hyperplasia**, primary adrenal hyperplasia; - **Familial hyperaldosteronism (FH I-IV)** — autosomal dominant — rare; - **Aldosterone-producing carcinoma** — rare; (4) **Clinical**: - HTN often resistant to multiple meds; - Hypokalemia (not always — < 50% have low K); - Metabolic alkalosis; - Headaches, muscle weakness, polyuria/polydipsia; - **End-organ damage worse than essential HTN** with same BP — direct aldosterone effects on heart + vessels + kidney; (5) **Screening (Endocrine Society 2016 guidelines)**: - **Indications**: resistant HTN, HTN + hypokalemia, HTN + adrenal mass, HTN + family history early HTN/CVA, all 1st degree relatives with PA, HTN + sleep apnea (high comorbidity); - **Aldosterone-to-renin ratio (ARR)** — primary screen — elevated suggests PA; - Discontinue interfering meds (MR antagonists, ACE/ARB, diuretics) when feasible — or interpret cautiously; - Beta-blockers + clonidine + alpha-methyldopa interfere; - Adrenergic alpha-blockers (doxazosin, terazosin) + verapamil + hydralazine OK to use; - Salt loading not needed for screen; - Cutoffs vary by lab — typically ARR > 30 (with aldosterone units ng/dL + renin ng/mL/hr); - Newer LC-MS/MS for aldosterone reliable; (6) **Confirmation**: - **Saline infusion test** — aldosterone fails to suppress < 5 ng/dL; - **Captopril challenge**; - **Oral salt loading + 24h urine aldosterone**; - **Fludrocortisone suppression**; (7) **Subtype determination**: - **CT/MRI adrenal** — nodule(s) visualized but small APAs missed + non-functional adenomas common; - **Adrenal Vein Sampling (AVS)** — gold standard for distinguishing unilateral vs bilateral — guides surgery vs medical Tx; technically demanding but essential for surgical candidates; (8) **Treatment**: - **Unilateral APA (after AVS)**: laparoscopic adrenalectomy — curative or improves HTN dramatically; - **Bilateral disease**: **mineralocorticoid receptor antagonist** — spironolactone (first-line, can have anti-androgen SE — gynecomastia, menstrual changes), eplerenone (more selective, less SE, less potent); finerenone — newer (renal indications HF + CKD); - **Newer agents** — aldosterone synthase inhibitors (baxdrostat, lorundrostat) under study; - **K supplementation**; - **Genetic** familial — specific approaches (e.g., FH I = glucocorticoid-remediable — dexamethasone); (9) **Multidisciplinary**: endocrinology + interventional radiology + endo surgery + path + cardiology + nephrology

---

Primary aldosteronism: ↑aldo + ↓renin + ↑ARR. Causes: APA (~35%, surgical), BIH (~60%, medical), familial. Screening — ARR + drug interference considered. Confirm with saline infusion. AVS gold standard for lateralization. Tx: laparoscopic adrenalectomy (APA) or MRA (spironolactone/eplerenone). Aldo synthase inhibitors emerging.', NULL,
  'hard', 'clinical_chemistry', 'review',
  'pathology', 'clinical_decision', 'clinical_chemistry', 'adult',
  'Endocrine Society PA 2016', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี ABG + electrolytes — Na 142, K 2.8, Cl 92, HCO3 35; BP 180/110; renin low, aldosterone high; primary aldosteronism workup'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 40 ปี — Cushingoid features + weight gain + central obesity + striae + HTN + hyperglycemia; 24-h urine free cortisol elevated + late-night salivary cortisol elevated; ACTH suppressed; workup', '[{"label":"A","text":"Refuse"},{"label":"B","text":"Cushing Syndrome Workup"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cushing Syndrome Workup: (1) **Definitions**: - **Cushing syndrome (CS)** — clinical state of chronic glucocorticoid excess (any cause); - **Cushing disease** — pituitary ACTH-secreting adenoma (specific subset of CS); (2) **Causes**: - **Exogenous (iatrogenic)** — most common — chronic steroid Tx; - **Endogenous**: - **ACTH-dependent (~ 80%)**: - **Cushing disease (pituitary adenoma)** ~ 70%; - **Ectopic ACTH** ~ 10% — SCLC, bronchial carcinoid, MTC, pheo, neuroendocrine tumors; - **Ectopic CRH** rare; - **ACTH-independent (~ 20%)**: - Adrenal adenoma; - Adrenal carcinoma (rare, virilizing, aggressive); - Bilateral micronodular/macronodular adrenal hyperplasia (primary pigmented nodular adrenal disease — Carney complex; bilateral macronodular — aberrant receptor signaling); - **Subclinical Cushing** — adrenal incidentaloma with mild autonomous secretion — increasingly recognized; (3) **Clinical**: - Central obesity, buffalo hump, supraclavicular fat, moon facies; - Purple striae > 1 cm wide; - Skin atrophy, easy bruising; - Proximal muscle weakness; - HTN + hyperglycemia/DM + dyslipidemia; - Hypokalemia (especially ectopic); - Osteoporosis + fractures; - Psychiatric (depression, psychosis); - Hypogonadism; - Infections + impaired wound healing; - In Cushing disease — hyperpigmentation (ACTH stimulates MSH) — also ectopic; (4) **Screening tests (Endocrine Society 2008 + updates)**: - **Late-night salivary cortisol** (loss of diurnal rhythm) — high sensitivity; - **24-h urinary free cortisol** (UFC) — quantifies overall cortisol production; - **Overnight 1-mg dexamethasone suppression test (DST)** — failure to suppress (> 1.8 μg/dL); - **2-2 low-dose DST** alternative; - 2 abnormal tests typically required to confirm; - Pre-test probability + exclusion of factors that can cause false-positive (alcoholism, depression, pregnancy, OCP, obesity = ''pseudo-Cushing''); (5) **Differentiation by ACTH + further testing**: - **ACTH suppressed** = ACTH-independent → adrenal — CT/MRI adrenal + further workup; - **ACTH normal/elevated** = ACTH-dependent — distinguish pituitary vs ectopic: - **High-dose DST** (2 mg q6h × 2 d or 8-mg overnight) — Cushing disease suppresses (≥ 50%), ectopic typically doesn''t; - **CRH stimulation** — Cushing disease responds; - **Pituitary MRI** + sometimes inferior petrosal sinus sampling (IPSS) — gold standard for distinguishing pituitary vs ectopic; - **Imaging for ectopic** — CT/MRI chest/abdomen, 68Ga-DOTATATE PET for neuroendocrine; (6) **Treatment**: - **Cushing disease**: transsphenoidal pituitary surgery (curative when complete); RT for residual/recurrence; medical (pasireotide somatostatin analog, cabergoline) for surgically refractory + adjunct; - **Adrenal adenoma**: adrenalectomy; - **Adrenal carcinoma**: surgery + mitotane + chemo (etoposide-doxorubicin-cisplatin); - **Ectopic ACTH**: treat primary tumor; if unresectable — adrenal-targeted (metyrapone, ketoconazole, etomidate, **osilodrostat — 11β-hydroxylase inhibitor — newer**, mifepristone — receptor blocker for hyperglycemia); bilateral adrenalectomy for refractory; (7) **Multidisciplinary**: endocrinology + neurosurgery/endo surgery + RT + path + cardiology + DM + bone + mental health + ID; (8) **Manage comorbidities** actively in parallel

---

Cushing syndrome: ↑cortisol — iatrogenic vs endogenous (ACTH-dep: pituitary or ectopic; ACTH-indep: adrenal). Screen: late-night salivary, 24h UFC, 1-mg DST. Confirm with ≥2 tests + exclude pseudo-Cushing. ACTH guides further: high-dose DST + IPSS for source. Tx: TSS for Cushing disease; adrenalectomy for adenoma; treat ectopic primary; osilodrostat medical management.', NULL,
  'medium', 'clinical_chemistry', 'review',
  'pathology', 'clinical_decision', 'clinical_chemistry', 'adult',
  'Endocrine Society Cushing 2008/updates', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 40 ปี — Cushingoid features + weight gain + central obesity + striae + HTN + hyperglycemia; 24-h urine free cortisol elevated + late-night salivary cortisol elevated; ACTH suppressed; workup'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยมี multiple cancers in family + young onset; hereditary cancer panel testing — variant interpretation + ACMG framework + family counseling + integrative care', '[{"label":"A","text":"Random"},{"label":"B","text":"Hereditary Cancer Syndromes Genetic Testing"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hereditary Cancer Syndromes Genetic Testing: (1) **Common syndromes**: - **HBOC (Hereditary Breast + Ovarian Cancer)**: BRCA1/2 (also pancreatic, prostate, melanoma); - **Lynch syndrome (HNPCC)**: MLH1, MSH2, MSH6, PMS2, EPCAM (colon, endometrial, ovarian, gastric, urothelial, biliary, brain, skin); - **Li-Fraumeni**: TP53 (sarcoma, breast, brain, adrenal, leukemia); - **Cowden (PHTS)**: PTEN (breast, thyroid, endometrial, hamartomas); - **FAP**: APC (CRC adenomatous polyposis + extracolonic — desmoids, duodenum, papillary thyroid); attenuated FAP (AFAP); MUTYH-associated polyposis (MAP); - **Peutz-Jeghers**: STK11 (GI hamartomas + pigmentation + cancers); - **Juvenile polyposis**: SMAD4, BMPR1A; - **MEN1, MEN2** (described); - **VHL** (described); - **NF1, NF2, TSC** + others; - **Hereditary diffuse gastric** (CDH1) — also ILC breast; - **Familial atypical multiple mole melanoma (FAMMM)**: CDKN2A; - **Hereditary leiomyomatosis + renal cell carcinoma (HLRCC)**: FH; - **BAP1 tumor predisposition**: mesothelioma + uveal melanoma + RCC + cutaneous melanocytic; (2) **NGS-based hereditary cancer panel testing**: - 20-100+ gene panels common; - Pan-cancer or syndrome-specific; - Germline (blood, saliva, buccal swab — DNA) — usually germline focus; - Often paired with tumor testing for somatic vs germline distinction in cancers; (3) **Variant interpretation — ACMG/AMP 2015 framework (updated)**: - **Pathogenic (P)**: ≥ 1 very strong + ≥ 1 strong, OR ≥ 2 strong, etc.; - **Likely pathogenic (LP)**: 90-99% probability pathogenic; - **VUS (Variant of Uncertain Significance)**: insufficient data; - **Likely benign (LB)** + **Benign (B)**: ≥ 99% benign; - **Evidence types**: population data (allele frequency in gnomAD), computational predictions (REVEL, CADD), functional studies, segregation, de novo, splicing predictions, clinical phenotype + matching; - **Databases**: ClinVar, ClinGen, LOVD, gene-specific (BRCA Exchange, InSiGHT, etc.); - **VUS — important not to treat as pathogenic** clinically — but track + reclassify with new evidence; (4) **Indications for testing (NCCN-Genetic/Familial High-Risk Assessment)**: - Personal history of certain cancers (BRCA-related early-onset, ovarian, male breast, pancreatic, prostate metastatic; CRC < 50 or with tumor MSI; multiple primary cancers; family history meeting criteria); - **Universal testing** in some contexts (all CRC + endometrial — universal Lynch screen; all ovarian — BRCA + HRD; recent trend — all metastatic prostate, pancreatic — germline testing); - **Family genetic counseling** + cascade testing of relatives; (5) **Pre + post-test genetic counseling — essential**: - Pre — discuss potential outcomes + implications + insurance + family + emotional + informed consent; - Post — disclose + interpret + management plan + cascade testing + reproductive options; - Recommended Genetic counselor or appropriately trained provider; (6) **Management based on pathogenic variant**: - **Risk-reducing surveillance** (e.g., breast MRI, colonoscopy more frequent); - **Risk-reducing surgery** (e.g., BRSO for BRCA — bilateral salpingo-oophorectomy by age 35-40; prophylactic mastectomy considered); - **Chemoprevention** (e.g., aspirin Lynch CAPP2; tamoxifen breast); - **Treatment implications** for affected — PARP inhibitors for BRCA, IO for MSI-H/Lynch; - **Cascade testing** for family — ethical + reproductive implications; (7) **Reproductive options**: pre-implantation genetic testing (PGT), prenatal testing, family planning; (8) **Equity considerations**: - Access to testing + counseling + management; - **Variant interpretation more reliable in well-represented populations** — VUS rates higher in under-represented (need diverse data); - Insurance + financial considerations; - Cultural sensitivity around family disclosure + reproductive decisions; (9) **Multidisciplinary**: medical genetics + genetic counseling + medical oncology + surgical onc + screening teams + ethics + research; (10) **Continued education** + reclassification of variants over time

---

Hereditary cancer syndromes: HBOC, Lynch, Li-Fraumeni, Cowden, FAP, MEN, VHL, NF, BAP1, HLRCC, etc. NGS panels + ACMG/AMP 5-tier variant classification (P/LP/VUS/LB/B). Pre + post-test counseling. Management — surveillance/risk-reducing surgery/chemoprevention/Tx implications (PARP/IO) + cascade family testing. Equity in access + interpretation.', NULL,
  'hard', 'molecular_pathology', 'review',
  'pathology', 'clinical_decision', 'molecular_pathology', 'mixed',
  'ACMG/AMP 2015; NCCN Genetic/Familial', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยมี multiple cancers in family + young onset; hereditary cancer panel testing — variant interpretation + ACMG framework + family counseling + integrative care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี — uterus enlarging mass + bleeding → resection: smooth muscle tumor with cellular atypia + necrosis + mitoses 15/10 HPF; IHC: desmin+, SMA+, h-caldesmon+, ER/PR+, Ki-67 high; การวินิจฉัย — Stanford criteria + management', '[{"label":"A","text":"Leiomyoma"},{"label":"B","text":"Uterine Leiomyosarcoma + Smooth Muscle Spectrum"},{"label":"C","text":"Endometrial ca"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Uterine Leiomyosarcoma + Smooth Muscle Spectrum: (1) **Categories (WHO 2020 Female Genital Tumors)**: - **Leiomyoma** — benign — bland smooth muscle; common; - **Smooth muscle tumor of uncertain malignant potential (STUMP)** — atypical features but not full criteria for sarcoma; - **Leiomyosarcoma (LMS)** — malignant; - **Other variants**: cellular leiomyoma, mitotically active leiomyoma, atypical leiomyoma, lipoleiomyoma, leiomyoma with bizarre nuclei (formerly ''symplastic''); intravenous leiomyomatosis; benign metastasizing leiomyoma; (2) **Stanford criteria for uterine LMS (need ≥ 2 of 3)**: - **Severe nuclear atypia (moderate-to-severe diffuse)**; - **Mitotic count ≥ 10/10 HPF**; - **Tumor cell necrosis** (coagulative necrosis with abrupt transition — NOT hyalinizing/ischemic necrosis); (3) **Histology + IHC**: - Spindle cells (fascicular pattern), epithelioid + myxoid variants exist; - **IHC**: desmin+, SMA+, **h-caldesmon+** (smooth muscle specific), HMW caldesmon, calponin+; ER/PR variable; - **Ki-67 high** in LMS vs low in leiomyoma; - **p53** abnormal expression — increased in LMS; - **p16** strong + diffuse in LMS (vs patchy leiomyoma); - **CD10 in low-grade endometrial stromal sarcoma** (DDx); (4) **Differential**: leiomyoma variants (especially bizarre nuclei — important not to overdiagnose), endometrial stromal sarcoma (CD10+, ER+, low/intermediate mitoses + YWHAE-NUTM2 — high-grade ESS; JAZF1-SUZ12 — low-grade ESS), adenosarcoma, undifferentiated uterine sarcoma; (5) **Concern about morcellation**: - **Power morcellation of presumed leiomyoma can disseminate undiagnosed LMS** → FDA black box warning + restriction in many practices; - Pre-operative MRI + biomarkers + bag containment if morcellation needed; (6) **Workup**: - Imaging (US + MRI); - Endometrial biopsy may not yield (intramural); - LDH elevated possible; - Staging when LMS confirmed — CT chest-abdomen-pelvis; (7) **Treatment**: - **Total hysterectomy + BSO**; lymphadenectomy not routine (low yield); peritoneal staging; - **Adjuvant chemotherapy** controversial — limited evidence; doxorubicin-based; gemcitabine + docetaxel; **GeDDiS, EORTC** trials negative for survival in adjuvant — but some role for high-risk; - **Adjuvant RT** — limited benefit overall; - **Metastatic disease**: - **Doxorubicin** ± dacarbazine first-line; - **Gemcitabine + docetaxel** alternative; - **Trabectedin (Yondelis)** — translocation-related sarcomas (but LMS responds — ENGOT-EN10); - **Eribulin** (E7389) — third-line + later; - **Pazopanib** + other TKIs; - **Olaratumab** (PDGFR) — withdrew after ANNOUNCE; - Emerging: doxorubicin + temozolomide, immunotherapy + chemo combos (limited responses in sarcomas in general); (8) **Multidisciplinary**: GYN onc + medical onc + RT + path + radiology + genetic counseling (Li-Fraumeni, hereditary leiomyomatosis HLRCC — fumarate hydratase loss); (9) **Prognosis**: stage-dependent, often advanced + recurs; new agents needed

---

Uterine LMS: Stanford criteria (atypia + mitoses ≥ 10/10HPF + coagulative necrosis). IHC desmin/SMA/h-caldesmon+; p16/p53 + Ki-67 ↑ in LMS. STUMP intermediate. Morcellation FDA warning. TAH-BSO; adjuvant chemo controversial. Doxorubicin/gem-docetaxel/trabectedin/eribulin metastatic. HLRCC + Li-Fraumeni associations.', NULL,
  'hard', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'WHO Female Genital Tumors 5th ed; NCCN Sarcoma', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี — uterus enlarging mass + bleeding → resection: smooth muscle tumor with cellular atypia + necrosis + mitoses 15/10 HPF; IHC: desmin+, SMA+, h-caldesmon+, ER/PR+, Ki-67 high; การวินิจฉัย — Stanford criteria + management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 30 ปี ตั้งครรภ์ที่ 32 wk — HELLP syndrome (Hemolysis + Elevated Liver enzymes + Low Platelets) — pathology + multidisciplinary integrative management', '[{"label":"A","text":"Random"},{"label":"B","text":"HELLP Syndrome — Pathology + Management"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** HELLP Syndrome — Pathology + Management: (1) **Definition + criteria** (Mississippi or Tennessee classification): - **Hemolysis**: schistocytes + low haptoglobin + ↑LDH + ↑ indirect bili; - **Elevated Liver enzymes**: AST/ALT > 70 U/L; - **Low Platelets**: < 100 × 10⁹/L; - Severity Mississippi I (platelets < 50), II (50-100), III (100-150); (2) **Spectrum within preeclampsia**: - **Preeclampsia (PE)** — HTN + proteinuria/end-organ injury > 20 wk gestation; - **Severe PE** — features incl headache, visual symptoms, oliguria, pulmonary edema, ↑Cr, HELLP, thrombocytopenia, fetal growth restriction; - **HELLP syndrome** — subset; can occur with or without overt HTN/proteinuria; - **Eclampsia** — PE + seizures; (3) **Pathophysiology**: - Abnormal placentation + endothelial dysfunction + systemic inflammation; - Antiangiogenic factors (sFlt-1, sEng) elevated; - Microangiopathic process with microthrombi in placenta + liver + kidney + brain; - Hepatic involvement — periportal necrosis, microhemorrhages, infarction, subcapsular hematoma (severe — rupture risk); (4) **Differential — thrombotic microangiopathies in pregnancy** (similar lab features — different management): - HELLP/preeclampsia — delivery is treatment; - **Pregnancy-onset TTP** — ADAMTS13 < 10% — PLEX needed; - **aHUS (atypical HUS)** — complement-mediated — eculizumab + delivery; - **AFLP (acute fatty liver of pregnancy)** — hypoglycemia + LFTs ↑↑ + DIC + Swansea criteria — delivery; - DIC from other obstetric (abruption, IUFD, amniotic fluid embolism); - Lupus flare with antiphospholipid syndrome; (5) **Workup**: - CBC + smear + platelet count + LFTs + LDH + haptoglobin; - PT/PTT/fibrinogen + D-dimer (DIC); - Cr + uric acid + UA + UPCR (preeclampsia); - **ADAMTS13** if TTP suspected; - Complement assays if aHUS suspected; - Liver imaging (US) for hematoma/rupture; - Brain MRI if neurologic; (6) **Treatment** (urgent — fetal + maternal compromise): - **DELIVERY definitive Tx** — depending on gestational age + maternal/fetal status; - **Stabilize maternal** — control BP (labetalol, hydralazine, nicardipine; avoid ACE/ARB), magnesium for seizure prophylaxis + neuroprotection; - **Antenatal corticosteroids** for fetal lung maturity if < 34 wk and time allows; - **Platelet + FFP transfusion** for severe bleeding/before procedure; - **Cesarean delivery** often needed (rapid + maternal safer); - **Monitoring** in HDU/ICU; - **Magnesium sulfate** continue postpartum 24-48 hr; (7) **Postpartum**: - Most improve within 48-72 hr postpartum; - Watch for **postpartum HELLP** (can develop or worsen postpartum); - **Hepatic hematoma rupture** — surgical emergency; - **Long-term**: HTN, CKD, CVD risk increased — follow-up + lifestyle + low-dose aspirin in future pregnancy from 12 wk to reduce recurrence; (8) **Placental pathology**: MVM (maternal vascular malperfusion) — infarcts, decidual arteriopathy, accelerated villous maturation, distal villous hypoplasia; (9) **Recurrence + future pregnancy planning**: ~ 20% recurrence; ASA + early specialist care; (10) **Multidisciplinary**: maternal-fetal medicine + OB + neonatology + ICU + hematology + nephrology + hepatology + path + nursing

---

HELLP: Hemolysis + ↑LFTs + low Plt within preeclampsia spectrum. Pathology MVM. DDx: TTP (ADAMTS13), aHUS (complement), AFLP, DIC, lupus/APS. Tx: delivery definitive + BP control + MgSO4 + antenatal steroids if <34wk + transfusion. Watch hepatic hematoma rupture. Long-term CVD risk + future pregnancy ASA.', NULL,
  'medium', 'obgyn', 'review',
  'pathology', 'clinical_decision', 'obgyn', 'adult',
  'ACOG; ISSHP Preeclampsia', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 30 ปี ตั้งครรภ์ที่ 32 wk — HELLP syndrome (Hemolysis + Elevated Liver enzymes + Low Platelets) — pathology + multidisciplinary integrative management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย acute pancreatitis severe — lab markers + interpretation + pathology + multidisciplinary integrative care', '[{"label":"A","text":"Random"},{"label":"B","text":"Acute Pancreatitis Lab + Management"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Pancreatitis Lab + Management: (1) **Diagnosis (≥ 2 of 3 Atlanta criteria)**: - Abdominal pain consistent with pancreatitis; - Serum lipase or amylase > 3× ULN; - Imaging findings consistent with pancreatitis (US, CT, MRI); (2) **Lab markers**: - **Lipase** — more specific than amylase + longer half-life (preferred); elevations persist 8-14 d; - **Amylase** — less specific (salivary, ovarian, gut); peaks early + falls 3-5 d; - **Both can be elevated in non-pancreatic conditions** — bowel perforation/ischemia, salivary, ectopic pregnancy, ovarian cyst, renal failure, DKA, macroamylasemia; - **Lipase > 3× ULN** typical for diagnosis; absolute level doesn''t predict severity; - **Calcium** — may drop (saponification + sequestration in necrosis); - **Glucose, triglycerides** — severity/etiology; - **LFTs** — biliary etiology (ALT > 150 U/L predicts gallstone pancreatitis); - **CRP** — at 48 hr > 150 predicts severe disease; - **BUN + creatinine** — predicts mortality (BUN rise > 5 mg/dL in 24 hr → mortality); - **Hematocrit** — hemoconcentration severe; (3) **Etiology**: - **Gallstones** (most common — 40%) — confirmed with US, ERCP if obstruction; - **Alcohol** (30%); - **Hypertriglyceridemia** (5%) — TG > 1000 mg/dL; - **Drug-induced** (azathioprine, valproate, didanosine, mesalamine, others); - **Idiopathic** (~ 15%); - **Other**: ERCP-related, post-traumatic, hereditary (PRSS1, SPINK1, CFTR), autoimmune pancreatitis (IgG4-RD), tumor (PDAC, IPMN, NET), infections (mumps, hepatitis), hypercalcemia, anatomic; (4) **Severity assessment (Revised Atlanta 2012)**: - **Mild**: no organ failure or local complications; - **Moderately severe**: transient organ failure (< 48 hr) and/or local complications; - **Severe**: persistent organ failure (> 48 hr); - **Predictors**: BISAP, APACHE II, Ranson, persistent organ failure on day 3, BUN, creatinine; - **CT severity index** (CTSI) for imaging; (5) **Pathology** (severe cases on autopsy or surgery): - Acute interstitial edematous pancreatitis (more common); - Acute necrotizing pancreatitis — necrosis of pancreatic + peripancreatic tissue (~ 20%); - Peripancreatic fluid collections, pseudocysts (later), walled-off necrosis; - Fat necrosis with chalky deposits (saponification); - Hemorrhagic pancreatitis severe; (6) **Treatment**: - **Aggressive IV fluid resuscitation** (lactated Ringer''s preferred — improved outcomes); guided by clinical + lactate + UO; - **Analgesia** — opioids; - **Nutrition**: early enteral feeding (within 24-48 hr) — improves outcomes vs NPO/TPN; nasoenteric tube if needed; - **Antibiotics**: NOT prophylactic; reserve for documented infected necrosis or systemic infection; - **ERCP**: for biliary etiology with persistent obstruction/cholangitis — within 24-72 hr; - **Cholecystectomy**: for gallstone pancreatitis — during same admission for mild, after resolution for severe; - **Hypertriglyceridemia**: insulin + heparin + apheresis severe; - **Step-up approach for necrosis with infection**: percutaneous drainage → minimally invasive necrosectomy (endoscopic transluminal preferred) → surgery; - **Complications**: necrosis with infection, ARDS, AKI, abdominal compartment syndrome, vascular complications (pseudoaneurysm, thrombosis), pseudocysts, chronic pancreatitis; (7) **Multidisciplinary**: gastroenterology + general/HPB surgery + IR + ICU + nutrition + ID + path + endocrinology (DM)

---

Acute pancreatitis: lipase > 3× (more specific than amylase). Etiology: gallstones > alcohol > TG > drugs > idiopathic > autoimmune. Revised Atlanta severity. Tx: aggressive LR fluids + early enteral nutrition + analgesia + ERCP for biliary obstruction. Step-up approach for infected necrosis. NO prophylactic antibiotics.', NULL,
  'medium', 'clinical_chemistry', 'review',
  'pathology', 'clinical_decision', 'clinical_chemistry', 'adult',
  'Revised Atlanta 2012; ACG Acute Pancreatitis', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วย acute pancreatitis severe — lab markers + interpretation + pathology + multidisciplinary integrative care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยเด็กอายุ 2 ปี — abdominal mass + AFP very high (200000); biopsy: tumor cells with hepatocyte differentiation + fetal/embryonal pattern + small cell undifferentiated; การวินิจฉัย', '[{"label":"A","text":"HCC adult"},{"label":"B","text":"Hepatoblastoma — Pediatric Liver Tumor"},{"label":"C","text":"Wilms"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hepatoblastoma — Pediatric Liver Tumor: (1) **Most common pediatric primary liver cancer**; median age ~ 1 yr; (2) **Risk factors + syndromes**: - **Beckwith-Wiedemann syndrome (BWS)** — 11p15 imprinting disorder — increased Wilms + hepatoblastoma — surveillance; - **Familial adenomatous polyposis (FAP)** — APC mutation — increased hepatoblastoma — surveillance in children with FAP family; - Premature/very low birth weight; - Trisomy 18; - Hemihypertrophy; (3) **Histology (Children''s Oncology Group + International Consensus)**: - **Pure fetal epithelial** (best prognosis) — uniform small cuboidal cells resembling fetal hepatocytes; - **Mixed fetal + embryonal**; - **Macrotrabecular**; - **Small cell undifferentiated (SCU)** — INI1/SMARCB1 loss possible — aggressive, behaves like rhabdoid; - **Mixed epithelial + mesenchymal** (including teratoid + osteoid + cartilage); - **Cholangioblastic** + others; (4) **IHC**: - **HepPar-1+, arginase-1+, glypican-3+, AFP+ (often very high)** (similar to HCC); - **Beta-catenin nuclear/cytoplasmic** translocation (CTNNB1 mutations frequent); - INI1/SMARCB1 loss in SCU subtype; - **Hematopoietic precursors** in stroma in some; (5) **Workup**: - **AFP** — markedly elevated (often > 100,000) — diagnostic + monitoring; - **PIVKA-II/DCP**; - **Imaging**: US (initial), MRI/CT for staging; **PRETEXT staging system** (pre-treatment extent); annotation factors (V — vena cava, P — portal vein, E — extrahepatic, F — focality, R — rupture, etc.); - **CXR/CT chest** — lung mets common; - **Germline testing** for FAP if family history; (6) **PRETEXT system (radiologic)**: divides liver into 4 sections — assesses number of sections involved + extrahepatic features; (7) **Treatment** (Children''s Hepatic tumors International Collaboration — CHIC, COG, SIOPEL):  - **Risk stratification**: low/intermediate/high based on PRETEXT, AFP, annotation factors, histology; - **Chemotherapy backbone**: cisplatin-based (cis-PLADO — cisplatin + doxorubicin pyrimidine; or C5VD — cisplatin alone vs combinations); - **Surgical resection** (partial hepatectomy) or **liver transplant** for unresectable; - Sequence: chemo → assessment → surgery → adjuvant chemo; - **Outcomes**: > 80% cure overall; pure fetal histology + low-stage > 95%; high-risk + SCU worse; (8) **Lung metastases — resectable** improves outcomes; (9) **Long-term**: cisplatin ototoxicity (consider sodium thiosulfate — SIOPEL — protects hearing); cardiotoxicity (doxorubicin); growth + endocrine; secondary malignancy; - **Multidisciplinary**: pediatric onc + pediatric surgery + hepatology + RT (limited) + path + radiology + genetics (BWS, FAP) + audiology + cardiology + transplant + survivorship; (10) **Genetic counseling** when appropriate

---

Hepatoblastoma: pediatric; BWS + FAP associations. Histology fetal (best) → mixed → SCU (aggressive). AFP markedly elevated + monitoring. PRETEXT staging. CHIC risk strat. Cisplatin-based chemo + surgery/transplant. Sodium thiosulfate (SIOPEL) protects hearing from cisplatin. > 80% cure overall.', NULL,
  'medium', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'peds',
  'CHIC Hepatoblastoma; COG; SIOPEL', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยเด็กอายุ 2 ปี — abdominal mass + AFP very high (200000); biopsy: tumor cells with hepatocyte differentiation + fetal/embryonal pattern + small cell undifferentiated; การวินิจฉัย'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident — fundamentals of cytogenetics: karyotyping + FISH + chromosomal microarray (CMA, SNP/CGH) + applications in pathology', '[{"label":"A","text":"Skip"},{"label":"B","text":"Cytogenetics in Diagnostic Pathology"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cytogenetics in Diagnostic Pathology: (1) **Traditional G-banded karyotyping**: - Metaphase chromosomes stained with Giemsa → bands; - Detects numerical abnormalities (aneuploidy, polyploidy) + large structural (translocations, deletions, duplications, inversions); - **Limitations**: requires cell division (cell culture) → fresh cells, slow (days), low resolution (~ 5-10 Mb), labor-intensive; - **Applications**: hematologic malignancies (AML, ALL, CML, MDS — risk stratification + ELN), constitutional (prenatal, congenital syndromes — Down, Edwards), solid tumors (selected sarcomas); (2) **FISH (described elsewhere)**: targeted, faster, FFPE-compatible, single-cell resolution; (3) **Chromosomal microarray (CMA — array CGH or SNP array)**: - **High-resolution genome-wide copy number variation (CNV) detection** — ~ 50-100 kb resolution typically (much higher than karyotype); - **SNP arrays additionally detect loss of heterozygosity (LOH) + uniparental disomy (UPD)** + region of homozygosity (consanguinity, imprinting disorders); - **Doesn''t detect balanced translocations** (no copy number change); - **Doesn''t detect low-level mosaicism** below threshold; - **Applications**: - **Constitutional**: developmental delay, intellectual disability, congenital anomalies, autism — first-tier test (per ACMG); replaced karyotype for these indications; - **Prenatal**: replacing karyotype for diagnostic indications (cell-free DNA screening separate); - **Tumor**: solid tumor characterization + CNV detection; - **Lymphoma/leukemia**: complementary; (4) **Optical genome mapping (OGM) — emerging**: - Long single DNA molecules tagged + imaged in nanochannels; - Detects structural variants (balanced + unbalanced) + CNVs + copy-neutral LOH; - Single platform may replace karyotype + CMA + FISH in some contexts; - Faster than karyotype, higher resolution than CMA + FISH; - Increasing clinical adoption; (5) **NGS-based cytogenomics**: - **WGS** detects structural variants + CNVs + sequence variants — comprehensive but expensive; - **WES + targeted panels** — less comprehensive for SV; - **Long-read sequencing (ONT, PacBio)** — improving SV detection; - **NGS-based MRD + minimal cytogenetics**; (6) **Choice depends on indication**: - Hematologic malignancy diagnosis — karyotype + FISH + NGS panels (gradually integrating); - Constitutional — CMA first-tier; - Sarcoma — targeted FISH/RT-PCR for fusion (Ewing, synovial), CMA selected; - Solid tumor — NGS + selected FISH for actionable; (7) **Reporting (ISCN — International System for Human Cytogenomic Nomenclature)**: standardized nomenclature; cytogeneticists involved; (8) **Quality**: cytogenetics labs ACMG/CAP accredited; proficiency testing essential; (9) **Clinical impact**: - Hematologic malignancy risk stratification (e.g., AML ELN, ALL, CML, MM, MDS-R/IPSS-M); - Constitutional diagnosis impact; - Tumor diagnosis (sarcomas) — fusion-defined entities; - Precision medicine; (10) **Future**: optical genome mapping increasingly + long-read NGS replacing traditional methods; AI-assisted analysis

---

Cytogenetics: karyotype (low-res, needs cell division), FISH (targeted, FFPE), CMA (high-res CNV + LOH; first-tier for constitutional, doesn''t detect balanced SV), optical genome mapping (emerging — comprehensive SV), NGS-based. Hematologic malignancy uses karyo + FISH + NGS; constitutional uses CMA. Choice depends on indication. ISCN nomenclature.', NULL,
  'medium', 'molecular_pathology', 'review',
  'pathology', 'basic_science', 'molecular_pathology', 'mixed',
  'ACMG; ISCN; CAP Cytogenetics', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Resident — fundamentals of cytogenetics: karyotyping + FISH + chromosomal microarray (CMA, SNP/CGH) + applications in pathology'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident question — fundamentals of pathology peer review + intraoperative consultation + second opinion + diagnostic discrepancy review + lessons learned framework', '[{"label":"A","text":"Random"},{"label":"B","text":"Pathology Peer Review + Discrepancy Framework"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pathology Peer Review + Discrepancy Framework: (1) **Types of peer review (CAP all common, ADASP)**: - **Intra-departmental review**: cases reviewed by other pathologists within department — for complexity, difficulty, or routinely (e.g., random cases); - **Inter-departmental / outside institution review**: second opinion from referral center for complex cases (sarcoma, lymphoma, rare/unusual diagnoses) — often required for treatment selection; - **Concurrent review**: prior to final report on selected cases; - **Retrospective review**: after sign-out for QA + discrepancy identification; - **External proficiency testing**: CAP, AAFP — required external assessment; (2) **CAP requirements**: - Random or focused peer review of cases (e.g., 10% selected, or all malignancies, complex categories); - Documentation + tracking; - Discrepancy management process; - Education + improvement focus; (3) **Indications for second opinion / referral**: - Rare or unusual diagnoses; - Discordance with clinical presentation; - Treatment-altering decisions (e.g., sarcoma subtype affecting chemo); - Complex molecular cases; - Pre-treatment confirmation of cancer; - Patient request; (4) **Discrepancy types**: - **Major** — affects diagnosis category + treatment decision (e.g., benign vs malignant, type change affecting Tx); - **Minor** — minor classification differences, terminology, grading without Tx impact; - **No discrepancy**; (5) **Tracking discrepancies**: - **Time-out / amended reports** for changes after sign-out; - **Communication to clinical team** for changes affecting care; - **Documentation** in pathology system; - **Trends + monitoring** — by pathologist, organ, type — identifying systemic issues; (6) **Frozen section concordance (CAP)**: - Concordance with permanent section ≥ 97% target; - Discordance investigations + RCA; (7) **Outside slide review process**: - Comparison with original report; - Documentation of agreement/disagreement; - Communication with referring institution + treating clinician; - Educational opportunity; (8) **Intraoperative consultation**: described elsewhere — communication critical + concordance tracked; (9) **Second opinions for patients**: - **Required by treatment guidelines** for some (sarcoma, certain lymphomas — central pathology review for trials); - Common in cancers prior to definitive surgery — patients often seek; - Streamlined process with consent + slides shipped + records; (10) **Patient advocacy**: many cancer centers + organizations recommend always getting second opinion for cancer pathology; (11) **Educational + safety aspects**: - Routine + structured peer review identifies systemic issues + supports continuous learning; - Just-culture approach — non-punitive for genuine difficult cases + errors; - Reward identification + correction; - Pathologist competence + continuous improvement; (12) **Outcomes-based feedback**: clinical-pathologic correlation in tumor boards + M&Ms; (13) **Difficult case rotation + consultation networks**: regional + national + international expert networks (e.g., USCAP, IAP, specialty societies); (14) **Equity considerations**: rural + LMIC less access to second opinion — telepathology + global partnerships emerging

---

Pathology peer review: intra-/inter-dept, concurrent, retrospective + external PT. CAP requires. Discrepancies — major (Tx impact) vs minor. Frozen section ≥97% concordance. Indications for 2nd opinion: rare/discordant/Tx-altering. Educational + safety + just culture. Telepathology extending access.', NULL,
  'medium', 'quality_safety', 'review',
  'pathology', 'ems_mgmt', 'quality_safety', 'mixed',
  'CAP All Common; ADASP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Resident question — fundamentals of pathology peer review + intraoperative consultation + second opinion + diagnostic discrepancy review + lessons learned framework'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Lab implementing AI for pathology (Paige Prostate + similar) — clinical workflow + validation + ethical + regulatory + workforce + cost-benefit + equity considerations', '[{"label":"A","text":"Random"},{"label":"B","text":"Implementing AI in Pathology Practice"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Implementing AI in Pathology Practice: (1) **Use cases — FDA-cleared (early adoption)**: - **Paige Prostate** — algorithm flags suspicious foci in prostate biopsies (FDA 2021 — first AI for primary pathology dx); - **Quantitative IHC**: PD-L1, Ki-67, ER/PR, HER2; - **Mitotic count** in tumors; - **Image quality** + slide-level checks; - **Education + reference**; - **Many more in pipeline**: cervical cancer cytology, breast cancer detection + grading, melanoma, dermpath, hematopathology; (2) **Implementation workflow**: - **Validation in your lab + population**: - **CAP guidelines for WSI + AI validation** — minimum 60 cases per intended use; - Performance on diverse + representative cases; - **Lab-specific validation** required (scanner + workflow); - Different from manufacturer''s clinical validation; - **Workflow integration**: - **Pre-screening** — AI runs first, flags positive/concerning cases for pathologist focus; - **Augmented review** — AI overlay on pathologist viewing; - **Quality assurance** — second read with AI; - **Quantitative output** — for biomarkers; - **LIS/scanner integration**: barcoded slides → scanner → AI engine → report integration; - **Pathologist training**: AI strengths + limitations + when to override; - **Documentation**: AI-assisted dx vs AI-only; (3) **Regulatory considerations**: - **FDA** clearance/approval — class II/III; - **CE mark** EU; **NMPA** China; **MFDS** Korea; - **CLIA** for LDT-implemented AI; - **HIPAA** + privacy for data; (4) **Ethical considerations**: - **Bias** — algorithms trained on limited demographics may underperform in different populations; need equity-focused validation; - **Black-box AI** — interpretability + explainability concerns + liability; - **Patient consent + transparency** — should patients know AI was used?; - **Liability** — pathologist responsibility + manufacturer + institution; - **Data ownership** — patient + institutional + commercial; - **Continuous learning** — model updates + regulatory framework + validation requirements; (5) **Workforce + workflow**: - **Augmented intelligence** — AI assists pathologist, doesn''t replace; - **Workflow optimization** — pathologists focus on complex cases + AI handles routine screening; - **Productivity gains** in some contexts (e.g., negative case screening) — efficiency; - **Resident + fellow training** — adapted curricula including digital + AI; - **Continuous learning** for practicing pathologists; (6) **Cost-benefit**: - **Hardware + software costs** (scanners, AI platforms, IT); - **Subscription vs licensing models**; - **ROI from improved accuracy, reduced workload for routine cases, missed cancer reduction, efficiency**; - **Smaller labs + LMIC** — barriers but potential equity benefit via remote AI services; (7) **Equity considerations**: - **Diverse training data** — ensure model performance across populations (race, ethnicity, geography); - **Access** — high-cost technology — risk of widening disparities; - **Solutions**: open-source + collaborative models, public-private partnerships, federated learning preserving privacy; (8) **Continuous monitoring + governance**: - AI performance monitoring post-implementation; - Reporting issues + drift over time; - **AI governance committee** at institutional level; - Periodic re-validation; (9) **Future directions**: - **Multi-modal AI** combining pathology + molecular + imaging + clinical; - **Foundation models** general-purpose pathology AI; - **Real-time decision support during sign-out**; - **Triage** + workflow optimization; - **Discovery** — new biomarkers + signatures + prognosis prediction; - **Drug development**

---

AI implementation: validate locally (CAP ≥60 cases) + diverse populations; workflow integration (pre-screen, augmented, QA). Regulatory (FDA, CE, CLIA). Ethics: bias, explainability, liability, transparency. Augmented intelligence (not replacement). Equity + cost barriers; foundation models + federated learning emerging. Governance + monitoring + continuous validation.', NULL,
  'hard', 'quality_safety', 'review',
  'pathology', 'ems_mgmt', 'quality_safety', 'mixed',
  'FDA AI/ML Action Plan; CAP WSI/AI Validation', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Lab implementing AI for pathology (Paige Prostate + similar) — clinical workflow + validation + ethical + regulatory + workforce + cost-benefit + equity considerations'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Lab manager — environmental sustainability + green lab practices + waste reduction + energy efficiency + supply chain sustainability + ESG (environmental, social, governance)', '[{"label":"A","text":"Random"},{"label":"B","text":"Environmental Sustainability in Lab Practice"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Environmental Sustainability in Lab Practice: (1) **Healthcare is high carbon emitter** (~ 5% global emissions); labs contribute disproportionately — energy, water, plastics, chemicals; (2) **Major environmental impacts of lab practice**: - **Energy consumption**: 24/7 freezers (especially -80°C), HVAC, sterilization, equipment standby; - **Water use** (instrument cooling, washing); - **Plastic waste** (pipette tips, tubes, gloves, packaging); - **Hazardous chemicals** (xylene, formalin, alcohol, heavy metals, radioactive); - **Refrigerants** (ozone-depleting, HFCs); - **Single-use items** vs reusable; (3) **Green lab practices (My Green Lab certification + others)**: - **Energy**: - **Set freezers from -80°C to -70°C** — 30% energy savings, validated safety for many samples; - **Defrost regularly** + maintain seals; - **Power down** non-essential equipment overnight + weekends; - **LED lighting**; - **Energy-efficient equipment** + Energy Star ratings; - **Smart HVAC** + occupancy sensors; - **Heat recovery** systems; - **Fume hood management** (close sashes when not in use — major energy savings); - **Water**: - **Aspiration** vs continuous water-using condensers; - **Reduce wash cycles** + reuse rinse water; - **Recirculating water chillers**; - **Waste reduction**: - **Plastic reduction** — eliminate where possible (e.g., reusable glass tubes + autoclave); - **Recycling streams** — clean plastics, paper, cardboard, electronics; - **Vendor take-back** programs for packaging; - **Inventory management** — reduce expired waste; - **Reagent miniaturization** — smaller volumes when validated; - **Optimize batch testing** + run frequency; - **Chemical management**: - **Substitution** — less toxic alternatives (xylene-free clearing agents, less mercury, lead-free); - **Inventory + sharing networks**; - **Microscale chemistry** where applicable; - **Waste segregation** + proper disposal; - **Hazardous → universal waste programs**; - **Procurement**: - **Sustainable suppliers** + supply chain transparency; - **Local + regional** procurement reducing transport; - **Refurbished + recyclable** equipment; - **Life-cycle analysis** in vendor selection; - **Digital transformation**: - **Digital pathology** reducing slide transport + storage; - **Paperless workflows** + reports; - **Remote work** when possible reducing commuting; (4) **Metrics + tracking**: - **Carbon footprint** (Scope 1, 2, 3 emissions); - **Water + waste tracking**; - **Cost savings** from green initiatives — usually positive ROI; - **Sustainability reports + dashboards**; - **Engagement** of lab staff; (5) **Certifications + standards**: - **My Green Lab certification** (Green Lab Association, U.S.); - **LEED** building certification; - **ISO 14001** environmental management; - **The Green Health Initiative**; - Healthcare-specific (Practice Greenhealth); (6) **ESG (Environmental + Social + Governance)**: - Increasing investor + institutional + regulatory pressure; - Reporting requirements (TCFD, GRI); - Healthcare organization commitments to carbon neutrality; (7) **Co-benefits**: - **Cost reduction**; - **Patient + staff well-being**; - **Resilience** — supply chain + climate; - **Mission alignment** — ''do no harm'' includes environment; (8) **Climate change health impacts**: - Direct (heat, weather); - Vector-borne diseases (dengue, malaria — Thailand relevance); - Food security; - Mental health; - **Healthcare in climate change adaptation + mitigation**; (9) **Multidisciplinary + cross-institutional collaboration**: facilities + sustainability office + lab leaders + procurement + IT; (10) **Education + awareness**: emerging area in pathology + lab medicine training

---

Green labs: energy (-80→-70°C freezers, fume hood sash, smart HVAC), water reduction, plastic reduction + recycling, chemical substitution, sustainable procurement, digital transformation. My Green Lab certification + ISO 14001. ESG reporting. Climate change health impacts (vector-borne — Thailand relevance). Cost savings + co-benefits. Multidisciplinary.', NULL,
  'medium', 'quality_safety', 'review',
  'pathology', 'ems_mgmt', 'quality_safety', 'mixed',
  'My Green Lab; Practice Greenhealth; TCFD', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Lab manager — environmental sustainability + green lab practices + waste reduction + energy efficiency + supply chain sustainability + ESG (environmental, social, governance)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Integrative — climate change + planetary health + pathology — vector-borne disease emergence + heat-related deaths + Thailand context', '[{"label":"A","text":"Random"},{"label":"B","text":"Climate Change + Planetary Health — Pathology Perspective"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Climate Change + Planetary Health — Pathology Perspective: (1) **Planetary health framework**: human health intimately linked with Earth''s natural systems; climate change major threat to global health (Lancet); pathology + lab medicine has roles in surveillance, response, advocacy; (2) **Climate-related health impacts pathology contributes to understanding/diagnosing**: - **Vector-borne diseases — expanding range + intensity**: - **Dengue, Zika, Chikungunya** — Aedes mosquitoes — Thailand high burden + worsening + new areas; - **Malaria** — Plasmodium spp. — areas of resurgence; - **Leishmaniasis, schistosomiasis**; - **Lyme disease** — expanding ranges with warmer climates; - **Pathology — microscopy, NAAT, serology + epidemiologic surveillance**; - **Waterborne diseases**: cholera, cryptosporidium, typhoid (Salmonella typhi); - **Foodborne illness** — temperature-related spoilage + pathogen growth; - **Respiratory illness** — air pollution (PM2.5, ozone) + bushfire smoke + aerosolized pollutants → lung cancer + asthma + COPD; - **Heat-related illness + deaths** — heat stroke + cardiovascular + renal — postmortem assessment; - **Cardiovascular disease** worsened by heat + pollution; - **Mental health** impacts of climate-related disasters + uncertainty; - **Mass migration health** from climate displacement; - **Allergic disorders** — extended pollen seasons; - **Skin cancer** — UV exposure + ozone depletion (improving but still concern); - **Marine + foodborne toxins** — shellfish poisoning (HAB — harmful algal blooms); - **Food security + nutrition**; (3) **Thailand context** specifically: - **Dengue + chikungunya endemic** + recurrent outbreaks — pathology + lab essential for case management; - **Cholangiocarcinoma** (Opisthorchis viverrini-related) — climate + water quality factors; - **Melioidosis** (Burkholderia pseudomallei) — rainfall + soil — pathology + microbiology; - **Heat-related illness** in tropical climate worsening; - **Air pollution** — Bangkok + northern Thailand bushfire seasons; - **Maternal-child health** vulnerabilities; (4) **Pathology + lab medicine roles**: - **Surveillance** — detection + reporting of emerging pathogens (e.g., MERS, COVID demonstrated pathology importance); - **Diagnostic capacity** — particularly in vulnerable areas (LMIC) — strengthen lab networks; - **Reference laboratory + outbreak response**; - **Sentinel surveillance**; - **One Health approach** — human + animal + environmental health integrated — Coordinated emerging zoonosis detection; - **Climate-informed research** — disease emergence + transmission modeling + intervention evaluation; (5) **Mitigation in healthcare** (described — sustainability practices); (6) **Adaptation**: - Surveillance + early warning systems; - Vaccine campaigns; - Vector control + community engagement; - Resilient health systems; - Workforce training on emerging diseases; - **Health equity** central — most vulnerable disproportionately affected; (7) **Advocacy + policy**: pathology professional societies engaging in climate-health policy; (8) **Education**: planetary health in medical + pathology curricula emerging — comprehensive training for future practice; (9) **Research priorities**: vector-borne disease modeling, lab capacity, equity in adaptation, mitigation in healthcare delivery, novel diagnostics for emerging pathogens; (10) **Multidisciplinary + cross-sector**: pathology + public health + clinical + epidemiology + environmental sciences + policy + community

---

Planetary health + climate: vector-borne (dengue/Zika/chik/malaria — Thailand high burden), waterborne, respiratory (PM2.5), heat-related, food security. Thailand specific: dengue, cholangiocarcinoma (O. viverrini), melioidosis, air pollution. Pathology roles: surveillance, dx capacity, One Health, climate research. Equity central + advocacy.', NULL,
  'medium', 'microbiology', 'review',
  'pathology', 'integrative', 'microbiology', 'mixed',
  'Lancet Countdown; WHO Climate Health; One Health', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Integrative — climate change + planetary health + pathology — vector-borne disease emergence + heat-related deaths + Thailand context'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident — fundamentals of TEG (thromboelastography) + ROTEM (rotational thromboelastometry) — viscoelastic global hemostasis tests + applications in trauma, surgery, liver disease, ICU', '[{"label":"A","text":"Skip"},{"label":"B","text":"Viscoelastic Hemostasis Testing (TEG + ROTEM)"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Viscoelastic Hemostasis Testing (TEG + ROTEM): (1) **Concept**: assesses **global hemostasis** in whole blood — clot formation + dynamics + strength + fibrinolysis — in real-time, near patient; complements conventional coag tests (PT/PTT/fibrinogen/platelet count); (2) **Tracing parameters**: - **TEG**: - **R-time**: reaction time to initial clot — coagulation factors (cf. PT/PTT); prolonged → coagulation factor deficiency or anticoagulant; - **K-time (alpha)**: time to amplitude 20 mm — fibrinogen + platelet function; - **Maximum amplitude (MA)**: maximum clot strength — platelets + fibrinogen; - **LY30**: lysis at 30 min after MA — fibrinolysis; - **ROTEM (parallel system)**: - CT (clotting time) — analogous R; - CFT (clot formation time) — analogous K; - **α-angle**; - **MCF (maximum clot firmness)** — analogous MA; - **LI (lysis index)**; - Tests: EXTEM (extrinsic), INTEM (intrinsic), FIBTEM (cytochalasin D blocks platelets — isolates fibrinogen contribution), APTEM (aprotinin blocks fibrinolysis), HEPTEM (heparinase removes heparin effect); (3) **Applications**: - **Trauma + massive hemorrhage**: guides blood product use; reduces over-transfusion; - **Cardiac surgery / bypass**: post-pump bleeding diagnosis (factor deficiency vs platelet dysfunction vs fibrinogen vs fibrinolysis vs heparin residual); - **Liver transplantation**: monitor coagulation during procedure; baseline coagulopathy with rebalanced thrombin generation; - **Obstetric hemorrhage**; - **Critical illness / sepsis** — hyper- vs hypocoagulable; - **DIC** — recognize hyperfibrinolysis; - **Anticoagulant assessment** — DOACs + heparin presence; - **Hypercoagulability** — assess thrombotic risk; (4) **Advantages over conventional coag**: - **Whole blood + intact clot function** — captures platelet-fibrin interaction missing in PT/PTT; - **Faster** — results in 10-30 min vs longer turnaround for conventional + sequential; - **Dynamic + real-time during procedures**; - **Lower cost** of unnecessary blood products + improved outcomes; (5) **Algorithms**: many institutions have viscoelastic-guided transfusion protocols — fibrinogen concentrate if FIBTEM/MA low, platelets if MA low, FFP if R/CT prolonged, antifibrinolytics (TXA) if hyperfibrinolysis; (6) **Limitations**: - **Doesn''t replace conventional tests for all uses** (e.g., specific factor deficiencies, lupus anticoagulant); - **Equipment + training required**; - **Standardization across centers + technologies** still evolving; - **Acutely intoxicated trauma + temperature-corrected** considerations; (7) **Clinical evidence**: - **Trauma + cardiac surgery — multiple trials** showing reduced blood product use + improved outcomes with viscoelastic-guided approach; - **Recommended in major bleeding/trauma guidelines** (European Guideline on Management of Major Bleeding 2023, NICE, others); (8) **Quality**: validation, QC, training, interpretation by trained clinicians + lab staff; (9) **Multidisciplinary application**: anesthesia + surgery + ICU + hematology + transfusion + lab + pharmacy

---

TEG/ROTEM: viscoelastic whole-blood hemostasis. Parameters — R/CT (factors), K/CFT + α (fibrinogen/platelets), MA/MCF (clot strength), LY30/LI (lysis). FIBTEM isolates fibrinogen. Applications: trauma, cardiac surgery, liver tx, OB hemorrhage, ICU, DIC. Faster + functional + reduces blood product overuse. Guideline-recommended for major bleeding.', NULL,
  'medium', 'coagulation', 'review',
  'pathology', 'basic_science', 'coagulation', 'mixed',
  'European Guideline Major Bleeding 2023; ISTH', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Resident — fundamentals of TEG (thromboelastography) + ROTEM (rotational thromboelastometry) — viscoelastic global hemostasis tests + applications in trauma, surgery, liver disease, ICU'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Lab — implementing patient blood management (PBM) program — preoperative anemia + intraoperative blood conservation + restrictive transfusion + multidisciplinary integration', '[{"label":"A","text":"Random"},{"label":"B","text":"Patient Blood Management (PBM)"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Patient Blood Management (PBM): (1) **WHO definition**: ''a patient-centered, evidence-based + systematic approach to optimize the management of patients + transfusion of blood products for quality + effective patient care'' — three pillars: (2) **Three pillars of PBM**: - **Pillar 1: Optimize erythropoiesis** (treat anemia, support red cell mass): - **Pre-operative anemia diagnosis + treatment**: address iron deficiency (oral or IV iron), B12, folate, EPO if appropriate (CKD, refractory); - Treat anemia of chronic disease + inflammation; - Plan elective surgery to allow time for correction; - **Pillar 2: Minimize bleeding + blood loss**: - **Surgical techniques** — meticulous hemostasis, less invasive approaches when feasible, electrocautery, energy devices; - **Topical hemostatics**, fibrin sealants; - **Antifibrinolytics** — TXA for surgery + trauma + OB; - **Anticoagulant + antiplatelet management** pre-operatively — careful peri-operative bridging; - **Acute normovolemic hemodilution** — pre-op autologous blood removal + replacement post-bleed; - **Cell salvage** — collect + reinfuse intra-op blood loss; - **Hypotensive anesthesia** in selected; - **Minimally invasive surgery**; - **Identify + treat coagulopathy proactively** — viscoelastic testing; - **Pillar 3: Harness + optimize patient-specific physiologic tolerance**: - **Restrictive transfusion strategy** — Hb threshold 7 g/dL for stable hospitalized, 8 g/dL for cardiac/orthopedic — based on TRICC, FOCUS, TRISS, MINT (cardiac), TRACS, others; - **Single-unit transfusions** then reassess (avoid 2-unit reflex); - **Optimize cardiac output + oxygen delivery**; - **Patient + family education**; (3) **Implementation framework**: - **Multidisciplinary committee**: anesthesia + surgery + medicine + nursing + hematology + transfusion medicine + nephrology + critical care + nutrition + pharmacy + lab + administration; - **Protocols + standardized order sets**; - **Electronic decision support** in CPOE; - **Audit + feedback**: monitor transfusion practices + outcomes; (4) **Evidence**: - Reduces transfusion exposure 20-50%; - Reduces healthcare-associated infections; - Reduces complications; - Reduces costs; - Improves patient outcomes; - **WHO Resolution 63.12** supports PBM globally; (5) **Specific populations**: - **Cardiac surgery** — significant transfusion use historically; PBM bundles reduce; - **Obstetric**: hemorrhage management protocols + TXA + cell salvage selectively; - **Pediatric**: weight-based + careful management; - **Oncology**: anemia management + selective transfusion; - **Religious/cultural considerations**: bloodless surgery for Jehovah''s Witnesses + others — advanced PBM techniques + iron + EPO + cell salvage + alternative oxygen carriers; (6) **Pre-operative anemia program**: - Screen 4-6 wk before elective surgery; - Treat reversible causes; - Optimize Hb to reduce transfusion likelihood; - Cost-effective; (7) **Outcomes monitoring**: - Transfusion rates per procedure; - Hb thresholds met; - Adverse events; - Mortality; - Length of stay; - Costs; (8) **Equity considerations**: blood supply scarcity especially LMIC — PBM critical for sustainable transfusion practice; (9) **Cultural + religious sensitivity**: provide PBM-based bloodless options when desired

---

PBM 3 pillars: optimize erythropoiesis (preop anemia Tx — iron/EPO), minimize blood loss (TXA, cell salvage, ANH, surgical technique, viscoelastic-guided), harness physiologic tolerance (restrictive Hb 7-8 + single-unit). WHO endorsed. Reduces transfusion 20-50% + costs + adverse events. Multidisciplinary + protocols + audit. Cultural sensitivity.', NULL,
  'medium', 'transfusion', 'review',
  'pathology', 'ems_mgmt', 'transfusion', 'mixed',
  'WHO PBM; SABM; AABB', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Lab — implementing patient blood management (PBM) program — preoperative anemia + intraoperative blood conservation + restrictive transfusion + multidisciplinary integration'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 70 ปี — Paget disease bone — biopsy: disorganized lamellae + mosaic pattern + numerous osteoclasts + woven + lamellar bone; serum ALP markedly elevated + normal Ca; การวินิจฉัยและการรักษา + risk of malignant transformation', '[{"label":"A","text":"Osteoporosis"},{"label":"B","text":"Paget Disease of Bone"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Paget Disease of Bone: (1) **Pathophysiology**: focal disorder of accelerated bone turnover — increased osteoclast activity → resorption → reactive osteoblast activity → chaotic disorganized ''mosaic'' bone deposition; (2) **Epidemiology**: elderly (> 55 yr); UK + Australia + NZ + US higher; genetic (SQSTM1 mutations ~ 30-50%) + possible environmental (paramyxovirus debated); (3) **Sites**: pelvis, lumbar + thoracic spine, skull, femur, tibia — bone deformation + pain + fractures; (4) **Clinical**: - **Most asymptomatic** — found incidentally; - **Bone pain** + deformity (bowed tibia, skull enlargement, spinal kyphosis); - **Pathologic fractures**; - **Neurologic compression** (skull → cranial nerve, spinal → cord/root); - **Hearing loss** (skull involvement, CN VIII); - **High-output cardiac failure** in severe widespread (rare modern); - **Osteoarthritis** of adjacent joints; (5) **Histology** (mainly pelvic, skull, long bone biopsy): - **Mosaic pattern of cement lines** — irregular lamellar bone with interlocking cement lines reflecting cycle of resorption + formation; - **Numerous osteoclasts** + osteoblasts; - **Fibrous marrow** + increased vascularity; - **Woven + lamellar bone** mixed; - **Phases**: lytic (osteoclast predominance) → mixed → sclerotic (osteoblast); (6) **Workup**: - **Serum alkaline phosphatase (ALP) markedly elevated** — bone-specific most sensitive marker for Paget activity; - **Normal Ca + P** typically (vs hyperparathyroidism, osteomalacia); - **Imaging**: X-ray — characteristic features (lytic ''flame'' or sclerotic, cortical thickening, bone expansion, blade-of-grass appearance long bones); bone scan shows hot uptake (more sensitive than X-ray); MRI for complications; - **Skeletal survey** when diagnosed; - **Liver/biliary workup** if ALP unexplained (rule out non-bone source) — GGT distinguishes; (7) **Treatment** (Endocrine Society 2014 + AACE 2018 guidelines): - **Indications**: symptoms (pain), planned surgery on Paget bone, biochemical surveillance to prevent complications, hypercalcemia, neurologic complications, vertebral deformity, before extraction Pagetic bone; - **Bisphosphonates**: - **Zoledronic acid 5 mg IV once** — most effective + durable response (years); preferred; - **Risedronate, alendronate** PO alternatives; - Adequate Ca + vit D essential; - **Monitor ALP** trends + symptoms; (8) **Complications**: - **Osteoarthritis** of adjacent joints (hip, knee); - **Pathologic fractures**; - **Heart failure** in widespread (high-output); - **Hearing loss** + cranial nerve compression; - **Spinal stenosis**; - **Hypercalcemia** with immobilization; - **MALIGNANT TRANSFORMATION** — to osteosarcoma (1-5%) — sudden pain + lytic lesion in known Paget bone + ALP further rise — biopsy + aggressive treatment (chemo + surgery typically high-grade); incomplete prognosis; - **Other tumors**: giant cell tumor + fibrosarcoma; (9) **Multidisciplinary**: endocrinology + orthopedics (hip/knee arthroplasty considerations) + neurology + audiology + pain + ortho onc + path

---

Paget disease bone: increased turnover with mosaic cement lines + osteoclast prominence. ALP markedly ↑ with normal Ca/P. Imaging: cortical thickening, bone expansion, lytic-sclerotic. SQSTM1 mutations ~30-50%. Tx zoledronic acid IV once if indicated (pain, surgery, complications). Malignant transformation 1-5% (osteosarcoma, GCT) — sudden pain warning.', NULL,
  'medium', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'Endocrine Society Paget 2014; AACE 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 70 ปี — Paget disease bone — biopsy: disorganized lamellae + mosaic pattern + numerous osteoclasts + woven + lamellar bone; serum ALP markedly elevated + normal Ca; การวินิจฉัยและการรักษา + risk of malignant transformation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 25 ปี — anaplastic large cell lymphoma → biopsy lymph node: large pleomorphic cells + ''hallmark cells'' with horseshoe nuclei; IHC: CD30+, ALK+, CD3+, CD2+, CD43+, EMA+; การวินิจฉัย และการรักษา', '[{"label":"A","text":"Hodgkin"},{"label":"B","text":"Anaplastic Large Cell Lymphoma (ALCL) Subtypes (WHO HAEM5)"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Anaplastic Large Cell Lymphoma (ALCL) Subtypes (WHO HAEM5): (1) **Categories**: - **Systemic ALK-positive ALCL** — younger (< 30), better prognosis; ALK gene rearrangements (most commonly t(2;5) NPM-ALK; others — TPM3, TPM4, ATIC, ALO17, CLTC); - **Systemic ALK-negative ALCL** — older, more variable prognosis; subset has **DUSP22 rearrangement** (better — similar to ALK+) or **TP63 rearrangement** (worse); - **Primary cutaneous ALCL (pcALCL)** — distinct entity within primary cutaneous CD30+ LPDs; ALK typically negative; indolent — usually local treatment + observation; - **Breast implant-associated ALCL (BIA-ALCL)** — distinct WHO entity — implant-associated; surgery + capsulectomy curative early; awareness essential — historically associated with textured implants; (2) **Histology**: - Large pleomorphic cells, abundant cytoplasm, multinucleated forms; - **''Hallmark cells''** — eccentric reniform/horseshoe-shaped nuclei + perinuclear eosinophilic Golgi region — diagnostic but found in all subtypes (not only ALK+); - Cohesive nests + sinusoidal involvement; - Morphologic patterns: common type (most), lymphohistiocytic, small cell variant, Hodgkin-like, neutrophil-rich, signet-ring; (3) **IHC**: - **CD30+ strong + diffuse** (membranous + Golgi) — defining feature of all ALCL; - **ALK+** (cytoplasmic if NPM-ALK fusion at t(2;5); nuclear or cytoplasmic depending on partner) in ALK+ ALCL; - **CD3 variable, CD2+, CD4+, CD5 often lost**; T-cell receptor rearrangements; - **EMA+, CD43+**; - **Cytotoxic markers** (granzyme B, TIA-1, perforin) variable; - **Pan-T markers loss** often (aberrant); (4) **Differential**: - **Classical Hodgkin Lymphoma** — RS cells, CD15+ (vs ALCL CD15-), CD30+ both, EMA negative in CHL (vs ALCL EMA+), B-cell origin CHL with PAX5 dim+; - **DLBCL with CD30** — B-cell markers + clonal Ig; - **Other T-cell lymphomas** with CD30 expression; (5) **Workup**: PET-CT staging + BM + CSF if neuro symptoms; ALK IHC + FISH; molecular if needed (DUSP22, TP63 for ALK-negative risk stratification); (6) **Treatment**: - **ALK-positive + ALK-negative DUSP22-rearranged (good risk)**: CHOP-based chemo with high cure rates; emerging — replacing CHOP doxorubicin with brentuximab vedotin (CD30-targeted ADC); - **A+CHP (brentuximab vedotin + CHP without vincristine)** — front-line standard for systemic ALCL per ECHELON-2 trial — significantly improved survival vs CHOP; - **ALK+** highly responsive to **crizotinib + other ALK inhibitors** — used for relapsed disease; future trials moving to frontline; - **Auto-HCT** consolidation considered for high-risk; - **Primary cutaneous ALCL**: observation, local RT, methotrexate, surgery; brentuximab vedotin for multifocal/refractory; - **BIA-ALCL**: complete implant + capsule removal — curative if localized + early; chemo for disseminated; - **CNS prophylaxis** in high-risk; (7) **Relapsed/refractory**: brentuximab vedotin + chemo, crizotinib (ALK+), allo-HCT for selected, CAR-T trials; (8) **Multidisciplinary**: hematopathology + heme-onc + RT + transplant + breast surgery (BIA-ALCL); (9) **Prognosis**: ALK+ very good (> 70% 5-yr OS), ALK-neg variable (DUSP22 ~ 90%, TP63 ~ 17%), pcALCL excellent, BIA-ALCL early excellent

---

ALCL subtypes: systemic ALK+ (better), ALK- (DUSP22 better, TP63 worse), pcALCL (indolent), BIA-ALCL (implant — surgery curative early). CD30+ + hallmark cells + EMA+. NPM-ALK most common ALK+ fusion. A+CHP (brentuximab + CHP) frontline (ECHELON-2). ALK inhibitors for ALK+ relapsed. Variable prognosis by subtype.', NULL,
  'hard', 'hematopathology', 'review',
  'pathology', 'clinical_decision', 'hematopathology', 'adult',
  'WHO HAEM5 2022; ECHELON-2', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 25 ปี — anaplastic large cell lymphoma → biopsy lymph node: large pleomorphic cells + ''hallmark cells'' with horseshoe nuclei; IHC: CD30+, ALK+, CD3+, CD2+, CD43+, EMA+; การวินิจฉัย และการรักษา'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident — fundamentals of point-of-care testing devices + glucose meters + ABG analyzers + coagulation POC (INR + aPTT) + clinical performance vs central lab + QC', '[{"label":"A","text":"Skip"},{"label":"B","text":"Point-of-Care Testing (POCT) Devices"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Point-of-Care Testing (POCT) Devices: (1) **Glucose meters**: - **Capillary blood (finger stick) testing** — most common POCT; bedside + home; - **Technology**: glucose oxidase or glucose dehydrogenase strips → electrochemical or photometric; - **Performance vs central lab**: typically within 10-15% — adequate for diabetes management; less accurate at extremes (very low/high); - **Critical issues**: pre-analytic (hand washing — sugar contamination; alcohol pad residue; first-drop vs second-drop); finger stick accuracy variable; - **Hospital glucose meters** — different from home — quality controls + competency assessment + linked to LIS — **CAP/CLIA waived + moderate-complexity**; - **Continuous glucose monitoring (CGM)** — interstitial fluid sensor — Dexcom, Libre — now integrated into hospital care emerging; (2) **POC ABG/blood gas analyzers**: - **Bedside, near-real-time** results; - **Cartridge-based** (i-STAT, GEM) or portable benchtop (RAPIDLab); - **Parameters**: pH, pCO2, pO2, HCO3, lactate, electrolytes (Na, K, Cl, iCa, glucose, hemoglobin); - **Used in**: ICU, ED, OR, dialysis, NICU — critical for rapid clinical decisions; - **Quality**: rigorous QC + control materials + comparison with central lab; - **Issues**: pre-analytic (heparin dilution, air bubbles, delay → CO2 changes); (3) **POC coagulation**: - **INR meters** (CoaguChek, ProTime) — outpatient warfarin monitoring + anticoagulation clinics — reduce visit burden + improve adherence; - **Performance vs central lab**: generally good; INR up to ~ 4.5 reliable; high INR less accurate; - **ACT (activated clotting time)** — heparin monitoring during cardiac surgery, dialysis, ECMO, percutaneous procedures; - **POC PT/PTT** — less common; - **Specific limitations + validation in different populations**; (4) **Other common POCT**: - **Pregnancy** (hCG) qualitative urine; - **Urine dipsticks**; - **Rapid strep, influenza, RSV, SARS-CoV-2 antigen, HIV** + others — rapid antigen/antibody; - **CRP, BNP, troponin** — emergency department; - **Bilirubin** — neonates; - **Hgb/Hct** for blood loss assessment; - **Anesthesia + recovery** — selected; (5) **Performance considerations**: - **Different sample type** (whole blood, capillary, venous) — different reference intervals than serum-based central lab; - **Limited test menu vs central lab**; - **Less stringent statistical QC** compared to high-throughput central lab; - **Interfering substances** — hemolysis (less detection in POC), bilirubin, lipemia; (6) **Quality assurance for POCT** (described prior — CLIA-waived + moderate complexity rules apply): - Operator training + competency (CLIA 6 elements); - QC daily + per manufacturer; - Linearity + calibration verification; - Linked to LIS + EHR via middleware ideally; - Periodic comparison with central lab; - Proficiency testing; (7) **CLIA waived tests vs moderate-complexity**: - **Waived** (FDA grants): simple methods + clear results — less stringent oversight (glucose meter, rapid strep, pregnancy); - **Moderate complexity**: more oversight + personnel requirements + competency; - Same accuracy expectations regardless; (8) **Cost-effectiveness**: - Faster decisions + reduced LOS + faster Tx; - Higher per-test cost vs central; - **Reimbursement considerations**; (9) **Future**: - **Wearable + continuous monitoring** (CGM, smart watches with HR/SpO2, sleep apnea); - **Multiplex POCT** (combined cardiac, renal, infectious markers); - **AI + interpretation** + cloud connectivity; - **Personalized medicine via portable diagnostics**

---

POCT: glucose meters (within 10-15% central lab; finger stick issues), ABG (i-STAT — rapid critical care), INR meters (anticoag clinics), ACT (heparin monitoring), rapid Ag (strep/flu/COVID), troponin/BNP, bilirubin. QC + competency + linkage to LIS. CLIA waived vs mod-complexity. Wearable + AI + multiplex future.', NULL,
  'easy', 'clinical_chemistry', 'review',
  'pathology', 'basic_science', 'clinical_chemistry', 'mixed',
  'CLSI POCT; CAP POCT Checklist; CLIA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Resident — fundamentals of point-of-care testing devices + glucose meters + ABG analyzers + coagulation POC (INR + aPTT) + clinical performance vs central lab + QC'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Integrative — pathology + ethics + research — informed consent + tissue + data use + research participation + Tuskegee + Henrietta Lacks + modern frameworks', '[{"label":"A","text":"Random"},{"label":"B","text":"Research Ethics in Pathology"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Research Ethics in Pathology: (1) **Historical context — landmark events shaping modern ethics**: - **Tuskegee syphilis study (1932-1972)** — Black men with syphilis observed without informed consent + denied treatment; led to Belmont Report + 45 CFR 46 (Common Rule); - **Henrietta Lacks (1951)** — Black woman whose cervical cancer cells became HeLa cells — used widely in research without consent; family identified decades later; led to recognition of tissue + data use ethics + biobanking issues; - **Nuremberg Code (1947)** — post-WWII — informed consent foundational principle; - **Declaration of Helsinki** — international research ethics; - **Belmont Report (1979)** — three principles: respect for persons, beneficence, justice; (2) **Modern ethics framework**: - **Informed consent**: - **Capacity**: ability to understand + appreciate + reason; surrogate decision-makers when needed; - **Voluntariness**: free from coercion; - **Information**: purpose, procedure, risks, benefits, alternatives, confidentiality, who, voluntary, withdrawal; - **Understanding**: confirmed comprehension; - **Documentation**: written consent forms in patient''s language; verbal explanation + chance for questions; (3) **Tissue + data use specifically**: - **Diagnostic tissue** — for patient''s care; - **Research use of tissue** — requires specific consent (broad vs specific); - **De-identified vs identifiable** — different requirements; - **Biobanks** — long-term storage + future research — consent framework: broad consent + opt-out + dynamic consent; - **Reidentification risk** with genomic + clinical + image data; (4) **Common Rule (revised 2018)**: - **Broad consent** option for future research with identifiable biospecimens + private info; - **Single IRB** for multi-site studies; - **Exemptions** clarified — research with identifiable biospecimens explicit (vs prior); - **Continuing review** for some studies; (5) **HIPAA + privacy**: - **Authorization for research use** of PHI separate from clinical care use; - **Limited data set + data use agreement** alternative; - **De-identification standards** (safe harbor or statistical); - **Breach notification + penalties**; (6) **Equitable research participation**: - Historic underrepresentation of minorities, women, children, pregnant, elderly in clinical research; - **NIH-mandated inclusion** + reporting; - **Community-based participatory research** for community-engaged studies; - **Tribal sovereignty** in indigenous research; - **Just allocation of risks + benefits**; - **Decolonizing research** especially LMIC + indigenous; (7) **Genetics + genomics ethical issues**: - **Incidental findings** — actionable + uncertain — disclosure decisions; - **ACMG-recommended return of secondary findings** in clinical exome (currently 78+ genes); - **Family member implications** — cascade testing + privacy of others; - **Reproductive implications** + PGT; - **Insurance discrimination concerns** — GINA in US, similar laws elsewhere; - **Direct-to-consumer testing** considerations; (8) **AI + data ethics**: - **Bias in training data**; - **Black-box explainability**; - **Liability + accountability**; - **Consent for algorithmic decisions**; - **Data ownership + access**; (9) **Special populations**: - **Pediatric research** — assent + parental permission, age-appropriate; - **Pregnant women + fetuses** — additional protections + necessary inclusion; - **Vulnerable** — prisoners, cognitively impaired — additional safeguards; - **Cross-cultural + LMIC research** — ensure local oversight + local benefit; (10) **Multidisciplinary ethics committees + bioethicists** + community + patient advisors essential; (11) **Continuous education + reflection**: pathologists involved in research need ethics training + ongoing CME

---

Research ethics: Tuskegee + Henrietta Lacks shaped modern framework. Belmont Report — respect/beneficence/justice. Informed consent (capacity + voluntary + information + understanding + documented). Tissue/data use specific consent. Common Rule 2018 + HIPAA. Equitable participation + special populations. Genomics secondary findings + GINA. AI + ethics emerging. Multidisciplinary IRB + community.', NULL,
  'medium', 'quality_safety', 'review',
  'pathology', 'integrative', 'quality_safety', 'mixed',
  'Belmont Report; Common Rule 2018; ACMG SF', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Integrative — pathology + ethics + research — informed consent + tissue + data use + research participation + Tuskegee + Henrietta Lacks + modern frameworks'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี — adrenal incidentaloma 5 cm on CT — workup + differential + pathology + multidisciplinary integrative management', '[{"label":"A","text":"Random"},{"label":"B","text":"Adrenal Incidentaloma — Workup + Management"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Adrenal Incidentaloma — Workup + Management: (1) **Definition**: adrenal mass discovered incidentally on imaging done for other reasons; prevalence increases with age (~ 10% at age > 70); (2) **Two key questions**: - **Functional**: is the mass producing excess hormone? - **Malignant**: is the mass benign or malignant?; (3) **Differential diagnosis**: - **Non-functional adenoma** (most common, ~ 80%); - **Functional adenoma**: aldosterone (Conn), cortisol (subclinical or overt Cushing), pheochromocytoma; - **Adrenocortical carcinoma (ACC)** — rare but important; - **Pheochromocytoma**; - **Adrenal metastases** — lung, breast, melanoma, RCC, lymphoma; - **Myelolipoma** — fat + bone marrow elements (pathognomonic CT — fat density); - **Cysts, hemorrhage, infection** (TB, fungal, hydatid); - **Hyperplasia** (congenital adrenal hyperplasia, ACTH excess); (4) **Imaging characteristics** (CT/MRI): - **Lipid-rich adenoma** typical: < 4 cm, smooth borders, homogeneous, unenhanced HU < 10 (lipid content), absolute washout > 60% + relative washout > 40% on delayed CT; - **MRI**: signal drop on out-of-phase imaging (chemical shift) — adenoma; - **Adrenocortical carcinoma features**: > 4 cm typical, heterogeneous, irregular, enhanced HU > 10, calcifications, necrosis, local invasion, mets; - **Myelolipoma**: macroscopic fat (CT HU < -30); - **Pheochromocytoma**: > 10 HU unenhanced, avid enhancement, hyperintense T2 MRI ''light bulb''; - **Adrenal washout less reliable in pheochromocytoma — beware**; (5) **Functional workup (Endocrine Society + AACE guidelines)**: - **All incidentalomas**: - **1-mg overnight dexamethasone suppression test** — for subclinical/overt Cushing; - **Plasma free metanephrines** OR 24-h urine metanephrines — for pheochromocytoma (alpha-block + adrenalectomy if positive — NOT biopsy); - **Hypertensive or hypokalemic**: aldosterone-to-renin ratio for Conn; - **Virilizing/feminizing signs**: DHEAS + sex hormones (suggest ACC or rare); (6) **Pheochromocytoma — DO NOT biopsy** — risk of hypertensive crisis; (7) **Adrenocortical carcinoma — DO NOT biopsy** unless very specific need — risk of seeding; surgical resection + complete histopathology preferred; (8) **Indications for surgery (adrenalectomy)**: - **Functional**: pheochromocytoma, primary aldosteronism (if unilateral confirmed by AVS), Cushing syndrome from adrenal source, severe androgen excess; - **Mass features suspicious for malignancy**: > 4-6 cm depending on imaging features, heterogeneous, growth on surveillance, suspicious imaging characteristics, mets workup; - **Subclinical Cushing**: balance benefit/risk; surgery considered if symptoms/comorbidities, growing, or > 4 cm with cortisol abnormality; (9) **Imaging surveillance for non-functional, < 4 cm, lipid-rich adenoma**: - Repeat imaging at 6-12 mo + 1-2 yr typically — most labs/guidelines; - Stable + benign features → no further imaging long-term; (10) **Adrenocortical carcinoma management**: - **Surgical resection** with adequate margins; - **Mitotane** (lysodren — alkylating-like, adrenolytic) adjuvant + treatment; - **EDP (etoposide + doxorubicin + cisplatin)** chemo combined with mitotane for advanced; - **Targeted + IO** under study (FIRM-ACT, others); - **Multidisciplinary** essential; (11) **Pathology of ACC**: Weiss criteria + ENS@T modified (high nuclear grade, mitoses > 5/50 HPF, atypical mitoses, < 25% clear cells, diffuse architecture, necrosis, venous invasion, sinusoidal invasion, capsular invasion); IHC: SF1+, MelanA+, inhibin+, synaptophysin patchy+; loss of typical ''compact + clear cell'' adrenocortical morphology; (12) **Multidisciplinary**: endocrinology + endo surgery + medical oncology + radiology + pathology + path subspecialist for ACC + genetics (Li-Fraumeni, BWS associations)

---

Adrenal incidentaloma: question 1 — functional? (1-mg DST, metanephrines, ARR + selected) + question 2 — malignant? (size > 4cm + suspicious imaging). NEVER biopsy pheochromocytoma + ACC. Surgery for functional, large, suspicious. ACC: surgical resection + mitotane + EDP chemo. Weiss criteria + IHC (SF1/MelanA/inhibin+). Genetic associations.', NULL,
  'medium', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'Endocrine Society Adrenal 2016; ESE Guidelines; AACE', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี — adrenal incidentaloma 5 cm on CT — workup + differential + pathology + multidisciplinary integrative management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Integrative pathology + One Health — emerging infectious disease, antimicrobial resistance, zoonosis surveillance — multidisciplinary cross-sector framework + Thailand context', '[{"label":"A","text":"Random"},{"label":"B","text":"One Health Framework — Pathology Contribution"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** One Health Framework — Pathology Contribution: (1) **One Health definition**: collaborative + multisectoral + transdisciplinary approach recognizing the interconnection between human + animal + environmental health to achieve optimal health outcomes; WHO + FAO + WOAH + UNEP quadripartite; (2) **Key areas**: - **Zoonotic diseases** — > 60% emerging infections zoonotic — COVID-19, MERS, SARS, Ebola, avian + swine influenza, monkeypox/Mpox, Zika, Lyme, leptospirosis (Thailand relevance — rainy season), rabies, Q fever, salmonella; - **Antimicrobial resistance (AMR)** — agricultural + human + environmental drivers — coordinated response essential; - **Vector-borne diseases** — climate + land use + vector ecology — dengue, malaria, JE; - **Food safety + security**; - **Environmental health** — pollution, climate change, biodiversity loss; - **Comparative medicine** — animal models + diseases; (3) **Pathology + lab medicine contributions**: - **Diagnostic capacity** — human, animal, environmental sampling; - **Surveillance** — clinical labs + public health labs + veterinary labs networked; - **Reference labs** + outbreak response; - **Research** — pathogen characterization, host-pathogen, emerging signals; - **Capacity-building** in LMIC including diagnostic labs; - **Education** — incorporating One Health into medical + veterinary + public health curricula; (4) **AMR specifically**: - **WHO Global Action Plan on AMR (2015)** + national plans; - **Surveillance networks**: WHO GLASS (human), WOAH (animal), GLASS for AMR in food chain emerging; - **Stewardship** — human (described prior) + veterinary (reduce non-therapeutic antibiotic use in agriculture) + plant protection; - **Infection prevention + control**; - **Vaccination** + alternatives to antibiotics; - **Research + development** — new antibiotics + diagnostics + therapies; - **Sustainable financing**; (5) **Thailand One Health initiatives**: - **National Strategic Plan on AMR (2017-2022, 2023-2027)** — comprehensive multisectoral; - **Hub for One Health** in SE Asia + ASEAN initiatives; - **Specific zoonoses**: rabies (significant Thai burden + vaccination programs), leptospirosis (rainy season + agriculture), Salmonella, avian + swine influenza, JE; - **Cholangiocarcinoma + Opisthorchis** — One Health (parasite + fish + human + environmental) — endemic NE Thailand; - **Coronaviruses** — Mahidol University + others active surveillance; - **Antimicrobial use in Thailand** — both human + agriculture — stewardship; (6) **Pandemic preparedness lessons (COVID-19)**: - **Investment in lab capacity** + workforce + research; - **Diagnostic platforms** — flexible + scalable; - **Surveillance integration** — clinical, public health, environmental; - **Communication + transparency** + global cooperation; - **Equity in access** to diagnostics + vaccines + therapeutics; - **WHO Pandemic Treaty** + IHR revisions ongoing; (7) **Antimicrobial resistance — concerning trends**: - **CRE (carbapenem-resistant Enterobacterales)** — global spread + high mortality; - **MDR-TB + XDR-TB** — significant remaining challenge; - **Candida auris** — fungal — multidrug-resistant + healthcare-associated outbreaks; - **Drug-resistant gonorrhea** — last-line ceftriaxone resistance emerging; - **Drug-resistant malaria + artemisinin resistance** — Greater Mekong subregion (Thailand) initial epicenter; (8) **Cross-sector collaboration**: - Public health + clinical + veterinary + environmental + agricultural + research + policy + community; - **Multidisciplinary task forces** + ICCs; - **Data sharing** + interoperability; (9) **Workforce + training**: - One Health curricula in medical, veterinary, public health, and other sciences; - Cross-training opportunities; - Career pathways in One Health; (10) **Equity + global health**: - LMIC disproportionately affected by emerging infections + AMR; - Capacity-building + equitable access — essential ethical + practical; (11) **Modern context**: COVID-19 underscored interconnection + need for One Health; future preparedness investment essential

---

One Health: integrated human + animal + environmental health; > 60% emerging infections zoonotic. Pathology roles: diagnostic capacity, surveillance, reference, research, capacity-building. AMR: WHO GLASS, stewardship multi-sector, R&D. Thailand specific: NE Thai cholangio + Opisthorchis, leptospirosis, rabies, artemisinin resistance Mekong. COVID lessons reinforced need.', NULL,
  'medium', 'microbiology', 'review',
  'pathology', 'integrative', 'microbiology', 'mixed',
  'WHO/FAO/WOAH/UNEP One Health; Thai NSP-AMR', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Integrative pathology + One Health — emerging infectious disease, antimicrobial resistance, zoonosis surveillance — multidisciplinary cross-sector framework + Thailand context'
  );

commit;

