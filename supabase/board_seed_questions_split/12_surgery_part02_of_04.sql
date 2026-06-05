-- ===============================================================
-- หมอรู้ — Board seed: ศัลยศาสตร์ (surgery) — part 2/4 (50 MCQs)
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
  s.id, 'board', NULL, 'ชายไทยอายุ 22 ปี ดื่มเหล้าหนัก พบในที่เกิดเหตุไม่รู้สึกตัว มี alcohol smell ตกบันได

GCS = 6 (E1V2M3), pupils unequal — right 5mm fixed dilated, left 3mm reactive; ทั่วศีรษะมี laceration + scalp hematoma right side
V/S: BP 168/96, HR 56, RR 12 irregular (Cushing''s reflex)
No other obvious injury

CT brain: right acute subdural hematoma 12 mm + midline shift 8 mm + uncal herniation

คำถาม: management', '[{"label":"A","text":"Observation + serial neurological exam"},{"label":"B","text":"**Severe TBI + acute SDH with uncal herniation — neurosurgical emergency**: (1) **ABC + protect airway** — RSI intubation (cervical spine precaution) with neuroprotective induction (avoid hypotension + hypoxia which double mortality); (2) **Maintain CPP > 60-70 mmHg**, MAP > 80, avoid hypotension (SBP > 110 if no other contraindication per BTF 4th ed), avoid hypoxia (SpO2 > 94%); (3) **Temporary measures for raised ICP / herniation**: - **Head of bed 30°**, head midline (jugular drainage) - **Hyperventilation TARGET PaCO2 30-35** (briefly, for impending herniation — vasoconstriction reduces ICP; not prolonged → ischemia) - **Mannitol 1 g/kg IV OR hypertonic saline 3% bolus 250 mL** — osmotic ICP reduction - **Sedation + analgesia**; paralytic if needed for asynchrony; (4) **Emergent neurosurgical decompression** — craniotomy + SDH evacuation ± decompressive craniectomy; (5) **ICP monitoring** post-op (intraventricular catheter preferred — diagnostic + therapeutic CSF drainage); (6) **TXA** — CRASH-3 trial: IV TXA within 3h of mild-moderate TBI reduces head injury death; (7) **Avoid steroids** (CRASH-1 — increased mortality in TBI); (8) **Anti-seizure** prophylaxis 7 days (levetiracetam preferred); (9) **DVT prophylaxis** — mechanical until 24-72h post-stable head CT, then chemical; (10) ICU + multidisciplinary"},{"label":"C","text":"Steroid IV high dose"},{"label":"D","text":"Aggressive hyperventilation PaCO2 < 25 sustained"},{"label":"E","text":"Wait CT repeat tomorrow"}]'::jsonb,
  'B', 'Severe TBI management — Brain Trauma Foundation (BTF) 4th edition + ATLS: **Primary brain injury** (initial trauma) + **secondary brain injury** (hypotension, hypoxia, ↑ICP, hypoglycemia, hyperthermia, seizures) — preventable secondary injury is target. **Severe TBI**: GCS ≤ 8 — intubate, ICP monitoring **Surgical SDH evacuation indications**: > 10 mm thickness OR midline shift > 5 mm OR GCS deteriorating OR pupillary abnormality OR ICP > 20 mmHg sustained **CPP** (Cerebral Perfusion Pressure = MAP - ICP): target 60-70 (BTF) — too high → ARDS risk; too low → ischemia **ICP** management tiered: 1. Head elevation, sedation, normothermia, normoglycemia 2. Osmotic therapy: mannitol 0.25-1 g/kg OR hypertonic saline 3. CSF drainage via EVD 4. Hyperventilation (rescue — brief) PaCO2 30-35; avoid PaCO2 < 30 (ischemia) 5. Decompressive craniectomy 6. Barbiturate coma (last resort) **CRASH-3** trial 2019: TXA within 3h of mild-moderate TBI reduces head injury-related death. **Glucose**: 140-180 target — avoid hyperglycemia + hypoglycemia. **Avoid**: prolonged severe hyperventilation, steroids, hypotension, hypoxia. A C E ผิดอย่างยิ่ง. D ผิด — brief PaCO2 30-35 OK, not < 25 sustained.', NULL,
  'hard', 'trauma', 'review',
  'surgery', 'clinical_decision', 'trauma', 'adult',
  'Brain Trauma Foundation Guidelines 4th Edition 2017; CRASH-3 Trial Lancet 2019; ATLS 10th Ed; SIBICC Algorithm', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 22 ปี ดื่มเหล้าหนัก พบในที่เกิดเหตุไม่รู้สึกตัว มี alcohol smell ตกบันได

GCS = 6 (E1V2M3), pupils unequal — right 5mm fixed dilated, left 3mm reactive; ทั่วศีรษะมี laceration + scalp hematoma right side
V/S: BP 168/96, HR 56, RR 12 irregular (Cushing''s reflex)
No other obvious injury

CT brain: right acute subdural hematoma 12 mm + midline shift 8 mm + uncal herniation

คำถาม: management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 25 ปี ไม่มีโรคประจำตัว มาด้วยอาการ neck mass บริเวณ thyroid โตขึ้น 6 เดือน ไม่มี hyperthyroid symptoms

Examination: 2 cm hard nodule right lobe + cervical lymphadenopathy ipsilateral
US thyroid: 2 cm hypoechoic solid nodule with microcalcifications + irregular margin + taller-than-wide + TIRADS 5
FNA: papillary thyroid carcinoma (PTC)

TFTs: euthyroid; calcitonin normal
Staging CT neck: no distant metastasis, several ipsilateral central + lateral compartment lymph nodes suspicious', '[{"label":"A","text":"Thyroid lobectomy alone, no node dissection"},{"label":"B","text":"**Papillary thyroid carcinoma cT2N1b (lateral nodal disease) — extensive surgery**: (1) **Total thyroidectomy** — indicated for tumors > 4 cm, gross extrathyroidal extension, clinically apparent nodal disease, distant metastases, prior head/neck radiation; this patient: nodal disease present → total thyroidectomy preferred over lobectomy; (2) **Central compartment lymph node dissection (level VI)** — therapeutic for clinically positive central nodes; prophylactic for select high-risk; (3) **Modified radical neck dissection (lateral compartment levels II-V)** — therapeutic for biopsy-proven lateral nodal disease (functional dissection preserving SCM, IJ, spinal accessory n. when possible); (4) **Postop**: serum thyroglobulin (Tg) + anti-Tg Ab — surveillance marker; calcium monitoring (hypoparathyroidism risk); recurrent laryngeal n. evaluation; (5) **Radioactive iodine (RAI I-131) ablation** — indicated for higher risk: > 4 cm, extrathyroidal extension, nodal disease (esp. > 5 nodes OR > 1 cm OR extranodal extension), distant metastases; dose 30-150 mCi; (6) **TSH suppression** with levothyroxine — target TSH < 0.1 in high-risk, 0.1-0.5 intermediate, 0.5-2 low-risk; (7) **Long-term surveillance**: serum Tg, neck US, possible whole-body scan; (8) Genetic counseling if family history"},{"label":"C","text":"Active surveillance only"},{"label":"D","text":"Chemotherapy first-line"},{"label":"E","text":"Radiation alone, no surgery"}]'::jsonb,
  'B', 'Papillary Thyroid Carcinoma (PTC) — most common (80-85% of thyroid Ca). Excellent prognosis overall (10-year survival > 95% in localized). **ATA Risk stratification** (2015 guidelines): - **Low risk**: intrathyroidal PTC ≤ 4 cm, no nodal/distant mets, no aggressive variant - **Intermediate**: gross extrathyroidal extension, vascular invasion, > 5 LN involved (small), aggressive histology - **High**: gross extrathyroidal invasion, incomplete resection, distant mets, large nodal disease **Surgical extent**: - **Lobectomy** for ≤ 4 cm, intrathyroidal, no nodes, low-risk — recent trend - **Total thyroidectomy** for: > 4 cm, gross ETE, distant mets, nodal disease, bilateral, prior H&N RT, contralateral nodule **Lymph node dissection**: - Therapeutic central (VI) for clinically involved central nodes - Therapeutic lateral (II-V) for biopsy-proven lateral nodes (modified radical) - Prophylactic central — controversial; consider T3/T4 **RAI ablation**: post-total thyroidectomy, intermediate-high risk — destroys residual + treats microscopic + mets **TSH suppression** with LT4 reduces recurrence in higher risk **Active surveillance** — selected microcarcinoma (≤ 1 cm) no node/ETE — not appropriate here (2 cm, N1b) A ผิด — N1 + 2cm ต้อง total + dissection. C ผิด — N1 disease ไม่ใช่ active surveillance candidate. D ผิด — chemo ไม่ใช่ first-line PTC. E ผิด — RAI not external RT.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'surgery', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'ATA Guidelines for Thyroid Nodules and Differentiated Thyroid Cancer 2015; NCCN Thyroid Carcinoma 2024; Haugen BR et al. Thyroid 2016', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 25 ปี ไม่มีโรคประจำตัว มาด้วยอาการ neck mass บริเวณ thyroid โตขึ้น 6 เดือน ไม่มี hyperthyroid symptoms

Examination: 2 cm hard nodule right lobe + cervical lymphadenopathy ipsilateral
US thyroid: 2 cm hypoechoic solid nodule with microcalcifications + irregular margin + taller-than-wide + TIRADS 5
FNA: papillary thyroid carcinoma (PTC)

TFTs: euthyroid; calcitonin normal
Staging CT neck: no distant metastasis, several ipsilateral central + lateral compartment lymph nodes suspicious'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 68 ปี smoker 60 pack-yr มาด้วยอาการปวดน่อง ขณะเดิน 100 เมตร 6 เดือน รุนแรงขึ้นเป็น 50 เมตร 2 สัปดาห์ ขาขวาเย็น ปวดเวลานอน

Examination: cool right foot, absent right popliteal + dorsalis pedis + posterior tibial pulses, capillary refill > 4 sec, ulcer 1 cm at heel non-healing
ABI: right 0.32 (severe), left 0.78 (mild-moderate)
Doppler: monophasic flow right SFA + popliteal
CT angiography: long-segment SFA occlusion right + multilevel atherosclerosis

คำถาม: management', '[{"label":"A","text":"Continue medical therapy only"},{"label":"B","text":"**Critical limb-threatening ischemia (CLTI, formerly CLI) — limb salvage approach**: (1) **Risk factor modification + medical optimization**: smoking cessation (most important), statin (high-intensity), antiplatelet (aspirin or clopidogrel; consider DOAC + aspirin per VOYAGER PAD — rivaroxaban 2.5 BID + ASA), BP control, glycemic control, supervised exercise (claudication only); (2) **Revascularization** indicated for CLTI — improves limb salvage + survival: - **Endovascular**: angioplasty ± stent (drug-eluting), atherectomy — preferred first in many; appropriate for short-segment, focal disease - **Open bypass**: femoropopliteal, fem-distal bypass with autologous vein (saphenous) — better long-term patency for long-segment disease; prosthetic if vein unavailable - **BEST-CLI trial (NEJM 2022)**: surgical bypass with adequate vein conduit superior to endovascular for major adverse limb events + need for re-intervention in CLTI; endovascular alternative if no good vein; (3) **Wound care + offloading** for foot ulcer; podiatry; (4) **Multidisciplinary** vascular surgery + IR + wound care + diabetes + podiatry; (5) **Amputation only if not revascularizable / non-salvageable limb**; (6) Lifelong surveillance + medical therapy"},{"label":"C","text":"Primary amputation"},{"label":"D","text":"Beta-blocker + observation"},{"label":"E","text":"Anticoagulation alone"}]'::jsonb,
  'B', '**Peripheral Artery Disease (PAD)** classification (Rutherford / Fontaine): - **Claudication (Rutherford 1-3 / Fontaine II)**: pain with exertion - **CLTI (Rutherford 4-6 / Fontaine III-IV)**: rest pain (4), ulceration (5), gangrene (6) — limb-threatening **Diagnosis**: ABI (0.9-1.4 normal; < 0.9 PAD; < 0.4 severe); TBI in non-compressible (DM, ESRD — vessel calcification); duplex; CT/MR angio; conventional angio. **ABI > 1.4** suggests non-compressible — get TBI/PVR. **CLTI Management** (ESVS + AHA 2022 + Global Vascular Guidelines): - Medical: smoking cessation, statin, antiplatelet, glycemic, BP - Revascularization always considered if limb salvageable - WIfI score (Wound, Ischemia, foot Infection) — stratify - **BEST-CLI (NEJM 2022)**: bypass with adequate vein > endovascular for MALE outcomes in CLTI with single-segment GSV - **BASIL-2 (Lancet 2023)**: endovascular non-inferior in some subgroups - **Antithrombotic** — VOYAGER PAD: rivaroxaban 2.5 BID + ASA reduces MALE post-revascularization; COMPASS regimen for stable PAD **Claudication only** (not CLTI): - First-line: supervised exercise + medical + risk factor - Revascularization if lifestyle-limiting after trial - Cilostazol — phosphodiesterase inhibitor for symptoms A ผิด — CLTI ต้อง revascularize. C ผิด — limb still salvageable. D E ผิด — ไม่พอ.', NULL,
  'medium', 'vascular', 'review',
  'surgery', 'clinical_decision', 'vascular', 'adult',
  'Global Vascular Guidelines on Management of CLTI (ESVS/SVS/WFVS 2019); AHA/ACC PAD 2016; Farber A et al. NEJM 2022 (BEST-CLI); Bonaca MP et al. NEJM 2020 (VOYAGER PAD)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 68 ปี smoker 60 pack-yr มาด้วยอาการปวดน่อง ขณะเดิน 100 เมตร 6 เดือน รุนแรงขึ้นเป็น 50 เมตร 2 สัปดาห์ ขาขวาเย็น ปวดเวลานอน

Examination: cool right foot, absent right popliteal + dorsalis pedis + posterior tibial pulses, capillary refill > 4 sec, ulcer 1 cm at heel non-healing
ABI: right 0.32 (severe), left 0.78 (mild-moderate)
Doppler: monophasic flow right SFA + popliteal
CT angiography: long-segment SFA occlusion right + multilevel atherosclerosis

คำถาม: management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายไทยอายุ 6 สัปดาห์ มาด้วยอาเจียนพุ่งเป็นน้ำนม 2 สัปดาห์ น้ำหนักลด ตาลึก ปัสสาวะน้อย

Exam: alert but lethargic, dehydrated, palpable olive-shaped mass RUQ, visible peristalsis epigastric
Weight 4.0 kg (10th percentile)

Lab: Na 128, K 2.8, Cl 84, HCO3 36, BUN 22, Cr 0.6, glucose 76
ABG: pH 7.52, PaCO2 48, HCO3 38 (hypochloremic hypokalemic metabolic alkalosis)
US: pyloric muscle thickness 5 mm, length 18 mm, target sign — diagnosis of pyloric stenosis', '[{"label":"A","text":"Emergency pyloromyotomy immediately"},{"label":"B","text":"**Hypertrophic pyloric stenosis — surgical disease but MEDICAL EMERGENCY of correcting metabolic alkalosis + dehydration FIRST**: (1) **NPO + NG decompression**; (2) **IV fluid resuscitation + electrolyte correction** — D5 ½NS with 20-40 mEq KCl/L after urine output established; goal: correct dehydration, normalize Cl > 100, HCO3 < 30, K > 3.5, urine output > 1 mL/kg/hr — usually takes 24-48 hr; (3) **Then surgery**: Ramstedt **pyloromyotomy** (open or laparoscopic) — split serosa + muscularis longitudinally without breaching mucosa; (4) **Postop feeding**: ad lib feeding within hours (recent evidence) OR scheduled advance; vomiting common 24-48h then resolves; (5) **Avoid emergency surgery before correction** — anesthesia in alkalotic patient → hypoventilation + respiratory acidosis + hypoxia + apnea; mortality risk; (6) **Outcome**: excellent — > 99% cure"},{"label":"C","text":"Oral rehydration + delay surgery 1 week"},{"label":"D","text":"Surgery without fluid correction"},{"label":"E","text":"Atropine medical therapy only"}]'::jsonb,
  'B', '**Hypertrophic Pyloric Stenosis (HPS)** — 2-12 weeks of age, more common in firstborn males. Etiology multifactorial — genetic + environmental (macrolides in infancy assoc), idiopathic muscle hypertrophy. **Classic presentation**: non-bilious projectile vomiting + visible peristalsis + palpable ''olive'' RUQ + dehydration + failure to thrive. **Lab signature**: hypochloremic hypokalemic metabolic alkalosis (loss of HCl from vomiting; renal compensation by H+ retention worsens alkalosis; paradoxical aciduria when severe). **Imaging**: US gold standard — muscle thickness ≥ 4 mm, length ≥ 16 mm, target/donut sign, elongated channel **Management critical principle**: PYLORIC STENOSIS IS NOT A SURGICAL EMERGENCY — IT IS A MEDICAL EMERGENCY OF FLUID + ELECTROLYTE CORRECTION FIRST. - Anesthesia + surgery in alkalotic patient = postop apnea (CNS depression from alkalosis + hypoventilation compensation) - Correct: Cl > 100, HCO3 < 30, K > 3.5, normal urine output - Usually 24-48 hours of IV resuscitation **Surgery**: Ramstedt pyloromyotomy — extramucosal splitting; laparoscopic = open in modern era for outcomes. Atropine medical therapy — historical, rarely used now. A ผิด — ห้ามผ่าตัดก่อน correct lab. C ผิด — IV ไม่ใช่ oral. D ผิดอย่างยิ่ง — anesthetic risk. E ผิด — surgery definitive.', NULL,
  'easy', 'pediatrics', 'review',
  'surgery', 'clinical_decision', 'pediatrics', 'peds',
  'APSA Pediatric Surgery Handbook; Pandya S et al. Pediatr Surg Int; Aspelund G, Langer JC. Semin Pediatr Surg', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'เด็กชายไทยอายุ 6 สัปดาห์ มาด้วยอาเจียนพุ่งเป็นน้ำนม 2 สัปดาห์ น้ำหนักลด ตาลึก ปัสสาวะน้อย

Exam: alert but lethargic, dehydrated, palpable olive-shaped mass RUQ, visible peristalsis epigastric
Weight 4.0 kg (10th percentile)

Lab: Na 128, K 2.8, Cl 84, HCO3 36, BUN 22, Cr 0.6, glucose 76
ABG: pH 7.52, PaCO2 48, HCO3 38 (hypochloremic hypokalemic metabolic alkalosis)
US: pyloric muscle thickness 5 mm, length 18 mm, target sign — diagnosis of pyloric stenosis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายไทยอายุ 9 เดือน มาด้วยอาการร้องไห้เป็นพักๆ ทุก 15-30 นาที + อาเจียน 6 ชั่วโมง + ถ่ายเป็นเลือดสีน้ำตาลแดง currant jelly stool 2 ครั้ง

Exam: lethargic between crying spells, palpable sausage-shaped mass RUQ, dance''s sign (empty RLQ)
VS: BP 80/50, HR 144, RR 30, Temp 37.6°C

US abdomen: target sign / pseudokidney sign at ileocolic region — intussusception confirmed; no signs of perforation', '[{"label":"A","text":"Emergency laparotomy"},{"label":"B","text":"**Ileocolic intussusception in pediatric patient — air enema reduction first-line if stable**: (1) **Resuscitation** + IV fluid + NG decompression + surgical consultation on standby; (2) **Air (pneumatic) enema reduction** under fluoroscopy — preferred over hydrostatic (barium/saline) due to better visualization, less mess if perforation, equally effective; success rate 80-90% (lower if symptoms > 24h, small bowel only); contraindications: peritonitis, perforation, hemodynamic instability; (3) **Hydrostatic enema** alternative (US-guided saline) — also effective, no radiation; (4) **Confirm reduction** — air through ileocecal valve into ileum + clinical improvement; observe 24h for recurrence (5-10%); (5) **Surgery** indicated for: failed enema reduction, peritonitis, perforation, pathological lead point (Meckel''s, polyp, lymphoma — older child > 5 yr suspect lead point), recurrence > 3 times → laparoscopic / open reduction + resection if non-viable / lead point; (6) **Postop care + follow-up**"},{"label":"C","text":"Observation 24 hr without intervention"},{"label":"D","text":"Oral contrast study only"},{"label":"E","text":"Discharge home with follow-up"}]'::jsonb,
  'B', '**Intussusception** — invagination of bowel into distal segment. Most common < 2 years, peak 5-9 months. Ileocolic most common. **Etiology**: idiopathic (peak age 3 mo - 3 yr) — viral-induced lymphoid hyperplasia (Peyer''s patches); rotavirus vaccine RotaShield withdrawn 1999. **Pathological lead point** more likely > 5 yr — Meckel''s, polyp, lymphoma, duplication, cyst. **Classic triad** (only 25%): crying spells + vomiting + currant jelly stool **Dance sign**: empty RLQ + sausage RUQ. **US** investigation of choice (target/donut, pseudokidney). **Reduction**: - **Air enema** preferred (pneumatic) — fluoroscopy-guided air insufflation; 80-90% success; perforation risk 0.4-2.5% - **Hydrostatic** (saline/water-soluble contrast under US, OR barium under fluoroscopy) — alternative - Contraindications: peritonitis, free air, hemodynamic instability, prolonged symptoms with signs of ischemia **Surgery indications**: failed non-operative reduction, peritonitis, perforation, lead point, recurrence (3+). **Recurrence** ~5-10% — usually within 24h. A ผิด — first-line non-operative. C ผิด — delay = ischemia. D ผิด — therapeutic enema. E ผิดอย่างยิ่ง.', NULL,
  'medium', 'pediatrics', 'review',
  'surgery', 'clinical_decision', 'pediatrics', 'peds',
  'APSA Pediatric Surgery Handbook; Applegate KE Pediatr Radiol; Marsicovetere P et al. Clin Colon Rectal Surg', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'เด็กชายไทยอายุ 9 เดือน มาด้วยอาการร้องไห้เป็นพักๆ ทุก 15-30 นาที + อาเจียน 6 ชั่วโมง + ถ่ายเป็นเลือดสีน้ำตาลแดง currant jelly stool 2 ครั้ง

Exam: lethargic between crying spells, palpable sausage-shaped mass RUQ, dance''s sign (empty RLQ)
VS: BP 80/50, HR 144, RR 30, Temp 37.6°C

US abdomen: target sign / pseudokidney sign at ileocolic region — intussusception confirmed; no signs of perforation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกแรกเกิดอายุ 1 วัน term, มาด้วยอาเจียน bilious + ท้องอืดเล็กน้อย ผ่าน meconium ปกติ 12 ชั่วโมงแรก

VS stable, abdomen non-distended, no peritonitis
Upper GI series: ''corkscrew'' appearance of duodenum + small bowel — concerning for malrotation with midgut volvulus', '[{"label":"A","text":"Observation + NG decompression only"},{"label":"B","text":"**Neonatal midgut volvulus with malrotation — SURGICAL EMERGENCY**: (1) **Immediate resuscitation**: NG decompression, IV fluid bolus, broad-spectrum antibiotic, type & crossmatch; (2) **EMERGENT laparotomy** (within hours) for **Ladd''s procedure**: (a) detorsion (counterclockwise) of volvulus, (b) division of Ladd''s bands (peritoneal bands compressing duodenum), (c) widening of mesenteric base, (d) appendectomy (because appendix ends up LUQ → future atypical presentation), (e) place small bowel right, colon left; (3) **Assess bowel viability** — non-viable bowel resection; massive necrosis → damage control + second look 24-48h; (4) **Postop**: ICU, NG, gradual enteral; (5) **Time-critical** — bowel ischemia within hours → short gut syndrome if extensive necrosis or death"},{"label":"C","text":"Outpatient referral pediatric surgery"},{"label":"D","text":"Contrast enema"},{"label":"E","text":"Endoscopic correction"}]'::jsonb,
  'B', '**Midgut volvulus with malrotation** — true surgical emergency in newborn. Embryologic basis: incomplete rotation of midgut (270° CCW) + fixation → narrow mesenteric base around SMA → volvulus risk. **Presentation**: bilious vomiting in newborn = malrotation with volvulus until proven otherwise → emergent workup. **Classic age**: 50% within 1 month, 75% within 1 year, can occur any age. **Diagnosis**: - **Upper GI series gold standard**: duodenojejunal junction (DJJ) right of midline / inferior to pylorus = malrotation; ''corkscrew'' duodenum + jejunum = volvulus - US — SMA/SMV relationship reversal supportive - X-ray: limited, may show double bubble; some atypical **Time = bowel**: every hour of volvulus → more ischemia → catastrophic short gut syndrome (massive resection → lifelong TPN) **Ladd''s procedure**: 1. Counterclockwise detorsion 2. Lyse Ladd''s bands 3. Widen mesentery 4. Appendectomy (anatomic relocation) 5. Place bowel in non-rotation position **Appendectomy** because cecum + appendix moved → atypical pain location later. A ผิดอย่างยิ่ง — emergency. C D E ผิด.', NULL,
  'easy', 'pediatrics', 'review',
  'surgery', 'clinical_decision', 'pediatrics', 'peds',
  'APSA Pediatric Surgery Handbook; Strouse PJ Pediatr Radiol; Adams SD, Stanton MP Surg Childhood', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ทารกแรกเกิดอายุ 1 วัน term, มาด้วยอาเจียน bilious + ท้องอืดเล็กน้อย ผ่าน meconium ปกติ 12 ชั่วโมงแรก

VS stable, abdomen non-distended, no peritonitis
Upper GI series: ''corkscrew'' appearance of duodenum + small bowel — concerning for malrotation with midgut volvulus'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 65 ปี ผ่า colorectal cancer (sigmoid) ผ่านไป 6 ชั่วโมง post-op ผู้ป่วยมา ICU vitals stable แต่สังเกตเห็น oliguria 0.2 mL/kg/hr × 4 ชั่วโมง

VS: BP 118/72, HR 96, RR 16, Temp 37.0°C
Lab: Hb 9.8 stable, Cr 1.6 (baseline 1.0), K 4.2, lactate 2.4
Fluid balance + 2 L positive intraop + 800 mL post-op
UO 80 mL last 4 hr
US Bladder: 60 mL urine in catheter functional

