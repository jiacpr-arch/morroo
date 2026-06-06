-- ===============================================================
-- หมอรู้ — Board seed: ศัลยศาสตร์ (surgery) — part 1/4 (50 MCQs)
-- Safe to paste into Supabase SQL Editor. Re-runnable.
-- ===============================================================

begin;

-- mcq_subjects for this specialty (idempotent)
insert into public.mcq_subjects
  (name, name_th, icon, audience, board_specialty, exam_type, question_count)
values
  ('surg_clinical_decision', 'ศัลยศาสตร์ · การตัดสินใจทางเวชกรรม', '🩺', 'board', 'surgery', NULL, 0),
  ('surg_basic_science', 'ศัลยศาสตร์ · วิทยาศาสตร์การแพทย์พื้นฐาน', '🧬', 'board', 'surgery', NULL, 0),
  ('surg_ems_mgmt', 'ศัลยศาสตร์ · การจัดการระบบบริการการแพทย์ฉุกเฉิน', '🚨', 'board', 'surgery', NULL, 0),
  ('surg_integrative', 'ศัลยศาสตร์ · ข้อสอบบูรณาการ', '🧩', 'board', 'surgery', NULL, 0)
on conflict (name) do nothing;

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 32 ปี ถูกแทงด้วยมีดเข้าหน้าท้องด้านซ้าย level เหนือสะดือ มาห้องฉุกเฉิน 30 นาทีหลังเกิดเหตุ ผู้ป่วยรู้สึกตัวดี

V/S: BP 96/64 mmHg, HR 118, RR 24, SpO2 98% room air, Temp 36.8°C
Gen: alert, pale, diaphoretic
Abdomen: distended, guarding +, rebound +, มี evisceration ของ omentum ออกจากแผลขนาด 4 cm

