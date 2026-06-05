-- ===============================================================
-- หมอรู้ — Board seed: อายุรศาสตร์ (internal_medicine) — Part 1/4 (Q1-50)
-- Safe to paste into Supabase SQL Editor. Re-runnable.
-- Apply parts in order: 1, 2, 3, 4
-- ===============================================================

begin;

-- 1/2 ─── mcq_subjects for this specialty (idempotent) ────────
insert into public.mcq_subjects
  (name, name_th, icon, audience, board_specialty, exam_type, question_count)
values
  ('im_clinical_decision', 'อายุรศาสตร์ · การตัดสินใจทางเวชกรรม', '🩺', 'board', 'internal_medicine', NULL, 0),
  ('im_basic_science', 'อายุรศาสตร์ · วิทยาศาสตร์การแพทย์พื้นฐาน', '🧬', 'board', 'internal_medicine', NULL, 0),
  ('im_ems_mgmt', 'อายุรศาสตร์ · การจัดการระบบบริการการแพทย์ฉุกเฉิน', '🚨', 'board', 'internal_medicine', NULL, 0),
  ('im_integrative', 'อายุรศาสตร์ · ข้อสอบบูรณาการ', '🧩', 'board', 'internal_medicine', NULL, 0)
on conflict (name) do nothing;

-- 2/2 ─── 50 mcq_questions (Q1-50) ──────────────

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 68 ปี underlying HT, DM type 2, ex-smoker 40 pack-year มาด้วยอาการเหนื่อยมากขึ้น orthopnea + bilateral pedal edema มา 1 สัปดาห์

V/S: BP 138/82, HR 102 (irregular), RR 24, SpO2 90% room air, น้ำหนักเพิ่ม 4 kg ใน 2 สัปดาห์
JVP 12 cmH2O, S3 gallop, fine basilar crackles ทั้งสองข้าง, hepatomegaly, 2+ pitting edema

Lab: BNP 1,850 pg/mL (URL 100), Troponin 0.02 (ไม่เพิ่ม), Cr 1.6 (baseline 1.2), Na 132, K 4.2
Echocardiogram: LVEF 28%, dilated LV
CXR: cardiomegaly + pulmonary congestion + bilateral pleural effusion', '[{"label":"A","text":"IV furosemide 40-80 mg bolus (2× home dose) + monitor urine output + ลด preload (NTG ถ้า BP > 100) + ออกซิเจน + assess perfusion"},{"label":"B","text":"IV norepinephrine drip + dobutamine สำหรับ cardiogenic shock"},{"label":"C","text":"IV beta-blocker (metoprolol IV) ทันทีเพื่อ rate control"},{"label":"D","text":"Restrict fluid + furosemide oral + discharge follow-up OPD"},{"label":"E","text":"ACEi loading dose + spironolactone IV"}]'::jsonb,
  'A', 'ผู้ป่วยเป็น acute decompensated heart failure (ADHF) — "warm and wet" profile (perfusion ดี, congestion +) ESC 2021 + AHA/ACC 2022 HF guideline first-line: (1) IV loop diuretic — initial dose 2× home oral dose IV (Pioneer-HF + DOSE trial); titrate q 2-4 ชม. (2) Oxygen supplementation ถ้า SpO2 < 90% (3) IV vasodilator (NTG) ถ้า systolic BP > 100 + symptomatic (4) Beta-blocker: ห้ามให้ใหม่ใน acute decompensation — continue home dose ถ้าตัว stable (5) ACEi/ARB: continue oral; ห้าม initiate IV (6) Inotrope (dobutamine) เฉพาะ "cold and wet" (poor perfusion) — ตัวเลือก A ถูก. B ผิดเพราะไม่ใช่ shock. C ผิด — beta-blocker IV ใน ADHF เพิ่ม mortality. D ผิด — IV diuretic ดีกว่า oral. E ผิด — spironolactone IV ไม่มี form', NULL,
  'medium', 'cardiovascular', 'review',
  'internal_medicine', 'clinical_decision', 'cardiovascular', 'adult',
  'AHA/ACC/HFSA 2022 Guideline for the Management of Heart Failure; ESC Guidelines for Diagnosis and Treatment of Acute and Chronic Heart Failure 2021; Felker GM et al. NEJM 2011 (DOSE-AHF)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 68 ปี underlying HT, DM type 2, ex-smoker 40 pack-year มาด้วยอาการเหนื่อยมากขึ้น orthopnea + bilateral pedal edema มา 1 สัปดาห์

V/S: BP 138/82, HR 102 (irregular), RR 24, SpO2 90% room air, น้ำหนักเพิ่ม 4 kg ใน 2 สัปดาห์
JVP 12 cmH2O, S3 gallop, fine basilar crackles ทั้งสองข้าง, hepatomegaly, 2+ pitting edema

Lab: BNP 1,850 pg/mL (URL 100), Troponin 0.02 (ไม่เพิ่ม), Cr 1.6 (baseline 1.2), Na 132, K 4.2
Echocardiogram: LVEF 28%, dilated LV
CXR: cardiomegaly + pulmonary congestion + bilateral pleural effusion'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 52 ปี ไม่มีโรคประจำตัว มาด้วยอาการอ่อนเพลีย น้ำหนักลด 5 kg ใน 3 เดือน เหงื่อออกตอนกลางคืน ปวดข้อมือทั้งสองข้าง บวมตอนเช้า > 1 ชม.

V/S: BP 124/76, HR 88, RR 14, Temp 37.6°C
PE: symmetric synovitis ที่ MCP, PIP ทั้งสองข้าง + wrists
ไม่มี nodules

Lab: Hb 10.2 (normocytic), WBC 9,800, Plt 425,000, ESR 78, CRP 32, RF positive (78 IU/mL), Anti-CCP > 200 U/mL (strongly positive), ANA 1:80', '[{"label":"A","text":"NSAIDs อย่างเดียว + observe"},{"label":"B","text":"Start methotrexate 15 mg/wk + folate + low-dose prednisolone bridging + monitor CBC/LFT + refer rheumatology — early aggressive DMARD ลด joint damage ตาม treat-to-target strategy"},{"label":"C","text":"Hydroxychloroquine อย่างเดียว"},{"label":"D","text":"ส่ง biologic agent (anti-TNF) เป็น first-line"},{"label":"E","text":"Topical NSAIDs + physiotherapy"}]'::jsonb,
  'B', 'ผู้ป่วยมี classic Rheumatoid Arthritis (RA) ตาม ACR/EULAR 2010 classification criteria: symmetric polyarthritis ของ small joints + morning stiffness > 1 ชม. + RF positive + Anti-CCP strongly positive + ESR/CRP elevated + symptoms > 6 สัปดาห์ ACR 2021 + EULAR 2022 RA guideline: (1) Methotrexate (MTX) เป็น anchor DMARD first-line — start within 3 เดือนของ diagnosis (window of opportunity) (2) Folate supplementation ลด GI side effect (3) Bridging glucocorticoid (low-dose prednisolone 5-10 mg) ลด symptoms ระหว่าง MTX onset (4-8 สัปดาห์ to effect), taper เมื่อ DMARD effective (4) Treat-to-target: aim for remission (DAS28 < 2.6) (5) Biologic หรือ targeted synthetic DMARD ถ้า MTX fail หลัง 3-6 เดือน — ตัวเลือก B ครบ. A ผิด — NSAIDs ไม่ stop progression. C ผิด — HCQ ใช้ใน mild RA หรือ combo. D ผิด — biologic ไม่ใช่ first-line. E ผิดเชิงพื้นฐาน', NULL,
  'medium', 'rheumatology', 'review',
  'internal_medicine', 'clinical_decision', 'rheumatology', 'adult',
  'ACR Guideline for the Treatment of Rheumatoid Arthritis 2021; EULAR Recommendations for the Management of RA 2022', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 52 ปี ไม่มีโรคประจำตัว มาด้วยอาการอ่อนเพลีย น้ำหนักลด 5 kg ใน 3 เดือน เหงื่อออกตอนกลางคืน ปวดข้อมือทั้งสองข้าง บวมตอนเช้า > 1 ชม.

V/S: BP 124/76, HR 88, RR 14, Temp 37.6°C
PE: symmetric synovitis ที่ MCP, PIP ทั้งสองข้าง + wrists
ไม่มี nodules

Lab: Hb 10.2 (normocytic), WBC 9,800, Plt 425,000, ESR 78, CRP 32, RF positive (78 IU/mL), Anti-CCP > 200 U/mL (strongly positive), ANA 1:80'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 45 ปี underlying chronic alcoholism มา ED ด้วยอาการสับสน confused ระยะ 3 วัน ก่อนหน้านี้หยุดดื่มสุรามา 5 วัน เพราะรู้สึกไม่สบาย

V/S: BP 168/102, HR 124, RR 22, Temp 38.4°C, SpO2 96%
Gen: tremor, diaphoretic, agitated, ตอบคำถามเพี้ยน เห็น insects ที่ผนัง
GCS 14 (E4V4M6)
ไม่มี focal neurology, neck supple

Lab: Mg 1.2 (low), K 3.1, Na 132, Glucose 88, AST 188, ALT 92, Ammonia 84
CT brain: negative', '[{"label":"A","text":"IV haloperidol อย่างเดียว + restraint"},{"label":"B","text":"IV thiamine 500 mg ก่อนให้กลูโคส + IV benzodiazepine (lorazepam หรือ diazepam) titrate ด้วย CIWA-Ar protocol + correct electrolytes (Mg, K) + IV fluid + monitor — ป้องกัน Wernicke encephalopathy"},{"label":"C","text":"Beta-blocker IV เพื่อ control HR + BP"},{"label":"D","text":"IV dextrose 50% bolus ก่อนเพราะกลัว hypoglycemia"},{"label":"E","text":"IV phenytoin loading dose เพื่อ prevent seizure"}]'::jsonb,
  'B', 'ผู้ป่วยเป็น Delirium Tremens (DTs) — severe alcohol withdrawal (peak 48-96 ชม. หลังหยุด) + เพิ่ม risk Wernicke encephalopathy AAFP/ASAM/Royal College of Psychiatrists guideline: (1) **Thiamine 100-500 mg IV ก่อนกลูโคส** เสมอ — ถ้าให้กลูโคสก่อน thiamine จะ precipitate Wernicke (acute amnestic state) ใน thiamine-deficient (2) Benzodiazepine titrate ตาม CIWA-Ar — lorazepam (short half-life ใน liver disease), diazepam (long half-life — auto-tapering) — first-line สำหรับทั้ง withdrawal และ DTs (3) Correct electrolytes: Mg (precipitate seizure), K, Phos (4) IV fluid (dehydration) (5) Treat hyperthermia + agitation (6) Avoid haloperidol ใน DTs (lower seizure threshold) — ตัวเลือก B ครบและถูกลำดับ. A ผิดเพราะ haloperidol ลด seizure threshold. C ผิด — beta-blocker mask autonomic symptoms ไม่ได้รักษา root cause. D ผิดอย่างยิ่ง — กลูโคสก่อน thiamine = Wernicke. E ผิด — phenytoin ไม่มีประโยชน์ใน alcohol withdrawal seizures (benzodiazepine ดีกว่า)', NULL,
  'hard', 'neurology', 'review',
  'internal_medicine', 'clinical_decision', 'neurology', 'adult',
  'ASAM Clinical Practice Guideline on Alcohol Withdrawal Management 2020; Mayo-Smith MF et al. Arch Intern Med 2004 (CIWA-Ar)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 45 ปี underlying chronic alcoholism มา ED ด้วยอาการสับสน confused ระยะ 3 วัน ก่อนหน้านี้หยุดดื่มสุรามา 5 วัน เพราะรู้สึกไม่สบาย

V/S: BP 168/102, HR 124, RR 22, Temp 38.4°C, SpO2 96%
Gen: tremor, diaphoretic, agitated, ตอบคำถามเพี้ยน เห็น insects ที่ผนัง
GCS 14 (E4V4M6)
ไม่มี focal neurology, neck supple

Lab: Mg 1.2 (low), K 3.1, Na 132, Glucose 88, AST 188, ALT 92, Ammonia 84
CT brain: negative'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 28 ปี ตั้งครรภ์ GA 24 weeks มา OPD ด้วยอาการเหนื่อยเมื่อออกแรงมา 2 สัปดาห์ ก่อนหน้านี้ healthy

V/S: BP 110/72, HR 96, RR 18, SpO2 99%, Temp 36.8°C
Gen: pale, conjunctival pallor +
ไม่มี jaundice, ม้าม-ตับไม่โต

Lab: Hb 7.8 g/dL (baseline 12 ก่อนตั้งครรภ์), MCV 68 fL (low), MCH 22 pg, RDW 18% (high), Reticulocyte 1.2%
Ferritin 8 ng/mL (low), Iron 28 (low), TIBC 480 (high), Transferrin saturation 6%
Vitamin B12 + Folate ปกติ', '[{"label":"A","text":"Blood transfusion ทันที 2 units PRC"},{"label":"B","text":"Oral ferrous sulfate 325 mg TID + vitamin C 250 mg เพื่อเพิ่ม absorption + ตรวจ Hb ซ้ำ 4 สัปดาห์ + counseling diet + investigate cause ของ iron deficiency + ตรวจ thalassemia screening (ระวัง coexistence)"},{"label":"C","text":"IV iron sucrose 200 mg ทุกวันที่ 3 × 3 doses เพราะรุนแรง"},{"label":"D","text":"Erythropoietin SC weekly"},{"label":"E","text":"Bone marrow biopsy เพื่อ rule out aplastic anemia"}]'::jsonb,
  'B', 'ผู้ป่วยมี Iron Deficiency Anemia (IDA) ในการตั้งครรภ์ — microcytic, hypochromic anemia + ferritin < 30 + low transferrin saturation < 16% + high TIBC = classic IDA (ไม่ใช่ thalassemia ที่ ferritin จะปกติ-สูง) WHO + ACOG + RCOG guideline: (1) Oral iron first-line — 100-200 mg elemental iron/วัน (ferrous sulfate 325 mg มี elemental ~65 mg) ในขณะท้องว่าง + vitamin C (acidic environment เพิ่ม absorption) (2) Side effects (constipation, nausea) — start TID หรือ alternate-day (PROVIDE trial 2019 — alternate-day absorption ดีกว่าและ side effect น้อยกว่า) (3) Reticulocyte response ภายใน 1-2 สัปดาห์, Hb ขึ้น 1 g/dL ใน 2-4 สัปดาห์ (4) IV iron ถ้า: ทน oral ไม่ได้, severe (Hb < 7), 3rd trimester, surgery imminent (5) Transfusion ถ้า Hb < 7 + symptomatic, หรือ < 6 (6) Investigate cause: ในไทยต้อง screen thalassemia แยกจาก IDA (อาจ coexist) — ตัวเลือก B ครบ. A ผิด — Hb 7.8 ยังไม่ต้อง transfuse. C ผิด — IV iron เป็น second-line. D ผิด — EPO สำหรับ CKD. E ผิด — IDA classic ไม่ต้อง marrow', NULL,
  'medium', 'hematology', 'review',
  'internal_medicine', 'clinical_decision', 'hematology', 'adult',
  'ACOG Practice Bulletin: Anemia in Pregnancy 2021; British Society for Haematology UK Guidelines on IDA 2021; PROVIDE Trial (Stoffel NU et al. Lancet Haematol 2017)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 28 ปี ตั้งครรภ์ GA 24 weeks มา OPD ด้วยอาการเหนื่อยเมื่อออกแรงมา 2 สัปดาห์ ก่อนหน้านี้ healthy

V/S: BP 110/72, HR 96, RR 18, SpO2 99%, Temp 36.8°C
Gen: pale, conjunctival pallor +
ไม่มี jaundice, ม้าม-ตับไม่โต

Lab: Hb 7.8 g/dL (baseline 12 ก่อนตั้งครรภ์), MCV 68 fL (low), MCH 22 pg, RDW 18% (high), Reticulocyte 1.2%
Ferritin 8 ng/mL (low), Iron 28 (low), TIBC 480 (high), Transferrin saturation 6%
Vitamin B12 + Folate ปกติ'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 72 ปี underlying HT, T2DM, CKD stage 3 มา ED ด้วยปัสสาวะออกน้อยลง 2 วัน + edema เพิ่มขึ้น + nausea

V/S: BP 178/104, HR 88, RR 20, SpO2 96%, Temp 36.8°C
Urine output 6 ชม. = 80 mL
Lab: Cr 4.2 (baseline 1.8), BUN 76, K 5.8, Bicarbonate 18, Hb 10.5
Urinalysis: protein 2+, blood 1+, RBC 5-10/HPF (eumorphic), Granular casts +
Urine Na 8 mEq/L, Urine osm 580, FENa 0.4%
Recent: เริ่ม losartan 100 mg + lisinopril 20 mg + furosemide 40 mg เพิ่ม dose สัปดาห์ที่แล้ว ใช้ ibuprofen 400 mg TID ปวดเข่า 4 วัน', '[{"label":"A","text":"Pre-renal AKI on CKD จาก dehydration + ACEi/ARB/NSAIDs (triple whammy) → หยุด NSAIDs + ลด/หยุด ACEi+ARB ชั่วคราว + ปรับ diuretic + IV fluid replacement carefully (judicious) + manage hyperkalemia + repeat creatinine + nephrology consult ถ้าไม่ดีขึ้น"},{"label":"B","text":"Aggressive IV fluid 200 mL/hr ต่อเนื่อง"},{"label":"C","text":"Hemodialysis ทันที"},{"label":"D","text":"Increase furosemide IV high dose"},{"label":"E","text":"Renal biopsy เพื่อ confirm ATN"}]'::jsonb,
  'A', 'ผู้ป่วยเป็น Acute Kidney Injury on CKD — KDIGO criteria: Cr ↑ 0.3 ภายใน 48 ชม. หรือ 1.5× baseline; ของเรา Cr 4.2 vs 1.8 = 2.3× → AKI Stage 2 Subtype = Pre-renal (FENa < 1% ใน eumorphic urine + low urine Na + concentrated urine osm) — แต่ตอนนี้ไม่ใช่ pure pre-renal เพราะมี granular casts บ่งบอกว่าเริ่มเป็น ATN ตามมา Causative trio: "Triple whammy" = ACEi/ARB (reduce GFR) + diuretic (volume depletion) + NSAIDs (vasoconstrict afferent + reduce prostaglandin-mediated dilation) — synergistic AKI risk Management ตาม KDIGO AKI 2012: (1) Stop nephrotoxins (NSAIDs first) (2) Reduce/hold ACEi+ARB temporarily — รวมจึง 3 ตัวขัดแย้ง (3) Adjust diuretic (4) Fluid replacement judiciously — ระวัง overload เพราะ CKD baseline (5) Treat hyperkalemia (Ca gluconate, insulin/dextrose, kayexalate; HD ถ้าไม่ตอบสนอง) (6) Repeat Cr 24-48 ชม. ติดตาม — ตัวเลือก A ครบ. B ผิด — aggressive fluid เสี่ยง overload. C ผิด — HD ใช้เมื่อ refractory hyperkalemia, severe acidosis, uremic complications, fluid overload — ยังไม่ใช่ขั้นนี้. D ผิด — diuretic เพิ่มจะแย่ลง. E ผิด — biopsy เฉพาะ unclear cases', NULL,
  'medium', 'renal_gu', 'review',
  'internal_medicine', 'clinical_decision', 'renal_gu', 'adult',
  'KDIGO Clinical Practice Guideline for AKI (2012); Loutradis C et al. (Triple Whammy and AKI risk) BMJ 2013', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 72 ปี underlying HT, T2DM, CKD stage 3 มา ED ด้วยปัสสาวะออกน้อยลง 2 วัน + edema เพิ่มขึ้น + nausea

V/S: BP 178/104, HR 88, RR 20, SpO2 96%, Temp 36.8°C
Urine output 6 ชม. = 80 mL
Lab: Cr 4.2 (baseline 1.8), BUN 76, K 5.8, Bicarbonate 18, Hb 10.5
Urinalysis: protein 2+, blood 1+, RBC 5-10/HPF (eumorphic), Granular casts +
Urine Na 8 mEq/L, Urine osm 580, FENa 0.4%
Recent: เริ่ม losartan 100 mg + lisinopril 20 mg + furosemide 40 mg เพิ่ม dose สัปดาห์ที่แล้ว ใช้ ibuprofen 400 mg TID ปวดเข่า 4 วัน'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 35 ปี underlying SLE on hydroxychloroquine + low-dose prednisolone มาด้วยปวดข้อเข่าทั้งสองข้าง + ผื่นแดงที่หน้า ก่อนหน้า 1 สัปดาห์ไปทะเลอาบแดด

V/S: BP 142/88, HR 92, RR 18, Temp 37.8°C
Gen: malar rash + photosensitive
Mild synovitis at knees, mild ankle edema
Urine dipstick: protein 3+, blood 2+

Lab: Hb 9.2, WBC 3,400 (Lymph 980), Plt 92,000, Cr 1.4 (baseline 0.9), Albumin 2.8
Urine: protein/Cr ratio 3.8 g/g, RBC casts +, RBC dysmorphic
C3 ต่ำ, C4 ต่ำ, Anti-dsDNA 480 IU/mL (high), ANA 1:1280', '[{"label":"A","text":"Increase prednisolone oral แล้วนัด follow-up 1 เดือน"},{"label":"B","text":"SLE flare + Class III/IV lupus nephritis (proliferative GN) — admit + Renal biopsy + IV methylprednisolone pulse 500-1000 mg × 3 days → oral prednisolone + Induction immunosuppression (mycophenolate mofetil 2-3 g/วัน หรือ cyclophosphamide) + hydroxychloroquine continue + monitor renal function"},{"label":"C","text":"Continue HCQ อย่างเดียว + sunscreen"},{"label":"D","text":"Rituximab single agent first-line"},{"label":"E","text":"ACEi อย่างเดียวเพื่อ control proteinuria"}]'::jsonb,
  'B', 'ผู้ป่วยมี SLE flare with active Lupus Nephritis (LN) — clinical clues: (1) proteinuria > 0.5 g/24 ชม. (2) active urine sediment (RBC casts, dysmorphic RBC) (3) ↑ Cr (4) low C3/C4 + ↑ Anti-dsDNA ตาม ACR/EULAR 2019 + KDIGO 2024 LN guideline: (1) Renal biopsy เป็น standard — แยก Class III/IV (proliferative) จาก Class V (membranous) เพราะ treatment ต่างกัน (2) Induction therapy (3-6 เดือน) สำหรับ Class III/IV: - High-dose glucocorticoid: IV methylprednisolone pulse → oral pred 0.5-1 mg/kg taper - PLUS one of: MMF 2-3 g/วัน (preferred ใน Asian, less toxicity) หรือ IV cyclophosphamide (Euro-Lupus or NIH regimen) (3) Maintenance (≥ 3 ปี): MMF หรือ azathioprine + low-dose pred (4) Adjuncts: HCQ continue (ลด flare, improve survival, lupus-protective), ACEi/ARB (lower BP target < 130/80, antiproteinuria), statin, sun protection, calcium/vitamin D, vaccination — ตัวเลือก B ครบ. A ผิด — flare + active nephritis ต้อง escalate, not OPD. C ผิด — HCQ alone ไม่พอ. D ผิด — rituximab เป็น refractory option. E ผิด — ACEi เป็น adjunct ไม่ใช่ treatment เดียว', NULL,
  'hard', 'rheumatology', 'review',
  'internal_medicine', 'clinical_decision', 'rheumatology', 'adult',
  'ACR/EULAR Recommendations for LN 2019; KDIGO Clinical Practice Guideline for Lupus Nephritis 2024; Houssiau FA et al. (Euro-Lupus) Arthritis Rheum 2002', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 35 ปี underlying SLE on hydroxychloroquine + low-dose prednisolone มาด้วยปวดข้อเข่าทั้งสองข้าง + ผื่นแดงที่หน้า ก่อนหน้า 1 สัปดาห์ไปทะเลอาบแดด

V/S: BP 142/88, HR 92, RR 18, Temp 37.8°C
Gen: malar rash + photosensitive
Mild synovitis at knees, mild ankle edema
Urine dipstick: protein 3+, blood 2+

Lab: Hb 9.2, WBC 3,400 (Lymph 980), Plt 92,000, Cr 1.4 (baseline 0.9), Albumin 2.8
Urine: protein/Cr ratio 3.8 g/g, RBC casts +, RBC dysmorphic
C3 ต่ำ, C4 ต่ำ, Anti-dsDNA 480 IU/mL (high), ANA 1:1280'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 58 ปี underlying T2DM 15 ปี ไม่ค่อย compliance ยา HbA1c ล่าสุด 11.2%, BP control แย่, สูบบุหรี่ 30 pack-year มาด้วยอาการเจ็บขาขวาเวลาเดิน relief เมื่อพัก เพิ่งเริ่ม 3 เดือน เดินได้ < 100 m

V/S: BP 168/96, HR 84, ABI right 0.62, left 0.85
Femoral pulse ขวา weak, popliteal absent, dorsalis pedis absent
ผิวหนังเท้าขวา cool, hair loss, slow capillary refill
ไม่มี ulcer, ไม่มี rest pain', '[{"label":"A","text":"Refer vascular surgery ทันทีเพื่อ revascularization"},{"label":"B","text":"Optimize medical therapy: statin (atorvastatin 80 mg) + antiplatelet (aspirin 81 mg หรือ clopidogrel 75 mg) + smoking cessation + structured exercise program (supervised walking) + glycemic control + BP control + cilostazol สำหรับ claudication; revascularization reserved สำหรับ lifestyle-limiting claudication หลัง medical fail หรือ critical limb ischemia"},{"label":"C","text":"Long-term anticoagulation with warfarin"},{"label":"D","text":"Pentoxifylline as first-line agent"},{"label":"E","text":"Avoid exercise — bed rest จะช่วย"}]'::jsonb,
  'B', 'Peripheral Arterial Disease (PAD) — symptomatic intermittent claudication, ABI < 0.9 confirms PAD (0.62 = moderate-severe) AHA/ACC 2016 + ESC 2017 PAD guideline lifestyle-limiting claudication management: (1) Risk factor modification (foundational): - **Smoking cessation** (single most effective intervention — reduces amputation, MI, mortality) - **Statin high-intensity** (atorvastatin 40-80 mg) — reduces cardiovascular events + improves walking distance - **Glycemic control** (HbA1c < 7% if safe) - **BP control** (< 130/80; ACEi preferred) - **Antiplatelet** (aspirin หรือ clopidogrel) reduces MI/stroke (2) Symptom control: - **Supervised exercise therapy** (35-50 นาที × 3 ครั้ง/สัปดาห์ × 12 สัปดาห์) — Class I, increases walking distance more than meds - **Cilostazol** 100 mg BID — phosphodiesterase III inhibitor; contraindicated in CHF (3) Revascularization (endovascular หรือ surgical) เฉพาะ: lifestyle-limiting claudication ที่ medical fail, critical limb-threatening ischemia (rest pain, tissue loss, gangrene) — ตัวเลือก B ครบและสะท้อน guideline-directed therapy. A ผิด — surgery ไม่ใช่ first-line ใน claudication ที่ไม่ critical. C ผิด — warfarin ไม่ improve outcomes ใน PAD. D ผิด — pentoxifylline weak evidence. E ผิดอย่างยิ่ง — exercise ช่วย ไม่ใช่ bed rest', NULL,
  'medium', 'cardiovascular', 'review',
  'internal_medicine', 'clinical_decision', 'cardiovascular', 'adult',
  'AHA/ACC 2016 Guideline for the Management of Patients with Lower Extremity Peripheral Artery Disease; ESC/ESVS 2017 Guidelines on the Diagnosis and Treatment of PAD', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 58 ปี underlying T2DM 15 ปี ไม่ค่อย compliance ยา HbA1c ล่าสุด 11.2%, BP control แย่, สูบบุหรี่ 30 pack-year มาด้วยอาการเจ็บขาขวาเวลาเดิน relief เมื่อพัก เพิ่งเริ่ม 3 เดือน เดินได้ < 100 m

