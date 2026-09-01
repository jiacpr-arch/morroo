-- ===============================================================
-- UPDATE chunk 2/8: anesthesiology (25 questions)
-- ===============================================================

begin;

update public.mcq_questions
set choices = '[{"label":"A","text":"Ignore"},{"label":"B","text":"Anesthesia Patient Safety Program"},{"label":"C","text":"Refuse safety measures"},{"label":"D","text":"Single specialty"},{"label":"E","text":"Random approach"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Anesthesia Patient Safety Program: (1) **APSF (Anesthesia Patient Safety Foundation)** leadership in anesthesia safety; (2) **Anesthesia mortality** reduced dramatically: from 1 per 5,000 (1960s) → 1 per 200,000 modern — model patient safety success in medicine; (3) **Key safety initiatives**: - **Standardized monitoring** (ASA standards 1986) — pulse ox, EKG, BP, EtCO2, temperature, vigilance; - **Difficult airway algorithm** + equipment availability; - **Crisis Resource Management (CRM)** training — communication, leadership, teamwork during emergencies; - **Simulation training** — realistic scenarios, debriefing; - **Pre-anesthesia checklists** (machine, equipment, drugs, patient identification, allergies, NPO); - **Time-out** before surgical incision (universal protocol — patient + site + procedure); - **Medication safety** — color-coded syringes, separate stations, pre-filled syringes, barcode scanning, electronic record; - **Closed-loop communication** — read-back of orders; - **Fatigue + handoff management** — duty hour limits, structured handoffs (SBAR, I-PASS); - **Quality improvement infrastructure** — case review, M&M, root cause analysis, blame-free reporting; - **APSF newsletter** + publications + funded research; (4) **Specific medication errors**: ampule confusion, similar labels (lookalike), wrong concentrations, wrong route (intrathecal vs IV), reversed drug → use prefilled syringes when possible; (5) **Technology**: anesthesia information management systems (AIMS), barcode scanning, smart pumps, computerized order entry; (6) **Culture of safety**: psychological safety, learning from errors, transparency, accountability; (7) **Multidisciplinary**: physicians, nurses, technicians, pharmacy, IT, administration; (8) **Continuous education + competency assessment**

---

Anesthesia patient safety: dramatic mortality reduction (1 per 5,000 → 1 per 200,000) — model of patient safety success. APSF leadership. ASA monitoring standards + difficult airway + CRM + simulation + checklists + time-out + medication safety + handoffs. Culture of safety. Technology aids. Modern: standard practice across hospitals.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Hospital implements patient safety + medication error reduction — anesthesia-specific';

update public.mcq_questions
set choices = '[{"label":"A","text":"More opioids"},{"label":"B","text":"Opioid Stewardship in Anesthesia"},{"label":"C","text":"Long-term opioids"},{"label":"D","text":"Refuse stewardship"},{"label":"E","text":"Single intervention"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Opioid Stewardship in Anesthesia: (1) **Public health context**: opioid crisis — 100,000+ overdose deaths/year US, fentanyl epidemic, persistent post-op opioid use → addiction; (2) **Perioperative opioid stewardship goals**: - Reduce opioid prescribing without compromising pain control; - Identify high-risk patients; - Multimodal analgesia; - Patient + family education; - Safe disposal of unused; - Surveillance + monitoring; (3) **Specific interventions**: - **Multimodal analgesia foundation** (acetaminophen + NSAID + gabapentinoid + ketamine + regional + steroid); - **Regional anesthesia** + neuraxial — opioid-sparing; - **ERAS protocols** include opioid-sparing; - **Surgeon-specific prescribing guidelines** (limited dose + days for specific procedures — e.g., open hernia 5-10 tabs total); - **Default prescribing** — change defaults in EMR (smaller quantities, lower doses); - **PDMP (Prescription Drug Monitoring Programs)** — check before prescribing; - **OUD screening** + treatment (don''t withhold pain control from OUD patients — multimodal + may need MAT); - **Naloxone co-prescription** for high-risk; - **Education**: physicians, residents, students; (4) **Patient education**: realistic expectations, side effects, addiction risks, safe storage + disposal, alternatives; (5) **Post-op pain management programs**: outpatient pain management, transitional pain service for high-risk; (6) **Surveillance**: opioid prescribing data, persistent use rates, ED visits + readmissions, satisfaction; (7) **Quality metrics**: opioid prescribing per case + procedure; (8) **Multidisciplinary**: anesthesia + surgery + pharmacy + nursing + addiction medicine + primary care + mental health; (9) **Modern paradigm**: less opioid is more — patient outcomes, addiction prevention

---

Opioid stewardship: anesthesia + perioperative response to opioid crisis. Multimodal analgesia + regional anesthesia + ERAS + PDMP + procedure-specific guidelines + default prescribing changes. Patient education + safe disposal. OUD screening + treatment. Modern: less opioid is more — patient outcomes + addiction prevention.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Hospital implements opioid stewardship in anesthesia + perioperative period — opioid crisis response';

update public.mcq_questions
set choices = '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Multimorbid Elderly Perioperative Integrative Care"},{"label":"C","text":"Refuse care"},{"label":"D","text":"Single intervention"},{"label":"E","text":"Discharge home"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Multimorbid Elderly Perioperative Integrative Care: (1) **Pre-op multidisciplinary assessment**: orthopedics + anesthesia + geriatric medicine + cardiology + nephrology + endocrinology + PT + nutrition + social work; (2) **Comprehensive Geriatric Assessment (CGA)**: medical + functional + cognitive + nutritional + psychosocial + medications (Beers, STOPP/START); (3) **Goals of care discussion**: balance benefits vs risks; advance directives; family + patient values; outcomes-focused (function, QOL, mortality); (4) **Optimization without delaying urgent surgery**: HF (loop diuretic + ACE/ARB optimize cautious), CKD (avoid nephrotoxic + hydration), DM (glycemic control + hold metformin), frailty (nutrition, prehabilitation if elective); (5) **Anesthetic plan**: regional or neuraxial preferred (REGAIN trial mixed — local + anesthesia preference); multimodal + opioid-sparing; less sedation; (6) **Hemodynamic monitoring**: invasive in high-risk (arterial line); maintain MAP > 65, individualized; volume status balance; (7) **Delirium prevention**: HELP elements (orientation, mobility, sleep, hearing/vision aids, family); avoid Beers meds; ABCDEF in ICU if applicable; (8) **Post-op**: ortho-geriatric co-management — Cochrane evidence reduces mortality; multidisciplinary rounds; early mobilization; nutrition; PT/OT; pain control opioid-sparing; (9) **Discharge planning early**: home with services vs rehab vs SNF; family + social support; (10) **Secondary prevention**: osteoporosis, fall prevention, CV; (11) **Family + caregiver engagement**: support, education, decision-making; (12) **Long-term**: rehabilitation, function, follow-up; quality of life focus