คำถาม: management of oliguria', '[{"label":"A","text":"Large fluid bolus 2L NSS"},{"label":"B","text":"**Post-operative oliguria — systematic evaluation + fluid challenge**: (1) **Differential**: pre-renal (hypovolemia, hypotension, anemia, low cardiac output), renal (ATN from hypotension, sepsis, contrast, drugs, transfusion), post-renal (bladder/ureter obstruction, kink, catheter); (2) **Assess volume status**: dynamic measures preferred — passive leg raise, pulse pressure variation, SVV (if ventilated), bedside US (IVC, lung B-lines), urine sodium / osmolality / FENa < 1% = pre-renal; (3) **Confirm Foley patency** — bladder scan done (catheter functional), rule out kink/blockage; (4) **Modest fluid challenge** 250-500 mL crystalloid + reassess UO/HD parameters — avoid large bolus that worsens edema (third spacing, prolonged ileus); (5) **Optimize**: correct anemia (transfuse if Hb < 7 standard, < 8 cardiac), maintain MAP > 65, treat pain, check medications (NSAIDs, nephrotoxic); (6) **Goal-directed therapy** ERAS-aligned — avoid liberal fluid (causes worse outcomes per ERAS evidence + Shin CH NEJM 2018); restrictive moderate strategy; (7) **Persistent oliguria** → nephrology consult, consider AKI workup, renal US, urine studies; (8) **Monitor Cr trend**"},{"label":"C","text":"Furosemide IV bolus 80 mg"},{"label":"D","text":"Renal replacement therapy immediately"},{"label":"E","text":"Stop all fluids"}]'::jsonb,
  'B', '**Postoperative oliguria** — UO < 0.5 mL/kg/hr × > 6h (KDIGO AKI Stage 1 criterion). Don''t reflex bolus. Modern ERAS + perioperative fluid management has shifted away from liberal fluids toward goal-directed + restrictive. **Differential**: 1. **Pre-renal**: hypovolemia (intraop loss, third space), low cardiac output, vasodilation (sepsis, anesthetic) 2. **Renal (intrinsic)**: ATN from prolonged hypotension/hypovolemia, drug-induced (NSAID, contrast, aminoglycoside), interstitial nephritis (antibiotics), rhabdomyolysis 3. **Post-renal**: catheter obstruction (kink, clot), bladder outlet, ureteral injury intraop (esp pelvic/colorectal — 0.5-1%) **Assessment**: - Check Foley patency, bladder scan - Vital signs trend - Fluid balance, weight - Lab: Cr, BUN/Cr ratio, electrolytes - Urine: Na, osmolality, FENa - Hemodynamics: dynamic measures preferred over CVP (CVP poorly predicts fluid responsiveness) - Bedside US: IVC, lung B-lines, cardiac function **Modern goal-directed**: small fluid challenges with reassessment, avoid over-resuscitation. **Avoid loop diuretics** for pre-renal oliguria — worsens AKI. Use only after volume optimized + persistent fluid overload. **Avoid contrast** for imaging if possible in AKI. A ผิด — large bolus harmful. C ผิด — loop in pre-renal harmful. D ผิด — RRT for refractory severe AKI. E ผิด — need maintenance.', NULL,
  'medium', 'renal_gu', 'review',
  'surgery', 'clinical_decision', 'renal_gu', 'adult',
  'KDIGO AKI Guidelines 2012; ERAS Society Guidelines for Colorectal Surgery; Shin CH et al. JAMA 2018; Myles PS et al. NEJM 2018 (RELIEF)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 65 ปี ผ่า colorectal cancer (sigmoid) ผ่านไป 6 ชั่วโมง post-op ผู้ป่วยมา ICU vitals stable แต่สังเกตเห็น oliguria 0.2 mL/kg/hr × 4 ชั่วโมง

VS: BP 118/72, HR 96, RR 16, Temp 37.0°C
Lab: Hb 9.8 stable, Cr 1.6 (baseline 1.0), K 4.2, lactate 2.4
Fluid balance + 2 L positive intraop + 800 mL post-op
UO 80 mL last 4 hr
US Bladder: 60 mL urine in catheter functional

คำถาม: management of oliguria'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 72 ปี post-op day 1 right hemicolectomy for cecal mass admit ICU มาขอ consultation ว่าผู้ป่วยมี atrial fibrillation new onset HR 140 BP 95/60

VS: BP 96/58, HR 142 irregular, RR 22, SpO2 94% room air, Temp 37.8°C
Gen: dyspneic
Lab: Hb 9.6, K 3.4, Mg 1.6, troponin negative, TSH normal

คำถาม: management', '[{"label":"A","text":"Electrical cardioversion immediately"},{"label":"B","text":"**Postoperative new-onset atrial fibrillation (POAF) with rapid ventricular response + borderline hemodynamics**: (1) **Identify + correct precipitants** — common: pain, hypoxia, electrolyte derangements (K, Mg), hypovolemia/overload, anemia, sepsis, MI, PE, withdrawal; replete K to 4-4.5, Mg to > 2; (2) **Rate vs rhythm control**: hemodynamically stable enough to attempt rate control first — **IV beta-blocker (metoprolol 5 mg q5 min × 3 doses)** OR **diltiazem 10-20 mg bolus then infusion** — caution in HFrEF (diltiazem CI); avoid amiodarone first in stable rate control (more pro-arrhythmic, hypotension); (3) **Hemodynamically unstable** (severe hypotension, ischemia, severe HF) → **synchronized DC cardioversion** 120-200 J biphasic + sedation; (4) **Rhythm control with amiodarone IV** consider if rate control inadequate or rhythm desired (150 mg load, then drip) — also good in critically ill; (5) **Anticoagulation**: CHA2DS2-VASc score in POAF — controversial; transient POAF may not warrant long-term AC but risk of stroke during episode + recurrence high; consult per guidelines + bleeding risk balance; postop bleeding risk weigh; (6) **Address underlying causes**, optimize hemodynamics; (7) Cardiology consult; (8) Outpatient follow-up — many POAF persistent or recurrent"},{"label":"C","text":"Digoxin alone for rate control"},{"label":"D","text":"Observation only"},{"label":"E","text":"Warfarin start immediately"}]'::jsonb,
  'B', '**Postoperative Atrial Fibrillation (POAF)** — incidence 10-30% post non-cardiac surgery, 30-50% post cardiac. Risk factors: age, HT, valvular disease, COPD, electrolyte disturbance, intraop volume shifts. **Management**: 1. **Identify precipitants**: pain, hypoxia, K/Mg deficiency, anemia, sepsis, fluid status, MI, PE 2. **Hemodynamic stability assessment**: - Stable: rate vs rhythm control - Unstable: synchronized cardioversion immediately 3. **Rate control**: - First-line: beta-blocker (metoprolol, esmolol) OR non-DHP CCB (diltiazem, verapamil) — caution in HFrEF - Digoxin: slow onset, less effective in stress states; adjunct only - Amiodarone: rhythm + rate; reasonable in critically ill, HF 4. **Rhythm control**: amiodarone IV; ibutilide; cardioversion 5. **Anticoagulation** in POAF: - CHA2DS2-VASc + HAS-BLED - Postop bleeding risk → individualized - Recent meta-analyses: POAF assoc with long-term AF recurrence + stroke risk — increasing recognition to anticoagulate persistent POAF beyond initial episode 6. **Long-term**: outpatient follow-up; many persist or recur **Special**: post-cardiac surgery — prophylactic beta-blocker, amiodarone proven to reduce POAF (PAPABEAR, others). A ผิด — stable enough for rate control trial. C ผิด — digoxin slow. D ผิด — RVR + hypotension. E ผิด — long-term decision later.', NULL,
  'medium', 'cardiovascular', 'review',
  'surgery', 'clinical_decision', 'cardiovascular', 'adult',
  'AHA/ACC/HRS Atrial Fibrillation Guidelines 2023; ESC Atrial Fibrillation 2020; Dobrev D et al. Nat Rev Cardiol 2019 (POAF)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 72 ปี post-op day 1 right hemicolectomy for cecal mass admit ICU มาขอ consultation ว่าผู้ป่วยมี atrial fibrillation new onset HR 140 BP 95/60

VS: BP 96/58, HR 142 irregular, RR 22, SpO2 94% room air, Temp 37.8°C
Gen: dyspneic
Lab: Hb 9.6, K 3.4, Mg 1.6, troponin negative, TSH normal

คำถาม: management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 40 ปี ทำงานก่อสร้าง post-op day 3 elective open inguinal hernia repair (mesh) มาด้วยอาการ shortness of breath ตื่นปวด chest, calf swelling left leg

VS: BP 124/82, HR 116, RR 24, SpO2 89% room air, Temp 37.4°C
Leg: left calf swollen 3 cm > right + tender + Homan''s positive
Chest: clear, mild tachypnea

Lab: Hb 13.8, D-dimer 4,200 (elevated)
CT pulmonary angiography: bilateral segmental PE; right ventricle:left ventricle ratio 0.9 (normal)
US Doppler legs: extensive DVT left femoropopliteal
Well''s score for PE high, Hestia low risk (no shock, no RV strain)', '[{"label":"A","text":"Observation + bed rest"},{"label":"B","text":"**Acute proximal DVT + segmental PE (low-risk by Hestia/sPESI, hemodynamically stable, normal RV function) → therapeutic anticoagulation**: (1) **Anticoagulation initiation** — choices: - **DOAC** (apixaban 10 mg BID × 7 days then 5 mg BID; OR rivaroxaban 15 mg BID × 21 days then 20 mg daily) — first-line per ACCP + CHEST; no overlap needed; - **LMWH** (enoxaparin 1 mg/kg q12h or 1.5 mg/kg daily) — for early use, particularly if uncertain bleeding risk, pregnancy, severe renal dz, cancer (LMWH historically preferred for cancer, now DOAC also acceptable per CLOT/Caravaggio); - **UFH IV** if hemodynamic concern, severe renal impairment, planned procedure; - Warfarin requires bridging with LMWH/UFH until INR 2-3 — rarely first choice now; (2) **Duration**: provoked (surgery-associated) → 3 months; unprovoked or persistent risk → consider extended; (3) **Postop bleeding risk** assessment — recent surgery 3 days = bleeding risk; balance vs PE/DVT mortality; usually proceed with anticoagulation with monitoring; (4) **Bleeding**: monitor wound, Hb, drains; consider IVC filter if true contraindication to anticoagulation (recent intracranial surgery, active bleeding) — retrievable filter; (5) **Outpatient management** acceptable for low-risk PE per HoT-PE / others — if reliable patient + outpatient anticoagulation feasible; (6) **No thrombolytics** for low-risk PE (only massive/hemodynamic instability or selected submassive with RV dysfunction)"},{"label":"C","text":"Surgical thrombectomy"},{"label":"D","text":"Systemic thrombolytics for all PE"},{"label":"E","text":"Aspirin only"}]'::jsonb,
  'B', '**VTE management** — anticoagulation cornerstone. **Risk stratification of PE** (PESI / sPESI / Hestia): - Low risk: stable, no RV dysfunction, no biomarker elevation, no comorbidities — outpatient OR short observation - Intermediate-low: RV dysfunction OR biomarker elevation alone - Intermediate-high: BOTH RV dysfunction AND biomarker elevation - High (massive) PE: shock/hypotension SBP < 90 → thrombolytics, embolectomy, ECMO **Anticoagulation choice**: - **DOAC** first-line for most (CHEST 2021): apixaban, rivaroxaban (initial loading); dabigatran, edoxaban (require initial parenteral) - **LMWH** — pregnancy, cancer (alternative to DOAC), severe renal dz - **UFH** — hemodynamic instability, procedure planned, severe renal - **VKA** — historical, mechanical valves, antiphospholipid syndrome (recent evidence) **Duration**: - Provoked (surgery, immobilization): 3 months - Unprovoked: 3 months minimum; consider extended (D-dimer, sex, residual thrombus) - Active cancer: indefinite while active - Recurrent unprovoked: indefinite **Thrombolytics**: only for high-risk (massive) PE OR selected intermediate-high with deterioration. **IVC filter**: only if true contraindication to anticoagulation; retrievable preferred; not for prophylaxis. **Postop VTE** — provoked but high recurrence risk if cancer-associated; weigh bleeding. A ผิด — ต้อง anticoagulate. C ผิด — selected only. D ผิด — low-risk PE no thrombolytics. E ผิด — aspirin ไม่พอ.', NULL,
  'medium', 'cardiovascular', 'review',
  'surgery', 'clinical_decision', 'cardiovascular', 'adult',
  'CHEST Guidelines on Antithrombotic Therapy 2021; ESC Pulmonary Embolism 2019; Kearon C et al. CHEST 2016; Stevens SM et al. CHEST 2021', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 40 ปี ทำงานก่อสร้าง post-op day 3 elective open inguinal hernia repair (mesh) มาด้วยอาการ shortness of breath ตื่นปวด chest, calf swelling left leg

VS: BP 124/82, HR 116, RR 24, SpO2 89% room air, Temp 37.4°C
Leg: left calf swollen 3 cm > right + tender + Homan''s positive
Chest: clear, mild tachypnea

Lab: Hb 13.8, D-dimer 4,200 (elevated)
CT pulmonary angiography: bilateral segmental PE; right ventricle:left ventricle ratio 0.9 (normal)
US Doppler legs: extensive DVT left femoropopliteal
Well''s score for PE high, Hestia low risk (no shock, no RV strain)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 42 ปี BMI 32 มาด้วยอาการปวด RUQ หลังกินอาหารมันๆ 6 ชั่วโมง ไม่มีไข้

VS: BP 124/78, HR 92, RR 16, Temp 37.0°C
Abdomen: tender RUQ, Murphy''s sign negative, no peritonitis
Lab: WBC 9,200, ALP normal, total bili 0.8, AST/ALT normal, lipase 38 (normal)
US abdomen: multiple gallstones in GB, GB wall 2 mm (normal), no pericholecystic fluid, CBD 5 mm', '[{"label":"A","text":"Emergency cholecystectomy"},{"label":"B","text":"**Symptomatic cholelithiasis without acute cholecystitis (biliary colic) → elective laparoscopic cholecystectomy**: (1) symptomatic gallstones — typical biliary colic episodes; (2) discuss timing — symptoms recurrent + risk of complications (cholecystitis, pancreatitis, cholangitis) → recommend elective laparoscopic cholecystectomy within weeks; (3) pre-op: low-fat diet, analgesia, anti-emetic; (4) laparoscopic preferred — gold standard, lower morbidity vs open; (5) intraoperative cholangiography selective vs routine — based on risk factors for CBD stones (LFTs, dilated CBD on US, history pancreatitis); (6) post-op: rapid recovery, return to normal diet"},{"label":"C","text":"Observation + reassurance lifelong"},{"label":"D","text":"Oral ursodeoxycholic acid lifelong only"},{"label":"E","text":"ERCP first"}]'::jsonb,
  'B', 'Asymptomatic gallstones — observation generally; intervention for selected (DM, transplant, sickle cell, porcelain GB, anticipated bariatric). Symptomatic gallstones (biliary colic without acute cholecystitis) — elective laparoscopic cholecystectomy due to ~20% risk of complications/year + recurrent attacks. UDCA medical dissolution — only small (< 5 mm) cholesterol stones in functioning GB with mild symptoms; high recurrence. Acute cholecystitis (Tokyo 2018): early laparoscopic cholecystectomy within 7 days preferred over delayed (CHOCOLATE, ACDC trials); percutaneous cholecystostomy if non-operative candidate.', NULL,
  'easy', 'gi', 'review',
  'surgery', 'clinical_decision', 'gi', 'adult',
  'Tokyo Guidelines 2018; WSES Acute Calculous Cholecystitis 2020; SAGES Guidelines for Gallbladder Disease', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 42 ปี BMI 32 มาด้วยอาการปวด RUQ หลังกินอาหารมันๆ 6 ชั่วโมง ไม่มีไข้

VS: BP 124/78, HR 92, RR 16, Temp 37.0°C
Abdomen: tender RUQ, Murphy''s sign negative, no peritonitis
Lab: WBC 9,200, ALP normal, total bili 0.8, AST/ALT normal, lipase 38 (normal)
US abdomen: multiple gallstones in GB, GB wall 2 mm (normal), no pericholecystic fluid, CBD 5 mm'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 60 ปี post-laparoscopic cholecystectomy day 1 มาด้วยอาการตัวเหลือง ปวด RUQ ไข้ขึ้น

VS: BP 118/76, HR 102, Temp 38.4°C
Lab: Total bili 3.8 (preop 0.6), Direct 2.9, ALP 380, AST 180, ALT 142
US: free fluid RUQ + dilated CBD 9 mm, no GB (s/p removal)
MRCP: leak from cystic duct stump + dilated intrahepatic ducts + retained CBD stone 8 mm', '[{"label":"A","text":"Observation"},{"label":"B","text":"**Post-cholecystectomy bile leak + retained CBD stone — multimodal management**: (1) **ERCP with sphincterotomy + stone extraction + biliary stent** — addresses both: relieves CBD obstruction, decompresses biliary tree, allows leak to seal (lower pressure system); (2) **Percutaneous drainage** of biloma if symptomatic localized collection; (3) **IV antibiotic** (covering biliary flora — ceftriaxone + metronidazole or piperacillin-tazobactam); (4) **Monitor LFTs**, repeat imaging; remove stent 4-8 wk later; (5) **Re-operation** if: large duct injury (Bismuth-Strasberg classification — E1-E5 hilar injuries need hepaticojejunostomy), failed ERCP/PTC drainage, peritonitis, severe sepsis; (6) **Strasberg classification of bile duct injuries**: A — cystic duct or aberrant duct leak, B/C — aberrant right duct, D — lateral injury of CBD, E1-E5 hilar injuries (more complex); (7) Tertiary HPB referral for major injuries"},{"label":"C","text":"Re-operation laparotomy immediately for all leaks"},{"label":"D","text":"Oral antibiotics + outpatient"},{"label":"E","text":"Liver transplantation"}]'::jsonb,
  'B', 'Bile duct injury post-laparoscopic cholecystectomy — 0.3-0.6% incidence. Cystic duct stump leak (Strasberg A) — most common; managed with ERCP + stent (relieves resistance), drain if collection. Major duct injury (Strasberg E1-E5) — need hepaticojejunostomy (Roux-en-Y) by HPB surgeon, ideally referred to tertiary center. Retained CBD stones — incidence 5-15%; ERCP + sphincterotomy gold standard. Strasberg-Bismuth classification systematizes injury type + guides management. Early recognition + appropriate management critical — delayed/missed injuries → biliary cirrhosis, recurrent cholangitis, death.', NULL,
  'hard', 'gi', 'review',
  'surgery', 'clinical_decision', 'gi', 'adult',
  'Strasberg SM et al. J Am Coll Surg 1995; Tokyo Guidelines 2018; SAGES Safe Cholecystectomy 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 60 ปี post-laparoscopic cholecystectomy day 1 มาด้วยอาการตัวเหลือง ปวด RUQ ไข้ขึ้น

VS: BP 118/76, HR 102, Temp 38.4°C
Lab: Total bili 3.8 (preop 0.6), Direct 2.9, ALP 380, AST 180, ALT 142
US: free fluid RUQ + dilated CBD 9 mm, no GB (s/p removal)
MRCP: leak from cystic duct stump + dilated intrahepatic ducts + retained CBD stone 8 mm'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 58 ปี ตัวเหลืองมา 3 สัปดาห์ + คันตามตัว + น้ำหนักลด 6 kg ใน 2 เดือน + ปวดท้องตื้อๆ + Courvoisier sign + (palpable non-tender GB)

VS stable
Lab: Total bili 16, Direct 13, ALP 680, GGT 540, CA 19-9 240
CT abdomen: 3 cm mass at pancreatic head + dilated CBD + dilated PD (double duct sign) + atrophic distal pancreas + no liver/peritoneal metastases + SMA + SMV: ≤ 180° contact = borderline resectable; CA + celiac artery free
FNA: pancreatic adenocarcinoma', '[{"label":"A","text":"Upfront Whipple immediately"},{"label":"B","text":"**Borderline resectable pancreatic adenocarcinoma — neoadjuvant + restaging approach**: (1) **Multidisciplinary tumor board** — pancreatic surgery + medical oncology + radiation + IR + GI; (2) **Biliary decompression** if jaundice severe + chemotherapy planned — endoscopic biliary stent (metal stent preferred per recent evidence, vs plastic — longer patency); avoid pre-op stenting in clearly resectable to prevent infection (PreVerstent trial considerations); (3) **Neoadjuvant chemotherapy** — modified FOLFIRINOX (preferred fit patients) OR gemcitabine + nab-paclitaxel × 3-6 months — improves R0 resection rate, treats micro-mets, identifies aggressive biology; (4) **Restaging** post-neoadjuvant — CT, CA 19-9 (response marker), PET if uncertain; (5) **Resection** if response/stable + remains technically resectable: pancreaticoduodenectomy (Whipple) — pylorus-preserving or classic + standard lymphadenectomy; vascular reconstruction (SMV/PV resection) as needed; (6) **Adjuvant chemo** completion (6 mo total perioperative); (7) **Adjuvant RT** considered selected R1 / positive margins; (8) **Surveillance** post-op: CA 19-9 + CT q3 mo × 2 yr; (9) **Genetic testing** considered (BRCA, Lynch — PALB2, ATM — actionable)"},{"label":"C","text":"Sorafenib"},{"label":"D","text":"Liver transplant"},{"label":"E","text":"Palliative care only"}]'::jsonb,
  'B', 'Pancreatic adenocarcinoma resectability (NCCN): - Resectable: no arterial contact, ≤ 180° venous contact without irregularity - Borderline resectable: SMA/CHA/celiac ≤ 180°, SMV/PV > 180° contact with reconstruction possible, short occlusion reconstructible - Locally advanced: SMA/celiac > 180°, unreconstructible venous, aortic involvement - Metastatic: distant disease Neoadjuvant FOLFIRINOX has shifted paradigm — better R0 rate, OS in borderline resectable (PRODIGE/SWOG, PREOPANC, A021501 trials). Adjuvant FOLFIRINOX × 6 mo standard for resected (PRODIGE 24). Median OS resected ~ 36 mo vs 12-16 mo non-resected with chemo. Courvoisier sign: palpable non-tender GB + jaundice → suggests malignant biliary obstruction (not gallstones, which scar GB).', NULL,
  'hard', 'hemato_onco', 'review',
  'surgery', 'clinical_decision', 'hemato_onco', 'adult',
  'NCCN Pancreatic Adenocarcinoma 2024; Conroy T et al. NEJM 2018 (PRODIGE 24); Versteijne E et al. JCO 2020 (PREOPANC); Janssen QP et al. Ann Surg 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 58 ปี ตัวเหลืองมา 3 สัปดาห์ + คันตามตัว + น้ำหนักลด 6 kg ใน 2 เดือน + ปวดท้องตื้อๆ + Courvoisier sign + (palpable non-tender GB)

VS stable
Lab: Total bili 16, Direct 13, ALP 680, GGT 540, CA 19-9 240
CT abdomen: 3 cm mass at pancreatic head + dilated CBD + dilated PD (double duct sign) + atrophic distal pancreas + no liver/peritoneal metastases + SMA + SMV: ≤ 180° contact = borderline resectable; CA + celiac artery free
FNA: pancreatic adenocarcinoma'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 65 ปี alcoholic chronic pancreatitis ปวดท้องเรื้อรัง 10 ปี + steatorrhea + DM type 3c + น้ำหนักลด

MRCP: dilated main pancreatic duct 9 mm with multiple stones + atrophic parenchyma; pseudocyst 4 cm; no malignancy
CA 19-9 normal

คำถาม: management', '[{"label":"A","text":"Continue medical therapy only"},{"label":"B","text":"**Chronic pancreatitis with dilated MPD, intraductal stones, intractable pain + complications**: (1) **Optimize medical first**: pain control multimodal (avoid chronic opioids if possible; gabapentinoids, TCA, multimodal), pancreatic enzyme replacement (PERT — 25,000-50,000 units lipase per meal), DM control (insulin), nutritional support, alcohol cessation absolute, smoking cessation, fat-soluble vitamins (ADEK); (2) **Endoscopic therapy** trial first for select: ERCP + sphincterotomy + stone extraction ± lithotripsy + PD stent — symptom relief 50-65% short-term; less invasive; (3) **Surgical drainage / resection** for: failed endoscopic, large MPD ≥ 6 mm + intractable pain, inflammatory mass head — options: - **Puestow procedure (lateral pancreaticojejunostomy Roux-en-Y)** — for diffusely dilated MPD; pain relief 70-80% - **Frey procedure** — core excision of pancreatic head + LPJ; for head-dominant disease - **Beger procedure** — duodenum-preserving pancreatic head resection; for inflammatory head mass - **Pancreaticoduodenectomy (Whipple)** — when suspect malignancy; (4) **Pseudocyst management**: > 6 cm, symptomatic, complications → endoscopic cyst gastrostomy / cystoduodenostomy OR surgical drainage; (5) **Surveillance for HCC and pancreatic cancer** elevated risk; (6) Multidisciplinary chronic pain management"},{"label":"C","text":"Total pancreatectomy + islet cell autotransplantation immediately"},{"label":"D","text":"Pancreatic resection for all chronic pancreatitis"},{"label":"E","text":"Opioid escalation only"}]'::jsonb,
  'B', 'Chronic pancreatitis surgical management — pain + complications when medical inadequate. ESCAPE trial (NEJM 2020) — early surgery (< 18 mo symptoms) > endoscopic-first approach for pain. Procedure selection by anatomy: - Dilated MPD (≥ 6 mm) diffuse → Puestow/LPJ - Head-dominant + dilated duct → Frey - Inflammatory head mass + suspect malignancy → Beger or Whipple - Small duct + diffuse → consider total pancreatectomy + islet auto-tx in select centers Cambridge classification of CP severity. Total pancreatectomy with islet cell autotransplantation — for refractory severe pain in select younger patients with diffuse disease. Pseudocyst drainage when symptomatic / > 6 cm / complications. PERT essential for exocrine insufficiency. Insulin for type 3c DM. Risk of pancreatic Ca increased 2-3x in CP — surveillance considered.', NULL,
  'medium', 'gi', 'review',
  'surgery', 'clinical_decision', 'gi', 'adult',
  'Issa Y et al. NEJM 2020 (ESCAPE); ACG Chronic Pancreatitis Guidelines 2020; ESGE Chronic Pancreatitis 2019', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 65 ปี alcoholic chronic pancreatitis ปวดท้องเรื้อรัง 10 ปี + steatorrhea + DM type 3c + น้ำหนักลด