V/S: BP 168/96, HR 84, ABI right 0.62, left 0.85
Femoral pulse ขวา weak, popliteal absent, dorsalis pedis absent
ผิวหนังเท้าขวา cool, hair loss, slow capillary refill
ไม่มี ulcer, ไม่มี rest pain'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 42 ปี HIV positive (CD4 = 38 cells/μL), ไม่ compliance ART มา ED ด้วยปวดศีรษะรุนแรง + ไข้ + คอแข็ง onset 5 วัน ค่อย ๆ แย่ลง วันนี้สับสน

V/S: BP 124/76, HR 102, RR 22, Temp 39.0°C, SpO2 97%
GCS 13 (E3V4M6), neck stiffness +
Kernig sign positive, Brudzinski +
ไม่มี focal neurology, ไม่มี papilledema

Lab: WBC 4,800, Hb 11.2, Plt 168,000, Cr 1.0, Na 132
CT brain non-contrast: no mass effect, no hydrocephalus, no abscess

Lumbar puncture: opening pressure 38 cmH2O (very high), WBC 25 (mononuclear predominant), Protein 88, Glucose 32 (serum 92), India ink + (encapsulated yeasts), Cryptococcal antigen positive (titer 1:512)', '[{"label":"A","text":"Empirical antibacterial coverage (ceftriaxone + vancomycin) + observe"},{"label":"B","text":"Induction therapy: IV Amphotericin B (liposomal 3-4 mg/kg/day) + Flucytosine (100 mg/kg/วัน) × 2 weeks → consolidation Fluconazole 800 mg/day × 8 weeks → maintenance fluconazole 200 mg/วัน + serial therapeutic LP เพื่อลด ICP + delay ART 4-6 weeks เพื่อหลีก IRIS"},{"label":"C","text":"Restart ART ทันทีเพื่อ recover immunity"},{"label":"D","text":"Fluconazole monotherapy 400 mg/วัน"},{"label":"E","text":"Steroid IV ทันทีเพื่อ reduce CNS inflammation"}]'::jsonb,
  'B', 'Cryptococcal Meningitis (CrM) ใน AIDS — India ink + capsule + CrAg + CD4 < 100 IDSA + WHO 2022 Cryptococcal Disease guideline: (1) Induction phase (2 สัปดาห์): - Liposomal Amphotericin B 3-4 mg/kg/วัน + 5-Flucytosine 100 mg/kg/วัน (Cochrane evidence: combo > monotherapy, reduces mortality) - Alternative ถ้า amphotericin ไม่ได้: high-dose fluconazole 1200 mg/วัน + flucytosine - WHO recently: single dose Liposomal Amphotericin 10 mg/kg + 14 days fluconazole + flucytosine (AMBITION trial 2022) (2) Consolidation (8 สัปดาห์): Fluconazole 800 mg/วัน (3) Maintenance (> 1 ปี ถึง CD4 > 100 สม่ำเสมอ): Fluconazole 200 mg/วัน (4) Manage raised ICP: serial therapeutic LPs (target OP < 20 cm) — independent predictor ของ survival (5) ART delay 4-6 สัปดาห์ — premature ART = IRIS + worse outcomes (COAT trial 2014) — ตัวเลือก B ครบ. A ผิด — bacterial meningitis เป็น different pathogen. C ผิด — IRIS risk. D ผิด — monotherapy inferior. E ผิด — steroid ใน CrM IRIS เฉพาะ severe CNS IRIS — ไม่ใช่ initial', NULL,
  'hard', 'id', 'review',
  'internal_medicine', 'clinical_decision', 'id', 'adult',
  'WHO Guidelines for Diagnosing, Preventing and Managing Cryptococcal Disease 2022; IDSA Practice Guideline for the Management of Cryptococcal Disease 2010; AMBITION-cm Trial (Jarvis JN et al. NEJM 2022); COAT Trial NEJM 2014', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 42 ปี HIV positive (CD4 = 38 cells/μL), ไม่ compliance ART มา ED ด้วยปวดศีรษะรุนแรง + ไข้ + คอแข็ง onset 5 วัน ค่อย ๆ แย่ลง วันนี้สับสน

V/S: BP 124/76, HR 102, RR 22, Temp 39.0°C, SpO2 97%
GCS 13 (E3V4M6), neck stiffness +
Kernig sign positive, Brudzinski +
ไม่มี focal neurology, ไม่มี papilledema

Lab: WBC 4,800, Hb 11.2, Plt 168,000, Cr 1.0, Na 132
CT brain non-contrast: no mass effect, no hydrocephalus, no abscess

Lumbar puncture: opening pressure 38 cmH2O (very high), WBC 25 (mononuclear predominant), Protein 88, Glucose 32 (serum 92), India ink + (encapsulated yeasts), Cryptococcal antigen positive (titer 1:512)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 28 ปี ตรวจสุขภาพประจำปีพบ AST 78, ALT 92 (URL 40), GGT 88, ALP 110, Bilirubin 1.0 ก่อนหน้านี้ปกติ ผู้ป่วย asymptomatic ไม่มีโรคประจำตัว ไม่ดื่มสุรา ไม่ได้กินยาใหม่

BMI 32 kg/m², waist 102 cm
Fasting glucose 108, HbA1c 6.2%, Triglyceride 285, HDL 32, LDL 142
US abdomen: hepatomegaly + diffuse hyperechoic texture ("bright liver") consistent with steatosis, no focal lesion

HBsAg neg, Anti-HCV neg, Iron studies normal, ANA neg, IgG normal', '[{"label":"A","text":"Hepatitis A vaccine + observe ใน 6 เดือน"},{"label":"B","text":"Lifestyle modification: weight loss 7-10% (mediterranean diet + caloric restriction + exercise 150 min/wk moderate) + manage metabolic syndrome (statin OK ใน NAFLD ไม่ contraindicate) + screen for fibrosis (FIB-4, NAFLD Fibrosis Score, transient elastography); ถ้า FIB-4 > 2.67 หรือ elastography > 8 kPa → hepatologist consult + biopsy พิจารณา; ยังไม่มี FDA-approved drug routine (อาจ vitamin E 800 IU ใน selected non-diabetic biopsy-proven NASH)"},{"label":"C","text":"Pioglitazone first-line"},{"label":"D","text":"Ursodeoxycholic acid 15 mg/kg/วัน"},{"label":"E","text":"Refer transplant"}]'::jsonb,
  'B', 'ผู้ป่วยเป็น Non-Alcoholic Fatty Liver Disease (NAFLD) / MAFLD (Metabolic Associated Fatty Liver Disease) — obesity + insulin resistance + dyslipidemia + steatosis + ↑ transaminase (ALT > AST pattern in NAFLD; AST > ALT in alcoholic) AASLD 2018 + EASL 2024 NAFLD/MAFLD guideline: (1) Lifestyle (cornerstone): - Weight loss 7-10% ของ body weight reverses steatosis และ NASH histology (Promrat K et al.) - Mediterranean diet - Aerobic + resistance exercise 150-300 min/wk - ลด fructose, processed food (2) Comorbidity management: - Lipids: statin safe ใน NAFLD (myth ที่ statin contraindicate — actually แนะนำใช้) - Diabetes: metformin ไม่ improve liver histology แต่ overall benefit; GLP-1 agonist (semaglutide, liraglutide) + SGLT2 inhibitor — emerging evidence (3) Fibrosis assessment: - Non-invasive: FIB-4, NAFLD Fibrosis Score, transient elastography (FibroScan), MRE - Biopsy: selected ใน intermediate scores หรือ progression (4) Pharmacotherapy: - Vitamin E 800 IU/วัน ใน biopsy-proven NASH non-diabetic (PIVENS trial) - Pioglitazone: NASH improvement but weight gain — selected - Resmetirom (FDA approved 2024): for non-cirrhotic NASH F2-F3 — ตัวเลือก B comprehensive. A ผิด — vaccinate good แต่ละเลย main issue. C ผิด — pioglitazone ไม่ใช่ first-line. D ผิด — UDCA ใน NAFLD ไม่ improve histology. E ผิด — ไม่ใช่ end-stage', NULL,
  'medium', 'gi', 'review',
  'internal_medicine', 'clinical_decision', 'gi', 'adult',
  'AASLD Practice Guidance on NAFLD 2018; EASL Clinical Practice Guidelines on Management of NAFLD/MAFLD 2024; Promrat K et al. Hepatology 2010 (Weight Loss in NASH); PIVENS Trial NEJM 2010', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 28 ปี ตรวจสุขภาพประจำปีพบ AST 78, ALT 92 (URL 40), GGT 88, ALP 110, Bilirubin 1.0 ก่อนหน้านี้ปกติ ผู้ป่วย asymptomatic ไม่มีโรคประจำตัว ไม่ดื่มสุรา ไม่ได้กินยาใหม่

BMI 32 kg/m², waist 102 cm
Fasting glucose 108, HbA1c 6.2%, Triglyceride 285, HDL 32, LDL 142
US abdomen: hepatomegaly + diffuse hyperechoic texture ("bright liver") consistent with steatosis, no focal lesion

HBsAg neg, Anti-HCV neg, Iron studies normal, ANA neg, IgG normal'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 65 ปี underlying T2DM, HT, CKD stage 3 (eGFR 42) มา OPD เพื่อปรับยา DM ปัจจุบัน HbA1c 8.4%, BP 142/88 mmHg, BMI 31, urine microalbumin/Cr 145 mg/g (moderately increased)

Group of medications: metformin 1000 mg BID, glipizide 10 mg BID, lisinopril 20 mg/วัน, amlodipine 5 mg/วัน, atorvastatin 40 mg

ต้องการเพิ่มยา DM 1 ตัวเพื่อ better glycemic control', '[{"label":"A","text":"Insulin glargine basal — เพิ่มเป็น first preference"},{"label":"B","text":"SGLT2 inhibitor (empagliflozin หรือ dapagliflozin) — provides glycemic + cardio-renal protection (reduces MACE, HF hospitalization, CKD progression) ใน patients with diabetes + CKD + albuminuria, even with metformin already optimized; check eGFR cutoff (initiate at eGFR ≥ 20-30) + monitor for euglycemic DKA, UTI, volume depletion"},{"label":"C","text":"Sulfonylurea (เพิ่มขึ้น) — glipizide เป็น 20 mg"},{"label":"D","text":"Pioglitazone 30 mg/วัน"},{"label":"E","text":"DPP-4 inhibitor (sitagliptin) — neutral cardiovascular profile"}]'::jsonb,
  'B', 'ผู้ป่วยมี T2DM + CKD + albuminuria + HT — high cardiovascular และ renal risk ADA 2024 Standards of Care + KDIGO 2022 Diabetes in CKD + AHA/ACC guideline: เลือก antihyperglycemic ตาม comorbidity ก่อน HbA1c lowering: 1. **SGLT2 inhibitors** (empagliflozin, dapagliflozin, canagliflozin) — preferred ใน: - CKD with albuminuria (eGFR > 20) — slows CKD progression (EMPA-KIDNEY, DAPA-CKD, CREDENCE trials) - Heart failure (DAPA-HF, EMPEROR-Reduced/Preserved) - ASCVD high risk - Weight loss + BP lowering benefits 2. **GLP-1 receptor agonists** (semaglutide, dulaglutide, liraglutide) — preferred ใน: - ASCVD (LEADER, SUSTAIN-6, REWIND, AMPLITUDE-O) - Obesity (weight loss benefit) 3. Metformin: continue if eGFR > 30 (caution > 30, hold > 45 mostly) 4. Sulfonylurea: hypoglycemia risk ใน elderly + CKD — avoid 5. Pioglitazone: weight gain, edema, bladder cancer concern, HF — caution 6. DPP-4 inhibitor: neutral CV — okay but no benefit beyond glucose 7. Insulin: lowest priority unless severe — ตัวเลือก B comprehensive และ guideline-concordant. A ผิด — insulin ไม่ใช่ first preference. C ผิด — SU เพิ่ม hypoglycemia + ไม่มี CV/renal benefit. D ผิด — pioglitazone เสี่ยง HF + edema ใน CKD. E ผิด — DPP-4 inferior ต่อ SGLT2/GLP-1 ใน this patient', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'internal_medicine', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'ADA Standards of Care in Diabetes 2024; KDIGO 2022 Clinical Practice Guideline for Diabetes Management in CKD; EMPA-KIDNEY NEJM 2023; DAPA-CKD NEJM 2020; CREDENCE NEJM 2019', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 65 ปี underlying T2DM, HT, CKD stage 3 (eGFR 42) มา OPD เพื่อปรับยา DM ปัจจุบัน HbA1c 8.4%, BP 142/88 mmHg, BMI 31, urine microalbumin/Cr 145 mg/g (moderately increased)

Group of medications: metformin 1000 mg BID, glipizide 10 mg BID, lisinopril 20 mg/วัน, amlodipine 5 mg/วัน, atorvastatin 40 mg

ต้องการเพิ่มยา DM 1 ตัวเพื่อ better glycemic control'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 56 ปี underlying HT, T2DM มาด้วยอาการ shortness of breath ขั้นรุนแรง + crackles ทั้งสองข้างปอด + bilateral pedal edema เป็นมา 3 ชั่วโมง ก่อนหน้านี้ adherent ต่อยา

V/S: BP 218/124 mmHg, HR 112, RR 30, SpO2 86% room air, Temp 36.7°C
PE: JVP 14, S3 gallop, fine crackles 3/4 ของปอด, no focal neurology

CXR: pulmonary edema bilateral, cardiomegaly
EKG: LVH with strain pattern, no ST changes
Troponin 0.04 (URL 0.04), BNP 1,200
Fundoscopy: papilledema + flame hemorrhages', '[{"label":"A","text":"Oral captopril + sublingual NTG"},{"label":"B","text":"Hypertensive emergency with acute pulmonary edema — IV nitroglycerin (start 10 mcg/min titrate to BP) + IV furosemide + non-invasive ventilation (BiPAP) + reduce MAP by 25% ใน 1 ชม. แรก (target ~ MAP 110) ไม่ aggressive เกิน + ICU monitoring; avoid hydralazine ใน acute LV failure"},{"label":"C","text":"IV labetalol bolus + observe"},{"label":"D","text":"IV nitroprusside without arterial line monitoring"},{"label":"E","text":"Reduce BP to normal (120/80) within 1 hour"}]'::jsonb,
  'B', 'Hypertensive emergency (BP > 180/120 + end-organ damage: pulmonary edema, papilledema, retinal hemorrhage) AHA 2017 + JNC 8 + ESC hypertension guideline: (1) Reduce MAP by 20-25% ใน 1 ชม. แรก, then to 160/100 ใน 2-6 ชม., gradual normalization ใน 24-48 ชม. — aggressive reduction → cerebral/coronary/renal ischemia (2) Choice of agent depends on end-organ: - Acute pulmonary edema/HF: **IV nitroglycerin** (venodilator → reduce preload + afterload), **furosemide**, NIV - Aortic dissection: labetalol + esmolol (HR control), IV nitroprusside - Acute neurological (stroke): nicardipine, labetalol - Pheochromocytoma: phentolamine + beta-blocker - Eclampsia: hydralazine, labetalol, MgSO4 (3) Avoid in pulmonary edema: - Hydralazine (reflex tachycardia, increased CO worsens edema) - Beta-blocker IV monotherapy (negative inotrope) (4) NIV (BiPAP) for cardiogenic pulmonary edema (5) Continuous arterial line monitoring ใน ICU — ตัวเลือก B ครบ. A ผิด — oral onset ช้า ใน emergency. C ผิด — labetalol IV ไม่ดีใน acute LV failure. D ผิด — nitroprusside ต้องมี arterial line + cyanide concern long use. E ผิด — ลด BP เร็วเกินไป', NULL,
  'medium', 'cardiovascular', 'review',
  'internal_medicine', 'clinical_decision', 'cardiovascular', 'adult',
  'AHA/ACC 2017 Guideline for the Prevention, Detection, Evaluation, and Management of High Blood Pressure in Adults; ESC/ESH 2018 Guidelines for the Management of Arterial Hypertension', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 56 ปี underlying HT, T2DM มาด้วยอาการ shortness of breath ขั้นรุนแรง + crackles ทั้งสองข้างปอด + bilateral pedal edema เป็นมา 3 ชั่วโมง ก่อนหน้านี้ adherent ต่อยา

V/S: BP 218/124 mmHg, HR 112, RR 30, SpO2 86% room air, Temp 36.7°C
PE: JVP 14, S3 gallop, fine crackles 3/4 ของปอด, no focal neurology

CXR: pulmonary edema bilateral, cardiomegaly
EKG: LVH with strain pattern, no ST changes
Troponin 0.04 (URL 0.04), BNP 1,200
Fundoscopy: papilledema + flame hemorrhages'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 35 ปี HIV-negative, ไม่มีโรคประจำตัว ทำงาน health worker ที่โรงพยาบาล มาด้วยอาการไอเรื้อรัง > 3 สัปดาห์ ร่วมกับน้ำหนักลด 5 kg, ไข้ต่ำตอนเย็น, เหงื่อออกตอนกลางคืน

V/S: BP 118/72, HR 88, RR 18, SpO2 96% room air, Temp 37.8°C, น้ำหนัก 58 kg (จาก 63)
PE: ฟัง crackles RUL

CXR: cavitary lesion ที่ right upper lobe + fibronodular infiltrate
Sputum AFB × 3: positive 2+ ทั้ง 3 specimen
Sputum GeneXpert MTB/RIF: MTB detected, Rifampin sensitive
HIV test: negative
CBC + LFT + Cr ปกติ', '[{"label":"A","text":"Isoniazid + Rifampin × 6 เดือน เท่านั้น"},{"label":"B","text":"Initial 4-drug regimen (Isoniazid + Rifampin + Pyrazinamide + Ethambutol) × 2 เดือน intensive phase → Continuation (Isoniazid + Rifampin) × 4 เดือน = total 6 เดือน + ตรวจ baseline LFT, vision (ethambutol), uric acid + DOT (Directly Observed Therapy) + contact tracing + report to public health"},{"label":"C","text":"Treatment regimen 9 months 4-drug ทั้ง regimen"},{"label":"D","text":"Empirical antibiotic for community-acquired pneumonia ก่อน"},{"label":"E","text":"Surgery to remove cavitary lesion"}]'::jsonb,
  'B', 'Pulmonary TB confirmed (AFB + GeneXpert positive, Rifampin sensitive) WHO + Thai National TB Program + ATS/CDC/IDSA 2016 guideline: (1) **Standard regimen for drug-susceptible pulmonary TB (Category I)**: - **Intensive phase (2 เดือน)**: Isoniazid (H) + Rifampin (R) + Pyrazinamide (Z) + Ethambutol (E) - **Continuation phase (4 เดือน)**: Isoniazid + Rifampin - Total 6 เดือน (DS-TB pulmonary) (2) **Adjuncts**: - Pyridoxine (vitamin B6) 25-50 mg/day with INH to prevent peripheral neuropathy - Baseline LFT (hepatotoxicity from H/R/Z), uric acid (Z), eye exam (E — optic neuritis), Cr (3) **DOT** (Directly Observed Therapy) — improves adherence, reduces resistance development (4) **Contact tracing** + report to Public Health (notifiable disease) (5) **HIV testing** (must in all TB) — negative here (6) **Monitor**: monthly clinical, sputum AFB at 2 months (smear conversion), LFT 2 weeks then monthly, weight/symptom (7) MDR/XDR-TB: longer (18-24 months), 2nd line drugs — สำหรับ resistant case ไม่ใช่กรณีนี้ — ตัวเลือก B comprehensive. A ผิด — INH + Rif alone ไม่ใช่ standard. C ผิด — 9 months ใช้ใน selected (extrapulmonary, slow response). D ผิด — TB confirmed ไม่ต้อง CAP empirical. E ผิด — surgery เฉพาะ refractory MDR-TB', NULL,
  'easy', 'id', 'review',
  'internal_medicine', 'clinical_decision', 'id', 'adult',
  'WHO Consolidated Guidelines on Tuberculosis 2022; ATS/CDC/IDSA Clinical Practice Guidelines: Treatment of Drug-Susceptible Tuberculosis (CID 2016); Thailand National TB Program Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 35 ปี HIV-negative, ไม่มีโรคประจำตัว ทำงาน health worker ที่โรงพยาบาล มาด้วยอาการไอเรื้อรัง > 3 สัปดาห์ ร่วมกับน้ำหนักลด 5 kg, ไข้ต่ำตอนเย็น, เหงื่อออกตอนกลางคืน

V/S: BP 118/72, HR 88, RR 18, SpO2 96% room air, Temp 37.8°C, น้ำหนัก 58 kg (จาก 63)
PE: ฟัง crackles RUL

CXR: cavitary lesion ที่ right upper lobe + fibronodular infiltrate
Sputum AFB × 3: positive 2+ ทั้ง 3 specimen
Sputum GeneXpert MTB/RIF: MTB detected, Rifampin sensitive
HIV test: negative
CBC + LFT + Cr ปกติ'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 75 ปี underlying multiple myeloma, recent chemotherapy มา ED ด้วยอาการสับสน เพ้อ ดื่มน้ำมาก ปัสสาวะเยอะ ก่อนหน้านี้ 1 สัปดาห์ปวดหลังรุนแรง

V/S: BP 102/64, HR 102, RR 18, Temp 36.8°C, SpO2 97%
Gen: dry mucous membrane, lethargic but arousable
GCS 13, neuro non-focal

Lab: Ca total 14.8 mg/dL (corrected for albumin 2.6 → corrected Ca 15.9), Phosphate 4.8, Cr 2.4 (baseline 1.0), Albumin 2.6, Alkaline phosphatase 285, PTH < 10 (suppressed), PTH-rP 88 pmol/L (elevated)
EKG: short QT interval', '[{"label":"A","text":"Mild restriction of fluid + observe"},{"label":"B","text":"Severe hypercalcemia (corrected Ca > 14 + symptomatic) — IV normal saline aggressive (200-300 mL/hr) + once euvolemic add loop diuretic (furosemide) + IV bisphosphonate (zoledronate 4 mg IV — onset 2-4 days) OR Denosumab (faster ใน CKD) + calcitonin SC/IM (rapid 2-6 hr action) bridging + treat underlying malignancy + monitor electrolytes"},{"label":"C","text":"Calcium gluconate to correct electrolyte"},{"label":"D","text":"Aggressive hemodialysis without prior fluid"},{"label":"E","text":"Steroid alone — IV dexamethasone 8 mg"}]'::jsonb,
  'B', 'Hypercalcemia of malignancy (HCM) — most common cause of hypercalcemia in hospital setting; in MM = osteolytic + PTH-rP mediated; suppressed PTH ruled out primary hyperparathyroidism Severity: - Mild: Ca 10.5-12 mg/dL (often asymptomatic) - Moderate: 12-14 mg/dL - Severe: > 14 mg/dL (symptomatic, requires aggressive Rx) Management ตาม Endocrine Society + ASCO + KDIGO: 1. **Aggressive IV hydration** (NSS 200-300 mL/hr first, then maintain euvolemia ~ 100-150 mL/hr) — restores GFR, dilutes Ca, promotes renal excretion 2. **Loop diuretic (furosemide)** — only AFTER euvolemia restored (without rehydration first → worsens hypovolemia + Ca) 3. **Bisphosphonates** (zoledronate 4 mg IV over 15 min, or pamidronate 60-90 mg over 2 hr) — onset 2-4 days, lasts weeks; adjust ใน renal impairment 4. **Denosumab** (RANK-L inhibitor) — alternative bisphosphonate ใน CKD severe (no renal adjustment), faster onset ใน some cases 5. **Calcitonin** (4 IU/kg SC/IM q12h) — rapid (2-6 hr) but tachyphylaxis ใน 48 hr; bridge until bisphosphonate works 6. **Glucocorticoid** — effective ใน vit D-mediated (sarcoid, lymphoma, MM somewhat), reduces 1,25-vit D 7. **Hemodialysis** — refractory case, low-Ca dialysate; ใช้เมื่อ life-threatening + AKI + can''t tolerate fluid 8. **Treat underlying malignancy** essential — ตัวเลือก B comprehensive. A ผิดอย่างยิ่ง — severe symptomatic = emergency. C ผิดอย่างยิ่ง — give Ca ใน hyper-Ca = lethal. D ผิด — HD ก่อน fluid resuscitation ผิด sequence. E ผิด — steroid alone insufficient + slow onset', NULL,
  'hard', 'endocrine_metabolic', 'review',
  'internal_medicine', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'Endocrine Society Clinical Practice Guideline: Hypercalcemia of Malignancy 2014 (Stewart); ASCO/Cancer Care Ontario Guidelines on Bisphosphonates and Bone Health', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 75 ปี underlying multiple myeloma, recent chemotherapy มา ED ด้วยอาการสับสน เพ้อ ดื่มน้ำมาก ปัสสาวะเยอะ ก่อนหน้านี้ 1 สัปดาห์ปวดหลังรุนแรง

V/S: BP 102/64, HR 102, RR 18, Temp 36.8°C, SpO2 97%
Gen: dry mucous membrane, lethargic but arousable
GCS 13, neuro non-focal

Lab: Ca total 14.8 mg/dL (corrected for albumin 2.6 → corrected Ca 15.9), Phosphate 4.8, Cr 2.4 (baseline 1.0), Albumin 2.6, Alkaline phosphatase 285, PTH < 10 (suppressed), PTH-rP 88 pmol/L (elevated)
EKG: short QT interval'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 45 ปี ไม่มีโรคประจำตัว มาด้วยอาการ acute onset ปวดข้อเท้าซ้ายอย่างรุนแรง บวมแดงร้อน 8 ชั่วโมงก่อน ก่อนหน้านี้กินอาหารทะเลและดื่ม craft beer มาก

V/S: BP 142/88, HR 92, RR 16, Temp 37.6°C
PE: 1st MTP joint ซ้าย: erythema, swelling, exquisite tenderness, ROM ลด

Lab: WBC 11,800, ESR 56, CRP 24, Uric acid 8.6, Cr 1.0
Joint aspiration: WBC 18,000 (PMN 78%), polarized light: negatively birefringent needle-shaped crystals + intracellular
Culture pending', '[{"label":"A","text":"Allopurinol 300 mg start ทันที + observe"},{"label":"B","text":"Acute Gout flare confirmed by crystal analysis — first-line: NSAID (indomethacin 50 mg TID หรือ naproxen 500 mg BID) ถ้าไม่มี contraindication; OR colchicine 1.2 mg → 0.6 mg ใน 1 ชม. OR oral/intra-articular glucocorticoid — choice based on comorbidities; do NOT initiate urate-lowering during flare; once resolved discuss long-term ULT (allopurinol/febuxostat) ถ้า indications (≥2 attacks/yr, tophi, CKD3+, urolithiasis) + lifestyle (avoid purine, alcohol, fructose)"},{"label":"C","text":"IV antibiotic for septic arthritis empirically"},{"label":"D","text":"Joint surgery ทันที"},{"label":"E","text":"Aspirin high-dose 4 g/day"}]'::jsonb,
  'B', 'Acute gout — pathognomonic crystal (monosodium urate — negatively birefringent needle-shaped) ใน 1st MTP (podagra) — classic ACR 2020 Gout Management Guideline + EULAR 2016: 1. **Acute flare treatment** (any of, choice by comorbidity, side effect): - **NSAIDs** (indomethacin, naproxen, ibuprofen) — first-line if no contraindication (CKD, PUD, HF, anticoagulation) - **Colchicine** — loading 1.2 mg then 0.6 mg in 1 hr (low-dose regimen = high-dose regimen efficacy with fewer side effects per AGREE trial); avoid if severe CKD or strong CYP3A4 inhibitors - **Glucocorticoid** (oral pred 30-40 mg/วัน taper × 5-10 วัน, IM, intra-articular) — preferred in CKD, PUD, anticoagulation - **Anti-IL-1 (anakinra, canakinumab)** — refractory cases 2. **Important**: Do NOT initiate urate-lowering therapy (ULT) during acute flare (may worsen/prolong) — BUT do not stop ULT if patient already on it 3. **Long-term ULT indications** (after flare resolution): - ≥ 2 attacks/year - Tophi - CKD stage ≥ 3 - History of urolithiasis - Target uric acid < 6 mg/dL (< 5 if tophi) - Allopurinol first-line (start 100 mg/day, titrate); HLA-B*5801 screen ใน Asian (high risk SJS) — Thai have high prevalence - Alternative: febuxostat (caution ใน ASCVD per CARES) - Probenecid: uricosuric (avoid in CKD, urolithiasis) 4. **Flare prophylaxis during ULT initiation** (3-6 months): low-dose colchicine 0.6 mg/d or NSAID — prevents mobilization flares 5. **Lifestyle**: low purine, less alcohol (especially beer), avoid fructose-sweetened drinks, weight loss, hydration — ตัวเลือก B comprehensive. A ผิดอย่างยิ่ง — allopurinol during flare = worsens. C ผิด — crystals confirmed gout + culture pending (low fever doesn''t suggest sepsis primarily). D ผิด — no surgery indication. E ผิด — aspirin ↑ uric acid', NULL,
  'medium', 'rheumatology', 'review',
  'internal_medicine', 'clinical_decision', 'rheumatology', 'adult',
  'ACR 2020 Guideline for the Management of Gout (Arthritis Care Res); EULAR Evidence-Based Recommendations for the Management of Gout 2016', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 45 ปี ไม่มีโรคประจำตัว มาด้วยอาการ acute onset ปวดข้อเท้าซ้ายอย่างรุนแรง บวมแดงร้อน 8 ชั่วโมงก่อน ก่อนหน้านี้กินอาหารทะเลและดื่ม craft beer มาก

