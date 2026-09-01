-- ===============================================================
-- UPDATE chunk 2/8: internal_medicine (25 questions)
-- ===============================================================

begin;

update public.mcq_questions
set choices = '[{"label":"A","text":"Restrict all broad-spectrum antibiotics for use only by infectious disease physicians"},{"label":"B","text":"CDC Core Elements of Hospital ASPs"},{"label":"C","text":"Same antibiotic protocol regardless of unit"},{"label":"D","text":"Avoid culture-guided therapy"},{"label":"E","text":"Empirical broad-spectrum for all febrile patients"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** CDC Core Elements of Hospital ASPs: (1) Leadership commitment + dedicated resources (2) Accountability — physician leader (3) Pharmacy expertise — pharmacist leader (4) Action — interventions: (a) prospective audit + feedback (b) formulary restriction + pre-authorization (c) facility-specific treatment recommendations (5) Tracking — metrics: antibiotic use (days of therapy/DOT), C. difficile rates, resistance (6) Reporting — feedback to providers (7) Education; Specific interventions: IV-to-PO switch + de-escalation based on culture + duration optimization (avoiding overlong therapy)

---

Antimicrobial Stewardship Program (ASP) — coordinated interventions to optimize antimicrobial use Goals: 1. Improve patient outcomes 2. Reduce antimicrobial resistance 3. Reduce antibiotic-related adverse events (C. difficile, drug toxicity) 4. Reduce healthcare costs CDC Core Elements (2014, updated 2019) — required by Joint Commission accreditation: 1. **Leadership commitment**: senior leadership support, dedicated time/funding/staff 2. **Accountability**: appoint a single leader (typically physician) responsible for outcomes 3. **Pharmacy expertise**: appoint single pharmacist leader 4. **Action** (interventions): - **Prospective audit and feedback** (most effective): ID/pharmacist reviews ongoing prescriptions, recommends changes - **Formulary restriction + pre-authorization**: restricted drugs require approval - **Facility-specific guidelines** based on local antibiogram - **IV-to-PO conversion** when patient tolerates oral - **De-escalation** based on culture results (narrow spectrum) - **Duration optimization** — avoid overlong courses (e.g., uncomplicated CAP 5 days, uncomplicated pyelonephritis 7-14 days, uncomplicated SSTI 5-7 days) - **Rapid diagnostics + biomarker-guided** (procalcitonin in pneumonia) 5. **Tracking** (metrics): - Antibiotic use: Days of Therapy (DOT) per 1000 patient-days; Standardized Antimicrobial Administration Ratio (SAAR) - Resistance: institutional antibiogram updated annually - Outcomes: C. difficile rate, mortality, LOS 6. **Reporting**: regular feedback to prescribers, leadership 7. **Education**: providers, nurses, pharmacists, patients Evidence: - 30-40% antibiotic use is inappropriate (CDC) - ASP reduces antibiotic use ~ 20%, resistance, C. difficile, cost - Joint Commission requires ASP for hospital accreditation since 2017 IDSA/SHEA 2016 guideline endorses these strategies WHO Global Action Plan on AMR + Thailand''s National Strategic Plan on AMR alignment — ตัวเลือก B comprehensive. A ผิด — pure restriction without other elements insufficient + creates conflict. C ผิด — facility-unit-specific guidelines preferred. D ผิดอย่างยิ่ง — culture-guided therapy is cornerstone. E ผิดอย่างยิ่ง — opposite of stewardship'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'โรงพยาบาลพบว่ามีการใช้ broad-spectrum antibiotics สูงและ resistance rates เพิ่มขึ้น ผู้บริหารตั้ง Antimicrobial Stewardship Program (ASP) นำโดยทีม ID + clinical pharmacist

คำถาม: ASP "core elements" ตาม CDC + IDSA/SHEA 2016 ที่ควรมีในทุก hospital-based ASP';

update public.mcq_questions
set choices = '[{"label":"A","text":"หยุดทุกยาทันที"},{"label":"B","text":"Apply Beers Criteria + STOPP/START + geriatric assessment: high-risk medications for falls and adverse events in elderly include —"},{"label":"C","text":"Add more medications to control symptoms"},{"label":"D","text":"Continue all medications unchanged"},{"label":"E","text":"Stop only statins (low benefit in elderly)"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Apply Beers Criteria + STOPP/START + geriatric assessment: high-risk medications for falls and adverse events in elderly include — (1) **Alprazolam (benzodiazepine)** — Beers Criteria avoid in elderly (increased fall, fracture, cognitive impairment risk); taper slowly (2) **Paroxetine** — strongly anticholinergic, avoid in elderly per Beers; consider switch to sertraline or escitalopram (3) **Tamsulosin + amlodipine + diuretic + ACEi** combo → orthostatic hypotension; check standing BP, consider de-prescribing (4) **Glipizide** — sulfonylurea, hypoglycemia risk in elderly + CKD; consider switch to DPP-4 inhibitor or metformin alone (5) **Donepezil** — review indication and risk/benefit (6) **PPI long-term** — review indication; risks fracture, C. difficile, B12 deficiency; deprescribe if no clear indication; comprehensive geriatric assessment (CGA) + medication reconciliation + functional + cognitive + nutritional + social assessment; fall prevention program (CDC STEADI)

---

Polypharmacy in elderly (≥ 5 medications) — associated with: falls, fractures, hospitalization, cognitive impairment, adverse drug events, drug-drug interactions, increased mortality Tools for deprescribing: 1. **Beers Criteria (AGS, updated 2023)** — list of Potentially Inappropriate Medications (PIMs) in adults ≥ 65 years 2. **STOPP/START Criteria** (Screening Tool of Older People''s Prescriptions / Screening Tool to Alert to Right Treatment) — version 3 (2023) European 3. **Medication Appropriateness Index (MAI)** 4. **Drug Burden Index** Specific drugs in this case (high-risk per Beers/STOPP): **Alprazolam (Benzodiazepine)**: - Beers: avoid in elderly (high risk: falls, fractures, delirium, cognitive impairment) - Long half-life → cumulative effect - If used: taper slowly (10-25% q2-4 weeks), substitute non-pharm strategies for anxiety/insomnia (CBT-I) **Paroxetine**: - Strongly anticholinergic among SSRIs → cognitive impairment, anticholinergic burden - Withdrawal syndrome (short half-life) - Beers: avoid; prefer sertraline, escitalopram, citalopram (with caution for QTc) **Antihypertensives + alpha-blocker (tamsulosin) + diuretic**: - Orthostatic hypotension → falls - Check standing BP + symptoms - Consider deprescribing one or more, especially if BP well-controlled - Beers: avoid alpha-blockers as antihypertensives (not as BPH treatment) — but tamsulosin OK for BPH if no orthostasis **Sulfonylurea (glipizide)**: - Hypoglycemia risk especially in CKD - Beers: avoid long-acting (glyburide); short-acting (glipizide) acceptable but caution - Prefer: metformin (eGFR > 30), DPP-4 inhibitor, SGLT2 inhibitor (with renal/CV benefit), GLP-1 agonist **PPI (omeprazole)**: - Long-term risks: fracture, hypomagnesemia, B12 deficiency, C. difficile, pneumonia, AKI, CKD - Deprescribing recommended if no ongoing indication (e.g., chronic NSAID, Barrett''s, severe esophagitis) - Algorithm: identify indication → reassess need → step down or stop **Anticholinergic burden**: paroxetine, donepezil (counteracts purpose), some bladder agents — assess total burden Comprehensive Geriatric Assessment (CGA) — multidisciplinary: 1. Medical: medication review, comorbidity 2. Functional: ADL, IADL, gait/balance (TUG) 3. Cognitive: Mini-Cog, MoCA 4. Nutritional: weight, MNA-SF 5. Psychosocial: depression (GDS), social support 6. Environmental: home safety Deprescribing approach: 1. Comprehensive medication review 2. Identify drugs with no clear indication or harm > benefit 3. Prioritize based on risk (fall risk, anticholinergic, hypoglycemia) 4. Taper one drug at a time 5. Engage patient + family in shared decision-making 6. Monitor for withdrawal/return of symptoms — ตัวเลือก B comprehensive evidence-based deprescribing. A ผิด — abrupt all withdrawal dangerous. C ผิด — adds harm. D ผิด — perpetuates problem. E ผิด — statins debatable benefit in oldest old but не isolated issue'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'ผู้ป่วยอายุ 72 ปี มีปัญหา medication ที่ซับซ้อน — polypharmacy 12 ตัว: rosuvastatin, amlodipine, lisinopril, hydrochlorothiazide, metoprolol, metformin, glipizide, omeprazole, tamsulosin, donepezil, paroxetine, alprazolam

ผู้ป่วยตกล้ม 2 ครั้งในเดือนที่ผ่านมา

คำถาม: ตามหลัก geriatric medicine + Beers Criteria + STOPP/START ยาใดควร reconsider หรือลด/หยุดเพราะ inappropriate medication ใน elderly ที่มี falls';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue trastuzumab + monitor"},{"label":"B","text":"Trastuzumab-induced cardiotoxicity (HFrEF)"},{"label":"C","text":"Increase trastuzumab dose to overcome cardiac stress"},{"label":"D","text":"Hospice referral — terminal cancer + heart failure"},{"label":"E","text":"Heart transplant evaluation immediately"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Trastuzumab-induced cardiotoxicity (HFrEF) — integrated cardio-oncology management: (1) HOLD trastuzumab temporarily (cardiotoxicity often reversible with HF therapy, unlike anthracycline which is dose-cumulative + often irreversible) (2) Start guideline-directed medical therapy (GDMT) for HFrEF: ACEi/ARB or ARNI + beta-blocker + MRA + SGLT2 inhibitor (4 pillars) + diuretic for congestion (3) Repeat echo in 3-4 weeks; if LVEF recovers to > 50%, can resume trastuzumab with close monitoring (4) Cardio-oncology consult — joint decision balancing cancer + cardiac (5) Oncology consult — alternative HER2-targeted therapy (e.g., pertuzumab combo, TDM-1, T-DXd) (6) Long-term surveillance — annual echo, biomarkers; cardiotoxicity affect overall survival

---