MRCP: dilated main pancreatic duct 9 mm with multiple stones + atrophic parenchyma; pseudocyst 4 cm; no malignancy
CA 19-9 normal

คำถาม: management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 55 ปี HBV chronic + cirrhosis Child-Pugh B7 + portal HTN — Ascites moderate, prior variceal bleed banded; HCC 5 cm at segment IV + portal vein branch invasion + AFP 8,000

MELD 14; no extrahepatic disease; Child-Pugh B (bili 2.4, albumin 2.9, INR 1.5, ascites moderate, no encephalopathy)

คำถาม: management', '[{"label":"A","text":"Surgical resection"},{"label":"B","text":"**Advanced HCC (BCLC C — portal vein invasion) — systemic therapy first-line**: (1) **Atezolizumab + bevacizumab** — first-line per IMbrave150 (NEJM 2020): improved OS + PFS vs sorafenib; caveats — esophageal varices must be screened + treated (bevacizumab bleeding risk); Child-Pugh A optimal, B with caution; (2) **Durvalumab + tremelimumab (STRIDE)** — alternative first-line per HIMALAYA, avoids bevacizumab in varices; (3) **Lenvatinib** — alternative if immunotherapy contraindicated; (4) **Sorafenib** — historical first-line; (5) **Treat underlying HBV** — antiviral (entecavir, tenofovir) lifelong — slow cirrhosis progression + reduces HCC recurrence; (6) **Treat portal HTN complications**: beta-blocker (carvedilol preferred in compensated, caution decompensated), variceal surveillance + banding, ascites diuretic + sodium restriction; (7) **Liver transplant consideration**: outside Milan due to vascular invasion → typically excluded; downstaging protocols (TACE/Y90) may allow listing if response + size criteria met; (8) **TACE/Y90** for select macrovascular invasion but reduced efficacy; (9) **Surgical resection contraindicated** typically — portal vein invasion = BCLC C; (10) **Palliative care integration**"},{"label":"C","text":"TACE alone"},{"label":"D","text":"Liver transplant immediately"},{"label":"E","text":"Observation"}]'::jsonb,
  'B', 'BCLC C HCC (advanced) — portal vein invasion, lymph node, distant mets, ECOG 1-2. Standard first-line: - Atezolizumab + bevacizumab (IMbrave150) — preferred Child-Pugh A; OS 19.2 mo - Durvalumab + tremelimumab STRIDE (HIMALAYA) — alternative, no bev → safer with varices - Lenvatinib (REFLECT) — non-inferior to sorafenib - Sorafenib — historic Second-line: regorafenib, cabozantinib, ramucirumab (AFP > 400), nivolumab/pembrolizumab. Liver transplant criteria: Milan (1 ≤ 5 cm OR 2-3 ≤ 3 cm) — gold standard. Expanded (UCSF) sometimes used. Vascular invasion typically excluded. Downstaging with TACE/Y90 in selected protocols. HBV antiviral therapy reduces HCC recurrence post-treatment.', NULL,
  'hard', 'hemato_onco', 'review',
  'surgery', 'clinical_decision', 'hemato_onco', 'adult',
  'AASLD HCC Practice Guidance 2023; EASL 2018; Finn RS et al. NEJM 2020 (IMbrave150); Abou-Alfa GK et al. NEJM Evid 2022 (HIMALAYA)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 55 ปี HBV chronic + cirrhosis Child-Pugh B7 + portal HTN — Ascites moderate, prior variceal bleed banded; HCC 5 cm at segment IV + portal vein branch invasion + AFP 8,000

MELD 14; no extrahepatic disease; Child-Pugh B (bili 2.4, albumin 2.9, INR 1.5, ascites moderate, no encephalopathy)

คำถาม: management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 50 ปี smoker, dysphagia 3 เดือน รุนแรงขึ้น น้ำหนักลด 8 kg

EGD: ulcerative mass at mid-esophagus 32 cm from incisors, biopsy = squamous cell carcinoma
EUS: T3 invading muscularis propria, N1 (2 periesophageal nodes); no celiac nodes
CT chest/abd: no distant mets
PET: localized disease + 1 supraclavicular node SUV 4 (equivocal) — FNA negative

Clinical T3 N1 M0 — Stage III esophageal SCC', '[{"label":"A","text":"Surgery alone (esophagectomy)"},{"label":"B","text":"**Locally advanced esophageal SCC (cT3N1) — multimodal treatment**: (1) **Neoadjuvant chemoradiotherapy (CRT) then surgery** — CROSS regimen: carboplatin + paclitaxel + concurrent RT 41.4 Gy/23 fractions × 5 weeks; improves OS + R0 rate (van Hagen NEJM 2012); (2) **Restaging** 4-6 weeks post-CRT — CT, EUS, PET; (3) **Esophagectomy** — Ivor Lewis (right thoracotomy + abdominal) for distal/mid-esophageal; transhiatal or McKeown (3-field) for upper; minimally invasive (MIE) acceptable; (4) **Lymphadenectomy** — 2-field (mediastinal + abdominal) standard; 3-field (cervical) for upper esophageal SCC selected centers; (5) **Reconstruction** — gastric conduit standard; jejunum or colon if stomach unsuitable; (6) **Adjuvant** — nivolumab × 1 year post-resection if residual disease after neoadjuvant (CheckMate 577); (7) **Definitive CRT** alternative for cervical SCC OR non-surgical candidates; (8) **Surveillance** + nutritional optimization (J-tube during/post)"},{"label":"C","text":"Chemo alone"},{"label":"D","text":"Radiation alone"},{"label":"E","text":"Endoscopic mucosal resection"}]'::jsonb,
  'B', 'Esophageal cancer — SCC (upper-mid, alcohol/smoking risk) vs adenocarcinoma (distal, Barrett''s, GERD, obesity). Staging: EUS for T/N, CT chest/abd for distant, PET selectively. Trimodality (CRT + surgery) per CROSS for locally advanced (T2N+/T3-4 any N) — improves OS 5-yr 47% vs 33% surgery alone. CheckMate 577 — adjuvant nivolumab × 1 yr for incomplete pathologic response after neoadjuvant CRT — improves DFS. Definitive CRT (50-50.4 Gy + chemo) — cervical SCC, refusal/unfit for surgery. Esophagectomy approaches: - Ivor Lewis: distal/mid - McKeown 3-field: mid/upper - Transhiatal: avoid thoracotomy MIE associated with less morbidity (TIME trial).', NULL,
  'medium', 'hemato_onco', 'review',
  'surgery', 'clinical_decision', 'hemato_onco', 'adult',
  'NCCN Esophageal and EGJ 2024; van Hagen P et al. NEJM 2012 (CROSS); Kelly RJ et al. NEJM 2021 (CheckMate 577)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 50 ปี smoker, dysphagia 3 เดือน รุนแรงขึ้น น้ำหนักลด 8 kg

EGD: ulcerative mass at mid-esophagus 32 cm from incisors, biopsy = squamous cell carcinoma
EUS: T3 invading muscularis propria, N1 (2 periesophageal nodes); no celiac nodes
CT chest/abd: no distant mets
PET: localized disease + 1 supraclavicular node SUV 4 (equivocal) — FNA negative

Clinical T3 N1 M0 — Stage III esophageal SCC'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 70 ปี dysphagia + reflux 6 เดือน + iron deficiency anemia

EGD: large 8 cm paraesophageal hernia type III + organoaxial gastric volvulus + Cameron erosions in herniated stomach
CT: > 50% stomach in chest + obstruction signs at GEJ

Symptoms: dysphagia worsening + intermittent chest pain + early satiety + anemia

คำถาม: management', '[{"label":"A","text":"Observation + PPI"},{"label":"B","text":"**Symptomatic large paraesophageal hernia (type III) with gastric volvulus + complications (Cameron erosions, anemia, dysphagia) — surgical repair**: (1) **Laparoscopic paraesophageal hernia repair** (gold standard — Stylopoulos vs open): - Sac dissection + reduction of stomach into abdomen - Crural repair (primary suture; mesh reinforcement controversial — biological mesh selected, synthetic avoid for erosion risk) - Fundoplication (Nissen 360° or Toupet 270°) to address reflux + prevent recurrence - Consider gastropexy in selected; (2) **Type III PEH**: combined sliding + paraesophageal — GEJ above diaphragm + portion of stomach beside esophagus; (3) **Indications for elective repair**: symptomatic (reflux, dysphagia, anemia, obstruction), large hernia > 50% intrathoracic, volvulus, recurrent complications; (4) **Emergent indications**: incarceration, strangulation, perforation, obstruction — high mortality 15-20% if delayed; (5) **Pre-op**: PPI, anemia workup, transfuse PRBC if symptomatic; nutritional optimization; (6) **Post-op**: gastric reflux still possible; recurrence rate 10-25% at 5 years (less with mesh); (7) Risk-benefit discussion — elderly + comorbid → balance"},{"label":"C","text":"Endoscopic dilation only"},{"label":"D","text":"Total gastrectomy"},{"label":"E","text":"Heller myotomy"}]'::jsonb,
  'B', 'Hiatal hernia classification: - Type I (sliding) — most common, GEJ displaced into chest - Type II (true paraesophageal) — gastric fundus beside esophagus, GEJ intra-abdominal - Type III (mixed sliding + paraesophageal) — most common PEH - Type IV — other organs herniated (colon, spleen) Asymptomatic PEH — observation generally (Stylopoulos approach — watchful waiting; risk of emergency low ~1%/yr but high mortality if emergent). Symptomatic PEH — elective laparoscopic repair. Cameron lesions — gastric erosions/ulcers in hernia sac at diaphragmatic hiatus — cause chronic GI bleeding + iron deficiency anemia. Surgical principles: sac dissection, complete reduction, crural closure, antireflux procedure (Nissen most common; Toupet if dysmotility / poor esophageal contractility). Mesh use controversial — meta-analyses show reduced short-term recurrence but erosion + esophageal stricture risk with synthetic; biologic acceptable.', NULL,
  'medium', 'gi', 'review',
  'surgery', 'clinical_decision', 'gi', 'adult',
  'SAGES Hiatal Hernia Guidelines 2013/Updated; Kohn GP et al. Surg Endosc 2013; Stylopoulos N et al. Ann Surg 2002', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 70 ปี dysphagia + reflux 6 เดือน + iron deficiency anemia

EGD: large 8 cm paraesophageal hernia type III + organoaxial gastric volvulus + Cameron erosions in herniated stomach
CT: > 50% stomach in chest + obstruction signs at GEJ

Symptoms: dysphagia worsening + intermittent chest pain + early satiety + anemia

คำถาม: management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 35 ปี BMI 42 (severe obesity class III), DM type 2 controlled HbA1c 7.2, HT, OSA, depression — ลองอาหารควบคุมหลายปีไม่สำเร็จ ต้องการลดน้ำหนักถาวร

VS stable, lab acceptable, psychological evaluation cleared

คำถาม: ตัวเลือก bariatric surgery', '[{"label":"A","text":"Bariatric not indicated at this BMI"},{"label":"B","text":"**Bariatric surgery candidate (BMI > 40 OR BMI > 35 with obesity-related comorbidities — ASMBS 2022 update lowered threshold)**: (1) **Multidisciplinary evaluation**: dietitian, psychologist, endocrinology, gastroenterology — preoperative weight loss, nutritional assessment, medical optimization, psychiatric clearance, smoking cessation; (2) **Procedure options**: - **Roux-en-Y gastric bypass (RYGB)** — gold standard; greater + more durable weight loss, better DM resolution, more GERD improvement; complexity higher; risks: marginal ulcer, internal hernia, dumping, nutritional deficiency - **Sleeve gastrectomy (LSG)** — most common globally; simpler; less weight loss than RYGB but acceptable durability; risks: leak (staple line), GERD worsening (Barrett''s screening) - **Duodenal switch (BPD-DS) / SADI-S** — most weight loss but more nutritional issues; reserved superobese - **Adjustable gastric band (LAGB)** — historic, declining use; lowest efficacy + durability; (3) **Outcomes**: 60-70% excess weight loss at 1-2 yr; DM remission 50-80% (DiaRem score predicts); HT, OSA, dyslipidemia improvement; mortality reduction (Sjöström SOS study); (4) **Lifelong vitamin + mineral supplementation** + nutritional surveillance + medical follow-up; (5) **Psychological** — eating disorder screening + ongoing support; (6) **DM**: SO bariatric surgery (Metabolic Surgery)** — 2nd-line for T2DM BMI ≥ 30 not controlled (joint statements); (7) Pregnancy — wait 12-18 months post-op + folic acid + vitamin supplementation"},{"label":"C","text":"Liposuction"},{"label":"D","text":"Gastric balloon as definitive"},{"label":"E","text":"Refer to psychiatry only"}]'::jsonb,
  'B', '**Bariatric / metabolic surgery indications** (ASMBS-IFSO 2022 update — lowered thresholds): - BMI ≥ 35 regardless of comorbidities - BMI 30-34.9 with metabolic disease (T2DM, NAFLD/MASH) - Asian populations: BMI 27.5-32.5 with comorbidities considered Historical NIH 1991 was BMI > 40 OR > 35 + comorbidity. **Mechanism of weight loss + metabolic improvement**: restriction (anatomical), malabsorption (RYGB, DS), neurohormonal (ghrelin, GLP-1, PYY changes). **Outcomes**: - %EWL: LSG ~ 50-60%, RYGB ~ 60-70%, DS ~ 70-80% - DM remission: highest with DS > RYGB > LSG (STAMPEDE trial 5-yr) - HT, OSA, MASH improvement substantial - Mortality 30-40% reduction long-term (Sjöström SOS) **Complications**: leak, bleeding, stenosis, internal hernia, marginal ulcer, dumping, nutritional deficiency (iron, B12, calcium, vit D, thiamine in rapid loss). **Pregnancy** — defer 12-18 mo for stable weight + nutrition. **Endoscopic options**: gastric balloons (temporary), endoscopic sleeve (under investigation) — bridging or non-surgical candidates. A ผิด — meets criteria. C ผิด — cosmetic, not metabolic. D ผิด — temporary. E ผิด — already cleared.', NULL,
  'easy', 'endocrine_metabolic', 'review',
  'surgery', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'ASMBS-IFSO Statement on Indications for Metabolic Surgery 2022; STAMPEDE Trial NEJM 2017; Sjöström L et al. JAMA 2012 (SOS Study)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 35 ปี BMI 42 (severe obesity class III), DM type 2 controlled HbA1c 7.2, HT, OSA, depression — ลองอาหารควบคุมหลายปีไม่สำเร็จ ต้องการลดน้ำหนักถาวร

VS stable, lab acceptable, psychological evaluation cleared

คำถาม: ตัวเลือก bariatric surgery'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 65 ปี post-Roux-en-Y gastric bypass 3 ปี มาด้วยอาการปวดท้องเรื้อรังเป็นพักๆ 6 เดือน + คลื่นไส้อาเจียน ครั้งล่าสุด acute severe + bilious vomiting 24 hr ก่อน

VS: BP 102/64, HR 116, RR 22, Temp 37.0°C
Abdomen: distended, tender diffuse, sluggish bowel sounds

Lab: WBC 14,800, lactate 3.4
CT abdomen: ''mesenteric whirl sign'' + small bowel obstruction + dilated alimentary limb', '[{"label":"A","text":"NG decompression + observation 48 hr"},{"label":"B","text":"**Internal hernia post-RYGB — surgical emergency**: (1) **Resuscitation** + NG decompression + IV fluid + surgical consultation; (2) **Emergent diagnostic laparoscopy / laparotomy** — high suspicion + whirl sign on CT — do NOT delay; (3) **Operative findings**: 3 possible defect sites post-RYGB: - **Petersen''s defect** — between Roux limb mesentery + transverse mesocolon - **Jejunojejunostomy mesenteric defect** - **Transverse mesocolon defect** (if retrocolic Roux limb); (4) **Reduce** internally herniated bowel; **assess viability** — resect non-viable; (5) **Close all mesenteric defects with non-absorbable suture** to prevent recurrence; (6) **Postop**: bowel rest, gradual feeding, nutritional optimization; (7) **High mortality** if delayed (bowel ischemia in closed loop) — modern series mortality ~ 1-3% with timely intervention vs >20% delayed; (8) Counsel patient about lifelong risk + symptom recognition"},{"label":"C","text":"Outpatient EGD"},{"label":"D","text":"Antibiotic alone"},{"label":"E","text":"Reverse RYGB"}]'::jsonb,
  'B', 'Internal hernia post-bariatric (RYGB) — incidence 1-5%; cause of significant late morbidity. Mesenteric defects created during RYGB heal poorly + may not be closed routinely (controversy — current trend toward routine closure with non-absorbable suture). Three sites: 1. Petersen''s defect (between Roux limb mesentery + transverse mesocolon) 2. Jejunojejunostomy defect 3. Transverse mesocolon defect (retrocolic technique) Antecolic Roux limb construction → only Petersen''s + JJ defects (preferred technique). Diagnosis: high index of suspicion in any post-RYGB patient with abdominal symptoms. CT signs: mesenteric swirl/whirl sign (twisted vessels), SBO, mesenteric edema, hurricane sign. Plain CT may be falsely negative — symptoms + clinical alone may warrant diagnostic laparoscopy. Treatment: emergent reduction + defect closure. Bowel ischemia common — assess viability carefully. Post-op recurrence with simple closure 5-10%; non-absorbable suture preferred. Patient education + early ED visit for symptoms key.', NULL,
  'hard', 'gi', 'review',
  'surgery', 'clinical_decision', 'gi', 'adult',
  'ASMBS Standardization of Outcomes Committee; Geubbels N et al. Obes Surg 2015; Stenberg E et al. Lancet 2016 (mesenteric defect closure RCT)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 65 ปี post-Roux-en-Y gastric bypass 3 ปี มาด้วยอาการปวดท้องเรื้อรังเป็นพักๆ 6 เดือน + คลื่นไส้อาเจียน ครั้งล่าสุด acute severe + bilious vomiting 24 hr ก่อน

VS: BP 102/64, HR 116, RR 22, Temp 37.0°C
Abdomen: distended, tender diffuse, sluggish bowel sounds

Lab: WBC 14,800, lactate 3.4
CT abdomen: ''mesenteric whirl sign'' + small bowel obstruction + dilated alimentary limb'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 45 ปี post-gastrectomy 2 ปีก่อนสำหรับ gastric ulcer มา outpatient ด้วย persistent watery diarrhea + flushing 15 นาทีหลังกิน + palpitation + sweating + drowsiness ก่อนกินอาหารบ่อย ๆ

Glucose during episodes 48 mg/dL
Upper GI series: small gastric remnant + rapid emptying

คำถาม: management', '[{"label":"A","text":"Insulin therapy"},{"label":"B","text":"**Dumping syndrome post-gastrectomy — early + late dumping symptoms**: (1) **Early dumping** (within 30 min): rapid emptying of hyperosmolar food → fluid shift into bowel + vasoactive substance release → tachycardia, sweating, flushing, abdominal cramps; (2) **Late dumping** (1-3h): rapid carbohydrate absorption → insulin spike → reactive hypoglycemia; this patient has both; (3) **Dietary management first-line** (75% improve): - **Small frequent meals** 6-8/day - **Low simple carb / high complex carb + protein + fat** - **Avoid hyperosmolar liquids** with meals — separate fluid from solid 30-60 min - **Pectin/guar gum** soluble fiber to slow gastric emptying - **Lie down 30 min post-meal**; (4) **Acarbose** — α-glucosidase inhibitor — slows carb absorption → reduces late dumping (reactive hypoglycemia); (5) **Octreotide** — somatostatin analog — slows GI transit + inhibits insulin/vasoactive peptides; SC short-acting before meals OR LAR depot monthly — refractory cases; (6) **Surgical revision** for refractory severe (< 5%): - Reconstruction with Roux limb (if Billroth I/II) - Antireflux procedure - Pyloric reconstruction (Henley loop, jejunal interposition); (7) **Nutritional follow-up** + monitoring B12, iron, calcium, vit D"},{"label":"C","text":"PPI long-term"},{"label":"D","text":"Total gastrectomy"},{"label":"E","text":"Antibiotic for SIBO"}]'::jsonb,
  'B', 'Dumping syndrome — common post-gastrectomy / pyloroplasty / RYGB. Pathophysiology: 1. Early (osmotic + vasomotor): hyperosmolar bolus into small bowel → fluid shift, release of vasoactive intestinal peptides (VIP, neurotensin, serotonin) → tachycardia, flushing, sweating, cramps 2. Late (hypoglycemic): rapid glucose absorption → hyperinsulinism → reactive hypoglycemia 30 min - 3h post-meal Diagnosis: clinical + Sigstad score (≥ 7 suggests dumping); oral glucose challenge with hypoglycemia + tachycardia. Treatment ladder: 1. Diet modification (75% effective) 2. Acarbose for late dumping 3. Octreotide SC pre-meal or LAR for refractory 4. Surgical revision rarely needed Post-RYGB hypoglycemia (''post-bariatric hypoglycemia'') — late dumping variant, increasingly recognized; lifestyle + acarbose + diazoxide considered.', NULL,
  'medium', 'gi', 'review',
  'surgery', 'clinical_decision', 'gi', 'adult',
  'Tack J et al. Aliment Pharmacol Ther 2009; Berg P et al. Curr Diab Rep 2018; Scarpellini E et al. Nat Rev Endocrinol 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 45 ปี post-gastrectomy 2 ปีก่อนสำหรับ gastric ulcer มา outpatient ด้วย persistent watery diarrhea + flushing 15 นาทีหลังกิน + palpitation + sweating + drowsiness ก่อนกินอาหารบ่อย ๆ

Glucose during episodes 48 mg/dL
Upper GI series: small gastric remnant + rapid emptying

คำถาม: management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 28 ปี ตกจากที่สูง โดน blunt chest trauma

VS: BP 110/72, HR 102, RR 20, SpO2 95% room air
Chest: tenderness left chest, no flail, mild crepitus
CXR: widened mediastinum > 8 cm + indistinct aortic knob + left apical cap + depressed left mainstem bronchus
CT chest angiography: blunt thoracic aortic injury at isthmus (just distal to L subclavian) — grade III (pseudoaneurysm) + mediastinal hematoma; no contrast extravasation

คำถาม: management', '[{"label":"A","text":"Conservative observation"},{"label":"B","text":"**Blunt Thoracic Aortic Injury (BTAI) — modern preferred: thoracic endovascular aortic repair (TEVAR)**: (1) **Acute resuscitation + permissive hypotension** SBP 100-120 (lower if no head injury) + heart rate control (esmolol or labetalol) to reduce shear stress on aorta — ''impulse control'' (dP/dt reduction); (2) **Grade-based management** (SVS BTAI classification): - Grade I (intimal tear): observation + medical (impulse control); - Grade II (intramural hematoma): selective intervention; - Grade III (pseudoaneurysm): **TEVAR within 24h** — improved survival vs open in modern era (NTDB data, AAST PROOVIT registry); - Grade IV (rupture): emergent TEVAR; (3) **TEVAR**: percutaneous femoral access, stent-graft deploy across injury; may require LSCA coverage (consider revascularization if dominant); (4) **Open repair** alternative — if TEVAR not feasible (anatomy, no graft) — left thoracotomy + clamp + interposition graft; higher morbidity; (5) **Address concurrent injuries** — TBI, abdominal, etc.; balance permissive hypotension vs head injury; (6) ICU + multidisciplinary trauma"},{"label":"C","text":"Anticoagulation only"},{"label":"D","text":"Aspirin only"},{"label":"E","text":"Wait 1 week for elective repair"}]'::jsonb,
  'B', '**Blunt Thoracic Aortic Injury (BTAI)** — usually at aortic isthmus (just distal to L subclavian artery — relatively fixed ligamentum arteriosum). Result of rapid deceleration (MVC, fall, blast). 80-85% die at scene; remaining present with widened mediastinum, hypotension. Diagnosis: CXR signs (widened mediastinum > 8 cm, apical cap, indistinct knob, depressed L mainstem bronchus, tracheal deviation R, NG tube deviation R, L pleural effusion) → CT angiography gold standard. SVS BTAI Grading: - I: intimal tear - II: intramural hematoma - III: pseudoaneurysm (most common needing intervention) - IV: rupture / transection Management evolution: open repair → TEVAR (since 2010s). Modern era: TEVAR < 24h preferred — reduced mortality, paraplegia (vs open clamp/sew). Anatomical considerations: proximal landing zone, LSCA coverage (consider revascularization), femoral access. Impulse control medical therapy critical — beta-blocker (esmolol) to reduce dP/dt + shear; SBP target lower; concurrent TBI requires balanced BP target. A C D E ผิด — grade III ต้อง intervention urgent.', NULL,
  'hard', 'trauma', 'review',
  'surgery', 'clinical_decision', 'trauma', 'adult',
  'SVS Practice Guidelines for BTAI 2011; AAST PROOVIT; EAST PMG Blunt Aortic Injury; Lee WA et al. J Vasc Surg', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 28 ปี ตกจากที่สูง โดน blunt chest trauma

VS: BP 110/72, HR 102, RR 20, SpO2 95% room air
Chest: tenderness left chest, no flail, mild crepitus
CXR: widened mediastinum > 8 cm + indistinct aortic knob + left apical cap + depressed left mainstem bronchus
CT chest angiography: blunt thoracic aortic injury at isthmus (just distal to L subclavian) — grade III (pseudoaneurysm) + mediastinal hematoma; no contrast extravasation

คำถาม: management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 32 ปี post-thyroidectomy total day 1 มาด้วยอาการ tetany, perioral numbness, tingling fingers, positive Chvostek + Trousseau signs

VS stable
Lab: Ca 6.4 (low), ionized Ca 0.8, Mg 1.6, PO4 5.2, PTH 8 (low normal), albumin 4.0
ECG: prolonged QTc

