-- ===============================================================
-- UPDATE chunk 5/8: anesthesiology (25 questions)
-- ===============================================================

begin;

update public.mcq_questions
set choices = '[{"label":"A","text":"Manage same as systolic HF"},{"label":"B","text":"HFpEF (preserved EF) physiology"},{"label":"C","text":"Aggressive fluid loading"},{"label":"D","text":"Allow tachycardia"},{"label":"E","text":"Skip rhythm management"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** HFpEF (preserved EF) physiology: (1) Pathophys — impaired ventricular relaxation + increased filling pressures; LVEF normal but diastolic dysfunction; common in elderly, HTN, AFib, obesity, diabetes; (2) Echo features — E/A reversal, increased E/e'', LA enlargement, diastolic dysfunction grades; (3) Hemodynamic vulnerability: - Sensitive to volume changes — easily overloaded; - Sensitive to AFib (loss of atrial kick — 30% CO loss); - Sensitive to tachycardia (decreased diastolic filling time); (4) Anesthesia goals: - Maintain sinus rhythm — aggressive treat AFib (cardioversion if hemodynamically compromised, rate control); - Avoid tachycardia (target HR 60-80); - Maintain preload BUT avoid overload (Goldilocks zone narrow); - Maintain afterload (avoid sudden drops); - Avoid myocardial depressants; (5) Monitoring — TEE useful; CVP/PA catheter limited utility (LV filling pressure not reflected); (6) Drug choices: - Etomidate induction (CV stable); - Slow titrated propofol/opioid; - Phenylephrine for hypotension (alpha-1, maintains afterload); - Avoid ketamine (HR + SVR); - Avoid volatile high dose (vasodilator + myocardial depressant); (7) Fluid — judicious, frequent assessment; (8) Postop AFib common — rate + rhythm control; (9) Beta-blocker, ACE-I, MRA, SGLT2i in chronic management; loop diuretic; (10) Recent SGLT2i (empagliflozin, dapagliflozin) shown HFpEF benefit (EMPEROR-Preserved, DELIVER); (11) Hold ACE-I/ARB day of surgery; continue beta-blocker; (12) Modern: tailored hemodynamic management, multidisciplinary

---

HFpEF: maintain SR, avoid tachy + volume overload, narrow Goldilocks zone, phenylephrine for hypotension, avoid ketamine, TEE useful, multimodal. SGLT2i emerging treatment.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Basic science: cardiac physiology + anesthesia
Patient with diastolic dysfunction HFpEF';

update public.mcq_questions
set choices = '[{"label":"A","text":"V/Q irrelevant"},{"label":"B","text":"Pulmonary physiology + anesthesia"},{"label":"C","text":"Use 100% O2 always"},{"label":"D","text":"TV 15 mL/kg routine"},{"label":"E","text":"No PEEP"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pulmonary physiology + anesthesia: (1) V/Q matching: - West''s lung zones: Zone 1 (PA > Pa > Pv) — dead space; Zone 2 (Pa > PA > Pv) — variable; Zone 3 (Pa > Pv > PA) — best perfusion; - Normal V/Q ratio 0.8; - Mismatch causes hypoxemia (shunt) or hypercapnia (dead space); (2) Anesthesia effects: - GA reduces FRC (20% supine + intubated); - Atelectasis common (avoid 100% O2, recruitment maneuvers, PEEP); - Shunt increased — supine, intubated, paralyzed; - Decreased response to hypoxia + hypercapnia; (3) Hypoxic Pulmonary Vasoconstriction (HPV): - Reflex vasoconstriction in hypoxic alveoli to redirect blood to ventilated lung; - Improves V/Q matching; - INHIBITED by: volatile anesthetics (dose-dependent), pulmonary vasodilators (NO, nitroglycerin, dobutamine, prostacyclin), alkalosis; - PRESERVED by: TIVA propofol; (4) Critical in one-lung ventilation — HPV helps blood shunt to ventilated lung; (5) Lung-protective ventilation: - TV 6 mL/kg IBW (predicted BW from height); - Plateau < 30; - Driving pressure < 15; - PEEP 5-10 (titrate); - Permissive hypercapnia OK; (6) Recruitment maneuvers — controversial harm in some (ART trial); (7) Specific conditions: - COPD — air trapping, prolong expiration, avoid auto-PEEP; - Asthma — bronchospasm, deepen anesthesia + bronchodilator; - ARDS — TV 4-6 mL/kg, prone, PEEP titration; - Obesity — ramped position, PEEP, recruitment; - Restrictive — careful PIP; (8) Closing capacity rises with age + disease — may exceed FRC + cause hypoxemia

---

V/Q + HPV: West''s zones, V/Q 0.8, GA reduces FRC + causes atelectasis. HPV redirects to ventilated lung — inhibited by volatile + vasodilator, preserved by TIVA. Lung-protective ventilation universal modern standard.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Basic science: pulmonary physiology + ventilation
Question on ventilation/perfusion + hypoxic pulmonary vasoconstriction';

update public.mcq_questions
set choices = '[{"label":"A","text":"Hypothermia desirable always"},{"label":"B","text":"Thermoregulation during anesthesia"},{"label":"C","text":"Skip temp monitoring"},{"label":"D","text":"Cold IV fluid routine"},{"label":"E","text":"Cold room mandatory"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Thermoregulation during anesthesia: (1) Mechanisms heat loss: - Radiation (40%); - Convection (30%); - Evaporation (skin + airway + surgical); - Conduction (cold surfaces); (2) Anesthesia + thermoregulation: - GA inhibits hypothalamic thermoregulation; threshold for shivering decreased to 34°C (normal 36.5°C); - Vasoconstriction threshold decreased; - Redistribution hypothermia — peripheral vasodilation after induction → core temp drops 1-2°C in first hour; - Linear loss 0.5-1°C/hr if uncorrected; - Plateau when shivering threshold reached; (3) Consequences hypothermia: - Wound infection (vasoconstriction → tissue hypoxia); - Coagulopathy (impaired enzymes + platelets); - Cardiac arrhythmias + MI; - Delayed drug metabolism; - Patient discomfort + shivering (5× O2 consumption); - Length of stay; (4) Active warming: - Pre-warm pre-op 30-60 min reduces redistribution; - Forced air warmer (Bair Hugger) — most effective; - Warm IV fluids (37-40°C); blood warmer; - Warm humidified gases (minor); - Increase OR ambient temperature (24-26°C); - Underbody warming, conductive blankets; (5) Hypothermia indications (intentional): - Deep hypothermic circulatory arrest (DHCA) — cardiac/aortic surgery; - Post-cardiac arrest TTM 32-36°C; - Neurosurgical adjunct (controversial); (6) Hyperthermia: - Malignant hyperthermia (treat as covered); - Sepsis/infection; - Drug-induced (anticholinergic, sympathomimetic, serotonin syndrome, NMS); - Hyperthyroidism storm; - Treat: stop trigger + cool + hydrate + treat underlying; (7) Monitoring — esophageal/bladder/nasopharyngeal core temp; surface variable; (8) Target — normothermia 36-37°C

---

Thermoregulation: GA inhibits hypothalamic regulation, redistribution hypothermia first hour. Hypothermia → infection, coagulopathy, MI, shivering. Active warming + pre-warming. Target 36-37°C. Intentional hypothermia: DHCA, TTM.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Basic science: temperature regulation + anesthesia';

