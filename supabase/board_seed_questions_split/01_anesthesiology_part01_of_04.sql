-- ===============================================================
-- หมอรู้ — Board seed: วิสัญญีวิทยา (anesthesiology) — part 1/4 (50 MCQs)
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
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 68 ปี underlying HT, T2DM, CAD post-PCI 2 ปีที่แล้ว — pre-op evaluation for elective open AAA repair

Functional capacity: 4 METs (can walk up stairs)
Meds: aspirin, atorvastatin, metoprolol, enalapril, metformin
No angina + no recent CHF + no arrhythmia
Lab: HbA1c 7.2%, Cr 1.2, normal CBC, BUN
EKG: old Q wave inferior, no acute changes
Echo: LVEF 50% with mild inferior hypokinesia', '[{"label":"A","text":"Cancel surgery"},{"label":"B","text":"Continue chronic medications"},{"label":"C","text":"Cardiac catheterization preoperative"},{"label":"D","text":"Stop all medications"},{"label":"E","text":"Refuse surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pre-op cardiac evaluation per AHA/ACC 2014 + ESC 2022 — High-risk surgery (vascular) + intermediate risk patient: (1) RCRI = 2 (CAD + DM on insulin if applicable, or here CAD + high-risk surgery) — intermediate risk (2-2.4%); (2) Functional capacity ≥ 4 METs adequate; (3) **Continue chronic medications**: aspirin (continue per surgical bleeding risk — vascular usually continue), statin (continue — cardioprotective, mortality benefit), beta-blocker (continue — sudden discontinuation harmful); ACE inhibitor — hold morning of surgery (hypotension intra-op); metformin — hold day of surgery (lactic acidosis risk if AKI); (4) **No additional stress testing** indicated (functional capacity OK); (5) **Pre-op consultation as needed**: cardiology if symptoms or new abnormalities; (6) Glycemic control: target intra-op 140-180; (7) Anesthetic plan: epidural for analgesia (open AAA), general anesthesia, invasive monitoring (arterial line, CVL), aortic cross-clamp considerations, cell saver, blood products available, temperature management; (8) Multidisciplinary: surgery + anesthesia + cardiology if needed; (9) Post-op: ICU monitoring, pain control, continue beta-blocker + statin, DVT prophylaxis, hyperglycemia management

---

Pre-op cardiac evaluation: AHA/ACC 2014 stepwise approach. RCRI + functional capacity. Continue chronic medications (beta-blocker, statin) — sudden discontinuation harmful. Hold ACE inhibitor day of surgery. Metformin caution AKI. No additional stress test if functional capacity adequate. Pre-op coronary revascularization not routinely beneficial (CARP trial). Anesthetic plan + ICU monitoring.', NULL,
  'medium', 'cardiovascular', 'review',
  'anesthesiology', 'clinical_decision', 'cardiovascular', 'adult',
  'AHA/ACC Perioperative Guidelines 2014; ESC/ESA 2022', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยอายุ 68 ปี underlying HT, T2DM, CAD post-PCI 2 ปีที่แล้ว — pre-op evaluation for elective open AAA repair

Functional capacity: 4 METs (can walk up stairs)
Meds: aspirin, atorvastatin, metoprolol, enalapril, metformin
No angina + no recent CHF + no arrhythmia
Lab: HbA1c 7.2%, Cr 1.2, normal CBC, BUN
EKG: old Q wave inferior, no acute changes
Echo: LVEF 50% with mild inferior hypokinesia'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี underlying obesity BMI 38, OSA on CPAP, hypertension — undergoing elective laparoscopic cholecystectomy

Mallampati class IV, thyromental distance 5 cm, limited neck extension, large neck circumference 45 cm, beard

Predicts difficult airway', '[{"label":"A","text":"Standard induction without preparation"},{"label":"B","text":"Difficult Airway Management — pre-op preparation"},{"label":"C","text":"Blind nasotracheal"},{"label":"D","text":"Surgery without intubation"},{"label":"E","text":"Refuse case"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Difficult Airway Management — pre-op preparation: (1) **Predict difficult airway**: LEMON (Look, Evaluate 3-3-2, Mallampati, Obstruction, Neck mobility), MOANS (Mask, Obese, Age, No teeth, Stiff lungs); (2) **Multimodal preparation**: 2 difficult airway providers available, multiple equipment options ready; (3) **Pre-oxygenation thoroughly** (3-5 min FRC washout or 8 vital capacity breaths); high-flow nasal O2 during apnea (THRIVE — Transnasal Humidified Rapid Insufflation Ventilatory Exchange); (4) **Awake fiberoptic intubation** preferred for known/predicted difficult airway — sedation (dexmedetomidine, remifentanil), topical anesthesia (lidocaine spray/nebulized/atomized), supplemental O2; (5) **Video laryngoscopy** (GlideScope, McGrath, C-MAC) — better view + first-attempt success; (6) **Supraglottic airway** (LMA Fastrach, iGel, AirQ — conduit for ETT) — backup or primary; (7) **DAS (Difficult Airway Society) algorithm**: Plan A (intubation) → Plan B (SGA) → Plan C (face mask ventilation) → Plan D (emergency front of neck access — cricothyrotomy, surgical airway); (8) **Equipment ready**: bougie, multiple ETT sizes + types, multiple laryngoscope blades, SGA, fiberscope, cricothyrotomy kit; (9) **Communication + team**: brief plan + contingencies; (10) **Avoid prolonged hypoxia**: limit attempts (3 max), maintain oxygenation between attempts, wake patient if unable to intubate or ventilate ("awaken" option); (11) **OSA considerations**: continue CPAP intra-op (some surgeries) + post-op; (12) **Documentation** of difficult airway + future planning

---

Difficult airway management: prediction (LEMON, MOANS) + preparation. Awake fiberoptic intubation preferred for known/predicted. Video laryngoscopy improves first-pass success. DAS algorithm: Plan A→B→C→D. Equipment ready. Team communication. Limit attempts (3). Awaken option. OSA continuation CPAP. Documentation. Modern: video laryngoscopy widespread + DAS algorithm.', NULL,
  'medium', 'respiratory', 'review',
  'anesthesiology', 'clinical_decision', 'respiratory', 'adult',
  'ASA Difficult Airway Guidelines; Difficult Airway Society UK', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี underlying obesity BMI 38, OSA on CPAP, hypertension — undergoing elective laparoscopic cholecystectomy

Mallampati class IV, thyromental distance 5 cm, limited neck extension, large neck circumference 45 cm, beard

Predicts difficult airway'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 28 ปี healthy elective knee arthroscopy under spinal anesthesia (bupivacaine 10mg) + epinephrine

Procedure: 45 min, uneventful
Post-op: patient develops perioral numbness then dizziness then tinnitus then mental status changes then seizure

UDS negative, no other drug exposure
LA accidentally given IV vs spinal in error', '[{"label":"A","text":"Wait + see"},{"label":"B","text":"Local Anesthetic Systemic Toxicity (LAST) — life-threatening complication of LA"},{"label":"C","text":"Calcium gluconate only"},{"label":"D","text":"Surgery"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Local Anesthetic Systemic Toxicity (LAST) — life-threatening complication of LA: (1) **CNS symptoms first** (lower threshold than CV): perioral numbness → tinnitus → metallic taste → dizziness → AMS → seizure → coma; (2) **CV later** (higher threshold): hypotension → arrhythmia (bradycardia, ventricular) → cardiac arrest; (3) **Bupivacaine cardiac toxicity** worst — high lipid solubility + sodium channel blockade — refractory to standard ACLS; (4) **Immediate management** (ASRA Checklist 2017): - Call for help + LAST checklist + lipid emulsion; - Airway/breathing: 100% O2, hyperventilate to alkalosis (improves CV outcome); - Stop LA delivery if ongoing; - Seizure: benzodiazepine (lorazepam, midazolam) preferred over propofol (propofol may further reduce CV function); - **Lipid emulsion 20% (Intralipid)** — first-line for cardiotoxicity: 1.5 mL/kg IV bolus over 1 min (~100 mL adult) → infusion 0.25 mL/kg/min × 30 min minimum; repeat bolus + double infusion if needed; max 12 mL/kg total; mechanism — lipid sink + metabolic; (5) **Modified ACLS** for cardiac arrest: chest compressions, lipid emulsion priority over epinephrine (small doses 1 mcg/kg if needed — high-dose epi may worsen); AVOID vasopressin, beta-blocker, Ca channel blocker, LA (lidocaine); (6) **Cardiopulmonary bypass / ECMO** for refractory arrest; (7) **Prolonged resuscitation** (> 1 hour) — case reports of survival; (8) **Prevention**: aspiration test before injection, slow incremental injection, ultrasound guidance, test dose with epinephrine; appropriate dose for weight (max 2-3 mg/kg bupivacaine); (9) **Document + report** — quality improvement

---

LAST = life-threatening LA complication. Mortality high if not recognized. CNS symptoms first → CV later. Bupivacaine cardiotoxicity worst. **Lipid emulsion 20% first-line treatment** (cornerstone). ASRA Checklist. Avoid vasopressin, beta-blocker, CCB, LA. Lipid sink mechanism. Prevention: ultrasound, aspiration test, test dose, max dose. Modern: lipid emulsion saved many lives.', NULL,
  'medium', 'toxicology', 'review',
  'anesthesiology', 'clinical_decision', 'toxicology', 'adult',
  'ASRA LAST Checklist 2017; Neal JM et al. Reg Anesth Pain Med', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยอายุ 28 ปี healthy elective knee arthroscopy under spinal anesthesia (bupivacaine 10mg) + epinephrine

Procedure: 45 min, uneventful
Post-op: patient develops perioral numbness then dizziness then tinnitus then mental status changes then seizure

UDS negative, no other drug exposure
LA accidentally given IV vs spinal in error'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 32 ปี G2P1 GA 39 wk elective C-section under spinal anesthesia + bupivacaine + morphine + fentanyl

5 min after spinal: BP drops 90/60 → 70/40, HR drops 92 → 55, patient nauseous

Fetal heart 142 stable', '[{"label":"A","text":"Wait + observe"},{"label":"B","text":"Post-Spinal Anesthesia Hypotension (Sympathectomy + IVC compression by gravid uterus)"},{"label":"C","text":"Supine flat position"},{"label":"D","text":"Reduce fluid"},{"label":"E","text":"Stop monitoring"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-Spinal Anesthesia Hypotension (Sympathectomy + IVC compression by gravid uterus): (1) **Left lateral tilt** (Wedge under right hip) — relieves IVC compression by gravid uterus, improves venous return; (2) **IV fluid co-loading** during spinal (better than pre-loading) — crystalloid + colloid; (3) **Vasopressor**: - **Phenylephrine** first-line (alpha-1 agonist — restores SVR + reflex bradycardia rare in OB); start prophylactic infusion 25-50 mcg/min; rescue bolus 50-100 mcg; - **Norepinephrine** alternative (alpha + mild beta — less bradycardia than phenylephrine; growing use); - **Ephedrine** (mixed alpha-beta) — historic first-line but causes neonatal acidosis more than phenylephrine (Ngan Kee); (4) **Bradycardia**: atropine 0.4-0.6 mg if symptomatic + hypotensive; (5) **Oxygen supplementation**; (6) **Nausea management**: ondansetron, metoclopramide; (7) **Monitor fetal heart** — fetal hypoxia risk from maternal hypotension; (8) **Prevention**: prophylactic phenylephrine infusion from time of spinal (mainstay modern OB anesthesia per Ngan Kee + Carvalho); left lateral tilt; fluid; (9) **Other causes of hypotension during C-section**: hemorrhage (placenta previa, abruption, atony), uterine inversion, amniotic fluid embolism, anaphylaxis, supine hypotensive syndrome; (10) Multidisciplinary: OB + anesthesia + neonatal team

---

Post-spinal hypotension common in OB (sympathectomy + IVC compression). Left lateral tilt + IV fluid co-loading + phenylephrine prophylactic infusion = standard care. Modern: phenylephrine > ephedrine (better fetal pH). Norepinephrine emerging alternative. Bradycardia atropine. Fetal monitoring. Prevention better than treatment.', NULL,
  'medium', 'obgyn', 'review',
  'anesthesiology', 'clinical_decision', 'obgyn', 'adult',
  'ASRA Recommendations; Ngan Kee WD Anesthesiology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยอายุ 32 ปี G2P1 GA 39 wk elective C-section under spinal anesthesia + bupivacaine + morphine + fentanyl

5 min after spinal: BP drops 90/60 → 70/40, HR drops 92 → 55, patient nauseous

Fetal heart 142 stable'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 14 ปี healthy elective tonsillectomy under general anesthesia

30 min into surgery — temp rises rapidly 39.8°C → 40.5°C, HR 140, EtCO2 rising 35 → 55 mmHg despite increasing ventilation, muscle rigidity especially masseter, mottled skin, dark urine starts appearing

Using volatile (sevoflurane) + succinylcholine for intubation

Family: cousin died during dental surgery years ago', '[{"label":"A","text":"Increase volatile anesthetic"},{"label":"B","text":"Malignant Hyperthermia (MH) — rare life-threatening complication: triggered by volatile anesthetics + succinylcholine in genetically susceptible (RYR1, CACNA1S mutations — autosomal dominant)"},{"label":"C","text":"Wait + observe"},{"label":"D","text":"Increase muscle relaxant"},{"label":"E","text":"Stop monitoring"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Malignant Hyperthermia (MH) — rare life-threatening complication: triggered by volatile anesthetics + succinylcholine in genetically susceptible (RYR1, CACNA1S mutations — autosomal dominant): (1) **Stop triggering agents** immediately — volatile + succinylcholine; switch to non-triggering (propofol, opioid, NMB rocuronium/cisatracurium); change anesthesia circuit + soda lime + ventilator; (2) **Hyperventilate 100% O2** at 10 L/min minimum to flush volatile; (3) **Dantrolene** — specific antidote — 2.5 mg/kg IV bolus, repeat every 5-10 min up to 10 mg/kg total; dantrolene blocks RYR1 + decreases muscle Ca release; new formulation (Ryanodex) faster reconstitution; (4) **Active cooling**: cold IV fluids, ice packs to groin/axillae/neck, cooling blankets, peritoneal/gastric lavage with cold saline if severe; STOP at 38-38.5°C to avoid overshoot hypothermia; (5) **Treat acidosis**: bicarbonate, hyperventilation; (6) **Treat hyperkalemia**: insulin + glucose, Ca, kayexalate; (7) **Treat arrhythmias**: standard ACLS — but AVOID calcium channel blockers (interact with dantrolene); (8) **Monitor + treat rhabdomyolysis**: IV fluid, alkalinize urine (urine output > 2 mL/kg/hr), monitor CK + myoglobin + AKI; (9) **ICU admission** for at least 24-48 hours — recrudescence risk; continue dantrolene 1 mg/kg q6h × 24h; (10) **Counsel family** — autosomal dominant, family screening with muscle biopsy/in vitro contracture test or genetic testing; future surgeries need non-triggering anesthetic + MH precautions; (11) **MH Hotline** (US 1-800-MH-HYPER) — expert consultation; **MHAUS** (Malignant Hyperthermia Association)

---

MH = anesthetic emergency. Triggered by volatile anesthetics + succinylcholine. Autosomal dominant (RYR1, CACNA1S). Hypermetabolic crisis. Dantrolene is specific antidote. Active cooling. Treat acidosis, hyperkalemia, rhabdo. ICU recrudescence risk. Family screening. Avoid CCB (interact). Modern: Ryanodex (faster dantrolene). MHAUS expert consultation. Modern mortality < 5% with prompt treatment (was > 70%).', NULL,
  'hard', 'endocrine_metabolic', 'review',
  'anesthesiology', 'clinical_decision', 'endocrine_metabolic', 'peds',
  'MHAUS Guidelines; ASA Practice Advisory', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยอายุ 14 ปี healthy elective tonsillectomy under general anesthesia

30 min into surgery — temp rises rapidly 39.8°C → 40.5°C, HR 140, EtCO2 rising 35 → 55 mmHg despite increasing ventilation, muscle rigidity especially masseter, mottled skin, dark urine starts appearing

Using volatile (sevoflurane) + succinylcholine for intubation

Family: cousin died during dental surgery years ago'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 45 ปี elective laparoscopic cholecystectomy under general anesthesia

15 min after IV abx (cefazolin): BP drops 130/80 → 60/30, HR rises 80 → 130, urticaria + flushing chest + wheezing + difficulty ventilating with high airway pressure + bronchospasm

Using propofol + remifentanil + sevoflurane + rocuronium + cefazolin', '[{"label":"A","text":"Continue case"},{"label":"B","text":"Intraoperative Anaphylaxis — anesthesia emergency"},{"label":"C","text":"Antibiotic again"},{"label":"D","text":"Continue propofol"},{"label":"E","text":"Discharge to PACU"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Intraoperative Anaphylaxis — anesthesia emergency: (1) **Immediate**: notify team, call for help, stop suspected trigger (cefazolin most likely, also rocuronium common); (2) **Epinephrine first-line**: 100-200 mcg IV bolus + repeat every 1-2 min as needed; severe — IV infusion 1-10 mcg/min titrated; (3) **Airway + ventilation**: 100% O2, may need increased PEEP for severe bronchospasm; consider salbutamol nebulizer; (4) **Volume resuscitation**: IV crystalloid 20-30 mL/kg rapid (distributive shock + capillary leak); colloid alternative; (5) **Reverse Trendelenburg or position to optimize venous return**; (6) **Secondary medications**: H1 antihistamine (diphenhydramine 50 mg IV), H2 antihistamine (ranitidine 50 mg IV), corticosteroid (hydrocortisone 200 mg IV or methylprednisolone 1-2 mg/kg) — prevent biphasic + late-phase; (7) **Glucagon** 1-5 mg IV if on beta-blocker (epinephrine-refractory); (8) **Refractory shock**: norepinephrine, vasopressin, methylene blue (selected); ECMO last resort; (9) **Consider whether to continue or abort surgery** — case-by-case based on stability + necessity; (10) **Post-event**: tryptase level (within 1-3h), document trigger, follow-up allergy testing + skin testing (4-6 weeks later for accurate); medic-alert; (11) **Documentation** for future anesthesia care; (12) **Differential**: hemorrhage, PE, MI, pneumothorax, MH, sepsis; (13) **Most common triggers**: NMB (rocuronium most), antibiotics (cefazolin, vancomycin), latex, chlorhexidine, contrast, blood products; (14) Multidisciplinary: anesthesia + surgery + allergy follow-up

---

Intraoperative anaphylaxis: anesthesia emergency. Most common triggers: NMB, antibiotics, latex. Epinephrine first-line. Volume resuscitation. Secondary meds (antihistamine, steroid). Glucagon for beta-blocker users. Tryptase level for confirmation. Future testing + documentation. Multidisciplinary care.', NULL,
  'medium', 'toxicology', 'review',
  'anesthesiology', 'clinical_decision', 'toxicology', 'adult',
  'ASA + AAAAI + WAO Practice Parameter on Anesthetic Anaphylaxis', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยอายุ 45 ปี elective laparoscopic cholecystectomy under general anesthesia

15 min after IV abx (cefazolin): BP drops 130/80 → 60/30, HR rises 80 → 130, urticaria + flushing chest + wheezing + difficulty ventilating with high airway pressure + bronchospasm

Using propofol + remifentanil + sevoflurane + rocuronium + cefazolin'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 72 ปี G2P2 elective open hysterectomy under general anesthesia

Post-op PACU: alert + cooperative initially → at 2 hours becomes confused, agitated, inattention, hallucinations, hyperactive, attempting to remove IV + Foley

No prior delirium history, no dementia, no substance use
V/S: BP 142/85, HR 95, Temp 37.4°C, SpO2 96%
Lab: electrolytes normal, glucose 145, no infection signs', '[{"label":"A","text":"Discharge home"},{"label":"B","text":"Postoperative Delirium (POD) — common in elderly post-surgical"},{"label":"C","text":"Restraint"},{"label":"D","text":"Long-acting benzo"},{"label":"E","text":"Ignore"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Postoperative Delirium (POD) — common in elderly post-surgical: (1) **Identify + treat underlying causes** (multifactorial): - **Pain** (under or over-treated); - **Medications** (opioid, benzodiazepine, anticholinergic — Beers list); - **Hypoxia** (assess oxygenation); - **Electrolyte derangement** (Na, glucose, Ca, Mg); - **Infection** (UTI, pneumonia, line, surgical site); - **Constipation/urinary retention**; - **Sleep deprivation**; - **Withdrawal** (alcohol, benzo, nicotine); - **CNS event** (stroke, seizure); (2) **Non-pharmacologic management (cornerstone)**: - Re-orient frequently (clock, calendar, names); - Family presence + familiar objects; - Hearing aids + glasses; - Sleep-wake cycle (lighting, noise); - Minimize tethers (lines, restraints, Foley) — remove ASAP; - Mobility (sit up, walk); - Hydration; - Multimodal pain control reduce opioid; (3) **Pharmacologic (sparingly + low-dose)** — only for severe agitation/danger to self: low-dose haloperidol 0.25-0.5 mg or quetiapine 12.5-25 mg; AVOID benzodiazepines (worsen — except alcohol/benzo withdrawal); AVOID anticholinergic; (4) **Multidisciplinary**: anesthesia, surgery, geriatric medicine, nursing, family; (5) **HELP (Hospital Elder Life Program)** prevention bundle; (6) **Prevention** going forward: pre-op cognitive screening (Mini-Cog), Beers Criteria deprescribing, hearing/vision aids; (7) **Long-term outcomes**: persistent cognitive impairment possible, increased mortality + functional decline + LTC placement risk; (8) **Family education** + reassurance

---

Postoperative delirium common in elderly. Multifactorial. Non-pharm management primary. Identify + treat causes. Pharmacologic for severe agitation only (low-dose antipsychotic). AVOID benzodiazepines, anticholinergics. HELP program. Long-term consequences. Family + multidisciplinary care. Prevention through pre-op screening + multimodal anesthesia + minimal opioids.', NULL,
  'easy', 'neurology', 'review',
  'anesthesiology', 'clinical_decision', 'neurology', 'adult',
  'ASA + APSF + AGS POD Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยอายุ 72 ปี G2P2 elective open hysterectomy under general anesthesia

Post-op PACU: alert + cooperative initially → at 2 hours becomes confused, agitated, inattention, hallucinations, hyperactive, attempting to remove IV + Foley

No prior delirium history, no dementia, no substance use
V/S: BP 142/85, HR 95, Temp 37.4°C, SpO2 96%
Lab: electrolytes normal, glucose 145, no infection signs'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 28 ปี healthy female elective lap chole + general anesthesia

Post-op: severe persistent nausea + vomiting × 6 hours despite IV ondansetron 4mg + IV metoclopramide 10mg

Mild + moderate hypotension + slightly dehydrated', '[{"label":"A","text":"Discharge with oral medications"},{"label":"B","text":"Post-Operative Nausea + Vomiting (PONV) — common after general anesthesia + abdominal surgery"},{"label":"C","text":"Surgery again"},{"label":"D","text":"Ignore"},{"label":"E","text":"Long-acting opioid"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-Operative Nausea + Vomiting (PONV) — common after general anesthesia + abdominal surgery: (1) **Identify risk factors** (Apfel score 4 points — female + non-smoker + history of motion sickness/PONV + post-op opioids): - Female (highest risk); - Non-smoker; - Prior PONV/motion sickness; - Post-op opioids; (2) **Multimodal antiemetic prevention** for at-risk (≥ 2 factors): combine multiple classes — - 5-HT3 antagonist (ondansetron, granisetron, palonosetron — long-acting); - Dexamethasone (4-8 mg pre-induction); - Droperidol or haloperidol (D2 antagonist — QTc precaution); - Aprepitant (NK1 antagonist) — long-acting + effective; - Scopolamine patch (anticholinergic — placed > 2h pre-op); - Anti-histamine (promethazine, diphenhydramine); (3) **Rescue if PONV develops**: use different class than prophylaxis (since same class fails again); often combinations needed; (4) **Non-pharmacologic**: acupressure P6 (Neiguan point — wristbands), ginger, aromatherapy (isopropyl alcohol pads — limited evidence), hydration; (5) **Anesthetic technique adjustments**: TIVA with propofol (less PONV vs volatile), regional + neuraxial anesthesia, minimize opioids (multimodal pain), gastric decompression, avoid nitrous oxide; (6) **Hydration adequate**: IV crystalloid; (7) **Refractory PONV**: combinations of multiple classes + steroids + dexmedetomidine; (8) **Patient comfort**: significant patient satisfaction issue + can delay discharge + readmission risk; (9) Multidisciplinary: anesthesia + surgery + PACU + outpatient

---

PONV common — multifactorial. Apfel score + risk factors. Multimodal antiemetic prevention. Rescue with different class. Non-pharmacologic adjuncts. Anesthetic technique adjustments. TIVA + regional anesthesia reduce PONV. Avoid nitrous oxide. Hydration. Modern: prophylaxis with multiple classes routinely.', NULL,
  'easy', 'gi', 'review',
  'anesthesiology', 'clinical_decision', 'gi', 'adult',
  'Society for Ambulatory Anesthesia Consensus Guidelines for PONV 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยอายุ 28 ปี healthy female elective lap chole + general anesthesia

Post-op: severe persistent nausea + vomiting × 6 hours despite IV ondansetron 4mg + IV metoclopramide 10mg

Mild + moderate hypotension + slightly dehydrated'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี post-knee arthroplasty Day 1 — uncontrolled severe pain despite IV morphine + oral oxycodone — pain VAS 8-9/10

Request assistance for pain management', '[{"label":"A","text":"Higher dose opioid"},{"label":"B","text":"Multimodal Post-Operative Analgesia — Opioid-Sparing"},{"label":"C","text":"Discharge with oral opioid"},{"label":"D","text":"Ignore pain"},{"label":"E","text":"Surgery again"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Multimodal Post-Operative Analgesia — Opioid-Sparing: (1) **Reassess + diagnose**: rule out complications (compartment syndrome, infection, hematoma, nerve injury); (2) **Multimodal foundation**: - Scheduled acetaminophen 1 g IV/PO q6h (max 4 g/day); - NSAID (ketorolac 15-30 mg IV q6h max 5 days; or celecoxib 200 mg BID — caution renal, CV, GI); - Gabapentin or pregabalin (50-300 mg TID, dose adjust); - Ketamine low-dose infusion (0.1-0.3 mg/kg/hr) — opioid-sparing + anti-hyperalgesic; - Dexamethasone single dose (anti-inflammatory + antiemetic + analgesic); (3) **Regional anesthesia** considerations: - Femoral nerve block (best knee analgesia but motor weakness — fall risk); - Adductor canal block (preferred — preserves quadriceps strength + good analgesia); - Continuous catheter for prolonged effect; - Liposomal bupivacaine local infiltration (LIA — long-acting 72h); - Periarticular injection by surgeon; (4) **Ice + elevation + position**; (5) **Opioid as adjunct** (lower dose with multimodal): PCA (Patient-Controlled Analgesia), oral as transition; tramadol — caution interactions; avoid long-acting opioid PRN initially; (6) **Non-pharmacologic**: PT, mobility, distraction, mindfulness, music; (7) **Psychological**: chronic post-surgical pain risk — early intervention if catastrophizing, anxiety, depression; (8) **Discharge planning**: minimize discharge opioids (modern epidemic concerns), continue acetaminophen + NSAID schedule, taper opioid quickly, follow-up; (9) **Multidisciplinary**: anesthesia (pain service), surgery, nursing, PT, psychology; (10) **Pain at rest vs activity**: differentiate

---

Multimodal post-op analgesia = standard. Opioid-sparing through multiple mechanisms (acetaminophen + NSAID + gabapentinoid + ketamine + regional + steroid + non-pharm). Regional anesthesia (adductor canal for knee). Opioid PCA + oral as adjunct, minimize discharge prescription. Modern: addressing opioid epidemic. Multidisciplinary pain management.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'anesthesiology', 'clinical_decision', 'msk_nontrauma', 'adult',
  'AAPM + APS + ASA + ERAS Pain Management Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี post-knee arthroplasty Day 1 — uncontrolled severe pain despite IV morphine + oral oxycodone — pain VAS 8-9/10

Request assistance for pain management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 25 ปี G1P0 GA 40 wk in active labor at 6cm + epidural catheter placed for labor analgesia + bolus dose given

10 min later: patient mentions difficulty breathing + speaking + then becomes mute + diaphoretic + hypotensive + bradycardic + dilated pupils + fully alert mental status (yet)

Unable to elevate arms or push', '[{"label":"A","text":"Wait + observe"},{"label":"B","text":"High/Total Spinal — accidental intrathecal injection of epidural dose causing extensive sensory + motor + sympathetic block"},{"label":"C","text":"Increase epidural"},{"label":"D","text":"Discharge"},{"label":"E","text":"Refuse intervention"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** High/Total Spinal — accidental intrathecal injection of epidural dose causing extensive sensory + motor + sympathetic block: (1) **Immediate** — call for help, OR/anesthesia, OB ready for emergency C-section; (2) **Airway + breathing**: respiratory compromise from intercostal + phrenic nerve block; intubate immediately if hypoxic/apneic; bag-mask ventilate; (3) **Cardiovascular**: profound hypotension + bradycardia from sympathectomy + cardiac accelerator block (T1-T4); aggressive IV fluid + vasopressors (phenylephrine or norepinephrine; epinephrine for bradycardia/cardiac arrest); atropine for bradycardia; (4) **Position**: avoid Trendelenburg (LA distribution worse + decreases venous return paradoxically); slight head up if possible; left lateral tilt to relieve IVC compression; (5) **Maintain fetal oxygenation**: maternal stability + position; fetal monitoring; (6) **Decision regarding delivery**: stable mother — continue monitoring; non-reassuring fetal status or unable to recover — emergency C-section under general (since spinal already in place but may not be effective if too high); (7) **Post-event**: monitor for prolonged block, document, debrief team; (8) **Cause**: catheter migration into intrathecal space, large bolus accidentally intrathecal, no test dose recognition; (9) **Prevention**: test dose for catheter placement (epinephrine), incremental dosing, aspiration before each bolus, observe for signs of intrathecal injection (rapid block onset, motor block, hypotension); (10) **Differential**: amniotic fluid embolism, eclampsia, anaphylaxis, LAST, pulmonary edema; (11) Multidisciplinary: anesthesia + OB + neonatal + nursing

---

High/Total spinal = accidental intrathecal injection of epidural dose. Anesthesia emergency. Respiratory + CV compromise. Immediate intubation + ventilation if needed. Aggressive vasopressor + fluid + atropine. Left lateral tilt. Fetal monitoring + emergency delivery if needed. Prevention: test dose, aspirate, incremental dosing. Modern: ultrasound-guided neuraxial reduces risk.', NULL,
  'hard', 'obgyn', 'review',
  'anesthesiology', 'clinical_decision', 'obgyn', 'adult',
  'SOAP Practice Guidelines; ASA Anesthesia for Obstetrics', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยอายุ 25 ปี G1P0 GA 40 wk in active labor at 6cm + epidural catheter placed for labor analgesia + bolus dose given

10 min later: patient mentions difficulty breathing + speaking + then becomes mute + diaphoretic + hypotensive + bradycardic + dilated pupils + fully alert mental status (yet)

Unable to elevate arms or push'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ICU patient post-cardiac surgery on mechanical ventilation needing sedation + analgesia for 5 days

คำถาม: sedation + delirium prevention in ICU', '[{"label":"A","text":"Continuous benzodiazepine"},{"label":"B","text":"Daily sedation interruption"},{"label":"C","text":"Deep sedation continuous"},{"label":"D","text":"No analgesia"},{"label":"E","text":"Restraints only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** ICU Sedation + Analgesia — ABCDEF Bundle: A Assess + Prevent Pain (multimodal — opioid + non-opioid); B Both spontaneous awakening + breathing trials; C Choice of Sedation + Analgesia (target light sedation RASS 0 to -1; preferred — propofol short-term, dexmedetomidine (no respiratory depression + maintain interaction); AVOID benzodiazepine drips long-term — increases delirium + LOS + mortality; analgesia-first sedation; D Delirium — assess (CAM-ICU) + manage (non-pharm primary; haloperidol/quetiapine for severe agitation; avoid benzo); E Early mobility + exercise (PT in ICU even on vent); F Family engagement + empowerment; (2) **Pain control**: opioid (fentanyl, morphine, remifentanil) + non-opioid (acetaminophen, ketamine low-dose, regional anesthesia, multimodal); (3) **Daily sedation interruption** (Kress NEJM 2000) — daily SAT (spontaneous awakening trial) + SBT (spontaneous breathing trial) — reduces vent days + LOS + mortality; (4) **Outcomes**: ABCDEF compliance correlates with survival, less delirium, faster recovery; (5) Modern: less sedation, more interaction, family presence, early mobility; quality improvement focus

---

ICU sedation paradigm shift: light sedation + ABCDEF bundle. Avoid benzodiazepine drips long-term (delirium, mortality). Daily SAT/SBT. Multimodal analgesia. Early mobility. Family engagement. Outcomes improve with bundle compliance. Modern: less is more — light sedation, more interaction.', NULL,
  'medium', 'procedures', 'review',
  'anesthesiology', 'clinical_decision', 'procedures', 'adult',
  'PADIS Guidelines 2018; ICU Liberation ABCDEF Bundle', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ICU patient post-cardiac surgery on mechanical ventilation needing sedation + analgesia for 5 days

คำถาม: sedation + delirium prevention in ICU'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 35 ปี polytrauma post-MVC — open femoral fracture + pneumothorax + closed head injury — going to OR for damage control surgery

V/S: BP 88/52, HR 132, Hb 6.4, Lactate 4.8, INR 1.6, pH 7.21, Temp 35.4°C
Airway secured pre-OR + chest tube + IV × 2', '[{"label":"A","text":"Standard elective anesthesia"},{"label":"B","text":"Trauma Anesthesia + Damage Control Resuscitation"},{"label":"C","text":"Refuse case"},{"label":"D","text":"Elective approach"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Trauma Anesthesia + Damage Control Resuscitation: (1) **Damage Control Surgery (DCS)** principles — control hemorrhage + contamination, leave anatomy abnormal, temporary closure, ICU resuscitation, return for definitive 24-72h; goal: avoid ''lethal triad'' (acidosis + coagulopathy + hypothermia); (2) **Damage Control Resuscitation**: - Permissive hypotension SBP 80-90 until bleeding controlled (avoid except TBI — different MAP target); - Balanced transfusion 1:1:1 (PRC:FFP:Plt) per PROPPR; - Crystalloid minimized (worsens coagulopathy + edema); - Tranexamic acid (TXA) 1g IV bolus within 3h then 1g over 8h (CRASH-2); - Warm products + fluid; - Calcium replacement (citrate binds Ca); (3) **Anesthetic choice**: avoid agents causing further hypotension; ketamine (cardiostable, analgesic), etomidate (hemodynamically stable but adrenal suppression — single dose OK); minimize propofol (hypotension); volatile carefully; (4) **Ventilation**: lung-protective TV 6 mL/kg IBW; chest tube monitoring; (5) **Monitoring**: arterial line, CVL, urine output, temperature, blood gas + lactate; (6) **TBI considerations**: avoid hypotension (different target — MAP > 65, CPP > 60), avoid hypoxia, avoid hyperventilation (cerebral vasoconstriction); osmotherapy if elevated ICP (mannitol, hypertonic saline); (7) **Open femoral fracture**: antibiotic within 1h (cefazolin + gentamicin for Gustilo III), tetanus, immobilize; (8) **Temperature**: normothermia (warming blankets, warm IV, warm room) — hypothermia worsens coagulopathy + cardiac; (9) **Massive Transfusion Protocol (MTP)** activation; (10) **Trauma team approach**: surgery + anesthesia + nursing + blood bank + lab + interventional radiology; ICU bed reserved; (11) **Post-op**: ICU resuscitation, monitor labs, plan definitive surgery; (12) **Predictors**: shock index, mortality scores

---

Trauma anesthesia: damage control resuscitation principles. Permissive hypotension (except TBI). Balanced transfusion 1:1:1. TXA early. Avoid lethal triad. Anesthetic choice — ketamine, etomidate. TBI considerations differ. Normothermia. MTP. Trauma team approach. Modern: aggressive multidisciplinary trauma care.', NULL,
  'hard', 'trauma', 'review',
  'anesthesiology', 'clinical_decision', 'trauma', 'adult',
  'ATLS 10th ed; PROPPR Trial; CRASH-2 Trial', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยอายุ 35 ปี polytrauma post-MVC — open femoral fracture + pneumothorax + closed head injury — going to OR for damage control surgery

V/S: BP 88/52, HR 132, Hb 6.4, Lactate 4.8, INR 1.6, pH 7.21, Temp 35.4°C
Airway secured pre-OR + chest tube + IV × 2'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 3 ปี น้ำหนัก 15 kg elective tonsillectomy + adenoidectomy under general anesthesia

No significant medical history, no allergies, vaccines current', '[{"label":"A","text":"Same as adult anesthesia"},{"label":"B","text":"Pediatric Anesthesia Considerations"},{"label":"C","text":"No special considerations"},{"label":"D","text":"Adult dosing"},{"label":"E","text":"Refuse case"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Anesthesia Considerations: (1) **Pre-operative**: parental separation anxiety — pre-medication (midazolam oral 0.5 mg/kg); EMLA topical; toys, distraction; child life specialist; (2) **Inhalation induction** (mask) preferred 3 yo — sevoflurane (sweet smell, fast); IV induction once IV in place (lidocaine for propofol injection pain); (3) **Airway** differences: large occiput → flexion neutral position, large tongue, narrow cricoid (subglottic stenosis risk), funnel-shaped larynx; ETT cuff size — ''age/4 + 4'' uncuffed, ''age/4 + 3.5'' cuffed; LMA acceptable for short cases; (4) **Drug doses weight-based** (mg/kg); fluid calculation by 4-2-1 rule; (5) **Temperature regulation**: high surface area:volume ratio → hypothermia risk; warm IV, blanket, warm room (26-28°C in OR for infants); (6) **Hemodynamics**: rate-dependent CO; bradycardia → low CO → use atropine; (7) **Tonsillectomy specifics**: airway shared with surgeon, position changes, intra-op bleeding monitoring; dexamethasone (reduce PONV + edema + pain); minimize opioid (post-T+A apnea risk in OSA); local infiltration; multimodal analgesia (acetaminophen, NSAIDs avoid if bleeding concern); (8) **Post-tonsillectomy hemorrhage** — major risk 5-10 days; emergency airway/resuscitation if returns; (9) **PONV**: high incidence after T+A; dexamethasone + ondansetron prophylactic; (10) **Pain management**: multimodal, parents stay, comfort measures; (11) **Discharge criteria**: usually same day except OSA, age < 3, comorbidity, distance from hospital; (12) **OSA considerations**: opioid sensitivity, post-op monitoring overnight if severe; (13) Multidisciplinary: anesthesia + ENT + nursing + child life + family

---

Pediatric anesthesia: child differences from adult — airway, drug dosing, temperature, hemodynamics, psychological. Inhalation induction common (sevoflurane). Tonsillectomy: shared airway, OSA + opioid sensitivity, hemorrhage risk 5-10d, PONV high, multimodal pain. Multidisciplinary care + family-centered.', NULL,
  'medium', 'respiratory', 'review',
  'anesthesiology', 'clinical_decision', 'respiratory', 'peds',
  'Society for Pediatric Anesthesia; APAS Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'เด็กชายอายุ 3 ปี น้ำหนัก 15 kg elective tonsillectomy + adenoidectomy under general anesthesia

No significant medical history, no allergies, vaccines current'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี acute subarachnoid hemorrhage from ruptured cerebral aneurysm — going to OR for endovascular coiling under general anesthesia

V/S: BP 178/108 (high), HR 88, GCS 14, no focal neurological deficit', '[{"label":"A","text":"Standard surgical anesthesia"},{"label":"B","text":"Neuroanesthesia for Aneurysmal SAH Coiling"},{"label":"C","text":"Refuse case"},{"label":"D","text":"Discharge"},{"label":"E","text":"No monitoring"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neuroanesthesia for Aneurysmal SAH Coiling: (1) **Goals**: maintain CPP (CPP = MAP - ICP, target > 60), avoid spikes in BP (rebleeding risk), avoid hypotension, avoid increases in ICP, minimize aneurysm wall tension; (2) **Pre-op**: BP control (target SBP < 140-160 pre-secured aneurysm — prevent rebleeding 4% in 24h, 30% in 1 month); IV access; arterial line; CVL if needed; nimodipine for vasospasm prevention; seizure prophylaxis if HUNT/HESS poor grade; (3) **Induction**: smooth, avoid HTN spike (treat with esmolol, lidocaine), avoid hypotension; propofol (cardiostable + lowers ICP via reduced CMRO2), thiopental alternative; opioid (fentanyl/remifentanil) blunt sympathetic response; muscle relaxant non-depolarizing (rocuronium); (4) **Maintenance**: TIVA (propofol + remifentanil) vs balanced (volatile + opioid); TIVA preferred for neuroanesthesia (less ICP increase, faster wake-up, better neuro exam); (5) **Hemodynamic management during procedure**: tight BP control — avoid hyper + hypotension; arterial line; vasoactive infusions ready (nicardipine, esmolol for HT; phenylephrine, norepinephrine for hypotension); MAP 80-90 typically; (6) **Ventilation**: PaCO2 normocapnia (avoid hyper or hypoventilation — ICP effects); SpO2 > 95; (7) **Temperature**: normothermia or mild hypothermia (debated — no clear benefit, may worsen); (8) **Heparinization**: for procedure — coordinate with reversal availability; (9) **Hyperthermia**: aggressive treatment (acetaminophen, cooling — fever worsens outcome); (10) **Emergence**: smooth, avoid HTN (treat aggressively), rapid neurological assessment; (11) **Post-op**: ICU, BP control continues, monitor for vasospasm + rebleeding + hydrocephalus + seizures; nimodipine; close neuro checks; (12) **Multidisciplinary**: neurosurgery + interventional radiology + anesthesia + neurocritical care

---

Neuroanesthesia: tight BP control + ICP management + smooth hemodynamic course. TIVA preferred for neurosurgical cases. Aneurysm SAH: pre-secured aneurysm — avoid HTN (rebleeding); post-secured — moderate HTN may be allowed if vasospasm. Nimodipine for vasospasm. Multidisciplinary neurocritical care.', NULL,
  'hard', 'neurology', 'review',
  'anesthesiology', 'clinical_decision', 'neurology', 'adult',
  'SNACC Neuroanesthesia Guidelines; AHA SAH Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี acute subarachnoid hemorrhage from ruptured cerebral aneurysm — going to OR for endovascular coiling under general anesthesia

V/S: BP 178/108 (high), HR 88, GCS 14, no focal neurological deficit'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 68 ปี going for elective CABG + aortic valve replacement + on cardiopulmonary bypass

Meds: aspirin, statin, beta-blocker, lisinopril, metformin', '[{"label":"A","text":"Standard anesthesia"},{"label":"B","text":"Cardiac Anesthesia for CABG + AVR with CPB"},{"label":"C","text":"Refuse case"},{"label":"D","text":"Local anesthetic only"},{"label":"E","text":"No monitoring"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cardiac Anesthesia for CABG + AVR with CPB: (1) **Pre-op**: continue beta-blocker + statin + aspirin (continue per surgeon preference vs hold 5-7 days pre-op for some); hold ACE inhibitor day of surgery; hold metformin day of surgery; antifibrinolytic (TXA or aprotinin alternative); coordinate with cardiologist + perfusionist + ICU; (2) **Monitoring**: 5-lead EKG, arterial line, CVL with PAC option, BIS for depth, TEE intra-op (essential for valve + ventricular function assessment), temperature (esophageal + bladder); (3) **Induction**: smooth, hemodynamically neutral; fentanyl high-dose ''cardiac dose'' historic, modern lower with multimodal; etomidate or low-dose propofol; rocuronium; (4) **Pre-CPB**: maintain hemodynamics, monitor TEE; heparinization (300-400 U/kg) to ACT > 480 before bypass; (5) **On CPB**: maintained by perfusionist; perform aortic cross-clamp; cardioplegia for myocardial protection (cold + chemical); MAP 50-70 on bypass (typical); hemodilution; mild hypothermia (32-34°C) — cerebral protection; (6) **Coming off CPB**: rewarm to 36.5-37°C; restore rhythm (defibrillate, pace); volume management; inotropic support if needed (epinephrine, milrinone, dobutamine); ventilate; protamine to reverse heparin (carefully — anaphylactoid reaction risk); (7) **TEE assessment**: valve function, ventricular function, wall motion; (8) **Bleeding management**: balanced product replacement, TXA/aprotinin, factor concentrates, point-of-care testing (ROTEM, TEG); (9) **Post-op ICU**: ventilation, hemodynamic support, pain control, glycemic control, early extubation when stable (fast-track); (10) **Complications**: arrhythmia (AF — 20-30%), bleeding, stroke, AKI, vasoplegia; (11) **Multidisciplinary**: cardiac surgery + anesthesia + perfusion + ICU + cardiology

---

Cardiac anesthesia: extensive monitoring + invasive (arterial line, CVL, PAC option, TEE). Heparinization for CPB. Cardioplegia + hypothermia for myocardial + cerebral protection. Inotropic support coming off CPB. TXA reduces bleeding. Modern: TEE essential, fast-track recovery, multidisciplinary team. Complications: arrhythmia, bleeding, stroke, AKI.', NULL,
  'hard', 'cardiovascular', 'review',
  'anesthesiology', 'clinical_decision', 'cardiovascular', 'adult',
  'SCA + EACTS Guidelines; STS Cardiac Surgery', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยอายุ 68 ปี going for elective CABG + aortic valve replacement + on cardiopulmonary bypass

Meds: aspirin, statin, beta-blocker, lisinopril, metformin'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ระหว่างผ่าตัด — surgeon uses electrocautery near oxygen-enriched area + drape catches fire on patient

คำถาม: OR fire management', '[{"label":"A","text":"Continue surgery"},{"label":"B","text":"OR Fire — Anesthesia/Surgical Emergency"},{"label":"C","text":"Continue with surgery"},{"label":"D","text":"Refuse to help"},{"label":"E","text":"Discharge patient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** OR Fire — Anesthesia/Surgical Emergency: (1) **Stop procedure immediately** + alert team + announce ''FIRE''; (2) **Fire triangle**: oxidizer (O2, N2O), ignition source (electrocautery, laser, drill), fuel (drapes, alcohol prep, hair, ETT, gauze); (3) **Immediate actions**: - Stop O2 + N2O flow (most important); - Remove burning materials from patient; - Extinguish fire (saline, CO2 extinguisher, smother with blankets); (4) **For airway fires**: - Disconnect breathing circuit; - Remove ETT immediately; - Pour saline into airway; - Once fire out, ventilate with room air + minimum O2 needed; - Re-intubate (likely required for airway burn); - Bronchoscopy to assess; - Tracheostomy if severe; - ICU admission + steroids; (5) **Post-fire**: - Assess patient injury (skin burns, airway burn); - Resuscitation if extensive; - Document — quality improvement; - Counsel patient + family; (6) **Prevention** (ASA Fire Algorithm): - Reduce ambient O2 below 30% when possible; - Use compressed air or blended O2; - Avoid open O2 delivery near surgical site for head/neck cases; - Use proper drape technique; - Allow time for alcohol prep to dry; - Communication between surgeon + anesthesia about ignition + oxidizer use; (7) **OR personnel safety**; (8) **Multidisciplinary**: surgery, anesthesia, OR nursing, infection control

---

OR fires: rare but devastating. Fire triangle — oxidizer + ignition + fuel. Stop O2 first. Airway fires require ETT removal + reintubation. Prevention: ASA Fire Algorithm — reduce ambient O2, time for alcohol drying, communication. Multidisciplinary safety. Document + QI.', NULL,
  'medium', 'trauma', 'review',
  'anesthesiology', 'clinical_decision', 'trauma', 'adult',
  'ASA Practice Advisory for Prevention + Management of Operating Room Fires', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ระหว่างผ่าตัด — surgeon uses electrocautery near oxygen-enriched area + drape catches fire on patient

คำถาม: OR fire management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 28 ปี G2P1 GA 40 wk emergency C-section for fetal distress + uterine atony + ongoing hemorrhage 2L+

Going to OR + already lost lots of blood + still bleeding', '[{"label":"A","text":"Wait for typed blood"},{"label":"B","text":"Massive Transfusion Protocol (MTP) for OB Hemorrhage"},{"label":"C","text":"Crystalloid only"},{"label":"D","text":"Discharge"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Massive Transfusion Protocol (MTP) for OB Hemorrhage: (1) **Activate MTP** (criteria — ongoing hemorrhage requiring multiple units, shock); (2) **Balanced product administration 1:1:1** (PRC:FFP:Plt) per PROPPR trial 2015 — better than crystalloid + delayed plasma; (3) **Tranexamic acid (TXA) 1g IV** within 3 hours (WOMAN trial — reduces death from bleeding in OB hemorrhage); (4) **Crystalloid + colloid** secondary — minimize (dilutional coagulopathy); (5) **Type O negative blood emergent** before type-specific available (for women of reproductive age — Rh status matters); type-specific switch when available; uncrossmatched if needed; (6) **Cryoprecipitate** for fibrinogen < 200 (OB hemorrhage requires fibrinogen > 200 — higher target than trauma); (7) **Point-of-care testing**: ROTEM/TEG to guide product use; (8) **Permissive hypotension** caution in OB (placental + fetal perfusion, eclampsia risk); SBP target 90-100 typically; (9) **Cell saver** controversial in OB (amniotic fluid contamination concern, but increasingly used with leukocyte depletion filter); (10) **Treat cause**: uterine atony (oxytocin + methylergonovine + carboprost + misoprostol — 4 T''s: tone, trauma, tissue, thrombin), surgical control (B-Lynch, hysterectomy if needed); IR + UAE if available; (11) **Temperature**: warming all products, blanket warmer, warm IV — hypothermia worsens coagulopathy; (12) **Calcium replacement** (citrate binds Ca); (13) **Multidisciplinary team**: OB + anesthesia + blood bank + nursing + IR + ICU; (14) **Maternal mortality risk** — leading cause globally; aggressive management saves lives

---

Massive transfusion: balanced 1:1:1 ratio (PROPPR). TXA within 3h (WOMAN). Cryoprecipitate for fibrinogen < 200 (OB target higher). O-negative emergent. Point-of-care testing (ROTEM/TEG). Treat cause. Warm products. Multidisciplinary team. OB hemorrhage = leading cause of maternal mortality globally — saves lives.', NULL,
  'medium', 'obgyn', 'review',
  'anesthesiology', 'clinical_decision', 'obgyn', 'adult',
  'ACOG; PROPPR Trial JAMA 2015; WOMAN Trial Lancet 2017', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยอายุ 28 ปี G2P1 GA 40 wk emergency C-section for fetal distress + uterine atony + ongoing hemorrhage 2L+

Going to OR + already lost lots of blood + still bleeding'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี multi-trauma post-MVC + open femoral fracture exposure for 1 hour + Temp 33.6°C + slow rewarming

คำถาม: perioperative hypothermia management', '[{"label":"A","text":"Ignore temperature"},{"label":"B","text":"Perioperative Hypothermia Management"},{"label":"C","text":"Discharge"},{"label":"D","text":"Refuse"},{"label":"E","text":"Cool further"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Perioperative Hypothermia Management: (1) **Hypothermia harm**: coagulopathy (platelet + enzymatic dysfunction), arrhythmia (especially < 30°C), wound infection, increased SSI, delayed drug metabolism, shivering (cardiac demand), longer recovery; (2) **Prevention strategies (ASA + NICE recommend normothermia > 36°C)**: - Pre-warming pre-op (forced air warming 30-60 min before induction); - Warm OR room (initially 20-24°C, higher for infants 26-28°C); - Forced air warming intra-op (Bair Hugger most common); - Conductive warming mattress; - IV fluid warmer; - Humidification of inspired gas; - Reduce skin exposure; - Cover head; (3) **Active rewarming when hypothermic**: - Forced air warming primary; - IV fluid warmer (40°C); - Warmed humidified ventilation; - Body cavity lavage (pleural, peritoneal) for severe; - Continuous renal replacement therapy with warming; - ECMO for refractory severe (< 28°C, hemodynamic compromise); (4) **Hypothermia + trauma ''lethal triad''**: hypothermia + acidosis + coagulopathy — vicious cycle; aggressive rewarming + product replacement; (5) **Monitoring**: core temperature (esophageal, bladder, rectal, tympanic); skin temperature less accurate; (6) **Cooling for indications** (controversial benefit, narrow): targeted temperature management (TTM 32-36°C) post-cardiac arrest, neuroprotection (mild hypothermia for selected — debated); never hyperthermia (worsens outcome universally); (7) **Multidisciplinary**: anesthesia + surgery + nursing + ICU

---

Perioperative hypothermia: significant harm (coagulopathy, arrhythmia, SSI). Prevention better than treatment. Forced air warming primary. Pre-warming. Trauma lethal triad: hypothermia + acidosis + coagulopathy. Hyperthermia universally harmful. Monitor core temperature. Multidisciplinary team. Modern: normothermia > 36°C standard.', NULL,
  'easy', 'trauma', 'review',
  'anesthesiology', 'clinical_decision', 'trauma', 'adult',
  'ASA Temperature Monitoring Guidelines; NICE Hypothermia', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี multi-trauma post-MVC + open femoral fracture exposure for 1 hour + Temp 33.6°C + slow rewarming

คำถาม: perioperative hypothermia management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 78 ปี HF, CKD3, recent MI, going for emergency hip fracture repair within 24 hours

Functional capacity poor pre-fall, on aspirin + warfarin (INR 2.4) + furosemide + carvedilol + atorvastatin', '[{"label":"A","text":"Discharge"},{"label":"B","text":"Frail Elderly Emergency Surgery"},{"label":"C","text":"Cancel surgery"},{"label":"D","text":"Standard elective"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Frail Elderly Emergency Surgery: (1) **Pre-op optimization while not delaying surgery > 48h** (hip fracture mortality increases with delay): - Volume status assessment (fluid resuscitation cautious in HF/CKD); - Anti-coagulation reversal — INR > 1.5 + emergency hip surgery → 4-factor PCC (Kcentra) + vitamin K (faster than FFP, smaller volume; especially CKD + HF); INR target 1.5; - Continue beta-blocker + statin; - Hold furosemide if hypovolemic; - Optimize Hb (transfuse if < 8 or anemic + symptomatic); - Glycemic control; (2) **Anesthetic plan**: - Regional anesthesia preferred (spinal/CSE) — less delirium + lower mortality than GA in some series (limited evidence — REGAIN trial NEJM 2021 no difference); - Fascia iliaca compartment block (pre-op + intra-op) — excellent analgesia + multimodal; - Reduce opioids; (3) **Monitoring**: arterial line for invasive BP, urine output, EKG, possibly TEE if hemodynamic concerns; (4) **Hemodynamic management**: maintain perfusion to organs (cardiac + renal + brain) — MAP > 65, individualized; avoid both HT + hypoTN; vasopressors as needed; (5) **Cementing reaction risk** (BCIS — bone cement implantation syndrome — hypotension + hypoxia + arrhythmia during prosthesis insertion) — communicate with surgeon, premedicate volume, ready vasopressors, careful cement use, vent reaming; (6) **Post-op**: PACU then ICU vs ward based on stability; multimodal analgesia opioid-sparing; early mobilization; PT; (7) **Ortho-geriatric co-management** — Cochrane evidence reduces mortality; (8) **Delirium prevention**: HELP, non-pharm, avoid Beers meds; (9) **Secondary fracture prevention**: osteoporosis Rx, fall prevention; (10) **Multidisciplinary**: orthopedics + anesthesia + geriatric medicine + nursing + PT + family

---

Frail elderly emergency surgery: optimize without delaying > 48h. Reverse warfarin (PCC > FFP). Regional anesthesia (REGAIN trial — no clear difference from GA but fascia iliaca block + multimodal). Hemodynamic vigilance. Cementing reaction risk. Ortho-geriatric co-management. Modern multidisciplinary team approach.', NULL,
  'medium', 'trauma', 'review',
  'anesthesiology', 'clinical_decision', 'trauma', 'adult',
  'AAOS Hip Fracture; REGAIN Trial NEJM 2021', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยอายุ 78 ปี HF, CKD3, recent MI, going for emergency hip fracture repair within 24 hours

Functional capacity poor pre-fall, on aspirin + warfarin (INR 2.4) + furosemide + carvedilol + atorvastatin'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 32 ปี Jehovah''s Witness — refusing all blood products + going for emergency surgery (ruptured ectopic pregnancy)

Currently BP 88/52, HR 132, Hb 7.4 (dropping)', '[{"label":"A","text":"Force blood transfusion"},{"label":"B","text":"Jehovah''s Witness + Bloodless Medicine"},{"label":"C","text":"Refuse case"},{"label":"D","text":"Discharge"},{"label":"E","text":"Ignore wishes"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Jehovah''s Witness + Bloodless Medicine: (1) **Respect patient autonomy** — informed consent + refusal of blood products (constitutionally protected); document in advance directive + chart; (2) **Discuss specifics**: most JWs refuse whole blood, PRBC, FFP, platelets; many accept albumin, cryoprecipitate, some accept own blood (cell saver if continuous circuit), recombinant factors, ESA (erythropoietin); individualized — ask patient specifically; (3) **Pre-op optimization**: maximize Hb pre-op (iron, B12, folate, erythropoietin if elective); minimize blood draws; (4) **Intra-op blood conservation strategies**: - **Cell saver** (intraoperative blood recovery — preferred — continuous circuit acceptable to most JWs); - **Acute normovolemic hemodilution** (ANH — collect autologous blood + replace with crystalloid; reinfuse later); - **Hypotensive anesthesia** (lower MAP — reduces blood loss); - **Optimize hemostasis** — surgical technique, electrocautery, topical agents (TXA, fibrin glue, hemostatic patches); - **Tranexamic acid (TXA)** — IV systemic + topical reduces bleeding; - **Minimize phlebotomy** — pediatric tubes; - **Pharmacologic**: erythropoietin, iron IV, vitamin B12/folate; (5) **Post-op**: aggressive hemostasis, monitor for re-bleeding, optimize Hb (iron, EPO), nutritional support; (6) **Maternal mortality higher in JW vs general OB population** — counsel + discuss; (7) **Refractory severe anemia**: hyperbaric oxygen as last resort (controversial); (8) **Ethics committee** if complex situations; (9) **Family education** + support; (10) **Bloodless medicine programs** specialized centers; (11) **Documentation** of informed consent + refusal

---

Jehovah''s Witness: respect patient autonomy. Bloodless medicine strategies: cell saver, ANH, TXA, EPO/iron, surgical hemostasis. Document informed consent + refusal. Higher mortality risk — discuss. Specialized bloodless programs. Modern: many options to minimize blood need.', NULL,
  'medium', 'hematology', 'review',
  'anesthesiology', 'clinical_decision', 'hematology', 'adult',
  'Bloodless Medicine + Surgery; Patient Blood Management', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยอายุ 32 ปี Jehovah''s Witness — refusing all blood products + going for emergency surgery (ruptured ectopic pregnancy)

Currently BP 88/52, HR 132, Hb 7.4 (dropping)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง pharmacology — IV induction agents + mechanisms', '[{"label":"A","text":"No differences"},{"label":"B","text":"IV Induction Agents — Mechanisms + Clinical Use"},{"label":"C","text":"Same mechanism"},{"label":"D","text":"Random use"},{"label":"E","text":"Single agent only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** IV Induction Agents — Mechanisms + Clinical Use: (1) **Propofol** — GABA-A agonist + glycine; most common induction; rapid onset + offset; reduces ICP + CMRO2 (neuroprotective); negative inotrope + vasodilator (hypotension); pain on injection (lidocaine pretreat); anti-emetic effects; propofol infusion syndrome (rare — > 4 mg/kg/hr > 48h); (2) **Etomidate** — GABA-A modulator; hemodynamically stable (preferred in unstable cardiac, hypovolemia); ADRENAL SUPPRESSION (11-beta hydroxylase inhibition — single dose may suppress 24-48h; concern in sepsis — avoid in adrenal insufficiency); myoclonus + N/V; (3) **Ketamine** — NMDA antagonist; dissociative anesthesia; preserves cardiovascular + respiratory function (preferred in shock, asthma, bronchospasm); analgesic; emergence reactions (hallucinations — benzo prophylaxis); sympathomimetic (caution CAD, HTN crisis); increases salivation; (4) **Midazolam** — GABA-A modulator (benzodiazepine); pre-medication, sedation, induction with opioid; reversible with flumazenil; respiratory depression; longer recovery; (5) **Thiopental** — GABA-A modulator (barbiturate); historical, less use now; rapid + neuroprotective; reduces ICP; CV depression; reduces hepatic blood flow; precipitates porphyria; pain on injection; (6) **Dexmedetomidine** — alpha-2 agonist; sedation without respiratory depression; analgesic; opioid-sparing; preserves arousability; useful for ICU sedation, awake fiberoptic, procedural sedation; bradycardia + hypotension; (7) **Selection factors**: hemodynamics, comorbidities, allergies, surgery type, recovery profile, cost; (8) **Combination + multimodal** preferred over single agent

---

IV induction agents: different mechanisms + clinical profiles. Propofol most common. Etomidate cardiostable but adrenal suppression. Ketamine preserves CV + respiratory + analgesic. Midazolam reversible. Dexmedetomidine awake sedation. Selection by patient + procedure. Multimodal approach preferred.', NULL,
  'medium', 'procedures', 'review',
  'anesthesiology', 'basic_science', 'procedures', 'adult',
  'Miller''s Anesthesia; Stoelting''s Pharmacology + Physiology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Resident ถามเรื่อง pharmacology — IV induction agents + mechanisms'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง physiology — respiratory + cardiovascular changes during anesthesia', '[{"label":"A","text":"No changes"},{"label":"B","text":"Physiologic Changes During Anesthesia"},{"label":"C","text":"No physiologic effects"},{"label":"D","text":"Adult only"},{"label":"E","text":"Random changes"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Physiologic Changes During Anesthesia: (1) **Respiratory**: - Loss of upper airway tone → obstruction (jaw thrust, oral airway, intubation); - Loss of muscle tone → atelectasis (recruitment maneuver, PEEP); - Reduced FRC (functional residual capacity) by 20% (supine + anesthesia + paralysis); - V/Q mismatch + shunt; - Loss of HPV (hypoxic pulmonary vasoconstriction) in lung; - Apnea (depending on depth + agent); - Respiratory acidosis if hypoventilation; - Hyperventilation → respiratory alkalosis → cerebral vasoconstriction; (2) **Cardiovascular**: - Most anesthetics — myocardial depression, vasodilation → hypotension; - Loss of sympathetic tone (especially neuraxial); - Bradycardia (volatile, opioids, dexmedetomidine, vagal — surgical stimulation); - Reduced response to BP changes; (3) **Neurological**: CMRO2 reduced (most anesthetics neuroprotective in some sense); BBB intact; (4) **Renal**: GFR reduced; reduced response to ADH; - antidiuresis (sympathetic + renin-angiotensin response to surgical stress); - perioperative AKI risk; (5) **GI**: reduced gastric emptying (aspiration risk); ileus post-op; (6) **Endocrine**: stress response (cortisol, glucagon, GH, ADH, catecholamines) → hyperglycemia, fluid retention, immunosuppression; (7) **Hematologic**: hypercoagulability post-op (VTE prophylaxis); (8) **Temperature**: rapid hypothermia (vasodilation + cool OR); (9) **Pediatric/Geriatric** differ — separate considerations; (10) **Implications**: maintain physiologic homeostasis, monitor, intervene as needed

---

Anesthesia profound physiologic effects. Respiratory: loss of tone, atelectasis, reduced FRC, V/Q mismatch. CV: myocardial depression, vasodilation, hypotension. Neuro: reduced CMRO2. GI: aspiration risk + ileus. Endocrine: stress response. Hypothermia rapid. Implications: maintain physiology + monitor + intervene. Modern: minimize disruption.', NULL,
  'medium', 'respiratory', 'review',
  'anesthesiology', 'basic_science', 'respiratory', 'adult',
  'Miller''s Anesthesia; West''s Pulmonary Physiology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Resident ถามเรื่อง physiology — respiratory + cardiovascular changes during anesthesia'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง pharmacology — neuromuscular blockers + reversal', '[{"label":"A","text":"Same mechanism"},{"label":"B","text":"Neuromuscular Blockers (NMB) + Reversal"},{"label":"C","text":"No reversal needed"},{"label":"D","text":"Random use"},{"label":"E","text":"Single agent only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neuromuscular Blockers (NMB) + Reversal: (1) **Depolarizing NMB — Succinylcholine**: ACh receptor agonist; rapid onset (30-60s) + short duration (5-10 min); fasciculations + myalgia; side effects — hyperkalemia (avoid in burns, denervation, neuromuscular disease, prolonged immobilization), MH trigger, increased ICP/IOP, bradycardia (esp peds repeat doses); plasma cholinesterase metabolism (pseudocholinesterase deficiency — prolonged effect); not routinely reversed (let wear off); (2) **Non-Depolarizing NMB — competitive ACh antagonists**: - **Aminosteroids**: rocuronium (intermediate, rapid onset), vecuronium (intermediate), pancuronium (long-acting); - **Benzylisoquinolinium**: cisatracurium (intermediate, Hofmann elimination — useful in liver/renal disease), atracurium (histamine release), mivacurium (short); (3) **Reversal of non-depolarizing NMB**: - **Sugammadex** — for aminosteroids only (rocuronium + vecuronium); cyclodextrin encapsulates molecule; rapid + complete reversal at any depth; 2-16 mg/kg dose-dependent; FDA approved + revolutionary — eliminates residual blockade concerns; - **Neostigmine** (acetylcholinesterase inhibitor) + glycopyrrolate or atropine (anticholinergic to prevent bradycardia + secretion); maximum 5 mg; not effective for profound block; (4) **Monitoring NMB** — train-of-four (TOF) at adductor pollicis or facial nerve; depth-of-block assessment; TOF ratio > 0.9 before extubation (residual NMB causes airway compromise + aspiration); (5) **Quantitative monitoring** (acceleromyography) preferred over qualitative; (6) **Clinical considerations**: avoid hypothermia (prolongs block), acidosis, hypokalemia, hypomagnesemia (potentiates); some antibiotics (aminoglycosides, polymyxin) potentiate; (7) **Reversal of residual NMB** — increased focus to reduce post-op respiratory complications

---

NMB: depolarizing (succinylcholine — rapid, short) vs non-depolarizing (aminosteroids, benzyliso). Sugammadex revolutionized rocuronium/vecuronium reversal. Neostigmine + anticholinergic traditional reversal. TOF monitoring + quantitative preferred. TOF > 0.9 before extubation. Residual NMB causes post-op complications. Modern: emphasis on full reversal + monitoring.', NULL,
  'medium', 'procedures', 'review',
  'anesthesiology', 'basic_science', 'procedures', 'adult',
  'Miller''s Anesthesia; ASA Quantitative NMB Monitoring', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Resident ถามเรื่อง pharmacology — neuromuscular blockers + reversal'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง regional anesthesia anatomy + ultrasound guidance', '[{"label":"A","text":"Blind technique only"},{"label":"B","text":"Ultrasound-Guided Regional Anesthesia"},{"label":"C","text":"Random injection"},{"label":"D","text":"No regional"},{"label":"E","text":"Refuse"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Ultrasound-Guided Regional Anesthesia: (1) **Advantages over blind/nerve stimulator**: direct visualization, real-time needle tracking, lower volume LA, faster onset, fewer attempts, lower complication rates (vascular puncture, nerve injury, LAST); (2) **Common blocks**: - Upper extremity: interscalene (shoulder), supraclavicular (arm), infraclavicular (forearm), axillary, peripheral (median, ulnar, radial nerve, distal); - Lower extremity: femoral, adductor canal (saphenous), sciatic (popliteal), ankle block; - Truncal: TAP (transversus abdominis plane), rectus sheath, quadratus lumborum, paravertebral, erector spinae plane (ESP), serratus anterior, PECS I + II (chest wall); - Neuraxial: spinal, epidural (ultrasound assists in difficult anatomy or obesity); (3) **Technique**: identify target nerve + surrounding structures, in-plane vs out-of-plane needle, hydrodissection, incremental LA injection with aspiration; (4) **LA selection**: lidocaine (short-acting, intra-op), bupivacaine + ropivacaine (long-acting, post-op analgesia 12-24h), liposomal bupivacaine (72h); adjuncts (epinephrine — vasoconstriction + LA duration + detect IV; dexamethasone + clonidine — prolong); (5) **Complications**: LAST (most feared — see other question), nerve injury, vascular puncture + hematoma, infection, pneumothorax (interscalene, supraclavicular), epidural hematoma (neuraxial); (6) **Patient selection**: cooperative, no severe coagulopathy at site, no infection at site, appropriate consent; (7) **Documentation**: technique, structure identification, LA + volume, response, complications; (8) **Continuous catheters**: prolonged analgesia, multimodal; (9) **Outcomes**: reduced opioid use, shorter hospital stay, less PONV, better recovery; (10) **Training**: ultrasound + needle skills require deliberate practice

---

Ultrasound-guided regional anesthesia: advantages over blind. Multiple block types upper/lower/truncal/neuraxial. LA selection + adjuncts. Continuous catheters for prolonged. Complications: LAST, nerve injury, vascular, pneumothorax. Reduces opioid use + improves recovery. Modern multimodal analgesia foundation.', NULL,
  'easy', 'procedures', 'review',
  'anesthesiology', 'basic_science', 'procedures', 'adult',
  'ASRA Anatomy + Block Manual; SonoSim + Online Resources', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Resident ถามเรื่อง regional anesthesia anatomy + ultrasound guidance'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital wants reduce surgical mortality + improve perioperative care — implement Enhanced Recovery After Surgery (ERAS) hospital-wide', '[{"label":"A","text":"Traditional approach"},{"label":"B","text":"ERAS Hospital-Wide Implementation"},{"label":"C","text":"Single intervention"},{"label":"D","text":"No multidisciplinary"},{"label":"E","text":"Refuse ERAS"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** ERAS Hospital-Wide Implementation: (1) **Multidisciplinary team**: surgeons, anesthesia, nursing, PT/OT, dietitian, social work, pharmacy, case management, quality improvement, IT, leadership; (2) **Specialty-specific protocols** (ERAS Society guidelines exist for major specialties — colorectal, urology, GYN, breast, bariatric, hepatobiliary, esophageal, lung, cardiac, gastric, thoracic, head + neck, pancreas, ortho, OB); (3) **Components** (~ 20 elements per protocol): - Pre-operative: education + counseling, no prolonged fasting (clear fluids 2h, carb loading), no routine bowel prep (specialty-dependent), MRSA screening, smoking cessation, nutritional optimization; - Intra-operative: antibiotic prophylaxis timing, normothermia, restrictive fluid, minimally invasive when possible, multimodal analgesia (regional + non-opioid), avoid NG tube + drains routine, normoglycemia; - Post-operative: early diet + mobilization (within 24h), multimodal analgesia (opioid-sparing), no Foley routine > 24h, DVT prophylaxis, early discharge planning; (4) **Audit + feedback**: measure compliance + outcomes per ERAS interactive audit system or local; (5) **Outcomes**: reduced LOS 30%, complications 30-50%, opioid use, readmissions; cost-effective; (6) **Cultural change** essential — staff buy-in, education, ongoing reinforcement; (7) **Patient + family engagement**: empowered, informed, expectations set; (8) **Continuous improvement**: quarterly review, evolve protocols; (9) **Equity**: ensure benefits across all populations; (10) **Modern**: ERAS as standard of care; high-quality + low-cost approach

---

ERAS = evidence-based multimodal perioperative care. Specialty-specific protocols. ~20 elements per protocol. Multidisciplinary team. Audit + feedback. Outcomes: shorter LOS, less morbidity, less opioid, cost-effective. Cultural change. Patient empowerment. Modern: standard of care across major surgeries.', NULL,
  'medium', 'procedures', 'review',
  'anesthesiology', 'ems_mgmt', 'procedures', 'adult',
  'ERAS Society Guidelines; Ljungqvist O JAMA Surg 2017', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Hospital wants reduce surgical mortality + improve perioperative care — implement Enhanced Recovery After Surgery (ERAS) hospital-wide'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital implements patient safety + medication error reduction — anesthesia-specific', '[{"label":"A","text":"Ignore"},{"label":"B","text":"Anesthesia Patient Safety Program"},{"label":"C","text":"Refuse safety measures"},{"label":"D","text":"Single specialty"},{"label":"E","text":"Random approach"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Anesthesia Patient Safety Program: (1) **APSF (Anesthesia Patient Safety Foundation)** leadership in anesthesia safety; (2) **Anesthesia mortality** reduced dramatically: from 1 per 5,000 (1960s) → 1 per 200,000 modern — model patient safety success in medicine; (3) **Key safety initiatives**: - **Standardized monitoring** (ASA standards 1986) — pulse ox, EKG, BP, EtCO2, temperature, vigilance; - **Difficult airway algorithm** + equipment availability; - **Crisis Resource Management (CRM)** training — communication, leadership, teamwork during emergencies; - **Simulation training** — realistic scenarios, debriefing; - **Pre-anesthesia checklists** (machine, equipment, drugs, patient identification, allergies, NPO); - **Time-out** before surgical incision (universal protocol — patient + site + procedure); - **Medication safety** — color-coded syringes, separate stations, pre-filled syringes, barcode scanning, electronic record; - **Closed-loop communication** — read-back of orders; - **Fatigue + handoff management** — duty hour limits, structured handoffs (SBAR, I-PASS); - **Quality improvement infrastructure** — case review, M&M, root cause analysis, blame-free reporting; - **APSF newsletter** + publications + funded research; (4) **Specific medication errors**: ampule confusion, similar labels (lookalike), wrong concentrations, wrong route (intrathecal vs IV), reversed drug → use prefilled syringes when possible; (5) **Technology**: anesthesia information management systems (AIMS), barcode scanning, smart pumps, computerized order entry; (6) **Culture of safety**: psychological safety, learning from errors, transparency, accountability; (7) **Multidisciplinary**: physicians, nurses, technicians, pharmacy, IT, administration; (8) **Continuous education + competency assessment**

---

Anesthesia patient safety: dramatic mortality reduction (1 per 5,000 → 1 per 200,000) — model of patient safety success. APSF leadership. ASA monitoring standards + difficult airway + CRM + simulation + checklists + time-out + medication safety + handoffs. Culture of safety. Technology aids. Modern: standard practice across hospitals.', NULL,
  'easy', 'procedures', 'review',
  'anesthesiology', 'ems_mgmt', 'procedures', 'adult',
  'APSF; ASA Patient Safety Standards', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Hospital implements patient safety + medication error reduction — anesthesia-specific'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital implements opioid stewardship in anesthesia + perioperative period — opioid crisis response', '[{"label":"A","text":"More opioids"},{"label":"B","text":"Opioid Stewardship in Anesthesia"},{"label":"C","text":"Long-term opioids"},{"label":"D","text":"Refuse stewardship"},{"label":"E","text":"Single intervention"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Opioid Stewardship in Anesthesia: (1) **Public health context**: opioid crisis — 100,000+ overdose deaths/year US, fentanyl epidemic, persistent post-op opioid use → addiction; (2) **Perioperative opioid stewardship goals**: - Reduce opioid prescribing without compromising pain control; - Identify high-risk patients; - Multimodal analgesia; - Patient + family education; - Safe disposal of unused; - Surveillance + monitoring; (3) **Specific interventions**: - **Multimodal analgesia foundation** (acetaminophen + NSAID + gabapentinoid + ketamine + regional + steroid); - **Regional anesthesia** + neuraxial — opioid-sparing; - **ERAS protocols** include opioid-sparing; - **Surgeon-specific prescribing guidelines** (limited dose + days for specific procedures — e.g., open hernia 5-10 tabs total); - **Default prescribing** — change defaults in EMR (smaller quantities, lower doses); - **PDMP (Prescription Drug Monitoring Programs)** — check before prescribing; - **OUD screening** + treatment (don''t withhold pain control from OUD patients — multimodal + may need MAT); - **Naloxone co-prescription** for high-risk; - **Education**: physicians, residents, students; (4) **Patient education**: realistic expectations, side effects, addiction risks, safe storage + disposal, alternatives; (5) **Post-op pain management programs**: outpatient pain management, transitional pain service for high-risk; (6) **Surveillance**: opioid prescribing data, persistent use rates, ED visits + readmissions, satisfaction; (7) **Quality metrics**: opioid prescribing per case + procedure; (8) **Multidisciplinary**: anesthesia + surgery + pharmacy + nursing + addiction medicine + primary care + mental health; (9) **Modern paradigm**: less opioid is more — patient outcomes, addiction prevention

---

Opioid stewardship: anesthesia + perioperative response to opioid crisis. Multimodal analgesia + regional anesthesia + ERAS + PDMP + procedure-specific guidelines + default prescribing changes. Patient education + safe disposal. OUD screening + treatment. Modern: less opioid is more — patient outcomes + addiction prevention.', NULL,
  'medium', 'psych_behavior', 'review',
  'anesthesiology', 'ems_mgmt', 'psych_behavior', 'adult',
  'CDC Pain Guidelines 2022; ASA Opioid Stewardship', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Hospital implements opioid stewardship in anesthesia + perioperative period — opioid crisis response'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 78 ปี multimorbid (HF + CKD + DM + frailty + cognitive impairment) coming for hip surgery — complex perioperative + multidisciplinary care', '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Multimorbid Elderly Perioperative Integrative Care"},{"label":"C","text":"Refuse care"},{"label":"D","text":"Single intervention"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Multimorbid Elderly Perioperative Integrative Care: (1) **Pre-op multidisciplinary assessment**: orthopedics + anesthesia + geriatric medicine + cardiology + nephrology + endocrinology + PT + nutrition + social work; (2) **Comprehensive Geriatric Assessment (CGA)**: medical + functional + cognitive + nutritional + psychosocial + medications (Beers, STOPP/START); (3) **Goals of care discussion**: balance benefits vs risks; advance directives; family + patient values; outcomes-focused (function, QOL, mortality); (4) **Optimization without delaying urgent surgery**: HF (loop diuretic + ACE/ARB optimize cautious), CKD (avoid nephrotoxic + hydration), DM (glycemic control + hold metformin), frailty (nutrition, prehabilitation if elective); (5) **Anesthetic plan**: regional or neuraxial preferred (REGAIN trial mixed — local + anesthesia preference); multimodal + opioid-sparing; less sedation; (6) **Hemodynamic monitoring**: invasive in high-risk (arterial line); maintain MAP > 65, individualized; volume status balance; (7) **Delirium prevention**: HELP elements (orientation, mobility, sleep, hearing/vision aids, family); avoid Beers meds; ABCDEF in ICU if applicable; (8) **Post-op**: ortho-geriatric co-management — Cochrane evidence reduces mortality; multidisciplinary rounds; early mobilization; nutrition; PT/OT; pain control opioid-sparing; (9) **Discharge planning early**: home with services vs rehab vs SNF; family + social support; (10) **Secondary prevention**: osteoporosis, fall prevention, CV; (11) **Family + caregiver engagement**: support, education, decision-making; (12) **Long-term**: rehabilitation, function, follow-up; quality of life focus

---

Multimorbid elderly perioperative care = quintessential integrative + multidisciplinary. CGA + goals of care + optimization (not delaying urgent). Anesthetic choice individualized. Hemodynamic + delirium prevention. Ortho-geriatric co-management evidence-based. Family engagement. Long-term function focus. Modern: multidisciplinary team approach standard.', NULL,
  'hard', 'trauma', 'review',
  'anesthesiology', 'integrative', 'trauma', 'adult',
  'AAOS + AGS Guidelines; ACS Geriatric Surgery', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยอายุ 78 ปี multimorbid (HF + CKD + DM + frailty + cognitive impairment) coming for hip surgery — complex perioperative + multidisciplinary care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 40 ปี undergoing major spine surgery for tumor resection — long surgery + complex monitoring + transfusion + neuro monitoring + chronic pain management', '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Complex Spine Surgery Integrative Care"},{"label":"C","text":"Refuse"},{"label":"D","text":"Single specialty"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Complex Spine Surgery Integrative Care: (1) **Pre-op multidisciplinary**: spine surgery + anesthesia + neuro monitoring + oncology + IR (potentially preoperative embolization) + ICU + rehabilitation + pain management + psychology + nutrition + social work; (2) **Pre-op planning**: imaging review, blood + products availability, autologous blood storage, cell saver, vascular access planning; (3) **Anesthetic plan**: TIVA for neuromonitoring (avoids volatile interference); positioning (prone or other) considerations + pressure injury prevention; (4) **Neurophysiologic monitoring (IONM)**: MEPs (motor evoked potentials), SSEPs (somatosensory), EMG — detect early nerve injury; requires TIVA + careful muscle relaxant; (5) **Massive blood loss management**: TXA (loading + infusion); cell saver; balanced transfusion; permissive hypotension cautious in spine — blood loss vs cord perfusion balance; point-of-care testing (ROTEM/TEG); fibrinogen monitoring; (6) **Hemodynamic management**: MAP > 80-85 to maintain cord perfusion + brain; arterial line + CVL + possibly TEE; vasopressors as needed; (7) **Lung-protective ventilation**: TV 6 mL/kg IBW + PEEP; particular consideration in prone position; (8) **Temperature**: normothermia; warming devices; (9) **Pain control**: regional (epidural, paravertebral, ESP); IV ketamine; multimodal opioid-sparing; (10) **Post-op**: ICU monitoring; neurological exam frequent; (11) **Rehabilitation**: early; spine precautions; PT + OT; (12) **Psychological support + family**: anxiety, depression, prolonged recovery; (13) **Long-term**: chronic pain + functional + tumor surveillance + oncology follow-up + transition planning

---

Complex spine surgery = integrative multidisciplinary. TIVA for IONM. Massive transfusion + cell saver. MAP maintenance for cord perfusion. Regional + multimodal pain. Prone positioning considerations. Post-op ICU + frequent neuro checks. Rehabilitation + psychological. Long-term oncology follow-up. Modern: highly coordinated multidisciplinary care.', NULL,
  'hard', 'neurology', 'review',
  'anesthesiology', 'integrative', 'neurology', 'adult',
  'ASA + SNACC; AANS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยอายุ 40 ปี undergoing major spine surgery for tumor resection — long surgery + complex monitoring + transfusion + neuro monitoring + chronic pain management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 60 ปี OUD on methadone — going for emergency surgery + multidisciplinary pain management challenge', '[{"label":"A","text":"Withhold methadone"},{"label":"B","text":"OUD on Methadone Perioperative Care"},{"label":"C","text":"More opioid only"},{"label":"D","text":"Refuse pain control"},{"label":"E","text":"Detox emergent"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** OUD on Methadone Perioperative Care: (1) **Continue methadone** for OUD treatment — do NOT stop; coordinate dose timing with surgery (last dose timing affects pain management); withholding precipitates withdrawal + worsens outcomes; (2) **Tolerance considerations**: increased opioid requirements vs opioid-naive (3-4× typical doses); standard doses inadequate; (3) **Multimodal opioid-sparing primary**: acetaminophen + NSAID + gabapentinoid + ketamine (excellent for OUD + chronic pain) + regional anesthesia + dexmedetomidine + dexamethasone; (4) **Acute pain on top of methadone**: short-acting opioid for breakthrough (PCA hydromorphone, fentanyl); higher doses than opioid-naive; (5) **Regional anesthesia** maximally utilized — neuraxial, peripheral nerve blocks, continuous catheters; (6) **NMDA antagonist**: ketamine infusion (anti-hyperalgesic + opioid-sparing) — particularly useful in OUD; (7) **Pain medicine + addiction medicine consult**; (8) **Behavioral**: address anxiety, recognize withdrawal symptoms, prevent precipitated withdrawal, supportive care; (9) **Discharge planning** carefully: transition off short-acting opioid back to methadone alone; multimodal + non-opioid continue; close follow-up; (10) **Avoid pain-medicine ''orphaning''** — addiction medicine + acute pain + chronic pain coordination; (11) **Stigma**: address — OUD = chronic illness, patient deserves appropriate pain management; (12) **Modern**: integrated dual treatment, multidisciplinary, addiction + pain specialists working together; (13) **Naltrexone challenges**: NOT in this case (methadone) but if on naltrexone — must address blocking of opioid effects

---

OUD on methadone perioperative: CONTINUE methadone. Tolerance — higher opioid doses for breakthrough. Multimodal opioid-sparing primary (regional, ketamine, multimodal). Addiction + pain medicine coordination. Stigma awareness. Modern: integrated care + appropriate pain control + addiction treatment maintained. Patient deserves humane care.', NULL,
  'medium', 'psych_behavior', 'review',
  'anesthesiology', 'integrative', 'psych_behavior', 'adult',
  'ASA + ASAM Perioperative OUD; ICA Opioid Use', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยอายุ 60 ปี OUD on methadone — going for emergency surgery + multidisciplinary pain management challenge'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 72 ปี ASA III, hypertension, COPD GOLD 2 — elective TURP
Meds: amlodipine, tiotropium, salmeterol-fluticasone
Functional capacity 5 METs, room air SpO2 94%
PFT: FEV1 65%, FEV1/FVC 0.62
CXR: hyperinflation
ABG: pH 7.40, PaCO2 44, PaO2 72', '[{"label":"A","text":"Cancel surgery for ICU bed"},{"label":"B","text":"COPD perioperative optimization (ASA + ATS)"},{"label":"C","text":"Stop all bronchodilators pre-op"},{"label":"D","text":"Use desflurane mandatory"},{"label":"E","text":"Refuse anesthesia"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** COPD perioperative optimization (ASA + ATS): (1) Continue inhaled bronchodilators perioperative (LABA + LAMA + ICS); pre-op nebulized albuterol on call to OR; (2) Smoking cessation > 8 weeks ideal (4-8 weeks may transiently increase secretions); (3) Pulmonary rehab if time allows; (4) Treat exacerbation with antibiotic + steroid before elective surgery; (5) Anesthetic plan — regional (spinal/epidural) preferred for TURP (avoid GA + intubation); if GA needed: avoid histamine-releasing agents (atracurium, morphine, thiopental), use sevoflurane (bronchodilator), avoid desflurane (airway irritant); (6) Ventilation strategy: lung-protective TV 6-8 mL/kg, PEEP 5-8, prolonged I:E ratio to allow expiration, permissive hypercapnia, avoid auto-PEEP; (7) Post-op pulmonary toilet, incentive spirometry, early mobilization, multimodal opioid-sparing analgesia; (8) Risk stratification using ARISCAT score; (9) Document baseline ABG; (10) Consider neuraxial-only technique

---

COPD pre-op: continue inhalers, optimize before elective surgery, choose regional > GA, lung-protective ventilation, sevoflurane > desflurane (airway irritant), multimodal analgesia post-op. ARISCAT for risk stratification.', NULL,
  'medium', 'respiratory', 'review',
  'anesthesiology', 'clinical_decision', 'respiratory', 'adult',
  'ASA Preanesthesia Evaluation Practice Advisory; ATS/ERS COPD Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 72 ปี ASA III, hypertension, COPD GOLD 2 — elective TURP
Meds: amlodipine, tiotropium, salmeterol-fluticasone
Functional capacity 5 METs, room air SpO2 94%
PFT: FEV1 65%, FEV1/FVC 0.62
CXR: hyperinflation
ABG: pH 7.40, PaCO2 44, PaO2 72'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 65 ปี ASA III ESRD on HD MWF — elective AV fistula revision วันจันทร์
Last HD วันศุกร์
Meds: amlodipine, EPO, calcitriol, sevelamer
Lab: K 6.2, Cr 8.4, Hb 9.8, normal coagulation
ECG: peaked T waves', '[{"label":"A","text":"Proceed with surgery immediately"},{"label":"B","text":"ESRD pre-op management"},{"label":"C","text":"Give succinylcholine for RSI"},{"label":"D","text":"Use morphine PCA only"},{"label":"E","text":"Mass IV crystalloid bolus"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** ESRD pre-op management: (1) Hyperkalemia 6.2 + ECG changes = urgent dialysis BEFORE surgery; delay 6-12h post-HD ideal (avoid volume depletion + heparin effect); (2) If can''t delay: medical treatment — calcium gluconate 1g (membrane stabilization), insulin 10U + D50 (shift K intracellular), beta-2 agonist nebulizer, sodium bicarb if acidotic, kayexalate; (3) Anesthetic considerations: avoid succinylcholine (further K release ~0.5-1 mEq/L); use rocuronium (renal-independent for cisatracurium — Hofmann elimination preferred); avoid morphine (M6G metabolite accumulates) — use fentanyl/hydromorphone; (4) Volume: cautious — fluid overload risk; isotonic crystalloid only as needed; avoid LR if K elevated (K 4 mEq/L); (5) Regional anesthesia for AV fistula = excellent choice (brachial plexus block — avoid GA); (6) Protect contralateral arm — no BP cuff, IV, or arterial line on AV fistula side; (7) Monitor — careful CV, electrolytes; (8) Post-op HD schedule planning

---

ESRD + hyperkalemia: dialyze before elective surgery. Avoid succinylcholine + morphine. Cisatracurium preferred NMB. Regional anesthesia ideal for AV fistula. Protect fistula arm. Cautious fluid management.', NULL,
  'medium', 'cardiovascular', 'review',
  'anesthesiology', 'clinical_decision', 'cardiovascular', 'adult',
  'ASA Practice Advisory; KDIGO Perioperative Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 65 ปี ASA III ESRD on HD MWF — elective AV fistula revision วันจันทร์
Last HD วันศุกร์
Meds: amlodipine, EPO, calcitriol, sevelamer
Lab: K 6.2, Cr 8.4, Hb 9.8, normal coagulation
ECG: peaked T waves'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 58 ปี DM T2 on insulin glargine 30U HS + metformin — elective hip replacement
HbA1c 8.4%, FBS 165
ไม่มี microvascular complications
NPO since midnight', '[{"label":"A","text":"Continue normal insulin + metformin"},{"label":"B","text":"Diabetic perioperative glycemic management"},{"label":"C","text":"Stop all insulin pre-op"},{"label":"D","text":"Give double dose insulin"},{"label":"E","text":"Use D10 infusion routinely"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Diabetic perioperative glycemic management: (1) Hold metformin morning of surgery (risk lactic acidosis if AKI develops); resume when eating + renal function stable; (2) Long-acting insulin (glargine) — give 50-80% of usual dose night before or morning of surgery (basal coverage needed despite NPO); (3) Hold short-acting prandial insulin while NPO; (4) Hold SGLT2 inhibitors 3 days pre-op (euglycemic DKA risk); (5) Target intraop glucose 140-180 mg/dL (avoid hypoglycemia + severe hyperglycemia); use insulin infusion if persistently > 180; (6) Check glucose q1-2h intraop, q4h post-op; (7) Schedule diabetic patients FIRST CASE to minimize NPO duration; (8) Resume oral hypoglycemics when eating + tolerating + renal OK; (9) Avoid dextrose-containing fluids unless hypoglycemic; (10) HbA1c > 8.5% — consider delay elective surgery for optimization (increased SSI risk); (11) DKA + HHS — delay all elective until resolved

---

DM perioperative: hold metformin + short-acting insulin, 50-80% basal insulin, target 140-180, first case scheduling, hold SGLT2i 3 days. HbA1c > 8.5% consider delay.', NULL,
  'easy', 'endocrine_metabolic', 'review',
  'anesthesiology', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'ADA Standards of Care; SAMBA Consensus Diabetes Surgery', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 58 ปี DM T2 on insulin glargine 30U HS + metformin — elective hip replacement
HbA1c 8.4%, FBS 165
ไม่มี microvascular complications
NPO since midnight'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 78 ปี ASA III — fragility hip fracture
Meds: warfarin (AFib), apixaban changed by GP, ASA 81mg
INR 2.4, weight 60 kg, eGFR 45
ต้องผ่าตัด < 48 ชม. per orthopedic guidelines', '[{"label":"A","text":"Wait 5 days for warfarin clearance"},{"label":"B","text":"Anticoagulant reversal for urgent hip surgery"},{"label":"C","text":"Heparin bridging only"},{"label":"D","text":"Proceed without reversal"},{"label":"E","text":"Cancel surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Anticoagulant reversal for urgent hip surgery: (1) Hip fracture surgery < 48h reduces mortality + morbidity per international guidelines; (2) Warfarin reversal — Vitamin K 5-10 mg IV (12-24h onset) + 4-factor PCC (Kcentra) 25-50 U/kg INR-based dosing (immediate reversal); avoid FFP if PCC available (volume + slower); (3) Apixaban (DOAC) — andexanet alfa (specific reversal) if within hours of last dose; otherwise PCC 50 U/kg empirically; check apixaban level if available; last dose timing critical (half-life 12h with normal renal); (4) ASA 81mg — continue (cardiovascular protection > minor bleeding risk in hip surgery); (5) Neuraxial anesthesia — DOAC requires 24-48h hold (longer with renal impairment); residual DOAC contraindicates neuraxial — use GA; (6) Type + cross blood products; (7) Restart anticoagulation post-op when hemostasis confirmed — bridge with LMWH while warfarin retitrated; DOAC restart 24-72h depending on bleeding risk; (8) Multidisciplinary: anesthesia + ortho + cardiology + hematology

---

Hip fracture < 48h reduces mortality. Warfarin: PCC + vit K. DOAC: andexanet or PCC. Continue ASA. DOAC contraindicates neuraxial (24-48h hold). Restart anticoagulation post-op after hemostasis.', NULL,
  'hard', 'hematology', 'review',
  'anesthesiology', 'clinical_decision', 'hematology', 'adult',
  'ASRA Anticoagulation Guidelines 2018; ACC/AHA Perioperative Management', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 78 ปี ASA III — fragility hip fracture
Meds: warfarin (AFib), apixaban changed by GP, ASA 81mg
INR 2.4, weight 60 kg, eGFR 45
ต้องผ่าตัด < 48 ชม. per orthopedic guidelines'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 45 ปี hyperthyroid Graves'' disease — elective cholecystectomy
Meds: methimazole 10mg TID × 6 weeks, propranolol 40mg BID
TSH 0.05, FT4 1.5 (slightly elevated), HR 92, BP 130/75
Thyroid still mildly enlarged', '[{"label":"A","text":"Proceed immediately"},{"label":"B","text":"Hyperthyroid pre-op optimization"},{"label":"C","text":"Stop methimazole + propranolol"},{"label":"D","text":"Use ketamine for induction"},{"label":"E","text":"Refuse referral"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hyperthyroid pre-op optimization: (1) Elective surgery — should be euthyroid first (TSH normal, FT4/FT3 normal, HR < 90 rest) to prevent thyroid storm; (2) Methimazole continued for at least 6 weeks (until euthyroid); (3) Beta-blocker (propranolol 20-40 mg q6h) to control HR + symptoms; preferred — non-selective (blocks T4→T3 conversion); (4) If urgent surgery + hyperthyroid: Lugol''s iodine 5 drops TID (Wolff-Chaikoff effect) + hydrocortisone + propranolol; (5) Thyroid storm precipitants intra-op: surgery itself, infection, DKA, trauma, anesthesia stress; (6) Anesthetic choice: avoid sympathomimetic (ephedrine, ketamine) — use phenylephrine; avoid pancuronium (vagolytic); use rocuronium/cisatracurium; (7) Adequate depth anesthesia critical (stress response); (8) Thyroid storm treatment: PTU 600-1000mg loading + 250mg q4h (blocks synthesis + conversion); beta-blocker (esmolol IV infusion); hydrocortisone 100mg q8h; iodine (Lugol''s after PTU); cooling; supportive care ICU; (9) Recommend delay until euthyroid (FT4 normal)

---

Hyperthyroid + elective surgery: euthyroid first (prevent thyroid storm). Continue methimazole + beta-blocker. Urgent: add Lugol''s + steroid. Avoid sympathomimetics + ketamine + pancuronium. Storm: PTU + esmolol + steroid + cooling + Lugol''s.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'anesthesiology', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'ATA Hyperthyroidism Guidelines; ASA Practice Advisory', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 45 ปี hyperthyroid Graves'' disease — elective cholecystectomy
Meds: methimazole 10mg TID × 6 weeks, propranolol 40mg BID
TSH 0.05, FT4 1.5 (slightly elevated), HR 92, BP 130/75
Thyroid still mildly enlarged'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 55 ปี ASA II, history breast cancer mastectomy + chemotherapy (doxorubicin 240 mg/m2 cumulative) 8 ปีที่แล้ว — elective abdominal surgery
Echo ปัจจุบัน LVEF 40% (baseline 60% pre-chemo)
Mild DOE NYHA II', '[{"label":"A","text":"Proceed without modification"},{"label":"B","text":"Anthracycline cardiotoxicity perioperative"},{"label":"C","text":"Use high-dose propofol bolus"},{"label":"D","text":"Aggressive fluid loading"},{"label":"E","text":"Skip echo"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Anthracycline cardiotoxicity perioperative: (1) Doxorubicin cumulative dose > 240 mg/m2 — risk cardiomyopathy increasing dose-dependent (5% at 400 mg/m2, 26% at 550 mg/m2); (2) Late cardiotoxicity (years after) — irreversible dilated cardiomyopathy; current LVEF 40% confirms; (3) Pre-op: Echo + BNP + cardiology consult; consider stress imaging; (4) Optimize HF treatment — ACEi/ARB, beta-blocker (carvedilol/metoprolol succinate), MRA, SGLT2i; loop diuretic if congested; ideally optimized 4-6 weeks pre-op; (5) Anesthetic plan — invasive monitoring (arterial line ± CVP/TEE for major case); maintain preload + afterload; (6) Drug choices — avoid myocardial depressants in high doses; etomidate for induction (CV stable) > propofol; opioid-based maintenance; (7) Cardiac output monitoring (esophageal Doppler, pulse contour); (8) Cautious fluid — avoid overload; (9) Multimodal analgesia + regional to reduce stress response; (10) Post-op ICU/step-down; (11) Modern: dexrazoxane prophylaxis for high-dose anthracycline; cardio-oncology programs

---

Anthracycline cardiomyopathy: dose-dependent, late onset, irreversible. Optimize HF treatment pre-op. Etomidate > propofol for induction. Invasive monitoring. Avoid fluid overload. Cardio-oncology consultation.', NULL,
  'medium', 'cardiovascular', 'review',
  'anesthesiology', 'clinical_decision', 'cardiovascular', 'adult',
  'ESC Cardio-Oncology Guidelines 2022; ASA Cardiac Perioperative', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 55 ปี ASA II, history breast cancer mastectomy + chemotherapy (doxorubicin 240 mg/m2 cumulative) 8 ปีที่แล้ว — elective abdominal surgery
Echo ปัจจุบัน LVEF 40% (baseline 60% pre-chemo)
Mild DOE NYHA II'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 70 ปี severe aortic stenosis (AVA 0.7 cm², peak gradient 65 mmHg, mean 42) — elective inguinal hernia repair
Class II-III symptoms, LVEF 55%
ไม่ใช่ candidate TAVR ทันที', '[{"label":"A","text":"Spinal anesthesia for ease"},{"label":"B","text":"Severe AS perioperative anesthesia"},{"label":"C","text":"Aggressive vasodilator"},{"label":"D","text":"Beta-blocker bolus high dose"},{"label":"E","text":"Bupivacaine spinal full dose"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe AS perioperative anesthesia: (1) Severe AS = high CV risk noncardiac surgery (mortality 10% major surgery); (2) Symptomatic severe AS — consider AVR/TAVR FIRST if surgery elective + delayable; if urgent: proceed with intensive monitoring; (3) Hemodynamic goals: maintain SINUS RHYTHM (atrial kick critical 30-40% CO), avoid TACHYCARDIA (reduces diastolic filling time + coronary perfusion), maintain PRELOAD + AFTERLOAD (SVR — coronary perfusion pressure), avoid HYPOTENSION (coronary supply-demand mismatch); (4) Anesthetic technique — neuraxial RELATIVELY CONTRAINDICATED (sympathectomy → drop SVR → cardiac arrest risk); GA preferred OR carefully titrated epidural (slow onset, T10 level, phenylephrine ready) or local + sedation; (5) Induction — etomidate (CV stable) + opioid; avoid propofol bolus; (6) Phenylephrine first-line vasopressor (alpha-1, maintains SVR + reflex bradycardia OK); (7) Invasive monitoring — arterial line MANDATORY; (8) Treat arrhythmia aggressively — cardioversion AFib immediately if hemodynamic compromise; (9) Maintain coronary perfusion pressure (MAP - LVEDP); (10) Multidisciplinary: cardiology + anesthesia + surgery; consider TAVR before elective non-cardiac if possible

---

Severe AS hemodynamic goals: maintain SR, preload, afterload, avoid tachy. Neuraxial relatively contraindicated. Phenylephrine first-line. Arterial line mandatory. Consider TAVR before elective non-cardiac.', NULL,
  'hard', 'cardiovascular', 'review',
  'anesthesiology', 'clinical_decision', 'cardiovascular', 'adult',
  'AHA/ACC Valvular Heart Disease 2020; ESC Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 70 ปี severe aortic stenosis (AVA 0.7 cm², peak gradient 65 mmHg, mean 42) — elective inguinal hernia repair
Class II-III symptoms, LVEF 55%
ไม่ใช่ candidate TAVR ทันที'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 60 ปี BMI 42, full stomach (last meal 2h ago) trauma, emergent appendectomy
Mallampati III, neck mobility ลดลง mild, thyromental 6 cm, no beard
SpO2 96% RA, BP 138/82', '[{"label":"A","text":"Awake fiberoptic intubation only option"},{"label":"B","text":"Rapid Sequence Induction (RSI) modified"},{"label":"C","text":"Slow inhalational induction"},{"label":"D","text":"Skip pre-oxygenation"},{"label":"E","text":"Mass bag-mask ventilation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Rapid Sequence Induction (RSI) modified: (1) Indications — full stomach, GERD, obstetric, trauma, ileus, emergency; (2) Preparation — suction working, multiple ETT sizes, video laryngoscope, bougie, SGA backup; team briefing; (3) Pre-oxygenation — 100% O2 × 3-5 min or 8 vital capacity breaths (target ETO2 > 90%); ramped position obese (HELP — Head Elevated Laryngoscopy Position); apneic oxygenation via NC 15 L/min during apnea (NODESAT); (4) Pre-treatment — analgesia (fentanyl 1-2 mcg/kg); lidocaine 1.5 mg/kg optional; (5) Induction — propofol 1.5-2.5 mg/kg OR etomidate 0.3 mg/kg (hemodynamic instability) OR ketamine 1-2 mg/kg (shock); (6) Paralysis — succinylcholine 1-1.5 mg/kg (fast onset 45-60s) OR rocuronium 1.2 mg/kg (alternative if sux contraindicated; sugammadex reversal); (7) Cricoid pressure (Sellick) — controversial; may worsen view + recent evidence less robust; selectively applied + released if difficult intubation; (8) NO bag-mask ventilation (avoid gastric insufflation) — unless desaturating, then GENTLE low-pressure; (9) Intubate — video laryngoscope first-pass success higher; (10) Confirm — EtCO2, bilateral breath sounds; (11) OG/NG decompression post-intubation; (12) RSI modifications obese: HELP position, pre-O2 + PEEP, apneic oxygenation, ETT cuff inflation immediately

---

RSI for full stomach: pre-O2, apneic O2 (NODESAT), HELP position obese, propofol/etomidate/ketamine + succinylcholine/rocuronium, video laryngoscopy, EtCO2 confirm. Cricoid controversial. NO ventilation unless desaturating.', NULL,
  'medium', 'respiratory', 'review',
  'anesthesiology', 'clinical_decision', 'respiratory', 'adult',
  'DAS Guidelines 2015; ASA Difficult Airway 2022', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 60 ปี BMI 42, full stomach (last meal 2h ago) trauma, emergent appendectomy
Mallampati III, neck mobility ลดลง mild, thyromental 6 cm, no beard
SpO2 96% RA, BP 138/82'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 50 ปี C5-C6 fracture from MVC requires emergency exploratory laparotomy
Cervical collar in place, GCS 14
Airway secured needs intubation
Known unstable C-spine', '[{"label":"A","text":"Full neck extension for direct laryngoscopy"},{"label":"B","text":"Unstable C-spine airway management"},{"label":"C","text":"Blind nasotracheal forceful"},{"label":"D","text":"Remove cervical collar fully"},{"label":"E","text":"Surgical airway first"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Unstable C-spine airway management: (1) Goal — minimize cervical spine movement during intubation (avoid worsening cord injury); (2) Manual In-Line Stabilization (MILS) — assistant maintains neutral position by holding head + mastoids during intubation; FRONT of collar removed (back stays); (3) Pre-oxygenation thorough; (4) Awake fiberoptic intubation — gold standard for known unstable C-spine — minimal neck movement + neuro check before + after; sedation (dexmedetomidine, remifentanil) + topical airway anesthesia; (5) Alternative — video laryngoscopy (GlideScope, McGrath, C-MAC) — better view with neutral position; (6) Direct laryngoscopy with MILS — option if other unavailable but increased difficulty; (7) AVOID — vigorous neck extension/flexion, blind techniques, nasal intubation if facial fracture; (8) RSI considerations — if full stomach + emergency: modified RSI with MILS + video laryngoscopy; (9) Equipment ready — multiple airway devices, surgical airway kit; (10) Post-intubation — neuro exam if possible, re-secure collar, document; (11) Cricoid pressure: applied carefully (may worsen C-spine alignment); (12) Multidisciplinary: anesthesia + neurosurgery + trauma

---

Unstable C-spine: MILS during intubation, awake fiberoptic gold standard, video laryngoscopy alternative. Front of collar removed only. Avoid vigorous neck movement. Multidisciplinary care.', NULL,
  'hard', 'trauma', 'review',
  'anesthesiology', 'clinical_decision', 'trauma', 'adult',
  'ASA Difficult Airway Guidelines 2022; Eastern Association Trauma Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 50 ปี C5-C6 fracture from MVC requires emergency exploratory laparotomy
Cervical collar in place, GCS 14
Airway secured needs intubation
Known unstable C-spine'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'GA case 45 ปี, intubated successfully with rocuronium
หลังจาก 5 นาที, SpO2 ลดลง 99 → 88%, ETCO2 ค่อยๆ rising 35 → 48, airway pressure increasing 22 → 35 cmH2O, wheezing bilateral, breath sounds decreased
No cardiovascular compromise', '[{"label":"A","text":"Continue current ventilation"},{"label":"B","text":"Intraoperative bronchospasm DDx + Mx"},{"label":"C","text":"Disconnect ventilator without action"},{"label":"D","text":"Stop volatile + extubate"},{"label":"E","text":"Beta-blocker IV"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Intraoperative bronchospasm DDx + Mx: (1) DDx — bronchospasm (asthma, COPD, anaphylaxis), endobronchial intubation, ETT obstruction (mucus plug, kink), pneumothorax, pulmonary edema, aspiration; (2) Immediate — 100% O2, hand ventilate to feel compliance, check ETT position (auscultate bilaterally, CXR if available, capnogram shark-fin shape = bronchospasm); (3) Deepen anesthesia — sevoflurane (bronchodilator), propofol bolus, ketamine (bronchodilator) 0.5-1 mg/kg; (4) Bronchodilators — salbutamol nebulizer via ETT or MDI 4-8 puffs through circuit (use spacer); ipratropium nebulizer; (5) IV — magnesium sulfate 2g over 20min, hydrocortisone 100mg or methylprednisolone, aminophylline (rarely); (6) Epinephrine — for severe (anaphylaxis or refractory): 10-100 mcg IV titrated; (7) Ventilation strategy — prolonged expiration (low rate, longer I:E 1:3 or 1:4), TV 6 mL/kg, permissive hypercapnia, watch for auto-PEEP; disconnect circuit to allow exhalation if severe air-trapping; (8) Check for anaphylaxis features — hypotension, urticaria, angioedema; (9) Rule out pneumothorax — auscultation, US, CXR; (10) If anaphylaxis suspected: epinephrine + steroid + antihistamine + fluid + cessation trigger; (11) Document + plan for future anesthetic

---

Intraop bronchospasm: deepen anesthesia (sevoflurane, propofol, ketamine), bronchodilators inhaled + IV, magnesium, steroid. Severe = epinephrine. Long expiration. Rule out anaphylaxis + pneumothorax + ETT issues.', NULL,
  'medium', 'respiratory', 'review',
  'anesthesiology', 'clinical_decision', 'respiratory', 'adult',
  'ASA Practice Advisory; Difficult Airway Society', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'GA case 45 ปี, intubated successfully with rocuronium
หลังจาก 5 นาที, SpO2 ลดลง 99 → 88%, ETCO2 ค่อยๆ rising 35 → 48, airway pressure increasing 22 → 35 cmH2O, wheezing bilateral, breath sounds decreased
No cardiovascular compromise'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 35 ปี GA 38 wk obese BMI 38 — emergency C-section for fetal distress
Mallampati IV, full stomach, no time for AFOI
GA induction attempted: 3 attempts failed intubation, BMV adequate, SpO2 maintained 96%', '[{"label":"A","text":"Continue attempts until succeed"},{"label":"B","text":"DAS Obstetric Failed Intubation algorithm"},{"label":"C","text":"Tracheostomy emergency"},{"label":"D","text":"Cancel C-section"},{"label":"E","text":"Mass paralytic re-dose"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** DAS Obstetric Failed Intubation algorithm: (1) Declare ''failed intubation'' after 2-3 attempts (limit 3); (2) Plan B — supraglottic airway (LMA, iGel, ProSeal LMA preferred — gastric port); 2nd generation SGA = safer for non-fasted obstetric; ventilate through SGA; (3) Consider whether to wake patient or proceed — depends on fetal condition + maternal stability + urgency: - WAKE if mother stable + non-immediate fetal distress + difficult airway → consider regional anesthesia (spinal if no CI) or AFOI; - PROCEED with SGA if cannot wake + critical fetal distress + adequate ventilation through SGA; (4) Continue cricoid pressure but release if difficulty (controversial); (5) If cannot intubate cannot oxygenate (CICO): EMERGENCY FRONT OF NECK ACCESS — cricothyrotomy (scalpel-bougie-tube technique per DAS); (6) Communicate clearly with team — declare failure + plan; (7) Obstetric considerations — capillary engorgement (smaller ETT 6.0-6.5), edema, full breasts impede laryngoscope; aspiration risk; rapid desaturation; (8) Prevention — pre-O2 thorough (30° HOB or ramped), apneic oxygenation, video laryngoscopy FIRST line in obstetric, optimal position (HELP); (9) MOH (Mother + Baby) safety priorities; (10) Document for future + alert anesthetist

---

DAS Obstetric failed intubation: limit attempts, 2nd gen SGA Plan B, wake vs proceed decision based on fetal + maternal status, CICO = surgical airway. Video laryngoscopy first-line obstetric. Pre-O2 + ramped.', NULL,
  'hard', 'obgyn', 'review',
  'anesthesiology', 'clinical_decision', 'obgyn', 'adult',
  'DAS/OAA Obstetric Difficult Airway Guidelines 2015', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 35 ปี GA 38 wk obese BMI 38 — emergency C-section for fetal distress
Mallampati IV, full stomach, no time for AFOI
GA induction attempted: 3 attempts failed intubation, BMV adequate, SpO2 maintained 96%'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 28 ปี post-thyroidectomy 6h ago — sudden onset stridor + distress + neck swelling visibly enlarging
SpO2 dropping 95→88%, hoarse, anxious
Surgical drain in place — minimal output', '[{"label":"A","text":"Reassurance + observation"},{"label":"B","text":"Post-thyroidectomy hematoma airway compromise = SURGICAL EMERGENCY"},{"label":"C","text":"Wait for OR available"},{"label":"D","text":"Increase IV fluid only"},{"label":"E","text":"Sedate to reduce anxiety"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-thyroidectomy hematoma airway compromise = SURGICAL EMERGENCY: (1) Immediate recognition — neck swelling + stridor + distress = compressing trachea + venous obstruction → laryngeal edema; (2) IMMEDIATE bedside drainage — open wound at bedside if airway compromise (do not wait for OR); cut sutures + evacuate hematoma; relieves compression + may stabilize airway transiently; (3) Call surgery + anesthesia STAT; (4) Airway management — challenging: laryngeal edema + distorted anatomy; avoid muscle relaxant until secured (loss of muscle tone may worsen); AWAKE fiberoptic intubation if time; or video laryngoscopy with awake/sedated; have surgical airway ready (cricothyrotomy/tracheostomy); (5) Smaller ETT (6.0-6.5) anticipate edema; (6) Sit upright if possible (helps venous drainage + comfort); (7) 100% O2, position upright, IV access; (8) Hold heparin/anticoagulants; reverse if applicable; (9) After airway secured: return to OR for definitive hemostasis; (10) Drain output may NOT reflect actual bleeding (may be clotted or extra-luminal); (11) Risk factors: bleeding diathesis, hypertension, vigorous coughing, retrosternal goiter; (12) Post-op: observe at least 6h with neck visualization, drain monitoring

---

Post-thyroidectomy hematoma: SURGICAL EMERGENCY. Bedside wound opening immediately. Awake fiberoptic intubation. Surgical airway backup. Drain output unreliable. Sit upright. Avoid muscle relaxant until secured.', NULL,
  'hard', 'respiratory', 'review',
  'anesthesiology', 'clinical_decision', 'respiratory', 'adult',
  'ASA Difficult Airway Guidelines; AAOHNS Thyroidectomy Complications', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 28 ปี post-thyroidectomy 6h ago — sudden onset stridor + distress + neck swelling visibly enlarging
SpO2 dropping 95→88%, hoarse, anxious
Surgical drain in place — minimal output'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย GA case ASA II 40 ปี — after extubation in PACU, SpO2 drops 99→82%, paradoxical chest-abdomen movement, suprasternal retractions, stridor inspiratory, agitated
Received neuromuscular block reversal (neostigmine + glycopyrrolate) 10 min ago
TOF train-of-four ratio not measured', '[{"label":"A","text":"Re-anesthetize + intubate immediately"},{"label":"B","text":"Post-extubation laryngospasm + residual neuromuscular block DDx"},{"label":"C","text":"IV fluid bolus only"},{"label":"D","text":"Wait silently"},{"label":"E","text":"Sedate with midazolam"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-extubation laryngospasm + residual neuromuscular block DDx: (1) Laryngospasm — inspiratory stridor, paradoxical movement, suprasternal retraction; treat: 100% O2 + jaw thrust + CPAP + remove stimuli + Larson maneuver (digital pressure ''laryngospasm notch'' behind ear lobe); deepen anesthesia (propofol 0.5-1 mg/kg IV); IM succinylcholine 1-2 mg/kg if persistent or hypoxic (IV faster if access); (2) Residual neuromuscular blockade (PORC) — TOF ratio < 0.9 = inadequate reversal, presents with weakness, swallowing difficulty, airway obstruction; treat: sugammadex 2-4 mg/kg if rocuronium/vecuronium (immediate complete reversal); or neostigmine + glyco re-dose if deeper block; (3) Negative pressure pulmonary edema (NPPE) — from laryngospasm + forced inspiration against closed glottis; treat: O2, PEEP, diuretic, supportive; (4) Other DDx — opioid-induced respiratory depression (naloxone), upper airway edema, foreign body, vocal cord paralysis (recurrent laryngeal nerve injury); (5) Modern: quantitative TOF monitoring should be ROUTINE for all NMB use (ASA standard); sugammadex preferred over neostigmine for deeper blocks; (6) Prevention: assure TOF > 0.9 before extubation, quantitative monitoring, sugammadex for difficult reversal

---

Post-extubation distress DDx: laryngospasm (CPAP, Larson, deepen, sux), residual NMB (sugammadex), NPPE, opioid-induced. Quantitative TOF routine standard. Sugammadex preferred.', NULL,
  'medium', 'respiratory', 'review',
  'anesthesiology', 'clinical_decision', 'respiratory', 'adult',
  'ASA NMB Monitoring Practice Advisory 2023; APSF', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วย GA case ASA II 40 ปี — after extubation in PACU, SpO2 drops 99→82%, paradoxical chest-abdomen movement, suprasternal retractions, stridor inspiratory, agitated
Received neuromuscular block reversal (neostigmine + glycopyrrolate) 10 min ago
TOF train-of-four ratio not measured'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 65 ปี laryngeal cancer with stridor pre-op — elective laryngectomy + tracheostomy
Mallampati IV, fixed laryngeal mass invading hypopharynx
Plan = awake tracheostomy under local', '[{"label":"A","text":"Standard GA + RSI"},{"label":"B","text":"Compromised airway anesthesia plan"},{"label":"C","text":"Blind nasal intubation"},{"label":"D","text":"IV induction + paralysis first"},{"label":"E","text":"Mass sedation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Compromised airway anesthesia plan: (1) Pre-op airway assessment — flexible nasal endoscopy by ENT, imaging (CT) to define obstruction level + degree; multidisciplinary planning ENT + anesthesia; (2) Awake tracheostomy under local anesthesia = safest for severe upper airway obstruction (preserves spontaneous ventilation); (3) Preparation — ENT + surgical airway ready, all difficult airway equipment, multiple plans; team brief; (4) Position — supine but head of bed up 30°; pre-oxygenate; (5) Local anesthesia — lidocaine + epinephrine subcutaneous + deeper tissues; minimal sedation (avoid losing airway) — small dose dexmedetomidine 0.5 mcg/kg/hr titrated, OR remifentanil low-dose; (6) Surgical access — neck dissection to trachea; insert tracheostomy tube; confirm position + ventilation; (7) ONLY after secure airway: induce GA with propofol + NMB; (8) Alternative plans: awake fiberoptic intubation (if can pass scope through obstruction), inhalational induction maintaining spontaneous ventilation (sevoflurane in O2), rigid bronchoscopy with jet ventilation (ENT in OR); (9) AVOID — paralytic before secured airway, IV induction first; (10) Equipment — multiple ETT sizes (smaller anticipate), tracheal tubes, jet ventilation, ECMO standby for high-grade obstruction; (11) Communication — patient awake, reassure, explain steps

---

Compromised airway: awake tracheostomy under local = safest. ENT + anesthesia plan. Preserve spontaneous ventilation. NEVER paralyze before secured. Multiple plans + equipment ready. Modern: multidisciplinary head-and-neck airway teams.', NULL,
  'hard', 'respiratory', 'review',
  'anesthesiology', 'clinical_decision', 'respiratory', 'adult',
  'DAS Awake Tracheal Intubation Guidelines 2020; ENT-Anesthesia Collaboration', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 65 ปี laryngeal cancer with stridor pre-op — elective laryngectomy + tracheostomy
Mallampati IV, fixed laryngeal mass invading hypopharynx
Plan = awake tracheostomy under local'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 75 ปี severe lumbar spinal stenosis — total knee arthroplasty
Meds: enoxaparin 40 mg SC HS prophylactic, lastdose 14h ago
INR normal, plt 240k, no anticoagulant other
Plan: regional anesthesia preferred', '[{"label":"A","text":"Proceed spinal immediately"},{"label":"B","text":"ASRA Anticoagulation + Neuraxial Guidelines"},{"label":"C","text":"GA mandatory regardless"},{"label":"D","text":"Continue enoxaparin same day"},{"label":"E","text":"Stop ASA 7 days for spinal"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** ASRA Anticoagulation + Neuraxial Guidelines: (1) LMWH prophylactic dose (enoxaparin 40 mg SC daily) — wait 12h since last dose before neuraxial; this patient 14h = OK to proceed; (2) LMWH therapeutic dose (1 mg/kg BID or 1.5 mg/kg daily) — wait 24h; (3) Unfractionated heparin SC ≤ 5000U BID — no delay; ≥ 7500U BID or TID — 12h hold + normal aPTT; (4) Heparin infusion IV — stop 4-6h + aPTT normal; (5) Warfarin — INR ≤ 1.5; (6) DOAC — apixaban/rivaroxaban 72h hold (longer renal); dabigatran 5 days (CrCl < 50); (7) ASA + NSAID — no delay neuraxial; (8) Clopidogrel — 5-7 days; ticagrelor — 5-7 days; prasugrel — 7-10 days; (9) Restart anticoagulation post-procedure — LMWH prophylactic 12h after; LMWH therapeutic 24h; remove catheter 12h after last LMWH dose + next dose 4h later; (10) Spinal stenosis = relative contraindication concern: harder to find space, increased neuraxial hematoma risk, neurologic complication if hematoma; some advocate avoid neuraxial in severe stenosis; (11) Alternative: spinal saddle block, adductor canal + femoral block, peripheral nerve block, GA; (12) Document discussion + plan + neuro exam baseline

---

ASRA Anticoagulation Guidelines: LMWH prophylactic 12h, therapeutic 24h. DOAC 72h. Clopidogrel 5-7d. Spinal stenosis = relative concern. Peripheral nerve block alternative. Document.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'anesthesiology', 'clinical_decision', 'msk_nontrauma', 'adult',
  'ASRA Anticoagulation Guidelines 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 75 ปี severe lumbar spinal stenosis — total knee arthroplasty
Meds: enoxaparin 40 mg SC HS prophylactic, lastdose 14h ago
INR normal, plt 240k, no anticoagulant other
Plan: regional anesthesia preferred'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 55 ปี received epidural for thoracotomy at T6-7 level, catheter in place 48h post-op
Nurse calls: lower extremity weakness developing × 4h, progressive
Incontinence new
Block not infusing > 1h', '[{"label":"A","text":"Increase epidural infusion"},{"label":"B","text":"Suspected epidural hematoma"},{"label":"C","text":"Wait 24h to see if resolves"},{"label":"D","text":"Pull catheter immediately"},{"label":"E","text":"Give more local anesthetic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Suspected epidural hematoma — EMERGENCY: (1) Recognition — new or progressive lower extremity weakness/sensory loss + bowel/bladder dysfunction in patient with neuraxial; (2) DDx — epidural hematoma, epidural abscess, residual local anesthetic, vascular event (anterior spinal artery syndrome), retained catheter; (3) IMMEDIATE — stop infusion (already done), urgent MRI spine (gold standard); avoid LP; (4) Neurosurgery consult URGENT — surgical decompression within 8h of symptom onset critical for neuro recovery; (5) Coagulation status — INR, PTT, platelets, fibrinogen; correct coagulopathy if present (FFP, platelets); review anticoagulation/antiplatelet history; (6) Catheter removal — only after coagulation OK (12h after LMWH prophylactic); document timing; (7) MRI findings — hyperintense on T1/T2 acute hematoma, mass effect on cord; abscess shows enhancement + rim; (8) Surgery — emergent laminectomy + clot evacuation; outcome best if < 8h symptoms; (9) Document time of onset + serial neuro exams q1h; (10) Risk factors — anticoagulation (highest), age, female, traumatic placement, multiple attempts, anatomic abnormalities; (11) Prevention — follow ASRA timing, careful placement, neuro checks after neuraxial; (12) Don''t miss: spinal abscess (fever, back pain, days later, immunocompromised)

---

Post-neuraxial new weakness = EMERGENCY. Urgent MRI + neurosurgery. Surgical decompression < 8h. DDx hematoma, abscess. Document neuro exam. Coag check + reverse. ASRA timing for catheter removal.', NULL,
  'hard', 'neurology', 'review',
  'anesthesiology', 'clinical_decision', 'neurology', 'adult',
  'ASRA Anticoagulation 2018; ASA Neuraxial Complications', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 55 ปี received epidural for thoracotomy at T6-7 level, catheter in place 48h post-op
Nurse calls: lower extremity weakness developing × 4h, progressive
Incontinence new
Block not infusing > 1h'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 30 ปี post-spinal anesthesia for C-section, day 2
Severe positional headache (worse upright, better supine)
Frontal-occipital, neck stiffness, photophobia
No fever, no focal deficit', '[{"label":"A","text":"Lumbar puncture diagnostic"},{"label":"B","text":"Post-dural puncture headache (PDPH)"},{"label":"C","text":"Antibiotic empirically"},{"label":"D","text":"Discharge no follow-up"},{"label":"E","text":"Immediate craniotomy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-dural puncture headache (PDPH): (1) Diagnosis — positional headache (worse upright, better supine) within 5 days post-neuraxial; CSF leak → low pressure → cerebral vasodilation + traction; auditory symptoms (tinnitus, hearing loss), neck stiffness, photophobia, nausea; (2) Risk factors — young female, pregnancy, low BMI, prior PDPH, large needle, cutting needle (Quincke), multiple attempts; (3) Prevention — pencil-point needle (Whitacre, Sprotte) smaller gauge (25-27G); single attempt; bevel orientation parallel to fibers; (4) Conservative initial — bed rest, hydration (oral + IV), caffeine (300 mg PO or 500 mg IV), analgesics (acetaminophen, NSAID), abdominal binder; many resolve 1-7 days; avoid Trendelenburg (worsens); (5) Epidural blood patch (EBP) = definitive treatment if conservative fails or severe disability: 15-20 mL autologous blood injected sterile epidural at or one level below puncture; 60-90% success first attempt, repeat if needed; precautions — sterile technique, sit up after to seal; (6) Sphenopalatine ganglion block — emerging non-invasive option (lidocaine via nasal catheter); (7) Other options — gabapentin, theophylline, ACTH, hydrocortisone (less evidence); (8) Differential — meningitis (fever, WBC), cortical vein thrombosis (focal deficit, seizure), pre-eclampsia (HTN), tension/migraine, intracranial bleed; LP only if meningitis suspected (otherwise worsens); (9) Reassure + counsel; future neuraxial OK with proper technique

---

PDPH: positional, post-neuraxial. Conservative first (caffeine, hydration), EBP definitive if persistent. Pencil-point needles prevent. DDx meningitis, cortical vein thrombosis, pre-eclampsia. Sphenopalatine block emerging.', NULL,
  'easy', 'neurology', 'review',
  'anesthesiology', 'clinical_decision', 'neurology', 'adult',
  'ASA Neuraxial; SOAP PDPH Consensus 2023', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 30 ปี post-spinal anesthesia for C-section, day 2
Severe positional headache (worse upright, better supine)
Frontal-occipital, neck stiffness, photophobia
No fever, no focal deficit'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 50 ปี mastectomy + axillary dissection — plan = paravertebral block T2-T6 for analgesia + GA
Ultrasound-guided technique
Received bupivacaine 0.5% 5 mL × 5 levels', '[{"label":"A","text":"Standard GA only without regional"},{"label":"B","text":"Paravertebral block (PVB) for breast surgery"},{"label":"C","text":"Continuous epidural T6 level"},{"label":"D","text":"Brachial plexus block"},{"label":"E","text":"Caudal block"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Paravertebral block (PVB) for breast surgery: (1) Indication — unilateral chest wall/abdominal analgesia; breast surgery (lumpectomy, mastectomy), thoracotomy, rib fracture, hernia; (2) Anatomy — paravertebral space wedge-shaped, bordered by superior costotransverse ligament + parietal pleura; contains spinal nerve root + sympathetic chain; (3) Ultrasound-guided technique preferred — paramedian sagittal view (count ribs + transverse processes), in-plane needle, observe LA spread anteriorly + pleural depression; (4) Multiple levels needed for breast — T2-T6; volume 3-5 mL per level OR larger single-level injection (15-20 mL) for spread; (5) LA — bupivacaine 0.25-0.5%, ropivacaine 0.375-0.5%; adjuvant — epinephrine, dexamethasone, dexmedetomidine prolong duration; (6) Continuous catheter for prolonged analgesia; (7) Advantages over epidural — unilateral (less hemodynamic), preserves bladder + lower extremity, less PONV; better than no block for cancer recurrence theory (volatile/opioid sparing); (8) Complications — pleural puncture/pneumothorax (1-5%), vascular puncture, intrathecal injection (rare but devastating), hypotension (less than epidural), LAST; (9) Alternatives — erector spinae plane block (ESP — easier, safer, similar efficacy), serratus anterior plane block, PECS I/II; (10) Modern: regional anesthesia for breast surgery reduces opioid + PONV + chronic post-mastectomy pain; (11) Multimodal post-op

---

PVB for breast: T2-T6, ultrasound-guided, unilateral sympathectomy, less hemodynamic vs epidural. Alternatives ESP, serratus, PECS. Pleural puncture risk. Reduces chronic pain.', NULL,
  'medium', 'procedures', 'review',
  'anesthesiology', 'clinical_decision', 'procedures', 'adult',
  'ASRA Regional Anesthesia; PROSPECT Breast Surgery Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 50 ปี mastectomy + axillary dissection — plan = paravertebral block T2-T6 for analgesia + GA
Ultrasound-guided technique
Received bupivacaine 0.5% 5 mL × 5 levels'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 55 ปี received ultrasound-guided supraclavicular block for forearm surgery
5 min later: SpO2 88%, dyspnea, decreased breath sounds R chest
BP 130/80, HR 95
CXR pending', '[{"label":"A","text":"Continue surgery"},{"label":"B","text":"Pneumothorax after supraclavicular block"},{"label":"C","text":"Ignore breath sounds"},{"label":"D","text":"More local anesthetic"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pneumothorax after supraclavicular block: (1) Recognition — dyspnea + decreased ipsilateral breath sounds + hypoxia after supraclavicular/infraclavicular block; risk 0.5-6% (lower with ultrasound vs blind); (2) Confirm — bedside ultrasound (absence of lung sliding, lung point sign), CXR upright expiratory; (3) Management depends on size + symptoms: - Small + stable: O2 supplemental + observation + serial imaging; - Symptomatic + > 15-20% or expanding: tube thoracostomy chest tube; - Tension pneumothorax: emergent needle decompression (2nd ICS midclavicular or 4-5th ICS midaxillary) then chest tube; (4) Avoid positive pressure ventilation if can (worsens pneumothorax); if intubated: small TV, low PEEP; (5) Postpone elective surgery; (6) Other complications supraclavicular block: phrenic nerve palsy (50-100%), Horner syndrome, recurrent laryngeal nerve palsy, intravascular injection + LAST, nerve injury; (7) Phrenic palsy — generally well-tolerated in healthy; severe respiratory disease (COPD): consider alternative block (infraclavicular, axillary); (8) Alternatives — interscalene (shoulder), infraclavicular (forearm), axillary (forearm/hand); (9) Prevention — ultrasound guidance, in-plane needle, careful visualization, avoid deep insertion; (10) Document + counsel

---

Pneumothorax post-supraclavicular: dyspnea + decreased BS + hypoxia. Ultrasound confirm. Size-based Mx. Avoid PPV. Alternatives infraclavicular/axillary. Phrenic palsy common but usually tolerated.', NULL,
  'medium', 'respiratory', 'review',
  'anesthesiology', 'clinical_decision', 'respiratory', 'adult',
  'ASRA Regional Anesthesia Complications; NYSORA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 55 ปี received ultrasound-guided supraclavicular block for forearm surgery
5 min later: SpO2 88%, dyspnea, decreased breath sounds R chest
BP 130/80, HR 95
CXR pending'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 28 ปี G2P1 GA 38 wk severe pre-eclampsia
BP 165/110, proteinuria 3+, headache, RUQ pain
Plt 75k, AST 120, ALT 95
Urgent C-section indicated', '[{"label":"A","text":"Spinal anesthesia routine dose"},{"label":"B","text":"Severe pre-eclampsia + HELLP"},{"label":"C","text":"Wait BP to normalize naturally"},{"label":"D","text":"Mass crystalloid bolus"},{"label":"E","text":"Skip magnesium"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe pre-eclampsia + HELLP — anesthesia management: (1) BP control — labetalol 20mg IV bolus q10min (max 300mg) OR hydralazine 5-10mg IV q20min OR nicardipine infusion; target SBP 140-160, DBP 90-100; (2) Seizure prophylaxis — magnesium sulfate 4-6g loading + 1-2g/hr infusion (continue 24h post-delivery); monitor reflexes + RR + urine output; signs toxicity: loss DTR (8-10), respiratory depression (12), cardiac arrest (15+); antidote calcium gluconate 1g IV; (3) Anesthesia choice based on platelets: - Plt > 70-80k + no rapid drop + no other coag issues = neuraxial generally safe; some advocate higher threshold (100k); spinal preferred over epidural (smaller needle); - Plt < 70k or rapidly dropping = GA with careful airway (edema, full stomach, RSI); video laryngoscopy first; smaller ETT; expect HTN response to laryngoscopy — treat (lidocaine, opioid, magnesium); (4) Airway considerations — edema, weight gain, friability; difficult airway anticipated; (5) Volume — judicious (pulmonary edema risk); avoid fluid overload; (6) Fetal: neonatal team ready; (7) Post-op — ICU/HDU 24h, continue magnesium, monitor for eclampsia, BP control, fluid balance, pulmonary edema, AKI, abruption, DIC; (8) Magnesium prolongs NMB — reduce NMB dose; (9) Avoid ergot (BP), methergine; oxytocin slow (hypotension); carboprost contraindicated (asthma); (10) Multidisciplinary: anesthesia + OB + neonatology + ICU

---

Severe PEC/HELLP: labetalol/hydralazine, magnesium prophylaxis, neuraxial if plt > 70-80k, GA with difficult airway prep if low plt. Volume judicious. Magnesium toxicity Ca antidote. Multidisciplinary post-op ICU.', NULL,
  'hard', 'obgyn', 'review',
  'anesthesiology', 'clinical_decision', 'obgyn', 'adult',
  'SOAP Consensus on Hypertensive Disorders; ACOG Practice Bulletin', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 28 ปี G2P1 GA 38 wk severe pre-eclampsia
BP 165/110, proteinuria 3+, headache, RUQ pain
Plt 75k, AST 120, ALT 95
Urgent C-section indicated'
  );

commit;