คำถาม: management', '[{"label":"A","text":"Oral calcium carbonate alone"},{"label":"B","text":"**Symptomatic post-thyroidectomy hypocalcemia (likely transient hypoparathyroidism from parathyroid trauma/devascularization)**: (1) **IV calcium gluconate 10% 10 mL slow IV bolus over 10 min** (3-4 mL contains 1 g — provides 90 mg elemental Ca per amp) — repeat as needed + continuous infusion if persistent (e.g., 1 g calcium gluconate in 100 mL D5W at 50 mL/h titrate); (2) **Repeat Ca q4-6h**; (3) **Activated vitamin D (calcitriol)** 0.25-0.5 mcg PO BID — bypasses PTH-dependent activation; (4) **Oral calcium carbonate** 1-2 g elemental Ca q6h between meals (better absorbed); (5) **Replete magnesium** — Mg essential for PTH function + Ca release; IV MgSO4 1-2 g if Mg < 1.8; (6) **ECG monitoring** — prolonged QT → torsade risk; (7) **Differentiate transient vs permanent hypoparathyroidism**: transient 6 mo follow-up; permanent if PTH not recovering — continue lifelong Ca + calcitriol; consider PTH replacement (recombinant PTH 1-84); (8) **Hungry bone syndrome** consideration in pre-op hyperparathyroid patients post-parathyroidectomy — rapid Ca uptake into bones; same management"},{"label":"C","text":"Furosemide"},{"label":"D","text":"Steroid IV"},{"label":"E","text":"Discharge with PO calcium"}]'::jsonb,
  'B', '**Post-thyroidectomy hypocalcemia** — common (10-30% transient, 1-3% permanent post-total thyroidectomy). Causes: 1. Parathyroid trauma / devascularization / inadvertent removal 2. Hungry bone syndrome — patients with severe pre-op hyperparathyroidism (rapid Ca deposition into bones post-correction) 3. Hypomagnesemia impairing PTH function/secretion **Symptoms**: perioral + acral paresthesias, muscle cramps, Chvostek sign (facial twitch on tapping facial nerve at zygomatic arch), Trousseau sign (carpal spasm with BP cuff inflation), tetany, laryngospasm, seizures, prolonged QT → torsades **Severity grading**: - Mild (Ca 8.0-8.4): oral Ca + calcitriol - Moderate (Ca 7.0-7.9): oral + close monitoring - Severe (Ca < 7.0 or symptomatic): IV calcium gluconate + infusion **IV Ca preparation**: - Calcium gluconate 10% 10 mL = 1 g = 90 mg elemental Ca (preferred — less tissue necrosis if extravasate) - Calcium chloride 10% 10 mL = 1 g = 270 mg elemental Ca (central line preferred — sclerosant) Always concurrently replete Mg + vitamin D. PTH check — distinguishes hypoparathyroid (low PTH) from other causes. Lifelong management of permanent hypoparathyroidism: calcium + calcitriol; recombinant PTH 1-84 for selected.', NULL,
  'easy', 'endocrine_metabolic', 'review',
  'surgery', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'American Thyroid Association Postsurgical Hypoparathyroidism Statement; ESE Hypoparathyroidism Guidelines 2015; Bollerslev J et al. Eur J Endocrinol', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 32 ปี post-thyroidectomy total day 1 มาด้วยอาการ tetany, perioral numbness, tingling fingers, positive Chvostek + Trousseau signs

VS stable
Lab: Ca 6.4 (low), ionized Ca 0.8, Mg 1.6, PO4 5.2, PTH 8 (low normal), albumin 4.0
ECG: prolonged QTc

คำถาม: management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 45 ปี ตรวจสุขภาพประจำปี พบ Ca 11.4 (high) + PTH 145 (high) + iPTH elevated + 24h urine Ca 380 (elevated) + Vit D 25-OH 22 (slightly low)

No bone disease, no nephrolithiasis on US, no DM
BMD: T-score -2.1 hip (osteopenia)
Sestamibi scan: positive single adenoma in right inferior parathyroid

คำถาม: management', '[{"label":"A","text":"Observation + repeat Ca/PTH in 1 year"},{"label":"B","text":"**Primary hyperparathyroidism with surgical indication → minimally invasive parathyroidectomy**: (1) **Surgical indications (4th International Workshop 2014)** for asymptomatic PHPT: - Age < 50 - Serum Ca > 1.0 mg/dL above upper limit normal (this patient 11.4 likely meets) - 24h urine Ca > 400 - eGFR < 60 - Nephrolithiasis or nephrocalcinosis - BMD T-score ≤ -2.5 OR vertebral fracture - Inability/refusal medical surveillance - This patient meets multiple → surgery indicated; (2) **Pre-op localization**: sestamibi scan + neck US (concordant → MIP feasible); 4D-CT if discordant; (3) **Minimally invasive parathyroidectomy (MIP)** — focused exploration of localized adenoma; intraoperative PTH monitoring (50% drop from baseline at 10 min post-excision predicts cure); (4) **Bilateral neck exploration** if non-localizing, multi-gland, family history MEN; (5) **Intraoperative PTH (IoPTH)** — drop ≥ 50% from highest pre-excision + into normal range = cure (Miami criterion); (6) **Address vitamin D deficiency** pre-op cautiously (may worsen hypercalcemia in PHPT — controversial — replete moderately); (7) **Post-op monitoring**: Ca, PTH; risk of hungry bone syndrome; (8) **Cure rate** > 95% in expert hands"},{"label":"C","text":"Calcimimetic (cinacalcet) lifelong only"},{"label":"D","text":"Total thyroidectomy"},{"label":"E","text":"Bisphosphonate alone"}]'::jsonb,
  'B', '**Primary hyperparathyroidism (PHPT)** — high Ca + high (or inappropriately normal) PTH. Most common cause of hypercalcemia in outpatients. Etiology: 85% single adenoma, 10-15% 4-gland hyperplasia (sporadic or MEN 1/2A), 1% parathyroid cancer. **Symptoms** (classic ''stones, bones, abdominal groans, psychic moans''): nephrolithiasis, osteoporosis/fractures, abdominal pain (PUD, pancreatitis), neuropsychiatric (depression, fatigue), polyuria. Many asymptomatic on screening. **4th International Workshop 2014 surgical indications** (asymptomatic): - Ca > 1.0 above ULN - 24h urine Ca > 400 + kidney stone risk - eGFR < 60 - Nephrolithiasis/nephrocalcinosis - T-score ≤ -2.5 or vertebral fracture - Age < 50 - Refusal/inability for surveillance - Symptomatic — always surgery **Localization**: sestamibi + US (concordant = MIP); 4D-CT if uncertain; MRI; PET-CT (parathyroid). **MIP**: focused approach to localized adenoma; IoPTH guides extent (Miami criterion: 50% drop into normal range = cure). **MEN consideration**: family history, young age — 4-gland exploration; subtotal vs total parathyroidectomy + autotransplant. **Cinacalcet**: calcimimetic — selected non-operative candidates; doesn''t address bone loss. A ผิด — meets surgical criteria. C ผิด — surgery curative. D ผิด — thyroidectomy ไม่ใช่ PHPT. E ผิด — surgery first-line.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'surgery', 'clinical_decision', 'endocrine_metabolic', 'adult',
  '4th International Workshop on Asymptomatic PHPT 2014 (Bilezikian); AAES Guidelines for Parathyroidectomy 2016; Wilhelm SM et al. JAMA Surg', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 45 ปี ตรวจสุขภาพประจำปี พบ Ca 11.4 (high) + PTH 145 (high) + iPTH elevated + 24h urine Ca 380 (elevated) + Vit D 25-OH 22 (slightly low)

No bone disease, no nephrolithiasis on US, no DM
BMD: T-score -2.1 hip (osteopenia)
Sestamibi scan: positive single adenoma in right inferior parathyroid

คำถาม: management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 48 ปี ภาวะ persistent hypertension + episodic palpitations + headaches + diaphoresis + hyperhidrosis + paroxysmal panic-like attacks

VS: BP 178/108 baseline; during attack 230/130
Lab: plasma metanephrine 3,200 (elevated 10x normal), normetanephrine 4,800 (elevated 8x normal), 24h urine VMA elevated; chromogranin A elevated
CT abdomen: 3.5 cm well-circumscribed enhancing mass at right adrenal
123-I MIBG scan: positive uptake at right adrenal

คำถาม: pre-op preparation + management', '[{"label":"A","text":"Beta-blocker first then surgery"},{"label":"B","text":"**Pheochromocytoma — proper preoperative alpha-blockade BEFORE surgery (critical to prevent intraoperative hypertensive crisis)**: (1) **Alpha-blockade FIRST** — phenoxybenzamine (non-selective irreversible) 10 mg BID, titrate q2-3 days to 0.5-1 mg/kg/day OR doxazosin (alpha-1 selective) 1-16 mg/day — for 10-14 days; goal: BP normotensive supine + mild orthostasis upon standing; (2) **Beta-blockade ONLY AFTER alpha-blockade established** (NEVER before — unopposed alpha → hypertensive crisis) — to control reflex tachycardia; propranolol or atenolol; (3) **High-sodium diet + IV fluid** preop — restore intravascular volume (chronic vasoconstriction has reduced); (4) **Calcium channel blocker** as adjunct (nicardipine, amlodipine); (5) **Adrenalectomy** — laparoscopic retroperitoneal OR transabdominal approach for benign-appearing < 6-8 cm; open for larger / malignant / invasive; minimize tumor manipulation (catecholamine release); ligate adrenal vein early; (6) **Intraop**: anesthesia team prepared with vasodilators (nitroprusside, phentolamine), beta-blockers (esmolol), vasopressors (norepi, phenylephrine) — wide swings of BP; (7) **Post-op**: monitor for hypotension (rebound — vasodilation), hypoglycemia (rebound insulin), and persistent disease; ICU 24h; (8) **Pathology + genetic testing** — 30-40% pheochromocytoma have germline mutation (RET, VHL, NF1, SDH genes) — refer genetics; (9) **Lifelong surveillance** for recurrence + metachronous + second primary; (10) **''Rule of 10s'' historic** (now outdated): 10% extra-adrenal (paraganglioma), 10% bilateral, 10% malignant, 10% familial — actual percentages higher"},{"label":"C","text":"Surgery immediately without medical preparation"},{"label":"D","text":"Radiotherapy"},{"label":"E","text":"Chemotherapy"}]'::jsonb,
  'B', '**Pheochromocytoma / paraganglioma** — catecholamine-secreting tumor of chromaffin cells. Adrenal medulla (pheochromocytoma) or extra-adrenal (paraganglioma — head/neck, organ of Zuckerkandl, bladder). **Symptoms triad**: paroxysmal headache + palpitations + diaphoresis (90% specificity if all 3). HT (sustained or paroxysmal). **Biochemical diagnosis**: plasma free metanephrines (most sensitive ~99%) OR 24h urine fractionated metanephrines. Chromogranin A supportive. **Imaging**: CT/MRI adrenal — ''lightbulb'' enhancement; 123-I MIBG for functional confirmation + extra-adrenal; PET-DOTA for paraganglioma/metastatic. **Preop pharmacologic preparation** (critical — historic mortality 50% → < 3% with proper prep): - Alpha-blockade 10-14 days: phenoxybenzamine (non-selective irreversible), doxazosin (selective alpha-1) - High-sodium diet + IV fluid - Beta-blockade AFTER alpha-blockade (only for tachycardia) - Calcium channel blocker adjunct - Goal: SBP < 130, mild orthostasis **Surgery**: laparoscopic adrenalectomy (transabdominal or retroperitoneal); open for large > 6-8 cm, invasive, malignant. Minimize tumor manipulation, ligate adrenal vein early. **Postop**: hypotension (rebound), hypoglycemia (catecholamine-induced insulin suppression then rebound). Long-term: lifelong biochemical surveillance, genetic testing (30-40% germline mutation — RET, VHL, NF1, SDHB/C/D, MAX, TMEM127), screen first-degree relatives if positive.', NULL,
  'hard', 'endocrine_metabolic', 'review',
  'surgery', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'Endocrine Society Pheochromocytoma/Paraganglioma Guideline 2014; NANETS Consensus; Lenders JWM et al. JCEM 2014', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 48 ปี ภาวะ persistent hypertension + episodic palpitations + headaches + diaphoresis + hyperhidrosis + paroxysmal panic-like attacks

VS: BP 178/108 baseline; during attack 230/130
Lab: plasma metanephrine 3,200 (elevated 10x normal), normetanephrine 4,800 (elevated 8x normal), 24h urine VMA elevated; chromogranin A elevated
CT abdomen: 3.5 cm well-circumscribed enhancing mass at right adrenal
123-I MIBG scan: positive uptake at right adrenal

คำถาม: pre-op preparation + management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 32 ปี ไม่มีโรคประจำตัว มาด้วยปวดท้องเฉียบพลัน LLQ 6 ชั่วโมง คลื่นไส้ ไม่อาเจียน ไม่เคยมีอาการก่อน

VS: BP 124/76, HR 88, RR 16, Temp 36.8°C
Abdomen: tender LLQ but no rebound; reducible inguinal hernia left side detected on exam — bulge over inguinal ligament
CT abdomen: incarcerated left inguinal hernia + small bowel obstruction at hernia site; bowel inside hernia sac, no signs of strangulation yet