Cancer Therapy-Related Cardiac Dysfunction (CTRCD) — major cardio-oncology issue Types of cardiotoxicity by agent: 1. **Anthracyclines** (doxorubicin, epirubicin): - Type I cardiotoxicity: dose-dependent, often irreversible, myocyte death - Cumulative dose limit: doxorubicin > 450-500 mg/m² high risk - Mechanism: oxidative stress, topoisomerase II-beta inhibition - Prevention: dexrazoxane (iron chelator), limit cumulative dose 2. **HER2-targeted (trastuzumab, pertuzumab, TDM-1, T-DXd)**: - Type II cardiotoxicity: not dose-dependent, often **reversible** with cessation + HF therapy - Mechanism: HER2 (ErbB2) inhibition disrupts cardiomyocyte stress response - Risk factors: prior anthracycline, age > 60, baseline LVEF reduced, HTN 3. **Tyrosine kinase inhibitors** (sunitinib, sorafenib): - Hypertension, LV dysfunction - Reversible 4. **Fluoropyrimidines** (5-FU, capecitabine): - Coronary vasospasm → angina, MI - Acute, often reversible with cessation 5. **Immune checkpoint inhibitors** (pembrolizumab, nivolumab, ipilimumab): - Myocarditis (rare but high mortality 50%) - Other: pericarditis, conduction abnormalities - Treatment: high-dose steroid + ICI discontinuation 6. **Radiation therapy**: - Pericardial disease, accelerated CAD, valvular disease - Years to decades later 7. **CAR-T cell therapy**: - Cytokine release syndrome → cardiotoxicity ESC 2022 Cardio-Oncology Guideline + ASCO definition of CTRCD: - **Asymptomatic CTRCD**: LVEF drop ≥ 10 absolute % to < 50%, OR new GLS reduction > 15% relative, OR troponin/BNP elevation - **Symptomatic CTRCD**: HF symptoms + LVEF reduction This patient: LVEF 62 → 38% (drop 24 points) + HF symptoms = Severe CTRCD Management: 1. **Hold trastuzumab** (Type II — reversible) 2. **GDMT for HFrEF**: - ACEi/ARB or **ARNI (sacubitril/valsartan)** — cardioprotective, may improve recovery - **Beta-blocker** (carvedilol, metoprolol succinate, bisoprolol) - **MRA** (spironolactone, eplerenone) - **SGLT2 inhibitor** (dapagliflozin, empagliflozin) — 4th pillar HFrEF therapy - Loop diuretic for congestion 3. **Repeat echo 3-4 weeks**: most recover to > 50% LVEF on GDMT 4. **Cardio-oncology + oncology joint decision**: - If LVEF recovers > 50%, can resume trastuzumab with monitoring - If not recovered, consider alternative HER2-targeted agents (pertuzumab + chemo, TDM-1, T-DXd — newer with less cardiotoxicity) - Balance cancer prognosis + cardiac risk 5. **Long-term surveillance**: - Annual echo, biomarkers - Cardiac biomarker (troponin, BNP) trends - Lifestyle: BP, lipids, weight, exercise 6. **Primary prevention** (high-risk patients pre-treatment): - Baseline echo + biomarkers - ACEi/beta-blocker prophylactically in selected high-risk - Statin (some evidence in anthracycline) — ตัวเลือก B comprehensive integrative. A ผิด — continued trastuzumab worsens LVEF, harms. C ผิด — increased dose worse. D ผิด — premature, cardiotoxicity often reversible. E ผิด — transplant not first-line'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'ผู้ป่วยอายุ 64 ปี underlying breast cancer (HER2+) ได้ trastuzumab + chemotherapy 4 cycles มาด้วยอาการเหนื่อย + bilateral pedal edema + รุนแรงขึ้นใน 2 สัปดาห์

V/S: BP 124/78, HR 96, RR 20, SpO2 95%
PE: JVP 11, S3 gallop +, fine basilar crackles, 2+ pedal edema
Echocardiogram before chemo: LVEF 62%
Echocardiogram now: LVEF 38% (drop > 10 absolute points + below 50%)

Lab: BNP 1,240, Troponin negative, Cr 1.1
EKG: sinus tachycardia, no acute changes';

update public.mcq_questions
set choices = '[{"label":"A","text":"ปรับยาทุกตัว ไม่ปรับใดก็ได้"},{"label":"B","text":"Multi-morbidity prescribing review"},{"label":"C","text":"หยุด empagliflozin เพราะ CKD"},{"label":"D","text":"Continue current regimen unchanged"},{"label":"E","text":"Stop apixaban — too high bleeding risk"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Multi-morbidity prescribing review: (1) **Metformin** — eGFR 22 < 30 = contraindicated (lactic acidosis risk) → discontinue (2) **Empagliflozin** — eGFR 22 < initiation threshold 20 (some guidelines 30) but if already on, continue with monitoring per EMPA-KIDNEY (3) **Apixaban** dose — adjust to 2.5 mg BID if ≥ 2 of: age ≥ 80, weight ≤ 60 kg, Cr ≥ 1.5 (4) **Gabapentin** — accumulates in CKD → reduce dose (eGFR 15-29: 200-700 mg/day; eGFR < 15: 100-300 mg/day) — current 1800 mg/day too high → reduce to 600 mg/day max + monitor for sedation/falls (5) **Glipizide** — hypoglycemia risk in CKD elderly → consider switch (6) **HFpEF guideline**: SGLT2 inhibitor continue (DELIVER, EMPEROR-Preserved benefit); consider spironolactone if K stable; loop diuretic for congestion; treat HT (7) **Constipation** — review opioids, anticholinergics; gabapentin can contribute; PEG laxative first-line (8) Cardio-renal-metabolic syndrome multidisciplinary approach + medication reconciliation

---

Multi-morbidity + polypharmacy + advanced CKD + HF — complex integrative management Key drug-disease interactions: 1. **Metformin in CKD**: - eGFR ≥ 45: full dose - eGFR 30-44: reduce dose, monitor - **eGFR < 30: contraindicated** (FDA 2016 update) — risk of metformin-associated lactic acidosis (MALA), mortality 50% - Discontinue in this patient (eGFR 22) 2. **SGLT2 inhibitors in CKD**: - Indicated for: T2DM + CKD with albuminuria, HFrEF, HFpEF (EMPEROR-Preserved/DELIVER), CKD without DM (EMPA-KIDNEY, DAPA-CKD) - Initiation: empagliflozin labeled for eGFR ≥ 20; dapagliflozin ≥ 25 - **Already on**: continue until dialysis per major trials (cardiorenal benefit persists) 3. **Apixaban dose adjustment** (FDA): - 2.5 mg BID if ≥ 2 of: - Age ≥ 80 years - Body weight ≤ 60 kg - Serum Cr ≥ 1.5 mg/dL - This patient: age 70 (no), weight unknown, Cr (eGFR 22 → likely Cr > 1.5) → assess: if only 1 criterion → 5 mg BID; if ≥ 2 → 2.5 mg BID 4. **Gabapentin in CKD** (renal excretion): - eGFR ≥ 60: full dose 900-3600 mg/day - eGFR 30-59: 400-1400 mg/day - eGFR 15-29: 200-700 mg/day - eGFR < 15: 100-300 mg/day - This patient: eGFR 22 → max 700 mg/day; currently 1800 mg → toxic risk (sedation, falls, ataxia) 5. **Sulfonylurea (glipizide)** in elderly + CKD: - Hypoglycemia risk - Switch to DPP-4 inhibitor (linagliptin — no renal adjustment) or other 6. **HFpEF management** (recent paradigm shift): - SGLT2 inhibitor (empagliflozin EMPEROR-Preserved 2021; dapagliflozin DELIVER 2022) — first guideline-supported - Spironolactone (TOPCAT — debated, some benefit) - Sacubitril/valsartan (PARAGON-HF — borderline; selected) - Loop diuretic for congestion - Treat comorbidities (HT, AF rate control, T2DM, obesity) Comprehensive geriatric medication review + cardio-renal-metabolic coordination — ตัวเลือก B comprehensive. A ผิด — adjustment needed. C ผิด — continue SGLT2 if benefit. D ผิด — toxic medications. E ผิด — anticoagulation needed for AF, just dose adjust'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'ผู้ป่วยหญิงอายุ 70 ปี underlying CKD stage 4 (eGFR 22), T2DM, HFpEF, AF on apixaban, peripheral neuropathy มา OPD ด้วยอาการ chronic constipation + recently elevated cardiac biomarker (NT-proBNP) on routine check

Medications: metformin 500 BID, glipizide 5 mg, empagliflozin 10 mg, apixaban 5 mg BID, metoprolol succinate 100 mg, furosemide 40 mg, atorvastatin 40 mg, gabapentin 600 mg TID

Question: identify high-priority drug-disease + drug-drug interactions to address';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue chemotherapy + observe"},{"label":"B","text":"Malignant Spinal Cord Compression (MSCC)"},{"label":"C","text":"Discharge with oral analgesics"},{"label":"D","text":"MRI brain only — likely cerebral metastasis"},{"label":"E","text":"Aspirin + observe"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Malignant Spinal Cord Compression (MSCC) — oncologic emergency requiring multidisciplinary integrative approach: (1) Immediate IV dexamethasone 10-16 mg loading + 4 mg q6h (reduces cord edema; PRESCO trial supports) (2) Urgent neurosurgery + radiation oncology consult — surgery (decompression + stabilization) + post-op RT shown superior to RT alone in selected ambulatory patients with single-level compression (Patchell trial Lancet 2005); choice based on neurologic status, prognosis, life expectancy, tumor type (3) Concurrent palliative consultation — goals of care discussion (ECOG 2 + metastatic) (4) Pain management (opioids + bisphosphonates for bone pain) (5) DVT prophylaxis (immobile + cancer = high risk) (6) Bladder management (catheter for retention; intermittent catheterization plan) (7) Bowel management (8) Rehab early to maximize function + prevent contracture/decubitus (9) Psychosocial support — patient/family

---

Malignant Spinal Cord Compression (MSCC) — oncologic emergency Incidence: 5-10% of cancer patients overall; most common in lung (15%), breast (15%), prostate (15%), lymphoma, myeloma Etiology: - Extradural (95%): vertebral body metastasis → posterior extension - Intradural extramedullary - Intramedullary Levels: thoracic 60% (most common — narrow canal), lumbosacral 30%, cervical 10% Clinical features: 1. **Pain** (95% — earliest, weeks before deficit): back pain, often radicular, worse at night/lying flat 2. **Motor weakness** (75% at presentation): symmetric, lower extremities (in thoracolumbar) 3. **Sensory deficit** (50%): level - dermatome correlates with compression level 4. **Autonomic dysfunction** (late): - **Urinary retention** + overflow incontinence (post-void > 200 mL highly suggestive) - **Constipation** + bowel incontinence - Loss of anal sphincter tone 5. Lhermitte''s sign, hyperreflexia, Babinski + Diagnosis: - **Whole spine MRI with contrast** — gold standard (multifocal in 30%) - CT myelography if MRI contraindicated Management (NICE 2019 + ASCO + ESMO MSCC guidelines): 1. **Glucocorticoid IMMEDIATELY** (don''t wait for imaging): - Dexamethasone 8-16 mg IV loading → 4 mg q6h - Reduces edema, pain, may preserve neurological function - Taper after definitive Rx 2. **Urgent referral within 24 hr**: - **Neurosurgery + Radiation Oncology** - **Multidisciplinary decision**: a. **Surgical decompression + post-op RT** (Patchell trial Lancet 2005): - Superior to RT alone in: single-level compression, expected survival > 3 months, ambulatory, not radiosensitive tumor - 84% vs 57% retention of ambulation b. **Radiation alone**: - Radiosensitive tumors (lymphoma, SCLC, germ cell, multiple myeloma) - Multi-level compression - Poor prognosis - Non-surgical candidate c. **Stereotactic body radiation (SBRT)**: highly conformal, increasingly used d. **Vertebroplasty/kyphoplasty**: pain control in vertebral collapse 3. **Tumor-directed therapy**: - Chemotherapy (highly chemosensitive tumors: lymphoma, germ cell) - Targeted therapy (e.g., EGFR-TKI for EGFR-mutant NSCLC) - Hormonal (prostate, breast) 4. **Supportive care**: - Pain control (multimodal: opioid + adjuvant analgesic + bisphosphonate) - Bisphosphonate or denosumab for skeletal-related events - **DVT prophylaxis** (cancer + immobility = very high risk) - Bladder + bowel management (Foley initially, IC scheduling) - Pressure injury prevention - Early rehabilitation 5. **Goals-of-care discussion**: - Prognosis, expected outcome of intervention - Quality of life - Patient + family values - Palliative care consultation - Advance directives Prognosis: pre-treatment ambulatory status best predictor of post-treatment function — "time is cord" Long-term outcomes: - Median survival after MSCC: 3-6 months (varies by tumor) - Lung cancer: shorter; breast/prostate/myeloma: longer - ตัวเลือก B comprehensive integrative oncology + neurosurgery + palliative + rehab approach. A ผิด — emergency missed. C ผิด — discharge dangerous. D ผิด — MRI brain not relevant. E ผิด — totally inadequate'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'ผู้ป่วยอายุ 58 ปี diagnosed metastatic NSCLC, ECOG 2, no actionable mutations มาด้วยอาการ severe back pain + leg weakness + urinary retention มา 2 วัน

