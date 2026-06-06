-- ===============================================================
-- UPDATE chunk 2/8: surgery (25 questions)
-- ===============================================================

begin;

update public.mcq_questions
set choices = '[{"label":"A","text":"Prolonged NPO + IV fluid loading + bed rest"},{"label":"B","text":"ERAS Pathway for Colorectal Surgery"},{"label":"C","text":"Routine nasogastric tube + 5-day NPO"},{"label":"D","text":"Opioid-based analgesia preferred"},{"label":"E","text":"No exercise until full recovery"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **ERAS Pathway for Colorectal Surgery** (multimodal evidence-based, reduces LOS 30%, complications 30-50%): (1) **Pre-admission**: counseling, smoking + alcohol cessation, anemia + nutrition optimization, prehabilitation; (2) **Pre-op**: avoid prolonged fasting (clear liquids until 2h pre-op, solids until 6h), carbohydrate loading 2h pre-op, no premedication routinely, mechanical + oral antibiotic bowel prep (recent), antibiotic prophylaxis + DVT prophylaxis, skin prep with chlorhexidine; (3) **Intra-op**: minimally invasive approach when possible, normothermia, goal-directed fluid therapy (avoid excess), short-acting anesthetic, multimodal pain (avoid opioid-only), regional block (TAP block, epidural for some), avoid NG tube routine, restrictive transfusion; (4) **Post-op**: early oral diet (immediately or within 24h), early mobilization (within 24h), multimodal analgesia (NSAID + acetaminophen + gabapentin + minimal opioid), DVT prophylaxis continued, glycemic control, remove urinary catheter < 24h, NG tube avoided, ileus prevention (alvimopan in selected); (5) **Audit + improvement** — ERAS compliance correlates with outcomes

---

ERAS = multimodal evidence-based perioperative care pathway. ERAS Society publishes guidelines per specialty. Colorectal ERAS reduces LOS 2-3 days, complications 30-50%, readmissions, costs without compromising safety (Kehlet H, Wilmore DW Ann Surg 2008; ERAS Society Guidelines). Key principles: minimize physiologic stress, restore homeostasis quickly, multidisciplinary + standardized + audited. Compliance with elements correlates with outcomes (>70% compliance = best outcomes). Implementation requires institutional commitment, education, audit.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'Hospital trauma center พบ trauma death สูง — wants to implement Enhanced Recovery After Surgery (ERAS) for elective surgery + Trauma Quality Improvement Program (TQIP)

คำถาม: ERAS pathway สำหรับ colorectal surgery + key components';

update public.mcq_questions
set choices = '[{"label":"A","text":"Single hospital provides all trauma care"},{"label":"B","text":"Trauma System (regionalized)"},{"label":"C","text":"Avoid data collection"},{"label":"D","text":"Each hospital independent — no coordination"},{"label":"E","text":"Only major trauma centers needed"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Trauma System** (regionalized): (1) **Level I** (highest): comprehensive care, research, education, 24h subspecialty coverage, > 1200 trauma admissions/year; (2) **Level II**: comprehensive care, may not have research; (3) **Level III**: ER + ICU + surgical capability, transfer for higher level; (4) **Level IV/V**: stabilize + transfer. **Inclusive trauma system** — all hospitals participate. **Pre-hospital**: triage criteria (CDC field triage), transport to appropriate level. **TQIP/ACS Quality Improvement**: data submission (registry), risk-adjusted outcomes, benchmarking, monthly multidisciplinary morbidity + mortality conferences, root cause analysis. **Key metrics**: mortality (overall, preventable, expected), undertriage/overtriage rates, time to OR, time to CT, time to interventional radiology, blood transfusion ratios, VTE rates, decubitus ulcer, ventilator-associated pneumonia, central line infection, return to OR, readmission. **TQIP benchmarking** shows performance vs comparable centers

---

Trauma system organization → improved outcomes vs non-system care (West JG JAMA 1979, MacKenzie EJ NEJM 2006). ACS-COT criteria for verification (Level I-V). Inclusive system: all hospitals participate at appropriate level. Pre-hospital triage critical. TQIP (Trauma Quality Improvement Program) launched 2010 by ACS — risk-adjusted benchmarking from > 800 centers. Drives quality improvement through transparent comparison + PI cycles. Modern trauma care: damage control, balanced resuscitation, REBOA, multidisciplinary, multimodal monitoring.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'Hospital wants implement Trauma Quality Improvement Program (TQIP) — measure + improve trauma outcomes

คำถาม: Trauma system organization + key quality metrics';

update public.mcq_questions
set choices = '[{"label":"A","text":"Always operate regardless of risk"},{"label":"B","text":"Multidisciplinary frailty + risk-benefit assessment — integrative geriatric + surgical decision-making","difficulty":"hard"},{"label":"C","text":"Always conservative regardless of symptoms"},{"label":"D","text":"Total gastrectomy"},{"label":"E","text":"ERCP only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Multidisciplinary frailty + risk-benefit assessment — integrative geriatric + surgical decision-making: (1) **Frailty assessment** (Clinical Frailty Scale, FRAIL scale, Edmonton Frail Scale) — CFS 6 = moderately frail → significantly increased post-op morbidity/mortality; (2) **Comprehensive Geriatric Assessment** (CGA): medical optimization (HF, CAD, CKD, COPD), cognitive, functional, nutritional, psychosocial; (3) **Shared decision-making** with patient + family: discuss goals of care, life expectancy, quality of life, surgical risk vs ongoing symptom burden, alternative (interval cholecystostomy, lithotripsy controversial, conservative); (4) **Pre-habilitation** if proceeding: exercise, nutrition, smoking cessation, comorbidity optimization 4-6 weeks; (5) **Surgical options**: laparoscopic cholecystectomy preferred (lower morbidity); subtotal cholecystectomy if difficult anatomy; (6) **Anesthesia consult**, ERAS pathway, multimodal analgesia (avoid opioids in elderly), early mobilization; (7) **Post-op**: high-risk admission with cardiology + geriatric co-management; (8) Post-discharge: rehabilitation, medication reconciliation, fall prevention; (9) Some elderly with prohibitive risk + limited life expectancy: leave cholecystostomy long-term or conservative management

---

Frail elderly surgical decision-making = integrative — surgical + medical + geriatric + functional + values. Frailty (CFS ≥ 5) independently predicts post-op morbidity, mortality, LOS, institutionalization. Shared decision-making essential — consider patient values, life expectancy, alternative therapies. Pre-habilitation can reduce risk (multiple RCTs). Comprehensive multidisciplinary care improves outcomes. ACS Geriatric Surgery Verification Program + Strong for Surgery + NSQIP Geriatric promote integrated care. A wrong — risk-benefit individualized. C wrong — symptomatic + low risk surgery acceptable. D-E wrong irrelevant.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'ผู้ป่วยอายุ 78 ปี มีหลายโรค (CAD post-PCI, HFrEF EF 35%, CKD stage 3, COPD GOLD II, frailty CFS 6) มา OPD ด้วย symptomatic gallstone disease — recurrent biliary colic + recent acute cholecystitis ทำ percutaneous cholecystostomy แล้วดีขึ้น ตอนนี้ tube ออกแล้ว pain free 6 weeks

ปรึกษาเรื่อง cholecystectomy';

update public.mcq_questions
set choices = '[{"label":"A","text":"Treat each injury separately by individual specialists"},{"label":"B","text":"Polytrauma Multidisciplinary Integrative Management"},{"label":"C","text":"Operate on all injuries day 1"},{"label":"D","text":"Discharge home with outpatient follow-up"},{"label":"E","text":"Single specialist manages all"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Polytrauma Multidisciplinary Integrative Management** — coordinated by trauma team: (1) **Trauma team leader** coordinates overall care + family communication; (2) **Damage Control Resuscitation** during initial phase: balanced 1:1:1 transfusion, permissive hypotension if no TBI, normothermia, calcium replacement, TXA early; (3) **Damage Control Surgery**: stop hemorrhage + contamination, temporary closure, ICU resuscitation, return for definitive surgery 24-72h; (4) **Specialty consults**: trauma surgery, orthopedics (femur fracture — early total care vs damage control orthopedics depending on physiology), neurosurgery (TBI — ICP monitoring, CPP > 60), vascular (pelvic — angiography + embolization, REBOA in selected); (5) **ICU**: ventilator strategy (low TV, lung protective), sedation + analgesia (ABCDEF bundle), DVT prophylaxis (mechanical until safe for chemical, then start early), nutrition (enteral early), glycemic control, infection surveillance + antibiotic stewardship; (6) **Continuous reassessment** for missed injuries (tertiary survey), compartment syndrome, abdominal compartment syndrome, second hits; (7) **Rehab early**: PT/OT in ICU, mobility protocols; (8) **Psychological support**: PTSD risk, family support, social work; (9) **Discharge planning**: rehabilitation facility, outpatient follow-up multi-specialty; (10) **Long-term outcomes**: functional, vocational, psychological — multidisciplinary follow-up clinic

---

Polytrauma management = quintessentially integrative + multidisciplinary. Modern principles: damage control resuscitation + damage control surgery (Hirshberg, Holcomb), early balanced transfusion (PROPPR), TBI-aware sequencing, lung-protective ventilation, ABCDEF ICU bundle, early mobility + rehab. Coordinated trauma team (surgeon + intensivist + specialty consultants) — single point of accountability. Tertiary survey for missed injuries (5-10% miss rate). Long-term outcomes depend on coordinated care across acute + rehab + outpatient phases. Outcomes 30-40% better in dedicated trauma centers vs general hospital (MacKenzie NEJM 2006).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'ผู้ป่วยอายุ 55 ปี multitrauma post-MVC (motor vehicle crash) — splenic injury Grade IV + femur fracture + closed head injury + pelvic fracture

