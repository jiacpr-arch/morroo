-- ===============================================================
-- UPDATE chunk 3/8: anesthesiology (25 questions)
-- ===============================================================

begin;

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

commit;
