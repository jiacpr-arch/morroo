-- ===============================================================
-- หมอรู้ — Board seed: วิสัญญีวิทยา (anesthesiology) — part 2/4 (50 MCQs)
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
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 35 ปี G3P2 GA 40 wk vaginal delivery
Post-delivery: heavy bleeding > 1500 mL, uterus boggy, vital signs deteriorating BP 80/45, HR 120
Oxytocin infusion running, manual fundal massage ongoing', '[{"label":"A","text":"Wait for bleeding to stop"},{"label":"B","text":"Postpartum hemorrhage (PPH)"},{"label":"C","text":"Vasopressor only without transfusion"},{"label":"D","text":"Volatile anesthesia high dose"},{"label":"E","text":"Limit fluids strictly"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Postpartum hemorrhage (PPH) — anesthesia + multidisciplinary: (1) Massive Transfusion Protocol activation; 2 large-bore IV; T+C 4-6 units; arterial line; (2) Uterine atony = most common cause; massage + uterotonics escalation: - Oxytocin 10-40U IV in 1L (avoid fast bolus — hypotension); - Methylergonovine 0.2mg IM (avoid in HTN/PEC); - Carboprost (PGF2a) 0.25mg IM q15min (avoid in asthma); - Misoprostol 800-1000mcg PR or SL; (3) Tranexamic acid 1g IV within 3h (WOMAN trial — reduces death); (4) Other causes — Tears, Tissue (retained), Thrombin (coagulopathy) — 4Ts; check retained placenta, lacerations; (5) Balanced transfusion 1:1:1 PRC:FFP:Plt; fibrinogen target > 2 g/L (cryo if low); calcium replacement (citrate); warm fluids; (6) Surgical interventions — uterine balloon (Bakri, Belfort-Dildy), B-Lynch suture, uterine artery ligation/embolization, hysterectomy; (7) Anesthesia: GA likely for instability + emergent procedure; ketamine or etomidate for induction (CV stable); avoid volatile high dose (uterine relaxation); (8) Monitor — labs (Hb, coag, fibrinogen, lactate), TEG/ROTEM if available; (9) Postpartum care — ICU, monitor coagulopathy, AKI, Sheehan syndrome; (10) Modern: REBOA for massive PPH refractory; cell salvage acceptable in OB now; multidisciplinary code team

---

PPH: 4Ts (Tone/Tear/Tissue/Thrombin). Uterotonic ladder. TXA. Balanced transfusion 1:1:1. Surgical escalation (balloon, B-Lynch, hysterectomy). GA with CV-stable induction. ICU post-op. Cell salvage OK.', NULL,
  'medium', 'obgyn', 'review',
  'anesthesiology', 'clinical_decision', 'obgyn', 'adult',
  'SOAP PPH Consensus; WHO PPH Recommendations', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 35 ปี G3P2 GA 40 wk vaginal delivery
Post-delivery: heavy bleeding > 1500 mL, uterus boggy, vital signs deteriorating BP 80/45, HR 120
Oxytocin infusion running, manual fundal massage ongoing'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 32 ปี G2P1 GA 39 wk in labor with epidural × 6h, baby delivered
Sudden: dyspnea + cyanosis + cardiovascular collapse + DIC + altered mental status
BP 60/30, SpO2 78%, ETCO2 dropping during CPR', '[{"label":"A","text":"Tocolysis"},{"label":"B","text":"Amniotic Fluid Embolism (AFE)"},{"label":"C","text":"Discharge home immediately"},{"label":"D","text":"Beta-blocker IV"},{"label":"E","text":"Limit oxygen therapy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Amniotic Fluid Embolism (AFE) — rare but fatal: (1) Clinical — peri-/postpartum sudden cardiovascular collapse + hypoxia + DIC + altered mental status; mortality 30-60%; (2) Pathophys — amniotic fluid + fetal cells into maternal circulation → anaphylactoid + pulmonary vasoconstriction + RV failure + DIC; (3) DDx — PE, hemorrhage, sepsis, MI, anaphylaxis, eclampsia, LAST; (4) Immediate — ACLS modified for pregnant if pre-delivery (LUD = left uterine displacement, perimortem C-section within 4 min cardiac arrest if no ROSC); (5) Airway — intubate + 100% O2 + lung-protective ventilation; (6) Hemodynamic support — fluid resuscitation cautious (RV failure), epinephrine, norepinephrine, vasopressin; pulmonary vasodilator (inhaled NO, milrinone, sildenafil); (7) RV support — TEE-guided management, inotropes (dobutamine, milrinone), avoid fluid overload; (8) ECMO — early consideration; (9) Coagulopathy — massive transfusion 1:1:1, fibrinogen replacement aggressive (target > 2-2.5 g/L), TXA, cryoprecipitate; TEG/ROTEM; (10) A-OK regimen — atropine 1mg + ondansetron 8mg + ketorolac 30mg (case reports); (11) Multidisciplinary — anesthesia + OB + ICU + hematology + cardiac surgery; (12) Survival improving with aggressive management + recognition; (13) Post-event: report to AFE registry, family support, debriefing; (14) No prevention — sporadic

---

AFE: peri-/postpartum collapse + hypoxia + DIC. ACLS + perimortem C-section if pre-delivery. Aggressive transfusion + fibrinogen. RV support. ECMO. A-OK regimen. Multidisciplinary.', NULL,
  'hard', 'obgyn', 'review',
  'anesthesiology', 'clinical_decision', 'obgyn', 'adult',
  'SMFM Consult Series AFE 2016; SOAP Maternal Cardiac Arrest', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 32 ปี G2P1 GA 39 wk in labor with epidural × 6h, baby delivered
Sudden: dyspnea + cyanosis + cardiovascular collapse + DIC + altered mental status
BP 60/30, SpO2 78%, ETCO2 dropping during CPR'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 28 ปี G1P0 GA 38 wk active labor, requesting epidural
BP 110/70, HR 88, no contraindications
Lumbar spine palpable normally', '[{"label":"A","text":"Decline patient request"},{"label":"B","text":"Labor epidural"},{"label":"C","text":"GA only routine"},{"label":"D","text":"No analgesia natural birth"},{"label":"E","text":"IV opioid only no neuraxial"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Labor epidural — standard technique + management: (1) Pre-procedure — consent (risks: headache 1%, hypotension, failure, infection, hematoma rare, nerve injury rare, total spinal); IV access + fluid co-load; monitors (BP, HR, SpO2, FHR); (2) Position — sitting or lateral decubitus; back arched; (3) Sterile technique — chlorhexidine prep, drape, mask; (4) Identify L3-4 or L4-5 (avoid cord); LOR (loss of resistance) to saline or air; thread catheter 3-5 cm; (5) Test dose — lidocaine 1.5% + epi 1:200,000, 3 mL — detects intravascular (HR rise) or intrathecal (motor block); (6) Loading dose — bupivacaine 0.0625-0.125% with fentanyl 2 mcg/mL, 10-15 mL incremental; (7) Maintenance — PCEA (Patient-Controlled Epidural Analgesia): continuous low-dose (8-12 mL/hr) + bolus (5 mL q10-15 min); or PIEB (Programmed Intermittent Epidural Bolus) — newer, less local + better coverage; (8) Local anesthetic — bupivacaine 0.0625-0.125% with fentanyl 2 mcg/mL most common; ropivacaine alternative; (9) Goals — sensory T10, motor preservation (walking epidural concept), maternal satisfaction; (10) Monitor for hypotension (fluid + phenylephrine), inadequate block (re-dose, replace catheter), high block, intravascular migration, PDPH; (11) C-section conversion — bolus 2% lidocaine 15-20 mL with epinephrine + bicarbonate; T4 dermatome; (12) Modern: CSE (combined spinal-epidural) for faster onset; ultrasound-guided neuraxial helps in difficult

---

Labor epidural: test dose, low-dose bupivacaine + fentanyl, PCEA/PIEB. Convert to C-section with 2% lidocaine + epi + bicarb. Walking epidural concept. CSE faster onset. Ultrasound helps difficult.', NULL,
  'easy', 'obgyn', 'review',
  'anesthesiology', 'clinical_decision', 'obgyn', 'adult',
  'SOAP Labor Analgesia; ASA OB Anesthesia Practice Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 28 ปี G1P0 GA 38 wk active labor, requesting epidural
BP 110/70, HR 88, no contraindications
Lumbar spine palpable normally'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชาย 4 ปี ASA I — elective tonsillectomy + adenoidectomy
Weight 16 kg, healthy, no allergies, NPO 8h
No family history of anesthesia issues', '[{"label":"A","text":"Adult-dosed propofol"},{"label":"B","text":"Pediatric T+A anesthesia + airway"},{"label":"C","text":"No pain medication"},{"label":"D","text":"Long-acting opioid premedication"},{"label":"E","text":"Skip dexamethasone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric T+A anesthesia + airway: (1) Pre-op — fasting (clear fluids 1-2h, breast milk 4h, formula/light meal 6h, full meal 8h — modern shorter clear fluids OK); avoid pre-medication unless anxious (midazolam PO 0.5 mg/kg); EMLA cream for IV access; parental presence + child life; (2) Induction options: - Inhalational (mask) sevoflurane 8% in O2/N2O → IV access after — common in children; - IV propofol 2-3 mg/kg + opioid + NMB (older children); (3) Airway — RAE tube (oral preformed) for surgical access; size = age/4 + 4 (uncuffed) or age/4 + 3.5 (cuffed); cuffed ETT now standard for most peds (low-pressure cuffs); (4) Position — Rose''s position (head extension), shared airway with surgeon; (5) Maintenance — sevoflurane in O2/air; opioid (fentanyl 1-2 mcg/kg); avoid N2O if PONV risk; multimodal — acetaminophen + dexamethasone + ondansetron; (6) Dexamethasone 0.15-0.5 mg/kg (max 8mg) — PONV + airway edema + analgesia; (7) Post-tonsillectomy bleeding — risk 1-3% (primary 24h, secondary 5-10 days) — emergency = full stomach swallowed blood, hypovolemia, difficult airway; RSI with cricoid + suction ready; (8) Extubation — deep extubation or fully awake (debated); (9) Post-op — PONV common (Apfel + opioid + surgery type all high); multimodal antiemetics; pain control; observation for bleeding 4-8h; (10) OSA considerations — common indication; reduce opioid, observe overnight

---

Peds T+A: inhalational induction common, RAE tube, cuffed ETT modern, dexamethasone, multimodal anti-emetic + analgesia. Watch for OSA + post-op bleed (RSI). Modern shorter fasting clear fluids 1-2h.', NULL,
  'easy', 'respiratory', 'review',
  'anesthesiology', 'clinical_decision', 'respiratory', 'peds',
  'APAGBI Tonsillectomy Guidelines; SPA Practice Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'เด็กชาย 4 ปี ASA I — elective tonsillectomy + adenoidectomy
Weight 16 kg, healthy, no allergies, NPO 8h
No family history of anesthesia issues'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชาย 2 ปี 12 kg — preop assessment, mother reports URI ปัจจุบัน × 3 วัน, runny nose green, cough productive, mild fever 37.8°C
Elective inguinal hernia repair scheduled today', '[{"label":"A","text":"Proceed always"},{"label":"B","text":"Pediatric URI + anesthesia decision"},{"label":"C","text":"Refuse all elective surgery for 6 months"},{"label":"D","text":"Use ETT always"},{"label":"E","text":"Ignore symptoms"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric URI + anesthesia decision: (1) Risks of anesthesia with URI — laryngospasm (10× higher), bronchospasm, hypoxemia, desaturation, breath-holding, atelectasis; severity = active URI > recovering > none; (2) Decision factors: - Symptoms active (purulent rhinorrhea, productive cough, fever > 38) — consider DELAY; - LRTI signs (wheezing, crackles, severe cough) = DELAY 2-4 weeks; - Mild symptoms only (clear runny nose, no fever, no cough) — proceed with caution; - Risk factors increasing risk: prematurity, asthma, OSA, surgery type (airway), GA + ETT vs LMA vs regional; (3) Delay timing — wait 2-4 weeks for full resolution; longer (6 weeks) if severe LRTI; (4) If proceed despite URI: - Avoid ETT if possible (LMA or mask preferred); - Maintain anesthesia depth, especially at extubation; - Avoid stimulating airway; - Higher FiO2; - Bronchodilator pre-op if reactive airway; - Consider regional anesthesia (caudal block for hernia); (5) Parental discussion — risks + alternatives; (6) Inguinal hernia repair — caudal block adjuvant minimizes opioid + general anesthetic; (7) For THIS patient (active purulent symptoms, fever) — recommend RESCHEDULE 2-4 weeks; (8) Document

---

Peds URI: active symptoms (fever, purulent, productive cough) = delay 2-4 weeks; mild (clear rhinorrhea) = proceed cautiously, LMA over ETT, regional. Risk laryngospasm/bronchospasm 10× higher.', NULL,
  'easy', 'respiratory', 'review',
  'anesthesiology', 'clinical_decision', 'respiratory', 'peds',
  'Cote Pediatric Anesthesia; SPA URI Practice Advisory', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'เด็กชาย 2 ปี 12 kg — preop assessment, mother reports URI ปัจจุบัน × 3 วัน, runny nose green, cough productive, mild fever 37.8°C
Elective inguinal hernia repair scheduled today'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กเล็ก 6 เดือน 7 kg — emergency pyloric stenosis pyloromyotomy
Vomiting × 3 วัน, dehydrated
Lab: Na 128, K 3.0, Cl 88, HCO3 32, pH 7.50', '[{"label":"A","text":"Proceed immediately"},{"label":"B","text":"Pyloric stenosis = MEDICAL emergency, NOT surgical; correct electrolyte first"},{"label":"C","text":"Use furosemide for diuresis"},{"label":"D","text":"Skip electrolyte check"},{"label":"E","text":"Adult-dosed medications"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pyloric stenosis = MEDICAL emergency, NOT surgical; correct electrolyte first: (1) Hypochloremic, hypokalemic, metabolic alkalosis (from persistent vomiting losing HCl); pyloric stenosis: - Surgical correction can wait until electrolytes corrected; - Goal: Cl > 95, K > 3.5, HCO3 < 30, normal pH; (2) IV rehydration — NS bolus 20 mL/kg (~140 mL for 7 kg), then D5 1/2 NS + KCl 20-40 mEq/L at 1.5× maintenance rate; takes 12-48h typically; (3) Anesthesia considerations once corrected: - Full stomach — RSI with cricoid; suction OG before induction; - Propofol or sevoflurane mask induction; succinylcholine 2 mg/kg or rocuronium 1.2 mg/kg; - Cuffed ETT size 4.0; - Atropine 20 mcg/kg pre-induction (bradycardia risk neonates); (4) Postoperative apnea risk — alkalosis + CSF alkalosis → post-op apnea up to 24h; monitor closely; avoid long-acting opioid; multimodal — acetaminophen, local infiltration, ilioinguinal block; (5) Hypoglycemia risk — D5 maintenance; (6) Temperature — neonatal heat loss; warm fluids, warming devices; (7) Post-op — apnea monitoring 12-24h, NG suction, ICU/HDU; (8) NEVER operate before electrolyte correction — anesthesia risk + arrhythmia + post-op apnea worse; (9) Multidisciplinary — peds surgery + anesthesia + neonatology

---

Pyloric stenosis: medical emergency first - correct hypochloremic hypoK metabolic alkalosis BEFORE surgery. RSI with cricoid. Atropine pre-induction. Post-op apnea risk monitor 12-24h. Multimodal analgesia.', NULL,
  'medium', 'gi', 'review',
  'anesthesiology', 'clinical_decision', 'gi', 'peds',
  'Cote Pediatric Anesthesia; APAGBI Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'เด็กเล็ก 6 เดือน 7 kg — emergency pyloric stenosis pyloromyotomy
Vomiting × 3 วัน, dehydrated
Lab: Na 128, K 3.0, Cl 88, HCO3 32, pH 7.50'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกแรกเกิด full-term 3.2 kg, day of life 1 — neonatal congenital diaphragmatic hernia (CDH) surgical repair planned
Intubated, on HFOV, iNO, PaO2 60, PaCO2 50, pH 7.30
Unstable hemodynamics on epinephrine + milrinone', '[{"label":"A","text":"Operate immediately"},{"label":"B","text":"Congenital diaphragmatic hernia"},{"label":"C","text":"Mask bag ventilation"},{"label":"D","text":"Use N2O routinely"},{"label":"E","text":"Aggressive hyperventilation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Congenital diaphragmatic hernia — neonatal anesthesia: (1) Pre-op stabilization is KEY — modern approach delays surgery until stable (24-72h+); pulmonary hypertension + lung hypoplasia drive outcomes; (2) Stabilization: gentle ventilation (HFOV often), permissive hypercapnia (pH > 7.20, PaCO2 50-65), avoid hyperventilation, low PIP target < 25-28; iNO for PHTN; cardiotonic support (milrinone, dobutamine, epinephrine, vasopressin); avoid pulmonary vasoconstriction (hypoxia, acidosis, cold, pain); (3) ECMO criteria — refractory hypoxemia/hypercarbia despite max conventional support; (4) Anesthesia approach when ready for surgery: - Continue current ventilation strategy in OR; - Avoid mask ventilation pre-op (gastric distension worsens lung compression) — already intubated typically; - OG tube continuous suction; - Anesthetic: fentanyl-based (CV stable), low MAC sevoflurane if tolerated, NMB; - Avoid N2O (expands bowel); (5) Monitor — pre/post-ductal SpO2 (right radial + lower extremity), arterial line, +/- CVL, urine output, temperature; (6) Volume status — careful, avoid both over and under-resuscitation; (7) Surgical — repair via subcostal or thoracoscopic; primary closure or patch; (8) Post-op — NICU; expect prolonged ventilation; pulmonary HTN management ongoing; (9) Long-term — chronic lung disease, GERD, neurodevelopmental issues; (10) Multidisciplinary: neonatology + peds surgery + anesthesia + ECMO team

---

CDH: delay surgery until stable, gentle ventilation, permissive hypercapnia, iNO for PHTN. No mask BVM (gastric distension). Pre/post-ductal SpO2. Fentanyl-based anesthesia. ECMO if refractory.', NULL,
  'hard', 'respiratory', 'review',
  'anesthesiology', 'clinical_decision', 'respiratory', 'peds',
  'CDH EURO Consortium Guidelines; SPA Neonatal Anesthesia', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ทารกแรกเกิด full-term 3.2 kg, day of life 1 — neonatal congenital diaphragmatic hernia (CDH) surgical repair planned
Intubated, on HFOV, iNO, PaO2 60, PaCO2 50, pH 7.30
Unstable hemodynamics on epinephrine + milrinone'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชาย 5 ปี 18 kg — laryngospasm after sevoflurane induction prior to IV access
SpO2 95→78%, paradoxical movement, no air movement
No IV yet, no surgical stimulation', '[{"label":"A","text":"Wait observe"},{"label":"B","text":"Pediatric laryngospasm management"},{"label":"C","text":"Continue mask without intervention"},{"label":"D","text":"Decrease sevoflurane"},{"label":"E","text":"Mass IV fluid bolus"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric laryngospasm management: (1) Recognition — inspiratory stridor → silent obstruction; chest wall paradoxical motion; desaturation; often during light anesthesia + airway stimulation; (2) Immediate — call for help; (3) Larson maneuver — pressure to ''laryngospasm notch'' (behind ear lobe, condyle of mandible, mastoid process) — bilateral firm anterior pressure; jaw thrust; (4) 100% O2 + tight mask seal + CPAP 10-15 cmH2O via mask; (5) Deepen anesthesia — increase sevoflurane if tolerated, BUT often need IV access; (6) IV access — establish ASAP; if no IV: - IM succinylcholine 4 mg/kg (max 200 mg) + atropine 20 mcg/kg (prevent bradycardia); onset 2-4 min; - IO access if difficult IV; - Intralingual succinylcholine emergency (controversial); (7) Once IV: propofol 0.5-1 mg/kg (deepen, may break spasm) OR succinylcholine 0.5-1 mg/kg IV; (8) Bradycardia risk in peds during hypoxia — atropine 20 mcg/kg ready; (9) NPPE (negative pressure pulmonary edema) — risk after relieved laryngospasm; treat with PEEP, diuretic; (10) Cardiac arrest — pediatric hypoxic arrest can occur quickly; ACLS pediatric algorithm; (11) Prevention — avoid extubation in light plane, suction before extubation, no stimulation during light plane, awake or deep extubation only; magnesium 30 mg/kg may reduce; (12) Post-event — observe for NPPE, document

---

Peds laryngospasm: Larson maneuver + CPAP 100% O2, deepen with propofol if IV, IM sux + atropine if no IV. Bradycardia risk. NPPE post-relief. Prevent: avoid light-plane stimulation.', NULL,
  'medium', 'respiratory', 'review',
  'anesthesiology', 'clinical_decision', 'respiratory', 'peds',
  'APAGBI Pediatric Airway; Cote Pediatric Anesthesia', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'เด็กชาย 5 ปี 18 kg — laryngospasm after sevoflurane induction prior to IV access
SpO2 95→78%, paradoxical movement, no air movement
No IV yet, no surgical stimulation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 68 ปี CABG × 3, LVEF 30%, severe LV dysfunction
During induction post-fentanyl + etomidate: BP drops 120/70 → 70/40, no surgical stimulation yet
CVP 8, pulse contour CO showing low cardiac output', '[{"label":"A","text":"Continue induction"},{"label":"B","text":"Cardiac anesthesia induction in severe LV dysfunction"},{"label":"C","text":"Massive propofol bolus"},{"label":"D","text":"High volatile concentration"},{"label":"E","text":"Beta-blocker"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cardiac anesthesia induction in severe LV dysfunction: (1) Induction hypotension common in severe HF — minimize CV impact: - Etomidate or ketamine preferred (less hypotension); - Slow titrated fentanyl (5-10 mcg/kg total); - Avoid propofol bolus (myocardial depression + vasodilation); - Pre-induction arterial line + vasopressor ready; (2) Treatment immediate: - Vasopressor bolus — phenylephrine 50-100 mcg or norepinephrine 4-8 mcg or vasopressin 0.5-1U; - Inotrope if low CO — epinephrine 5-10 mcg, ephedrine 5-10 mg, milrinone bolus carefully; - Volume — TEE guided if available; cautious in HF (avoid pulm edema); 250 mL crystalloid bolus if low filling; - Reduce afterload — only if elevated SVR + adequate BP; - Treat arrhythmia (HR + rhythm); (3) Re-evaluate anesthetic depth + adjust; (4) Cardiac anesthesia principles: - Maintain coronary perfusion (DBP - LVEDP); - Avoid tachycardia (worsens ischemia); - Avoid extreme HTN/HoTN; - Multimodal — opioid-based + low-dose volatile; - TEE intraop monitoring; - Goal-directed hemodynamic management; (5) Pre-induction prep — arterial line awake (radial), vasopressor/inotrope drawn up + running, TEE probe ready, surgeon scrubbed in cardiac case; (6) Post-CPB considerations — vasoplegia common; methylene blue + vasopressin if refractory norepinephrine; (7) Post-op — ICU, hemodynamic monitoring, weaning support, neuro recovery

---

Cardiac induction in low EF: etomidate/ketamine, slow fentanyl, avoid propofol bolus. Vasopressor + inotrope ready. TEE-guided. Pre-induction arterial line. Goal-directed hemodynamic.', NULL,
  'hard', 'cardiovascular', 'review',
  'anesthesiology', 'clinical_decision', 'cardiovascular', 'adult',
  'SCA Cardiac Anesthesia Practice; ASE/SCA TEE Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 68 ปี CABG × 3, LVEF 30%, severe LV dysfunction
During induction post-fentanyl + etomidate: BP drops 120/70 → 70/40, no surgical stimulation yet
CVP 8, pulse contour CO showing low cardiac output'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 60 ปี — right-sided lung resection (lobectomy) for cancer
FEV1 65%, DLCO 70%, no other CV disease
Plan one-lung ventilation', '[{"label":"A","text":"Standard ETT bilateral ventilation"},{"label":"B","text":"One-lung ventilation (OLV) for thoracic surgery"},{"label":"C","text":"Mass fluid loading"},{"label":"D","text":"100% O2 always"},{"label":"E","text":"Highest possible MAC"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** One-lung ventilation (OLV) for thoracic surgery: (1) Lung isolation device: - Double-lumen tube (DLT) — left-sided most common (right rare due to RUL bronchus issues); size 35-41 F based on height; fiberoptic confirmation MANDATORY; - Bronchial blocker (Arndt, Cohen, Univent) — alternative if difficult intubation or already intubated; less precise but useful; (2) DLT placement — direct laryngoscopy + advance until resistance + rotate; fiberoptic confirms position; reposition after side change; (3) OLV physiology — V/Q mismatch + shunting → hypoxia risk; hypoxic pulmonary vasoconstriction (HPV) helps redirect blood to ventilated lung; volatile anesthetics inhibit HPV — minimize MAC; (4) Ventilator strategy: - Lung-protective TV 4-6 mL/kg IBW (lower than two-lung); - PEEP 5-10 (ventilated lung); CPAP 5-10 (non-ventilated lung) if hypoxia; - Permissive hypercapnia OK; - Avoid high FiO2 except as needed; - PCV often preferred; (5) Hypoxia OLV: - Confirm DLT position; - 100% O2; - Recruit ventilated lung; - CPAP non-ventilated lung; - Intermittent two-lung ventilation; - PEEP ventilated lung; - Inhaled vasodilator selective; (6) Bronchospasm common — bronchodilator; (7) Fluids — restrictive (post-op pneumonectomy lung edema); (8) Analgesia — thoracic epidural or PVB highly recommended; ESP block alternative; multimodal; (9) Post-op — extubate ASAP, ICU/step-down; pain control critical; (10) Pneumonectomy considerations — strict fluid restriction (post-pneumonectomy pulmonary edema)

---

OLV: DLT (L > R) or bronchial blocker, fiberoptic confirm. Lung-protective TV 4-6 mL/kg + PEEP. Hypoxia algorithm: position, CPAP, PEEP. Volatile inhibits HPV. Thoracic epidural/PVB analgesia. Restrictive fluids.', NULL,
  'medium', 'respiratory', 'review',
  'anesthesiology', 'clinical_decision', 'respiratory', 'adult',
  'SCA Thoracic Anesthesia; ERAS Thoracic Surgery', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 60 ปี — right-sided lung resection (lobectomy) for cancer
FEV1 65%, DLCO 70%, no other CV disease
Plan one-lung ventilation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 75 ปี post-CABG day 1 — sudden hypotension BP 75/45, HR 110, CVP rises 8 → 18, decreased chest tube output (was 100 mL/hr, now 10 mL/hr) but increased mediastinal silhouette on CXR
Urine output decreasing', '[{"label":"A","text":"Vasopressor infusion only"},{"label":"B","text":"Cardiac tamponade post-cardiac surgery"},{"label":"C","text":"Aggressive diuresis"},{"label":"D","text":"Wait observe"},{"label":"E","text":"Sedation deeper"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cardiac tamponade post-cardiac surgery: (1) Recognition — Beck''s triad (hypotension + elevated venous pressure + muffled heart sounds) less reliable post-op; signs: hypotension, tachycardia, rising CVP, decreased CT output (clot obstruction), pulsus paradoxus, equalization of diastolic pressures; (2) Confirm — TTE or TEE (gold standard) — pericardial effusion + RV/RA diastolic collapse + IVC plethora + respiratory variation Doppler; CT if stable; (3) MEDICAL emergency — temporize: - Volume — 250-500 mL bolus to improve filling; - Inotrope — dobutamine, epinephrine; - Avoid bradycardia + decreased contractility; - Avoid positive pressure ventilation if possible (worsens venous return); spontaneous ventilation preferred; (4) DEFINITIVE: pericardial drainage — pericardiocentesis (bedside if unstable) or surgical re-exploration (post-cardiac surgery preferred — clots often + locations atypical); (5) Operative pericardial window OR sternotomy re-exploration in OR; (6) Anesthesia for re-exploration: - Pre-op arterial line awake; - Ketamine induction (CV stable); - Maintain pre-op meds; - Avoid significant vasodilation/myocardial depression; - Prep + drape BEFORE induction (in case arrest during induction — open immediately); - Have surgeon ready; (7) DDx — coagulopathy, prosthetic valve issue, graft failure, MI, pulmonary embolism; (8) Multidisciplinary — anesthesia + CT surgery + ICU; (9) Modern: bedside echo essential skill ICU

---

Post-cardiac surgery tamponade: rising CVP + low CT output + hypotension. Echo (TEE/TTE) confirm. Volume + inotrope temporize. Re-exploration definitive. Ketamine induction. Prep before induction.', NULL,
  'hard', 'cardiovascular', 'review',
  'anesthesiology', 'clinical_decision', 'cardiovascular', 'adult',
  'SCA Cardiac Surgery Practice; STS Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 75 ปี post-CABG day 1 — sudden hypotension BP 75/45, HR 110, CVP rises 8 → 18, decreased chest tube output (was 100 mL/hr, now 10 mL/hr) but increased mediastinal silhouette on CXR
Urine output decreasing'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 55 ปี mitral regurgitation severe + AFib — elective non-cardiac surgery (cholecystectomy)
LVEF 50%, on warfarin INR 2.5, beta-blocker, ACE-I', '[{"label":"A","text":"Tachycardia desirable"},{"label":"B","text":"Mitral regurgitation hemodynamic goals"},{"label":"C","text":"Bradycardia preferred"},{"label":"D","text":"Phenylephrine first-line"},{"label":"E","text":"High SVR target"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mitral regurgitation hemodynamic goals: (1) Fast, full, forward (mnemonic): - Fast HR (avoid bradycardia — regurgitation time increases); target HR 80-90; - Full preload (maintain venous return); - Forward flow (low SVR — reduce afterload, reduce regurgitation); - Avoid increased PVR (worsens RV); (2) Anesthetic technique: - Neuraxial OK (reduces SVR — beneficial); careful titration; - GA acceptable; - Volatile reduces SVR (beneficial); - Avoid ketamine (increases SVR + HR + PVR — but HR helpful); (3) Drugs: - Vasopressor — norepinephrine (mild beta — maintain HR); avoid pure alpha (phenylephrine) — increases afterload + may worsen MR; - Inotrope — milrinone (vasodilator + inotrope), dobutamine; - Avoid bradycardia — atropine, ephedrine if needed; (4) Anticoagulation — warfarin for AFib — bridge with LMWH if high stroke risk + holding warfarin; or continue if procedure low bleed risk; (5) Continue beta-blocker (rate control AFib) + ACE-I usually (hold morning of surgery debated); (6) Volume — adequate preload; avoid fluid overload (pulm edema); (7) Monitor — arterial line; consider TEE intraop if major surgery + significant MR; (8) Post-op — rate control AFib, restart warfarin/DOAC, monitor HF; (9) Severe MR + symptoms → MV repair/replacement; if elective non-cardiac surgery — consider MV procedure first; (10) Multidisciplinary

---

MR hemodynamic goals: Fast, Full, Forward. Low SVR (afterload reduction). Avoid bradycardia + phenylephrine. Norepinephrine for vasopressor. Neuraxial OK. TEE intraop. Continue beta-blocker.', NULL,
  'medium', 'cardiovascular', 'review',
  'anesthesiology', 'clinical_decision', 'cardiovascular', 'adult',
  'AHA/ACC Valvular HD 2020; SCA Cardiac Anesthesia', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 55 ปี mitral regurgitation severe + AFib — elective non-cardiac surgery (cholecystectomy)
LVEF 50%, on warfarin INR 2.5, beta-blocker, ACE-I'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 50 ปี — elective craniotomy for brain tumor (R frontal lobe)
GCS 15, no focal deficit, no seizure
MRI: 4 cm mass + minimal edema, no midline shift
Meds: dexamethasone 4mg q6h, levetiracetam 1g BID', '[{"label":"A","text":"Use ketamine + N2O routinely"},{"label":"B","text":"Neuroanesthesia craniotomy principles"},{"label":"C","text":"Hypotensive technique aggressive"},{"label":"D","text":"PEEP 15 mandatory"},{"label":"E","text":"Mass hypotonic fluids"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neuroanesthesia craniotomy principles: (1) Goals — maintain CPP, control ICP, brain relaxation, smooth emergence for neuro exam; (2) CPP = MAP - ICP; target CPP 60-70; (3) ICP control intraop: - Head up 15-30°; - Avoid PEEP > 10 if possible; - Mannitol 0.5-1 g/kg or hypertonic saline 3% (250 mL) — osmotic diuresis; - Hyperventilation to PaCO2 30-35 (temporary, avoid < 30 prolonged — ischemia); - Avoid hypotonic fluids (use NS or balanced isotonic); - CSF drainage via lumbar drain (selected); (4) Anesthetic choice: - Propofol-based TIVA preferred (reduces CMRO2, ICP, may improve brain relaxation); - Volatile (sevoflurane < 1 MAC OK; high MAC vasodilator); - Avoid N2O (expands air, may worsen pneumocephalus); - Opioid (remifentanil infusion or fentanyl) for analgesia + blunt response; - Muscle relaxant — rocuronium or cisatracurium; avoid succinylcholine (transient ICP rise + K release); (5) Hemodynamic — arterial line; CVL if needed; tight BP control; avoid surges with laryngoscopy/pinning (lidocaine, opioid, deepen); (6) Avoid ketamine (controversial — some say OK with controlled ventilation but classic teaching: avoid); (7) Emergence — smooth, awake neuro exam priority; remifentanil + dexmedetomidine helpful; (8) Post-op — neuro ICU; serial neuro exams; HOB up; control BP, glucose, temperature (normothermia); seizure prophylaxis; (9) Awake craniotomy — for eloquent cortex; dexmedetomidine + remifentanil + scalp block; (10) Monitoring — neurophysiologic (SSEP, MEP) — affects anesthetic choice

---

Neuro craniotomy: CPP > 60, propofol-TIVA, avoid N2O + succinylcholine, mannitol/HTS, modest hyperventilation, smooth emergence. Scalp block for pinning. Awake craniotomy for eloquent areas.', NULL,
  'medium', 'neurology', 'review',
  'anesthesiology', 'clinical_decision', 'neurology', 'adult',
  'SNACC Neuroanesthesia Guidelines; ASA Practice Advisory', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 50 ปี — elective craniotomy for brain tumor (R frontal lobe)
GCS 15, no focal deficit, no seizure
MRI: 4 cm mass + minimal edema, no midline shift
Meds: dexamethasone 4mg q6h, levetiracetam 1g BID'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 45 ปี SAH grade III (Hunt-Hess) — emergent craniotomy for clipping ruptured anterior communicating aneurysm
GCS 13, BP 165/95, HR 90
No neuro deficit currently', '[{"label":"A","text":"Allow BP to rise during induction"},{"label":"B","text":"Aneurysm clipping anesthesia"},{"label":"C","text":"Skip arterial line"},{"label":"D","text":"Allow hypovolemia"},{"label":"E","text":"Hyperventilate aggressively all case"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Aneurysm clipping anesthesia: (1) Pre-rupture goal — PREVENT rebleed (mortality 50% if rebleed); strict BP control SBP < 140-160; (2) Avoid HTN surges — at intubation, pinning, dural opening, emergence; (3) Premedication — small midazolam for anxiety; avoid heavy sedation (need neuro exam); (4) Induction: - Pre-induction arterial line MANDATORY; - Smooth induction: propofol + opioid (high-dose fentanyl 5-10 mcg/kg OR remifentanil 0.3-0.5 mcg/kg/min); - Lidocaine 1.5 mg/kg blunt response; - NMB rocuronium; - Esmolol/labetalol ready for HTN; - Scalp block (bupivacaine + epinephrine) for pinning + scalp incision; (5) Maintenance — TIVA propofol + remifentanil OR sevoflurane < 1 MAC + opioid; (6) Hemodynamic: - Tight BP control (avoid spikes); - SBP 140-160 before clipping; - Reduce BP for temporary clipping if needed (SBP 100-120, MAP 70-80); - After clipping: liberalize, allow higher BP for cerebral perfusion (Triple-H — Hypertension, Hypervolemia, Hemodilution — historic; now permissive HTN + euvolemia); (7) Brain relaxation: mannitol, hyperventilation modest, CSF drainage; (8) Burst suppression for temporary clipping — propofol bolus + EEG; (9) Avoid hyperglycemia (worsens ischemia); maintain normothermia (some advocate mild hypothermia — controversial); (10) Emergence — smooth, allow early neuro exam; (11) Post-op vasospasm — typically days 4-14 post-SAH; nimodipine, BP support (euvolemia + permissive HTN), endovascular treatment if symptomatic; (12) Endovascular alternative — coiling in IR

---

Aneurysm clipping: prevent rebleed (tight BP), pre-induction art line, scalp block, TIVA, burst suppression for temp clipping, mannitol + modest hyperventilation. Post-op vasospasm management. Endovascular alternative.', NULL,
  'hard', 'neurology', 'review',
  'anesthesiology', 'clinical_decision', 'neurology', 'adult',
  'SNACC Practice Advisory; Neurocritical Care Society Vasospasm', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 45 ปี SAH grade III (Hunt-Hess) — emergent craniotomy for clipping ruptured anterior communicating aneurysm
GCS 13, BP 165/95, HR 90
No neuro deficit currently'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 60 ปี diabetic — elective lumbar fusion L4-S1 posterior approach
Duration 4-6 hr prone position planned
Weight 95 kg', '[{"label":"A","text":"No special precautions for prone"},{"label":"B","text":"Prone position complications + management"},{"label":"C","text":"Eyes pressed against pad"},{"label":"D","text":"No padding required"},{"label":"E","text":"Avoid all monitoring"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Prone position complications + management: (1) Eye injury — POVL (Postoperative Visual Loss) — ischemic optic neuropathy most common in prolonged prone + blood loss; PREVENTION: - Eyes free of pressure (foam pad with holes); - Check eyes regularly q15-30 min; - Avoid hypotension (MAP > 70); - Limit blood loss; consider transfusion threshold; - Head neutral position, level with or higher than heart; - Avoid direct eye pressure; (2) Airway — ETT secure (taped firmly), EtCO2 monitor, anticipated airway swelling, leak test before extubation; (3) Neck — neutral position; (4) Pressure injuries — pad bony prominences (chest, iliac crests, knees, ankles); breasts/genitalia free; (5) Hemodynamic — venous return decreased; abdomen free (avoid IVC compression) — venous bleeding worse if pressure; (6) Pulmonary — chest free (improves compliance), but anterior chest wall compression possible; PCV often preferred; (7) Neuropathy — brachial plexus (arms < 90° abduction, supinated), ulnar nerves (padded elbows), lateral femoral cutaneous, peroneal; (8) Endotracheal tube obstruction (kink, secretion) — capnogram monitor; (9) Anesthesia — multi-modal opioid-sparing important (spine + fusion = high postop pain); TIVA reduces blood loss + facilitates motor/SSEP monitoring; (10) MEP/SSEP — TIVA preferred, avoid muscle relaxant after intubation; (11) Massive blood loss — type + cross, TXA 1g, cell saver; (12) Post-op — neuro exam, pain control, PT, DVT prophylaxis

---

Prone position: POVL prevention (no eye pressure, MAP > 70, limit blood loss), pad bony prominences, free abdomen + chest, neutral neck, brachial plexus protection, capnogram for ETT obstruction. TIVA for MEP.', NULL,
  'medium', 'neurology', 'review',
  'anesthesiology', 'clinical_decision', 'neurology', 'adult',
  'ASA POVL Practice Advisory 2019; SNACC Spine Anesthesia', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 60 ปี diabetic — elective lumbar fusion L4-S1 posterior approach
Duration 4-6 hr prone position planned
Weight 95 kg'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 35 ปี traumatic brain injury, GCS 7, pupils 3 mm reactive, requires intubation + emergent OR for ICH evacuation
BP 160/90, HR 60 (Cushing-like)', '[{"label":"A","text":"Aggressive hyperventilation to PaCO2 25"},{"label":"B","text":"Severe TBI anesthesia"},{"label":"C","text":"Aggressive fluid restriction"},{"label":"D","text":"Hypotonic fluid"},{"label":"E","text":"Hypertonic saline contraindicated"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe TBI anesthesia: (1) ABC + C-spine precautions (always assume unstable C-spine in TBI); (2) Airway — RSI with MILS + video laryngoscopy; - Induction: etomidate (CV stable) or propofol; lidocaine pre-treatment; opioid (fentanyl); rocuronium (succinylcholine ICP rise — but minor + transient, often acceptable in TBI RSI); - Pre-O2 thorough; - Avoid hypotension (single SBP < 90 doubles mortality TBI); avoid hypoxia; (3) Intracranial pressure management: - Head up 30°, neck neutral (allows venous drainage); - PaCO2 35-40 normal; mild hyperventilation 30-35 ONLY for impending herniation (transient measure); - Hyperosmolar therapy: hypertonic saline 3% 250 mL or mannitol 0.5-1 g/kg; - Sedation + analgesia adequate; (4) BP/CPP — MAP > 80, CPP > 60 (BTF guideline); norepinephrine first-line vasopressor; (5) Fluid — isotonic crystalloid (NS, balanced); avoid hypotonic; avoid albumin (SAFE TBI subgroup worse); (6) Hyperglycemia — avoid (worsens secondary injury); target 140-180; (7) Temperature — normothermia (hyperthermia harmful); (8) Sodium — target Na 145-155 (mild hypernatremia OK); avoid hyponatremia; (9) Seizure prophylaxis — levetiracetam or phenytoin × 7 days (early seizure); (10) ICP monitor placement (Camino, EVD) — neurosurgery; ICP target < 20-22; (11) Avoid PEEP > 10 generally; (12) Cushing response (HTN + bradycardia) — ominous, indicates impending herniation; (13) Multidisciplinary: anesthesia + neurosurgery + ICU

---

TBI: avoid hypotension + hypoxia, RSI MILS, etomidate, mild HV only for herniation, hypertonic saline > mannitol, MAP > 80 CPP > 60. Normothermia. ICP monitor < 20-22. Cushing = herniation imminent.', NULL,
  'hard', 'trauma', 'review',
  'anesthesiology', 'clinical_decision', 'trauma', 'adult',
  'BTF Severe TBI Guidelines 4th Edition; SNACC TBI', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 35 ปี traumatic brain injury, GCS 7, pupils 3 mm reactive, requires intubation + emergent OR for ICH evacuation
BP 160/90, HR 60 (Cushing-like)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย post-spine surgery 50 ปี ICU monitoring SSEP + MEP signals
Surgeon requests anesthetic technique that preserves neuromonitoring', '[{"label":"A","text":"Volatile + N2O + paralytic"},{"label":"B","text":"Neuromonitoring + anesthetic technique"},{"label":"C","text":"Deep hypothermia"},{"label":"D","text":"Continuous NMB infusion"},{"label":"E","text":"Heavy sedation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neuromonitoring + anesthetic technique: (1) SSEP (Somatosensory Evoked Potential) — cortical signal from peripheral nerve stimulation; sensitive to: volatile (dose-dependent suppression), hypothermia, hypotension, hypoxia, anemia; (2) MEP (Motor Evoked Potential) — direct cortical stimulation, recorded in muscles; MORE sensitive than SSEP to anesthetic + muscle relaxant; (3) Preferred anesthetic for SSEP + MEP: - TIVA propofol + opioid (remifentanil/sufentanil) — minimal interference; - Ketamine acceptable (some advocate); - Dexmedetomidine well-tolerated; - Low-dose volatile (< 0.5 MAC) tolerable for SSEP, suppresses MEP; (4) AVOID: - High-dose volatile (suppresses both); - N2O (suppresses both, expands air); - Muscle relaxant after intubation (eliminates MEP); use intermediate-acting rocuronium for intubation, then no further dose; (5) Maintain physiology: - MAP > 70; - SpO2 > 95%; - Normothermia 36-37°C; - Normocarbia PaCO2 35-40; - Adequate Hb (> 9-10 typically); (6) Communication with neuromonitoring tech essential — alerts to signal changes; (7) Signal change response — STOP surgery, check anesthetic + physiology, reposition if needed; (8) Stagnara wake-up test alternative (rare now); (9) Documentation; (10) Modern: routine for scoliosis, spinal cord tumor, complex spine surgery

---

Neuromonitoring anesthesia: TIVA propofol + remifentanil, low/no volatile, NO N2O, single-dose NMB only. Maintain MAP, normothermia, Hb. MEP more sensitive than SSEP. Communicate with tech.', NULL,
  'medium', 'neurology', 'review',
  'anesthesiology', 'clinical_decision', 'neurology', 'adult',
  'ASNM Intraoperative Neuromonitoring; SNACC Practice', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วย post-spine surgery 50 ปี ICU monitoring SSEP + MEP signals
Surgeon requests anesthetic technique that preserves neuromonitoring'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 28 ปี GSW abdomen + chest, profound shock
BP 70/40, HR 140, GCS 14, intubated in ED
FAST positive, hemoperitoneum
Blood products activated, MTP started', '[{"label":"A","text":"Aggressive crystalloid only"},{"label":"B","text":"Hemorrhagic shock + damage control resuscitation"},{"label":"C","text":"Crystalloid 5L bolus"},{"label":"D","text":"Aggressive vasopressor without blood"},{"label":"E","text":"Refuse transfusion"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hemorrhagic shock + damage control resuscitation: (1) Massive Transfusion Protocol — pre-defined ratios, immediate release; (2) Balanced transfusion 1:1:1 (PRC:FFP:Platelets) per PROPPR trial; whole blood emerging (military origin); (3) TXA 1g IV bolus < 3h, then 1g over 8h (CRASH-2 mortality reduction); (4) Permissive hypotension — SBP 80-90 until hemorrhage controlled (avoid for TBI); reduces clot disruption + further bleeding; (5) Minimize crystalloid — worsens coagulopathy + edema + abdominal compartment syndrome; (6) Calcium replacement — citrate from transfusion chelates Ca; check iCa, replace 1g CaCl2 every 4 units PRBC; (7) Warming — warmed fluids + blankets; hypothermia worsens coagulopathy + cardiac function; (8) Fibrinogen target > 1.5-2 g/L; cryoprecipitate (10 units) or fibrinogen concentrate if low; (9) Viscoelastic testing (TEG/ROTEM) — guides component therapy (FFP, platelets, cryo, TXA); (10) Anesthetic — ketamine 1-2 mg/kg + opioid; etomidate alternative; avoid propofol bolus (hypotension); maintain low-dose volatile/TIVA; (11) Vasopressor — norepinephrine if persistent hypotension despite volume; vasopressin adjunct; (12) Calcium gluconate or chloride; (13) Lung-protective ventilation; (14) Post-op — ICU, monitor for ACS (abdominal compartment), AKI, MOF, coagulopathy; (15) Damage control surgery — quick hemorrhage + contamination control, leave open, return 24-48h

---

Trauma hemorrhagic shock: MTP 1:1:1, TXA, permissive hypotension (except TBI), minimize crystalloid, Ca replacement, warm, TEG/ROTEM-guided. Ketamine + low-dose volatile. Damage control surgery.', NULL,
  'medium', 'trauma', 'review',
  'anesthesiology', 'clinical_decision', 'trauma', 'adult',
  'ATLS 10th Edition; ACS TQIP Massive Transfusion', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 28 ปี GSW abdomen + chest, profound shock
BP 70/40, HR 140, GCS 14, intubated in ED
FAST positive, hemoperitoneum
Blood products activated, MTP started'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ICU patient 65 ปี septic shock, intubated, on norepinephrine 0.4 mcg/kg/min + vasopressin 0.04 U/min
Lactate 5.2, MAP 58, urine output 15 mL/hr × 4h
Fluids 3L crystalloid already given', '[{"label":"A","text":"More fluid 5L"},{"label":"B","text":"Septic shock"},{"label":"C","text":"Stop all vasopressor"},{"label":"D","text":"Hypotonic fluid"},{"label":"E","text":"Avoid steroid always"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Septic shock — Surviving Sepsis Campaign 2021: (1) Initial — 30 mL/kg crystalloid within 3h (now individualized); reassess hemodynamic response; (2) Antibiotics within 1h (broad-spectrum); source control; (3) Vasopressor — norepinephrine first-line (alpha + mild beta); target MAP > 65 (some advocate higher 80-85 in chronic HTN); (4) Refractory shock — add vasopressin 0.03-0.04 U/min (V1 receptor — non-catecholamine sparing); epinephrine third-line; (5) Stress-dose steroid — hydrocortisone 200 mg/day continuous infusion or 50 mg q6h IV if refractory shock on norepinephrine + vasopressin; ADRENAL trial showed faster shock resolution; (6) Fluid responsiveness assessment — passive leg raise, pulse pressure variation > 13%, IVC variation, cardiac output monitor; avoid fluid overload (mortality); (7) Goal-directed: lactate clearance, ScvO2, MAP, urine output; (8) Glycemic control — target < 180; insulin infusion; (9) DVT + stress ulcer prophylaxis; (10) Lung-protective ventilation TV 6 mL/kg, plateau < 30, PEEP per FiO2; prone if severe ARDS PaO2/FiO2 < 150; (11) Sedation — light, dexmedetomidine, daily SAT; (12) Renal — CRRT if AKI + refractory; (13) Nutrition — early enteral if possible; (14) Family communication + goals of care; (15) Multidisciplinary; (16) Avoid prolonged unnecessary fluids; modern trend conservative fluid + early vasopressor

---

Septic shock SSC 2021: initial 30 mL/kg, norepi first-line, vasopressin + steroid for refractory, MAP > 65, lactate clearance, fluid-responsive assessment, lung-protective, CRRT. Conservative fluids modern trend.', NULL,
  'medium', 'procedures', 'review',
  'anesthesiology', 'clinical_decision', 'procedures', 'adult',
  'Surviving Sepsis Campaign 2021', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ICU patient 65 ปี septic shock, intubated, on norepinephrine 0.4 mcg/kg/min + vasopressin 0.04 U/min
Lactate 5.2, MAP 58, urine output 15 mL/hr × 4h
Fluids 3L crystalloid already given'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ICU ARDS patient 50 ปี post-pneumonia
PaO2/FiO2 95 on FiO2 0.7 + PEEP 12
Plateau pressure 32, TV 6 mL/kg IBW
Mechanically ventilated 3 วัน, hemodynamically stable', '[{"label":"A","text":"Increase TV to 10 mL/kg"},{"label":"B","text":"Severe ARDS management"},{"label":"C","text":"Permissive supine without prone"},{"label":"D","text":"High TV 12 mL/kg"},{"label":"E","text":"No PEEP"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe ARDS management — ARDSnet + recent evidence: (1) Lung-protective ventilation: - TV 4-6 mL/kg IBW (predicted body weight); - Plateau pressure < 30 cmH2O; - Driving pressure < 15 cmH2O (delta P = Pplat - PEEP); - PEEP titration per FiO2 (ARDSnet table) or optimal PEEP (best compliance, lowest driving P); (2) PaO2/FiO2 < 150 = severe ARDS — prone positioning 16h/day (PROSEVA trial — mortality benefit); (3) Conservative fluid strategy after initial resuscitation (FACTT); (4) Neuromuscular blockade in early severe ARDS (ACURASYS — controversial; ROSE found no benefit if not deeply sedated); (5) Recruitment maneuvers — controversial (ART trial harm); selective use; (6) ECMO — refractory hypoxia despite optimization (EOLIA trial); P/F < 50 for 3h or < 80 for 6h; CESAR for transfer to center; (7) Inhaled vasodilator (NO, prostacyclin) — selective pulmonary vasodilation, improves oxygenation, no mortality benefit; (8) Permissive hypercapnia (pH > 7.20) OK; (9) Sedation — minimize, daily SAT; (10) Steroids — DEXA-ARDS trial showed benefit dexamethasone 20 mg × 5d then 10 mg × 5d for moderate-severe ARDS; (11) Treat underlying cause; (12) Nutrition + DVT prophylaxis + ABCDEF bundle; (13) APRV (Airway Pressure Release Ventilation) — alternative mode; (14) Family communication + goals of care; (15) Modern: prone positioning + ECMO save lives

---

Severe ARDS: TV 4-6 mL/kg IBW, Pplat < 30, driving P < 15, PEEP titration. Prone for P/F < 150. Conservative fluids. ECMO refractory. Dexamethasone benefit. Inhaled NO bridge. Modern: prone + ECMO.', NULL,
  'medium', 'respiratory', 'review',
  'anesthesiology', 'clinical_decision', 'respiratory', 'adult',
  'ARDSnet; PROSEVA; ESICM ARDS Guidelines 2023', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ICU ARDS patient 50 ปี post-pneumonia
PaO2/FiO2 95 on FiO2 0.7 + PEEP 12
Plateau pressure 32, TV 6 mL/kg IBW
Mechanically ventilated 3 วัน, hemodynamically stable'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ICU patient 70 ปี post-cardiac arrest ROSC × 1h, intubated, comatose
GCS 4, no withdrawal
Core temp 36.4°C, BP 110/70 on no vasopressor
Lactate 4, no overt seizure', '[{"label":"A","text":"Wait observation only"},{"label":"B","text":"Post-cardiac arrest care (PCAC)"},{"label":"C","text":"Allow fever to 39°C"},{"label":"D","text":"Withdraw care immediately"},{"label":"E","text":"Aggressive hyperoxia"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-cardiac arrest care (PCAC): (1) Targeted Temperature Management (TTM) — TTM2 trial showed 33°C vs 36°C equivalent; current consensus: avoid fever (target 32-36°C × 24h, then rewarm slowly 0.25°C/hr); (2) Cardiopulmonary support — MAP > 65-80 (some advocate higher), avoid hypotension, lactate normalization; (3) Ventilation — PaO2 90-100 (avoid hyperoxia + hypoxia), PaCO2 35-45 (normocapnia), lung-protective; (4) Glucose 140-180; (5) Seizure detection — continuous EEG (subclinical seizure common); treat with levetiracetam, valproate, benzo for convulsive; (6) Sedation — propofol + opioid + NMB during TTM to prevent shivering; magnesium 2g; counterwarming; (7) Coronary angiography — if STEMI on ECG; consider if non-STEMI + presumed cardiac cause (selective per recent trials); (8) Neuroprognostication — DELAY > 72h after rewarming for accurate assessment; multimodal: clinical exam (GCS M, pupillary, corneal), bilateral absent N20 SSEP, NSE, EEG, MRI; do NOT base prognosis on single modality early; (9) Withdrawal of life-sustaining therapy — based on neuroprognostication, patient wishes, family discussion; (10) Modern: ECPR (ECMO-assisted CPR) for refractory; (11) Cause identification — CAD, PE, sepsis, hypoxia, etc; (12) Family communication ongoing

---

Post-arrest care: TTM (avoid fever 32-36°C), MAP > 65, normoxia + normocapnia, EEG monitoring, neuroprognostication > 72h post-rewarm multimodal, treat reversible cause. ECPR emerging.', NULL,
  'medium', 'cardiovascular', 'review',
  'anesthesiology', 'clinical_decision', 'cardiovascular', 'adult',
  'ILCOR 2020; AHA Post-Cardiac Arrest Care; TTM2 Trial', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ICU patient 70 ปี post-cardiac arrest ROSC × 1h, intubated, comatose
GCS 4, no withdrawal
Core temp 36.4°C, BP 110/70 on no vasopressor
Lactate 4, no overt seizure'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 45 ปี polytrauma open femur + pelvic fracture, splenic laceration, lung contusion
Post-laparotomy + splenectomy + ex fix → ICU
BP 110/70 on norepi 0.1, lactate 3, Hb 8.5, INR 1.4
ABG: pH 7.30, PaO2 75, PaCO2 45, T 35.0°C', '[{"label":"A","text":"Cool further to 32°C"},{"label":"B","text":"Post-damage control resuscitation in ICU"},{"label":"C","text":"Avoid all warming"},{"label":"D","text":"Maximize crystalloid"},{"label":"E","text":"Skip antibiotics open fracture"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-damage control resuscitation in ICU: (1) Continue resuscitation goals — normalize lactate, hemoglobin, coagulation, temperature; (2) Lethal triad reversal: - Hypothermia: warming (Bair Hugger, warm fluids, IV warmer, room temp 24-26°C); target 36-37°C; - Coagulopathy: TEG/ROTEM-guided product therapy; FFP, platelets, fibrinogen, cryoprecipitate; - Acidosis: improve perfusion + ventilation; bicarb selectively; (3) Volume + perfusion — balanced approach; vasopressor as needed; lactate clearance goal; (4) Reduce vasopressor as appropriate; (5) Ventilation — lung-protective; chest tube monitor; expect ARDS risk with lung contusion + transfusion; (6) Imaging — secondary survey CT scans (head, chest, abd, pelvis); (7) Antibiotic — open fracture prophylaxis (cefazolin + gentamicin Gustilo III); tetanus; (8) Pain — multimodal (regional anesthesia useful — fascia iliaca, lumbar plexus, paravertebral, ESP); minimize opioid; (9) Return to OR for definitive surgery (24-72h) — orthopedic, abdominal closure; (10) DVT prophylaxis — early (mechanical immediate; pharmacologic 48-72h depending on bleeding); (11) Stress ulcer prophylaxis; (12) Early enteral nutrition; (13) Monitor for ACS (abdominal compartment), AKI, MOF, infection, splenectomy considerations (vaccinate); (14) Multidisciplinary team — trauma, anesthesia, ortho, ICU, PT, nutrition; (15) Family communication

---

Post-DCS ICU: reverse lethal triad (warm, correct coag, treat acidosis), TEG/ROTEM-guided, lactate clearance, multimodal regional analgesia, early DVT prophylaxis, definitive surgery 24-72h, multidisciplinary.', NULL,
  'medium', 'trauma', 'review',
  'anesthesiology', 'clinical_decision', 'trauma', 'adult',
  'EAST Trauma Practice Management; ATLS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 45 ปี polytrauma open femur + pelvic fracture, splenic laceration, lung contusion
Post-laparotomy + splenectomy + ex fix → ICU
BP 110/70 on norepi 0.1, lactate 3, Hb 8.5, INR 1.4
ABG: pH 7.30, PaO2 75, PaCO2 45, T 35.0°C'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 45 ปี chronic back pain × 5 ปี — admitted for elective spinal fusion
Meds: oxycodone ER 40 mg BID + IR 10 mg q4h PRN, pregabalin 150 mg BID, duloxetine 60 mg daily
Daily MME estimated 180', '[{"label":"A","text":"Stop all opioids preop"},{"label":"B","text":"Chronic opioid use perioperative"},{"label":"C","text":"Discharge with double opioid dose"},{"label":"D","text":"Combine opioid + benzo"},{"label":"E","text":"Refuse perioperative care"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Chronic opioid use perioperative: (1) Continue chronic opioid regimen — abrupt stop causes withdrawal + worsens pain; (2) Calculate baseline MME (morphine milligram equivalents) — informs intra/post-op needs; tolerance = increased opioid requirements (3-5×); (3) Multimodal opioid-sparing maximally: - Acetaminophen scheduled; - NSAID (ketorolac, celecoxib) unless CI; - Ketamine infusion 0.1-0.3 mg/kg/hr (anti-hyperalgesic + opioid-sparing); - Continue gabapentinoid (pregabalin); - Continue duloxetine; - Dexamethasone single dose; - Lidocaine infusion (1-2 mg/kg/hr); - Magnesium sulfate; (4) Regional anesthesia maximally — neuraxial (epidural for spine — controversial near surgical site; ESP block alternative), peripheral nerve blocks; (5) Intra-op opioid — higher doses than naive; (6) Post-op pain — PCA hydromorphone (or fentanyl) with higher doses; basal rate avoided typically but considered; (7) Coordinate with pain medicine + addiction medicine; (8) Discharge — transition off short-acting back to chronic regimen + multimodal; avoid escalation; close follow-up; (9) Tolerance considerations: - May need higher intra-op opioid (sufentanil/fentanyl); - Hyperalgesia phenomenon — opioid-induced; ketamine helps; (10) Psychological support — anxiety, catastrophizing, depression contribute to perception; (11) Goals of care discussion + realistic expectations; (12) Avoid combining opioids + benzodiazepines (CDC warning — respiratory depression mortality)

---

Chronic opioid: continue, multimodal opioid-sparing (ketamine, lidocaine, regional, gabapentinoid), higher intra-op doses, transition back postop. Pain + addiction medicine consult. Avoid opioid + benzo combo.', NULL,
  'medium', 'msk_nontrauma', 'review',
  'anesthesiology', 'clinical_decision', 'msk_nontrauma', 'adult',
  'ASA Chronic Pain Perioperative; CDC Opioid Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 45 ปี chronic back pain × 5 ปี — admitted for elective spinal fusion
Meds: oxycodone ER 40 mg BID + IR 10 mg q4h PRN, pregabalin 150 mg BID, duloxetine 60 mg daily
Daily MME estimated 180'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 55 ปี post-mastectomy 3 เดือน — persistent burning + shooting pain ipsilateral chest wall + axilla
Non-radiating, allodynia + hyperalgesia present
No recurrence on imaging', '[{"label":"A","text":"Surgery again"},{"label":"B","text":"Chronic Post-Mastectomy Pain Syndrome (post-surgical neuropathic pain)"},{"label":"C","text":"Long-term high-dose opioid"},{"label":"D","text":"Single nerve block only"},{"label":"E","text":"Ignore symptoms"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Chronic Post-Mastectomy Pain Syndrome (post-surgical neuropathic pain): (1) Pathophys — intercostobrachial nerve injury most common (axillary dissection); central sensitization; (2) Risk factors — axillary lymph node dissection, chemo/radiation, younger age, higher acute postop pain, anxiety/depression; (3) Diagnosis — clinical; neuropathic features (burning, shooting, allodynia, hyperalgesia); chronic > 3 months postop; rule out recurrence imaging; (4) Multimodal treatment: - Pharmacologic: gabapentinoid (gabapentin titrate to 1800-3600 mg/day; pregabalin 75-300 mg BID), TCA (amitriptyline, nortriptyline 10-75 mg HS), SNRI (duloxetine, venlafaxine), topical lidocaine 5% patch, capsaicin 8% patch; - Avoid chronic opioid (limited efficacy + addiction risk); - Acetaminophen + NSAID adjunct; (5) Interventional: - Intercostal nerve block; - Pulsed radiofrequency intercostal nerve; - Paravertebral block; - Stellate ganglion block; - Erector spinae plane block (ESP) — both diagnostic + therapeutic; (6) Non-pharmacologic — PT, TENS, mindfulness, CBT, acupuncture; (7) Psychological support — depression, anxiety, PTSD common in cancer survivors; (8) Prevention (best) — regional anesthesia at surgery (PVB, ESP), multimodal analgesia perioperatively, minimize acute postop pain; (9) Multidisciplinary pain clinic; (10) Refractory — spinal cord stimulation, intrathecal pump

---

Chronic post-mastectomy pain: neuropathic, intercostobrachial nerve injury. Multimodal: gabapentinoid, TCA, SNRI, topical, interventional (intercostal, PVB, ESP). Avoid chronic opioid. Prevention via regional at surgery.', NULL,
  'medium', 'neurology', 'review',
  'anesthesiology', 'clinical_decision', 'neurology', 'adult',
  'IASP Neuropathic Pain Guidelines; ASRA Chronic Pain', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 55 ปี post-mastectomy 3 เดือน — persistent burning + shooting pain ipsilateral chest wall + axilla
Non-radiating, allodynia + hyperalgesia present
No recurrence on imaging'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 35 ปี complex regional pain syndrome (CRPS) Type I — left lower extremity 6 เดือน after ankle sprain
Pain: severe burning, allodynia, autonomic changes (color, temp, sweating), edema, motor dysfunction', '[{"label":"A","text":"Wait + observe"},{"label":"B","text":"CRPS Type I management"},{"label":"C","text":"Amputation"},{"label":"D","text":"High-dose opioid only"},{"label":"E","text":"Refuse evaluation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** CRPS Type I management: (1) Diagnosis — Budapest criteria (continuing pain disproportionate to event + symptoms in 3 of 4 categories: sensory, vasomotor, sudomotor/edema, motor/trophic + signs in 2 of 4 + no alternative diagnosis); (2) Multidisciplinary EARLY intervention key: - Physical/occupational therapy = CORNERSTONE (graded motor imagery, mirror therapy, desensitization, ROM, strengthening); - Active rather than passive treatments; (3) Pharmacologic: - Gabapentin/pregabalin (first-line neuropathic); - TCA (amitriptyline, nortriptyline); - Bisphosphonate (pamidronate) — modest evidence; - Vitamin C (prevention not treatment); - Calcitonin (limited evidence); - Topical lidocaine, capsaicin; - Avoid chronic opioid (poor efficacy); (4) Interventional: - Sympathetic ganglion block (stellate ganglion UE, lumbar sympathetic LE) — diagnostic + therapeutic; - Continuous nerve catheter; - Spinal cord stimulation (DRG stimulation for focal CRPS — strong evidence); - Intrathecal therapy (refractory); (5) Psychological — CBT, biofeedback, mindfulness (chronic pain coping); high comorbidity depression/anxiety; (6) Ketamine infusion (sub-anesthetic) — controversial but emerging evidence; (7) IVIG, plasmapheresis — research; (8) Prevention — vitamin C 500 mg/day × 50 days after distal radius fracture (some evidence); regional anesthesia; (9) Early treatment (< 1 year) = better outcomes; (10) Patient education + expectation setting; (11) Functional restoration focus rather than pain elimination

---

CRPS: Budapest criteria. PT/OT cornerstone (graded motor imagery, mirror, desensitization). Multimodal pharmacologic + sympathetic blocks + SCS/DRG. CBT. Avoid chronic opioid. Early intervention key.', NULL,
  'medium', 'neurology', 'review',
  'anesthesiology', 'clinical_decision', 'neurology', 'adult',
  'IASP CRPS Guidelines; Budapest Criteria', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 35 ปี complex regional pain syndrome (CRPS) Type I — left lower extremity 6 เดือน after ankle sprain
Pain: severe burning, allodynia, autonomic changes (color, temp, sweating), edema, motor dysfunction'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 60 ปี — major abdominal surgery, ASA II, pre-op anxiety + history PONV + chronic neck pain on tramadol 50 mg q6h
Plan: ERAS protocol', '[{"label":"A","text":"Traditional pre-op fasting NPO midnight"},{"label":"B","text":"ERAS (Enhanced Recovery After Surgery) protocol"},{"label":"C","text":"Heavy opioid post-op"},{"label":"D","text":"Delay diet 5 days"},{"label":"E","text":"Mass IV fluid empirical"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** ERAS (Enhanced Recovery After Surgery) protocol: (1) Pre-op: - Education + expectations; - No prolonged fasting (clear fluids until 2h pre-op; light meal 6h); - Carbohydrate loading drink 2h pre-op (reduces insulin resistance); - Avoid bowel prep (most cases); - Anxiolysis without long-acting (avoid premed in elderly — delirium risk); - Skin prep (chlorhexidine); - Antibiotic prophylaxis within 60 min; (2) Intra-op: - Multimodal opioid-sparing analgesia (acetaminophen, NSAID/COX-2, gabapentinoid, ketamine, lidocaine infusion, dexamethasone); - Regional anesthesia (TAP block, ESP block, rectus sheath block, neuraxial selectively); - Goal-directed fluid therapy (avoid over and under); - Normothermia (warming); - Multimodal PONV prophylaxis (Apfel high-risk); - Short-acting anesthetics (propofol TIVA, remifentanil); - Minimize NG, drains, urinary catheters; - Lung-protective ventilation; - Avoid nitrous oxide; (3) Post-op: - Early mobilization (Day 0); - Early oral intake/diet advancement (Day 0-1); - Multimodal opioid-sparing analgesia continuation; - Glycemic control; - DVT prophylaxis; - Early Foley removal; - Discharge criteria objective; - Follow-up; (4) Outcomes — reduced LOS, complications, opioid use, cost, improved patient satisfaction; (5) Multidisciplinary: surgery + anesthesia + nursing + nutrition + PT + patient; (6) Patient buy-in critical; (7) ERAS Society protocols by procedure; (8) Audit + continuous improvement

---

ERAS: shortened fasting + carb load, multimodal opioid-sparing, regional, goal-directed fluid, normothermia, PONV prophylaxis, early mobilization + feeding. Multidisciplinary. Reduces LOS + complications.', NULL,
  'easy', 'gi', 'review',
  'anesthesiology', 'ems_mgmt', 'gi', 'adult',
  'ERAS Society Guidelines; ASA Practice Advisory', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 60 ปี — major abdominal surgery, ASA II, pre-op anxiety + history PONV + chronic neck pain on tramadol 50 mg q6h
Plan: ERAS protocol'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย 70 ปี chronic intractable cancer pain (pancreatic CA) — pain VAS 9/10 despite oral oxycodone 80 mg BID + ER
Limited life expectancy 6 เดือน
Nausea + constipation + sedation from opioids', '[{"label":"A","text":"Add more oral opioid"},{"label":"B","text":"Intractable cancer pain"},{"label":"C","text":"Refuse pain care"},{"label":"D","text":"Discharge no follow-up"},{"label":"E","text":"Surgery as primary treatment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Intractable cancer pain — interventional options: (1) Celiac plexus block/neurolysis — pancreatic + upper abd visceral pain; alcohol or phenol; significant reduction in opioid + pain in pancreatic CA (Wong RCT); ultrasound or fluoroscopy guided; (2) Splanchnic nerve neurolysis — alternative to celiac; (3) Intrathecal pump (IDDS) — for refractory cancer pain; morphine, fentanyl, hydromorphone, ziconotide, bupivacaine, clonidine combinations; significant opioid reduction; quality of life improvement; reduces systemic side effects (nausea, constipation, sedation); (4) Spinal cord stimulation — less common for cancer pain; (5) Hypogastric plexus block — pelvic cancer pain; (6) Ganglion impar block — perineal cancer pain; (7) Vertebroplasty/kyphoplasty — pathologic spine fracture; (8) Multimodal systemic: opioid (rotate if tolerance), NSAID, gabapentinoid, antidepressant, steroid, bisphosphonate (bone mets); (9) Symptom management — nausea (haloperidol, prochlorperazine, ondansetron, scopolamine), constipation (osmotic + stimulant laxatives, methylnaltrexone, naloxegol — peripherally-acting opioid antagonists), sedation; (10) Goals of care + advance directives; palliative care consult; (11) Hospice referral when appropriate; (12) Psychosocial + spiritual support; (13) Family education + support; (14) Modern: integrated palliative + pain medicine + oncology

---

Cancer pain: celiac plexus block (pancreatic CA), intrathecal pump for refractory, multimodal systemic. Symptom Mx (constipation, nausea). Palliative + hospice. Integrated multidisciplinary approach.', NULL,
  'medium', 'procedures', 'review',
  'anesthesiology', 'clinical_decision', 'procedures', 'adult',
  'ASA Cancer Pain; WHO Pain Ladder; ASRA Interventional', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วย 70 ปี chronic intractable cancer pain (pancreatic CA) — pain VAS 9/10 despite oral oxycodone 80 mg BID + ER
Limited life expectancy 6 เดือน
Nausea + constipation + sedation from opioids'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Question on pharmacology of induction agents:
Patient with elevated ICP needs RSI for emergent surgery', '[{"label":"A","text":"Use ketamine 2 mg/kg"},{"label":"B","text":"Induction agents"},{"label":"C","text":"Thiopental 10 mg/kg high dose"},{"label":"D","text":"Avoid all induction agents"},{"label":"E","text":"Use volatile only induction"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Induction agents — pharmacology: (1) Propofol — GABA-A agonist; rapid onset (30s) + offset; metabolized hepatic CYP; decreases ICP + CMRO2 + BP; bolus 1.5-2.5 mg/kg; infusion 50-150 mcg/kg/min; side effects: hypotension, pain on injection, PRIS (propofol infusion syndrome — high dose long duration: rhabdo, acidosis, cardiac failure); preferred for neurosurgery; (2) Etomidate — GABA-A agonist; rapid onset (30s); hemodynamically stable (preferred unstable); bolus 0.3 mg/kg; side effects: adrenal suppression (single dose — controversial significance; consider stress steroid in critically ill sepsis), myoclonus, PONV, no analgesia; good for cardiac + shock + TBI; (3) Ketamine — NMDA receptor antagonist; dissociative; bolus 1-2 mg/kg IV or 4 mg/kg IM; bronchodilator, analgesic, sympathomimetic (preserved BP + HR — beneficial in shock); historic concern increased ICP (now controversial — may be OK with controlled ventilation; some advocate use in TBI); emergence reactions (use benzo or propofol); excellent for trauma, shock, asthma, peds; (4) Thiopental — barbiturate; rapid onset; decreases ICP + CMRO2 + BP; rarely used now (limited availability); useful for status epilepticus; (5) Midazolam — benzodiazepine; slower onset; less BP effect than propofol; 0.1-0.3 mg/kg IV; amnesia good; for selected cases; (6) Dexmedetomidine — alpha-2 agonist; sedation without respiratory depression; awake intubation, MAC; loading 1 mcg/kg over 10 min + infusion; bradycardia + hypotension; (7) Selection — patient factors (hemodynamic, neuro, asthma, allergies, dose adjustment renal/hepatic)

---

Induction agents: propofol (rapid, ICP↓), etomidate (CV stable, adrenal suppression), ketamine (NMDA, dissociative, broncho-/sympathomimetic), thiopental (rarely used), midazolam, dexmedetomidine (alpha-2). Select per patient.', NULL,
  'easy', 'procedures', 'review',
  'anesthesiology', 'basic_science', 'procedures', 'adult',
  'Miller''s Anesthesia 9th ed', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Question on pharmacology of induction agents:
Patient with elevated ICP needs RSI for emergent surgery'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Question on neuromuscular blockers + reversal pharmacology', '[{"label":"A","text":"All NMBs equal"},{"label":"B","text":"Neuromuscular blocker (NMB) pharmacology"},{"label":"C","text":"Sux in all patients regardless"},{"label":"D","text":"No reversal needed"},{"label":"E","text":"Pancuronium first-line"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neuromuscular blocker (NMB) pharmacology: (1) Depolarizing — Succinylcholine: - Mechanism: acetylcholine receptor agonist (depolarization phase 1 → phase 2 with high dose); fast onset (30-60s), short duration (5-10 min) — metabolized by plasma cholinesterase; - Use: RSI; - Side effects: fasciculation, myalgia, K+ rise (0.5-1; AVOID in burns > 24h, denervation, hyperkalemia, severe muscular dystrophy, MH-susceptible), bradycardia (peds especially), increased ICP/IOP/intragastric pressure, masseter spasm, MH trigger; - Pseudocholinesterase deficiency — prolonged paralysis (atypical, heterozygous, homozygous); (2) Non-depolarizing — Rocuronium (preferred): - Aminosteroid, fast onset 60-90s (intubating dose 1.2 mg/kg), duration 30-60 min; minimal CV effects; sugammadex-reversible; (3) Vecuronium — aminosteroid, intermediate duration; sugammadex-reversible; (4) Cisatracurium — benzylisoquinoline; Hofmann elimination (organ-independent — preferred renal/hepatic failure); no histamine release; (5) Atracurium — Hofmann; histamine release; (6) Pancuronium — long-acting; vagolytic (tachycardia); rarely used now; (7) Reversal: - Sugammadex (cyclodextrin) — binds rocuronium/vecuronium; rapid + complete reversal; dose 2 mg/kg (TOF 2) or 4 mg/kg (deep block) or 16 mg/kg (immediate); preferred modern; - Neostigmine — AChE inhibitor; combine with anticholinergic (glycopyrrolate 0.2 mg per 1 mg neostigmine — avoid muscarinic effects bradycardia/secretions/bronchospasm); only when TOF count 2-4 (won''t reverse deep block); ceiling effect; (8) TOF monitoring — quantitative (TOFCuff, AcceleroMyograph) — TOF ratio > 0.9 = adequate reversal; modern standard

---

NMBs: sux (depol, fast/short, K+, MH trigger, contraindications), rocuronium (sugammadex-reversible), cisatracurium (Hofmann), vecuronium. Reversal: sugammadex preferred (rocuronium/vecuronium); neostigmine + glyco (TOF 2-4). Quantitative TOF standard.', NULL,
  'easy', 'procedures', 'review',
  'anesthesiology', 'basic_science', 'procedures', 'adult',
  'Miller''s Anesthesia; ASA NMB Monitoring 2023', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Question on neuromuscular blockers + reversal pharmacology'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Question on volatile anesthetics pharmacology', '[{"label":"A","text":"All volatiles identical"},{"label":"B","text":"Volatile anesthetics"},{"label":"C","text":"Highest possible MAC always"},{"label":"D","text":"Use for awake intubation"},{"label":"E","text":"Skip CO2 absorbent"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Volatile anesthetics — pharmacology: (1) MAC (Minimum Alveolar Concentration) — concentration preventing movement in 50% to surgical stimulus; - Sevoflurane 2.0% (lower in elderly; 0.6% age 80); - Isoflurane 1.15%; - Desflurane 6%; - Decreased by: age, hypothermia, opioid, alpha-2 agonist, pregnancy, hyponatremia, ethanol acute; - Increased by: hyperthermia, chronic ethanol, sympathomimetic, hypernatremia; (2) Solubility (blood/gas partition coefficient) — lower = faster onset/offset; desflurane 0.42 (fastest), sevoflurane 0.65, isoflurane 1.4; (3) Effects: - CV: dose-dependent decrease in BP (vasodilation), SVR, contractility; HR variable (desflurane increases at induction transient); QT prolongation; - Respiratory: bronchodilation (sevoflurane best — pediatric induction; desflurane = airway irritant); decreased TV, increased RR, decreased response to CO2/hypoxia; - CNS: increased CBF + ICP (vasodilator) — minimize in neurosurgery; decrease CMRO2; modulate seizure (sevoflurane epileptogenic at high concentration); - Skeletal muscle: relaxation + potentiates NMB; trigger MH (all halogenated); - Metabolism: minimal modern (sevoflurane 5%, isoflurane 0.2%, desflurane 0.02%); compound A from sevoflurane + desiccated CO2 absorbent (theoretical nephrotoxicity — limited clinical); CO production from desflurane + desiccated; (4) Selection: - Sevoflurane: peds induction (sweet, bronchodilator), short cases, neuroanesthesia (limited MAC); - Desflurane: rapid emergence (long cases, obese — fast offset); avoid: induction (irritant); high environmental impact; - Isoflurane: cardiac surgery, neuro, cost-effective; - N2O: adjunct (analgesia, MAC sparing); avoid pneumothorax, bowel obstruction, middle ear, retinal surgery; B12 deficiency

---

Volatile: MAC, solubility (des fastest), CV depression, bronchodilator (sevo > des), increased CBF/ICP, MH trigger. Sevo: peds induction. Des: rapid emergence, irritant induction. Iso: cardiac, neuro. N2O: adjunct + restrictions.', NULL,
  'easy', 'respiratory', 'review',
  'anesthesiology', 'basic_science', 'respiratory', 'adult',
  'Miller''s Anesthesia; Stoelting Pharmacology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Question on volatile anesthetics pharmacology'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Question on opioid pharmacology in anesthesia', '[{"label":"A","text":"All opioids equivalent"},{"label":"B","text":"Opioids"},{"label":"C","text":"Use only morphine universally"},{"label":"D","text":"Naloxone first-line analgesic"},{"label":"E","text":"Avoid all opioids universally"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Opioids — anesthesia pharmacology: (1) Mu-receptor agonist mechanism (analgesia, respiratory depression, sedation, miosis, decreased GI motility, urinary retention, pruritus, tolerance, dependence); (2) Specific agents: - Morphine — IV, IM, oral, neuraxial; onset 5-10 min IV, peak 20 min, duration 3-4h; active metabolite M6G (renal accumulation — avoid CKD); histamine release; intrathecal morphine = prolonged analgesia (up to 24h) for C-section, major surgery; - Fentanyl — synthetic, 100× morphine potency; rapid onset (30-60s IV), short duration (30-60 min single dose) but accumulates context-sensitive half-time; lipophilic; safer renal; transdermal patch (chronic pain); intrathecal/epidural; - Sufentanil — 1000× morphine; intra-op for cardiac; - Alfentanil — short-acting (5-10 min); - Remifentanil — ultra-short (3-5 min); ester linkage metabolized by plasma esterases; infusion 0.05-0.5 mcg/kg/min; no accumulation; rapid recovery; opioid-induced hyperalgesia + acute tolerance; need bridge analgesic before stop; - Hydromorphone — 5-7× morphine; PCA; renal safer than morphine; - Oxycodone — oral; PO common; - Methadone — NMDA antagonist + Mu; long half-life; chronic pain + OUD; QTc prolongation, drug interactions; - Tramadol — weak Mu + SNRI; seizure risk, serotonin syndrome; - Buprenorphine — partial agonist; ceiling for respiratory depression; OUD, chronic pain; (3) Reversal — naloxone (Mu antagonist) 0.04-0.4 mg IV titrated; short half-life (need repeat); precipitate withdrawal; - Naltrexone — oral long-acting (OUD/AUD treatment); (4) Side effect management — multimodal opioid-sparing; PRO laxative; pruritus (nalbuphine, antihistamine); urinary retention; (5) PCA settings — bolus + lockout; basal rare; (6) Modern: opioid epidemic awareness, minimize where possible

---

Opioids: morphine (M6G renal), fentanyl (rapid, lipophilic), remifentanil (esterase, ultra-short), sufentanil, hydromorphone (renal safer), methadone (NMDA + QTc), tramadol (SNRI). Naloxone reversal. Multimodal opioid-sparing.', NULL,
  'easy', 'procedures', 'review',
  'anesthesiology', 'basic_science', 'procedures', 'adult',
  'Miller''s Anesthesia; Stoelting Pharmacology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Question on opioid pharmacology in anesthesia'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Question on local anesthetic pharmacology', '[{"label":"A","text":"All locals same"},{"label":"B","text":"Local anesthetics"},{"label":"C","text":"Skip all locals"},{"label":"D","text":"Mass IV bupivacaine"},{"label":"E","text":"Use cocaine routinely"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Local anesthetics — pharmacology: (1) Mechanism — block voltage-gated Na+ channels (intracellular side) → prevents action potential propagation; (2) Structure — lipophilic aromatic + amide/ester linkage + hydrophilic amine; lipid solubility = potency; protein binding = duration; pKa = onset; (3) Classification: - Esters (1 ''i'' in name): procaine, chloroprocaine (very short), tetracaine (long), cocaine; metabolized by plasma cholinesterase; PABA metabolite (allergy more common); - Amides (2 ''i'' in name): lidocaine, bupivacaine, ropivacaine, mepivacaine, prilocaine; metabolized hepatic; (4) Common agents: - Lidocaine — fast onset, intermediate duration; max 4.5 mg/kg (7 mg/kg with epinephrine); IV use OK (LAST risk lower than bupivacaine); ventricular arrhythmia treatment; topical; - Bupivacaine — slow onset, long duration (4-8h); highly protein-bound; CARDIOTOXIC (worse than CNS toxicity ratio); use carefully + max 2 mg/kg (3 with epi); levobupivacaine = S-enantiomer (less cardiotox); - Ropivacaine — long duration; less cardiotoxic than bupivacaine; less motor block (sensory > motor) — useful labor; max 3-4 mg/kg; - Mepivacaine — intermediate duration; - Prilocaine — risk methemoglobinemia (avoid in infants, anemic, G6PD); EMLA component; (5) Adjuncts: - Epinephrine 1:200,000 — vasoconstrictor: prolongs duration, reduces systemic absorption + LAST risk; AVOID end-arteries (digit, penis, ear), peripheral nerve blocks now OK in most; - Bicarbonate — speed onset (raises pH); - Dexamethasone — prolongs block (perineural or IV); - Dexmedetomidine, clonidine — alpha-2 prolong; (6) Toxicity LAST — CNS (perioral numbness → tinnitus → metallic taste → seizure → coma) + CV (hypotension → arrhythmia → arrest); bupivacaine worst CV; treatment — lipid emulsion 20% (1.5 mL/kg bolus + infusion); (7) Allergy — true rare; esters > amides; preservative methylparaben often blamed

---

Locals: Na channel block. Esters (procaine, chloroprocaine, tetracaine; PABA) vs amides (lidocaine, bupivacaine, ropivacaine). Bupivacaine cardiotoxic. Adjuncts: epi, bicarb, dex. LAST: lipid emulsion. Max doses critical.', NULL,
  'easy', 'procedures', 'review',
  'anesthesiology', 'basic_science', 'procedures', 'adult',
  'Miller''s Anesthesia; ASRA LAST', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Question on local anesthetic pharmacology'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'OR 35 ปี healthy patient sevoflurane induction + succinylcholine
10 min: jaw rigidity (masseter spasm), HR rising 90 → 130, EtCO2 mild rising 40 → 48, no temp change yet
BP stable', '[{"label":"A","text":"Ignore + continue"},{"label":"B","text":"MMR (Masseter Muscle Rigidity)"},{"label":"C","text":"Continue surgery + give more sux"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Increase volatile"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** MMR (Masseter Muscle Rigidity) — possible MH precursor: (1) MMR after succinylcholine — common (1%) in peds; significance varies: - Mild + transient (jaw stiff but mouth opens) — usually normal succinylcholine effect; - SEVERE (jaw locked, cannot open) = MH-suggestive in 50%; (2) Management: - If severe MMR with other MH signs (rising EtCO2, tachycardia, rhabdo, acidosis): treat as MH — stop triggers, dantrolene, cooling; - If isolated MMR + no other features: postpone elective surgery, observe in PACU/ICU 24h; monitor for late MH features; check CK, K, urine myoglobin q6h × 24h; counsel future anesthesia; refer for MH testing (in vitro contracture test, genetic); - Urgent surgery: switch to non-triggering anesthetic; (3) MH-trigger-free anesthetic for future + family: avoid volatile + succinylcholine; use TIVA propofol + opioid + non-depolarizing NMB (rocuronium/cisatracurium); change circuit + soda lime; MH machine prep (flushing 10+ min, fresh circuit); (4) Documentation + MedicAlert; (5) Family counseling — autosomal dominant inheritance; (6) MHAUS Hotline 1-800-MH-HYPER for consultation; (7) Definitive diagnosis — caffeine-halothane contracture test (gold standard) or genetic testing (RYR1, CACNA1S — ~80% sensitivity); (8) MH-susceptible = OK for surgery with trigger-free anesthetic; (9) Differential MMR — TMJ pathology, dystonic reaction, myotonic disorder; (10) Modern: Ryanodex (dantrolene faster reconstitution)

---

MMR after sux: mild = normal; severe + other signs = treat as MH. Isolated severe MMR — postpone elective, observe 24h, MH workup. Future trigger-free anesthetic. MHAUS hotline. Genetic + contracture testing.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'anesthesiology', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'MHAUS Guidelines; ASA Practice Advisory', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'OR 35 ปี healthy patient sevoflurane induction + succinylcholine
10 min: jaw rigidity (masseter spasm), HR rising 90 → 130, EtCO2 mild rising 40 → 48, no temp change yet
BP stable'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'OR — patient just received IV cefazolin pre-incision + rocuronium for induction
3 min later: profound hypotension BP 60/30, HR 140, increased airway pressure, no rash visible yet under drape
Unresponsive to phenylephrine bolus', '[{"label":"A","text":"Continue case"},{"label":"B","text":"Intra-op anaphylaxis"},{"label":"C","text":"Discharge to PACU"},{"label":"D","text":"More cefazolin"},{"label":"E","text":"Anti-histamine only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Intra-op anaphylaxis — REFRACTORY: (1) Recognition under drape — hypotension + bronchospasm + tachycardia (or bradycardia in severe) often precedes rash; (2) Stop trigger (suspect rocuronium > cefazolin — NMB most common in OR anaphylaxis); call for help; declare emergency; (3) Epinephrine FIRST-LINE — 100-200 mcg IV bolus; repeat every 1-2 min; infusion if refractory (1-10 mcg/min titrated up to 50 mcg/min); intramuscular 0.3-0.5 mg if no IV access; (4) Airway — 100% O2, may need to deepen anesthesia for refractory bronchospasm; consider ECMO if refractory hypoxia; (5) Aggressive fluid resuscitation — 20-30 mL/kg crystalloid bolus; capillary leak + distributive shock; (6) Trendelenburg position to optimize venous return; (7) Refractory hypotension despite epinephrine: - Norepinephrine + vasopressin; - Methylene blue 1-2 mg/kg (NOS inhibitor for vasoplegia); - Glucagon 1-5 mg if on beta-blocker (interferes with epinephrine response); - Consider VA-ECMO for refractory; (8) Secondary medications (after epinephrine): - H1 antihistamine (diphenhydramine 50 mg IV); - H2 antihistamine (ranitidine 50 mg IV or famotidine); - Corticosteroid (hydrocortisone 200 mg IV or methylprednisolone 1-2 mg/kg) — prevents biphasic; (9) Decision continue vs abort surgery — stabilize first; case-by-case; (10) Post-event — tryptase level 30 min - 3h post-event (peak); document trigger; refer for allergy testing 4-6 weeks (skin testing + IgE, BAT — basophil activation test); MedicAlert; (11) ICU observation 24h (biphasic risk 1-20%); (12) Top triggers — NMB (rocuronium, succinylcholine), antibiotics (cefazolin, penicillin, vancomycin), latex, chlorhexidine, contrast, blood; (13) Document for future

---

Refractory anaphylaxis: epinephrine first-line + infusion, fluid bolus 20-30 mL/kg, methylene blue + glucagon (beta-blocker) for refractory, ECMO. Secondary meds: antihistamine + steroid. Tryptase + allergy testing. NMB top trigger.', NULL,
  'hard', 'toxicology', 'review',
  'anesthesiology', 'clinical_decision', 'toxicology', 'adult',
  'ASA + WAO Anaphylaxis Practice Parameter; NAP6', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'OR — patient just received IV cefazolin pre-incision + rocuronium for induction
3 min later: profound hypotension BP 60/30, HR 140, increased airway pressure, no rash visible yet under drape
Unresponsive to phenylephrine bolus'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'OR patient under spinal anesthesia for inguinal hernia + IV sedation
5 min after spinal injection: anxiety, slurred speech, lightheaded, then tonic-clonic seizure
LA used: 0.5% bupivacaine 15 mL + epinephrine for combined spinal + field block by surgeon', '[{"label":"A","text":"Wait + observe"},{"label":"B","text":"LAST (Local Anesthetic Systemic Toxicity) management"},{"label":"C","text":"Calcium gluconate first-line"},{"label":"D","text":"Increased epinephrine dose"},{"label":"E","text":"More LA injection"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** LAST (Local Anesthetic Systemic Toxicity) management — ASRA Checklist 2020: (1) Recognition — CNS symptoms (perioral numbness → tinnitus → metallic taste → confusion → seizure → coma) precede CV (hypotension → arrhythmia → arrest); bupivacaine worst CV toxicity; (2) IMMEDIATE: call for help + LAST checklist + lipid emulsion + airway help; (3) Airway management — 100% O2, hyperventilation (alkalosis improves CV outcome — moves drug off Na channels); intubate if needed; (4) Seizure: - Benzodiazepine preferred (midazolam 2-4 mg, lorazepam 2-4 mg) — minimal CV depression; - Small dose propofol acceptable IF no CV compromise; AVOID propofol if hypotensive (further CV depression); - Avoid additional LA (lidocaine); (5) LIPID EMULSION 20% (Intralipid) — first-line cornerstone for cardiovascular toxicity (also helps CNS): - Bolus 1.5 mL/kg LBW over 1 min (~100 mL adult); - Infusion 0.25 mL/kg/min × 30 min minimum; - Repeat bolus + double infusion if persistent CV collapse; - Maximum 12 mL/kg total; - Mechanism: lipid sink + metabolic + ionotrope effects; (6) Modified ACLS for cardiac arrest: - Chest compressions; - Lipid emulsion priority; - SMALL doses epinephrine (1 mcg/kg = ~70 mcg) — high-dose impairs lipid efficacy; - AVOID: vasopressin (increased mortality), beta-blocker (depress contractility), calcium channel blocker, lidocaine/procainamide; - Cardiopulmonary bypass/ECMO if refractory; (7) PROLONGED RESUSCITATION — survival reported > 1 hour; (8) Post-event monitoring — ICU 4-6h minimum (recurrent CV instability), liver/lipid monitoring; (9) Prevention: - Aspiration test before injection (multiple sites for nerve block); - Slow incremental injection; - Ultrasound guidance peripheral block; - Test dose epinephrine; - Appropriate dose for weight (max bupivacaine 2-3 mg/kg); (10) Bupivacaine 15 mL of 0.5% = 75 mg; >> typical spinal dose (10-15 mg); concern systemic absorption from field block or intravascular component

---

LAST: lipid emulsion 20% cornerstone (1.5 mL/kg bolus + 0.25 mL/kg/min infusion). Benzo for seizure. Modified ACLS — SMALL epi, NO vasopressin/beta-blocker/CCB/LA. Prolonged resus. Prevention: aspirate, US, dose limits.', NULL,
  'medium', 'toxicology', 'review',
  'anesthesiology', 'clinical_decision', 'toxicology', 'adult',
  'ASRA LAST Checklist 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'OR patient under spinal anesthesia for inguinal hernia + IV sedation
5 min after spinal injection: anxiety, slurred speech, lightheaded, then tonic-clonic seizure
LA used: 0.5% bupivacaine 15 mL + epinephrine for combined spinal + field block by surgeon'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 65 ปี post-major abdominal surgery PACU
Shivering, restless, SpO2 95% on 4L NC, BP 145/90, HR 100
Core temp 35.4°C, peripheral cold', '[{"label":"A","text":"Discharge to ward"},{"label":"B","text":"Postoperative hypothermia + shivering management"},{"label":"C","text":"Cool further"},{"label":"D","text":"Ignore + observe"},{"label":"E","text":"Restraint patient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Postoperative hypothermia + shivering management: (1) Recognition — core temp < 36°C; mild 35-36, moderate 32-35, severe < 32; (2) Consequences: - Increased cardiac complications (shivering → 5× O2 consumption, MI risk); - Coagulopathy (impaired platelet + enzyme); - Delayed drug metabolism + emergence; - Wound infection (vasoconstriction → tissue hypoxia + impaired neutrophil); - Patient discomfort + length of stay; (3) Active rewarming: - Forced air warmer (Bair Hugger) — most effective; - Warmed IV fluids (37-40°C); - Warm humidified gases; - Room temperature 24-26°C; (4) Shivering treatment: - Meperidine 12.5-25 mg IV (most effective; kappa receptor) — avoid in MAOI, serotonin syndrome risk; - Tramadol; - Clonidine; - Dexmedetomidine; - Magnesium sulfate; - Buspirone; - Ondansetron; (5) Oxygen supplementation — meets increased demand; (6) Monitor — ECG (arrhythmia risk), serial temps q15-30 min; (7) Prevention — intraoperative warming (pre-warming pre-op, intraop forced air, fluid warming, warm room, humidified gases); (8) High-risk patients — elderly, low BMI, long surgery, large fluid/blood, open cavity, regional anesthesia (vasodilation); (9) Severe hypothermia (< 32°C) — aggressive: warmed IV, ETT humidification, bladder/peritoneal lavage, ECMO if cardiac arrest; (10) Goals — target normothermia 36-37°C before transfer to ward; (11) Document

---

Postop hypothermia: active rewarming (Bair Hugger, warm IV), shivering treatment (meperidine first-line), O2 supplementation. Consequences: MI, coagulopathy, infection. Prevention via intraop warming. Target 36-37°C.', NULL,
  'easy', 'procedures', 'review',
  'anesthesiology', 'clinical_decision', 'procedures', 'adult',
  'ASPAN Hypothermia Guidelines; ASA Practice Advisory', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 65 ปี post-major abdominal surgery PACU
Shivering, restless, SpO2 95% on 4L NC, BP 145/90, HR 100
Core temp 35.4°C, peripheral cold'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 75 ปี post-hip surgery PACU
Alert but slow to respond, SpO2 88% on 4L NC, RR 8, pinpoint pupils
Received: morphine 8 mg PCA + previous IV doses', '[{"label":"A","text":"Discharge"},{"label":"B","text":"Opioid-induced respiratory depression"},{"label":"C","text":"More opioid"},{"label":"D","text":"Ignore vital signs"},{"label":"E","text":"Sedative IV bolus"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Opioid-induced respiratory depression — PACU: (1) Recognition — RR < 10, sedation (Pasero opioid-induced sedation scale > 3), SpO2 drop, pinpoint pupils; elderly + comorbid most at risk; (2) Immediate — stimulate, supplemental O2 high-flow, position (jaw thrust, lateral if vomiting risk), call for help; (3) Naloxone — opioid antagonist: - Dose 0.04-0.4 mg IV (start low — titrate to RR without precipitating withdrawal/pain); - Onset 1-2 min, duration 30-90 min (shorter than most opioids — repeat or infusion may be needed); - Mu receptor antagonist; - Side effects: precipitated withdrawal (pain, hypertension, tachycardia, arrhythmia, pulmonary edema rare); - Infusion if long-acting opioid 2/3 effective bolus dose per hour; (4) Airway management — bag mask, intubation if severe; (5) Hold further opioids; reassess pain control; (6) Identify causes: - Cumulative opioid dose; - Combination with sedatives/benzo (synergistic — CDC warning); - Renal/hepatic accumulation (morphine M6G in renal failure); - Patient factors (elderly, OSA, obesity, COPD, opioid-naive); - PCA programming error; (7) Multimodal opioid-sparing — reduce future risk; (8) Continuous monitoring — capnography (EtCO2) detects hypoventilation BEFORE SpO2 drops; modern recommendation for high-risk patients on opioid PCA; (9) ICU/step-down for monitoring after event; (10) Documentation + safety review; (11) Prevention: PCA without basal rate typically, lockout, dose reduction in elderly + renal, multimodal analgesia, opioid-induced sedation scale assessment q1-2h, naloxone available

---

Opioid-induced respiratory depression: naloxone titrated 0.04-0.4 mg IV. Watch for withdrawal/recurrence (short half-life). Capnography monitoring high-risk PCA. Multimodal opioid-sparing prevention.', NULL,
  'easy', 'respiratory', 'review',
  'anesthesiology', 'clinical_decision', 'respiratory', 'adult',
  'ASA Practice Advisory; APSF Capnography Monitoring', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 75 ปี post-hip surgery PACU
Alert but slow to respond, SpO2 88% on 4L NC, RR 8, pinpoint pupils
Received: morphine 8 mg PCA + previous IV doses'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Question on patient safety in anesthesia practice — preventing wrong-site surgery', '[{"label":"A","text":"Skip checklist"},{"label":"B","text":"WHO Surgical Safety Checklist"},{"label":"C","text":"Surgeon alone responsible"},{"label":"D","text":"Speak up culture suppressed"},{"label":"E","text":"No documentation needed"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** WHO Surgical Safety Checklist — patient safety: (1) Three phases: - SIGN IN (before induction): patient ID, site, procedure, consent, anesthesia safety check, allergies, difficult airway, blood loss risk; - TIME OUT (before skin incision): all team introduce themselves + role, confirm patient/site/procedure, anticipated critical events surgeon/anesthesia/nurse, antibiotic 60 min, imaging displayed, sterile + equipment OK; - SIGN OUT (before patient leaves OR): procedure recorded, instrument/sponge/needle count, specimen labeled, equipment concerns, key concerns for recovery; (2) Effectiveness — WHO study reduced mortality 40% + complications 36% in low/middle income settings; (3) Implementation success requires: - Team buy-in + leadership; - Customized to local setting; - Continuous training + reinforcement; - Audit + feedback; - Combine with team training (CRM); (4) Joint Commission Universal Protocol: - Pre-procedure verification; - Mark site (surgeon mark + patient awake/aware); - Time out (active confirmation, all team); (5) Crew Resource Management (CRM) — borrowed from aviation; flat hierarchy, speak up culture, closed-loop communication; (6) Just culture — distinguish honest error from reckless behavior; learn from near-miss + adverse event; report without fear; (7) Crisis checklists — emergency manuals (Stanford, Harvard, AOA) — bedside aids for crisis (MH, LAST, anaphylaxis, ACLS, ALS); (8) Quality improvement frameworks — PDSA cycles, root cause analysis; (9) Patient + family engagement; (10) Modern: human factors engineering, simulation training, technology integration (EHR alerts, smart pumps)

---

WHO Surgical Safety Checklist: Sign In + Time Out + Sign Out. Reduces mortality 40%. Joint Commission Universal Protocol. CRM. Just culture. Emergency manuals. Multimodal patient safety.', NULL,
  'easy', 'procedures', 'review',
  'anesthesiology', 'ems_mgmt', 'procedures', 'adult',
  'WHO Surgical Safety Checklist; Joint Commission', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Question on patient safety in anesthesia practice — preventing wrong-site surgery'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Question on anesthesia informed consent + capacity', '[{"label":"A","text":"Skip consent"},{"label":"B","text":"Informed consent for anesthesia"},{"label":"C","text":"Coerce patient"},{"label":"D","text":"Ignore patient preferences"},{"label":"E","text":"DNR automatically suspended in OR"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Informed consent for anesthesia: (1) Required elements: - Disclosure of nature of anesthesia + procedure; - Risks (common + rare but serious): mortality, MI, stroke, awareness, PONV, dental damage, allergic reaction, nerve injury, PDPH, infection, transfusion-related; - Benefits; - Alternatives (regional vs GA, MAC, no anesthesia); - Patient questions answered; - Voluntary (no coercion); (2) Capacity assessment — ability to: - Understand the information; - Appreciate the implications; - Reason about choices; - Communicate a choice; (3) Surrogate decision-makers if patient lacks capacity: - Healthcare proxy/medical power of attorney; - Court-appointed guardian; - Family hierarchy per state law (spouse, adult child, parent, sibling); - Two-physician consent in emergency without surrogate; (4) Special populations: - Pediatric — parent/guardian consent + child assent (age-appropriate, typically > 7); - Pregnant patient — usually unchanged; emergent procedures; - Cognitively impaired — surrogate + best interest; - Emergency — implied consent if life-threatening + no surrogate available; - Jehovah''s Witness — respect blood refusal even if life-threatening (adult competent); document; advance directive; (5) Documentation — written + verbal discussion; specific risks discussed; alternatives offered; questions answered; patient + witness signature; (6) Refusal of anesthesia/surgery — explore reasons, address concerns, alternatives, document refusal + counseled; (7) Withdrawal of consent — can occur any time before/during procedure if competent; (8) DNR in OR — ASA recommends required reconsideration (not automatic suspension); explicit discussion + documentation; (9) Modern: shared decision-making, patient values, decision aids; (10) Ethical principles: autonomy, beneficence, non-maleficence, justice

---

Informed consent: disclose risks/benefits/alternatives, capacity assessment, surrogate if lacks, special populations, document, withdrawal allowed. DNR in OR = required reconsideration not automatic suspension. Shared decision-making.', NULL,
  'easy', 'procedures', 'review',
  'anesthesiology', 'ems_mgmt', 'procedures', 'adult',
  'ASA Statement on Ethical Practice; AMA Code Medical Ethics', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Question on anesthesia informed consent + capacity'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Question on operating room fire safety + electrosurgery', '[{"label":"A","text":"Fire safety not concern of anesthesiologist"},{"label":"B","text":"OR Fire Safety"},{"label":"C","text":"Use 100% O2 always"},{"label":"D","text":"Skip wet drapes"},{"label":"E","text":"Alcohol prep wet OK"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** OR Fire Safety — Fire Triangle: (1) Three elements (anesthesia owns oxidizer): - Fuel: drapes, gauze, ETT, alcohol prep, hair, GI gas; - Heat/ignition: electrosurgery (Bovie), laser, fiberoptic light source; - Oxidizer: O2, N2O (supports combustion); (2) High-risk procedures (Joint Commission alerts): - Surgery above xiphoid + open O2 source + heat source; - Head/neck/upper airway surgery; - Tonsillectomy/adenoidectomy + cautery; - Tracheostomy with cautery during entry; (3) Anesthesia role — minimize O2 to lowest needed; ideally < 30% FiO2 for high-risk; transition to medical air if open delivery (NC, mask); communicate to team before electrocautery; (4) Surgeon role: - Pause O2 reduction before activating cautery (30s wait); - Use bipolar over monopolar in airway; - Cuffed ETT for tonsillectomy with cautery to prevent O2 leak; - Laser-resistant ETT for laser surgery; - Saline-filled cuff with methylene blue (detect rupture); - Wet drapes/gauze in surgical field; (5) Drape patient with O2-permeable drapes; avoid pooling; (6) Alcohol prep — fully dry before drape + electrocautery; document drying; (7) Airway fire: - STOP all gases (disconnect ventilator); - Remove ETT immediately; - Pour saline into airway + extinguish fire; - Re-intubate after fire extinguished; - Inspect airway for damage (bronchoscopy); - Monitor for thermal injury + edema; - Steroids + observation 24h+; (8) Drape fire: - Stop O2 flow; - Remove burning drape; - Water/saline to extinguish; - Cardex CO2 fire extinguisher; (9) Education + simulation; emergency protocol posted; (10) Modern: laser smoke evacuator (toxic plume), team training, fire drills; (11) Documentation post-event

---

OR fire: triangle (fuel + heat + O2 oxidizer). Anesthesia reduces FiO2 < 30%, pause before cautery. Cuffed ETT for tonsillectomy + cautery. Airway fire: stop gas, remove ETT, saline, re-intubate. Wet drapes. Education + simulation.', NULL,
  'medium', 'procedures', 'review',
  'anesthesiology', 'ems_mgmt', 'procedures', 'adult',
  'ASA Practice Advisory on OR Fire 2013; APSF Fire Safety', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Question on operating room fire safety + electrosurgery'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย Jehovah''s Witness 45 ปี severe anemia Hb 7.5 — elective major orthopedic surgery
Refuses all blood products including PRC + plasma; will accept albumin + cell saver + recombinant factors
Understands risks including death; competent adult with advance directive', '[{"label":"A","text":"Force transfusion"},{"label":"B","text":"Jehovah''s Witness bloodless surgery"},{"label":"C","text":"Refuse surgery"},{"label":"D","text":"Override decision"},{"label":"E","text":"Hide transfusion"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Jehovah''s Witness bloodless surgery — ethical + clinical: (1) Respect patient autonomy — competent adult refusal of transfusion is legally + ethically binding (most jurisdictions); cannot transfuse against will even if life-threatening; (2) Explore patient preferences — what they accept varies (some accept albumin, immune globulin, clotting factors, dialysis, cell saver, normovolemic hemodilution; some refuse all blood-derived products); document explicitly; (3) Advance directive + healthcare proxy review; (4) Pre-op optimization — aggressive: - Iron (PO 3x daily, or IV iron sucrose/iron carboxymaltose if PO failed/intolerant); - Erythropoietin (EPO) — stimulate erythropoiesis; - B12, folate; - Treat underlying cause anemia; - Optimize medical conditions; - Time elective surgery for optimization (target Hb > 13); (5) Intra-op blood conservation: - Cell saver (autologous; most witnesses accept); - Acute normovolemic hemodilution (ANH) — collect autologous blood in continuity with patient (accept if attached); - Antifibrinolytics (TXA 1g IV); - Permissive low BP (within safety); - Bipolar electrocautery, vessel sealer, harmonic; - Minimal blood draw (microsampling); - Topical hemostatics (fibrin glue, gelfoam); - Limit phlebotomy; (6) Anesthetic technique — regional anesthesia (less bleeding), controlled hypotension carefully, position to minimize blood loss; (7) Post-op — minimize blood loss, iron + EPO continued, monitor; (8) Multidisciplinary — anesthesia + surgery + hematology + ethics consult + Jehovah''s Witness Hospital Liaison Committee; (9) Pediatric Jehovah''s Witness — different (parents'' refusal may be overridden for child''s life); court order if needed; (10) Patient Blood Management (PBM) principles apply to ALL patients now — minimize unnecessary transfusion (universal benefit); (11) Document + communicate

---

Jehovah''s Witness: respect autonomy (competent adult). Explore acceptable products. Optimize anemia (iron, EPO). Cell saver, ANH, TXA. Pediatric different (court order possible). PBM universal. Multidisciplinary + ethics.', NULL,
  'medium', 'hematology', 'review',
  'anesthesiology', 'integrative', 'hematology', 'adult',
  'ASA Patient Blood Management; AABB Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วย Jehovah''s Witness 45 ปี severe anemia Hb 7.5 — elective major orthopedic surgery
Refuses all blood products including PRC + plasma; will accept albumin + cell saver + recombinant factors
Understands risks including death; competent adult with advance directive'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย 80 ปี severe dementia, hip fracture — capacity to consent uncertain
Family wants surgery, patient inconsistent
No advance directive, no formal proxy', '[{"label":"A","text":"Just operate"},{"label":"B","text":"Capacity + surrogate consent in elderly with dementia"},{"label":"C","text":"Refuse surgery + nothing"},{"label":"D","text":"Skip family input"},{"label":"E","text":"Ignore advance directive concept"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Capacity + surrogate consent in elderly with dementia: (1) Capacity assessment: - Specific to decision (sliding scale — higher stakes = higher capacity threshold); - Four components: understand, appreciate, reason, communicate choice; - Document specific assessment (not just diagnosis); - Re-assess (capacity may fluctuate — sundowning, delirium, medication); (2) Lack of capacity → surrogate decision-maker: - Healthcare proxy / medical POA (formal designation); - Court-appointed guardian; - Family hierarchy per state/jurisdiction law (typically: spouse → adult children → parents → siblings → close friend); - Two-physician consent for emergency without surrogate (life-threatening); - Ethics committee for difficult cases; (3) Substituted judgment standard (preferred) — what would patient choose based on prior values, statements, religious beliefs; (4) Best interest standard (fallback) — what reasonable person would choose; (5) Hip fracture in elderly: - Surgical repair improves mortality + function; mortality 30% at 1 year without surgery; - Pain control, mobilization, dignity; - Goals of care discussion with family + medical team; - Palliative approach if dying or extremely frail; (6) Anesthetic considerations elderly with dementia: - Pre-op delirium screening (Mini-Cog); - Regional anesthesia preferred (spinal — less delirium than GA per some studies; but recent RCT REGAIN showed no difference); - Avoid benzodiazepines, anticholinergics, long-acting opioid (Beers list); - Multimodal analgesia; - Family presence + reorientation; - Quick mobilization; (7) Ethics: - Autonomy respect — what patient would want; - Beneficence — what''s medically beneficial; - Non-maleficence — avoid harm; - Justice; (8) Multidisciplinary — anesthesia + surgery + geriatric medicine + palliative care + ethics consult + social work + family meeting; (9) Document all

---

Elderly + dementia + hip fracture: capacity assessment specific, surrogate hierarchy, substituted judgment > best interest, hip surgery improves outcomes, regional + multimodal anesthesia, delirium prevention, ethics consult, multidisciplinary.', NULL,
  'medium', 'psych_behavior', 'review',
  'anesthesiology', 'integrative', 'psych_behavior', 'adult',
  'ASA Geriatric Anesthesia; AGS Beers Criteria 2023', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วย 80 ปี severe dementia, hip fracture — capacity to consent uncertain
Family wants surgery, patient inconsistent
No advance directive, no formal proxy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 35 ปี OSA severe AHI 45 — elective bariatric sleeve gastrectomy
BMI 48, CPAP non-adherent, HTN, T2DM
Berlin questionnaire + STOP-BANG 7 (high risk)', '[{"label":"A","text":"Outpatient surgery"},{"label":"B","text":"OSA + obesity perioperative management"},{"label":"C","text":"Heavy benzodiazepine premed"},{"label":"D","text":"Skip CPAP postop"},{"label":"E","text":"Long-acting opioid PCA"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** OSA + obesity perioperative management: (1) STOP-BANG ≥ 3 = high risk OSA; sleep study if not yet diagnosed; (2) Pre-op CPAP optimization 1-3 months pre-op (improves cardiac, BP, glucose); bring own CPAP to hospital; (3) Anesthetic considerations: - Difficult airway anticipated (large neck, redundant tissue, Mallampati high) — video laryngoscope first-pass, ramped (HELP) position, pre-O2 + apneic oxygenation, awake fiberoptic for severe; - Multimodal opioid-sparing analgesia (TAP block, ESP, IV ketamine, acetaminophen, NSAID); - Minimize benzodiazepines (sedation + respiratory depression); - Short-acting agents (propofol TIVA, remifentanil, sugammadex); - Regional anesthesia when possible; (4) Intra-op ventilation — lung-protective, PEEP 8-10, recruitment maneuvers, position semi-recumbent; (5) Post-op CPAP continuous when not eating/drinking; lateral position; (6) Monitoring — continuous SpO2 + capnography overnight; step-down or ICU for severe OSA; AVOID outpatient discharge for severe OSA with major surgery; (7) Bariatric surgery specific — laparoscopic, ERAS, TAP block, multimodal, early mobilization, DVT prophylaxis, glucose control; (8) Opioid considerations — increased sensitivity in OSA + chronic hypoxia; (9) Discharge criteria — adequate respiratory function on room air after typical opioid usage pattern; CPAP at home; (10) Outcomes — OSA patients increased OR cancellation, perioperative complications, ICU admission, death — recognition + optimization critical

---

OSA + obesity: STOP-BANG screen, CPAP optimize, difficult airway prep, opioid-sparing, ramped position, postop CPAP + monitoring. Bariatric ERAS. Avoid outpatient discharge severe OSA major surgery.', NULL,
  'medium', 'respiratory', 'review',
  'anesthesiology', 'clinical_decision', 'respiratory', 'adult',
  'SAMBA OSA Practice Advisory; STOP-BANG', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 35 ปี OSA severe AHI 45 — elective bariatric sleeve gastrectomy
BMI 48, CPAP non-adherent, HTN, T2DM
Berlin questionnaire + STOP-BANG 7 (high risk)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 65 ปี chronic alcohol use 4 standard drinks/day × 30 ปี — elective surgery in 1 week
No cirrhosis on labs (AST 65, ALT 50, GGT 220)
Last drink today, mild tremor, anxious', '[{"label":"A","text":"Force abstinence cold turkey"},{"label":"B","text":"Alcohol use disorder perioperative"},{"label":"C","text":"Ignore drinking history"},{"label":"D","text":"Give glucose first not thiamine"},{"label":"E","text":"Refuse care"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Alcohol use disorder perioperative: (1) Pre-op — abrupt cessation = withdrawal risk (DTs mortality 5-15% untreated); (2) Withdrawal prophylaxis: - CIWA-Ar scoring guide treatment; - Benzodiazepines first-line (chlordiazepoxide, diazepam, lorazepam — lorazepam in hepatic dysfunction); symptom-triggered or scheduled; - Thiamine 100 mg IV/IM BEFORE glucose (Wernicke prevention); folate, multivitamin; - Magnesium replacement; - Phenobarbital alternative; - Dexmedetomidine adjunct (not monotherapy); (3) Anesthetic considerations: - Tolerance to many anesthetics (chronic) — may need higher doses initially; - Acute intoxication = MAC decrease (synergistic); - Hepatic dysfunction — drug metabolism altered; - Increased PONV; cardiomyopathy possible; coagulopathy; nutritional deficiency; - Avoid LR if alcoholic ketoacidosis; - Multimodal pain management — careful with benzodiazepines (already on them for withdrawal); (4) Delay elective surgery if active withdrawal or recent heavy use; (5) Abstinence > 2-4 weeks pre-op ideal for elective; (6) Brief intervention + referral for treatment: - Counseling; - Naltrexone, acamprosate, disulfiram pharmacotherapy; - 12-step programs (AA); - Specialty addiction medicine; (7) Hidden withdrawal post-op — 2-5 days after last drink; suspect in agitation, confusion, autonomic instability; (8) ICU monitoring if severe withdrawal; (9) Documentation + non-stigmatizing approach

---

AUD perioperative: withdrawal prophylaxis (benzo + thiamine BEFORE glucose + Mg). Tolerance + hepatic + nutritional + cardiac considerations. Delay elective if active. Brief intervention + treatment referral. Monitor postop withdrawal.', NULL,
  'medium', 'psych_behavior', 'review',
  'anesthesiology', 'clinical_decision', 'psych_behavior', 'adult',
  'ASAM Alcohol Withdrawal Guidelines; ASA AUD Perioperative', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 65 ปี chronic alcohol use 4 standard drinks/day × 30 ปี — elective surgery in 1 week
No cirrhosis on labs (AST 65, ALT 50, GGT 220)
Last drink today, mild tremor, anxious'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 28 ปี G2P1 GA 32 wk severe placenta accreta spectrum diagnosed antenatally
Planned C-section + hysterectomy at 34-36 wk
MDT — anesthesia, OB, urology, IR, transfusion service', '[{"label":"A","text":"Standard C-section"},{"label":"B","text":"Placenta accreta spectrum (PAS) anesthesia"},{"label":"C","text":"Skip preplanning"},{"label":"D","text":"Outpatient C-section"},{"label":"E","text":"Single IV only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Placenta accreta spectrum (PAS) anesthesia: (1) PAS = abnormally adherent placenta (accreta, increreta, percreta); risk factors prior C-section, placenta previa; massive hemorrhage risk (estimated blood loss 2-5 L+); (2) Antenatal diagnosis (US, MRI) — multidisciplinary planning at PAS center; (3) Pre-op MDT planning: - Schedule 34-36 wk (before labor + bleeding); - Cell saver available; - Massive Transfusion Protocol activated; - IR for prophylactic balloon (uterine artery or internal iliac) — controversial; - Urology for bladder involvement (percreta); - Adequate IV access (2-3 large bore + arterial line + CVL); - Type + cross 6-10 units PRBC + matching FFP + platelets; - Cardiac surgery + general surgery available; (4) Anesthetic technique — controversial: - Combined spinal-epidural with epidural extension; OR - General anesthesia from start (safer airway control during massive hemorrhage); - Many centers use neuraxial → convert to GA when significant bleeding/hemodynamic instability; (5) Airway considerations — obstetric difficult airway expected; full RSI; video laryngoscopy first-line; (6) Intra-op management — TXA early (1g), warm fluids, normothermia, calcium, vasopressors, inotropes; TEG/ROTEM-guided; (7) Hysterectomy planned (vs conservative leave-in-place approaches); (8) Post-op ICU; ongoing transfusion + monitoring; DIC, AKI, ARDS risk; (9) Maternal mortality reduced significantly with PAS center care + MDT vs ad hoc; (10) Neonatology team for prematurity; (11) Modern: PAS centers of excellence, MDT essential, antifibrinolytic, REBOA in select centers

---

PAS: MDT planning at PAS center, schedule 34-36 wk, cell saver, MTP, IR balloon, neuraxial or GA, TXA early, TEG-guided. ICU postop. PAS center reduces mortality.', NULL,
  'hard', 'obgyn', 'review',
  'anesthesiology', 'clinical_decision', 'obgyn', 'adult',
  'SOAP Consensus PAS; SMFM Practice Bulletin', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 28 ปี G2P1 GA 32 wk severe placenta accreta spectrum diagnosed antenatally
Planned C-section + hysterectomy at 34-36 wk
MDT — anesthesia, OB, urology, IR, transfusion service'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยทารก 8 เดือน 8 kg — elective inguinal herniorrhaphy
No comorbidities, parents anxious, healthy term birth
NPO appropriate for age', '[{"label":"A","text":"GA + ETT routine"},{"label":"B","text":"Pediatric inguinal hernia anesthesia + caudal block"},{"label":"C","text":"Heavy opioid"},{"label":"D","text":"Adult-dose ketorolac"},{"label":"E","text":"No analgesia"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric inguinal hernia anesthesia + caudal block: (1) Anesthetic technique options: - GA with LMA or ETT + multimodal analgesia + regional; - Spinal anesthesia in infants (formerly preferred, less common now); - Awake spinal in former premies < 60 weeks PCA (apnea risk reduction); (2) GA induction — sevoflurane mask induction common in this age; IV after; (3) LMA appropriate for non-laparoscopic short cases; cuffed ETT alternative; (4) Caudal block — gold standard for sub-umbilical surgery analgesia in peds: - Position lateral; - Identify sacral hiatus (sacral cornua); - 22G needle ''pop'' through sacrococcygeal membrane; - LA: bupivacaine 0.25% 1 mL/kg (or ropivacaine 0.2% 1 mL/kg); max 2 mg/kg; - Adjuncts: clonidine 1-2 mcg/kg, dexamethasone, dexmedetomidine; - Duration 4-8h; - Ultrasound guidance increases success; (5) Multimodal — acetaminophen 15 mg/kg, ibuprofen 10 mg/kg; (6) Post-op — typically discharge same day; family education; (7) Premature/former-preterm < 60 weeks PCA — APNEA RISK postop GA — admit + apnea monitor 12-24h; (8) Avoid local anesthetic toxicity — calculate weight-based max dose carefully (lower margin in infants); (9) Family-centered care — parent presence at induction (controversial — some advocate, some say child life specialists/premed better); (10) Modern: regional anesthesia + multimodal + minimal opioid (peds opioid concerns less but same principles); SPA + APAGBI guidelines emphasize regional in peds

---

Peds inguinal hernia: caudal block gold standard + GA + multimodal. Bupivacaine 0.25% 1 mL/kg + adjuncts. Calculate max LA dose. Premature former < 60 weeks PCA = postop apnea monitor.', NULL,
  'easy', 'procedures', 'review',
  'anesthesiology', 'clinical_decision', 'procedures', 'peds',
  'APAGBI Regional Anesthesia Peds; SPA Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยทารก 8 เดือน 8 kg — elective inguinal herniorrhaphy
No comorbidities, parents anxious, healthy term birth
NPO appropriate for age'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยชาย 60 ปี non-cardiac thoracic surgery (esophagectomy) ASA III, COPD, smoker
Plan: thoracic epidural T7-T8 + GA, one-lung ventilation', '[{"label":"A","text":"GA only no epidural"},{"label":"B","text":"Thoracic surgery comprehensive anesthesia"},{"label":"C","text":"Mass crystalloid"},{"label":"D","text":"Long-acting opioid PCA only"},{"label":"E","text":"Skip pulmonary toilet"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Thoracic surgery comprehensive anesthesia: (1) Thoracic epidural T6-T8 = gold standard for thoracotomy analgesia: - Catheter pre-induction (awake) with patient cooperation; - Test dose; loading bupivacaine 0.125-0.25% + fentanyl + epinephrine; - Continuous infusion intra-op + post-op; - Excellent analgesia + opioid sparing + reduced pulmonary complications + chronic post-thoracotomy pain prevention; - Hypotension common — manage with phenylephrine + fluid; (2) Alternatives if epidural contraindicated/failed — paravertebral block, erector spinae plane block (ESP — emerging strong evidence), serratus plane block, intercostal blocks, intrathecal morphine; (3) One-lung ventilation strategy (covered separately) — DLT + lung-protective TV 4-6 mL/kg + PEEP; (4) Fluid management — restrictive (post-pneumonectomy pulmonary edema; ESM concept of fluid management); use vasopressor for BP support rather than fluid; (5) Goal-directed hemodynamic monitoring — arterial line, +/- TEE; cardiac output monitoring (esophageal Doppler, pulse contour); (6) Lung-protective ventilation; (7) Extubate in OR or early (avoid prolonged ventilation if possible); (8) ICU/HDU post-op; (9) Pain — continue epidural 3-5 days; convert to oral when tolerated; multimodal (acetaminophen, gabapentinoid, NSAID); (10) Pulmonary toilet — incentive spirometry, mobilization, PT, bronchodilator; (11) DVT prophylaxis — mechanical + LMWH timed with epidural removal per ASRA; (12) ERAS thoracic — multimodal, opioid-sparing, mobilization, fluid restriction

---

Thoracic surgery: epidural T6-T8 gold standard (alternatives ESP, PVB), OLV with lung-protective, restrictive fluids, goal-directed monitoring, early extubation, ERAS thoracic, multimodal analgesia.', NULL,
  'medium', 'respiratory', 'review',
  'anesthesiology', 'clinical_decision', 'respiratory', 'adult',
  'ERAS Thoracic 2019; ASRA Regional', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยชาย 60 ปี non-cardiac thoracic surgery (esophagectomy) ASA III, COPD, smoker
Plan: thoracic epidural T7-T8 + GA, one-lung ventilation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิง 25 ปี G1P0 GA 26 wk emergency appendectomy
Fetal viability + healthy mom otherwise
NPO 12h, normal labs', '[{"label":"A","text":"Cancel + wait postpartum"},{"label":"B","text":"Non-obstetric surgery in pregnancy"},{"label":"C","text":"GA without airway precautions"},{"label":"D","text":"Supine position no tilt"},{"label":"E","text":"Skip FHR check"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Non-obstetric surgery in pregnancy: (1) Indications — emergent (appendicitis, cholecystitis, trauma, ovarian torsion); delay elective surgery until postpartum; second trimester safest if must operate; (2) Pregnancy physiology adjustments: - Cardiovascular: increased CO 40%, decreased SVR, supine hypotensive syndrome (IVC compression > 20 wk — left lateral tilt); aortocaval compression; - Pulmonary: decreased FRC 20%, increased O2 consumption 20-30% — rapid desaturation; - GI: delayed gastric emptying + reduced LES tone — aspiration risk (full stomach assumption > 18-20 wk); - Hematologic: hypercoagulable, anemia of pregnancy; - Renal: increased GFR; - Difficult airway 8-10×; (3) Anesthetic technique: - Regional preferred when possible (spinal, epidural, peripheral nerve block) — avoids fetal drug exposure + airway risk; - GA if needed — RSI with cricoid + video laryngoscopy + difficult airway preparation; modify drug doses (decreased MAC, increased sensitivity); (4) Avoid teratogens — most modern anesthetics safe in pregnancy (no animal teratogenicity sufficient to cause concern); avoid N2O in early pregnancy (theoretical concern); (5) Fetal monitoring — FHR before and after; intra-op if > viability (typically > 24 wk) by OB consultation; preterm labor monitoring; (6) Tocolysis — prophylactic not routine; treat preterm labor if occurs; (7) DVT prophylaxis — VTE risk increased in pregnancy + surgery; mechanical + pharmacologic; (8) Maternal goals: maintain MAP, FiO2, normocarbia, perfusion; left lateral tilt > 20 wk; (9) Multidisciplinary — anesthesia + surgery + OB + neonatology; (10) Avoid radiation if possible; lead apron; (11) Post-op pain — multimodal opioid-sparing; acetaminophen safe; NSAID 3rd trimester avoid (ductus closure); breastfeeding considerations

---

Non-OB surgery in pregnancy: 2nd trimester safest, regional preferred, RSI for GA, left lateral tilt > 20 wk, modern anesthetics safe, FHR monitor, multidisciplinary. Avoid NSAID 3rd trimester.', NULL,
  'medium', 'obgyn', 'review',
  'anesthesiology', 'clinical_decision', 'obgyn', 'adult',
  'SOAP Non-Obstetric Surgery Pregnancy; ACOG Practice Bulletin', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'ผู้ป่วยหญิง 25 ปี G1P0 GA 26 wk emergency appendectomy
Fetal viability + healthy mom otherwise
NPO 12h, normal labs'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Basic science: ventilation parameters + capnography interpretation', '[{"label":"A","text":"Ignore EtCO2"},{"label":"B","text":"Capnography + ventilation"},{"label":"C","text":"Capnography optional"},{"label":"D","text":"Auscultation alone for intubation"},{"label":"E","text":"Skip during MAC"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Capnography + ventilation: (1) EtCO2 normal 35-45 mmHg (typically 2-5 below PaCO2); reflects ventilation + perfusion + metabolism; (2) Capnogram phases: - Phase I (inspiratory baseline 0); - Phase II (expiratory upstroke); - Phase III (alveolar plateau); - Phase IV (rapid downstroke at inspiration); (3) Normal waveform = rectangular; (4) Abnormal patterns: - Shark-fin (sloping plateau) = bronchospasm/COPD; - Curare cleft (notch) = inadequate paralysis recovery; - Cardiogenic oscillations = cardiac pulsations; - Sudden drop = circuit disconnect, esophageal intubation, cardiac arrest, PE, severe hypotension; - Gradual rise = hypoventilation, increased CO2 production (fever, MH, sepsis, hyperthyroidism); - Gradual decline = hyperventilation, decreased CO2 production (hypothermia, low CO); - Phase I above baseline = rebreathing (exhausted CO2 absorber); - Biphasic plateau = single lung intubation or asymmetric lung disease; (5) Confirming intubation — gold standard (5+ good waveforms); (6) Detecting esophageal intubation immediately; (7) ROSC during CPR — EtCO2 rises rapidly; (8) Quality CPR — EtCO2 > 10-20 mmHg target; (9) MH — early sign rising EtCO2 despite increased ventilation; (10) PE — EtCO2 acute drop with hemodynamic instability; (11) Procedural sedation safety — capnography mandatory for moderate/deep sedation per ASA monitoring standards; detects apnea before SpO2 drops

---

Capnography: gold standard intubation confirm, ventilation + perfusion + metabolism. Patterns: shark-fin (bronchospasm), curare cleft (NMB), sudden drop (disconnect/arrest), rising (MH). Mandatory all anesthesia incl MAC.', NULL,
  'easy', 'respiratory', 'review',
  'anesthesiology', 'basic_science', 'respiratory', 'adult',
  'ASA Standards for Basic Monitoring; APSF', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Basic science: ventilation parameters + capnography interpretation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Basic science: acid-base interpretation + anesthesia implications
ABG: pH 7.20, PaCO2 60, HCO3 22, Base excess -4
On mechanical ventilation', '[{"label":"A","text":"Normal"},{"label":"B","text":"Mixed respiratory acidosis + mild metabolic acidosis"},{"label":"C","text":"Pure metabolic alkalosis"},{"label":"D","text":"No intervention needed"},{"label":"E","text":"Decrease ventilation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mixed respiratory acidosis + mild metabolic acidosis: (1) Approach: - pH 7.20 = acidosis; - PaCO2 60 = respiratory acidosis (expected pH change ~0.08/10 mmHg PaCO2 change; expected pH ~7.40 - 0.16 = 7.24 for pure acute respiratory acidosis); - HCO3 22, BE -4 = mild metabolic component; - Anion gap calculation important; (2) Respiratory acidosis causes: - Hypoventilation (sedation, opioid, NMB residual, central depression); - Increased CO2 production (MH, sepsis, hyperthermia, exhausted soda lime); - Increased dead space (PE, ARDS); - Equipment: circuit disconnect, kinked tube, mucus plug, bronchospasm; (3) Anion gap (Na - Cl - HCO3, normal 8-12) — calculate to identify added acid: - Increased AG: ketoacidosis (DKA, alcohol, starvation), lactic acidosis (sepsis, shock, ischemia), renal failure, toxins (methanol, ethylene glycol, salicylate), large volume saline (hyperchloremic); - Normal AG: GI loss (diarrhea), renal tubular acidosis; (4) Lactic acidosis intra-op causes: - Inadequate perfusion (shock); - Tourniquet release; - Catecholamine excess; - Liver dysfunction; - MH; - Metformin (AKI); (5) Treatment: - Treat underlying cause; - Increase minute ventilation (RR or TV) for respiratory acidosis (PaCO2 down ~5 mmHg per 1 L/min MV increase); - Bicarbonate selectively (pH < 7.0-7.10 + correctible cause); - Restore perfusion; (6) Permissive hypercapnia OK if pH > 7.20 in ARDS / asthma; (7) Stewart approach — strong ion difference (SID), weak acids, PCO2; useful complex cases

---

Mixed respiratory + metabolic acidosis: increase minute ventilation, identify cause (hypoventilation, MH, sepsis, perfusion), calculate AG, treat underlying. Bicarb selective. Permissive hypercapnia OK if pH > 7.20.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'anesthesiology', 'basic_science', 'endocrine_metabolic', 'adult',
  'Stoelting; Miller''s Anesthesia', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'anes_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'anesthesiology'
      and q.scenario = 'Basic science: acid-base interpretation + anesthesia implications
ABG: pH 7.20, PaCO2 60, HCO3 22, Base excess -4
On mechanical ventilation'
  );

commit;