Day 3 ICU: hemodynamically stable, intubated, requiring blood products + inotropes weaning

คำถาม: multidisciplinary management of polytrauma + key principles';

update public.mcq_questions
set choices = '[{"label":"A","text":"Whipple repeat"},{"label":"B","text":"Recurrent metastatic pancreatic cancer — integrative palliative + oncologic approach"},{"label":"C","text":"Aggressive surgery only"},{"label":"D","text":"Stop all treatment immediately"},{"label":"E","text":"Chemotherapy without palliative care"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Recurrent metastatic pancreatic cancer — integrative palliative + oncologic approach**: (1) **Confirm recurrence**: biopsy of liver lesion if feasible (or peritoneal if accessible) to confirm + characterize; (2) **Multidisciplinary tumor board**: medical oncology + surgical + radiation + palliative; (3) **Systemic therapy** (second-line based on prior FOLFIRINOX + performance status): - **Gemcitabine + nab-paclitaxel** if not used; - **5-FU/leucovorin + nanoliposomal irinotecan** (NAPOLI-1); - **Targeted/precision**: olaparib if BRCA1/2 germline + platinum-responsive (POLO trial); pembrolizumab if MSI-high; (4) **Performance status assessment** ECOG — if 0-1, treat actively; 2 may treat selectively; 3-4 best supportive care; (5) **Concurrent palliative care** from diagnosis (Temel NEJM 2010 — survival + QOL benefit even in pancreatic Ca); (6) **Symptom management**: pain (multimodal analgesic ladder, celiac plexus block consideration), nutrition (PERT for exocrine insufficiency, weight loss), psychological, fatigue, ascites (paracentesis if symptomatic); (7) **Advance care planning**: goals of care discussion, advance directive, healthcare proxy, hospice when appropriate; (8) **Family support**: anticipatory grief, caregiver burden; (9) Survivorship + survivorship care plan if extended survival; (10) Spiritual + cultural support

---

Recurrent pancreatic cancer = integrative cancer + palliative care. Median survival recurrent unresectable PDAC: 6-12 months with second-line. Treatment decisions must balance: prognosis, performance status, comorbidities, patient values, quality of life. Second-line options based on first-line + biomarkers (BRCA, MSI). Concurrent palliative care improves QOL, may extend survival (Temel JCO 2010). Decision-making collaborative — patient + family + multidisciplinary team. Advance care planning essential. Hospice when life expectancy < 6 months + comfort-focused goals. Survivorship for long-term responders.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'ผู้ป่วยอายุ 62 ปี post-Whipple procedure for pancreatic head adenocarcinoma 6 months ago — adjuvant chemotherapy completed mFOLFIRINOX × 12 cycles

Now asymptomatic, CA 19-9 rising 35 → 88 → 142 over 3 visits, CT scan shows new 2 cm hepatic lesion + suspicious peritoneal nodule

คำถาม: management approach for recurrent pancreatic cancer';

update public.mcq_questions
set choices = '[{"label":"A","text":"Chest X-ray portable ก่อนแล้วค่อยตัดสินใจ"},{"label":"B","text":"Tension pneumothorax — immediate needle decompression"},{"label":"C","text":"CT chest urgent"},{"label":"D","text":"Intubate before chest decompression"},{"label":"E","text":"Pericardiocentesis"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Tension pneumothorax — immediate needle decompression** ที่ 5th intercostal space anterior axillary line (ATLS 10th edition update — เดิมคือ 2nd ICS MCL แต่ผนังหน้าอกหนาในผู้ใหญ่ทำให้เข็ม 5 cm ไม่ถึง pleural space ในบางคน) ตามด้วยการใส่ **tube thoracostomy** (chest tube 28-32 Fr) อย่างเร่งด่วน; การวินิจฉัย tension pneumothorax เป็น clinical diagnosis ไม่ต้องรอ CXR (รอ imaging = death); concurrent resuscitation + secure airway

---

Tension pneumothorax เป็น clinical diagnosis — air ใน pleural space ทำให้ mediastinum เคลื่อน, vena cava ถูกกด, venous return ลดลง, obstructive shock เกิดได้เร็ว Classic findings: respiratory distress, tracheal deviation away from affected side, hyperresonance, decreased breath sounds, distended neck veins (อาจ flat ถ้า hypovolemia), hemodynamic compromise ATLS 10th edition: ตำแหน่ง needle decompression สำหรับ adult = 5th ICS anterior axillary line (เข็ม 14G 5 cm) เพราะ chest wall thickness ที่ 2nd ICS MCL อาจมากกว่า 5 cm ใน 30-50% ของคนไข้. ในเด็กยังคงใช้ 2nd ICS MCL. หลัง decompression แล้ว ต้อง tube thoracostomy เสมอ. A ผิด — ห้ามรอ CXR ใน tension pneumothorax. C ผิด — ห้ามส่ง CT. D ผิด — positive pressure ventilation จะทำให้อาการแย่ลงเร็ว ควร decompress ก่อน intubate ถ้าทำได้. E ผิด — ไม่ใช่ pericardial.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'ชายไทยอายุ 24 ปี ขับมอเตอร์ไซค์ชนเสาไฟฟ้า ถูกนำส่ง ER ใส่ collar มา

V/S: BP 92/60, HR 124, RR 28, SpO2 91% room air
Gen: somnolent, GCS E2V3M5 = 10
Neck vein flat
Chest: right side decreased breath sound + hyperresonance + tracheal deviation to left + subcutaneous emphysema
Abdomen: soft, no peritonitis

คำถาม: ขั้นตอนแรกที่ต้องทำคืออะไร';

update public.mcq_questions
set choices = '[{"label":"A","text":"IV fluid bolus 2 liter normal saline"},{"label":"B","text":"Cardiac tamponade — emergent decompression"},{"label":"C","text":"Beta-blocker IV เพื่อลด HR"},{"label":"D","text":"CT chest with contrast ก่อนตัดสินใจ"},{"label":"E","text":"Observation in ICU"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Cardiac tamponade — emergent decompression**: (1) IV fluid bolus to optimize preload (bridge); (2) **Emergent pericardiocentesis** (subxiphoid approach with US guidance) — temporizing; (3) **Definitive: emergent median sternotomy หรือ left anterior thoracotomy** (resuscitative thoracotomy) for traumatic tamponade เพื่อ relieve tamponade + repair cardiac injury; (4) Trauma + CT surgery activation; type & cross 6 units PRC; massive transfusion protocol on standby; (5) Avoid intubation with high PEEP — จะลด venous return ทำให้ shock แย่ลง

---

Cardiac tamponade — Beck''s triad: hypotension + muffled heart sounds + distended neck veins (Kussmaul sign = paradoxical JVD on inspiration). Pulsus paradoxus > 10 mmHg. FAST sensitivity 90-95% สำหรับ pericardial effusion. ในผู้ป่วย penetrating trauma หรือ blunt cardiac injury ที่มี tamponade ต้องเปิด pericardium ทันที — pericardiocentesis อาจช่วยชั่วคราว แต่ definitive คือ thoracotomy/sternotomy. ใน blunt trauma มักจาก cardiac rupture, ใน penetrating จาก stab wound. Resuscitative ED thoracotomy พิจารณาใน penetrating chest trauma with signs of life within 15 min. A เป็น bridge แต่ไม่ definitive. C ผิด — beta-blocker จะทำให้ cardiac output ลด. D ผิด — ห้ามรอ CT. E ผิดอย่างยิ่ง.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'หญิงไทยอายุ 36 ปี รถยนต์ชนต้นไม้ความเร็วสูง คาดเข็มขัดนิรภัย air bag ทำงาน

V/S: BP 78/40, HR 138, RR 26, SpO2 96%
Gen: pale, diaphoretic, JVP elevated, muffled heart sounds, Beck''s triad positive
Chest: clear breath sounds bilaterally
Abdomen: soft

FAST exam: pericardial effusion มาก, RV collapse in diastole';

update public.mcq_questions
set choices = '[{"label":"A","text":"Foley catheterization immediately"},{"label":"B","text":"Unstable open-book pelvic fracture with hemorrhagic shock + urethral injury"},{"label":"C","text":"Definitive ORIF pelvis immediately"},{"label":"D","text":"Observation + serial Hb"},{"label":"E","text":"MRI pelvis"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Unstable open-book pelvic fracture with hemorrhagic shock + urethral injury**: (1) **Pelvic binder** (or circumferential sheet) at level greater trochanters — first-line mechanical stabilization to reduce volume + tamponade; (2) **Resuscitation**: 2 large-bore IV + massive transfusion protocol 1:1:1; (3) **Source of bleeding**: pelvic fracture (FAST negative — abdominal source unlikely); arterial bleed → **angioembolization** (preferred if available); venous/bony bleed → **preperitoneal pelvic packing** + external fixation; (4) **REBOA Zone 3** in extremis as bridge to definitive control; (5) **Suspect urethral injury** (blood at meatus, high-riding prostate) → **retrograde urethrogram (RUG)** before any Foley attempt — DO NOT pass Foley until urethra confirmed intact; suprapubic catheter if needed; (6) Trauma + Ortho + Urology + IR multidisciplinary

