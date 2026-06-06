-- ===============================================================
-- UPDATE: anesthesiology (200 questions)
-- ===============================================================

begin;

update public.mcq_questions
set choices = '[{"label":"A","text":"Cancel surgery"},{"label":"B","text":"Continue chronic medications"},{"label":"C","text":"Cardiac catheterization preoperative"},{"label":"D","text":"Stop all medications"},{"label":"E","text":"Refuse surgery"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pre-op cardiac evaluation per AHA/ACC 2014 + ESC 2022 — High-risk surgery (vascular) + intermediate risk patient: (1) RCRI = 2 (CAD + DM on insulin if applicable, or here CAD + high-risk surgery) — intermediate risk (2-2.4%); (2) Functional capacity ≥ 4 METs adequate; (3) **Continue chronic medications**: aspirin (continue per surgical bleeding risk — vascular usually continue), statin (continue — cardioprotective, mortality benefit), beta-blocker (continue — sudden discontinuation harmful); ACE inhibitor — hold morning of surgery (hypotension intra-op); metformin — hold day of surgery (lactic acidosis risk if AKI); (4) **No additional stress testing** indicated (functional capacity OK); (5) **Pre-op consultation as needed**: cardiology if symptoms or new abnormalities; (6) Glycemic control: target intra-op 140-180; (7) Anesthetic plan: epidural for analgesia (open AAA), general anesthesia, invasive monitoring (arterial line, CVL), aortic cross-clamp considerations, cell saver, blood products available, temperature management; (8) Multidisciplinary: surgery + anesthesia + cardiology if needed; (9) Post-op: ICU monitoring, pain control, continue beta-blocker + statin, DVT prophylaxis, hyperglycemia management

---

Pre-op cardiac evaluation: AHA/ACC 2014 stepwise approach. RCRI + functional capacity. Continue chronic medications (beta-blocker, statin) — sudden discontinuation harmful. Hold ACE inhibitor day of surgery. Metformin caution AKI. No additional stress test if functional capacity adequate. Pre-op coronary revascularization not routinely beneficial (CARP trial). Anesthetic plan + ICU monitoring.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยอายุ 68 ปี underlying HT, T2DM, CAD post-PCI 2 ปีที่แล้ว — pre-op evaluation for elective open AAA repair

Functional capacity: 4 METs (can walk up stairs)
Meds: aspirin, atorvastatin, metoprolol, enalapril, metformin
No angina + no recent CHF + no arrhythmia
Lab: HbA1c 7.2%, Cr 1.2, normal CBC, BUN
EKG: old Q wave inferior, no acute changes
Echo: LVEF 50% with mild inferior hypokinesia';

update public.mcq_questions
set choices = '[{"label":"A","text":"Standard induction without preparation"},{"label":"B","text":"Difficult Airway Management — pre-op preparation"},{"label":"C","text":"Blind nasotracheal"},{"label":"D","text":"Surgery without intubation"},{"label":"E","text":"Refuse case"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Difficult Airway Management — pre-op preparation: (1) **Predict difficult airway**: LEMON (Look, Evaluate 3-3-2, Mallampati, Obstruction, Neck mobility), MOANS (Mask, Obese, Age, No teeth, Stiff lungs); (2) **Multimodal preparation**: 2 difficult airway providers available, multiple equipment options ready; (3) **Pre-oxygenation thoroughly** (3-5 min FRC washout or 8 vital capacity breaths); high-flow nasal O2 during apnea (THRIVE — Transnasal Humidified Rapid Insufflation Ventilatory Exchange); (4) **Awake fiberoptic intubation** preferred for known/predicted difficult airway — sedation (dexmedetomidine, remifentanil), topical anesthesia (lidocaine spray/nebulized/atomized), supplemental O2; (5) **Video laryngoscopy** (GlideScope, McGrath, C-MAC) — better view + first-attempt success; (6) **Supraglottic airway** (LMA Fastrach, iGel, AirQ — conduit for ETT) — backup or primary; (7) **DAS (Difficult Airway Society) algorithm**: Plan A (intubation) → Plan B (SGA) → Plan C (face mask ventilation) → Plan D (emergency front of neck access — cricothyrotomy, surgical airway); (8) **Equipment ready**: bougie, multiple ETT sizes + types, multiple laryngoscope blades, SGA, fiberscope, cricothyrotomy kit; (9) **Communication + team**: brief plan + contingencies; (10) **Avoid prolonged hypoxia**: limit attempts (3 max), maintain oxygenation between attempts, wake patient if unable to intubate or ventilate ("awaken" option); (11) **OSA considerations**: continue CPAP intra-op (some surgeries) + post-op; (12) **Documentation** of difficult airway + future planning

---

Difficult airway management: prediction (LEMON, MOANS) + preparation. Awake fiberoptic intubation preferred for known/predicted. Video laryngoscopy improves first-pass success. DAS algorithm: Plan A→B→C→D. Equipment ready. Team communication. Limit attempts (3). Awaken option. OSA continuation CPAP. Documentation. Modern: video laryngoscopy widespread + DAS algorithm.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยอายุ 55 ปี underlying obesity BMI 38, OSA on CPAP, hypertension — undergoing elective laparoscopic cholecystectomy

Mallampati class IV, thyromental distance 5 cm, limited neck extension, large neck circumference 45 cm, beard

Predicts difficult airway';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait + see"},{"label":"B","text":"Local Anesthetic Systemic Toxicity (LAST) — life-threatening complication of LA"},{"label":"C","text":"Calcium gluconate only"},{"label":"D","text":"Surgery"},{"label":"E","text":"Discharge"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Local Anesthetic Systemic Toxicity (LAST) — life-threatening complication of LA: (1) **CNS symptoms first** (lower threshold than CV): perioral numbness → tinnitus → metallic taste → dizziness → AMS → seizure → coma; (2) **CV later** (higher threshold): hypotension → arrhythmia (bradycardia, ventricular) → cardiac arrest; (3) **Bupivacaine cardiac toxicity** worst — high lipid solubility + sodium channel blockade — refractory to standard ACLS; (4) **Immediate management** (ASRA Checklist 2017): - Call for help + LAST checklist + lipid emulsion; - Airway/breathing: 100% O2, hyperventilate to alkalosis (improves CV outcome); - Stop LA delivery if ongoing; - Seizure: benzodiazepine (lorazepam, midazolam) preferred over propofol (propofol may further reduce CV function); - **Lipid emulsion 20% (Intralipid)** — first-line for cardiotoxicity: 1.5 mL/kg IV bolus over 1 min (~100 mL adult) → infusion 0.25 mL/kg/min × 30 min minimum; repeat bolus + double infusion if needed; max 12 mL/kg total; mechanism — lipid sink + metabolic; (5) **Modified ACLS** for cardiac arrest: chest compressions, lipid emulsion priority over epinephrine (small doses 1 mcg/kg if needed — high-dose epi may worsen); AVOID vasopressin, beta-blocker, Ca channel blocker, LA (lidocaine); (6) **Cardiopulmonary bypass / ECMO** for refractory arrest; (7) **Prolonged resuscitation** (> 1 hour) — case reports of survival; (8) **Prevention**: aspiration test before injection, slow incremental injection, ultrasound guidance, test dose with epinephrine; appropriate dose for weight (max 2-3 mg/kg bupivacaine); (9) **Document + report** — quality improvement

---

LAST = life-threatening LA complication. Mortality high if not recognized. CNS symptoms first → CV later. Bupivacaine cardiotoxicity worst. **Lipid emulsion 20% first-line treatment** (cornerstone). ASRA Checklist. Avoid vasopressin, beta-blocker, CCB, LA. Lipid sink mechanism. Prevention: ultrasound, aspiration test, test dose, max dose. Modern: lipid emulsion saved many lives.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยอายุ 28 ปี healthy elective knee arthroscopy under spinal anesthesia (bupivacaine 10mg) + epinephrine

Procedure: 45 min, uneventful
Post-op: patient develops perioral numbness then dizziness then tinnitus then mental status changes then seizure

UDS negative, no other drug exposure
LA accidentally given IV vs spinal in error';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait + observe"},{"label":"B","text":"Post-Spinal Anesthesia Hypotension (Sympathectomy + IVC compression by gravid uterus)"},{"label":"C","text":"Supine flat position"},{"label":"D","text":"Reduce fluid"},{"label":"E","text":"Stop monitoring"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-Spinal Anesthesia Hypotension (Sympathectomy + IVC compression by gravid uterus): (1) **Left lateral tilt** (Wedge under right hip) — relieves IVC compression by gravid uterus, improves venous return; (2) **IV fluid co-loading** during spinal (better than pre-loading) — crystalloid + colloid; (3) **Vasopressor**: - **Phenylephrine** first-line (alpha-1 agonist — restores SVR + reflex bradycardia rare in OB); start prophylactic infusion 25-50 mcg/min; rescue bolus 50-100 mcg; - **Norepinephrine** alternative (alpha + mild beta — less bradycardia than phenylephrine; growing use); - **Ephedrine** (mixed alpha-beta) — historic first-line but causes neonatal acidosis more than phenylephrine (Ngan Kee); (4) **Bradycardia**: atropine 0.4-0.6 mg if symptomatic + hypotensive; (5) **Oxygen supplementation**; (6) **Nausea management**: ondansetron, metoclopramide; (7) **Monitor fetal heart** — fetal hypoxia risk from maternal hypotension; (8) **Prevention**: prophylactic phenylephrine infusion from time of spinal (mainstay modern OB anesthesia per Ngan Kee + Carvalho); left lateral tilt; fluid; (9) **Other causes of hypotension during C-section**: hemorrhage (placenta previa, abruption, atony), uterine inversion, amniotic fluid embolism, anaphylaxis, supine hypotensive syndrome; (10) Multidisciplinary: OB + anesthesia + neonatal team

---

Post-spinal hypotension common in OB (sympathectomy + IVC compression). Left lateral tilt + IV fluid co-loading + phenylephrine prophylactic infusion = standard care. Modern: phenylephrine > ephedrine (better fetal pH). Norepinephrine emerging alternative. Bradycardia atropine. Fetal monitoring. Prevention better than treatment.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยอายุ 32 ปี G2P1 GA 39 wk elective C-section under spinal anesthesia + bupivacaine + morphine + fentanyl

5 min after spinal: BP drops 90/60 → 70/40, HR drops 92 → 55, patient nauseous

Fetal heart 142 stable';

update public.mcq_questions
set choices = '[{"label":"A","text":"Increase volatile anesthetic"},{"label":"B","text":"Malignant Hyperthermia (MH) — rare life-threatening complication: triggered by volatile anesthetics + succinylcholine in genetically susceptible (RYR1, CACNA1S mutations — autosomal dominant)"},{"label":"C","text":"Wait + observe"},{"label":"D","text":"Increase muscle relaxant"},{"label":"E","text":"Stop monitoring"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Malignant Hyperthermia (MH) — rare life-threatening complication: triggered by volatile anesthetics + succinylcholine in genetically susceptible (RYR1, CACNA1S mutations — autosomal dominant): (1) **Stop triggering agents** immediately — volatile + succinylcholine; switch to non-triggering (propofol, opioid, NMB rocuronium/cisatracurium); change anesthesia circuit + soda lime + ventilator; (2) **Hyperventilate 100% O2** at 10 L/min minimum to flush volatile; (3) **Dantrolene** — specific antidote — 2.5 mg/kg IV bolus, repeat every 5-10 min up to 10 mg/kg total; dantrolene blocks RYR1 + decreases muscle Ca release; new formulation (Ryanodex) faster reconstitution; (4) **Active cooling**: cold IV fluids, ice packs to groin/axillae/neck, cooling blankets, peritoneal/gastric lavage with cold saline if severe; STOP at 38-38.5°C to avoid overshoot hypothermia; (5) **Treat acidosis**: bicarbonate, hyperventilation; (6) **Treat hyperkalemia**: insulin + glucose, Ca, kayexalate; (7) **Treat arrhythmias**: standard ACLS — but AVOID calcium channel blockers (interact with dantrolene); (8) **Monitor + treat rhabdomyolysis**: IV fluid, alkalinize urine (urine output > 2 mL/kg/hr), monitor CK + myoglobin + AKI; (9) **ICU admission** for at least 24-48 hours — recrudescence risk; continue dantrolene 1 mg/kg q6h × 24h; (10) **Counsel family** — autosomal dominant, family screening with muscle biopsy/in vitro contracture test or genetic testing; future surgeries need non-triggering anesthetic + MH precautions; (11) **MH Hotline** (US 1-800-MH-HYPER) — expert consultation; **MHAUS** (Malignant Hyperthermia Association)

---

MH = anesthetic emergency. Triggered by volatile anesthetics + succinylcholine. Autosomal dominant (RYR1, CACNA1S). Hypermetabolic crisis. Dantrolene is specific antidote. Active cooling. Treat acidosis, hyperkalemia, rhabdo. ICU recrudescence risk. Family screening. Avoid CCB (interact). Modern: Ryanodex (faster dantrolene). MHAUS expert consultation. Modern mortality < 5% with prompt treatment (was > 70%).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยอายุ 14 ปี healthy elective tonsillectomy under general anesthesia

30 min into surgery — temp rises rapidly 39.8°C → 40.5°C, HR 140, EtCO2 rising 35 → 55 mmHg despite increasing ventilation, muscle rigidity especially masseter, mottled skin, dark urine starts appearing

Using volatile (sevoflurane) + succinylcholine for intubation

Family: cousin died during dental surgery years ago';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue case"},{"label":"B","text":"Intraoperative Anaphylaxis — anesthesia emergency"},{"label":"C","text":"Antibiotic again"},{"label":"D","text":"Continue propofol"},{"label":"E","text":"Discharge to PACU"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Intraoperative Anaphylaxis — anesthesia emergency: (1) **Immediate**: notify team, call for help, stop suspected trigger (cefazolin most likely, also rocuronium common); (2) **Epinephrine first-line**: 100-200 mcg IV bolus + repeat every 1-2 min as needed; severe — IV infusion 1-10 mcg/min titrated; (3) **Airway + ventilation**: 100% O2, may need increased PEEP for severe bronchospasm; consider salbutamol nebulizer; (4) **Volume resuscitation**: IV crystalloid 20-30 mL/kg rapid (distributive shock + capillary leak); colloid alternative; (5) **Reverse Trendelenburg or position to optimize venous return**; (6) **Secondary medications**: H1 antihistamine (diphenhydramine 50 mg IV), H2 antihistamine (ranitidine 50 mg IV), corticosteroid (hydrocortisone 200 mg IV or methylprednisolone 1-2 mg/kg) — prevent biphasic + late-phase; (7) **Glucagon** 1-5 mg IV if on beta-blocker (epinephrine-refractory); (8) **Refractory shock**: norepinephrine, vasopressin, methylene blue (selected); ECMO last resort; (9) **Consider whether to continue or abort surgery** — case-by-case based on stability + necessity; (10) **Post-event**: tryptase level (within 1-3h), document trigger, follow-up allergy testing + skin testing (4-6 weeks later for accurate); medic-alert; (11) **Documentation** for future anesthesia care; (12) **Differential**: hemorrhage, PE, MI, pneumothorax, MH, sepsis; (13) **Most common triggers**: NMB (rocuronium most), antibiotics (cefazolin, vancomycin), latex, chlorhexidine, contrast, blood products; (14) Multidisciplinary: anesthesia + surgery + allergy follow-up

---

Intraoperative anaphylaxis: anesthesia emergency. Most common triggers: NMB, antibiotics, latex. Epinephrine first-line. Volume resuscitation. Secondary meds (antihistamine, steroid). Glucagon for beta-blocker users. Tryptase level for confirmation. Future testing + documentation. Multidisciplinary care.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยอายุ 45 ปี elective laparoscopic cholecystectomy under general anesthesia

15 min after IV abx (cefazolin): BP drops 130/80 → 60/30, HR rises 80 → 130, urticaria + flushing chest + wheezing + difficulty ventilating with high airway pressure + bronchospasm

Using propofol + remifentanil + sevoflurane + rocuronium + cefazolin';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge home"},{"label":"B","text":"Postoperative Delirium (POD) — common in elderly post-surgical"},{"label":"C","text":"Restraint"},{"label":"D","text":"Long-acting benzo"},{"label":"E","text":"Ignore"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Postoperative Delirium (POD) — common in elderly post-surgical: (1) **Identify + treat underlying causes** (multifactorial): - **Pain** (under or over-treated); - **Medications** (opioid, benzodiazepine, anticholinergic — Beers list); - **Hypoxia** (assess oxygenation); - **Electrolyte derangement** (Na, glucose, Ca, Mg); - **Infection** (UTI, pneumonia, line, surgical site); - **Constipation/urinary retention**; - **Sleep deprivation**; - **Withdrawal** (alcohol, benzo, nicotine); - **CNS event** (stroke, seizure); (2) **Non-pharmacologic management (cornerstone)**: - Re-orient frequently (clock, calendar, names); - Family presence + familiar objects; - Hearing aids + glasses; - Sleep-wake cycle (lighting, noise); - Minimize tethers (lines, restraints, Foley) — remove ASAP; - Mobility (sit up, walk); - Hydration; - Multimodal pain control reduce opioid; (3) **Pharmacologic (sparingly + low-dose)** — only for severe agitation/danger to self: low-dose haloperidol 0.25-0.5 mg or quetiapine 12.5-25 mg; AVOID benzodiazepines (worsen — except alcohol/benzo withdrawal); AVOID anticholinergic; (4) **Multidisciplinary**: anesthesia, surgery, geriatric medicine, nursing, family; (5) **HELP (Hospital Elder Life Program)** prevention bundle; (6) **Prevention** going forward: pre-op cognitive screening (Mini-Cog), Beers Criteria deprescribing, hearing/vision aids; (7) **Long-term outcomes**: persistent cognitive impairment possible, increased mortality + functional decline + LTC placement risk; (8) **Family education** + reassurance

---

Postoperative delirium common in elderly. Multifactorial. Non-pharm management primary. Identify + treat causes. Pharmacologic for severe agitation only (low-dose antipsychotic). AVOID benzodiazepines, anticholinergics. HELP program. Long-term consequences. Family + multidisciplinary care. Prevention through pre-op screening + multimodal anesthesia + minimal opioids.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยอายุ 72 ปี G2P2 elective open hysterectomy under general anesthesia

Post-op PACU: alert + cooperative initially → at 2 hours becomes confused, agitated, inattention, hallucinations, hyperactive, attempting to remove IV + Foley

No prior delirium history, no dementia, no substance use
V/S: BP 142/85, HR 95, Temp 37.4°C, SpO2 96%
Lab: electrolytes normal, glucose 145, no infection signs';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge with oral medications"},{"label":"B","text":"Post-Operative Nausea + Vomiting (PONV) — common after general anesthesia + abdominal surgery"},{"label":"C","text":"Surgery again"},{"label":"D","text":"Ignore"},{"label":"E","text":"Long-acting opioid"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-Operative Nausea + Vomiting (PONV) — common after general anesthesia + abdominal surgery: (1) **Identify risk factors** (Apfel score 4 points — female + non-smoker + history of motion sickness/PONV + post-op opioids): - Female (highest risk); - Non-smoker; - Prior PONV/motion sickness; - Post-op opioids; (2) **Multimodal antiemetic prevention** for at-risk (≥ 2 factors): combine multiple classes — - 5-HT3 antagonist (ondansetron, granisetron, palonosetron — long-acting); - Dexamethasone (4-8 mg pre-induction); - Droperidol or haloperidol (D2 antagonist — QTc precaution); - Aprepitant (NK1 antagonist) — long-acting + effective; - Scopolamine patch (anticholinergic — placed > 2h pre-op); - Anti-histamine (promethazine, diphenhydramine); (3) **Rescue if PONV develops**: use different class than prophylaxis (since same class fails again); often combinations needed; (4) **Non-pharmacologic**: acupressure P6 (Neiguan point — wristbands), ginger, aromatherapy (isopropyl alcohol pads — limited evidence), hydration; (5) **Anesthetic technique adjustments**: TIVA with propofol (less PONV vs volatile), regional + neuraxial anesthesia, minimize opioids (multimodal pain), gastric decompression, avoid nitrous oxide; (6) **Hydration adequate**: IV crystalloid; (7) **Refractory PONV**: combinations of multiple classes + steroids + dexmedetomidine; (8) **Patient comfort**: significant patient satisfaction issue + can delay discharge + readmission risk; (9) Multidisciplinary: anesthesia + surgery + PACU + outpatient

---

PONV common — multifactorial. Apfel score + risk factors. Multimodal antiemetic prevention. Rescue with different class. Non-pharmacologic adjuncts. Anesthetic technique adjustments. TIVA + regional anesthesia reduce PONV. Avoid nitrous oxide. Hydration. Modern: prophylaxis with multiple classes routinely.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยอายุ 28 ปี healthy female elective lap chole + general anesthesia

Post-op: severe persistent nausea + vomiting × 6 hours despite IV ondansetron 4mg + IV metoclopramide 10mg

Mild + moderate hypotension + slightly dehydrated';

update public.mcq_questions
set choices = '[{"label":"A","text":"Higher dose opioid"},{"label":"B","text":"Multimodal Post-Operative Analgesia — Opioid-Sparing"},{"label":"C","text":"Discharge with oral opioid"},{"label":"D","text":"Ignore pain"},{"label":"E","text":"Surgery again"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Multimodal Post-Operative Analgesia — Opioid-Sparing: (1) **Reassess + diagnose**: rule out complications (compartment syndrome, infection, hematoma, nerve injury); (2) **Multimodal foundation**: - Scheduled acetaminophen 1 g IV/PO q6h (max 4 g/day); - NSAID (ketorolac 15-30 mg IV q6h max 5 days; or celecoxib 200 mg BID — caution renal, CV, GI); - Gabapentin or pregabalin (50-300 mg TID, dose adjust); - Ketamine low-dose infusion (0.1-0.3 mg/kg/hr) — opioid-sparing + anti-hyperalgesic; - Dexamethasone single dose (anti-inflammatory + antiemetic + analgesic); (3) **Regional anesthesia** considerations: - Femoral nerve block (best knee analgesia but motor weakness — fall risk); - Adductor canal block (preferred — preserves quadriceps strength + good analgesia); - Continuous catheter for prolonged effect; - Liposomal bupivacaine local infiltration (LIA — long-acting 72h); - Periarticular injection by surgeon; (4) **Ice + elevation + position**; (5) **Opioid as adjunct** (lower dose with multimodal): PCA (Patient-Controlled Analgesia), oral as transition; tramadol — caution interactions; avoid long-acting opioid PRN initially; (6) **Non-pharmacologic**: PT, mobility, distraction, mindfulness, music; (7) **Psychological**: chronic post-surgical pain risk — early intervention if catastrophizing, anxiety, depression; (8) **Discharge planning**: minimize discharge opioids (modern epidemic concerns), continue acetaminophen + NSAID schedule, taper opioid quickly, follow-up; (9) **Multidisciplinary**: anesthesia (pain service), surgery, nursing, PT, psychology; (10) **Pain at rest vs activity**: differentiate

---

Multimodal post-op analgesia = standard. Opioid-sparing through multiple mechanisms (acetaminophen + NSAID + gabapentinoid + ketamine + regional + steroid + non-pharm). Regional anesthesia (adductor canal for knee). Opioid PCA + oral as adjunct, minimize discharge prescription. Modern: addressing opioid epidemic. Multidisciplinary pain management.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยอายุ 60 ปี post-knee arthroplasty Day 1 — uncontrolled severe pain despite IV morphine + oral oxycodone — pain VAS 8-9/10

Request assistance for pain management';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait + observe"},{"label":"B","text":"High/Total Spinal — accidental intrathecal injection of epidural dose causing extensive sensory + motor + sympathetic block"},{"label":"C","text":"Increase epidural"},{"label":"D","text":"Discharge"},{"label":"E","text":"Refuse intervention"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** High/Total Spinal — accidental intrathecal injection of epidural dose causing extensive sensory + motor + sympathetic block: (1) **Immediate** — call for help, OR/anesthesia, OB ready for emergency C-section; (2) **Airway + breathing**: respiratory compromise from intercostal + phrenic nerve block; intubate immediately if hypoxic/apneic; bag-mask ventilate; (3) **Cardiovascular**: profound hypotension + bradycardia from sympathectomy + cardiac accelerator block (T1-T4); aggressive IV fluid + vasopressors (phenylephrine or norepinephrine; epinephrine for bradycardia/cardiac arrest); atropine for bradycardia; (4) **Position**: avoid Trendelenburg (LA distribution worse + decreases venous return paradoxically); slight head up if possible; left lateral tilt to relieve IVC compression; (5) **Maintain fetal oxygenation**: maternal stability + position; fetal monitoring; (6) **Decision regarding delivery**: stable mother — continue monitoring; non-reassuring fetal status or unable to recover — emergency C-section under general (since spinal already in place but may not be effective if too high); (7) **Post-event**: monitor for prolonged block, document, debrief team; (8) **Cause**: catheter migration into intrathecal space, large bolus accidentally intrathecal, no test dose recognition; (9) **Prevention**: test dose for catheter placement (epinephrine), incremental dosing, aspiration before each bolus, observe for signs of intrathecal injection (rapid block onset, motor block, hypotension); (10) **Differential**: amniotic fluid embolism, eclampsia, anaphylaxis, LAST, pulmonary edema; (11) Multidisciplinary: anesthesia + OB + neonatal + nursing

---

High/Total spinal = accidental intrathecal injection of epidural dose. Anesthesia emergency. Respiratory + CV compromise. Immediate intubation + ventilation if needed. Aggressive vasopressor + fluid + atropine. Left lateral tilt. Fetal monitoring + emergency delivery if needed. Prevention: test dose, aspirate, incremental dosing. Modern: ultrasound-guided neuraxial reduces risk.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยอายุ 25 ปี G1P0 GA 40 wk in active labor at 6cm + epidural catheter placed for labor analgesia + bolus dose given

10 min later: patient mentions difficulty breathing + speaking + then becomes mute + diaphoretic + hypotensive + bradycardic + dilated pupils + fully alert mental status (yet)

Unable to elevate arms or push';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continuous benzodiazepine"},{"label":"B","text":"Daily sedation interruption"},{"label":"C","text":"Deep sedation continuous"},{"label":"D","text":"No analgesia"},{"label":"E","text":"Restraints only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** ICU Sedation + Analgesia — ABCDEF Bundle: A Assess + Prevent Pain (multimodal — opioid + non-opioid); B Both spontaneous awakening + breathing trials; C Choice of Sedation + Analgesia (target light sedation RASS 0 to -1; preferred — propofol short-term, dexmedetomidine (no respiratory depression + maintain interaction); AVOID benzodiazepine drips long-term — increases delirium + LOS + mortality; analgesia-first sedation; D Delirium — assess (CAM-ICU) + manage (non-pharm primary; haloperidol/quetiapine for severe agitation; avoid benzo); E Early mobility + exercise (PT in ICU even on vent); F Family engagement + empowerment; (2) **Pain control**: opioid (fentanyl, morphine, remifentanil) + non-opioid (acetaminophen, ketamine low-dose, regional anesthesia, multimodal); (3) **Daily sedation interruption** (Kress NEJM 2000) — daily SAT (spontaneous awakening trial) + SBT (spontaneous breathing trial) — reduces vent days + LOS + mortality; (4) **Outcomes**: ABCDEF compliance correlates with survival, less delirium, faster recovery; (5) Modern: less sedation, more interaction, family presence, early mobility; quality improvement focus

---

ICU sedation paradigm shift: light sedation + ABCDEF bundle. Avoid benzodiazepine drips long-term (delirium, mortality). Daily SAT/SBT. Multimodal analgesia. Early mobility. Family engagement. Outcomes improve with bundle compliance. Modern: less is more — light sedation, more interaction.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ICU patient post-cardiac surgery on mechanical ventilation needing sedation + analgesia for 5 days

คำถาม: sedation + delirium prevention in ICU';

update public.mcq_questions
set choices = '[{"label":"A","text":"Standard elective anesthesia"},{"label":"B","text":"Trauma Anesthesia + Damage Control Resuscitation"},{"label":"C","text":"Refuse case"},{"label":"D","text":"Elective approach"},{"label":"E","text":"Discharge home"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Trauma Anesthesia + Damage Control Resuscitation: (1) **Damage Control Surgery (DCS)** principles — control hemorrhage + contamination, leave anatomy abnormal, temporary closure, ICU resuscitation, return for definitive 24-72h; goal: avoid ''lethal triad'' (acidosis + coagulopathy + hypothermia); (2) **Damage Control Resuscitation**: - Permissive hypotension SBP 80-90 until bleeding controlled (avoid except TBI — different MAP target); - Balanced transfusion 1:1:1 (PRC:FFP:Plt) per PROPPR; - Crystalloid minimized (worsens coagulopathy + edema); - Tranexamic acid (TXA) 1g IV bolus within 3h then 1g over 8h (CRASH-2); - Warm products + fluid; - Calcium replacement (citrate binds Ca); (3) **Anesthetic choice**: avoid agents causing further hypotension; ketamine (cardiostable, analgesic), etomidate (hemodynamically stable but adrenal suppression — single dose OK); minimize propofol (hypotension); volatile carefully; (4) **Ventilation**: lung-protective TV 6 mL/kg IBW; chest tube monitoring; (5) **Monitoring**: arterial line, CVL, urine output, temperature, blood gas + lactate; (6) **TBI considerations**: avoid hypotension (different target — MAP > 65, CPP > 60), avoid hypoxia, avoid hyperventilation (cerebral vasoconstriction); osmotherapy if elevated ICP (mannitol, hypertonic saline); (7) **Open femoral fracture**: antibiotic within 1h (cefazolin + gentamicin for Gustilo III), tetanus, immobilize; (8) **Temperature**: normothermia (warming blankets, warm IV, warm room) — hypothermia worsens coagulopathy + cardiac; (9) **Massive Transfusion Protocol (MTP)** activation; (10) **Trauma team approach**: surgery + anesthesia + nursing + blood bank + lab + interventional radiology; ICU bed reserved; (11) **Post-op**: ICU resuscitation, monitor labs, plan definitive surgery; (12) **Predictors**: shock index, mortality scores

---

Trauma anesthesia: damage control resuscitation principles. Permissive hypotension (except TBI). Balanced transfusion 1:1:1. TXA early. Avoid lethal triad. Anesthetic choice — ketamine, etomidate. TBI considerations differ. Normothermia. MTP. Trauma team approach. Modern: aggressive multidisciplinary trauma care.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยอายุ 35 ปี polytrauma post-MVC — open femoral fracture + pneumothorax + closed head injury — going to OR for damage control surgery

V/S: BP 88/52, HR 132, Hb 6.4, Lactate 4.8, INR 1.6, pH 7.21, Temp 35.4°C
Airway secured pre-OR + chest tube + IV × 2';

update public.mcq_questions
set choices = '[{"label":"A","text":"Same as adult anesthesia"},{"label":"B","text":"Pediatric Anesthesia Considerations"},{"label":"C","text":"No special considerations"},{"label":"D","text":"Adult dosing"},{"label":"E","text":"Refuse case"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Anesthesia Considerations: (1) **Pre-operative**: parental separation anxiety — pre-medication (midazolam oral 0.5 mg/kg); EMLA topical; toys, distraction; child life specialist; (2) **Inhalation induction** (mask) preferred 3 yo — sevoflurane (sweet smell, fast); IV induction once IV in place (lidocaine for propofol injection pain); (3) **Airway** differences: large occiput → flexion neutral position, large tongue, narrow cricoid (subglottic stenosis risk), funnel-shaped larynx; ETT cuff size — ''age/4 + 4'' uncuffed, ''age/4 + 3.5'' cuffed; LMA acceptable for short cases; (4) **Drug doses weight-based** (mg/kg); fluid calculation by 4-2-1 rule; (5) **Temperature regulation**: high surface area:volume ratio → hypothermia risk; warm IV, blanket, warm room (26-28°C in OR for infants); (6) **Hemodynamics**: rate-dependent CO; bradycardia → low CO → use atropine; (7) **Tonsillectomy specifics**: airway shared with surgeon, position changes, intra-op bleeding monitoring; dexamethasone (reduce PONV + edema + pain); minimize opioid (post-T+A apnea risk in OSA); local infiltration; multimodal analgesia (acetaminophen, NSAIDs avoid if bleeding concern); (8) **Post-tonsillectomy hemorrhage** — major risk 5-10 days; emergency airway/resuscitation if returns; (9) **PONV**: high incidence after T+A; dexamethasone + ondansetron prophylactic; (10) **Pain management**: multimodal, parents stay, comfort measures; (11) **Discharge criteria**: usually same day except OSA, age < 3, comorbidity, distance from hospital; (12) **OSA considerations**: opioid sensitivity, post-op monitoring overnight if severe; (13) Multidisciplinary: anesthesia + ENT + nursing + child life + family

---

Pediatric anesthesia: child differences from adult — airway, drug dosing, temperature, hemodynamics, psychological. Inhalation induction common (sevoflurane). Tonsillectomy: shared airway, OSA + opioid sensitivity, hemorrhage risk 5-10d, PONV high, multimodal pain. Multidisciplinary care + family-centered.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'เด็กชายอายุ 3 ปี น้ำหนัก 15 kg elective tonsillectomy + adenoidectomy under general anesthesia

No significant medical history, no allergies, vaccines current';

update public.mcq_questions
set choices = '[{"label":"A","text":"Standard surgical anesthesia"},{"label":"B","text":"Neuroanesthesia for Aneurysmal SAH Coiling"},{"label":"C","text":"Refuse case"},{"label":"D","text":"Discharge"},{"label":"E","text":"No monitoring"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neuroanesthesia for Aneurysmal SAH Coiling: (1) **Goals**: maintain CPP (CPP = MAP - ICP, target > 60), avoid spikes in BP (rebleeding risk), avoid hypotension, avoid increases in ICP, minimize aneurysm wall tension; (2) **Pre-op**: BP control (target SBP < 140-160 pre-secured aneurysm — prevent rebleeding 4% in 24h, 30% in 1 month); IV access; arterial line; CVL if needed; nimodipine for vasospasm prevention; seizure prophylaxis if HUNT/HESS poor grade; (3) **Induction**: smooth, avoid HTN spike (treat with esmolol, lidocaine), avoid hypotension; propofol (cardiostable + lowers ICP via reduced CMRO2), thiopental alternative; opioid (fentanyl/remifentanil) blunt sympathetic response; muscle relaxant non-depolarizing (rocuronium); (4) **Maintenance**: TIVA (propofol + remifentanil) vs balanced (volatile + opioid); TIVA preferred for neuroanesthesia (less ICP increase, faster wake-up, better neuro exam); (5) **Hemodynamic management during procedure**: tight BP control — avoid hyper + hypotension; arterial line; vasoactive infusions ready (nicardipine, esmolol for HT; phenylephrine, norepinephrine for hypotension); MAP 80-90 typically; (6) **Ventilation**: PaCO2 normocapnia (avoid hyper or hypoventilation — ICP effects); SpO2 > 95; (7) **Temperature**: normothermia or mild hypothermia (debated — no clear benefit, may worsen); (8) **Heparinization**: for procedure — coordinate with reversal availability; (9) **Hyperthermia**: aggressive treatment (acetaminophen, cooling — fever worsens outcome); (10) **Emergence**: smooth, avoid HTN (treat aggressively), rapid neurological assessment; (11) **Post-op**: ICU, BP control continues, monitor for vasospasm + rebleeding + hydrocephalus + seizures; nimodipine; close neuro checks; (12) **Multidisciplinary**: neurosurgery + interventional radiology + anesthesia + neurocritical care

---

Neuroanesthesia: tight BP control + ICP management + smooth hemodynamic course. TIVA preferred for neurosurgical cases. Aneurysm SAH: pre-secured aneurysm — avoid HTN (rebleeding); post-secured — moderate HTN may be allowed if vasospasm. Nimodipine for vasospasm. Multidisciplinary neurocritical care.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยอายุ 55 ปี acute subarachnoid hemorrhage from ruptured cerebral aneurysm — going to OR for endovascular coiling under general anesthesia

V/S: BP 178/108 (high), HR 88, GCS 14, no focal neurological deficit';

update public.mcq_questions
set choices = '[{"label":"A","text":"Standard anesthesia"},{"label":"B","text":"Cardiac Anesthesia for CABG + AVR with CPB"},{"label":"C","text":"Refuse case"},{"label":"D","text":"Local anesthetic only"},{"label":"E","text":"No monitoring"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cardiac Anesthesia for CABG + AVR with CPB: (1) **Pre-op**: continue beta-blocker + statin + aspirin (continue per surgeon preference vs hold 5-7 days pre-op for some); hold ACE inhibitor day of surgery; hold metformin day of surgery; antifibrinolytic (TXA or aprotinin alternative); coordinate with cardiologist + perfusionist + ICU; (2) **Monitoring**: 5-lead EKG, arterial line, CVL with PAC option, BIS for depth, TEE intra-op (essential for valve + ventricular function assessment), temperature (esophageal + bladder); (3) **Induction**: smooth, hemodynamically neutral; fentanyl high-dose ''cardiac dose'' historic, modern lower with multimodal; etomidate or low-dose propofol; rocuronium; (4) **Pre-CPB**: maintain hemodynamics, monitor TEE; heparinization (300-400 U/kg) to ACT > 480 before bypass; (5) **On CPB**: maintained by perfusionist; perform aortic cross-clamp; cardioplegia for myocardial protection (cold + chemical); MAP 50-70 on bypass (typical); hemodilution; mild hypothermia (32-34°C) — cerebral protection; (6) **Coming off CPB**: rewarm to 36.5-37°C; restore rhythm (defibrillate, pace); volume management; inotropic support if needed (epinephrine, milrinone, dobutamine); ventilate; protamine to reverse heparin (carefully — anaphylactoid reaction risk); (7) **TEE assessment**: valve function, ventricular function, wall motion; (8) **Bleeding management**: balanced product replacement, TXA/aprotinin, factor concentrates, point-of-care testing (ROTEM, TEG); (9) **Post-op ICU**: ventilation, hemodynamic support, pain control, glycemic control, early extubation when stable (fast-track); (10) **Complications**: arrhythmia (AF — 20-30%), bleeding, stroke, AKI, vasoplegia; (11) **Multidisciplinary**: cardiac surgery + anesthesia + perfusion + ICU + cardiology

---

Cardiac anesthesia: extensive monitoring + invasive (arterial line, CVL, PAC option, TEE). Heparinization for CPB. Cardioplegia + hypothermia for myocardial + cerebral protection. Inotropic support coming off CPB. TXA reduces bleeding. Modern: TEE essential, fast-track recovery, multidisciplinary team. Complications: arrhythmia, bleeding, stroke, AKI.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยอายุ 68 ปี going for elective CABG + aortic valve replacement + on cardiopulmonary bypass

Meds: aspirin, statin, beta-blocker, lisinopril, metformin';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue surgery"},{"label":"B","text":"OR Fire — Anesthesia/Surgical Emergency"},{"label":"C","text":"Continue with surgery"},{"label":"D","text":"Refuse to help"},{"label":"E","text":"Discharge patient"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** OR Fire — Anesthesia/Surgical Emergency: (1) **Stop procedure immediately** + alert team + announce ''FIRE''; (2) **Fire triangle**: oxidizer (O2, N2O), ignition source (electrocautery, laser, drill), fuel (drapes, alcohol prep, hair, ETT, gauze); (3) **Immediate actions**: - Stop O2 + N2O flow (most important); - Remove burning materials from patient; - Extinguish fire (saline, CO2 extinguisher, smother with blankets); (4) **For airway fires**: - Disconnect breathing circuit; - Remove ETT immediately; - Pour saline into airway; - Once fire out, ventilate with room air + minimum O2 needed; - Re-intubate (likely required for airway burn); - Bronchoscopy to assess; - Tracheostomy if severe; - ICU admission + steroids; (5) **Post-fire**: - Assess patient injury (skin burns, airway burn); - Resuscitation if extensive; - Document — quality improvement; - Counsel patient + family; (6) **Prevention** (ASA Fire Algorithm): - Reduce ambient O2 below 30% when possible; - Use compressed air or blended O2; - Avoid open O2 delivery near surgical site for head/neck cases; - Use proper drape technique; - Allow time for alcohol prep to dry; - Communication between surgeon + anesthesia about ignition + oxidizer use; (7) **OR personnel safety**; (8) **Multidisciplinary**: surgery, anesthesia, OR nursing, infection control

---

OR fires: rare but devastating. Fire triangle — oxidizer + ignition + fuel. Stop O2 first. Airway fires require ETT removal + reintubation. Prevention: ASA Fire Algorithm — reduce ambient O2, time for alcohol drying, communication. Multidisciplinary safety. Document + QI.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ระหว่างผ่าตัด — surgeon uses electrocautery near oxygen-enriched area + drape catches fire on patient

คำถาม: OR fire management';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait for typed blood"},{"label":"B","text":"Massive Transfusion Protocol (MTP) for OB Hemorrhage"},{"label":"C","text":"Crystalloid only"},{"label":"D","text":"Discharge"},{"label":"E","text":"Refuse"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Massive Transfusion Protocol (MTP) for OB Hemorrhage: (1) **Activate MTP** (criteria — ongoing hemorrhage requiring multiple units, shock); (2) **Balanced product administration 1:1:1** (PRC:FFP:Plt) per PROPPR trial 2015 — better than crystalloid + delayed plasma; (3) **Tranexamic acid (TXA) 1g IV** within 3 hours (WOMAN trial — reduces death from bleeding in OB hemorrhage); (4) **Crystalloid + colloid** secondary — minimize (dilutional coagulopathy); (5) **Type O negative blood emergent** before type-specific available (for women of reproductive age — Rh status matters); type-specific switch when available; uncrossmatched if needed; (6) **Cryoprecipitate** for fibrinogen < 200 (OB hemorrhage requires fibrinogen > 200 — higher target than trauma); (7) **Point-of-care testing**: ROTEM/TEG to guide product use; (8) **Permissive hypotension** caution in OB (placental + fetal perfusion, eclampsia risk); SBP target 90-100 typically; (9) **Cell saver** controversial in OB (amniotic fluid contamination concern, but increasingly used with leukocyte depletion filter); (10) **Treat cause**: uterine atony (oxytocin + methylergonovine + carboprost + misoprostol — 4 T''s: tone, trauma, tissue, thrombin), surgical control (B-Lynch, hysterectomy if needed); IR + UAE if available; (11) **Temperature**: warming all products, blanket warmer, warm IV — hypothermia worsens coagulopathy; (12) **Calcium replacement** (citrate binds Ca); (13) **Multidisciplinary team**: OB + anesthesia + blood bank + nursing + IR + ICU; (14) **Maternal mortality risk** — leading cause globally; aggressive management saves lives

---

Massive transfusion: balanced 1:1:1 ratio (PROPPR). TXA within 3h (WOMAN). Cryoprecipitate for fibrinogen < 200 (OB target higher). O-negative emergent. Point-of-care testing (ROTEM/TEG). Treat cause. Warm products. Multidisciplinary team. OB hemorrhage = leading cause of maternal mortality globally — saves lives.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยอายุ 28 ปี G2P1 GA 40 wk emergency C-section for fetal distress + uterine atony + ongoing hemorrhage 2L+

Going to OR + already lost lots of blood + still bleeding';

update public.mcq_questions
set choices = '[{"label":"A","text":"Ignore temperature"},{"label":"B","text":"Perioperative Hypothermia Management"},{"label":"C","text":"Discharge"},{"label":"D","text":"Refuse"},{"label":"E","text":"Cool further"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Perioperative Hypothermia Management: (1) **Hypothermia harm**: coagulopathy (platelet + enzymatic dysfunction), arrhythmia (especially < 30°C), wound infection, increased SSI, delayed drug metabolism, shivering (cardiac demand), longer recovery; (2) **Prevention strategies (ASA + NICE recommend normothermia > 36°C)**: - Pre-warming pre-op (forced air warming 30-60 min before induction); - Warm OR room (initially 20-24°C, higher for infants 26-28°C); - Forced air warming intra-op (Bair Hugger most common); - Conductive warming mattress; - IV fluid warmer; - Humidification of inspired gas; - Reduce skin exposure; - Cover head; (3) **Active rewarming when hypothermic**: - Forced air warming primary; - IV fluid warmer (40°C); - Warmed humidified ventilation; - Body cavity lavage (pleural, peritoneal) for severe; - Continuous renal replacement therapy with warming; - ECMO for refractory severe (< 28°C, hemodynamic compromise); (4) **Hypothermia + trauma ''lethal triad''**: hypothermia + acidosis + coagulopathy — vicious cycle; aggressive rewarming + product replacement; (5) **Monitoring**: core temperature (esophageal, bladder, rectal, tympanic); skin temperature less accurate; (6) **Cooling for indications** (controversial benefit, narrow): targeted temperature management (TTM 32-36°C) post-cardiac arrest, neuroprotection (mild hypothermia for selected — debated); never hyperthermia (worsens outcome universally); (7) **Multidisciplinary**: anesthesia + surgery + nursing + ICU

---

Perioperative hypothermia: significant harm (coagulopathy, arrhythmia, SSI). Prevention better than treatment. Forced air warming primary. Pre-warming. Trauma lethal triad: hypothermia + acidosis + coagulopathy. Hyperthermia universally harmful. Monitor core temperature. Multidisciplinary team. Modern: normothermia > 36°C standard.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยอายุ 65 ปี multi-trauma post-MVC + open femoral fracture exposure for 1 hour + Temp 33.6°C + slow rewarming

คำถาม: perioperative hypothermia management';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge"},{"label":"B","text":"Frail Elderly Emergency Surgery"},{"label":"C","text":"Cancel surgery"},{"label":"D","text":"Standard elective"},{"label":"E","text":"Refuse"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Frail Elderly Emergency Surgery: (1) **Pre-op optimization while not delaying surgery > 48h** (hip fracture mortality increases with delay): - Volume status assessment (fluid resuscitation cautious in HF/CKD); - Anti-coagulation reversal — INR > 1.5 + emergency hip surgery → 4-factor PCC (Kcentra) + vitamin K (faster than FFP, smaller volume; especially CKD + HF); INR target 1.5; - Continue beta-blocker + statin; - Hold furosemide if hypovolemic; - Optimize Hb (transfuse if < 8 or anemic + symptomatic); - Glycemic control; (2) **Anesthetic plan**: - Regional anesthesia preferred (spinal/CSE) — less delirium + lower mortality than GA in some series (limited evidence — REGAIN trial NEJM 2021 no difference); - Fascia iliaca compartment block (pre-op + intra-op) — excellent analgesia + multimodal; - Reduce opioids; (3) **Monitoring**: arterial line for invasive BP, urine output, EKG, possibly TEE if hemodynamic concerns; (4) **Hemodynamic management**: maintain perfusion to organs (cardiac + renal + brain) — MAP > 65, individualized; avoid both HT + hypoTN; vasopressors as needed; (5) **Cementing reaction risk** (BCIS — bone cement implantation syndrome — hypotension + hypoxia + arrhythmia during prosthesis insertion) — communicate with surgeon, premedicate volume, ready vasopressors, careful cement use, vent reaming; (6) **Post-op**: PACU then ICU vs ward based on stability; multimodal analgesia opioid-sparing; early mobilization; PT; (7) **Ortho-geriatric co-management** — Cochrane evidence reduces mortality; (8) **Delirium prevention**: HELP, non-pharm, avoid Beers meds; (9) **Secondary fracture prevention**: osteoporosis Rx, fall prevention; (10) **Multidisciplinary**: orthopedics + anesthesia + geriatric medicine + nursing + PT + family

---

Frail elderly emergency surgery: optimize without delaying > 48h. Reverse warfarin (PCC > FFP). Regional anesthesia (REGAIN trial — no clear difference from GA but fascia iliaca block + multimodal). Hemodynamic vigilance. Cementing reaction risk. Ortho-geriatric co-management. Modern multidisciplinary team approach.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยอายุ 78 ปี HF, CKD3, recent MI, going for emergency hip fracture repair within 24 hours

Functional capacity poor pre-fall, on aspirin + warfarin (INR 2.4) + furosemide + carvedilol + atorvastatin';

update public.mcq_questions
set choices = '[{"label":"A","text":"Force blood transfusion"},{"label":"B","text":"Jehovah''s Witness + Bloodless Medicine"},{"label":"C","text":"Refuse case"},{"label":"D","text":"Discharge"},{"label":"E","text":"Ignore wishes"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Jehovah''s Witness + Bloodless Medicine: (1) **Respect patient autonomy** — informed consent + refusal of blood products (constitutionally protected); document in advance directive + chart; (2) **Discuss specifics**: most JWs refuse whole blood, PRBC, FFP, platelets; many accept albumin, cryoprecipitate, some accept own blood (cell saver if continuous circuit), recombinant factors, ESA (erythropoietin); individualized — ask patient specifically; (3) **Pre-op optimization**: maximize Hb pre-op (iron, B12, folate, erythropoietin if elective); minimize blood draws; (4) **Intra-op blood conservation strategies**: - **Cell saver** (intraoperative blood recovery — preferred — continuous circuit acceptable to most JWs); - **Acute normovolemic hemodilution** (ANH — collect autologous blood + replace with crystalloid; reinfuse later); - **Hypotensive anesthesia** (lower MAP — reduces blood loss); - **Optimize hemostasis** — surgical technique, electrocautery, topical agents (TXA, fibrin glue, hemostatic patches); - **Tranexamic acid (TXA)** — IV systemic + topical reduces bleeding; - **Minimize phlebotomy** — pediatric tubes; - **Pharmacologic**: erythropoietin, iron IV, vitamin B12/folate; (5) **Post-op**: aggressive hemostasis, monitor for re-bleeding, optimize Hb (iron, EPO), nutritional support; (6) **Maternal mortality higher in JW vs general OB population** — counsel + discuss; (7) **Refractory severe anemia**: hyperbaric oxygen as last resort (controversial); (8) **Ethics committee** if complex situations; (9) **Family education** + support; (10) **Bloodless medicine programs** specialized centers; (11) **Documentation** of informed consent + refusal

---

Jehovah''s Witness: respect patient autonomy. Bloodless medicine strategies: cell saver, ANH, TXA, EPO/iron, surgical hemostasis. Document informed consent + refusal. Higher mortality risk — discuss. Specialized bloodless programs. Modern: many options to minimize blood need.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยอายุ 32 ปี Jehovah''s Witness — refusing all blood products + going for emergency surgery (ruptured ectopic pregnancy)

Currently BP 88/52, HR 132, Hb 7.4 (dropping)';

update public.mcq_questions
set choices = '[{"label":"A","text":"No differences"},{"label":"B","text":"IV Induction Agents — Mechanisms + Clinical Use"},{"label":"C","text":"Same mechanism"},{"label":"D","text":"Random use"},{"label":"E","text":"Single agent only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** IV Induction Agents — Mechanisms + Clinical Use: (1) **Propofol** — GABA-A agonist + glycine; most common induction; rapid onset + offset; reduces ICP + CMRO2 (neuroprotective); negative inotrope + vasodilator (hypotension); pain on injection (lidocaine pretreat); anti-emetic effects; propofol infusion syndrome (rare — > 4 mg/kg/hr > 48h); (2) **Etomidate** — GABA-A modulator; hemodynamically stable (preferred in unstable cardiac, hypovolemia); ADRENAL SUPPRESSION (11-beta hydroxylase inhibition — single dose may suppress 24-48h; concern in sepsis — avoid in adrenal insufficiency); myoclonus + N/V; (3) **Ketamine** — NMDA antagonist; dissociative anesthesia; preserves cardiovascular + respiratory function (preferred in shock, asthma, bronchospasm); analgesic; emergence reactions (hallucinations — benzo prophylaxis); sympathomimetic (caution CAD, HTN crisis); increases salivation; (4) **Midazolam** — GABA-A modulator (benzodiazepine); pre-medication, sedation, induction with opioid; reversible with flumazenil; respiratory depression; longer recovery; (5) **Thiopental** — GABA-A modulator (barbiturate); historical, less use now; rapid + neuroprotective; reduces ICP; CV depression; reduces hepatic blood flow; precipitates porphyria; pain on injection; (6) **Dexmedetomidine** — alpha-2 agonist; sedation without respiratory depression; analgesic; opioid-sparing; preserves arousability; useful for ICU sedation, awake fiberoptic, procedural sedation; bradycardia + hypotension; (7) **Selection factors**: hemodynamics, comorbidities, allergies, surgery type, recovery profile, cost; (8) **Combination + multimodal** preferred over single agent

---

IV induction agents: different mechanisms + clinical profiles. Propofol most common. Etomidate cardiostable but adrenal suppression. Ketamine preserves CV + respiratory + analgesic. Midazolam reversible. Dexmedetomidine awake sedation. Selection by patient + procedure. Multimodal approach preferred.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Resident ถามเรื่อง pharmacology — IV induction agents + mechanisms';

update public.mcq_questions
set choices = '[{"label":"A","text":"No changes"},{"label":"B","text":"Physiologic Changes During Anesthesia"},{"label":"C","text":"No physiologic effects"},{"label":"D","text":"Adult only"},{"label":"E","text":"Random changes"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Physiologic Changes During Anesthesia: (1) **Respiratory**: - Loss of upper airway tone → obstruction (jaw thrust, oral airway, intubation); - Loss of muscle tone → atelectasis (recruitment maneuver, PEEP); - Reduced FRC (functional residual capacity) by 20% (supine + anesthesia + paralysis); - V/Q mismatch + shunt; - Loss of HPV (hypoxic pulmonary vasoconstriction) in lung; - Apnea (depending on depth + agent); - Respiratory acidosis if hypoventilation; - Hyperventilation → respiratory alkalosis → cerebral vasoconstriction; (2) **Cardiovascular**: - Most anesthetics — myocardial depression, vasodilation → hypotension; - Loss of sympathetic tone (especially neuraxial); - Bradycardia (volatile, opioids, dexmedetomidine, vagal — surgical stimulation); - Reduced response to BP changes; (3) **Neurological**: CMRO2 reduced (most anesthetics neuroprotective in some sense); BBB intact; (4) **Renal**: GFR reduced; reduced response to ADH; - antidiuresis (sympathetic + renin-angiotensin response to surgical stress); - perioperative AKI risk; (5) **GI**: reduced gastric emptying (aspiration risk); ileus post-op; (6) **Endocrine**: stress response (cortisol, glucagon, GH, ADH, catecholamines) → hyperglycemia, fluid retention, immunosuppression; (7) **Hematologic**: hypercoagulability post-op (VTE prophylaxis); (8) **Temperature**: rapid hypothermia (vasodilation + cool OR); (9) **Pediatric/Geriatric** differ — separate considerations; (10) **Implications**: maintain physiologic homeostasis, monitor, intervene as needed

---

Anesthesia profound physiologic effects. Respiratory: loss of tone, atelectasis, reduced FRC, V/Q mismatch. CV: myocardial depression, vasodilation, hypotension. Neuro: reduced CMRO2. GI: aspiration risk + ileus. Endocrine: stress response. Hypothermia rapid. Implications: maintain physiology + monitor + intervene. Modern: minimize disruption.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Resident ถามเรื่อง physiology — respiratory + cardiovascular changes during anesthesia';

update public.mcq_questions
set choices = '[{"label":"A","text":"Same mechanism"},{"label":"B","text":"Neuromuscular Blockers (NMB) + Reversal"},{"label":"C","text":"No reversal needed"},{"label":"D","text":"Random use"},{"label":"E","text":"Single agent only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neuromuscular Blockers (NMB) + Reversal: (1) **Depolarizing NMB — Succinylcholine**: ACh receptor agonist; rapid onset (30-60s) + short duration (5-10 min); fasciculations + myalgia; side effects — hyperkalemia (avoid in burns, denervation, neuromuscular disease, prolonged immobilization), MH trigger, increased ICP/IOP, bradycardia (esp peds repeat doses); plasma cholinesterase metabolism (pseudocholinesterase deficiency — prolonged effect); not routinely reversed (let wear off); (2) **Non-Depolarizing NMB — competitive ACh antagonists**: - **Aminosteroids**: rocuronium (intermediate, rapid onset), vecuronium (intermediate), pancuronium (long-acting); - **Benzylisoquinolinium**: cisatracurium (intermediate, Hofmann elimination — useful in liver/renal disease), atracurium (histamine release), mivacurium (short); (3) **Reversal of non-depolarizing NMB**: - **Sugammadex** — for aminosteroids only (rocuronium + vecuronium); cyclodextrin encapsulates molecule; rapid + complete reversal at any depth; 2-16 mg/kg dose-dependent; FDA approved + revolutionary — eliminates residual blockade concerns; - **Neostigmine** (acetylcholinesterase inhibitor) + glycopyrrolate or atropine (anticholinergic to prevent bradycardia + secretion); maximum 5 mg; not effective for profound block; (4) **Monitoring NMB** — train-of-four (TOF) at adductor pollicis or facial nerve; depth-of-block assessment; TOF ratio > 0.9 before extubation (residual NMB causes airway compromise + aspiration); (5) **Quantitative monitoring** (acceleromyography) preferred over qualitative; (6) **Clinical considerations**: avoid hypothermia (prolongs block), acidosis, hypokalemia, hypomagnesemia (potentiates); some antibiotics (aminoglycosides, polymyxin) potentiate; (7) **Reversal of residual NMB** — increased focus to reduce post-op respiratory complications

---

NMB: depolarizing (succinylcholine — rapid, short) vs non-depolarizing (aminosteroids, benzyliso). Sugammadex revolutionized rocuronium/vecuronium reversal. Neostigmine + anticholinergic traditional reversal. TOF monitoring + quantitative preferred. TOF > 0.9 before extubation. Residual NMB causes post-op complications. Modern: emphasis on full reversal + monitoring.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Resident ถามเรื่อง pharmacology — neuromuscular blockers + reversal';

update public.mcq_questions
set choices = '[{"label":"A","text":"Blind technique only"},{"label":"B","text":"Ultrasound-Guided Regional Anesthesia"},{"label":"C","text":"Random injection"},{"label":"D","text":"No regional"},{"label":"E","text":"Refuse"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Ultrasound-Guided Regional Anesthesia: (1) **Advantages over blind/nerve stimulator**: direct visualization, real-time needle tracking, lower volume LA, faster onset, fewer attempts, lower complication rates (vascular puncture, nerve injury, LAST); (2) **Common blocks**: - Upper extremity: interscalene (shoulder), supraclavicular (arm), infraclavicular (forearm), axillary, peripheral (median, ulnar, radial nerve, distal); - Lower extremity: femoral, adductor canal (saphenous), sciatic (popliteal), ankle block; - Truncal: TAP (transversus abdominis plane), rectus sheath, quadratus lumborum, paravertebral, erector spinae plane (ESP), serratus anterior, PECS I + II (chest wall); - Neuraxial: spinal, epidural (ultrasound assists in difficult anatomy or obesity); (3) **Technique**: identify target nerve + surrounding structures, in-plane vs out-of-plane needle, hydrodissection, incremental LA injection with aspiration; (4) **LA selection**: lidocaine (short-acting, intra-op), bupivacaine + ropivacaine (long-acting, post-op analgesia 12-24h), liposomal bupivacaine (72h); adjuncts (epinephrine — vasoconstriction + LA duration + detect IV; dexamethasone + clonidine — prolong); (5) **Complications**: LAST (most feared — see other question), nerve injury, vascular puncture + hematoma, infection, pneumothorax (interscalene, supraclavicular), epidural hematoma (neuraxial); (6) **Patient selection**: cooperative, no severe coagulopathy at site, no infection at site, appropriate consent; (7) **Documentation**: technique, structure identification, LA + volume, response, complications; (8) **Continuous catheters**: prolonged analgesia, multimodal; (9) **Outcomes**: reduced opioid use, shorter hospital stay, less PONV, better recovery; (10) **Training**: ultrasound + needle skills require deliberate practice

---

Ultrasound-guided regional anesthesia: advantages over blind. Multiple block types upper/lower/truncal/neuraxial. LA selection + adjuncts. Continuous catheters for prolonged. Complications: LAST, nerve injury, vascular, pneumothorax. Reduces opioid use + improves recovery. Modern multimodal analgesia foundation.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Resident ถามเรื่อง regional anesthesia anatomy + ultrasound guidance';

update public.mcq_questions
set choices = '[{"label":"A","text":"Traditional approach"},{"label":"B","text":"ERAS Hospital-Wide Implementation"},{"label":"C","text":"Single intervention"},{"label":"D","text":"No multidisciplinary"},{"label":"E","text":"Refuse ERAS"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** ERAS Hospital-Wide Implementation: (1) **Multidisciplinary team**: surgeons, anesthesia, nursing, PT/OT, dietitian, social work, pharmacy, case management, quality improvement, IT, leadership; (2) **Specialty-specific protocols** (ERAS Society guidelines exist for major specialties — colorectal, urology, GYN, breast, bariatric, hepatobiliary, esophageal, lung, cardiac, gastric, thoracic, head + neck, pancreas, ortho, OB); (3) **Components** (~ 20 elements per protocol): - Pre-operative: education + counseling, no prolonged fasting (clear fluids 2h, carb loading), no routine bowel prep (specialty-dependent), MRSA screening, smoking cessation, nutritional optimization; - Intra-operative: antibiotic prophylaxis timing, normothermia, restrictive fluid, minimally invasive when possible, multimodal analgesia (regional + non-opioid), avoid NG tube + drains routine, normoglycemia; - Post-operative: early diet + mobilization (within 24h), multimodal analgesia (opioid-sparing), no Foley routine > 24h, DVT prophylaxis, early discharge planning; (4) **Audit + feedback**: measure compliance + outcomes per ERAS interactive audit system or local; (5) **Outcomes**: reduced LOS 30%, complications 30-50%, opioid use, readmissions; cost-effective; (6) **Cultural change** essential — staff buy-in, education, ongoing reinforcement; (7) **Patient + family engagement**: empowered, informed, expectations set; (8) **Continuous improvement**: quarterly review, evolve protocols; (9) **Equity**: ensure benefits across all populations; (10) **Modern**: ERAS as standard of care; high-quality + low-cost approach

---

ERAS = evidence-based multimodal perioperative care. Specialty-specific protocols. ~20 elements per protocol. Multidisciplinary team. Audit + feedback. Outcomes: shorter LOS, less morbidity, less opioid, cost-effective. Cultural change. Patient empowerment. Modern: standard of care across major surgeries.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Hospital wants reduce surgical mortality + improve perioperative care — implement Enhanced Recovery After Surgery (ERAS) hospital-wide';

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

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait for bleeding to stop"},{"label":"B","text":"Postpartum hemorrhage (PPH)"},{"label":"C","text":"Vasopressor only without transfusion"},{"label":"D","text":"Volatile anesthesia high dose"},{"label":"E","text":"Limit fluids strictly"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Postpartum hemorrhage (PPH) — anesthesia + multidisciplinary: (1) Massive Transfusion Protocol activation; 2 large-bore IV; T+C 4-6 units; arterial line; (2) Uterine atony = most common cause; massage + uterotonics escalation: - Oxytocin 10-40U IV in 1L (avoid fast bolus — hypotension); - Methylergonovine 0.2mg IM (avoid in HTN/PEC); - Carboprost (PGF2a) 0.25mg IM q15min (avoid in asthma); - Misoprostol 800-1000mcg PR or SL; (3) Tranexamic acid 1g IV within 3h (WOMAN trial — reduces death); (4) Other causes — Tears, Tissue (retained), Thrombin (coagulopathy) — 4Ts; check retained placenta, lacerations; (5) Balanced transfusion 1:1:1 PRC:FFP:Plt; fibrinogen target > 2 g/L (cryo if low); calcium replacement (citrate); warm fluids; (6) Surgical interventions — uterine balloon (Bakri, Belfort-Dildy), B-Lynch suture, uterine artery ligation/embolization, hysterectomy; (7) Anesthesia: GA likely for instability + emergent procedure; ketamine or etomidate for induction (CV stable); avoid volatile high dose (uterine relaxation); (8) Monitor — labs (Hb, coag, fibrinogen, lactate), TEG/ROTEM if available; (9) Postpartum care — ICU, monitor coagulopathy, AKI, Sheehan syndrome; (10) Modern: REBOA for massive PPH refractory; cell salvage acceptable in OB now; multidisciplinary code team

---

PPH: 4Ts (Tone/Tear/Tissue/Thrombin). Uterotonic ladder. TXA. Balanced transfusion 1:1:1. Surgical escalation (balloon, B-Lynch, hysterectomy). GA with CV-stable induction. ICU post-op. Cell salvage OK.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 35 ปี G3P2 GA 40 wk vaginal delivery
Post-delivery: heavy bleeding > 1500 mL, uterus boggy, vital signs deteriorating BP 80/45, HR 120
Oxytocin infusion running, manual fundal massage ongoing';

update public.mcq_questions
set choices = '[{"label":"A","text":"Tocolysis"},{"label":"B","text":"Amniotic Fluid Embolism (AFE)"},{"label":"C","text":"Discharge home immediately"},{"label":"D","text":"Beta-blocker IV"},{"label":"E","text":"Limit oxygen therapy"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Amniotic Fluid Embolism (AFE) — rare but fatal: (1) Clinical — peri-/postpartum sudden cardiovascular collapse + hypoxia + DIC + altered mental status; mortality 30-60%; (2) Pathophys — amniotic fluid + fetal cells into maternal circulation → anaphylactoid + pulmonary vasoconstriction + RV failure + DIC; (3) DDx — PE, hemorrhage, sepsis, MI, anaphylaxis, eclampsia, LAST; (4) Immediate — ACLS modified for pregnant if pre-delivery (LUD = left uterine displacement, perimortem C-section within 4 min cardiac arrest if no ROSC); (5) Airway — intubate + 100% O2 + lung-protective ventilation; (6) Hemodynamic support — fluid resuscitation cautious (RV failure), epinephrine, norepinephrine, vasopressin; pulmonary vasodilator (inhaled NO, milrinone, sildenafil); (7) RV support — TEE-guided management, inotropes (dobutamine, milrinone), avoid fluid overload; (8) ECMO — early consideration; (9) Coagulopathy — massive transfusion 1:1:1, fibrinogen replacement aggressive (target > 2-2.5 g/L), TXA, cryoprecipitate; TEG/ROTEM; (10) A-OK regimen — atropine 1mg + ondansetron 8mg + ketorolac 30mg (case reports); (11) Multidisciplinary — anesthesia + OB + ICU + hematology + cardiac surgery; (12) Survival improving with aggressive management + recognition; (13) Post-event: report to AFE registry, family support, debriefing; (14) No prevention — sporadic

---

AFE: peri-/postpartum collapse + hypoxia + DIC. ACLS + perimortem C-section if pre-delivery. Aggressive transfusion + fibrinogen. RV support. ECMO. A-OK regimen. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 32 ปี G2P1 GA 39 wk in labor with epidural × 6h, baby delivered
Sudden: dyspnea + cyanosis + cardiovascular collapse + DIC + altered mental status
BP 60/30, SpO2 78%, ETCO2 dropping during CPR';

update public.mcq_questions
set choices = '[{"label":"A","text":"Decline patient request"},{"label":"B","text":"Labor epidural"},{"label":"C","text":"GA only routine"},{"label":"D","text":"No analgesia natural birth"},{"label":"E","text":"IV opioid only no neuraxial"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Labor epidural — standard technique + management: (1) Pre-procedure — consent (risks: headache 1%, hypotension, failure, infection, hematoma rare, nerve injury rare, total spinal); IV access + fluid co-load; monitors (BP, HR, SpO2, FHR); (2) Position — sitting or lateral decubitus; back arched; (3) Sterile technique — chlorhexidine prep, drape, mask; (4) Identify L3-4 or L4-5 (avoid cord); LOR (loss of resistance) to saline or air; thread catheter 3-5 cm; (5) Test dose — lidocaine 1.5% + epi 1:200,000, 3 mL — detects intravascular (HR rise) or intrathecal (motor block); (6) Loading dose — bupivacaine 0.0625-0.125% with fentanyl 2 mcg/mL, 10-15 mL incremental; (7) Maintenance — PCEA (Patient-Controlled Epidural Analgesia): continuous low-dose (8-12 mL/hr) + bolus (5 mL q10-15 min); or PIEB (Programmed Intermittent Epidural Bolus) — newer, less local + better coverage; (8) Local anesthetic — bupivacaine 0.0625-0.125% with fentanyl 2 mcg/mL most common; ropivacaine alternative; (9) Goals — sensory T10, motor preservation (walking epidural concept), maternal satisfaction; (10) Monitor for hypotension (fluid + phenylephrine), inadequate block (re-dose, replace catheter), high block, intravascular migration, PDPH; (11) C-section conversion — bolus 2% lidocaine 15-20 mL with epinephrine + bicarbonate; T4 dermatome; (12) Modern: CSE (combined spinal-epidural) for faster onset; ultrasound-guided neuraxial helps in difficult

---

Labor epidural: test dose, low-dose bupivacaine + fentanyl, PCEA/PIEB. Convert to C-section with 2% lidocaine + epi + bicarb. Walking epidural concept. CSE faster onset. Ultrasound helps difficult.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 28 ปี G1P0 GA 38 wk active labor, requesting epidural
BP 110/70, HR 88, no contraindications
Lumbar spine palpable normally';

update public.mcq_questions
set choices = '[{"label":"A","text":"Adult-dosed propofol"},{"label":"B","text":"Pediatric T+A anesthesia + airway"},{"label":"C","text":"No pain medication"},{"label":"D","text":"Long-acting opioid premedication"},{"label":"E","text":"Skip dexamethasone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric T+A anesthesia + airway: (1) Pre-op — fasting (clear fluids 1-2h, breast milk 4h, formula/light meal 6h, full meal 8h — modern shorter clear fluids OK); avoid pre-medication unless anxious (midazolam PO 0.5 mg/kg); EMLA cream for IV access; parental presence + child life; (2) Induction options: - Inhalational (mask) sevoflurane 8% in O2/N2O → IV access after — common in children; - IV propofol 2-3 mg/kg + opioid + NMB (older children); (3) Airway — RAE tube (oral preformed) for surgical access; size = age/4 + 4 (uncuffed) or age/4 + 3.5 (cuffed); cuffed ETT now standard for most peds (low-pressure cuffs); (4) Position — Rose''s position (head extension), shared airway with surgeon; (5) Maintenance — sevoflurane in O2/air; opioid (fentanyl 1-2 mcg/kg); avoid N2O if PONV risk; multimodal — acetaminophen + dexamethasone + ondansetron; (6) Dexamethasone 0.15-0.5 mg/kg (max 8mg) — PONV + airway edema + analgesia; (7) Post-tonsillectomy bleeding — risk 1-3% (primary 24h, secondary 5-10 days) — emergency = full stomach swallowed blood, hypovolemia, difficult airway; RSI with cricoid + suction ready; (8) Extubation — deep extubation or fully awake (debated); (9) Post-op — PONV common (Apfel + opioid + surgery type all high); multimodal antiemetics; pain control; observation for bleeding 4-8h; (10) OSA considerations — common indication; reduce opioid, observe overnight

---

Peds T+A: inhalational induction common, RAE tube, cuffed ETT modern, dexamethasone, multimodal anti-emetic + analgesia. Watch for OSA + post-op bleed (RSI). Modern shorter fasting clear fluids 1-2h.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'เด็กชาย 4 ปี ASA I — elective tonsillectomy + adenoidectomy
Weight 16 kg, healthy, no allergies, NPO 8h
No family history of anesthesia issues';

update public.mcq_questions
set choices = '[{"label":"A","text":"Proceed always"},{"label":"B","text":"Pediatric URI + anesthesia decision"},{"label":"C","text":"Refuse all elective surgery for 6 months"},{"label":"D","text":"Use ETT always"},{"label":"E","text":"Ignore symptoms"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric URI + anesthesia decision: (1) Risks of anesthesia with URI — laryngospasm (10× higher), bronchospasm, hypoxemia, desaturation, breath-holding, atelectasis; severity = active URI > recovering > none; (2) Decision factors: - Symptoms active (purulent rhinorrhea, productive cough, fever > 38) — consider DELAY; - LRTI signs (wheezing, crackles, severe cough) = DELAY 2-4 weeks; - Mild symptoms only (clear runny nose, no fever, no cough) — proceed with caution; - Risk factors increasing risk: prematurity, asthma, OSA, surgery type (airway), GA + ETT vs LMA vs regional; (3) Delay timing — wait 2-4 weeks for full resolution; longer (6 weeks) if severe LRTI; (4) If proceed despite URI: - Avoid ETT if possible (LMA or mask preferred); - Maintain anesthesia depth, especially at extubation; - Avoid stimulating airway; - Higher FiO2; - Bronchodilator pre-op if reactive airway; - Consider regional anesthesia (caudal block for hernia); (5) Parental discussion — risks + alternatives; (6) Inguinal hernia repair — caudal block adjuvant minimizes opioid + general anesthetic; (7) For THIS patient (active purulent symptoms, fever) — recommend RESCHEDULE 2-4 weeks; (8) Document

---

Peds URI: active symptoms (fever, purulent, productive cough) = delay 2-4 weeks; mild (clear rhinorrhea) = proceed cautiously, LMA over ETT, regional. Risk laryngospasm/bronchospasm 10× higher.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'เด็กชาย 2 ปี 12 kg — preop assessment, mother reports URI ปัจจุบัน × 3 วัน, runny nose green, cough productive, mild fever 37.8°C
Elective inguinal hernia repair scheduled today';

update public.mcq_questions
set choices = '[{"label":"A","text":"Proceed immediately"},{"label":"B","text":"Pyloric stenosis = MEDICAL emergency, NOT surgical; correct electrolyte first"},{"label":"C","text":"Use furosemide for diuresis"},{"label":"D","text":"Skip electrolyte check"},{"label":"E","text":"Adult-dosed medications"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pyloric stenosis = MEDICAL emergency, NOT surgical; correct electrolyte first: (1) Hypochloremic, hypokalemic, metabolic alkalosis (from persistent vomiting losing HCl); pyloric stenosis: - Surgical correction can wait until electrolytes corrected; - Goal: Cl > 95, K > 3.5, HCO3 < 30, normal pH; (2) IV rehydration — NS bolus 20 mL/kg (~140 mL for 7 kg), then D5 1/2 NS + KCl 20-40 mEq/L at 1.5× maintenance rate; takes 12-48h typically; (3) Anesthesia considerations once corrected: - Full stomach — RSI with cricoid; suction OG before induction; - Propofol or sevoflurane mask induction; succinylcholine 2 mg/kg or rocuronium 1.2 mg/kg; - Cuffed ETT size 4.0; - Atropine 20 mcg/kg pre-induction (bradycardia risk neonates); (4) Postoperative apnea risk — alkalosis + CSF alkalosis → post-op apnea up to 24h; monitor closely; avoid long-acting opioid; multimodal — acetaminophen, local infiltration, ilioinguinal block; (5) Hypoglycemia risk — D5 maintenance; (6) Temperature — neonatal heat loss; warm fluids, warming devices; (7) Post-op — apnea monitoring 12-24h, NG suction, ICU/HDU; (8) NEVER operate before electrolyte correction — anesthesia risk + arrhythmia + post-op apnea worse; (9) Multidisciplinary — peds surgery + anesthesia + neonatology

---

Pyloric stenosis: medical emergency first - correct hypochloremic hypoK metabolic alkalosis BEFORE surgery. RSI with cricoid. Atropine pre-induction. Post-op apnea risk monitor 12-24h. Multimodal analgesia.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'เด็กเล็ก 6 เดือน 7 kg — emergency pyloric stenosis pyloromyotomy
Vomiting × 3 วัน, dehydrated
Lab: Na 128, K 3.0, Cl 88, HCO3 32, pH 7.50';

update public.mcq_questions
set choices = '[{"label":"A","text":"Operate immediately"},{"label":"B","text":"Congenital diaphragmatic hernia"},{"label":"C","text":"Mask bag ventilation"},{"label":"D","text":"Use N2O routinely"},{"label":"E","text":"Aggressive hyperventilation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Congenital diaphragmatic hernia — neonatal anesthesia: (1) Pre-op stabilization is KEY — modern approach delays surgery until stable (24-72h+); pulmonary hypertension + lung hypoplasia drive outcomes; (2) Stabilization: gentle ventilation (HFOV often), permissive hypercapnia (pH > 7.20, PaCO2 50-65), avoid hyperventilation, low PIP target < 25-28; iNO for PHTN; cardiotonic support (milrinone, dobutamine, epinephrine, vasopressin); avoid pulmonary vasoconstriction (hypoxia, acidosis, cold, pain); (3) ECMO criteria — refractory hypoxemia/hypercarbia despite max conventional support; (4) Anesthesia approach when ready for surgery: - Continue current ventilation strategy in OR; - Avoid mask ventilation pre-op (gastric distension worsens lung compression) — already intubated typically; - OG tube continuous suction; - Anesthetic: fentanyl-based (CV stable), low MAC sevoflurane if tolerated, NMB; - Avoid N2O (expands bowel); (5) Monitor — pre/post-ductal SpO2 (right radial + lower extremity), arterial line, +/- CVL, urine output, temperature; (6) Volume status — careful, avoid both over and under-resuscitation; (7) Surgical — repair via subcostal or thoracoscopic; primary closure or patch; (8) Post-op — NICU; expect prolonged ventilation; pulmonary HTN management ongoing; (9) Long-term — chronic lung disease, GERD, neurodevelopmental issues; (10) Multidisciplinary: neonatology + peds surgery + anesthesia + ECMO team

---

CDH: delay surgery until stable, gentle ventilation, permissive hypercapnia, iNO for PHTN. No mask BVM (gastric distension). Pre/post-ductal SpO2. Fentanyl-based anesthesia. ECMO if refractory.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ทารกแรกเกิด full-term 3.2 kg, day of life 1 — neonatal congenital diaphragmatic hernia (CDH) surgical repair planned
Intubated, on HFOV, iNO, PaO2 60, PaCO2 50, pH 7.30
Unstable hemodynamics on epinephrine + milrinone';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait observe"},{"label":"B","text":"Pediatric laryngospasm management"},{"label":"C","text":"Continue mask without intervention"},{"label":"D","text":"Decrease sevoflurane"},{"label":"E","text":"Mass IV fluid bolus"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric laryngospasm management: (1) Recognition — inspiratory stridor → silent obstruction; chest wall paradoxical motion; desaturation; often during light anesthesia + airway stimulation; (2) Immediate — call for help; (3) Larson maneuver — pressure to ''laryngospasm notch'' (behind ear lobe, condyle of mandible, mastoid process) — bilateral firm anterior pressure; jaw thrust; (4) 100% O2 + tight mask seal + CPAP 10-15 cmH2O via mask; (5) Deepen anesthesia — increase sevoflurane if tolerated, BUT often need IV access; (6) IV access — establish ASAP; if no IV: - IM succinylcholine 4 mg/kg (max 200 mg) + atropine 20 mcg/kg (prevent bradycardia); onset 2-4 min; - IO access if difficult IV; - Intralingual succinylcholine emergency (controversial); (7) Once IV: propofol 0.5-1 mg/kg (deepen, may break spasm) OR succinylcholine 0.5-1 mg/kg IV; (8) Bradycardia risk in peds during hypoxia — atropine 20 mcg/kg ready; (9) NPPE (negative pressure pulmonary edema) — risk after relieved laryngospasm; treat with PEEP, diuretic; (10) Cardiac arrest — pediatric hypoxic arrest can occur quickly; ACLS pediatric algorithm; (11) Prevention — avoid extubation in light plane, suction before extubation, no stimulation during light plane, awake or deep extubation only; magnesium 30 mg/kg may reduce; (12) Post-event — observe for NPPE, document

---

Peds laryngospasm: Larson maneuver + CPAP 100% O2, deepen with propofol if IV, IM sux + atropine if no IV. Bradycardia risk. NPPE post-relief. Prevent: avoid light-plane stimulation.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'เด็กชาย 5 ปี 18 kg — laryngospasm after sevoflurane induction prior to IV access
SpO2 95→78%, paradoxical movement, no air movement
No IV yet, no surgical stimulation';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue induction"},{"label":"B","text":"Cardiac anesthesia induction in severe LV dysfunction"},{"label":"C","text":"Massive propofol bolus"},{"label":"D","text":"High volatile concentration"},{"label":"E","text":"Beta-blocker"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cardiac anesthesia induction in severe LV dysfunction: (1) Induction hypotension common in severe HF — minimize CV impact: - Etomidate or ketamine preferred (less hypotension); - Slow titrated fentanyl (5-10 mcg/kg total); - Avoid propofol bolus (myocardial depression + vasodilation); - Pre-induction arterial line + vasopressor ready; (2) Treatment immediate: - Vasopressor bolus — phenylephrine 50-100 mcg or norepinephrine 4-8 mcg or vasopressin 0.5-1U; - Inotrope if low CO — epinephrine 5-10 mcg, ephedrine 5-10 mg, milrinone bolus carefully; - Volume — TEE guided if available; cautious in HF (avoid pulm edema); 250 mL crystalloid bolus if low filling; - Reduce afterload — only if elevated SVR + adequate BP; - Treat arrhythmia (HR + rhythm); (3) Re-evaluate anesthetic depth + adjust; (4) Cardiac anesthesia principles: - Maintain coronary perfusion (DBP - LVEDP); - Avoid tachycardia (worsens ischemia); - Avoid extreme HTN/HoTN; - Multimodal — opioid-based + low-dose volatile; - TEE intraop monitoring; - Goal-directed hemodynamic management; (5) Pre-induction prep — arterial line awake (radial), vasopressor/inotrope drawn up + running, TEE probe ready, surgeon scrubbed in cardiac case; (6) Post-CPB considerations — vasoplegia common; methylene blue + vasopressin if refractory norepinephrine; (7) Post-op — ICU, hemodynamic monitoring, weaning support, neuro recovery

---

Cardiac induction in low EF: etomidate/ketamine, slow fentanyl, avoid propofol bolus. Vasopressor + inotrope ready. TEE-guided. Pre-induction arterial line. Goal-directed hemodynamic.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 68 ปี CABG × 3, LVEF 30%, severe LV dysfunction
During induction post-fentanyl + etomidate: BP drops 120/70 → 70/40, no surgical stimulation yet
CVP 8, pulse contour CO showing low cardiac output';

update public.mcq_questions
set choices = '[{"label":"A","text":"Standard ETT bilateral ventilation"},{"label":"B","text":"One-lung ventilation (OLV) for thoracic surgery"},{"label":"C","text":"Mass fluid loading"},{"label":"D","text":"100% O2 always"},{"label":"E","text":"Highest possible MAC"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** One-lung ventilation (OLV) for thoracic surgery: (1) Lung isolation device: - Double-lumen tube (DLT) — left-sided most common (right rare due to RUL bronchus issues); size 35-41 F based on height; fiberoptic confirmation MANDATORY; - Bronchial blocker (Arndt, Cohen, Univent) — alternative if difficult intubation or already intubated; less precise but useful; (2) DLT placement — direct laryngoscopy + advance until resistance + rotate; fiberoptic confirms position; reposition after side change; (3) OLV physiology — V/Q mismatch + shunting → hypoxia risk; hypoxic pulmonary vasoconstriction (HPV) helps redirect blood to ventilated lung; volatile anesthetics inhibit HPV — minimize MAC; (4) Ventilator strategy: - Lung-protective TV 4-6 mL/kg IBW (lower than two-lung); - PEEP 5-10 (ventilated lung); CPAP 5-10 (non-ventilated lung) if hypoxia; - Permissive hypercapnia OK; - Avoid high FiO2 except as needed; - PCV often preferred; (5) Hypoxia OLV: - Confirm DLT position; - 100% O2; - Recruit ventilated lung; - CPAP non-ventilated lung; - Intermittent two-lung ventilation; - PEEP ventilated lung; - Inhaled vasodilator selective; (6) Bronchospasm common — bronchodilator; (7) Fluids — restrictive (post-op pneumonectomy lung edema); (8) Analgesia — thoracic epidural or PVB highly recommended; ESP block alternative; multimodal; (9) Post-op — extubate ASAP, ICU/step-down; pain control critical; (10) Pneumonectomy considerations — strict fluid restriction (post-pneumonectomy pulmonary edema)

---

OLV: DLT (L > R) or bronchial blocker, fiberoptic confirm. Lung-protective TV 4-6 mL/kg + PEEP. Hypoxia algorithm: position, CPAP, PEEP. Volatile inhibits HPV. Thoracic epidural/PVB analgesia. Restrictive fluids.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 60 ปี — right-sided lung resection (lobectomy) for cancer
FEV1 65%, DLCO 70%, no other CV disease
Plan one-lung ventilation';

update public.mcq_questions
set choices = '[{"label":"A","text":"Vasopressor infusion only"},{"label":"B","text":"Cardiac tamponade post-cardiac surgery"},{"label":"C","text":"Aggressive diuresis"},{"label":"D","text":"Wait observe"},{"label":"E","text":"Sedation deeper"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cardiac tamponade post-cardiac surgery: (1) Recognition — Beck''s triad (hypotension + elevated venous pressure + muffled heart sounds) less reliable post-op; signs: hypotension, tachycardia, rising CVP, decreased CT output (clot obstruction), pulsus paradoxus, equalization of diastolic pressures; (2) Confirm — TTE or TEE (gold standard) — pericardial effusion + RV/RA diastolic collapse + IVC plethora + respiratory variation Doppler; CT if stable; (3) MEDICAL emergency — temporize: - Volume — 250-500 mL bolus to improve filling; - Inotrope — dobutamine, epinephrine; - Avoid bradycardia + decreased contractility; - Avoid positive pressure ventilation if possible (worsens venous return); spontaneous ventilation preferred; (4) DEFINITIVE: pericardial drainage — pericardiocentesis (bedside if unstable) or surgical re-exploration (post-cardiac surgery preferred — clots often + locations atypical); (5) Operative pericardial window OR sternotomy re-exploration in OR; (6) Anesthesia for re-exploration: - Pre-op arterial line awake; - Ketamine induction (CV stable); - Maintain pre-op meds; - Avoid significant vasodilation/myocardial depression; - Prep + drape BEFORE induction (in case arrest during induction — open immediately); - Have surgeon ready; (7) DDx — coagulopathy, prosthetic valve issue, graft failure, MI, pulmonary embolism; (8) Multidisciplinary — anesthesia + CT surgery + ICU; (9) Modern: bedside echo essential skill ICU

---

Post-cardiac surgery tamponade: rising CVP + low CT output + hypotension. Echo (TEE/TTE) confirm. Volume + inotrope temporize. Re-exploration definitive. Ketamine induction. Prep before induction.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 75 ปี post-CABG day 1 — sudden hypotension BP 75/45, HR 110, CVP rises 8 → 18, decreased chest tube output (was 100 mL/hr, now 10 mL/hr) but increased mediastinal silhouette on CXR
Urine output decreasing';

update public.mcq_questions
set choices = '[{"label":"A","text":"Tachycardia desirable"},{"label":"B","text":"Mitral regurgitation hemodynamic goals"},{"label":"C","text":"Bradycardia preferred"},{"label":"D","text":"Phenylephrine first-line"},{"label":"E","text":"High SVR target"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mitral regurgitation hemodynamic goals: (1) Fast, full, forward (mnemonic): - Fast HR (avoid bradycardia — regurgitation time increases); target HR 80-90; - Full preload (maintain venous return); - Forward flow (low SVR — reduce afterload, reduce regurgitation); - Avoid increased PVR (worsens RV); (2) Anesthetic technique: - Neuraxial OK (reduces SVR — beneficial); careful titration; - GA acceptable; - Volatile reduces SVR (beneficial); - Avoid ketamine (increases SVR + HR + PVR — but HR helpful); (3) Drugs: - Vasopressor — norepinephrine (mild beta — maintain HR); avoid pure alpha (phenylephrine) — increases afterload + may worsen MR; - Inotrope — milrinone (vasodilator + inotrope), dobutamine; - Avoid bradycardia — atropine, ephedrine if needed; (4) Anticoagulation — warfarin for AFib — bridge with LMWH if high stroke risk + holding warfarin; or continue if procedure low bleed risk; (5) Continue beta-blocker (rate control AFib) + ACE-I usually (hold morning of surgery debated); (6) Volume — adequate preload; avoid fluid overload (pulm edema); (7) Monitor — arterial line; consider TEE intraop if major surgery + significant MR; (8) Post-op — rate control AFib, restart warfarin/DOAC, monitor HF; (9) Severe MR + symptoms → MV repair/replacement; if elective non-cardiac surgery — consider MV procedure first; (10) Multidisciplinary

---

MR hemodynamic goals: Fast, Full, Forward. Low SVR (afterload reduction). Avoid bradycardia + phenylephrine. Norepinephrine for vasopressor. Neuraxial OK. TEE intraop. Continue beta-blocker.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 55 ปี mitral regurgitation severe + AFib — elective non-cardiac surgery (cholecystectomy)
LVEF 50%, on warfarin INR 2.5, beta-blocker, ACE-I';

update public.mcq_questions
set choices = '[{"label":"A","text":"Use ketamine + N2O routinely"},{"label":"B","text":"Neuroanesthesia craniotomy principles"},{"label":"C","text":"Hypotensive technique aggressive"},{"label":"D","text":"PEEP 15 mandatory"},{"label":"E","text":"Mass hypotonic fluids"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neuroanesthesia craniotomy principles: (1) Goals — maintain CPP, control ICP, brain relaxation, smooth emergence for neuro exam; (2) CPP = MAP - ICP; target CPP 60-70; (3) ICP control intraop: - Head up 15-30°; - Avoid PEEP > 10 if possible; - Mannitol 0.5-1 g/kg or hypertonic saline 3% (250 mL) — osmotic diuresis; - Hyperventilation to PaCO2 30-35 (temporary, avoid < 30 prolonged — ischemia); - Avoid hypotonic fluids (use NS or balanced isotonic); - CSF drainage via lumbar drain (selected); (4) Anesthetic choice: - Propofol-based TIVA preferred (reduces CMRO2, ICP, may improve brain relaxation); - Volatile (sevoflurane < 1 MAC OK; high MAC vasodilator); - Avoid N2O (expands air, may worsen pneumocephalus); - Opioid (remifentanil infusion or fentanyl) for analgesia + blunt response; - Muscle relaxant — rocuronium or cisatracurium; avoid succinylcholine (transient ICP rise + K release); (5) Hemodynamic — arterial line; CVL if needed; tight BP control; avoid surges with laryngoscopy/pinning (lidocaine, opioid, deepen); (6) Avoid ketamine (controversial — some say OK with controlled ventilation but classic teaching: avoid); (7) Emergence — smooth, awake neuro exam priority; remifentanil + dexmedetomidine helpful; (8) Post-op — neuro ICU; serial neuro exams; HOB up; control BP, glucose, temperature (normothermia); seizure prophylaxis; (9) Awake craniotomy — for eloquent cortex; dexmedetomidine + remifentanil + scalp block; (10) Monitoring — neurophysiologic (SSEP, MEP) — affects anesthetic choice

---

Neuro craniotomy: CPP > 60, propofol-TIVA, avoid N2O + succinylcholine, mannitol/HTS, modest hyperventilation, smooth emergence. Scalp block for pinning. Awake craniotomy for eloquent areas.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 50 ปี — elective craniotomy for brain tumor (R frontal lobe)
GCS 15, no focal deficit, no seizure
MRI: 4 cm mass + minimal edema, no midline shift
Meds: dexamethasone 4mg q6h, levetiracetam 1g BID';

update public.mcq_questions
set choices = '[{"label":"A","text":"Allow BP to rise during induction"},{"label":"B","text":"Aneurysm clipping anesthesia"},{"label":"C","text":"Skip arterial line"},{"label":"D","text":"Allow hypovolemia"},{"label":"E","text":"Hyperventilate aggressively all case"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Aneurysm clipping anesthesia: (1) Pre-rupture goal — PREVENT rebleed (mortality 50% if rebleed); strict BP control SBP < 140-160; (2) Avoid HTN surges — at intubation, pinning, dural opening, emergence; (3) Premedication — small midazolam for anxiety; avoid heavy sedation (need neuro exam); (4) Induction: - Pre-induction arterial line MANDATORY; - Smooth induction: propofol + opioid (high-dose fentanyl 5-10 mcg/kg OR remifentanil 0.3-0.5 mcg/kg/min); - Lidocaine 1.5 mg/kg blunt response; - NMB rocuronium; - Esmolol/labetalol ready for HTN; - Scalp block (bupivacaine + epinephrine) for pinning + scalp incision; (5) Maintenance — TIVA propofol + remifentanil OR sevoflurane < 1 MAC + opioid; (6) Hemodynamic: - Tight BP control (avoid spikes); - SBP 140-160 before clipping; - Reduce BP for temporary clipping if needed (SBP 100-120, MAP 70-80); - After clipping: liberalize, allow higher BP for cerebral perfusion (Triple-H — Hypertension, Hypervolemia, Hemodilution — historic; now permissive HTN + euvolemia); (7) Brain relaxation: mannitol, hyperventilation modest, CSF drainage; (8) Burst suppression for temporary clipping — propofol bolus + EEG; (9) Avoid hyperglycemia (worsens ischemia); maintain normothermia (some advocate mild hypothermia — controversial); (10) Emergence — smooth, allow early neuro exam; (11) Post-op vasospasm — typically days 4-14 post-SAH; nimodipine, BP support (euvolemia + permissive HTN), endovascular treatment if symptomatic; (12) Endovascular alternative — coiling in IR

---

Aneurysm clipping: prevent rebleed (tight BP), pre-induction art line, scalp block, TIVA, burst suppression for temp clipping, mannitol + modest hyperventilation. Post-op vasospasm management. Endovascular alternative.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 45 ปี SAH grade III (Hunt-Hess) — emergent craniotomy for clipping ruptured anterior communicating aneurysm
GCS 13, BP 165/95, HR 90
No neuro deficit currently';

update public.mcq_questions
set choices = '[{"label":"A","text":"No special precautions for prone"},{"label":"B","text":"Prone position complications + management"},{"label":"C","text":"Eyes pressed against pad"},{"label":"D","text":"No padding required"},{"label":"E","text":"Avoid all monitoring"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Prone position complications + management: (1) Eye injury — POVL (Postoperative Visual Loss) — ischemic optic neuropathy most common in prolonged prone + blood loss; PREVENTION: - Eyes free of pressure (foam pad with holes); - Check eyes regularly q15-30 min; - Avoid hypotension (MAP > 70); - Limit blood loss; consider transfusion threshold; - Head neutral position, level with or higher than heart; - Avoid direct eye pressure; (2) Airway — ETT secure (taped firmly), EtCO2 monitor, anticipated airway swelling, leak test before extubation; (3) Neck — neutral position; (4) Pressure injuries — pad bony prominences (chest, iliac crests, knees, ankles); breasts/genitalia free; (5) Hemodynamic — venous return decreased; abdomen free (avoid IVC compression) — venous bleeding worse if pressure; (6) Pulmonary — chest free (improves compliance), but anterior chest wall compression possible; PCV often preferred; (7) Neuropathy — brachial plexus (arms < 90° abduction, supinated), ulnar nerves (padded elbows), lateral femoral cutaneous, peroneal; (8) Endotracheal tube obstruction (kink, secretion) — capnogram monitor; (9) Anesthesia — multi-modal opioid-sparing important (spine + fusion = high postop pain); TIVA reduces blood loss + facilitates motor/SSEP monitoring; (10) MEP/SSEP — TIVA preferred, avoid muscle relaxant after intubation; (11) Massive blood loss — type + cross, TXA 1g, cell saver; (12) Post-op — neuro exam, pain control, PT, DVT prophylaxis

---

Prone position: POVL prevention (no eye pressure, MAP > 70, limit blood loss), pad bony prominences, free abdomen + chest, neutral neck, brachial plexus protection, capnogram for ETT obstruction. TIVA for MEP.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 60 ปี diabetic — elective lumbar fusion L4-S1 posterior approach
Duration 4-6 hr prone position planned
Weight 95 kg';

update public.mcq_questions
set choices = '[{"label":"A","text":"Aggressive hyperventilation to PaCO2 25"},{"label":"B","text":"Severe TBI anesthesia"},{"label":"C","text":"Aggressive fluid restriction"},{"label":"D","text":"Hypotonic fluid"},{"label":"E","text":"Hypertonic saline contraindicated"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe TBI anesthesia: (1) ABC + C-spine precautions (always assume unstable C-spine in TBI); (2) Airway — RSI with MILS + video laryngoscopy; - Induction: etomidate (CV stable) or propofol; lidocaine pre-treatment; opioid (fentanyl); rocuronium (succinylcholine ICP rise — but minor + transient, often acceptable in TBI RSI); - Pre-O2 thorough; - Avoid hypotension (single SBP < 90 doubles mortality TBI); avoid hypoxia; (3) Intracranial pressure management: - Head up 30°, neck neutral (allows venous drainage); - PaCO2 35-40 normal; mild hyperventilation 30-35 ONLY for impending herniation (transient measure); - Hyperosmolar therapy: hypertonic saline 3% 250 mL or mannitol 0.5-1 g/kg; - Sedation + analgesia adequate; (4) BP/CPP — MAP > 80, CPP > 60 (BTF guideline); norepinephrine first-line vasopressor; (5) Fluid — isotonic crystalloid (NS, balanced); avoid hypotonic; avoid albumin (SAFE TBI subgroup worse); (6) Hyperglycemia — avoid (worsens secondary injury); target 140-180; (7) Temperature — normothermia (hyperthermia harmful); (8) Sodium — target Na 145-155 (mild hypernatremia OK); avoid hyponatremia; (9) Seizure prophylaxis — levetiracetam or phenytoin × 7 days (early seizure); (10) ICP monitor placement (Camino, EVD) — neurosurgery; ICP target < 20-22; (11) Avoid PEEP > 10 generally; (12) Cushing response (HTN + bradycardia) — ominous, indicates impending herniation; (13) Multidisciplinary: anesthesia + neurosurgery + ICU

---

TBI: avoid hypotension + hypoxia, RSI MILS, etomidate, mild HV only for herniation, hypertonic saline > mannitol, MAP > 80 CPP > 60. Normothermia. ICP monitor < 20-22. Cushing = herniation imminent.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 35 ปี traumatic brain injury, GCS 7, pupils 3 mm reactive, requires intubation + emergent OR for ICH evacuation
BP 160/90, HR 60 (Cushing-like)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Volatile + N2O + paralytic"},{"label":"B","text":"Neuromonitoring + anesthetic technique"},{"label":"C","text":"Deep hypothermia"},{"label":"D","text":"Continuous NMB infusion"},{"label":"E","text":"Heavy sedation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neuromonitoring + anesthetic technique: (1) SSEP (Somatosensory Evoked Potential) — cortical signal from peripheral nerve stimulation; sensitive to: volatile (dose-dependent suppression), hypothermia, hypotension, hypoxia, anemia; (2) MEP (Motor Evoked Potential) — direct cortical stimulation, recorded in muscles; MORE sensitive than SSEP to anesthetic + muscle relaxant; (3) Preferred anesthetic for SSEP + MEP: - TIVA propofol + opioid (remifentanil/sufentanil) — minimal interference; - Ketamine acceptable (some advocate); - Dexmedetomidine well-tolerated; - Low-dose volatile (< 0.5 MAC) tolerable for SSEP, suppresses MEP; (4) AVOID: - High-dose volatile (suppresses both); - N2O (suppresses both, expands air); - Muscle relaxant after intubation (eliminates MEP); use intermediate-acting rocuronium for intubation, then no further dose; (5) Maintain physiology: - MAP > 70; - SpO2 > 95%; - Normothermia 36-37°C; - Normocarbia PaCO2 35-40; - Adequate Hb (> 9-10 typically); (6) Communication with neuromonitoring tech essential — alerts to signal changes; (7) Signal change response — STOP surgery, check anesthetic + physiology, reposition if needed; (8) Stagnara wake-up test alternative (rare now); (9) Documentation; (10) Modern: routine for scoliosis, spinal cord tumor, complex spine surgery

---

Neuromonitoring anesthesia: TIVA propofol + remifentanil, low/no volatile, NO N2O, single-dose NMB only. Maintain MAP, normothermia, Hb. MEP more sensitive than SSEP. Communicate with tech.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วย post-spine surgery 50 ปี ICU monitoring SSEP + MEP signals
Surgeon requests anesthetic technique that preserves neuromonitoring';

update public.mcq_questions
set choices = '[{"label":"A","text":"Aggressive crystalloid only"},{"label":"B","text":"Hemorrhagic shock + damage control resuscitation"},{"label":"C","text":"Crystalloid 5L bolus"},{"label":"D","text":"Aggressive vasopressor without blood"},{"label":"E","text":"Refuse transfusion"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hemorrhagic shock + damage control resuscitation: (1) Massive Transfusion Protocol — pre-defined ratios, immediate release; (2) Balanced transfusion 1:1:1 (PRC:FFP:Platelets) per PROPPR trial; whole blood emerging (military origin); (3) TXA 1g IV bolus < 3h, then 1g over 8h (CRASH-2 mortality reduction); (4) Permissive hypotension — SBP 80-90 until hemorrhage controlled (avoid for TBI); reduces clot disruption + further bleeding; (5) Minimize crystalloid — worsens coagulopathy + edema + abdominal compartment syndrome; (6) Calcium replacement — citrate from transfusion chelates Ca; check iCa, replace 1g CaCl2 every 4 units PRBC; (7) Warming — warmed fluids + blankets; hypothermia worsens coagulopathy + cardiac function; (8) Fibrinogen target > 1.5-2 g/L; cryoprecipitate (10 units) or fibrinogen concentrate if low; (9) Viscoelastic testing (TEG/ROTEM) — guides component therapy (FFP, platelets, cryo, TXA); (10) Anesthetic — ketamine 1-2 mg/kg + opioid; etomidate alternative; avoid propofol bolus (hypotension); maintain low-dose volatile/TIVA; (11) Vasopressor — norepinephrine if persistent hypotension despite volume; vasopressin adjunct; (12) Calcium gluconate or chloride; (13) Lung-protective ventilation; (14) Post-op — ICU, monitor for ACS (abdominal compartment), AKI, MOF, coagulopathy; (15) Damage control surgery — quick hemorrhage + contamination control, leave open, return 24-48h

---

Trauma hemorrhagic shock: MTP 1:1:1, TXA, permissive hypotension (except TBI), minimize crystalloid, Ca replacement, warm, TEG/ROTEM-guided. Ketamine + low-dose volatile. Damage control surgery.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 28 ปี GSW abdomen + chest, profound shock
BP 70/40, HR 140, GCS 14, intubated in ED
FAST positive, hemoperitoneum
Blood products activated, MTP started';

update public.mcq_questions
set choices = '[{"label":"A","text":"More fluid 5L"},{"label":"B","text":"Septic shock"},{"label":"C","text":"Stop all vasopressor"},{"label":"D","text":"Hypotonic fluid"},{"label":"E","text":"Avoid steroid always"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Septic shock — Surviving Sepsis Campaign 2021: (1) Initial — 30 mL/kg crystalloid within 3h (now individualized); reassess hemodynamic response; (2) Antibiotics within 1h (broad-spectrum); source control; (3) Vasopressor — norepinephrine first-line (alpha + mild beta); target MAP > 65 (some advocate higher 80-85 in chronic HTN); (4) Refractory shock — add vasopressin 0.03-0.04 U/min (V1 receptor — non-catecholamine sparing); epinephrine third-line; (5) Stress-dose steroid — hydrocortisone 200 mg/day continuous infusion or 50 mg q6h IV if refractory shock on norepinephrine + vasopressin; ADRENAL trial showed faster shock resolution; (6) Fluid responsiveness assessment — passive leg raise, pulse pressure variation > 13%, IVC variation, cardiac output monitor; avoid fluid overload (mortality); (7) Goal-directed: lactate clearance, ScvO2, MAP, urine output; (8) Glycemic control — target < 180; insulin infusion; (9) DVT + stress ulcer prophylaxis; (10) Lung-protective ventilation TV 6 mL/kg, plateau < 30, PEEP per FiO2; prone if severe ARDS PaO2/FiO2 < 150; (11) Sedation — light, dexmedetomidine, daily SAT; (12) Renal — CRRT if AKI + refractory; (13) Nutrition — early enteral if possible; (14) Family communication + goals of care; (15) Multidisciplinary; (16) Avoid prolonged unnecessary fluids; modern trend conservative fluid + early vasopressor

---

Septic shock SSC 2021: initial 30 mL/kg, norepi first-line, vasopressin + steroid for refractory, MAP > 65, lactate clearance, fluid-responsive assessment, lung-protective, CRRT. Conservative fluids modern trend.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ICU patient 65 ปี septic shock, intubated, on norepinephrine 0.4 mcg/kg/min + vasopressin 0.04 U/min
Lactate 5.2, MAP 58, urine output 15 mL/hr × 4h
Fluids 3L crystalloid already given';

update public.mcq_questions
set choices = '[{"label":"A","text":"Increase TV to 10 mL/kg"},{"label":"B","text":"Severe ARDS management"},{"label":"C","text":"Permissive supine without prone"},{"label":"D","text":"High TV 12 mL/kg"},{"label":"E","text":"No PEEP"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe ARDS management — ARDSnet + recent evidence: (1) Lung-protective ventilation: - TV 4-6 mL/kg IBW (predicted body weight); - Plateau pressure < 30 cmH2O; - Driving pressure < 15 cmH2O (delta P = Pplat - PEEP); - PEEP titration per FiO2 (ARDSnet table) or optimal PEEP (best compliance, lowest driving P); (2) PaO2/FiO2 < 150 = severe ARDS — prone positioning 16h/day (PROSEVA trial — mortality benefit); (3) Conservative fluid strategy after initial resuscitation (FACTT); (4) Neuromuscular blockade in early severe ARDS (ACURASYS — controversial; ROSE found no benefit if not deeply sedated); (5) Recruitment maneuvers — controversial (ART trial harm); selective use; (6) ECMO — refractory hypoxia despite optimization (EOLIA trial); P/F < 50 for 3h or < 80 for 6h; CESAR for transfer to center; (7) Inhaled vasodilator (NO, prostacyclin) — selective pulmonary vasodilation, improves oxygenation, no mortality benefit; (8) Permissive hypercapnia (pH > 7.20) OK; (9) Sedation — minimize, daily SAT; (10) Steroids — DEXA-ARDS trial showed benefit dexamethasone 20 mg × 5d then 10 mg × 5d for moderate-severe ARDS; (11) Treat underlying cause; (12) Nutrition + DVT prophylaxis + ABCDEF bundle; (13) APRV (Airway Pressure Release Ventilation) — alternative mode; (14) Family communication + goals of care; (15) Modern: prone positioning + ECMO save lives

---

Severe ARDS: TV 4-6 mL/kg IBW, Pplat < 30, driving P < 15, PEEP titration. Prone for P/F < 150. Conservative fluids. ECMO refractory. Dexamethasone benefit. Inhaled NO bridge. Modern: prone + ECMO.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ICU ARDS patient 50 ปี post-pneumonia
PaO2/FiO2 95 on FiO2 0.7 + PEEP 12
Plateau pressure 32, TV 6 mL/kg IBW
Mechanically ventilated 3 วัน, hemodynamically stable';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait observation only"},{"label":"B","text":"Post-cardiac arrest care (PCAC)"},{"label":"C","text":"Allow fever to 39°C"},{"label":"D","text":"Withdraw care immediately"},{"label":"E","text":"Aggressive hyperoxia"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-cardiac arrest care (PCAC): (1) Targeted Temperature Management (TTM) — TTM2 trial showed 33°C vs 36°C equivalent; current consensus: avoid fever (target 32-36°C × 24h, then rewarm slowly 0.25°C/hr); (2) Cardiopulmonary support — MAP > 65-80 (some advocate higher), avoid hypotension, lactate normalization; (3) Ventilation — PaO2 90-100 (avoid hyperoxia + hypoxia), PaCO2 35-45 (normocapnia), lung-protective; (4) Glucose 140-180; (5) Seizure detection — continuous EEG (subclinical seizure common); treat with levetiracetam, valproate, benzo for convulsive; (6) Sedation — propofol + opioid + NMB during TTM to prevent shivering; magnesium 2g; counterwarming; (7) Coronary angiography — if STEMI on ECG; consider if non-STEMI + presumed cardiac cause (selective per recent trials); (8) Neuroprognostication — DELAY > 72h after rewarming for accurate assessment; multimodal: clinical exam (GCS M, pupillary, corneal), bilateral absent N20 SSEP, NSE, EEG, MRI; do NOT base prognosis on single modality early; (9) Withdrawal of life-sustaining therapy — based on neuroprognostication, patient wishes, family discussion; (10) Modern: ECPR (ECMO-assisted CPR) for refractory; (11) Cause identification — CAD, PE, sepsis, hypoxia, etc; (12) Family communication ongoing

---

Post-arrest care: TTM (avoid fever 32-36°C), MAP > 65, normoxia + normocapnia, EEG monitoring, neuroprognostication > 72h post-rewarm multimodal, treat reversible cause. ECPR emerging.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ICU patient 70 ปี post-cardiac arrest ROSC × 1h, intubated, comatose
GCS 4, no withdrawal
Core temp 36.4°C, BP 110/70 on no vasopressor
Lactate 4, no overt seizure';

update public.mcq_questions
set choices = '[{"label":"A","text":"Cool further to 32°C"},{"label":"B","text":"Post-damage control resuscitation in ICU"},{"label":"C","text":"Avoid all warming"},{"label":"D","text":"Maximize crystalloid"},{"label":"E","text":"Skip antibiotics open fracture"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-damage control resuscitation in ICU: (1) Continue resuscitation goals — normalize lactate, hemoglobin, coagulation, temperature; (2) Lethal triad reversal: - Hypothermia: warming (Bair Hugger, warm fluids, IV warmer, room temp 24-26°C); target 36-37°C; - Coagulopathy: TEG/ROTEM-guided product therapy; FFP, platelets, fibrinogen, cryoprecipitate; - Acidosis: improve perfusion + ventilation; bicarb selectively; (3) Volume + perfusion — balanced approach; vasopressor as needed; lactate clearance goal; (4) Reduce vasopressor as appropriate; (5) Ventilation — lung-protective; chest tube monitor; expect ARDS risk with lung contusion + transfusion; (6) Imaging — secondary survey CT scans (head, chest, abd, pelvis); (7) Antibiotic — open fracture prophylaxis (cefazolin + gentamicin Gustilo III); tetanus; (8) Pain — multimodal (regional anesthesia useful — fascia iliaca, lumbar plexus, paravertebral, ESP); minimize opioid; (9) Return to OR for definitive surgery (24-72h) — orthopedic, abdominal closure; (10) DVT prophylaxis — early (mechanical immediate; pharmacologic 48-72h depending on bleeding); (11) Stress ulcer prophylaxis; (12) Early enteral nutrition; (13) Monitor for ACS (abdominal compartment), AKI, MOF, infection, splenectomy considerations (vaccinate); (14) Multidisciplinary team — trauma, anesthesia, ortho, ICU, PT, nutrition; (15) Family communication

---

Post-DCS ICU: reverse lethal triad (warm, correct coag, treat acidosis), TEG/ROTEM-guided, lactate clearance, multimodal regional analgesia, early DVT prophylaxis, definitive surgery 24-72h, multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 45 ปี polytrauma open femur + pelvic fracture, splenic laceration, lung contusion
Post-laparotomy + splenectomy + ex fix → ICU
BP 110/70 on norepi 0.1, lactate 3, Hb 8.5, INR 1.4
ABG: pH 7.30, PaO2 75, PaCO2 45, T 35.0°C';

update public.mcq_questions
set choices = '[{"label":"A","text":"Stop all opioids preop"},{"label":"B","text":"Chronic opioid use perioperative"},{"label":"C","text":"Discharge with double opioid dose"},{"label":"D","text":"Combine opioid + benzo"},{"label":"E","text":"Refuse perioperative care"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Chronic opioid use perioperative: (1) Continue chronic opioid regimen — abrupt stop causes withdrawal + worsens pain; (2) Calculate baseline MME (morphine milligram equivalents) — informs intra/post-op needs; tolerance = increased opioid requirements (3-5×); (3) Multimodal opioid-sparing maximally: - Acetaminophen scheduled; - NSAID (ketorolac, celecoxib) unless CI; - Ketamine infusion 0.1-0.3 mg/kg/hr (anti-hyperalgesic + opioid-sparing); - Continue gabapentinoid (pregabalin); - Continue duloxetine; - Dexamethasone single dose; - Lidocaine infusion (1-2 mg/kg/hr); - Magnesium sulfate; (4) Regional anesthesia maximally — neuraxial (epidural for spine — controversial near surgical site; ESP block alternative), peripheral nerve blocks; (5) Intra-op opioid — higher doses than naive; (6) Post-op pain — PCA hydromorphone (or fentanyl) with higher doses; basal rate avoided typically but considered; (7) Coordinate with pain medicine + addiction medicine; (8) Discharge — transition off short-acting back to chronic regimen + multimodal; avoid escalation; close follow-up; (9) Tolerance considerations: - May need higher intra-op opioid (sufentanil/fentanyl); - Hyperalgesia phenomenon — opioid-induced; ketamine helps; (10) Psychological support — anxiety, catastrophizing, depression contribute to perception; (11) Goals of care discussion + realistic expectations; (12) Avoid combining opioids + benzodiazepines (CDC warning — respiratory depression mortality)

---

Chronic opioid: continue, multimodal opioid-sparing (ketamine, lidocaine, regional, gabapentinoid), higher intra-op doses, transition back postop. Pain + addiction medicine consult. Avoid opioid + benzo combo.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 45 ปี chronic back pain × 5 ปี — admitted for elective spinal fusion
Meds: oxycodone ER 40 mg BID + IR 10 mg q4h PRN, pregabalin 150 mg BID, duloxetine 60 mg daily
Daily MME estimated 180';

update public.mcq_questions
set choices = '[{"label":"A","text":"Surgery again"},{"label":"B","text":"Chronic Post-Mastectomy Pain Syndrome (post-surgical neuropathic pain)"},{"label":"C","text":"Long-term high-dose opioid"},{"label":"D","text":"Single nerve block only"},{"label":"E","text":"Ignore symptoms"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Chronic Post-Mastectomy Pain Syndrome (post-surgical neuropathic pain): (1) Pathophys — intercostobrachial nerve injury most common (axillary dissection); central sensitization; (2) Risk factors — axillary lymph node dissection, chemo/radiation, younger age, higher acute postop pain, anxiety/depression; (3) Diagnosis — clinical; neuropathic features (burning, shooting, allodynia, hyperalgesia); chronic > 3 months postop; rule out recurrence imaging; (4) Multimodal treatment: - Pharmacologic: gabapentinoid (gabapentin titrate to 1800-3600 mg/day; pregabalin 75-300 mg BID), TCA (amitriptyline, nortriptyline 10-75 mg HS), SNRI (duloxetine, venlafaxine), topical lidocaine 5% patch, capsaicin 8% patch; - Avoid chronic opioid (limited efficacy + addiction risk); - Acetaminophen + NSAID adjunct; (5) Interventional: - Intercostal nerve block; - Pulsed radiofrequency intercostal nerve; - Paravertebral block; - Stellate ganglion block; - Erector spinae plane block (ESP) — both diagnostic + therapeutic; (6) Non-pharmacologic — PT, TENS, mindfulness, CBT, acupuncture; (7) Psychological support — depression, anxiety, PTSD common in cancer survivors; (8) Prevention (best) — regional anesthesia at surgery (PVB, ESP), multimodal analgesia perioperatively, minimize acute postop pain; (9) Multidisciplinary pain clinic; (10) Refractory — spinal cord stimulation, intrathecal pump

---

Chronic post-mastectomy pain: neuropathic, intercostobrachial nerve injury. Multimodal: gabapentinoid, TCA, SNRI, topical, interventional (intercostal, PVB, ESP). Avoid chronic opioid. Prevention via regional at surgery.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 55 ปี post-mastectomy 3 เดือน — persistent burning + shooting pain ipsilateral chest wall + axilla
Non-radiating, allodynia + hyperalgesia present
No recurrence on imaging';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait + observe"},{"label":"B","text":"CRPS Type I management"},{"label":"C","text":"Amputation"},{"label":"D","text":"High-dose opioid only"},{"label":"E","text":"Refuse evaluation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** CRPS Type I management: (1) Diagnosis — Budapest criteria (continuing pain disproportionate to event + symptoms in 3 of 4 categories: sensory, vasomotor, sudomotor/edema, motor/trophic + signs in 2 of 4 + no alternative diagnosis); (2) Multidisciplinary EARLY intervention key: - Physical/occupational therapy = CORNERSTONE (graded motor imagery, mirror therapy, desensitization, ROM, strengthening); - Active rather than passive treatments; (3) Pharmacologic: - Gabapentin/pregabalin (first-line neuropathic); - TCA (amitriptyline, nortriptyline); - Bisphosphonate (pamidronate) — modest evidence; - Vitamin C (prevention not treatment); - Calcitonin (limited evidence); - Topical lidocaine, capsaicin; - Avoid chronic opioid (poor efficacy); (4) Interventional: - Sympathetic ganglion block (stellate ganglion UE, lumbar sympathetic LE) — diagnostic + therapeutic; - Continuous nerve catheter; - Spinal cord stimulation (DRG stimulation for focal CRPS — strong evidence); - Intrathecal therapy (refractory); (5) Psychological — CBT, biofeedback, mindfulness (chronic pain coping); high comorbidity depression/anxiety; (6) Ketamine infusion (sub-anesthetic) — controversial but emerging evidence; (7) IVIG, plasmapheresis — research; (8) Prevention — vitamin C 500 mg/day × 50 days after distal radius fracture (some evidence); regional anesthesia; (9) Early treatment (< 1 year) = better outcomes; (10) Patient education + expectation setting; (11) Functional restoration focus rather than pain elimination

---

CRPS: Budapest criteria. PT/OT cornerstone (graded motor imagery, mirror, desensitization). Multimodal pharmacologic + sympathetic blocks + SCS/DRG. CBT. Avoid chronic opioid. Early intervention key.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 35 ปี complex regional pain syndrome (CRPS) Type I — left lower extremity 6 เดือน after ankle sprain
Pain: severe burning, allodynia, autonomic changes (color, temp, sweating), edema, motor dysfunction';

update public.mcq_questions
set choices = '[{"label":"A","text":"Traditional pre-op fasting NPO midnight"},{"label":"B","text":"ERAS (Enhanced Recovery After Surgery) protocol"},{"label":"C","text":"Heavy opioid post-op"},{"label":"D","text":"Delay diet 5 days"},{"label":"E","text":"Mass IV fluid empirical"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** ERAS (Enhanced Recovery After Surgery) protocol: (1) Pre-op: - Education + expectations; - No prolonged fasting (clear fluids until 2h pre-op; light meal 6h); - Carbohydrate loading drink 2h pre-op (reduces insulin resistance); - Avoid bowel prep (most cases); - Anxiolysis without long-acting (avoid premed in elderly — delirium risk); - Skin prep (chlorhexidine); - Antibiotic prophylaxis within 60 min; (2) Intra-op: - Multimodal opioid-sparing analgesia (acetaminophen, NSAID/COX-2, gabapentinoid, ketamine, lidocaine infusion, dexamethasone); - Regional anesthesia (TAP block, ESP block, rectus sheath block, neuraxial selectively); - Goal-directed fluid therapy (avoid over and under); - Normothermia (warming); - Multimodal PONV prophylaxis (Apfel high-risk); - Short-acting anesthetics (propofol TIVA, remifentanil); - Minimize NG, drains, urinary catheters; - Lung-protective ventilation; - Avoid nitrous oxide; (3) Post-op: - Early mobilization (Day 0); - Early oral intake/diet advancement (Day 0-1); - Multimodal opioid-sparing analgesia continuation; - Glycemic control; - DVT prophylaxis; - Early Foley removal; - Discharge criteria objective; - Follow-up; (4) Outcomes — reduced LOS, complications, opioid use, cost, improved patient satisfaction; (5) Multidisciplinary: surgery + anesthesia + nursing + nutrition + PT + patient; (6) Patient buy-in critical; (7) ERAS Society protocols by procedure; (8) Audit + continuous improvement

---

ERAS: shortened fasting + carb load, multimodal opioid-sparing, regional, goal-directed fluid, normothermia, PONV prophylaxis, early mobilization + feeding. Multidisciplinary. Reduces LOS + complications.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 60 ปี — major abdominal surgery, ASA II, pre-op anxiety + history PONV + chronic neck pain on tramadol 50 mg q6h
Plan: ERAS protocol';

update public.mcq_questions
set choices = '[{"label":"A","text":"Add more oral opioid"},{"label":"B","text":"Intractable cancer pain"},{"label":"C","text":"Refuse pain care"},{"label":"D","text":"Discharge no follow-up"},{"label":"E","text":"Surgery as primary treatment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Intractable cancer pain — interventional options: (1) Celiac plexus block/neurolysis — pancreatic + upper abd visceral pain; alcohol or phenol; significant reduction in opioid + pain in pancreatic CA (Wong RCT); ultrasound or fluoroscopy guided; (2) Splanchnic nerve neurolysis — alternative to celiac; (3) Intrathecal pump (IDDS) — for refractory cancer pain; morphine, fentanyl, hydromorphone, ziconotide, bupivacaine, clonidine combinations; significant opioid reduction; quality of life improvement; reduces systemic side effects (nausea, constipation, sedation); (4) Spinal cord stimulation — less common for cancer pain; (5) Hypogastric plexus block — pelvic cancer pain; (6) Ganglion impar block — perineal cancer pain; (7) Vertebroplasty/kyphoplasty — pathologic spine fracture; (8) Multimodal systemic: opioid (rotate if tolerance), NSAID, gabapentinoid, antidepressant, steroid, bisphosphonate (bone mets); (9) Symptom management — nausea (haloperidol, prochlorperazine, ondansetron, scopolamine), constipation (osmotic + stimulant laxatives, methylnaltrexone, naloxegol — peripherally-acting opioid antagonists), sedation; (10) Goals of care + advance directives; palliative care consult; (11) Hospice referral when appropriate; (12) Psychosocial + spiritual support; (13) Family education + support; (14) Modern: integrated palliative + pain medicine + oncology

---

Cancer pain: celiac plexus block (pancreatic CA), intrathecal pump for refractory, multimodal systemic. Symptom Mx (constipation, nausea). Palliative + hospice. Integrated multidisciplinary approach.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วย 70 ปี chronic intractable cancer pain (pancreatic CA) — pain VAS 9/10 despite oral oxycodone 80 mg BID + ER
Limited life expectancy 6 เดือน
Nausea + constipation + sedation from opioids';

update public.mcq_questions
set choices = '[{"label":"A","text":"Use ketamine 2 mg/kg"},{"label":"B","text":"Induction agents"},{"label":"C","text":"Thiopental 10 mg/kg high dose"},{"label":"D","text":"Avoid all induction agents"},{"label":"E","text":"Use volatile only induction"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Induction agents — pharmacology: (1) Propofol — GABA-A agonist; rapid onset (30s) + offset; metabolized hepatic CYP; decreases ICP + CMRO2 + BP; bolus 1.5-2.5 mg/kg; infusion 50-150 mcg/kg/min; side effects: hypotension, pain on injection, PRIS (propofol infusion syndrome — high dose long duration: rhabdo, acidosis, cardiac failure); preferred for neurosurgery; (2) Etomidate — GABA-A agonist; rapid onset (30s); hemodynamically stable (preferred unstable); bolus 0.3 mg/kg; side effects: adrenal suppression (single dose — controversial significance; consider stress steroid in critically ill sepsis), myoclonus, PONV, no analgesia; good for cardiac + shock + TBI; (3) Ketamine — NMDA receptor antagonist; dissociative; bolus 1-2 mg/kg IV or 4 mg/kg IM; bronchodilator, analgesic, sympathomimetic (preserved BP + HR — beneficial in shock); historic concern increased ICP (now controversial — may be OK with controlled ventilation; some advocate use in TBI); emergence reactions (use benzo or propofol); excellent for trauma, shock, asthma, peds; (4) Thiopental — barbiturate; rapid onset; decreases ICP + CMRO2 + BP; rarely used now (limited availability); useful for status epilepticus; (5) Midazolam — benzodiazepine; slower onset; less BP effect than propofol; 0.1-0.3 mg/kg IV; amnesia good; for selected cases; (6) Dexmedetomidine — alpha-2 agonist; sedation without respiratory depression; awake intubation, MAC; loading 1 mcg/kg over 10 min + infusion; bradycardia + hypotension; (7) Selection — patient factors (hemodynamic, neuro, asthma, allergies, dose adjustment renal/hepatic)

---

Induction agents: propofol (rapid, ICP↓), etomidate (CV stable, adrenal suppression), ketamine (NMDA, dissociative, broncho-/sympathomimetic), thiopental (rarely used), midazolam, dexmedetomidine (alpha-2). Select per patient.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Question on pharmacology of induction agents:
Patient with elevated ICP needs RSI for emergent surgery';

update public.mcq_questions
set choices = '[{"label":"A","text":"All NMBs equal"},{"label":"B","text":"Neuromuscular blocker (NMB) pharmacology"},{"label":"C","text":"Sux in all patients regardless"},{"label":"D","text":"No reversal needed"},{"label":"E","text":"Pancuronium first-line"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neuromuscular blocker (NMB) pharmacology: (1) Depolarizing — Succinylcholine: - Mechanism: acetylcholine receptor agonist (depolarization phase 1 → phase 2 with high dose); fast onset (30-60s), short duration (5-10 min) — metabolized by plasma cholinesterase; - Use: RSI; - Side effects: fasciculation, myalgia, K+ rise (0.5-1; AVOID in burns > 24h, denervation, hyperkalemia, severe muscular dystrophy, MH-susceptible), bradycardia (peds especially), increased ICP/IOP/intragastric pressure, masseter spasm, MH trigger; - Pseudocholinesterase deficiency — prolonged paralysis (atypical, heterozygous, homozygous); (2) Non-depolarizing — Rocuronium (preferred): - Aminosteroid, fast onset 60-90s (intubating dose 1.2 mg/kg), duration 30-60 min; minimal CV effects; sugammadex-reversible; (3) Vecuronium — aminosteroid, intermediate duration; sugammadex-reversible; (4) Cisatracurium — benzylisoquinoline; Hofmann elimination (organ-independent — preferred renal/hepatic failure); no histamine release; (5) Atracurium — Hofmann; histamine release; (6) Pancuronium — long-acting; vagolytic (tachycardia); rarely used now; (7) Reversal: - Sugammadex (cyclodextrin) — binds rocuronium/vecuronium; rapid + complete reversal; dose 2 mg/kg (TOF 2) or 4 mg/kg (deep block) or 16 mg/kg (immediate); preferred modern; - Neostigmine — AChE inhibitor; combine with anticholinergic (glycopyrrolate 0.2 mg per 1 mg neostigmine — avoid muscarinic effects bradycardia/secretions/bronchospasm); only when TOF count 2-4 (won''t reverse deep block); ceiling effect; (8) TOF monitoring — quantitative (TOFCuff, AcceleroMyograph) — TOF ratio > 0.9 = adequate reversal; modern standard

---

NMBs: sux (depol, fast/short, K+, MH trigger, contraindications), rocuronium (sugammadex-reversible), cisatracurium (Hofmann), vecuronium. Reversal: sugammadex preferred (rocuronium/vecuronium); neostigmine + glyco (TOF 2-4). Quantitative TOF standard.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Question on neuromuscular blockers + reversal pharmacology';

update public.mcq_questions
set choices = '[{"label":"A","text":"All volatiles identical"},{"label":"B","text":"Volatile anesthetics"},{"label":"C","text":"Highest possible MAC always"},{"label":"D","text":"Use for awake intubation"},{"label":"E","text":"Skip CO2 absorbent"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Volatile anesthetics — pharmacology: (1) MAC (Minimum Alveolar Concentration) — concentration preventing movement in 50% to surgical stimulus; - Sevoflurane 2.0% (lower in elderly; 0.6% age 80); - Isoflurane 1.15%; - Desflurane 6%; - Decreased by: age, hypothermia, opioid, alpha-2 agonist, pregnancy, hyponatremia, ethanol acute; - Increased by: hyperthermia, chronic ethanol, sympathomimetic, hypernatremia; (2) Solubility (blood/gas partition coefficient) — lower = faster onset/offset; desflurane 0.42 (fastest), sevoflurane 0.65, isoflurane 1.4; (3) Effects: - CV: dose-dependent decrease in BP (vasodilation), SVR, contractility; HR variable (desflurane increases at induction transient); QT prolongation; - Respiratory: bronchodilation (sevoflurane best — pediatric induction; desflurane = airway irritant); decreased TV, increased RR, decreased response to CO2/hypoxia; - CNS: increased CBF + ICP (vasodilator) — minimize in neurosurgery; decrease CMRO2; modulate seizure (sevoflurane epileptogenic at high concentration); - Skeletal muscle: relaxation + potentiates NMB; trigger MH (all halogenated); - Metabolism: minimal modern (sevoflurane 5%, isoflurane 0.2%, desflurane 0.02%); compound A from sevoflurane + desiccated CO2 absorbent (theoretical nephrotoxicity — limited clinical); CO production from desflurane + desiccated; (4) Selection: - Sevoflurane: peds induction (sweet, bronchodilator), short cases, neuroanesthesia (limited MAC); - Desflurane: rapid emergence (long cases, obese — fast offset); avoid: induction (irritant); high environmental impact; - Isoflurane: cardiac surgery, neuro, cost-effective; - N2O: adjunct (analgesia, MAC sparing); avoid pneumothorax, bowel obstruction, middle ear, retinal surgery; B12 deficiency

---

Volatile: MAC, solubility (des fastest), CV depression, bronchodilator (sevo > des), increased CBF/ICP, MH trigger. Sevo: peds induction. Des: rapid emergence, irritant induction. Iso: cardiac, neuro. N2O: adjunct + restrictions.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Question on volatile anesthetics pharmacology';

update public.mcq_questions
set choices = '[{"label":"A","text":"All opioids equivalent"},{"label":"B","text":"Opioids"},{"label":"C","text":"Use only morphine universally"},{"label":"D","text":"Naloxone first-line analgesic"},{"label":"E","text":"Avoid all opioids universally"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Opioids — anesthesia pharmacology: (1) Mu-receptor agonist mechanism (analgesia, respiratory depression, sedation, miosis, decreased GI motility, urinary retention, pruritus, tolerance, dependence); (2) Specific agents: - Morphine — IV, IM, oral, neuraxial; onset 5-10 min IV, peak 20 min, duration 3-4h; active metabolite M6G (renal accumulation — avoid CKD); histamine release; intrathecal morphine = prolonged analgesia (up to 24h) for C-section, major surgery; - Fentanyl — synthetic, 100× morphine potency; rapid onset (30-60s IV), short duration (30-60 min single dose) but accumulates context-sensitive half-time; lipophilic; safer renal; transdermal patch (chronic pain); intrathecal/epidural; - Sufentanil — 1000× morphine; intra-op for cardiac; - Alfentanil — short-acting (5-10 min); - Remifentanil — ultra-short (3-5 min); ester linkage metabolized by plasma esterases; infusion 0.05-0.5 mcg/kg/min; no accumulation; rapid recovery; opioid-induced hyperalgesia + acute tolerance; need bridge analgesic before stop; - Hydromorphone — 5-7× morphine; PCA; renal safer than morphine; - Oxycodone — oral; PO common; - Methadone — NMDA antagonist + Mu; long half-life; chronic pain + OUD; QTc prolongation, drug interactions; - Tramadol — weak Mu + SNRI; seizure risk, serotonin syndrome; - Buprenorphine — partial agonist; ceiling for respiratory depression; OUD, chronic pain; (3) Reversal — naloxone (Mu antagonist) 0.04-0.4 mg IV titrated; short half-life (need repeat); precipitate withdrawal; - Naltrexone — oral long-acting (OUD/AUD treatment); (4) Side effect management — multimodal opioid-sparing; PRO laxative; pruritus (nalbuphine, antihistamine); urinary retention; (5) PCA settings — bolus + lockout; basal rare; (6) Modern: opioid epidemic awareness, minimize where possible

---

Opioids: morphine (M6G renal), fentanyl (rapid, lipophilic), remifentanil (esterase, ultra-short), sufentanil, hydromorphone (renal safer), methadone (NMDA + QTc), tramadol (SNRI). Naloxone reversal. Multimodal opioid-sparing.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Question on opioid pharmacology in anesthesia';

update public.mcq_questions
set choices = '[{"label":"A","text":"All locals same"},{"label":"B","text":"Local anesthetics"},{"label":"C","text":"Skip all locals"},{"label":"D","text":"Mass IV bupivacaine"},{"label":"E","text":"Use cocaine routinely"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Local anesthetics — pharmacology: (1) Mechanism — block voltage-gated Na+ channels (intracellular side) → prevents action potential propagation; (2) Structure — lipophilic aromatic + amide/ester linkage + hydrophilic amine; lipid solubility = potency; protein binding = duration; pKa = onset; (3) Classification: - Esters (1 ''i'' in name): procaine, chloroprocaine (very short), tetracaine (long), cocaine; metabolized by plasma cholinesterase; PABA metabolite (allergy more common); - Amides (2 ''i'' in name): lidocaine, bupivacaine, ropivacaine, mepivacaine, prilocaine; metabolized hepatic; (4) Common agents: - Lidocaine — fast onset, intermediate duration; max 4.5 mg/kg (7 mg/kg with epinephrine); IV use OK (LAST risk lower than bupivacaine); ventricular arrhythmia treatment; topical; - Bupivacaine — slow onset, long duration (4-8h); highly protein-bound; CARDIOTOXIC (worse than CNS toxicity ratio); use carefully + max 2 mg/kg (3 with epi); levobupivacaine = S-enantiomer (less cardiotox); - Ropivacaine — long duration; less cardiotoxic than bupivacaine; less motor block (sensory > motor) — useful labor; max 3-4 mg/kg; - Mepivacaine — intermediate duration; - Prilocaine — risk methemoglobinemia (avoid in infants, anemic, G6PD); EMLA component; (5) Adjuncts: - Epinephrine 1:200,000 — vasoconstrictor: prolongs duration, reduces systemic absorption + LAST risk; AVOID end-arteries (digit, penis, ear), peripheral nerve blocks now OK in most; - Bicarbonate — speed onset (raises pH); - Dexamethasone — prolongs block (perineural or IV); - Dexmedetomidine, clonidine — alpha-2 prolong; (6) Toxicity LAST — CNS (perioral numbness → tinnitus → metallic taste → seizure → coma) + CV (hypotension → arrhythmia → arrest); bupivacaine worst CV; treatment — lipid emulsion 20% (1.5 mL/kg bolus + infusion); (7) Allergy — true rare; esters > amides; preservative methylparaben often blamed

---

Locals: Na channel block. Esters (procaine, chloroprocaine, tetracaine; PABA) vs amides (lidocaine, bupivacaine, ropivacaine). Bupivacaine cardiotoxic. Adjuncts: epi, bicarb, dex. LAST: lipid emulsion. Max doses critical.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Question on local anesthetic pharmacology';

update public.mcq_questions
set choices = '[{"label":"A","text":"Ignore + continue"},{"label":"B","text":"MMR (Masseter Muscle Rigidity)"},{"label":"C","text":"Continue surgery + give more sux"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Increase volatile"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** MMR (Masseter Muscle Rigidity) — possible MH precursor: (1) MMR after succinylcholine — common (1%) in peds; significance varies: - Mild + transient (jaw stiff but mouth opens) — usually normal succinylcholine effect; - SEVERE (jaw locked, cannot open) = MH-suggestive in 50%; (2) Management: - If severe MMR with other MH signs (rising EtCO2, tachycardia, rhabdo, acidosis): treat as MH — stop triggers, dantrolene, cooling; - If isolated MMR + no other features: postpone elective surgery, observe in PACU/ICU 24h; monitor for late MH features; check CK, K, urine myoglobin q6h × 24h; counsel future anesthesia; refer for MH testing (in vitro contracture test, genetic); - Urgent surgery: switch to non-triggering anesthetic; (3) MH-trigger-free anesthetic for future + family: avoid volatile + succinylcholine; use TIVA propofol + opioid + non-depolarizing NMB (rocuronium/cisatracurium); change circuit + soda lime; MH machine prep (flushing 10+ min, fresh circuit); (4) Documentation + MedicAlert; (5) Family counseling — autosomal dominant inheritance; (6) MHAUS Hotline 1-800-MH-HYPER for consultation; (7) Definitive diagnosis — caffeine-halothane contracture test (gold standard) or genetic testing (RYR1, CACNA1S — ~80% sensitivity); (8) MH-susceptible = OK for surgery with trigger-free anesthetic; (9) Differential MMR — TMJ pathology, dystonic reaction, myotonic disorder; (10) Modern: Ryanodex (dantrolene faster reconstitution)

---

MMR after sux: mild = normal; severe + other signs = treat as MH. Isolated severe MMR — postpone elective, observe 24h, MH workup. Future trigger-free anesthetic. MHAUS hotline. Genetic + contracture testing.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'OR 35 ปี healthy patient sevoflurane induction + succinylcholine
10 min: jaw rigidity (masseter spasm), HR rising 90 → 130, EtCO2 mild rising 40 → 48, no temp change yet
BP stable';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue case"},{"label":"B","text":"Intra-op anaphylaxis"},{"label":"C","text":"Discharge to PACU"},{"label":"D","text":"More cefazolin"},{"label":"E","text":"Anti-histamine only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Intra-op anaphylaxis — REFRACTORY: (1) Recognition under drape — hypotension + bronchospasm + tachycardia (or bradycardia in severe) often precedes rash; (2) Stop trigger (suspect rocuronium > cefazolin — NMB most common in OR anaphylaxis); call for help; declare emergency; (3) Epinephrine FIRST-LINE — 100-200 mcg IV bolus; repeat every 1-2 min; infusion if refractory (1-10 mcg/min titrated up to 50 mcg/min); intramuscular 0.3-0.5 mg if no IV access; (4) Airway — 100% O2, may need to deepen anesthesia for refractory bronchospasm; consider ECMO if refractory hypoxia; (5) Aggressive fluid resuscitation — 20-30 mL/kg crystalloid bolus; capillary leak + distributive shock; (6) Trendelenburg position to optimize venous return; (7) Refractory hypotension despite epinephrine: - Norepinephrine + vasopressin; - Methylene blue 1-2 mg/kg (NOS inhibitor for vasoplegia); - Glucagon 1-5 mg if on beta-blocker (interferes with epinephrine response); - Consider VA-ECMO for refractory; (8) Secondary medications (after epinephrine): - H1 antihistamine (diphenhydramine 50 mg IV); - H2 antihistamine (ranitidine 50 mg IV or famotidine); - Corticosteroid (hydrocortisone 200 mg IV or methylprednisolone 1-2 mg/kg) — prevents biphasic; (9) Decision continue vs abort surgery — stabilize first; case-by-case; (10) Post-event — tryptase level 30 min - 3h post-event (peak); document trigger; refer for allergy testing 4-6 weeks (skin testing + IgE, BAT — basophil activation test); MedicAlert; (11) ICU observation 24h (biphasic risk 1-20%); (12) Top triggers — NMB (rocuronium, succinylcholine), antibiotics (cefazolin, penicillin, vancomycin), latex, chlorhexidine, contrast, blood; (13) Document for future

---

Refractory anaphylaxis: epinephrine first-line + infusion, fluid bolus 20-30 mL/kg, methylene blue + glucagon (beta-blocker) for refractory, ECMO. Secondary meds: antihistamine + steroid. Tryptase + allergy testing. NMB top trigger.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'OR — patient just received IV cefazolin pre-incision + rocuronium for induction
3 min later: profound hypotension BP 60/30, HR 140, increased airway pressure, no rash visible yet under drape
Unresponsive to phenylephrine bolus';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait + observe"},{"label":"B","text":"LAST (Local Anesthetic Systemic Toxicity) management"},{"label":"C","text":"Calcium gluconate first-line"},{"label":"D","text":"Increased epinephrine dose"},{"label":"E","text":"More LA injection"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** LAST (Local Anesthetic Systemic Toxicity) management — ASRA Checklist 2020: (1) Recognition — CNS symptoms (perioral numbness → tinnitus → metallic taste → confusion → seizure → coma) precede CV (hypotension → arrhythmia → arrest); bupivacaine worst CV toxicity; (2) IMMEDIATE: call for help + LAST checklist + lipid emulsion + airway help; (3) Airway management — 100% O2, hyperventilation (alkalosis improves CV outcome — moves drug off Na channels); intubate if needed; (4) Seizure: - Benzodiazepine preferred (midazolam 2-4 mg, lorazepam 2-4 mg) — minimal CV depression; - Small dose propofol acceptable IF no CV compromise; AVOID propofol if hypotensive (further CV depression); - Avoid additional LA (lidocaine); (5) LIPID EMULSION 20% (Intralipid) — first-line cornerstone for cardiovascular toxicity (also helps CNS): - Bolus 1.5 mL/kg LBW over 1 min (~100 mL adult); - Infusion 0.25 mL/kg/min × 30 min minimum; - Repeat bolus + double infusion if persistent CV collapse; - Maximum 12 mL/kg total; - Mechanism: lipid sink + metabolic + ionotrope effects; (6) Modified ACLS for cardiac arrest: - Chest compressions; - Lipid emulsion priority; - SMALL doses epinephrine (1 mcg/kg = ~70 mcg) — high-dose impairs lipid efficacy; - AVOID: vasopressin (increased mortality), beta-blocker (depress contractility), calcium channel blocker, lidocaine/procainamide; - Cardiopulmonary bypass/ECMO if refractory; (7) PROLONGED RESUSCITATION — survival reported > 1 hour; (8) Post-event monitoring — ICU 4-6h minimum (recurrent CV instability), liver/lipid monitoring; (9) Prevention: - Aspiration test before injection (multiple sites for nerve block); - Slow incremental injection; - Ultrasound guidance peripheral block; - Test dose epinephrine; - Appropriate dose for weight (max bupivacaine 2-3 mg/kg); (10) Bupivacaine 15 mL of 0.5% = 75 mg; >> typical spinal dose (10-15 mg); concern systemic absorption from field block or intravascular component

---

LAST: lipid emulsion 20% cornerstone (1.5 mL/kg bolus + 0.25 mL/kg/min infusion). Benzo for seizure. Modified ACLS — SMALL epi, NO vasopressin/beta-blocker/CCB/LA. Prolonged resus. Prevention: aspirate, US, dose limits.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'OR patient under spinal anesthesia for inguinal hernia + IV sedation
5 min after spinal injection: anxiety, slurred speech, lightheaded, then tonic-clonic seizure
LA used: 0.5% bupivacaine 15 mL + epinephrine for combined spinal + field block by surgeon';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge to ward"},{"label":"B","text":"Postoperative hypothermia + shivering management"},{"label":"C","text":"Cool further"},{"label":"D","text":"Ignore + observe"},{"label":"E","text":"Restraint patient"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Postoperative hypothermia + shivering management: (1) Recognition — core temp < 36°C; mild 35-36, moderate 32-35, severe < 32; (2) Consequences: - Increased cardiac complications (shivering → 5× O2 consumption, MI risk); - Coagulopathy (impaired platelet + enzyme); - Delayed drug metabolism + emergence; - Wound infection (vasoconstriction → tissue hypoxia + impaired neutrophil); - Patient discomfort + length of stay; (3) Active rewarming: - Forced air warmer (Bair Hugger) — most effective; - Warmed IV fluids (37-40°C); - Warm humidified gases; - Room temperature 24-26°C; (4) Shivering treatment: - Meperidine 12.5-25 mg IV (most effective; kappa receptor) — avoid in MAOI, serotonin syndrome risk; - Tramadol; - Clonidine; - Dexmedetomidine; - Magnesium sulfate; - Buspirone; - Ondansetron; (5) Oxygen supplementation — meets increased demand; (6) Monitor — ECG (arrhythmia risk), serial temps q15-30 min; (7) Prevention — intraoperative warming (pre-warming pre-op, intraop forced air, fluid warming, warm room, humidified gases); (8) High-risk patients — elderly, low BMI, long surgery, large fluid/blood, open cavity, regional anesthesia (vasodilation); (9) Severe hypothermia (< 32°C) — aggressive: warmed IV, ETT humidification, bladder/peritoneal lavage, ECMO if cardiac arrest; (10) Goals — target normothermia 36-37°C before transfer to ward; (11) Document

---

Postop hypothermia: active rewarming (Bair Hugger, warm IV), shivering treatment (meperidine first-line), O2 supplementation. Consequences: MI, coagulopathy, infection. Prevention via intraop warming. Target 36-37°C.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 65 ปี post-major abdominal surgery PACU
Shivering, restless, SpO2 95% on 4L NC, BP 145/90, HR 100
Core temp 35.4°C, peripheral cold';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge"},{"label":"B","text":"Opioid-induced respiratory depression"},{"label":"C","text":"More opioid"},{"label":"D","text":"Ignore vital signs"},{"label":"E","text":"Sedative IV bolus"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Opioid-induced respiratory depression — PACU: (1) Recognition — RR < 10, sedation (Pasero opioid-induced sedation scale > 3), SpO2 drop, pinpoint pupils; elderly + comorbid most at risk; (2) Immediate — stimulate, supplemental O2 high-flow, position (jaw thrust, lateral if vomiting risk), call for help; (3) Naloxone — opioid antagonist: - Dose 0.04-0.4 mg IV (start low — titrate to RR without precipitating withdrawal/pain); - Onset 1-2 min, duration 30-90 min (shorter than most opioids — repeat or infusion may be needed); - Mu receptor antagonist; - Side effects: precipitated withdrawal (pain, hypertension, tachycardia, arrhythmia, pulmonary edema rare); - Infusion if long-acting opioid 2/3 effective bolus dose per hour; (4) Airway management — bag mask, intubation if severe; (5) Hold further opioids; reassess pain control; (6) Identify causes: - Cumulative opioid dose; - Combination with sedatives/benzo (synergistic — CDC warning); - Renal/hepatic accumulation (morphine M6G in renal failure); - Patient factors (elderly, OSA, obesity, COPD, opioid-naive); - PCA programming error; (7) Multimodal opioid-sparing — reduce future risk; (8) Continuous monitoring — capnography (EtCO2) detects hypoventilation BEFORE SpO2 drops; modern recommendation for high-risk patients on opioid PCA; (9) ICU/step-down for monitoring after event; (10) Documentation + safety review; (11) Prevention: PCA without basal rate typically, lockout, dose reduction in elderly + renal, multimodal analgesia, opioid-induced sedation scale assessment q1-2h, naloxone available

---

Opioid-induced respiratory depression: naloxone titrated 0.04-0.4 mg IV. Watch for withdrawal/recurrence (short half-life). Capnography monitoring high-risk PCA. Multimodal opioid-sparing prevention.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 75 ปี post-hip surgery PACU
Alert but slow to respond, SpO2 88% on 4L NC, RR 8, pinpoint pupils
Received: morphine 8 mg PCA + previous IV doses';

update public.mcq_questions
set choices = '[{"label":"A","text":"Skip checklist"},{"label":"B","text":"WHO Surgical Safety Checklist"},{"label":"C","text":"Surgeon alone responsible"},{"label":"D","text":"Speak up culture suppressed"},{"label":"E","text":"No documentation needed"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** WHO Surgical Safety Checklist — patient safety: (1) Three phases: - SIGN IN (before induction): patient ID, site, procedure, consent, anesthesia safety check, allergies, difficult airway, blood loss risk; - TIME OUT (before skin incision): all team introduce themselves + role, confirm patient/site/procedure, anticipated critical events surgeon/anesthesia/nurse, antibiotic 60 min, imaging displayed, sterile + equipment OK; - SIGN OUT (before patient leaves OR): procedure recorded, instrument/sponge/needle count, specimen labeled, equipment concerns, key concerns for recovery; (2) Effectiveness — WHO study reduced mortality 40% + complications 36% in low/middle income settings; (3) Implementation success requires: - Team buy-in + leadership; - Customized to local setting; - Continuous training + reinforcement; - Audit + feedback; - Combine with team training (CRM); (4) Joint Commission Universal Protocol: - Pre-procedure verification; - Mark site (surgeon mark + patient awake/aware); - Time out (active confirmation, all team); (5) Crew Resource Management (CRM) — borrowed from aviation; flat hierarchy, speak up culture, closed-loop communication; (6) Just culture — distinguish honest error from reckless behavior; learn from near-miss + adverse event; report without fear; (7) Crisis checklists — emergency manuals (Stanford, Harvard, AOA) — bedside aids for crisis (MH, LAST, anaphylaxis, ACLS, ALS); (8) Quality improvement frameworks — PDSA cycles, root cause analysis; (9) Patient + family engagement; (10) Modern: human factors engineering, simulation training, technology integration (EHR alerts, smart pumps)

---

WHO Surgical Safety Checklist: Sign In + Time Out + Sign Out. Reduces mortality 40%. Joint Commission Universal Protocol. CRM. Just culture. Emergency manuals. Multimodal patient safety.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Question on patient safety in anesthesia practice — preventing wrong-site surgery';

update public.mcq_questions
set choices = '[{"label":"A","text":"Skip consent"},{"label":"B","text":"Informed consent for anesthesia"},{"label":"C","text":"Coerce patient"},{"label":"D","text":"Ignore patient preferences"},{"label":"E","text":"DNR automatically suspended in OR"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Informed consent for anesthesia: (1) Required elements: - Disclosure of nature of anesthesia + procedure; - Risks (common + rare but serious): mortality, MI, stroke, awareness, PONV, dental damage, allergic reaction, nerve injury, PDPH, infection, transfusion-related; - Benefits; - Alternatives (regional vs GA, MAC, no anesthesia); - Patient questions answered; - Voluntary (no coercion); (2) Capacity assessment — ability to: - Understand the information; - Appreciate the implications; - Reason about choices; - Communicate a choice; (3) Surrogate decision-makers if patient lacks capacity: - Healthcare proxy/medical power of attorney; - Court-appointed guardian; - Family hierarchy per state law (spouse, adult child, parent, sibling); - Two-physician consent in emergency without surrogate; (4) Special populations: - Pediatric — parent/guardian consent + child assent (age-appropriate, typically > 7); - Pregnant patient — usually unchanged; emergent procedures; - Cognitively impaired — surrogate + best interest; - Emergency — implied consent if life-threatening + no surrogate available; - Jehovah''s Witness — respect blood refusal even if life-threatening (adult competent); document; advance directive; (5) Documentation — written + verbal discussion; specific risks discussed; alternatives offered; questions answered; patient + witness signature; (6) Refusal of anesthesia/surgery — explore reasons, address concerns, alternatives, document refusal + counseled; (7) Withdrawal of consent — can occur any time before/during procedure if competent; (8) DNR in OR — ASA recommends required reconsideration (not automatic suspension); explicit discussion + documentation; (9) Modern: shared decision-making, patient values, decision aids; (10) Ethical principles: autonomy, beneficence, non-maleficence, justice

---

Informed consent: disclose risks/benefits/alternatives, capacity assessment, surrogate if lacks, special populations, document, withdrawal allowed. DNR in OR = required reconsideration not automatic suspension. Shared decision-making.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Question on anesthesia informed consent + capacity';

update public.mcq_questions
set choices = '[{"label":"A","text":"Fire safety not concern of anesthesiologist"},{"label":"B","text":"OR Fire Safety"},{"label":"C","text":"Use 100% O2 always"},{"label":"D","text":"Skip wet drapes"},{"label":"E","text":"Alcohol prep wet OK"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** OR Fire Safety — Fire Triangle: (1) Three elements (anesthesia owns oxidizer): - Fuel: drapes, gauze, ETT, alcohol prep, hair, GI gas; - Heat/ignition: electrosurgery (Bovie), laser, fiberoptic light source; - Oxidizer: O2, N2O (supports combustion); (2) High-risk procedures (Joint Commission alerts): - Surgery above xiphoid + open O2 source + heat source; - Head/neck/upper airway surgery; - Tonsillectomy/adenoidectomy + cautery; - Tracheostomy with cautery during entry; (3) Anesthesia role — minimize O2 to lowest needed; ideally < 30% FiO2 for high-risk; transition to medical air if open delivery (NC, mask); communicate to team before electrocautery; (4) Surgeon role: - Pause O2 reduction before activating cautery (30s wait); - Use bipolar over monopolar in airway; - Cuffed ETT for tonsillectomy with cautery to prevent O2 leak; - Laser-resistant ETT for laser surgery; - Saline-filled cuff with methylene blue (detect rupture); - Wet drapes/gauze in surgical field; (5) Drape patient with O2-permeable drapes; avoid pooling; (6) Alcohol prep — fully dry before drape + electrocautery; document drying; (7) Airway fire: - STOP all gases (disconnect ventilator); - Remove ETT immediately; - Pour saline into airway + extinguish fire; - Re-intubate after fire extinguished; - Inspect airway for damage (bronchoscopy); - Monitor for thermal injury + edema; - Steroids + observation 24h+; (8) Drape fire: - Stop O2 flow; - Remove burning drape; - Water/saline to extinguish; - Cardex CO2 fire extinguisher; (9) Education + simulation; emergency protocol posted; (10) Modern: laser smoke evacuator (toxic plume), team training, fire drills; (11) Documentation post-event

---

OR fire: triangle (fuel + heat + O2 oxidizer). Anesthesia reduces FiO2 < 30%, pause before cautery. Cuffed ETT for tonsillectomy + cautery. Airway fire: stop gas, remove ETT, saline, re-intubate. Wet drapes. Education + simulation.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Question on operating room fire safety + electrosurgery';

update public.mcq_questions
set choices = '[{"label":"A","text":"Force transfusion"},{"label":"B","text":"Jehovah''s Witness bloodless surgery"},{"label":"C","text":"Refuse surgery"},{"label":"D","text":"Override decision"},{"label":"E","text":"Hide transfusion"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Jehovah''s Witness bloodless surgery — ethical + clinical: (1) Respect patient autonomy — competent adult refusal of transfusion is legally + ethically binding (most jurisdictions); cannot transfuse against will even if life-threatening; (2) Explore patient preferences — what they accept varies (some accept albumin, immune globulin, clotting factors, dialysis, cell saver, normovolemic hemodilution; some refuse all blood-derived products); document explicitly; (3) Advance directive + healthcare proxy review; (4) Pre-op optimization — aggressive: - Iron (PO 3x daily, or IV iron sucrose/iron carboxymaltose if PO failed/intolerant); - Erythropoietin (EPO) — stimulate erythropoiesis; - B12, folate; - Treat underlying cause anemia; - Optimize medical conditions; - Time elective surgery for optimization (target Hb > 13); (5) Intra-op blood conservation: - Cell saver (autologous; most witnesses accept); - Acute normovolemic hemodilution (ANH) — collect autologous blood in continuity with patient (accept if attached); - Antifibrinolytics (TXA 1g IV); - Permissive low BP (within safety); - Bipolar electrocautery, vessel sealer, harmonic; - Minimal blood draw (microsampling); - Topical hemostatics (fibrin glue, gelfoam); - Limit phlebotomy; (6) Anesthetic technique — regional anesthesia (less bleeding), controlled hypotension carefully, position to minimize blood loss; (7) Post-op — minimize blood loss, iron + EPO continued, monitor; (8) Multidisciplinary — anesthesia + surgery + hematology + ethics consult + Jehovah''s Witness Hospital Liaison Committee; (9) Pediatric Jehovah''s Witness — different (parents'' refusal may be overridden for child''s life); court order if needed; (10) Patient Blood Management (PBM) principles apply to ALL patients now — minimize unnecessary transfusion (universal benefit); (11) Document + communicate

---

Jehovah''s Witness: respect autonomy (competent adult). Explore acceptable products. Optimize anemia (iron, EPO). Cell saver, ANH, TXA. Pediatric different (court order possible). PBM universal. Multidisciplinary + ethics.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วย Jehovah''s Witness 45 ปี severe anemia Hb 7.5 — elective major orthopedic surgery
Refuses all blood products including PRC + plasma; will accept albumin + cell saver + recombinant factors
Understands risks including death; competent adult with advance directive';

update public.mcq_questions
set choices = '[{"label":"A","text":"Just operate"},{"label":"B","text":"Capacity + surrogate consent in elderly with dementia"},{"label":"C","text":"Refuse surgery + nothing"},{"label":"D","text":"Skip family input"},{"label":"E","text":"Ignore advance directive concept"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Capacity + surrogate consent in elderly with dementia: (1) Capacity assessment: - Specific to decision (sliding scale — higher stakes = higher capacity threshold); - Four components: understand, appreciate, reason, communicate choice; - Document specific assessment (not just diagnosis); - Re-assess (capacity may fluctuate — sundowning, delirium, medication); (2) Lack of capacity → surrogate decision-maker: - Healthcare proxy / medical POA (formal designation); - Court-appointed guardian; - Family hierarchy per state/jurisdiction law (typically: spouse → adult children → parents → siblings → close friend); - Two-physician consent for emergency without surrogate (life-threatening); - Ethics committee for difficult cases; (3) Substituted judgment standard (preferred) — what would patient choose based on prior values, statements, religious beliefs; (4) Best interest standard (fallback) — what reasonable person would choose; (5) Hip fracture in elderly: - Surgical repair improves mortality + function; mortality 30% at 1 year without surgery; - Pain control, mobilization, dignity; - Goals of care discussion with family + medical team; - Palliative approach if dying or extremely frail; (6) Anesthetic considerations elderly with dementia: - Pre-op delirium screening (Mini-Cog); - Regional anesthesia preferred (spinal — less delirium than GA per some studies; but recent RCT REGAIN showed no difference); - Avoid benzodiazepines, anticholinergics, long-acting opioid (Beers list); - Multimodal analgesia; - Family presence + reorientation; - Quick mobilization; (7) Ethics: - Autonomy respect — what patient would want; - Beneficence — what''s medically beneficial; - Non-maleficence — avoid harm; - Justice; (8) Multidisciplinary — anesthesia + surgery + geriatric medicine + palliative care + ethics consult + social work + family meeting; (9) Document all

---

Elderly + dementia + hip fracture: capacity assessment specific, surrogate hierarchy, substituted judgment > best interest, hip surgery improves outcomes, regional + multimodal anesthesia, delirium prevention, ethics consult, multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วย 80 ปี severe dementia, hip fracture — capacity to consent uncertain
Family wants surgery, patient inconsistent
No advance directive, no formal proxy';

update public.mcq_questions
set choices = '[{"label":"A","text":"Outpatient surgery"},{"label":"B","text":"OSA + obesity perioperative management"},{"label":"C","text":"Heavy benzodiazepine premed"},{"label":"D","text":"Skip CPAP postop"},{"label":"E","text":"Long-acting opioid PCA"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** OSA + obesity perioperative management: (1) STOP-BANG ≥ 3 = high risk OSA; sleep study if not yet diagnosed; (2) Pre-op CPAP optimization 1-3 months pre-op (improves cardiac, BP, glucose); bring own CPAP to hospital; (3) Anesthetic considerations: - Difficult airway anticipated (large neck, redundant tissue, Mallampati high) — video laryngoscope first-pass, ramped (HELP) position, pre-O2 + apneic oxygenation, awake fiberoptic for severe; - Multimodal opioid-sparing analgesia (TAP block, ESP, IV ketamine, acetaminophen, NSAID); - Minimize benzodiazepines (sedation + respiratory depression); - Short-acting agents (propofol TIVA, remifentanil, sugammadex); - Regional anesthesia when possible; (4) Intra-op ventilation — lung-protective, PEEP 8-10, recruitment maneuvers, position semi-recumbent; (5) Post-op CPAP continuous when not eating/drinking; lateral position; (6) Monitoring — continuous SpO2 + capnography overnight; step-down or ICU for severe OSA; AVOID outpatient discharge for severe OSA with major surgery; (7) Bariatric surgery specific — laparoscopic, ERAS, TAP block, multimodal, early mobilization, DVT prophylaxis, glucose control; (8) Opioid considerations — increased sensitivity in OSA + chronic hypoxia; (9) Discharge criteria — adequate respiratory function on room air after typical opioid usage pattern; CPAP at home; (10) Outcomes — OSA patients increased OR cancellation, perioperative complications, ICU admission, death — recognition + optimization critical

---

OSA + obesity: STOP-BANG screen, CPAP optimize, difficult airway prep, opioid-sparing, ramped position, postop CPAP + monitoring. Bariatric ERAS. Avoid outpatient discharge severe OSA major surgery.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 35 ปี OSA severe AHI 45 — elective bariatric sleeve gastrectomy
BMI 48, CPAP non-adherent, HTN, T2DM
Berlin questionnaire + STOP-BANG 7 (high risk)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Force abstinence cold turkey"},{"label":"B","text":"Alcohol use disorder perioperative"},{"label":"C","text":"Ignore drinking history"},{"label":"D","text":"Give glucose first not thiamine"},{"label":"E","text":"Refuse care"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Alcohol use disorder perioperative: (1) Pre-op — abrupt cessation = withdrawal risk (DTs mortality 5-15% untreated); (2) Withdrawal prophylaxis: - CIWA-Ar scoring guide treatment; - Benzodiazepines first-line (chlordiazepoxide, diazepam, lorazepam — lorazepam in hepatic dysfunction); symptom-triggered or scheduled; - Thiamine 100 mg IV/IM BEFORE glucose (Wernicke prevention); folate, multivitamin; - Magnesium replacement; - Phenobarbital alternative; - Dexmedetomidine adjunct (not monotherapy); (3) Anesthetic considerations: - Tolerance to many anesthetics (chronic) — may need higher doses initially; - Acute intoxication = MAC decrease (synergistic); - Hepatic dysfunction — drug metabolism altered; - Increased PONV; cardiomyopathy possible; coagulopathy; nutritional deficiency; - Avoid LR if alcoholic ketoacidosis; - Multimodal pain management — careful with benzodiazepines (already on them for withdrawal); (4) Delay elective surgery if active withdrawal or recent heavy use; (5) Abstinence > 2-4 weeks pre-op ideal for elective; (6) Brief intervention + referral for treatment: - Counseling; - Naltrexone, acamprosate, disulfiram pharmacotherapy; - 12-step programs (AA); - Specialty addiction medicine; (7) Hidden withdrawal post-op — 2-5 days after last drink; suspect in agitation, confusion, autonomic instability; (8) ICU monitoring if severe withdrawal; (9) Documentation + non-stigmatizing approach

---

AUD perioperative: withdrawal prophylaxis (benzo + thiamine BEFORE glucose + Mg). Tolerance + hepatic + nutritional + cardiac considerations. Delay elective if active. Brief intervention + treatment referral. Monitor postop withdrawal.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 65 ปี chronic alcohol use 4 standard drinks/day × 30 ปี — elective surgery in 1 week
No cirrhosis on labs (AST 65, ALT 50, GGT 220)
Last drink today, mild tremor, anxious';

update public.mcq_questions
set choices = '[{"label":"A","text":"Standard C-section"},{"label":"B","text":"Placenta accreta spectrum (PAS) anesthesia"},{"label":"C","text":"Skip preplanning"},{"label":"D","text":"Outpatient C-section"},{"label":"E","text":"Single IV only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Placenta accreta spectrum (PAS) anesthesia: (1) PAS = abnormally adherent placenta (accreta, increreta, percreta); risk factors prior C-section, placenta previa; massive hemorrhage risk (estimated blood loss 2-5 L+); (2) Antenatal diagnosis (US, MRI) — multidisciplinary planning at PAS center; (3) Pre-op MDT planning: - Schedule 34-36 wk (before labor + bleeding); - Cell saver available; - Massive Transfusion Protocol activated; - IR for prophylactic balloon (uterine artery or internal iliac) — controversial; - Urology for bladder involvement (percreta); - Adequate IV access (2-3 large bore + arterial line + CVL); - Type + cross 6-10 units PRBC + matching FFP + platelets; - Cardiac surgery + general surgery available; (4) Anesthetic technique — controversial: - Combined spinal-epidural with epidural extension; OR - General anesthesia from start (safer airway control during massive hemorrhage); - Many centers use neuraxial → convert to GA when significant bleeding/hemodynamic instability; (5) Airway considerations — obstetric difficult airway expected; full RSI; video laryngoscopy first-line; (6) Intra-op management — TXA early (1g), warm fluids, normothermia, calcium, vasopressors, inotropes; TEG/ROTEM-guided; (7) Hysterectomy planned (vs conservative leave-in-place approaches); (8) Post-op ICU; ongoing transfusion + monitoring; DIC, AKI, ARDS risk; (9) Maternal mortality reduced significantly with PAS center care + MDT vs ad hoc; (10) Neonatology team for prematurity; (11) Modern: PAS centers of excellence, MDT essential, antifibrinolytic, REBOA in select centers

---

PAS: MDT planning at PAS center, schedule 34-36 wk, cell saver, MTP, IR balloon, neuraxial or GA, TXA early, TEG-guided. ICU postop. PAS center reduces mortality.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 28 ปี G2P1 GA 32 wk severe placenta accreta spectrum diagnosed antenatally
Planned C-section + hysterectomy at 34-36 wk
MDT — anesthesia, OB, urology, IR, transfusion service';

update public.mcq_questions
set choices = '[{"label":"A","text":"GA + ETT routine"},{"label":"B","text":"Pediatric inguinal hernia anesthesia + caudal block"},{"label":"C","text":"Heavy opioid"},{"label":"D","text":"Adult-dose ketorolac"},{"label":"E","text":"No analgesia"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric inguinal hernia anesthesia + caudal block: (1) Anesthetic technique options: - GA with LMA or ETT + multimodal analgesia + regional; - Spinal anesthesia in infants (formerly preferred, less common now); - Awake spinal in former premies < 60 weeks PCA (apnea risk reduction); (2) GA induction — sevoflurane mask induction common in this age; IV after; (3) LMA appropriate for non-laparoscopic short cases; cuffed ETT alternative; (4) Caudal block — gold standard for sub-umbilical surgery analgesia in peds: - Position lateral; - Identify sacral hiatus (sacral cornua); - 22G needle ''pop'' through sacrococcygeal membrane; - LA: bupivacaine 0.25% 1 mL/kg (or ropivacaine 0.2% 1 mL/kg); max 2 mg/kg; - Adjuncts: clonidine 1-2 mcg/kg, dexamethasone, dexmedetomidine; - Duration 4-8h; - Ultrasound guidance increases success; (5) Multimodal — acetaminophen 15 mg/kg, ibuprofen 10 mg/kg; (6) Post-op — typically discharge same day; family education; (7) Premature/former-preterm < 60 weeks PCA — APNEA RISK postop GA — admit + apnea monitor 12-24h; (8) Avoid local anesthetic toxicity — calculate weight-based max dose carefully (lower margin in infants); (9) Family-centered care — parent presence at induction (controversial — some advocate, some say child life specialists/premed better); (10) Modern: regional anesthesia + multimodal + minimal opioid (peds opioid concerns less but same principles); SPA + APAGBI guidelines emphasize regional in peds

---

Peds inguinal hernia: caudal block gold standard + GA + multimodal. Bupivacaine 0.25% 1 mL/kg + adjuncts. Calculate max LA dose. Premature former < 60 weeks PCA = postop apnea monitor.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยทารก 8 เดือน 8 kg — elective inguinal herniorrhaphy
No comorbidities, parents anxious, healthy term birth
NPO appropriate for age';

update public.mcq_questions
set choices = '[{"label":"A","text":"GA only no epidural"},{"label":"B","text":"Thoracic surgery comprehensive anesthesia"},{"label":"C","text":"Mass crystalloid"},{"label":"D","text":"Long-acting opioid PCA only"},{"label":"E","text":"Skip pulmonary toilet"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Thoracic surgery comprehensive anesthesia: (1) Thoracic epidural T6-T8 = gold standard for thoracotomy analgesia: - Catheter pre-induction (awake) with patient cooperation; - Test dose; loading bupivacaine 0.125-0.25% + fentanyl + epinephrine; - Continuous infusion intra-op + post-op; - Excellent analgesia + opioid sparing + reduced pulmonary complications + chronic post-thoracotomy pain prevention; - Hypotension common — manage with phenylephrine + fluid; (2) Alternatives if epidural contraindicated/failed — paravertebral block, erector spinae plane block (ESP — emerging strong evidence), serratus plane block, intercostal blocks, intrathecal morphine; (3) One-lung ventilation strategy (covered separately) — DLT + lung-protective TV 4-6 mL/kg + PEEP; (4) Fluid management — restrictive (post-pneumonectomy pulmonary edema; ESM concept of fluid management); use vasopressor for BP support rather than fluid; (5) Goal-directed hemodynamic monitoring — arterial line, +/- TEE; cardiac output monitoring (esophageal Doppler, pulse contour); (6) Lung-protective ventilation; (7) Extubate in OR or early (avoid prolonged ventilation if possible); (8) ICU/HDU post-op; (9) Pain — continue epidural 3-5 days; convert to oral when tolerated; multimodal (acetaminophen, gabapentinoid, NSAID); (10) Pulmonary toilet — incentive spirometry, mobilization, PT, bronchodilator; (11) DVT prophylaxis — mechanical + LMWH timed with epidural removal per ASRA; (12) ERAS thoracic — multimodal, opioid-sparing, mobilization, fluid restriction

---

Thoracic surgery: epidural T6-T8 gold standard (alternatives ESP, PVB), OLV with lung-protective, restrictive fluids, goal-directed monitoring, early extubation, ERAS thoracic, multimodal analgesia.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 60 ปี non-cardiac thoracic surgery (esophagectomy) ASA III, COPD, smoker
Plan: thoracic epidural T7-T8 + GA, one-lung ventilation';

update public.mcq_questions
set choices = '[{"label":"A","text":"Cancel + wait postpartum"},{"label":"B","text":"Non-obstetric surgery in pregnancy"},{"label":"C","text":"GA without airway precautions"},{"label":"D","text":"Supine position no tilt"},{"label":"E","text":"Skip FHR check"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Non-obstetric surgery in pregnancy: (1) Indications — emergent (appendicitis, cholecystitis, trauma, ovarian torsion); delay elective surgery until postpartum; second trimester safest if must operate; (2) Pregnancy physiology adjustments: - Cardiovascular: increased CO 40%, decreased SVR, supine hypotensive syndrome (IVC compression > 20 wk — left lateral tilt); aortocaval compression; - Pulmonary: decreased FRC 20%, increased O2 consumption 20-30% — rapid desaturation; - GI: delayed gastric emptying + reduced LES tone — aspiration risk (full stomach assumption > 18-20 wk); - Hematologic: hypercoagulable, anemia of pregnancy; - Renal: increased GFR; - Difficult airway 8-10×; (3) Anesthetic technique: - Regional preferred when possible (spinal, epidural, peripheral nerve block) — avoids fetal drug exposure + airway risk; - GA if needed — RSI with cricoid + video laryngoscopy + difficult airway preparation; modify drug doses (decreased MAC, increased sensitivity); (4) Avoid teratogens — most modern anesthetics safe in pregnancy (no animal teratogenicity sufficient to cause concern); avoid N2O in early pregnancy (theoretical concern); (5) Fetal monitoring — FHR before and after; intra-op if > viability (typically > 24 wk) by OB consultation; preterm labor monitoring; (6) Tocolysis — prophylactic not routine; treat preterm labor if occurs; (7) DVT prophylaxis — VTE risk increased in pregnancy + surgery; mechanical + pharmacologic; (8) Maternal goals: maintain MAP, FiO2, normocarbia, perfusion; left lateral tilt > 20 wk; (9) Multidisciplinary — anesthesia + surgery + OB + neonatology; (10) Avoid radiation if possible; lead apron; (11) Post-op pain — multimodal opioid-sparing; acetaminophen safe; NSAID 3rd trimester avoid (ductus closure); breastfeeding considerations

---

Non-OB surgery in pregnancy: 2nd trimester safest, regional preferred, RSI for GA, left lateral tilt > 20 wk, modern anesthetics safe, FHR monitor, multidisciplinary. Avoid NSAID 3rd trimester.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 25 ปี G1P0 GA 26 wk emergency appendectomy
Fetal viability + healthy mom otherwise
NPO 12h, normal labs';

update public.mcq_questions
set choices = '[{"label":"A","text":"Ignore EtCO2"},{"label":"B","text":"Capnography + ventilation"},{"label":"C","text":"Capnography optional"},{"label":"D","text":"Auscultation alone for intubation"},{"label":"E","text":"Skip during MAC"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Capnography + ventilation: (1) EtCO2 normal 35-45 mmHg (typically 2-5 below PaCO2); reflects ventilation + perfusion + metabolism; (2) Capnogram phases: - Phase I (inspiratory baseline 0); - Phase II (expiratory upstroke); - Phase III (alveolar plateau); - Phase IV (rapid downstroke at inspiration); (3) Normal waveform = rectangular; (4) Abnormal patterns: - Shark-fin (sloping plateau) = bronchospasm/COPD; - Curare cleft (notch) = inadequate paralysis recovery; - Cardiogenic oscillations = cardiac pulsations; - Sudden drop = circuit disconnect, esophageal intubation, cardiac arrest, PE, severe hypotension; - Gradual rise = hypoventilation, increased CO2 production (fever, MH, sepsis, hyperthyroidism); - Gradual decline = hyperventilation, decreased CO2 production (hypothermia, low CO); - Phase I above baseline = rebreathing (exhausted CO2 absorber); - Biphasic plateau = single lung intubation or asymmetric lung disease; (5) Confirming intubation — gold standard (5+ good waveforms); (6) Detecting esophageal intubation immediately; (7) ROSC during CPR — EtCO2 rises rapidly; (8) Quality CPR — EtCO2 > 10-20 mmHg target; (9) MH — early sign rising EtCO2 despite increased ventilation; (10) PE — EtCO2 acute drop with hemodynamic instability; (11) Procedural sedation safety — capnography mandatory for moderate/deep sedation per ASA monitoring standards; detects apnea before SpO2 drops

---

Capnography: gold standard intubation confirm, ventilation + perfusion + metabolism. Patterns: shark-fin (bronchospasm), curare cleft (NMB), sudden drop (disconnect/arrest), rising (MH). Mandatory all anesthesia incl MAC.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Basic science: ventilation parameters + capnography interpretation';

update public.mcq_questions
set choices = '[{"label":"A","text":"Normal"},{"label":"B","text":"Mixed respiratory acidosis + mild metabolic acidosis"},{"label":"C","text":"Pure metabolic alkalosis"},{"label":"D","text":"No intervention needed"},{"label":"E","text":"Decrease ventilation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mixed respiratory acidosis + mild metabolic acidosis: (1) Approach: - pH 7.20 = acidosis; - PaCO2 60 = respiratory acidosis (expected pH change ~0.08/10 mmHg PaCO2 change; expected pH ~7.40 - 0.16 = 7.24 for pure acute respiratory acidosis); - HCO3 22, BE -4 = mild metabolic component; - Anion gap calculation important; (2) Respiratory acidosis causes: - Hypoventilation (sedation, opioid, NMB residual, central depression); - Increased CO2 production (MH, sepsis, hyperthermia, exhausted soda lime); - Increased dead space (PE, ARDS); - Equipment: circuit disconnect, kinked tube, mucus plug, bronchospasm; (3) Anion gap (Na - Cl - HCO3, normal 8-12) — calculate to identify added acid: - Increased AG: ketoacidosis (DKA, alcohol, starvation), lactic acidosis (sepsis, shock, ischemia), renal failure, toxins (methanol, ethylene glycol, salicylate), large volume saline (hyperchloremic); - Normal AG: GI loss (diarrhea), renal tubular acidosis; (4) Lactic acidosis intra-op causes: - Inadequate perfusion (shock); - Tourniquet release; - Catecholamine excess; - Liver dysfunction; - MH; - Metformin (AKI); (5) Treatment: - Treat underlying cause; - Increase minute ventilation (RR or TV) for respiratory acidosis (PaCO2 down ~5 mmHg per 1 L/min MV increase); - Bicarbonate selectively (pH < 7.0-7.10 + correctible cause); - Restore perfusion; (6) Permissive hypercapnia OK if pH > 7.20 in ARDS / asthma; (7) Stewart approach — strong ion difference (SID), weak acids, PCO2; useful complex cases

---

Mixed respiratory + metabolic acidosis: increase minute ventilation, identify cause (hypoventilation, MH, sepsis, perfusion), calculate AG, treat underlying. Bicarb selective. Permissive hypercapnia OK if pH > 7.20.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Basic science: acid-base interpretation + anesthesia implications
ABG: pH 7.20, PaCO2 60, HCO3 22, Base excess -4
On mechanical ventilation';

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

update public.mcq_questions
set choices = '[{"label":"A","text":"Transfuse PRBC only"},{"label":"B","text":"TEG/ROTEM interpretation + transfusion"},{"label":"C","text":"Skip TEG"},{"label":"D","text":"Routine FFP for all"},{"label":"E","text":"Refuse transfusion"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** TEG/ROTEM interpretation + transfusion: (1) TEG parameters: - R time (reaction) — time to clot initiation; prolonged = factor deficiency → FFP; - K time + Alpha angle — clot formation rate; abnormal = fibrinogen → cryoprecipitate or fibrinogen concentrate; - MA (Maximum Amplitude) — clot strength = platelets + fibrin; decreased = platelet dysfunction → platelet transfusion; - LY30 — fibrinolysis at 30 min; > 3% = hyperfibrinolysis → TXA; (2) ROTEM equivalents: - EXTEM (extrinsic), INTEM (intrinsic), FIBTEM (fibrinogen contribution), APTEM (TXA effect), HEPTEM (heparin effect); (3) Component therapy: - PRBC for anemia (target Hb > 7 in stable; > 9-10 in active bleeding or specific conditions; restrictive better — TRICC); - FFP for factor deficiency (15-20 mL/kg); INR > 1.5-1.7 active bleeding or pre-procedure; - Platelets for < 50k bleeding, < 100k CNS/eye surgery; - Cryoprecipitate (factor VIII, fibrinogen, vWF, factor XIII) for fibrinogen < 1.5-2 g/L; - Fibrinogen concentrate alternative; - Prothrombin complex concentrate (PCC) — warfarin reversal, factor deficiency; - Recombinant factor VIIa (NovoSeven) — refractory; expensive; (4) Massive transfusion 1:1:1 (PRC:FFP:Plt) per PROPPR; (5) Citrate toxicity — chelates calcium; replace 1g CaCl2 q4 units; (6) Hyperkalemia from old PRBC; (7) TRALI (transfusion-related acute lung injury) — within 6h, pulmonary edema, hypoxia; (8) TACO (transfusion-associated circulatory overload); (9) Patient Blood Management — minimize transfusion universally, point-of-care testing

---

TEG: R (factor → FFP), K/alpha (fibrinogen → cryo), MA (platelet → plt), LY30 (TXA). Component therapy guided. Massive 1:1:1. Ca replacement. TRALI/TACO awareness. PBM modern.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Basic science: hemostasis + transfusion therapy
Patient bleeding intraop, TEG shows decreased MA + prolonged R time';

update public.mcq_questions
set choices = '[{"label":"A","text":"Single agent only"},{"label":"B","text":"Antiemetic pharmacology"},{"label":"C","text":"All ineffective"},{"label":"D","text":"Avoid all"},{"label":"E","text":"Sedate heavily"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Antiemetic pharmacology: (1) Receptor-based — multiple receptors involved in nausea (D2, 5-HT3, NK1, H1, M1, GABA, CB1): (2) 5-HT3 antagonists — ondansetron (4-8 mg IV, dosed once for PONV), granisetron, palonosetron (long-acting), tropisetron; QTc prolongation; common first-line; (3) D2 antagonists — droperidol (0.625-1.25 mg IV, QTc warning), haloperidol (1-2 mg IV, off-label), metoclopramide (10 mg IV, EPS); prochlorperazine; (4) NK1 antagonists — aprepitant (oral) + fosaprepitant (IV); long-acting (48h); good for major surgery + chemo; (5) Corticosteroids — dexamethasone (4-8 mg IV pre-induction); mechanism unclear; effective; antiemetic + antiinflammatory + analgesic + airway swelling reduction; concerns hyperglycemia + infection (minimal at single dose); (6) Anticholinergic — scopolamine patch (apply > 2h pre-op, lasts 72h); avoid in elderly (delirium), glaucoma; (7) Antihistamine — diphenhydramine 25-50 mg; promethazine 12.5-25 mg; sedation; (8) Phenothiazine — promethazine; sedation; (9) Cannabinoid — nabilone, dronabinol; chemo; (10) Acupressure P6 (Neiguan); (11) Strategy: - Apfel risk score; - Multimodal prophylaxis (different mechanisms); - Rescue with different class than prophylaxis; (12) PONV groups — pediatric, OB, obese, opioid, certain surgeries; (13) Recent: olanzapine, mirtazapine; (14) Modern: enhanced recovery routine multimodal PONV prophylaxis

---

Antiemetic receptors: 5-HT3 (ondansetron), D2 (droperidol, metoclopramide), NK1 (aprepitant), steroid (dex), anticholinergic (scopolamine), antihistamine. Multimodal prophylaxis Apfel-stratified. Different class rescue.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Basic science: pharmacology of antiemetics + receptors';

update public.mcq_questions
set choices = '[{"label":"A","text":"Skip monitoring"},{"label":"B","text":"ASA Standards for Basic Anesthetic Monitoring"},{"label":"C","text":"BP every hour"},{"label":"D","text":"No documentation"},{"label":"E","text":"EtCO2 optional"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** ASA Standards for Basic Anesthetic Monitoring: (1) Qualified anesthesia personnel present continuously; (2) Oxygenation: - Inspired gas O2 analyzer with low alarm; - Pulse oximetry continuous; (3) Ventilation: - Capnography (EtCO2) for all anesthetized patients with airway device; mandatory for moderate/deep sedation; - Quantitative monitoring of ventilation (TV, RR, peak airway pressure); - Disconnect alarm; (4) Circulation: - ECG continuous; - BP + HR every 5 minutes minimum (more frequent if unstable); - Circulatory function continuous (palpation, auscultation, art line, plethysmograph); (5) Body temperature: - Continuous when clinically significant changes anticipated; (6) Neuromuscular monitoring: - Quantitative TOF when NMB used (recent update — ASA 2023); (7) Documentation: - Complete anesthetic record; - Vital signs every 5 min minimum; - Critical events; (8) Standards apply for general anesthesia, regional anesthesia, MAC; (9) Additional monitoring as indicated: arterial line, CVL, PA catheter, TEE, BIS, cerebral oximetry, urine output; (10) Equipment: - Anesthesia machine check before use; - Backup equipment available; (11) Recovery: - Continued monitoring + qualified personnel in PACU; - Discharge criteria; (12) Crew Resource Management + safety culture

---

ASA Standards: continuous qualified personnel, O2 analyzer + pulse ox, capnography + ventilation, ECG + BP q5min, temperature, quantitative TOF (modern). PACU monitoring. Documentation. Equipment check.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Basic science: monitoring standards + standards of care';

update public.mcq_questions
set choices = '[{"label":"A","text":"Skip verification"},{"label":"B","text":"Medication errors in anesthesia"},{"label":"C","text":"Use unlabeled syringe"},{"label":"D","text":"Ignore errors"},{"label":"E","text":"Hide errors"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Medication errors in anesthesia: (1) Common errors: - Syringe swap (wrong drug); - Wrong dose (calculation, pump programming); - Wrong route; - Wrong patient; - Drug omission; - Look-alike sound-alike (LASA) — bupivacaine vs lidocaine, midazolam vs metoclopramide; (2) High-alert medications — concentrated electrolytes (KCl), insulin, anticoagulants, opioids, neuromuscular blockers; (3) Risk factors — fatigue, distraction, urgency, look-alike, similar containers; (4) Prevention strategies: - Standardized drug concentrations (institutional + national); - Pre-printed syringe labels (color-coded by class — ASTM); - Drug-specific safety features; - Smart pumps (drug library, dose limits); - Barcode medication administration; - Read-back verification with another provider; - Avoid concentrate at bedside; - Tall man lettering; - Storage separation; - Time-out for medication; (5) Specific examples: - Use vasopressin from labeled syringe not unlabeled bolus; - Reverse — confirm sugammadex vs neostigmine; - Heparin flush vs bolus; - Inadvertent epidural IV; (6) Reporting + analysis: - Anonymous reporting culture; - Root cause analysis; - Quality improvement; - Anesthesia Quality Institute (AQI); (7) Education + simulation; (8) Modern: AI-assisted decision support, smart pumps, EHR integration, near-miss reporting, simulation training

---

Med errors: syringe swap, dose, route, LASA. Prevention: standardized concentration, labels, smart pumps, barcoded, read-back, separation. Just culture reporting. High-alert meds.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'EMS/Management: medication errors in anesthesia + prevention';

update public.mcq_questions
set choices = '[{"label":"A","text":"Skip handoff"},{"label":"B","text":"Anesthesia handoff communication"},{"label":"C","text":"Hide info"},{"label":"D","text":"One-way only"},{"label":"E","text":"No documentation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Anesthesia handoff communication: (1) Common handoffs: - OR to PACU; - PACU to ward; - OR to ICU; - Anesthesia provider change intra-op; - Shift change; (2) Risks of poor handoff: - Information loss; - Error; - Adverse events; - Delay care; - Major contributor sentinel events (Joint Commission); (3) Structured handoff tools: - SBAR (Situation, Background, Assessment, Recommendation); - I-PASS (Illness severity, Patient summary, Action list, Situation awareness, Synthesis by receiver); - PACU handoff checklist; (4) Essential elements: - Patient identification; - Surgical procedure + position; - Anesthetic technique + complications; - Hemodynamic intra-op course; - Fluid + transfusion; - Pain management + medications given; - Anticipated post-op concerns; - Disposition + special needs; - Lines + drains + tubes; - Allergies; - DNR status; - Family communication needs; (5) Quality elements: - Quiet environment minimizing distractions; - Read-back confirmation; - Opportunity for questions; - Visual aids (anesthesia record); - Both providers physically present; (6) ICU handoff specific: - Higher complexity; - Multidisciplinary inclusion; - Ventilator settings + plan; - Sedation plan; - Goals of care; - Family communication; (7) Intra-op handoff: - Avoid if possible (continuity); - If needed: thorough, in OR, brief surgery; - Document handoff; (8) Quality improvement: - Audit; - Standardized templates; - Training; - Simulation; (9) Cognitive aids; (10) Modern: EHR templates, digital tools, structured curriculum

---

Handoff: SBAR/I-PASS structured tools. Essential elements: patient, procedure, course, fluids, pain, plan. Quiet environment + read-back. Sentinel event contributor. ICU + intra-op specific. Modern: EHR templates.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'EMS/Management: handoff communication in anesthesia';

update public.mcq_questions
set choices = '[{"label":"A","text":"Skip simulation"},{"label":"B","text":"Simulation + Crisis Resource Management (CRM)"},{"label":"C","text":"Real patients only"},{"label":"D","text":"Avoid teamwork training"},{"label":"E","text":"No debriefing"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Simulation + Crisis Resource Management (CRM): (1) Simulation in anesthesia education: - Mannequin-based (high-fidelity simulator); - Standardized patients; - Procedural trainers; - Virtual reality; - Screen-based; (2) Benefits: - Practice rare events (MH, anaphylaxis, LAST); - Skills without patient risk; - Team training; - Communication; - Debriefing critical for learning; (3) CRM principles (adapted from aviation): - Situational awareness; - Decision-making; - Communication (closed-loop); - Teamwork; - Leadership + followership; - Resource utilization (people, equipment, time); - Workload distribution; - Re-evaluation + adaptation; - Calling for help early; (4) Effective debriefing: - Safe environment; - Reflective practice; - Plus/delta or 3D model; - Trained debriefer; - Behavior-based feedback; (5) Crisis manuals + cognitive aids: - Stanford Emergency Manual; - APSF resources; - LAST checklist (ASRA); - MH protocol (MHAUS); - Bedside availability; (6) Application: - MOC/CMP requirements; - Department training; - Just-in-time refresher; - Inter-professional team training; (7) Specific scenarios for training: - Failed intubation/CICO; - MH; - Anaphylaxis; - LAST; - Massive transfusion; - Pediatric emergencies; - Cardiac arrest in OR; (8) Quality improvement framework; (9) Research outcomes — improved performance, retention, team dynamics; (10) Modern: in-situ simulation, virtual reality, AI-enhanced training

---

Simulation + CRM: practice rare events safely, team training, communication, cognitive aids. Effective debriefing key. Stanford manual + MH/LAST checklists. MOC requirements. Modern: VR + in-situ.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Integrative: simulation training + crisis resource management';

update public.mcq_questions
set choices = '[{"label":"A","text":"Ignore burnout"},{"label":"B","text":"Anesthesiologist wellness + burnout"},{"label":"C","text":"Work more hours"},{"label":"D","text":"Punish substance use"},{"label":"E","text":"Hide problems"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Anesthesiologist wellness + burnout: (1) Burnout prevalence — 40-50%+ in anesthesia; higher in residents, trainees; (2) Components (Maslach): - Emotional exhaustion; - Depersonalization/cynicism; - Reduced personal accomplishment; (3) Consequences: - Personal — depression, substance abuse, suicide (anesthesiologists higher risk vs general physician), divorce, physical illness; - Professional — medical errors, decreased patient satisfaction, career change, early retirement; - Workplace — turnover, recruitment difficulty; (4) Substance use disorder — anesthesia higher risk: access to drugs (fentanyl, propofol, NMB), stress, denial; mortality high; treatment + monitored re-entry possible; (5) Risk factors burnout: - Workload + hours; - Loss of autonomy; - EHR burden; - Difficult cases + outcomes; - Family/life conflict; - Personality (perfectionism); - Trainee status; (6) Interventions: - Individual: self-care, exercise, sleep, nutrition, mindfulness, meditation, hobbies, relationships, professional help; - Organizational: appropriate staffing, support, mentorship, EHR optimization, mental health resources, peer support, leadership culture, wellness programs; (7) Second victim phenomenon — provider distress after adverse events; need support; (8) Suicide prevention — confidential help (PHP, Lifeline 988); reduce stigma; (9) Substance use program: Physician Health Program (PHP); confidential evaluation + monitoring; (10) Joy in work + meaning — engagement vs burnout opposite; (11) Modern: ASA Committee on Physician Wellness; APSF clinician well-being; healthcare systems addressing burnout; (12) Confidential resources: 24/7 helplines, mental health, EAP

---

Burnout 40-50% anesthesia. Components: exhaustion, depersonalization, reduced accomplishment. Substance use higher risk. Interventions: individual + organizational. Second victim support. PHP confidential help. Joy in work.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Integrative: wellness + burnout in anesthesia practitioners';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge"},{"label":"B","text":"Post-thyroidectomy airway complications"},{"label":"C","text":"Wait silently"},{"label":"D","text":"Refuse intubation"},{"label":"E","text":"Sedate heavily"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-thyroidectomy airway complications: (1) DDx: - Bilateral RLN injury (rare, devastating) — adducted vocal cords; - Unilateral RLN injury (hoarseness, weak voice); - Laryngospasm (recurrent stridor); - Hematoma compressing airway (covered separately); - Laryngeal edema; - Hypocalcemia (rare immediate, days later); - Tracheomalacia (after large goiter removal); (2) Bilateral RLN injury — both vocal cords paralyzed in median (adducted) position → severe obstruction + stridor; emergent re-intubation + tracheostomy; (3) Unilateral RLN — hoarseness, aspiration risk, no airway emergency; treatment: voice therapy, augmentation; (4) Recognition: - Laryngoscopy/fiberoptic exam to identify; - Differentiate paralysis (cord position fixed) from laryngospasm (treatable); (5) Immediate management: - 100% O2 + jaw thrust + CPAP; - Re-intubation if obstruction worsening; - May need tracheostomy if persistent bilateral RLN; - Steroids (controversial); - Heliox temporary; (6) Prevention: - Intraoperative nerve monitoring (IONM) for RLN — standard in many centers; reduces injury rate; - Careful dissection technique; - Identify nerves intra-op; (7) Hypocalcemia from parathyroid injury — days later, tetany, hyperreflexia, Chvostek/Trousseau, prolonged QTc, laryngospasm; check Ca + PTH; treat with Ca gluconate + calcitriol; (8) Tracheomalacia — large goiter, weakened tracheal rings; may require tracheostomy; recognize at extubation; (9) Multidisciplinary: anesthesia + ENT + endocrine surgery; (10) Post-op: bilateral RLN paralysis may improve over weeks-months; consider extubation trial in PACU then re-evaluate

---

Post-thyroidectomy airway: bilateral RLN (emergent — re-intubate/trach), unilateral (hoarseness), laryngospasm, hematoma, hypocalcemia, tracheomalacia. IONM prevention. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 30 ปี healthy GA + thyroidectomy
During emergence + extubation, sudden inspiratory stridor + difficulty breathing, hoarse voice, no neck swelling
Differential bilateral recurrent laryngeal nerve injury vs laryngospasm vs hematoma';

update public.mcq_questions
set choices = '[{"label":"A","text":"Aggressive fluid"},{"label":"B","text":"Liver resection anesthesia"},{"label":"C","text":"Avoid CVL"},{"label":"D","text":"Long-acting opioid"},{"label":"E","text":"High volatile"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Liver resection anesthesia: (1) Goals: - Minimize blood loss (often massive); - Maintain hepatic perfusion; - Avoid hepatotoxicity; - Pain control; (2) Low CVP technique — keep CVP < 5 cmH2O during dissection: - Reduces hepatic venous pressure + bleeding from cut surface; - Achieved by: restrict fluid, position (Trendelenburg avoid; head-up), low TV, diuretic, nitroglycerin, vasopressor for BP; (3) Risks low CVP: - Air embolism (open hepatic veins + low pressure); - Hypoperfusion + AKI; - Hypotension; - Cerebral hypoperfusion; (4) Pringle maneuver — clamp portal triad (hepatic artery + portal vein); reduces inflow bleeding; ischemia-reperfusion risk; usually < 60-90 min total; (5) Drug choices: - Avoid hepatotoxic; - Cisatracurium (Hofmann elimination, organ-independent); - Remifentanil (esterase elimination); - Propofol OK; sevoflurane OK; - Avoid halothane (rarely available); - Caution opioid + benzodiazepine (altered metabolism); (6) Cell saver + autologous transfusion; (7) Coagulation: - Hepatic disease + extensive resection — coagulopathy expected; - TEG-guided; - TXA controversial in liver surgery (theoretical thrombosis); (8) Monitoring: - Arterial line; - CVL (low CVP measurement, vasopressor); - Cardiac output (esophageal Doppler, pulse contour); - Urine output; - Glucose; - Lactate; (9) Pain — thoracic epidural (controversial in liver — coagulopathy risk if liver dysfunction); alternative: ESP block, intrathecal morphine, multimodal; (10) Post-op: - ICU/HDU; - Liver function monitoring; - Coagulation; - Pain; - Bile leak; - PV thrombosis; (11) ERAS liver surgery: minimize fluid, regional, mobilization

---

Liver resection: low CVP < 5 (reduces bleeding), Pringle maneuver, cisatracurium, cell saver, TEG-guided, monitor cardiac output. Thoracic epidural debate. Post-op ICU. ERAS protocol.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 50 ปี — elective major liver resection
Child-Pugh A, MELD 8, normal coagulation
Plan: low CVP technique, GA';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait + observe"},{"label":"B","text":"Category III fetal tracing"},{"label":"C","text":"Heavy fluid only"},{"label":"D","text":"Sedation heavily"},{"label":"E","text":"Refuse"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Category III fetal tracing — non-reassuring fetal status: (1) Recognition — Category III (NICHD): absent baseline variability + recurrent late/variable decelerations OR bradycardia OR sinusoidal pattern; (2) Immediate intrauterine resuscitation: - Reposition mother (left lateral, knee-chest, side-to-side); - 100% O2 supplemental; - IV fluid bolus 500-1000 mL; - Stop oxytocin (if running); - Vasopressor if hypotensive (phenylephrine, ephedrine); - Vaginal exam (cord prolapse, dilation); - Tocolysis (terbutaline 0.25 mg SC or IV) for tachysystole; (3) If non-recovery — DELIVERY: - Operative vaginal delivery if fully dilated + station appropriate; - Emergency Cesarean section if not; - Decision-to-delivery interval < 30 min (some say < 15 for prolonged bradycardia + no recovery); (4) Anesthesia for emergent C-section: - Epidural top-up if functioning: 2% lidocaine + epinephrine + bicarbonate 15-20 mL (fastest reliable); aim T4 dermatome; - Spinal if no epidural + time + no severe hypovolemia/coagulopathy; - GA if immediate (failed epidural, hemodynamic instability, severe coagulopathy); GA technique: RSI + cricoid + video laryngoscopy + difficult airway prep; (5) Decision factors: - Time to delivery; - Urgency (Category 1 immediate / 2 maternal-fetal compromise / 3 stable); - Anesthesia type already in place; - Patient stability; - Difficult airway; (6) Hemodynamic: avoid hypotension (fetal hypoxia); fluid + phenylephrine; (7) Neonatal team ready; (8) Post-delivery: maternal monitoring, hemorrhage risk, NICU coordination; (9) Multidisciplinary: anesthesia + OB + nursing + neonatology

---

Category III tracing: intrauterine resuscitation (position, O2, fluid, stop oxytocin, vasopressor, tocolysis). Delivery if no recovery. Epidural top-up (lido + epi + bicarb) > spinal > GA. Decision-to-delivery < 30 min.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 35 ปี G1P0 GA 39 wk active labor, epidural in place + bolused, contractions strong
Fetal HR 90 sustained × 5 min + no recovery, late decelerations preceding
Category III tracing';

update public.mcq_questions
set choices = '[{"label":"A","text":"No monitoring"},{"label":"B","text":"Procedural sedation pediatric"},{"label":"C","text":"Skip NPO"},{"label":"D","text":"Adult doses always"},{"label":"E","text":"Discharge without recovery"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Procedural sedation pediatric: (1) Continuum: minimal (anxiolysis) → moderate (purposeful response) → deep (purposeful with repeated stimulation) → GA; (2) Sedationist must be capable of rescuing deeper level than intended; (3) Pre-procedure: - History (allergies, NPO, comorbidities, prior sedation); - Physical (airway assessment); - ASA classification; - Informed consent; - Equipment: O2, suction, BVM, airway, IV access, reversal agents, monitor; - NPO guidelines (clear 2h, breast milk 4h, formula 6h, solid 8h — emergency exceptions); (4) Monitoring: - Continuous SpO2, ECG, BP intermittent, capnography (mandatory moderate/deep per ASA); - Trained personnel; (5) Drug options: - Propofol — short, smooth; respiratory depression; - Ketamine 1-2 mg/kg IV (or 4 mg/kg IM) — dissociative, analgesic, preserved airway + breathing, sympathomimetic; emergence reactions; - Ketofol (propofol + ketamine) — additive benefits, opposing side effects; - Midazolam — anxiolysis, amnesia; - Fentanyl — analgesia; - Dexmedetomidine — sedation without respiratory depression; - Nitrous oxide — quick onset/offset, anxiolysis + analgesia; - Etomidate — CV stable; (6) Risks: - Apnea + hypoventilation; - Aspiration; - Hypotension; - Allergic; - Emergence; - Failed sedation; (7) Recovery — meets discharge criteria (same as ambulatory anesthesia); (8) Documentation; (9) Pediatric specific: - Weight-based dosing; - Atropine pre-treatment (bradycardia risk in young); - Family involvement; - Distraction techniques + child life; - Topical anesthesia for IV; (10) Complications managed: airway opening, BVM, intubation, reversal (naloxone, flumazenil), CPR

---

Pediatric procedural sedation: depth continuum, capnography mandatory, NPO with emergency exceptions, drugs (propofol, ketamine, ketofol, dex, N2O), weight-based dosing, monitoring + rescue capability.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'เด็ก 5 ปี — moderate sedation for laceration repair in ED
Using propofol + ketamine combination (''ketofol'')
Monitored';

update public.mcq_questions
set choices = '[{"label":"A","text":"No monitoring"},{"label":"B","text":"Total Intravenous Anesthesia (TIVA)"},{"label":"C","text":"Stop pumps"},{"label":"D","text":"Avoid all TIVA"},{"label":"E","text":"Skip BIS"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Total Intravenous Anesthesia (TIVA): (1) Components — IV agents only (no volatile); typically propofol + opioid (remifentanil most common); (2) Indications: - MEP/SSEP monitoring; - Operating room without volatile; - Patient transport; - Avoid PONV (propofol antiemetic); - Awake craniotomy; - Avoid environmental impact (volatile potent greenhouse gas); - Patient preference; - Risk MH; (3) Target-controlled infusion (TCI): - Pharmacokinetic model (Marsh, Schnider for propofol; Minto for remifentanil); - Target plasma or effect-site concentration; - System adjusts infusion rate automatically; - Allows steady predictable levels; (4) Manual infusion alternative — 10-8-6 rule for propofol (10 mg/kg/hr × 10 min, 8 × 10 min, 6 continuous); requires monitoring; (5) Advantages: - Smooth + predictable; - Less PONV; - No environmental concern; - Avoids volatile interactions (MH, neuromonitoring); - Good for transports; (6) Disadvantages: - Awareness risk if delivery failure (vapor analyzer not applicable); - Need IV access reliable; - Cost (propofol); - Requires pump expertise; - Variable pharmacokinetics (obesity, elderly); (7) Monitoring: - BIS/processed EEG strongly recommended (awareness); - Standard ASA monitoring; (8) Specific considerations: - Awareness — confirm IV running, no leak, pump function; - Propofol infusion syndrome (high dose long duration): rhabdo, acidosis, cardiac failure, hyperlipidemia, hepatomegaly; avoid > 4 mg/kg/hr > 48h; - Remifentanil — context-insensitive; bridge analgesia before stop; opioid-induced hyperalgesia; (9) Pediatric TIVA — TCI models pediatric; (10) Modern: TIVA expanding, environmental concerns drive change

---

TIVA: propofol + remifentanil (typically) ± TCI. Indications: MEP/SSEP, no volatile, PONV avoidance, environmental. Advantages: smooth, less PONV. Risks: awareness, PRIS, hyperalgesia. BIS strongly recommended.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Basic science: pharmacology of TIVA (Total IV Anesthesia)
Using propofol + remifentanil TCI';

update public.mcq_questions
set choices = '[{"label":"A","text":"Skip checks"},{"label":"B","text":"Anesthesia machine + physics"},{"label":"C","text":"Use without setup"},{"label":"D","text":"Ignore alarms"},{"label":"E","text":"Disable safety"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Anesthesia machine + physics: (1) Components: - Pipeline + cylinder gas supply (O2, N2O, air); - Pressure regulators (high pressure → working); - Flow meters (variable orifice rotameters); - Vaporizers (variable bypass agent-specific); - Common gas outlet; - Circle breathing system; - Ventilator; - Scavenging system; - Monitors; (2) Safety features: - Pin index safety system (PISS) for cylinders; - Diameter index safety system (DISS) for pipelines; - O2 ratio controller (prevents hypoxic mixture, fail-safe); - Low O2 alarm; - Vaporizer interlock; - Hypoxic guard; - Backup O2 cylinder; (3) Vaporizers: - Variable bypass (splitting ratio determines % output); - Agent-specific (each calibrated); - Tec 6 desflurane (heated); - Temperature compensation; (4) Circle system advantages: rebreathing (CO2 absorbed) — saves volatile + heat + moisture; (5) CO2 absorber — soda lime / Baralyme: - Reacts with CO2 → CaCO3; - Color indicator (ethyl violet); - Desiccated absorber + sevoflurane = compound A (nephrotoxicity concern); + desflurane = CO (concern); modern absorbers reduce risk; (6) Daily machine check (FDA pre-use checkout): - Verify backup O2; - Check anesthesia gas suction; - Inspect circuit; - Test high + low pressure leak; - Verify gas flows; - Check vaporizer; - Check ventilator + ICU monitor; - Suction; - Check scavenging; - Final position safe; (7) Common faults: - Disconnect, kink, leak; - Vaporizer empty/tipped; - Pop-off valve closed; - Exhausted CO2 absorber (Phase I rebreathing); - Pipeline contamination (rare devastating); (8) Modern: integrated machine + monitor; software-guided checks

---

Anesthesia machine: gas supply + safety features (PISS, DISS, O2 ratio), vaporizers (agent-specific), circle system + CO2 absorber, ventilator. Daily pre-use check FDA mandatory. Common faults: leak, kink, exhausted absorber.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Basic science: physics of anesthesia equipment + machine check';

update public.mcq_questions
set choices = '[{"label":"A","text":"Maximum crystalloid"},{"label":"B","text":"Perioperative fluid management"},{"label":"C","text":"No replacement"},{"label":"D","text":"Hypotonic always"},{"label":"E","text":"Skip electrolytes"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Perioperative fluid management: (1) Fluid types: - Crystalloid: NS (isotonic, but hyperchloremic — large volumes → metabolic acidosis + AKI; SMART trial favors balanced); balanced (LR, Plasma-Lyte) — preferred most cases; - D5W rarely used (free water); - Colloid: albumin (5%, 25%), hydroxyethyl starch (avoided due to AKI per CHEST + 6S trials); (2) Goals: - Maintain perfusion (BP, urine output, lactate clearance, mental status); - Avoid over-resuscitation (interstitial edema, anastomotic leak, pulmonary edema, AKI, abdominal compartment syndrome, ICU LOS, mortality); - Avoid under-resuscitation (hypoperfusion, AKI, ileus); (3) Maintenance — 4-2-1 rule (4 mL/kg first 10 kg + 2 next 10 + 1 above) historic; modern advocates lower or none with shorter NPO; (4) Replacement — match losses (insensible, urine, blood, third space); third space concept evolved (overestimated); (5) Goal-directed fluid therapy (GDFT): - Dynamic indices (PPV pulse pressure variation > 13%, SVV, IVC variability) > static (CVP, PCWP); - Cardiac output monitoring (esophageal Doppler, pulse contour analysis — FloTrac); - Fluid challenge (250 mL bolus, observe response); - Restrictive vs liberal — controversial; RELIEF trial moderate (3-4 L), restrictive associated with AKI; goal-directed better; (6) ERAS — moderate fluid + GDFT + early oral; (7) Major fluid shifts surgeries: liver, abdominal, vascular; (8) Electrolytes: - Na (water balance), K (cardiac), Ca (citrate from transfusion), Mg (arrhythmia, NMB), Cl (acid-base); - Hyponatremia (TURP syndrome with hypotonic irrigation; SIADH); - Hyperkalemia (ESRD, succinylcholine, transfusion, AKI); (9) Modern: individualized, goal-directed, multimodal assessment

---

Fluids: balanced > NS (large volume), avoid HES, GDFT > liberal/restrictive, dynamic indices > static, ERAS moderate fluid. Electrolyte management. Modern: individualized.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Basic science: physiology of fluid + electrolytes
Question on perioperative fluid management';

update public.mcq_questions
set choices = '[{"label":"A","text":"Avoid all EHR"},{"label":"B","text":"AIMS/EHR in anesthesia"},{"label":"C","text":"Paper only"},{"label":"D","text":"Skip decision support"},{"label":"E","text":"Ignore alerts"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** AIMS/EHR in anesthesia: (1) Anesthesia Information Management System (AIMS) — electronic anesthesia record: - Automated capture of vitals; - Drug + fluid administration; - Events + interventions; - Customizable templates; - Integration with EHR; (2) Benefits: - Accuracy + completeness; - Legibility; - Decision support (drug interactions, allergies, dosing); - Quality reporting + research (NACOR); - Billing accuracy; - Reduced documentation burden in some studies; (3) Concerns: - Implementation cost; - Workflow disruption initially; - Patient safety risks (automated entry errors); - Privacy + security; - Documentation increase paradoxical; (4) Decision support: - Drug allergy alerts; - Drug-drug interaction; - Drug-disease interaction; - Dose-checking; - Reminders (antibiotic timing, glucose check); - Alert fatigue concern; (5) Big data + research: - Multicenter studies; - Quality improvement; - Outcome prediction (machine learning); - Precision anesthesia; (6) Integration with pumps, ventilators, monitors; (7) Modern: AI/ML applications: - Hypotension prediction (HPI); - Difficult airway prediction; - PONV risk; - Mortality risk; - Clinical decision support; (8) Cybersecurity — healthcare data breaches increasing; ransomware; vigilance + backup; (9) Modern: cloud-based, mobile, wearables, telemedicine integration; (10) Limitations — never replace clinical judgment + presence

---

AIMS/EHR: automated capture, decision support, quality reporting, research (NACOR). Concerns: workflow, alert fatigue, security. AI/ML modern (HPI, prediction). Integration. Cybersecurity vigilance. Clinical judgment paramount.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'EMS/Management: anesthesia information management systems (AIMS) + EHR';

update public.mcq_questions
set choices = '[{"label":"A","text":"Ignore global health"},{"label":"B","text":"Global anesthesia + low-resource settings"},{"label":"C","text":"Refuse training"},{"label":"D","text":"Equipment-dependent always"},{"label":"E","text":"Discriminate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Global anesthesia + low-resource settings: (1) Global burden — 5 billion people lack safe anesthesia/surgery (Lancet Commission Global Surgery 2030); (2) Disparities: - Workforce shortage; - Equipment + drug shortages; - Training gaps; - Infrastructure; - Maternal mortality (anesthesia-related); (3) Anesthesia + global surgery: - Bellwether procedures (C-section, laparotomy, open fracture) — surrogate for surgical capacity; - WFSA (World Federation of Societies of Anaesthesiologists) Standards minimum; (4) Adaptations: - Draw-over vaporizers (no compressed gas needed); - Spinal anesthesia (low cost, effective for C-section + many surgeries); - Ketamine (broad utility, safer in low-resource); - Trained non-physician anesthesia providers; - Standardized protocols; (5) Education + training: - Training programs (Lifebox, SAFE OB, ETAT); - Continuing education; - Equipment donation programs; (6) Patient safety: - Lifebox pulse oximetry initiative; - WHO Surgical Safety Checklist; - Standardized care; (7) Specific challenges: - Sickle cell disease prevalent; - Anemia + nutritional deficiencies; - Infectious diseases (HIV, TB, malaria); - Late presentation; - Drug shortages; (8) Disaster anesthesia: - Earthquake, conflict, refugee crisis; - MSF, ICRC; - Field hospitals; - Ketamine-based; (9) Health equity: - Access to safe surgery; - Training local providers; - Sustainable systems; (10) Ethical considerations: - Cultural sensitivity; - Capacity building > episodic missions; - Respect local autonomy; - Avoid ''voluntourism''; (11) Modern: GlobalSurg studies, NIHR, partnership models

---

Global anesthesia: 5 billion lack access. Adaptations (draw-over, ketamine, spinal, non-physician providers). Lifebox initiative + WHO Checklist. WFSA Standards. Education + sustainable systems. Bellwether procedures.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Integrative: global anesthesia + low-resource settings';

update public.mcq_questions
set choices = '[{"label":"A","text":"Test everything"},{"label":"B","text":"Pre-operative testing"},{"label":"C","text":"No history needed"},{"label":"D","text":"Routine CXR all"},{"label":"E","text":"Skip cardiac"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pre-operative testing — evidence-based: (1) Universal testing not recommended — direct patient impact required: - Reduce false positives leading to delays + harms; - Cost; - Patient inconvenience; (2) ASA/Choosing Wisely recommendations: - History + physical primary; - Targeted testing based on patient factors + procedure; (3) Tests with low yield in asymptomatic patients: - CXR without symptoms or specific risk; - Routine ECG in low-risk; - Routine CBC/electrolytes/coag asymptomatic minor surgery; (4) Indicated testing: - Age + comorbidity-based ECG (men > 40, women > 50, cardiac history); - Glucose/HbA1c if diabetic; - Hb if anemia history or major surgery; - Coagulation if liver disease, bleeding history, anticoagulant; - Renal function if CKD, age > 65 with risk factors, nephrotoxic drugs; - Pregnancy testing — selective vs universal female reproductive age; (5) Cardiac evaluation (covered) — RCRI + functional capacity; (6) Pulmonary — PFT only if active symptoms, recent change, planned thoracotomy; (7) Other tests: - Coag in regional anesthesia (selective); - Type + cross only if anticipated transfusion; (8) Cost-effective; (9) Beyond elective: - Emergent procedures less testing pre-op; - Trauma based on injury; (10) Pre-op clinic functions: - Risk stratification; - Optimization; - Education; - Coordination; - Reduced day-of cancellation; (11) Joint Commission + CMS quality measures; (12) Modern: shared decision-making + individualized testing

---

Pre-op testing: targeted based on H&P + comorbidity + procedure (NOT universal). ECG age + risk-based, indicated labs only. Reduce false-positive harms + cost. Pre-op clinic for optimization. Choose Wisely.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 60 ปี ASA III HTN, CAD on aspirin, well-controlled — elective TKA
Pre-op evaluation considering ALL routine testing';

update public.mcq_questions
set choices = '[{"label":"A","text":"Standard supine"},{"label":"B","text":"Robotic surgery anesthesia + steep Trendelenburg + pneumoperitoneum"},{"label":"C","text":"No fluid restriction"},{"label":"D","text":"Skip eye protection"},{"label":"E","text":"Mass volume loading"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Robotic surgery anesthesia + steep Trendelenburg + pneumoperitoneum: (1) Steep Trendelenburg (30-45° head down) physiologic effects: - CV: increased preload + venous return (initially), decreased venous return prolonged (Bezold), increased ICP, conjunctival + laryngeal edema; - Respiratory: decreased FRC, increased PIP, atelectasis, decreased compliance, V/Q mismatch; - CNS: increased ICP + IOP; - Visual: increased risk POVL (rare but recognized); - Aspiration risk; (2) CO2 pneumoperitoneum: - Increased intra-abdominal pressure (12-15 mmHg) → decreased venous return + cardiac output; renal perfusion decrease; oliguria; - CO2 absorption → hypercapnia → tachycardia + arrhythmia; - Compromised ventilation; - Subcutaneous emphysema, pneumomediastinum, pneumothorax (rare); - Gas embolism (rare devastating); (3) Anesthetic management: - Lung-protective ventilation TV 6 mL/kg + PEEP 8-12; - Permissive hypercapnia; - Adjust I:E ratio; - Pressure-controlled ventilation often; - Adequate paralysis to facilitate insufflation + minimize PIP; - Limit IV fluid (avoid edema in head-down); - Goal-directed fluid; - Maintain MAP; - Eye protection (taped, eye shields, regularly check); - Avoid prolonged extreme Trendelenburg if possible; (4) Position complications: - Slipping cephalad — taped to bed, shoulder braces (brachial plexus injury risk), bean bag, gel pads; - Compartment syndrome lower extremity (lithotomy + steep T) — limit duration; - Brachial plexus injury (shoulder braces); - Conjunctival edema; - Facial edema; - Cerebral edema (post-op delirium); (5) Robotic specific: - Patient inaccessible during surgery (cannot easily access airway); - Emergency requires undocking robot; - Long surgery — pressure injury; - Single instrument failure issues; (6) Extubation: - Edema may compromise airway — cuff leak test, awake extubation, head up; - Post-op observation; (7) Multidisciplinary: anesthesia + urology + nursing

---

Robotic + steep T + pneumoperitoneum: lung-protective ventilation + PEEP, permissive hypercapnia, fluid restriction, eye protection, position complications (compartment syndrome, brachial plexus). Awake extubation. Robot undocking for emergency.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 65 ปี — robotic-assisted laparoscopic prostatectomy in steep Trendelenburg position
GA + ETT, CO2 pneumoperitoneum, expected duration 4-5h';

update public.mcq_questions
set choices = '[{"label":"A","text":"Skip equipment"},{"label":"B","text":"Trauma intra-hospital transport"},{"label":"C","text":"Walk patient"},{"label":"D","text":"Single IV only"},{"label":"E","text":"No transport plan"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Trauma intra-hospital transport: (1) Risks during transport: - Cardiovascular instability; - Respiratory compromise; - Loss IV access; - Hypothermia; - Equipment failure; - Disconnection (ETT, lines, monitors); - Inadequate analgesia/sedation; (2) Pre-transport optimization: - Hemodynamic stabilization (within reason — competing balance); - Adequate IV access (2 large-bore + central if available); - Secure airway (ETT + EtCO2 confirmation); - Adequate ventilation/oxygenation; - Sedation + analgesia + paralysis as needed; - Vasopressors continued; - Blood products available + warming; - Hypothermia prevention; (3) Transport equipment: - Portable monitor (SpO2, ECG, BP, EtCO2); - Portable ventilator (or ambu); - O2 cylinder full + backup; - Suction; - Airway kit (re-intubation); - Emergency drugs (epinephrine, atropine, sedation, paralysis); - IV pumps battery-powered + drugs; - Defibrillator; (4) Team composition: - Anesthesiologist or trained provider; - Nurse/RT; - Transport personnel; - Communication with destination; (5) Damage control resuscitation principles continue; (6) Trauma triad of death avoidance — hypothermia, coagulopathy, acidosis; (7) Communication: - Pre-arrival notification to receiving area (OR/ICU/CT); - Brief handoff; - Continued accessibility; (8) CT scan decision: - Full body CT (whole body scan) in stable trauma for diagnosis; - But unstable patient → direct to OR (damage control); - REBOA for select bleeding cases as bridge; (9) Documentation; (10) Multidisciplinary team approach

---

Trauma transport: optimize hemodynamic + airway, full transport equipment, trained team, communicate with destination, continue resuscitation. Triad of death avoidance. Stable → CT first, unstable → OR. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 45 ปี multi-trauma C-spine + chest injury + pelvic fracture + femur fracture
Age: 45, ED — airway secured, IV × 2, blood products started
Now planning transport from ED to OR vs CT scan';

update public.mcq_questions
set choices = '[{"label":"A","text":"Ondansetron prophylactic"},{"label":"B","text":"Long QT Syndrome (LQTS) perioperative"},{"label":"C","text":"Methadone PCA"},{"label":"D","text":"Amiodarone first-line"},{"label":"E","text":"Bradycardia desired"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Long QT Syndrome (LQTS) perioperative: (1) Risk torsades de pointes (polymorphic VT) intra/post-op; (2) Continue baseline beta-blocker (cornerstone LQTS treatment); (3) Avoid QT-prolonging drugs: - Ondansetron + droperidol (5-HT3 + D2); - Methadone; - Amiodarone (acute use OK); - Erythromycin/clarithromycin; - Quinidine, procainamide; - Sotalol; - Haloperidol (high dose); - Fluoroquinolones; - Some anesthetics (sevoflurane modest prolongation; isoflurane less); - Volatile typically OK at clinical doses; (4) Avoid bradycardia (potentiates TdP) — atropine ready; (5) Avoid hypokalemia, hypomagnesemia (correct pre-op; target K > 4, Mg > 2); (6) Avoid sympathetic surges: - Adequate anesthesia depth; - Smooth induction + intubation; - Adequate analgesia; - Avoid pain, anxiety, light anesthesia; - Beta-blocker pre-induction; (7) Drug choices: - Propofol OK; - Etomidate OK; - Ketamine controversial (sympathomimetic — but usually OK with adequate beta-blockade); - Fentanyl OK (less than sufentanil); - Rocuronium OK; - Avoid succinylcholine bradycardia; - Lidocaine OK (treats TdP if occurs); (8) Monitoring: - Continuous ECG; - Have defibrillator/pacer immediately available; - Watch QTc + TWI dynamic changes; (9) Treatment torsades: - Magnesium sulfate 2g IV bolus (first-line); - Overdrive pacing or isoproterenol (increase HR > 100 to shorten QT); - Defibrillation if pulseless; - Avoid antiarrhythmic that prolong QT (amiodarone, procainamide, sotalol); (10) Implantable cardiac defibrillator (ICD) — deactivate for electrocautery (or use bipolar/short bursts), reactivate post-op; (11) Genetic counseling; (12) Family screening

---

LQTS: continue BB, avoid QT-prolonging drugs (ondansetron/droperidol/methadone), K > 4 + Mg > 2, avoid bradycardia, defibrillator ready. TdP treatment: Mg + overdrive pacing. Smooth anesthesia.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วย 55 ปี history Long QT Syndrome — elective laparoscopic cholecystectomy
QTc 510 baseline
No prior arrhythmia';

update public.mcq_questions
set choices = '[{"label":"A","text":"Ignore"},{"label":"B","text":"Spinal cord ischemia post-aortic surgery"},{"label":"C","text":"Wait 48h"},{"label":"D","text":"More sedation"},{"label":"E","text":"Decrease MAP"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Spinal cord ischemia post-aortic surgery: (1) Mechanism — interruption of spinal cord blood supply: - Anterior spinal artery — arises from intercostals, especially T9-T12 (Artery of Adamkiewicz); - Aortic cross-clamp during surgery; - Aortic dissection; - Embolic; (2) Anterior spinal artery syndrome: - Bilateral motor loss + pain/temperature loss; - Preserved proprioception + vibration (dorsal column); - Bowel/bladder dysfunction; - Devastating; (3) Risk factors: - Thoracoabdominal aortic surgery (highest); - Cross-clamp duration > 30 min; - Hypotension intra/post-op; - Anemia; - Hypovolemia; - Aortic disease; (4) Prevention strategies (TAA): - Cerebrospinal fluid drainage (CSF drain) — reduce CSF pressure, improve perfusion (target CSF < 10); - Distal aortic perfusion (LV bypass); - Mild hypothermia (32-34°C); - Permissive hypertension (MAP > 80-90); - Avoid anemia; - Reimplantation intercostals; - Motor evoked potential (MEP) monitoring; (5) Recognition + management: - Neuro exam q1h post-op; - If new deficit: CSF drainage MORE aggressive (drain CSF, target < 8), maintain MAP > 90-100, transfusion to Hb > 10, steroids (controversial); - MRI to rule out hematoma vs ischemia; - Time-sensitive — may reverse with prompt intervention; (6) Multidisciplinary: vascular surgery + anesthesia + neurology; (7) Other causes weakness post-aortic: - Hematoma (anticoagulation, neuraxial); - Mechanical (spinal stenosis); - Stroke; - Critical illness neuropathy (later); (8) Prognosis variable — early reversal possible if rapid intervention; permanent if delayed; (9) Documentation + counseling

---

Post-aortic spinal cord ischemia: anterior spinal artery syndrome (motor + pain/temp loss, preserved proprioception). Prevention CSF drain + MAP > 90 + MEP. Treatment: drain more, MAP higher, transfuse, rule out hematoma. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ICU 70 ปี post-aortic surgery day 2 — sudden lower extremity weakness bilateral
No pain, no sensory deficit per dermatomes initially, reflexes diminished';

update public.mcq_questions
set choices = '[{"label":"A","text":"Single approach all"},{"label":"B","text":"Cultural competency in anesthesia"},{"label":"C","text":"Family interprets always"},{"label":"D","text":"Ignore disparities"},{"label":"E","text":"Discriminate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cultural competency in anesthesia: (1) Healthcare disparities documented by race/ethnicity, gender, sexual orientation, socioeconomic, language, immigration, disability; (2) Specific anesthesia disparities: - Pain undertreated in minorities (multiple studies); - Disparities in perioperative outcomes; - Language barriers + access; (3) Components of cultural competency: - Awareness of own biases; - Knowledge of cultural variations (beliefs, practices); - Skills to engage respectfully; - Encounters across cultures; (4) Communication: - Professional interpreter (NOT family member); - Plain language; - Teach-back; - Health literacy assessment; - Culturally appropriate consent; - Privacy + dignity; (5) Cultural beliefs affecting anesthesia: - Religious (Jehovah''s Witness, fasting, modesty); - Dietary; - Pain expression varies; - Family decision-making (collectivist vs individualist); - End-of-life beliefs; - Traditional medicine; (6) Specific populations: - LGBTQ+ — affirming care, hormone therapy, surgical issues; - Indigenous — historical trauma, cultural practices; - Refugee/immigrant — trauma, language, legal status; - Disabled — accommodations, communication, consent capacity; - Limited English — interpretation; - Mental illness — stigma; (7) Implicit bias — automatic stereotyping; education + awareness + reflection; (8) Anti-racism in healthcare: - Recognize structural racism; - Diversify workforce; - Inclusive curriculum; - Address systemic issues; (9) Diversity, Equity, Inclusion (DEI) initiatives: - ASA Committee on DEI; - APSF; (10) Patient-centered care + shared decision-making; (11) Modern: trauma-informed care, structural humility, recognizing intersectionality; (12) Quality + safety equity

---

Cultural competency: awareness + knowledge + skills + encounters. Professional interpreter (NOT family). Address pain disparities. LGBTQ+ + refugee + disabled needs. Implicit bias + structural racism. DEI initiatives. Patient-centered + shared decision-making.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Integrative: cultural competency + diversity in anesthesia care';

update public.mcq_questions
set choices = '[{"label":"A","text":"Single-shot spinal"},{"label":"B","text":"Mitral stenosis in pregnancy + delivery"},{"label":"C","text":"Allow tachycardia"},{"label":"D","text":"Mass IV bolus"},{"label":"E","text":"Skip cardiology"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mitral stenosis in pregnancy + delivery: (1) MS hemodynamic goals: - Maintain SINUS RHYTHM (atrial kick essential, AFib catastrophic); - Avoid TACHYCARDIA (decreases diastolic filling time across stenotic valve → pulmonary congestion); target HR 60-80; - Maintain PRELOAD but avoid OVERLOAD (pulmonary edema); - Maintain SVR (afterload supports systemic circulation); - Avoid increased PVR (RV failure); - Avoid sympathetic surges; (2) Pregnancy worsens MS: - Increased CO + HR; - Increased blood volume; - Autotransfusion peri-delivery worst; (3) Pre-conception counseling, severe MS — consider valve intervention before pregnancy; balloon valvuloplasty pregnancy (radiation considerations); (4) Anesthesia for delivery: - Multidisciplinary planning at cardiac OB center; - Early epidural for labor — reduces sympathetic surge from pain; SLOW titration to avoid sudden hemodynamic shifts; - Vaginal delivery preferred if hemodynamically tolerated; assisted second stage (avoid prolonged Valsalva); - C-section reserved for OB indications; - Avoid spinal (sudden sympathectomy); - GA if needed (RSI standard, blunt response with opioid + lidocaine, avoid bradycardia + hypovolemia); (5) Drug choices: - Norepinephrine for hypotension (alpha + beta); - Esmolol for tachycardia/AFib rate control (avoid pure beta with caution); - Cardioversion AFib hemodynamic compromise; - Avoid ergot (uterine + cardiac); - Oxytocin slow (sudden hypotension can be devastating); (6) Monitoring: - Arterial line; - Cardiac output monitoring (esophageal Doppler, pulse contour); - TEE in OR if available; - Strict fluid balance; (7) Postpartum: - Autotransfusion + decompensation risk — highest mortality first 48h; - ICU; - Diuresis (carefully); - Continue beta-blocker; - Anticoagulation if AFib; (8) Multidisciplinary: cardiac OB anesthesia + OB + cardiology + ICU + neonatology

---

MS in pregnancy: hemodynamic goals (SR, slow HR, preload + afterload), early SLOW epidural for labor, avoid spinal/sudden sympathectomy, vaginal preferred. Norepi + esmolol. ICU postpartum. Multidisciplinary cardiac OB.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 32 ปี G2P1 GA 36 wk — severe Mitral Stenosis (MVA 0.8 cm²) from rheumatic
Dyspnea NYHA III, paroxysmal AFib
Delivery planning at 38 wk';

update public.mcq_questions
set choices = '[{"label":"A","text":"Adult dosing"},{"label":"B","text":"Pediatric pharmacology"},{"label":"C","text":"Skip pediatric considerations"},{"label":"D","text":"Avoid all anesthesia peds"},{"label":"E","text":"Ignore weight"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric pharmacology: (1) Age-related changes: - Body composition (water, fat, muscle); - Protein binding; - Metabolism (CYP maturation); - Renal function maturation; - BBB permeability; (2) Neonatal specific: - Increased total body water (75-80%) → larger Vd hydrophilic drugs → higher loading dose; - Decreased lipid → smaller Vd lipophilic; - Decreased plasma proteins → more free drug; - Hepatic metabolism immature (CYP); - GFR decreased then matures by 1 year; - BBB more permeable (drug entry); - Receptor sensitivity different; (3) Specific drugs: - Propofol — increased dose 2.5-3 mg/kg (vs adult 1.5-2.5); higher metabolic rate young; - Succinylcholine — 1.5-2 mg/kg IV, 4 mg/kg IM (higher dose due to ECF); atropine pre-treatment for bradycardia; - Rocuronium — 1.2 mg/kg; sugammadex now available pediatric; - Sevoflurane — preferred for inhalational induction; emergence delirium risk; - Opioid — sensitivity varies; neonate respiratory depression risk; - Local anesthetic — lower max dose; bupivacaine 2 mg/kg, lidocaine 4.5 mg/kg (with epi 7); (4) MAC: - Neonate MAC similar/lower; - Infant 1-6 months HIGHER MAC for volatile (highest); - Decreases with age; (5) Dosing: - Weight-based mg/kg (not adult fixed dose); - Use ideal body weight in obese; - Round to nearest practical dose; - Adjust for age, organ function; (6) Cardiac: - Higher dependence on HR (fixed SV); avoid bradycardia (atropine ready); (7) Respiratory: - Higher O2 consumption; rapid desaturation; large head + occiput affects positioning; (8) Vascular access: - IV difficult — IO acceptable emergency; (9) Premature infants: - More extreme PK; - Apnea risk; - Hypoglycemia; - Hypothermia; - Long-term neurodevelopmental considerations volatile (FDA warning, controversial)

---

Pediatric PK/PD: water/fat differ, protein binding decreased, hepatic immature. Sux higher dose, MAC variable (infant highest). Weight-based dosing. Bradycardia + rapid desat. Premie special considerations.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Basic science: pediatric pharmacokinetics/pharmacodynamics';

update public.mcq_questions
set choices = '[{"label":"A","text":"Skip ECMO"},{"label":"B","text":"Adult ECMO"},{"label":"C","text":"All patients candidates"},{"label":"D","text":"Avoid anticoagulation"},{"label":"E","text":"Single-clinician decision"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Adult ECMO: (1) Types: - VV (veno-venous) — respiratory failure, lungs rest; blood from vein → oxygenator → vein; - VA (veno-arterial) — cardiac + respiratory failure, supports CO; blood from vein → oxygenator → artery; (2) Indications VV ECMO: - Severe ARDS (P/F < 50 for 3h or < 80 for 6h + maximal medical therapy); - EOLIA + CESAR trials; (3) Indications VA ECMO: - Cardiogenic shock refractory; - Cardiac arrest (ECPR) — high-quality CPR + reversible cause; - Massive PE; - Anaphylaxis refractory; - Bridge to transplant/recovery/decision; (4) Contraindications: - Severe brain injury; - Disseminated cancer; - Severe coagulopathy/bleeding; - Age + frailty (case-by-case); - Cannot tolerate anticoagulation (relative); (5) Anticoagulation: - Heparin infusion target ACT 180-220 or aPTT 60-80; - Bivalirudin alternative (HIT or heparin resistance); - Bleeding most common complication; - Thrombosis if undertreated; (6) ECMO cannulation: - VV: percutaneous femoral + IJ or dual-lumen Avalon; - VA: peripheral (femoral artery + vein, distal perfusion cannula for limb), central (chest open); (7) Complications: - Bleeding; - Hemolysis; - Thrombosis; - Limb ischemia (VA peripheral); - Air embolism; - Cardiac stunning (LV distension VA); - Infection; - Neurologic; (8) Management: - Daily evaluation native function; - Weaning trials; - Multidisciplinary; - Family communication; (9) Anesthesia for ECMO patients: - Pump-dependent oxygenation/circulation; - Drugs altered PK (circuit sequestration); - Bleeding risk; - Communication with perfusion; (10) Outcomes: - VV ARDS survival ~60%; - VA cardiogenic shock variable; - ECPR survival 25-40%; (11) Modern: increased use; selection critical for outcomes

---

ECMO: VV (respiratory) vs VA (cardiac + respiratory). Indications + contraindications. Anticoagulation (heparin/bivalirudin). Complications: bleeding, limb ischemia (VA), LV distension. Multidisciplinary + selection critical. Modern: expanding use.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Basic science: ECMO in adult ICU';

update public.mcq_questions
set choices = '[{"label":"A","text":"Skip safety standards"},{"label":"B","text":"Non-Operating Room Anesthesia (NORA)"},{"label":"C","text":"No monitoring needed"},{"label":"D","text":"Different rules"},{"label":"E","text":"Refuse NORA"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Non-Operating Room Anesthesia (NORA): (1) Locations: - GI endoscopy (colonoscopy, ERCP, EUS); - Interventional radiology (embolization, biopsy, drain, EVAR); - Cardiac cath/EP lab (TAVR, ablation, ICD, PCI); - Radiation oncology (pediatric daily); - MRI/CT; - Bronchoscopy; - ECT (psychiatry); - Dental; - Office-based; (2) Challenges: - Unfamiliar environment; - Limited assistance; - Patient access limited (cath lab, MRI); - Equipment different/less; - Radiation exposure; - Magnetic field (MRI); - Distance from main OR/resources; (3) Anesthesia options: - MAC (moderate-deep sedation); - GA; - Regional + sedation; - Local + monitor; (4) Equipment requirements: - Same standards as OR (ASA monitoring); - Capnography mandatory moderate/deep; - Suction, O2, airway, drugs, defibrillator; - Reliable communication; - Emergency support plan; (5) MRI-specific: - MR-conditional equipment (ferromagnetic safety); - Long monitoring cables; - Pulse oximetry, capnography, ECG MR-safe; - Anesthesia machine MR-compatible or outside scan room; - Earplugs/protection (noise); - Patient screening (pacemaker, implants); - Heat concern (RF energy); (6) Radiation: - Lead shield + apron; - Distance + time minimization; - Pregnancy screening staff; - Eye protection; (7) Pediatric NORA — high volume (radiation therapy, MRI); requires expertise; (8) Sedation drugs: - Propofol, ketamine, dexmedetomidine, fentanyl, midazolam; - Risks: airway, hypotension, paradoxical reaction; (9) Pre-procedure assessment: - Standard pre-anesthesia evaluation; - NPO; - Difficult airway screening; - Comorbidities; (10) Safety: - Standard apply outside OR; - ASA Statement NORA

---

NORA: same ASA standards as OR, capnography mandatory moderate/deep sedation, MR-conditional equipment, radiation protection, pediatric NORA expertise. Reliable communication + emergency plan. ASA NORA Statement.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'EMS/Management: anesthesia for procedures outside OR (NORA — Non-Operating Room Anesthesia)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Routine doses all drugs"},{"label":"B","text":"Cirrhosis perioperative anesthesia"},{"label":"C","text":"Morphine PCA only"},{"label":"D","text":"Mass IV crystalloid"},{"label":"E","text":"Skip TEG"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cirrhosis perioperative anesthesia: (1) Severity assessment — Child-Pugh (A: 5-6, B: 7-9, C: 10-15), MELD (predicts mortality, > 15 high risk); (2) Pre-op optimization: - Treat ascites (diuretic, paracentesis large volume); - Correct coagulopathy (vitamin K, FFP, platelets if active bleeding or pre-procedure); - Optimize albumin + nutrition; - Hepatic encephalopathy (lactulose, rifaximin); - Hyponatremia correction slowly; - Renal function — hepatorenal syndrome screening; (3) Anesthetic considerations: - Altered drug metabolism — many drugs (benzodiazepines, opioids, propofol) accumulate; - Hypoalbuminemia → increased free drug; - Cisatracurium preferred NMB (Hofmann elimination); - Remifentanil preferred opioid (esterase metabolism); - Propofol OK (lower doses, slower infusion); - Avoid morphine (active metabolites); use fentanyl/hydromorphone reduced doses; - Avoid halothane (now rarely used); sevoflurane OK; (4) Hemodynamic: - Hyperdynamic circulation (low SVR, high CO); - Sensitive to fluid shifts; - Vasoplegia common; - Hemorrhagic risk + variceal bleeding; (5) Coagulation: - Rebalanced coagulation (both pro + anti-coagulant decreased); TEG more useful than INR; - Avoid unnecessary FFP (worsens portal pressure); (6) Special considerations TIPS, liver transplant, variceal bleeding; (7) Neuraxial considerations — coagulopathy concern; (8) Post-op: - Hepatic decompensation risk; - HRS; - Infection (SBP); - Coagulopathy; - Encephalopathy; (9) Multidisciplinary: hepatology + anesthesia + surgery + transplant team if applicable

---

Cirrhosis: Child-Pugh + MELD severity. Treat coagulopathy, ascites, encephalopathy. Cisatracurium, remifentanil, reduced doses. Hyperdynamic + vasoplegia. TEG > INR. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 50 ปี — elective hepatic resection
Lab: AST 80, ALT 60, ALK 120, bili 1.8, INR 1.3, plt 110k, albumin 3.2
Child-Pugh B, MELD 12, mild ascites';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue all unchanged"},{"label":"B","text":"Polypharmacy + elderly perioperative"},{"label":"C","text":"Stop everything"},{"label":"D","text":"Skip review"},{"label":"E","text":"Ignore interactions"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Polypharmacy + elderly perioperative: (1) Pre-op medication review (Beers Criteria, STOPP/START): - Identify potentially inappropriate medications (PIMs); - Drug interactions; - Cumulative anticholinergic burden; - Polypharmacy itself = risk factor adverse outcomes; (2) Common categories to review/adjust: - Anticoagulants — hold appropriate intervals (DOAC, warfarin); - Antiplatelets — selective hold; - Antihypertensives — hold ACE-I/ARB day surgery (hypotension); continue beta-blocker; - Diuretics — hold morning, resume; - Hypoglycemics — adjust insulin, hold metformin/SGLT2i; - Anticonvulsants — continue; - Psychiatric — continue most; SSRI (bleeding); MAOI (drug interactions); - Long-acting opioid — continue (avoid withdrawal); - Steroid — continue + stress dose; - Statin — continue (cardioprotective); - Antiarrhythmic — continue (amiodarone — pulmonary, hepatic, thyroid considerations); (3) Specific concerns: - Amiodarone — pulmonary fibrosis risk + intra-op bradycardia + corneal deposits + thyroid; - Furosemide — hypokalemia, hypomagnesemia, hypovolemia; replace K + Mg; - ACE-I — refractory intra-op hypotension; vasopressin may help; (4) Drug-drug interactions: - QTc prolongation cumulative; - Serotonin syndrome (multiple serotonergic); - Sedative additive; (5) Anticholinergic burden — falls, delirium, cognitive; (6) Renal/hepatic adjustment; (7) Cumulative bleeding risk multiple agents; (8) Withdrawal considerations — opioid, benzo, alcohol, nicotine, baclofen; (9) Multidisciplinary: - Pharmacist consultation; - Geriatric medicine; - Specialty consultations; (10) De-prescribing as appropriate long-term; (11) Modern: pre-op clinic medication reconciliation + optimization

---

Polypharmacy elderly: Beers Criteria + STOPP/START review, individualized hold/continue, address PIMs, anticholinergic burden, drug interactions, withdrawal considerations. Pharmacist + geriatric consult. Pre-op clinic.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 75 ปี — emergent surgery for SBO
Polypharmacy: 12 medications + DOAC + furosemide + amiodarone + warfarin + ACE-I + ASA
History: AFib, HFpEF, CKD, T2DM';

update public.mcq_questions
set choices = '[{"label":"A","text":"Refuse care"},{"label":"B","text":"Infective endocarditis + IVDU"},{"label":"C","text":"Single discipline"},{"label":"D","text":"Stigmatize patient"},{"label":"E","text":"Skip TEE"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Infective endocarditis + IVDU — cardiac anesthesia: (1) Multidisciplinary endocarditis team — cardiology + cardiac surgery + infectious disease + anesthesia + addiction medicine; (2) Pre-op optimization: - Antibiotics — appropriate based on organisms (MSSA, MRSA, Strep, enterococci, fungi); typically 4-6 weeks; surgery often before completion if indication; - Source control; - Echo (TTE + TEE) to characterize valve + vegetations + complications (abscess, fistula); - Cardiac assessment (heart failure, arrhythmia); - Embolic complications screen (CNS, splenic, renal); - Renal function (drug-induced, AKI from sepsis); - Substance use evaluation; (3) Surgical indications: - Heart failure refractory medical Mx; - Uncontrolled infection (large vegetation, abscess, embolic events); - Prosthetic valve endocarditis; - Specific organisms (fungal, MDR); (4) Anesthesia considerations: - Multivalvular disease — complex hemodynamics; - Anti-emboli precautions; - Possibly endocarditis prophylaxis sub-optimal; - Hemodynamic instability risk; - Cerebral vegetation/embolic stroke risk; - TEE crucial; - CPB considerations; (5) IVDU-specific: - Tolerance opioid + benzodiazepine — increased anesthetic + analgesic doses; - Risk withdrawal (heroin, methadone); coordinate with addiction medicine; - Blood-borne illness (HIV, hepatitis B + C) — universal precautions, antiretrovirals; - Vascular access difficult (sclerosed veins); central access; - Possible recurrence — discuss with patient + family; (6) Addiction medicine: - Methadone or buprenorphine bridge if appropriate; - Treatment plan post-op (residential, outpatient); - Naloxone education; (7) Stigma awareness — patient deserves equitable care; (8) Multidisciplinary post-op: - ICU; - Anticoagulation if mechanical valve; - Antibiotic continuation; - Addiction treatment; - Mental health; (9) Modern: combined cardiothoracic + addiction programs improve outcomes; ethical considerations regarding repeat surgery in active IVDU

---

Endocarditis + IVDU: multidisciplinary endocarditis team, antibiotics + source control + surgical indications, TEE essential, IVDU considerations (tolerance, withdrawal, vascular access), addiction medicine coordination, stigma-free care.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 28 ปี healthy, IV drug user, presenting with infective endocarditis aortic + mitral valve
Vegetations large + new AR moderate-severe
Hemodynamically stable but planned valve surgery';

update public.mcq_questions
set choices = '[{"label":"A","text":"Crystalloid only"},{"label":"B","text":"Severe PPH + coagulopathy"},{"label":"C","text":"Single uterotonic"},{"label":"D","text":"Avoid TXA"},{"label":"E","text":"Stop transfusion"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe PPH + coagulopathy: (1) Activate MTP if not already; (2) Stop bleeding source: - Uterotonics maximal (oxytocin + methergine + carboprost + misoprostol); - Surgical interventions: balloon (Bakri), B-Lynch, uterine artery ligation, hysterectomy; - IR embolization if available + stable; (3) Balanced transfusion 1:1:1 PRBC:FFP:Plt; (4) Fibrinogen replacement aggressive: - Target > 2 g/L (PPH may need > 2.5); - Cryoprecipitate 10 units OR fibrinogen concentrate 4 g; - Critical for clot strength; (5) TXA 1g IV if not given (WOMAN trial — within 3h reduces death); (6) Calcium replacement (citrate); (7) Warm fluids + products + patient; (8) Avoid acidosis + hypothermia (lethal triad); (9) Monitoring: - Arterial line; - Continuous Hb (HemoCue); - TEG/ROTEM if available; - Lactate; - Urine output; (10) Anesthesia: - GA if instability requires; - Ketamine + opioid CV stable; - Vasopressors (norepinephrine first-line); - Inotropes if cardiogenic; (11) Cell salvage acceptable in OB now (post-2007 confirmation); (12) REBOA (Resuscitative Endovascular Balloon Occlusion of Aorta) — emerging for refractory; (13) Post-op: - ICU; - Continued bleeding monitoring; - Sheehan syndrome screening; - DIC; - AKI; - ARDS; - Renal replacement if needed; - Psychological support (PTSD, postpartum depression); (14) Multidisciplinary: OB + anesthesia + IR + ICU + hematology + blood bank

---

Severe PPH + coagulopathy: MTP 1:1:1, fibrinogen target > 2 (cryo/concentrate), TXA, Ca, warm, surgical control. TEG-guided. Norepi. Cell saver OB OK. REBOA emerging. ICU. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 30 ปี G3P2 GA 36 wk — major obstetric hemorrhage after vaginal delivery 2L+ blood loss
Uterotonics escalated
Now shock with INR 1.8, fibrinogen 1.0 g/L, plt 80k';

update public.mcq_questions
set choices = '[{"label":"A","text":"Propofol bolus + hyperventilate"},{"label":"B","text":"Congenital heart disease neonatal anesthesia (Tet)"},{"label":"C","text":"Decrease SVR"},{"label":"D","text":"Allow dehydration"},{"label":"E","text":"Vasodilator first"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Congenital heart disease neonatal anesthesia (Tet): (1) Tetralogy of Fallot — VSD + RVOT obstruction + overriding aorta + RV hypertrophy; cyanosis from R-to-L shunt across VSD; (2) Tet spells (hypercyanotic episodes): - Triggered by — crying, dehydration, fever, induction; - Treatment: knee-chest position (increase SVR + reduce R-to-L shunt); 100% O2; morphine (sedation + reduces sympathetic + reduces infundibular spasm); phenylephrine (increases SVR); fluid bolus; propranolol (reduces infundibular spasm + tachycardia); bicarbonate if acidotic; ECMO if refractory; (3) Anesthetic considerations: - Avoid hypovolemia + tachycardia + decreased SVR — all worsen R-to-L shunt; - Maintain SVR (phenylephrine); - Maintain preload (fluid); - Avoid PVR increases (hypoxia, hypercapnia, acidosis, cold) — worsen R-to-L; - Adequate sedation pre-induction (cry → tet spell); - Smooth induction (ketamine preferred — maintains SVR + HR; etomidate alternative); avoid propofol bolus + high volatile (vasodilation); - Adequate depth before stimulation; - Antifibrinolytic for cardiac surgery; (4) Surgical options: - Modified Blalock-Taussig shunt (subclavian to PA) — palliation; - Complete repair (VSD closure + RVOT augmentation) — definitive; (5) Pre-op: - Echo (anatomy); - Hemoglobin (polycythemia from chronic hypoxia — phlebotomy if Hct > 65); - Bleeding considerations (coagulopathy from polycythemia); - Family preparation; (6) Anti-infective endocarditis prophylaxis; (7) Specific drug choices: - Ketamine 1-2 mg/kg (maintains SVR + HR); - Phenylephrine bolus 1-5 mcg/kg for SVR; - Fentanyl 5-10 mcg/kg; - Rocuronium; (8) Monitoring: - Arterial line; - SpO2 + EtCO2; - Cerebral oximetry useful; - TEE intraop; (9) Multidisciplinary pediatric cardiac team

---

Tet: maintain SVR + preload + adequate depth, avoid PVR increases. Tet spell: knee-chest + O2 + morphine + phenylephrine + propranolol. Ketamine induction. Modified BT shunt vs complete repair.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยทารกแรกเกิด 36 wk GA 2.4 kg — congenital heart disease (tetralogy of Fallot) requires palliative shunt
Not ductal-dependent but cyanosis worsening, SpO2 78% on RA';

update public.mcq_questions
set choices = '[{"label":"A","text":"No antibiotics"},{"label":"B","text":"Ventilator-Associated Pneumonia (VAP) / Hospital-Acquired Pneumonia"},{"label":"C","text":"Continue support"},{"label":"D","text":"Ignore CXR"},{"label":"E","text":"Sedate more"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Ventilator-Associated Pneumonia (VAP) / Hospital-Acquired Pneumonia: (1) Definitions: - VAP: > 48h after intubation; - HAP: > 48h after hospital admission; - Post-extubation can blur with VAP for recently extubated; (2) Diagnosis: - Fever + leukocytosis + purulent secretions + hypoxia + new infiltrate; - Lower sensitivity in critically ill (other infiltrate causes — atelectasis, edema, ARDS, hemorrhage); - Bronchoalveolar lavage (BAL) or non-bronchoscopic mini-BAL; - Quantitative culture + threshold; - Procalcitonin (sensitivity moderate); (3) Empiric antibiotics — IDSA/ATS 2016 guidelines: - Cover S. aureus, Pseudomonas, gram-negative; - Vancomycin or linezolid (MRSA); - Cefepime, pip-tazobactam, or carbapenem (MDR risk); - Aminoglycoside or fluoroquinolone if high MDR risk; - De-escalate per culture (48-72h); - Duration 7 days standard (not 14); (4) Prevention bundle (VAP bundle): - HOB > 30° (semi-recumbent); - Oral care chlorhexidine; - SAT/SBT daily (extubate ASAP); - Stress ulcer prophylaxis; - DVT prophylaxis; - Subglottic suction ETT; - Cuff pressure 20-30; - Minimize sedation; - Hand hygiene; (5) Post-extubation considerations: - Aspiration risk; - Diaphragm dysfunction (ICU-acquired weakness); - Atelectasis; - Multimodal pulmonary toilet; (6) Risk factors VAP: - Prolonged ventilation; - Sedation/paralysis; - Reintubation; - Aspiration; - Supine position; - Comorbid (COPD, ARDS); (7) Outcomes: - Mortality 20-50% VAP; - Increased LOS + cost; (8) Modern: minimizing ventilation + aggressive prevention bundle

---

VAP/HAP: fever + WBC + secretions + infiltrate. Empiric MRSA + Pseudomonas coverage, de-escalate, 7 days. Bundle prevention (HOB, oral care, SAT/SBT, subglottic suction). Modern minimization.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 60 ปี — extubated ICU day 3 after major surgery
Develops fever 38.5°C, hypoxia SpO2 88% on 6L O2, productive cough, rhonchi RML
WBC 16k, CXR new RML infiltrate';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue surgery routine"},{"label":"B","text":"Perioperative myocardial infarction"},{"label":"C","text":"Ignore troponin"},{"label":"D","text":"Aggressive surgery"},{"label":"E","text":"Refuse cardiology"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Perioperative myocardial infarction: (1) Recognition — anginal symptoms may be masked (sedation, analgesia, post-op confusion); silent MI common (50%); ECG changes + troponin elevation key; (2) Classification: - Type 1 — plaque rupture, thrombosis; - Type 2 — supply-demand mismatch (most common perioperative — anemia, tachycardia, hypotension, hypoxia); (3) Management — depends on type + clinical: - Type 1 (STEMI or NSTEMI with high-risk features): - Cardiology consult urgent; - PCI consideration (timing depends on bleeding risk + surgical wound — often delayed primary PCI 24-72h); - Dual antiplatelet (DAPT) — ASA + clopidogrel — balance bleeding risk surgical; - Anticoagulation careful; - Beta-blocker, statin (continued/added); - Type 2: address underlying — transfuse, control HR/BP, oxygenate, treat pain; medical management; (4) Hemodynamic optimization: - HR < 80 (beta-blocker); - BP control (avoid extremes); - Adequate oxygenation; - Hb > 7-9 (debate); - Adequate analgesia (sympathetic surge); - Hemostatic control; (5) Imaging: - Echo (LV function, regional WMA); - Coronary angiography selective; (6) Cardiology consultation + multidisciplinary; (7) Risk stratification — RCRI, ACS-NSQIP, NSQIP-Gupta MICA, AUB-HAS2; (8) Prevention: - Continuation cardio-protective medications (statin, beta-blocker); - Optimize comorbidities; - Anemia avoidance; - Multimodal pain control; - Identification high-risk patients; (9) Outcomes — perioperative MI associated with high mortality (5-25%); (10) MINS (Myocardial Injury after Non-cardiac Surgery) — troponin elevation without classical MI criteria; increasingly recognized + treated as significant marker risk + therapeutic target

---

Perioperative MI: Type 1 (plaque) vs Type 2 (supply-demand). Cardiology consult, DAPT vs bleeding risk, hemodynamic optimization. MINS recognition. RCRI risk stratification. Multidisciplinary + prevention.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 70 ปี post-major surgery day 1 — sudden chest pain + ST elevation V1-V4 + cardiac biomarkers rising
BP stable, no overt heart failure';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait + observe"},{"label":"B","text":"Post-bariatric surgical complication"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Ignore tachycardia"},{"label":"E","text":"Routine post-op care"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-bariatric surgical complication: (1) DDx urgent: - Anastomotic leak (sleeve gastrectomy staple line leak — most feared); - Bleeding; - PE/DVT; - Sepsis (other source); - Cardiogenic; - Adrenal insufficiency; - Bowel obstruction; (2) Sleeve leak features: - Tachycardia + tachypnea early (often before pain or fever); - Fever; - Hypotension; - Leukocytosis; - Tachycardia > 120 = ominous sign; - Pain location variable (LUQ to L shoulder referred); - SOB; - Lactate elevation; (3) Diagnostic: - CT with PO + IV contrast (extravasation); - Upper GI series (water-soluble); - Endoscopy diagnostic + therapeutic; - Exploration if unstable; (4) Management: - NPO + NG decompression (controversial — endoscopic better); - IV fluids + electrolytes; - Broad-spectrum antibiotics (gram-negative + anaerobic); - Drain (percutaneous IR or surgical); - Endoscopic stent (sleeve leaks); - Surgical revision (massive leak, sepsis); - ICU monitoring; (5) PE/DVT — bariatric high risk: - Dyspnea, tachycardia, hypoxia; - CTPA; - Heparin anticoagulation; - Catheter-directed thrombolysis selected; - IVC filter selected; (6) Multidisciplinary: - Bariatric surgery; - General surgery; - IR; - Anesthesia (if OR); - ICU; - Nutrition; (7) Anesthesia for reoperation: - Difficult airway (obesity); - Aspiration risk; - Hemodynamic considerations sepsis; - Multimodal opioid-sparing (avoid NSAID after bariatric); - Regional techniques; (8) Outcomes — early recognition + intervention critical; (9) Modern: increased bariatric surgery, complications, standardized protocols

---

Post-bariatric crisis: think LEAK (tachy first sign), DDx PE/bleeding/sepsis. CT + endoscopy diagnostic. Antibiotics + drainage + stent or surgical. ICU. Multidisciplinary. Avoid NSAID post-bariatric.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 45 ปี post-bariatric sleeve gastrectomy POD 3 ICU — sudden tachycardia + hypotension + AKI + worsening confusion + abdominal pain
WBC 18k, lactate 4, fever 38.6';

update public.mcq_questions
set choices = '[{"label":"A","text":"Succinylcholine RSI"},{"label":"B","text":"Major burn anesthesia"},{"label":"C","text":"Routine doses"},{"label":"D","text":"No fluid"},{"label":"E","text":"Skip airway"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Major burn anesthesia: (1) Initial assessment ABCDE + burn-specific: - Airway — burns to face, neck, oropharynx → progressive edema → early intubation (within 4-6h); inhalational injury; - Breathing — circumferential chest burns may need escharotomy; - Circulation — fluid resuscitation Parkland: 4 mL × kg × %TBSA = 24h fluid; half in first 8h from time of burn; LR most common; modern reduces with adequate UO; - Disability — neuro; - Exposure — keep warm; (2) Inhalational injury: - Singed nasal hairs, soot, hoarse, stridor, carbonaceous sputum; - Carboxyhemoglobin (CO) + cyanide poisoning; treat with 100% O2 + hydroxocobalamin; - Early intubation (airway swelling progresses 24-48h); - Bronchoscopy diagnostic; (3) Fluid resuscitation: - Parkland formula starting point; - Titrate to UO 0.5 mL/kg/hr adult (1 mL/kg pediatric); - Avoid over-resuscitation (fluid creep, ACS, ARDS); - Albumin debated, often added 12-24h; - Vitamin C high-dose protocol (modern); (4) Anesthetic considerations: - Difficult airway anticipated (edema, distortion); - Hypermetabolism + increased MAC after 48h burn; - Hypercatabolism + nutrition needs; - Hemodynamic instability; - Hypothermia risk; - Vascular access difficult; - Renal + hepatic dysfunction; - Coagulopathy + DIC; (5) Drug pharmacology: - Succinylcholine — AVOID > 24h post-burn (hyperkalemic arrest); use rocuronium; - NMB resistance — increased doses non-depolarizing; - Opioid tolerance + increased requirements; - Volatile resistance; (6) Pain management: - Severe burn pain + procedural pain; - Multimodal — opioid PCA, ketamine, gabapentinoid, regional (limited by burn location), dexmedetomidine; - Procedural sedation for dressing changes; (7) Surgery — early excision + grafting; multiple surgeries; (8) Sepsis risk high — burn wound infection; antibiotics judicious; (9) Multidisciplinary burn center; (10) Long-term — physical + psychological rehabilitation

---

Major burn: ABCDE + early airway, Parkland fluid (titrate to UO), inhalational injury (CO + cyanide), AVOID sux > 24h, NMB resistance, opioid tolerance + multimodal, multidisciplinary burn center.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 25 ปี — major burn 35% TBSA — emergency escharotomy + ongoing resuscitation
Burns chest, abdomen, both arms
Fluid resuscitation Parkland formula started';

update public.mcq_questions
set choices = '[{"label":"A","text":"Diuretic only"},{"label":"B","text":"Negative Pressure Pulmonary Edema (NPPE) post-laryngospasm/airway obstruction"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Ignore symptoms"},{"label":"E","text":"Continue without intervention"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Negative Pressure Pulmonary Edema (NPPE) post-laryngospasm/airway obstruction: (1) Pathophysiology — forced inspiration against closed glottis → very negative intrapleural pressure → increased hydrostatic gradient → transudation alveoli; (2) Common settings: - Post-laryngospasm (most common in peds T+A); - Biting ETT (Type II NPPE); - Upper airway obstruction; - OSA; - Strangulation; (3) Clinical features: - Onset minutes after obstruction relieved; - Frothy/pink secretions; - Hypoxia; - Dyspnea, tachypnea; - Bilateral crackles; - Normal cardiac function (vs cardiogenic edema); (4) Diagnosis — clinical + CXR (bilateral pulmonary edema); echo to rule out cardiac (LV normal); (5) Management: - 100% O2; - Positive pressure ventilation (CPAP non-invasive or intubate + PEEP); - Furosemide selective (volume status concern in NPPE — usually euvolemic so questionable benefit); - Supportive — usually self-limited 12-24h; - Steroids questionable; (6) ICU/step-down monitoring; (7) Avoid: - Excessive fluid; - Repeat airway obstruction; (8) Prevention: - Laryngospasm prevention/treatment; - Pediatric airway expertise; - Magnesium adjunct; - Multimodal opioid-sparing; (9) Outcome — generally good with prompt recognition; (10) Pediatric considerations: - Smaller airway → more obstruction risk; - Rapid desaturation; - Cardiopulmonary reserve limited; - Family communication; - Observation 24h; (11) Modern: awareness + recognition; bedside ultrasound (B-lines)

---

NPPE: post-laryngospasm/airway obstruction → very negative pressure → pulmonary edema. Frothy/pink secretions, hypoxia. Mx: CPAP/PEEP, O2, supportive, usually 12-24h. Prevent: laryngospasm + multimodal anesthesia.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยทารก 1 ปี 10 kg — post-op tonsillectomy + adenoidectomy, recovering in PACU
Develops progressive hypoxia, pink frothy secretions from airway, dyspnea
No bleeding evident';

update public.mcq_questions
set choices = '[{"label":"A","text":"Mass NMB doses"},{"label":"B","text":"Myasthenia gravis (MG) anesthesia"},{"label":"C","text":"Use sux high dose"},{"label":"D","text":"Magnesium routine"},{"label":"E","text":"Ignore TOF"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Myasthenia gravis (MG) anesthesia: (1) Pathophysiology — autoantibodies vs nicotinic acetylcholine receptors at NMJ → fluctuating weakness; (2) Pre-op: - Continue anticholinesterase (pyridostigmine) — debate timing of last dose pre-op (some hold to better assess intra-op NMB, others continue); - Assess severity (Osserman classification); - Pulmonary function (FVC) — predictor post-op ventilation; - Consider plasmapheresis or IVIG pre-op for severe; - Steroid stress dose if on chronic; - Multidisciplinary planning (neurology); (3) NMB considerations: - SENSITIVE to non-depolarizing NMB — reduce dose (rocuronium 0.3 mg/kg, 1/4 normal); titrate with TOF; - RESISTANT to succinylcholine (need higher dose 1.5-2 mg/kg); avoid generally; - Sugammadex 2-4 mg/kg for reversal — preferred over neostigmine (which paradoxically may worsen weakness in cholinergic crisis); - Quantitative TOF mandatory; (4) Volatile anesthetic potentiates weakness — be aware; (5) TIVA reasonable alternative — propofol + remifentanil; (6) Regional anesthesia useful adjunct (reduces opioid + NMB needs); (7) Drug interactions: - Avoid aminoglycosides (potentiate weakness); - Avoid certain antiarrhythmics (procainamide, quinidine); - Avoid magnesium (potentiates NMB); - Stress dose steroids if applicable; (8) Post-op concerns: - Myasthenic crisis vs cholinergic crisis (both cause weakness — differentiate); - Edrophonium test (rarely used now); - Plasmapheresis/IVIG; - Mechanical ventilation may be needed; (9) Risk factors post-op ventilation: - Duration MG > 6 years; - FVC < 2.9 L; - High pyridostigmine dose; - COPD; - Major intra-op blood loss; (10) Post-op monitoring ICU; multidisciplinary

---

MG: sensitive non-depolarizing NMB (1/4 dose), sugammadex reversal preferred, quantitative TOF, continue pyridostigmine, avoid aminoglycosides + magnesium. Post-op monitor for crisis. Plasmapheresis/IVIG. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 55 ปี — myasthenia gravis chronic on pyridostigmine — elective thymectomy
Mild generalized weakness, no recent crisis
FVC 75% predicted';

update public.mcq_questions
set choices = '[{"label":"A","text":"Stop levodopa"},{"label":"B","text":"Parkinson disease + anesthesia"},{"label":"C","text":"Use metoclopramide"},{"label":"D","text":"Heavy sedation"},{"label":"E","text":"Ignore DBS"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Parkinson disease + anesthesia: (1) Pre-op: - Continue PD medications maximally (carbidopa-levodopa) — schedule around surgery; - Last dose pre-op timed; - Resume ASAP post-op via NG or PR (if PO not tolerated); - Withdrawal precipitates ''off'' periods + rigidity + risk neuroleptic malignant-like syndrome; - MAO-B inhibitor (selegiline) — typically continue; older non-selective MAOIs require drug interaction caution; (2) Drug interactions/avoidances: - Avoid antiemetics that block D2 (metoclopramide, droperidol, prochlorperazine, haloperidol) — worsen parkinsonism; - Ondansetron acceptable; - Avoid meperidine (serotonin syndrome with MAOI); - Cautious with sympathomimetic + MAOI (hypertensive crisis); - Avoid neuroleptic; (3) DBS considerations: - Verify with neurologist if DBS should remain on or be turned off intra-op; usually turned off if electrocautery (electromagnetic interference + heating); bipolar cautery preferred; - Pacemaker-like considerations; - Programming reassessment post-op; - MRI considerations (some DBS MRI-conditional); (4) Anesthetic technique: - Regional preferred when possible (avoid GA + reduces medication interaction); - GA: propofol OK, sevoflurane OK, fentanyl/remifentanil OK; - Avoid heavy sedation/long-acting opioid if PD with cognitive issues; - Aspiration risk (autonomic dysfunction, swallowing); - Postoperative confusion + delirium risk; (5) Autonomic dysfunction: - Orthostatic hypotension — careful position changes, IV fluid; - Tachycardia/bradycardia; - Constipation; - Urinary retention; (6) Aspiration risk — RSI considerations; (7) Post-op: - Resume PD meds urgently; - Multimodal opioid-sparing analgesia; - Early mobilization; - Aspiration precautions; - Delirium prevention bundle; (8) Multidisciplinary: anesthesia + surgery + neurology; (9) Modern: increasing PD population + DBS implants

---

PD: continue carbidopa-levodopa, AVOID D2 antagonists (metoclopramide, droperidol), DBS off for cautery + bipolar, regional preferred, aspiration + delirium prevention. Resume PD meds urgently post-op. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 60 ปี Parkinson disease 10 ปี + DBS implanted — elective surgery
Meds: carbidopa-levodopa, MAO-B inhibitor selegiline
Mild dyskinesia, tremor controlled';

update public.mcq_questions
set choices = '[{"label":"A","text":"Skip neuraxial"},{"label":"B","text":"Twin C-section + obesity + PEC + DM"},{"label":"C","text":"Routine anesthesia"},{"label":"D","text":"Heavy sedation"},{"label":"E","text":"Ignore comorbidities"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Twin C-section + obesity + PEC + DM — high-risk OB anesthesia: (1) Multiple risk factors compound complications; (2) Airway: - Obesity + pregnancy + PEC edema = anticipated difficult; - Pre-O2 thorough (rapid desaturation); - Ramped position; - Video laryngoscopy first; - Difficult airway equipment ready; (3) Anesthetic technique decision: - Neuraxial preferred if no contraindication; - Platelets (PEC) — generally OK > 70-80k; - Spinal vs epidural vs CSE; - Spinal may have profound hypotension in twins (higher uterine pressure, multiple); titrated dose lower; - CSE good balance — flexible duration + reduced dose; (4) Hemodynamic considerations: - Aortocaval compression worse in twins + obesity (left lateral tilt 30°); - Magnesium effects (mild vasodilation, NMB potentiation); - PEC — pulmonary edema risk (cautious fluids); - PEC — avoid HTN surge at intubation if GA; (5) Glucose management — gestational DM: - Insulin sliding scale or infusion; - Target intra-op 100-180; - Avoid hypoglycemia (fetal effects); (6) Multiple babies — neonatal team ready, separate teams ideal; (7) Post-partum considerations: - Atony risk increased (twins, magnesium); aggressive uterotonic; - PEC — continue magnesium 24h, BP control, fluid balance, pulmonary edema risk, eclampsia, AKI; - Thromboembolic prophylaxis (obese + PEC + post-op); - Pain control — multimodal, neuraxial morphine, intrathecal hydromorphone, TAP block, acetaminophen + NSAID (post-delivery OK); (8) ICU/HDU monitoring; (9) Glycemic management transition postpartum; (10) Multidisciplinary: OB + anesthesia + neonatology + MFM + ICU + nursing

---

High-risk OB: difficult airway, neuraxial preferred (platelets > 80k), aortocaval compression worse twins/obesity, magnesium + PEC + DM + atony management. Multidisciplinary. ICU postpartum. Multimodal analgesia.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 28 ปี G2P1 GA 30 wk — twin pregnancy, severe pre-eclampsia
Magnesium running, BP controlled
Weight 95 kg, BMI 38, gestational diabetes
C-section planned';

update public.mcq_questions
set choices = '[{"label":"A","text":"No anesthesia needed"},{"label":"B","text":"ECT anesthesia"},{"label":"C","text":"Heavy sedation continuous"},{"label":"D","text":"Skip NMB"},{"label":"E","text":"Avoid ECT all patients"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** ECT anesthesia: (1) Goals — induce brief generalized seizure (> 25 seconds) under anesthesia with NMB; (2) Pre-procedure: - Medical clearance (cardiac, neuro); - NPO; - IV access; - Standard ASA monitoring + EEG/EMG; - Mouthguard (protect teeth from masseter contraction); (3) Anesthetic technique: - Induction: methohexital (traditional) 1-1.5 mg/kg OR propofol 0.5-1 mg/kg (less seizure duration); etomidate alternative (longer seizure); ketamine 0.5-1 mg/kg (longer + better quality seizures, used for refractory); - Pre-oxygenate; - NMB: succinylcholine 0.5-1 mg/kg (lower dose than RSI — purpose is to attenuate convulsion not full paralysis); rocuronium + sugammadex alternative; - Mask ventilation during seizure (no intubation typically); - Glycopyrrolate pre-treatment (secretions + bradycardia); (4) Cardiovascular: - Initial parasympathetic surge (bradycardia, asystole) — atropine if severe; - Then sympathetic surge (tachycardia, hypertension) — beta-blocker (esmolol or labetalol) or labetalol pre-treatment for cardiac patients; - Monitor closely; (5) Cerebral: - Increased CBF, ICP, IOP, intragastric pressure transient; - Caution in space-occupying lesion, recent stroke, increased ICP; (6) Seizure parameters: - Target 25-60 seconds; - Inadequate: increase stimulus, change anesthetic (ketamine), reduce anesthetic if too deep, hyperventilate, withhold benzo, caffeine 500 mg pre-treatment; (7) Drug considerations: - SSRI continue (no contraindication); - MAOI (caution sympathomimetic interaction); - Lithium — neurotoxicity risk increased — debate continue vs hold; - Benzodiazepines decrease seizure (hold if possible); - Anticonvulsants for non-ECT reasons — debate; (8) Recovery: - Headache, confusion, myalgia common; - Anterograde amnesia (treatment + side effect); - Multimodal post-ECT (acetaminophen, ondansetron); (9) Series of treatments; (10) Multidisciplinary: psychiatry + anesthesia + nursing

---

ECT anesthesia: methohexital/propofol/ketamine + sux + mask ventilation. Glycopyrrolate. Treat parasympathetic then sympathetic surge. Seizure 25-60 sec target. Hold benzo. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 70 ปี — anesthesia for ECT (Electroconvulsive Therapy) for severe depression refractory
5 sessions weekly
On citalopram, mirtazapine';

update public.mcq_questions
set choices = '[{"label":"A","text":"Stop ART"},{"label":"B","text":"HIV/AIDS perioperative care"},{"label":"C","text":"Refuse care"},{"label":"D","text":"Treat as terminal"},{"label":"E","text":"Hide diagnosis"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** HIV/AIDS perioperative care: (1) Effective ART has transformed HIV from terminal to chronic — perioperative care similar to non-HIV in well-controlled patients; (2) Pre-op assessment: - CD4 count + viral load; well-controlled (CD4 > 200, undetectable VL) — comparable outcomes; - Comorbidities: cardiovascular (accelerated atherosclerosis), renal (HIV-associated nephropathy + tenofovir), bone (osteoporosis), neuropathy, depression; - Opportunistic infections screen; - Drug interactions; (3) Continue ART perioperatively: - Avoid interruption (resistance, viral rebound); - Coordinate with HIV specialist if NPO prolonged; - Some IV formulations available; (4) Drug interactions: - Protease inhibitors + integrase inhibitors — CYP3A4 effects; - Boosted regimens (ritonavir, cobicistat) — many interactions: midazolam, fentanyl (increased levels), opioids; - Anesthetic implications variable; - Methadone interactions; (5) Universal precautions — standard for all patients (HIV status often unknown); (6) Anesthetic technique — no specific contraindications; regional anesthesia OK; (7) Wound healing — comparable to non-HIV in well-controlled; AIDS (CD4 < 200) may have impaired healing; (8) Infection risk: - Comparable in well-controlled; - Antibiotic prophylaxis standard; - Opportunistic infection screen (CMV, PCP, TB) — selective; (9) Healthcare worker considerations: - Standard precautions; - Post-exposure prophylaxis (PEP) if exposure; - Hepatitis B + C considerations; (10) Stigma awareness — confidentiality + equitable care; (11) Psychiatric — depression, substance use, social factors; (12) Modern: HIV similar to other chronic illness, integrated care

---

HIV well-controlled: similar outcomes, continue ART, drug interactions (PI, integrase, boosted), universal precautions, no special anesthetic contraindications. Confidentiality + equitable care. Modern: chronic illness paradigm.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 50 ปี HIV+ controlled on ART, CD4 450, undetectable VL — elective ortho surgery
Meds: dolutegravir/abacavir/lamivudine, statins
No opportunistic infections';

update public.mcq_questions
set choices = '[{"label":"A","text":"Maximum FGF always"},{"label":"B","text":"Sustainable anesthesia practice"},{"label":"C","text":"Use desflurane preferentially"},{"label":"D","text":"Ignore sustainability"},{"label":"E","text":"Single-use only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Sustainable anesthesia practice: (1) Healthcare contributes 4-5% global greenhouse gases; anesthesia significant contributor; (2) Volatile anesthetics carbon footprint: - Desflurane WORST (2540× CO2 equivalent per kg, 14-year atmospheric lifetime); - Sevoflurane modest (130×, 1.1 year); - Isoflurane intermediate (510×, 3.2 year); - N2O significant (265×, 114 years); also ozone depleter; - 1 hour desflurane = driving 100 km; (3) Reduce volatile impact: - Lower FGF (fresh gas flow) 1-2 L/min — major reduction; - Avoid desflurane when alternatives appropriate; - Avoid N2O when alternatives; - TIVA reduces volatile entirely (but propofol packaging waste); - Charcoal-based volatile capture systems (Centurio, Deltasorb) emerging; (4) Other sustainability: - Reduce single-use plastic; - Reusable when safe + cost-effective; - Pharmaceutical waste reduction (right-sizing doses); - Equipment lifecycle assessment; - LED lighting + HVAC efficiency; - Local + sustainable supply chain; (5) Specific practices: - Open circuit avoid; - LMA reusable available; - Drug syringe sizing (avoid waste); - Procedure-appropriate equipment; (6) Patient + organizational benefits: - Cost savings (lower FGF, less waste); - Improved care continuity (greener operations); - Healthier workforce + community; (7) ASA Committee on Equipment + Facilities + Environmental Stewardship; (8) Code Green NHS UK + similar initiatives; (9) Personal + institutional advocacy: - Education + awareness; - Practice changes; - Procurement decisions; - Research; (10) Modern: regulatory pressure (EU desflurane ban 2026), accreditation incentives, anesthesia leadership in sustainability

---

Sustainability: anesthesia significant GHG. Desflurane WORST, N2O ozone depleter. Reduce FGF, avoid desflurane + N2O, TIVA option, charcoal capture. Plastic reduction. Cost savings + patient benefit. ASA + Code Green advocacy.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'EMS/Management: anesthesia for environmentally sustainable practice';

update public.mcq_questions
set choices = '[{"label":"A","text":"Avoid leadership"},{"label":"B","text":"Anesthesia leadership + administration"},{"label":"C","text":"Single-handed decisions"},{"label":"D","text":"Ignore finances"},{"label":"E","text":"Skip quality"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Anesthesia leadership + administration: (1) Roles: - Chief of Anesthesia; - Department chair; - Medical director OR/PACU; - Quality + safety officer; - Educational director; - Research director; - Wellness officer; - Equity, Diversity, Inclusion (EDI) officer; (2) Skills required: - Clinical credibility; - Vision + strategic planning; - Communication + interpersonal; - Conflict resolution; - Financial management; - Quality improvement; - Operations + workflow; - Personnel management; - Mentorship; (3) Operating room management: - Block scheduling; - Add-on management; - First case on-time start; - Turnover; - Utilization metrics; - Surgeon + nurse coordination; (4) Financial: - Reimbursement (insurance, value-based); - Coding (CPT, ASA, modifiers, time-based, units); - Productivity (RVU); - Cost management; - Investment decisions (equipment, technology); (5) Quality + safety: - Adverse event review; - Quality improvement projects (PDSA); - Benchmarking (NACOR, MIPS); - Risk management; - Credentialing + privileging; (6) Educational: - Resident program; - CME; - Simulation; - Faculty development; (7) Research: - IRB; - Funding; - Mentorship; - Collaboration; (8) Workforce: - Recruitment; - Retention; - Mentorship; - Wellness; - Burnout; - Succession planning; (9) Patient experience: - Satisfaction surveys; - HCAHPS; - Communication training; (10) Interdisciplinary collaboration: - Surgical specialties; - Nursing; - Hospital administration; - Insurance + payers; - Community; (11) Modern: data-driven, value-based care, telemedicine, AI integration; (12) Professional organizations: - ASA, ASAM, ARAS — engagement + advocacy

---

Anesthesia leadership: vision + strategic + operations + financial + quality + workforce + education + research. Multidisciplinary. Modern: data-driven, value-based. Professional engagement. EDI + wellness focus.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'EMS/Management: anesthesia leadership + administration';

update public.mcq_questions
set choices = '[{"label":"A","text":"Skip oximetry"},{"label":"B","text":"Pulse oximetry + capnography physics"},{"label":"C","text":"100% accurate always"},{"label":"D","text":"Ignore limitations"},{"label":"E","text":"Single wavelength"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pulse oximetry + capnography physics: (1) Pulse oximetry: - Principle: Beer-Lambert law — absorption of red (660 nm) + infrared (940 nm) light by oxy- vs deoxyhemoglobin; - Pulsatile flow = arterial signal (ratio of pulsatile absorption red:IR converted to SpO2); - Accuracy ± 2% above SpO2 90%; (2) Limitations: - Motion artifact; - Poor perfusion (hypothermia, shock, vasoconstrictor); - Nail polish, henna; - Dyshemoglobinemia: - Carboxyhemoglobin (CO poisoning) — falsely HIGH (co-ox needed); - Methemoglobinemia — reads ~85% regardless of true; - Sulfhemoglobin; - Anemia — accuracy maintained until severe; - Ambient light interference; - Dye (methylene blue, indigo carmine — temporary drop); - Skin pigmentation — recent concerns of bias in dark skin (FDA review); (3) Pulse co-oximetry (Masimo) — measures additional wavelengths for SpCO, SpMet, SpHb (continuous Hb); (4) Capnography: - Infrared absorption (CO2 absorbs specific IR); - Mainstream (heated, in airway) vs sidestream (sample drawn out); - Time-based waveform — 4 phases; - Volumetric capnography emerging; (5) Limitations: - Delay sidestream; - Water + secretions; - Disconnection misread as zero; - High RR/short breaths may underestimate; (6) Clinical applications (covered separately); (7) Other monitoring: - Cerebral oximetry (NIRS) — regional brain O2 (rSO2); useful cardiac, beach chair, complex; - SedLine + BIS — processed EEG depth; - Esophageal Doppler — CO; - Pulse contour CO analysis (FloTrac, LiDCO); (8) Standards — continuous SpO2 + capnography for anesthesia + moderate/deep sedation; (9) Modern: integrated multi-parameter monitors, wearable continuous monitoring

---

Pulse ox: Beer-Lambert, R+IR ratio. Limitations: motion, perfusion, CO/MetHb, anemia, pigmentation. Capnography: IR absorption. Limitations: water, RR. NIRS/BIS/Doppler/pulse contour. Standards continuous.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Basic science: physics of monitoring — pulse oximetry + capnography';

update public.mcq_questions
set choices = '[{"label":"A","text":"Use sux + volatile"},{"label":"B","text":"Muscular dystrophies + anesthesia"},{"label":"C","text":"Adult routine doses"},{"label":"D","text":"Ignore cardiac"},{"label":"E","text":"Refuse care"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Muscular dystrophies + anesthesia: (1) Categories: - Duchenne (DMD) + Becker (BMD) — X-linked; - Myotonic dystrophy — autosomal dominant; - Limb-girdle; - Facioscapulohumeral; (2) DMD: - Progressive proximal weakness, cardiomyopathy, scoliosis, respiratory failure; - AVOID succinylcholine (hyperkalemic arrest, rhabdomyolysis); - AVOID volatile anesthetics (MH-like reactions — anesthesia-induced rhabdomyolysis); - Use TIVA (propofol + opioid); - Cardiac assessment (cardiomyopathy); - Pulmonary assessment (restrictive); - NMB cautious (non-depolarizing OK at reduced dose with TOF); - Spinal anesthesia OK if scoliosis allows; (3) Myotonic dystrophy: - Sustained muscle contraction (myotonia); - Multisystem involvement (cardiac conduction, GI, endocrine, CNS); - AVOID succinylcholine (sustained myotonic contraction); - Caution all NMB; - Sensitive to opioids, sedatives, volatile (respiratory depression); - Cardiac conduction abnormalities — pacing readiness; - Temperature regulation; - Multimodal opioid-sparing; - Regional anesthesia helpful; - Avoid neostigmine (may worsen myotonia); use sugammadex if rocuronium; (4) Anesthesia-Induced Rhabdomyolysis (AIR): - Similar to MH but distinct mechanism — sarcolemmal damage; - Volatile triggers; - Treatment: stop volatile, supportive, IVF + alkalinization for myoglobinuria, monitor K + CK; - NO dantrolene (different mechanism); (5) Cardiac considerations: - Cardiomyopathy → consider as such for management; - Conduction abnormalities → ECG, electrophysiology consult; (6) Respiratory: - Restrictive disease; - Cough impaired; - Risk post-op ventilatory failure; - Avoid long-acting opioid; (7) Multidisciplinary: anesthesia + neurology + cardiology + pulmonology + physical therapy

---

Muscular dystrophies: DMD/BMD avoid sux + volatile (AIR), TIVA. Myotonic: avoid sux (sustained contraction), conduction abnormalities, NMB caution. Cardiomyopathy + respiratory assessment. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Basic science: muscular dystrophies + anesthesia';

update public.mcq_questions
set choices = '[{"label":"A","text":"Single opioid only"},{"label":"B","text":"Anesthesia adjuvants"},{"label":"C","text":"Skip multimodal"},{"label":"D","text":"Adult only"},{"label":"E","text":"Avoid all adjuvants"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Anesthesia adjuvants — opioid-sparing: (1) Ketamine: - NMDA antagonist; - Sub-anesthetic dose 0.1-0.5 mg/kg bolus + 0.1-0.3 mg/kg/hr infusion; - Anti-hyperalgesic + analgesic + opioid-sparing; - Useful: chronic opioid users, opioid-induced hyperalgesia, complex regional pain syndrome, depression (intranasal esketamine FDA-approved); - Side effects: sympathomimetic (HTN, tachy), psychomimetic (hallucinations — combine with low-dose benzo), salivation; (2) Magnesium: - NMDA antagonist + Ca channel blockade + smooth muscle relaxation; - Loading 30-50 mg/kg + infusion 8-15 mg/kg/hr; - Reduces opioid requirement, post-op pain, PONV, shivering, asthma; - Side effects: hypotension, flushing, sedation, NMB potentiation, respiratory depression at high levels; - Monitor reflexes + RR + serum Mg; (3) Lidocaine infusion: - Na channel block; - Bolus 1.5 mg/kg + infusion 1-3 mg/kg/hr; - Anti-inflammatory + analgesic; - Reduces opioid + ileus + PONV; - Useful: abdominal surgery, spine, breast; - Side effects: LAST (CNS, CV) — monitor signs + symptoms; - Avoid in heart block, severe hepatic dysfunction; (4) Dexmedetomidine (covered separately): alpha-2 agonist, sedation + analgesia + sympatholysis, no respiratory depression; (5) Dexamethasone: - Steroid; 4-10 mg single dose; - Anti-inflammatory + antiemetic + analgesic + airway swelling; - Hyperglycemia concern minimal single dose; (6) Gabapentinoids (gabapentin, pregabalin): - Voltage-gated Ca channel modulation; - Pre-op 300-1200 mg gabapentin or 75-300 mg pregabalin; - Reduces opioid + acute pain + chronic pain prevention; - Side effects: sedation, dizziness, especially elderly; recent guidelines suggest selective use rather than routine; (7) Acetaminophen IV: 1g; consistent multimodal; (8) NSAID (ketorolac 15-30 mg, celecoxib 200-400 mg); (9) Modern: multimodal opioid-sparing routine for major surgery; ERAS protocols

---

Adjuvants: ketamine (NMDA, anti-hyperalgesic), magnesium (NMDA + Ca), lidocaine infusion (Na channel, anti-inflammatory), dex (anti-inflammatory + analgesic), gabapentinoid (selective use), acetaminophen + NSAID. ERAS multimodal opioid-sparing standard.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Basic science: pharmacology of common anesthesia adjuvants — ketamine, magnesium, lidocaine infusion';

update public.mcq_questions
set choices = '[{"label":"A","text":"Ignore ethics"},{"label":"B","text":"Anesthesia ethics"},{"label":"C","text":"Single principle only"},{"label":"D","text":"Hide errors"},{"label":"E","text":"Discriminate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Anesthesia ethics: (1) Core principles: - Autonomy — patient self-determination, informed consent; - Beneficence — act in patient''s best interest; - Non-maleficence — first, do no harm; - Justice — fair distribution + access; (2) Common ethical dilemmas: - DNR in OR (covered); - Jehovah''s Witness blood refusal; - Capacity + surrogate decisions; - Disclosure of error; - End-of-life care + withdrawal; - Resource allocation (mass casualty, transplant); - Conflict of interest; - Confidentiality + privacy; - Pediatric assent + adolescent autonomy; - Pregnancy + fetal interests; - Substance use + impairment colleagues; - Caring for difficult patients; - Treatment of incarcerated patients; (3) Decision-making frameworks: - Four boxes (Jonsen): medical indications, patient preferences, quality of life, contextual features; - Multidisciplinary ethics consult; - Ethics committees; (4) Informed consent process: - Voluntary; - Capacity assessment; - Information disclosure; - Documentation; (5) Truth-telling: - Honest communication; - Cultural sensitivity; - Bad news delivery skills; (6) Confidentiality: - HIPAA; - Limits (mandatory reporting, public health, immediate safety); (7) Resource allocation: - ICU bed; - Transplant organ; - Crisis standards of care (pandemic); - Triage (mass casualty); (8) Professional ethics: - Maintain competence (MOC); - Avoid impairment; - Report colleague impairment/error; - Conflict of interest disclosure; - Industry relationships; (9) Research ethics: - Belmont Report (respect, beneficence, justice); - IRB; - Informed consent; - Vulnerable populations; - Data integrity; (10) Modern: precision medicine, AI ethics, digital health, genetic information, environmental ethics; (11) Resources: - ASA Statement on Ethical Practice; - AMA Code of Medical Ethics; - WMA Declaration of Geneva; - Bioethics literature

---

Anesthesia ethics: autonomy + beneficence + non-maleficence + justice. Common dilemmas: DNR, Jehovah''s Witness, capacity, disclosure, end-of-life. Four boxes framework. Ethics consult. Modern: AI, digital, environmental ethics.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Integrative: ethics in anesthesia practice';

update public.mcq_questions
set choices = '[{"label":"A","text":"Avoid difficult conversations"},{"label":"B","text":"Difficult conversations + bad news"},{"label":"C","text":"Single quick statement"},{"label":"D","text":"Skip empathy"},{"label":"E","text":"Hide info"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Difficult conversations + bad news: (1) SPIKES protocol — bad news: - Setting (privacy, sit down, no distraction); - Perception (what patient knows); - Invitation (how much info wanted); - Knowledge (clear language, no jargon, pause for comprehension); - Emotion (acknowledge, empathize, support); - Strategy + summary (plan, follow-up); (2) Other models — NURSE (Name, Understand, Respect, Support, Explore emotions), Ask-Tell-Ask; (3) Anesthesia-specific scenarios: - Pre-op consent risk disclosure; - Adverse event disclosure (intraop awareness, dental injury, nerve injury, mortality); - Death notification; - End-of-life discussions; - Substance use disorder; - Chronic pain — realistic expectations; - Difficult family interactions; (4) Disclosure of adverse events: - Honest + timely; - Express empathy + apology (sorry vs admit fault — vary by jurisdiction; many states have apology laws); - Factual + non-defensive; - Documentation; - Institutional support; - Multidisciplinary; - Follow-up; (5) Family meetings: - Multidisciplinary; - Prepared agenda; - Patient/family-centered; - Cultural + spiritual considerations; - Decision aid + clarify; - Document discussion + outcomes; (6) Specific situations: - Pediatric — developmentally appropriate, parents, child life; - Cognitive impairment — surrogate; - LEP — interpreter; - Cultural differences — humility; (7) Communication skills training: - Simulation; - Real-time feedback; - Mentorship; (8) Self-care for provider: - Vicarious trauma; - Second victim phenomenon; - Debriefing; - Support resources; (9) Cognitive biases — anchoring, availability, confirmation; awareness; (10) Modern: cultural humility, structural humility, narrative medicine, patient-centered care, family-witnessed resuscitation

---

Difficult conversations: SPIKES (Setting, Perception, Invitation, Knowledge, Emotion, Strategy), NURSE. Disclosure (honest + empathic + apology). Multidisciplinary family meetings. Cultural + spiritual considerations. Self-care. Modern: patient-centered + humility.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Integrative: communication with patients + family — bad news + difficult conversations';

update public.mcq_questions
set choices = '[{"label":"A","text":"Ignore evidence"},{"label":"B","text":"Translational research + evidence-based practice"},{"label":"C","text":"Rapid adoption all"},{"label":"D","text":"Single discipline"},{"label":"E","text":"Skip improvement"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Translational research + evidence-based practice: (1) Research to practice gap — 17 years average; addressing: - Implementation science: - Diffusion of innovation; - Knowledge translation; - Quality improvement; (2) Levels of translation: - T1: bench to bedside (drug development); - T2: clinical research to clinical practice; - T3: practice to community/population; - T4: policy + health outcomes; (3) Implementation science frameworks: - CFIR (Consolidated Framework Implementation Research); - PARIHS (Promoting Action Research Implementation); - RE-AIM (Reach, Effectiveness, Adoption, Implementation, Maintenance); (4) Quality improvement methodology: - PDSA (Plan, Do, Study, Act); - Six Sigma; - Lean; - Audit + feedback; - Clinical practice guidelines; - Pathways + protocols; (5) Barriers to adoption: - Time + workload; - Knowledge gaps; - Habit; - Patient + colleague resistance; - System constraints; - Resource limitations; (6) Facilitators: - Leadership champion; - Education; - Aligned incentives; - System redesign; - Feedback; - Patient + family engagement; (7) Anesthesia examples: - ERAS adoption; - Multimodal opioid-sparing; - Lung-protective ventilation; - Goal-directed fluid therapy; - Quality programs (NACOR, MIPS); (8) Maintenance + sustainability: - Continuous improvement; - Avoid drift; - Update guidelines; - Re-train; (9) Patient engagement: - Co-design; - Patient-reported outcomes; - Shared decision-making; - Lived experience; (10) Modern: big data, AI/ML, learning health systems, registries (NACOR), comparative effectiveness research, real-world evidence; (11) Resources: - Cochrane; - ASA practice advisories; - Evidence-Based Anesthesia; - Anesthesia & Analgesia Translational Research

---

Translational research: gap 17 years. Levels T1-T4. Implementation science (CFIR, RE-AIM). QI methodology (PDSA). Barriers + facilitators. Anesthesia examples (ERAS, multimodal). Modern: big data + AI/ML + learning health systems.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Integrative: research + clinical practice — translating evidence';

update public.mcq_questions
set choices = '[{"label":"A","text":"Avoid telemedicine"},{"label":"B","text":"Telemedicine in anesthesia"},{"label":"C","text":"Same as in-person all"},{"label":"D","text":"Skip security"},{"label":"E","text":"No documentation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Telemedicine in anesthesia: (1) Pre-op telemedicine: - Pre-anesthesia evaluation virtual; - Especially useful for ambulatory + remote patients; - Time + cost savings; - High satisfaction; - Limitations: airway exam, physical exam; - Hybrid (virtual + in-person) common; (2) Tele-ICU: - Centralized ICU monitoring + consultation; - 24/7 intensivist coverage rural/community; - Quality + mortality improvements; - Care plans + medication review; - Family communication; (3) Tele-anesthesia OR: - Mentorship + supervision remote; - Difficult case consultation; - Mass casualty + disaster; - Global health applications; (4) Tele-PACU + tele-rounding; (5) Mobile apps + wearables: - Patient monitoring (BP, SpO2, glucose, sleep); - Medication adherence; - Pain tracking; - Recovery monitoring; (6) Patient education: - Videos; - Apps; - Tele-consultation; - Cultural translation; (7) Limitations + challenges: - Technology access (digital divide); - Privacy + security; - Reimbursement (evolving); - Licensing + jurisdiction; - Liability + standard of care; - Cultural + language; - Physical exam limitations; - Procedure-specific (cannot do all in person); (8) COVID-19 pandemic accelerated adoption; (9) Quality + safety: - Same standards apply; - Documentation requirements; - Technical reliability; (10) Specific anesthesia applications: - Pre-anesthesia clinic; - Pain medicine consultation; - Critical care; - Disaster response; - Global health partnerships; - Education + simulation; (11) Modern: telemedicine integral to healthcare; ASA guidance + advocacy; ongoing reimbursement + regulation evolution

---

Telemedicine anesthesia: pre-op evaluation + tele-ICU + tele-PACU + mentorship + global health. Limitations: physical exam, technology access, reimbursement. COVID accelerated. Same standards + documentation. ASA guidance.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Integrative: telemedicine + anesthesia (pre-op, post-op, ICU)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Ignore edema"},{"label":"B","text":"Post-prone position post-op visual loss (POVL) concern"},{"label":"C","text":"Hold ophthalmology"},{"label":"D","text":"Discharge immediately"},{"label":"E","text":"Skip checks"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-prone position post-op visual loss (POVL) concern: (1) POVL = devastating complication: - Ischemic Optic Neuropathy (ION) — anterior or posterior; - Central Retinal Artery Occlusion (CRAO) — direct eye pressure; - Cortical blindness — rare; (2) Risk factors: - Prone prolonged > 6h; - Blood loss > 1L; - Anemia (low Hct); - Hypotension (MAP < 65); - Direct eye pressure; - Steep Trendelenburg; - Volume + colloid use (large volume crystalloid worse); - Vascular risk factors (HTN, DM, CAD, smoking); (3) Pre-op + intra-op prevention (ASA POVL Practice Advisory): - Patient counseling for high-risk procedures; - Stage long procedures; - Eyes free from pressure (foam pad or Mayfield clamp); - Regular eye checks q15-30 min; - Head level with or higher than heart; - MAP > 70; - Limit blood loss + early transfusion; - Avoid extreme Trendelenburg; - Mix colloid + crystalloid (avoid excessive crystalloid); - Communicate with surgeon; (4) Recognition post-op: - Visual symptoms — blurring, blindness, scotoma; - Bilateral usually for ION; - Painless; - May not be immediately apparent (delayed days); - Comprehensive eye exam by ophthalmology; (5) Treatment ION (limited options): - Increase O2 carriage (transfuse if anemic); - Increase blood flow (avoid hypotension, head up); - Hyperbaric O2 controversial; - Steroids controversial; - Outcomes generally poor; (6) Other prone complications: - Brachial plexus, ulnar, lateral femoral cutaneous, peroneal injuries; - Pressure ulcers; - Tongue + lip injury; - ETT dislodgement; - Hemodynamic; (7) Periorbital edema common after prone — usually resolves; concerning if visual symptoms or persistent; (8) Multidisciplinary: anesthesia + surgery + ophthalmology

---

POVL: ION + CRAO + cortical blindness. Risk: prone > 6h, blood loss, anemia, hypotension, eye pressure. ASA POVL Practice Advisory prevention. Limited treatment options. Multidisciplinary. Documentation + counseling.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 60 ปี — major spine surgery (4 levels posterior fusion) prone position 6 hr
Blood loss 1500 mL, MAP maintained > 65, urine output adequate
At extubation: severe periorbital edema + conjunctival edema';

update public.mcq_questions
set choices = '[{"label":"A","text":"Aggressive hypotension"},{"label":"B","text":"Acute SDH + emergent craniotomy anesthesia"},{"label":"C","text":"Hypotonic fluids"},{"label":"D","text":"High volatile + N2O"},{"label":"E","text":"Skip osmotherapy"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute SDH + emergent craniotomy anesthesia: (1) Cushing''s reflex (HTN + bradycardia) suggests elevated ICP + impending herniation; (2) Pre-induction: - Maintain intubation + 100% O2; - Mild hyperventilation (PaCO2 30-35) only if herniation; otherwise normocapnia; - Head up 30°; - Hyperosmolar therapy (3% saline 250 mL or mannitol 0.5-1 g/kg); - Sedation + analgesia (avoid awareness from neuromuscular blockade); - Anticonvulsant (levetiracetam 1g IV); - Avoid hypotension (worsens secondary injury); (3) Anesthesia induction (already intubated): - Propofol bolus + opioid (fentanyl) + maintain sedation; - Rocuronium for OR; - Lidocaine pre-induction (blunt response); (4) Maintenance: - Propofol-based TIVA (lower ICP, smooth control); OR sevoflurane < 1 MAC + opioid; - Remifentanil infusion (titratable, smooth emergence); - Avoid N2O; (5) Hemodynamic goals: - MAP > 80, CPP > 60-70 (BTF guideline); - Norepinephrine first-line if hypotension; - Treat HTN cautiously (avoid worsening cerebral edema vs ICP) — labetalol if needed but maintain CPP; (6) Arterial line + CVL + Foley + temperature; (7) Brain relaxation: - Mannitol or hypertonic saline; - Mild hyperventilation; - CSF drainage if EVD placed; - Avoid PEEP > 10; (8) Surgical: - Burr hole, craniectomy; - Evacuation + hemostasis; (9) Post-op: - Neuro ICU; - Head up 30°; - Sedation + analgesia titrated; - Treat ICP (ICP monitor); - BP control; - Normothermia; - Glucose 140-180; - Seizure prophylaxis 7 days; - DVT prophylaxis (mechanical immediate, pharmacologic 24-48h based on stability); (10) Multidisciplinary: anesthesia + neurosurgery + ICU; (11) Family communication + goals of care

---

Acute SDH: maintain CPP > 60, mild HV only for herniation, hypertonic saline/mannitol, propofol TIVA, MAP > 80, head up 30°, ICP monitor postop, neuro ICU. Multidisciplinary. Goals of care.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 50 ปี — emergent neurosurgical evacuation of subdural hematoma
GCS 8 deteriorating, pupils equal reactive, intubated by EMS
BP 175/95, HR 60';

update public.mcq_questions
set choices = '[{"label":"A","text":"Force opioid heavy"},{"label":"B","text":"Routine elective laparoscopic appendectomy anesthesia"},{"label":"C","text":"Skip multimodal"},{"label":"D","text":"No ventilation considerations"},{"label":"E","text":"Mandatory ICU"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Routine elective laparoscopic appendectomy anesthesia: (1) Pre-op: - Standard pre-op evaluation; - No need extensive testing (young healthy); - Informed consent including risks; - IV access; - Pre-procedural medication: maybe ondansetron + dexamethasone; - Antibiotic prophylaxis (cefazolin) 60 min pre-incision; (2) Intra-op: - GA with ETT (pneumoperitoneum); - Induction: propofol 2 mg/kg + fentanyl 2 mcg/kg + rocuronium 0.6 mg/kg; - Maintenance: sevoflurane 0.8-1 MAC + opioid; OR TIVA propofol + remifentanil; - Lung-protective ventilation: TV 6 mL/kg IBW, PEEP 5-8, plateau < 30, permissive hypercapnia; - Adjust ventilation for CO2 pneumoperitoneum (~ 20% increase EtCO2); - Multimodal analgesia: acetaminophen 1g IV + ketorolac 30 mg IV + local infiltration; - PONV prophylaxis: dexamethasone 4-8 mg + ondansetron 4-8 mg (Apfel score female + non-smoker + post-op opioid); (3) Position considerations: - Supine + Trendelenburg ± lateral tilt; - Padded arms (brachial plexus); - Eye protection; - Foley if expected > 2-3h; (4) Specific: - CO2 pneumoperitoneum effects (hemodynamic + respiratory); - Limit intra-abdominal pressure < 15 mmHg; - Watch for surgical complications (bleeding, organ injury); (5) Emergence + extubation: - Multimodal continued; - Reverse NMB (sugammadex or neostigmine + glyco); - TOF > 0.9 before extubation; - Awake extubation; (6) PACU: - Pain assessment + treatment (multimodal); - PONV management; - Aldrete score; - Voiding (if Foley) + ambulation; - Discharge criteria; (7) Discharge: - Same day typical; - Written + verbal instructions; - Follow-up; - Multimodal analgesia continuation; (8) Modern: ERAS-like principles for ambulatory; minimize opioid

---

Routine lap appy: GA + ETT, lung-protective ventilation, multimodal analgesia, PONV prophylaxis (dex + ondansetron), reverse NMB (sugammadex), Aldrete + discharge criteria. Pneumoperitoneum considerations.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 22 ปี ASA II — elective laparoscopic appendectomy
No PMH, no allergies, no medications, NPO 8h
Mallampati II, no airway concerns';

update public.mcq_questions
set choices = '[{"label":"A","text":"Beta-blocker first"},{"label":"B","text":"Pheochromocytoma resection anesthesia"},{"label":"C","text":"Skip alpha-blockade"},{"label":"D","text":"No invasive monitoring"},{"label":"E","text":"Ketamine induction"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pheochromocytoma resection anesthesia: (1) Pre-op preparation (essential): - Alpha-blockade FIRST (phenoxybenzamine, doxazosin) × 10-14 days — reduces vasoconstriction; - Beta-blockade ONLY after alpha (otherwise unopposed alpha → severe HTN); - Hydration (alpha-blockade causes orthostatic, volume re-expansion); - Magnesium + electrolyte normalization; - Target BP < 130/80 + HR 60-80 + orthostatic decrease + minimal symptoms; - Imaging (CT/MRI), biochemical (metanephrines); (2) Anesthetic considerations: - Hypertensive crisis + arrhythmia at induction, intubation, surgical manipulation; - Hypotension after ligation of venous drainage (sudden catecholamine removal + remaining alpha-blockade); - Glucose lability; - Cardiomyopathy possible; (3) Anesthetic technique: - Smooth induction: propofol + opioid + lidocaine pre-treatment + rocuronium; - Avoid ketamine (sympathomimetic), succinylcholine (controversial — most use OK with NMB); - Avoid morphine (histamine release); - Avoid pancuronium (vagolytic); - Sevoflurane OK; (4) Drugs ready (have multiple syringes prepared): - Vasodilators: nitroprusside (gold standard, rapid), nitroglycerin, phentolamine, esmolol, magnesium; - Antiarrhythmic: lidocaine, esmolol, amiodarone; - Vasopressor: norepinephrine, phenylephrine for hypotension; - Sympatholytic: esmolol, labetalol; (5) Invasive monitoring: - Pre-induction arterial line; - CVL or large peripheral; - Consider PA catheter for cardiomyopathy; - Cardiac output monitor; (6) Surgical considerations: - Laparoscopic preferred; - Avoid manipulating tumor early (prepare for catecholamine surge); - Identify + clamp venous drainage early; (7) Post-op: - ICU; - Hemodynamic instability possible 24-48h; - Glucose monitoring (rebound hypoglycemia); - Steroid replacement if bilateral or contralateral atrophy; (8) Multidisciplinary: anesthesia + surgery + endocrinology + ICU

---

Pheochromocytoma: alpha-blockade FIRST (10-14d), then beta. Hydration. Vasodilator (nitroprusside) + vasopressor + esmolol ready. Pre-induction A-line + CVL. ICU post-op. Hypoglycemia rebound. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 45 ปี — surgical removal pheochromocytoma right adrenal
Pre-op alpha + beta blocked × 14 days
Verified Mg + electrolytes + hydration';

update public.mcq_questions
set choices = '[{"label":"A","text":"Same as GA"},{"label":"B","text":"Neuraxial anesthesia physiology"},{"label":"C","text":"Always use lidocaine"},{"label":"D","text":"Avoid in all surgery"},{"label":"E","text":"Skip patient assessment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neuraxial anesthesia physiology: (1) Spinal anesthesia: - LA injected into subarachnoid space (CSF); - Direct effect on spinal nerve roots + spinal cord; - Rapid onset (5-10 min); - Dense block (motor + sensory + autonomic); - Smaller dose; - Single shot or catheter (rare); (2) Epidural anesthesia: - LA injected into epidural space (potential space, outside dura); - Indirect effect via diffusion across dura + nerve roots; - Slower onset (15-30 min); - Differential block (sensory > motor); - Larger volume; - Continuous catheter common; (3) CSE (combined spinal-epidural) — best of both; (4) Hemodynamic effects: - Sympathectomy → vasodilation → hypotension; - Level T1-T4 affects cardiac sympathetic (bradycardia + decreased contractility); - Higher block = more profound; - Pre-load with fluid + vasopressor; (5) Respiratory effects: - Below T8 — minimal; - Above T4 — accessory muscle paralysis (cough impaired); - Above C3-5 — phrenic palsy (apnea); - High spinal = respiratory failure; (6) Neurologic effects: - Sensory loss (block height); - Motor loss; - Visceral effects (bowel + bladder); (7) Block height factors: - Baricity LA (hyperbaric, isobaric, hypobaric); - Position; - Volume + dose; - Patient height + curvature; - Site of injection; - Direction needle; (8) Contraindications: - Patient refusal; - Coagulopathy (hematoma risk); - Infection at site; - Increased ICP; - Severe hypovolemia; - Severe aortic stenosis (relative); - Severe spinal abnormality; (9) Complications: - Hypotension (most common); - PDPH; - Total spinal; - Hematoma; - Abscess; - Nerve injury; - Transient neurologic symptoms (TNS — lidocaine); (10) Drug selection: - Bupivacaine, ropivacaine, levobupivacaine — long-acting; - Lidocaine — intermediate (TNS); - Chloroprocaine — short; (11) Adjuncts: - Epinephrine, fentanyl, morphine (long-acting analgesia), clonidine; (12) Modern: ultrasound guidance for difficult anatomy

---

Neuraxial: spinal (direct CSF, fast, dense) vs epidural (indirect, slow, differential). Sympathectomy + hypotension. High block respiratory. Block height factors. Contraindications + complications. Adjuncts. Modern US guidance.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Basic science: physiology of central neuraxial anesthesia';

update public.mcq_questions
set choices = '[{"label":"A","text":"Mass crystalloid"},{"label":"B","text":"Chest trauma + thoracic anesthesia"},{"label":"C","text":"No pain control"},{"label":"D","text":"N2O routine"},{"label":"E","text":"Skip multimodal"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Chest trauma + thoracic anesthesia: (1) Flail chest — paradoxical chest wall movement, severe pain, underlying pulmonary contusion; (2) Pulmonary contusion — most important pathology; ARDS-like; (3) Management priorities: - Airway (intubated); - Ventilation (lung-protective TV 6 mL/kg); - Pain control essential (thoracic epidural, ESP, intercostal blocks — facilitates breathing + reduces splinting); - Volume management (avoid overload — worsens contusion); - Treat associated injuries (pneumothorax, hemothorax with chest tubes); (4) Surgical fixation of flail (rib plating) — improving outcomes vs conservative; (5) Anesthetic considerations: - Difficult ventilation (one-lung ventilation may worsen + improve); - Hemodynamic instability — judicious fluids + early vasopressor; - Massive transfusion if hemorrhage; - Avoid N2O (pneumothorax expansion); - Ketamine acceptable; - Lung-protective + permissive hypercapnia; (6) Specific: - Tension pneumothorax — immediate chest decompression; - Massive hemothorax (> 1500 mL initially or > 200 mL/hr) → thoracotomy; - Cardiac contusion — ECG, troponin, echo; - Aortic injury — CT angiogram; (7) Post-op: - ICU; - Multimodal analgesia continuation; - Lung-protective ventilation; - Wean ventilator as tolerated; - DVT prophylaxis; - Aggressive pulmonary toilet; - Monitor for ARDS; (8) Multidisciplinary: trauma surgery + anesthesia + ICU + thoracic + cardiology + IR

---

Flail chest + pulmonary contusion: lung-protective ventilation, multimodal analgesia (epidural, ESP), judicious fluids, rib plating emerging, ICU management. Avoid N2O. Multidisciplinary trauma team.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 45 ปี — emergency open repair flail chest + bilateral pulmonary contusions + hemodynamic compromise
Intubated, BP 80/50, HR 130, SpO2 88% FiO2 1.0';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait for stability"},{"label":"B","text":"Hypovolemic shock + emergency gynecologic surgery"},{"label":"C","text":"Crystalloid only"},{"label":"D","text":"Propofol bolus high dose"},{"label":"E","text":"Skip blood"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hypovolemic shock + emergency gynecologic surgery: (1) Resuscitation priorities: - 2 large-bore IV; - O- blood emergency or type-specific; - Crystalloid bolus initially while blood arrives; - MTP protocol activation if massive; (2) Anesthesia preparation: - Full stomach (emergency) — RSI; - Likely hemorrhagic shock — choose CV-stable induction (ketamine 1 mg/kg + opioid OR etomidate 0.3 mg/kg); avoid propofol bolus; rocuronium for RSI; - Pre-O2 thorough; - Arterial line; - Foley; (3) Intra-op: - Continue resuscitation — blood, FFP, platelets 1:1:1; TXA 1g; - Calcium replacement; - Warming; - Avoid acidosis + hypothermia + coagulopathy; - Vasopressor (norepinephrine) if persistent hypotension despite volume; - Surgeon control bleeding ASAP (clamp tube + ovary, hemostasis); (4) Maintain anesthesia: - Lower MAC volatile (hemodynamic); - Adequate amnesia (BIS if available); - Multimodal opioid-sparing post-op; (5) Post-op: - PACU or ICU based on stability; - Continued monitoring + transfusion; - Rh(D) immunoglobulin if Rh- mother + Rh+ products (or unknown fetus); - Emotional support (loss of pregnancy + emergency); - Follow-up + counseling fertility; (6) Multidisciplinary: OB-GYN + anesthesia + nursing + social work + blood bank; (7) Modern: methotrexate medical Mx for stable ectopic; surgical for ruptured/unstable; salpingostomy vs salpingectomy

---

Ruptured ectopic: RSI with ketamine/etomidate (CV stable), blood products 1:1:1, TXA, Ca, warming, norepi. Rh(D) immunoglobulin. Multidisciplinary including emotional support.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 28 ปี — emergent surgery for ectopic pregnancy ruptured
Hypotensive BP 75/40, HR 130, abdominal pain
IV × 2, type + cross pending, NPO unclear';

update public.mcq_questions
set choices = '[{"label":"A","text":"Force ETT first"},{"label":"B","text":"Pediatric foreign body airway anesthesia"},{"label":"C","text":"Mass NMB"},{"label":"D","text":"Skip atropine"},{"label":"E","text":"Discharge home"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric foreign body airway anesthesia: (1) Pre-op: - Stable child — proceed semi-urgent; - Unstable (severe distress, near-total obstruction) — immediate; - Avoid sedation/general anesthesia that may worsen obstruction; - NPO if possible; - Discussion with ENT/bronchoscopist for plan; - IV access + atropine pre-treatment (vagal bradycardia from airway stimulation); (2) Anesthetic approach (shared airway with bronchoscopist): - Inhalational induction with sevoflurane in O2 (maintain spontaneous ventilation initially — avoid converting partial to complete obstruction with paralysis); - Alternative: IV induction with propofol (with NMB if planning controlled ventilation); - Topical lidocaine to airway; - Equipment: rigid bronchoscope (ENT) + flexible bronchoscope + multiple ETT sizes + ECMO if catastrophic; (3) During bronchoscopy: - Spontaneous ventilation vs controlled (TIVA + NMB) — debated, depends on patient + foreign body + bronchoscopist preference; - 100% O2; - Adequate depth; - Hemodynamic support; (4) Specific risks: - Airway trauma; - Mucosal edema; - Foreign body migration; - Hypoxia; - Bronchospasm + laryngospasm; - Pneumothorax + bleeding; - Cardiac arrest; (5) Post-removal: - Assess airway; - Treat residual swelling (steroid, racemic epinephrine); - Observation 24h (may have delayed edema, infection); - Antibiotics if appropriate; (6) Common foreign bodies — peanuts, popcorn, hot dogs, small toys, batteries (button battery = caustic, urgent); (7) Outcomes generally good with prompt recognition; mortality < 1%; (8) Multidisciplinary: ENT + anesthesia + nursing + family; (9) Prevention education — chokable foods, supervised play, button battery storage

---

Pediatric foreign body: inhalational induction with maintained spontaneous ventilation (typically), shared airway with bronchoscopist, atropine pre-treatment, multiple equipment ready, post-removal observation. Button battery urgent.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยทารก 18 mo 10 kg — emergent surgery for foreign body aspiration in main bronchus
Mild dyspnea, occasional wheeze, SpO2 92% RA';

update public.mcq_questions
set choices = '[{"label":"A","text":"Sedate heavily"},{"label":"B","text":"Acute post-op delirium"},{"label":"C","text":"More opioid"},{"label":"D","text":"Restrain physically"},{"label":"E","text":"Ignore"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute post-op delirium — comprehensive workup + management: (1) DDx: - Medication-induced (opioid, benzodiazepine, anticholinergic, steroid); - Hypoxia; - Hypoglycemia; - Infection (UTI, pneumonia, wound, line); - Electrolyte derangement (Na, glucose, Ca, Mg); - Pain undertreated; - Withdrawal (alcohol, benzo, nicotine); - Urinary retention/constipation; - Sleep deprivation; - CNS event (stroke, hemorrhage, seizure); - PRES (Posterior Reversible Encephalopathy Syndrome) — HTN + immunosuppressant; - Sepsis; - Cardiogenic (low CO); (2) Diagnosis — CAM (Confusion Assessment Method): - Acute onset + fluctuating; - Inattention; - Disorganized thinking; - Altered consciousness; - Plus diagnosis when 1 + 2 + (3 or 4); (3) Workup: - Vital signs + glucose + SpO2; - Pain assessment; - Medication review (Beers); - Labs: BMP, Mg, glucose, CBC, UA; - ECG; - Consider CXR, CT head if focal/severe; (4) Management non-pharmacologic (primary): - Address underlying causes; - Re-orient (clock, calendar, family); - Hearing aids + glasses; - Sleep promotion (night light off, day activities); - Mobilize early; - Hydration; - Pain control multimodal (reduce opioid); - Remove tethers (lines, Foley, restraints); - Family presence; (5) Pharmacologic (sparingly + low-dose): - Low-dose haloperidol 0.25-0.5 mg or quetiapine 12.5-25 mg for severe agitation/safety; - AVOID benzodiazepines (worsen) — except withdrawal; - AVOID anticholinergics; - Dexmedetomidine has emerging role; (6) Risk reduction multimodal — multifactorial intervention (HELP — Hospital Elder Life Program) reduces incidence; (7) Long-term outcomes: increased mortality, functional decline, dementia risk, LOS; (8) Family education + support

---

Post-op delirium: comprehensive workup (causes — meds, hypoxia, infection, electrolytes, pain, withdrawal), CAM diagnosis, non-pharm primary (re-orient, sleep, mobility, family), low-dose antipsychotic sparingly, AVOID benzo + anticholinergic. HELP bundle prevention.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 70 ปี — elective colectomy ASA III with CAD + DM
Using IV PCA morphine post-op
Day 1 develops confusion + agitation + visual hallucinations
No focal neuro deficit + WBC normal';

update public.mcq_questions
set choices = '[{"label":"A","text":"Cuff on fistula arm"},{"label":"B","text":"AV fistula salvage anesthesia"},{"label":"C","text":"Use succinylcholine"},{"label":"D","text":"Morphine PCA"},{"label":"E","text":"Heavy sedation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** AV fistula salvage anesthesia: (1) Anesthetic options: - Local infiltration + monitored anesthesia care (MAC) — for minor revisions; - Regional anesthesia (brachial plexus block) — preferred for major fistula work; - GA — reserved for complex/uncooperative; (2) Brachial plexus block options: - Supraclavicular — covers entire arm, good for fistula work; small pneumothorax risk; - Infraclavicular — also good coverage, less phrenic palsy than interscalene; - Axillary — only safer in ESRD with possible coagulopathy; - Ultrasound guidance preferred (reduces complications + improves success); (3) ESRD-specific considerations: - Recently dialyzed (6h) — better K + volume; check K before; - Heparin from HD — wait time before regional; ASRA timing; - Coagulopathy from uremia — DDAVP if bleeding; - Protect non-fistula arm (no BP, IV, art line); - Avoid succinylcholine if K elevated; - Avoid morphine; use fentanyl/hydromorphone; - Cisatracurium NMB if GA; (4) Sedation: - Avoid heavy sedation (already volume + electrolyte concerns); - Dexmedetomidine — sedation without respiratory depression; - Small midazolam + fentanyl; (5) Hemodynamic: - Maintain MAP — preserve fistula flow; - Cautious fluid (overload risk); - Vasopressor if needed; (6) Fistula salvage success time-sensitive (24-48h); coordinate with vascular + IR; (7) Post-op: - Monitor for bleeding, thrombosis; - Continue dialysis schedule; - Protect arm; - Multimodal analgesia; (8) Multidisciplinary: vascular surgery + IR + nephrology + anesthesia; (9) Modern: percutaneous thrombectomy emerging; AV graft considerations

---

AV fistula salvage: regional anesthesia (brachial plexus block, ultrasound-guided) preferred. ESRD considerations: K, coagulopathy, drug selection (cisatracurium, fentanyl/hydromorphone). Protect fistula arm. Maintain MAP. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 30 ปี diabetic ESRD on HD — emergent AV fistula thrombectomy
Has labile glucose, K 6.0, recently dialyzed 6h ago
Use local + sedation vs regional vs GA';

update public.mcq_questions
set choices = '[{"label":"A","text":"NPO since midnight"},{"label":"B","text":"ERAS colorectal protocol"},{"label":"C","text":"Heavy opioid PCA"},{"label":"D","text":"Prolonged bedrest"},{"label":"E","text":"Delayed feeding"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** ERAS colorectal protocol — comprehensive: (1) Pre-op: - Patient education + expectations; - No mechanical bowel prep + no fasting > 2h (clear fluids); carb load 2h pre-op; - No long-acting premedication; - DVT + antibiotic prophylaxis; - Chlorhexidine skin prep; (2) Intra-op: - Multimodal opioid-sparing analgesia (acetaminophen + NSAID/COX-2 + gabapentinoid + ketamine + lidocaine infusion + dexamethasone); - Regional: epidural OR TAP/QL block OR ESP — debate epidural value in ERAS; TAP increasingly preferred; - Short-acting anesthetics (propofol + remifentanil OR low-dose volatile + opioid); - Goal-directed fluid therapy (esophageal Doppler, pulse contour) — moderate fluid; - Normothermia (active warming); - PONV prophylaxis multimodal (Apfel); - Minimize NG, drains, urinary catheter; - Lung-protective ventilation; - Avoid N2O; - Glucose control; - Local infiltration LA (laparoscopic ports + open wound); (3) Post-op: - Early oral intake (Day 0 or Day 1); - Early mobilization (Day 0); - Multimodal opioid-sparing analgesia continued; - Glucose control; - DVT prophylaxis; - Early Foley removal (Day 0-1); - NG/drains removed early; - Discharge criteria objective; - Follow-up; (4) Outcomes (multiple RCTs): - Reduced LOS (~30%); - Reduced complications (~50%); - Reduced opioid use; - Improved patient satisfaction; - Cost-effective; (5) Multidisciplinary: surgery + anesthesia + nursing + nutrition + PT + patient education; (6) Audit + continuous improvement; (7) Modern: ERAS Society protocols by procedure (colorectal, thoracic, gynecologic, orthopedic, bariatric, etc.); ERAS adapted to ambulatory; (8) Patient buy-in + family engagement; (9) Quality improvement framework — compliance with elements drives outcome

---

ERAS colorectal: shortened fasting + carb load, multimodal opioid-sparing + regional, goal-directed fluid, normothermia, early feeding + mobilization. Multidisciplinary. Reduces LOS + complications.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 55 ปี — major colorectal resection for cancer
Planned ERAS protocol
No prior surgery, normal labs, ASA II';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge to ward"},{"label":"B","text":"Acute new onset AFib + decompensated HF in PACU"},{"label":"C","text":"Aggressive crystalloid"},{"label":"D","text":"Sedate heavily"},{"label":"E","text":"Wait"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute new onset AFib + decompensated HF in PACU: (1) Initial — ABCs, supplemental O2, position upright, IV access, monitor; (2) Assessment: - Hemodynamically unstable (hypotension, ischemia, severe HF) — synchronized cardioversion immediate (200J biphasic); - Hemodynamically stable but symptomatic — rate control + diuretic + supportive; (3) Acute pulmonary edema: - O2 — NC → mask → HFNC → NIV (CPAP/BiPAP) → intubate; NIV often effective for cardiogenic edema; - Loop diuretic (furosemide 20-40 mg IV); - Nitroglycerin (sublingual or infusion) — preload + afterload reduction (caution hypotension); - Inotropes if cardiogenic shock; (4) AFib rate control: - Beta-blocker (esmolol IV — short, titratable; metoprolol); - Calcium channel blocker (diltiazem) if BB contraindicated; - Amiodarone (rate + rhythm); - Digoxin (slow); - AVOID rate-control if WPW (use cardioversion); (5) Rhythm control: - Synchronized cardioversion if unstable or anticipated quick conversion + low stroke risk; - Amiodarone IV; - Newer: ibutilide, vernakalant; (6) Anticoagulation: - CHA2DS2-VASc score; - If AFib > 48h or unknown: anticoagulate before cardioversion or TEE; - Post-cardioversion anticoagulation 4 weeks minimum (stunning); (7) Identify precipitants: - Hypoxia, hypercapnia, acidosis; - Electrolyte (K, Mg); - Pain, anxiety; - Volume status; - PE; - Sepsis; - Hyperthyroidism; - Anemia; - MI; (8) Differential — other causes pulmonary edema: ARDS, TRALI, neurogenic, negative-pressure; (9) Multidisciplinary: anesthesia + cardiology + ICU; (10) Disposition: step-down or ICU; continued workup + treatment

---

New AFib + acute pulmonary edema PACU: O2 + NIV, diuretic + nitroglycerin, rate control (esmolol, diltiazem, amio), cardioversion if unstable. CHA2DS2-VASc anticoagulation. Identify precipitants. Step-down/ICU.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 60 ปี — atrial fibrillation rate 150 + acute pulmonary edema in PACU post-cholecystectomy
BP 90/60, SpO2 88% on 6L NC, anxious + dyspneic
Cardiac history HTN';

update public.mcq_questions
set choices = '[{"label":"A","text":"Cancel surgery"},{"label":"B","text":"Multi-comorbidity hip fracture anesthesia"},{"label":"C","text":"Wait 9 months for stroke"},{"label":"D","text":"Immediate neuraxial"},{"label":"E","text":"Skip blocks"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Multi-comorbidity hip fracture anesthesia — complex decision: (1) Hip fracture < 48h reduces mortality per multiple guidelines; (2) Stroke 2 months ago — high perioperative risk: - Recommendation defer elective surgery 9 months post-stroke; - Hip fracture urgent — proceed with risk acceptance; - Cardiology consult; - Maintain MAP > 80 to preserve cerebral perfusion; - Avoid hypotension + hyperglycemia; - Continue antiplatelet typically; (3) Apixaban management: - Half-life 12h normal renal; 18h since last dose; - Wait further or use reversal (andexanet alfa) for neuraxial; - Andexanet expensive; PCC 4-factor 50 U/kg empirical alternative; - Generally hold neuraxial if recent DOAC + bleeding concern; (4) Anesthetic choice: - Neuraxial (spinal) vs GA — both acceptable per recent RCT REGAIN (no significant difference for mortality, delirium); - Spinal may be preferred for: avoidance of GA in elderly (delirium concern — though REGAIN showed equivocal); - GA may be preferred for: anticoagulation status (avoid neuraxial hematoma), dementia patient cooperation, time pressure; - Decision individualized; (5) For THIS patient: - GA + multimodal opioid-sparing recommended given recent DOAC + dementia + stroke; - Regional adjunct: fascia iliaca + lateral femoral cutaneous nerve blocks for analgesia; (6) Anesthetic technique: - Etomidate or low-dose propofol; - Multimodal + regional adjunct (fascia iliaca block); - Avoid Beers Criteria meds (benzo, anticholinergic); - Use sugammadex for rapid reversal; (7) Delirium prevention: - HELP bundle; - Family presence; - Re-orientation; - Pain control + multimodal; (8) Post-op: - ICU/step-down monitoring; - Stroke awareness (neuro checks); - Restart antithrombotic when hemostasis OK; - DVT prophylaxis; - Mobilization; - PT/OT; - Discharge planning (likely SNF); (9) Goals of care discussion with family — dementia + multiple comorbidities — what does patient want? Function vs comfort?

---

Hip fracture + multiple comorbidities: surgery < 48h, individualize anesthesia (REGAIN — spinal/GA similar), recent DOAC + stroke considerations, fascia iliaca block, multimodal opioid-sparing, delirium prevention, goals of care discussion.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 75 ปี — fall + hip fracture, ASA III
Alzheimer dementia + atrial fibrillation on apixaban + recent stroke 2 months ago
Last apixaban 18h ago
Urgent surgery < 48h per ortho guidelines';

update public.mcq_questions
set choices = '[{"label":"A","text":"Outpatient discharge"},{"label":"B","text":"Severe OSA + airway surgery"},{"label":"C","text":"Heavy opioid PCA"},{"label":"D","text":"Skip CPAP postop"},{"label":"E","text":"Single-shot blocks"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe OSA + airway surgery — high-risk anesthesia: (1) Pre-op: - Optimize CPAP compliance; - Difficult airway anticipated; - Multidisciplinary planning ENT + anesthesia + sleep medicine; (2) Airway considerations: - Predicted difficult: large neck, redundant tissue, friable post-op; - Awake fiberoptic intubation may be wise; - Video laryngoscopy first; - Multiple airway equipment + plans; (3) Anesthetic technique: - Avoid heavy sedation + long-acting opioids (respiratory depression OSA); - Multimodal opioid-sparing maximally: acetaminophen + NSAID + gabapentinoid (caution OSA — sedation), ketamine, dexmedetomidine; - Local infiltration; - Bilateral palatal block; - Topical anesthesia airway; (4) Intra-op: - Lung-protective + PEEP; - PONV prophylaxis (dexamethasone helps swelling + nausea + analgesia); - Limit IV fluid (edema); - Surgical-shared airway with ENT; (5) Extubation: - Awake extubation in lateral position; - Suction; - Equipment ready for re-intubation; - Watch for post-op bleeding (tonsillar + palatal); (6) Post-op: - PACU + CPAP back ASAP; - Continuous capnography + SpO2 monitoring step-down/ICU; - Multimodal analgesia opioid-sparing; - Position lateral or semi-upright; - Avoid sedatives; - Observation 24h+ (NOT outpatient for severe OSA major airway surgery); - Difficult airway alert + documentation; (7) Specific complications watch: - Post-op bleeding (primary 24h, secondary 5-10 days); - Airway edema; - NPPE; - Apnea + hypoxia; - PONV; - Pain (severe); (8) Long-term: continue CPAP + sleep medicine follow-up; (9) Multidisciplinary: ENT + anesthesia + sleep medicine + intensivist

---

Severe OSA + airway surgery: difficult airway prep, multimodal opioid-sparing maximally, AFOI/video laryngoscopy, awake extubation lateral, CPAP back ASAP, continuous monitoring 24h+, NOT outpatient, multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 35 ปี severe sleep apnea — elective tonsillectomy + uvulopalatopharyngoplasty (UPPP) + nasal surgery
BMI 36, AHI 50, on CPAP';

update public.mcq_questions
set choices = '[{"label":"A","text":"No imaging guidance"},{"label":"B","text":"Interventional pain management"},{"label":"C","text":"Particulate steroid for transforaminal"},{"label":"D","text":"Skip consent"},{"label":"E","text":"No image guidance cervical"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Interventional pain management — epidural steroid injection (ESI): (1) Indications: - Radicular pain (radiculopathy) from disc herniation, spinal stenosis; - Failed conservative management (PT, NSAIDs, neuropathic agents); - Diagnostic + therapeutic; (2) Pre-procedure: - Imaging review (level + side); - Anticoagulation review (ASRA Interventional 2018): - High bleeding risk procedure for transforaminal; - Intermediate for interlaminar/caudal; - Hold per category + half-life; - Coagulation assessment if abnormal history; - Informed consent (risks: infection, bleeding, dural puncture, vascular injection, transient/permanent neuro deficit, no benefit); - IV access + monitoring; - Patient prone position; (3) Approaches: - Interlaminar (loss of resistance, fluoroscopy guidance); - Transforaminal (foramen, image guidance — fluoro or CT); more targeted but higher risk vascular injection + neuro complications; - Caudal (sacral hiatus); (4) Drugs: - Local anesthetic (lidocaine 1-2%) — diagnostic + analgesia; - Steroid: dexamethasone (non-particulate — recommended for transforaminal to reduce stroke/cord injury risk from particulate steroid embolism); particulate (triamcinolone, methylprednisolone) interlaminar/caudal acceptable; - Contrast (Omnipaque) to confirm spread + rule out vascular; (5) Image guidance MANDATORY for cervical + thoracic + transforaminal — multiple safety reports; (6) Complications: - Vascular injection (artery of Adamkiewicz, vertebral) → catastrophic; - Dural puncture → PDPH; - Infection (epidural abscess, meningitis); - Hematoma; - Nerve injury; - Transient steroid side effects (insomnia, glucose elevation, flushing); (7) Outcome — limited evidence; modest short-term benefit for radicular pain; (8) Multidisciplinary: pain medicine + spine surgery + PT; (9) Modern: regenerative medicine (PRP, stem cells) emerging but limited evidence

---

ESI: image guidance mandatory (fluoro/CT) for cervical/thoracic/transforaminal. Non-particulate steroid (dex) for transforaminal. ASRA anticoag timing. Risks: vascular injection (cord ischemia), dural puncture, infection, hematoma. Modest benefit.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 55 ปี — chronic pain referred to pain clinic, severe lumbar radicular pain × 1 year
MRI: large L5-S1 disc herniation
Failed conservative
Procedural: epidural steroid injection';

update public.mcq_questions
set choices = '[{"label":"A","text":"Heavy opioid only"},{"label":"B","text":"Postherpetic neuralgia (PHN)"},{"label":"C","text":"Refuse care"},{"label":"D","text":"Surgery"},{"label":"E","text":"Single agent only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Postherpetic neuralgia (PHN) — chronic management: (1) Definition — pain > 3 months after zoster (shingles) rash resolution; (2) Risk factors: age > 50, severity acute zoster, ophthalmic, immunocompromise; (3) Mechanism — peripheral + central sensitization, nerve damage; (4) Treatment hierarchy: - First-line: - Gabapentin (300-3600 mg/day) or pregabalin (75-300 mg BID); - TCA (amitriptyline, nortriptyline) 10-100 mg HS; - 5% lidocaine patch (topical, localized); - Capsaicin 8% patch (single application 60 min, can repeat q3 months); - Second-line: - SNRI (duloxetine, venlafaxine); - Tramadol (weak opioid + SNRI); - Combination therapy; - Refractory: - Opioids — limited efficacy + addiction risk; consider carefully; - Methadone (NMDA + opioid); - Botulinum toxin injection; - Intrathecal medications; (5) Interventional options: - Intercostal nerve block — diagnostic + therapeutic; - Paravertebral block; - Erector spinae plane block (ESP) — emerging; - Pulsed radiofrequency; - Sympathetic block; - Spinal cord stimulation (refractory); - Dorsal root ganglion (DRG) stimulation; (6) Non-pharmacologic: - CBT; - Mindfulness; - PT for stiffness/disuse; - TENS; - Acupuncture (mixed evidence); (7) Prevention (most important): - Shingles vaccine (Shingrix) > 50 years — significantly reduces zoster + PHN; - Early antiviral (acyclovir, valacyclovir) within 72h acute zoster reduces PHN risk; - Pain control acute zoster (opioid, antiviral, possibly steroid); (8) Patient education: - Chronic condition; - Functional restoration focus; - Pacing; - Sleep; - Mood support; (9) Multidisciplinary pain clinic + multimodal

---

PHN: multimodal (gabapentinoid, TCA, lidocaine patch, capsaicin 8%, SNRI, tramadol, ESP/intercostal blocks, SCS/DRG). Prevention: Shingrix vaccine + early antiviral + acute pain control. Multidisciplinary + non-pharm.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 45 ปี — chronic pain post-zoster (postherpetic neuralgia) ipsilateral T4-T6 × 6 months
Severe allodynia + burning + shooting pain
Failed gabapentinoid + TCA';

update public.mcq_questions
set choices = '[{"label":"A","text":"Spinal anesthesia"},{"label":"B","text":"HELLP syndrome"},{"label":"C","text":"Skip BP control"},{"label":"D","text":"No transfusion ready"},{"label":"E","text":"Routine technique"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** HELLP syndrome — emergent C-section anesthesia: (1) HELLP — Hemolysis, Elevated Liver enzymes, Low Platelets; subset severe PEC; high mortality; (2) BP control: - Labetalol 20 mg IV bolus q10 min; - Hydralazine 5-10 mg IV q20; - Nicardipine infusion; - Target SBP 140-160, DBP 90-110; (3) Seizure prophylaxis — magnesium 4-6g loading + 1-2g/hr (continue 24h post-delivery); (4) Anesthesia choice (challenging): - Platelets 35k = BELOW threshold for neuraxial (typically need > 70-80k, some advocate higher); - Spinal hematoma risk too high; - GA required typically; (5) GA technique: - Aspiration prophylaxis (PPI, antacid); - Rapid Sequence Induction (RSI) with cricoid; - Anticipated difficult airway (edema); - Pre-O2 thorough; - Video laryngoscopy first; - Blunt response: opioid (remifentanil 1 mcg/kg or fentanyl 2-4 mcg/kg); lidocaine 1.5 mg/kg; magnesium adjunct; consider esmolol; - Induction: propofol 1.5-2 mg/kg + rocuronium 1.2 mg/kg; - Maintain anesthesia: sevoflurane 1 MAC + opioid + magnesium (potentiates NMB, careful); (6) Hemorrhage risk + transfusion: - Coagulopathy possible; - Platelet transfusion if active bleeding or pre-procedure (controversial threshold); - FFP if INR > 1.5; - Cryoprecipitate if fibrinogen < 1.5; - Cell saver acceptable OB; - TXA 1g; (7) Hemodynamic management: - Cautious fluid (pulmonary edema risk); - Vasopressor (norepinephrine, phenylephrine carefully — already HTN); (8) Neonatal preparation: - Term but premature; - NICU team ready; - Magnesium effects on neonate (respiratory depression); (9) Post-op care: - ICU; - Continue magnesium 24h; - BP control; - Monitor for pulmonary edema, AKI, abruption, DIC, hepatic infarction/rupture; - Platelet count + LFT trending; - Hepatic rupture (rare, devastating) — abdominal pain, shock; (10) Multidisciplinary: OB + anesthesia + neonatology + ICU + hematology + critical care + family

---

HELLP + emergent C-section: GA with RSI (plt too low for neuraxial), difficult airway prep, blunt response to laryngoscopy, magnesium continuation, careful fluid + vasopressor, transfusion ready, ICU + monitor for hepatic rupture. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยหญิง 35 ปี G2P1 GA 32 wk — admitted for severe HELLP syndrome — emergent C-section
Plt 35k, AST 350, ALT 380, Hb 9, INR 1.2, fibrinogen 200
BP 165/105 on labetalol';

update public.mcq_questions
set choices = '[{"label":"A","text":"NSAID PCA"},{"label":"B","text":"Bariatric anesthesia (sleeve gastrectomy)"},{"label":"C","text":"Heavy benzo premed"},{"label":"D","text":"Total body weight all drugs"},{"label":"E","text":"Outpatient discharge"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bariatric anesthesia (sleeve gastrectomy): (1) Pre-op optimization: - CPAP for OSA — adherent 1-3 months pre-op; - Weight loss preoperative (some surgeons require); - Glucose control DM; - Smoking cessation; - Cardiac + pulmonary clearance; - Sleep study screening (STOP-BANG); - Pre-op clinic comprehensive evaluation; (2) Airway: - Difficult airway anticipated; - Pre-O2 thorough (rapid desaturation); - Ramped position (HELP); - Apneic oxygenation (high-flow NC during apnea); - Video laryngoscopy first-pass; - Multiple equipment + difficult airway plan; - Awake fiberoptic intubation for predicted very difficult; (3) Drug dosing: - Lean body weight for: induction (propofol, sux), NMB; - Total body weight for: succinylcholine, antibiotics; - Adjusted body weight for: maintenance, opioid; - Sugammadex weight-based; (4) Intra-op: - Lung-protective + PEEP 8-12; - Recruitment maneuvers; - Multimodal opioid-sparing (TAP/QL block, acetaminophen, ketamine, dexmedetomidine, dexamethasone); - AVOID NSAID after bariatric (ulcer + perforation risk); - PONV prophylaxis multimodal (Apfel + bariatric); - Glucose control; - DVT prophylaxis (mechanical + LMWH adjusted weight); (5) Position considerations: - Reverse Trendelenburg + steep; - Pad bony prominences; - Foot board; - Compartment syndrome risk lower extremity; (6) Pneumoperitoneum effects (covered separately) — limit pressure < 15 mmHg; (7) Surgical sleeve gastrectomy specific: - Bougie size; - Staple line check; - Leak test; - Drain selective; (8) Extubation: - Fully awake; - HOB up 30°; - Lateral position; - CPAP back ASAP; (9) Post-op: - Step-down or PACU monitoring; - Continuous SpO2 + capnography; - Multimodal pain (opioid-sparing maximally); - Early mobilization; - DVT prophylaxis; - Glucose control; - Aspiration precautions; - Nutrition (bariatric supplementation lifelong); (10) Multidisciplinary: bariatric surgery + anesthesia + nursing + nutrition + psychology + endocrinology; (11) ERAS bariatric protocol

---

Bariatric anesthesia: difficult airway prep, ramped position + HELP, drug dosing by weight class (LBW, ABW, TBW), multimodal + TAP block, AVOID NSAID, CPAP back ASAP, ERAS bariatric. Multidisciplinary lifelong care.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 40 ปี ASA III — sleep study confirms positional OSA + obesity
Needs elective bariatric surgery laparoscopic sleeve gastrectomy
BMI 45, neck circ 47 cm';

update public.mcq_questions
set choices = '[{"label":"A","text":"Propofol high dose"},{"label":"B","text":"Septic shock + emergent abdominal surgery"},{"label":"C","text":"Skip vasopressor"},{"label":"D","text":"Hypotonic fluid"},{"label":"E","text":"Discharge"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Septic shock + emergent abdominal surgery: (1) Source control — emergent surgery for ischemic bowel; (2) Pre-op (in ED already): - Antibiotics (broad-spectrum within 1h); - Fluid resuscitation initiated; - Norepinephrine started; - Lactate measured; - Cultures; (3) Anesthesia for emergent septic patient: - Pre-induction art line; CVL useful; - Continue vasopressor; - Induction agent — CV-stable: etomidate 0.3 mg/kg (single dose acceptable despite adrenal suppression theoretical concern in sepsis — controversial; consider stress steroid coverage); OR ketamine 0.5-1 mg/kg (preserves CV); - Reduced doses; - Rocuronium 1.2 mg/kg; - Avoid propofol bolus; (4) Maintenance: - Low-dose volatile + opioid (fentanyl, hydromorphone); - Minimize vasodilator effects; - Avoid prolonged opioid hangover (kidney + liver dysfunction); - Cisatracurium for NMB (organ-independent metabolism); (5) Resuscitation continued: - Goal-directed: MAP > 65, lactate clearance, urine output, ScvO2; - Balanced crystalloid; - Avoid colloid (HES contraindicated AKI); - Vasopressin + epinephrine if refractory; - Steroid (hydrocortisone 200 mg/d) for vasopressor-refractory; - Blood products as needed (Hb > 7 generally); (6) Renal protection: - Avoid nephrotoxins; - Maintain perfusion; - Monitor UO; - Consider CRRT post-op if AKI persists; (7) Glucose 140-180; (8) Ventilator: - Lung-protective TV 6 mL/kg IBW; - PEEP appropriate; - Avoid V/Q worsening; (9) Post-op: - ICU; - Continue resuscitation + source control if not achieved; - Open abdomen if damage control (ACS, packing); - Multidisciplinary; (10) Goals of care + family communication — elderly + emergent + sepsis = high mortality risk; ethical discussion important; (11) Modern: ABCDEF bundle ICU; sepsis bundle compliance correlates with outcome

---

Septic shock + emergent surgery: etomidate/ketamine induction (CV stable), continue vasopressor + fluid, source control surgery, ICU post-op, goals of care + family discussion. Cisatracurium. Multidisciplinary. ABCDEF bundle.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วยชาย 80 ปี — emergent abdominal surgery for ischemic bowel
Sepsis, lactate 6, BP 80/50 on norepi, K 5.5, AKI Cr 2.8
Intubated in ED';

update public.mcq_questions
set choices = '[{"label":"A","text":"Skip capnography"},{"label":"B","text":"GI endoscopy anesthesia (NORA)"},{"label":"C","text":"Heavy fentanyl"},{"label":"D","text":"Long-acting benzo"},{"label":"E","text":"Adult standard NPO ignored"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** GI endoscopy anesthesia (NORA): (1) Pre-procedure: - History + physical, allergies, comorbidities; - NPO standard; - IV access; - Monitoring (BP, ECG, SpO2, capnography mandatory); - Communication with endoscopist + plan; (2) Anesthesia options: - Conscious sedation (endoscopist-administered, often midazolam + fentanyl); - Monitored Anesthesia Care (MAC) by anesthesiologist — propofol-based; - General anesthesia with ETT for select cases (advanced procedures, aspiration risk); (3) Propofol MAC: - Bolus 0.5-1 mg/kg + titrated infusion 50-150 mcg/kg/min; - Fentanyl 25-50 mcg adjunct; - Maintains airway often; - Smooth + rapid recovery; - Respiratory depression risk (especially OSA, obesity, elderly, with opioids); (4) OSA considerations: - Increased risk obstruction + apnea; - Lateral position helps; - Capnography essential; - Consider lower target depth; - Have airway equipment ready; - Bigger role for endoscopist suction; (5) Specific procedures: - Colonoscopy — supine to lateral; bowel preparation may cause dehydration; - EGD — shared airway, bite block; - ERCP — prone or lateral; longer; - EUS — similar to EGD/ERCP; - Bronchoscopy — shared airway; topical lidocaine; high O2 needs; (6) Risks: - Aspiration (especially upper GI, ileus); - Airway obstruction (OSA); - Hemodynamic instability; - Bleeding (polypectomy); - Perforation; (7) Recovery: - PACU standard discharge criteria; - Cannot drive same day; - Escort home; - Diet advancement gradual; (8) Anticoagulant management — coordinate with proceduralist; (9) Modern: increasing complex GI procedures (ESD, POEM, advanced ERCP) — anesthesia involvement increasing; (10) Multidisciplinary: GI + anesthesia + nursing

---

GI endoscopy MAC: propofol-based + low-dose fentanyl, capnography mandatory, OSA considerations (lateral, lower depth, equipment ready), specific procedure considerations (EGD shared airway, ERCP prone). Aspiration risk.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'ผู้ป่วย 55 ปี — diagnostic colonoscopy + polypectomy under MAC sedation
BMI 32, OSA STOP-BANG 5, controlled HTN
Using propofol + fentanyl by anesthesiologist';

update public.mcq_questions
set choices = '[{"label":"A","text":"Skip BP monitoring"},{"label":"B","text":"Blood pressure monitoring"},{"label":"C","text":"Single technique always"},{"label":"D","text":"Wrong cuff size OK"},{"label":"E","text":"No arterial line ever"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Blood pressure monitoring — physics + methods: (1) Indirect (non-invasive): - Manual sphygmomanometer (auscultation Korotkoff sounds — gold standard intermittent); - Oscillometric (automated, most common); detects oscillations, calculates MAP from peak amplitude, derives SBP + DBP from algorithm; - Limitations: errors at extreme pressures, arrhythmia, motion, cuff size; - Cuff size — bladder 80% arm circumference (too small = falsely high; too large = falsely low); - Wrong cuff size most common error; (2) Direct (invasive arterial line): - Continuous beat-to-beat; - Accurate at extreme pressures; - Allows ABG sampling; - Risk: bleeding, thrombosis, infection, ischemia (Allen test); - Common sites: radial > femoral > brachial > axillary > dorsalis pedis; - Wave form analysis: dicrotic notch, slope, pulse pressure variation (fluid responsiveness); - Damped (occlusion, air, fibrosis); - Resonant (under-damped — over-shoot); (3) Indications arterial line: - Hemodynamic instability; - Major surgery (cardiac, vascular, neuro); - Frequent ABG; - Vasoactive infusion titration; - Inaccurate noninvasive (extreme BMI, edema); (4) Newer non-invasive continuous: - ClearSight, Nexfin (finger cuff); - LiDCO; - FloTrac; - Comparable in many cases but not all; (5) Central venous pressure: - Limited utility static fluid responsiveness; - Useful for vasoactive infusion access, fluid administration, vasopressor monitoring; (6) Pulmonary artery catheter (Swan-Ganz): - Decreasing use; - Useful in selected complex cases (right HF, PAH, complex cardiac); - Complications: arrhythmia, infection, pulmonary infarct/rupture; (7) Cardiac output monitoring: - Thermodilution (PA cath gold standard); - Esophageal Doppler; - Pulse contour (FloTrac); - Bioreactance; - Lithium dilution; (8) Selection — least invasive that meets goal

---

BP monitoring: manual + oscillometric NIBP (cuff size critical), arterial line for instability/major surgery/vasoactive (radial > others, Allen test). CVP limited fluid utility. PA cath declining. Newer NIBP continuous. Least invasive that meets goal.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Basic science: blood pressure monitoring techniques + invasive vs noninvasive';

update public.mcq_questions
set choices = '[{"label":"A","text":"Single provider 24/7"},{"label":"B","text":"Emergency anesthesia coverage + staffing"},{"label":"C","text":"No staffing plan"},{"label":"D","text":"Skip after-hours quality"},{"label":"E","text":"Refuse emergency"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Emergency anesthesia coverage + staffing: (1) Coverage models: - 24/7 in-house; - On-call from home; - Combination; - Trainee coverage with attending availability; (2) Staffing decisions based on: - Case volume + acuity; - Geographic factors (distance to hospital); - Reimbursement; - Quality + safety standards; - Resident education; - Workforce sustainability; (3) Emergency case categories (NCEPOD): - Immediate (life/limb/organ saving — within minutes); - Urgent (life/limb/organ saving — within hours); - Expedited (early treatment — within days); - Elective (planned); (4) Acuity-based triage + prioritization: - Communication surgeon + anesthesia + OR; - Multiple emergencies simultaneously — triage; - Document; (5) After-hours considerations: - Reduced staffing; - Fatigue + safety; - Communication challenges; - Resource limitations; (6) Quality + safety after hours: - Standards same as daytime; - Surgical timing for elective; - Trauma + emergency only after hours where possible; - Fatigue mitigation; (7) Wellness + sustainability: - Duty hour limits; - Hand-off + sleep protection; - Mental health resources; - Substance use awareness; (8) Multidisciplinary: anesthesia + surgery + OR nursing + administration; (9) Pediatric + cardiac + neurosurgery sub-specialty coverage; (10) Communication: - Clear escalation pathways; - Centralized call schedule; - Backup coverage; (11) Quality improvement: - Adverse event after hours; - Audit + feedback; - Continuous improvement; (12) Modern: telemedicine coverage, AI scheduling, work-life balance focus, COVID-19 + recovery impact, recruitment challenges

---

Emergency coverage: 24/7 in-house vs on-call models, acuity-based triage (NCEPOD), after-hours standards same, fatigue mitigation, multidisciplinary communication, quality improvement, sub-specialty considerations, modern: telemedicine + AI scheduling.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Management question: clinical pathway for emergency anesthesia department coverage';

update public.mcq_questions
set choices = '[{"label":"A","text":"Ignore disparities"},{"label":"B","text":"Health equity + anesthesia outcomes"},{"label":"C","text":"Single approach all"},{"label":"D","text":"Treat all same regardless"},{"label":"E","text":"Skip community"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Health equity + anesthesia outcomes: (1) Social Determinants of Health (SDOH) — non-medical factors affecting health: - Economic stability; - Education; - Healthcare access; - Neighborhood + environment; - Social + community context; (2) Anesthesia outcome disparities: - Pain treatment (multiple studies showing minorities undertreated for pain); - Surgical mortality higher in lower socioeconomic; - Maternal mortality (Black women 3-4× higher); - Access to specialty care + transplant; - Insurance + reimbursement disparities; (3) Bias in healthcare: - Implicit bias (automatic stereotyping); - Structural racism in policy + practice; - Provider biases affecting decisions; - System designed for some not others; - Awareness + reflection + training; (4) Addressing disparities: - Education + training; - Workforce diversity; - Patient-centered care; - Community engagement; - Policy advocacy; - Quality improvement targeting equity; - Data stratification by demographics; (5) Specific anesthesia-relevant interventions: - Multilingual care; - Cultural humility training; - Outreach in underserved; - Pain management equity; - Pre-op clinic for high-risk; - ERAS for all (reducing disparities); - Mobile health technology; - Telemedicine; (6) Maternal mortality: - Black maternal mortality crisis; - Multi-faceted (pre-existing, access, bias, treatment); - California Maternal Quality Collaborative model; (7) Pediatric — child poverty effects; (8) LGBTQ+ health (covered); (9) Global health (covered); (10) Disability — accommodations + accessibility; (11) Modern: anti-racism in medicine, structural competency, advocacy, ASA + APSF + AAMC initiatives; (12) Resources: - SDOH screening; - Community health workers; - Social work referrals; - Patient advocacy

---

Health equity: SDOH affect anesthesia outcomes (pain undertreatment minorities, maternal mortality, surgical outcomes). Implicit bias + structural racism awareness. Interventions: education, diversity, patient-centered, advocacy, ERAS, data stratification. Modern: anti-racism + structural competency.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Integrative: socioeconomic determinants of anesthesia outcomes + health equity';

update public.mcq_questions
set choices = '[{"label":"A","text":"Resist all AI"},{"label":"B","text":"Future of anesthesia"},{"label":"C","text":"Replace all clinicians"},{"label":"D","text":"Skip ethics"},{"label":"E","text":"Single use only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Future of anesthesia — AI/ML: (1) Current AI applications: - Hypotension Prediction Index (HPI) — predicts hypotension before occurrence; FDA-approved; - Difficult airway prediction; - Drug dosing optimization; - PONV risk stratification; - Mortality + complication prediction; - Closed-loop drug delivery (target-controlled infusion, BIS-guided sedation, fluid management); - Image analysis (ultrasound for regional anesthesia, echo); - Natural language processing (chart review, documentation); (2) Machine learning approaches: - Supervised (predict outcomes); - Unsupervised (clustering, phenotypes); - Deep learning (neural networks, image, complex pattern); - Reinforcement learning (sequential decision-making); (3) Big data sources: - EHR (NACOR registry); - Wearables + continuous monitoring; - Genomics; - Imaging; - Patient-reported outcomes; (4) Considerations + challenges: - Data quality + standardization; - Algorithmic bias (training data); - Interpretability (black box); - Generalizability across populations; - Validation in diverse cohorts; - Regulatory (FDA SaMD framework); - Liability + accountability; - Privacy + security; - Implementation + workflow integration; - Provider acceptance + training; - Equity concerns (digital divide, bias); (5) Closed-loop systems: - Anesthesia delivery; - Fluid resuscitation; - Glucose control; - Ventilation; - Sedation; - Need to balance autonomy + safety; (6) Telemedicine + remote: - Pre-op evaluation; - Tele-ICU; - Mentorship; - Disaster + global; (7) Wearable + continuous: - Home monitoring post-discharge; - Early detection complications; (8) Ethical considerations: - Bias propagation; - Job displacement (mostly augmentation not replacement); - Patient autonomy + consent; - Equity + access; (9) Education + training: - AI literacy for anesthesiologists; - Lifelong learning; - Hybrid expertise (clinical + computational); (10) Anesthesiologist role evolving: - Decision support partner; - Quality + safety oversight; - Higher-level + complex case focus; - Education + research; - Leadership + advocacy; (11) Modern: rapidly evolving field, opportunity for anesthesiology leadership

---

Future anesthesia: AI/ML (HPI, prediction, closed-loop, imaging). Considerations: bias, interpretability, regulation, equity. Wearables + telemedicine. Ethical + equity considerations. Anesthesiologist role evolves (augmentation + leadership). Rapidly evolving field.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Integrative: future of anesthesia — AI, machine learning, automation';

update public.mcq_questions
set choices = '[{"label":"A","text":"Skip CME"},{"label":"B","text":"Anesthesia education + lifelong learning"},{"label":"C","text":"Single training only"},{"label":"D","text":"Avoid simulation"},{"label":"E","text":"No mentorship"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Anesthesia education + lifelong learning: (1) Education hierarchy: - Medical school; - Residency (4 years anesthesia in US after intern); - Fellowship (cardiac, pediatric, OB, regional, pain, critical care, NORA); - Continuous practice + learning; (2) ACGME competencies: - Patient care; - Medical knowledge; - Practice-based learning + improvement; - Interpersonal + communication; - Professionalism; - Systems-based practice; (3) Maintenance of Certification in Anesthesiology (MOCA): - 10-year cycle; - Continuous learning (MOCA Minute); - Periodic assessment; - Quality improvement; - Professional standing; - 4 components by ABA; (4) Continuing Medical Education (CME): - Required for licensure + boards; - Categories: lecture, simulation, journal, online, self-directed; - ACCME accreditation; (5) Adult learning theory: - Self-directed; - Experience-based; - Relevant + applicable; - Problem-centered; (6) Effective methods: - Active learning > passive; - Simulation (high-fidelity, standardized patient); - Procedural skills practice; - Debriefing; - Peer learning; - Mentorship; - Feedback (formative + summative); (7) Resident education: - Graduated responsibility; - Case mix variety; - Sub-specialty exposure; - Wellness + work-life balance; - Inter-professional training; - QI + research; (8) Faculty development: - Teaching skills; - Educational scholarship; - Mentoring; - Curriculum design; (9) Educational research: - Evidence-based education; - Implementation; - Assessment validity; (10) Professional engagement: - Specialty societies (ASA, AAGBI, ESA); - Conferences; - Journals; - Online communities; (11) Mentorship: - Formal + informal; - Sponsorship; - Career navigation; - Bidirectional; (12) Modern: digital education, podcasts, MOOCs, social media, simulation centers, telementoring, lifelong learning culture; (13) Wellness integrated with education — sustainable career

---

Anesthesia education: medical school → residency → fellowship → MOCA. ACGME competencies. Adult learning theory. Simulation + active learning. Mentorship. CME. Professional engagement. Modern: digital + lifelong learning culture integrated with wellness.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'anesthesiology'
  and scenario = 'Integrative: educational + lifelong learning in anesthesia';

commit;