update public.mcq_questions
set choices = '[{"label":"A","text":"Intubate all trauma"},{"label":"B","text":"Pre-hospital/transport anesthesia"},{"label":"C","text":"Skip airway protection"},{"label":"D","text":"No monitoring"},{"label":"E","text":"Walk-in trauma center"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pre-hospital/transport anesthesia: (1) Indications for pre-hospital intubation: - Inability to maintain/protect airway; - Failure to ventilate/oxygenate despite simpler measures; - Severe TBI GCS ≤ 8; - Anticipated clinical course (e.g., burn airway); - Long transport time; (2) Pre-hospital RSI requires: - Trained provider (anesthesia, EM, critical care paramedic); - Equipment + medications; - Monitoring (SpO2, EtCO2, BP, ECG); - Backup airway plan; - Quality assurance + outcomes tracking; (3) Drug RSI: - Etomidate or ketamine (hemodynamically stable in shock); - Rocuronium or succinylcholine; (4) Confirmation — EtCO2 mandatory; auscultation supplemental; (5) Outcomes — pre-hospital intubation can worsen outcomes if performed by inexperienced providers; multiple studies; trained services improve outcomes; (6) Supraglottic airway alternative — iGel, LMA — faster + safer than ETT in some settings; (7) Mechanical ventilation transport — small ventilators, lung-protective TV 6 mL/kg, PEEP, FiO2 adjusted; (8) Sedation + analgesia transport — fentanyl, midazolam, ketamine, propofol infusion; (9) Hemodynamic support — vasopressor infusion, fluid; (10) Communication with receiving facility — destination decision (trauma center, stroke center, STEMI center); (11) HEMS (helicopter) considerations — noise, vibration, weight, altitude (PaO2 drops, expanded gas), thermoregulation; (12) Interhospital transport — pre-transport optimization, anticipated equipment failure backup, monitoring continuity; (13) Modern: tele-EMS, point-of-care US, video laryngoscopy in field, simulation training

---

Pre-hospital anesthesia: indications for intubation, RSI with etomidate/ketamine + rocuronium/sux, EtCO2 confirmation, SGA alternative, transport ventilation + sedation, destination decision. Outcome depends on provider experience.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'EMS question: pre-hospital + transport anesthesia
Field intubation criteria + considerations';

update public.mcq_questions
set choices = '[{"label":"A","text":"Treat first arrived"},{"label":"B","text":"Mass casualty + triage"},{"label":"C","text":"Ignore triage"},{"label":"D","text":"Treat black tag first"},{"label":"E","text":"Skip blood bank"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mass casualty + triage — anesthesia role: (1) Triage systems: - START (Simple Triage And Rapid Treatment) — adult: ability to walk, respiration, perfusion, mental status; - JumpSTART — pediatric; - SALT (Sort, Assess, Lifesaving interventions, Treatment/Transport); - Categories: RED (immediate — survivable life-threatening), YELLOW (delayed — serious but stable), GREEN (minor — walking wounded), BLACK (deceased/expectant); (2) Greatest good for greatest number principle (vs individual best care); (3) Anesthesia roles: - Airway management (intubation, surgical airway, SGA); - Resuscitation (IV access, IO if difficult, fluid, blood); - Operating room management — surgical priority, damage control; - ICU + transport coordination; - Mass casualty pre-deployment training; (4) Hospital response: - Activate disaster plan; - Mobilize personnel; - Cancel elective; - Open additional ORs; - Blood bank mass casualty protocol; - Patient flow + identification system; (5) Lifesaving interventions in field: - Airway opening, chest decompression (pneumothorax), hemorrhage control (tourniquet), antidote (autoinjector); (6) Tourniquet — modern resurgence (CAT, SOFTT-W); for extremity hemorrhage life-threatening; can stay 6-8h safely; (7) Hemorrhage control — direct pressure, hemostatic dressing, tourniquet, wound packing; whole blood emerging civilian; (8) Anesthetic considerations — high-volume rapid care, ketamine + minimal monitoring, regional anesthesia for selected injuries, ECMO referral capability; (9) Mental health for providers + patients; (10) Debrief + after-action review; (11) Special situations — chemical/biological/radiological/nuclear (CBRN); (12) Multidisciplinary disaster team training + drills

---

Mass casualty: START/SALT triage (RED/YELLOW/GREEN/BLACK), greatest good principle. Anesthesia roles: airway, resuscitation, OR management. Hospital disaster plan. Tourniquet hemorrhage. Multidisciplinary drills.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Mass casualty incident — multiple trauma patients arriving — triage + anesthesia role';

update public.mcq_questions
set choices = '[{"label":"A","text":"Ignore adverse events"},{"label":"B","text":"Quality + safety in anesthesia"},{"label":"C","text":"Hide errors"},{"label":"D","text":"Punish all"},{"label":"E","text":"Skip continuing education"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Quality + safety in anesthesia: (1) ASA Closed Claims Project — analysis malpractice claims identifies patterns: - Top categories: nerve injury, dental damage, respiratory events, awareness, eye injury, regional anesthesia complications, OB anesthesia, post-op visual loss, fire injury; - Modern: more chronic pain claims, regional anesthesia, peripheral nerve injury, intra-op awareness with recall; - Standards improvements reduced specific events (e.g., capnography reduced unrecognized esophageal intubation); (2) Adverse event management: - Recognize + acknowledge; - Disclosure to patient/family (ethical + legal); - Document factually; - Internal reporting + investigation; - Root cause analysis; - Quality improvement; - Support second victim (provider); (3) Risk management — Just Culture: - Distinguish human error (console + retrain) vs at-risk behavior (coach) vs reckless (discipline); - Encourage reporting + learning; (4) Patient safety initiatives: - ASA Anesthesia Quality Institute (AQI); - APSF; - National Patient Safety Foundation; - Joint Commission accreditation; - WHO Surgical Safety Checklist; (5) Specific safety improvements: - Pulse oximetry + capnography mandatory; - Standardized monitoring; - Quantitative TOF monitoring; - Difficult airway algorithm; - Cognitive aids (emergency manuals); - Simulation training; - Crew Resource Management (CRM); - Maintenance of Certification; (6) Outcome metrics — perioperative mortality, MOC, surgical site infection, PONV, pain, satisfaction, length of stay; (7) Quality improvement frameworks — PDSA, lean, six sigma; (8) National Anesthesia Clinical Outcomes Registry (NACOR); (9) MOCA Minute (continuous learning); (10) Modern: AI, machine learning, big data, EHR analytics for adverse event detection + prevention

---

Anesthesia quality + safety: ASA Closed Claims (nerve injury, dental, respiratory, awareness), adverse event management (recognize, disclose, RCA), Just Culture, mandatory monitoring, CRM, simulation, MOC, NACOR. Modern AI/ML.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Question on quality + safety in anesthesia: closed claims + adverse events';