V/S: BP 138/82, HR 92, RR 18, SpO2 96%
Neuro: bilateral lower extremity weakness grade 3/5, sensory level T10, sphincter dysfunction, bladder palpable post-void volume 600 mL

MRI spine: epidural metastasis T8-T9 with cord compression > 50% canal stenosis + edema';

update public.mcq_questions
set choices = '[{"label":"A","text":"Fibrinolysis (tenecteplase) ทันที + transfer cath lab"},{"label":"B","text":"Inferior STEMI with RV involvement (ST elevation V4R)"},{"label":"C","text":"Sublingual NTG ต่อเนื่อง + IV morphine + observe in ED"},{"label":"D","text":"Beta-blocker IV ทันทีก่อน reperfusion"},{"label":"E","text":"Coronary CT angiography ก่อนเพื่อ confirm diagnosis"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Inferior STEMI with RV involvement (ST elevation V4R) — กระตุ้น STEMI activation + ASA 162-325 mg chew + P2Y12 inhibitor (ticagrelor 180 mg หรือ prasugrel 60 mg loading) + heparin (UFH 60 U/kg bolus หรือ enoxaparin) + Primary PCI ภายใน 90 นาที + IV fluid bolus (ระวัง nitroglycerin/morphine ที่อาจ drop preload ใน RV infarct)

---

Inferior STEMI with right ventricular (RV) infarct (ST elevation V4R = RV involvement, 30-50% of inferior MI). ACC/AHA + ESC 2023 STEMI guideline: (1) Primary PCI within 90 min door-to-balloon (preferred over fibrinolysis if available within 120 min). (2) DAPT loading: ASA + ticagrelor/prasugrel (prasugrel contraindicated in TIA/stroke history หรือ > 75 ปี). (3) Anticoagulation: UFH bolus. (4) **RV infarct caveats**: preload-dependent — avoid nitrates, morphine, diuretics (drop preload → hypotension); give IV NSS fluid bolus; dobutamine ถ้า cardiogenic shock. (5) Beta-blocker IV avoid in early phase ของ RV infarct (worsens bradyarrhythmias). A ผิดเพราะ PCI พร้อม. C ผิด — NTG อันตรายใน RV infarct. D ผิด — beta-blocker IV early เพิ่ม cardiogenic shock risk. E ผิด — STEMI = no time for CTA.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'ชายไทยอายุ 62 ปี underlying HT, DM, dyslipidemia สูบบุหรี่ 30 pack-year มาด้วยอาการเจ็บแน่นหน้าอกแบบทับๆ ร้าวไปกราม + เหงื่อแตก + คลื่นไส้ เริ่ม 45 นาทีที่แล้วขณะทำงาน

V/S: BP 156/94, HR 102, RR 22, SpO2 95% room air, Temp 36.8°C
PE: anxious, diaphoretic, JVP 8, lungs clear, S4 gallop, no murmur

EKG: ST-elevation 2-3 mm in leads II, III, aVF + reciprocal ST depression in I, aVL + ST elevation V4R
Troponin-I: 0.12 (URL 0.04)
CXR: no congestion

Door-to-balloon time ของโรงพยาบาลนี้ < 90 นาที (cath lab พร้อม)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Synchronized cardioversion ทันทีเพราะ HR > 140"},{"label":"B","text":"Stable AF with RVR"},{"label":"C","text":"Digoxin IV monotherapy"},{"label":"D","text":"Aspirin 81 mg alone for stroke prevention"},{"label":"E","text":"IV amiodarone bolus + immediate cardioversion without anticoagulation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Stable AF with RVR — rate control first (IV metoprolol 5 mg q5min × 3 หรือ IV diltiazem 0.25 mg/kg) target HR < 110 + assess thromboembolic risk (CHA2DS2-VASc 4 = anticoagulation indicated) + start DOAC (apixaban หรือ rivaroxaban) — NO need for TEE if duration > 48 hr และไม่ planning cardioversion ทันที + arrange rhythm vs rate strategy พิจารณา outpatient

---

Atrial fibrillation with rapid ventricular response, hemodynamically stable. ACC/AHA/ACCP/HRS 2023 AF guideline: (1) Rate control acute: IV beta-blocker (metoprolol, esmolol) หรือ non-dihydropyridine CCB (diltiazem, verapamil); avoid CCB ใน HFrEF. Target resting HR < 110 (RACE II showed lenient ≈ strict). (2) Rhythm control: cardioversion ถ้า hemodynamic unstable, new-onset symptomatic, หรือ EAST-AFNET 4 strategy ใน early AF. (3) Thromboembolic prophylaxis ตาม CHA2DS2-VASc — ≥ 2 ผู้ชาย หรือ ≥ 3 ผู้หญิง → OAC (DOAC preferred over warfarin ใน non-valvular AF). HAS-BLED ไม่ใช่ contraindication — guides bleeding risk modification. (4) AF > 48 hr or unknown duration: anticoagulate ≥ 3 weeks before cardioversion หรือ TEE-guided. (5) Digoxin: 2nd line, slow onset, narrow therapeutic index — not preferred monotherapy. A ผิด — stable. C ผิด — digoxin slow. D ผิด — ASA inferior to OAC ใน AF. E ผิด — risk of stroke if cardioversion without anticoagulation in long duration AF.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'หญิงไทยอายุ 74 ปี underlying HT, T2DM มา ED ด้วยใจสั่น + เหนื่อย onset 6 ชม. ไม่มีเจ็บอก ไม่ syncope

V/S: BP 128/78, HR 142 irregularly irregular, RR 20, SpO2 96%, Temp 36.6°C
PE: irregular pulse, no murmur, lungs clear, no edema

EKG: atrial fibrillation, no flutter waves, rate 138-148, no ST changes, no LVH strain
Troponin negative, TSH 1.8, electrolytes normal, BNP 320
Echo (prior): LVEF 55%, mild LAE, no valve disease, no thrombus

CHA2DS2-VASc = 4, HAS-BLED = 2';

update public.mcq_questions
set choices = '[{"label":"A","text":"Endurance training program + ACEi"},{"label":"B","text":"Aortic stenosis — refer for surgical AVR"},{"label":"C","text":"Hypertrophic cardiomyopathy with LVOT obstruction + exertional syncope (high SCD risk)"},{"label":"D","text":"Loop diuretic + nitrate for relief"},{"label":"E","text":"Coronary angiography ก่อนพิจารณาอื่นใด"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก C (รายละเอียด):** Hypertrophic cardiomyopathy with LVOT obstruction + exertional syncope (high SCD risk) — restrict competitive sports + beta-blocker (metoprolol) หรือ non-DHP CCB (verapamil) + genetic counseling + cascade family screening + risk-stratify for ICD (HCM Risk-SCD score + family history of SCD + unexplained syncope) → strongly consider primary prevention ICD; mavacamten (cardiac myosin inhibitor) เป็น option ในรายที่ symptomatic obstruction

---

Hypertrophic cardiomyopathy (HCM) with LVOT obstruction. Clues: young adult exertional syncope, harsh systolic murmur that ↑ with Valsalva/standing (reduces preload, worsens LVOT obstruction — opposite of AS), asymmetric septal hypertrophy + SAM, family history of SCD. AHA/ACC 2020 HCM + ESC 2023 Cardiomyopathy guideline: (1) Restrict high-intensity competitive sports — leading cause of SCD in young athletes. (2) Negative inotropes/chronotropes: non-vasodilating beta-blocker (metoprolol, atenolol) first-line; verapamil/diltiazem if BB intolerant; disopyramide added if persistent obstruction. (3) Avoid: vasodilators (ACEi, nitrates), pure diuretics (decrease preload → worsen LVOT gradient), digoxin. (4) Mavacamten (FDA 2022) — myosin inhibitor for obstructive HCM. (5) Septal reduction (myectomy preferred; alcohol septal ablation alternative) ใน refractory NYHA III/IV. (6) ICD primary prevention: major risk markers — FHx SCD, unexplained syncope, NSVT, massive LVH ≥ 30 mm, abnormal BP response, LV apical aneurysm. HCM Risk-SCD score guides 5-yr SCD risk. (7) Cascade genetic screening of 1st degree relatives. A ผิด — sport restriction needed. B ผิด — murmur ↑ with Valsalva = HCM, not AS (AS ↓). D ผิด — diuretic/nitrate worsen. E ผิด — coronary not the issue.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'ชายไทยอายุ 28 ปี ไม่มีโรคประจำตัว มาด้วยอาการเป็นลม syncope ขณะวิ่งออกกำลังกาย ฟื้นเองภายใน 30 วินาที ไม่มี postictal phase ไม่มี tongue bite, ไม่มี incontinence ก่อนหน้านี้มี episodes คล้ายกัน 2 ครั้งใน 1 ปี

Family history: cousin เสียชีวิตอย่างกะทันหันอายุ 32

V/S: BP 124/76, HR 68, RR 16, SpO2 99%
PE: harsh systolic ejection murmur LSB grade 3/6, **เพิ่มขึ้นด้วย Valsalva + standing**, no carotid radiation

EKG: LVH, deep narrow Q in V4-V6, T wave inversion lateral leads
Echo: asymmetric septal hypertrophy 22 mm, SAM of MV +, LVOT gradient at rest 35 mmHg, provocation 90 mmHg';

update public.mcq_questions
set choices = '[{"label":"A","text":"Medical therapy (statins + ASA) + observe"},{"label":"B","text":"Symptomatic severe AS (syncope, angina, dyspnea = class I indication for AVR)"},{"label":"C","text":"Balloon valvuloplasty as definitive treatment"},{"label":"D","text":"ACEi + nitrate ลด afterload"},{"label":"E","text":"Repeat echo ใน 1 ปี"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Symptomatic severe AS (syncope, angina, dyspnea = class I indication for AVR) — Heart team evaluation; SAVR vs TAVR based on age, anatomy, comorbidities; in this patient (68 ปี, intermediate risk, concomitant CAD) — consider SAVR + CABG หรือ TAVR + staged PCI; valve choice (bioprosthetic vs mechanical) + lifelong follow-up; antibiotic prophylaxis IE สำหรับ procedures certain

---

