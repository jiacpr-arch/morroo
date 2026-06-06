-- ===============================================================
-- UPDATE chunk 2/8: radiology (25 questions)
-- ===============================================================

begin;

update public.mcq_questions
set choices = '[{"label":"A","text":"No technology"},{"label":"B","text":"Teleradiology + AI in Radiology"},{"label":"C","text":"Random"},{"label":"D","text":"Refuse"},{"label":"E","text":"Avoid technology"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Teleradiology + AI in Radiology: (1) **Teleradiology**: remote reading of imaging — expands access, after-hours coverage, subspecialty expertise; modern: most major imaging read across distances; (2) **PACS (Picture Archiving + Communication System) + RIS (Radiology Information System)**: digital workflow; integration with EMR; standardized; (3) **AI applications**: - **Triage**: prioritize urgent (intracranial hemorrhage, PE, pneumothorax); - **Detection**: lung nodules, breast lesions, fractures, hemorrhage, embolism; - **Quantification**: lesion measurement, organ volume, bone density, cardiac function; - **Image quality**: noise reduction, motion correction, reconstruction; - **Workflow**: protocoling, hanging protocols, structured reports; (4) **FDA-cleared AI applications growing** (> 500 + as of 2024); (5) **Limitations + concerns**: bias, generalizability, validation, regulatory, integration, training, liability, ethics; (6) **Human-AI collaboration**: AI augments not replaces radiologist; emphasis on subtle findings + workflow efficiency; (7) **Quality + validation**: prospective trials, real-world evidence, post-market surveillance; (8) **Education + training**: residents + practicing radiologists need familiarity; (9) **Patient-facing AI**: explanation, communication; (10) **Equity**: ensure benefits across populations + reduce disparities; (11) **Multidisciplinary**: radiology + IT + leadership + regulatory + patient; (12) **Modern**: AI transforming imaging — increased throughput, missed findings, structured + actionable reports

---

Teleradiology + AI: expanding access + capabilities. Multiple AI applications: triage, detection, quantification, workflow. FDA-cleared growing. Human-AI collaboration. Limitations: bias, validation, integration. Education + ethics. Modern: AI transforming radiology workflow.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'radiology'
  and scenario = 'Hospital implements teleradiology + AI in radiology';

update public.mcq_questions
set choices = '[{"label":"A","text":"Random"},{"label":"B","text":"Interventional Radiology (IR) — Image-Guided Minimally Invasive"},{"label":"C","text":"Random"},{"label":"D","text":"Avoid"},{"label":"E","text":"Refuse"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Interventional Radiology (IR) — Image-Guided Minimally Invasive: (1) **Scope**: image-guided diagnostic + therapeutic procedures; replacing many surgeries; (2) **Procedures**: - **Vascular**: angioplasty + stent (peripheral, renal, mesenteric, intracranial), embolization (GI bleeding, uterine fibroids — UFE, AVM, aneurysm coiling, varicocele, tumor — TACE for HCC, splenic artery for hypersplenism), thrombolysis (DVT, PE, stroke — mechanical thrombectomy), IVC filter, central venous access (PICC, port, CVC); - **Non-vascular**: percutaneous biopsy (US, CT-guided), drainage (abscess, biliary, urinary, ascites, pleural), ablation (RFA, microwave, cryo for tumors), vertebroplasty + kyphoplasty (compression fractures), nephrostomy, gastrostomy (PEG/PIG), feeding tubes, TIPS (portal HT), pain procedures (sympathetic blocks, RFA spine); - **Neurointerventional**: aneurysm coiling, AVM embolization, stroke mechanical thrombectomy, carotid stenting; (3) **Multidisciplinary**: IR + referring specialties (oncology, GI, urology, neurology, cardiology, surgery); (4) **Outcomes**: minimally invasive — less morbidity, faster recovery, shorter hospital stay vs open surgery; (5) **Specialization**: IR is a recognized specialty with fellowship training (or IR/DR pathway combined); (6) **Complications**: bleeding, infection, contrast nephropathy, vessel injury, organ injury; (7) **Patient + family education** + informed consent; (8) **Modern**: AI guidance, image fusion, robotic assistance, advanced imaging; (9) **Healthcare value**: cost-effective + improved patient experience

---

IR: image-guided minimally invasive — replacing many surgeries. Vascular + non-vascular + neurointerventional procedures. Multidisciplinary. Less morbidity + faster recovery. Recognized specialty. Modern: AI + robotics + advanced imaging. Cost-effective + improved patient experience.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'radiology'
  and scenario = 'Hospital implements interventional radiology + image-guided procedures expansion';

update public.mcq_questions
set choices = '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Integrative Imaging + IR for Advanced Cancer Care"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Refuse care"},{"label":"E","text":"Discharge"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Integrative Imaging + IR for Advanced Cancer Care: (1) **Multidisciplinary tumor board** coordinated approach; (2) **Diagnostic imaging**: staging (CT + PET + MRI), tumor response (RECIST, iRECIST for immunotherapy), surveillance for recurrence; (3) **Image-guided biopsy** for diagnosis + molecular characterization (precision medicine); (4) **Therapeutic IR options based on cancer type**: - Tumor embolization (HCC — TACE, UFE for fibroids — palliation, splenic for hypersplenism); - Ablation (RFA, MWA, cryo) for local control; - Y-90 radioembolization for liver metastases; - Pain procedures (celiac plexus block for pancreatic Ca pain, vertebroplasty for spine mets, peripheral nerve blocks); - Central venous access for chemo (port, PICC); - Biliary stenting for obstruction; - Nephrostomy for ureteral obstruction; - Drainage of effusions, ascites (PleurX catheter for recurrent); - Hemostatic procedures for bleeding (hemoptysis, GI bleed); (5) **Palliative imaging + IR**: focus on quality of life, symptom relief; (6) **Multidisciplinary palliative care** integrated; (7) **Cost-effectiveness**: minimally invasive often replaces more morbid surgery; (8) **Patient + family communication**: realistic expectations, decision-making, advance care planning; (9) **Quality of life metrics**: pain scores, functional, satisfaction; (10) **Long-term care**: ongoing imaging surveillance + IR procedures as needed + transitions to hospice when appropriate

---

Integrative imaging + IR for cancer care = multidisciplinary. Diagnostic + therapeutic. Many IR options for palliation + local control. Quality of life focus. Concurrent palliative care. Cost-effective. Modern: precision + minimally invasive + integrated care.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'radiology'
  and scenario = 'ผู้ป่วยอายุ 65 ปี advanced cancer + chronic pain + multiple complications — integrative imaging + IR care';