update public.mcq_questions
set choices = '[{"label":"A","text":"Always full resuscitation"},{"label":"B","text":"End-of-life care + anesthesia"},{"label":"C","text":"Hide diagnosis"},{"label":"D","text":"Force intubation"},{"label":"E","text":"Ignore family"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** End-of-life care + anesthesia: (1) Palliative anesthesia — symptom management in serious illness/end of life: - Pain (opioids, regional anesthesia, intrathecal pump, sympathetic blocks); - Dyspnea (opioids low-dose, anxiolytics, oxygen, fan); - Nausea (multimodal antiemetics); - Anxiety + delirium; - Total pain concept (physical + psychological + social + spiritual); (2) DNR/DNI in operating room: - ASA Statement: required reconsideration (NOT automatic suspension); - Explicit discussion patient/surrogate + surgeon + anesthesiologist; - Options: full suspension (most common historically), procedure-directed (no chest compressions, no defibrillation, etc.), goal-directed (resuscitate if temporary issue, not if terminal); - Document explicitly; restore DNR postop; - Limits on interventions don''t preclude anesthesia care; (3) Withdrawal of life-sustaining therapy — anesthesia role: - Compassionate extubation; - Symptom management — opioid + benzodiazepine titrated to comfort (Doctrine of Double Effect — intent to relieve suffering, foreseeable but unintended hastening of death — ethical + legal); - Family presence + support; - Spiritual care; (4) Hospice + palliative care consultation; (5) Anesthesia for palliative procedures: - Nerve block/neurolysis (celiac plexus, splanchnic, intercostal, sympathetic) for cancer pain; - Vertebroplasty for spine fractures; - Bronchoscopy/stenting for airway obstruction; - GI stenting for obstruction; (6) Goals of care discussions: - Address prognosis honestly + sensitively; - Patient values + preferences; - Trade-offs; - Quality of life vs length; - Family inclusion; (7) Ethical principles: - Autonomy + informed consent; - Beneficence + non-maleficence; - Doctrine of Double Effect; - Distinction between killing + allowing to die; (8) Modern: integrated palliative + critical care; Schwartz Rounds for provider support; (9) Cultural sensitivity

---

End-of-life anesthesia: palliative procedures, DNR in OR = required reconsideration (not suspension), withdrawal of LST with symptom Mx (Doctrine of Double Effect), goals of care discussions, palliative consultation, integrated care.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Question on end-of-life care + anesthesia';

update public.mcq_questions
set choices = '[{"label":"A","text":"Stop all + no bridging"},{"label":"B","text":"Bridging anticoagulation pre-op"},{"label":"C","text":"Continue all chronically"},{"label":"D","text":"Skip cardiology consult"},{"label":"E","text":"Always bridge with heparin"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bridging anticoagulation pre-op: (1) CHA2DS2-VASc 5 = high stroke risk AFib; (2) Warfarin management — depends on bleeding risk surgery + stroke risk patient: - HIGH stroke risk (CHA2DS2-VASc ≥ 5, mechanical valve, recent VTE < 3 months): consider bridging with LMWH; BRIDGE trial showed no benefit + increased bleeding for AFib (CHA2DS2-VASc ≤ 5 — most patients); for higher risk individualize; - Continue warfarin if low-bleeding-risk procedure (cataracts, dental, dermatologic, simple endoscopy); (3) Standard hold warfarin 5 days pre-op + restart 12-24h post-op when hemostasis OK; check INR ≤ 1.5 day before; (4) DOAC bridging — generally NOT recommended; hold based on half-life + CrCl + bleeding risk: - Apixaban/rivaroxaban: 48h hold (high bleed risk), 24h (low); longer with renal; - Dabigatran: 48-96h depending on CrCl; (5) Reversal options: - Warfarin: Vit K, 4-factor PCC (Kcentra), FFP; - Apixaban/rivaroxaban: andexanet alfa, PCC; - Dabigatran: idarucizumab (specific antibody); (6) Antiplatelet management — clopidogrel for DES: - Recent DES (< 6 months) — continue DAPT, defer elective surgery; - Stable > 6-12 months — continue ASA, consider hold clopidogrel 5-7 days (cardiology consult); - Bare metal stent — different timing; (7) Restart timing: - Hemostasis confirmed; - LMWH bridging post-op 48-72h (high VTE/CV risk); - Therapeutic anticoagulation when bleeding low; (8) Special: neuraxial — strict ASRA timing (as covered); (9) Multidisciplinary — cardiology + hematology + surgery + anesthesia; (10) PERIOP2 trial; BRIDGE trial influence modern practice

---

Anticoag bridging: BRIDGE trial — no benefit AFib most patients. Hold warfarin 5d, DOAC per half-life + CrCl. Reversal agents available. Clopidogrel + DES — defer if recent. Restart based on hemostasis. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Pre-op question: patient on chronic anticoagulation + antiplatelet — bridging plan
70 ปี AFib on warfarin (CHA2DS2-VASc 5) + ASA + clopidogrel post-DES 8 ปี ago — elective hip replacement';

update public.mcq_questions
set choices = '[{"label":"A","text":"Standard anesthesia"},{"label":"B","text":"Ruptured AAA emergency anesthesia"},{"label":"C","text":"Aggressive crystalloid only"},{"label":"D","text":"Avoid all transfusion"},{"label":"E","text":"Hold ventilation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Ruptured AAA emergency anesthesia: (1) Mortality 50% reaching hospital, 80% overall; (2) Resuscitation principles: - Permissive hypotension SBP 70-90 until cross-clamp (controls bleeding before surgery); - Massive transfusion 1:1:1; TXA; - Avoid over-resuscitation (worsens bleeding + coagulopathy); - Large-bore IV × 2-3 + RIC line or central; - Arterial line ASAP; (3) Anesthesia induction: - Pre-induction: surgeon scrubbed + prepped, OR ready, blood products in room; - Ketamine 1 mg/kg + opioid + rocuronium 1.2 mg/kg; - Etomidate alternative; - Avoid propofol bolus (hypotension); (4) Cross-clamp considerations: - Pre-clamp: lower BP target (SBP 90-100), prepare for sudden afterload increase; - Apply clamp: massive BP rise + afterload + decreased CO; treat with vasodilator (nitroglycerin), increase volatile, deepen anesthesia, fluid; - Pre-unclamp: volume load, calcium, sodium bicarb (acidosis from ischemic limb), expect hypotension; - Unclamp: profound hypotension expected (vasodilation + reactive hyperemia + metabolite release); vasopressor, fluid; (5) Ventilation: lung-protective; (6) Renal protection — fluid + mannitol selectively; minimize ischemia time; (7) Spinal cord protection (TAA) — CSF drainage, MAP > 80-90, mild hypothermia; (8) Coagulopathy management — TEG/ROTEM; fibrinogen target > 1.5-2; warm products; calcium; (9) Hypothermia avoidance — warming all; (10) Post-op ICU — expect prolonged ventilation, AKI, coagulopathy, abdominal compartment syndrome, mesenteric ischemia, paraplegia (TAA); (11) Endovascular alternative (EVAR) — lower mortality if anatomy suitable; emergent EVAR program; (12) Multidisciplinary — vascular surgery + anesthesia + perfusion (if open) + ICU + blood bank

---

Ruptured AAA: permissive hypotension, MTP 1:1:1, ketamine/etomidate induction, cross-clamp Mx (vasodilator pre, vasopressor post-unclamp), TEG-guided, warming, renal + spinal cord protection. EVAR alternative.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 45 ปี — emergency open AAA repair with rupture
BP 75/40, HR 130, intubated in ED
Massive transfusion ongoing — 8 units PRC + 6 FFP + 1 platelet apheresis so far';