---

Open-book pelvic fracture (APC type) — high mortality (20-40%) จาก venous plexus + arterial bleed + soft tissue. Pelvic binder ลด pelvic volume → tamponade + ลดเลือดออก. Source of major hemorrhage: 85% venous/bony, 15% arterial. Hemodynamically unstable + pelvic fracture without intra-abdominal source: arterial bleed suspected → angioembolization. If no IR: preperitoneal pelvic packing + external fixator (รวดเร็ว, control venous + bony). Sequence per WSES guidelines: binder → resuscitate → if FAST positive → laparotomy; if FAST negative + unstable → IR or packing. Urethral injury — blood at meatus / scrotal hematoma / high-riding prostate → RUG ก่อน Foley. A ผิด — Foley before RUG อาจทำให้ urethra injury แย่ลง. C ผิด — definitive surgery รอ stable. D ผิดอย่างยิ่ง. E ผิด — ไม่ใช่ทำเลย.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'ชายไทยอายุ 45 ปี ตกจากที่สูง 4 เมตร ปวดเชิงกรานรุนแรง

V/S: BP 84/52, HR 130, RR 24, GCS 15
Pelvis: instability on compression, hematoma scrotum +, blood at urethral meatus
FAST: negative free fluid abdomen
CXR: clear
Pelvic X-ray: open-book pelvic fracture with > 2.5 cm pubic diastasis

คำถาม: ขั้นตอนต่อไป';

update public.mcq_questions
set choices = '[{"label":"A","text":"Emergency splenectomy"},{"label":"B","text":"Splenic injury grade III + active blush + hemodynamically stable → angioembolization + non-operative management (NOM)"},{"label":"C","text":"Discharge home with outpatient follow-up"},{"label":"D","text":"Total body MRI"},{"label":"E","text":"Diagnostic laparoscopy"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Splenic injury grade III + active blush + hemodynamically stable → angioembolization + non-operative management (NOM)**: (1) ICU admission + serial abdominal exam + serial Hb q4-6h × 24-48h; (2) **Splenic artery angioembolization (SAE)** for active blush (contrast extravasation) — proximal embolization for grade IV-V; distal/selective for focal pseudoaneurysm; improves NOM success rate (90% with SAE vs 60% without in grade III-IV); (3) NPO initially, bedrest 24-48h; (4) Vaccination prophylaxis NOT needed unless splenectomy; (5) Failure criteria → hemodynamic instability, ongoing transfusion > 2 units/24h, peritonitis → laparotomy + splenectomy/splenorrhaphy; (6) Activity restriction 6-8 weeks post-discharge

---

Blunt splenic injury — AAST grading I-V. NOM success rate decreases with grade: I-II ~95%, III ~80%, IV-V ~50-70%. SAE เพิ่ม NOM success rate ใน grade III-V + contrast blush. Indications สำหรับ angioembolization (WSES + EAST): contrast extravasation, pseudoaneurysm, AV fistula, grade IV-V even without blush in selected centers. Hemodynamically unstable + splenic injury = laparotomy. ผู้ป่วยรายนี้ stable + grade III + blush → ideal for SAE-NOM. Post-splenectomy vaccinations (S. pneumoniae, H. influenzae, N. meningitidis) ถ้าตัดม้าม. A ผิด — stable + NOM candidate. C ผิดอย่างยิ่ง. D ผิด — CT done. E ผิด — no indication.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'ชายไทยอายุ 28 ปี ขับรถยนต์ชนกับรถกระบะ ใช้เข็มขัดนิรภัย ไม่มีอาการขณะรับรู้

V/S: BP 124/78, HR 88, RR 16, GCS 15, room air SpO2 99%
Abdomen: tender LUQ, no peritonitis, no bruising
FAST: small free fluid Morrison''s pouch
CT abdomen: splenic laceration grade III with active blush + free fluid moderate amount; no other injury

Hb 11.8 g/dL stable

คำถาม: management';

update public.mcq_questions
set choices = '[{"label":"A","text":"Observation + IV antibiotic 24 hours"},{"label":"B","text":"Perforated viscus with generalized peritonitis — emergent exploratory laparotomy"},{"label":"C","text":"Endoscopy + clip closure"},{"label":"D","text":"Conservative non-operative management (Taylor approach) for all"},{"label":"E","text":"CT abdomen ก่อนแล้วค่อยตัดสินใจ"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Perforated viscus with generalized peritonitis — emergent exploratory laparotomy**: (1) **Pre-op resuscitation**: 2 large-bore IV, IV fluid 1-2 L crystalloid, type & cross, foley + NG decompression, IV broad-spectrum antibiotic (e.g., piperacillin-tazobactam OR ceftriaxone + metronidazole); (2) **Source identification**: PUD perforation most common (60-70%) — duodenal > gastric; ตำแหน่งอื่น: appendix, sigmoid (diverticulitis, cancer), small bowel; (3) **Operative repair**: PUD perforation < 2 cm → Graham omental patch + biopsy + H. pylori workup; large perforation → Billroth I/II or vagotomy/antrectomy (rarely needed now); ล้างช่องท้องด้วย NSS; place drain; (4) **Postop**: continue antibiotic 5-7 days, PPI long-term, H. pylori eradication, ICU monitoring; (5) Laparoscopic approach if surgeon experienced + stable

---

Free air under diaphragm + peritonitis = perforated viscus = emergent surgery. Causes: PUD (60-70%), appendiceal perforation, diverticulitis perforation, colon cancer perforation, traumatic, iatrogenic, ischemic. Mortality of perforated PUD: 5-15%, higher in elderly + delayed presentation. Graham omental patch — pedicled omentum on perforation + interrupted sutures. Boey score predicts mortality: shock, comorbidity, delayed presentation > 24h. Taylor non-operative approach (NG suction, antibiotics, PPI, NPO) considered ONLY in selected stable patients with sealed perforation on Gastrografin — rarely first-line. CT useful if diagnosis unclear แต่ patient ที่ peritonitis + free air ชัด ไม่ต้องรอ CT. A ผิด — peritonitis + free air ต้องผ่า. C ผิด — perforation > endoscopic. D ผิด — selected only. E controversial แต่ถ้า diagnosis ชัด ไม่จำเป็น.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'หญิงไทยอายุ 62 ปี underlying COPD GOLD C มาด้วยอาการปวดท้องรุนแรงทันทีทันใด มา 3 ชั่วโมง ปวดทั้งท้อง ไม่ผ่ายลม ไม่ถ่าย

V/S: BP 102/68, HR 116, RR 24, Temp 38.4°C
Abdomen: rigid abdomen, generalized rebound tenderness, absent bowel sound

Upright CXR: free air under bilateral diaphragm
Lab: WBC 18,400, Lactate 3.6

คำถาม: management';

update public.mcq_questions
set choices = '[{"label":"A","text":"Observation + IV antibiotic + bowel rest"},{"label":"B","text":"Acute mesenteric ischemia (AMI) — SMA embolism (likely cardioembolic from AF)"},{"label":"C","text":"Stat angiogram only without intervention"},{"label":"D","text":"Heparin infusion alone without revascularization"},{"label":"E","text":"Diagnostic peritoneal lavage"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Acute mesenteric ischemia (AMI) — SMA embolism (likely cardioembolic from AF)**: (1) **Immediate resuscitation** + IV broad-spectrum antibiotic (e.g., piperacillin-tazobactam — covers bowel translocation); (2) **Therapeutic anticoagulation** (heparin IV) once decision-made; (3) **Vascular intervention**: **endovascular thrombectomy/thrombolysis** (catheter-directed) if no peritonitis + viable bowel — first-line in modern era OR **open SMA embolectomy via laparotomy**; (4) **Exploratory laparotomy** if peritonitis, pneumatosis with full-thickness necrosis suspected — **assess bowel viability** → resect non-viable bowel + **second-look laparotomy 24-48h** if uncertain; (5) Avoid vasopressors that constrict splanchnic flow (norepi preferred ถ้าจำเป็น); (6) Mortality 60-80% — early diagnosis + revascularization critical

---

Acute Mesenteric Ischemia (AMI) — high mortality (60-80%) จาก delayed diagnosis. Etiology: 1) **Arterial embolism** 50% (AF, MI, valve dz — SMA most common embolic destination) 2) **Arterial thrombosis** 25% (atherosclerosis at SMA origin) 3) **Non-occlusive mesenteric ischemia (NOMI)** 20% (low flow, vasoconstriction — shock, vasopressors, dialysis) 4) **Mesenteric venous thrombosis** 5% (hypercoagulable). Classic: ''pain out of proportion to physical findings'' + AF/atherosclerosis. CT angiography is diagnostic gold standard. Pneumatosis intestinalis + portal venous gas = late sign with high mortality. Modern management trend: endovascular-first (thrombectomy ± stenting) for arterial occlusion without peritonitis. Open surgery if peritonitis OR endovascular failure. Damage control + second-look. A ผิด — observation = death. C ผิด — diagnostic only ไม่พอ. D ผิด — heparin alone ไม่พอ. E ผิดล้าสมัย.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'ชายไทยอายุ 72 ปี atrial fibrillation on warfarin (INR 2.4) มาด้วยปวดท้องรุนแรง 6 ชั่วโมง ปวดทั้งท้องไม่ระบุตำแหน่ง pain out of proportion to exam findings