update public.mcq_questions
set choices = '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Complex Elderly Patient Integrative Imaging Care"},{"label":"C","text":"Refuse"},{"label":"D","text":"Always image"},{"label":"E","text":"Hospice"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Complex Elderly Patient Integrative Imaging Care: (1) **Goals of care discussion first** — imaging guided by what will change management + values + prognosis; (2) **Comprehensive geriatric assessment**: medical, functional, cognitive, psychosocial; (3) **Imaging selection considerations**: - Can patient tolerate (cooperation, claustrophobia, ability to lie still); - Will imaging change management (avoid imaging not changing care); - Risks of imaging (contrast, radiation, transportation, transition to new environment — confusion, falls); - Sedation needed (additional risk); - Alternatives (less invasive); (4) **Multidisciplinary**: primary care + geriatric medicine + specialists + radiology + nursing + family + palliative care; (5) **Shared decision-making**: patient (if cognitively able), family, surrogate; values + preferences; quality vs quantity of life; (6) **Common scenarios + considerations**: - New symptoms in advanced dementia — careful workup; - Falls — minimal vs full workup; - Acute change — DDx + workup; - Screening cancer — discontinuation often appropriate based on life expectancy; (7) **Imaging modifications**: low-dose protocols, alternatives (US > CT for some), sedation only if essential, mobile imaging when possible; (8) **Family communication**: explain rationale, alternatives, expectations; (9) **Modern**: integrated care + value-based + patient-centered + advance care planning + palliative care concurrent

---

Complex elderly imaging: goals-of-care-driven. CGA + multidisciplinary + shared decision-making. Image selection considers tolerability + will change management + risks + alternatives. Screening discontinuation appropriate based on life expectancy. Modifications for elderly. Family communication. Modern: patient-centered + value-based.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'radiology'
  and scenario = 'ผู้ป่วยอายุ 78 ปี multimorbid + dementia + functional decline + new symptoms — diagnostic + management complexity + multidisciplinary';

update public.mcq_questions
set choices = '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Chronic Pain — Integrative Diagnostic + IR + Multidisciplinary Care"},{"label":"C","text":"Long-term opioids"},{"label":"D","text":"Refuse"},{"label":"E","text":"Discharge"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Chronic Pain — Integrative Diagnostic + IR + Multidisciplinary Care: (1) **Diagnosis + characterization**: comprehensive imaging when needed (MRI for spine, joints; nerve imaging — high-resolution MR neurography or US); (2) **Multidisciplinary pain team**: pain medicine + IR + anesthesia + neurology + orthopedics + PT/OT + psychology + primary care; (3) **IR pain procedures**: - **Spine procedures**: epidural steroid injection (cervical, lumbar; transforaminal, interlaminar), medial branch blocks + RFA for facet pain, sacroiliac joint injections, vertebroplasty/kyphoplasty for compression fractures; - **Peripheral nerve blocks** (image-guided ultrasound or fluoroscopy): occipital nerve, intercostal, sciatic, etc.; - **Sympathetic blocks**: stellate ganglion (CRPS upper extremity), lumbar sympathetic (CRPS lower), celiac plexus (pancreatic cancer pain), superior hypogastric (pelvic pain); - **Joint injections** (US or fluoroscopic guidance): shoulder, hip, knee — corticosteroid, hyaluronic acid; - **Genicular nerve block + RFA** for knee OA pain; - **PRP, prolotherapy** for selected tendon/joint; (4) **Cognitive Behavioral Therapy** for chronic pain — evidence-based; (5) **Multimodal pharmacologic + non-pharmacologic** (per CDC pain guidelines 2022): - Acetaminophen + NSAID (topical preferred for localized); - SNRI (duloxetine) for chronic pain; - Anticonvulsants (gabapentinoids — caution misuse); - Avoid long-term opioids (epidemic, addiction, hyperalgesia); - Topical agents; - Acupuncture; - Mindfulness + meditation; (6) **Functional goals** over pain elimination; (7) **Mental health integration**: depression + anxiety + sleep + trauma history; (8) **Substance use screening**; (9) **Family + work support**: vocational rehabilitation, accommodations; (10) **Modern**: biopsychosocial + multidisciplinary + opioid-sparing + minimally invasive + functional focus

---

Chronic pain integrative care = multidisciplinary biopsychosocial. Imaging diagnosis. IR procedures (spine, peripheral nerves, sympathetic, joints). CBT + multimodal pharmacologic + non-pharmacologic. Avoid long-term opioids. Functional goals. Mental health integration. Modern: comprehensive opioid-sparing approach.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'radiology'
  and scenario = 'ผู้ป่วยอายุ 40 ปี chronic pain syndrome — multidisciplinary diagnostic + therapeutic IR + pain management';

update public.mcq_questions
set choices = '[{"label":"A","text":"Tension headache — discharge"},{"label":"B","text":"Acute intracerebral hemorrhage (ICH)"},{"label":"C","text":"Plain X-ray skull"},{"label":"D","text":"Lumbar puncture first"},{"label":"E","text":"Observation only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute intracerebral hemorrhage (ICH): (1) **CT findings**: hyperdense (50-80 HU) lesion — basal ganglia + thalamus typical hypertensive site; mass effect, midline shift, intraventricular extension (worse prognosis); (2) **Differential by location**: hypertensive (BG, thalamus, pons, cerebellum), amyloid angiopathy (lobar, elderly), AVM/aneurysm (atypical location), tumor (rim enhancement, edema disproportionate), hemorrhagic transformation of infarct; (3) **CTA** to evaluate underlying vascular lesion (spot sign predicts expansion); (4) **Management per AHA 2022 ICH guidelines**: BP control (SBP target 130-150 in INTERACT trials), reverse anticoagulation (PCC for warfarin, idarucizumab for dabigatran, andexanet for FXa-i), ICU admission, neurosurgery consult for cerebellar > 3 cm or hydrocephalus (EVD), supratentorial surgery limited role (MISTIE III — minimally invasive evacuation selected); (5) **ICH score** for prognosis (GCS, age, ICH volume, IVH, location)

---

Hyperdense BG lesion = hypertensive ICH. CTA to exclude vascular cause. AHA 2022: BP control, reverse anticoag, NSG for selected cerebellar/hydrocephalus. ICH score prognosis.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'radiology'
  and scenario = 'ผู้ป่วยอายุ 70 ปี acute severe headache + decreased consciousness + GCS 11 — CT พบ hyperdense lesion in right basal ganglia 4 cm with mass effect + intraventricular extension

คำถาม: diagnosis + immediate management';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge home"},{"label":"B","text":"Suspected SAH workup"},{"label":"C","text":"Repeat CT in 24 h"},{"label":"D","text":"MRI brain only"},{"label":"E","text":"Antibiotics empirically"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Suspected SAH workup: (1) **NCCT sensitivity** for SAH: ~ 100% within 6h of onset on modern scanner with neuroradiologist read (Perry 2011); drops to ~ 85% at 24h, ~ 50% at 1 week — blood becomes isodense; (2) **If CT negative but high clinical suspicion** → **lumbar puncture** — look for xanthochromia (yellow CSF from bilirubin, takes 12 h to develop — most reliable after 12h), elevated RBC count not decreasing from tube 1 → 4; (3) **CTA or MRA** for aneurysm detection after SAH confirmed (or as alternative to LP in selected — CTA-only protocols controversial); (4) **DSA** gold standard if CTA negative but high suspicion; (5) **Management of confirmed aneurysmal SAH**: securing aneurysm (clipping vs coiling — ISAT trial favored coiling for selected), nimodipine for vasospasm prevention, monitor for hydrocephalus, rebleed, vasospasm (TCD, CTA, DSA), DCI; Hunt-Hess + WFNS + Fisher scores for prognosis