update public.mcq_questions
set choices = '[{"label":"A","text":"Treat as morbidly obese"},{"label":"B","text":"Post-bariatric surgery anesthesia"},{"label":"C","text":"Heavy NSAID use"},{"label":"D","text":"Skip B12"},{"label":"E","text":"Force oral medications"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-bariatric surgery anesthesia: (1) Physiology changes: - Significant weight loss → improved cardiopulmonary status; - Reduced OSA severity (re-evaluate); - Improved diabetes, HTN; - Nutritional deficiencies common (B1, B12, iron, vit D, protein); (2) Anatomic changes: - Roux-en-Y gastric bypass: small pouch + Roux limb + bypass; rapid transit; - Sleeve gastrectomy: tubular stomach; (3) Anesthesia considerations: - NPO different — modified, rapid transit; some centers shorter NPO; - Aspiration risk variable — bypass typically lower (small pouch); sleeve variable; consider RSI if symptoms or recent surgery; - Pharmacokinetics altered — reduced absorption oral medications; consider IV/IM; - Volume of distribution changed; (4) Specific medication concerns: - NSAID: AVOID after bariatric (anastomotic ulcer + perforation risk); - Opioid: increased sensitivity (weight loss + reduced tolerance); - Iron, B12 supplementation; - Hypoglycemia risk (dumping syndrome); (5) Multimodal opioid-sparing: - Regional anesthesia (TAP, ESP, rectus sheath); - Acetaminophen + ketamine + gabapentinoid + dexamethasone + lidocaine infusion; - Local infiltration; - Avoid NSAID; (6) DVT prophylaxis — still increased risk even after weight loss; mechanical + pharmacologic; (7) Reassess OSA — repeat sleep study post-significant weight loss; (8) Late complications watch for: - Internal hernia (Roux-en-Y) — abdominal pain emergency; - Anastomotic stricture; - Nutritional deficiencies; - Dumping syndrome; - Gallstones; (9) Psychiatric — depression, substance abuse increased post-bariatric — screen + support; (10) Modern: bariatric surgery long-term care multidisciplinary

---

Post-bariatric: AVOID NSAID (ulcer + perforation), opioid sensitivity increased, altered PK + nutritional deficiencies, multimodal regional anesthesia, screen OSA, internal hernia emergency, multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 45 ปี post-laparoscopic Roux-en-Y gastric bypass 6 months ago — elective ventral hernia repair
Weight 88 kg (down from 145 kg)
No current GERD; on PPI, B12, multivitamins';

update public.mcq_questions
set choices = '[{"label":"A","text":"Standard adult anesthesia"},{"label":"B","text":"Geriatric anesthesia + frailty"},{"label":"C","text":"Heavy benzodiazepine premed"},{"label":"D","text":"Skip pre-op assessment"},{"label":"E","text":"Refuse elderly patients"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Geriatric anesthesia + frailty: (1) Frailty assessment: - Clinical Frailty Score (CFS); - Fried Phenotype (weight loss, exhaustion, slow walking, weakness, low activity); - Edmonton Frail Scale; - Frailty = biologic age > chronologic; predicts adverse outcomes; (2) Pre-op optimization: - Multidisciplinary geriatric assessment; - Pre-habilitation (exercise, nutrition, cognitive training); - Medication review (Beers Criteria — avoid potentially inappropriate); - Treat comorbidities; - Cognitive baseline (Mini-Cog, MoCA); - Goals of care discussion; (3) Anesthetic considerations: - Reduced MAC (~6% decrease per decade after 40); - Increased sensitivity to opioids; - Slower drug clearance (renal + hepatic + lean body mass); - Decreased cardiopulmonary reserve; - Increased delirium risk; - Higher perioperative mortality; (4) Drug choices: - Avoid Beers list — benzodiazepines (delirium), anticholinergic (diphenhydramine, scopolamine), meperidine, long-acting opioid; - Use: short-acting agents, regional anesthesia, multimodal; - Propofol carefully (hypotension); - Dexmedetomidine — anxiolysis + sedation without respiratory depression; (5) Delirium prevention: - Avoid offenders (benzo, anticholinergic, opioid in excess); - HELP bundle (orientation, hearing/glasses, sleep, mobility, hydration); - Multimodal pain control; - Avoid restraints; - Family + familiar items; (6) Postop care: - Early mobilization; - Adequate analgesia (multimodal); - Hydration; - Bowel/bladder routines; - Skin care; - Nutrition; - Re-orientation; (7) Outcomes — frailty increases mortality 3-5×; functional decline; institutionalization; (8) Goals of care — quality of life, function, dignity > length; informed shared decision-making; (9) Multidisciplinary — anesthesia + geriatric medicine + surgery + nursing + PT + OT + family; (10) Modern: perioperative geriatric medicine; prehabilitation programs

---

Geriatric + frail: CFS, Beers Criteria avoidance, multimodal opioid-sparing, regional, HELP bundle for delirium, prehabilitation, goals of care. Multidisciplinary. Modern: perioperative geriatric medicine.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 80 ปี frail, ASA III — elective laparoscopic cholecystectomy
Clinical Frailty Score 6, lives in assisted living, mild cognitive impairment
Family wants aggressive treatment';

update public.mcq_questions
set choices = '[{"label":"A","text":"Routine doses all drugs"},{"label":"B","text":"Chronic kidney disease perioperative"},{"label":"C","text":"Morphine PCA"},{"label":"D","text":"NSAID for pain"},{"label":"E","text":"Mass IV NS bolus"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Chronic kidney disease perioperative: (1) Pre-op optimization: - Avoid nephrotoxins (NSAIDs, IV contrast, aminoglycosides); - Volume status assessment + optimization; - Treat anemia (Hb > 10) — iron, EPO if indicated; - Electrolytes — correct hyperkalemia, acidosis; - Coagulopathy from uremia — DDAVP 0.3 mcg/kg if bleeding; cryoprecipitate; platelet dysfunction; - Hold ACE-I/ARB day of surgery (hypotension); continue most others; - Discuss with nephrology; (2) Anesthesia choices: - Regional anesthesia good option (avoid GA in advanced CKD); - GA: cisatracurium (Hofmann elimination — renal-independent), avoid morphine (M6G accumulates) — use fentanyl/hydromorphone; - Propofol OK; etomidate OK; - Avoid succinylcholine if K elevated; - Sevoflurane OK; avoid desflurane prolonged (compound A theoretical concern in CKD); (3) Fluid management — judicious, avoid overload; isotonic crystalloid (NS — but chloride load concern; balanced solutions better; avoid LR if K elevated near upper limit); (4) Hemodynamic — maintain BP (renal perfusion); arterial line for major surgery; (5) Drug dose adjustment per eGFR — many anesthetic adjuncts; (6) Post-op — monitor renal function, urine output, electrolytes, fluid balance; (7) Avoid AKI prevention — maintain MAP, avoid nephrotoxins, fluid balance; (8) Multidisciplinary — nephrology + anesthesia + surgery; (9) Inguinal hernia — regional anesthesia ideal (spinal or local + TAP/ilioinguinal block); (10) Modern: erythropoiesis-stimulating agents (ESA) for anemia, iron sucrose, careful monitoring

---

CKD: avoid NSAIDs/contrast/aminoglycoside, treat anemia, regional preferred, cisatracurium, fentanyl/hydromorphone, balanced fluids, dose adjustment. Inguinal hernia ideal for regional.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 55 ปี chronic kidney disease stage 4 (eGFR 22) — elective inguinal hernia repair
Meds: amlodipine, atorvastatin, no anticoagulant
Hb 10.5, K 4.5, Cr 3.0, urea 80
Anemia of CKD on no EPO yet';