Severe symptomatic aortic stenosis — "SAD" (syncope, angina, dyspnea) classic triad portends median survival 2-3 years without intervention. ACC/AHA 2020 Valvular Heart Disease guideline: (1) Severe AS criteria: peak velocity ≥ 4 m/s, mean gradient ≥ 40 mmHg, AVA ≤ 1 cm². (2) Class I AVR indications: symptomatic severe AS, asymptomatic severe AS with LVEF < 50%, undergoing cardiac surgery for other reason. (3) Heart team decides SAVR vs TAVR: - SAVR preferred: < 65 yr, low surgical risk, bicuspid valve with aortopathy, mechanical valve preference. - TAVR preferred: > 80 yr, high/prohibitive surgical risk; expanding to intermediate-risk based on PARTNER 3, Evolut Low Risk trials showing non-inferior outcomes in low-risk 65-80 yr. (4) Concomitant CAD: significant disease → revascularize (CABG with SAVR; staged PCI with TAVR). (5) Avoid ACEi/nitrate ใน severe AS (preload-dependent → may cause hypotension/syncope). (6) Valvuloplasty: bridge or palliative — high restenosis rate. A ผิด — symptomatic = AVR. C ผิด — palliative only. D ผิด — vasodilators risky. E ผิด — symptomatic = act now.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'หญิงไทยอายุ 68 ปี underlying HT มา ED ด้วยเหนื่อยมากขึ้น exertional + เป็นลม 1 ครั้ง 2 สัปดาห์ก่อน เจ็บอกเล็กน้อยเวลาเดินขึ้นบันได

V/S: BP 138/64 (wide pulse pressure), HR 72, RR 18, SpO2 97%
PE: harsh systolic ejection murmur RUSB radiating to carotids grade 4/6, **decreases with Valsalva**, soft S2, delayed carotid upstroke (parvus et tardus)

Echo: severe aortic stenosis — peak velocity 4.6 m/s, mean gradient 52 mmHg, AVA 0.8 cm², LVEF 60%
CAG: 70% mid-LAD stenosis
STS score: 3.2% (low-intermediate)';

update public.mcq_questions
set choices = '[{"label":"A","text":"IV adenosine 6 mg push"},{"label":"B","text":"Sustained monomorphic VT with hemodynamic instability"},{"label":"C","text":"IV beta-blocker (metoprolol) bolus"},{"label":"D","text":"Carotid sinus massage"},{"label":"E","text":"Lidocaine IV monotherapy as first-line"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Sustained monomorphic VT with hemodynamic instability — Immediate synchronized DC cardioversion 100-200 J (biphasic) + ACLS protocol; after restoration → IV amiodarone 150 mg over 10 min then 1 mg/min infusion; reverse precipitants (electrolyte, ischemia); long-term: ICD secondary prevention (Class I — sustained VT in LVEF ≤ 35%), EP study + ablation consideration, optimize GDMT

---

Sustained monomorphic ventricular tachycardia (VT) with hemodynamic instability (hypotension, syncope). VT clues in wide-complex tachycardia: AV dissociation, fusion/capture beats, QRS > 140 ms, structural heart disease (HFrEF). ACLS + AHA/HRS Ventricular Arrhythmia guideline 2017: (1) Unstable VT → immediate synchronized DC cardioversion 100-200 J biphasic. Pulseless VT/VF → defibrillation. (2) Post-conversion antiarrhythmic: amiodarone (first-line in HFrEF), lidocaine alternative ใน ischemic VT. Procainamide for stable VT (PROCAMIO trial). (3) Reverse precipitants: electrolytes (K, Mg), ischemia, drug toxicity. (4) ICD secondary prevention is Class I for sustained VT/VF survivors with LVEF ≤ 35% (AVID, CIDS trials). (5) EP study + catheter ablation: refractory VT or appropriate ICD shocks. (6) Adenosine, vagal maneuvers, BB IV bolus: useful in SVT, NOT VT — risk of hemodynamic collapse. A ผิด — adenosine for SVT, not VT. C ผิด — IV BB can precipitate collapse. D ผิด — for SVT. E ผิด — amiodarone preferred in HFrEF.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'ชายไทยอายุ 76 ปี underlying HF (LVEF 30% on guideline-directed medical therapy: bisoprolol 5 mg, sacubitril/valsartan 49/51 mg BID, spironolactone 25 mg, dapagliflozin 10 mg), NYHA II baseline มา ED ด้วยใจสั่น เป็นลม syncope 30 นาทีก่อน

V/S: BP 88/56, HR 168 wide complex, RR 24, SpO2 92%, GCS 14
EKG: monomorphic wide complex tachycardia (QRS 180 ms), AV dissociation +, fusion beats, capture beats — sustained > 30 sec, hemodynamically unstable
K 4.0, Mg 2.0, Troponin pending';

update public.mcq_questions
set choices = '[{"label":"A","text":"Outpatient management with rivaroxaban + early discharge"},{"label":"B","text":"Intermediate-high risk submassive PE (RV strain + biomarker elevation, hemodynamically stable but borderline)"},{"label":"C","text":"Aspirin alone for antithrombotic"},{"label":"D","text":"IVC filter ใส่ทันทีโดยไม่ anticoagulate"},{"label":"E","text":"Systemic thrombolytic ทันทีเป็น first-line"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Intermediate-high risk submassive PE (RV strain + biomarker elevation, hemodynamically stable but borderline) — admit ICU/step-down + therapeutic anticoagulation (UFH preferred if escalation to thrombolytic likely, หรือ LMWH) + monitor for decompensation + consider catheter-directed thrombolysis if deterioration หรือ systemic thrombolytic (alteplase 100 mg) ถ้า cardiac arrest หรือ persistent hypotension; AVOID lytic ใน recent surgery unless catastrophic (recent surgery 7 d = relative contraindication)

---

Intermediate-high risk (submassive) pulmonary embolism — RV dysfunction + elevated troponin, hemodynamically stable but at risk for decompensation. ESC 2019 + AHA 2011 + CHEST 2021 PE guideline: (1) Risk stratification: massive (shock) → systemic lytic / catheter-directed; submassive (RV strain + biomarker) → close monitoring + anticoagulation, escalate ถ้า deteriorate (MOPETT, PEITHO data); low-risk → outpatient DOAC. (2) Anticoagulation: UFH (titratable, reversible, preferred if planning intervention), LMWH (enoxaparin), หรือ DOAC after acute phase. (3) Systemic thrombolytic (alteplase 100 mg over 2 hr) for massive PE — bleeding risk 10-20%. (4) Recent surgery (< 14 days) = relative contraindication to systemic lysis; catheter-directed thrombolysis (lower dose) safer alternative — SEATTLE II, OPTALYSE. (5) IVC filter: indication = contraindication to anticoagulation; not as standalone treatment. A ผิด — submassive ≠ outpatient. C ผิด — ASA ไม่พอ. D ผิด — IVC filter requires anticoagulation when possible. E ผิด — risk-benefit unfavorable post-op without instability.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'หญิงไทยอายุ 58 ปี underlying obesity, recent total knee arthroplasty 7 วันก่อน มา ED ด้วยอาการเจ็บอกแบบ pleuritic + เหนื่อย onset 2 ชม. ไอเล็กน้อยมีเลือดปน

V/S: BP 102/68, HR 118, RR 28, SpO2 88% room air → 94% on 4L NC, Temp 37.4°C
PE: clear lungs, no edema, calf ขวา tender + swelling 3 cm difference

Lab: D-dimer 4,800 ng/mL, Troponin 0.08 (low elevation), BNP 480
EKG: sinus tachycardia 118, S1Q3T3 pattern, RBBB new
CXR: clear, no infiltrate
CT pulmonary angiography: bilateral segmental + subsegmental PE + RV/LV diameter ratio 1.2 (RV strain), no saddle thrombus
Echo: RV dilation + RV hypokinesis, septal flattening, no thrombus

sPESI: 2 (high risk), BP stable but borderline';

update public.mcq_questions
set choices = '[{"label":"A","text":"100% oxygen via non-rebreather mask"},{"label":"B","text":"COPD exacerbation with hypercapnic respiratory failure"},{"label":"C","text":"High-dose IV theophylline as first-line bronchodilator"},{"label":"D","text":"Intubation ทันทีโดยไม่ลอง NIV ก่อน"},{"label":"E","text":"Furosemide IV for pulmonary edema"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** COPD exacerbation with hypercapnic respiratory failure — controlled oxygen target SpO2 88-92% (venturi 24-28%) + nebulized short-acting bronchodilator (salbutamol + ipratropium q4-6h) + systemic corticosteroid (prednisolone 40 mg PO × 5 d หรือ methylprednisolone IV) + antibiotic (amoxicillin-clavulanate or doxycycline — Anthonisen criteria 3) + NIV (BiPAP) for pH < 7.35 + PaCO2 > 45 + monitor; intubation ถ้า NIV fail หรือ contraindicated

---

COPD exacerbation with acute-on-chronic hypercapnic respiratory failure (pH 7.32, PaCO2 58, elevated HCO3 = chronic compensation + acute decompensation). GOLD 2024 + Thai COPD guideline: (1) Controlled oxygen: target SpO2 88-92% (high FiO2 → worsening hypercapnia via Haldane effect, V/Q mismatch, ↓ respiratory drive). (2) Bronchodilator: nebulized SABA + SAMA (salbutamol + ipratropium). (3) Systemic corticosteroid: prednisolone 40 mg/day × 5 days (REDUCE trial — 5 d non-inferior 14 d), reduces relapse + LOS. (4) Antibiotic: Anthonisen ≥ 2 of 3 (↑ dyspnea, ↑ sputum volume, ↑ purulence) — typically amoxicillin-clavulanate, doxycycline, macrolide 5-7 days; cover Pseudomonas (cipro/levofloxacin) ถ้า severe + recent hospitalization. (5) NIV (BiPAP) Class I for pH < 7.35 + PaCO2 > 45 + respiratory distress — reduces mortality + intubation rate (Cochrane). (6) Methylxanthines: not routine — narrow therapeutic, side effects. A ผิด — high FiO2 → worsens hypercapnia. C ผิด — theophylline not first-line. D ผิด — try NIV first. E ผิด — not edema.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'ชายไทยอายุ 70 ปี underlying COPD GOLD III (FEV1 38% predicted) on tiotropium + LABA + ICS, recent URI 5 วันก่อน มา ED ด้วยเหนื่อยมากขึ้น เสมหะเปลี่ยนสีเหลือง-เขียว ปริมาณเพิ่ม

V/S: BP 138/82, HR 108, RR 28, SpO2 86% room air → 91% on 2L NC, Temp 37.6°C
PE: pursed-lip breathing, accessory muscle use, prolonged expiration, diffuse rhonchi + scattered wheeze, no consolidation
ABG room air: pH 7.32, PaCO2 58, PaO2 54, HCO3 30 (chronic + acute on top)
CXR: hyperinflated lungs, no infiltrate, no pneumothorax';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue MDI albuterol + observation"},{"label":"B","text":"Near-fatal asthma exacerbation (silent chest, normal/rising CO2 in tachypneic asthmatic = impending respiratory failure)"},{"label":"C","text":"IV theophylline as primary therapy"},{"label":"D","text":"IV beta-blocker เพื่อ control HR"},{"label":"E","text":"Discharge with new MDI + oral steroid + return precautions"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Near-fatal asthma exacerbation (silent chest, normal/rising CO2 in tachypneic asthmatic = impending respiratory failure) — Continuous nebulized salbutamol + ipratropium + IV magnesium sulfate 2 g over 20 min + systemic corticosteroid (IV hydrocortisone 100 mg หรือ oral prednisolone 50 mg) + high-flow O2 + early ICU + prepare for intubation (rapid sequence, ketamine preferred bronchodilator effect) with lung-protective + permissive hypercapnia + IV epinephrine ถ้า peri-arrest

