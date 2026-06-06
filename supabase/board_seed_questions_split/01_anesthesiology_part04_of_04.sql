-- ===============================================================
-- หมอรู้ — Board seed: วิสัญญีวิทยา (anesthesiology) — part 4/4 (50 MCQs)
-- Safe to paste into Supabase SQL Editor. Re-runnable.
-- ===============================================================

begin;

-- mcq_subjects for this specialty (idempotent)
insert into public.mcq_subjects
  (name, name_th, icon, audience, board_specialty, exam_type, question_count)
values
  ('anes_clinical_decision', 'วิสัญญีวิทยา · การตัดสินใจทางเวชกรรม', '🩺', 'board', 'anesthesiology', NULL, 0),
  ('anes_basic_science', 'วิสัญญีวิทยา · วิทยาศาสตร์การแพทย์พื้นฐาน', '🧬', 'board', 'anesthesiology', NULL, 0),
  ('anes_ems_mgmt', 'วิสัญญีวิทยา · การจัดการระบบบริการการแพทย์ฉุกเฉิน', '🚨', 'board', 'anesthesiology', NULL, 0),
  ('anes_integrative', 'วิสัญญีวิทยา · ข้อสอบบูรณาการ', '🧩', 'board', 'anesthesiology', NULL, 0)
on conflict (name) do nothing;

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'EMS/Management: anesthesia for procedures outside OR (NORA — Non-Operating Room Anesthesia)', '[{"label":"A","text":"Skip safety standards"},{"label":"B","text":"Non-Operating Room Anesthesia (NORA)"},{"label":"C","text":"No monitoring needed"},{"label":"D","text":"Different rules"},{"label":"E","text":"Refuse NORA"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Non-Operating Room Anesthesia (NORA): (1) Locations: - GI endoscopy (colonoscopy, ERCP, EUS); - Interventional radiology (embolization, biopsy, drain, EVAR); - Cardiac cath/EP lab (TAVR, ablation, ICD, PCI); - Radiation oncology (pediatric daily); - MRI/CT; - Bronchoscopy; - ECT (psychiatry); - Dental; - Office-based; (2) Challenges: - Unfamiliar environment; - Limited assistance; - Patient access limited (cath lab, MRI); - Equipment different/less; - Radiation exposure; - Magnetic field (MRI); - Distance from main OR/resources; (3) Anesthesia options: - MAC (moderate-deep sedation); - GA; - Regional + sedation; - Local + monitor; (4) Equipment requirements: - Same standards as OR (ASA monitoring); - Capnography mandatory moderate/deep; - Suction, O2, airway, drugs, defibrillator; - Reliable communication; - Emergency support plan; (5) MRI-specific: - MR-conditional equipment (ferromagnetic safety); - Long monitoring cables; - Pulse oximetry, capnography, ECG MR-safe; - Anesthesia machine MR-compatible or outside scan room; - Earplugs/protection (noise); - Patient screening (pacemaker, implants); - Heat concern (RF energy); (6) Radiation: - Lead shield + apron; - Distance + time minimization; - Pregnancy screening staff; - Eye protection; (7) Pediatric NORA — high volume (radiation therapy, MRI); requires expertise; (8) Sedation drugs: - Propofol, ketamine, dexmedetomidine, fentanyl, midazolam; - Risks: airway, hypotension, paradoxical reaction; (9) Pre-procedure assessment: - Standard pre-anesthesia evaluation; - NPO; - Difficult airway screening; - Comorbidities; (10) Safety: - Standard apply outside OR; - ASA Statement NORA

---

NORA: same ASA standards as OR, capnography mandatory moderate/deep sedation, MR-conditional equipment, radiation protection, pediatric NORA expertise. Reliable communication + emergency plan. ASA NORA Statement.', NULL,
  'easy', 'procedures', 'review',
  'anesthesiology', 'ems_mgmt', 'procedures', 'adult',
  'ASA NORA Statement; APSF Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'EMS/Management: anesthesia for procedures outside OR (NORA — Non-Operating Room Anesthesia)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 50 ปี — elective hepatic resection
