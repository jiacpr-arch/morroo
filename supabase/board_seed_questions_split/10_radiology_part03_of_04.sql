-- ===============================================================
-- หมอรู้ — Board seed: รังสีวิทยา (radiology) — part 3/4 (50 MCQs)
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
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี painless jaundice + weight loss — CT พบ pancreatic head mass + double duct sign (dilated CBD + pancreatic duct) + biliary obstruction', '[{"label":"A","text":"Discharge"},{"label":"B","text":"Pancreatic ductal adenocarcinoma (PDAC)"},{"label":"C","text":"Always inoperable - hospice"},{"label":"D","text":"Single specialty"},{"label":"E","text":"X-ray sufficient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pancreatic ductal adenocarcinoma (PDAC): (1) **Imaging features**: - **CT abdomen with pancreas protocol (multiphase IV contrast, pancreatic arterial + portal venous phases)** — first-line: hypoenhancing mass in pancreas (typically head — 60-70%), upstream pancreatic duct + CBD dilation (''double duct sign''), atrophy of distal pancreas, contour deformity, vascular involvement assessment (SMA, celiac, portal vein, SMV — critical for resectability); - **MRI/MRCP** — adjunct: characterization, isoattenuating tumors on CT not seen, biliary tree, branch-duct IPMN differential; - **EUS** — gold standard for small tumors + tissue diagnosis (FNA biopsy); - **PET/CT** — distant mets, indeterminate lesions; - **Diagnostic laparoscopy** — peritoneal mets assessment before major resection; (2) **Resectability classification (NCCN)**: - **Resectable**: no involvement of celiac, SMA; SMV/PV ≤ 180° contact reconstructible; - **Borderline resectable**: contact with celiac/SMA but not encasement (≤ 180° SMA, ≤ 180° celiac); SMV/PV > 180° contact or short-segment occlusion; - **Locally advanced (LAPC)**: > 180° encasement of celiac/SMA; long-segment SMV/PV occlusion not reconstructible; - **Metastatic**: distant mets; (3) **Treatment**: - **Resectable** — surgery (Whipple for head, distal pancreatectomy for body/tail, total pancreatectomy rarely) + adjuvant chemotherapy (mFOLFIRINOX — PRODIGE; or gemcitabine + capecitabine); increasingly neoadjuvant chemo even for resectable (ALLIANCE A021806, PREOPANC); - **Borderline resectable + LAPC** — neoadjuvant chemo (mFOLFIRINOX, gemcitabine + nab-paclitaxel) ± RT, then restage + consider surgery; - **Metastatic** — palliative chemo (FOLFIRINOX first-line if performance status good, gemcitabine + nab-paclitaxel alternative); BRCA + PARPi (olaparib — POLO); MSI-H — pembrolizumab; KRAS G12C/G12D emerging; (4) **Palliation**: - **Biliary obstruction** — endoscopic stenting (metal preferred for unresectable, plastic if going to OR), PTC if ERCP fails; - **Gastric outlet obstruction** — endoscopic stent or gastrojejunostomy; - **Pain** — celiac plexus block by IR/EUS for refractory pancreatic cancer pain; (5) **5-year survival** poor: ~ 10% overall, ~ 25% after R0 resection + adjuvant chemo; (6) **Multidisciplinary tumor board**: hepatobiliary/pancreatic surgery + medical oncology + radiation oncology + GI + IR + radiology + pathology + nutrition + palliative care

---

PDAC: CT pancreas protocol + MRI/MRCP + EUS biopsy. Resectability classification (NCCN). Whipple ± adjuvant. Increasingly neoadjuvant chemo. Borderline/LAPC — neoadjuvant. Metastatic — FOLFIRINOX. Palliation (stenting, celiac block). Poor prognosis. Multidisciplinary.', NULL,
  'hard', 'gi', 'review',
  'radiology', 'clinical_decision', 'gi', 'adult',
  'NCCN Pancreatic; AGA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี painless jaundice + weight loss — CT พบ pancreatic head mass + double duct sign (dilated CBD + pancreatic duct) + biliary obstruction'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 30 ปี chronic diarrhea + weight loss + abdominal pain + perianal disease — MR enterography พบ skip lesions terminal ileum + mural thickening + fat creeping', '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Crohn disease imaging — MR enterography (MRE) preferred"},{"label":"C","text":"X-ray only"},{"label":"D","text":"Discharge"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Crohn disease imaging — MR enterography (MRE) preferred: (1) **MRE features Crohn**: - **Skip lesions** (discontinuous involvement) — key DDx from UC (continuous from rectum); - **Terminal ileum involvement** (~ 80% of Crohn) — wall thickening, mucosal enhancement, mural T2 hyperintensity (acute inflammation/edema); - **Mesenteric (creeping) fat** — proliferation of fat around inflamed bowel — characteristic; - **Strictures** — fibrotic (low signal T2, less enhancement) vs inflammatory (high T2 + enhancement) — treatment implications; - **Fistulas + sinus tracts** — bowel-bowel, enterovesical, enterocutaneous, perianal; - **Abscesses** — pelvic, intra-abdominal; - **Comb sign** — engorged vasa recta along inflamed bowel; - **Mesenteric adenopathy**; (2) **Modality choices**: - **MRE** — preferred for young patients (no radiation, repeatable), perianal disease assessment (MRI pelvis), pediatric; - **CT enterography (CTE)** — alternative, faster, fewer artifacts, but radiation; - **US** — emerging, no radiation, good for follow-up + acute symptoms; - **Colonoscopy + ileoscopy + biopsy** — gold standard mucosal evaluation + histology + risk of dysplasia surveillance; - **Capsule endoscopy** for small bowel disease undetected by other modalities (caution stricture); (3) **Differential UC vs Crohn**: UC — continuous from rectum, mucosal only, no skip, no perianal, no fistulas (typically), ''lead pipe'' colon chronic; Crohn — discontinuous, transmural, terminal ileum + colon, perianal, fistulas; (4) **Complications imaging**: - Stricture (fibrotic — balloon dilation by GI or surgery; inflammatory — anti-TNF response); - Fistula (perianal — multidisciplinary IBD + colorectal surgery + IR + GI); - Abscess (image-guided drainage by IR, antibiotics, then biologic therapy); - Cancer surveillance (colonoscopy + biopsies q1-3 years after 8 years of pancolitis); (5) **Treatment**: - 5-ASA (UC > Crohn limited efficacy); - Corticosteroids — acute flares; budesonide for terminal ileum/right colon; - **Immunomodulators** (azathioprine, MTX); - **Biologics**: anti-TNF (infliximab, adalimumab); anti-integrin (vedolizumab); anti-IL-12/23 (ustekinumab); anti-IL-23 (risankizumab, mirikizumab); JAK inhibitors (tofacitinib, upadacitinib); selection by phenotype + risk + comorbidities; - **Surgery** for medication failure + complications (strictures, fistulas, dysplasia/cancer); (6) **Multidisciplinary IBD clinic**: GI + colorectal surgery + radiology + IR + nutrition + nursing + pharmacy + mental health + rheumatology if EIM

---

Crohn disease: MRE preferred (no radiation). Skip lesions + terminal ileum + creeping fat + transmural + perianal + fistulas. Differential UC. Complications: stricture, fistula, abscess. Biologics + selective immunomodulators + surgery. Multidisciplinary IBD clinic.', NULL,
  'medium', 'gi', 'review',
  'radiology', 'clinical_decision', 'gi', 'adult',
  'ACG IBD; ECCO Crohn', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 30 ปี chronic diarrhea + weight loss + abdominal pain + perianal disease — MR enterography พบ skip lesions terminal ileum + mural thickening + fat creeping'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี hematuria + flank pain — CT พบ 4 cm enhancing solid renal mass — incidental finding', '[{"label":"A","text":"Always benign — observe"},{"label":"B","text":"Renal cell carcinoma (RCC) — Bosniak + management"},{"label":"C","text":"Always biopsy first"},{"label":"D","text":"Discharge"},{"label":"E","text":"Single specialty"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Renal cell carcinoma (RCC) — Bosniak + management: (1) **Imaging characterization solid renal mass**: - **CT abdomen with multiphase IV contrast** (non-contrast + corticomedullary + nephrographic + excretory) — gold standard; > 20 HU enhancement = solid enhancing mass; - **MRI** when contrast contraindicated or characterization; - Look for: enhancement, growth, fat (AML — angiomyolipoma — fat density), calcification, necrosis, vascular invasion (renal vein, IVC — surgical implication); (2) **Bosniak classification for cystic renal lesions** (for cysts, not solid masses; revised 2019): - I: simple cyst, < 5% malignancy — no follow-up; - II: minimally complex (thin septa, fine calcifications), benign; - IIF: moderately complex — surveillance imaging; - III: complex (thick irregular septa, irregular wall) — 50% malignancy — surgical exploration/biopsy; - IV: enhancing soft tissue components — > 90% malignancy — surgery; (3) **Solid enhancing renal mass approach**: - Stage with CT chest + abdomen-pelvis (or MRI), look for metastases (lung + bone most common); - Biopsy considerations: ~ 20% of small (< 4 cm) solid masses are benign (oncocytoma, AML without fat — fat-poor AML, lipid-poor); biopsy helpful for: indeterminate, comorbidities affecting surgical risk, planning ablation, advanced disease for tissue + molecular; - Solid + fat = AML (benign — surveillance unless > 4 cm or symptomatic — embolization); (4) **Renal cell carcinoma staging**: TNM 8th ed; (5) **Treatment options**: - **Partial nephrectomy (preferred for T1)** — preserve renal function, oncologically equivalent for small tumors; robotic minimally invasive standard; - **Radical nephrectomy** for larger tumors, central tumors, vascular invasion; - **Ablation (RFA, cryoablation, MWA)** by IR — small (< 3-4 cm) exophytic tumors, comorbid patients unable for surgery; - **Active surveillance** for small renal masses (≤ 4 cm) in elderly or with comorbidities — slow growth in most; - **Cytoreductive nephrectomy** controversial in metastatic (CARMENA trial — sunitinib alone non-inferior to surgery + sunitinib); (6) **Metastatic RCC systemic therapy**: combination immunotherapy + TKI now standard (pembrolizumab + axitinib, nivolumab + ipilimumab, lenvatinib + pembrolizumab, cabozantinib + nivolumab); first-line by IMDC risk; (7) **Multidisciplinary**: urology + medical oncology + radiation oncology + IR + radiology

---

Renal mass: CT multiphase for enhancement + characterization. Bosniak for cysts (revised 2019). Solid + fat = AML benign. Biopsy selective. Partial nephrectomy preferred for T1. Ablation alternative for small/comorbid. Active surveillance selected. Combination IO+TKI for metastatic.', NULL,
  'medium', 'renal_gu', 'review',
  'radiology', 'clinical_decision', 'renal_gu', 'adult',
  'Bosniak 2019; NCCN Kidney Cancer; AUA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี hematuria + flank pain — CT พบ 4 cm enhancing solid renal mass — incidental finding'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 40 ปี acute left flank pain + hematuria + nausea — non-contrast CT KUB พบ 5 mm stone at left ureterovesical junction + mild hydronephrosis', '[{"label":"A","text":"Always surgery"},{"label":"B","text":"Urolithiasis — imaging + management"},{"label":"C","text":"X-ray sufficient"},{"label":"D","text":"Discharge no follow-up"},{"label":"E","text":"Single specialty"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Urolithiasis — imaging + management: (1) **Imaging modality**: - **Non-contrast CT abdomen-pelvis (CT KUB / ''stone protocol'')** — gold standard: identifies stones (any composition except indinavir — drug-related rare), location, size, density (HU — higher density less likely to pass + harder to fragment), hydronephrosis, perinephric stranding; sensitivity ~ 95-100%, specificity ~ 95-100%; low-dose protocols reduce radiation; - **Ultrasound** — initial in pregnancy, pediatric, to reduce radiation; identifies hydronephrosis + larger stones; sensitivity lower than CT (~ 70-90%) — Twinkle artifact aids stone detection; - **KUB plain X-ray** — limited; only radiopaque stones (calcium); follow-up; - **IVP** — historical; (2) **Imaging-based decisions**: - Stone size + location → likelihood of spontaneous passage (< 5 mm: 80%, 5-7 mm: 60%, 7-10 mm: 50%, > 10 mm: low; distal more likely to pass); - HU density > 1000 → less likely shock wave lithotripsy success; - Anatomic factors (UPJ obstruction, horseshoe kidney, transplant kidney); (3) **Management**: - **Conservative (medical expulsive therapy)** for uncomplicated < 10 mm: hydration, analgesics (NSAIDs preferred — ketorolac IV, decreases ureteral contractility + renal capsule pressure; opioids for breakthrough), antiemetics, alpha-blocker (tamsulosin — controversial efficacy, modest benefit for distal stones 5-10 mm per SUSPEND, EAU includes); follow-up to confirm passage; - **Urgent intervention indications**: obstruction + infection (urosepsis — emergency, antibiotic + decompression — ureteral stent or percutaneous nephrostomy), acute kidney injury (especially solitary kidney), intractable pain/vomiting, large stone unlikely to pass; - **Definitive therapies**: - **ESWL (extracorporeal shock wave lithotripsy)** — non-invasive, less effective for large/dense/lower pole; - **Ureteroscopy + holmium laser lithotripsy** — most precise; - **PCNL (percutaneous nephrolithotomy)** for large kidney stones (> 2 cm); - Stent placement to relieve obstruction; (4) **Recurrence prevention**: hydration > 2.5 L/day, low salt + animal protein, moderate calcium intake (calcium binds oxalate — paradoxically reduces stone risk), citrate intake (citrus, potassium citrate Rx), based on stone composition (struvite — infection management, uric acid — alkalinization, cystine — alkalinization + thiols); 24-h urine collection for recurrent + high-risk; (5) **Multidisciplinary**: urology + ED + radiology + IR + nephrology

---

Urolithiasis: CT KUB gold standard. US in pregnancy. Conservative for uncomplicated < 10 mm. Urgent — obstruction + infection (urosepsis), AKI, intractable. Definitive (ESWL, ureteroscopy + laser, PCNL). Recurrence prevention with hydration + diet. Multidisciplinary.', NULL,
  'easy', 'renal_gu', 'review',
  'radiology', 'clinical_decision', 'renal_gu', 'adult',
  'AUA/EAU Urolithiasis Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 40 ปี acute left flank pain + hematuria + nausea — non-contrast CT KUB พบ 5 mm stone at left ureterovesical junction + mild hydronephrosis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 70 ปี gross hematuria — cystoscopy พบ bladder mass — CT urogram for staging', '[{"label":"A","text":"X-ray sufficient"},{"label":"B","text":"Bladder cancer — imaging + staging"},{"label":"C","text":"Discharge"},{"label":"D","text":"Always observation"},{"label":"E","text":"Single specialty"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bladder cancer — imaging + staging: (1) **Initial evaluation**: - **Cystoscopy + biopsy** — gold standard diagnosis (urothelial carcinoma most common in West, squamous in schistosomiasis-endemic, adenocarcinoma rare); - **Urine cytology** — adjunct, low sensitivity for low-grade; - **NMP22, UroVysion FISH** — selected; (2) **Imaging**: - **CT urogram (CTU) — first-line for upper tract evaluation + hematuria workup**: multiphase IV contrast — corticomedullary, nephrographic, excretory phases — synchronous + metachronous upper tract urothelial carcinoma (~ 5%), staging local + nodal + distant; - **MRI pelvis with multiparametric protocol** — for local T-staging (depth of invasion — T1 lamina propria, T2 muscle, T3 perivesical fat, T4 adjacent organs); VI-RADS (Vesical Imaging-Reporting and Data System) for muscle invasion prediction — recent development; - **CT chest** — for muscle-invasive + distant staging; - **PET/CT** — selective for muscle-invasive + lymph node staging; - **Bone scan** — symptomatic / elevated ALP / muscle-invasive; (3) **Staging-based treatment**: - **Non-muscle invasive (Ta, T1, CIS)** (~ 75% at diagnosis): - TURBT + intravesical therapy (BCG for high-risk — most effective; mitomycin); - Surveillance cystoscopy q3-6 months × years (high recurrence rate); - Persistent CIS / BCG-refractory: pembrolizumab (KEYNOTE-057), nadofaragene (gene therapy), cystectomy; - **Muscle-invasive (T2-T4)**: - **Neoadjuvant cisplatin-based chemo (MVAC, dose-dense MVAC, gemcitabine + cisplatin) + radical cystectomy + pelvic LN dissection** — standard of care; OS benefit ~ 5-8% absolute over surgery alone; - **Bladder-sparing** trimodal therapy (TURBT + concurrent chemoradiation) — selected for smaller solitary tumors, organ preservation, patient preference; - Adjuvant immunotherapy (nivolumab — CheckMate 274 — for ypT2-4 or yN+ after neoadj chemo); - **Metastatic**: chemo (cis/carbo + gem) → immunotherapy (avelumab maintenance — JAVELIN Bladder 100, pembrolizumab); enfortumab vedotin (ADC — Nectin-4 targeting); FGFR inhibitors (erdafitinib) for FGFR-altered; (4) **Risks**: smoking (#1), occupational (aromatic amines, dyes), schistosomiasis (squamous in endemic areas), aristolochic acid; (5) **Multidisciplinary**: urology + medical oncology + radiation oncology + radiology + pathology + nursing + nutrition + palliative care + stoma nurse for cystectomy patients

---

Bladder cancer: cystoscopy + biopsy. CT urogram for staging + upper tracts. MRI VI-RADS for local T-stage. Non-muscle invasive: TURBT + BCG. Muscle-invasive: neoadj chemo + cystectomy or trimodal therapy. Nivolumab adjuvant. Enfortumab vedotin metastatic. Multidisciplinary.', NULL,
  'hard', 'renal_gu', 'review',
  'radiology', 'clinical_decision', 'renal_gu', 'adult',
  'NCCN Bladder Cancer; AUA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 70 ปี gross hematuria — cystoscopy พบ bladder mass — CT urogram for staging'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี incidental 2 cm adrenal mass on CT done for trauma — non-functioning suspected

คำถาม: workup adrenal incidentaloma', '[{"label":"A","text":"Always biopsy"},{"label":"B","text":"Adrenal incidentaloma — Choosing Wisely approach"},{"label":"C","text":"Always surgery"},{"label":"D","text":"Discharge no workup"},{"label":"E","text":"Single specialty"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Adrenal incidentaloma — Choosing Wisely approach: (1) **Definition**: incidentally discovered adrenal mass ≥ 1 cm on imaging not initially targeted at adrenals; ~ 4-7% of abdominal CTs; (2) **Two key questions**: (a) **Is it malignant?** (b) **Is it functional (hormonally active)?**; (3) **Imaging characterization for malignancy**: - **Non-contrast CT < 10 HU** = lipid-rich adenoma (benign, ~ 70% of adenomas) — no further imaging unless functional or growing; - **Adrenal CT washout protocol** for lesions ≥ 10 HU: pre-contrast + 60-second post-contrast + 15-minute delayed phase: absolute washout > 60% or relative washout > 40% = lipid-poor adenoma (benign); poor washout = potentially malignant or pheochromocytoma; - **MRI chemical shift imaging** — signal drop on out-of-phase = adenoma (lipid content); - **Heterogeneous, > 4 cm, irregular margins, central necrosis, calcifications, hemorrhage** — suspicious for malignancy (adrenocortical carcinoma, metastasis, pheochromocytoma); - **FDG-PET** — high SUV uptake suggests malignancy; (4) **Functional workup (all incidentalomas)** — biochemical screening: - **24h urine metanephrines or plasma free metanephrines** — pheochromocytoma (always rule out before biopsy or surgery — hypertensive crisis risk); - **Overnight 1 mg dexamethasone suppression test** — Cushing syndrome / autonomous cortisol secretion; - **Aldosterone-renin ratio** — primary hyperaldosteronism (if hypertensive); - **DHEA-S** — adrenal androgen excess (selected); (5) **Indications for adrenalectomy**: - Functional adenoma — pheo, primary aldosteronism (Conn), cortisol-producing (overt Cushing); - Suspicious for malignancy (size > 4 cm, suspicious imaging features, growth); - Bilateral large adrenal masses; (6) **Surveillance** for non-functioning < 4 cm with benign imaging features: - One follow-up CT/MRI at 6-12 months to confirm stability (per AACE/AAES + recent ESE guidelines; some suggest no follow-up if clearly benign on initial imaging — recent shift); - Repeat hormonal screening for cortisol q1-5 years (subclinical Cushing); (7) **Biopsy RARELY needed**: only for known extra-adrenal cancer when changes management + benign features ruled out + pheochromocytoma excluded biochemically; (8) **Multidisciplinary**: endocrinology + radiology + urology/endocrine surgery + medical oncology if metastasis

---

Adrenal incidentaloma: characterize (non-contrast HU, washout, MRI chemical shift) + functional workup (metanephrines, dex suppression, aldosterone-renin). Surgery for functional, suspicious, > 4 cm. Surveillance for benign non-functioning. Rarely biopsy. EXCLUDE pheo before biopsy/surgery. Multidisciplinary.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'radiology', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'AACE/AAES Adrenal Incidentaloma; ESE 2023', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี incidental 2 cm adrenal mass on CT done for trauma — non-functioning suspected

คำถาม: workup adrenal incidentaloma'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี elevated PSA + abnormal DRE — prostate MRI for biopsy planning', '[{"label":"A","text":"Biopsy first then MRI"},{"label":"B","text":"Prostate MRI + PI-RADS"},{"label":"C","text":"Discharge"},{"label":"D","text":"Single specialty"},{"label":"E","text":"X-ray sufficient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Prostate MRI + PI-RADS: (1) **Multi-parametric prostate MRI (mpMRI)** — T2W + DWI/ADC + DCE (dynamic contrast-enhanced) — standard for clinically significant prostate cancer (csPCa, Gleason ≥ 3+4) detection + localization + staging; (2) **PI-RADS v2.1 classification (peripheral zone — DWI dominant; transition zone — T2 dominant)**: - **PI-RADS 1**: very low; - **PI-RADS 2**: low; - **PI-RADS 3**: equivocal; - **PI-RADS 4**: high — biopsy recommended; - **PI-RADS 5**: very high — biopsy recommended; (3) **Use in clinical workflow**: - **Pre-biopsy MRI** (PRECISION trial — improves detection of csPCa, reduces detection of clinically insignificant) — recommended before initial biopsy in elevated PSA per EAU + many guidelines, NCCN evolving; - **Targeted MRI/US fusion biopsy** for PI-RADS 4-5 lesions + concurrent systematic biopsy; - **Active surveillance** monitoring; - **Local staging** for known cancer (extraprostatic extension, seminal vesicle invasion, lymph node staging); (4) **Other imaging in prostate cancer**: - **Bone scan / NaF PET** for high-risk staging (PSA > 20, Gleason ≥ 8, T3-4) — bone mets; - **PSMA PET/CT** — revolutionized prostate cancer imaging — biochemical recurrence (PSA rising post-treatment) with very high sensitivity (proPSMA trial — superior to conventional CT + bone scan), recently approved for staging high-risk pre-treatment + recurrence (CONDOR, OSPREY trials); guides salvage therapy + metastasis-directed therapy (MDT); - **CT abdomen-pelvis** for nodal + visceral staging; (5) **Risk-stratified treatment options**: - **Very low / low risk (Gleason 6, PSA < 10)** — active surveillance preferred (PIVOT, ProtecT, PROTECT-T trials); - **Intermediate-favorable** — surveillance or treatment; - **Intermediate-unfavorable / high risk** — surgery (robotic radical prostatectomy + pelvic LN dissection), radiation therapy (external beam + brachytherapy boost for high risk) + ADT (androgen deprivation therapy for high risk 18-36 months); - **Metastatic hormone-sensitive** — ADT + docetaxel or AR-pathway inhibitor (abiraterone, enzalutamide, apalutamide, darolutamide); triplet therapy emerging; - **Metastatic CRPC (castration-resistant)** — multiple lines (taxanes, abiraterone, enzalutamide, radium-223, PARPi for BRCA-altered, sipuleucel-T, Lu-177 PSMA radioligand therapy — VISION trial); (6) **Multidisciplinary**: urology + medical oncology + radiation oncology + radiology + pathology + nuclear medicine + nursing + palliative care

---

Prostate MRI mpMRI + PI-RADS for pre-biopsy + targeted fusion biopsy (PRECISION). PSMA PET revolutionized recurrence + high-risk staging (proPSMA). Risk-stratified treatment (AS, RP, RT + ADT, multiple systemic lines including Lu-177 PSMA). Multidisciplinary.', NULL,
  'hard', 'renal_gu', 'review',
  'radiology', 'clinical_decision', 'renal_gu', 'adult',
  'PI-RADS v2.1; NCCN Prostate; EAU', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี elevated PSA + abnormal DRE — prostate MRI for biopsy planning'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 16 ปี acute severe testicular pain × 2 ชั่วโมง — examination พบ swollen tender testicle — testicular torsion suspected', '[{"label":"A","text":"Conservative observation"},{"label":"B","text":"Testicular torsion — emergent"},{"label":"C","text":"Discharge"},{"label":"D","text":"Single specialty"},{"label":"E","text":"X-ray sufficient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Testicular torsion — emergent: (1) **Clinical features**: sudden severe pain, swelling, high-riding testicle, transverse lie, absent cremasteric reflex, often nausea/vomiting, recent activity/trauma trigger but often spontaneous (sleep); (2) **Imaging when DOES NOT delay surgery** — if clinical certainty high → straight to OR: - **Scrotal Doppler US — first-line**: absent or markedly diminished blood flow on color/spectral Doppler in affected testicle (compare to contralateral); ''whirlpool sign'' of twisted cord; testicular swelling + heterogeneous (late — necrosis); - **POCUS** at bedside if available — sensitivity high for trained operators; - **Color Doppler — sensitivity 88-90%, specificity 99%** — operator-dependent; - **Scintigraphy** historical (decreased uptake) — slow + unavailable; (3) **Time-critical**: testicular salvage rates: < 6 hours ~ 90-100%; 6-12 hours ~ 50%; > 12 hours < 20%; > 24 hours rare; (4) **Management**: - **Emergent urology consultation** before/during imaging; - **Manual detorsion attempt** in ED while waiting OR — typically rotate outward (''open like a book'') — relief of pain suggests success; not definitive (must still go to OR); - **Surgical exploration + detorsion + bilateral orchiopexy** (contralateral too — prevent future); - **Non-viable testicle — orchiectomy**; (5) **Differential**: epididymitis (older, gradual, fever, dysuria, increased flow on Doppler — opposite of torsion), torsion of appendix testis (blue dot sign, less severe, often self-limited), trauma, hernia, hydrocele/varicocele complications, idiopathic scrotal edema; (6) **Pediatric considerations** — peak incidence ages 12-18, neonatal (often perinatal extravaginal — different mechanism, often non-salvageable at birth); (7) **Recurrent torsion** prevention — bilateral orchiopexy; (8) **Family communication + counseling** — testicular loss, fertility implications, follow-up; (9) **Multidisciplinary**: ED + urology + radiology + pediatric urology if pediatric

---

Testicular torsion: clinical Dx — high clinical suspicion straight to OR. Doppler US first-line — absent flow + whirlpool sign. Time-critical (< 6h best). Manual detorsion attempt + emergent surgery + bilateral orchiopexy. Multidisciplinary.', NULL,
  'easy', 'renal_gu', 'review',
  'radiology', 'clinical_decision', 'renal_gu', 'adult',
  'AUA Acute Scrotum; ACR Appropriateness', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'เด็กชายอายุ 16 ปี acute severe testicular pain × 2 ชั่วโมง — examination พบ swollen tender testicle — testicular torsion suspected'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 35 ปี incidental complex ovarian mass on imaging — O-RADS classification', '[{"label":"A","text":"Always benign — observe"},{"label":"B","text":"Ovarian/adnexal mass — O-RADS"},{"label":"C","text":"Always surgery"},{"label":"D","text":"Discharge"},{"label":"E","text":"Single specialty"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Ovarian/adnexal mass — O-RADS: (1) **O-RADS US** (lexicon + risk categories — based on IOTA-derived simple rules): - **O-RADS 0**: incomplete — additional imaging; - **O-RADS 1**: normal ovary; - **O-RADS 2**: almost certainly benign (< 1% malignancy) — simple cyst, hemorrhagic cyst < 5 cm, etc.; - **O-RADS 3**: low risk (1-10%); - **O-RADS 4**: intermediate (10-50%); - **O-RADS 5**: high (≥ 50%); (2) **O-RADS MRI** for indeterminate adnexal masses (especially O-RADS 3-4 on US) — high specificity for benign vs malignant: - 5-point scale based on signal characteristics, enhancement; - Adnexal masses with cystic components — different from solid; - Time-intensity curves on DCE-MRI (type 1 slow benign, type 2 intermediate, type 3 rapid washout malignant); (3) **Common benign masses**: simple cysts (functional), hemorrhagic cysts (T1 hyperintense, fluid-fluid level, shrinking on follow-up), endometrioma (''chocolate cyst'' — T1 hyperintense, T2 shading), dermoid (mature cystic teratoma — fat content + calcifications + Rokitansky nodule), fibroma, fibrothecoma; (4) **Tumor markers + adjuncts**: - **CA-125** — limited as screening (false positives in endometriosis, fibroids, menstruation, peritonitis, etc.); useful for follow-up of known cancer; - **HE4** + CA-125 — ROMA score; - **AFP, β-hCG, LDH** — germ cell tumors in young; - **Inhibin** — sex cord-stromal; (5) **Management based on risk**: - O-RADS 1-2 → routine, follow-up only for specific entities; - O-RADS 3 → gynecologic consultation + interval follow-up; - O-RADS 4-5 → gynecologic oncology referral; (6) **Ovarian cancer staging + treatment**: - **Staging**: CT chest-abdomen-pelvis + tumor markers + diagnostic laparoscopy/laparotomy; - **Surgery** — bilateral salpingo-oophorectomy + total abdominal hysterectomy + comprehensive staging or cytoreduction (debulking) for advanced; gyn-onc subspecialty; - **Adjuvant chemo**: platinum-taxane (carboplatin + paclitaxel) standard; - **Maintenance**: PARPi (olaparib, niraparib) for BRCA-mutated + HRD; bevacizumab; - **Recurrent**: platinum-sensitive vs resistant — multiple lines; (7) **Hereditary**: BRCA1/2, Lynch syndrome — genetic counseling + risk-reducing surgery (RRSO) recommended; (8) **Multidisciplinary**: gynecologic oncology + radiology + medical oncology + radiation oncology + pathology + nursing + palliative care + genetics

---

O-RADS for ovarian/adnexal masses (US + MRI). Risk-stratified categories 0-5. MRI for indeterminate. Tumor markers (CA-125 + HE4 + ROMA + germ cell). Gyn-onc referral for O-RADS 4-5. Multidisciplinary cancer care + PARPi maintenance + genetics.', NULL,
  'medium', 'obgyn', 'review',
  'radiology', 'clinical_decision', 'obgyn', 'adult',
  'ACR O-RADS US + MRI; NCCN Ovarian', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'หญิงอายุ 35 ปี incidental complex ovarian mass on imaging — O-RADS classification'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 30 ปี first-trimester pregnancy + RUQ pain — imaging considerations', '[{"label":"A","text":"No imaging in pregnancy ever"},{"label":"B","text":"Imaging in pregnancy — modality selection"},{"label":"C","text":"Always CT"},{"label":"D","text":"Single specialty"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Imaging in pregnancy — modality selection: (1) **General principles**: - Risk-benefit analysis: maternal indication usually outweighs fetal risk; - Modality preferences: US > MRI > CT (radiation); - Cumulative fetal dose ≤ 50 mGy threshold for deterministic effects per ACR + ACOG; most diagnostic CT studies far below; - Shielding minimally protective for direct beam — modern thinking; - ''Pregnant or could-be-pregnant'' status checked + documented; (2) **Modality-specific**: - **US — first-line for most indications in pregnancy**: no radiation, no contrast; abdominal pain — gallstones, appendicitis (limited later); pelvic; obstetric; thrombus (DVT); musculoskeletal; - **MRI without contrast — second-line**: no radiation; gadolinium contrast generally avoided in pregnancy (NSF + fetal effects — gadolinium crosses placenta + recirculates in fetal urine) — only if essential, no alternative, after counseling; - **CT — only when necessary**: lower-dose protocols; abdominal CT typical 10-25 mGy fetal dose (below threshold but cumulative consideration); CTPA for suspected PE (low fetal dose with breast shielding — alternative V/Q scan also low dose to fetus); contrast iodinated — generally safe (fetal thyroid concerns minimal with single exposure); - **Nuclear medicine**: case-by-case; V/Q scan for PE — low fetal dose (1.4 mGy); thyroid uptake/treatment contraindicated; (3) **ACR Appropriateness for common scenarios**: - **Suspected PE in pregnancy**: D-dimer + Wells, US lower extremity if signs; if imaging needed — CTPA or V/Q (controversies — V/Q lower breast radiation, CTPA lower fetal radiation if breast shielding); CTPA preferred more recently; - **Suspected appendicitis**: US first → MRI if non-diagnostic → CT if needed; - **Cholelithiasis**: US first-line; - **Trauma**: indicated CT not deferred (mother-first principle); - **Stroke**: MRI without gadolinium first-line; CT if MRI not available; - **Headache**: MRI without contrast if needed; (4) **Patient counseling**: shared decision-making, written information, document discussion; (5) **Lactation**: most contrast (iodinated + macrocyclic gadolinium) compatible — continue breastfeeding; (6) **Multidisciplinary**: OB + radiology + ED + specialist consultants

---

Imaging in pregnancy: risk-benefit; US > MRI > CT. Fetal dose < 50 mGy threshold. Avoid gadolinium unless essential. Iodinated contrast generally safe. ACR Appropriateness for common scenarios (PE, appendicitis, etc.). Shared decision-making + documentation. Multidisciplinary.', NULL,
  'medium', 'obgyn', 'review',
  'radiology', 'clinical_decision', 'obgyn', 'adult',
  'ACR/ACOG Imaging in Pregnancy; ACR Manual on Contrast Media', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'หญิงอายุ 30 ปี first-trimester pregnancy + RUQ pain — imaging considerations'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี hypertension + episodic palpitations + sweating + headache — pheochromocytoma suspected', '[{"label":"A","text":"Beta-blocker first"},{"label":"B","text":"Pheochromocytoma — imaging + management"},{"label":"C","text":"Surgery without alpha-blockade"},{"label":"D","text":"Discharge"},{"label":"E","text":"Single specialty"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pheochromocytoma — imaging + management: (1) **Diagnosis**: - **Biochemical first** (always before imaging): plasma free metanephrines + normetanephrines (high sensitivity ~ 99%, lower specificity), 24h urine fractionated metanephrines + catecholamines; **avoid** medications interfering (tricyclics, MAOIs, decongestants — discontinue before testing); - Confirmed elevation → **imaging localization**: - **CT abdomen with IV contrast** — high sensitivity for adrenal pheo (10-15 HU non-contrast typically, avid enhancement, may be heterogeneous, cystic/hemorrhagic, larger lesions); - **MRI alternative** — T2 hyperintense (''light bulb'' sign — classic but not always present); - **Functional imaging** for extra-adrenal paraganglioma + metastatic + hereditary syndromes: - **MIBG scintigraphy** (I-123 MIBG) — adrenal + extra-adrenal pheo/paraganglioma + metastases; - **68Ga-DOTATATE PET/CT** — sensitive for SDHB-mutated + metastatic + paraganglioma (often outperforms MIBG, becoming first-line for some scenarios); - **FDG-PET** alternative; (2) **Hereditary syndromes (40% of pheo/PGL — genetic)**: VHL, MEN2A/B, NF1, SDHx (SDHB, SDHD — paraganglioma syndromes), TMEM127, MAX — genetic testing recommended for all; SDHB high metastatic risk; (3) **Pre-operative management**: - **Alpha-blockade first (essential)** — phenoxybenzamine (non-selective long-acting) or doxazosin (selective alpha-1, shorter acting, fewer side effects) for 10-14 days; - **Then beta-blockade** for tachycardia (NEVER beta-blocker first — unopposed alpha causes hypertensive crisis); - Liberal salt + fluids to expand intravascular volume pre-op; - Avoid medications causing release (glucagon, metoclopramide, certain anesthetics); (4) **Surgery**: laparoscopic adrenalectomy (cortical-sparing for bilateral hereditary), open for large/invasive/extra-adrenal; intra-op blood pressure swings expected; (5) **Post-op**: monitoring for hypotension (sudden withdrawal of catecholamines), hypoglycemia (rebound), surveillance metanephrines + imaging; (6) **Metastatic pheo/PGL**: I-131 MIBG radionuclide therapy, Lu-177 DOTATATE PRRT, chemo (CVD — cyclophosphamide, vincristine, dacarbazine), tyrosine kinase inhibitors (sunitinib selected); (7) **Multidisciplinary**: endocrinology + endocrine surgery + radiology + nuclear medicine + genetics + medical oncology if metastatic

---

Pheochromocytoma: biochemical first (plasma free metanephrines) → CT/MRI + functional imaging (MIBG, DOTATATE). Hereditary syndromes 40% — genetic testing. Alpha-blockade FIRST then beta-blockade pre-op. Adrenalectomy. Surveillance. Multidisciplinary.', NULL,
  'hard', 'endocrine_metabolic', 'review',
  'radiology', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'Endocrine Society Pheo/PGL Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี hypertension + episodic palpitations + sweating + headache — pheochromocytoma suspected'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Ultrasound physics + common artifacts', '[{"label":"A","text":"No artifacts to know"},{"label":"B","text":"Ultrasound physics + artifacts"},{"label":"C","text":"Always interpretable"},{"label":"D","text":"Discharge"},{"label":"E","text":"Single mode only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Ultrasound physics + artifacts: (1) **Physics basics**: piezoelectric crystals in transducer convert electrical to mechanical (acoustic) waves + back; high-frequency probes (7-15 MHz — linear) — higher resolution + shallower penetration (superficial, vascular, MSK); low-frequency (2-5 MHz — curvilinear, phased array) — deeper penetration + lower resolution (abdomen, OB, cardiac); (2) **Modes**: B-mode (2D anatomy), M-mode (motion vs time — cardiac), color/power Doppler (flow), spectral Doppler (velocity quantification), elastography (tissue stiffness), contrast-enhanced US (microbubbles); (3) **Common artifacts**: - **Acoustic shadowing**: dense structures (stones, bone, calcifications, air) block transmission — posterior shadowing; - **Posterior acoustic enhancement**: fluid-filled (cysts) transmits more — bright behind; differentiates cyst from solid; - **Reverberation**: parallel reflectors — repeated echoes (comet tail, ring-down); ''A-lines'' lung; - **Mirror image**: at strong reflector (diaphragm) — duplicate liver appearing above diaphragm; - **Edge artifact / refractive shadowing**: rounded structures (gallbladder, cysts) — shadowing at edges; - **Side lobe artifact**: false echoes from off-axis beams; - **Twinkling**: behind crystalline structures (stones) on color Doppler — aids stone detection; - **Aliasing**: Doppler exceeds Nyquist limit (PRF/2) — color reversal or wrap-around in spectral; - **B-lines** (lung): hyperechoic vertical lines extending from pleura — pulmonary edema, ILD, pneumonia; - **Lung sliding + lung pulse + lung point**: pneumothorax exclusion (presence of sliding rules out PTX at that location); (4) **Clinical applications expanding** — POCUS (lung, FAST, cardiac), nerve blocks, vascular access, dynamic imaging, pediatric (no radiation), pregnancy; (5) **Limitations**: operator-dependent, body habitus (obesity), bowel gas, depth limitations

---

US physics: high freq superficial, low freq deep. Modes (B, M, Doppler, elastography, CEUS). Artifacts: shadowing (stones), enhancement (cysts), reverberation (A-lines, comet), mirror, twinkling (stones on Doppler), B-lines (edema). POCUS expanding. Operator-dependent.', NULL,
  'easy', 'procedures', 'review',
  'radiology', 'basic_science', 'procedures', 'adult',
  'AIUM Standards; Radiology Physics', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Ultrasound physics + common artifacts'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'MRI safety — zones + screening + projectiles', '[{"label":"A","text":"No screening needed"},{"label":"B","text":"MRI safety — 4 zones + screening"},{"label":"C","text":"Magnet turned off between scans"},{"label":"D","text":"Discharge"},{"label":"E","text":"Single zone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** MRI safety — 4 zones + screening: (1) **ACR MR Safety Zones** (4-zone access control): - **Zone I**: open public area, no restriction; - **Zone II**: interface between unscreened public + restricted, screening starts (waiting room, reception); - **Zone III**: restricted to screened personnel + patients (control room area, near scanner); - **Zone IV**: scanner room (magnet on at all times — even when ''off''); only screened + supervised; (2) **Screening — every entry**: - **Implanted devices**: pacemaker/ICD (older — contraindicated; many modern devices MR-conditional — vendor + parameters specified), cochlear implants, neurostimulators, drug pumps, aneurysm clips (older ferromagnetic vs newer non-ferromagnetic), intracranial coils, IVC filters, joint replacements (most MR-conditional or safe), penile implants, retained bullets/shrapnel, retained tattoos (rarely heating), retained metal fragments (especially in eyes — orbital X-ray screening for workers in occupations); - **Pregnancy**: first trimester relative caution — counsel + indications; - **Renal function**: if gadolinium contemplated (eGFR, NSF risk); - **Claustrophobia + sedation needs**; - **Body habitus** (bore size); - **Recent surgery / device placement** (must be confirmed safe); (3) **Projectile hazards**: - Magnet always ON — ferromagnetic objects (oxygen tanks, IV poles, scissors, keys, monitors) accelerate to high velocities, can become deadly missiles; - High-profile fatalities historically (oxygen tank case); - All equipment entering scanner room must be MR-safe (green label) or conditional (yellow); MR-unsafe (red — forbidden); - Visitor screening + escort; (4) **Heating + burns**: RF energy deposition (SAR — specific absorption rate); avoid skin-to-skin contact (loops), wires/leads (looped — induce currents + burns); ECG, pulse ox cables — MR-compatible only; (5) **Quench safety**: emergency dump of cryogens (helium → gas, displaces oxygen, frostbite) — quench button only in true emergency; ventilation; (6) **Loud noise**: > 100 dB — hearing protection mandatory; (7) **Contrast safety**: gadolinium (above question — NSF, retention); (8) **Pediatric + claustrophobic**: sedation/anesthesia in selected — full monitoring; (9) **Multidisciplinary**: radiology + MRI tech + nursing + anesthesia + medical physics + administration + safety officer; (10) **Modern**: MR-conditional devices increasingly available — check vendor specifications + manufacturer''s IFU before scanning

---

MR safety: 4 zones (I-IV). Screening for implants + projectiles + pregnancy + renal function. Magnet ALWAYS ON — projectile hazards. Heating + burns from cables (no loops). Quench emergency only. MR-conditional devices increasing. Multidisciplinary safety culture.', NULL,
  'easy', 'procedures', 'review',
  'radiology', 'basic_science', 'procedures', 'adult',
  'ACR Manual on MR Safety 2024', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'MRI safety — zones + screening + projectiles'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'PACS + DICOM + radiology informatics', '[{"label":"A","text":"Paper-based sufficient"},{"label":"B","text":"DICOM (Digital Imaging and Communications in Medicine)"},{"label":"C","text":"No digital integration"},{"label":"D","text":"Discharge"},{"label":"E","text":"Single system"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Radiology informatics: (1) **DICOM (Digital Imaging and Communications in Medicine)**: international standard for medical imaging — file format + network communication; metadata embedded (patient demographics, study, series, image, equipment, technique); (2) **PACS (Picture Archiving and Communication System)**: stores, retrieves, displays, distributes images; integration with RIS (Radiology Information System — orders, schedules, reports) + EHR; vendor-neutral archives (VNA) for cross-vendor; (3) **HL7 / FHIR**: standards for healthcare data exchange — orders, reports, demographics; FHIR (Fast Healthcare Interoperability Resources) — modern API-based; (4) **Speech recognition + structured reporting**: Dragon, M*Modal; templates + macros; reduces turnaround time; (5) **AI / machine learning applications**: - **Detection**: PE, ICH, stroke (LVO), nodules, fractures, pneumothorax — FDA-cleared products integrating into PACS worklists; - **Quantification**: lesion size + volume, perfusion mapping (RAPID for stroke), calcium scoring; - **Workflow**: prioritization, decision support, dose monitoring; - **Image quality + reconstruction**: deep learning-based reconstruction (faster MRI, lower-dose CT); - **Natural language processing**: structured data extraction from reports; (6) **Cybersecurity**: HIPAA compliance, encryption, access logging, ransomware mitigation, incident response; (7) **Tele-radiology**: night/weekend coverage; subspecialty consultation; equity in underserved areas; cross-border practices; licensing + credentialing considerations; (8) **Cloud computing**: scalable storage + computing; vendor-neutral; consolidation across enterprises; (9) **Reporting analytics**: turnaround time, peer review, quality metrics, dose tracking, billing; (10) **3D + advanced visualization**: post-processing workstations + AI-augmented; surgical planning, 3D printing; (11) **Quality + safety**: closed-loop critical findings, follow-up tracking (incidental findings), error reporting; (12) **Multidisciplinary**: radiology + IT + medical physics + quality + administration + clinical informatics + vendors + cybersecurity

---

Radiology informatics: DICOM + PACS + RIS + HL7/FHIR. Structured reporting + AI (detection, prioritization, quantification). Cybersecurity. Tele-radiology. Cloud. 3D visualization. Quality + safety closed-loop. Multidisciplinary.', NULL,
  'easy', 'procedures', 'review',
  'radiology', 'basic_science', 'procedures', 'adult',
  'ACR Informatics Standards; HIMSS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'PACS + DICOM + radiology informatics'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Body MRI sequences + applications', '[{"label":"A","text":"Single sequence only"},{"label":"B","text":"Body MRI sequences"},{"label":"C","text":"No specialized sequences"},{"label":"D","text":"Discharge"},{"label":"E","text":"X-ray equivalent"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Body MRI sequences: (1) **T1-weighted**: anatomy, fat bright, water/CSF dark; in-phase and out-of-phase (chemical shift) — adrenal adenoma signal drop on OP suggests fat-containing; (2) **T2-weighted (with + without fat saturation)**: fluid bright, pathology generally bright (edema, cysts, fluid collections); fat-saturated T2 — pathology stands out; (3) **STIR (short tau inversion recovery)**: fat suppressed, sensitive for edema (bone marrow, soft tissue), inflammation; (4) **DWI (diffusion-weighted imaging)** + ADC map: restricted diffusion in hypercellular tumors (lymphoma, prostate cancer, hepatocellular cancer, peritoneal carcinomatosis), abscess (pus), recent stroke; high b-values better for tumor; (5) **Post-contrast T1 (with fat saturation)**: dynamic multiphase — arterial, portal venous, equilibrium, delayed; tissue characterization (HCC arterial + washout, hemangioma peripheral nodular discontinuous fill-in, FNH centripetal); (6) **Specialized sequences**: - **MRCP (cholangiopancreatography)** — heavily T2-weighted thick-slab: biliary + pancreatic ducts non-invasively; - **MR enterography (MRE)** — small bowel: oral contrast (sorbitol-polyethylene glycol) distends bowel; for Crohn disease assessment; - **MR urography** — heavily T2 + post-contrast excretory phase: collecting system; - **MR angiography (MRA)** — TOF, phase-contrast, contrast-enhanced; - **Cardiac MRI** sequences (above question 75 — cine, LGE, T1/T2/T2* mapping, perfusion); - **MR elastography** — liver stiffness for fibrosis assessment (replacing many biopsies for chronic liver disease staging); - **Breast MRI** — DCE + DWI; - **Prostate mpMRI** (above) — T2 + DWI + DCE; - **Fetal MRI** — anatomy + brain in selected pregnancies; (7) **Hepatocyte-specific contrast (gadoxetate disodium — Eovist/Primovist)**: hepatocyte uptake at 20 min (hepatobiliary phase) — FNH retains, adenoma less, HCC washout, metastases hypo; biliary excretion — biliary tree imaging; (8) **Field strength**: 1.5 T standard, 3 T higher resolution + SNR but more artifacts; 7 T research; (9) **Body MRI vs CT**: MRI better tissue characterization + no radiation; CT faster + better calcification + less motion sensitive; (10) **Multidisciplinary** — radiology subspecialties; coordination with referring providers + technologists

---

Body MRI: T1 (in/out phase), T2 ± fat sat, STIR, DWI + ADC, post-contrast dynamic multiphase. Specialized — MRCP, MRE, MR urography, MRA, cardiac MRI, MR elastography, breast/prostate mpMRI. Hepatocyte-specific contrast (Eovist). Field strength 1.5-3T. Multidisciplinary.', NULL,
  'medium', 'procedures', 'review',
  'radiology', 'basic_science', 'procedures', 'adult',
  'ACR MRI Standards; Body MRI Atlas', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Body MRI sequences + applications'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Incidental findings management — Choosing Wisely + tracking systems', '[{"label":"A","text":"Discharge no follow-up"},{"label":"B","text":"Incidental findings — Choosing Wisely + closed-loop"},{"label":"C","text":"Always extensive workup"},{"label":"D","text":"Single specialty"},{"label":"E","text":"X-ray sufficient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Incidental findings — Choosing Wisely + closed-loop: (1) **Common incidental findings**: pulmonary nodules (Fleischner), renal cysts (Bosniak), adrenal incidentaloma, thyroid nodules (TI-RADS), liver lesions, ovarian/adnexal masses (O-RADS), pancreatic cysts (American College Gastro IPMN guidelines), aortic aneurysm, vertebral compression fractures, focal liver lesions, splenic lesions; (2) **Choosing Wisely principles** (ACR, ABR-IM, etc.): - Don''t recommend follow-up imaging without clear value; - Use evidence-based guidelines (Fleischner, Bosniak, ACR White Papers, society-specific RADS); - Avoid ''incidentaloma cascade'' (chain of follow-ups leading to harm); - Risk-benefit + patient-centered; (3) **ACR White Papers on Incidental Findings** — algorithmic management for many entities; (4) **Reporting standardization**: use society RADS systems, recommend specific follow-up + interval + modality, NOT vague language; (5) **Closed-loop / tracking systems** — critical for patient safety: - **EMR integration** — alerts, dashboards, work queues; - **Designated personnel** (radiology nurses, clinical pharmacists, midlevel providers) for follow-up; - **Patient communication** — direct via portals, mail; - **Audit + feedback**: measure adherence to recommended follow-up; (6) **Pitfalls when follow-up fails**: missed cancer (lung nodules), delayed treatment, increased morbidity, malpractice (failure to communicate is leading cause); (7) **Patient-centered**: clear communication, shared decision-making, written information; values + preferences (some patients prefer not to know); (8) **Documentation**: communication of findings + recommendations + acknowledgment in chart; (9) **Health system investment**: dedicated programs (e.g., ''safety net'' for incidental findings); quality reporting metrics; (10) **AI + informatics**: NLP extraction of incidental findings from reports; automated tracking systems; (11) **Multidisciplinary**: radiology + primary care + specialists + IT + quality + nursing + administration + patient + family

---

Incidental findings: Choosing Wisely + ACR White Papers + society RADS for evidence-based follow-up. Avoid ''incidentaloma cascade.'' Closed-loop tracking systems essential — EMR alerts, designated personnel, audit. Multidisciplinary patient-centered.', NULL,
  'medium', 'procedures', 'review',
  'radiology', 'ems_mgmt', 'procedures', 'adult',
  'ACR Incidental Findings White Papers; Choosing Wisely', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Incidental findings management — Choosing Wisely + tracking systems'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Radiology reading room ergonomics + workflow + burnout prevention', '[{"label":"A","text":"Workflow unimportant"},{"label":"B","text":"Reading room ergonomics + burnout"},{"label":"C","text":"Burnout not radiology issue"},{"label":"D","text":"Discharge"},{"label":"E","text":"Single specialty"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Reading room ergonomics + burnout: (1) **Ergonomics** — radiologists prone to repetitive strain (mouse + dictation + sitting), neck/back pain, eye strain: - **Workstation setup**: adjustable height desk (sit-stand), proper chair (lumbar support, adjustable), monitor at eye level + arm''s length, ambient lighting low + indirect (reduce glare), dimmer controls; - **Dual monitors** for high resolution + comparison; calibrated to DICOM grayscale standard display function (GSDF); - **Input devices**: ergonomic mouse, dictation foot pedal, voice recognition reduces typing; periodic rest; - **Breaks**: 20-20-20 rule (every 20 min, look 20 ft away for 20 seconds) — eye strain; standing breaks; (2) **Reading room environment**: quiet, controlled temperature, good ventilation, minimize interruptions (phone, walk-ins) — supports cognitive focus + accuracy; (3) **Workflow design**: - **Worklist prioritization** — urgent/stat first; AI-prioritized (LVO, PE, PTX detection); subspecialty assignments; - **Avoidable interruptions** reduced — protocol questions to mid-level/RN, scheduled callbacks; - **Reasonable volumes** — high volume linked to errors + burnout; - **Adequate breaks** + nutrition; - **Subspecialty support** — multidisciplinary conferences, peer consultations; (4) **Burnout prevalence in radiology**: high — emotional exhaustion + depersonalization + reduced personal accomplishment; affects quality + safety; (5) **Burnout mitigation strategies**: - **System-level**: workload management, scheduling fairness, reduced administrative burden, EMR efficiency; - **Cultural**: open communication, peer support, blame-free environment; - **Individual**: wellness programs, exercise, mindfulness, sleep, work-life integration, vacation usage; - **Leadership**: walk-arounds, listening, equity, recognition; (6) **Tele-radiology specific**: home reading flexibility but isolation concerns; (7) **Mental health**: access to mental health services (no penalty); peer support; (8) **Professional development + meaning**: subspecialty growth, research, teaching, leadership; (9) **Compensation + recognition**: fair, transparent; (10) **Multidisciplinary + organizational**: radiology + administration + IT + HR + wellness committees + physician health programs; (11) **Modern**: AI-augmented worklists reduce repetitive aspects; emphasis on physician wellness as patient safety issue

---

Reading room: ergonomic workstation + calibrated monitors + breaks + quiet environment. AI-prioritized worklists + subspecialty + reasonable volumes. Burnout common — system + cultural + individual strategies. AI augmentation. Multidisciplinary wellness.', NULL,
  'easy', 'procedures', 'review',
  'radiology', 'ems_mgmt', 'procedures', 'adult',
  'ACR Wellness; AMGA Physician Burnout', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Radiology reading room ergonomics + workflow + burnout prevention'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'HCC multidisciplinary care — liver transplant + IR + surgery + oncology', '[{"label":"A","text":"Single specialty"},{"label":"B","text":"HCC integrative multidisciplinary care"},{"label":"C","text":"Surgery only option"},{"label":"D","text":"Discharge"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** HCC integrative multidisciplinary care: (1) **Multidisciplinary HCC tumor board**: hepatology + transplant surgery + hepatobiliary surgery + IR + medical oncology + radiation oncology + radiology + pathology + nursing + nutrition + palliative care + social work + transplant coordinator; (2) **BCLC stage-based treatment** (above LI-RADS question expanded): - **Stage 0 (very early)**: single ≤ 2 cm — resection or ablation; - **Stage A (early)**: single or ≤ 3 tumors all ≤ 3 cm — curative options (resection, transplant, ablation); - **Stage B (intermediate)**: multifocal not meeting transplant criteria — TACE; - **Stage C (advanced)**: vascular invasion or extrahepatic — systemic; - **Stage D (terminal)**: ECOG 3-4, decompensated — best supportive care; (3) **Liver transplant** — only definitive cure for HCC + cirrhosis: - **Milan criteria** (single < 5 cm or up to 3 ≤ 3 cm, no vascular invasion or extrahepatic): standard; 5-yr OS > 70%; - **Extended criteria**: UCSF, up-to-7 (Italian), downstaging protocols; - **Living donor** option in selected; - **Wait time issue** — MELD-based with HCC exception points (T2 lesions); progression on waitlist = drop-out; bridging therapies (TACE, ablation, SBRT) to prevent progression; (4) **Locoregional therapies**: - **TACE (transarterial chemoembolization)** — drug-eluting beads or Lipiodol-based — intermediate stage + bridging; - **TARE (Y-90 transarterial radioembolization)** — intermediate + advanced; less post-embolic syndrome; long-term outcomes comparable; - **Ablation** (RFA, MWA — preferred over RFA for ≥ 3 cm and adjacent to vessels — heat sink); cryoablation; for ≤ 3 cm; - **SBRT** — selected; (5) **Systemic therapy** advances: - **First-line**: atezolizumab + bevacizumab (IMbrave150 — superior to sorafenib); tremelimumab + durvalumab (HIMALAYA — STRIDE regimen); lenvatinib (REFLECT — non-inferior to sorafenib); sorafenib historical; - **Second-line + later**: regorafenib (RESORCE), cabozantinib (CELESTIAL), ramucirumab (REACH-2 — AFP > 400), nivolumab + ipilimumab (CheckMate 040, FDA accelerated approval); (6) **Comorbidity management**: underlying chronic liver disease (HCV → DAAs cure rate > 95% — game changer; HBV → tenofovir/entecavir; alcohol → cessation + counseling; MASLD/MASH → weight loss + GLP-1, semaglutide; iron overload → phlebotomy); variceal screening + surveillance; (7) **Surveillance** post-treatment: imaging q3 months × 2 years, then q6 months; AFP; (8) **Palliative care + advance care planning**: concurrent throughout journey; (9) **Family support + education**: hepatitis testing + vaccination; (10) **Multidisciplinary at every step** drives outcomes

---

HCC multidisciplinary: BCLC staging. Liver transplant (Milan + extended) only cure for cirrhosis + HCC. Bridging + downstaging. TACE/TARE/ablation/SBRT for locoregional. Atezo+bev first-line systemic. HCV DAAs + HBV antivirals + MASLD management. Multidisciplinary throughout.', NULL,
  'hard', 'gi', 'review',
  'radiology', 'integrative', 'gi', 'adult',
  'AASLD HCC 2023; BCLC; ASCO Hepatobiliary', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'HCC multidisciplinary care — liver transplant + IR + surgery + oncology'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'IBD chronic care — imaging integration + multidisciplinary team', '[{"label":"A","text":"Single specialty"},{"label":"B","text":"IBD chronic care + imaging integration"},{"label":"C","text":"No multidisciplinary"},{"label":"D","text":"Discharge"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** IBD chronic care + imaging integration: (1) **Multidisciplinary IBD team**: gastroenterology (IBD specialist) + colorectal surgery + radiology (cross-sectional imaging expert) + IR + nutrition + pharmacy + nursing + mental health + rheumatology (EIMs) + dermatology + ophthalmology + obstetrics if pregnant + pediatrics if children + social work + financial counseling + transition care to adult; (2) **Imaging in IBD chronic management**: - **MRE / CTE** — assess disease activity + complications q1-3 years or with symptom change; - **MRE preferred** in young + chronic management (no radiation); - **US** emerging — point-of-care + intestinal US increasingly used for monitoring (no radiation, repeatable, less expensive); - **MRI pelvis** — perianal disease evaluation + monitoring; - **Colonoscopy + biopsy** — gold standard mucosal + histologic activity + dysplasia surveillance (q1-3 years after 8 yrs pancolitis); - **Capsule endoscopy** — small bowel disease undetected by other modalities (caution stricture — patency capsule first if stricture concern); (3) **Treat-to-target paradigm**: clinical remission + endoscopic + radiographic + biomarker (CRP, fecal calprotectin) targets; STRIDE-II consensus; mucosal healing predicts long-term outcomes; (4) **Medication strategy by phenotype + risk + severity + comorbidities**: - 5-ASA — UC primarily; - Steroids — acute flares (budesonide for terminal ileum); - Immunomodulators (thiopurines, MTX); - **Biologics**: anti-TNF (infliximab, adalimumab, certolizumab), anti-integrin (vedolizumab — gut-specific), anti-IL-12/23 (ustekinumab), anti-IL-23 (risankizumab, mirikizumab, guselkumab), JAK inhibitors (tofacitinib, upadacitinib — UC + Crohn); - **Therapeutic drug monitoring** (TDM) — anti-TNF levels + anti-drug antibodies; - **Combination therapy** — Crohn primary; UC selective; (5) **Surgical considerations**: - Crohn — strictures (resection vs stricturoplasty), fistulae (multidisciplinary with IR + colorectal), abscess (drain by IR + biologic), cancer/dysplasia, refractory; - UC — colectomy (curative for colonic disease) — IPAA (J-pouch) vs end ileostomy; pouchitis (subsequent); (6) **EIMs (extraintestinal manifestations)**: arthritis (peripheral + axial), eye (uveitis, episcleritis), skin (erythema nodosum, pyoderma gangrenosum), liver (PSC — ↑ cholangio + colon cancer risk — annual MRCP + colonoscopy), VTE (3× risk), osteoporosis; (7) **Lifestyle + nutrition**: identify food triggers, dietary therapy (exclusive enteral nutrition in pediatric Crohn first-line per ECCO/ESPGHAN), vitamin D, B12 (terminal ileum disease), iron, calcium; smoking cessation (worsens Crohn — opposite effect on UC paradoxically); (8) **Mental health**: depression + anxiety common — screen + treat; chronic illness counseling; (9) **Pregnancy**: most biologics safe (anti-TNF, anti-integrin, IL-12/23); thiopurines + biologics generally continued; (10) **Cancer surveillance**: colonoscopy as above; cervical cancer (immunosuppression — Pap + HPV per guidelines); skin cancer; (11) **Vaccines**: live vaccines (varicella, MMR, yellow fever) BEFORE biologics; inactivated routine (flu, COVID, pneumonia, HPV, hepatitis, shingrix); (12) **Patient education + self-management** + support groups

---

IBD chronic: MRE + intestinal US + colonoscopy + biomarkers (calprotectin) for treat-to-target. Biologics + immunomodulators + JAK inhibitors + TDM. Surgery for selected. EIMs management. Lifestyle + nutrition + smoking. Mental health. Vaccines + cancer surveillance. Multidisciplinary IBD team.', NULL,
  'hard', 'gi', 'review',
  'radiology', 'integrative', 'gi', 'adult',
  'ACG IBD; ECCO; STRIDE-II Consensus', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'IBD chronic care — imaging integration + multidisciplinary team'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 80 ปี F + low-energy fall + hip pain + unable to bear weight — X-ray hip + pelvis normal — clinical concern persists', '[{"label":"A","text":"Discharge with negative X-ray"},{"label":"B","text":"Occult hip fracture in elderly — MRI for negative X-ray with high clinical suspicion"},{"label":"C","text":"Always X-ray sufficient"},{"label":"D","text":"Wait 1 week then re-X-ray"},{"label":"E","text":"Single specialty"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Occult hip fracture in elderly — MRI for negative X-ray with high clinical suspicion: (1) **X-ray (AP pelvis + lateral hip)** — initial — 90-95% sensitivity for hip fractures; misses ~ 5-10% (non-displaced, intertrochanteric subtle, sacral insufficiency, pubic ramus); (2) **MRI hip — gold standard for occult fracture**: T1 hypointense fracture line + STIR hyperintense surrounding marrow edema (within hours of injury); detects fractures missed on X-ray + CT; alternative when X-ray negative but inability to bear weight or persistent severe pain; sensitivity ~ 100%; (3) **CT** alternative if MRI contraindicated or not available — faster but less sensitive for marrow edema; useful for surgical planning (intertrochanteric, subtrochanteric pattern); (4) **Bone scan** — historical, takes 24-72 hours in elderly for uptake; less used; (5) **Hip fracture types + management**: - **Femoral neck (intracapsular)**: high non-union + AVN risk due to retrograde vascular supply from MFCA — younger displaced → ORIF (cannulated screws), elderly displaced → hemi or total hip arthroplasty (THA) preferred for active; non-displaced → cannulated screws; - **Intertrochanteric (extracapsular)**: ORIF with sliding hip screw (DHS) or cephalomedullary nail (CMN — more popular now, especially for unstable patterns); - **Subtrochanteric**: cephalomedullary nail; - **Pubic ramus + sacral insufficiency**: typically conservative — analgesia + early mobilization (rare surgical); (6) **Time to surgery — within 24-48 hours** (best outcomes — reduces mortality, complications, LOS — multiple guidelines + meta-analyses); orthogeriatric co-management improves outcomes; (7) **Pre-op evaluation**: medical clearance, comorbidities optimization, anticoagulant management, anesthesia planning; (8) **Post-op DVT prophylaxis**: LMWH × 10-35 days; multimodal pain; physical therapy day 1; (9) **Osteoporosis evaluation**: DXA, vitamin D + calcium, fall prevention, FRAX, anti-resorptive therapy (bisphosphonates) — fragility fracture = osteoporosis treatment indication even without DXA; (10) **Multidisciplinary**: orthopedics + geriatrics + anesthesia + hospitalist + PT/OT + nutrition + social work + family

---

Occult hip fracture: X-ray misses 5-10%. MRI gold standard (T1 + STIR — marrow edema). Surgery within 24-48h. Hip fracture types — neck (arthroplasty for elderly displaced), intertroch (CMN). Orthogeriatric co-management + osteoporosis evaluation + DVT prophylaxis. Multidisciplinary.', NULL,
  'easy', 'trauma', 'review',
  'radiology', 'clinical_decision', 'trauma', 'adult',
  'ACR Appropriateness; NICE Hip Fracture', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 80 ปี F + low-energy fall + hip pain + unable to bear weight — X-ray hip + pelvis normal — clinical concern persists'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 25 ปี FOOSH injury + anatomic snuffbox tenderness — scaphoid fracture suspected — X-ray พบ normal', '[{"label":"A","text":"Discharge no immobilization"},{"label":"B","text":"Suspected scaphoid fracture"},{"label":"C","text":"Always X-ray sufficient"},{"label":"D","text":"Surgery without imaging"},{"label":"E","text":"Single specialty"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Suspected scaphoid fracture: (1) **Clinical exam**: anatomic snuffbox tenderness + scaphoid tubercle tenderness + scaphoid compression test — high sensitivity but low specificity; (2) **X-ray scaphoid views** (PA + lateral + scaphoid views: PA with ulnar deviation + clenched fist) — initial; sensitivity only ~ 70-80% for acute scaphoid fracture (often occult initially); (3) **If negative X-ray + clinical suspicion**: - **Immobilize in thumb spica splint/cast** + repeat X-ray in 10-14 days OR; - **Advanced imaging**: - **MRI** (sensitivity > 95%) — preferred when available; - **CT** — high spatial resolution for fracture detail + displacement (better than MRI for cortical details, surgical planning); - **Bone scan** — historical alternative (less common now); (4) **Scaphoid anatomy + management considerations**: - **Vascular supply** — retrograde from distal pole (dorsal carpal branch of radial artery) — proximal pole at risk of AVN with proximal/displaced fractures; - **Fracture location** affects management: - **Distal pole** (less common) — usually heals well with cast; - **Waist (mid-scaphoid) — most common** — non-displaced often cast (10-12 weeks); displaced or unstable → ORIF (screw fixation, e.g., Herbert screw); - **Proximal pole** — high risk non-union + AVN — surgical fixation often; (5) **Cast vs surgery for non-displaced waist** — current evidence shows early percutaneous screw may have faster return to function but similar long-term outcomes vs cast — patient-specific decision; (6) **Complications**: non-union (10-15%), AVN proximal pole, scaphoid non-union advanced collapse (SNAC) — late wrist arthritis; (7) **Multidisciplinary**: ED + hand surgery + radiology + physical therapy

---

Suspected scaphoid: clinical snuffbox tenderness + X-rays often miss initially. Immobilize + repeat X-ray or MRI/CT for definitive. Location matters — proximal pole high non-union/AVN risk. Surgery for displaced or proximal. Multidisciplinary hand care.', NULL,
  'medium', 'trauma', 'review',
  'radiology', 'clinical_decision', 'trauma', 'adult',
  'ACR Appropriateness; ASSH Scaphoid', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 25 ปี FOOSH injury + anatomic snuffbox tenderness — scaphoid fracture suspected — X-ray พบ normal'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 35 ปี ankle sprain + lateral pain after inversion injury — Ottawa Ankle Rules decision tool', '[{"label":"A","text":"Always X-ray everyone"},{"label":"B","text":"Ottawa Ankle Rules — clinical decision aid"},{"label":"C","text":"Discharge no rules"},{"label":"D","text":"Single specialty"},{"label":"E","text":"MRI for all sprains"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Ottawa Ankle Rules — clinical decision aid: (1) **Ottawa Ankle Rules** (Stiell — validated extensively): X-ray indicated if pain in malleolar zone AND any of: - Bone tenderness at posterior edge or tip of LATERAL malleolus (distal 6 cm); - Bone tenderness at posterior edge or tip of MEDIAL malleolus (distal 6 cm); - Inability to bear weight (4 steps) BOTH immediately AND in ED; (2) **Ottawa Foot Rules** (parallel): X-ray foot if pain in midfoot zone AND any of: - Bone tenderness at base of 5th metatarsal; - Bone tenderness at navicular; - Inability to bear weight; (3) **Sensitivity ~ 100%** for clinically significant fractures (Cochrane); reduces unnecessary radiographs ~ 30-40%; (4) **NOT applied**: < 18 years (controversial — many studies validate similarly), intoxicated, distracting injuries, neuropathy, multiple painful injuries; (5) **X-ray views (if indicated)**: ankle — AP, lateral, mortise (15° internal rotation); foot — AP, lateral, oblique; (6) **Common ankle fractures + treatment**: - **Lateral malleolus**: Weber A (below syndesmosis — stable, conservative cast/boot), Weber B (at syndesmosis — variable stability, surgical if unstable), Weber C (above syndesmosis — unstable, ORIF); - **Bimalleolar / trimalleolar**: usually unstable → ORIF; - **Maisonneuve**: proximal fibula + medial malleolar/deltoid disruption — high-energy unstable; - **Talar dome OCD** — MRI; (7) **Sprain treatment**: PRICE (protection, rest, ice, compression, elevation), functional rehab > prolonged immobilization, early weight-bearing as tolerated; (8) **Chronic instability** — physical therapy → consideration of Brostrom procedure; (9) **Multidisciplinary**: ED + orthopedics + radiology + PT

---

Ottawa Ankle Rules: clinical decision tool — X-ray if malleolar pain + bone tenderness or inability to bear weight (4 steps). Foot Rules parallel. ~ 100% sensitive; reduces 30-40% unnecessary X-rays. Fracture types by Weber + treatment. Multidisciplinary.', NULL,
  'easy', 'trauma', 'review',
  'radiology', 'clinical_decision', 'trauma', 'adult',
  'Ottawa Ankle Rules (Stiell); ACR Appropriateness', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 35 ปี ankle sprain + lateral pain after inversion injury — Ottawa Ankle Rules decision tool'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 30 ปี twisting knee injury + locking + clicking + persistent pain — MRI knee พบ meniscal tear + bone bruise + intact ligaments', '[{"label":"A","text":"X-ray sufficient"},{"label":"B","text":"Knee MRI — meniscal + ligament + cartilage"},{"label":"C","text":"Always surgery"},{"label":"D","text":"Discharge"},{"label":"E","text":"Single specialty"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Knee MRI — meniscal + ligament + cartilage: (1) **MRI knee — modality of choice** for internal derangement: T1 + PD (proton density) fat-sat + T2 fat-sat + STIR sequences; (2) **Meniscus tears**: - **Grade 1-2**: intrasubstance signal not reaching surface — pre-degenerative, NOT a tear per se; - **Grade 3 (true tear)**: signal reaching articular surface; - **Patterns**: longitudinal vertical (bucket-handle if displaced — flipped fragment in notch, double PCL sign), radial (volume loss radially), horizontal, oblique, complex; (3) **Bucket-handle tear**: ''double PCL sign,'' ''absent bow-tie sign'' (normally PD sagittal shows 2-3 bow-tie images of meniscus body, < 2 if torn), ''flipped meniscus,'' mechanical symptoms (locking, catching) — surgical urgency; (4) **Discoid meniscus** — congenital, prone to tear; (5) **Meniscal root tears** — significant — equivalent to total meniscectomy mechanically, leads to rapid OA — surgical repair often; (6) **Treatment**: - **Conservative** for stable longitudinal tears + small radial in older patients, degenerative; - **Surgical**: - Partial meniscectomy for unrepairable; - Meniscal repair (vertical tears in younger patients in vascular red zone — outer 1/3) — preserves meniscus + chondroprotection; - Root repair for root tears; - Meniscal transplant for selected post-meniscectomy young; (7) **Concurrent injuries**: - **''Terrible triad''** (O''Donoghue) — ACL + MCL + medial meniscus from valgus pivot; - **Lateral meniscus + ACL** common; - **Bone bruise** patterns help diagnose mechanism (kissing bruise lateral femoral condyle + posterior lateral tibia → ACL pivot shift); (8) **Cartilage assessment**: chondral lesions graded — partial vs full-thickness; (9) **Multidisciplinary**: orthopedics + sports medicine + physical therapy

---

Knee MRI: PD fat-sat for meniscus + ligament + cartilage. Grade 3 = true tear (surface signal). Bucket-handle locked knee — double PCL sign, surgical. Root tears = mechanical total meniscectomy — repair. Repair for vascular zone tears in young. Multidisciplinary.', NULL,
  'easy', 'msk_nontrauma', 'review',
  'radiology', 'clinical_decision', 'msk_nontrauma', 'adult',
  'ACR Appropriateness; AAOS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 30 ปี twisting knee injury + locking + clicking + persistent pain — MRI knee พบ meniscal tear + bone bruise + intact ligaments'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี shoulder pain + weakness on abduction + night pain × 6 เดือน — MRI shoulder พบ full-thickness supraspinatus tear with retraction', '[{"label":"A","text":"Discharge"},{"label":"B","text":"Rotator cuff pathology — MRI"},{"label":"C","text":"Always surgery"},{"label":"D","text":"X-ray sufficient"},{"label":"E","text":"Single specialty"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Rotator cuff pathology — MRI: (1) **Anatomy**: 4 RC muscles — supraspinatus (most commonly torn — superior, abduction initiation), infraspinatus (posterior, external rotation), teres minor (posterior, external rotation), subscapularis (anterior, internal rotation); biceps tendon long head — separate but often involved; (2) **Tear classification**: - **Partial-thickness** vs **full-thickness**; - **Articular-sided** (deep — bursal-sided more rare), bursal-sided, intratendinous; - **Crescentic, U-shaped, L-shaped** patterns; - **Size**: small (< 1 cm), medium (1-3 cm), large (3-5 cm), massive (> 5 cm or ≥ 2 tendons); - **Retraction**: Patte 1 (lateral to top of humeral head), 2 (over humeral head), 3 (medial to glenoid); - **Muscle quality**: Goutallier classification (0-4) fatty infiltration — predicts surgical outcome; (3) **Imaging modalities**: - **MRI shoulder** — primary; - **MR arthrogram** — better for partial-thickness + labrum (SLAP), Bankart, GHL — direct intra-articular contrast; - **US shoulder** — alternative for cuff (dynamic, no radiation); operator-dependent; - **X-ray** — superior migration of humeral head (cuff arthropathy late); (4) **Subacromial impingement** — Neer + Hawkins tests clinical; outlet view radiograph (acromial type — type 3 hooked predisposes); MRI shows subacromial bursitis; (5) **Treatment**: - **Conservative first** for many full-thickness in older + low-demand: PT, NSAIDs, subacromial corticosteroid injection (US-guided more accurate); - **Surgery** considered: - Younger active patients with cuff tears (better repair potential); - Acute trauma tears (especially subscapularis); - Functional impairment, pain not responding to conservative; - Progressive enlargement; - **Procedures**: arthroscopic repair (single vs double row), open repair, reverse total shoulder arthroplasty for massive cuff tears + arthropathy in elderly (preserves function despite irreparable cuff); (6) **Outcomes**: depend on tear size + retraction + muscle quality (Goutallier); irreparable massive tears — superior capsular reconstruction or graft alternatives; (7) **Multidisciplinary**: orthopedics + sports medicine + radiology + PT

---

RC tear: MRI primary (MR arthrogram for partial/labrum). Patterns + size + retraction + Goutallier fatty infiltration. Conservative first for older + low-demand. Surgery for young active + acute + impairment. Reverse TSA for cuff arthropathy. Multidisciplinary.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'radiology', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AAOS Rotator Cuff', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี shoulder pain + weakness on abduction + night pain × 6 เดือน — MRI shoulder พบ full-thickness supraspinatus tear with retraction'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 25 ปี pivot injury + immediate effusion + giving way — MRI knee พบ disrupted ACL fibers + bone bruise on lateral femoral condyle + posterior lateral tibia', '[{"label":"A","text":"Always observation"},{"label":"B","text":"ACL tear — MRI + management"},{"label":"C","text":"Discharge"},{"label":"D","text":"X-ray sufficient"},{"label":"E","text":"Single specialty"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** ACL tear — MRI + management: (1) **MRI findings**: - **Primary**: discontinuity of ACL fibers, abnormal angulation, increased signal in ACL substance; - **Secondary**: ''kissing bone bruise'' pattern (impaction lateral femoral condyle + posterior lateral tibia from pivot shift mechanism — pathognomonic), anterior translation of tibia (''PCL buckling'' — PCL more vertical/angulated), deep lateral femoral notch sign (≥ 1.5 mm); (2) **Mechanism**: non-contact pivot, deceleration, hyperextension; sports — soccer, skiing, basketball; female athletes higher rate (anatomic + neuromuscular factors); (3) **Concurrent injuries** common (~ 50%+ have additional pathology): - Meniscus (lateral > medial in acute ACL); medial in chronic; - MCL (terrible triad if also medial meniscus); - Bone bruise (above); - Cartilage; - Posterolateral corner; - SegSegond fracture (small lateral tibial avulsion — pathognomonic for ACL tear, MCL/iliotibial); (4) **Clinical exam**: Lachman test (most sensitive), pivot shift (specific, anesthesia), anterior drawer; (5) **Treatment**: - **Surgical reconstruction (ACL-R)** — most active patients + young: hamstring autograft (gracilis-semitendinosus), BPTB (bone-patellar tendon-bone) autograft (gold standard for high-demand athletes — better return-to-sport), quadriceps tendon autograft (emerging), allograft (older patients, revisions, lower demand); - **Non-operative**: older + sedentary lifestyle + minor instability; functional bracing + intensive rehab; some studies (KANON) show similar outcomes selected — but young active typically choose surgery; (6) **Timing**: - ''Pre-habilitation'' before surgery — reduce swelling, improve ROM, strengthen — better outcomes; - Acute surgery vs delayed similar outcomes; - Concurrent meniscus repair if able; (7) **Post-op rehab**: progressive — extension first, range of motion, strengthening, return to sport at 9-12+ months (objective testing — limb symmetry index, hop tests, psychological readiness); (8) **Prevention** — neuromuscular training programs (FIFA 11+, PEP) reduce ACL injury 30-50% in female athletes; (9) **Multidisciplinary**: orthopedics + sports medicine + PT + athletic training + psychology

---

ACL tear: MRI — discontinuous fibers + kissing bone bruise pivot shift pattern + Segond fracture. Concurrent injuries common. ACL-R with autograft (BPTB, hamstring, quad) preferred for young active. Pre-hab + neuromuscular rehab + RTS testing. Prevention programs. Multidisciplinary.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'radiology', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AAOS ACL; JOSPT Sports PT', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 25 ปี pivot injury + immediate effusion + giving way — MRI knee พบ disrupted ACL fibers + bone bruise on lateral femoral condyle + posterior lateral tibia'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี chronic bilateral knee pain + morning stiffness < 30 minutes + crepitus — X-ray knee bilateral พบ joint space narrowing + osteophytes + subchondral sclerosis + subchondral cysts — OA vs RA differentiation', '[{"label":"A","text":"No radiographic distinction"},{"label":"B","text":"Osteoarthritis (OA) vs Rheumatoid arthritis (RA) — radiographic differentiation"},{"label":"C","text":"Single feature only"},{"label":"D","text":"Discharge"},{"label":"E","text":"X-ray unhelpful"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Osteoarthritis (OA) vs Rheumatoid arthritis (RA) — radiographic differentiation: (1) **OA radiographic features (''LOSS'')**: - **L**oss of joint space (asymmetric, weight-bearing joints — knees medial, hip superior); - **O**steophytes (marginal); - **S**ubchondral sclerosis (increased density); - **S**ubchondral cysts (geodes); - Bony deformity (varus knee); (2) **RA radiographic features (''LESS'')**: - **L**oss of joint space (uniform, symmetric); - **E**rosions (marginal, periarticular — earliest in MTP, MCP, PIP, wrist, ulnar styloid); - **S**oft tissue swelling (periarticular, fusiform of fingers); - **S**ubluxations (ulnar deviation, swan neck, boutonniere, Z-thumb); - Periarticular osteoporosis (early); - **Distribution**: symmetric polyarthritis — MCP, PIP, wrist, MTP — proximal small joints typical (DIPs spared — unlike OA + psoriatic); (3) **Other inflammatory arthritis distinguishing features**: - **Psoriatic**: asymmetric, DIP involvement (with nail changes), pencil-in-cup deformity, periostitis, dactylitis (''sausage digit''), enthesitis; - **Ankylosing spondylitis (axSpA)**: sacroiliitis (early MRI bone marrow edema before X-ray), syndesmophytes (slender marginal — vs psoriatic non-marginal bridging), bamboo spine late; - **Gout**: punched-out periarticular erosions with overhanging edges, tophus soft tissue masses, asymmetric distribution, often 1st MTP (podagra); - **CPPD/pseudogout**: chondrocalcinosis (cartilage calcification — knee menisci, wrist TFCC, symphysis), arthritis pattern similar to OA but with calcifications; - **Erosive OA**: DIPs erosive (''gull-wing''); (4) **MRI** for: early RA (synovitis + bone marrow edema before erosions), spondyloarthropathy sacroiliitis, internal derangement; (5) **US** for: synovitis, effusions, tophi/crystals (double contour sign in gout), tendinopathy; (6) **CT** rarely needed for arthritis (cross-section for gout tophi quantification, complex anatomy); (7) **Workup labs**: RF + anti-CCP (RA), ANA + ENA (CTDs), HLA-B27 (spondylo), urate + crystal analysis (gout), inflammatory markers; (8) **Modern RA + spondylo treatment paradigm**: treat-to-target with DMARDs (methotrexate first-line RA) + biologics (anti-TNF, abatacept, rituximab, tocilizumab, JAK inhibitors); achieve remission early to prevent erosions + disability; (9) **Multidisciplinary**: rheumatology + radiology + PT/OT + orthopedics if joint replacement

---

OA: LOSS — asymmetric joint space loss + osteophytes + subchondral sclerosis + cysts. RA: LESS — uniform JSL + erosions + soft tissue swelling + subluxations + periarticular osteopenia; symmetric MCP/PIP/wrist + spares DIP. Spondylo, gout, CPPD distinct. MRI for early. Multidisciplinary.', NULL,
  'easy', 'msk_nontrauma', 'review',
  'radiology', 'clinical_decision', 'msk_nontrauma', 'adult',
  'ACR Imaging Arthritis', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี chronic bilateral knee pain + morning stiffness < 30 minutes + crepitus — X-ray knee bilateral พบ joint space narrowing + osteophytes + subchondral sclerosis + subchondral cysts — OA vs RA differentiation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 50 ปี acute knee monoarthritis + fever + leukocytosis — septic arthritis suspected', '[{"label":"A","text":"Discharge"},{"label":"B","text":"Septic arthritis — emergent"},{"label":"C","text":"Wait for imaging before tap"},{"label":"D","text":"X-ray sufficient"},{"label":"E","text":"Single specialty"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Septic arthritis — emergent: (1) **Diagnosis is CLINICAL + arthrocentesis** — DO NOT delay tap for imaging: - Arthrocentesis (joint aspiration) — synovial fluid WBC > 50,000/mm³ (with PMN predominance > 75%) highly suggestive (lower threshold for prosthetic), Gram stain + culture (positive in ~ 70%), crystal analysis (rule out crystal-induced — but co-existence possible!); - Blood cultures × 2; - Lab: WBC + inflammatory markers (CRP, ESR — sensitive but non-specific); (2) **Imaging role**: - **Plain X-ray** — initial: rule out fracture, osteomyelitis, foreign body, crystal disease (chondrocalcinosis); early septic arthritis X-ray often normal — soft tissue swelling only; late — joint space narrowing, erosions, periarticular osteopenia, joint destruction; - **US** — joint effusion + guidance for tap (especially hip — deep, hard to tap blind); - **MRI** — sensitive for early findings (joint effusion, synovial enhancement + thickening, periarticular soft tissue inflammation, bone marrow edema — concurrent osteomyelitis); useful when diagnosis unclear or to assess associated osteomyelitis + abscesses; - **CT** — for surgical planning or selected scenarios; - **Tagged WBC scan / FDG-PET** — selective for chronic / prosthetic; (3) **Common pathogens**: S. aureus (most common, including MRSA in IVDU + healthcare exposure), Streptococci, gonococcus (young sexually active — disseminated GC), gram-negatives (immunocompromised, IVDU), TB (chronic, history), Lyme (knee, exposure), polymicrobial after surgery; (4) **Treatment**: - **Emergent joint drainage** — arthroscopic or open or repeated needle aspiration (less invasive but may not be adequate for purulent); hip — surgical urgent (vascular supply); prosthetic joint — orthopedic involvement (debride vs explant); - **Empiric IV antibiotics** AFTER joint aspiration culture: cover staph + strep (vancomycin + ceftriaxone) until culture results; gonococcus suspected — ceftriaxone; immunocompromised — broader; - **De-escalate** to culture-directed; - **Duration**: 2-4 weeks IV typically; longer for complicated or prosthetic; (5) **Prosthetic joint infection** — different — DAIR (debridement, antibiotics, implant retention) for acute, 1- or 2-stage exchange for chronic; multidisciplinary infectious disease + orthopedics; (6) **Outcomes**: morbidity high — chronic joint damage, OA, prosthesis loss, sepsis, death; early diagnosis + drainage + antibiotics improve outcomes; (7) **Multidisciplinary**: ED + orthopedics + infectious disease + radiology + microbiology + IR (for image-guided drainage)

---

Septic arthritis = clinical Dx + emergent arthrocentesis (synovial WBC > 50k, Gram stain + culture). Imaging adjunct — US/MRI for diagnosis + complications. Empiric vancomycin + ceftriaxone after tap. Drainage + 2-4 wk IV antibiotics. Prosthetic infection — DAIR vs exchange. Multidisciplinary.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'radiology', 'clinical_decision', 'msk_nontrauma', 'adult',
  'IDSA Bone + Joint Infection', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 50 ปี acute knee monoarthritis + fever + leukocytosis — septic arthritis suspected'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี diabetes + foot ulcer + exposed bone + deep infection — osteomyelitis suspected', '[{"label":"A","text":"X-ray sufficient"},{"label":"B","text":"Osteomyelitis — imaging + management"},{"label":"C","text":"Discharge"},{"label":"D","text":"Single specialty"},{"label":"E","text":"Always amputate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Osteomyelitis — imaging + management: (1) **Imaging modalities**: - **X-ray** — initial: bone changes late (10-21 days — soft tissue swelling first, then lytic, periosteal reaction, sequestrum, involucrum); insensitive for early OM; - **MRI — preferred modality**: T1 marrow edema (replaces normal high-signal fat with low signal), STIR/T2 fat-sat hyperintensity, post-contrast enhancement; sensitivity > 95%, specificity ~ 90%; differentiates cellulitis vs osteomyelitis vs abscess; - **CT** — sequestrum + cortical erosion + reactive bone; less sensitive than MRI for marrow but better cortical detail; - **Nuclear**: bone scan (Tc-99m MDP — 3-phase — hot all 3 phases for osteo); WBC-labeled scan (more specific in setting of orthopedic hardware or recent surgery — bone scan false positive); FDG-PET (sensitive + specific); - **Probe to bone test** — clinical (high PPV in diabetic foot — palpable bone on probe = osteomyelitis until proven otherwise); (2) **Diabetic foot osteomyelitis special considerations**: - High morbidity + risk of amputation; - Multidisciplinary diabetic foot team (vascular, podiatry, ID, plastics); - Vascular assessment (PAD common — affects healing); - Wound care; - Glycemic control; (3) **Classification**: - **Acute hematogenous** (children — metaphysis); - **Contiguous spread** (diabetic foot, decubitus, trauma); - **Vertebral osteomyelitis (discitis-osteomyelitis)** — adults — hematogenous; MRI for diagnosis (above + below disc — endplate edema/enhancement, epidural abscess possible); blood cultures + image-guided biopsy for organism; (4) **Pathogens**: S. aureus (most common in most contexts), strep, gram-negatives (diabetic foot, IVDU), anaerobes (diabetic foot, decubitus), TB (vertebral — Pott''s disease, chronic, granulomas), fungal (immunocompromised, endemic); (5) **Treatment**: - **Image-guided biopsy + culture before antibiotics** if possible (improves organism identification); - **Empiric antibiotics** initially based on context (e.g., diabetic foot — vancomycin + piperacillin-tazobactam); then culture-directed; - **Duration**: usually 4-6 weeks IV for acute; longer for vertebral (6-12 weeks); OVIVA trial — selected can transition to oral after 1-2 weeks; - **Surgical debridement** for sequestrum + necrotic tissue + abscess drainage; - **Hardware** infections — usually requires removal (vs DAIR for selected); - **Hyperbaric oxygen** — selected refractory + radionecrosis; (6) **Multidisciplinary**: ID + orthopedics + plastic surgery + vascular + radiology + IR + endocrinology + wound care + podiatry

---

Osteomyelitis: MRI preferred — marrow edema + enhancement. X-ray late changes. WBC scan/FDG-PET selected (post-op, hardware). Probe to bone in diabetic foot. Biopsy + culture before antibiotics. 4-6+ wks IV (OVIVA early oral OK selected). Surgical debridement. Multidisciplinary.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'radiology', 'clinical_decision', 'msk_nontrauma', 'adult',
  'IDSA Diabetic Foot + OM Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี diabetes + foot ulcer + exposed bone + deep infection — osteomyelitis suspected'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 16 ปี persistent femoral pain + palpable mass + X-ray พบ aggressive lytic + sclerotic lesion in distal femur with periosteal reaction (sunburst + Codman triangle)', '[{"label":"A","text":"Discharge"},{"label":"B","text":"Osteosarcoma — imaging + management"},{"label":"C","text":"Single specialty"},{"label":"D","text":"X-ray sufficient"},{"label":"E","text":"Always amputation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Osteosarcoma — imaging + management: (1) **Imaging features**: - **X-ray**: aggressive lytic + sclerotic mixed lesion in metaphysis of long bone (distal femur most common, proximal tibia, proximal humerus); aggressive periosteal reaction — sunburst pattern (perpendicular spicules), Codman triangle (periosteum elevated at edges), lamellated; soft tissue mass extension; - **MRI** — local staging: intramedullary extent, soft tissue extension, neurovascular bundle, joint involvement, skip lesions (separate lesion within same bone, prognostically important); - **CT chest** — pulmonary metastases (lung most common site); - **Bone scan / FDG-PET** — systemic skeletal staging + response monitoring; - **Image-guided biopsy** — by orthopedic oncology with care for biopsy tract (will be excised with tumor — avoid contamination); (2) **Differential of aggressive bone lesions**: - Osteosarcoma (10-25 years, metaphyseal, lytic + sclerotic, bone production); - **Ewing sarcoma** (5-25 years, diaphyseal, lamellated periosteal reaction onion skin, may be permeative — small round blue cell tumor); - **Chondrosarcoma** (older, cartilaginous matrix calcifications); - **Osteomyelitis** (sequestrum, may mimic); - **Eosinophilic granuloma / Langerhans cell histiocytosis** (children, lytic, vertebra plana); - **Metastasis** (older); - **Multiple myeloma** (older, multiple lytic); - **Aneurysmal bone cyst** (lytic, fluid-fluid levels on MRI); (3) **Subtypes**: conventional (most common), telangiectatic, parosteal (surface, lower-grade), periosteal, secondary (Paget, post-radiation); (4) **Staging**: Enneking + TNM 8th ed; (5) **Treatment**: - **Multimodal therapy — multidisciplinary musculoskeletal oncology team essential**; - **Neoadjuvant chemotherapy** (MAP — methotrexate + doxorubicin + cisplatin) ~ 10 weeks → restage with imaging → **limb salvage surgery** preferred over amputation (when feasible — wide local excision with reconstruction — endoprosthesis, allograft, vascularized fibula) → **adjuvant chemotherapy** continuation; - Response to neoadjuvant on histology (Huvos grading — ≥ 90% necrosis good prognosis) — modifies adjuvant; - RT — limited role (osteosarcoma relatively radioresistant); selected unresectable or palliation; (6) **Ewing sarcoma treatment**: VDC/IE chemotherapy + surgery + RT (more radiosensitive); (7) **Survival**: localized osteosarcoma 5-yr ~ 60-70%; metastatic at presentation ~ 20-30%; (8) **Multidisciplinary musculoskeletal oncology team**: orthopedic oncology + medical oncology + radiation oncology + radiology + pathology + nursing + PT/OT + psychology + social work + financial — increasingly centralized in specialty centers per evidence

---

Osteosarcoma: aggressive metaphyseal lesion + sunburst periosteal + Codman triangle. MRI local staging + CT chest. Image-guided biopsy by orthopedic oncology (careful biopsy tract). Multimodal — neoadj chemo + limb salvage + adj chemo (MAP). Centralized care. Multidisciplinary MSK oncology team.', NULL,
  'hard', 'hemato_onco', 'review',
  'radiology', 'clinical_decision', 'hemato_onco', 'adult',
  'NCCN Bone Cancer; MSTS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 16 ปี persistent femoral pain + palpable mass + X-ray พบ aggressive lytic + sclerotic lesion in distal femur with periosteal reaction (sunburst + Codman triangle)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี anemia + bone pain + hypercalcemia + renal failure — multiple myeloma suspected — imaging modality', '[{"label":"A","text":"Skeletal survey only"},{"label":"B","text":"Multiple myeloma imaging"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Discharge"},{"label":"E","text":"X-ray sufficient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Multiple myeloma imaging: (1) **IMWG (International Myeloma Working Group) 2014 + 2018 update — modern imaging in MM**: - **Whole-body low-dose CT (WBLDCT)** — recommended as first-line for screening lytic lesions; replaces traditional skeletal survey (skeletal survey insensitive — needs 30%+ bone destruction); - **Whole-body MRI** — most sensitive for marrow involvement + focal lesions + diffuse infiltration; recommended for: smoldering MM (≥ 1 focal lesion on MRI = upgrades to active MM per 2014 criteria), suspected spinal cord compression, when CT equivocal; - **FDG-PET/CT** — sensitive for focal lesions + extramedullary disease + monitoring response (functional info — viable disease); (2) **Imaging is part of CRAB criteria** (now MyDEFINING criteria for active MM): - **C**alcium > 11 mg/dL; - **R**enal — creatinine > 2 mg/dL or eGFR < 40; - **A**nemia — Hgb < 10 or 2 below LLN; - **B**one — lytic lesions on imaging (CT, MRI, PET) ≥ 1; - PLUS Biomarkers (free light chain ratio, BM plasma cells ≥ 60%, MRI focal lesions ≥ 1); (3) **Differential lytic bone lesions**: MM, metastasis (lung, breast, kidney, thyroid), Langerhans cell histiocytosis, brown tumors (hyperparathyroidism), osteoporosis collapse + benign lesions (less aggressive); (4) **Treatment**: - **Risk stratification**: ISS + R-ISS based on β2-microglobulin + albumin + cytogenetics + LDH; - **Induction**: triplet/quadruplet (D-VRd — daratumumab + bortezomib + lenalidomide + dexamethasone — recent gold standard induction); - **Autologous SCT** (consolidation) for transplant-eligible (typically < 70-75 + fit); - **Maintenance**: lenalidomide; - **Relapsed/refractory**: many lines — CD38 (daratumumab + isatuximab), proteasome inhibitors, IMiDs, anti-BCMA (CAR-T — ide-cel, cilta-cel; bispecifics — teclistamab, talquetamab, elranatamab); - **Bisphosphonates / denosumab** monthly — reduce skeletal events; (5) **Local therapies** for symptomatic lesions: RT (palliative pain, cord compression, plasmacytoma), kyphoplasty/vertebroplasty (compression fractures); (6) **Multidisciplinary**: hematology + radiation oncology + IR (vertebroplasty) + orthopedics + nephrology + radiology + nuclear medicine + nursing + palliative care

---

MM imaging: WBLDCT replaces skeletal survey. Whole-body MRI most sensitive for marrow + focal lesions. FDG-PET for response. Imaging part of CRAB criteria. Modern induction D-VRd + ASCT + maintenance. CAR-T + bispecifics for R/R. Bisphosphonates. Multidisciplinary.', NULL,
  'hard', 'hemato_onco', 'review',
  'radiology', 'clinical_decision', 'hemato_onco', 'adult',
  'IMWG 2018; NCCN Multiple Myeloma', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี anemia + bone pain + hypercalcemia + renal failure — multiple myeloma suspected — imaging modality'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 50 ปี average risk — annual mammography screening — USPSTF + ACS recommendations', '[{"label":"A","text":"No screening"},{"label":"B","text":"Mammography screening — USPSTF 2024 + ACS + ACR"},{"label":"C","text":"Single recommendation"},{"label":"D","text":"Single specialty"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mammography screening — USPSTF 2024 + ACS + ACR: (1) **USPSTF 2024 update** (Grade B): screening mammography q2 years for women aged **40-74** (lowered from 50 in 2024 update — based on increasing breast cancer rates in young women + benefits exceeding harms for 40s); insufficient evidence > 75; recommends discussing supplemental screening for dense breasts (50-75% reduced sensitivity of mammography); (2) **ACS recommendations**: annual mammography 45-54, then biennial (or continued annual if preferred) 55+; option of annual starting at 40 based on shared decision-making; continue while in good health + life expectancy ≥ 10 years; (3) **ACR + SBI**: annual mammography starting at 40 (some now recommend annual 40+ based on randomized + observational data showing greatest benefit); supplemental screening for dense breasts; (4) **Dense breasts**: - 50% of women — variable by classification (a-d on BI-RADS); - Reduced sensitivity of mammography; - FDA — facilities required to inform patients of breast density (effective 2024); - **Supplemental screening options**: tomosynthesis (DBT — improved cancer detection + reduced recalls — most centers now standard), ultrasound (whole-breast — moderate benefit, more false positives), MRI (for high-risk; emerging for dense breast — DENSE trial), contrast-enhanced mammography (emerging); (5) **High-risk screening** (lifetime risk ≥ 20% by Tyrer-Cuzick or BRCAPro, BRCA carriers, family history, prior chest radiation 10-30, certain pathologies — LCIS, ADH): - **Annual mammography + annual breast MRI** starting at age 25-30 (alternating MRI + mammogram every 6 months); - Genetic counseling + testing; - Risk-reducing options — prophylactic mastectomy (90%+ reduction), risk-reducing salpingo-oophorectomy (ovarian + breast cancer reduction for BRCA), chemoprevention (tamoxifen, raloxifene, aromatase inhibitors); (6) **Modern**: 3D tomosynthesis preferred where available — replaces 2D as standard of care; AI-augmented reading emerging; (7) **Reporting BI-RADS**: standardized categories 0-6, density A-D; (8) **Multidisciplinary**: primary care + breast imaging + breast surgery + genetic counseling + women''s health

---

Mammography: USPSTF 2024 — biennial 40-74 (lowered from 50). ACS — annual 45-54 then biennial. ACR — annual 40+. Dense breasts — supplemental (DBT, US, MRI). High-risk (BRCA, > 20% lifetime risk) — annual mammogram + MRI from 25-30. BI-RADS reporting. Multidisciplinary.', NULL,
  'easy', 'hemato_onco', 'review',
  'radiology', 'clinical_decision', 'hemato_onco', 'adult',
  'USPSTF Mammography 2024; ACS; ACR', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'หญิงอายุ 50 ปี average risk — annual mammography screening — USPSTF + ACS recommendations'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 55 ปี + screening mammogram with suspicious mass — diagnostic mammography workup', '[{"label":"A","text":"Discharge"},{"label":"B","text":"Diagnostic mammography workup"},{"label":"C","text":"Always surgery without biopsy"},{"label":"D","text":"Single specialty"},{"label":"E","text":"X-ray sufficient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Diagnostic mammography workup: (1) **Diagnostic mammography** (vs screening) — additional views to characterize abnormalities found on screening or new symptoms: - **Spot compression** — focal pressure to flatten breast tissue + characterize mass (true vs overlapping tissue), evaluate margins; - **Magnification views** — fine details, especially calcifications (morphology, distribution); - **Tangential views** — lesion location confirmation; - **Implant displaced views** for implants; (2) **Targeted ultrasound** — adjunctive: characterize mass (cyst vs solid, BI-RADS US lexicon — shape, margin, orientation, internal echo pattern, posterior features); biopsy guidance; (3) **Breast MRI** — selected: high-risk screening, evaluating extent of known cancer (multifocal, multicentric, bilateral), neoadjuvant chemo response, occult primary with axillary mets, equivocal mammography findings; (4) **BI-RADS 5th edition (2013)**: - **BI-RADS 0**: incomplete (screening — needs additional imaging — call back); - **BI-RADS 1**: negative; - **BI-RADS 2**: benign findings (no further action); - **BI-RADS 3**: probably benign (< 2% malignancy) — short-interval follow-up imaging 6 months × 2 years; - **BI-RADS 4**: suspicious (2-95% — wide range, subcategories): 4A (2-10%), 4B (10-50%), 4C (50-95%) — TISSUE DIAGNOSIS; - **BI-RADS 5**: highly suggestive (≥ 95%) — TISSUE DIAGNOSIS + surgical planning; - **BI-RADS 6**: known biopsy-proven malignancy; (5) **Calcifications** important to characterize: - Benign — popcorn (fibroadenoma), vascular, dystrophic, milk of calcium (cyst, layering on lateral view), large rod-like, rim/eggshell; - Suspicious — fine pleomorphic, fine linear branching (DCIS, casting), amorphous; - Distribution — clustered, segmental, linear branching = suspicious; (6) **Tissue diagnosis options**: - **Stereotactic core needle biopsy** for calcifications (mammography-guided); - **Ultrasound-guided core biopsy** for masses; - **MRI-guided biopsy** for MR-only lesions; - **Vacuum-assisted biopsy** for more tissue; - **Excisional biopsy** historically (now less — used after image-guided when needed for diagnosis confirmation); - **FNA** less preferred (cytology only); (7) **Pathology results management**: - Benign concordant — routine; - Atypical hyperplasia (ADH) — surgical excision (upgrade rate 20-30%); - DCIS / cancer — multidisciplinary tumor board + treatment; - High-risk lesions (LCIS, ALH) — surveillance + chemoprevention discussion; (8) **Multidisciplinary breast center**: breast imaging + breast surgery + medical oncology + radiation oncology + pathology + genetics + nursing + plastics + survivorship

---

Diagnostic mammography: spot compression + magnification + tangential views + targeted US + selected MRI. BI-RADS categories 0-6. Calcifications morphology + distribution. Tissue diagnosis — stereotactic core for calcifications, US-core for masses, MRI-guided. Multidisciplinary tumor board.', NULL,
  'easy', 'hemato_onco', 'review',
  'radiology', 'clinical_decision', 'hemato_onco', 'adult',
  'ACR BI-RADS 5th ed; ACR Practice', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'หญิงอายุ 55 ปี + screening mammogram with suspicious mass — diagnostic mammography workup'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 35 ปี BRCA1+ — high-risk breast screening protocol', '[{"label":"A","text":"No screening"},{"label":"B","text":"High-risk breast screening — BRCA + family history"},{"label":"C","text":"Mammogram alone"},{"label":"D","text":"Single specialty"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** High-risk breast screening — BRCA + family history: (1) **High-risk identification**: - **Lifetime risk ≥ 20%** by validated models (Tyrer-Cuzick, BRCAPro, BOADICEA, Claus); - **Known mutation carriers**: BRCA1/2, TP53 (Li-Fraumeni), PTEN (Cowden), STK11 (Peutz-Jeghers), CDH1, PALB2, ATM, CHEK2 (moderate), others; - **Prior chest radiation 10-30** (lymphoma, etc.); - **Pathologic high-risk lesions**: LCIS, ALH, ADH; (2) **Screening protocol** (NCCN, ACS): - **Annual mammography** (often with tomosynthesis) starting age 30 (or 5-10 years before youngest affected family member); - **Annual breast MRI with contrast** starting age 25-30 (or younger if affected relative earlier); some guidelines recommend alternating mammogram + MRI every 6 months for tighter surveillance; - **Clinical breast exam q6-12 months**; (3) **Breast MRI**: high sensitivity for invasive cancer (90-95% vs mammography 50-70%); detects MRI-only cancers in BRCA+; can be uncomfortable, IV contrast, claustrophobia; abbreviated MRI protocols emerging (faster, lower cost — may extend to dense breast screening); (4) **Genetic counseling + testing**: - Pre-test + post-test counseling (psychological, family planning, surveillance, risk-reducing options); - Family cascade testing for first-degree relatives; - Insurance + employment discrimination protections (GINA in US — partial); (5) **Risk-reducing strategies**: - **Risk-reducing mastectomy (bilateral, prophylactic)** — > 90% reduction in breast cancer risk for BRCA+; nipple-sparing + breast reconstruction options preserve cosmesis; psychological + sexual + body image counseling; - **Risk-reducing salpingo-oophorectomy (RRSO)** — by age 35-40 for BRCA1, 40-45 for BRCA2 (after childbearing complete) — > 80% reduction ovarian cancer + 50% reduction breast cancer (pre-menopausal); hormone replacement until natural menopause age safe for BRCA+ (does not reverse breast cancer reduction); - **Chemoprevention**: tamoxifen (premenopausal + postmenopausal), raloxifene (postmenopausal only), aromatase inhibitors (exemestane STAR trial) — for BRCA2 evidence stronger; for elevated risk regardless of BRCA; (6) **Pancreatic + prostate + melanoma screening** for BRCA carriers (especially BRCA2): - EUS/MRI pancreas annually in selected (often family history of pancreatic cancer + BRCA2); - PSA + DRE + targeted screening for men with BRCA2; - Annual skin exam; (7) **Pregnancy considerations**: BRCA + childbearing — discuss timing, fertility preservation if chemo planned, preimplantation genetic testing options; (8) **Multidisciplinary high-risk clinic**: breast imaging + breast surgery + medical oncology + gynecologic oncology + genetics + psychology + reproductive medicine + survivorship

---

High-risk breast screening: BRCA+, > 20% lifetime risk, others — annual mammography + annual MRI from age 25-30. Risk-reducing options — mastectomy, RRSO (by 35-40 BRCA1, 40-45 BRCA2), chemoprevention. Pancreatic + prostate screening for BRCA2. Multidisciplinary high-risk clinic.', NULL,
  'medium', 'hemato_onco', 'review',
  'radiology', 'clinical_decision', 'hemato_onco', 'adult',
  'NCCN Genetic/Familial High-Risk; ACR', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'หญิงอายุ 35 ปี BRCA1+ — high-risk breast screening protocol'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 60 ปี mammography พบ suspicious microcalcifications fine pleomorphic clustered — stereotactic biopsy พบ DCIS', '[{"label":"A","text":"Discharge"},{"label":"B","text":"DCIS — diagnosis + management"},{"label":"C","text":"Always mastectomy"},{"label":"D","text":"Single specialty"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** DCIS — diagnosis + management: (1) **DCIS imaging features** (most common presentation now — screening): - **Microcalcifications** (most common): fine pleomorphic, fine linear branching, casting — segmental or linear distribution suggests ductal origin; - **Architectural distortion**; - **Mass / asymmetry** less common but possible; - **MRI**: non-mass enhancement (NME) — clumped or clustered ring pattern, linear/ductal, segmental distribution; high-grade DCIS more often detected on MRI; (2) **Stereotactic vacuum-assisted biopsy** standard for calcifications; **MRI-guided biopsy** for MRI-only DCIS; (3) **Pathology**: - DCIS — non-invasive cancer cells within ducts; - **Grade** (low, intermediate, high — nuclear grade + necrosis presence); - **Receptors** (ER/PR) — guide endocrine therapy; - **Margins** on surgical excision — critical; - **Comedo necrosis** — more aggressive; - **Microinvasion** (≤ 1 mm) — small foci of invasion within DCIS; - **Upgrade rate** to invasive on excision after core biopsy ~ 10-25% — depends on extent + grade + imaging features; (4) **Treatment**: - **Lumpectomy (breast-conserving surgery) + RT** — standard for most DCIS — equivalent local control to mastectomy when margins adequate (no ink on tumor per SSO/ASTRO/ASCO 2 mm consensus for DCIS); - **Mastectomy** — extensive DCIS not amenable to lumpectomy, multicentric, contraindication to RT, patient preference; cure rate > 98%; sentinel lymph node biopsy at mastectomy time (in case occult invasion); - **RT after lumpectomy** — reduces local recurrence ~ 50%; standard whole-breast RT (15-20 fractions hypofractionated); partial breast irradiation (APBI) for selected; omission considered for low-risk DCIS (LISA + LORD trials) — controversial; - **Endocrine therapy** for ER+ DCIS (tamoxifen or aromatase inhibitor postmenopausal) × 5 years — reduces ipsilateral + contralateral recurrence (NSABP B-24, IBIS-II); shared decision-making for adverse effects; - **HER2-targeted therapy** — investigational for DCIS HER2+ (NSABP B-43 results pending); (5) **Recurrence**: 50% recurrences are invasive (worse prognosis), 50% DCIS; (6) **Active surveillance** for low-risk DCIS — ongoing trials (LORIS, COMET, LORD) — paradigm potentially shifting for low-grade non-comedo DCIS; (7) **Multidisciplinary**: breast imaging + breast surgery + radiation oncology + medical oncology + pathology + genetics if young/family history + psychology + survivorship

---

DCIS: microcalcifications + non-mass enhancement on MRI. Stereotactic VAB. Treatment — lumpectomy + RT preferred (BCS + RT equivalent to mastectomy local control). Endocrine therapy for ER+. SSO/ASTRO/ASCO 2 mm margin. Active surveillance trials for low-risk. Multidisciplinary.', NULL,
  'medium', 'hemato_onco', 'review',
  'radiology', 'clinical_decision', 'hemato_onco', 'adult',
  'NCCN Breast Cancer; SSO/ASTRO/ASCO Margins', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'หญิงอายุ 60 ปี mammography พบ suspicious microcalcifications fine pleomorphic clustered — stereotactic biopsy พบ DCIS'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 8 ปี + RLQ pain + fever + vomiting + leukocytosis — pediatric appendicitis', '[{"label":"A","text":"CT first for all"},{"label":"B","text":"Pediatric appendicitis — different from adult"},{"label":"C","text":"Discharge"},{"label":"D","text":"Single specialty"},{"label":"E","text":"X-ray sufficient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric appendicitis — different from adult: (1) **Clinical**: classic triad of RLQ pain + fever + leukocytosis often atypical in young children; abdominal pain + vomiting common, may have diarrhea (mimics gastroenteritis); higher perforation rate at presentation due to delayed diagnosis; (2) **Imaging algorithm — Image Gently / ACR Appropriateness**: - **US first-line** (no radiation) — sensitivity ~ 85-90% in pediatric (often better than adult due to thinner body habitus); positive findings same as adult — non-compressible blind-ending tubular > 6-7 mm, target sign, appendicolith, periappendiceal fat echogenic, free fluid; - **MRI** without sedation often feasible for older children — alternative when US non-diagnostic + persistent concern (no radiation); - **CT** — third-line, only when US/MRI not feasible or non-diagnostic + clinical concern; reserved due to radiation; (3) **Pediatric appendicitis scoring** (PAS, Alvarado, pediatric-specific): risk-stratify before imaging — low risk → observation; intermediate → US; high → may proceed without imaging in some centers; (4) **Treatment**: - **Laparoscopic appendectomy** standard for uncomplicated; - **Antibiotics-first strategy** — emerging for uncomplicated in pediatric (CODA-like trials in peds — APPY-1, APAC trials); selected with appropriate consent + monitoring; - **Perforated with abscess** — IV antibiotics + percutaneous drainage (IR) → interval appendectomy 6-8 weeks (or selectively no appendectomy if cleared); (5) **Differential pediatric**: gastroenteritis, mesenteric adenitis (post-viral, mimics appendicitis on imaging — large nodes but normal appendix), Meckel diverticulitis, intussusception, pyelonephritis, ovarian torsion in girls, testicular torsion in boys, constipation, functional pain; (6) **Family communication**: clear explanation, anesthesia + surgery education, post-op expectations; (7) **Image Gently campaign** — pediatric-specific protocols + alternative modalities + ALARA; (8) **Multidisciplinary**: pediatric ED + pediatric surgery + radiology + pediatric anesthesia

---

Pediatric appendicitis: US first-line (Image Gently). MRI alternative. CT third-line. Atypical presentation common — higher perforation rate. Antibiotics-first strategy emerging. Perforated abscess — IR drain + interval appendectomy. Multidisciplinary peds care.', NULL,
  'easy', 'gi', 'review',
  'radiology', 'clinical_decision', 'gi', 'peds',
  'ACR Appropriateness; APSA Pediatric Surgery', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'เด็กชายอายุ 8 ปี + RLQ pain + fever + vomiting + leukocytosis — pediatric appendicitis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กอายุ 9 เดือน + intermittent crampy abdominal pain + currant jelly stool + sausage-shaped abdominal mass — intussusception', '[{"label":"A","text":"Discharge"},{"label":"B","text":"Pediatric intussusception — emergent"},{"label":"C","text":"Surgery first without enema"},{"label":"D","text":"X-ray sufficient"},{"label":"E","text":"Single specialty"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric intussusception — emergent: (1) **Clinical**: classic triad of intermittent crampy abdominal pain (drawing knees up — colicky episodes) + currant jelly stool (late finding — bowel ischemia) + sausage-shaped RUQ mass; age 3 months-3 years (peak 5-9 months); after viral illness common (lymphoid hyperplasia as lead point); (2) **Imaging**: - **US — first-line** (Image Gently): ''target sign'' / ''doughnut sign'' (concentric rings on cross-section), ''pseudokidney sign'' on longitudinal; sensitivity + specificity > 95%; identifies anatomic lead point (Meckel diverticulum, polyp, lymphoma) if present; - **Contrast / air enema** — both diagnostic + therapeutic (reduction); air preferred over contrast in many centers (less peritonitis if perforation); - **CT/MRI** — selected (atypical presentations, older children, complications); (3) **Reduction**: - **Air or contrast enema reduction** — under fluoroscopy or US guidance (US-guided enema reduces radiation — emerging) — success rate 70-90% if presents < 24 hours; - **Contraindications to enema** — clinical signs of peritonitis, perforation (free air), shock; - **Recurrence** ~ 10% after successful reduction — most can be re-attempted enema; - **Surgery** for: failed enema (consider repeat after rest period), pathologic lead point (older children > 3-5 years more likely), peritonitis/perforation, severe instability; (4) **Surgical**: open or laparoscopic — manual reduction; resection if non-viable bowel or lead point identified; (5) **Older children with intussusception** (> 5 years) — higher likelihood of pathologic lead point (lymphoma, polyp, Meckel) — workup needed; (6) **Adult intussusception**: nearly always pathologic lead point (tumor) — surgical resection; (7) **Pediatric resuscitation + family communication**; (8) **Multidisciplinary**: pediatric ED + pediatric surgery + pediatric radiology + IR if image-guided drainage needed

---

Pediatric intussusception: US first (target sign, pseudokidney). Air/contrast enema — diagnostic + therapeutic (success 70-90%). Surgery for failed enema, lead point, peritonitis. Older children/adults — pathologic lead point — surgical. Multidisciplinary.', NULL,
  'medium', 'gi', 'review',
  'radiology', 'clinical_decision', 'gi', 'peds',
  'ACR Appropriateness Pediatric; APSA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'เด็กอายุ 9 เดือน + intermittent crampy abdominal pain + currant jelly stool + sausage-shaped abdominal mass — intussusception'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กอายุ 2 ปี + multiple unexplained fractures + bruising at varying ages — non-accidental trauma (NAT) suspected', '[{"label":"A","text":"X-ray sufficient"},{"label":"B","text":"Non-accidental trauma (NAT) — child abuse imaging"},{"label":"C","text":"Discharge"},{"label":"D","text":"Single specialty"},{"label":"E","text":"No reporting"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Non-accidental trauma (NAT) — child abuse imaging: (1) **Skeletal survey** — initial imaging when NAT suspected age < 2 (some say < 5): - **Standardized views** per ACR + AAP: 1-view AP/lateral skull, AP/lateral spine, AP pelvis, AP/lateral chest, oblique CXR (rib fx), bilateral AP forearm + femur + tibia, AP/lateral both hands + feet (sometimes), bilateral oblique ribs; - **Repeat skeletal survey at 2 weeks** — increases sensitivity for healing fractures (callus formation, rib fractures often only visible later); (2) **Highly specific for NAT (per AAP)**: - Classic metaphyseal lesions (CML / ''bucket handle'' / ''corner fractures'') — corner of metaphysis avulsion — pathognomonic in non-ambulating child; - Posterior rib fractures (especially in infant — from chest squeezing); - Scapular fractures; - Sternal fractures; - Spinous process fractures; - Fractures of different ages; (3) **Moderately specific**: multiple fractures, especially bilateral; epiphyseal separations; vertebral body fractures + subluxations; digital fractures; complex skull fractures (non-parietal — depressed, bilateral, crossing sutures); (4) **Less specific but possible**: clavicle fractures (common accidental — birth, falls), simple linear skull fractures, mid-shaft long bone fractures; (5) **Imaging for head injury (most lethal NAT pattern — abusive head trauma)**: - **CT head** — initial in symptomatic infant; - **MRI brain + spine** — within 48 hours of admission for confirmed/suspected abusive head trauma: subdural hematomas at different ages (bilateral over convexities), parenchymal injuries (shaking-impact pattern), diffuse axonal injury, spinal cord injury (cervical from shaking); retinal hemorrhages (ophthalmology dilated exam); (6) **Abdominal trauma**: CT abdomen-pelvis with IV contrast — duodenal/jejunal hematomas (handlebar-type injury without history), liver/spleen lacerations, pancreatic injuries; (7) **Workup**: comprehensive medical evaluation + lab (CBC, coags — rule out bleeding diathesis, LFTs — abdominal injury, amylase/lipase, U/A — renal/bladder injury); ophthalmology dilated fundoscopic for retinal hemorrhages; (8) **Differential — mimics of NAT**: osteogenesis imperfecta (genetic testing + family history + clinical features), rickets, accidental trauma (history consistent), birth trauma (specific patterns, timing), congenital syphilis, leukemia, metabolic bone disease; (9) **Reporting + multidisciplinary**: - **Mandatory reporting** to child protective services + law enforcement in many jurisdictions — physician obligation, immunity from prosecution for good-faith reports; - **Child abuse pediatrician** consultation; - **Multidisciplinary child protection team**: pediatrics + child abuse specialist + radiology + ophthalmology + neurology + surgery + social work + child life + nursing + legal + CPS; (10) **Documentation** — meticulous + objective; photographs of injuries; family interview separately; (11) **Sibling evaluation** — at-risk siblings need evaluation

---

NAT skeletal survey + repeat at 2 wks. Highly specific — CML, posterior rib fx, fractures of different ages. MRI brain for AHT. Ophthalmology for retinal hemorrhages. CT abdomen for visceral. Differential rules out OI + metabolic. MANDATORY reporting. Multidisciplinary child protection team.', NULL,
  'hard', 'trauma', 'review',
  'radiology', 'clinical_decision', 'trauma', 'peds',
  'AAP NAT Statement; ACR Skeletal Survey', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'เด็กอายุ 2 ปี + multiple unexplained fractures + bruising at varying ages — non-accidental trauma (NAT) suspected'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 6 สัปดาห์ + breech presentation + family history of DDH — newborn hip screening', '[{"label":"A","text":"No screening"},{"label":"B","text":"DDH (developmental dysplasia of hip) screening"},{"label":"C","text":"Discharge"},{"label":"D","text":"Single specialty"},{"label":"E","text":"X-ray for all newborns"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** DDH (developmental dysplasia of hip) screening: (1) **AAP Screening Recommendations**: - **Clinical exam** at every well-child visit through age 1: Barlow (dislocatable) + Ortolani (relocatable) maneuvers — most sensitive < 3 months; later — limited abduction, leg length discrepancy, asymmetric gluteal/thigh folds; - **Risk factors**: female (4× higher), breech presentation (especially frank breech), family history of DDH, oligohydramnios, large-for-gestational-age, left hip (more common), torticollis, foot deformities; (2) **Imaging modality by age**: - **US (Graf method) before 4-6 months** — femoral heads not yet ossified; Graf alpha angle (bony coverage — ≥ 60° normal) + beta angle (cartilaginous coverage); dynamic stress maneuvers — Type I (normal), II (immature/dysplastic), III/IV (subluxed/dislocated); - **X-ray pelvis (AP)** **after 4-6 months** when femoral head ossifies — Shenton line continuity, acetabular index < 30°, Hilgenreiner + Perkin lines, position of ossified femoral head; (3) **Imaging indications**: - **Universal US screening** for breech presentation (regardless of exam findings) at 4-6 weeks; - **Risk-based** for family history + female alone — limited evidence — controversial whether universal or selective; - **Abnormal exam** at any age — imaging immediately (US if < 6 mo, X-ray if older); - **Persistent borderline findings** — repeat imaging; (4) **Treatment**: - **Pavlik harness** — first-line for mild-moderate dysplasia/dislocation in infant < 6 months — hips flexed + abducted; weekly monitoring with US; success ~ 90% in selected cases; - **Failed Pavlik / late diagnosis (6-18 months)** — closed reduction under anesthesia + spica cast; arthrogram to confirm reduction; - **Older children (> 18 months) / failed closed**: open reduction ± femoral / pelvic osteotomy; - **Adolescent / adult untreated DDH** — periacetabular osteotomy (PAO) for selected; total hip arthroplasty for advanced; (5) **Outcomes**: early diagnosis + treatment excellent; missed/late diagnosis — long-term OA risk; (6) **Education + parental counseling**: technique of Pavlik (compliance important — avoid lower extremity overlap, baby positioning, padding); (7) **Multidisciplinary**: pediatrics + pediatric orthopedics + radiology

---

DDH: clinical exam + risk factor screening. US (Graf) before 4-6 mo, X-ray after femoral head ossifies. Universal US for breech. Pavlik harness first-line < 6 mo. Closed/open reduction + osteotomy for older. Early diagnosis + treatment essential. Multidisciplinary.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'radiology', 'clinical_decision', 'msk_nontrauma', 'peds',
  'AAP DDH; POSNA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'เด็กหญิงอายุ 6 สัปดาห์ + breech presentation + family history of DDH — newborn hip screening'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กอายุ 4 ปี + ALL pediatric + new headache + papilledema — leptomeningeal disease vs benign post-treatment', '[{"label":"A","text":"X-ray sufficient"},{"label":"B","text":"Pediatric brain imaging — leukemia + CNS involvement"},{"label":"C","text":"Discharge"},{"label":"D","text":"Single specialty"},{"label":"E","text":"Avoid imaging"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric brain imaging — leukemia + CNS involvement: (1) **MRI brain + spine with contrast** — modality of choice in pediatric malignancy with neurological symptoms; (2) **Common findings in pediatric ALL with CNS involvement**: - **Leptomeningeal enhancement** — sulcal + cisternal + cranial nerve coverage; - **Parenchymal lesions** — uncommon, atypical; - **Chloromas** (myeloid sarcoma) — extramedullary AML; - **Hydrocephalus** from CSF outflow obstruction; - **Mass effect** rare in pure leukemia; (3) **Differential**: - Treatment-related: methotrexate leukoencephalopathy, PRES (posterior reversible encephalopathy syndrome — chemo, steroids, hypertension), stroke (asparaginase-related coagulopathy), infections (immunocompromised — bacterial, fungal — aspergillus), sinus venous thrombosis, intracranial hemorrhage (thrombocytopenia, DIC); - Disease-related: CNS relapse, secondary tumors (radiation-induced years later); (4) **CSF analysis** — flow cytometry essential (more sensitive than cytology); intracranial pressure measurement; (5) **Management of pediatric leukemia CNS prophylaxis + treatment**: - **CNS prophylaxis** standard during ALL treatment (intrathecal MTX ± hydrocortisone + cytarabine; cranial radiation historical, mostly avoided due to cognitive late effects); - **CNS relapse treatment** — intensive intrathecal + systemic + cranial RT + bone marrow transplant in selected; (6) **Image Gently** principles — minimize radiation in pediatric malignancy follow-up; MRI for surveillance (no radiation, sensitive); (7) **Multidisciplinary pediatric oncology team**: pediatric oncology + neuro-oncology + radiation oncology + radiology + pathology + neurology + ophthalmology + nursing + child life + psychology + school liaison + social work + family

---

Pediatric ALL with neuro sx: MRI brain + spine. Findings — leptomeningeal enhancement + parenchymal + chloromas. Differential — chemo toxicity (MTX leukoencephalopathy, PRES, stroke), infection, intracranial hemorrhage. CSF flow cytometry. Multidisciplinary peds onc team.', NULL,
  'hard', 'hemato_onco', 'review',
  'radiology', 'clinical_decision', 'hemato_onco', 'peds',
  'COG Pediatric ALL; ACR Appropriateness', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'เด็กอายุ 4 ปี + ALL pediatric + new headache + papilledema — leptomeningeal disease vs benign post-treatment'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Bone X-ray interpretation — systematic approach + identifying fractures', '[{"label":"A","text":"No system needed"},{"label":"B","text":"Bone X-ray interpretation — systematic approach"},{"label":"C","text":"Discharge"},{"label":"D","text":"Single approach only"},{"label":"E","text":"X-ray unreliable"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bone X-ray interpretation — systematic approach: (1) **Quality + projections first**: PA + lateral standard for most; oblique additional views as needed; comparison views (contralateral) selected; weight-bearing for joint assessment; (2) **Systematic search pattern**: - **A — Alignment**: cortical contour, angulation; check joints + line up bony landmarks (Shenton line — hip, Mayfield lines — wrist); - **B — Bone density**: osteopenia (diffuse decreased — osteoporosis), focal lesions (lytic, sclerotic, mixed); - **C — Cortex**: continuity (fracture lines), thickness (osteoporosis thin, hyperparathyroidism subperiosteal resorption); - **D — Density**: medullary cavity changes; - **E — Edges of bone**: periosteal reaction (acute fracture, infection, tumor, metabolic), erosions (arthritis); - **F — Fractures**: location (diaphysis, metaphysis, epiphysis — Salter-Harris classification I-V in children growth plates), pattern (transverse, oblique, spiral, comminuted, segmental, intra-articular), displacement (translation, angulation, rotation, shortening), open vs closed, neurovascular status (clinical); - **G — Gait + joint spaces**: alignment, joint space narrowing (OA), erosions (RA); - **H — Hardware**: implants + position; - **I — Imaging extras**: soft tissue swelling, foreign bodies, calcifications (vascular, soft tissue), gas; (3) **Fracture descriptors**: - **Location**: bone + segment (proximal/middle/distal third, intra-articular, etc.); - **Pattern**: simple, comminuted, segmental, butterfly fragment; - **Direction**: transverse, oblique, spiral, longitudinal, vertical; - **Displacement**: % translation, angulation (apex direction, degrees), rotation, shortening (cm); - **Specific named fractures**: Colles (distal radius dorsally angulated), Smith (distal radius volarly angulated), Bennett (1st CMC intra-articular), Boxer (5th metacarpal neck), Maisonneuve (medial malleolus + proximal fibula), Jones (5th MT base proximal), Lisfranc (TMT joint), Galeazzi (distal radius + DRUJ), Monteggia (ulna + radial head dislocation), Weber A/B/C (lateral malleolus relative to syndesmosis); (4) **Pediatric considerations**: - **Salter-Harris classification I-V** for physeal injuries (epiphyseal plate); growth disturbance risk; - **Buckle (torus) fractures** — incomplete cortical buckle, common forearm; conservative; - **Greenstick fractures** — incomplete on tension side; - **Plastic deformation** — bent bone without fracture; (5) **Stress fractures + insufficiency fractures** — early subtle; MRI for early diagnosis; (6) **Beware**: 1st sign of fracture may be subtle — fat pads (elbow effusion → radial head fx in adults, supracondylar in children — anterior sail + posterior fat pad), soft tissue swelling, joint effusion; (7) **Comparison with priors** + always look at edges + corners — easy to miss

---

Bone X-ray: systematic ABCDEFGHI approach. Fracture descriptors (location, pattern, displacement). Named fractures (Colles, Smith, Boxer, etc.). Pediatric Salter-Harris I-V + buckle + greenstick + plastic deformation. Subtle signs — fat pads, soft tissue. Compare priors.', NULL,
  'easy', 'trauma', 'review',
  'radiology', 'basic_science', 'trauma', 'adult',
  'Radiology Bone Atlas; ACR Practice Parameter', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Bone X-ray interpretation — systematic approach + identifying fractures'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Bone scintigraphy (Tc-99m MDP) vs PET — applications + interpretation', '[{"label":"A","text":"Bone scan only modality"},{"label":"B","text":"Bone scintigraphy + PET — applications"},{"label":"C","text":"PET unreliable"},{"label":"D","text":"Single test"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bone scintigraphy + PET — applications: (1) **Tc-99m MDP (methylene diphosphonate) bone scan**: - Mechanism: chemisorption to hydroxyapatite — increased uptake reflects increased osteoblastic activity + bone turnover + blood flow; - 3-phase: blood flow (immediate, dynamic), blood pool (5-10 min, vascular), delayed (2-4 hours, bone uptake); - **Applications**: bone metastases (especially osteoblastic — prostate, breast), osteomyelitis (3-phase positive — sensitive but less specific than MRI), occult fractures (especially stress), Paget disease, fibrous dysplasia, prosthesis loosening (delayed and combined with WBC scan), CRPS (complex regional pain syndrome); - **False positives**: any bone turnover increase (osteoarthritis, fracture, infection, tumor); - **False negatives**: highly aggressive purely lytic lesions (e.g., multiple myeloma — lacks osteoblastic response — low sensitivity vs FDG-PET/CT or MRI); (2) **Tc-99m WBC (white blood cell-labeled) scintigraphy** — autologous WBCs labeled in vitro with HMPAO or HMPAO + Tc-99m colloid: - More specific for infection vs MDP — useful in prosthetic infection (vs aseptic loosening), diabetic foot, etc.; (3) **F-18 FDG PET/CT**: - Glucose analog — increased uptake in metabolically active tissue; - **Applications in MSK**: bone metastases (especially marrow-based — lymphoma, MM, melanoma; sometimes more sensitive than bone scan for lytic mets — but less for osteoblastic prostate), sarcoma staging + response, infection (PET excellent for chronic osteomyelitis, vertebral discitis), large vessel vasculitis; - **Limitations**: physiologic uptake (brain, bowel, urinary tract); false positives (infection, inflammation, recent fracture, brown adipose tissue); (4) **F-18 NaF PET/CT (sodium fluoride)**: - Bone-seeking like MDP but with PET resolution + sensitivity — superior for bone mets detection vs bone scan; - Often used for prostate cancer metastasis evaluation + skeletal staging in selected; (5) **Ga-68 PSMA PET/CT** for prostate cancer (above question 108); (6) **Lu-177 DOTATATE / DOTATOC** — somatostatin receptor (neuroendocrine tumors + paragangliomas + meningiomas) — diagnostic + therapeutic (PRRT — peptide receptor radionuclide therapy); (7) **Radium-223 (Xofigo)** — alpha-emitter — for prostate cancer bone mets — improves survival (ALSYMPCA); (8) **Lu-177 PSMA RLT** — recent approval for mCRPC — VISION trial; (9) **Image interpretation** requires knowledge of physiologic vs pathologic uptake + clinical context + comparison with anatomic imaging; (10) **Multidisciplinary**: nuclear medicine + oncology + endocrinology (DOTATATE, PRRT) + urology + radiation safety officer

---

Tc-99m MDP bone scan: bone turnover — mets (osteoblastic), occult fx, OM. False negative in lytic MM. WBC scan more specific for infection. FDG-PET — MSK tumors + lymphoma + MM + infection. NaF PET superior bone mets. PSMA PET prostate. PRRT DOTATATE. Radium-223 + Lu-177 PSMA therapeutic. Multidisciplinary.', NULL,
  'medium', 'procedures', 'review',
  'radiology', 'basic_science', 'procedures', 'adult',
  'SNMMI; EANM Procedure Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Bone scintigraphy (Tc-99m MDP) vs PET — applications + interpretation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'MRI MSK sequences — joint imaging protocols', '[{"label":"A","text":"Single sequence"},{"label":"B","text":"MSK MRI sequences"},{"label":"C","text":"T1 only"},{"label":"D","text":"Discharge"},{"label":"E","text":"X-ray equivalent"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** MSK MRI sequences: (1) **Standard MSK protocols include**: - **T1**: anatomy, fat bright, bone marrow normal (yellow marrow bright, red marrow intermediate); replacement → low signal (tumor, edema, inflammation, fibrosis); - **PD (proton density) fat-saturated** — most useful for many MSK applications: meniscus, cartilage, ligaments (intermediate signal); pathology (fluid, edema, tears) brighter; - **T2 fat-saturated**: fluid + edema bright; pathology highlighted; for tendon + soft tissue + joint effusion; - **STIR (short tau inversion recovery)**: alternative to fat-sat T2 — robust fat suppression on inhomogeneous fields; sensitive for bone marrow edema (fractures, contusions, stress reactions, osteomyelitis, tumor); - **T2*** GRE (gradient echo): cartilage, fragments, susceptibility (blood, calcifications); - **Post-contrast T1 with fat saturation**: enhancement — synovitis, tumor, infection (abscess wall + non-enhancing center), inflammation, granulation tissue; (2) **MR arthrogram** — direct (intra-articular injection of dilute gadolinium): - Indications: shoulder (SLAP, Bankart, partial RC tear), wrist (TFCC, ligament), hip (labrum), elbow (UCL); - Superior for intra-articular abnormalities, distends joint, outlines structures; - Risks: needle + injection complications, infection; - **Indirect MR arthrogram** (IV gadolinium + delayed imaging) — less common alternative; (3) **Specialized cartilage techniques**: - **T2 mapping** — quantifies cartilage hydration + collagen integrity; - **dGEMRIC (delayed gadolinium-enhanced MRI of cartilage)** — glycosaminoglycan content; - **T1ρ** — proteoglycan content; - All advanced for early OA detection + research; (4) **High field strength (3 T) + dedicated coils**: improved SNR + resolution; - 7 T research; (5) **Whole-body MRI**: oncologic staging (myeloma, lymphoma, mets), inflammatory diseases (PsA, sarcoidosis), fever of unknown origin selected; (6) **MR neurography**: high-resolution MRI of peripheral nerves — entrapment + injury + tumors; (7) **Application by region**: - **Knee**: PD fat-sat for meniscus, ACL, cartilage; T2 fat-sat for bone edema; - **Shoulder**: PD fat-sat + T2 fat-sat for RC; T1 + T2 axial for labrum; arthrogram for SLAP/Bankart; - **Spine**: T1 + T2 sagittal; STIR for marrow edema; post-contrast T1 fat-sat for infection/tumor; DWI for abscess + tumor; - **Hip**: 3T preferred; non-arthrogram often sufficient for FAI + labrum (controversial vs arthrogram); cartilage assessment T2 mapping selected; (8) **Multidisciplinary**: radiology + orthopedics + sports medicine + rheumatology + PT

---

MSK MRI: T1 anatomy + marrow; PD fat-sat for cartilage/meniscus/ligaments; T2 fat-sat + STIR for edema; post-contrast for inflammation/infection/tumor. MR arthrogram for labrum + partial tears + ligaments. Advanced cartilage (T2 mapping, T1ρ). Whole-body for oncology + inflammation. Multidisciplinary.', NULL,
  'medium', 'procedures', 'review',
  'radiology', 'basic_science', 'procedures', 'adult',
  'ACR MRI Standards; AJR Practical MSK', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'MRI MSK sequences — joint imaging protocols'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Mammography quality + MQSA + tomosynthesis', '[{"label":"A","text":"No regulation needed"},{"label":"B","text":"MQSA (Mammography Quality Standards Act, FDA, US)"},{"label":"C","text":"Discharge"},{"label":"D","text":"Single specialty"},{"label":"E","text":"X-ray sufficient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mammography quality: (1) **MQSA (Mammography Quality Standards Act, FDA, US)** — federal regulation since 1992 + reauthorized: - Facility accreditation + certification; - Equipment QC + maintenance; - Personnel qualifications (radiologic technologists, interpreting physicians, medical physicists) — initial training + continuing education + minimum volume; - Reporting standards; - Inspections (annual + complaint-based); - Communication of results to patient (lay summary letter mandatory); - Recent update — breast density notification requirement (2024 effective date), formal mammography reports + lay summaries; (2) **Quality control daily/weekly/monthly/annual tests**: - Phantom imaging (ACR phantom — fibers, specks, masses); - Compression force; - Dose; - Beam quality; - Image quality (contrast, resolution, noise); - Display monitor calibration; (3) **Tomosynthesis (DBT, digital breast tomosynthesis)** — ''3D mammography'': - Multiple low-dose images at different angles → reconstruction of thin slice volume; - Improvements vs 2D digital: ↑ cancer detection (~ 20-40% in some studies — STORM, OTST), ↓ recall rates (~ 15%), better localization, better for dense breasts; - Disadvantages: higher dose (synthesized 2D from DBT eliminates need for separate 2D dose); longer interpretation time; - **Becoming standard of care** — many practices adopted as primary screening modality; - Recent TMIST trial — ongoing comparison; (4) **Image archiving + comparison** with priors — essential for early detection of change; (5) **Double reading + AI-assisted reading**: - Double reading common in Europe — improves detection; - AI emerging — multiple FDA-cleared tools for triage + detection adjunct; computer-aided detection (CAD) historically + now AI-augmented; (6) **Patient experience + accessibility**: scheduling, transportation, screening barrier removal (cost, fear, time), mobile mammography units for underserved populations; (7) **Quality metrics**: cancer detection rate, recall rate, PPV of biopsy recommendation, sensitivity/specificity, interval cancers; published benchmarks (ACR + BCSC) for self-comparison; (8) **Patient counseling + shared decision-making** for screening: risks (false positives, anxiety, overdiagnosis) + benefits (mortality reduction); USPSTF + ACS + ACR variation; (9) **Multidisciplinary breast center**: breast imaging + technologists + medical physics + administration + breast surgery + medical oncology + genetics + radiation oncology + nursing + survivorship + patient navigators

---

MQSA federal regulation — accreditation, QC, personnel, reporting, density notification (2024). DBT improves detection + reduces recalls — increasingly standard. AI adjunct. Quality metrics + benchmarks. Multidisciplinary breast center. Patient counseling + shared decision-making.', NULL,
  'easy', 'procedures', 'review',
  'radiology', 'basic_science', 'procedures', 'adult',
  'FDA MQSA; ACR Mammography; SBI', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Mammography quality + MQSA + tomosynthesis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Pediatric imaging — radiation considerations + Image Gently campaign', '[{"label":"A","text":"No radiation difference adult vs peds"},{"label":"B","text":"Pediatric imaging — radiation safety"},{"label":"C","text":"Always CT for fast diagnosis"},{"label":"D","text":"Discharge"},{"label":"E","text":"Single approach"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric imaging — radiation safety: (1) **Why pediatric radiation matters more**: - Higher cancer risk per dose — 3-4× more radiosensitive than adult (BEIR VII committee); - Longer life expectancy → more time for cancer to develop; - Cumulative lifetime exposure adds up — many imaging studies over childhood; - Smaller body → relatively higher absorbed dose for given parameters; (2) **Image Gently Campaign** (Alliance for Radiation Safety in Pediatric Imaging) — international: - **Child-size the dose** — pediatric-specific protocols; - **Image only when needed** — necessity, appropriateness; - **Use only the necessary radiation** — ALARA; - **Modalities considered**: prefer no-radiation alternatives (US, MRI) when possible; (3) **Specific recommendations**: - **CT**: lower kVp + mA based on age/size; automatic tube current modulation; iterative reconstruction; restricted scan length; avoid repeat scans without indication; - **Fluoroscopy**: pulsed instead of continuous; limit time + magnification; use last image hold; - **Nuclear medicine**: weight-based dosing per consensus dose tables (NACGM, EANM-SNMMI joint); - **Radiography**: collimation, shielding (limited evidence — controversial recently), proper technique; (4) **Modality choices**: - **US — first-line for many**: appendicitis, intussusception, hip DDH, pyloric stenosis, lumbar puncture guidance, CVC placement, soft tissue, FAST trauma; - **MRI when feasible** — sedation/anesthesia in young children may be needed (risks vs benefit); - **CT — judicious use**: major trauma, complex congenital, suspected pulmonary embolism (rare in peds), brain in selected (post-trauma per PECARN), cancer staging; - **Plain X-ray**: chest, abdomen, MSK, skeletal survey (NAT); - **Fluoroscopy**: contrast studies (VCUG, UGI, intussusception reduction); (5) **PECARN head injury rules** (above) reduce unnecessary head CT in pediatric trauma; (6) **Family communication**: risk-benefit discussion, why specific modality, ALARA, alternatives; (7) **Cumulative dose tracking** — child''s lifetime radiation history; many EMRs track; (8) **Quality + accreditation**: ACR pediatric imaging accreditation programs; (9) **Sedation considerations**: pediatric anesthesia consultation, fasting guidelines, monitoring, recovery; recent FDA warnings on general anesthesia < 3 years (developing brain) — shared decision-making + reasonable alternatives; (10) **Multidisciplinary**: pediatric radiology + pediatric subspecialists + technologists + medical physics + anesthesia + nursing + child life + family + ordering providers

---

Pediatric radiation: 3-4× more sensitive than adult; longer life. Image Gently — child-size dose + image only when needed + ALARA. US first-line for many. MRI alternative (sedation considerations). PECARN reduces head CT. Cumulative dose tracking. Multidisciplinary peds imaging.', NULL,
  'easy', 'procedures', 'review',
  'radiology', 'basic_science', 'procedures', 'peds',
  'Image Gently Alliance; ACR Pediatric', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Pediatric imaging — radiation considerations + Image Gently campaign'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Informed consent + patient communication in radiology procedures', '[{"label":"A","text":"Verbal only no documentation"},{"label":"B","text":"Informed consent in radiology"},{"label":"C","text":"Discharge"},{"label":"D","text":"Family decides alone"},{"label":"E","text":"No consent needed"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Informed consent in radiology: (1) **Elements of valid informed consent**: - **Capacity** to understand + decide; surrogate if not (HCPOA, family per state law); - **Disclosure** by physician — diagnosis, recommended procedure, alternatives (including no treatment), risks (common + serious + procedure-specific), benefits, prognosis; - **Understanding** by patient — verify comprehension, use lay language, professional medical interpreter for language; teach-back method; - **Voluntary** — no coercion; - **Documentation** + signature; (2) **Procedures requiring informed consent in radiology**: - **IR procedures**: biopsies, embolizations, catheter-based interventions, ablations, vertebroplasty, drainages, central lines; - **Contrast administration** — especially in selected patients (prior reactions); - **Sedation** — moderate to deep; - **Radiation therapy planning** (separate); - Sometimes mammography callbacks; (3) **Risks to disclose** — specific to procedure: - Bleeding, infection, organ injury, allergic reaction; - Procedure-specific (e.g., chylothorax in thoracic biopsy, biloma in liver biopsy, pneumothorax in lung biopsy, paralysis in spine procedure); - Alternative outcomes (e.g., non-diagnostic biopsy → re-biopsy); (4) **Special situations**: - **Emergent** — life-threatening + unable to obtain — implied consent (document carefully); - **Pediatric** — parent/legal guardian consent + assent of older child; - **Cognitively impaired adult** — surrogate; - **Sedated patient** — consent before sedation; - **Refusal of recommended procedure** — document discussion of risks of NOT doing procedure (informed refusal); - **Language barrier** — professional medical interpreter (NOT family member ideally); - **Health literacy** — adapt explanation level; (5) **Cultural + spiritual considerations** — respect; involve clergy, family per patient wishes; (6) **Communication best practices**: - **Patient-centered**: meeting patient where they are; - **Compassionate**: especially difficult diagnoses (cancer findings); - **Bad news communication** — SPIKES protocol (Setting, Perception, Invitation, Knowledge, Empathy, Strategy/Summary); - **Plain language**: avoid jargon; - **Time + space**: not rushed, private; - **Family + support persons** present per patient preference; - **Follow-up**: questions, additional resources, contact information; (7) **Radiology report communication to patients**: - **Open Notes** + patient portals — patients see reports often before physician contact; - **Plain-language summaries** + glossaries — emerging; - **Direct patient communication** for some findings — controversies (when, how); (8) **Documentation**: thorough; medicolegal protection but more importantly good care; (9) **Multidisciplinary**: ordering provider + radiologist (especially for procedures) + nursing + patient navigation + family

---

Informed consent: capacity + disclosure + understanding + voluntary + documentation. Risks specific to procedure. Special situations (emergent, peds, cognitively impaired). SPIKES for bad news. Patient-centered communication. Open Notes + plain language summaries. Multidisciplinary.', NULL,
  'easy', 'procedures', 'review',
  'radiology', 'ems_mgmt', 'procedures', 'adult',
  'ACR Practice Parameter Patient Communication; Joint Commission', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Informed consent + patient communication in radiology procedures'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Lean + Six Sigma + quality improvement in radiology', '[{"label":"A","text":"No QI in radiology"},{"label":"B","text":"Lean + Six Sigma + QI in radiology"},{"label":"C","text":"Discharge"},{"label":"D","text":"Single approach"},{"label":"E","text":"Only individual"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Lean + Six Sigma + QI in radiology: (1) **Lean principles** (from Toyota Production System): - Eliminate waste (TIMWOODS — Transport, Inventory, Motion, Waiting, Overproduction, Over-processing, Defects, Skills underutilized); - Value stream mapping — visualize patient/process flow + identify bottlenecks; - Continuous flow; - Pull system (just-in-time); - Continuous improvement (Kaizen) — small incremental changes; - 5S (Sort, Set in order, Shine, Standardize, Sustain); (2) **Six Sigma** — data-driven defect reduction: - DMAIC (Define, Measure, Analyze, Improve, Control) framework; - Statistical tools — control charts, root cause analysis, Pareto charts, fishbone (Ishikawa) diagrams; - Goal: 3.4 defects per million (six sigma); - Belts (yellow, green, black, master black) for training levels; (3) **Common radiology applications**: - **Reducing turnaround time** for reports; - **Reducing patient wait times** for scheduled exams; - **Reducing exam cancellations** + no-shows; - **Reducing dose** in CT (workflow + standardization); - **Reducing recall rates** in mammography; - **Improving critical findings communication**; - **Reducing repeat imaging** (technique, positioning, contrast); - **Reducing patient transport time** in ED workflow; - **Increasing scanner utilization**; (4) **PDSA / PDCA cycles** (Plan-Do-Study-Act / Plan-Do-Check-Act) — iterative improvement; pilot small changes, measure, adjust, spread; (5) **Quality measures** + metrics: - **Process measures**: turnaround time, throughput, exam appropriateness; - **Outcome measures**: missed diagnoses, complication rates, patient satisfaction; - **Structural measures**: equipment, staffing, accreditation; - **Balanced scorecard** approach; (6) **Patient experience** measurement: HCAHPS-like for radiology, NPS (net promoter score), focus groups, post-visit surveys; (7) **Just culture + safety culture**: - Blame-free reporting of errors + near-misses; - System-focused vs individual-focused; - Learning organization; - Psychological safety for staff; (8) **Tools + technology enablers**: - **EHR + analytics dashboards** for real-time monitoring; - **Automation** for routine tasks (scheduling, reminders); - **AI** for workflow prioritization + dose monitoring + quality scoring; (9) **Multidisciplinary QI teams**: radiology + technologists + nursing + IT + administration + quality + medical physics + ordering providers + patients + caregivers; (10) **Modern**: lean-six-sigma + design thinking + agile + human factors engineering + behavioral economics — integrated approach to radiology operations; (11) **Examples**: - Mayo Clinic, Virginia Mason, Cleveland Clinic — published examples; - ACR + SIIM + RSNA — practical workshops + resources

---

Lean + Six Sigma + QI: Lean eliminates waste (TIMWOODS) + value stream + Kaizen + 5S. Six Sigma DMAIC + data-driven. PDSA cycles. Common applications — TAT, wait times, dose, recall rates. Just culture + safety. Multidisciplinary teams. Modern integrated approach.', NULL,
  'medium', 'procedures', 'review',
  'radiology', 'ems_mgmt', 'procedures', 'adult',
  'ACR + SIIM + RSNA QI Resources', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'Lean + Six Sigma + quality improvement in radiology'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยเด็กอายุ 6 ปี + diagnosed osteosarcoma — pediatric cancer multidisciplinary care', '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Pediatric cancer multidisciplinary care"},{"label":"C","text":"Adult oncology care"},{"label":"D","text":"Discharge"},{"label":"E","text":"No multidisciplinary"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric cancer multidisciplinary care: (1) **Multidisciplinary pediatric oncology team — centralized at COG (Children''s Oncology Group) center**: - Pediatric oncology + pediatric surgical oncology + pediatric radiation oncology + pediatric radiology + pediatric pathology + pediatric anesthesia + child life specialist + pediatric psychology + pediatric palliative care + school liaison + nutrition + social work + nursing + chaplaincy + research coordinators + financial counseling + survivorship + parent partner; (2) **Imaging during therapy**: - Initial staging + restaging (MRI primary tumor, CT chest mets, bone scan/PET); - Mid-therapy response (RECIST-modified for pediatric); - Post-therapy surveillance — risk-adapted schedule (e.g., osteosarcoma — q3 months × 2 years, then q6 months × 3 years, then annual); - Image Gently — MRI + US when possible; CT only when needed; (3) **Treatment principles**: - **Cooperative group trials** (COG) — standard of care for most pediatric malignancies; high enrollment rate (~ 60% of pediatric oncology patients on trials) drives progress; - **Multimodal therapy** — surgery + chemo + RT + targeted/immunotherapy as applicable; - **Risk-stratification** drives intensity; (4) **Family-centered care principles**: - **Child + family unit**, not just child; - **Open communication** — age-appropriate explanation; honest, hopeful; - **Decision-making** — assent of older children + adolescents; parent consent; - **Advocacy + empowerment**; (5) **Child life specialist** — critical: prepare child for procedures, age-appropriate explanation, play therapy, distraction techniques, emotional support; (6) **Education + school**: tutors + school liaison; reintegration planning; legal protections (IDEA, 504 plan); (7) **Fertility preservation**: - **Pre-treatment** when feasible: testicular tissue/sperm cryopreservation (post-pubertal males), ovarian tissue cryopreservation (females), oophoropexy if RT to pelvis; - For pre-pubertal — experimental options; - Reproductive endocrinology consultation; (8) **Psychosocial support**: - Family counseling, sibling support, parent support groups; - PTSD, depression, anxiety screening + treatment; - Long-term mental health follow-up; - **Adolescent and Young Adult (AYA) oncology programs** — recognizing distinct needs; (9) **Palliative care + symptom management**: - **Concurrent** from diagnosis (not ''end of life'' only); - Symptom management (pain, nausea, fatigue, anxiety); - Advanced care planning, goals of care; - Hospice when appropriate; - Bereavement support for family; (10) **Survivorship care**: - **Late effects** of treatment — cardiotoxicity (anthracyclines), pulmonary (chest RT), endocrine (growth, fertility, thyroid), neurocognitive (CNS therapy), secondary malignancies (RT, chemo), psychosocial; - **Children''s Oncology Group long-term follow-up guidelines** — exposure-based screening; - **Survivorship clinic** with comprehensive care; - Successful re-integration to school/work/life; (11) **Research + clinical trials integration**; (12) **Financial + insurance**: navigating costs, support programs (CureSearch, others), advocacy; (13) **Family + advocacy organizations** — CureSearch, NCCS, parent advocacy groups, condition-specific (e.g., MIB Agents for osteosarcoma)

---

Pediatric cancer: centralized COG center. Multidisciplinary peds onc team. Imaging Gently. Cooperative group trials. Family-centered care. Child life. Education + school liaison. Fertility preservation. Psychosocial support. Concurrent palliative care. Survivorship for late effects. Multidisciplinary throughout.', NULL,
  'medium', 'hemato_onco', 'review',
  'radiology', 'integrative', 'hemato_onco', 'peds',
  'COG; AAP Pediatric Cancer; ASCO', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยเด็กอายุ 6 ปี + diagnosed osteosarcoma — pediatric cancer multidisciplinary care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 30 ปี + first-trimester pregnancy + suspected PE — V/Q scan vs CTPA decision', '[{"label":"A","text":"Discharge"},{"label":"B","text":"V/Q scan vs CTPA in pregnancy"},{"label":"C","text":"Always CTPA"},{"label":"D","text":"Single specialty"},{"label":"E","text":"X-ray sufficient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** V/Q scan vs CTPA in pregnancy: (1) **Both have low fetal radiation** — both acceptable per ACR + ATS guidelines: - **CTPA**: fetal dose ~ 0.003-0.13 mGy (well below 50 mGy threshold), breast dose higher (~ 20 mGy without shielding) — radiation breast tissue concern in young women; - **V/Q scan**: fetal dose ~ 0.1-0.5 mGy slightly higher than CTPA, but lower breast dose; (2) **Modern practice considerations**: - **Modified V/Q protocols in pregnancy** — perfusion-only scan (skip ventilation if CXR normal) — even lower dose; - **Half-dose CTPA** protocols; - **Both modalities have ~ 95% diagnostic concordance**; (3) **Decision factors**: - **Normal CXR** → V/Q acceptable + may be preferred (low non-diagnostic rate); - **Abnormal CXR** → CTPA preferred (V/Q likely non-diagnostic + needs follow-up); - **Patient/clinician preference**; - **Time + availability** (CTPA usually faster); - **Renal function** (CTPA contrast — usually OK in pregnancy); - **Iodine allergy** → V/Q; (4) **General PE workup in pregnancy** — modified pathway (YEARS algorithm + pregnancy-specific tools): - Wells-like clinical assessment; - D-dimer — elevated in pregnancy physiologically but useful with pregnancy-adjusted cutoffs (TIPPS algorithm); - **Bilateral leg US** first if signs/symptoms of DVT — if positive treat as PE (same management); - **If imaging needed** → V/Q or CTPA as above; (5) **V/Q scan interpretation** (PIOPED criteria — modified Wells): - **Normal**: rules out PE; - **High probability**: ≥ 2 large segmental mismatched defects — treat as PE; - **Low / intermediate / non-diagnostic**: requires further imaging or empiric treatment based on clinical probability; (6) **PE treatment in pregnancy**: - **LMWH** (enoxaparin, dalteparin) — does NOT cross placenta — first-line throughout pregnancy + postpartum; weight-based; renal-adjusted; - Warfarin contraindicated (teratogen); - DOACs contraindicated; - Duration — throughout pregnancy + 6 weeks postpartum minimum; - Consider IVC filter for: high-risk PE + active bleeding contraindicating anticoagulation, recurrent PE on anticoagulation; (7) **Multidisciplinary**: ED + OB + radiology + hematology + maternal-fetal medicine

---

PE in pregnancy: V/Q or CTPA both low fetal radiation. Decision factors — CXR (normal → V/Q; abnormal → CTPA), preference, availability. Leg US first if DVT signs. LMWH throughout pregnancy + 6 wks postpartum; warfarin + DOACs contraindicated. Multidisciplinary.', NULL,
  'medium', 'respiratory', 'review',
  'radiology', 'clinical_decision', 'respiratory', 'adult',
  'ACR Appropriateness; ATS PE Pregnancy 2011', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 30 ปี + first-trimester pregnancy + suspected PE — V/Q scan vs CTPA decision'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี + diagnosed DLBCL — PET/CT for staging + response assessment', '[{"label":"A","text":"CT only sufficient"},{"label":"B","text":"PET/CT in lymphoma — Lugano + Deauville criteria"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Discharge"},{"label":"E","text":"X-ray sufficient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** PET/CT in lymphoma — Lugano + Deauville criteria: (1) **PET/CT FDG — standard of care for FDG-avid lymphomas** (DLBCL, Hodgkin, follicular grade 3, mantle cell, peripheral T-cell — most NHL subtypes); (2) **Staging — Lugano Classification (2014)**: - **Modified Ann Arbor staging** with PET integrated; - **Stages I-IV** based on nodal regions + extranodal involvement; - PET more sensitive than CT for nodal + extranodal (bone marrow, spleen, GI) disease; - **Bone marrow biopsy** no longer needed for DLBCL staging if PET is negative for marrow involvement (changed practice paradigm); (3) **Response assessment — Deauville 5-point scale** based on FDG uptake vs reference (mediastinal blood pool + liver background): - **1**: no uptake above background; - **2**: ≤ mediastinum; - **3**: > mediastinum but ≤ liver; - **4**: > liver moderately; - **5**: > liver markedly OR new lesions; - **Score 1-3 = complete metabolic response** (negative); - **Score 4-5 with reduced uptake vs baseline** = partial; - **Score 4-5 with increased uptake or new** = treatment failure; (4) **Interim PET** (PET-2 after 2 cycles in Hodgkin) — guides treatment intensification or de-escalation (response-adapted therapy — e.g., RATHL trial — Hodgkin); (5) **End-of-treatment PET** — confirms complete response — drives follow-up + further therapy; (6) **Pitfalls**: - **False positives**: inflammation, infection, brown adipose tissue, thymic rebound (children, post-chemo), recent G-CSF, sarcoidosis; - **False negatives**: low-grade lymphomas (FDG-low), small lesions (partial volume), bone marrow uptake from G-CSF; (7) **Modern advances**: - **CT-guided biopsy** for tissue confirmation; - **Quantitative measures** — SUV, total metabolic tumor volume (TMTV) emerging as prognostic; - **AI-assisted** segmentation + quantification; - **PET/MRI** alternative — lower radiation, especially pediatric + selected; (8) **Treatment of DLBCL**: - **R-CHOP** first-line (rituximab + cyclophosphamide + doxorubicin + vincristine + prednisone); - **Pola-R-CHP** (polatuzumab vedotin + R-CHP — POLARIX trial); - **CNS prophylaxis** for high-risk; - **Relapsed/refractory**: salvage chemo + ASCT; **CAR-T cell** (axicabtagene, tisagenlecleucel, lisocabtagene — multiple FDA-approved); bispecifics (epcoritamab, glofitamab); ADCs (loncastuximab, polatuzumab); (9) **Multidisciplinary lymphoma team**: hematology + medical oncology + radiation oncology + nuclear medicine + radiology + pathology + nursing + palliative care + survivorship

---

Lymphoma PET/CT: standard for FDG-avid (Lugano staging — DLBCL, Hodgkin). Deauville 5-point response. Interim PET response-adapted therapy. End-of-treatment confirms CR. False positives + negatives. R-CHOP + emerging CAR-T + bispecifics. Multidisciplinary.', NULL,
  'hard', 'hemato_onco', 'review',
  'radiology', 'clinical_decision', 'hemato_onco', 'adult',
  'Lugano Classification 2014; NCCN B-cell Lymphoma', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี + diagnosed DLBCL — PET/CT for staging + response assessment'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี + oropharyngeal squamous cell carcinoma — PET/CT for staging + treatment planning', '[{"label":"A","text":"No PET role"},{"label":"B","text":"PET/CT in head + neck cancer"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Discharge"},{"label":"E","text":"X-ray sufficient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** PET/CT in head + neck cancer: (1) **PET/CT FDG indications**: - **Staging** for advanced (stage III-IV) — distant mets + nodal disease + synchronous primaries (5-10% in HN cancer); - **Treatment planning** — defining gross tumor volume + nodal volumes for RT; - **Response assessment** after chemoradiation — at 12 weeks (avoiding inflammation immediately post-RT); - **Surveillance + recurrence** detection; - **Unknown primary** with cervical lymphadenopathy — finding occult primary (esp. tonsil/base of tongue / nasopharynx); (2) **Findings + interpretation**: - **Primary tumor**: hypermetabolic; defines extent; - **Lymph nodes**: hypermetabolic > 1 cm or > 0.5 cm with morphologic suspicion; bilateral involvement; retropharyngeal nodes; - **Distant mets**: lung, bone, liver, brain (PET poor for brain due to high background — MRI for brain); - **Synchronous primaries** — common (alcohol/tobacco-related fields cancerization) — second primary lung + esophagus + colon; (3) **Specific findings + scoring**: - **Hopkins criteria** for response assessment — post-treatment scoring; - **Visual + SUV-based** assessment; - **PERCIST 1.0** quantitative response criteria (broader oncology); (4) **Modality choice depending on goal**: - **Primary diagnosis**: CT + MRI for local staging (MRI better for soft tissue + perineural — important in HN); biopsy by ENT; - **Comprehensive staging**: PET/CT (whole body); - **Brain involvement suspected**: MRI brain; - **Recurrence vs post-treatment**: PET/CT 12+ weeks; (5) **HPV-associated oropharyngeal cancer**: - **Distinct biology** + better prognosis vs HPV-negative; - **De-escalation trials** ongoing (NRG-HN002, HN005); - **p16 IHC + HPV PCR** for status; (6) **Treatment**: - **Early stage** — surgery (transoral robotic surgery for selected) or RT (single modality); - **Locally advanced** — concurrent chemoradiation (cisplatin-based) + immunotherapy emerging; - **Recurrent/metastatic** — pembrolizumab ± chemo (KEYNOTE-048), nivolumab (CheckMate 141), cetuximab combinations; (7) **Multidisciplinary head + neck tumor board**: ENT/head + neck surgery + medical oncology + radiation oncology + radiology (head + neck imaging + nuclear) + pathology + speech-language pathology + nutrition (often G-tube needed) + dental + nursing + survivorship + psychology + tobacco/alcohol cessation

---

HN cancer PET/CT: staging stage III-IV + RT planning + response + surveillance + unknown primary. MRI for local + brain. HPV-associated distinct biology + de-escalation trials. Multimodal treatment + HN tumor board including SLP + dental + nutrition.', NULL,
  'hard', 'hemato_onco', 'review',
  'radiology', 'clinical_decision', 'hemato_onco', 'adult',
  'NCCN Head + Neck Cancer; ACR Appropriateness', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'rad_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'radiology'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี + oropharyngeal squamous cell carcinoma — PET/CT for staging + treatment planning'
  );

commit;