---

Near-fatal asthma (status asthmaticus). Critical signs: silent chest (no air movement), normal/rising PaCO2 in asthmatic with tachypnea (should be hypocapnic — "normal" CO2 = exhaustion), drowsiness, cannot complete words. GINA 2024 + Thai Asthma guideline: (1) Inhaled SABA: continuous nebulized salbutamol 5 mg + ipratropium 0.5 mg q20min × 3, then q1-4h. (2) Systemic glucocorticoid: oral prednisolone 50 mg or IV hydrocortisone 100 mg q6h (slow onset 4-6 hr; reduces relapse). (3) IV magnesium sulfate 2 g over 20 min — bronchodilator + adjunct in severe (3 Mg trial). (4) Oxygen target SpO2 93-95%. (5) Intubation indications: silent chest, exhaustion, ↓ consciousness, rising CO2 — use ketamine (bronchodilator), lung-protective vent (low TV 6 mL/kg, permissive hypercapnia, longer expiratory time, watch dynamic hyperinflation). (6) Adjuncts: heliox (decreased airflow resistance), ECMO ใน refractory. (7) Epinephrine IM/IV in peri-arrest or anaphylaxis component. A ผิด — failed already. C ผิด — theophylline ไม่ใช่ primary. D ผิด — BB contraindicated severe asthma. E ผิด — near-fatal = ICU not discharge.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'หญิงไทยอายุ 32 ปี underlying asthma, allergic rhinitis on ICS-LABA (budesonide/formoterol) + albuterol PRN มา ED ด้วยอาการเหนื่อยมาก พูดได้แค่ครั้งละคำ คล้ายจะหมดสติ ใช้ albuterol MDI 20 puffs ใน 1 ชม. ก่อนมา ไม่ดีขึ้น

V/S: BP 142/88, HR 132, RR 36, SpO2 88% room air, Temp 37.0°C
PE: tripod position, accessory muscle use, **silent chest bilateral** (no wheeze), prolonged expiration, drowsy borderline
PEFR ทำไม่ได้ (too distressed)
ABG room air: pH 7.30, PaCO2 48, PaO2 58 (normal-elevated CO2 in asthma = exhaustion sign)';

update public.mcq_questions
set choices = '[{"label":"A","text":"NSAID for pain + observe + delayed EGD"},{"label":"B","text":"Variceal UGIB in cirrhosis"},{"label":"C","text":"Massive crystalloid resuscitation (5 L NSS) + transfusion to Hb 12"},{"label":"D","text":"Vasopressin IV alone without endoscopy"},{"label":"E","text":"Tranexamic acid only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Variceal UGIB in cirrhosis — resuscitation 2 large-bore IV + crystalloid restricted (avoid over-resuscitation worsens variceal bleeding — target SBP 90-100, Hb 7-8) + restrictive PRC transfusion (Hb 7-8 trigger, Villanueva NEJM 2013) + IV octreotide (50 mcg bolus → 50 mcg/hr × 3-5 d) + IV ceftriaxone 1 g/d × 7 d prophylaxis SBP/BBI + IV PPI bolus then drip + urgent EGD within 12 hr with band ligation; if uncontrolled → TIPS (rescue) หรือ Sengstaken-Blakemore bridging

---

Acute variceal bleeding in cirrhosis (stigmata of chronic liver disease + portal hypertension). AASLD 2017 + Baveno VII 2022 portal hypertension guideline: (1) Resuscitation: avoid over-transfusion (↑ portal pressure → rebleed; Villanueva NEJM 2013 — restrictive Hb 7-8 trigger reduces mortality vs liberal Hb 9-10). (2) Splanchnic vasoconstrictor: octreotide / terlipressin / somatostatin × 3-5 days. (3) Prophylactic antibiotic (ceftriaxone or norfloxacin) × 7 days — reduces infection, rebleeding, mortality (Bernard Hepatology 1999). (4) Urgent endoscopy within 12 hr: variceal band ligation (1st choice esophageal), tissue glue (gastric varices). (5) PPI infusion — empiric until endoscopy distinguishes variceal from peptic ulcer. (6) Rescue: TIPS (early TIPS within 72 hr in Child-Pugh B with active bleeding or C; García-Pagán NEJM 2010), balloon tamponade (24 hr bridging), self-expanding metal stent. (7) Secondary prevention after acute: NSBB (propranolol/carvedilol) + repeat EBL. A ผิด — NSAID worsens bleeding. C ผิด — over-resuscitation increases rebleed/mortality. D ผิด — endoscopy essential. E ผิด — TXA ไม่ลด mortality ใน UGIB (HALT-IT 2020).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'ชายไทยอายุ 55 ปี ไม่มีโรคประจำตัวที่ทราบ มา ED ด้วยอาเจียนเป็นเลือดสดและก้อนเลือดดำ 3 ครั้งใน 2 ชม. + ถ่ายอุจจาระดำเหนียว 2 ครั้ง ก่อนหน้านี้ดื่มสุราหนัก 30 ปี

V/S: BP 88/56 (orthostatic +), HR 124, RR 22, SpO2 96%, Temp 36.5°C
PE: pale, jaundice +, spider angioma, palmar erythema, abdominal distension + shifting dullness +, splenomegaly, no asterixis

Lab: Hb 7.2 (baseline unknown), Plt 78,000, INR 1.8, BUN 48, Cr 1.0, Bilirubin 3.4, Albumin 2.4, AST 92, ALT 48, Ammonia 68
FAST: moderate ascites';

update public.mcq_questions
set choices = '[{"label":"A","text":"Observation อย่างเดียว เพราะ HBeAg negative"},{"label":"B","text":"Chronic HBeAg-negative hepatitis B with active disease + significant fibrosis F3"},{"label":"C","text":"Tenofovir + entecavir combination เป็น standard"},{"label":"D","text":"Pegylated interferon as preferred 1st-line in HBeAg negative + F3"},{"label":"E","text":"Liver transplant evaluation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Chronic HBeAg-negative hepatitis B with active disease + significant fibrosis F3 — initiate antiviral therapy: 1st-line entecavir 0.5 mg/d (high genetic barrier) หรือ tenofovir alafenamide (TAF, preferred ใน bone/renal concern) หรือ tenofovir disoproxil fumarate (TDF) — pegylated interferon alternative ใน selected (younger, HBeAg+, low HBV DNA, high ALT, genotype A); monitor HBV DNA, ALT q3-6เดือน + HCC surveillance (US + AFP q6เดือน — F3/cirrhosis = high risk regardless of viral suppression); duration: until HBsAg loss + 12 เดือน consolidation

---

Chronic hepatitis B, HBeAg-negative, active hepatitis (HBV DNA > 2,000 IU/mL + persistently elevated ALT > 2 ULN + significant fibrosis ≥ F2). AASLD 2018 + EASL 2017 + APASL 2015 HBV guideline: (1) Indication for treatment: HBV DNA > 2,000 + ALT > ULN with significant inflammation/fibrosis (≥ F2), OR cirrhosis with any detectable DNA, OR HBeAg+ with persistent ALT elevation. (2) First-line: nucleos(t)ide with high genetic barrier — entecavir, tenofovir (TDF or TAF). - TAF preferred ใน bone disease, CKD, elderly (less nephrotoxic, less bone loss). - TDF preferred ใน pregnancy. - Entecavir avoid ใน lamivudine-resistant. (3) Pegylated interferon: finite duration (48 wk), 30% response, contraindicated cirrhosis decompensated, autoimmune, pregnancy. (4) HCC surveillance: US + AFP every 6 months for cirrhosis, F3 fibrosis, family hx HCC, Asian male > 40, Asian female > 50. (5) Treatment duration: indefinite typically; HBsAg seroconversion = functional cure (rare ~1-3%/yr); consolidate 12 mo before stop. (6) Monitor: HBV DNA, ALT, HBsAg quantitative, HBeAg, Cr (TDF), DXA. A ผิด — active disease + F3 = treat. C ผิด — combo ไม่ใช่ standard ใน chronic Rx-naïve. D ผิด — IFN ไม่ใช่ preferred. E ผิด — F3 ไม่ใช่ end-stage.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'หญิงไทยอายุ 42 ปี underlying chronic hepatitis B (HBeAg negative, HBV DNA 12,000 IU/mL, ALT 92, AST 78 — moderately elevated > 2 ULN x 6 เดือน) Fibroscan 9.8 kPa (F3 fibrosis), ไม่มี HCC จาก US + AFP, ไม่ตั้งครรภ์ ปฏิเสธ alcohol

ไม่มี co-infection HIV/HCV/HDV, eGFR 95, T-spine X-ray normal';

update public.mcq_questions
set choices = '[{"label":"A","text":"NPO + IV NSS 50 mL/hr maintenance + IV PPI"},{"label":"B","text":"Acute pancreatitis (alcohol etiology)"},{"label":"C","text":"Empirical broad-spectrum antibiotics for all pancreatitis"},{"label":"D","text":"Emergency surgery + necrosectomy"},{"label":"E","text":"ERCP within 24 hr regardless of etiology"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute pancreatitis (alcohol etiology) — Aggressive but **goal-directed** fluid resuscitation (lactated Ringer''s preferred over NS — WATERFALL trial moderate fluid 1.5 mL/kg/hr after initial bolus, avoid over-resuscitation) + early enteral nutrition (within 24-72 hr — NJ tube if intolerant oral, NOT prolonged NPO) + analgesia (IV opioid: hydromorphone/fentanyl preferred; meperidine avoided) + treat underlying (alcohol cessation, triglyceride <500 not causal here) + NO prophylactic antibiotics in sterile necrosis + monitor for complications (necrosis, pseudocyst, infected necrosis at 2-4 wk, ARDS, AKI)

---