คำถาม: management', '[{"label":"A","text":"Outpatient referral elective surgery"},{"label":"B","text":"**Incarcerated inguinal hernia with bowel obstruction — emergent surgical reduction + repair**: (1) **Attempt manual reduction** (taxis) — gentle, with sedation + Trendelenburg, after analgesia + muscle relaxation — if successful + no strangulation suspected → elective repair within days (caution: bowel ischemia could be missed → re-evaluate carefully post-reduction); (2) **Emergent surgical exploration** if: cannot reduce, signs of strangulation (peritonitis, sepsis, dark/bloody hernia sac contents, severe pain disproportionate), bowel obstruction not relieved; (3) **Operative**: - **Open approach** (Lichtenstein with mesh) — standard, can assess viability easily - **Laparoscopic** (TEP, TAPP) — increasingly utilized; allows intra-abdominal bowel assessment; mesh may be avoided if bowel viability questionable - **Bowel assessment**: viable → reduce + repair with mesh; non-viable → resect + primary anastomosis; (4) **Mesh decision**: clean contaminated (bowel resected) — primary repair without mesh OR delayed mesh OR biological mesh (controversial — recent evidence permits prosthetic in many cases per Society guidelines); (5) **Post-op**: monitor for infection, recurrence; (6) Discuss bilateral repair if other side detectable"},{"label":"C","text":"Observation + IV fluids only"},{"label":"D","text":"Laxatives"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', '**Inguinal hernia** — common surgical problem. Indirect (most common, lateral to inferior epigastric vessels, congenital patent processus vaginalis) vs direct (medial, Hesselbach triangle, acquired weakness). Most asymptomatic; watchful waiting acceptable for asymptomatic minimally symptomatic (Fitzgibbons JAMA 2006 trial). **Indications for surgery**: symptoms, enlarging, recurrent obstruction risk. **Complications**: - Incarceration: irreducible without strangulation - Strangulation: ischemic bowel — emergency - Bowel obstruction **Approach**: - Open (Lichtenstein with mesh) — gold standard - Laparoscopic (TEP — totally extraperitoneal, TAPP — transabdominal preperitoneal) — comparable outcomes, bilateral repair easier, lower chronic pain - Recent evidence: laparoscopic equal/better re: chronic pain, return to work; cost higher **Mesh**: standard in adults (lower recurrence vs primary suture per evidence). Polypropylene most common. In contaminated field (strangulated bowel resection): biological mesh OR delayed repair OR primary suture; recent literature supports prosthetic mesh selectively. **Pediatric**: high ligation alone, no mesh; very low recurrence. **Femoral hernia**: more common in women, high incarceration risk → repair always upon diagnosis.', NULL,
  'easy', 'gi', 'review',
  'surgery', 'clinical_decision', 'gi', 'adult',
  'International HerniaSurge Group Guidelines 2018; SAGES Hernia Guidelines; EHS European Hernia Society', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 32 ปี ไม่มีโรคประจำตัว มาด้วยปวดท้องเฉียบพลัน LLQ 6 ชั่วโมง คลื่นไส้ ไม่อาเจียน ไม่เคยมีอาการก่อน

VS: BP 124/76, HR 88, RR 16, Temp 36.8°C
Abdomen: tender LLQ but no rebound; reducible inguinal hernia left side detected on exam — bulge over inguinal ligament
CT abdomen: incarcerated left inguinal hernia + small bowel obstruction at hernia site; bowel inside hernia sac, no signs of strangulation yet

คำถาม: management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 60 ปี ปวดทวารหนัก + เลือดออกหลังถ่าย 6 เดือน + ก้อนยื่นออก reducible

Exam: prolapsed grade III internal hemorrhoid (reducible manually), no thrombosis, no skin tag
No perianal disease, no fistula
Colonoscopy normal proximal

คำถาม: management', '[{"label":"A","text":"Surgical hemorrhoidectomy first-line"},{"label":"B","text":"**Grade III internal hemorrhoid — staged management starting non-operative + procedural**: (1) **Conservative first-line**: high-fiber diet + adequate hydration + avoid straining + warm sitz baths + topical agents (analgesic, anti-inflammatory steroid short-term); (2) **Office-based procedures** for failed conservative or persistent grade I-III: - **Rubber band ligation (RBL)** — most effective office procedure; grade I-III; ~80% success; ligate above dentate line; avoid in anticoagulated patients (post-ligation bleeding 5-10 days); - **Infrared coagulation, sclerotherapy** — lower-grade alternatives; (3) **Surgical hemorrhoidectomy** for: grade IV, mixed internal-external, refractory grade III after RBL, complications (thrombosis, gangrene), patient preference - **Open (Milligan-Morgan) or closed (Ferguson) hemorrhoidectomy** — gold standard; remove diseased tissue; more painful but lower recurrence - **Stapled hemorrhoidopexy (Longo)** — less pain, faster recovery, higher recurrence + risk of severe complications (rectal stricture, sepsis); (4) **THD (transanal hemorrhoidal dearterialization) / HAL-RAR** — dearterialization with Doppler + mucopexy; less pain, mid-range recurrence; (5) **Address constipation + risk factors** lifelong"},{"label":"C","text":"Long-term opioid use"},{"label":"D","text":"Total proctocolectomy"},{"label":"E","text":"Observation lifelong"}]'::jsonb,
  'B', '**Hemorrhoid grading** (internal — above dentate line): - Grade I: bleeding without prolapse - Grade II: prolapse with spontaneous reduction - Grade III: prolapse requiring manual reduction - Grade IV: irreducible / chronically prolapsed External hemorrhoids — below dentate line, somatic innervation (painful); thrombosed external — excise within 72h. **Treatment ladder**: 1. Lifestyle: fiber 25-35 g/day, water, sitz bath, topical 2. Office procedures (grade I-III RBL most effective) 3. Surgical hemorrhoidectomy (Milligan-Morgan open, Ferguson closed, Longo stapled, THD/HAL-RAR) — for severe / refractory / complications 4. Newer: laser hemorrhoidoplasty Avoid: chronic constipation, prolonged straining, prolonged sitting on toilet, NSAIDs (bleeding). Pregnancy: conservative + topical; surgery rarely needed (postpartum resolution).', NULL,
  'easy', 'gi', 'review',
  'surgery', 'clinical_decision', 'gi', 'adult',
  'ASCRS Clinical Practice Guidelines for Hemorrhoids 2018; Cochrane RBL vs Hemorrhoidectomy', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 60 ปี ปวดทวารหนัก + เลือดออกหลังถ่าย 6 เดือน + ก้อนยื่นออก reducible

Exam: prolapsed grade III internal hemorrhoid (reducible manually), no thrombosis, no skin tag
No perianal disease, no fistula
Colonoscopy normal proximal

คำถาม: management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 35 ปี ปวดบริเวณก้นกบ 3 วัน + บวมแดงร้อน + ไข้ต่ำ

Exam: tender erythematous swelling 4 cm at lower sacrum + central pit + small purulent discharge
Hair tuft present
No signs of cellulitis spreading

คำถาม: management', '[{"label":"A","text":"Oral antibiotic only"},{"label":"B","text":"**Acute pilonidal abscess — incision + drainage**: (1) **I&D off-midline** — local anesthesia + small lateral incision (off-midline preferred — better healing than midline); evacuate pus + debride hair + necrotic tissue; loose packing; no closure; (2) **No routine antibiotic** unless: cellulitis spreading, immunocompromised, sepsis — if needed: cover skin flora (cefalexin, dicloxacillin) or MRSA (clindamycin, doxycycline, TMP-SMX) per local prevalence; (3) **Wound care**: regular dressing change, sitz baths; (4) **Definitive treatment after acute episode resolved**: elective management of pilonidal disease — - **Pit picking / Bascom''s procedure** (minimally invasive, off-midline) - **Excision + secondary intention healing** (open wound, longer healing) - **Excision + primary closure off-midline** (Karydakis flap, Limberg/rhomboid flap) — lower recurrence than midline closure - **Laser ablation** (newer); (5) **Lifestyle**: hair removal (shaving, laser depilation) at natal cleft, hygiene, weight loss, avoid prolonged sitting; (6) **Recurrence** 10-30% — choice of definitive procedure affects"},{"label":"C","text":"Observation only"},{"label":"D","text":"Total proctectomy"},{"label":"E","text":"Discharge home, follow up 1 week"}]'::jsonb,
  'B', '**Pilonidal disease** — chronic sinus / abscess in natal cleft, usually 15-35 yr males with deep cleft + hair + sweating. Etiology: hair penetrates skin → foreign body reaction + sinus → recurrent infection. **Acute abscess**: I&D off-midline (better healing); systemic antibiotic for surrounding cellulitis only. **Chronic / recurrent disease**: - Conservative: hair removal (shaving, laser depilation — Conroy meta-analysis supports laser), hygiene - Pit picking (Bascom) — minimally invasive - Excision + healing by secondary intention — longer wound care - Excision + flap closure off-midline (Karydakis, Limberg rhomboid) — lower recurrence than midline primary closure - Endoscopic pilonidal sinus treatment (EPSiT), laser ablation — newer **Wound closure principle**: avoid midline closure (poor healing, recurrence) — off-midline flap preferred. **Risk factors**: obesity, sedentary, sweating, hairy, family history. **Prevention**: hair removal, hygiene. A ผิด — abscess ต้อง I&D. C ผิดอย่างยิ่ง. D ผิดเกินจริง. E ผิด.', NULL,
  'easy', 'id', 'review',
  'surgery', 'clinical_decision', 'id', 'adult',
  'ASCRS Clinical Practice Guidelines for Pilonidal Disease 2019; Iesalnieks I et al. Coloproctology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 35 ปี ปวดบริเวณก้นกบ 3 วัน + บวมแดงร้อน + ไข้ต่ำ

Exam: tender erythematous swelling 4 cm at lower sacrum + central pit + small purulent discharge
Hair tuft present
No signs of cellulitis spreading

คำถาม: management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 28 ปี Crohn''s disease 10 ปี on adalimumab + budesonide แต่ flare ใหม่ 1 เดือน ปวดท้อง RLQ + ถ่ายเหลว 6 ครั้ง/วัน + น้ำหนักลด 4 kg + perianal fistula chronic

MRI enterography: active inflammation distal ileum 15 cm + stricture + small bowel obstruction features + complex perianal fistula (Park''s type)
Colonoscopy: focal colitis + skip lesions

คำถาม: surgical considerations', '[{"label":"A","text":"Total proctocolectomy + ileal pouch-anal anastomosis (IPAA)"},{"label":"B","text":"**Crohn''s disease with stricturing + penetrating phenotype — selective surgical approach (bowel preservation principle)**: (1) **Optimize medical therapy** — biologic optimization (adalimumab trough + ADA), switch class if loss of response (anti-TNF → ustekinumab, vedolizumab, risankizumab, upadacitinib JAK), corticosteroid bridging, nutritional optimization; (2) **Surgical indications in Crohn''s**: failed medical therapy, intestinal obstruction (stricture), perforation, hemorrhage, fistula refractory, cancer/dysplasia, growth failure (pediatric); (3) **Surgical principles** — BOWEL PRESERVATION: - **Strictureplasty** (Heineke-Mikulicz, Finney, Michelassi for long strictures) — preserve bowel length, avoid short gut - **Limited segmental resection** with histologically clean margins (~ 2 cm grossly normal — no need wider; recurrence not reduced) - Avoid wide resection; (4) **Ileocecal resection** for distal ileal disease — standard; recent LIR!C trial (Ponsioen Lancet GH 2017) — early surgery non-inferior to infliximab in selected; (5) **Perianal fistulas** — multidisciplinary: seton placement for drainage, MRI mapping; biologic therapy (anti-TNF); local excision/LIFT; mesenchymal stem cell therapy (darvadstrocel — ADMIRE-CD); (6) **No IPAA in Crohn''s** — high failure + complications; reserved for UC; (7) **Post-op recurrence prophylaxis** — clinical features (smoking, fistulizing, prior resection) → start biologic 4-8 weeks post-op; (8) **Surveillance for dysplasia/cancer** — chronic colitis at risk; (9) **Smoking cessation absolute** in Crohn''s — strongest modifiable risk; (10) Multidisciplinary IBD team"},{"label":"C","text":"Refuse surgery in all Crohn''s"},{"label":"D","text":"Total colectomy + permanent ileostomy first-line"},{"label":"E","text":"Whipple procedure"}]'::jsonb,
  'B', '**Crohn''s disease surgical principles**: 1. Crohn''s is not curable surgically — recurrence common — preserve bowel 2. Common indications: stricture (obstruction), fistula (enteroenteric, enterovesical, enterocutaneous), abscess, perforation, hemorrhage, dysplasia/cancer, refractory disease, growth retardation 3. Surgical options: - Strictureplasty (Heineke-Mikulicz < 10 cm, Finney for medium, Michelassi side-to-side isoperistaltic for long > 25 cm) — preserves length - Limited segmental resection with 2 cm grossly normal margin (Fazio Ann Surg 1996 — no benefit to wider margins for recurrence) - Drainage of abscess (often percutaneous first) - Diversion stoma sparingly 4. AVOID: extensive resection, IPAA (high failure in Crohn''s), pouch in Crohn''s 5. Recurrence — endoscopic 70% at 1 yr, surgical 30% at 10 yr 6. Postoperative prophylaxis: anti-TNF or other biologic based on risk (POCER trial — colonoscopy-guided step-up) 7. Smoking cessation absolute Perianal fistulas: complex anatomy (Park classification — intersphincteric, transsphincteric, suprasphincteric, extrasphincteric); MRI mapping; multidisciplinary management: drainage seton + biologic + local procedure (LIFT, fistula plug, advancement flap); mesenchymal stem cells (allogeneic adipose-derived darvadstrocel) for refractory complex perianal Crohn''s fistulas. A ผิด — IPAA = UC. C E ผิดอย่างยิ่ง. D ผิด — bowel-preserving.', NULL,
  'hard', 'gi', 'review',
  'surgery', 'clinical_decision', 'gi', 'adult',
  'ECCO-ESCP Surgical Management Crohn''s 2017; ASCRS Crohn''s Surgical Guidelines 2020; Ponsioen CY et al. Lancet GH 2017 (LIR!C)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 28 ปี Crohn''s disease 10 ปี on adalimumab + budesonide แต่ flare ใหม่ 1 เดือน ปวดท้อง RLQ + ถ่ายเหลว 6 ครั้ง/วัน + น้ำหนักลด 4 kg + perianal fistula chronic

MRI enterography: active inflammation distal ileum 15 cm + stricture + small bowel obstruction features + complex perianal fistula (Park''s type)
Colonoscopy: focal colitis + skip lesions

คำถาม: surgical considerations'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 24 ปี Ulcerative colitis 5 ปี on mesalamine + azathioprine + steroid; ตอนนี้ admit ICU ด้วย severe acute UC flare 10 วัน — diarrhea 12 ครั้ง/วัน + bloody + abdominal distention + ไข้ + tachycardia

VS: BP 102/64, HR 116, Temp 38.4°C
Abdomen: distended, tender, decreased bowel sounds
Lab: Hb 8.2, albumin 2.4, CRP 180, K 3.0
KUB: transverse colon dilated 7 cm + ''thumbprinting'' edema
Colonoscopy (limited): severe ulcerated mucosa + Mayo 3

Truelove-Witts severe
CT scan: rule out perforation, megacolon', '[{"label":"A","text":"Continue azathioprine + steroid same dose"},{"label":"B","text":"**Acute Severe Ulcerative Colitis (ASUC) — toxic megacolon possible, medical rescue OR colectomy**: (1) **Hospitalization + supportive care**: NPO, NG decompression if megacolon, IV fluid, electrolyte correction (K), VTE prophylaxis (UC = high VTE risk), correct anemia, nutritional support (parenteral if needed); rule out CDI + CMV (stool toxin + sigmoidoscopy biopsy CMV IHC); (2) **IV corticosteroid** — methylprednisolone 60 mg/day OR hydrocortisone 100 mg q6h — first 72h; (3) **Day 3 assessment** (Travis criteria): CRP > 45 + > 8 stools/day = > 80% likely need colectomy → consider rescue OR surgery; (4) **Medical rescue if no response by day 3-5**: - **Infliximab** 5 mg/kg IV (consider higher dose 10 mg/kg in severe inflammation given clearance) — accelerated induction - **Cyclosporine** IV 2-4 mg/kg/day - **Tofacitinib** rapid acting — emerging - **JAK inhibitors** upadacitinib emerging; (5) **Colectomy indication** — emergent: toxic megacolon (transverse colon > 6 cm + signs sepsis), perforation, massive hemorrhage, failed medical rescue 5-7 days; subacute: failed medical optimization; (6) **Surgery**: **subtotal/total colectomy with end ileostomy + Hartmann pouch** (preserve rectum) — emergent / unstable / steroid-dependent; later reconstruction with IPAA (ileal pouch-anal anastomosis) in 3-stage approach; (7) **Avoid antimotility** + opioids (precipitate toxic megacolon); (8) Long-term post-IPAA — pouchitis common (15-50%) — treat antibiotic"},{"label":"C","text":"Discharge home with oral steroid"},{"label":"D","text":"Antidiarrheal medication"},{"label":"E","text":"Total proctectomy alone, leave colon"}]'::jsonb,
  'B', '**Acute Severe UC (ASUC)** — Truelove-Witts criteria: ≥ 6 bloody stools/day + 1+ systemic (HR > 90, fever > 37.8, Hb < 10.5, ESR > 30, albumin < 30, CRP elevated). Mortality without colectomy historically 30%; modern era < 1% with rescue medical + timely surgery. **Day 3 assessment** (Oxford / Travis predictors of colectomy): - CRP > 45 + 3-8 stools/day OR > 8 stools/day on day 3 → 80% need colectomy **Rescue therapy options** (failed IV steroid day 3-5): 1. Infliximab — increasingly preferred; consider accelerated dosing (10 mg/kg, repeat 7 days) — CONSTRUCT trial 2. Cyclosporine IV 2-4 mg/kg/day — historical efficacy similar 3. JAK inhibitor (tofacitinib, upadacitinib) — emerging, rapid onset 4. Sequential rescue (cyclo → IFX or vice versa) not recommended — bone marrow + infection risk **Surgery (colectomy)** indications: toxic megacolon (≥ 6 cm + sepsis), perforation, hemorrhage, failed rescue 5-7 days. **Approach**: total/subtotal colectomy + end ileostomy + Hartmann (preserve rectum) — emergent; staged IPAA later (2 or 3 stages depending on patient). **Toxic megacolon**: KUB transverse colon > 6 cm + systemic toxicity (3+ of fever, HR > 120, WBC > 10.5k, anemia) + 1+ of dehydration, AMS, electrolyte, hypotension. **VTE prophylaxis** essential — UC active disease is hypercoagulable. A ผิด — current regimen failed. C ผิด — severe ต้อง IV. D ผิด — โครงสร้าง megacolon. E ผิด — leave colon = recurrent.', NULL,
  'hard', 'gi', 'review',
  'surgery', 'clinical_decision', 'gi', 'adult',
  'ECCO Acute Severe UC Guidelines 2022; AGA Guidelines Moderate-Severe UC 2020; Travis SPL et al. Gut 1996', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 24 ปี Ulcerative colitis 5 ปี on mesalamine + azathioprine + steroid; ตอนนี้ admit ICU ด้วย severe acute UC flare 10 วัน — diarrhea 12 ครั้ง/วัน + bloody + abdominal distention + ไข้ + tachycardia

VS: BP 102/64, HR 116, Temp 38.4°C
Abdomen: distended, tender, decreased bowel sounds
Lab: Hb 8.2, albumin 2.4, CRP 180, K 3.0
KUB: transverse colon dilated 7 cm + ''thumbprinting'' edema
Colonoscopy (limited): severe ulcerated mucosa + Mayo 3

Truelove-Witts severe
CT scan: rule out perforation, megacolon'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกแรกเกิดอายุ 1 วัน อาเจียน bilious 12 ชั่วโมง + abdominal distention + ไม่ผ่าน meconium 24 hr

VS stable
Abdomen: distended, no peritonitis
X-ray: dilated loops bowel + ''soap bubble'' appearance RLQ + no rectal gas
Contrast enema: microcolon + dilated proximal small bowel + filling defects in distal ileum', '[{"label":"A","text":"NG decompression only, no further workup"},{"label":"B","text":"**Meconium ileus in neonate — likely cystic fibrosis-associated**: (1) **Initial resuscitation**: NPO, NG decompression, IV fluid, broad-spectrum antibiotic; (2) **Cystic fibrosis evaluation** — sweat chloride test + CFTR genetic testing — > 80% of meconium ileus have CF; refer pulmonology, genetics; (3) **Therapeutic Gastrografin enema** — hypertonic water-soluble contrast under fluoroscopy — both diagnostic + therapeutic (osmotic effect draws fluid → soften + flush meconium); success rate 50-70% in uncomplicated meconium ileus; risks: bowel perforation (~5%), fluid shift → hypovolemia (preceded by IV fluid resuscitation); (4) **Surgery indications**: failed contrast enema (3 attempts), complications (perforation, volvulus, atresia), complicated meconium ileus (meconium peritonitis, ileal atresia, pseudocyst); (5) **Surgical options**: enterotomy + meconium evacuation + irrigation; resection of non-viable segment + primary anastomosis or temporary stoma (Bishop-Koop, Mikulicz); (6) **Postop**: enzyme replacement therapy, nutritional optimization (CF-specific), antibiotic, follow CF specialist long-term; (7) Genetic counseling for family planning"},{"label":"C","text":"Outpatient referral pediatric surgery"},{"label":"D","text":"Emergent total colectomy"},{"label":"E","text":"Observation 48 hr"}]'::jsonb,
  'B', '**Meconium ileus** — distal small bowel obstruction in neonate from thick inspissated meconium; > 80% have cystic fibrosis (CFTR mutation → abnormal mucus). Other causes: pancreatic insufficiency, Hirschsprung''s (DDx), small left colon syndrome (maternal DM). **Presentation**: bilious vomiting + abdominal distention + failure to pass meconium > 24h. **X-ray**: dilated bowel + ''soap bubble'' appearance RLQ (meconium-gas), absent rectal gas. **Contrast enema (Gastrografin)**: microcolon (disuse) + filling defects in ileum from meconium. **Therapeutic enema**: hypertonic water-soluble (Gastrografin) — osmotic action; success 50-70% uncomplicated; risks: perforation 3-5%, fluid shift → hypovolemia (IV pre-hydration mandatory); repeat 1-2 times if partial success. **Surgery**: failed enema, complications. Options: enterotomy + irrigation, resection + anastomosis vs stoma (Bishop-Koop double-barrel, Mikulicz, Santulli). **CF evaluation**: sweat chloride > 60 mEq/L diagnostic; CFTR mutation analysis; pulmonology follow-up; pancreatic enzyme replacement therapy (PERT); nutritional optimization (high calorie, fat-soluble vitamins); long-term CF center care; precision therapy (CFTR modulators — ivacaftor, elexacaftor-tezacaftor-ivacaftor) for specific mutations.', NULL,
  'medium', 'pediatrics', 'review',
  'surgery', 'clinical_decision', 'pediatrics', 'peds',
  'APSA Pediatric Surgery Handbook; Cystic Fibrosis Foundation Consensus; Lawrence MJ et al. World J Pediatr', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ทารกแรกเกิดอายุ 1 วัน อาเจียน bilious 12 ชั่วโมง + abdominal distention + ไม่ผ่าน meconium 24 hr

VS stable
Abdomen: distended, no peritonitis
X-ray: dilated loops bowel + ''soap bubble'' appearance RLQ + no rectal gas
Contrast enema: microcolon + dilated proximal small bowel + filling defects in distal ileum'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกแรกเกิดอายุ 36 ชม. ไม่ผ่าน meconium + ท้องอืด + อาเจียน feculent

Exam: explosive watery stool + flatus on rectal exam (digital examination relief)
Contrast enema: transition zone at sigmoid; dilated proximal + narrow distal
Rectal suction biopsy: aganglionosis in rectum', '[{"label":"A","text":"Observation"},{"label":"B","text":"**Hirschsprung disease (congenital aganglionic megacolon) — staged management**: (1) **Initial**: bowel decompression with rectal stimulation / irrigation (saline irrigation); broad-spectrum antibiotic; NG decompression; (2) **Confirm diagnosis**: rectal suction biopsy gold standard (absence of ganglion cells + hypertrophic nerve trunks + calretinin negative); (3) **Modern approach — single-stage pull-through** in stable infant after decompression: - **Soave** (endorectal pull-through) — preserve muscular cuff - **Swenson** (full-thickness rectosigmoidectomy + coloanal anastomosis) - **Duhamel** (retrorectal pull-through with side-to-side anastomosis) — common, less pelvic dissection - **Transanal endorectal pull-through (TERPT/De La Torre)** — increasingly preferred, no laparotomy in standard-length disease; (4) **Staged approach** for very ill / total colonic Hirschsprung / late presentation: leveling colostomy in ganglionic bowel → pull-through 4-6 mo later → closure of stoma; (5) **Post-op complications**: enterocolitis (Hirschsprung-associated enterocolitis HAEC — life-threatening; treat aggressive antibiotic + irrigation), constipation, soiling, recurrent enterocolitis; (6) **Long-term follow-up** for functional outcomes; (7) **Genetic counseling** — 10-15% have RET mutation (also MEN2); other genes (EDNRB, EDN3); associated syndromes (Down, MEN2A, Waardenburg)"},{"label":"C","text":"Total colectomy + ileostomy without diagnosis"},{"label":"D","text":"Discharge with laxative"},{"label":"E","text":"Endoscopic dilation"}]'::jsonb,
  'B', '**Hirschsprung disease** — congenital absence of ganglion cells (Meissner + Auerbach plexus) in distal bowel → functional obstruction. Etiology: arrest of neural crest migration; genetic (RET, EDNRB, EDN3, GDNF). Associations: Down syndrome (most common — 5-15% Down have Hirschsprung), MEN2A (RET), Waardenburg-Shah. **Clinical**: 90% present in neonate with delayed passage meconium (> 48h), abdominal distention, bilious vomiting; relief with rectal exam (explosive release); failure to thrive; chronic constipation. **Diagnosis**: 1. Contrast enema: transition zone (proximal dilated, distal narrow aganglionic) — operator-dependent in neonates 2. Anorectal manometry: absent rectoanal inhibitory reflex (RAIR) 3. Rectal suction biopsy: absent ganglion cells + hypertrophic nerve trunks + calretinin neg (immunohistochemistry) — gold standard **Length of aganglionosis**: - Short segment (80% — rectosigmoid) - Long segment - Total colonic Hirschsprung (TCHA) - Total intestinal aganglionosis (rare, fatal without transplant) **Surgery options**: pull-through procedures — Swenson, Soave, Duhamel; modern TERPT (transanal endorectal pull-through). Single-stage in stable patients; staged for very ill / very young / long-segment. **HAEC (Hirschsprung-associated enterocolitis)** — serious complication preop or postop; clinical: fever, abdominal distention, foul stool, lethargy → treat: NPO, NG, antibiotic broad (metronidazole + cephalosporin), rectal irrigation aggressive.', NULL,
  'medium', 'pediatrics', 'review',
  'surgery', 'clinical_decision', 'pediatrics', 'peds',
  'APSA Pediatric Surgery Handbook; ARM Hirschsprung Guidelines; Langer JC Semin Pediatr Surg', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ทารกแรกเกิดอายุ 36 ชม. ไม่ผ่าน meconium + ท้องอืด + อาเจียน feculent

Exam: explosive watery stool + flatus on rectal exam (digital examination relief)
Contrast enema: transition zone at sigmoid; dilated proximal + narrow distal
Rectal suction biopsy: aganglionosis in rectum'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 2 ปี มา ED ด้วยอาการบวมที่ขาหนีบขวา 4 ชั่วโมง คลื่นไส้อาเจียน ร้องไห้ ไม่ยอมเดิน

Exam: tender erythematous bulge right inguinal region 3 cm, not reducible, no overlying skin changes severe, mild scrotal swelling
VS stable

คำถาม: management', '[{"label":"A","text":"Observation"},{"label":"B","text":"**Incarcerated pediatric inguinal hernia — urgent management**: (1) **Attempt manual reduction (taxis)** — sedation + analgesia + Trendelenburg + cold compress + gentle constant pressure; success rate > 80% in children; (2) **Successful reduction** → admit + observe 24h + **scheduled elective herniorrhaphy within 24-72h** (delayed re-operation has higher recurrence + complication); (3) **Failed reduction OR signs of strangulation** (peritonitis, sepsis, dark/edematous bulge, severe pain, irreducible after attempts) → **emergent surgical exploration**: high ligation of patent processus vaginalis (no mesh in children); assess viability of bowel / testis (in boys — testicular ischemia possible); resect non-viable bowel + primary anastomosis; (4) **Pediatric hernia repair**: high ligation alone (Marcy) — no mesh; very low recurrence (< 1-2%); laparoscopic increasingly utilized — allows contralateral inspection (5-10% have contralateral patent processus vaginalis); (5) **Postop**: monitor for testicular issues, recurrence, wound; (6) **Differentiate from communicating hydrocele**: transilluminates, reducible into peritoneum, often spontaneous resolution if simple; surgery for persistent > 12-24 mo"},{"label":"C","text":"Outpatient referral 3 months"},{"label":"D","text":"Antibiotic only"},{"label":"E","text":"Discharge home, follow up 1 week"}]'::jsonb,
  'B', '**Pediatric inguinal hernia** — most common pediatric surgery. Always indirect (patent processus vaginalis). Higher rate of incarceration in pediatric (5-20%) than adult, especially < 1 yr. **Boys** > girls (6-10:1), preterm > term (higher patent processus vaginalis). **Bilateral** — ~10% (more in preterm, family history). **Acute incarcerated hernia**: 1. Attempt taxis with sedation + analgesia + position (Trendelenburg) — success > 80% in pediatric 2. Successful → elective repair within 24-72h (don''t discharge — recurrence + complication risk) 3. Failed / strangulation → emergent surgery **Repair principles** (pediatric): - High ligation of hernia sac (patent processus vaginalis) — Marcy procedure - NO MESH (growing patient) - Open or laparoscopic — both acceptable; laparoscopic allows contralateral evaluation **Contralateral exploration**: controversial — laparoscopy allows easy inspection; if patent processus vaginalis on other side → repair concurrently (5-30% bilateral patent on lap evaluation). **Complications**: testicular atrophy / ischemia (10-20% incarcerated), recurrence (1-2%), wound infection. **Hydrocele** vs hernia in child: communicating hydrocele (patent processus vaginalis, fluid varies) — observe until 12-24 mo; if persistent → repair (same as hernia). Non-communicating — observe (resolves spontaneously).', NULL,
  'easy', 'pediatrics', 'review',
  'surgery', 'clinical_decision', 'pediatrics', 'peds',
  'APSA Pediatric Surgery Handbook; Nazem M et al. Pediatr Surg Int; ACS Pediatric Hernia Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'เด็กชายอายุ 2 ปี มา ED ด้วยอาการบวมที่ขาหนีบขวา 4 ชั่วโมง คลื่นไส้อาเจียน ร้องไห้ ไม่ยอมเดิน

Exam: tender erythematous bulge right inguinal region 3 cm, not reducible, no overlying skin changes severe, mild scrotal swelling
VS stable

คำถาม: management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 5 ปี มาด้วย neck mass anterior midline midway hyoid bone โต 1 ปี ไม่เจ็บ; เคลื่อนขึ้นลงเวลากลืน + protrude tongue

FNA: cyst with thyroid-like epithelium; no malignancy
US: cystic mass 2 cm anterior midline, separate from thyroid (normal thyroid orthotopic)

คำถาม: management', '[{"label":"A","text":"Observation indefinitely"},{"label":"B","text":"**Thyroglossal duct cyst (TGDC) — surgical excision (Sistrunk procedure)**: (1) **Confirm orthotopic thyroid present** — pre-op US thyroid to ensure not ''ectopic thyroid'' (rare — would result in iatrogenic hypothyroidism if excised); (2) **Sistrunk procedure**: excise cyst + middle portion of hyoid bone + tract to foramen cecum at tongue base — reduces recurrence from ~50% (simple excision) to ~5% (Sistrunk); developed by Sistrunk 1920; (3) **Pre-op**: thyroid function (TSH, free T4); imaging (US adequate; CT/MRI for atypical); FNA if suspicious or atypical features; (4) **Risk of carcinoma in TGDC** ~1% (papillary thyroid carcinoma most common type within TGDC); recommendations: total thyroidectomy + RAI if positive — controversial vs local Sistrunk alone with surveillance; refer to thyroid surgery if found; (5) **Differential**: thyroglossal duct cyst, ectopic thyroid, branchial cleft cyst (lateral), dermoid cyst, lymph node, lipoma; (6) Postop: surveillance for recurrence + wound"},{"label":"C","text":"Aspiration only"},{"label":"D","text":"Total thyroidectomy"},{"label":"E","text":"Radioactive iodine therapy"}]'::jsonb,
  'B', '**Thyroglossal duct cyst (TGDC)** — most common congenital neck mass in children. Embryology: thyroid descends from foramen cecum at tongue base through hyoid bone to anterior neck; thyroglossal duct usually obliterates but may persist as cyst. **Clinical**: midline neck mass, anterior to hyoid bone (75%) or below; elevates with swallowing + tongue protrusion (anatomical attachment to hyoid); may become infected. **Diagnosis**: clinical + US (confirm cystic + identify orthotopic thyroid — critical before excision; ectopic thyroid in TGDC location = avoid resection, would cause hypothyroidism). **Sistrunk procedure**: excise cyst + central hyoid (1-2 cm) + tract to foramen cecum (tongue base) — historic + still gold standard. Recurrence with simple excision ~ 50%, Sistrunk ~ 5%. **Carcinoma in TGDC**: ~1% — papillary thyroid carcinoma most common (~75-80% of TGDC cancers); follicular, mixed; treat: Sistrunk + total thyroidectomy ± neck dissection ± RAI for high-risk features (controversy — some advocate Sistrunk alone + surveillance for small intracystic PTC). **Branchial cleft anomalies** (differential): 2nd most common, lateral neck (along SCM); 1st (preauricular, periotic), 2nd (most common, along SCM), 3rd (lower lateral), 4th (rare); excise complete tract.', NULL,
  'easy', 'pediatrics', 'review',
  'surgery', 'clinical_decision', 'pediatrics', 'peds',
  'APSA Pediatric Surgery Handbook; Carter Y et al. Operative Tech Otolaryngol; Plaza CP et al. Otolaryngol Clin North Am', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'เด็กหญิงอายุ 5 ปี มาด้วย neck mass anterior midline midway hyoid bone โต 1 ปี ไม่เจ็บ; เคลื่อนขึ้นลงเวลากลืน + protrude tongue

FNA: cyst with thyroid-like epithelium; no malignancy
US: cystic mass 2 cm anterior midline, separate from thyroid (normal thyroid orthotopic)

คำถาม: management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 42 ปี post-laparoscopic Nissen fundoplication 3 วันก่อน complaining of new-onset persistent dysphagia ทุกครั้งที่ดื่มน้ำ + ไม่สามารถเรอได้ + gas bloat

คำถาม: pathophysiology + management', '[{"label":"A","text":"Normal post-op finding, ignore"},{"label":"B","text":"**Post-Nissen fundoplication complications**: (1) **Dysphagia** — common transient (50% first 2-4 weeks) due to: edema at wrap, wrap too tight, wrap herniation, slipped wrap; (2) **Gas bloat syndrome** — inability to belch due to competent valve mechanism; common; usually improves over time; (3) **Pathophysiology of fundoplication**: 360° wrap around lower esophagus (Nissen) creates one-way valve preventing reflux but may restrict belching/vomiting; (4) **Investigations**: contrast esophagram (rule out slipped wrap, paraesophageal recurrence), EGD (visualize wrap, exclude obstruction), high-resolution manometry, pH study; (5) **Management**: - Conservative: dietary modification (small bites, chewing well, soft texture, no carbonation), pro-motility, time (resolves 4-8 wk typically) - Endoscopic dilation if persistent moderate (3-6 mo post-op) - Re-do surgery if persistent severe + anatomical issue (slipped, twisted, too tight) — convert Nissen to partial (Toupet 270° posterior, Dor 180° anterior) - Partial wraps (Toupet/Dor) have lower dysphagia but slightly higher reflux long-term; (6) **Selection**: severe dysmotility on manometry pre-op → consider partial wrap to begin with; (7) Patient counseling — most resolves"},{"label":"C","text":"Total gastrectomy"},{"label":"D","text":"PPI lifelong only"},{"label":"E","text":"No follow-up needed"}]'::jsonb,
  'B', '**Anti-reflux surgery (fundoplication)**: surgical treatment of GERD refractory / complicated. Options: - Nissen (360° complete wrap) — most reflux control, highest dysphagia - Toupet (270° posterior partial) — less dysphagia, reasonable reflux control - Dor (180° anterior partial) — used with Heller myotomy for achalasia, less reflux control - LINX (magnetic sphincter augmentation) — newer, restorative **Principles**: 1. Complete hiatal dissection 2. Crural repair (close hiatus) 3. Adequate intra-abdominal esophageal length (3-5 cm) 4. Wrap construction over bougie 5. Short floppy wrap (Donahue technique) **Complications**: - Dysphagia (transient 50%, persistent 5-10%) - Gas bloat — inability to belch - Slipped wrap (Nissen → migration above diaphragm) - Twisted wrap — anatomic distortion - Wrap dehiscence - Recurrent reflux **Pre-op evaluation essential**: EGD + manometry + pH study + esophagram to exclude motility disorder (achalasia, scleroderma) which contraindicates Nissen → use partial. **GERD surgical indication**: refractory medical therapy (PPI failure), complications (Barrett''s, stricture, recurrent aspiration), patient preference, large hiatal hernia, esophagitis with PPI tolerance issues. LOTUS trial — long-term PPI vs Nissen similar outcomes.', NULL,
  'medium', 'gi', 'review',
  'surgery', 'basic_science', 'gi', 'adult',
  'SAGES Anti-Reflux Surgery Guidelines; Stefanidis D et al. Surg Endosc; Lundell L et al. Lancet GH (LOTUS)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 42 ปี post-laparoscopic Nissen fundoplication 3 วันก่อน complaining of new-onset persistent dysphagia ทุกครั้งที่ดื่มน้ำ + ไม่สามารถเรอได้ + gas bloat

คำถาม: pathophysiology + management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี ได้รับการเตรียมการผ่าตัด elective colorectal surgery มา clinic ขอ pre-op evaluation

Underlying: HT, DM type 2 (HbA1c 8.2), CKD stage 3 (eGFR 40), prior MI 2 ปีก่อน on aspirin + clopidogrel + statin + beta-blocker; functional capacity 4 METs (walks 2 blocks)

คำถาม: pre-operative cardiac evaluation', '[{"label":"A","text":"Cancel surgery indefinitely"},{"label":"B","text":"**Perioperative cardiac risk assessment + optimization**: (1) **Calculate cardiac risk** — RCRI (Revised Cardiac Risk Index — Lee): high-risk surgery, ischemic heart disease, HF, CVA, insulin-dependent DM, Cr > 2.0 — this patient: yes IHD, possible DM (insulin?), Cr (eGFR 40) → 2-3 points = intermediate to high (1-2% MACE) OR NSQIP MICA calculator; (2) **Functional capacity assessment** — METs > 4 = good; < 4 = poor (cannot climb 2 flights) — this patient marginal; (3) **Step-wise approach (ACC/AHA + ESC guidelines)**: - Emergent → proceed - Active cardiac condition (unstable angina, decompensated HF, severe valve dz, arrhythmia) → defer + treat - Low risk surgery + good MET → proceed - Intermediate-high risk + poor MET → consider non-invasive testing (stress test, echo) if results would change management; (4) **Investigations** consider: ECG, echo (LV function), stress test if poor MET + high-risk surgery; coronary angiography only if would change management (PCI before non-cardiac surgery NOT routinely indicated — DECREASE-V, CARP trials show no benefit of prophylactic revascularization); (5) **Medical optimization**: continue beta-blocker (if on chronic — DO NOT initiate new on day of surgery per POISE trial — increased stroke + death), statin continue, ACE-I hold on day of surgery (hypotension), antiplatelet management (aspirin continue per POISE-2 except for high bleed surgery; DAPT — delay surgery for elective until 6-12 months post-DES or 30 days BMS; bridging not routinely needed), DM control (sliding scale + adjusted long-acting; HbA1c < 8 ideal), CKD optimize, anemia treat (iron + EPO if needed); (6) **Counsel** + multidisciplinary; (7) Post-op: troponin surveillance in high-risk (MINS — myocardial injury after noncardiac surgery — associated with mortality)"},{"label":"C","text":"Coronary angiography before all surgery"},{"label":"D","text":"Start beta-blocker day of surgery"},{"label":"E","text":"Stop all medications 2 weeks before"}]'::jsonb,
  'B', '**Perioperative cardiac risk assessment**: 1. RCRI (Lee): 6 factors — high-risk surgery (intraperitoneal, intrathoracic, suprainguinal vascular), ischemic heart disease, HF, CVA/TIA, insulin-dependent DM, preop Cr > 2.0 — 0 pts <1%, 1: 1%, 2: 2.4%, ≥3: >5% MACE 2. NSQIP MICA calculator — more individualized 3. Functional capacity (METs) — 4 METs = climb 2 flights, walk uphill briskly **Stepwise approach (ACC/AHA 2014, ESC 2022)**: - Emergent → proceed with optimal medical management - Active condition → defer + treat - Risk + functional capacity → testing only if would change management **Medical management evidence**: - Beta-blocker: continue if chronic; DO NOT initiate same day (POISE trial — death + stroke up) - Statin: continue / initiate beneficial - Aspirin: continue except if high-risk bleed (POISE-2) - ACE-I/ARB: hold day of surgery (hypotension) - Antiplatelet for stent: 30 days BMS, 6-12 mo DES delay elective; bridging not routinely needed - DM: hold sulfonylureas + meglitinides; metformin OK day before per CKD/contrast; insulin adjust - Anticoagulation: bridge per stratified risk (BRIDGE trial — most non-mechanical valve AF don''t need bridging) **Prophylactic revascularization** for asymptomatic CAD pre-op = NOT beneficial (CARP, DECREASE-V) **MINS** — myocardial injury after noncardiac surgery — troponin elevation alone (without symptoms) — high mortality; consider surveillance in high-risk.', NULL,
  'medium', 'cardiovascular', 'review',
  'surgery', 'basic_science', 'cardiovascular', 'adult',
  'ACC/AHA Perioperative Guidelines 2014; ESC Non-Cardiac Surgery Guidelines 2022; Devereaux PJ et al. JAMA (POISE-2)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี ได้รับการเตรียมการผ่าตัด elective colorectal surgery มา clinic ขอ pre-op evaluation

Underlying: HT, DM type 2 (HbA1c 8.2), CKD stage 3 (eGFR 40), prior MI 2 ปีก่อน on aspirin + clopidogrel + statin + beta-blocker; functional capacity 4 METs (walks 2 blocks)

คำถาม: pre-operative cardiac evaluation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทีม EMS วิทยุแจ้ง trauma center ว่า กำลังนำส่งผู้ป่วย MVC ระดับ red ที่ป่าจังหวัด ETA 20 min; multiple casualties 4 ราย ระดับความรุนแรงต่างกัน — ผู้ป่วย 1: GCS 8, hypotensive (red); ผู้ป่วย 2: GCS 15, ขาหัก (yellow); ผู้ป่วย 3: GCS 14, abdominal pain (yellow); ผู้ป่วย 4: walking wounded (green)

คำถาม: trauma team activation protocol + triage system', '[{"label":"A","text":"Treat in order of arrival"},{"label":"B","text":"**Mass Casualty Incident (MCI) triage + trauma activation**: (1) **Pre-arrival**: full trauma team activation for red patient — surgeon, anesthesia, ER physician, OR availability, blood bank notified MTP, IR/CT availability; (2) **Triage system (START / Simple Triage and Rapid Treatment)** or SALT (Sort-Assess-Lifesaving-Treatment-Transport): - **Red (Immediate / T1)**: life-threatening, salvageable with immediate intervention (e.g., airway, breathing, circulation compromise) - **Yellow (Delayed / T2)**: serious but stable, can wait 30-60 min - **Green (Minor / T3)**: walking wounded, minimal injury - **Black (Expectant)**: dead or non-salvageable; (3) **JumpSTART** for pediatric (< 8 yr); (4) **Resource allocation**: red patients get immediate trauma bay + team; yellow next; green to alternative area; (5) **Activation criteria** (universal trauma criteria): physiologic (SBP < 90, GCS < 13, RR < 10 or > 29), anatomic (penetrating head/neck/torso/extremity proximal, flail chest, > 2 long bone fractures, paralysis, amputation), mechanism (high-velocity MVC, falls > 3 m, ejection, extrication > 20 min); (6) **MCI command**: incident command system (ICS), unified command if multi-agency, communication coordinator; (7) **Tertiary survey** after primary stabilization to detect missed injuries; (8) **Documentation, family notification, mental health support, debrief**"},{"label":"C","text":"Send all to ICU regardless"},{"label":"D","text":"Discharge green patients home immediately without exam"},{"label":"E","text":"Operate on all 4 patients simultaneously"}]'::jsonb,
  'B', '**Mass Casualty Incident (MCI) management** — system-level coordination required. **Triage systems**: 1. **START** (Simple Triage and Rapid Treatment) — adults, 30-second assessment: walking (green), respirations (rate, present/absent → red/black), perfusion (radial pulse, cap refill), mental status (commands) 2. **JumpSTART** — pediatric (< 8 yr or weight) — modifications for respiratory: 5 rescue breaths before declaring black 3. **SALT** (Sort-Assess-Lifesaving-Treatment-Transport) — global sorting → individual assessment → lifesaving interventions (airway, hemorrhage, decompression) → triage category → transport **Triage categories**: - **Red / Immediate / T1**: life-threatening salvageable - **Yellow / Delayed / T2**: serious, stable - **Green / Minor / T3**: minor injuries, ambulatory - **Black / Expectant**: dead or non-salvageable in available resources **Trauma team activation criteria** (Tier 1 — full activation): - Physiologic: SBP < 90, GCS ≤ 8 (or motor < 6), RR < 10 or > 29, need airway - Anatomic: penetrating to head/neck/torso, flail chest, > 2 long bone fractures, amputation proximal wrist/ankle, paralysis, crushed mangled extremity, pelvic fracture - Mechanism: high-velocity MVC, ejection, > 20 min extrication, fall > 6 m **Incident Command System (ICS)** — unified command structure; communication; logistics; safety; finance. **Resource management** — when overwhelmed, shift paradigm: ''greatest good for greatest number'' (vs individual patient focus).', NULL,
  'medium', 'trauma', 'review',
  'surgery', 'ems_mgmt', 'trauma', 'adult',
  'ACS Resources for Optimal Care of the Injured Patient (Orange Book); SALT Triage; START Triage; ATLS 10th Ed', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ทีม EMS วิทยุแจ้ง trauma center ว่า กำลังนำส่งผู้ป่วย MVC ระดับ red ที่ป่าจังหวัด ETA 20 min; multiple casualties 4 ราย ระดับความรุนแรงต่างกัน — ผู้ป่วย 1: GCS 8, hypotensive (red); ผู้ป่วย 2: GCS 15, ขาหัก (yellow); ผู้ป่วย 3: GCS 14, abdominal pain (yellow); ผู้ป่วย 4: walking wounded (green)

คำถาม: trauma team activation protocol + triage system'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 70 ปี ผ่า total gastrectomy + D2 dissection for advanced gastric cancer 18 เดือนก่อน + adjuvant chemotherapy completed

Now มาด้วยอาการ severe fatigue + weight loss + diarrhea + leg edema + paresthesia + difficulty walking + recurrent infection

Lab: Hb 8.4 (microcytic + macrocytic mixed), albumin 2.6, B12 80 (low), folate 3 (low), iron 18, ferritin low, vit D low, Ca low, Mg low, Zn low
MRI brain: subcortical demyelination consistent with subacute combined degeneration
No recurrence on imaging

คำถาม: integrative survivorship management', '[{"label":"A","text":"Restart chemotherapy"},{"label":"B","text":"**Post-gastrectomy nutritional deficiency syndrome + cancer survivorship — integrative multimodal care**: (1) **Diagnose specific deficiencies + replete**: - B12: parenteral 1000 mcg IM (loading: weekly × 4, then monthly lifelong) — oral cannot absorb without intrinsic factor (loss with total gastrectomy) - Iron: IV iron (gastrectomy impairs absorption); avoid oral if malabsorption - Folate: oral 1-5 mg daily - Vit D + Ca: high dose oral 50,000 IU/wk + Ca 1,500 mg/day - Mg, Zn: oral repletion; monitor - Vit ADEK: empiric supplementation; (2) **Nutritional optimization**: dietician, small frequent high-protein high-calorie meals, enzyme support if needed; address dumping syndrome (small meals, low carb); (3) **Subacute combined degeneration** treatment — B12 repletion early; neurological recovery may be incomplete if delayed; (4) **Long-term surveillance for recurrence**: clinical, CT chest/abd q6 mo × 2 yr then annual × 5 yr, EGD periodically; CA 19-9 if elevated initially; (5) **Bone health**: DEXA, treatment of osteoporosis (bisphosphonate if T-score ≤ -2.5 or fragility fracture); (6) **Functional rehabilitation**: PT, OT, neuropathy management; (7) **Psychological support**: cancer survivorship clinic, peer support, mental health; (8) **Lifestyle**: exercise as tolerated, smoking cessation, moderate alcohol, vaccination (pneumococcal, influenza, COVID); (9) **Survivorship care plan** — written summary of treatment received + future surveillance + risk factors + lifestyle + contacts; (10) **Multidisciplinary**: oncology, surgery, nutrition, psychology, physical therapy, primary care"},{"label":"C","text":"TPN lifelong"},{"label":"D","text":"Observation only"},{"label":"E","text":"Antibiotic prophylaxis"}]'::jsonb,
  'B', '**Post-gastrectomy nutritional consequences** — chronic, lifelong. Deficiencies: - B12 — total gastrectomy eliminates intrinsic factor production → no B12 absorption → require parenteral lifelong - Iron — gastric acid + duodenal absorption impaired → IV iron or aggressive oral - Folate — variable; oral repletion - Vit D + Ca — duodenal absorption; oral supplementation - Fat-soluble vitamins (ADEK) — fat malabsorption with dumping/rapid transit - Mg, Zn, Cu — variable - Protein — low intake + malabsorption → weight loss, sarcopenia **Dumping syndrome** — early + late (see prior question) **Subacute combined degeneration**: B12 deficiency → dorsal column + lateral corticospinal tract demyelination → paresthesia, ataxia, weakness, cognitive impairment. Treat with B12 — neurological recovery may be incomplete if delayed > months. **Cancer survivorship**: surveillance for recurrence, second primary cancer, late effects of treatment (chemo neuropathy, cardiotoxicity, secondary malignancy from RT), physical fitness, psychological, lifestyle modification, vaccination, family genetic risk assessment. **Survivorship care plan** (IOM recommendation): written summary of treatment, surveillance schedule, late effects, lifestyle, contact information for transitioning care. Multidisciplinary survivorship clinics — integrate medical, nutritional, psychological, social, financial, vocational, sexual health.', NULL,
  'hard', 'hemato_onco', 'review',
  'surgery', 'integrative', 'hemato_onco', 'adult',
  'ASCO Survivorship Care Planning; NCCN Survivorship; Davis JL et al. J Surg Oncol; Carpentieri J et al. J Gastrointest Surg', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 70 ปี ผ่า total gastrectomy + D2 dissection for advanced gastric cancer 18 เดือนก่อน + adjuvant chemotherapy completed

Now มาด้วยอาการ severe fatigue + weight loss + diarrhea + leg edema + paresthesia + difficulty walking + recurrent infection

Lab: Hb 8.4 (microcytic + macrocytic mixed), albumin 2.6, B12 80 (low), folate 3 (low), iron 18, ferritin low, vit D low, Ca low, Mg low, Zn low
MRI brain: subcortical demyelination consistent with subacute combined degeneration
No recurrence on imaging

คำถาม: integrative survivorship management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 78 ปี smoker, HT, DM มา routine clinic วันนี้สังเกตเห็น pulsatile abdominal mass บริเวณ epigastrium

VS: BP 142/86, HR 76, asymptomatic
US abdomen screening: infrarenal AAA 5.8 cm diameter, no signs of impending rupture
CT angiography: 5.8 cm fusiform AAA, neck 18 mm length good, iliac access acceptable, no thrombus

คำถาม: management', '[{"label":"A","text":"Observation + repeat US 6 months"},{"label":"B","text":"**Elective AAA repair indicated (≥ 5.5 cm men, ≥ 5.0 cm women, OR rapid growth > 0.5 cm/6 mo, OR symptomatic)**: (1) **Pre-op evaluation**: cardiac risk (RCRI, stress test if poor MET — vascular = high-risk surgery), pulmonary, renal, optimize comorbidities + medications (statin, antiplatelet, BP control, smoking cessation absolute); (2) **EVAR (Endovascular Aneurysm Repair) — preferred first if anatomy suitable**: - Lower 30-day mortality (1.6% vs 4.7% open per EVAR-1, DREAM trials) - Less invasive, shorter LOS, faster recovery - Anatomic criteria: proximal neck ≥ 10-15 mm length, angulation < 60°, diameter < 32 mm; iliac access; (3) **Open repair alternative**: - Younger / longer life expectancy (durability advantage long-term) - Unsuitable anatomy for EVAR - Connective tissue disease (Marfan, EDS) - Surgeon/patient preference; (4) **Long-term EVAR surveillance**: CT at 1 mo + annually for endoleak (type I-V), sac size, migration; secondary intervention rate 10-20%; (5) **Open long-term**: less surveillance needed; (6) **Continued medical**: statin, antiplatelet, BP control lifelong + smoking cessation; (7) **Family screening** — first-degree relatives ≥ 60 OR younger if early-onset family history"},{"label":"C","text":"Beta-blocker only"},{"label":"D","text":"Endovascular thrombolysis"},{"label":"E","text":"No treatment needed"}]'::jsonb,
  'B', '**AAA — Abdominal Aortic Aneurysm**. Definition: ≥ 3 cm infrarenal aortic diameter. **Screening (USPSTF)**: one-time abdominal US in men 65-75 with smoking history. **Rupture risk by size**: < 4 cm: < 0.5%/yr; 4-5: 0.5-5%/yr; 5-6: 3-15%/yr; > 6 cm: 15-40%/yr. **Elective repair indications**: - ≥ 5.5 cm men, ≥ 5.0 cm women (lower threshold — higher rupture rate per size) - Rapid growth > 0.5 cm/6 mo or > 1 cm/yr - Symptomatic (pain, embolic, large) regardless of size - Inflammatory or mycotic — earlier repair **EVAR vs Open**: - EVAR-1 (Lancet 2005, 2016): EVAR lower perioperative mortality + early benefit but at 8 yrs equivalence then open better long-term (graft failure, secondary intervention) - DREAM (NEJM 2005, 2010): similar findings - OVER (NEJM 2012): no late benefit of open in 7 years - Modern era: EVAR ~ 70-80% of elective repairs **EVAR limitations**: anatomic criteria (proximal neck, iliac access, tortuosity); endoleak (type I-V); sac enlargement; need for lifelong surveillance + reintervention. **Open**: durable, no endoleak; higher perioperative morbidity. **Medical management of AAA**: statin, BP control (especially β-blocker — limited evidence for growth retardation), smoking cessation, exercise, diet. Surveillance for sub-threshold AAA: 3-3.9 cm q2-3 yr, 4-4.9 cm q6-12 mo, 5-5.4 cm q6 mo. A ผิด — meets criteria. C D ผิด — definitive repair needed. E ผิด.', NULL,
  'easy', 'vascular', 'review',
  'surgery', 'clinical_decision', 'vascular', 'adult',
  'SVS AAA Practice Guidelines 2018; ESVS AAA 2024; Greenhalgh RM et al. NEJM 2010 (EVAR-1); Schermerhorn ML et al. NEJM', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 78 ปี smoker, HT, DM มา routine clinic วันนี้สังเกตเห็น pulsatile abdominal mass บริเวณ epigastrium

VS: BP 142/86, HR 76, asymptomatic
US abdomen screening: infrarenal AAA 5.8 cm diameter, no signs of impending rupture
CT angiography: 5.8 cm fusiform AAA, neck 18 mm length good, iliac access acceptable, no thrombus

คำถาม: management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 65 ปี HT, smoker มาด้วยอาการ unilateral severe limb pain + paresthesia + pallor + pulselessness 4 ชั่วโมง ของขาขวา + power 3/5

VS: BP 158/92, HR 92 (regular sinus), Temp 36.8°C
Leg: cold, pale right foot, no distal pulse, motor weakness, sensation reduced
ABI: not measurable
Doppler: no signal popliteal + distal
CT angiography: acute thrombotic occlusion right SFA + popliteal (likely on chronic atherosclerosis); other limb patent', '[{"label":"A","text":"Observation 24 hr"},{"label":"B","text":"**Acute Limb Ischemia (ALI) — Rutherford IIB (immediately threatened, motor + sensory deficit)** — emergent intervention: (1) **Immediate anticoagulation** with IV heparin bolus + infusion (target aPTT 1.5-2.5 control); (2) **Etiology determination**: embolic (cardiac — AF, MI, valve; aneurysm; tumor) vs thrombotic (atherosclerotic, hypercoagulable, dissection, popliteal aneurysm thrombosis); this patient: thrombotic on atherosclerosis; (3) **Intervention timing**: Rutherford IIB (immediately threatened) requires intervention within hours (6-8h ideal — beyond → tissue death + reperfusion injury); (4) **Treatment options**: - **Surgical thromboembolectomy** (Fogarty catheter) — for embolic ALI; quicker hemostasis - **Endovascular catheter-directed thrombolysis (tPA, urokinase, alteplase)** + thrombectomy — for thrombotic ALI; 12-24h infusion; STILE, TOPAS trials support endovascular as comparable to surgery for limb salvage in selected; - **Hybrid procedure** (endo + open) — common in modern practice - **Bypass surgery** for chronic atherosclerotic occlusion with non-restorable in-situ flow; (5) **Compartment syndrome surveillance** post-revascularization — measure compartment pressures; fasciotomy if pressures elevated + symptoms or prolonged ischemia (> 4-6h); (6) **Reperfusion syndrome**: hyperkalemia (release K), acidosis, myoglobinuria → RHABDOMYOLYSIS — IV fluid, urinary alkalinization, monitor K, AKI prevention; (7) **Address underlying cause** — workup for source: ECG (AF), echo (thrombus, valve), screen for hypercoagulability; antiplatelet + statin lifelong + smoking cessation; (8) Rehab, secondary prevention"},{"label":"C","text":"Primary amputation"},{"label":"D","text":"Aspirin only"},{"label":"E","text":"Discharge home with follow-up"}]'::jsonb,
  'B', '**Acute Limb Ischemia (ALI)** — sudden decrease in limb perfusion threatening viability. **6 Ps**: pain, pallor, pulselessness, paresthesia, paralysis, poikilothermia (cold). **Rutherford Classification**: - **I — viable**: not immediately threatened, no sensory/motor deficit; audible arterial Doppler - **IIA — marginally threatened**: mild sensory loss only, salvageable with prompt treatment; audible venous Doppler, inaudible arterial - **IIB — immediately threatened**: sensory + mild motor; salvageable with immediate intervention - **III — non-viable**: profound anesthesia + paralysis, irreversible damage; primary amputation **Etiology**: - Embolic (30%) — cardiac (AF 80%, MI, valve), proximal aneurysm, paradoxical, tumor - Thrombotic (40-50%) — atherosclerotic plaque rupture, bypass graft, popliteal aneurysm - Other: dissection, trauma, vasospasm, hypercoagulable **Management**: 1. Immediate IV heparin 2. Rutherford I/IIA — workup + planned intervention 3. Rutherford IIB — emergent intervention within 6h 4. Rutherford III — primary amputation (limb non-salvageable + reperfusion would cause systemic toxicity) **Intervention**: - Embolic → Fogarty thromboembolectomy (open) - Thrombotic → catheter-directed thrombolysis ± aspiration thrombectomy ± stent/bypass - Hybrid common **Reperfusion injury**: hyperkalemia, acidosis, myoglobinuria, AKI, compartment syndrome — anticipate, monitor, treat. Fasciotomy if compartment pressures elevated. Rhabdomyolysis: IV fluid 1-2 L/h initially, alkalinize urine (pH > 6.5), monitor K. A ผิด — Rutherford IIB ฉุกเฉิน. C ผิด — limb still salvageable. D ผิดอย่างยิ่ง. E ผิด.', NULL,
  'medium', 'vascular', 'review',
  'surgery', 'clinical_decision', 'vascular', 'adult',
  'ACC/AHA/SVS PAD Guidelines 2016; ESVS Acute Limb Ischemia 2020; Norgren L et al. TASC II; Ouriel K et al. NEJM (TOPAS)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 65 ปี HT, smoker มาด้วยอาการ unilateral severe limb pain + paresthesia + pallor + pulselessness 4 ชั่วโมง ของขาขวา + power 3/5

VS: BP 158/92, HR 92 (regular sinus), Temp 36.8°C
Leg: cold, pale right foot, no distal pulse, motor weakness, sensation reduced
ABI: not measurable
Doppler: no signal popliteal + distal
CT angiography: acute thrombotic occlusion right SFA + popliteal (likely on chronic atherosclerosis); other limb patent'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 35 ปี G3P2 in third trimester (36 weeks) มาด้วยอาการ unilateral leg swelling + pain 2 วัน + low-grade fever

VS stable
Leg: left calf swollen 4 cm > right, tender, Homan''s positive
D-dimer 6,800 (elevated, expected in pregnancy)
US Doppler: extensive DVT left iliofemoral + femoropopliteal

คำถาม: management', '[{"label":"A","text":"Warfarin start immediately"},{"label":"B","text":"**Acute proximal DVT in pregnancy — LMWH (pregnancy-safe anticoagulation)**: (1) **LMWH first-line** in pregnancy — enoxaparin 1 mg/kg SC q12h OR dalteparin — does not cross placenta, safe; (2) **Avoid**: warfarin (teratogen — embryopathy 1st trimester, fetal hemorrhage 3rd trimester), DOACs (limited safety data, cross placenta — avoid in pregnancy + breastfeeding), aspirin alone (insufficient); (3) **UFH alternative**: bridging if delivery imminent or invasive procedure planned (shorter half-life, reversible); (4) **Compression stockings** + ambulation as tolerated; (5) **Delivery planning** — multidisciplinary OB + hematology + anesthesia: - Discontinue LMWH 24h before scheduled induction / cesarean to allow neuraxial anesthesia (24h for therapeutic dose) - UFH bridging in interim if high VTE risk - Restart anticoagulation 12-24h post-delivery (4-6h post-neuraxial); (6) **Continue postpartum** total at least 6 weeks postpartum + total ≥ 3 months from DVT onset; (7) **Breastfeeding safe** with warfarin + LMWH (not DOACs); transition to warfarin or continue LMWH; (8) **IVC filter** only if contraindication to anticoagulation or recurrent VTE despite adequate anticoagulation; (9) **Future pregnancies** — prophylaxis with LMWH; (10) **Thrombophilia workup** post-pregnancy (factor V Leiden, prothrombin, protein C/S, antiphospholipid — clinical decision)"},{"label":"C","text":"DOAC (apixaban) immediately"},{"label":"D","text":"Aspirin only"},{"label":"E","text":"No treatment"}]'::jsonb,
  'B', '**VTE in pregnancy** — leading cause of maternal mortality in developed countries. Pregnancy = hypercoagulable state (factors VII, VIII, X, fibrinogen increase; protein S decrease; stasis from uterine compression). **Anticoagulation choice in pregnancy**: - **LMWH** — first-line, safe; doesn''t cross placenta; weight-based dosing - **UFH** — alternative, shorter half-life (useful pre-delivery, severe renal impairment); risk: HIT, osteoporosis with long-term use - **Warfarin** — TERATOGENIC (warfarin embryopathy: nasal hypoplasia, stippled epiphyses, CNS abnormality especially 6-12 wk gestation; fetal hemorrhage late pregnancy); SAFE postpartum + breastfeeding; mechanical valves may use cautiously - **DOAC (apixaban, rivaroxaban, dabigatran, edoxaban)** — avoid pregnancy + breastfeeding; cross placenta, limited safety data **Delivery planning**: - Discontinue therapeutic LMWH 24h before scheduled delivery (neuraxial anesthesia safety) - Resume LMWH 12-24h after vaginal delivery, 24-48h after cesarean - Convert to UFH near term for shorter washout flexibility - Bridge to warfarin postpartum if long-term needed **Duration**: minimum 3 months total + at least 6 weeks postpartum **Compression stockings** — adjunct, especially post-thrombotic syndrome prevention. **Thrombolysis** — only for life-threatening (massive PE with shock); pregnancy-specific risks (placental abruption, hemorrhage). **Surgical thrombectomy** — selected. **IVC filter** — only for true anticoagulation contraindication. **Prevention** in subsequent pregnancies — prophylactic LMWH if history VTE.', NULL,
  'medium', 'vascular', 'review',
  'surgery', 'clinical_decision', 'vascular', 'adult',
  'ACOG Practice Bulletin VTE in Pregnancy; ASH Pregnancy VTE Guidelines; CHEST Antithrombotic Therapy 2021', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 35 ปี G3P2 in third trimester (36 weeks) มาด้วยอาการ unilateral leg swelling + pain 2 วัน + low-grade fever

VS stable
Leg: left calf swollen 4 cm > right, tender, Homan''s positive
D-dimer 6,800 (elevated, expected in pregnancy)
US Doppler: extensive DVT left iliofemoral + femoropopliteal

คำถาม: management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 68 ปี smoker ผ่าน CT incidental พบ lung nodule 1.8 cm RUL + 2 enlarged mediastinal lymph nodes + brain MRI: 1 lesion 1 cm frontal; PET: SUV 8 primary, SUV 4 mediastinum, brain enhanced

Bronchoscopy + biopsy: adenocarcinoma
Mutations: EGFR exon 19 deletion positive
PS 1
No other metastases

Clinical T1c N2 M1b (single brain met) Stage IVA', '[{"label":"A","text":"Pneumonectomy"},{"label":"B","text":"**Stage IVA NSCLC adenocarcinoma EGFR-positive with oligometastatic brain disease — multidisciplinary curative-intent approach**: (1) **Multidisciplinary tumor board**: thoracic surgery, neurosurgery, radiation oncology, medical oncology; (2) **Systemic targeted therapy first-line** — **osimertinib** (3rd-generation EGFR TKI) — preferred per FLAURA trial (OS benefit vs 1st-gen TKI) + CNS penetration (treats brain mets in many); (3) **Brain metastasis management**: - Stereotactic radiosurgery (SRS) for 1-3 brain mets (preferred over WBRT — better cognitive preservation per N107C, NRG-CC003 trials) - Surgical resection for solitary larger met (> 3 cm, symptomatic, or for diagnosis); single brain met + controlled systemic = surgery + SRS to cavity reasonable - WBRT reserved for diffuse mets or salvage; (4) **Primary tumor + mediastinal** in oligometastatic setting — selected cases: - SBRT to primary if not surgical candidate - Surgical resection in highly selected (OMD — oligometastatic disease, well-controlled extracranial) per SABR-COMET and LungART evidence; (5) **Continued osimertinib** lifelong (until progression / intolerance); (6) **Surveillance**: CT chest q3 mo + brain MRI q3 mo first 2 yr; (7) **Second-line on progression**: tissue + plasma biopsy for resistance mechanism (T790M, C797S, MET amplification, transformation) → guide next therapy (amivantamab + lazertinib MARIPOSA; chemo + immunotherapy if non-driver); (8) **Smoking cessation, palliative care integrated, supportive"},{"label":"C","text":"Chemo alone, no targeted"},{"label":"D","text":"Hospice referral"},{"label":"E","text":"Surgery alone, no systemic"}]'::jsonb,
  'B', '**Lung cancer (NSCLC)** — paradigm shift in advanced disease management. **Histology-driven + molecular-driven**: - Adenocarcinoma: EGFR, ALK, ROS1, KRAS G12C, BRAF V600E, MET ex14, RET, HER2, NTRK - Squamous: less driver mutations; FGFR, PIK3CA emerging - Small cell: chemo + IO **EGFR-mutant NSCLC**: - 1st-line: osimertinib (3rd-gen, FLAURA OS benefit, CNS active) - Resistance: T790M (1st-gen TKI resistance → osi), C797S, MET amplification, small cell transformation - Amivantamab + lazertinib (EGFR + MET bispecific + 3rd-gen TKI) emerging (MARIPOSA, MARIPOSA-2) **Oligometastatic NSCLC** (1-5 metastases, often single organ): - Aggressive local therapy (SBRT, surgery) + systemic — improved survival in selected (SABR-COMET, LungART) - Brain mets: SRS for 1-3 (preferred over WBRT — neurocognitive preservation per N107C); surgery for solitary large/symptomatic - Adrenal, liver, bone solitary mets — local therapy considered **Stereotactic Radiosurgery (SRS)** for brain mets — single high-dose radiation; preserves cognition vs WBRT; effective for ≤ 3 lesions ≤ 3-4 cm. **Surveillance** post local + targeted — q3 mo first 2 yr then q6 mo. **Liquid biopsy** (ctDNA) — useful for monitoring + identifying resistance non-invasively. A ผิด — pneumonectomy not for stage IV. C ผิด — EGFR+ benefits from targeted. D ผิด — curative intent feasible. E ผิด — systemic essential.', NULL,
  'hard', 'hemato_onco', 'review',
  'surgery', 'clinical_decision', 'hemato_onco', 'adult',
  'NCCN NSCLC 2024; Soria JC et al. NEJM 2018 (FLAURA); Brown PD et al. JAMA 2016 (N107C SRS vs WBRT); Palma DA et al. Lancet 2019 (SABR-COMET)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 68 ปี smoker ผ่าน CT incidental พบ lung nodule 1.8 cm RUL + 2 enlarged mediastinal lymph nodes + brain MRI: 1 lesion 1 cm frontal; PET: SUV 8 primary, SUV 4 mediastinum, brain enhanced

Bronchoscopy + biopsy: adenocarcinoma
Mutations: EGFR exon 19 deletion positive
PS 1
No other metastases

Clinical T1c N2 M1b (single brain met) Stage IVA'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 55 ปี chronic empyema 6 สัปดาห์หลัง pneumonia ใช้ antibiotic IV หลายชนิดอยู่นาน

VS: BP 118/76, HR 88, Temp 38.0°C, SpO2 92% room air
Chest: dull percussion + decreased breath sound right base, no peritonitis
CT chest: right pleural empyema with loculated fluid + thickened pleura + entrapped lung
Thoracentesis: thick pus, gram-positive cocci, glucose < 40, pH 7.0, LDH 1,800

คำถาม: management', '[{"label":"A","text":"Continue IV antibiotic alone"},{"label":"B","text":"**Stage III (organized) pleural empyema — needs drainage + decortication**: (1) **Light''s empyema staging**: - Stage I (exudative): thin fluid, free-flowing — thoracentesis or simple chest tube - Stage II (fibrinopurulent): loculated, fibrin deposition — chest tube + intrapleural fibrinolytic (tPA + DNase per MIST-2) - Stage III (organized): thick pleural peel, entrapped lung — VATS or open decortication; (2) **VATS decortication** preferred — first-line for stage II-III; lower morbidity than thoracotomy in selected; remove fibrinous peel + drain pus + re-expand lung; (3) **Open thoracotomy decortication** — failed VATS, dense adhesions, chronic disease; (4) **Continued IV antibiotic** — culture-directed (empyema flora — strep, staph including MRSA, anaerobes); duration 2-6 weeks typically; (5) **Chest tube + monitoring** post-op until drainage minimal + lung expanded; (6) **Treat underlying cause** — pneumonia, esophageal perforation (Boerhaave), thoracic surgery, trauma; (7) **Empyema necessitatis** — spontaneous extension to soft tissue/skin — drain + treat infection; (8) **Long-term**: monitor for restrictive deficit, recurrence; pulmonary rehabilitation"},{"label":"C","text":"Pneumonectomy"},{"label":"D","text":"Observation only"},{"label":"E","text":"Antifungal alone"}]'::jsonb,
  'B', '**Pleural empyema** — pus in pleural space, complication of bacterial pneumonia 5-10% (parapneumonic effusion 20-40%, empyema 5-10%). **Light''s criteria for exudative effusion**: protein ratio > 0.5, LDH ratio > 0.6, LDH > 2/3 ULN serum. **Empyema staging** (American Thoracic Society): - Stage I (exudative, 1-2 wk): clear fluid, low WBC, low protein, no loculation — drainage with thoracentesis OR small chest tube - Stage II (fibrinopurulent, 2-4 wk): thick fluid, loculations, fibrin — chest tube + intrapleural fibrinolytics (MIST-2: tPA 10 mg + DNase 5 mg BID × 3 days improves drainage + reduces surgery) - Stage III (organized, > 4 wk): thick pleural peel, entrapped lung — surgical decortication **VATS vs Open**: - VATS preferred first-line stage II-III if feasible — less morbidity, similar outcomes - Conversion to open if dense adhesions, anatomic difficulty - Open thoracotomy for chronic, failed VATS, complex anatomy **Antibiotic**: empiric cover community-acquired (strep, staph, anaerobes — amoxicillin-clavulanate, ceftriaxone + metronidazole, ampicillin-sulbactam); MRSA cover (vanco) if risk; nosocomial cover broader. Duration 2-6 weeks. **Drainage**: small-bore (12-14 Fr) effective for thin fluid; large-bore for thick pus; large-bore catheter (28-32 Fr) for empyema commonly. **Complications**: bronchopleural fistula, empyema necessitatis, restriction, sepsis. A ผิด — drainage essential. C ผิด — too radical. D E ผิด.', NULL,
  'medium', 'id', 'review',
  'surgery', 'clinical_decision', 'id', 'adult',
  'ATS Pleural Empyema Guidelines; BTS Pleural Disease 2010; Rahman NM et al. NEJM 2011 (MIST-2)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 55 ปี chronic empyema 6 สัปดาห์หลัง pneumonia ใช้ antibiotic IV หลายชนิดอยู่นาน

VS: BP 118/76, HR 88, Temp 38.0°C, SpO2 92% room air
Chest: dull percussion + decreased breath sound right base, no peritonitis
CT chest: right pleural empyema with loculated fluid + thickened pleura + entrapped lung
Thoracentesis: thick pus, gram-positive cocci, glucose < 40, pH 7.0, LDH 1,800

คำถาม: management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 24 ปี G1P0 1st trimester 10 weeks gestation มาด้วยอาการ chest pain + dyspnea sudden onset 3 ชั่วโมง

VS: BP 92/58, HR 124, RR 28, SpO2 88% room air
Chest: clear breath sounds, no wheeze
Lab: D-dimer 4,200 (interpretation in pregnancy challenging — physiologically elevated)

คำถาม: diagnostic approach for suspected PE in pregnancy', '[{"label":"A","text":"CT pulmonary angiography immediately for all"},{"label":"B","text":"**Suspected PE in pregnancy — stepwise diagnostic approach to minimize fetal radiation while excluding life-threatening PE**: (1) **Risk stratification**: clinical features (hemodynamic instability + tachypnea + hypoxia = high suspicion); (2) **First step — bilateral leg compression US Doppler** — if positive DVT (especially proximal) → diagnose VTE + treat (avoids further imaging); (3) **CXR (low radiation, mandatory)** — rule out other diagnoses (pneumothorax, pneumonia, etc.); (4) **If CXR normal → V/Q scan (preferred next per ESC + RCOG guidelines)** — perfusion-only scan (low ventilation portion sometimes omitted to reduce fetal dose); lower fetal radiation than CTPA but higher maternal breast dose; (5) **If CXR abnormal → CTPA** — better diagnostic in abnormal CXR; modern dose-reduced; fetal dose < 0.1 mGy (well below teratogenic threshold of 50 mGy); maternal breast dose higher than V/Q; (6) **Hemodynamically unstable** — bedside echo (RV strain), CTPA emergent regardless; (7) **Pregnancy-adapted YEARS or DiPEP** — algorithms incorporating clinical + D-dimer thresholds (adjusted in pregnancy) can safely exclude PE without imaging in low-risk; (8) **Diagnostic confirmation** → therapeutic LMWH (see prior question); (9) **MRI pulmonary angiography** — emerging but limited availability + sensitivity"},{"label":"C","text":"D-dimer alone — exclude PE if low"},{"label":"D","text":"Empiric anticoagulation without imaging"},{"label":"E","text":"Observation only"}]'::jsonb,
  'B', '**PE in pregnancy** — leading cause of maternal mortality. Pregnancy = hypercoagulable + venous stasis → high PE risk. **Diagnostic challenges**: - Symptoms (dyspnea, tachycardia) overlap with pregnancy physiology - D-dimer physiologically elevated (negative may exclude in low-risk; positive non-specific) - Imaging considerations: fetal radiation, maternal breast radiation (CTPA), iodinated contrast **Stepwise approach (ESC 2019, RCOG)**: 1. Clinical pre-test probability (Wells, Geneva, YEARS adapted for pregnancy) 2. Bilateral leg compression US Doppler — if proximal DVT positive → diagnose VTE + treat (no further imaging) 3. CXR — to rule out alternative diagnoses + guide next imaging 4. CXR normal → V/Q scan (perfusion-only modification reduces fetal dose) 5. CXR abnormal → CTPA 6. Hemodynamically unstable → emergent bedside echo + CTPA **Radiation exposure**: - Fetal dose: V/Q ~ 0.5 mGy, CTPA ~ 0.05-0.1 mGy (both well below 50 mGy teratogenic threshold) - Maternal breast dose: CTPA higher than V/Q (lifetime breast cancer risk consideration) **Pregnancy-adapted YEARS algorithm**: 3 clinical criteria (DVT signs, hemoptysis, PE most likely diagnosis) + D-dimer threshold adjusted — can rule out PE in 39% of pregnant women without imaging (Artemis study NEJM 2019). **CHEST + ASH guidelines** — supportive of risk-stratified approach + leg US first. **Treatment** if confirmed: LMWH (see prior question). A ผิด — first US legs. C ผิด — D-dimer alone insufficient. D ผิด — confirm diagnosis. E ผิดอย่างยิ่ง.', NULL,
  'hard', 'obgyn', 'review',
  'surgery', 'clinical_decision', 'obgyn', 'adult',
  'ESC PE 2019; RCOG Green-top 37b; van der Pol LM et al. NEJM 2019 (Pregnancy-Adapted YEARS); ACOG Practice Bulletin', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 24 ปี G1P0 1st trimester 10 weeks gestation มาด้วยอาการ chest pain + dyspnea sudden onset 3 ชั่วโมง

VS: BP 92/58, HR 124, RR 28, SpO2 88% room air
Chest: clear breath sounds, no wheeze
Lab: D-dimer 4,200 (interpretation in pregnancy challenging — physiologically elevated)

คำถาม: diagnostic approach for suspected PE in pregnancy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 45 ปี post-renal transplant 5 ปี on tacrolimus + mycophenolate + prednisone มาด้วยอาการปวดท้องตื้อๆ 2 สัปดาห์ + 5 kg loss

US abdomen: cholelithiasis + GB wall 5 mm, mildly thickened, no fluid; suspicious mass at colon

CT abdomen: 3 cm mass right colon + few enlarged regional LNs + 2 liver lesions 1 cm each suspicious
Colonoscopy + biopsy: poorly differentiated adenocarcinoma, MSI-stable, KRAS mutated
Further staging: no other distant disease

คำถาม: management considerations in post-transplant patient', '[{"label":"A","text":"Standard management same as non-transplant"},{"label":"B","text":"**Cancer in transplant recipient — increased risk + management nuances**: (1) **Multidisciplinary**: transplant nephrology, medical oncology, surgical oncology, infectious disease; (2) **Immunosuppression adjustment**: - Reduce overall immunosuppression cautiously — balance graft rejection vs cancer progression - Switch from calcineurin inhibitor (CNI — tacrolimus, cyclosporine: pro-cancer) to mTOR inhibitor (sirolimus, everolimus: anti-tumor effect, less malignancy risk) in selected — particularly for some cancers (skin, Kaposi''s) - Mycophenolate may continue at lower dose - Prednisone continue (avoid adrenal crisis); (3) **Surgical resection** of CRC: right hemicolectomy + standard oncologic resection; (4) **Liver met evaluation**: resectable oligometastatic → potentially resection; multidisciplinary; (5) **Adjuvant chemotherapy** — adjust dosing for renal function + drug interactions: - Tacrolimus + 5-FU/oxaliplatin (FOLFOX): monitor levels (5-FU may alter CNI metabolism) - Avoid nephrotoxic chemotherapy when possible; cisplatin avoid - Capecitabine may be preferred over IV 5-FU (oral, dose adjust renal); (6) **Targeted therapy considerations**: - Anti-EGFR (cetuximab/panitumumab) — KRAS mutated → NOT effective (excluded) - Anti-VEGF (bevacizumab) — wound healing + bleeding + HT issues; caution post-surgery - Immune checkpoint inhibitors (atezolizumab, pembrolizumab in MSI-H) — risk of graft rejection (controversial — may be considered with intensified monitoring; case series); (7) **Infection prophylaxis** intensified during chemo (PJP, CMV); (8) **Renal function monitoring** essential — adjust drug doses; (9) **Long-term**: increased risk other malignancies (skin — q6-12 mo dermatology, PTLD post-transplant lymphoproliferative disorder); (10) **Survivorship + palliation integration**"},{"label":"C","text":"Stop all immunosuppression"},{"label":"D","text":"No treatment"},{"label":"E","text":"Sacrifice graft (allow rejection)"}]'::jsonb,
  'B', '**Malignancy in transplant recipients** — 2-5 fold increased risk vs general population (immunosuppression + chronic inflammation + viral oncogenesis). **Common cancers post-transplant**: - Skin (especially SCC — UV + immunosuppression) - PTLD (post-transplant lymphoproliferative disorder — EBV-driven) - Kaposi''s sarcoma (HHV-8) - Cervical, anal (HPV) - Renal cell, urothelial (especially native kidney in failed transplant) - Colorectal, breast, lung — slightly increased **Management principles**: 1. **Immunosuppression modification**: - Reduce total burden cautiously - Switch CNI → mTOR inhibitor (sirolimus, everolimus) for certain cancers (less tumorigenic, mTOR has anti-tumor effect) - Consider rituximab for PTLD 2. **Standard oncologic care** with modifications: - Surgical resection — same principles - Chemotherapy — dose-adjust for renal/hepatic, drug interactions (CNI metabolism — azole, macrolide affect levels) - Radiation — same - Targeted therapy — case-by-case 3. **Immune checkpoint inhibitors** — controversial; graft rejection risk significant (40% in case series); requires careful selection, intensified monitoring, multidisciplinary; benefit may outweigh risk in selected aggressive cancers without alternatives 4. **Infection prophylaxis** — PJP, CMV, fungal — intensified during chemotherapy 5. **Screening + surveillance** — increased frequency for skin, cervical, anal, renal **PTLD** — most common post-transplant cancer (5-20% kidney recipients); EBV-driven B-cell proliferation; treat: reduce immunosuppression + rituximab + chemo if needed.', NULL,
  'hard', 'hemato_onco', 'review',
  'surgery', 'integrative', 'hemato_onco', 'adult',
  'AST/ASTS Consensus on Malignancy in Transplant; UNOS data; Kasiske BL et al. Am J Transplant', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ผู้ป่วยอายุ 45 ปี post-renal transplant 5 ปี on tacrolimus + mycophenolate + prednisone มาด้วยอาการปวดท้องตื้อๆ 2 สัปดาห์ + 5 kg loss

US abdomen: cholelithiasis + GB wall 5 mm, mildly thickened, no fluid; suspicious mass at colon

CT abdomen: 3 cm mass right colon + few enlarged regional LNs + 2 liver lesions 1 cm each suspicious
Colonoscopy + biopsy: poorly differentiated adenocarcinoma, MSI-stable, KRAS mutated
Further staging: no other distant disease

คำถาม: management considerations in post-transplant patient'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 32 ปี G3P2 immediate post-vaginal delivery 1 hr ago — มี profuse vaginal bleeding 1,500 mL persistent

VS: BP 78/48, HR 132, RR 24, alert
Fundus boggy, atonic, deviated to right
No lacerations evident, no retained products on examination

คำถาม: management of postpartum hemorrhage', '[{"label":"A","text":"Observation + IV fluid"},{"label":"B","text":"**Postpartum Hemorrhage (PPH) — uterine atony most likely (80% of PPH cause)**: (1) **Activate massive transfusion protocol** + 2 large-bore IV + type & crossmatch 4 units PRC + FFP + platelet 1:1:1 ratio; (2) **Identify cause — 4 Ts**: - **Tone** (atony 80%) — most common - **Trauma** (lacerations, hematoma, rupture) - **Tissue** (retained placenta, products) - **Thrombin** (coagulopathy); (3) **For uterine atony — stepwise**: a. **Empty bladder** (Foley) — bladder distention impairs uterine contraction b. **Bimanual uterine compression + massage** c. **Uterotonic medications**: - **Oxytocin** 10-40 units IV/IM (first-line) - **Methylergonovine** 0.2 mg IM q2-4h (avoid in HT) - **Carboprost (15-methyl PGF2α)** 250 mcg IM q15 min (avoid in asthma) - **Misoprostol** 800-1000 mcg PR/SL (alternative); (4) **TXA 1 g IV** within 3 hours (WOMAN trial — reduces mortality from bleeding); (5) **If atony persists** — uterine balloon tamponade (Bakri balloon) or condom catheter (low-resource); (6) **Surgical interventions if continued bleeding**: - Uterine artery embolization (IR — if available + stable enough) - B-Lynch suture (compression suture) - O''Leary uterine artery ligation - Internal iliac artery ligation - **Hysterectomy** — last resort but life-saving in massive hemorrhage; (7) **Resuscitation**: vasopressors, calcium replacement, fibrinogen monitoring (target > 200), avoid hypothermia, correct acidosis; (8) **Postpartum monitoring** ICU, monitor for Sheehan''s, DIC, organ dysfunction"},{"label":"C","text":"Discharge to ward"},{"label":"D","text":"Steroid IV"},{"label":"E","text":"Hysterectomy first-line"}]'::jsonb,
  'B', '**Postpartum Hemorrhage (PPH)** — leading cause of maternal mortality globally. **Definition**: blood loss ≥ 500 mL vaginal delivery, ≥ 1000 mL cesarean OR any blood loss with hemodynamic compromise. **4 Ts of PPH etiology**: 1. **Tone (70-80%)** — uterine atony — most common; risk factors: prolonged labor, multiparity, multiple gestation, polyhydramnios, chorioamnionitis, oxytocin use, magnesium sulfate 2. **Trauma (15-20%)** — lacerations (cervical, vaginal, perineal), hematoma, uterine rupture, inversion 3. **Tissue (10%)** — retained placenta, placental fragments, abnormal placentation (accreta) 4. **Thrombin (1%)** — coagulopathy (HELLP, AFE, sepsis, abruption, DIC) **Stepwise management of uterine atony**: 1. Bimanual massage + empty bladder 2. Uterotonics in sequence: oxytocin → methylergonovine → carboprost → misoprostol 3. TXA 1 g IV within 3h (WOMAN trial — Lancet 2017 — reduces death from bleeding by 1/3) 4. Mechanical: balloon tamponade (Bakri) 5. Surgical: compression sutures (B-Lynch), uterine artery ligation (O''Leary), internal iliac ligation, IR embolization 6. Hysterectomy — last resort **Massive transfusion**: 1:1:1 ratio PRC:FFP:Plt; calcium (citrate binds); avoid hypothermia; fibrinogen > 200 (cryo or fibrinogen concentrate). **Trauma sources**: inspect lower genital tract systematically; consider US/CT for hematoma. **Retained tissue** — manual removal, D&C, methotrexate for accreta spectrum (selected). **Coagulopathy** — workup (PT, aPTT, fibrinogen, platelets, TEG/ROTEM), correct deficits. A ผิด — active hemorrhage. C E ผิด. D ผิด — steroid ไม่ first-line.', NULL,
  'medium', 'obgyn', 'review',
  'surgery', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin 183 PPH; WOMAN Trial Lancet 2017; WHO PPH Recommendations; FIGO PPH Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 32 ปี G3P2 immediate post-vaginal delivery 1 hr ago — มี profuse vaginal bleeding 1,500 mL persistent

VS: BP 78/48, HR 132, RR 24, alert
Fundus boggy, atonic, deviated to right
No lacerations evident, no retained products on examination

คำถาม: management of postpartum hemorrhage'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 60 ปี GERD chronic 20 ปี, smoker, BMI 32 มา EGD พบ Barrett''s esophagus segment 4 cm + nodule 1 cm at GEJ; biopsy = high-grade dysplasia + intramucosal adenocarcinoma (T1a)

No lymphadenopathy on EUS, no distant disease on staging CT/PET

คำถาม: management of Barrett''s + early adenocarcinoma', '[{"label":"A","text":"Esophagectomy for all Barrett''s with HGD"},{"label":"B","text":"**Barrett''s esophagus with HGD + T1a intramucosal adenocarcinoma — endoscopic eradication therapy (organ-preserving)**: (1) **Confirm pathology** — pathology review by GI pathologist; staging: EUS, CT chest/abd, PET; (2) **Endoscopic eradication therapy (EET)**: - **Endoscopic mucosal resection (EMR)** for nodular / focal lesion — both diagnostic (accurate staging — distinguish T1a from T1b) + therapeutic - **Endoscopic submucosal dissection (ESD)** — for larger / en-bloc resection of larger areas - **Radiofrequency ablation (RFA)** of residual flat Barrett''s — eradicates intestinal metaplasia + dysplasia - **Combination EMR + RFA** standard approach; (3) **Pathology criteria for endoscopic vs surgical management of T1**: - T1a (intramucosal): EET acceptable — low nodal risk (~2%) - T1b superficial (sm1, < 500 μm submucosal): EET selected centers vs surgery — controversial; nodal risk 7-15% if high-risk features (poor differentiation, LVI) - T1b deep (sm2-3): surgery (esophagectomy + lymphadenectomy) — high nodal risk; (4) **Post-EET surveillance**: EGD q3 mo × 1 yr, then q6 mo × 1 yr, then annual lifelong — detect recurrence; (5) **Long-term PPI** — high dose, lifelong; lifestyle modification; smoking cessation; weight loss; (6) **Family screening** — first-degree relatives with Barrett''s; (7) **Esophagectomy** if: ESD/EMR fails to achieve R0, T1b deep, multifocal HGD not amenable to EET, patient preference, recurrent dysplasia despite EET"},{"label":"C","text":"Observation alone"},{"label":"D","text":"Chemotherapy alone"},{"label":"E","text":"Total gastrectomy"}]'::jsonb,
  'B', '**Barrett''s esophagus** — intestinal metaplasia in distal esophagus (premalignant). Risk factor for esophageal adenocarcinoma (lifetime ~3-5% for non-dysplastic Barrett''s; higher with dysplasia). **Surveillance**: 1. No dysplasia: EGD q3-5 yr 2. Low-grade dysplasia (LGD): EET (RFA preferred) OR EGD q6-12 mo with biopsies 3. High-grade dysplasia (HGD): EET (mandatory) OR esophagectomy 4. Intramucosal carcinoma (T1a): EET (preferred for organ preservation) 5. T1b superficial: EET vs surgery (case-by-case) 6. T1b deep (sm2-3) or higher: esophagectomy + lymphadenectomy **Endoscopic Eradication Therapy (EET)**: - **EMR/ESD** for nodular/focal lesions — provides accurate staging + treats lesion - **RFA** for flat Barrett''s — eradicates remaining intestinal metaplasia + dysplasia - **Cryotherapy** alternative for select - **Combination EMR + RFA** — most common approach **EET advantages over esophagectomy**: lower morbidity (mortality ~ 0.1% EET vs 2-5% esophagectomy), preserves esophagus + function, comparable oncologic outcomes for T1a + selected T1b. **EET success**: 80-90% complete eradication of dysplasia + intestinal metaplasia at 2 years; recurrence ~ 8-10%/yr → lifelong surveillance + PPI. **Esophagectomy** indications: failed EET, T1b deep, multifocal disease, high-risk features, patient preference. **Aspirin chemoprevention** for high-risk Barrett''s — AspECT trial showed slight benefit + acceptable safety profile.', NULL,
  'hard', 'hemato_onco', 'review',
  'surgery', 'clinical_decision', 'hemato_onco', 'adult',
  'ACG Barrett''s Guidelines 2022; ESGE Endoscopic Submucosal Dissection 2015; Shaheen NJ et al. NEJM 2009 (AIM Trial RFA); Pech O et al. Gastroenterology 2014', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 60 ปี GERD chronic 20 ปี, smoker, BMI 32 มา EGD พบ Barrett''s esophagus segment 4 cm + nodule 1 cm at GEJ; biopsy = high-grade dysplasia + intramucosal adenocarcinoma (T1a)

No lymphadenopathy on EUS, no distant disease on staging CT/PET

คำถาม: management of Barrett''s + early adenocarcinoma'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 50 ปี smoker, BMI 28 มาด้วยอาการ heartburn + regurgitation 5 ปี + dysphagia เป็นๆ หายๆ + วันนี้ regurgitation ของอาหารที่กินเมื่อ 6 ชั่วโมงก่อน + chest tightness severe

VS: BP 138/86, HR 102, RR 18, Temp 36.8°C
Chest: clear breath sound

EGD: severe dilation of distal esophagus + ''bird''s beak'' narrowing at GEJ + retained food + no esophagitis severe
High-resolution manometry: failed relaxation LES + absent peristalsis = achalasia (subtype I — classic)
Barium swallow: dilated esophagus + bird''s beak', '[{"label":"A","text":"PPI long-term only"},{"label":"B","text":"**Achalasia (classic — type I per Chicago Classification) — treatment options**: (1) **Goal**: relieve obstruction at LES — symptomatic relief + prevent complications (megaesophagus, sigmoid esophagus, aspiration, esophageal Ca); (2) **Treatment options**: a. **Pneumatic dilation (PD)** — endoscopic dilation 30-40 mm balloon — graded; effective 50-90% short-term; perforation risk 2-5%; may repeat b. **Heller myotomy (laparoscopic) + partial fundoplication (Dor anterior 180° or Toupet posterior 270°)** — definitive surgery; division of LES muscle; fundoplication prevents post-op reflux; success 85-95%, durable c. **Per-Oral Endoscopic Myotomy (POEM)** — endoscopic incision of LES via submucosal tunnel; equivalent to Heller in short-medium term (POEM vs Heller trials Inoue, others); higher post-op reflux than Heller + fundoplication (no antireflux component — though anterior POEM may reduce); d. **Botox injection** to LES — 100 units endoscopic — temporary (3-6 mo); reserve for elderly / unfit / bridge; e. **Calcium channel blocker, nitrate** — limited efficacy, side effects; (3) **Choice depends on**: age, comorbidity, surgical fitness, achalasia subtype (II classic responds best to all, III spastic to POEM), patient preference, local expertise; (4) **Subtype-specific** (Chicago): - Type I (classic): all options - Type II (panesophageal pressurization): best response - Type III (spastic): POEM (longer myotomy) preferred; (5) **Long-term surveillance**: 10-fold increased esophageal SCC risk → EGD periodically; reflux surveillance post-procedure"},{"label":"C","text":"Esophagectomy first-line"},{"label":"D","text":"Observation + no treatment"},{"label":"E","text":"Antifungal only"}]'::jsonb,
  'B', '**Achalasia** — primary esophageal motility disorder. Pathophysiology: loss of inhibitory ganglion cells in myenteric (Auerbach) plexus → failure of LES relaxation + absent peristalsis. Etiology mostly idiopathic; secondary (pseudoachalasia) from infiltrating malignancy at GEJ, Chagas disease (T. cruzi). **Clinical**: dysphagia (solids + liquids paradoxically — distinguishing from peptic stricture), regurgitation, chest pain, weight loss, aspiration. **Diagnosis**: 1. **Barium swallow** — bird''s beak narrowing + dilated esophagus + sigmoid esophagus (advanced) 2. **EGD** — exclude malignancy at GEJ (pseudoachalasia), assess esophagitis 3. **High-resolution manometry** — diagnostic + subtyping (Chicago Classification): - Type I: classic — failed relaxation + absent peristalsis (no pressurization) - Type II: panesophageal pressurization — best response to treatment - Type III: spastic contractions + failed relaxation **Treatment options**: 1. **Heller myotomy + partial fundoplication (laparoscopic)** — gold standard for surgical candidates; 85-95% effective, durable 2. **POEM** — endoscopic alternative; equivalent short-medium term; higher post-op reflux; preferred for type III (longer myotomy) 3. **Pneumatic dilation** — graded balloon; ~ 50-70% durable response; may need repeat; perforation risk 4. **Botox** — temporary, for non-operative candidates 5. **Medical** (CCB, nitrate) — limited efficacy **Post-treatment surveillance**: GERD (PPI), esophageal Ca risk (10-fold ↑ — surveillance EGD periodically). **End-stage achalasia** (megaesophagus, sigmoid): esophagectomy considered.', NULL,
  'medium', 'gi', 'review',
  'surgery', 'clinical_decision', 'gi', 'adult',
  'Chicago Classification 4.0; ACG Achalasia Guidelines 2020; Vaezi MF et al. Gastroenterology; Werner YB et al. NEJM 2019 (POEM vs Heller)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ชายไทยอายุ 50 ปี smoker, BMI 28 มาด้วยอาการ heartburn + regurgitation 5 ปี + dysphagia เป็นๆ หายๆ + วันนี้ regurgitation ของอาหารที่กินเมื่อ 6 ชั่วโมงก่อน + chest tightness severe

VS: BP 138/86, HR 102, RR 18, Temp 36.8°C
Chest: clear breath sound

EGD: severe dilation of distal esophagus + ''bird''s beak'' narrowing at GEJ + retained food + no esophagitis severe
High-resolution manometry: failed relaxation LES + absent peristalsis = achalasia (subtype I — classic)
Barium swallow: dilated esophagus + bird''s beak'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกแรกเกิดอายุ 12 ชั่วโมง มาด้วย excessive drooling + cyanosis with feeding + can''t pass NG tube into stomach (coil at upper esophagus)

CXR: NG tube coiled in upper esophagus + air in stomach (suggesting distal TEF)
Clinical diagnosis: esophageal atresia with distal tracheoesophageal fistula (TEF Type C — Gross — most common 85%)', '[{"label":"A","text":"Observation + IV fluid"},{"label":"B","text":"**Esophageal atresia with distal TEF (Gross type C, 85%) — staged management**: (1) **Pre-op stabilization**: - Head up 30-45° position - Suction esophageal pouch (Replogle tube — continuous low-pressure suction) - NPO - IV fluid + maintenance - Antibiotic prophylaxis (aspiration pneumonia risk) - Ventilator avoid high pressures (distends stomach via fistula → respiratory distress + aspiration); (2) **Workup for VACTERL association** (vertebral, anal, cardiac, tracheoesophageal, renal, limb) — echocardiogram (cardiac anomalies 30-40%, including R-sided arch — affects surgical approach), spine X-ray, renal US, anorectal exam, limb exam; (3) **Timing of surgery**: - Stable + term: primary repair within 24-72h - Premature / unstable / pulmonary issues: delayed primary repair (gastrostomy for feeding + fistula ligation as initial); (4) **Surgical approach**: - **Right thoracotomy** (or thoracoscopy in experienced centers) for left-sided aortic arch (most common — 95%) — extrapleural approach traditionally - **Left thoracotomy** if right-sided aortic arch (3-5% — important for echo screening pre-op); (5) **Repair**: - Ligate + divide TEF - Esophageal anastomosis end-to-end (primary if proximal/distal pouches reachable) - Long-gap atresia (> 3 vertebral bodies): staged — gastrostomy + delayed repair (4-12 wk) or esophageal lengthening (Foker procedure) or gastric pull-up / colon interposition for ultra-long-gap; (6) **Post-op complications**: anastomotic leak (10-20%), anastomotic stricture (~30% — endoscopic dilation), recurrent fistula (5-10%), GERD common (lifelong PPI often), tracheomalacia, dysphagia, motility disorder; (7) **Long-term**: pediatric GI follow-up, growth, neurodevelopmental, swallowing therapy"},{"label":"C","text":"Total esophagectomy at birth"},{"label":"D","text":"Feeding through NG tube"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', '**Esophageal Atresia (EA) ± Tracheoesophageal Fistula (TEF)** — congenital. Incidence 1:3,000-4,500. **Gross Classification**: - Type A — Pure EA without TEF (~ 8%) — long gap - Type B — EA with proximal TEF (~ 1%) - Type C — EA with distal TEF (~ 85%) — most common - Type D — EA with both proximal + distal TEF (~ 1%) - Type E (H-type) — Isolated TEF without EA (~ 5%) — presents later **Presentation**: - Polyhydramnios prenatal (inability to swallow amniotic fluid) - Drooling, choking, cyanosis with feeding - Cannot pass NG tube (coils at pouch) - Type E may present later — recurrent pneumonia, choking with feeding **CXR findings**: - Coiled NG tube in upper pouch - Air in stomach = distal TEF present - No gas in abdomen = pure EA or proximal TEF only **VACTERL association**: - V — Vertebral - A — Anorectal (imperforate anus) - C — Cardiac (30-40%) - TE — Tracheoesophageal - R — Renal - L — Limb (radial — thumb) Screen with echo (priority), spine X-ray, renal US, anorectal exam, limb exam. **Pre-op stabilization** principles: head-up, continuous suction of upper pouch, NPO, avoid high-pressure ventilation. **Surgical approach**: right thoracotomy/thoracoscopy (left aortic arch — 95%); confirm aortic arch position by echo. **Long-term outcomes**: most do well with appropriate care. Long-term issues: GERD, dysphagia, anastomotic stricture, motility, tracheomalacia, growth.', NULL,
  'medium', 'pediatrics', 'review',
  'surgery', 'clinical_decision', 'pediatrics', 'peds',
  'APSA Pediatric Surgery Handbook; Spitz L et al. Br J Surg; ESPGHAN-NASPGHAN EA Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ทารกแรกเกิดอายุ 12 ชั่วโมง มาด้วย excessive drooling + cyanosis with feeding + can''t pass NG tube into stomach (coil at upper esophagus)

CXR: NG tube coiled in upper esophagus + air in stomach (suggesting distal TEF)
Clinical diagnosis: esophageal atresia with distal tracheoesophageal fistula (TEF Type C — Gross — most common 85%)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกแรกเกิดอายุ 1 วัน มาด้วยภาวะ respiratory distress severe + scaphoid abdomen + barrel chest + bowel sounds in chest

CXR: bowel loops in left hemithorax + mediastinal shift to right + small RUL
ABG: pH 7.20, PaCO2 65, PaO2 50

คำถาม: management', '[{"label":"A","text":"Bag-mask ventilation"},{"label":"B","text":"**Congenital Diaphragmatic Hernia (CDH) — neonatal emergency, physiology-first stabilization before surgery**: (1) **Avoid bag-mask ventilation** (distends bowel in chest → worsens lung compression + cardiopulmonary compromise); (2) **Immediate intubation + gentle ventilation** — low pressure, permissive hypercapnia (PaCO2 50-70), preductal SpO2 > 85% acceptable; lung-protective; (3) **NG tube decompression** — empty stomach/bowel in chest; (4) **Pre-op stabilization** (''gentle ventilation'' era — physiologic stabilization first, surgery delayed until stable — improved outcomes): - Surfactant if preterm - Inotropes for hypotension - Pulmonary hypertension management: iNO (inhaled nitric oxide), sildenafil, milrinone - Persistent PHTN: ECMO bridge (criteria — preductal SpO2 < 85%, OI > 25, refractory hypotension); (5) **Workup for associations**: echocardiogram (cardiac anomalies common — 25%), chromosomal (trisomy 13, 18, 21), syndromes (CHARGE, Pallister-Killian); (6) **Surgical repair after stabilization** (typically days, not hours): - Approach: subcostal or laparotomy (more common in CDH) - Reduce abdominal contents from chest - Primary diaphragm closure (small defects) or patch repair (large defects) — Gore-Tex, biological mesh; - Liver position critical (intrathoracic liver = worse prognosis); (7) **Postop**: continued ventilator support, gradual weaning; PHTN monitoring; (8) **Long-term**: ~ 60-80% survival in modern era (depends on side, liver position, size of defect, associated anomalies); long-term issues: BPD, PHTN, GERD, growth delay, hearing loss, neurodevelopmental delay"},{"label":"C","text":"Emergent operative repair within 1 hour"},{"label":"D","text":"Observation"},{"label":"E","text":"Total gastrectomy"}]'::jsonb,
  'B', '**Congenital Diaphragmatic Hernia (CDH)** — defect in diaphragm allowing abdominal contents into chest → pulmonary hypoplasia + persistent pulmonary HTN. Incidence ~ 1:2,500. **Types**: - **Bochdalek (90%)** — posterolateral, more often left (80%) - **Morgagni (5%)** — anterior/retrosternal - **Central** (rare) **Pathophysiology**: - Pulmonary hypoplasia (both lungs, worse ipsilateral) - Persistent pulmonary hypertension (PPHN) — high resistance, R-to-L shunt - Heart compression + mediastinal shift **Presentation**: - Antenatal US — diagnostic - Birth: respiratory distress, scaphoid abdomen, barrel chest, bowel sounds in chest, decreased breath sounds **Management evolution**: ''Surgery is not the emergency, physiology is.'' - Pre-1990s: emergent surgery → high mortality - Modern: ''gentle ventilation'' + delayed surgery after stabilization → improved survival 1. **Immediate**: avoid bag-mask, intubate, NG decompression 2. **Ventilation**: low PIP (< 25), permissive hypercapnia (PaCO2 50-70), preductal SpO2 > 85% 3. **PPHN management**: iNO, sildenafil, milrinone, prostaglandin if ductal-dependent 4. **ECMO** for refractory: VV or VA; criteria include OI > 25, refractory hypotension, hypoxia 5. **Surgical repair** when stable (days, not hours): - Reduce viscera - Primary closure or patch (large defects) - Approach: abdominal (subcostal) most common 6. **Postop**: continued ventilation, weaning, PHTN monitoring 7. **Long-term**: ~ 60-80% survival; BPD, PHTN, GERD, scoliosis, growth, neurodevelopmental issues **Prognosis** depends on: lung size (LHR — lung-to-head ratio prenatal), liver position (intrathoracic liver = worse), associated anomalies. **Fetal intervention** (FETO — fetal endoscopic tracheal occlusion) — for severe CDH with high mortality risk; improves lung growth (TOTAL trial NEJM 2021).', NULL,
  'hard', 'pediatrics', 'review',
  'surgery', 'clinical_decision', 'pediatrics', 'peds',
  'CDH EURO Consortium Consensus; Snoek KG et al. Neonatology; Deprest J et al. NEJM 2021 (TOTAL Trial)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ทารกแรกเกิดอายุ 1 วัน มาด้วยภาวะ respiratory distress severe + scaphoid abdomen + barrel chest + bowel sounds in chest

CXR: bowel loops in left hemithorax + mediastinal shift to right + small RUL
ABG: pH 7.20, PaCO2 65, PaO2 50

คำถาม: management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกแรกเกิดอายุ 1 วัน born premature 30 weeks GA, weight 1,400 g, ในวันที่ 5 มี feeding intolerance, abdominal distention, bloody stool

VS: BP 64/38, HR 168, Temp 36.0°C
Abdomen: distended, erythema over abdominal wall, sluggish bowel sounds, tenderness

Lab: WBC 18,000, Plt 80,000 (down from 230,000), CRP 78, lactate 4.2
KUB: pneumatosis intestinalis + portal venous gas + dilated bowel loops; no free air yet

คำถาม: management', '[{"label":"A","text":"Continue oral feeding"},{"label":"B","text":"**Necrotizing Enterocolitis (NEC) — Bell stage IIB (definite NEC with systemic signs + portal gas) — medical management**: (1) **NPO + bowel rest** 7-14 days + NG decompression; (2) **TPN** — central venous access for parenteral nutrition; (3) **IV broad-spectrum antibiotics** — cover enteric flora + anaerobes — typically **ampicillin + gentamicin + metronidazole** OR meropenem alone — 7-14 days; (4) **Respiratory + circulatory support** as needed — mechanical ventilation, vasopressor, blood products (platelets often consumed); (5) **Serial abdominal exams + KUB q6-12h** — monitor for progression to perforation (free air → Bell stage III → surgical); (6) **Surgical indications** (Bell stage III): - Pneumoperitoneum (free air) - Worsening clinical despite medical - Palpable mass / fixed loops on serial X-ray - Erythema of abdominal wall - Hemodynamic instability; (7) **Surgical options**: - **Laparotomy + bowel resection** of necrotic + primary anastomosis OR diverting stoma + ''clip-and-drop'' (damage control) for damage control - **Primary peritoneal drainage (PPD)** in extremely premature/unstable — bedside placement of drain in RLQ; NEC NEONATAL Trial showed PPD + laparotomy comparable in some subgroups; (8) **Long-term complications**: short gut syndrome (extensive bowel loss), strictures (~ 20%), TPN-related liver disease, neurodevelopmental delay; (9) **Prevention** strategies: breast milk feeding (protective vs formula — NEC reduction), standardized feeding protocols, probiotics (controversial — some evidence), prevention of premature birth"},{"label":"C","text":"Observation only"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Whipple procedure"}]'::jsonb,
  'B', '**Necrotizing Enterocolitis (NEC)** — most common GI emergency of preterm infant. Incidence ~ 5-10% VLBW infants (< 1500 g). **Pathophysiology**: multifactorial — prematurity (immature gut barrier + immune), formula feeding (vs breast milk protective), enteral feeds advancement, intestinal ischemia, bacterial translocation, hypoxia-reperfusion. **Bell Staging**: - **I (suspected)**: clinical + non-specific imaging — supportive - **II (definite)**: A pneumatosis intestinalis on imaging; B + portal venous gas / systemic signs — NPO, IV abx, TPN, supportive - **III (advanced)**: A peritonitis + acidosis + DIC; B + perforation (pneumoperitoneum) — SURGICAL **Clinical**: feeding intolerance, abdominal distention, bilious aspirate, bloody stool, lethargy, temperature instability, apnea, bradycardia, shock. **Imaging**: pneumatosis intestinalis (pathognomonic), portal venous gas (advanced), fixed dilated loop, free air (perforation). Serial KUB essential. **Medical management** (Bell I-II): - NPO 7-14 days - TPN central line - Broad-spectrum antibiotics (ampicillin + gentamicin + metronidazole OR meropenem) - Decompress (NG) - Serial assessment - Blood products as needed **Surgical management** (Bell III): - Laparotomy + resection of necrotic bowel + stoma or primary anastomosis (depending on bowel length + viability + patient stability) - Primary peritoneal drainage (PPD) for unstable / extremely premature — drain alone; NECsteo + NEC NEONATAL trials show comparable outcomes in some subgroups - ''Clip-and-drop'' damage control: resect necrotic + temporary closure; second look 24-48h; restore continuity later **Outcomes**: mortality 20-30% overall; higher for surgical NEC + extreme prematurity. Long-term: short gut, strictures, neurodevelopmental delay (worse with surgical NEC). **Prevention**: human milk feeding (DOPPS evidence), standardized feeding advancement, probiotics (controversial), donor milk if mom''s unavailable.', NULL,
  'medium', 'pediatrics', 'review',
  'surgery', 'clinical_decision', 'pediatrics', 'peds',
  'APSA Pediatric Surgery Handbook; Neu J, Walker WA. NEJM 2011; Moss RL et al. NEJM 2006 (NEC Surgery); Blakely ML et al. JAMA Surg', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'ทารกแรกเกิดอายุ 1 วัน born premature 30 weeks GA, weight 1,400 g, ในวันที่ 5 มี feeding intolerance, abdominal distention, bloody stool

VS: BP 64/38, HR 168, Temp 36.0°C
Abdomen: distended, erythema over abdominal wall, sluggish bowel sounds, tenderness

Lab: WBC 18,000, Plt 80,000 (down from 230,000), CRP 78, lactate 4.2
KUB: pneumatosis intestinalis + portal venous gas + dilated bowel loops; no free air yet

คำถาม: management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 28 ปี ผ่า cesarean section 6 ชั่วโมงก่อน มาขอ consult ICU เพราะปวดท้อง + tachycardia + tachypnea + hypoxic

VS: BP 84/52, HR 138, RR 32, SpO2 86%, Temp 37.8°C
Gen: alert but distressed
Lab: D-dimer 8,000, Hb 9.2 (preop 11), fibrinogen 100 (low), platelets 80,000, INR 1.8, troponin 0.04
ECG: sinus tach
CXR: bilateral pulmonary edema
Echo: RV dilation, decreased RV function, no IVC collapse

คำถาม: differential diagnosis + management', '[{"label":"A","text":"Observation"},{"label":"B","text":"**Suspected Amniotic Fluid Embolism (AFE) — life-threatening obstetric emergency**: (1) **Differential consideration**: AFE, PE, hemorrhage with DIC, sepsis, anaphylaxis, cardiac (MI, dissection), tension pneumothorax — but clinical context (peripartum, sudden hypoxia, hypotension, coagulopathy) → AFE most likely; (2) **AFE clinical triad**: sudden cardiovascular collapse + hypoxia + DIC during/immediately after labor/delivery; (3) **Diagnosis is clinical** (no specific test); pathology: fetal squames + lanugo + mucin in maternal circulation (postmortem); rule out other causes; (4) **Management — supportive multidisciplinary**: - **Resuscitation** ABC: intubate + mechanical ventilation, vasopressor (norepi + epinephrine), IV fluid cautiously; - **Hemodynamic support**: pulmonary vasodilators (iNO, sildenafil, milrinone) for RV failure; consider ECMO bridge for refractory cardiogenic shock + hypoxia; - **DIC management**: aggressive blood product replacement — PRC, FFP, platelets, cryoprecipitate (fibrinogen target > 200, low fibrinogen drives bleeding), TXA, factor concentrates; massive transfusion protocol; - **Atropine + ondansetron + ketorolac (A-OK regimen)** — emerging anecdotal supportive therapy for AFE (case series, not RCT) - **Address surgical bleeding** — uterine compression sutures, balloon tamponade, hysterectomy if uncontrolled; (5) **Mortality** 20-60% historically; modern aggressive management improves; survivors high morbidity (neurological, cardiac, hematologic); (6) **Postpartum care**: ICU, multidisciplinary (OB, ICU, hematology, cardiology); (7) **Counseling for future pregnancies** — recurrence rare but considered; case-by-case"},{"label":"C","text":"PPI alone"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
  'B', '**Amniotic Fluid Embolism (AFE)** — rare (1:8,000-1:80,000 deliveries) but catastrophic obstetric emergency. **Pathophysiology**: amniotic fluid components enter maternal circulation → pulmonary vascular obstruction + biphasic hemodynamic response (initial PHTN + RV failure → then LV failure) + anaphylactoid/inflammatory response + DIC. Modern understanding: more akin to anaphylaxis (anaphylactoid syndrome of pregnancy) than embolic obstruction. **Clinical features (sudden, peripartum or up to 30 min postpartum)**: - Severe hypotension - Hypoxia - Coagulopathy / DIC - Altered mental status, seizures - Cardiac arrest (uncommon presenting feature) **Diagnosis** — clinical, exclude alternatives. No pathognomonic test. **Management — supportive**: 1. ABC: intubate, mechanical ventilation 2. Aggressive hemodynamic support: vasopressors (norepi, epinephrine), inotrope, IV fluid (judicious — RV failure) 3. Pulmonary vasodilators (iNO, sildenafil, milrinone, prostacyclin) for RV failure 4. ECMO (VA) for refractory cardiogenic shock 5. Massive transfusion (PRC:FFP:Plt 1:1:1) + cryoprecipitate (fibrinogen target > 200) + TXA 6. Treat ongoing surgical bleeding 7. Multidisciplinary (OB, ICU, anesthesia, hematology) **A-OK regimen** (atropine, ondansetron, ketorolac) — anecdotal, proposed mechanism: blunt vagal + serotonin + thromboxane response; not RCT-proven. **Mortality**: 20-60% historic; better in modern centers. Survivors significant morbidity. Recurrence in future pregnancy uncertain — likely low but counsel risk.', NULL,
  'hard', 'obgyn', 'review',
  'surgery', 'clinical_decision', 'obgyn', 'adult',
  'Clark SL et al. AJOG 2016; SMFM Clinical Series AFE; Pacheco LD et al. AJOG 2016 (A-OK Regimen)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'surg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'surgery'
      and q.scenario = 'หญิงไทยอายุ 28 ปี ผ่า cesarean section 6 ชั่วโมงก่อน มาขอ consult ICU เพราะปวดท้อง + tachycardia + tachypnea + hypoxic

VS: BP 84/52, HR 138, RR 32, SpO2 86%, Temp 37.8°C
Gen: alert but distressed
Lab: D-dimer 8,000, Hb 9.2 (preop 11), fibrinogen 100 (low), platelets 80,000, INR 1.8, troponin 0.04
ECG: sinus tach
CXR: bilateral pulmonary edema
Echo: RV dilation, decreased RV function, no IVC collapse

คำถาม: differential diagnosis + management'
  );

commit;