V/S: BP 142/88, HR 92, RR 16, Temp 37.6°C
PE: 1st MTP joint ซ้าย: erythema, swelling, exquisite tenderness, ROM ลด

Lab: WBC 11,800, ESR 56, CRP 24, Uric acid 8.6, Cr 1.0
Joint aspiration: WBC 18,000 (PMN 78%), polarized light: negatively birefringent needle-shaped crystals + intracellular
Culture pending'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 38 ปี underlying hyperthyroidism on methimazole มา ED ด้วยอาการเหนื่อย ใจสั่นมาก เหงื่อแตก ไข้สูง สับสน เริ่มอาเจียน 12 ชม. ก่อนหน้านี้มี influenza-like illness 3 วัน หยุดยา methimazole มา 1 สัปดาห์ก่อนเพราะลืม

V/S: BP 168/86 mmHg, HR 168 (AF rapid response), RR 28, SpO2 97%, Temp 39.8°C
Gen: agitated, diaphoretic, fine tremor
Neuro: GCS 13, no focal deficits
Thyroid: enlarged smooth, no nodules, ไม่มี bruit

Lab: TSH < 0.01 (very suppressed), Free T4 5.8 (5×ULN), Free T3 18 (high), WBC 14,200
EKG: AF rate 168, no ST changes', '[{"label":"A","text":"Restart methimazole 20 mg และ rate control"},{"label":"B","text":"Thyroid Storm (Burch-Wartofsky score > 45 — diagnostic) — admit ICU; sequential therapy: (1) **Beta-blocker** propranolol IV 1 mg slow push, repeat q5-10 min OR esmolol drip (blocks T4→T3 conversion + symptomatic) (2) **Antithyroid drug** PTU 500-1000 mg loading then 250 mg q4h (preferred — blocks T4→T3) OR methimazole 60-80 mg (3) **Iodine** (Lugol''s or SSKI) at least 1 hour AFTER antithyroid (4) **Glucocorticoid** hydrocortisone 100 mg IV q8h (blocks T4→T3 + treats potential adrenal insufficiency) (5) **Supportive**: cooling (acetaminophen, NOT aspirin which displaces T4 from TBG), IV fluid, treat precipitant (here: infection — work up) (6) **Identify trigger**: infection, surgery, trauma, DKA, MI, withdrawal of antithyroid"},{"label":"C","text":"Aspirin 650 mg PR for fever + sedation only"},{"label":"D","text":"Thyroidectomy emergent"},{"label":"E","text":"Iodine first then antithyroid"}]'::jsonb,
  'B', 'Thyroid Storm — life-threatening hyperthyroidism with multi-organ decompensation Diagnosis: Burch-Wartofsky Point Scale (BWPS): - Temperature 39.8°C → 30 pts - HR 168 → 25 pts - Atrial fibrillation → 10 pts - CNS agitation/confusion → 20 pts - GI dysfunction (vomiting) → 10 pts - Precipitant (infection, missed doses) → 10 pts Total > 45 = highly suggestive thyroid storm Mortality 10-30% if untreated — emergency Treatment sequence is critical (Endocrine Society + JTA Japan Thyroid Association guideline): 1. **Beta-blocker FIRST** — propranolol IV (blocks T4→T3 conversion, controls cardiac symptoms); avoid IV propranolol if CHF (use esmolol — short-acting, titratable) 2. **Antithyroid drug** (Thionamides) — blocks new hormone synthesis: - **PTU** preferred initially (also blocks peripheral T4→T3) - **Methimazole** longer half-life but no T4→T3 blockade 3. **Iodine** (Lugol''s, SSKI) — blocks release of pre-formed hormone; MUST be given at least 1 hour after antithyroid (else iodine fuels more hormone synthesis — Wolff-Chaikoff vs Jod-Basedow paradox) 4. **Glucocorticoid** (hydrocortisone) — blocks T4→T3, treats relative adrenal insufficiency 5. **Cooling** with acetaminophen + cooling blankets (ASPIRIN CONTRAINDICATED — displaces T4 from TBG → worse storm) 6. **Identify and treat precipitant** (infection most common; here: flu-like) 7. **Supportive ICU** care: fluid, electrolytes, nutrition, treat AF — ตัวเลือก B comprehensive correct sequence. A ผิด — under-treats severe storm. C ผิดอย่างยิ่ง — aspirin contraindicated. D ผิด — surgery refractory option. E ผิด — sequence wrong (iodine before antithyroid = worse)', NULL,
  'hard', 'endocrine_metabolic', 'review',
  'internal_medicine', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'Burch HB, Wartofsky L. Endocrinol Metab Clin North Am 1993 (BWPS); American Thyroid Association Guidelines for Diagnosis and Management of Hyperthyroidism 2016', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 38 ปี underlying hyperthyroidism on methimazole มา ED ด้วยอาการเหนื่อย ใจสั่นมาก เหงื่อแตก ไข้สูง สับสน เริ่มอาเจียน 12 ชม. ก่อนหน้านี้มี influenza-like illness 3 วัน หยุดยา methimazole มา 1 สัปดาห์ก่อนเพราะลืม

V/S: BP 168/86 mmHg, HR 168 (AF rapid response), RR 28, SpO2 97%, Temp 39.8°C
Gen: agitated, diaphoretic, fine tremor
Neuro: GCS 13, no focal deficits
Thyroid: enlarged smooth, no nodules, ไม่มี bruit

Lab: TSH < 0.01 (very suppressed), Free T4 5.8 (5×ULN), Free T3 18 (high), WBC 14,200
EKG: AF rate 168, no ST changes'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 32 ปี ไม่มีโรคประจำตัว มาด้วยอาการอ่อนเพลีย หน้าซีด เลือดออกตามไรฟัน และผื่น petechiae ที่ขาเป็นมา 5 วัน ก่อนหน้านี้ไอ มีไข้เล็กน้อย 2 สัปดาห์ที่แล้ว ใช้ paracetamol และ ibuprofen

V/S: BP 112/72, HR 88, RR 16, Temp 37.0°C, SpO2 99%
PE: pallor, petechiae ที่ extremities + buccal mucosa, gum bleeding mild
ไม่มี hepatosplenomegaly, ไม่มี lymphadenopathy

Lab: Hb 11.8, WBC 5,200 (normal differential), Platelet 8,000/μL (severe thrombocytopenia)
Peripheral blood smear: normal RBC + WBC morphology, ลด platelets ไม่มี schistocytes
Coagulation: PT/PTT/INR ปกติ, Fibrinogen ปกติ
Direct Coombs: negative
HIV/HCV: negative', '[{"label":"A","text":"Platelet transfusion ทันที × 2 units"},{"label":"B","text":"Immune Thrombocytopenia (ITP) — diagnosis of exclusion; first-line glucocorticoid (oral prednisolone 1 mg/kg/day × 1-2 wk then taper OR dexamethasone 40 mg/d × 4 days × 1-4 cycles) OR IVIG 1 g/kg × 1-2 doses (faster response); platelet transfusion only if active life-threatening bleeding; bone marrow biopsy not needed in classic case; second-line for refractory: rituximab, TPO agonists (eltrombopag, romiplostim), splenectomy"},{"label":"C","text":"Splenectomy first-line"},{"label":"D","text":"Plasmapheresis emergent"},{"label":"E","text":"Bone marrow biopsy เป็น mandatory first step"}]'::jsonb,
  'B', 'Immune Thrombocytopenia (ITP, formerly ITP "idiopathic") — autoimmune destruction of platelets Diagnosis: isolated thrombocytopenia (platelet < 100,000) + exclusion of other causes; no specific test (diagnosis of exclusion) Clinical clues here: - Isolated thrombocytopenia (Hb normal, WBC normal) - No schistocytes (rule out TTP/HUS/DIC) - Normal coagulation (rule out DIC) - No splenomegaly or lymphadenopathy (rule out lymphoma, leukemia) - Antecedent viral illness (common trigger in primary ITP, especially in children) - Negative HIV/HCV (chronic viral cause ruled out) ASH 2019 + ICR international consensus ITP guideline: 1. **First-line treatment**: - **Glucocorticoid**: prednisolone 1 mg/kg/day for 1-2 weeks then taper OR dexamethasone 40 mg/day × 4 days (1-4 cycles) — both effective, dex faster + lower cumulative steroid - **IVIG 1 g/kg × 1-2 doses** — faster response (24-48 hr); use when need rapid rise (active bleeding, pre-procedure, refractory steroid) - **Anti-D (WinRho)** — Rh-positive non-splenectomized 2. **Platelet transfusion**: only for life-threatening bleeding (CNS, severe GI) — transfused platelets destroyed quickly 3. **Bone marrow biopsy**: NOT routine in classic presentation; consider if atypical features (age > 60, abnormal smear, B symptoms, lymphadenopathy) 4. **Second-line** (refractory > 3-6 months): - Rituximab (anti-CD20) - Thrombopoietin receptor agonists (eltrombopag, romiplostim) - Fostamatinib (SYK inhibitor) - Splenectomy (last resort due to lifelong infection risk) — ตัวเลือก B comprehensive. A ผิด — platelet transfusion only for major bleeding; here petechiae + minor gum bleed = not life-threatening. C ผิด — splenectomy last resort. D ผิด — plasmapheresis for TTP, not ITP. E ผิด — bone marrow not mandatory', NULL,
  'medium', 'hematology', 'review',
  'internal_medicine', 'clinical_decision', 'hematology', 'adult',
  'ASH 2019 Guidelines for the Management of Immune Thrombocytopenia (Blood Adv); International Consensus Report on ITP 2019 (Provan D et al.)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 32 ปี ไม่มีโรคประจำตัว มาด้วยอาการอ่อนเพลีย หน้าซีด เลือดออกตามไรฟัน และผื่น petechiae ที่ขาเป็นมา 5 วัน ก่อนหน้านี้ไอ มีไข้เล็กน้อย 2 สัปดาห์ที่แล้ว ใช้ paracetamol และ ibuprofen

V/S: BP 112/72, HR 88, RR 16, Temp 37.0°C, SpO2 99%
PE: pallor, petechiae ที่ extremities + buccal mucosa, gum bleeding mild
ไม่มี hepatosplenomegaly, ไม่มี lymphadenopathy

Lab: Hb 11.8, WBC 5,200 (normal differential), Platelet 8,000/μL (severe thrombocytopenia)
Peripheral blood smear: normal RBC + WBC morphology, ลด platelets ไม่มี schistocytes
Coagulation: PT/PTT/INR ปกติ, Fibrinogen ปกติ
Direct Coombs: negative
HIV/HCV: negative'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 28 ปี ทำงาน farmer มาด้วยอาการ acute onset ปวดศีรษะ ปวดเมื่อยกล้ามเนื้อ ไข้สูง คลื่นไส้ อาเจียน เป็นมา 5 วัน วันนี้สังเกตว่าตาเหลือง ปัสสาวะเข้ม

V/S: BP 102/64, HR 108, RR 22, Temp 39.4°C, SpO2 96%
PE: conjunctival suffusion + jaundice mild, calf tenderness ทั้งสองข้าง, hepatomegaly mild
ไม่มี meningismus, no focal neuro

Lab: WBC 14,500 (left shift), Hb 13.2, Plt 78,000, Cr 2.4, BUN 56, Total bilirubin 4.8 (direct 3.6, indirect 1.2), AST 188, ALT 142, ALP 168, CK 1,840
Urinalysis: protein 2+, blood 1+, no RBC casts
PCR for Leptospira: positive
Microscopic agglutination test (MAT): pending', '[{"label":"A","text":"Doxycycline oral 200 mg/วัน × 7 วัน"},{"label":"B","text":"Severe Leptospirosis (Weil''s disease — triad of jaundice + AKI + bleeding tendency, often with myocarditis/pulmonary hemorrhage) — admit ICU; IV penicillin G 1.5 million units q6h × 7 days OR IV ceftriaxone 1-2 g/d OR IV doxycycline if penicillin allergy; supportive: IV fluid + hemodialysis if severe AKI + manage hemorrhagic complications + JarisсhHerxheimer reaction may occur after first dose; report to public health"},{"label":"C","text":"Tetracycline oral + observe outpatient"},{"label":"D","text":"Empirical malaria treatment first"},{"label":"E","text":"Steroid alone"}]'::jsonb,
  'B', 'Leptospirosis — zoonotic spirochete (Leptospira interrogans) from contact with contaminated water/soil; common in farmers, sanitation workers, after floods Clinical features: - **Anicteric (90%)**: 1-week biphasic course, flu-like, conjunctival suffusion (pathognomonic), calf myalgia, headache - **Icteric (Weil''s syndrome 10%)**: severe with jaundice + AKI + bleeding + myocarditis + pulmonary hemorrhage; mortality 5-40% Diagnosis: - **Acute**: PCR (positive in blood 1st week, urine after 2nd week) - **Convalescent**: MAT (microagglutination — gold standard but slow), 4-fold rise titer - IgM ELISA (week 1-2) Severity here: Weil''s disease (jaundice + AKI + thrombocytopenia + hepatitis + rhabdomyolysis CK↑) = severe Treatment ตาม WHO + IDSA: 1. **Severe leptospirosis** (Weil''s): - **IV Penicillin G** 1.5 million units q6h × 7 days (preferred) - OR **IV Ceftriaxone** 1-2 g/day (similar efficacy, easier dosing) - OR **IV Doxycycline** (penicillin allergy or in setting where also rickettsial coverage needed) 2. **Mild/Moderate** (outpatient): - **Oral Doxycycline** 100 mg BID × 7 days - OR **Oral Amoxicillin** 500 mg q8h × 7 days 3. **Supportive**: - IV fluid (volume often depleted) - Hemodialysis early for severe AKI (improves survival) - Blood products for thrombocytopenia/bleeding - Mechanical ventilation for pulmonary hemorrhage (ECMO in extreme cases) 4. **Jarisch-Herxheimer reaction** may occur 1-2 hrs after first antibiotic dose (rare but expect) — supportive 5. **Public health reporting** (notifiable disease in Thailand) 6. **Prophylaxis**: Doxycycline 200 mg/wk for high-risk exposure — ตัวเลือก B comprehensive. A ผิด — severe leptospirosis ต้อง IV not oral. C ผิดอย่างยิ่ง — severe disease + outpatient = fatal. D ผิด — PCR confirmed lepto. E ผิด — steroid not standard', NULL,
  'hard', 'id', 'review',
  'internal_medicine', 'clinical_decision', 'id', 'adult',
  'WHO Human Leptospirosis: Guidance for Diagnosis, Surveillance and Control 2003; Thailand Bureau of Epidemiology Leptospirosis Guidelines; Costa F et al. PLoS Negl Trop Dis 2015', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 28 ปี ทำงาน farmer มาด้วยอาการ acute onset ปวดศีรษะ ปวดเมื่อยกล้ามเนื้อ ไข้สูง คลื่นไส้ อาเจียน เป็นมา 5 วัน วันนี้สังเกตว่าตาเหลือง ปัสสาวะเข้ม

V/S: BP 102/64, HR 108, RR 22, Temp 39.4°C, SpO2 96%
PE: conjunctival suffusion + jaundice mild, calf tenderness ทั้งสองข้าง, hepatomegaly mild
ไม่มี meningismus, no focal neuro

Lab: WBC 14,500 (left shift), Hb 13.2, Plt 78,000, Cr 2.4, BUN 56, Total bilirubin 4.8 (direct 3.6, indirect 1.2), AST 188, ALT 142, ALP 168, CK 1,840
Urinalysis: protein 2+, blood 1+, no RBC casts
PCR for Leptospira: positive
Microscopic agglutination test (MAT): pending'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 68 ปี underlying COPD GOLD III on tiotropium + salmeterol/fluticasone + roflumilast มาด้วยอาการเหนื่อยมาก + ไอเสมหะเหลืองมากกว่าปกติ + ไข้ต่ำ 3 วัน เพิ่มยา reliever salbutamol ทุก 2 ชม.

V/S: BP 138/82, HR 108, RR 28, Temp 37.8°C, SpO2 86% room air → 91% on O2 2 L/min
PE: barrel chest, distant breath sounds, expiratory wheeze both lungs, prolonged expiratory phase

ABG (on O2 2L): pH 7.32, PaCO2 56 (baseline 48), PaO2 64, HCO3 30
CXR: hyperinflation no consolidation no pneumothorax

Procalcitonin 0.18 ng/mL
CBC: WBC 11,800', '[{"label":"A","text":"Increase oxygen to 6 L/min via NC + outpatient"},{"label":"B","text":"Moderate-Severe COPD exacerbation with hypercapnic respiratory acidosis — admit; titrate O2 to SpO2 88-92% (avoid > 92% — risk worsening hypercapnia); **NIV (BiPAP)** indicated (pH < 7.35 + PaCO2 > 45); short-acting bronchodilator nebulization (salbutamol + ipratropium); **systemic corticosteroid** (oral prednisolone 40 mg/d × 5 days REDUCE trial); **antibiotic** indicated (Anthonisen criteria: ≥2 of dyspnea, sputum volume, sputum purulence + procalcitonin moderate — amoxicillin/clavulanate, doxycycline, or macrolide; consider Pseudomonas coverage if frequent exacerbator/structural lung disease)"},{"label":"C","text":"Intubation immediate"},{"label":"D","text":"IV magnesium sulfate alone"},{"label":"E","text":"Heliox first-line"}]'::jsonb,
  'B', 'Acute COPD exacerbation classification: - Mild: SABA only - Moderate: SABA + antibiotic and/or steroid - Severe: hospitalization needed - Very severe: respiratory failure GOLD 2024 Report management: 1. **Oxygen**: target SpO2 88-92% — avoid liberal O2 (cuts hypoxic drive in CO2 retainers, worsens V/Q mismatch — Austin BMJ 2010 RCT showed mortality benefit of titrated O2) 2. **Inhaled bronchodilators**: short-acting beta-2 agonist (salbutamol) + short-acting muscarinic antagonist (ipratropium) — nebulized or MDI with spacer 3. **Systemic corticosteroids** (REDUCE trial): - Prednisolone 40 mg PO × 5 days (5 days = 14 days for outcomes) - Shortens recovery, reduces relapse 4. **Antibiotics** (Anthonisen criteria, GOLD): - Indicated if ≥ 2 of 3: ↑ dyspnea, ↑ sputum volume, ↑ sputum purulence (Anthonisen 1987 NEJM) - OR requiring mechanical ventilation - OR procalcitonin-guided where available - Choice: amoxicillin/clavulanate, doxycycline, macrolide (5-7 days) - Pseudomonas coverage (e.g., fluoroquinolone, anti-pseudomonal beta-lactam) if: FEV1 < 50%, frequent exacerbator > 4/yr, prior Pseudomonas, hospitalized in past 90 days, bronchiectasis 5. **NIV (BiPAP)**: - Indicated if respiratory acidosis (pH < 7.35 + PaCO2 > 45) or severe dyspnea with accessory muscle use - Cochrane meta-analysis: reduces intubation by 65%, mortality by 46% - Contraindications: severe acidosis (pH < 7.25), AMS, vomiting, copious secretions, hemodynamic instability 6. **Intubation/IMV**: reserved for NIV failure, severe AMS, hemodynamic instability, contraindication to NIV 7. **IV MgSO4**: weak evidence in COPD, not routine 8. **Heliox**: not standard — ตัวเลือก B comprehensive matches GOLD. A ผิด — liberal O2 + outpatient miss severe. C ผิด — try NIV first. D ผิด — Mg not first. E ผิด — heliox not first', NULL,
  'medium', 'respiratory', 'review',
  'internal_medicine', 'clinical_decision', 'respiratory', 'adult',
  'GOLD Report 2024 (Global Strategy for Diagnosis, Management and Prevention of COPD); Anthonisen NR et al. Ann Intern Med 1987 (Antibiotic Criteria); Plant PK et al. Lancet 2000 (NIV in COPD)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 68 ปี underlying COPD GOLD III on tiotropium + salmeterol/fluticasone + roflumilast มาด้วยอาการเหนื่อยมาก + ไอเสมหะเหลืองมากกว่าปกติ + ไข้ต่ำ 3 วัน เพิ่มยา reliever salbutamol ทุก 2 ชม.

V/S: BP 138/82, HR 108, RR 28, Temp 37.8°C, SpO2 86% room air → 91% on O2 2 L/min
PE: barrel chest, distant breath sounds, expiratory wheeze both lungs, prolonged expiratory phase

ABG (on O2 2L): pH 7.32, PaCO2 56 (baseline 48), PaO2 64, HCO3 30
CXR: hyperinflation no consolidation no pneumothorax

Procalcitonin 0.18 ng/mL
CBC: WBC 11,800'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 55 ปี underlying alcoholic cirrhosis (Child-Pugh B) มา ED ด้วยอาการสับสน เพ้อ ไม่รู้จักครอบครัว เริ่มเช้านี้ ก่อนหน้านี้รับประทานอาหารปกติ ไม่มีอาการไข้

V/S: BP 124/82, HR 96, RR 18, Temp 36.8°C, SpO2 98%, DTX 92
GCS 13 (E3V4M6), asterixis +, fetor hepaticus, sluggish movements, no focal neuro
Ascites moderate
ไม่มี hematemesis หรือ melena

Lab: Hb 11.0, WBC 8,200, Plt 88,000, Cr 1.4, Na 128, K 3.2, Glucose 92, NH3 92 μmol/L (>>normal 35), AST 78, ALT 42, Total bili 3.2, INR 1.8, Albumin 2.6
CT brain: no acute lesion
Urinalysis: WBC 12 RBC 5, leukocyte esterase positive — UTI', '[{"label":"A","text":"Diagnose dementia and admit for evaluation"},{"label":"B","text":"Hepatic Encephalopathy (HE) precipitated by UTI — West Haven Grade II-III; admit; identify and treat precipitant (treat UTI with appropriate antibiotic — ceftriaxone or cefotaxime if SBP not excluded; consider also SBP — diagnostic paracentesis if ascites; correct electrolytes K, Na); start **lactulose** (oral or NG) 30-45 mL q1h until soft stool then titrate to 2-3 BM/day + **rifaximin 550 mg BID** added if recurrent or severe; nutrition: protein 1.2-1.5 g/kg/d (do NOT restrict protein); zinc supplementation; avoid sedatives; manage cerebral edema if Grade IV/coma"},{"label":"C","text":"Stat hemodialysis to clear ammonia"},{"label":"D","text":"Protein restriction strict + IV dextrose"},{"label":"E","text":"Benzodiazepine for agitation"}]'::jsonb,
  'B', 'Hepatic Encephalopathy (HE) — neuropsychiatric syndrome in chronic liver disease West Haven Grading: - Grade 0 (Minimal): only on neuropsychological testing - Grade I: trivial loss of awareness, euphoria, anxiety, shortened attention span - Grade II: lethargy or apathy, disorientation, asterixis (flapping tremor), inappropriate behavior - Grade III: somnolence but rousable, gross disorientation, confusion - Grade IV: coma This patient: GCS 13, asterixis, disorientation, sluggish → **Grade II-III** Precipitants of HE (5 most common — "PRECIPITATE"): 1. **Infection** (most common — SBP, UTI, pneumonia) ← this case 2. GI bleed (high protein load + reduced perfusion) 3. Electrolyte: hypokalemia, hyponatremia, alkalosis (↑ NH3 across BBB) 4. Constipation 5. Drugs: sedatives (benzodiazepines), opioids 6. Renal failure (uremia) 7. Dehydration (overdiuresis) 8. Dietary: excess protein (rare alone) 9. TIPS or shunt 10. Hepatocellular carcinoma AASLD 2014 + EASL HE guideline + Italian AIGO: 1. **Identify and treat precipitant** — most important step 2. **Lactulose** (first-line) — 30-45 mL q1h until soft stool, then titrate to 2-3 BM/day; acidifies gut + traps NH3 + cathartic 3. **Rifaximin** 550 mg BID — non-absorbable antibiotic; reduces ammonia-producing bacteria; add for recurrent HE, refractory, or as monotherapy when lactulose limiting (Bass et al. NEJM 2010) 4. **Nutrition**: - DO NOT restrict protein (old myth) — leads to muscle catabolism + worsens HE - Target 1.2-1.5 g protein/kg/day - Branched-chain amino acids (BCAA) supplementation - Frequent small meals + late-evening snack (prevent nocturnal catabolism) - Vegetable + dairy protein preferred over animal 5. **Other agents**: - L-ornithine L-aspartate (LOLA) - Zinc supplementation - Polyethylene glycol (PEG) — emerging alternative to lactulose 6. **Avoid sedatives** — benzodiazepines worsen HE 7. **Manage cerebral edema** in Grade IV: mannitol, hypertonic saline, head elevation 8. **Long-term**: liver transplant evaluation if recurrent/refractory — ตัวเลือก B comprehensive. A ผิด — acute HE not dementia. C ผิด — HD ใช้ใน end-stage. D ผิดอย่างยิ่ง — protein restriction outdated, harms. E ผิด — benzo worsen HE', NULL,
  'medium', 'gi', 'review',
  'internal_medicine', 'clinical_decision', 'gi', 'adult',
  'AASLD/EASL Practice Guideline: Hepatic Encephalopathy in Chronic Liver Disease (Vilstrup H et al. Hepatology 2014); Bass NM et al. NEJM 2010 (Rifaximin in HE)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 55 ปี underlying alcoholic cirrhosis (Child-Pugh B) มา ED ด้วยอาการสับสน เพ้อ ไม่รู้จักครอบครัว เริ่มเช้านี้ ก่อนหน้านี้รับประทานอาหารปกติ ไม่มีอาการไข้

V/S: BP 124/82, HR 96, RR 18, Temp 36.8°C, SpO2 98%, DTX 92
GCS 13 (E3V4M6), asterixis +, fetor hepaticus, sluggish movements, no focal neuro
Ascites moderate
ไม่มี hematemesis หรือ melena

Lab: Hb 11.0, WBC 8,200, Plt 88,000, Cr 1.4, Na 128, K 3.2, Glucose 92, NH3 92 μmol/L (>>normal 35), AST 78, ALT 42, Total bili 3.2, INR 1.8, Albumin 2.6
CT brain: no acute lesion
Urinalysis: WBC 12 RBC 5, leukocyte esterase positive — UTI'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 48 ปี underlying breast cancer on chemotherapy (cycle 2 of FEC) มา ED ด้วยอาการเหนื่อยมาก แน่นหน้าอก เท้าและขาบวม คอบวม เห็น collateral vein ที่ผนังหน้าอก เริ่ม 2 สัปดาห์ที่ผ่านมา ค่อย ๆ แย่ลง วันนี้นอนราบหายใจไม่ออก

V/S: BP 102/64, HR 102, RR 26, SpO2 92%, Temp 36.8°C
PE: facial plethora + edema, JVD prominent, dilated chest wall collaterals, cyanosis upper extremities, Pemberton''s sign positive