Lab: AST 80, ALT 60, ALK 120, bili 1.8, INR 1.3, plt 110k, albumin 3.2
Child-Pugh B, MELD 12, mild ascites', '[{"label":"A","text":"Routine doses all drugs"},{"label":"B","text":"Cirrhosis perioperative anesthesia"},{"label":"C","text":"Morphine PCA only"},{"label":"D","text":"Mass IV crystalloid"},{"label":"E","text":"Skip TEG"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cirrhosis perioperative anesthesia: (1) Severity assessment — Child-Pugh (A: 5-6, B: 7-9, C: 10-15), MELD (predicts mortality, > 15 high risk); (2) Pre-op optimization: - Treat ascites (diuretic, paracentesis large volume); - Correct coagulopathy (vitamin K, FFP, platelets if active bleeding or pre-procedure); - Optimize albumin + nutrition; - Hepatic encephalopathy (lactulose, rifaximin); - Hyponatremia correction slowly; - Renal function — hepatorenal syndrome screening; (3) Anesthetic considerations: - Altered drug metabolism — many drugs (benzodiazepines, opioids, propofol) accumulate; - Hypoalbuminemia → increased free drug; - Cisatracurium preferred NMB (Hofmann elimination); - Remifentanil preferred opioid (esterase metabolism); - Propofol OK (lower doses, slower infusion); - Avoid morphine (active metabolites); use fentanyl/hydromorphone reduced doses; - Avoid halothane (now rarely used); sevoflurane OK; (4) Hemodynamic: - Hyperdynamic circulation (low SVR, high CO); - Sensitive to fluid shifts; - Vasoplegia common; - Hemorrhagic risk + variceal bleeding; (5) Coagulation: - Rebalanced coagulation (both pro + anti-coagulant decreased); TEG more useful than INR; - Avoid unnecessary FFP (worsens portal pressure); (6) Special considerations TIPS, liver transplant, variceal bleeding; (7) Neuraxial considerations — coagulopathy concern; (8) Post-op: - Hepatic decompensation risk; - HRS; - Infection (SBP); - Coagulopathy; - Encephalopathy; (9) Multidisciplinary: hepatology + anesthesia + surgery + transplant team if applicable

---

Cirrhosis: Child-Pugh + MELD severity. Treat coagulopathy, ascites, encephalopathy. Cisatracurium, remifentanil, reduced doses. Hyperdynamic + vasoplegia. TEG > INR. Multidisciplinary.', NULL,
  'medium', 'gi', 'review',
  'anesthesiology', 'clinical_decision', 'gi', 'adult',
  'ASA Practice; AASLD Hepatic Surgery', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 50 ปี — elective hepatic resection
Lab: AST 80, ALT 60, ALK 120, bili 1.8, INR 1.3, plt 110k, albumin 3.2
Child-Pugh B, MELD 12, mild ascites'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 75 ปี — emergent surgery for SBO
Polypharmacy: 12 medications + DOAC + furosemide + amiodarone + warfarin + ACE-I + ASA
History: AFib, HFpEF, CKD, T2DM', '[{"label":"A","text":"Continue all unchanged"},{"label":"B","text":"Polypharmacy + elderly perioperative"},{"label":"C","text":"Stop everything"},{"label":"D","text":"Skip review"},{"label":"E","text":"Ignore interactions"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Polypharmacy + elderly perioperative: (1) Pre-op medication review (Beers Criteria, STOPP/START): - Identify potentially inappropriate medications (PIMs); - Drug interactions; - Cumulative anticholinergic burden; - Polypharmacy itself = risk factor adverse outcomes; (2) Common categories to review/adjust: - Anticoagulants — hold appropriate intervals (DOAC, warfarin); - Antiplatelets — selective hold; - Antihypertensives — hold ACE-I/ARB day surgery (hypotension); continue beta-blocker; - Diuretics — hold morning, resume; - Hypoglycemics — adjust insulin, hold metformin/SGLT2i; - Anticonvulsants — continue; - Psychiatric — continue most; SSRI (bleeding); MAOI (drug interactions); - Long-acting opioid — continue (avoid withdrawal); - Steroid — continue + stress dose; - Statin — continue (cardioprotective); - Antiarrhythmic — continue (amiodarone — pulmonary, hepatic, thyroid considerations); (3) Specific concerns: - Amiodarone — pulmonary fibrosis risk + intra-op bradycardia + corneal deposits + thyroid; - Furosemide — hypokalemia, hypomagnesemia, hypovolemia; replace K + Mg; - ACE-I — refractory intra-op hypotension; vasopressin may help; (4) Drug-drug interactions: - QTc prolongation cumulative; - Serotonin syndrome (multiple serotonergic); - Sedative additive; (5) Anticholinergic burden — falls, delirium, cognitive; (6) Renal/hepatic adjustment; (7) Cumulative bleeding risk multiple agents; (8) Withdrawal considerations — opioid, benzo, alcohol, nicotine, baclofen; (9) Multidisciplinary: - Pharmacist consultation; - Geriatric medicine; - Specialty consultations; (10) De-prescribing as appropriate long-term; (11) Modern: pre-op clinic medication reconciliation + optimization

---

Polypharmacy elderly: Beers Criteria + STOPP/START review, individualized hold/continue, address PIMs, anticholinergic burden, drug interactions, withdrawal considerations. Pharmacist + geriatric consult. Pre-op clinic.', NULL,
  'medium', 'cardiovascular', 'review',
  'anesthesiology', 'clinical_decision', 'cardiovascular', 'adult',
  'ASA Geriatric Anesthesia; AGS Beers 2023', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 75 ปี — emergent surgery for SBO
Polypharmacy: 12 medications + DOAC + furosemide + amiodarone + warfarin + ACE-I + ASA
History: AFib, HFpEF, CKD, T2DM'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 28 ปี healthy, IV drug user, presenting with infective endocarditis aortic + mitral valve
Vegetations large + new AR moderate-severe
Hemodynamically stable but planned valve surgery', '[{"label":"A","text":"Refuse care"},{"label":"B","text":"Infective endocarditis + IVDU"},{"label":"C","text":"Single discipline"},{"label":"D","text":"Stigmatize patient"},{"label":"E","text":"Skip TEE"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Infective endocarditis + IVDU — cardiac anesthesia: (1) Multidisciplinary endocarditis team — cardiology + cardiac surgery + infectious disease + anesthesia + addiction medicine; (2) Pre-op optimization: - Antibiotics — appropriate based on organisms (MSSA, MRSA, Strep, enterococci, fungi); typically 4-6 weeks; surgery often before completion if indication; - Source control; - Echo (TTE + TEE) to characterize valve + vegetations + complications (abscess, fistula); - Cardiac assessment (heart failure, arrhythmia); - Embolic complications screen (CNS, splenic, renal); - Renal function (drug-induced, AKI from sepsis); - Substance use evaluation; (3) Surgical indications: - Heart failure refractory medical Mx; - Uncontrolled infection (large vegetation, abscess, embolic events); - Prosthetic valve endocarditis; - Specific organisms (fungal, MDR); (4) Anesthesia considerations: - Multivalvular disease — complex hemodynamics; - Anti-emboli precautions; - Possibly endocarditis prophylaxis sub-optimal; - Hemodynamic instability risk; - Cerebral vegetation/embolic stroke risk; - TEE crucial; - CPB considerations; (5) IVDU-specific: - Tolerance opioid + benzodiazepine — increased anesthetic + analgesic doses; - Risk withdrawal (heroin, methadone); coordinate with addiction medicine; - Blood-borne illness (HIV, hepatitis B + C) — universal precautions, antiretrovirals; - Vascular access difficult (sclerosed veins); central access; - Possible recurrence — discuss with patient + family; (6) Addiction medicine: - Methadone or buprenorphine bridge if appropriate; - Treatment plan post-op (residential, outpatient); - Naloxone education; (7) Stigma awareness — patient deserves equitable care; (8) Multidisciplinary post-op: - ICU; - Anticoagulation if mechanical valve; - Antibiotic continuation; - Addiction treatment; - Mental health; (9) Modern: combined cardiothoracic + addiction programs improve outcomes; ethical considerations regarding repeat surgery in active IVDU

---

Endocarditis + IVDU: multidisciplinary endocarditis team, antibiotics + source control + surgical indications, TEE essential, IVDU considerations (tolerance, withdrawal, vascular access), addiction medicine coordination, stigma-free care.', NULL,
  'hard', 'cardiovascular', 'review',
  'anesthesiology', 'clinical_decision', 'cardiovascular', 'adult',
  'AHA Endocarditis; ASRA Addiction', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 28 ปี healthy, IV drug user, presenting with infective endocarditis aortic + mitral valve
Vegetations large + new AR moderate-severe
Hemodynamically stable but planned valve surgery'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 30 ปี G3P2 GA 36 wk — major obstetric hemorrhage after vaginal delivery 2L+ blood loss
Uterotonics escalated
Now shock with INR 1.8, fibrinogen 1.0 g/L, plt 80k', '[{"label":"A","text":"Crystalloid only"},{"label":"B","text":"Severe PPH + coagulopathy"},{"label":"C","text":"Single uterotonic"},{"label":"D","text":"Avoid TXA"},{"label":"E","text":"Stop transfusion"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe PPH + coagulopathy: (1) Activate MTP if not already; (2) Stop bleeding source: - Uterotonics maximal (oxytocin + methergine + carboprost + misoprostol); - Surgical interventions: balloon (Bakri), B-Lynch, uterine artery ligation, hysterectomy; - IR embolization if available + stable; (3) Balanced transfusion 1:1:1 PRBC:FFP:Plt; (4) Fibrinogen replacement aggressive: - Target > 2 g/L (PPH may need > 2.5); - Cryoprecipitate 10 units OR fibrinogen concentrate 4 g; - Critical for clot strength; (5) TXA 1g IV if not given (WOMAN trial — within 3h reduces death); (6) Calcium replacement (citrate); (7) Warm fluids + products + patient; (8) Avoid acidosis + hypothermia (lethal triad); (9) Monitoring: - Arterial line; - Continuous Hb (HemoCue); - TEG/ROTEM if available; - Lactate; - Urine output; (10) Anesthesia: - GA if instability requires; - Ketamine + opioid CV stable; - Vasopressors (norepinephrine first-line); - Inotropes if cardiogenic; (11) Cell salvage acceptable in OB now (post-2007 confirmation); (12) REBOA (Resuscitative Endovascular Balloon Occlusion of Aorta) — emerging for refractory; (13) Post-op: - ICU; - Continued bleeding monitoring; - Sheehan syndrome screening; - DIC; - AKI; - ARDS; - Renal replacement if needed; - Psychological support (PTSD, postpartum depression); (14) Multidisciplinary: OB + anesthesia + IR + ICU + hematology + blood bank

---

Severe PPH + coagulopathy: MTP 1:1:1, fibrinogen target > 2 (cryo/concentrate), TXA, Ca, warm, surgical control. TEG-guided. Norepi. Cell saver OB OK. REBOA emerging. ICU. Multidisciplinary.', NULL,
  'hard', 'obgyn', 'review',
  'anesthesiology', 'clinical_decision', 'obgyn', 'adult',
  'SOAP Consensus PPH; WOMAN Trial', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 30 ปี G3P2 GA 36 wk — major obstetric hemorrhage after vaginal delivery 2L+ blood loss
Uterotonics escalated
Now shock with INR 1.8, fibrinogen 1.0 g/L, plt 80k'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยทารกแรกเกิด 36 wk GA 2.4 kg — congenital heart disease (tetralogy of Fallot) requires palliative shunt
Not ductal-dependent but cyanosis worsening, SpO2 78% on RA', '[{"label":"A","text":"Propofol bolus + hyperventilate"},{"label":"B","text":"Congenital heart disease neonatal anesthesia (Tet)"},{"label":"C","text":"Decrease SVR"},{"label":"D","text":"Allow dehydration"},{"label":"E","text":"Vasodilator first"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Congenital heart disease neonatal anesthesia (Tet): (1) Tetralogy of Fallot — VSD + RVOT obstruction + overriding aorta + RV hypertrophy; cyanosis from R-to-L shunt across VSD; (2) Tet spells (hypercyanotic episodes): - Triggered by — crying, dehydration, fever, induction; - Treatment: knee-chest position (increase SVR + reduce R-to-L shunt); 100% O2; morphine (sedation + reduces sympathetic + reduces infundibular spasm); phenylephrine (increases SVR); fluid bolus; propranolol (reduces infundibular spasm + tachycardia); bicarbonate if acidotic; ECMO if refractory; (3) Anesthetic considerations: - Avoid hypovolemia + tachycardia + decreased SVR — all worsen R-to-L shunt; - Maintain SVR (phenylephrine); - Maintain preload (fluid); - Avoid PVR increases (hypoxia, hypercapnia, acidosis, cold) — worsen R-to-L; - Adequate sedation pre-induction (cry → tet spell); - Smooth induction (ketamine preferred — maintains SVR + HR; etomidate alternative); avoid propofol bolus + high volatile (vasodilation); - Adequate depth before stimulation; - Antifibrinolytic for cardiac surgery; (4) Surgical options: - Modified Blalock-Taussig shunt (subclavian to PA) — palliation; - Complete repair (VSD closure + RVOT augmentation) — definitive; (5) Pre-op: - Echo (anatomy); - Hemoglobin (polycythemia from chronic hypoxia — phlebotomy if Hct > 65); - Bleeding considerations (coagulopathy from polycythemia); - Family preparation; (6) Anti-infective endocarditis prophylaxis; (7) Specific drug choices: - Ketamine 1-2 mg/kg (maintains SVR + HR); - Phenylephrine bolus 1-5 mcg/kg for SVR; - Fentanyl 5-10 mcg/kg; - Rocuronium; (8) Monitoring: - Arterial line; - SpO2 + EtCO2; - Cerebral oximetry useful; - TEE intraop; (9) Multidisciplinary pediatric cardiac team

---

Tet: maintain SVR + preload + adequate depth, avoid PVR increases. Tet spell: knee-chest + O2 + morphine + phenylephrine + propranolol. Ketamine induction. Modified BT shunt vs complete repair.', NULL,
  'hard', 'cardiovascular', 'review',
  'anesthesiology', 'clinical_decision', 'cardiovascular', 'peds',
  'Pediatric Cardiac Anesthesia; AHA CHD Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยทารกแรกเกิด 36 wk GA 2.4 kg — congenital heart disease (tetralogy of Fallot) requires palliative shunt
Not ductal-dependent but cyanosis worsening, SpO2 78% on RA'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 60 ปี — extubated ICU day 3 after major surgery
Develops fever 38.5°C, hypoxia SpO2 88% on 6L O2, productive cough, rhonchi RML
WBC 16k, CXR new RML infiltrate', '[{"label":"A","text":"No antibiotics"},{"label":"B","text":"Ventilator-Associated Pneumonia (VAP) / Hospital-Acquired Pneumonia"},{"label":"C","text":"Continue support"},{"label":"D","text":"Ignore CXR"},{"label":"E","text":"Sedate more"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Ventilator-Associated Pneumonia (VAP) / Hospital-Acquired Pneumonia: (1) Definitions: - VAP: > 48h after intubation; - HAP: > 48h after hospital admission; - Post-extubation can blur with VAP for recently extubated; (2) Diagnosis: - Fever + leukocytosis + purulent secretions + hypoxia + new infiltrate; - Lower sensitivity in critically ill (other infiltrate causes — atelectasis, edema, ARDS, hemorrhage); - Bronchoalveolar lavage (BAL) or non-bronchoscopic mini-BAL; - Quantitative culture + threshold; - Procalcitonin (sensitivity moderate); (3) Empiric antibiotics — IDSA/ATS 2016 guidelines: - Cover S. aureus, Pseudomonas, gram-negative; - Vancomycin or linezolid (MRSA); - Cefepime, pip-tazobactam, or carbapenem (MDR risk); - Aminoglycoside or fluoroquinolone if high MDR risk; - De-escalate per culture (48-72h); - Duration 7 days standard (not 14); (4) Prevention bundle (VAP bundle): - HOB > 30° (semi-recumbent); - Oral care chlorhexidine; - SAT/SBT daily (extubate ASAP); - Stress ulcer prophylaxis; - DVT prophylaxis; - Subglottic suction ETT; - Cuff pressure 20-30; - Minimize sedation; - Hand hygiene; (5) Post-extubation considerations: - Aspiration risk; - Diaphragm dysfunction (ICU-acquired weakness); - Atelectasis; - Multimodal pulmonary toilet; (6) Risk factors VAP: - Prolonged ventilation; - Sedation/paralysis; - Reintubation; - Aspiration; - Supine position; - Comorbid (COPD, ARDS); (7) Outcomes: - Mortality 20-50% VAP; - Increased LOS + cost; (8) Modern: minimizing ventilation + aggressive prevention bundle

---

VAP/HAP: fever + WBC + secretions + infiltrate. Empiric MRSA + Pseudomonas coverage, de-escalate, 7 days. Bundle prevention (HOB, oral care, SAT/SBT, subglottic suction). Modern minimization.', NULL,
  'medium', 'respiratory', 'review',
  'anesthesiology', 'clinical_decision', 'respiratory', 'adult',
  'IDSA/ATS HAP/VAP 2016; SCCM ICU Liberation', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 60 ปี — extubated ICU day 3 after major surgery
Develops fever 38.5°C, hypoxia SpO2 88% on 6L O2, productive cough, rhonchi RML
WBC 16k, CXR new RML infiltrate'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 70 ปี post-major surgery day 1 — sudden chest pain + ST elevation V1-V4 + cardiac biomarkers rising
BP stable, no overt heart failure', '[{"label":"A","text":"Continue surgery routine"},{"label":"B","text":"Perioperative myocardial infarction"},{"label":"C","text":"Ignore troponin"},{"label":"D","text":"Aggressive surgery"},{"label":"E","text":"Refuse cardiology"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Perioperative myocardial infarction: (1) Recognition — anginal symptoms may be masked (sedation, analgesia, post-op confusion); silent MI common (50%); ECG changes + troponin elevation key; (2) Classification: - Type 1 — plaque rupture, thrombosis; - Type 2 — supply-demand mismatch (most common perioperative — anemia, tachycardia, hypotension, hypoxia); (3) Management — depends on type + clinical: - Type 1 (STEMI or NSTEMI with high-risk features): - Cardiology consult urgent; - PCI consideration (timing depends on bleeding risk + surgical wound — often delayed primary PCI 24-72h); - Dual antiplatelet (DAPT) — ASA + clopidogrel — balance bleeding risk surgical; - Anticoagulation careful; - Beta-blocker, statin (continued/added); - Type 2: address underlying — transfuse, control HR/BP, oxygenate, treat pain; medical management; (4) Hemodynamic optimization: - HR < 80 (beta-blocker); - BP control (avoid extremes); - Adequate oxygenation; - Hb > 7-9 (debate); - Adequate analgesia (sympathetic surge); - Hemostatic control; (5) Imaging: - Echo (LV function, regional WMA); - Coronary angiography selective; (6) Cardiology consultation + multidisciplinary; (7) Risk stratification — RCRI, ACS-NSQIP, NSQIP-Gupta MICA, AUB-HAS2; (8) Prevention: - Continuation cardio-protective medications (statin, beta-blocker); - Optimize comorbidities; - Anemia avoidance; - Multimodal pain control; - Identification high-risk patients; (9) Outcomes — perioperative MI associated with high mortality (5-25%); (10) MINS (Myocardial Injury after Non-cardiac Surgery) — troponin elevation without classical MI criteria; increasingly recognized + treated as significant marker risk + therapeutic target

---

Perioperative MI: Type 1 (plaque) vs Type 2 (supply-demand). Cardiology consult, DAPT vs bleeding risk, hemodynamic optimization. MINS recognition. RCRI risk stratification. Multidisciplinary + prevention.', NULL,
  'medium', 'cardiovascular', 'review',
  'anesthesiology', 'clinical_decision', 'cardiovascular', 'adult',
  'AHA/ACC Perioperative MI; VISION Study', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 70 ปี post-major surgery day 1 — sudden chest pain + ST elevation V1-V4 + cardiac biomarkers rising
BP stable, no overt heart failure'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 45 ปี post-bariatric sleeve gastrectomy POD 3 ICU — sudden tachycardia + hypotension + AKI + worsening confusion + abdominal pain
WBC 18k, lactate 4, fever 38.6', '[{"label":"A","text":"Wait + observe"},{"label":"B","text":"Post-bariatric surgical complication"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Ignore tachycardia"},{"label":"E","text":"Routine post-op care"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-bariatric surgical complication: (1) DDx urgent: - Anastomotic leak (sleeve gastrectomy staple line leak — most feared); - Bleeding; - PE/DVT; - Sepsis (other source); - Cardiogenic; - Adrenal insufficiency; - Bowel obstruction; (2) Sleeve leak features: - Tachycardia + tachypnea early (often before pain or fever); - Fever; - Hypotension; - Leukocytosis; - Tachycardia > 120 = ominous sign; - Pain location variable (LUQ to L shoulder referred); - SOB; - Lactate elevation; (3) Diagnostic: - CT with PO + IV contrast (extravasation); - Upper GI series (water-soluble); - Endoscopy diagnostic + therapeutic; - Exploration if unstable; (4) Management: - NPO + NG decompression (controversial — endoscopic better); - IV fluids + electrolytes; - Broad-spectrum antibiotics (gram-negative + anaerobic); - Drain (percutaneous IR or surgical); - Endoscopic stent (sleeve leaks); - Surgical revision (massive leak, sepsis); - ICU monitoring; (5) PE/DVT — bariatric high risk: - Dyspnea, tachycardia, hypoxia; - CTPA; - Heparin anticoagulation; - Catheter-directed thrombolysis selected; - IVC filter selected; (6) Multidisciplinary: - Bariatric surgery; - General surgery; - IR; - Anesthesia (if OR); - ICU; - Nutrition; (7) Anesthesia for reoperation: - Difficult airway (obesity); - Aspiration risk; - Hemodynamic considerations sepsis; - Multimodal opioid-sparing (avoid NSAID after bariatric); - Regional techniques; (8) Outcomes — early recognition + intervention critical; (9) Modern: increased bariatric surgery, complications, standardized protocols

---

Post-bariatric crisis: think LEAK (tachy first sign), DDx PE/bleeding/sepsis. CT + endoscopy diagnostic. Antibiotics + drainage + stent or surgical. ICU. Multidisciplinary. Avoid NSAID post-bariatric.', NULL,
  'medium', 'gi', 'review',
  'anesthesiology', 'clinical_decision', 'gi', 'adult',
  'SOBA; ASMBS Complications', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 45 ปี post-bariatric sleeve gastrectomy POD 3 ICU — sudden tachycardia + hypotension + AKI + worsening confusion + abdominal pain
WBC 18k, lactate 4, fever 38.6'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 25 ปี — major burn 35% TBSA — emergency escharotomy + ongoing resuscitation
Burns chest, abdomen, both arms
Fluid resuscitation Parkland formula started', '[{"label":"A","text":"Succinylcholine RSI"},{"label":"B","text":"Major burn anesthesia"},{"label":"C","text":"Routine doses"},{"label":"D","text":"No fluid"},{"label":"E","text":"Skip airway"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Major burn anesthesia: (1) Initial assessment ABCDE + burn-specific: - Airway — burns to face, neck, oropharynx → progressive edema → early intubation (within 4-6h); inhalational injury; - Breathing — circumferential chest burns may need escharotomy; - Circulation — fluid resuscitation Parkland: 4 mL × kg × %TBSA = 24h fluid; half in first 8h from time of burn; LR most common; modern reduces with adequate UO; - Disability — neuro; - Exposure — keep warm; (2) Inhalational injury: - Singed nasal hairs, soot, hoarse, stridor, carbonaceous sputum; - Carboxyhemoglobin (CO) + cyanide poisoning; treat with 100% O2 + hydroxocobalamin; - Early intubation (airway swelling progresses 24-48h); - Bronchoscopy diagnostic; (3) Fluid resuscitation: - Parkland formula starting point; - Titrate to UO 0.5 mL/kg/hr adult (1 mL/kg pediatric); - Avoid over-resuscitation (fluid creep, ACS, ARDS); - Albumin debated, often added 12-24h; - Vitamin C high-dose protocol (modern); (4) Anesthetic considerations: - Difficult airway anticipated (edema, distortion); - Hypermetabolism + increased MAC after 48h burn; - Hypercatabolism + nutrition needs; - Hemodynamic instability; - Hypothermia risk; - Vascular access difficult; - Renal + hepatic dysfunction; - Coagulopathy + DIC; (5) Drug pharmacology: - Succinylcholine — AVOID > 24h post-burn (hyperkalemic arrest); use rocuronium; - NMB resistance — increased doses non-depolarizing; - Opioid tolerance + increased requirements; - Volatile resistance; (6) Pain management: - Severe burn pain + procedural pain; - Multimodal — opioid PCA, ketamine, gabapentinoid, regional (limited by burn location), dexmedetomidine; - Procedural sedation for dressing changes; (7) Surgery — early excision + grafting; multiple surgeries; (8) Sepsis risk high — burn wound infection; antibiotics judicious; (9) Multidisciplinary burn center; (10) Long-term — physical + psychological rehabilitation

---

Major burn: ABCDE + early airway, Parkland fluid (titrate to UO), inhalational injury (CO + cyanide), AVOID sux > 24h, NMB resistance, opioid tolerance + multimodal, multidisciplinary burn center.', NULL,
  'hard', 'trauma', 'review',
  'anesthesiology', 'clinical_decision', 'trauma', 'adult',
  'ABA Practice Guidelines; ATLS Burn', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 25 ปี — major burn 35% TBSA — emergency escharotomy + ongoing resuscitation
Burns chest, abdomen, both arms
Fluid resuscitation Parkland formula started'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยทารก 1 ปี 10 kg — post-op tonsillectomy + adenoidectomy, recovering in PACU
Develops progressive hypoxia, pink frothy secretions from airway, dyspnea
No bleeding evident', '[{"label":"A","text":"Diuretic only"},{"label":"B","text":"Negative Pressure Pulmonary Edema (NPPE) post-laryngospasm/airway obstruction"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Ignore symptoms"},{"label":"E","text":"Continue without intervention"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Negative Pressure Pulmonary Edema (NPPE) post-laryngospasm/airway obstruction: (1) Pathophysiology — forced inspiration against closed glottis → very negative intrapleural pressure → increased hydrostatic gradient → transudation alveoli; (2) Common settings: - Post-laryngospasm (most common in peds T+A); - Biting ETT (Type II NPPE); - Upper airway obstruction; - OSA; - Strangulation; (3) Clinical features: - Onset minutes after obstruction relieved; - Frothy/pink secretions; - Hypoxia; - Dyspnea, tachypnea; - Bilateral crackles; - Normal cardiac function (vs cardiogenic edema); (4) Diagnosis — clinical + CXR (bilateral pulmonary edema); echo to rule out cardiac (LV normal); (5) Management: - 100% O2; - Positive pressure ventilation (CPAP non-invasive or intubate + PEEP); - Furosemide selective (volume status concern in NPPE — usually euvolemic so questionable benefit); - Supportive — usually self-limited 12-24h; - Steroids questionable; (6) ICU/step-down monitoring; (7) Avoid: - Excessive fluid; - Repeat airway obstruction; (8) Prevention: - Laryngospasm prevention/treatment; - Pediatric airway expertise; - Magnesium adjunct; - Multimodal opioid-sparing; (9) Outcome — generally good with prompt recognition; (10) Pediatric considerations: - Smaller airway → more obstruction risk; - Rapid desaturation; - Cardiopulmonary reserve limited; - Family communication; - Observation 24h; (11) Modern: awareness + recognition; bedside ultrasound (B-lines)

---

NPPE: post-laryngospasm/airway obstruction → very negative pressure → pulmonary edema. Frothy/pink secretions, hypoxia. Mx: CPAP/PEEP, O2, supportive, usually 12-24h. Prevent: laryngospasm + multimodal anesthesia.', NULL,
  'medium', 'respiratory', 'review',
  'anesthesiology', 'clinical_decision', 'respiratory', 'peds',
  'APAGBI; SPA Pediatric', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยทารก 1 ปี 10 kg — post-op tonsillectomy + adenoidectomy, recovering in PACU
Develops progressive hypoxia, pink frothy secretions from airway, dyspnea
No bleeding evident'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 55 ปี — myasthenia gravis chronic on pyridostigmine — elective thymectomy
Mild generalized weakness, no recent crisis
FVC 75% predicted', '[{"label":"A","text":"Mass NMB doses"},{"label":"B","text":"Myasthenia gravis (MG) anesthesia"},{"label":"C","text":"Use sux high dose"},{"label":"D","text":"Magnesium routine"},{"label":"E","text":"Ignore TOF"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Myasthenia gravis (MG) anesthesia: (1) Pathophysiology — autoantibodies vs nicotinic acetylcholine receptors at NMJ → fluctuating weakness; (2) Pre-op: - Continue anticholinesterase (pyridostigmine) — debate timing of last dose pre-op (some hold to better assess intra-op NMB, others continue); - Assess severity (Osserman classification); - Pulmonary function (FVC) — predictor post-op ventilation; - Consider plasmapheresis or IVIG pre-op for severe; - Steroid stress dose if on chronic; - Multidisciplinary planning (neurology); (3) NMB considerations: - SENSITIVE to non-depolarizing NMB — reduce dose (rocuronium 0.3 mg/kg, 1/4 normal); titrate with TOF; - RESISTANT to succinylcholine (need higher dose 1.5-2 mg/kg); avoid generally; - Sugammadex 2-4 mg/kg for reversal — preferred over neostigmine (which paradoxically may worsen weakness in cholinergic crisis); - Quantitative TOF mandatory; (4) Volatile anesthetic potentiates weakness — be aware; (5) TIVA reasonable alternative — propofol + remifentanil; (6) Regional anesthesia useful adjunct (reduces opioid + NMB needs); (7) Drug interactions: - Avoid aminoglycosides (potentiate weakness); - Avoid certain antiarrhythmics (procainamide, quinidine); - Avoid magnesium (potentiates NMB); - Stress dose steroids if applicable; (8) Post-op concerns: - Myasthenic crisis vs cholinergic crisis (both cause weakness — differentiate); - Edrophonium test (rarely used now); - Plasmapheresis/IVIG; - Mechanical ventilation may be needed; (9) Risk factors post-op ventilation: - Duration MG > 6 years; - FVC < 2.9 L; - High pyridostigmine dose; - COPD; - Major intra-op blood loss; (10) Post-op monitoring ICU; multidisciplinary

---

MG: sensitive non-depolarizing NMB (1/4 dose), sugammadex reversal preferred, quantitative TOF, continue pyridostigmine, avoid aminoglycosides + magnesium. Post-op monitor for crisis. Plasmapheresis/IVIG. Multidisciplinary.', NULL,
  'medium', 'neurology', 'review',
  'anesthesiology', 'clinical_decision', 'neurology', 'adult',
  'Anesth Analg Practice; ASA Practice', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 55 ปี — myasthenia gravis chronic on pyridostigmine — elective thymectomy
Mild generalized weakness, no recent crisis
FVC 75% predicted'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 60 ปี Parkinson disease 10 ปี + DBS implanted — elective surgery
Meds: carbidopa-levodopa, MAO-B inhibitor selegiline
Mild dyskinesia, tremor controlled', '[{"label":"A","text":"Stop levodopa"},{"label":"B","text":"Parkinson disease + anesthesia"},{"label":"C","text":"Use metoclopramide"},{"label":"D","text":"Heavy sedation"},{"label":"E","text":"Ignore DBS"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Parkinson disease + anesthesia: (1) Pre-op: - Continue PD medications maximally (carbidopa-levodopa) — schedule around surgery; - Last dose pre-op timed; - Resume ASAP post-op via NG or PR (if PO not tolerated); - Withdrawal precipitates ''off'' periods + rigidity + risk neuroleptic malignant-like syndrome; - MAO-B inhibitor (selegiline) — typically continue; older non-selective MAOIs require drug interaction caution; (2) Drug interactions/avoidances: - Avoid antiemetics that block D2 (metoclopramide, droperidol, prochlorperazine, haloperidol) — worsen parkinsonism; - Ondansetron acceptable; - Avoid meperidine (serotonin syndrome with MAOI); - Cautious with sympathomimetic + MAOI (hypertensive crisis); - Avoid neuroleptic; (3) DBS considerations: - Verify with neurologist if DBS should remain on or be turned off intra-op; usually turned off if electrocautery (electromagnetic interference + heating); bipolar cautery preferred; - Pacemaker-like considerations; - Programming reassessment post-op; - MRI considerations (some DBS MRI-conditional); (4) Anesthetic technique: - Regional preferred when possible (avoid GA + reduces medication interaction); - GA: propofol OK, sevoflurane OK, fentanyl/remifentanil OK; - Avoid heavy sedation/long-acting opioid if PD with cognitive issues; - Aspiration risk (autonomic dysfunction, swallowing); - Postoperative confusion + delirium risk; (5) Autonomic dysfunction: - Orthostatic hypotension — careful position changes, IV fluid; - Tachycardia/bradycardia; - Constipation; - Urinary retention; (6) Aspiration risk — RSI considerations; (7) Post-op: - Resume PD meds urgently; - Multimodal opioid-sparing analgesia; - Early mobilization; - Aspiration precautions; - Delirium prevention bundle; (8) Multidisciplinary: anesthesia + surgery + neurology; (9) Modern: increasing PD population + DBS implants

---

PD: continue carbidopa-levodopa, AVOID D2 antagonists (metoclopramide, droperidol), DBS off for cautery + bipolar, regional preferred, aspiration + delirium prevention. Resume PD meds urgently post-op. Multidisciplinary.', NULL,
  'medium', 'neurology', 'review',
  'anesthesiology', 'clinical_decision', 'neurology', 'adult',
  'ASA Practice; Movement Disorders Society', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 60 ปี Parkinson disease 10 ปี + DBS implanted — elective surgery
Meds: carbidopa-levodopa, MAO-B inhibitor selegiline
Mild dyskinesia, tremor controlled'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 28 ปี G2P1 GA 30 wk — twin pregnancy, severe pre-eclampsia
Magnesium running, BP controlled
Weight 95 kg, BMI 38, gestational diabetes
C-section planned', '[{"label":"A","text":"Skip neuraxial"},{"label":"B","text":"Twin C-section + obesity + PEC + DM"},{"label":"C","text":"Routine anesthesia"},{"label":"D","text":"Heavy sedation"},{"label":"E","text":"Ignore comorbidities"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Twin C-section + obesity + PEC + DM — high-risk OB anesthesia: (1) Multiple risk factors compound complications; (2) Airway: - Obesity + pregnancy + PEC edema = anticipated difficult; - Pre-O2 thorough (rapid desaturation); - Ramped position; - Video laryngoscopy first; - Difficult airway equipment ready; (3) Anesthetic technique decision: - Neuraxial preferred if no contraindication; - Platelets (PEC) — generally OK > 70-80k; - Spinal vs epidural vs CSE; - Spinal may have profound hypotension in twins (higher uterine pressure, multiple); titrated dose lower; - CSE good balance — flexible duration + reduced dose; (4) Hemodynamic considerations: - Aortocaval compression worse in twins + obesity (left lateral tilt 30°); - Magnesium effects (mild vasodilation, NMB potentiation); - PEC — pulmonary edema risk (cautious fluids); - PEC — avoid HTN surge at intubation if GA; (5) Glucose management — gestational DM: - Insulin sliding scale or infusion; - Target intra-op 100-180; - Avoid hypoglycemia (fetal effects); (6) Multiple babies — neonatal team ready, separate teams ideal; (7) Post-partum considerations: - Atony risk increased (twins, magnesium); aggressive uterotonic; - PEC — continue magnesium 24h, BP control, fluid balance, pulmonary edema risk, eclampsia, AKI; - Thromboembolic prophylaxis (obese + PEC + post-op); - Pain control — multimodal, neuraxial morphine, intrathecal hydromorphone, TAP block, acetaminophen + NSAID (post-delivery OK); (8) ICU/HDU monitoring; (9) Glycemic management transition postpartum; (10) Multidisciplinary: OB + anesthesia + neonatology + MFM + ICU + nursing

---

High-risk OB: difficult airway, neuraxial preferred (platelets > 80k), aortocaval compression worse twins/obesity, magnesium + PEC + DM + atony management. Multidisciplinary. ICU postpartum. Multimodal analgesia.', NULL,
  'hard', 'obgyn', 'review',
  'anesthesiology', 'clinical_decision', 'obgyn', 'adult',
  'SOAP High-Risk OB; ACOG', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 28 ปี G2P1 GA 30 wk — twin pregnancy, severe pre-eclampsia
Magnesium running, BP controlled
Weight 95 kg, BMI 38, gestational diabetes
C-section planned'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 70 ปี — anesthesia for ECT (Electroconvulsive Therapy) for severe depression refractory
5 sessions weekly
On citalopram, mirtazapine', '[{"label":"A","text":"No anesthesia needed"},{"label":"B","text":"ECT anesthesia"},{"label":"C","text":"Heavy sedation continuous"},{"label":"D","text":"Skip NMB"},{"label":"E","text":"Avoid ECT all patients"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** ECT anesthesia: (1) Goals — induce brief generalized seizure (> 25 seconds) under anesthesia with NMB; (2) Pre-procedure: - Medical clearance (cardiac, neuro); - NPO; - IV access; - Standard ASA monitoring + EEG/EMG; - Mouthguard (protect teeth from masseter contraction); (3) Anesthetic technique: - Induction: methohexital (traditional) 1-1.5 mg/kg OR propofol 0.5-1 mg/kg (less seizure duration); etomidate alternative (longer seizure); ketamine 0.5-1 mg/kg (longer + better quality seizures, used for refractory); - Pre-oxygenate; - NMB: succinylcholine 0.5-1 mg/kg (lower dose than RSI — purpose is to attenuate convulsion not full paralysis); rocuronium + sugammadex alternative; - Mask ventilation during seizure (no intubation typically); - Glycopyrrolate pre-treatment (secretions + bradycardia); (4) Cardiovascular: - Initial parasympathetic surge (bradycardia, asystole) — atropine if severe; - Then sympathetic surge (tachycardia, hypertension) — beta-blocker (esmolol or labetalol) or labetalol pre-treatment for cardiac patients; - Monitor closely; (5) Cerebral: - Increased CBF, ICP, IOP, intragastric pressure transient; - Caution in space-occupying lesion, recent stroke, increased ICP; (6) Seizure parameters: - Target 25-60 seconds; - Inadequate: increase stimulus, change anesthetic (ketamine), reduce anesthetic if too deep, hyperventilate, withhold benzo, caffeine 500 mg pre-treatment; (7) Drug considerations: - SSRI continue (no contraindication); - MAOI (caution sympathomimetic interaction); - Lithium — neurotoxicity risk increased — debate continue vs hold; - Benzodiazepines decrease seizure (hold if possible); - Anticonvulsants for non-ECT reasons — debate; (8) Recovery: - Headache, confusion, myalgia common; - Anterograde amnesia (treatment + side effect); - Multimodal post-ECT (acetaminophen, ondansetron); (9) Series of treatments; (10) Multidisciplinary: psychiatry + anesthesia + nursing

---

ECT anesthesia: methohexital/propofol/ketamine + sux + mask ventilation. Glycopyrrolate. Treat parasympathetic then sympathetic surge. Seizure 25-60 sec target. Hold benzo. Multidisciplinary.', NULL,
  'medium', 'psych_behavior', 'review',
  'anesthesiology', 'clinical_decision', 'psych_behavior', 'adult',
  'ASA ECT Practice; APA Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 70 ปี — anesthesia for ECT (Electroconvulsive Therapy) for severe depression refractory
5 sessions weekly
On citalopram, mirtazapine'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 50 ปี HIV+ controlled on ART, CD4 450, undetectable VL — elective ortho surgery
Meds: dolutegravir/abacavir/lamivudine, statins
No opportunistic infections', '[{"label":"A","text":"Stop ART"},{"label":"B","text":"HIV/AIDS perioperative care"},{"label":"C","text":"Refuse care"},{"label":"D","text":"Treat as terminal"},{"label":"E","text":"Hide diagnosis"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** HIV/AIDS perioperative care: (1) Effective ART has transformed HIV from terminal to chronic — perioperative care similar to non-HIV in well-controlled patients; (2) Pre-op assessment: - CD4 count + viral load; well-controlled (CD4 > 200, undetectable VL) — comparable outcomes; - Comorbidities: cardiovascular (accelerated atherosclerosis), renal (HIV-associated nephropathy + tenofovir), bone (osteoporosis), neuropathy, depression; - Opportunistic infections screen; - Drug interactions; (3) Continue ART perioperatively: - Avoid interruption (resistance, viral rebound); - Coordinate with HIV specialist if NPO prolonged; - Some IV formulations available; (4) Drug interactions: - Protease inhibitors + integrase inhibitors — CYP3A4 effects; - Boosted regimens (ritonavir, cobicistat) — many interactions: midazolam, fentanyl (increased levels), opioids; - Anesthetic implications variable; - Methadone interactions; (5) Universal precautions — standard for all patients (HIV status often unknown); (6) Anesthetic technique — no specific contraindications; regional anesthesia OK; (7) Wound healing — comparable to non-HIV in well-controlled; AIDS (CD4 < 200) may have impaired healing; (8) Infection risk: - Comparable in well-controlled; - Antibiotic prophylaxis standard; - Opportunistic infection screen (CMV, PCP, TB) — selective; (9) Healthcare worker considerations: - Standard precautions; - Post-exposure prophylaxis (PEP) if exposure; - Hepatitis B + C considerations; (10) Stigma awareness — confidentiality + equitable care; (11) Psychiatric — depression, substance use, social factors; (12) Modern: HIV similar to other chronic illness, integrated care

---

HIV well-controlled: similar outcomes, continue ART, drug interactions (PI, integrase, boosted), universal precautions, no special anesthetic contraindications. Confidentiality + equitable care. Modern: chronic illness paradigm.', NULL,
  'easy', 'procedures', 'review',
  'anesthesiology', 'clinical_decision', 'procedures', 'adult',
  'ASA HIV Practice; HIVMA Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 50 ปี HIV+ controlled on ART, CD4 450, undetectable VL — elective ortho surgery
Meds: dolutegravir/abacavir/lamivudine, statins
No opportunistic infections'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'EMS/Management: anesthesia for environmentally sustainable practice', '[{"label":"A","text":"Maximum FGF always"},{"label":"B","text":"Sustainable anesthesia practice"},{"label":"C","text":"Use desflurane preferentially"},{"label":"D","text":"Ignore sustainability"},{"label":"E","text":"Single-use only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Sustainable anesthesia practice: (1) Healthcare contributes 4-5% global greenhouse gases; anesthesia significant contributor; (2) Volatile anesthetics carbon footprint: - Desflurane WORST (2540× CO2 equivalent per kg, 14-year atmospheric lifetime); - Sevoflurane modest (130×, 1.1 year); - Isoflurane intermediate (510×, 3.2 year); - N2O significant (265×, 114 years); also ozone depleter; - 1 hour desflurane = driving 100 km; (3) Reduce volatile impact: - Lower FGF (fresh gas flow) 1-2 L/min — major reduction; - Avoid desflurane when alternatives appropriate; - Avoid N2O when alternatives; - TIVA reduces volatile entirely (but propofol packaging waste); - Charcoal-based volatile capture systems (Centurio, Deltasorb) emerging; (4) Other sustainability: - Reduce single-use plastic; - Reusable when safe + cost-effective; - Pharmaceutical waste reduction (right-sizing doses); - Equipment lifecycle assessment; - LED lighting + HVAC efficiency; - Local + sustainable supply chain; (5) Specific practices: - Open circuit avoid; - LMA reusable available; - Drug syringe sizing (avoid waste); - Procedure-appropriate equipment; (6) Patient + organizational benefits: - Cost savings (lower FGF, less waste); - Improved care continuity (greener operations); - Healthier workforce + community; (7) ASA Committee on Equipment + Facilities + Environmental Stewardship; (8) Code Green NHS UK + similar initiatives; (9) Personal + institutional advocacy: - Education + awareness; - Practice changes; - Procurement decisions; - Research; (10) Modern: regulatory pressure (EU desflurane ban 2026), accreditation incentives, anesthesia leadership in sustainability

---

Sustainability: anesthesia significant GHG. Desflurane WORST, N2O ozone depleter. Reduce FGF, avoid desflurane + N2O, TIVA option, charcoal capture. Plastic reduction. Cost savings + patient benefit. ASA + Code Green advocacy.', NULL,
  'easy', 'respiratory', 'review',
  'anesthesiology', 'ems_mgmt', 'respiratory', 'adult',
  'ASA Environmental Stewardship; Code Green NHS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'EMS/Management: anesthesia for environmentally sustainable practice'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'EMS/Management: anesthesia leadership + administration', '[{"label":"A","text":"Avoid leadership"},{"label":"B","text":"Anesthesia leadership + administration"},{"label":"C","text":"Single-handed decisions"},{"label":"D","text":"Ignore finances"},{"label":"E","text":"Skip quality"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Anesthesia leadership + administration: (1) Roles: - Chief of Anesthesia; - Department chair; - Medical director OR/PACU; - Quality + safety officer; - Educational director; - Research director; - Wellness officer; - Equity, Diversity, Inclusion (EDI) officer; (2) Skills required: - Clinical credibility; - Vision + strategic planning; - Communication + interpersonal; - Conflict resolution; - Financial management; - Quality improvement; - Operations + workflow; - Personnel management; - Mentorship; (3) Operating room management: - Block scheduling; - Add-on management; - First case on-time start; - Turnover; - Utilization metrics; - Surgeon + nurse coordination; (4) Financial: - Reimbursement (insurance, value-based); - Coding (CPT, ASA, modifiers, time-based, units); - Productivity (RVU); - Cost management; - Investment decisions (equipment, technology); (5) Quality + safety: - Adverse event review; - Quality improvement projects (PDSA); - Benchmarking (NACOR, MIPS); - Risk management; - Credentialing + privileging; (6) Educational: - Resident program; - CME; - Simulation; - Faculty development; (7) Research: - IRB; - Funding; - Mentorship; - Collaboration; (8) Workforce: - Recruitment; - Retention; - Mentorship; - Wellness; - Burnout; - Succession planning; (9) Patient experience: - Satisfaction surveys; - HCAHPS; - Communication training; (10) Interdisciplinary collaboration: - Surgical specialties; - Nursing; - Hospital administration; - Insurance + payers; - Community; (11) Modern: data-driven, value-based care, telemedicine, AI integration; (12) Professional organizations: - ASA, ASAM, ARAS — engagement + advocacy

---

Anesthesia leadership: vision + strategic + operations + financial + quality + workforce + education + research. Multidisciplinary. Modern: data-driven, value-based. Professional engagement. EDI + wellness focus.', NULL,
  'easy', 'procedures', 'review',
  'anesthesiology', 'ems_mgmt', 'procedures', 'adult',
  'ASA Practice Management; AANA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'EMS/Management: anesthesia leadership + administration'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Basic science: physics of monitoring — pulse oximetry + capnography', '[{"label":"A","text":"Skip oximetry"},{"label":"B","text":"Pulse oximetry + capnography physics"},{"label":"C","text":"100% accurate always"},{"label":"D","text":"Ignore limitations"},{"label":"E","text":"Single wavelength"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pulse oximetry + capnography physics: (1) Pulse oximetry: - Principle: Beer-Lambert law — absorption of red (660 nm) + infrared (940 nm) light by oxy- vs deoxyhemoglobin; - Pulsatile flow = arterial signal (ratio of pulsatile absorption red:IR converted to SpO2); - Accuracy ± 2% above SpO2 90%; (2) Limitations: - Motion artifact; - Poor perfusion (hypothermia, shock, vasoconstrictor); - Nail polish, henna; - Dyshemoglobinemia: - Carboxyhemoglobin (CO poisoning) — falsely HIGH (co-ox needed); - Methemoglobinemia — reads ~85% regardless of true; - Sulfhemoglobin; - Anemia — accuracy maintained until severe; - Ambient light interference; - Dye (methylene blue, indigo carmine — temporary drop); - Skin pigmentation — recent concerns of bias in dark skin (FDA review); (3) Pulse co-oximetry (Masimo) — measures additional wavelengths for SpCO, SpMet, SpHb (continuous Hb); (4) Capnography: - Infrared absorption (CO2 absorbs specific IR); - Mainstream (heated, in airway) vs sidestream (sample drawn out); - Time-based waveform — 4 phases; - Volumetric capnography emerging; (5) Limitations: - Delay sidestream; - Water + secretions; - Disconnection misread as zero; - High RR/short breaths may underestimate; (6) Clinical applications (covered separately); (7) Other monitoring: - Cerebral oximetry (NIRS) — regional brain O2 (rSO2); useful cardiac, beach chair, complex; - SedLine + BIS — processed EEG depth; - Esophageal Doppler — CO; - Pulse contour CO analysis (FloTrac, LiDCO); (8) Standards — continuous SpO2 + capnography for anesthesia + moderate/deep sedation; (9) Modern: integrated multi-parameter monitors, wearable continuous monitoring

---

Pulse ox: Beer-Lambert, R+IR ratio. Limitations: motion, perfusion, CO/MetHb, anemia, pigmentation. Capnography: IR absorption. Limitations: water, RR. NIRS/BIS/Doppler/pulse contour. Standards continuous.', NULL,
  'easy', 'respiratory', 'review',
  'anesthesiology', 'basic_science', 'respiratory', 'adult',
  'ASA Standards Monitoring; Miller''s', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Basic science: physics of monitoring — pulse oximetry + capnography'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Basic science: muscular dystrophies + anesthesia', '[{"label":"A","text":"Use sux + volatile"},{"label":"B","text":"Muscular dystrophies + anesthesia"},{"label":"C","text":"Adult routine doses"},{"label":"D","text":"Ignore cardiac"},{"label":"E","text":"Refuse care"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Muscular dystrophies + anesthesia: (1) Categories: - Duchenne (DMD) + Becker (BMD) — X-linked; - Myotonic dystrophy — autosomal dominant; - Limb-girdle; - Facioscapulohumeral; (2) DMD: - Progressive proximal weakness, cardiomyopathy, scoliosis, respiratory failure; - AVOID succinylcholine (hyperkalemic arrest, rhabdomyolysis); - AVOID volatile anesthetics (MH-like reactions — anesthesia-induced rhabdomyolysis); - Use TIVA (propofol + opioid); - Cardiac assessment (cardiomyopathy); - Pulmonary assessment (restrictive); - NMB cautious (non-depolarizing OK at reduced dose with TOF); - Spinal anesthesia OK if scoliosis allows; (3) Myotonic dystrophy: - Sustained muscle contraction (myotonia); - Multisystem involvement (cardiac conduction, GI, endocrine, CNS); - AVOID succinylcholine (sustained myotonic contraction); - Caution all NMB; - Sensitive to opioids, sedatives, volatile (respiratory depression); - Cardiac conduction abnormalities — pacing readiness; - Temperature regulation; - Multimodal opioid-sparing; - Regional anesthesia helpful; - Avoid neostigmine (may worsen myotonia); use sugammadex if rocuronium; (4) Anesthesia-Induced Rhabdomyolysis (AIR): - Similar to MH but distinct mechanism — sarcolemmal damage; - Volatile triggers; - Treatment: stop volatile, supportive, IVF + alkalinization for myoglobinuria, monitor K + CK; - NO dantrolene (different mechanism); (5) Cardiac considerations: - Cardiomyopathy → consider as such for management; - Conduction abnormalities → ECG, electrophysiology consult; (6) Respiratory: - Restrictive disease; - Cough impaired; - Risk post-op ventilatory failure; - Avoid long-acting opioid; (7) Multidisciplinary: anesthesia + neurology + cardiology + pulmonology + physical therapy

---

Muscular dystrophies: DMD/BMD avoid sux + volatile (AIR), TIVA. Myotonic: avoid sux (sustained contraction), conduction abnormalities, NMB caution. Cardiomyopathy + respiratory assessment. Multidisciplinary.', NULL,
  'medium', 'neurology', 'review',
  'anesthesiology', 'basic_science', 'neurology', 'adult',
  'ASA Practice; Pediatric Anesthesia', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Basic science: muscular dystrophies + anesthesia'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Basic science: pharmacology of common anesthesia adjuvants — ketamine, magnesium, lidocaine infusion', '[{"label":"A","text":"Single opioid only"},{"label":"B","text":"Anesthesia adjuvants"},{"label":"C","text":"Skip multimodal"},{"label":"D","text":"Adult only"},{"label":"E","text":"Avoid all adjuvants"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Anesthesia adjuvants — opioid-sparing: (1) Ketamine: - NMDA antagonist; - Sub-anesthetic dose 0.1-0.5 mg/kg bolus + 0.1-0.3 mg/kg/hr infusion; - Anti-hyperalgesic + analgesic + opioid-sparing; - Useful: chronic opioid users, opioid-induced hyperalgesia, complex regional pain syndrome, depression (intranasal esketamine FDA-approved); - Side effects: sympathomimetic (HTN, tachy), psychomimetic (hallucinations — combine with low-dose benzo), salivation; (2) Magnesium: - NMDA antagonist + Ca channel blockade + smooth muscle relaxation; - Loading 30-50 mg/kg + infusion 8-15 mg/kg/hr; - Reduces opioid requirement, post-op pain, PONV, shivering, asthma; - Side effects: hypotension, flushing, sedation, NMB potentiation, respiratory depression at high levels; - Monitor reflexes + RR + serum Mg; (3) Lidocaine infusion: - Na channel block; - Bolus 1.5 mg/kg + infusion 1-3 mg/kg/hr; - Anti-inflammatory + analgesic; - Reduces opioid + ileus + PONV; - Useful: abdominal surgery, spine, breast; - Side effects: LAST (CNS, CV) — monitor signs + symptoms; - Avoid in heart block, severe hepatic dysfunction; (4) Dexmedetomidine (covered separately): alpha-2 agonist, sedation + analgesia + sympatholysis, no respiratory depression; (5) Dexamethasone: - Steroid; 4-10 mg single dose; - Anti-inflammatory + antiemetic + analgesic + airway swelling; - Hyperglycemia concern minimal single dose; (6) Gabapentinoids (gabapentin, pregabalin): - Voltage-gated Ca channel modulation; - Pre-op 300-1200 mg gabapentin or 75-300 mg pregabalin; - Reduces opioid + acute pain + chronic pain prevention; - Side effects: sedation, dizziness, especially elderly; recent guidelines suggest selective use rather than routine; (7) Acetaminophen IV: 1g; consistent multimodal; (8) NSAID (ketorolac 15-30 mg, celecoxib 200-400 mg); (9) Modern: multimodal opioid-sparing routine for major surgery; ERAS protocols

---

Adjuvants: ketamine (NMDA, anti-hyperalgesic), magnesium (NMDA + Ca), lidocaine infusion (Na channel, anti-inflammatory), dex (anti-inflammatory + analgesic), gabapentinoid (selective use), acetaminophen + NSAID. ERAS multimodal opioid-sparing standard.', NULL,
  'easy', 'procedures', 'review',
  'anesthesiology', 'basic_science', 'procedures', 'adult',
  'ASA Practice Advisory; ERAS Society', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Basic science: pharmacology of common anesthesia adjuvants — ketamine, magnesium, lidocaine infusion'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Integrative: ethics in anesthesia practice', '[{"label":"A","text":"Ignore ethics"},{"label":"B","text":"Anesthesia ethics"},{"label":"C","text":"Single principle only"},{"label":"D","text":"Hide errors"},{"label":"E","text":"Discriminate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Anesthesia ethics: (1) Core principles: - Autonomy — patient self-determination, informed consent; - Beneficence — act in patient''s best interest; - Non-maleficence — first, do no harm; - Justice — fair distribution + access; (2) Common ethical dilemmas: - DNR in OR (covered); - Jehovah''s Witness blood refusal; - Capacity + surrogate decisions; - Disclosure of error; - End-of-life care + withdrawal; - Resource allocation (mass casualty, transplant); - Conflict of interest; - Confidentiality + privacy; - Pediatric assent + adolescent autonomy; - Pregnancy + fetal interests; - Substance use + impairment colleagues; - Caring for difficult patients; - Treatment of incarcerated patients; (3) Decision-making frameworks: - Four boxes (Jonsen): medical indications, patient preferences, quality of life, contextual features; - Multidisciplinary ethics consult; - Ethics committees; (4) Informed consent process: - Voluntary; - Capacity assessment; - Information disclosure; - Documentation; (5) Truth-telling: - Honest communication; - Cultural sensitivity; - Bad news delivery skills; (6) Confidentiality: - HIPAA; - Limits (mandatory reporting, public health, immediate safety); (7) Resource allocation: - ICU bed; - Transplant organ; - Crisis standards of care (pandemic); - Triage (mass casualty); (8) Professional ethics: - Maintain competence (MOC); - Avoid impairment; - Report colleague impairment/error; - Conflict of interest disclosure; - Industry relationships; (9) Research ethics: - Belmont Report (respect, beneficence, justice); - IRB; - Informed consent; - Vulnerable populations; - Data integrity; (10) Modern: precision medicine, AI ethics, digital health, genetic information, environmental ethics; (11) Resources: - ASA Statement on Ethical Practice; - AMA Code of Medical Ethics; - WMA Declaration of Geneva; - Bioethics literature

---

Anesthesia ethics: autonomy + beneficence + non-maleficence + justice. Common dilemmas: DNR, Jehovah''s Witness, capacity, disclosure, end-of-life. Four boxes framework. Ethics consult. Modern: AI, digital, environmental ethics.', NULL,
  'easy', 'psych_behavior', 'review',
  'anesthesiology', 'integrative', 'psych_behavior', 'adult',
  'ASA Ethical Practice; AMA Code Ethics', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Integrative: ethics in anesthesia practice'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Integrative: communication with patients + family — bad news + difficult conversations', '[{"label":"A","text":"Avoid difficult conversations"},{"label":"B","text":"Difficult conversations + bad news"},{"label":"C","text":"Single quick statement"},{"label":"D","text":"Skip empathy"},{"label":"E","text":"Hide info"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Difficult conversations + bad news: (1) SPIKES protocol — bad news: - Setting (privacy, sit down, no distraction); - Perception (what patient knows); - Invitation (how much info wanted); - Knowledge (clear language, no jargon, pause for comprehension); - Emotion (acknowledge, empathize, support); - Strategy + summary (plan, follow-up); (2) Other models — NURSE (Name, Understand, Respect, Support, Explore emotions), Ask-Tell-Ask; (3) Anesthesia-specific scenarios: - Pre-op consent risk disclosure; - Adverse event disclosure (intraop awareness, dental injury, nerve injury, mortality); - Death notification; - End-of-life discussions; - Substance use disorder; - Chronic pain — realistic expectations; - Difficult family interactions; (4) Disclosure of adverse events: - Honest + timely; - Express empathy + apology (sorry vs admit fault — vary by jurisdiction; many states have apology laws); - Factual + non-defensive; - Documentation; - Institutional support; - Multidisciplinary; - Follow-up; (5) Family meetings: - Multidisciplinary; - Prepared agenda; - Patient/family-centered; - Cultural + spiritual considerations; - Decision aid + clarify; - Document discussion + outcomes; (6) Specific situations: - Pediatric — developmentally appropriate, parents, child life; - Cognitive impairment — surrogate; - LEP — interpreter; - Cultural differences — humility; (7) Communication skills training: - Simulation; - Real-time feedback; - Mentorship; (8) Self-care for provider: - Vicarious trauma; - Second victim phenomenon; - Debriefing; - Support resources; (9) Cognitive biases — anchoring, availability, confirmation; awareness; (10) Modern: cultural humility, structural humility, narrative medicine, patient-centered care, family-witnessed resuscitation

---

Difficult conversations: SPIKES (Setting, Perception, Invitation, Knowledge, Emotion, Strategy), NURSE. Disclosure (honest + empathic + apology). Multidisciplinary family meetings. Cultural + spiritual considerations. Self-care. Modern: patient-centered + humility.', NULL,
  'easy', 'psych_behavior', 'review',
  'anesthesiology', 'integrative', 'psych_behavior', 'adult',
  'ASA Practice; AAMC Communication', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Integrative: communication with patients + family — bad news + difficult conversations'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Integrative: research + clinical practice — translating evidence', '[{"label":"A","text":"Ignore evidence"},{"label":"B","text":"Translational research + evidence-based practice"},{"label":"C","text":"Rapid adoption all"},{"label":"D","text":"Single discipline"},{"label":"E","text":"Skip improvement"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Translational research + evidence-based practice: (1) Research to practice gap — 17 years average; addressing: - Implementation science: - Diffusion of innovation; - Knowledge translation; - Quality improvement; (2) Levels of translation: - T1: bench to bedside (drug development); - T2: clinical research to clinical practice; - T3: practice to community/population; - T4: policy + health outcomes; (3) Implementation science frameworks: - CFIR (Consolidated Framework Implementation Research); - PARIHS (Promoting Action Research Implementation); - RE-AIM (Reach, Effectiveness, Adoption, Implementation, Maintenance); (4) Quality improvement methodology: - PDSA (Plan, Do, Study, Act); - Six Sigma; - Lean; - Audit + feedback; - Clinical practice guidelines; - Pathways + protocols; (5) Barriers to adoption: - Time + workload; - Knowledge gaps; - Habit; - Patient + colleague resistance; - System constraints; - Resource limitations; (6) Facilitators: - Leadership champion; - Education; - Aligned incentives; - System redesign; - Feedback; - Patient + family engagement; (7) Anesthesia examples: - ERAS adoption; - Multimodal opioid-sparing; - Lung-protective ventilation; - Goal-directed fluid therapy; - Quality programs (NACOR, MIPS); (8) Maintenance + sustainability: - Continuous improvement; - Avoid drift; - Update guidelines; - Re-train; (9) Patient engagement: - Co-design; - Patient-reported outcomes; - Shared decision-making; - Lived experience; (10) Modern: big data, AI/ML, learning health systems, registries (NACOR), comparative effectiveness research, real-world evidence; (11) Resources: - Cochrane; - ASA practice advisories; - Evidence-Based Anesthesia; - Anesthesia & Analgesia Translational Research

---

Translational research: gap 17 years. Levels T1-T4. Implementation science (CFIR, RE-AIM). QI methodology (PDSA). Barriers + facilitators. Anesthesia examples (ERAS, multimodal). Modern: big data + AI/ML + learning health systems.', NULL,
  'easy', 'procedures', 'review',
  'anesthesiology', 'integrative', 'procedures', 'adult',
  'AHRQ; Implementation Science; Cochrane', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Integrative: research + clinical practice — translating evidence'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Integrative: telemedicine + anesthesia (pre-op, post-op, ICU)', '[{"label":"A","text":"Avoid telemedicine"},{"label":"B","text":"Telemedicine in anesthesia"},{"label":"C","text":"Same as in-person all"},{"label":"D","text":"Skip security"},{"label":"E","text":"No documentation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Telemedicine in anesthesia: (1) Pre-op telemedicine: - Pre-anesthesia evaluation virtual; - Especially useful for ambulatory + remote patients; - Time + cost savings; - High satisfaction; - Limitations: airway exam, physical exam; - Hybrid (virtual + in-person) common; (2) Tele-ICU: - Centralized ICU monitoring + consultation; - 24/7 intensivist coverage rural/community; - Quality + mortality improvements; - Care plans + medication review; - Family communication; (3) Tele-anesthesia OR: - Mentorship + supervision remote; - Difficult case consultation; - Mass casualty + disaster; - Global health applications; (4) Tele-PACU + tele-rounding; (5) Mobile apps + wearables: - Patient monitoring (BP, SpO2, glucose, sleep); - Medication adherence; - Pain tracking; - Recovery monitoring; (6) Patient education: - Videos; - Apps; - Tele-consultation; - Cultural translation; (7) Limitations + challenges: - Technology access (digital divide); - Privacy + security; - Reimbursement (evolving); - Licensing + jurisdiction; - Liability + standard of care; - Cultural + language; - Physical exam limitations; - Procedure-specific (cannot do all in person); (8) COVID-19 pandemic accelerated adoption; (9) Quality + safety: - Same standards apply; - Documentation requirements; - Technical reliability; (10) Specific anesthesia applications: - Pre-anesthesia clinic; - Pain medicine consultation; - Critical care; - Disaster response; - Global health partnerships; - Education + simulation; (11) Modern: telemedicine integral to healthcare; ASA guidance + advocacy; ongoing reimbursement + regulation evolution

---

Telemedicine anesthesia: pre-op evaluation + tele-ICU + tele-PACU + mentorship + global health. Limitations: physical exam, technology access, reimbursement. COVID accelerated. Same standards + documentation. ASA guidance.', NULL,
  'easy', 'procedures', 'review',
  'anesthesiology', 'integrative', 'procedures', 'adult',
  'ASA Telemedicine; ATA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Integrative: telemedicine + anesthesia (pre-op, post-op, ICU)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 60 ปี — major spine surgery (4 levels posterior fusion) prone position 6 hr
Blood loss 1500 mL, MAP maintained > 65, urine output adequate
At extubation: severe periorbital edema + conjunctival edema', '[{"label":"A","text":"Ignore edema"},{"label":"B","text":"Post-prone position post-op visual loss (POVL) concern"},{"label":"C","text":"Hold ophthalmology"},{"label":"D","text":"Discharge immediately"},{"label":"E","text":"Skip checks"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-prone position post-op visual loss (POVL) concern: (1) POVL = devastating complication: - Ischemic Optic Neuropathy (ION) — anterior or posterior; - Central Retinal Artery Occlusion (CRAO) — direct eye pressure; - Cortical blindness — rare; (2) Risk factors: - Prone prolonged > 6h; - Blood loss > 1L; - Anemia (low Hct); - Hypotension (MAP < 65); - Direct eye pressure; - Steep Trendelenburg; - Volume + colloid use (large volume crystalloid worse); - Vascular risk factors (HTN, DM, CAD, smoking); (3) Pre-op + intra-op prevention (ASA POVL Practice Advisory): - Patient counseling for high-risk procedures; - Stage long procedures; - Eyes free from pressure (foam pad or Mayfield clamp); - Regular eye checks q15-30 min; - Head level with or higher than heart; - MAP > 70; - Limit blood loss + early transfusion; - Avoid extreme Trendelenburg; - Mix colloid + crystalloid (avoid excessive crystalloid); - Communicate with surgeon; (4) Recognition post-op: - Visual symptoms — blurring, blindness, scotoma; - Bilateral usually for ION; - Painless; - May not be immediately apparent (delayed days); - Comprehensive eye exam by ophthalmology; (5) Treatment ION (limited options): - Increase O2 carriage (transfuse if anemic); - Increase blood flow (avoid hypotension, head up); - Hyperbaric O2 controversial; - Steroids controversial; - Outcomes generally poor; (6) Other prone complications: - Brachial plexus, ulnar, lateral femoral cutaneous, peroneal injuries; - Pressure ulcers; - Tongue + lip injury; - ETT dislodgement; - Hemodynamic; (7) Periorbital edema common after prone — usually resolves; concerning if visual symptoms or persistent; (8) Multidisciplinary: anesthesia + surgery + ophthalmology

---

POVL: ION + CRAO + cortical blindness. Risk: prone > 6h, blood loss, anemia, hypotension, eye pressure. ASA POVL Practice Advisory prevention. Limited treatment options. Multidisciplinary. Documentation + counseling.', NULL,
  'medium', 'neurology', 'review',
  'anesthesiology', 'clinical_decision', 'neurology', 'adult',
  'ASA POVL Practice Advisory 2019', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 60 ปี — major spine surgery (4 levels posterior fusion) prone position 6 hr
Blood loss 1500 mL, MAP maintained > 65, urine output adequate
At extubation: severe periorbital edema + conjunctival edema'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 50 ปี — emergent neurosurgical evacuation of subdural hematoma
GCS 8 deteriorating, pupils equal reactive, intubated by EMS
BP 175/95, HR 60', '[{"label":"A","text":"Aggressive hypotension"},{"label":"B","text":"Acute SDH + emergent craniotomy anesthesia"},{"label":"C","text":"Hypotonic fluids"},{"label":"D","text":"High volatile + N2O"},{"label":"E","text":"Skip osmotherapy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute SDH + emergent craniotomy anesthesia: (1) Cushing''s reflex (HTN + bradycardia) suggests elevated ICP + impending herniation; (2) Pre-induction: - Maintain intubation + 100% O2; - Mild hyperventilation (PaCO2 30-35) only if herniation; otherwise normocapnia; - Head up 30°; - Hyperosmolar therapy (3% saline 250 mL or mannitol 0.5-1 g/kg); - Sedation + analgesia (avoid awareness from neuromuscular blockade); - Anticonvulsant (levetiracetam 1g IV); - Avoid hypotension (worsens secondary injury); (3) Anesthesia induction (already intubated): - Propofol bolus + opioid (fentanyl) + maintain sedation; - Rocuronium for OR; - Lidocaine pre-induction (blunt response); (4) Maintenance: - Propofol-based TIVA (lower ICP, smooth control); OR sevoflurane < 1 MAC + opioid; - Remifentanil infusion (titratable, smooth emergence); - Avoid N2O; (5) Hemodynamic goals: - MAP > 80, CPP > 60-70 (BTF guideline); - Norepinephrine first-line if hypotension; - Treat HTN cautiously (avoid worsening cerebral edema vs ICP) — labetalol if needed but maintain CPP; (6) Arterial line + CVL + Foley + temperature; (7) Brain relaxation: - Mannitol or hypertonic saline; - Mild hyperventilation; - CSF drainage if EVD placed; - Avoid PEEP > 10; (8) Surgical: - Burr hole, craniectomy; - Evacuation + hemostasis; (9) Post-op: - Neuro ICU; - Head up 30°; - Sedation + analgesia titrated; - Treat ICP (ICP monitor); - BP control; - Normothermia; - Glucose 140-180; - Seizure prophylaxis 7 days; - DVT prophylaxis (mechanical immediate, pharmacologic 24-48h based on stability); (10) Multidisciplinary: anesthesia + neurosurgery + ICU; (11) Family communication + goals of care

---

Acute SDH: maintain CPP > 60, mild HV only for herniation, hypertonic saline/mannitol, propofol TIVA, MAP > 80, head up 30°, ICP monitor postop, neuro ICU. Multidisciplinary. Goals of care.', NULL,
  'medium', 'trauma', 'review',
  'anesthesiology', 'clinical_decision', 'trauma', 'adult',
  'BTF TBI Guidelines; SNACC', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 50 ปี — emergent neurosurgical evacuation of subdural hematoma
GCS 8 deteriorating, pupils equal reactive, intubated by EMS
BP 175/95, HR 60'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 22 ปี ASA II — elective laparoscopic appendectomy
No PMH, no allergies, no medications, NPO 8h
Mallampati II, no airway concerns', '[{"label":"A","text":"Force opioid heavy"},{"label":"B","text":"Routine elective laparoscopic appendectomy anesthesia"},{"label":"C","text":"Skip multimodal"},{"label":"D","text":"No ventilation considerations"},{"label":"E","text":"Mandatory ICU"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Routine elective laparoscopic appendectomy anesthesia: (1) Pre-op: - Standard pre-op evaluation; - No need extensive testing (young healthy); - Informed consent including risks; - IV access; - Pre-procedural medication: maybe ondansetron + dexamethasone; - Antibiotic prophylaxis (cefazolin) 60 min pre-incision; (2) Intra-op: - GA with ETT (pneumoperitoneum); - Induction: propofol 2 mg/kg + fentanyl 2 mcg/kg + rocuronium 0.6 mg/kg; - Maintenance: sevoflurane 0.8-1 MAC + opioid; OR TIVA propofol + remifentanil; - Lung-protective ventilation: TV 6 mL/kg IBW, PEEP 5-8, plateau < 30, permissive hypercapnia; - Adjust ventilation for CO2 pneumoperitoneum (~ 20% increase EtCO2); - Multimodal analgesia: acetaminophen 1g IV + ketorolac 30 mg IV + local infiltration; - PONV prophylaxis: dexamethasone 4-8 mg + ondansetron 4-8 mg (Apfel score female + non-smoker + post-op opioid); (3) Position considerations: - Supine + Trendelenburg ± lateral tilt; - Padded arms (brachial plexus); - Eye protection; - Foley if expected > 2-3h; (4) Specific: - CO2 pneumoperitoneum effects (hemodynamic + respiratory); - Limit intra-abdominal pressure < 15 mmHg; - Watch for surgical complications (bleeding, organ injury); (5) Emergence + extubation: - Multimodal continued; - Reverse NMB (sugammadex or neostigmine + glyco); - TOF > 0.9 before extubation; - Awake extubation; (6) PACU: - Pain assessment + treatment (multimodal); - PONV management; - Aldrete score; - Voiding (if Foley) + ambulation; - Discharge criteria; (7) Discharge: - Same day typical; - Written + verbal instructions; - Follow-up; - Multimodal analgesia continuation; (8) Modern: ERAS-like principles for ambulatory; minimize opioid

---

Routine lap appy: GA + ETT, lung-protective ventilation, multimodal analgesia, PONV prophylaxis (dex + ondansetron), reverse NMB (sugammadex), Aldrete + discharge criteria. Pneumoperitoneum considerations.', NULL,
  'easy', 'gi', 'review',
  'anesthesiology', 'clinical_decision', 'gi', 'adult',
  'ASA Practice; ERAS Society', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 22 ปี ASA II — elective laparoscopic appendectomy
No PMH, no allergies, no medications, NPO 8h
Mallampati II, no airway concerns'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 45 ปี — surgical removal pheochromocytoma right adrenal
Pre-op alpha + beta blocked × 14 days
Verified Mg + electrolytes + hydration', '[{"label":"A","text":"Beta-blocker first"},{"label":"B","text":"Pheochromocytoma resection anesthesia"},{"label":"C","text":"Skip alpha-blockade"},{"label":"D","text":"No invasive monitoring"},{"label":"E","text":"Ketamine induction"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pheochromocytoma resection anesthesia: (1) Pre-op preparation (essential): - Alpha-blockade FIRST (phenoxybenzamine, doxazosin) × 10-14 days — reduces vasoconstriction; - Beta-blockade ONLY after alpha (otherwise unopposed alpha → severe HTN); - Hydration (alpha-blockade causes orthostatic, volume re-expansion); - Magnesium + electrolyte normalization; - Target BP < 130/80 + HR 60-80 + orthostatic decrease + minimal symptoms; - Imaging (CT/MRI), biochemical (metanephrines); (2) Anesthetic considerations: - Hypertensive crisis + arrhythmia at induction, intubation, surgical manipulation; - Hypotension after ligation of venous drainage (sudden catecholamine removal + remaining alpha-blockade); - Glucose lability; - Cardiomyopathy possible; (3) Anesthetic technique: - Smooth induction: propofol + opioid + lidocaine pre-treatment + rocuronium; - Avoid ketamine (sympathomimetic), succinylcholine (controversial — most use OK with NMB); - Avoid morphine (histamine release); - Avoid pancuronium (vagolytic); - Sevoflurane OK; (4) Drugs ready (have multiple syringes prepared): - Vasodilators: nitroprusside (gold standard, rapid), nitroglycerin, phentolamine, esmolol, magnesium; - Antiarrhythmic: lidocaine, esmolol, amiodarone; - Vasopressor: norepinephrine, phenylephrine for hypotension; - Sympatholytic: esmolol, labetalol; (5) Invasive monitoring: - Pre-induction arterial line; - CVL or large peripheral; - Consider PA catheter for cardiomyopathy; - Cardiac output monitor; (6) Surgical considerations: - Laparoscopic preferred; - Avoid manipulating tumor early (prepare for catecholamine surge); - Identify + clamp venous drainage early; (7) Post-op: - ICU; - Hemodynamic instability possible 24-48h; - Glucose monitoring (rebound hypoglycemia); - Steroid replacement if bilateral or contralateral atrophy; (8) Multidisciplinary: anesthesia + surgery + endocrinology + ICU

---

Pheochromocytoma: alpha-blockade FIRST (10-14d), then beta. Hydration. Vasodilator (nitroprusside) + vasopressor + esmolol ready. Pre-induction A-line + CVL. ICU post-op. Hypoglycemia rebound. Multidisciplinary.', NULL,
  'hard', 'endocrine_metabolic', 'review',
  'anesthesiology', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'Endocrine Society Pheochromocytoma; ASA Practice', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 45 ปี — surgical removal pheochromocytoma right adrenal
Pre-op alpha + beta blocked × 14 days
Verified Mg + electrolytes + hydration'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Basic science: physiology of central neuraxial anesthesia', '[{"label":"A","text":"Same as GA"},{"label":"B","text":"Neuraxial anesthesia physiology"},{"label":"C","text":"Always use lidocaine"},{"label":"D","text":"Avoid in all surgery"},{"label":"E","text":"Skip patient assessment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neuraxial anesthesia physiology: (1) Spinal anesthesia: - LA injected into subarachnoid space (CSF); - Direct effect on spinal nerve roots + spinal cord; - Rapid onset (5-10 min); - Dense block (motor + sensory + autonomic); - Smaller dose; - Single shot or catheter (rare); (2) Epidural anesthesia: - LA injected into epidural space (potential space, outside dura); - Indirect effect via diffusion across dura + nerve roots; - Slower onset (15-30 min); - Differential block (sensory > motor); - Larger volume; - Continuous catheter common; (3) CSE (combined spinal-epidural) — best of both; (4) Hemodynamic effects: - Sympathectomy → vasodilation → hypotension; - Level T1-T4 affects cardiac sympathetic (bradycardia + decreased contractility); - Higher block = more profound; - Pre-load with fluid + vasopressor; (5) Respiratory effects: - Below T8 — minimal; - Above T4 — accessory muscle paralysis (cough impaired); - Above C3-5 — phrenic palsy (apnea); - High spinal = respiratory failure; (6) Neurologic effects: - Sensory loss (block height); - Motor loss; - Visceral effects (bowel + bladder); (7) Block height factors: - Baricity LA (hyperbaric, isobaric, hypobaric); - Position; - Volume + dose; - Patient height + curvature; - Site of injection; - Direction needle; (8) Contraindications: - Patient refusal; - Coagulopathy (hematoma risk); - Infection at site; - Increased ICP; - Severe hypovolemia; - Severe aortic stenosis (relative); - Severe spinal abnormality; (9) Complications: - Hypotension (most common); - PDPH; - Total spinal; - Hematoma; - Abscess; - Nerve injury; - Transient neurologic symptoms (TNS — lidocaine); (10) Drug selection: - Bupivacaine, ropivacaine, levobupivacaine — long-acting; - Lidocaine — intermediate (TNS); - Chloroprocaine — short; (11) Adjuncts: - Epinephrine, fentanyl, morphine (long-acting analgesia), clonidine; (12) Modern: ultrasound guidance for difficult anatomy

---

Neuraxial: spinal (direct CSF, fast, dense) vs epidural (indirect, slow, differential). Sympathectomy + hypotension. High block respiratory. Block height factors. Contraindications + complications. Adjuncts. Modern US guidance.', NULL,
  'easy', 'procedures', 'review',
  'anesthesiology', 'basic_science', 'procedures', 'adult',
  'Miller''s; ASRA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Basic science: physiology of central neuraxial anesthesia'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 45 ปี — emergency open repair flail chest + bilateral pulmonary contusions + hemodynamic compromise
Intubated, BP 80/50, HR 130, SpO2 88% FiO2 1.0', '[{"label":"A","text":"Mass crystalloid"},{"label":"B","text":"Chest trauma + thoracic anesthesia"},{"label":"C","text":"No pain control"},{"label":"D","text":"N2O routine"},{"label":"E","text":"Skip multimodal"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Chest trauma + thoracic anesthesia: (1) Flail chest — paradoxical chest wall movement, severe pain, underlying pulmonary contusion; (2) Pulmonary contusion — most important pathology; ARDS-like; (3) Management priorities: - Airway (intubated); - Ventilation (lung-protective TV 6 mL/kg); - Pain control essential (thoracic epidural, ESP, intercostal blocks — facilitates breathing + reduces splinting); - Volume management (avoid overload — worsens contusion); - Treat associated injuries (pneumothorax, hemothorax with chest tubes); (4) Surgical fixation of flail (rib plating) — improving outcomes vs conservative; (5) Anesthetic considerations: - Difficult ventilation (one-lung ventilation may worsen + improve); - Hemodynamic instability — judicious fluids + early vasopressor; - Massive transfusion if hemorrhage; - Avoid N2O (pneumothorax expansion); - Ketamine acceptable; - Lung-protective + permissive hypercapnia; (6) Specific: - Tension pneumothorax — immediate chest decompression; - Massive hemothorax (> 1500 mL initially or > 200 mL/hr) → thoracotomy; - Cardiac contusion — ECG, troponin, echo; - Aortic injury — CT angiogram; (7) Post-op: - ICU; - Multimodal analgesia continuation; - Lung-protective ventilation; - Wean ventilator as tolerated; - DVT prophylaxis; - Aggressive pulmonary toilet; - Monitor for ARDS; (8) Multidisciplinary: trauma surgery + anesthesia + ICU + thoracic + cardiology + IR

---

Flail chest + pulmonary contusion: lung-protective ventilation, multimodal analgesia (epidural, ESP), judicious fluids, rib plating emerging, ICU management. Avoid N2O. Multidisciplinary trauma team.', NULL,
  'medium', 'trauma', 'review',
  'anesthesiology', 'clinical_decision', 'trauma', 'adult',
  'ATLS; EAST Chest Trauma', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 45 ปี — emergency open repair flail chest + bilateral pulmonary contusions + hemodynamic compromise
Intubated, BP 80/50, HR 130, SpO2 88% FiO2 1.0'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 28 ปี — emergent surgery for ectopic pregnancy ruptured
Hypotensive BP 75/40, HR 130, abdominal pain
IV × 2, type + cross pending, NPO unclear', '[{"label":"A","text":"Wait for stability"},{"label":"B","text":"Hypovolemic shock + emergency gynecologic surgery"},{"label":"C","text":"Crystalloid only"},{"label":"D","text":"Propofol bolus high dose"},{"label":"E","text":"Skip blood"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hypovolemic shock + emergency gynecologic surgery: (1) Resuscitation priorities: - 2 large-bore IV; - O- blood emergency or type-specific; - Crystalloid bolus initially while blood arrives; - MTP protocol activation if massive; (2) Anesthesia preparation: - Full stomach (emergency) — RSI; - Likely hemorrhagic shock — choose CV-stable induction (ketamine 1 mg/kg + opioid OR etomidate 0.3 mg/kg); avoid propofol bolus; rocuronium for RSI; - Pre-O2 thorough; - Arterial line; - Foley; (3) Intra-op: - Continue resuscitation — blood, FFP, platelets 1:1:1; TXA 1g; - Calcium replacement; - Warming; - Avoid acidosis + hypothermia + coagulopathy; - Vasopressor (norepinephrine) if persistent hypotension despite volume; - Surgeon control bleeding ASAP (clamp tube + ovary, hemostasis); (4) Maintain anesthesia: - Lower MAC volatile (hemodynamic); - Adequate amnesia (BIS if available); - Multimodal opioid-sparing post-op; (5) Post-op: - PACU or ICU based on stability; - Continued monitoring + transfusion; - Rh(D) immunoglobulin if Rh- mother + Rh+ products (or unknown fetus); - Emotional support (loss of pregnancy + emergency); - Follow-up + counseling fertility; (6) Multidisciplinary: OB-GYN + anesthesia + nursing + social work + blood bank; (7) Modern: methotrexate medical Mx for stable ectopic; surgical for ruptured/unstable; salpingostomy vs salpingectomy

---

Ruptured ectopic: RSI with ketamine/etomidate (CV stable), blood products 1:1:1, TXA, Ca, warming, norepi. Rh(D) immunoglobulin. Multidisciplinary including emotional support.', NULL,
  'medium', 'obgyn', 'review',
  'anesthesiology', 'clinical_decision', 'obgyn', 'adult',
  'SOAP; ATLS; ACOG', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 28 ปี — emergent surgery for ectopic pregnancy ruptured
Hypotensive BP 75/40, HR 130, abdominal pain
IV × 2, type + cross pending, NPO unclear'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยทารก 18 mo 10 kg — emergent surgery for foreign body aspiration in main bronchus
Mild dyspnea, occasional wheeze, SpO2 92% RA', '[{"label":"A","text":"Force ETT first"},{"label":"B","text":"Pediatric foreign body airway anesthesia"},{"label":"C","text":"Mass NMB"},{"label":"D","text":"Skip atropine"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric foreign body airway anesthesia: (1) Pre-op: - Stable child — proceed semi-urgent; - Unstable (severe distress, near-total obstruction) — immediate; - Avoid sedation/general anesthesia that may worsen obstruction; - NPO if possible; - Discussion with ENT/bronchoscopist for plan; - IV access + atropine pre-treatment (vagal bradycardia from airway stimulation); (2) Anesthetic approach (shared airway with bronchoscopist): - Inhalational induction with sevoflurane in O2 (maintain spontaneous ventilation initially — avoid converting partial to complete obstruction with paralysis); - Alternative: IV induction with propofol (with NMB if planning controlled ventilation); - Topical lidocaine to airway; - Equipment: rigid bronchoscope (ENT) + flexible bronchoscope + multiple ETT sizes + ECMO if catastrophic; (3) During bronchoscopy: - Spontaneous ventilation vs controlled (TIVA + NMB) — debated, depends on patient + foreign body + bronchoscopist preference; - 100% O2; - Adequate depth; - Hemodynamic support; (4) Specific risks: - Airway trauma; - Mucosal edema; - Foreign body migration; - Hypoxia; - Bronchospasm + laryngospasm; - Pneumothorax + bleeding; - Cardiac arrest; (5) Post-removal: - Assess airway; - Treat residual swelling (steroid, racemic epinephrine); - Observation 24h (may have delayed edema, infection); - Antibiotics if appropriate; (6) Common foreign bodies — peanuts, popcorn, hot dogs, small toys, batteries (button battery = caustic, urgent); (7) Outcomes generally good with prompt recognition; mortality < 1%; (8) Multidisciplinary: ENT + anesthesia + nursing + family; (9) Prevention education — chokable foods, supervised play, button battery storage

---

Pediatric foreign body: inhalational induction with maintained spontaneous ventilation (typically), shared airway with bronchoscopist, atropine pre-treatment, multiple equipment ready, post-removal observation. Button battery urgent.', NULL,
  'medium', 'respiratory', 'review',
  'anesthesiology', 'clinical_decision', 'respiratory', 'peds',
  'APAGBI; SPA; Cote', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยทารก 18 mo 10 kg — emergent surgery for foreign body aspiration in main bronchus
Mild dyspnea, occasional wheeze, SpO2 92% RA'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 70 ปี — elective colectomy ASA III with CAD + DM
Using IV PCA morphine post-op
Day 1 develops confusion + agitation + visual hallucinations
No focal neuro deficit + WBC normal', '[{"label":"A","text":"Sedate heavily"},{"label":"B","text":"Acute post-op delirium"},{"label":"C","text":"More opioid"},{"label":"D","text":"Restrain physically"},{"label":"E","text":"Ignore"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute post-op delirium — comprehensive workup + management: (1) DDx: - Medication-induced (opioid, benzodiazepine, anticholinergic, steroid); - Hypoxia; - Hypoglycemia; - Infection (UTI, pneumonia, wound, line); - Electrolyte derangement (Na, glucose, Ca, Mg); - Pain undertreated; - Withdrawal (alcohol, benzo, nicotine); - Urinary retention/constipation; - Sleep deprivation; - CNS event (stroke, hemorrhage, seizure); - PRES (Posterior Reversible Encephalopathy Syndrome) — HTN + immunosuppressant; - Sepsis; - Cardiogenic (low CO); (2) Diagnosis — CAM (Confusion Assessment Method): - Acute onset + fluctuating; - Inattention; - Disorganized thinking; - Altered consciousness; - Plus diagnosis when 1 + 2 + (3 or 4); (3) Workup: - Vital signs + glucose + SpO2; - Pain assessment; - Medication review (Beers); - Labs: BMP, Mg, glucose, CBC, UA; - ECG; - Consider CXR, CT head if focal/severe; (4) Management non-pharmacologic (primary): - Address underlying causes; - Re-orient (clock, calendar, family); - Hearing aids + glasses; - Sleep promotion (night light off, day activities); - Mobilize early; - Hydration; - Pain control multimodal (reduce opioid); - Remove tethers (lines, Foley, restraints); - Family presence; (5) Pharmacologic (sparingly + low-dose): - Low-dose haloperidol 0.25-0.5 mg or quetiapine 12.5-25 mg for severe agitation/safety; - AVOID benzodiazepines (worsen) — except withdrawal; - AVOID anticholinergics; - Dexmedetomidine has emerging role; (6) Risk reduction multimodal — multifactorial intervention (HELP — Hospital Elder Life Program) reduces incidence; (7) Long-term outcomes: increased mortality, functional decline, dementia risk, LOS; (8) Family education + support

---

Post-op delirium: comprehensive workup (causes — meds, hypoxia, infection, electrolytes, pain, withdrawal), CAM diagnosis, non-pharm primary (re-orient, sleep, mobility, family), low-dose antipsychotic sparingly, AVOID benzo + anticholinergic. HELP bundle prevention.', NULL,
  'easy', 'psych_behavior', 'review',
  'anesthesiology', 'clinical_decision', 'psych_behavior', 'adult',
  'AGS; ASA Brain Health Initiative', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 70 ปี — elective colectomy ASA III with CAD + DM
Using IV PCA morphine post-op
Day 1 develops confusion + agitation + visual hallucinations
No focal neuro deficit + WBC normal'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 30 ปี diabetic ESRD on HD — emergent AV fistula thrombectomy
Has labile glucose, K 6.0, recently dialyzed 6h ago
Use local + sedation vs regional vs GA', '[{"label":"A","text":"Cuff on fistula arm"},{"label":"B","text":"AV fistula salvage anesthesia"},{"label":"C","text":"Use succinylcholine"},{"label":"D","text":"Morphine PCA"},{"label":"E","text":"Heavy sedation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** AV fistula salvage anesthesia: (1) Anesthetic options: - Local infiltration + monitored anesthesia care (MAC) — for minor revisions; - Regional anesthesia (brachial plexus block) — preferred for major fistula work; - GA — reserved for complex/uncooperative; (2) Brachial plexus block options: - Supraclavicular — covers entire arm, good for fistula work; small pneumothorax risk; - Infraclavicular — also good coverage, less phrenic palsy than interscalene; - Axillary — only safer in ESRD with possible coagulopathy; - Ultrasound guidance preferred (reduces complications + improves success); (3) ESRD-specific considerations: - Recently dialyzed (6h) — better K + volume; check K before; - Heparin from HD — wait time before regional; ASRA timing; - Coagulopathy from uremia — DDAVP if bleeding; - Protect non-fistula arm (no BP, IV, art line); - Avoid succinylcholine if K elevated; - Avoid morphine; use fentanyl/hydromorphone; - Cisatracurium NMB if GA; (4) Sedation: - Avoid heavy sedation (already volume + electrolyte concerns); - Dexmedetomidine — sedation without respiratory depression; - Small midazolam + fentanyl; (5) Hemodynamic: - Maintain MAP — preserve fistula flow; - Cautious fluid (overload risk); - Vasopressor if needed; (6) Fistula salvage success time-sensitive (24-48h); coordinate with vascular + IR; (7) Post-op: - Monitor for bleeding, thrombosis; - Continue dialysis schedule; - Protect arm; - Multimodal analgesia; (8) Multidisciplinary: vascular surgery + IR + nephrology + anesthesia; (9) Modern: percutaneous thrombectomy emerging; AV graft considerations

---

AV fistula salvage: regional anesthesia (brachial plexus block, ultrasound-guided) preferred. ESRD considerations: K, coagulopathy, drug selection (cisatracurium, fentanyl/hydromorphone). Protect fistula arm. Maintain MAP. Multidisciplinary.', NULL,
  'medium', 'procedures', 'review',
  'anesthesiology', 'clinical_decision', 'procedures', 'adult',
  'ASRA Regional + ESRD; KDIGO', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 30 ปี diabetic ESRD on HD — emergent AV fistula thrombectomy
Has labile glucose, K 6.0, recently dialyzed 6h ago
Use local + sedation vs regional vs GA'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 55 ปี — major colorectal resection for cancer
Planned ERAS protocol
No prior surgery, normal labs, ASA II', '[{"label":"A","text":"NPO since midnight"},{"label":"B","text":"ERAS colorectal protocol"},{"label":"C","text":"Heavy opioid PCA"},{"label":"D","text":"Prolonged bedrest"},{"label":"E","text":"Delayed feeding"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** ERAS colorectal protocol — comprehensive: (1) Pre-op: - Patient education + expectations; - No mechanical bowel prep + no fasting > 2h (clear fluids); carb load 2h pre-op; - No long-acting premedication; - DVT + antibiotic prophylaxis; - Chlorhexidine skin prep; (2) Intra-op: - Multimodal opioid-sparing analgesia (acetaminophen + NSAID/COX-2 + gabapentinoid + ketamine + lidocaine infusion + dexamethasone); - Regional: epidural OR TAP/QL block OR ESP — debate epidural value in ERAS; TAP increasingly preferred; - Short-acting anesthetics (propofol + remifentanil OR low-dose volatile + opioid); - Goal-directed fluid therapy (esophageal Doppler, pulse contour) — moderate fluid; - Normothermia (active warming); - PONV prophylaxis multimodal (Apfel); - Minimize NG, drains, urinary catheter; - Lung-protective ventilation; - Avoid N2O; - Glucose control; - Local infiltration LA (laparoscopic ports + open wound); (3) Post-op: - Early oral intake (Day 0 or Day 1); - Early mobilization (Day 0); - Multimodal opioid-sparing analgesia continued; - Glucose control; - DVT prophylaxis; - Early Foley removal (Day 0-1); - NG/drains removed early; - Discharge criteria objective; - Follow-up; (4) Outcomes (multiple RCTs): - Reduced LOS (~30%); - Reduced complications (~50%); - Reduced opioid use; - Improved patient satisfaction; - Cost-effective; (5) Multidisciplinary: surgery + anesthesia + nursing + nutrition + PT + patient education; (6) Audit + continuous improvement; (7) Modern: ERAS Society protocols by procedure (colorectal, thoracic, gynecologic, orthopedic, bariatric, etc.); ERAS adapted to ambulatory; (8) Patient buy-in + family engagement; (9) Quality improvement framework — compliance with elements drives outcome

---

ERAS colorectal: shortened fasting + carb load, multimodal opioid-sparing + regional, goal-directed fluid, normothermia, early feeding + mobilization. Multidisciplinary. Reduces LOS + complications.', NULL,
  'easy', 'gi', 'review',
  'anesthesiology', 'clinical_decision', 'gi', 'adult',
  'ERAS Society Colorectal Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 55 ปี — major colorectal resection for cancer
Planned ERAS protocol
No prior surgery, normal labs, ASA II'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 60 ปี — atrial fibrillation rate 150 + acute pulmonary edema in PACU post-cholecystectomy
BP 90/60, SpO2 88% on 6L NC, anxious + dyspneic
Cardiac history HTN', '[{"label":"A","text":"Discharge to ward"},{"label":"B","text":"Acute new onset AFib + decompensated HF in PACU"},{"label":"C","text":"Aggressive crystalloid"},{"label":"D","text":"Sedate heavily"},{"label":"E","text":"Wait"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute new onset AFib + decompensated HF in PACU: (1) Initial — ABCs, supplemental O2, position upright, IV access, monitor; (2) Assessment: - Hemodynamically unstable (hypotension, ischemia, severe HF) — synchronized cardioversion immediate (200J biphasic); - Hemodynamically stable but symptomatic — rate control + diuretic + supportive; (3) Acute pulmonary edema: - O2 — NC → mask → HFNC → NIV (CPAP/BiPAP) → intubate; NIV often effective for cardiogenic edema; - Loop diuretic (furosemide 20-40 mg IV); - Nitroglycerin (sublingual or infusion) — preload + afterload reduction (caution hypotension); - Inotropes if cardiogenic shock; (4) AFib rate control: - Beta-blocker (esmolol IV — short, titratable; metoprolol); - Calcium channel blocker (diltiazem) if BB contraindicated; - Amiodarone (rate + rhythm); - Digoxin (slow); - AVOID rate-control if WPW (use cardioversion); (5) Rhythm control: - Synchronized cardioversion if unstable or anticipated quick conversion + low stroke risk; - Amiodarone IV; - Newer: ibutilide, vernakalant; (6) Anticoagulation: - CHA2DS2-VASc score; - If AFib > 48h or unknown: anticoagulate before cardioversion or TEE; - Post-cardioversion anticoagulation 4 weeks minimum (stunning); (7) Identify precipitants: - Hypoxia, hypercapnia, acidosis; - Electrolyte (K, Mg); - Pain, anxiety; - Volume status; - PE; - Sepsis; - Hyperthyroidism; - Anemia; - MI; (8) Differential — other causes pulmonary edema: ARDS, TRALI, neurogenic, negative-pressure; (9) Multidisciplinary: anesthesia + cardiology + ICU; (10) Disposition: step-down or ICU; continued workup + treatment

---

New AFib + acute pulmonary edema PACU: O2 + NIV, diuretic + nitroglycerin, rate control (esmolol, diltiazem, amio), cardioversion if unstable. CHA2DS2-VASc anticoagulation. Identify precipitants. Step-down/ICU.', NULL,
  'medium', 'cardiovascular', 'review',
  'anesthesiology', 'clinical_decision', 'cardiovascular', 'adult',
  'AHA/ACC AFib + HF', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 60 ปี — atrial fibrillation rate 150 + acute pulmonary edema in PACU post-cholecystectomy
BP 90/60, SpO2 88% on 6L NC, anxious + dyspneic
Cardiac history HTN'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 75 ปี — fall + hip fracture, ASA III
Alzheimer dementia + atrial fibrillation on apixaban + recent stroke 2 months ago
Last apixaban 18h ago
Urgent surgery < 48h per ortho guidelines', '[{"label":"A","text":"Cancel surgery"},{"label":"B","text":"Multi-comorbidity hip fracture anesthesia"},{"label":"C","text":"Wait 9 months for stroke"},{"label":"D","text":"Immediate neuraxial"},{"label":"E","text":"Skip blocks"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Multi-comorbidity hip fracture anesthesia — complex decision: (1) Hip fracture < 48h reduces mortality per multiple guidelines; (2) Stroke 2 months ago — high perioperative risk: - Recommendation defer elective surgery 9 months post-stroke; - Hip fracture urgent — proceed with risk acceptance; - Cardiology consult; - Maintain MAP > 80 to preserve cerebral perfusion; - Avoid hypotension + hyperglycemia; - Continue antiplatelet typically; (3) Apixaban management: - Half-life 12h normal renal; 18h since last dose; - Wait further or use reversal (andexanet alfa) for neuraxial; - Andexanet expensive; PCC 4-factor 50 U/kg empirical alternative; - Generally hold neuraxial if recent DOAC + bleeding concern; (4) Anesthetic choice: - Neuraxial (spinal) vs GA — both acceptable per recent RCT REGAIN (no significant difference for mortality, delirium); - Spinal may be preferred for: avoidance of GA in elderly (delirium concern — though REGAIN showed equivocal); - GA may be preferred for: anticoagulation status (avoid neuraxial hematoma), dementia patient cooperation, time pressure; - Decision individualized; (5) For THIS patient: - GA + multimodal opioid-sparing recommended given recent DOAC + dementia + stroke; - Regional adjunct: fascia iliaca + lateral femoral cutaneous nerve blocks for analgesia; (6) Anesthetic technique: - Etomidate or low-dose propofol; - Multimodal + regional adjunct (fascia iliaca block); - Avoid Beers Criteria meds (benzo, anticholinergic); - Use sugammadex for rapid reversal; (7) Delirium prevention: - HELP bundle; - Family presence; - Re-orientation; - Pain control + multimodal; (8) Post-op: - ICU/step-down monitoring; - Stroke awareness (neuro checks); - Restart antithrombotic when hemostasis OK; - DVT prophylaxis; - Mobilization; - PT/OT; - Discharge planning (likely SNF); (9) Goals of care discussion with family — dementia + multiple comorbidities — what does patient want? Function vs comfort?

---

Hip fracture + multiple comorbidities: surgery < 48h, individualize anesthesia (REGAIN — spinal/GA similar), recent DOAC + stroke considerations, fascia iliaca block, multimodal opioid-sparing, delirium prevention, goals of care discussion.', NULL,
  'hard', 'msk_nontrauma', 'review',
  'anesthesiology', 'clinical_decision', 'msk_nontrauma', 'adult',
  'ACS Geriatric Surgery; REGAIN Trial; ASRA Anticoag', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 75 ปี — fall + hip fracture, ASA III
Alzheimer dementia + atrial fibrillation on apixaban + recent stroke 2 months ago
Last apixaban 18h ago
Urgent surgery < 48h per ortho guidelines'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 35 ปี severe sleep apnea — elective tonsillectomy + uvulopalatopharyngoplasty (UPPP) + nasal surgery
BMI 36, AHI 50, on CPAP', '[{"label":"A","text":"Outpatient discharge"},{"label":"B","text":"Severe OSA + airway surgery"},{"label":"C","text":"Heavy opioid PCA"},{"label":"D","text":"Skip CPAP postop"},{"label":"E","text":"Single-shot blocks"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe OSA + airway surgery — high-risk anesthesia: (1) Pre-op: - Optimize CPAP compliance; - Difficult airway anticipated; - Multidisciplinary planning ENT + anesthesia + sleep medicine; (2) Airway considerations: - Predicted difficult: large neck, redundant tissue, friable post-op; - Awake fiberoptic intubation may be wise; - Video laryngoscopy first; - Multiple airway equipment + plans; (3) Anesthetic technique: - Avoid heavy sedation + long-acting opioids (respiratory depression OSA); - Multimodal opioid-sparing maximally: acetaminophen + NSAID + gabapentinoid (caution OSA — sedation), ketamine, dexmedetomidine; - Local infiltration; - Bilateral palatal block; - Topical anesthesia airway; (4) Intra-op: - Lung-protective + PEEP; - PONV prophylaxis (dexamethasone helps swelling + nausea + analgesia); - Limit IV fluid (edema); - Surgical-shared airway with ENT; (5) Extubation: - Awake extubation in lateral position; - Suction; - Equipment ready for re-intubation; - Watch for post-op bleeding (tonsillar + palatal); (6) Post-op: - PACU + CPAP back ASAP; - Continuous capnography + SpO2 monitoring step-down/ICU; - Multimodal analgesia opioid-sparing; - Position lateral or semi-upright; - Avoid sedatives; - Observation 24h+ (NOT outpatient for severe OSA major airway surgery); - Difficult airway alert + documentation; (7) Specific complications watch: - Post-op bleeding (primary 24h, secondary 5-10 days); - Airway edema; - NPPE; - Apnea + hypoxia; - PONV; - Pain (severe); (8) Long-term: continue CPAP + sleep medicine follow-up; (9) Multidisciplinary: ENT + anesthesia + sleep medicine + intensivist

---

Severe OSA + airway surgery: difficult airway prep, multimodal opioid-sparing maximally, AFOI/video laryngoscopy, awake extubation lateral, CPAP back ASAP, continuous monitoring 24h+, NOT outpatient, multidisciplinary.', NULL,
  'medium', 'respiratory', 'review',
  'anesthesiology', 'clinical_decision', 'respiratory', 'adult',
  'SAMBA OSA; AAOHNS Sleep Surgery', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 35 ปี severe sleep apnea — elective tonsillectomy + uvulopalatopharyngoplasty (UPPP) + nasal surgery
BMI 36, AHI 50, on CPAP'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 55 ปี — chronic pain referred to pain clinic, severe lumbar radicular pain × 1 year
MRI: large L5-S1 disc herniation
Failed conservative
Procedural: epidural steroid injection', '[{"label":"A","text":"No imaging guidance"},{"label":"B","text":"Interventional pain management"},{"label":"C","text":"Particulate steroid for transforaminal"},{"label":"D","text":"Skip consent"},{"label":"E","text":"No image guidance cervical"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Interventional pain management — epidural steroid injection (ESI): (1) Indications: - Radicular pain (radiculopathy) from disc herniation, spinal stenosis; - Failed conservative management (PT, NSAIDs, neuropathic agents); - Diagnostic + therapeutic; (2) Pre-procedure: - Imaging review (level + side); - Anticoagulation review (ASRA Interventional 2018): - High bleeding risk procedure for transforaminal; - Intermediate for interlaminar/caudal; - Hold per category + half-life; - Coagulation assessment if abnormal history; - Informed consent (risks: infection, bleeding, dural puncture, vascular injection, transient/permanent neuro deficit, no benefit); - IV access + monitoring; - Patient prone position; (3) Approaches: - Interlaminar (loss of resistance, fluoroscopy guidance); - Transforaminal (foramen, image guidance — fluoro or CT); more targeted but higher risk vascular injection + neuro complications; - Caudal (sacral hiatus); (4) Drugs: - Local anesthetic (lidocaine 1-2%) — diagnostic + analgesia; - Steroid: dexamethasone (non-particulate — recommended for transforaminal to reduce stroke/cord injury risk from particulate steroid embolism); particulate (triamcinolone, methylprednisolone) interlaminar/caudal acceptable; - Contrast (Omnipaque) to confirm spread + rule out vascular; (5) Image guidance MANDATORY for cervical + thoracic + transforaminal — multiple safety reports; (6) Complications: - Vascular injection (artery of Adamkiewicz, vertebral) → catastrophic; - Dural puncture → PDPH; - Infection (epidural abscess, meningitis); - Hematoma; - Nerve injury; - Transient steroid side effects (insomnia, glucose elevation, flushing); (7) Outcome — limited evidence; modest short-term benefit for radicular pain; (8) Multidisciplinary: pain medicine + spine surgery + PT; (9) Modern: regenerative medicine (PRP, stem cells) emerging but limited evidence

---

ESI: image guidance mandatory (fluoro/CT) for cervical/thoracic/transforaminal. Non-particulate steroid (dex) for transforaminal. ASRA anticoag timing. Risks: vascular injection (cord ischemia), dural puncture, infection, hematoma. Modest benefit.', NULL,
  'medium', 'neurology', 'review',
  'anesthesiology', 'clinical_decision', 'neurology', 'adult',
  'ASRA Interventional Pain', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 55 ปี — chronic pain referred to pain clinic, severe lumbar radicular pain × 1 year
MRI: large L5-S1 disc herniation
Failed conservative
Procedural: epidural steroid injection'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 45 ปี — chronic pain post-zoster (postherpetic neuralgia) ipsilateral T4-T6 × 6 months
Severe allodynia + burning + shooting pain
Failed gabapentinoid + TCA', '[{"label":"A","text":"Heavy opioid only"},{"label":"B","text":"Postherpetic neuralgia (PHN)"},{"label":"C","text":"Refuse care"},{"label":"D","text":"Surgery"},{"label":"E","text":"Single agent only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Postherpetic neuralgia (PHN) — chronic management: (1) Definition — pain > 3 months after zoster (shingles) rash resolution; (2) Risk factors: age > 50, severity acute zoster, ophthalmic, immunocompromise; (3) Mechanism — peripheral + central sensitization, nerve damage; (4) Treatment hierarchy: - First-line: - Gabapentin (300-3600 mg/day) or pregabalin (75-300 mg BID); - TCA (amitriptyline, nortriptyline) 10-100 mg HS; - 5% lidocaine patch (topical, localized); - Capsaicin 8% patch (single application 60 min, can repeat q3 months); - Second-line: - SNRI (duloxetine, venlafaxine); - Tramadol (weak opioid + SNRI); - Combination therapy; - Refractory: - Opioids — limited efficacy + addiction risk; consider carefully; - Methadone (NMDA + opioid); - Botulinum toxin injection; - Intrathecal medications; (5) Interventional options: - Intercostal nerve block — diagnostic + therapeutic; - Paravertebral block; - Erector spinae plane block (ESP) — emerging; - Pulsed radiofrequency; - Sympathetic block; - Spinal cord stimulation (refractory); - Dorsal root ganglion (DRG) stimulation; (6) Non-pharmacologic: - CBT; - Mindfulness; - PT for stiffness/disuse; - TENS; - Acupuncture (mixed evidence); (7) Prevention (most important): - Shingles vaccine (Shingrix) > 50 years — significantly reduces zoster + PHN; - Early antiviral (acyclovir, valacyclovir) within 72h acute zoster reduces PHN risk; - Pain control acute zoster (opioid, antiviral, possibly steroid); (8) Patient education: - Chronic condition; - Functional restoration focus; - Pacing; - Sleep; - Mood support; (9) Multidisciplinary pain clinic + multimodal

---

PHN: multimodal (gabapentinoid, TCA, lidocaine patch, capsaicin 8%, SNRI, tramadol, ESP/intercostal blocks, SCS/DRG). Prevention: Shingrix vaccine + early antiviral + acute pain control. Multidisciplinary + non-pharm.', NULL,
  'medium', 'neurology', 'review',
  'anesthesiology', 'clinical_decision', 'neurology', 'adult',
  'IASP NeuropathicPain; AAN PHN Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 45 ปี — chronic pain post-zoster (postherpetic neuralgia) ipsilateral T4-T6 × 6 months
Severe allodynia + burning + shooting pain
Failed gabapentinoid + TCA'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 35 ปี G2P1 GA 32 wk — admitted for severe HELLP syndrome — emergent C-section
Plt 35k, AST 350, ALT 380, Hb 9, INR 1.2, fibrinogen 200
BP 165/105 on labetalol', '[{"label":"A","text":"Spinal anesthesia"},{"label":"B","text":"HELLP syndrome"},{"label":"C","text":"Skip BP control"},{"label":"D","text":"No transfusion ready"},{"label":"E","text":"Routine technique"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** HELLP syndrome — emergent C-section anesthesia: (1) HELLP — Hemolysis, Elevated Liver enzymes, Low Platelets; subset severe PEC; high mortality; (2) BP control: - Labetalol 20 mg IV bolus q10 min; - Hydralazine 5-10 mg IV q20; - Nicardipine infusion; - Target SBP 140-160, DBP 90-110; (3) Seizure prophylaxis — magnesium 4-6g loading + 1-2g/hr (continue 24h post-delivery); (4) Anesthesia choice (challenging): - Platelets 35k = BELOW threshold for neuraxial (typically need > 70-80k, some advocate higher); - Spinal hematoma risk too high; - GA required typically; (5) GA technique: - Aspiration prophylaxis (PPI, antacid); - Rapid Sequence Induction (RSI) with cricoid; - Anticipated difficult airway (edema); - Pre-O2 thorough; - Video laryngoscopy first; - Blunt response: opioid (remifentanil 1 mcg/kg or fentanyl 2-4 mcg/kg); lidocaine 1.5 mg/kg; magnesium adjunct; consider esmolol; - Induction: propofol 1.5-2 mg/kg + rocuronium 1.2 mg/kg; - Maintain anesthesia: sevoflurane 1 MAC + opioid + magnesium (potentiates NMB, careful); (6) Hemorrhage risk + transfusion: - Coagulopathy possible; - Platelet transfusion if active bleeding or pre-procedure (controversial threshold); - FFP if INR > 1.5; - Cryoprecipitate if fibrinogen < 1.5; - Cell saver acceptable OB; - TXA 1g; (7) Hemodynamic management: - Cautious fluid (pulmonary edema risk); - Vasopressor (norepinephrine, phenylephrine carefully — already HTN); (8) Neonatal preparation: - Term but premature; - NICU team ready; - Magnesium effects on neonate (respiratory depression); (9) Post-op care: - ICU; - Continue magnesium 24h; - BP control; - Monitor for pulmonary edema, AKI, abruption, DIC, hepatic infarction/rupture; - Platelet count + LFT trending; - Hepatic rupture (rare, devastating) — abdominal pain, shock; (10) Multidisciplinary: OB + anesthesia + neonatology + ICU + hematology + critical care + family

---

HELLP + emergent C-section: GA with RSI (plt too low for neuraxial), difficult airway prep, blunt response to laryngoscopy, magnesium continuation, careful fluid + vasopressor, transfusion ready, ICU + monitor for hepatic rupture. Multidisciplinary.', NULL,
  'hard', 'obgyn', 'review',
  'anesthesiology', 'clinical_decision', 'obgyn', 'adult',
  'SOAP HELLP; ACOG', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 35 ปี G2P1 GA 32 wk — admitted for severe HELLP syndrome — emergent C-section
Plt 35k, AST 350, ALT 380, Hb 9, INR 1.2, fibrinogen 200
BP 165/105 on labetalol'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 40 ปี ASA III — sleep study confirms positional OSA + obesity
Needs elective bariatric surgery laparoscopic sleeve gastrectomy
BMI 45, neck circ 47 cm', '[{"label":"A","text":"NSAID PCA"},{"label":"B","text":"Bariatric anesthesia (sleeve gastrectomy)"},{"label":"C","text":"Heavy benzo premed"},{"label":"D","text":"Total body weight all drugs"},{"label":"E","text":"Outpatient discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bariatric anesthesia (sleeve gastrectomy): (1) Pre-op optimization: - CPAP for OSA — adherent 1-3 months pre-op; - Weight loss preoperative (some surgeons require); - Glucose control DM; - Smoking cessation; - Cardiac + pulmonary clearance; - Sleep study screening (STOP-BANG); - Pre-op clinic comprehensive evaluation; (2) Airway: - Difficult airway anticipated; - Pre-O2 thorough (rapid desaturation); - Ramped position (HELP); - Apneic oxygenation (high-flow NC during apnea); - Video laryngoscopy first-pass; - Multiple equipment + difficult airway plan; - Awake fiberoptic intubation for predicted very difficult; (3) Drug dosing: - Lean body weight for: induction (propofol, sux), NMB; - Total body weight for: succinylcholine, antibiotics; - Adjusted body weight for: maintenance, opioid; - Sugammadex weight-based; (4) Intra-op: - Lung-protective + PEEP 8-12; - Recruitment maneuvers; - Multimodal opioid-sparing (TAP/QL block, acetaminophen, ketamine, dexmedetomidine, dexamethasone); - AVOID NSAID after bariatric (ulcer + perforation risk); - PONV prophylaxis multimodal (Apfel + bariatric); - Glucose control; - DVT prophylaxis (mechanical + LMWH adjusted weight); (5) Position considerations: - Reverse Trendelenburg + steep; - Pad bony prominences; - Foot board; - Compartment syndrome risk lower extremity; (6) Pneumoperitoneum effects (covered separately) — limit pressure < 15 mmHg; (7) Surgical sleeve gastrectomy specific: - Bougie size; - Staple line check; - Leak test; - Drain selective; (8) Extubation: - Fully awake; - HOB up 30°; - Lateral position; - CPAP back ASAP; (9) Post-op: - Step-down or PACU monitoring; - Continuous SpO2 + capnography; - Multimodal pain (opioid-sparing maximally); - Early mobilization; - DVT prophylaxis; - Glucose control; - Aspiration precautions; - Nutrition (bariatric supplementation lifelong); (10) Multidisciplinary: bariatric surgery + anesthesia + nursing + nutrition + psychology + endocrinology; (11) ERAS bariatric protocol

---

Bariatric anesthesia: difficult airway prep, ramped position + HELP, drug dosing by weight class (LBW, ABW, TBW), multimodal + TAP block, AVOID NSAID, CPAP back ASAP, ERAS bariatric. Multidisciplinary lifelong care.', NULL,
  'medium', 'gi', 'review',
  'anesthesiology', 'clinical_decision', 'gi', 'adult',
  'SOBA Bariatric; ERAS Society', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 40 ปี ASA III — sleep study confirms positional OSA + obesity
Needs elective bariatric surgery laparoscopic sleeve gastrectomy
BMI 45, neck circ 47 cm'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 80 ปี — emergent abdominal surgery for ischemic bowel
Sepsis, lactate 6, BP 80/50 on norepi, K 5.5, AKI Cr 2.8
Intubated in ED', '[{"label":"A","text":"Propofol high dose"},{"label":"B","text":"Septic shock + emergent abdominal surgery"},{"label":"C","text":"Skip vasopressor"},{"label":"D","text":"Hypotonic fluid"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Septic shock + emergent abdominal surgery: (1) Source control — emergent surgery for ischemic bowel; (2) Pre-op (in ED already): - Antibiotics (broad-spectrum within 1h); - Fluid resuscitation initiated; - Norepinephrine started; - Lactate measured; - Cultures; (3) Anesthesia for emergent septic patient: - Pre-induction art line; CVL useful; - Continue vasopressor; - Induction agent — CV-stable: etomidate 0.3 mg/kg (single dose acceptable despite adrenal suppression theoretical concern in sepsis — controversial; consider stress steroid coverage); OR ketamine 0.5-1 mg/kg (preserves CV); - Reduced doses; - Rocuronium 1.2 mg/kg; - Avoid propofol bolus; (4) Maintenance: - Low-dose volatile + opioid (fentanyl, hydromorphone); - Minimize vasodilator effects; - Avoid prolonged opioid hangover (kidney + liver dysfunction); - Cisatracurium for NMB (organ-independent metabolism); (5) Resuscitation continued: - Goal-directed: MAP > 65, lactate clearance, urine output, ScvO2; - Balanced crystalloid; - Avoid colloid (HES contraindicated AKI); - Vasopressin + epinephrine if refractory; - Steroid (hydrocortisone 200 mg/d) for vasopressor-refractory; - Blood products as needed (Hb > 7 generally); (6) Renal protection: - Avoid nephrotoxins; - Maintain perfusion; - Monitor UO; - Consider CRRT post-op if AKI persists; (7) Glucose 140-180; (8) Ventilator: - Lung-protective TV 6 mL/kg IBW; - PEEP appropriate; - Avoid V/Q worsening; (9) Post-op: - ICU; - Continue resuscitation + source control if not achieved; - Open abdomen if damage control (ACS, packing); - Multidisciplinary; (10) Goals of care + family communication — elderly + emergent + sepsis = high mortality risk; ethical discussion important; (11) Modern: ABCDEF bundle ICU; sepsis bundle compliance correlates with outcome

---

Septic shock + emergent surgery: etomidate/ketamine induction (CV stable), continue vasopressor + fluid, source control surgery, ICU post-op, goals of care + family discussion. Cisatracurium. Multidisciplinary. ABCDEF bundle.', NULL,
  'hard', 'gi', 'review',
  'anesthesiology', 'clinical_decision', 'gi', 'adult',
  'Surviving Sepsis 2021; ACS Surgical Sepsis', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 80 ปี — emergent abdominal surgery for ischemic bowel
Sepsis, lactate 6, BP 80/50 on norepi, K 5.5, AKI Cr 2.8
Intubated in ED'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย 55 ปี — diagnostic colonoscopy + polypectomy under MAC sedation
BMI 32, OSA STOP-BANG 5, controlled HTN
Using propofol + fentanyl by anesthesiologist', '[{"label":"A","text":"Skip capnography"},{"label":"B","text":"GI endoscopy anesthesia (NORA)"},{"label":"C","text":"Heavy fentanyl"},{"label":"D","text":"Long-acting benzo"},{"label":"E","text":"Adult standard NPO ignored"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** GI endoscopy anesthesia (NORA): (1) Pre-procedure: - History + physical, allergies, comorbidities; - NPO standard; - IV access; - Monitoring (BP, ECG, SpO2, capnography mandatory); - Communication with endoscopist + plan; (2) Anesthesia options: - Conscious sedation (endoscopist-administered, often midazolam + fentanyl); - Monitored Anesthesia Care (MAC) by anesthesiologist — propofol-based; - General anesthesia with ETT for select cases (advanced procedures, aspiration risk); (3) Propofol MAC: - Bolus 0.5-1 mg/kg + titrated infusion 50-150 mcg/kg/min; - Fentanyl 25-50 mcg adjunct; - Maintains airway often; - Smooth + rapid recovery; - Respiratory depression risk (especially OSA, obesity, elderly, with opioids); (4) OSA considerations: - Increased risk obstruction + apnea; - Lateral position helps; - Capnography essential; - Consider lower target depth; - Have airway equipment ready; - Bigger role for endoscopist suction; (5) Specific procedures: - Colonoscopy — supine to lateral; bowel preparation may cause dehydration; - EGD — shared airway, bite block; - ERCP — prone or lateral; longer; - EUS — similar to EGD/ERCP; - Bronchoscopy — shared airway; topical lidocaine; high O2 needs; (6) Risks: - Aspiration (especially upper GI, ileus); - Airway obstruction (OSA); - Hemodynamic instability; - Bleeding (polypectomy); - Perforation; (7) Recovery: - PACU standard discharge criteria; - Cannot drive same day; - Escort home; - Diet advancement gradual; (8) Anticoagulant management — coordinate with proceduralist; (9) Modern: increasing complex GI procedures (ESD, POEM, advanced ERCP) — anesthesia involvement increasing; (10) Multidisciplinary: GI + anesthesia + nursing

---

GI endoscopy MAC: propofol-based + low-dose fentanyl, capnography mandatory, OSA considerations (lateral, lower depth, equipment ready), specific procedure considerations (EGD shared airway, ERCP prone). Aspiration risk.', NULL,
  'easy', 'gi', 'review',
  'anesthesiology', 'clinical_decision', 'gi', 'adult',
  'ASA NORA; ASGE Sedation', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วย 55 ปี — diagnostic colonoscopy + polypectomy under MAC sedation
BMI 32, OSA STOP-BANG 5, controlled HTN
Using propofol + fentanyl by anesthesiologist'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Basic science: blood pressure monitoring techniques + invasive vs noninvasive', '[{"label":"A","text":"Skip BP monitoring"},{"label":"B","text":"Blood pressure monitoring"},{"label":"C","text":"Single technique always"},{"label":"D","text":"Wrong cuff size OK"},{"label":"E","text":"No arterial line ever"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Blood pressure monitoring — physics + methods: (1) Indirect (non-invasive): - Manual sphygmomanometer (auscultation Korotkoff sounds — gold standard intermittent); - Oscillometric (automated, most common); detects oscillations, calculates MAP from peak amplitude, derives SBP + DBP from algorithm; - Limitations: errors at extreme pressures, arrhythmia, motion, cuff size; - Cuff size — bladder 80% arm circumference (too small = falsely high; too large = falsely low); - Wrong cuff size most common error; (2) Direct (invasive arterial line): - Continuous beat-to-beat; - Accurate at extreme pressures; - Allows ABG sampling; - Risk: bleeding, thrombosis, infection, ischemia (Allen test); - Common sites: radial > femoral > brachial > axillary > dorsalis pedis; - Wave form analysis: dicrotic notch, slope, pulse pressure variation (fluid responsiveness); - Damped (occlusion, air, fibrosis); - Resonant (under-damped — over-shoot); (3) Indications arterial line: - Hemodynamic instability; - Major surgery (cardiac, vascular, neuro); - Frequent ABG; - Vasoactive infusion titration; - Inaccurate noninvasive (extreme BMI, edema); (4) Newer non-invasive continuous: - ClearSight, Nexfin (finger cuff); - LiDCO; - FloTrac; - Comparable in many cases but not all; (5) Central venous pressure: - Limited utility static fluid responsiveness; - Useful for vasoactive infusion access, fluid administration, vasopressor monitoring; (6) Pulmonary artery catheter (Swan-Ganz): - Decreasing use; - Useful in selected complex cases (right HF, PAH, complex cardiac); - Complications: arrhythmia, infection, pulmonary infarct/rupture; (7) Cardiac output monitoring: - Thermodilution (PA cath gold standard); - Esophageal Doppler; - Pulse contour (FloTrac); - Bioreactance; - Lithium dilution; (8) Selection — least invasive that meets goal

---

BP monitoring: manual + oscillometric NIBP (cuff size critical), arterial line for instability/major surgery/vasoactive (radial > others, Allen test). CVP limited fluid utility. PA cath declining. Newer NIBP continuous. Least invasive that meets goal.', NULL,
  'easy', 'cardiovascular', 'review',
  'anesthesiology', 'basic_science', 'cardiovascular', 'adult',
  'ASA Standards; Miller''s', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Basic science: blood pressure monitoring techniques + invasive vs noninvasive'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Management question: clinical pathway for emergency anesthesia department coverage', '[{"label":"A","text":"Single provider 24/7"},{"label":"B","text":"Emergency anesthesia coverage + staffing"},{"label":"C","text":"No staffing plan"},{"label":"D","text":"Skip after-hours quality"},{"label":"E","text":"Refuse emergency"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Emergency anesthesia coverage + staffing: (1) Coverage models: - 24/7 in-house; - On-call from home; - Combination; - Trainee coverage with attending availability; (2) Staffing decisions based on: - Case volume + acuity; - Geographic factors (distance to hospital); - Reimbursement; - Quality + safety standards; - Resident education; - Workforce sustainability; (3) Emergency case categories (NCEPOD): - Immediate (life/limb/organ saving — within minutes); - Urgent (life/limb/organ saving — within hours); - Expedited (early treatment — within days); - Elective (planned); (4) Acuity-based triage + prioritization: - Communication surgeon + anesthesia + OR; - Multiple emergencies simultaneously — triage; - Document; (5) After-hours considerations: - Reduced staffing; - Fatigue + safety; - Communication challenges; - Resource limitations; (6) Quality + safety after hours: - Standards same as daytime; - Surgical timing for elective; - Trauma + emergency only after hours where possible; - Fatigue mitigation; (7) Wellness + sustainability: - Duty hour limits; - Hand-off + sleep protection; - Mental health resources; - Substance use awareness; (8) Multidisciplinary: anesthesia + surgery + OR nursing + administration; (9) Pediatric + cardiac + neurosurgery sub-specialty coverage; (10) Communication: - Clear escalation pathways; - Centralized call schedule; - Backup coverage; (11) Quality improvement: - Adverse event after hours; - Audit + feedback; - Continuous improvement; (12) Modern: telemedicine coverage, AI scheduling, work-life balance focus, COVID-19 + recovery impact, recruitment challenges

---

Emergency coverage: 24/7 in-house vs on-call models, acuity-based triage (NCEPOD), after-hours standards same, fatigue mitigation, multidisciplinary communication, quality improvement, sub-specialty considerations, modern: telemedicine + AI scheduling.', NULL,
  'easy', 'procedures', 'review',
  'anesthesiology', 'ems_mgmt', 'procedures', 'adult',
  'ASA Practice Management; AAGBI', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Management question: clinical pathway for emergency anesthesia department coverage'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Integrative: socioeconomic determinants of anesthesia outcomes + health equity', '[{"label":"A","text":"Ignore disparities"},{"label":"B","text":"Health equity + anesthesia outcomes"},{"label":"C","text":"Single approach all"},{"label":"D","text":"Treat all same regardless"},{"label":"E","text":"Skip community"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Health equity + anesthesia outcomes: (1) Social Determinants of Health (SDOH) — non-medical factors affecting health: - Economic stability; - Education; - Healthcare access; - Neighborhood + environment; - Social + community context; (2) Anesthesia outcome disparities: - Pain treatment (multiple studies showing minorities undertreated for pain); - Surgical mortality higher in lower socioeconomic; - Maternal mortality (Black women 3-4× higher); - Access to specialty care + transplant; - Insurance + reimbursement disparities; (3) Bias in healthcare: - Implicit bias (automatic stereotyping); - Structural racism in policy + practice; - Provider biases affecting decisions; - System designed for some not others; - Awareness + reflection + training; (4) Addressing disparities: - Education + training; - Workforce diversity; - Patient-centered care; - Community engagement; - Policy advocacy; - Quality improvement targeting equity; - Data stratification by demographics; (5) Specific anesthesia-relevant interventions: - Multilingual care; - Cultural humility training; - Outreach in underserved; - Pain management equity; - Pre-op clinic for high-risk; - ERAS for all (reducing disparities); - Mobile health technology; - Telemedicine; (6) Maternal mortality: - Black maternal mortality crisis; - Multi-faceted (pre-existing, access, bias, treatment); - California Maternal Quality Collaborative model; (7) Pediatric — child poverty effects; (8) LGBTQ+ health (covered); (9) Global health (covered); (10) Disability — accommodations + accessibility; (11) Modern: anti-racism in medicine, structural competency, advocacy, ASA + APSF + AAMC initiatives; (12) Resources: - SDOH screening; - Community health workers; - Social work referrals; - Patient advocacy

---

Health equity: SDOH affect anesthesia outcomes (pain undertreatment minorities, maternal mortality, surgical outcomes). Implicit bias + structural racism awareness. Interventions: education, diversity, patient-centered, advocacy, ERAS, data stratification. Modern: anti-racism + structural competency.', NULL,
  'easy', 'psych_behavior', 'review',
  'anesthesiology', 'integrative', 'psych_behavior', 'adult',
  'AHRQ; AAMC; ASA DEI', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Integrative: socioeconomic determinants of anesthesia outcomes + health equity'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Integrative: future of anesthesia — AI, machine learning, automation', '[{"label":"A","text":"Resist all AI"},{"label":"B","text":"Future of anesthesia"},{"label":"C","text":"Replace all clinicians"},{"label":"D","text":"Skip ethics"},{"label":"E","text":"Single use only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Future of anesthesia — AI/ML: (1) Current AI applications: - Hypotension Prediction Index (HPI) — predicts hypotension before occurrence; FDA-approved; - Difficult airway prediction; - Drug dosing optimization; - PONV risk stratification; - Mortality + complication prediction; - Closed-loop drug delivery (target-controlled infusion, BIS-guided sedation, fluid management); - Image analysis (ultrasound for regional anesthesia, echo); - Natural language processing (chart review, documentation); (2) Machine learning approaches: - Supervised (predict outcomes); - Unsupervised (clustering, phenotypes); - Deep learning (neural networks, image, complex pattern); - Reinforcement learning (sequential decision-making); (3) Big data sources: - EHR (NACOR registry); - Wearables + continuous monitoring; - Genomics; - Imaging; - Patient-reported outcomes; (4) Considerations + challenges: - Data quality + standardization; - Algorithmic bias (training data); - Interpretability (black box); - Generalizability across populations; - Validation in diverse cohorts; - Regulatory (FDA SaMD framework); - Liability + accountability; - Privacy + security; - Implementation + workflow integration; - Provider acceptance + training; - Equity concerns (digital divide, bias); (5) Closed-loop systems: - Anesthesia delivery; - Fluid resuscitation; - Glucose control; - Ventilation; - Sedation; - Need to balance autonomy + safety; (6) Telemedicine + remote: - Pre-op evaluation; - Tele-ICU; - Mentorship; - Disaster + global; (7) Wearable + continuous: - Home monitoring post-discharge; - Early detection complications; (8) Ethical considerations: - Bias propagation; - Job displacement (mostly augmentation not replacement); - Patient autonomy + consent; - Equity + access; (9) Education + training: - AI literacy for anesthesiologists; - Lifelong learning; - Hybrid expertise (clinical + computational); (10) Anesthesiologist role evolving: - Decision support partner; - Quality + safety oversight; - Higher-level + complex case focus; - Education + research; - Leadership + advocacy; (11) Modern: rapidly evolving field, opportunity for anesthesiology leadership

---

Future anesthesia: AI/ML (HPI, prediction, closed-loop, imaging). Considerations: bias, interpretability, regulation, equity. Wearables + telemedicine. Ethical + equity considerations. Anesthesiologist role evolves (augmentation + leadership). Rapidly evolving field.', NULL,
  'easy', 'procedures', 'review',
  'anesthesiology', 'integrative', 'procedures', 'adult',
  'ASA Innovations; APSF Tech', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Integrative: future of anesthesia — AI, machine learning, automation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Integrative: educational + lifelong learning in anesthesia', '[{"label":"A","text":"Skip CME"},{"label":"B","text":"Anesthesia education + lifelong learning"},{"label":"C","text":"Single training only"},{"label":"D","text":"Avoid simulation"},{"label":"E","text":"No mentorship"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Anesthesia education + lifelong learning: (1) Education hierarchy: - Medical school; - Residency (4 years anesthesia in US after intern); - Fellowship (cardiac, pediatric, OB, regional, pain, critical care, NORA); - Continuous practice + learning; (2) ACGME competencies: - Patient care; - Medical knowledge; - Practice-based learning + improvement; - Interpersonal + communication; - Professionalism; - Systems-based practice; (3) Maintenance of Certification in Anesthesiology (MOCA): - 10-year cycle; - Continuous learning (MOCA Minute); - Periodic assessment; - Quality improvement; - Professional standing; - 4 components by ABA; (4) Continuing Medical Education (CME): - Required for licensure + boards; - Categories: lecture, simulation, journal, online, self-directed; - ACCME accreditation; (5) Adult learning theory: - Self-directed; - Experience-based; - Relevant + applicable; - Problem-centered; (6) Effective methods: - Active learning > passive; - Simulation (high-fidelity, standardized patient); - Procedural skills practice; - Debriefing; - Peer learning; - Mentorship; - Feedback (formative + summative); (7) Resident education: - Graduated responsibility; - Case mix variety; - Sub-specialty exposure; - Wellness + work-life balance; - Inter-professional training; - QI + research; (8) Faculty development: - Teaching skills; - Educational scholarship; - Mentoring; - Curriculum design; (9) Educational research: - Evidence-based education; - Implementation; - Assessment validity; (10) Professional engagement: - Specialty societies (ASA, AAGBI, ESA); - Conferences; - Journals; - Online communities; (11) Mentorship: - Formal + informal; - Sponsorship; - Career navigation; - Bidirectional; (12) Modern: digital education, podcasts, MOOCs, social media, simulation centers, telementoring, lifelong learning culture; (13) Wellness integrated with education — sustainable career

---

Anesthesia education: medical school → residency → fellowship → MOCA. ACGME competencies. Adult learning theory. Simulation + active learning. Mentorship. CME. Professional engagement. Modern: digital + lifelong learning culture integrated with wellness.', NULL,
  'easy', 'procedures', 'review',
  'anesthesiology', 'integrative', 'procedures', 'adult',
  'ABA MOCA; ACGME', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Integrative: educational + lifelong learning in anesthesia'
  );

commit;