update public.mcq_questions
set choices = '[{"label":"A","text":"Naloxone"},{"label":"B","text":"Organophosphate poisoning"},{"label":"C","text":"Beta-blocker"},{"label":"D","text":"Calcium channel blocker"},{"label":"E","text":"Succinylcholine for RSI"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Organophosphate poisoning — cholinergic crisis: (1) Mechanism — acetylcholinesterase inhibition → ACh accumulation → muscarinic + nicotinic + CNS effects; (2) Toxidrome — SLUDGE/BBB: salivation, lacrimation, urination, defecation, GI upset, emesis + bronchorrhea, bronchospasm, bradycardia + miosis, fasciculations, weakness, confusion, seizure, coma; (3) Decontamination: - Remove clothing; - Wash skin (provider PPE — concentrated agents harm responders); - Activated charcoal early if ingested; - GI lavage controversial; (4) Atropine — competitive muscarinic antagonist: - Bolus 1-3 mg IV q3-5 min doubling until adequate atropinization (dry secretions, HR > 80, no bronchospasm); huge doses may be needed (10s-100s of mg); - Infusion to maintain; - Endpoint: drying of secretions, not pupil dilation (lags); (5) Pralidoxime (2-PAM) — regenerates AChE if given before ''aging'' of enzyme (hours): - 1-2 g IV bolus + 500 mg/hr infusion; - Effective for nicotinic + muscarinic; - Less effective for some agents (nerve agents age fast); (6) Airway: - Intubate for respiratory failure/secretions/altered mental status; - Avoid succinylcholine — prolonged paralysis (depends on cholinesterase); - Use rocuronium (longer onset, but only choice); - Suctioning constant for secretions; (7) Seizures — benzodiazepine; (8) Hemodynamic support; (9) ICU admission — prolonged course (days-weeks); intermediate syndrome (paralysis 24-96h post); delayed neuropathy weeks-months; (10) Psychiatric consult — intentional ingestion; (11) Modern: hemoperfusion experimental; lipid emulsion (some advocate); (12) Multidisciplinary — toxicology + ICU + psychiatry

---

Organophosphate: atropine (titrate to dry secretions), pralidoxime (2-PAM) before aging, decontamination, intubate with rocuronium (NOT sux), benzo for seizure, ICU course prolonged.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วย 50 ปี — emergency 2 hr after exposure: pesticide (organophosphate) — ingested deliberately
Symptoms: salivation, sweating, miosis, fasciculations, bradycardia, bronchospasm
SpO2 88%, BP 80/50, HR 50';

update public.mcq_questions
set choices = '[{"label":"A","text":"Admit overnight always"},{"label":"B","text":"Ambulatory surgery discharge criteria"},{"label":"C","text":"Refuse discharge"},{"label":"D","text":"No instructions"},{"label":"E","text":"Discharge alone driving"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Ambulatory surgery discharge criteria: (1) Aldrete Score — modified for ambulatory: - Activity (move all extremities voluntarily); - Respiration (deep breathe, cough); - Circulation (BP within 20% baseline); - Consciousness (fully awake); - SpO2 (> 92% on room air); - Score ≥ 9 for PACU discharge; (2) PADSS (Post-Anesthesia Discharge Scoring System): - Vital signs; - Activity (ambulation); - Nausea/vomiting; - Pain; - Surgical bleeding; - Score ≥ 9 for home discharge; (3) Specific criteria for ambulatory discharge: - Stable VS × 30 min; - Awake + oriented; - Able to ambulate (with assistance if needed); - Pain manageable with oral medications; - PONV controlled; - No bleeding; - Voided (controversial — some require, especially after neuraxial); - Tolerating PO fluids (controversial — fast-track may skip); - Responsible adult escort; - Written + verbal discharge instructions; - Follow-up plan; (4) Spinal anesthesia specific: - Resolution of motor block; - Sensory regression to S3 (anal); - Some advocate voiding before discharge (urinary retention risk) — others allow with instructions if low-risk; - Lower-dose short-acting LA (chloroprocaine, hyperbaric lidocaine, low-dose bupivacaine) faster ambulation; (5) Fast-track recovery — bypass PACU if criteria met in OR; (6) ERAS ambulatory protocols; (7) Outpatient surgery contraindications: - Severe OSA without home CPAP; - Unstable comorbidity; - Lack escort/home support; (8) Modern: increasing complex outpatient surgery (TKA, mastectomy, even some hysterectomies)

---

Ambulatory discharge: Aldrete + PADSS scores, VS stable, ambulating, pain/PONV controlled, escort home, voided (selective), instructions. Spinal: motor + sensory recovery, voiding for some. ERAS + fast-track modern.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วย 24 ปี healthy elective ACL reconstruction outpatient — spinal anesthesia + sedation
Finished procedure, in PACU, vital signs stable, ambulating, voiding
Ready for discharge';

update public.mcq_questions
set choices = '[{"label":"A","text":"Routine epidural for labor"},{"label":"B","text":"Severe pulmonary hypertension in pregnancy"},{"label":"C","text":"Single-shot spinal for C-section"},{"label":"D","text":"Heavy IV crystalloid"},{"label":"E","text":"Pure alpha agonist high dose"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe pulmonary hypertension in pregnancy — high mortality (25-50%): (1) Multidisciplinary pre-conception counseling — pregnancy contraindicated traditionally, but some patients counseled; modern care improved outcomes; (2) Pulmonary HTN + pregnancy physiology: - Increased CO 40% poorly tolerated with fixed PVR; - RV failure risk; - Highest risk peri-/postpartum (autotransfusion, blood loss); (3) Delivery planning: - Multidisciplinary center (anesthesia + OB + cardiology + ICU + neonatology + ECMO); - Vaginal vs C-section — controversial; vaginal with epidural may be preferred (avoid surgical stress); C-section for OB indications; - Avoid neuraxial-induced sudden sympathectomy (slow epidural titration; spinal generally avoided); (4) Anesthesia approach: - Avoid sudden hemodynamic changes; - Pulmonary vasodilator continuation (sildenafil, bosentan, inhaled NO, prostacyclin epoprostenol/iloprost); - Avoid pulmonary vasoconstrictors (hypoxia, hypercarbia, acidosis, cold, pain, alpha-agonist concentrated); - Norepinephrine + low-dose vasopressin for SBP support (less PVR effect); - Inotropes (milrinone, dobutamine); - TEE intraop guides; - Avoid fluid overload (RV failure); (5) Cesarean considerations: - Continuous regional (slow CSE or epidural extension) often preferred over GA + spinal; - Single-shot spinal AVOIDED (sudden sympathectomy); - GA with caution (laryngoscopy response avoid, gentle ventilation, RSI standard for OB); (6) Postpartum care — highest mortality first week postpartum; ICU 1-2 weeks; aggressive monitoring; (7) Anticoagulation considerations; (8) ECMO standby; (9) Multidisciplinary; (10) Modern: improved outcomes with PAH centers + multidisciplinary planning

---

Severe PHTN + pregnancy: multidisciplinary PAH center, continuous epidural over spinal, pulmonary vasodilator continuation, avoid pulmonary vasoconstrictors, norepi + vasopressin, ICU postpartum, ECMO standby.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 35 ปี G2P1 GA 28 wk severe pulmonary HTN (mean PAP 50)
Dyspnea NYHA III, RV dysfunction
Obstetric anesthesia consult — delivery planning';