---

Thunderclap HA + negative CT < 6h does NOT exclude SAH late; classic teaching = LP for xanthochromia. CTA to find aneurysm. Modern: CTA-only protocols emerging but LP still standard if > 6h.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'radiology'
  and scenario = 'ผู้ป่วยอายุ 45 ปี thunderclap headache (worst of life) + neck stiffness + photophobia — NCCT head 6 ชั่วโมงหลัง onset ปกติ

คำถาม: SAH workup next step';

update public.mcq_questions
set choices = '[{"label":"A","text":"No screening needed"},{"label":"B","text":"Aneurysm screening in ADPKD"},{"label":"C","text":"Annual CT head"},{"label":"D","text":"Plain skull X-ray"},{"label":"E","text":"Carotid US"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Aneurysm screening in ADPKD: (1) **Risk**: ADPKD has 4-10× general population risk of intracranial aneurysm (~ 9-12% prevalence vs ~ 2% general); (2) **ACR Appropriateness Criteria + AHA**: screening recommended if family history of aneurysm/SAH, prior SAH, high-risk occupation (pilot), pre-transplant; routine screening of all ADPKD controversial; (3) **Modality**: **MR angiography (MRA) — 3T preferred, time-of-flight (TOF), no contrast needed** — first-line, no radiation, no contrast; sensitivity ~ 90% for ≥ 3 mm; (4) **CTA** alternative — better spatial resolution, requires contrast + radiation; (5) **DSA** reserved for treatment planning or equivocal cases; (6) **Surveillance interval**: every 5-10 years if initial negative, sooner if family history; (7) **If aneurysm found**: size + location + PHASES score guides treatment (clipping, coiling, flow diverter, observation for small < 5 mm anterior circulation); (8) **Multidisciplinary**: nephrology + neurology + neurosurgery + neuro-IR

---

ADPKD: 4-10× aneurysm risk. MRA TOF first-line (no contrast/radiation). Screen if family history. Surveillance q5-10y. PHASES score for treatment. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'radiology'
  and scenario = 'ผู้ป่วยอายุ 35 ปี ADPKD (autosomal dominant polycystic kidney disease) + family history of SAH — screening for intracranial aneurysm';

update public.mcq_questions
set choices = '[{"label":"A","text":"Likely abscess — antibiotics"},{"label":"B","text":"Glioblastoma (GBM, WHO grade 4 astrocytoma)"},{"label":"C","text":"Migraine — discharge"},{"label":"D","text":"Stroke acute"},{"label":"E","text":"Multiple sclerosis"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Glioblastoma (GBM, WHO grade 4 astrocytoma): (1) **Imaging features**: heterogeneous T1 hypointense / T2-FLAIR hyperintense mass, ring/heterogeneous enhancement (necrosis), butterfly pattern across corpus callosum classic, marked surrounding vasogenic edema (T2-FLAIR — tumor cells extend BEYOND enhancement); (2) **Advanced MRI** distinguishes from mimics: MR spectroscopy (↑ choline, ↓ NAA, lactate peak), MR perfusion (↑ rCBV high-grade), DWI (variable), DTI for tract mapping pre-op; (3) **Differential**: high-grade glioma, lymphoma (homogeneous enhancement, less necrosis, DWI restriction, immunocompromised), metastasis (often multiple, gray-white junction, less edema-to-tumor mismatch), abscess (DWI restriction central — different from tumor necrosis), demyelinating tumefactive lesion (open ring); (4) **Workup**: contrast MRI + advanced sequences, neuro-oncology referral, multidisciplinary tumor board, stereotactic biopsy or maximal safe resection; (5) **Molecular**: IDH mutation, MGMT methylation, EGFR, 1p/19q — guide therapy + prognosis; (6) **Standard treatment**: maximal safe resection + concurrent chemoradiation (Stupp protocol — TMZ) + adjuvant TMZ + tumor-treating fields (TTF)

---

Butterfly GBM = heterogeneous enhancing mass crossing corpus callosum + vasogenic edema. MR spectroscopy + perfusion differentiate from lymphoma/mets/abscess. Stupp protocol standard. Modular molecular markers.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'radiology'
  and scenario = 'ผู้ป่วยอายุ 60 ปี progressive headache + seizure + right hemiparesis × 6 สัปดาห์ — MRI brain พบ heterogeneously enhancing mass in left frontal lobe with central necrosis + extensive vasogenic edema + crosses corpus callosum (butterfly pattern)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Likely benign"},{"label":"B","text":"MRI > CT"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Discharge"},{"label":"E","text":"Observation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Brain metastases: (1) **Imaging features**: multiple lesions (most common pattern, ~ 50% have multiple), gray-white matter junction (vascular supply terminates), ring or solid enhancement, vasogenic edema (out of proportion to tumor size — finger-like extension in white matter), hemorrhage common with melanoma/renal/thyroid/choriocarcinoma; (2) **Common primaries**: lung > breast > melanoma > renal > colorectal; (3) **MRI > CT** sensitivity — gadolinium + 3D thin-section, post-contrast T1, FLAIR; (4) **Differential**: GBM (typically single, butterfly), abscess (DWI restriction central), lymphoma, demyelination, radiation necrosis (in treated patients — MR perfusion + spectroscopy differentiate), septic emboli (peripheral location); (5) **Management**: (a) symptomatic — dexamethasone for edema, AEDs only if seizure (no prophylaxis); (b) systemic therapy with CNS-active agents (osimertinib for EGFR NSCLC, alectinib for ALK, trastuzumab/T-DM1 + tucatinib for HER2+ BC); (c) **SRS (stereotactic radiosurgery)** preferred up to 4-10 lesions (NCCTG N0574, JLGK0901); (d) **WBRT** for many lesions, leptomeningeal disease — but cognitive decline; hippocampal sparing + memantine; (e) **Surgery** for symptomatic single large, accessible, primary diagnosis needed; (6) **Multidisciplinary**: neuro-oncology + radiation oncology + neurosurgery + medical oncology

---

Brain mets: multiple ring-enhancing lesions at gray-white junction + edema. Lung > breast > melanoma. SRS preferred up to 4-10 lesions; WBRT for many. CNS-active systemic therapy. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'radiology'
  and scenario = 'ผู้ป่วยอายุ 65 ปี known lung adenocarcinoma + new headache + seizure — MRI brain พบ multiple ring-enhancing lesions at gray-white junctions + surrounding vasogenic edema';