CXR: widened mediastinum + right paratracheal mass
CT chest with contrast: large mediastinal mass compressing SVC + extending to right pulmonary artery
No prior history of central line
Bronchoscopy biopsy result pending', '[{"label":"A","text":"Furosemide IV high dose only"},{"label":"B","text":"Superior Vena Cava Syndrome (SVCS) from compression by malignant mediastinal mass — semi-recumbent positioning + oxygen + supportive; tissue diagnosis essential ก่อน definitive treatment (chemotherapy ทำได้ if chemosensitive tumor — SCLC, lymphoma, germ cell; radiation if NSCLC, mesothelioma; endovascular SVC stent + thrombolysis for severe/refractory case); steroid for laryngeal/cerebral edema or lymphoma trial; diuretics + sodium restriction; anticoagulation if SVC thrombus; AVOID upper extremity IV lines (impede flow)"},{"label":"C","text":"Immediate sternotomy + decompression"},{"label":"D","text":"Aspirin only — likely thromboembolic"},{"label":"E","text":"Discharge with diuretics + outpatient follow-up"}]'::jsonb,
  'B', 'Superior Vena Cava Syndrome (SVCS) — obstruction of SVC blood flow Etiology: - **Malignant (most common 60-90%)**: lung cancer (NSCLC > SCLC), lymphoma, metastatic, thymoma, germ cell tumor, mesothelioma - **Non-malignant**: indwelling catheter thrombosis, mediastinal fibrosis (histoplasmosis, TB), aortic aneurysm Clinical features: - Face + neck swelling, plethora - Dyspnea, cough, orthopnea - Distended neck + chest wall veins (collaterals) - Cyanosis, edema upper extremities - Pemberton''s sign (arms above head → facial plethora) - Headache, blurred vision, dizziness (cerebral edema) - Stridor, hoarseness (laryngeal edema) - Lethargy, syncope, seizure (severe — emergency!) Severity (Yu et al. grading): - Grade 1: Asymptomatic - Grade 2: Mild (facial swelling, plethora, dyspnea) - Grade 3: Moderate (functional impairment) - Grade 4: Severe (cerebral edema, laryngeal edema, hemodynamic compromise) — emergency - Grade 5: Life-threatening Management ตาม ASCO + Wilson 2007 NEJM review: 1. **Initial supportive** (all cases): - Semi-recumbent position (decrease venous pressure) - Oxygen - Avoid upper extremity IV lines + venipuncture (impede flow + risk thrombosis) - Sodium restriction + cautious diuretics 2. **Tissue diagnosis** — essential before specific Rx (except life-threatening emergency): - Sputum cytology, lymph node biopsy, bronchoscopy, mediastinoscopy, CT-guided biopsy 3. **Definitive treatment** based on histology: - **Chemosensitive tumors** (SCLC, NHL, germ cell): chemotherapy first — high response rate within days - **Less chemosensitive** (NSCLC, mesothelioma, thymoma): radiation - **Combined modality** in some cases 4. **Endovascular stent placement**: - Rapid symptom relief (24-48 hr) - Indicated for severe symptoms, refractory, or pre-treatment to bridge - Often combined with mechanical thrombectomy if thrombus 5. **Glucocorticoid**: - Useful for laryngeal edema, cerebral edema - Diagnostic-therapeutic trial in suspected lymphoma (can mask diagnosis — give after biopsy if possible) 6. **Anticoagulation**: indicated if SVC thrombus or central line thrombosis 7. **Surgery (SVC bypass)**: rarely used in malignant; sometimes for benign refractory — ตัวเลือก B comprehensive. A ผิด — diuretic alone insufficient. C ผิด — surgery not first. D ผิด — this is compression not just thrombus. E ผิดอย่างยิ่ง — SVCS Grade 3-4 emergent', NULL,
  'hard', 'hemato_onco', 'review',
  'internal_medicine', 'clinical_decision', 'hemato_onco', 'adult',
  'Wilson LD et al. NEJM 2007 (Superior Vena Cava Syndrome); Yu JB et al. J Thorac Oncol 2008 (SVCS Grading); NCCN Guidelines: Management of Oncologic Emergencies', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 48 ปี underlying breast cancer on chemotherapy (cycle 2 of FEC) มา ED ด้วยอาการเหนื่อยมาก แน่นหน้าอก เท้าและขาบวม คอบวม เห็น collateral vein ที่ผนังหน้าอก เริ่ม 2 สัปดาห์ที่ผ่านมา ค่อย ๆ แย่ลง วันนี้นอนราบหายใจไม่ออก

V/S: BP 102/64, HR 102, RR 26, SpO2 92%, Temp 36.8°C
PE: facial plethora + edema, JVD prominent, dilated chest wall collaterals, cyanosis upper extremities, Pemberton''s sign positive

CXR: widened mediastinum + right paratracheal mass
CT chest with contrast: large mediastinal mass compressing SVC + extending to right pulmonary artery
No prior history of central line
Bronchoscopy biopsy result pending'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 65 ปี underlying AF on warfarin (target INR 2-3) ได้รับยา azithromycin 500 mg/วัน × 5 วัน สำหรับ atypical pneumonia

หลังจบ course 3 วัน INR ตรวจ = 5.8 (เดิม 2.4) ไม่มี active bleeding หรือ INR > 9

คำถาม: จงอธิบายกลไก drug-drug interaction และการจัดการ INR overdose ที่ถูกต้องตาม Chest 2018 guideline', '[{"label":"A","text":"Azithromycin เป็น CYP3A4 inducer → ลด warfarin → INR ควรลด ไม่ใช่เพิ่ม"},{"label":"B","text":"Macrolides (azithromycin, clarithromycin, erythromycin) inhibit CYP3A4 และ CYP2C9 → ลด clearance warfarin → INR สูงขึ้น; การจัดการ INR 4.5-10 ไม่มี bleeding: หยุด warfarin 1-2 doses, restart at lower dose, recheck INR — DO NOT routinely give vitamin K (ACCP Chest 2018 guideline updated — vitamin K not recommended for INR < 10 without bleeding); INR > 10 + no bleed: low-dose oral vitamin K 2.5-5 mg; major bleeding: hold + PCC + vitamin K 10 mg IV"},{"label":"C","text":"ให้ vitamin K 10 mg IV ทันทีเพื่อ reverse"},{"label":"D","text":"ทำ plasmapheresis"},{"label":"E","text":"Continue warfarin same dose + recheck INR ใน 1 สัปดาห์"}]'::jsonb,
  'B', 'Warfarin pharmacology: - Warfarin = racemic mixture; **S-warfarin (more potent)** metabolized by **CYP2C9**; **R-warfarin** by CYP1A2, CYP3A4 - Therapeutic index narrow → many drug-drug + drug-food interactions Common interactions ↑ INR (inhibit metabolism): - Macrolides (azithromycin, clarithromycin, erythromycin) — CYP3A4 inhibitors - Fluoroquinolones (ciprofloxacin, levofloxacin) — CYP1A2 + protein displacement - TMP-SMX — CYP2C9 inhibitor + displacement - Metronidazole — CYP2C9 inhibitor (potent) - Amiodarone — CYP2C9 + 3A4 inhibitor (one of strongest) - SSRIs (fluoxetine, fluvoxamine) — CYP2C9 inhibitor - Statins (lovastatin, simvastatin) - Acetaminophen high-dose chronic Common interactions ↓ INR (induce metabolism): - Rifampin (strong CYP inducer) - Phenytoin, phenobarbital, carbamazepine - St. John''s wort - Vitamin K-rich foods (green leafy vegetables) ACCP CHEST 2018 + 9th ed. Antithrombotic Guidelines — supratherapeutic INR management: 1. **INR < 4.5, no bleeding**: lower dose or omit 1 dose; recheck 2. **INR 4.5-10, no bleeding**: - Hold warfarin 1-2 doses - Recheck INR - **Vitamin K NOT routinely recommended** (no clinical benefit, may overcorrect → resistance) - Restart at lower dose when INR therapeutic 3. **INR > 10, no bleeding**: - Hold warfarin - **Vitamin K 2.5-5 mg oral** (avoid IV — risk anaphylaxis; SC erratic) - Daily INR monitoring - Restart lower dose 4. **Major bleeding (any INR)**: - Hold warfarin - **PCC (4-factor prothrombin complex concentrate)** 25-50 IU/kg — preferred over FFP (faster, less volume) - **Vitamin K 5-10 mg IV slow** (slow push to avoid anaphylactoid reaction) - Recheck INR, repeat PCC if needed - Treat bleeding source — ตัวเลือก B ถูกและสะท้อน 2018 update. A ผิดเชิงพื้นฐาน (azithromycin = inhibitor not inducer). C ผิด — vitamin K 10 mg IV เก็บไว้สำหรับ major bleeding. D ผิด — plasmapheresis ไม่ effective. E ผิด — INR 5.8 ต้อง intervene', NULL,
  'medium', 'cardiovascular', 'review',
  'internal_medicine', 'basic_science', 'cardiovascular', 'adult',
  'Witt DM et al. CHEST 2018 (ACCP Antithrombotic Therapy 9th Edition Updates); Holbrook A et al. CHEST 2012 (Evidence-Based Management of Anticoagulant Therapy)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 65 ปี underlying AF on warfarin (target INR 2-3) ได้รับยา azithromycin 500 mg/วัน × 5 วัน สำหรับ atypical pneumonia

หลังจบ course 3 วัน INR ตรวจ = 5.8 (เดิม 2.4) ไม่มี active bleeding หรือ INR > 9

คำถาม: จงอธิบายกลไก drug-drug interaction และการจัดการ INR overdose ที่ถูกต้องตาม Chest 2018 guideline'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Researcher ทำ randomized controlled trial ของยาใหม่ A กับ standard therapy ใน acute heart failure ผลแสดงว่า 30-day mortality: drug A = 8.2%, standard = 11.4%; absolute risk reduction 3.2%; p = 0.04, 95% CI 0.5-5.9%

คำถาม: จงคำนวณ Number Needed to Treat (NNT) และตีความหมายผลของ study นี้', '[{"label":"A","text":"NNT = 100 / 3.2 = 31.25 ≈ 32; treat 32 patients with drug A to prevent 1 additional death at 30 days; result statistically significant (p < 0.05, CI excludes null effect of 0); clinical significance depends on cost, side effects, and patient values"},{"label":"B","text":"NNT = 3.2 — only 3 patients needed to treat"},{"label":"C","text":"NNT = 8.2 / 11.4 = 0.72"},{"label":"D","text":"Cannot calculate without odds ratio"},{"label":"E","text":"NNT calculation requires individual patient data"}]'::jsonb,
  'A', 'Number Needed to Treat (NNT) — core EBM concept Formula: NNT = 1 / ARR (Absolute Risk Reduction expressed as decimal) OR NNT = 100 / ARR% (when ARR expressed as percentage) Calculation: - Control event rate (CER) = 11.4% = 0.114 - Experimental event rate (EER) = 8.2% = 0.082 - ARR = CER - EER = 11.4% - 8.2% = 3.2% = 0.032 - **NNT = 1 / 0.032 = 31.25 ≈ 32** Interpretation: - Treat ~32 patients with drug A for 30 days to prevent 1 additional death - Smaller NNT = bigger effect; larger NNT = smaller effect - NNT of 32 = moderate effect for short-term mortality endpoint Compare common NNTs (calibration): - Aspirin in acute MI: NNT ~ 40 for 1 month mortality - Statin primary prevention: NNT ~ 100 over 5 years - Statin secondary prevention: NNT ~ 50 over 5 years - tPA in acute stroke (3-4.5 hr): NNT ~ 14 for improvement Statistical significance: - p = 0.04 < 0.05 → statistically significant - 95% CI 0.5-5.9% does not cross 0 → consistent with significance - Note: statistical ≠ clinical significance (need to consider effect size + side effects + cost) Other related metrics: - Relative Risk (RR) = EER/CER = 0.082/0.114 = 0.72 (28% relative reduction) - Relative Risk Reduction (RRR) = 1 - RR = 28% (or ARR/CER) - Number Needed to Harm (NNH) = 1 / Absolute Risk Increase of harm Common pitfalls: - Do NOT confuse RRR (28%) with ARR (3.2%) — RRR often quoted in headlines but ARR more clinically useful - NNT depends on baseline risk — same RRR yields different NNT in low- vs high-risk populations - Time horizon matters — NNT differs at different follow-up durations — ตัวเลือก A ถูก calculation + interpretation. B ผิด — confused ARR with NNT. C ผิด — calculated RR not NNT. D ผิด — NNT calculated from ARR. E ผิด — can calculate from group rates', NULL,
  'easy', 'signs_symptoms', 'review',
  'internal_medicine', 'basic_science', 'signs_symptoms', 'adult',
  'Guyatt G et al. JAMA Users'' Guides to the Medical Literature; Cook RJ, Sackett DL. BMJ 1995 (NNT)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'Researcher ทำ randomized controlled trial ของยาใหม่ A กับ standard therapy ใน acute heart failure ผลแสดงว่า 30-day mortality: drug A = 8.2%, standard = 11.4%; absolute risk reduction 3.2%; p = 0.04, 95% CI 0.5-5.9%

คำถาม: จงคำนวณ Number Needed to Treat (NNT) และตีความหมายผลของ study นี้'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยที่มี type 2 diabetes มีกลไกหลักคือ insulin resistance + relative insulin deficiency อาจารย์อธิบายเรื่อง molecular pathway ของ insulin signaling ให้นักศึกษาแพทย์ฟัง:

คำถาม: อธิบาย pathway การส่งสัญญาณของ insulin หลังจาก binding กับ insulin receptor (IR) ที่ liver/muscle/adipose cell — เริ่มต้นจากตำแหน่งใดและจบที่กระบวนการใด ?', '[{"label":"A","text":"Insulin → cAMP → PKA → glucose uptake"},{"label":"B","text":"Insulin → IR tyrosine kinase autophosphorylation → IRS-1/2 phosphorylation → PI3K activation → PIP3 production → AKT (PKB) phosphorylation → multiple downstream: (1) GLUT4 translocation to membrane (glucose uptake in muscle/adipose) (2) Glycogen synthase activation (glycogen storage liver/muscle via inhibition of GSK-3) (3) Lipogenesis activation (SREBP-1c) (4) Inhibition of gluconeogenesis (FoxO1 nuclear exclusion) (5) Protein synthesis via mTOR; parallel MAPK pathway for mitogenic effects"},{"label":"C","text":"Insulin → G-protein → IP3 → Ca release → glucose uptake"},{"label":"D","text":"Insulin → directly enters cell → activates nuclear receptor → gene transcription"},{"label":"E","text":"Insulin → JAK/STAT → glucose metabolism"}]'::jsonb,
  'B', 'Insulin signaling pathway (essential basic science): 1. **Receptor binding**: Insulin binds extracellular alpha-subunit of insulin receptor (IR, a transmembrane RTK = receptor tyrosine kinase) on hepatocytes, myocytes, adipocytes (and many others) 2. **Autophosphorylation**: Conformational change activates intrinsic tyrosine kinase in beta-subunit → autophosphorylation of multiple tyrosine residues on IR 3. **IRS phosphorylation**: Activated IR phosphorylates Insulin Receptor Substrate 1 and 2 (IRS-1, IRS-2) on tyrosine residues 4. **PI3K activation**: Phosphorylated IRS recruits and activates phosphatidylinositol-3-kinase (PI3K) — main metabolic branch 5. **PIP3 generation**: PI3K converts PIP2 → PIP3 in membrane 6. **PDK1 and AKT phosphorylation**: PIP3 recruits PDK1 (3-phosphoinositide-dependent kinase) and AKT (= protein kinase B) to membrane; PDK1 + mTORC2 phosphorylate AKT 7. **Downstream effects of AKT**: a. **GLUT4 translocation** (skeletal muscle + adipose): activates AS160 → vesicles fuse with plasma membrane → glucose uptake (NOTE: liver has insulin-independent GLUT2; brain has GLUT3) b. **Glycogen synthesis** (liver + muscle): AKT phosphorylates and inactivates GSK-3 → glycogen synthase activated c. **Lipogenesis** (liver + adipose): SREBP-1c activation → fatty acid + triglyceride synthesis d. **Inhibition of gluconeogenesis** (liver): AKT phosphorylates FoxO1 → cytoplasmic sequestration → reduced PEPCK, G6Pase transcription e. **Protein synthesis**: AKT → mTORC1 → 4E-BP1 + S6K1 → translation initiation f. **Inhibition of lipolysis** (adipose): AKT → PDE3B → ↓cAMP → ↓HSL activity 8. **Parallel mitogenic branch**: IRS → GRB2 → SOS → Ras → Raf → MEK → MAPK (ERK) → growth/proliferation Pathophysiology of insulin resistance: - Defects: serine (not tyrosine) phosphorylation of IRS (inhibitory) by inflammatory kinases (JNK, IKK), reduced GLUT4 translocation - Hyperglycemia + hyperinsulinemia results — ตัวเลือก B ถูกครอบคลุม. A ผิด — cAMP/PKA pathway สำหรับ glucagon/epinephrine ตรงข้ามกับ insulin. C ผิด — Gq/IP3/Ca pathway สำหรับ alpha-1 adrenergic etc. D ผิด — insulin signaling cell surface ไม่ใช่ nuclear hormone. E ผิด — JAK/STAT สำหรับ cytokines/leptin', NULL,
  'hard', 'endocrine_metabolic', 'review',
  'internal_medicine', 'basic_science', 'endocrine_metabolic', 'adult',
  'Boron & Boulpaep Medical Physiology 3rd ed. Ch. 51; Williams Textbook of Endocrinology 14th ed. Ch. 31; Saltiel AR, Kahn CR. Nature 2001 (Insulin signaling)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ผู้ป่วยที่มี type 2 diabetes มีกลไกหลักคือ insulin resistance + relative insulin deficiency อาจารย์อธิบายเรื่อง molecular pathway ของ insulin signaling ให้นักศึกษาแพทย์ฟัง:

คำถาม: อธิบาย pathway การส่งสัญญาณของ insulin หลังจาก binding กับ insulin receptor (IR) ที่ liver/muscle/adipose cell — เริ่มต้นจากตำแหน่งใดและจบที่กระบวนการใด ?'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วย hospital-acquired pneumonia (HAP) ใน ICU ตรวจพบ Acinetobacter baumannii จาก tracheal aspirate sensitivity: resistant ต่อ ceftazidime, cefepime, piperacillin-tazobactam, ciprofloxacin, gentamicin; intermediate ต่อ meropenem; sensitive ต่อ colistin และ tigecycline

คำถาม: A. baumannii MDR/XDR pathogenic mechanisms และ optimal treatment approach', '[{"label":"A","text":"ใช้ meropenem high-dose monotherapy"},{"label":"B","text":"MDR Acinetobacter resistance mechanisms: (1) ESBL/carbapenemase production (OXA-23, OXA-58, NDM) — degrade beta-lactams (2) Efflux pumps (AdeABC system) (3) Porin loss/mutation reducing permeability (4) Aminoglycoside-modifying enzymes (5) Target modifications (mutations in topoisomerase for fluoroquinolone resistance); Treatment XDR (extensively drug-resistant): combination therapy — colistin (polymyxin E) IV (load 9 million units → 4.5 million q12h, nephrotoxic monitor) + tigecycline IV (caution in pneumonia — low lung penetration) OR sulbactam high-dose (synergy with intrinsic A. baumannii susceptibility) OR cefiderocol (siderophore cephalosporin — new option); source control critical (remove infected device); infectious diseases consult + antibiotic stewardship"},{"label":"C","text":"Ciprofloxacin oral monotherapy"},{"label":"D","text":"Vancomycin IV — gram-negative coverage"},{"label":"E","text":"Stop antibiotic and observe immune response"}]'::jsonb,
  'B', 'Acinetobacter baumannii — opportunistic gram-negative coccobacillus, ICU pathogen, common HAP/VAP, bloodstream infection, surgical wound, meningitis Resistance phenotypes: - **MDR** (multidrug-resistant): non-susceptible ≥ 1 agent in ≥ 3 antimicrobial categories - **XDR** (extensively drug-resistant): non-susceptible ≥ 1 agent in all but ≤ 2 categories - **PDR** (pan-drug-resistant): non-susceptible to all agents in all categories Resistance mechanisms (often combined): 1. **Enzymatic inactivation**: - Beta-lactamases: ESBL (e.g., PER, VEB), AmpC (cephalosporinase), carbapenemases — OXA-type carbapenemases (OXA-23, OXA-24/40, OXA-58) most prevalent globally; metallo-beta-lactamases (NDM, IMP, VIM) — Aminoglycoside-modifying enzymes (acetyltransferases, phosphotransferases) 2. **Reduced permeability**: porin loss (e.g., CarO) 3. **Efflux pumps**: AdeABC (RND-family), AdeIJK, AdeFGH — extrude multiple antibiotic classes 4. **Target modifications**: mutations in penicillin-binding proteins (PBPs), DNA gyrase/topoisomerase IV (fluoroquinolone resistance), 16S rRNA methylases (aminoglycoside resistance) 5. **Biofilm formation** on devices Treatment for XDR/MDR (IDSA 2022 + ESCMID + Tamma 2024 update): 1. **Sulbactam** (often combined with ampicillin or as ampicillin-sulbactam high-dose): - Intrinsic anti-A. baumannii activity (binds PBP3) - High-dose: 9-12 g sulbactam component/day (off-label) - Recently approved: sulbactam-durlobactam (Xacduro) — FDA 2023 specifically for HAP/VAP by A. baumannii 2. **Polymyxins** (colistin = polymyxin E, polymyxin B): - Lipid A binding → membrane disruption - Loading dose 5 mg/kg colistin base activity (CBA) - Nephrotoxicity + neurotoxicity monitor - Should not be monotherapy (synergy needed) 3. **Cefiderocol** — siderophore cephalosporin: - Trojan-horse: binds iron, transported via siderophore uptake - Effective vs all carbapenemase classes (OXA, NDM, KPC) - FDA approved for cUTI, HAP/VAP 4. **Combination therapy** preferred for severe XDR: - Colistin + meropenem (high-dose, 2 g q8h infused over 3 hr) - Colistin + tigecycline (caution in pneumonia — lung penetration limited) - Colistin + ampicillin-sulbactam 5. **Tigecycline**: glycylcycline; broad gram-positive + negative + atypical coverage; **caution in pneumonia and bacteremia** — black box warning (increased mortality); reserved for cIAI, cSSTI 6. **Adjuncts**: source control (drain abscess, remove infected device), infection control (isolation) — ตัวเลือก B comprehensive. A ผิด — intermediate susceptibility, monotherapy inadequate. C ผิด — already resistant. D ผิด — vancomycin = gram-positive coverage. E ผิด — XDR HAP requires aggressive Rx', NULL,
  'hard', 'id', 'review',
  'internal_medicine', 'basic_science', 'id', 'adult',
  'IDSA 2022 Guidance: Treatment of AmpC β-lactamase, Carbapenem-Resistant Acinetobacter baumannii; Tamma PD et al. CID 2024 Update; Magiorakos AP et al. CMI 2012 (MDR/XDR/PDR definitions)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ผู้ป่วย hospital-acquired pneumonia (HAP) ใน ICU ตรวจพบ Acinetobacter baumannii จาก tracheal aspirate sensitivity: resistant ต่อ ceftazidime, cefepime, piperacillin-tazobactam, ciprofloxacin, gentamicin; intermediate ต่อ meropenem; sensitive ต่อ colistin และ tigecycline

คำถาม: A. baumannii MDR/XDR pathogenic mechanisms และ optimal treatment approach'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'โรงพยาบาลใหญ่ในกรุงเทพมีอัตรา central line-associated bloodstream infection (CLABSI) สูง 4.2 ต่อ 1,000 catheter-days (เป้าหมาย CDC NHSN ≤ 1) ผู้บริหารโรงพยาบาลตั้ง quality improvement team

คำถาม: ตามหลัก quality improvement (PDSA cycle) + CLABSI bundle ขั้นตอนใดควรปฏิบัติเป็น "foundational evidence-based bundle" เพื่อลด CLABSI ตามที่ AHRQ และ IHI แนะนำ', '[{"label":"A","text":"ใช้ silver-impregnated catheter ทุกราย"},{"label":"B","text":"Central Line Insertion Bundle (5 elements): (1) Hand hygiene before insertion (2) Maximal barrier precautions (cap, mask, sterile gown, gloves, large drape) (3) Chlorhexidine 2% skin antisepsis (allow drying) (4) Optimal catheter site selection (subclavian > IJ > femoral; avoid femoral in adults) (5) Daily review of line necessity + prompt removal when no longer indicated; PLUS culture-of-safety: empower nurses to stop procedure if breaches; track and feedback rates; PDSA cycles to drive process improvement"},{"label":"C","text":"Antibiotic prophylaxis vancomycin for every line"},{"label":"D","text":"Replace lines q72h regardless of indication"},{"label":"E","text":"Skip dressing changes to avoid contamination"}]'::jsonb,
  'B', 'Central Line-Associated Bloodstream Infection (CLABSI) — high-morbidity nosocomial infection; preventable to large degree CDC NHSN definition: laboratory-confirmed bloodstream infection in patient with central line in place > 2 days, not related to infection from another site Pronovost et al. NEJM 2006 (Keystone ICU project in Michigan): - 103 ICUs implemented 5-element bundle - CLABSI dropped from 7.7 → 1.4 per 1000 catheter-days - Sustained reduction over 18 months - Cost-effective: prevented 1500 deaths + $200M cost savings IHI + AHRQ + SHEA + CDC bundle (consistent core elements): **CLABSI Insertion Bundle (5 elements)**: 1. **Hand hygiene** before insertion 2. **Maximal sterile barrier precautions**: cap, mask, sterile gown, sterile gloves, large sterile drape covering patient 3. **Chlorhexidine gluconate ≥ 0.5% in alcohol** for skin antisepsis (or 2% CHG) — allow to dry 30 sec on dry skin, 2 min if hair/oil 4. **Optimal site selection**: - Subclavian preferred (lowest infection rate) - Internal jugular acceptable - **Avoid femoral** in adults (highest infection + thrombosis risk) - In children, femoral acceptable (lower rates than adults) 5. **Daily review** of line necessity + remove promptly when no longer indicated **Maintenance Bundle**: - Disinfect access hubs/ports with chlorhexidine/alcohol before each use ("scrub the hub" 15 seconds) - Transparent dressing change q7 days, gauze dressing q2 days, or if soiled/non-occlusive - Chlorhexidine-impregnated dressings (CHG-discs) — additional reduction - Daily CHG bathing (in some institutions) - Antimicrobial lock therapy for selected high-risk lines **Additional strategies**: - Empower any team member to stop procedure if breach in technique - Standardized insertion checklist + observer documentation - Provider education + competency assessment - Real-time CLABSI tracking + feedback to units - Antimicrobial-impregnated catheters (CHG + sulfadiazine, or minocycline-rifampin) — for selected high-risk patients only, not routine **PDSA Cycle for QI**: - **Plan**: define problem, set aim (e.g., reduce CLABSI to ≤ 1 per 1000 catheter-days), measure baseline - **Do**: implement bundle on pilot unit - **Study**: measure outcomes vs aim - **Act**: adapt, spread, sustain — ตัวเลือก B comprehensive evidence-based. A ผิด — antimicrobial catheter เป็น selected use ไม่ใช่ first foundational step. C ผิด — antibiotic prophylaxis NOT recommended (promotes resistance). D ผิด — routine replacement NOT recommended (increases mechanical complications without reducing infection). E ผิด — soiled dressing increases infection', NULL,
  'medium', 'id', 'review',
  'internal_medicine', 'ems_mgmt', 'id', 'adult',
  'Pronovost P et al. NEJM 2006 (Michigan Keystone ICU); CDC NHSN CLABSI Prevention; IHI How-to Guide: Prevent CLABSI; SHEA/IDSA Practice Recommendation 2014', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'โรงพยาบาลใหญ่ในกรุงเทพมีอัตรา central line-associated bloodstream infection (CLABSI) สูง 4.2 ต่อ 1,000 catheter-days (เป้าหมาย CDC NHSN ≤ 1) ผู้บริหารโรงพยาบาลตั้ง quality improvement team