V/S: BP 128/76, HR 116 irregular, RR 22, Temp 36.8°C
Abdomen: soft, mild tenderness diffuse, no peritonitis, bowel sound active

Lab: WBC 16,800, Lactate 4.8, BE -8, Cr 1.6, LDH 480
CT abdomen with IV contrast: SMA occlusion + bowel wall thickening + pneumatosis intestinalis at jejunum';

update public.mcq_questions
set choices = '[{"label":"A","text":"Emergency Hartmann''s procedure"},{"label":"B","text":"Hinchey II diverticulitis (pericolic abscess > 3-4 cm)"},{"label":"C","text":"Antibiotic alone without drainage"},{"label":"D","text":"Discharge home with oral antibiotics"},{"label":"E","text":"Diverting colostomy"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Hinchey II diverticulitis (pericolic abscess > 3-4 cm)**: (1) **Percutaneous CT-guided drainage** of abscess (IR) + IV broad-spectrum antibiotics (ceftriaxone + metronidazole or piperacillin-tazobactam) × 10-14 days; (2) NPO → clear liquid → low residue as tolerated; (3) Repeat imaging if not improving in 48-72h; (4) **Interval consideration of elective resection 6-8 weeks** post-recovery — current evidence (DIABOLO + others) shows elective sigmoidectomy NOT mandatory after single uncomplicated episode; consider in patients with complicated diverticulitis (abscess, fistula, stricture), immunocompromised, recurrent attacks, persistent symptoms — individualized; (5) Colonoscopy 6-8 weeks post-attack to exclude malignancy (controversial in mild cases per Cochrane); (6) Lifestyle: high-fiber diet, hydration

---

Hinchey classification of complicated diverticulitis: I) pericolic abscess (< 4 cm), II) pelvic/distant abscess (> 4 cm), III) purulent peritonitis, IV) fecal peritonitis. Management: - **Uncomplicated (Hinchey 0-Ia)**: outpatient antibiotics OR observation alone in selected cases (DIABOLO trial — antibiotic non-inferior to observation in uncomplicated) - **Hinchey I (< 3-4 cm)**: IV antibiotic alone usually adequate - **Hinchey II (> 4 cm)**: percutaneous drainage + IV antibiotic - **Hinchey III**: laparoscopic lavage (controversial — Ladies/SCANDIV trials mixed) OR sigmoidectomy with primary anastomosis ± diverting loop ileostomy (modern preferred over Hartmann''s in selected) - **Hinchey IV (fecal peritonitis)**: emergent Hartmann''s OR primary anastomosis with diversion in selected stable patients Elective sigmoidectomy after recovery — individualized, not for all single episodes. A ผิด — emergency Hartmann''s สำหรับ Hinchey III-IV. C ผิด — abscess > 3-4 cm ต้อง drain. D ผิด — รุนแรงเกิน outpatient. E ผิด — ไม่มี indication.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'หญิงไทยอายุ 78 ปี มา ED ด้วยอาการปวดท้องน้อยซ้าย 3 วัน ไข้ ปวดเวลาถ่าย ถ่ายลำบาก

V/S: BP 132/82, HR 96, RR 18, Temp 38.6°C
Abdomen: tenderness LLQ + palpable mass + guarding localized, no generalized peritonitis

Lab: WBC 15,200, CRP 142
CT abdomen: sigmoid diverticulitis + pericolic abscess 4.5 cm, no free air, no generalized peritonitis (Hinchey II)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Emergent exploratory laparotomy"},{"label":"B","text":"Adhesive small bowel obstruction (ASBO), uncomplicated → conservative management trial"},{"label":"C","text":"Discharge home with oral antibiotic"},{"label":"D","text":"Colonoscopy"},{"label":"E","text":"Sigmoid decompression tube"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Adhesive small bowel obstruction (ASBO), uncomplicated → conservative management trial**: (1) **NPO + NG decompression**; (2) **IV fluid + electrolyte correction** (K, Cl losses common); (3) **Serial abdominal exam** + serial labs (WBC, lactate); (4) **Water-soluble contrast challenge (Gastrografin)** — both diagnostic + therapeutic: contrast reaching colon within 24h = predictive of resolution + may itself promote passage (osmotic effect); 75% resolve with conservative trial; (5) **Surgery indicated** if: peritonitis, ischemia/strangulation suspected (fever, leukocytosis, lactate, CT signs — closed loop, pneumatosis, mesenteric edema), failure of conservative trial 48-72h, no transit on contrast study; (6) Surgical options: laparoscopic adhesiolysis (selected) vs open; address etiology; (7) **Prevention**: adhesion barrier (e.g., hyaluronic acid) at index surgery

---

Adhesive SBO — most common cause of SBO in adults (60-75%). Conservative management resolves 70-80% of uncomplicated ASBO. **Bologna Guidelines (WSES) + ASBO management**: 1. Initial: NPO, NG, IV fluid, electrolyte correction 2. Identify warning signs of strangulation: fever, tachycardia, focal tenderness, lactate, WBC, CT signs (closed loop, mesenteric edema, pneumatosis, free fluid, lack of bowel wall enhancement) 3. Gastrografin challenge: 100 mL via NG, follow-up X-ray at 24h — if contrast in colon, predicts resolution + may aid passage 4. Trial 48-72h max; longer trial increases ischemia risk 5. Surgical indication: failed conservative, suspected ischemia, complete obstruction without resolution, closed loop, virgin abdomen (high malignancy risk) Strangulation = surgical emergency. A ผิด — no strangulation signs. C ผิดอย่างยิ่ง. D ผิด — small bowel not colon. E ผิด — for volvulus.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'ชายไทยอายุ 58 ปี มาด้วยอาเจียน 5 ครั้ง 24 ชั่วโมง ท้องอืด ไม่ผ่ายลม ไม่ถ่าย previous appendectomy 10 ปีก่อน

V/S: BP 118/76, HR 102, RR 18, Temp 37.2°C
Abdomen: distended, high-pitched bowel sound, tender diffuse, no peritonitis, no hernia

Upright X-ray: multiple air-fluid levels + dilated small bowel loops + no free air
CT abdomen: small bowel obstruction with transition point at right lower quadrant + adhesion suspected; no closed loop, no pneumatosis, no fat stranding

คำถาม: initial management';

update public.mcq_questions
set choices = '[{"label":"A","text":"Emergency sigmoidectomy"},{"label":"B","text":"Sigmoid volvulus without ischemia → endoscopic detorsion first"},{"label":"C","text":"Observation + bowel rest only"},{"label":"D","text":"Barium enema"},{"label":"E","text":"Discharge with laxatives"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Sigmoid volvulus without ischemia → endoscopic detorsion first**: (1) **Flexible sigmoidoscopy / colonoscopy decompression + rectal tube placement** — successful in 70-90% of cases without ischemia; assess viability of mucosa during scope; (2) **NG decompression**, IV fluid, electrolyte correction; (3) **Sentinel sigmoidectomy during same admission** (within 2-7 days) after detorsion — recurrence rate ~50-90% if not resected; one-stage sigmoidectomy with primary anastomosis preferred; (4) **Emergent surgery** if: failed endoscopic detorsion, signs of ischemia/gangrene (peritonitis, mucosal necrosis on scope, fever, lactate), perforation → Hartmann''s procedure or sigmoidectomy with primary anastomosis ± diverting stoma; (5) Post-recovery: nutrition, mobility, bowel regimen

---

Sigmoid volvulus — common in elderly, institutionalized, chronic constipation, neurogenic. Coffee bean / omega sign on X-ray; whirl sign on CT. Management: 1. **No ischemia + stable**: endoscopic detorsion successful 70-90%; rectal tube placement post-detorsion 2. **Definitive**: sigmoidectomy ภายใน same admission — recurrence > 50% if not resected 3. **Ischemia / failed endoscopic / perforation**: emergent surgery — Hartmann''s (classic) OR sigmoidectomy + primary anastomosis ± diverting stoma per surgeon judgment + patient status Cecal volvulus (different): NOT amenable to endoscopic detorsion typically; emergent right hemicolectomy. A ผิด — รุนแรงเกินไป first-line, แต่ definitive needed. C ผิด — รอจะเกิด ischemia. D ผิด — เก่า + ไม่ therapeutic. E ผิดอย่างยิ่ง.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'ชายไทยอายุ 68 ปี ปวดท้องน้อยซ้าย ท้องอืดมาก 5 วัน ไม่ผ่ายลม no flatus

V/S: BP 142/86, HR 96, RR 20, Temp 37.0°C
Abdomen: massive distention, asymmetric, no peritonitis

Abdominal X-ray: ''coffee bean'' sign / ''omega loop'' centred to RUQ
CT abdomen: sigmoid volvulus with whirl sign + dilated loop without bowel wall ischemia signs';

update public.mcq_questions
set choices = '[{"label":"A","text":"Immediate cholecystectomy"},{"label":"B","text":"Acute cholangitis with Reynolds'' pentad — severe (Tokyo Grade III)"},{"label":"C","text":"Antibiotic alone × 7 days, no procedure"},{"label":"D","text":"Open CBD exploration immediately"},{"label":"E","text":"Endoscopic ultrasound only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Acute cholangitis with Reynolds'' pentad — severe (Tokyo Grade III)**: (1) **Resuscitation**: IV crystalloid bolus, vasopressors as needed for septic shock; (2) **IV broad-spectrum antibiotic** ASAP (within 1 hr of recognition) — piperacillin-tazobactam OR meropenem + cover ESBL/anaerobes given severity; (3) **Urgent biliary decompression within 24h** — **ERCP with sphincterotomy + stone extraction + biliary stent** (preferred — therapeutic); alternative if ERCP failed/unavailable: **PTC (percutaneous transhepatic cholangiogram + drain)** or open biliary decompression as last resort; (4) ICU monitoring; (5) **Cholecystectomy delayed** until cholangitis resolved (typically 4-6 weeks) — gallstone source; same admission cholecystectomy if mild-moderate cholangitis post-ERCP, delayed if severe