update public.mcq_questions
set choices = '[{"label":"A","text":"Standard induction"},{"label":"B","text":"Post-tonsillectomy bleed"},{"label":"C","text":"Wait + observe bleeding"},{"label":"D","text":"Discharge"},{"label":"E","text":"No fluid resuscitation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-tonsillectomy bleed — pediatric emergency: (1) Full stomach (swallowed blood) + hypovolemic + uncooperative; airway emergency; (2) Pre-op: - Resuscitate IV fluid (NS 20 mL/kg bolus + repeat as needed); - Type + cross + transfuse if Hb low; - NG tube avoid (may worsen bleeding + uncomfortable); - Suction ready (multiple Yankauers); - Position lateral or head-down to drain blood; - Difficult airway equipment ready (multiple ETT sizes, video laryngoscope, surgical airway); - ENT scrubbed + ready in OR; (3) Induction options: - RSI with cricoid pressure (but cricoid may dislodge clot); - Modified RSI; - Inhalational induction lateral position (if child uncooperative or no IV) — but full stomach concern; - Awake intubation difficult in child; (4) Drugs: - Ketamine 1-2 mg/kg (CV stable in hypovolemia) OR propofol low-dose; - Rocuronium 1.2 mg/kg or succinylcholine 1-2 mg/kg; - Etomidate alternative; (5) Intubation challenges: - Blood obscuring view; - Suction ready; - Video laryngoscopy + bougie helpful; - Smaller ETT if airway edematous; - SGA backup if difficult; (6) Confirm placement, suction stomach with OG; (7) Maintain fluid resuscitation, transfusion as needed; (8) ENT control bleeding — re-cautery, surgical control; (9) Extubation — fully awake, suction, head-down/lateral, equipment ready (may need re-intubation); (10) Post-op observation 24h+; (11) Most secondary bleeds resolve with intervention; mortality rare but real

---

Pediatric tonsil bleed: hypovolemia + full stomach + difficult airway. Resuscitate, RSI with ketamine + rocuronium/sux, multiple suction, video laryngoscopy, ENT ready, awake extubation. 24h observation.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'เด็กชาย 8 ปี 25 kg — emergency tonsil bleed 6h post-tonsillectomy
Active bleeding, swallowed unknown amount
Tachycardia 130, BP 95/55, sleepy + anxious
Full stomach + anticipated difficult airway';

update public.mcq_questions
set choices = '[{"label":"A","text":"GABA agonist"},{"label":"B","text":"Dexmedetomidine (Precedex)"},{"label":"C","text":"NMDA antagonist"},{"label":"D","text":"Beta-blocker"},{"label":"E","text":"Opioid agonist"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Dexmedetomidine (Precedex) — alpha-2 agonist: (1) Mechanism — selective alpha-2A receptor agonist (8× more selective than clonidine); acts in locus coeruleus → sedation; spinal cord → analgesia; sympathetic ganglia → sympatholysis; (2) Effects: - Sedation: arousable, mimics natural sleep (N3 stage), preserved respiration; - Analgesia: moderate; opioid-sparing; - Sympatholysis: BP + HR decrease (helpful + concerning); - Anxiolysis; - No significant respiratory depression (huge advantage); - Anti-shivering; - Anti-delirium properties; (3) Pharmacokinetics: - Loading: 1 mcg/kg over 10 min (optional — causes hypotension/bradycardia at fast load); - Infusion: 0.2-1.5 mcg/kg/hr titrated; - Onset 5-10 min, redistribution half-life 6 min, elimination 2-3 h; - Hepatic metabolism — adjust hepatic dysfunction; (4) Clinical uses: - ICU sedation (alternative to propofol/midazolam; less delirium); - Awake fiberoptic intubation (preserved respiration + cooperation); - MAC/procedural sedation; - Adjunct GA (reduces opioid + volatile); - Pediatric: pre-medication, MRI sedation, post-op (ED prevention); - Cardiac surgery (post-op sedation + delirium prevention); - Withdrawal management (alcohol, opioid); - PACU shivering; - Awake craniotomy; (5) Side effects: - Hypotension + bradycardia (especially with loading or in volume-depleted); - Rebound hypertension on abrupt discontinuation (rare); - Caution in heart block, severe LV dysfunction, hypovolemia; (6) Comparisons: - Clonidine — less selective, oral available, less ICU use; - Vs propofol: less respiratory depression, more bradycardia, less hypotension overall; less delirium; - Vs benzodiazepines: less delirium ICU; (7) Modern: increasing use ICU + perioperative; SPICE III, MIDEX, PRODEX trials

---

Dexmedetomidine: alpha-2A agonist. Sedation without respiratory depression. Analgesia + sympatholysis + anti-delirium. Hypotension/bradycardia side effects. ICU sedation, AFOI, peds premed, post-op, cardiac. Modern use expanding.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Basic science: dexmedetomidine pharmacology + clinical applications';

update public.mcq_questions
set choices = '[{"label":"A","text":"All patients aware"},{"label":"B","text":"Anesthetic depth monitoring + awareness"},{"label":"C","text":"Skip monitoring"},{"label":"D","text":"Ignore patient reports"},{"label":"E","text":"Deeper anesthesia always"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Anesthetic depth monitoring + awareness: (1) Awareness with recall — 0.1-0.2% routine, higher risk: trauma (1-2%), C-section under GA (1%), cardiac surgery (1%); (2) Risk factors: - TIVA without monitoring; - Light anesthesia; - Hemodynamic instability requiring lighter anesthesia; - History prior awareness; - Difficult airway/intubation (period of paralysis without anesthetic); - Drug error or equipment failure; - Patient factors: chronic opioid, alcohol, drug abuse; (3) Consequences: - Acute distress; - PTSD; - Lawsuit; (4) Monitoring: - Standard ASA monitoring + clinical signs (HR, BP, lacrimation, sweating, movement); - EEG processed: BIS (Bispectral Index) 0-100; target 40-60 anesthesia; > 60 risk awareness; below 40 deeper than necessary; - Entropy; - Narcotrend; - SedLine (patient state index); - Etc.; (5) BIS limitations: - Not perfect (some awake with low BIS, vice versa); - EMG artifact; - Drug-specific (ketamine + N2O may not correlate); - Some studies (B-Aware) showed reduction in awareness; others (B-Unaware) no difference vs end-tidal anesthetic monitoring in volatile cases; - Better in TIVA than volatile; (6) Prevention awareness: - Confirm anesthetic delivery (vapor on, infusion running, IV functional); - Adequate dose particularly for cases requiring lighter (cardiac, trauma); - End-tidal anesthetic monitoring during volatile; - BIS for high-risk + TIVA; - Avoid muscle relaxant unless necessary; - Premedication amnestic (midazolam); (7) Postop assessment — Modified Brice questionnaire; (8) Management awareness — acknowledge, reassure, debrief, psychiatric support, follow up; (9) ASA Awareness Practice Advisory; (10) Modern: routine BIS for TIVA + high-risk

---

Awareness: 0.1-0.2% routine, higher trauma/OB/cardiac. BIS 40-60 target. Limitations exist. Prevention: confirm delivery, adequate dose, end-tidal anesthetic + BIS high-risk, premedication. Modified Brice. PTSD risk.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Basic science: pharmacology of anesthetic depth monitoring (BIS, awareness)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Treat as cisgender"},{"label":"B","text":"Transgender patient"},{"label":"C","text":"Discriminate based on identity"},{"label":"D","text":"Out hormones without consent"},{"label":"E","text":"Refuse care"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Transgender patient — anesthesia care: (1) Respectful + affirming care: - Use chosen name + pronouns; - Privacy + dignity; - Knowledgeable team; - Non-judgmental; (2) Hormone therapy considerations: - Estrogen (trans women) — increased VTE risk (especially ethinyl estradiol; transdermal lower risk); some advocate hold 2-4 weeks pre-major surgery; others continue if mechanical + pharmacologic VTE prophylaxis; balance risk; - Testosterone (trans men) — increased polycythemia, lipid changes; usually continue perioperatively; - Anti-androgens (spironolactone) — hyperkalemia, hypotension; (3) Surgical procedures: - Gender-affirming surgery (top — mastectomy/breast augmentation; bottom — vaginoplasty, phalloplasty, metoidioplasty, hysterectomy, orchiectomy); - Specific anesthesia for each; (4) Anesthetic considerations general: - Standard except hormone considerations; - Avoid assumptions about anatomy; - Sensitive imaging requests; - Multimodal opioid-sparing standard; - DVT prophylaxis (especially long surgeries + estrogen); (5) Mental health: - Depression, anxiety, dysphoria; - Higher suicide risk historically — gender-affirming care reduces; - Postop emotional impact; - Support; (6) Reproductive considerations — fertility preservation discussion before some surgeries; (7) Documentation — legal name + chosen name, sex assigned + gender identity, anatomy as relevant; (8) Discrimination prevention — staff education, inclusive policies, EHR systems; (9) WPATH (World Professional Association Transgender Health) Standards of Care guideline; (10) Insurance + financial considerations historically barrier; (11) Pre-op clinic prep — sensitive intake, individualized plan