update public.mcq_questions
set choices = '[{"label":"A","text":"Brain abscess"},{"label":"B","text":"Imaging features pathognomonic"},{"label":"C","text":"Glioblastoma"},{"label":"D","text":"Metastasis"},{"label":"E","text":"Stroke"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Meningioma: (1) **Imaging features pathognomonic**: extra-axial dural-based mass (broad dural base, CSF cleft sign separating from brain), homogeneous avid contrast enhancement, **dural tail** (enhancement extending along dura — present in ~ 60-70%, not pathognomonic but characteristic), calcification (15-20%), adjacent skull hyperostosis (psammomatous changes); (2) **MRI signal**: T1 iso to gray matter, T2 iso to hyperintense, diffusion restriction variable; (3) **Locations**: parasagittal/falcine (most common), convexity, sphenoid wing, olfactory groove, suprasellar, posterior fossa, intraventricular; (4) **Grading WHO 2021**: Grade 1 (benign ~ 80%), Grade 2 atypical (~ 15%), Grade 3 anaplastic/malignant (~ 5% — higher recurrence); (5) **Management**: (a) asymptomatic small typical → observation with serial MRI (low growth rate); (b) symptomatic or growing → surgery (Simpson grading of resection — extent predicts recurrence); (c) **SRS** for small (≤ 3 cm) or surgical residual; (d) RT for recurrent, residual, atypical/malignant; (e) hormonal management — progesterone receptor positive may grow in pregnancy; (6) **Multidisciplinary**: neurosurgery + radiation oncology + neuro-oncology

---

Meningioma: extra-axial dural-based + dural tail + calcification + hyperostosis. WHO grading 1-3. Surgery for symptomatic, SRS for small. Multidisciplinary. Pregnancy growth risk (PR+).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'radiology'
  and scenario = 'ผู้ป่วยอายุ 55 ปี chronic headache — MRI brain พบ extra-axial dural-based mass with homogeneous avid enhancement + dural tail + calcification + skull hyperostosis adjacent

คำถาม: most likely diagnosis + management';

update public.mcq_questions
set choices = '[{"label":"A","text":"Likely brain tumor — surgery first"},{"label":"B","text":"Pituitary macroadenoma (likely prolactinoma)"},{"label":"C","text":"Migraine — discharge"},{"label":"D","text":"Multiple sclerosis"},{"label":"E","text":"Stroke"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pituitary macroadenoma (likely prolactinoma): (1) **Imaging**: dedicated sellar MRI thin-section pre/post gadolinium — microadenoma (< 10 mm — hypoenhancing relative to normal gland on dynamic post-contrast) vs macroadenoma (≥ 10 mm — heterogeneous enhancement, suprasellar extension, chiasm compression — ''snowman'' configuration when notched by diaphragma sellae); (2) **Workup**: hormonal panel — prolactin, IGF-1 (GH excess — acromegaly), 8 AM cortisol + ACTH or 24h UFC (Cushing), TSH + FT4, LH/FSH/estradiol or testosterone; **hook effect** in very high prolactin (> 200,000) — dilute sample; (3) **Visual field** (formal perimetry) for chiasm compression; (4) **Differentials sellar/suprasellar mass**: pituitary adenoma (most common adult), craniopharyngioma (calcification + cystic — children + adults), Rathke cleft cyst, meningioma, germinoma (children, midline), aneurysm (CTA/MRA!), pituitary hyperplasia (pregnancy, primary hypothyroidism), lymphocytic hypophysitis (postpartum); (5) **Management**: (a) **prolactinoma** — dopamine agonist (cabergoline > bromocriptine) first-line even with chiasm compression — usually shrinks tumor; (b) **non-functioning + symptomatic** (visual loss, hypopituitarism) — transsphenoidal surgery; (c) **GH-secreting (acromegaly)** — surgery + somatostatin analog (octreotide, lanreotide, pasireotide) or pegvisomant; (d) **Cushing''s disease** — surgery, then medical (mifepristone, osilodrostat); (e) RT for residual/recurrent; (6) **Multidisciplinary**: endocrinology + neurosurgery + neuro-ophthalmology

---

Pituitary macroadenoma. Workup: hormonal panel (prolactin, IGF-1, cortisol, TSH) + visual field. Prolactinoma → cabergoline first-line. Other types → surgery. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'radiology'
  and scenario = 'หญิงอายุ 35 ปี amenorrhea + galactorrhea + bitemporal hemianopia — MRI พบ sellar/suprasellar mass 1.5 cm with homogeneous enhancement + chiasm compression

คำถาม: diagnosis + workup';

update public.mcq_questions
set choices = '[{"label":"A","text":"Stroke"},{"label":"B","text":"Vestibular schwannoma (acoustic neuroma)"},{"label":"C","text":"Migraine"},{"label":"D","text":"Discharge"},{"label":"E","text":"Likely benign — no workup"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Vestibular schwannoma (acoustic neuroma): (1) **Imaging gold standard**: MRI with gadolinium + high-resolution T2 CISS/FIESTA — avidly enhancing mass at CPA with intracanalicular component into IAC (''ice cream cone''); (2) **Differential CPA mass**: vestibular schwannoma (most common, ~ 80% of CPA tumors), meningioma (dural-based, dural tail, hyperostosis), epidermoid (DWI bright — restricted diffusion, T2 bright, non-enhancing), arachnoid cyst (CSF signal all sequences, non-enhancing), facial nerve schwannoma; (3) **Bilateral vestibular schwannoma** = pathognomonic for NF2 (genetic testing); (4) **Audiogram**: sensorineural hearing loss + speech discrimination disproportionately decreased; (5) **Management options based on size, growth, age, hearing status**: (a) **observation + serial MRI** for small (< 1.5 cm), elderly, slow-growing — many don''t grow; (b) **SRS (gamma knife, cyberknife)** for small-medium (< 3 cm) — preserves hearing better than surgery in many; (c) **microsurgery** (translabyrinthine, retrosigmoid, middle fossa approaches) for large, brainstem compression, young; goal — facial nerve preservation primary; (6) **Multidisciplinary**: neurosurgery + neurotology/ENT + radiation oncology + audiology; (7) **NF2 management**: bevacizumab for selected, complex multidisciplinary care

---

