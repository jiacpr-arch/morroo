-- ===============================================================
-- UPDATE chunk 6/8: anesthesiology (25 questions)
-- ===============================================================

begin;

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

commit;