FAST exam: positive free fluid ทั้ง 4 quadrants', '[{"label":"A","text":"CT abdomen with contrast แล้วค่อยตัดสินใจ"},{"label":"B","text":"emergent exploratory laparotomy"},{"label":"C","text":"Local wound exploration ใน ED ก่อน"},{"label":"D","text":"Diagnostic peritoneal lavage"},{"label":"E","text":"Observation 6 ชั่วโมง ก่อนตัดสินใจ"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Anterior abdominal stab wound + evisceration + hemodynamic instability + positive FAST → mandatory **emergent exploratory laparotomy** without further imaging; resuscitate enroute (2 large-bore IV, type & crossmatch 4 units PRC, give massive transfusion protocol if needed, IV antibiotics ครอบคลุม enteric flora); avoid hypothermia; damage control surgery principles if unstable

---

Penetrating abdominal trauma — indications for **mandatory laparotomy** (no need for further imaging): 1. **Hemodynamic instability** (BP < 90, HR > 120, signs of shock) 2. **Peritonitis** (rebound, guarding, generalized tenderness) 3. **Evisceration** of omentum or bowel 4. **Blood per rectum, hematemesis, or hematuria** (visceral injury) 5. **Gunshot wound** to abdomen — almost always laparotomy (high transit injury rate) 6. **Diaphragm injury** 7. **Free intraperitoneal air** on imaging Patient has: anterior abdominal stab + evisceration + hemodynamic instability + positive FAST = ABSOLUTE indication WSES + EAST + ATLS 10th edition + Trauma Quality Improvement Program guideline: 1. **Primary survey (ABCDE)**: - Airway with C-spine, breathing, circulation - 2 large-bore IV (16-18G), type & cross 4-6 units - Resuscitate to permissive hypotension (SBP 80-90) until bleeding controlled - Massive transfusion protocol 1:1:1 (PRC:FFP:Plt) if ongoing hemorrhage 2. **Emergent operating room**: - Midline laparotomy - Damage control surgery if unstable: control hemorrhage + contamination, temporary abdominal closure, ICU resuscitation, return for definitive 24-72 hr later 3. **Antibiotics**: broad-spectrum (e.g., cefoxitin, piperacillin-tazobactam, or cefazolin + metronidazole) — penetrating abdominal trauma 4. **Tetanus prophylaxis** 5. **Trauma team activation, blood bank notification** Stable patient with penetrating abdominal wound (no above indications) may have: - **Local wound exploration** to determine if peritoneum violated (anterior stab only) - **CT triple contrast** if equivocal - **Selective non-operative management** (SNOM) for selected hemodynamically stable patients with isolated solid organ injury, no peritonitis - **Serial abdominal exams** + observation 24 hr if equivocal — ตัวเลือก B ถูกตามมาตรฐาน. A ผิด — unstable + evisceration ไม่รอ CT. C ผิด — local exploration เฉพาะ stable ไม่มี absolute indication. D ผิด — DPL ล้าสมัย ใช้ FAST แทน. E ผิดอย่างยิ่ง — ไม่สังเกตเมื่อมี indication absolute', NULL,
  'easy', 'trauma', 'review',
  'surgery', 'clinical_decision', 'trauma', 'adult',
  'ATLS Advanced Trauma Life Support 10th Edition; EAST Practice Management Guidelines: Penetrating Abdominal Trauma; WSES Guidelines for Trauma 2022', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 32 ปี ถูกแทงด้วยมีดเข้าหน้าท้องด้านซ้าย level เหนือสะดือ มาห้องฉุกเฉิน 30 นาทีหลังเกิดเหตุ ผู้ป่วยรู้สึกตัวดี

V/S: BP 96/64 mmHg, HR 118, RR 24, SpO2 98% room air, Temp 36.8°C
Gen: alert, pale, diaphoretic
Abdomen: distended, guarding +, rebound +, มี evisceration ของ omentum ออกจากแผลขนาด 4 cm

FAST exam: positive free fluid ทั้ง 4 quadrants'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 65 ปี underlying HT, DM type 2 มาด้วยอาการปวดท้องรุนแรงทันทีทันใด มาแล้ว 8 ชั่วโมง ปวดร้าวไปหลัง คลื่นไส้อาเจียน ผู้ป่วย ill-looking มาก

V/S: BP 88/52, HR 132, RR 26, SpO2 95% room air, Temp 36.4°C
Abdomen: pulsatile mass บริเวณ epigastrium-paraumbilical ขนาด 6 cm + tender + rigid abdomen

Lab: Hb 8.4 g/dL (baseline 13.2), WBC 16,500, Cr 1.8, Lactate 4.8
CT abdomen with contrast (urgent bedside): ruptured AAA 7.2 cm with retroperitoneal hematoma extending to pelvis', '[{"label":"A","text":"Aggressive IV fluid resuscitation ก่อนแล้วค่อย surgery"},{"label":"B","text":"emergent endovascular aortic repair (EVAR)"},{"label":"C","text":"Observation in ICU + serial Hb"},{"label":"D","text":"Catheter-directed thrombolysis"},{"label":"E","text":"Beta-blocker IV high dose first"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Ruptured Abdominal Aortic Aneurysm (rAAA) — surgical emergency mortality 80-90% overall; immediate transfer to OR for **emergent endovascular aortic repair (EVAR)** if anatomy suitable (improved survival vs open IMPROVE trial 2014; randomized REVAR vs open showed equivalent mortality) OR **open surgical repair** if EVAR not feasible; permissive hypotension SBP 70-90 (avoid aggressive fluid → worsens rupture, dilutes clotting); rapid blood transfusion + massive transfusion protocol; vascular surgery + trauma team activation; preoperative antibiotics

---

Ruptured Abdominal Aortic Aneurysm (rAAA) — true vascular emergency Classic triad (Cooper Triad — present in only 50%): 1. Hypotension/shock 2. Pulsatile abdominal mass 3. Severe abdominal/back pain Overall mortality: - Pre-hospital: ~50% die before reaching hospital - In-hospital: 50-80% (overall mortality 80-90%) Risk factors for AAA: - Age > 65, male, smoking, family history, HT, atherosclerosis, COPD, connective tissue disorders Indications for elective AAA repair (asymptomatic): - Size ≥ 5.5 cm in men, ≥ 5.0 cm in women - Rapid growth > 0.5 cm/6 mo or > 1 cm/year - Symptomatic (always repair regardless of size) Management of rAAA: 1. **Code AAA / trauma team activation** + vascular surgery + OR + blood bank 2. **Permissive hypotension** SBP 70-90 (cerebral perfusion + avoid clot disruption): - Aggressive fluid worsens rupture ("pop the clot") - Avoid hypertension (Valsalva, anxiety) 3. **Two large-bore IV** access + type & crossmatch 6-10 units PRC + massive transfusion protocol 1:1:1 4. **Imaging** (rapid): - CT angiogram bedside or in OR (if available, planning for EVAR) - Avoid if delays surgery in unstable patient 5. **Emergent repair**: - **EVAR (Endovascular Aneurysm Repair)** — preferred if anatomy suitable - IMPROVE trial 2014 (BMJ, Lancet): EVAR vs open in rAAA showed no significant difference in 30-day mortality but better quality of life + faster recovery in EVAR - AJAX trial: similar results - Anatomic requirements: adequate proximal neck (length ≥ 10-15 mm, angulation, diameter), suitable iliac access - Permissive hypotensive setup, percutaneous when possible - **Open Surgical Repair**: - Midline laparotomy → aortic cross-clamp (supraceliac or infrarenal) → control proximal + distal → graft replacement - Longer recovery, higher complication rate but no anatomy limitations 6. **Postoperative ICU**: - Multi-organ dysfunction risk: AKI, MI, mesenteric ischemia, abdominal compartment syndrome, lower limb ischemia, paraplegia, colon ischemia - Monitor abdominal pressure (compartment syndrome) - Continued resuscitation Outcome predictors (Hardman index): age > 76, loss of consciousness, Hb < 9, Cr > 190, ECG ischemia → higher mortality Prevention: AAA screening (USPSTF): - Men 65-75 ever-smoked: one-time abdominal US screening - Other selected per family history / comorbidity — ตัวเลือก B comprehensive. A ผิดอย่างยิ่ง — aggressive fluid before control = pop the clot. C ผิดอย่างยิ่ง — observation = death. D ผิด — thrombolysis ทำให้เลือดออกมากขึ้น. E ผิด — beta-blocker single agent insufficient', NULL,
  'medium', 'trauma', 'review',
  'surgery', 'clinical_decision', 'trauma', 'adult',
  'IMPROVE Trial BMJ 2014, Lancet 2017 (EVAR vs Open in rAAA); ESVS Clinical Practice Guidelines 2024 on AAA; Society for Vascular Surgery Practice Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 65 ปี underlying HT, DM type 2 มาด้วยอาการปวดท้องรุนแรงทันทีทันใด มาแล้ว 8 ชั่วโมง ปวดร้าวไปหลัง คลื่นไส้อาเจียน ผู้ป่วย ill-looking มาก

V/S: BP 88/52, HR 132, RR 26, SpO2 95% room air, Temp 36.4°C
Abdomen: pulsatile mass บริเวณ epigastrium-paraumbilical ขนาด 6 cm + tender + rigid abdomen

Lab: Hb 8.4 g/dL (baseline 13.2), WBC 16,500, Cr 1.8, Lactate 4.8
CT abdomen with contrast (urgent bedside): ruptured AAA 7.2 cm with retroperitoneal hematoma extending to pelvis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 28 ปี ไม่มีโรคประจำตัว มาด้วยอาการปวดท้อง RLQ มา 24 ชั่วโมง initial pain at periumbilical area แล้ว migrate ไปขวาล่าง คลื่นไส้อาเจียน 2 ครั้ง ไม่ผ่ายลง ไม่ถ่ายเหลว

LMP 2 สัปดาห์ที่แล้ว — ไม่ตั้งครรภ์
V/S: BP 118/72, HR 102, RR 18, Temp 38.2°C, SpO2 99%
Abdomen: RLQ tenderness, McBurney''s point +, Rovsing''s sign +, psoas sign +, ไม่มี rebound

Lab: WBC 14,200 (PMN 88%), CRP 78, urinalysis WBC 5 negative leukocyte esterase, β-hCG negative
Alvarado score = 9 (high)
US abdomen: enlarged non-compressible appendix 9 mm with periappendiceal fluid', '[{"label":"A","text":"Antibiotic therapy alone (amoxicillin-clavulanate) × 7 วัน + outpatient"},{"label":"B","text":"Laparoscopic appendectomy"},{"label":"C","text":"CT abdomen with contrast (mandatory) ก่อนตัดสินใจ"},{"label":"D","text":"MRI abdomen"},{"label":"E","text":"Discharge with analgesics + follow-up 24 hr"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Laparoscopic appendectomy** with concurrent IV antibiotic (cefoxitin or amoxicillin-clavulanate) — gold standard for uncomplicated acute appendicitis with high clinical suspicion (Alvarado ≥ 7) and imaging confirmation; benefits over open: less pain, shorter LOS, less wound infection; if complicated (perforation, abscess), may consider percutaneous drainage + interval appendectomy; antibiotic alone (non-operative management) considered for selected uncomplicated cases in adults (CODA trial NEJM 2020) — option but recurrence 25-40% within 1 year

---

Acute Appendicitis — most common surgical emergency Diagnosis (clinical + imaging): - **Clinical features**: periumbilical pain → migration to RLQ (Murphy''s sequence), anorexia, nausea/vomiting, low-grade fever - **Physical exam signs**: - McBurney''s point tenderness - Rovsing''s sign (pain in RLQ on palpation LLQ) - Psoas sign (pain on right hip extension) - Obturator sign (pain on internal rotation right hip) - Rebound tenderness, guarding (peritonitis) - **Alvarado score** (MANTRELS): - Migration of pain, Anorexia, Nausea/vomiting, Tenderness RLQ, Rebound, Elevated temp, Leukocytosis, Shift to left - Score: 1-4 unlikely, 5-6 possible, 7-8 probable, 9-10 highly likely Imaging: - **Ultrasound**: first-line in pediatric, pregnant, young adult (avoid radiation) - **CT with IV contrast**: gold standard in adults (sensitivity 95%) - **MRI**: pregnant women with equivocal ultrasound Differential diagnosis: - Ovarian cyst (rupture, torsion), tubo-ovarian abscess - PID - Ectopic pregnancy - Right ureteral colic - Meckel''s diverticulitis - Yersinia mesenteric adenitis - Crohn''s flare (terminal ileitis) - UTI/pyelonephritis Management — Acute Uncomplicated Appendicitis: 1. **Laparoscopic appendectomy** (preferred): - Cochrane meta-analysis: lower wound infection, less pain, shorter LOS, faster recovery vs open - More expensive but cost-effective long-term - Indications particularly: obese, young adults, females (avoid scar, fertility) 2. **Open appendectomy** alternative: - In situations with limited laparoscopy availability - When suspicion of perforation/abscess with extensive contamination 3. **Preoperative antibiotics**: - **Single preoperative dose** broad-spectrum (e.g., cefoxitin, cefoxitin + metronidazole, ampicillin-sulbactam) - Continue postoperatively only if complicated (perforation, gangrene) 4. **Non-operative management (NOM) with antibiotics alone** — emerging option: - CODA Trial (NEJM 2020): non-inferior at 30 days for uncomplicated appendicitis - 25-40% recurrence within 1-5 years - Considerations: patient preference, fecalith on imaging (higher recurrence), comorbidities - Not currently first-line for general use Management — Complicated Appendicitis (perforation, abscess, phlegmon): 1. **Stable patient with localized abscess > 3 cm**: - Percutaneous drainage + IV antibiotics × 7-10 days - Interval appendectomy 6-8 weeks later (controversial — some advocate observation if asymptomatic, given recurrence rate ~15%) 2. **Phlegmon or small abscess (< 3 cm)**: - IV antibiotics alone, interval appendectomy 3. **Generalized peritonitis or septic shock**: - Emergency exploratory laparotomy + appendectomy + washout - Antibiotics: cefoxitin or piperacillin-tazobactam Pediatric considerations: - High risk of perforation (less localized, delayed presentation) - Imaging: ultrasound first; CT or MRI if equivocal Pregnancy considerations: - Appendix displaced upward + lateral as pregnancy advances - Increased risk of perforation due to atypical presentation - Ultrasound first; MRI if non-diagnostic; CT only if essential - Appendectomy safe in all trimesters; laparoscopy preferred in 1st-2nd trimester — ตัวเลือก B comprehensive. A ผิด — NOM optional but appendectomy more definitive especially Alvarado 9. C ผิด — CT not mandatory if clinical + US supports diagnosis (over-utilization of imaging is criticized). D ผิด — MRI for pregnancy not routine. E ผิดอย่างยิ่ง — discharge dangerous', NULL,
  'easy', 'gi', 'review',
  'surgery', 'clinical_decision', 'gi', 'adult',
  'WSES Jerusalem Guidelines for Acute Appendicitis 2020; Flum DR et al. NEJM 2020 (CODA Trial); ACS Strong for Surgery Initiative', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 28 ปี ไม่มีโรคประจำตัว มาด้วยอาการปวดท้อง RLQ มา 24 ชั่วโมง initial pain at periumbilical area แล้ว migrate ไปขวาล่าง คลื่นไส้อาเจียน 2 ครั้ง ไม่ผ่ายลง ไม่ถ่ายเหลว

LMP 2 สัปดาห์ที่แล้ว — ไม่ตั้งครรภ์
V/S: BP 118/72, HR 102, RR 18, Temp 38.2°C, SpO2 99%
Abdomen: RLQ tenderness, McBurney''s point +, Rovsing''s sign +, psoas sign +, ไม่มี rebound

Lab: WBC 14,200 (PMN 88%), CRP 78, urinalysis WBC 5 negative leukocyte esterase, β-hCG negative
Alvarado score = 9 (high)
US abdomen: enlarged non-compressible appendix 9 mm with periappendiceal fluid'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 55 ปี underlying alcoholic cirrhosis, esophageal varices มา ED ด้วยอาการอาเจียนเป็นเลือดสด 3 ครั้ง ปริมาณรวม ~600 mL ใน 4 ชั่วโมงก่อน ก่อนหน้านี้เคย banding 6 เดือนที่แล้ว

V/S: BP 78/48 mmHg, HR 132, RR 24, SpO2 95%, Temp 37.0°C
Gen: ill-looking, pale, diaphoretic
Abdomen: ascites moderate, splenomegaly, ไม่มี shifting dullness
Digital rectal exam: melena +

Lab: Hb 6.8 (baseline 11), Plt 78,000, INR 1.9, Cr 1.4, BUN 56, AST 88, ALT 42, Total bili 3.2, Albumin 2.6, Na 132, NH3 92
Child-Pugh = C (10), MELD 22', '[{"label":"A","text":"PPI IV infusion alone + transfuse PRC to Hb > 10"},{"label":"B","text":"IV vasoactive drug"},{"label":"C","text":"Emergency surgery — devascularization procedure"},{"label":"D","text":"Liver transplant immediate"},{"label":"E","text":"Conservative observation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Variceal hemorrhage in cirrhosis (high mortality): (1) Resuscitate: 2 large-bore IV + restrictive transfusion (target Hb 7-8 — Villanueva NEJM 2013 showed mortality benefit) + careful fluid (avoid over-resuscitation → ↑ portal pressure rebleeding) (2) **IV vasoactive drug**: terlipressin OR octreotide infusion (start immediately, continue 3-5 days) (3) **Prophylactic IV antibiotic** (ceftriaxone 1 g/day × 5-7 days) — reduces bacterial infections, rebleeding, mortality (Cochrane meta-analysis) (4) **Endoscopic variceal band ligation (EVBL)** within 12 hours — definitive hemostasis; sclerotherapy alternative (5) Correct coagulopathy (vitamin K + FFP for INR > 1.5, platelet > 50,000 for procedure; avoid aggressive coagulation correction in cirrhosis — paradoxic rebleeding) (6) Manage hepatic encephalopathy precipitated by GI bleed (lactulose, rifaximin) (7) Refractory bleeding: balloon tamponade (Sengstaken-Blakemore) as bridge; TIPS (Transjugular Intrahepatic Portosystemic Shunt) for early salvage in selected (Child B/C with re-bleed) (8) Long-term: secondary prophylaxis with non-selective beta-blocker (propranolol or carvedilol) + serial EVBL until eradication

---

Variceal hemorrhage in cirrhosis — life-threatening complication of portal hypertension Mortality: - 6-week mortality: 15-25% overall - 6-week mortality Child-Pugh C: > 50% - Re-bleeding rate without prophylaxis: 60% at 1 year Risk factors for variceal bleed: - Variceal size (large > medium > small) - Red wale marks (high-risk signs on endoscopy) - Child-Pugh class (B/C higher) - HVPG > 12 mmHg (portal hypertension threshold) Management (Baveno VII Consensus 2022 + AASLD): 1. **Resuscitation**: - Two large-bore IV - **Restrictive transfusion** strategy (Hb 7-8 g/dL): Villanueva NEJM 2013 trial — restrictive lower mortality vs liberal in cirrhotic variceal bleed - Avoid over-resuscitation (worsens portal pressure → rebleeding) - Vasopressors if needed - Airway protection (intubation) for ongoing hematemesis or altered mental status 2. **Vasoactive drug** (start immediately, before endoscopy): - **Terlipressin** 2 mg IV q4h × 24-48 hr, then 1 mg q4h × 3-5 days (preferred — vasopressin V1 receptor selective, less side effects) - **Octreotide** 50 mcg IV bolus → 50 mcg/hr infusion × 3-5 days (somatostatin analog) - Continue × 3-5 days 3. **Prophylactic antibiotics** (mandatory, regardless of ascites or signs of infection): - **Ceftriaxone 1 g IV daily × 5-7 days** (preferred over norfloxacin in advanced cirrhosis — Fernández J et al. Gastroenterology 2006) - Reduces: SBP, UTI, pneumonia, bacteremia, rebleeding, mortality - Note: Patient has Child-Pugh C → ceftriaxone preferred 4. **Endoscopy within 12 hours**: - **Variceal Band Ligation (EVBL)** — first-line endoscopic treatment for esophageal varices - **Sclerotherapy** — second-line if EVBL not feasible - **N-butyl cyanoacrylate injection** — for gastric varices 5. **Correct coagulopathy carefully**: - Vitamin K 10 mg IV (slow push) - FFP for active bleeding + INR > 1.5 (controversial — cirrhotic coagulopathy is balanced; over-correction worsens portal pressure) - Platelet transfusion if < 50,000 + procedure or active bleed - Avoid aggressive blood product use 6. **Manage Hepatic Encephalopathy** (often precipitated): - **Lactulose** 30-45 mL q1h until 2-3 BM/day - **Rifaximin** 550 mg BID if recurrent 7. **TIPS (Transjugular Intrahepatic Portosystemic Shunt)**: - **Early TIPS** (within 72 hr) for high-risk patients: Child B with active bleed at endoscopy OR Child C 10-13 — improves survival (García-Pagán et al. NEJM 2010) - **Rescue TIPS** for refractory or recurrent bleeding after 2 endoscopic sessions - Contraindications: heart failure, severe pulmonary HTN, severe HE 8. **Balloon tamponade** (Sengstaken-Blakemore tube): - Temporary bridge to definitive therapy (TIPS, surgery, transplant) - Complications: aspiration, esophageal rupture, pressure necrosis - Max 24 hr 9. **Surgery**: - Now largely replaced by TIPS - Devascularization procedures (Sugiura), shunt surgery (distal splenorenal) — selected refractory cases 10. **Liver transplantation**: - Definitive for end-stage liver disease - MELD-based allocation Long-term Secondary Prophylaxis: 1. **Combination therapy**: - Non-selective beta-blocker (propranolol or carvedilol — preferred in compensated cirrhosis per Baveno) + serial EVBL 2. **Carvedilol**: more effective at reducing HVPG than propranolol (PREDESCI 2019) — first choice in compensated 3. Treat underlying liver disease (etiology-specific): - Alcohol cessation - Antiviral therapy for HCV (DAAs) - Lifestyle/medical Rx for NAFLD/MASH 4. Liver transplant evaluation Primary Prophylaxis (no prior bleed but high-risk varices): - Non-selective beta-blocker OR EVBL Patient prognosis: Child-Pugh C + variceal bleed = high mortality; early aggressive multimodal management + transplant evaluation — ตัวเลือก B comprehensive. A ผิด — PPI inadequate sole therapy + liberal transfusion harms. C ผิด — surgery rarely used now. D ผิด — transplant evaluation but not immediate. E ผิดอย่างยิ่ง', NULL,
  'hard', 'gi', 'review',
  'surgery', 'clinical_decision', 'gi', 'adult',
  'Baveno VII Consensus Workshop on Portal Hypertension (J Hepatol 2022); AASLD Practice Guidance on Portal Hypertensive Bleeding 2017; García-Pagán JC et al. NEJM 2010 (Early TIPS); Villanueva C et al. NEJM 2013 (Restrictive Transfusion)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 55 ปี underlying alcoholic cirrhosis, esophageal varices มา ED ด้วยอาการอาเจียนเป็นเลือดสด 3 ครั้ง ปริมาณรวม ~600 mL ใน 4 ชั่วโมงก่อน ก่อนหน้านี้เคย banding 6 เดือนที่แล้ว

V/S: BP 78/48 mmHg, HR 132, RR 24, SpO2 95%, Temp 37.0°C
Gen: ill-looking, pale, diaphoretic
Abdomen: ascites moderate, splenomegaly, ไม่มี shifting dullness
Digital rectal exam: melena +

Lab: Hb 6.8 (baseline 11), Plt 78,000, INR 1.9, Cr 1.4, BUN 56, AST 88, ALT 42, Total bili 3.2, Albumin 2.6, Na 132, NH3 92
Child-Pugh = C (10), MELD 22'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 48 ปี ตรวจสุขภาพประจำปี mammogram screening พบ suspicious calcification cluster ขนาด 8 mm ที่ upper outer quadrant ของ left breast (BI-RADS 4B)

No palpable mass; no skin changes, no nipple discharge, no axillary lymph nodes

Core biopsy: invasive ductal carcinoma, grade 2, ER 95%+, PR 70%+, HER2 1+ (negative), Ki-67 18%

Staging US axilla: no suspicious nodes
Clinical T1cN0M0
Mammogram other breast: BI-RADS 1', '[{"label":"A","text":"Bilateral mastectomy + adjuvant chemotherapy"},{"label":"B","text":"Early breast cancer (T1N0M0, HR+/HER2-) — staged multidisciplinary management"},{"label":"C","text":"Single agent endocrine therapy alone"},{"label":"D","text":"Observation only"},{"label":"E","text":"Stereotactic radiotherapy without surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Early breast cancer (T1N0M0, HR+/HER2-) — staged multidisciplinary management: (1) **Breast Conservation Surgery (BCS = lumpectomy)** with negative margin (ASCO 2014 = ''no ink on tumor'' for invasive, 2 mm for DCIS); equivalent to mastectomy for overall survival (NSABP B-06 trial); (2) **Sentinel Lymph Node Biopsy (SLNB)** for clinical N0 — replaces axillary dissection; if 1-2 positive sentinel nodes + meeting Z0011 criteria (T1-2, BCS + RT, no neoadjuvant), can avoid axillary dissection; (3) **Adjuvant whole-breast radiation therapy** after BCS (essential — reduces local recurrence 50% per EBCTCG meta-analysis); (4) **Adjuvant endocrine therapy** for HR+: tamoxifen 5-10 years (premenopausal) OR aromatase inhibitor (postmenopausal) — extended duration if high-risk; (5) **Genomic assay** (Oncotype DX Recurrence Score, MammaPrint) — guides chemo decision in T1-2, N0, HR+/HER2-; (6) **Adjuvant chemotherapy** based on RS/MammaPrint risk + clinical features; (7) Genetic counseling/testing if criteria met (young age, family history, triple-neg); (8) Lifestyle: weight, exercise, alcohol; (9) Survivorship plan + surveillance

---

Early-stage breast cancer (Stage I, T1N0M0, HR+/HER2-) — most favorable subtype Multidisciplinary management: 1. **Surgical management**: - **Breast Conservation Surgery (BCS)** = lumpectomy: equivalent OS to mastectomy in early-stage (NSABP B-06 trial 20-year follow-up) - Margin definition (SSO/ASTRO 2014): "no ink on tumor" for invasive cancer (re-excision rate from 25% → 14%) - **Contraindications to BCS**: multicentric disease (multiple quadrants), inability to achieve negative margins after re-excision, prior radiation to chest, persistent positive margins, large tumor:breast ratio (relative), inflammatory cancer 2. **Axillary staging**: - **Sentinel Lymph Node Biopsy (SLNB)** for cN0 → standard of care, replaces ALND (axillary lymph node dissection) - **ACOSOG Z0011 trial**: Patients with T1-2, BCS + whole breast RT, no neoadjuvant chemo, 1-2 positive SLNs by H&E → can SKIP axillary dissection (no survival difference) - **Indications for ALND**: > 3 positive SLNs, clinically positive nodes pre-op, mastectomy patients with positive SLN, inflammatory breast cancer 3. **Adjuvant radiation therapy**: - **Whole-breast RT (WBRT)** after BCS — mandatory (EBCTCG meta-analysis: 50% reduction in local recurrence, 5-10% reduction in death) - **Hypofractionated WBRT** (40 Gy/15 fractions or 26 Gy/5 fractions FAST-Forward) — equivalent + shorter - **Accelerated partial breast irradiation (APBI)** — selected (older patients, smaller tumors) - **Boost to tumor bed**: recommended in younger patients, high-grade, positive margins - **Post-mastectomy RT**: T3-4, ≥ 4 positive nodes, positive margins 4. **Adjuvant systemic therapy**: a. **Endocrine therapy** (HR+ only): - **Premenopausal**: Tamoxifen 5-10 years; consider ovarian suppression + AI in high-risk (TEXT/SOFT trials) - **Postmenopausal**: Aromatase Inhibitor (letrozole, anastrozole, exemestane) 5-10 years; tamoxifen alternative - **Extended therapy** (10 years): high-risk features (large tumor, multiple positive nodes) — ATLAS, aTTom, MA.17R trials - **Side effects**: hot flashes, vaginal dryness, bone loss (DEXA monitoring), VTE (tamoxifen), endometrial cancer (tamoxifen) b. **Adjuvant chemotherapy** decision in HR+/HER2-, node-negative: - Driven by **multigene assays**: - **Oncotype DX Recurrence Score (RS)** — most validated; based on 21 genes; TAILORx trial: - RS 0-10: endocrine alone - RS 11-25: endocrine alone if age > 50 (TAILORx); consider chemo + endocrine if age ≤ 50 or high clinical risk - RS 26-100: chemo + endocrine - **MammaPrint** — 70-gene; categorical (high/low) per MINDACT trial - **PAM50/Prosigna**, **EndoPredict** — alternatives c. **HER2-targeted therapy** (HER2+ only): - Trastuzumab × 1 year, often + pertuzumab, with chemo - HER2-low (1+, 2+/FISH-) — emerging T-DXd 5. **Genetic testing/counseling**: - Indications: age < 50, triple-negative, male breast cancer, bilateral, family history, Ashkenazi Jewish ancestry, prior personal history - BRCA1/2 + other genes (PALB2, ATM, CHEK2, etc.) - Guides risk-reducing strategies + family screening 6. **Survivorship + Surveillance**: - Annual mammography (other breast + tumor bed if BCS), clinical breast exam q3-6 months × 5 years - DEXA scan if on AI - Endometrial cancer surveillance if on tamoxifen - Lifestyle: weight control, exercise, limit alcohol, smoking cessation - Lymphedema awareness 7. **Prognosis**: - T1N0 HR+/HER2- has excellent prognosis (5-year DFS > 90%, 10-year > 85%) - Modern outcomes per SEER + clinical trials — ตัวเลือก B comprehensive evidence-based. A ผิด — bilateral mastectomy + chemo overtreatment. C ผิด — no surgery missed. D ผิดอย่างยิ่ง. E ผิด — invasive cancer needs surgery', NULL,
  'medium', 'hemato_onco', 'review',
  'surgery', 'clinical_decision', 'hemato_onco', 'adult',
  'NCCN Clinical Practice Guidelines in Oncology: Breast Cancer 2024; Sparano JA et al. NEJM 2018 (TAILORx); Giuliano AE et al. JAMA 2017 (Z0011 10-year); EBCTCG Lancet 2014 (Radiation Meta-analysis)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 48 ปี ตรวจสุขภาพประจำปี mammogram screening พบ suspicious calcification cluster ขนาด 8 mm ที่ upper outer quadrant ของ left breast (BI-RADS 4B)

No palpable mass; no skin changes, no nipple discharge, no axillary lymph nodes

Core biopsy: invasive ductal carcinoma, grade 2, ER 95%+, PR 70%+, HER2 1+ (negative), Ki-67 18%

Staging US axilla: no suspicious nodes
Clinical T1cN0M0
Mammogram other breast: BI-RADS 1'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 70 ปี underlying T2DM, smoker มาด้วยอาการ painless jaundice ค่อยเป็นค่อยไปใน 3 สัปดาห์ ร่วมกับน้ำหนักลด 6 kg อ่อนเพลีย ปวด epigastrium ร้าวไปหลังเล็กน้อย ปัสสาวะเข้ม อุจจาระสีซีด คันตามตัว

V/S: BP 128/76, HR 88, RR 16, Temp 36.8°C
PE: jaundice + scleral icterus + Courvoisier''s sign (palpable non-tender gallbladder)
ไม่มี ascites หรือ stigmata of chronic liver disease

Lab: Total bili 12.4 (direct 9.8, indirect 2.6), AST 78, ALT 92, ALP 485 (high), GGT 612 (high), Albumin 3.2, INR 1.4, Cr 0.9, CA 19-9 1,240 U/mL (very high, normal < 37)
US abdomen: dilated CBD 14 mm + intrahepatic biliary dilatation + suspicious hypoechoic mass at pancreatic head 3.5 cm
CT abdomen: pancreatic head mass 3.5 cm + biliary obstruction + suspicious peripancreatic + portal vein abutment < 180° (borderline resectable per NCCN criteria)', '[{"label":"A","text":"Palliative care alone"},{"label":"B","text":"Pancreatic head adenocarcinoma — borderline resectable"},{"label":"C","text":"Whipple immediately without neoadjuvant"},{"label":"D","text":"Chemotherapy alone (no surgery)"},{"label":"E","text":"Radiation alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pancreatic head adenocarcinoma — borderline resectable: (1) **Multidisciplinary tumor board** (HPB surgery + medical oncology + radiation oncology + GI + interventional radiology); (2) **Tissue diagnosis** by EUS-guided FNA before neoadjuvant therapy; (3) **Neoadjuvant chemotherapy** with FOLFIRINOX or gemcitabine + nab-paclitaxel — improves resection rates, R0 rates, survival per ESPAC-1, PRODIGE-24 trials; (4) Concurrent or sequential **chemoradiotherapy** consideration; (5) Restage after 2-4 months — if resectable response, proceed to **Whipple procedure (pancreaticoduodenectomy)** with R0 resection goal; (6) Adjuvant chemotherapy post-op (modified FOLFIRINOX preferred); (7) **Biliary drainage** if obstructive jaundice causes complications (cholangitis, severe pruritus, malnutrition, AKI) — endoscopic stenting (ERCP) preferred over percutaneous; metal vs plastic stent decision; preoperative drainage controversial (DROP trial 2010) — not routine if proceeding immediately; (8) Genetic counseling — 10% germline mutations (BRCA1/2, ATM, PALB2 — implications for therapy + family); (9) Performance status optimization, nutritional support; (10) Palliative care concurrent

---

Pancreatic Adenocarcinoma (Pancreatic Ductal Adenocarcinoma, PDAC) — most lethal common cancer (5-year OS ~ 10%) Epidemiology: - 7th leading cause of cancer death in Thailand; 4th in US - Increasing incidence - Risk factors: age, smoking, chronic pancreatitis, family history, diabetes (new-onset in elderly may herald cancer), obesity, BRCA1/2, Peutz-Jeghers, Lynch, FAMMM Clinical presentation depends on location: - **Head (70%)**: painless obstructive jaundice (Courvoisier''s sign), weight loss, dark urine, light stool, pruritus - **Body/tail (30%)**: epigastric pain radiating to back, weight loss; often advanced at presentation Tumor marker: - **CA 19-9** (elevated in 80%): useful for monitoring, not screening; can be elevated in cholangitis, biliary obstruction (non-specific); Lewis-negative population (5%) cannot produce - Other: CEA Diagnosis: - **CT pancreas protocol (triple-phase)** — first-line imaging - **MRI/MRCP** — biliary anatomy, equivocal CT - **EUS** — best for small tumors + FNA biopsy - **Tissue confirmation** via EUS-FNA preferred over percutaneous (lower tract seeding) - **ERCP** — biliary drainage with stenting (not primarily diagnostic) Staging (NCCN 2024 criteria — resectability): 1. **Resectable**: - No arterial contact - ≤ 180° contact with SMV/PV without contour irregularity 2. **Borderline resectable**: - SMV/PV contact > 180° with contour irregularity OR reconstructible occlusion - Solid tumor contact ≤ 180° with SMA, CHA - Aortic contact for body/tail tumors 3. **Locally advanced (unresectable)**: - SMA, celiac > 180° contact - SMV/PV occlusion not reconstructible - Aortic contact (for head) 4. **Metastatic**: distant (liver, peritoneum, lung most common) Management based on stage: A. **Resectable**: - **Surgery first** (Whipple for head; distal pancreatectomy for body/tail) - **Adjuvant chemotherapy**: - mFOLFIRINOX × 12 cycles (PRODIGE-24, Conroy NEJM 2018 — improved OS over gemcitabine) — fit patients - Gemcitabine + capecitabine (ESPAC-4) - Gemcitabine alone (older/less fit) - Adjuvant chemoradiotherapy: controversial (CONKO-001) B. **Borderline resectable** (this case): - **Neoadjuvant therapy first** (current preferred approach per NCCN, ESMO): - **FOLFIRINOX or modified FOLFIRINOX** (preferred for fit) OR **gemcitabine + nab-paclitaxel** - With or without subsequent **chemoradiotherapy** - Restage at 2-4 months — proceed to surgery if responsive - Improves R0 resection rate, OS - PRODIGE-23, PREOPANC, A021501 trials C. **Locally advanced**: - Systemic chemotherapy (FOLFIRINOX or gem/nab-pac) - Possible conversion to surgery in responders D. **Metastatic**: - FOLFIRINOX (PRODIGE-4, Conroy NEJM 2011) - Gemcitabine + nab-paclitaxel (MPACT, Von Hoff NEJM 2013) - Second-line options - Targeted: olaparib (BRCA1/2), pembrolizumab (MSI-high) - Palliative care integration Whipple Procedure (Pancreaticoduodenectomy) — for head/uncinate process tumors: - Resection: pancreatic head + duodenum + distal stomach (classic) or pylorus-preserving (PPPD) + gallbladder + distal CBD + proximal jejunum + lymph nodes - Reconstruction: pancreaticojejunostomy, hepaticojejunostomy, gastrojejunostomy or duodenojejunostomy - High morbidity (30-40%): pancreatic fistula (most common), delayed gastric emptying, hemorrhage, bile leak, infection - Mortality: 1-3% in high-volume centers; up to 10% in low-volume - Volume-outcome relationship (Leapfrog) → centralize in high-volume centers (> 20-50/year) Biliary drainage pre-op: - **Indications**: cholangitis, severe pruritus, AKI from bilirubin, prolonged delay to surgery, malnutrition - **DROP trial (NEJM 2010)** — routine pre-op drainage NOT recommended for resectable; only if symptomatic - **For neoadjuvant** patients: drainage usually needed (long delay) - **Endoscopic stent (ERCP)**: - **Plastic stent**: short-term, frequent occlusion - **Metal stent** (covered or uncovered): longer patency, preferred if expected delay > 2 weeks Genetic counseling: - 10% have germline mutations - BRCA1/2 (PARP inhibitor implications), ATM, PALB2 — actionable Survivorship + palliative: - Concurrent palliative care from diagnosis (Temel JNCI evidence in PDAC) - Symptom management - Nutritional support, pancreatic enzyme replacement therapy (PERT) for exocrine insufficiency - Diabetes management - Psychological support — ตัวเลือก B comprehensive multidisciplinary. A ผิด — palliative alone misses curable intent. C ผิด — borderline resectable benefit from neoadjuvant. D ผิด — chemo alone less effective. E ผิด — RT alone insufficient', NULL,
  'hard', 'hemato_onco', 'review',
  'surgery', 'clinical_decision', 'hemato_onco', 'adult',
  'NCCN Clinical Practice Guidelines: Pancreatic Adenocarcinoma 2024; Conroy T et al. NEJM 2018 (PRODIGE-24); ESMO Clinical Practice Guidelines: Pancreatic Cancer 2023; van der Gaag NA et al. NEJM 2010 (DROP Trial)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 70 ปี underlying T2DM, smoker มาด้วยอาการ painless jaundice ค่อยเป็นค่อยไปใน 3 สัปดาห์ ร่วมกับน้ำหนักลด 6 kg อ่อนเพลีย ปวด epigastrium ร้าวไปหลังเล็กน้อย ปัสสาวะเข้ม อุจจาระสีซีด คันตามตัว

V/S: BP 128/76, HR 88, RR 16, Temp 36.8°C
PE: jaundice + scleral icterus + Courvoisier''s sign (palpable non-tender gallbladder)
ไม่มี ascites หรือ stigmata of chronic liver disease

Lab: Total bili 12.4 (direct 9.8, indirect 2.6), AST 78, ALT 92, ALP 485 (high), GGT 612 (high), Albumin 3.2, INR 1.4, Cr 0.9, CA 19-9 1,240 U/mL (very high, normal < 37)
US abdomen: dilated CBD 14 mm + intrahepatic biliary dilatation + suspicious hypoechoic mass at pancreatic head 3.5 cm
CT abdomen: pancreatic head mass 3.5 cm + biliary obstruction + suspicious peripancreatic + portal vein abutment < 180° (borderline resectable per NCCN criteria)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 32 ปี ถูกรถชนเข้ากับ guardrail ขณะขับมอเตอร์ไซค์ ความเร็ว 80 km/hr มาห้องฉุกเฉิน 30 นาทีหลังเกิดเหตุ ผู้ป่วยรู้สึกตัวดี แต่อ่อนเพลีย หายใจเหนื่อย

V/S: BP 88/56 mmHg, HR 128, RR 28, SpO2 92% on O2 4 L NC, Temp 36.4°C
Primary survey: airway intact (talking), breathing — decreased BS left, dullness to percussion left + tracheal deviation right; circulation: cold extremities, capillary refill 3 sec
C-spine collar in place

FAST: positive free fluid LUQ, negative pericardial
CXR: left hemothorax + multiple left rib fractures (ribs 6-9) + left scapula fracture
Hb 8.6, Type & cross 4 units pending', '[{"label":"A","text":"Observation with serial CXR"},{"label":"B","text":"Hemodynamically unstable blunt chest trauma with massive hemothorax — emergent management"},{"label":"C","text":"CT chest abdomen first, then tube"},{"label":"D","text":"Needle decompression"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hemodynamically unstable blunt chest trauma with massive hemothorax — emergent management: (1) **Tube thoracostomy (chest tube)** — large-bore (28-32 Fr) at 5th ICS midaxillary line on left; (2) **Indications for emergent thoracotomy** in massive hemothorax: initial drainage > 1.5 L (or > 20 mL/kg) OR continued bleeding > 200 mL/hr × 3-4 hr OR > 1.5-2.0 L/24 hr OR hemodynamic instability not responsive to chest tube + resuscitation; (3) **Concurrent abdominal evaluation** — positive FAST suggests intra-abdominal source — likely needs laparotomy + thoracotomy combination; (4) Massive transfusion protocol 1:1:1 (PRC:FFP:Plt); permissive hypotension target SBP 80-90 until bleeding controlled; (5) **Multiple rib fractures + chest wall injury management**: pain control (intercostal block, thoracic epidural, multimodal analgesic — avoid pure opioid in CHI), pulmonary toilet (incentive spirometry), early mobilization, mechanical ventilation if respiratory failure; (6) Tetanus prophylaxis; (7) Trauma team + thoracic surgery + general surgery consult

---

Blunt chest trauma with massive hemothorax + hemodynamic instability + likely concurrent abdominal injury Massive hemothorax: > 1500 mL of blood in pleural space (or > 20 mL/kg, or > 1/3 blood volume) ATLS 10th Edition + EAST + WSES management: 1. **Primary Survey (ABCDE)**: - **A**irway with C-spine - **B**reathing: O2, assess for ventilatory failure → consider intubation - **C**irculation: 2 large-bore IV, type & cross, MTP if indicated - **D**isability - **E**xposure 2. **Tube Thoracostomy** (chest tube): - **Indications**: pneumothorax, hemothorax, hemopneumothorax in trauma - **Size**: 28-32 Fr large bore (older recommendations; smaller 14-28 Fr increasingly accepted per recent evidence) - **Site**: 5th intercostal space, mid-axillary line ("safe triangle") - **Direction**: posterior + superior - **Connection**: underwater seal drainage + suction (-20 cm H2O typical) 3. **Indications for Emergent Thoracotomy** (massive hemothorax): - **Initial chest tube output > 1.5 L** (or > 20 mL/kg in pediatrics) - **Continued output > 200 mL/hr × 3-4 hr** (or > 1.5-2.0 L/24 hr) - **Hemodynamic instability** despite chest tube + resuscitation - **Massive air leak** suggesting tracheobronchial injury - **Cardiac tamponade** despite pericardial window/pericardiocentesis - **Penetrating cardiac injury** - **Esophageal injury** (large) - **Diaphragm rupture** - **Aortic transection** (now mostly endovascular — TEVAR) 4. **Massive Transfusion Protocol (MTP)**: - **1:1:1 ratio** (PRC:FFP:Platelets) per PROPPR trial 2015 - Activation criteria (ABC score, shock index, ROTEM/TEG-guided) - **Permissive hypotension** SBP 80-90 mmHg until bleeding controlled (avoid dilution of clotting factors + clot disruption) - **Tranexamic acid (TXA)** 1 g IV bolus within 3 hours of injury → 1 g over 8 hr (CRASH-2 trial) - **Damage control resuscitation** principles 5. **Damage Control Surgery** (in extremis): - Control hemorrhage + contamination - Temporary closure - ICU resuscitation - Return for definitive operation 24-72 hr later 6. **Concurrent injuries**: - **Positive FAST** + chest tube + abdominal source = combined chest/abdominal injury - May need laparotomy + thoracotomy simultaneously or sequentially 7. **Multiple Rib Fractures** management: - **Pain control essential** (inadequate analgesia → splinting, atelectasis, pneumonia, respiratory failure): - **Thoracic epidural** (gold standard for multiple rib fractures, paravertebral blocks alternative) - **Intercostal nerve block** - **Multimodal analgesia**: NSAIDs (caution renal/bleeding), acetaminophen, opioids - **Pulmonary toilet**: incentive spirometry, chest physiotherapy, ambulation - **Mechanical ventilation** if respiratory failure - **Surgical rib fixation** considered in: flail chest, ≥ 3 displaced rib fractures, pain not controlled, non-union (RIBSCORE) 8. **Flail Chest**: - ≥ 3 adjacent rib fractures in 2+ places creating free segment - Paradoxic chest wall movement during respiration - Often associated pulmonary contusion - Treatment: pain control + pulmonary toilet + selective ventilation; surgical fixation (Cochrane evidence shorter ICU/ventilation) 9. **Pulmonary Contusion**: - Pulmonary parenchymal injury without laceration - Often associated with rib fractures - Manifests 24-72 hr post-injury: hypoxia, infiltrate on CXR/CT - Management: O2, pulmonary toilet, restricted IV fluid (avoid worsening edema), mechanical ventilation if needed 10. **Other Chest Trauma Considerations**: - **Tension pneumothorax**: needle decompression then chest tube - **Open pneumothorax**: occlusive dressing (3-sided) then chest tube - **Cardiac tamponade**: pericardiocentesis bridge to OR - **Cardiac contusion**: monitor, EKG, troponin - **Aortic injury**: CT angiogram, TEVAR (endovascular preferred) - **Tracheobronchial injury**: bronchoscopy, surgical repair Outcome: Mortality of massive hemothorax requiring thoracotomy: 20-30% Concurrent abdominal injuries increase mortality significantly — ตัวเลือก B comprehensive. A ผิดอย่างยิ่ง. C ผิด — unstable patient cannot wait for CT. D ผิด — needle decompression for tension pneumothorax not hemothorax. E ผิดอย่างยิ่ง', NULL,
  'medium', 'trauma', 'review',
  'surgery', 'clinical_decision', 'trauma', 'adult',
  'ATLS Advanced Trauma Life Support 10th Edition; EAST Practice Management Guidelines: Hemothorax; WSES Guidelines for Chest Trauma; PROPPR Trial JAMA 2015', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 32 ปี ถูกรถชนเข้ากับ guardrail ขณะขับมอเตอร์ไซค์ ความเร็ว 80 km/hr มาห้องฉุกเฉิน 30 นาทีหลังเกิดเหตุ ผู้ป่วยรู้สึกตัวดี แต่อ่อนเพลีย หายใจเหนื่อย

V/S: BP 88/56 mmHg, HR 128, RR 28, SpO2 92% on O2 4 L NC, Temp 36.4°C
Primary survey: airway intact (talking), breathing — decreased BS left, dullness to percussion left + tracheal deviation right; circulation: cold extremities, capillary refill 3 sec
C-spine collar in place

FAST: positive free fluid LUQ, negative pericardial
CXR: left hemothorax + multiple left rib fractures (ribs 6-9) + left scapula fracture
Hb 8.6, Type & cross 4 units pending'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 58 ปี ไม่มีโรคประจำตัว มาด้วยอาการ severe abdominal pain เริ่ม mid-epigastrium acute onset 2 ชั่วโมง ปวดอย่างรุนแรง 10/10 แล้วลามทั่วท้อง ไม่อาเจียน

V/S: BP 88/54, HR 124, RR 28, Temp 37.6°C
Abdomen: distended, rigid "board-like" abdomen, generalized peritonitis, absent bowel sounds, percussion: tympanic over liver (loss of hepatic dullness)

Lab: WBC 18,500 (left shift), Hb 13.8, Lactate 4.2, Cr 1.4
Upright CXR: free air under right hemidiaphragm (pneumoperitoneum)
CT abdomen with IV contrast: free intraperitoneal air + free fluid + extraluminal contrast extravasation from anterior duodenum

History: chronic NSAIDs use for back pain × 1 year, no PUD history, alcohol social', '[{"label":"A","text":"Conservative management with NPO + IV PPI + observe"},{"label":"B","text":"Perforated peptic ulcer (likely anterior duodenal) with generalized peritonitis + septic shock — surgical emergency"},{"label":"C","text":"Endoscopic clipping of perforation"},{"label":"D","text":"Total gastrectomy"},{"label":"E","text":"ERCP"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Perforated peptic ulcer (likely anterior duodenal) with generalized peritonitis + septic shock — surgical emergency: (1) **Aggressive resuscitation**: 2 large-bore IV, crystalloid bolus 30 mL/kg, vasopressors (norepinephrine) if persistent hypotension, antibiotics — broad-spectrum empirical (e.g., piperacillin-tazobactam OR cefepime + metronidazole) within 1 hour (Surviving Sepsis); (2) NPO, NG tube decompression; (3) **Emergent surgery** — laparoscopic vs open primary closure (Graham omental patch) + peritoneal lavage; (4) Test for **H. pylori** (biopsy or serology, treat if positive — eradication reduces recurrence > 5×); (5) Hold/discontinue NSAIDs; (6) Postoperative **PPI long-term** if NSAID continuation necessary; (7) Discuss long-term ulcer prevention strategies + lifestyle; (8) Surgical management options: most cases of perforated peptic ulcer treated with primary closure + omental patch; definitive ulcer surgery (truncal vagotomy + drainage, or vagotomy + antrectomy) reserved for refractory/recurrent cases in PPI era

---

Perforated Peptic Ulcer (PPU) — surgical emergency Etiology: - **H. pylori infection** (declining role with treatment) - **NSAIDs/aspirin** — increasing role (this patient!) - Smoking, stress (Cushing/Curling ulcers — head trauma, burns) - Zollinger-Ellison syndrome (gastrinoma) - Severe physiologic stress (ICU, burns) Locations: - **Duodenal (most common)**: anterior — perforates into peritoneal cavity; posterior — erodes into gastroduodenal artery (UGIB) - **Gastric**: typically lesser curvature angularis Clinical features (classic triad — present in 80%): 1. **Sudden severe abdominal pain** ("like a knife," often mid-epigastric initially → generalized) 2. **Generalized abdominal rigidity** ("board-like abdomen," peritonitis) 3. **Tachycardia + signs of shock** Other findings: - Loss of hepatic dullness (free air over liver — Jobert''s sign) - Absent bowel sounds - Rebound tenderness, guarding - Sepsis features Imaging: - **Upright CXR or left lateral decubitus abdominal X-ray**: free air under diaphragm (sensitivity 70-80%) - **CT abdomen with contrast** (preferred): more sensitive, identifies free air, extraluminal contrast (if water-soluble PO), site of perforation, complications - **Ultrasound**: less sensitive Lab: - Leukocytosis with left shift - Elevated lactate (sepsis) - AKI possible Management: 1. **Resuscitation** (Surviving Sepsis 2021): - Crystalloid 30 mL/kg within 3 hours - Vasopressor (norepinephrine) if MAP < 65 despite fluid - Source control - **Broad-spectrum antibiotics within 1 hour** of recognition - Lactate clearance - ScVO2 + urine output goals 2. **Empirical antibiotics** (cover GI flora + anaerobes): - **First-line**: piperacillin-tazobactam, cefepime + metronidazole, or carbapenem - Modify per culture - Duration: 4-7 days (or per source control evidence) 3. **NPO + NG decompression** + IV PPI 4. **Emergent surgery**: a. **Laparoscopic vs Open**: - Laparoscopic increasingly preferred — less pain, faster recovery, equivalent outcomes in selected stable patients (Sanabria meta-analysis) - Open if hemodynamically unstable, surgical expertise unavailable, complex case b. **Procedures**: - **Graham Omental Patch**: most common; greater omentum drawn over perforation + secured with sutures - **Modified Cellan-Jones**: primary closure + omental patch reinforcement - **Resection + reconstruction**: large perforations (> 2 cm), suspicious for malignancy (gastric) - **Definitive antiulcer surgery** (rarely now): - Truncal vagotomy + drainage (pyloroplasty, gastrojejunostomy) - Vagotomy + antrectomy - Indications: refractory ulcer despite optimal medical therapy (rare in PPI era) c. **Damage Control Surgery**: in extremis — control contamination, plan return d. **Peritoneal lavage** with copious warm saline 5. **H. pylori testing + eradication**: - Test (biopsy, urease, serology, urea breath test) - Eradication regimen (triple, quadruple, sequential) - Confirm eradication (UBT or stool antigen) 4 weeks post-therapy - Reduces ulcer recurrence > 5× 6. **NSAID management**: - Discontinue if possible - If essential, switch to COX-2 selective (celecoxib) - Co-prescribe PPI - Caution in cardiovascular disease 7. **Long-term acid suppression**: - **PPI** (omeprazole 20-40 mg/day) — continue for 4-8 weeks for ulcer healing; longer if NSAIDs continued - **H2 blockers** (less effective) - Misoprostol — PG analog (prevents NSAID ulcers) Outcome: - **Mortality**: 5-25% (overall), increases with: age > 65, comorbidities, delayed surgery > 24 hr, large perforation, septic shock - **Complications**: leak (5-10%), abscess, prolonged ileus, wound infection, hospital pneumonia, ARDS Modern approach minimally invasive + non-operative for selected (small, contained perforation in stable patient — "Taylor method" with NG, NPO, IV PPI, antibiotics) — controversial — ตัวเลือก B comprehensive. A ผิดอย่างยิ่ง — generalized peritonitis ต้อง surgery. C ผิด — endoscopic clipping ใช้ใน small contained perforation not generalized. D ผิด — gastrectomy excessive. E ผิด — ERCP for biliary not duodenal', NULL,
  'easy', 'gi', 'review',
  'surgery', 'clinical_decision', 'gi', 'adult',
  'WSES Guidelines: Perforated and Bleeding Peptic Ulcer 2020; Surviving Sepsis Campaign 2021; ACS Surgery: Principles and Practice', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 58 ปี ไม่มีโรคประจำตัว มาด้วยอาการ severe abdominal pain เริ่ม mid-epigastrium acute onset 2 ชั่วโมง ปวดอย่างรุนแรง 10/10 แล้วลามทั่วท้อง ไม่อาเจียน

V/S: BP 88/54, HR 124, RR 28, Temp 37.6°C
Abdomen: distended, rigid "board-like" abdomen, generalized peritonitis, absent bowel sounds, percussion: tympanic over liver (loss of hepatic dullness)

Lab: WBC 18,500 (left shift), Hb 13.8, Lactate 4.2, Cr 1.4
Upright CXR: free air under right hemidiaphragm (pneumoperitoneum)
CT abdomen with IV contrast: free intraperitoneal air + free fluid + extraluminal contrast extravasation from anterior duodenum

History: chronic NSAIDs use for back pain × 1 year, no PUD history, alcohol social'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 45 ปี ไม่มีโรคประจำตัว มาห้องฉุกเฉินด้วยอาการปวด RUQ + ไข้สูง + ตัวเหลือง 24 ชั่วโมงก่อน ก่อนหน้านี้เคยปวดท้องเป็นๆ หายๆ หลังกินอาหารมัน

V/S: BP 88/54 mmHg, HR 128, RR 24, Temp 39.4°C, SpO2 95%
Gen: jaundice + ill-looking + sluggish
GCS 13 (E3V4M6), Murphy''s sign positive
Abdomen: RUQ tenderness, mild peritonitis localized

Lab: WBC 22,500 (PMN 92%), CRP 245, Total bili 6.8 (direct 5.4), AST 188, ALT 142, ALP 485, GGT 612, Albumin 3.1, INR 1.6, Cr 1.8, Lactate 3.8
US abdomen: cholelithiasis + CBD 12 mm + intrahepatic biliary dilatation
CT abdomen: dilated CBD with stone at distal CBD + early intrahepatic biliary dilatation

Reynold''s pentad: RUQ pain + fever + jaundice + altered mental status + hypotension/shock', '[{"label":"A","text":"Wait for serial labs and observation"},{"label":"B","text":"Acute Cholangitis (Reynolds'' pentad — severe/Grade III per Tokyo Guidelines) — surgical-medical emergency"},{"label":"C","text":"Emergency open cholecystectomy alone"},{"label":"D","text":"Discharge with oral antibiotics"},{"label":"E","text":"Hydroxychloroquine empirical"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Cholangitis (Reynolds'' pentad — severe/Grade III per Tokyo Guidelines) — surgical-medical emergency: (1) **Immediate sepsis resuscitation** (Surviving Sepsis): crystalloid 30 mL/kg, vasopressor if hypotensive, source control planning; (2) **Broad-spectrum IV antibiotic within 1 hour** — piperacillin-tazobactam, ceftriaxone + metronidazole, or carbapenem (for severe with prior antibiotic exposure or HCAI); (3) **Urgent biliary drainage** (definitive source control) — **ERCP with sphincterotomy + stone extraction OR stent placement** (preferred — less invasive); if ERCP fails or unavailable: **PTBD (percutaneous transhepatic biliary drainage)** OR **emergency open surgical decompression** (last resort); timing: severe cholangitis (Grade III) within 12-24 hours; (4) Correct coagulopathy (vitamin K, FFP) before procedure; (5) NPO; (6) ICU monitoring; (7) **Delayed (interval) cholecystectomy** 4-6 weeks after acute episode (laparoscopic preferred) for gallstone source; (8) Antibiotic duration: 4-7 days after source control + clinical improvement

---

Acute Cholangitis (Ascending Cholangitis, Charcot''s Cholangitis) — biliary system infection Etiology: bacterial infection of biliary tree, typically due to obstruction Most common organism: gram-negative (E. coli most common, Klebsiella, Enterobacter), enterococcus, anaerobes (especially Bacteroides) Pathophysiology: 1. **Obstruction**: choledocholithiasis (gallstones in CBD — most common cause), stricture (benign, malignant), iatrogenic (stent, ERCP), parasitic (Ascaris, Clonorchis) 2. **Bacterial contamination** from duodenum reflux 3. **Bacteremia** from cholangiovenous reflux (increased biliary pressure) Clinical features: - **Charcot''s Triad** (Sensitivity 50-70%): 1. RUQ pain 2. Fever 3. Jaundice - **Reynolds'' Pentad** (severe — 5-15% but high mortality): 1. RUQ pain 2. Fever 3. Jaundice 4. **Altered mental status / confusion** 5. **Hypotension / shock** Tokyo Guidelines 2018 (TG18) — Diagnostic Criteria (need ≥ 2 of A + ≥ 1 of B + ≥ 1 of C): - **A. Systemic inflammation**: fever (> 38°C) and/or shaking chills; leukocytosis (> 10,000) or CRP elevation - **B. Cholestasis**: jaundice (total bili ≥ 2); abnormal LFTs (ALP, GGT, AST, ALT > 1.5× ULN) - **C. Imaging**: biliary dilatation OR evidence of etiology (stricture, stone, stent) Severity Grading (TG18): - **Grade I (Mild)**: meets criteria, no organ dysfunction - **Grade II (Moderate)**: meets criteria + ≥ 2 of: WBC > 12,000 or < 4,000, fever > 39°C, age > 75, hyperbilirubinemia (TB > 5), hypoalbuminemia - **Grade III (Severe)**: meets criteria + ≥ 1 organ dysfunction: CV (hypotension requiring dopamine ≥ 5 or any norepinephrine), neuro (disturbed consciousness), respiratory (PaO2/FiO2 < 300), renal (oliguria, Cr > 2), hepatic (INR > 1.5), hematologic (Plt < 100,000) Management (Tokyo Guidelines 2018 + ACS): A. **Mild (Grade I)**: - General supportive care, IV fluids - Antibiotic (oral or IV) - **Elective biliary drainage** (ERCP) within 24-48 hours after response - **Cholecystectomy** elective for gallstones B. **Moderate (Grade II)**: - IV fluids + antibiotics - **Early biliary drainage within 24 hours** - Source control + drainage C. **Severe (Grade III)** (this patient): - **Sepsis resuscitation** (Surviving Sepsis 1-hour bundle) - **Urgent IV antibiotics within 1 hour** - **Urgent biliary drainage within 12-24 hours** - ICU monitoring 1. **Antibiotic selection** (TG18 + community vs healthcare-associated): - **Community-acquired Mild-Moderate**: - Ampicillin-sulbactam, ceftriaxone, ciprofloxacin + metronidazole, cefoxitin - **Community-acquired Severe**: - **Piperacillin-tazobactam**, cefepime + metronidazole, levofloxacin + metronidazole - **Healthcare-associated or prior antibiotic**: - **Carbapenem** (meropenem, imipenem, ertapenem) +/- vancomycin (cover Enterococcus, MRSA risk) - **Antifungal**: candidemia risk in selected (immunocompromised, prolonged ICU, broad antibiotic use, candida growth) - **Duration**: - With source control: 4-7 days post-procedure - Without source control: longer 2. **Biliary Drainage** (definitive source control): a. **ERCP with sphincterotomy + stone removal**: - First-line approach - Success rate > 90% for stones - Procedure includes: sphincterotomy, balloon/basket extraction, lithotripsy if large, stent if residual or stricture b. **PTBD (Percutaneous Transhepatic Biliary Drainage)**: - When ERCP fails or unavailable - Hilar obstruction better drained by PTBD - More invasive c. **Open surgical decompression** (T-tube, choledochoduodenostomy): - Last resort - High morbidity in unstable patient d. **EUS-guided biliary drainage**: emerging alternative 3. **Adjunctive Care**: - **Correct coagulopathy** before invasive procedure: vitamin K (slow correction), FFP (rapid), platelets if < 50,000 - **NPO** - **Pain control** (avoid opioids that may worsen biliary pressure — meperidine traditional but lacks evidence; multimodal analgesia preferred) - **Electrolyte correction** - **VTE prophylaxis** when bleeding risk acceptable 4. **Cholecystectomy** (for gallstone source — "interval cholecystectomy"): - Laparoscopic preferred - Timing: 4-6 weeks after acute episode resolved - Prevents recurrence (50% within 1 year) - Some advocate during same admission if stable (debated) Complications: - Hepatic abscess, sepsis, MOF, ARDS, AKI - Bleeding from sphincterotomy (5%), pancreatitis from ERCP (3-5%), perforation (1%) Outcome: - Mortality overall: 5-10% - Mortality Grade III without urgent drainage: 30-50% - Early aggressive intervention saves lives — ตัวเลือก B comprehensive. A ผิดอย่างยิ่ง — severe sepsis cannot wait. C ผิด — cholecystectomy alone doesn''t address CBD obstruction. D ผิด — severe disease cannot be outpatient. E ผิดอย่างยิ่ง', NULL,
  'medium', 'gi', 'review',
  'surgery', 'clinical_decision', 'gi', 'adult',
  'Tokyo Guidelines 2018 (TG18) for Acute Cholangitis (J Hepatobiliary Pancreat Sci); Surviving Sepsis Campaign 2021; WSES Guidelines for Acute Calculous Cholecystitis 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 45 ปี ไม่มีโรคประจำตัว มาห้องฉุกเฉินด้วยอาการปวด RUQ + ไข้สูง + ตัวเหลือง 24 ชั่วโมงก่อน ก่อนหน้านี้เคยปวดท้องเป็นๆ หายๆ หลังกินอาหารมัน

V/S: BP 88/54 mmHg, HR 128, RR 24, Temp 39.4°C, SpO2 95%
Gen: jaundice + ill-looking + sluggish
GCS 13 (E3V4M6), Murphy''s sign positive
Abdomen: RUQ tenderness, mild peritonitis localized

Lab: WBC 22,500 (PMN 92%), CRP 245, Total bili 6.8 (direct 5.4), AST 188, ALT 142, ALP 485, GGT 612, Albumin 3.1, INR 1.6, Cr 1.8, Lactate 3.8
US abdomen: cholelithiasis + CBD 12 mm + intrahepatic biliary dilatation
CT abdomen: dilated CBD with stone at distal CBD + early intrahepatic biliary dilatation

Reynold''s pentad: RUQ pain + fever + jaundice + altered mental status + hypotension/shock'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 55 ปี ตรวจสุขภาพประจำปีคลำพบ thyroid nodule ขนาด 3 cm ที่ right lobe ผู้ป่วยไม่มีอาการ ไม่มี hyperthyroidism symptoms

V/S: ปกติ; ไม่มี cervical lymphadenopathy
TFT: TSH 2.4 (normal), Free T4 1.1 (normal)
US thyroid: hypoechoic 3.2 cm solid nodule ที่ right lobe with microcalcifications + irregular margins + taller-than-wide shape (TI-RADS 5 high suspicion); no abnormal cervical lymph nodes

FNAB ผ่าน US guidance: Bethesda Category VI (Malignant) — Papillary Thyroid Carcinoma (PTC), classical variant', '[{"label":"A","text":"Observation with serial US"},{"label":"B","text":"Differentiated thyroid cancer (PTC) — multidisciplinary management"},{"label":"C","text":"Total parathyroidectomy"},{"label":"D","text":"Chemotherapy first"},{"label":"E","text":"Hospice care"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Differentiated thyroid cancer (PTC) — multidisciplinary management: (1) **Surgery**: Total thyroidectomy preferred over lobectomy if tumor > 4 cm, gross extrathyroidal extension, clinical nodal metastasis, or distant metastasis; selected lower-risk PTC 1-4 cm may consider lobectomy (ATA 2015); concurrent central neck dissection (level VI) recommended for clinically positive nodes or T3-T4; lateral neck dissection only if biopsy-proven; (2) **Postoperative TSH suppression therapy** with levothyroxine — degree depends on risk stratification (high-risk: TSH < 0.1; intermediate: 0.1-0.5; low-risk: 0.5-2); (3) **Radioactive iodine (RAI, I-131)** indication based on ATA risk stratification: high-risk routinely; intermediate-risk selectively; low-risk usually omitted; (4) Long-term surveillance: TSH + Tg + anti-Tg antibodies + neck US periodically; rising Tg = potential recurrence; (5) Pathology review for high-risk features: extrathyroidal extension, vascular invasion, large nodes, distant mets; (6) Genetic considerations: BRAF V600E mutation (sporadic) — possible targeted therapy for advanced; RET mutations for medullary (different cancer); (7) Multidisciplinary tumor board for complex cases

---

Papillary Thyroid Carcinoma (PTC) — most common thyroid malignancy (80% of all thyroid cancers) Differentiated Thyroid Cancers (DTC): - **Papillary (PTC)**: 80% — best prognosis - **Follicular (FTC)**: 10-15% — older, hematogenous spread (bone, lung) - **Hürthle cell**: variant of follicular - **Poorly differentiated**: aggressive Other thyroid cancers: - **Medullary (MTC)**: 5%, parafollicular C cells, calcitonin marker, hereditary 25% (MEN2) - **Anaplastic (ATC)**: < 2%, highly aggressive, > 90% mortality - **Lymphoma**: rare Risk factors: - Female (3:1), age 30-50 (peak), childhood radiation exposure, family history (MEN2), genetic syndromes (Cowden, FAP) Clinical features: - **Asymptomatic thyroid nodule** (most common) - Hoarseness (recurrent laryngeal nerve invasion) - Cervical lymphadenopathy - Dyspnea, dysphagia (large tumors) - Rarely: paraneoplastic syndromes ATA 2015 Guidelines for evaluation of thyroid nodule: 1. **Thyroid US + TI-RADS classification**: - TI-RADS 1: Benign (no FNA) - TI-RADS 2: Not suspicious - TI-RADS 3: Mildly suspicious (FNA if ≥ 2.5 cm; follow if ≥ 1.5 cm) - TI-RADS 4: Moderately suspicious (FNA if ≥ 1.5 cm; follow if ≥ 1 cm) - TI-RADS 5: Highly suspicious (FNA if ≥ 1 cm) Suspicious US features: hypoechoic, microcalcifications, irregular margins, taller-than-wide, abnormal lymph nodes 2. **Bethesda Classification** (FNA cytology): - I: Non-diagnostic (1-4% malignancy) — repeat - II: Benign (0-3% malignancy) - III: AUS/FLUS (5-15% malignancy) - IV: FN/SFN (15-30%) - V: Suspicious for malignancy (60-75%) - VI: Malignant (97-99%) — this patient Surgical Management (ATA 2015): A. **Total Thyroidectomy** preferred when: - Tumor > 4 cm - Gross extrathyroidal extension - Clinical nodal or distant metastasis - Multifocal or bilateral disease - High-risk variants (tall cell, columnar cell, hobnail) - Prior radiation B. **Lobectomy** acceptable in selected: - Unilateral 1-4 cm PTC - No nodal or distant metastasis - No extrathyroidal extension - No prior radiation - Patient preference C. **Lymph Node Dissection**: - **Therapeutic central neck dissection (level VI)**: clinically positive nodes - **Prophylactic central neck dissection**: controversial — recommended for T3-T4, advanced age, considering RAI - **Lateral neck dissection (levels II-V)**: biopsy-proven involvement; no prophylactic D. **Complications**: - **Hypocalcemia** from parathyroid injury (transient 5-10%, permanent 1-3%) — replace calcium + calcitriol - **Recurrent laryngeal nerve injury** → hoarseness (transient 5%, permanent 1%) - Hematoma (compromise airway, urgent evacuation) - Hypothyroidism (universal after total → levothyroxine replacement) Postoperative Management: 1. **TSH Suppression** with levothyroxine: - Goal based on ATA risk: - **Low-risk**: TSH 0.5-2 - **Intermediate-risk**: TSH 0.1-0.5 - **High-risk**: TSH < 0.1 - Lifelong typically (lower TSH = less recurrence but more bone loss + AF) 2. **Radioactive Iodine (RAI, I-131) Ablation**: - **ATA Risk Stratification**: - **Low risk**: intrathyroidal, no aggressive features, no nodes, no extension — RAI usually omitted - **Intermediate risk**: microscopic extension, aggressive variants, vascular invasion, small node mets — selective RAI - **High risk**: gross extrathyroidal extension, distant mets, > 5 large nodes — RAI routinely - Dose: 30-150 mCi based on risk - Preparation: low-iodine diet, TSH stimulation (recombinant TSH or thyroid hormone withdrawal) - Side effects: sialadenitis, dry mouth, nausea, secondary cancer risk (controversial low) 3. **Surveillance**: - **TSH + Free T4** q6 weeks initially, then q6-12 months - **Thyroglobulin (Tg)** + anti-Tg antibodies — sensitive marker of residual/recurrent disease after total thyroidectomy + RAI (should be undetectable) - **Neck US** q6-12 months × 1-2 years, then q1-3 years - **CT/MRI** for symptoms or rising Tg with negative US - **PET-CT** for high-risk surveillance, suspected recurrence Advanced/Metastatic PTC: - **Radioiodine-refractory**: targeted therapy - **Sorafenib, lenvatinib** (multikinase TKIs) — FDA approved - **Selpercatinib, pralsetinib** for RET-altered (rare in PTC) - **Dabrafenib + trametinib** for BRAF V600E (selected) - **Embolization, RFA, SBRT** for local control - **External beam RT**: locally advanced, unresectable Prognosis: - **PTC**: 10-year OS > 95% in localized; 60% in distant mets - **Excellent in young** patients (< 55) - **Poor prognostic factors**: age > 55, large tumor, extrathyroidal extension, distant metastasis, high-risk variants Staging (AJCC 8th edition): - Age cutoff 55 (recently updated from 45) - Stage I/II for < 55 unless distant mets - Stage III/IV reserved for older + advanced — ตัวเลือก B comprehensive. A ผิด — biopsy malignant cannot observe. C ผิด — confused with parathyroid. D ผิด — chemo not first-line in DTC. E ผิด — curable cancer', NULL,
  'medium', 'hemato_onco', 'review',
  'surgery', 'clinical_decision', 'hemato_onco', 'adult',
  'American Thyroid Association Management Guidelines for Adult Patients with Thyroid Nodules and Differentiated Thyroid Cancer 2015 (Haugen BR et al. Thyroid); ATA Guideline for the Management of Anaplastic Thyroid Cancer 2021; NCCN Thyroid Carcinoma 2024', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 55 ปี ตรวจสุขภาพประจำปีคลำพบ thyroid nodule ขนาด 3 cm ที่ right lobe ผู้ป่วยไม่มีอาการ ไม่มี hyperthyroidism symptoms

V/S: ปกติ; ไม่มี cervical lymphadenopathy
TFT: TSH 2.4 (normal), Free T4 1.1 (normal)
US thyroid: hypoechoic 3.2 cm solid nodule ที่ right lobe with microcalcifications + irregular margins + taller-than-wide shape (TI-RADS 5 high suspicion); no abnormal cervical lymph nodes

FNAB ผ่าน US guidance: Bethesda Category VI (Malignant) — Papillary Thyroid Carcinoma (PTC), classical variant'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 68 ปี underlying CHF, AF on warfarin มาห้องฉุกเฉินด้วยอาการปวดท้อง diffuse acute onset 4 ชั่วโมงก่อน อาเจียน 2 ครั้ง ไม่มีไข้

V/S: BP 102/64, HR 122 (irregular), RR 22, Temp 36.8°C, SpO2 96%
Abdomen: distended, tenderness diffuse, ไม่มี peritoneal signs ในขั้นแรก, อาการดูไม่สมกับ pain ("pain out of proportion to exam")

Lab: WBC 18,500, Lactate 5.4, Cr 1.4, INR 2.4 (subtherapeutic), Hb 12.4
Lactic acid is very high; metabolic acidosis pH 7.28
CT angiogram abdomen: SMA filling defect (embolic occlusion) + bowel wall thickening + pneumatosis intestinalis early', '[{"label":"A","text":"Conservative observation with serial exams"},{"label":"B","text":"Acute Mesenteric Ischemia (likely embolic from AF) — \"pain out of proportion\" classic + elevated lactate + CT angiogram diagnostic; surgical-vascular emergency"},{"label":"C","text":"Endoscopic colonoscopy"},{"label":"D","text":"ERCP"},{"label":"E","text":"Discharge with antiemetics"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Mesenteric Ischemia (likely embolic from AF) — "pain out of proportion" classic + elevated lactate + CT angiogram diagnostic; surgical-vascular emergency: (1) **Resuscitation**: aggressive IV fluid, correct acidosis, vasopressor cautiously (avoid mesenteric vasoconstrictors — preferably norepinephrine if needed); (2) **Empirical antibiotics**: broad-spectrum (cefoxitin or piperacillin-tazobactam); (3) **Anticoagulation**: IV heparin therapeutic; (4) **Definitive revascularization**: - **Endovascular** (preferred increasingly): catheter-directed thrombolysis + thrombectomy + stenting — best for early presentation, focal lesion, viable bowel; - **Surgical embolectomy + exploration laparotomy** when peritonitis present, late presentation, or extensive infarction — assess bowel viability + resect non-viable + consider second-look 24-48 hr; (5) Multidisciplinary: vascular surgery + general surgery + IR + ICU; (6) Long-term anticoagulation for AF (also for thrombotic etiology); (7) Identify embolic source (echocardiogram); (8) ICU monitoring postop — high mortality 50-70% overall, lower with early intervention

---

Acute Mesenteric Ischemia (AMI) — vascular emergency with high mortality (50-80%) Etiology: 1. **Arterial embolism** (40-50%) — usually from cardiac source (AF, post-MI mural thrombus, valve disease, atrial myxoma) — SMA most common; lodges 3-10 cm distal to origin 2. **Arterial thrombosis** (25-30%) — atherosclerotic; often history of postprandial pain, weight loss (chronic mesenteric ischemia preceded) 3. **Mesenteric venous thrombosis (MVT)** (10%) — hypercoagulable, cirrhosis, malignancy, OCP — subacute presentation 4. **Non-occlusive mesenteric ischemia (NOMI)** (15-25%) — low-flow state (shock, cardiac failure, vasopressor use, dialysis) Clinical features: - **"Pain out of proportion to physical exam"** (classic) — severe pain with minimal findings early - Vomiting, diarrhea (often bloody late) - Abdominal distension - Late: peritonitis, hemodynamic instability - **Triad**: severe abdominal pain + AF (or vasculopathy) + emptying of bowel Risk factors: - **Embolism**: AF (most), recent MI, valvular disease, atrial myxoma, endocarditis - **Thrombosis**: atherosclerosis, smoking, dyslipidemia - **MVT**: thrombophilia, malignancy, intra-abdominal infection, cirrhosis, OCP - **NOMI**: shock, vasopressors, dialysis, advanced CHF Diagnosis: - **Lab**: elevated lactate (late), WBC, metabolic acidosis, elevated D-dimer (sensitive but non-specific) - **CT angiogram (CTA) abdomen-pelvis with contrast** — gold standard - **Conventional angiography** — diagnostic + therapeutic (endovascular intervention) - **MR angiography** — alternative if contrast contraindicated CT findings: - Filling defect in SMA/IMA (embolus, thrombus) - Bowel wall thickening - **Pneumatosis intestinalis** (air in bowel wall — late, ischemic injury) - Portal venous gas (very late, advanced) - Free fluid - Reduced bowel enhancement Management (ESVS + AAST + WSES guidelines): A. **Resuscitation**: - Aggressive IV fluid - Correct electrolytes + acidosis - Cautious vasopressors (norepinephrine preferred over alpha agonists) - Avoid digoxin (vasoconstriction) - **Broad-spectrum antibiotic** (cefoxitin, piperacillin-tazobactam, ertapenem) — gut translocation - **Therapeutic anticoagulation** (IV heparin) — embolic + thrombotic types - NG decompression - NPO B. **Revascularization** (time-sensitive — every hour delay reduces salvageable bowel): 1. **Endovascular** (preferred increasingly, ESVS Class I): - Catheter-directed thrombolysis (alteplase) - Mechanical thrombectomy - Angioplasty + stent - Indications: early presentation, viable bowel, no peritonitis, suitable anatomy 2. **Open surgical embolectomy + laparotomy**: - Indications: peritonitis, late presentation, extensive infarction, failed endovascular - SMA embolectomy with Fogarty catheter - Assess bowel viability: pulsation, peristalsis, color, fluorescein/Doppler - Resect non-viable bowel - **Second-look laparotomy** 24-48 hr to reassess marginally viable segments - Damage control if unstable C. **MVT specifically**: - Anticoagulation alone often sufficient if no peritonitis + bowel viable - Thrombolysis selected - Surgery if bowel ischemia/infarction D. **NOMI**: - Treat underlying low-flow state - Intra-arterial papaverine (vasodilator) - Surgery for infarction Post-operative: 1. ICU 2. Continue anticoagulation 3. Nutritional support (TPN if extensive resection — short bowel syndrome) 4. Antibiotics 5. Surveillance for short bowel syndrome, anastomotic leak Long-term: - Identify + treat embolic source (echo, EKG, cardiology) - Long-term anticoagulation (warfarin or DOAC) per cause - Atherosclerosis risk factor modification Prognosis: - **Mortality**: overall 50-70%, drops to 20-30% with early intervention - **Survival predictors**: time to revascularization, age, comorbidities, bowel salvageability, lactate level — ตัวเลือก B comprehensive. A ผิดอย่างยิ่ง — observation = bowel death + sepsis. C ผิด — colonoscopy contraindicated in suspected ischemia (perforation risk). D ผิด — ERCP for biliary. E ผิดอย่างยิ่ง', NULL,
  'medium', 'gi', 'review',
  'surgery', 'clinical_decision', 'gi', 'adult',
  'ESVS Clinical Practice Guidelines on the Management of Acute Mesenteric Ischemia 2017; AAST/ACS Guidelines; WSES Guidelines on Mesenteric Ischemia', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 68 ปี underlying CHF, AF on warfarin มาห้องฉุกเฉินด้วยอาการปวดท้อง diffuse acute onset 4 ชั่วโมงก่อน อาเจียน 2 ครั้ง ไม่มีไข้

V/S: BP 102/64, HR 122 (irregular), RR 22, Temp 36.8°C, SpO2 96%
Abdomen: distended, tenderness diffuse, ไม่มี peritoneal signs ในขั้นแรก, อาการดูไม่สมกับ pain ("pain out of proportion to exam")

Lab: WBC 18,500, Lactate 5.4, Cr 1.4, INR 2.4 (subtherapeutic), Hb 12.4
Lactic acid is very high; metabolic acidosis pH 7.28
CT angiogram abdomen: SMA filling defect (embolic occlusion) + bowel wall thickening + pneumatosis intestinalis early'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 42 ปี ใต้ผิวหนังที่ต้นขาขวามี swelling + redness + รุนแรงปวด, เริ่ม 36 ชั่วโมงก่อน เริ่มมีไข้ ต่อมา 12 ชั่วโมงปวดมากขึ้น + skin discoloration

Underlying: DM type 2, ไม่ compliance ยา, baseline HbA1c 11%

V/S: BP 88/52, HR 138, RR 28, Temp 39.4°C, SpO2 96%
Gen: ill-appearing, septic
Thigh: extensive erythema 25 × 18 cm, bullae with hemorrhagic fluid, dusky skin discoloration in center, crepitus on palpation, severe pain out of proportion + ตึงตามขาเป็นวงกว้าง, exam findings limited by extreme pain

Lab: WBC 22,500 (left shift), Hb 12.4, Plt 89,000, Cr 2.4, Lactate 5.6, Glucose 488, ABG pH 7.18, LDH 850, CK 12,400, Na 130, CRP > 250
LRINEC score = 11 (high suspicion for necrotizing fasciitis)
X-ray plain: subcutaneous gas in thigh + along fascial planes
Ultrasound bedside: hyperechoic + acoustic shadowing (gas) + fluid along fascia', '[{"label":"A","text":"Antibiotic alone + observation"},{"label":"B","text":"Necrotizing Fasciitis (NF, likely Type II — gas-forming, possibly polymicrobial in DM) — surgical-medical emergency"},{"label":"C","text":"Topical antibiotic + warm compress"},{"label":"D","text":"Diuretic for swelling"},{"label":"E","text":"Discharge with oral antibiotics"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Necrotizing Fasciitis (NF, likely Type II — gas-forming, possibly polymicrobial in DM) — surgical-medical emergency: (1) **Resuscitation**: aggressive IV fluid, correct DKA + hyperglycemia + electrolytes, vasopressors if needed, ICU; (2) **Broad-spectrum antibiotic within 1 hour** — combination: carbapenem (or piperacillin-tazobactam) + vancomycin (MRSA coverage) + clindamycin (toxin suppression — anti-Streptococcus); (3) **EMERGENT surgical debridement** (within hours — every hour delay increases mortality) — wide aggressive debridement of all necrotic + non-viable tissue, leave wound open, return for repeat debridement q12-24 hr until healthy tissue margins; (4) Adjuncts: **IVIG** in toxic shock or severe Group A Strep NF; **hyperbaric oxygen** controversial — selected centers; (5) Multidisciplinary: surgery + ID + ICU + plastic surgery (reconstruction); (6) Tetanus prophylaxis; (7) Source control critical — antibiotic alone fails; (8) Mortality 25-30% even with optimal care; consider amputation if extensive limb involvement

---

Necrotizing Soft Tissue Infections (NSTI), including Necrotizing Fasciitis (NF) — surgical emergency; rapidly fatal if delayed Types: 1. **Type I — Polymicrobial** (60-70%): mixed gram-positive, gram-negative, anaerobes; in DM, immunocompromised, post-surgical, IVDU 2. **Type II — Group A Streptococcus** ("flesh-eating") +/- Staphylococcus aureus (including MRSA); often in young healthy + minor trauma 3. **Type III — Vibrio** (saltwater exposure, raw shellfish, in immunocompromised/cirrhosis) 4. **Type IV — Fungal** (rare, post-traumatic, immunocompromised) 5. **Special forms**: - **Fournier''s gangrene**: perineal NSTI, often polymicrobial - **Clostridial myonecrosis (gas gangrene)**: Clostridium perfringens, traumatic/post-op, gas formation Risk factors: - DM, immunocompromise, malignancy, IVDU, alcohol, peripheral vascular disease, recent surgery, trauma, IV drug use, NSAIDs (controversial — may mask symptoms) Clinical features: - **Severe pain out of proportion to physical findings** (classic — early) - Erythema, swelling - Skin changes: dusky/violaceous discoloration, bullae (hemorrhagic), necrosis (late) - **Crepitus** (gas in soft tissue) — late, specific - Systemic toxicity: high fever, hypotension, multi-organ failure - Rapid progression (hours) Diagnostic clues: - **LRINEC Score** (Laboratory Risk Indicator for Necrotizing Fasciitis): CRP, WBC, Hb, Na, Cr, Glucose - LRINEC ≥ 6: suspect NF; ≥ 8: NF likely (this patient: 11) - **Imaging**: - **Plain X-ray**: subcutaneous gas (Type IV pathognomonic, but late) - **CT** (preferred): gas, fluid, fascial thickening, asymmetric soft tissue enhancement - **MRI**: most sensitive but time-consuming Note: imaging delays surgical exploration — if high suspicion, do not delay surgery for imaging Management (IDSA + WSES NSTI guidelines): 1. **Resuscitation**: - Aggressive IV fluid (often 30 mL/kg + ongoing) - Correct electrolytes, glycemic control - Vasopressor (norepinephrine) for hypotension - ICU monitoring 2. **Empirical Broad-spectrum Antibiotics within 1 hour**: - **Carbapenem** (meropenem, ertapenem) OR **piperacillin-tazobactam** (broad gram-negative + anaerobes) - PLUS **Vancomycin or linezolid** (MRSA coverage) - PLUS **Clindamycin** (toxin suppression — anti-streptococcal, anti-toxin) - **Type III suspicion (Vibrio)**: add doxycycline or ceftriaxone (or fluoroquinolone) - Modify based on culture + sensitivities - Duration: 14 days or longer if extensive 3. **EMERGENT Surgical Debridement** (cornerstone — within hours): - **Wide, aggressive debridement** of all necrotic + non-viable + suspicious tissue down to healthy bleeding tissue - Leave wound open (no primary closure) - **Repeat debridement q12-24 hr** until healthy margins achieved - Negative pressure wound therapy (VAC) - **Amputation** if extensive limb involvement or refractory progression - Each hour delay increases mortality 4. **Adjuncts**: - **IVIG (intravenous immunoglobulin)**: - Indications: Type II (Group A Strep) NF or toxic shock syndrome - Dose: 1 g/kg day 1, 0.5 g/kg days 2-3 - Mechanism: neutralizes toxins - Evidence: registry data (Linner Lancet ID 2014) - **Hyperbaric Oxygen Therapy (HBOT)**: - Controversial — limited centers - Theoretical benefit: tissue oxygenation, bacteriostatic for anaerobes - Should not delay surgery 5. **Tetanus prophylaxis** 6. **Supportive ICU care**: - Mechanical ventilation, vasopressors, renal replacement if needed - Nutritional support (catabolic state) - VTE prophylaxis - Wound care, plastic surgery consult for reconstruction Outcome: - **Mortality**: 20-30% overall; up to 50-70% in delayed diagnosis - **Predictors of mortality**: age > 60, delayed surgery (> 24 hr), septic shock, leukopenia, organ failure, type of infection (Vibrio higher) - **Time to first debridement** is most modifiable factor — "every hour counts" Prevention: - Wound care, prompt treatment of cellulitis - DM control - Avoid NSAIDs in equivocal skin infections (may mask) Long-term: - Multiple surgeries, reconstruction - Functional rehabilitation - Psychosocial support (scarring, body image, limb loss) - High recurrence risk for chronic conditions — ตัวเลือก B comprehensive. A ผิด — antibiotic alone fails. C ผิดอย่างยิ่ง. D ผิด. E ผิดอย่างยิ่ง — fatal', NULL,
  'medium', 'id', 'review',
  'surgery', 'clinical_decision', 'id', 'adult',
  'IDSA Practice Guidelines for the Diagnosis and Management of Skin and Soft Tissue Infections 2014; WSES/SIS-E Consensus Conference: Necrotizing Soft Tissue Infections 2018; Wong CH et al. Crit Care Med 2004 (LRINEC)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 42 ปี ใต้ผิวหนังที่ต้นขาขวามี swelling + redness + รุนแรงปวด, เริ่ม 36 ชั่วโมงก่อน เริ่มมีไข้ ต่อมา 12 ชั่วโมงปวดมากขึ้น + skin discoloration

Underlying: DM type 2, ไม่ compliance ยา, baseline HbA1c 11%

V/S: BP 88/52, HR 138, RR 28, Temp 39.4°C, SpO2 96%
Gen: ill-appearing, septic
Thigh: extensive erythema 25 × 18 cm, bullae with hemorrhagic fluid, dusky skin discoloration in center, crepitus on palpation, severe pain out of proportion + ตึงตามขาเป็นวงกว้าง, exam findings limited by extreme pain

Lab: WBC 22,500 (left shift), Hb 12.4, Plt 89,000, Cr 2.4, Lactate 5.6, Glucose 488, ABG pH 7.18, LDH 850, CK 12,400, Na 130, CRP > 250
LRINEC score = 11 (high suspicion for necrotizing fasciitis)
X-ray plain: subcutaneous gas in thigh + along fascial planes
Ultrasound bedside: hyperechoic + acoustic shadowing (gas) + fluid along fascia'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 65 ปี underlying T2DM มาห้องฉุกเฉินด้วยอาการปวดท้อง LLQ + ไข้สูง + ท้องเสีย 3 วัน ปวดมากขึ้น 24 ชั่วโมงก่อน

V/S: BP 124/76, HR 102, RR 18, Temp 38.4°C, SpO2 97%
Abdomen: LLQ tenderness + guarding localized + mild rebound + palpable tender mass; no generalized peritonitis

Lab: WBC 16,800 (PMN 85%), CRP 142, Cr 0.9, Lactate 2.2, Glucose 188
CT abdomen with IV + oral contrast: sigmoid diverticulosis with diverticulitis + 4 cm peri-sigmoid abscess + no free air + minimal free fluid
Hinchey stage II (pelvic abscess)', '[{"label":"A","text":"Oral antibiotic + outpatient"},{"label":"B","text":"Acute Sigmoid Diverticulitis with abscess (Hinchey II) — admit"},{"label":"C","text":"Emergency colectomy"},{"label":"D","text":"ERCP"},{"label":"E","text":"Stem cell therapy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Sigmoid Diverticulitis with abscess (Hinchey II) — admit: (1) **Bowel rest + IV fluid**; (2) **IV broad-spectrum antibiotic** ครอบคลุม enteric flora (e.g., piperacillin-tazobactam, ceftriaxone + metronidazole, ertapenem) × 4-7 days then transition to oral; (3) **Percutaneous CT-guided drainage** of abscess (preferred over surgical) — successful 70-90% for abscess > 3-4 cm — drain in for 1-2 weeks until output minimal; (4) Serial clinical assessment; (5) Repeat CT 7-10 days; (6) **Colonoscopy 6-8 weeks** after resolution to exclude underlying malignancy or IBD (controversial — recently questioned in straightforward cases); (7) **Elective sigmoid resection** considered for recurrent diverticulitis (especially complicated), immunocompromised, fistula, stricture — not routinely after first complicated episode anymore (DIRECT trial 2017 — quality-of-life-based decision); (8) Differential management by Hinchey: I (pericolic abscess) — IV antibiotics +/- drainage; II (pelvic abscess) — drainage + antibiotics; III (purulent peritonitis) — emergency surgery; IV (fecal peritonitis) — emergency surgery (Hartmann''s procedure); (9) Diet: avoid high-residue diet during acute; resume regular diet (no nut/seed avoidance now per evidence)

---

Acute Diverticulitis — common surgical/medical condition Pathophysiology: - Diverticula = pseudodiverticula (mucosa + submucosa through muscularis defect) - Common at sites of arterial penetration (vasa recta) - **Sigmoid** most common location (90%) - **Right colon** more common in Asians - Inflammation when diverticulum becomes obstructed → bacterial overgrowth → microperforation Risk factors: - Age (60% by age 80) - Low-fiber diet (debated — fiber may protect), high-fat - Obesity, sedentary - NSAIDs, opioids, corticosteroids - Smoking Clinical features: - **LLQ pain** (Western — sigmoid); right-sided in Asians - Fever, leukocytosis - Bowel habit change (constipation, diarrhea) - Nausea, vomiting (if obstruction) - Urinary symptoms (bladder irritation from inflamed sigmoid) Complications: - Abscess - Perforation (free or contained) - Peritonitis - Fistula (colovesical most common, colovaginal, coloenteric) - Stricture/obstruction - Sepsis Diagnosis: - **CT abdomen with IV + oral contrast** — gold standard (95% sensitive) - **US** alternative (operator-dependent) - **MRI** for pregnant, contrast contraindication - Avoid endoscopy in acute phase (perforation risk) Hinchey Classification (severity): - **0 (modified)**: mild clinical diverticulitis, no diverticulitis on CT - **Ia**: phlegmon, no abscess - **Ib**: pericolic/mesenteric abscess (< 4 cm) - **II**: pelvic, retroperitoneal, distant abscess (> 4 cm) - **III**: purulent peritonitis (free pus, no fecal contamination) - **IV**: fecal peritonitis (free perforation with feces) Management by Severity: A. **Uncomplicated diverticulitis** (Hinchey 0, Ia — most): - **Outpatient management** option (DIVER trial, AVOD trial) in selected stable patients: - Without high fever, severe tenderness, immunocompromise, intolerance of oral - Oral antibiotics or even **NO antibiotics** for mild (AVOD trial 2012, DIABOLO trial 2017 — no antibiotics non-inferior in selected uncomplicated cases) - Or: amoxicillin-clavulanate, ciprofloxacin + metronidazole - **Inpatient** if cannot tolerate oral, severe, immunocompromised, failed outpatient - IV antibiotics × 4-7 days then oral × total 7-10 days B. **Hinchey Ib-II (abscess)**: - **IV broad-spectrum antibiotics** - **Percutaneous drainage** for abscess > 3-4 cm under CT/US guidance - Bowel rest, IV fluid - Reassess - Most resolve without surgery C. **Hinchey III (purulent peritonitis)**: - **Emergency surgery**: - **Hartmann''s procedure** (traditional — sigmoid resection + end colostomy + rectal stump) - **Primary resection + anastomosis +/- diverting ileostomy** (selected stable patients — Ladies trial controversial) - **Laparoscopic lavage** for selected Hinchey III without fecal peritonitis — questioned (SCANDIV, Ladies trials — higher reoperation; not first-line now) D. **Hinchey IV (fecal peritonitis)**: - **Emergency surgery: Hartmann''s procedure** - High mortality 20-40% - ICU care Elective Surgery Indications: 1. **Recurrent diverticulitis**: - Old recommendation: 2+ episodes → surgery - **New approach** (ASCRS 2020): individualized — quality of life, complicated episodes, immunocompromise; many recurrences resolve with conservative therapy 2. **Complicated diverticulitis after conservative**: - Fistula, stricture, recurrent abscess 3. **Immunocompromised**: lower threshold for surgery (corticosteroids, chemotherapy, transplant) 4. **Inability to exclude malignancy** Colonoscopy: - 6-8 weeks after acute episode resolution - Exclude underlying malignancy (3-5% of presumed diverticulitis) - Not routinely needed for straightforward uncomplicated cases per recent evidence (controversial) Diet: - Acute phase: clear liquids → low residue → regular - **Long-term**: high-fiber diet recommended (debated — protective?) - **No restriction of nuts, seeds, popcorn** (old recommendation disproven — Strate JAMA 2008) Pharmacologic: - Mesalamine — no clear benefit - Probiotics — debated - Avoid NSAIDs Outcome: - Uncomplicated: > 95% recovery with conservative - Complicated: depends on stage; Hinchey III/IV mortality 5-20% - Recurrence: 20-30% lifetime — ตัวเลือก B comprehensive. A ผิด — Hinchey II ต้อง admit + drain. C ผิด — emergency surgery for Hinchey III/IV not II. D ผิด — ERCP for biliary. E ผิด — irrelevant', NULL,
  'medium', 'gi', 'review',
  'surgery', 'clinical_decision', 'gi', 'adult',
  'ASCRS Clinical Practice Guidelines for the Treatment of Left-Sided Colonic Diverticulitis 2020 (Hall J et al. Dis Colon Rectum); WSES Guidelines for the Management of Acute Left-Sided Colonic Diverticulitis', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 65 ปี underlying T2DM มาห้องฉุกเฉินด้วยอาการปวดท้อง LLQ + ไข้สูง + ท้องเสีย 3 วัน ปวดมากขึ้น 24 ชั่วโมงก่อน

V/S: BP 124/76, HR 102, RR 18, Temp 38.4°C, SpO2 97%
Abdomen: LLQ tenderness + guarding localized + mild rebound + palpable tender mass; no generalized peritonitis

Lab: WBC 16,800 (PMN 85%), CRP 142, Cr 0.9, Lactate 2.2, Glucose 188
CT abdomen with IV + oral contrast: sigmoid diverticulosis with diverticulitis + 4 cm peri-sigmoid abscess + no free air + minimal free fluid
Hinchey stage II (pelvic abscess)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 4 ปี น้ำหนัก 18 kg ตกในกระทะน้ำเดือดที่ขาทั้งสองข้าง + ลำตัวล่าง 30 นาทีก่อน

V/S: BP 90/56, HR 145, RR 28, Temp 36.4°C, SpO2 99%
Gen: alert but crying, in pain
Burn assessment:
- Both lower extremities (front + back): 18% × 2 = 36%
- Anterior trunk lower half: ~ 9%
- Total BSA burn = ~ 45% (estimated)
Depth: mixed superficial partial (red, blistered, painful) + some deep partial thickness (pale white areas)
No airway burn signs, no carbonaceous sputum, no facial burns', '[{"label":"A","text":"Topical silver sulfadiazine + oral analgesic + discharge"},{"label":"B","text":"Major pediatric burn (> 10% BSA, > 20% TBSA criteria varies) — admit burn center"},{"label":"C","text":"Limited fluid resuscitation to prevent edema"},{"label":"D","text":"Immediate skin graft"},{"label":"E","text":"Cold water immersion 30 min"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Major pediatric burn (> 10% BSA, > 20% TBSA criteria varies) — admit burn center: (1) **Airway assessment** (no signs of inhalation injury here but vigilant); (2) **Fluid resuscitation** — **Parkland formula**: 4 mL × kg × %TBSA Lactated Ringer''s; for this patient: 4 × 18 × 45 = 3,240 mL in first 24 hr; HALF in FIRST 8 HOURS from time of burn (not from arrival) = 1,620 mL in first 8 hr → ~ 200 mL/hr; remainder over next 16 hr; PLUS maintenance fluid for pediatric (4-2-1 rule for child < 30 kg) since burn formula doesn''t include maintenance; (3) **Foley catheter** to monitor urine output goal 1 mL/kg/hr in child (adult 0.5 mL/kg/hr); (4) **Pain control** with IV opioid (morphine 0.1 mg/kg); (5) **Wound care**: gentle cleansing, topical antimicrobial (silver sulfadiazine for partial; not on face/genitals), non-adherent dressing; (6) **Tetanus prophylaxis**; (7) **NG tube** if > 20% TBSA (ileus risk); (8) **Nutritional support** — pediatric burns hypermetabolic; (9) Multidisciplinary burn team — surgery, plastic, ICU, PT/OT, psychology; (10) **NAI assessment** — atypical burns, inconsistent history, splash vs immersion pattern (immersion = symmetric, sharp demarcation); (11) Long-term: scar management, contracture prevention, psychosocial support

---

Major Pediatric Burn — high-mortality if mismanaged Severity criteria (American Burn Association — Burn Center Referral): - **Major burn**: - Adult: > 20% TBSA partial/full - Child < 10: > 10% TBSA - Elderly > 50: > 10% TBSA - Any: full-thickness > 5%, electrical, chemical, inhalation, facial/genital/hands/feet/joints, comorbidities Burn depth: 1. **Superficial (1st degree)**: epidermis only, red, dry, painful (sunburn) — NOT counted in TBSA 2. **Superficial partial-thickness (2nd degree, superficial)**: epidermis + upper dermis, red, blistered, painful, blanches 3. **Deep partial-thickness (2nd degree, deep)**: into deeper dermis, pale/white/red mottled, less painful, slow capillary refill 4. **Full-thickness (3rd degree)**: through dermis, white/leathery/charred, painless (nerve destruction), no blanching 5. **4th degree**: into fat, muscle, bone TBSA estimation: - **Wallace Rule of Nines** (adult): - Head + neck: 9% - Each arm: 9% - Each leg: 18% - Anterior trunk: 18% - Posterior trunk: 18% - Perineum: 1% - **Lund-Browder chart** (pediatric — different proportions): - Children have proportionally larger head, smaller legs - Infant head: 18%, leg: 14%; adult head: 9%, leg: 18% - **Palm method**: patient''s palm (with fingers) = ~1% TBSA Initial Management (ATLS-Advanced Trauma Life Support burn focus + ABA Advanced Burn Life Support): A. **Primary Survey + Stop Burning Process**: - Remove clothing, jewelry - Cool burn (room temp water 20 min); avoid ice/very cold (vasoconstriction, hypothermia) - Cover with clean dry sheet B. **Airway**: - **High suspicion of inhalation injury** if: enclosed space, facial burns, singed nasal hair, soot, hoarse voice, stridor, carbonaceous sputum - Early intubation if signs of impending airway compromise - 100% O2 if CO inhalation suspected (carboxyhemoglobin) C. **Breathing**: - Carbon monoxide, cyanide (smoke) - 100% O2 + hyperbaric for severe CO - Hydroxocobalamin for cyanide D. **Circulation / Fluid Resuscitation**: - **2 large-bore IVs** (through unburned skin if possible) - **Parkland Formula**: - **4 mL × kg × %TBSA Lactated Ringer''s** in first 24 hours - **Half in first 8 hours** (from time of burn, not arrival) - **Remainder over next 16 hours** - Adjust based on urine output - **Modified Brooke**: 2 mL × kg × %TBSA (less fluid, similar outcomes — preferred in some centers) - **Parkland is just a starting estimate** — titrate to: - **Urine output 0.5 mL/kg/hr (adult), 1 mL/kg/hr (child < 30 kg), 1-2 mL/kg/hr (infant)** - MAP, HR, mental status, lactate - Add maintenance fluid for children (4-2-1 rule for first 10 kg, +2 for 10-20 kg, +1 above) - **Over-resuscitation harms**: "fluid creep" → ARDS, compartment syndromes, edema E. **Disability + Exposure** F. **Secondary Survey** + Detailed Assessment: - TBSA + depth - Associated injuries - History of mechanism (NAI screen in pediatric) Other Critical Interventions: 1. **Foley catheter** — UO monitoring 2. **NG tube** if > 20% TBSA (paralytic ileus) 3. **Pain control** — IV opioid (morphine, fentanyl) titrated 4. **Tetanus prophylaxis** 5. **Topical antimicrobial**: - Silver sulfadiazine (most common; not face/genitals — gray-blue) - Mafenide (deeper penetration; metabolic acidosis) - Bacitracin (face, small burns) - Silver dressings (Acticoat, Mepilex Ag) 6. **Wound care**: gentle cleansing, debridement, non-adherent dressing 7. **Escharotomy**: circumferential full-thickness burns of extremities or chest causing compartment syndrome or restricted ventilation 8. **Nutritional support**: hypermetabolic state, increased caloric + protein needs (Curreri formula: 25 kcal/kg + 40 kcal × %TBSA) 9. **VTE prophylaxis** 10. **Stress ulcer prophylaxis** (Curling''s ulcer prevention) 11. **Glucose control** Specific Pediatric Considerations: - **Higher TBSA-to-weight ratio** → more heat/fluid loss - **Larger head proportion** - **Hypothermia risk** — warm room, blankets - **NAI/abuse screening**: - Pattern: symmetric (immersion), sharp demarcation, sparing of flexor creases - Inconsistent history - Delayed presentation - Other injuries (bruises, fractures) - Mandatory reporting in many jurisdictions Definitive Care (Burn Center): 1. **Debridement + Excision**: - Early excision (within 5-7 days) of deep partial + full-thickness → improved outcomes - Tangential excision until viable bleeding tissue 2. **Wound Coverage**: - Autograft (split-thickness or full-thickness) - Cultured epidermal autografts (Epicel) - Biologic dressings (allograft, xenograft) - Synthetic dermal substitutes (Integra, AlloDerm) 3. **Rehabilitation**: - PT/OT — early ROM, splinting (prevent contractures) - Pressure garments for hypertrophic scarring - Psychological support - Long-term scar management Complications: - **Sepsis** (most common cause of mortality late) - Compartment syndrome - Burn shock - Stress ulcer (Curling''s) - Acute renal failure - DVT - Heterotopic ossification - Hypertrophic scar, contracture - Post-traumatic stress disorder Outcome: - Pediatric burn survival > 95% with optimal care - Long-term morbidity significant — scarring, contracture, psychological, growth — ตัวเลือก B comprehensive. A ผิดอย่างยิ่ง — major pediatric burn. C ผิด — under-resuscitation harms. D ผิด — graft is later. E ผิด — short cooling fine but not 30 min (hypothermia)', NULL,
  'medium', 'trauma', 'review',
  'surgery', 'clinical_decision', 'trauma', 'peds',
  'American Burn Association Advanced Burn Life Support (ABLS) 2018; ABA Practice Guidelines for Burn Care; ISBI Practice Guidelines for Burn Care 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'เด็กชายอายุ 4 ปี น้ำหนัก 18 kg ตกในกระทะน้ำเดือดที่ขาทั้งสองข้าง + ลำตัวล่าง 30 นาทีก่อน

V/S: BP 90/56, HR 145, RR 28, Temp 36.4°C, SpO2 99%
Gen: alert but crying, in pain
Burn assessment:
- Both lower extremities (front + back): 18% × 2 = 36%
- Anterior trunk lower half: ~ 9%
- Total BSA burn = ~ 45% (estimated)
Depth: mixed superficial partial (red, blistered, painful) + some deep partial thickness (pale white areas)
No airway burn signs, no carbonaceous sputum, no facial burns'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 78 ปี underlying CAD, COPD, mild dementia เข้ารับการผ่าตัด open AAA repair การผ่าตัดสำเร็จ ใช้เวลา 5 ชั่วโมง EBL 1,500 mL ได้ PRC 2 units + crystalloid 4 L

Day 1 post-op:
- BP 138/78, HR 92, RR 18, SpO2 96% on 4 L NC, Temp 37.8°C
- Urine output 0.3 mL/kg/hr × 6 hours (oliguria)
- Hb 9.8, Cr rose from 1.2 → 2.4 (KDIGO AKI Stage 2)
- Lactate 2.8
- ABG: pH 7.32, HCO3 18
- Bladder pressure (intra-abdominal pressure) = 22 mmHg via Foley transducer
- Abdomen distended + tense
- Peak inspiratory pressure increased on ventilator
- Decreased venous return on echocardiography', '[{"label":"A","text":"Increase IV fluid aggressively to improve urine"},{"label":"B","text":"Abdominal Compartment Syndrome (ACS — IAP > 20 + new organ failure per WSACS) post-open AAA repair"},{"label":"C","text":"Continue current management — Cr will recover"},{"label":"D","text":"Diuretic IV high dose"},{"label":"E","text":"Vasopressor to maintain BP"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Abdominal Compartment Syndrome (ACS — IAP > 20 + new organ failure per WSACS) post-open AAA repair: (1) **Monitor IAP** (bladder pressure q4-6h post high-risk surgery); (2) **Medical management** (try first if no overt organ failure): NG/rectal decompression, sedation + analgesia (reduce abdominal muscle tone), neuromuscular blockade (deep sedation), avoid excessive crystalloid (worsens edema), drain ascites/fluid (paracentesis), diuresis + CRRT if volume overload, head of bed < 20°; (3) **Surgical decompressive laparotomy** (definitive) when: medical management fails, IAP > 20-25 + organ failure, anuria, refractory hypoxia, refractory hypotension; (4) Post-decompression: open abdomen with temporary closure (Bogota bag, ABThera VAC, mesh) — staged closure over days-weeks; (5) ICU monitoring + multi-organ support

---

Abdominal Compartment Syndrome (ACS) — increased intra-abdominal pressure causing organ dysfunction WSACS (World Society Abdominal Compartment Syndrome) 2013 + updated definitions: - **Intra-abdominal Hypertension (IAH)**: sustained IAP ≥ 12 mmHg (normal 5-7) - Grade I: 12-15 - Grade II: 16-20 - Grade III: 21-25 - Grade IV: > 25 - **Abdominal Compartment Syndrome (ACS)**: IAP > 20 mmHg + new organ failure - **Primary ACS**: intra-abdominal pathology (trauma, surgery, peritonitis) - **Secondary ACS**: extra-abdominal cause (massive resuscitation, burns) - **Recurrent ACS**: post-decompression Etiology: 1. Post-surgical (especially AAA, transplant, trauma laparotomy) 2. Massive fluid resuscitation ("fluid creep") 3. Severe pancreatitis 4. Massive ascites 5. Bowel obstruction, ileus 6. Hemorrhage (intra-abdominal) 7. Burn (> 30% TBSA — secondary ACS) 8. Capillary leak (sepsis) Pathophysiology: - Increased IAP compresses: 1. **Vena cava** → reduced venous return → reduced CO + hypotension 2. **Renal vessels** + renal parenchyma → AKI (most sensitive organ) 3. **Diaphragm displacement** → reduced lung compliance + atelectasis + hypoxia + hypercapnia 4. **Splanchnic perfusion** → bowel ischemia, bacterial translocation 5. **Hepatic vein** + portal vein → hepatic dysfunction 6. **Cerebral perfusion** → ↑ ICP, ↓ CPP 7. **Abdominal wall** → necrosis, dehiscence Clinical features: - Tense distended abdomen - Oliguria/AKI - Hypoxia (increased airway pressure on ventilator) - Hypotension (despite resuscitation) - Acidosis - Multi-organ dysfunction Diagnosis: - **Bladder pressure measurement** (gold standard): - Foley catheter with transducer - 25 mL saline instilled into bladder - End-expiration, supine, no abdominal contraction - Normal: 5-7; IAH ≥ 12; ACS > 20 + organ dysfunction Management (WSACS Guidelines): A. **Prevention**: - Avoid excessive crystalloid in resuscitation - Use damage control surgery in trauma when appropriate - Monitor IAP in high-risk patients B. **Medical Management** (IAH grades I-III without overt ACS): - **Evacuate intraluminal contents**: NG suction, rectal tube, enemas, prokinetics (metoclopramide, erythromycin) - **Evacuate intra-abdominal fluid**: paracentesis for ascites, drainage of abscesses - **Improve abdominal wall compliance**: sedation, analgesia, neuromuscular blockade (deep sedation with paralysis last resort) - **Optimize fluid balance**: avoid over-resuscitation, judicious diuresis (furosemide), CRRT if volume overload + AKI - **Optimize perfusion**: MAP, CPP - **Positioning**: head of bed < 20° (reduces IAP further worsening; trade-off vs aspiration risk) C. **Surgical Decompression** (definitive when ACS develops or refractory): - **Decompressive laparotomy** — emergency - Vertical midline incision - **Open abdomen** management: - **Temporary abdominal closure (TAC)**: Bogota bag (sterile bag), Wittmann patch, ABThera/VAC (negative pressure abdominal therapy — preferred) - Prevents evisceration, evaporation, mass transfer of bacteria - Allows for serial assessment, control of fluid losses, re-exploration - **Staged closure**: - Primary closure when feasible (often days-weeks later) - Component separation - Skin graft over granulation - Mesh repair Specific Considerations Post-AAA Repair: - **High-risk for ACS**: large transfusion, prolonged operative time, hemorrhage, ruptured AAA - **Routine IAP monitoring** in ICU - **Early decompression** if developed - **EVAR vs Open**: EVAR has lower ACS risk Complications: - Bowel ischemia → necrosis - Sepsis (translocation) - Multi-organ failure - Death (50-70% if untreated ACS) - Wound complications post-decompression (hernia, fistula) Long-term: - Incisional hernia (common) - Functional recovery — ตัวเลือก B comprehensive. A ผิดอย่างยิ่ง — more fluid worsens ACS. C ผิด — Cr rising = AKI, intervention needed. D ผิด — diuretic alone insufficient. E ผิด — vasopressor doesn''t address root cause', NULL,
  'hard', 'renal_gu', 'review',
  'surgery', 'clinical_decision', 'renal_gu', 'adult',
  'WSACS Consensus Definitions and Clinical Practice Guidelines from the World Society of the Abdominal Compartment Syndrome (Kirkpatrick AW et al. Intensive Care Med 2013); ACS Surgery Critical Care', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 78 ปี underlying CAD, COPD, mild dementia เข้ารับการผ่าตัด open AAA repair การผ่าตัดสำเร็จ ใช้เวลา 5 ชั่วโมง EBL 1,500 mL ได้ PRC 2 units + crystalloid 4 L

Day 1 post-op:
- BP 138/78, HR 92, RR 18, SpO2 96% on 4 L NC, Temp 37.8°C
- Urine output 0.3 mL/kg/hr × 6 hours (oliguria)
- Hb 9.8, Cr rose from 1.2 → 2.4 (KDIGO AKI Stage 2)
- Lactate 2.8
- ABG: pH 7.32, HCO3 18
- Bladder pressure (intra-abdominal pressure) = 22 mmHg via Foley transducer
- Abdomen distended + tense
- Peak inspiratory pressure increased on ventilator
- Decreased venous return on echocardiography'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 45 ปี ไม่มีโรคประจำตัว มา ED ด้วยอาการ acute onset ปวด groin ขวา + คลำพบก้อน + ปวดมาก ก้อนไม่สามารถ reduce ได้ + คลื่นไส้อาเจียน 4 ชั่วโมง ก่อนหน้านี้ ผู้ป่วยเคยมี inguinal hernia ขวา reducible มา 1 ปี ไม่ผ่าตัด

V/S: BP 132/78, HR 102, RR 18, Temp 37.4°C, SpO2 98%
Gen: pain + anxious
Right groin: tender mass 6 × 4 cm, non-reducible, overlying skin erythematous, no induration
Abdomen: mild distension, hyperactive bowel sounds, no peritoneal signs

Lab: WBC 13,400, Lactate 2.4
CT abdomen with contrast: right inguinal hernia with incarcerated bowel loop + bowel wall edema + minimal mesenteric fat stranding (no clear strangulation yet, but bowel obstruction proximal — dilated small bowel loops)', '[{"label":"A","text":"Reduction attempt + elective surgery in 4-6 weeks"},{"label":"B","text":"Incarcerated inguinal hernia with bowel obstruction — surgical emergency (high risk progression to strangulation)"},{"label":"C","text":"Discharge with truss + outpatient"},{"label":"D","text":"Antibiotic + observation"},{"label":"E","text":"Hot compress to soften mass"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Incarcerated inguinal hernia with bowel obstruction — surgical emergency (high risk progression to strangulation): (1) **Initial gentle taxis (manual reduction)** in selected stable case (< 6 hr, no signs of strangulation: severe pain, peritonitis, skin discoloration, elevated lactate, leukocytosis), but most cases proceed directly to surgery; sedation + analgesia + Trendelenburg position to assist; (2) **NPO + IV fluid + NG decompression**; (3) **Emergent surgical exploration** (within hours) — open or laparoscopic; assess bowel viability (color, peristalsis, Doppler) — resect non-viable, repair hernia; (4) **Hernia repair**: mesh repair if no bowel resection or clean field; **avoid mesh** if contaminated field (bowel resection, infection); primary tissue repair (Bassini, Shouldice, McVay) or biologic mesh alternatives; (5) Tetanus prophylaxis if open wound; (6) Antibiotics for bowel resection (broad-spectrum, single dose pre-op, continue if contaminated); (7) Post-op monitoring for SSI, recurrence; (8) Differential management: incarcerated (cannot reduce) → urgent surgery; strangulated (compromised blood supply — severe pain, peritonitis, fever, leukocytosis, lactate) → emergent surgery; reducible chronic → elective

---

Inguinal Hernia — protrusion of abdominal contents through inguinal canal Types: 1. **Indirect**: through deep ring (most common, congenital persistence of processus vaginalis) 2. **Direct**: through Hesselbach''s triangle (acquired, abdominal wall weakness) 3. **Femoral**: through femoral canal (more common in women, higher strangulation risk) Spectrum of severity: 1. **Reducible**: hernia contents can be returned to abdomen with manipulation 2. **Incarcerated**: cannot be reduced (firmly stuck), no compromise of blood supply yet 3. **Strangulated**: blood supply compromised → ischemia → necrosis (surgical emergency) 4. **Obstructed**: bowel in hernia → bowel obstruction Clinical features: - Reducible: bulge that appears with Valsalva, disappears when lying or with manipulation - **Incarcerated**: painful non-reducible mass, may have nausea, vomiting if bowel obstruction - **Strangulated**: severe constant pain, peritonitis, skin discoloration, fever, leukocytosis, sepsis, lactate elevation Risk factors: - Male (10:1 in inguinal) - Increased intra-abdominal pressure: chronic cough (COPD), constipation, heavy lifting, ascites, pregnancy - Family history - Connective tissue disorders - Prior abdominal surgery (incisional hernia adjacent) Diagnosis: - **Clinical examination** — primary - **Imaging** when atypical or complicated: - CT abdomen/pelvis: most useful - US: dynamic, real-time - MRI: occult hernias Management: A. **Asymptomatic Reducible Inguinal Hernia**: - **Watchful waiting** acceptable (PASIH trial — minor surgical risk in elderly comorbid) - **Elective repair** when symptomatic, large, increasing - **EHS (European Hernia Society)** + **ICS (International Consensus on Surgery) guidelines** B. **Incarcerated Hernia** (this patient): - **Taxis (manual reduction)**: - Indications: hemodynamically stable, no signs of strangulation, < 6 hr - Technique: sedation, Trendelenburg, gentle manipulation - If successful: observe, surgery within days (not immediate emergency but soon — risk of re-incarceration) - If unsuccessful or risk of reduction en masse (returning compromised bowel into peritoneum): immediate surgery - **Direct to surgery** if any sign of strangulation or > 6 hr incarceration C. **Strangulated Hernia** (this is also a strong consideration here): - **Emergent surgery** - Open vs laparoscopic - **Assess bowel viability**: - Color (pink, viable; dark, necrotic) - Peristalsis (present, viable; absent, dead) - Doppler flow assessment - Fluorescein test - Warm packs + wait 10-20 min for borderline - **Resect non-viable bowel** + primary anastomosis (or stoma if hemodynamically unstable or contaminated) - **Hernia repair**: - **Clean field**: mesh acceptable - **Contaminated field** (bowel resection, infection): tissue repair (Bassini, Shouldice, McVay) or biologic/absorbable mesh; synthetic mesh avoidance to reduce infection D. **Repair Techniques**: 1. **Open Repair**: - **Lichtenstein** (tension-free, mesh — most common, gold standard for elective) - **Plug & patch** (Rutkow) - **Tissue repairs**: - **Bassini**: approximation of conjoint tendon to inguinal ligament - **Shouldice**: layered, multi-layer (lowest recurrence among tissue repairs) - **McVay (Cooper''s ligament)**: useful for femoral and recurrent 2. **Laparoscopic Repair**: - **TEP (Totally Extraperitoneal)** - **TAPP (TransAbdominal PrePeritoneal)** - Advantages: bilateral repair, recurrent hernia, less pain, faster recovery - Mesh placement preperitoneal Outcomes: - Recurrence: 1-3% modern mesh repairs; 5-10% tissue repairs - Chronic pain: 5-10% (mesh) — concern - Mesh infection: < 1% - Mortality elective: < 0.1% - Mortality emergent for strangulation: 5-10% Complications: - Hematoma, seroma - Wound infection - Mesh infection - Recurrence - Chronic pain (genital, inguinal, neuralgia) - Bowel injury - Vascular injury - Ureteral injury (rare) Special Considerations: - **Pregnant women**: defer if possible to postpartum - **Pediatric**: high-ligation alone (no mesh — growth) - **Femoral hernias**: higher strangulation risk → repair when diagnosed - **Recurrent hernias**: consider laparoscopic + alternative anatomic approach Prevention: - Avoid heavy lifting in recent post-op - Smoking cessation, weight management — ตัวเลือก B comprehensive. A ผิด — incarcerated cannot wait. C ผิด — truss outdated, doesn''t prevent strangulation. D ผิด — antibiotic alone insufficient. E ผิด — hot compress doesn''t address mechanical issue', NULL,
  'easy', 'gi', 'review',
  'surgery', 'clinical_decision', 'gi', 'adult',
  'European Hernia Society Guidelines for Inguinal Hernia 2018; International Guidelines for Groin Hernia Management (HerniaSurge Group); WSES Emergency Hernia Repair Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 45 ปี ไม่มีโรคประจำตัว มา ED ด้วยอาการ acute onset ปวด groin ขวา + คลำพบก้อน + ปวดมาก ก้อนไม่สามารถ reduce ได้ + คลื่นไส้อาเจียน 4 ชั่วโมง ก่อนหน้านี้ ผู้ป่วยเคยมี inguinal hernia ขวา reducible มา 1 ปี ไม่ผ่าตัด

V/S: BP 132/78, HR 102, RR 18, Temp 37.4°C, SpO2 98%
Gen: pain + anxious
Right groin: tender mass 6 × 4 cm, non-reducible, overlying skin erythematous, no induration
Abdomen: mild distension, hyperactive bowel sounds, no peritoneal signs

Lab: WBC 13,400, Lactate 2.4
CT abdomen with contrast: right inguinal hernia with incarcerated bowel loop + bowel wall edema + minimal mesenteric fat stranding (no clear strangulation yet, but bowel obstruction proximal — dilated small bowel loops)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 65 ปี underlying CKD stage 3, DM, HT มาด้วยอาการปวดท้องน้อย LLQ + ท้องอืดมาก + อาเจียน + ไม่ผ่ายลม + ไม่ถ่ายมา 36 ชั่วโมง ก่อนหน้านี้ 3 เดือนถ่ายไม่สม่ำเสมอ + ลำไส้สลับเล็กลง + น้ำหนักลด 4 kg + เคยถ่ายมีเลือดปน intermittent

V/S: BP 138/82, HR 96, RR 22, Temp 37.2°C, SpO2 97%
Abdomen: distended, tympanic, high-pitched bowel sounds + visible peristalsis, mild generalized tenderness without peritoneal signs

Lab: WBC 10,800, Hb 9.2 (microcytic), CEA 28 (elevated), Lactate 1.8
Upright abdominal X-ray: dilated colon with air-fluid levels + cecum dilated to 11 cm + relative absence of distal gas + abrupt cutoff at sigmoid
CT abdomen with contrast: large bowel obstruction with apple-core stricture at sigmoid colon + dilated proximal colon to 10 cm + thickened bowel wall + multiple liver hypodense lesions suspicious for metastases', '[{"label":"A","text":"Pure conservative management with NG + IV fluid"},{"label":"B","text":"Malignant Large Bowel Obstruction (LBO) from sigmoid colon cancer with liver mets — surgical-oncologic management"},{"label":"C","text":"Discharge home with stool softener"},{"label":"D","text":"Whipple procedure"},{"label":"E","text":"Long fasting therapy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Malignant Large Bowel Obstruction (LBO) from sigmoid colon cancer with liver mets — surgical-oncologic management: (1) **Initial resuscitation**: IV fluid, correct electrolytes, NG decompression, NPO, monitor; (2) **Address acute obstruction** with cecal distension (> 12 cm = high perforation risk) — options: (a) **Emergency surgery** if peritonitis or imminent perforation — sigmoid resection ± stoma vs primary anastomosis ± loop ileostomy (decompression); (b) **Endoscopic Self-Expanding Metal Stent (SEMS)** as bridge to surgery — allows decompression, bowel prep, elective surgery; useful in palliative setting too — but increasing concerns about perforation + worse oncologic outcomes (controversial — DCCG STENT trial outcomes mixed); (3) **Multidisciplinary tumor board**: surgery + medical oncology + radiation oncology + hepatobiliary + IR + palliative care; (4) **Stage with chest CT + biopsy of liver lesions** to confirm metastatic disease (M1c); (5) **Decision based on resectability**: - **Resectable metastases (liver-only, limited)**: consider perioperative chemotherapy + concurrent or staged primary tumor + liver metastasis resection; - **Unresectable metastases**: palliative chemotherapy (FOLFIRINOX, FOLFOX +/- bevacizumab or cetuximab/panitumumab if RAS WT, BRAF status, MSI status); palliate primary if obstructing/bleeding; (6) **Genetic testing**: RAS, BRAF, MSI/MMR, HER2 status (Lynch syndrome screening if appropriate); (7) Concurrent **palliative care + nutrition** support; (8) Hereditary risk assessment + family screening

---

Large Bowel Obstruction (LBO) from Colorectal Cancer — common surgical-oncologic presentation Etiology of LBO: 1. **Colorectal cancer** (60% of LBO — most common) 2. Diverticular stricture 3. Volvulus (sigmoid > cecal in elderly; cecal younger) 4. Inflammatory stricture (IBD) 5. Hernia (incisional or external) 6. Adhesions (less common in LBO than SBO) Clinical features: - Abdominal distension - Constipation, obstipation (no flatus/stool) - Vomiting (late — often feculent if distal) - Crampy abdominal pain - History of bowel habit change (suggests malignant — apple core lesion) - Hematochezia, melena - Weight loss, anemia (chronic blood loss) Diagnosis: - **Upright + supine abdominal X-ray**: dilated colon, air-fluid levels, "coffee bean" sign (sigmoid volvulus), absence of distal gas - **CT abdomen-pelvis with contrast**: gold standard - Locates obstruction - Identifies cause (mass, stricture, volvulus) - Identifies metastases (liver, peritoneal) - Assesses perforation, bowel viability - **Colonoscopy**: diagnostic + therapeutic (biopsy, stent) - Avoid if perforation, peritonitis Cecal Distension as Predictor of Perforation: - Law of Laplace: wall tension ∝ radius (cecum largest → highest tension) - **Cecal diameter > 10-12 cm = high risk of perforation** ("closed loop" if competent ileocecal valve) - Urgent decompression needed Management of Malignant LBO: A. **Initial Management**: 1. **Resuscitation**: IV fluid (often dehydrated, electrolyte derangement) 2. **NPO + NG decompression** (bowel rest) 3. **Foley catheter** (UO monitoring) 4. **Correct electrolytes**: K, Na, Mg 5. **Antibiotics** if signs of perforation or bowel ischemia B. **Address Acute Obstruction**: 1. **Emergency Surgery** indications: - Cecal perforation or imminent perforation (cecum > 12 cm) - Peritonitis - Failed medical management - Bowel ischemia Procedures: - **Hartmann''s procedure**: resection + end colostomy + rectal stump (most common emergent for distal obstruction) - **Primary resection + anastomosis** (with on-table lavage) - **Subtotal colectomy** with ileorectal anastomosis - **Diverting loop ileostomy/colostomy** if too unstable for resection 2. **Endoscopic Self-Expanding Metal Stent (SEMS)** — alternative to emergency surgery: - Indications: - **Bridge to elective surgery** — decompress, optimize patient, oncologic staging, elective resection - **Palliation** of unresectable obstruction - Benefits: less morbidity than emergency surgery, primary anastomosis possible, oncologic staging more thorough - Risks: perforation (5-10%), stent migration, tumor ingrowth, possible worse oncologic outcomes (controversial — concern of tumor cell spread from stenting) - **Recent evidence (DCCG STENT, Catalonia trial)**: mixed — some show worse oncologic outcomes - **ESMO/ESCP recommendations**: SEMS reasonable in selected patients C. **Oncologic Management** (after acute obstruction managed): 1. **Staging**: - **Chest/abdomen/pelvis CT** - **MRI rectum** for rectal cancer - **CEA** baseline + monitoring - **Biopsy** primary + suspicious mets - **PET/CT** for equivocal mets - **Liver MRI** for liver-specific assessment - **Genetic testing**: RAS (KRAS, NRAS), BRAF, MSI/MMR, HER2 2. **Stage IV with Resectable Liver Mets**: - **Perioperative chemotherapy** (FOLFOX or CapeOx +/- bevacizumab) + **synchronous or staged resection** of primary + liver mets - 5-year survival 30-40% in selected (5 mets, isolated to liver) - Modern: "liver-first" approach for some 3. **Unresectable Metastases**: - **Systemic chemotherapy** (palliative intent): - **First-line**: FOLFOX (5-FU + leucovorin + oxaliplatin), CapeOx, FOLFIRI, FOLFIRINOX - **+ Biologic**: - **Bevacizumab** (anti-VEGF) — any RAS status - **Cetuximab/panitumumab** (anti-EGFR) — RAS wild-type, left-sided tumor (PRIME, FIRE-3 trials) - **Second-line**: alternate combinations - **Targeted/Immunotherapy**: - **Pembrolizumab/nivolumab** for MSI-high tumors (KEYNOTE-177) - **Trastuzumab + tucatinib/lapatinib** for HER2-amplified - **Encorafenib + cetuximab** for BRAF V600E (BEACON trial) - **Larotrectinib** for NTRK fusions 4. **Palliative Primary Tumor Management**: - **Stent** for obstruction - **Diverting stoma** - **Palliative resection** controversial (no clear survival benefit but symptom control) 5. **Liver-Directed Therapy** for liver-dominant disease: - SBRT (stereotactic body RT) - Y-90 radioembolization - HAI (hepatic artery infusion) - RFA, microwave ablation Pre-operative Optimization (elective): - Optimization of comorbidities (cardiac, pulmonary, renal) - Nutritional support - Bowel preparation (mechanical + oral antibiotics — historical debate, recent evidence supports) - VTE prophylaxis - Pre-habilitation (exercise, nutrition, smoking cessation, alcohol cessation) Surgical Approach: - **Open vs Laparoscopic vs Robotic** — equivalent oncologic outcomes; laparoscopic/robotic preferred for elective (faster recovery, less morbidity) - **Total mesorectal excision (TME)** for rectal cancer - **Lymph node dissection** D2 standard, D3 (extended) for some Adjuvant Therapy (Stage III): - **Stage III (node-positive)**: adjuvant FOLFOX or CapeOx × 3-6 months (IDEA trial — duration optimized based on risk) - **Stage II high-risk**: selected adjuvant based on features (T4, perforation, < 12 nodes examined, lymphovascular invasion) - **Rectal cancer**: neoadjuvant or adjuvant chemoradiation (selected) Surveillance: - Clinical exam + CEA q3-6 mo × 5 yr - CT chest/abdomen q12 mo × 5 yr - Colonoscopy 1 yr post-op, then q3-5 yr - Higher frequency for high-risk Hereditary Considerations: - **Lynch Syndrome** screening: family history, age, tumor MSI/IHC, germline testing if criteria met - **FAP**: family history of polyps - Implications for family screening + risk-reducing strategies Outcome: - 5-year survival: - Stage I: 90%+ - Stage II: 70-85% - Stage III: 50-70% - Stage IV: 10-15% overall; 30-40% if liver-only resectable; modern targeted improving — ตัวเลือก B comprehensive multidisciplinary. A ผิด — pure conservative insufficient for cecum > 10 cm. C ผิดอย่างยิ่ง. D ผิด — Whipple for pancreatic. E ผิด — fasting doesn''t address', NULL,
  'hard', 'hemato_onco', 'review',
  'surgery', 'clinical_decision', 'hemato_onco', 'adult',
  'ESMO Clinical Practice Guidelines for the Management of Patients with Metastatic Colorectal Cancer 2022; NCCN Colon Cancer 2024; ASCO Practice Guidelines; WSES Guidelines on Malignant Colorectal Obstruction', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 65 ปี underlying CKD stage 3, DM, HT มาด้วยอาการปวดท้องน้อย LLQ + ท้องอืดมาก + อาเจียน + ไม่ผ่ายลม + ไม่ถ่ายมา 36 ชั่วโมง ก่อนหน้านี้ 3 เดือนถ่ายไม่สม่ำเสมอ + ลำไส้สลับเล็กลง + น้ำหนักลด 4 kg + เคยถ่ายมีเลือดปน intermittent

V/S: BP 138/82, HR 96, RR 22, Temp 37.2°C, SpO2 97%
Abdomen: distended, tympanic, high-pitched bowel sounds + visible peristalsis, mild generalized tenderness without peritoneal signs

Lab: WBC 10,800, Hb 9.2 (microcytic), CEA 28 (elevated), Lactate 1.8
Upright abdominal X-ray: dilated colon with air-fluid levels + cecum dilated to 11 cm + relative absence of distal gas + abrupt cutoff at sigmoid
CT abdomen with contrast: large bowel obstruction with apple-core stricture at sigmoid colon + dilated proximal colon to 10 cm + thickened bowel wall + multiple liver hypodense lesions suspicious for metastases'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 28 ปี ก่อนทำ elective laparoscopic cholecystectomy พบ blood pressure 184/108 mmHg ใน pre-op anesthesia clinic ไม่มีโรคประจำตัว ไม่ได้รับยา ค่า BP ก่อนหน้านี้ปกติเมื่อ 3 เดือน

ผู้ป่วยไม่มีอาการเลย ไม่มีปวดศีรษะ ไม่มีเหงื่อแตก ไม่มี palpitations

Vitals: BP 184/108 (วัดซ้ำห่าง 15 นาที 178/106), HR 98, RR 16, Temp 36.6°C, BMI 24
PE: ไม่มี Cushingoid features, ไม่มี abdominal bruit, ไม่มี edema, ไม่มี Café-au-lait spots

Lab: K 3.2 (low), Na 142, Cr 0.9
Urinalysis: ปกติ; renin/aldosterone ratio: aldosterone 28, renin 0.4 (suppressed) → ARR > 70 (suggestive of primary aldosteronism)
CT adrenal: 2.5 cm adenoma right adrenal gland
Plasma metanephrines: ปกติ', '[{"label":"A","text":"Proceed with cholecystectomy as planned"},{"label":"B","text":"Postpone elective surgery — secondary hypertension workup positive for Primary Aldosteronism (Conn''s syndrome) likely aldosterone-producing adenoma (APA) — manage systematically"},{"label":"C","text":"Add antihypertensive and proceed with cholecystectomy"},{"label":"D","text":"Diagnose essential HT + treat with thiazide"},{"label":"E","text":"Cancel surgery permanently"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Postpone elective surgery — secondary hypertension workup positive for Primary Aldosteronism (Conn''s syndrome) likely aldosterone-producing adenoma (APA) — manage systematically: (1) **Confirm diagnosis**: ARR (aldosterone-to-renin ratio) screening — already done; confirmatory test (saline infusion test, oral salt loading, captopril challenge, fludrocortisone suppression — to confirm aldosterone autonomy); (2) **Subtype**: adrenal CT shows 2.5 cm unilateral adenoma (consistent with APA — Conn''s); but in patients age > 35 or with bilateral abnormalities, **adrenal venous sampling (AVS)** is essential to confirm unilateral source before surgery; (3) **Pre-treatment with spironolactone or eplerenone** (mineralocorticoid receptor antagonist) to control BP + correct hypokalemia 2-4 weeks; (4) **Surgical treatment** if unilateral: **laparoscopic adrenalectomy** — curative for APA; cures HT in 30-40%, improves in 50%, no change in 10-15%; (5) **Bilateral hyperplasia**: medical management with MRA long-term; (6) Postpone elective cholecystectomy until BP controlled + endocrine surgery planned/done; (7) Endocrine consult + endocrine surgery; (8) Family screening for FH-I, FH-II, FH-III (familial hyperaldosteronism syndromes) if young or family history

---

Secondary Hypertension Workup in Young Patient — Pre-operative Setting Indications for secondary HT workup: - **Onset before age 30** without family history - **Onset > 55** (less common but possible) - **Sudden change** in previously controlled HT - **Treatment-resistant HT** (≥ 3 drugs at max dose, one being diuretic) - **Severe HT** (> 180/110) at presentation - **Accelerated/malignant HT** - **Clinical clues** to specific causes Common Causes of Secondary HT: 1. **Renal parenchymal disease** (most common — CKD, polycystic kidney) 2. **Renovascular disease** (renal artery stenosis — atherosclerotic, fibromuscular dysplasia in young) 3. **Endocrine causes**: - **Primary aldosteronism** (most common endocrine cause — 5-15% of HT) - **Pheochromocytoma/paraganglioma** (rare but classic) - **Cushing''s syndrome** - **Thyroid disease** (hyper/hypo) - **Hyperparathyroidism** - **Acromegaly** 4. **Coarctation of aorta** (young, differential BP arms/legs) 5. **Obstructive sleep apnea** (very common — often overlooked) 6. **Drug-induced**: oral contraceptives, NSAIDs, decongestants, glucocorticoids, illicit drugs (cocaine, amphetamines), erythropoietin Primary Aldosteronism (PA, Conn''s Syndrome) — Suspect when: - HT + hypokalemia (classic; but normokalemic PA increasingly recognized — most common now) - HT + adrenal incidentaloma - Treatment-resistant HT - Family history of PA or early-onset HT - HT + atrial fibrillation (out of proportion to risk factors) Diagnosis: 1. **Screening**: ARR (aldosterone : renin ratio) - Plasma aldosterone (PA) > 15 ng/dL - Plasma renin activity (PRA) < 1 ng/mL/hr (suppressed) or DRC low - **ARR > 30 (variable cutoffs 20-40) — positive screen** - Patient: PA 28, renin 0.4 → ARR 70 — very positive 2. **Confirmatory test** (after positive screen): - **Saline infusion test** (2 L NS over 4 hr — failure to suppress aldosterone < 5-10 ng/dL) - **Oral salt loading** (high-salt diet × 3 d — 24-hr urine aldosterone > 12 μg/24h with adequate Na) - **Captopril challenge** (aldosterone fails to suppress) - **Fludrocortisone suppression** (gold standard) Important: PRA/PA testing affected by: - Diet (salt) - Posture (upright > supine) - Medications: hold MRA (spironolactone, eplerenone) 4-6 wks before; ACEi/ARB may suppress renin (interpret carefully) - Time of day - Hypokalemia (correct first — falsely low aldosterone) 3. **Subtype Localization**: a. **Adrenal CT** — first imaging: - Adenoma (unilateral, > 6-10 mm) — APA likely - Bilateral hyperplasia (BAH) — non-surgical b. **Adrenal Venous Sampling (AVS)** — gold standard for subtype: - Confirms lateralization (aldosterone:cortisol ratio in adrenal vein) - **Endocrine Society Recommends AVS in all patients age > 35 + adenoma > 1 cm** before surgery (false-positive CT due to non-functioning adenomas common) - **Exception**: age < 35 with unilateral adenoma + classic phenotype + contralateral normal — may proceed without AVS - Performed in centers experienced (success > 90%) Treatment of Primary Aldosteronism: A. **Unilateral APA**: - **Laparoscopic adrenalectomy** — curative for APA - Outcomes: cures HT 30-40%, improves 50%, no change 10-15% (often confounded by essential HT comorbid) - Hypokalemia almost always resolves - Decreased mortality, CV events, AF B. **Bilateral Adrenal Hyperplasia (BAH)** or **Bilateral Adenomas**: - **Medical management long-term**: - **Spironolactone**: aldosterone antagonist; side effects gynecomastia, ED, menstrual irregularity (anti-androgenic) - **Eplerenone**: selective, fewer side effects but less potent - **Amiloride**: ENaC blocker — adjunct - **Other antihypertensives** as needed Pre-operative Management of PA: - **Correct hypokalemia** (KCl supplementation, MRA) - **Control BP** with MRA (spironolactone 25-100 mg, eplerenone 25-50 mg BID) - **Optimize** 2-4 weeks before surgery - Adequate Na intake (no salt restriction — aldosterone-driven Na loss) Pheochromocytoma (key differential — important to rule out before surgery): - Diagnosis: plasma free metanephrines (preferred), 24-hr urine metanephrines + catecholamines - Imaging: CT/MRI adrenal; MIBG for extra-adrenal - **Pre-op alpha-blockade** (phenoxybenzamine 7-14 days) BEFORE beta-blockade (unopposed alpha = HT crisis) - Surgical resection - Patient''s metanephrines normal → ruled out Pre-operative Considerations for Non-Adrenal Surgery in Untreated PA: - Risk of HT crisis intraop - Risk of hypokalemia → arrhythmias - Volume status altered - **Postpone elective surgery** until PA optimized — ตัวเลือก B comprehensive correct sequence. A ผิด — untreated severe HT + electrolyte abnormality elective surgery dangerous. C ผิด — quick fix misses underlying. D ผิด — secondary HT clearly diagnosed. E ผิด — postponed not canceled', NULL,
  'hard', 'endocrine_metabolic', 'review',
  'surgery', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'Endocrine Society Clinical Practice Guideline: Diagnosis and Treatment of Primary Aldosteronism 2016 (Funder JW et al. J Clin Endocrinol Metab); JNC-8 and AHA/ACC 2017 Hypertension Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 28 ปี ก่อนทำ elective laparoscopic cholecystectomy พบ blood pressure 184/108 mmHg ใน pre-op anesthesia clinic ไม่มีโรคประจำตัว ไม่ได้รับยา ค่า BP ก่อนหน้านี้ปกติเมื่อ 3 เดือน

ผู้ป่วยไม่มีอาการเลย ไม่มีปวดศีรษะ ไม่มีเหงื่อแตก ไม่มี palpitations

Vitals: BP 184/108 (วัดซ้ำห่าง 15 นาที 178/106), HR 98, RR 16, Temp 36.6°C, BMI 24
PE: ไม่มี Cushingoid features, ไม่มี abdominal bruit, ไม่มี edema, ไม่มี Café-au-lait spots

Lab: K 3.2 (low), Na 142, Cr 0.9
Urinalysis: ปกติ; renin/aldosterone ratio: aldosterone 28, renin 0.4 (suppressed) → ARR > 70 (suggestive of primary aldosteronism)
CT adrenal: 2.5 cm adenoma right adrenal gland
Plasma metanephrines: ปกติ'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 35 ปี ตั้งครรภ์ GA 28 weeks มาห้องฉุกเฉินด้วยอาการ acute appendicitis (ปวด RUQ shifted from periumbilical — atypical due to pregnancy displacing appendix), ไข้, leukocytosis 16,500

V/S: BP 122/78, HR 102, RR 18, Temp 38.2°C, fetal HR 142 (normal)
MRI abdomen (preferred in pregnancy): appendix > 8 mm enlarged with peri-appendiceal inflammation; no perforation

Obstetric assessment: no contractions, normal fetal movement, no PV bleeding

Discussion of management approach', '[{"label":"A","text":"Wait until delivery to operate"},{"label":"B","text":"Acute Appendicitis in Pregnancy — multidisciplinary management with surgery + OB + anesthesia"},{"label":"C","text":"Antibiotic alone + outpatient"},{"label":"D","text":"Termination of pregnancy"},{"label":"E","text":"Cesarean delivery + appendectomy in 28 weeks"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Appendicitis in Pregnancy — multidisciplinary management with surgery + OB + anesthesia: (1) **Timely appendectomy** (delay > 24 hr increases perforation + fetal loss risk); (2) **Laparoscopic appendectomy preferred** in 1st-2nd trimester (selected 3rd trimester); equivalent maternal outcomes, slightly higher early fetal loss in some studies but recent meta-analyses favor laparoscopic in all trimesters (Wilasrusmee BJS 2012, Walker JAMA Surg 2014); (3) Open if surgeon less experienced laparoscopically in pregnancy, or technical limitations at advanced gestation; (4) **Pre-op considerations**: - Left lateral tilt position (avoid IVC compression); - Adequate oxygenation; - CO2 insufflation pressure < 15 mmHg (concern for fetal acidosis from absorbed CO2); - Continuous fetal monitoring per gestation (24 weeks+ typically); (5) **Antibiotics**: cefoxitin or amoxicillin-clavulanate (category B); avoid fluoroquinolones, metronidazole 1st trimester (Category B but caution); single pre-op dose for uncomplicated, continue if perforated; (6) **Tocolytics** controversial — given prophylactically by some, not by others; (7) **Anti-D Rh prophylaxis** if Rh-negative + bleeding; (8) **Postoperative**: continued fetal monitoring, OB consult, VTE prophylaxis (pregnancy + surgery = high risk); (9) **Differential diagnosis** broader in pregnancy: cholecystitis (more common), pyelonephritis, ovarian torsion, round ligament pain, placental abruption, preterm labor, HELLP, ectopic late

---

Acute Appendicitis in Pregnancy — most common non-obstetric surgical emergency Incidence: 1 in 1,500-2,000 pregnancies (similar to non-pregnant women) Anatomic Changes during Pregnancy: - Appendix displaced **upward + laterally** as pregnancy progresses - 1st trimester: typical RLQ location - 2nd trimester: midabdominal - 3rd trimester: RUQ (Adams point) Clinical Challenges in Diagnosis: - Atypical pain location - Nausea/vomiting common in pregnancy (overlap) - WBC physiologically elevated in pregnancy (12,000-15,000 normal late) - Pain attribution to round ligament, contractions, or other - **Result**: delayed diagnosis → higher perforation rate (perforation 25% in pregnant vs 5% non-pregnant) Diagnosis: - **Ultrasound**: first-line, non-invasive, no radiation; but technically difficult late pregnancy - **MRI** without contrast: preferred imaging in pregnancy after non-diagnostic US (high sensitivity 90%+, no radiation, safe in 2nd-3rd trimester; 1st trimester debated but acceptable when needed) - **CT**: avoid if possible; if essential, use low-dose protocol (small radiation dose) - Avoid endoscopy in acute Outcomes — Maternal + Fetal: - **Perforated appendicitis**: fetal loss 20-35%, preterm delivery 30-40% - **Non-perforated**: fetal loss < 5%, preterm 10-15% - **Timely surgery** is most important factor Management: 1. **Resuscitation**: - IV fluid, NPO - Pain control (acetaminophen, opioids — careful 3rd trimester for neonatal respiratory depression) - **Position**: left lateral tilt > 15° (relieves IVC compression by gravid uterus → improves cardiac output) 2. **Antibiotic Therapy**: - **Safe in pregnancy** (Category B mostly): - Beta-lactams (cefoxitin, cefotetan, ceftriaxone, ampicillin-sulbactam) - Clindamycin - Erythromycin - **Caution/avoid**: - Tetracyclines (teratogenic) - Fluoroquinolones (cartilage) - Aminoglycosides (ototoxicity in fetus) - Metronidazole (1st trimester — controversial; 2nd-3rd OK) - Sulfa drugs (3rd trimester — kernicterus) 3. **Surgical Approach** (controversial historically, now well-supported): a. **Laparoscopic Appendectomy**: - **First-line in 1st + 2nd trimester** (clearly accepted) - **Second trimester traditionally preferred** if elective for any reason (less anesthetic teratogenicity, less risk of preterm labor) - **3rd Trimester**: increasingly accepted, but technically more challenging - **SAGES Guidelines 2017**: laparoscopy safe in all trimesters - **Outcomes**: equivalent maternal complications; recent meta-analyses (Walker JAMA Surg 2014, Lee EHA 2013) — laparoscopic non-inferior to open b. **Open Appendectomy**: - Open in 3rd trimester at very advanced gestation if surgeon prefers - Trauma to uterus possible - Concern about preterm labor (less than laparoscopic) - Vertical (midline) incision preferred for exposure 4. **Intra-operative Considerations**: - **Patient position**: left lateral tilt - **Initial trocar placement**: more cephalad than usual to avoid uterus - **CO2 insufflation pressure**: typically < 15 mmHg (concerns historically about fetal acidosis from absorbed CO2 — recent evidence suggests safe up to 20 mmHg) - **Fetal monitoring**: continuous if ≥ 24 weeks (depending on local practice); intermittent if < 24 weeks - **Avoid uterine manipulation** - **OB available** for fetal concerns 5. **Anesthesia**: - Regional preferred when feasible (spinal/epidural) - General anesthesia safe — modern agents not teratogenic - **Aspiration risk** — RSI standard - **Postpartum-style preoxygenation** 6. **Post-operative**: - Continued fetal monitoring (24 hr or per OB) - **OB consult** - **Tocolytics** if uterine activity (controversial — prophylactic use debated; selective for established contractions) - **VTE prophylaxis** (pregnancy + post-op = very high risk) - Pain control - Early ambulation 7. **Anti-D Rh prophylaxis** if Rh-negative mother + bleeding or surgery in 3rd trimester 8. **Differential in Pregnancy** (broader): - Cholecystitis (more common due to bile stasis) - Pyelonephritis - Ovarian torsion (urgent if suspected) - Round ligament pain - Adnexal mass with torsion - Preterm labor - Placental abruption - HELLP syndrome (presenting with RUQ pain) - Hyperemesis gravidarum - Ectopic (late — rare) Perforated Appendicitis: - More aggressive antibiotic, drainage, possible interval appendectomy - Higher morbidity for mother + fetus - Often requires more extensive surgery (resection + ostomy) Outcomes (Modern): - Maternal mortality very low (< 0.1%) - Fetal loss: 2-5% non-perforated, 20-35% perforated - Preterm delivery: 10-15% non-perforated, 30-40% perforated - Earlier diagnosis = better outcomes — ตัวเลือก B comprehensive. A ผิดอย่างยิ่ง — delayed = perforation, fetal loss. C ผิด — uncomplicated antibiotic management not proven safe in pregnancy. D ผิดอย่างยิ่ง. E ผิด — premature delivery 28 weeks high morbidity', NULL,
  'medium', 'obgyn', 'review',
  'surgery', 'clinical_decision', 'obgyn', 'adult',
  'SAGES Guidelines for Laparoscopic Surgery in Pregnancy 2017 (Pearl JP et al. Surg Endosc); Walker HG et al. JAMA Surg 2014 (Laparoscopic vs Open Appendectomy in Pregnancy); RCOG Green-top Guideline: Abdominal Pain in Pregnancy', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 35 ปี ตั้งครรภ์ GA 28 weeks มาห้องฉุกเฉินด้วยอาการ acute appendicitis (ปวด RUQ shifted from periumbilical — atypical due to pregnancy displacing appendix), ไข้, leukocytosis 16,500

V/S: BP 122/78, HR 102, RR 18, Temp 38.2°C, fetal HR 142 (normal)
MRI abdomen (preferred in pregnancy): appendix > 8 mm enlarged with peri-appendiceal inflammation; no perforation

Obstetric assessment: no contractions, normal fetal movement, no PV bleeding

Discussion of management approach'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 42 ปี post-laparoscopic cholecystectomy day 5 มาห้องฉุกเฉินด้วยอาการ ไข้, ปวด RUQ, jaundice, bilirubin 6.2 ตรวจ MRCP พบ bile duct injury (Strasberg E2 — common bile duct transection > 2 cm from confluence) + bile collection 6 cm in subhepatic space

V/S: BP 122/74, HR 96, RR 18, Temp 38.4°C, WBC 14,500', '[{"label":"A","text":"Repeat laparoscopy + simple suture repair"},{"label":"B","text":"Major Bile Duct Injury (Strasberg E2) post-cholecystectomy — multidisciplinary referral to HPB center"},{"label":"C","text":"Conservative observation only"},{"label":"D","text":"Total hepatectomy + transplant"},{"label":"E","text":"Discharge with oral antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Major Bile Duct Injury (Strasberg E2) post-cholecystectomy — multidisciplinary referral to HPB center: (1) **Control sepsis** — IV antibiotics + percutaneous drainage of biloma + ERCP with stent or PTBD for biliary diversion; (2) **Delayed definitive reconstruction** 6-8 weeks later (allow inflammation to resolve) — **Roux-en-Y hepaticojejunostomy** is gold standard; (3) Avoid attempts at primary repair in non-HPB centers (high stricture/leak rate); (4) Long-term complications: stricture (10-30%), recurrent cholangitis, secondary biliary cirrhosis; (5) Medico-legal documentation

---

Bile duct injury (BDI) — feared complication of cholecystectomy (0.3-0.6%). Strasberg classification A-E (E1-E5 = main duct injuries). Management principles: control sepsis (drainage + antibiotic), divert bile (ERCP/PTBD), refer to HPB specialist, delayed Roux-en-Y hepaticojejunostomy at 6-8 weeks for major injuries. Primary repair attempts by non-specialists have high failure rate (stricture, recurrent cholangitis, secondary cirrhosis). Outcome depends on time to specialist referral and surgeon expertise. A wrong — simple suture fails. C wrong — biloma + sepsis can''t observe. D wrong — transplant for end-stage liver only. E wrong — outpatient unsafe.', NULL,
  'hard', 'gi', 'review',
  'surgery', 'clinical_decision', 'gi', 'adult',
  'Strasberg SM et al. J Am Coll Surg 1995 (Classification); ATOM/Sicklick Ann Surg 2005 (BDI management); SAGES Safe Cholecystectomy Program', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 42 ปี post-laparoscopic cholecystectomy day 5 มาห้องฉุกเฉินด้วยอาการ ไข้, ปวด RUQ, jaundice, bilirubin 6.2 ตรวจ MRCP พบ bile duct injury (Strasberg E2 — common bile duct transection > 2 cm from confluence) + bile collection 6 cm in subhepatic space

V/S: BP 122/74, HR 96, RR 18, Temp 38.4°C, WBC 14,500'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident surgery ถามอาจารย์เรื่อง wound healing physiology อาจารย์อธิบายเรื่อง phases of wound healing + factors affecting healing

คำถาม: phases ของ wound healing ตามลำดับ + key cells ในแต่ละ phase', '[{"label":"A","text":"Inflammation → proliferation → remodeling (collagen synthesis only)"},{"label":"B","text":"overlapping phases"},{"label":"C","text":"Coagulation only"},{"label":"D","text":"Epithelialization first then inflammation"},{"label":"E","text":"Single-phase process"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **4 overlapping phases**: (1) **Hemostasis** (immediate-hours): platelet aggregation + fibrin clot + vasoconstriction; (2) **Inflammation** (0-3 days): neutrophils (24-48h) → macrophages (key cell, phagocytosis + growth factors VEGF, PDGF, TGF-β); (3) **Proliferation** (3 days - 3 weeks): fibroblasts (collagen Type III), angiogenesis (endothelial cells, VEGF), epithelialization (keratinocytes); granulation tissue formation; (4) **Remodeling** (3 weeks - 1 year+): collagen Type III replaced by Type I (stronger), wound contraction (myofibroblasts), tensile strength reaches max 80% of original at 1 year

---

Wound healing has 4 overlapping phases. Key cells: platelets (hemostasis), neutrophils + macrophages (inflammation — macrophages most important, transition cell), fibroblasts + endothelial cells + keratinocytes (proliferation), myofibroblasts (contraction in remodeling). Collagen Type III deposited first then replaced by Type I (stronger triple-helix). Final tensile strength ~ 80% (never 100%). Factors impairing: DM, malnutrition, steroids, smoking, radiation, ischemia, infection, age. A incomplete. C-E wrong.', NULL,
  'easy', 'procedures', 'review',
  'surgery', 'basic_science', 'procedures', 'adult',
  'Sabiston Textbook of Surgery 21st ed Ch. 7; Schwartz Principles of Surgery 11th ed Ch. 9', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'Resident surgery ถามอาจารย์เรื่อง wound healing physiology อาจารย์อธิบายเรื่อง phases of wound healing + factors affecting healing

คำถาม: phases ของ wound healing ตามลำดับ + key cells ในแต่ละ phase'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี เข้ารับการผ่าตัด elective abdominal surgery (open colectomy) ต้องประเมิน perioperative cardiac risk

ROSE Revised Cardiac Risk Index (RCRI) factors: high-risk surgery + ischemic heart disease + heart failure + cerebrovascular disease + insulin-treated DM + Cr > 2', '[{"label":"A","text":"Cardiac risk same for all surgeries"},{"label":"B","text":"Lee''s Revised Cardiac Risk Index (RCRI)"},{"label":"C","text":"All patients need echo and stress test"},{"label":"D","text":"Always cancel surgery if any cardiac risk"},{"label":"E","text":"Routine cardiac catheterization pre-op"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Lee''s Revised Cardiac Risk Index (RCRI)** — 6 factors, 1 point each: (1) High-risk surgery (intraperitoneal, intrathoracic, suprainguinal vascular); (2) Ischemic heart disease (prior MI, angina, positive stress test, nitrate use, Q-wave on EKG); (3) Heart failure history; (4) Cerebrovascular disease (TIA/stroke); (5) Insulin-treated DM; (6) Cr > 2 mg/dL. Risk of major cardiac event: 0 factors = 0.4%, 1 = 1%, 2 = 2.4%, ≥3 = 5.4%+. AHA/ACC 2014 stepwise approach: (1) Emergent? → proceed; (2) Active cardiac condition (unstable angina, decompensated HF, severe arrhythmia, valvular disease) → optimize first; (3) Low-risk surgery → proceed; (4) Functional capacity ≥ 4 METs → proceed; (5) RCRI + functional capacity guides further testing (stress test, echo); (6) Optimize medical therapy (continue beta-blockers if already on; statins; ACEi/ARB consideration)

---

RCRI (Lee 1999) widely used. Each factor = 1 point. Risk stratifies major adverse cardiac events. AHA/ACC 2014 + ESC perioperative guidelines emphasize stepwise approach + functional capacity (METs — 4 METs = climb stairs, walk uphill). Optimize comorbidities, continue chronic medications (beta-blockers, statins), evaluate active cardiac conditions, additional testing only if changes management. Pre-op coronary revascularization not routinely beneficial (CARP trial). A wrong — surgery-specific. C wrong — selective. D wrong — risk stratification, not blanket cancellation. E wrong — invasive, not first-line.', NULL,
  'medium', 'cardiovascular', 'review',
  'surgery', 'basic_science', 'cardiovascular', 'adult',
  'Lee TH et al. Circulation 1999 (RCRI); Fleisher LA et al. JACC 2014 (AHA/ACC Perioperative Guidelines); ESC/ESA Guidelines on Non-Cardiac Surgery 2022', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี เข้ารับการผ่าตัด elective abdominal surgery (open colectomy) ต้องประเมิน perioperative cardiac risk

ROSE Revised Cardiac Risk Index (RCRI) factors: high-risk surgery + ischemic heart disease + heart failure + cerebrovascular disease + insulin-treated DM + Cr > 2'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Surgeon ออกข้อสอบเรื่อง surgical infection + antibiotic prophylaxis อาจารย์อธิบาย wound classification + recommendations', '[{"label":"A","text":"All surgeries need same prophylaxis"},{"label":"B","text":"Wound classification (CDC)"},{"label":"C","text":"Antibiotics for 7 days for all surgeries"},{"label":"D","text":"No antibiotics ever needed"},{"label":"E","text":"Topical antibiotics only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Wound classification** (CDC): (1) **Clean**: no inflammation, no entry into GI/GU/respiratory tract — SSI 1-2% — e.g., hernia, breast (prophylaxis typically not needed unless prosthesis/foreign body); (2) **Clean-contaminated**: GI/GU/respiratory entered under controlled conditions — SSI 5-10% — e.g., elective colectomy, cholecystectomy — single pre-op antibiotic dose; (3) **Contaminated**: gross spillage, fresh trauma, acute inflammation — SSI 15-20% — therapeutic antibiotic 24h; (4) **Dirty/Infected**: pus, perforated viscus, devitalized tissue — SSI > 30% — therapeutic antibiotic full course. **Prophylaxis principles**: appropriate agent (typically 1st-gen cephalosporin for skin flora; add metronidazole for colorectal), within 60 min before incision (within 120 min for vancomycin/fluoroquinolone), re-dose for long procedures (3-4h), single dose for most, discontinue within 24h post-op (NSQIP)

---

Surgical wound classification CDC + ACS NSQIP guides antibiotic prophylaxis + SSI prevention. Key principles: (1) appropriate drug (skin flora for most; gut flora for colorectal); (2) timing within 60 min of incision (correct timing strongest predictor); (3) adequate dose (weight-based for obese); (4) redosing for prolonged surgery; (5) discontinue ≤ 24h (longer = no benefit + resistance). Other SSI prevention: glycemic control, normothermia, chlorhexidine skin prep, smoking cessation, no shaving (clipping), oxygen optimization. Bundle approach (Centre Comprehensive Unit Safety) reduces SSI.', NULL,
  'medium', 'id', 'review',
  'surgery', 'basic_science', 'id', 'adult',
  'CDC Guideline for the Prevention of Surgical Site Infection 2017; ACS NSQIP Surgical Care Improvement Project; Bratzler DW et al. CID 2013', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'Surgeon ออกข้อสอบเรื่อง surgical infection + antibiotic prophylaxis อาจารย์อธิบาย wound classification + recommendations'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Surgery resident ถามอาจารย์เรื่อง shock physiology + management — distinguish types of shock with hemodynamic profiles

คำถาม: 4 ชนิด shock + hemodynamic patterns + first-line resuscitation', '[{"label":"A","text":"All shock treated same way with IV fluid"},{"label":"B","text":"types of shock + patterns"},{"label":"C","text":"Vasopressor first-line for all shock"},{"label":"D","text":"Beta-blocker for all shock"},{"label":"E","text":"Restrict fluid for all shock"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **4 types of shock + patterns**: (1) **Hypovolemic** (hemorrhage, dehydration): ↓CVP, ↓PCWP, ↓CO, ↑SVR — Rx: fluid + blood; (2) **Cardiogenic** (MI, HF): ↑CVP, ↑PCWP, ↓CO, ↑SVR — Rx: revascularization (PCI), inotrope (dobutamine, milrinone), mechanical support (IABP, Impella, ECMO), avoid excess fluid; (3) **Obstructive** (PE, tamponade, tension pneumothorax): ↑CVP, varies, ↓CO, ↑SVR — Rx: relieve obstruction (thrombolysis/thrombectomy for PE, pericardiocentesis for tamponade, needle decompression for tension pneumo); (4) **Distributive** (septic, anaphylactic, neurogenic): ↓-N CVP/PCWP, ↑CO (early septic), ↓↓SVR — Rx for septic: 30 mL/kg crystalloid + broad-spectrum antibiotic + norepinephrine + source control; anaphylactic: epinephrine; neurogenic: fluid + phenylephrine. Goal: MAP > 65, urine output > 0.5 mL/kg/hr, lactate clearance, mental status

---

Shock = inadequate tissue oxygen delivery. Etiology-specific management essential. Hypovolemic (most common in surgery — trauma, GI bleed): restore volume + control source. Cardiogenic: pump failure — increase CO with inotrope, avoid excess fluid. Obstructive: relieve obstruction. Distributive: vasodilation — fluid + vasopressor + treat cause. Goals: MAP, urine output, lactate, mental status, ScvO2. Avoid one-size-fits-all approach. Modern multi-modal monitoring (TTE, lactate, capillary refill, cardiac output monitoring) guides individualized therapy.', NULL,
  'medium', 'cardiovascular', 'review',
  'surgery', 'basic_science', 'cardiovascular', 'adult',
  'Surviving Sepsis Campaign 2021; Vincent JL, De Backer D NEJM 2013 (Circulatory Shock); Marino''s ICU Book 5th ed Ch. 13', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'Surgery resident ถามอาจารย์เรื่อง shock physiology + management — distinguish types of shock with hemodynamic profiles

คำถาม: 4 ชนิด shock + hemodynamic patterns + first-line resuscitation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital ต้องการลด surgical site infection (SSI) ใน colorectal surgery จาก 12% เป็น < 5% ทีม quality improvement ตั้ง bundle intervention

คำถาม: SSI prevention bundle ที่มี evidence ดี', '[{"label":"A","text":"Single intervention is enough"},{"label":"B","text":"SSI Prevention Bundle for Colorectal Surgery"},{"label":"C","text":"Antibiotic for 14 days for all"},{"label":"D","text":"Avoid hand hygiene"},{"label":"E","text":"Always operate at night when stable"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **SSI Prevention Bundle for Colorectal Surgery** (multifaceted, evidence-based): (1) **Pre-op**: chlorhexidine + alcohol skin prep, oral antibiotic + mechanical bowel prep (combined — recent evidence favors), antibiotic prophylaxis within 60 min, normothermia (warm IV + air blanket), glycemic control (target glucose < 180), smoking cessation, hair removal by clipping (not shaving), nutritional optimization; (2) **Intra-op**: maintain normothermia, antibiotic re-dose at 3-4h, wound protector, surgeon glove change, sterile instruments for closure, supplemental oxygen 80% FiO2 (debated); (3) **Post-op**: glycemic control, early ambulation, sterile dressing 48h, daily wound assessment, antibiotic discontinue ≤ 24h; (4) **Bundle approach** reduces SSI 30-50% per ACS NSQIP, Keystone Project, IHI; (5) Audit + feedback + continuous improvement; (6) Multidisciplinary team — surgeon, anesthesia, nursing, pharmacy

---

SSI prevention bundle = multiple evidence-based interventions delivered together. Most effective when reliably applied. ACS NSQIP, CMS SCIP measures track key metrics. Bundle approach reduces SSI 30-50% in colorectal surgery (Cima R et al. JACS 2013, ACS Bundles 2015). Patient education + engagement also important. Sustained improvement requires culture change + leadership commitment + data feedback. A wrong — bundle better. C wrong — prolonged antibiotic ↑ resistance. D-E wrong absurd.', NULL,
  'medium', 'id', 'review',
  'surgery', 'ems_mgmt', 'id', 'adult',
  'ACS Bundles for SSI Prevention 2015; CDC HICPAC SSI Guideline 2017; Keenan JE et al. JAMA Surg 2014 (Colorectal Bundle Outcomes)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'Hospital ต้องการลด surgical site infection (SSI) ใน colorectal surgery จาก 12% เป็น < 5% ทีม quality improvement ตั้ง bundle intervention

คำถาม: SSI prevention bundle ที่มี evidence ดี'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital trauma center พบ trauma death สูง — wants to implement Enhanced Recovery After Surgery (ERAS) for elective surgery + Trauma Quality Improvement Program (TQIP)

คำถาม: ERAS pathway สำหรับ colorectal surgery + key components', '[{"label":"A","text":"Prolonged NPO + IV fluid loading + bed rest"},{"label":"B","text":"ERAS Pathway for Colorectal Surgery"},{"label":"C","text":"Routine nasogastric tube + 5-day NPO"},{"label":"D","text":"Opioid-based analgesia preferred"},{"label":"E","text":"No exercise until full recovery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **ERAS Pathway for Colorectal Surgery** (multimodal evidence-based, reduces LOS 30%, complications 30-50%): (1) **Pre-admission**: counseling, smoking + alcohol cessation, anemia + nutrition optimization, prehabilitation; (2) **Pre-op**: avoid prolonged fasting (clear liquids until 2h pre-op, solids until 6h), carbohydrate loading 2h pre-op, no premedication routinely, mechanical + oral antibiotic bowel prep (recent), antibiotic prophylaxis + DVT prophylaxis, skin prep with chlorhexidine; (3) **Intra-op**: minimally invasive approach when possible, normothermia, goal-directed fluid therapy (avoid excess), short-acting anesthetic, multimodal pain (avoid opioid-only), regional block (TAP block, epidural for some), avoid NG tube routine, restrictive transfusion; (4) **Post-op**: early oral diet (immediately or within 24h), early mobilization (within 24h), multimodal analgesia (NSAID + acetaminophen + gabapentin + minimal opioid), DVT prophylaxis continued, glycemic control, remove urinary catheter < 24h, NG tube avoided, ileus prevention (alvimopan in selected); (5) **Audit + improvement** — ERAS compliance correlates with outcomes

---

ERAS = multimodal evidence-based perioperative care pathway. ERAS Society publishes guidelines per specialty. Colorectal ERAS reduces LOS 2-3 days, complications 30-50%, readmissions, costs without compromising safety (Kehlet H, Wilmore DW Ann Surg 2008; ERAS Society Guidelines). Key principles: minimize physiologic stress, restore homeostasis quickly, multidisciplinary + standardized + audited. Compliance with elements correlates with outcomes (>70% compliance = best outcomes). Implementation requires institutional commitment, education, audit.', NULL,
  'medium', 'gi', 'review',
  'surgery', 'ems_mgmt', 'gi', 'adult',
  'ERAS Society Guidelines: Colorectal Surgery 2018; Ljungqvist O et al. JAMA Surg 2017 (ERAS Review); Gustafsson UO et al. World J Surg 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'Hospital trauma center พบ trauma death สูง — wants to implement Enhanced Recovery After Surgery (ERAS) for elective surgery + Trauma Quality Improvement Program (TQIP)

คำถาม: ERAS pathway สำหรับ colorectal surgery + key components'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital wants implement Trauma Quality Improvement Program (TQIP) — measure + improve trauma outcomes

คำถาม: Trauma system organization + key quality metrics', '[{"label":"A","text":"Single hospital provides all trauma care"},{"label":"B","text":"Trauma System (regionalized)"},{"label":"C","text":"Avoid data collection"},{"label":"D","text":"Each hospital independent — no coordination"},{"label":"E","text":"Only major trauma centers needed"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Trauma System** (regionalized): (1) **Level I** (highest): comprehensive care, research, education, 24h subspecialty coverage, > 1200 trauma admissions/year; (2) **Level II**: comprehensive care, may not have research; (3) **Level III**: ER + ICU + surgical capability, transfer for higher level; (4) **Level IV/V**: stabilize + transfer. **Inclusive trauma system** — all hospitals participate. **Pre-hospital**: triage criteria (CDC field triage), transport to appropriate level. **TQIP/ACS Quality Improvement**: data submission (registry), risk-adjusted outcomes, benchmarking, monthly multidisciplinary morbidity + mortality conferences, root cause analysis. **Key metrics**: mortality (overall, preventable, expected), undertriage/overtriage rates, time to OR, time to CT, time to interventional radiology, blood transfusion ratios, VTE rates, decubitus ulcer, ventilator-associated pneumonia, central line infection, return to OR, readmission. **TQIP benchmarking** shows performance vs comparable centers

---

Trauma system organization → improved outcomes vs non-system care (West JG JAMA 1979, MacKenzie EJ NEJM 2006). ACS-COT criteria for verification (Level I-V). Inclusive system: all hospitals participate at appropriate level. Pre-hospital triage critical. TQIP (Trauma Quality Improvement Program) launched 2010 by ACS — risk-adjusted benchmarking from > 800 centers. Drives quality improvement through transparent comparison + PI cycles. Modern trauma care: damage control, balanced resuscitation, REBOA, multidisciplinary, multimodal monitoring.', NULL,
  'easy', 'trauma', 'review',
  'surgery', 'ems_mgmt', 'trauma', 'adult',
  'ACS Resources for Optimal Care of the Injured Patient 2014 (Trauma System); MacKenzie EJ et al. NEJM 2006 (Trauma System Outcomes); ACS TQIP Annual Report', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'Hospital wants implement Trauma Quality Improvement Program (TQIP) — measure + improve trauma outcomes

คำถาม: Trauma system organization + key quality metrics'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 78 ปี มีหลายโรค (CAD post-PCI, HFrEF EF 35%, CKD stage 3, COPD GOLD II, frailty CFS 6) มา OPD ด้วย symptomatic gallstone disease — recurrent biliary colic + recent acute cholecystitis ทำ percutaneous cholecystostomy แล้วดีขึ้น ตอนนี้ tube ออกแล้ว pain free 6 weeks

ปรึกษาเรื่อง cholecystectomy', '[{"label":"A","text":"Always operate regardless of risk"},{"label":"B","text":"Multidisciplinary frailty + risk-benefit assessment — integrative geriatric + surgical decision-making","difficulty":"hard"},{"label":"C","text":"Always conservative regardless of symptoms"},{"label":"D","text":"Total gastrectomy"},{"label":"E","text":"ERCP only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Multidisciplinary frailty + risk-benefit assessment — integrative geriatric + surgical decision-making: (1) **Frailty assessment** (Clinical Frailty Scale, FRAIL scale, Edmonton Frail Scale) — CFS 6 = moderately frail → significantly increased post-op morbidity/mortality; (2) **Comprehensive Geriatric Assessment** (CGA): medical optimization (HF, CAD, CKD, COPD), cognitive, functional, nutritional, psychosocial; (3) **Shared decision-making** with patient + family: discuss goals of care, life expectancy, quality of life, surgical risk vs ongoing symptom burden, alternative (interval cholecystostomy, lithotripsy controversial, conservative); (4) **Pre-habilitation** if proceeding: exercise, nutrition, smoking cessation, comorbidity optimization 4-6 weeks; (5) **Surgical options**: laparoscopic cholecystectomy preferred (lower morbidity); subtotal cholecystectomy if difficult anatomy; (6) **Anesthesia consult**, ERAS pathway, multimodal analgesia (avoid opioids in elderly), early mobilization; (7) **Post-op**: high-risk admission with cardiology + geriatric co-management; (8) Post-discharge: rehabilitation, medication reconciliation, fall prevention; (9) Some elderly with prohibitive risk + limited life expectancy: leave cholecystostomy long-term or conservative management

---

Frail elderly surgical decision-making = integrative — surgical + medical + geriatric + functional + values. Frailty (CFS ≥ 5) independently predicts post-op morbidity, mortality, LOS, institutionalization. Shared decision-making essential — consider patient values, life expectancy, alternative therapies. Pre-habilitation can reduce risk (multiple RCTs). Comprehensive multidisciplinary care improves outcomes. ACS Geriatric Surgery Verification Program + Strong for Surgery + NSQIP Geriatric promote integrated care. A wrong — risk-benefit individualized. C wrong — symptomatic + low risk surgery acceptable. D-E wrong irrelevant.', NULL,
  'hard', 'gi', 'review',
  'surgery', 'integrative', 'gi', 'adult',
  'ACS Geriatric Surgery Verification Program 2019; Rockwood K et al. CMAJ 2005 (Clinical Frailty Scale); Robinson TN et al. Ann Surg 2013 (Frailty + Surgical Outcomes)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ผู้ป่วยอายุ 78 ปี มีหลายโรค (CAD post-PCI, HFrEF EF 35%, CKD stage 3, COPD GOLD II, frailty CFS 6) มา OPD ด้วย symptomatic gallstone disease — recurrent biliary colic + recent acute cholecystitis ทำ percutaneous cholecystostomy แล้วดีขึ้น ตอนนี้ tube ออกแล้ว pain free 6 weeks

ปรึกษาเรื่อง cholecystectomy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี multitrauma post-MVC (motor vehicle crash) — splenic injury Grade IV + femur fracture + closed head injury + pelvic fracture

Day 3 ICU: hemodynamically stable, intubated, requiring blood products + inotropes weaning

คำถาม: multidisciplinary management of polytrauma + key principles', '[{"label":"A","text":"Treat each injury separately by individual specialists"},{"label":"B","text":"Polytrauma Multidisciplinary Integrative Management"},{"label":"C","text":"Operate on all injuries day 1"},{"label":"D","text":"Discharge home with outpatient follow-up"},{"label":"E","text":"Single specialist manages all"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Polytrauma Multidisciplinary Integrative Management** — coordinated by trauma team: (1) **Trauma team leader** coordinates overall care + family communication; (2) **Damage Control Resuscitation** during initial phase: balanced 1:1:1 transfusion, permissive hypotension if no TBI, normothermia, calcium replacement, TXA early; (3) **Damage Control Surgery**: stop hemorrhage + contamination, temporary closure, ICU resuscitation, return for definitive surgery 24-72h; (4) **Specialty consults**: trauma surgery, orthopedics (femur fracture — early total care vs damage control orthopedics depending on physiology), neurosurgery (TBI — ICP monitoring, CPP > 60), vascular (pelvic — angiography + embolization, REBOA in selected); (5) **ICU**: ventilator strategy (low TV, lung protective), sedation + analgesia (ABCDEF bundle), DVT prophylaxis (mechanical until safe for chemical, then start early), nutrition (enteral early), glycemic control, infection surveillance + antibiotic stewardship; (6) **Continuous reassessment** for missed injuries (tertiary survey), compartment syndrome, abdominal compartment syndrome, second hits; (7) **Rehab early**: PT/OT in ICU, mobility protocols; (8) **Psychological support**: PTSD risk, family support, social work; (9) **Discharge planning**: rehabilitation facility, outpatient follow-up multi-specialty; (10) **Long-term outcomes**: functional, vocational, psychological — multidisciplinary follow-up clinic

---

Polytrauma management = quintessentially integrative + multidisciplinary. Modern principles: damage control resuscitation + damage control surgery (Hirshberg, Holcomb), early balanced transfusion (PROPPR), TBI-aware sequencing, lung-protective ventilation, ABCDEF ICU bundle, early mobility + rehab. Coordinated trauma team (surgeon + intensivist + specialty consultants) — single point of accountability. Tertiary survey for missed injuries (5-10% miss rate). Long-term outcomes depend on coordinated care across acute + rehab + outpatient phases. Outcomes 30-40% better in dedicated trauma centers vs general hospital (MacKenzie NEJM 2006).', NULL,
  'hard', 'trauma', 'review',
  'surgery', 'integrative', 'trauma', 'adult',
  'ATLS 10th Edition; PROPPR Trial JAMA 2015; ACS Resources for Optimal Care of the Injured Patient; Pape HC et al. JOT 2018 (Polytrauma Management)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี multitrauma post-MVC (motor vehicle crash) — splenic injury Grade IV + femur fracture + closed head injury + pelvic fracture

Day 3 ICU: hemodynamically stable, intubated, requiring blood products + inotropes weaning

คำถาม: multidisciplinary management of polytrauma + key principles'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 62 ปี post-Whipple procedure for pancreatic head adenocarcinoma 6 months ago — adjuvant chemotherapy completed mFOLFIRINOX × 12 cycles

Now asymptomatic, CA 19-9 rising 35 → 88 → 142 over 3 visits, CT scan shows new 2 cm hepatic lesion + suspicious peritoneal nodule

คำถาม: management approach for recurrent pancreatic cancer', '[{"label":"A","text":"Whipple repeat"},{"label":"B","text":"Recurrent metastatic pancreatic cancer — integrative palliative + oncologic approach"},{"label":"C","text":"Aggressive surgery only"},{"label":"D","text":"Stop all treatment immediately"},{"label":"E","text":"Chemotherapy without palliative care"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Recurrent metastatic pancreatic cancer — integrative palliative + oncologic approach**: (1) **Confirm recurrence**: biopsy of liver lesion if feasible (or peritoneal if accessible) to confirm + characterize; (2) **Multidisciplinary tumor board**: medical oncology + surgical + radiation + palliative; (3) **Systemic therapy** (second-line based on prior FOLFIRINOX + performance status): - **Gemcitabine + nab-paclitaxel** if not used; - **5-FU/leucovorin + nanoliposomal irinotecan** (NAPOLI-1); - **Targeted/precision**: olaparib if BRCA1/2 germline + platinum-responsive (POLO trial); pembrolizumab if MSI-high; (4) **Performance status assessment** ECOG — if 0-1, treat actively; 2 may treat selectively; 3-4 best supportive care; (5) **Concurrent palliative care** from diagnosis (Temel NEJM 2010 — survival + QOL benefit even in pancreatic Ca); (6) **Symptom management**: pain (multimodal analgesic ladder, celiac plexus block consideration), nutrition (PERT for exocrine insufficiency, weight loss), psychological, fatigue, ascites (paracentesis if symptomatic); (7) **Advance care planning**: goals of care discussion, advance directive, healthcare proxy, hospice when appropriate; (8) **Family support**: anticipatory grief, caregiver burden; (9) Survivorship + survivorship care plan if extended survival; (10) Spiritual + cultural support

---

Recurrent pancreatic cancer = integrative cancer + palliative care. Median survival recurrent unresectable PDAC: 6-12 months with second-line. Treatment decisions must balance: prognosis, performance status, comorbidities, patient values, quality of life. Second-line options based on first-line + biomarkers (BRCA, MSI). Concurrent palliative care improves QOL, may extend survival (Temel JCO 2010). Decision-making collaborative — patient + family + multidisciplinary team. Advance care planning essential. Hospice when life expectancy < 6 months + comfort-focused goals. Survivorship for long-term responders.', NULL,
  'hard', 'hemato_onco', 'review',
  'surgery', 'integrative', 'hemato_onco', 'adult',
  'NCCN Pancreatic Adenocarcinoma 2024; Wang-Gillam A et al. Lancet 2016 (NAPOLI-1); Temel JS et al. NEJM 2010 (Early Palliative Care); Golan T et al. NEJM 2019 (POLO Trial — Olaparib)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ผู้ป่วยอายุ 62 ปี post-Whipple procedure for pancreatic head adenocarcinoma 6 months ago — adjuvant chemotherapy completed mFOLFIRINOX × 12 cycles

Now asymptomatic, CA 19-9 rising 35 → 88 → 142 over 3 visits, CT scan shows new 2 cm hepatic lesion + suspicious peritoneal nodule

คำถาม: management approach for recurrent pancreatic cancer'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 24 ปี ขับมอเตอร์ไซค์ชนเสาไฟฟ้า ถูกนำส่ง ER ใส่ collar มา

V/S: BP 92/60, HR 124, RR 28, SpO2 91% room air
Gen: somnolent, GCS E2V3M5 = 10
Neck vein flat
Chest: right side decreased breath sound + hyperresonance + tracheal deviation to left + subcutaneous emphysema
Abdomen: soft, no peritonitis

คำถาม: ขั้นตอนแรกที่ต้องทำคืออะไร', '[{"label":"A","text":"Chest X-ray portable ก่อนแล้วค่อยตัดสินใจ"},{"label":"B","text":"Tension pneumothorax — immediate needle decompression"},{"label":"C","text":"CT chest urgent"},{"label":"D","text":"Intubate before chest decompression"},{"label":"E","text":"Pericardiocentesis"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Tension pneumothorax — immediate needle decompression** ที่ 5th intercostal space anterior axillary line (ATLS 10th edition update — เดิมคือ 2nd ICS MCL แต่ผนังหน้าอกหนาในผู้ใหญ่ทำให้เข็ม 5 cm ไม่ถึง pleural space ในบางคน) ตามด้วยการใส่ **tube thoracostomy** (chest tube 28-32 Fr) อย่างเร่งด่วน; การวินิจฉัย tension pneumothorax เป็น clinical diagnosis ไม่ต้องรอ CXR (รอ imaging = death); concurrent resuscitation + secure airway

---

Tension pneumothorax เป็น clinical diagnosis — air ใน pleural space ทำให้ mediastinum เคลื่อน, vena cava ถูกกด, venous return ลดลง, obstructive shock เกิดได้เร็ว Classic findings: respiratory distress, tracheal deviation away from affected side, hyperresonance, decreased breath sounds, distended neck veins (อาจ flat ถ้า hypovolemia), hemodynamic compromise ATLS 10th edition: ตำแหน่ง needle decompression สำหรับ adult = 5th ICS anterior axillary line (เข็ม 14G 5 cm) เพราะ chest wall thickness ที่ 2nd ICS MCL อาจมากกว่า 5 cm ใน 30-50% ของคนไข้. ในเด็กยังคงใช้ 2nd ICS MCL. หลัง decompression แล้ว ต้อง tube thoracostomy เสมอ. A ผิด — ห้ามรอ CXR ใน tension pneumothorax. C ผิด — ห้ามส่ง CT. D ผิด — positive pressure ventilation จะทำให้อาการแย่ลงเร็ว ควร decompress ก่อน intubate ถ้าทำได้. E ผิด — ไม่ใช่ pericardial.', NULL,
  'easy', 'trauma', 'review',
  'surgery', 'clinical_decision', 'trauma', 'adult',
  'ATLS Advanced Trauma Life Support 10th Edition — Chapter 4 Thoracic Trauma; Inaba K et al. J Trauma 2011 (needle thoracostomy depth)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 24 ปี ขับมอเตอร์ไซค์ชนเสาไฟฟ้า ถูกนำส่ง ER ใส่ collar มา

V/S: BP 92/60, HR 124, RR 28, SpO2 91% room air
Gen: somnolent, GCS E2V3M5 = 10
Neck vein flat
Chest: right side decreased breath sound + hyperresonance + tracheal deviation to left + subcutaneous emphysema
Abdomen: soft, no peritonitis

คำถาม: ขั้นตอนแรกที่ต้องทำคืออะไร'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 36 ปี รถยนต์ชนต้นไม้ความเร็วสูง คาดเข็มขัดนิรภัย air bag ทำงาน

V/S: BP 78/40, HR 138, RR 26, SpO2 96%
Gen: pale, diaphoretic, JVP elevated, muffled heart sounds, Beck''s triad positive
Chest: clear breath sounds bilaterally
Abdomen: soft

FAST exam: pericardial effusion มาก, RV collapse in diastole', '[{"label":"A","text":"IV fluid bolus 2 liter normal saline"},{"label":"B","text":"Cardiac tamponade — emergent decompression"},{"label":"C","text":"Beta-blocker IV เพื่อลด HR"},{"label":"D","text":"CT chest with contrast ก่อนตัดสินใจ"},{"label":"E","text":"Observation in ICU"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Cardiac tamponade — emergent decompression**: (1) IV fluid bolus to optimize preload (bridge); (2) **Emergent pericardiocentesis** (subxiphoid approach with US guidance) — temporizing; (3) **Definitive: emergent median sternotomy หรือ left anterior thoracotomy** (resuscitative thoracotomy) for traumatic tamponade เพื่อ relieve tamponade + repair cardiac injury; (4) Trauma + CT surgery activation; type & cross 6 units PRC; massive transfusion protocol on standby; (5) Avoid intubation with high PEEP — จะลด venous return ทำให้ shock แย่ลง

---

Cardiac tamponade — Beck''s triad: hypotension + muffled heart sounds + distended neck veins (Kussmaul sign = paradoxical JVD on inspiration). Pulsus paradoxus > 10 mmHg. FAST sensitivity 90-95% สำหรับ pericardial effusion. ในผู้ป่วย penetrating trauma หรือ blunt cardiac injury ที่มี tamponade ต้องเปิด pericardium ทันที — pericardiocentesis อาจช่วยชั่วคราว แต่ definitive คือ thoracotomy/sternotomy. ใน blunt trauma มักจาก cardiac rupture, ใน penetrating จาก stab wound. Resuscitative ED thoracotomy พิจารณาใน penetrating chest trauma with signs of life within 15 min. A เป็น bridge แต่ไม่ definitive. C ผิด — beta-blocker จะทำให้ cardiac output ลด. D ผิด — ห้ามรอ CT. E ผิดอย่างยิ่ง.', NULL,
  'medium', 'trauma', 'review',
  'surgery', 'clinical_decision', 'trauma', 'adult',
  'ATLS 10th Ed; EAST Guidelines: Penetrating Cardiac Injuries 2019; WSES Cardiac Trauma Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 36 ปี รถยนต์ชนต้นไม้ความเร็วสูง คาดเข็มขัดนิรภัย air bag ทำงาน

V/S: BP 78/40, HR 138, RR 26, SpO2 96%
Gen: pale, diaphoretic, JVP elevated, muffled heart sounds, Beck''s triad positive
Chest: clear breath sounds bilaterally
Abdomen: soft

FAST exam: pericardial effusion มาก, RV collapse in diastole'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 45 ปี ตกจากที่สูง 4 เมตร ปวดเชิงกรานรุนแรง

V/S: BP 84/52, HR 130, RR 24, GCS 15
Pelvis: instability on compression, hematoma scrotum +, blood at urethral meatus
FAST: negative free fluid abdomen
CXR: clear
Pelvic X-ray: open-book pelvic fracture with > 2.5 cm pubic diastasis

คำถาม: ขั้นตอนต่อไป', '[{"label":"A","text":"Foley catheterization immediately"},{"label":"B","text":"Unstable open-book pelvic fracture with hemorrhagic shock + urethral injury"},{"label":"C","text":"Definitive ORIF pelvis immediately"},{"label":"D","text":"Observation + serial Hb"},{"label":"E","text":"MRI pelvis"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Unstable open-book pelvic fracture with hemorrhagic shock + urethral injury**: (1) **Pelvic binder** (or circumferential sheet) at level greater trochanters — first-line mechanical stabilization to reduce volume + tamponade; (2) **Resuscitation**: 2 large-bore IV + massive transfusion protocol 1:1:1; (3) **Source of bleeding**: pelvic fracture (FAST negative — abdominal source unlikely); arterial bleed → **angioembolization** (preferred if available); venous/bony bleed → **preperitoneal pelvic packing** + external fixation; (4) **REBOA Zone 3** in extremis as bridge to definitive control; (5) **Suspect urethral injury** (blood at meatus, high-riding prostate) → **retrograde urethrogram (RUG)** before any Foley attempt — DO NOT pass Foley until urethra confirmed intact; suprapubic catheter if needed; (6) Trauma + Ortho + Urology + IR multidisciplinary

---

Open-book pelvic fracture (APC type) — high mortality (20-40%) จาก venous plexus + arterial bleed + soft tissue. Pelvic binder ลด pelvic volume → tamponade + ลดเลือดออก. Source of major hemorrhage: 85% venous/bony, 15% arterial. Hemodynamically unstable + pelvic fracture without intra-abdominal source: arterial bleed suspected → angioembolization. If no IR: preperitoneal pelvic packing + external fixator (รวดเร็ว, control venous + bony). Sequence per WSES guidelines: binder → resuscitate → if FAST positive → laparotomy; if FAST negative + unstable → IR or packing. Urethral injury — blood at meatus / scrotal hematoma / high-riding prostate → RUG ก่อน Foley. A ผิด — Foley before RUG อาจทำให้ urethra injury แย่ลง. C ผิด — definitive surgery รอ stable. D ผิดอย่างยิ่ง. E ผิด — ไม่ใช่ทำเลย.', NULL,
  'hard', 'trauma', 'review',
  'surgery', 'clinical_decision', 'trauma', 'adult',
  'WSES Pelvic Trauma Guidelines 2017; EAST Guidelines: Pelvic Fracture; AAST Pelvic Fracture Grading', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 45 ปี ตกจากที่สูง 4 เมตร ปวดเชิงกรานรุนแรง

V/S: BP 84/52, HR 130, RR 24, GCS 15
Pelvis: instability on compression, hematoma scrotum +, blood at urethral meatus
FAST: negative free fluid abdomen
CXR: clear
Pelvic X-ray: open-book pelvic fracture with > 2.5 cm pubic diastasis

คำถาม: ขั้นตอนต่อไป'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 28 ปี ขับรถยนต์ชนกับรถกระบะ ใช้เข็มขัดนิรภัย ไม่มีอาการขณะรับรู้

V/S: BP 124/78, HR 88, RR 16, GCS 15, room air SpO2 99%
Abdomen: tender LUQ, no peritonitis, no bruising
FAST: small free fluid Morrison''s pouch
CT abdomen: splenic laceration grade III with active blush + free fluid moderate amount; no other injury

Hb 11.8 g/dL stable

คำถาม: management', '[{"label":"A","text":"Emergency splenectomy"},{"label":"B","text":"Splenic injury grade III + active blush + hemodynamically stable → angioembolization + non-operative management (NOM)"},{"label":"C","text":"Discharge home with outpatient follow-up"},{"label":"D","text":"Total body MRI"},{"label":"E","text":"Diagnostic laparoscopy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Splenic injury grade III + active blush + hemodynamically stable → angioembolization + non-operative management (NOM)**: (1) ICU admission + serial abdominal exam + serial Hb q4-6h × 24-48h; (2) **Splenic artery angioembolization (SAE)** for active blush (contrast extravasation) — proximal embolization for grade IV-V; distal/selective for focal pseudoaneurysm; improves NOM success rate (90% with SAE vs 60% without in grade III-IV); (3) NPO initially, bedrest 24-48h; (4) Vaccination prophylaxis NOT needed unless splenectomy; (5) Failure criteria → hemodynamic instability, ongoing transfusion > 2 units/24h, peritonitis → laparotomy + splenectomy/splenorrhaphy; (6) Activity restriction 6-8 weeks post-discharge

---

Blunt splenic injury — AAST grading I-V. NOM success rate decreases with grade: I-II ~95%, III ~80%, IV-V ~50-70%. SAE เพิ่ม NOM success rate ใน grade III-V + contrast blush. Indications สำหรับ angioembolization (WSES + EAST): contrast extravasation, pseudoaneurysm, AV fistula, grade IV-V even without blush in selected centers. Hemodynamically unstable + splenic injury = laparotomy. ผู้ป่วยรายนี้ stable + grade III + blush → ideal for SAE-NOM. Post-splenectomy vaccinations (S. pneumoniae, H. influenzae, N. meningitidis) ถ้าตัดม้าม. A ผิด — stable + NOM candidate. C ผิดอย่างยิ่ง. D ผิด — CT done. E ผิด — no indication.', NULL,
  'medium', 'trauma', 'review',
  'surgery', 'clinical_decision', 'trauma', 'adult',
  'WSES Splenic Trauma Guidelines 2017; EAST Practice Management Guidelines: Selective NOM Blunt Splenic Injury; Stassen NA et al. J Trauma 2012', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 28 ปี ขับรถยนต์ชนกับรถกระบะ ใช้เข็มขัดนิรภัย ไม่มีอาการขณะรับรู้

V/S: BP 124/78, HR 88, RR 16, GCS 15, room air SpO2 99%
Abdomen: tender LUQ, no peritonitis, no bruising
FAST: small free fluid Morrison''s pouch
CT abdomen: splenic laceration grade III with active blush + free fluid moderate amount; no other injury

Hb 11.8 g/dL stable

คำถาม: management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 62 ปี underlying COPD GOLD C มาด้วยอาการปวดท้องรุนแรงทันทีทันใด มา 3 ชั่วโมง ปวดทั้งท้อง ไม่ผ่ายลม ไม่ถ่าย

V/S: BP 102/68, HR 116, RR 24, Temp 38.4°C
Abdomen: rigid abdomen, generalized rebound tenderness, absent bowel sound

Upright CXR: free air under bilateral diaphragm
Lab: WBC 18,400, Lactate 3.6

คำถาม: management', '[{"label":"A","text":"Observation + IV antibiotic 24 hours"},{"label":"B","text":"Perforated viscus with generalized peritonitis — emergent exploratory laparotomy"},{"label":"C","text":"Endoscopy + clip closure"},{"label":"D","text":"Conservative non-operative management (Taylor approach) for all"},{"label":"E","text":"CT abdomen ก่อนแล้วค่อยตัดสินใจ"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Perforated viscus with generalized peritonitis — emergent exploratory laparotomy**: (1) **Pre-op resuscitation**: 2 large-bore IV, IV fluid 1-2 L crystalloid, type & cross, foley + NG decompression, IV broad-spectrum antibiotic (e.g., piperacillin-tazobactam OR ceftriaxone + metronidazole); (2) **Source identification**: PUD perforation most common (60-70%) — duodenal > gastric; ตำแหน่งอื่น: appendix, sigmoid (diverticulitis, cancer), small bowel; (3) **Operative repair**: PUD perforation < 2 cm → Graham omental patch + biopsy + H. pylori workup; large perforation → Billroth I/II or vagotomy/antrectomy (rarely needed now); ล้างช่องท้องด้วย NSS; place drain; (4) **Postop**: continue antibiotic 5-7 days, PPI long-term, H. pylori eradication, ICU monitoring; (5) Laparoscopic approach if surgeon experienced + stable

---

Free air under diaphragm + peritonitis = perforated viscus = emergent surgery. Causes: PUD (60-70%), appendiceal perforation, diverticulitis perforation, colon cancer perforation, traumatic, iatrogenic, ischemic. Mortality of perforated PUD: 5-15%, higher in elderly + delayed presentation. Graham omental patch — pedicled omentum on perforation + interrupted sutures. Boey score predicts mortality: shock, comorbidity, delayed presentation > 24h. Taylor non-operative approach (NG suction, antibiotics, PPI, NPO) considered ONLY in selected stable patients with sealed perforation on Gastrografin — rarely first-line. CT useful if diagnosis unclear แต่ patient ที่ peritonitis + free air ชัด ไม่ต้องรอ CT. A ผิด — peritonitis + free air ต้องผ่า. C ผิด — perforation > endoscopic. D ผิด — selected only. E controversial แต่ถ้า diagnosis ชัด ไม่จำเป็น.', NULL,
  'easy', 'gi', 'review',
  'surgery', 'clinical_decision', 'gi', 'adult',
  'WSES Guidelines for Perforated Peptic Ulcer 2020; ACS Surgery Principles; Søreide K et al. Lancet 2015', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 62 ปี underlying COPD GOLD C มาด้วยอาการปวดท้องรุนแรงทันทีทันใด มา 3 ชั่วโมง ปวดทั้งท้อง ไม่ผ่ายลม ไม่ถ่าย

V/S: BP 102/68, HR 116, RR 24, Temp 38.4°C
Abdomen: rigid abdomen, generalized rebound tenderness, absent bowel sound

Upright CXR: free air under bilateral diaphragm
Lab: WBC 18,400, Lactate 3.6

คำถาม: management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 72 ปี atrial fibrillation on warfarin (INR 2.4) มาด้วยปวดท้องรุนแรง 6 ชั่วโมง ปวดทั้งท้องไม่ระบุตำแหน่ง pain out of proportion to exam findings

V/S: BP 128/76, HR 116 irregular, RR 22, Temp 36.8°C
Abdomen: soft, mild tenderness diffuse, no peritonitis, bowel sound active

Lab: WBC 16,800, Lactate 4.8, BE -8, Cr 1.6, LDH 480
CT abdomen with IV contrast: SMA occlusion + bowel wall thickening + pneumatosis intestinalis at jejunum', '[{"label":"A","text":"Observation + IV antibiotic + bowel rest"},{"label":"B","text":"Acute mesenteric ischemia (AMI) — SMA embolism (likely cardioembolic from AF)"},{"label":"C","text":"Stat angiogram only without intervention"},{"label":"D","text":"Heparin infusion alone without revascularization"},{"label":"E","text":"Diagnostic peritoneal lavage"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Acute mesenteric ischemia (AMI) — SMA embolism (likely cardioembolic from AF)**: (1) **Immediate resuscitation** + IV broad-spectrum antibiotic (e.g., piperacillin-tazobactam — covers bowel translocation); (2) **Therapeutic anticoagulation** (heparin IV) once decision-made; (3) **Vascular intervention**: **endovascular thrombectomy/thrombolysis** (catheter-directed) if no peritonitis + viable bowel — first-line in modern era OR **open SMA embolectomy via laparotomy**; (4) **Exploratory laparotomy** if peritonitis, pneumatosis with full-thickness necrosis suspected — **assess bowel viability** → resect non-viable bowel + **second-look laparotomy 24-48h** if uncertain; (5) Avoid vasopressors that constrict splanchnic flow (norepi preferred ถ้าจำเป็น); (6) Mortality 60-80% — early diagnosis + revascularization critical

---

Acute Mesenteric Ischemia (AMI) — high mortality (60-80%) จาก delayed diagnosis. Etiology: 1) **Arterial embolism** 50% (AF, MI, valve dz — SMA most common embolic destination) 2) **Arterial thrombosis** 25% (atherosclerosis at SMA origin) 3) **Non-occlusive mesenteric ischemia (NOMI)** 20% (low flow, vasoconstriction — shock, vasopressors, dialysis) 4) **Mesenteric venous thrombosis** 5% (hypercoagulable). Classic: ''pain out of proportion to physical findings'' + AF/atherosclerosis. CT angiography is diagnostic gold standard. Pneumatosis intestinalis + portal venous gas = late sign with high mortality. Modern management trend: endovascular-first (thrombectomy ± stenting) for arterial occlusion without peritonitis. Open surgery if peritonitis OR endovascular failure. Damage control + second-look. A ผิด — observation = death. C ผิด — diagnostic only ไม่พอ. D ผิด — heparin alone ไม่พอ. E ผิดล้าสมัย.', NULL,
  'hard', 'vascular', 'review',
  'surgery', 'clinical_decision', 'vascular', 'adult',
  'WSES Guidelines for Acute Mesenteric Ischemia 2017; ESVS Mesenteric Arterial Disease 2017; Bala M et al. World J Emerg Surg', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 72 ปี atrial fibrillation on warfarin (INR 2.4) มาด้วยปวดท้องรุนแรง 6 ชั่วโมง ปวดทั้งท้องไม่ระบุตำแหน่ง pain out of proportion to exam findings

V/S: BP 128/76, HR 116 irregular, RR 22, Temp 36.8°C
Abdomen: soft, mild tenderness diffuse, no peritonitis, bowel sound active

Lab: WBC 16,800, Lactate 4.8, BE -8, Cr 1.6, LDH 480
CT abdomen with IV contrast: SMA occlusion + bowel wall thickening + pneumatosis intestinalis at jejunum'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 78 ปี มา ED ด้วยอาการปวดท้องน้อยซ้าย 3 วัน ไข้ ปวดเวลาถ่าย ถ่ายลำบาก

V/S: BP 132/82, HR 96, RR 18, Temp 38.6°C
Abdomen: tenderness LLQ + palpable mass + guarding localized, no generalized peritonitis

Lab: WBC 15,200, CRP 142
CT abdomen: sigmoid diverticulitis + pericolic abscess 4.5 cm, no free air, no generalized peritonitis (Hinchey II)', '[{"label":"A","text":"Emergency Hartmann''s procedure"},{"label":"B","text":"Hinchey II diverticulitis (pericolic abscess > 3-4 cm)"},{"label":"C","text":"Antibiotic alone without drainage"},{"label":"D","text":"Discharge home with oral antibiotics"},{"label":"E","text":"Diverting colostomy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Hinchey II diverticulitis (pericolic abscess > 3-4 cm)**: (1) **Percutaneous CT-guided drainage** of abscess (IR) + IV broad-spectrum antibiotics (ceftriaxone + metronidazole or piperacillin-tazobactam) × 10-14 days; (2) NPO → clear liquid → low residue as tolerated; (3) Repeat imaging if not improving in 48-72h; (4) **Interval consideration of elective resection 6-8 weeks** post-recovery — current evidence (DIABOLO + others) shows elective sigmoidectomy NOT mandatory after single uncomplicated episode; consider in patients with complicated diverticulitis (abscess, fistula, stricture), immunocompromised, recurrent attacks, persistent symptoms — individualized; (5) Colonoscopy 6-8 weeks post-attack to exclude malignancy (controversial in mild cases per Cochrane); (6) Lifestyle: high-fiber diet, hydration

---

Hinchey classification of complicated diverticulitis: I) pericolic abscess (< 4 cm), II) pelvic/distant abscess (> 4 cm), III) purulent peritonitis, IV) fecal peritonitis. Management: - **Uncomplicated (Hinchey 0-Ia)**: outpatient antibiotics OR observation alone in selected cases (DIABOLO trial — antibiotic non-inferior to observation in uncomplicated) - **Hinchey I (< 3-4 cm)**: IV antibiotic alone usually adequate - **Hinchey II (> 4 cm)**: percutaneous drainage + IV antibiotic - **Hinchey III**: laparoscopic lavage (controversial — Ladies/SCANDIV trials mixed) OR sigmoidectomy with primary anastomosis ± diverting loop ileostomy (modern preferred over Hartmann''s in selected) - **Hinchey IV (fecal peritonitis)**: emergent Hartmann''s OR primary anastomosis with diversion in selected stable patients Elective sigmoidectomy after recovery — individualized, not for all single episodes. A ผิด — emergency Hartmann''s สำหรับ Hinchey III-IV. C ผิด — abscess > 3-4 cm ต้อง drain. D ผิด — รุนแรงเกิน outpatient. E ผิด — ไม่มี indication.', NULL,
  'medium', 'gi', 'review',
  'surgery', 'clinical_decision', 'gi', 'adult',
  'WSES Guidelines for Acute Left Sided Colonic Diverticulitis 2020; ASCRS Clinical Practice Guidelines Diverticulitis; Daniels L et al. Br J Surg 2017 (DIABOLO)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 78 ปี มา ED ด้วยอาการปวดท้องน้อยซ้าย 3 วัน ไข้ ปวดเวลาถ่าย ถ่ายลำบาก

V/S: BP 132/82, HR 96, RR 18, Temp 38.6°C
Abdomen: tenderness LLQ + palpable mass + guarding localized, no generalized peritonitis

Lab: WBC 15,200, CRP 142
CT abdomen: sigmoid diverticulitis + pericolic abscess 4.5 cm, no free air, no generalized peritonitis (Hinchey II)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 58 ปี มาด้วยอาเจียน 5 ครั้ง 24 ชั่วโมง ท้องอืด ไม่ผ่ายลม ไม่ถ่าย previous appendectomy 10 ปีก่อน

V/S: BP 118/76, HR 102, RR 18, Temp 37.2°C
Abdomen: distended, high-pitched bowel sound, tender diffuse, no peritonitis, no hernia

Upright X-ray: multiple air-fluid levels + dilated small bowel loops + no free air
CT abdomen: small bowel obstruction with transition point at right lower quadrant + adhesion suspected; no closed loop, no pneumatosis, no fat stranding

คำถาม: initial management', '[{"label":"A","text":"Emergent exploratory laparotomy"},{"label":"B","text":"Adhesive small bowel obstruction (ASBO), uncomplicated → conservative management trial"},{"label":"C","text":"Discharge home with oral antibiotic"},{"label":"D","text":"Colonoscopy"},{"label":"E","text":"Sigmoid decompression tube"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Adhesive small bowel obstruction (ASBO), uncomplicated → conservative management trial**: (1) **NPO + NG decompression**; (2) **IV fluid + electrolyte correction** (K, Cl losses common); (3) **Serial abdominal exam** + serial labs (WBC, lactate); (4) **Water-soluble contrast challenge (Gastrografin)** — both diagnostic + therapeutic: contrast reaching colon within 24h = predictive of resolution + may itself promote passage (osmotic effect); 75% resolve with conservative trial; (5) **Surgery indicated** if: peritonitis, ischemia/strangulation suspected (fever, leukocytosis, lactate, CT signs — closed loop, pneumatosis, mesenteric edema), failure of conservative trial 48-72h, no transit on contrast study; (6) Surgical options: laparoscopic adhesiolysis (selected) vs open; address etiology; (7) **Prevention**: adhesion barrier (e.g., hyaluronic acid) at index surgery

---

Adhesive SBO — most common cause of SBO in adults (60-75%). Conservative management resolves 70-80% of uncomplicated ASBO. **Bologna Guidelines (WSES) + ASBO management**: 1. Initial: NPO, NG, IV fluid, electrolyte correction 2. Identify warning signs of strangulation: fever, tachycardia, focal tenderness, lactate, WBC, CT signs (closed loop, mesenteric edema, pneumatosis, free fluid, lack of bowel wall enhancement) 3. Gastrografin challenge: 100 mL via NG, follow-up X-ray at 24h — if contrast in colon, predicts resolution + may aid passage 4. Trial 48-72h max; longer trial increases ischemia risk 5. Surgical indication: failed conservative, suspected ischemia, complete obstruction without resolution, closed loop, virgin abdomen (high malignancy risk) Strangulation = surgical emergency. A ผิด — no strangulation signs. C ผิดอย่างยิ่ง. D ผิด — small bowel not colon. E ผิด — for volvulus.', NULL,
  'easy', 'gi', 'review',
  'surgery', 'clinical_decision', 'gi', 'adult',
  'WSES Bologna Guidelines for ASBO 2017; Maung AA et al. EAST PMG; Di Saverio S et al. World J Emerg Surg', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 58 ปี มาด้วยอาเจียน 5 ครั้ง 24 ชั่วโมง ท้องอืด ไม่ผ่ายลม ไม่ถ่าย previous appendectomy 10 ปีก่อน

V/S: BP 118/76, HR 102, RR 18, Temp 37.2°C
Abdomen: distended, high-pitched bowel sound, tender diffuse, no peritonitis, no hernia

Upright X-ray: multiple air-fluid levels + dilated small bowel loops + no free air
CT abdomen: small bowel obstruction with transition point at right lower quadrant + adhesion suspected; no closed loop, no pneumatosis, no fat stranding

คำถาม: initial management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 68 ปี ปวดท้องน้อยซ้าย ท้องอืดมาก 5 วัน ไม่ผ่ายลม no flatus

V/S: BP 142/86, HR 96, RR 20, Temp 37.0°C
Abdomen: massive distention, asymmetric, no peritonitis

Abdominal X-ray: ''coffee bean'' sign / ''omega loop'' centred to RUQ
CT abdomen: sigmoid volvulus with whirl sign + dilated loop without bowel wall ischemia signs', '[{"label":"A","text":"Emergency sigmoidectomy"},{"label":"B","text":"Sigmoid volvulus without ischemia → endoscopic detorsion first"},{"label":"C","text":"Observation + bowel rest only"},{"label":"D","text":"Barium enema"},{"label":"E","text":"Discharge with laxatives"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Sigmoid volvulus without ischemia → endoscopic detorsion first**: (1) **Flexible sigmoidoscopy / colonoscopy decompression + rectal tube placement** — successful in 70-90% of cases without ischemia; assess viability of mucosa during scope; (2) **NG decompression**, IV fluid, electrolyte correction; (3) **Sentinel sigmoidectomy during same admission** (within 2-7 days) after detorsion — recurrence rate ~50-90% if not resected; one-stage sigmoidectomy with primary anastomosis preferred; (4) **Emergent surgery** if: failed endoscopic detorsion, signs of ischemia/gangrene (peritonitis, mucosal necrosis on scope, fever, lactate), perforation → Hartmann''s procedure or sigmoidectomy with primary anastomosis ± diverting stoma; (5) Post-recovery: nutrition, mobility, bowel regimen

---

Sigmoid volvulus — common in elderly, institutionalized, chronic constipation, neurogenic. Coffee bean / omega sign on X-ray; whirl sign on CT. Management: 1. **No ischemia + stable**: endoscopic detorsion successful 70-90%; rectal tube placement post-detorsion 2. **Definitive**: sigmoidectomy ภายใน same admission — recurrence > 50% if not resected 3. **Ischemia / failed endoscopic / perforation**: emergent surgery — Hartmann''s (classic) OR sigmoidectomy + primary anastomosis ± diverting stoma per surgeon judgment + patient status Cecal volvulus (different): NOT amenable to endoscopic detorsion typically; emergent right hemicolectomy. A ผิด — รุนแรงเกินไป first-line, แต่ definitive needed. C ผิด — รอจะเกิด ischemia. D ผิด — เก่า + ไม่ therapeutic. E ผิดอย่างยิ่ง.', NULL,
  'medium', 'gi', 'review',
  'surgery', 'clinical_decision', 'gi', 'adult',
  'ASCRS Clinical Practice Guidelines Sigmoid Volvulus 2016; WSES Acute Colonic Obstruction Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 68 ปี ปวดท้องน้อยซ้าย ท้องอืดมาก 5 วัน ไม่ผ่ายลม no flatus

V/S: BP 142/86, HR 96, RR 20, Temp 37.0°C
Abdomen: massive distention, asymmetric, no peritonitis

Abdominal X-ray: ''coffee bean'' sign / ''omega loop'' centred to RUQ
CT abdomen: sigmoid volvulus with whirl sign + dilated loop without bowel wall ischemia signs'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 56 ปี underlying gallstones มา ED ด้วยปวด RUQ severe 12 ชั่วโมง ไข้สูง หนาวสั่น ตัวเหลืองตาเหลือง confusion mild

V/S: BP 92/58, HR 124, RR 22, Temp 39.4°C
Abdomen: tender RUQ, Murphy''s + , no peritonitis generalized

Lab: WBC 22,000, Total bili 6.8, Direct bili 5.2, ALP 480, GGT 320, AST 188, ALT 142, Cr 1.7
US: gallbladder distention + sludge + CBD dilatation 12 mm + intrahepatic duct dilatation
MRCP pending

คำถาม: most appropriate next step', '[{"label":"A","text":"Immediate cholecystectomy"},{"label":"B","text":"Acute cholangitis with Reynolds'' pentad — severe (Tokyo Grade III)"},{"label":"C","text":"Antibiotic alone × 7 days, no procedure"},{"label":"D","text":"Open CBD exploration immediately"},{"label":"E","text":"Endoscopic ultrasound only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Acute cholangitis with Reynolds'' pentad — severe (Tokyo Grade III)**: (1) **Resuscitation**: IV crystalloid bolus, vasopressors as needed for septic shock; (2) **IV broad-spectrum antibiotic** ASAP (within 1 hr of recognition) — piperacillin-tazobactam OR meropenem + cover ESBL/anaerobes given severity; (3) **Urgent biliary decompression within 24h** — **ERCP with sphincterotomy + stone extraction + biliary stent** (preferred — therapeutic); alternative if ERCP failed/unavailable: **PTC (percutaneous transhepatic cholangiogram + drain)** or open biliary decompression as last resort; (4) ICU monitoring; (5) **Cholecystectomy delayed** until cholangitis resolved (typically 4-6 weeks) — gallstone source; same admission cholecystectomy if mild-moderate cholangitis post-ERCP, delayed if severe

---

Acute cholangitis (ascending cholangitis) — biliary tract infection from obstruction (stones > stricture > malignancy). **Charcot''s triad**: fever + RUQ pain + jaundice (50-70% present) **Reynolds'' pentad**: + hypotension + altered mental status (severe/suppurative). Tokyo Guidelines 2018 grading: - **Grade I (mild)**: no organ dysfunction, responds to antibiotics, no urgent drainage needed - **Grade II (moderate)**: 2+ of (WBC > 12k or < 4k, fever > 39, age > 75, hyperbili > 5, hypoalbumin < 0.7x LL) - **Grade III (severe)**: organ dysfunction (CV, neuro, resp, renal, hepatic, hematologic) — **urgent drainage required** Treatment principles: 1. Antibiotics (within 1 hr): broad-spectrum covering gram-neg + anaerobes; piperacillin-tazobactam, meropenem in severe 2. Biliary decompression timing: - Grade I: elective or within 24-48h if not improving - Grade II: early (within 24-48h) - Grade III: urgent (within 24h) 3. ERCP preferred — therapeutic + diagnostic 4. Cholecystectomy delayed until cholangitis resolved A ผิด — cholecystectomy โดยไม่ decompress = mortality. C ผิด — drainage essential. D ผิด — open last resort. E ผิด — EUS diagnostic only.', NULL,
  'medium', 'gi', 'review',
  'surgery', 'clinical_decision', 'gi', 'adult',
  'Tokyo Guidelines 2018 (TG18) for Acute Cholangitis; WSES Guidelines Acute Calculous Cholecystitis 2020; Miura F et al. J Hepatobiliary Pancreat Sci 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 56 ปี underlying gallstones มา ED ด้วยปวด RUQ severe 12 ชั่วโมง ไข้สูง หนาวสั่น ตัวเหลืองตาเหลือง confusion mild

V/S: BP 92/58, HR 124, RR 22, Temp 39.4°C
Abdomen: tender RUQ, Murphy''s + , no peritonitis generalized

Lab: WBC 22,000, Total bili 6.8, Direct bili 5.2, ALP 480, GGT 320, AST 188, ALT 142, Cr 1.7
US: gallbladder distention + sludge + CBD dilatation 12 mm + intrahepatic duct dilatation
MRCP pending

คำถาม: most appropriate next step'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 48 ปี ดื่มแอลกอฮอล์หนัก ปวดท้องรุนแรงตรงกลางท้อง 24 ชั่วโมง ปวดร้าวไปหลัง คลื่นไส้อาเจียน

V/S: BP 96/64, HR 124, RR 28, Temp 38.4°C, SpO2 92% room air
Abdomen: tender epigastric, distended, decreased bowel sound

Lab: WBC 19,200, Lipase 3,200 (normal < 60), Glucose 220, Ca 7.6, BUN 32, Cr 1.8, LDH 480, AST 220, Hct 48
ABG: pH 7.30, PaO2 64, HCO3 18
CT abdomen with contrast (day 3): pancreatic necrosis 40% + peripancreatic fluid collection + no infection signs', '[{"label":"A","text":"Immediate necrosectomy day 1"},{"label":"B","text":"Severe acute pancreatitis (predicted by APACHE-II, BISAP, modified Marshall) with sterile necrosis — multidisciplinary critical care management"},{"label":"C","text":"Routine prophylactic antibiotic infusion 14 days"},{"label":"D","text":"TPN only, no enteral feeding"},{"label":"E","text":"ERCP for all severe pancreatitis"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Severe acute pancreatitis (predicted by APACHE-II, BISAP, modified Marshall) with sterile necrosis — multidisciplinary critical care management**: (1) **Aggressive but goal-directed IV fluid** (Ringer lactate, target UO 0.5 ml/kg/hr, MAP > 65, Hct 35-44; avoid over-resuscitation — increases organ failure); recent trend: moderate fluid resuscitation per WATERFALL trial 2022 (aggressive worsens outcomes); (2) **ICU admission** for organ support — ventilator, vasopressor, CRRT as needed; (3) **Enteral nutrition early** (NG/NJ within 24-72h) — better than TPN (reduces infection, mortality); (4) **No prophylactic antibiotic** in sterile necrosis (no mortality benefit, increases fungal/resistant infections — current evidence); (5) **Pain control**, **PPI**, **DVT prophylaxis**; (6) **Treat underlying cause** — gallstone → urgent ERCP if cholangitis or persistent obstruction; alcohol → cessation + thiamine; (7) **Necrosis intervention indication**: infected necrosis suspected (clinical decline, gas in necrosis, positive FNA) — **delay 4 weeks** if possible for walled-off necrosis (WON), then **step-up approach** per PANTER trial: percutaneous drainage → endoscopic/MIS necrosectomy if not resolved → open necrosectomy last resort

---

Acute pancreatitis severity assessment: **Atlanta Classification 2012**: - Mild: no organ failure, no complications - Moderately severe: transient organ failure < 48h OR local/systemic complications - Severe: persistent organ failure > 48h **Scoring**: Ranson, APACHE-II, BISAP (5 variables, simple), Marshall (modified) Etiology: GET SMASHED — Gallstones (40%), Ethanol (30%), Trauma, Steroids, Mumps, Autoimmune, Scorpion, Hypertriglyceridemia/Hypercalcemia, ERCP, Drugs Key evidence-based management updates: 1. **Fluid resuscitation**: WATERFALL trial (NEJM 2022) — moderate (Ringer 1.5 mL/kg/h) BETTER than aggressive (3 mL/kg/h + bolus) re: organ failure, persistent SIRS 2. **Nutrition**: Early enteral (NJ ดีกว่า NG controversial — but both OK) > TPN — reduces infectious complications, organ failure 3. **Antibiotics**: NOT prophylactic in sterile necrosis. Use only for documented infection 4. **Necrosis intervention**: PANTER trial (NEJM 2010) — step-up approach (percutaneous drainage → minimally invasive necrosectomy) better than open. Delay until walled-off (4+ weeks) for elective 5. **ERCP** in pancreatitis: indicated for gallstone pancreatitis + cholangitis OR persistent obstruction; NOT for all severe A ผิด — delay 4 weeks for WON. C ผิด — no prophylactic abx. D ผิด — enteral preferred. E ผิด — selected only.', NULL,
  'hard', 'gi', 'review',
  'surgery', 'clinical_decision', 'gi', 'adult',
  'Atlanta Classification 2012; IAP/APA Acute Pancreatitis Guidelines; WSES Severe Acute Pancreatitis 2019; van Santvoort HC et al. NEJM 2010 (PANTER); de-Madaria E et al. NEJM 2022 (WATERFALL)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 48 ปี ดื่มแอลกอฮอล์หนัก ปวดท้องรุนแรงตรงกลางท้อง 24 ชั่วโมง ปวดร้าวไปหลัง คลื่นไส้อาเจียน

V/S: BP 96/64, HR 124, RR 28, Temp 38.4°C, SpO2 92% room air
Abdomen: tender epigastric, distended, decreased bowel sound

Lab: WBC 19,200, Lipase 3,200 (normal < 60), Glucose 220, Ca 7.6, BUN 32, Cr 1.8, LDH 480, AST 220, Hct 48
ABG: pH 7.30, PaO2 64, HCO3 18
CT abdomen with contrast (day 3): pancreatic necrosis 40% + peripancreatic fluid collection + no infection signs'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 60 ปี ติด HBV chronic 30 ปี cirrhosis Child-Pugh A เคยตรวจ AFP > 400 ng/mL

CT 4-phase liver: 4.5 cm enhancing mass at segment VI with arterial hyperenhancement + washout in portal venous + delayed phases (LI-RADS 5)

No extrahepatic disease, no portal vein thrombosis
Bilirubin 1.0, INR 1.1, Albumin 3.8, no ascites, no encephalopathy
MELD 7

คำถาม: management', '[{"label":"A","text":"Sorafenib alone"},{"label":"B","text":"HCC stage Barcelona Clinic Liver Cancer (BCLC) A — single nodule, preserved liver function, no portal HTN"},{"label":"C","text":"TACE only"},{"label":"D","text":"Observation"},{"label":"E","text":"Whipple procedure"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **HCC stage Barcelona Clinic Liver Cancer (BCLC) A — single nodule, preserved liver function, no portal HTN**: best candidate for **curative therapy**: (1) **Surgical resection** = first-line if: no significant portal HTN (HVPG < 10), preserved function (Child A), feasible anatomical resection with adequate remnant; this patient meets criteria — segmentectomy/lobectomy of segment VI; (2) **Alternatives**: - **Liver transplantation** if within Milan criteria (1 lesion ≤ 5 cm OR 2-3 lesions each ≤ 3 cm, no extrahepatic, no vascular invasion) — particularly if Child B/C or significant portal HTN; - **Ablation (RFA/MWA)** for tumors ≤ 3 cm — comparable to resection in small HCC, less invasive; (3) **Adjuvant therapy**: no proven adjuvant therapy post-resection (atezolizumab + bevacizumab in adjuvant trial IMbrave050 ongoing); (4) **Surveillance**: AFP + imaging q3 mo × 2 yr then q6 mo; (5) **Treat underlying HBV** — antiviral (entecavir or tenofovir) lifelong

---

HCC management (BCLC staging — primary algorithm): - **BCLC 0 (very early)**: single ≤ 2 cm, Child A, PS 0 — resection or ablation - **BCLC A (early)**: single OR up to 3 nodules ≤ 3 cm, Child A-B, PS 0 — resection / transplant / ablation - **BCLC B (intermediate)**: multinodular, Child A-B, PS 0 — TACE - **BCLC C (advanced)**: portal vein invasion, extrahepatic spread, Child A-B, PS 1-2 — systemic therapy (atezolizumab + bevacizumab first-line per IMbrave150; alternatives: durvalumab + tremelimumab, lenvatinib, sorafenib) - **BCLC D (terminal)**: Child C, PS 3-4 — best supportive care **Milan criteria** (transplant): 1 lesion ≤ 5 cm OR 2-3 lesions each ≤ 3 cm + no vascular invasion + no extrahepatic — 5-yr survival 70-75% Patient: BCLC A (4.5 cm single, Child A, no portal HTN, no extrahepatic) — resection candidate; transplant alternative; ablation > 3 cm less optimal. A ผิด — sorafenib BCLC C. C ผิด — TACE BCLC B. D ผิดอย่างยิ่ง. E ผิด — HCC not pancreas.', NULL,
  'medium', 'hemato_onco', 'review',
  'surgery', 'clinical_decision', 'hemato_onco', 'adult',
  'AASLD HCC Practice Guidance 2023; EASL Clinical Practice Guidelines HCC 2018; BCLC Strategy 2022 Update (J Hepatol); Finn RS et al. NEJM 2020 (IMbrave150)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 60 ปี ติด HBV chronic 30 ปี cirrhosis Child-Pugh A เคยตรวจ AFP > 400 ng/mL

CT 4-phase liver: 4.5 cm enhancing mass at segment VI with arterial hyperenhancement + washout in portal venous + delayed phases (LI-RADS 5)

No extrahepatic disease, no portal vein thrombosis
Bilirubin 1.0, INR 1.1, Albumin 3.8, no ascites, no encephalopathy
MELD 7

คำถาม: management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 62 ปี มาด้วยอาการเลือดออกทางทวารหนัก 3 เดือน + น้ำหนักลด 5 กิโลกรัม + ท้องอืด ท้องผูกสลับท้องเสีย

Colonoscopy: circumferential mass at sigmoid 25 cm from anal verge, biopsy = moderately differentiated adenocarcinoma
CT chest/abdomen/pelvis: 4 cm sigmoid mass + perirectal stranding + 3 enlarged regional LNs + 2 liver lesions (1.8 cm and 1.2 cm) suspicious metastatic; no lung disease
CEA 12.4

Molecular: KRAS wild-type, NRAS wild-type, BRAF wild-type, MSI-stable', '[{"label":"A","text":"Palliative surgery alone, no chemotherapy"},{"label":"B","text":"Stage IV colorectal cancer with potentially resectable liver metastases (oligometastatic)"},{"label":"C","text":"Sigmoid resection only without addressing liver"},{"label":"D","text":"Chemotherapy alone, no surgery"},{"label":"E","text":"Radiation only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Stage IV colorectal cancer with potentially resectable liver metastases (oligometastatic)**: multidisciplinary tumor board: (1) **Restaging + assessment of resectability** — MRI liver, PET-CT to rule out other metastases, hepatobiliary surgery consultation; (2) **Genetic profiling** done — KRAS/NRAS/BRAF wild-type + MSS → candidate for anti-EGFR (cetuximab/panitumumab) **left-sided primary** with chemo (FOLFOX or FOLFIRI + anti-EGFR — preferred in left-sided RAS WT per CALGB/SWOG 80405); (3) **Approach options**: a) **Synchronous resection** (primary + liver met) if low-volume + technically feasible + good surgical team; b) **Staged**: primary first then liver (classic) OR **liver-first (reverse)** in selected — particularly large liver disease with at-risk primary; c) **Perioperative chemotherapy** (3 mo neoadjuvant + 3 mo adjuvant per EPOC trial) before resection if resectable but high risk; (4) **Locally advanced primary**: consider neoadjuvant chemo + adjuvant; (5) **Adjuvant chemo** for 6 mo total perioperative; (6) **Surveillance**: CEA + imaging q3-6 mo × 2 yr then q6 mo; (7) Genetic counseling (Lynch syndrome MSI testing done — stable)

---

Stage IV CRC with oligometastatic liver disease — 20-30% of stage IV potentially curable. Multidisciplinary critical. **Resectability of liver mets**: anatomical (preserve adequate remnant function, vascular margin) > number/size. Modern era: aggressive approach including major hepatectomy, two-stage hepatectomy, ALPPS, portal vein embolization. **Sidedness** matters: - Left-sided primary (splenic flexure-rectum): better prognosis; RAS WT → anti-EGFR effective - Right-sided primary (cecum-transverse): poorer; RAS WT → anti-VEGF (bevacizumab) preferred over EGFR **Sequencing options for resectable mCRC**: 1. Synchronous resection — selected (limited mets, experienced center) 2. Staged primary-first → adjuvant → liver — classic 3. Liver-first (reverse) — large/symptomatic mets, asymptomatic primary 4. Perioperative chemo (FOLFOX 3+3 months per EPOC) — high-risk **Adjuvant systemic therapy**: backbone FOLFOX or FOLFIRI; biologics by RAS/sidedness; total 6 months perioperative **Surveillance**: CEA, CT, colonoscopy A ผิด — palliative สำหรับ unresectable. C ผิด — ต้องดูแล liver mets ด้วย. D ผิด — primary obstruction. E ผิด — RT ไม่ใช่ first-line สำหรับ sigmoid.', NULL,
  'hard', 'hemato_onco', 'review',
  'surgery', 'clinical_decision', 'hemato_onco', 'adult',
  'NCCN Colon Cancer 2024; ESMO Metastatic CRC 2023; Venook AP et al. JAMA 2017 (CALGB/SWOG 80405); Nordlinger B et al. Lancet 2013 (EPOC)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 62 ปี มาด้วยอาการเลือดออกทางทวารหนัก 3 เดือน + น้ำหนักลด 5 กิโลกรัม + ท้องอืด ท้องผูกสลับท้องเสีย

Colonoscopy: circumferential mass at sigmoid 25 cm from anal verge, biopsy = moderately differentiated adenocarcinoma
CT chest/abdomen/pelvis: 4 cm sigmoid mass + perirectal stranding + 3 enlarged regional LNs + 2 liver lesions (1.8 cm and 1.2 cm) suspicious metastatic; no lung disease
CEA 12.4

Molecular: KRAS wild-type, NRAS wild-type, BRAF wild-type, MSI-stable'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 32 ปี G2P1 อายุครรภ์ 28 สัปดาห์ มา ED ด้วยอาการปวดท้องน้อยขวา 18 ชั่วโมง คลื่นไส้อาเจียน

V/S: BP 118/72, HR 98, RR 18, Temp 38.0°C
Abdomen: tenderness at right flank — appendix displaced superiorly + laterally per pregnancy; rebound mild
Fetal HR 142 bpm regular

Lab: WBC 16,800 (normal in pregnancy 6-16k), CRP 88, urinalysis normal
US abdomen: appendix not well visualized due to gravid uterus, mild free fluid RLQ

คำถาม: next step', '[{"label":"A","text":"CT abdomen with IV contrast"},{"label":"B","text":"Suspected acute appendicitis in pregnancy, US non-diagnostic → MRI abdomen without gadolinium"},{"label":"C","text":"Observation 24 hr without imaging"},{"label":"D","text":"Conservative antibiotic only, no surgery"},{"label":"E","text":"Cesarean delivery + appendectomy together"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Suspected acute appendicitis in pregnancy, US non-diagnostic → MRI abdomen without gadolinium** (no radiation, no contrast, sensitivity > 90% for appendicitis in pregnancy); if MRI confirms or strongly suggests appendicitis → **proceed to appendectomy** (laparoscopic preferred in 1st-2nd trimester; open feasible in 3rd trimester depending on surgeon preference + body habitus); (1) **Perioperative**: continuous fetal monitoring (≥ 24 wk), left lateral tilt to avoid IVC compression, OB consultation; (2) **Tocolysis** prophylactic NOT recommended; treat preterm contractions if occur; (3) **Antibiotic**: pregnancy-safe (cefoxitin, ampicillin-sulbactam, or cefazolin + metronidazole as per appendix status) prophylactic single dose, continue if perforation; (4) **Avoid CT** if alternative imaging (MRI) available — minimize fetal radiation; (5) Negative appendectomy rate higher in pregnancy (20-30%) but missed appendicitis = perforation = 35% fetal loss → low threshold to operate; (6) Postoperative VTE prophylaxis + fetal surveillance

---

Appendicitis in pregnancy — most common non-OB surgical emergency (1:1,500 pregnancies). Diagnosis challenging — appendix migrates upward + lateral as pregnancy advances. Classic Alvarado less reliable. WBC physiologically elevated. **Imaging in pregnancy**: 1. **Ultrasound** — first-line, but sensitivity drops as pregnancy advances (limited visualization 3rd trimester) 2. **MRI without gadolinium** — preferred next; sensitivity > 90%, specificity > 95%; safe in pregnancy (gadolinium AVOID — crosses placenta) 3. **CT** — reserved if MRI unavailable; fetal radiation < 5 mSv per CT abdomen pelvis is below teratogenic threshold but minimize **Surgical approach**: - Laparoscopic appendectomy safe in 1st-2nd trimester, feasible in 3rd (depends on uterus size) - Lower CO2 pressure (10-12 mmHg) - Left lateral tilt to avoid aortocaval compression - Trocar placement adjusted for gravid uterus **Risks**: - Negative appendectomy 20-30% (acceptable to avoid missed dx) - Perforation → 35% fetal loss; non-perforated 5% - Maternal mortality < 1% **Antibiotic**: pregnancy-safe; cefazolin, ampicillin-sulbactam, cefoxitin OK; tetracycline + fluoroquinolone avoid A ผิด — CT avoid if MRI available. C ผิด — high stakes ต้อง diagnose. D ผิด — controversial in pregnancy, surgical safer. E ผิด — ไม่มี indication delivery 28 wk.', NULL,
  'medium', 'obgyn', 'review',
  'surgery', 'clinical_decision', 'obgyn', 'adult',
  'SAGES Guidelines Laparoscopic Surgery in Pregnancy; ACOG Committee Opinion 723; ACR Appropriateness Criteria; Tolcher MC et al. Am J Obstet Gynecol 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 32 ปี G2P1 อายุครรภ์ 28 สัปดาห์ มา ED ด้วยอาการปวดท้องน้อยขวา 18 ชั่วโมง คลื่นไส้อาเจียน

V/S: BP 118/72, HR 98, RR 18, Temp 38.0°C
Abdomen: tenderness at right flank — appendix displaced superiorly + laterally per pregnancy; rebound mild
Fetal HR 142 bpm regular

Lab: WBC 16,800 (normal in pregnancy 6-16k), CRP 88, urinalysis normal
US abdomen: appendix not well visualized due to gravid uterus, mild free fluid RLQ

คำถาม: next step'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 55 ปี โดนน้ำร้อนลวก ทั้งหน้า + ขาทั้งสองข้าง + แขนซ้าย + ลำตัวด้านหน้า

V/S: BP 102/68, HR 116, RR 22, Temp 37.0°C, SpO2 96%
Gen: alert, voice hoarse, singed nasal hair, soot in oropharynx
Burn: partial + full thickness — face 9% + bilateral leg ant. 18% + left arm anterior 4.5% + anterior trunk 18% ≈ 49.5% TBSA
Weight 70 kg', '[{"label":"A","text":"Lactate Ringer 4 mL/kg/%TBSA × 24h start"},{"label":"B","text":"Severe burn 49.5% TBSA + suspected inhalational injury — comprehensive resuscitation"},{"label":"C","text":"Oral hydration + outpatient"},{"label":"D","text":"Surgery immediate full debridement day 1"},{"label":"E","text":"Steroid IV high dose for inhalational"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Severe burn 49.5% TBSA + suspected inhalational injury — comprehensive resuscitation**: (1) **Airway**: signs of inhalational injury (singed nasal hair, soot, hoarse voice, facial burn, closed-space fire) → **early intubation** before edema obstructs airway — do NOT wait; bronchoscopy to assess; carboxyhemoglobin level (CO poisoning) — 100% O2; HCN poisoning (close-space fire) → hydroxocobalamin; (2) **Fluid resuscitation Parkland formula**: 4 mL × 70 kg × 49.5% = **13,860 mL Lactated Ringer''s over 24h** — first half (6,930 mL) over 8h from BURN time (not arrival), second half over 16h; adjust to UO 0.5 mL/kg/hr (30-50 mL/hr adult); recent trend toward lower volume to avoid ''fluid creep'' — start 2 mL/kg/%TBSA in mod severity, 4 mL/kg/%TBSA in severe + inhalation; (3) **Tetanus prophylaxis**; (4) **Wound care**: cool burn wounds with room-temp NSS-soaked gauze (NOT ice), debride loose epidermis, topical silver sulfadiazine or silver dressings; **escharotomy** for circumferential full-thickness burns (limbs, chest) — vascular/respiratory compromise; (5) **Pain control**: IV opioids; (6) **Nutrition**: early enteral high-protein high-calorie (3000-4000 kcal/day); (7) **Transfer to burn center** if > 10% TBSA + inhalation OR > 20% TBSA OR major burn (face, hands, feet, genitalia, joints); (8) ICU monitoring

---

Major burn management — ABA criteria: > 10% TBSA full-thickness, > 20% TBSA total, special areas (face, hands, feet, perineum, joints), chemical, electrical, inhalational, comorbidities → burn center **TBSA calculation**: Rule of Nines (adult): head 9%, each arm 9%, each leg 18% (9 ant + 9 post), trunk anterior 18%, posterior 18%, perineum 1% — Lund-Browder more accurate (pediatric) **Burn depth**: - Superficial (1st°): epidermis, erythema, painful — heal 3-7 days, exclude from TBSA - Superficial partial (2nd°): dermis (papillary), blisters, painful — heal 7-21 days - Deep partial (2nd°): deep dermis, less pain, slow heal 3-6 wk → may need grafting - Full thickness (3rd°): all skin, painless, leathery — graft - 4th°: muscle/bone — extensive **Parkland formula**: 4 mL/kg/%TBSA Lactated Ringer''s first 24h from burn time; ½ in first 8h, ½ next 16h; target UO 0.5 mL/kg/hr (adult), 1 mL/kg/hr (peds). Modified Brooke (2 mL/kg/%TBSA) — lower volume option. **Inhalational injury**: 30-40% mortality if extensive burns; early intubation, FOB diagnosis, bronchodilator, suctioning. **Escharotomy**: circumferential burns chest (limit ventilation) or limbs (compartment syndrome). A partial — formula correct but inhalation/airway crucial. C ผิดอย่างยิ่ง. D ผิด — early total excision 5-7 days. E ผิด — steroid harmful in inhalation.', NULL,
  'medium', 'trauma', 'review',
  'surgery', 'clinical_decision', 'trauma', 'adult',
  'ABLS Provider Manual 2018; ISBI Practice Guidelines for Burn Care 2016; Parkland Formula (Baxter & Shires 1968); Pham TN et al. J Burn Care Res 2008', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 55 ปี โดนน้ำร้อนลวก ทั้งหน้า + ขาทั้งสองข้าง + แขนซ้าย + ลำตัวด้านหน้า

V/S: BP 102/68, HR 116, RR 22, Temp 37.0°C, SpO2 96%
Gen: alert, voice hoarse, singed nasal hair, soot in oropharynx
Burn: partial + full thickness — face 9% + bilateral leg ant. 18% + left arm anterior 4.5% + anterior trunk 18% ≈ 49.5% TBSA
Weight 70 kg'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 45 ปี รักษาที่บ้านจากแมลงสัตว์กัด ขาขวา 2 วัน ขาขวาบวมแดงร้อนมาก ไข้สูง

V/S: BP 78/48, HR 138, RR 28, Temp 39.8°C
Leg: erythema rapidly spreading + bullae hemorrhagic + crepitus on palpation + pain out of proportion + skin necrosis patches
Lab: WBC 24,000 with bands 18%, Cr 2.4, lactate 5.2, glucose 280, Na 128, CK 4800, LRINEC score = 9

คำถาม: management', '[{"label":"A","text":"Oral antibiotic + outpatient"},{"label":"B","text":"Necrotizing fasciitis — surgical emergency + septic shock"},{"label":"C","text":"Antibiotic only, no surgery"},{"label":"D","text":"Wait for culture results before debridement"},{"label":"E","text":"Topical antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Necrotizing fasciitis — surgical emergency + septic shock**: (1) **Immediate resuscitation** + IV fluid + vasopressor (norepinephrine first-line); ICU; (2) **Emergent surgical debridement** within HOURS of diagnosis (mortality increases ~9% per hour delay) — wide debridement of ALL non-viable tissue, may need amputation; second-look debridement 24-48h; goal aggressive debridement until viable bleeding tissue; (3) **Empiric broad-spectrum IV antibiotics** ASAP — coverage: gram-positive (incl MRSA: vancomycin/linezolid), gram-negative, anaerobes — **piperacillin-tazobactam + vancomycin + clindamycin** (clindamycin = toxin suppression key for Strep + Staph); de-escalate per culture; (4) **Gram stain + cultures** at debridement: Type I polymicrobial 70% (mixed aerobic/anaerobic incl Bacteroides, E. coli) Type II monomicrobial (GAS, S. aureus incl MRSA, V. vulnificus marine) Type III (Clostridium gas gangrene — Fournier''s gangrene perineum); (5) **Adjunctive**: IVIG (Type II Strep TSS — controversial benefit), hyperbaric oxygen (selected centers — Clostridial), no proven survival benefit but considered; (6) Wound VAC after debridement; reconstruction later; (7) Mortality 25-35%

---

Necrotizing soft tissue infection (NSTI) — life-threatening, surgical emergency. Mortality 25-40%. **Risk factors**: DM (most common), trauma, IVDU, immunocompromise, NSAID use (delays diagnosis), pre-existing skin lesion. **LRINEC score** (Laboratory Risk Indicator for NF): CRP > 150, WBC, Hb, Na < 135, Cr > 1.6, Glucose > 180; score ≥ 6 high suspicion, ≥ 8 high risk. Not perfectly sensitive — clinical suspicion paramount. **Clinical**: pain out of proportion (early sign), rapid spread, bullae, crepitus (gas), skin necrosis (late), sepsis. **Types**: I) Polymicrobial (DM, abdominal, perineum/Fournier''s) — 70% II) Monomicrobial — GAS, S. aureus, V. vulnificus (marine exposure) III) Clostridial myonecrosis (gas gangrene) — trauma, post-surgery **Treatment principles**: 1. EMERGENT wide surgical debridement (best predictor of survival) 2. Broad-spectrum antibiotics with anti-toxin (clindamycin) 3. ICU resuscitation, source control, repeat OR q24-48h 4. Late: reconstruction Imaging (CT, MRI) helpful but DO NOT delay surgery if clinical diagnosis. A C E ผิดอย่างยิ่ง — antibiotic alone = death. D ผิด — wait = death.', NULL,
  'easy', 'id', 'review',
  'surgery', 'clinical_decision', 'id', 'adult',
  'IDSA Skin and Soft Tissue Infection Guidelines 2014; Stevens DL et al. CID 2014; Wong CH et al. Crit Care Med 2004 (LRINEC); WSES Necrotizing Soft Tissue Infections 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 45 ปี รักษาที่บ้านจากแมลงสัตว์กัด ขาขวา 2 วัน ขาขวาบวมแดงร้อนมาก ไข้สูง

V/S: BP 78/48, HR 138, RR 28, Temp 39.8°C
Leg: erythema rapidly spreading + bullae hemorrhagic + crepitus on palpation + pain out of proportion + skin necrosis patches
Lab: WBC 24,000 with bands 18%, Cr 2.4, lactate 5.2, glucose 280, Na 128, CK 4800, LRINEC score = 9

คำถาม: management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 28 ปี G1P0 28 weeks GA appendicitis + appendectomy 5 วันก่อน admission กลับมาด้วยไข้ ปวดท้องน้อยขวา

V/S: BP 116/72, HR 102, RR 18, Temp 38.6°C
Abdomen: RLQ tender, no peritonitis
Fetal HR 140 reactive

Lab: WBC 17,200, CRP 198
US abdomen: fluid collection 5x4 cm at RLQ deep to wound site, suspected abscess', '[{"label":"A","text":"Re-exploration laparotomy"},{"label":"B","text":"Post-operative intra-abdominal abscess in pregnancy"},{"label":"C","text":"Oral antibiotic outpatient"},{"label":"D","text":"Observation alone"},{"label":"E","text":"Cesarean delivery preterm to access"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Post-operative intra-abdominal abscess in pregnancy**: (1) **CT-guided or US-guided percutaneous drainage** — preferred over re-exploration (less morbidity, preserve gestation); US-guided preferred in pregnancy to avoid radiation; (2) **IV broad-spectrum antibiotic** — pregnancy-safe (e.g., piperacillin-tazobactam, ceftriaxone + metronidazole) × 10-14 days; (3) **Drain management** — culture-directed antibiotic adjustment, output monitoring, drain in place until resolution; repeat imaging q4-7 days; (4) **Maternal-fetal monitoring** — fetal HR, contractions, infection markers, growth scan; OB co-management; (5) **Surgical re-exploration** if: failure of percutaneous drainage, hemodynamic instability, peritonitis, generalized sepsis, multi-loculated abscess inaccessible; (6) **Nutritional support** maternal; (7) Postpartum follow-up; consider underlying immune state

---

Post-operative intra-abdominal abscess — 4-10% after appendectomy (higher post perforation). Pregnancy considerations: avoid CT if possible, use US/MRI guidance. Percutaneous drainage success rate 80-90% for accessible unilocular abscess. Re-exploration reserved for failure or complications. Antibiotics in pregnancy: penicillins, cephalosporins, clindamycin, metronidazole all category B; avoid tetracyclines, fluoroquinolones (cartilage), sulfa (3rd trimester — kernicterus). Premature delivery NOT indicated for maternal infection unless severe sepsis + viable gestation + maternal life-threatening. A ผิด — invasive. C ผิด — IV. D ผิดอย่างยิ่ง. E ผิด — preterm at 28 wk significant fetal morbidity.', NULL,
  'medium', 'id', 'review',
  'surgery', 'clinical_decision', 'id', 'adult',
  'ACOG Committee Opinion; WSES Intra-abdominal Infection Guidelines 2017; Sartelli M et al. World J Emerg Surg', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 28 ปี G1P0 28 weeks GA appendicitis + appendectomy 5 วันก่อน admission กลับมาด้วยไข้ ปวดท้องน้อยขวา

V/S: BP 116/72, HR 102, RR 18, Temp 38.6°C
Abdomen: RLQ tender, no peritonitis
Fetal HR 140 reactive

Lab: WBC 17,200, CRP 198
US abdomen: fluid collection 5x4 cm at RLQ deep to wound site, suspected abscess'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 45 ปี post-op day 4 laparotomy for perforated peptic ulcer ตื่นมาบ่นปวดท้อง ไข้ขึ้น 39°C

V/S: BP 88/52, HR 128, RR 26, Temp 39.4°C
Abdomen: distended, tender diffuse, surgical wound serosanguinous discharge

Lab: WBC 22,400, lactate 4.2, Cr 1.8
CT abdomen: 3 fluid collections + free fluid moderate + suspected anastomotic leak

คำถาม: management', '[{"label":"A","text":"Observation + IV antibiotic only"},{"label":"B","text":"Postoperative anastomotic leak with intra-abdominal sepsis — surgical emergency"},{"label":"C","text":"Endoscopic clip closure first"},{"label":"D","text":"Discharge home for outpatient antibiotic"},{"label":"E","text":"Total parenteral nutrition only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Postoperative anastomotic leak with intra-abdominal sepsis — surgical emergency**: (1) **Resuscitation** + vasopressor + ICU; (2) **Broad-spectrum IV antibiotic** + antifungal (Candida if persistent leak/TPN) — piperacillin-tazobactam ± vancomycin ± fluconazole; (3) **Source control** — re-exploration laparotomy preferred over percutaneous in unstable / generalized peritonitis: identify + control leak (primary repair, diversion stoma, exteriorization, or end stoma), wash out, place drains, consider damage control with open abdomen + temporary closure (Bogota bag, vacuum-assisted) for severe contamination; (4) **Nutritional support** — TPN initially, transition enteral when feasible (NJ tube past leak); (5) **Drain management** + serial imaging; (6) **Reconstruction** delayed 3-6 months after recovery + nutritional optimization; (7) **Treat ongoing risk factors**: control DM, optimize nutrition, smoking cessation

---

Anastomotic leak — major cause of post-op morbidity + mortality after GI surgery (mortality 5-20%, higher with sepsis). Risk factors: tension at anastomosis, poor blood supply, contamination, malnutrition, smoking, steroids, DM, emergency surgery, hemodynamic instability. **Diagnosis**: high index of suspicion in post-op day 3-7 patient with sepsis, tachycardia, ileus, wound drainage. CT with oral + IV contrast — extravasation, free fluid, fluid collections, free air. **Management principles** (controlled vs uncontrolled): - **Controlled leak**: contained collection, stable patient, adequate drainage — percutaneous drain + IV antibiotic + NPO + bowel rest - **Uncontrolled leak**: generalized peritonitis, sepsis, hemodynamic instability — emergent re-operation **Surgical options**: - Primary repair (small early leak, healthy tissue) - Diverting loop ileostomy/colostomy + drain - Resection + end stoma (Hartmann''s-type) - Damage control if unstable: control + temporary closure + return Endoscopic options: clips (small), stents (selected esophagogastric), endoscopic vacuum (selected anastomotic). A ผิด — sepsis ต้อง source control. C ผิด — clip ไม่พอ severe. D ผิดอย่างยิ่ง. E ผิด — TPN ไม่ใช่ definitive.', NULL,
  'hard', 'gi', 'review',
  'surgery', 'clinical_decision', 'gi', 'adult',
  'ESCP Anastomotic Leak Consensus 2020; WSES Surgical Sepsis Guidelines; Hyman N et al. Dis Colon Rectum', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 45 ปี post-op day 4 laparotomy for perforated peptic ulcer ตื่นมาบ่นปวดท้อง ไข้ขึ้น 39°C

V/S: BP 88/52, HR 128, RR 26, Temp 39.4°C
Abdomen: distended, tender diffuse, surgical wound serosanguinous discharge

Lab: WBC 22,400, lactate 4.2, Cr 1.8
CT abdomen: 3 fluid collections + free fluid moderate + suspected anastomotic leak

คำถาม: management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 35 ปี มาด้วยอาการคลำได้ก้อนนมข้างขวา quadrant 3 cm ขนาด 4 ซม. นาน 6 เดือน ไม่เจ็บ ไม่มี nipple discharge

Mammogram: BI-RADS 4C (suspicious — 5-95% probability)
US: solid mass 4 cm, hypoechoic, irregular margin
Core biopsy: invasive lobular carcinoma, grade 2, ER 99%+, PR 80%+, HER2 0, Ki-67 12%
Axillary US: 1 enlarged node 1.5 cm cortical thickening — FNAC positive metastatic carcinoma

Staging CT: no distant metastasis
Clinical T2 (4cm) N1 M0', '[{"label":"A","text":"Lumpectomy alone, no axillary surgery"},{"label":"B","text":"Stage IIB invasive lobular carcinoma, cN1 — multimodal management"},{"label":"C","text":"Tamoxifen alone, no surgery"},{"label":"D","text":"Observation only"},{"label":"E","text":"Mastectomy alone, no systemic therapy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Stage IIB invasive lobular carcinoma, cN1 — multimodal management**: (1) **Neoadjuvant approach considered**: ILC less chemosensitive than IDC + HR-strong + Ki-67 low → **neoadjuvant endocrine therapy (aromatase inhibitor for postmenopausal, ovarian suppression + AI or tamoxifen premenopausal)** — alternative to neoadjuvant chemo in luminal A-like; (2) **Surgical**: - **Mastectomy** often preferred for ILC (multifocal, infiltrative pattern, MRI more accurate for extent) — or BCS if margins achievable + acceptable cosmesis - **Axillary management**: with biopsy-confirmed nodal disease (cN1) → **axillary lymph node dissection (ALND)** standard (post-neoadjuvant may convert to SLNB with dual tracer + clip per ACOSOG Z1071); (3) **Radiation**: post-mastectomy RT for T3/T4 OR ≥ 4 + nodes; consider in T2N1 high-risk; post-BCS WBRT mandatory + regional nodal irradiation; (4) **Adjuvant systemic**: - **Endocrine therapy 5-10 years** + abemaciclib if high-risk per monarchE (≥ 4 nodes OR 1-3 nodes + high-risk feature) - **Adjuvant chemo** controversial in low-Ki-67 ILC; Oncotype DX has caveats in ILC (lower utility); often endocrine alone if T2N1 luminal A; (5) **Genetic testing** — younger age + family history + lobular (CDH1 = E-cadherin germline → hereditary diffuse gastric ca + lobular breast); (6) Survivorship + surveillance + lifestyle

---

Invasive Lobular Carcinoma (ILC) — 10-15% of breast cancer. Characteristics: - E-cadherin loss (CDH1) — single-file infiltrative pattern - Often multifocal, multicentric, bilateral - Mammographic occult (infiltrative without mass) — MRI more accurate for extent - Usually HR-positive (95%), HER2 low/neg, lower Ki-67 → luminal A-like - Less chemosensitive than IDC; more endocrine-sensitive - Metastatic pattern: peritoneum, GI tract, ovary, leptomeninges (unusual sites) **Management nuances**: 1. MRI breast pre-op to assess extent (multifocal common) 2. Mastectomy more often than BCS due to extent + margin difficulty 3. SLNB acceptable for clinically node-negative; ALND if N1+ confirmed (or post-neoadjuvant per Z1071) 4. Neoadjuvant chemo less effective; consider neoadjuvant endocrine in HR-strong + postmenopausal 5. Adjuvant: long-term endocrine 5-10 years; abemaciclib (monarchE) for high-risk HR+/HER2- 6. Oncotype DX has lower utility in ILC than IDC (validation issues) 7. Genetic — CDH1 germline assoc with HDGC (hereditary diffuse gastric ca) — refer A ผิด — nodal disease ต้อง axillary surgery. C ผิด — surgery essential. D ผิดอย่างยิ่ง. E ผิด — adjuvant systemic ต้องมี.', NULL,
  'hard', 'hemato_onco', 'review',
  'surgery', 'clinical_decision', 'hemato_onco', 'adult',
  'NCCN Breast Cancer 2024; St Gallen 2023; ASCO Guidelines on Endocrine Therapy; Johnston SRD et al. JCO 2020 (monarchE)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 35 ปี มาด้วยอาการคลำได้ก้อนนมข้างขวา quadrant 3 cm ขนาด 4 ซม. นาน 6 เดือน ไม่เจ็บ ไม่มี nipple discharge

Mammogram: BI-RADS 4C (suspicious — 5-95% probability)
US: solid mass 4 cm, hypoechoic, irregular margin
Core biopsy: invasive lobular carcinoma, grade 2, ER 99%+, PR 80%+, HER2 0, Ki-67 12%
Axillary US: 1 enlarged node 1.5 cm cortical thickening — FNAC positive metastatic carcinoma

Staging CT: no distant metastasis
Clinical T2 (4cm) N1 M0'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 52 ปี underlying DM, HT มาด้วยอาการ painful neck mass 3 วัน หนาวสั่น ไข้สูง กลืนเจ็บ

V/S: BP 108/68, HR 116, RR 22, Temp 39.4°C
Neck: tender mass anterior to SCM left side 6 cm + erythema + tenderness + trismus + drooling
Oral: poor dentition, swelling lower jaw + floor of mouth tenderness, tongue elevated

Lab: WBC 22,400, CRP 240, glucose 380
CT neck with contrast: deep neck space infection involving submandibular + parapharyngeal + retropharyngeal spaces + airway narrowing 50%', '[{"label":"A","text":"Oral antibiotic + outpatient"},{"label":"B","text":"Ludwig''s angina + deep neck space infection — airway emergency"},{"label":"C","text":"Wait for airway compromise then intubate"},{"label":"D","text":"Antibiotic only without drainage"},{"label":"E","text":"Steroids high dose alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Ludwig''s angina + deep neck space infection — airway emergency**: (1) **Airway first**: anticipate difficult airway → **awake fiberoptic intubation** or **early surgical airway (tracheostomy)** in OR with surgical airway backup; avoid sedation that loses airway; (2) **ICU admission**; (3) **IV broad-spectrum antibiotic** ASAP — cover oral flora (strep + anaerobes incl Bacteroides) — **ampicillin-sulbactam OR clindamycin + ceftriaxone OR piperacillin-tazobactam**; add vancomycin if MRSA risk; (4) **Surgical drainage** of deep neck space infection — incision + drainage of involved spaces (submandibular, submental, parapharyngeal, retropharyngeal as needed) + dental extraction if odontogenic source; obtain cultures; (5) **DM control** — IV insulin, glucose monitoring; (6) **Monitor for complications**: descending mediastinitis (CT chest if suspected — high mortality), Lemierre''s syndrome (jugular thrombophlebitis), sepsis, airway compromise; (7) Dental/ENT consultation; (8) Postdischarge dental care

---

Ludwig''s angina — bilateral submandibular + sublingual + submental space cellulitis. Usually odontogenic (lower molars). Rapid spread + airway threat + descending mediastinitis risk. **Mortality**: 50%+ pre-antibiotic, 5-10% modern era. **Anatomy of deep neck spaces**: - Submandibular (Ludwig''s) - Parapharyngeal — communicates with retropharyngeal, mediastinum - Retropharyngeal — extends to mediastinum (danger space) - Prevertebral - Carotid sheath **Airway management** critical: - Early intubation BEFORE airway loss - Anticipate difficulty (trismus, floor mouth edema, tongue displacement) - Awake fiberoptic preferred - Surgical airway (tracheostomy or cricothyroidotomy) ready - Avoid blind intubation, paralytics if uncertain **Antibiotics**: cover oral flora — strep, anaerobes (Bacteroides, Prevotella, Fusobacterium); β-lactam/inhibitor + clindamycin standard. Vanco if MRSA suspected. **Surgical**: drain abscesses, address source (dental). **Complications**: - Descending necrotizing mediastinitis (50% mortality) — high CT chest if persistent fever, chest symptoms - Lemierre''s syndrome — Fusobacterium necrophorum jugular thrombophlebitis with septic emboli A ผิด — ผู้ป่วยรุนแรง. C ผิดอย่างยิ่ง — pre-emptive airway. D ผิด — ต้อง drain. E ผิด — steroid bukan first-line.', NULL,
  'hard', 'id', 'review',
  'surgery', 'clinical_decision', 'id', 'adult',
  'IDSA Skin/Soft Tissue Infection Guidelines; UpToDate Ludwig''s Angina; Vieira F et al. Otolaryngol Clin North Am', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 52 ปี underlying DM, HT มาด้วยอาการ painful neck mass 3 วัน หนาวสั่น ไข้สูง กลืนเจ็บ

V/S: BP 108/68, HR 116, RR 22, Temp 39.4°C
Neck: tender mass anterior to SCM left side 6 cm + erythema + tenderness + trismus + drooling
Oral: poor dentition, swelling lower jaw + floor of mouth tenderness, tongue elevated

Lab: WBC 22,400, CRP 240, glucose 380
CT neck with contrast: deep neck space infection involving submandibular + parapharyngeal + retropharyngeal spaces + airway narrowing 50%'
  );

commit;