Vestibular schwannoma: CPA mass + intracanalicular component (''ice cream cone'') on MRI. Bilateral = NF2. Options: observation, SRS, microsurgery. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'radiology'
  and scenario = 'ผู้ป่วยอายุ 50 ปี unilateral sensorineural hearing loss + tinnitus + imbalance × 2 ปี — MRI พบ enhancing mass in cerebellopontine angle (CPA) extending into internal auditory canal (ice cream cone appearance)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Stroke"},{"label":"B","text":"Multiple sclerosis — McDonald 2017 criteria (revised 2024)"},{"label":"C","text":"Migraine — discharge"},{"label":"D","text":"Brain tumor"},{"label":"E","text":"Discharge — observation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Multiple sclerosis — McDonald 2017 criteria (revised 2024): (1) **MRI is gold standard for diagnosis**: typical lesions — ovoid T2/FLAIR hyperintense; classic locations — periventricular (Dawson fingers perpendicular to ventricles), juxtacortical/cortical, infratentorial (brainstem, cerebellum), spinal cord (cervical > thoracic, < 2 vertebral segments, partial cross-section); (2) **Active vs chronic**: enhancing lesion (active inflammation, BBB breakdown — gadolinium), T2 lesion without enhancement (chronic), black holes T1 (axonal loss); (3) **McDonald 2017 Criteria**: dissemination in space (DIS) — ≥ 1 T2 lesion in ≥ 2 of 4 typical locations (periventricular, cortical/juxtacortical, infratentorial, spinal cord); + dissemination in time (DIT) — new T2 or enhancing lesion on follow-up scan OR simultaneous enhancing + non-enhancing lesions on single scan; (4) **CSF**: oligoclonal bands (substitute for DIT in 2017 criteria), elevated IgG index; (5) **Differential**: NMOSD (longitudinally extensive transverse myelitis > 3 segments, optic neuritis, AQP4 ab), MOGAD (MOG ab), ADEM (monophasic, post-infectious), small vessel ischemic (older, vascular risk factors), neurosarcoidosis, vasculitis, Susac, CADASIL; (6) **Management**: high-efficacy DMTs early (ocrelizumab, ofatumumab, natalizumab, S1P modulators) — paradigm shift toward early aggressive treatment; (7) **Multidisciplinary MS care**: neurology + MS specialist + radiology + PT/OT + urology + mental health

---

MS = MRI + McDonald 2017 (DIS + DIT). Periventricular Dawson fingers, juxtacortical, infratentorial, spinal cord. Oligoclonal bands substitute DIT. Differential NMOSD/MOGAD/ADEM. Early high-efficacy DMT.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'radiology'
  and scenario = 'หญิงอายุ 28 ปี episodes of visual loss + paresthesia + ataxia separated in time — MRI พบ multiple ovoid T2/FLAIR hyperintense lesions perpendicular to ventricles (Dawson fingers) + some enhancing

คำถาม: imaging diagnosis MS';

update public.mcq_questions
set choices = '[{"label":"A","text":"MS — start interferon"},{"label":"B","text":"Neuromyelitis optica spectrum disorder (NMOSD)"},{"label":"C","text":"Stroke"},{"label":"D","text":"Migraine"},{"label":"E","text":"Discharge"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neuromyelitis optica spectrum disorder (NMOSD): (1) **Hallmark imaging**: longitudinally extensive transverse myelitis (LETM, ≥ 3 contiguous vertebral segments) — central cord T2 hyperintense, enhancement, atypical for MS (MS lesions < 2 segments, partial cross-section); optic neuritis often bilateral or chiasmal involvement (severe vs MS); area postrema lesion (intractable hiccups/vomiting); brain lesions if any are atypical for MS — diencephalic, periependymal; (2) **Serology**: AQP4-IgG antibody — pathognomonic when positive (specificity > 99%), positive in ~ 75% of NMOSD; AQP4-negative NMOSD — some have MOG-IgG (MOGAD — overlap but distinct entity); (3) **Wingerchuk 2015 criteria** for NMOSD: AQP4-positive + 1 core clinical characteristic (optic neuritis, LETM, area postrema, brainstem, narcolepsy/diencephalic, cerebral with NMOSD-typical MRI lesions); AQP4-negative requires ≥ 2 core clinical characteristics + more stringent MRI criteria; (4) **Treatment**: acute relapse — high-dose methylprednisolone + plasmapheresis for severe; (5) **Prevention** — disease modifying therapy in NMOSD distinct from MS (some MS DMTs WORSEN NMOSD — e.g., interferon, fingolimod, natalizumab): - **Eculizumab** (anti-C5) approved AQP4+; - **Inebilizumab** (anti-CD19); - **Satralizumab** (anti-IL-6R); - Off-label: rituximab, azathioprine, mycophenolate; (6) **Multidisciplinary**: neurology (neuroimmunology) + ophthalmology + PT/OT + urology

---

NMOSD: LETM ≥ 3 segments + optic neuritis + AQP4-IgG. Wingerchuk criteria. CRITICAL: MS DMTs (interferon, fingolimod, natalizumab) WORSEN NMOSD. Treat with eculizumab/inebilizumab/satralizumab/rituximab.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'radiology'
  and scenario = 'หญิงอายุ 40 ปี bilateral optic neuritis + longitudinally extensive transverse myelitis > 3 vertebral segments — MRI spine T2 hyperintense central cord lesion spanning C2-C7

คำถาม: diagnosis suspected';

update public.mcq_questions
set choices = '[{"label":"A","text":"Alzheimer disease"},{"label":"B","text":"Normal pressure hydrocephalus (NPH) — Hakim triad"},{"label":"C","text":"Migraine"},{"label":"D","text":"Discharge"},{"label":"E","text":"Single specialty"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Normal pressure hydrocephalus (NPH) — Hakim triad: (1) **Clinical triad** (often incomplete): gait apraxia (magnetic gait, broad-based, shuffling — most responsive feature), urinary incontinence, cognitive decline (subcortical pattern); (2) **Imaging features (iNPH)**: ventriculomegaly out of proportion to atrophy — Evans index ≥ 0.30 (max width frontal horns / max biparietal diameter); callosal angle (coronal at posterior commissure) < 90° (NPH) vs > 90° (atrophy); DESH pattern (disproportionately enlarged subarachnoid spaces hydrocephalus) — tight high convexity + dilated Sylvian fissures (specific for iNPH); CSF flow void aqueduct; (3) **Workup**: high-volume LP (tap test — 30-50 mL CSF removed, gait/cognition tested before + after — improvement suggests responsive); external lumbar drainage (3-5 days, more sensitive); CSF pressure measurement (normal — by definition); (4) **Differentials**: Alzheimer (cortical atrophy disproportionate), vascular dementia, Lewy body, PSP, normal pressure hydrocephalus secondary (post-SAH, post-meningitis, post-traumatic); (5) **Treatment**: ventriculoperitoneal shunt (programmable valve) for responders — gait improves most predictably, cognition less so; (6) **Multidisciplinary**: neurology + neurosurgery + neuropsychology + PT/OT + urology

---

NPH: triad gait/incontinence/cognitive + ventriculomegaly disproportionate (Evans ≥ 0.30, callosal angle < 90°, DESH). Tap test + ELD predict shunt response. VP shunt for responders. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'radiology'
  and scenario = 'ผู้ป่วยอายุ 75 ปี progressive gait disturbance (magnetic gait) + urinary incontinence + cognitive decline × 1 ปี — MRI brain พบ ventriculomegaly disproportionate to sulcal atrophy + Evans index 0.35

คำถาม: diagnosis + workup';