คำถาม: ตามหลัก quality improvement (PDSA cycle) + CLABSI bundle ขั้นตอนใดควรปฏิบัติเป็น "foundational evidence-based bundle" เพื่อลด CLABSI ตามที่ AHRQ และ IHI แนะนำ'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'โรงพยาบาลพบว่ามีการใช้ broad-spectrum antibiotics สูงและ resistance rates เพิ่มขึ้น ผู้บริหารตั้ง Antimicrobial Stewardship Program (ASP) นำโดยทีม ID + clinical pharmacist

คำถาม: ASP "core elements" ตาม CDC + IDSA/SHEA 2016 ที่ควรมีในทุก hospital-based ASP', '[{"label":"A","text":"Restrict all broad-spectrum antibiotics for use only by infectious disease physicians"},{"label":"B","text":"CDC Core Elements of Hospital ASPs: (1) Leadership commitment + dedicated resources (2) Accountability — physician leader (3) Pharmacy expertise — pharmacist leader (4) Action — interventions: (a) prospective audit + feedback (b) formulary restriction + pre-authorization (c) facility-specific treatment recommendations (5) Tracking — metrics: antibiotic use (days of therapy/DOT), C. difficile rates, resistance (6) Reporting — feedback to providers (7) Education; Specific interventions: IV-to-PO switch + de-escalation based on culture + duration optimization (avoiding overlong therapy)"},{"label":"C","text":"Same antibiotic protocol regardless of unit"},{"label":"D","text":"Avoid culture-guided therapy"},{"label":"E","text":"Empirical broad-spectrum for all febrile patients"}]'::jsonb,
  'B', 'Antimicrobial Stewardship Program (ASP) — coordinated interventions to optimize antimicrobial use Goals: 1. Improve patient outcomes 2. Reduce antimicrobial resistance 3. Reduce antibiotic-related adverse events (C. difficile, drug toxicity) 4. Reduce healthcare costs CDC Core Elements (2014, updated 2019) — required by Joint Commission accreditation: 1. **Leadership commitment**: senior leadership support, dedicated time/funding/staff 2. **Accountability**: appoint a single leader (typically physician) responsible for outcomes 3. **Pharmacy expertise**: appoint single pharmacist leader 4. **Action** (interventions): - **Prospective audit and feedback** (most effective): ID/pharmacist reviews ongoing prescriptions, recommends changes - **Formulary restriction + pre-authorization**: restricted drugs require approval - **Facility-specific guidelines** based on local antibiogram - **IV-to-PO conversion** when patient tolerates oral - **De-escalation** based on culture results (narrow spectrum) - **Duration optimization** — avoid overlong courses (e.g., uncomplicated CAP 5 days, uncomplicated pyelonephritis 7-14 days, uncomplicated SSTI 5-7 days) - **Rapid diagnostics + biomarker-guided** (procalcitonin in pneumonia) 5. **Tracking** (metrics): - Antibiotic use: Days of Therapy (DOT) per 1000 patient-days; Standardized Antimicrobial Administration Ratio (SAAR) - Resistance: institutional antibiogram updated annually - Outcomes: C. difficile rate, mortality, LOS 6. **Reporting**: regular feedback to prescribers, leadership 7. **Education**: providers, nurses, pharmacists, patients Evidence: - 30-40% antibiotic use is inappropriate (CDC) - ASP reduces antibiotic use ~ 20%, resistance, C. difficile, cost - Joint Commission requires ASP for hospital accreditation since 2017 IDSA/SHEA 2016 guideline endorses these strategies WHO Global Action Plan on AMR + Thailand''s National Strategic Plan on AMR alignment — ตัวเลือก B comprehensive. A ผิด — pure restriction without other elements insufficient + creates conflict. C ผิด — facility-unit-specific guidelines preferred. D ผิดอย่างยิ่ง — culture-guided therapy is cornerstone. E ผิดอย่างยิ่ง — opposite of stewardship', NULL,
  'medium', 'id', 'review',
  'internal_medicine', 'ems_mgmt', 'id', 'adult',
  'CDC Core Elements of Hospital Antibiotic Stewardship Programs 2019; IDSA/SHEA Implementing an ASP 2016 (CID); Barlam TF et al. CID 2016', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'โรงพยาบาลพบว่ามีการใช้ broad-spectrum antibiotics สูงและ resistance rates เพิ่มขึ้น ผู้บริหารตั้ง Antimicrobial Stewardship Program (ASP) นำโดยทีม ID + clinical pharmacist

คำถาม: ASP "core elements" ตาม CDC + IDSA/SHEA 2016 ที่ควรมีในทุก hospital-based ASP'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 72 ปี มีปัญหา medication ที่ซับซ้อน — polypharmacy 12 ตัว: rosuvastatin, amlodipine, lisinopril, hydrochlorothiazide, metoprolol, metformin, glipizide, omeprazole, tamsulosin, donepezil, paroxetine, alprazolam

ผู้ป่วยตกล้ม 2 ครั้งในเดือนที่ผ่านมา

คำถาม: ตามหลัก geriatric medicine + Beers Criteria + STOPP/START ยาใดควร reconsider หรือลด/หยุดเพราะ inappropriate medication ใน elderly ที่มี falls', '[{"label":"A","text":"หยุดทุกยาทันที"},{"label":"B","text":"Apply Beers Criteria + STOPP/START + geriatric assessment: high-risk medications for falls and adverse events in elderly include — (1) **Alprazolam (benzodiazepine)** — Beers Criteria avoid in elderly (increased fall, fracture, cognitive impairment risk); taper slowly (2) **Paroxetine** — strongly anticholinergic, avoid in elderly per Beers; consider switch to sertraline or escitalopram (3) **Tamsulosin + amlodipine + diuretic + ACEi** combo → orthostatic hypotension; check standing BP, consider de-prescribing (4) **Glipizide** — sulfonylurea, hypoglycemia risk in elderly + CKD; consider switch to DPP-4 inhibitor or metformin alone (5) **Donepezil** — review indication and risk/benefit (6) **PPI long-term** — review indication; risks fracture, C. difficile, B12 deficiency; deprescribe if no clear indication; comprehensive geriatric assessment (CGA) + medication reconciliation + functional + cognitive + nutritional + social assessment; fall prevention program (CDC STEADI)"},{"label":"C","text":"Add more medications to control symptoms"},{"label":"D","text":"Continue all medications unchanged"},{"label":"E","text":"Stop only statins (low benefit in elderly)"}]'::jsonb,
  'B', 'Polypharmacy in elderly (≥ 5 medications) — associated with: falls, fractures, hospitalization, cognitive impairment, adverse drug events, drug-drug interactions, increased mortality Tools for deprescribing: 1. **Beers Criteria (AGS, updated 2023)** — list of Potentially Inappropriate Medications (PIMs) in adults ≥ 65 years 2. **STOPP/START Criteria** (Screening Tool of Older People''s Prescriptions / Screening Tool to Alert to Right Treatment) — version 3 (2023) European 3. **Medication Appropriateness Index (MAI)** 4. **Drug Burden Index** Specific drugs in this case (high-risk per Beers/STOPP): **Alprazolam (Benzodiazepine)**: - Beers: avoid in elderly (high risk: falls, fractures, delirium, cognitive impairment) - Long half-life → cumulative effect - If used: taper slowly (10-25% q2-4 weeks), substitute non-pharm strategies for anxiety/insomnia (CBT-I) **Paroxetine**: - Strongly anticholinergic among SSRIs → cognitive impairment, anticholinergic burden - Withdrawal syndrome (short half-life) - Beers: avoid; prefer sertraline, escitalopram, citalopram (with caution for QTc) **Antihypertensives + alpha-blocker (tamsulosin) + diuretic**: - Orthostatic hypotension → falls - Check standing BP + symptoms - Consider deprescribing one or more, especially if BP well-controlled - Beers: avoid alpha-blockers as antihypertensives (not as BPH treatment) — but tamsulosin OK for BPH if no orthostasis **Sulfonylurea (glipizide)**: - Hypoglycemia risk especially in CKD - Beers: avoid long-acting (glyburide); short-acting (glipizide) acceptable but caution - Prefer: metformin (eGFR > 30), DPP-4 inhibitor, SGLT2 inhibitor (with renal/CV benefit), GLP-1 agonist **PPI (omeprazole)**: - Long-term risks: fracture, hypomagnesemia, B12 deficiency, C. difficile, pneumonia, AKI, CKD - Deprescribing recommended if no ongoing indication (e.g., chronic NSAID, Barrett''s, severe esophagitis) - Algorithm: identify indication → reassess need → step down or stop **Anticholinergic burden**: paroxetine, donepezil (counteracts purpose), some bladder agents — assess total burden Comprehensive Geriatric Assessment (CGA) — multidisciplinary: 1. Medical: medication review, comorbidity 2. Functional: ADL, IADL, gait/balance (TUG) 3. Cognitive: Mini-Cog, MoCA 4. Nutritional: weight, MNA-SF 5. Psychosocial: depression (GDS), social support 6. Environmental: home safety Deprescribing approach: 1. Comprehensive medication review 2. Identify drugs with no clear indication or harm > benefit 3. Prioritize based on risk (fall risk, anticholinergic, hypoglycemia) 4. Taper one drug at a time 5. Engage patient + family in shared decision-making 6. Monitor for withdrawal/return of symptoms — ตัวเลือก B comprehensive evidence-based deprescribing. A ผิด — abrupt all withdrawal dangerous. C ผิด — adds harm. D ผิด — perpetuates problem. E ผิด — statins debatable benefit in oldest old but не isolated issue', NULL,
  'medium', 'psych_behavior', 'review',
  'internal_medicine', 'ems_mgmt', 'psych_behavior', 'adult',
  'American Geriatrics Society Beers Criteria 2023 Update (J Am Geriatr Soc); STOPP/START Criteria Version 3 (2023); O''Mahony D et al. Age Ageing 2023', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 72 ปี มีปัญหา medication ที่ซับซ้อน — polypharmacy 12 ตัว: rosuvastatin, amlodipine, lisinopril, hydrochlorothiazide, metoprolol, metformin, glipizide, omeprazole, tamsulosin, donepezil, paroxetine, alprazolam

ผู้ป่วยตกล้ม 2 ครั้งในเดือนที่ผ่านมา

คำถาม: ตามหลัก geriatric medicine + Beers Criteria + STOPP/START ยาใดควร reconsider หรือลด/หยุดเพราะ inappropriate medication ใน elderly ที่มี falls'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 64 ปี underlying breast cancer (HER2+) ได้ trastuzumab + chemotherapy 4 cycles มาด้วยอาการเหนื่อย + bilateral pedal edema + รุนแรงขึ้นใน 2 สัปดาห์

V/S: BP 124/78, HR 96, RR 20, SpO2 95%
PE: JVP 11, S3 gallop +, fine basilar crackles, 2+ pedal edema
Echocardiogram before chemo: LVEF 62%
Echocardiogram now: LVEF 38% (drop > 10 absolute points + below 50%)

Lab: BNP 1,240, Troponin negative, Cr 1.1
EKG: sinus tachycardia, no acute changes', '[{"label":"A","text":"Continue trastuzumab + monitor"},{"label":"B","text":"Trastuzumab-induced cardiotoxicity (HFrEF) — integrated cardio-oncology management: (1) HOLD trastuzumab temporarily (cardiotoxicity often reversible with HF therapy, unlike anthracycline which is dose-cumulative + often irreversible) (2) Start guideline-directed medical therapy (GDMT) for HFrEF: ACEi/ARB or ARNI + beta-blocker + MRA + SGLT2 inhibitor (4 pillars) + diuretic for congestion (3) Repeat echo in 3-4 weeks; if LVEF recovers to > 50%, can resume trastuzumab with close monitoring (4) Cardio-oncology consult — joint decision balancing cancer + cardiac (5) Oncology consult — alternative HER2-targeted therapy (e.g., pertuzumab combo, TDM-1, T-DXd) (6) Long-term surveillance — annual echo, biomarkers; cardiotoxicity affect overall survival"},{"label":"C","text":"Increase trastuzumab dose to overcome cardiac stress"},{"label":"D","text":"Hospice referral — terminal cancer + heart failure"},{"label":"E","text":"Heart transplant evaluation immediately"}]'::jsonb,
  'B', 'Cancer Therapy-Related Cardiac Dysfunction (CTRCD) — major cardio-oncology issue Types of cardiotoxicity by agent: 1. **Anthracyclines** (doxorubicin, epirubicin): - Type I cardiotoxicity: dose-dependent, often irreversible, myocyte death - Cumulative dose limit: doxorubicin > 450-500 mg/m² high risk - Mechanism: oxidative stress, topoisomerase II-beta inhibition - Prevention: dexrazoxane (iron chelator), limit cumulative dose 2. **HER2-targeted (trastuzumab, pertuzumab, TDM-1, T-DXd)**: - Type II cardiotoxicity: not dose-dependent, often **reversible** with cessation + HF therapy - Mechanism: HER2 (ErbB2) inhibition disrupts cardiomyocyte stress response - Risk factors: prior anthracycline, age > 60, baseline LVEF reduced, HTN 3. **Tyrosine kinase inhibitors** (sunitinib, sorafenib): - Hypertension, LV dysfunction - Reversible 4. **Fluoropyrimidines** (5-FU, capecitabine): - Coronary vasospasm → angina, MI - Acute, often reversible with cessation 5. **Immune checkpoint inhibitors** (pembrolizumab, nivolumab, ipilimumab): - Myocarditis (rare but high mortality 50%) - Other: pericarditis, conduction abnormalities - Treatment: high-dose steroid + ICI discontinuation 6. **Radiation therapy**: - Pericardial disease, accelerated CAD, valvular disease - Years to decades later 7. **CAR-T cell therapy**: - Cytokine release syndrome → cardiotoxicity ESC 2022 Cardio-Oncology Guideline + ASCO definition of CTRCD: - **Asymptomatic CTRCD**: LVEF drop ≥ 10 absolute % to < 50%, OR new GLS reduction > 15% relative, OR troponin/BNP elevation - **Symptomatic CTRCD**: HF symptoms + LVEF reduction This patient: LVEF 62 → 38% (drop 24 points) + HF symptoms = Severe CTRCD Management: 1. **Hold trastuzumab** (Type II — reversible) 2. **GDMT for HFrEF**: - ACEi/ARB or **ARNI (sacubitril/valsartan)** — cardioprotective, may improve recovery - **Beta-blocker** (carvedilol, metoprolol succinate, bisoprolol) - **MRA** (spironolactone, eplerenone) - **SGLT2 inhibitor** (dapagliflozin, empagliflozin) — 4th pillar HFrEF therapy - Loop diuretic for congestion 3. **Repeat echo 3-4 weeks**: most recover to > 50% LVEF on GDMT 4. **Cardio-oncology + oncology joint decision**: - If LVEF recovers > 50%, can resume trastuzumab with monitoring - If not recovered, consider alternative HER2-targeted agents (pertuzumab + chemo, TDM-1, T-DXd — newer with less cardiotoxicity) - Balance cancer prognosis + cardiac risk 5. **Long-term surveillance**: - Annual echo, biomarkers - Cardiac biomarker (troponin, BNP) trends - Lifestyle: BP, lipids, weight, exercise 6. **Primary prevention** (high-risk patients pre-treatment): - Baseline echo + biomarkers - ACEi/beta-blocker prophylactically in selected high-risk - Statin (some evidence in anthracycline) — ตัวเลือก B comprehensive integrative. A ผิด — continued trastuzumab worsens LVEF, harms. C ผิด — increased dose worse. D ผิด — premature, cardiotoxicity often reversible. E ผิด — transplant not first-line', NULL,
  'hard', 'cardiovascular', 'review',
  'internal_medicine', 'integrative', 'cardiovascular', 'adult',
  'ESC 2022 Guidelines on Cardio-Oncology (Eur Heart J); Lyon AR et al. Eur Heart J 2022 (Cardiovascular Toxicity); ASCO Practical Clinical Guideline on Cardiac Dysfunction', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 64 ปี underlying breast cancer (HER2+) ได้ trastuzumab + chemotherapy 4 cycles มาด้วยอาการเหนื่อย + bilateral pedal edema + รุนแรงขึ้นใน 2 สัปดาห์

V/S: BP 124/78, HR 96, RR 20, SpO2 95%
PE: JVP 11, S3 gallop +, fine basilar crackles, 2+ pedal edema
Echocardiogram before chemo: LVEF 62%
Echocardiogram now: LVEF 38% (drop > 10 absolute points + below 50%)

Lab: BNP 1,240, Troponin negative, Cr 1.1
EKG: sinus tachycardia, no acute changes'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยหญิงอายุ 70 ปี underlying CKD stage 4 (eGFR 22), T2DM, HFpEF, AF on apixaban, peripheral neuropathy มา OPD ด้วยอาการ chronic constipation + recently elevated cardiac biomarker (NT-proBNP) on routine check

Medications: metformin 500 BID, glipizide 5 mg, empagliflozin 10 mg, apixaban 5 mg BID, metoprolol succinate 100 mg, furosemide 40 mg, atorvastatin 40 mg, gabapentin 600 mg TID

Question: identify high-priority drug-disease + drug-drug interactions to address', '[{"label":"A","text":"ปรับยาทุกตัว ไม่ปรับใดก็ได้"},{"label":"B","text":"Multi-morbidity prescribing review: (1) **Metformin** — eGFR 22 < 30 = contraindicated (lactic acidosis risk) → discontinue (2) **Empagliflozin** — eGFR 22 < initiation threshold 20 (some guidelines 30) but if already on, continue with monitoring per EMPA-KIDNEY (3) **Apixaban** dose — adjust to 2.5 mg BID if ≥ 2 of: age ≥ 80, weight ≤ 60 kg, Cr ≥ 1.5 (4) **Gabapentin** — accumulates in CKD → reduce dose (eGFR 15-29: 200-700 mg/day; eGFR < 15: 100-300 mg/day) — current 1800 mg/day too high → reduce to 600 mg/day max + monitor for sedation/falls (5) **Glipizide** — hypoglycemia risk in CKD elderly → consider switch (6) **HFpEF guideline**: SGLT2 inhibitor continue (DELIVER, EMPEROR-Preserved benefit); consider spironolactone if K stable; loop diuretic for congestion; treat HT (7) **Constipation** — review opioids, anticholinergics; gabapentin can contribute; PEG laxative first-line (8) Cardio-renal-metabolic syndrome multidisciplinary approach + medication reconciliation"},{"label":"C","text":"หยุด empagliflozin เพราะ CKD"},{"label":"D","text":"Continue current regimen unchanged"},{"label":"E","text":"Stop apixaban — too high bleeding risk"}]'::jsonb,
  'B', 'Multi-morbidity + polypharmacy + advanced CKD + HF — complex integrative management Key drug-disease interactions: 1. **Metformin in CKD**: - eGFR ≥ 45: full dose - eGFR 30-44: reduce dose, monitor - **eGFR < 30: contraindicated** (FDA 2016 update) — risk of metformin-associated lactic acidosis (MALA), mortality 50% - Discontinue in this patient (eGFR 22) 2. **SGLT2 inhibitors in CKD**: - Indicated for: T2DM + CKD with albuminuria, HFrEF, HFpEF (EMPEROR-Preserved/DELIVER), CKD without DM (EMPA-KIDNEY, DAPA-CKD) - Initiation: empagliflozin labeled for eGFR ≥ 20; dapagliflozin ≥ 25 - **Already on**: continue until dialysis per major trials (cardiorenal benefit persists) 3. **Apixaban dose adjustment** (FDA): - 2.5 mg BID if ≥ 2 of: - Age ≥ 80 years - Body weight ≤ 60 kg - Serum Cr ≥ 1.5 mg/dL - This patient: age 70 (no), weight unknown, Cr (eGFR 22 → likely Cr > 1.5) → assess: if only 1 criterion → 5 mg BID; if ≥ 2 → 2.5 mg BID 4. **Gabapentin in CKD** (renal excretion): - eGFR ≥ 60: full dose 900-3600 mg/day - eGFR 30-59: 400-1400 mg/day - eGFR 15-29: 200-700 mg/day - eGFR < 15: 100-300 mg/day - This patient: eGFR 22 → max 700 mg/day; currently 1800 mg → toxic risk (sedation, falls, ataxia) 5. **Sulfonylurea (glipizide)** in elderly + CKD: - Hypoglycemia risk - Switch to DPP-4 inhibitor (linagliptin — no renal adjustment) or other 6. **HFpEF management** (recent paradigm shift): - SGLT2 inhibitor (empagliflozin EMPEROR-Preserved 2021; dapagliflozin DELIVER 2022) — first guideline-supported - Spironolactone (TOPCAT — debated, some benefit) - Sacubitril/valsartan (PARAGON-HF — borderline; selected) - Loop diuretic for congestion - Treat comorbidities (HT, AF rate control, T2DM, obesity) Comprehensive geriatric medication review + cardio-renal-metabolic coordination — ตัวเลือก B comprehensive. A ผิด — adjustment needed. C ผิด — continue SGLT2 if benefit. D ผิด — toxic medications. E ผิด — anticoagulation needed for AF, just dose adjust', NULL,
  'hard', 'renal_gu', 'review',
  'internal_medicine', 'integrative', 'renal_gu', 'adult',
  'FDA Metformin Label 2016; ESC 2021 HF Guidelines + 2023 Focused Update; KDIGO Diabetes in CKD 2022; Apixaban (Eliquis) Prescribing Information', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ผู้ป่วยหญิงอายุ 70 ปี underlying CKD stage 4 (eGFR 22), T2DM, HFpEF, AF on apixaban, peripheral neuropathy มา OPD ด้วยอาการ chronic constipation + recently elevated cardiac biomarker (NT-proBNP) on routine check

Medications: metformin 500 BID, glipizide 5 mg, empagliflozin 10 mg, apixaban 5 mg BID, metoprolol succinate 100 mg, furosemide 40 mg, atorvastatin 40 mg, gabapentin 600 mg TID

Question: identify high-priority drug-disease + drug-drug interactions to address'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 58 ปี diagnosed metastatic NSCLC, ECOG 2, no actionable mutations มาด้วยอาการ severe back pain + leg weakness + urinary retention มา 2 วัน

V/S: BP 138/82, HR 92, RR 18, SpO2 96%
Neuro: bilateral lower extremity weakness grade 3/5, sensory level T10, sphincter dysfunction, bladder palpable post-void volume 600 mL

MRI spine: epidural metastasis T8-T9 with cord compression > 50% canal stenosis + edema', '[{"label":"A","text":"Continue chemotherapy + observe"},{"label":"B","text":"Malignant Spinal Cord Compression (MSCC) — oncologic emergency requiring multidisciplinary integrative approach: (1) Immediate IV dexamethasone 10-16 mg loading + 4 mg q6h (reduces cord edema; PRESCO trial supports) (2) Urgent neurosurgery + radiation oncology consult — surgery (decompression + stabilization) + post-op RT shown superior to RT alone in selected ambulatory patients with single-level compression (Patchell trial Lancet 2005); choice based on neurologic status, prognosis, life expectancy, tumor type (3) Concurrent palliative consultation — goals of care discussion (ECOG 2 + metastatic) (4) Pain management (opioids + bisphosphonates for bone pain) (5) DVT prophylaxis (immobile + cancer = high risk) (6) Bladder management (catheter for retention; intermittent catheterization plan) (7) Bowel management (8) Rehab early to maximize function + prevent contracture/decubitus (9) Psychosocial support — patient/family"},{"label":"C","text":"Discharge with oral analgesics"},{"label":"D","text":"MRI brain only — likely cerebral metastasis"},{"label":"E","text":"Aspirin + observe"}]'::jsonb,
  'B', 'Malignant Spinal Cord Compression (MSCC) — oncologic emergency Incidence: 5-10% of cancer patients overall; most common in lung (15%), breast (15%), prostate (15%), lymphoma, myeloma Etiology: - Extradural (95%): vertebral body metastasis → posterior extension - Intradural extramedullary - Intramedullary Levels: thoracic 60% (most common — narrow canal), lumbosacral 30%, cervical 10% Clinical features: 1. **Pain** (95% — earliest, weeks before deficit): back pain, often radicular, worse at night/lying flat 2. **Motor weakness** (75% at presentation): symmetric, lower extremities (in thoracolumbar) 3. **Sensory deficit** (50%): level - dermatome correlates with compression level 4. **Autonomic dysfunction** (late): - **Urinary retention** + overflow incontinence (post-void > 200 mL highly suggestive) - **Constipation** + bowel incontinence - Loss of anal sphincter tone 5. Lhermitte''s sign, hyperreflexia, Babinski + Diagnosis: - **Whole spine MRI with contrast** — gold standard (multifocal in 30%) - CT myelography if MRI contraindicated Management (NICE 2019 + ASCO + ESMO MSCC guidelines): 1. **Glucocorticoid IMMEDIATELY** (don''t wait for imaging): - Dexamethasone 8-16 mg IV loading → 4 mg q6h - Reduces edema, pain, may preserve neurological function - Taper after definitive Rx 2. **Urgent referral within 24 hr**: - **Neurosurgery + Radiation Oncology** - **Multidisciplinary decision**: a. **Surgical decompression + post-op RT** (Patchell trial Lancet 2005): - Superior to RT alone in: single-level compression, expected survival > 3 months, ambulatory, not radiosensitive tumor - 84% vs 57% retention of ambulation b. **Radiation alone**: - Radiosensitive tumors (lymphoma, SCLC, germ cell, multiple myeloma) - Multi-level compression - Poor prognosis - Non-surgical candidate c. **Stereotactic body radiation (SBRT)**: highly conformal, increasingly used d. **Vertebroplasty/kyphoplasty**: pain control in vertebral collapse 3. **Tumor-directed therapy**: - Chemotherapy (highly chemosensitive tumors: lymphoma, germ cell) - Targeted therapy (e.g., EGFR-TKI for EGFR-mutant NSCLC) - Hormonal (prostate, breast) 4. **Supportive care**: - Pain control (multimodal: opioid + adjuvant analgesic + bisphosphonate) - Bisphosphonate or denosumab for skeletal-related events - **DVT prophylaxis** (cancer + immobility = very high risk) - Bladder + bowel management (Foley initially, IC scheduling) - Pressure injury prevention - Early rehabilitation 5. **Goals-of-care discussion**: - Prognosis, expected outcome of intervention - Quality of life - Patient + family values - Palliative care consultation - Advance directives Prognosis: pre-treatment ambulatory status best predictor of post-treatment function — "time is cord" Long-term outcomes: - Median survival after MSCC: 3-6 months (varies by tumor) - Lung cancer: shorter; breast/prostate/myeloma: longer - ตัวเลือก B comprehensive integrative oncology + neurosurgery + palliative + rehab approach. A ผิด — emergency missed. C ผิด — discharge dangerous. D ผิด — MRI brain not relevant. E ผิด — totally inadequate', NULL,
  'hard', 'hemato_onco', 'review',
  'internal_medicine', 'integrative', 'hemato_onco', 'adult',
  'NICE Guideline NG234: Metastatic Spinal Cord Compression 2023; Patchell RA et al. Lancet 2005 (Surgery vs RT in MSCC); Loblaw DA et al. ASCO 2012 Guideline; ESMO Clinical Practice Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ผู้ป่วยอายุ 58 ปี diagnosed metastatic NSCLC, ECOG 2, no actionable mutations มาด้วยอาการ severe back pain + leg weakness + urinary retention มา 2 วัน

V/S: BP 138/82, HR 92, RR 18, SpO2 96%
Neuro: bilateral lower extremity weakness grade 3/5, sensory level T10, sphincter dysfunction, bladder palpable post-void volume 600 mL

MRI spine: epidural metastasis T8-T9 with cord compression > 50% canal stenosis + edema'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 62 ปี underlying HT, DM, dyslipidemia สูบบุหรี่ 30 pack-year มาด้วยอาการเจ็บแน่นหน้าอกแบบทับๆ ร้าวไปกราม + เหงื่อแตก + คลื่นไส้ เริ่ม 45 นาทีที่แล้วขณะทำงาน

V/S: BP 156/94, HR 102, RR 22, SpO2 95% room air, Temp 36.8°C
PE: anxious, diaphoretic, JVP 8, lungs clear, S4 gallop, no murmur

EKG: ST-elevation 2-3 mm in leads II, III, aVF + reciprocal ST depression in I, aVL + ST elevation V4R
Troponin-I: 0.12 (URL 0.04)
CXR: no congestion