---

Multimorbid elderly perioperative care = quintessential integrative + multidisciplinary. CGA + goals of care + optimization (not delaying urgent). Anesthetic choice individualized. Hemodynamic + delirium prevention. Ortho-geriatric co-management evidence-based. Family engagement. Long-term function focus. Modern: multidisciplinary team approach standard.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยอายุ 78 ปี multimorbid (HF + CKD + DM + frailty + cognitive impairment) coming for hip surgery — complex perioperative + multidisciplinary care';

update public.mcq_questions
set choices = '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Complex Spine Surgery Integrative Care"},{"label":"C","text":"Refuse"},{"label":"D","text":"Single specialty"},{"label":"E","text":"Discharge"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Complex Spine Surgery Integrative Care: (1) **Pre-op multidisciplinary**: spine surgery + anesthesia + neuro monitoring + oncology + IR (potentially preoperative embolization) + ICU + rehabilitation + pain management + psychology + nutrition + social work; (2) **Pre-op planning**: imaging review, blood + products availability, autologous blood storage, cell saver, vascular access planning; (3) **Anesthetic plan**: TIVA for neuromonitoring (avoids volatile interference); positioning (prone or other) considerations + pressure injury prevention; (4) **Neurophysiologic monitoring (IONM)**: MEPs (motor evoked potentials), SSEPs (somatosensory), EMG — detect early nerve injury; requires TIVA + careful muscle relaxant; (5) **Massive blood loss management**: TXA (loading + infusion); cell saver; balanced transfusion; permissive hypotension cautious in spine — blood loss vs cord perfusion balance; point-of-care testing (ROTEM/TEG); fibrinogen monitoring; (6) **Hemodynamic management**: MAP > 80-85 to maintain cord perfusion + brain; arterial line + CVL + possibly TEE; vasopressors as needed; (7) **Lung-protective ventilation**: TV 6 mL/kg IBW + PEEP; particular consideration in prone position; (8) **Temperature**: normothermia; warming devices; (9) **Pain control**: regional (epidural, paravertebral, ESP); IV ketamine; multimodal opioid-sparing; (10) **Post-op**: ICU monitoring; neurological exam frequent; (11) **Rehabilitation**: early; spine precautions; PT + OT; (12) **Psychological support + family**: anxiety, depression, prolonged recovery; (13) **Long-term**: chronic pain + functional + tumor surveillance + oncology follow-up + transition planning

---

Complex spine surgery = integrative multidisciplinary. TIVA for IONM. Massive transfusion + cell saver. MAP maintenance for cord perfusion. Regional + multimodal pain. Prone positioning considerations. Post-op ICU + frequent neuro checks. Rehabilitation + psychological. Long-term oncology follow-up. Modern: highly coordinated multidisciplinary care.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยอายุ 40 ปี undergoing major spine surgery for tumor resection — long surgery + complex monitoring + transfusion + neuro monitoring + chronic pain management';

update public.mcq_questions
set choices = '[{"label":"A","text":"Withhold methadone"},{"label":"B","text":"OUD on Methadone Perioperative Care"},{"label":"C","text":"More opioid only"},{"label":"D","text":"Refuse pain control"},{"label":"E","text":"Detox emergent"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** OUD on Methadone Perioperative Care: (1) **Continue methadone** for OUD treatment — do NOT stop; coordinate dose timing with surgery (last dose timing affects pain management); withholding precipitates withdrawal + worsens outcomes; (2) **Tolerance considerations**: increased opioid requirements vs opioid-naive (3-4× typical doses); standard doses inadequate; (3) **Multimodal opioid-sparing primary**: acetaminophen + NSAID + gabapentinoid + ketamine (excellent for OUD + chronic pain) + regional anesthesia + dexmedetomidine + dexamethasone; (4) **Acute pain on top of methadone**: short-acting opioid for breakthrough (PCA hydromorphone, fentanyl); higher doses than opioid-naive; (5) **Regional anesthesia** maximally utilized — neuraxial, peripheral nerve blocks, continuous catheters; (6) **NMDA antagonist**: ketamine infusion (anti-hyperalgesic + opioid-sparing) — particularly useful in OUD; (7) **Pain medicine + addiction medicine consult**; (8) **Behavioral**: address anxiety, recognize withdrawal symptoms, prevent precipitated withdrawal, supportive care; (9) **Discharge planning** carefully: transition off short-acting opioid back to methadone alone; multimodal + non-opioid continue; close follow-up; (10) **Avoid pain-medicine ''orphaning''** — addiction medicine + acute pain + chronic pain coordination; (11) **Stigma**: address — OUD = chronic illness, patient deserves appropriate pain management; (12) **Modern**: integrated dual treatment, multidisciplinary, addiction + pain specialists working together; (13) **Naltrexone challenges**: NOT in this case (methadone) but if on naltrexone — must address blocking of opioid effects

---

OUD on methadone perioperative: CONTINUE methadone. Tolerance — higher opioid doses for breakthrough. Multimodal opioid-sparing primary (regional, ketamine, multimodal). Addiction + pain medicine coordination. Stigma awareness. Modern: integrated care + appropriate pain control + addiction treatment maintained. Patient deserves humane care.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยอายุ 60 ปี OUD on methadone — going for emergency surgery + multidisciplinary pain management challenge';

update public.mcq_questions
set choices = '[{"label":"A","text":"Cancel surgery for ICU bed"},{"label":"B","text":"COPD perioperative optimization (ASA + ATS)"},{"label":"C","text":"Stop all bronchodilators pre-op"},{"label":"D","text":"Use desflurane mandatory"},{"label":"E","text":"Refuse anesthesia"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** COPD perioperative optimization (ASA + ATS): (1) Continue inhaled bronchodilators perioperative (LABA + LAMA + ICS); pre-op nebulized albuterol on call to OR; (2) Smoking cessation > 8 weeks ideal (4-8 weeks may transiently increase secretions); (3) Pulmonary rehab if time allows; (4) Treat exacerbation with antibiotic + steroid before elective surgery; (5) Anesthetic plan — regional (spinal/epidural) preferred for TURP (avoid GA + intubation); if GA needed: avoid histamine-releasing agents (atracurium, morphine, thiopental), use sevoflurane (bronchodilator), avoid desflurane (airway irritant); (6) Ventilation strategy: lung-protective TV 6-8 mL/kg, PEEP 5-8, prolonged I:E ratio to allow expiration, permissive hypercapnia, avoid auto-PEEP; (7) Post-op pulmonary toilet, incentive spirometry, early mobilization, multimodal opioid-sparing analgesia; (8) Risk stratification using ARISCAT score; (9) Document baseline ABG; (10) Consider neuraxial-only technique