update public.mcq_questions
set choices = '[{"label":"A","text":"Likely toxoplasmosis only — empiric treatment"},{"label":"B","text":"Primary CNS lymphoma (PCNSL)"},{"label":"C","text":"Stroke"},{"label":"D","text":"Migraine"},{"label":"E","text":"Discharge"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Primary CNS lymphoma (PCNSL): (1) **Imaging features**: periventricular + deep gray location (basal ganglia, thalami, corpus callosum), subependymal spread (highly characteristic), homogeneous enhancement (vs ring/heterogeneous in GBM/abscess/mets), restricted diffusion (high cellularity — DWI bright, ADC dark); less edema-to-tumor mismatch than GBM; (2) **In immunocompromised** (HIV, transplant, immunosuppressed) — often more heterogeneous, may have necrosis (less typical than immunocompetent); (3) **Differential in HIV with brain lesions**: toxoplasmosis (most common — ring-enhancing, eccentric target sign, basal ganglia, multiple, no DWI restriction usually), PCNSL (single or few, periventricular, DWI restricted, subependymal), PML (T2 hyperintense, subcortical white matter, NO enhancement, JC virus), tuberculoma (ring-enhancing, basal cisterns/meningitis), cryptococcoma; (4) **Workup**: contrast MRI + advanced (perfusion — low rCBV PCNSL vs high GBM; spectroscopy — high choline, lipid-lactate), FDG-PET (hypermetabolic PCNSL vs hypometabolic toxo), CSF analysis (EBV PCR positive in HIV-PCNSL, flow cytometry, cytology — limited sensitivity), serum LDH, slit-lamp eye exam for ocular involvement; (5) **Avoid steroids before biopsy** if possible — can cause rapid lymphoma regression and obscure diagnosis; (6) **Treatment**: HD-MTX-based polychemotherapy (rituximab, temozolomide, MATRIX/Bonn regimens); consolidation with autologous SCT or WBRT in selected; cART for HIV-PCNSL; (7) **Multidisciplinary**: hematology + neuro-oncology + ID (HIV) + radiation oncology + neurosurgery

---

PCNSL in HIV: periventricular + subependymal + DWI restriction + homogeneous enhancement. Differential vs toxoplasmosis/PML/TB. AVOID empiric steroids. HD-MTX + rituximab. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'radiology'
  and scenario = 'ผู้ป่วยอายุ 55 ปี HIV+ CD4 50 + multiple focal neurological deficits — MRI brain พบ multiple periventricular + deep gray homogeneously enhancing lesions with restricted diffusion + subependymal spread';

update public.mcq_questions
set choices = '[{"label":"A","text":"Conservative care"},{"label":"B","text":"Metastatic spinal cord compression (MSCC) — oncologic emergency"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Discharge"},{"label":"E","text":"Outpatient follow-up"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Metastatic spinal cord compression (MSCC) — oncologic emergency: (1) **Imaging**: **whole spine MRI** (gadolinium not strictly required) is gold standard — entire vertebral column imaged (multiple levels of involvement common, may change radiation field); shows epidural mass + cord compression + edema (T2 hyperintensity) + level of block; STIR sensitive for vertebral marrow disease; (2) **CT myelogram** alternative if MRI contraindicated; CT for bone detail + planning instrumentation; (3) **Plain X-ray** insensitive (50% bone loss needed) — not adequate; (4) **Common primaries**: prostate, breast, lung, RCC, multiple myeloma; (5) **Diagnosis + management urgent — within hours not days**: (a) **High-dose dexamethasone immediately** (10 mg IV bolus + 4-16 mg q6h) — start before imaging if high clinical suspicion; (b) **Urgent surgical consultation** — laminectomy + tumor debulking + instrumentation (Patchell 2005 RCT showed surgery + RT > RT alone for selected — single level, ambulatory, life expectancy > 3 months, radioresistant); (c) **Urgent radiotherapy** — 8 Gy × 1 or 30 Gy / 10 fractions; SBRT for selected; (d) **Systemic therapy** for radio-sensitive (lymphoma, germ cell, small cell); (e) **Ambulation status at presentation = strongest predictor** of post-treatment ambulation — DO NOT DELAY; (6) **Multidisciplinary** — radiation oncology + neurosurgery/spine + medical oncology + radiology + PT/OT + palliative care + urology; (7) **Bisphosphonates / denosumab** for prevention

---

MSCC = oncologic emergency. Whole spine MRI gold standard. IMMEDIATE dexamethasone + urgent surgery/RT consultation. Ambulation at presentation strongest predictor of outcome. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'radiology'
  and scenario = 'ผู้ป่วยอายุ 60 ปี known prostate cancer + acute lower back pain + urinary retention + bilateral leg weakness × 24 hr — MRI spine พบ T9-T10 epidural mass compressing cord with T2 hyperintensity (cord edema)

คำถาม: diagnosis + management';

update public.mcq_questions
set choices = '[{"label":"A","text":"Always image with X-ray"},{"label":"B","text":"Cervical spine clearance — Canadian C-Spine + NEXUS criteria"},{"label":"C","text":"Always do MRI"},{"label":"D","text":"X-ray plain only sufficient"},{"label":"E","text":"Bone scan"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cervical spine clearance — Canadian C-Spine + NEXUS criteria: (1) **NEXUS criteria** (low-risk — no imaging needed if ALL met): no posterior midline tenderness, no focal neurological deficit, normal alertness, no intoxication, no distracting injury; (2) **Canadian C-Spine Rule** (more sensitive in trials — Stiell): - **High-risk factors** mandate imaging: age ≥ 65, dangerous mechanism (fall > 3 ft / 5 stairs, axial load, MVC > 100 km/h, rollover, ejection, bicycle struck), paresthesias in extremities; - If NO high-risk → check **low-risk** allowing safe range of motion assessment: simple rear-end MVC, sitting position in ED, ambulatory at any time, delayed onset of neck pain, absence of midline tenderness; - If any low-risk feature → assess **45° rotation L+R** — if able → no imaging; if unable → image; (3) **Modality choice**: **CT cervical spine** if imaging indicated — replaces plain films (much higher sensitivity > 98%, plain X-ray ~ 50%); MRI for cord/ligamentous injury suspected (neuro deficit, persistent pain with normal CT); (4) **In obtunded patients** — protocol varies, CT alone often sufficient in modern era; MRI controversial; (5) **Pediatric considerations** — flexion injuries higher in young children, SCIWORA (spinal cord injury without radiographic abnormality), use PECARN-style validated rules + lower threshold for MRI; (6) **Documentation** of clinical clearance + decision rationale critical

---

C-spine clearance: NEXUS or Canadian C-Spine Rule. CT (not X-ray) if imaging needed. MRI for cord/ligamentous. Pediatric SCIWORA consideration.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'radiology'
  and scenario = 'ผู้ป่วยอายุ 30 ปี MVC + neck pain + GCS 15 + no neuro deficit + no distracting injury + no intoxication

คำถาม: cervical spine imaging decision';