Door-to-balloon time ของโรงพยาบาลนี้ < 90 นาที (cath lab พร้อม)', '[{"label":"A","text":"Fibrinolysis (tenecteplase) ทันที + transfer cath lab"},{"label":"B","text":"Inferior STEMI with RV involvement (ST elevation V4R) — กระตุ้น STEMI activation + ASA 162-325 mg chew + P2Y12 inhibitor (ticagrelor 180 mg หรือ prasugrel 60 mg loading) + heparin (UFH 60 U/kg bolus หรือ enoxaparin) + Primary PCI ภายใน 90 นาที + IV fluid bolus (ระวัง nitroglycerin/morphine ที่อาจ drop preload ใน RV infarct)"},{"label":"C","text":"Sublingual NTG ต่อเนื่อง + IV morphine + observe in ED"},{"label":"D","text":"Beta-blocker IV ทันทีก่อน reperfusion"},{"label":"E","text":"Coronary CT angiography ก่อนเพื่อ confirm diagnosis"}]'::jsonb,
  'B', 'Inferior STEMI with right ventricular (RV) infarct (ST elevation V4R = RV involvement, 30-50% of inferior MI). ACC/AHA + ESC 2023 STEMI guideline: (1) Primary PCI within 90 min door-to-balloon (preferred over fibrinolysis if available within 120 min). (2) DAPT loading: ASA + ticagrelor/prasugrel (prasugrel contraindicated in TIA/stroke history หรือ > 75 ปี). (3) Anticoagulation: UFH bolus. (4) **RV infarct caveats**: preload-dependent — avoid nitrates, morphine, diuretics (drop preload → hypotension); give IV NSS fluid bolus; dobutamine ถ้า cardiogenic shock. (5) Beta-blocker IV avoid in early phase ของ RV infarct (worsens bradyarrhythmias). A ผิดเพราะ PCI พร้อม. C ผิด — NTG อันตรายใน RV infarct. D ผิด — beta-blocker IV early เพิ่ม cardiogenic shock risk. E ผิด — STEMI = no time for CTA.', NULL,
  'medium', 'cardiovascular', 'review',
  'internal_medicine', 'clinical_decision', 'cardiovascular', 'adult',
  'ACC/AHA Guideline for the Management of Patients with STEMI 2013 (update 2022); ESC Guidelines for the Management of ACS 2023', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 62 ปี underlying HT, DM, dyslipidemia สูบบุหรี่ 30 pack-year มาด้วยอาการเจ็บแน่นหน้าอกแบบทับๆ ร้าวไปกราม + เหงื่อแตก + คลื่นไส้ เริ่ม 45 นาทีที่แล้วขณะทำงาน

V/S: BP 156/94, HR 102, RR 22, SpO2 95% room air, Temp 36.8°C
PE: anxious, diaphoretic, JVP 8, lungs clear, S4 gallop, no murmur

EKG: ST-elevation 2-3 mm in leads II, III, aVF + reciprocal ST depression in I, aVL + ST elevation V4R
Troponin-I: 0.12 (URL 0.04)
CXR: no congestion

Door-to-balloon time ของโรงพยาบาลนี้ < 90 นาที (cath lab พร้อม)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 74 ปี underlying HT, T2DM มา ED ด้วยใจสั่น + เหนื่อย onset 6 ชม. ไม่มีเจ็บอก ไม่ syncope

V/S: BP 128/78, HR 142 irregularly irregular, RR 20, SpO2 96%, Temp 36.6°C
PE: irregular pulse, no murmur, lungs clear, no edema

EKG: atrial fibrillation, no flutter waves, rate 138-148, no ST changes, no LVH strain
Troponin negative, TSH 1.8, electrolytes normal, BNP 320
Echo (prior): LVEF 55%, mild LAE, no valve disease, no thrombus

CHA2DS2-VASc = 4, HAS-BLED = 2', '[{"label":"A","text":"Synchronized cardioversion ทันทีเพราะ HR > 140"},{"label":"B","text":"Stable AF with RVR — rate control first (IV metoprolol 5 mg q5min × 3 หรือ IV diltiazem 0.25 mg/kg) target HR < 110 + assess thromboembolic risk (CHA2DS2-VASc 4 = anticoagulation indicated) + start DOAC (apixaban หรือ rivaroxaban) — NO need for TEE if duration > 48 hr และไม่ planning cardioversion ทันที + arrange rhythm vs rate strategy พิจารณา outpatient"},{"label":"C","text":"Digoxin IV monotherapy"},{"label":"D","text":"Aspirin 81 mg alone for stroke prevention"},{"label":"E","text":"IV amiodarone bolus + immediate cardioversion without anticoagulation"}]'::jsonb,
  'B', 'Atrial fibrillation with rapid ventricular response, hemodynamically stable. ACC/AHA/ACCP/HRS 2023 AF guideline: (1) Rate control acute: IV beta-blocker (metoprolol, esmolol) หรือ non-dihydropyridine CCB (diltiazem, verapamil); avoid CCB ใน HFrEF. Target resting HR < 110 (RACE II showed lenient ≈ strict). (2) Rhythm control: cardioversion ถ้า hemodynamic unstable, new-onset symptomatic, หรือ EAST-AFNET 4 strategy ใน early AF. (3) Thromboembolic prophylaxis ตาม CHA2DS2-VASc — ≥ 2 ผู้ชาย หรือ ≥ 3 ผู้หญิง → OAC (DOAC preferred over warfarin ใน non-valvular AF). HAS-BLED ไม่ใช่ contraindication — guides bleeding risk modification. (4) AF > 48 hr or unknown duration: anticoagulate ≥ 3 weeks before cardioversion หรือ TEE-guided. (5) Digoxin: 2nd line, slow onset, narrow therapeutic index — not preferred monotherapy. A ผิด — stable. C ผิด — digoxin slow. D ผิด — ASA inferior to OAC ใน AF. E ผิด — risk of stroke if cardioversion without anticoagulation in long duration AF.', NULL,
  'medium', 'cardiovascular', 'review',
  'internal_medicine', 'clinical_decision', 'cardiovascular', 'adult',
  'ACC/AHA/ACCP/HRS 2023 Guideline for Diagnosis and Management of Atrial Fibrillation; ESC AF Guideline 2020; EAST-AFNET 4 NEJM 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 74 ปี underlying HT, T2DM มา ED ด้วยใจสั่น + เหนื่อย onset 6 ชม. ไม่มีเจ็บอก ไม่ syncope

V/S: BP 128/78, HR 142 irregularly irregular, RR 20, SpO2 96%, Temp 36.6°C
PE: irregular pulse, no murmur, lungs clear, no edema

EKG: atrial fibrillation, no flutter waves, rate 138-148, no ST changes, no LVH strain
Troponin negative, TSH 1.8, electrolytes normal, BNP 320
Echo (prior): LVEF 55%, mild LAE, no valve disease, no thrombus

CHA2DS2-VASc = 4, HAS-BLED = 2'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 28 ปี ไม่มีโรคประจำตัว มาด้วยอาการเป็นลม syncope ขณะวิ่งออกกำลังกาย ฟื้นเองภายใน 30 วินาที ไม่มี postictal phase ไม่มี tongue bite, ไม่มี incontinence ก่อนหน้านี้มี episodes คล้ายกัน 2 ครั้งใน 1 ปี

Family history: cousin เสียชีวิตอย่างกะทันหันอายุ 32

V/S: BP 124/76, HR 68, RR 16, SpO2 99%
PE: harsh systolic ejection murmur LSB grade 3/6, **เพิ่มขึ้นด้วย Valsalva + standing**, no carotid radiation

EKG: LVH, deep narrow Q in V4-V6, T wave inversion lateral leads
Echo: asymmetric septal hypertrophy 22 mm, SAM of MV +, LVOT gradient at rest 35 mmHg, provocation 90 mmHg', '[{"label":"A","text":"Endurance training program + ACEi"},{"label":"B","text":"Aortic stenosis — refer for surgical AVR"},{"label":"C","text":"Hypertrophic cardiomyopathy with LVOT obstruction + exertional syncope (high SCD risk) — restrict competitive sports + beta-blocker (metoprolol) หรือ non-DHP CCB (verapamil) + genetic counseling + cascade family screening + risk-stratify for ICD (HCM Risk-SCD score + family history of SCD + unexplained syncope) → strongly consider primary prevention ICD; mavacamten (cardiac myosin inhibitor) เป็น option ในรายที่ symptomatic obstruction"},{"label":"D","text":"Loop diuretic + nitrate for relief"},{"label":"E","text":"Coronary angiography ก่อนพิจารณาอื่นใด"}]'::jsonb,
  'C', 'Hypertrophic cardiomyopathy (HCM) with LVOT obstruction. Clues: young adult exertional syncope, harsh systolic murmur that ↑ with Valsalva/standing (reduces preload, worsens LVOT obstruction — opposite of AS), asymmetric septal hypertrophy + SAM, family history of SCD. AHA/ACC 2020 HCM + ESC 2023 Cardiomyopathy guideline: (1) Restrict high-intensity competitive sports — leading cause of SCD in young athletes. (2) Negative inotropes/chronotropes: non-vasodilating beta-blocker (metoprolol, atenolol) first-line; verapamil/diltiazem if BB intolerant; disopyramide added if persistent obstruction. (3) Avoid: vasodilators (ACEi, nitrates), pure diuretics (decrease preload → worsen LVOT gradient), digoxin. (4) Mavacamten (FDA 2022) — myosin inhibitor for obstructive HCM. (5) Septal reduction (myectomy preferred; alcohol septal ablation alternative) ใน refractory NYHA III/IV. (6) ICD primary prevention: major risk markers — FHx SCD, unexplained syncope, NSVT, massive LVH ≥ 30 mm, abnormal BP response, LV apical aneurysm. HCM Risk-SCD score guides 5-yr SCD risk. (7) Cascade genetic screening of 1st degree relatives. A ผิด — sport restriction needed. B ผิด — murmur ↑ with Valsalva = HCM, not AS (AS ↓). D ผิด — diuretic/nitrate worsen. E ผิด — coronary not the issue.', NULL,
  'hard', 'cardiovascular', 'review',
  'internal_medicine', 'clinical_decision', 'cardiovascular', 'adult',
  'AHA/ACC 2020 Guideline for the Diagnosis and Treatment of Patients with Hypertrophic Cardiomyopathy; ESC 2023 Cardiomyopathy Guideline; EXPLORER-HCM Trial (Lancet 2020)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 28 ปี ไม่มีโรคประจำตัว มาด้วยอาการเป็นลม syncope ขณะวิ่งออกกำลังกาย ฟื้นเองภายใน 30 วินาที ไม่มี postictal phase ไม่มี tongue bite, ไม่มี incontinence ก่อนหน้านี้มี episodes คล้ายกัน 2 ครั้งใน 1 ปี

Family history: cousin เสียชีวิตอย่างกะทันหันอายุ 32

V/S: BP 124/76, HR 68, RR 16, SpO2 99%
PE: harsh systolic ejection murmur LSB grade 3/6, **เพิ่มขึ้นด้วย Valsalva + standing**, no carotid radiation

EKG: LVH, deep narrow Q in V4-V6, T wave inversion lateral leads
Echo: asymmetric septal hypertrophy 22 mm, SAM of MV +, LVOT gradient at rest 35 mmHg, provocation 90 mmHg'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 68 ปี underlying HT มา ED ด้วยเหนื่อยมากขึ้น exertional + เป็นลม 1 ครั้ง 2 สัปดาห์ก่อน เจ็บอกเล็กน้อยเวลาเดินขึ้นบันได

V/S: BP 138/64 (wide pulse pressure), HR 72, RR 18, SpO2 97%
PE: harsh systolic ejection murmur RUSB radiating to carotids grade 4/6, **decreases with Valsalva**, soft S2, delayed carotid upstroke (parvus et tardus)

Echo: severe aortic stenosis — peak velocity 4.6 m/s, mean gradient 52 mmHg, AVA 0.8 cm², LVEF 60%
CAG: 70% mid-LAD stenosis
STS score: 3.2% (low-intermediate)', '[{"label":"A","text":"Medical therapy (statins + ASA) + observe"},{"label":"B","text":"Symptomatic severe AS (syncope, angina, dyspnea = class I indication for AVR) — Heart team evaluation; SAVR vs TAVR based on age, anatomy, comorbidities; in this patient (68 ปี, intermediate risk, concomitant CAD) — consider SAVR + CABG หรือ TAVR + staged PCI; valve choice (bioprosthetic vs mechanical) + lifelong follow-up; antibiotic prophylaxis IE สำหรับ procedures certain"},{"label":"C","text":"Balloon valvuloplasty as definitive treatment"},{"label":"D","text":"ACEi + nitrate ลด afterload"},{"label":"E","text":"Repeat echo ใน 1 ปี"}]'::jsonb,
  'B', 'Severe symptomatic aortic stenosis — "SAD" (syncope, angina, dyspnea) classic triad portends median survival 2-3 years without intervention. ACC/AHA 2020 Valvular Heart Disease guideline: (1) Severe AS criteria: peak velocity ≥ 4 m/s, mean gradient ≥ 40 mmHg, AVA ≤ 1 cm². (2) Class I AVR indications: symptomatic severe AS, asymptomatic severe AS with LVEF < 50%, undergoing cardiac surgery for other reason. (3) Heart team decides SAVR vs TAVR: - SAVR preferred: < 65 yr, low surgical risk, bicuspid valve with aortopathy, mechanical valve preference. - TAVR preferred: > 80 yr, high/prohibitive surgical risk; expanding to intermediate-risk based on PARTNER 3, Evolut Low Risk trials showing non-inferior outcomes in low-risk 65-80 yr. (4) Concomitant CAD: significant disease → revascularize (CABG with SAVR; staged PCI with TAVR). (5) Avoid ACEi/nitrate ใน severe AS (preload-dependent → may cause hypotension/syncope). (6) Valvuloplasty: bridge or palliative — high restenosis rate. A ผิด — symptomatic = AVR. C ผิด — palliative only. D ผิด — vasodilators risky. E ผิด — symptomatic = act now.', NULL,
  'medium', 'cardiovascular', 'review',
  'internal_medicine', 'clinical_decision', 'cardiovascular', 'adult',
  'ACC/AHA 2020 Guideline for the Management of Patients with Valvular Heart Disease; PARTNER 3 NEJM 2019; Evolut Low Risk NEJM 2019', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 68 ปี underlying HT มา ED ด้วยเหนื่อยมากขึ้น exertional + เป็นลม 1 ครั้ง 2 สัปดาห์ก่อน เจ็บอกเล็กน้อยเวลาเดินขึ้นบันได

V/S: BP 138/64 (wide pulse pressure), HR 72, RR 18, SpO2 97%
PE: harsh systolic ejection murmur RUSB radiating to carotids grade 4/6, **decreases with Valsalva**, soft S2, delayed carotid upstroke (parvus et tardus)

Echo: severe aortic stenosis — peak velocity 4.6 m/s, mean gradient 52 mmHg, AVA 0.8 cm², LVEF 60%
CAG: 70% mid-LAD stenosis
STS score: 3.2% (low-intermediate)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 76 ปี underlying HF (LVEF 30% on guideline-directed medical therapy: bisoprolol 5 mg, sacubitril/valsartan 49/51 mg BID, spironolactone 25 mg, dapagliflozin 10 mg), NYHA II baseline มา ED ด้วยใจสั่น เป็นลม syncope 30 นาทีก่อน

V/S: BP 88/56, HR 168 wide complex, RR 24, SpO2 92%, GCS 14
EKG: monomorphic wide complex tachycardia (QRS 180 ms), AV dissociation +, fusion beats, capture beats — sustained > 30 sec, hemodynamically unstable
K 4.0, Mg 2.0, Troponin pending', '[{"label":"A","text":"IV adenosine 6 mg push"},{"label":"B","text":"Sustained monomorphic VT with hemodynamic instability — Immediate synchronized DC cardioversion 100-200 J (biphasic) + ACLS protocol; after restoration → IV amiodarone 150 mg over 10 min then 1 mg/min infusion; reverse precipitants (electrolyte, ischemia); long-term: ICD secondary prevention (Class I — sustained VT in LVEF ≤ 35%), EP study + ablation consideration, optimize GDMT"},{"label":"C","text":"IV beta-blocker (metoprolol) bolus"},{"label":"D","text":"Carotid sinus massage"},{"label":"E","text":"Lidocaine IV monotherapy as first-line"}]'::jsonb,
  'B', 'Sustained monomorphic ventricular tachycardia (VT) with hemodynamic instability (hypotension, syncope). VT clues in wide-complex tachycardia: AV dissociation, fusion/capture beats, QRS > 140 ms, structural heart disease (HFrEF). ACLS + AHA/HRS Ventricular Arrhythmia guideline 2017: (1) Unstable VT → immediate synchronized DC cardioversion 100-200 J biphasic. Pulseless VT/VF → defibrillation. (2) Post-conversion antiarrhythmic: amiodarone (first-line in HFrEF), lidocaine alternative ใน ischemic VT. Procainamide for stable VT (PROCAMIO trial). (3) Reverse precipitants: electrolytes (K, Mg), ischemia, drug toxicity. (4) ICD secondary prevention is Class I for sustained VT/VF survivors with LVEF ≤ 35% (AVID, CIDS trials). (5) EP study + catheter ablation: refractory VT or appropriate ICD shocks. (6) Adenosine, vagal maneuvers, BB IV bolus: useful in SVT, NOT VT — risk of hemodynamic collapse. A ผิด — adenosine for SVT, not VT. C ผิด — IV BB can precipitate collapse. D ผิด — for SVT. E ผิด — amiodarone preferred in HFrEF.', NULL,
  'hard', 'cardiovascular', 'review',
  'internal_medicine', 'clinical_decision', 'cardiovascular', 'adult',
  'AHA/ACC/HRS 2017 Guideline for Management of Patients with Ventricular Arrhythmias and Prevention of Sudden Cardiac Death; AVID Trial NEJM 1997', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 76 ปี underlying HF (LVEF 30% on guideline-directed medical therapy: bisoprolol 5 mg, sacubitril/valsartan 49/51 mg BID, spironolactone 25 mg, dapagliflozin 10 mg), NYHA II baseline มา ED ด้วยใจสั่น เป็นลม syncope 30 นาทีก่อน

V/S: BP 88/56, HR 168 wide complex, RR 24, SpO2 92%, GCS 14
EKG: monomorphic wide complex tachycardia (QRS 180 ms), AV dissociation +, fusion beats, capture beats — sustained > 30 sec, hemodynamically unstable
K 4.0, Mg 2.0, Troponin pending'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 58 ปี underlying obesity, recent total knee arthroplasty 7 วันก่อน มา ED ด้วยอาการเจ็บอกแบบ pleuritic + เหนื่อย onset 2 ชม. ไอเล็กน้อยมีเลือดปน

V/S: BP 102/68, HR 118, RR 28, SpO2 88% room air → 94% on 4L NC, Temp 37.4°C
PE: clear lungs, no edema, calf ขวา tender + swelling 3 cm difference

Lab: D-dimer 4,800 ng/mL, Troponin 0.08 (low elevation), BNP 480
EKG: sinus tachycardia 118, S1Q3T3 pattern, RBBB new
CXR: clear, no infiltrate
CT pulmonary angiography: bilateral segmental + subsegmental PE + RV/LV diameter ratio 1.2 (RV strain), no saddle thrombus
Echo: RV dilation + RV hypokinesis, septal flattening, no thrombus

sPESI: 2 (high risk), BP stable but borderline', '[{"label":"A","text":"Outpatient management with rivaroxaban + early discharge"},{"label":"B","text":"Intermediate-high risk submassive PE (RV strain + biomarker elevation, hemodynamically stable but borderline) — admit ICU/step-down + therapeutic anticoagulation (UFH preferred if escalation to thrombolytic likely, หรือ LMWH) + monitor for decompensation + consider catheter-directed thrombolysis if deterioration หรือ systemic thrombolytic (alteplase 100 mg) ถ้า cardiac arrest หรือ persistent hypotension; AVOID lytic ใน recent surgery unless catastrophic (recent surgery 7 d = relative contraindication)"},{"label":"C","text":"Aspirin alone for antithrombotic"},{"label":"D","text":"IVC filter ใส่ทันทีโดยไม่ anticoagulate"},{"label":"E","text":"Systemic thrombolytic ทันทีเป็น first-line"}]'::jsonb,
  'B', 'Intermediate-high risk (submassive) pulmonary embolism — RV dysfunction + elevated troponin, hemodynamically stable but at risk for decompensation. ESC 2019 + AHA 2011 + CHEST 2021 PE guideline: (1) Risk stratification: massive (shock) → systemic lytic / catheter-directed; submassive (RV strain + biomarker) → close monitoring + anticoagulation, escalate ถ้า deteriorate (MOPETT, PEITHO data); low-risk → outpatient DOAC. (2) Anticoagulation: UFH (titratable, reversible, preferred if planning intervention), LMWH (enoxaparin), หรือ DOAC after acute phase. (3) Systemic thrombolytic (alteplase 100 mg over 2 hr) for massive PE — bleeding risk 10-20%. (4) Recent surgery (< 14 days) = relative contraindication to systemic lysis; catheter-directed thrombolysis (lower dose) safer alternative — SEATTLE II, OPTALYSE. (5) IVC filter: indication = contraindication to anticoagulation; not as standalone treatment. A ผิด — submassive ≠ outpatient. C ผิด — ASA ไม่พอ. D ผิด — IVC filter requires anticoagulation when possible. E ผิด — risk-benefit unfavorable post-op without instability.', NULL,
  'hard', 'respiratory', 'review',
  'internal_medicine', 'clinical_decision', 'respiratory', 'adult',
  'ESC Guidelines for the Diagnosis and Management of Acute Pulmonary Embolism 2019; CHEST Guideline on Antithrombotic Therapy for VTE 2021; PEITHO Trial NEJM 2014', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 58 ปี underlying obesity, recent total knee arthroplasty 7 วันก่อน มา ED ด้วยอาการเจ็บอกแบบ pleuritic + เหนื่อย onset 2 ชม. ไอเล็กน้อยมีเลือดปน

V/S: BP 102/68, HR 118, RR 28, SpO2 88% room air → 94% on 4L NC, Temp 37.4°C
PE: clear lungs, no edema, calf ขวา tender + swelling 3 cm difference

Lab: D-dimer 4,800 ng/mL, Troponin 0.08 (low elevation), BNP 480
EKG: sinus tachycardia 118, S1Q3T3 pattern, RBBB new
CXR: clear, no infiltrate
CT pulmonary angiography: bilateral segmental + subsegmental PE + RV/LV diameter ratio 1.2 (RV strain), no saddle thrombus
Echo: RV dilation + RV hypokinesis, septal flattening, no thrombus

sPESI: 2 (high risk), BP stable but borderline'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 70 ปี underlying COPD GOLD III (FEV1 38% predicted) on tiotropium + LABA + ICS, recent URI 5 วันก่อน มา ED ด้วยเหนื่อยมากขึ้น เสมหะเปลี่ยนสีเหลือง-เขียว ปริมาณเพิ่ม

V/S: BP 138/82, HR 108, RR 28, SpO2 86% room air → 91% on 2L NC, Temp 37.6°C
PE: pursed-lip breathing, accessory muscle use, prolonged expiration, diffuse rhonchi + scattered wheeze, no consolidation
ABG room air: pH 7.32, PaCO2 58, PaO2 54, HCO3 30 (chronic + acute on top)
CXR: hyperinflated lungs, no infiltrate, no pneumothorax', '[{"label":"A","text":"100% oxygen via non-rebreather mask"},{"label":"B","text":"COPD exacerbation with hypercapnic respiratory failure — controlled oxygen target SpO2 88-92% (venturi 24-28%) + nebulized short-acting bronchodilator (salbutamol + ipratropium q4-6h) + systemic corticosteroid (prednisolone 40 mg PO × 5 d หรือ methylprednisolone IV) + antibiotic (amoxicillin-clavulanate or doxycycline — Anthonisen criteria 3) + NIV (BiPAP) for pH < 7.35 + PaCO2 > 45 + monitor; intubation ถ้า NIV fail หรือ contraindicated"},{"label":"C","text":"High-dose IV theophylline as first-line bronchodilator"},{"label":"D","text":"Intubation ทันทีโดยไม่ลอง NIV ก่อน"},{"label":"E","text":"Furosemide IV for pulmonary edema"}]'::jsonb,
  'B', 'COPD exacerbation with acute-on-chronic hypercapnic respiratory failure (pH 7.32, PaCO2 58, elevated HCO3 = chronic compensation + acute decompensation). GOLD 2024 + Thai COPD guideline: (1) Controlled oxygen: target SpO2 88-92% (high FiO2 → worsening hypercapnia via Haldane effect, V/Q mismatch, ↓ respiratory drive). (2) Bronchodilator: nebulized SABA + SAMA (salbutamol + ipratropium). (3) Systemic corticosteroid: prednisolone 40 mg/day × 5 days (REDUCE trial — 5 d non-inferior 14 d), reduces relapse + LOS. (4) Antibiotic: Anthonisen ≥ 2 of 3 (↑ dyspnea, ↑ sputum volume, ↑ purulence) — typically amoxicillin-clavulanate, doxycycline, macrolide 5-7 days; cover Pseudomonas (cipro/levofloxacin) ถ้า severe + recent hospitalization. (5) NIV (BiPAP) Class I for pH < 7.35 + PaCO2 > 45 + respiratory distress — reduces mortality + intubation rate (Cochrane). (6) Methylxanthines: not routine — narrow therapeutic, side effects. A ผิด — high FiO2 → worsens hypercapnia. C ผิด — theophylline not first-line. D ผิด — try NIV first. E ผิด — not edema.', NULL,
  'medium', 'respiratory', 'review',
  'internal_medicine', 'clinical_decision', 'respiratory', 'adult',
  'GOLD Global Strategy for Diagnosis, Management, and Prevention of COPD 2024; REDUCE Trial JAMA 2013; ERS/ATS COPD Exacerbation Guideline 2017', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 70 ปี underlying COPD GOLD III (FEV1 38% predicted) on tiotropium + LABA + ICS, recent URI 5 วันก่อน มา ED ด้วยเหนื่อยมากขึ้น เสมหะเปลี่ยนสีเหลือง-เขียว ปริมาณเพิ่ม

V/S: BP 138/82, HR 108, RR 28, SpO2 86% room air → 91% on 2L NC, Temp 37.6°C
PE: pursed-lip breathing, accessory muscle use, prolonged expiration, diffuse rhonchi + scattered wheeze, no consolidation
ABG room air: pH 7.32, PaCO2 58, PaO2 54, HCO3 30 (chronic + acute on top)
CXR: hyperinflated lungs, no infiltrate, no pneumothorax'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 32 ปี underlying asthma, allergic rhinitis on ICS-LABA (budesonide/formoterol) + albuterol PRN มา ED ด้วยอาการเหนื่อยมาก พูดได้แค่ครั้งละคำ คล้ายจะหมดสติ ใช้ albuterol MDI 20 puffs ใน 1 ชม. ก่อนมา ไม่ดีขึ้น

