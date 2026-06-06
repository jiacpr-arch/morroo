-- ===============================================================
-- หมอรู้ — Board seed: อายุรศาสตร์ (internal_medicine) — part 2/4 (50 MCQs)
-- Safe to paste into Supabase SQL Editor. Re-runnable.
-- ===============================================================

begin;

-- mcq_subjects for this specialty (idempotent)
insert into public.mcq_subjects
  (name, name_th, icon, audience, board_specialty, exam_type, question_count)
values
  ('im_clinical_decision', 'อายุรศาสตร์ · การตัดสินใจทางเวชกรรม', '🩺', 'board', 'internal_medicine', NULL, 0),
  ('im_basic_science', 'อายุรศาสตร์ · วิทยาศาสตร์การแพทย์พื้นฐาน', '🧬', 'board', 'internal_medicine', NULL, 0),
  ('im_ems_mgmt', 'อายุรศาสตร์ · การจัดการระบบบริการการแพทย์ฉุกเฉิน', '🚨', 'board', 'internal_medicine', NULL, 0),
  ('im_integrative', 'อายุรศาสตร์ · ข้อสอบบูรณาการ', '🧩', 'board', 'internal_medicine', NULL, 0)
on conflict (name) do nothing;

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 45 ปี HIV positive on ART × 8 ปี, CD4 ปัจจุบัน 580, VL undetectable มา OPD ด้วย proteinuria 4+ จาก routine UA + edema ใน 6 สัปดาห์

V/S: BP 158/96, HR 76, RR 16, SpO2 98%
PE: periorbital + lower limb 3+ pitting edema, no rash, no ascites