---

Transgender anesthesia: affirming care, hormone considerations (estrogen VTE risk), gender-affirming surgical needs, multimodal opioid-sparing, mental health support, WPATH guidelines, sensitive documentation, inclusive practice.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Integrative question: anesthesia care for transgender patient — surgical considerations + hormone therapy';

update public.mcq_questions
set choices = '[{"label":"A","text":"Accept all studies"},{"label":"B","text":"Critical appraisal RCT + evidence-based anesthesia"},{"label":"C","text":"Ignore evidence"},{"label":"D","text":"All studies equal"},{"label":"E","text":"Skip statistics"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Critical appraisal RCT + evidence-based anesthesia: (1) PICO question — Patient, Intervention, Comparator, Outcome — frame question; (2) Hierarchy of evidence: - Systematic reviews + meta-analyses (Level I); - RCTs (Level II); - Cohort studies (Level III); - Case-control (Level IV); - Case series + expert opinion (Level V); (3) RCT critical appraisal: - Randomization (true random + concealment); - Blinding (patients, providers, outcome assessors); - Intention-to-treat analysis; - Loss to follow-up < 20%; - Baseline characteristics balanced; - Outcome measures appropriate + valid; - Sample size + power; - Statistical significance + clinical significance; - Conflict of interest; - Funding source; (4) Internal validity (study design quality) vs external validity (generalizability); (5) Statistical considerations: - p < 0.05 = statistical significance (arbitrary cutoff); - Confidence intervals more informative; - Number Needed to Treat (NNT); - Effect size; - Multiple comparisons (Bonferroni correction); (6) Bias types: - Selection, performance, detection, attrition, reporting; - Industry-sponsored research bias toward positive results; (7) Common pitfalls: - Surrogate endpoints; - Composite outcomes; - Subgroup analyses post-hoc; - Underpowered; - Short follow-up; (8) Frameworks: - CONSORT for RCT reporting; - GRADE for evidence quality; - Cochrane Risk of Bias; (9) Translating evidence: - Strength of recommendation; - Patient values + preferences; - Resource considerations; - Local context; (10) Modern: pragmatic trials, large simple trials, registry-based RCTs, machine learning prediction; (11) Implementation science — closing evidence-practice gap; (12) Modern: open data, pre-registration, reproducibility

---

Evidence-based anesthesia: PICO, evidence hierarchy, RCT appraisal (randomization, blinding, ITT), internal vs external validity, statistical + clinical significance, CONSORT + GRADE, implementation science. Modern: pragmatic trials.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Integrative: research methodology + evidence-based anesthesia
Critical appraisal of trial — RCT shows new drug reduces PONV vs ondansetron';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue case"},{"label":"B","text":"Bezold-Jarisch reflex / cerebral hypoperfusion in beach chair position"},{"label":"C","text":"Decrease IV fluid"},{"label":"D","text":"Mass volatile increase"},{"label":"E","text":"Refuse position"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bezold-Jarisch reflex / cerebral hypoperfusion in beach chair position: (1) Beach chair position — venous pooling lower extremity + reduced venous return; (2) Cerebral perfusion concern — measure BP at brain level (subtract ~15-20 mmHg from arm BP for head level); MAP at brain target > 70-80; cerebral oximetry (NIRS) helpful; (3) Bezold-Jarisch reflex — paradoxical bradycardia + hypotension from inadequate venous return + ventricular mechanoreceptor activation; (4) Management: - Lower head of bed (return to supine); - IV fluid bolus; - Vasopressor (phenylephrine, ephedrine, norepinephrine); - Atropine for bradycardia (0.4-0.6 mg); - Reduce volatile if too deep; (5) Interscalene block effects — phrenic palsy (50-100%), Horner, hypotension less; not cause of this; (6) Other DDx beach chair: air embolism (CO2 capno drop), stroke, hypovolemia, deep anesthesia, vasovagal; (7) Prevention: gradual position change, compression stockings, adequate fluid loading, vasopressor pre-emptive, careful BP target at head level, cerebral oximetry, minimize hypotension; (8) POVL + stroke reports beach chair — important safety issue; (9) Modern: many advocate lateral decubitus alternative; cerebral oximetry monitoring; tight BP control

---

Beach chair: BP at brain level, Bezold-Jarisch reflex risk. Manage with position, fluid, vasopressor, atropine. NIRS helpful. Avoid hypotension. Lateral alternative.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 28 ปี healthy elective shoulder arthroscopy in beach chair position
GA + interscalene block + LMA
30 min into surgery, sudden BP drop 110/70 → 60/30, HR 50, EtCO2 stable';

update public.mcq_questions
set choices = '[{"label":"A","text":"Ignore + observe"},{"label":"B","text":"Post-cardiac surgery AFib management"},{"label":"C","text":"Aggressive cardioversion always"},{"label":"D","text":"Stop all medications"},{"label":"E","text":"Discharge home"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-cardiac surgery AFib management: (1) Common complication 20-40% post-cardiac surgery; peak day 2-3; (2) Rate control: - Beta-blocker (esmolol IV infusion or metoprolol 5 mg IV q5 min); - Calcium channel blocker (diltiazem 10-25 mg IV) if BB contraindicated; - Amiodarone bolus 150 mg + infusion (rate + rhythm); - Digoxin (slow onset, useful HF); (3) Rhythm control: - Hemodynamic instability — synchronized cardioversion 200J biphasic; - Stable — amiodarone (300 mg loading + 900 mg/24h); ibutilide alternative; - Cardiovert if < 48h onset (lower stroke risk); (4) Anticoagulation: - CHA2DS2-VASc score; - Anticoagulate if persistent > 48h (warfarin or DOAC); - Bridging if cardioversion + > 48h; - Balance with bleeding risk post-cardiac surgery; (5) Treat reversible causes: - Electrolytes (K, Mg) — K > 4, Mg > 2; - Hypoxia, acidosis; - Pain, anxiety; - Volume status; - Inflammation (corticosteroid evidence mixed); - Pulmonary embolism; - Pericardial effusion/tamponade; (6) Prevention: - Beta-blocker continuation; - Amiodarone prophylaxis (selected); - Magnesium; - Statin; - Minimize pump time + cross-clamp; - Atrial pacing; (7) Post-op care: - Echo if hemodynamic concern; - Continue rate/rhythm control 4-6 weeks; - Anticoagulation per stroke risk; (8) Modern: PREDICT-AF score; left atrial appendage occlusion at time of surgery (selected); thoracoscopic AF surgery