V/S: BP 142/88, HR 132, RR 36, SpO2 88% room air, Temp 37.0°C
PE: tripod position, accessory muscle use, **silent chest bilateral** (no wheeze), prolonged expiration, drowsy borderline
PEFR ทำไม่ได้ (too distressed)
ABG room air: pH 7.30, PaCO2 48, PaO2 58 (normal-elevated CO2 in asthma = exhaustion sign)', '[{"label":"A","text":"Continue MDI albuterol + observation"},{"label":"B","text":"Near-fatal asthma exacerbation (silent chest, normal/rising CO2 in tachypneic asthmatic = impending respiratory failure) — Continuous nebulized salbutamol + ipratropium + IV magnesium sulfate 2 g over 20 min + systemic corticosteroid (IV hydrocortisone 100 mg หรือ oral prednisolone 50 mg) + high-flow O2 + early ICU + prepare for intubation (rapid sequence, ketamine preferred bronchodilator effect) with lung-protective + permissive hypercapnia + IV epinephrine ถ้า peri-arrest"},{"label":"C","text":"IV theophylline as primary therapy"},{"label":"D","text":"IV beta-blocker เพื่อ control HR"},{"label":"E","text":"Discharge with new MDI + oral steroid + return precautions"}]'::jsonb,
  'B', 'Near-fatal asthma (status asthmaticus). Critical signs: silent chest (no air movement), normal/rising PaCO2 in asthmatic with tachypnea (should be hypocapnic — "normal" CO2 = exhaustion), drowsiness, cannot complete words. GINA 2024 + Thai Asthma guideline: (1) Inhaled SABA: continuous nebulized salbutamol 5 mg + ipratropium 0.5 mg q20min × 3, then q1-4h. (2) Systemic glucocorticoid: oral prednisolone 50 mg or IV hydrocortisone 100 mg q6h (slow onset 4-6 hr; reduces relapse). (3) IV magnesium sulfate 2 g over 20 min — bronchodilator + adjunct in severe (3 Mg trial). (4) Oxygen target SpO2 93-95%. (5) Intubation indications: silent chest, exhaustion, ↓ consciousness, rising CO2 — use ketamine (bronchodilator), lung-protective vent (low TV 6 mL/kg, permissive hypercapnia, longer expiratory time, watch dynamic hyperinflation). (6) Adjuncts: heliox (decreased airflow resistance), ECMO ใน refractory. (7) Epinephrine IM/IV in peri-arrest or anaphylaxis component. A ผิด — failed already. C ผิด — theophylline ไม่ใช่ primary. D ผิด — BB contraindicated severe asthma. E ผิด — near-fatal = ICU not discharge.', NULL,
  'hard', 'respiratory', 'review',
  'internal_medicine', 'clinical_decision', 'respiratory', 'adult',
  'GINA Global Strategy for Asthma Management and Prevention 2024; British Thoracic Society/SIGN Asthma Guideline 2019; 3Mg Trial Lancet RM 2013', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 32 ปี underlying asthma, allergic rhinitis on ICS-LABA (budesonide/formoterol) + albuterol PRN มา ED ด้วยอาการเหนื่อยมาก พูดได้แค่ครั้งละคำ คล้ายจะหมดสติ ใช้ albuterol MDI 20 puffs ใน 1 ชม. ก่อนมา ไม่ดีขึ้น

V/S: BP 142/88, HR 132, RR 36, SpO2 88% room air, Temp 37.0°C
PE: tripod position, accessory muscle use, **silent chest bilateral** (no wheeze), prolonged expiration, drowsy borderline
PEFR ทำไม่ได้ (too distressed)
ABG room air: pH 7.30, PaCO2 48, PaO2 58 (normal-elevated CO2 in asthma = exhaustion sign)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 55 ปี ไม่มีโรคประจำตัวที่ทราบ มา ED ด้วยอาเจียนเป็นเลือดสดและก้อนเลือดดำ 3 ครั้งใน 2 ชม. + ถ่ายอุจจาระดำเหนียว 2 ครั้ง ก่อนหน้านี้ดื่มสุราหนัก 30 ปี

V/S: BP 88/56 (orthostatic +), HR 124, RR 22, SpO2 96%, Temp 36.5°C
PE: pale, jaundice +, spider angioma, palmar erythema, abdominal distension + shifting dullness +, splenomegaly, no asterixis

Lab: Hb 7.2 (baseline unknown), Plt 78,000, INR 1.8, BUN 48, Cr 1.0, Bilirubin 3.4, Albumin 2.4, AST 92, ALT 48, Ammonia 68
FAST: moderate ascites', '[{"label":"A","text":"NSAID for pain + observe + delayed EGD"},{"label":"B","text":"Variceal UGIB in cirrhosis — resuscitation 2 large-bore IV + crystalloid restricted (avoid over-resuscitation worsens variceal bleeding — target SBP 90-100, Hb 7-8) + restrictive PRC transfusion (Hb 7-8 trigger, Villanueva NEJM 2013) + IV octreotide (50 mcg bolus → 50 mcg/hr × 3-5 d) + IV ceftriaxone 1 g/d × 7 d prophylaxis SBP/BBI + IV PPI bolus then drip + urgent EGD within 12 hr with band ligation; if uncontrolled → TIPS (rescue) หรือ Sengstaken-Blakemore bridging"},{"label":"C","text":"Massive crystalloid resuscitation (5 L NSS) + transfusion to Hb 12"},{"label":"D","text":"Vasopressin IV alone without endoscopy"},{"label":"E","text":"Tranexamic acid only"}]'::jsonb,
  'B', 'Acute variceal bleeding in cirrhosis (stigmata of chronic liver disease + portal hypertension). AASLD 2017 + Baveno VII 2022 portal hypertension guideline: (1) Resuscitation: avoid over-transfusion (↑ portal pressure → rebleed; Villanueva NEJM 2013 — restrictive Hb 7-8 trigger reduces mortality vs liberal Hb 9-10). (2) Splanchnic vasoconstrictor: octreotide / terlipressin / somatostatin × 3-5 days. (3) Prophylactic antibiotic (ceftriaxone or norfloxacin) × 7 days — reduces infection, rebleeding, mortality (Bernard Hepatology 1999). (4) Urgent endoscopy within 12 hr: variceal band ligation (1st choice esophageal), tissue glue (gastric varices). (5) PPI infusion — empiric until endoscopy distinguishes variceal from peptic ulcer. (6) Rescue: TIPS (early TIPS within 72 hr in Child-Pugh B with active bleeding or C; García-Pagán NEJM 2010), balloon tamponade (24 hr bridging), self-expanding metal stent. (7) Secondary prevention after acute: NSBB (propranolol/carvedilol) + repeat EBL. A ผิด — NSAID worsens bleeding. C ผิด — over-resuscitation increases rebleed/mortality. D ผิด — endoscopy essential. E ผิด — TXA ไม่ลด mortality ใน UGIB (HALT-IT 2020).', NULL,
  'hard', 'gi', 'review',
  'internal_medicine', 'clinical_decision', 'gi', 'adult',
  'AASLD Practice Guidance on Portal Hypertensive Bleeding in Cirrhosis 2017; Baveno VII Consensus Workshop on Portal Hypertension 2022; Villanueva C et al. NEJM 2013', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 55 ปี ไม่มีโรคประจำตัวที่ทราบ มา ED ด้วยอาเจียนเป็นเลือดสดและก้อนเลือดดำ 3 ครั้งใน 2 ชม. + ถ่ายอุจจาระดำเหนียว 2 ครั้ง ก่อนหน้านี้ดื่มสุราหนัก 30 ปี

V/S: BP 88/56 (orthostatic +), HR 124, RR 22, SpO2 96%, Temp 36.5°C
PE: pale, jaundice +, spider angioma, palmar erythema, abdominal distension + shifting dullness +, splenomegaly, no asterixis

Lab: Hb 7.2 (baseline unknown), Plt 78,000, INR 1.8, BUN 48, Cr 1.0, Bilirubin 3.4, Albumin 2.4, AST 92, ALT 48, Ammonia 68
FAST: moderate ascites'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 42 ปี underlying chronic hepatitis B (HBeAg negative, HBV DNA 12,000 IU/mL, ALT 92, AST 78 — moderately elevated > 2 ULN x 6 เดือน) Fibroscan 9.8 kPa (F3 fibrosis), ไม่มี HCC จาก US + AFP, ไม่ตั้งครรภ์ ปฏิเสธ alcohol

ไม่มี co-infection HIV/HCV/HDV, eGFR 95, T-spine X-ray normal', '[{"label":"A","text":"Observation อย่างเดียว เพราะ HBeAg negative"},{"label":"B","text":"Chronic HBeAg-negative hepatitis B with active disease + significant fibrosis F3 — initiate antiviral therapy: 1st-line entecavir 0.5 mg/d (high genetic barrier) หรือ tenofovir alafenamide (TAF, preferred ใน bone/renal concern) หรือ tenofovir disoproxil fumarate (TDF) — pegylated interferon alternative ใน selected (younger, HBeAg+, low HBV DNA, high ALT, genotype A); monitor HBV DNA, ALT q3-6เดือน + HCC surveillance (US + AFP q6เดือน — F3/cirrhosis = high risk regardless of viral suppression); duration: until HBsAg loss + 12 เดือน consolidation"},{"label":"C","text":"Tenofovir + entecavir combination เป็น standard"},{"label":"D","text":"Pegylated interferon as preferred 1st-line in HBeAg negative + F3"},{"label":"E","text":"Liver transplant evaluation"}]'::jsonb,
  'B', 'Chronic hepatitis B, HBeAg-negative, active hepatitis (HBV DNA > 2,000 IU/mL + persistently elevated ALT > 2 ULN + significant fibrosis ≥ F2). AASLD 2018 + EASL 2017 + APASL 2015 HBV guideline: (1) Indication for treatment: HBV DNA > 2,000 + ALT > ULN with significant inflammation/fibrosis (≥ F2), OR cirrhosis with any detectable DNA, OR HBeAg+ with persistent ALT elevation. (2) First-line: nucleos(t)ide with high genetic barrier — entecavir, tenofovir (TDF or TAF). - TAF preferred ใน bone disease, CKD, elderly (less nephrotoxic, less bone loss). - TDF preferred ใน pregnancy. - Entecavir avoid ใน lamivudine-resistant. (3) Pegylated interferon: finite duration (48 wk), 30% response, contraindicated cirrhosis decompensated, autoimmune, pregnancy. (4) HCC surveillance: US + AFP every 6 months for cirrhosis, F3 fibrosis, family hx HCC, Asian male > 40, Asian female > 50. (5) Treatment duration: indefinite typically; HBsAg seroconversion = functional cure (rare ~1-3%/yr); consolidate 12 mo before stop. (6) Monitor: HBV DNA, ALT, HBsAg quantitative, HBeAg, Cr (TDF), DXA. A ผิด — active disease + F3 = treat. C ผิด — combo ไม่ใช่ standard ใน chronic Rx-naïve. D ผิด — IFN ไม่ใช่ preferred. E ผิด — F3 ไม่ใช่ end-stage.', NULL,
  'medium', 'gi', 'review',
  'internal_medicine', 'clinical_decision', 'gi', 'adult',
  'AASLD Hepatitis B Guidance Update 2018; EASL Clinical Practice Guidelines on Management of HBV Infection 2017; APASL HBV Guideline 2015', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 42 ปี underlying chronic hepatitis B (HBeAg negative, HBV DNA 12,000 IU/mL, ALT 92, AST 78 — moderately elevated > 2 ULN x 6 เดือน) Fibroscan 9.8 kPa (F3 fibrosis), ไม่มี HCC จาก US + AFP, ไม่ตั้งครรภ์ ปฏิเสธ alcohol

ไม่มี co-infection HIV/HCV/HDV, eGFR 95, T-spine X-ray normal'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 38 ปี ไม่มีโรคประจำตัว มา ED ด้วยปวดท้องบริเวณ epigastrium ร้าวทะลุไปหลังรุนแรง 12 ชม. คลื่นไส้ อาเจียน เคยดื่มสุรา binge 2 วันก่อน

V/S: BP 110/72, HR 116, RR 22, SpO2 96%, Temp 37.8°C
PE: epigastric tenderness, guarding +, decreased bowel sounds, no rebound, no flank discoloration

Lab: Lipase 1,850 (URL 60), Amylase 980, WBC 16,500 (N 88%), Hb 14.2, Plt 320,000, Cr 1.2, BUN 32, Ca 8.4, Glucose 156, AST 68, ALT 42, ALP 110, Bilirubin 1.4, Triglyceride 380, LDH 380, Albumin 3.6
ABG: pH 7.36, PaCO2 36, HCO3 22
US abdomen: no gallstone, no CBD dilation, pancreas edematous
BISAP score: 2, Ranson criteria at admission: 2', '[{"label":"A","text":"NPO + IV NSS 50 mL/hr maintenance + IV PPI"},{"label":"B","text":"Acute pancreatitis (alcohol etiology) — Aggressive but **goal-directed** fluid resuscitation (lactated Ringer''s preferred over NS — WATERFALL trial moderate fluid 1.5 mL/kg/hr after initial bolus, avoid over-resuscitation) + early enteral nutrition (within 24-72 hr — NJ tube if intolerant oral, NOT prolonged NPO) + analgesia (IV opioid: hydromorphone/fentanyl preferred; meperidine avoided) + treat underlying (alcohol cessation, triglyceride <500 not causal here) + NO prophylactic antibiotics in sterile necrosis + monitor for complications (necrosis, pseudocyst, infected necrosis at 2-4 wk, ARDS, AKI)"},{"label":"C","text":"Empirical broad-spectrum antibiotics for all pancreatitis"},{"label":"D","text":"Emergency surgery + necrosectomy"},{"label":"E","text":"ERCP within 24 hr regardless of etiology"}]'::jsonb,
  'B', 'Acute pancreatitis (Atlanta classification — 2 of 3: characteristic pain + lipase/amylase > 3× ULN + imaging). Etiology: alcohol > gallstone here. ACG 2024 + AGA 2018 + WSES guideline: (1) Fluid resuscitation: lactated Ringer (less acidemia, anti-inflammatory) > NS; goal-directed — WATERFALL trial (NEJM 2022) showed aggressive (10 mL/kg bolus + 3 mL/kg/hr) vs moderate (1.5 mL/kg/hr after 10 mL/kg bolus) had MORE fluid overload without improved outcomes → moderate preferred. (2) Early enteral nutrition: within 24-72 hr if tolerating (oral or NJ); reduces infection, mortality vs prolonged NPO (PYTHON trial, Cochrane). (3) Analgesia: IV opioid; meperidine traditional preference is myth — avoid (neurotoxicity). (4) Prophylactic antibiotics: NOT indicated ใน sterile necrotizing pancreatitis (multiple RCT). Use only ใน documented/suspected infected necrosis (gas in collection, persistent sepsis at 7-10 d). (5) ERCP within 24 hr only if cholangitis or persistent biliary obstruction — not in alcoholic. (6) Severity scores: BISAP, Ranson, APACHE II, modified Marshall. (7) Step-up approach for infected necrosis: percutaneous drainage → endoscopic/minimally invasive necrosectomy → open last resort (PANTER trial). A ผิด — under-resuscitation; need early enteral. C ผิด — no prophylactic abx. D ผิด — surgery delayed step-up. E ผิด — ERCP for biliary obstruction only.', NULL,
  'medium', 'gi', 'review',
  'internal_medicine', 'clinical_decision', 'gi', 'adult',
  'ACG Clinical Guideline: Management of Acute Pancreatitis 2024; AGA Institute Guideline on Initial Management of Acute Pancreatitis 2018; WATERFALL Trial NEJM 2022', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 38 ปี ไม่มีโรคประจำตัว มา ED ด้วยปวดท้องบริเวณ epigastrium ร้าวทะลุไปหลังรุนแรง 12 ชม. คลื่นไส้ อาเจียน เคยดื่มสุรา binge 2 วันก่อน

V/S: BP 110/72, HR 116, RR 22, SpO2 96%, Temp 37.8°C
PE: epigastric tenderness, guarding +, decreased bowel sounds, no rebound, no flank discoloration

Lab: Lipase 1,850 (URL 60), Amylase 980, WBC 16,500 (N 88%), Hb 14.2, Plt 320,000, Cr 1.2, BUN 32, Ca 8.4, Glucose 156, AST 68, ALT 42, ALP 110, Bilirubin 1.4, Triglyceride 380, LDH 380, Albumin 3.6
ABG: pH 7.36, PaCO2 36, HCO3 22
US abdomen: no gallstone, no CBD dilation, pancreas edematous
BISAP score: 2, Ranson criteria at admission: 2'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 26 ปี ไม่มีโรคประจำตัว มาด้วยถ่ายเหลวมีมูกเลือดปนมา 3 เดือน ปวดเกร็งท้องน้อย urgency + tenesmus ปวดข้อโดยเฉพาะ ankles, น้ำหนักลด 4 kg, มี iritis 1 ตอน 1 เดือนก่อน

V/S: BP 110/68, HR 92, Temp 37.4°C
Lab: Hb 9.8, MCV 78, Plt 480,000, ESR 62, CRP 38, Albumin 3.0, Cr 0.8, ALT 28, fecal calprotectin 580 (high)
Stool culture, C. difficile toxin, parasites: negative
Colonoscopy: continuous inflammation from rectum to splenic flexure with loss of vascular pattern, friable mucosa, superficial ulcers, no skip lesion, no perianal disease; biopsy = chronic active colitis with crypt abscess, basal plasmacytosis, no granuloma
Surface area involved: 35-40% (left-sided colitis)
Mayo score: 8 (moderate-severe activity)', '[{"label":"A","text":"Antibiotic (metronidazole + ciprofloxacin) เป็น first-line"},{"label":"B","text":"Ulcerative colitis, moderate-severe activity, left-sided — Induction: oral 5-ASA (mesalamine 4.8 g/d) + rectal 5-ASA (enema/suppository) — combined topical + oral superior; if inadequate response in 2-4 wk → add oral systemic corticosteroid (prednisolone 40 mg/d taper) OR budesonide MMX; severe/steroid-refractory → biologic (anti-TNF infliximab, anti-integrin vedolizumab, anti-IL12/23 ustekinumab) หรือ JAK inhibitor (tofacitinib); Maintenance: 5-ASA หรือ biologic ที่ induce remission; colon CA surveillance from 8 yr after dx; extracolonic mgmt (iritis, arthritis)"},{"label":"C","text":"Surgery (total colectomy) เป็น first-line"},{"label":"D","text":"Diet modification + probiotic alone"},{"label":"E","text":"Empirical antiparasitic"}]'::jsonb,
  'B', 'Ulcerative colitis (UC) — continuous inflammation from rectum, crypt abscess, no granuloma, no skip lesion, with extraintestinal manifestations (peripheral arthritis, iritis). ACG 2019 + AGA 2020 + ECCO 2022 UC guideline: (1) Severity: Mayo score, Truelove-Witts; moderate-severe = systemic illness, frequent stool, anemia. (2) Mild-moderate left-sided UC: oral + topical 5-ASA combination (Cochrane — superior to either alone). (3) Moderate-severe: oral prednisolone 40 mg/day or budesonide MMX (lower side effect); if refractory → biologic. (4) Biologics: anti-TNF (infliximab, adalimumab), vedolizumab (gut-selective, safer profile), ustekinumab; JAK inhibitor tofacitinib, upadacitinib. (5) Acute severe UC (Truelove-Witts severe): IV methylprednisolone 60 mg/day, calprotectin/CRP rapid assessment day 3; if non-response → infliximab rescue or cyclosporine; colectomy if no response by day 7. (6) Maintenance: avoid chronic steroids; 5-ASA, immunomodulator, biologic. (7) Surveillance: chromoendoscopy or HD-WL colonoscopy from 8 yr after UC dx (annual to 5-yearly based on risk). (8) Extraintestinal: peripheral arthritis tracks disease activity, axial doesn''t; iritis = urgent ophthalmologic referral. A ผิด — antibiotic เฉพาะ pouchitis, perianal CD. C ผิด — surgery refractory or dysplasia/CA. D ผิด — diet alone ไม่พอ moderate-severe. E ผิด — no evidence parasite.', NULL,
  'medium', 'gi', 'review',
  'internal_medicine', 'clinical_decision', 'gi', 'adult',
  'ACG Clinical Guideline: Ulcerative Colitis in Adults 2019; AGA Institute Guideline on UC Management 2020; ECCO Guideline on Therapeutics in UC 2022', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 26 ปี ไม่มีโรคประจำตัว มาด้วยถ่ายเหลวมีมูกเลือดปนมา 3 เดือน ปวดเกร็งท้องน้อย urgency + tenesmus ปวดข้อโดยเฉพาะ ankles, น้ำหนักลด 4 kg, มี iritis 1 ตอน 1 เดือนก่อน

V/S: BP 110/68, HR 92, Temp 37.4°C
Lab: Hb 9.8, MCV 78, Plt 480,000, ESR 62, CRP 38, Albumin 3.0, Cr 0.8, ALT 28, fecal calprotectin 580 (high)
Stool culture, C. difficile toxin, parasites: negative
Colonoscopy: continuous inflammation from rectum to splenic flexure with loss of vascular pattern, friable mucosa, superficial ulcers, no skip lesion, no perianal disease; biopsy = chronic active colitis with crypt abscess, basal plasmacytosis, no granuloma
Surface area involved: 35-40% (left-sided colitis)
Mayo score: 8 (moderate-severe activity)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 60 ปี underlying HIT, dyslipidemia มา ED ด้วยอาการแขนขวา + ใบหน้าด้านขวาอ่อนแรง พูดไม่ชัด (slurred speech, expressive aphasia) onset 90 นาทีก่อน

V/S: BP 168/92, HR 86 sinus, RR 18, SpO2 98%, Glucose 142
NIHSS: 12 (moderate)
Neuro: right hemiparesis 3/5 arm > leg, right facial droop, expressive aphasia (Broca), no neglect, gaze conjugate

CT brain non-contrast: no hemorrhage, no early ischemic change ASPECTS 9
CTA: left M2 MCA occlusion + LICA 50% stenosis, no large vessel proximal
CT perfusion: penumbra > core (mismatch 60%)
ไม่มี contraindication ต่อ thrombolytic (no recent surgery, no recent stroke, no anticoagulant, no GIB)', '[{"label":"A","text":"Antiplatelet ASA 325 mg + admit observation"},{"label":"B","text":"Acute ischemic stroke within window — IV alteplase 0.9 mg/kg (10% bolus, 90% over 1 hr) ภายใน 4.5 ชม. onset (max 90 mg) + BP control < 185/110 ก่อน tPA, < 180/105 หลัง × 24 hr + permissive hypertension if no tPA + assess for endovascular thrombectomy (M2 occlusion: select cases per AURORA, with mismatch + favorable ASPECTS); NIHSS ≥ 6 + LVO + < 24 hr → EVT consideration (DAWN/DEFUSE-3 extended window); admit stroke unit; start dual antiplatelet (ASA + clopidogrel × 21 d in minor stroke/TIA — CHANCE/POINT)"},{"label":"C","text":"Aggressive BP reduction to 120/80 ทันที"},{"label":"D","text":"Heparin infusion full-dose for stroke"},{"label":"E","text":"Statin + observe without acute reperfusion"}]'::jsonb,
  'B', 'Acute ischemic stroke within thrombolytic window. AHA/ASA 2019 + updated 2023 stroke guideline: (1) IV alteplase 0.9 mg/kg (max 90 mg) within 4.5 hr onset; tenecteplase 0.25 mg/kg single bolus emerging alternative (AcT, EXTEND-IA TNK). (2) BP target: < 185/110 before tPA (labetalol, nicardipine); < 180/105 × 24 hr after; permissive hypertension (< 220/120) if no tPA. (3) Endovascular thrombectomy (EVT): - 0-6 hr: NIHSS ≥ 6, LVO (ICA, M1) — Class I (HERMES). - 6-24 hr: select with clinical-imaging mismatch (DAWN: NIHSS-core mismatch; DEFUSE-3: perfusion mismatch). - M2: select cases (AURORA pooled data). (4) Glucose control 140-180. (5) Avoid acute BP lowering (worsens penumbra); permissive HTN if no reperfusion. (6) Anticoagulation: not for acute stroke; for AF after stabilization (timing per stroke size — 1-2-3-4 day rule for small to large infarcts). (7) Antiplatelet: ASA within 24 hr (after 24 hr if tPA); DAPT × 21 d in minor stroke/high-risk TIA (CHANCE, POINT). A ผิด — within window = thrombolytic. C ผิด — aggressive BP ↓ worsens stroke. D ผิด — heparin not for acute stroke. E ผิด — misses reperfusion opportunity.', NULL,
  'hard', 'neurology', 'review',
  'internal_medicine', 'clinical_decision', 'neurology', 'adult',
  'AHA/ASA 2019 Guidelines for the Early Management of Patients with Acute Ischemic Stroke; 2023 Focused Update; DAWN NEJM 2018; DEFUSE-3 NEJM 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 60 ปี underlying HIT, dyslipidemia มา ED ด้วยอาการแขนขวา + ใบหน้าด้านขวาอ่อนแรง พูดไม่ชัด (slurred speech, expressive aphasia) onset 90 นาทีก่อน

V/S: BP 168/92, HR 86 sinus, RR 18, SpO2 98%, Glucose 142
NIHSS: 12 (moderate)
Neuro: right hemiparesis 3/5 arm > leg, right facial droop, expressive aphasia (Broca), no neglect, gaze conjugate

CT brain non-contrast: no hemorrhage, no early ischemic change ASPECTS 9
CTA: left M2 MCA occlusion + LICA 50% stenosis, no large vessel proximal
CT perfusion: penumbra > core (mismatch 60%)
ไม่มี contraindication ต่อ thrombolytic (no recent surgery, no recent stroke, no anticoagulant, no GIB)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 70 ปี underlying HT มา ED ด้วยปวดศีรษะรุนแรงทันที ("worst headache ever") + อาเจียน + คอแข็ง + GCS ลดลงเป็น 13 (E3V4M6) onset 1 ชม.

V/S: BP 192/108, HR 76, RR 16, SpO2 98%, Temp 37.0°C
Neuro: no focal motor deficit, photophobia, neck stiffness +, no papilledema, pupil equal

CT brain non-contrast: subarachnoid blood ใน basal cisterns + bilateral sylvian fissures (Fisher 3, modified Fisher 4)
CTA: 7 mm anterior communicating artery aneurysm
Hunt-Hess grade II, WFNS grade II', '[{"label":"A","text":"Antihypertensive aggressive ลด BP ให้ normal + delayed clipping ใน 2 สัปดาห์"},{"label":"B","text":"Aneurysmal subarachnoid hemorrhage — ICU admission + BP target SBP < 160 (labetalol/nicardipine) + early aneurysm securing (endovascular coiling preferred over clipping per ISAT) within 24-72 hr + Nimodipine 60 mg PO/NG q4h × 21 d (reduces delayed cerebral ischemia) + maintain euvolemia (avoid prophylactic hypervolemia) + glucose 140-180 + seizure prophylaxis short course + monitor for: rebleeding (peak day 1), hydrocephalus (ext ventricular drain ถ้า), delayed cerebral ischemia (DCI day 4-14 — TCD + clinical), hyponatremia (CSW/SIADH)"},{"label":"C","text":"Lumbar puncture ก่อน CT angiography เพื่อ confirm"},{"label":"D","text":"Heparin anticoagulation prevent secondary thrombosis"},{"label":"E","text":"Mannitol IV ทันทีและพิจารณา hemicraniectomy"}]'::jsonb,
  'B', 'Aneurysmal subarachnoid hemorrhage (aSAH) — "thunderclap headache" + meningismus + Fisher 3 + AcoA aneurysm. AHA/ASA + Neurocritical Care SAH guideline 2023: (1) BP control: target SBP < 160 (some < 140) until aneurysm secured to prevent rebleed; nicardipine/labetalol/clevidipine. (2) Early aneurysm treatment: < 24-72 hr by coiling (endovascular) — superior to clipping in most (ISAT trial — better outcome, less death/dependency at 1 yr); clipping for complex anatomy. (3) Nimodipine 60 mg q4h × 21 d — reduces poor outcomes (mechanism: neuroprotective, doesn''t prevent vasospasm angiographically). (4) Volume management: euvolemia (CVP-guided NSS); avoid prophylactic hypervolemia (no benefit + harms). (5) DCI monitoring: TCD daily, clinical exam; treat with permissive hypertension ("Triple H" outdated — just induced hypertension), endovascular angioplasty/intra-arterial vasodilators. (6) Hydrocephalus: EVD; chronic VP shunt 20%. (7) Seizure prophylaxis: short course (3-7 d) if no seizure; longer if hemorrhage extends into parenchyma. (8) Hyponatremia: CSW (volume-depleted) vs SIADH (euvolemic) — common; treat with NSS + fludrocortisone if CSW. A ผิด — early securing essential. C ผิด — CT positive = no LP. D ผิด — anticoagulation worsens. E ผิด — mannitol/decompressive for ICH not SAH alone.', NULL,
  'hard', 'neurology', 'review',
  'internal_medicine', 'clinical_decision', 'neurology', 'adult',
  'AHA/ASA Guidelines for Management of Aneurysmal SAH 2023; Neurocritical Care Society SAH Guidelines 2011 (update 2023); ISAT Trial Lancet 2002', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 70 ปี underlying HT มา ED ด้วยปวดศีรษะรุนแรงทันที ("worst headache ever") + อาเจียน + คอแข็ง + GCS ลดลงเป็น 13 (E3V4M6) onset 1 ชม.