---

COPD pre-op: continue inhalers, optimize before elective surgery, choose regional > GA, lung-protective ventilation, sevoflurane > desflurane (airway irritant), multimodal analgesia post-op. ARISCAT for risk stratification.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 72 ปี ASA III, hypertension, COPD GOLD 2 — elective TURP
Meds: amlodipine, tiotropium, salmeterol-fluticasone
Functional capacity 5 METs, room air SpO2 94%
PFT: FEV1 65%, FEV1/FVC 0.62
CXR: hyperinflation
ABG: pH 7.40, PaCO2 44, PaO2 72';

update public.mcq_questions
set choices = '[{"label":"A","text":"Proceed with surgery immediately"},{"label":"B","text":"ESRD pre-op management"},{"label":"C","text":"Give succinylcholine for RSI"},{"label":"D","text":"Use morphine PCA only"},{"label":"E","text":"Mass IV crystalloid bolus"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** ESRD pre-op management: (1) Hyperkalemia 6.2 + ECG changes = urgent dialysis BEFORE surgery; delay 6-12h post-HD ideal (avoid volume depletion + heparin effect); (2) If can''t delay: medical treatment — calcium gluconate 1g (membrane stabilization), insulin 10U + D50 (shift K intracellular), beta-2 agonist nebulizer, sodium bicarb if acidotic, kayexalate; (3) Anesthetic considerations: avoid succinylcholine (further K release ~0.5-1 mEq/L); use rocuronium (renal-independent for cisatracurium — Hofmann elimination preferred); avoid morphine (M6G metabolite accumulates) — use fentanyl/hydromorphone; (4) Volume: cautious — fluid overload risk; isotonic crystalloid only as needed; avoid LR if K elevated (K 4 mEq/L); (5) Regional anesthesia for AV fistula = excellent choice (brachial plexus block — avoid GA); (6) Protect contralateral arm — no BP cuff, IV, or arterial line on AV fistula side; (7) Monitor — careful CV, electrolytes; (8) Post-op HD schedule planning

---

ESRD + hyperkalemia: dialyze before elective surgery. Avoid succinylcholine + morphine. Cisatracurium preferred NMB. Regional anesthesia ideal for AV fistula. Protect fistula arm. Cautious fluid management.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 65 ปี ASA III ESRD on HD MWF — elective AV fistula revision วันจันทร์
Last HD วันศุกร์
Meds: amlodipine, EPO, calcitriol, sevelamer
Lab: K 6.2, Cr 8.4, Hb 9.8, normal coagulation
ECG: peaked T waves';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue normal insulin + metformin"},{"label":"B","text":"Diabetic perioperative glycemic management"},{"label":"C","text":"Stop all insulin pre-op"},{"label":"D","text":"Give double dose insulin"},{"label":"E","text":"Use D10 infusion routinely"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Diabetic perioperative glycemic management: (1) Hold metformin morning of surgery (risk lactic acidosis if AKI develops); resume when eating + renal function stable; (2) Long-acting insulin (glargine) — give 50-80% of usual dose night before or morning of surgery (basal coverage needed despite NPO); (3) Hold short-acting prandial insulin while NPO; (4) Hold SGLT2 inhibitors 3 days pre-op (euglycemic DKA risk); (5) Target intraop glucose 140-180 mg/dL (avoid hypoglycemia + severe hyperglycemia); use insulin infusion if persistently > 180; (6) Check glucose q1-2h intraop, q4h post-op; (7) Schedule diabetic patients FIRST CASE to minimize NPO duration; (8) Resume oral hypoglycemics when eating + tolerating + renal OK; (9) Avoid dextrose-containing fluids unless hypoglycemic; (10) HbA1c > 8.5% — consider delay elective surgery for optimization (increased SSI risk); (11) DKA + HHS — delay all elective until resolved

---

DM perioperative: hold metformin + short-acting insulin, 50-80% basal insulin, target 140-180, first case scheduling, hold SGLT2i 3 days. HbA1c > 8.5% consider delay.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 58 ปี DM T2 on insulin glargine 30U HS + metformin — elective hip replacement
HbA1c 8.4%, FBS 165
ไม่มี microvascular complications
NPO since midnight';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait 5 days for warfarin clearance"},{"label":"B","text":"Anticoagulant reversal for urgent hip surgery"},{"label":"C","text":"Heparin bridging only"},{"label":"D","text":"Proceed without reversal"},{"label":"E","text":"Cancel surgery"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Anticoagulant reversal for urgent hip surgery: (1) Hip fracture surgery < 48h reduces mortality + morbidity per international guidelines; (2) Warfarin reversal — Vitamin K 5-10 mg IV (12-24h onset) + 4-factor PCC (Kcentra) 25-50 U/kg INR-based dosing (immediate reversal); avoid FFP if PCC available (volume + slower); (3) Apixaban (DOAC) — andexanet alfa (specific reversal) if within hours of last dose; otherwise PCC 50 U/kg empirically; check apixaban level if available; last dose timing critical (half-life 12h with normal renal); (4) ASA 81mg — continue (cardiovascular protection > minor bleeding risk in hip surgery); (5) Neuraxial anesthesia — DOAC requires 24-48h hold (longer with renal impairment); residual DOAC contraindicates neuraxial — use GA; (6) Type + cross blood products; (7) Restart anticoagulation post-op when hemostasis confirmed — bridge with LMWH while warfarin retitrated; DOAC restart 24-72h depending on bleeding risk; (8) Multidisciplinary: anesthesia + ortho + cardiology + hematology

---

Hip fracture < 48h reduces mortality. Warfarin: PCC + vit K. DOAC: andexanet or PCC. Continue ASA. DOAC contraindicates neuraxial (24-48h hold). Restart anticoagulation post-op after hemostasis.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 78 ปี ASA III — fragility hip fracture
Meds: warfarin (AFib), apixaban changed by GP, ASA 81mg
INR 2.4, weight 60 kg, eGFR 45
ต้องผ่าตัด < 48 ชม. per orthopedic guidelines';