---

Acute cholangitis (ascending cholangitis) — biliary tract infection from obstruction (stones > stricture > malignancy). **Charcot''s triad**: fever + RUQ pain + jaundice (50-70% present) **Reynolds'' pentad**: + hypotension + altered mental status (severe/suppurative). Tokyo Guidelines 2018 grading: - **Grade I (mild)**: no organ dysfunction, responds to antibiotics, no urgent drainage needed - **Grade II (moderate)**: 2+ of (WBC > 12k or < 4k, fever > 39, age > 75, hyperbili > 5, hypoalbumin < 0.7x LL) - **Grade III (severe)**: organ dysfunction (CV, neuro, resp, renal, hepatic, hematologic) — **urgent drainage required** Treatment principles: 1. Antibiotics (within 1 hr): broad-spectrum covering gram-neg + anaerobes; piperacillin-tazobactam, meropenem in severe 2. Biliary decompression timing: - Grade I: elective or within 24-48h if not improving - Grade II: early (within 24-48h) - Grade III: urgent (within 24h) 3. ERCP preferred — therapeutic + diagnostic 4. Cholecystectomy delayed until cholangitis resolved A ผิด — cholecystectomy โดยไม่ decompress = mortality. C ผิด — drainage essential. D ผิด — open last resort. E ผิด — EUS diagnostic only.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'หญิงไทยอายุ 56 ปี underlying gallstones มา ED ด้วยปวด RUQ severe 12 ชั่วโมง ไข้สูง หนาวสั่น ตัวเหลืองตาเหลือง confusion mild

V/S: BP 92/58, HR 124, RR 22, Temp 39.4°C
Abdomen: tender RUQ, Murphy''s + , no peritonitis generalized

Lab: WBC 22,000, Total bili 6.8, Direct bili 5.2, ALP 480, GGT 320, AST 188, ALT 142, Cr 1.7
US: gallbladder distention + sludge + CBD dilatation 12 mm + intrahepatic duct dilatation
MRCP pending

คำถาม: most appropriate next step';

update public.mcq_questions
set choices = '[{"label":"A","text":"Immediate necrosectomy day 1"},{"label":"B","text":"Severe acute pancreatitis (predicted by APACHE-II, BISAP, modified Marshall) with sterile necrosis — multidisciplinary critical care management"},{"label":"C","text":"Routine prophylactic antibiotic infusion 14 days"},{"label":"D","text":"TPN only, no enteral feeding"},{"label":"E","text":"ERCP for all severe pancreatitis"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Severe acute pancreatitis (predicted by APACHE-II, BISAP, modified Marshall) with sterile necrosis — multidisciplinary critical care management**: (1) **Aggressive but goal-directed IV fluid** (Ringer lactate, target UO 0.5 ml/kg/hr, MAP > 65, Hct 35-44; avoid over-resuscitation — increases organ failure); recent trend: moderate fluid resuscitation per WATERFALL trial 2022 (aggressive worsens outcomes); (2) **ICU admission** for organ support — ventilator, vasopressor, CRRT as needed; (3) **Enteral nutrition early** (NG/NJ within 24-72h) — better than TPN (reduces infection, mortality); (4) **No prophylactic antibiotic** in sterile necrosis (no mortality benefit, increases fungal/resistant infections — current evidence); (5) **Pain control**, **PPI**, **DVT prophylaxis**; (6) **Treat underlying cause** — gallstone → urgent ERCP if cholangitis or persistent obstruction; alcohol → cessation + thiamine; (7) **Necrosis intervention indication**: infected necrosis suspected (clinical decline, gas in necrosis, positive FNA) — **delay 4 weeks** if possible for walled-off necrosis (WON), then **step-up approach** per PANTER trial: percutaneous drainage → endoscopic/MIS necrosectomy if not resolved → open necrosectomy last resort

---

Acute pancreatitis severity assessment: **Atlanta Classification 2012**: - Mild: no organ failure, no complications - Moderately severe: transient organ failure < 48h OR local/systemic complications - Severe: persistent organ failure > 48h **Scoring**: Ranson, APACHE-II, BISAP (5 variables, simple), Marshall (modified) Etiology: GET SMASHED — Gallstones (40%), Ethanol (30%), Trauma, Steroids, Mumps, Autoimmune, Scorpion, Hypertriglyceridemia/Hypercalcemia, ERCP, Drugs Key evidence-based management updates: 1. **Fluid resuscitation**: WATERFALL trial (NEJM 2022) — moderate (Ringer 1.5 mL/kg/h) BETTER than aggressive (3 mL/kg/h + bolus) re: organ failure, persistent SIRS 2. **Nutrition**: Early enteral (NJ ดีกว่า NG controversial — but both OK) > TPN — reduces infectious complications, organ failure 3. **Antibiotics**: NOT prophylactic in sterile necrosis. Use only for documented infection 4. **Necrosis intervention**: PANTER trial (NEJM 2010) — step-up approach (percutaneous drainage → minimally invasive necrosectomy) better than open. Delay until walled-off (4+ weeks) for elective 5. **ERCP** in pancreatitis: indicated for gallstone pancreatitis + cholangitis OR persistent obstruction; NOT for all severe A ผิด — delay 4 weeks for WON. C ผิด — no prophylactic abx. D ผิด — enteral preferred. E ผิด — selected only.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'ชายไทยอายุ 48 ปี ดื่มแอลกอฮอล์หนัก ปวดท้องรุนแรงตรงกลางท้อง 24 ชั่วโมง ปวดร้าวไปหลัง คลื่นไส้อาเจียน

V/S: BP 96/64, HR 124, RR 28, Temp 38.4°C, SpO2 92% room air
Abdomen: tender epigastric, distended, decreased bowel sound

Lab: WBC 19,200, Lipase 3,200 (normal < 60), Glucose 220, Ca 7.6, BUN 32, Cr 1.8, LDH 480, AST 220, Hct 48
ABG: pH 7.30, PaO2 64, HCO3 18
CT abdomen with contrast (day 3): pancreatic necrosis 40% + peripancreatic fluid collection + no infection signs';

update public.mcq_questions
set choices = '[{"label":"A","text":"Sorafenib alone"},{"label":"B","text":"HCC stage Barcelona Clinic Liver Cancer (BCLC) A — single nodule, preserved liver function, no portal HTN"},{"label":"C","text":"TACE only"},{"label":"D","text":"Observation"},{"label":"E","text":"Whipple procedure"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **HCC stage Barcelona Clinic Liver Cancer (BCLC) A — single nodule, preserved liver function, no portal HTN**: best candidate for **curative therapy**: (1) **Surgical resection** = first-line if: no significant portal HTN (HVPG < 10), preserved function (Child A), feasible anatomical resection with adequate remnant; this patient meets criteria — segmentectomy/lobectomy of segment VI; (2) **Alternatives**: - **Liver transplantation** if within Milan criteria (1 lesion ≤ 5 cm OR 2-3 lesions each ≤ 3 cm, no extrahepatic, no vascular invasion) — particularly if Child B/C or significant portal HTN; - **Ablation (RFA/MWA)** for tumors ≤ 3 cm — comparable to resection in small HCC, less invasive; (3) **Adjuvant therapy**: no proven adjuvant therapy post-resection (atezolizumab + bevacizumab in adjuvant trial IMbrave050 ongoing); (4) **Surveillance**: AFP + imaging q3 mo × 2 yr then q6 mo; (5) **Treat underlying HBV** — antiviral (entecavir or tenofovir) lifelong

---

HCC management (BCLC staging — primary algorithm): - **BCLC 0 (very early)**: single ≤ 2 cm, Child A, PS 0 — resection or ablation - **BCLC A (early)**: single OR up to 3 nodules ≤ 3 cm, Child A-B, PS 0 — resection / transplant / ablation - **BCLC B (intermediate)**: multinodular, Child A-B, PS 0 — TACE - **BCLC C (advanced)**: portal vein invasion, extrahepatic spread, Child A-B, PS 1-2 — systemic therapy (atezolizumab + bevacizumab first-line per IMbrave150; alternatives: durvalumab + tremelimumab, lenvatinib, sorafenib) - **BCLC D (terminal)**: Child C, PS 3-4 — best supportive care **Milan criteria** (transplant): 1 lesion ≤ 5 cm OR 2-3 lesions each ≤ 3 cm + no vascular invasion + no extrahepatic — 5-yr survival 70-75% Patient: BCLC A (4.5 cm single, Child A, no portal HTN, no extrahepatic) — resection candidate; transplant alternative; ablation > 3 cm less optimal. A ผิด — sorafenib BCLC C. C ผิด — TACE BCLC B. D ผิดอย่างยิ่ง. E ผิด — HCC not pancreas.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'ชายไทยอายุ 60 ปี ติด HBV chronic 30 ปี cirrhosis Child-Pugh A เคยตรวจ AFP > 400 ng/mL