Acute pancreatitis (Atlanta classification — 2 of 3: characteristic pain + lipase/amylase > 3× ULN + imaging). Etiology: alcohol > gallstone here. ACG 2024 + AGA 2018 + WSES guideline: (1) Fluid resuscitation: lactated Ringer (less acidemia, anti-inflammatory) > NS; goal-directed — WATERFALL trial (NEJM 2022) showed aggressive (10 mL/kg bolus + 3 mL/kg/hr) vs moderate (1.5 mL/kg/hr after 10 mL/kg bolus) had MORE fluid overload without improved outcomes → moderate preferred. (2) Early enteral nutrition: within 24-72 hr if tolerating (oral or NJ); reduces infection, mortality vs prolonged NPO (PYTHON trial, Cochrane). (3) Analgesia: IV opioid; meperidine traditional preference is myth — avoid (neurotoxicity). (4) Prophylactic antibiotics: NOT indicated ใน sterile necrotizing pancreatitis (multiple RCT). Use only ใน documented/suspected infected necrosis (gas in collection, persistent sepsis at 7-10 d). (5) ERCP within 24 hr only if cholangitis or persistent biliary obstruction — not in alcoholic. (6) Severity scores: BISAP, Ranson, APACHE II, modified Marshall. (7) Step-up approach for infected necrosis: percutaneous drainage → endoscopic/minimally invasive necrosectomy → open last resort (PANTER trial). A ผิด — under-resuscitation; need early enteral. C ผิด — no prophylactic abx. D ผิด — surgery delayed step-up. E ผิด — ERCP for biliary obstruction only.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'ชายไทยอายุ 38 ปี ไม่มีโรคประจำตัว มา ED ด้วยปวดท้องบริเวณ epigastrium ร้าวทะลุไปหลังรุนแรง 12 ชม. คลื่นไส้ อาเจียน เคยดื่มสุรา binge 2 วันก่อน

V/S: BP 110/72, HR 116, RR 22, SpO2 96%, Temp 37.8°C
PE: epigastric tenderness, guarding +, decreased bowel sounds, no rebound, no flank discoloration

Lab: Lipase 1,850 (URL 60), Amylase 980, WBC 16,500 (N 88%), Hb 14.2, Plt 320,000, Cr 1.2, BUN 32, Ca 8.4, Glucose 156, AST 68, ALT 42, ALP 110, Bilirubin 1.4, Triglyceride 380, LDH 380, Albumin 3.6
ABG: pH 7.36, PaCO2 36, HCO3 22
US abdomen: no gallstone, no CBD dilation, pancreas edematous
BISAP score: 2, Ranson criteria at admission: 2';

update public.mcq_questions
set choices = '[{"label":"A","text":"Antibiotic (metronidazole + ciprofloxacin) เป็น first-line"},{"label":"B","text":"Ulcerative colitis, moderate-severe activity, left-sided"},{"label":"C","text":"Surgery (total colectomy) เป็น first-line"},{"label":"D","text":"Diet modification + probiotic alone"},{"label":"E","text":"Empirical antiparasitic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Ulcerative colitis, moderate-severe activity, left-sided — Induction: oral 5-ASA (mesalamine 4.8 g/d) + rectal 5-ASA (enema/suppository) — combined topical + oral superior; if inadequate response in 2-4 wk → add oral systemic corticosteroid (prednisolone 40 mg/d taper) OR budesonide MMX; severe/steroid-refractory → biologic (anti-TNF infliximab, anti-integrin vedolizumab, anti-IL12/23 ustekinumab) หรือ JAK inhibitor (tofacitinib); Maintenance: 5-ASA หรือ biologic ที่ induce remission; colon CA surveillance from 8 yr after dx; extracolonic mgmt (iritis, arthritis)

---

Ulcerative colitis (UC) — continuous inflammation from rectum, crypt abscess, no granuloma, no skip lesion, with extraintestinal manifestations (peripheral arthritis, iritis). ACG 2019 + AGA 2020 + ECCO 2022 UC guideline: (1) Severity: Mayo score, Truelove-Witts; moderate-severe = systemic illness, frequent stool, anemia. (2) Mild-moderate left-sided UC: oral + topical 5-ASA combination (Cochrane — superior to either alone). (3) Moderate-severe: oral prednisolone 40 mg/day or budesonide MMX (lower side effect); if refractory → biologic. (4) Biologics: anti-TNF (infliximab, adalimumab), vedolizumab (gut-selective, safer profile), ustekinumab; JAK inhibitor tofacitinib, upadacitinib. (5) Acute severe UC (Truelove-Witts severe): IV methylprednisolone 60 mg/day, calprotectin/CRP rapid assessment day 3; if non-response → infliximab rescue or cyclosporine; colectomy if no response by day 7. (6) Maintenance: avoid chronic steroids; 5-ASA, immunomodulator, biologic. (7) Surveillance: chromoendoscopy or HD-WL colonoscopy from 8 yr after UC dx (annual to 5-yearly based on risk). (8) Extraintestinal: peripheral arthritis tracks disease activity, axial doesn''t; iritis = urgent ophthalmologic referral. A ผิด — antibiotic เฉพาะ pouchitis, perianal CD. C ผิด — surgery refractory or dysplasia/CA. D ผิด — diet alone ไม่พอ moderate-severe. E ผิด — no evidence parasite.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'หญิงไทยอายุ 26 ปี ไม่มีโรคประจำตัว มาด้วยถ่ายเหลวมีมูกเลือดปนมา 3 เดือน ปวดเกร็งท้องน้อย urgency + tenesmus ปวดข้อโดยเฉพาะ ankles, น้ำหนักลด 4 kg, มี iritis 1 ตอน 1 เดือนก่อน

V/S: BP 110/68, HR 92, Temp 37.4°C
Lab: Hb 9.8, MCV 78, Plt 480,000, ESR 62, CRP 38, Albumin 3.0, Cr 0.8, ALT 28, fecal calprotectin 580 (high)
Stool culture, C. difficile toxin, parasites: negative
Colonoscopy: continuous inflammation from rectum to splenic flexure with loss of vascular pattern, friable mucosa, superficial ulcers, no skip lesion, no perianal disease; biopsy = chronic active colitis with crypt abscess, basal plasmacytosis, no granuloma
Surface area involved: 35-40% (left-sided colitis)
Mayo score: 8 (moderate-severe activity)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Antiplatelet ASA 325 mg + admit observation"},{"label":"B","text":"Acute ischemic stroke within window"},{"label":"C","text":"Aggressive BP reduction to 120/80 ทันที"},{"label":"D","text":"Heparin infusion full-dose for stroke"},{"label":"E","text":"Statin + observe without acute reperfusion"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute ischemic stroke within window — IV alteplase 0.9 mg/kg (10% bolus, 90% over 1 hr) ภายใน 4.5 ชม. onset (max 90 mg) + BP control < 185/110 ก่อน tPA, < 180/105 หลัง × 24 hr + permissive hypertension if no tPA + assess for endovascular thrombectomy (M2 occlusion: select cases per AURORA, with mismatch + favorable ASPECTS); NIHSS ≥ 6 + LVO + < 24 hr → EVT consideration (DAWN/DEFUSE-3 extended window); admit stroke unit; start dual antiplatelet (ASA + clopidogrel × 21 d in minor stroke/TIA — CHANCE/POINT)

---

Acute ischemic stroke within thrombolytic window. AHA/ASA 2019 + updated 2023 stroke guideline: (1) IV alteplase 0.9 mg/kg (max 90 mg) within 4.5 hr onset; tenecteplase 0.25 mg/kg single bolus emerging alternative (AcT, EXTEND-IA TNK). (2) BP target: < 185/110 before tPA (labetalol, nicardipine); < 180/105 × 24 hr after; permissive hypertension (< 220/120) if no tPA. (3) Endovascular thrombectomy (EVT): - 0-6 hr: NIHSS ≥ 6, LVO (ICA, M1) — Class I (HERMES). - 6-24 hr: select with clinical-imaging mismatch (DAWN: NIHSS-core mismatch; DEFUSE-3: perfusion mismatch). - M2: select cases (AURORA pooled data). (4) Glucose control 140-180. (5) Avoid acute BP lowering (worsens penumbra); permissive HTN if no reperfusion. (6) Anticoagulation: not for acute stroke; for AF after stabilization (timing per stroke size — 1-2-3-4 day rule for small to large infarcts). (7) Antiplatelet: ASA within 24 hr (after 24 hr if tPA); DAPT × 21 d in minor stroke/high-risk TIA (CHANCE, POINT). A ผิด — within window = thrombolytic. C ผิด — aggressive BP ↓ worsens stroke. D ผิด — heparin not for acute stroke. E ผิด — misses reperfusion opportunity.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'ชายไทยอายุ 60 ปี underlying HIT, dyslipidemia มา ED ด้วยอาการแขนขวา + ใบหน้าด้านขวาอ่อนแรง พูดไม่ชัด (slurred speech, expressive aphasia) onset 90 นาทีก่อน

V/S: BP 168/92, HR 86 sinus, RR 18, SpO2 98%, Glucose 142
NIHSS: 12 (moderate)
Neuro: right hemiparesis 3/5 arm > leg, right facial droop, expressive aphasia (Broca), no neglect, gaze conjugate

CT brain non-contrast: no hemorrhage, no early ischemic change ASPECTS 9
CTA: left M2 MCA occlusion + LICA 50% stenosis, no large vessel proximal
CT perfusion: penumbra > core (mismatch 60%)
ไม่มี contraindication ต่อ thrombolytic (no recent surgery, no recent stroke, no anticoagulant, no GIB)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Antihypertensive aggressive ลด BP ให้ normal + delayed clipping ใน 2 สัปดาห์"},{"label":"B","text":"Aneurysmal subarachnoid hemorrhage"},{"label":"C","text":"Lumbar puncture ก่อน CT angiography เพื่อ confirm"},{"label":"D","text":"Heparin anticoagulation prevent secondary thrombosis"},{"label":"E","text":"Mannitol IV ทันทีและพิจารณา hemicraniectomy"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Aneurysmal subarachnoid hemorrhage — ICU admission + BP target SBP < 160 (labetalol/nicardipine) + early aneurysm securing (endovascular coiling preferred over clipping per ISAT) within 24-72 hr + Nimodipine 60 mg PO/NG q4h × 21 d (reduces delayed cerebral ischemia) + maintain euvolemia (avoid prophylactic hypervolemia) + glucose 140-180 + seizure prophylaxis short course + monitor for: rebleeding (peak day 1), hydrocephalus (ext ventricular drain ถ้า), delayed cerebral ischemia (DCI day 4-14 — TCD + clinical), hyponatremia (CSW/SIADH)

---

Aneurysmal subarachnoid hemorrhage (aSAH) — "thunderclap headache" + meningismus + Fisher 3 + AcoA aneurysm. AHA/ASA + Neurocritical Care SAH guideline 2023: (1) BP control: target SBP < 160 (some < 140) until aneurysm secured to prevent rebleed; nicardipine/labetalol/clevidipine. (2) Early aneurysm treatment: < 24-72 hr by coiling (endovascular) — superior to clipping in most (ISAT trial — better outcome, less death/dependency at 1 yr); clipping for complex anatomy. (3) Nimodipine 60 mg q4h × 21 d — reduces poor outcomes (mechanism: neuroprotective, doesn''t prevent vasospasm angiographically). (4) Volume management: euvolemia (CVP-guided NSS); avoid prophylactic hypervolemia (no benefit + harms). (5) DCI monitoring: TCD daily, clinical exam; treat with permissive hypertension ("Triple H" outdated — just induced hypertension), endovascular angioplasty/intra-arterial vasodilators. (6) Hydrocephalus: EVD; chronic VP shunt 20%. (7) Seizure prophylaxis: short course (3-7 d) if no seizure; longer if hemorrhage extends into parenchyma. (8) Hyponatremia: CSW (volume-depleted) vs SIADH (euvolemic) — common; treat with NSS + fludrocortisone if CSW. A ผิด — early securing essential. C ผิด — CT positive = no LP. D ผิด — anticoagulation worsens. E ผิด — mannitol/decompressive for ICH not SAH alone.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'หญิงไทยอายุ 70 ปี underlying HT มา ED ด้วยปวดศีรษะรุนแรงทันที ("worst headache ever") + อาเจียน + คอแข็ง + GCS ลดลงเป็น 13 (E3V4M6) onset 1 ชม.