update public.mcq_questions
set choices = '[{"label":"A","text":"Proceed immediately"},{"label":"B","text":"Hyperthyroid pre-op optimization"},{"label":"C","text":"Stop methimazole + propranolol"},{"label":"D","text":"Use ketamine for induction"},{"label":"E","text":"Refuse referral"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hyperthyroid pre-op optimization: (1) Elective surgery — should be euthyroid first (TSH normal, FT4/FT3 normal, HR < 90 rest) to prevent thyroid storm; (2) Methimazole continued for at least 6 weeks (until euthyroid); (3) Beta-blocker (propranolol 20-40 mg q6h) to control HR + symptoms; preferred — non-selective (blocks T4→T3 conversion); (4) If urgent surgery + hyperthyroid: Lugol''s iodine 5 drops TID (Wolff-Chaikoff effect) + hydrocortisone + propranolol; (5) Thyroid storm precipitants intra-op: surgery itself, infection, DKA, trauma, anesthesia stress; (6) Anesthetic choice: avoid sympathomimetic (ephedrine, ketamine) — use phenylephrine; avoid pancuronium (vagolytic); use rocuronium/cisatracurium; (7) Adequate depth anesthesia critical (stress response); (8) Thyroid storm treatment: PTU 600-1000mg loading + 250mg q4h (blocks synthesis + conversion); beta-blocker (esmolol IV infusion); hydrocortisone 100mg q8h; iodine (Lugol''s after PTU); cooling; supportive care ICU; (9) Recommend delay until euthyroid (FT4 normal)

---

Hyperthyroid + elective surgery: euthyroid first (prevent thyroid storm). Continue methimazole + beta-blocker. Urgent: add Lugol''s + steroid. Avoid sympathomimetics + ketamine + pancuronium. Storm: PTU + esmolol + steroid + cooling + Lugol''s.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 45 ปี hyperthyroid Graves'' disease — elective cholecystectomy
Meds: methimazole 10mg TID × 6 weeks, propranolol 40mg BID
TSH 0.05, FT4 1.5 (slightly elevated), HR 92, BP 130/75
Thyroid still mildly enlarged';

update public.mcq_questions
set choices = '[{"label":"A","text":"Proceed without modification"},{"label":"B","text":"Anthracycline cardiotoxicity perioperative"},{"label":"C","text":"Use high-dose propofol bolus"},{"label":"D","text":"Aggressive fluid loading"},{"label":"E","text":"Skip echo"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Anthracycline cardiotoxicity perioperative: (1) Doxorubicin cumulative dose > 240 mg/m2 — risk cardiomyopathy increasing dose-dependent (5% at 400 mg/m2, 26% at 550 mg/m2); (2) Late cardiotoxicity (years after) — irreversible dilated cardiomyopathy; current LVEF 40% confirms; (3) Pre-op: Echo + BNP + cardiology consult; consider stress imaging; (4) Optimize HF treatment — ACEi/ARB, beta-blocker (carvedilol/metoprolol succinate), MRA, SGLT2i; loop diuretic if congested; ideally optimized 4-6 weeks pre-op; (5) Anesthetic plan — invasive monitoring (arterial line ± CVP/TEE for major case); maintain preload + afterload; (6) Drug choices — avoid myocardial depressants in high doses; etomidate for induction (CV stable) > propofol; opioid-based maintenance; (7) Cardiac output monitoring (esophageal Doppler, pulse contour); (8) Cautious fluid — avoid overload; (9) Multimodal analgesia + regional to reduce stress response; (10) Post-op ICU/step-down; (11) Modern: dexrazoxane prophylaxis for high-dose anthracycline; cardio-oncology programs

---

Anthracycline cardiomyopathy: dose-dependent, late onset, irreversible. Optimize HF treatment pre-op. Etomidate > propofol for induction. Invasive monitoring. Avoid fluid overload. Cardio-oncology consultation.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 55 ปี ASA II, history breast cancer mastectomy + chemotherapy (doxorubicin 240 mg/m2 cumulative) 8 ปีที่แล้ว — elective abdominal surgery
Echo ปัจจุบัน LVEF 40% (baseline 60% pre-chemo)
Mild DOE NYHA II';

update public.mcq_questions
set choices = '[{"label":"A","text":"Spinal anesthesia for ease"},{"label":"B","text":"Severe AS perioperative anesthesia"},{"label":"C","text":"Aggressive vasodilator"},{"label":"D","text":"Beta-blocker bolus high dose"},{"label":"E","text":"Bupivacaine spinal full dose"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe AS perioperative anesthesia: (1) Severe AS = high CV risk noncardiac surgery (mortality 10% major surgery); (2) Symptomatic severe AS — consider AVR/TAVR FIRST if surgery elective + delayable; if urgent: proceed with intensive monitoring; (3) Hemodynamic goals: maintain SINUS RHYTHM (atrial kick critical 30-40% CO), avoid TACHYCARDIA (reduces diastolic filling time + coronary perfusion), maintain PRELOAD + AFTERLOAD (SVR — coronary perfusion pressure), avoid HYPOTENSION (coronary supply-demand mismatch); (4) Anesthetic technique — neuraxial RELATIVELY CONTRAINDICATED (sympathectomy → drop SVR → cardiac arrest risk); GA preferred OR carefully titrated epidural (slow onset, T10 level, phenylephrine ready) or local + sedation; (5) Induction — etomidate (CV stable) + opioid; avoid propofol bolus; (6) Phenylephrine first-line vasopressor (alpha-1, maintains SVR + reflex bradycardia OK); (7) Invasive monitoring — arterial line MANDATORY; (8) Treat arrhythmia aggressively — cardioversion AFib immediately if hemodynamic compromise; (9) Maintain coronary perfusion pressure (MAP - LVEDP); (10) Multidisciplinary: cardiology + anesthesia + surgery; consider TAVR before elective non-cardiac if possible

---

Severe AS hemodynamic goals: maintain SR, preload, afterload, avoid tachy. Neuraxial relatively contraindicated. Phenylephrine first-line. Arterial line mandatory. Consider TAVR before elective non-cardiac.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 70 ปี severe aortic stenosis (AVA 0.7 cm², peak gradient 65 mmHg, mean 42) — elective inguinal hernia repair
Class II-III symptoms, LVEF 55%
ไม่ใช่ candidate TAVR ทันที';

update public.mcq_questions
set choices = '[{"label":"A","text":"Awake fiberoptic intubation only option"},{"label":"B","text":"Rapid Sequence Induction (RSI) modified"},{"label":"C","text":"Slow inhalational induction"},{"label":"D","text":"Skip pre-oxygenation"},{"label":"E","text":"Mass bag-mask ventilation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Rapid Sequence Induction (RSI) modified: (1) Indications — full stomach, GERD, obstetric, trauma, ileus, emergency; (2) Preparation — suction working, multiple ETT sizes, video laryngoscope, bougie, SGA backup; team briefing; (3) Pre-oxygenation — 100% O2 × 3-5 min or 8 vital capacity breaths (target ETO2 > 90%); ramped position obese (HELP — Head Elevated Laryngoscopy Position); apneic oxygenation via NC 15 L/min during apnea (NODESAT); (4) Pre-treatment — analgesia (fentanyl 1-2 mcg/kg); lidocaine 1.5 mg/kg optional; (5) Induction — propofol 1.5-2.5 mg/kg OR etomidate 0.3 mg/kg (hemodynamic instability) OR ketamine 1-2 mg/kg (shock); (6) Paralysis — succinylcholine 1-1.5 mg/kg (fast onset 45-60s) OR rocuronium 1.2 mg/kg (alternative if sux contraindicated; sugammadex reversal); (7) Cricoid pressure (Sellick) — controversial; may worsen view + recent evidence less robust; selectively applied + released if difficult intubation; (8) NO bag-mask ventilation (avoid gastric insufflation) — unless desaturating, then GENTLE low-pressure; (9) Intubate — video laryngoscope first-pass success higher; (10) Confirm — EtCO2, bilateral breath sounds; (11) OG/NG decompression post-intubation; (12) RSI modifications obese: HELP position, pre-O2 + PEEP, apneic oxygenation, ETT cuff inflation immediately