CT 4-phase liver: 4.5 cm enhancing mass at segment VI with arterial hyperenhancement + washout in portal venous + delayed phases (LI-RADS 5)

No extrahepatic disease, no portal vein thrombosis
Bilirubin 1.0, INR 1.1, Albumin 3.8, no ascites, no encephalopathy
MELD 7

คำถาม: management';

update public.mcq_questions
set choices = '[{"label":"A","text":"Palliative surgery alone, no chemotherapy"},{"label":"B","text":"Stage IV colorectal cancer with potentially resectable liver metastases (oligometastatic)"},{"label":"C","text":"Sigmoid resection only without addressing liver"},{"label":"D","text":"Chemotherapy alone, no surgery"},{"label":"E","text":"Radiation only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Stage IV colorectal cancer with potentially resectable liver metastases (oligometastatic)**: multidisciplinary tumor board: (1) **Restaging + assessment of resectability** — MRI liver, PET-CT to rule out other metastases, hepatobiliary surgery consultation; (2) **Genetic profiling** done — KRAS/NRAS/BRAF wild-type + MSS → candidate for anti-EGFR (cetuximab/panitumumab) **left-sided primary** with chemo (FOLFOX or FOLFIRI + anti-EGFR — preferred in left-sided RAS WT per CALGB/SWOG 80405); (3) **Approach options**: a) **Synchronous resection** (primary + liver met) if low-volume + technically feasible + good surgical team; b) **Staged**: primary first then liver (classic) OR **liver-first (reverse)** in selected — particularly large liver disease with at-risk primary; c) **Perioperative chemotherapy** (3 mo neoadjuvant + 3 mo adjuvant per EPOC trial) before resection if resectable but high risk; (4) **Locally advanced primary**: consider neoadjuvant chemo + adjuvant; (5) **Adjuvant chemo** for 6 mo total perioperative; (6) **Surveillance**: CEA + imaging q3-6 mo × 2 yr then q6 mo; (7) Genetic counseling (Lynch syndrome MSI testing done — stable)

---

Stage IV CRC with oligometastatic liver disease — 20-30% of stage IV potentially curable. Multidisciplinary critical. **Resectability of liver mets**: anatomical (preserve adequate remnant function, vascular margin) > number/size. Modern era: aggressive approach including major hepatectomy, two-stage hepatectomy, ALPPS, portal vein embolization. **Sidedness** matters: - Left-sided primary (splenic flexure-rectum): better prognosis; RAS WT → anti-EGFR effective - Right-sided primary (cecum-transverse): poorer; RAS WT → anti-VEGF (bevacizumab) preferred over EGFR **Sequencing options for resectable mCRC**: 1. Synchronous resection — selected (limited mets, experienced center) 2. Staged primary-first → adjuvant → liver — classic 3. Liver-first (reverse) — large/symptomatic mets, asymptomatic primary 4. Perioperative chemo (FOLFOX 3+3 months per EPOC) — high-risk **Adjuvant systemic therapy**: backbone FOLFOX or FOLFIRI; biologics by RAS/sidedness; total 6 months perioperative **Surveillance**: CEA, CT, colonoscopy A ผิด — palliative สำหรับ unresectable. C ผิด — ต้องดูแล liver mets ด้วย. D ผิด — primary obstruction. E ผิด — RT ไม่ใช่ first-line สำหรับ sigmoid.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'หญิงไทยอายุ 62 ปี มาด้วยอาการเลือดออกทางทวารหนัก 3 เดือน + น้ำหนักลด 5 กิโลกรัม + ท้องอืด ท้องผูกสลับท้องเสีย

Colonoscopy: circumferential mass at sigmoid 25 cm from anal verge, biopsy = moderately differentiated adenocarcinoma
CT chest/abdomen/pelvis: 4 cm sigmoid mass + perirectal stranding + 3 enlarged regional LNs + 2 liver lesions (1.8 cm and 1.2 cm) suspicious metastatic; no lung disease
CEA 12.4

Molecular: KRAS wild-type, NRAS wild-type, BRAF wild-type, MSI-stable';

update public.mcq_questions
set choices = '[{"label":"A","text":"CT abdomen with IV contrast"},{"label":"B","text":"Suspected acute appendicitis in pregnancy, US non-diagnostic → MRI abdomen without gadolinium"},{"label":"C","text":"Observation 24 hr without imaging"},{"label":"D","text":"Conservative antibiotic only, no surgery"},{"label":"E","text":"Cesarean delivery + appendectomy together"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Suspected acute appendicitis in pregnancy, US non-diagnostic → MRI abdomen without gadolinium** (no radiation, no contrast, sensitivity > 90% for appendicitis in pregnancy); if MRI confirms or strongly suggests appendicitis → **proceed to appendectomy** (laparoscopic preferred in 1st-2nd trimester; open feasible in 3rd trimester depending on surgeon preference + body habitus); (1) **Perioperative**: continuous fetal monitoring (≥ 24 wk), left lateral tilt to avoid IVC compression, OB consultation; (2) **Tocolysis** prophylactic NOT recommended; treat preterm contractions if occur; (3) **Antibiotic**: pregnancy-safe (cefoxitin, ampicillin-sulbactam, or cefazolin + metronidazole as per appendix status) prophylactic single dose, continue if perforation; (4) **Avoid CT** if alternative imaging (MRI) available — minimize fetal radiation; (5) Negative appendectomy rate higher in pregnancy (20-30%) but missed appendicitis = perforation = 35% fetal loss → low threshold to operate; (6) Postoperative VTE prophylaxis + fetal surveillance

---

Appendicitis in pregnancy — most common non-OB surgical emergency (1:1,500 pregnancies). Diagnosis challenging — appendix migrates upward + lateral as pregnancy advances. Classic Alvarado less reliable. WBC physiologically elevated. **Imaging in pregnancy**: 1. **Ultrasound** — first-line, but sensitivity drops as pregnancy advances (limited visualization 3rd trimester) 2. **MRI without gadolinium** — preferred next; sensitivity > 90%, specificity > 95%; safe in pregnancy (gadolinium AVOID — crosses placenta) 3. **CT** — reserved if MRI unavailable; fetal radiation < 5 mSv per CT abdomen pelvis is below teratogenic threshold but minimize **Surgical approach**: - Laparoscopic appendectomy safe in 1st-2nd trimester, feasible in 3rd (depends on uterus size) - Lower CO2 pressure (10-12 mmHg) - Left lateral tilt to avoid aortocaval compression - Trocar placement adjusted for gravid uterus **Risks**: - Negative appendectomy 20-30% (acceptable to avoid missed dx) - Perforation → 35% fetal loss; non-perforated 5% - Maternal mortality < 1% **Antibiotic**: pregnancy-safe; cefazolin, ampicillin-sulbactam, cefoxitin OK; tetracycline + fluoroquinolone avoid A ผิด — CT avoid if MRI available. C ผิด — high stakes ต้อง diagnose. D ผิด — controversial in pregnancy, surgical safer. E ผิด — ไม่มี indication delivery 28 wk.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'หญิงไทยอายุ 32 ปี G2P1 อายุครรภ์ 28 สัปดาห์ มา ED ด้วยอาการปวดท้องน้อยขวา 18 ชั่วโมง คลื่นไส้อาเจียน

V/S: BP 118/72, HR 98, RR 18, Temp 38.0°C
Abdomen: tenderness at right flank — appendix displaced superiorly + laterally per pregnancy; rebound mild
Fetal HR 142 bpm regular

Lab: WBC 16,800 (normal in pregnancy 6-16k), CRP 88, urinalysis normal
US abdomen: appendix not well visualized due to gravid uterus, mild free fluid RLQ

คำถาม: next step';

update public.mcq_questions
set choices = '[{"label":"A","text":"Lactate Ringer 4 mL/kg/%TBSA × 24h start"},{"label":"B","text":"Severe burn 49.5% TBSA + suspected inhalational injury — comprehensive resuscitation"},{"label":"C","text":"Oral hydration + outpatient"},{"label":"D","text":"Surgery immediate full debridement day 1"},{"label":"E","text":"Steroid IV high dose for inhalational"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Severe burn 49.5% TBSA + suspected inhalational injury — comprehensive resuscitation**: (1) **Airway**: signs of inhalational injury (singed nasal hair, soot, hoarse voice, facial burn, closed-space fire) → **early intubation** before edema obstructs airway — do NOT wait; bronchoscopy to assess; carboxyhemoglobin level (CO poisoning) — 100% O2; HCN poisoning (close-space fire) → hydroxocobalamin; (2) **Fluid resuscitation Parkland formula**: 4 mL × 70 kg × 49.5% = **13,860 mL Lactated Ringer''s over 24h** — first half (6,930 mL) over 8h from BURN time (not arrival), second half over 16h; adjust to UO 0.5 mL/kg/hr (30-50 mL/hr adult); recent trend toward lower volume to avoid ''fluid creep'' — start 2 mL/kg/%TBSA in mod severity, 4 mL/kg/%TBSA in severe + inhalation; (3) **Tetanus prophylaxis**; (4) **Wound care**: cool burn wounds with room-temp NSS-soaked gauze (NOT ice), debride loose epidermis, topical silver sulfadiazine or silver dressings; **escharotomy** for circumferential full-thickness burns (limbs, chest) — vascular/respiratory compromise; (5) **Pain control**: IV opioids; (6) **Nutrition**: early enteral high-protein high-calorie (3000-4000 kcal/day); (7) **Transfer to burn center** if > 10% TBSA + inhalation OR > 20% TBSA OR major burn (face, hands, feet, genitalia, joints); (8) ICU monitoring

