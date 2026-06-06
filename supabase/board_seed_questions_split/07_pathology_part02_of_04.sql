-- ===============================================================
-- หมอรู้ — Board seed: พยาธิวิทยา (pathology) — part 2/4 (50 MCQs)
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
  s.id, 'board', NULL, 'Resident pathology — ขอเข้าใจหลักการของ immunohistochemistry (IHC) — antigen retrieval + detection systems + controls + interpretation pitfalls', '[{"label":"A","text":"ไม่ต้อง control"},{"label":"B","text":"IHC Principles + Pitfalls"},{"label":"C","text":"Random Ab"},{"label":"D","text":"No retrieval"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** IHC Principles + Pitfalls: (1) **Concept**: antibody-based detection of specific antigens in tissue — primary Ab → secondary Ab/polymer with enzyme (HRP/AP) → chromogen (DAB brown, AEC red) → visualized in tissue context; (2) **Antigen retrieval** (essential for FFPE — formalin masks epitopes): - **Heat-induced epitope retrieval (HIER)**: most common, citrate buffer pH 6 OR EDTA-Tris pH 9 (high pH); pressure cooker / steamer / microwave; - **Enzymatic** (proteinase K, trypsin) for some antibodies (e.g., kappa/lambda); - Mismatched retrieval common cause of false-negative; (3) **Detection systems**: avidin-biotin (legacy), polymer-based (HRP-conjugated polymer — sensitive, no endogenous biotin issue), tyramide amplification (very sensitive); (4) **Controls (essential)**: - **Positive control**: tissue known to express antigen on same slide or batch — confirms procedure worked; - **Negative control**: tissue lacking antigen or omit primary Ab — confirms specificity; - **Internal control**: cells within patient tissue (e.g., normal duct for ER, blood vessels for vimentin) — best validation; - **Each run** must have controls + documented; (5) **Pitfalls** (interpretation): - **Fixation issues** → false-negative (over/under); - **Edge artifact** — tissue edge stains non-specifically; - **Necrosis** — non-specific staining; - **Endogenous peroxidase** (RBCs, granulocytes) — block; - **Endogenous biotin** (liver, kidney) — block; - **Tonsil/tumor heterogeneity**; - **Antibody cross-reactivity**; (6) **Quantification**: percentage + intensity (e.g., ER, PR, HER2 with H-score, Allred, TPS PD-L1); standardized scoring critical; (7) **Validation**: CLIA-validated against gold standard; CAP accreditation requirements

---

IHC: Ab-Ag detection in tissue. HIER (citrate pH6 / EDTA pH9) essential FFPE. Polymer detection sensitive. Controls (positive/negative/internal) every run. Pitfalls: fixation, edge, endogenous biotin/perox, heterogeneity. Quantification standardized (Allred/TPS).', NULL,
  'medium', 'molecular_pathology', 'review',
  'pathology', 'basic_science', 'molecular_pathology', 'mixed',
  'CAP IHC Guidelines; AJCP IHC', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Resident pathology — ขอเข้าใจหลักการของ immunohistochemistry (IHC) — antigen retrieval + detection systems + controls + interpretation pitfalls'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หลักการของ FISH (fluorescence in situ hybridization) ใน pathology — applications + interpretation + advantages vs limitations เมื่อเทียบกับ IHC และ NGS', '[{"label":"A","text":"FISH = same as IHC"},{"label":"B","text":"FISH Principles + Applications"},{"label":"C","text":"Same as NGS"},{"label":"D","text":"Useless"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** FISH Principles + Applications: (1) **Concept**: fluorescently labeled DNA probes hybridize to specific chromosomal regions in interphase cells (FFPE tissue) or metaphase (cytogenetics) — detects gene amplifications, deletions, translocations/fusions; (2) **Probe types**: - **Locus-specific** (e.g., HER2 amplification — HER2/CEP17 ratio); - **Centromeric** (chromosome enumeration); - **Break-apart** (rearrangement detection — e.g., ALK, ROS1, MYC, IGH — red/green flanking → separation = rearrangement); - **Dual fusion** (specific fusion partners, e.g., BCR-ABL); - **Whole chromosome painting** (metaphase); (3) **Major applications**: - **HER2 amplification** breast/gastric (ratio HER2/CEP17 ≥ 2.0 or HER2 copies ≥ 6.0); - **ALK, ROS1, RET, NTRK** rearrangements lung; - **MYC** translocations lymphoma (Burkitt, double-hit DLBCL); - **EWSR1** Ewing sarcoma, **SS18** synovial sarcoma; - **MDM2** amplification well-differentiated/dedifferentiated liposarcoma; - **1p/19q codeletion** oligodendroglioma; - **Urovysion** urine for urothelial; - **Prenatal/oncology cytogenetics**; (4) **Advantages**: single-cell resolution, works on FFPE, can detect subclones, visual + spatial; (5) **Limitations**: targeted (need to know what to look for), labor-intensive, requires fluorescence microscope, fading; (6) **vs IHC**: IHC = protein, FISH = DNA; complementary — IHC screen + FISH confirm (HER2 2+ → FISH); (7) **vs NGS**: NGS = sequence-level, more comprehensive, lower turnaround, can miss some fusions if intronic; (8) **Quality**: validated probes, signal counting standards (cells counted, scoring rules), inter-observer concordance

---

FISH: fluorescent DNA probes detect amplifications/deletions/translocations on FFPE. HER2/ALK/MYC/1p19q/MDM2/EWSR1 key applications. Break-apart for rearrangements. Single-cell + spatial. Complements IHC + NGS.', NULL,
  'medium', 'molecular_pathology', 'review',
  'pathology', 'basic_science', 'molecular_pathology', 'mixed',
  'CAP Molecular Pathology; AMP Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'หลักการของ FISH (fluorescence in situ hybridization) ใน pathology — applications + interpretation + advantages vs limitations เมื่อเทียบกับ IHC และ NGS'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หลักการของ next-generation sequencing (NGS) ใน clinical molecular pathology — workflow + applications + tumor + germline + variant interpretation + limitations', '[{"label":"A","text":"NGS = Sanger"},{"label":"B","text":"Clinical NGS Principles"},{"label":"C","text":"No QC"},{"label":"D","text":"Skip"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Clinical NGS Principles: (1) **Concept**: massively parallel sequencing — millions of short reads per run vs Sanger one read; (2) **Workflow**: DNA/RNA extraction → library preparation (fragmentation + adapter ligation + barcode) → enrichment (capture or amplicon) → sequencing on platform (Illumina short read, ONT/PacBio long read) → bioinformatics (alignment to reference, variant calling, annotation, filtering) → clinical interpretation + reporting; (3) **Panel types**: - **Targeted hotspot panels** (e.g., 50-gene cancer panel) — fast, deep coverage, limited scope; - **Comprehensive genomic profiling (CGP)** ~ 300-700+ genes — TMB, MSI, signatures (FoundationOne, MSK-IMPACT); - **Whole exome (WES)** — all coding ~ 1.5% genome; - **Whole genome (WGS)** — comprehensive but expensive; - **RNA seq** — fusions, expression, splicing (better fusion detection vs DNA); - **Liquid biopsy** (ctDNA) — non-invasive, monitoring, resistance — limited sensitivity early-stage; (4) **Applications**: - Solid tumor profiling (matched therapy + clinical trials); - Heme malignancies (myeloid + lymphoid panels — AML risk stratification, MDS, MPN); - Germline cancer predisposition (hereditary panels); - Inherited disease (WES diagnostic); - Microbiology (metagenomic); - Transplant; - Pharmacogenomics; (5) **Variant classification**: - **Somatic** (AMP/ASCO/CAP 2017 Tier I-IV — actionable, potential, unknown, benign); - **Germline** (ACMG 5-tier P/LP/VUS/LB/B); - VAF (variant allele frequency) interpretation — germline ~ 50% (het) / 100% (hom); somatic variable; (6) **QC**: depth (≥ 100x typical tumor), uniformity, coverage; validation; CLIA/CAP requirements; (7) **Limitations**: detection of large structural variants challenging (long-read helps); RNA needed for many fusions; tumor purity essential for VAF; turnaround time

---

NGS: massively parallel; library prep → seq → bioinfo → interpretation. Panels (hotspot/CGP/WES/WGS/RNA/ctDNA). Variant tiers — somatic (AMP/ASCO/CAP 2017) + germline (ACMG). Depth + tumor purity essential. RNA needed for fusion detection.', NULL,
  'hard', 'molecular_pathology', 'review',
  'pathology', 'basic_science', 'molecular_pathology', 'mixed',
  'AMP/ASCO/CAP 2017 Somatic Variant; ACMG/AMP 2015 Germline; CAP NGS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'หลักการของ next-generation sequencing (NGS) ใน clinical molecular pathology — workflow + applications + tumor + germline + variant interpretation + limitations'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Lab manager — มี breast biopsy specimen ที่ refrigerated และ formalin fixation เริ่มหลังจาก 3 ชม cold ischemia + ระยะ fixation เพียง 4 ชม ก่อนนำไป processing; ส่ง ER + HER2 — ปัญหา + management', '[{"label":"A","text":"Report ก็ได้"},{"label":"B","text":"Pre-analytical Specimen Handling Errors + Mitigation"},{"label":"C","text":"Discard silently"},{"label":"D","text":"Use anyway"},{"label":"E","text":"Refuse case"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pre-analytical Specimen Handling Errors + Mitigation: (1) **CAP/ASCO Guidelines for breast biomarkers (ER, PR, HER2)**: - **Cold ischemia time ≤ 1 hour** (time from removal to fixation); refrigeration acceptable short delay but documented; - **Fixation time 6-72 hours** in 10% NBF; - **Documented** on requisition + report (cold ischemia, fixation time); (2) **This case violates both**: 3-h cold ischemia + 4-h fixation → invalid for biomarker testing per guidelines; (3) **Consequences**: false-negative ER/PR (loss of antigenicity), false-negative HER2 IHC + invalid FISH, impacts treatment decisions (deny targeted therapy); (4) **Mitigation**: - Document deviation explicitly on report; - Note ''biomarker results may be unreliable due to pre-analytic deviation''; - Recommend repeat sampling if results affect management; - Consider testing surgical specimen if core invalid; - Discuss with treating clinician; (5) **Quality improvement (system level)**: - Specimen transport workflow with time stamps; - Education of OR + transport + lab; - Tracking software for cold ischemia + fixation timestamps; - Periodic audits + feedback; - Root cause analysis; - CAP accreditation requirements monitored; (6) **Other pre-analytical critical issues**: hemolysis (chemistry), clot in EDTA (CBC), wrong tube/anticoagulant, mislabeling (most common — ''never event'' if causes wrong patient treatment), inadequate volume; (7) **Two-identifier rule**: specimens labeled with ≥ 2 patient identifiers; (8) **Specimen rejection criteria** standardized + tracked; (9) **TJC + ISO 15189 + CAP**: pre-analytical phase 60-70% of lab errors — focus area

---