update public.mcq_questions
set choices = '[{"label":"A","text":"Always image acutely"},{"label":"B","text":"Lumbar disc herniation with radiculopathy + neuro deficit — MRI indicated"},{"label":"C","text":"Surgery without imaging"},{"label":"D","text":"X-ray only"},{"label":"E","text":"Discharge"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Lumbar disc herniation with radiculopathy + neuro deficit — MRI indicated: (1) **ACR Appropriateness Criteria — low back pain**: routine imaging NOT indicated in acute non-specific LBP < 6 weeks WITHOUT red flags (Choosing Wisely); (2) **Red flags** mandating imaging: progressive neuro deficit, suspected cauda equina (saddle anesthesia, bladder/bowel dysfunction), suspected malignancy (history of cancer, weight loss, age > 50, night pain), suspected infection (fever, IVDU, immunocompromised), suspected fracture (trauma, osteoporosis, steroid use), failed conservative therapy > 4-6 weeks with persistent radiculopathy + neuro deficit (this patient); (3) **MRI lumbar spine — modality of choice**: T1/T2 sagittal + axial; STIR for edema; gadolinium for post-op (scar vs recurrent disc), infection, tumor; (4) **Findings**: disc bulge vs herniation (protrusion < extrusion < sequestered), location (central, paracentral, foraminal, far lateral — predicts which nerve compressed), level, modic changes (endplate edema/sclerosis suggests degenerative), facet arthropathy, stenosis (central, lateral recess, foraminal); (5) **Management**: continued conservative if symptoms tolerable (PT, NSAIDs, neuropathic agents); epidural steroid injection (transforaminal more targeted) for refractory; surgery (microdiscectomy) for: progressive neuro deficit, cauda equina (emergency), severe persistent pain failing conservative; (6) **Multidisciplinary**: PCP + PT + pain medicine + spine surgery + IR

---

LBP imaging: NOT needed acutely without red flags. MRI for red flags or failed conservative + neuro deficit. ACR Appropriateness + Choosing Wisely. Surgery for cauda equina/progressive deficit/refractory.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'radiology'
  and scenario = 'ผู้ป่วยอายุ 45 ปี chronic low back pain + radicular pain left leg in L5 distribution + foot drop weakness × 2 สัปดาห์ — failed conservative therapy 6 สัปดาห์';

update public.mcq_questions
set choices = '[{"label":"A","text":"Conservative management"},{"label":"B","text":"Cauda equina syndrome — surgical emergency"},{"label":"C","text":"Outpatient MRI in 1 week"},{"label":"D","text":"Discharge with NSAIDs"},{"label":"E","text":"Single specialty"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cauda equina syndrome — surgical emergency: (1) **Classic features**: severe low back pain + bilateral leg weakness/numbness + saddle (perineal) anesthesia + urinary retention (overflow incontinence) or fecal incontinence + decreased rectal tone + sexual dysfunction; (2) **Etiology**: massive central disc herniation (most common), epidural hematoma (post-procedure, anticoagulants), epidural abscess (fever, IVDU, immunocompromised), tumor/metastases, trauma, severe stenosis; (3) **EMERGENT MRI lumbar spine** — must be obtained urgently (CT myelogram if MRI contraindicated); time to decompression linked to outcomes (within 24-48h, ideally < 24h); (4) **Findings**: compression of cauda equina nerve roots at level of lesion; (5) **Management**: (a) emergent neurosurgical/orthopedic spine consultation; (b) emergent decompressive surgery (laminectomy + discectomy or abscess drainage); (c) high-dose dexamethasone for tumor/abscess while preparing for OR; (d) antibiotics if abscess + culture-directed; (e) Foley catheter, monitor neuro; (6) **Outcome**: incomplete syndrome (preserved sensation, no incontinence) better outcomes than complete; bladder dysfunction may be incomplete recovery even with prompt surgery; (7) **Documentation**: clinical exam findings (post-void residual, rectal tone, perineal sensation) + imaging + time of surgery — medicolegal high-risk; (8) **Multidisciplinary**: ED + spine surgery + radiology + anesthesia + urology + PT/OT

---

Cauda equina = surgical emergency. Bilateral leg sx + saddle anesthesia + urinary retention. EMERGENT MRI + surgery within 24-48h. Multidisciplinary. Medicolegal high-risk — document exam.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'radiology'
  and scenario = 'ผู้ป่วยอายุ 55 ปี acute severe low back pain + bilateral leg weakness + urinary retention + saddle anesthesia × 8 ชั่วโมง';

update public.mcq_questions
set choices = '[{"label":"A","text":"No imaging"},{"label":"B","text":"Carotid imaging for stroke/TIA workup"},{"label":"C","text":"Bone scan"},{"label":"D","text":"Skull X-ray"},{"label":"E","text":"PET scan"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Carotid imaging for stroke/TIA workup: (1) **Carotid duplex US (CDUS) — first-line screening**: no radiation, no contrast, widely available, evaluates plaque morphology + degree of stenosis via velocity criteria (peak systolic velocity); limitations — operator-dependent, calcified plaque shadowing, tandem lesions, distal/intracranial vessels not assessed; (2) **CT angiography (CTA) head + neck**: high spatial resolution, evaluates aortic arch + cervical + intracranial vessels (whole pathway), excellent for stenosis + plaque calcification + occlusion; iodinated contrast — caution CKD; radiation; (3) **MR angiography (MRA)**: TOF (no contrast — but tends to overestimate stenosis, especially turbulent flow), contrast-enhanced MRA (gadolinium, more accurate); no radiation; longer; (4) **DSA**: gold standard but invasive (small stroke risk) — reserved for treatment planning, equivocal imaging; (5) **Severity quantification** by NASCET method (% stenosis based on residual vs distal normal lumen); (6) **Management based on severity + symptoms**: - **Symptomatic 70-99% stenosis** → carotid endarterectomy (CEA) within 14 days ideal (NASCET, ECST) OR carotid artery stenting (CAS) for selected (high surgical risk); - **Symptomatic 50-69%** → CEA reasonable if low surgical risk + early after event; - **Asymptomatic 60-99%** → benefit smaller with modern medical therapy (CREST-2 ongoing) — individualized; (7) **Medical therapy in ALL**: antiplatelet (aspirin or clopidogrel), high-intensity statin, BP control, DM control, smoking cessation — modern medical therapy reduces benefit of revascularization in asymptomatic; (8) **Multidisciplinary**: stroke neurology + vascular surgery + IR + radiology

---

Carotid imaging: CDUS first-line; CTA most comprehensive; MRA no radiation; DSA gold standard. CEA for symptomatic 70-99% (or 50-69% selected). Modern medical therapy reduces revasc benefit in asymptomatic.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'radiology'
  and scenario = 'ผู้ป่วยอายุ 70 ปี recent TIA — workup for source of stroke including carotid evaluation

คำถาม: carotid imaging modality choice';