---

Major burn management — ABA criteria: > 10% TBSA full-thickness, > 20% TBSA total, special areas (face, hands, feet, perineum, joints), chemical, electrical, inhalational, comorbidities → burn center **TBSA calculation**: Rule of Nines (adult): head 9%, each arm 9%, each leg 18% (9 ant + 9 post), trunk anterior 18%, posterior 18%, perineum 1% — Lund-Browder more accurate (pediatric) **Burn depth**: - Superficial (1st°): epidermis, erythema, painful — heal 3-7 days, exclude from TBSA - Superficial partial (2nd°): dermis (papillary), blisters, painful — heal 7-21 days - Deep partial (2nd°): deep dermis, less pain, slow heal 3-6 wk → may need grafting - Full thickness (3rd°): all skin, painless, leathery — graft - 4th°: muscle/bone — extensive **Parkland formula**: 4 mL/kg/%TBSA Lactated Ringer''s first 24h from burn time; ½ in first 8h, ½ next 16h; target UO 0.5 mL/kg/hr (adult), 1 mL/kg/hr (peds). Modified Brooke (2 mL/kg/%TBSA) — lower volume option. **Inhalational injury**: 30-40% mortality if extensive burns; early intubation, FOB diagnosis, bronchodilator, suctioning. **Escharotomy**: circumferential burns chest (limit ventilation) or limbs (compartment syndrome). A partial — formula correct but inhalation/airway crucial. C ผิดอย่างยิ่ง. D ผิด — early total excision 5-7 days. E ผิด — steroid harmful in inhalation.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'ชายไทยอายุ 55 ปี โดนน้ำร้อนลวก ทั้งหน้า + ขาทั้งสองข้าง + แขนซ้าย + ลำตัวด้านหน้า

V/S: BP 102/68, HR 116, RR 22, Temp 37.0°C, SpO2 96%
Gen: alert, voice hoarse, singed nasal hair, soot in oropharynx
Burn: partial + full thickness — face 9% + bilateral leg ant. 18% + left arm anterior 4.5% + anterior trunk 18% ≈ 49.5% TBSA
Weight 70 kg';

update public.mcq_questions
set choices = '[{"label":"A","text":"Oral antibiotic + outpatient"},{"label":"B","text":"Necrotizing fasciitis — surgical emergency + septic shock"},{"label":"C","text":"Antibiotic only, no surgery"},{"label":"D","text":"Wait for culture results before debridement"},{"label":"E","text":"Topical antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Necrotizing fasciitis — surgical emergency + septic shock**: (1) **Immediate resuscitation** + IV fluid + vasopressor (norepinephrine first-line); ICU; (2) **Emergent surgical debridement** within HOURS of diagnosis (mortality increases ~9% per hour delay) — wide debridement of ALL non-viable tissue, may need amputation; second-look debridement 24-48h; goal aggressive debridement until viable bleeding tissue; (3) **Empiric broad-spectrum IV antibiotics** ASAP — coverage: gram-positive (incl MRSA: vancomycin/linezolid), gram-negative, anaerobes — **piperacillin-tazobactam + vancomycin + clindamycin** (clindamycin = toxin suppression key for Strep + Staph); de-escalate per culture; (4) **Gram stain + cultures** at debridement: Type I polymicrobial 70% (mixed aerobic/anaerobic incl Bacteroides, E. coli) Type II monomicrobial (GAS, S. aureus incl MRSA, V. vulnificus marine) Type III (Clostridium gas gangrene — Fournier''s gangrene perineum); (5) **Adjunctive**: IVIG (Type II Strep TSS — controversial benefit), hyperbaric oxygen (selected centers — Clostridial), no proven survival benefit but considered; (6) Wound VAC after debridement; reconstruction later; (7) Mortality 25-35%

---

Necrotizing soft tissue infection (NSTI) — life-threatening, surgical emergency. Mortality 25-40%. **Risk factors**: DM (most common), trauma, IVDU, immunocompromise, NSAID use (delays diagnosis), pre-existing skin lesion. **LRINEC score** (Laboratory Risk Indicator for NF): CRP > 150, WBC, Hb, Na < 135, Cr > 1.6, Glucose > 180; score ≥ 6 high suspicion, ≥ 8 high risk. Not perfectly sensitive — clinical suspicion paramount. **Clinical**: pain out of proportion (early sign), rapid spread, bullae, crepitus (gas), skin necrosis (late), sepsis. **Types**: I) Polymicrobial (DM, abdominal, perineum/Fournier''s) — 70% II) Monomicrobial — GAS, S. aureus, V. vulnificus (marine exposure) III) Clostridial myonecrosis (gas gangrene) — trauma, post-surgery **Treatment principles**: 1. EMERGENT wide surgical debridement (best predictor of survival) 2. Broad-spectrum antibiotics with anti-toxin (clindamycin) 3. ICU resuscitation, source control, repeat OR q24-48h 4. Late: reconstruction Imaging (CT, MRI) helpful but DO NOT delay surgery if clinical diagnosis. A C E ผิดอย่างยิ่ง — antibiotic alone = death. D ผิด — wait = death.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'ชายไทยอายุ 45 ปี รักษาที่บ้านจากแมลงสัตว์กัด ขาขวา 2 วัน ขาขวาบวมแดงร้อนมาก ไข้สูง

V/S: BP 78/48, HR 138, RR 28, Temp 39.8°C
Leg: erythema rapidly spreading + bullae hemorrhagic + crepitus on palpation + pain out of proportion + skin necrosis patches
Lab: WBC 24,000 with bands 18%, Cr 2.4, lactate 5.2, glucose 280, Na 128, CK 4800, LRINEC score = 9

คำถาม: management';

update public.mcq_questions
set choices = '[{"label":"A","text":"Re-exploration laparotomy"},{"label":"B","text":"Post-operative intra-abdominal abscess in pregnancy"},{"label":"C","text":"Oral antibiotic outpatient"},{"label":"D","text":"Observation alone"},{"label":"E","text":"Cesarean delivery preterm to access"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Post-operative intra-abdominal abscess in pregnancy**: (1) **CT-guided or US-guided percutaneous drainage** — preferred over re-exploration (less morbidity, preserve gestation); US-guided preferred in pregnancy to avoid radiation; (2) **IV broad-spectrum antibiotic** — pregnancy-safe (e.g., piperacillin-tazobactam, ceftriaxone + metronidazole) × 10-14 days; (3) **Drain management** — culture-directed antibiotic adjustment, output monitoring, drain in place until resolution; repeat imaging q4-7 days; (4) **Maternal-fetal monitoring** — fetal HR, contractions, infection markers, growth scan; OB co-management; (5) **Surgical re-exploration** if: failure of percutaneous drainage, hemodynamic instability, peritonitis, generalized sepsis, multi-loculated abscess inaccessible; (6) **Nutritional support** maternal; (7) Postpartum follow-up; consider underlying immune state

---

Post-operative intra-abdominal abscess — 4-10% after appendectomy (higher post perforation). Pregnancy considerations: avoid CT if possible, use US/MRI guidance. Percutaneous drainage success rate 80-90% for accessible unilocular abscess. Re-exploration reserved for failure or complications. Antibiotics in pregnancy: penicillins, cephalosporins, clindamycin, metronidazole all category B; avoid tetracyclines, fluoroquinolones (cartilage), sulfa (3rd trimester — kernicterus). Premature delivery NOT indicated for maternal infection unless severe sepsis + viable gestation + maternal life-threatening. A ผิด — invasive. C ผิด — IV. D ผิดอย่างยิ่ง. E ผิด — preterm at 28 wk significant fetal morbidity.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'หญิงไทยอายุ 28 ปี G1P0 28 weeks GA appendicitis + appendectomy 5 วันก่อน admission กลับมาด้วยไข้ ปวดท้องน้อยขวา

V/S: BP 116/72, HR 102, RR 18, Temp 38.6°C
Abdomen: RLQ tender, no peritonitis
Fetal HR 140 reactive

Lab: WBC 17,200, CRP 198
US abdomen: fluid collection 5x4 cm at RLQ deep to wound site, suspected abscess';

update public.mcq_questions
set choices = '[{"label":"A","text":"Observation + IV antibiotic only"},{"label":"B","text":"Postoperative anastomotic leak with intra-abdominal sepsis — surgical emergency"},{"label":"C","text":"Endoscopic clip closure first"},{"label":"D","text":"Discharge home for outpatient antibiotic"},{"label":"E","text":"Total parenteral nutrition only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Postoperative anastomotic leak with intra-abdominal sepsis — surgical emergency**: (1) **Resuscitation** + vasopressor + ICU; (2) **Broad-spectrum IV antibiotic** + antifungal (Candida if persistent leak/TPN) — piperacillin-tazobactam ± vancomycin ± fluconazole; (3) **Source control** — re-exploration laparotomy preferred over percutaneous in unstable / generalized peritonitis: identify + control leak (primary repair, diversion stoma, exteriorization, or end stoma), wash out, place drains, consider damage control with open abdomen + temporary closure (Bogota bag, vacuum-assisted) for severe contamination; (4) **Nutritional support** — TPN initially, transition enteral when feasible (NJ tube past leak); (5) **Drain management** + serial imaging; (6) **Reconstruction** delayed 3-6 months after recovery + nutritional optimization; (7) **Treat ongoing risk factors**: control DM, optimize nutrition, smoking cessation

