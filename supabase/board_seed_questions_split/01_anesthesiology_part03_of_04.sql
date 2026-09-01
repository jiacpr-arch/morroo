-- ===============================================================
-- หมอรู้ — Board seed: วิสัญญีวิทยา (anesthesiology) — part 3/4 (50 MCQs)
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
  s.id, 'board', NULL, 'Basic science: cardiac physiology + anesthesia
Patient with diastolic dysfunction HFpEF', '[{"label":"A","text":"Manage same as systolic HF"},{"label":"B","text":"HFpEF (preserved EF) physiology"},{"label":"C","text":"Aggressive fluid loading"},{"label":"D","text":"Allow tachycardia"},{"label":"E","text":"Skip rhythm management"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** HFpEF (preserved EF) physiology: (1) Pathophys — impaired ventricular relaxation + increased filling pressures; LVEF normal but diastolic dysfunction; common in elderly, HTN, AFib, obesity, diabetes; (2) Echo features — E/A reversal, increased E/e'', LA enlargement, diastolic dysfunction grades; (3) Hemodynamic vulnerability: - Sensitive to volume changes — easily overloaded; - Sensitive to AFib (loss of atrial kick — 30% CO loss); - Sensitive to tachycardia (decreased diastolic filling time); (4) Anesthesia goals: - Maintain sinus rhythm — aggressive treat AFib (cardioversion if hemodynamically compromised, rate control); - Avoid tachycardia (target HR 60-80); - Maintain preload BUT avoid overload (Goldilocks zone narrow); - Maintain afterload (avoid sudden drops); - Avoid myocardial depressants; (5) Monitoring — TEE useful; CVP/PA catheter limited utility (LV filling pressure not reflected); (6) Drug choices: - Etomidate induction (CV stable); - Slow titrated propofol/opioid; - Phenylephrine for hypotension (alpha-1, maintains afterload); - Avoid ketamine (HR + SVR); - Avoid volatile high dose (vasodilator + myocardial depressant); (7) Fluid — judicious, frequent assessment; (8) Postop AFib common — rate + rhythm control; (9) Beta-blocker, ACE-I, MRA, SGLT2i in chronic management; loop diuretic; (10) Recent SGLT2i (empagliflozin, dapagliflozin) shown HFpEF benefit (EMPEROR-Preserved, DELIVER); (11) Hold ACE-I/ARB day of surgery; continue beta-blocker; (12) Modern: tailored hemodynamic management, multidisciplinary

---

HFpEF: maintain SR, avoid tachy + volume overload, narrow Goldilocks zone, phenylephrine for hypotension, avoid ketamine, TEE useful, multimodal. SGLT2i emerging treatment.', NULL,
  'medium', 'cardiovascular', 'review',
  'anesthesiology', 'basic_science', 'cardiovascular', 'adult',
  'AHA/ACC HF Guidelines; SCA Anesthesia', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Basic science: cardiac physiology + anesthesia
Patient with diastolic dysfunction HFpEF'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Basic science: pulmonary physiology + ventilation
Question on ventilation/perfusion + hypoxic pulmonary vasoconstriction', '[{"label":"A","text":"V/Q irrelevant"},{"label":"B","text":"Pulmonary physiology + anesthesia"},{"label":"C","text":"Use 100% O2 always"},{"label":"D","text":"TV 15 mL/kg routine"},{"label":"E","text":"No PEEP"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pulmonary physiology + anesthesia: (1) V/Q matching: - West''s lung zones: Zone 1 (PA > Pa > Pv) — dead space; Zone 2 (Pa > PA > Pv) — variable; Zone 3 (Pa > Pv > PA) — best perfusion; - Normal V/Q ratio 0.8; - Mismatch causes hypoxemia (shunt) or hypercapnia (dead space); (2) Anesthesia effects: - GA reduces FRC (20% supine + intubated); - Atelectasis common (avoid 100% O2, recruitment maneuvers, PEEP); - Shunt increased — supine, intubated, paralyzed; - Decreased response to hypoxia + hypercapnia; (3) Hypoxic Pulmonary Vasoconstriction (HPV): - Reflex vasoconstriction in hypoxic alveoli to redirect blood to ventilated lung; - Improves V/Q matching; - INHIBITED by: volatile anesthetics (dose-dependent), pulmonary vasodilators (NO, nitroglycerin, dobutamine, prostacyclin), alkalosis; - PRESERVED by: TIVA propofol; (4) Critical in one-lung ventilation — HPV helps blood shunt to ventilated lung; (5) Lung-protective ventilation: - TV 6 mL/kg IBW (predicted BW from height); - Plateau < 30; - Driving pressure < 15; - PEEP 5-10 (titrate); - Permissive hypercapnia OK; (6) Recruitment maneuvers — controversial harm in some (ART trial); (7) Specific conditions: - COPD — air trapping, prolong expiration, avoid auto-PEEP; - Asthma — bronchospasm, deepen anesthesia + bronchodilator; - ARDS — TV 4-6 mL/kg, prone, PEEP titration; - Obesity — ramped position, PEEP, recruitment; - Restrictive — careful PIP; (8) Closing capacity rises with age + disease — may exceed FRC + cause hypoxemia

---

V/Q + HPV: West''s zones, V/Q 0.8, GA reduces FRC + causes atelectasis. HPV redirects to ventilated lung — inhibited by volatile + vasodilator, preserved by TIVA. Lung-protective ventilation universal modern standard.', NULL,
  'medium', 'respiratory', 'review',
  'anesthesiology', 'basic_science', 'respiratory', 'adult',
  'Miller''s Anesthesia; West Respiratory Physiology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Basic science: pulmonary physiology + ventilation
Question on ventilation/perfusion + hypoxic pulmonary vasoconstriction'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Basic science: temperature regulation + anesthesia', '[{"label":"A","text":"Hypothermia desirable always"},{"label":"B","text":"Thermoregulation during anesthesia"},{"label":"C","text":"Skip temp monitoring"},{"label":"D","text":"Cold IV fluid routine"},{"label":"E","text":"Cold room mandatory"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Thermoregulation during anesthesia: (1) Mechanisms heat loss: - Radiation (40%); - Convection (30%); - Evaporation (skin + airway + surgical); - Conduction (cold surfaces); (2) Anesthesia + thermoregulation: - GA inhibits hypothalamic thermoregulation; threshold for shivering decreased to 34°C (normal 36.5°C); - Vasoconstriction threshold decreased; - Redistribution hypothermia — peripheral vasodilation after induction → core temp drops 1-2°C in first hour; - Linear loss 0.5-1°C/hr if uncorrected; - Plateau when shivering threshold reached; (3) Consequences hypothermia: - Wound infection (vasoconstriction → tissue hypoxia); - Coagulopathy (impaired enzymes + platelets); - Cardiac arrhythmias + MI; - Delayed drug metabolism; - Patient discomfort + shivering (5× O2 consumption); - Length of stay; (4) Active warming: - Pre-warm pre-op 30-60 min reduces redistribution; - Forced air warmer (Bair Hugger) — most effective; - Warm IV fluids (37-40°C); blood warmer; - Warm humidified gases (minor); - Increase OR ambient temperature (24-26°C); - Underbody warming, conductive blankets; (5) Hypothermia indications (intentional): - Deep hypothermic circulatory arrest (DHCA) — cardiac/aortic surgery; - Post-cardiac arrest TTM 32-36°C; - Neurosurgical adjunct (controversial); (6) Hyperthermia: - Malignant hyperthermia (treat as covered); - Sepsis/infection; - Drug-induced (anticholinergic, sympathomimetic, serotonin syndrome, NMS); - Hyperthyroidism storm; - Treat: stop trigger + cool + hydrate + treat underlying; (7) Monitoring — esophageal/bladder/nasopharyngeal core temp; surface variable; (8) Target — normothermia 36-37°C

---

Thermoregulation: GA inhibits hypothalamic regulation, redistribution hypothermia first hour. Hypothermia → infection, coagulopathy, MI, shivering. Active warming + pre-warming. Target 36-37°C. Intentional hypothermia: DHCA, TTM.', NULL,
  'easy', 'endocrine_metabolic', 'review',
  'anesthesiology', 'basic_science', 'endocrine_metabolic', 'adult',
  'ASPAN Hypothermia; Miller''s Anesthesia', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Basic science: temperature regulation + anesthesia'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'EMS question: pre-hospital + transport anesthesia
Field intubation criteria + considerations', '[{"label":"A","text":"Intubate all trauma"},{"label":"B","text":"Pre-hospital/transport anesthesia"},{"label":"C","text":"Skip airway protection"},{"label":"D","text":"No monitoring"},{"label":"E","text":"Walk-in trauma center"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pre-hospital/transport anesthesia: (1) Indications for pre-hospital intubation: - Inability to maintain/protect airway; - Failure to ventilate/oxygenate despite simpler measures; - Severe TBI GCS ≤ 8; - Anticipated clinical course (e.g., burn airway); - Long transport time; (2) Pre-hospital RSI requires: - Trained provider (anesthesia, EM, critical care paramedic); - Equipment + medications; - Monitoring (SpO2, EtCO2, BP, ECG); - Backup airway plan; - Quality assurance + outcomes tracking; (3) Drug RSI: - Etomidate or ketamine (hemodynamically stable in shock); - Rocuronium or succinylcholine; (4) Confirmation — EtCO2 mandatory; auscultation supplemental; (5) Outcomes — pre-hospital intubation can worsen outcomes if performed by inexperienced providers; multiple studies; trained services improve outcomes; (6) Supraglottic airway alternative — iGel, LMA — faster + safer than ETT in some settings; (7) Mechanical ventilation transport — small ventilators, lung-protective TV 6 mL/kg, PEEP, FiO2 adjusted; (8) Sedation + analgesia transport — fentanyl, midazolam, ketamine, propofol infusion; (9) Hemodynamic support — vasopressor infusion, fluid; (10) Communication with receiving facility — destination decision (trauma center, stroke center, STEMI center); (11) HEMS (helicopter) considerations — noise, vibration, weight, altitude (PaO2 drops, expanded gas), thermoregulation; (12) Interhospital transport — pre-transport optimization, anticipated equipment failure backup, monitoring continuity; (13) Modern: tele-EMS, point-of-care US, video laryngoscopy in field, simulation training

---

Pre-hospital anesthesia: indications for intubation, RSI with etomidate/ketamine + rocuronium/sux, EtCO2 confirmation, SGA alternative, transport ventilation + sedation, destination decision. Outcome depends on provider experience.', NULL,
  'medium', 'trauma', 'review',
  'anesthesiology', 'ems_mgmt', 'trauma', 'adult',
  'NAEMSP Practice Statements; PHTLS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'EMS question: pre-hospital + transport anesthesia
Field intubation criteria + considerations'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Mass casualty incident — multiple trauma patients arriving — triage + anesthesia role', '[{"label":"A","text":"Treat first arrived"},{"label":"B","text":"Mass casualty + triage"},{"label":"C","text":"Ignore triage"},{"label":"D","text":"Treat black tag first"},{"label":"E","text":"Skip blood bank"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mass casualty + triage — anesthesia role: (1) Triage systems: - START (Simple Triage And Rapid Treatment) — adult: ability to walk, respiration, perfusion, mental status; - JumpSTART — pediatric; - SALT (Sort, Assess, Lifesaving interventions, Treatment/Transport); - Categories: RED (immediate — survivable life-threatening), YELLOW (delayed — serious but stable), GREEN (minor — walking wounded), BLACK (deceased/expectant); (2) Greatest good for greatest number principle (vs individual best care); (3) Anesthesia roles: - Airway management (intubation, surgical airway, SGA); - Resuscitation (IV access, IO if difficult, fluid, blood); - Operating room management — surgical priority, damage control; - ICU + transport coordination; - Mass casualty pre-deployment training; (4) Hospital response: - Activate disaster plan; - Mobilize personnel; - Cancel elective; - Open additional ORs; - Blood bank mass casualty protocol; - Patient flow + identification system; (5) Lifesaving interventions in field: - Airway opening, chest decompression (pneumothorax), hemorrhage control (tourniquet), antidote (autoinjector); (6) Tourniquet — modern resurgence (CAT, SOFTT-W); for extremity hemorrhage life-threatening; can stay 6-8h safely; (7) Hemorrhage control — direct pressure, hemostatic dressing, tourniquet, wound packing; whole blood emerging civilian; (8) Anesthetic considerations — high-volume rapid care, ketamine + minimal monitoring, regional anesthesia for selected injuries, ECMO referral capability; (9) Mental health for providers + patients; (10) Debrief + after-action review; (11) Special situations — chemical/biological/radiological/nuclear (CBRN); (12) Multidisciplinary disaster team training + drills

---

Mass casualty: START/SALT triage (RED/YELLOW/GREEN/BLACK), greatest good principle. Anesthesia roles: airway, resuscitation, OR management. Hospital disaster plan. Tourniquet hemorrhage. Multidisciplinary drills.', NULL,
  'medium', 'trauma', 'review',
  'anesthesiology', 'ems_mgmt', 'trauma', 'adult',
  'ATLS; NAEMSP MCI; Stop the Bleed', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Mass casualty incident — multiple trauma patients arriving — triage + anesthesia role'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Question on quality + safety in anesthesia: closed claims + adverse events', '[{"label":"A","text":"Ignore adverse events"},{"label":"B","text":"Quality + safety in anesthesia"},{"label":"C","text":"Hide errors"},{"label":"D","text":"Punish all"},{"label":"E","text":"Skip continuing education"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Quality + safety in anesthesia: (1) ASA Closed Claims Project — analysis malpractice claims identifies patterns: - Top categories: nerve injury, dental damage, respiratory events, awareness, eye injury, regional anesthesia complications, OB anesthesia, post-op visual loss, fire injury; - Modern: more chronic pain claims, regional anesthesia, peripheral nerve injury, intra-op awareness with recall; - Standards improvements reduced specific events (e.g., capnography reduced unrecognized esophageal intubation); (2) Adverse event management: - Recognize + acknowledge; - Disclosure to patient/family (ethical + legal); - Document factually; - Internal reporting + investigation; - Root cause analysis; - Quality improvement; - Support second victim (provider); (3) Risk management — Just Culture: - Distinguish human error (console + retrain) vs at-risk behavior (coach) vs reckless (discipline); - Encourage reporting + learning; (4) Patient safety initiatives: - ASA Anesthesia Quality Institute (AQI); - APSF; - National Patient Safety Foundation; - Joint Commission accreditation; - WHO Surgical Safety Checklist; (5) Specific safety improvements: - Pulse oximetry + capnography mandatory; - Standardized monitoring; - Quantitative TOF monitoring; - Difficult airway algorithm; - Cognitive aids (emergency manuals); - Simulation training; - Crew Resource Management (CRM); - Maintenance of Certification; (6) Outcome metrics — perioperative mortality, MOC, surgical site infection, PONV, pain, satisfaction, length of stay; (7) Quality improvement frameworks — PDSA, lean, six sigma; (8) National Anesthesia Clinical Outcomes Registry (NACOR); (9) MOCA Minute (continuous learning); (10) Modern: AI, machine learning, big data, EHR analytics for adverse event detection + prevention

---

Anesthesia quality + safety: ASA Closed Claims (nerve injury, dental, respiratory, awareness), adverse event management (recognize, disclose, RCA), Just Culture, mandatory monitoring, CRM, simulation, MOC, NACOR. Modern AI/ML.', NULL,
  'easy', 'procedures', 'review',
  'anesthesiology', 'ems_mgmt', 'procedures', 'adult',
  'ASA Closed Claims Project; APSF', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Question on quality + safety in anesthesia: closed claims + adverse events'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Question on end-of-life care + anesthesia', '[{"label":"A","text":"Always full resuscitation"},{"label":"B","text":"End-of-life care + anesthesia"},{"label":"C","text":"Hide diagnosis"},{"label":"D","text":"Force intubation"},{"label":"E","text":"Ignore family"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** End-of-life care + anesthesia: (1) Palliative anesthesia — symptom management in serious illness/end of life: - Pain (opioids, regional anesthesia, intrathecal pump, sympathetic blocks); - Dyspnea (opioids low-dose, anxiolytics, oxygen, fan); - Nausea (multimodal antiemetics); - Anxiety + delirium; - Total pain concept (physical + psychological + social + spiritual); (2) DNR/DNI in operating room: - ASA Statement: required reconsideration (NOT automatic suspension); - Explicit discussion patient/surrogate + surgeon + anesthesiologist; - Options: full suspension (most common historically), procedure-directed (no chest compressions, no defibrillation, etc.), goal-directed (resuscitate if temporary issue, not if terminal); - Document explicitly; restore DNR postop; - Limits on interventions don''t preclude anesthesia care; (3) Withdrawal of life-sustaining therapy — anesthesia role: - Compassionate extubation; - Symptom management — opioid + benzodiazepine titrated to comfort (Doctrine of Double Effect — intent to relieve suffering, foreseeable but unintended hastening of death — ethical + legal); - Family presence + support; - Spiritual care; (4) Hospice + palliative care consultation; (5) Anesthesia for palliative procedures: - Nerve block/neurolysis (celiac plexus, splanchnic, intercostal, sympathetic) for cancer pain; - Vertebroplasty for spine fractures; - Bronchoscopy/stenting for airway obstruction; - GI stenting for obstruction; (6) Goals of care discussions: - Address prognosis honestly + sensitively; - Patient values + preferences; - Trade-offs; - Quality of life vs length; - Family inclusion; (7) Ethical principles: - Autonomy + informed consent; - Beneficence + non-maleficence; - Doctrine of Double Effect; - Distinction between killing + allowing to die; (8) Modern: integrated palliative + critical care; Schwartz Rounds for provider support; (9) Cultural sensitivity

---

End-of-life anesthesia: palliative procedures, DNR in OR = required reconsideration (not suspension), withdrawal of LST with symptom Mx (Doctrine of Double Effect), goals of care discussions, palliative consultation, integrated care.', NULL,
  'medium', 'psych_behavior', 'review',
  'anesthesiology', 'integrative', 'psych_behavior', 'adult',
  'ASA Statement on DNR; AAHPM Palliative Care', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Question on end-of-life care + anesthesia'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Pre-op question: patient on chronic anticoagulation + antiplatelet — bridging plan
70 ปี AFib on warfarin (CHA2DS2-VASc 5) + ASA + clopidogrel post-DES 8 ปี ago — elective hip replacement', '[{"label":"A","text":"Stop all + no bridging"},{"label":"B","text":"Bridging anticoagulation pre-op"},{"label":"C","text":"Continue all chronically"},{"label":"D","text":"Skip cardiology consult"},{"label":"E","text":"Always bridge with heparin"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bridging anticoagulation pre-op: (1) CHA2DS2-VASc 5 = high stroke risk AFib; (2) Warfarin management — depends on bleeding risk surgery + stroke risk patient: - HIGH stroke risk (CHA2DS2-VASc ≥ 5, mechanical valve, recent VTE < 3 months): consider bridging with LMWH; BRIDGE trial showed no benefit + increased bleeding for AFib (CHA2DS2-VASc ≤ 5 — most patients); for higher risk individualize; - Continue warfarin if low-bleeding-risk procedure (cataracts, dental, dermatologic, simple endoscopy); (3) Standard hold warfarin 5 days pre-op + restart 12-24h post-op when hemostasis OK; check INR ≤ 1.5 day before; (4) DOAC bridging — generally NOT recommended; hold based on half-life + CrCl + bleeding risk: - Apixaban/rivaroxaban: 48h hold (high bleed risk), 24h (low); longer with renal; - Dabigatran: 48-96h depending on CrCl; (5) Reversal options: - Warfarin: Vit K, 4-factor PCC (Kcentra), FFP; - Apixaban/rivaroxaban: andexanet alfa, PCC; - Dabigatran: idarucizumab (specific antibody); (6) Antiplatelet management — clopidogrel for DES: - Recent DES (< 6 months) — continue DAPT, defer elective surgery; - Stable > 6-12 months — continue ASA, consider hold clopidogrel 5-7 days (cardiology consult); - Bare metal stent — different timing; (7) Restart timing: - Hemostasis confirmed; - LMWH bridging post-op 48-72h (high VTE/CV risk); - Therapeutic anticoagulation when bleeding low; (8) Special: neuraxial — strict ASRA timing (as covered); (9) Multidisciplinary — cardiology + hematology + surgery + anesthesia; (10) PERIOP2 trial; BRIDGE trial influence modern practice

---

Anticoag bridging: BRIDGE trial — no benefit AFib most patients. Hold warfarin 5d, DOAC per half-life + CrCl. Reversal agents available. Clopidogrel + DES — defer if recent. Restart based on hemostasis. Multidisciplinary.', NULL,
  'hard', 'hematology', 'review',
  'anesthesiology', 'clinical_decision', 'hematology', 'adult',
  'ACC/AHA Perioperative; CHEST Antithrombotic; BRIDGE trial', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Pre-op question: patient on chronic anticoagulation + antiplatelet — bridging plan
70 ปี AFib on warfarin (CHA2DS2-VASc 5) + ASA + clopidogrel post-DES 8 ปี ago — elective hip replacement'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 45 ปี — emergency open AAA repair with rupture
BP 75/40, HR 130, intubated in ED
Massive transfusion ongoing — 8 units PRC + 6 FFP + 1 platelet apheresis so far', '[{"label":"A","text":"Standard anesthesia"},{"label":"B","text":"Ruptured AAA emergency anesthesia"},{"label":"C","text":"Aggressive crystalloid only"},{"label":"D","text":"Avoid all transfusion"},{"label":"E","text":"Hold ventilation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Ruptured AAA emergency anesthesia: (1) Mortality 50% reaching hospital, 80% overall; (2) Resuscitation principles: - Permissive hypotension SBP 70-90 until cross-clamp (controls bleeding before surgery); - Massive transfusion 1:1:1; TXA; - Avoid over-resuscitation (worsens bleeding + coagulopathy); - Large-bore IV × 2-3 + RIC line or central; - Arterial line ASAP; (3) Anesthesia induction: - Pre-induction: surgeon scrubbed + prepped, OR ready, blood products in room; - Ketamine 1 mg/kg + opioid + rocuronium 1.2 mg/kg; - Etomidate alternative; - Avoid propofol bolus (hypotension); (4) Cross-clamp considerations: - Pre-clamp: lower BP target (SBP 90-100), prepare for sudden afterload increase; - Apply clamp: massive BP rise + afterload + decreased CO; treat with vasodilator (nitroglycerin), increase volatile, deepen anesthesia, fluid; - Pre-unclamp: volume load, calcium, sodium bicarb (acidosis from ischemic limb), expect hypotension; - Unclamp: profound hypotension expected (vasodilation + reactive hyperemia + metabolite release); vasopressor, fluid; (5) Ventilation: lung-protective; (6) Renal protection — fluid + mannitol selectively; minimize ischemia time; (7) Spinal cord protection (TAA) — CSF drainage, MAP > 80-90, mild hypothermia; (8) Coagulopathy management — TEG/ROTEM; fibrinogen target > 1.5-2; warm products; calcium; (9) Hypothermia avoidance — warming all; (10) Post-op ICU — expect prolonged ventilation, AKI, coagulopathy, abdominal compartment syndrome, mesenteric ischemia, paraplegia (TAA); (11) Endovascular alternative (EVAR) — lower mortality if anatomy suitable; emergent EVAR program; (12) Multidisciplinary — vascular surgery + anesthesia + perfusion (if open) + ICU + blood bank

---

Ruptured AAA: permissive hypotension, MTP 1:1:1, ketamine/etomidate induction, cross-clamp Mx (vasodilator pre, vasopressor post-unclamp), TEG-guided, warming, renal + spinal cord protection. EVAR alternative.', NULL,
  'hard', 'trauma', 'review',
  'anesthesiology', 'clinical_decision', 'trauma', 'adult',
  'SVS AAA Guidelines; SCA Vascular Anesthesia', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 45 ปี — emergency open AAA repair with rupture
BP 75/40, HR 130, intubated in ED
Massive transfusion ongoing — 8 units PRC + 6 FFP + 1 platelet apheresis so far'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 45 ปี post-laparoscopic Roux-en-Y gastric bypass 6 months ago — elective ventral hernia repair
Weight 88 kg (down from 145 kg)
No current GERD; on PPI, B12, multivitamins', '[{"label":"A","text":"Treat as morbidly obese"},{"label":"B","text":"Post-bariatric surgery anesthesia"},{"label":"C","text":"Heavy NSAID use"},{"label":"D","text":"Skip B12"},{"label":"E","text":"Force oral medications"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-bariatric surgery anesthesia: (1) Physiology changes: - Significant weight loss → improved cardiopulmonary status; - Reduced OSA severity (re-evaluate); - Improved diabetes, HTN; - Nutritional deficiencies common (B1, B12, iron, vit D, protein); (2) Anatomic changes: - Roux-en-Y gastric bypass: small pouch + Roux limb + bypass; rapid transit; - Sleeve gastrectomy: tubular stomach; (3) Anesthesia considerations: - NPO different — modified, rapid transit; some centers shorter NPO; - Aspiration risk variable — bypass typically lower (small pouch); sleeve variable; consider RSI if symptoms or recent surgery; - Pharmacokinetics altered — reduced absorption oral medications; consider IV/IM; - Volume of distribution changed; (4) Specific medication concerns: - NSAID: AVOID after bariatric (anastomotic ulcer + perforation risk); - Opioid: increased sensitivity (weight loss + reduced tolerance); - Iron, B12 supplementation; - Hypoglycemia risk (dumping syndrome); (5) Multimodal opioid-sparing: - Regional anesthesia (TAP, ESP, rectus sheath); - Acetaminophen + ketamine + gabapentinoid + dexamethasone + lidocaine infusion; - Local infiltration; - Avoid NSAID; (6) DVT prophylaxis — still increased risk even after weight loss; mechanical + pharmacologic; (7) Reassess OSA — repeat sleep study post-significant weight loss; (8) Late complications watch for: - Internal hernia (Roux-en-Y) — abdominal pain emergency; - Anastomotic stricture; - Nutritional deficiencies; - Dumping syndrome; - Gallstones; (9) Psychiatric — depression, substance abuse increased post-bariatric — screen + support; (10) Modern: bariatric surgery long-term care multidisciplinary

---

Post-bariatric: AVOID NSAID (ulcer + perforation), opioid sensitivity increased, altered PK + nutritional deficiencies, multimodal regional anesthesia, screen OSA, internal hernia emergency, multidisciplinary.', NULL,
  'medium', 'gi', 'review',
  'anesthesiology', 'clinical_decision', 'gi', 'adult',
  'SOBA Bariatric Anesthesia Guidelines; ASMBS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 45 ปี post-laparoscopic Roux-en-Y gastric bypass 6 months ago — elective ventral hernia repair
Weight 88 kg (down from 145 kg)
No current GERD; on PPI, B12, multivitamins'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 80 ปี frail, ASA III — elective laparoscopic cholecystectomy
Clinical Frailty Score 6, lives in assisted living, mild cognitive impairment
Family wants aggressive treatment', '[{"label":"A","text":"Standard adult anesthesia"},{"label":"B","text":"Geriatric anesthesia + frailty"},{"label":"C","text":"Heavy benzodiazepine premed"},{"label":"D","text":"Skip pre-op assessment"},{"label":"E","text":"Refuse elderly patients"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Geriatric anesthesia + frailty: (1) Frailty assessment: - Clinical Frailty Score (CFS); - Fried Phenotype (weight loss, exhaustion, slow walking, weakness, low activity); - Edmonton Frail Scale; - Frailty = biologic age > chronologic; predicts adverse outcomes; (2) Pre-op optimization: - Multidisciplinary geriatric assessment; - Pre-habilitation (exercise, nutrition, cognitive training); - Medication review (Beers Criteria — avoid potentially inappropriate); - Treat comorbidities; - Cognitive baseline (Mini-Cog, MoCA); - Goals of care discussion; (3) Anesthetic considerations: - Reduced MAC (~6% decrease per decade after 40); - Increased sensitivity to opioids; - Slower drug clearance (renal + hepatic + lean body mass); - Decreased cardiopulmonary reserve; - Increased delirium risk; - Higher perioperative mortality; (4) Drug choices: - Avoid Beers list — benzodiazepines (delirium), anticholinergic (diphenhydramine, scopolamine), meperidine, long-acting opioid; - Use: short-acting agents, regional anesthesia, multimodal; - Propofol carefully (hypotension); - Dexmedetomidine — anxiolysis + sedation without respiratory depression; (5) Delirium prevention: - Avoid offenders (benzo, anticholinergic, opioid in excess); - HELP bundle (orientation, hearing/glasses, sleep, mobility, hydration); - Multimodal pain control; - Avoid restraints; - Family + familiar items; (6) Postop care: - Early mobilization; - Adequate analgesia (multimodal); - Hydration; - Bowel/bladder routines; - Skin care; - Nutrition; - Re-orientation; (7) Outcomes — frailty increases mortality 3-5×; functional decline; institutionalization; (8) Goals of care — quality of life, function, dignity > length; informed shared decision-making; (9) Multidisciplinary — anesthesia + geriatric medicine + surgery + nursing + PT + OT + family; (10) Modern: perioperative geriatric medicine; prehabilitation programs

---

Geriatric + frail: CFS, Beers Criteria avoidance, multimodal opioid-sparing, regional, HELP bundle for delirium, prehabilitation, goals of care. Multidisciplinary. Modern: perioperative geriatric medicine.', NULL,
  'medium', 'psych_behavior', 'review',
  'anesthesiology', 'clinical_decision', 'psych_behavior', 'adult',
  'ACS Geriatric Surgery; AGS Beers Criteria 2023; ASA Brain Health Initiative', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 80 ปี frail, ASA III — elective laparoscopic cholecystectomy
Clinical Frailty Score 6, lives in assisted living, mild cognitive impairment
Family wants aggressive treatment'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 55 ปี chronic kidney disease stage 4 (eGFR 22) — elective inguinal hernia repair
Meds: amlodipine, atorvastatin, no anticoagulant
Hb 10.5, K 4.5, Cr 3.0, urea 80
Anemia of CKD on no EPO yet', '[{"label":"A","text":"Routine doses all drugs"},{"label":"B","text":"Chronic kidney disease perioperative"},{"label":"C","text":"Morphine PCA"},{"label":"D","text":"NSAID for pain"},{"label":"E","text":"Mass IV NS bolus"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Chronic kidney disease perioperative: (1) Pre-op optimization: - Avoid nephrotoxins (NSAIDs, IV contrast, aminoglycosides); - Volume status assessment + optimization; - Treat anemia (Hb > 10) — iron, EPO if indicated; - Electrolytes — correct hyperkalemia, acidosis; - Coagulopathy from uremia — DDAVP 0.3 mcg/kg if bleeding; cryoprecipitate; platelet dysfunction; - Hold ACE-I/ARB day of surgery (hypotension); continue most others; - Discuss with nephrology; (2) Anesthesia choices: - Regional anesthesia good option (avoid GA in advanced CKD); - GA: cisatracurium (Hofmann elimination — renal-independent), avoid morphine (M6G accumulates) — use fentanyl/hydromorphone; - Propofol OK; etomidate OK; - Avoid succinylcholine if K elevated; - Sevoflurane OK; avoid desflurane prolonged (compound A theoretical concern in CKD); (3) Fluid management — judicious, avoid overload; isotonic crystalloid (NS — but chloride load concern; balanced solutions better; avoid LR if K elevated near upper limit); (4) Hemodynamic — maintain BP (renal perfusion); arterial line for major surgery; (5) Drug dose adjustment per eGFR — many anesthetic adjuncts; (6) Post-op — monitor renal function, urine output, electrolytes, fluid balance; (7) Avoid AKI prevention — maintain MAP, avoid nephrotoxins, fluid balance; (8) Multidisciplinary — nephrology + anesthesia + surgery; (9) Inguinal hernia — regional anesthesia ideal (spinal or local + TAP/ilioinguinal block); (10) Modern: erythropoiesis-stimulating agents (ESA) for anemia, iron sucrose, careful monitoring

---

CKD: avoid NSAIDs/contrast/aminoglycoside, treat anemia, regional preferred, cisatracurium, fentanyl/hydromorphone, balanced fluids, dose adjustment. Inguinal hernia ideal for regional.', NULL,
  'medium', 'cardiovascular', 'review',
  'anesthesiology', 'clinical_decision', 'cardiovascular', 'adult',
  'KDIGO Perioperative; ASA Practice Advisory', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 55 ปี chronic kidney disease stage 4 (eGFR 22) — elective inguinal hernia repair
Meds: amlodipine, atorvastatin, no anticoagulant
Hb 10.5, K 4.5, Cr 3.0, urea 80
Anemia of CKD on no EPO yet'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย 50 ปี — emergency 2 hr after exposure: pesticide (organophosphate) — ingested deliberately
Symptoms: salivation, sweating, miosis, fasciculations, bradycardia, bronchospasm
SpO2 88%, BP 80/50, HR 50', '[{"label":"A","text":"Naloxone"},{"label":"B","text":"Organophosphate poisoning"},{"label":"C","text":"Beta-blocker"},{"label":"D","text":"Calcium channel blocker"},{"label":"E","text":"Succinylcholine for RSI"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Organophosphate poisoning — cholinergic crisis: (1) Mechanism — acetylcholinesterase inhibition → ACh accumulation → muscarinic + nicotinic + CNS effects; (2) Toxidrome — SLUDGE/BBB: salivation, lacrimation, urination, defecation, GI upset, emesis + bronchorrhea, bronchospasm, bradycardia + miosis, fasciculations, weakness, confusion, seizure, coma; (3) Decontamination: - Remove clothing; - Wash skin (provider PPE — concentrated agents harm responders); - Activated charcoal early if ingested; - GI lavage controversial; (4) Atropine — competitive muscarinic antagonist: - Bolus 1-3 mg IV q3-5 min doubling until adequate atropinization (dry secretions, HR > 80, no bronchospasm); huge doses may be needed (10s-100s of mg); - Infusion to maintain; - Endpoint: drying of secretions, not pupil dilation (lags); (5) Pralidoxime (2-PAM) — regenerates AChE if given before ''aging'' of enzyme (hours): - 1-2 g IV bolus + 500 mg/hr infusion; - Effective for nicotinic + muscarinic; - Less effective for some agents (nerve agents age fast); (6) Airway: - Intubate for respiratory failure/secretions/altered mental status; - Avoid succinylcholine — prolonged paralysis (depends on cholinesterase); - Use rocuronium (longer onset, but only choice); - Suctioning constant for secretions; (7) Seizures — benzodiazepine; (8) Hemodynamic support; (9) ICU admission — prolonged course (days-weeks); intermediate syndrome (paralysis 24-96h post); delayed neuropathy weeks-months; (10) Psychiatric consult — intentional ingestion; (11) Modern: hemoperfusion experimental; lipid emulsion (some advocate); (12) Multidisciplinary — toxicology + ICU + psychiatry

---

Organophosphate: atropine (titrate to dry secretions), pralidoxime (2-PAM) before aging, decontamination, intubate with rocuronium (NOT sux), benzo for seizure, ICU course prolonged.', NULL,
  'medium', 'toxicology', 'review',
  'anesthesiology', 'clinical_decision', 'toxicology', 'adult',
  'WHO Toxicology; ASA Acute Poisoning', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วย 50 ปี — emergency 2 hr after exposure: pesticide (organophosphate) — ingested deliberately
Symptoms: salivation, sweating, miosis, fasciculations, bradycardia, bronchospasm
SpO2 88%, BP 80/50, HR 50'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย 24 ปี healthy elective ACL reconstruction outpatient — spinal anesthesia + sedation
Finished procedure, in PACU, vital signs stable, ambulating, voiding
Ready for discharge', '[{"label":"A","text":"Admit overnight always"},{"label":"B","text":"Ambulatory surgery discharge criteria"},{"label":"C","text":"Refuse discharge"},{"label":"D","text":"No instructions"},{"label":"E","text":"Discharge alone driving"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Ambulatory surgery discharge criteria: (1) Aldrete Score — modified for ambulatory: - Activity (move all extremities voluntarily); - Respiration (deep breathe, cough); - Circulation (BP within 20% baseline); - Consciousness (fully awake); - SpO2 (> 92% on room air); - Score ≥ 9 for PACU discharge; (2) PADSS (Post-Anesthesia Discharge Scoring System): - Vital signs; - Activity (ambulation); - Nausea/vomiting; - Pain; - Surgical bleeding; - Score ≥ 9 for home discharge; (3) Specific criteria for ambulatory discharge: - Stable VS × 30 min; - Awake + oriented; - Able to ambulate (with assistance if needed); - Pain manageable with oral medications; - PONV controlled; - No bleeding; - Voided (controversial — some require, especially after neuraxial); - Tolerating PO fluids (controversial — fast-track may skip); - Responsible adult escort; - Written + verbal discharge instructions; - Follow-up plan; (4) Spinal anesthesia specific: - Resolution of motor block; - Sensory regression to S3 (anal); - Some advocate voiding before discharge (urinary retention risk) — others allow with instructions if low-risk; - Lower-dose short-acting LA (chloroprocaine, hyperbaric lidocaine, low-dose bupivacaine) faster ambulation; (5) Fast-track recovery — bypass PACU if criteria met in OR; (6) ERAS ambulatory protocols; (7) Outpatient surgery contraindications: - Severe OSA without home CPAP; - Unstable comorbidity; - Lack escort/home support; (8) Modern: increasing complex outpatient surgery (TKA, mastectomy, even some hysterectomies)

---

Ambulatory discharge: Aldrete + PADSS scores, VS stable, ambulating, pain/PONV controlled, escort home, voided (selective), instructions. Spinal: motor + sensory recovery, voiding for some. ERAS + fast-track modern.', NULL,
  'easy', 'procedures', 'review',
  'anesthesiology', 'ems_mgmt', 'procedures', 'adult',
  'SAMBA Guidelines; ASA Ambulatory Anesthesia', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วย 24 ปี healthy elective ACL reconstruction outpatient — spinal anesthesia + sedation
Finished procedure, in PACU, vital signs stable, ambulating, voiding
Ready for discharge'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 35 ปี G2P1 GA 28 wk severe pulmonary HTN (mean PAP 50)
Dyspnea NYHA III, RV dysfunction
Obstetric anesthesia consult — delivery planning', '[{"label":"A","text":"Routine epidural for labor"},{"label":"B","text":"Severe pulmonary hypertension in pregnancy"},{"label":"C","text":"Single-shot spinal for C-section"},{"label":"D","text":"Heavy IV crystalloid"},{"label":"E","text":"Pure alpha agonist high dose"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe pulmonary hypertension in pregnancy — high mortality (25-50%): (1) Multidisciplinary pre-conception counseling — pregnancy contraindicated traditionally, but some patients counseled; modern care improved outcomes; (2) Pulmonary HTN + pregnancy physiology: - Increased CO 40% poorly tolerated with fixed PVR; - RV failure risk; - Highest risk peri-/postpartum (autotransfusion, blood loss); (3) Delivery planning: - Multidisciplinary center (anesthesia + OB + cardiology + ICU + neonatology + ECMO); - Vaginal vs C-section — controversial; vaginal with epidural may be preferred (avoid surgical stress); C-section for OB indications; - Avoid neuraxial-induced sudden sympathectomy (slow epidural titration; spinal generally avoided); (4) Anesthesia approach: - Avoid sudden hemodynamic changes; - Pulmonary vasodilator continuation (sildenafil, bosentan, inhaled NO, prostacyclin epoprostenol/iloprost); - Avoid pulmonary vasoconstrictors (hypoxia, hypercarbia, acidosis, cold, pain, alpha-agonist concentrated); - Norepinephrine + low-dose vasopressin for SBP support (less PVR effect); - Inotropes (milrinone, dobutamine); - TEE intraop guides; - Avoid fluid overload (RV failure); (5) Cesarean considerations: - Continuous regional (slow CSE or epidural extension) often preferred over GA + spinal; - Single-shot spinal AVOIDED (sudden sympathectomy); - GA with caution (laryngoscopy response avoid, gentle ventilation, RSI standard for OB); (6) Postpartum care — highest mortality first week postpartum; ICU 1-2 weeks; aggressive monitoring; (7) Anticoagulation considerations; (8) ECMO standby; (9) Multidisciplinary; (10) Modern: improved outcomes with PAH centers + multidisciplinary planning

---

Severe PHTN + pregnancy: multidisciplinary PAH center, continuous epidural over spinal, pulmonary vasodilator continuation, avoid pulmonary vasoconstrictors, norepi + vasopressin, ICU postpartum, ECMO standby.', NULL,
  'hard', 'obgyn', 'review',
  'anesthesiology', 'clinical_decision', 'obgyn', 'adult',
  'SOAP PHTN Consensus; ESC/AHA Pulmonary HTN Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 35 ปี G2P1 GA 28 wk severe pulmonary HTN (mean PAP 50)
Dyspnea NYHA III, RV dysfunction
Obstetric anesthesia consult — delivery planning'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชาย 8 ปี 25 kg — emergency tonsil bleed 6h post-tonsillectomy
Active bleeding, swallowed unknown amount
Tachycardia 130, BP 95/55, sleepy + anxious
Full stomach + anticipated difficult airway', '[{"label":"A","text":"Standard induction"},{"label":"B","text":"Post-tonsillectomy bleed"},{"label":"C","text":"Wait + observe bleeding"},{"label":"D","text":"Discharge"},{"label":"E","text":"No fluid resuscitation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-tonsillectomy bleed — pediatric emergency: (1) Full stomach (swallowed blood) + hypovolemic + uncooperative; airway emergency; (2) Pre-op: - Resuscitate IV fluid (NS 20 mL/kg bolus + repeat as needed); - Type + cross + transfuse if Hb low; - NG tube avoid (may worsen bleeding + uncomfortable); - Suction ready (multiple Yankauers); - Position lateral or head-down to drain blood; - Difficult airway equipment ready (multiple ETT sizes, video laryngoscope, surgical airway); - ENT scrubbed + ready in OR; (3) Induction options: - RSI with cricoid pressure (but cricoid may dislodge clot); - Modified RSI; - Inhalational induction lateral position (if child uncooperative or no IV) — but full stomach concern; - Awake intubation difficult in child; (4) Drugs: - Ketamine 1-2 mg/kg (CV stable in hypovolemia) OR propofol low-dose; - Rocuronium 1.2 mg/kg or succinylcholine 1-2 mg/kg; - Etomidate alternative; (5) Intubation challenges: - Blood obscuring view; - Suction ready; - Video laryngoscopy + bougie helpful; - Smaller ETT if airway edematous; - SGA backup if difficult; (6) Confirm placement, suction stomach with OG; (7) Maintain fluid resuscitation, transfusion as needed; (8) ENT control bleeding — re-cautery, surgical control; (9) Extubation — fully awake, suction, head-down/lateral, equipment ready (may need re-intubation); (10) Post-op observation 24h+; (11) Most secondary bleeds resolve with intervention; mortality rare but real

---

Pediatric tonsil bleed: hypovolemia + full stomach + difficult airway. Resuscitate, RSI with ketamine + rocuronium/sux, multiple suction, video laryngoscopy, ENT ready, awake extubation. 24h observation.', NULL,
  'hard', 'respiratory', 'review',
  'anesthesiology', 'clinical_decision', 'respiratory', 'peds',
  'APAGBI; SPA Pediatric Anesthesia Practice', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'เด็กชาย 8 ปี 25 kg — emergency tonsil bleed 6h post-tonsillectomy
Active bleeding, swallowed unknown amount
Tachycardia 130, BP 95/55, sleepy + anxious
Full stomach + anticipated difficult airway'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Basic science: dexmedetomidine pharmacology + clinical applications', '[{"label":"A","text":"GABA agonist"},{"label":"B","text":"Dexmedetomidine (Precedex)"},{"label":"C","text":"NMDA antagonist"},{"label":"D","text":"Beta-blocker"},{"label":"E","text":"Opioid agonist"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Dexmedetomidine (Precedex) — alpha-2 agonist: (1) Mechanism — selective alpha-2A receptor agonist (8× more selective than clonidine); acts in locus coeruleus → sedation; spinal cord → analgesia; sympathetic ganglia → sympatholysis; (2) Effects: - Sedation: arousable, mimics natural sleep (N3 stage), preserved respiration; - Analgesia: moderate; opioid-sparing; - Sympatholysis: BP + HR decrease (helpful + concerning); - Anxiolysis; - No significant respiratory depression (huge advantage); - Anti-shivering; - Anti-delirium properties; (3) Pharmacokinetics: - Loading: 1 mcg/kg over 10 min (optional — causes hypotension/bradycardia at fast load); - Infusion: 0.2-1.5 mcg/kg/hr titrated; - Onset 5-10 min, redistribution half-life 6 min, elimination 2-3 h; - Hepatic metabolism — adjust hepatic dysfunction; (4) Clinical uses: - ICU sedation (alternative to propofol/midazolam; less delirium); - Awake fiberoptic intubation (preserved respiration + cooperation); - MAC/procedural sedation; - Adjunct GA (reduces opioid + volatile); - Pediatric: pre-medication, MRI sedation, post-op (ED prevention); - Cardiac surgery (post-op sedation + delirium prevention); - Withdrawal management (alcohol, opioid); - PACU shivering; - Awake craniotomy; (5) Side effects: - Hypotension + bradycardia (especially with loading or in volume-depleted); - Rebound hypertension on abrupt discontinuation (rare); - Caution in heart block, severe LV dysfunction, hypovolemia; (6) Comparisons: - Clonidine — less selective, oral available, less ICU use; - Vs propofol: less respiratory depression, more bradycardia, less hypotension overall; less delirium; - Vs benzodiazepines: less delirium ICU; (7) Modern: increasing use ICU + perioperative; SPICE III, MIDEX, PRODEX trials

---

Dexmedetomidine: alpha-2A agonist. Sedation without respiratory depression. Analgesia + sympatholysis + anti-delirium. Hypotension/bradycardia side effects. ICU sedation, AFOI, peds premed, post-op, cardiac. Modern use expanding.', NULL,
  'easy', 'procedures', 'review',
  'anesthesiology', 'basic_science', 'procedures', 'adult',
  'Miller''s Anesthesia; SCCM PADIS Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Basic science: dexmedetomidine pharmacology + clinical applications'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Basic science: pharmacology of anesthetic depth monitoring (BIS, awareness)', '[{"label":"A","text":"All patients aware"},{"label":"B","text":"Anesthetic depth monitoring + awareness"},{"label":"C","text":"Skip monitoring"},{"label":"D","text":"Ignore patient reports"},{"label":"E","text":"Deeper anesthesia always"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Anesthetic depth monitoring + awareness: (1) Awareness with recall — 0.1-0.2% routine, higher risk: trauma (1-2%), C-section under GA (1%), cardiac surgery (1%); (2) Risk factors: - TIVA without monitoring; - Light anesthesia; - Hemodynamic instability requiring lighter anesthesia; - History prior awareness; - Difficult airway/intubation (period of paralysis without anesthetic); - Drug error or equipment failure; - Patient factors: chronic opioid, alcohol, drug abuse; (3) Consequences: - Acute distress; - PTSD; - Lawsuit; (4) Monitoring: - Standard ASA monitoring + clinical signs (HR, BP, lacrimation, sweating, movement); - EEG processed: BIS (Bispectral Index) 0-100; target 40-60 anesthesia; > 60 risk awareness; below 40 deeper than necessary; - Entropy; - Narcotrend; - SedLine (patient state index); - Etc.; (5) BIS limitations: - Not perfect (some awake with low BIS, vice versa); - EMG artifact; - Drug-specific (ketamine + N2O may not correlate); - Some studies (B-Aware) showed reduction in awareness; others (B-Unaware) no difference vs end-tidal anesthetic monitoring in volatile cases; - Better in TIVA than volatile; (6) Prevention awareness: - Confirm anesthetic delivery (vapor on, infusion running, IV functional); - Adequate dose particularly for cases requiring lighter (cardiac, trauma); - End-tidal anesthetic monitoring during volatile; - BIS for high-risk + TIVA; - Avoid muscle relaxant unless necessary; - Premedication amnestic (midazolam); (7) Postop assessment — Modified Brice questionnaire; (8) Management awareness — acknowledge, reassure, debrief, psychiatric support, follow up; (9) ASA Awareness Practice Advisory; (10) Modern: routine BIS for TIVA + high-risk

---

Awareness: 0.1-0.2% routine, higher trauma/OB/cardiac. BIS 40-60 target. Limitations exist. Prevention: confirm delivery, adequate dose, end-tidal anesthetic + BIS high-risk, premedication. Modified Brice. PTSD risk.', NULL,
  'medium', 'neurology', 'review',
  'anesthesiology', 'basic_science', 'neurology', 'adult',
  'ASA Awareness Practice Advisory; B-Aware + B-Unaware trials', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Basic science: pharmacology of anesthetic depth monitoring (BIS, awareness)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Integrative question: anesthesia care for transgender patient — surgical considerations + hormone therapy', '[{"label":"A","text":"Treat as cisgender"},{"label":"B","text":"Transgender patient"},{"label":"C","text":"Discriminate based on identity"},{"label":"D","text":"Out hormones without consent"},{"label":"E","text":"Refuse care"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Transgender patient — anesthesia care: (1) Respectful + affirming care: - Use chosen name + pronouns; - Privacy + dignity; - Knowledgeable team; - Non-judgmental; (2) Hormone therapy considerations: - Estrogen (trans women) — increased VTE risk (especially ethinyl estradiol; transdermal lower risk); some advocate hold 2-4 weeks pre-major surgery; others continue if mechanical + pharmacologic VTE prophylaxis; balance risk; - Testosterone (trans men) — increased polycythemia, lipid changes; usually continue perioperatively; - Anti-androgens (spironolactone) — hyperkalemia, hypotension; (3) Surgical procedures: - Gender-affirming surgery (top — mastectomy/breast augmentation; bottom — vaginoplasty, phalloplasty, metoidioplasty, hysterectomy, orchiectomy); - Specific anesthesia for each; (4) Anesthetic considerations general: - Standard except hormone considerations; - Avoid assumptions about anatomy; - Sensitive imaging requests; - Multimodal opioid-sparing standard; - DVT prophylaxis (especially long surgeries + estrogen); (5) Mental health: - Depression, anxiety, dysphoria; - Higher suicide risk historically — gender-affirming care reduces; - Postop emotional impact; - Support; (6) Reproductive considerations — fertility preservation discussion before some surgeries; (7) Documentation — legal name + chosen name, sex assigned + gender identity, anatomy as relevant; (8) Discrimination prevention — staff education, inclusive policies, EHR systems; (9) WPATH (World Professional Association Transgender Health) Standards of Care guideline; (10) Insurance + financial considerations historically barrier; (11) Pre-op clinic prep — sensitive intake, individualized plan

---

Transgender anesthesia: affirming care, hormone considerations (estrogen VTE risk), gender-affirming surgical needs, multimodal opioid-sparing, mental health support, WPATH guidelines, sensitive documentation, inclusive practice.', NULL,
  'easy', 'psych_behavior', 'review',
  'anesthesiology', 'integrative', 'psych_behavior', 'adult',
  'WPATH Standards of Care 8; ASA Practice', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Integrative question: anesthesia care for transgender patient — surgical considerations + hormone therapy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Integrative: research methodology + evidence-based anesthesia
Critical appraisal of trial — RCT shows new drug reduces PONV vs ondansetron', '[{"label":"A","text":"Accept all studies"},{"label":"B","text":"Critical appraisal RCT + evidence-based anesthesia"},{"label":"C","text":"Ignore evidence"},{"label":"D","text":"All studies equal"},{"label":"E","text":"Skip statistics"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Critical appraisal RCT + evidence-based anesthesia: (1) PICO question — Patient, Intervention, Comparator, Outcome — frame question; (2) Hierarchy of evidence: - Systematic reviews + meta-analyses (Level I); - RCTs (Level II); - Cohort studies (Level III); - Case-control (Level IV); - Case series + expert opinion (Level V); (3) RCT critical appraisal: - Randomization (true random + concealment); - Blinding (patients, providers, outcome assessors); - Intention-to-treat analysis; - Loss to follow-up < 20%; - Baseline characteristics balanced; - Outcome measures appropriate + valid; - Sample size + power; - Statistical significance + clinical significance; - Conflict of interest; - Funding source; (4) Internal validity (study design quality) vs external validity (generalizability); (5) Statistical considerations: - p < 0.05 = statistical significance (arbitrary cutoff); - Confidence intervals more informative; - Number Needed to Treat (NNT); - Effect size; - Multiple comparisons (Bonferroni correction); (6) Bias types: - Selection, performance, detection, attrition, reporting; - Industry-sponsored research bias toward positive results; (7) Common pitfalls: - Surrogate endpoints; - Composite outcomes; - Subgroup analyses post-hoc; - Underpowered; - Short follow-up; (8) Frameworks: - CONSORT for RCT reporting; - GRADE for evidence quality; - Cochrane Risk of Bias; (9) Translating evidence: - Strength of recommendation; - Patient values + preferences; - Resource considerations; - Local context; (10) Modern: pragmatic trials, large simple trials, registry-based RCTs, machine learning prediction; (11) Implementation science — closing evidence-practice gap; (12) Modern: open data, pre-registration, reproducibility

---

Evidence-based anesthesia: PICO, evidence hierarchy, RCT appraisal (randomization, blinding, ITT), internal vs external validity, statistical + clinical significance, CONSORT + GRADE, implementation science. Modern: pragmatic trials.', NULL,
  'easy', 'procedures', 'review',
  'anesthesiology', 'integrative', 'procedures', 'adult',
  'CONSORT; GRADE; Cochrane Handbook', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Integrative: research methodology + evidence-based anesthesia
Critical appraisal of trial — RCT shows new drug reduces PONV vs ondansetron'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 28 ปี healthy elective shoulder arthroscopy in beach chair position
GA + interscalene block + LMA
30 min into surgery, sudden BP drop 110/70 → 60/30, HR 50, EtCO2 stable', '[{"label":"A","text":"Continue case"},{"label":"B","text":"Bezold-Jarisch reflex / cerebral hypoperfusion in beach chair position"},{"label":"C","text":"Decrease IV fluid"},{"label":"D","text":"Mass volatile increase"},{"label":"E","text":"Refuse position"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bezold-Jarisch reflex / cerebral hypoperfusion in beach chair position: (1) Beach chair position — venous pooling lower extremity + reduced venous return; (2) Cerebral perfusion concern — measure BP at brain level (subtract ~15-20 mmHg from arm BP for head level); MAP at brain target > 70-80; cerebral oximetry (NIRS) helpful; (3) Bezold-Jarisch reflex — paradoxical bradycardia + hypotension from inadequate venous return + ventricular mechanoreceptor activation; (4) Management: - Lower head of bed (return to supine); - IV fluid bolus; - Vasopressor (phenylephrine, ephedrine, norepinephrine); - Atropine for bradycardia (0.4-0.6 mg); - Reduce volatile if too deep; (5) Interscalene block effects — phrenic palsy (50-100%), Horner, hypotension less; not cause of this; (6) Other DDx beach chair: air embolism (CO2 capno drop), stroke, hypovolemia, deep anesthesia, vasovagal; (7) Prevention: gradual position change, compression stockings, adequate fluid loading, vasopressor pre-emptive, careful BP target at head level, cerebral oximetry, minimize hypotension; (8) POVL + stroke reports beach chair — important safety issue; (9) Modern: many advocate lateral decubitus alternative; cerebral oximetry monitoring; tight BP control

---

Beach chair: BP at brain level, Bezold-Jarisch reflex risk. Manage with position, fluid, vasopressor, atropine. NIRS helpful. Avoid hypotension. Lateral alternative.', NULL,
  'medium', 'neurology', 'review',
  'anesthesiology', 'clinical_decision', 'neurology', 'adult',
  'ASA Practice Advisory; SCA Beach Chair', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 28 ปี healthy elective shoulder arthroscopy in beach chair position
GA + interscalene block + LMA
30 min into surgery, sudden BP drop 110/70 → 60/30, HR 50, EtCO2 stable'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 60 ปี post-CABG ICU day 3 — sudden AFib with rapid response
HR 145, BP 100/60, no chest pain, mild dyspnea
On beta-blocker post-op', '[{"label":"A","text":"Ignore + observe"},{"label":"B","text":"Post-cardiac surgery AFib management"},{"label":"C","text":"Aggressive cardioversion always"},{"label":"D","text":"Stop all medications"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-cardiac surgery AFib management: (1) Common complication 20-40% post-cardiac surgery; peak day 2-3; (2) Rate control: - Beta-blocker (esmolol IV infusion or metoprolol 5 mg IV q5 min); - Calcium channel blocker (diltiazem 10-25 mg IV) if BB contraindicated; - Amiodarone bolus 150 mg + infusion (rate + rhythm); - Digoxin (slow onset, useful HF); (3) Rhythm control: - Hemodynamic instability — synchronized cardioversion 200J biphasic; - Stable — amiodarone (300 mg loading + 900 mg/24h); ibutilide alternative; - Cardiovert if < 48h onset (lower stroke risk); (4) Anticoagulation: - CHA2DS2-VASc score; - Anticoagulate if persistent > 48h (warfarin or DOAC); - Bridging if cardioversion + > 48h; - Balance with bleeding risk post-cardiac surgery; (5) Treat reversible causes: - Electrolytes (K, Mg) — K > 4, Mg > 2; - Hypoxia, acidosis; - Pain, anxiety; - Volume status; - Inflammation (corticosteroid evidence mixed); - Pulmonary embolism; - Pericardial effusion/tamponade; (6) Prevention: - Beta-blocker continuation; - Amiodarone prophylaxis (selected); - Magnesium; - Statin; - Minimize pump time + cross-clamp; - Atrial pacing; (7) Post-op care: - Echo if hemodynamic concern; - Continue rate/rhythm control 4-6 weeks; - Anticoagulation per stroke risk; (8) Modern: PREDICT-AF score; left atrial appendage occlusion at time of surgery (selected); thoracoscopic AF surgery

---

Post-cardiac surgery AFib: rate (BB, CCB, amio) ± rhythm control, anticoagulation per CHA2DS2-VASc, treat electrolytes/causes, prevention BB + amio. Common day 2-3.', NULL,
  'medium', 'cardiovascular', 'review',
  'anesthesiology', 'clinical_decision', 'cardiovascular', 'adult',
  'STS Guidelines; AHA/ACC AFib', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 60 ปี post-CABG ICU day 3 — sudden AFib with rapid response
HR 145, BP 100/60, no chest pain, mild dyspnea
On beta-blocker post-op'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 70 ปี — post-laparotomy day 1 ICU
RR 28 + accessory muscle use, SpO2 90% on 4L NC + bilateral basal crackles + decreased air entry
Fever 38.2°C, WBC 14k', '[{"label":"A","text":"Discharge ward"},{"label":"B","text":"Post-op pulmonary complications"},{"label":"C","text":"More opioid for breathing"},{"label":"D","text":"Bedrest no mobilization"},{"label":"E","text":"Ignore"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-op pulmonary complications: (1) DDx: atelectasis, pneumonia, pulmonary edema, ARDS, PE, aspiration, COPD exacerbation; (2) Atelectasis = most common (mild fever, basal findings, restrictive); treatment: - Incentive spirometry; - Mobilization; - Adequate pain control (multimodal allows deep breathing); - Bronchodilator if reactive airway; - PEEP/CPAP non-invasive; - Bronchoscopy if mucus plug; (3) Hospital-acquired pneumonia (HAP) — fever > 48h post-admission, infiltrate, leukocytosis, sputum; - Empiric antibiotics covering MRSA + Pseudomonas (vancomycin + cefepime/pip-tazo or carbapenem); - De-escalate per culture; (4) Aspiration pneumonia — risk factors: altered mental status, dysphagia, NG tube; treatment: antibiotic + supportive; (5) Acute respiratory failure: - O2 therapy (NC → mask → HFNC → NIV → invasive); - NIV (BiPAP) for COPD, CHF, hypercapnic respiratory failure; - HFNC (Optiflow) for hypoxemic respiratory failure (FLORALI); - Intubation criteria: severe hypoxia, fatigue, altered mental status, hemodynamic instability; (6) Lung-protective ventilation if intubated (TV 6 mL/kg IBW); (7) Prevention pulmonary complications: - Pre-op smoking cessation; - Multimodal opioid-sparing analgesia (allow deep breathing); - Regional anesthesia (thoracic epidural for thoracoabdominal); - Lung-protective intra-op ventilation; - Early mobilization; - Incentive spirometry training; - Chest PT; (8) Risk scores — ARISCAT for pulmonary complications; (9) ICU evaluation for refractory cases

---

Post-op pulmonary: atelectasis most common; DDx pneumonia, edema, PE. Treatment: O2, IS, mobilize, NIV/HFNC, pain control. Prevention: smoking cessation, regional, multimodal, lung-protective ventilation. ARISCAT.', NULL,
  'easy', 'respiratory', 'review',
  'anesthesiology', 'clinical_decision', 'respiratory', 'adult',
  'ASA Pulmonary Practice Advisory; ATS Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 70 ปี — post-laparotomy day 1 ICU
RR 28 + accessory muscle use, SpO2 90% on 4L NC + bilateral basal crackles + decreased air entry
Fever 38.2°C, WBC 14k'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 35 ปี — orthopedic case left femur ORIF
During reaming + cementation: sudden BP drop 130/80 → 60/35, HR rise 80 → 130, SpO2 drop 99 → 78%, EtCO2 drop 40 → 22
No airway issues, no anaphylaxis features', '[{"label":"A","text":"Continue cementation rapidly"},{"label":"B","text":"Bone Cement / Fat Embolism Syndrome"},{"label":"C","text":"Ignore"},{"label":"D","text":"More volatile"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bone Cement / Fat Embolism Syndrome: (1) Bone Cement Implantation Syndrome (BCIS) — during cementation + intramedullary pressurization → embolic + vasoactive release: hypoxia, hypotension, arrhythmia, cardiac arrest; risk: hip arthroplasty, vertebral surgery, intramedullary nailing; (2) Fat Embolism Syndrome — long bone fracture or instrumentation: 24-72h post-injury typically; triad: respiratory (hypoxia), neurologic (confusion), cutaneous (petechiae axilla/conjunctiva); diagnosis Gurd criteria; (3) Pulmonary embolism — thromboembolic; risk factor surgery + trauma; (4) Air embolism — sitting position, neuro/vascular surgery; (5) Common findings — sudden hypoxia + hypotension + EtCO2 drop (loss of pulmonary blood flow → V/Q mismatch); (6) Management: - 100% O2; - Stop trigger (pause cementation if not committed); - Vasopressor (norepinephrine, epinephrine); - Volume resuscitation; - Inotropic support; - TEE if available — see right heart strain, emboli, RV dysfunction; - Pulmonary vasodilator (inhaled NO) for severe RV failure; - ECMO for refractory; (7) Specific BCIS: - Pressurize femoral canal carefully; - Vacuum cement mixing; - Vent femoral canal during cementation; - Avoid in compromised cardiopulmonary patients; - Awareness in elderly hip fracture; (8) Differentiation: timing + procedure stage, clinical features; (9) Post-event: monitoring, ICU, repeat CXR/CT/echo, anticoagulation if PE confirmed

---

BCIS / fat embolism: sudden hypoxia + hypotension + EtCO2 drop during cementation/long-bone instrumentation. 100% O2, vasopressor, TEE if available, ECMO refractory. Prevention via cementation technique.', NULL,
  'medium', 'trauma', 'review',
  'anesthesiology', 'clinical_decision', 'trauma', 'adult',
  'AAGBI BCIS Guidelines; ASA Practice', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 35 ปี — orthopedic case left femur ORIF
During reaming + cementation: sudden BP drop 130/80 → 60/35, HR rise 80 → 130, SpO2 drop 99 → 78%, EtCO2 drop 40 → 22
No airway issues, no anaphylaxis features'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Basic science: pharmacology of vasopressors + inotropes', '[{"label":"A","text":"All vasopressors same"},{"label":"B","text":"Vasopressors + inotropes"},{"label":"C","text":"Dopamine first-line all"},{"label":"D","text":"Avoid all"},{"label":"E","text":"Use only orally"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Vasopressors + inotropes: (1) Norepinephrine — alpha-1 + beta-1; first-line septic shock (Surviving Sepsis); 0.01-1 mcg/kg/min; preferred over dopamine; (2) Epinephrine — alpha + beta; anaphylaxis first-line; cardiac arrest; refractory shock; 0.01-0.5 mcg/kg/min; (3) Phenylephrine — pure alpha-1; bolus 50-200 mcg; infusion; OB anesthesia (no neonatal acidosis); spinal hypotension; (4) Vasopressin — V1 receptor (non-catecholamine); 0.03-0.04 U/min adjunct in refractory shock; cardiac arrest 40U IV (no longer ACLS); useful in acidemic + refractory norepinephrine; (5) Dopamine — dose-dependent (low: dopaminergic — disproven for renal protection; mid: beta; high: alpha); largely replaced; (6) Dobutamine — beta-1 selective inotrope; cardiogenic shock; 2-20 mcg/kg/min; tachycardia + arrhythmia; (7) Milrinone — phosphodiesterase-3 inhibitor; inotrope + vasodilator; HF, pulmonary HTN, post-CPB; 0.25-0.75 mcg/kg/min; hypotension; (8) Levosimendan — Ca sensitizer; HF; not FDA approved; (9) Methylene blue — vasoplegia (post-CPB, sepsis refractory, anaphylaxis); 1-2 mg/kg; NOS inhibitor; (10) Angiotensin II (Giapreza) — refractory shock; ATHOS-3; (11) Selection: - Septic shock: norepi → vasopressin → epi/steroid; - Cardiogenic shock: norepi + dobutamine/milrinone; - Anaphylaxis: epinephrine; - OB: phenylephrine; - Cardiac arrest: epinephrine; (12) Considerations: receptor profile, side effects (arrhythmia, peripheral ischemia, hyperglycemia), tachyphylaxis, route (central vs peripheral)

---

Vasopressors: norepi (septic, first-line), epi (anaphylaxis, arrest), phenylephrine (OB), vasopressin (refractory adjunct), dobutamine/milrinone (inotrope), dopamine (largely replaced), methylene blue (vasoplegia). Receptor-based selection.', NULL,
  'easy', 'cardiovascular', 'review',
  'anesthesiology', 'basic_science', 'cardiovascular', 'adult',
  'Miller''s; Surviving Sepsis 2021', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Basic science: pharmacology of vasopressors + inotropes'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Basic science: hemostasis + transfusion therapy
Patient bleeding intraop, TEG shows decreased MA + prolonged R time', '[{"label":"A","text":"Transfuse PRBC only"},{"label":"B","text":"TEG/ROTEM interpretation + transfusion"},{"label":"C","text":"Skip TEG"},{"label":"D","text":"Routine FFP for all"},{"label":"E","text":"Refuse transfusion"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** TEG/ROTEM interpretation + transfusion: (1) TEG parameters: - R time (reaction) — time to clot initiation; prolonged = factor deficiency → FFP; - K time + Alpha angle — clot formation rate; abnormal = fibrinogen → cryoprecipitate or fibrinogen concentrate; - MA (Maximum Amplitude) — clot strength = platelets + fibrin; decreased = platelet dysfunction → platelet transfusion; - LY30 — fibrinolysis at 30 min; > 3% = hyperfibrinolysis → TXA; (2) ROTEM equivalents: - EXTEM (extrinsic), INTEM (intrinsic), FIBTEM (fibrinogen contribution), APTEM (TXA effect), HEPTEM (heparin effect); (3) Component therapy: - PRBC for anemia (target Hb > 7 in stable; > 9-10 in active bleeding or specific conditions; restrictive better — TRICC); - FFP for factor deficiency (15-20 mL/kg); INR > 1.5-1.7 active bleeding or pre-procedure; - Platelets for < 50k bleeding, < 100k CNS/eye surgery; - Cryoprecipitate (factor VIII, fibrinogen, vWF, factor XIII) for fibrinogen < 1.5-2 g/L; - Fibrinogen concentrate alternative; - Prothrombin complex concentrate (PCC) — warfarin reversal, factor deficiency; - Recombinant factor VIIa (NovoSeven) — refractory; expensive; (4) Massive transfusion 1:1:1 (PRC:FFP:Plt) per PROPPR; (5) Citrate toxicity — chelates calcium; replace 1g CaCl2 q4 units; (6) Hyperkalemia from old PRBC; (7) TRALI (transfusion-related acute lung injury) — within 6h, pulmonary edema, hypoxia; (8) TACO (transfusion-associated circulatory overload); (9) Patient Blood Management — minimize transfusion universally, point-of-care testing

---

TEG: R (factor → FFP), K/alpha (fibrinogen → cryo), MA (platelet → plt), LY30 (TXA). Component therapy guided. Massive 1:1:1. Ca replacement. TRALI/TACO awareness. PBM modern.', NULL,
  'medium', 'hematology', 'review',
  'anesthesiology', 'basic_science', 'hematology', 'adult',
  'AABB Guidelines; ASA Practice Advisory Blood', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Basic science: hemostasis + transfusion therapy
Patient bleeding intraop, TEG shows decreased MA + prolonged R time'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Basic science: pharmacology of antiemetics + receptors', '[{"label":"A","text":"Single agent only"},{"label":"B","text":"Antiemetic pharmacology"},{"label":"C","text":"All ineffective"},{"label":"D","text":"Avoid all"},{"label":"E","text":"Sedate heavily"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Antiemetic pharmacology: (1) Receptor-based — multiple receptors involved in nausea (D2, 5-HT3, NK1, H1, M1, GABA, CB1): (2) 5-HT3 antagonists — ondansetron (4-8 mg IV, dosed once for PONV), granisetron, palonosetron (long-acting), tropisetron; QTc prolongation; common first-line; (3) D2 antagonists — droperidol (0.625-1.25 mg IV, QTc warning), haloperidol (1-2 mg IV, off-label), metoclopramide (10 mg IV, EPS); prochlorperazine; (4) NK1 antagonists — aprepitant (oral) + fosaprepitant (IV); long-acting (48h); good for major surgery + chemo; (5) Corticosteroids — dexamethasone (4-8 mg IV pre-induction); mechanism unclear; effective; antiemetic + antiinflammatory + analgesic + airway swelling reduction; concerns hyperglycemia + infection (minimal at single dose); (6) Anticholinergic — scopolamine patch (apply > 2h pre-op, lasts 72h); avoid in elderly (delirium), glaucoma; (7) Antihistamine — diphenhydramine 25-50 mg; promethazine 12.5-25 mg; sedation; (8) Phenothiazine — promethazine; sedation; (9) Cannabinoid — nabilone, dronabinol; chemo; (10) Acupressure P6 (Neiguan); (11) Strategy: - Apfel risk score; - Multimodal prophylaxis (different mechanisms); - Rescue with different class than prophylaxis; (12) PONV groups — pediatric, OB, obese, opioid, certain surgeries; (13) Recent: olanzapine, mirtazapine; (14) Modern: enhanced recovery routine multimodal PONV prophylaxis

---

Antiemetic receptors: 5-HT3 (ondansetron), D2 (droperidol, metoclopramide), NK1 (aprepitant), steroid (dex), anticholinergic (scopolamine), antihistamine. Multimodal prophylaxis Apfel-stratified. Different class rescue.', NULL,
  'easy', 'gi', 'review',
  'anesthesiology', 'basic_science', 'gi', 'adult',
  'SAMBA PONV Consensus 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Basic science: pharmacology of antiemetics + receptors'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Basic science: monitoring standards + standards of care', '[{"label":"A","text":"Skip monitoring"},{"label":"B","text":"ASA Standards for Basic Anesthetic Monitoring"},{"label":"C","text":"BP every hour"},{"label":"D","text":"No documentation"},{"label":"E","text":"EtCO2 optional"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** ASA Standards for Basic Anesthetic Monitoring: (1) Qualified anesthesia personnel present continuously; (2) Oxygenation: - Inspired gas O2 analyzer with low alarm; - Pulse oximetry continuous; (3) Ventilation: - Capnography (EtCO2) for all anesthetized patients with airway device; mandatory for moderate/deep sedation; - Quantitative monitoring of ventilation (TV, RR, peak airway pressure); - Disconnect alarm; (4) Circulation: - ECG continuous; - BP + HR every 5 minutes minimum (more frequent if unstable); - Circulatory function continuous (palpation, auscultation, art line, plethysmograph); (5) Body temperature: - Continuous when clinically significant changes anticipated; (6) Neuromuscular monitoring: - Quantitative TOF when NMB used (recent update — ASA 2023); (7) Documentation: - Complete anesthetic record; - Vital signs every 5 min minimum; - Critical events; (8) Standards apply for general anesthesia, regional anesthesia, MAC; (9) Additional monitoring as indicated: arterial line, CVL, PA catheter, TEE, BIS, cerebral oximetry, urine output; (10) Equipment: - Anesthesia machine check before use; - Backup equipment available; (11) Recovery: - Continued monitoring + qualified personnel in PACU; - Discharge criteria; (12) Crew Resource Management + safety culture

---

ASA Standards: continuous qualified personnel, O2 analyzer + pulse ox, capnography + ventilation, ECG + BP q5min, temperature, quantitative TOF (modern). PACU monitoring. Documentation. Equipment check.', NULL,
  'easy', 'procedures', 'review',
  'anesthesiology', 'basic_science', 'procedures', 'adult',
  'ASA Standards for Basic Anesthetic Monitoring 2020/2023', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Basic science: monitoring standards + standards of care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'EMS/Management: medication errors in anesthesia + prevention', '[{"label":"A","text":"Skip verification"},{"label":"B","text":"Medication errors in anesthesia"},{"label":"C","text":"Use unlabeled syringe"},{"label":"D","text":"Ignore errors"},{"label":"E","text":"Hide errors"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Medication errors in anesthesia: (1) Common errors: - Syringe swap (wrong drug); - Wrong dose (calculation, pump programming); - Wrong route; - Wrong patient; - Drug omission; - Look-alike sound-alike (LASA) — bupivacaine vs lidocaine, midazolam vs metoclopramide; (2) High-alert medications — concentrated electrolytes (KCl), insulin, anticoagulants, opioids, neuromuscular blockers; (3) Risk factors — fatigue, distraction, urgency, look-alike, similar containers; (4) Prevention strategies: - Standardized drug concentrations (institutional + national); - Pre-printed syringe labels (color-coded by class — ASTM); - Drug-specific safety features; - Smart pumps (drug library, dose limits); - Barcode medication administration; - Read-back verification with another provider; - Avoid concentrate at bedside; - Tall man lettering; - Storage separation; - Time-out for medication; (5) Specific examples: - Use vasopressin from labeled syringe not unlabeled bolus; - Reverse — confirm sugammadex vs neostigmine; - Heparin flush vs bolus; - Inadvertent epidural IV; (6) Reporting + analysis: - Anonymous reporting culture; - Root cause analysis; - Quality improvement; - Anesthesia Quality Institute (AQI); (7) Education + simulation; (8) Modern: AI-assisted decision support, smart pumps, EHR integration, near-miss reporting, simulation training

---

Med errors: syringe swap, dose, route, LASA. Prevention: standardized concentration, labels, smart pumps, barcoded, read-back, separation. Just culture reporting. High-alert meds.', NULL,
  'easy', 'procedures', 'review',
  'anesthesiology', 'ems_mgmt', 'procedures', 'adult',
  'ASA Practice Advisory; APSF Medication Safety', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'EMS/Management: medication errors in anesthesia + prevention'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'EMS/Management: handoff communication in anesthesia', '[{"label":"A","text":"Skip handoff"},{"label":"B","text":"Anesthesia handoff communication"},{"label":"C","text":"Hide info"},{"label":"D","text":"One-way only"},{"label":"E","text":"No documentation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Anesthesia handoff communication: (1) Common handoffs: - OR to PACU; - PACU to ward; - OR to ICU; - Anesthesia provider change intra-op; - Shift change; (2) Risks of poor handoff: - Information loss; - Error; - Adverse events; - Delay care; - Major contributor sentinel events (Joint Commission); (3) Structured handoff tools: - SBAR (Situation, Background, Assessment, Recommendation); - I-PASS (Illness severity, Patient summary, Action list, Situation awareness, Synthesis by receiver); - PACU handoff checklist; (4) Essential elements: - Patient identification; - Surgical procedure + position; - Anesthetic technique + complications; - Hemodynamic intra-op course; - Fluid + transfusion; - Pain management + medications given; - Anticipated post-op concerns; - Disposition + special needs; - Lines + drains + tubes; - Allergies; - DNR status; - Family communication needs; (5) Quality elements: - Quiet environment minimizing distractions; - Read-back confirmation; - Opportunity for questions; - Visual aids (anesthesia record); - Both providers physically present; (6) ICU handoff specific: - Higher complexity; - Multidisciplinary inclusion; - Ventilator settings + plan; - Sedation plan; - Goals of care; - Family communication; (7) Intra-op handoff: - Avoid if possible (continuity); - If needed: thorough, in OR, brief surgery; - Document handoff; (8) Quality improvement: - Audit; - Standardized templates; - Training; - Simulation; (9) Cognitive aids; (10) Modern: EHR templates, digital tools, structured curriculum

---

Handoff: SBAR/I-PASS structured tools. Essential elements: patient, procedure, course, fluids, pain, plan. Quiet environment + read-back. Sentinel event contributor. ICU + intra-op specific. Modern: EHR templates.', NULL,
  'easy', 'procedures', 'review',
  'anesthesiology', 'ems_mgmt', 'procedures', 'adult',
  'Joint Commission; APSF Handoff', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'EMS/Management: handoff communication in anesthesia'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Integrative: simulation training + crisis resource management', '[{"label":"A","text":"Skip simulation"},{"label":"B","text":"Simulation + Crisis Resource Management (CRM)"},{"label":"C","text":"Real patients only"},{"label":"D","text":"Avoid teamwork training"},{"label":"E","text":"No debriefing"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Simulation + Crisis Resource Management (CRM): (1) Simulation in anesthesia education: - Mannequin-based (high-fidelity simulator); - Standardized patients; - Procedural trainers; - Virtual reality; - Screen-based; (2) Benefits: - Practice rare events (MH, anaphylaxis, LAST); - Skills without patient risk; - Team training; - Communication; - Debriefing critical for learning; (3) CRM principles (adapted from aviation): - Situational awareness; - Decision-making; - Communication (closed-loop); - Teamwork; - Leadership + followership; - Resource utilization (people, equipment, time); - Workload distribution; - Re-evaluation + adaptation; - Calling for help early; (4) Effective debriefing: - Safe environment; - Reflective practice; - Plus/delta or 3D model; - Trained debriefer; - Behavior-based feedback; (5) Crisis manuals + cognitive aids: - Stanford Emergency Manual; - APSF resources; - LAST checklist (ASRA); - MH protocol (MHAUS); - Bedside availability; (6) Application: - MOC/CMP requirements; - Department training; - Just-in-time refresher; - Inter-professional team training; (7) Specific scenarios for training: - Failed intubation/CICO; - MH; - Anaphylaxis; - LAST; - Massive transfusion; - Pediatric emergencies; - Cardiac arrest in OR; (8) Quality improvement framework; (9) Research outcomes — improved performance, retention, team dynamics; (10) Modern: in-situ simulation, virtual reality, AI-enhanced training

---

Simulation + CRM: practice rare events safely, team training, communication, cognitive aids. Effective debriefing key. Stanford manual + MH/LAST checklists. MOC requirements. Modern: VR + in-situ.', NULL,
  'easy', 'procedures', 'review',
  'anesthesiology', 'integrative', 'procedures', 'adult',
  'Society for Simulation in Healthcare; ASA Education', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Integrative: simulation training + crisis resource management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Integrative: wellness + burnout in anesthesia practitioners', '[{"label":"A","text":"Ignore burnout"},{"label":"B","text":"Anesthesiologist wellness + burnout"},{"label":"C","text":"Work more hours"},{"label":"D","text":"Punish substance use"},{"label":"E","text":"Hide problems"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Anesthesiologist wellness + burnout: (1) Burnout prevalence — 40-50%+ in anesthesia; higher in residents, trainees; (2) Components (Maslach): - Emotional exhaustion; - Depersonalization/cynicism; - Reduced personal accomplishment; (3) Consequences: - Personal — depression, substance abuse, suicide (anesthesiologists higher risk vs general physician), divorce, physical illness; - Professional — medical errors, decreased patient satisfaction, career change, early retirement; - Workplace — turnover, recruitment difficulty; (4) Substance use disorder — anesthesia higher risk: access to drugs (fentanyl, propofol, NMB), stress, denial; mortality high; treatment + monitored re-entry possible; (5) Risk factors burnout: - Workload + hours; - Loss of autonomy; - EHR burden; - Difficult cases + outcomes; - Family/life conflict; - Personality (perfectionism); - Trainee status; (6) Interventions: - Individual: self-care, exercise, sleep, nutrition, mindfulness, meditation, hobbies, relationships, professional help; - Organizational: appropriate staffing, support, mentorship, EHR optimization, mental health resources, peer support, leadership culture, wellness programs; (7) Second victim phenomenon — provider distress after adverse events; need support; (8) Suicide prevention — confidential help (PHP, Lifeline 988); reduce stigma; (9) Substance use program: Physician Health Program (PHP); confidential evaluation + monitoring; (10) Joy in work + meaning — engagement vs burnout opposite; (11) Modern: ASA Committee on Physician Wellness; APSF clinician well-being; healthcare systems addressing burnout; (12) Confidential resources: 24/7 helplines, mental health, EAP

---

Burnout 40-50% anesthesia. Components: exhaustion, depersonalization, reduced accomplishment. Substance use higher risk. Interventions: individual + organizational. Second victim support. PHP confidential help. Joy in work.', NULL,
  'easy', 'psych_behavior', 'review',
  'anesthesiology', 'integrative', 'psych_behavior', 'adult',
  'ASA Physician Wellness; AMA Burnout', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Integrative: wellness + burnout in anesthesia practitioners'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 30 ปี healthy GA + thyroidectomy
During emergence + extubation, sudden inspiratory stridor + difficulty breathing, hoarse voice, no neck swelling
Differential bilateral recurrent laryngeal nerve injury vs laryngospasm vs hematoma', '[{"label":"A","text":"Discharge"},{"label":"B","text":"Post-thyroidectomy airway complications"},{"label":"C","text":"Wait silently"},{"label":"D","text":"Refuse intubation"},{"label":"E","text":"Sedate heavily"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-thyroidectomy airway complications: (1) DDx: - Bilateral RLN injury (rare, devastating) — adducted vocal cords; - Unilateral RLN injury (hoarseness, weak voice); - Laryngospasm (recurrent stridor); - Hematoma compressing airway (covered separately); - Laryngeal edema; - Hypocalcemia (rare immediate, days later); - Tracheomalacia (after large goiter removal); (2) Bilateral RLN injury — both vocal cords paralyzed in median (adducted) position → severe obstruction + stridor; emergent re-intubation + tracheostomy; (3) Unilateral RLN — hoarseness, aspiration risk, no airway emergency; treatment: voice therapy, augmentation; (4) Recognition: - Laryngoscopy/fiberoptic exam to identify; - Differentiate paralysis (cord position fixed) from laryngospasm (treatable); (5) Immediate management: - 100% O2 + jaw thrust + CPAP; - Re-intubation if obstruction worsening; - May need tracheostomy if persistent bilateral RLN; - Steroids (controversial); - Heliox temporary; (6) Prevention: - Intraoperative nerve monitoring (IONM) for RLN — standard in many centers; reduces injury rate; - Careful dissection technique; - Identify nerves intra-op; (7) Hypocalcemia from parathyroid injury — days later, tetany, hyperreflexia, Chvostek/Trousseau, prolonged QTc, laryngospasm; check Ca + PTH; treat with Ca gluconate + calcitriol; (8) Tracheomalacia — large goiter, weakened tracheal rings; may require tracheostomy; recognize at extubation; (9) Multidisciplinary: anesthesia + ENT + endocrine surgery; (10) Post-op: bilateral RLN paralysis may improve over weeks-months; consider extubation trial in PACU then re-evaluate

---

Post-thyroidectomy airway: bilateral RLN (emergent — re-intubate/trach), unilateral (hoarseness), laryngospasm, hematoma, hypocalcemia, tracheomalacia. IONM prevention. Multidisciplinary.', NULL,
  'medium', 'respiratory', 'review',
  'anesthesiology', 'clinical_decision', 'respiratory', 'adult',
  'ASA Difficult Airway; AAES Thyroidectomy', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 30 ปี healthy GA + thyroidectomy
During emergence + extubation, sudden inspiratory stridor + difficulty breathing, hoarse voice, no neck swelling
Differential bilateral recurrent laryngeal nerve injury vs laryngospasm vs hematoma'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 50 ปี — elective major liver resection
Child-Pugh A, MELD 8, normal coagulation
Plan: low CVP technique, GA', '[{"label":"A","text":"Aggressive fluid"},{"label":"B","text":"Liver resection anesthesia"},{"label":"C","text":"Avoid CVL"},{"label":"D","text":"Long-acting opioid"},{"label":"E","text":"High volatile"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Liver resection anesthesia: (1) Goals: - Minimize blood loss (often massive); - Maintain hepatic perfusion; - Avoid hepatotoxicity; - Pain control; (2) Low CVP technique — keep CVP < 5 cmH2O during dissection: - Reduces hepatic venous pressure + bleeding from cut surface; - Achieved by: restrict fluid, position (Trendelenburg avoid; head-up), low TV, diuretic, nitroglycerin, vasopressor for BP; (3) Risks low CVP: - Air embolism (open hepatic veins + low pressure); - Hypoperfusion + AKI; - Hypotension; - Cerebral hypoperfusion; (4) Pringle maneuver — clamp portal triad (hepatic artery + portal vein); reduces inflow bleeding; ischemia-reperfusion risk; usually < 60-90 min total; (5) Drug choices: - Avoid hepatotoxic; - Cisatracurium (Hofmann elimination, organ-independent); - Remifentanil (esterase elimination); - Propofol OK; sevoflurane OK; - Avoid halothane (rarely available); - Caution opioid + benzodiazepine (altered metabolism); (6) Cell saver + autologous transfusion; (7) Coagulation: - Hepatic disease + extensive resection — coagulopathy expected; - TEG-guided; - TXA controversial in liver surgery (theoretical thrombosis); (8) Monitoring: - Arterial line; - CVL (low CVP measurement, vasopressor); - Cardiac output (esophageal Doppler, pulse contour); - Urine output; - Glucose; - Lactate; (9) Pain — thoracic epidural (controversial in liver — coagulopathy risk if liver dysfunction); alternative: ESP block, intrathecal morphine, multimodal; (10) Post-op: - ICU/HDU; - Liver function monitoring; - Coagulation; - Pain; - Bile leak; - PV thrombosis; (11) ERAS liver surgery: minimize fluid, regional, mobilization

---

Liver resection: low CVP < 5 (reduces bleeding), Pringle maneuver, cisatracurium, cell saver, TEG-guided, monitor cardiac output. Thoracic epidural debate. Post-op ICU. ERAS protocol.', NULL,
  'medium', 'gi', 'review',
  'anesthesiology', 'clinical_decision', 'gi', 'adult',
  'ERAS Liver Surgery; SCA Practice', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 50 ปี — elective major liver resection
Child-Pugh A, MELD 8, normal coagulation
Plan: low CVP technique, GA'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 35 ปี G1P0 GA 39 wk active labor, epidural in place + bolused, contractions strong
Fetal HR 90 sustained × 5 min + no recovery, late decelerations preceding
Category III tracing', '[{"label":"A","text":"Wait + observe"},{"label":"B","text":"Category III fetal tracing"},{"label":"C","text":"Heavy fluid only"},{"label":"D","text":"Sedation heavily"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Category III fetal tracing — non-reassuring fetal status: (1) Recognition — Category III (NICHD): absent baseline variability + recurrent late/variable decelerations OR bradycardia OR sinusoidal pattern; (2) Immediate intrauterine resuscitation: - Reposition mother (left lateral, knee-chest, side-to-side); - 100% O2 supplemental; - IV fluid bolus 500-1000 mL; - Stop oxytocin (if running); - Vasopressor if hypotensive (phenylephrine, ephedrine); - Vaginal exam (cord prolapse, dilation); - Tocolysis (terbutaline 0.25 mg SC or IV) for tachysystole; (3) If non-recovery — DELIVERY: - Operative vaginal delivery if fully dilated + station appropriate; - Emergency Cesarean section if not; - Decision-to-delivery interval < 30 min (some say < 15 for prolonged bradycardia + no recovery); (4) Anesthesia for emergent C-section: - Epidural top-up if functioning: 2% lidocaine + epinephrine + bicarbonate 15-20 mL (fastest reliable); aim T4 dermatome; - Spinal if no epidural + time + no severe hypovolemia/coagulopathy; - GA if immediate (failed epidural, hemodynamic instability, severe coagulopathy); GA technique: RSI + cricoid + video laryngoscopy + difficult airway prep; (5) Decision factors: - Time to delivery; - Urgency (Category 1 immediate / 2 maternal-fetal compromise / 3 stable); - Anesthesia type already in place; - Patient stability; - Difficult airway; (6) Hemodynamic: avoid hypotension (fetal hypoxia); fluid + phenylephrine; (7) Neonatal team ready; (8) Post-delivery: maternal monitoring, hemorrhage risk, NICU coordination; (9) Multidisciplinary: anesthesia + OB + nursing + neonatology

---

Category III tracing: intrauterine resuscitation (position, O2, fluid, stop oxytocin, vasopressor, tocolysis). Delivery if no recovery. Epidural top-up (lido + epi + bicarb) > spinal > GA. Decision-to-delivery < 30 min.', NULL,
  'medium', 'obgyn', 'review',
  'anesthesiology', 'clinical_decision', 'obgyn', 'adult',
  'SOAP Practice Guidelines; ACOG', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 35 ปี G1P0 GA 39 wk active labor, epidural in place + bolused, contractions strong
Fetal HR 90 sustained × 5 min + no recovery, late decelerations preceding
Category III tracing'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็ก 5 ปี — moderate sedation for laceration repair in ED
Using propofol + ketamine combination (''ketofol'')
Monitored', '[{"label":"A","text":"No monitoring"},{"label":"B","text":"Procedural sedation pediatric"},{"label":"C","text":"Skip NPO"},{"label":"D","text":"Adult doses always"},{"label":"E","text":"Discharge without recovery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Procedural sedation pediatric: (1) Continuum: minimal (anxiolysis) → moderate (purposeful response) → deep (purposeful with repeated stimulation) → GA; (2) Sedationist must be capable of rescuing deeper level than intended; (3) Pre-procedure: - History (allergies, NPO, comorbidities, prior sedation); - Physical (airway assessment); - ASA classification; - Informed consent; - Equipment: O2, suction, BVM, airway, IV access, reversal agents, monitor; - NPO guidelines (clear 2h, breast milk 4h, formula 6h, solid 8h — emergency exceptions); (4) Monitoring: - Continuous SpO2, ECG, BP intermittent, capnography (mandatory moderate/deep per ASA); - Trained personnel; (5) Drug options: - Propofol — short, smooth; respiratory depression; - Ketamine 1-2 mg/kg IV (or 4 mg/kg IM) — dissociative, analgesic, preserved airway + breathing, sympathomimetic; emergence reactions; - Ketofol (propofol + ketamine) — additive benefits, opposing side effects; - Midazolam — anxiolysis, amnesia; - Fentanyl — analgesia; - Dexmedetomidine — sedation without respiratory depression; - Nitrous oxide — quick onset/offset, anxiolysis + analgesia; - Etomidate — CV stable; (6) Risks: - Apnea + hypoventilation; - Aspiration; - Hypotension; - Allergic; - Emergence; - Failed sedation; (7) Recovery — meets discharge criteria (same as ambulatory anesthesia); (8) Documentation; (9) Pediatric specific: - Weight-based dosing; - Atropine pre-treatment (bradycardia risk in young); - Family involvement; - Distraction techniques + child life; - Topical anesthesia for IV; (10) Complications managed: airway opening, BVM, intubation, reversal (naloxone, flumazenil), CPR

---

Pediatric procedural sedation: depth continuum, capnography mandatory, NPO with emergency exceptions, drugs (propofol, ketamine, ketofol, dex, N2O), weight-based dosing, monitoring + rescue capability.', NULL,
  'easy', 'procedures', 'review',
  'anesthesiology', 'clinical_decision', 'procedures', 'peds',
  'ASA Sedation Guidelines; AAP Procedural Sedation', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'เด็ก 5 ปี — moderate sedation for laceration repair in ED
Using propofol + ketamine combination (''ketofol'')
Monitored'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Basic science: pharmacology of TIVA (Total IV Anesthesia)
Using propofol + remifentanil TCI', '[{"label":"A","text":"No monitoring"},{"label":"B","text":"Total Intravenous Anesthesia (TIVA)"},{"label":"C","text":"Stop pumps"},{"label":"D","text":"Avoid all TIVA"},{"label":"E","text":"Skip BIS"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Total Intravenous Anesthesia (TIVA): (1) Components — IV agents only (no volatile); typically propofol + opioid (remifentanil most common); (2) Indications: - MEP/SSEP monitoring; - Operating room without volatile; - Patient transport; - Avoid PONV (propofol antiemetic); - Awake craniotomy; - Avoid environmental impact (volatile potent greenhouse gas); - Patient preference; - Risk MH; (3) Target-controlled infusion (TCI): - Pharmacokinetic model (Marsh, Schnider for propofol; Minto for remifentanil); - Target plasma or effect-site concentration; - System adjusts infusion rate automatically; - Allows steady predictable levels; (4) Manual infusion alternative — 10-8-6 rule for propofol (10 mg/kg/hr × 10 min, 8 × 10 min, 6 continuous); requires monitoring; (5) Advantages: - Smooth + predictable; - Less PONV; - No environmental concern; - Avoids volatile interactions (MH, neuromonitoring); - Good for transports; (6) Disadvantages: - Awareness risk if delivery failure (vapor analyzer not applicable); - Need IV access reliable; - Cost (propofol); - Requires pump expertise; - Variable pharmacokinetics (obesity, elderly); (7) Monitoring: - BIS/processed EEG strongly recommended (awareness); - Standard ASA monitoring; (8) Specific considerations: - Awareness — confirm IV running, no leak, pump function; - Propofol infusion syndrome (high dose long duration): rhabdo, acidosis, cardiac failure, hyperlipidemia, hepatomegaly; avoid > 4 mg/kg/hr > 48h; - Remifentanil — context-insensitive; bridge analgesia before stop; opioid-induced hyperalgesia; (9) Pediatric TIVA — TCI models pediatric; (10) Modern: TIVA expanding, environmental concerns drive change

---

TIVA: propofol + remifentanil (typically) ± TCI. Indications: MEP/SSEP, no volatile, PONV avoidance, environmental. Advantages: smooth, less PONV. Risks: awareness, PRIS, hyperalgesia. BIS strongly recommended.', NULL,
  'medium', 'procedures', 'review',
  'anesthesiology', 'basic_science', 'procedures', 'adult',
  'Miller''s; Anesthesia & Analgesia Reviews', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Basic science: pharmacology of TIVA (Total IV Anesthesia)
Using propofol + remifentanil TCI'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Basic science: physics of anesthesia equipment + machine check', '[{"label":"A","text":"Skip checks"},{"label":"B","text":"Anesthesia machine + physics"},{"label":"C","text":"Use without setup"},{"label":"D","text":"Ignore alarms"},{"label":"E","text":"Disable safety"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Anesthesia machine + physics: (1) Components: - Pipeline + cylinder gas supply (O2, N2O, air); - Pressure regulators (high pressure → working); - Flow meters (variable orifice rotameters); - Vaporizers (variable bypass agent-specific); - Common gas outlet; - Circle breathing system; - Ventilator; - Scavenging system; - Monitors; (2) Safety features: - Pin index safety system (PISS) for cylinders; - Diameter index safety system (DISS) for pipelines; - O2 ratio controller (prevents hypoxic mixture, fail-safe); - Low O2 alarm; - Vaporizer interlock; - Hypoxic guard; - Backup O2 cylinder; (3) Vaporizers: - Variable bypass (splitting ratio determines % output); - Agent-specific (each calibrated); - Tec 6 desflurane (heated); - Temperature compensation; (4) Circle system advantages: rebreathing (CO2 absorbed) — saves volatile + heat + moisture; (5) CO2 absorber — soda lime / Baralyme: - Reacts with CO2 → CaCO3; - Color indicator (ethyl violet); - Desiccated absorber + sevoflurane = compound A (nephrotoxicity concern); + desflurane = CO (concern); modern absorbers reduce risk; (6) Daily machine check (FDA pre-use checkout): - Verify backup O2; - Check anesthesia gas suction; - Inspect circuit; - Test high + low pressure leak; - Verify gas flows; - Check vaporizer; - Check ventilator + ICU monitor; - Suction; - Check scavenging; - Final position safe; (7) Common faults: - Disconnect, kink, leak; - Vaporizer empty/tipped; - Pop-off valve closed; - Exhausted CO2 absorber (Phase I rebreathing); - Pipeline contamination (rare devastating); (8) Modern: integrated machine + monitor; software-guided checks

---

Anesthesia machine: gas supply + safety features (PISS, DISS, O2 ratio), vaporizers (agent-specific), circle system + CO2 absorber, ventilator. Daily pre-use check FDA mandatory. Common faults: leak, kink, exhausted absorber.', NULL,
  'easy', 'procedures', 'review',
  'anesthesiology', 'basic_science', 'procedures', 'adult',
  'FDA Anesthesia Machine Checkout; Miller''s', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Basic science: physics of anesthesia equipment + machine check'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Basic science: physiology of fluid + electrolytes
Question on perioperative fluid management', '[{"label":"A","text":"Maximum crystalloid"},{"label":"B","text":"Perioperative fluid management"},{"label":"C","text":"No replacement"},{"label":"D","text":"Hypotonic always"},{"label":"E","text":"Skip electrolytes"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Perioperative fluid management: (1) Fluid types: - Crystalloid: NS (isotonic, but hyperchloremic — large volumes → metabolic acidosis + AKI; SMART trial favors balanced); balanced (LR, Plasma-Lyte) — preferred most cases; - D5W rarely used (free water); - Colloid: albumin (5%, 25%), hydroxyethyl starch (avoided due to AKI per CHEST + 6S trials); (2) Goals: - Maintain perfusion (BP, urine output, lactate clearance, mental status); - Avoid over-resuscitation (interstitial edema, anastomotic leak, pulmonary edema, AKI, abdominal compartment syndrome, ICU LOS, mortality); - Avoid under-resuscitation (hypoperfusion, AKI, ileus); (3) Maintenance — 4-2-1 rule (4 mL/kg first 10 kg + 2 next 10 + 1 above) historic; modern advocates lower or none with shorter NPO; (4) Replacement — match losses (insensible, urine, blood, third space); third space concept evolved (overestimated); (5) Goal-directed fluid therapy (GDFT): - Dynamic indices (PPV pulse pressure variation > 13%, SVV, IVC variability) > static (CVP, PCWP); - Cardiac output monitoring (esophageal Doppler, pulse contour analysis — FloTrac); - Fluid challenge (250 mL bolus, observe response); - Restrictive vs liberal — controversial; RELIEF trial moderate (3-4 L), restrictive associated with AKI; goal-directed better; (6) ERAS — moderate fluid + GDFT + early oral; (7) Major fluid shifts surgeries: liver, abdominal, vascular; (8) Electrolytes: - Na (water balance), K (cardiac), Ca (citrate from transfusion), Mg (arrhythmia, NMB), Cl (acid-base); - Hyponatremia (TURP syndrome with hypotonic irrigation; SIADH); - Hyperkalemia (ESRD, succinylcholine, transfusion, AKI); (9) Modern: individualized, goal-directed, multimodal assessment

---

Fluids: balanced > NS (large volume), avoid HES, GDFT > liberal/restrictive, dynamic indices > static, ERAS moderate fluid. Electrolyte management. Modern: individualized.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'anesthesiology', 'basic_science', 'endocrine_metabolic', 'adult',
  'ERAS Society; ASA Practice', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Basic science: physiology of fluid + electrolytes
Question on perioperative fluid management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'EMS/Management: anesthesia information management systems (AIMS) + EHR', '[{"label":"A","text":"Avoid all EHR"},{"label":"B","text":"AIMS/EHR in anesthesia"},{"label":"C","text":"Paper only"},{"label":"D","text":"Skip decision support"},{"label":"E","text":"Ignore alerts"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** AIMS/EHR in anesthesia: (1) Anesthesia Information Management System (AIMS) — electronic anesthesia record: - Automated capture of vitals; - Drug + fluid administration; - Events + interventions; - Customizable templates; - Integration with EHR; (2) Benefits: - Accuracy + completeness; - Legibility; - Decision support (drug interactions, allergies, dosing); - Quality reporting + research (NACOR); - Billing accuracy; - Reduced documentation burden in some studies; (3) Concerns: - Implementation cost; - Workflow disruption initially; - Patient safety risks (automated entry errors); - Privacy + security; - Documentation increase paradoxical; (4) Decision support: - Drug allergy alerts; - Drug-drug interaction; - Drug-disease interaction; - Dose-checking; - Reminders (antibiotic timing, glucose check); - Alert fatigue concern; (5) Big data + research: - Multicenter studies; - Quality improvement; - Outcome prediction (machine learning); - Precision anesthesia; (6) Integration with pumps, ventilators, monitors; (7) Modern: AI/ML applications: - Hypotension prediction (HPI); - Difficult airway prediction; - PONV risk; - Mortality risk; - Clinical decision support; (8) Cybersecurity — healthcare data breaches increasing; ransomware; vigilance + backup; (9) Modern: cloud-based, mobile, wearables, telemedicine integration; (10) Limitations — never replace clinical judgment + presence

---

AIMS/EHR: automated capture, decision support, quality reporting, research (NACOR). Concerns: workflow, alert fatigue, security. AI/ML modern (HPI, prediction). Integration. Cybersecurity vigilance. Clinical judgment paramount.', NULL,
  'easy', 'procedures', 'review',
  'anesthesiology', 'ems_mgmt', 'procedures', 'adult',
  'ASA Committee Informatics; APSF', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'EMS/Management: anesthesia information management systems (AIMS) + EHR'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Integrative: global anesthesia + low-resource settings', '[{"label":"A","text":"Ignore global health"},{"label":"B","text":"Global anesthesia + low-resource settings"},{"label":"C","text":"Refuse training"},{"label":"D","text":"Equipment-dependent always"},{"label":"E","text":"Discriminate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Global anesthesia + low-resource settings: (1) Global burden — 5 billion people lack safe anesthesia/surgery (Lancet Commission Global Surgery 2030); (2) Disparities: - Workforce shortage; - Equipment + drug shortages; - Training gaps; - Infrastructure; - Maternal mortality (anesthesia-related); (3) Anesthesia + global surgery: - Bellwether procedures (C-section, laparotomy, open fracture) — surrogate for surgical capacity; - WFSA (World Federation of Societies of Anaesthesiologists) Standards minimum; (4) Adaptations: - Draw-over vaporizers (no compressed gas needed); - Spinal anesthesia (low cost, effective for C-section + many surgeries); - Ketamine (broad utility, safer in low-resource); - Trained non-physician anesthesia providers; - Standardized protocols; (5) Education + training: - Training programs (Lifebox, SAFE OB, ETAT); - Continuing education; - Equipment donation programs; (6) Patient safety: - Lifebox pulse oximetry initiative; - WHO Surgical Safety Checklist; - Standardized care; (7) Specific challenges: - Sickle cell disease prevalent; - Anemia + nutritional deficiencies; - Infectious diseases (HIV, TB, malaria); - Late presentation; - Drug shortages; (8) Disaster anesthesia: - Earthquake, conflict, refugee crisis; - MSF, ICRC; - Field hospitals; - Ketamine-based; (9) Health equity: - Access to safe surgery; - Training local providers; - Sustainable systems; (10) Ethical considerations: - Cultural sensitivity; - Capacity building > episodic missions; - Respect local autonomy; - Avoid ''voluntourism''; (11) Modern: GlobalSurg studies, NIHR, partnership models

---

Global anesthesia: 5 billion lack access. Adaptations (draw-over, ketamine, spinal, non-physician providers). Lifebox initiative + WHO Checklist. WFSA Standards. Education + sustainable systems. Bellwether procedures.', NULL,
  'easy', 'procedures', 'review',
  'anesthesiology', 'integrative', 'procedures', 'adult',
  'Lancet Commission Global Surgery; WFSA Standards', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Integrative: global anesthesia + low-resource settings'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 60 ปี ASA III HTN, CAD on aspirin, well-controlled — elective TKA
Pre-op evaluation considering ALL routine testing', '[{"label":"A","text":"Test everything"},{"label":"B","text":"Pre-operative testing"},{"label":"C","text":"No history needed"},{"label":"D","text":"Routine CXR all"},{"label":"E","text":"Skip cardiac"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pre-operative testing — evidence-based: (1) Universal testing not recommended — direct patient impact required: - Reduce false positives leading to delays + harms; - Cost; - Patient inconvenience; (2) ASA/Choosing Wisely recommendations: - History + physical primary; - Targeted testing based on patient factors + procedure; (3) Tests with low yield in asymptomatic patients: - CXR without symptoms or specific risk; - Routine ECG in low-risk; - Routine CBC/electrolytes/coag asymptomatic minor surgery; (4) Indicated testing: - Age + comorbidity-based ECG (men > 40, women > 50, cardiac history); - Glucose/HbA1c if diabetic; - Hb if anemia history or major surgery; - Coagulation if liver disease, bleeding history, anticoagulant; - Renal function if CKD, age > 65 with risk factors, nephrotoxic drugs; - Pregnancy testing — selective vs universal female reproductive age; (5) Cardiac evaluation (covered) — RCRI + functional capacity; (6) Pulmonary — PFT only if active symptoms, recent change, planned thoracotomy; (7) Other tests: - Coag in regional anesthesia (selective); - Type + cross only if anticipated transfusion; (8) Cost-effective; (9) Beyond elective: - Emergent procedures less testing pre-op; - Trauma based on injury; (10) Pre-op clinic functions: - Risk stratification; - Optimization; - Education; - Coordination; - Reduced day-of cancellation; (11) Joint Commission + CMS quality measures; (12) Modern: shared decision-making + individualized testing

---

Pre-op testing: targeted based on H&P + comorbidity + procedure (NOT universal). ECG age + risk-based, indicated labs only. Reduce false-positive harms + cost. Pre-op clinic for optimization. Choose Wisely.', NULL,
  'easy', 'procedures', 'review',
  'anesthesiology', 'ems_mgmt', 'procedures', 'adult',
  'ASA Preanesthesia Practice Advisory; Choosing Wisely', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 60 ปี ASA III HTN, CAD on aspirin, well-controlled — elective TKA
Pre-op evaluation considering ALL routine testing'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 65 ปี — robotic-assisted laparoscopic prostatectomy in steep Trendelenburg position
GA + ETT, CO2 pneumoperitoneum, expected duration 4-5h', '[{"label":"A","text":"Standard supine"},{"label":"B","text":"Robotic surgery anesthesia + steep Trendelenburg + pneumoperitoneum"},{"label":"C","text":"No fluid restriction"},{"label":"D","text":"Skip eye protection"},{"label":"E","text":"Mass volume loading"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Robotic surgery anesthesia + steep Trendelenburg + pneumoperitoneum: (1) Steep Trendelenburg (30-45° head down) physiologic effects: - CV: increased preload + venous return (initially), decreased venous return prolonged (Bezold), increased ICP, conjunctival + laryngeal edema; - Respiratory: decreased FRC, increased PIP, atelectasis, decreased compliance, V/Q mismatch; - CNS: increased ICP + IOP; - Visual: increased risk POVL (rare but recognized); - Aspiration risk; (2) CO2 pneumoperitoneum: - Increased intra-abdominal pressure (12-15 mmHg) → decreased venous return + cardiac output; renal perfusion decrease; oliguria; - CO2 absorption → hypercapnia → tachycardia + arrhythmia; - Compromised ventilation; - Subcutaneous emphysema, pneumomediastinum, pneumothorax (rare); - Gas embolism (rare devastating); (3) Anesthetic management: - Lung-protective ventilation TV 6 mL/kg + PEEP 8-12; - Permissive hypercapnia; - Adjust I:E ratio; - Pressure-controlled ventilation often; - Adequate paralysis to facilitate insufflation + minimize PIP; - Limit IV fluid (avoid edema in head-down); - Goal-directed fluid; - Maintain MAP; - Eye protection (taped, eye shields, regularly check); - Avoid prolonged extreme Trendelenburg if possible; (4) Position complications: - Slipping cephalad — taped to bed, shoulder braces (brachial plexus injury risk), bean bag, gel pads; - Compartment syndrome lower extremity (lithotomy + steep T) — limit duration; - Brachial plexus injury (shoulder braces); - Conjunctival edema; - Facial edema; - Cerebral edema (post-op delirium); (5) Robotic specific: - Patient inaccessible during surgery (cannot easily access airway); - Emergency requires undocking robot; - Long surgery — pressure injury; - Single instrument failure issues; (6) Extubation: - Edema may compromise airway — cuff leak test, awake extubation, head up; - Post-op observation; (7) Multidisciplinary: anesthesia + urology + nursing

---

Robotic + steep T + pneumoperitoneum: lung-protective ventilation + PEEP, permissive hypercapnia, fluid restriction, eye protection, position complications (compartment syndrome, brachial plexus). Awake extubation. Robot undocking for emergency.', NULL,
  'medium', 'procedures', 'review',
  'anesthesiology', 'clinical_decision', 'procedures', 'adult',
  'ASA Position Practice Advisory; SAGES Pneumoperitoneum', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 65 ปี — robotic-assisted laparoscopic prostatectomy in steep Trendelenburg position
GA + ETT, CO2 pneumoperitoneum, expected duration 4-5h'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 45 ปี multi-trauma C-spine + chest injury + pelvic fracture + femur fracture
Age: 45, ED — airway secured, IV × 2, blood products started
Now planning transport from ED to OR vs CT scan', '[{"label":"A","text":"Skip equipment"},{"label":"B","text":"Trauma intra-hospital transport"},{"label":"C","text":"Walk patient"},{"label":"D","text":"Single IV only"},{"label":"E","text":"No transport plan"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Trauma intra-hospital transport: (1) Risks during transport: - Cardiovascular instability; - Respiratory compromise; - Loss IV access; - Hypothermia; - Equipment failure; - Disconnection (ETT, lines, monitors); - Inadequate analgesia/sedation; (2) Pre-transport optimization: - Hemodynamic stabilization (within reason — competing balance); - Adequate IV access (2 large-bore + central if available); - Secure airway (ETT + EtCO2 confirmation); - Adequate ventilation/oxygenation; - Sedation + analgesia + paralysis as needed; - Vasopressors continued; - Blood products available + warming; - Hypothermia prevention; (3) Transport equipment: - Portable monitor (SpO2, ECG, BP, EtCO2); - Portable ventilator (or ambu); - O2 cylinder full + backup; - Suction; - Airway kit (re-intubation); - Emergency drugs (epinephrine, atropine, sedation, paralysis); - IV pumps battery-powered + drugs; - Defibrillator; (4) Team composition: - Anesthesiologist or trained provider; - Nurse/RT; - Transport personnel; - Communication with destination; (5) Damage control resuscitation principles continue; (6) Trauma triad of death avoidance — hypothermia, coagulopathy, acidosis; (7) Communication: - Pre-arrival notification to receiving area (OR/ICU/CT); - Brief handoff; - Continued accessibility; (8) CT scan decision: - Full body CT (whole body scan) in stable trauma for diagnosis; - But unstable patient → direct to OR (damage control); - REBOA for select bleeding cases as bridge; (9) Documentation; (10) Multidisciplinary team approach

---

Trauma transport: optimize hemodynamic + airway, full transport equipment, trained team, communicate with destination, continue resuscitation. Triad of death avoidance. Stable → CT first, unstable → OR. Multidisciplinary.', NULL,
  'medium', 'trauma', 'review',
  'anesthesiology', 'ems_mgmt', 'trauma', 'adult',
  'ATLS; AAGBI Transfer Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 45 ปี multi-trauma C-spine + chest injury + pelvic fracture + femur fracture
Age: 45, ED — airway secured, IV × 2, blood products started
Now planning transport from ED to OR vs CT scan'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย 55 ปี history Long QT Syndrome — elective laparoscopic cholecystectomy
QTc 510 baseline
No prior arrhythmia', '[{"label":"A","text":"Ondansetron prophylactic"},{"label":"B","text":"Long QT Syndrome (LQTS) perioperative"},{"label":"C","text":"Methadone PCA"},{"label":"D","text":"Amiodarone first-line"},{"label":"E","text":"Bradycardia desired"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Long QT Syndrome (LQTS) perioperative: (1) Risk torsades de pointes (polymorphic VT) intra/post-op; (2) Continue baseline beta-blocker (cornerstone LQTS treatment); (3) Avoid QT-prolonging drugs: - Ondansetron + droperidol (5-HT3 + D2); - Methadone; - Amiodarone (acute use OK); - Erythromycin/clarithromycin; - Quinidine, procainamide; - Sotalol; - Haloperidol (high dose); - Fluoroquinolones; - Some anesthetics (sevoflurane modest prolongation; isoflurane less); - Volatile typically OK at clinical doses; (4) Avoid bradycardia (potentiates TdP) — atropine ready; (5) Avoid hypokalemia, hypomagnesemia (correct pre-op; target K > 4, Mg > 2); (6) Avoid sympathetic surges: - Adequate anesthesia depth; - Smooth induction + intubation; - Adequate analgesia; - Avoid pain, anxiety, light anesthesia; - Beta-blocker pre-induction; (7) Drug choices: - Propofol OK; - Etomidate OK; - Ketamine controversial (sympathomimetic — but usually OK with adequate beta-blockade); - Fentanyl OK (less than sufentanil); - Rocuronium OK; - Avoid succinylcholine bradycardia; - Lidocaine OK (treats TdP if occurs); (8) Monitoring: - Continuous ECG; - Have defibrillator/pacer immediately available; - Watch QTc + TWI dynamic changes; (9) Treatment torsades: - Magnesium sulfate 2g IV bolus (first-line); - Overdrive pacing or isoproterenol (increase HR > 100 to shorten QT); - Defibrillation if pulseless; - Avoid antiarrhythmic that prolong QT (amiodarone, procainamide, sotalol); (10) Implantable cardiac defibrillator (ICD) — deactivate for electrocautery (or use bipolar/short bursts), reactivate post-op; (11) Genetic counseling; (12) Family screening

---

LQTS: continue BB, avoid QT-prolonging drugs (ondansetron/droperidol/methadone), K > 4 + Mg > 2, avoid bradycardia, defibrillator ready. TdP treatment: Mg + overdrive pacing. Smooth anesthesia.', NULL,
  'hard', 'cardiovascular', 'review',
  'anesthesiology', 'clinical_decision', 'cardiovascular', 'adult',
  'AHA/ACC LQTS Guidelines; ASA Practice', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วย 55 ปี history Long QT Syndrome — elective laparoscopic cholecystectomy
QTc 510 baseline
No prior arrhythmia'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ICU 70 ปี post-aortic surgery day 2 — sudden lower extremity weakness bilateral
No pain, no sensory deficit per dermatomes initially, reflexes diminished', '[{"label":"A","text":"Ignore"},{"label":"B","text":"Spinal cord ischemia post-aortic surgery"},{"label":"C","text":"Wait 48h"},{"label":"D","text":"More sedation"},{"label":"E","text":"Decrease MAP"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Spinal cord ischemia post-aortic surgery: (1) Mechanism — interruption of spinal cord blood supply: - Anterior spinal artery — arises from intercostals, especially T9-T12 (Artery of Adamkiewicz); - Aortic cross-clamp during surgery; - Aortic dissection; - Embolic; (2) Anterior spinal artery syndrome: - Bilateral motor loss + pain/temperature loss; - Preserved proprioception + vibration (dorsal column); - Bowel/bladder dysfunction; - Devastating; (3) Risk factors: - Thoracoabdominal aortic surgery (highest); - Cross-clamp duration > 30 min; - Hypotension intra/post-op; - Anemia; - Hypovolemia; - Aortic disease; (4) Prevention strategies (TAA): - Cerebrospinal fluid drainage (CSF drain) — reduce CSF pressure, improve perfusion (target CSF < 10); - Distal aortic perfusion (LV bypass); - Mild hypothermia (32-34°C); - Permissive hypertension (MAP > 80-90); - Avoid anemia; - Reimplantation intercostals; - Motor evoked potential (MEP) monitoring; (5) Recognition + management: - Neuro exam q1h post-op; - If new deficit: CSF drainage MORE aggressive (drain CSF, target < 8), maintain MAP > 90-100, transfusion to Hb > 10, steroids (controversial); - MRI to rule out hematoma vs ischemia; - Time-sensitive — may reverse with prompt intervention; (6) Multidisciplinary: vascular surgery + anesthesia + neurology; (7) Other causes weakness post-aortic: - Hematoma (anticoagulation, neuraxial); - Mechanical (spinal stenosis); - Stroke; - Critical illness neuropathy (later); (8) Prognosis variable — early reversal possible if rapid intervention; permanent if delayed; (9) Documentation + counseling

---

Post-aortic spinal cord ischemia: anterior spinal artery syndrome (motor + pain/temp loss, preserved proprioception). Prevention CSF drain + MAP > 90 + MEP. Treatment: drain more, MAP higher, transfuse, rule out hematoma. Multidisciplinary.', NULL,
  'hard', 'neurology', 'review',
  'anesthesiology', 'clinical_decision', 'neurology', 'adult',
  'SVS Aortic Guidelines; SCA Aortic Anesthesia', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ICU 70 ปี post-aortic surgery day 2 — sudden lower extremity weakness bilateral
No pain, no sensory deficit per dermatomes initially, reflexes diminished'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Integrative: cultural competency + diversity in anesthesia care', '[{"label":"A","text":"Single approach all"},{"label":"B","text":"Cultural competency in anesthesia"},{"label":"C","text":"Family interprets always"},{"label":"D","text":"Ignore disparities"},{"label":"E","text":"Discriminate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cultural competency in anesthesia: (1) Healthcare disparities documented by race/ethnicity, gender, sexual orientation, socioeconomic, language, immigration, disability; (2) Specific anesthesia disparities: - Pain undertreated in minorities (multiple studies); - Disparities in perioperative outcomes; - Language barriers + access; (3) Components of cultural competency: - Awareness of own biases; - Knowledge of cultural variations (beliefs, practices); - Skills to engage respectfully; - Encounters across cultures; (4) Communication: - Professional interpreter (NOT family member); - Plain language; - Teach-back; - Health literacy assessment; - Culturally appropriate consent; - Privacy + dignity; (5) Cultural beliefs affecting anesthesia: - Religious (Jehovah''s Witness, fasting, modesty); - Dietary; - Pain expression varies; - Family decision-making (collectivist vs individualist); - End-of-life beliefs; - Traditional medicine; (6) Specific populations: - LGBTQ+ — affirming care, hormone therapy, surgical issues; - Indigenous — historical trauma, cultural practices; - Refugee/immigrant — trauma, language, legal status; - Disabled — accommodations, communication, consent capacity; - Limited English — interpretation; - Mental illness — stigma; (7) Implicit bias — automatic stereotyping; education + awareness + reflection; (8) Anti-racism in healthcare: - Recognize structural racism; - Diversify workforce; - Inclusive curriculum; - Address systemic issues; (9) Diversity, Equity, Inclusion (DEI) initiatives: - ASA Committee on DEI; - APSF; (10) Patient-centered care + shared decision-making; (11) Modern: trauma-informed care, structural humility, recognizing intersectionality; (12) Quality + safety equity

---

Cultural competency: awareness + knowledge + skills + encounters. Professional interpreter (NOT family). Address pain disparities. LGBTQ+ + refugee + disabled needs. Implicit bias + structural racism. DEI initiatives. Patient-centered + shared decision-making.', NULL,
  'easy', 'psych_behavior', 'review',
  'anesthesiology', 'integrative', 'psych_behavior', 'adult',
  'ASA DEI; AAMC Cultural Competence', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Integrative: cultural competency + diversity in anesthesia care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 32 ปี G2P1 GA 36 wk — severe Mitral Stenosis (MVA 0.8 cm²) from rheumatic
Dyspnea NYHA III, paroxysmal AFib
Delivery planning at 38 wk', '[{"label":"A","text":"Single-shot spinal"},{"label":"B","text":"Mitral stenosis in pregnancy + delivery"},{"label":"C","text":"Allow tachycardia"},{"label":"D","text":"Mass IV bolus"},{"label":"E","text":"Skip cardiology"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mitral stenosis in pregnancy + delivery: (1) MS hemodynamic goals: - Maintain SINUS RHYTHM (atrial kick essential, AFib catastrophic); - Avoid TACHYCARDIA (decreases diastolic filling time across stenotic valve → pulmonary congestion); target HR 60-80; - Maintain PRELOAD but avoid OVERLOAD (pulmonary edema); - Maintain SVR (afterload supports systemic circulation); - Avoid increased PVR (RV failure); - Avoid sympathetic surges; (2) Pregnancy worsens MS: - Increased CO + HR; - Increased blood volume; - Autotransfusion peri-delivery worst; (3) Pre-conception counseling, severe MS — consider valve intervention before pregnancy; balloon valvuloplasty pregnancy (radiation considerations); (4) Anesthesia for delivery: - Multidisciplinary planning at cardiac OB center; - Early epidural for labor — reduces sympathetic surge from pain; SLOW titration to avoid sudden hemodynamic shifts; - Vaginal delivery preferred if hemodynamically tolerated; assisted second stage (avoid prolonged Valsalva); - C-section reserved for OB indications; - Avoid spinal (sudden sympathectomy); - GA if needed (RSI standard, blunt response with opioid + lidocaine, avoid bradycardia + hypovolemia); (5) Drug choices: - Norepinephrine for hypotension (alpha + beta); - Esmolol for tachycardia/AFib rate control (avoid pure beta with caution); - Cardioversion AFib hemodynamic compromise; - Avoid ergot (uterine + cardiac); - Oxytocin slow (sudden hypotension can be devastating); (6) Monitoring: - Arterial line; - Cardiac output monitoring (esophageal Doppler, pulse contour); - TEE in OR if available; - Strict fluid balance; (7) Postpartum: - Autotransfusion + decompensation risk — highest mortality first 48h; - ICU; - Diuresis (carefully); - Continue beta-blocker; - Anticoagulation if AFib; (8) Multidisciplinary: cardiac OB anesthesia + OB + cardiology + ICU + neonatology

---

MS in pregnancy: hemodynamic goals (SR, slow HR, preload + afterload), early SLOW epidural for labor, avoid spinal/sudden sympathectomy, vaginal preferred. Norepi + esmolol. ICU postpartum. Multidisciplinary cardiac OB.', NULL,
  'hard', 'obgyn', 'review',
  'anesthesiology', 'clinical_decision', 'obgyn', 'adult',
  'SOAP Cardiac OB; AHA/ACC Valvular HD', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 32 ปี G2P1 GA 36 wk — severe Mitral Stenosis (MVA 0.8 cm²) from rheumatic
Dyspnea NYHA III, paroxysmal AFib
Delivery planning at 38 wk'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Basic science: pediatric pharmacokinetics/pharmacodynamics', '[{"label":"A","text":"Adult dosing"},{"label":"B","text":"Pediatric pharmacology"},{"label":"C","text":"Skip pediatric considerations"},{"label":"D","text":"Avoid all anesthesia peds"},{"label":"E","text":"Ignore weight"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric pharmacology: (1) Age-related changes: - Body composition (water, fat, muscle); - Protein binding; - Metabolism (CYP maturation); - Renal function maturation; - BBB permeability; (2) Neonatal specific: - Increased total body water (75-80%) → larger Vd hydrophilic drugs → higher loading dose; - Decreased lipid → smaller Vd lipophilic; - Decreased plasma proteins → more free drug; - Hepatic metabolism immature (CYP); - GFR decreased then matures by 1 year; - BBB more permeable (drug entry); - Receptor sensitivity different; (3) Specific drugs: - Propofol — increased dose 2.5-3 mg/kg (vs adult 1.5-2.5); higher metabolic rate young; - Succinylcholine — 1.5-2 mg/kg IV, 4 mg/kg IM (higher dose due to ECF); atropine pre-treatment for bradycardia; - Rocuronium — 1.2 mg/kg; sugammadex now available pediatric; - Sevoflurane — preferred for inhalational induction; emergence delirium risk; - Opioid — sensitivity varies; neonate respiratory depression risk; - Local anesthetic — lower max dose; bupivacaine 2 mg/kg, lidocaine 4.5 mg/kg (with epi 7); (4) MAC: - Neonate MAC similar/lower; - Infant 1-6 months HIGHER MAC for volatile (highest); - Decreases with age; (5) Dosing: - Weight-based mg/kg (not adult fixed dose); - Use ideal body weight in obese; - Round to nearest practical dose; - Adjust for age, organ function; (6) Cardiac: - Higher dependence on HR (fixed SV); avoid bradycardia (atropine ready); (7) Respiratory: - Higher O2 consumption; rapid desaturation; large head + occiput affects positioning; (8) Vascular access: - IV difficult — IO acceptable emergency; (9) Premature infants: - More extreme PK; - Apnea risk; - Hypoglycemia; - Hypothermia; - Long-term neurodevelopmental considerations volatile (FDA warning, controversial)

---

Pediatric PK/PD: water/fat differ, protein binding decreased, hepatic immature. Sux higher dose, MAC variable (infant highest). Weight-based dosing. Bradycardia + rapid desat. Premie special considerations.', NULL,
  'medium', 'procedures', 'review',
  'anesthesiology', 'basic_science', 'procedures', 'peds',
  'Cote Pediatric Anesthesia; APAGBI', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Basic science: pediatric pharmacokinetics/pharmacodynamics'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Basic science: ECMO in adult ICU', '[{"label":"A","text":"Skip ECMO"},{"label":"B","text":"Adult ECMO"},{"label":"C","text":"All patients candidates"},{"label":"D","text":"Avoid anticoagulation"},{"label":"E","text":"Single-clinician decision"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Adult ECMO: (1) Types: - VV (veno-venous) — respiratory failure, lungs rest; blood from vein → oxygenator → vein; - VA (veno-arterial) — cardiac + respiratory failure, supports CO; blood from vein → oxygenator → artery; (2) Indications VV ECMO: - Severe ARDS (P/F < 50 for 3h or < 80 for 6h + maximal medical therapy); - EOLIA + CESAR trials; (3) Indications VA ECMO: - Cardiogenic shock refractory; - Cardiac arrest (ECPR) — high-quality CPR + reversible cause; - Massive PE; - Anaphylaxis refractory; - Bridge to transplant/recovery/decision; (4) Contraindications: - Severe brain injury; - Disseminated cancer; - Severe coagulopathy/bleeding; - Age + frailty (case-by-case); - Cannot tolerate anticoagulation (relative); (5) Anticoagulation: - Heparin infusion target ACT 180-220 or aPTT 60-80; - Bivalirudin alternative (HIT or heparin resistance); - Bleeding most common complication; - Thrombosis if undertreated; (6) ECMO cannulation: - VV: percutaneous femoral + IJ or dual-lumen Avalon; - VA: peripheral (femoral artery + vein, distal perfusion cannula for limb), central (chest open); (7) Complications: - Bleeding; - Hemolysis; - Thrombosis; - Limb ischemia (VA peripheral); - Air embolism; - Cardiac stunning (LV distension VA); - Infection; - Neurologic; (8) Management: - Daily evaluation native function; - Weaning trials; - Multidisciplinary; - Family communication; (9) Anesthesia for ECMO patients: - Pump-dependent oxygenation/circulation; - Drugs altered PK (circuit sequestration); - Bleeding risk; - Communication with perfusion; (10) Outcomes: - VV ARDS survival ~60%; - VA cardiogenic shock variable; - ECPR survival 25-40%; (11) Modern: increased use; selection critical for outcomes

---

ECMO: VV (respiratory) vs VA (cardiac + respiratory). Indications + contraindications. Anticoagulation (heparin/bivalirudin). Complications: bleeding, limb ischemia (VA), LV distension. Multidisciplinary + selection critical. Modern: expanding use.', NULL,
  'medium', 'cardiovascular', 'review',
  'anesthesiology', 'basic_science', 'cardiovascular', 'adult',
  'ELSO Guidelines; EOLIA Trial', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Basic science: ECMO in adult ICU'
  );

commit;