Breast biomarker preanalytics: cold ischemia ≤1h, fixation 6-72h. Deviation → unreliable ER/HER2. Mitigation: document, comment on report, possibly repeat. QI: workflow + tracking + RCA. Pre-analytic = 60-70% lab errors. Two-identifier rule.', NULL,
  'medium', 'quality_safety', 'review',
  'pathology', 'ems_mgmt', 'quality_safety', 'mixed',
  'ASCO/CAP Breast Biomarker; CAP Cancer Protocol; TJC NPSGs', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Lab manager — มี breast biopsy specimen ที่ refrigerated และ formalin fixation เริ่มหลังจาก 3 ชม cold ischemia + ระยะ fixation เพียง 4 ชม ก่อนนำไป processing; ส่ง ER + HER2 — ปัญหา + management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Intra-operative frozen section — surgeon ขอ frozen section จาก breast lumpectomy margin + sentinel lymph node 3 nodes; lab manager จัด workflow + turnaround time + accuracy expectations', '[{"label":"A","text":"ไม่ทำ"},{"label":"B","text":"Frozen Section Operations"},{"label":"C","text":"Refuse"},{"label":"D","text":"Random sections"},{"label":"E","text":"No QA"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Frozen Section Operations: (1) **Purpose**: intraoperative consultation — diagnosis (benign vs malignant), margin assessment, identification of unknown tissue, evaluation of lymph nodes; guide immediate surgical decisions; (2) **Workflow**: surgeon submits fresh specimen → pathologist examines gross → selects sections → cryostat freezes (-25 to -30°C OCT compound) → microtome sections (5-10 μm) → rapid H&E (or toluidine blue) → microscopic interpretation → communicate to OR; (3) **Standards (CAP)**: - **Turnaround time** target: 20 min per block (single specimen) — track + report; - **Concordance with permanent**: ≥ 97% target; - Documented results, time stamps; (4) **Limitations**: - **Artifacts**: ice crystals (slow freeze), folding, freeze artifact → harder interpretation; - **Some lesions hard frozen**: fatty tissue (lipoma, fatty breast), small foci; - **No IHC** (some specialty IHC possible but routinely none); - **Permanent sections needed for definitive diagnosis** — always note ''pending permanent''; (5) **Common scenarios**: - **Breast margin**: ''cavity shave'' margins assessed; ink + sections; report distance to margin; - **Sentinel lymph node**: per-protocol slicing (2 mm slices), levels examined; cytokeratin IHC on permanents (micromets); - **Brain tumor**: smear preparation often added; - **Thyroid**: limited utility (papillary nuclear features lost in frozen, follicular vs follicular ca needs capsular invasion on permanent); (6) **Quality assurance**: monitor TAT, concordance, deferred rate; periodic case review; (7) **Communication**: clear verbal + written; surgeon repeats back; documented in OR + path system; (8) **Multidisciplinary**: surgeon + pathologist + OR staff collaboration; team-based

---

Frozen section: cryostat-cut H&E for intraop diagnosis/margin/LN. TAT target 20 min/block; concordance ≥97%. Limitations: artifacts, thyroid follicular, no IHC. Always ''pending permanent''. QA + clear communication + documentation essential.', NULL,
  'medium', 'quality_safety', 'review',
  'pathology', 'ems_mgmt', 'quality_safety', 'mixed',
  'CAP Frozen Section; ADASP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Intra-operative frozen section — surgeon ขอ frozen section จาก breast lumpectomy margin + sentinel lymph node 3 nodes; lab manager จัด workflow + turnaround time + accuracy expectations'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Lab director — มี critical value (panic value) ใน CBC: WBC 0.4 ที่ AM rounds รออยู่ + plt 8; ระบบรายงาน critical values + accountability + กระบวนการ closed-loop communication', '[{"label":"A","text":"Email"},{"label":"B","text":"Critical Value Reporting (CAP/CLSI/TJC)"},{"label":"C","text":"No documentation"},{"label":"D","text":"Tell student"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Critical Value Reporting (CAP/CLSI/TJC): (1) **Definition**: laboratory result that requires immediate notification because it may represent life-threatening condition; (2) **Each lab establishes own list** based on clinical input — example panic values: - **CBC**: WBC < 1.0 or > 30; Hb < 6 or > 20; platelet < 20 or > 1000; absolute neutrophil < 0.5; - **Chemistry**: glucose < 40 or > 500; Na < 120 or > 160; K < 2.8 or > 6.2; Ca < 6 or > 13; - **Coagulation**: INR > 5 (anticoag); fibrinogen < 100; - **Microbiology**: positive blood culture, CSF culture, gram stain; - **Toxicology**: acetaminophen toxic level; - **Histopathology**: unexpected critical diagnoses (e.g., mucormycosis); (3) **Process** (closed-loop): - **Confirmation**: verify result (delta check, repeat if quality concern); - **Notification** to **licensed caregiver who can act** — physician, nurse, NP, PA — NOT clerk/student; - **Read-back / repeat-back**: caregiver repeats result back to lab; - **Time-stamped documentation** in LIS: result, who notified, who notified (name + role), time, read-back confirmation; - **Escalation pathway** if unable to reach (chain of command, attending, supervisor, hospitalist); - **Maximum time target** (e.g., < 30 min) per policy; (4) **Quality monitoring**: % critical values reported within target time, missed/delayed events, RCAs for failures; TJC NPSG 02.03.01; (5) **System support**: automated alerts, escalation systems, on-call rosters, pager/secure messaging; (6) **Training + competency**: lab staff + clinicians on process; (7) **Continuous review** of critical value list with clinical input + outcomes

---

Critical value: established list + closed-loop reporting. Confirm → notify licensed actionable provider → read-back → time-stamp documentation → escalation if unreachable. < 30 min target. TJC NPSG 02.03.01. Monitor + RCA for misses.', NULL,
  'medium', 'quality_safety', 'review',
  'pathology', 'ems_mgmt', 'quality_safety', 'mixed',
  'CAP; CLSI GP47; TJC NPSG 02.03.01', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Lab director — มี critical value (panic value) ใน CBC: WBC 0.4 ที่ AM rounds รออยู่ + plt 8; ระบบรายงาน critical values + accountability + กระบวนการ closed-loop communication'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี — newly diagnosed lung adenocarcinoma — case discussion ที่ multidisciplinary tumor board: pathology + biomarkers + imaging + treatment planning + clinical trials + multidisciplinary integrative care', '[{"label":"A","text":"Single specialist decides"},{"label":"B","text":"Multidisciplinary Tumor Board (MTB) Integrative Care"},{"label":"C","text":"No discussion"},{"label":"D","text":"Skip"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Multidisciplinary Tumor Board (MTB) Integrative Care: (1) **Composition**: pathology + radiology + medical oncology + surgical oncology (thoracic) + radiation oncology + pulmonology + palliative + nursing + social work + research/clinical trials + pharmacy + nutrition + supportive care + patient advocacy/navigator; (2) **Case preparation**: structured templates — clinical hx, imaging review, pathology (histology + IHC + molecular complete profile), staging summary, prior treatment, performance status, patient priorities; (3) **Standard outputs**: consensus diagnosis, stage, treatment recommendation with rationale, clinical trial options, supportive care; documented in chart for team + patient; (4) **Modern features**: - **Molecular tumor board**: dedicated team for complex genomic findings — interpret VUS, off-label targeted therapy, trial matching; - **Virtual MTB**: telemedicine extends to community partners; - **Patient navigator** ensures plan execution + access; - **Survivorship + late effects** planning; (5) **Quality + outcomes**: MTB attendance documented; track concordance with NCCN/guidelines, time to treatment, clinical trial enrollment, equity in access, patient experience; (6) **Equity considerations**: language services, cultural competence, transportation, financial counseling, community outreach; (7) **Clinical trial integration**: matched targeted trials (NTRK, RET, MET, HER2), IO trials, neoadjuvant trials; (8) **Patient + family included** when appropriate; (9) **Documentation** in EHR + shared with primary care; (10) **Continuous improvement**: outcomes review, case audits, education; (11) **Integrative + supportive**: smoking cessation, nutrition, pulmonary rehab, mental health, palliative early-integration (Temel)

---

MTB integrative care: multidisciplinary team-based decisions. Composition wide. Modern: molecular tumor board, virtual MTB, navigator. QI tracking. Trial integration. Equity + supportive + palliative integration. Patient-centered.', NULL,
  'medium', 'hemato_onco', 'review',
  'pathology', 'integrative', 'hemato_onco', 'adult',
  'ASCO; NCI Tumor Board Standards; Temel NEJM', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี — newly diagnosed lung adenocarcinoma — case discussion ที่ multidisciplinary tumor board: pathology + biomarkers + imaging + treatment planning + clinical trials + multidisciplinary integrative care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Patient with rare cancer + VUS (variant of uncertain significance) ใน NGS — molecular tumor board for interpretation + integrative care + clinical trial matching', '[{"label":"A","text":"Ignore VUS"},{"label":"B","text":"Molecular Tumor Board (MTB) Integrative"},{"label":"C","text":"Skip board"},{"label":"D","text":"Refuse"},{"label":"E","text":"Single specialty"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Molecular Tumor Board (MTB) Integrative: (1) **Purpose**: interpret complex genomic results, match to targeted therapies/trials, classify variants, recommend additional testing; bridge between pathology + treating team; (2) **Composition**: molecular pathologist + genomic counselor + medical oncology (rare cancers + specific tumor types) + clinical pharmacist + bioinformatics + research + pathology + radiology + germline genetics + ethics consult (selected); (3) **Variant interpretation**: - **Tier I** (strong clinical significance) — FDA-approved drug; - **Tier II** (potential) — off-label or trial evidence; - **Tier III** (VUS) — additional curation; - **Tier IV** (benign/likely benign); - Functional studies, public databases (ClinVar, COSMIC, OncoKB, CIViC), literature; (4) **Germline implications**: distinguish somatic vs germline (paired testing or VAF); recommend genetic counseling + family testing; secondary findings (ACMG-recommended actionable list); (5) **Clinical trial matching**: basket/umbrella trials, MATCH/NCI-MATCH, ASCO TAPUR, industry trials; navigator-supported enrollment; (6) **Off-label + access**: insurance prior auth + appeals; patient assistance programs; compassionate use; expanded access; (7) **Equity**: rare tumor + biomarker access barriers; financial toxicity; (8) **Patient engagement**: shared decision-making + understanding of evidence quality; informed consent; (9) **Documentation + follow-up**: structured EHR templates; outcome tracking + database; (10) **Continuous learning**: update knowledge with rapidly evolving evidence; (11) **Integration**: molecular + clinical + imaging + multidisciplinary main tumor board; comprehensive treatment plan including palliative + supportive

---

Molecular tumor board: dedicated team for genomic interpretation + trial matching. Variant tiers I-IV (AMP/ASCO/CAP). Germline implications + counseling. Trial matching (MATCH, TAPUR). Access + equity considerations. Integrated with main MTB.', NULL,
  'hard', 'molecular_pathology', 'review',
  'pathology', 'integrative', 'molecular_pathology', 'mixed',
  'ASCO Precision Medicine; AMP/ASCO/CAP 2017', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Patient with rare cancer + VUS (variant of uncertain significance) ใน NGS — molecular tumor board for interpretation + integrative care + clinical trial matching'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital autopsy program — sudden unexpected adult death in hospital + family consent given; pathology + multidisciplinary autopsy integrative role in quality + education + family closure', '[{"label":"A","text":"No autopsy"},{"label":"B","text":"Hospital Autopsy Integrative Value"},{"label":"C","text":"Skip"},{"label":"D","text":"Single specialty"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hospital Autopsy Integrative Value: (1) **Purposes**: - **Diagnostic accuracy**: identify missed/incorrect diagnoses (~ 10-30% major discrepancies historically — even in modern era ~ 8-25%); - **Cause of death determination**; - **Quality + safety**: M&M, root cause analysis input, complications identified; - **Education**: medical students, residents, fellows, attendings learning; - **Research**: tissue collection (with consent), disease characterization; - **Family closure**: explanation, grief processing, hereditary implications; - **Public health**: surveillance of disease, COVID/emerging pathogens (e.g., COVID autopsy programs key to understanding disease); (2) **Process**: - **Consent**: from legal next of kin; specifics (full autopsy, restricted, organs retention); medical examiner cases (homicide, suicide, accident, suspicious, unattended, in-custody) → separate jurisdiction, no family consent needed; - **External exam** + photo documentation; - **Internal exam**: thoracic, abdominal, cranial as consented; - **Gross + histology**; - **Special**: microbiology, toxicology, genetic, molecular as indicated; - **Provisional anatomical diagnosis** within ~ 24 hours; - **Final autopsy report** ~ 6-8 weeks with histology + ancillary; (3) **Communication with family**: empathetic, clear, structured meeting; bereavement support; (4) **Communication with clinical team**: M&M conference, learning; (5) **Quality**: track autopsy rate, discrepancies (Goldman class I-IV), reporting timeliness; (6) **Multidisciplinary**: pathology + clinical service + bereavement + chaplaincy + risk management + legal as needed; (7) **Modern decline + revival**: rate dropped historically but renewed importance with COVID + complex deaths + AI; consent process improvement essential

---

Hospital autopsy: diagnostic accuracy + quality + education + family closure + research + public health. Goldman class discrepancies. Consent + ME jurisdiction. Provisional ~24h, final ~6-8w. Communication with family + clinical team. COVID renewed importance.', NULL,
  'medium', 'forensic', 'review',
  'pathology', 'integrative', 'forensic', 'adult',
  'CAP Autopsy; ADASP; Goldman', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Hospital autopsy program — sudden unexpected adult death in hospital + family consent given; pathology + multidisciplinary autopsy integrative role in quality + education + family closure'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี — lymph node biopsy: diffuse sheet-like proliferation of large lymphoid cells with vesicular nuclei + prominent nucleoli, high mitoses; IHC: CD20+, CD79a+, BCL6+, MUM1+, CD10-, Ki-67 ~80%, MYC 30%, BCL2 50%; FISH: no MYC/BCL2/BCL6 rearrangements; การวินิจฉัยและการรักษา', '[{"label":"A","text":"Reactive hyperplasia"},{"label":"B","text":"Diffuse Large B-cell Lymphoma (DLBCL)"},{"label":"C","text":"CLL"},{"label":"D","text":"Hodgkin"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Diffuse Large B-cell Lymphoma (DLBCL): (1) **Histology**: diffuse effacement by sheets of large transformed B-cells (centroblasts, immunoblasts); ≥ 2 × normal lymphocyte size; high mitoses + apoptosis; (2) **IHC** (mandatory panel): CD20, CD79a, PAX5 (B-cell); BCL6, CD10, MUM1 (cell-of-origin); BCL2, MYC (double-expressor); Ki-67; (3) **Hans algorithm (cell of origin from IHC)**: GCB (germinal-center B — CD10+ OR (CD10- BCL6+ MUM1-)) vs **non-GCB** (rest); GCB better prognosis; (4) **Molecular subtypes** (gene-expression): GCB, ABC, unclassified; new genomic clusters (LymphGen — MCD, BN2, N1, EZB, ST2, A53); (5) **Essential FISH** (rule out high-grade): **MYC** + **BCL2** + **BCL6** rearrangements → if MYC + (BCL2 and/or BCL6) = **''double-hit'' / ''triple-hit'' high-grade B-cell lymphoma (HGBL)** — aggressive, separate WHO entity; (6) **Double expressor** (BCL2 + MYC by IHC, no rearrangement) = worse prognosis but not HGBL; (7) **Staging**: PET-CT (Lugano 2014 criteria), BM biopsy (selective — replaced by PET in many), CNS risk assessment (CNS-IPI); (8) **Treatment**: - **R-CHOP × 6** standard; - **Pola-R-CHP** (polatuzumab vedotin replacing vincristine — POLARIX) ≥ IPI 2 — new standard for many; - HGBL: DA-EPOCH-R; - CNS prophylaxis high-risk (CNS-IPI ≥ 4, testicular, breast, double-hit, kidney/adrenal); - Relapsed/refractory: **CAR-T** (axi-cel, liso-cel — ZUMA-7, TRANSFORM moved CAR-T to 2nd line) > auto-HCT; - Other: tafasitamab + lenalidomide, lonca-T, glofitamab/epcoritamab (bispecific), pola; (9) **IPI / NCCN-IPI** risk; (10) **PMBCL** distinct entity; (11) **Cures > 60% with R-CHOP**

---

DLBCL: large B-cell sheets; Hans algorithm GCB vs non-GCB; FISH for MYC/BCL2/BCL6 to rule out HGBL. R-CHOP standard; Pola-R-CHP new (POLARIX). CAR-T 2nd line (ZUMA-7). Bispecifics + ADCs for R/R. Cure > 60%.', NULL,
  'hard', 'hematopathology', 'review',
  'pathology', 'clinical_decision', 'hematopathology', 'adult',
  'WHO HAEM5 2022; ICC 2022; NCCN B-cell Lymphomas; POLARIX', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี — lymph node biopsy: diffuse sheet-like proliferation of large lymphoid cells with vesicular nuclei + prominent nucleoli, high mitoses; IHC: CD20+, CD79a+, BCL6+, MUM1+, CD10-, Ki-67 ~80%, MYC 30%, BCL2 50%; FISH: no MYC/BCL2/BCL6 rearrangements; การวินิจฉัยและการรักษา'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี — generalized lymphadenopathy + slow growing → excisional biopsy: nodular/follicular pattern; IHC: CD20+, CD10+, BCL6+, BCL2+ (aberrant in follicles), CD5-, CD23-, Ki-67 low (~10%); FISH: t(14;18) IGH/BCL2 positive; grade 1-2', '[{"label":"A","text":"Reactive follicular hyperplasia"},{"label":"B","text":"Follicular Lymphoma (FL)"},{"label":"C","text":"MCL"},{"label":"D","text":"Burkitt"},{"label":"E","text":"Hodgkin"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Follicular Lymphoma (FL): (1) **Histology**: nodular/follicular pattern with monotonous small cleaved (centrocytes) + variable large (centroblasts) cells; loss of polarization + tingible-body macrophages; (2) **IHC**: CD20+, CD10+, BCL6+, **BCL2+ within follicles (aberrant — vs reactive germinal centers BCL2 negative)**, CD5-, CD23-; Ki-67 typically low in low-grade; (3) **Cytogenetics**: **t(14;18)(q32;q21) IGH/BCL2** in ~ 85% — leads to BCL2 overexpression + apoptosis evasion; (4) **Grading (WHO)**: based on centroblast count per HPF — grade 1-2 (0-15), grade 3A (> 15 but with centrocytes), 3B (sheets of centroblasts — treated like DLBCL); FL grading recently simplified; (5) **Variants/related**: pediatric-type FL (different biology), duodenal-type FL (indolent), in situ follicular B-cell neoplasm; FL with predominantly diffuse pattern, FL with unusual cytologic features; (6) **Staging**: PET-CT, BM biopsy (~ 70% involvement at diagnosis); (7) **FLIPI/FLIPI2** prognostic; (8) **Treatment**: - **Asymptomatic low burden**: watch + wait (no survival benefit from immediate Tx in low-grade); - **Symptomatic/high tumor burden (GELF criteria)**: bendamustine + rituximab (BR) OR R-CHOP OR R² (rituximab + lenalidomide — AUGMENT relapsed); rituximab maintenance debated; obinutuzumab + chemo alternative; - **Localized stage I**: RT alone potentially curative; - **Transformation to DLBCL** ~ 2-3%/yr — re-biopsy if discordant behavior; - **Relapsed/refractory**: PI3K inhibitors (limited), tazemetostat (EZH2 mutant), CAR-T (axi-cel — ZUMA-5), bispecifics (mosunetuzumab); (9) **Indolent but currently incurable** with chemo (except localized)

---

FL: follicular pattern, CD10+/BCL6+/BCL2+ (aberrant in follicles); t(14;18) IGH/BCL2 ~85%. Grading by centroblast count. Asymptomatic → W&W; symptomatic → BR/R-CHOP/R². Tazemetostat (EZH2), CAR-T, bispecifics for R/R. Incurable but indolent.', NULL,
  'medium', 'hematopathology', 'review',
  'pathology', 'clinical_decision', 'hematopathology', 'adult',
  'WHO HAEM5 2022; NCCN B-cell Lymphomas; AUGMENT', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี — generalized lymphadenopathy + slow growing → excisional biopsy: nodular/follicular pattern; IHC: CD20+, CD10+, BCL6+, BCL2+ (aberrant in follicles), CD5-, CD23-, Ki-67 low (~10%); FISH: t(14;18) IGH/BCL2 positive; grade 1-2'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชายอายุ 68 ปี — lymphadenopathy + splenomegaly + B symptoms; lymph node biopsy: monotonous medium-sized lymphoid cells with irregular nuclei; IHC: CD20+, CD5+, CD23-, **cyclin D1+**, SOX11+, CD10-; FISH: t(11;14) CCND1/IGH; การวินิจฉัย', '[{"label":"A","text":"CLL"},{"label":"B","text":"Mantle Cell Lymphoma (MCL)"},{"label":"C","text":"FL"},{"label":"D","text":"Hodgkin"},{"label":"E","text":"Reactive"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mantle Cell Lymphoma (MCL): (1) **Histology**: monotonous medium-sized cells with irregular cleaved nuclei; mantle zone, nodular, diffuse, or blastoid (aggressive variant) patterns; pleomorphic variant; (2) **IHC**: CD20+, CD5+, **CD23 negative** (vs CLL CD23+), **cyclin D1+ (nuclear)**, SOX11+ (specific; positive even in CCND1-negative MCL), CD10-, BCL6-; (3) **Cytogenetics**: **t(11;14)(q13;q32) CCND1/IGH** — pathognomonic, dysregulates cyclin D1 → cell cycle drive; (4) **Variants**: - **Classic** — node-based, aggressive; - **Leukemic non-nodal** (indolent, SOX11- subset) — watch + wait; - **Blastoid + pleomorphic** — aggressive; - **In situ mantle cell neoplasia**; (5) **Molecular**: TP53 mutation (poor prognosis — affects treatment selection — avoid intensive chemo); CDKN2A; ATM; NOTCH1/2; (6) **MIPI** prognostic; Ki-67 important (> 30% adverse); (7) **Staging**: PET-CT, BM biopsy, often advanced stage at diagnosis; GI involvement common (lymphomatous polyposis); (8) **Treatment**: - **Indolent (non-nodal, SOX11-)**: watch + wait; - **Younger fit**: intensive induction (R-DHAP or R-CHOP/R-DHAP alternating + cytarabine) + auto-HCT consolidation; rituximab maintenance; - **Older/less fit**: BR or R-CHOP + rituximab maintenance; - **TP53 mutated**: standard chemo poor — consider novel/trials (ibrutinib + venetoclax, BTKi-based, CAR-T); - **Relapsed**: BTK inhibitors (ibrutinib, acalabrutinib, zanubrutinib, pirtobrutinib non-covalent); venetoclax; lenalidomide; **CAR-T (brexucabtagene — ZUMA-2)** for R/R; bispecifics emerging

---

MCL: CD5+/CD23-/cyclin D1+/SOX11+; t(11;14) CCND1/IGH pathognomonic. Variants: classic, leukemic non-nodal (indolent), blastoid (aggressive). TP53 mutated worse; novel/CAR-T. BTKi (incl. pirtobrutinib) + venetoclax for R/R. ZUMA-2 CAR-T.', NULL,
  'hard', 'hematopathology', 'review',
  'pathology', 'clinical_decision', 'hematopathology', 'adult',
  'WHO HAEM5 2022; NCCN MCL; ZUMA-2', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยชายอายุ 68 ปี — lymphadenopathy + splenomegaly + B symptoms; lymph node biopsy: monotonous medium-sized lymphoid cells with irregular nuclei; IHC: CD20+, CD5+, CD23-, **cyclin D1+**, SOX11+, CD10-; FISH: t(11;14) CCND1/IGH; การวินิจฉัย'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชายอายุ 12 ปี — abdominal mass + tumor lysis on presentation; biopsy: monomorphic medium-sized cells with basophilic cytoplasm + vacuoles + ''starry sky'' (tingible body macrophages); IHC: CD20+, CD10+, BCL6+, BCL2-, Ki-67 ~100%, MYC+; FISH: t(8;14) MYC/IGH', '[{"label":"A","text":"Hodgkin"},{"label":"B","text":"BCL2 negative or weak"},{"label":"C","text":"ALL"},{"label":"D","text":"Neuroblastoma"},{"label":"E","text":"FL"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Burkitt Lymphoma: (1) **Histology**: monomorphic medium-sized cells with basophilic cytoplasm + lipid vacuoles; ''starry sky'' pattern from tingible body macrophages engulfing apoptotic cells (extremely high cell turnover); high mitoses + apoptosis; (2) **IHC**: CD20+, CD10+, BCL6+, **BCL2 negative or weak** (essential — distinguish from DLBCL/HGBL), **Ki-67 ~100%**, MYC + (translocation product); TdT negative; (3) **Cytogenetics**: **MYC rearrangement** — t(8;14)(q24;q32) IGH/MYC (most common); variants t(2;8) IGK/MYC, t(8;22) IGL/MYC; (4) **Variants (WHO)**: - Endemic (African) — EBV-associated, mandibular/abdominal; - Sporadic — abdominal, head/neck; - Immunodeficiency-associated (HIV, post-transplant); - **Burkitt-like lymphoma with 11q aberration** (newer entity, no MYC rearr, different biology); (5) **HGBL-NOS** + **HGBL with MYC + BCL2 +/- BCL6 (double/triple-hit)** distinct from Burkitt — important differential; (6) **Highly aggressive but curable** with intensive multi-agent chemo; (7) **Treatment**: - **Tumor lysis prophylaxis essential** (rasburicase, aggressive hydration, monitor electrolytes) — TLS often present at diagnosis; - **DA-EPOCH-R** with CNS prophylaxis (acceptable + tolerable in adults — Roschewski); - **CODOX-M/IVAC** (Magrath regimen) — historical/pediatric; - **R-Hyper-CVAD** alternative; - **CNS prophylaxis essential** (IT MTX/cytarabine ± high-dose systemic MTX); - Pediatric ANHL1131 regimen; (8) **Outcomes**: cure > 90% pediatric/young + low-stage, > 70% adult advanced

---

Burkitt: ''starry sky'', CD20+/CD10+/BCL6+/BCL2-, Ki-67 ~100%, MYC translocation (t(8;14)). Distinct from HGBL double-hit (BCL2+). TLS prophylaxis essential. DA-EPOCH-R or CODOX-M/IVAC; CNS prophylaxis. Curable.', NULL,
  'medium', 'hematopathology', 'review',
  'pathology', 'clinical_decision', 'hematopathology', 'mixed',
  'WHO HAEM5 2022; NCCN; Roschewski DA-EPOCH-R Burkitt', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยชายอายุ 12 ปี — abdominal mass + tumor lysis on presentation; biopsy: monomorphic medium-sized cells with basophilic cytoplasm + vacuoles + ''starry sky'' (tingible body macrophages); IHC: CD20+, CD10+, BCL6+, BCL2-, Ki-67 ~100%, MYC+; FISH: t(8;14) MYC/IGH'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 25 ปี — cervical lymphadenopathy + B symptoms → biopsy: scattered large cells with bilobed nuclei + prominent eosinophilic nucleoli (''owl eyes'') in background of small lymphocytes + eosinophils + plasma cells + fibrosis; IHC: CD30+, CD15+, PAX5 dim+, CD20-, CD45-', '[{"label":"A","text":"Reactive"},{"label":"B","text":"Classical Hodgkin Lymphoma (CHL)"},{"label":"C","text":"DLBCL"},{"label":"D","text":"TB"},{"label":"E","text":"CLL"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Classical Hodgkin Lymphoma (CHL): (1) **Histology**: Reed-Sternberg (RS) cells — large, multinucleated/bilobed with prominent eosinophilic ''owl-eye'' nucleoli; mononuclear variants (Hodgkin cells); lacunar variant (nodular sclerosis); inflammatory background — small lymphocytes, eosinophils, plasma cells, histiocytes, fibrosis; (2) **Subtypes (CHL)**: - **Nodular sclerosis** (NSCHL) — most common in West, young adults, mediastinum, lacunar RS cells, fibrous bands; - **Mixed cellularity** (MCCHL) — older, EBV-associated; - **Lymphocyte-rich** (LRCHL); - **Lymphocyte-depleted** (LDCHL) — rarest, aggressive, HIV-associated; (3) **IHC (CHL)**: **CD30+ (strong)**, **CD15+** (~ 75%), PAX5 dim+, MUM1+, **CD20 usually negative or weak/heterogeneous**, **CD45 negative**, BCL6-, OCT2/BOB1 weak/absent (B-cell program down-regulated); EBV (EBER ISH) variable; (4) **Nodular Lymphocyte Predominant Hodgkin/NLP B-cell Lymphoma** (NLPHL — reclassified in WHO HAEM5 as NLPBL) — distinct: LP (''popcorn'') cells, CD20+, CD45+, CD15-, CD30-, BCL6+ — treated more like indolent B-cell lymphoma; (5) **Staging**: PET-CT (Lugano) — replaces routine BM biopsy in CHL; (6) **Treatment**: - **Early stage favorable**: ABVD × 2 + ISRT (RAPID, H10) or ABVD × 4 alone (RATHL — PET-adapted); - **Early unfavorable**: ABVD × 4 + RT; - **Advanced**: ABVD × 6 (RATHL PET-adapted reducing bleo) OR **A+AVD (brentuximab vedotin + AVD)** (ECHELON-1 — A+AVD superior + PFS); recent ABVD/A+AVD + nivolumab data; - **Relapsed**: salvage + auto-HCT; brentuximab + nivolumab/pembrolizumab; allo-HCT for select; (7) **Cures > 80%**

---

Classical Hodgkin: RS cells (CD30+/CD15+/CD20-/CD45-), ''owl-eye'' nucleoli + inflammatory background. Subtypes NS/MC/LR/LD. NLPHL (NLPBL) distinct (CD20+). PET-adapted ABVD or A+AVD (ECHELON-1). Brentuximab + IO for R/R. Cure > 80%.', NULL,
  'medium', 'hematopathology', 'review',
  'pathology', 'clinical_decision', 'hematopathology', 'adult',
  'WHO HAEM5 2022; NCCN Hodgkin; ECHELON-1', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 25 ปี — cervical lymphadenopathy + B symptoms → biopsy: scattered large cells with bilobed nuclei + prominent eosinophilic nucleoli (''owl eyes'') in background of small lymphocytes + eosinophils + plasma cells + fibrosis; IHC: CD30+, CD15+, PAX5 dim+, CD20-, CD45-'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 70 ปี — fatigue + bone pain + Cr 2.3 + Hb 8.5 + Ca 11.5 + serum protein electrophoresis: M-spike 4.5 g/dL IgG kappa; BM biopsy: 60% plasma cells, sheets + atypical; FISH: t(4;14) FGFR3/MMSET, del(17p); การวินิจฉัยและการรักษา', '[{"label":"A","text":"MGUS"},{"label":"B","text":"Multiple Myeloma (MM)"},{"label":"C","text":"Refuse"},{"label":"D","text":"Hospice"},{"label":"E","text":"Lymphoma"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Multiple Myeloma (MM): (1) **Diagnostic criteria (IMWG 2014, updated)**: clonal BM plasma cells ≥ 10% (or biopsy-proven plasmacytoma) + one of CRAB (hypercalcemia, renal insufficiency, anemia, bone lesions) OR myeloma-defining events (clonal BM PC ≥ 60%, FLC ratio ≥ 100, > 1 focal MRI lesion ≥ 5 mm) — SLiM-CRAB; (2) **vs MGUS** (M-protein < 3, BM PC < 10%, no CRAB) and **smoldering MM** (intermediate, no CRAB); (3) **Workup**: SPEP + UPEP + immunofixation, serum free light chains, IgG/A/M quantitative, beta-2 microglobulin, albumin (R-ISS); skeletal survey (low-dose whole-body CT or MRI/PET preferred — more sensitive than plain films); BM biopsy + aspirate with FISH; (4) **FISH/cytogenetics (essential — risk stratification)**: - **High risk**: t(4;14), t(14;16), t(14;20), del(17p)/TP53, gain/amp 1q21, +/- t(14;20); - **Standard**: t(11;14), hyperdiploidy; (5) **R-ISS / R2-ISS**: stage I-III using albumin + β2m + LDH + cytogenetics; (6) **Treatment** (transplant-eligible — newly diagnosed): - **Quadruplet induction**: **Dara-VRd (daratumumab + bortezomib + lenalidomide + dexamethasone)** (PERSEUS, GRIFFIN) — new standard; alt isa-KRd; - Auto-HCT consolidation; - Maintenance lenalidomide; daratumumab maintenance trials; - **Transplant-ineligible**: Dara-Rd or Dara-VRd; (7) **Relapsed/refractory**: - **CAR-T (BCMA — ide-cel KarMMa, cilta-cel CARTITUDE)** — earlier lines now (CARTITUDE-4, KarMMa-3); - Bispecifics: **teclistamab, elranatamab (BCMA), talquetamab (GPRC5D), cevostamab (FcRH5)**; - Other PI (carfilzomib, ixazomib), IMiD (pomalidomide), anti-CD38 (isatuximab), selinexor, venetoclax (t(11;14)); (8) **Supportive**: bisphosphonate/denosumab, infection prophylaxis, anticoagulation IMiD

---

MM: SLiM-CRAB criteria; SPEP/SFLC/IFE + BM + FISH. High-risk t(4;14)/del(17p)/t(14;16)/+1q. Quadruplet Dara-VRd + auto-HCT + maintenance new standard. R/R: BCMA CAR-T (ide-cel/cilta-cel), bispecifics (teclistamab, talquetamab). Supportive bisphos.', NULL,
  'hard', 'hematopathology', 'review',
  'pathology', 'clinical_decision', 'hematopathology', 'adult',
  'IMWG 2014/updates; NCCN MM; PERSEUS; CARTITUDE-4', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 70 ปี — fatigue + bone pain + Cr 2.3 + Hb 8.5 + Ca 11.5 + serum protein electrophoresis: M-spike 4.5 g/dL IgG kappa; BM biopsy: 60% plasma cells, sheets + atypical; FISH: t(4;14) FGFR3/MMSET, del(17p); การวินิจฉัยและการรักษา'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิงอายุ 35 ปี — fatigue + heavy menses; CBC: Hb 8.2, MCV 68, MCH 22, RDW elevated; serum ferritin < 10, Fe low, TIBC high, transferrin saturation 5%; การวินิจฉัยและการรักษา', '[{"label":"A","text":"Thalassemia"},{"label":"B","text":"Iron Deficiency Anemia (IDA) — Pathology + Workup"},{"label":"C","text":"Sickle cell"},{"label":"D","text":"G6PD"},{"label":"E","text":"AIHA"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Iron Deficiency Anemia (IDA) — Pathology + Workup: (1) **Pattern**: microcytic (MCV < 80) + hypochromic (MCH ↓) + elevated RDW (heterogeneous); reticulocyte count low; (2) **Iron studies**: **ferritin LOW (most specific — < 15-30 ng/mL = iron deficient; < 100 in chronic disease + ''iron deficient'')**, serum Fe low, TIBC high (transferrin produced to compensate), transferrin saturation < 16%, sTfR elevated; (3) **Smear**: microcytic + hypochromic + anisocytosis + poikilocytosis (pencil/cigar cells, target cells); (4) **Differential of microcytic anemia (mnemonic TAILS)**: Thalassemia, Anemia of chronic disease, Iron deficiency, Lead poisoning, Sideroblastic; (5) **vs Thalassemia**: thal — MCV very low for Hb level, RDW NORMAL, normal/elevated Fe + ferritin, basophilic stippling, target cells; Hb electrophoresis abnormal (Hb F, A2); (6) **vs ACD**: ACD — ferritin normal/high, Fe low, TIBC LOW, hepcidin high (iron sequestration); (7) **Cause investigation essential** — IDA = bleeding until proven otherwise: - Menstrual loss; - GI bleed (occult — workup EGD + colonoscopy in adult men + postmenopausal women OR persistent IDA); - Pregnancy + lactation; - Malabsorption (celiac, atrophic gastritis, post-bariatric); - Diet (rare in developed countries except infants); - H. pylori; (8) **Treatment**: - Oral iron — ferrous sulfate 325 mg every other day (better absorption than daily — Stoffel data) until ferritin > 100 + 3-6 mo more for stores; - IV iron (ferric carboxymaltose, iron sucrose, ferumoxytol) — intolerance, severe deficit, IBD, CKD, pregnancy 2nd-3rd tri, post-bariatric, ongoing loss; - Transfusion only severe symptomatic; (9) **Follow-up**: Hb 4 wk + ferritin 3 mo

---

IDA: microcytic hypochromic + high RDW + low ferritin + low Fe + high TIBC + low sat. vs thal (normal RDW, normal Fe), ACD (low TIBC). Mandatory cause workup (GI in adults). Oral Fe alt-day (Stoffel); IV Fe selected. Monitor ferritin to replete stores.', NULL,
  'easy', 'hematopathology', 'review',
  'pathology', 'clinical_decision', 'hematopathology', 'adult',
  'ASH IDA Guidelines; AGA Anemia', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยหญิงอายุ 35 ปี — fatigue + heavy menses; CBC: Hb 8.2, MCV 68, MCH 22, RDW elevated; serum ferritin < 10, Fe low, TIBC high, transferrin saturation 5%; การวินิจฉัยและการรักษา'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 75 ปี vegan — Hb 9.0, MCV 115 (macrocytic), oval macrocytes + hypersegmented neutrophils, LDH high + indirect bili high, B12 100 (low), homocysteine + MMA elevated; การวินิจฉัยและการ workup + Tx', '[{"label":"A","text":"Iron deficiency"},{"label":"B","text":"Vitamin B12 Deficiency Anemia — Pathology + Workup"},{"label":"C","text":"MDS"},{"label":"D","text":"Aplastic anemia"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Vitamin B12 Deficiency Anemia — Pathology + Workup: (1) **Pattern**: macrocytic (MCV > 100), megaloblastic (oval macrocytes + hypersegmented neutrophils ≥ 5 lobes + 5%); pancytopenia possible severe cases; (2) **Megaloblastic = impaired DNA synthesis** — folate or B12 deficiency → ineffective erythropoiesis → high LDH + indirect bili (intramedullary hemolysis); (3) **B12 vs folate**: serum B12 + folate; **MMA (methylmalonic acid) elevated only in B12 def** (B12 cofactor for methylmalonyl-CoA mutase); homocysteine elevated in both; (4) **Causes B12 def**: - **Pernicious anemia** (autoimmune anti-IF, anti-parietal cell — atrophic gastritis) — most common adult; check anti-IF Ab (specific) + anti-parietal (sensitive); - **Dietary** (vegan, infants of vegan mothers); - **Malabsorption**: post-gastrectomy/bariatric, ileal resection/Crohn''s, pancreatic insufficiency, fish tapeworm (rare), bacterial overgrowth; - **PPI/H2RA chronic use**, **metformin** (mild); - **Inherited**: TC-II deficiency, IF deficiency (juvenile); (5) **Neurologic features** (B12 specific — folate doesn''t cause): subacute combined degeneration (posterior + lateral columns), peripheral neuropathy, paresthesias, ataxia, dementia, psych symptoms — can occur **without anemia** — neuro irreversible if untreated long; (6) **Treatment**: - Pernicious anemia or malabsorption: IM cyanocobalamin/hydroxocobalamin 1000 μg daily × 1 wk → weekly × 1 mo → monthly lifelong; high-dose oral 1000-2000 μg/d acceptable; - Dietary: oral; - Initial replenishment may unmask hypokalemia (sudden cell production); - **Don''t give folate alone if B12 deficient** — corrects anemia but neuro worsens; (7) **Investigate underlying** + monitor; (8) **Folate deficiency**: alcoholism, malabsorption, pregnancy, methotrexate, phenytoin, dialysis

---

B12 deficiency: macrocytic + megaloblastic (oval macros + hyperseg neutros); MMA + homocysteine elevated (B12 specific MMA). Pernicious anemia main cause adult. Neuro features irreversible if delayed. Treat IM/high-dose oral; don''t give folate alone if B12 low.', NULL,
  'medium', 'hematopathology', 'review',
  'pathology', 'clinical_decision', 'hematopathology', 'adult',
  'BSH B12/Folate; ASH', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 75 ปี vegan — Hb 9.0, MCV 115 (macrocytic), oval macrocytes + hypersegmented neutrophils, LDH high + indirect bili high, B12 100 (low), homocysteine + MMA elevated; การวินิจฉัยและการ workup + Tx'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 25 ปี African descent — peripheral smear: sickle-shaped RBCs + Howell-Jolly bodies + target cells; Hb electrophoresis: HbS 88%, HbF 8%, HbA2 3.5%, HbA 0%; current VOC + acute chest syndrome; การวินิจฉัยและการรักษา comprehensive', '[{"label":"A","text":"Iron deficiency"},{"label":"B","text":"Sickle Cell Disease (HbSS) — Pathology + Management"},{"label":"C","text":"Refuse"},{"label":"D","text":"Skip"},{"label":"E","text":"Same as trait"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Sickle Cell Disease (HbSS) — Pathology + Management: (1) **Pathophysiology**: point mutation HBB gene (Glu6Val) → HbS polymerizes in deoxygenated state → sickle RBCs → vaso-occlusion + chronic hemolysis + endothelial dysfunction + chronic inflammation; (2) **Smear**: sickle cells, target cells, Howell-Jolly bodies (functional asplenia), nucleated RBCs, polychromasia (reticulocytosis); (3) **Hb electrophoresis**: HbSS (homozygous), HbSC (compound heterozygous), HbS/β-thal; sickle cell trait (HbAS — usually asymptomatic, rare hypoxic complications); (4) **Newborn screening** universal (HbF predominant → screen with HPLC); (5) **Acute complications**: - **Vaso-occlusive crisis (VOC)**: pain — opioid + hydration + warmth; - **Acute chest syndrome (ACS)** — leading cause of mortality: hypoxia + infiltrate + chest pain → exchange transfusion + ABX (incl atypical) + bronchodilator + incentive spirometry; - **Splenic sequestration** (children); - **Aplastic crisis** (parvovirus B19); - **Stroke** — TCD screen children + transfuse if elevated velocity; - **Priapism**; - **Sepsis** (encapsulated organisms — functional asplenia → daily prophylactic PCN < 5 yo, full immunizations incl pneumo, Hib, meningo); (6) **Chronic**: chronic hemolytic anemia, gallstones, pulmonary HTN, renal disease, retinopathy, leg ulcers, avascular necrosis, growth failure, mental health; (7) **Disease-modifying therapy**: - **Hydroxyurea** (induces HbF) — foundation; - **L-glutamine** (Endari); - **Crizanlizumab** (anti-P-selectin) — re-evaluated; - **Voxelotor** (HbS polymerization inhibitor) — withdrawn 2024 globally due to mortality signal; - **Chronic transfusion** (stroke prevention/secondary, recurrent ACS); - **Curative**: **HLA-matched allo-HCT** (children + selected adults); **gene therapy** — Lyfgenia (lovotibeglogene autotemcel) + Casgevy (exa-cel — CRISPR BCL11A — first FDA-approved CRISPR therapy 2023); (8) **Multidisciplinary lifelong care**

---

SCD: sickle RBCs + Howell-Jolly + Hb S on electrophoresis. VOC + ACS major acute. Stroke (TCD screen), sepsis (prophylactic PCN, vaccines). Hydroxyurea foundation; chronic txn for select; allo-HCT + gene therapy (Casgevy CRISPR, Lyfgenia) curative. Voxelotor withdrawn.', NULL,
  'hard', 'hematopathology', 'review',
  'pathology', 'clinical_decision', 'hematopathology', 'mixed',
  'ASH SCD Guidelines; NHLBI', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 25 ปี African descent — peripheral smear: sickle-shaped RBCs + Howell-Jolly bodies + target cells; Hb electrophoresis: HbS 88%, HbF 8%, HbA2 3.5%, HbA 0%; current VOC + acute chest syndrome; การวินิจฉัยและการรักษา comprehensive'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยเด็กไทยอายุ 6 ปี — pallor + jaundice + splenomegaly; CBC: Hb 6, MCV 60, MCH 18; smear: severe microcytic + target cells + tear drops + nucleated RBCs; Hb typing: HbE 25%, HbF 60%, HbA2 5%, HbA 0%, HbH small amount; molecular: β-thal mutation + α-thal deletion', '[{"label":"A","text":"IDA"},{"label":"B","text":"Thalassemia (Compound) — Pathology + Management"},{"label":"C","text":"AIHA"},{"label":"D","text":"G6PD"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Thalassemia (Compound) — Pathology + Management: (1) **Background — common in Southeast Asia + Mediterranean + Africa**; (2) **α-thalassemia (HBA1/HBA2 deletions)**: - Silent carrier (-α/αα); - α-thal trait (--/αα or -α/-α) — microcytic + mild; - **HbH disease** (--/-α) — 3 α genes deleted → HbH (β4 tetramers) — moderate-severe; - **Hb Bart''s hydrops** (--/--) — incompatible with life (without intrauterine intervention); (3) **β-thalassemia (HBB mutations)**: - β-thal minor (heterozygous) — microcytic + mild; - β-thal intermedia — transfusion-independent or intermittent; - **β-thal major (Cooley''s anemia)** — homozygous null β-globin → severe; transfusion-dependent from infancy; (4) **β-thal/HbE** (compound — common Thailand/Cambodia) — variable severity from intermedia → major; (5) **Smear**: severe microcytic + hypochromic + target cells + nucleated RBCs + tear drops + basophilic stippling; (6) **Hb typing (HPLC)**: elevated HbA2 (β-thal trait/minor), HbF (β-thal major/intermedia, HbE), HbE peak, HbH peak (HbH disease), Bart''s (newborn); (7) **Iron studies**: normal/elevated Fe + ferritin (vs IDA which Fe + ferritin low); (8) **Complications**: ineffective erythropoiesis → marrow expansion (skull bossing, chipmunk facies), extramedullary hematopoiesis, hypersplenism; iron overload from transfusions + GI absorption — endocrine + cardiac + liver dysfunction; (9) **Treatment**: - **Transfusion** to suppress endogenous erythropoiesis (target Hb 9-10 pre-tx); - **Iron chelation** — deferoxamine SC, deferasirox PO, deferiprone PO — based on ferritin + MRI T2* (cardiac + liver iron); - **Splenectomy** for hypersplenism (vaccines + prophylactic ABX); - **Luspatercept** (β-thal — BELIEVE trial); - **Curative**: allo-HCT (children matched donor); **gene therapy** Casgevy + Zynteglo (betibeglogene); (10) **Prenatal screening + counseling** essential — Thailand national policy

---

Thalassemia: severe microcytic + target/teardrop + nRBCs; Hb typing diagnostic; normal/high Fe+ferritin (vs IDA). β-thal major Cooley''s, β-thal/HbE common Thai. Tx: transfusion + chelation + luspatercept; allo-HCT + gene therapy (Zynteglo, Casgevy) curative. Prenatal screening Thai policy.', NULL,
  'hard', 'hematopathology', 'review',
  'pathology', 'clinical_decision', 'hematopathology', 'mixed',
  'TIF Thalassemia Guidelines; Thai NHSO Thalassemia Program', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยเด็กไทยอายุ 6 ปี — pallor + jaundice + splenomegaly; CBC: Hb 6, MCV 60, MCH 18; smear: severe microcytic + target cells + tear drops + nucleated RBCs; Hb typing: HbE 25%, HbF 60%, HbA2 5%, HbA 0%, HbH small amount; molecular: β-thal mutation + α-thal deletion'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิงอายุ 30 ปี — สงสัย AIHA → DAT (direct antiglobulin test) positive IgG + C3; warm autoantibody; CBC: Hb 7, retic 12%, smear: spherocytes + polychromasia; LDH high, haptoglobin low, indirect bili high', '[{"label":"A","text":"Iron deficiency"},{"label":"B","text":"Autoimmune Hemolytic Anemia (AIHA)"},{"label":"C","text":"Refuse"},{"label":"D","text":"Thrombosis"},{"label":"E","text":"MDS"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Autoimmune Hemolytic Anemia (AIHA): (1) **Hemolysis markers**: anemia + reticulocytosis (compensatory) + LDH up + indirect bili up + haptoglobin low + urine hemosiderin (intravascular); (2) **DAT (direct Coombs)**: positive for IgG ± C3 (warm); C3 alone (cold); negative possible in some AIHA (DAT-neg); (3) **Smear**: spherocytes (warm AIHA) — Fc-mediated splenic clearance partial → loss of membrane; agglutination (cold); schistocytes if microangiopathic (different — TTP, HUS, DIC, mechanical valve); (4) **Types**: - **Warm AIHA** (~ 60-70%): IgG, optimal 37°C, extravascular hemolysis (spleen); idiopathic, lymphoproliferative (CLL, lymphoma — must rule out), SLE, drugs (alpha-methyldopa, penicillin, cephalosporin); - **Cold agglutinin disease** (CAD): IgM, optimal 4°C, intravascular hemolysis via complement; CAD primary (clonal lymphoproliferative — IGHV4-34 monoclonal IgM); secondary (Mycoplasma, EBV, lymphoma); - **Paroxysmal cold hemoglobinuria** (Donath-Landsteiner) — rare children post-viral; - **Mixed**, **drug-induced**; (5) **DAT-negative AIHA** ~ 5-10% — use enhanced techniques (gel column, flow); (6) **Workup for secondary**: CBC + smear, immunoglobulins, ANA, lymphadenopathy/splenomegaly assess (LDH, CT), HIV/hepatitis, drug review; PNH (flow CD55/CD59) consider if DAT-negative; (7) **Treatment**: - **Warm AIHA**: prednisone first-line; rituximab second-line (effective); IVIG less reliable; splenectomy (vaccines + prophy); thrombosis prophylaxis (high risk); transfusion if severe with best-match unit; - **CAD**: avoid cold + treat underlying; **sutimlimab** (anti-C1s, complement inhibitor — CARDINAL/CADENZA trials) approved 2022 + targets intravascular; rituximab ± bendamustine for clonal disease; steroids LESS effective in CAD vs warm; (8) **Multidisciplinary** including hematology + rheum/onc if secondary

---

AIHA: hemolysis markers + DAT positive. Warm (IgG, spleen, spherocytes) vs cold (IgM, complement, intravascular). Rule out secondary (lymphoproliferative). Warm: pred → rituximab. CAD: sutimlimab (anti-C1s) + rituximab. Thrombosis prophylaxis.', NULL,
  'medium', 'hematopathology', 'review',
  'pathology', 'clinical_decision', 'hematopathology', 'adult',
  'BSH AIHA 2023; ASH', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยหญิงอายุ 30 ปี — สงสัย AIHA → DAT (direct antiglobulin test) positive IgG + C3; warm autoantibody; CBC: Hb 7, retic 12%, smear: spherocytes + polychromasia; LDH high, haptoglobin low, indirect bili high'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี — pleural effusion → thoracentesis 1.5 L → fluid sent: cytology + cell count + chemistry + culture + flow cytometry; results: lymphocyte-predominant + protein 5.2 + LDH 450 + cytology malignant cells; Light''s criteria + cytology workflow', '[{"label":"A","text":"ไม่ส่ง"},{"label":"B","text":"Pleural Effusion Cytology + Workup"},{"label":"C","text":"Random Tx"},{"label":"D","text":"Refuse"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pleural Effusion Cytology + Workup: (1) **Light''s criteria for exudate vs transudate** (any 1 of 3): - Pleural/serum protein > 0.5; - Pleural/serum LDH > 0.6; - Pleural LDH > 2/3 upper limit of normal serum LDH; (2) **Transudates**: CHF, cirrhosis, nephrotic, hypoalbuminemia; (3) **Exudates**: infection (parapneumonic, empyema, TB), malignancy, PE, autoimmune (RA, lupus), pancreatitis, chylothorax, hemothorax; (4) **Tests on pleural fluid**: protein + LDH + glucose + pH; cell count + differential; cytology + cell block; gram stain + bacterial culture; AFB smear + culture (TB); fungal; adenosine deaminase (TB suggestive); triglyceride (chyle); amylase (esophageal/pancreatic); flow cytometry (lymphoproliferative); biomarkers — selected; (5) **Cytology yield malignant**: ~ 60-80% with adequate sample (≥ 1 sample; high volume aspirated 60-100 mL); cell block essential — better morphology + IHC opportunity; (6) **Common malignancies metastatic to pleura**: lung > breast > GI > GU > lymphoma > others; mesothelioma primary; (7) **Mesothelioma workup**: thoracoscopic biopsy preferred (cytology limited); IHC mesothelial (calretinin+, WT1+, D2-40+, CK5/6+, mesothelin+) vs adenocarcinoma (CEA+, BerEP4+, MOC31+, TTF-1+, claudin-4+); (8) **PD-L1 + biomarker** testing on cell block adequate samples — increasingly important; (9) **Flow cytometry for lymphocyte-predominant** rule out lymphoma; (10) **TB pleuritis** in Thailand consideration — high ADA, lymphocyte-predominant, low glucose, AFB low yield in fluid — pleural biopsy higher yield; (11) **Multidisciplinary**: pulm + path + onc + ID; (12) **Indwelling pleural catheter** for recurrent malignant effusion

---

Pleural fluid: Light''s criteria (exudate vs transudate). Tests: protein/LDH/cyto/culture/ADA/flow. Cell block for IHC. Malignancy panel: meso markers vs adenoca markers. TB: ADA + lymphocytic + biopsy higher yield. PD-L1 on cell block. Multidisciplinary.', NULL,
  'medium', 'cytopathology', 'review',
  'pathology', 'clinical_decision', 'cytopathology', 'adult',
  'ATS/ACCP/ERS Pleural; Papanicolaou Society', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี — pleural effusion → thoracentesis 1.5 L → fluid sent: cytology + cell count + chemistry + culture + flow cytometry; results: lymphocyte-predominant + protein 5.2 + LDH 450 + cytology malignant cells; Light''s criteria + cytology workflow'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 40 ปี — thyroid nodule 2 cm → FNA → Bethesda categories interpretation + recommendations + reflex molecular testing', '[{"label":"A","text":"All FNA = surgery"},{"label":"B","text":"Bethesda System for Thyroid Cytopathology (2023)"},{"label":"C","text":"All FNA = nothing"},{"label":"D","text":"Skip"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bethesda System for Thyroid Cytopathology (2023): (1) **6 Categories with malignancy risk + management**: - **I — Non-diagnostic** (5-10%); ROM 13% (5-20%); → repeat FNA with US guidance; - **II — Benign** (60-70%); ROM < 4%; → clinical/US surveillance; - **III — Atypia of undetermined significance (AUS)** (~ 10%); ROM 22% (13-30% — wide); → **molecular testing** (Afirma GSC, ThyroSeq, ThyGeNEXT/ThyraMIR) preferred OR repeat FNA OR lobectomy; - **IV — Follicular neoplasm/SFN** (5-10%); ROM 30% (23-34%); → **molecular testing** preferred OR lobectomy; - **V — Suspicious for malignancy** (~ 5%); ROM 74% (67-83%); → lobectomy or near-total thyroidectomy; - **VI — Malignant** (~ 5%); ROM 97% (97-99%); → thyroidectomy ± central neck dissection; (2) **NIFTP carve-out** affects malignancy risks; (3) **Molecular testing for III + IV** (refines management): - **High-risk mutations** (BRAF V600E, TERT promoter, TP53, fusions ALK/RET/NTRK) → surgery + extent guided; - **RAS-like, intermediate**, **benign signature** — lobectomy or surveillance; - Negative predictive value high — rule out malignancy + reduce unnecessary surgery; (4) **US risk stratification** (TI-RADS, ATA) determines FNA threshold and adds info; (5) **Special considerations**: pediatric (lower thresholds), pregnancy (defer if safe), graves; (6) **Multidisciplinary**: endocrinology + endo surgery + cytopathology + radiology; (7) **Active surveillance** for low-risk papillary microcarcinoma emerging

---

Bethesda 2023 thyroid: 6 categories (I non-diag, II benign, III AUS, IV FN/SFN, V susp, VI malignant) with ROM + mgmt. III + IV → molecular testing (Afirma/ThyroSeq) refines decisions. US risk strat (TI-RADS/ATA). Multidisciplinary.', NULL,
  'medium', 'cytopathology', 'review',
  'pathology', 'clinical_decision', 'cytopathology', 'adult',
  'Bethesda Thyroid 2023; ATA 2015', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 40 ปี — thyroid nodule 2 cm → FNA → Bethesda categories interpretation + recommendations + reflex molecular testing'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 45 ปี — septic shock — blood cultures growing gram-positive cocci in clusters; → identification + susceptibility — MRSA suspected; lab workflow + reporting + antimicrobial stewardship', '[{"label":"A","text":"Skip lab"},{"label":"B","text":"Blood Culture + Identification Workflow"},{"label":"C","text":"Discard"},{"label":"D","text":"No reporting"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Blood Culture + Identification Workflow: (1) **Gram stain on positive blood culture** — preliminary report ASAP (clusters → Staph; chains → Strep/Enterococcus; pairs → Strep pneumo; tetrads; rods); critical-value notification; (2) **Identification methods**: - **MALDI-TOF MS** (rapid, minutes from colonies — revolutionized clinical micro); - **Rapid molecular** (PCR — BioFire BCID2, Verigene, GeneXpert) directly from positive bottle — 1-2 hr ID + select resistance markers (mecA for MRSA, vanA/B for VRE, KPC, NDM, OXA, CTX-M for ESBL/CRE); - **Conventional biochemical + culture** still backup; (3) **Susceptibility testing (AST)**: - **Phenotypic** (MIC by broth microdilution, gradient/Etest, automated systems Vitek/Phoenix); reference standard; - **Rapid AST** emerging (Accelerate Pheno, MicroScan rapid panels) — faster than 18-24h; - **Disk diffusion (Kirby-Bauer)** still used; - **CLSI / EUCAST breakpoints** updated annually; (4) **MRSA**: mecA/mecC encoded PBP2a → cefoxitin/oxacillin resistant; treat with vancomycin (target trough 15-20 or AUC/MIC 400-600), daptomycin (not pulmonary — surfactant inactivates), linezolid, ceftaroline, dalbavancin, oritavancin; (5) **Communication + stewardship**: - Critical-value calls for blood culture positive — rapid impact; - **Antimicrobial stewardship** consult/intervention — narrow when susceptibilities back; de-escalation; - **Source control** essential (line, abscess, endocarditis workup); (6) **TAT goals**: blood culture detection within hours (continuous monitoring systems — BacT/Alert, BACTEC); gram stain reported same day; preliminary ID + AST same day with rapid methods; (7) **Contamination vs true positive**: skin flora (CoNS, diphtheroids, Cutibacterium) — single bottle, late time-to-positivity → consider contamination + clinical context; (8) **Quality**: contamination rates < 3% target; volume adequate (≥ 10 mL/bottle adults); two sets

---

Blood culture: gram stain immediate, MALDI-TOF + rapid molecular (BCID2 detects mecA MRSA). Phenotypic AST CLSI/EUCAST. MRSA → vancomycin (not dapto for pulm). Critical-value + stewardship + source control. Contamination < 3% target.', NULL,
  'medium', 'microbiology', 'review',
  'pathology', 'clinical_decision', 'microbiology', 'adult',
  'CLSI; IDSA; ASM Cumitech', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 45 ปี — septic shock — blood cultures growing gram-positive cocci in clusters; → identification + susceptibility — MRSA suspected; lab workflow + reporting + antimicrobial stewardship'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี — fever + headache + neck stiffness → LP: CSF cloudy, WBC 2500/µL (90% PMN), protein 250, glucose 20 (serum 90); gram stain: gram-negative diplococci; การวินิจฉัยและการรักษา + lab workflow', '[{"label":"A","text":"Viral meningitis"},{"label":"B","text":"Bacterial Meningitis — Lab + Treatment"},{"label":"C","text":"Refuse"},{"label":"D","text":"Tumor"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bacterial Meningitis — Lab + Treatment: (1) **CSF profile**: - **Bacterial**: cloudy, WBC > 1000 PMN-predominant, protein > 100, glucose < 40 (CSF/serum < 0.4); - **Viral**: clear, WBC 10-1000 lymphocyte-predominant, protein normal-mildly elevated, glucose normal; - **TB**: lymphocytic, protein very high, glucose low, ADA elevated; - **Fungal**: lymphocytic, similar to TB; cryptococcal — India ink, antigen, culture; (2) **Gram stain CSF morphology** clues: - GPC pairs lancet — Strep pneumoniae; - **GNDC — Neisseria meningitidis** (this case); - GNCB — Haemophilus influenzae (rare post-Hib vaccine); - GPB short — Listeria (elderly, pregnant, immunosup); - Pleomorphic GNB — others; (3) **N. meningitidis (meningococcal) — critical management**: - **Treatment**: ceftriaxone + vancomycin + dexamethasone (decreases neuro outcomes Strep pneumo; less benefit meningococcal but typically given empirically); - **Penicillin G** susceptible historically but resistance emerging; - **Chemoprophylaxis** close contacts: rifampin / ciprofloxacin / ceftriaxone (single dose); - **Reportable** to public health; vaccine recommendations to outbreak community; (4) **Empiric meningitis Tx by age/risk**: - Adult: ceftriaxone + vancomycin (± ampicillin if Listeria risk — > 50, immunosup, pregnant) + dexamethasone; - Steroid-responsive: pneumococcal; - Post-neurosurgical/trauma: add anti-pseudomonal (cefepime/meropenem); vancomycin; (5) **Workup**: blood cultures × 2; CT before LP if focal deficits, papilledema, immunocompromised, recent seizure, altered LOC; (6) **Molecular**: BioFire ME panel — rapid multiplex PCR; (7) **PCR + cultures + sensitivities**; (8) **Severe complications**: cerebritis, abscess, hydrocephalus, sequelae (hearing loss); (9) **Vaccination**: pneumococcal, Hib, meningococcal (MCV4 + Men B); (10) **Multidisciplinary**: ID + neurology + IM + public health

---

Bacterial meningitis: cloudy CSF, PMN, low glucose, high protein. GNDC = N. meningitidis. Empiric ceftriaxone + vanco ± amp (Listeria) + dexamethasone. Meningococcal: reportable, chemoprophylaxis contacts. BioFire ME panel rapid. CT before LP if focal/immunosup.', NULL,
  'medium', 'microbiology', 'review',
  'pathology', 'clinical_decision', 'microbiology', 'adult',
  'IDSA Meningitis; CDC ACIP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี — fever + headache + neck stiffness → LP: CSF cloudy, WBC 2500/µL (90% PMN), protein 250, glucose 20 (serum 90); gram stain: gram-negative diplococci; การวินิจฉัยและการรักษา + lab workflow'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี hepatitis + cirrhosis → labs: total bili 12, direct 9, AST 145, ALT 95, ALP 280, GGT 350, albumin 2.8, INR 1.8, plt 80; interpretation + cause workup', '[{"label":"A","text":"ไม่ต้องวิเคราะห์"},{"label":"B","text":"Liver Function Test (LFT) Interpretation"},{"label":"C","text":"Refuse"},{"label":"D","text":"Skip"},{"label":"E","text":"Random"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Liver Function Test (LFT) Interpretation: (1) **Hepatocellular pattern**: AST + ALT markedly elevated (> 3-5× ULN); R ratio = (ALT/ULN) / (ALP/ULN) > 5; causes — viral, drug (acetaminophen acute, isoniazid), ischemic, autoimmune, Wilson''s, alpha-1 AT; (2) **Cholestatic pattern**: ALP + GGT elevated > AST/ALT (R < 2); causes — extrahepatic (CBD stone, stricture, malignancy) vs intrahepatic (PBC, PSC, drug, infiltrative, sepsis); GGT confirms ALP hepatic vs bone origin; (3) **Mixed pattern**: R 2-5; (4) **AST/ALT ratio**: - > 2 — alcoholic liver disease (AST > ALT due to pyridoxal deficit + mitochondrial); - > 1 + low absolute — cirrhosis; - < 1 typical for NAFLD/MASLD + viral hepatitis (acute); (5) **Bilirubin**: - **Unconjugated** (indirect) — hemolysis, Gilbert''s, Crigler-Najjar; - **Conjugated** (direct) — hepatocellular dysfunction, cholestasis, Dubin-Johnson, Rotor; (6) **Synthetic function**: albumin, INR/PT (vitamin K-dependent factors — half-life 6h for factor VII, sensitive); platelets (hypersplenism, thrombopoietin decreased); (7) **Cirrhosis labs**: low albumin + elevated INR + thrombocytopenia + low Na (advanced); MELD (bili + Cr + INR + Na) for prognosis + transplant priority; Child-Pugh A/B/C; (8) **Etiology workup**: - **Viral**: HBV (HBsAg, anti-HBc, HBV DNA), HCV (Ab + RNA), HAV/HEV; - **Alcohol** history + AUDIT; - **Metabolic**: NAFLD/MASLD (US + transient elastography), Wilson''s (ceruloplasmin + 24h urine Cu < 40 yo), hemochromatosis (ferritin + sat + HFE), alpha-1 AT phenotype; - **Autoimmune**: ANA, ASMA, anti-LKM, IgG, AMA (PBC), p-ANCA (PSC); MRCP for PSC; - **Drug-induced** review (LiverTox); (9) **Imaging**: US + Doppler; MRI/MRCP; transient elastography; (10) **Cirrhosis surveillance**: HCC US ± AFP q6 mo, varices EGD, encephalopathy + ascites screening

---

LFT: hepatocellular (AST/ALT↑, R>5) vs cholestatic (ALP/GGT↑, R<2) vs mixed. AST/ALT ratio >2 alcohol. Bili direct vs indirect. Synthetic (albumin, INR). Cirrhosis: MELD, Child-Pugh. Etiology workup: viral/metabolic/autoimmune/drug + imaging. Surveillance HCC/varices.', NULL,
  'medium', 'clinical_chemistry', 'review',
  'pathology', 'clinical_decision', 'clinical_chemistry', 'adult',
  'AASLD LFT; ACG Abnormal Liver Tests', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี hepatitis + cirrhosis → labs: total bili 12, direct 9, AST 145, ALT 95, ALP 280, GGT 350, albumin 2.8, INR 1.8, plt 80; interpretation + cause workup'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี post-op day 1 hip replacement — Hb 6.8 → ordered 2 units PRBC; blood bank workflow + compatibility + acute hemolytic + non-hemolytic transfusion reactions', '[{"label":"A","text":"Random unit"},{"label":"B","text":"Transfusion Medicine — Compatibility + Reactions"},{"label":"C","text":"Skip ID"},{"label":"D","text":"Refuse"},{"label":"E","text":"Discard"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Transfusion Medicine — Compatibility + Reactions: (1) **Pre-transfusion testing**: - **ABO/Rh typing** (forward + reverse — confirm match); - **Antibody screen** (3-cell panel detects clinically significant alloantibodies); - **Crossmatch** (donor + recipient): immediate spin (ABO confirm), antiglobulin (full match if antibody+), electronic crossmatch (if validated); - **Type & screen** valid 72 hours post-transfusion/pregnancy (new antibodies); (2) **Component selection**: - **PRBC**: ABO compatible (not necessarily identical for ABO if no whole blood); Rh-matched for Rh-neg recipients (especially women childbearing); - **Platelets**: ABO ideally matched (plasma in unit), Rh-matched for Rh-neg women childbearing (small RBC contamination → anti-D); - **FFP**: ABO match (plasma — donor anti-A/B → recipient RBCs); - **Cryoprecipitate**: ABO match preferred; (3) **Indication-based use** + restrictive transfusion (Hb < 7 stable, < 8 cardiac/symptomatic); single-unit then reassess; (4) **Pre-transfusion patient identification — two patient identifiers** at issue + bedside (wrong patient = most common cause of fatal hemolytic reaction); (5) **Acute transfusion reactions**: - **Acute hemolytic (ABO mismatch)**: fever, hypotension, pain, hemoglobinuria, DIC, renal failure; STOP transfusion + maintain IV access + saline + monitor — workup + report blood bank; - **FNHTR** (febrile non-hemolytic): cytokines + recipient anti-leukocyte Abs; leukoreduced products reduce; antipyretic; - **Allergic/urticarial**: histamines (donor plasma); antihistamine ± slow + continue if mild; severe → epinephrine; - **TRALI** (transfusion-related acute lung injury): ARDS within 6 h, donor anti-HLA/HNA Abs to recipient leukocytes; leading cause transfusion mortality; supportive; male-predominant plasma policy reduced; - **TACO** (transfusion-associated circulatory overload): volume + cardiac; furosemide + slow rate; common in elderly; - **Bacterial sepsis** (platelet > RBC); - **Anaphylaxis** (IgA-deficient + anti-IgA — wash or use IgA-deficient donor); (6) **Delayed reactions**: delayed hemolytic (3-14 d, anamnestic), GvHD (irradiate for at-risk — immunocompromised, neonates, intrauterine, directed donors, HLA-matched units), iron overload (chronic — chelation), alloimmunization, post-transfusion purpura, infectious; (7) **Hemovigilance** + reporting + RCA

---

Transfusion: type/screen/crossmatch + ABO/Rh; two-identifier ID bedside (wrong pt → fatal hemolytic). Acute reactions: hemolytic, FNHTR, allergic, TRALI (leading mortality), TACO, sepsis. Delayed: hemolytic, GvHD (irradiate), iron overload. Hemovigilance.', NULL,
  'hard', 'transfusion', 'review',
  'pathology', 'clinical_decision', 'transfusion', 'adult',
  'AABB; ASH; TJC NPSGs', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี post-op day 1 hip replacement — Hb 6.8 → ordered 2 units PRBC; blood bank workflow + compatibility + acute hemolytic + non-hemolytic transfusion reactions'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย trauma + hemorrhagic shock — activate massive transfusion protocol (MTP); ratio + monitoring + adjuncts + lab role', '[{"label":"A","text":"PRBC only"},{"label":"B","text":"Massive Transfusion Protocol (MTP)"},{"label":"C","text":"FFP only"},{"label":"D","text":"Crystalloid only"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Massive Transfusion Protocol (MTP): (1) **Definition**: > 10 units PRBC/24 h OR > 4 units in 1 h OR replacement of patient''s blood volume; activate early; (2) **Ratio-based resuscitation**: **1:1:1 (PRBC : FFP : platelet apheresis units)** — based on PROPPR trial — improved hemostasis (vs 1:1:2); mimics whole blood; (3) **Whole blood (low-titer group O whole blood — LTOWB)** increasingly used in military + trauma centers — single-product simpler logistics; (4) **Adjuncts**: - **Tranexamic acid (TXA)** — 1 g IV bolus + 1 g over 8h within 3 h of trauma (CRASH-2/3); reduces mortality; - **Calcium replacement** — massive citrate (anticoagulant in blood products) chelates ionized Ca → hypocalcemia → contractility + coag impaired — monitor + replace with CaCl2 or Ca gluconate; - **Warm products + patient** — prevent hypothermia (coag impaired below 35°C); - **Bicarbonate / pH management** — acidosis impairs coag (lethal triad: acidosis + hypothermia + coagulopathy); (5) **Damage control resuscitation principles**: permissive hypotension (SBP 80-90 if no head injury) until surgical control; hemostatic resuscitation; limit crystalloid (worsens coagulopathy + edema); (6) **Lab role + monitoring**: - **Fast turnaround**: CBC, PT/PTT/INR, fibrinogen, blood gas, ionized Ca, lactate q15-30 min; - **TEG/ROTEM** viscoelastic — guides product use (fibrinogen, platelet, factor) more dynamically than conventional coag tests; - **Communication** with blood bank — anticipate need + prepare products; - **Universal donor** (O- for women + men with unknown, O+ for men) for emergency release before type/screen ready; (7) **Targeted fibrinogen replacement**: cryoprecipitate or fibrinogen concentrate if fibrinogen < 1.5-2 g/L; (8) **PCC (4-factor)** + vitamin K for anticoagulant reversal; (9) **Reassess + deactivate** when bleeding controlled; (10) **Multidisciplinary**: trauma surgery + anesthesia + blood bank + lab + ED + ICU

---

MTP: 1:1:1 PRBC:FFP:plt (PROPPR); LTOWB emerging. TXA within 3h (CRASH-2/3). Calcium replacement (citrate chelation). Warm + correct acidosis (lethal triad). TEG/ROTEM-guided. Damage control resuscitation; limit crystalloid. Universal O- emergency.', NULL,
  'medium', 'transfusion', 'review',
  'pathology', 'clinical_decision', 'transfusion', 'mixed',
  'PROPPR; CRASH-2/3; AABB MTP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วย trauma + hemorrhagic shock — activate massive transfusion protocol (MTP); ratio + monitoring + adjuncts + lab role'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 35 ปี — recurrent nosebleeds + heavy menses + family history of bleeding → coagulation workup: PT normal, aPTT mildly prolonged, platelet count normal, BT prolonged, vWF antigen low, vWF activity (RCo) low, factor VIII low; การวินิจฉัย', '[{"label":"A","text":"Hemophilia A"},{"label":"B","text":"von Willebrand Disease (vWD) — Pathology + Diagnosis"},{"label":"C","text":"ITP"},{"label":"D","text":"TTP"},{"label":"E","text":"DIC"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** von Willebrand Disease (vWD) — Pathology + Diagnosis: (1) **Background**: most common inherited bleeding disorder (~ 1%); autosomal (dominant typically); mucocutaneous bleeding (nosebleed, menses, GI, post-procedure); (2) **vWF function**: - **Platelet adhesion** at vascular injury (binds collagen + GPIb on platelets); - **Factor VIII carrier** (protects from degradation) — explains low FVIII in severe vWD; (3) **Classification**: - **Type 1** (partial quantitative — ~ 75%): vWF Ag + activity low (parallel); mild; - **Type 2** (qualitative — abnormal vWF): subtypes 2A (loss of large multimers), 2B (gain-of-function platelet binding — thrombocytopenia), 2M (loss of platelet binding without multimer abnormality), 2N (defective FVIII binding — mimics hemophilia); - **Type 3** (severe quantitative — virtually absent): autosomal recessive; severe joint bleeding-like hemophilia A; (4) **Lab workup**: - vWF antigen (vWF:Ag); - vWF activity (vWF:RCo ristocetin cofactor — measures platelet binding function; alternatives GPIbM, GPIbR); - **vWF:Ag / vWF:RCo ratio** distinguishes types (< 0.7 = qualitative defect type 2); - Factor VIII level; - **Multimer analysis** for type 2 distinction; - **Platelet function** (PFA-100 — closure time prolonged but not specific); - **Bleeding score** (ISTH); (5) **Pitfalls**: vWF is acute-phase reactant — false-normal in stress/pregnancy/OCP; blood type O ~ 25% lower baseline vWF; repeat testing; (6) **Acquired vWS**: aortic stenosis (shear), LVAD, MGUS, hypothyroidism, autoimmune; (7) **Treatment**: - **DDAVP (desmopressin)** — type 1 mild + selected type 2; releases endothelial vWF stores; test dose response; tachyphylaxis with repeat doses; - **vWF concentrate** (with or without FVIII — Humate-P, Wilate; recombinant vWF Vonvendi) for type 3, severe, surgical prophylaxis, type 2 unresponsive to DDAVP; - **Antifibrinolytic** (TXA) adjunct; - **OCP** for menorrhagia; - **Emicizumab** in development for vWD/hemophilia overlap; (8) **Multidisciplinary**: hematology + dental + OB-GYN + nurse coordinator

---

vWD: most common inherited bleeding. Types 1 (quantitative partial), 2 (qualitative — 2A/B/M/N), 3 (severe quant). vWF:Ag + RCo + FVIII + multimers + ratio. DDAVP for type 1; vWF concentrate for type 3/severe. TXA adjunct. Acquired vWS exists. Multidisciplinary.', NULL,
  'hard', 'coagulation', 'review',
  'pathology', 'clinical_decision', 'coagulation', 'mixed',
  'ASH/ISTH vWD 2021', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 35 ปี — recurrent nosebleeds + heavy menses + family history of bleeding → coagulation workup: PT normal, aPTT mildly prolonged, platelet count normal, BT prolonged, vWF antigen low, vWF activity (RCo) low, factor VIII low; การวินิจฉัย'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 30 ปี SLE — proteinuria + active sediment → kidney biopsy: glomeruli with endocapillary proliferation + wire loops + subendothelial deposits + ''full-house'' immunofluorescence (IgG, IgA, IgM, C3, C1q); EM: subendothelial deposits + tubuloreticular inclusions; classification', '[{"label":"A","text":"Diabetic nephropathy"},{"label":"B","text":"Lupus Nephritis (Class IV — Diffuse Proliferative) ISN/RPS Classification"},{"label":"C","text":"FSGS"},{"label":"D","text":"IgA nephropathy"},{"label":"E","text":"ATN"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Lupus Nephritis (Class IV — Diffuse Proliferative) ISN/RPS Classification: (1) **ISN/RPS 2003 (updated 2018) classification**: - **Class I**: minimal mesangial — normal LM, mesangial deposits IF/EM; - **Class II**: mesangial proliferative; - **Class III**: focal (< 50% glomeruli) proliferative; - **Class IV**: **diffuse (≥ 50%) proliferative** (this case) — endocapillary proliferation, wire loops, subendothelial deposits, fibrinoid necrosis, crescents — most aggressive; - **Class V**: membranous (subepithelial deposits like idiopathic MN but immune complex); - **Class VI**: advanced sclerosis (≥ 90%); - **Class III + V** and **IV + V** combinations; (2) **Activity + chronicity scores** (NIH) — guides treatment + prognosis; (3) **Immunofluorescence**: **''full-house''** (IgG + IgA + IgM + C3 + C1q) classic for lupus — distinguishes from idiopathic MN/MPGN; subendothelial in proliferative, subepithelial in membranous; (4) **EM**: subendothelial + mesangial deposits (proliferative); subepithelial (membranous); **tubuloreticular inclusions** in endothelial cells (interferon signature — lupus + viral); ''fingerprint'' deposits; (5) **Workup**: ANA, dsDNA (specific lupus), C3/C4 (low in active), Smith Ab, anti-phospholipid, urine sediment + UPCR, kidney biopsy when proteinuria > 0.5 g/d or active sediment with eGFR change; (6) **Treatment** (KDIGO 2021): - **Class III/IV induction**: mycophenolate (preferred) OR low-dose IV cyclophosphamide (Euro-Lupus) + steroids; ± **belimumab** (BLISS-LN) + standard; **voclosporin** (AURORA) + MMF + steroid — recent additions improve renal response; - **Class V**: MMF + RAS blockade ± steroids; - **Maintenance**: MMF or azathioprine + low-dose steroid; - **Refractory**: rituximab consideration (LUNAR negative but used); calcineurin inhibitors; (7) **Adjuncts**: HCQ all SLE (improves renal + extrarenal outcomes), RAS blockade, SGLT2 inhibitors (DAPA-CKD/EMPA-KIDNEY — proteinuria reduction), BP control; (8) **Pregnancy planning** + APS screening + LMWH if positive

---

Lupus nephritis: ISN/RPS Class I-VI; class IV diffuse proliferative most aggressive. Full-house IF + TR inclusions hallmark. Activity + chronicity scores. Induction: MMF or low-dose CYC + steroids ± belimumab or voclosporin (new). HCQ + RAS blockade + SGLT2.', NULL,
  'hard', 'renal_pathology', 'review',
  'pathology', 'clinical_decision', 'renal_pathology', 'adult',
  'ISN/RPS 2018; KDIGO Lupus 2021; AURORA; BLISS-LN', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 30 ปี SLE — proteinuria + active sediment → kidney biopsy: glomeruli with endocapillary proliferation + wire loops + subendothelial deposits + ''full-house'' immunofluorescence (IgG, IgA, IgM, C3, C1q); EM: subendothelial deposits + tubuloreticular inclusions; classification'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 28 ปี — gross hematuria 2 d after URI → kidney biopsy: mesangial proliferation + dominant IgA deposits on IF + electron-dense deposits in mesangium; การวินิจฉัยและการรักษา', '[{"label":"A","text":"Lupus"},{"label":"B","text":"IgA Nephropathy (Berger''s)"},{"label":"C","text":"Minimal change"},{"label":"D","text":"ATN"},{"label":"E","text":"FSGS"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** IgA Nephropathy (Berger''s): (1) **Most common primary glomerulonephritis worldwide**; (2) **Clinical**: gross hematuria post-URI (synpharyngitic — within days vs PSGN 1-2 wk after); microscopic hematuria + proteinuria + variable BP + Cr; can present as nephrotic + crescentic RPGN + AKI; (3) **Histology**: - **LM**: mesangial hypercellularity + matrix expansion; segmental sclerosis; crescents in severe; - **IF**: dominant or codominant **IgA** in mesangium (must be dominant); ± IgG, IgM, C3; C1q usually absent (vs lupus); - **EM**: electron-dense deposits mesangial (predominant) ± subendothelial in active disease; (4) **Pathogenesis**: galactose-deficient IgA1 + IgG autoantibodies → mesangial deposition + injury; (5) **Oxford classification (MEST-C)** scoring: Mesangial hypercellularity, Endocapillary hypercellularity, Segmental sclerosis, Tubular atrophy/interstitial fibrosis, Crescents — guides prognosis + treatment; (6) **Spectrum**: includes IgA vasculitis (formerly HSP) — same pathology with extrarenal (palpable purpura, arthralgia, GI) — more common children; (7) **Workup**: rule out secondary (cirrhosis, HIV, celiac), complement (C3/C4 usually normal), serologies; (8) **Treatment** (KDIGO 2021/2024 update): - **Supportive (foundation)**: RAS blockade (ACE/ARB) maximally tolerated to lower proteinuria + BP; salt restriction; BMI; smoking cessation; - **SGLT2 inhibitors** (dapagliflozin DAPA-CKD, empagliflozin EMPA-KIDNEY) — recommended for proteinuric CKD; reduce progression; - **Endothelin antagonists** (sparsentan PROTECT) — newer, approved; - **Targeted-release budesonide (Nefecon TARGET-A)** — gut-targeted, approved for high-risk progressive — addresses mucosal IgA; - **Systemic immunosuppression** controversial — for crescentic/rapidly progressive only typically (steroids; ± rituximab/MMF); - **Anti-complement** (iptacopan — for IgAN, MN under study) emerging; (9) **Renal transplant** for ESRD — recurs in graft ~ 30%; (10) **Multidisciplinary** nephrology + pathology + dietitian

---

IgA nephropathy: most common 1° GN; synpharyngitic hematuria. Mesangial IgA-dominant IF + mesangial deposits. Oxford MEST-C scoring. Tx: RAS blockade + SGLT2 + sparsentan + Nefecon (gut-targeted budesonide). Anti-complement emerging. Transplant recurs ~30%.', NULL,
  'medium', 'renal_pathology', 'review',
  'pathology', 'clinical_decision', 'renal_pathology', 'adult',
  'KDIGO Glomerular 2021/2024; PROTECT; TARGET-A', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 28 ปี — gross hematuria 2 d after URI → kidney biopsy: mesangial proliferation + dominant IgA deposits on IF + electron-dense deposits in mesangium; การวินิจฉัยและการรักษา'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี — frontal mass + altered mental status; biopsy: glial tumor + nuclear atypia + microvascular proliferation + necrosis with palisading; IHC: GFAP+, ATRX retained, IDH-1 R132H NEGATIVE; molecular: TERT promoter mutated, EGFR amplified, +7/-10', '[{"label":"A","text":"Meningioma"},{"label":"B","text":"Glioblastoma, IDH-wildtype (WHO grade 4) — CNS5 Classification 2021"},{"label":"C","text":"Lymphoma"},{"label":"D","text":"Mets"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Glioblastoma, IDH-wildtype (WHO grade 4) — CNS5 Classification 2021: (1) **WHO CNS5 (2021) integrates molecular + histology**: layered diagnosis (histopathological + CNS WHO grade + molecular); (2) **Adult-type diffuse gliomas (3 types)**: - **Astrocytoma, IDH-mutant** (grade 2, 3, or 4); - **Oligodendroglioma, IDH-mutant, 1p/19q-codeleted** (grade 2 or 3); - **Glioblastoma, IDH-wildtype** (grade 4) — most common, worst prognosis; (3) **Glioblastoma criteria** (IDH-WT adult): histologic — microvascular proliferation OR necrosis OR molecular features even in lower-grade morphology — **TERT promoter mutation, EGFR amplification, +7/-10** = grade 4 / glioblastoma regardless of morphology; (4) **IHC + molecular workup**: - **IDH1 R132H IHC** (most common, ~ 90% IDH-mutant); negative needs sequencing to rule out non-canonical; - **ATRX** loss (in IDH-mutant astrocytoma); - **GFAP, OLIG2, SOX2** (glial markers); - **MGMT promoter methylation** (predictive of TMZ response, prognostic); - **p53** (often mutated IDH-mutant astrocytoma); - **TERT promoter, EGFR, +7/-10** (GBM); - **1p/19q codeletion** (oligo); - **H3 K27M** for diffuse midline glioma; H3 G34 for diffuse hemispheric glioma; **CDKN2A/B homozygous deletion** (worsens grade in IDH-mutant astrocytoma to grade 4); (5) **Treatment GBM** (newly diagnosed): - **Maximal safe resection** (5-ALA fluorescence guided improves); - **Adjuvant radiotherapy + concurrent + adjuvant temozolomide** (Stupp protocol); - **Tumor treating fields (TTFields, Optune)** added — EF-14 trial — survival benefit; - **MGMT methylation** predicts TMZ benefit; (6) **Recurrent**: bevacizumab, lomustine, regorafenib, re-resection/RT; clinical trials; (7) **IDH-mutant gliomas**: now **vorasidenib** (INDIGO trial) — IDH1/2 inhibitor — significant PFS improvement grade 2 IDH-mutant — emerging standard pre-RT/chemo selection; (8) **Multidisciplinary**: neurosurgery + neuro-onc + RT + neuropath + neuro-radiology

---

GBM IDH-WT WHO CNS5 grade 4: TERT/EGFR/+7-10 = GBM even without classic histology. IDH/ATRX/MGMT/1p19q workup. Stupp (RT+TMZ) + TTFields. MGMT methylation predicts TMZ. Vorasidenib INDIGO for IDH-mutant. Multidisciplinary.', NULL,
  'hard', 'neuropathology', 'review',
  'pathology', 'clinical_decision', 'neuropathology', 'adult',
  'WHO CNS5 2021; Stupp; EF-14 TTFields; INDIGO', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี — frontal mass + altered mental status; biopsy: glial tumor + nuclear atypia + microvascular proliferation + necrosis with palisading; IHC: GFAP+, ATRX retained, IDH-1 R132H NEGATIVE; molecular: TERT promoter mutated, EGFR amplified, +7/-10'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Medical examiner — sudden death 35 yo male found in apartment; postmortem exam + cause of death + manner determination workflow + toxicology + scene investigation', '[{"label":"A","text":"Skip"},{"label":"B","text":"Medical Examiner Forensic Autopsy Workflow"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"No exam"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Medical Examiner Forensic Autopsy Workflow: (1) **Jurisdiction**: cases requiring ME — sudden, unexpected, unattended, traumatic (accident, suicide, homicide), in-custody, suspicious, occupational, public health concern, no recent attending physician; varies by state/country; (2) **Scene investigation + history**: scene visit if possible (death scene context, position, ligatures, evidence, drugs), interview family/witnesses, medical history review, social history, medications, prior incidents; (3) **External examination**: identification (visual, fingerprint, dental, DNA), photographs, livor + rigor + algor (postmortem changes — estimate PMI), injuries documented (location, type, age — antemortem vs postmortem distinction), tattoos + scars; (4) **Internal examination**: full autopsy — gross + histology all organs; brain (after fixation 2-3 wk if neuropathology); cardiac (weight, valve circumferences, coronaries, conduction); pulmonary; abdominal; (5) **Specimen collection (toxicology)**: blood (peripheral femoral preferred, central caval less ideal), urine, vitreous (most stable PMI changes, alcohol), bile, liver, hair (chronic), gastric contents; preserved + sealed; (6) **Toxicology** (essential many cases): comprehensive screen + targeted (opioids, fentanyl analogs critical given opioid epidemic; stimulants; ethanol; sedatives; psychotropic), confirmatory mass spec; (7) **Ancillary**: microbiology (sudden infant death, sepsis), microbiology + viral (sudden), histology, neuropathology, cardiac pathology (channelopathy/CM molecular autopsy — saved blood for genetic), ophthalmology (retinal hemorrhage — pediatric abusive head trauma); (8) **Cause of death** (immediate, contributing) + **Manner** (natural, accident, suicide, homicide, undetermined); (9) **Report + death certificate**; (10) **Communication**: family, law enforcement, courts (expert testimony); (11) **Molecular autopsy**: sudden cardiac death — genetic testing for LQTS, CPVT, HCM, ARVC; sudden unexplained infant death; collaboration with cardiology genetic; (12) **Education + quality**: institutional QI, NAME accreditation

---

ME autopsy: jurisdiction + scene + external + internal exam. Tox specimens (peripheral blood, vitreous, urine, liver). COD (immediate/contrib) + manner (natural/accident/suicide/homicide/undetermined). Molecular autopsy for sudden cardiac. NAME standards.', NULL,
  'medium', 'forensic', 'review',
  'pathology', 'clinical_decision', 'forensic', 'adult',
  'NAME Forensic Autopsy Standards', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Medical examiner — sudden death 35 yo male found in apartment; postmortem exam + cause of death + manner determination workflow + toxicology + scene investigation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident question — fundamentals of platelet function + primary hemostasis pathway + clinical platelet function tests + clinical applications', '[{"label":"A","text":"Random"},{"label":"B","text":"Platelet Function + Primary Hemostasis"},{"label":"C","text":"No tests"},{"label":"D","text":"Skip"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Platelet Function + Primary Hemostasis: (1) **Primary hemostasis steps**: - **Adhesion**: vWF binds exposed collagen at injury → platelet GPIb/IX/V binds vWF → tethering; - **Activation**: ADP, thrombin, TxA2, collagen activate platelets → shape change (pseudopods), granule release, phospholipid exposure (PS); - **Aggregation**: GPIIb/IIIa activates + binds fibrinogen + vWF → platelet-platelet bridges; (2) **Granules**: alpha (P-selectin, fibrinogen, vWF, factor V, PDGF), dense (ADP, ATP, serotonin, calcium, polyphosphate); (3) **Receptors**: GPIb-IX-V (vWF), GPIIb/IIIa (fibrinogen — αIIbβ3 integrin), GPVI (collagen), P2Y12 (ADP — clopidogrel target), TxA2 receptor (aspirin target via COX-1); (4) **Primary hemostasis disorders**: - **Quantitative**: thrombocytopenia (production — BM failure, suppression; destruction — ITP, TTP, DIC; sequestration — splenomegaly); thrombocytosis (reactive vs MPN — ET, PV); - **Qualitative**: inherited — **Bernard-Soulier** (GPIb deficiency — large platelets, mild thrombocytopenia, vWF doesn''t bind), **Glanzmann thrombasthenia** (GPIIb/IIIa deficiency — aggregation absent), storage pool diseases (dense granule), Wiskott-Aldrich, MYH9-related; acquired — uremia, drugs (aspirin, clopidogrel/P2Y12i, NSAIDs, anti-GPIIb/IIIa); (5) **Tests**: - **Platelet count** (CBC); - **PFA-100/200** (closure time — adhesion-aggregation under shear — screen for vWD + qualitative defects); - **Light transmission aggregometry (LTA)** — gold standard agonist-induced aggregation (ADP, epi, collagen, ristocetin, arachidonic acid); - **Whole blood impedance aggregometry**; - **Flow cytometry** for receptors (GPIb, IIb/IIIa); - **Bleeding time** — obsolete; - **TEG/ROTEM** platelet contribution; - **VerifyNow** P2Y12 inhibition monitoring; (6) **Treatment for platelet disorders**: ITP (steroids, IVIG, TPO mimetics, splenectomy, rituximab), TTP (PLEX, caplacizumab, rituximab), inherited Glanzmann/Bernard-Soulier (DDAVP, antifibrinolytic, recombinant factor VIIa, platelet transfusion); (7) **Antiplatelet therapy review** + holding for procedures; spacious area

---

Primary hemostasis: adhesion (GPIb-vWF) → activation (granules) → aggregation (GPIIb/IIIa-fibrinogen). Tests: count, PFA, LTA, flow, TEG, VerifyNow. Disorders: thrombocytopenia (qty), Bernard-Soulier/Glanzmann/storage (qual), acquired (drugs/uremia). Tx by disorder.', NULL,
  'medium', 'coagulation', 'review',
  'pathology', 'basic_science', 'coagulation', 'mixed',
  'ISTH; ASH; AACC', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Resident question — fundamentals of platelet function + primary hemostasis pathway + clinical platelet function tests + clinical applications'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident question — fundamentals of coagulation cascade (extrinsic + intrinsic + common pathway) + clinical lab tests + new perspective (cell-based model)', '[{"label":"A","text":"Random"},{"label":"B","text":"Coagulation Cascade + Cell-Based Model"},{"label":"C","text":"Random"},{"label":"D","text":"Skip"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Coagulation Cascade + Cell-Based Model: (1) **Classical waterfall (pedagogical)**: - **Intrinsic** (contact): XII → XIIa → XI → XIa → IX → IXa + VIIIa → X activation; - **Extrinsic** (tissue factor): TF + VIIa → X activation; - **Common**: X → Xa + Va → prothrombin (II) → thrombin (IIa) → fibrinogen (I) → fibrin → cross-linked by XIIIa; (2) **Cell-based model (modern — Hoffman + Monroe 2001)** — physiologically accurate: - **Initiation**: TF-bearing cells (subendothelial) bind VIIa → small amount Xa → thrombin (priming); - **Amplification**: thrombin activates platelets + V + VIII + XI on platelet surface; - **Propagation**: massive thrombin burst on platelet surface → fibrin formation; - Highlights platelet-coag interaction + integration with primary hemostasis; (3) **Anticoagulant systems** (natural balance): - **Antithrombin** (inhibits IIa, Xa, IXa — heparin enhances); - **Protein C + S** (cleave Va + VIIIa); - **TFPI** (tissue factor pathway inhibitor); (4) **Fibrinolysis**: plasminogen → plasmin (by tPA, urokinase) → degrades fibrin → D-dimer; antagonized by PAI-1 + alpha-2 antiplasmin + TAFI; (5) **Clinical tests**: - **PT/INR**: extrinsic + common (factors VII, X, V, II, fibrinogen); standardized INR via ISI for warfarin monitoring; - **aPTT**: intrinsic + common (factors XII, XI, IX, VIII, X, V, II, fibrinogen); heparin monitoring; - **Thrombin time** (TT): fibrinogen step, prolonged in dysfibrinogenemia, heparin, DTIs; - **Fibrinogen** (Clauss); - **Mixing study** (1:1 with normal plasma): corrects = factor deficiency; doesn''t correct = inhibitor (factor inhibitor, lupus anticoagulant, DOAC, heparin); - **Specific factor levels**; - **Anti-Xa** for LMWH + DOAC (calibrated assays); - **TEG/ROTEM** viscoelastic — global function + real-time; - **D-dimer**: VTE rule-out, DIC; (6) **Disorders**: factor deficiencies (hemophilia A/B, factor VII, XI, fibrinogen), DIC, liver disease, vitamin K deficiency, anticoagulant drugs; (7) **Reversal**: vitamin K + 4F-PCC (warfarin), andexanet alfa (anti-Xa DOAC), idarucizumab (dabigatran), protamine (heparin); (8) **DOAC monitoring**: not routine; specialized assays when needed

---

Coag: classical waterfall (intrinsic/extrinsic/common) → cell-based model (initiation/amplification/propagation on platelet surface). PT (extrinsic) + aPTT (intrinsic) + TT + mixing study + fibrinogen + anti-Xa + TEG. Anti-thrombin/Protein C-S/TFPI natural. Reversal agents.', NULL,
  'medium', 'coagulation', 'review',
  'pathology', 'basic_science', 'coagulation', 'mixed',
  'ISTH; CLSI; Hoffman Cell-Based Model', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Resident question — fundamentals of coagulation cascade (extrinsic + intrinsic + common pathway) + clinical lab tests + new perspective (cell-based model)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident — pathology + role of cytopathology of body fluids — workflow + processing + diagnostic challenges; cell block vs liquid-based vs conventional smear', '[{"label":"A","text":"Skip"},{"label":"B","text":"Body Fluid Cytology Workflow + Processing"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Body Fluid Cytology Workflow + Processing: (1) **Specimen types**: pleural, peritoneal/ascitic, pericardial, CSF, urine, washings (bronchial, peritoneal, biliary, brush), FNA (thyroid, breast, lymph node, salivary, abdominal organs, pancreas EUS-FNA), bronchoalveolar lavage, fine needle washings; (2) **Pre-analytical**: prompt to lab (delay → cell degradation, lysis); refrigerate if delay; volume guides processing approach; (3) **Processing methods**: - **Conventional smear** (Pap + Diff-Quik) — fast, basic; - **Cytospin** — small volumes/CSF — concentrates cells; - **Liquid-based cytology** (ThinPrep, SurePath) — better preservation, less obscuring blood/mucus, allows ancillary studies; - **Cell block** (formalin-fixed, paraffin-embedded centrifuged sediment) — essential — provides histologic-quality sections for IHC + molecular; - **Direct smears for FNA** + needle rinse for cell block (best of both); (4) **Stains**: - **Papanicolaou** (transparent, nuclear detail) — primary; - **Diff-Quik** (rapid romanowsky) — rapid bedside, cytoplasm/mucin; - **Special stains** (PAS, mucicarmine, Alcian blue, Ziehl-Neelsen, GMS); - **IHC on cell block**; (5) **Diagnostic categories**: - Adequate specimen documented; - Benign vs atypical vs suspicious vs malignant; - Primary vs metastatic — IHC essential (e.g., CK7/CK20, TTF-1, GATA3, PAX8, etc.); (6) **Common challenges**: reactive vs malignant mesothelial (BAP1 loss, MTAP IHC + p16/CDKN2A FISH for mesothelioma vs reactive); adenocarcinoma vs mesothelioma panel; lymphoma assessment (flow cytometry on fresh fluid); (7) **Ancillary studies** on cell block + supernatant: IHC, FISH (e.g., HER2 in breast cancer effusion, MET in lung), molecular (EGFR/ALK/PD-L1 lung, KRAS pancreas, MSI), flow cytometry (lymphoproliferative); (8) **Reporting systems**: - Bethesda (cervical, thyroid); - Milan (salivary FNA); - Paris (urine cytology) — for urothelial; - International Pancreatic; - International FNA Breast; (9) **Quality assurance**: adequacy criteria, correlation with surgical, rapid on-site evaluation (ROSE) for FNA increases yield

---

Body fluid cyto: prompt to lab; conventional smear + cell block + liquid-based + cytospin. Pap + Diff-Quik. Cell block enables IHC + molecular. Reporting systems: Bethesda/Milan/Paris/Pancreatic/Breast. ROSE for FNA. QA + correlation with surgical.', NULL,
  'medium', 'cytopathology', 'review',
  'pathology', 'basic_science', 'cytopathology', 'mixed',
  'Papanicolaou Society; ASC', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Resident — pathology + role of cytopathology of body fluids — workflow + processing + diagnostic challenges; cell block vs liquid-based vs conventional smear'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Pathology lab — point-of-care testing (POCT) implementation + quality + accreditation + governance', '[{"label":"A","text":"No governance"},{"label":"B","text":"POCT Management Framework"},{"label":"C","text":"Random"},{"label":"D","text":"Skip"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** POCT Management Framework: (1) **POCT definition**: laboratory testing performed near the patient — bedside, clinic, ED, OR, ICU — by non-laboratory personnel; (2) **Common POCT**: blood glucose, blood gases, urine dipstick + hCG, INR, ACT (cath lab), influenza/SARS-CoV-2, strep, troponin, BNP, lactate, hemoglobin/hematocrit; (3) **Advantages**: rapid TAT, immediate clinical action; (4) **Risks**: variable operator competency, less rigorous QC, devices vary in accuracy, documentation challenges, errors in patient ID + result entry; (5) **Governance**: - **POCT coordinator** — laboratory-trained, oversight; - **Multidisciplinary POCT committee** (lab + nursing + physician + risk + IT); - **Policies + procedures** standardized; - **Accreditation oversight (CAP, TJC, ISO 15189, CLIA)** — POCT held to same standards as central lab; (6) **Operator training + competency**: - Initial training + documented; - **Annual competency assessment** (CLIA 6 elements: direct observation, monitoring, blind sample analysis, problem-solving, procedure review); - Pediatric, surgical, dialysis special considerations; (7) **Quality control**: - QC frequency per manufacturer + regulatory; - Daily QC for many; - QC documentation + review; - Linearity, calibration verification; - Internal proficiency testing (PT) + external (CAP surveys, AAFP); - Comparison studies POCT vs central lab; (8) **Connectivity**: middleware connects POCT to LIS + EHR — eliminates manual entry errors, ensures documentation, QC compliance; (9) **Lot-to-lot verification**, reagent storage monitoring, expiration tracking; (10) **Incident reporting + RCAs** for errors; (11) **Cost-effectiveness analysis** vs central testing; (12) **Continuous review** with clinical input + outcomes; (13) **Examples of governance failures**: bedside glucose mismatches → wrong insulin → hypoglycemia events

---

POCT: rapid testing near patient. Governance: coordinator + multidisciplinary committee + accreditation (CAP/TJC/CLIA/ISO). Training + annual competency (6 CLIA elements). QC + PT + comparison. Middleware connectivity. Incident reporting.', NULL,
  'medium', 'quality_safety', 'review',
  'pathology', 'ems_mgmt', 'quality_safety', 'mixed',
  'CLSI POCT; CAP POCT Checklist; CLIA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Pathology lab — point-of-care testing (POCT) implementation + quality + accreditation + governance'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Patient with newly diagnosed acute myeloid leukemia — multidisciplinary integrative care from diagnosis through treatment + survivorship', '[{"label":"A","text":"Single specialty"},{"label":"B","text":"AML Integrative Multidisciplinary Care"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** AML Integrative Multidisciplinary Care: (1) **Diagnosis phase**: pathology (morphology + cytochemistry + flow + cytogenetics + molecular FLT3, NPM1, CEBPA, IDH1/2, TP53, KMT2A, RUNX1, ASXL1, comprehensive NGS panel) + hematology + risk stratification (ELN 2022 favorable/intermediate/adverse); (2) **Treatment selection**: - Fit for intensive: 7+3 (cytarabine + anthracycline) ± midostaurin (FLT3) or gemtuzumab (CD33+ core-binding); - APL: ATRA + arsenic — > 90% cure; - Unfit for intensive: **venetoclax + azacitidine/decitabine** (VIALE-A) — transformed outcomes; - Targeted: ivosidenib + aza (IDH1), enasidenib (IDH2), olutasidenib, gilteritinib (FLT3 R/R), revumenib (KMT2A/NPM1); (3) **Multidisciplinary team**: hematology + transplant + pathology + transfusion + ID + ICU + pharmacy + nursing + nutrition + social work + mental health + chaplaincy + research/trials + cardio-onc (anthracycline) + supportive care; (4) **Supportive**: transfusion (PRBC + platelets — irradiated for those moving to HCT, CMV-safe), antifungal/antibacterial prophylaxis, growth factors (selected), TLS prophylaxis (rasburicase, hydration), nutrition, central line care, oral care, exercise, mental health; (5) **Patient + family education + decision-making**: shared decisions on intensity, goals, palliative integration; advance care planning; (6) **HCT evaluation** for adverse-risk and intermediate-risk if available + appropriate fitness — early HLA typing + donor search; complications (GVHD, infection, late effects); (7) **MRD monitoring** (multiparameter flow + molecular — NPM1, CBF, FLT3) — guides post-remission, transplant timing; (8) **Survivorship + late effects** (cardiotoxicity, secondary malignancy, fertility, psychosocial, post-HCT issues); (9) **Clinical trials integration**; (10) **Equity**: access, financial toxicity, geographic disparities; (11) **Palliative integration early** improves outcomes

---

AML integrative care: pathology + molecular (ELN 2022) → fitness-based treatment (7+3 + midostaurin vs ven-aza vs targeted). Multidisciplinary + supportive (TLS, infection prophy, transfusion). HCT for adverse. MRD-guided. Survivorship + palliative early.', NULL,
  'hard', 'hematopathology', 'review',
  'pathology', 'integrative', 'hematopathology', 'adult',
  'ELN 2022 AML; NCCN AML; VIALE-A', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Patient with newly diagnosed acute myeloid leukemia — multidisciplinary integrative care from diagnosis through treatment + survivorship'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Patient kidney transplant recipient — pathology + integrative care from donor evaluation to post-transplant management', '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Kidney Transplant Pathology Integrative Care"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Skip"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Kidney Transplant Pathology Integrative Care: (1) **Pre-transplant**: - Donor evaluation (living/deceased) — pathology + clinical; donor kidney biopsy (deceased — frozen for chronic changes, glomerulosclerosis, IFTA); - Recipient: HLA typing + crossmatch (complement-dependent cytotoxicity, flow, single-antigen bead — virtual crossmatch), DSA assessment; ABO compatibility (or desensitization for incompatible); - Cause of ESRD review + treatable disease (avoid recurrence); (2) **Surgical pathology of explant** (for native kidney removed if applicable) + transplant kidney; (3) **Post-transplant pathology — biopsy crucial**: - **Banff classification 2022** standardized: - **T cell-mediated rejection (TCMR)**: tubulitis (t1-3) + interstitial inflammation (i1-3) + vasculitis (v1-3); - **Antibody-mediated rejection (ABMR)**: peritubular capillaritis + glomerulitis + C4d deposition + DSA + molecular signatures (Molecular Microscope, B-HOT panel emerging); - **Chronic**: IFTA (interstitial fibrosis + tubular atrophy), chronic TCMR, chronic active ABMR, transplant glomerulopathy; - **Recurrent disease** (FSGS, IgA, MN, lupus, oxalate); - **De novo disease** (de novo MN, GBM); - **BK virus nephropathy** (SV40 IHC), CMV, EBV-PTLD; - **Drug toxicity** (CNI — striped fibrosis, isometric vacuolization); - **Polyomavirus + adenovirus**; (4) **Immunosuppression management**: - Induction (basiliximab IL-2R blocker or ATG); - Maintenance (tacrolimus + MMF + steroid taper typical); - **Belatacept** (CTLA4-Ig) — costimulation blockade alternative; - Adjustments based on biopsy + DSA + infections; (5) **Multidisciplinary**: transplant nephrology + surgery + transplant pathology + ID + pharmacy + immunology + tissue typing + nursing + nutrition + mental health + social work; (6) **Surveillance protocols** (serum creatinine + DSA + protocol biopsies in some centers); (7) **Long-term complications**: rejection, infection (opportunistic), malignancy (skin, PTLD, others — sirolimus may reduce), cardiovascular (leading cause death), metabolic, recurrent disease; (8) **Equity** + access + financial; (9) **Living donor** outcomes monitoring

---

Kidney transplant pathology integrative: HLA + DSA pre. Banff 2022: TCMR (tubulitis + interstitial) + ABMR (capillaritis + C4d + DSA). BK virus, CMV, recurrent disease, CNI tox. Immunosuppression tailored (tac + MMF; belatacept alt). Multidisciplinary long-term care.', NULL,
  'hard', 'renal_pathology', 'review',
  'pathology', 'integrative', 'renal_pathology', 'adult',
  'Banff 2022; KDIGO Transplant', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'Patient kidney transplant recipient — pathology + integrative care from donor evaluation to post-transplant management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 70 ปี — incidental lymphocytosis 25,000; smear: small mature lymphocytes + smudge cells; flow cytometry: CD5+, CD19+, CD20 dim, CD23+, CD200+, kappa-restricted dim, FMC7-, CD79b dim; การวินิจฉัย + workup + treatment', '[{"label":"A","text":"AML"},{"label":"B","text":"Chronic Lymphocytic Leukemia (CLL) / Small Lymphocytic Lymphoma (SLL)"},{"label":"C","text":"DLBCL"},{"label":"D","text":"MCL"},{"label":"E","text":"ALL"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Chronic Lymphocytic Leukemia (CLL) / Small Lymphocytic Lymphoma (SLL): (1) **Diagnostic criteria (iwCLL 2018)**: monoclonal B-lymphocyte count > 5 × 10⁹/L in peripheral blood; clonality + immunophenotype confirmed; SLL = same disease, tissue-based (lymph nodes), low lymphocyte count; (2) **Immunophenotype** (essential — distinguishes from other CD5+ lymphomas): - **CD5+** (T-cell antigen aberrantly expressed); - **CD19+**, CD20 dim, CD79b dim; - **CD23+** (CLL key — vs MCL CD23-); - **CD200+** (CLL — vs MCL); - **FMC7 dim/negative** (vs MCL strong); - Light chain restricted (kappa or lambda) dim; cyclin D1 negative (vs MCL); LEF1 + (CLL marker); (3) **Workup at diagnosis** (essential — risk stratification): - **IGHV mutation status**: **unmutated IGHV** (poor prognosis, more aggressive) vs **mutated** (better); - **FISH (CLL panel)**: del(13q) — best prognosis; +12; del(11q) ATM; **del(17p) TP53** — worst; - **TP53 mutation** (next-gen sequencing — important even without del(17p)); - **NOTCH1, SF3B1, BIRC3** — adverse; - **CD49d** flow — adverse; - Beta-2 microglobulin; (4) **MBL** (monoclonal B-cell lymphocytosis) — < 5 × 10⁹/L, immunophenotype like CLL — precursor, surveillance; (5) **Treatment** — only when indicated (active disease per iwCLL — progressive cytopenia, symptomatic LAD/splenomegaly, B symptoms, lymphocyte doubling < 6 mo, autoimmune cytopenia): - **Targeted therapy frontline (no chemo)**: - **BTK inhibitor** (acalabrutinib, zanubrutinib preferred over ibrutinib due to cardiac SE) ± obinutuzumab — continuous; - **Venetoclax (BCL2 inhibitor) + obinutuzumab** — fixed duration 12 mo (CLL14); - **Ibrutinib + venetoclax** fixed-duration combinations (GLOW, CAPTIVATE) emerging; - Chemo-IO (FCR, BR, R-Bendamustine) historical — limited current use; (6) **TP53/del(17p) high-risk**: avoid chemo; BTKi + venetoclax preferred; (7) **Relapsed/refractory**: switch class (BTKi → BCL2i or vice versa); pirtobrutinib (non-covalent BTKi) — BRUIN; CAR-T (lisocabtagene — TRANSCEND CLL); allo-HCT select; (8) **Complications**: hypogammaglobulinemia (infections, IVIG selected), autoimmune cytopenia (AIHA, ITP), Richter transformation (DLBCL or Hodgkin), second malignancies; (9) **Vaccinations** + infection prophylaxis (PJP, antifungal, antiviral on BTKi/BCL2i)

---

CLL/SLL: CD5+/CD19+/CD23+/CD200+/dim Ig; FMC7-/cyclin D1-/LEF1+. IGHV + FISH (del17p/TP53 high-risk) + NGS. Treat when iwCLL active. Targeted frontline: BTKi (acala/zanu) or ven-obi (CLL14). Pirtobrutinib + CAR-T R/R. Richter transformation, infections.', NULL,
  'hard', 'hematopathology', 'review',
  'pathology', 'clinical_decision', 'hematopathology', 'adult',
  'iwCLL 2018; NCCN CLL; CLL14', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 70 ปี — incidental lymphocytosis 25,000; smear: small mature lymphocytes + smudge cells; flow cytometry: CD5+, CD19+, CD20 dim, CD23+, CD200+, kappa-restricted dim, FMC7-, CD79b dim; การวินิจฉัย + workup + treatment'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิงอายุ 65 ปี — bilateral parotid swelling chronic; biopsy: lymphoepithelial lesions + reactive germinal centers + monocytoid B-cells expanding into epithelium; flow: monoclonal kappa; IHC: CD20+, CD5-, CD10-, CD23-, cyclin D1-; การวินิจฉัย', '[{"label":"A","text":"Reactive"},{"label":"B","text":"Extranodal Marginal Zone Lymphoma (MALT lymphoma)"},{"label":"C","text":"DLBCL"},{"label":"D","text":"MCL"},{"label":"E","text":"Sjögren only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Extranodal Marginal Zone Lymphoma (MALT lymphoma): (1) **Origin**: arises from chronic antigenic stimulation in mucosa-associated lymphoid tissue (MALT) — acquired or normal; (2) **Common sites + associations**: - **Gastric** — H. pylori (most studied); - **Salivary gland** — Sjögren syndrome; - **Thyroid** — Hashimoto thyroiditis; - **Ocular adnexa** — Chlamydia psittaci (some regions); - **Skin** — Borrelia (Europe); - **Lung (BALT)**, GI other sites, breast; (3) **Histology**: small B-cells (centrocyte-like, monocytoid, plasmacytic differentiation), reactive follicles colonized + ''lymphoepithelial lesions'' (B-cells infiltrating epithelium) — diagnostic; (4) **Immunophenotype**: CD20+, CD79a+; **CD5-, CD10-, CD23-, cyclin D1- (rules out other small B-cell lymphomas)**; light chain restricted (kappa or lambda); CD43 sometimes aberrant+; (5) **Genetics**: - **t(11;18)(q21;q21) BIRC3-MALT1** — most common; **predicts H. pylori eradication resistance** (gastric — choose alternate Tx if positive); - t(14;18) MALT1/IGH; t(1;14) BCL10/IGH; t(3;14) FOXP1/IGH; - Trisomy 3, 18; (6) **Workup**: identify + treat underlying chronic stimulus when possible; staging PET-CT, BM (selectively), EGD/site-specific endoscopy; (7) **Treatment** (depends on site + stage + risk + t(11;18)): - **Gastric MALT**: H. pylori eradication — induces regression in low-grade, t(11;18) negative; persistent disease or t(11;18) positive → RT (low-dose) or rituximab ± chemo; - **Non-gastric**: RT (very radiosensitive), rituximab, observation in indolent low-burden, immunochemotherapy in advanced; - **Antibiotic-responsive** in other sites (ocular — doxycycline for C. psittaci); (8) **Indolent course typically**; **transformation to DLBCL** ~ 10%; (9) **Multidisciplinary**: heme-onc + GI/specialty + ID + rheumatology

---

MALT lymphoma: chronic antigen stimulation (H. pylori/Sjögren/Hashimoto/C. psittaci). Lymphoepithelial lesions + monocytoid B-cells; CD20+/CD5-/CD10-/CD23-. t(11;18) most common — predicts H. pylori eradication resistance. Antibiotic-responsive when feasible.', NULL,
  'medium', 'hematopathology', 'review',
  'pathology', 'clinical_decision', 'hematopathology', 'adult',
  'WHO HAEM5 2022; ESMO MZL', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยหญิงอายุ 65 ปี — bilateral parotid swelling chronic; biopsy: lymphoepithelial lesions + reactive germinal centers + monocytoid B-cells expanding into epithelium; flow: monoclonal kappa; IHC: CD20+, CD5-, CD10-, CD23-, cyclin D1-; การวินิจฉัย'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยเด็กอายุ 5 ปี — fatigue + bruising + LAD; CBC: WBC 60,000 with blasts; flow: CD19+, CD10+, CD20-, CD22+, TdT+, MPO-; cytogenetics: t(12;21) ETV6-RUNX1; การวินิจฉัยและการรักษา', '[{"label":"A","text":"AML"},{"label":"B","text":"B-cell Acute Lymphoblastic Leukemia/Lymphoblastic Lymphoma (B-ALL/LBL)"},{"label":"C","text":"Reactive lymphocytosis"},{"label":"D","text":"Refuse"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** B-cell Acute Lymphoblastic Leukemia/Lymphoblastic Lymphoma (B-ALL/LBL): (1) **Diagnostic criteria**: ≥ 20% lymphoblasts in BM/PB (or tissue-based LBL); immunophenotyping essential; (2) **B-ALL immunophenotype**: CD19+ (pan-B), CD22+, CD79a+, **CD10+ (common ALL)**, **TdT+**, CD34+ in many, **MPO negative** (vs AML); pro-B (CD10-), common B (CD10+, surface Ig-), pre-B (cIgM+), mature B = Burkitt (sIg+); (3) **T-ALL**: cytoplasmic CD3+, CD7+, CD1a+ (cortical), CD4/CD8 variable; T-cell receptor rearrangements; (4) **Cytogenetics/molecular (essential — risk stratification, WHO HAEM5)**: - **Good risk pediatric**: hyperdiploidy (51-65), **t(12;21) ETV6-RUNX1** (cryptic — needs FISH); - **High risk**: hypodiploidy < 44, **t(9;22) BCR-ABL (Ph+)** — add TKI, **KMT2A (MLL) rearrangements** (especially infants), iAMP21, **Ph-like ALL** (CRLF2, JAK2, ABL-class — adult > pediatric, kinase fusions); - **B-other**, ETP-T-ALL (T-cell aggressive), **TCF3-PBX1**, **TCF3-HLF**, ZNF384, DUX4 (favorable); - **IKZF1 deletion** — adverse independently; (5) **MRD monitoring** (flow MRD + molecular) — strongest prognostic factor; (6) **Treatment**: - **Multi-agent chemo**: induction (corticosteroid + vincristine + anthracycline + asparaginase ± rituximab) → consolidation → CNS-directed (IT MTX/cytarabine) → maintenance (~ 2-3 yr total in pediatric); - **Ph+ ALL**: add TKI (imatinib, dasatinib, ponatinib) — survival > 80% pediatric, much improved adult; - **Pediatric > adult outcomes**; pediatric-inspired protocols extended to AYA + adult; - **Relapsed/refractory**: - **Blinatumomab** (CD19/CD3 bispecific) — pre/post-MRD-positive role; - **Inotuzumab ozogamicin** (anti-CD22 ADC); - **CAR-T (tisagenlecleucel, brexucabtagene)** — pediatric ALL revolutionary cure rates; - allo-HCT consolidation; (7) **Pediatric outcomes excellent**: > 90% cure in good-risk; (8) **Multidisciplinary** + supportive + survivorship

---

B-ALL: ≥20% blasts; CD19/CD22/CD10/TdT+, MPO-. Risk strat by genetics: hyperdiploid + t(12;21) good; hypodiploid + Ph+ + KMT2A + Ph-like + iAMP21 high. MRD-guided. Pediatric chemo + CNS prophylaxis; +TKI for Ph+. R/R: blinatumomab, inotuzumab, CAR-T.', NULL,
  'hard', 'hematopathology', 'review',
  'pathology', 'clinical_decision', 'hematopathology', 'peds',
  'WHO HAEM5 2022; ICC 2022; NCCN ALL', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยเด็กอายุ 5 ปี — fatigue + bruising + LAD; CBC: WBC 60,000 with blasts; flow: CD19+, CD10+, CD20-, CD22+, TdT+, MPO-; cytogenetics: t(12;21) ETV6-RUNX1; การวินิจฉัยและการรักษา'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 75 ปี — pancytopenia + dysplastic features in marrow: ringed sideroblasts > 15%, blasts 6%; cytogenetics: del(5q); molecular: SF3B1 mutation + TP53 wildtype; การจำแนกและการรักษา', '[{"label":"A","text":"AML"},{"label":"B","text":"Myelodysplastic Syndromes (MDS) — Classification + Management"},{"label":"C","text":"Refuse"},{"label":"D","text":"Iron deficiency"},{"label":"E","text":"B12 deficiency"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Myelodysplastic Syndromes (MDS) — Classification + Management: (1) **WHO HAEM5 (2022) / ICC**: classified by dysplasia lineage count, blast %, genetics, ring sideroblasts: - MDS with low blasts (< 5% BM, < 2% PB); - MDS with low blasts and SF3B1 mutation; - MDS with low blasts and isolated del(5q); - MDS with biallelic TP53 inactivation (poor); - MDS with increased blasts (MDS-IB1 5-9%, MDS-IB2 10-19%); - MDS, hypoplastic; - MDS, fibrotic; - MDS/MPN overlap; - (2) **IPSS-R / IPSS-M** prognostic — IPSS-M integrates 31 mutations (TP53 multi-hit worst; SF3B1, SRSF2, U2AF1, ASXL1, RUNX1, EZH2, ETV6, others); (3) **Diagnostic workup**: BM biopsy + aspirate + iron stain (ring sideroblasts) + cytogenetics + FISH + NGS panel (myeloid); flow cytometry + Ogata score; rule out copper/B12/HIV/recent chemo; (4) **MDS with del(5q) — 5q minus syndrome**: middle-aged women, macrocytic anemia, normal/elevated platelet, megakaryocyte hypolobulation; **lenalidomide highly effective**; (5) **Treatment by risk**: - **Lower-risk MDS**: ESA (erythropoietin) for symptomatic anemia + low EPO; **luspatercept (RBC)** especially SF3B1+/ring sideroblasts (COMMANDS, MEDALIST); lenalidomide for del(5q); transfusion + iron chelation; immunosuppression (ATG/cyclosporine) for hypoplastic MDS; - **Higher-risk MDS**: **hypomethylating agents (azacitidine, decitabine, oral cedazuridine-decitabine)** — backbone; **allo-HCT only curative** (eligibility based on age/comorbidities); - **AML transformation** (MDS-IB2 already AML-like — venetoclax + aza emerging in ''AML with myelodysplasia-related changes''); - **TP53-mutated MDS/AML**: very poor — magrolimab/eprenetapopt under study, mostly trials; (6) **Supportive**: transfusion + chelation; growth factors; vaccinations; (7) **Multidisciplinary**: heme + transplant + transfusion + supportive care; (8) **Symptom-focused** in older unfit patients; palliative integration

---

MDS WHO HAEM5: by lineage dysplasia + blast % + genetics (SF3B1, del(5q), TP53). IPSS-M with mutations. Tx by risk: ESA/luspatercept/lenalidomide for low-risk; HMA + allo-HCT for high-risk. TP53 multi-hit worst. Supportive + multidisciplinary.', NULL,
  'hard', 'hematopathology', 'review',
  'pathology', 'clinical_decision', 'hematopathology', 'adult',
  'WHO HAEM5 2022; ICC 2022; IPSS-M; NCCN MDS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 75 ปี — pancytopenia + dysplastic features in marrow: ringed sideroblasts > 15%, blasts 6%; cytogenetics: del(5q); molecular: SF3B1 mutation + TP53 wildtype; การจำแนกและการรักษา'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี — high WBC 80,000 + immature myeloid cells + basophilia; BM hypercellular with granulocytic hyperplasia + blasts < 5%; FISH/PCR: **BCR-ABL1 t(9;22)** positive; การวินิจฉัยและการรักษา', '[{"label":"A","text":"AML"},{"label":"B","text":"Chronic Myeloid Leukemia (CML) — BCR-ABL1+"},{"label":"C","text":"Reactive leukocytosis"},{"label":"D","text":"Refuse"},{"label":"E","text":"MDS"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Chronic Myeloid Leukemia (CML) — BCR-ABL1+: (1) **Diagnostic criteria (WHO HAEM5)**: **BCR-ABL1 fusion** (t(9;22)(q34;q11.2) Philadelphia chromosome) — pathognomonic; myeloproliferation; left-shifted granulocytes + basophilia (specific) + variable eosinophilia + thrombocytosis; splenomegaly; (2) **Phases**: - **Chronic phase (CP)** — < 5% blasts in BM/PB, control of WBC achievable; - **Accelerated phase (AP)** — 10-19% blasts OR ≥ 20% basophils OR persistent thrombocytosis/penia OR new clonal evolution; - **Blast phase (BP)** — ≥ 20% blasts (myeloid 70% or lymphoid 30%) — behaves like acute leukemia; (3) **Workup**: PB + BM + cytogenetics + FISH + RT-PCR for BCR-ABL1 (p210 major, p190 minor, p230 — typing); baseline before TKI; (4) **Risk scores**: Sokal, Hasford, ELTS — guides TKI choice + monitoring; (5) **Treatment** (CP): - **TKI revolution** transformed CML survival ~ normal lifespan: - **First-gen**: **imatinib** (Gleevec); - **Second-gen**: **dasatinib, nilotinib, bosutinib** — frontline in higher-risk; - **Third-gen + asciminib (STAMP — allosteric BCR-ABL inhibitor)** approved 1L (ASC4FIRST 2024); - **Ponatinib** for T315I-mutated (resistance to other TKIs); - Choice considers comorbidities (cardiovascular — ponatinib + nilotinib caution; pleural effusion — dasatinib caution; pulmonary HTN); (6) **Monitoring**: - **BCR-ABL1 RT-qPCR (IS — international scale)** every 3 mo until MMR; milestones: BCR-ABL1 ≤ 10% at 3 mo, ≤ 1% at 6 mo, ≤ 0.1% (MMR) at 12 mo; - **Deep molecular response (MR4, MR4.5)** allows **treatment-free remission (TFR)** trial in eligible patients (sustained DMR > 2 yr) — ~ 50% maintain; - **Failure**: switch TKI, check BCR-ABL kinase domain mutations (T315I, F359, etc.); (7) **AP/BP**: more intensive — TKI + chemo ± allo-HCT; (8) **Multidisciplinary**: heme + transplant + adherence (TKI adherence critical) + pharmacy + cardiovascular + supportive; (9) **Compliance > 90% essential** for optimal response

---

CML: BCR-ABL1 t(9;22) pathognomonic; CP/AP/BP. TKI revolution: imatinib → dasatinib/nilotinib/bosutinib → ponatinib (T315I) → asciminib (STAMP). Molecular monitoring (IS); MMR at 12 mo; TFR for sustained DMR. Switch TKI + kinase mutation testing for failure.', NULL,
  'medium', 'hematopathology', 'review',
  'pathology', 'clinical_decision', 'hematopathology', 'adult',
  'WHO HAEM5 2022; ELN CML 2020; ASC4FIRST', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี — high WBC 80,000 + immature myeloid cells + basophilia; BM hypercellular with granulocytic hyperplasia + blasts < 5%; FISH/PCR: **BCR-ABL1 t(9;22)** positive; การวินิจฉัยและการรักษา'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี — erythrocytosis Hb 19 + splenomegaly + pruritus; EPO low; molecular: **JAK2 V617F mutation** positive; BM: hypercellular trilineage hyperplasia; การวินิจฉัยและการรักษา', '[{"label":"A","text":"Secondary polycythemia"},{"label":"B","text":"Polycythemia Vera (PV) — WHO 2022"},{"label":"C","text":"MDS"},{"label":"D","text":"AML"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Polycythemia Vera (PV) — WHO 2022: (1) **Diagnostic criteria** (3 major or first 2 + minor): - Major 1: Hb > 16.5 (M) / 16.0 (F) OR Hct > 49% (M) / 48% (F) OR red cell mass > 25% mean predicted; - Major 2: BM biopsy showing hypercellular for age with trilineage growth (panmyelosis) with pleomorphic mature megakaryocytes; - Major 3: **JAK2 V617F or JAK2 exon 12 mutation**; - Minor: subnormal serum EPO level; (2) **Other Philadelphia-negative MPNs**: - **Essential thrombocythemia (ET)** — sustained Plt > 450 × 10⁹/L; JAK2 V617F (~ 50%), **CALR exon 9** (~ 25%), **MPL** (~ 3%), ''triple negative'' (~ 10-15%); BM proliferation of large mature megakaryocytes; - **Primary myelofibrosis (PMF)** — prefibrotic and overt; same drivers; cytopenia + fibrosis + leukoerythroblastic + dacrocytes/teardrops + splenomegaly; - **MDS/MPN overlap**: CMML, aCML, JMML, MDS/MPN-RS-T, MDS/MPN-NOS; (3) **MPN complications**: thrombosis (arterial + venous — splanchnic — important PV/ET; HCT control), bleeding (acquired vWS in ET high platelet), transformation to MF then AML (acquired drivers ASXL1, EZH2, SRSF2, IDH; TP53); (4) **Risk stratification PV**: - **Low risk**: age < 60 + no thrombosis history → phlebotomy + low-dose aspirin; - **High risk**: age ≥ 60 OR thrombosis history → add cytoreduction; (5) **Treatment**: - **PV cytoreduction**: hydroxyurea (1st-line typically), interferon-α / pegylated IFN (**ropeginterferon alfa-2b** FDA-approved PV — PROUD-PV) — preferred for young/pregnancy; **ruxolitinib** (JAK1/2 inhibitor) — for HU-intolerant/resistant (RESPONSE/RESPONSE-2); - **ET**: low-risk — aspirin; high-risk — hydroxyurea, anagrelide, IFN; - **MF**: ruxolitinib, fedratinib, momelotinib (anemia + ↓ spleen, MOMENTUM), pacritinib (severe thrombocytopenia, PERSIST-2); navitoclax + ruxo combos under trial; allo-HCT only curative; (6) **Thrombosis prevention** central; control Hct < 45 PV (CYTO-PV); aspirin; risk-adapted cytoreduction; (7) **Multidisciplinary**

---

PV: WHO 2022 — Hb/Hct↑ + panmyelosis + JAK2 mutation + low EPO. MPN drivers JAK2/CALR/MPL. Tx: phlebotomy + ASA all; cytoreduction (HU or ropeg-IFN) for high-risk PV. Ruxolitinib for HU-intol/resistant (RESPONSE) + MF. Hct < 45 (CYTO-PV).', NULL,
  'medium', 'hematopathology', 'review',
  'pathology', 'clinical_decision', 'hematopathology', 'adult',
  'WHO HAEM5 2022; NCCN MPN; RESPONSE', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี — erythrocytosis Hb 19 + splenomegaly + pruritus; EPO low; molecular: **JAK2 V617F mutation** positive; BM: hypercellular trilineage hyperplasia; การวินิจฉัยและการรักษา'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี — heavy smoker + drinker; HPV testing positive; oropharyngeal tonsil mass biopsy: non-keratinizing squamous + basaloid cells + central necrosis; IHC: **p16 strong + diffuse block-positive**; HPV ISH or HPV PCR positive (high-risk type 16); การวินิจฉัยและการ stage', '[{"label":"A","text":"Adenocarcinoma"},{"label":"B","text":"HPV-associated Oropharyngeal Squamous Cell Carcinoma (HPV-OPSCC)"},{"label":"C","text":"Lymphoma"},{"label":"D","text":"Melanoma"},{"label":"E","text":"Cyst"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** HPV-associated Oropharyngeal Squamous Cell Carcinoma (HPV-OPSCC): (1) **Epidemiology**: rising incidence, predominantly white middle-aged men, sexual transmission, oral HPV exposure; better prognosis than HPV-negative; (2) **Histology**: typically non-keratinizing, basaloid, with comedo-type necrosis; lymphoepithelial pattern; tonsil + base of tongue most common; high-risk HPV types — predominantly HPV-16 (90% of HPV+ OPSCC), HPV-18, 33, 35; (3) **HPV testing — required** for OPSCC (CAP/ASCO/CAP-WHO): - **p16 IHC** — strong + diffuse (≥ 70% nuclear + cytoplasmic) — surrogate marker, high sensitivity, lower specificity especially outside oropharynx; - **HPV DNA ISH** or **HPV E6/E7 mRNA ISH** — directly detects HPV; - **HPV PCR** including high-risk genotype; - **HPV-associated head/neck cancers limited mostly to OROPHARYNX** — non-oropharyngeal p16+ less reliable HPV-driven; (4) **Staging**: **AJCC 8th edition (2017) — DIFFERENT for HPV-related OPSCC** (cN/cM categories simpler — reflects better prognosis): - p16+ T1-T2 N1 = stage I; - cf. p16- OPSCC traditional staging; (5) **HPV+ OPSCC excellent prognosis** — 5-yr OS > 80%; (6) **Treatment**: - **De-escalation trials ongoing** (lower dose RT, less intensive chemo) — not yet standard outside trial; - **Standard**: surgery (transoral robotic — TORS) for select + neck dissection + risk-adapted adjuvant; OR primary RT + concurrent platinum chemo; - **HPV-negative**: stage-based intensive multimodal; (7) **EBV-associated nasopharyngeal carcinoma** distinct — common SE Asia + Mediterranean: EBER ISH + (testing essential), non-keratinizing undifferentiated, treat with concurrent chemoRT; nivolumab + chemo in advanced (KEYNOTE-122); (8) **HPV vaccination** primary prevention; (9) **Multidisciplinary**: H&N surgery + RT + medical onc + speech + nutrition + dental + psychology + survivorship

---

HPV+ OPSCC: non-keratinizing, p16 block+ (CAP), HPV ISH/PCR confirmatory. AJCC 8th separate staging (better prognosis). 5-yr OS > 80%. Treatment: surgery (TORS) + risk-adapted adjuvant or chemoRT. EBV NPC distinct (EBER ISH). HPV vaccination prevention.', NULL,
  'medium', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'WHO Head + Neck Tumors 5th ed; AJCC 8th; CAP/ASCO p16', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี — heavy smoker + drinker; HPV testing positive; oropharyngeal tonsil mass biopsy: non-keratinizing squamous + basaloid cells + central necrosis; IHC: **p16 strong + diffuse block-positive**; HPV ISH or HPV PCR positive (high-risk type 16); การวินิจฉัยและการ stage'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี — gastric mass → biopsy: spindle cell tumor with mild atypia + low mitoses; IHC: **CD117 (KIT) +, DOG1+, CD34 + variable**, S100-, desmin-, SMA-; molecular: KIT exon 11 mutation; การวินิจฉัยและการรักษา', '[{"label":"A","text":"Leiomyoma"},{"label":"B","text":"Gastrointestinal Stromal Tumor (GIST)"},{"label":"C","text":"Lipoma"},{"label":"D","text":"Carcinoma"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Gastrointestinal Stromal Tumor (GIST): (1) **Origin**: interstitial cells of Cajal (pacemaker cells of GI tract); (2) **Common sites**: stomach (~ 60%), small intestine (~ 30%), colon, rectum, esophagus, extraintestinal (omentum); (3) **Histology**: spindle (70%), epithelioid (20%), mixed; nuclear atypia + mitoses variable; necrosis; (4) **IHC**: **CD117 (KIT)+ ~ 95%** (most specific), **DOG1+ ~ 98%** (more sensitive — useful in KIT-negative), CD34+ (~ 70%), variable SMA; S100-, desmin- (distinguishes from leiomyoma/sarcoma/schwannoma); succinate dehydrogenase (SDHB) IHC — loss in pediatric/SDH-deficient GIST; (5) **Molecular** (essential — guides treatment): - **KIT mutation** ~ 75-80% (exon 11 most common — best response to imatinib; exon 9 — partial response, higher dose 800 mg; exon 13, 17 less common); - **PDGFRA mutation** ~ 5-10% (exon 18 D842V — **imatinib resistant** — needs avapritinib; other exon 18 sensitive); - **KIT/PDGFRA wild-type GIST**: SDH-deficient (pediatric, Carney triad, Carney-Stratakis), NF1 (small bowel multifocal), BRAF V600E, KIT exon 11 internal duplication; (6) **Risk stratification (Miettinen + Lasota)**: size + mitotic count + site + tumor rupture → very low/low/intermediate/high — guides surveillance + adjuvant; (7) **Treatment**: - **Surgical resection** primary if resectable — R0 without lymph node dissection (rare nodal mets except SDH-deficient pediatric); - **Adjuvant imatinib** 3 yr for high-risk (PERSIST-5, SSGXVIII); - **Neoadjuvant imatinib** for unresectable/borderline → downsize; - **Metastatic/unresectable**: **imatinib** (400 mg, 800 mg for KIT exon 9) → **sunitinib** (2nd line) → **regorafenib** (3rd line) → **ripretinib** (4th line, INVICTUS); - **PDGFRA D842V**: **avapritinib**; - SDH-deficient + WT: targeted by mutation; immunotherapy investigational; (8) **Multidisciplinary**: surgery + medical onc + GI + pathology + radiology + genetics (SDH/NF1/Carney)

---

GIST: CD117+/DOG1+/CD34+ (interstitial cells of Cajal). KIT mutation 75-80% (exon 11 best imatinib response); PDGFRA D842V → avapritinib. SDH-deficient + WT subset. Surgery + adjuvant imatinib for high-risk. Sequential TKIs metastatic (imatinib → sunitinib → regorafenib → ripretinib).', NULL,
  'hard', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'WHO Soft Tissue + Bone 5th ed; NCCN GIST; INVICTUS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี — gastric mass → biopsy: spindle cell tumor with mild atypia + low mitoses; IHC: **CD117 (KIT) +, DOG1+, CD34 + variable**, S100-, desmin-, SMA-; molecular: KIT exon 11 mutation; การวินิจฉัยและการรักษา'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 15 ปี — knee pain + radiograph: aggressive bone lesion + Codman triangle + sunburst periosteal reaction; biopsy: malignant cells producing osteoid matrix + marked atypia + high mitoses; การวินิจฉัยและการรักษา', '[{"label":"A","text":"Osteomyelitis"},{"label":"B","text":"Osteosarcoma (Conventional)"},{"label":"C","text":"Refuse"},{"label":"D","text":"Hospice"},{"label":"E","text":"Benign cyst"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Osteosarcoma (Conventional): (1) **Epidemiology**: most common primary malignant bone tumor in adolescents + young adults; bimodal — second peak in elderly (Paget-associated, post-radiation); metaphysis of long bones (distal femur > proximal tibia > proximal humerus); (2) **Histology**: **osteoid production by malignant cells** — defining feature; spindle/polygonal cells with marked pleomorphism + atypical mitoses + necrosis; lace-like + sheet-like + filigree osteoid patterns; (3) **Subtypes**: - **Conventional** (most common — osteoblastic, chondroblastic, fibroblastic); - **Telangiectatic** (cystic, mimics ABC); - **Small cell** (mimics Ewing); - **Low-grade central** (mimics fibrous dysplasia, MDM2/CDK4 amp); - **Parosteal** (low-grade, posterior distal femur, MDM2/CDK4 amp — same as well-diff/dediff liposarcoma); - **Periosteal** (intermediate-grade, chondroblastic); - **Surface high-grade**; - **Secondary** (Paget, radiation); (4) **IHC**: SATB2+ (osteoblastic), variable osteonectin, osteocalcin; non-specific largely; **MDM2/CDK4** IHC + FISH for low-grade central + parosteal; (5) **Imaging**: aggressive periosteal reaction (Codman triangle, sunburst), poorly defined, soft-tissue mass; staging — CT chest (lung mets common), MRI primary, bone scan / PET; (6) **Genetics**: complex karyotype typically; hereditary predisposition (**Li-Fraumeni — TP53**, **Hereditary retinoblastoma — RB1**, **Rothmund-Thomson, Werner, Bloom**); MDM2 amp in low-grade subtypes; (7) **Differential**: Ewing sarcoma (small round blue cell — CD99+, EWSR1-FLI1 t(11;22)), chondrosarcoma, osteomyelitis (clinical), fibrous dysplasia, GCT; (8) **Treatment**: - **Neoadjuvant chemo** (MAP — methotrexate + adriamycin + cisplatin) → wide resection → adjuvant chemo; - **Necrosis ≥ 90% (Huvos)** predicts better outcome; EURAMOS-1 showed switching post-op chemo for poor response didn''t improve; - **Limb salvage** vs amputation per anatomy + response; - **Lung mets** resection (curative possible); - **Relapsed/refractory**: regorafenib, cabozantinib, sorafenib, mifamurtide (selected); trials; (9) **Multidisciplinary**: ortho onc + medical onc + RT (limited role) + pediatric onc + pathology + radiology + rehab; (10) **Genetic counseling** when hereditary suspected

---

Osteosarcoma: osteoid by malignant cells; metaphysis adolescent. Subtypes: conventional + telangiectatic + small cell + low-grade (MDM2/CDK4 amp) + parosteal. TP53/RB1 hereditary. MAP chemo neoadj + adjuvant + wide resection; Huvos necrosis prognostic. Limb salvage. Pulmonary met resection.', NULL,
  'medium', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'mixed',
  'WHO Soft Tissue + Bone 5th ed; EURAMOS-1; NCCN Bone', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 15 ปี — knee pain + radiograph: aggressive bone lesion + Codman triangle + sunburst periosteal reaction; biopsy: malignant cells producing osteoid matrix + marked atypia + high mitoses; การวินิจฉัยและการรักษา'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 14 ปี — diaphysis of femur + onion-skin periosteal reaction; biopsy: small round blue cells with scant cytoplasm; IHC: CD99+ membranous (diffuse), FLI1+, NKX2.2+; molecular: EWSR1-FLI1 fusion t(11;22)', '[{"label":"A","text":"Osteosarcoma"},{"label":"B","text":"CD99 (MIC2)+ membranous diffuse"},{"label":"C","text":"Lymphoma"},{"label":"D","text":"Refuse"},{"label":"E","text":"Benign"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Ewing Sarcoma: (1) **Epidemiology**: bone or soft tissue, children + young adults, diaphysis of long bones / pelvis / chest wall (Askin tumor) / paraspinal; (2) **Histology**: small round blue cell tumor — monotonous small cells with scant cytoplasm + round nuclei + finely dispersed chromatin + PAS-positive glycogen; Homer-Wright rosettes occasional; (3) **IHC**: **CD99 (MIC2)+ membranous diffuse** — characteristic (also positive in lymphoblastic lymphoma, synovial sarcoma, others — not specific alone); **NKX2.2+** (more specific), FLI1+, ERG+ (variant fusions); often vimentin+; (4) **Molecular (essential for diagnosis)** — **''Ewing sarcoma family'' genetic definition**: - **EWSR1-FLI1** ~ 85% (t(11;22)(q24;q12)); - **EWSR1-ERG** ~ 10% (t(21;22)); - Less common: EWSR1-ETV1, EWSR1-ETV4, EWSR1-FEV; - **FUS-ERG, FUS-FEV** rare; - These are ''fusions involving FET family RNA-binding protein with ETS transcription factor''; - **''Ewing-like sarcomas'' / round cell sarcomas — distinct entities** (WHO 2020): - **CIC-rearranged sarcoma** (CIC-DUX4 most common) — aggressive; - **BCOR-rearranged sarcoma** (BCOR-CCNB3) — children, distinct biology; - **Round cell sarcoma with EWSR1-non-ETS fusion**; - Different biology + treatment than classical Ewing; (5) **Differential**: osteosarcoma small cell, neuroblastoma (HVA, VMA, MIBG+; PHOX2B+), rhabdomyosarcoma alveolar (myogenin+, PAX-FOXO1), lymphoblastic lymphoma (TdT+), small cell carcinoma (cytokeratin, synaptophysin); (6) **Imaging**: diaphyseal, onion-skin or hair-on-end periosteal, large soft-tissue mass; staging CT chest, bone scan, MRI primary, PET; **BM biopsy** (high involvement frequency); (7) **Treatment**: - **Multimodal — chemo + local control + chemo**; - **VDC/IE (vincristine + doxorubicin + cyclophosphamide alternating with ifosfamide + etoposide)** — backbone; - **Interval compression** every 2 wk (Children''s Oncology Group) better outcomes pediatric; - **Local control**: surgery preferred when feasible; RT alternative or addition; - **Mets at diagnosis** ~ 25% (lung > bone > BM); lung-only better prognosis; - **Relapsed**: cyclophosphamide + topotecan, irinotecan + temozolomide, high-dose chemo + auto-SCT (controversial); trials with EZH2 inhibitor, others; (8) **Multidisciplinary**: ortho/surg + pediatric onc + RT + pathology + molecular + rehab; (9) **5-yr OS** ~ 70% localized, ~ 30% metastatic

---

Ewing: small round blue cell + glycogen; CD99 membranous + NKX2.2 + FLI1; EWSR1-FLI1 ~85%. ''Ewing-like'' (CIC-DUX4, BCOR) distinct entities. Multimodal VDC/IE chemo + surgery/RT. Interval compression pediatric. Lung-only mets better prognosis.', NULL,
  'hard', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'peds',
  'WHO Soft Tissue + Bone 5th ed; COG Ewing', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 14 ปี — diaphysis of femur + onion-skin periosteal reaction; biopsy: small round blue cells with scant cytoplasm; IHC: CD99+ membranous (diffuse), FLI1+, NKX2.2+; molecular: EWSR1-FLI1 fusion t(11;22)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี — large retroperitoneal mass → biopsy: well-differentiated lipomatous areas + spindle cells in fibrous bands; IHC: MDM2+, CDK4+; FISH: MDM2 amplification on 12q15; การวินิจฉัย', '[{"label":"A","text":"Lipoma"},{"label":"B","text":"Liposarcoma — Well-Differentiated / Dedifferentiated (WHO 2020)"},{"label":"C","text":"Cyst"},{"label":"D","text":"Carcinoma"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Liposarcoma — Well-Differentiated / Dedifferentiated (WHO 2020): (1) **Categories**: - **Well-differentiated liposarcoma (WDLPS)** / **atypical lipomatous tumor (ALT)** — same biology, different name based on location (extremity = ALT, retroperitoneum/mediastinum/spermatic cord = WDLPS — implies worse prognosis due to inability to resect with margins); - **Dedifferentiated liposarcoma (DDLPS)** — abrupt transition from WD areas to high-grade non-lipogenic sarcoma; - **Myxoid liposarcoma** — round to spindle cells in myxoid stroma with delicate vasculature + lipoblasts (signet-ring); ''low-grade'' (< 5% round cell) vs ''high-grade'' (≥ 5% round cell — worse); - **Pleomorphic liposarcoma** — high-grade pleomorphic sarcoma with lipoblasts; (2) **Histology WDLPS**: mature adipocytes with size variation + scattered atypical hyperchromatic spindle cells in fibrous septa + atypical adipocytes/lipoblasts (latter not required); (3) **Molecular**: - **WDLPS/DDLPS**: **MDM2 + CDK4 amplification on 12q14-15** — diagnostic; IHC + FISH; - **Myxoid liposarcoma**: **FUS-DDIT3** (CHOP) t(12;16) ~ 95%, or rare EWSR1-DDIT3; - **Pleomorphic**: complex karyotype; (4) **Differential**: lipoma (no atypia, no MDM2 amp), spindle cell lipoma (CD34+, monosomy 13/16, no MDM2), atypical spindle cell/pleomorphic lipomatous tumor (RB1 loss); (5) **Treatment**: - **Surgical resection** mainstay — wide excision; - **WDLPS retroperitoneal**: recurrence common (multifocal in 30%) — long-term surveillance; - **DDLPS**: more aggressive, distant mets possible; - **Myxoid LPS**: highly radiosensitive — RT may be useful pre-op or post-op; characteristic dissemination to soft tissue + extrapulmonary (vs other sarcoma lung-pattern); - **Pleomorphic**: doxorubicin-based chemo for metastatic; - **Investigational**: MDM2 inhibitors (milademetan, navtemadlin) for WD/DD LPS (trials, mixed results); trabectedin myxoid LPS especially active (ET-743 binds DNA + affects FUS-DDIT3 transcription); (6) **Soft tissue sarcoma general**: sarcoma multidisciplinary centers improve outcomes; (7) **Multidisciplinary**: surgical onc + sarcoma medical onc + pathology + RT + radiology

---

Liposarcoma WHO 2020: WDLPS/ALT (MDM2/CDK4 amp 12q), DDLPS (high-grade transition), myxoid (FUS-DDIT3; round cell % matters), pleomorphic. Surgery mainstay; myxoid radiosensitive + trabectedin active. MDM2 IHC/FISH key. Sarcoma multidisciplinary centers.', NULL,
  'hard', 'surgical_pathology', 'review',
  'pathology', 'clinical_decision', 'surgical_pathology', 'adult',
  'WHO Soft Tissue + Bone 5th ed; NCCN Sarcoma', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี — large retroperitoneal mass → biopsy: well-differentiated lipomatous areas + spindle cells in fibrous bands; IHC: MDM2+, CDK4+; FISH: MDM2 amplification on 12q15; การวินิจฉัย'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี — adult — convexity dural-based brain mass → resection: meningothelial cells forming whorls + psammoma bodies; IHC: EMA+, SSTR2A+, progesterone receptor+; การวินิจฉัยและการ grade', '[{"label":"A","text":"Glioma"},{"label":"B","text":"Meningioma — CNS WHO 2021"},{"label":"C","text":"Lymphoma"},{"label":"D","text":"Pituitary"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Meningioma — CNS WHO 2021: (1) **Origin**: arachnoid cap cells (meningothelial); most common primary CNS tumor adult (~ 1/3); dural-based; majority benign (grade 1); women > men (2:1); progesterone receptor positive — increased growth with pregnancy/hormones; (2) **Histology**: meningothelial whorls + syncytial nests + psammoma bodies + intranuclear pseudoinclusions; many subtypes histologically (transitional, fibrous, psammomatous, secretory, microcystic, etc.); (3) **IHC**: **EMA+ (variable), SSTR2A+ (somatostatin receptor)**, vimentin+, **PR+** (better in lower grade), Ki-67 grade marker; CD34+ + STAT6+ rule out solitary fibrous tumor (different entity); (4) **CNS WHO 2021 grading**: - **Grade 1 (benign — ~ 80%)**: usual subtypes, < 4 mitoses/10 HPF; - **Grade 2 (atypical — ~ 15%)**: ≥ 4 mitoses OR ≥ 3 of (necrosis spontaneous, sheeting, small cell, prominent nucleoli, hypercellularity); brain invasion alone now grade 2 (CNS5); chordoid + clear cell subtypes; - **Grade 3 (malignant)**: ≥ 20 mitoses, frank malignancy histology, rhabdoid or papillary subtypes; (5) **Molecular criteria (CNS5)**: - **TERT promoter mutation** OR **homozygous CDKN2A/B deletion** → upgrade to **grade 3** (CNS5 — integrated grading); - **NF2** loss common (sporadic + NF2-associated multiple meningiomas); - **AKT1, TRAF7, KLF4, SMO, POLR2A** mutations in subsets — some location-correlated; - **SMARCE1** (clear cell), **BAP1** (rhabdoid), **DMD** loss (subset); - **Methylation profiling** increasingly used for accurate grading + prognosis (DKFZ classifier); (6) **Imaging**: dural-based + enhancing + dural tail; (7) **Treatment**: - **Asymptomatic small grade 1**: observation; - **Symptomatic / growing / accessible**: surgical resection — **Simpson grade** of resection (0-V) — predicts recurrence; - **Subtotal resection or higher grade**: adjuvant or salvage RT (stereotactic for small, fractionated for larger); - **Recurrent/refractory**: trials with bevacizumab, sunitinib, octreotide-derivatives, mTOR inhibitors; - **NF2 multiple meningiomas**: complex management, observation when possible, bevacizumab in some; (8) **Multidisciplinary**: neurosurgery + RT + neuropath + neuro-onc; genetic eval (NF2) if multiple/young

---

Meningioma: arachnoid cap; EMA+/SSTR2A+/PR+. CNS WHO 2021: grade 1-3 by histology + molecular (TERT or CDKN2A/B homozygous deletion → grade 3). NF2 sporadic + germline. Methylation classification emerging. Simpson resection grade; RT for residual/recurrent.', NULL,
  'medium', 'neuropathology', 'review',
  'pathology', 'clinical_decision', 'neuropathology', 'adult',
  'WHO CNS5 2021', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'path_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pathology'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี — adult — convexity dural-based brain mass → resection: meningothelial cells forming whorls + psammoma bodies; IHC: EMA+, SSTR2A+, progesterone receptor+; การวินิจฉัยและการ grade'
  );

commit;