V/S: BP 192/108, HR 76, RR 16, SpO2 98%, Temp 37.0°C
Neuro: no focal motor deficit, photophobia, neck stiffness +, no papilledema, pupil equal

CT brain non-contrast: subarachnoid blood ใน basal cisterns + bilateral sylvian fissures (Fisher 3, modified Fisher 4)
CTA: 7 mm anterior communicating artery aneurysm
Hunt-Hess grade II, WFNS grade II'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 26 ปี ไม่มีโรคประจำตัว ตื่นมาพบแขนซ้ายอ่อนแรง + พูดไม่ชัด เริ่มแบบกระตุก หมุนหน้าไปทางขวา → generalized tonic-clonic 90 วินาที → postictal confusion 20 นาที ไม่มี FH seizure, ไม่ใช้สารเสพติด ไม่มี head trauma

V/S: BP 132/82, HR 92 sinus, RR 18, SpO2 98%, Temp 36.9°C
Neuro: post-ictal drowsy GCS 14, no focal residual, no neck stiffness, tongue bite +

Lab: Na 138, K 4.0, Glucose 102, Ca 9.4, Mg 2.0, Cr 0.9, CBC normal, prolactin elevated 60 (suggests true seizure not PNES), Tox screen negative
CT brain: normal
MRI brain: small focal cortical malformation right frontal
EEG: interictal right frontal sharp waves', '[{"label":"A","text":"No further workup — single seizure, no treatment needed"},{"label":"B","text":"Provoked seizure — correct trigger and discharge home"},{"label":"C","text":"First focal-to-bilateral tonic-clonic seizure with identified epileptogenic lesion (cortical malformation) + epileptiform EEG = epilepsy by ILAE 2014 definition (recurrence risk > 60%) — start anti-seizure medication (levetiracetam 500 mg BID up-titrate, OR lamotrigine slow titration, OR lacosamide); driving restriction per local regulation (Thailand: 6-12 เดือน seizure-free); seizure precautions counseling; pregnancy planning if female (avoid valproate); refer epilepsy clinic + neurosurgery consideration if drug-resistant for resective surgery"},{"label":"D","text":"Lifelong phenytoin monotherapy"},{"label":"E","text":"EEG-guided ketogenic diet"}]'::jsonb,
  'C', 'First-onset focal-to-bilateral tonic-clonic seizure. ILAE 2014 operational definition of epilepsy: (a) ≥ 2 unprovoked seizures > 24 hr apart, OR (b) 1 unprovoked seizure + ≥ 60% recurrence risk over 10 yr, OR (c) epilepsy syndrome. Our patient = (b) — structural lesion + epileptiform EEG → high recurrence → epilepsy → treat. (1) ASM choice: - Focal: levetiracetam, lamotrigine, lacosamide, carbamazepine (CBZ avoided in HLA-B*1502 + Asian = SJS), oxcarbazepine. - Generalized: valproate (most effective but teratogenic), lamotrigine, levetiracetam. - Pregnancy: lamotrigine, levetiracetam preferred; avoid valproate (NTD, autism, IQ↓). (2) Single seizure without high recurrence risk: discuss observation vs ASM (MESS trial — delay reasonable). (3) Driving: country-specific seizure-free period (US 3-12 mo; Thailand typically 6-12 mo). (4) Counseling: bathing/showering (vs bath = drowning risk), heights, swimming alone, ladders, no alcohol-driven sleep deprivation. (5) Drug-resistant epilepsy: failure of 2 adequately tried ASM → evaluate for resective surgery (lesionectomy in focal cortical dysplasia), VNS, RNS, ketogenic diet. (6) Levels & adherence; counsel SUDEP. A ผิด — risk ของ recurrence high. B ผิด — no provoking factor identified. D ผิด — phenytoin not first-line (cosmetic + cognitive). E ผิด — diet for refractory.', NULL,
  'medium', 'neurology', 'review',
  'internal_medicine', 'clinical_decision', 'neurology', 'adult',
  'ILAE Operational Definition of Epilepsy 2014; AAN Practice Guideline: Management of an Unprovoked First Seizure 2015; ILAE Treatment Guidelines 2023', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 26 ปี ไม่มีโรคประจำตัว ตื่นมาพบแขนซ้ายอ่อนแรง + พูดไม่ชัด เริ่มแบบกระตุก หมุนหน้าไปทางขวา → generalized tonic-clonic 90 วินาที → postictal confusion 20 นาที ไม่มี FH seizure, ไม่ใช้สารเสพติด ไม่มี head trauma

V/S: BP 132/82, HR 92 sinus, RR 18, SpO2 98%, Temp 36.9°C
Neuro: post-ictal drowsy GCS 14, no focal residual, no neck stiffness, tongue bite +

Lab: Na 138, K 4.0, Glucose 102, Ca 9.4, Mg 2.0, Cr 0.9, CBC normal, prolactin elevated 60 (suggests true seizure not PNES), Tox screen negative
CT brain: normal
MRI brain: small focal cortical malformation right frontal
EEG: interictal right frontal sharp waves'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 32 ปี ไม่มีโรคประจำตัว มาด้วยอาการอ่อนเพลีย ใจสั่น น้ำหนักลด 6 kg ใน 2 เดือน เหงื่อออกง่าย ทนร้อนไม่ได้ ประจำเดือนน้อยลง ตาโปนเล็กน้อย

V/S: BP 142/74, HR 118 (irregular AF), RR 18, Temp 37.2°C
PE: warm moist skin, fine tremor, diffuse goiter with bruit, lid lag, proptosis bilateral, no pretibial myxedema

Lab: TSH < 0.01, Free T4 4.8 (high), Free T3 18 (high), TRAb (TSH-receptor antibody) positive at 14 IU/L, anti-TPO positive
CBC normal, LFT normal, Cr 0.7
Thyroid US: diffuse hypervascular goiter, no nodule
Thyroid uptake (RAIU) 65% (high), homogeneous', '[{"label":"A","text":"Iodine therapy alone"},{"label":"B","text":"Graves disease with AF — Initiate antithyroid drug methimazole 20-40 mg/d (carbimazole equivalent; PTU only in 1st trimester pregnancy or thyroid storm due to hepatotoxicity) + beta-blocker (propranolol 40 mg q6h หรือ atenolol) symptom control + AF management (rate control + anticoagulation per CHA2DS2-VASc; AF often reverts when euthyroid); definitive options after MMI 12-18 mo (radioactive iodine I-131 preferred in non-pregnant; thyroidectomy if compressive/ophthalmopathy concern/pregnancy contraindication) + monitor LFT, CBC (agranulocytosis warning), TFT q4-6 wk; ophthalmology referral if moderate-severe orbitopathy (high-dose IV methylprednisolone, teprotumumab)"},{"label":"C","text":"Levothyroxine to suppress thyroid function"},{"label":"D","text":"Surgery (total thyroidectomy) เป็น first-line"},{"label":"E","text":"Steroid IV ทันทีโดยไม่ให้ antithyroid"}]'::jsonb,
  'B', 'Graves disease — diffuse goiter + Graves ophthalmopathy + TRAb positive + diffuse high RAIU + thyrotoxicosis + AF complication. ATA 2016 + Endocrine Society guideline: (1) Three definitive options — discuss with patient: (a) Antithyroid drug (ATD): methimazole 5-40 mg/d (preferred over PTU due to hepatotoxicity risk; PTU only 1st trimester pregnancy and thyroid storm). Duration 12-18 mo; remission 30-50%. (b) Radioactive iodine (I-131): definitive, hypothyroidism likely (need lifelong LT4); contraindicated in pregnancy/breastfeeding; relative contraindication in moderate-severe Graves orbitopathy (can worsen — steroid prophylaxis if mild GO). (c) Thyroidectomy: rapid control, large goiter, suspected malignancy, severe GO. (2) Beta-blocker for symptoms (propranolol blocks T4→T3 conversion). (3) AF in thyrotoxicosis: rate control + anticoagulation; reversion 60-70% within 4 mo of euthyroidism. (4) Monitor ATD: LFT, CBC; agranulocytosis (rare 0.2%) — stop if fever/sore throat; cholestatic hepatitis (MMI). (5) Graves orbitopathy: smoking cessation (huge), selenium for mild, IV methylprednisolone for active moderate-severe, teprotumumab (IGF-1R Ab — FDA 2020). (6) Thyroid storm: ICU + PTU + iodine 1 hr after PTU + steroid + BB + cooling + supportive. A ผิด — iodine + ATD combo for prep, alone causes worsening. C ผิด — LT4 = hypothyroid Rx not Graves. D ผิด — surgery not 1st-line. E ผิด — steroid for GO/storm not initial mgmt.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'internal_medicine', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'American Thyroid Association Guidelines for Diagnosis and Management of Hyperthyroidism 2016; Endocrine Society Clinical Practice Guideline; ATA/AACE Hyperthyroidism Management 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 32 ปี ไม่มีโรคประจำตัว มาด้วยอาการอ่อนเพลีย ใจสั่น น้ำหนักลด 6 kg ใน 2 เดือน เหงื่อออกง่าย ทนร้อนไม่ได้ ประจำเดือนน้อยลง ตาโปนเล็กน้อย

V/S: BP 142/74, HR 118 (irregular AF), RR 18, Temp 37.2°C
PE: warm moist skin, fine tremor, diffuse goiter with bruit, lid lag, proptosis bilateral, no pretibial myxedema

Lab: TSH < 0.01, Free T4 4.8 (high), Free T3 18 (high), TRAb (TSH-receptor antibody) positive at 14 IU/L, anti-TPO positive
CBC normal, LFT normal, Cr 0.7
Thyroid US: diffuse hypervascular goiter, no nodule
Thyroid uptake (RAIU) 65% (high), homogeneous'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 24 ปี underlying T1DM × 12 ปี on insulin glargine + lispro, history poor adherence ขาด insulin glargine 3 วัน + URI 4 วัน มา ED ด้วยปวดท้อง คลื่นไส้ อาเจียน หายใจเร็ว + ลึก สับสน

V/S: BP 96/62, HR 124, RR 32 Kussmaul, SpO2 98%, Temp 37.4°C
Gen: dry mucous membrane, fruity breath, lethargic GCS 13

Lab: Glucose 542 mg/dL, Na 132 (corrected 138), K 4.8, Cl 96, HCO3 9, Anion gap 27 (high), BUN 36, Cr 1.4 (baseline 0.7), Ketones (beta-hydroxybutyrate) 6.8 mmol/L, pH 7.12, PaCO2 16, pH 7.12
Urinalysis: ketones 4+, glucose 4+
Lactate 1.8, Mg 1.6, Phosphate 2.0
EKG: peaked T waves mild', '[{"label":"A","text":"IV NaHCO3 ทันทีเพื่อ correct acidosis"},{"label":"B","text":"Diabetic ketoacidosis (severe) — IV fluid 1-1.5 L NSS bolus then 250-500 mL/hr (switch to ½NS when Na ≥ 135 corrected); IV regular insulin 0.1 U/kg/hr infusion (NO bolus — recent ADA guidance) — check K BEFORE insulin (if K < 3.3 → hold insulin, give K first), add dextrose when glucose < 250 (continue insulin to clear ketones); replace K (target 4-5 mEq/L); identify trigger (infection, missed insulin); transition to SC basal-bolus when AG closed + bicarb > 18 + tolerating PO (overlap 2 hr); avoid bicarbonate routinely (only if pH < 6.9)"},{"label":"C","text":"High-dose insulin IV bolus 10 U + start drip"},{"label":"D","text":"Stop all insulin until glucose normalizes"},{"label":"E","text":"D5W IV main fluid replacement"}]'::jsonb,
  'B', 'Severe DKA — pH < 7.0 (or HCO3 < 10 + AG > 12 + ketones positive + hyperglycemia). ADA 2024 + JBDS DKA guideline: (1) Fluid first — typically dehydrated 5-7 L deficit; NSS 1-1.5 L/hr × 1-2 hr then 250-500 mL/hr; switch to 0.45% NS when serum Na corrected ≥ 135. (2) Insulin infusion 0.1 U/kg/hr; NO bolus per recent ADA recommendation (no benefit, increased hypoglycemia/hypokalemia). (3) Pre-insulin K check: < 3.3 → hold insulin + K replacement; 3.3-5.3 → add K 20-30 mEq/L IVF; > 5.3 → no K, recheck. (4) Add D5/D10 when glucose < 200-250 — to allow continued insulin clearing ketones without hypoglycemia. (5) Bicarbonate: only pH < 6.9 (controversial — may worsen intracellular acidosis, cerebral edema). (6) Phosphate: replace if < 1.0 or symptomatic. (7) Identify precipitant: I''s — infection, infarction (MI), insulin omission, intoxication, infant (pregnancy), iatrogenic. (8) Transition: AG closed + HCO3 > 18 + tolerating PO → SC basal-bolus with 1-2 hr IV overlap before stopping drip. (9) Cerebral edema (rare adults, more peds): too rapid fluid/Na correction. A ผิด — bicarbonate not routine. C ผิด — bolus not recommended. D ผิด — insulin needed to clear ketones. E ผิด — D5W alone wrong; need NSS for volume.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'internal_medicine', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'ADA Standards of Care 2024 — Hyperglycemic Crises; ADA Consensus Report on Hyperglycemic Crises 2024; JBDS DKA Guideline 2023', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 24 ปี underlying T1DM × 12 ปี on insulin glargine + lispro, history poor adherence ขาด insulin glargine 3 วัน + URI 4 วัน มา ED ด้วยปวดท้อง คลื่นไส้ อาเจียน หายใจเร็ว + ลึก สับสน

V/S: BP 96/62, HR 124, RR 32 Kussmaul, SpO2 98%, Temp 37.4°C
Gen: dry mucous membrane, fruity breath, lethargic GCS 13

Lab: Glucose 542 mg/dL, Na 132 (corrected 138), K 4.8, Cl 96, HCO3 9, Anion gap 27 (high), BUN 36, Cr 1.4 (baseline 0.7), Ketones (beta-hydroxybutyrate) 6.8 mmol/L, pH 7.12, PaCO2 16, pH 7.12
Urinalysis: ketones 4+, glucose 4+
Lactate 1.8, Mg 1.6, Phosphate 2.0
EKG: peaked T waves mild'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 58 ปี underlying chronic asthma on prednisolone 10 mg/d × 2 ปี (ผู้ป่วยพยายามหยุดยาเอง 1 สัปดาห์ก่อน) มา ED ด้วยอ่อนเพลียมาก คลื่นไส้ อาเจียน ปวดท้อง วิงเวียน + เป็นลม

V/S: BP 78/48 (orthostatic +), HR 124, RR 22, SpO2 96%, Temp 38.4°C, Glucose 58 mg/dL
PE: lethargic, dry mucous membrane, abdomen soft mild diffuse tender, no peritonitis, hyperpigmentation NOT present (secondary AI from chronic steroid)

Lab: Na 126, K 5.4, Cl 92, HCO3 18, BUN 38, Cr 1.6, Glucose 58, Ca 9.6
Cortisol 8 AM = 2.4 mcg/dL (low), ACTH undetectable (suggesting secondary)
WBC 11,200 with eosinophilia 8%', '[{"label":"A","text":"Oral hydrocortisone 20 mg + discharge with prednisolone refill"},{"label":"B","text":"Adrenal crisis (secondary AI from chronic exogenous glucocorticoid + abrupt withdrawal + concurrent stress/infection) — Immediate IV hydrocortisone 100 mg bolus then 50 mg q6h (or continuous 200 mg/24h) + IV NSS 1-2 L bolus + D5/D50 for hypoglycemia + identify and treat trigger (suspect infection — cultures + empirical antibiotic) + correct electrolytes + DO NOT delay steroids for ACTH stimulation test in crisis; transition to oral hydrocortisone 15-25 mg/d divided when stable + sick-day rules education + MedAlert; mineralocorticoid replacement (fludrocortisone) NOT needed in secondary AI (intact aldosterone)"},{"label":"C","text":"Fludrocortisone alone"},{"label":"D","text":"Defer steroid until ACTH stim test result"},{"label":"E","text":"IV dexamethasone alone (no mineralocorticoid activity)"}]'::jsonb,
  'B', 'Adrenal crisis — life-threatening due to glucocorticoid deficiency + stress trigger. Endocrine Society 2016 + recent Bornstein guidelines: (1) Diagnosis: hypotension + hypoglycemia + hyponatremia ± hyperkalemia + nonspecific symptoms; cortisol < 5 inappropriate during stress. ACTH: high in primary AI (Addison), low in secondary (pituitary/exogenous steroid suppression). Hyperpigmentation only in primary (high ACTH/MSH). (2) Treatment in crisis — DON''T DELAY for testing: - IV hydrocortisone 100 mg bolus then 50 mg q6h or 200 mg/24h infusion (provides both gluco + some mineralocorticoid effect at high dose). - IV fluid NSS 1-2 L over 1 hr; D5 if hypoglycemia. - Treat precipitant (infection most common). - Correct K, glucose. (3) Stress dose for known AI: triple oral dose for minor illness; IV hydrocortisone for major stress/surgery. (4) Iatrogenic 2° AI from chronic steroid > 3 wk of > 5 mg prednisolone — taper gradually, education. (5) ACTH stimulation (cosyntropin 250 mcg, cortisol at 30/60 min) deferred to non-crisis. (6) Patient education + MedAlert + glucagon/dex IM rescue kit. A ผิด — crisis = IV not oral. C ผิด — fludrocortisone alone misses GC. D ผิด — never delay treatment. E ผิด — dexamethasone OK in acute (no false ACTH interference) but lacks mineralocorticoid activity needed; hydrocortisone preferred in crisis.', NULL,
  'hard', 'endocrine_metabolic', 'review',
  'internal_medicine', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'Endocrine Society Clinical Practice Guideline: Diagnosis and Treatment of Primary AI 2016; Bornstein SR et al. JCEM 2016 (Adrenal Insufficiency)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 58 ปี underlying chronic asthma on prednisolone 10 mg/d × 2 ปี (ผู้ป่วยพยายามหยุดยาเอง 1 สัปดาห์ก่อน) มา ED ด้วยอ่อนเพลียมาก คลื่นไส้ อาเจียน ปวดท้อง วิงเวียน + เป็นลม

V/S: BP 78/48 (orthostatic +), HR 124, RR 22, SpO2 96%, Temp 38.4°C, Glucose 58 mg/dL
PE: lethargic, dry mucous membrane, abdomen soft mild diffuse tender, no peritonitis, hyperpigmentation NOT present (secondary AI from chronic steroid)

Lab: Na 126, K 5.4, Cl 92, HCO3 18, BUN 38, Cr 1.6, Glucose 58, Ca 9.6
Cortisol 8 AM = 2.4 mcg/dL (low), ACTH undetectable (suggesting secondary)
WBC 11,200 with eosinophilia 8%'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 65 ปี underlying CKD stage 4 (eGFR 22), DM, HT มา ED ด้วยอ่อนแรง ใจสั่น + EKG พบ peaked T waves + wide QRS

V/S: BP 138/82, HR 64, RR 18, SpO2 97%
PE: 2+ pedal edema, lung clear
Lab: K 7.6 mEq/L (acute), Na 138, Cl 102, HCO3 18, Cr 4.8 (baseline 3.5), Glucose 124, Ca 9.0, Mg 2.0
ABG: pH 7.30
EKG: peaked T waves V2-V5, PR interval prolonged, QRS 130 ms (widened), no sine wave yet
Recent: เพิ่ม lisinopril + spironolactone 4 วันก่อนเพราะ BP control', '[{"label":"A","text":"Stop only ACEi + oral kayexalate + observe"},{"label":"B","text":"Severe symptomatic hyperkalemia with EKG changes — Step 1: IV calcium gluconate 10% 10 mL over 2-3 min (membrane stabilization, onset 1-3 min, lasts 30-60 min — repeat if EKG persists); Step 2 shift K intracellular: IV insulin 10 U + D50 50 mL + IV salbutamol nebulized 10-20 mg + IV NaHCO3 if acidemia; Step 3 remove K: IV furosemide (if making urine) + new K-binders (patiromer or sodium zirconium cyclosilicate — onset hours; preferred over kayexalate due to colonic necrosis risk); urgent hemodialysis if refractory, severe, anuric, or ESRD; STOP ACEi + spironolactone; cardiac monitor"},{"label":"C","text":"IV NaHCO3 alone"},{"label":"D","text":"Oral resin alone for rapid effect"},{"label":"E","text":"Defer dialysis until K > 8"}]'::jsonb,
  'B', 'Severe hyperkalemia (K > 6.5 with EKG changes = emergency). KDIGO 2022 + UK Renal Association + ERA-EDTA guideline: (1) Stabilize myocardium: IV calcium gluconate 10% 10 mL (or CaCl 10% 5-10 mL via central) — onset minutes, duration 30-60 min, repeat if EKG persists. No K-lowering effect — just antagonizes membrane effect. (2) Shift K intracellular (temporary 1-6 hr): - Insulin 10 U IV + D50 50 mL (or D10 infusion if not fasting) — lowers 0.5-1.2 mEq/L. - Beta-2 agonist (nebulized salbutamol 10-20 mg) — lowers 0.5-1 mEq/L; synergistic with insulin. - NaHCO3 if acidemia (HCO3 < 22) — modest effect; not for routine. (3) Remove K (definitive): - Loop diuretic (furosemide) if making urine. - K-binders: patiromer (Veltassa), sodium zirconium cyclosilicate (Lokelma) — onset hours, suitable for chronic. - Sodium polystyrene sulfonate (Kayexalate) — slower, risk colonic necrosis (esp with sorbitol); falling out of favor. - Hemodialysis: refractory hyperkalemia, ESRD, oligo/anuric, severe/symptomatic. (4) Address cause: stop K-elevating drugs (ACEi, ARB, MRA, NSAIDs, TMP-SMX); dietary advice; correct acidosis. A ผิด — incomplete + slow. C ผิด — bicarb alone insufficient. D ผิด — resin onset too slow for emergency. E ผิด — K 7.6 + EKG = act now.', NULL,
  'medium', 'renal_gu', 'review',
  'internal_medicine', 'clinical_decision', 'renal_gu', 'adult',
  'KDIGO Conference Report on Potassium Management 2020; UK Renal Association Hyperkalaemia Guideline 2020; ERA-EDTA Guidance', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 65 ปี underlying CKD stage 4 (eGFR 22), DM, HT มา ED ด้วยอ่อนแรง ใจสั่น + EKG พบ peaked T waves + wide QRS

V/S: BP 138/82, HR 64, RR 18, SpO2 97%
PE: 2+ pedal edema, lung clear
Lab: K 7.6 mEq/L (acute), Na 138, Cl 102, HCO3 18, Cr 4.8 (baseline 3.5), Glucose 124, Ca 9.0, Mg 2.0
ABG: pH 7.30
EKG: peaked T waves V2-V5, PR interval prolonged, QRS 130 ms (widened), no sine wave yet
Recent: เพิ่ม lisinopril + spironolactone 4 วันก่อนเพราะ BP control'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 78 ปี admit ใน hospital × 5 วัน with pneumonia ตอนนี้ไข้ลดลง + ดีขึ้น แต่ ICU notes ระบุว่า Na ลดลงจาก 138 → 122 ใน 5 วันโดยที่ไม่มีอาการชัดเจน

V/S: BP 124/76, HR 78, euvolemic on exam (no edema, no orthostasis, no dry mucous membrane), Temp 37.4°C
Urine output 1.2 L/d
Lab: Na 122, K 4.0, Cl 88, HCO3 22, BUN 12, Cr 0.7, Glucose 102, Albumin 3.4, TSH 1.8, Cortisol 18
Urine Na 78 (high), Urine osm 480 (inappropriately concentrated relative to serum 252)
Uric acid 2.6 (low)
ผู้ป่วยรับยา: ceftriaxone, azithromycin (for pneumonia), oxycodone PRN pain, sertraline (chronic), HCTZ (chronic)', '[{"label":"A","text":"3% hypertonic saline aggressive bolus เพื่อ correct rapidly to 138"},{"label":"B","text":"Euvolemic hyponatremia consistent with SIADH (euvolemic + urine Na > 30 + urine osm > 100 + low BUN/uric acid; normal thyroid/cortisol/renal) — possibly drug-induced (SSRI sertraline very common cause; also rule out pulmonary disease itself) — Management: (1) Asymptomatic chronic (> 48 hr) — fluid restriction 800-1000 mL/d as first-line; (2) Treat underlying — stop sertraline if feasible, HCTZ; (3) If inadequate response → salt tabs + furosemide, urea, vaptan (tolvaptan) for refractory; (4) Severe symptomatic (seizure, coma) → 3% saline 100 mL bolus × up to 3; correction rate limit 6-8 mEq/L per 24 hr to avoid osmotic demyelination (especially when chronic + risk factors like alcoholism, malnutrition, hypokalemia)"},{"label":"C","text":"Demeclocycline ทันทีเป็น first-line"},{"label":"D","text":"Free water IV กลับมาทันที"},{"label":"E","text":"ไม่ต้องทำอะไร — Na 122 asymptomatic ปลอดภัย"}]'::jsonb,
  'B', 'SIADH — euvolemic hyponatremia with inappropriately concentrated urine despite serum hypotonicity. Diagnostic criteria (Bartter-Schwartz): hyponatremia, plasma osm < 275, urine osm > 100, urine Na > 30, euvolemia, normal thyroid/adrenal/renal, no diuretic use (HCTZ here is confounder — hypovolemic hyponatremia). European hyponatremia guideline 2014 + Verbalis NEJM 2013: (1) Severity: severe (Na < 125 or symptomatic seizure/coma) → 3% saline 100-150 mL bolus, repeat to ↑ Na 4-6 mEq/L. (2) Correction rate cap: < 8-10 mEq/L per 24 hr (some recommend 6); especially careful in chronic + risk factors → osmotic demyelination syndrome ("locked-in" 1-7 d after over-correction). (3) Asymptomatic/mild chronic SIADH: fluid restriction first; if inadequate add salt + furosemide, urea (effective + safe), vasopressin receptor antagonists (vaptans — tolvaptan, conivaptan). (4) Common SIADH causes: drugs (SSRI, carbamazepine, oxytocin, chemotherapy), CNS (stroke, hemorrhage, trauma, infection), pulmonary (pneumonia, TB, lung cancer SCLC paraneoplastic), nausea/pain/post-op. (5) Re-lowering with desmopressin if over-corrected. A ผิด — too rapid correction = ODS. C ผิด — demeclocycline obsolete (toxicity). D ผิด — worsens. E ผิด — Na 122 needs intervention.', NULL,
  'medium', 'renal_gu', 'review',
  'internal_medicine', 'clinical_decision', 'renal_gu', 'adult',
  'European Clinical Practice Guideline on Diagnosis and Treatment of Hyponatraemia 2014; Verbalis JG et al. Am J Med 2013; Adrogué HJ NEJM 2000', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 78 ปี admit ใน hospital × 5 วัน with pneumonia ตอนนี้ไข้ลดลง + ดีขึ้น แต่ ICU notes ระบุว่า Na ลดลงจาก 138 → 122 ใน 5 วันโดยที่ไม่มีอาการชัดเจน

V/S: BP 124/76, HR 78, euvolemic on exam (no edema, no orthostasis, no dry mucous membrane), Temp 37.4°C
Urine output 1.2 L/d
Lab: Na 122, K 4.0, Cl 88, HCO3 22, BUN 12, Cr 0.7, Glucose 102, Albumin 3.4, TSH 1.8, Cortisol 18
Urine Na 78 (high), Urine osm 480 (inappropriately concentrated relative to serum 252)
Uric acid 2.6 (low)
ผู้ป่วยรับยา: ceftriaxone, azithromycin (for pneumonia), oxycodone PRN pain, sertraline (chronic), HCTZ (chronic)'
  );

commit;

-- verify partial progress
select board_section, count(*) from public.mcq_questions
where board_specialty = 'internal_medicine' and exam_source = 'AI-generated-board-seed'
group by 1 order by 1;