Lab: Cr 1.8 (baseline 1.0), Albumin 2.4, Cholesterol 348, LDL 198, Triglyceride 412
UA: protein 4+, no RBC casts, oval fat bodies
24-hr urine protein: 8.2 g/d, Urine protein/Cr 7.8 g/g
C3 normal, C4 normal, ANA negative, HCV negative, HBV: anti-HBs +, ANCA negative
Kidney biopsy: focal segmental glomerulosclerosis (FSGS) — collapsing variant, severe podocyte effacement, no immune complex deposit
APOL1 genotype: 2 risk alleles (high-risk genotype)', '[{"label":"A","text":"Continue ART + observe; no specific renal treatment needed"},{"label":"B","text":"HIV-associated nephropathy / collapsing FSGS"},{"label":"C","text":"IV cyclophosphamide pulse alone"},{"label":"D","text":"Stop ART + IV methylprednisolone pulse"},{"label":"E","text":"Plasmapheresis as first-line"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** HIV-associated nephropathy / collapsing FSGS — Treat nephrotic syndrome + glomerular disease: (1) Continue ART and ensure adherence (VL suppression slows progression); (2) ACEi or ARB for proteinuria reduction (target < 1 g/d; here lisinopril titrate, monitor K, Cr) + BP target < 130/80; (3) Statin for hyperlipidemia from nephrotic syndrome; (4) Glucocorticoid (prednisolone 1 mg/kg/d up to 80 mg) considered in adult HIV-associated FSGS though evidence less robust than primary FSGS; (5) Manage edema (loop diuretic, sodium restriction); (6) Anticoagulation if albumin < 2.0-2.5 + high-risk features (membranous more); (7) Vaccinate pneumococcal + influenza + COVID; (8) Nephrologist follow-up + monitor for ESRD progression — APOL1 high-risk increases ESRD risk; eventually consider transplant

---

HIV-associated nephropathy (HIVAN) / collapsing FSGS in West African/Black ancestry strongly linked to APOL1 G1/G2 risk variants (2 risk alleles → high risk). KDIGO 2021 + AASLD/IDSA + HIV nephropathy guidelines: (1) Definitive — ART maintained, ensure VL suppression (HIVAN incidence dramatically reduced in ART era). (2) Renin-angiotensin blockade: ACEi or ARB → proteinuria, slows progression; monitor K, Cr (allow up to 30% Cr ↑ if stable). (3) BP target < 130/80 (SPRINT-applicable). (4) Steroid: data mixed; prednisolone 60-80 mg/d × 2-6 mo considered in some collapsing FSGS, especially if no contraindication. SONAR-style: not for routine HIVAN. (5) Lipids: statin for nephrotic dyslipidemia. (6) Anticoagulation: less common in FSGS vs membranous (membranous + albumin < 2.0-2.5 = highest VTE risk). (7) Vaccinations + opportunistic infection prophylaxis per CD4. (8) APOL1: 2 risk alleles → counsel re renal disease risk, transplant donor screening, possible APOL1-targeted therapy in trials (inaxaplin). (9) ESRD: dialysis, transplant (allograft outcomes good post-ART era). A ผิด — RAS blockade essential. C ผิด — cyclophosphamide for refractory rare. D ผิด — never stop ART. E ผิด — for TTP/anti-GBM not FSGS.', NULL,
  'hard', 'renal_gu', 'review',
  'internal_medicine', 'clinical_decision', 'renal_gu', 'adult',
  'KDIGO Glomerular Disease Guideline 2021; HIVMA/IDSA Primary Care Guideline for HIV 2020; Friedman DJ + Pollak MR — APOL1 review NEJM 2014', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 45 ปี HIV positive on ART × 8 ปี, CD4 ปัจจุบัน 580, VL undetectable มา OPD ด้วย proteinuria 4+ จาก routine UA + edema ใน 6 สัปดาห์

V/S: BP 158/96, HR 76, RR 16, SpO2 98%
PE: periorbital + lower limb 3+ pitting edema, no rash, no ascites

Lab: Cr 1.8 (baseline 1.0), Albumin 2.4, Cholesterol 348, LDL 198, Triglyceride 412
UA: protein 4+, no RBC casts, oval fat bodies
24-hr urine protein: 8.2 g/d, Urine protein/Cr 7.8 g/g
C3 normal, C4 normal, ANA negative, HCV negative, HBV: anti-HBs +, ANCA negative
Kidney biopsy: focal segmental glomerulosclerosis (FSGS) — collapsing variant, severe podocyte effacement, no immune complex deposit
APOL1 genotype: 2 risk alleles (high-risk genotype)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 70 ปี admit ด้วย septic shock จาก urinary source ขณะนี้ on norepinephrine + IV meropenem ใน ICU วันที่ 4 มี acute pulmonary edema + ARDS

V/S: BP 102/64 on norepi 0.15 mcg/kg/min, HR 102, RR 26 on mechanical ventilation, P/F ratio 142, Temp 37.8°C
Lab: Hb 9.4, WBC 16,800, Plt 88,000, Cr 2.6 (baseline 1.0), Lactate 2.4 (down from 6.2)
CXR: bilateral patchy infiltrates, no clear pulmonary edema cardiogenic
Echo: LVEF 55%, no significant valve, no pericardial effusion
ABG: pH 7.34, PaO2 78 on FiO2 60% PEEP 12, PaCO2 42
VT 6 mL/kg PBW, plateau pressure 28', '[{"label":"A","text":"Increase VT to 10 mL/kg PBW + decrease PEEP"},{"label":"B","text":"Moderate ARDS (P/F 100-200)"},{"label":"C","text":"Maximize FiO2 100% + remove PEEP"},{"label":"D","text":"Routine corticosteroids high-dose for all ARDS"},{"label":"E","text":"Liberal fluid bolus 30 mL/kg q6h"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Moderate ARDS (P/F 100-200) — Continue lung-protective ventilation: VT 4-6 mL/kg predicted body weight (already optimal), plateau pressure ≤ 30, driving pressure < 15, PEEP titrated per ARDSnet table or transpulmonary pressure; permissive hypercapnia pH > 7.20; conservative fluid strategy (FACTT trial — avoid positive balance); prone positioning ≥ 16 hr/d if P/F < 150 (PROSEVA — mortality benefit); neuromuscular blockade only if severe and dyssynchrony; consider VV-ECMO if refractory (EOLIA, P/F < 80 despite optimization); no routine steroid but consider dexamethasone in moderate-severe per DEXA-ARDS; sedation light; daily SBT + SAT

---

Moderate ARDS by Berlin definition (acute < 7 d, bilateral opacities, not solely cardiac, P/F 100-200 with PEEP ≥ 5). ARDSnet/SCCM/ESICM 2023 ARDS guideline: (1) Lung-protective ventilation (ARMA trial NEJM 2000): VT 4-8 mL/kg PBW (target 6), plateau ≤ 30, driving pressure (Pplat − PEEP) < 15; permissive hypercapnia pH > 7.20. (2) PEEP titration: ARDSnet high-PEEP/FiO2 table or transpulmonary pressure / esophageal balloon. (3) Prone positioning ≥ 16 hr/d for moderate-severe (PROSEVA P/F < 150 — mortality reduction). (4) Conservative fluid strategy (FACTT) — less positive balance shortens vent days. (5) Neuromuscular blockade (cisatracurium) early if severe + dyssynchrony (ACURASYS positive; ROSE neutral in light sedation era — selective use). (6) Inhaled vasodilators (NO, epoprostenol): improve oxygenation, no mortality benefit. (7) VV-ECMO: severe refractory (P/F < 80, pH < 7.25 + PaCO2 ≥ 60); EOLIA / CESAR. (8) Steroids: dexamethasone 20 mg × 5 d then 10 mg × 5 d in moderate-severe COVID and ARDS (DEXA-ARDS by Villar — controversial but used). (9) Daily SAT + SBT; light sedation (RASS 0 to −2); early mobilization. A ผิด — high VT injurious. C ผิด — high FiO2 toxic, PEEP critical. D ผิด — routine high-dose not standard. E ผิด — fluid overload harmful.', NULL,
  'hard', 'respiratory', 'review',
  'internal_medicine', 'clinical_decision', 'respiratory', 'adult',
  'ATS/ESICM/SCCM 2023 Clinical Practice Guideline on ARDS; PROSEVA NEJM 2013; ARMA NEJM 2000; EOLIA NEJM 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 70 ปี admit ด้วย septic shock จาก urinary source ขณะนี้ on norepinephrine + IV meropenem ใน ICU วันที่ 4 มี acute pulmonary edema + ARDS

V/S: BP 102/64 on norepi 0.15 mcg/kg/min, HR 102, RR 26 on mechanical ventilation, P/F ratio 142, Temp 37.8°C
Lab: Hb 9.4, WBC 16,800, Plt 88,000, Cr 2.6 (baseline 1.0), Lactate 2.4 (down from 6.2)
CXR: bilateral patchy infiltrates, no clear pulmonary edema cardiogenic
Echo: LVEF 55%, no significant valve, no pericardial effusion
ABG: pH 7.34, PaO2 78 on FiO2 60% PEEP 12, PaCO2 42
VT 6 mL/kg PBW, plateau pressure 28'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 42 ปี IV drug user, no fixed home มา ED ด้วยไข้สูง 38.8°C × 2 สัปดาห์, อ่อนเพลีย, น้ำหนักลด 5 kg, เพิ่งสังเกตเห็นจุดดำๆ ใต้เล็บ + จุดแดงๆบนฝ่ามือ

V/S: BP 110/68, HR 102, RR 18, SpO2 96%, Temp 38.8°C
PE: harsh holosystolic murmur ที่ LLSB เพิ่มขึ้นด้วย inspiration (Carvallo sign — tricuspid), splinter hemorrhages, Janeway lesions ฝ่ามือ, Osler nodes finger pads, Roth spots in fundoscopy

Blood culture × 3 separated by ≥ 1 hr from different sites: all 3 + Staphylococcus aureus, MSSA
Transthoracic echo: tricuspid valve vegetation 1.5 cm, no LV vegetation
Transesophageal echo: confirms 1.5 cm mobile vegetation on TV, no perivalvular abscess, no perforation, normal LV function
CXR: multiple bilateral cavitary nodules consistent with septic emboli
HIV: negative', '[{"label":"A","text":"Oral cephalexin × 10 d outpatient"},{"label":"B","text":"Right-sided infective endocarditis (MSSA) in IV drug user (Modified Duke criteria"},{"label":"C","text":"Vancomycin monotherapy × 2 weeks"},{"label":"D","text":"Watchful waiting until culture sensitivity"},{"label":"E","text":"Anticoagulation IV heparin for vegetation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Right-sided infective endocarditis (MSSA) in IV drug user (Modified Duke criteria: 2 major — positive blood cultures with typical organism + echo evidence of endocardial involvement) — IV antistaphylococcal therapy 4-6 weeks: cloxacillin/oxacillin/nafcillin 2 g q4h (MSSA-specific; cefazolin alternative); vancomycin if MRSA. Consider addition of gentamicin only for short period (no longer routine due to nephrotoxicity per ESC 2023). Daily clinical + repeat BCx q48h to document clearance. Surgical indications (Class I): heart failure from valve dysfunction, persistent bacteremia/vegetation despite > 5-7 d appropriate Rx, perivalvular abscess, large vegetation > 10 mm with embolic event, certain fungal/resistant organisms, recurrent septic PE from RV vegetation. Multidisciplinary endocarditis team consult. Substance use disorder treatment (MAT). HIV/HBV/HCV screen. Source control (any IV access)

---

Right-sided infective endocarditis in IVDU. Modified Duke criteria 2023: 2 major (positive BCx with typical organism + echo evidence) = definite IE. AHA 2015/2023 + ESC 2023 IE guideline: (1) Antimicrobial therapy by organism: - MSSA right-sided: cloxacillin/oxacillin/nafcillin 12 g/d × 4-6 wk; some uncomplicated right-sided IVDU MSSA: 2-week regimen of nafcillin + gentamicin per AHA (now controversial, mostly 4 wk). - MRSA: vancomycin or daptomycin 6 mg/kg/d (some prefer daptomycin for right-sided IE). - Streptococci viridans: penicillin G or ceftriaxone ± gentamicin. - Enterococcus: ampicillin + gentamicin or ampicillin + ceftriaxone. - HACEK: ceftriaxone. - Routine gentamicin combo for staph IE no longer recommended due to nephrotoxicity (ESC 2023). (2) Surgery indications (Class I): heart failure, uncontrolled infection (persistent BCx + > 5-7 d Rx, abscess, fistula), prevent embolism (large vegetation > 10 mm with embolic event, large mobile vegetation > 10 mm). (3) Echo: TEE > TTE for sensitivity (especially prosthetic valve); repeat if change in clinical status. (4) Repeat blood cultures q48-72 hr until clearance. (5) Daily monitoring for complications. (6) Addiction treatment: link to MAT, harm reduction. (7) Vaccines: HBV (if susceptible), pneumococcal. (8) Watch for septic emboli (lung in right-sided), AKI from drug + immune complex (Bartter Type GN). A ผิด — IE = IV abx weeks. C ผิด — MSSA: beta-lactam superior to vanco. D ผิด — sensitivity already (MSSA). E ผิด — anticoagulation increases hemorrhagic risk in IE.', NULL,
  'hard', 'id', 'review',
  'internal_medicine', 'clinical_decision', 'id', 'adult',
  'AHA Scientific Statement on Infective Endocarditis 2015 (update 2023); ESC Guidelines for Management of Endocarditis 2023; Duke-ISCVID Modified Criteria 2023', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 42 ปี IV drug user, no fixed home มา ED ด้วยไข้สูง 38.8°C × 2 สัปดาห์, อ่อนเพลีย, น้ำหนักลด 5 kg, เพิ่งสังเกตเห็นจุดดำๆ ใต้เล็บ + จุดแดงๆบนฝ่ามือ

V/S: BP 110/68, HR 102, RR 18, SpO2 96%, Temp 38.8°C
PE: harsh holosystolic murmur ที่ LLSB เพิ่มขึ้นด้วย inspiration (Carvallo sign — tricuspid), splinter hemorrhages, Janeway lesions ฝ่ามือ, Osler nodes finger pads, Roth spots in fundoscopy

Blood culture × 3 separated by ≥ 1 hr from different sites: all 3 + Staphylococcus aureus, MSSA
Transthoracic echo: tricuspid valve vegetation 1.5 cm, no LV vegetation
Transesophageal echo: confirms 1.5 cm mobile vegetation on TV, no perivalvular abscess, no perforation, normal LV function
CXR: multiple bilateral cavitary nodules consistent with septic emboli
HIV: negative'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 32 ปี admit ICU ด้วย septic shock จาก community-acquired pneumonia

V/S เริ่มต้น: BP 78/44 (MAP 56), HR 124, RR 32, SpO2 88% on 6L NC, Temp 39.2°C
Lactate 4.8 mmol/L, qSOFA 3, SOFA 8
Lab: WBC 22,000 (N 88%, bands 12%), Plt 88,000, Cr 1.8, Bili 1.6
CXR: RLL consolidation
Blood + sputum cultures sent

คำถาม: management ใน hour 1 + ongoing per Surviving Sepsis Campaign', '[{"label":"A","text":"Wait for blood culture result before antibiotics"},{"label":"B","text":"Septic shock (sepsis-3 + vasopressor + lactate > 2 despite resuscitation)"},{"label":"C","text":"Aggressive 6 L crystalloid bolus regardless of response"},{"label":"D","text":"Norepinephrine before any fluid resuscitation"},{"label":"E","text":"Activated protein C (drotrecogin alfa)"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Septic shock (sepsis-3 + vasopressor + lactate > 2 despite resuscitation) — Hour 1 bundle (SSC 2021): (1) Measure lactate + remeasure if elevated; (2) Obtain blood cultures BEFORE antibiotics if no delay; (3) Broad-spectrum antibiotics WITHIN 1 hr (e.g., for CAP severe: beta-lactam + macrolide or respiratory FQ; broaden to ceftriaxone + azithromycin OR pip-tazo + macrolide if HAP risk); (4) Crystalloid 30 mL/kg within 3 hr (use balanced solution — RL preferred over NS per SMART/SALT-ED); (5) Vasopressor (norepinephrine first-line) for MAP ≥ 65 if hypotensive despite fluid; add vasopressin 0.03 U/min if norepi > 0.25-0.5 mcg/kg/min; epinephrine 3rd line; corticosteroid (hydrocortisone 200 mg/d) if refractory shock; source control; lung-protective ventilation; conservative transfusion (Hb > 7); glucose 140-180; VTE + stress ulcer prophylaxis; daily assessment de-escalation

---

Septic shock — Surviving Sepsis Campaign 2021 + 2024 update: (1) Hour-1 Bundle: lactate, blood cultures, broad-spectrum antibiotics, 30 mL/kg crystalloid in hypotension/lactate ≥ 4, vasopressor for refractory hypotension. (2) Fluid: balanced crystalloid (lactated Ringer, Plasma-Lyte) preferred over normal saline (SMART trial — less AKI); albumin if requiring large volumes. Dynamic measures (passive leg raise, stroke volume variation, IVC variability) to guide further fluid — avoid fluid overload (CLASSIC, CLOVERS data — restrictive may be non-inferior; ongoing debate). (3) Vasopressor: norepinephrine first; add vasopressin 0.03 U/min as norepi-sparing or for AVP-deficient; epinephrine for refractory; phenylephrine and dopamine not first-line. MAP target ≥ 65; higher in chronic HTN (SEPSISPAM hint). (4) Corticosteroid: hydrocortisone 50 mg q6h or 200 mg infusion for vasopressor-requiring septic shock (ADRENAL, APROCCHSS). (5) Empiric antibiotics within 1 hr: cover suspected source; for CAP severe — beta-lactam + macrolide (Cochrane); broaden for resistant organism risk. (6) Source control within 6-12 hr. (7) Mechanical ventilation: lung-protective. (8) Glycemic control 140-180. (9) VTE prophylaxis (LMWH unless contraindicated). (10) Stress ulcer prophylaxis high-risk only. (11) Nutrition: early enteral. (12) Drotrecogin alfa withdrawn (PROWESS-SHOCK negative). A ผิด — antibiotic delay = mortality. C ผิด — fluid not endless; reassess. D ผิด — fluid first then vaso (or concurrent). E ผิด — withdrawn drug.', NULL,
  'medium', 'id', 'review',
  'internal_medicine', 'clinical_decision', 'id', 'adult',
  'Surviving Sepsis Campaign International Guidelines 2021 (update 2024); SMART Trial NEJM 2018; ADRENAL NEJM 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 32 ปี admit ICU ด้วย septic shock จาก community-acquired pneumonia

V/S เริ่มต้น: BP 78/44 (MAP 56), HR 124, RR 32, SpO2 88% on 6L NC, Temp 39.2°C
Lactate 4.8 mmol/L, qSOFA 3, SOFA 8
Lab: WBC 22,000 (N 88%, bands 12%), Plt 88,000, Cr 1.8, Bili 1.6
CXR: RLL consolidation
Blood + sputum cultures sent

คำถาม: management ใน hour 1 + ongoing per Surviving Sepsis Campaign'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 58 ปี underlying T2DM, ESRD on hemodialysis × 3 ปี via tunneled CVC right IJ มา ED ด้วยไข้ 38.6°C + rigors ทันทีหลังจาก HD เมื่อเช้า + แดงร้อน + เจ็บบริเวณ exit site catheter

V/S: BP 102/64, HR 108, RR 20, SpO2 96%, Temp 38.6°C
PE: catheter exit site erythematous + purulent discharge, no tunnel tenderness, no septic emboli signs

Lab: WBC 14,200 (N 86%), Hb 10.2, Plt 198,000, Cr 6.8 (baseline 7.0), CRP 92
Blood culture × 2 from peripheral + catheter (paired): both positive Gram-positive cocci in clusters
Final ID: MRSA (vancomycin MIC 1.0, daptomycin susceptible)
TEE: no vegetation
CT chest: no septic emboli', '[{"label":"A","text":"Antibiotic lock therapy alone + retain catheter"},{"label":"B","text":"Catheter-related bloodstream infection (CRBSI) MRSA in HD patient"},{"label":"C","text":"Retain catheter + oral linezolid 600 mg BID × 10 d"},{"label":"D","text":"Remove catheter + cefazolin 1 g IV post-HD only"},{"label":"E","text":"Echinocandin coverage assumed fungal"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Catheter-related bloodstream infection (CRBSI) MRSA in HD patient — Definitive management: Remove catheter (S. aureus = absolute indication for removal per IDSA) + IV vancomycin (target trough 15-20 mg/L หรือ AUC 400-600) or daptomycin 6-8 mg/kg/dose post-HD × at least 4-6 weeks (S. aureus longer 4-6 wk due to metastatic infection risk; check TEE to rule out IE which would extend to 6 wk and consider surgical) + temporary vascath/femoral for HD while waiting + replace tunneled catheter at new site after blood cultures clear ≥ 48-72 hr + monitor for complications (endocarditis, septic arthritis, osteomyelitis, septic emboli); long-term vascular access planning (AVF) ideal

---

Catheter-related bloodstream infection in HD patient. IDSA 2009 CRBSI + 2016 vascular catheter + KDOQI vascular access guidelines: (1) Diagnosis CRBSI: same organism from catheter + peripheral blood (paired cultures with differential time to positivity > 2 hr suggests catheter source); 2 catheter cultures with same organism; quantitative blood culture catheter:peripheral ratio ≥ 3:1. (2) Catheter removal MANDATORY for: S. aureus, P. aeruginosa, Candida, complications (endocarditis, septic thrombophlebitis, persistent bacteremia > 72 hr despite Rx). (3) Antibiotic selection: empiric vancomycin (HD setting MRSA common) + Gram-negative coverage (cefepime, ceftazidime). De-escalate per culture. (4) Duration: - Uncomplicated CoNS: 5-7 days. - MSSA: 4 weeks (rule out IE with TEE — if positive 6 wk + surgical assessment). - MRSA: 4-6 weeks. - Gram-negative: 7-14 days. - Candida: 14 days from first negative culture + ophth exam. (5) Lock therapy + retain catheter: salvage option for coagulase-negative staph or Gram-neg in selected patients without complications, NOT for S. aureus / Candida. (6) Repeat blood cultures 2-4 d after starting therapy to ensure clearance. (7) TEE: S. aureus bacteremia routinely (high IE rate); MSSA bacteremia 28-day rule (TEE within 5-7 d). (8) Vascular access plan: transition to AVF (preferred) or AVG. A ผิด — S. aureus needs removal. C ผิด — retain not allowed for S. aureus. D ผิด — cefazolin OK for MSSA not MRSA. E ผิด — bacterial not fungal.', NULL,
  'hard', 'id', 'review',
  'internal_medicine', 'clinical_decision', 'id', 'adult',
  'IDSA Clinical Practice Guidelines for Diagnosis and Management of Intravascular Catheter-Related Infection 2009; IDSA 2023 Update; KDOQI Clinical Practice Guideline for Vascular Access 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 58 ปี underlying T2DM, ESRD on hemodialysis × 3 ปี via tunneled CVC right IJ มา ED ด้วยไข้ 38.6°C + rigors ทันทีหลังจาก HD เมื่อเช้า + แดงร้อน + เจ็บบริเวณ exit site catheter

V/S: BP 102/64, HR 108, RR 20, SpO2 96%, Temp 38.6°C
PE: catheter exit site erythematous + purulent discharge, no tunnel tenderness, no septic emboli signs

Lab: WBC 14,200 (N 86%), Hb 10.2, Plt 198,000, Cr 6.8 (baseline 7.0), CRP 92
Blood culture × 2 from peripheral + catheter (paired): both positive Gram-positive cocci in clusters
Final ID: MRSA (vancomycin MIC 1.0, daptomycin susceptible)
TEE: no vegetation
CT chest: no septic emboli'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 55 ปี ไม่มีโรคประจำตัวเดิม มาด้วยอ่อนเพลีย เลือดออกตามไรฟัน + จุดเลือดออกใต้ผิวหนัง (petechiae) ไข้ต่ำ 1 สัปดาห์ น้ำหนักลด 3 kg ใน 1 เดือน

V/S: BP 118/72, HR 96, RR 18, SpO2 98%, Temp 37.6°C
PE: pallor, petechiae lower extremities, gingival bleeding, no hepatosplenomegaly significant, no lymphadenopathy

Lab: Hb 7.4 (low), MCV 92, WBC 38,000 with 78% myeloblasts on peripheral smear (large cells with Auer rods + cytoplasm fine azurophilic granules), Plt 28,000
LDH 1,820, Uric acid 9.8, K 5.2, Phosphate 5.8, Ca 7.8, Cr 1.6
Fibrinogen 80, PT 18, aPTT 42, D-dimer 8,400 (DIC)
Bone marrow aspirate: > 90% promyelocytic blasts with abundant Auer rods + bilobed nuclei
Cytogenetics: t(15;17) PML-RARA fusion confirmed
FLT3 negative', '[{"label":"A","text":"Standard 7+3 cytarabine + daunorubicin chemotherapy"},{"label":"B","text":"Acute promyelocytic leukemia (APL) with coagulopathy/DIC"},{"label":"C","text":"Imatinib (BCR-ABL targeted)"},{"label":"D","text":"Watchful waiting until risk stratification complete"},{"label":"E","text":"Plasmapheresis for coagulopathy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute promyelocytic leukemia (APL) with coagulopathy/DIC — Hematologic emergency: Start ATRA (all-trans retinoic acid) 45 mg/m² IMMEDIATELY on clinical suspicion (don''t wait for cytogenetic confirmation) + Arsenic trioxide (ATO) 0.15 mg/kg/d for low-intermediate risk per Lo-Coco APL0406 (ATRA + ATO without chemo); for high-risk (WBC > 10,000) add anthracycline (idarubicin) or gemtuzumab ozogamicin; aggressive coagulopathy support — transfuse cryoprecipitate to fibrinogen > 150, FFP, platelets > 30-50K (DIC + bleeding); monitor for differentiation syndrome (ATRA syndrome: fever, dyspnea, weight gain, infiltrates, hypoxia, hypotension) → dexamethasone 10 mg BID; tumor lysis prophylaxis (allopurinol/rasburicase, IV fluid); CNS prophylaxis high-risk; PCR monitoring of PML-RARA for MRD; aim cure rate > 90%

---

Acute promyelocytic leukemia (APL) = AML-M3 with t(15;17) PML-RARA fusion. Distinct hematologic emergency due to early hemorrhagic death from DIC. NCCN + Sanz/PETHEMA APL guideline: (1) Start ATRA IMMEDIATELY on clinical suspicion — bilobed promyelocytes + Auer rods + DIC is the trigger; delay = death. (2) Frontline regimen: - Low/intermediate risk (WBC < 10,000): ATRA + ATO (APL0406 Lo-Coco NEJM 2013 — no chemotherapy, > 90% cure, lower toxicity). - High risk (WBC ≥ 10,000): ATRA + ATO + idarubicin or gemtuzumab ozogamicin (cytoreduction). (3) Coagulopathy support: aggressive blood products — fibrinogen > 150 mg/dL (cryoprecipitate), platelets > 30-50K, FFP for INR; daily monitoring DIC panel; avoid heparin/antifibrinolytics (no clear benefit; increase thrombosis with antifibrinolytics paradoxically). (4) Differentiation syndrome (formerly ATRA syndrome): fever, weight gain, infiltrates, effusions, hypotension, AKI; 25% incidence; dexamethasone 10 mg BID at first sign; continue ATRA unless severe. (5) Tumor lysis prophylaxis: hydration, allopurinol or rasburicase. (6) CNS prophylaxis: intrathecal MTX × 4-6 doses for high-risk. (7) Maintenance: ATRA ± 6MP + MTX × 2 yr in some protocols. (8) MRD monitoring: PCR PML-RARA q3 mo for 2 yr. APL cure rate now > 90% — was 0% pre-ATRA era. A ผิด — APL needs differentiation therapy, not 7+3. C ผิด — imatinib for CML/BCR-ABL. D ผิด — wait = bleed death. E ผิด — plasmapheresis no role.', NULL,
  'hard', 'hemato_onco', 'review',
  'internal_medicine', 'clinical_decision', 'hemato_onco', 'adult',
  'NCCN Guidelines for AML 2024; Lo-Coco F et al. NEJM 2013 (APL0406 ATRA+ATO); Sanz MA et al. Blood 2019 APL Guideline', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 55 ปี ไม่มีโรคประจำตัวเดิม มาด้วยอ่อนเพลีย เลือดออกตามไรฟัน + จุดเลือดออกใต้ผิวหนัง (petechiae) ไข้ต่ำ 1 สัปดาห์ น้ำหนักลด 3 kg ใน 1 เดือน

V/S: BP 118/72, HR 96, RR 18, SpO2 98%, Temp 37.6°C
PE: pallor, petechiae lower extremities, gingival bleeding, no hepatosplenomegaly significant, no lymphadenopathy

Lab: Hb 7.4 (low), MCV 92, WBC 38,000 with 78% myeloblasts on peripheral smear (large cells with Auer rods + cytoplasm fine azurophilic granules), Plt 28,000
LDH 1,820, Uric acid 9.8, K 5.2, Phosphate 5.8, Ca 7.8, Cr 1.6
Fibrinogen 80, PT 18, aPTT 42, D-dimer 8,400 (DIC)
Bone marrow aspirate: > 90% promyelocytic blasts with abundant Auer rods + bilobed nuclei
Cytogenetics: t(15;17) PML-RARA fusion confirmed
FLT3 negative'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 68 ปี underlying COPD + AF on warfarin (INR target 2-3, last INR 2.4) มา ED ด้วยเลือดออกในสมอง (acute ICH) จาก fall

V/S: BP 184/102, HR 88, RR 22, SpO2 95%, GCS 13
Neuro: right hemiparesis 2/5, NIHSS 16
CT brain: left putaminal hemorrhage 35 mL, no IVH, mild midline shift
INR 2.6, Hb 11.2, Plt 218,000, Cr 1.0
Fibrinogen 320', '[{"label":"A","text":"IV vitamin K 10 mg + observe"},{"label":"B","text":"Warfarin-associated intracerebral hemorrhage"},{"label":"C","text":"Fresh frozen plasma 4 units alone over 8 hr"},{"label":"D","text":"Activated factor VII alone"},{"label":"E","text":"Restart warfarin within 24 hr to prevent stroke"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Warfarin-associated intracerebral hemorrhage — IMMEDIATE reversal: 4-factor Prothrombin Complex Concentrate (4F-PCC, e.g., Kcentra) 25-50 IU/kg IV based on INR (preferred over FFP per Cochrane + INCH trial — faster INR correction + less volume + less mortality) + IV vitamin K 10 mg slow IV (sustains reversal as PCC short-acting); recheck INR 30 min + 6 hr (target < 1.4); BP control target SBP 130-150 (ATACH-II/INTERACT data — aggressive < 140 safe but not superior); neurosurgery consult (no surgery typically for deep ganglia ICH unless deteriorating large lobar > 30 mL near surface); avoid prophylactic anticonvulsant; ICU monitoring; once stable + 4-8 weeks → discuss restarting anticoagulation (RESTART trial favors restart for AF stroke prevention; weigh against rebleed)

---

Warfarin-associated ICH — life-threatening, requires urgent reversal. AHA/ASA 2022 ICH + Neurocritical Care 2016 anticoagulant reversal + ISTH guidelines: (1) Vitamin K antagonist (warfarin) reversal: - 4F-PCC (Kcentra) 25-50 IU/kg IV based on INR — INCH trial NEJM 2016 showed faster INR correction vs FFP, but did not improve mortality; preferred per Cochrane due to speed + small volume. - IV vitamin K 10 mg slow infusion (anaphylactoid risk; provides sustained reversal beyond PCC''s short half-life of factors). - Recheck INR 30 min + 6 hr; goal < 1.4. - FFP alternative if PCC unavailable but slower + larger volume. (2) DOAC reversal: - Dabigatran: idarucizumab (Praxbind). - Factor Xa inhibitor (apixaban, rivaroxaban): andexanet alfa (ANNEXA-4, ANNEXA-I) — class IIa; or 4F-PCC if andexanet unavailable. (3) BP target ICH: SBP 130-150; aggressive < 140 in ATACH-II safe but mortality benefit unclear (INTERACT2). (4) Surgical: minimally invasive surgery (ENRICH trial 2024 — benefit in lobar ICH 30-80 mL). DC for cerebellar > 3 cm or hydrocephalus. (5) Restart anticoagulation: balance stroke risk vs rebleed; typically 4-8 weeks for lobar (higher CAA rebleed) or earlier for deep (hypertensive); RESTART, SoSTART trials. (6) Seizure prophylaxis only if seizure, not routine. A ผิด — vit K alone too slow. C ผิด — FFP slower, large volume, less effective. D ผิด — rFVIIa increased thrombosis without benefit. E ผิด — too early restart = rebleed.', NULL,
  'hard', 'hemato_onco', 'review',
  'internal_medicine', 'clinical_decision', 'hemato_onco', 'adult',
  'AHA/ASA 2022 Guideline for the Management of Patients with Spontaneous Intracerebral Hemorrhage; Neurocritical Care Society Anticoagulation Reversal 2016; INCH Trial NEJM 2016', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 68 ปี underlying COPD + AF on warfarin (INR target 2-3, last INR 2.4) มา ED ด้วยเลือดออกในสมอง (acute ICH) จาก fall

V/S: BP 184/102, HR 88, RR 22, SpO2 95%, GCS 13
Neuro: right hemiparesis 2/5, NIHSS 16
CT brain: left putaminal hemorrhage 35 mL, no IVH, mild midline shift
INR 2.6, Hb 11.2, Plt 218,000, Cr 1.0
Fibrinogen 320'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 38 ปี ไม่มีโรคประจำตัวที่ทราบ มาด้วยปวดข้อนิ้วเท้ามาก รุนแรง onset 6 ชม. หลังกินอาหารทะเล + เบียร์เยอะ ตื่นมาเจ็บมากจนเดินไม่ได้

V/S: BP 138/82, HR 96, RR 16, Temp 38.0°C
PE: 1st MTP right swollen, erythematous, warm, exquisitely tender (typical podagra), no other joint involved, no tophi

Lab: Uric acid 9.2 mg/dL, CRP 48, WBC 12,400, Cr 1.1, no leukocytosis other
Joint aspiration: negatively birefringent needle-shaped crystals on polarized microscopy, WBC 28,000 (predominant neutrophil), Gram stain negative, culture pending
Previous: 2 similar episodes in past year self-limited', '[{"label":"A","text":"Start allopurinol 300 mg/d ทันทีระหว่าง acute attack"},{"label":"B","text":"Acute gout (3rd attack with monosodium urate crystals confirmed)"},{"label":"C","text":"Antibiotic for septic arthritis empirically"},{"label":"D","text":"Urate-lowering therapy alone without addressing acute pain"},{"label":"E","text":"Continuous opioid analgesia only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute gout (3rd attack with monosodium urate crystals confirmed) — Acute attack treatment options (similarly effective): (1) NSAIDs (naproxen 500 mg BID, indomethacin 50 mg TID) × 5-7 d — first-line if no CKD/PUD/CV contraindication; (2) Colchicine 1.2 mg then 0.6 mg 1 hr later then 0.6 mg BID until resolved (low-dose AGREE trial preferred over old high-dose); (3) Glucocorticoid PO/IA — prednisolone 30-40 mg/d taper 7-14 d or intra-articular if single joint; (4) IL-1 inhibitor (anakinra, canakinumab) refractory; THEN urate-lowering therapy (ULT) AFTER attack settles OR start during acute with adequate flare prophylaxis (ACR 2020 — can start ULT during flare): allopurinol initial 100 mg/d (50 mg in CKD 4-5) titrate q2-5 wk to target serum urate < 6 (< 5 with tophi); HLA-B*5801 screening in Han Chinese, Thai, Korean (SJS/TEN risk); febuxostat alternative; flare prophylaxis with colchicine 0.6 mg/d × 3-6 mo when starting ULT; lifestyle modification

---

Acute gout — classic podagra + needle-shaped negatively birefringent MSU crystals (gold standard). ACR 2020 + EULAR 2016 gout guideline: (1) Acute attack treatment (first-line — pick one): - NSAIDs (any FDA-approved): naproxen, indomethacin, etoricoxib; caution CKD, PUD, CV. - Colchicine: 1.2 mg → 0.6 mg 1 hr later → 0.6 mg BID until resolved (AGREE trial — low-dose non-inferior, less toxicity). Avoid CYP3A4/PgP interactions (clarithromycin, statin) → toxicity. - Glucocorticoid: oral prednisolone 30-40 mg × 5-10 d taper; IM/IA injection if single joint, can''t take oral. - IL-1 inhibitor for refractory: anakinra (daily), canakinumab. (2) Urate-lowering therapy (ULT) indications (ACR 2020): ≥ 2 attacks/yr, tophi, CKD stage ≥ 3, urate stones; conditionally even after 1st attack if young/comorbid/high urate. (3) ULT options: - Allopurinol (xanthine oxidase inhibitor): start 100 mg/d (50 mg in CKD 4-5), titrate q2-5 wk; target serum urate < 6 (< 5 with tophi); SJS/TEN risk in HLA-B*5801 (high in Han Chinese, Thai, Korean) — screen before starting per ACR. - Febuxostat: 2nd line; CV mortality concern (CARES trial). - Uricosuric (probenecid): if underexcretor + normal renal. - Pegloticase: refractory tophaceous. (4) Flare prophylaxis when starting ULT: colchicine 0.6 mg/d × 3-6 mo (avoids paradoxical flares from urate mobilization). (5) Can start ULT during attack (ACR 2020 changed from waiting). (6) Lifestyle: limit purine-rich (organ meats, seafood), fructose, alcohol (esp beer); weight loss; consider losartan, fenofibrate (mild uricosuric effect). A ผิด — start ULT during attack OK but not at 300 mg without titration. C ผิด — Gram stain neg, crystals + = gout. D ผิด — need analgesia. E ผิด — opioid alone misses anti-inflammatory.', NULL,
  'medium', 'rheumatology', 'review',
  'internal_medicine', 'clinical_decision', 'rheumatology', 'adult',
  'ACR Guideline for the Management of Gout 2020; EULAR Recommendations for the Management of Gout 2016; AGREE Trial Arthritis Rheum 2010', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 38 ปี ไม่มีโรคประจำตัวที่ทราบ มาด้วยปวดข้อนิ้วเท้ามาก รุนแรง onset 6 ชม. หลังกินอาหารทะเล + เบียร์เยอะ ตื่นมาเจ็บมากจนเดินไม่ได้

V/S: BP 138/82, HR 96, RR 16, Temp 38.0°C
PE: 1st MTP right swollen, erythematous, warm, exquisitely tender (typical podagra), no other joint involved, no tophi

Lab: Uric acid 9.2 mg/dL, CRP 48, WBC 12,400, Cr 1.1, no leukocytosis other
Joint aspiration: negatively birefringent needle-shaped crystals on polarized microscopy, WBC 28,000 (predominant neutrophil), Gram stain negative, culture pending
Previous: 2 similar episodes in past year self-limited'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 72 ปี มาด้วยปวดศีรษะข้างขวา + scalp tenderness + jaw claudication (เคี้ยวแล้วล้าจนต้องหยุด) มา 3 สัปดาห์ + transient vision loss (amaurosis fugax) ตา ขวา 1 ครั้ง 1 วันก่อน + อาการอ่อนเพลีย น้ำหนักลด ปวดไหล่ + สะโพกตอนเช้า (PMR symptoms)

V/S: BP 138/82, HR 78, Temp 37.4°C
PE: tender thickened cordlike right superficial temporal artery, decreased pulse, no visual field defect on exam, fundus normal at moment

Lab: ESR 92, CRP 64, Hb 10.4 (anemia of chronic disease), Plt 484,000, normal LFT, normal CK
US temporal artery: "halo sign" + non-compressible right TA', '[{"label":"A","text":"Wait for temporal artery biopsy before treatment"},{"label":"B","text":"Giant cell arteritis with cranial ischemic symptoms (jaw claudication + amaurosis fugax = imminent permanent vision loss risk)"},{"label":"C","text":"Methotrexate alone first-line"},{"label":"D","text":"NSAIDs only"},{"label":"E","text":"Oral prednisolone 20 mg/d to avoid side effects"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Giant cell arteritis with cranial ischemic symptoms (jaw claudication + amaurosis fugax = imminent permanent vision loss risk) — Start high-dose glucocorticoid IMMEDIATELY without waiting for biopsy: IV methylprednisolone pulse 500-1000 mg × 3 d (for visual symptoms) followed by oral prednisolone 1 mg/kg/d (max 60-80 mg); without visual symptoms: oral prednisolone 40-60 mg/d; obtain temporal artery biopsy within 2 weeks (steroid does not change pathology that quickly) — bilateral or 2 cm segment; treat PMR component overlap; add tocilizumab (anti-IL-6) as steroid-sparing per GiACTA trial (especially in refractory or steroid-toxicity risk); aspirin 81 mg may reduce ischemic events (some controversy); bone health (calcium, vit D, bisphosphonate); PCP prophylaxis if prolonged steroid; very slow taper over 1-2 yr; relapse common — monitor ESR/CRP + clinical

---

Giant cell arteritis (GCA) with cranial/ischemic symptoms — emergency. Classic features: > 50 yr (most > 70), new headache, scalp tenderness, jaw claudication, visual disturbance (amaurosis fugax → AION → blindness), PMR overlap (40-50%), constitutional, ESR/CRP↑, anemia, thrombocytosis. ACR/Vasculitis Foundation 2021 + EULAR GCA guideline: (1) START STEROID FIRST — do not wait for biopsy (steroid does not eliminate vasculitis on histology within 2 weeks). - Visual symptoms: IV methylprednisolone 500-1000 mg × 3 d → oral prednisolone 1 mg/kg/d. - No visual symptoms: oral prednisolone 40-60 mg/d. (2) Diagnostic confirmation: - Temporal artery biopsy (TAB) within 2 weeks: 2 cm segment, bilateral consider (skip lesions). - US TA: halo sign, compression sign — high specificity. - MR or PET-CT for large vessel involvement (50% LV GCA). (3) Tocilizumab (anti-IL-6R) — GiACTA trial NEJM 2017 — steroid-sparing, faster remission; option in initial or relapsed/steroid-toxicity. (4) Aspirin 81 mg: may reduce stroke/vision loss (mixed evidence). (5) Steroid taper: very slow over 1-2 yr; relapse 40-50%. (6) Adjuncts: bone health (DXA, Ca/vit D, bisphosphonate if prolonged), glucose monitoring, PCP prophylaxis (if pred ≥ 20 mg × ≥ 1 mo), cataract/glaucoma monitoring. (7) Large vessel involvement: surveillance for aortic aneurysm (CXR or aortic imaging annually). A ผิด — vision loss imminent. C ผิด — MTX adjunct not first-line. D ผิด — NSAID inadequate. E ผิด — 20 mg insufficient for GCA + vision.', NULL,
  'medium', 'rheumatology', 'review',
  'internal_medicine', 'clinical_decision', 'rheumatology', 'adult',
  'ACR/VF Guideline for the Management of GCA and TAK 2021; EULAR Recommendations for the Management of Large Vessel Vasculitis 2018; GiACTA Trial NEJM 2017', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 72 ปี มาด้วยปวดศีรษะข้างขวา + scalp tenderness + jaw claudication (เคี้ยวแล้วล้าจนต้องหยุด) มา 3 สัปดาห์ + transient vision loss (amaurosis fugax) ตา ขวา 1 ครั้ง 1 วันก่อน + อาการอ่อนเพลีย น้ำหนักลด ปวดไหล่ + สะโพกตอนเช้า (PMR symptoms)

V/S: BP 138/82, HR 78, Temp 37.4°C
PE: tender thickened cordlike right superficial temporal artery, decreased pulse, no visual field defect on exam, fundus normal at moment

Lab: ESR 92, CRP 64, Hb 10.4 (anemia of chronic disease), Plt 484,000, normal LFT, normal CK
US temporal artery: "halo sign" + non-compressible right TA'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 45 ปี ไม่มีโรคประจำตัวเดิม มาด้วยน้ำหนักลด 8 kg ใน 3 เดือน + เหงื่อกลางคืน + ไข้ + ต่อมน้ำเหลืองโตคอด้านขวา ขนาด 3 cm × 4 cm หลายต่อม ไม่เจ็บ

V/S: BP 122/74, HR 86, RR 16, SpO2 99%, Temp 37.8°C
PE: cervical + supraclavicular + axillary lymphadenopathy non-tender rubbery; spleen tip palpable 2 cm BCM; no pruritus, no alcohol-induced pain

Lab: Hb 11.8, WBC 8,400, Plt 268,000, LDH 480, Cr 0.9, LFT normal, Uric 6.2, ESR 58
HIV: negative, HBsAg neg, anti-HCV neg, EBV positive (latent)
CT chest/abdomen/pelvis: bulky mediastinal mass 8 cm + cervical, axillary lymphadenopathy + spleen 14 cm
Lymph node excisional biopsy: Reed-Sternberg cells (multinucleated owl-eye nuclei) CD15+ CD30+ CD20− with mixed inflammatory background
→ Classical Hodgkin lymphoma, nodular sclerosis subtype
PET-CT: stage IIB (above diaphragm + B symptoms + bulky)
BM biopsy: no involvement
Echo LVEF 60%, PFT normal, fertility counseling done', '[{"label":"A","text":"Surgical resection of involved lymph nodes"},{"label":"B","text":"Classical Hodgkin lymphoma, stage IIB bulky (unfavorable)"},{"label":"C","text":"Watchful waiting until B symptoms severe"},{"label":"D","text":"Rituximab monotherapy"},{"label":"E","text":"Bone marrow transplant first-line"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Classical Hodgkin lymphoma, stage IIB bulky (unfavorable) — Treatment: ABVD chemotherapy (doxorubicin, bleomycin, vinblastine, dacarbazine) × 4 cycles + Involved-Site Radiation Therapy (ISRT) to bulky/initial sites; alternative escalated BEACOPP for higher-risk; PET-adapted therapy per RATHL/AHL2011 — interim PET after 2 cycles → if Deauville 1-3 (negative) consider omit bleomycin; if PET-positive escalate; pneumocystis prophylaxis with prolonged therapy; bleomycin lung toxicity monitoring (PFT, avoid high FiO2); cardiac monitoring doxorubicin; fertility preservation (sperm bank, oocyte cryopreservation) before therapy; vaccinations live attenuated complete pre-Rx; brentuximab vedotin + nivolumab/pembrolizumab for relapsed/refractory; long-term: secondary malignancy, cardiac, lung, thyroid surveillance

---

Classical Hodgkin lymphoma. Ann Arbor staging modified Cotswolds/Lugano 2014: stage I-IV + A/B (constitutional symptoms) + E (extranodal) + X (bulky > 10 cm). Risk stratification (EORTC/GHSG): - Early favorable: I/II without risk factors. - Early unfavorable: I/II with B symptoms, bulky, > 3 sites, ESR > 50 or extranodal. - Advanced: III/IV. NCCN + ESMO HL guideline: (1) Early favorable: ABVD × 2 + ISRT 20 Gy (RAPID, EORTC H10); or ABVD × 3-4 if RT avoidance. (2) Early unfavorable: ABVD × 4 + ISRT 30 Gy. (3) Advanced: ABVD × 6 or escBEACOPP × 4-6 (better PFS but more toxic); brentuximab vedotin + AVD (ECHELON-1) — superior PFS, neuropathy concern. (4) PET-adapted: interim PET-2 negative (Deauville 1-3) → de-escalate (drop bleomycin per RATHL); positive → escalate. (5) Toxicity: bleomycin (pneumonitis — PFT, age > 40 risk), doxorubicin (cardiac), pregnancy concerns. (6) Survivorship: secondary cancers (breast in young women receiving thoracic RT, lung, sarcoma), cardiac, hypothyroidism (40-50% post-thoracic RT), infertility, psychosocial. (7) Relapsed/refractory: salvage chemo + autologous SCT; brentuximab, PD-1 inhibitor (nivolumab, pembrolizumab); allogeneic SCT for refractory. (8) Fertility preservation: sperm bank, oocyte/embryo, ovarian tissue cryopreservation. A ผิด — surgery only for biopsy. C ผิด — curable cancer, treat. D ผิด — rituximab for CD20+ (NHL), HL is CD20-. E ผิด — BMT for relapsed/refractory.', NULL,
  'medium', 'hemato_onco', 'review',
  'internal_medicine', 'clinical_decision', 'hemato_onco', 'adult',
  'NCCN Guidelines for Hodgkin Lymphoma 2024; ESMO Clinical Practice Guidelines on HL 2018; RATHL Trial NEJM 2016; ECHELON-1 NEJM 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 45 ปี ไม่มีโรคประจำตัวเดิม มาด้วยน้ำหนักลด 8 kg ใน 3 เดือน + เหงื่อกลางคืน + ไข้ + ต่อมน้ำเหลืองโตคอด้านขวา ขนาด 3 cm × 4 cm หลายต่อม ไม่เจ็บ

V/S: BP 122/74, HR 86, RR 16, SpO2 99%, Temp 37.8°C
PE: cervical + supraclavicular + axillary lymphadenopathy non-tender rubbery; spleen tip palpable 2 cm BCM; no pruritus, no alcohol-induced pain

Lab: Hb 11.8, WBC 8,400, Plt 268,000, LDH 480, Cr 0.9, LFT normal, Uric 6.2, ESR 58
HIV: negative, HBsAg neg, anti-HCV neg, EBV positive (latent)
CT chest/abdomen/pelvis: bulky mediastinal mass 8 cm + cervical, axillary lymphadenopathy + spleen 14 cm
Lymph node excisional biopsy: Reed-Sternberg cells (multinucleated owl-eye nuclei) CD15+ CD30+ CD20− with mixed inflammatory background
→ Classical Hodgkin lymphoma, nodular sclerosis subtype
PET-CT: stage IIB (above diaphragm + B symptoms + bulky)
BM biopsy: no involvement
Echo LVEF 60%, PFT normal, fertility counseling done'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 32 ปี ไม่มีโรคประจำตัว มา ED ด้วยไข้สูง 39.4°C + ปวดศีรษะรุนแรง + คอแข็ง + สับสน onset 18 ชม. ก่อนหน้านี้มี URI 3 วัน

V/S: BP 102/68, HR 112, RR 22, SpO2 97%, GCS 13 (E3V4M6)
PE: neck stiffness +, Kernig +, Brudzinski +, photophobia, no focal neuro, no papilledema, no rash

Lab: WBC 18,400 (N 92% bands 10%), Plt 168,000, Cr 1.0, Glucose 96, CRP 220

คำถาม: management ลำดับขั้นตอนใน suspected acute bacterial meningitis', '[{"label":"A","text":"CT brain ก่อน LP ในทุกรายของ suspected meningitis"},{"label":"B","text":"Suspected acute bacterial meningitis"},{"label":"C","text":"LP first then antibiotics"},{"label":"D","text":"Acyclovir IV monotherapy"},{"label":"E","text":"Delay antibiotics until culture confirms organism"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Suspected acute bacterial meningitis — Sequence: (1) Blood cultures × 2 immediately; (2) Empirical antibiotics WITHIN 1 hr (do NOT delay for CT/LP): ceftriaxone 2 g IV q12h + vancomycin 15-20 mg/kg q8-12h (cover S. pneumoniae, N. meningitidis, drug-resistant pneumococcus); add ampicillin 2 g q4h ถ้า > 50 yr or immunocompromised (Listeria coverage); (3) Adjunctive dexamethasone 10 mg IV q6h × 4 d started BEFORE or with first antibiotic dose (improves outcomes in pneumococcal — DeGans NEJM 2002); (4) CT brain BEFORE LP only if: immunocompromised, history of CNS disease, new seizure, papilledema, focal neuro deficit, altered consciousness (this patient GCS 13 may qualify — but don''t delay antibiotics); (5) LP after CT if no contraindication: opening pressure, cell count, glucose, protein, Gram stain, culture, PCR (meningococcal, pneumococcal, HSV, enterovirus); (6) Isolate (droplet precaution for meningococcus); contact prophylaxis (ciprofloxacin or rifampin) for close contacts of N. meningitidis; notify public health

---

Acute bacterial meningitis — neurological emergency. IDSA 2004 (updated) + ESCMID 2016 + Thai ID Society guideline: (1) Antibiotics within 1 hr of presentation reduces mortality — every hour delay = ↑ mortality 13%. (2) Empirical regimen: ceftriaxone + vancomycin (Asia: vancomycin covers drug-resistant pneumococcus; ceftriaxone for meningococcus + susceptible pneumococcus + GNB). (3) Ampicillin if > 50 yr, immunocompromised, alcoholic, pregnant — covers Listeria (4-cephalosporin resistant). (4) Acyclovir 10 mg/kg IV q8h if HSV encephalitis suspected (focal neuro, temporal lobe, seizure). (5) Dexamethasone 10 mg IV q6h × 4 d before/with first antibiotic — Cochrane: reduces hearing loss + mortality in pneumococcal; stop if not pneumococcal/H. influenzae. (6) CT before LP indications (IDSA): immunocompromised, CNS lesion history, new seizure, papilledema, GCS reduced, focal deficit. If CT not immediately available — empirical antibiotic + CT + LP. (7) Public health: meningococcal = mandatory notification + droplet isolation until 24 hr antibiotic + chemoprophylaxis (ciprofloxacin 500 mg × 1, rifampin 600 mg BID × 2 d) for household + close contacts. A ผิด — CT for selected, not all. C ผิด — Antibiotics first, never delay. D ผิด — acyclovir for HSV not initial bacterial. E ผิด — culture takes days, can''t wait.', NULL,
  'medium', 'id', 'review',
  'internal_medicine', 'clinical_decision', 'id', 'adult',
  'IDSA Practice Guideline for the Management of Bacterial Meningitis 2004; ESCMID Guideline 2016; van de Beek D et al. NEJM (Dexamethasone)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 32 ปี ไม่มีโรคประจำตัว มา ED ด้วยไข้สูง 39.4°C + ปวดศีรษะรุนแรง + คอแข็ง + สับสน onset 18 ชม. ก่อนหน้านี้มี URI 3 วัน

V/S: BP 102/68, HR 112, RR 22, SpO2 97%, GCS 13 (E3V4M6)
PE: neck stiffness +, Kernig +, Brudzinski +, photophobia, no focal neuro, no papilledema, no rash

Lab: WBC 18,400 (N 92% bands 10%), Plt 168,000, Cr 1.0, Glucose 96, CRP 220

คำถาม: management ลำดับขั้นตอนใน suspected acute bacterial meningitis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 28 ปี เกษตรกร อาชีพปลูกข้าว เพิ่งเข้าทุ่งนาน้ำท่วม 2 สัปดาห์ก่อน ขาเท้ามีแผลถลอกขณะลุยน้ำ มาด้วยไข้สูง 39.5°C × 6 วัน + ปวดศีรษะรุนแรง + ปวดน่อง + ตาแดง (conjunctival suffusion) + คลื่นไส้ + ปัสสาวะสีเข้ม

V/S: BP 92/56, HR 124, RR 22, SpO2 95%, Temp 39.5°C
PE: jaundice +, conjunctival suffusion (no purulent discharge), calf tenderness + (hallmark), no rash, lung mild crackles bilateral, abdomen mild tender, no meningismus

Lab: Hb 12.0, WBC 15,200 (N 86% — neutrophilic), Plt 78,000, Cr 3.2 (AKI), Bilirubin 8.4 (direct 5.2), AST 88, ALT 68, ALP 280, CK 6,200 (rhabdomyolysis), Lactate 2.4, INR 1.6
UA: protein 2+, granular casts, no RBC casts
CXR: bilateral patchy infiltrates (pulmonary hemorrhage)
Microscopic agglutination test (MAT) pending; leptospira IgM rapid test positive', '[{"label":"A","text":"Antipyretic + supportive care only"},{"label":"B","text":"Severe leptospirosis / Weil disease (icterohemorrhagic form)"},{"label":"C","text":"Empirical anti-malarial therapy first"},{"label":"D","text":"Steroid IV high-dose monotherapy"},{"label":"E","text":"Tetracycline + chloramphenicol combo"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe leptospirosis / Weil disease (icterohemorrhagic form) — IV penicillin G 1.5 MU q6h OR IV ceftriaxone 1 g IV q24h × 7 days (ceftriaxone preferred, simpler, covers other tropical co-infections like scrub typhus pending diagnosis; doxycycline 100 mg PO/IV BID alternative in mild cases — preferred for outpatient prevention/treatment). Supportive: aggressive fluid for AKI (avoid overload — capillary leak), pressors if shock, possibly hemodialysis if oliguric/severe metabolic derangement; monitor for: pulmonary hemorrhage syndrome (severe form — high mortality), DIC, jaundice, myocarditis; Jarisch-Herxheimer reaction watch (first 24 hr of antibiotics); notify public health (notifiable disease in Thailand); occupational + environmental exposure history; rodent contact, paddy field water — high prevalence in Thai farmers

---

Severe leptospirosis (Weil disease) — tropical zoonotic disease common in Thai paddy farmers, fishermen, post-flooding. Clinical triad: jaundice + AKI + hemorrhage. Other clues: calf tenderness, conjunctival suffusion (non-purulent), exposure history. WHO + Thai Leptospirosis guideline + Faine criteria: (1) Antibiotics — start ASAP (effectiveness ↓ after 5-7 d but still beneficial): - Severe/hospitalized: IV penicillin G 1.5 MU q6h OR IV ceftriaxone 1 g/d × 7 d (LeptIM trial — ceftriaxone non-inferior to penicillin, easier dosing, broader cover). - Mild outpatient: doxycycline 100 mg BID × 7 d. - Doxycycline 200 mg/week — chemoprophylaxis in high-exposure flood. (2) Jarisch-Herxheimer reaction: 24 hr after antibiotics — fever + shock; supportive. (3) Supportive: - AKI: cautious fluid, RRT for severe oliguric AKI or refractory acidosis. - Pulmonary hemorrhage (severe — high mortality): ARDS lung-protective ventilation; some advocate corticosteroid for SPHS (mixed evidence). - DIC: blood products. - Plasma exchange controversial. (4) Differential in tropical fever: scrub typhus (eschar, similar regions), dengue (positive NS1), malaria (P. falciparum), rickettsia, melioidosis (Burkholderia in NE Thailand — different exposure). (5) Public health notification + environmental investigation + community education. A ผิด — needs antibiotic. C ผิด — pattern fits Weil not malaria primarily. D ผิด — steroid not standard. E ผิด — old regimen, not first-line.', NULL,
  'medium', 'id', 'review',
  'internal_medicine', 'clinical_decision', 'id', 'adult',
  'WHO Human Leptospirosis Guideline 2003; Thai Ministry of Public Health Leptospirosis Treatment Guideline 2020; Suputtamongkol Y et al. CID 2004 (Ceftriaxone Thailand)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 28 ปี เกษตรกร อาชีพปลูกข้าว เพิ่งเข้าทุ่งนาน้ำท่วม 2 สัปดาห์ก่อน ขาเท้ามีแผลถลอกขณะลุยน้ำ มาด้วยไข้สูง 39.5°C × 6 วัน + ปวดศีรษะรุนแรง + ปวดน่อง + ตาแดง (conjunctival suffusion) + คลื่นไส้ + ปัสสาวะสีเข้ม

V/S: BP 92/56, HR 124, RR 22, SpO2 95%, Temp 39.5°C
PE: jaundice +, conjunctival suffusion (no purulent discharge), calf tenderness + (hallmark), no rash, lung mild crackles bilateral, abdomen mild tender, no meningismus

Lab: Hb 12.0, WBC 15,200 (N 86% — neutrophilic), Plt 78,000, Cr 3.2 (AKI), Bilirubin 8.4 (direct 5.2), AST 88, ALT 68, ALP 280, CK 6,200 (rhabdomyolysis), Lactate 2.4, INR 1.6
UA: protein 2+, granular casts, no RBC casts
CXR: bilateral patchy infiltrates (pulmonary hemorrhage)
Microscopic agglutination test (MAT) pending; leptospira IgM rapid test positive'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 24 ปี ไม่มีโรคประจำตัว มาด้วยไข้สูง 39°C × 4 วัน + ปวดเมื่อยกล้ามเนื้อ + ปวดข้อ + ปวดหลังตา + ผื่น maculopapular วันที่ 3-4 ก่อน defervescence

V/S: BP 102/64, HR 104, RR 18, SpO2 99%, Temp 38.6°C
PE: tourniquet test positive (> 20 petechiae/inch²), no jaundice, abdomen soft no ascites, no organomegaly

Lab: Hb 13.8 (baseline 12.0 — rising hemoconcentration), Hct 41% (rising), WBC 3,200 (low), Plt 88,000 (falling from 165,000 at day 1), AST 142, ALT 98, Cr 0.7, glucose 92, K 3.6, Albumin 3.4
Dengue NS1 antigen positive; IgM positive; IgG negative (primary)
ไม่มี warning signs ของ severe dengue ขณะนี้: no severe abdominal pain, no persistent vomiting, no mucosal bleeding, no lethargy, no fluid accumulation, no hepatomegaly > 2 cm
Does not yet meet criteria for severe dengue', '[{"label":"A","text":"Discharge home + paracetamol + NSAID + observe outpatient"},{"label":"B","text":"Dengue with warning signs cusp (rising Hct + dropping platelets at critical phase day 4-5 = transitioning to critical/leak phase)"},{"label":"C","text":"Aggressive IV fluid 30 mL/kg bolus regardless of phase"},{"label":"D","text":"Prophylactic platelet transfusion if Plt < 50,000"},{"label":"E","text":"Empirical antibiotics for febrile illness"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Dengue with warning signs cusp (rising Hct + dropping platelets at critical phase day 4-5 = transitioning to critical/leak phase) — admit + monitor q4-6h V/S + Hct + UO + warning signs; isotonic IV fluid (Ringer lactate or NS) titrate to maintain UO 0.5-1 mL/kg/hr + Hct stability; serial Hct (every 4-6 hr in critical phase); paracetamol ONLY (avoid NSAIDs, aspirin — bleeding risk); platelet transfusion only if active bleeding (not prophylactic by count alone unless < 10K in some); avoid IM injection, central lines if possible; recognize compensated/decompensated dengue shock (narrow pulse pressure < 20 mmHg → IV crystalloid bolus 10-20 mL/kg; refractory → colloid + look for occult bleeding); convalescent phase (day 6-7 onwards): reabsorption — STOP/reduce IV fluid to prevent overload (most common iatrogenic harm)

---

Dengue fever transitioning into critical phase (day 4-6 — plasma leakage). WHO + Thai Dengue 2009 + 2022 guideline: (1) Phases: - Febrile (day 1-3): high fever, malaise, headache, retro-orbital pain. - Critical (day 4-6, around defervescence): plasma leakage — rising Hct, falling platelets; risk of shock, bleeding, organ impairment. - Recovery (day 7-10): reabsorption of leaked fluid; risk of fluid overload, pulmonary edema, hyponatremia. (2) Warning signs (WHO 2009): abdominal pain, persistent vomiting, mucosal bleeding, lethargy/restlessness, hepatomegaly > 2 cm, ↑ Hct + ↓ platelet. (3) Severe dengue: severe plasma leakage (shock, fluid accumulation with respiratory distress), severe bleeding, severe organ impairment (AST/ALT ≥ 1000, CNS, cardiac, AKI). (4) Fluid management cornerstone: - Maintenance crystalloid (RL/NS) titrate by UO + Hct + clinical. - Shock (DSS): 10-20 mL/kg bolus crystalloid; refractory → colloid (dextran-70, gelofusine); blood transfusion if Hct ↓ rapidly (occult bleed). - Recovery phase: ↓ IV rapidly; furosemide if overload. (5) Antipyretic: paracetamol only; NO NSAIDs/aspirin (bleeding, Reye). (6) Platelet transfusion: NOT prophylactic by number alone in dengue; only with active significant bleeding or < 10K with risk factors. Cochrane: no benefit prophylactic. (7) IM injection avoid; line placement minimal; safe NG if bleeding. (8) Surveillance: notifiable disease; vector control. (9) Discharge: afebrile > 48 hr, clinical improvement, rising platelets, stable Hct, good UO. A ผิด — critical phase needs monitoring. C ผิด — aggressive fluid → overload. D ผิด — no prophylactic transfusion. E ผิด — viral.', NULL,
  'medium', 'id', 'review',
  'internal_medicine', 'clinical_decision', 'id', 'adult',
  'WHO Dengue Guidelines for Diagnosis, Treatment, Prevention and Control 2009 (update 2022); Thai DOH Dengue Clinical Practice Guideline 2022', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 24 ปี ไม่มีโรคประจำตัว มาด้วยไข้สูง 39°C × 4 วัน + ปวดเมื่อยกล้ามเนื้อ + ปวดข้อ + ปวดหลังตา + ผื่น maculopapular วันที่ 3-4 ก่อน defervescence

V/S: BP 102/64, HR 104, RR 18, SpO2 99%, Temp 38.6°C
PE: tourniquet test positive (> 20 petechiae/inch²), no jaundice, abdomen soft no ascites, no organomegaly

Lab: Hb 13.8 (baseline 12.0 — rising hemoconcentration), Hct 41% (rising), WBC 3,200 (low), Plt 88,000 (falling from 165,000 at day 1), AST 142, ALT 98, Cr 0.7, glucose 92, K 3.6, Albumin 3.4
Dengue NS1 antigen positive; IgM positive; IgG negative (primary)
ไม่มี warning signs ของ severe dengue ขณะนี้: no severe abdominal pain, no persistent vomiting, no mucosal bleeding, no lethargy, no fluid accumulation, no hepatomegaly > 2 cm
Does not yet meet criteria for severe dengue'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 38 ปี ทำงานในป่าเขาภาคเหนือ มา 1 สัปดาห์ มาด้วยไข้สูง 39.2°C × 7 วัน + ปวดศีรษะ + ปวดเมื่อย + ไอแห้ง + cervical lymphadenopathy generalized

PE: small black eschar 5 mm ที่ inguinal region (eschar = patognomonic), generalized lymphadenopathy painless, maculopapular rash trunk, hepatosplenomegaly mild

Lab: Hb 13.0, WBC 9,800, Plt 96,000, AST 138, ALT 92, Cr 1.0, ESR 88
Weil-Felix: OX-K positive (suggestive)
Indirect immunofluorescence Orientia tsutsugamushi IgM positive → confirms scrub typhus
Malarial film negative, Dengue NS1 negative, leptospira IgM negative
ไม่มี severe complications (no MOF, no ARDS, no meningoencephalitis)', '[{"label":"A","text":"Ampicillin-sulbactam IV"},{"label":"B","text":"Scrub typhus (Orientia tsutsugamushi)"},{"label":"C","text":"Praziquantel for parasitic infection"},{"label":"D","text":"Antiviral oseltamivir empirical"},{"label":"E","text":"IV cefepime + metronidazole"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Scrub typhus (Orientia tsutsugamushi) — characteristic eschar + tropical fever + regional exposure (North/Northeast Thailand) — First-line: doxycycline 100 mg PO/IV BID × 7 d (very rapid defervescence, often < 48 hr — clinical ''doxycycline response'' supports diagnosis); azithromycin 500 mg/d × 3-5 d alternative (preferred in pregnancy, children < 8 yr, doxy intolerance); chloramphenicol older alternative; ceftriaxone NOT effective (rickettsia is intracellular); severe disease (MOF, ARDS, meningoencephalitis) — IV doxycycline + supportive ICU; consider co-infection workup (leptospira, dengue, melioidosis common co-endemic in Thailand); notify public health (vector mite chiggers); occupation/exposure counseling + DEET; family/cluster investigation

---

Scrub typhus — Orientia tsutsugamushi via chigger mite bite; endemic in Asia-Pacific including Thailand (North/Northeast). Clinical: eschar (60-90% — pathognomonic black necrotic skin with rim of erythema, often inguinal/axillary/groin/genital — search carefully), fever, headache, myalgia, lymphadenopathy, maculopapular rash, hepatosplenomegaly. Complications: pneumonia, ARDS, meningoencephalitis, AKI, hepatitis, myocarditis, DIC, MOF. WHO + Thai ID + ICMR guideline: (1) First-line: doxycycline 100 mg BID × 7 d — rapid defervescence within 24-48 hr (response is diagnostic clue); IV in severe. (2) Azithromycin 500 mg/d × 3-5 d — preferred in pregnancy, children < 8 yr, doxy allergy/intolerance; effective in doxy-resistant strains (some Thai isolates). (3) Chloramphenicol 50-75 mg/kg/d — older alternative, blood dyscrasia risk. (4) Rifampin 600-900 mg/d × 7 d — used in some Asian doxy-resistant studies. (5) Beta-lactam NOT effective — intracellular pathogen. (6) Severe (MOF, ARDS, meningoencephalitis): IV doxycycline, supportive ICU care; mortality up to 30% if untreated. (7) Co-infection (Thailand co-endemic): always rule out leptospirosis, dengue, malaria, melioidosis. (8) Prevention: DEET, protective clothing, avoiding chigger-infested grass/shrub, doxycycline prophylaxis for short-term exposure. A ผิด — beta-lactam ineffective. C ผิด — not parasitic. D ผิด — not influenza. E ผิด — gram-positive/anaerobe regimens ไม่ครอบ rickettsia.', NULL,
  'easy', 'id', 'review',
  'internal_medicine', 'clinical_decision', 'id', 'adult',
  'Thai Society of ID Scrub Typhus Guideline 2021; WHO Recognizing Neglected Tropical Diseases — Scrub Typhus 2017; Watt G et al. NEJM 1996 (Doxy + Thai resistance)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 38 ปี ทำงานในป่าเขาภาคเหนือ มา 1 สัปดาห์ มาด้วยไข้สูง 39.2°C × 7 วัน + ปวดศีรษะ + ปวดเมื่อย + ไอแห้ง + cervical lymphadenopathy generalized

PE: small black eschar 5 mm ที่ inguinal region (eschar = patognomonic), generalized lymphadenopathy painless, maculopapular rash trunk, hepatosplenomegaly mild

Lab: Hb 13.0, WBC 9,800, Plt 96,000, AST 138, ALT 92, Cr 1.0, ESR 88
Weil-Felix: OX-K positive (suggestive)
Indirect immunofluorescence Orientia tsutsugamushi IgM positive → confirms scrub typhus
Malarial film negative, Dengue NS1 negative, leptospira IgM negative
ไม่มี severe complications (no MOF, no ARDS, no meningoencephalitis)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 56 ปี underlying T2DM long-standing, alcoholic, นาข้าวอีสาน มาด้วยไข้สูง + ฝีหนองที่ปอด + ตับ + ม้าม + ข้อ + ผิวหนัง 3 สัปดาห์ ก่อนหน้านี้ลุยน้ำขณะฝนตก

V/S: BP 96/58, HR 116, RR 24, SpO2 90% RA, Temp 39.0°C
PE: multiple skin abscess, hepatosplenomegaly, lung crackles + consolidation RLL

Lab: Hb 9.8, WBC 21,000 (N 88%), Plt 188,000, Cr 1.6, ALT 92, ALP 320, Bilirubin 2.4, Glucose 380
CXR: multilobar consolidation + cavitation + nodules
US abdomen: multiple liver + spleen abscesses
Blood + abscess pus culture × 4: Burkholderia pseudomallei (oxidase positive, gram-negative bipolar safety-pin stain) — sensitive ceftazidime, meropenem, TMP-SMX', '[{"label":"A","text":"Oral doxycycline + observation"},{"label":"B","text":"Severe disseminated melioidosis (Burkholderia pseudomallei) — Two-phase therapy"},{"label":"C","text":"Ciprofloxacin alone × 14 d"},{"label":"D","text":"Vancomycin IV for gram-positive coverage"},{"label":"E","text":"Stop antibiotic once blood culture clears"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe disseminated melioidosis (Burkholderia pseudomallei) — Two-phase therapy: (1) **Intensive phase** (≥ 10-14 d, longer in severe disseminated): IV ceftazidime 50 mg/kg q6-8h OR meropenem 1 g q8h (meropenem preferred in severe sepsis, neuro, septic shock — MERTH trial); add IV TMP-SMX if deep-seated focus (CNS, bone, prostate, joint); (2) **Eradication phase** (3-6 months — usually 3 mo for skin, 6 mo for visceral abscess/bone/prostate): oral TMP-SMX 8/40 mg/kg/dose BID + folic acid; alternative doxycycline 100 mg BID + amoxicillin-clavulanate in TMP-SMX intolerance (less effective — higher relapse). Source control: drain large abscesses. Diabetes/alcohol management — major host risk factors. Lifelong relapse risk → adherence critical; report to public health (Northeast Thailand endemic); occupational exposure counseling (paddy field, mud, contaminated water/soil)

---

Melioidosis — Burkholderia pseudomallei, endemic in Northeast Thailand (Khon Kaen, Ubon — highest incidence globally), Southeast Asia, northern Australia. Bacterium of soil + surface water; risk factors = diabetes (most important — 50% of cases), alcoholism, CKD, thalassemia, chronic lung disease, occupational exposure (rice farmers). Disseminated form = highest mortality (40-60%). Limmathurotsakul/Wuthiekanun + Currie + IDSA Tropical guideline: (1) Intensive phase ≥ 10-14 d (longer 4-8 wk in severe/disseminated/deep): - IV ceftazidime 50 mg/kg q6-8h (max 8 g/d) — standard. - IV meropenem 1 g q8h — for severe sepsis, septic shock, ICU, neurological involvement (MERTH trial showed reduced mortality in severe cases). - Add IV TMP-SMX (8/40 mg/kg q12h) for: CNS, bone, joint, prostate, deep-seated focus. (2) Eradication phase 3-6 months (oral): - TMP-SMX 8/40 mg/kg per dose BID × 3 mo (skin, simple) or 6 mo (visceral abscess, bone, prostate) + folic acid 5 mg/d. - Alternative: doxycycline 100 mg BID + amoxicillin-clavulanate — higher relapse rate (~10%). (3) Source control: drainage of large abscesses; orchiectomy/prostatectomy for refractory prostate; cardiac surgery for endocarditis. (4) Host optimization: glycemic control (essential), alcohol cessation, treat comorbid. (5) Relapse: 5-15% — usually due to inadequate eradication; serial follow-up. (6) Public health: notifiable in Thailand; environmental investigation; education farmers re foot protection, avoiding mud, post-flood. A ผิด — disseminated severe needs IV intensive. C ผิด — cipro inadequate. D ผิด — gram-negative not positive. E ผิด — eradication phase 3-6 mo essential.', NULL,
  'hard', 'id', 'review',
  'internal_medicine', 'clinical_decision', 'id', 'adult',
  'Limmathurotsakul D et al. Lancet ID 2010; Currie BJ + Inglis TJJ — Melioidosis NEJM 2012; Thai Melioidosis Treatment Guideline; MERTH Trial Lancet ID 2014', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 56 ปี underlying T2DM long-standing, alcoholic, นาข้าวอีสาน มาด้วยไข้สูง + ฝีหนองที่ปอด + ตับ + ม้าม + ข้อ + ผิวหนัง 3 สัปดาห์ ก่อนหน้านี้ลุยน้ำขณะฝนตก

V/S: BP 96/58, HR 116, RR 24, SpO2 90% RA, Temp 39.0°C
PE: multiple skin abscess, hepatosplenomegaly, lung crackles + consolidation RLL

Lab: Hb 9.8, WBC 21,000 (N 88%), Plt 188,000, Cr 1.6, ALT 92, ALP 320, Bilirubin 2.4, Glucose 380
CXR: multilobar consolidation + cavitation + nodules
US abdomen: multiple liver + spleen abscesses
Blood + abscess pus culture × 4: Burkholderia pseudomallei (oxidase positive, gram-negative bipolar safety-pin stain) — sensitive ceftazidime, meropenem, TMP-SMX'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 35 ปี เพิ่งกลับจากซาฟารีในกานา 2 สัปดาห์ที่แล้ว ไม่ได้กินยา chemoprophylaxis มา ED ด้วยไข้สูง 40°C + chills + ปวดศีรษะ + คลื่นไส้ + ปัสสาวะสีดำ + ซีด

V/S: BP 88/52, HR 132, RR 28, SpO2 94%, Temp 40.2°C, GCS 13
PE: jaundice, pallor, hepatosplenomegaly +, no rash, no meningismus

Lab: Hb 6.4 (severe anemia), Plt 28,000, WBC 8,400, Cr 2.6, BUN 64, AST 142, ALT 88, Bilirubin 4.8 (mostly indirect — hemolysis), LDH 1,840, glucose 48 (hypoglycemia), Lactate 7.2 (severe), HCO3 14 (acidosis)
Thick blood film: high parasitemia 12% Plasmodium falciparum ring forms + few schizonts (ominous)
UA: hemoglobinuria + (blackwater fever)
No G6PD deficiency known', '[{"label":"A","text":"Oral artemether-lumefantrine × 3 d"},{"label":"B","text":"Severe Plasmodium falciparum malaria (parasitemia > 10%, severe anemia, AKI, jaundice, hypoglycemia, acidosis, hyperlactatemia, altered consciousness"},{"label":"C","text":"IV chloroquine (still effective in Africa)"},{"label":"D","text":"Primaquine alone first-line for radical cure"},{"label":"E","text":"Mefloquine PO empirical"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe Plasmodium falciparum malaria (parasitemia > 10%, severe anemia, AKI, jaundice, hypoglycemia, acidosis, hyperlactatemia, altered consciousness — WHO severe malaria criteria multiple) — IV artesunate 2.4 mg/kg at 0, 12, 24 hr then daily (artesunate superior to quinine — SEAQUAMAT, AQUAMAT — ↓ mortality 35% adult, 22% pediatric); continue at least 24 hr IV regardless of clinical response, then complete with full oral artemisinin combination therapy (ACT) e.g., artemether-lumefantrine × 3 d (anti-relapse); supportive: cautious IV fluid (avoid overload — ARDS), correct hypoglycemia (D10), blood transfusion if Hb < 7 + symptomatic, dialysis for severe AKI, broad-spectrum antibiotics if concomitant sepsis (bacteremia common); exchange transfusion no longer routine recommended; monitor for delayed hemolysis 7-14 d post-artesunate; admit ICU

---

Severe Plasmodium falciparum malaria — high mortality if delayed. WHO severe malaria criteria: any 1 of impaired consciousness, prostration, multiple seizures, acidosis (HCO3 < 15, lactate > 5), hypoglycemia (< 40), severe anemia (Hb < 7 adult), AKI, hyperbilirubinemia (jaundice), pulmonary edema/ARDS, abnormal bleeding, shock, hyperparasitemia (> 10% in non-immune, > 5% in falciparum). WHO Malaria Treatment Guideline 2023 + Thai Vector-borne Disease guideline: (1) IV artesunate FIRST-LINE for severe malaria — 2.4 mg/kg at 0, 12, 24 hr then daily; minimum 24 hr IV; landmark trials SEAQUAMAT (Lancet 2005, Asia) and AQUAMAT (Lancet 2010, Africa pediatric) showed substantial mortality reduction over quinine. (2) Continue with full oral ACT regimen × 3 d for radical cure after IV done. (3) Quinine + doxycycline/clindamycin: second-line if artesunate unavailable; hypoglycemia + cardiotoxicity. (4) Supportive: - Fluids: cautious — over-resuscitation worsens ARDS/cerebral edema (FEAST principle). - Hypoglycemia: D10/D50; quinine-induced hyperinsulinism in pregnant. - Anemia: transfusion if Hb < 7 + symptomatic. - AKI: dialysis if oliguric, severe acidosis, fluid overload. - Sepsis: bacteremia common in severe malaria (especially African children) — empirical broad-spectrum antibiotics. - Avoid: routine steroid, exchange transfusion (no benefit). (5) Delayed hemolytic anemia post-artesunate (PADH) 7-14 d — monitor Hb. (6) Cerebral malaria: ICU, mannitol selectively for raised ICP. (7) Primaquine after acute Rx — only if confirmed P. vivax/ovale + G6PD-normal; not falciparum routine (gametocidal single dose 0.25 mg/kg for transmission control). (8) Chloroquine: NOT for P. falciparum (universal resistance); only in chloroquine-sensitive vivax. A ผิด — severe malaria = IV not oral. C ผิด — chloroquine resistance universal P. falciparum. D ผิด — primaquine for radical cure of vivax/ovale, not severe falciparum. E ผิด — mefloquine adjunctive prophylaxis/uncomplicated, not severe.', NULL,
  'hard', 'id', 'review',
  'internal_medicine', 'clinical_decision', 'id', 'adult',
  'WHO Guidelines for Malaria 2023; SEAQUAMAT Lancet 2005; AQUAMAT Lancet 2010; Thai BVBD National Malaria Treatment Guideline 2021', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 35 ปี เพิ่งกลับจากซาฟารีในกานา 2 สัปดาห์ที่แล้ว ไม่ได้กินยา chemoprophylaxis มา ED ด้วยไข้สูง 40°C + chills + ปวดศีรษะ + คลื่นไส้ + ปัสสาวะสีดำ + ซีด

V/S: BP 88/52, HR 132, RR 28, SpO2 94%, Temp 40.2°C, GCS 13
PE: jaundice, pallor, hepatosplenomegaly +, no rash, no meningismus

Lab: Hb 6.4 (severe anemia), Plt 28,000, WBC 8,400, Cr 2.6, BUN 64, AST 142, ALT 88, Bilirubin 4.8 (mostly indirect — hemolysis), LDH 1,840, glucose 48 (hypoglycemia), Lactate 7.2 (severe), HCO3 14 (acidosis)
Thick blood film: high parasitemia 12% Plasmodium falciparum ring forms + few schizonts (ominous)
UA: hemoglobinuria + (blackwater fever)
No G6PD deficiency known'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 78 ปี underlying COPD + dementia + nursing home resident มา ED ด้วยไข้ + ไอ + เสมหะ + เหนื่อย 3 วัน ก่อนหน้านี้ admit รพ. 1 เดือนก่อนสำหรับ pneumonia

V/S: BP 102/64, HR 108, RR 26, SpO2 88% RA → 93% on 4L NC, Temp 38.6°C
PE: confusion (worse than baseline), crackles LLL + dullness, accessory muscle use

Lab: WBC 22,000, Cr 1.6 (baseline 1.0), Lactate 2.6, Procalcitonin 8.4, BUN 38, Glucose 192, Hb 11.4
CXR: LLL consolidation
CURB-65 = 4, qSOFA = 2, PSI class V (high risk)
No penicillin allergy', '[{"label":"A","text":"Oral azithromycin + discharge home"},{"label":"B","text":"Severe healthcare-associated/nursing home pneumonia (NHAP) with sepsis"},{"label":"C","text":"Oral amoxicillin × 7 d outpatient"},{"label":"D","text":"Single antibiotic IV ceftriaxone only"},{"label":"E","text":"Antiviral oseltamivir alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe healthcare-associated/nursing home pneumonia (NHAP) with sepsis — admit (consider ICU given respiratory distress + sepsis + age + comorbid) + empirical IV broad-spectrum within 1 hr (sepsis bundle): cover MRSA + Pseudomonas (recent hospitalization, NH residence, prior antibiotics) — vancomycin (or linezolid for MRSA pneumonia advantage in lung penetration + thrombocytopenia consideration) + piperacillin-tazobactam OR cefepime OR meropenem (Pseudomonas + GNB); add azithromycin or respiratory FQ (atypical coverage); blood cultures + sputum Gram/culture before antibiotics if no delay; respiratory virus panel; urinary antigens (Legionella, pneumococcal); influenza/COVID test; oxygen + NIV if hypercapnic; conservative fluid for sepsis; de-escalate based on culture in 48-72 hr; duration 7-8 d for uncomplicated bacterial; 14 d if Pseudomonas/MRSA/cavitation; vaccinate after recovery (pneumococcal, influenza); goals-of-care discussion in dementia given prognosis

---

Severe pneumonia with sepsis in patient with healthcare-associated risk factors (nursing home, recent hospitalization, prior antibiotics). IDSA/ATS 2019 CAP + 2016 HAP/VAP guideline: (1) Risk stratification: CURB-65, PSI/PORT; ICU criteria (IDSA major/minor — invasive vent or septic shock = major; ≥ 3 minor). (2) HCAP concept officially removed from 2016 IDSA HAP/VAP — but for nursing home residents with severe pneumonia + recent hospital + comorbidities, MDR coverage warranted: - Standard severe CAP: beta-lactam (ceftriaxone/cefotaxime) + macrolide (azithromycin) OR respiratory FQ. - + Pseudomonas risk (structural lung dz, recent abx, recent hosp, NH): pip-tazo OR cefepime OR meropenem. - + MRSA risk (recent hospitalization, prior MRSA, dialysis, IVDU, post-influenza, cavitary): vancomycin or linezolid (linezolid: superior in MRSA pneumonia per ZEPHyR though debated; safer in renal). (3) Diagnostics: blood + sputum cultures (high-quality sputum), urinary antigens (Strep pneumo, Legionella), respiratory viral panel + influenza/COVID test. (4) Duration: 5-7 d uncomplicated, 7-8 d HAP, 14 d Pseudomonas/MRSA/abscess/empyema. (5) Adjuncts: oxygen, NIV for hypercapnia (avoid if altered mental status), conservative fluid, glycemic control, VTE prophylaxis, early enteral nutrition. (6) Vaccinate after recovery: PCV20 or PPSV23, annual influenza, COVID booster. (7) Steroid: dexamethasone 6 mg in severe CAP showed benefit in CAPE-COD NEJM 2023 — option but not yet universal. (8) De-escalate based on culture/clinical response 48-72 hr. (9) Failure to improve: complications (empyema, abscess), resistant organism, unusual pathogen (TB, fungal). (10) Dementia + severe pneumonia — palliative care discussion. A ผิด — severe = admit. C ผิด — severity needs IV broad. D ผิด — single agent doesn''t cover MRSA/Pseudo/atypical. E ผิด — bacterial likely primary.', NULL,
  'medium', 'id', 'review',
  'internal_medicine', 'clinical_decision', 'id', 'adult',
  'IDSA/ATS Guideline for Diagnosis and Treatment of Adults with CAP 2019; IDSA/ATS Management of HAP/VAP 2016; CAPE-COD Trial NEJM 2023 (Dexamethasone)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 78 ปี underlying COPD + dementia + nursing home resident มา ED ด้วยไข้ + ไอ + เสมหะ + เหนื่อย 3 วัน ก่อนหน้านี้ admit รพ. 1 เดือนก่อนสำหรับ pneumonia

V/S: BP 102/64, HR 108, RR 26, SpO2 88% RA → 93% on 4L NC, Temp 38.6°C
PE: confusion (worse than baseline), crackles LLL + dullness, accessory muscle use

Lab: WBC 22,000, Cr 1.6 (baseline 1.0), Lactate 2.6, Procalcitonin 8.4, BUN 38, Glucose 192, Hb 11.4
CXR: LLL consolidation
CURB-65 = 4, qSOFA = 2, PSI class V (high risk)
No penicillin allergy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 68 ปี underlying T2DM, HT มา ED ด้วยอาการสับสน + อ่อนเพลีย + ปัสสาวะเยอะ + กระหายน้ำมาก 4 วัน หลังจากเริ่มมี viral URI 1 สัปดาห์ก่อน ไม่กินอาหารและน้ำตามปกติ

V/S: BP 96/58, HR 124, RR 20, SpO2 97%, Temp 37.4°C, น้ำหนัก 68 kg
PE: dry mucous membrane, sunken eyes, lethargic, GCS 13, no Kussmaul breathing

Lab: Glucose 968 mg/dL, Na 138 (corrected 156 — Adj +1.6 per 100 above 100), K 4.8, Cl 110, HCO3 22, BUN 76, Cr 2.8, Anion gap 12 (NORMAL), Ketones beta-hydroxybutyrate 0.4 (minimal), Osm 392 mOsm/kg, Lactate 1.4, Albumin 3.4
Urinalysis: ketones trace (mild), glucose 4+
ABG: pH 7.34, PaCO2 38, HCO3 22', '[{"label":"A","text":"Treat as DKA: NSS + insulin infusion + bicarbonate"},{"label":"B","text":"Hyperosmolar Hyperglycemic State (HHS)"},{"label":"C","text":"IV regular insulin bolus 0.1 U/kg before fluid resuscitation"},{"label":"D","text":"Discharge with adjustment of oral antidiabetic medication"},{"label":"E","text":"Rapid correction of glucose to normal in 2 hours"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hyperosmolar Hyperglycemic State (HHS) — older T2DM, severe hyperglycemia > 600, effective serum osmolality > 320 (here calc shows > 320), minimal ketosis, normal pH/AG: (1) Aggressive fluid replacement first (volume deficit 8-10 L typical) — NSS 1-1.5 L over 1 hr then 250-500 mL/hr; switch to ½NS when corrected serum Na ≥ 135; add D5/D10 once glucose 250-300 (continue insulin); (2) Insulin infusion 0.05-0.1 U/kg/hr started AFTER initial fluid bolus + K replete (no bolus needed); lower insulin rate than DKA; (3) Slow glucose correction — 50-75 mg/dL/hr to avoid cerebral edema (greater risk than DKA); (4) Slow Na correction — change < 10 mEq/L per 24 hr to prevent osmotic demyelination; (5) Replace K (target 4-5); (6) Identify precipitant: infection (most common — URI here, UTI, pneumonia), missed/inadequate insulin, new T2DM presentation, MI, stroke, drugs (steroid, diuretic, atypical antipsychotic); (7) VTE prophylaxis (HHS = hypercoagulable); (8) Mortality HHS > DKA (5-20%) — slower, sicker, older, comorbid; ICU admission

---

Hyperosmolar Hyperglycemic State (HHS, formerly HHNK) — diabetic emergency distinct from DKA. ADA 2024 + ADA Hyperglycemic Crises Consensus 2024: (1) Diagnostic criteria HHS: glucose > 600 mg/dL, effective serum osmolality > 320 mOsm/kg (calc: 2×Na + glucose/18 + BUN/2.8), pH > 7.3, HCO3 > 18, minimal/no ketosis, AG ≤ 12, altered mental status. (2) Pathophysiology: T2DM elderly; residual insulin secretion prevents lipolysis/ketosis but insufficient for glucose uptake; profound dehydration from osmotic diuresis (deficit 8-12 L). (3) Treatment differs from DKA — FLUID is primary, insulin secondary: - Fluid: NSS 1-1.5 L over 1 hr → 250-500 mL/hr; switch to ½NS when corrected serum Na ≥ 135. - K: replete if K < 5.3 (give 20-30 mEq/L of fluid); hold insulin if K < 3.3 until K replete. - Insulin: 0.05-0.1 U/kg/hr (lower than DKA) AFTER fluid initiated; NO bolus. - Glucose drop target 50-75 mg/dL/hr (slower than DKA); add D5W when glucose 250-300 + continue insulin. - Na: slow correction < 10 mEq/L per 24 hr; risk osmotic demyelination if too fast. (4) Precipitants: infection (most common — UTI, pneumonia, URI), missed meds, MI, stroke, new T2DM, steroids, atypical antipsychotics. (5) Complications: cerebral edema (esp pediatric, faster fluid → higher risk), thromboembolism (hypercoagulable — VTE prophylaxis), AKI, ARDS. (6) Mortality 5-20% (higher than DKA''s 1-5%) — older, sicker, more comorbidity. (7) ICU monitoring. (8) Resolution: osmolality normalized, glucose < 250, mental status improved → transition to SC insulin. A ผิด — not DKA (no ketosis, normal AG, normal pH). C ผิด — insulin before fluid → cardiovascular collapse + worsened cellular dehydration. D ผิด — emergency. E ผิด — rapid correction → cerebral edema.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'internal_medicine', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'ADA Hyperglycemic Crises Consensus Report 2024; ADA Standards of Care 2024; UK Joint British Diabetes Society HHS Guideline 2022', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 68 ปี underlying T2DM, HT มา ED ด้วยอาการสับสน + อ่อนเพลีย + ปัสสาวะเยอะ + กระหายน้ำมาก 4 วัน หลังจากเริ่มมี viral URI 1 สัปดาห์ก่อน ไม่กินอาหารและน้ำตามปกติ

V/S: BP 96/58, HR 124, RR 20, SpO2 97%, Temp 37.4°C, น้ำหนัก 68 kg
PE: dry mucous membrane, sunken eyes, lethargic, GCS 13, no Kussmaul breathing

Lab: Glucose 968 mg/dL, Na 138 (corrected 156 — Adj +1.6 per 100 above 100), K 4.8, Cl 110, HCO3 22, BUN 76, Cr 2.8, Anion gap 12 (NORMAL), Ketones beta-hydroxybutyrate 0.4 (minimal), Osm 392 mOsm/kg, Lactate 1.4, Albumin 3.4
Urinalysis: ketones trace (mild), glucose 4+
ABG: pH 7.34, PaCO2 38, HCO3 22'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 65 ปี underlying hypothyroidism (สรุปไม่ได้กิน levothyroxine 6 เดือน), found unresponsive ที่บ้านในเช้าที่อากาศหนาว (ฤดูหนาวภาคเหนือ)

V/S: BP 84/52, HR 42, RR 8 shallow, SpO2 92% RA, Temp 32.2°C (hypothermia), Glucose 58
PE: lethargic GCS 8, pale puffy face, dry coarse skin, hyporeflexia, periorbital edema, no goiter, no neck scar (no prior thyroidectomy)

Lab: Na 124, K 4.8, Glucose 58, Cr 1.4, CK 1,820 (mild), TSH > 100 (very high), Free T4 0.2 (very low), Cortisol AM 6 (suboptimal), ACTH 28
ABG: pH 7.30, PaCO2 60, PaO2 64, HCO3 28
CXR: small heart, pleural effusion bilateral mild
EKG: sinus bradycardia 42, low voltage, prolonged QT', '[{"label":"A","text":"Oral levothyroxine 100 mcg/d outpatient"},{"label":"B","text":"Myxedema coma (decompensated severe hypothyroidism)"},{"label":"C","text":"Active rewarming with hot blankets + warmed IV fluid only"},{"label":"D","text":"Withhold steroid until cortisol confirmed"},{"label":"E","text":"T3 alone without T4"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Myxedema coma (decompensated severe hypothyroidism) — Endocrinology emergency: (1) IV T4 (levothyroxine) 200-500 mcg loading dose then 50-100 mcg/d (slow conversion to T3); IV T3 (liothyronine) 5-20 mcg loading then 2.5-10 mcg q8h CONCURRENTLY (faster onset; cardiac caution in elderly/CAD); (2) IV hydrocortisone 100 mg q8h (concurrent adrenal insufficiency common — give before T4 to prevent precipitating adrenal crisis from increased cortisol clearance); (3) Passive rewarming (active aggressive rewarming causes vasodilation + hypotension); (4) Supportive ventilation (CO2 retention from hypothyroid respiratory depression — mechanical ventilation often needed); (5) Hypotonic saline (D5W or D5½NS) cautious for hyponatremia + glucose support; (6) Identify precipitant (infection, cold, MI, sedative/opioid use, surgery, non-adherence); empirical antibiotics if infection suspected; (7) Avoid sedatives (cleared slowly); (8) ICU admission; mortality 20-40% despite treatment

---

Myxedema coma — decompensated severe hypothyroidism. Mortality 20-40%. Classic features: AMS/coma, hypothermia, hypoventilation, hyponatremia, hypoglycemia, bradycardia, hypotension. Often elderly female with chronic hypothyroidism precipitated by cold, infection, drugs (sedative, opioid, amiodarone), MI, surgery, non-adherence. ATA + Endocrine Society guideline: (1) Thyroid hormone replacement (regimens vary; controversial T4 alone vs T4+T3): - IV T4 (levothyroxine): 200-500 mcg loading bolus then 50-100 mcg/d; slow onset (1-3 d). - IV T3 (liothyronine): 5-20 mcg loading then 2.5-10 mcg q8h; faster onset (hours); cardiac risk (arrhythmia, MI in elderly/CAD); some advocate combination for severe coma. - Oral inadequate due to absorption issues. (2) Hydrocortisone 100 mg IV q8h BEFORE or with thyroid hormone — concurrent adrenal insufficiency common (primary or secondary); thyroid replacement can precipitate adrenal crisis by ↑ cortisol clearance. (3) Passive rewarming (warm blankets, room temp); avoid active aggressive rewarming (vasodilation → shock). (4) Supportive: - Ventilation: often need intubation for hypercapnic respiratory failure (decreased respiratory drive + edema + obesity hypoventilation). - Hyponatremia: hypertonic saline only if severe symptomatic; usually fluid restriction + slow correction; SIADH-like picture. - Hypoglycemia: D10 IV. - Hypotension: cautious fluid; pressor if persistent. (5) Identify precipitant: infection, MI, cold, drugs (amiodarone, lithium), trauma. (6) Empirical antibiotics if infection suspected. (7) Avoid sedatives (decreased clearance). (8) ICU monitoring. (9) Watch for atrial fibrillation, MI during T4 replacement. A ผิด — too slow, can''t absorb. C ผิด — aggressive rewarming = shock. D ผิด — give steroid empirically. E ผิด — T4 backbone with T3 supplement.', NULL,
  'hard', 'endocrine_metabolic', 'review',
  'internal_medicine', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'ATA Guidelines for Hypothyroidism in Adults 2014; Endocrine Society — Myxedema Coma; Wartofsky L — Myxedema Coma Endocrinol Metab Clin North Am 2006', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 65 ปี underlying hypothyroidism (สรุปไม่ได้กิน levothyroxine 6 เดือน), found unresponsive ที่บ้านในเช้าที่อากาศหนาว (ฤดูหนาวภาคเหนือ)

V/S: BP 84/52, HR 42, RR 8 shallow, SpO2 92% RA, Temp 32.2°C (hypothermia), Glucose 58
PE: lethargic GCS 8, pale puffy face, dry coarse skin, hyporeflexia, periorbital edema, no goiter, no neck scar (no prior thyroidectomy)

Lab: Na 124, K 4.8, Glucose 58, Cr 1.4, CK 1,820 (mild), TSH > 100 (very high), Free T4 0.2 (very low), Cortisol AM 6 (suboptimal), ACTH 28
ABG: pH 7.30, PaCO2 60, PaO2 64, HCO3 28
CXR: small heart, pleural effusion bilateral mild
EKG: sinus bradycardia 42, low voltage, prolonged QT'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 45 ปี HIV-positive baseline (recently diagnosed, CD4 12 cells/μL, VL 480,000), ไม่เคย ART มา OPD เพื่อ start ART พบ:

No current opportunistic infection clinically (no cough, no fever, no headache)
CBC: Hb 11.4, WBC 4,800, Plt 188,000
CD4 12, VL 480,000
HIV genotype: no resistance mutations
HBsAg negative, Anti-HBs positive (vaccinated), Anti-HCV negative
Cryptococcal antigen serum: negative
TB symptom screen: negative, CXR clear, IGRA negative
Toxoplasma serology IgG positive
Urinalysis normal, eGFR 105, glucose 92, HbA1c 5.4%, lipid panel normal
No significant other comorbid', '[{"label":"A","text":"Wait until CD4 > 200 to start ART"},{"label":"B","text":"Newly diagnosed HIV with severe immunosuppression CD4 < 50"},{"label":"C","text":"Two-drug ART only"},{"label":"D","text":"Defer ART until baseline opportunistic infections fully treated"},{"label":"E","text":"Start ART + initiate isoniazid preventive therapy without TB screening"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Newly diagnosed HIV with severe immunosuppression CD4 < 50 — Start ART promptly (rapid initiation within days per WHO + DHHS), preferred regimen: Bictegravir/tenofovir alafenamide/emtricitabine (B/F/TAF — single tablet, high barrier, well-tolerated, no boost) OR Dolutegravir + TDF/FTC (TLD) or TAF/FTC — Thailand National AIDS Program TLD frontline; concomitantly: opportunistic infection prophylaxis — TMP-SMX 1 DS daily (PCP + toxoplasmosis prevention since toxo IgG+ + CD4 < 100); azithromycin 1200 mg weekly for MAC prevention (consider — most providers focus on ART-driven immune recovery); fluconazole 200 mg/d in regions with high cryptococcal burden when CrAg negative is sometimes used though not standard; vaccinate (pneumococcal PCV20, hepatitis B series booster, influenza, COVID, HPV, Tdap); counsel re ART adherence + safer sex + disclosure + partner testing/treatment + PrEP for partner; monitor for IRIS (immune reconstitution inflammatory syndrome — particularly TB and cryptococcal); ART adherence (target VL undetectable < 50 in 6 mo); social work + mental health

---

Newly diagnosed HIV — rapid ART initiation. WHO 2023 + DHHS 2024 + Thai National AIDS Program: (1) Start ART regardless of CD4 — earlier is better (START, TEMPRANO trials). Rapid initiation (same-day or within 7 d) reduces mortality, improves retention. (2) Preferred 1st-line regimens (DHHS): - Bictegravir/TAF/FTC (B/F/TAF, Biktarvy) — single-tablet INSTI, high barrier. - Dolutegravir (DTG) + TAF/FTC or TDF/FTC (TLD in Thai NAP). - DTG/3TC dual: in select stable patients (no HBV, baseline VL < 500K). (3) Avoid efavirenz first-line now (CNS side effects, lower barrier) — but still in resource-limited settings. (4) Opportunistic infection prophylaxis: - CD4 < 200: TMP-SMX (PCP). - CD4 < 100 + toxo IgG+: TMP-SMX (also covers toxo). - CD4 < 50: MAC prophylaxis with azithromycin 1200 mg weekly — though some recent guidelines suggest dropping if rapid ART initiation. - Fluconazole prophylaxis for cryptococcus in high-burden regions (CrAg screening then preemptive). - Routine TB symptom screen + IGRA/TST + CXR; IPT (isoniazid preventive therapy) 6 mo or 3HP if TB ruled out. (5) Vaccinations (avoid live until CD4 > 200): pneumococcal PCV20, HepB, influenza, COVID, HPV up to 45 yr, Tdap. (6) IRIS — paradoxical worsening of underlying infection within weeks of ART; commonly TB (5-25%), cryptococcal, CMV, MAC; manage continuing ART + treating underlying + steroid in severe (TB IRIS). (7) Counseling: adherence, U=U (undetectable=untransmittable), partner notification, PrEP for partners. (8) Monitor: VL at 4-8 wk, 3, 6 mo then q6-12 mo; CD4 q6 mo until > 350 then less; routine labs. A ผิด — START/TEMPRANO showed early ART benefit at all CD4. C ผิด — dual regimens select cases only. D ผิด — concurrent ART + OI treatment (with timing per OI). E ผิด — must screen TB before IPT.', NULL,
  'medium', 'id', 'review',
  'internal_medicine', 'clinical_decision', 'id', 'adult',
  'WHO Consolidated Guidelines on HIV 2023; DHHS Adult/Adolescent ARV Guideline 2024; Thailand National HIV Treatment Guideline 2022; START Trial NEJM 2015', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 45 ปี HIV-positive baseline (recently diagnosed, CD4 12 cells/μL, VL 480,000), ไม่เคย ART มา OPD เพื่อ start ART พบ:

No current opportunistic infection clinically (no cough, no fever, no headache)
CBC: Hb 11.4, WBC 4,800, Plt 188,000
CD4 12, VL 480,000
HIV genotype: no resistance mutations
HBsAg negative, Anti-HBs positive (vaccinated), Anti-HCV negative
Cryptococcal antigen serum: negative
TB symptom screen: negative, CXR clear, IGRA negative
Toxoplasma serology IgG positive
Urinalysis normal, eGFR 105, glucose 92, HbA1c 5.4%, lipid panel normal
No significant other comorbid'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 28 ปี ไม่มีโรคประจำตัว มาด้วยอาการเหนื่อยเพลีย ผิวเหลือง 2 สัปดาห์ หลังกินยาแก้ปวดประจำเดือน + Chinese herbal medicine มา 3 สัปดาห์

V/S: BP 118/72, HR 88, RR 16, Temp 37.0°C
PE: jaundice + scleral icterus, hepatomegaly mild tender, no asterixis, no encephalopathy

Lab: AST 1,580, ALT 2,420 (very high — hepatocellular pattern, R-ratio > 5), ALP 142, GGT 95, Bilirubin total 6.8 (direct 4.2), Albumin 3.4, INR 1.4 (mild prolongation), Cr 0.8
Anti-HAV IgM negative, HBsAg negative, anti-HBc IgM negative, anti-HCV negative, HCV RNA negative, anti-HEV IgM negative
ANA negative, anti-SMA negative, IgG normal, ceruloplasmin 32 (normal), iron studies normal
US abdomen: hepatomegaly, normal echotexture, no biliary obstruction, no mass
RUCAM score (Roussel Uclaf Causality Assessment): 7 (probable DILI)', '[{"label":"A","text":"IV vitamin K + observation only"},{"label":"B","text":"Drug-induced liver injury (DILI)"},{"label":"C","text":"Empirical corticosteroid pulse therapy"},{"label":"D","text":"Continue herbal medicine + tincture"},{"label":"E","text":"Antiviral therapy empirical"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Drug-induced liver injury (DILI) — likely from herbal supplement (Chinese herbs common cause in Asia — Polygonum, Bai Xian Pi, Ji Gu Cao, Sho-saiko-to, Atractylodes, etc.) ± analgesic: (1) Immediate withdrawal of all suspected hepatotoxic drugs/herbs (rechallenge contraindicated); (2) Supportive: maintain hydration, monitor LFT + INR daily initially; (3) Assess severity using Hy''s law (jaundice + 3× ULN ALT + bilirubin > 2× ULN without alternative cause = mortality risk 10-50%); (4) NAC (N-acetylcysteine) IV considered for early non-acetaminophen DILI with coagulopathy (Lee NEJM 2009 — modest mortality benefit pre-encephalopathy); (5) Glucocorticoid for hypersensitivity DILI with eosinophilia or autoimmune-like features (controversial); (6) Monitor for acute liver failure (ALF) — King''s College criteria for transplant referral (non-acetaminophen: pH < 7.3, OR INR > 6.5 + Cr > 3.4 + grade III/IV encephalopathy, OR 3 of 5 criteria); urgent referral to transplant center if INR > 1.5 + any encephalopathy; (7) RUCAM scoring + comprehensive ddx (viral hepatitis, autoimmune, Wilson, ischemic, biliary); (8) DILI registry reporting; patient counseling herbal/OTC labeling

---

Drug-induced liver injury (DILI) — hepatocellular pattern (R-ratio = (ALT/ULN)/(ALP/ULN) > 5). Asia: herbal/dietary supplements major cause (Korean DILIN: 27%; Chinese: many; US DILIN: 16%). AASLD 2014 + EASL 2019 + ACG 2021 DILI guideline: (1) Diagnosis = exclusion + temporal relationship; RUCAM score (5-8 probable, ≥ 9 highly probable). (2) Causes: APAP (predictable, dose-dependent), antibiotics (amox-clav, isoniazid, nitrofurantoin), antiepileptic (phenytoin, carbamazepine, valproate), statin (rare), methotrexate, herbal/supplement (Hydroxycut, Herbalife, Chinese herbs, kava), checkpoint inhibitor (ipi/nivo). (3) Management — discontinuation cornerstone: - Stop offending agent immediately; do not rechallenge (mortality on rechallenge much higher). - Supportive monitoring. - NAC IV 150 mg/kg over 1 hr, then 12.5 mg/kg/hr × 4 hr, then 6.25 mg/kg/hr × 16 hr — Lee NEJM 2009 showed transplant-free survival benefit in non-APAP early ALF (coma grade I-II); not routinely for early DILI without ALF. - Corticosteroid: only if hypersensitivity (DRESS), autoimmune-like features (SMA, ANA, eos, IgG ↑), some immune checkpoint inhibitor hepatitis. - L-ornithine-L-aspartate, lactulose if hepatic encephalopathy. (4) Hy''s law: jaundice + ALT > 3× + Bili > 2× (no obstruction/hemolysis/Gilbert) → ~10-50% mortality without transplant. (5) Acute liver failure (ALF) — coagulopathy (INR > 1.5) + encephalopathy in previously healthy liver < 26 wk: - Transfer to transplant center URGENT. - King''s College Criteria for transplantation. - MARS (artificial liver support) — bridge. (6) Reporting: LiverTox database, DILIN, national pharmacovigilance. (7) Patient education: avoid hepatotoxic OTC/herbals; rechallenge contraindicated. A ผิด — VitK alone inadequate. C ผิด — steroid not routine. D ผิด — perpetuates injury. E ผิด — viral panel negative.', NULL,
  'medium', 'gi', 'review',
  'internal_medicine', 'clinical_decision', 'gi', 'adult',
  'AASLD Guidance on DILI 2014; EASL Clinical Practice Guidelines: DILI 2019; ACG Guideline on Idiosyncratic DILI 2021; Lee WM et al. NEJM 2009 (NAC in non-APAP ALF)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 28 ปี ไม่มีโรคประจำตัว มาด้วยอาการเหนื่อยเพลีย ผิวเหลือง 2 สัปดาห์ หลังกินยาแก้ปวดประจำเดือน + Chinese herbal medicine มา 3 สัปดาห์

V/S: BP 118/72, HR 88, RR 16, Temp 37.0°C
PE: jaundice + scleral icterus, hepatomegaly mild tender, no asterixis, no encephalopathy

Lab: AST 1,580, ALT 2,420 (very high — hepatocellular pattern, R-ratio > 5), ALP 142, GGT 95, Bilirubin total 6.8 (direct 4.2), Albumin 3.4, INR 1.4 (mild prolongation), Cr 0.8
Anti-HAV IgM negative, HBsAg negative, anti-HBc IgM negative, anti-HCV negative, HCV RNA negative, anti-HEV IgM negative
ANA negative, anti-SMA negative, IgG normal, ceruloplasmin 32 (normal), iron studies normal
US abdomen: hepatomegaly, normal echotexture, no biliary obstruction, no mass
RUCAM score (Roussel Uclaf Causality Assessment): 7 (probable DILI)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 58 ปี underlying alcoholic cirrhosis Child-Pugh B, ascites known with chronic diuretics, MELD 16 มา ED ด้วยไข้ + ปวดท้องทั่วไป + abdominal tenderness + worsening ascites 3 วัน

V/S: BP 102/64, HR 104, RR 20, SpO2 96%, Temp 38.4°C
PE: jaundice, distended abdomen + shifting dullness, diffuse mild tender, no rebound, no rigidity, normal bowel sounds, no asterixis, GCS 15, no encephalopathy

Lab: WBC 12,400, Hb 10.2, Plt 88,000, Cr 1.4 (baseline 1.0), Bili 4.2, INR 1.6, Albumin 2.4, Na 130, K 4.0
Diagnostic paracentesis: WBC 580 cells/μL with PMN 420 cells/μL (> 250 = SBP), ascitic albumin 0.8 (SAAG = 1.6 = portal hypertension), Gram stain negative, culture pending, glucose 88 (similar to serum), LDH 180, total protein 1.2
No recent antibiotics, no surgery, no abdominal pain pattern peritonitis-like', '[{"label":"A","text":"Oral ciprofloxacin outpatient × 7 d"},{"label":"B","text":"Spontaneous Bacterial Peritonitis (SBP)"},{"label":"C","text":"Vancomycin IV monotherapy"},{"label":"D","text":"Surgical laparotomy for source control"},{"label":"E","text":"Symptomatic management only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Spontaneous Bacterial Peritonitis (SBP) — ascitic fluid PMN > 250/μL = diagnostic; (1) Empirical IV ceftriaxone 2 g/d × 5 d (first-line; covers usual gut translocation organisms — E. coli, K. pneumoniae, S. pneumoniae); avoid aminoglycoside (renal toxicity in cirrhosis); piperacillin-tazobactam if recent abx exposure, nosocomial, severe sepsis (resistance concern); (2) IV albumin 1.5 g/kg on day 1 + 1 g/kg on day 3 — reduces hepatorenal syndrome + mortality (Sort NEJM 1999 — particularly if Bili > 4 or Cr > 1); (3) HOLD non-selective beta-blocker temporarily if hypotensive or AKI (NSBB safe in stable cirrhosis with SBP but stop if shock); (4) Hold diuretic temporarily during AKI; (5) After resolution: secondary prophylaxis lifelong with norfloxacin 400 mg/d (or TMP-SMX, ciprofloxacin) — reduces recurrence + improves survival; (6) Primary prophylaxis indications: variceal hemorrhage (norfloxacin × 7 d) or low ascitic protein (< 1.5) + advanced cirrhosis (Bili > 3, Cr > 1.2, Na < 130) + Child-Pugh ≥ 9; (7) Liver transplant evaluation (SBP marker of decompensation, 1-yr survival 30-50%)

---

Spontaneous bacterial peritonitis (SBP). AASLD 2021 + EASL 2018 + Thai Hep Soc guideline: (1) Diagnostic paracentesis MANDATORY in any cirrhotic ascitic patient with fever, abdominal pain, encephalopathy, sepsis, AKI, GI bleed. (2) Diagnosis: ascitic fluid PMN > 250/μL (regardless of culture). - Culture-negative neutrocytic ascites = SBP variant — treat. - Monomicrobial non-neutrocytic bacterascites (positive culture, PMN < 250) — repeat tap; treat if symptomatic or persistent. - Secondary bacterial peritonitis (perforation): polymicrobial, protein > 1, glucose < 50, LDH > serum, Runyon criteria, ascitic CEA > 5 — surgical. (3) Empirical antibiotics: - Community-acquired: IV ceftriaxone 2 g/d × 5 d (covers E. coli, Klebsiella, pneumococcus). - Nosocomial / recent broad-spectrum exposure: pip-tazo, carbapenem (rising MDR). (4) Albumin 1.5 g/kg day 1 + 1 g/kg day 3 — Sort NEJM 1999: reduces HRS-AKI + mortality, especially if Cr > 1 or Bili > 4. (5) Repeat paracentesis at 48 hr to confirm > 25% PMN decrease — if not, broaden antibiotics, consider secondary peritonitis. (6) Hold/reduce NSBB if hypotension/AKI; restart when stable. (7) Hold diuretic during AKI; assess HRS criteria (cirrhotic + AKI + no improvement after 48 hr withdrawal + albumin challenge + no shock/nephrotoxin/structural). (8) HRS treatment: terlipressin + albumin (CONFIRM), norepi alternative. (9) Secondary prophylaxis after SBP: norfloxacin 400 mg/d lifelong (or other FQ, TMP-SMX); reduces recurrence + mortality. (10) Primary prophylaxis: GI bleeding + cirrhosis; low ascitic protein + high MELD. (11) Liver transplant evaluation (SBP = significant decompensation). A ผิด — IV broad first. C ผิด — vanco gram-negative inadequate. D ผิด — SBP not surgical. E ผิด — untreated mortality high.', NULL,
  'medium', 'gi', 'review',
  'internal_medicine', 'clinical_decision', 'gi', 'adult',
  'AASLD Practice Guidance: Diagnosis, Evaluation and Management of Ascites, SBP, HRS 2021; EASL Clinical Practice Guidelines on Decompensated Cirrhosis 2018; Sort P et al. NEJM 1999 (Albumin in SBP)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 58 ปี underlying alcoholic cirrhosis Child-Pugh B, ascites known with chronic diuretics, MELD 16 มา ED ด้วยไข้ + ปวดท้องทั่วไป + abdominal tenderness + worsening ascites 3 วัน

V/S: BP 102/64, HR 104, RR 20, SpO2 96%, Temp 38.4°C
PE: jaundice, distended abdomen + shifting dullness, diffuse mild tender, no rebound, no rigidity, normal bowel sounds, no asterixis, GCS 15, no encephalopathy

Lab: WBC 12,400, Hb 10.2, Plt 88,000, Cr 1.4 (baseline 1.0), Bili 4.2, INR 1.6, Albumin 2.4, Na 130, K 4.0
Diagnostic paracentesis: WBC 580 cells/μL with PMN 420 cells/μL (> 250 = SBP), ascitic albumin 0.8 (SAAG = 1.6 = portal hypertension), Gram stain negative, culture pending, glucose 88 (similar to serum), LDH 180, total protein 1.2
No recent antibiotics, no surgery, no abdominal pain pattern peritonitis-like'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 38 ปี ไม่มีโรคประจำตัว มาด้วยปวดท้องล่างขวา + เลือดออกทางทวารหนัก 6 เดือน + น้ำหนักลด 6 kg + ไข้ต่ำ + ปวดข้อ + แผลในปาก aphthous + perianal fistula

Lab: Hb 10.4, MCV 80, WBC 9,200, Plt 412,000, ESR 56, CRP 28, Albumin 3.0, fecal calprotectin 720 (high)
Colonoscopy: skip lesion pattern, deep linear ulcers + cobblestone in terminal ileum + ascending colon, normal rectum (rectal sparing), perianal fistula confirmed; biopsy = non-caseating granuloma, transmural inflammation
MRI enterography: terminal ileum 12 cm involvement + complex perianal fistula + small abscess perianal
No intra-abdominal abscess, no obstruction
Stool culture: negative
TB workup: IGRA negative, CXR clear
HBV/HCV/HIV: negative', '[{"label":"A","text":"Surgical bowel resection ทันทีเป็น first-line"},{"label":"B","text":"Crohn disease, moderate-severe ileocolonic + perianal fistula"},{"label":"C","text":"5-ASA monotherapy"},{"label":"D","text":"Antibiotic alone (metronidazole) long-term"},{"label":"E","text":"Watchful waiting until obstruction develops"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Crohn disease, moderate-severe ileocolonic + perianal fistula — Multidisciplinary approach: (1) Acute symptom control: prednisolone 40-60 mg/d taper or budesonide 9 mg/d (ileal release for ileal-Right colon — less systemic SE); (2) Address perianal abscess first: surgical drainage + seton placement (before immunosuppression to prevent worsening sepsis); (3) Induction + maintenance with biologic — anti-TNF (infliximab 5 mg/kg IV at 0, 2, 6 wk then q8wk OR adalimumab) — especially effective for fistulizing Crohn (ACCENT II); top-down strategy preferred over step-up in high-risk (young, deep ulcer, extensive, perianal, fistulizing) — REACT, RISK; (4) Combine with immunomodulator (azathioprine, methotrexate) — SONIC superior outcome combo > monotherapy; (5) Alternative biologics: ustekinumab (UNITI), vedolizumab (gut-selective, less efficacious in fistula), risankizumab; (6) Antibiotic ciprofloxacin + metronidazole for perianal disease adjunct; (7) Nutritional optimization (enteral nutrition in select cases); (8) Smoking cessation (worsens CD); (9) Vaccines (live attenuated avoid post-biologic); (10) CRC + small bowel surveillance; (11) Bone health, mood support

---

Crohn disease, moderate-severe, ileocolonic, fistulizing/perianal. Key features distinguishing from UC: skip lesions, transmural, granuloma, terminal ileum, perianal disease, fistula, oral aphthae, extraintestinal manifestations more common. ACG 2018 + AGA 2021 + ECCO 2020 Crohn guideline: (1) Severity assessment: CDAI, Harvey-Bradshaw, biomarkers, imaging extent. (2) Goals: clinical remission, mucosal healing (deep remission), prevent complications + surgery. (3) Initial: - Mild ileal: budesonide 9 mg/d × 8 wk. - Moderate-severe: systemic glucocorticoid (prednisolone 40 mg/d) taper. - Risk-stratify: young age, deep ulcer, extensive, perianal, fistula = high-risk → top-down biologic. (4) Biologic therapy: - Anti-TNF (infliximab, adalimumab) — most studied; ACCENT II for fistula. - Ustekinumab (anti-IL-12/23). - Vedolizumab (anti-α4β7 integrin, gut-selective). - Risankizumab, upadacitinib (newer). (5) Combination therapy: anti-TNF + immunomodulator (AZA, MTX) — SONIC trial: combo > monotherapy in steroid-free remission. (6) Perianal disease: - Examination under anesthesia (EUA) + MRI pelvis. - Abscess drainage + seton (essential before/concurrent with biologic). - Antibiotic (ciprofloxacin + metronidazole) adjunct. - Anti-TNF for fistula. (7) Surgery: for stricture (resection or strictureplasty), abscess, perforation, refractory disease; recurrence common at anastomosis. (8) Smoking cessation — major modifiable factor in CD. (9) Vaccines pre-immunosuppression (live attenuated); routine annual flu, pneumococcal, HBV. (10) Surveillance colonoscopy 8 yr from diagnosis. (11) Nutrition, bone, pregnancy, vaccination, malignancy surveillance. A ผิด — surgery not first-line. C ผิด — 5-ASA limited efficacy in CD. D ผิด — antibiotic alone inadequate moderate-severe. E ผิด — wait → complications.', NULL,
  'medium', 'gi', 'review',
  'internal_medicine', 'clinical_decision', 'gi', 'adult',
  'ACG Clinical Guideline: Management of Crohn Disease 2018; AGA Guideline on Moderate-Severe CD 2021; ECCO Guideline on Therapeutics in CD 2020; SONIC NEJM 2010; ACCENT II NEJM 2004', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 38 ปี ไม่มีโรคประจำตัว มาด้วยปวดท้องล่างขวา + เลือดออกทางทวารหนัก 6 เดือน + น้ำหนักลด 6 kg + ไข้ต่ำ + ปวดข้อ + แผลในปาก aphthous + perianal fistula

Lab: Hb 10.4, MCV 80, WBC 9,200, Plt 412,000, ESR 56, CRP 28, Albumin 3.0, fecal calprotectin 720 (high)
Colonoscopy: skip lesion pattern, deep linear ulcers + cobblestone in terminal ileum + ascending colon, normal rectum (rectal sparing), perianal fistula confirmed; biopsy = non-caseating granuloma, transmural inflammation
MRI enterography: terminal ileum 12 cm involvement + complex perianal fistula + small abscess perianal
No intra-abdominal abscess, no obstruction
Stool culture: negative
TB workup: IGRA negative, CXR clear
HBV/HCV/HIV: negative'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 32 ปี ไม่มีโรคประจำตัวเดิม มาด้วย microangiopathic hemolytic anemia + thrombocytopenia + AKI + fluctuating neuro symptoms (confusion → headache → mild aphasia ↔ recovery) + ไข้ low-grade × 5 วัน

V/S: BP 142/88, HR 102, RR 18, SpO2 97%, Temp 37.8°C, GCS variable 13-15
PE: petechiae diffuse, scleral icterus, no rash, no lymphadenopathy, no organomegaly

Lab: Hb 7.2 (rapid drop, baseline 12), MCV 88, Schistocytes 8% on peripheral smear, Plt 18,000, WBC 9,200
LDH 2,440, indirect bilirubin 4.6, haptoglobin < 10 (consumed)
Reticulocyte 8%, DAT/Coombs negative (non-immune hemolysis)
Cr 2.4 (baseline 0.8), UA: protein 2+, blood 2+, no RBC casts
PT/aPTT/Fibrinogen normal (rules out DIC), D-dimer mildly elevated
ADAMTS13 activity < 5% (severely decreased) + ADAMTS13 inhibitor positive → confirms TTP
E. coli O157:H7 negative, no diarrhea (rules out HUS)', '[{"label":"A","text":"Platelet transfusion to raise Plt > 50,000"},{"label":"B","text":"Acquired Thrombotic Thrombocytopenic Purpura (acquired TTP"},{"label":"C","text":"Platelet + plasma transfusion + supportive only"},{"label":"D","text":"Heparin anticoagulation for microthrombi"},{"label":"E","text":"Defer TPE until next morning per hematology consult"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acquired Thrombotic Thrombocytopenic Purpura (acquired TTP — autoimmune ADAMTS13 inhibitor) — Emergent treatment: (1) Therapeutic plasma exchange (TPE) DAILY starting within hours of diagnosis — replace ADAMTS13 + remove inhibitor + remove vWF multimers; continue until Plt > 150K × 2 d + LDH normalized; (2) Corticosteroid (methylprednisolone 1 g/d × 3 d or prednisolone 1 mg/kg/d) — immunosuppression of antibody; (3) Caplacizumab (anti-vWF nanobody) — accelerates platelet recovery, reduces exacerbation/refractory disease (HERCULES NEJM 2019); standard now in many centers; (4) Rituximab — anti-CD20 (frontline option per ISTH 2020; reduces refractoriness + relapse, lower TPE sessions); (5) AVOID prophylactic platelet transfusion (worsens thrombosis — fatal!) — only if life-threatening bleed or pre-procedure; (6) AVOID antiplatelet/anticoagulant unless specific indication; (7) Treat precipitant (infection, drugs, pregnancy, malignancy, HIV) if identified; (8) Monitor for relapse — Q4-12 wk ADAMTS13 level; relapse rate 30-50%; rituximab can prevent

---

Thrombotic thrombocytopenic purpura (TTP) — classic pentad (now diagnostic = first 2): microangiopathic hemolytic anemia (MAHA) + thrombocytopenia + fever + neuro + renal; ADAMTS13 < 10% confirms TTP. ISTH 2020 + ASH 2020 + ITP/TTP guideline: (1) Diagnosis: PLASMIC score ≥ 5 (creatinine < 2, INR < 1.5, MCV < 90, Plt < 30, no transplant, no cancer, hemolysis) — high probability TTP. ADAMTS13 < 10% confirms (most labs report). Anti-ADAMTS13 IgG distinguishes acquired (autoimmune) from congenital (cTTP/Upshaw-Schulman). (2) TREAT EMPIRICALLY before ADAMTS13 result — emergency, untreated mortality > 90%: - **Therapeutic plasma exchange (TPE)** daily within hours of diagnosis — replaces ADAMTS13 + removes inhibitor + vWF multimers; FFP if TPE delayed. - **Glucocorticoid**: methylprednisolone 1 g/d × 3 d, or prednisolone 1 mg/kg/d. - **Caplacizumab** (anti-vWF nanobody, Cablivi): HERCULES NEJM 2019 — accelerates platelet recovery, reduces refractoriness/exacerbation, prevents thrombotic events; ISTH 2020 recommends caplacizumab + TPE + steroid. - **Rituximab** 375 mg/m² × 4 weekly: frontline in some protocols; reduces refractoriness + relapse. (3) NO prophylactic platelet transfusion — controversial historical contraindication (fuel on fire) in TTP — case reports of catastrophic worsening; only for life-threatening bleed or pre-LP/central line. (4) AVOID anticoagulation/antiplatelet routinely. (5) Investigate precipitants: drugs (clopidogrel, ticlopidine, quinine, cyclosporine, gemcitabine, VEGF inhibitor), infection (HIV — test all TTP), pregnancy, malignancy, autoimmune. (6) Monitor: daily CBC, LDH, fibrinogen, ADAMTS13 (relapse prevention); platelet > 150K × 2 d + LDH normalized = remission, TPE can be tapered. (7) Long-term: ADAMTS13 monitoring Q3-12 mo; relapse 30-50% — preemptive rituximab in those with persistent ADAMTS13 < 10%. (8) Congenital TTP: regular plasma infusion or recombinant ADAMTS13 (recently approved adamzistron alfa). A ผิด — platelet transfusion harmful. C ผิด — TPE essential, not transfusion alone. D ผิด — anticoag worsens. E ผิด — TPE within hours, do NOT delay.', NULL,
  'hard', 'hemato_onco', 'review',
  'internal_medicine', 'clinical_decision', 'hemato_onco', 'adult',
  'ISTH Guidelines for the Diagnosis and Treatment of TTP 2020; ASH Guideline on Immune TTP 2020; HERCULES Caplacizumab Trial NEJM 2019', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 32 ปี ไม่มีโรคประจำตัวเดิม มาด้วย microangiopathic hemolytic anemia + thrombocytopenia + AKI + fluctuating neuro symptoms (confusion → headache → mild aphasia ↔ recovery) + ไข้ low-grade × 5 วัน

V/S: BP 142/88, HR 102, RR 18, SpO2 97%, Temp 37.8°C, GCS variable 13-15
PE: petechiae diffuse, scleral icterus, no rash, no lymphadenopathy, no organomegaly

Lab: Hb 7.2 (rapid drop, baseline 12), MCV 88, Schistocytes 8% on peripheral smear, Plt 18,000, WBC 9,200
LDH 2,440, indirect bilirubin 4.6, haptoglobin < 10 (consumed)
Reticulocyte 8%, DAT/Coombs negative (non-immune hemolysis)
Cr 2.4 (baseline 0.8), UA: protein 2+, blood 2+, no RBC casts
PT/aPTT/Fibrinogen normal (rules out DIC), D-dimer mildly elevated
ADAMTS13 activity < 5% (severely decreased) + ADAMTS13 inhibitor positive → confirms TTP
E. coli O157:H7 negative, no diarrhea (rules out HUS)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 28 ปี ไม่มีโรคประจำตัวเดิม ตั้งครรภ์ GA 32 weeks มาด้วย petechiae + epistaxis + เลือดออกตามเหงือก 2 สัปดาห์ ก่อนหน้านี้ healthy

V/S: BP 122/76, HR 88, RR 16, Temp 37.0°C
PE: extensive petechiae lower extremities + trunk, no purpura, no organomegaly, no lymphadenopathy, gravid uterus appropriate GA

Lab: Hb 11.2 (normal), MCV 88, WBC 7,400 (normal differential), Plt 8,000 (severe isolated thrombocytopenia), Reticulocyte 1.5%, smear: large platelets only (no schistocytes — rules out TTP/HUS/HELLP)
Coag: PT/aPTT/Fibrinogen normal (rules out DIC), D-dimer normal
LFT normal (rules out HELLP), Cr 0.6, UA normal
HIV negative, HCV negative, HBV negative
DAT (Coombs) negative
ANA negative
Bone marrow (deferred for now): would show normal/increased megakaryocytes if ITP
No bleeding currently active beyond petechiae + minor mucocutaneous', '[{"label":"A","text":"Splenectomy ทันที"},{"label":"B","text":"Pregnancy-associated severe Immune Thrombocytopenia (ITP)"},{"label":"C","text":"Platelet transfusion alone × 6 units to suppress"},{"label":"D","text":"Defer treatment until delivery"},{"label":"E","text":"Heparin anticoagulation for hypercoagulable"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pregnancy-associated severe Immune Thrombocytopenia (ITP) — must exclude pregnancy-specific causes (gestational thrombocytopenia: mild Plt > 70K third tri; preeclampsia/HELLP: HTN + AKI + LFT abnormal; TTP: MAHA + neuro + low ADAMTS13). Plt 8K with bleeding = severe ITP; treat: (1) First-line corticosteroid: prednisolone 1 mg/kg/d × 1-2 wk taper, or short pulse dexamethasone (40 mg × 4 d × 1-4 cycles per ASH 2019); IV methylprednisolone 1 g × 3 d if life-threatening; (2) IVIG 1 g/kg × 1-2 d — rapid (24-48 hr) platelet rise; preferred in pregnancy + emergency; (3) Pre-delivery target Plt > 30K (vaginal), > 50K (C-section), > 80K (neuraxial anesthesia); (4) Second-line in pregnancy: anti-D (Rh+ only), splenectomy 2nd trimester if refractory (delayed if possible); thrombopoietin receptor agonists (eltrombopag, romiplostim) — limited pregnancy safety data, case-by-case; (5) AVOID rituximab in 1st trimester (B-cell depletion neonate); cyclophosphamide teratogenic; (6) Coordination with OB + anesthesia for delivery planning; neonatal thrombocytopenia (10-25% via passive antibody) — neonatal CBC daily × 1 wk post-delivery; (7) Postpartum follow-up — relapse common as immune homeostasis shifts

---

Immune Thrombocytopenia (ITP) — isolated thrombocytopenia, diagnosis of exclusion (no clue to alternative cause + no other lineage involvement). ASH 2019 ITP guideline + Provan Blood Adv 2019: (1) Diagnosis: history, exam, CBC + smear (rule out pseudothrombocytopenia, MAHA), exclude drug-induced (heparin = HIT), infection (HIV, HCV, HBV, H. pylori, CMV), autoimmune (SLE → APS), lymphoma, splenic sequestration. Bone marrow only if atypical (older > 60 yr unclear etiology, refractory). (2) Treatment thresholds: - No bleed + Plt > 30K: observation (in adult, asymptomatic). - Bleed or Plt < 30K (some < 20K): treat. - Severe bleed: emergent treatment. (3) First-line corticosteroid options: - Prednisolone 1 mg/kg/d × 1-2 wk, taper. - Dexamethasone 40 mg × 4 d × 1-4 cycles per ASH (faster, less SE). - IV methylprednisolone 1 g × 3 d (life-threatening bleed). (4) IVIG 1 g/kg × 1-2 d — rapid (24-48 hr) platelet rise; preferred in pregnancy + emergency + need for rapid response. (5) Anti-D Ig 50-75 mcg/kg — Rh+ only, splenic-intact; risk of intravascular hemolysis. (6) Second-line: rituximab, TPO receptor agonists (eltrombopag, romiplostim, avatrombopag — durable response 60-80%), splenectomy (after 1 yr — accommodation), fostamatinib (SYK inhibitor). (7) Pregnancy-specific: - Differentiate gestational thrombocytopenia (mild, Plt > 70, late gestation, no Hx) vs ITP (severe < 100, any time, prior Hx). - Target Plt > 30K (vaginal delivery), > 50K (C-section), > 80K (neuraxial). - Steroid + IVIG safe in pregnancy. - Avoid rituximab early, cyclophosphamide. - TPO-RA limited data — case-by-case. - Neonatal: monitor CBC daily × 1 wk (Plt nadir day 2-5 from passive antibody); rarely severe but ICH risk. (8) Platelet transfusion: severe bleed only, not routine (consumed rapidly). A ผิด — splenectomy delay. C ผิด — transfusion not first; immune-mediated destruction. D ผิด — symptomatic + Plt < 10K + delivery soon = treat. E ผิด — heparin worsens bleeding, not indicated.', NULL,
  'medium', 'hemato_onco', 'review',
  'internal_medicine', 'clinical_decision', 'hemato_onco', 'adult',
  'ASH 2019 Guideline for the Management of ITP; International Consensus on ITP (Provan D et al. Blood Adv 2019); ACOG 207 (Thrombocytopenia in Pregnancy)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 28 ปี ไม่มีโรคประจำตัวเดิม ตั้งครรภ์ GA 32 weeks มาด้วย petechiae + epistaxis + เลือดออกตามเหงือก 2 สัปดาห์ ก่อนหน้านี้ healthy

V/S: BP 122/76, HR 88, RR 16, Temp 37.0°C
PE: extensive petechiae lower extremities + trunk, no purpura, no organomegaly, no lymphadenopathy, gravid uterus appropriate GA

Lab: Hb 11.2 (normal), MCV 88, WBC 7,400 (normal differential), Plt 8,000 (severe isolated thrombocytopenia), Reticulocyte 1.5%, smear: large platelets only (no schistocytes — rules out TTP/HUS/HELLP)
Coag: PT/aPTT/Fibrinogen normal (rules out DIC), D-dimer normal
LFT normal (rules out HELLP), Cr 0.6, UA normal
HIV negative, HCV negative, HBV negative
DAT (Coombs) negative
ANA negative
Bone marrow (deferred for now): would show normal/increased megakaryocytes if ITP
No bleeding currently active beyond petechiae + minor mucocutaneous'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 76 ปี underlying HT มา ED ด้วยเป็นลม syncope ขณะลุกขึ้นยืนจากเก้าอี้ ไม่มี aura, ไม่มี postictal, ไม่มี tongue bite, ไม่มี incontinence ฟื้นภายใน 1 นาที 4 ครั้งใน 3 เดือน

V/S supine: BP 142/82, HR 56; standing: BP 92/52, HR 58 (no compensatory rise = neurogenic orthostatic hypotension); RR 16, SpO2 98%
Medications: amlodipine, lisinopril, doxazosin, sertraline, tamsulosin (recent)
Neuro: mild gait instability, no focal deficits

Lab: CBC, electrolytes, Cr normal
EKG: sinus bradycardia 56, no AV block, no QT prolongation, no ischemic changes
Echo: LVEF 55%, no AS, no HCM
Tilt table: positive (BP drop without HR rise — neurogenic)', '[{"label":"A","text":"Pacemaker implantation ทันทีเป็น first-line"},{"label":"B","text":"Multifactorial syncope likely orthostatic + drug-induced + neurogenic (failure of HR compensation suggests autonomic dysfunction"},{"label":"C","text":"Continue all medications + observation"},{"label":"D","text":"EP study + ICD placement"},{"label":"E","text":"Beta-blocker to reduce reflex tachycardia"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Multifactorial syncope likely orthostatic + drug-induced + neurogenic (failure of HR compensation suggests autonomic dysfunction — possible Parkinsonism/MSA in elderly) — Approach: (1) Medication review — STOP/reduce: doxazosin + tamsulosin (alpha-blocker overlap), reduce sertraline if possible, separate antihypertensives; (2) Non-pharmacologic first: gradual postural change, leg crossing/squatting, compression stockings 20-30 mmHg, abdominal binder, fluid 2-2.5 L + Na liberal 6-10 g (if no HFrEF), elevate head of bed 10-20 degrees overnight (reduce supine hypertension paradox); (3) If inadequate — pharmacologic: fludrocortisone 0.1-0.3 mg/d (volume expansion; monitor K, edema, HF), midodrine 5-10 mg TID (alpha-agonist; avoid bedtime/supine HTN), droxidopa (norepinephrine prodrug), pyridostigmine; (4) Address co-morbidity: evaluate for autonomic disease (Parkinson, MSA, diabetic autonomic neuropathy, amyloid); (5) Falls prevention — PT, home safety; (6) Driving counseling; (7) Carotid sinus massage + tilt for diagnosis confirm

---

Orthostatic hypotension (sustained ≥ 20/10 drop within 3 min standing). Neurogenic OH = failure of expected HR rise (impaired sympathetic outflow) — suggests autonomic neuropathy or neurodegenerative (Parkinson, MSA, pure autonomic failure). ESC 2018 + AHA 2017 syncope + AAN OH guideline: (1) Classify syncope: reflex (vasovagal, situational, carotid sinus), orthostatic (volume, drug, neurogenic), cardiac (arrhythmia, structural). (2) High-risk features triggering admission/extensive workup: structural heart disease, abnormal EKG, syncope during exertion, family history SCD, persistent injury, hemodynamic instability. (3) Initial workup: history, exam, BP supine + standing × 3 min, EKG; selective use of Holter, echo, tilt table, exercise test. (4) OH causes: - Drug-induced: alpha-blocker, diuretic, vasodilator, antidepressant (TCA, SSRI), antiparkinson, nitrate, antipsychotic. - Volume depletion. - Neurogenic: Parkinson, MSA, pure autonomic failure, diabetes, amyloid, SCI, Sjögren. (5) Treatment hierarchy: - Stop/reduce offending drugs (alpha-blocker overlap here — doxazosin + tamsulosin). - Non-pharm: gradual movement, leg crossing, water 500 mL bolus pre-meal, compression stockings, abdominal binder, fluid 2-2.5 L + Na 6-10 g (if no CHF), HOB elevation. - Pharm: fludrocortisone (mineralocorticoid; volume), midodrine (alpha-1 agonist — avoid supine HTN, no bedtime), droxidopa (NEJM-approved for neurogenic OH), pyridostigmine. (6) Pacemaker — only for cardioinhibitory syncope (vasovagal with severe asystole), AV block, sinus node dysfunction (HR < 40 with symptoms). NOT for pure OH. (7) Address supine HTN paradox in nOH (often coexists with daytime OH): nighttime short-acting agent (losartan), HOB elevation, avoid evening fludrocortisone. A ผิด — pacemaker for cardioinhibitory not OH. C ผิด — meds are problem. D ผิด — no ventricular arrhythmia. E ผิด — beta-blocker worsens OH.', NULL,
  'medium', 'cardiovascular', 'review',
  'internal_medicine', 'clinical_decision', 'cardiovascular', 'adult',
  'ESC Guidelines for the Diagnosis and Management of Syncope 2018; AHA/ACC/HRS Syncope Guideline 2017; Freeman R et al. Auton Neurosci 2011 (Consensus on OH)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 76 ปี underlying HT มา ED ด้วยเป็นลม syncope ขณะลุกขึ้นยืนจากเก้าอี้ ไม่มี aura, ไม่มี postictal, ไม่มี tongue bite, ไม่มี incontinence ฟื้นภายใน 1 นาที 4 ครั้งใน 3 เดือน

V/S supine: BP 142/82, HR 56; standing: BP 92/52, HR 58 (no compensatory rise = neurogenic orthostatic hypotension); RR 16, SpO2 98%
Medications: amlodipine, lisinopril, doxazosin, sertraline, tamsulosin (recent)
Neuro: mild gait instability, no focal deficits

Lab: CBC, electrolytes, Cr normal
EKG: sinus bradycardia 56, no AV block, no QT prolongation, no ischemic changes
Echo: LVEF 55%, no AS, no HCM
Tilt table: positive (BP drop without HR rise — neurogenic)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 72 ปี underlying HT, T2DM, dyslipidemia มา OPD เพื่อ check up

No cardiovascular symptoms, no chest pain, no claudication, no syncope
Family history: father MI age 58, mother stroke age 65
Non-smoker, BMI 28

V/S: BP 138/84, HR 72
Lab: Total cholesterol 248, LDL 168, HDL 38, Triglyceride 218, non-HDL 210, A1c 7.2%, eGFR 68
Fasting glucose 142, urine microalbumin/Cr 88 mg/g
10-year ASCVD risk: 24% (high)
CAC score 480 (high)

คำถาม: dyslipidemia management strategy', '[{"label":"A","text":"Start statin only when LDL > 190"},{"label":"B","text":"Primary prevention high-ASCVD risk (T2DM + age + multiple risk factors + CAC > 100 = additional risk enhancer)"},{"label":"C","text":"Niacin + fenofibrate combo first-line"},{"label":"D","text":"Statin only for primary prevention after first MI"},{"label":"E","text":"Watchful waiting until LDL > 200"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Primary prevention high-ASCVD risk (T2DM + age + multiple risk factors + CAC > 100 = additional risk enhancer) — Lifestyle (Mediterranean/DASH diet, exercise 150 min/wk moderate, weight loss if overweight, smoking avoidance, alcohol moderation) + HIGH-intensity statin (atorvastatin 40-80 mg or rosuvastatin 20-40 mg) targeting LDL reduction ≥ 50% AND LDL < 70 (some recommend < 55 in very-high risk with diabetes + CKD + ≥ 2 RF per 2018 AHA/ACC + 2019 ESC); recheck lipids 4-12 weeks; if LDL goal not met → add ezetimibe (IMPROVE-IT); if still inadequate or very high risk → PCSK9 inhibitor (alirocumab, evolocumab) or inclisiran (siRNA, 6-monthly dose); bempedoic acid alternative if statin intolerance (CLEAR Outcomes); icosapent ethyl (Vascepa) if TG 150-499 + ASCVD/diabetes + RF (REDUCE-IT); manage co-existing DM (SGLT2i + GLP-1 RA preferred for cardio-renal benefit) + HT (BP < 130/80) + albuminuria (ACEi/ARB)

---

Primary prevention dyslipidemia + diabetes + high ASCVD risk + CAC > 100. AHA/ACC 2018 Cholesterol + 2019 ESC Dyslipidemia + ADA 2024 Standards of Care: (1) Risk-based statin therapy: - Clinical ASCVD (secondary prevention): high-intensity statin to LDL < 70 (< 55 if very high risk per ESC). - Primary prevention high risk (ASCVD risk ≥ 7.5-20%): moderate-high intensity statin. - Diabetes 40-75 yr: at least moderate-intensity statin; high-intensity if ASCVD risk ≥ 20% or multiple risk enhancers. - LDL ≥ 190 mg/dL: high-intensity statin regardless of risk. - Risk enhancers (AHA): CKD, metabolic syndrome, premature menopause, chronic inflammatory, family Hx premature CAD, ethnicity (South Asian), Lp(a) ≥ 50, ApoB ≥ 130, ABI < 0.9. - CAC scoring: 0 = defer/lower priority; 1-99 = consider; ≥ 100 or ≥ 75th percentile = favor statin. (2) Statin intensity: - High-intensity (LDL ↓ ≥ 50%): atorvastatin 40-80, rosuvastatin 20-40. - Moderate-intensity (LDL ↓ 30-49%): atorvastatin 10-20, rosuvastatin 5-10, simvastatin 20-40, pravastatin 40-80. (3) Goals: - Very high risk (clinical ASCVD + DM/CKD/recurrent event): LDL < 55 (ESC), < 70 (AHA). - High risk: LDL < 70 (ESC), reduction ≥ 50% (AHA). (4) Non-statin add-ons (after maximally tolerated statin): - Ezetimibe (IMPROVE-IT — additional 24% LDL ↓). - PCSK9 inhibitor (FOURIER, ODYSSEY — alirocumab, evolocumab); inclisiran (siRNA q6mo). - Bempedoic acid (CLEAR Outcomes — for statin intolerance). - Icosapent ethyl (REDUCE-IT — TG 150-499 + ASCVD/DM + RF). (5) Lifestyle backbone — Mediterranean, DASH, exercise, weight, smoking. (6) Statin safety: myalgia (common but rare true myopathy), LFT (rare hepatic injury), modest DM incidence (benefit outweighs in indicated). (7) Manage comorbid: SGLT2i/GLP-1 for cardio-renal-metabolic in DM; ACEi/ARB for albuminuria; BP < 130/80. A ผิด — wait misses benefit. C ผิด — niacin failed in HPS2-THRIVE/AIM-HIGH; fenofibrate adjunct not first-line. D ผิด — primary prevention well-established. E ผิด — ignore high-risk.', NULL,
  'easy', 'cardiovascular', 'review',
  'internal_medicine', 'clinical_decision', 'cardiovascular', 'adult',
  'ACC/AHA 2018 Cholesterol Guideline; ESC/EAS 2019 Guideline on Management of Dyslipidaemia; ADA Standards of Care 2024; IMPROVE-IT NEJM 2015; FOURIER NEJM 2017', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 72 ปี underlying HT, T2DM, dyslipidemia มา OPD เพื่อ check up

No cardiovascular symptoms, no chest pain, no claudication, no syncope
Family history: father MI age 58, mother stroke age 65
Non-smoker, BMI 28

V/S: BP 138/84, HR 72
Lab: Total cholesterol 248, LDL 168, HDL 38, Triglyceride 218, non-HDL 210, A1c 7.2%, eGFR 68
Fasting glucose 142, urine microalbumin/Cr 88 mg/g
10-year ASCVD risk: 24% (high)
CAC score 480 (high)

คำถาม: dyslipidemia management strategy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 60 ปี ไม่มีโรคประจำตัวเดิม มาด้วยอาการเหนื่อย dyspnea on exertion + ไอแห้ง 6 เดือน progressive ไม่มี wheeze, ไม่มี orthopnea, ไม่มี edema; ก่อนหน้านี้ไม่สูบบุหรี่; เคยเป็น cleaner (silica/dust exposure?), ใช้ตู้ราดะตา

V/S: BP 124/76, HR 92, RR 22, SpO2 91% RA, Temp 36.8°C
PE: clubbing +, fine "velcro" inspiratory crackles bilateral lower lobes, no wheeze, JVP normal, no edema

Lab: CBC normal, BNP 80, ESR 42, ANA 1:80 (low titer, non-specific), RF negative, Anti-CCP negative, ANCA negative, anti-Jo-1 negative
PFT: restrictive pattern — FVC 58% predicted, FEV1/FVC 0.85 (preserved ratio), TLC 62% predicted, DLCO 42% (severely reduced)
HRCT chest: bibasilar peripheral subpleural reticular opacities + honeycombing + traction bronchiectasis + minimal ground-glass — UIP (Usual Interstitial Pneumonia) pattern, no consolidation, no nodules, no mediastinal LAN
6-min walk test: distance 320 m, SpO2 drops to 85% during walk', '[{"label":"A","text":"Long-term high-dose prednisolone + azathioprine"},{"label":"B","text":"Idiopathic Pulmonary Fibrosis (IPF)"},{"label":"C","text":"Inhaled corticosteroid + LABA"},{"label":"D","text":"Empirical antibiotics"},{"label":"E","text":"Lung biopsy mandatory before any therapy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Idiopathic Pulmonary Fibrosis (IPF) — UIP pattern on HRCT + clinical features (gradual progressive dyspnea, clubbing, velcro crackles, restrictive PFT, low DLCO, age 60+, no alternative cause) — diagnosis per ATS/ERS/JRS/ALAT 2018/2022 criteria: (1) MDD (multidisciplinary discussion) confirms IPF; (2) Antifibrotic therapy: pirfenidone (CAPACITY/ASCEND trials, 2403 mg/d divided TID — slows FVC decline, photosensitivity + GI SE) OR nintedanib (INPULSIS trial, tyrosine kinase inhibitor 150 mg BID — slows FVC decline, diarrhea SE); both reduce FVC decline by ~50% and mortality benefit; do NOT use steroid + azathioprine + NAC triple — PANTHER-IPF showed harm; (3) Supportive care: pulmonary rehabilitation, oxygen supplementation (if SpO2 < 88% rest or exertional), influenza/pneumococcal/COVID vaccines, GERD treatment (common comorbid), comorbidity management (PH, OSA, depression); (4) Lung transplant referral early for younger patients (ILD = leading indication); (5) Acute exacerbation of IPF: high mortality, supportive ± steroids (low evidence); (6) Palliative care for symptom burden + advance care planning; clinical trial enrollment encouraged

---

Idiopathic Pulmonary Fibrosis (IPF) — most common idiopathic interstitial pneumonia in older adults. Diagnosis ATS/ERS/JRS/ALAT 2018 + 2022 update: (1) Clinical: > 60 yr, progressive dyspnea + dry cough > 6 mo, velcro inspiratory crackles, clubbing (30-50%). (2) PFT: restrictive (FVC ↓, TLC ↓), preserved ratio, DLCO disproportionately reduced. (3) HRCT UIP pattern (definite): bibasal subpleural reticulation + honeycombing + traction bronchiectasis + minimal ground-glass, no inconsistent features (extensive GGO, micronodules, consolidation, mosaicism, cysts away from honeycombing). - UIP: no biopsy needed. - Probable UIP: same without honeycombing → biopsy or cryobiopsy in selected. - Indeterminate, alt dx: surgical biopsy or transbronchial cryobiopsy. (4) Exclude alternative ILD: hypersensitivity pneumonitis (exposure, mosaicism, upper-lobe), CTD-ILD (autoimmune workup), occupational (asbestosis, silicosis), drug-induced (amio, methotrexate, nitrofurantoin), familial. (5) MDD (multidisciplinary discussion) — radiologist + pulm + pathologist. (6) Treatment: - Antifibrotic — Class I: - Pirfenidone (Esbriet): CAPACITY/ASCEND trials, 2403 mg/d divided, SE: photosensitivity, rash, GI. - Nintedanib (Ofev): INPULSIS, 150 mg BID, multi-TKI; SE: diarrhea (most common), LFT ↑, weight ↓. - Both slow FVC decline ~50%, mortality benefit. - Steroid + azathioprine + NAC HARMFUL (PANTHER-IPF stopped early — ↑ mortality). - NAC monotherapy: not effective. (7) Supportive: PR (pulm rehab), supplemental O2 (target SpO2 > 88-90%), vaccines, GERD treatment (common), comorbidity management (PH, OSA). (8) Lung transplant: ILD = leading indication; refer when FVC < 80% or symptomatic — single or double lung; 5-yr survival 50%. (9) Acute exacerbation: hospitalization, high-flow O2 ± empirical antibiotics/antiviral, methylprednisolone (low evidence — some use); high mortality. (10) Prognosis: median survival 3-5 yr from diagnosis; GAP score for staging. A ผิด — steroid harmful in IPF. C ผิด — for asthma not ILD. D ผิด — bacterial unlikely. E ผิด — typical UIP HRCT = no biopsy.', NULL,
  'medium', 'respiratory', 'review',
  'internal_medicine', 'clinical_decision', 'respiratory', 'adult',
  'ATS/ERS/JRS/ALAT IPF Clinical Practice Guideline 2018 (update 2022); INPULSIS Trial NEJM 2014; ASCEND/CAPACITY pirfenidone Lancet 2011; PANTHER-IPF NEJM 2012', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 60 ปี ไม่มีโรคประจำตัวเดิม มาด้วยอาการเหนื่อย dyspnea on exertion + ไอแห้ง 6 เดือน progressive ไม่มี wheeze, ไม่มี orthopnea, ไม่มี edema; ก่อนหน้านี้ไม่สูบบุหรี่; เคยเป็น cleaner (silica/dust exposure?), ใช้ตู้ราดะตา

V/S: BP 124/76, HR 92, RR 22, SpO2 91% RA, Temp 36.8°C
PE: clubbing +, fine "velcro" inspiratory crackles bilateral lower lobes, no wheeze, JVP normal, no edema

Lab: CBC normal, BNP 80, ESR 42, ANA 1:80 (low titer, non-specific), RF negative, Anti-CCP negative, ANCA negative, anti-Jo-1 negative
PFT: restrictive pattern — FVC 58% predicted, FEV1/FVC 0.85 (preserved ratio), TLC 62% predicted, DLCO 42% (severely reduced)
HRCT chest: bibasilar peripheral subpleural reticular opacities + honeycombing + traction bronchiectasis + minimal ground-glass — UIP (Usual Interstitial Pneumonia) pattern, no consolidation, no nodules, no mediastinal LAN
6-min walk test: distance 320 m, SpO2 drops to 85% during walk'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 60 ปี underlying T2DM, history pulmonary TB 10 ปีก่อน completed treatment มา OPD ด้วยน้ำในช่องเยื่อหุ้มปอดข้างขวา discovered ใน CXR routine

No fever, no weight loss, no night sweats, mild dyspnea on exertion, no chest pain
V/S stable

Thoracentesis: cloudy yellow fluid 1500 mL
Fluid analysis: WBC 4,200 (lymphocyte predominant 88%), protein 5.2 g/dL (serum 7.0), LDH 480 (serum 230), glucose 60 (serum 102), pH 7.36, ADA 92 U/L (high — suggests TB)
Gram stain negative, AFB smear negative, culture pending; cytology pending
Light''s criteria: protein ratio 0.74 (> 0.5), LDH ratio 2.1 (> 0.6), LDH > 2/3 ULN → EXUDATE
Closed pleural biopsy: granulomatous inflammation + AFB-positive caseating granulomas → confirms TB pleurisy
Drug-susceptibility: pan-susceptible MTB', '[{"label":"A","text":"Drainage of pleural effusion + observation only"},{"label":"B","text":"Tuberculous pleurisy"},{"label":"C","text":"Pleurodesis with talc to prevent recurrence"},{"label":"D","text":"Thoracotomy + decortication"},{"label":"E","text":"Antibiotics for bacterial empyema"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Tuberculous pleurisy — Treatment: (1) Standard 6-month TB regimen 4-drug intensive phase (2HRZE) → 2-drug continuation (4HR) — same as pulmonary TB; ATS/CDC/IDSA 2016 TB guideline; (2) Therapeutic thoracentesis for symptomatic relief — chest tube drainage NOT routinely required (unlike empyema/loculated); (3) Corticosteroid: NOT routinely recommended — Cochrane mixed evidence; consider in selected patients with significant symptoms or risk of pleural fibrosis; (4) Address comorbidity — optimize diabetes (TB-DM bidirectional, worsens outcomes); (5) HIV testing mandatory (all TB); (6) Contact tracing — pleural TB less infectious than pulm TB but family/close contacts screening recommended; (7) DOT or VOT (video-observed therapy) for adherence; (8) Baseline LFT (H, R, Z hepatotoxic), eye exam (E — optic neuritis), CBC, Cr, uric acid; (9) Monthly clinical + sputum/imaging follow-up; (10) Pyridoxine B6 25-50 mg/d with INH to prevent neuropathy; (11) Notify public health (TB notifiable in Thailand)

---

Tuberculous pleurisy — common cause of exudative pleural effusion in high-prevalence regions (Thailand). Clues: lymphocyte-predominant exudate (> 80% lymph), high ADA (> 40), low glucose, granulomatous inflammation. Light''s criteria distinguish exudate vs transudate. ATS/CDC/IDSA 2016 + WHO 2022 TB guideline: (1) Diagnosis: - Pleural fluid: lymphocytic exudate (> 80% lymphocytes), protein > 5 g/dL, glucose typically low-normal, ADA > 40-60 U/L highly suggestive (sensitivity 90-95%, specificity 85-95%; high-prevalence region positive predictive value > 95%), IFN-γ release assay pleural fluid alternative. - Pleural biopsy (closed needle or thoracoscopic) — high yield: granuloma + AFB + culture. - Sputum: 10-50% culture positive (often paucibacillary). - AFB smear pleural fluid: low sensitivity (10-20%) — paucibacillary. (2) Treatment: standard 6-month regimen (2 HRZE + 4 HR) — same as pulmonary TB. Drug-resistant: extended + 2nd-line. (3) Steroid: not routinely recommended; Cochrane review mixed; may reduce symptoms + effusion duration but no clear long-term benefit in pleural thickening/function. Selective use in severe symptoms. (4) Drainage: therapeutic thoracentesis for symptomatic relief; chest tube/decortication rarely needed unless loculated empyema. (5) Pleural fibrosis: long-term complication; trapped lung if delayed treatment. (6) HIV co-infection: test all; ART based on CD4; pleural TB common in HIV. (7) DM-TB: bidirectional — DM ↑ TB risk, TB worsens DM control; monitor + optimize. (8) Adverse drug reactions: hepatotoxicity (H, R, Z — check baseline + monthly LFT; hold if ALT > 5× or symptomatic), rash, fever, peripheral neuropathy (INH — give B6), optic neuritis (E), arthralgia + hyperuricemia (Z). (9) DOT/VOT to ensure adherence. (10) Notify public health. (11) Differential of lymphocytic exudate: TB, malignancy (lymphoma, mesothelioma, metastatic), CTD (RA, SLE), chylothorax, post-CABG. A ผิด — TB pleurisy needs anti-TB treatment. C ผิด — pleurodesis for refractory malignant. D ผิด — surgery for empyema/decortication late complication. E ผิด — TB not bacterial empyema.', NULL,
  'medium', 'respiratory', 'review',
  'internal_medicine', 'clinical_decision', 'respiratory', 'adult',
  'ATS/CDC/IDSA TB Treatment Guideline 2016; WHO Consolidated Guidelines on TB 2022; Light RW — Pleural Diseases 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 60 ปี underlying T2DM, history pulmonary TB 10 ปีก่อน completed treatment มา OPD ด้วยน้ำในช่องเยื่อหุ้มปอดข้างขวา discovered ใน CXR routine

No fever, no weight loss, no night sweats, mild dyspnea on exertion, no chest pain
V/S stable

Thoracentesis: cloudy yellow fluid 1500 mL
Fluid analysis: WBC 4,200 (lymphocyte predominant 88%), protein 5.2 g/dL (serum 7.0), LDH 480 (serum 230), glucose 60 (serum 102), pH 7.36, ADA 92 U/L (high — suggests TB)
Gram stain negative, AFB smear negative, culture pending; cytology pending
Light''s criteria: protein ratio 0.74 (> 0.5), LDH ratio 2.1 (> 0.6), LDH > 2/3 ULN → EXUDATE
Closed pleural biopsy: granulomatous inflammation + AFB-positive caseating granulomas → confirms TB pleurisy
Drug-susceptibility: pan-susceptible MTB'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 55 ปี IDU history, HIV negative มาด้วย incidental finding HCV antibody positive จาก routine screening + ALT/AST elevation 2× ULN × 6 เดือน

No jaundice, no ascites, no varices, no encephalopathy, no significant fatigue
V/S stable

Lab: HCV RNA 2.4 million IU/mL, HCV genotype 1a (most common in Asia/SE Asia among IDU)
LFT: AST 86, ALT 102, ALP 110, Bilirubin 1.0, Albumin 4.0, INR 1.0
Fibroscan 7.2 kPa (F2 mild-moderate fibrosis)
CBC normal, Cr 0.9, HbA1c 5.6%
HBsAg negative, anti-HBs positive (vaccinated), HIV negative
Family history: HCV in partner (now treated, SVR)
No drug allergies, no current drug-drug interactions concern', '[{"label":"A","text":"Pegylated interferon + ribavirin × 48 weeks"},{"label":"B","text":"Chronic HCV genotype 1a treatment-naïve no cirrhosis"},{"label":"C","text":"Watchful waiting until decompensation"},{"label":"D","text":"Liver biopsy mandatory before any treatment"},{"label":"E","text":"PEG-IFN + ribavirin + first-generation protease inhibitor"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Chronic HCV genotype 1a treatment-naïve no cirrhosis — Direct-acting antiviral (DAA) pan-genotypic regimen for 8-12 weeks: Glecaprevir/pibrentasvir 8 weeks OR Sofosbuvir/velpatasvir 12 weeks (both > 95% SVR12, well-tolerated, no IFN); confirm absence of decompensated cirrhosis (would require non-protease-inhibitor regimen + extended); check drug-drug interactions especially with statin, amiodarone, anticonvulsant, methadone, antiarrhythmic, herbal (St John''s wort contraindicated); HBV reactivation screening — must check HBsAg + anti-HBc before starting (here HBsAg neg, anti-HBs pos = vaccinated, no risk); SVR12 (Sustained Virologic Response 12 weeks post-treatment) = virologic cure (99% reduction HCC + cirrhosis progression); post-cure: continue HCC surveillance only if cirrhosis baseline (F4); reinfection counseling (DAA does not prevent re-infection — IDU = harm reduction, needle exchange, MOUD/OAT); partner notification; HCC US + AFP q6 mo if F3-F4; metabolic comorbidity management; vaccinate (HAV if susceptible)

---

Chronic Hepatitis C virus infection — modern era of direct-acting antiviral (DAA) cure. AASLD/IDSA 2023 + EASL 2020 + Thai Hep Soc HCV guideline: (1) Diagnosis: anti-HCV positive → HCV RNA + genotype; chronic if RNA > 6 mo. Universal screening adults 18-79 yr (CDC, USPSTF). (2) Pre-treatment evaluation: - Liver disease assessment: APRI, FIB-4, transient elastography (Fibroscan); cirrhosis (F4) impacts duration + agent choice. - Decompensation (Child-Pugh B/C): avoid protease inhibitors (glecaprevir, voxilaprevir) — hepatotoxicity. - HBV co-infection: HBsAg + anti-HBc → preemptive HBV antiviral or close monitoring (HBV reactivation reported with DAA). - HIV co-infection: ART drug interactions (glecaprevir + atazanavir issues). - Drug-drug interactions: HCV DAA interaction checker (Liverpool DDI). (3) DAA regimens (pan-genotypic — most useful in Asia where multiple genotypes): - **Glecaprevir/pibrentasvir** (G/P, Maviret): 8 wk in treatment-naïve no cirrhosis (all genotypes); 12 wk for compensated cirrhosis; SVR ≥ 95%. - **Sofosbuvir/velpatasvir** (SOF/VEL, Epclusa): 12 wk all genotypes treatment-naïve including compensated cirrhosis; SVR > 95%. - **Sofosbuvir/velpatasvir/voxilaprevir** (SOF/VEL/VOX, Vosevi): DAA-experienced 12 wk salvage. (4) SVR12 = cure (HCV RNA undetectable 12 wk post-treatment) — definitive virologic cure; reduces all-cause mortality, HCC, decompensation, transplant need. (5) Post-cure: - HCC surveillance: ONLY if cirrhosis (F4) at start — US + AFP q6 mo, lifelong. - Re-infection counseling: DAA does not confer immunity; risk persists in IDU, MSM, sexual practices — harm reduction (needle exchange, MOUD/OAT, PrEP-like counseling). - Partner notification. - Metabolic + cardiac comorbidity. (6) Public health: notifiable in some jurisdictions; WHO HCV elimination 2030 target. (7) Special populations: - Pregnancy: defer DAA (limited data) unless severe; treat post-partum. - Pediatric: G/P > 3 yr; SOF-based > 6 yr. - HIV co-infection: same DAA, watch DDI. - Kidney disease: G/P safe all eGFR; SOF safe (despite historical concerns). - Decompensated: SOF/VEL + ribavirin 12 wk (no PI). A ผิด — IFN era over. C ผิด — DAA cures + prevents progression. D ผิด — non-invasive sufficient; biopsy not required. E ผิด — old IFN-PI combo obsolete.', NULL,
  'easy', 'gi', 'review',
  'internal_medicine', 'clinical_decision', 'gi', 'adult',
  'AASLD-IDSA HCV Guidance 2023; EASL Recommendations on Treatment of Hepatitis C 2020; Thai Liver Society HCV Guidance', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 55 ปี IDU history, HIV negative มาด้วย incidental finding HCV antibody positive จาก routine screening + ALT/AST elevation 2× ULN × 6 เดือน

No jaundice, no ascites, no varices, no encephalopathy, no significant fatigue
V/S stable

Lab: HCV RNA 2.4 million IU/mL, HCV genotype 1a (most common in Asia/SE Asia among IDU)
LFT: AST 86, ALT 102, ALP 110, Bilirubin 1.0, Albumin 4.0, INR 1.0
Fibroscan 7.2 kPa (F2 mild-moderate fibrosis)
CBC normal, Cr 0.9, HbA1c 5.6%
HBsAg negative, anti-HBs positive (vaccinated), HIV negative
Family history: HCV in partner (now treated, SVR)
No drug allergies, no current drug-drug interactions concern'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 75 ปี admit รพ. × 12 วันสำหรับ CAP ได้ ceftriaxone + azithromycin ดีขึ้น ตอนนี้ถ่ายเหลว 8-10 ครั้ง/วัน × 3 วัน + ปวดท้องคล้ายๆ + ไข้ 38.4°C

V/S: BP 102/64, HR 102, RR 18, SpO2 96%, Temp 38.4°C
PE: abdomen distended, mild tender diffuse, normoactive bowel sounds, no rebound

Lab: WBC 22,000 (severe leukocytosis), Cr 1.8 (baseline 1.0), Albumin 2.6, Lactate 2.4
Stool: C. difficile toxin EIA positive, GDH positive, NAAT positive (toxigenic strain)
Abdominal imaging: colonic wall thickening + pericolonic stranding, no megacolon, no perforation
No recent fluoroquinolone or PPI changes', '[{"label":"A","text":"Metronidazole oral × 14 d"},{"label":"B","text":"Severe Clostridioides difficile infection (IDSA criteria"},{"label":"C","text":"Loperamide for diarrhea control"},{"label":"D","text":"Continue ceftriaxone + add metronidazole"},{"label":"E","text":"Probiotics alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe Clostridioides difficile infection (IDSA criteria: WBC > 15K OR Cr > 1.5 × baseline OR sepsis features; fulminant = hypotension/ileus/megacolon) — Stop offending antibiotics if possible (de-escalate broad spectrum) + start: (1) Fidaxomicin 200 mg PO BID × 10 d (FIRST-LINE per IDSA 2021 update — superior to vancomycin in sustained response/recurrence reduction); alternative oral vancomycin 125 mg PO QID × 10 d; metronidazole no longer first-line (inferior); (2) Severe-fulminant CDI with ileus/megacolon: vancomycin 500 mg PO/NG QID + IV metronidazole 500 mg q8h ± vancomycin per rectum (retention enema) 500 mg in 100 mL NSS q6h; surgical consult if megacolon/perforation/ shock — subtotal colectomy or diverting loop ileostomy; (3) Recurrent CDI: fidaxomicin or vancomycin tapered/pulsed; FMT (fecal microbiota transplantation) for ≥ 2 recurrences (CD highly effective ~90%); bezlotoxumab (anti-toxin B antibody) for high-risk recurrence; (4) Infection control: contact precautions (gown + gloves), private room, dedicated equipment, soap and water hand hygiene (alcohol does not kill spores), terminal cleaning with sporicidal (bleach); (5) Hold non-essential PPI (PPI ↑ CDI risk); (6) Probiotics — not routine; (7) Fluid + electrolyte support; (8) Repeat stool testing NOT recommended for cure (PCR can stay positive)

---

Clostridioides difficile infection (CDI) — most common nosocomial diarrhea. IDSA/SHEA 2017 + 2021 CDI guideline update + ESCMID 2021: (1) Diagnosis: liquid stool (unformed) + toxigenic test positive (NAAT/PCR for tcdB, or EIA toxin A/B; GDH screening). PCR-only = colonization possible — combine with toxin EIA (algorithmic — NAAT + EIA reflex). (2) Severity classification (IDSA): - Non-severe: WBC ≤ 15K + Cr ≤ 1.5 mg/dL. - Severe: WBC > 15K OR Cr > 1.5. - Fulminant (severe-complicated): hypotension, shock, ileus, megacolon (> 6 cm), perforation. (3) Initial treatment (IDSA 2021 update): - Non-severe + severe: fidaxomicin 200 mg PO BID × 10 d (preferred — superior sustained response, less recurrence). Alternative: vancomycin 125 mg PO QID × 10 d. Metronidazole no longer first-line (inferior, only if other unavailable + non-severe). - Fulminant: vancomycin 500 mg PO/NG QID + IV metronidazole 500 mg q8h ± vancomycin per rectum (if ileus) 500 mg in 100 mL NSS q6h; ICU; surgical consult. (4) Recurrent CDI (10-25% recur): - 1st recurrence: tapered/pulsed vancomycin OR fidaxomicin (if not used first time). - ≥ 2 recurrences: fidaxomicin extended OR fecal microbiota transplantation (FMT) — > 90% cure (oral capsule, colonoscopic, NG, enema); FDA-approved oral product Rebyota, Vowst; bezlotoxumab (anti-toxin B mAb) as adjunct for high-risk recurrence (single IV dose). (5) Surgical: subtotal colectomy or diverting loop ileostomy + colon lavage for fulminant + medical failure; mortality high. (6) Infection control: contact + enteric precautions, SOAP and water hand hygiene (alcohol gel ineffective vs spores), bleach cleaning. (7) Stop unnecessary antibiotics + PPI. (8) Avoid antimotility (loperamide) — risk toxic megacolon. (9) Repeat testing not recommended (PCR persists). (10) Vaccines under development. A ผิด — metronidazole no longer first-line. C ผิด — antimotility = megacolon risk. D ผิด — continuing offending abx perpetuates. E ผิด — inadequate.', NULL,
  'medium', 'id', 'review',
  'internal_medicine', 'clinical_decision', 'id', 'adult',
  'IDSA/SHEA Clinical Practice Guidelines for CDI in Adults 2017 (update 2021); ESCMID Guidelines for CDI 2021; ACG CDI Guidelines 2021', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 75 ปี admit รพ. × 12 วันสำหรับ CAP ได้ ceftriaxone + azithromycin ดีขึ้น ตอนนี้ถ่ายเหลว 8-10 ครั้ง/วัน × 3 วัน + ปวดท้องคล้ายๆ + ไข้ 38.4°C

V/S: BP 102/64, HR 102, RR 18, SpO2 96%, Temp 38.4°C
PE: abdomen distended, mild tender diffuse, normoactive bowel sounds, no rebound

Lab: WBC 22,000 (severe leukocytosis), Cr 1.8 (baseline 1.0), Albumin 2.6, Lactate 2.4
Stool: C. difficile toxin EIA positive, GDH positive, NAAT positive (toxigenic strain)
Abdominal imaging: colonic wall thickening + pericolonic stranding, no megacolon, no perforation
No recent fluoroquinolone or PPI changes'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 38 ปี ไม่มีโรคประจำตัวเดิม มาด้วยอาการแขนขาอ่อนแรง progressive ascending (เริ่มเท้าก่อน → ขา → แขน) 5 วัน + paresthesia ปลายนิ้วเท้า + นิ้วมือ + reflex ลดลง 1 สัปดาห์ก่อนหน้านี้มี diarrhea (likely Campylobacter)

V/S: BP 142/88 (mild HTN), HR 110 (tachycardia — autonomic), RR 22, SpO2 96%
PE: bilateral lower extremity weakness 2/5 proximal > distal, upper extremity 4/5, areflexia diffuse, sensory mild paresthesia, no fever, no meningismus, cranial nerves intact (no facial weakness yet)
Vital capacity 1.6 L (low — declining), NIF -25 cmH2O (concerning)

Lab: CBC, electrolytes normal; LFT normal; HIV neg
LP: protein 102 mg/dL (elevated), WBC 4 cells (no pleocytosis) — albuminocytologic dissociation (classic GBS)
NCS: prolonged distal motor latency + reduced motor conduction velocity + temporal dispersion → AIDP variant
Anti-GM1 IgG positive (Campylobacter-associated)
MRI spine: no compressive lesion', '[{"label":"A","text":"High-dose oral steroid prednisolone 60 mg/d"},{"label":"B","text":"Guillain-Barré Syndrome (acute inflammatory demyelinating polyradiculoneuropathy, AIDP)"},{"label":"C","text":"Pyridostigmine for myasthenia-like crisis"},{"label":"D","text":"Discharge with outpatient PT only"},{"label":"E","text":"Anti-epileptic drug for paresthesia"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Guillain-Barré Syndrome (acute inflammatory demyelinating polyradiculoneuropathy, AIDP) — Hospital admission + close respiratory monitoring (FVC < 20 mL/kg, NIF < -30, MIP, bulbar dysfunction = intubation criteria; 25-30% need vent); (1) First-line immunotherapy: IVIG 0.4 g/kg/d × 5 d (total 2 g/kg) OR plasma exchange (PLEX) 200-250 mL/kg over 5 sessions — both equally effective per multiple RCTs; choice based on availability/contraindications (PLEX needs vascular access, hemodynamic stability; IVIG: IgA deficiency, thromboembolic risk, renal); do NOT combine IVIG + PLEX (no added benefit); start within 2 wk of onset (preferably 1 wk); (2) NO steroid — Cochrane: ineffective in GBS, may worsen; (3) Supportive: VTE prophylaxis (immobile + immunoglobulin), DVT, autonomic monitoring (BP swings, arrhythmia, ileus), pain control (gabapentin/carbamazepine — neuropathic), nutrition, pressure injury prevention, early PT/OT, ophthalmologic (corneal protection), bladder/bowel; (4) ICU if rapid progression or respiratory compromise; (5) Tracheostomy if prolonged vent > 14-21 d; (6) Recovery 6-12 mo; 10-15% mortality; 20% residual disability; relapsing form = CIDP (consider if > 8 wk progression); (7) Vaccinations history; Campylobacter as trigger; counsel re re-vaccination concerns

---

Guillain-Barré syndrome (GBS) — most common AIDP variant. Classic features: ascending symmetric weakness/areflexia, antecedent infection (Campylobacter jejuni most common — anti-GM1 antibody; also CMV, EBV, Mycoplasma, Zika, COVID), albuminocytologic dissociation (high protein + minimal cells) on LP after week 1, demyelinating pattern on NCS. AAN + Cochrane GBS guideline: (1) Diagnosis: NINDS Brighton criteria; LP shows protein > 45 with WBC < 50 (albuminocytologic dissociation — sensitivity increases after week 1); NCS demonstrates motor demyelination (AIDP), or axonal (AMAN, AMSAN); MRI may show nerve root enhancement. (2) Variants: AIDP (Western, classic), AMAN (Asian, axonal motor, Campylobacter, anti-GM1), AMSAN (severe axonal), Miller-Fisher (ophthalmoplegia, ataxia, areflexia, anti-GQ1b). (3) Respiratory + autonomic monitoring critical: - Bedside FVC (< 20 mL/kg), MIP, MEP, NIF (< -30 cmH2O); 20-30% need intubation. - Bulbar dysfunction → aspiration. - Autonomic instability: BP swings, arrhythmia, ileus, urinary retention, sweating abnormalities. (4) Treatment: - IVIG 0.4 g/kg/d × 5 d (total 2 g/kg) — convenient, no vascular access; SE: aseptic meningitis, headache, anaphylaxis (IgA deficient), thrombosis, renal. - PLEX 200-250 mL/kg over 5 sessions — vascular access, BP support; SE: hypotension, infection, fluid shifts. - Both equally effective; combine not better. - Start within 1-2 weeks; benefit ↓ thereafter. (5) STEROIDS NOT effective in GBS — Cochrane confirmed; may worsen — DO NOT use (unlike CIDP). (6) Supportive: VTE prophylaxis (LMWH), pain (gabapentin, carbamazepine for neuropathic), nutrition (NG/PEG if bulbar), bladder/bowel, pressure injury prevention, early rehab, corneal protection (facial weakness). (7) ICU if respiratory failure or autonomic instability. (8) Recovery: nadir in 2-4 wk, plateau, gradual recovery over 6-12 mo; 80% ambulate at 1 yr; mortality 5-10%, 20% residual disability. (9) CIDP differential: progression > 8 wk, relapsing course → CIDP (responds to steroid). A ผิด — steroid not effective in GBS. C ผิด — not MG. D ผิด — risk respiratory failure. E ผิด — paresthesia not main issue.', NULL,
  'medium', 'neurology', 'review',
  'internal_medicine', 'clinical_decision', 'neurology', 'adult',
  'EAN/PNS Guideline on the Diagnosis and Treatment of GBS 2023; Cochrane Review IVIG vs PLEX in GBS; AAN Practice Parameter GBS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 38 ปี ไม่มีโรคประจำตัวเดิม มาด้วยอาการแขนขาอ่อนแรง progressive ascending (เริ่มเท้าก่อน → ขา → แขน) 5 วัน + paresthesia ปลายนิ้วเท้า + นิ้วมือ + reflex ลดลง 1 สัปดาห์ก่อนหน้านี้มี diarrhea (likely Campylobacter)

V/S: BP 142/88 (mild HTN), HR 110 (tachycardia — autonomic), RR 22, SpO2 96%
PE: bilateral lower extremity weakness 2/5 proximal > distal, upper extremity 4/5, areflexia diffuse, sensory mild paresthesia, no fever, no meningismus, cranial nerves intact (no facial weakness yet)
Vital capacity 1.6 L (low — declining), NIF -25 cmH2O (concerning)

Lab: CBC, electrolytes normal; LFT normal; HIV neg
LP: protein 102 mg/dL (elevated), WBC 4 cells (no pleocytosis) — albuminocytologic dissociation (classic GBS)
NCS: prolonged distal motor latency + reduced motor conduction velocity + temporal dispersion → AIDP variant
Anti-GM1 IgG positive (Campylobacter-associated)
MRI spine: no compressive lesion'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 45 ปี underlying myasthenia gravis on pyridostigmine 60 mg q4h + prednisolone 20 mg/d + azathioprine 100 mg/d มาด้วยอ่อนแรงมากขึ้นใน 3 วัน หลังเริ่ม ciprofloxacin สำหรับ UTI + คลื่นไส้

V/S: BP 132/82, HR 108, RR 26 (rapid shallow), SpO2 92% RA, Temp 37.6°C
PE: ptosis +, dysarthria, dysphagia, head drop, generalized weakness 3-4/5 proximal, normal sensory, no fasciculation
FVC 800 mL (low!), NIF -22 cmH2O (concerning), single breath count 14, GCS 15

Lab: WBC 12,400, CK 88, Mg 1.6, K 3.4, Cr 1.0, ABG: pH 7.36, PaCO2 44 (rising), PaO2 76
Ice pack test: improvement in ptosis +
Edrophonium test: improved strength (rules out cholinergic crisis)
AchR antibody positive (known)
Recent meds: ciprofloxacin (potential trigger), prednisolone (could be cause if recently increased — recent increase precipitates crisis transiently)', '[{"label":"A","text":"Increase pyridostigmine dose to 90 mg q3h"},{"label":"B","text":"Myasthenic crisis (respiratory failure or impending"},{"label":"C","text":"Stop pyridostigmine + intubate + PLEX"},{"label":"D","text":"Atropine IV for cholinergic crisis"},{"label":"E","text":"Calcium gluconate IV for muscle weakness"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Myasthenic crisis (respiratory failure or impending — FVC < 1 L, NIF < -25, single breath count < 20, dyspnea, dysphagia, hypercapnia) — Emergency: (1) ICU admission + frequent FVC/NIF q2h + airway assessment; intubation if FVC < 15 mL/kg, NIF < -20, deteriorating, severe bulbar (aspiration risk), CO2 retention — NIV may bridge but not delay; (2) Stop/avoid triggers — STOP fluoroquinolone (ciprofloxacin), aminoglycoside, macrolide, beta-blocker, magnesium, IV contrast (if possible), antimuscarinic, neuromuscular blocker (use cautiously, depolarizing OK but non-depolarizing prolonged); (3) IVIG 0.4 g/kg/d × 5 d (2 g/kg total) OR plasma exchange (PLEX) 5 sessions — equally effective per Cochrane; PLEX preferred in severe/rapid (faster onset 1-3 d); (4) Continue/optimize maintenance immunosuppression: prednisolone (steroid can transiently worsen first 1-2 wk — taper carefully; some give IVIG/PLEX before steroid increase to prevent crisis); azathioprine/MMF maintenance; (5) Pyridostigmine: continue at usual dose; high-dose can cause cholinergic crisis (which mimics myasthenic — bradycardia, miosis, salivation, lacrimation); during crisis many neurologists temporarily hold pyridostigmine (avoid secretion overload while intubated); (6) Newer: complement inhibitor eculizumab (REGAIN — refractory AchR+), efgartigimod (FcRn inhibitor, ADAPT), rozanolixizumab; (7) Treat precipitant (UTI here — switch to non-FQ antibiotic e.g., cefuroxime); correct electrolytes (Mg, K); (8) Thymectomy elective for non-thymomatous AchR+ MG (MGTX trial showed benefit)

---

Myasthenic crisis — respiratory or bulbar failure requiring ventilation in myasthenia gravis. Distinguish from cholinergic crisis (excessive AChE inhibitor → SLUDGE, fasciculations, miosis — rare with oral pyridostigmine alone). Triggers: infection, drugs (fluoroquinolone, aminoglycoside, macrolide, beta-blocker, Mg, IV contrast, ciprofloxacin here), pregnancy, surgery, steroid initiation/escalation (transient worsening). AAN + MGFA International Consensus 2020: (1) Diagnosis MG: AchR Ab (85% generalized, 50% ocular), MuSK Ab (some seroneg), LRP4 Ab; EMG: decremental response on repetitive nerve stimulation, single-fiber EMG (jitter, blocking — most sensitive); ice pack test, edrophonium test (rarely used now). (2) Crisis indicators: dyspnea, FVC < 1 L or < 15 mL/kg, NIF < -25, single-breath count < 20, hypercapnia, bulbar dysfunction (aspiration risk), accessory muscle use. (3) Crisis management: - ICU + frequent FVC/NIF q2-4h. - Intubation early if criteria; NIV (BiPAP) trial in selected non-bulbar. - Acute immunotherapy: IVIG 2 g/kg over 2-5 d OR PLEX 5 sessions QOD — equivalent (Cochrane); PLEX faster onset 1-3 d, preferred in severe/bulbar; IVIG easier access. - Continue prednisolone but recognize transient worsening 1-2 wk after steroid initiation/dose increase (give IVIG/PLEX prophylactically before steroid escalation in severe). - Pyridostigmine: maintenance dose; some hold during intubation to reduce secretions; avoid escalation to cholinergic crisis. - Treat precipitant: stop offending drug, treat infection (non-fluoroquinolone — ciprofloxacin worsens NMJ; use cefuroxime/nitrofurantoin for UTI), correct electrolytes (Mg, K). - VTE prophylaxis, DVT, nutrition. (4) Avoid: NM blockers (cisatracurium fine, succinylcholine OK, vecuronium prolonged; in MG response unpredictable); macrolide, FQ, AG, IV magnesium, beta-blocker. (5) Long-term: - Pyridostigmine 30-60 mg q4-6h symptomatic. - Prednisolone induction → taper to lowest effective. - Steroid-sparing: azathioprine, MMF, methotrexate, cyclosporine, tacrolimus. - Refractory: rituximab (MuSK especially), eculizumab (anti-C5, REGAIN — AchR+), efgartigimod (FcRn — ADAPT), rozanolixizumab. - Thymectomy: thymoma (always); non-thymomatous AchR+ generalized MG age 18-65 (MGTX NEJM 2016 trial — improved outcomes). (6) Crisis mortality < 5% with modern care. A ผิด — increasing pyridostigmine = cholinergic crisis risk. C ผิด — stopping pyrido + intubate + PLEX is partly right but not most complete. D ผิด — atropine for cholinergic. E ผิด — Ca not therapeutic.', NULL,
  'hard', 'neurology', 'review',
  'internal_medicine', 'clinical_decision', 'neurology', 'adult',
  'MGFA International Consensus Guidance for Management of MG 2020 Update; AAN MG Guidelines; MGTX Trial NEJM 2016 (Thymectomy)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 45 ปี underlying myasthenia gravis on pyridostigmine 60 mg q4h + prednisolone 20 mg/d + azathioprine 100 mg/d มาด้วยอ่อนแรงมากขึ้นใน 3 วัน หลังเริ่ม ciprofloxacin สำหรับ UTI + คลื่นไส้

V/S: BP 132/82, HR 108, RR 26 (rapid shallow), SpO2 92% RA, Temp 37.6°C
PE: ptosis +, dysarthria, dysphagia, head drop, generalized weakness 3-4/5 proximal, normal sensory, no fasciculation
FVC 800 mL (low!), NIF -22 cmH2O (concerning), single breath count 14, GCS 15

Lab: WBC 12,400, CK 88, Mg 1.6, K 3.4, Cr 1.0, ABG: pH 7.36, PaCO2 44 (rising), PaO2 76
Ice pack test: improvement in ptosis +
Edrophonium test: improved strength (rules out cholinergic crisis)
AchR antibody positive (known)
Recent meds: ciprofloxacin (potential trigger), prednisolone (could be cause if recently increased — recent increase precipitates crisis transiently)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 76 ปี underlying HT มาด้วย progressive memory impairment 18 เดือน + lost in familiar places + difficulty managing finances + recent worsening apathy + ภรรยาบอก rapid decline 6 เดือนสุดท้าย

MMSE 16/30 (severe loss orientation, recall, attention)
MoCA 14/30
ADL: needs help with finances, medications, complex IADL; preserved basic ADL

No prominent gait dysfunction, no parkinsonism, no visual hallucination (RBD absent), no early prominent language deficit, no urinary incontinence prominently, no early personality change with disinhibition

Lab: CBC, TSH, B12, RPR, HIV, LFT, electrolytes, glucose, Cr all normal
Vit D normal, Folate normal
Depression screening: positive mild but not major

MRI brain: bilateral medial temporal lobe (hippocampal) atrophy + parietal atrophy + global atrophy; small vessel white matter changes mild; no infarct
FDG-PET: bilateral temporoparietal + posterior cingulate hypometabolism ("AD pattern")
CSF biomarkers: low Aβ42, high p-tau, high t-tau (suggesting AD biomarker positive)', '[{"label":"A","text":"No further treatment needed — natural aging"},{"label":"B","text":"Alzheimer disease dementia, moderate stage"},{"label":"C","text":"Levodopa-carbidopa for parkinsonism"},{"label":"D","text":"Vitamin E mega-dose alone"},{"label":"E","text":"Hospice referral"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Alzheimer disease dementia, moderate stage — Multidisciplinary management: (1) Pharmacologic: cholinesterase inhibitor (donepezil 5-10 mg qhs, rivastigmine patch 9.5-13.3 mg/d, galantamine ER 16-24 mg/d) for mild-moderate stage; add memantine (NMDA antagonist) 10 mg BID for moderate-severe; monitor for SE (bradycardia + GI for ChEI; consider EKG baseline + with each dose change especially in HF/AV block); (2) Disease-modifying anti-amyloid therapy — lecanemab (Leqembi, FDA-approved 2023 — biweekly IV, slows decline 27%, ARIA edema/microhemorrhage risk; APOE ε4 homozygote highest risk) + donanemab (Kisunla, FDA 2024) — patient selection: early AD biomarker-confirmed (amyloid PET or CSF+) + mild cognitive impairment or mild dementia (MMSE > 20); MRI baseline + serial monitoring for ARIA-E/H; not for moderate-severe; (3) Non-pharm: cognitive training, exercise, social engagement, structured routine; (4) Address modifiable factors: BP control (SPRINT-MIND), hearing aids (LIFE-Cog), vision correction, sleep, depression treatment (SSRI safer than TCA); (5) Behavioral + psychological symptoms (BPSD): non-pharm first; antipsychotic last resort (FDA black box warning: ↑ mortality elderly dementia; brexpiprazole approved for AD agitation 2023); (6) Caregiver support, advance care planning, driving evaluation, finances, safety (cooking, wandering), POLST/advance directive; (7) Long-term care planning; (8) Vaccinations (flu, pneumococcal, COVID, shingles)

---

Alzheimer disease (AD) dementia, moderate stage with biomarker confirmation. NIA-AA 2018 + IWG criteria + Lancet Commission on Dementia 2024: (1) Diagnosis: clinical (insidious onset, progressive episodic memory loss > 6 mo + impairment another cognitive domain + functional decline) + biomarker (CSF Aβ42 ↓, p-tau ↑, t-tau ↑; or amyloid PET +; or FDG-PET temporoparietal hypometab; or hippocampal atrophy MRI). (2) Differential: vascular dementia, DLB (early visual hallucination, parkinsonism, fluctuating cognition, RBD), FTD (early personality/language/disinhibition, frontotemporal atrophy), NPH (gait + incontinence + cognition), CJD (rapid). (3) Treatment options: - **Symptomatic (ChEI)**: donepezil, rivastigmine, galantamine — mild-moderate AD; modest benefit (1-3 mo cognitive stability, some functional); SE: bradycardia, syncope, GI; check EKG; rivastigmine patch better tolerated. - **Memantine** (NMDA antagonist): moderate-severe (MMSE < 20); add to ChEI or monotherapy. - **Anti-amyloid mAb (disease-modifying)**: NEW. - Lecanemab (Leqembi, FDA Jul 2023): IV q2wk; CLARITY-AD trial slowed decline 27% over 18 mo; ARIA-E/H risk (especially APOE ε4 homozygotes — black box). - Donanemab (Kisunla, FDA 2024): IV q4wk; TRAILBLAZER-ALZ 2 trial. - Patient selection: confirmed amyloid biomarker + mild cognitive impairment or mild dementia (MMSE > 20). - Aducanumab (Aduhelm) withdrawn 2024. - MRI surveillance for ARIA. (4) Lancet Commission 2024 — 14 modifiable risk factors (40% dementia attributable): education, hearing loss, HTN, obesity, smoking, depression, physical inactivity, diabetes, social isolation, excessive alcohol, TBI, air pollution, visual impairment, high LDL. (5) Behavioral/psychological symptoms (BPSD): - Non-pharm first: routine, environment modification, music, exercise. - SSRI for depression (citalopram, sertraline). - Antipsychotic: brexpiprazole (FDA 2023 for AD agitation) — first FDA-approved for this; risperidone/olanzapine/quetiapine if needed, lowest dose shortest duration, black box ↑ mortality. - Trazodone, melatonin for sleep. - Benzodiazepines avoid (delirium, falls). (6) Caregiver support — major morbidity/mortality factor; respite, education. (7) Safety: driving (DMV referral), cooking, wandering, medication management, weapons. (8) Advance care planning: POLST, surrogate, goals of care. A ผิด — not natural aging. C ผิด — no parkinsonism. D ผิด — high-dose Vit E disputed (TEAM-AD modest, mortality concern). E ผิด — too early; not end-stage.', NULL,
  'medium', 'neurology', 'review',
  'internal_medicine', 'clinical_decision', 'neurology', 'adult',
  'NIA-AA Research Framework for AD 2018; Lancet Commission on Dementia Prevention 2024; CLARITY-AD Lecanemab NEJM 2023; AAN Practice Guideline on AD', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 76 ปี underlying HT มาด้วย progressive memory impairment 18 เดือน + lost in familiar places + difficulty managing finances + recent worsening apathy + ภรรยาบอก rapid decline 6 เดือนสุดท้าย

MMSE 16/30 (severe loss orientation, recall, attention)
MoCA 14/30
ADL: needs help with finances, medications, complex IADL; preserved basic ADL

No prominent gait dysfunction, no parkinsonism, no visual hallucination (RBD absent), no early prominent language deficit, no urinary incontinence prominently, no early personality change with disinhibition

Lab: CBC, TSH, B12, RPR, HIV, LFT, electrolytes, glucose, Cr all normal
Vit D normal, Folate normal
Depression screening: positive mild but not major

MRI brain: bilateral medial temporal lobe (hippocampal) atrophy + parietal atrophy + global atrophy; small vessel white matter changes mild; no infarct
FDG-PET: bilateral temporoparietal + posterior cingulate hypometabolism ("AD pattern")
CSF biomarkers: low Aβ42, high p-tau, high t-tau (suggesting AD biomarker positive)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 68 ปี underlying HT มาด้วยปวดหลังเรื้อรัง 3 เดือน + อ่อนเพลีย + น้ำหนักลด 4 kg + recently fall จากเดินปกติ → กระดูกสันหลังหัก L2 ไม่มี trauma รุนแรง

V/S: BP 138/82, HR 88, RR 16, Temp 36.8°C
PE: pallor +, mid-back tenderness, no focal neuro deficit, no organomegaly, no lymphadenopathy

Lab: Hb 9.4 (normocytic, MCV 88), Cr 2.4 (baseline 1.0), Ca 11.8 (high), Phosphate 4.2, Albumin 3.0, Total protein 9.8 (HIGH — gamma-gap = 6.8), ALP 110 (NORMAL — characteristic in MM no osteoblastic), LDH 320
UA: protein 1+ but UPCR 4.8 g/g (heavy proteinuria); Bence-Jones positive (light chain proteinuria)
Serum protein electrophoresis: M-spike 4.2 g/dL in gamma region
Immunofixation: IgG kappa monoclonal
Serum free light chain ratio: kappa/lambda = 28 (markedly skewed)
Beta-2 microglobulin: 6.2 (high — stage III)
Skeletal survey: multiple lytic lesions skull, spine, pelvis, femur ("punched out")
Whole-body MRI/PET: > 10 lytic lesions
Bone marrow biopsy: 42% atypical plasma cells (> 10% diagnostic for MM); flow cytometry: clonal CD138+ kappa+ plasma cells; FISH: t(4;14), del(17p) → high-risk cytogenetics

CRAB: Calcium 11.8 (+), Renal Cr 2.4 (+), Anemia Hb 9.4 (+), Bone lytic lesions (+) — symptomatic MM', '[{"label":"A","text":"Watchful waiting for asymptomatic MGUS"},{"label":"B","text":"Symptomatic Multiple Myeloma (CRAB criteria + biomarker SLiM"},{"label":"C","text":"Single-agent dexamethasone alone"},{"label":"D","text":"Radiation therapy as sole curative treatment"},{"label":"E","text":"Surgery to remove plasmacytoma"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Symptomatic Multiple Myeloma (CRAB criteria + biomarker SLiM: bone marrow plasma > 60%, FLC ratio > 100, > 1 focal lesion on MRI) high-risk cytogenetics t(4;14) del(17p) — Treatment: (1) Risk-stratify (R-ISS staging: β2M, albumin, LDH, cytogenetics): high-risk by FISH; (2) Transplant-eligible (age + comorbidity): induction with 4-drug regimen Daratumumab-VRd (DARA + bortezomib + lenalidomide + dexamethasone) × 4-6 cycles → autologous stem cell transplant (ASCT) → consolidation + lenalidomide maintenance (high-risk: longer/more intense maintenance); (3) Transplant-ineligible: DARA-VRd or DARA-Rd; (4) Supportive: bisphosphonate (zoledronate monthly) or denosumab (esp CKD) for skeletal events; surgery/RT/vertebroplasty for impending fracture/cord compression; manage hypercalcemia; hydration + careful loop diuretic; (5) Renal: optimize hydration, avoid nephrotoxin (NSAID, contrast), treat cast nephropathy with rapid disease control; possibly plasmapheresis if AKI + light chain; (6) Infection prophylaxis: TMP-SMX, acyclovir (especially with bortezomib + DARA — VZV), IVIG if hypogammaglobulinemia + recurrent infection; (7) Thromboprophylaxis with lenalidomide (aspirin or apixaban); (8) Anemia management (EPO, transfusion); (9) Vaccinations (PCV20, flu, COVID, RSV); (10) Refractory/relapsed: CAR-T (cilta-cel, ide-cel), bispecific (teclistamab — BCMA, talquetamab — GPRC5D, elranatamab); (11) Monitor: M-protein, FLC, β2M, monthly initially; long-term survivorship

---

Symptomatic multiple myeloma (MM) — IMWG 2014 + 2016 + 2024 update + NCCN guidelines: (1) Diagnosis: clonal bone marrow plasma cells ≥ 10% (or extramedullary plasmacytoma) + ≥ 1 myeloma-defining event: - CRAB: hyperCalcemia, Renal (Cr > 2 or CrCl < 40), Anemia (Hb < 10 or 2 below normal), Bone (≥ 1 lytic lesion on imaging). - SLiM biomarkers (added 2014): bone marrow plasma > 60%, serum FLC ratio > 100, > 1 focal lesion on MRI. (2) Differential: - MGUS (Monoclonal Gammopathy of Undetermined Significance): < 10% BM plasma + M-protein < 3 g/dL + no end-organ damage — observe, ~1%/yr progression. - Smoldering MM (SMM): 10-60% BM + M-protein ≥ 3 + no CRAB/SLiM — observe high-risk; trials of early treatment. - Solitary plasmacytoma. - Amyloidosis (AL). - Waldenström (IgM). (3) R-ISS staging (β2M, albumin, LDH, cytogenetics): stage I-III. High-risk cytogenetics by FISH: del(17p), t(4;14), t(14;16), t(14;20), 1q amplification — adverse outcomes. (4) Induction (transplant-eligible): - Quadruplet (current standard for newly diagnosed): - Daratumumab + bortezomib + lenalidomide + dexamethasone (DARA-VRd, GRIFFIN/PERSEUS trials). - Daratumumab + carfilzomib + lenalidomide + dexamethasone (DARA-KRd). - Triplet alternatives: VRd (without DARA). - 4-6 cycles → harvest → autologous SCT. (5) Transplant: - Eligible: ASCT (high-dose melphalan) — improves PFS + OS. - Tandem ASCT for high-risk. - Eligibility: age, performance, comorbid; chronologic age alone not exclusion. (6) Maintenance: lenalidomide ± DARA × 2+ yr (high-risk: indefinite, more intense). (7) Transplant-ineligible: DARA-Rd, DARA-VRd, VRd-lite. (8) Supportive: - Skeletal: bisphosphonate (zoledronate q3-4wk × 2 yr then prn) or denosumab (DEN preferred in CKD — no renal adjustment); dental clearance before (ONJ risk). - Hypercalcemia: hydration, calcitonin, bisphosphonate, treat disease. - Renal: hydration, avoid NSAIDs/contrast/aminoglycoside, dose-adjust drugs; cast nephropathy → rapid disease control; selected PLEX. - Infection: TMP-SMX (PCP), acyclovir (VZV with bortezomib/DARA), IVIG if recurrent + hypogamma. - Anemia: ESA, transfusion. - VTE prophylaxis with lenalidomide/thalidomide (aspirin or DOAC per risk). (9) Relapsed/refractory: triple-class refractory increasingly treated with CAR-T (idecabtagene vicleucel, ciltacabtagene autoleucel — BCMA), bispecifics (teclistamab, elranatamab — BCMA; talquetamab — GPRC5D); selinexor; ixazomib. (10) MRD monitoring (NGF, NGS) — informs prognosis + future treatment intensification. A ผิด — symptomatic = treat. C ผิด — dex alone palliative only. D ผิด — RT for symptom local control. E ผิด — surgery for cord compression.', NULL,
  'hard', 'hemato_onco', 'review',
  'internal_medicine', 'clinical_decision', 'hemato_onco', 'adult',
  'IMWG Updated Criteria for MM 2014/2024; NCCN Guidelines for Multiple Myeloma 2024; PERSEUS Trial DARA-VRd NEJM 2024; Mateos MV — IMWG MM Risk Stratification', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 68 ปี underlying HT มาด้วยปวดหลังเรื้อรัง 3 เดือน + อ่อนเพลีย + น้ำหนักลด 4 kg + recently fall จากเดินปกติ → กระดูกสันหลังหัก L2 ไม่มี trauma รุนแรง

V/S: BP 138/82, HR 88, RR 16, Temp 36.8°C
PE: pallor +, mid-back tenderness, no focal neuro deficit, no organomegaly, no lymphadenopathy

Lab: Hb 9.4 (normocytic, MCV 88), Cr 2.4 (baseline 1.0), Ca 11.8 (high), Phosphate 4.2, Albumin 3.0, Total protein 9.8 (HIGH — gamma-gap = 6.8), ALP 110 (NORMAL — characteristic in MM no osteoblastic), LDH 320
UA: protein 1+ but UPCR 4.8 g/g (heavy proteinuria); Bence-Jones positive (light chain proteinuria)
Serum protein electrophoresis: M-spike 4.2 g/dL in gamma region
Immunofixation: IgG kappa monoclonal
Serum free light chain ratio: kappa/lambda = 28 (markedly skewed)
Beta-2 microglobulin: 6.2 (high — stage III)
Skeletal survey: multiple lytic lesions skull, spine, pelvis, femur ("punched out")
Whole-body MRI/PET: > 10 lytic lesions
Bone marrow biopsy: 42% atypical plasma cells (> 10% diagnostic for MM); flow cytometry: clonal CD138+ kappa+ plasma cells; FISH: t(4;14), del(17p) → high-risk cytogenetics

CRAB: Calcium 11.8 (+), Renal Cr 2.4 (+), Anemia Hb 9.4 (+), Bone lytic lesions (+) — symptomatic MM'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 28 ปี ไม่มีโรคประจำตัว มา ED ด้วยปวดบวมขาขวา 3 วัน + ใหม่นี้เริ่มเจ็บอก pleuritic + เหนื่อย mild ไม่มี hemoptysis ก่อนหน้านี้กิน OCP (combined oral contraceptive) มา 6 เดือน ไม่สูบบุหรี่ ไม่มี recent surgery ไม่มี travel

V/S: BP 122/76, HR 102, RR 22, SpO2 95% RA, Temp 37.4°C
PE: right calf swelling 4 cm difference + tenderness + warmth, Homan sign positive (not specific), no skin changes other; chest clear, mild tachycardia

Lab: D-dimer 3,200 ng/mL (positive), CBC normal, Cr 0.8, hCG negative
Doppler US right lower extremity: occlusive thrombus right popliteal + femoral vein
CT pulmonary angiography: small subsegmental PE bilateral, RV/LV ratio normal, no RV strain
Family history: mother had DVT during pregnancy; brother PE age 30
No prior VTE
Well''s DVT score: 4 (likely)', '[{"label":"A","text":"Aspirin 81 mg + observation"},{"label":"B","text":"Acute proximal DVT + low-risk PE in young female + suggestive thrombophilia family history"},{"label":"C","text":"Long-term warfarin only"},{"label":"D","text":"Thrombolysis IV tPA"},{"label":"E","text":"IVC filter as primary treatment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute proximal DVT + low-risk PE in young female + suggestive thrombophilia family history — Anticoagulation: (1) DOAC (rivaroxaban 15 mg BID × 21 d → 20 mg/d, or apixaban 10 mg BID × 7 d → 5 mg BID) — preferred first-line per ACCP/CHEST 2021 + ASH 2020 (non-cancer); LMWH (enoxaparin 1 mg/kg q12h) bridge if dabigatran/edoxaban or planning warfarin; (2) Duration: minimum 3 months for provoked (here OCP is provoking factor — removable); 6-12 mo to indefinite if unprovoked or persistent risk; (3) Stop OCP immediately + counsel re alternative non-estrogen contraception (progesterone-only, copper IUD, barrier); (4) Thrombophilia workup considered AFTER acute treatment + at least 2 weeks off anticoagulant + 6 weeks post-event: factor V Leiden, prothrombin G20210A, antithrombin III, protein C, protein S, antiphospholipid (lupus anticoagulant, anticardiolipin, β2-GP1) — given strong family history. Findings may extend or change anticoagulation approach (APS = warfarin not DOAC per TRAPS); (5) Compression stocking for DVT symptom control + post-thrombotic syndrome prevention (controversial benefit per SOX trial); (6) Mobilize early (no benefit bed rest); (7) Outpatient management OK in stable PE (HESTIA criteria); (8) Family member counseling re thrombophilia screening + pregnancy/OCP risk

---

Acute VTE — proximal DVT + small subsegmental PE without RV strain (low-risk). ACCP/CHEST 2021 + ASH 2020 VTE guideline: (1) Diagnosis: D-dimer + imaging (US for DVT, CT-PA for PE, V/Q in pregnancy/contrast allergy). Well''s score, PERC rule for low-risk PE rule-out. (2) Anticoagulation choice: - **DOAC first-line** for non-cancer-associated VTE (CHEST 2021 Grade 1B): - Rivaroxaban: 15 mg BID × 21 d → 20 mg/d. - Apixaban: 10 mg BID × 7 d → 5 mg BID. - Dabigatran, edoxaban: require LMWH 5-10 d lead-in. - DOAC > VKA: less major bleeding, fixed dose, no monitoring; restrictions in APS (use VKA per TRAPS), severe renal/hepatic, mechanical valve. - Cancer-associated: LMWH or DOAC (apixaban, edoxaban — non-GI cancer; CARAVAGGIO, Hokusai-VTE Cancer). - LMWH preferred in pregnancy (DOAC contraindicated); switch to warfarin postpartum if breastfeeding (apixaban in non-breastfeeding). (3) Duration: - **3 months minimum** for provoked + removable risk factor (post-surgical, immobilization, OCP). - **6-12 months** for unprovoked (some recommend indefinite based on bleeding risk; HERDOO2, Vienna scores). - **Indefinite** for cancer (until cancer resolved), antiphospholipid syndrome (warfarin INR 2-3), recurrent VTE, strong persistent thrombophilia. - Reduced-dose DOAC for extended phase (rivaroxaban 10 mg/d, apixaban 2.5 mg BID per AMPLIFY-EXT, EINSTEIN-CHOICE). (4) PE risk stratification (PESI, sPESI, Bova): low → outpatient with HESTIA criteria; intermediate-high → admit, monitor for decompensation; massive → thrombolysis (alteplase) or catheter-directed. (5) IVC filter: only if contraindication to anticoagulation (active bleeding) or recurrence on anticoagulation; remove when no longer needed. (6) Thrombophilia testing: - Indications: unprovoked < 50 yr, strong family history, recurrent, unusual sites, pregnancy/OCP losses, multiple losses; APS testing for arterial thrombosis or pregnancy losses. - Timing: after 2-4 weeks off DOAC; protein C/S during warfarin unreliable; not in acute phase (depletion). - Testing: factor V Leiden, prothrombin G20210A, antithrombin, protein C/S, APS (LA, ACL, β2-GP1 × 2 separated 12 wk). (7) OCP/HRT: stop on VTE; counsel non-estrogen contraception. (8) Compression stockings: SOX trial neutral — not routine; symptomatic relief OK. (9) Pregnancy: LMWH; postpartum 6 wk minimum. (10) Travel precautions: ambulation, hydration, compression stocking. A ผิด — ASA inadequate. C ผิด — DOAC preferred. D ผิด — thrombolysis for massive PE. E ผิด — filter not primary.', NULL,
  'medium', 'hemato_onco', 'review',
  'internal_medicine', 'clinical_decision', 'hemato_onco', 'adult',
  'CHEST Guideline on Antithrombotic Therapy for VTE 2021; ASH VTE Guidelines 2020; CARAVAGGIO NEJM 2020; EINSTEIN-CHOICE NEJM 2017', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 28 ปี ไม่มีโรคประจำตัว มา ED ด้วยปวดบวมขาขวา 3 วัน + ใหม่นี้เริ่มเจ็บอก pleuritic + เหนื่อย mild ไม่มี hemoptysis ก่อนหน้านี้กิน OCP (combined oral contraceptive) มา 6 เดือน ไม่สูบบุหรี่ ไม่มี recent surgery ไม่มี travel

V/S: BP 122/76, HR 102, RR 22, SpO2 95% RA, Temp 37.4°C
PE: right calf swelling 4 cm difference + tenderness + warmth, Homan sign positive (not specific), no skin changes other; chest clear, mild tachycardia

Lab: D-dimer 3,200 ng/mL (positive), CBC normal, Cr 0.8, hCG negative
Doppler US right lower extremity: occlusive thrombus right popliteal + femoral vein
CT pulmonary angiography: small subsegmental PE bilateral, RV/LV ratio normal, no RV strain
Family history: mother had DVT during pregnancy; brother PE age 30
No prior VTE
Well''s DVT score: 4 (likely)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 78 ปี ไม่มีโรคประจำตัวเดิม มาด้วยอ่อนเพลีย + dyspnea on exertion 6 เดือน + pale + ไม่มี bleeding ไม่มี jaundice

V/S: BP 138/82, HR 92, RR 18, SpO2 96%, Temp 36.8°C
PE: pallor, no jaundice, no organomegaly, no lymphadenopathy, no rash

Lab: Hb 8.4 (low), MCV 108 (macrocytic), MCH 35, RDW 18 (high), Reticulocyte 0.8% (low for degree of anemia)
WBC 3,800 (mild leukopenia), Plt 105,000 (mild thrombocytopenia)
B12 92 pg/mL (low; normal > 200), Folate normal, MMA + homocysteine elevated
LDH 480 (high — ineffective erythropoiesis), Bilirubin 1.4 (indirect 0.8 — mild hemolysis), Haptoglobin 80
Anti-intrinsic factor antibody positive; anti-parietal cell antibody positive
Gastric biopsy: chronic atrophic gastritis with intestinal metaplasia + absent parietal cells in body
Neuro: glossitis +, mild paresthesia distal lower extremity, mild gait ataxia, decreased vibration sense lower extremity, no spastic paraparesis yet, Romberg + (early subacute combined degeneration?)', '[{"label":"A","text":"Oral folate alone"},{"label":"B","text":"Pernicious anemia (autoimmune chronic atrophic gastritis with IF antibody +) with B12 deficiency + early neurologic involvement"},{"label":"C","text":"Iron + EPO empirical for anemia"},{"label":"D","text":"Bone marrow biopsy mandatory before treatment"},{"label":"E","text":"Single oral B12 dose monthly only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pernicious anemia (autoimmune chronic atrophic gastritis with IF antibody +) with B12 deficiency + early neurologic involvement — Treatment: (1) Vitamin B12 (cyanocobalamin or hydroxocobalamin) replacement: IM 1000 mcg daily × 1 wk → weekly × 4 wk → monthly lifelong (alternative oral 1000-2000 mcg/d effective in many — passive diffusion 1% absorption, Cochrane non-inferior; but IM preferred in initial replacement + neurologic symptoms + severe deficiency); (2) Treat folate AFTER B12 — folate alone in B12 deficient = precipitate neurologic deterioration ("masking" hematologic improvement while neuro progresses); (3) Reticulocytosis at 5-10 d confirms response; CBC normalizes 4-6 wk; B12 / homocysteine / MMA normalize; (4) Neurologic recovery: gradual months; complete in early; residual if delayed > 6 mo from onset; (5) Monitor for hypokalemia first 48 hr (rapid erythropoiesis); (6) Address autoimmune polyendocrine associations (hypothyroid, T1DM, Addison, vitiligo) — screen; (7) Gastric cancer surveillance: PA has 2-3× ↑ gastric adenocarcinoma + neuroendocrine tumor risk; periodic endoscopy 3-5 yr for chronic atrophic gastritis; (8) Iron deficiency may coexist with PA — check ferritin; (9) Patient education: lifelong replacement, recognize relapse, vegan dietary B12 (different cause but same Rx); (10) Caregivers / family education on injection / supplement adherence

---

Vitamin B12 deficiency from pernicious anemia (PA) — autoimmune chronic atrophic gastritis with anti-IF antibody (most specific) + anti-parietal cell antibody. Clinical clues: macrocytic anemia (MCV > 100), ineffective erythropoiesis (↑ LDH, indirect bilirubin, low retic), pancytopenia possible (mild here), neurologic (paresthesia, ataxia, subacute combined degeneration of dorsal + lateral columns, dementia, mood), glossitis, megaloblastic changes BM (hypersegmented PMN, megaloblasts). British Society for Haematology + Stabler NEJM 2013 B12 guideline: (1) Diagnosis: - Serum B12 < 200 pg/mL (or < 148 pmol/L) — variable thresholds; intermediate 200-300 → confirm with MMA + homocysteine (both ↑ in B12 def; MMA only ↑ in B12 def, not folate def — distinguishes). - Anti-IF antibody (60% sensitive, > 90% specific) — diagnostic for PA. - Anti-parietal cell antibody (less specific). - Schilling test obsolete. (2) Etiology: - PA (most common — Northern European elderly). - Strict vegan diet. - Gastric: gastrectomy, atrophic gastritis (H. pylori), gastric bypass. - Terminal ileum: Crohn, resection, tropical sprue, fish tapeworm (Diphyllobothrium). - Drugs: metformin (chronic, mild), PPI (chronic), N2O (recreational/anesthetic — irreversible methionine synthase inhibition; severe SCD case reports). (3) Treatment: - **Replacement**: - IM B12 1000 mcg daily × 1 wk → weekly × 4 wk → monthly lifelong (cyanocobalamin or hydroxocobalamin). - Oral B12 1000-2000 mcg/d — Cochrane: non-inferior to IM in non-severe; passive absorption 1% bypasses IF; option for chronic. - Initial preference IM in severe + neurologic involvement + symptomatic. - **Do NOT give folate alone before B12 correction** — corrects MA but worsens/unmasks neurologic deterioration. - Monitor reticulocytosis day 5-10 (response confirms diagnosis); normalize CBC 4-6 wk; MMA + homocysteine normalize. - Watch hypokalemia first 48 hr (rapid intracellular K shift with erythropoiesis); supplement K. - Neurologic recovery may be partial if delayed Dx > 6 mo. (4) Iron coexists in 25% PA (parietal cell loss → low acid → reduced Fe absorption); check ferritin. (5) Endocrinopathy associations (APS-2): hypothyroidism, T1DM, vitiligo, Addison — screen. (6) Gastric cancer surveillance: PA = 2-3× ↑ gastric adenocarcinoma + neuroendocrine tumor risk; periodic EGD 3-5 yr. (7) Folate deficiency Rx: oral 1-5 mg/d × 3-4 mo; after B12 sufficient. (8) Pediatric / pregnancy: critical for fetal neural tube; folate supplement before/during. A ผิด — folate alone harmful. C ผิด — wrong type anemia. D ผิด — overinvasive. E ผิด — schedule wrong.', NULL,
  'medium', 'hemato_onco', 'review',
  'internal_medicine', 'clinical_decision', 'hemato_onco', 'adult',
  'British Society for Haematology Cobalamin and Folate Deficiency Guideline 2014; Stabler SP NEJM 2013; Lechner K B12 Deficiency Review', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 78 ปี ไม่มีโรคประจำตัวเดิม มาด้วยอ่อนเพลีย + dyspnea on exertion 6 เดือน + pale + ไม่มี bleeding ไม่มี jaundice

V/S: BP 138/82, HR 92, RR 18, SpO2 96%, Temp 36.8°C
PE: pallor, no jaundice, no organomegaly, no lymphadenopathy, no rash

Lab: Hb 8.4 (low), MCV 108 (macrocytic), MCH 35, RDW 18 (high), Reticulocyte 0.8% (low for degree of anemia)
WBC 3,800 (mild leukopenia), Plt 105,000 (mild thrombocytopenia)
B12 92 pg/mL (low; normal > 200), Folate normal, MMA + homocysteine elevated
LDH 480 (high — ineffective erythropoiesis), Bilirubin 1.4 (indirect 0.8 — mild hemolysis), Haptoglobin 80
Anti-intrinsic factor antibody positive; anti-parietal cell antibody positive
Gastric biopsy: chronic atrophic gastritis with intestinal metaplasia + absent parietal cells in body
Neuro: glossitis +, mild paresthesia distal lower extremity, mild gait ataxia, decreased vibration sense lower extremity, no spastic paraparesis yet, Romberg + (early subacute combined degeneration?)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 35 ปี ไม่มีโรคประจำตัว ตั้งครรภ์ GA 30 weeks มา ED ด้วยปวดหลังร้าวลงขา + ไข้ 39.0°C + costovertebral angle tenderness + คลื่นไส้ อาเจียน 2 วัน

V/S: BP 96/58, HR 122, RR 22, SpO2 97%, Temp 39.2°C
PE: gravid uterus appropriate, CVA tenderness right, no peritoneal signs, mild contractions q15min (not productive)

Lab: WBC 19,400 (N 92%), Hb 10.4, Plt 168,000, Cr 1.0 (slightly elevated for pregnancy), Lactate 2.2, glucose 88
UA: leukocyte esterase ++, nitrite +, WBC > 50/HPF, bacteria many, RBC few; urine culture pending
Blood culture × 2 pending
US kidneys: mild right hydronephrosis (physiologic of pregnancy + UTI), no abscess, no obstructing stone
Fetal heart rate normal, no preterm labor active', '[{"label":"A","text":"Oral nitrofurantoin × 5 d outpatient"},{"label":"B","text":"Acute pyelonephritis in pregnancy with sepsis"},{"label":"C","text":"Outpatient management without antibiotic"},{"label":"D","text":"Watchful waiting for spontaneous resolution"},{"label":"E","text":"Fluoroquinolone IV ciprofloxacin first-line"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute pyelonephritis in pregnancy with sepsis — Admission + IV antibiotics + supportive: (1) Empirical IV antibiotic — covering common uropathogens (E. coli, Klebsiella, Proteus) + pregnancy safety: ceftriaxone 1-2 g/d IV (1st choice) OR cefepime 1 g q12h (preferred when Pseudomonas concern); avoid TMP-SMX in 3rd trimester (kernicterus near term) + 1st trimester (NTD); avoid fluoroquinolone in pregnancy (cartilage); avoid aminoglycoside if possible (fetal nephro/ototoxicity); avoid nitrofurantoin in 3rd trimester near delivery (hemolytic anemia neonate G6PD); (2) IV fluid resuscitation for sepsis + monitor BP/UO/lactate; (3) Switch to oral after clinical improvement + afebrile 24-48 hr; total duration 10-14 d; (4) Fetal monitoring + tocolysis if preterm labor (corticosteroid for fetal lung maturity if < 34 wk + at risk); (5) Suppressive antibiotic prophylaxis for remainder of pregnancy (nitrofurantoin until 36 wk, cephalexin) — recurrence risk 6-8x; (6) Urine culture 1-2 weeks after treatment + monthly during remaining pregnancy; (7) Follow-up imaging if not improving (rule out abscess, obstruction); (8) Counsel: hydration, hygiene, void after intercourse, complete antibiotic course, return precautions (worsening pain, fever, contractions); (9) ASB (asymptomatic bacteriuria) in pregnancy MUST be treated (different from non-pregnant) — reduces pyelonephritis + preterm + LBW (Cochrane)

---

Acute pyelonephritis in pregnancy with sepsis. Pregnancy ↑ UTI risk (ureteral dilation, smooth muscle relaxation from progesterone, glucosuria, immune changes). IDSA + ACOG UTI in Pregnancy + EAU guideline: (1) Spectrum: - Asymptomatic bacteriuria (ASB): screen at first prenatal visit (urine culture); treat in pregnancy (unlike non-pregnant) — reduces pyelo, preterm, LBW; nitrofurantoin (avoid 3rd trimester near delivery, G6PD), cephalexin, fosfomycin × 5-7 d. - Acute cystitis: similar oral antibiotics × 5-7 d. - Acute pyelonephritis: admit + IV antibiotic. (2) Pyelonephritis management: - Admission: pregnancy + sepsis or unable PO. - IV empiric antibiotic: - Ceftriaxone 1-2 g/d (1st choice, broad coverage, safe). - Cefepime 1 g q12h (Pseudomonas concern). - Piperacillin-tazobactam if severe sepsis + nosocomial. - Avoid: fluoroquinolone (cartilage), aminoglycoside (8th nerve + nephro fetal — only if life-threatening), TMP-SMX (NTD 1st tri, kernicterus 3rd), nitrofurantoin late 3rd tri (hemolysis G6PD newborn). - IV fluid + supportive sepsis bundle. - Step-down to oral after afebrile 24-48 hr; total 10-14 d. - Suppressive prophylaxis post-treatment for rest of pregnancy (nitrofurantoin 50 mg qhs until 36 wk OR cephalexin 250 mg qhs) — recurrence risk 6-8x. (3) Maternal monitoring: BP, HR, UO, lactate, septic complications (ARDS — increased in pyelo of pregnancy due to endotoxin + capillary leak). (4) Fetal monitoring: NST, ultrasound; tocolysis (nifedipine) for preterm contractions; antenatal corticosteroid (betamethasone) for fetal lung maturity if 24-34 wk + risk of delivery within 7 d. (5) Imaging if no improvement 48-72 hr: US for hydronephrosis (physiologic + pathologic), abscess, obstruction; MRI without contrast if needed; CT only if essential. (6) Renal calculi management: stent or nephrostomy preferred over lithotripsy in pregnancy. (7) Postpartum: continue surveillance; structural workup if recurrent (US, MRI). (8) Maternal sepsis: leading cause of maternal mortality; high index of suspicion. A ผิด — sepsis = IV admit. C ผิด — pyelo needs antibiotic. D ผิด — sepsis + pregnancy. E ผิด — FQ contraindicated.', NULL,
  'medium', 'id', 'review',
  'internal_medicine', 'clinical_decision', 'id', 'adult',
  'IDSA Guidelines for ASB 2019; ACOG Practice Bulletin 91: Asymptomatic Bacteriuria + Pyelonephritis in Pregnancy; EAU Guidelines on Urological Infections 2024', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 35 ปี ไม่มีโรคประจำตัว ตั้งครรภ์ GA 30 weeks มา ED ด้วยปวดหลังร้าวลงขา + ไข้ 39.0°C + costovertebral angle tenderness + คลื่นไส้ อาเจียน 2 วัน

V/S: BP 96/58, HR 122, RR 22, SpO2 97%, Temp 39.2°C
PE: gravid uterus appropriate, CVA tenderness right, no peritoneal signs, mild contractions q15min (not productive)

Lab: WBC 19,400 (N 92%), Hb 10.4, Plt 168,000, Cr 1.0 (slightly elevated for pregnancy), Lactate 2.2, glucose 88
UA: leukocyte esterase ++, nitrite +, WBC > 50/HPF, bacteria many, RBC few; urine culture pending
Blood culture × 2 pending
US kidneys: mild right hydronephrosis (physiologic of pregnancy + UTI), no abscess, no obstructing stone
Fetal heart rate normal, no preterm labor active'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 65 ปี underlying CKD stage 4 (eGFR 22), DM, anemia of CKD on EPO มา OPD ติดตาม

ลgnose ของ CKD: DM nephropathy + HT
Medications: insulin glargine + lispro, lisinopril 40 mg, amlodipine 10 mg, furosemide 40 mg, sodium bicarbonate 650 mg TID, calcium acetate 667 mg with meals, erythropoietin 4000 U weekly SC

V/S: BP 152/88, HR 76
No edema, no SOB, no anorexia

Lab: Cr 3.2 (stable), eGFR 22, BUN 56, K 5.4, Na 138, Cl 110, HCO3 18, Ca 8.4 (after corrected for albumin), Phosphate 6.2 (high), PTH 380 (elevated, secondary hyperPTH), 25-OH Vitamin D 18 (insufficient)
Hb 9.4 (target 10-11), iron studies: ferritin 220, TSAT 18% (low — relative iron deficiency)
A1c 7.4%, microalbumin/Cr 540 (severe albuminuria), urine glucose 1+
Lipid: LDL 102

คำถาม: CKD-MBD + anemia + slowing progression management', '[{"label":"A","text":"No further intervention; continue current"},{"label":"B","text":"Comprehensive CKD stage 4 management"},{"label":"C","text":"Stop all medications + low-protein diet only"},{"label":"D","text":"Start dialysis immediately regardless of symptoms"},{"label":"E","text":"Increase EPO to target Hb > 13"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Comprehensive CKD stage 4 management: (1) **Slow progression**: maximize RAS blockade (ACEi at maximum tolerated dose — already lisinopril 40 mg; ARB alternative if cough; SGLT2 inhibitor (dapagliflozin 10 mg or empagliflozin) — DAPA-CKD, EMPA-KIDNEY trials showed RRR ~30% CKD progression + CV mortality regardless of glycemic status in CKD with albuminuria, safe down to eGFR 20-25); finerenone (non-steroidal MRA, FIDELIO-DKD, FIGARO-DKD) — albuminuric DKD additional renoprotection; tight BP < 130/80 (SPRINT individualized); A1c 7-8% (loose in advanced CKD); (2) **Metabolic acidosis** (HCO3 18 < 22): sodium bicarbonate to target HCO3 22-24 — slows progression + improves muscle/bone; (3) **CKD-MBD**: phosphate restriction + binder (calcium acetate or non-Ca binder sevelamer/lanthanum to avoid hypercalcemia); activated vitamin D (calcitriol, alfacalcidol) for secondary hyperPTH; cinacalcet (calcimimetic) if persistent + Ca high; native vitamin D supplementation (25-OH < 30); target Ca-Phos product < 55, PTH 2-9× ULN in CKD 4; (4) **Anemia**: continue EPO; check iron status (TSAT 18% suboptimal — IV iron sucrose/ferric carboxymaltose to TSAT > 20%, ferritin > 100 in non-dialysis CKD); target Hb 10-11 (not > 11.5 — CHOIR, TREAT trials showed harm at higher targets); HIF-PHi (roxadustat — recent option, MI/MACE concern in CV disease); (5) **Hyperkalemia**: dietary K restriction + new K binders (patiromer, sodium zirconium cyclosilicate) — allow continued RAS blockade despite K rise; (6) **Dialysis preparation**: vascular access (AVF — arteriovenous fistula creation ≥ 6 mo before anticipated start) for HD; PD catheter alternative; transplant eligibility evaluation + listing (preemptive transplant best); patient education re modality choice + conservative care option; (7) Vaccinations (HBV series — higher dose; pneumococcal, flu, COVID); (8) Nephro-cardiology cross-care

---

Chronic kidney disease stage 4 (eGFR 15-29) — pre-dialysis, comprehensive management for slow progression + complication management. KDIGO 2024 CKD + KDIGO 2022 Diabetes in CKD + 2017 CKD-MBD guideline: (1) **Slow CKD progression**: - RAS inhibitor (ACEi/ARB): max tolerated; target BP < 130/80 (CKD); reduce albuminuria. - SGLT2 inhibitor (dapagliflozin, empagliflozin): DAPA-CKD, EMPA-KIDNEY trials show 30% RRR CKD progression + CV events; benefit in DM + non-DM; safe down to eGFR 20-25. Mainstay now. - Finerenone (non-steroidal MRA): FIDELIO/FIGARO — DKD with albuminuria, K monitoring. - GLP-1 RA (semaglutide): FLOW trial 2024 — renoprotection in DKD. - Glycemic: A1c individualized (7-8% advanced CKD; CGM, avoid hypoglycemia). - BP: < 130/80 (SPRINT individualized in elderly/CKD; KDIGO < 120 SBP individualized). - Lifestyle: weight, exercise, smoking cessation, sodium < 2 g/d, protein 0.8 g/kg/d (avoid < 0.6, malnutrition). (2) **CKD-MBD** (mineral bone disorder): - Phosphate: restrict dietary (avoid high-phos foods, additives); phosphate binders (calcium-containing or non-Ca: sevelamer, lanthanum, ferric citrate) — avoid hypercalcemia, vascular calcification. - PTH: target 2-9× ULN in CKD 4; treat secondary hyperPTH with calcitriol or analogs (paricalcitol, doxercalciferol), cinacalcet (calcimimetic) if Ca high. - 25-OH Vit D: replete if < 30. - Bone: DXA, bone biopsy in refractory. - Avoid: high Ca, high vit D, oversuppression PTH (adynamic bone). (3) **Metabolic acidosis** (HCO3 < 22): sodium bicarbonate 0.5-1 mEq/kg/d to HCO3 22-24 — UBI study showed slower progression + improved muscle/bone (controversy Veverka/BiCARB). (4) **Anemia**: - Workup: iron (TSAT, ferritin), B12, folate, blood loss, hemolysis. - Target Hb 10-11 (not > 11.5 — CHOIR, TREAT, CREATE showed ↑ stroke/CV/cancer at higher targets). - IV iron preferred in non-dialysis CKD (TSAT > 20%, ferritin > 100). - ESA (epoetin, darbepoetin) for Hb < 10 after iron repletion; target lower of normal range. - HIF-PH inhibitors (roxadustat, daprodustat) — newer; CV concern (PYRENEES) — selected. (5) **Hyperkalemia**: dietary, RAS modification (continue if possible), K binders (patiromer, sodium zirconium cyclosilicate — chronic). (6) **Dialysis prep** (eGFR < 30 — KDOQI; eGFR 15-20 + symptoms): - Vascular access: AVF creation ≥ 6 mo before anticipated HD start (KDIGO 2019). - Modality discussion: HD, PD, home; transplant. - Conservative care if frail/poor prognosis. - Patient education programs. (7) **Transplant evaluation**: eGFR < 20 — refer for listing; preemptive transplant best outcomes; living donor preferred. (8) **CV risk**: highest cause of death in CKD; statin, ASA per indication, lifestyle. (9) **Vaccinations**: HBV (higher dose 40 mcg × 4 — Engerix-B 2 mL); pneumococcal PCV20/PPSV23; influenza annual; COVID; zoster. (10) **Drug dosing**: many drugs need renal adjustment; avoid nephrotoxins (NSAID, contrast, aminoglycoside); deprescribe. A ผิด — many gaps. C ผิด — too restrictive, missing meds. D ผิด — no current indication. E ผิด — high Hb harmful.', NULL,
  'medium', 'renal_gu', 'review',
  'internal_medicine', 'clinical_decision', 'renal_gu', 'adult',
  'KDIGO 2024 CKD Evaluation and Management; KDIGO 2022 Diabetes Management in CKD; KDIGO 2017 CKD-MBD; DAPA-CKD NEJM 2020; EMPA-KIDNEY NEJM 2023; FIDELIO-DKD NEJM 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 65 ปี underlying CKD stage 4 (eGFR 22), DM, anemia of CKD on EPO มา OPD ติดตาม

ลgnose ของ CKD: DM nephropathy + HT
Medications: insulin glargine + lispro, lisinopril 40 mg, amlodipine 10 mg, furosemide 40 mg, sodium bicarbonate 650 mg TID, calcium acetate 667 mg with meals, erythropoietin 4000 U weekly SC

V/S: BP 152/88, HR 76
No edema, no SOB, no anorexia

Lab: Cr 3.2 (stable), eGFR 22, BUN 56, K 5.4, Na 138, Cl 110, HCO3 18, Ca 8.4 (after corrected for albumin), Phosphate 6.2 (high), PTH 380 (elevated, secondary hyperPTH), 25-OH Vitamin D 18 (insufficient)
Hb 9.4 (target 10-11), iron studies: ferritin 220, TSAT 18% (low — relative iron deficiency)
A1c 7.4%, microalbumin/Cr 540 (severe albuminuria), urine glucose 1+
Lipid: LDL 102

คำถาม: CKD-MBD + anemia + slowing progression management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 62 ปี มา ED ด้วยปวดอกร้าวไปหลังรุนแรงทันที onset 30 นาทีก่อน "แบบฉีกขาด" + เหงื่อแตก + เป็นลม

V/S: BP แขนขวา 198/110, แขนซ้าย 162/88 (pulse differential 36 mmHg), HR 108, RR 24, SpO2 97%
PE: diastolic murmur LSB grade 2/6 (new AR), no JVP elevation, pulse deficits, no cardiac tamponade signs yet

EKG: sinus tach, no ST elevation, no Q waves, LVH
CXR: widened mediastinum + abnormal aortic contour
CT angiography aorta: type A aortic dissection from aortic root to arch + iliac extension, intimal flap visible, no pericardial effusion yet, no organ malperfusion currently
Troponin negative
Cr 1.0, Hb 13.4', '[{"label":"A","text":"Conservative medical management with antihypertensive + observe"},{"label":"B","text":"Acute Stanford Type A aortic dissection"},{"label":"C","text":"Thrombolytic IV tPA"},{"label":"D","text":"Heparin anticoagulation"},{"label":"E","text":"Coronary angiography first"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Stanford Type A aortic dissection — SURGICAL EMERGENCY: (1) Immediate cardiac surgery consult + transfer OR if needed — open aortic repair (replacement of ascending aorta ± valve ± arch); untreated mortality 1-2%/hr first 24 hr; (2) Pre-op medical optimization: target SBP 100-120 + HR < 60 — IV beta-blocker first (esmolol drip or labetalol) BEFORE vasodilator (avoid reflex tachycardia from pure vasodilator alone); then add IV nitroprusside or nicardipine if BP not controlled with BB alone; (3) Pain control IV morphine/fentanyl; (4) Avoid thrombolytic, anticoagulant (worsens hemorrhage); (5) Type B (descending only) — usually medical first (BP/HR control) + endovascular TEVAR for complicated (malperfusion, rupture, refractory pain, rapid expansion); (6) ICU monitoring continuous arterial line, foley, frequent neuro exam (CVA from arch involvement), limb perfusion; (7) Watch for complications: cardiac tamponade, aortic regurgitation, coronary involvement (RCA → inferior MI), stroke, mesenteric/renal/limb ischemia; (8) Post-op lifelong BP control + surveillance imaging

---

Acute aortic dissection. Stanford classification: Type A = involves ascending aorta (surgical emergency); Type B = distal to left subclavian (medical first). AHA/ACC + ESC + AATS aortic guideline: (1) Recognition: tearing chest/back pain, BP/pulse asymmetry, mediastinal widening, AR murmur, neurologic deficit, malperfusion, syncope. (2) Imaging: CT angiography (gold standard if stable), TEE (intraoperative or unstable), MRA. D-dimer high sensitivity but not diagnostic alone. (3) Type A management: emergent surgical repair (replacement of ascending aorta ± valve ± arch ± aortic root); untreated mortality 1-2%/hr first 48 hr. (4) Type B management: - Uncomplicated: medical therapy alone — beta-blocker + ACEi long-term, BP < 130/80. - Complicated (malperfusion, rupture, refractory pain, rapid expansion): TEVAR (thoracic endovascular aortic repair) — INSTEAD trial. (5) Medical optimization (both types): - Target HR < 60 + SBP 100-120. - Beta-blocker first (esmolol IV drip, labetalol) — reduces shear stress dP/dt. - Then add vasodilator (nicardipine, nitroprusside) if BP not controlled — never give vasodilator alone first (reflex tachycardia → ↑ dP/dt → propagation). - IV opioid for pain (also reduces sympathetic). - Avoid thrombolytic, anticoagulant, aspirin acutely. (6) Coronary involvement (RCA in 10-20% of Type A) — inferior MI; don''t delay surgery for cath. (7) Complications: cardiac tamponade (pericardial rupture), severe AR, coronary occlusion, stroke (arch vessels), mesenteric/renal/limb malperfusion. (8) Long-term: BP control mandatory (< 130/80, beta-blocker + ACEi), serial CT/MRA surveillance, lifestyle, family screening (Marfan, Loeys-Dietz, Ehlers-Danlos, bicuspid aortopathy, family aneurysm history). A ผิด — Type A = surgery. C ผิด — thrombolytic worsens. D ผิด — anticoag worsens. E ผิด — coronary delay risks death.', NULL,
  'medium', 'cardiovascular', 'review',
  'internal_medicine', 'clinical_decision', 'cardiovascular', 'adult',
  'AHA/ACC 2022 Guideline for the Diagnosis and Management of Aortic Disease; ESC 2014 Guidelines on the Diagnosis and Treatment of Aortic Diseases', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 62 ปี มา ED ด้วยปวดอกร้าวไปหลังรุนแรงทันที onset 30 นาทีก่อน "แบบฉีกขาด" + เหงื่อแตก + เป็นลม

V/S: BP แขนขวา 198/110, แขนซ้าย 162/88 (pulse differential 36 mmHg), HR 108, RR 24, SpO2 97%
PE: diastolic murmur LSB grade 2/6 (new AR), no JVP elevation, pulse deficits, no cardiac tamponade signs yet

EKG: sinus tach, no ST elevation, no Q waves, LVH
CXR: widened mediastinum + abnormal aortic contour
CT angiography aorta: type A aortic dissection from aortic root to arch + iliac extension, intimal flap visible, no pericardial effusion yet, no organ malperfusion currently
Troponin negative
Cr 1.0, Hb 13.4'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 78 ปี underlying HF, T2DM, prior MI ก่อน 2 ปี on optimal medical therapy (carvedilol 25 mg BID, sacubitril/valsartan, spironolactone, empagliflozin, ASA) มา ED ด้วยใจสั่น + วิงเวียน + ไม่ syncope

V/S: BP 102/64, HR 38 (slow), RR 18, SpO2 97%, Temp 36.8°C
EKG: 2nd degree AV block Mobitz Type II (constant PR with sudden non-conducted P; sometimes 2:1 conduction), wide QRS 130 ms, sinus rhythm underneath
Lab: K 4.2, Mg 2.0, Cr 1.4, Ca 9.2, TSH 1.8, troponin negative
Medication review: recently started higher dose metoprolol (replaced carvedilol; mistake) → likely contributory but also infranodal disease based on EKG
No digoxin, no diltiazem, no antiarrhythmic
No Lyme, no infiltrative cardiomyopathy clue', '[{"label":"A","text":"Atropine IV 0.5 mg + observe"},{"label":"B","text":"Mobitz Type II AV block with wide QRS = infranodal block, high-risk for progression to complete heart block"},{"label":"C","text":"Increase metoprolol dose to suppress arrhythmia"},{"label":"D","text":"Digoxin therapy"},{"label":"E","text":"ICD without pacing function"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mobitz Type II AV block with wide QRS = infranodal block, high-risk for progression to complete heart block — (1) Identify + remove reversible causes: review medication (over-rate-controlling agents, AV-blockers), electrolytes (K, Mg, Ca), thyroid, ischemia (rule out ACS), infiltration (sarcoid, amyloid, hemochromatosis); (2) Stop offending beta-blocker temporarily; (3) Atropine 0.5 mg IV — limited benefit in infranodal (works at AV node, not below); transcutaneous pacing pads on standby; transvenous pacing if hemodynamically unstable or progresses to CHB; (4) Permanent pacemaker indicated (Class I per 2018 ACC/AHA/HRS bradycardia guideline): - Symptomatic Mobitz II (regardless of cause). - Mobitz II with wide QRS or block below the bundle of His (here both). - High-grade AV block (≥ 2 consecutive non-conducted P). - 3rd degree AV block (CHB) symptomatic or with broad QRS escape. (5) Single-chamber (VVI) vs dual-chamber (DDD) — DDD preferred for AV synchrony in those with intact SA node + AV conduction issues; CRT (biventricular) considered if HFrEF + expected high RV pacing burden (HOT-CRT, BLOCK HF); His bundle pacing / left bundle area pacing — physiologic; (6) Pre-implant: device counseling, MRI compatibility, driving restrictions, infection prophylaxis (cephazolin), bleeding risk (DOAC hold)

---

Mobitz Type II AV block — infranodal (below AV node, His-Purkinje system), high progression risk to complete heart block + ventricular standstill. EKG: constant PR interval with sudden non-conducted P (vs Mobitz I/Wenckebach = progressive PR lengthening, AV nodal, lower risk). Wide QRS suggests bundle branch disease. ACC/AHA/HRS 2018 Bradycardia + ESC 2021 Pacing guideline: (1) Reversible causes: medication (BB, CCB, digoxin, antiarrhythmic, clonidine), electrolyte (K, Mg, Ca), hypothyroid, ischemia, Lyme, sarcoid, amyloid, infiltrative, vagal hypertonia, post-cardiac surgery, congenital. (2) Acute management: - Stable: monitor, treat reversible. - Symptomatic/unstable: atropine 0.5 mg q3-5 min (limited in infranodal); transcutaneous pacing prep; transvenous pacing if persistent. - Avoid further AV-blockers. (3) Pacemaker indications (Class I): - 3rd degree AV block (CHB), permanent or paroxysmal, regardless of symptoms (most situations). - Mobitz II AV block — independent of symptoms if wide QRS or block in/below His; if narrow QRS without other cause + asymptomatic, individualized. - Symptomatic Mobitz I — pace if symptomatic OR infranodal location. - High-grade AV block (multiple consecutive blocked P). - Chronic bifascicular/trifascicular block with intermittent CHB or syncope unexplained. - Sinus node dysfunction symptomatic (sinus bradycardia, pauses > 3 sec awake, chronotropic incompetence). (4) Pacing modality: - SSS sinus node dysfunction: DDD-R or AAI-R. - AV block with intact SA: DDD. - AF + CHB: VVI-R. - Avoidance of unnecessary RV pacing (RV pacing-induced cardiomyopathy) — managed PVP algorithms, AAIsafeR, His-Purkinje pacing. - CRT (biventricular pacing) if expected RV pacing > 40% + LVEF < 50% (BLOCK HF, BIOPACE). - Conduction system pacing (His bundle, left bundle area) — more physiologic, increasing. (5) Pre-implant: anticoagulation hold (warfarin held INR < 1.8 or DOAC hold 24-48 hr; DAPT continued for CAD/PCI as per BRUISE CONTROL), antibiotic prophylaxis (cefazolin), device counseling, lifestyle (no driving 1 wk after implant). (6) Post-implant: wound care, follow-up interrogation, MRI compatibility per device (most newer = MRI-conditional). A ผิด — Mobitz II infranodal = needs pacing; atropine doesn''t reliably work. C ผิด — worsens. D ผิด — digoxin AV nodal blocker. E ผิด — primary indication is bradyarrhythmia not ventricular tachyarrhythmia.', NULL,
  'medium', 'cardiovascular', 'review',
  'internal_medicine', 'clinical_decision', 'cardiovascular', 'adult',
  'ACC/AHA/HRS 2018 Guideline on Bradycardia and Cardiac Conduction Delay; ESC 2021 Guidelines on Cardiac Pacing and CRT', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 78 ปี underlying HF, T2DM, prior MI ก่อน 2 ปี on optimal medical therapy (carvedilol 25 mg BID, sacubitril/valsartan, spironolactone, empagliflozin, ASA) มา ED ด้วยใจสั่น + วิงเวียน + ไม่ syncope

V/S: BP 102/64, HR 38 (slow), RR 18, SpO2 97%, Temp 36.8°C
EKG: 2nd degree AV block Mobitz Type II (constant PR with sudden non-conducted P; sometimes 2:1 conduction), wide QRS 130 ms, sinus rhythm underneath
Lab: K 4.2, Mg 2.0, Cr 1.4, Ca 9.2, TSH 1.8, troponin negative
Medication review: recently started higher dose metoprolol (replaced carvedilol; mistake) → likely contributory but also infranodal disease based on EKG
No digoxin, no diltiazem, no antiarrhythmic
No Lyme, no infiltrative cardiomyopathy clue'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 30 ปี สูง 188 cm BMI 19, ไม่มีโรคประจำตัว มา ED ด้วยปวดอกข้างขวา + เหนื่อย onset 1 ชม. ก่อนหน้านี้สูบบุหรี่ light ขณะที่ไอแรง

V/S: BP 124/76, HR 102, RR 22, SpO2 94% RA, Temp 36.8°C
PE: decreased breath sounds right hemithorax + hyperresonance + decreased fremitus, trachea midline, no JVP, no hemodynamic compromise

CXR: right pneumothorax 35% (large by BTS criteria > 2 cm at hilum); no mediastinal shift, no rib fracture
No prior pneumothorax', '[{"label":"A","text":"Observation alone — small pneumothorax"},{"label":"B","text":"Primary spontaneous pneumothorax, large (> 2 cm rim) + symptomatic"},{"label":"C","text":"Surgery thoracotomy + pleurectomy first"},{"label":"D","text":"Heimlich one-way valve for outpatient"},{"label":"E","text":"Thoracic CT angiography to rule out PE"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Primary spontaneous pneumothorax, large (> 2 cm rim) + symptomatic — (1) Chest tube insertion (small-bore 8-14 Fr pigtail) is traditional but recent BTS 2023 + ACCP guidance favor: needle aspiration as first-line for large primary spontaneous pneumothorax (success ~ 50-70%; equivalent outcomes vs tube — Thomsen NEJM 2020); chest tube if aspiration fails or air leak persists; (2) Connect to underwater seal + monitor — apply suction (-20 cm H2O) only if persistent air leak > 48 hr; (3) Supplemental oxygen — accelerates absorption (3-4x with high-FiO2); (4) Pain control; (5) Avoid air travel until resolved + 1 wk after; lifelong avoid scuba diving (BTS); (6) Smoking cessation counseling — reduces recurrence 6x; (7) Recurrence: ~20-50% first-side risk → ipsilateral risk ↑ after first event; pleurodesis (chemical talc, mechanical abrasion) or VATS bullectomy + pleurectomy considered after second ipsilateral or first contralateral or persistent air leak > 5-7 d or high-risk profession (pilot, diver); (8) Secondary pneumothorax (underlying lung disease — COPD, CF, asthma, ILD, TB, malignancy, HIV/PCP): chest tube indicated more aggressively, lower threshold for surgery; (9) Tension pneumothorax: needle decompression 2nd intercostal space midclavicular line OR 4th-5th anterior axillary, then chest tube

---

Primary spontaneous pneumothorax (PSP) — no underlying lung disease, tall thin males, smokers; rupture of subpleural bleb at apex. BTS 2023 + ACCP 2001 + ERS pneumothorax guideline: (1) Size definition: BTS > 2 cm at hilum = large; ACCP > 3 cm at apex = large; small if < 2 cm BTS or < 3 cm ACCP. (2) Primary spontaneous pneumothorax management: - Small + asymptomatic: observation + O2 (absorbs 1-2%/d, faster with O2); discharge with f/u. - Large or symptomatic: - Needle aspiration (16-18 G) — first-line per BTS 2023 (less hospital stay, similar success; Thomsen NEJM 2020 conservative). - Chest tube (small-bore 8-14 Fr pigtail preferred over large-bore) — if NA fails (> 2.5 L air aspirated, persistent breathlessness, persistent PTX > 50%). - VATS/pleurectomy for persistent air leak > 5-7 d, recurrent ipsilateral, contralateral first event, high-risk profession (pilot, diver). (3) Secondary spontaneous pneumothorax (SSP) — underlying lung disease (COPD, CF, ILD, TB, PCP, malignancy, Pneumocystis): - More aggressive: chest tube earlier; surgery threshold lower. - Higher morbidity + mortality. - Pleurodesis for recurrence prevention (chemical talc — pleurodesis at bedside or VATS, mechanical pleurectomy + bullectomy). (4) Tension pneumothorax: emergency — hemodynamic instability + tracheal deviation + JVP rise + absent breath sounds; needle decompression 2nd ICS midclavicular line (or 4th-5th anterior/mid-axillary per recent updates — better in obese), followed by chest tube. (5) Catamenial: in menstruating female, possibly endometriosis-related — hormonal Rx + surgery. (6) Iatrogenic (post-CVC, thoracentesis): aspiration or tube. (7) Post-PTX management: - O2 supplementation accelerates resorption. - Avoid air travel until resolved + 1-2 wk. - Avoid SCUBA diving — lifelong if recurrent (relative even with single). - Smoking cessation — recurrence ↓. - Counsel re recognizing recurrence. (8) Heimlich valve for outpatient management in selected stable PSP — institution-dependent. (9) Recurrence: PSP 20-50% on same side after first; SSP higher; pleurodesis/surgery after 2nd ipsilateral. A ผิด — large symptomatic = intervention. C ผิด — surgery for recurrent/persistent. D ผิด — alternative not first-line. E ผิด — distractor.', NULL,
  'easy', 'respiratory', 'review',
  'internal_medicine', 'clinical_decision', 'respiratory', 'adult',
  'BTS Pleural Disease Guideline 2023; ACCP Consensus Statement on Pneumothorax 2001; Thomsen R et al. NEJM 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 30 ปี สูง 188 cm BMI 19, ไม่มีโรคประจำตัว มา ED ด้วยปวดอกข้างขวา + เหนื่อย onset 1 ชม. ก่อนหน้านี้สูบบุหรี่ light ขณะที่ไอแรง

V/S: BP 124/76, HR 102, RR 22, SpO2 94% RA, Temp 36.8°C
PE: decreased breath sounds right hemithorax + hyperresonance + decreased fremitus, trachea midline, no JVP, no hemodynamic compromise

CXR: right pneumothorax 35% (large by BTS criteria > 2 cm at hilum); no mediastinal shift, no rib fracture
No prior pneumothorax'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 45 ปี ไม่มีโรคประจำตัวเดิม มาด้วยปวดท้อง epigastric + คลื่นไส้ + อาเจียน + กลืนเจ็บ ตอนกลางคืน เป็นมา 3 เดือน + recently 2 สัปดาห์ ถ่ายอุจจาระดำ 

V/S: BP 122/76, HR 88, RR 16, Temp 36.8°C
PE: epigastric tenderness mild, no peritonitis, rectal exam: melena on glove

Lab: Hb 9.8 (microcytic MCV 76 — iron deficiency), Plt 280K, BUN/Cr ratio 28 (high, suggests UGIB), Cr 0.9, INR 1.0
EGD: 2 ulcers — 1 in gastric antrum (1.2 cm, clean base — Forrest III), 1 duodenal bulb (0.8 cm, visible non-bleeding vessel — Forrest IIa); biopsy: H. pylori positive on rapid urease test + histology; no malignancy on gastric ulcer biopsy
Medication review: takes ibuprofen 400 mg PRN for back pain × 6 months', '[{"label":"A","text":"PPI + observation only without H. pylori treatment"},{"label":"B","text":"H. pylori-positive peptic ulcer disease with NSAID contribution"},{"label":"C","text":"Surgery (selective vagotomy) first-line"},{"label":"D","text":"PPI + clarithromycin monotherapy"},{"label":"E","text":"Antacid alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** H. pylori-positive peptic ulcer disease with NSAID contribution: (1) Acute UGIB control during EGD — Forrest IIa (visible vessel) duodenal ulcer = endoscopic therapy (epinephrine injection + bipolar cautery / hemoclip — dual modality preferred); high-dose PPI infusion (esomeprazole 80 mg bolus + 8 mg/hr × 72 hr) per Lau NEJM; (2) H. pylori eradication — Thai/Asian common: triple therapy (PPI BID + amoxicillin 1 g BID + clarithromycin 500 mg BID × 14 d) if local clarithromycin resistance < 15%, OR bismuth quadruple (PPI + bismuth + metronidazole + tetracycline × 10-14 d) — preferred where resistance > 15% (Thailand resistance rising); concomitant therapy 4-drug × 14 d alternative; new option vonoprazan + amoxicillin ± clarithromycin (potassium-competitive acid blocker — higher acid suppression even with CYP2C19 EM); (3) Stop NSAID; alternative analgesic (acetaminophen, topical, low-dose if essential + co-prescribe PPI/misoprostol); (4) PPI 8 weeks for ulcer healing; (5) Confirm H. pylori eradication 4 weeks after therapy: urea breath test, stool antigen, or biopsy — off PPI 2 weeks + off antibiotic 4 weeks; (6) Iron supplementation for IDA; (7) Repeat EGD only if gastric ulcer (rule out malignancy — biopsies were negative initially), follow-up 8-12 wk; duodenal ulcer no follow-up scope needed; (8) Recurrence prevention: maintenance PPI if NSAID continued; smoking/alcohol cessation; H. pylori re-test if relapse symptoms

---

Peptic ulcer disease with UGIB — H. pylori-positive + NSAID-contributory. Forrest classification: Ia (active spurting), Ib (oozing), IIa (visible non-bleeding vessel), IIb (adherent clot), IIc (flat pigment), III (clean base). Higher Forrest = higher rebleed risk → endoscopic Rx + IV PPI. ACG 2017 UGIB + ACG 2017/2024 H. pylori + Maastricht VI 2022 H. pylori guideline: (1) Acute UGIB: - Risk stratify (Glasgow-Blatchford, AIMS65, Rockall). - Resuscitation: large-bore IV, restrictive transfusion Hb 7-8 (Villanueva). - IV PPI: 80 mg bolus + 8 mg/hr × 72 hr post-endoscopy hemostasis for high-risk (Forrest Ia-IIb). Pre-endoscopic PPI may down-stage lesion but not reduce rebleed/mortality. - Erythromycin 250 mg IV pre-endoscopy: clears stomach, improves visualization. - EGD within 24 hr: hemostasis for Forrest Ia-IIb (combination: epinephrine + thermal/clip; clip alone or thermal alone OK). - Forrest III no endoscopic Rx needed. - Rebleed → repeat endoscopy; angiographic embolization; surgery rarely. (2) H. pylori testing: stool antigen, urea breath test (off PPI 2 wk + antibiotics 4 wk), serology (cannot distinguish current vs past), histology + RUT during EGD. (3) Eradication regimens (Thailand high clarithromycin resistance area — > 20%): - **Bismuth quadruple** (PPI + bismuth subsalicylate + metronidazole + tetracycline) × 10-14 d — preferred where clarithromycin resistance > 15%. - **Concomitant** (PPI + amoxicillin + clarithromycin + metronidazole) × 14 d — alternative. - **Triple** (PPI + amoxicillin + clarithromycin) × 14 d — only if clarithromycin resistance < 15% (no longer reliable in Thailand). - **Sequential** (PPI + amoxicillin × 5 d → PPI + clarithromycin + metronidazole × 5 d) — outdated. - **Levofloxacin-based**: salvage. - **Vonoprazan-based** (P-CAB potassium-competitive acid blocker): emerging — superior acid suppression, equivalent or better eradication; vonoprazan + amoxicillin (dual) or with clarithromycin (triple) — pylera-Helie data. (4) Confirm eradication 4 wk post-Rx: stool antigen or UBT off PPI/abx. (5) Indications for H. pylori test + treat: PUD, MALT lymphoma, ITP, IDA unexplained, gastric MALT, first-degree relative gastric cancer, gastric adenocarcinoma after resection. (6) NSAID-induced ulcer prevention: - Stop NSAID if possible; switch to acetaminophen/topical/coxib. - Co-prescribe PPI or misoprostol for high-risk continuing NSAID (elderly, prior PUD, on anticoagulant/steroid). - COX-2 selective (celecoxib) — lower GI bleed but CV risk. - H. pylori eradication if positive + NSAID use planned/ongoing. (7) Gastric ulcer (vs duodenal): biopsy to rule out malignancy; repeat EGD 8-12 wk to document healing. A ผิด — must eradicate H. pylori. C ผิด — surgery rare. D ผิด — needs combination + antibiotic. E ผิด — inadequate.', NULL,
  'medium', 'gi', 'review',
  'internal_medicine', 'clinical_decision', 'gi', 'adult',
  'ACG Clinical Guideline: Upper GI and Ulcer Bleeding 2021; Maastricht VI/Florence Consensus on H. pylori 2022; ACG Treatment of H. pylori 2024', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 45 ปี ไม่มีโรคประจำตัวเดิม มาด้วยปวดท้อง epigastric + คลื่นไส้ + อาเจียน + กลืนเจ็บ ตอนกลางคืน เป็นมา 3 เดือน + recently 2 สัปดาห์ ถ่ายอุจจาระดำ 

V/S: BP 122/76, HR 88, RR 16, Temp 36.8°C
PE: epigastric tenderness mild, no peritonitis, rectal exam: melena on glove

Lab: Hb 9.8 (microcytic MCV 76 — iron deficiency), Plt 280K, BUN/Cr ratio 28 (high, suggests UGIB), Cr 0.9, INR 1.0
EGD: 2 ulcers — 1 in gastric antrum (1.2 cm, clean base — Forrest III), 1 duodenal bulb (0.8 cm, visible non-bleeding vessel — Forrest IIa); biopsy: H. pylori positive on rapid urease test + histology; no malignancy on gastric ulcer biopsy
Medication review: takes ibuprofen 400 mg PRN for back pain × 6 months'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 42 ปี ไม่มีโรคประจำตัว มาด้วยอาการกลืนติด solid food > liquid 8 เดือน progressive + ระบายอาการอาเจียนอาหารไม่ย่อย + น้ำหนักลด 5 kg + ไม่มี heartburn + ไม่มี GI bleeding

Upper GI study (barium swallow): "bird''s beak" appearance distal esophagus + dilated proximal esophagus + retained barium with delayed emptying
EGD: dilated esophagus, retained food + saliva, no mass, normal mucosa, scope passes through LES with mild resistance, no Schatzki ring, no mucosal break, biopsy normal (no eosinophilic esophagitis)
High-resolution esophageal manometry: integrated relaxation pressure (IRP) > 15 mmHg + 100% failed peristalsis + Type II achalasia (panesophageal pressurization)
Chagas serology negative (not Mexico/SA exposure)', '[{"label":"A","text":"High-dose PPI + observation"},{"label":"B","text":"Laparoscopic Heller myotomy"},{"label":"C","text":"Surgical esophagectomy first-line"},{"label":"D","text":"Repeat endoscopy every 6 months without treatment"},{"label":"E","text":"H2 blocker monotherapy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Achalasia Type II (Chicago Classification v4.0) — best prognosis subtype, responds well to all treatments: (1) Definitive options (no single "best" — patient preference + center expertise per ACG 2020 + ASGE): - **Pneumatic dilation** (graded 30 → 35 → 40 mm): endoscopic; risk of perforation 1-3%; durable in 70-80% at 5 yr; multiple sessions often; preferred in elderly + high surgical risk; not for hiatal hernia or prior surgery. - **Laparoscopic Heller myotomy** with Dor or Toupet fundoplication: gold-standard surgical; durable 80-90% at 5 yr; preferred in young patients + Type III achalasia (longer myotomy); GERD risk addressed by fundoplication. - **POEM (peroral endoscopic myotomy)**: endoscopic, no skin incision; emerging as effective alternative; high success 80-95% but ↑ GERD (up to 50%) — must offer PPI long-term + surveillance. - All three roughly equivalent in Type II per recent RCTs. (2) Medical (poor durability, bridging only): - Calcium channel blocker (nifedipine 10-20 mg sublingual pre-meal), nitrate (isosorbide dinitrate) — short-term, side effects, low efficacy. - Botulinum toxin injection at LES (EUS-guided): 6-12 mo duration; option for elderly, high surgical risk, bridging. (3) Lifestyle: small frequent meals, upright posture, chew thoroughly, hydration during meals. (4) Post-treatment GERD surveillance — endoscopy + symptom assessment; PPI in symptomatic. (5) Long-term: ~2-7% lifetime esophageal cancer risk (squamous) — surveillance endoscopy debated; not routinely recommended but consider 10-15 yr post-symptom onset. (6) Type III (spastic) — POEM preferred (longer myotomy); CCB/nitrate adjunct. (7) Pseudoachalasia: malignancy mimics — EGD + CT/EUS exclude; suspect if rapid weight loss + short history + elderly. (8) Refractory: esophagectomy last resort

---

Achalasia — primary esophageal motility disorder of unknown etiology; ganglion cell loss in myenteric plexus → impaired LES relaxation + aperistalsis. Chicago Classification v4.0 (HREM): Type I (classic, no pressurization), Type II (panesophageal pressurization — best prognosis), Type III (spastic — premature contractions, worst prognosis, needs longer myotomy). ACG 2020 + ASGE 2021 + ISDE guideline: (1) Diagnosis: - Symptoms: dysphagia (solid + liquid, often progressive), regurgitation, weight loss, chest pain, aspiration. - Barium swallow: bird''s beak, dilated esophagus, retained food, delayed emptying. - EGD: rule out mechanical obstruction (mass, stricture, ring); pseudoachalasia (10% malignant — gastroesophageal junction adenocarcinoma); rule out EoE. - **HREM (high-resolution esophageal manometry) — gold standard**: integrated relaxation pressure (IRP) > 15 mmHg + 100% failed peristalsis. Type subclassification. - Timed barium esophagogram for monitoring. - EndoFLIP (functional luminal imaging probe): emerging. (2) Treatment goals: relieve obstruction, improve emptying, prevent megaesophagus. (3) Definitive options: - **Pneumatic dilation**: 30-40 mm balloon, graded approach; success 70-80% at 5 yr; perforation 1-3% (highest at largest balloon); multiple sessions often. - **Laparoscopic Heller myotomy + partial fundoplication** (Dor anterior or Toupet posterior): durable 80-90% at 5 yr; GERD reduced by fundoplication. - **POEM (peroral endoscopic myotomy)**: high success 80-95%; GERD 30-50% (no fundoplication); preferred Type III (longer myotomy possible); requires expertise. - Equivalency: in Type II — all roughly equivalent (Werner NEJM 2019 — POEM vs PD); choice by patient, center, anatomy. (4) Medical (poor efficacy, bridge): - Calcium channel blocker (nifedipine SL), nitrate — pre-meal; modest. - Botulinum toxin injection LES: 6-12 mo duration; for elderly, high-risk, bridging. (5) Lifestyle: small meals, upright, chew, hydrate. (6) Post-treatment: monitor symptoms, GERD; PPI if reflux; periodic EGD if surveillance for cancer (controversial — modest ↑ squamous cell ca lifetime). (7) Refractory or megaesophagus: esophagectomy. (8) Pseudoachalasia: short Hx + rapid weight loss + elderly + atypical findings → rule out malignancy (EGD biopsy, EUS, CT). (9) Chagas disease (Trypanosoma cruzi): South/Central America exposure; serology — endemic achalasia look-alike. A ผิด — PPI for reflux, not achalasia. C ผิด — esophagectomy is last resort. D ผิด — progressive, treat. E ผิด — wrong mechanism.', NULL,
  'medium', 'gi', 'review',
  'internal_medicine', 'clinical_decision', 'gi', 'adult',
  'ACG Clinical Guidelines: Diagnosis and Management of Achalasia 2020; ASGE Guidelines on Endoscopic Management of Achalasia 2021; Werner YB et al. NEJM 2019', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 42 ปี ไม่มีโรคประจำตัว มาด้วยอาการกลืนติด solid food > liquid 8 เดือน progressive + ระบายอาการอาเจียนอาหารไม่ย่อย + น้ำหนักลด 5 kg + ไม่มี heartburn + ไม่มี GI bleeding

Upper GI study (barium swallow): "bird''s beak" appearance distal esophagus + dilated proximal esophagus + retained barium with delayed emptying
EGD: dilated esophagus, retained food + saliva, no mass, normal mucosa, scope passes through LES with mild resistance, no Schatzki ring, no mucosal break, biopsy normal (no eosinophilic esophagitis)
High-resolution esophageal manometry: integrated relaxation pressure (IRP) > 15 mmHg + 100% failed peristalsis + Type II achalasia (panesophageal pressurization)
Chagas serology negative (not Mexico/SA exposure)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 30 ปี underlying SLE on hydroxychloroquine + low-dose prednisolone + mycophenolate มาด้วย ขาบวมทั้งสองข้าง + ปัสสาวะมีฟอง + edema 2 สัปดาห์ + weight gain 4 kg

V/S: BP 158/96, HR 88, Temp 36.8°C
PE: 3+ pedal edema, periorbital edema, no ascites, no rash flare, no arthritis, no oral ulcer

Lab: Hb 11.4, WBC 6,800, Plt 198K, Cr 1.6 (baseline 0.8), Albumin 1.8, Cholesterol 380, LDL 220, Triglyceride 280
24-hr urine protein 8.4 g (heavy proteinuria); UPCR 7.8 g/g
UA: protein 4+, oval fat bodies, fatty casts; RBC few; no RBC casts
C3 low, C4 low, anti-dsDNA 280 (high — active SLE)
Kidney biopsy: Class V membranous lupus nephritis (subepithelial immune deposits + thickened basement membrane on EM) + features of Class III/IV mild (focal proliferative) — mixed Class III+V or pure V depends on severity
No thrombosis history, no contraindication anticoagulation', '[{"label":"A","text":"Continue current immunosuppression without change"},{"label":"B","text":"Class V (pure membranous) ± mixed lupus nephritis with nephrotic syndrome"},{"label":"C","text":"Cyclosporine monotherapy as first-line"},{"label":"D","text":"Renal transplant evaluation"},{"label":"E","text":"Plasmapheresis alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Class V (pure membranous) ± mixed lupus nephritis with nephrotic syndrome — Treatment per KDIGO 2024 + ACR/EULAR 2019 LN guideline: (1) Induction: - Pure Class V: MMF (mycophenolate mofetil 2-3 g/d, current MMF dose insufficient — increase) OR cyclophosphamide (lower dose Euro-Lupus); ACEi/ARB; antimalarial. - Mixed Class III/IV + V: more aggressive proliferative LN regimen — IV methylprednisolone pulse + oral prednisolone 0.5-1 mg/kg/d + MMF or cyclophosphamide; add belimumab (BLISS-LN) or voclosporin (calcineurin inhibitor, AURORA) as additive — improves complete renal response. (2) BP target < 130/80 with ACEi/ARB (anti-proteinuric + reno-protective; safe in pregnancy planning? — switch to non-RAAS pre-conception). (3) Nephrotic syndrome management: - Salt restriction + loop diuretic for edema. - Statin for hyperlipidemia (avoid if pregnancy planning). - Anticoagulation: high VTE risk in membranous + Alb < 2-2.5 g/dL — prophylactic anticoagulation (warfarin INR 2-3 or DOAC; consider in nephrotic membranous especially with additional risk; Class V LN intermediate risk — individualize). - Hydroxychloroquine ALWAYS continue (improves renal + extra-renal outcomes + survival). - Pneumocystis (TMP-SMX) prophylaxis if pred ≥ 20 mg + > 1 mo or other immunosuppressive risk. - Calcium + Vit D + bisphosphonate consideration with chronic steroid. - Vaccinations (avoid live; inactivated when stable). - Pregnancy counseling: avoid teratogen (MMF, MTX, cyclophosphamide stop ≥ 3 mo before conception); switch to azathioprine + tacrolimus + low-dose pred; HCQ continued; APS antibody screen. (4) Maintenance: MMF 1-2 g/d OR azathioprine 2 mg/kg/d for 3-5 yr at least; taper steroid; monitor activity (anti-dsDNA, C3/C4, urine sediment). (5) Refractory: rituximab, plasma exchange (rarely needed), belimumab

---

Lupus nephritis Class V (membranous) ± mixed proliferative — ISN/RPS 2003 classification. Distinct from Class III/IV (proliferative) in pathogenesis + treatment + prognosis. Nephrotic syndrome features (heavy proteinuria > 3.5 g/d, hypoalbuminemia, edema, hyperlipidemia). KDIGO 2024 LN + ACR/EULAR 2019 LN + recent trials: (1) Class III/IV (proliferative): - Induction: IV methylprednisolone pulse + oral pred + MMF (preferred Asian, less toxic) or cyclophosphamide (Euro-Lupus 500 mg q2wk × 6 doses; NIH high-dose alternative); add belimumab (BLISS-LN) or voclosporin (AURORA — CNI). - Maintenance: MMF or AZA + low-dose pred × 3-5 yr. (2) Class V (membranous): - Pure V with nephrotic proteinuria: MMF 2-3 g/d OR cyclophosphamide; CNI (tacrolimus, voclosporin); rituximab in refractory. - Pure V with sub-nephrotic: ACEi/ARB + HCQ + low-dose steroid + close monitor; no aggressive immunosuppression initially. - Mixed III/IV + V: treat as proliferative + V combined — more aggressive. (3) Class VI (advanced sclerosis): no immunosuppression; prepare RRT. (4) Adjunct in all LN: - Hydroxychloroquine: improves renal + survival + lipid; continue lifelong unless contraindicated (avoid retinopathy — annual ophth screen). - ACEi/ARB: BP < 130/80; albuminuria target ↓ to < 0.5 g/d; safe in non-pregnant. - Statin for hyperlipidemia. - Anticoagulation: VTE risk in nephrotic syndrome especially membranous + Alb < 2-2.5; prophylactic in selected. - Bone (steroid): Ca, Vit D, bisphosphonate (avoid in pregnancy planning). - Vaccinations: pre-immunosuppression preferred; avoid live. - PCP prophylaxis (TMP-SMX) if pred ≥ 20 mg × > 1 mo + concurrent immunosuppression. - Pregnancy: counseling; teratogen avoidance (MMF, MTX, CYC — stop ≥ 3 mo pre-conception); switch to AZA + tacrolimus + low-dose pred + HCQ; APS screen; planned conception in quiescent state ≥ 6 mo. - Cardiovascular risk: SLE = ↑ premature ASCVD — manage aggressively. - Cancer surveillance: ↑ lymphoma, cervical, skin. (5) Refractory: rituximab, voclosporin, belimumab, obinutuzumab; PLEX rare. (6) Monitoring: serum Cr, UPCR, urine sediment, anti-dsDNA, C3/C4, lupus activity (SLEDAI). (7) ESRD: ~10-15% LN; transplant outcomes good. (8) Outcomes: ~80% 10-yr renal survival now (vs 50% pre-MMF era). A ผิด — active LN needs escalation. C ผิด — CNI is adjunct or alternative. D ผิด — too early. E ผิด — PLEX rare indication.', NULL,
  'hard', 'rheumatology', 'review',
  'internal_medicine', 'clinical_decision', 'rheumatology', 'adult',
  'KDIGO 2024 Clinical Practice Guideline for Lupus Nephritis; ACR/EULAR 2019 LN Recommendations; BLISS-LN NEJM 2020; AURORA Voclosporin', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 30 ปี underlying SLE on hydroxychloroquine + low-dose prednisolone + mycophenolate มาด้วย ขาบวมทั้งสองข้าง + ปัสสาวะมีฟอง + edema 2 สัปดาห์ + weight gain 4 kg

V/S: BP 158/96, HR 88, Temp 36.8°C
PE: 3+ pedal edema, periorbital edema, no ascites, no rash flare, no arthritis, no oral ulcer

Lab: Hb 11.4, WBC 6,800, Plt 198K, Cr 1.6 (baseline 0.8), Albumin 1.8, Cholesterol 380, LDL 220, Triglyceride 280
24-hr urine protein 8.4 g (heavy proteinuria); UPCR 7.8 g/g
UA: protein 4+, oval fat bodies, fatty casts; RBC few; no RBC casts
C3 low, C4 low, anti-dsDNA 280 (high — active SLE)
Kidney biopsy: Class V membranous lupus nephritis (subepithelial immune deposits + thickened basement membrane on EM) + features of Class III/IV mild (focal proliferative) — mixed Class III+V or pure V depends on severity
No thrombosis history, no contraindication anticoagulation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 35 ปี ไม่มีโรคประจำตัว มาด้วยปวดหลังเรื้อรัง > 6 เดือน + ปวดสะโพก + sciatic-like + stiffness ตอนเช้า > 60 นาที + ดีขึ้นเมื่อขยับ + อาการแย่ตอนกลางคืน + Achilles tendinitis 2 ตอน + พ่อมี HLA-B27 positive AS

V/S: BP 124/76, HR 78, Temp 36.8°C
PE: Schober test < 4 cm (limited lumbar flexion), reduced chest expansion 3 cm, bilateral SI joint tenderness, FABER positive bilateral, no peripheral synovitis active

Lab: ESR 48, CRP 28, RF negative, anti-CCP negative, ANA negative, HLA-B27 positive
X-ray pelvis: bilateral sacroiliitis grade 3 (definite erosions + sclerosis); X-ray spine: shiny corners early bamboo spine
MRI SI joints: active inflammation with bone marrow edema + erosions (confirms radiographic axial SpA)
No IBD symptoms, no psoriasis, no uveitis history', '[{"label":"A","text":"DMARDs methotrexate first-line"},{"label":"B","text":"Axial Spondyloarthritis / Ankylosing Spondylitis (radiographic axSpA)"},{"label":"C","text":"Long-term high-dose oral steroid"},{"label":"D","text":"Allopurinol prophylactic"},{"label":"E","text":"Surgery as first-line"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Axial Spondyloarthritis / Ankylosing Spondylitis (radiographic axSpA) — ASAS/EULAR 2022 axSpA management guideline: (1) Non-pharmacologic foundation: regular exercise (aerobic + spine extension + posture), physical therapy, smoking cessation (smoking accelerates progression), patient education + self-management; (2) First-line: NSAIDs continuous (vs PRN) — at full anti-inflammatory dose (naproxen 500 mg BID, celecoxib 200 mg/d, etoricoxib 90 mg/d, indomethacin 75 mg/d); ≥ 2 different NSAIDs adequate trial × 2-4 weeks each before declaring inadequate response; some evidence NSAID slow radiographic progression; (3) Second-line for axial active despite NSAIDs (no role for conventional DMARDs methotrexate/sulfasalazine in axial; helpful for peripheral arthritis): biologic — TNF inhibitor (adalimumab, etanercept, golimumab, infliximab, certolizumab) OR IL-17 inhibitor (secukinumab, ixekizumab) — both classes effective; JAK inhibitor (upadacitinib, tofacitinib) alternative; (4) Peripheral arthritis/enthesitis/dactylitis: sulfasalazine, methotrexate (more for peripheral); biologic same as above; (5) Extra-articular manifestations (uveitis, IBD, psoriasis) — anti-TNF mAb (infliximab, adalimumab) effective for uveitis + IBD-associated; secukinumab/ixekizumab less effective for IBD (may worsen); etanercept no IBD efficacy; (6) Comorbidity: osteoporosis screening (DXA — high risk despite young), cardiovascular (↑ ASCVD), cancer, depression; (7) Bone health: vit D, Ca, bisphosphonate if osteoporotic; (8) Vaccinations pre-biologic; TB + hepatitis screen before anti-TNF; (9) Surgery: hip arthroplasty (common in AS), spinal corrective for severe deformity (rare); osteotomy considered

---

Ankylosing spondylitis (AS) / radiographic axial spondyloarthritis (axSpA). Diagnostic criteria modified New York (radiographic sacroiliitis + clinical) or ASAS for axSpA (sacroiliitis on imaging + SpA features OR HLA-B27 + ≥ 2 SpA features). Inflammatory back pain: insidious, age < 45 onset, > 3 mo, morning stiffness > 30 min, improves with exercise, no improvement with rest, awakens night especially 2nd half. ASAS/EULAR 2022 + ACR/Spondyloarthritis Research Network of America 2019 axSpA guideline: (1) Treatment goals: symptom control, prevent structural damage, maintain function, manage comorbidities. (2) Non-pharm cornerstone: - Education + self-management. - Exercise (extension, posture, aerobic, hydrotherapy) — strongest evidence non-pharm. - Smoking cessation. - Physical therapy. - Postural therapy + sleep ergonomics. (3) Pharmacologic stepped: - NSAID continuous at maximum tolerated dose × at least 2-4 wk; if inadequate try second NSAID; ≥ 2 trials before declaring inadequate; NSAID may slow radiographic progression (Wanders ARD 2005, controversial). - Biologics for axial active despite NSAID: - **Anti-TNF**: adalimumab, etanercept, golimumab, certolizumab, infliximab — all effective. - **Anti-IL-17**: secukinumab, ixekizumab — alternative. - **JAK inhibitor**: upadacitinib (axial), tofacitinib — alternative. - Switch within class or cross-class if inadequate. - Conventional DMARDs (MTX, SSZ): role only for peripheral arthritis, not axial. (4) Peripheral arthritis: SSZ, MTX; biologic if refractory. (5) Enthesitis: NSAID, local steroid injection (caution Achilles — rupture), biologic. (6) Extra-articular: - Uveitis (acute anterior, HLA-B27): topical steroid + cycloplegic; recurrent → biologic (anti-TNF mAb preferred, secukinumab less). - IBD: biologic — anti-TNF mAb (not etanercept); avoid IL-17 (worsens). - Psoriasis: anti-TNF, IL-17, IL-23. (7) Comorbidity: ↑ ASCVD, osteoporosis (paradox in AS — both syndesmophyte formation + vertebral fragility), spinal fracture risk, depression. (8) Bone health: DXA (often spuriously high due to syndesmophyte — hip/forearm preferred); fracture risk. (9) Vaccines pre-biologic; TB + HBV + HCV screen before anti-TNF. (10) Pregnancy: SSZ + certolizumab pegol (no transplacental); avoid MTX; biologic mostly safe. (11) Surgery: hip arthroplasty (severe coxitis), spinal osteotomy for severe deformity (rare). A ผิด — DMARD no role axial. C ผิด — long-term steroid not used in AS axial. D ผิด — distractor. E ผิด — surgery last resort.', NULL,
  'medium', 'rheumatology', 'review',
  'internal_medicine', 'clinical_decision', 'rheumatology', 'adult',
  'ASAS/EULAR 2022 Recommendations for the Management of Axial Spondyloarthritis; ACR/SPARTAN 2019 Treatment Guideline for AS and Non-radiographic axSpA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 35 ปี ไม่มีโรคประจำตัว มาด้วยปวดหลังเรื้อรัง > 6 เดือน + ปวดสะโพก + sciatic-like + stiffness ตอนเช้า > 60 นาที + ดีขึ้นเมื่อขยับ + อาการแย่ตอนกลางคืน + Achilles tendinitis 2 ตอน + พ่อมี HLA-B27 positive AS

V/S: BP 124/76, HR 78, Temp 36.8°C
PE: Schober test < 4 cm (limited lumbar flexion), reduced chest expansion 3 cm, bilateral SI joint tenderness, FABER positive bilateral, no peripheral synovitis active

Lab: ESR 48, CRP 28, RF negative, anti-CCP negative, ANA negative, HLA-B27 positive
X-ray pelvis: bilateral sacroiliitis grade 3 (definite erosions + sclerosis); X-ray spine: shiny corners early bamboo spine
MRI SI joints: active inflammation with bone marrow edema + erosions (confirms radiographic axial SpA)
No IBD symptoms, no psoriasis, no uveitis history'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 52 ปี ไม่มีโรคประจำตัวเดิม มาด้วย Raynaud phenomenon 5 ปี + อาการแย่ขึ้น + ผิวมือ + ใบหน้าหนา + difficulty swallow solid food + รู้สึก SOB เพิ่ม 6 เดือน + arthralgia

V/S: BP 132/78, HR 92, RR 20, SpO2 94%
PE: sclerodactyly (digital tip ulcers), telangiectasia ใบหน้า + มือ, salt-and-pepper hyperpigmentation, skin tightening face + neck + arms (mRSS modified Rodnan skin score 16 — diffuse cutaneous), no synovitis, no organomegaly

Lab: Hb 11.2, Cr 0.9, urinalysis normal, K 4.0, Ca 9.4
LFT normal
ANA 1:1280 nucleolar pattern
Anti-Scl-70 (anti-topoisomerase I) positive → diffuse cutaneous SSc
Anti-centromere negative (more limited)
Anti-RNA polymerase III negative (associated with rapid progression + scleroderma renal crisis)
PFT: restrictive FVC 68%, DLCO 52% (reduced)
HRCT chest: bibasilar reticular opacities + ground-glass + traction bronchiectasis — NSIP pattern interstitial lung disease
Echo: estimated PASP 32 (mild PH) — borderline
Esophageal manometry: hypotensive LES + absent peristalsis distal 2/3 (typical SSc esophagus)
6MWT 380 m', '[{"label":"A","text":"Methotrexate alone first-line"},{"label":"B","text":"Diffuse cutaneous systemic sclerosis (dcSSc) with multi-organ involvement (ILD-NSIP, esophageal, Raynaud, skin)"},{"label":"C","text":"Plasmapheresis alone"},{"label":"D","text":"Hydroxychloroquine alone"},{"label":"E","text":"Calcium channel blocker alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Diffuse cutaneous systemic sclerosis (dcSSc) with multi-organ involvement (ILD-NSIP, esophageal, Raynaud, skin) — Organ-based management per EULAR 2017 (update 2024) + ACR SSc guideline: (1) Raynaud + digital ulcers: avoid cold/smoking/vasoconstrictors; calcium channel blocker (nifedipine, amlodipine — first-line); PDE5 inhibitor (sildenafil, tadalafil) for refractory; iloprost IV; endothelin receptor antagonist (bosentan) for digital ulcer prevention (RAPIDS trials); aspirin/statin; topical nitrate; (2) Skin (diffuse cutaneous active): methotrexate; mycophenolate (MMF) — also for ILD synergy; rituximab; tocilizumab (focuSSced trial); hematopoietic stem cell transplant in selected severe progressive; (3) ILD: MMF (Scleroderma Lung Study II) preferred OR cyclophosphamide (SLS I); add nintedanib (SENSCIS trial — slows FVC decline) for SSc-ILD; tocilizumab (IL-6 inhibitor — focuSSced); rituximab. Monitor FVC + DLCO + HRCT serial; pulmonary rehab; oxygen; vaccinations; (4) Pulmonary arterial hypertension (PAH-SSc — leading cause death): screen annually (echo, NT-proBNP, DLCO < 60%, FVC/DLCO ratio > 1.6); confirm with right heart catheterization (mPAP > 20 + PCWP ≤ 15 + PVR > 2 WU); treat upfront combination — ERA (ambrisentan/bosentan/macitentan) + PDE5i (sildenafil/tadalafil), add prostanoid (selexipag, treprostinil, epoprostenol) for inadequate; AMBITION trial; (5) Scleroderma renal crisis (SRC — abrupt malignant HT + AKI + MAHA, esp anti-RNA pol III + diffuse early-disease): IMMEDIATE ACEi (captopril titrate up); avoid steroids > 20 mg/d (precipitates SRC); dialysis if needed; many recover; (6) GI: PPI for reflux; prokinetic (metoclopramide, erythromycin); SIBO antibiotic rotation; nutrition; (7) Avoid high-dose steroid (SRC precipitator); (8) Cardiac: HF, arrhythmia, pericardial effusion — monitor + treat

---

Diffuse cutaneous systemic sclerosis (dcSSc) with ILD + Raynaud + esophageal + borderline PH — multi-organ approach needed. ACR/EULAR 2013 SSc classification + EULAR 2017 (update 2024) SSc management + ACR ILD-SSc 2024 guideline: (1) Classify: - Limited cutaneous (lcSSc, CREST): distal extremities + face; anti-centromere; better prognosis; PAH more common later. - Diffuse cutaneous (dcSSc): proximal limbs + trunk; anti-Scl-70 (topoisomerase I), anti-RNA pol III; ILD + renal crisis more common; worse early prognosis. - Autoantibodies guide organ risk: centromere → lcSSc + PAH; Scl-70 → ILD; RNA pol III → SRC + cancer; U1-RNP → PAH/MCTD; PM-Scl → myositis overlap. (2) Organ-specific management: - **Raynaud**: cold avoidance, no smoking, CCB (nifedipine); PDE5i (sildenafil); iloprost IV for ulcers; bosentan for prevention (RAPIDS). - **Skin**: MTX, MMF, rituximab, tocilizumab; HSCT for severe progressive (ASTIS, SCOT trials). - **ILD-SSc** (leading cause death): MMF preferred (SLS II — better tolerated); cyclophosphamide alternative (SLS I); + nintedanib (SENSCIS — slows FVC decline); + tocilizumab (focuSSced); rituximab. Monitor FVC + DLCO q3-6mo + HRCT q1y. - **PAH-SSc**: screen annually (DETECT algorithm); RHC confirm; upfront combo therapy (ERA + PDE5i ± prostanoid); AMBITION trial. - **Scleroderma renal crisis (SRC)**: emergent ACEi (captopril titrate); never give high-dose steroid (> 20 mg pred precipitates SRC); dialysis bridge; ACEi continue even on dialysis (renal recovery occurs months). - **GI**: PPI for reflux (universal); prokinetic; SIBO antibiotic rotation; gastric antral vascular ectasia → APC. - **Cardiac**: monitor echo + EKG. - **Musculoskeletal**: low-dose pred + MTX + biologic. (3) Avoid high-dose steroid > 15-20 mg/d (SRC risk). (4) Vaccinations: pre-immunosuppression. (5) Cancer surveillance: ↑ lung, breast, hematologic; RNA pol III especially. (6) Pregnancy: high-risk; defer until stable; SRC fatal; avoid teratogens (MMF, MTX, CYC). (7) Multidisciplinary: rheum + pulm + cardio + nephro + GI + derm. A ผิด — MTX alone doesn''t cover ILD. C ผิด — PLEX rare role. D ผิด — HCQ adjunct only. E ผิด — CCB for Raynaud only.', NULL,
  'hard', 'rheumatology', 'review',
  'internal_medicine', 'clinical_decision', 'rheumatology', 'adult',
  'EULAR 2017 (update 2024) Recommendations for Treatment of Systemic Sclerosis; ACR Guideline on Pharmacologic Treatment of ILD in SSc and other CTDs 2024; SENSCIS Nintedanib NEJM 2019; focuSSced Tocilizumab Lancet 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 52 ปี ไม่มีโรคประจำตัวเดิม มาด้วย Raynaud phenomenon 5 ปี + อาการแย่ขึ้น + ผิวมือ + ใบหน้าหนา + difficulty swallow solid food + รู้สึก SOB เพิ่ม 6 เดือน + arthralgia

V/S: BP 132/78, HR 92, RR 20, SpO2 94%
PE: sclerodactyly (digital tip ulcers), telangiectasia ใบหน้า + มือ, salt-and-pepper hyperpigmentation, skin tightening face + neck + arms (mRSS modified Rodnan skin score 16 — diffuse cutaneous), no synovitis, no organomegaly

Lab: Hb 11.2, Cr 0.9, urinalysis normal, K 4.0, Ca 9.4
LFT normal
ANA 1:1280 nucleolar pattern
Anti-Scl-70 (anti-topoisomerase I) positive → diffuse cutaneous SSc
Anti-centromere negative (more limited)
Anti-RNA polymerase III negative (associated with rapid progression + scleroderma renal crisis)
PFT: restrictive FVC 68%, DLCO 52% (reduced)
HRCT chest: bibasilar reticular opacities + ground-glass + traction bronchiectasis — NSIP pattern interstitial lung disease
Echo: estimated PASP 32 (mild PH) — borderline
Esophageal manometry: hypotensive LES + absent peristalsis distal 2/3 (typical SSc esophagus)
6MWT 380 m'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 70 ปี underlying HT, T2DM, CKD3 มาด้วยอ่อนเพลีย + คลื่นไส้ + ปัสสาวะออกน้อย 5 วัน หลังเริ่ม TMP-SMX สำหรับ UTI + ใช้ ibuprofen ปวดเข่า

V/S: BP 132/82, HR 88, RR 18, SpO2 97%, Temp 37.6°C
PE: mild rash trunk + extremities, no edema active, abdomen soft

Lab: Cr 3.8 (baseline 1.6), BUN 64, K 5.4, HCO3 18, Hb 11.0, WBC 8,400 with eosinophilia 12%, Plt 220K
UA: protein 1+, WBC 20-30 cells/HPF (sterile pyuria), WBC casts +, urine eosinophils 5% (low sensitivity)
Urine Na 48, FENa 2.4% (not pre-renal), urine osm 320
No urinary obstruction on US
Drug review: started TMP-SMX 5 d ago for UTI + chronic ibuprofen
Renal biopsy: interstitial edema + inflammatory infiltrate (lymphocyte + eosinophil + plasma cell) + tubulitis; glomeruli normal — confirms Acute Interstitial Nephritis (AIN)', '[{"label":"A","text":"Continue TMP-SMX + IV fluid + observe"},{"label":"B","text":"Drug-induced Acute Interstitial Nephritis (AIN"},{"label":"C","text":"Empirical immunosuppression cyclophosphamide"},{"label":"D","text":"Hemodialysis immediately regardless of indication"},{"label":"E","text":"Continue ibuprofen for pain"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Drug-induced Acute Interstitial Nephritis (AIN — TMP-SMX + NSAID polypharmacy) — Management: (1) Identify + remove offending agent — STOP TMP-SMX + ibuprofen; substitute non-nephrotoxic alternative for UTI (e.g., nitrofurantoin if eGFR allows, cephalexin); (2) Supportive: avoid additional nephrotoxin (contrast, aminoglycoside), maintain euvolemia, adjust drug dosing for AKI, manage electrolytes (K, HCO3) + dialysis if severe; (3) Corticosteroid: controversial but commonly used in moderate-severe AIN without rapid Cr improvement after drug withdrawal (3-7 days observation); prednisolone 0.5-1 mg/kg/d × 2-4 weeks then taper over 6-8 weeks (Gonzalez Kidney Int 2008 — earlier + higher dose better outcome retrospective); steroid evidence weak (no RCT), but consensus reasonable in biopsy-proven AIN without spontaneous recovery; mycophenolate or rituximab as steroid-sparing in refractory; (4) Repeat Cr 24-72 hr after drug withdrawal — improvement supports diagnosis + good prognosis; persistent → consider steroid + biopsy if not done; (5) Long-term: 30-70% complete recovery; some progress to CKD; lifelong avoidance of offending drug class; (6) Causes: drugs (antibiotics — beta-lactam, sulfa, FQ, rifampin; NSAIDs — distinctive proteinuric with minimal change picture; PPI — common + often missed; allopurinol — SJS/TEN risk in HLA-B*5801 Thai; checkpoint inhibitor; tuberculostatic), infection (legionella, leptospira, EBV, BK virus), autoimmune (SLE, Sjögren, sarcoid, IgG4-related TIN), TINU (tubulointerstitial nephritis + uveitis); (7) Ophthalmology referral if uveitis (TINU); (8) Pharmacovigilance + patient education re medication adherence to avoid implicated drugs

---

Drug-induced Acute Interstitial Nephritis (AIN) — common cause of acute kidney injury. Classic triad (only 10%): fever, rash, eosinophilia + AKI; sterile pyuria + WBC casts + low-level proteinuria (NSAID-AIN can have nephrotic-range with minimal change). Drug causes 70%: NSAIDs (delayed weeks-months, often nephrotic), antibiotics (beta-lactam, sulfonamide, FQ, rifampin), PPI (often missed), allopurinol (SJS/TEN risk Asian HLA-B*5801), checkpoint inhibitors. KDIGO AKI + Praga AIN review: (1) Diagnosis: - History (drug exposure + timeline, classic triad), - Lab: AKI, sterile pyuria, WBC casts, low-grade proteinuria (or nephrotic in NSAID), eosinophilia variable, urine eosinophils (low sensitivity ~ 30%), - Imaging: kidneys normal-mildly enlarged, hyperechoic. - Biopsy: gold standard — interstitial edema + lymphoplasmacytic + eosinophil infiltrate + tubulitis; glomeruli + vessels normal; granuloma in some (sarcoid, TB). - Gallium-67 scan: positive (not specific). (2) Treatment: - **Stop offending drug** (cornerstone). - Substitute alternative if antibiotic needed. - Avoid additional nephrotoxin. - Supportive: fluid + electrolyte management; dialysis if indicated. - **Corticosteroid**: controversial. Reasonable in moderate-severe biopsy-proven AIN without rapid (3-7 d) Cr improvement post-drug withdrawal. Prednisolone 0.5-1 mg/kg/d × 2-4 wk then taper 6-8 wk total. Evidence weak (no RCT); some retrospective (Gonzalez Kidney Int 2008) suggests earlier + higher dose better. - Mycophenolate or rituximab in refractory. (3) Prognosis: - 30-70% complete recovery (drug-induced). - Some residual CKD. - Worse with delayed Dx, advanced age, baseline CKD, granulomatous AIN, severe interstitial fibrosis on biopsy. (4) Other AIN causes: - Infection: legionella, leptospira, EBV, BK virus, HIV, Hantavirus. - Autoimmune: SLE, Sjögren, sarcoid (granuloma), IgG4-related (steroid-responsive). - TINU (tubulointerstitial nephritis + uveitis): young adults, Sjögren-like; steroid responsive; ophth eval. - Idiopathic. (5) Differential of sterile pyuria + AKI: AIN, partially treated UTI, TB urinary, papillary necrosis. (6) Long-term: avoid offending drug class lifelong (cross-react possible); medical alert. A ผิด — perpetuates injury. C ผิด — cyclo not first-line for drug-induced AIN. D ผิด — no current indication. E ผิด — NSAID continues injury.', NULL,
  'medium', 'renal_gu', 'review',
  'internal_medicine', 'clinical_decision', 'renal_gu', 'adult',
  'KDIGO AKI Guideline 2012; Praga M + González E — Kidney International 2010 Review on AIN; Perazella MA Clin J Am Soc Nephrol 2017', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 70 ปี underlying HT, T2DM, CKD3 มาด้วยอ่อนเพลีย + คลื่นไส้ + ปัสสาวะออกน้อย 5 วัน หลังเริ่ม TMP-SMX สำหรับ UTI + ใช้ ibuprofen ปวดเข่า

V/S: BP 132/82, HR 88, RR 18, SpO2 97%, Temp 37.6°C
PE: mild rash trunk + extremities, no edema active, abdomen soft

Lab: Cr 3.8 (baseline 1.6), BUN 64, K 5.4, HCO3 18, Hb 11.0, WBC 8,400 with eosinophilia 12%, Plt 220K
UA: protein 1+, WBC 20-30 cells/HPF (sterile pyuria), WBC casts +, urine eosinophils 5% (low sensitivity)
Urine Na 48, FENa 2.4% (not pre-renal), urine osm 320
No urinary obstruction on US
Drug review: started TMP-SMX 5 d ago for UTI + chronic ibuprofen
Renal biopsy: interstitial edema + inflammatory infiltrate (lymphocyte + eosinophil + plasma cell) + tubulitis; glomeruli normal — confirms Acute Interstitial Nephritis (AIN)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 32 ปี ไม่มีโรคประจำตัว มาด้วย ปวดสันหลังด้านล่าง + ปวดข้างขวา + คลื่นไส้ + ปัสสาวะแสบ + เห็นเลือดในปัสสาวะ + ไข้ต่ำ 1 วัน

V/S: BP 124/76, HR 102, RR 16, SpO2 99%, Temp 37.8°C
PE: right CVA tenderness +, no peritonitis, no leg edema

Lab: WBC 12,800, Hb 12.4, Cr 1.0, K 4.0, Ca 11.4 (mild hypercalcemia), Phosphate 3.4, Albumin 4.2, Uric acid 7.2
UA: pH 5.5, RBC 30-50/HPF, WBC 10-15/HPF, no nitrite, crystals + (calcium oxalate)
NCCT abdomen: 8 mm stone right mid-ureter + mild hydronephrosis right, no pyonephrosis, contralateral kidney normal, no obstruction beyond stone
24-hr urine: high oxalate 65 mg, normal citrate, mild hypercalciuria 280 mg/24h
No recent UTI, no fever > 38.5
IVU/CTU: solitary right stone
No prior stone history', '[{"label":"A","text":"Aggressive IV fluid 3 L bolus + observation only"},{"label":"B","text":"Acute ureteral calculus (8 mm"},{"label":"C","text":"Surgical open ureterolithotomy first-line"},{"label":"D","text":"Furosemide + low calcium diet"},{"label":"E","text":"Antibiotic prophylaxis indefinitely"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute ureteral calculus (8 mm — borderline; AUA: < 10 mm may pass spontaneously, > 10 mm usually requires intervention): (1) Acute management: hydration (oral or moderate IV if NPO), pain control with NSAID (preferred over opioid — better analgesia + reduces ureteral spasm; ketorolac IV/IM if oral intolerable; avoid in CKD/dehydration), antiemetic; (2) Medical Expulsive Therapy (MET) — alpha-1 blocker (tamsulosin 0.4 mg/d) for distal ureter stones 5-10 mm — Cochrane: improves passage; ineffective for proximal ureter; limit trial 4-6 weeks; (3) Indications for intervention (urgent — same day urology consult): - Sepsis / pyonephrosis / obstructed infected system → emergent decompression with ureteral stent or percutaneous nephrostomy + IV antibiotics. - AKI from obstruction. - Anuria (solitary kidney). - Intractable pain. - Stone > 10 mm or low spontaneous passage probability. - Failure of conservative + MET. (4) Elective definitive: - Ureteroscopy (URS) with laser lithotripsy + stent — preferred for ureteral stones, especially mid-distal. - Extracorporeal shock wave lithotripsy (ESWL) — non-invasive, good for renal pelvis + upper ureteral < 2 cm; not for cystine, calcium oxalate monohydrate, very hard stones. - Percutaneous nephrolithotomy (PCNL): for renal stones > 2 cm, staghorn, lower pole anatomy unfavorable for ESWL. (5) Metabolic workup after first stone in young or after second stone: 24-hr urine × 2 (calcium, oxalate, citrate, uric acid, Na, volume, pH, creatinine), serum chemistry + PTH + uric acid, stone analysis. Address: high Ca (hypercalciuria — thiazide), high oxalate (dietary calcium, oxalate restriction; pyridoxine for primary hyperoxaluria), low citrate (citrate supplementation, alkalinizing K citrate; thiazide diuretic), uric acid (allopurinol + K citrate; pH > 6.5), cystine (alkalinization + thiol agent). (6) Lifestyle: hydration > 2.5 L/d (UO > 2 L/d), sodium reduction < 2.3 g/d, normal calcium 1000 mg/d (not low — increases enteric oxalate absorption!), reduce animal protein, oxalate moderation (spinach, nuts, chocolate), citrus juice (lemon)

---

Acute ureteral calculus with hypercalciuria + hyperoxaluria. AUA 2016 + 2019 Update Surgical Management of Stones + EAU Urolithiasis guideline: (1) Acute assessment: severity, sepsis screen, AKI, solitary kidney, stone size + location. (2) Imaging: noncontrast CT abdomen-pelvis (NCCT) — gold standard (sensitivity > 95%); US in pregnancy + young avoid radiation (lower sensitivity); KUB plain film for radioopaque follow-up. (3) Acute management: - Hydration (oral preferred; moderate IV if NPO). - Analgesia: NSAID first-line (ketorolac, ibuprofen) — better pain control + reduces ureteral peristalsis; opioid adjunct. - Antiemetic. - Tamsulosin (alpha-1 blocker) MET for distal ureter stones 5-10 mm; debated benefit (Cochrane positive, large RCT SUSPEND negative for some); reasonable trial 4-6 wk; limited for proximal ureter. (4) Indication for intervention/emergent: - Sepsis / pyonephrosis / obstructed infected system → emergent decompression (ureteral stent or percutaneous nephrostomy) + IV antibiotics; URGENT urology. - AKI from obstruction. - Solitary kidney + obstruction. - Intractable pain. - Stone > 10 mm unlikely to pass. (5) Definitive procedures: - Ureteroscopy + laser lithotripsy: preferred for ureteral stones (mid-distal especially); high success. - ESWL: extracorporeal shockwave; non-invasive; for renal pelvis + upper ureter < 2 cm; not for cystine, COM hard, lower pole anatomy. - PCNL: percutaneous nephrolithotomy for > 2 cm renal stones, staghorn, lower pole unfavorable for ESWL. - Open/laparoscopic surgery: rare. (6) Metabolic workup indications: first stone in young < 35, family Hx, recurrent stone, complex (multiple, bilateral, cystine, struvite), CKD, unique anatomy. - 24-hr urine × 2 (Ca, oxalate, citrate, uric acid, Na, volume, Cr, pH). - Serum chemistry + PTH + Vit D + uric acid. - Stone analysis (crystallography). (7) Stone composition guide: - Calcium oxalate (75%): hypercalciuria, hyperoxaluria, hypocitraturia. - Calcium phosphate: high pH (RTA, primary hyperparathyroidism). - Uric acid: low pH, gout, urate overproduction. - Struvite (Mg-NH4-PO4): urease-producing UTI (Proteus, Klebsiella, Staph saprophyticus). - Cystine: cystinuria (autosomal recessive). (8) Prevention by stone type: - Hypercalciuria: thiazide diuretic + low Na + normal Ca diet (not low — paradoxically ↑ enteric oxalate absorption). - Hyperoxaluria: low oxalate diet + adequate dietary Ca + pyridoxine (primary hyperoxaluria); RNAi lumasiran (PH1). - Hypocitraturia: K citrate alkalinization. - Uric acid: alkalinization (K citrate, NaHCO3 to urine pH > 6.5) + allopurinol if hyperuricosuric. - Cystine: alkalinization + hydration + thiol (tiopronin). - Struvite: complete stone removal + antibiotic + acidification; consider acetohydroxamic acid (urease inhibitor). (9) Lifestyle universal: hydration > 2.5 L/d to UO > 2 L; reduce Na, animal protein, oxalate moderate; normal dietary Ca 1000-1200 mg; citrus juice (lemonade); plant protein vs animal; weight reduction if obese. A ผิด — incomplete pain + delayed intervention. C ผิด — open surgery rare. D ผิด — low-Ca diet harmful. E ผิด — prophylactic abx not for non-infected stone.', NULL,
  'medium', 'renal_gu', 'review',
  'internal_medicine', 'clinical_decision', 'renal_gu', 'adult',
  'AUA Guideline on Surgical Management of Stones 2016 (2019 update); EAU Guidelines on Urolithiasis 2024; AUA Guideline on Medical Management of Stones 2014', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'หญิงไทยอายุ 32 ปี ไม่มีโรคประจำตัว มาด้วย ปวดสันหลังด้านล่าง + ปวดข้างขวา + คลื่นไส้ + ปัสสาวะแสบ + เห็นเลือดในปัสสาวะ + ไข้ต่ำ 1 วัน

V/S: BP 124/76, HR 102, RR 16, SpO2 99%, Temp 37.8°C
PE: right CVA tenderness +, no peritonitis, no leg edema

Lab: WBC 12,800, Hb 12.4, Cr 1.0, K 4.0, Ca 11.4 (mild hypercalcemia), Phosphate 3.4, Albumin 4.2, Uric acid 7.2
UA: pH 5.5, RBC 30-50/HPF, WBC 10-15/HPF, no nitrite, crystals + (calcium oxalate)
NCCT abdomen: 8 mm stone right mid-ureter + mild hydronephrosis right, no pyonephrosis, contralateral kidney normal, no obstruction beyond stone
24-hr urine: high oxalate 65 mg, normal citrate, mild hypercalciuria 280 mg/24h
No recent UTI, no fever > 38.5
IVU/CTU: solitary right stone
No prior stone history'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 45 ปี ไม่มีโรคประจำตัว มาด้วย central obesity + striae + proximal muscle weakness + HT new onset + hyperglycemia + osteoporosis + จิตใจ depression

V/S: BP 168/96, HR 88, BMI 32, central obesity, dorsocervical fat pad (buffalo hump), supraclavicular fat, moon face, wide purple abdominal striae > 1 cm, easy bruising, proximal muscle wasting + weakness

Lab: glucose 168, A1c 7.4%, K 3.2, Cr 1.0, lipid: TG 280, LDL 168, HDL 32; A.M. cortisol 28 (normal-high)

Workup confirms hypercortisolism:
- 24-hr urine free cortisol 480 (high)
- Late-night salivary cortisol elevated
- Low-dose dexamethasone suppression test (1 mg overnight): cortisol 18 (not suppressed; normal < 1.8) → CONFIRMS Cushing syndrome
- ACTH 84 (elevated — ACTH-dependent)
- High-dose dexamethasone test (8 mg): cortisol suppression > 50% → suggests pituitary source
- Pituitary MRI: 6 mm microadenoma
- IPSS (inferior petrosal sinus sampling): central-to-peripheral ACTH ratio > 2 confirms pituitary Cushing disease', '[{"label":"A","text":"Bilateral adrenalectomy as first-line"},{"label":"B","text":"Steroidogenesis inhibitors"},{"label":"C","text":"Long-term hydrocortisone replacement only"},{"label":"D","text":"Whole-body radiation therapy"},{"label":"E","text":"Watchful waiting"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cushing disease (ACTH-secreting pituitary adenoma) — Endocrine Society 2015 + Pituitary Society guideline: (1) First-line: transsphenoidal selective adenomectomy by experienced pituitary surgeon — remission 70-90% in microadenoma, lower in macroadenoma + cavernous sinus invasion; (2) Recurrent or persistent post-surgery: - Repeat pituitary surgery if visible residual. - Radiation therapy (stereotactic radiosurgery, fractionated): slow onset months-years; pituitary insufficiency long-term risk. - Medical therapy: - **Steroidogenesis inhibitors**: ketoconazole (LFT monitoring), metyrapone, osilodrostat (FDA 2020 — 11β-hydroxylase inhibitor), levoketoconazole, mitotane (also adrenolytic for adrenal cancer). - **Pituitary-directed**: cabergoline (dopamine agonist — modest); pasireotide (somatostatin analog — hyperglycemia common SE). - **Glucocorticoid receptor blocker**: mifepristone — improves glycemic + clinical features, monitor adrenal insufficiency by clinical + cortisol unreliable. - **Bilateral adrenalectomy**: last resort — provides immediate normalization, but causes lifelong adrenal insufficiency + Nelson syndrome risk (pituitary adenoma growth + hyperpigmentation). (3) Peri-op management: corticosteroid replacement (hydrocortisone) at surgery and pituitary axis recovery in months; monitor for sodium fluctuation (transient SIADH then DI then SIADH); long-term DI from pituitary stalk; pituitary hormone replacement as needed. (4) Address comorbidities while pursuing surgery — antihypertensives, antidiabetic, statin, antiplatelet, anticoagulation (Cushing = hypercoagulable, ↑ VTE — prophylaxis), osteoporosis (Vit D + bisphosphonate), antidepressant; psychiatric symptoms (depression, mania) common; (5) Ectopic ACTH (paraneoplastic — SCLC, carcinoid, MTC, thymic): different workup (chest/abdomen imaging, dotatate scan); manage primary tumor + steroidogenesis inhibitor as bridge; (6) Adrenal source (ACTH-independent — adrenal adenoma, carcinoma, bilateral hyperplasia): unilateral or bilateral adrenalectomy; mitotane for ACC

---

Cushing disease (ACTH-secreting pituitary microadenoma) — most common cause endogenous Cushing syndrome (70%). Endocrine Society 2015 + Pituitary Society Cushing''s syndrome guideline + Newell-Price Lancet 2006: (1) Diagnosis (3 tests, ≥ 2 positive confirms hypercortisolism — ES 2008 + 2015): - 24-hr urine free cortisol × 2-3 (consistent elevation). - Late-night salivary cortisol × 2 (best sensitivity for circadian loss). - Low-dose dexamethasone suppression test (1 mg overnight or 0.5 mg q6h × 2 d): cortisol > 1.8 mcg/dL = abnormal. - Cortisol diurnal rhythm. (2) Etiology workup (after confirmation of hypercortisolism): - ACTH: < 5 → ACTH-independent (adrenal); > 20 → ACTH-dependent; intermediate ambiguous. - ACTH-independent: adrenal CT/MRI → adenoma, carcinoma, bilateral hyperplasia. - ACTH-dependent: high-dose DST (8 mg dex): - Suppression > 50% → pituitary (Cushing disease). - No suppression → ectopic (paraneoplastic — SCLC, carcinoid, MTC, thymic, pancreatic, pheochromocytoma). - Pituitary MRI (50-70% identify adenoma). - IPSS (inferior petrosal sinus sampling) if MRI negative or uncertain: central-to-peripheral ACTH ratio > 2 (basal) or > 3 (CRH-stimulated) → pituitary. - CRH stimulation. - Chest/abdomen CT for ectopic suspicion; somatostatin receptor imaging (Ga-DOTATATE PET). (3) Treatment Cushing disease: - First-line: transsphenoidal selective adenomectomy. Remission microadenoma 70-90%; macroadenoma 30-60%. - Recurrent/persistent (10-20% in microadenoma, higher in macro): repeat surgery, radiotherapy, medical, bilateral adrenalectomy. (4) Medical therapy classes: - Steroidogenesis inhibitors: ketoconazole (LFT monitoring, QT, drug interactions), metyrapone, osilodrostat (FDA 2020), levoketoconazole, mitotane (adrenal carcinoma). - Pituitary-directed: pasireotide (somatostatin analog — hyperglycemia common), cabergoline (dopamine agonist). - Glucocorticoid receptor blocker: mifepristone (Korlym). - Bilateral adrenalectomy: last resort; lifelong adrenal insufficiency + Nelson syndrome (15-30% — adenoma growth + hyperpigmentation; recurrent need for repeat pituitary surgery). (5) Adjunctive treatment of complications: - HT: spironolactone, eplerenone (mineralocorticoid contribution); ACEi/ARB. - DM. - Osteoporosis: Ca, Vit D, bisphosphonate. - VTE prophylaxis (Cushing = hypercoagulable). - Psychiatric: SSRI. - Infection prophylaxis if severe (Pneumocystis). - Steroid replacement after surgery (transient adrenal insufficiency from suppressed pituitary axis recovery 6-18 mo). (6) Post-operative: hydrocortisone replacement, taper based on AM cortisol; monitor for diabetes insipidus (transient), SIADH (post-op water excess). (7) Long-term: monitor for recurrence (cortisol normalcy, IGF-1, ACTH, salivary cortisol); pituitary hormone deficiency. A ผิด — bilateral adrenalectomy is last resort. C ผิด — replacement after curative surgery. D ผิด — focal RT not whole-body. E ผิด — high mortality untreated.', NULL,
  'hard', 'endocrine_metabolic', 'review',
  'internal_medicine', 'clinical_decision', 'endocrine_metabolic', 'adult',
  'Endocrine Society Clinical Practice Guideline: Treatment of Cushing''s Syndrome 2015; Newell-Price J Lancet 2006; Nieman LK Endocrine Society Diagnosis of Cushing 2008', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'im_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'internal_medicine'
      and q.scenario = 'ชายไทยอายุ 45 ปี ไม่มีโรคประจำตัว มาด้วย central obesity + striae + proximal muscle weakness + HT new onset + hyperglycemia + osteoporosis + จิตใจ depression

V/S: BP 168/96, HR 88, BMI 32, central obesity, dorsocervical fat pad (buffalo hump), supraclavicular fat, moon face, wide purple abdominal striae > 1 cm, easy bruising, proximal muscle wasting + weakness

Lab: glucose 168, A1c 7.4%, K 3.2, Cr 1.0, lipid: TG 280, LDL 168, HDL 32; A.M. cortisol 28 (normal-high)

Workup confirms hypercortisolism:
- 24-hr urine free cortisol 480 (high)
- Late-night salivary cortisol elevated
- Low-dose dexamethasone suppression test (1 mg overnight): cortisol 18 (not suppressed; normal < 1.8) → CONFIRMS Cushing syndrome
- ACTH 84 (elevated — ACTH-dependent)
- High-dose dexamethasone test (8 mg): cortisol suppression > 50% → suggests pituitary source
- Pituitary MRI: 6 mm microadenoma
- IPSS (inferior petrosal sinus sampling): central-to-peripheral ACTH ratio > 2 confirms pituitary Cushing disease'
  );

commit;