---

RSI for full stomach: pre-O2, apneic O2 (NODESAT), HELP position obese, propofol/etomidate/ketamine + succinylcholine/rocuronium, video laryngoscopy, EtCO2 confirm. Cricoid controversial. NO ventilation unless desaturating.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 60 ปี BMI 42, full stomach (last meal 2h ago) trauma, emergent appendectomy
Mallampati III, neck mobility ลดลง mild, thyromental 6 cm, no beard
SpO2 96% RA, BP 138/82';

update public.mcq_questions
set choices = '[{"label":"A","text":"Full neck extension for direct laryngoscopy"},{"label":"B","text":"Unstable C-spine airway management"},{"label":"C","text":"Blind nasotracheal forceful"},{"label":"D","text":"Remove cervical collar fully"},{"label":"E","text":"Surgical airway first"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Unstable C-spine airway management: (1) Goal — minimize cervical spine movement during intubation (avoid worsening cord injury); (2) Manual In-Line Stabilization (MILS) — assistant maintains neutral position by holding head + mastoids during intubation; FRONT of collar removed (back stays); (3) Pre-oxygenation thorough; (4) Awake fiberoptic intubation — gold standard for known unstable C-spine — minimal neck movement + neuro check before + after; sedation (dexmedetomidine, remifentanil) + topical airway anesthesia; (5) Alternative — video laryngoscopy (GlideScope, McGrath, C-MAC) — better view with neutral position; (6) Direct laryngoscopy with MILS — option if other unavailable but increased difficulty; (7) AVOID — vigorous neck extension/flexion, blind techniques, nasal intubation if facial fracture; (8) RSI considerations — if full stomach + emergency: modified RSI with MILS + video laryngoscopy; (9) Equipment ready — multiple airway devices, surgical airway kit; (10) Post-intubation — neuro exam if possible, re-secure collar, document; (11) Cricoid pressure: applied carefully (may worsen C-spine alignment); (12) Multidisciplinary: anesthesia + neurosurgery + trauma

---

Unstable C-spine: MILS during intubation, awake fiberoptic gold standard, video laryngoscopy alternative. Front of collar removed only. Avoid vigorous neck movement. Multidisciplinary care.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 50 ปี C5-C6 fracture from MVC requires emergency exploratory laparotomy
Cervical collar in place, GCS 14
Airway secured needs intubation
Known unstable C-spine';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue current ventilation"},{"label":"B","text":"Intraoperative bronchospasm DDx + Mx"},{"label":"C","text":"Disconnect ventilator without action"},{"label":"D","text":"Stop volatile + extubate"},{"label":"E","text":"Beta-blocker IV"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Intraoperative bronchospasm DDx + Mx: (1) DDx — bronchospasm (asthma, COPD, anaphylaxis), endobronchial intubation, ETT obstruction (mucus plug, kink), pneumothorax, pulmonary edema, aspiration; (2) Immediate — 100% O2, hand ventilate to feel compliance, check ETT position (auscultate bilaterally, CXR if available, capnogram shark-fin shape = bronchospasm); (3) Deepen anesthesia — sevoflurane (bronchodilator), propofol bolus, ketamine (bronchodilator) 0.5-1 mg/kg; (4) Bronchodilators — salbutamol nebulizer via ETT or MDI 4-8 puffs through circuit (use spacer); ipratropium nebulizer; (5) IV — magnesium sulfate 2g over 20min, hydrocortisone 100mg or methylprednisolone, aminophylline (rarely); (6) Epinephrine — for severe (anaphylaxis or refractory): 10-100 mcg IV titrated; (7) Ventilation strategy — prolonged expiration (low rate, longer I:E 1:3 or 1:4), TV 6 mL/kg, permissive hypercapnia, watch for auto-PEEP; disconnect circuit to allow exhalation if severe air-trapping; (8) Check for anaphylaxis features — hypotension, urticaria, angioedema; (9) Rule out pneumothorax — auscultation, US, CXR; (10) If anaphylaxis suspected: epinephrine + steroid + antihistamine + fluid + cessation trigger; (11) Document + plan for future anesthetic

---

Intraop bronchospasm: deepen anesthesia (sevoflurane, propofol, ketamine), bronchodilators inhaled + IV, magnesium, steroid. Severe = epinephrine. Long expiration. Rule out anaphylaxis + pneumothorax + ETT issues.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'GA case 45 ปี, intubated successfully with rocuronium
หลังจาก 5 นาที, SpO2 ลดลง 99 → 88%, ETCO2 ค่อยๆ rising 35 → 48, airway pressure increasing 22 → 35 cmH2O, wheezing bilateral, breath sounds decreased
No cardiovascular compromise';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue attempts until succeed"},{"label":"B","text":"DAS Obstetric Failed Intubation algorithm"},{"label":"C","text":"Tracheostomy emergency"},{"label":"D","text":"Cancel C-section"},{"label":"E","text":"Mass paralytic re-dose"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** DAS Obstetric Failed Intubation algorithm: (1) Declare ''failed intubation'' after 2-3 attempts (limit 3); (2) Plan B — supraglottic airway (LMA, iGel, ProSeal LMA preferred — gastric port); 2nd generation SGA = safer for non-fasted obstetric; ventilate through SGA; (3) Consider whether to wake patient or proceed — depends on fetal condition + maternal stability + urgency: - WAKE if mother stable + non-immediate fetal distress + difficult airway → consider regional anesthesia (spinal if no CI) or AFOI; - PROCEED with SGA if cannot wake + critical fetal distress + adequate ventilation through SGA; (4) Continue cricoid pressure but release if difficulty (controversial); (5) If cannot intubate cannot oxygenate (CICO): EMERGENCY FRONT OF NECK ACCESS — cricothyrotomy (scalpel-bougie-tube technique per DAS); (6) Communicate clearly with team — declare failure + plan; (7) Obstetric considerations — capillary engorgement (smaller ETT 6.0-6.5), edema, full breasts impede laryngoscope; aspiration risk; rapid desaturation; (8) Prevention — pre-O2 thorough (30° HOB or ramped), apneic oxygenation, video laryngoscopy FIRST line in obstetric, optimal position (HELP); (9) MOH (Mother + Baby) safety priorities; (10) Document for future + alert anesthetist