---

Anastomotic leak — major cause of post-op morbidity + mortality after GI surgery (mortality 5-20%, higher with sepsis). Risk factors: tension at anastomosis, poor blood supply, contamination, malnutrition, smoking, steroids, DM, emergency surgery, hemodynamic instability. **Diagnosis**: high index of suspicion in post-op day 3-7 patient with sepsis, tachycardia, ileus, wound drainage. CT with oral + IV contrast — extravasation, free fluid, fluid collections, free air. **Management principles** (controlled vs uncontrolled): - **Controlled leak**: contained collection, stable patient, adequate drainage — percutaneous drain + IV antibiotic + NPO + bowel rest - **Uncontrolled leak**: generalized peritonitis, sepsis, hemodynamic instability — emergent re-operation **Surgical options**: - Primary repair (small early leak, healthy tissue) - Diverting loop ileostomy/colostomy + drain - Resection + end stoma (Hartmann''s-type) - Damage control if unstable: control + temporary closure + return Endoscopic options: clips (small), stents (selected esophagogastric), endoscopic vacuum (selected anastomotic). A ผิด — sepsis ต้อง source control. C ผิด — clip ไม่พอ severe. D ผิดอย่างยิ่ง. E ผิด — TPN ไม่ใช่ definitive.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'ชายไทยอายุ 45 ปี post-op day 4 laparotomy for perforated peptic ulcer ตื่นมาบ่นปวดท้อง ไข้ขึ้น 39°C

V/S: BP 88/52, HR 128, RR 26, Temp 39.4°C
Abdomen: distended, tender diffuse, surgical wound serosanguinous discharge

Lab: WBC 22,400, lactate 4.2, Cr 1.8
CT abdomen: 3 fluid collections + free fluid moderate + suspected anastomotic leak

คำถาม: management';

update public.mcq_questions
set choices = '[{"label":"A","text":"Lumpectomy alone, no axillary surgery"},{"label":"B","text":"Stage IIB invasive lobular carcinoma, cN1 — multimodal management"},{"label":"C","text":"Tamoxifen alone, no surgery"},{"label":"D","text":"Observation only"},{"label":"E","text":"Mastectomy alone, no systemic therapy"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Stage IIB invasive lobular carcinoma, cN1 — multimodal management**: (1) **Neoadjuvant approach considered**: ILC less chemosensitive than IDC + HR-strong + Ki-67 low → **neoadjuvant endocrine therapy (aromatase inhibitor for postmenopausal, ovarian suppression + AI or tamoxifen premenopausal)** — alternative to neoadjuvant chemo in luminal A-like; (2) **Surgical**: - **Mastectomy** often preferred for ILC (multifocal, infiltrative pattern, MRI more accurate for extent) — or BCS if margins achievable + acceptable cosmesis - **Axillary management**: with biopsy-confirmed nodal disease (cN1) → **axillary lymph node dissection (ALND)** standard (post-neoadjuvant may convert to SLNB with dual tracer + clip per ACOSOG Z1071); (3) **Radiation**: post-mastectomy RT for T3/T4 OR ≥ 4 + nodes; consider in T2N1 high-risk; post-BCS WBRT mandatory + regional nodal irradiation; (4) **Adjuvant systemic**: - **Endocrine therapy 5-10 years** + abemaciclib if high-risk per monarchE (≥ 4 nodes OR 1-3 nodes + high-risk feature) - **Adjuvant chemo** controversial in low-Ki-67 ILC; Oncotype DX has caveats in ILC (lower utility); often endocrine alone if T2N1 luminal A; (5) **Genetic testing** — younger age + family history + lobular (CDH1 = E-cadherin germline → hereditary diffuse gastric ca + lobular breast); (6) Survivorship + surveillance + lifestyle

---

Invasive Lobular Carcinoma (ILC) — 10-15% of breast cancer. Characteristics: - E-cadherin loss (CDH1) — single-file infiltrative pattern - Often multifocal, multicentric, bilateral - Mammographic occult (infiltrative without mass) — MRI more accurate for extent - Usually HR-positive (95%), HER2 low/neg, lower Ki-67 → luminal A-like - Less chemosensitive than IDC; more endocrine-sensitive - Metastatic pattern: peritoneum, GI tract, ovary, leptomeninges (unusual sites) **Management nuances**: 1. MRI breast pre-op to assess extent (multifocal common) 2. Mastectomy more often than BCS due to extent + margin difficulty 3. SLNB acceptable for clinically node-negative; ALND if N1+ confirmed (or post-neoadjuvant per Z1071) 4. Neoadjuvant chemo less effective; consider neoadjuvant endocrine in HR-strong + postmenopausal 5. Adjuvant: long-term endocrine 5-10 years; abemaciclib (monarchE) for high-risk HR+/HER2- 6. Oncotype DX has lower utility in ILC than IDC (validation issues) 7. Genetic — CDH1 germline assoc with HDGC (hereditary diffuse gastric ca) — refer A ผิด — nodal disease ต้อง axillary surgery. C ผิด — surgery essential. D ผิดอย่างยิ่ง. E ผิด — adjuvant systemic ต้องมี.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'หญิงไทยอายุ 35 ปี มาด้วยอาการคลำได้ก้อนนมข้างขวา quadrant 3 cm ขนาด 4 ซม. นาน 6 เดือน ไม่เจ็บ ไม่มี nipple discharge

Mammogram: BI-RADS 4C (suspicious — 5-95% probability)
US: solid mass 4 cm, hypoechoic, irregular margin
Core biopsy: invasive lobular carcinoma, grade 2, ER 99%+, PR 80%+, HER2 0, Ki-67 12%
Axillary US: 1 enlarged node 1.5 cm cortical thickening — FNAC positive metastatic carcinoma

Staging CT: no distant metastasis
Clinical T2 (4cm) N1 M0';

update public.mcq_questions
set choices = '[{"label":"A","text":"Oral antibiotic + outpatient"},{"label":"B","text":"Ludwig''s angina + deep neck space infection — airway emergency"},{"label":"C","text":"Wait for airway compromise then intubate"},{"label":"D","text":"Antibiotic only without drainage"},{"label":"E","text":"Steroids high dose alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Ludwig''s angina + deep neck space infection — airway emergency**: (1) **Airway first**: anticipate difficult airway → **awake fiberoptic intubation** or **early surgical airway (tracheostomy)** in OR with surgical airway backup; avoid sedation that loses airway; (2) **ICU admission**; (3) **IV broad-spectrum antibiotic** ASAP — cover oral flora (strep + anaerobes incl Bacteroides) — **ampicillin-sulbactam OR clindamycin + ceftriaxone OR piperacillin-tazobactam**; add vancomycin if MRSA risk; (4) **Surgical drainage** of deep neck space infection — incision + drainage of involved spaces (submandibular, submental, parapharyngeal, retropharyngeal as needed) + dental extraction if odontogenic source; obtain cultures; (5) **DM control** — IV insulin, glucose monitoring; (6) **Monitor for complications**: descending mediastinitis (CT chest if suspected — high mortality), Lemierre''s syndrome (jugular thrombophlebitis), sepsis, airway compromise; (7) Dental/ENT consultation; (8) Postdischarge dental care

---

Ludwig''s angina — bilateral submandibular + sublingual + submental space cellulitis. Usually odontogenic (lower molars). Rapid spread + airway threat + descending mediastinitis risk. **Mortality**: 50%+ pre-antibiotic, 5-10% modern era. **Anatomy of deep neck spaces**: - Submandibular (Ludwig''s) - Parapharyngeal — communicates with retropharyngeal, mediastinum - Retropharyngeal — extends to mediastinum (danger space) - Prevertebral - Carotid sheath **Airway management** critical: - Early intubation BEFORE airway loss - Anticipate difficulty (trismus, floor mouth edema, tongue displacement) - Awake fiberoptic preferred - Surgical airway (tracheostomy or cricothyroidotomy) ready - Avoid blind intubation, paralytics if uncertain **Antibiotics**: cover oral flora — strep, anaerobes (Bacteroides, Prevotella, Fusobacterium); β-lactam/inhibitor + clindamycin standard. Vanco if MRSA suspected. **Surgical**: drain abscesses, address source (dental). **Complications**: - Descending necrotizing mediastinitis (50% mortality) — high CT chest if persistent fever, chest symptoms - Lemierre''s syndrome — Fusobacterium necrophorum jugular thrombophlebitis with septic emboli A ผิด — ผู้ป่วยรุนแรง. C ผิดอย่างยิ่ง — pre-emptive airway. D ผิด — ต้อง drain. E ผิด — steroid bukan first-line.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'surgery'
  and scenario = 'ชายไทยอายุ 52 ปี underlying DM, HT มาด้วยอาการ painful neck mass 3 วัน หนาวสั่น ไข้สูง กลืนเจ็บ

V/S: BP 108/68, HR 116, RR 22, Temp 39.4°C
Neck: tender mass anterior to SCM left side 6 cm + erythema + tenderness + trismus + drooling
Oral: poor dentition, swelling lower jaw + floor of mouth tenderness, tongue elevated

Lab: WBC 22,400, CRP 240, glucose 380
CT neck with contrast: deep neck space infection involving submandibular + parapharyngeal + retropharyngeal spaces + airway narrowing 50%';

commit;
