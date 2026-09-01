-- ===============================================================
-- UPDATE chunk 4/8: anesthesiology (25 questions)
-- ===============================================================

begin;

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

commit;