---

DAS Obstetric failed intubation: limit attempts, 2nd gen SGA Plan B, wake vs proceed decision based on fetal + maternal status, CICO = surgical airway. Video laryngoscopy first-line obstetric. Pre-O2 + ramped.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 35 ปี GA 38 wk obese BMI 38 — emergency C-section for fetal distress
Mallampati IV, full stomach, no time for AFOI
GA induction attempted: 3 attempts failed intubation, BMV adequate, SpO2 maintained 96%';

update public.mcq_questions
set choices = '[{"label":"A","text":"Reassurance + observation"},{"label":"B","text":"Post-thyroidectomy hematoma airway compromise = SURGICAL EMERGENCY"},{"label":"C","text":"Wait for OR available"},{"label":"D","text":"Increase IV fluid only"},{"label":"E","text":"Sedate to reduce anxiety"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-thyroidectomy hematoma airway compromise = SURGICAL EMERGENCY: (1) Immediate recognition — neck swelling + stridor + distress = compressing trachea + venous obstruction → laryngeal edema; (2) IMMEDIATE bedside drainage — open wound at bedside if airway compromise (do not wait for OR); cut sutures + evacuate hematoma; relieves compression + may stabilize airway transiently; (3) Call surgery + anesthesia STAT; (4) Airway management — challenging: laryngeal edema + distorted anatomy; avoid muscle relaxant until secured (loss of muscle tone may worsen); AWAKE fiberoptic intubation if time; or video laryngoscopy with awake/sedated; have surgical airway ready (cricothyrotomy/tracheostomy); (5) Smaller ETT (6.0-6.5) anticipate edema; (6) Sit upright if possible (helps venous drainage + comfort); (7) 100% O2, position upright, IV access; (8) Hold heparin/anticoagulants; reverse if applicable; (9) After airway secured: return to OR for definitive hemostasis; (10) Drain output may NOT reflect actual bleeding (may be clotted or extra-luminal); (11) Risk factors: bleeding diathesis, hypertension, vigorous coughing, retrosternal goiter; (12) Post-op: observe at least 6h with neck visualization, drain monitoring

---

Post-thyroidectomy hematoma: SURGICAL EMERGENCY. Bedside wound opening immediately. Awake fiberoptic intubation. Surgical airway backup. Drain output unreliable. Sit upright. Avoid muscle relaxant until secured.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 28 ปี post-thyroidectomy 6h ago — sudden onset stridor + distress + neck swelling visibly enlarging
SpO2 dropping 95→88%, hoarse, anxious
Surgical drain in place — minimal output';

update public.mcq_questions
set choices = '[{"label":"A","text":"Re-anesthetize + intubate immediately"},{"label":"B","text":"Post-extubation laryngospasm + residual neuromuscular block DDx"},{"label":"C","text":"IV fluid bolus only"},{"label":"D","text":"Wait silently"},{"label":"E","text":"Sedate with midazolam"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-extubation laryngospasm + residual neuromuscular block DDx: (1) Laryngospasm — inspiratory stridor, paradoxical movement, suprasternal retraction; treat: 100% O2 + jaw thrust + CPAP + remove stimuli + Larson maneuver (digital pressure ''laryngospasm notch'' behind ear lobe); deepen anesthesia (propofol 0.5-1 mg/kg IV); IM succinylcholine 1-2 mg/kg if persistent or hypoxic (IV faster if access); (2) Residual neuromuscular blockade (PORC) — TOF ratio < 0.9 = inadequate reversal, presents with weakness, swallowing difficulty, airway obstruction; treat: sugammadex 2-4 mg/kg if rocuronium/vecuronium (immediate complete reversal); or neostigmine + glyco re-dose if deeper block; (3) Negative pressure pulmonary edema (NPPE) — from laryngospasm + forced inspiration against closed glottis; treat: O2, PEEP, diuretic, supportive; (4) Other DDx — opioid-induced respiratory depression (naloxone), upper airway edema, foreign body, vocal cord paralysis (recurrent laryngeal nerve injury); (5) Modern: quantitative TOF monitoring should be ROUTINE for all NMB use (ASA standard); sugammadex preferred over neostigmine for deeper blocks; (6) Prevention: assure TOF > 0.9 before extubation, quantitative monitoring, sugammadex for difficult reversal

---

Post-extubation distress DDx: laryngospasm (CPAP, Larson, deepen, sux), residual NMB (sugammadex), NPPE, opioid-induced. Quantitative TOF routine standard. Sugammadex preferred.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วย GA case ASA II 40 ปี — after extubation in PACU, SpO2 drops 99→82%, paradoxical chest-abdomen movement, suprasternal retractions, stridor inspiratory, agitated
Received neuromuscular block reversal (neostigmine + glycopyrrolate) 10 min ago
TOF train-of-four ratio not measured';

update public.mcq_questions
set choices = '[{"label":"A","text":"Standard GA + RSI"},{"label":"B","text":"Compromised airway anesthesia plan"},{"label":"C","text":"Blind nasal intubation"},{"label":"D","text":"IV induction + paralysis first"},{"label":"E","text":"Mass sedation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Compromised airway anesthesia plan: (1) Pre-op airway assessment — flexible nasal endoscopy by ENT, imaging (CT) to define obstruction level + degree; multidisciplinary planning ENT + anesthesia; (2) Awake tracheostomy under local anesthesia = safest for severe upper airway obstruction (preserves spontaneous ventilation); (3) Preparation — ENT + surgical airway ready, all difficult airway equipment, multiple plans; team brief; (4) Position — supine but head of bed up 30°; pre-oxygenate; (5) Local anesthesia — lidocaine + epinephrine subcutaneous + deeper tissues; minimal sedation (avoid losing airway) — small dose dexmedetomidine 0.5 mcg/kg/hr titrated, OR remifentanil low-dose; (6) Surgical access — neck dissection to trachea; insert tracheostomy tube; confirm position + ventilation; (7) ONLY after secure airway: induce GA with propofol + NMB; (8) Alternative plans: awake fiberoptic intubation (if can pass scope through obstruction), inhalational induction maintaining spontaneous ventilation (sevoflurane in O2), rigid bronchoscopy with jet ventilation (ENT in OR); (9) AVOID — paralytic before secured airway, IV induction first; (10) Equipment — multiple ETT sizes (smaller anticipate), tracheal tubes, jet ventilation, ECMO standby for high-grade obstruction; (11) Communication — patient awake, reassure, explain steps

---