V/S: BP 192/108, HR 76, RR 16, SpO2 98%, Temp 37.0°C
Neuro: no focal motor deficit, photophobia, neck stiffness +, no papilledema, pupil equal

CT brain non-contrast: subarachnoid blood ใน basal cisterns + bilateral sylvian fissures (Fisher 3, modified Fisher 4)
CTA: 7 mm anterior communicating artery aneurysm
Hunt-Hess grade II, WFNS grade II';

update public.mcq_questions
set choices = '[{"label":"A","text":"No further workup — single seizure, no treatment needed"},{"label":"B","text":"Provoked seizure — correct trigger and discharge home"},{"label":"C","text":"First focal-to-bilateral tonic-clonic seizure with identified epileptogenic lesion (cortical malformation) + epileptiform EEG = epilepsy by ILAE 2014 definition (recurrence risk > 60%)"},{"label":"D","text":"Lifelong phenytoin monotherapy"},{"label":"E","text":"EEG-guided ketogenic diet"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก C (รายละเอียด):** First focal-to-bilateral tonic-clonic seizure with identified epileptogenic lesion (cortical malformation) + epileptiform EEG = epilepsy by ILAE 2014 definition (recurrence risk > 60%) — start anti-seizure medication (levetiracetam 500 mg BID up-titrate, OR lamotrigine slow titration, OR lacosamide); driving restriction per local regulation (Thailand: 6-12 เดือน seizure-free); seizure precautions counseling; pregnancy planning if female (avoid valproate); refer epilepsy clinic + neurosurgery consideration if drug-resistant for resective surgery

---

First-onset focal-to-bilateral tonic-clonic seizure. ILAE 2014 operational definition of epilepsy: (a) ≥ 2 unprovoked seizures > 24 hr apart, OR (b) 1 unprovoked seizure + ≥ 60% recurrence risk over 10 yr, OR (c) epilepsy syndrome. Our patient = (b) — structural lesion + epileptiform EEG → high recurrence → epilepsy → treat. (1) ASM choice: - Focal: levetiracetam, lamotrigine, lacosamide, carbamazepine (CBZ avoided in HLA-B*1502 + Asian = SJS), oxcarbazepine. - Generalized: valproate (most effective but teratogenic), lamotrigine, levetiracetam. - Pregnancy: lamotrigine, levetiracetam preferred; avoid valproate (NTD, autism, IQ↓). (2) Single seizure without high recurrence risk: discuss observation vs ASM (MESS trial — delay reasonable). (3) Driving: country-specific seizure-free period (US 3-12 mo; Thailand typically 6-12 mo). (4) Counseling: bathing/showering (vs bath = drowning risk), heights, swimming alone, ladders, no alcohol-driven sleep deprivation. (5) Drug-resistant epilepsy: failure of 2 adequately tried ASM → evaluate for resective surgery (lesionectomy in focal cortical dysplasia), VNS, RNS, ketogenic diet. (6) Levels & adherence; counsel SUDEP. A ผิด — risk ของ recurrence high. B ผิด — no provoking factor identified. D ผิด — phenytoin not first-line (cosmetic + cognitive). E ผิด — diet for refractory.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'ชายไทยอายุ 26 ปี ไม่มีโรคประจำตัว ตื่นมาพบแขนซ้ายอ่อนแรง + พูดไม่ชัด เริ่มแบบกระตุก หมุนหน้าไปทางขวา → generalized tonic-clonic 90 วินาที → postictal confusion 20 นาที ไม่มี FH seizure, ไม่ใช้สารเสพติด ไม่มี head trauma

V/S: BP 132/82, HR 92 sinus, RR 18, SpO2 98%, Temp 36.9°C
Neuro: post-ictal drowsy GCS 14, no focal residual, no neck stiffness, tongue bite +

Lab: Na 138, K 4.0, Glucose 102, Ca 9.4, Mg 2.0, Cr 0.9, CBC normal, prolactin elevated 60 (suggests true seizure not PNES), Tox screen negative
CT brain: normal
MRI brain: small focal cortical malformation right frontal
EEG: interictal right frontal sharp waves';

update public.mcq_questions
set choices = '[{"label":"A","text":"Iodine therapy alone"},{"label":"B","text":"Graves disease with AF"},{"label":"C","text":"Levothyroxine to suppress thyroid function"},{"label":"D","text":"Surgery (total thyroidectomy) เป็น first-line"},{"label":"E","text":"Steroid IV ทันทีโดยไม่ให้ antithyroid"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Graves disease with AF — Initiate antithyroid drug methimazole 20-40 mg/d (carbimazole equivalent; PTU only in 1st trimester pregnancy or thyroid storm due to hepatotoxicity) + beta-blocker (propranolol 40 mg q6h หรือ atenolol) symptom control + AF management (rate control + anticoagulation per CHA2DS2-VASc; AF often reverts when euthyroid); definitive options after MMI 12-18 mo (radioactive iodine I-131 preferred in non-pregnant; thyroidectomy if compressive/ophthalmopathy concern/pregnancy contraindication) + monitor LFT, CBC (agranulocytosis warning), TFT q4-6 wk; ophthalmology referral if moderate-severe orbitopathy (high-dose IV methylprednisolone, teprotumumab)

---

Graves disease — diffuse goiter + Graves ophthalmopathy + TRAb positive + diffuse high RAIU + thyrotoxicosis + AF complication. ATA 2016 + Endocrine Society guideline: (1) Three definitive options — discuss with patient: (a) Antithyroid drug (ATD): methimazole 5-40 mg/d (preferred over PTU due to hepatotoxicity risk; PTU only 1st trimester pregnancy and thyroid storm). Duration 12-18 mo; remission 30-50%. (b) Radioactive iodine (I-131): definitive, hypothyroidism likely (need lifelong LT4); contraindicated in pregnancy/breastfeeding; relative contraindication in moderate-severe Graves orbitopathy (can worsen — steroid prophylaxis if mild GO). (c) Thyroidectomy: rapid control, large goiter, suspected malignancy, severe GO. (2) Beta-blocker for symptoms (propranolol blocks T4→T3 conversion). (3) AF in thyrotoxicosis: rate control + anticoagulation; reversion 60-70% within 4 mo of euthyroidism. (4) Monitor ATD: LFT, CBC; agranulocytosis (rare 0.2%) — stop if fever/sore throat; cholestatic hepatitis (MMI). (5) Graves orbitopathy: smoking cessation (huge), selenium for mild, IV methylprednisolone for active moderate-severe, teprotumumab (IGF-1R Ab — FDA 2020). (6) Thyroid storm: ICU + PTU + iodine 1 hr after PTU + steroid + BB + cooling + supportive. A ผิด — iodine + ATD combo for prep, alone causes worsening. C ผิด — LT4 = hypothyroid Rx not Graves. D ผิด — surgery not 1st-line. E ผิด — steroid for GO/storm not initial mgmt.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'หญิงไทยอายุ 32 ปี ไม่มีโรคประจำตัว มาด้วยอาการอ่อนเพลีย ใจสั่น น้ำหนักลด 6 kg ใน 2 เดือน เหงื่อออกง่าย ทนร้อนไม่ได้ ประจำเดือนน้อยลง ตาโปนเล็กน้อย

V/S: BP 142/74, HR 118 (irregular AF), RR 18, Temp 37.2°C
PE: warm moist skin, fine tremor, diffuse goiter with bruit, lid lag, proptosis bilateral, no pretibial myxedema

Lab: TSH < 0.01, Free T4 4.8 (high), Free T3 18 (high), TRAb (TSH-receptor antibody) positive at 14 IU/L, anti-TPO positive
CBC normal, LFT normal, Cr 0.7
Thyroid US: diffuse hypervascular goiter, no nodule
Thyroid uptake (RAIU) 65% (high), homogeneous';

update public.mcq_questions
set choices = '[{"label":"A","text":"IV NaHCO3 ทันทีเพื่อ correct acidosis"},{"label":"B","text":"Diabetic ketoacidosis (severe)"},{"label":"C","text":"High-dose insulin IV bolus 10 U + start drip"},{"label":"D","text":"Stop all insulin until glucose normalizes"},{"label":"E","text":"D5W IV main fluid replacement"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Diabetic ketoacidosis (severe) — IV fluid 1-1.5 L NSS bolus then 250-500 mL/hr (switch to ½NS when Na ≥ 135 corrected); IV regular insulin 0.1 U/kg/hr infusion (NO bolus — recent ADA guidance) — check K BEFORE insulin (if K < 3.3 → hold insulin, give K first), add dextrose when glucose < 250 (continue insulin to clear ketones); replace K (target 4-5 mEq/L); identify trigger (infection, missed insulin); transition to SC basal-bolus when AG closed + bicarb > 18 + tolerating PO (overlap 2 hr); avoid bicarbonate routinely (only if pH < 6.9)

---

Severe DKA — pH < 7.0 (or HCO3 < 10 + AG > 12 + ketones positive + hyperglycemia). ADA 2024 + JBDS DKA guideline: (1) Fluid first — typically dehydrated 5-7 L deficit; NSS 1-1.5 L/hr × 1-2 hr then 250-500 mL/hr; switch to 0.45% NS when serum Na corrected ≥ 135. (2) Insulin infusion 0.1 U/kg/hr; NO bolus per recent ADA recommendation (no benefit, increased hypoglycemia/hypokalemia). (3) Pre-insulin K check: < 3.3 → hold insulin + K replacement; 3.3-5.3 → add K 20-30 mEq/L IVF; > 5.3 → no K, recheck. (4) Add D5/D10 when glucose < 200-250 — to allow continued insulin clearing ketones without hypoglycemia. (5) Bicarbonate: only pH < 6.9 (controversial — may worsen intracellular acidosis, cerebral edema). (6) Phosphate: replace if < 1.0 or symptomatic. (7) Identify precipitant: I''s — infection, infarction (MI), insulin omission, intoxication, infant (pregnancy), iatrogenic. (8) Transition: AG closed + HCO3 > 18 + tolerating PO → SC basal-bolus with 1-2 hr IV overlap before stopping drip. (9) Cerebral edema (rare adults, more peds): too rapid fluid/Na correction. A ผิด — bicarbonate not routine. C ผิด — bolus not recommended. D ผิด — insulin needed to clear ketones. E ผิด — D5W alone wrong; need NSS for volume.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'หญิงไทยอายุ 24 ปี underlying T1DM × 12 ปี on insulin glargine + lispro, history poor adherence ขาด insulin glargine 3 วัน + URI 4 วัน มา ED ด้วยปวดท้อง คลื่นไส้ อาเจียน หายใจเร็ว + ลึก สับสน

V/S: BP 96/62, HR 124, RR 32 Kussmaul, SpO2 98%, Temp 37.4°C
Gen: dry mucous membrane, fruity breath, lethargic GCS 13