---

Post-cardiac surgery AFib: rate (BB, CCB, amio) ± rhythm control, anticoagulation per CHA2DS2-VASc, treat electrolytes/causes, prevention BB + amio. Common day 2-3.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 60 ปี post-CABG ICU day 3 — sudden AFib with rapid response
HR 145, BP 100/60, no chest pain, mild dyspnea
On beta-blocker post-op';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge ward"},{"label":"B","text":"Post-op pulmonary complications"},{"label":"C","text":"More opioid for breathing"},{"label":"D","text":"Bedrest no mobilization"},{"label":"E","text":"Ignore"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-op pulmonary complications: (1) DDx: atelectasis, pneumonia, pulmonary edema, ARDS, PE, aspiration, COPD exacerbation; (2) Atelectasis = most common (mild fever, basal findings, restrictive); treatment: - Incentive spirometry; - Mobilization; - Adequate pain control (multimodal allows deep breathing); - Bronchodilator if reactive airway; - PEEP/CPAP non-invasive; - Bronchoscopy if mucus plug; (3) Hospital-acquired pneumonia (HAP) — fever > 48h post-admission, infiltrate, leukocytosis, sputum; - Empiric antibiotics covering MRSA + Pseudomonas (vancomycin + cefepime/pip-tazo or carbapenem); - De-escalate per culture; (4) Aspiration pneumonia — risk factors: altered mental status, dysphagia, NG tube; treatment: antibiotic + supportive; (5) Acute respiratory failure: - O2 therapy (NC → mask → HFNC → NIV → invasive); - NIV (BiPAP) for COPD, CHF, hypercapnic respiratory failure; - HFNC (Optiflow) for hypoxemic respiratory failure (FLORALI); - Intubation criteria: severe hypoxia, fatigue, altered mental status, hemodynamic instability; (6) Lung-protective ventilation if intubated (TV 6 mL/kg IBW); (7) Prevention pulmonary complications: - Pre-op smoking cessation; - Multimodal opioid-sparing analgesia (allow deep breathing); - Regional anesthesia (thoracic epidural for thoracoabdominal); - Lung-protective intra-op ventilation; - Early mobilization; - Incentive spirometry training; - Chest PT; (8) Risk scores — ARISCAT for pulmonary complications; (9) ICU evaluation for refractory cases

---

Post-op pulmonary: atelectasis most common; DDx pneumonia, edema, PE. Treatment: O2, IS, mobilize, NIV/HFNC, pain control. Prevention: smoking cessation, regional, multimodal, lung-protective ventilation. ARISCAT.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 70 ปี — post-laparotomy day 1 ICU
RR 28 + accessory muscle use, SpO2 90% on 4L NC + bilateral basal crackles + decreased air entry
Fever 38.2°C, WBC 14k';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue cementation rapidly"},{"label":"B","text":"Bone Cement / Fat Embolism Syndrome"},{"label":"C","text":"Ignore"},{"label":"D","text":"More volatile"},{"label":"E","text":"Discharge"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bone Cement / Fat Embolism Syndrome: (1) Bone Cement Implantation Syndrome (BCIS) — during cementation + intramedullary pressurization → embolic + vasoactive release: hypoxia, hypotension, arrhythmia, cardiac arrest; risk: hip arthroplasty, vertebral surgery, intramedullary nailing; (2) Fat Embolism Syndrome — long bone fracture or instrumentation: 24-72h post-injury typically; triad: respiratory (hypoxia), neurologic (confusion), cutaneous (petechiae axilla/conjunctiva); diagnosis Gurd criteria; (3) Pulmonary embolism — thromboembolic; risk factor surgery + trauma; (4) Air embolism — sitting position, neuro/vascular surgery; (5) Common findings — sudden hypoxia + hypotension + EtCO2 drop (loss of pulmonary blood flow → V/Q mismatch); (6) Management: - 100% O2; - Stop trigger (pause cementation if not committed); - Vasopressor (norepinephrine, epinephrine); - Volume resuscitation; - Inotropic support; - TEE if available — see right heart strain, emboli, RV dysfunction; - Pulmonary vasodilator (inhaled NO) for severe RV failure; - ECMO for refractory; (7) Specific BCIS: - Pressurize femoral canal carefully; - Vacuum cement mixing; - Vent femoral canal during cementation; - Avoid in compromised cardiopulmonary patients; - Awareness in elderly hip fracture; (8) Differentiation: timing + procedure stage, clinical features; (9) Post-event: monitoring, ICU, repeat CXR/CT/echo, anticoagulation if PE confirmed

---

BCIS / fat embolism: sudden hypoxia + hypotension + EtCO2 drop during cementation/long-bone instrumentation. 100% O2, vasopressor, TEE if available, ECMO refractory. Prevention via cementation technique.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 35 ปี — orthopedic case left femur ORIF
During reaming + cementation: sudden BP drop 130/80 → 60/35, HR rise 80 → 130, SpO2 drop 99 → 78%, EtCO2 drop 40 → 22
No airway issues, no anaphylaxis features';

update public.mcq_questions
set choices = '[{"label":"A","text":"All vasopressors same"},{"label":"B","text":"Vasopressors + inotropes"},{"label":"C","text":"Dopamine first-line all"},{"label":"D","text":"Avoid all"},{"label":"E","text":"Use only orally"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Vasopressors + inotropes: (1) Norepinephrine — alpha-1 + beta-1; first-line septic shock (Surviving Sepsis); 0.01-1 mcg/kg/min; preferred over dopamine; (2) Epinephrine — alpha + beta; anaphylaxis first-line; cardiac arrest; refractory shock; 0.01-0.5 mcg/kg/min; (3) Phenylephrine — pure alpha-1; bolus 50-200 mcg; infusion; OB anesthesia (no neonatal acidosis); spinal hypotension; (4) Vasopressin — V1 receptor (non-catecholamine); 0.03-0.04 U/min adjunct in refractory shock; cardiac arrest 40U IV (no longer ACLS); useful in acidemic + refractory norepinephrine; (5) Dopamine — dose-dependent (low: dopaminergic — disproven for renal protection; mid: beta; high: alpha); largely replaced; (6) Dobutamine — beta-1 selective inotrope; cardiogenic shock; 2-20 mcg/kg/min; tachycardia + arrhythmia; (7) Milrinone — phosphodiesterase-3 inhibitor; inotrope + vasodilator; HF, pulmonary HTN, post-CPB; 0.25-0.75 mcg/kg/min; hypotension; (8) Levosimendan — Ca sensitizer; HF; not FDA approved; (9) Methylene blue — vasoplegia (post-CPB, sepsis refractory, anaphylaxis); 1-2 mg/kg; NOS inhibitor; (10) Angiotensin II (Giapreza) — refractory shock; ATHOS-3; (11) Selection: - Septic shock: norepi → vasopressin → epi/steroid; - Cardiogenic shock: norepi + dobutamine/milrinone; - Anaphylaxis: epinephrine; - OB: phenylephrine; - Cardiac arrest: epinephrine; (12) Considerations: receptor profile, side effects (arrhythmia, peripheral ischemia, hyperglycemia), tachyphylaxis, route (central vs peripheral)

---

Vasopressors: norepi (septic, first-line), epi (anaphylaxis, arrest), phenylephrine (OB), vasopressin (refractory adjunct), dobutamine/milrinone (inotrope), dopamine (largely replaced), methylene blue (vasoplegia). Receptor-based selection.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Basic science: pharmacology of vasopressors + inotropes';

commit;