Compromised airway: awake tracheostomy under local = safest. ENT + anesthesia plan. Preserve spontaneous ventilation. NEVER paralyze before secured. Multiple plans + equipment ready. Modern: multidisciplinary head-and-neck airway teams.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 65 ปี laryngeal cancer with stridor pre-op — elective laryngectomy + tracheostomy
Mallampati IV, fixed laryngeal mass invading hypopharynx
Plan = awake tracheostomy under local';

update public.mcq_questions
set choices = '[{"label":"A","text":"Proceed spinal immediately"},{"label":"B","text":"ASRA Anticoagulation + Neuraxial Guidelines"},{"label":"C","text":"GA mandatory regardless"},{"label":"D","text":"Continue enoxaparin same day"},{"label":"E","text":"Stop ASA 7 days for spinal"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** ASRA Anticoagulation + Neuraxial Guidelines: (1) LMWH prophylactic dose (enoxaparin 40 mg SC daily) — wait 12h since last dose before neuraxial; this patient 14h = OK to proceed; (2) LMWH therapeutic dose (1 mg/kg BID or 1.5 mg/kg daily) — wait 24h; (3) Unfractionated heparin SC ≤ 5000U BID — no delay; ≥ 7500U BID or TID — 12h hold + normal aPTT; (4) Heparin infusion IV — stop 4-6h + aPTT normal; (5) Warfarin — INR ≤ 1.5; (6) DOAC — apixaban/rivaroxaban 72h hold (longer renal); dabigatran 5 days (CrCl < 50); (7) ASA + NSAID — no delay neuraxial; (8) Clopidogrel — 5-7 days; ticagrelor — 5-7 days; prasugrel — 7-10 days; (9) Restart anticoagulation post-procedure — LMWH prophylactic 12h after; LMWH therapeutic 24h; remove catheter 12h after last LMWH dose + next dose 4h later; (10) Spinal stenosis = relative contraindication concern: harder to find space, increased neuraxial hematoma risk, neurologic complication if hematoma; some advocate avoid neuraxial in severe stenosis; (11) Alternative: spinal saddle block, adductor canal + femoral block, peripheral nerve block, GA; (12) Document discussion + plan + neuro exam baseline

---

ASRA Anticoagulation Guidelines: LMWH prophylactic 12h, therapeutic 24h. DOAC 72h. Clopidogrel 5-7d. Spinal stenosis = relative concern. Peripheral nerve block alternative. Document.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 75 ปี severe lumbar spinal stenosis — total knee arthroplasty
Meds: enoxaparin 40 mg SC HS prophylactic, lastdose 14h ago
INR normal, plt 240k, no anticoagulant other
Plan: regional anesthesia preferred';

update public.mcq_questions
set choices = '[{"label":"A","text":"Increase epidural infusion"},{"label":"B","text":"Suspected epidural hematoma"},{"label":"C","text":"Wait 24h to see if resolves"},{"label":"D","text":"Pull catheter immediately"},{"label":"E","text":"Give more local anesthetic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Suspected epidural hematoma — EMERGENCY: (1) Recognition — new or progressive lower extremity weakness/sensory loss + bowel/bladder dysfunction in patient with neuraxial; (2) DDx — epidural hematoma, epidural abscess, residual local anesthetic, vascular event (anterior spinal artery syndrome), retained catheter; (3) IMMEDIATE — stop infusion (already done), urgent MRI spine (gold standard); avoid LP; (4) Neurosurgery consult URGENT — surgical decompression within 8h of symptom onset critical for neuro recovery; (5) Coagulation status — INR, PTT, platelets, fibrinogen; correct coagulopathy if present (FFP, platelets); review anticoagulation/antiplatelet history; (6) Catheter removal — only after coagulation OK (12h after LMWH prophylactic); document timing; (7) MRI findings — hyperintense on T1/T2 acute hematoma, mass effect on cord; abscess shows enhancement + rim; (8) Surgery — emergent laminectomy + clot evacuation; outcome best if < 8h symptoms; (9) Document time of onset + serial neuro exams q1h; (10) Risk factors — anticoagulation (highest), age, female, traumatic placement, multiple attempts, anatomic abnormalities; (11) Prevention — follow ASRA timing, careful placement, neuro checks after neuraxial; (12) Don''t miss: spinal abscess (fever, back pain, days later, immunocompromised)

---

Post-neuraxial new weakness = EMERGENCY. Urgent MRI + neurosurgery. Surgical decompression < 8h. DDx hematoma, abscess. Document neuro exam. Coag check + reverse. ASRA timing for catheter removal.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 55 ปี received epidural for thoracotomy at T6-7 level, catheter in place 48h post-op
Nurse calls: lower extremity weakness developing × 4h, progressive
Incontinence new
Block not infusing > 1h';

update public.mcq_questions
set choices = '[{"label":"A","text":"Lumbar puncture diagnostic"},{"label":"B","text":"Post-dural puncture headache (PDPH)"},{"label":"C","text":"Antibiotic empirically"},{"label":"D","text":"Discharge no follow-up"},{"label":"E","text":"Immediate craniotomy"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-dural puncture headache (PDPH): (1) Diagnosis — positional headache (worse upright, better supine) within 5 days post-neuraxial; CSF leak → low pressure → cerebral vasodilation + traction; auditory symptoms (tinnitus, hearing loss), neck stiffness, photophobia, nausea; (2) Risk factors — young female, pregnancy, low BMI, prior PDPH, large needle, cutting needle (Quincke), multiple attempts; (3) Prevention — pencil-point needle (Whitacre, Sprotte) smaller gauge (25-27G); single attempt; bevel orientation parallel to fibers; (4) Conservative initial — bed rest, hydration (oral + IV), caffeine (300 mg PO or 500 mg IV), analgesics (acetaminophen, NSAID), abdominal binder; many resolve 1-7 days; avoid Trendelenburg (worsens); (5) Epidural blood patch (EBP) = definitive treatment if conservative fails or severe disability: 15-20 mL autologous blood injected sterile epidural at or one level below puncture; 60-90% success first attempt, repeat if needed; precautions — sterile technique, sit up after to seal; (6) Sphenopalatine ganglion block — emerging non-invasive option (lidocaine via nasal catheter); (7) Other options — gabapentin, theophylline, ACTH, hydrocortisone (less evidence); (8) Differential — meningitis (fever, WBC), cortical vein thrombosis (focal deficit, seizure), pre-eclampsia (HTN), tension/migraine, intracranial bleed; LP only if meningitis suspected (otherwise worsens); (9) Reassure + counsel; future neuraxial OK with proper technique

---

PDPH: positional, post-neuraxial. Conservative first (caffeine, hydration), EBP definitive if persistent. Pencil-point needles prevent. DDx meningitis, cortical vein thrombosis, pre-eclampsia. Sphenopalatine block emerging.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 30 ปี post-spinal anesthesia for C-section, day 2
Severe positional headache (worse upright, better supine)
Frontal-occipital, neck stiffness, photophobia
No fever, no focal deficit';