Lab: Glucose 542 mg/dL, Na 132 (corrected 138), K 4.8, Cl 96, HCO3 9, Anion gap 27 (high), BUN 36, Cr 1.4 (baseline 0.7), Ketones (beta-hydroxybutyrate) 6.8 mmol/L, pH 7.12, PaCO2 16, pH 7.12
Urinalysis: ketones 4+, glucose 4+
Lactate 1.8, Mg 1.6, Phosphate 2.0
EKG: peaked T waves mild';

update public.mcq_questions
set choices = '[{"label":"A","text":"Oral hydrocortisone 20 mg + discharge with prednisolone refill"},{"label":"B","text":"Adrenal crisis (secondary AI from chronic exogenous glucocorticoid + abrupt withdrawal + concurrent stress/infection)"},{"label":"C","text":"Fludrocortisone alone"},{"label":"D","text":"Defer steroid until ACTH stim test result"},{"label":"E","text":"IV dexamethasone alone (no mineralocorticoid activity)"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Adrenal crisis (secondary AI from chronic exogenous glucocorticoid + abrupt withdrawal + concurrent stress/infection) — Immediate IV hydrocortisone 100 mg bolus then 50 mg q6h (or continuous 200 mg/24h) + IV NSS 1-2 L bolus + D5/D50 for hypoglycemia + identify and treat trigger (suspect infection — cultures + empirical antibiotic) + correct electrolytes + DO NOT delay steroids for ACTH stimulation test in crisis; transition to oral hydrocortisone 15-25 mg/d divided when stable + sick-day rules education + MedAlert; mineralocorticoid replacement (fludrocortisone) NOT needed in secondary AI (intact aldosterone)

---

Adrenal crisis — life-threatening due to glucocorticoid deficiency + stress trigger. Endocrine Society 2016 + recent Bornstein guidelines: (1) Diagnosis: hypotension + hypoglycemia + hyponatremia ± hyperkalemia + nonspecific symptoms; cortisol < 5 inappropriate during stress. ACTH: high in primary AI (Addison), low in secondary (pituitary/exogenous steroid suppression). Hyperpigmentation only in primary (high ACTH/MSH). (2) Treatment in crisis — DON''T DELAY for testing: - IV hydrocortisone 100 mg bolus then 50 mg q6h or 200 mg/24h infusion (provides both gluco + some mineralocorticoid effect at high dose). - IV fluid NSS 1-2 L over 1 hr; D5 if hypoglycemia. - Treat precipitant (infection most common). - Correct K, glucose. (3) Stress dose for known AI: triple oral dose for minor illness; IV hydrocortisone for major stress/surgery. (4) Iatrogenic 2° AI from chronic steroid > 3 wk of > 5 mg prednisolone — taper gradually, education. (5) ACTH stimulation (cosyntropin 250 mcg, cortisol at 30/60 min) deferred to non-crisis. (6) Patient education + MedAlert + glucagon/dex IM rescue kit. A ผิด — crisis = IV not oral. C ผิด — fludrocortisone alone misses GC. D ผิด — never delay treatment. E ผิด — dexamethasone OK in acute (no false ACTH interference) but lacks mineralocorticoid activity needed; hydrocortisone preferred in crisis.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'ชายไทยอายุ 58 ปี underlying chronic asthma on prednisolone 10 mg/d × 2 ปี (ผู้ป่วยพยายามหยุดยาเอง 1 สัปดาห์ก่อน) มา ED ด้วยอ่อนเพลียมาก คลื่นไส้ อาเจียน ปวดท้อง วิงเวียน + เป็นลม

V/S: BP 78/48 (orthostatic +), HR 124, RR 22, SpO2 96%, Temp 38.4°C, Glucose 58 mg/dL
PE: lethargic, dry mucous membrane, abdomen soft mild diffuse tender, no peritonitis, hyperpigmentation NOT present (secondary AI from chronic steroid)

Lab: Na 126, K 5.4, Cl 92, HCO3 18, BUN 38, Cr 1.6, Glucose 58, Ca 9.6
Cortisol 8 AM = 2.4 mcg/dL (low), ACTH undetectable (suggesting secondary)
WBC 11,200 with eosinophilia 8%';

update public.mcq_questions
set choices = '[{"label":"A","text":"Stop only ACEi + oral kayexalate + observe"},{"label":"B","text":"Severe symptomatic hyperkalemia with EKG changes"},{"label":"C","text":"IV NaHCO3 alone"},{"label":"D","text":"Oral resin alone for rapid effect"},{"label":"E","text":"Defer dialysis until K > 8"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe symptomatic hyperkalemia with EKG changes — Step 1: IV calcium gluconate 10% 10 mL over 2-3 min (membrane stabilization, onset 1-3 min, lasts 30-60 min — repeat if EKG persists); Step 2 shift K intracellular: IV insulin 10 U + D50 50 mL + IV salbutamol nebulized 10-20 mg + IV NaHCO3 if acidemia; Step 3 remove K: IV furosemide (if making urine) + new K-binders (patiromer or sodium zirconium cyclosilicate — onset hours; preferred over kayexalate due to colonic necrosis risk); urgent hemodialysis if refractory, severe, anuric, or ESRD; STOP ACEi + spironolactone; cardiac monitor

---

Severe hyperkalemia (K > 6.5 with EKG changes = emergency). KDIGO 2022 + UK Renal Association + ERA-EDTA guideline: (1) Stabilize myocardium: IV calcium gluconate 10% 10 mL (or CaCl 10% 5-10 mL via central) — onset minutes, duration 30-60 min, repeat if EKG persists. No K-lowering effect — just antagonizes membrane effect. (2) Shift K intracellular (temporary 1-6 hr): - Insulin 10 U IV + D50 50 mL (or D10 infusion if not fasting) — lowers 0.5-1.2 mEq/L. - Beta-2 agonist (nebulized salbutamol 10-20 mg) — lowers 0.5-1 mEq/L; synergistic with insulin. - NaHCO3 if acidemia (HCO3 < 22) — modest effect; not for routine. (3) Remove K (definitive): - Loop diuretic (furosemide) if making urine. - K-binders: patiromer (Veltassa), sodium zirconium cyclosilicate (Lokelma) — onset hours, suitable for chronic. - Sodium polystyrene sulfonate (Kayexalate) — slower, risk colonic necrosis (esp with sorbitol); falling out of favor. - Hemodialysis: refractory hyperkalemia, ESRD, oligo/anuric, severe/symptomatic. (4) Address cause: stop K-elevating drugs (ACEi, ARB, MRA, NSAIDs, TMP-SMX); dietary advice; correct acidosis. A ผิด — incomplete + slow. C ผิด — bicarb alone insufficient. D ผิด — resin onset too slow for emergency. E ผิด — K 7.6 + EKG = act now.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'ชายไทยอายุ 65 ปี underlying CKD stage 4 (eGFR 22), DM, HT มา ED ด้วยอ่อนแรง ใจสั่น + EKG พบ peaked T waves + wide QRS

V/S: BP 138/82, HR 64, RR 18, SpO2 97%
PE: 2+ pedal edema, lung clear
Lab: K 7.6 mEq/L (acute), Na 138, Cl 102, HCO3 18, Cr 4.8 (baseline 3.5), Glucose 124, Ca 9.0, Mg 2.0
ABG: pH 7.30
EKG: peaked T waves V2-V5, PR interval prolonged, QRS 130 ms (widened), no sine wave yet
Recent: เพิ่ม lisinopril + spironolactone 4 วันก่อนเพราะ BP control';

update public.mcq_questions
set choices = '[{"label":"A","text":"3% hypertonic saline aggressive bolus เพื่อ correct rapidly to 138"},{"label":"B","text":"Euvolemic hyponatremia consistent with SIADH (euvolemic + urine Na > 30 + urine osm > 100 + low BUN/uric acid; normal thyroid/cortisol/renal)"},{"label":"C","text":"Demeclocycline ทันทีเป็น first-line"},{"label":"D","text":"Free water IV กลับมาทันที"},{"label":"E","text":"ไม่ต้องทำอะไร — Na 122 asymptomatic ปลอดภัย"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Euvolemic hyponatremia consistent with SIADH (euvolemic + urine Na > 30 + urine osm > 100 + low BUN/uric acid; normal thyroid/cortisol/renal) — possibly drug-induced (SSRI sertraline very common cause; also rule out pulmonary disease itself) — Management: (1) Asymptomatic chronic (> 48 hr) — fluid restriction 800-1000 mL/d as first-line; (2) Treat underlying — stop sertraline if feasible, HCTZ; (3) If inadequate response → salt tabs + furosemide, urea, vaptan (tolvaptan) for refractory; (4) Severe symptomatic (seizure, coma) → 3% saline 100 mL bolus × up to 3; correction rate limit 6-8 mEq/L per 24 hr to avoid osmotic demyelination (especially when chronic + risk factors like alcoholism, malnutrition, hypokalemia)

---

SIADH — euvolemic hyponatremia with inappropriately concentrated urine despite serum hypotonicity. Diagnostic criteria (Bartter-Schwartz): hyponatremia, plasma osm < 275, urine osm > 100, urine Na > 30, euvolemia, normal thyroid/adrenal/renal, no diuretic use (HCTZ here is confounder — hypovolemic hyponatremia). European hyponatremia guideline 2014 + Verbalis NEJM 2013: (1) Severity: severe (Na < 125 or symptomatic seizure/coma) → 3% saline 100-150 mL bolus, repeat to ↑ Na 4-6 mEq/L. (2) Correction rate cap: < 8-10 mEq/L per 24 hr (some recommend 6); especially careful in chronic + risk factors → osmotic demyelination syndrome ("locked-in" 1-7 d after over-correction). (3) Asymptomatic/mild chronic SIADH: fluid restriction first; if inadequate add salt + furosemide, urea (effective + safe), vasopressin receptor antagonists (vaptans — tolvaptan, conivaptan). (4) Common SIADH causes: drugs (SSRI, carbamazepine, oxytocin, chemotherapy), CNS (stroke, hemorrhage, trauma, infection), pulmonary (pneumonia, TB, lung cancer SCLC paraneoplastic), nausea/pain/post-op. (5) Re-lowering with desmopressin if over-corrected. A ผิด — too rapid correction = ODS. C ผิด — demeclocycline obsolete (toxicity). D ผิด — worsens. E ผิด — Na 122 needs intervention.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'internal_medicine'
  and scenario = 'หญิงไทยอายุ 78 ปี admit ใน hospital × 5 วัน with pneumonia ตอนนี้ไข้ลดลง + ดีขึ้น แต่ ICU notes ระบุว่า Na ลดลงจาก 138 → 122 ใน 5 วันโดยที่ไม่มีอาการชัดเจน

V/S: BP 124/76, HR 78, euvolemic on exam (no edema, no orthostasis, no dry mucous membrane), Temp 37.4°C
Urine output 1.2 L/d
Lab: Na 122, K 4.0, Cl 88, HCO3 22, BUN 12, Cr 0.7, Glucose 102, Albumin 3.4, TSH 1.8, Cortisol 18
Urine Na 78 (high), Urine osm 480 (inappropriately concentrated relative to serum 252)
Uric acid 2.6 (low)
ผู้ป่วยรับยา: ceftriaxone, azithromycin (for pneumonia), oxycodone PRN pain, sertraline (chronic), HCTZ (chronic)';

commit;