update public.mcq_questions
set choices = '[{"label":"A","text":"Migraine — discharge"},{"label":"B","text":"Carotid dissection — high clinical suspicion warrants vascular imaging"},{"label":"C","text":"Likely viral"},{"label":"D","text":"Stroke alone — no further workup"},{"label":"E","text":"Discharge"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Carotid dissection — high clinical suspicion warrants vascular imaging: (1) **Clinical features**: ipsilateral neck/face/head pain, ipsilateral Horner syndrome (sympathetic plexus on carotid), cranial nerve palsies (IX-XII near carotid), pulsatile tinnitus, TIA/stroke (embolic distally) — delayed up to days/weeks; (2) **Risk factors**: trauma (MVC, neck manipulation — chiropractic, hyperextension), connective tissue disease (Ehlers-Danlos, Marfan, fibromuscular dysplasia), spontaneous; (3) **Imaging**: - **CTA neck** — first-line in trauma: stenosis (string sign), occlusion, pseudoaneurysm, intimal flap, intramural hematoma (eccentric crescent narrowing lumen); - **MRA neck + fat-suppressed T1 axial neck** — sensitive for intramural hematoma (crescent of T1 hyperintense methemoglobin in vessel wall); MRA without fat sat misses it; - **DSA** for treatment planning or equivocal; (4) **Vertebral artery dissection** similar — posterior circulation symptoms; (5) **Management**: - **Antithrombotic** — antiplatelet (aspirin) vs anticoagulation (warfarin/DOAC) — CADISS RCT showed equivalent for stroke prevention; antiplatelet generally preferred; - Treat for 3-6 months then reimage — most dissections heal; - **Endovascular** for failure of medical, expanding pseudoaneurysm, hemodynamic compromise; - **Surgery** rarely; (6) **Avoid IV tPA** if dissection with intracranial extension (risk extension); (7) **Multidisciplinary**: stroke neurology + vascular surgery + neuro-IR

---

Carotid dissection: post-trauma + Horner + delayed stroke. CTA or MRA + fat-sat T1 (crescent intramural hematoma). Antiplatelet vs anticoag (CADISS — equivalent). 3-6 months treatment + reimage. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'radiology'
  and scenario = 'ผู้ป่วยอายุ 35 ปี post-MVC + neck pain + ipsilateral Horner syndrome + contralateral hemiparesis × 6 ชั่วโมง — MRI brain พบ no acute infarct yet';

update public.mcq_questions
set choices = '[{"label":"A","text":"Migraine — discharge"},{"label":"B","text":"Cerebral venous sinus thrombosis (CVST)"},{"label":"C","text":"Stroke arterial — tPA"},{"label":"D","text":"Tumor"},{"label":"E","text":"Discharge"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cerebral venous sinus thrombosis (CVST): (1) **Risk factors**: pregnancy/postpartum (hypercoagulable), OCPs, thrombophilia (Factor V Leiden, prothrombin, antiphospholipid, protein C/S deficiency, antithrombin deficiency), dehydration, malignancy, infection (mastoiditis, sinusitis — dural sinus thrombosis), trauma, IBD, recent COVID/vaccine; (2) **Clinical**: headache (most common, may be only symptom — DDx of post-LP headache, etc.), seizures, focal deficits (depending on infarct territory — often venous infarct doesn''t follow arterial distribution), papilledema, encephalopathy; (3) **Imaging**: - **NCCT** — hyperdense thrombus in sinus (cord sign, dense triangle); often normal; - **CT venography (CTV) or MR venography (MRV)** — gold standard non-invasive: filling defect, lack of opacification, empty delta sign on contrast CT (post-contrast triangle around sagittal sinus clot); - **MRI brain** — T2 hyperintense parenchymal lesions (vasogenic + cytotoxic edema mixed), hemorrhagic transformation, in non-arterial distribution; - **DSA** rarely needed; (4) **Management** (AHA 2011 + 2024 Statement): - **Anticoagulation** — heparin (LMWH preferred or UFH) acutely, then transition to warfarin or DOAC × 3-12 months (depending on cause); pregnancy — LMWH; - Even if hemorrhagic transformation — still anticoagulate (paradox — bleeding due to congestion improves with restoration of venous drainage); - Endovascular thrombectomy for deterioration despite anticoag (TO-ACT trial — not superior, but selected cases); - Decompressive craniectomy for malignant edema; - Treat underlying cause; (5) **Multidisciplinary**: neurology + hematology + neurosurgery + OB if peripartum

---

CVST in postpartum: headache + seizure + papilledema + filling defect on MRV. Anticoagulate even if hemorrhagic transformation. Treat 3-12 months + underlying cause. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'radiology'
  and scenario = 'หญิงอายุ 30 ปี postpartum 2 สัปดาห์ + severe headache + seizure + papilledema — MRI พบ T2 hyperintensity in bilateral parasagittal regions + MRV พบ filling defect in superior sagittal sinus

คำถาม: diagnosis + management';

update public.mcq_questions
set choices = '[{"label":"A","text":"Likely tumor — biopsy"},{"label":"B","text":"Brain arteriovenous malformation (AVM)"},{"label":"C","text":"Conservative"},{"label":"D","text":"Single specialty"},{"label":"E","text":"Discharge"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Brain arteriovenous malformation (AVM): (1) **Imaging features**: nidus (tangle of dysplastic vessels), enlarged feeding arteries, early draining vein (high flow), often surrounding gliosis; (2) **Modalities**: - CT may show calcifications, hemorrhage; - CTA/MRA — first-line non-invasive; - **DSA — gold standard** — defines feeding arteries, nidus, draining veins, aneurysms (intranidal — high rebleed risk); - MRI to evaluate parenchymal changes + relationship to eloquent cortex; (3) **Presentation**: hemorrhage (most common — 50%, lobar in young), seizures, headache, focal neurologic deficit, incidental; **risk of hemorrhage** ~ 2-4%/year (cumulative — higher with prior bleed, deep location, exclusive deep venous drainage, associated aneurysm); (4) **Spetzler-Martin grading** (size, eloquence, venous drainage) for surgical risk; (5) **Management options** (multimodal — individualized by SM grade + age + symptoms): - **Microsurgical resection** for accessible low-grade; - **Stereotactic radiosurgery** for small (< 3 cm) deep/eloquent (gamma knife — obliteration over 2-3 years, latency period bleed risk); - **Endovascular embolization** — adjunct before surgery/SRS or curative for selected; - **Observation** for unruptured high-grade (ARUBA RCT — controversial — showed observation better than intervention for unruptured at 33 months, but longer-term follow-up needed); (6) **Ruptured AVM** — secure the AVM (vs unruptured ARUBA controversy not applicable to ruptured); (7) **Multidisciplinary**: neurosurgery + neuro-IR + radiation oncology + radiology + neurology

---

AVM: nidus + feeders + early draining vein. DSA gold standard. SM grading. Multimodal treatment (surgery, SRS, embolization). ARUBA — observation may be appropriate for unruptured. Ruptured = treat. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'radiology'
  and scenario = 'ผู้ป่วยอายุ 25 ปี ICH lobar — angiography เพื่อหา etiology พบ tangle of abnormal vessels with feeding arteries from MCA + early draining vein';

commit;