update public.mcq_questions
set choices = '[{"label":"A","text":"Standard GA only without regional"},{"label":"B","text":"Paravertebral block (PVB) for breast surgery"},{"label":"C","text":"Continuous epidural T6 level"},{"label":"D","text":"Brachial plexus block"},{"label":"E","text":"Caudal block"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Paravertebral block (PVB) for breast surgery: (1) Indication — unilateral chest wall/abdominal analgesia; breast surgery (lumpectomy, mastectomy), thoracotomy, rib fracture, hernia; (2) Anatomy — paravertebral space wedge-shaped, bordered by superior costotransverse ligament + parietal pleura; contains spinal nerve root + sympathetic chain; (3) Ultrasound-guided technique preferred — paramedian sagittal view (count ribs + transverse processes), in-plane needle, observe LA spread anteriorly + pleural depression; (4) Multiple levels needed for breast — T2-T6; volume 3-5 mL per level OR larger single-level injection (15-20 mL) for spread; (5) LA — bupivacaine 0.25-0.5%, ropivacaine 0.375-0.5%; adjuvant — epinephrine, dexamethasone, dexmedetomidine prolong duration; (6) Continuous catheter for prolonged analgesia; (7) Advantages over epidural — unilateral (less hemodynamic), preserves bladder + lower extremity, less PONV; better than no block for cancer recurrence theory (volatile/opioid sparing); (8) Complications — pleural puncture/pneumothorax (1-5%), vascular puncture, intrathecal injection (rare but devastating), hypotension (less than epidural), LAST; (9) Alternatives — erector spinae plane block (ESP — easier, safer, similar efficacy), serratus anterior plane block, PECS I/II; (10) Modern: regional anesthesia for breast surgery reduces opioid + PONV + chronic post-mastectomy pain; (11) Multimodal post-op

---

PVB for breast: T2-T6, ultrasound-guided, unilateral sympathectomy, less hemodynamic vs epidural. Alternatives ESP, serratus, PECS. Pleural puncture risk. Reduces chronic pain.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 50 ปี mastectomy + axillary dissection — plan = paravertebral block T2-T6 for analgesia + GA
Ultrasound-guided technique
Received bupivacaine 0.5% 5 mL × 5 levels';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue surgery"},{"label":"B","text":"Pneumothorax after supraclavicular block"},{"label":"C","text":"Ignore breath sounds"},{"label":"D","text":"More local anesthetic"},{"label":"E","text":"Discharge"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pneumothorax after supraclavicular block: (1) Recognition — dyspnea + decreased ipsilateral breath sounds + hypoxia after supraclavicular/infraclavicular block; risk 0.5-6% (lower with ultrasound vs blind); (2) Confirm — bedside ultrasound (absence of lung sliding, lung point sign), CXR upright expiratory; (3) Management depends on size + symptoms: - Small + stable: O2 supplemental + observation + serial imaging; - Symptomatic + > 15-20% or expanding: tube thoracostomy chest tube; - Tension pneumothorax: emergent needle decompression (2nd ICS midclavicular or 4-5th ICS midaxillary) then chest tube; (4) Avoid positive pressure ventilation if can (worsens pneumothorax); if intubated: small TV, low PEEP; (5) Postpone elective surgery; (6) Other complications supraclavicular block: phrenic nerve palsy (50-100%), Horner syndrome, recurrent laryngeal nerve palsy, intravascular injection + LAST, nerve injury; (7) Phrenic palsy — generally well-tolerated in healthy; severe respiratory disease (COPD): consider alternative block (infraclavicular, axillary); (8) Alternatives — interscalene (shoulder), infraclavicular (forearm), axillary (forearm/hand); (9) Prevention — ultrasound guidance, in-plane needle, careful visualization, avoid deep insertion; (10) Document + counsel

---

Pneumothorax post-supraclavicular: dyspnea + decreased BS + hypoxia. Ultrasound confirm. Size-based Mx. Avoid PPV. Alternatives infraclavicular/axillary. Phrenic palsy common but usually tolerated.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 55 ปี received ultrasound-guided supraclavicular block for forearm surgery
5 min later: SpO2 88%, dyspnea, decreased breath sounds R chest
BP 130/80, HR 95
CXR pending';

update public.mcq_questions
set choices = '[{"label":"A","text":"Spinal anesthesia routine dose"},{"label":"B","text":"Severe pre-eclampsia + HELLP"},{"label":"C","text":"Wait BP to normalize naturally"},{"label":"D","text":"Mass crystalloid bolus"},{"label":"E","text":"Skip magnesium"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe pre-eclampsia + HELLP — anesthesia management: (1) BP control — labetalol 20mg IV bolus q10min (max 300mg) OR hydralazine 5-10mg IV q20min OR nicardipine infusion; target SBP 140-160, DBP 90-100; (2) Seizure prophylaxis — magnesium sulfate 4-6g loading + 1-2g/hr infusion (continue 24h post-delivery); monitor reflexes + RR + urine output; signs toxicity: loss DTR (8-10), respiratory depression (12), cardiac arrest (15+); antidote calcium gluconate 1g IV; (3) Anesthesia choice based on platelets: - Plt > 70-80k + no rapid drop + no other coag issues = neuraxial generally safe; some advocate higher threshold (100k); spinal preferred over epidural (smaller needle); - Plt < 70k or rapidly dropping = GA with careful airway (edema, full stomach, RSI); video laryngoscopy first; smaller ETT; expect HTN response to laryngoscopy — treat (lidocaine, opioid, magnesium); (4) Airway considerations — edema, weight gain, friability; difficult airway anticipated; (5) Volume — judicious (pulmonary edema risk); avoid fluid overload; (6) Fetal: neonatal team ready; (7) Post-op — ICU/HDU 24h, continue magnesium, monitor for eclampsia, BP control, fluid balance, pulmonary edema, AKI, abruption, DIC; (8) Magnesium prolongs NMB — reduce NMB dose; (9) Avoid ergot (BP), methergine; oxytocin slow (hypotension); carboprost contraindicated (asthma); (10) Multidisciplinary: anesthesia + OB + neonatology + ICU

---

Severe PEC/HELLP: labetalol/hydralazine, magnesium prophylaxis, neuraxial if plt > 70-80k, GA with difficult airway prep if low plt. Volume judicious. Magnesium toxicity Ca antidote. Multidisciplinary post-op ICU.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 28 ปี G2P1 GA 38 wk severe pre-eclampsia
BP 165/110, proteinuria 3+, headache, RUQ pain
Plt 75k, AST 120, ALT 95
Urgent C-section indicated';

commit;
