-- ===============================================================
-- หมอรู้ — Board seed: กุมารเวชศาสตร์ (pediatrics) — part 4/4 (50 MCQs)
-- Safe to paste into Supabase SQL Editor. Re-runnable.
-- ===============================================================

begin;

-- mcq_subjects for this specialty (idempotent)
insert into public.mcq_subjects
  (name, name_th, icon, audience, board_specialty, exam_type, question_count)
values
  ('peds_clinical_decision', 'กุมารเวชศาสตร์ · การตัดสินใจทางเวชกรรม', '🩺', 'board', 'pediatrics', NULL, 0),
  ('peds_basic_science', 'กุมารเวชศาสตร์ · วิทยาศาสตร์การแพทย์พื้นฐาน', '🧬', 'board', 'pediatrics', NULL, 0),
  ('peds_ems_mgmt', 'กุมารเวชศาสตร์ · การจัดการระบบบริการการแพทย์ฉุกเฉิน', '🚨', 'board', 'pediatrics', NULL, 0),
  ('peds_integrative', 'กุมารเวชศาสตร์ · ข้อสอบบูรณาการ', '🧩', 'board', 'pediatrics', NULL, 0)
on conflict (name) do nothing;

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 5 ปี ตรวจ routine check up พบ murmur fixed split S2 + soft systolic ejection murmur LUSB grade 2-3/6

V/S ปกติ, BW 18 kg, asymptomatic, normal growth
Family Hx: aunt has ASD repaired

ECG: incomplete RBBB, right axis deviation
CXR: mild cardiomegaly, prominent pulmonary vasculature
Echo: ostium secundum ASD 12 mm, L→R shunt, Qp:Qs 2.4, mild RV dilatation, normal LV, normal pulmonary pressure', '[{"label":"A","text":"No intervention needed ever"},{"label":"B","text":"Hemodynamically significant Ostium Secundum ASD (Qp:Qs > 1.5-2 + RV dilation)"},{"label":"C","text":"Heart transplant"},{"label":"D","text":"Watch + wait age 40"},{"label":"E","text":"Diuretic chronic only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hemodynamically significant Ostium Secundum ASD (Qp:Qs > 1.5-2 + RV dilation): elective closure indicated to prevent long-term complications (PHT, atrial arrhythmias, paradoxical embolism, RV failure); TIMING — ideally 2-5 years of age (most defects identified by age, surgery before school age + reduces lifetime risk); MODALITY — TRANSCATHETER closure (Amplatzer Septal Occluder, Gore Cardioform) is FIRST-LINE for secundum ASD with adequate rims + appropriate size (90%+ secundum amenable) — minimally invasive, no sternotomy, shorter recovery, similar long-term outcomes; SURGICAL closure for: primum ASD, sinus venosus, large defect with inadequate rims, very large secundum > 35 mm, associated anomalies, contraindication to device; cardiac MRI for detailed anatomy + RV function; antibiotic prophylaxis NOT routinely required for ASD per AHA 2007 unless prosthetic material in first 6 mo OR residual defect adjacent to device; aspirin 3-5 mg/kg/d × 6 mo post-device closure (anti-platelet for endothelialization); follow-up — echo at 24 hr post + 1 mo + 6 mo + annually; activity — no restriction unless symptomatic; education + screen first-degree relatives (small familial component); long-term: post-closure outcomes excellent if closed before adult atrial arrhythmias develop

---

Secundum ASD = most common ASD. Transcatheter device closure preferred for amenable defects. Close 2-5 yr to prevent adult complications (atrial arrhythmia, PHT, RV dysfunction). Surgery for primum/sinus venosus/inadequate rims. Excellent outcomes if treated.', NULL,
  'medium', 'cardiovascular', 'review',
  'pediatrics', 'clinical_decision', 'cardiovascular', 'peds',
  'AHA/ACC ACHD Guideline 2018; STS Pediatric Cardiac', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 5 ปี ตรวจ routine check up พบ murmur fixed split S2 + soft systolic ejection murmur LUSB grade 2-3/6

V/S ปกติ, BW 18 kg, asymptomatic, normal growth
Family Hx: aunt has ASD repaired

ECG: incomplete RBBB, right axis deviation
CXR: mild cardiomegaly, prominent pulmonary vasculature
Echo: ostium secundum ASD 12 mm, L→R shunt, Qp:Qs 2.4, mild RV dilatation, normal LV, normal pulmonary pressure'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 10 ปี ใจสั่น + เจ็บอกขณะออกกำลังกาย + episodes syncope ขณะเล่นกีฬา 2 ครั้ง 3 mo

V/S: HR 78, BP 110/72, BW 30 kg
PE: harsh ejection systolic murmur 4/6 at RUSB radiating to neck + suprasternal thrill, soft S2, delayed carotid upstroke (parvus et tardus)

ECG: LVH + strain pattern
CXR: prominent aorta, normal heart size
Echo: bicuspid AV (congenital) + severe AS (mean gradient 60 mmHg, peak gradient 90), normal LV function, mild AR', '[{"label":"A","text":"Continue sports unrestricted"},{"label":"B","text":"Severe Congenital Aortic Stenosis (bicuspid) + symptoms = INTERVENTION"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Wait — outgrow"},{"label":"E","text":"Aspirin alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe Congenital Aortic Stenosis (bicuspid) + symptoms = INTERVENTION: cardiology + cardiac surgery urgent; activity RESTRICTION — no competitive sports + no isometric high-intensity activity until intervention (sudden death risk severe AS); BETA-BLOCKER for symptom control before intervention; BALLOON AORTIC VALVULOPLASTY (BAV) — TYPICALLY FIRST-LINE intervention in pediatric AS — minimally invasive, can repeat, postpones valve replacement (durability 5-10 yr typically before need for further intervention); SURGICAL OPTIONS depending on anatomy + age: 1) AV repair if leaflet preservation possible, 2) Ross procedure (pulmonary autograft to aortic position + homograft to PV — preferred in growing children, autograft grows, no anticoagulation, durable) — gold standard pediatric AS surgical; 3) AV REPLACEMENT — mechanical (durable but requires lifelong anticoagulation, problematic growth), bioprosthetic (no anticoagulation but limited durability + redo); 4) APICOAORTIC conduit; antibiotic prophylaxis prior to dental/surgery for prosthetic/repaired with material × 6 mo (AHA); long-term follow-up annually — echo + ECG + symptom + activity; counsel on Marfan/connective tissue + aortopathy/dissection risk with bicuspid AV; family screening (BAV familial component); contraception planning + pregnancy considerations later; transition adult CHD

---

Pediatric AS + symptoms or severe gradient = intervention. BAV first-line typically. Ross procedure preferred surgical for growing children (autograft grows, no anticoagulation). Mechanical valve = lifelong anticoagulation. Bicuspid AV = aortopathy + family screen. Activity restriction critical pre-intervention.', NULL,
  'medium', 'cardiovascular', 'review',
  'pediatrics', 'clinical_decision', 'cardiovascular', 'peds',
  'AHA/ACC Pediatric Cardiology; STS Congenital Cardiac', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 10 ปี ใจสั่น + เจ็บอกขณะออกกำลังกาย + episodes syncope ขณะเล่นกีฬา 2 ครั้ง 3 mo

V/S: HR 78, BP 110/72, BW 30 kg
PE: harsh ejection systolic murmur 4/6 at RUSB radiating to neck + suprasternal thrill, soft S2, delayed carotid upstroke (parvus et tardus)

ECG: LVH + strain pattern
CXR: prominent aorta, normal heart size
Echo: bicuspid AV (congenital) + severe AS (mean gradient 60 mmHg, peak gradient 90), normal LV function, mild AR'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 8 ปี 4 wk ก่อน Hx COVID-19 mild ตอนนี้ ไข้สูง 39.6°C × 6 วัน + conjunctivitis bilateral + ผื่นแดง + ปวดท้องรุนแรง + อาเจียน + diarrhea + ปาก/ลิ้นแดง + edema hands/feet + hypotension shock-like

V/S: HR 142, BP 86/52, RR 32, SpO2 96%, Temp 39.6°C, BW 26 kg
Gen: ill-appearing, mucocutaneous + cardiac + GI

Lab: CRP 285 (very high), ESR 92, fibrinogen 580, ferritin 1,840, D-dimer 3,200, troponin 1.2 (HIGH!), BNP 4,250, lymphopenia, mild AKI Cr 1.4, sodium 132, albumin 2.8, LFT mildly elevated
SARS-CoV-2 IgG positive + PCR negative
Echo: LV dysfunction EF 38%, mild dilation, no coronary aneurysm yet (but Z-score borderline)', '[{"label":"A","text":"Antibiotic alone"},{"label":"B","text":"Multisystem Inflammatory Syndrome in Children (MIS-C, post-COVID hyperinflammation, CDC criteria"},{"label":"C","text":"Steroid alone"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Antiviral alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Multisystem Inflammatory Syndrome in Children (MIS-C, post-COVID hyperinflammation, CDC criteria — fever + multi-system + lab evidence + SARS-CoV-2 exposure/serology + no alt Dx): admit PICU; cardiac monitoring + frequent echo; supportive — IV fluid careful (cardiac dysfunction → measure preload + avoid overload), vasopressor/inotrope as needed (norepinephrine, epinephrine, milrinone for LV dysfunction), respiratory support; IMMUNOMODULATION — first-line IVIG 2 g/kg single infusion + Methylprednisolone 1-2 mg/kg/d IV (low-mod dose) — combination shows improved outcomes (especially with shock/cardiac involvement); for severe/refractory — high-dose pulse methylprednisolone 30 mg/kg/d × 3 d OR anakinra (IL-1 receptor antagonist) 4-10 mg/kg/d SC/IV OR infliximab (anti-TNF) OR tocilizumab — escalation; ASPIRIN 3-5 mg/kg/d (anti-platelet — concurrent treatment with thrombosis prophylaxis); ANTICOAGULATION — enoxaparin prophylactic ALL patients OR therapeutic if thrombosis/severe LV dysfunction/aneurysm; address coronary involvement (z-score) — escalation if dilatation/aneurysm progresses; multidisciplinary — peds cardiology, ID, rheumatology, ICU, hematology; SUPPORTIVE — electrolytes, AKI management; recheck inflammatory markers + echo trending down; vaccination once recovered (COVID + others on schedule); long-term — cardiac function follow-up 6-12 mo, exercise tolerance, NSAID/anticoagulation duration; report to local public health + national database; family education + return precautions if recurrent fever

---

MIS-C = hyperinflammatory syndrome 2-6 wk after SARS-CoV-2 (mimics KD + TSS). CDC criteria. IVIG + steroid combination first-line. Cardiac involvement common (LV dysfunction, coronaries). Aspirin + anticoagulation. Escalation (anakinra) for refractory. Multidisciplinary + long-term cardiac follow-up.', NULL,
  'hard', 'cardiovascular', 'review',
  'pediatrics', 'clinical_decision', 'cardiovascular', 'peds',
  'AHA Scientific Statement MIS-C 2022; ACR Clinical Guidance for MIS-C', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 8 ปี 4 wk ก่อน Hx COVID-19 mild ตอนนี้ ไข้สูง 39.6°C × 6 วัน + conjunctivitis bilateral + ผื่นแดง + ปวดท้องรุนแรง + อาเจียน + diarrhea + ปาก/ลิ้นแดง + edema hands/feet + hypotension shock-like

V/S: HR 142, BP 86/52, RR 32, SpO2 96%, Temp 39.6°C, BW 26 kg
Gen: ill-appearing, mucocutaneous + cardiac + GI

Lab: CRP 285 (very high), ESR 92, fibrinogen 580, ferritin 1,840, D-dimer 3,200, troponin 1.2 (HIGH!), BNP 4,250, lymphopenia, mild AKI Cr 1.4, sodium 132, albumin 2.8, LFT mildly elevated
SARS-CoV-2 IgG positive + PCR negative
Echo: LV dysfunction EF 38%, mild dilation, no coronary aneurysm yet (but Z-score borderline)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 6 ปี on chemotherapy for ALL (induction phase, severely immunocompromised) แม่บอกพี่น้องเป็นอีสุกอีใส 14 วันก่อน — ตอนนี้พบ vesicular rash บน trunk + face 2 lesions ใหม่ ๆ + ไข้ 38.4°C

V/S: HR 122, RR 28, Temp 38.4°C, BW 20 kg
PE: 5-6 vesicles trunk + face on erythematous base (early), no respiratory distress, no encephalopathy currently, no severe LFT change

WBC neutropenia 220 (severely low), Plt 38,000, mild LFT elevation', '[{"label":"A","text":"Outpatient oral acyclovir"},{"label":"B","text":"Varicella in severely immunocompromised child = EMERGENCY (high mortality if disseminated)"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Withhold all treatment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Varicella in severely immunocompromised child = EMERGENCY (high mortality if disseminated): admit + IV Acyclovir 500 mg/m² q8h (or 10 mg/kg/dose q8h) IV × 7-10 days minimum (longer if continued lesions/disseminated/visceral), adjusted for renal function; oral acyclovir/valacyclovir INADEQUATE in this population; supportive — hydration (acyclovir crystalluria, maintain UO good), antipyretic AVOID ASPIRIN (Reye risk + transmission concern), antipruritic, prevent secondary bacterial infection (Staph, GAS — superinfection can be severe); careful skin/wound care + bath; monitor for VISCERAL DISSEMINATION — pneumonitis (severe, high mortality), encephalitis, hepatitis, DIC, hemorrhagic varicella — manage in ICU; isolate airborne + contact precautions (until lesions crusted, no new × 24 hr); REMOVE/REDUCE chemotherapy temporarily (coordinate oncology — risk infection vs cancer); POST-EXPOSURE for immunocompromised + susceptible contacts: VZIG (VariZIG) 125 U/10 kg IM (max 625 U) within 96 hr (extended to 10 d post-exposure) — passive immunization; alternative IVIG if VZIG unavailable; antiviral prophylaxis acyclovir 800 mg PO QID × 7 d (days 7-22 post-exposure) for high-risk susceptible if VZIG unavailable; prevention — VARIVAX vaccine for healthy + select immunocompetent contacts; long-term: full immunity post-recovery; vaccination once chemo completed + immune recovery

---

Varicella + severe immunocompromise (ALL on chemo, post-transplant, congenital immunodeficiency) = high mortality if untreated. IV acyclovir mandatory (oral inadequate). Watch visceral dissemination + bacterial superinfection. Post-exposure prophylaxis VZIG or acyclovir for susceptible immunocompromised contacts within 10 d.', NULL,
  'medium', 'id', 'review',
  'pediatrics', 'clinical_decision', 'id', 'peds',
  'AAP Red Book 2024 Varicella; CDC ACIP Varicella Recommendations', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 6 ปี on chemotherapy for ALL (induction phase, severely immunocompromised) แม่บอกพี่น้องเป็นอีสุกอีใส 14 วันก่อน — ตอนนี้พบ vesicular rash บน trunk + face 2 lesions ใหม่ ๆ + ไข้ 38.4°C

V/S: HR 122, RR 28, Temp 38.4°C, BW 20 kg
PE: 5-6 vesicles trunk + face on erythematous base (early), no respiratory distress, no encephalopathy currently, no severe LFT change

WBC neutropenia 220 (severely low), Plt 38,000, mild LFT elevation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 4 ปี vaccine ไม่ครบ (no MMR), เพิ่งเดินทางกลับจาก outbreak area ในต่างประเทศ ตอนนี้ ไข้สูง 40°C × 5 วัน + cough + coryza + conjunctivitis + Koplik spots (white spots on red base buccal mucosa) → ผื่นแดงเริ่มหน้าก่อน แล้วลามลงตัว 2 วัน + คอเจ็บ + เริ่มหอบเหนื่อย + ไม่ได้กิน vit A

V/S: HR 142, RR 48, SpO2 92%, Temp 40°C, BW 16 kg
PE: morbilliform rash trunk + extremities, conjunctivitis, Koplik (resolving), bilateral crackles + decreased breath sounds RLL
CXR: bilateral interstitial + RLL consolidation
CBC: lymphopenia
Measles IgM positive + PCR positive', '[{"label":"A","text":"Antiviral alone curative"},{"label":"B","text":"Measles with secondary pneumonia (major complication, leading cause measles death)"},{"label":"C","text":"Discharge no follow"},{"label":"D","text":"Steroid alone"},{"label":"E","text":"Antifungal"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Measles with secondary pneumonia (major complication, leading cause measles death) — vaccine-preventable disease: admit + isolation airborne (negative pressure room if available, mask) until 4 d after rash onset; SUPPORTIVE — adequate hydration, antipyretic acetaminophen (AVOID aspirin), oxygen as needed to maintain SpO2 ≥ 92%, nutritional support; ANTIBIOTIC for bacterial pneumonia superinfection — empiric Ceftriaxone (covers Spn, H flu) + add anti-Staph (vancomycin) if severe/MRSA risk × 7-10 d; VITAMIN A SUPPLEMENT — proven to reduce measles morbidity + mortality especially in malnourished/vit A deficient — 200,000 IU PO single dose for > 1 yr (100,000 < 1 yr, 50,000 < 6 mo) — repeat day 2 + 2-4 wk if signs of vit A deficiency + measles severe (WHO standard); ANTIVIRAL — ribavirin investigational + only for severe cases (no routine antiviral measles); no specific approved antiviral; bacterial complications include AOM, pneumonia, mastoiditis, croup; OTHER COMPLICATIONS to watch — encephalitis 0.1-0.2% (high mortality + morbidity), SSPE (subacute sclerosing panencephalitis) rare delayed years later (degenerative); blindness from corneal scarring (vit A deficiency); diarrhea + malnutrition; POST-EXPOSURE PROPHYLAXIS for susceptible contacts within 72 hr (MMR vaccine — but contraindicated < 6 mo + pregnant + severely immunocompromised) OR within 6 d (immune globulin 0.5 mL/kg max 15 mL — for immunocompromised, pregnant, < 12 mo); reportable urgent + public health response; quarantine contacts 21 d if susceptible; vaccination key prevention (MMR 2-dose); long-term — immune amnesia (immune system reset post-measles, increased susceptibility 1-3 yr)

---

Measles = highly contagious, reportable, vaccine-preventable. Pneumonia leading complication. Vitamin A WHO/AAP recommendation. Bacterial superinfection antibiotic. Watch encephalitis + SSPE. PEP within 72 hr MMR or within 6 d immune globulin for susceptible. Vaccination 2-dose prevention.', NULL,
  'medium', 'id', 'review',
  'pediatrics', 'clinical_decision', 'id', 'peds',
  'AAP Red Book 2024 Measles; CDC ACIP MMR; WHO Vit A in Measles', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 4 ปี vaccine ไม่ครบ (no MMR), เพิ่งเดินทางกลับจาก outbreak area ในต่างประเทศ ตอนนี้ ไข้สูง 40°C × 5 วัน + cough + coryza + conjunctivitis + Koplik spots (white spots on red base buccal mucosa) → ผื่นแดงเริ่มหน้าก่อน แล้วลามลงตัว 2 วัน + คอเจ็บ + เริ่มหอบเหนื่อย + ไม่ได้กิน vit A

V/S: HR 142, RR 48, SpO2 92%, Temp 40°C, BW 16 kg
PE: morbilliform rash trunk + extremities, conjunctivitis, Koplik (resolving), bilateral crackles + decreased breath sounds RLL
CXR: bilateral interstitial + RLL consolidation
CBC: lymphopenia
Measles IgM positive + PCR positive'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 12 ปี ค่อย ๆ มีไข้ + ไอ persistent dry x 2-3 wk + ปวดศีรษะ + sore throat + myalgia + ไม่ค่อยตอบสนองต่อ ampicillin ขั้น primary care

V/S: HR 102, RR 28, SpO2 95%, Temp 38.4°C, BW 36 kg
Gen: not toxic, persistent dry cough, scattered crackles bilateral, mild wheeze, no consolidation pattern

CXR: bilateral interstitial + perihilar infiltrate (looks worse than clinical exam — classic for atypical)
CBC: WBC 9,200 normal, mild lymphopenia
Cold agglutinins positive; Mycoplasma IgM positive + PCR positive (current preferred)
Family: sibling sick with similar 4 wk ago', '[{"label":"A","text":"Continue ampicillin"},{"label":"B","text":"Mycoplasma pneumoniae pneumonia (atypical pneumonia, school-age + adolescent peak)"},{"label":"C","text":"Antifungal alone"},{"label":"D","text":"Steroid alone"},{"label":"E","text":"No antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mycoplasma pneumoniae pneumonia (atypical pneumonia, school-age + adolescent peak): antibiotic effective against atypical pathogens — Macrolide first-line (Azithromycin 10 mg/kg day 1 then 5 mg/kg × 4 d OR Clarithromycin 7.5 mg/kg q12h × 7-10 d OR Erythromycin); MACROLIDE RESISTANCE rising globally (especially Asia) — if no clinical improvement 48-72 hr or known high-resistance area → consider DOXYCYCLINE 4 mg/kg/d ÷ q12h × 7-10 d (now recommended ALL ages per IDSA 2020 for short courses, formerly restricted > 8 yr) OR Fluoroquinolone (levofloxacin) selected (off-label peds, reserve); supportive — antipyretic, hydration, monitoring; usually outpatient unless severe (hypoxia, distress, dehydration, immunocompromised); EXTRAPULMONARY MANIFESTATIONS to watch — hemolytic anemia (cold agglutinin), encephalitis (rare but devastating), Mycoplasma-induced rash + mucositis (MIRM), Stevens-Johnson syndrome variant, arthritis, myocarditis; consider hospitalization if extrapulmonary; immunity not lifelong → can reinfect; outbreaks among schools/families; no vaccine; identify clinical context — Mycoplasma should be considered school-age + adolescent with atypical features (gradual onset, prolonged cough, normal-mild CBC, bilateral patchy CXR, extrapulmonary, exposure)

---

Mycoplasma = atypical pneumonia school-age + adolescent. CXR worse than clinical. Cold agglutinin + extrapulmonary manifestations (MIRM, SJS, hemolytic anemia, encephalitis). Macrolide first-line; doxycycline (all ages 2020) or fluoroquinolone for macrolide-resistance. No vaccine; reinfection possible.', NULL,
  'medium', 'respiratory', 'review',
  'pediatrics', 'clinical_decision', 'respiratory', 'peds',
  'PIDS/IDSA Pediatric CAP Guideline 2011; IDSA Pediatric Antibiotic Guideline 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 12 ปี ค่อย ๆ มีไข้ + ไอ persistent dry x 2-3 wk + ปวดศีรษะ + sore throat + myalgia + ไม่ค่อยตอบสนองต่อ ampicillin ขั้น primary care

V/S: HR 102, RR 28, SpO2 95%, Temp 38.4°C, BW 36 kg
Gen: not toxic, persistent dry cough, scattered crackles bilateral, mild wheeze, no consolidation pattern

CXR: bilateral interstitial + perihilar infiltrate (looks worse than clinical exam — classic for atypical)
CBC: WBC 9,200 normal, mild lymphopenia
Cold agglutinins positive; Mycoplasma IgM positive + PCR positive (current preferred)
Family: sibling sick with similar 4 wk ago'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 6 ปี BW 24 kg ครอบครัวสังเกตว่าลูกนอนกรน + หยุดหายใจ episodes 5-10 sec ขณะนอน + restless sleep + ตื่นเช้าง่วงนอน + พฤติกรรมหลังตื่น hyperactive + ผลการเรียนตก + ปัสสาวะรดที่นอน + mouth breathing daytime

PE: tonsils 3+ enlarged + adenoid facies (long face, open mouth), BMI 19, nasal congestion mild, no obstruction other; growth ปกติ
Polysomnography: AHI 14 events/hr (moderate-severe OSA in peds — AHI > 5 in kids = OSA, > 10 = moderate, > 15 = severe), oxygen desaturation nadir 82%, no central apnea, snoring throughout', '[{"label":"A","text":"Watchful waiting"},{"label":"B","text":"Pediatric Moderate-Severe Obstructive Sleep Apnea"},{"label":"C","text":"Discharge no treatment"},{"label":"D","text":"Antibiotic alone"},{"label":"E","text":"Sedative for sleep"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Moderate-Severe Obstructive Sleep Apnea — ENT referral + adenotonsillectomy FIRST-LINE: surgical adenotonsillectomy success rate 70-80% pediatric OSA cure, addresses adenoid + tonsillar hypertrophy (most common cause); pre-op evaluation — anesthesia consult (post-op respiratory complications — especially < 3 yr, severe OSA, obesity, syndromes — admit overnight monitoring); supportive — humidified air, nasal saline, treat allergic rhinitis (intranasal corticosteroid + montelukast may help mild OSA pre-surgery + persistent post-op residual OSA); WATCH for post-op complications — bleeding (primary 24 hr, secondary 5-10 d), respiratory compromise, dehydration; if residual OSA post-surgery → CPAP/BiPAP titrated (PSG repeat 6-8 wk post-op); ADDRESS COMORBIDITIES — obesity weight management, allergic rhinitis, GERD, craniofacial syndromes (Pierre Robin, Treacher Collins, Crouzon — different approach), neuromuscular weakness, Down syndrome (higher OSA prevalence + risk + post-op edema); long-term sequelae untreated — cardiovascular (pulmonary HT, RV dysfunction), neurocognitive + behavioral (ADHD-like), failure to thrive, enuresis; family education — observe post-op recovery, return precautions; PSG repeat 6-8 wk post-op if symptoms persist; transition adult OSA if persists adolescence + adulthood

---

Pediatric OSA different from adult — adenotonsillar hypertrophy primary cause. Adenotonsillectomy first-line (70-80% cure). PSG diagnostic + AHI > 5 in kids = OSA. Comorbidities (obesity, Down, craniofacial). CPAP for residual OSA. Long-term cardiovascular + neurobehavioral sequelae untreated.', NULL,
  'medium', 'respiratory', 'review',
  'pediatrics', 'clinical_decision', 'respiratory', 'peds',
  'AAP Clinical Practice Guideline: Pediatric OSA 2012', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 6 ปี BW 24 kg ครอบครัวสังเกตว่าลูกนอนกรน + หยุดหายใจ episodes 5-10 sec ขณะนอน + restless sleep + ตื่นเช้าง่วงนอน + พฤติกรรมหลังตื่น hyperactive + ผลการเรียนตก + ปัสสาวะรดที่นอน + mouth breathing daytime

PE: tonsils 3+ enlarged + adenoid facies (long face, open mouth), BMI 19, nasal congestion mild, no obstruction other; growth ปกติ
Polysomnography: AHI 14 events/hr (moderate-severe OSA in peds — AHI > 5 in kids = OSA, > 10 = moderate, > 15 = severe), oxygen desaturation nadir 82%, no central apnea, snoring throughout'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 14 ปี BMI 30 (obesity) presented with headache + nosebleed × 3 วัน — no other neurologic symptoms

V/S: BP 168/108 (severely elevated > 95th + 12 mmHg) confirmed × 3 separate measurements, HR 92, BW 68 kg, no signs end-organ damage (no papilledema, no AKI, no encephalopathy, no LVH on ECG, no neuro deficit)
Lab: Cr 0.8, K 3.6, glucose 102, UA negative, plasma renin/aldosterone normal, TSH normal, urine catecholamines pending
US renal: normal anatomy', '[{"label":"A","text":"Discharge home"},{"label":"B","text":"Pediatric Hypertensive Urgency (severe HT WITHOUT end-organ damage"},{"label":"C","text":"Sublingual nifedipine"},{"label":"D","text":"IV nitroprusside"},{"label":"E","text":"Wait — outgrow"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Hypertensive Urgency (severe HT WITHOUT end-organ damage — vs emergency WITH damage): admit observation, GRADUAL oral antihypertensive treatment over 24-48 hr (not minutes-hours like emergency); first-line oral options — Captopril 0.3-0.5 mg/kg/dose q8h (ACEI, fast onset 15-30 min, monitor renal function) OR Hydralazine 0.1-0.2 mg/kg/dose q4-6h (vasodilator) OR Labetalol oral 1-3 mg/kg/dose q12h (beta + alpha block) OR Nifedipine immediate release (NOT sublingual — avoid sudden drops, but oral 0.25-0.5 mg/kg may be acceptable in some pediatric protocols, used cautiously); avoid abrupt + excessive lowering; goal — reduce BP gradually over 24-48 hr aim < 95th percentile; identify cause — workup secondary HT (renal — US + DMSA + MRA renal arteries if young; endocrine — pheochromocytoma + neuroblastoma catecholamines, Cushing, hyperaldosteronism, thyroid; coarctation re-eval; OSA screen; medication-induced; oral contraceptive; sympathomimetic, illicit drugs); LIFESTYLE — weight management (this patient overweight), DASH diet, sodium reduction, increase activity, address screen time + sleep; long-term oral antihypertensive — ACEI (lisinopril) OR ARB (losartan) OR CCB (amlodipine) OR thiazide first-line per AAP 2017; reassess + titrate q1-4 wk; ABPM for white coat HT; address comorbid CV risk; family + school education

---

Pediatric HT urgency = severely elevated BP WITHOUT end-organ damage. Treat gradually with oral antihypertensives over 24-48 hr (vs IV emergency). Workup secondary cause. Lifestyle + pharmacotherapy long-term. AAP 2017 Guideline. Goal < 95th percentile.', NULL,
  'medium', 'cardiovascular', 'review',
  'pediatrics', 'clinical_decision', 'cardiovascular', 'peds',
  'AAP Clinical Practice Guideline: HT in Children 2017', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 14 ปี BMI 30 (obesity) presented with headache + nosebleed × 3 วัน — no other neurologic symptoms

V/S: BP 168/108 (severely elevated > 95th + 12 mmHg) confirmed × 3 separate measurements, HR 92, BW 68 kg, no signs end-organ damage (no papilledema, no AKI, no encephalopathy, no LVH on ECG, no neuro deficit)
Lab: Cr 0.8, K 3.6, glucose 102, UA negative, plasma renin/aldosterone normal, TSH normal, urine catecholamines pending
US renal: normal anatomy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 11 ปี เริ่มเหนื่อยง่าย + ทนหนาวไม่ค่อยได้ + น้ำหนักเพิ่ม 4 kg ใน 6 mo despite same diet + ผลการเรียนลดลง + skin dry + hair coarse + constipation + delayed puberty Tanner 2

V/S: HR 58, BP 102/68, BW 42 kg, growth velocity slowed (4 cm/yr from baseline 6 cm/yr)
PE: diffuse goiter symmetric firm rubbery, dry skin, mild bradycardia, normal reflexes (no delayed relaxation severe yet), proportional growth

Lab: TSH 38 (high), Free T4 0.5 (low), Free T3 low-normal
Anti-thyroid peroxidase (anti-TPO) HIGH, Anti-thyroglobulin elevated = autoimmune (Hashimoto thyroiditis)
Family: mother Hashimoto + sister type 1 DM', '[{"label":"A","text":"Methimazole"},{"label":"B","text":"Acquired Primary Hypothyroidism (Hashimoto thyroiditis, most common cause peds acquired hypothyroidism)"},{"label":"C","text":"Iodine high dose"},{"label":"D","text":"Surgery"},{"label":"E","text":"Discharge no treatment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acquired Primary Hypothyroidism (Hashimoto thyroiditis, most common cause peds acquired hypothyroidism): LEVOTHYROXINE replacement starting dose pediatric (~3-5 mcg/kg/d adolescent, lower for younger child age-specific) — start lower in long-standing severe hypothyroidism then titrate up (avoid cardiac arrhythmia / pseudotumor cerebri / accelerated growth/bone age); take EMPTY STOMACH 30-60 min before food + separated from calcium/iron/PPI/soy (interfere absorption); RECHECK TSH + Free T4 q4-6 wk while titrating, then q6-12 mo once stable (TSH lag 6 wk after dose change); target TSH normal range (0.5-4) + Free T4 mid-normal range; INVESTIGATE associated autoimmune conditions (DM1, celiac, Addison, vitiligo, Sjogren, alopecia) + screen family; monitor growth + puberty progression (resume after euthyroid); educate family + child — lifelong condition + medication adherence; long-term — most stable euthyroid on replacement, occasional fluctuation, repeat scan if structural concern (rare cancer in pediatric Hashimoto); psychosocial support — initial mood/cognition affects; consider growth specialist if growth severely impaired; adolescent transition; AVOID — methimazole/PTU (those for hyperthyroidism), surgery (no indication)

---

Hashimoto thyroiditis = most common acquired hypothyroidism kids + adolescents. Levothyroxine replacement + monitoring TSH/Free T4. Screen associated autoimmune. Family history common. Lifelong treatment. Avoid antithyroid agents (those for Graves).', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'pediatrics', 'clinical_decision', 'endocrine_metabolic', 'peds',
  'PES Pediatric Hypothyroidism Guidelines; AAP Endocrinology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 11 ปี เริ่มเหนื่อยง่าย + ทนหนาวไม่ค่อยได้ + น้ำหนักเพิ่ม 4 kg ใน 6 mo despite same diet + ผลการเรียนลดลง + skin dry + hair coarse + constipation + delayed puberty Tanner 2

V/S: HR 58, BP 102/68, BW 42 kg, growth velocity slowed (4 cm/yr from baseline 6 cm/yr)
PE: diffuse goiter symmetric firm rubbery, dry skin, mild bradycardia, normal reflexes (no delayed relaxation severe yet), proportional growth

Lab: TSH 38 (high), Free T4 0.5 (low), Free T3 low-normal
Anti-thyroid peroxidase (anti-TPO) HIGH, Anti-thyroglobulin elevated = autoimmune (Hashimoto thyroiditis)
Family: mother Hashimoto + sister type 1 DM'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 6 ปี พ่อแม่สังเกตว่ามี cafe-au-lait macules หลายจุด (8 จุด > 5 mm) + freckling axillary + Lisch nodules iris bilateral (slit-lamp + ในตา) + first-degree relative (พ่อ) มี NF-1

PE: > 6 CAL spots > 5 mm prepubertal, axillary + inguinal freckling, Lisch nodules, no plexiform NF currently, no skeletal deformity, normal development, BW + height normal

Clinical NIH criteria met for NF-1 ( ≥ 2 features)
No malignancy currently, MRI brain + spine pending baseline', '[{"label":"A","text":"No follow-up needed"},{"label":"B","text":"Neurofibromatosis Type 1 (NF1 = autosomal dominant, NF1 gene chromosome 17, ~50% spontaneous mutation)"},{"label":"C","text":"Surgery only no follow-up"},{"label":"D","text":"Chemotherapy preventive"},{"label":"E","text":"Wait — outgrow"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neurofibromatosis Type 1 (NF1 = autosomal dominant, NF1 gene chromosome 17, ~50% spontaneous mutation) — multispecialty surveillance + management: GENETIC confirmation (NF1 sequencing) + counseling (50% offspring risk + 50% sporadic); MULTIDISCIPLINARY annual evaluation — pediatric neurology + ophthalmology + dermatology + orthopedics + oncology + cardiology + psychology + special education; ANNUAL OPHTHALMOLOGY — Lisch nodules + screen optic pathway glioma (most common CNS tumor NF1, peak 4-6 yr, surveillance MRI annual age 1-7 then if symptoms); annual GROWTH/PUBERTY/BP — early puberty + HT (pheochromocytoma — rare but evaluate if symptoms, renal artery stenosis — important treatable cause HT in NF1); ANNUAL SKIN exam — neurofibromas + plexiform NF (risk MPNST malignant transformation 5-10% lifetime); ANNUAL SKELETAL exam — scoliosis (common, severe + dysplastic), pseudoarthrosis tibia/fibula (typically congenital), sphenoid wing dysplasia; LEARNING DISABILITY 50% — neuropsychology + IEP + school accommodations; MRI brain baseline (most centers) + selective spine; AVOID elective IR + radiation if possible (NF1 = increased second malignancy risk); WATCH/EARLY DETECT — MPNST (Malignant Peripheral Nerve Sheath Tumor) — most common cancer NF1 adolescent/adult — rapid growth, pain, neurological symptoms = workup PET/MRI/biopsy urgent; AML, brain tumors, GIST, leukemia + breast cancer adult women NF1 (earlier screening mammogram 30); selumetinib (MEK inhibitor) FDA-approved for inoperable plexiform NF1 ≥ 2 yr with morbidity — significant benefit; FAMILY support + education + transition adult; pregnancy planning — NF1 women high-risk pregnancy + complications + half offspring inherit

---

NF1 = AD genetic disorder, multisystem manifestations. NIH criteria. Comprehensive multispecialty annual surveillance for tumor (OPG, MPNST), HT (RAS, pheo), skeletal (scoliosis), cognitive (LD), psychosocial. Selumetinib for plexiform NF. Genetic counseling. Long-term cancer surveillance.', NULL,
  'medium', 'neurology', 'review',
  'pediatrics', 'basic_science', 'neurology', 'peds',
  'Children''s Tumor Foundation NF1 Guidelines; AAP Health Supervision NF1', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 6 ปี พ่อแม่สังเกตว่ามี cafe-au-lait macules หลายจุด (8 จุด > 5 mm) + freckling axillary + Lisch nodules iris bilateral (slit-lamp + ในตา) + first-degree relative (พ่อ) มี NF-1

PE: > 6 CAL spots > 5 mm prepubertal, axillary + inguinal freckling, Lisch nodules, no plexiform NF currently, no skeletal deformity, normal development, BW + height normal

Clinical NIH criteria met for NF-1 ( ≥ 2 features)
No malignancy currently, MRI brain + spine pending baseline'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกหญิงอายุ 6 mo ตอนคลอดพ่อแม่สังเกตว่ามี hypomelanotic macules (ash-leaf spots) หลายจุด — สังเกตได้ด้วย Wood''s lamp; ตอนนี้ infantile spasms (hypsarrhythmia EEG +) เริ่ม 4 mo + developmental regression + cardiac murmur ที่เคยตรวจ pre-natal มี rhabdomyoma

PE: > 3 hypomelanotic macules trunk + extremities, shagreen patch lumbar back, no facial angiofibroma yet (too young)
Echo: multiple cardiac rhabdomyomas (non-obstructive)
Brain MRI: multiple cortical tubers + subependymal nodules + subependymal giant cell astrocytoma (SEGA) borderline size
US renal: small angiomyolipomas + cysts bilateral
Genetics: TSC2 mutation positive', '[{"label":"A","text":"Discharge no follow-up"},{"label":"B","text":"Tuberous Sclerosis Complex (TSC, autosomal dominant TSC1/TSC2 gene"},{"label":"C","text":"Surgery only"},{"label":"D","text":"Single antiepileptic alone"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Tuberous Sclerosis Complex (TSC, autosomal dominant TSC1/TSC2 gene → hyperactive mTOR pathway): multidisciplinary lifelong care — neurology + cardiology + nephrology + dermatology + ophthalmology + neuropsychology + special education + genetics; INFANTILE SPASMS treatment — first-line VIGABATRIN (preferred in TSC, evidence superior to ACTH in TSC), monitor retinal toxicity (vigabatrin retinal field defect); alternative ACTH; ketogenic diet adjunct; epilepsy surgery if focal resistant; CONTROL EPILEPSY critical for cognitive outcome; mTOR INHIBITORS — Everolimus (FDA-approved for SEGA, renal angiomyolipoma, refractory epilepsy in TSC ≥ 1 yr) revolutionized treatment + can shrink tumors; SEGA surveillance — MRI annual + watch growth, hydrocephalus, neuro symptoms — surgical resection vs everolimus (decision per anatomy + symptoms); RENAL angiomyolipomas — surveillance + bleeding risk (large > 3 cm), everolimus or embolization or partial nephrectomy; CARDIAC rhabdomyoma — most regress spontaneously childhood, surgery rarely needed unless obstruction/arrhythmia; SKIN — facial angiofibromas topical sirolimus, surgical/laser for cosmesis; DENTAL — pitting/enamel; PULMONARY — lymphangioleiomyomatosis (LAM) women adolescence/adult; INTELLECTUAL DISABILITY 50% — early intervention + IEP; AUTISM spectrum 30-60% — early intervention; PSYCHIATRIC + ADHD common; CANCER surveillance — renal cell carcinoma + others; FAMILY genetic counseling (AD, 25-67% sporadic vs inherited); transition adult care; updated TSC consensus 2021 + 2024

---

TSC = autosomal dominant, mTOR pathway. Multisystem: brain (tubers, SEGA, infantile spasms, autism, LD), cardiac (rhabdomyoma — regress), renal (AML, cysts), skin, eye, lung (LAM adults). Vigabatrin first-line for infantile spasms in TSC. mTOR inhibitor everolimus revolutionized. Multidisciplinary lifelong.', NULL,
  'medium', 'neurology', 'review',
  'pediatrics', 'basic_science', 'neurology', 'peds',
  'TSC Consensus Conference 2012 + 2021 updates; PES Pediatric Neurology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกหญิงอายุ 6 mo ตอนคลอดพ่อแม่สังเกตว่ามี hypomelanotic macules (ash-leaf spots) หลายจุด — สังเกตได้ด้วย Wood''s lamp; ตอนนี้ infantile spasms (hypsarrhythmia EEG +) เริ่ม 4 mo + developmental regression + cardiac murmur ที่เคยตรวจ pre-natal มี rhabdomyoma

PE: > 3 hypomelanotic macules trunk + extremities, shagreen patch lumbar back, no facial angiofibroma yet (too young)
Echo: multiple cardiac rhabdomyomas (non-obstructive)
Brain MRI: multiple cortical tubers + subependymal nodules + subependymal giant cell astrocytoma (SEGA) borderline size
US renal: small angiomyolipomas + cysts bilateral
Genetics: TSC2 mutation positive'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารก term DOL 1 (age 14 ชม), แม่ GBS+ ได้ IAP intrapartum penicillin > 4 hr ก่อนคลอด ตอนนี้ทารกอาการแย่ลง — temperature instability + respiratory distress + cyanosis + poor feeding + lethargy

V/S: HR 184, RR 78, Temp 35.8°C (hypothermia), SpO2 88%, capillary refill 5 sec
Gen: lethargic, mottled, weak pulses, mild grunting, retractions, jaundice mild

CBC: WBC 28,000 + immature/total ratio 0.4 (HIGH), Plt 78,000, glucose 38, lactate 5.2
ABG: pH 7.18, BE -12
CXR: bilateral patchy infiltrate
Blood culture × 2 pending; LP pending; CRP 95', '[{"label":"A","text":"Wait for culture results"},{"label":"B","text":"Early-Onset Neonatal Sepsis (likely GBS despite IAP"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Antiviral alone"},{"label":"E","text":"Single antibiotic narrow spectrum"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Early-Onset Neonatal Sepsis (likely GBS despite IAP — IAP reduces but doesn''t eliminate): IMMEDIATE recognition + treat as septic shock; ABC — airway + breathing (consider intubation given respiratory distress + impending failure); CIRCULATION — IV/IO access × 2 within minutes; aggressive fluid resuscitation 10-20 mL/kg NSS BOLUS over 5-10 min repeat as needed reassessing after each (target normal perfusion); empiric BROAD-SPECTRUM IV antibiotic within FIRST HOUR — Ampicillin 100-150 mg/kg/dose q6h + Gentamicin 4 mg/kg/dose q24h IV (covers GBS, E. coli, Listeria, gram-negatives); if meningitis confirmed (LP after stabilization, NOT delaying antibiotic) → add Cefotaxime 50 mg/kg/dose q6-8h + extend duration; correct hypoglycemia D10W 2 mL/kg bolus + ongoing infusion; correct acidosis (volume + antibiotic), electrolytes; VASOPRESSOR if fluid-refractory shock — DOPAMINE 5-15 mcg/kg/min OR EPINEPHRINE 0.05-0.3 mcg/kg/min (preferred cold shock — neonates often cold); HYDROCORTISONE if catecholamine-resistant; NEONATAL ICU; monitor for DIC (FFP + platelet if active bleed/severe consumption); intubation + surfactant if respiratory failure; ECMO selected refractory; serial lactate + perfusion; antibiotic duration 10 d uncomplicated bacteremia, 14-21 d meningitis (GBS), longer for complications; supportive — temp regulation, glucose, electrolytes, nutrition, family support; vaccine on schedule once recovered; audiology + neuroimaging + developmental follow-up; counsel family — outcome variable, prevention via IAP + new maternal GBS vaccine in development

---

Early-onset sepsis = leading cause neonatal mortality. GBS most common despite IAP (reduces but doesn''t eliminate). Recognize signs (temp instability, respiratory, poor feeding, lethargy, mottling). Empiric ampicillin + gentamicin within 1 hr. Aggressive fluid + vasopressor + ICU. Antibiotic duration per Dx. Long-term sequelae.', NULL,
  'hard', 'id', 'review',
  'pediatrics', 'clinical_decision', 'id', 'peds',
  'AAP COFN/COID Sepsis in Newborns 2018; Surviving Sepsis Pediatric 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารก term DOL 1 (age 14 ชม), แม่ GBS+ ได้ IAP intrapartum penicillin > 4 hr ก่อนคลอด ตอนนี้ทารกอาการแย่ลง — temperature instability + respiratory distress + cyanosis + poor feeding + lethargy

V/S: HR 184, RR 78, Temp 35.8°C (hypothermia), SpO2 88%, capillary refill 5 sec
Gen: lethargic, mottled, weak pulses, mild grunting, retractions, jaundice mild

CBC: WBC 28,000 + immature/total ratio 0.4 (HIGH), Plt 78,000, glucose 38, lactate 5.2
ABG: pH 7.18, BE -12
CXR: bilateral patchy infiltrate
Blood culture × 2 pending; LP pending; CRP 95'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 11 ปี เริ่มกิน carbamazepine สำหรับ seizure 4 wk ก่อน ตอนนี้ ไข้สูง + ผื่นแดงทั่วตัว morbilliform → expanding + facial edema + lymphadenopathy generalized + เหนื่อย + คลื่นไส้ + เริ่ม dark urine

V/S: HR 122, BP 102/68, RR 24, Temp 39.4°C, BW 36 kg
PE: erythroderma-like rash > 50% BSA, facial edema, generalized lymphadenopathy, hepatomegaly tender, no mucous involvement to suggest SJS

CBC: WBC 18,000 with eosinophils 4,200 (15% — HIGH), atypical lymphocytes
LFT: ALT 480, AST 520 (high — hepatitis), bilirubin elevated
Cr 1.4 (mild AKI), proteinuria + LE +
Viral HHV-6 reactivation common — PCR pending
DRESS RegiSCAR score: definite', '[{"label":"A","text":"Continue carbamazepine"},{"label":"B","text":"DRESS (Drug Reaction with Eosinophilia + Systemic Symptoms"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Antifungal alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** DRESS (Drug Reaction with Eosinophilia + Systemic Symptoms — severe SCAR — Severe Cutaneous Adverse Reaction): IMMEDIATE DISCONTINUE OFFENDING DRUG (carbamazepine + cross-reactive aromatic antiepileptics — phenytoin, phenobarbital, lamotrigine — switch to non-aromatic levetiracetam, valproate); admit + multidisciplinary (dermatology + ID + nephrology + hepatology + cardiology + pulmonology — multi-organ involvement); SUPPORTIVE — fluid balance, electrolytes, nutrition; SYSTEMIC CORTICOSTEROIDS — prednisolone 1-2 mg/kg/d IV/PO (start higher in severe/visceral involvement) + slow taper over weeks-months (rapid taper → relapse); TOPICAL corticosteroid + emollient for skin; refractory + life-threatening → consider IVIG OR cyclosporine OR rituximab; monitor — VISCERAL INVOLVEMENT (liver, kidney, heart, lung, brain, pancreas, thyroid) recurrent flares + organ-specific (LFT q daily, Cr, ECG, echo, lipase) + autoimmune sequelae long-term (autoimmune thyroiditis, T1DM, lupus, AIHA developing months-years post — long-term follow-up); supportive other organ management; AVOID future re-exposure offending drug + cross-reactive drugs (lifelong, medical alert bracelet, document allergy); HLA TESTING — HLA-B*15:02 (carbamazepine SJS/DRESS in Asians especially Han Chinese, Thai, Indonesian — FDA + Thai Ministry of Health recommend screening before carbamazepine), HLA-B*58:01 (allopurinol), HLA-B*57:01 (abacavir); family + sibling considered for testing depending; report to drug safety authority; mortality ~10% DRESS

---

DRESS = severe adverse drug reaction. Carbamazepine, phenytoin, allopurinol, sulfa, vancomycin common triggers. Latency 2-6 wk. Fever + rash + facial edema + LN + eosinophilia + multi-organ. STOP drug + systemic steroid + long taper. HLA-B*15:02 screening before carbamazepine in Asians (Thai). Late autoimmune sequelae.', NULL,
  'hard', 'id', 'review',
  'pediatrics', 'clinical_decision', 'id', 'peds',
  'RegiSCAR DRESS Criteria; AAD Severe Cutaneous Adverse Reactions Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 11 ปี เริ่มกิน carbamazepine สำหรับ seizure 4 wk ก่อน ตอนนี้ ไข้สูง + ผื่นแดงทั่วตัว morbilliform → expanding + facial edema + lymphadenopathy generalized + เหนื่อย + คลื่นไส้ + เริ่ม dark urine

V/S: HR 122, BP 102/68, RR 24, Temp 39.4°C, BW 36 kg
PE: erythroderma-like rash > 50% BSA, facial edema, generalized lymphadenopathy, hepatomegaly tender, no mucous involvement to suggest SJS

CBC: WBC 18,000 with eosinophils 4,200 (15% — HIGH), atypical lymphocytes
LFT: ALT 480, AST 520 (high — hepatitis), bilirubin elevated
Cr 1.4 (mild AKI), proteinuria + LE +
Viral HHV-6 reactivation common — PCR pending
DRESS RegiSCAR score: definite'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 14 ปี เริ่ม TMP-SMX 8 วันก่อนสำหรับ UTI ตอนนี้ ไข้ + ผื่นแดง dusky พอง + slipped skin sheets + ปาก + ตา + อวัยวะเพศ involvement + เจ็บปาก + กลืนไม่ได้ + ตาเปิดไม่ได้ + dysuria — sloughing < 10% BSA

V/S: HR 122, BP 102/68, RR 24, Temp 39.2°C, BW 40 kg
Gen: ill-looking, dehydrated, skin: dusky red macules + blisters + epidermal detachment + Nikolsky sign positive, severe mucositis oral + ocular + genital; involvement < 10% BSA = SJS

Lab: ALT 240, leukopenia 2,800, electrolyte abnormalities
HLA-B testing pending; biopsy: full-thickness epidermal necrosis + few lymphocytic infiltrate = consistent', '[{"label":"A","text":"Continue TMP-SMX"},{"label":"B","text":"Stevens-Johnson Syndrome (SJS, severe cutaneous adverse reaction, < 10% BSA detachment; SJS-TEN overlap 10-30%; TEN > 30%)"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Antibiotic IV broad-spectrum prophylactic"},{"label":"E","text":"Wait — outgrow"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Stevens-Johnson Syndrome (SJS, severe cutaneous adverse reaction, < 10% BSA detachment; SJS-TEN overlap 10-30%; TEN > 30%) — DERMATOLOGIC EMERGENCY: IMMEDIATE DISCONTINUE OFFENDING DRUG (TMP-SMX + cross-reactive sulfa) + ANY other non-essential medications; TRANSFER to burn unit / specialized SJS center (mortality 5% SJS, 30% TEN, treatment effectiveness depends on early specialty care); SUPPORTIVE care = priority (Burn-unit style) — temperature regulation (lose thermoregulation), fluid resuscitation (Parkland-like formula but typically less aggressive than burn — adjust by ins/outs, mucosal losses), electrolytes + nutrition (consider TPN, mucositis severe), pain management (IV opioid), prevent infection — sterile environment, gentle wound care (non-adherent dressings, biosynthetic skin substitutes), avoid empiric antibiotic (mask infection — culture-directed only); MUCOSAL CARE multidisciplinary — ophthalmology DAILY (prevent corneal scarring/blindness — lubrication + topical steroid + amniotic membrane transplant for severe), oral hygiene, GU care, GI/respiratory mucosa involvement; SPECIFIC therapy CONTROVERSIAL evidence — options: cyclosporine 3-5 mg/kg/d (most evidence + best outcome data in TEN/SJS, immunomodulator), IVIG (controversial, some studies + some no benefit), corticosteroid (controversial — high-dose pulse early may help, prolonged use ↑ infection risk, recent meta-analyses suggest benefit early steroid); etanercept (anti-TNF) emerging promising; AVOID NSAID, prophylactic systemic antibiotic; long-term — skin (pigmentation), ocular sequelae (visual impairment 35%, dry eye, scarring, blindness — LIFELONG ophtho follow-up), pulmonary (bronchiolitis obliterans), genitourinary stricture, psychological PTSD, oral/dental long-term; AVOID OFFENDING + CROSS-REACTIVE DRUG lifelong + medical alert + document; HLA testing for genetic susceptibility identification; family + reproductive counseling; reportable adverse event

---

SJS/TEN = severe drug reaction, skin emergency. STOP drug + transfer burn/specialized unit. Supportive Burn-like + mucosal care + ophtho daily. Cyclosporine best evidence specific therapy. Steroid controversial. Long-term ocular + pulmonary + skin sequelae. HLA testing. Lifelong drug avoidance.', NULL,
  'hard', 'id', 'review',
  'pediatrics', 'clinical_decision', 'id', 'peds',
  'AAD SJS/TEN Practice Statement; RegiSCAR Network', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 14 ปี เริ่ม TMP-SMX 8 วันก่อนสำหรับ UTI ตอนนี้ ไข้ + ผื่นแดง dusky พอง + slipped skin sheets + ปาก + ตา + อวัยวะเพศ involvement + เจ็บปาก + กลืนไม่ได้ + ตาเปิดไม่ได้ + dysuria — sloughing < 10% BSA

V/S: HR 122, BP 102/68, RR 24, Temp 39.2°C, BW 40 kg
Gen: ill-looking, dehydrated, skin: dusky red macules + blisters + epidermal detachment + Nikolsky sign positive, severe mucositis oral + ocular + genital; involvement < 10% BSA = SJS

Lab: ALT 240, leukopenia 2,800, electrolyte abnormalities
HLA-B testing pending; biopsy: full-thickness epidermal necrosis + few lymphocytic infiltrate = consistent'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 13 ปี (post-menarche 1 yr) เลือดประจำเดือนมาก 8 วัน + เปลี่ยน pad q1-2 hr + Hb ลด + เลือดกำเดาหลายครั้ง + bruise ง่าย + เลือดออกหลังถอนฟัน นานกว่าปกติ 3 เดือน ก่อน

Family: mother มี heavy menses + brother บางครั้ง easy bruise
V/S: HR 102, BP 102/68, BW 50 kg

Lab: Hb 9.2, MCV 76 (microcytic — IDA), Ferritin LOW, Plt 280,000, PT normal, aPTT mildly prolonged 38 sec (normal 25-35), bleeding time prolonged
vWF antigen LOW (40%, normal 50-150), vWF activity (RCo) LOW, FVIII modestly LOW (subset of vWD), multimer analysis normal pattern = Type 1 vWD', '[{"label":"A","text":"Aspirin"},{"label":"B","text":"Type 1 von Willebrand Disease (most common inherited bleeding disorder, AD, partial quantitative deficiency) + heavy menstrual bleeding + IDA"},{"label":"C","text":"NSAID"},{"label":"D","text":"Discharge no treatment"},{"label":"E","text":"Surgery alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Type 1 von Willebrand Disease (most common inherited bleeding disorder, AD, partial quantitative deficiency) + heavy menstrual bleeding + IDA: hematology consultation; ACUTE bleeding (heavy menses now) — antifibrinolytic Tranexamic acid (TXA) 25 mg/kg/dose q8h PO during menses (effective for heavy bleeding); DESMOPRESSIN (DDAVP) — releases stored vWF + FVIII from endothelium — INTRANASAL Stimate 150 mcg/spray 1 spray each nostril q12-24h OR IV 0.3 mcg/kg infusion q12h — FOR Type 1 vWD with documented response (test response with stimation first); monitor for hyponatremia + seizure (fluid restriction during DDAVP); avoid > 3 doses (tachyphylaxis); ESTROGEN-PROGESTIN combined oral contraceptive — effective for menstrual control (also pregnancy prevention) ± LNG-IUD; vWF/FVIII CONCENTRATE (Humate-P, Wilate, recombinant) for severe bleeding, surgery, refractory bleeding; LONG-TERM management — vary intervention by need + lifestyle; AVOID — aspirin, NSAID, antiplatelet (worsen bleeding); MEDICAL ALERT bracelet + dental procedure pre-op planning (DDAVP, TXA, factor concentrate as needed); IRON replacement for IDA (oral or IV depending severity); FAMILY screening (AD, screen first-degree relatives, prenatal/PGD selected); long-term follow-up hematology + gyn + dental; education + transition adult; pregnancy planning — vWF normalizes 2nd-3rd trimester in many but post-partum hemorrhage risk → hematology coordination; emicizumab not vWD indicated

---

vWD = most common inherited bleeding disorder. Type 1 mild quantitative most common. Menorrhagia common presenting in adolescents. DDAVP + TXA + COC + factor concentrate per scenario. Avoid antiplatelet/NSAID. Iron supplement + family screen. Medical alert + dental planning.', NULL,
  'medium', 'hematology', 'review',
  'pediatrics', 'clinical_decision', 'hematology', 'peds',
  'ASH/ISTH/NHF/WFH 2021 vWD Guidelines; Pediatric Hematology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 13 ปี (post-menarche 1 yr) เลือดประจำเดือนมาก 8 วัน + เปลี่ยน pad q1-2 hr + Hb ลด + เลือดกำเดาหลายครั้ง + bruise ง่าย + เลือดออกหลังถอนฟัน นานกว่าปกติ 3 เดือน ก่อน

Family: mother มี heavy menses + brother บางครั้ง easy bruise
V/S: HR 102, BP 102/68, BW 50 kg

Lab: Hb 9.2, MCV 76 (microcytic — IDA), Ferritin LOW, Plt 280,000, PT normal, aPTT mildly prolonged 38 sec (normal 25-35), bleeding time prolonged
vWF antigen LOW (40%, normal 50-150), vWF activity (RCo) LOW, FVIII modestly LOW (subset of vWD), multimer analysis normal pattern = Type 1 vWD'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 12 ปี known T1DM (Dx 2 yr ago) มา ED ด้วย vomiting + abdominal pain + polyuria after missed insulin 24 ชม

V/S: HR 122, BP 102/68, RR 28 (Kussmaul), SpO2 98%, BW 36 kg
Gen: alert, ill-appearing, mild dehydration

Lab: pH 7.20, HCO3 12 (moderate DKA), AG 24, Glucose 480, K 4.8 (corrected), Na 132, BUN 22, Cr 0.8, ketone urine 3+, lactate 2.5 (mild), Cl 100
No neuro deficit, no headache, no signs cerebral edema', '[{"label":"A","text":"Insulin bolus + sodium bicarb"},{"label":"B","text":"Pediatric DKA moderate (ISPAD 2022)"},{"label":"C","text":"Restrict all fluid"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Oral hypoglycemic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric DKA moderate (ISPAD 2022): IV access; fluid resuscitation CAUTIOUS — 10-20 mL/kg NSS bolus over 30-60 min (avoid > 50 mL/kg first 4 hr — cerebral edema risk in peds, prefer SLOWER vs adult), then maintenance + deficit over 24-48 hr (NOT 24 hr alone); insulin AT LEAST 1 hr after starting fluid (not immediately, allows initial fluid resuscitation), then continuous IV regular insulin 0.05-0.1 U/kg/hr (NO BOLUS in peds DKA — bolus = no benefit, increased cerebral edema risk); POTASSIUM REPLACEMENT — add K to fluid (KCl 20-40 mEq/L) once K < 5.5 + UO established, even if serum K initially normal/high (total body deficit); monitor K q1-2h initially; BICARBONATE only if pH < 6.9 + CV compromise (controversial otherwise + cerebral edema risk); GLUCOSE monitor hourly — DEXTROSE add to fluid once glucose drops to ~250-300 (D5 then D10 if needed, continue insulin to clear ketones not just glucose); transition SC insulin when bicarbonate > 18, pH > 7.3, AG normal, glucose < 200, eating; OVERLAP IV + SC insulin (give SC dose 15-30 min before STOP IV insulin); GLUCOSE + electrolytes q1-2 hr; serum osmolality corrected sodium trend (paradoxical Na rise as glucose falls = appropriate; FALL = cerebral edema warning); MONITOR for CEREBRAL EDEMA — most feared, > 80% pediatric DKA deaths — signs: headache, vomiting (after initial improvement), AMS, papilledema, Cushing reflex, paradoxical Na rise; manage if detected — IMMEDIATE hypertonic saline OR mannitol, reduce fluid rate; identify TRIGGER — missed insulin most common adolescents, intercurrent illness (viral, UTI, GE), insulin pump failure; PSYCHOSOCIAL — adherence issues common adolescent (mental health, family conflict, eating disorder); patient education + family + transition adult; CGM + insulin pump consideration

---

Pediatric DKA = ISPAD 2022 cautious approach (cerebral edema risk). NO insulin bolus, delayed insulin (after fluid), gradual fluid over 48 hr, K replacement, monitor for cerebral edema warning signs (HA, AMS, paradoxical Na rise). Address trigger + psychosocial.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'pediatrics', 'clinical_decision', 'endocrine_metabolic', 'peds',
  'ISPAD Clinical Practice Consensus Guideline DKA 2022', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 12 ปี known T1DM (Dx 2 yr ago) มา ED ด้วย vomiting + abdominal pain + polyuria after missed insulin 24 ชม

V/S: HR 122, BP 102/68, RR 28 (Kussmaul), SpO2 98%, BW 36 kg
Gen: alert, ill-appearing, mild dehydration

Lab: pH 7.20, HCO3 12 (moderate DKA), AG 24, Glucose 480, K 4.8 (corrected), Na 132, BUN 22, Cr 0.8, ketone urine 3+, lactate 2.5 (mild), Cl 100
No neuro deficit, no headache, no signs cerebral edema'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 8 ปี known sickle cell disease (HbSS) อาการเริ่ม 2 ชม ก่อน — สูญเสีย speech + right hemiparesis + facial droop + altered mental status

V/S: HR 112, BP 132/78, Temp 37.0°C, BW 22 kg
Gen: alert but dysarthric, expressive aphasia, right facial droop, right arm + leg weakness 2/5 strength, sensory loss right side, no seizure

CT head non-contrast: subtle hypodensity left MCA territory + dense MCA sign
MRI + DWI: large left MCA stroke + ADC restriction = acute ischemic stroke
TCD: previously high velocities suggesting stenosis; CBC: Hb 7.8, retic 8%; recent transfusion 1 month ago', '[{"label":"A","text":"Wait 24 hr observation"},{"label":"B","text":"Acute Ischemic Stroke in Sickle Cell Disease (peds stroke incidence 11% in SCD by 20 yr)"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Aspirin alone"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Ischemic Stroke in Sickle Cell Disease (peds stroke incidence 11% in SCD by 20 yr) — peds stroke emergency: ABC + neurologic exam + emergent CT/MRI confirmed; EXCHANGE TRANSFUSION urgent — reduce HbS to < 30% — most effective acute intervention to halt ongoing stroke + reduce extension (manual or automated exchange, preferred over simple transfusion); pediatric neurology + hematology + interventional radiology + ICU; IV ALTEPLASE (tPA) — generally NOT recommended in SCD (different pathophysiology — vasculopathy + sludge rather than thromboembolic, no good evidence) + selected major centers offer in SCD adult, adult/peds general criteria <4.5 hr; pediatric tPA non-SCD: limited data, selected centers for older adolescents extrapolated adult criteria; thrombectomy — emerging in pediatric LVO stroke (limited data, selected centers); SUPPORTIVE — maintain euvolemia + normal glucose + normal Na + normal temp + adequate oxygenation + treat seizure if present + manage ICP if increased; OPTIMIZE OXYGEN delivery (transfuse Hb > 10), avoid hypoxia + hyperthermia; antiplatelet (aspirin 1-5 mg/kg/d) considered after acute phase + once exchange completed (delayed); EARLY rehab; INVESTIGATIONS — TCD historical, baseline + post-stroke MRA/cervical vessels (vasculopathy moyamoya in SCD), echo (cardioembolic), prothrombotic workup (anti-phospholipid, factor V Leiden, protein C/S — selective); secondary stroke prevention — CHRONIC TRANSFUSION program (target HbS < 30% lifelong) OR Hydroxyurea (alternative — STOP study + TWiTCH trial); long-term — hematopoietic stem cell transplant (HLA-matched sibling), GENE THERAPY (newer FDA-approved SCD), rehab, neuropsych, school IEP, family

---

Pediatric stroke in SCD = urgent exchange transfusion (reduce HbS < 30%). tPA generally NOT used in SCD (different pathophysiology). Secondary prevention: chronic transfusion or hydroxyurea + monitor TCD. HSCT or gene therapy curative options. Rehab + neuropsych long-term.', NULL,
  'hard', 'neurology', 'review',
  'pediatrics', 'clinical_decision', 'neurology', 'peds',
  'AHA/ASA Pediatric Stroke Guideline 2019; ASH SCD Stroke Prevention Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 8 ปี known sickle cell disease (HbSS) อาการเริ่ม 2 ชม ก่อน — สูญเสีย speech + right hemiparesis + facial droop + altered mental status

V/S: HR 112, BP 132/78, Temp 37.0°C, BW 22 kg
Gen: alert but dysarthric, expressive aphasia, right facial droop, right arm + leg weakness 2/5 strength, sensory loss right side, no seizure

CT head non-contrast: subtle hypodensity left MCA territory + dense MCA sign
MRI + DWI: large left MCA stroke + ADC restriction = acute ischemic stroke
TCD: previously high velocities suggesting stenosis; CBC: Hb 7.8, retic 8%; recent transfusion 1 month ago'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 6 ปี newly diagnosed ALL ตรวจ initial WBC 380,000 (hyperleukocytosis > 100K) + clinical symptoms — confusion, dyspnea, retinal hemorrhages, headache + petechiae

V/S: HR 132, BP 102/72, RR 32, SpO2 92%, Temp 37.6°C, BW 24 kg
Gen: confused, mild distress, retinal hemorrhages, splenomegaly 5 cm

Lab: WBC 380,000 (blasts 85% — pre-B ALL), Hb 6.5, Plt 24,000, K 6.2, P 9.0, Ca 7.2, uric acid 18 (HIGH), LDH 4,820, Cr 1.4, AGMA mild, INR 1.4, fibrinogen 180 (DIC borderline)', '[{"label":"A","text":"Wait — start chemo slowly"},{"label":"B","text":"Hyperleukocytosis (WBC > 100K) + Leukostasis + Tumor Lysis Syndrome (TLS) imminent"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Antibiotic alone"},{"label":"E","text":"Transfuse aggressively"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hyperleukocytosis (WBC > 100K) + Leukostasis + Tumor Lysis Syndrome (TLS) imminent — pediatric oncology emergency: admit ICU + ped-onc team; AGGRESSIVE TLS prophylaxis + treatment — IV HYDRATION 2-3× maintenance (3 L/m²/d crystalloid, no K addition initially); RASBURICASE 0.15-0.2 mg/kg IV daily × 1-5 days (recombinant urate oxidase — preferred over allopurinol for high uric acid > 8 mg/dL OR rapidly rising OR organ dysfunction — converts uric acid to allantoin, rapid + effective; CAUTION G6PD deficient — methemoglobinemia + hemolysis, screen if Asian/African/Mediterranean); alternative ALLOPURINOL 10 mg/kg/d for less severe TLS risk; ALKALINIZATION controversial (urate easier excretion but increases calcium phosphate precipitation — most centers now avoid with rasburicase); CORRECT ELECTROLYTES — K (Ca gluconate IV cardiac protection + insulin/glucose + albuterol + sodium polystyrene + dialysis), P (binders + dialysis), Ca (treat hypocalcemia only if symptomatic — concern Ca-P precipitation); LEUKAPHERESIS — selected case (HOLD if asymptomatic), benefit unclear in ALL hyperleukocytosis (vs AML where established) — generally not first-line in peds ALL because rapid response to cytoreduction with steroid alone; STEROID — start prednisolone 60 mg/m²/d (initial cytoreduction prior to full chemo, gentle dose increase to avoid TLS); RAPID PROGRESSION TO CHEMOTHERAPY — induction (vincristine + steroid + asparaginase ± anthracycline) once initial stabilization; PRBC transfusion only if severe symptomatic anemia (avoid increasing viscosity → worsen leukostasis); platelet transfusion for active bleed or < 20 (NOT prophylactic transfusion may aggravate); RRT/dialysis indication — severe TLS refractory hyperK/AKI/hyperP; coagulopathy management (cryo if fibrinogen low, FFP); central line + supportive; intrathecal chemo + CNS prophylaxis later; counsel family — newer molecular subtyping + risk stratification + immunotherapy (blinatumomab, CAR-T for relapse) revolutionized outcomes (cure > 90% pre-B ALL pediatric); long-term: late effects monitoring + comprehensive cancer survivorship

---

Hyperleukocytosis + TLS = oncologic emergency. Aggressive hydration + rasburicase (or allopurinol) + correct electrolytes (K, P, Ca, uric acid). Avoid alkalinization with rasburicase. Steroid cytoreduction + rapid chemo. Leukapheresis selective. Avoid excessive PRBC (increases viscosity). Multidisciplinary ICU.', NULL,
  'hard', 'hemato_onco', 'review',
  'pediatrics', 'clinical_decision', 'hemato_onco', 'peds',
  'COG ALL Protocols; Cairo-Bishop TLS Classification 2010; Coiffier JCO 2008', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 6 ปี newly diagnosed ALL ตรวจ initial WBC 380,000 (hyperleukocytosis > 100K) + clinical symptoms — confusion, dyspnea, retinal hemorrhages, headache + petechiae

V/S: HR 132, BP 102/72, RR 32, SpO2 92%, Temp 37.6°C, BW 24 kg
Gen: confused, mild distress, retinal hemorrhages, splenomegaly 5 cm

Lab: WBC 380,000 (blasts 85% — pre-B ALL), Hb 6.5, Plt 24,000, K 6.2, P 9.0, Ca 7.2, uric acid 18 (HIGH), LDH 4,820, Cr 1.4, AGMA mild, INR 1.4, fibrinogen 180 (DIC borderline)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 2 ปี ครอบครัวคลำพบก้อน RUQ ขนาดใหญ่ + abdominal distension + เริ่มเบื่ออาหาร + น้ำหนักลด 1 kg ใน 2 mo + early puberty (signs virilization)

V/S: BW 11 kg, abdominal distension + large RUQ mass firm, no jaundice, splenomegaly absent

Lab: AFP 480,000 (extremely high — characteristic), bilirubin normal, ALT mildly elevated, hCG mildly elevated (paraneoplastic), no jaundice
US: large 12 cm hepatic mass right lobe
CT chest/abdomen: well-defined heterogeneous hepatic mass, no metastasis lung, no portal vein invasion
Biopsy: hepatoblastoma fetal/embryonal type
PRETEXT staging: III (limited resection feasibility)', '[{"label":"A","text":"Wait — observe"},{"label":"B","text":"Hepatoblastoma (most common pediatric primary liver cancer, peak 1-3 yr, very high AFP, virilization rare from beta-hCG)"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Antibiotic alone"},{"label":"E","text":"Surgery without chemo"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hepatoblastoma (most common pediatric primary liver cancer, peak 1-3 yr, very high AFP, virilization rare from beta-hCG) — multimodal: pediatric oncology + hepatobiliary surgery + transplant team coordinated; ALL hepatoblastoma treated per international protocols (COG/SIOPEL); NEOADJUVANT CHEMOTHERAPY — cisplatin-based (PLADO: cisplatin + doxorubicin or C5VD or as per protocol) × 4-6 cycles — shrinks tumor to allow resection; reassess RESECTABILITY POST-CHEMO with imaging; SURGICAL RESECTION — partial hepatectomy if confined to resectable anatomy (PRETEXT I, II, post-chemo III); LIVER TRANSPLANTATION (orthotopic) — for unresectable PRETEXT III/IV without extrahepatic disease — pediatric transplant center, requires donor evaluation, immunosuppression lifelong, EXCELLENT outcomes with appropriate selection (5-yr survival ~70-90%); ADJUVANT CHEMOTHERAPY post-surgery; monitor AFP — drops with effective treatment, rises with recurrence; LONG-TERM follow-up — recurrence (most within 2 yr), hearing (cisplatin ototoxicity audiology long-term), renal + cardiac (doxorubicin), secondary malignancy, growth + developmental; transition adult; PROGNOSIS — overall 5-yr survival 80%, depends on PRETEXT stage + histology + alpha-fetoprotein response + complete resection; family education + comprehensive cancer survivorship clinic; investigate associated conditions — Beckwith-Wiedemann, FAP (APC mutation), prematurity + low birth weight + parenteral nutrition risk factors

---

Hepatoblastoma = most common pediatric primary liver cancer. PRETEXT staging. Cisplatin-based neoadjuvant chemo + surgery (or transplant for unresectable) excellent outcomes. AFP marker. Cisplatin ototoxicity monitor. Associated: BWS, FAP, prematurity.', NULL,
  'medium', 'hemato_onco', 'review',
  'pediatrics', 'clinical_decision', 'hemato_onco', 'peds',
  'COG/SIOPEL Hepatoblastoma Protocols', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 2 ปี ครอบครัวคลำพบก้อน RUQ ขนาดใหญ่ + abdominal distension + เริ่มเบื่ออาหาร + น้ำหนักลด 1 kg ใน 2 mo + early puberty (signs virilization)

V/S: BW 11 kg, abdominal distension + large RUQ mass firm, no jaundice, splenomegaly absent

Lab: AFP 480,000 (extremely high — characteristic), bilirubin normal, ALT mildly elevated, hCG mildly elevated (paraneoplastic), no jaundice
US: large 12 cm hepatic mass right lobe
CT chest/abdomen: well-defined heterogeneous hepatic mass, no metastasis lung, no portal vein invasion
Biopsy: hepatoblastoma fetal/embryonal type
PRETEXT staging: III (limited resection feasibility)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 10 ปี Trauma ขณะเล่นจักรยานชน handlebar เข้าท้อง 2 วันก่อน ตอนนี้ ปวดท้องรุนแรง upper abdomen + radiating to back + คลื่นไส้อาเจียน + ไข้ต่ำ

V/S: HR 122, BP 102/68, RR 22, Temp 38.0°C, BW 30 kg
Gen: distress, abdominal tenderness epigastric + RUQ, mild rebound, hypoactive bowel sounds, no peritonitis severe

Lab: lipase 3,200 (high, > 3× normal), amylase 1,840, CBC WBC 14,500, glucose 110, Cr normal, LFT mildly elevated, calcium 8.4
US abdomen + contrast CT: pancreatic edema + peripancreatic fluid + no necrosis on early CT (may evolve)', '[{"label":"A","text":"Discharge home"},{"label":"B","text":"Acute Pediatric Pancreatitis (trauma-related"},{"label":"C","text":"Restrict all food + fluid weeks"},{"label":"D","text":"Prophylactic antibiotic IV"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Pediatric Pancreatitis (trauma-related — handlebar injury common cause peds): admit + ICU consideration if severe (organ dysfunction); SUPPORTIVE — primary treatment, NO specific therapy curative; FLUID resuscitation — IV crystalloid LR 1.5-2× maintenance first 24-48 hr (most important — prevents pancreatic ischemia + necrosis) — guide by clinical perfusion + UO + Hct trend, AVOID over-resuscitation; ANALGESIA — IV opioid (morphine 0.05-0.1 mg/kg q3-4h, contrary to old myth about Oddi spasm — modern evidence supports morphine + ketorolac); ANTIEMETIC; NUTRITION — EARLY ENTERAL feeding within 24-72 hr (oral or NG/NJ if cannot tolerate) — improves outcomes vs prolonged NPO (older paradigm) — start clear liquid → soft → regular; if cannot enteral → TPN; AVOID PROPHYLACTIC ANTIBIOTIC (no benefit, increased resistance); ANTIBIOTIC only for: documented infection, infected necrosis (FNA-guided), cholangitis; INVESTIGATIONS — exclude causes — trauma here, but consider gallstones (US), hypertriglyceridemia (lipid), hypercalcemia, drugs (asparaginase, valproate, steroid, thiazide), genetic (PRSS1, CFTR, SPINK1, CTRC — selected); MRCP if structural concern; ERCP for sphincterotomy/stone removal if obstructive; monitor for complications — pseudocyst (drain if symptomatic or > 6 cm + > 6 wk), necrosis (FNA + debridement step-up approach), abscess (drainage), AKI, ARDS, abdominal compartment syndrome; CHRONIC PANCREATITIS pediatric (recurrent acute → chronic) — multidisciplinary genetic + nutritional + endocrine evaluation; long-term — exocrine + endocrine insufficiency (DM, malabsorption) monitor; family education + dietary; PEDIATRIC pancreatitis usually resolves with supportive care + treat cause

---

Pediatric pancreatitis = supportive care primary. Aggressive IV fluid first 24-48 hr (prevent ischemia). EARLY enteral feeding (improves outcomes). Adequate analgesia (morphine OK). Avoid prophylactic antibiotic. Investigate cause. Trauma + biliary + drug + genetic. Complications surveillance. Long-term: chronic pancreatitis if recurrent.', NULL,
  'medium', 'gi', 'review',
  'pediatrics', 'clinical_decision', 'gi', 'peds',
  'NASPGHAN Pediatric Pancreatitis Position Paper 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 10 ปี Trauma ขณะเล่นจักรยานชน handlebar เข้าท้อง 2 วันก่อน ตอนนี้ ปวดท้องรุนแรง upper abdomen + radiating to back + คลื่นไส้อาเจียน + ไข้ต่ำ

V/S: HR 122, BP 102/68, RR 22, Temp 38.0°C, BW 30 kg
Gen: distress, abdominal tenderness epigastric + RUQ, mild rebound, hypoactive bowel sounds, no peritonitis severe

Lab: lipase 3,200 (high, > 3× normal), amylase 1,840, CBC WBC 14,500, glucose 110, Cr normal, LFT mildly elevated, calcium 8.4
US abdomen + contrast CT: pancreatic edema + peripancreatic fluid + no necrosis on early CT (may evolve)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 11 ปี ก่อนหน้านี้ healthy เริ่มมีปวดท้อง severe colicky 3 วันก่อน + อาเจียน + bloody stool + palpable purpura ทั้ง 2 ขา + ปวดข้อหลายข้อย้ายที่ + ปัสสาวะปริมาณน้อย dark urine

V/S: BP 132/86 (HT in child), HR 102, BW 32 kg, mild edema
PE: extensive palpable purpura buttocks + lower legs, scrotal swelling + tenderness (HSP-orchitis), abdominal tender diffuse no peritonitis, knee + ankle effusion mild bilateral

Lab: Plt 380,000 normal, CBC mild leukocytosis, BUN 32, Cr 1.4 (high), UA — RBC casts + protein 3+, urine P:Cr 5.0 (nephrotic-range proteinuria!), albumin 2.4, complement normal
ABD US: intussusception ileo-ileal R sided + bowel wall edema; testicular US: orchitis only no torsion', '[{"label":"A","text":"Discharge home"},{"label":"B","text":"IgA Vasculitis (HSP) with multiple severe complications"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Antiviral alone"},{"label":"E","text":"Surgery first immediately"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** IgA Vasculitis (HSP) with multiple severe complications — intussusception, severe abdominal pain, nephritis nephrotic-range, scrotal involvement: admit ICU monitoring; abdominal management — surgical consultation for intussusception ileo-ileal (usually doesn''t reduce with enema; surgery if persistent + symptomatic, often resolves spontaneously in HSP); IV fluid resuscitation + bowel rest if severe abdominal pain + analgesia; SYSTEMIC CORTICOSTEROID — prednisolone 1-2 mg/kg/d IV or PO (max 60 mg/d) — INDICATIONS in HSP: severe abdominal pain, GI bleeding, intussusception, scrotal involvement, severe arthritis, evidence of severe nephritis — given for these severe complications (no clear evidence for routine cutaneous/mild disease); SEVERE NEPHRITIS (this patient — RPGN-like, nephrotic-range, AKI) — escalate immunosuppression: corticosteroid pulse methylprednisolone 30 mg/kg/d × 3 d then prednisolone; ADD cyclophosphamide IV monthly × 6 mo OR mycophenolate mofetil OR rituximab for severe progressive; ACEI/ARB for proteinuria once stable; renal biopsy CONSIDERED for severe nephritis to guide therapy + prognosis (ISKDC classification); MANAGE HT carefully (CCB or labetalol acute, ACEI/ARB long-term once stable); ORCHITIS/SCROTAL — supportive care, scrotal support, NSAID (caution renal), corticosteroid; MONITOR — BP, UA, Cr, intussusception clinical + serial US (q12-24h), GI bleeding; long-term followup — UA + BP + Cr q monthly × 6 mo (nephritis up to 6 mo post), then less frequent; chronic kidney disease 1-5% even with treatment; PROGNOSIS depend on renal involvement severity; family education recurrence 30%

---

HSP/IgAV with severe complications (intussusception, nephritis, scrotal) = treat aggressively with steroid + escalated immunosuppression if severe nephritis. Intussusception in HSP often ileo-ileal + doesn''t reduce with enema, may resolve spontaneously. Long-term renal monitoring 6 mo. Multidisciplinary.', NULL,
  'medium', 'renal_gu', 'review',
  'pediatrics', 'clinical_decision', 'renal_gu', 'peds',
  'SHARE Initiative HSP Management 2019; EULAR/PRINTO/PReS Criteria 2010', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 11 ปี ก่อนหน้านี้ healthy เริ่มมีปวดท้อง severe colicky 3 วันก่อน + อาเจียน + bloody stool + palpable purpura ทั้ง 2 ขา + ปวดข้อหลายข้อย้ายที่ + ปัสสาวะปริมาณน้อย dark urine

V/S: BP 132/86 (HT in child), HR 102, BW 32 kg, mild edema
PE: extensive palpable purpura buttocks + lower legs, scrotal swelling + tenderness (HSP-orchitis), abdominal tender diffuse no peritonitis, knee + ankle effusion mild bilateral

Lab: Plt 380,000 normal, CBC mild leukocytosis, BUN 32, Cr 1.4 (high), UA — RBC casts + protein 3+, urine P:Cr 5.0 (nephrotic-range proteinuria!), albumin 2.4, complement normal
ABD US: intussusception ileo-ileal R sided + bowel wall edema; testicular US: orchitis only no torsion'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 7 ปี ในช่วง maintenance phase ALL (treatment 2 yr) เริ่มปวดศีรษะ + อาเจียน morning + diplopia + papilledema bilateral 1 wk

V/S: BP 112/68, HR 92, BW 26 kg
PE: papilledema bilateral, 6th nerve palsy bilateral (false localizing), no other focal deficit, alert

Lab: CBC stable (no marrow relapse currently — Plt 220, WBC 4,200 no blasts), LFT normal, Cr normal
MRI brain + spine: leptomeningeal enhancement + multiple lesions in brain parenchyma + spinal cord
LP: WBC 35 (all blasts on cytospin), Protein elevated, Glucose normal, BLASTS confirmed = isolated CNS relapse', '[{"label":"A","text":"Discharge no further treatment"},{"label":"B","text":"Isolated CNS Relapse Pediatric ALL"},{"label":"C","text":"Single intrathecal dose"},{"label":"D","text":"Antibiotic"},{"label":"E","text":"Antifungal"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Isolated CNS Relapse Pediatric ALL — pediatric oncology emergency + new treatment paradigm: pediatric oncology + radiation oncology + neurology + neurosurgery + BMT team; INTRATHECAL CHEMOTHERAPY (triple therapy: methotrexate + cytarabine + hydrocortisone) intensified frequency (twice weekly × 4-6 wk then weekly × 4-8 wk to clear blasts); SYSTEMIC reinduction — high-intensity chemotherapy (high-dose methotrexate to cross BBB + dexamethasone + asparaginase + vincristine ± additional agents per protocol); CNS RADIATION THERAPY — craniospinal RT (typical 18 Gy cranial + spinal lower) AFTER chemo control + once approach end of treatment plan — irradiation reduces CNS recurrence but neurocognitive cost especially young children — modern trials reduce/omit RT if molecular/MRD control achievable + extensive chemo CNS-directed; HEMATOPOIETIC STEM CELL TRANSPLANT (allogeneic) — strongly considered for early CNS relapse < 18 mo from initial Dx + selected high-risk; CAR-T cell therapy (tisagenlecleucel — FDA approved relapsed/refractory pediatric ALL) — emerging for relapse + can penetrate CNS; blinatumomab (BiTE — anti-CD19/CD3) emerging; SUPPORTIVE — manage increased ICP with steroid (dexamethasone) + hyperosmolar therapy if symptomatic; monitor MRD (minimal residual disease) — quantitative response to therapy guides intensity; INVESTIGATIONS — exclude marrow relapse (BMA), molecular characterization (BCR-ABL, MLL, others); long-term — neurocognitive deficits from CNS RT + IT therapy (especially young), endocrinopathy from CNS RT, growth + puberty delay, secondary malignancy, cardiac (anthracycline cumulative); psychosocial + family + transition adult; treatment intensity + prognosis depend on timing relapse, MRD, immunophenotype, age; comprehensive cancer survivorship

---

Isolated CNS relapse ALL = aggressive multimodal treatment with high CR rate but worse than initial. Intensified IT + high-dose systemic + CNS-directed RT + HSCT or CAR-T for selected. Early relapse worse prognosis. Multidisciplinary cancer survivorship long-term.', NULL,
  'hard', 'hemato_onco', 'review',
  'pediatrics', 'clinical_decision', 'hemato_onco', 'peds',
  'COG ALL Relapse Protocols; CIBMTR Pediatric', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 7 ปี ในช่วง maintenance phase ALL (treatment 2 yr) เริ่มปวดศีรษะ + อาเจียน morning + diplopia + papilledema bilateral 1 wk

V/S: BP 112/68, HR 92, BW 26 kg
PE: papilledema bilateral, 6th nerve palsy bilateral (false localizing), no other focal deficit, alert

Lab: CBC stable (no marrow relapse currently — Plt 220, WBC 4,200 no blasts), LFT normal, Cr normal
MRI brain + spine: leptomeningeal enhancement + multiple lesions in brain parenchyma + spinal cord
LP: WBC 35 (all blasts on cytospin), Protein elevated, Glucose normal, BLASTS confirmed = isolated CNS relapse'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 9 ปี diagnosis ITP 14 mo ago + ได้รับ IVIG + steroid + รักษาแล้ว ตอนนี้ Plt count vary 8,000-30,000 chronic ITP > 12 mo + petechiae + minor bleeding + บางครั้ง heavy menses (post-menarche 1 yr) + ผลกระทบ activity

V/S: BW 32 kg, intermittent petechiae + bruising, no severe bleeding currently

CBC: Hb 11.0, WBC normal, Plt 12,000
Bone marrow biopsy (done 1 yr ago): normal megakaryocytes, no abnormality = ITP
No connective tissue disease evidence (ANA negative, normal complement)', '[{"label":"A","text":"Continue steroid forever"},{"label":"B","text":"Chronic Pediatric ITP (> 12 mo duration, intermittent bleeding, impacts quality of life)"},{"label":"C","text":"Splenectomy immediately"},{"label":"D","text":"Aspirin"},{"label":"E","text":"Discharge no follow"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Chronic Pediatric ITP (> 12 mo duration, intermittent bleeding, impacts quality of life) — beyond first-line: pediatric hematology specialist + ASH 2019 + 2024 updates; INDICATIONS to treat (vs observe) — significant bleeding, lifestyle impact, contact sports involvement, surgery planning; FIRST-LINE for chronic ITP — TPO RECEPTOR AGONISTS (revolutionized — non-immunosuppressive, oral, well-tolerated): ELTROMBOPAG ≥ 1 yr FDA-approved (25-75 mg/d oral, take fasting + 4 hr after polyvalent cations, monitor LFT cataract eye exam) OR ROMIPLOSTIM ≥ 1 yr (SC weekly injection, dose-adjusted by platelet response); ~70-80% response rate; PREDNISOLONE pulses (rather than chronic) — short courses for bleeds or surgeries; IVIG — short-term boost for severe bleed or pre-surgery (rapid effect); RITUXIMAB (anti-CD20) — second-line, durable response 30-40%, side effects + immunosuppression; FOSTAMATINIB (SYK inhibitor) — oral newer alternative; SPLENECTOMY — historically curative ~70%, but now reserved for refractory after TPO-RA fail + > 6 yr age (immune maturity) + counseling about lifelong infection risk + vaccinations pre + post (pneumococcal, meningococcal, Hib, influenza) + penicillin prophylaxis 5+ yr; HEAVY MENSES — TXA + COC (combined OCP) for menstrual control; ACTIVITY — generally allow normal activity with awareness, avoid contact sports if Plt < 30K; MEDICAL ALERT bracelet; FAMILY education emergency response + when to seek care; long-term watch for chronic disease, autoimmune comorbidity, secondary malignancy considerations; psychosocial support adolescent + transition adult

---

Chronic pediatric ITP (> 12 mo) — TPO receptor agonists (eltrombopag, romiplostim) revolutionized (oral, non-immunosuppressive, ~70-80% response). Rituximab + fostamatinib alternatives. Splenectomy reserved + delayed > 6 yr. Treat based on bleeding/lifestyle, not just count. ASH 2019/2024.', NULL,
  'medium', 'hematology', 'review',
  'pediatrics', 'clinical_decision', 'hematology', 'peds',
  'ASH 2019 ITP Guidelines; Updates Neunert + Provan', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 9 ปี diagnosis ITP 14 mo ago + ได้รับ IVIG + steroid + รักษาแล้ว ตอนนี้ Plt count vary 8,000-30,000 chronic ITP > 12 mo + petechiae + minor bleeding + บางครั้ง heavy menses (post-menarche 1 yr) + ผลกระทบ activity

V/S: BW 32 kg, intermittent petechiae + bruising, no severe bleeding currently

CBC: Hb 11.0, WBC normal, Plt 12,000
Bone marrow biopsy (done 1 yr ago): normal megakaryocytes, no abnormality = ITP
No connective tissue disease evidence (ANA negative, normal complement)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 8 ปี persistent microscopic hematuria > 1 yr + intermittent gross hematuria after URI + mild proteinuria new + family Hx — มี uncle (mother''s brother) ESRD age 25 with bilateral sensorineural hearing loss + cousin had similar

V/S: BP 110/72 normal, BW 26 kg
PE: anterior lenticonus on slit-lamp + retinal flecks, normal exam otherwise
Audiometry: bilateral high-frequency sensorineural hearing loss

Lab: Cr 0.7 normal, UA — RBC 50+, dysmorphic, mild protein 1+, UP/UCr 0.4, complement normal
Family Hx + clinical features = X-linked Alport syndrome
Kidney biopsy + EM: basement membrane splitting + lamellation + thinning = Alport
Genetic testing: COL4A5 mutation positive (X-linked)', '[{"label":"A","text":"Wait — observe"},{"label":"B","text":"Alport Syndrome (X-linked, COL4A5 type IV collagen"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Surgery first-line"},{"label":"E","text":"Discharge no follow"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Alport Syndrome (X-linked, COL4A5 type IV collagen — affects glomerular basement membrane, cochlea, lens) — long-term progressive renal disease management: nephrology + ophthalmology + audiology + genetics + multidisciplinary; RENIN-ANGIOTENSIN-ALDOSTERONE SYSTEM (RAAS) blockade EARLY — ACEI (lisinopril, enalapril, ramipril) titrated to maximum tolerated dose (proteinuria reduction primary) — STARTING when proteinuria detected, slows progression; ARB if ACEI not tolerated; spironolactone aldosterone receptor antagonist add-on; SGLT2 inhibitor (dapagliflozin, empagliflozin) emerging — recent evidence reduces progression in CKD including Alport; bardoxolone (Nrf2 activator) — recent FDA approval emerging; counsel about lifelong progression to ESRD (males X-linked 90% by age 30); ANNUAL — BP monitoring + UA + Cr + GFR + audiology + ophtho (cataract + anterior lenticonus); HYPERTENSION management — RAAS blockade + diuretics + add as needed; AVOID nephrotoxin (NSAID, aminoglycoside, contrast); HEARING aids when indicated; ophthalmology for lenticonus + cataract; PREPARE FOR ESRD — late teens to adult — dialysis + KIDNEY TRANSPLANT (preferred — successful long-term, but risk of post-transplant anti-GBM antibodies in some — rare complication needing monitoring + immunosuppression coordination); GENETIC COUNSELING + family screen — X-linked (males severe, females carrier — variable severity), AR + AD forms exist (COL4A3/COL4A4 — Alport variant); prenatal/preimplantation diagnosis available; education adolescence + transition adult nephrology; psychosocial support; gene therapy in development

---

Alport syndrome = inherited basement membrane disease (X-linked most). Progressive nephritis + sensorineural hearing loss + ocular changes. Early ACEI/ARB slow progression. SGLT2i emerging. Most males progress to ESRD → transplant. Genetic counseling. Family screen. Multispecialty.', NULL,
  'medium', 'renal_gu', 'review',
  'pediatrics', 'clinical_decision', 'renal_gu', 'peds',
  'KDIGO Glomerular Diseases 2021; Alport Syndrome Foundation Clinical Practice', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 8 ปี persistent microscopic hematuria > 1 yr + intermittent gross hematuria after URI + mild proteinuria new + family Hx — มี uncle (mother''s brother) ESRD age 25 with bilateral sensorineural hearing loss + cousin had similar

V/S: BP 110/72 normal, BW 26 kg
PE: anterior lenticonus on slit-lamp + retinal flecks, normal exam otherwise
Audiometry: bilateral high-frequency sensorineural hearing loss

Lab: Cr 0.7 normal, UA — RBC 50+, dysmorphic, mild protein 1+, UP/UCr 0.4, complement normal
Family Hx + clinical features = X-linked Alport syndrome
Kidney biopsy + EM: basement membrane splitting + lamellation + thinning = Alport
Genetic testing: COL4A5 mutation positive (X-linked)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 18 mo คุณแม่กังวล — coarse facial features + recurrent URI + macrocephaly + corneal clouding + hepatosplenomegaly + cardiac murmur + delayed development + stiff joints + claw hand + กระดูกอ่อนผิดรูป (dysostosis multiplex)

PE: characteristic coarse face, large tongue, depressed nasal bridge, hepatosplenomegaly, lumbar gibbus, corneal clouding bilateral mild, joint contractures hands, BW + height < 3rd percentile

Lab: urine glycosaminoglycans (GAGs) markedly elevated; alpha-L-iduronidase enzyme: severely deficient → Hurler syndrome (MPS-I, severe form, IDUA gene autosomal recessive)
Echo: thickened mitral + aortic valves + mild LVH', '[{"label":"A","text":"Watchful waiting"},{"label":"B","text":"Mucopolysaccharidosis Type I Hurler (severe form, IDUA deficiency"},{"label":"C","text":"Antibiotic only"},{"label":"D","text":"Surgery alone"},{"label":"E","text":"Discharge no follow-up"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mucopolysaccharidosis Type I Hurler (severe form, IDUA deficiency — autosomal recessive) — multidisciplinary lifelong care: HEMATOPOIETIC STEM CELL TRANSPLANTATION (HSCT, allogeneic) — best treatment if performed EARLY (< 2 yr ideally, before significant CNS damage) — donor cells produce enzyme + provide enzyme delivery to CNS via crossing BBB (limited but partial), improves longevity + cognition + organomegaly — DECISION POINT NOW given age + severe form; ENZYME REPLACEMENT THERAPY (ERT) — Laronidase (Aldurazyme) IV weekly — does NOT cross BBB so does NOT prevent CNS deterioration in severe form (Hurler), but improves visceral disease + reduces airway/hepatosplenomegaly — typically GIVEN PERIOPERATIVELY when planning HSCT and continued long-term as adjunct; SUPPORTIVE — multispecialty annual evaluation: cardiology (valve disease — surgery may be needed), ENT (airway, AOM, hearing loss, OSA — adenotonsillectomy), ophtho (corneal clouding, glaucoma, retinopathy), neurology (cervical cord compression — RISK ANESTHESIA), orthopedic (carpal tunnel, hip dysplasia, kyphosis), neurosurgery (hydrocephalus → VP shunt), pulmonology (restrictive lung), gastroenterology, audiology, dental; PHYSICAL + OCCUPATIONAL therapy; ANESTHESIA CARE — extremely high risk (airway difficult, cervical instability, restrictive lung, valve disease) — anesthesia consult before procedures; ATTAINTIVES — gene therapy clinical trials emerging (autologous transduced HSC); substrate reduction therapy + intrathecal ERT investigational; FAMILY genetic counseling + carrier testing siblings; prenatal/preimplantation testing for future pregnancy; psychosocial support; transition adult metabolic — though severe Hurler historically died by age 5-10 without treatment, modern HSCT + ERT improves longevity

---

MPS Hurler = severe form, IDUA deficiency. Multisystem (face, viscera, joints, eye, brain, cardiac, airway). HSCT early (< 2 yr) for severe + ERT (laronidase) for visceral but limited CNS. High anesthesia risk. Gene therapy emerging. Multidisciplinary lifelong + family genetic counseling.', NULL,
  'medium', 'endocrine_metabolic', 'review',
  'pediatrics', 'basic_science', 'endocrine_metabolic', 'peds',
  'MPS Society Clinical Care Guidelines; Pediatric Metabolic Society', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 18 mo คุณแม่กังวล — coarse facial features + recurrent URI + macrocephaly + corneal clouding + hepatosplenomegaly + cardiac murmur + delayed development + stiff joints + claw hand + กระดูกอ่อนผิดรูป (dysostosis multiplex)

PE: characteristic coarse face, large tongue, depressed nasal bridge, hepatosplenomegaly, lumbar gibbus, corneal clouding bilateral mild, joint contractures hands, BW + height < 3rd percentile

Lab: urine glycosaminoglycans (GAGs) markedly elevated; alpha-L-iduronidase enzyme: severely deficient → Hurler syndrome (MPS-I, severe form, IDUA gene autosomal recessive)
Echo: thickened mitral + aortic valves + mild LVH'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 5 ปี multiple system involvement — developmental regression starting 2 yr + episodic vomiting + lactic acidosis episodes + ptosis bilateral + exercise intolerance + hearing loss bilateral + retinopathy + short stature + lactic acidemia

V/S: BW 14 kg (< 3rd %), HR mildly tachycardic, no acute distress
PE: ptosis bilateral, ophthalmoplegia, retinopathy on fundoscopy, sensorineural hearing loss bilateral, no rash

Lab: lactate 6.2 (HIGH chronic), pyruvate elevated, lactate/pyruvate ratio elevated, plasma amino acids — alanine high (chronic acidosis), urine organic acids — Krebs cycle intermediates abnormal; CK mildly elevated; CSF lactate elevated
Muscle biopsy: ragged red fibers + decreased COX staining + abnormal mitochondria EM; mtDNA testing: large deletion confirmed (Kearns-Sayre vs other)', '[{"label":"A","text":"Single drug cure"},{"label":"B","text":"Mitochondrial Disease (multisystemic"},{"label":"C","text":"Valproic acid"},{"label":"D","text":"Surgery curative"},{"label":"E","text":"Discharge no follow"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mitochondrial Disease (multisystemic — features overlap Kearns-Sayre/Leigh syndrome/MELAS): NO CURATIVE TREATMENT — symptomatic + supportive multidisciplinary lifelong; AVOID precipitants — STARVATION (frequent meals, avoid fasting > 4-6 hr, complex carbs at bedtime), DEHYDRATION (adequate hydration always), METABOLIC STRESS (illness/fever — early aggressive treatment with IV fluid + glucose); AVOID drugs that impair mitochondrial function — VALPROIC ACID (HEPATOTOXICITY in mitochondrial), aminoglycosides (deafness), high-dose steroid, anesthetic ketamine + thiopental + nitrous (use propofol total IV anesthesia with caution, avoid prolonged propofol — PRIS); SUPPLEMENT ''MITO COCKTAIL'' (evidence variable but commonly used): COENZYME Q10 (ubiquinone) 5-10 mg/kg/d, CARNITINE 50-100 mg/kg/d (if low), VITAMIN C + E (antioxidants), B vitamins (riboflavin 100 mg/d, thiamine, B12, folate), ARGININE (especially MELAS for stroke-like episodes — 0.5 g/kg orally daily prophylactic, 0.5 g/kg IV acute episode); CREATINE supplementation; address ACUTE LACTIC ACIDOSIS — IV fluid + dextrose, BICARBONATE only severe symptomatic (controversial); DIETARY — frequent small meals, complex carb at bedtime, may benefit from ketogenic diet (selected complex I deficiency); EXERCISE — moderate aerobic exercise improves mitochondrial biogenesis (paradoxically); MULTISYSTEM management — cardiology (cardiomyopathy, conduction defects — Kearns-Sayre block — PACEMAKER may be needed), ophthalmology (PEO, retinopathy), audiology (hearing aids), endocrine (diabetes, hypothyroid, growth issues), neurology (stroke-like episodes, epilepsy, dystonia), GI (dysmotility), nephrology (Fanconi); PT/OT; nutritional support — G-tube selected; genetic counseling — mitochondrial inheritance (mtDNA = maternal, heteroplasmy variable transmission; nDNA = autosomal); EMERGING — gene therapy + mitochondrial replacement therapy (legal in some countries); family support + transition adult

---

Mitochondrial disease = heterogeneous multisystem disorders. No cure. Supportive + ''mito cocktail'' (CoQ10, carnitine, vit B/C/E, arginine for MELAS). AVOID valproate (hepatotoxic), aminoglycosides, prolonged anesthetics. Avoid metabolic stress. Multidisciplinary. Mitochondrial inheritance counseling.', NULL,
  'medium', 'neurology', 'review',
  'pediatrics', 'basic_science', 'neurology', 'peds',
  'Mitochondrial Medicine Society Practice Patient Care Standards 2017', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 5 ปี multiple system involvement — developmental regression starting 2 yr + episodic vomiting + lactic acidosis episodes + ptosis bilateral + exercise intolerance + hearing loss bilateral + retinopathy + short stature + lactic acidemia

V/S: BW 14 kg (< 3rd %), HR mildly tachycardic, no acute distress
PE: ptosis bilateral, ophthalmoplegia, retinopathy on fundoscopy, sensorineural hearing loss bilateral, no rash

Lab: lactate 6.2 (HIGH chronic), pyruvate elevated, lactate/pyruvate ratio elevated, plasma amino acids — alanine high (chronic acidosis), urine organic acids — Krebs cycle intermediates abnormal; CK mildly elevated; CSF lactate elevated
Muscle biopsy: ragged red fibers + decreased COX staining + abnormal mitochondria EM; mtDNA testing: large deletion confirmed (Kearns-Sayre vs other)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 4 ปี ตรวจ routine CBC พบ Hb 10.2 (mild anemia) + MCV 65 (microcytic), MCH 21, MCHC normal, RDW 12.5 (NORMAL, not elevated), Plt + WBC normal, Retic 1.8% (normal)

Dietary: balanced, adequate iron-rich foods, breastfed first year + appropriate formula transition, no excessive milk, no recent illness
Family: parents both alpha-thalassemia trait, paternal grandfather Mediterranean origin

Iron studies normal — ferritin 65, TSAT 24%, iron + TIBC normal
Hb electrophoresis: HbA 95%, HbA2 normal, HbF normal (alpha-thalassemia electrophoresis often normal — DNA testing needed)
DNA testing α-globin: alpha-thalassemia trait (heterozygous α/-- or --SEA confirmed)', '[{"label":"A","text":"Iron supplementation indefinite"},{"label":"B","text":"Alpha Thalassemia Trait (alpha-thal carrier, --SEA common Thai/Southeast Asian)"},{"label":"C","text":"Blood transfusion"},{"label":"D","text":"Splenectomy"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Alpha Thalassemia Trait (alpha-thal carrier, --SEA common Thai/Southeast Asian): NO TREATMENT NEEDED for trait/carrier; reassurance — life expectancy normal, mild microcytosis lifelong, no clinical consequence to individual; DIFFERENTIATE from iron deficiency anemia (similar microcytic but iron studies + normal RDW + family hx + DNA help distinguish — KEY: IDA = high RDW + low ferritin + low TSAT; alpha-thal trait = normal/low normal RDW + normal iron studies + family history); AVOID UNNECESSARY iron supplementation — does not help thalassemia trait + can cause iron overload long-term; counsel family about INHERITANCE — autosomal recessive, both parents trait → 25% offspring may have Hb H disease (3 gene deletion — moderate disease, lifelong) OR Hb Bart hydrops fetalis (4 gene deletion --/-- = lethal in utero — severe consequence!); PREMARITAL / PRECONCEPTION COUNSELING crucial for couple with both alpha-thal trait — option of prenatal diagnosis (CVS, amnio) + preimplantation genetic diagnosis (PGD); national screening program Thai for thalassemia common (high prevalence Thailand 30-40% trait); reproductive education for the patient when older; OTHER ASIAN COUNTRY screening similar; recognize the family genetic implications + offer testing siblings + family; routine pediatric care otherwise; CBC follow-up; routine vaccinations; document allergy + thalassemia trait medical record; consider HPLC + DNA confirmation if uncertain

---

Alpha-thal trait = common in Southeast Asia, Mediterranean. Asymptomatic carrier. NO TREATMENT needed. Important: DIFFERENTIATE from IDA (RDW + iron studies). Avoid unnecessary iron. CRITICAL: GENETIC COUNSELING for couples — both trait → 25% Hb H disease or HYDROPS FETALIS (lethal). Premarital screening + prenatal diagnosis.', NULL,
  'easy', 'hematology', 'review',
  'pediatrics', 'clinical_decision', 'hematology', 'peds',
  'Thai National Thalassemia Network; TIF Guidelines for the Management of Non-Transfusion-Dependent Thalassemia 2017', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 4 ปี ตรวจ routine CBC พบ Hb 10.2 (mild anemia) + MCV 65 (microcytic), MCH 21, MCHC normal, RDW 12.5 (NORMAL, not elevated), Plt + WBC normal, Retic 1.8% (normal)

Dietary: balanced, adequate iron-rich foods, breastfed first year + appropriate formula transition, no excessive milk, no recent illness
Family: parents both alpha-thalassemia trait, paternal grandfather Mediterranean origin

Iron studies normal — ferritin 65, TSAT 24%, iron + TIBC normal
Hb electrophoresis: HbA 95%, HbA2 normal, HbF normal (alpha-thalassemia electrophoresis often normal — DNA testing needed)
DNA testing α-globin: alpha-thalassemia trait (heterozygous α/-- or --SEA confirmed)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 13 ปี vaccine ไม่ครบ (missed MMR booster) ปวด + บวม parotid gland bilateral + ไข้ + ปวดศีรษะ + ตึงคอ × 4 d, ตอนนี้ ปวด testicle ข้างขวา + บวมแดง 24 ชม + ไข้สูง ใหม่

V/S: HR 102, RR 22, Temp 38.8°C, BW 38 kg
PE: bilateral parotid swelling + tender, right scrotal swelling + erythema + tender testicle (epididymo-orchitis), no peritoneal sign, no meningeal stiffness severe

Lab: amylase elevated (parotitis), lipase normal (pancreas not), CBC mild lymphocytosis
Mumps IgM positive + RT-PCR positive; HSV negative; bacterial culture negative', '[{"label":"A","text":"Antibiotic alone"},{"label":"B","text":"Mumps with Orchitis (post-pubertal complication 15-30% males)"},{"label":"C","text":"Discharge home no precautions"},{"label":"D","text":"Antifungal alone"},{"label":"E","text":"Steroid only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mumps with Orchitis (post-pubertal complication 15-30% males): supportive care — no specific antiviral (viral self-limited); pain control — acetaminophen, ibuprofen, scrotal support + ice; bed rest, hydration; antiviral — interferon-alpha investigational, not standard; ISOLATION — droplet precautions until 5 days after parotitis onset (highly contagious); steroid use for orchitis controversial — some recommend short course prednisolone 1 mg/kg/d × 3-5 d for severe orchitis to reduce pain + possible fertility impact (evidence limited); WATCH for OTHER COMPLICATIONS — meningitis/encephalitis (1-10%, CSF mononuclear pleocytosis), oophoritis (post-pubertal females), pancreatitis (5%), deafness (sensorineural, sudden 5/10,000), arthritis, myocarditis, thyroiditis; LP if meningoencephalitis suspected (severe HA + AMS + nuchal rigidity); audiogram follow-up at recovery + 3 mo (hearing loss); FERTILITY counsel — orchitis MAY cause testicular atrophy + reduced fertility in 15-30% of orchitis cases, BILATERAL infrequent but more concerning, true sterility rare (~13% unilateral, < 30% bilateral); REPORT — public health (reportable disease); CONTACTS — vaccinate susceptible contacts within 72 hr (MMR), counsel pregnancy contact (vaccine contraindicated pregnancy + immunocompromised); PREVENTION — MMR vaccine 2 dose (Thai EPI + CDC) — outbreaks in undervaccinated communities (booster recommended outbreak settings, third MMR can boost waning immunity per CDC outbreak guidance); long-term — most fully recover, document immunity status for family + patient + reproductive counseling

---

Mumps + orchitis = post-pubertal complication (testicular atrophy + reduced fertility, rare bilateral sterility). Supportive treatment, scrotal support + analgesia, droplet isolation 5 d post-parotitis. Watch other complications (meningitis, deafness, pancreatitis). MMR 2-dose prevention + outbreak boost. Reportable.', NULL,
  'medium', 'id', 'review',
  'pediatrics', 'clinical_decision', 'id', 'peds',
  'AAP Red Book 2024 Mumps; CDC ACIP Mumps Recommendations', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 13 ปี vaccine ไม่ครบ (missed MMR booster) ปวด + บวม parotid gland bilateral + ไข้ + ปวดศีรษะ + ตึงคอ × 4 d, ตอนนี้ ปวด testicle ข้างขวา + บวมแดง 24 ชม + ไข้สูง ใหม่

V/S: HR 102, RR 22, Temp 38.8°C, BW 38 kg
PE: bilateral parotid swelling + tender, right scrotal swelling + erythema + tender testicle (epididymo-orchitis), no peritoneal sign, no meningeal stiffness severe

Lab: amylase elevated (parotitis), lipase normal (pancreas not), CBC mild lymphocytosis
Mumps IgM positive + RT-PCR positive; HSV negative; bacterial culture negative'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 6 ปี เริ่มซีดอย่างรวดเร็ว + เหนื่อย + ปัสสาวะสีโคล่า dark + ตาเหลือง 3 วัน ก่อนหน้านี้เป็น viral URI 1 สัปดาห์

V/S: HR 132, BP 102/68, RR 24, Temp 37.6°C, BW 20 kg, jaundice
PE: pallor, jaundice, splenomegaly 2 cm BCM, no lymphadenopathy, no organomegaly other

Lab: Hb 5.2 (acute drop from baseline 12), MCV 105 (macrocytic — reticulocytosis), retic 18% (HIGH), LDH 980, haptoglobin LOW, indirect bilirubin 6.2 elevated, direct Coombs POSITIVE (warm IgG), no schistocytes, Plt + WBC normal
Negative ANA, normal complement, no recent drug, viral panel positive Mycoplasma + EBV recent', '[{"label":"A","text":"Iron supplementation alone"},{"label":"B","text":"Acute Autoimmune Hemolytic Anemia warm-IgG (post-viral/Mycoplasma + EBV-associated)"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Surgery first"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Autoimmune Hemolytic Anemia warm-IgG (post-viral/Mycoplasma + EBV-associated): admit; ABC + monitor; supportive — adequate hydration (alkalinize urine to prevent renal damage from hemolysis), monitor renal function + electrolytes; PRBC TRANSFUSION carefully if symptomatic severe anemia (Hb < 5 or symptomatic) — challenge: ALL units may be incompatible due to autoantibody panreactive — emergency ''least incompatible'' units selected by blood bank in consultation; slow transfusion with vigilant monitoring; FIRST-LINE — CORTICOSTEROID — prednisolone 1-2 mg/kg/d (max 60 mg) PO OR methylprednisolone IV equivalent — typically 70-80% response, slow taper over months once Hb stabilizes; AVOID PREMATURE STEROID TAPER (relapse common); IVIG 1-2 g/kg in selected cases — short-term boost or if hemolysis severe; FOLIC ACID 1 mg/d (increased demand); REFRACTORY OR RELAPSED — second-line — rituximab (anti-CD20) increasingly first-line or early second in AIHA (especially pediatric — fewer side effects than long-term steroid, durable response); other options: cyclosporine, MMF, azathioprine, danazol; SPLENECTOMY rarely needed kids (long-term infection risk + many spontaneous remission); investigate UNDERLYING — viral (EBV, CMV, Mycoplasma — supportive), drug-induced (review meds), autoimmune (ANA, lupus serology), lymphoproliferative (rare child but consider if persistent), Evans syndrome (AIHA + ITP); thromboprophylaxis selected (AIHA + LE/APS + immobile); patient + family education + monitor recovery; isolation if Mycoplasma or other infectious cause; long-term most children RECOVER with treatment (vs adult AIHA which can be chronic)

---

AIHA pediatric usually warm-IgG, often post-viral. Coombs+, hemolysis labs, splenomegaly. Treat with steroid first-line + RBC transfusion carefully (least incompatible). Rituximab second-line increasingly first-line in pediatrics. Long-term recovery typical in kids. Investigate underlying viral/autoimmune.', NULL,
  'medium', 'hematology', 'review',
  'pediatrics', 'clinical_decision', 'hematology', 'peds',
  'ASH Pediatric AIHA; British Society Haematology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 6 ปี เริ่มซีดอย่างรวดเร็ว + เหนื่อย + ปัสสาวะสีโคล่า dark + ตาเหลือง 3 วัน ก่อนหน้านี้เป็น viral URI 1 สัปดาห์

V/S: HR 132, BP 102/68, RR 24, Temp 37.6°C, BW 20 kg, jaundice
PE: pallor, jaundice, splenomegaly 2 cm BCM, no lymphadenopathy, no organomegaly other

Lab: Hb 5.2 (acute drop from baseline 12), MCV 105 (macrocytic — reticulocytosis), retic 18% (HIGH), LDH 980, haptoglobin LOW, indirect bilirubin 6.2 elevated, direct Coombs POSITIVE (warm IgG), no schistocytes, Plt + WBC normal
Negative ANA, normal complement, no recent drug, viral panel positive Mycoplasma + EBV recent'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 4 ปี กำลังกินขนมเชอรี่ + พูด + จู่ ๆ ก็เริ่มไอ + grasps throat + ไม่สามารถพูดได้ + cyanosis เริ่ม + ไม่สามารถหายใจ

Conscious + standing + alert + signs choking universal sign (clutching throat)
ไม่สามารถ cry, no air movement, สีฟ้า

สถานการณ์ critical airway obstruction full', '[{"label":"A","text":"Wait — child usually self-resolves"},{"label":"B","text":"Conscious child with foreign body airway obstruction (FBAO) complete"},{"label":"C","text":"Wait — observe at home"},{"label":"D","text":"Mouth-to-mouth without addressing"},{"label":"E","text":"Discharge home no assessment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Conscious child with foreign body airway obstruction (FBAO) complete — AHA BLS algorithm: assess universal sign of choking + inability to speak/cough/breathe = COMPLETE OBSTRUCTION; for CONSCIOUS child > 1 yr → ABDOMINAL THRUSTS (Heimlich maneuver) — stand or kneel behind child, place fist (thumb-side) above navel + below ribcage, grasp with other hand, quick upward thrusts × 5 + reassess + repeat until expelled OR unconscious; for INFANT < 1 yr (different) → 5 back blows (between scapulae) + 5 chest thrusts (sternum compression), alternating until expelled or unconscious; if UNCONSCIOUS → start CPR, lower onto firm surface, BEGIN compressions first (per current AHA — compressions may expel FB), 30 compressions then look in mouth for visible FB before breaths (DO NOT blind finger sweep), if FB visible — remove with finger, then 2 breaths if possible, continue CPR; call EMS 1669 (Thailand) immediately; transport once secured (FB removed or in ALS hands); after expulsion → assess + observe (may have lower airway/post-obstruction issues), seek medical care for airway trauma, residual aspiration, swallowing/respiratory function evaluation; AVOID — back blows in standing conscious > 1 yr (per current AHA peds — abdominal thrusts preferred), blind finger sweep (may push FB deeper); PREVENTION — choking-hazard foods (round/hard/smooth — grapes, nuts, hot dogs, hard candy, popcorn, marshmallow), supervise during meals, no eating + running, age-appropriate food, food cut into small pieces, parent CPR training, choking awareness; for severe cases beyond BLS → ALS, emergency cricothyroidotomy (last resort), rigid bronchoscopy if at hospital

---

FBAO = AHA BLS algorithm. Conscious > 1 yr — abdominal thrusts (Heimlich). Infant < 1 yr — back blows + chest thrusts. Unconscious — CPR (compressions first), check mouth between cycles (no blind sweep). Call EMS. Prevention — supervised meals, no choking hazard foods.', NULL,
  'easy', 'respiratory', 'review',
  'pediatrics', 'clinical_decision', 'respiratory', 'peds',
  'AHA BLS Pediatric Guidelines 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 4 ปี กำลังกินขนมเชอรี่ + พูด + จู่ ๆ ก็เริ่มไอ + grasps throat + ไม่สามารถพูดได้ + cyanosis เริ่ม + ไม่สามารถหายใจ

Conscious + standing + alert + signs choking universal sign (clutching throat)
ไม่สามารถ cry, no air movement, สีฟ้า

สถานการณ์ critical airway obstruction full'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 2 ปี ไข้ต่ำ 38.0°C + น้ำมูก clear + ไอเล็กน้อย + เจ็บคอ × 3 วัน ไม่มีหอบเหนื่อย ไม่มี ear pain, well-appearing, กินดี, เล่นได้, ดูแข็งแรง

V/S: HR 102, RR 28, SpO2 99%, Temp 38.0°C, BW 12 kg
PE: clear rhinorrhea, mild pharyngeal erythema, tympanic membranes normal, lungs clear, no LN, normal exam

No medical Hx, vaccines up-to-date', '[{"label":"A","text":"Antibiotic immediately"},{"label":"B","text":"Viral Upper Respiratory Infection (common cold, rhinovirus most common)"},{"label":"C","text":"Strict bed rest"},{"label":"D","text":"Steroid"},{"label":"E","text":"Discharge with no education"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Viral Upper Respiratory Infection (common cold, rhinovirus most common): supportive care — adequate hydration, rest, humidification; saline nasal drops/sprays + gentle suction for nasal congestion (especially infants who are obligate nose breathers); honey for cough ≥ 1 yr (NOT < 1 yr — botulism risk) — better than dextromethorphan in trials; ACETAMINOPHEN or IBUPROFEN for fever > 38.5 + discomfort (alternate not recommended routinely); AVOID — over-the-counter cough/cold medicine < 6 yr (FDA + AAP warn, no efficacy + side effects), antibiotic (no benefit for viral, increases resistance), antihistamine for cold (no benefit + sedation), decongestant nasal spray (rebound + side effects); EDUCATION family — typical course 7-10 days, peak day 3-5, cough may persist 2-3 wk; return precautions — high fever > 3-4 d, difficulty breathing, dehydration, ear pain, persistent symptoms > 10 d (suggests bacterial sinusitis), worsening; PREVENTION — handwashing, avoid sharing utensils, cover cough/sneeze, stay home when sick, annual influenza vaccination, breastfeeding; address — daycare/school exclusion until fever-free 24 hr (without antipyretic) + well-appearing; education on hand hygiene + when to seek medical care

---

URI = common cold, viral self-limited. Supportive care only. AVOID antibiotic + OTC cough/cold meds < 6 yr + decongestant spray. Honey for cough > 1 yr. Education family on course + return precautions + prevention.', NULL,
  'easy', 'respiratory', 'review',
  'pediatrics', 'clinical_decision', 'respiratory', 'peds',
  'AAP Clinical Report Common Cold; FDA OTC Cold Medicine Pediatric Warnings', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 2 ปี ไข้ต่ำ 38.0°C + น้ำมูก clear + ไอเล็กน้อย + เจ็บคอ × 3 วัน ไม่มีหอบเหนื่อย ไม่มี ear pain, well-appearing, กินดี, เล่นได้, ดูแข็งแรง

V/S: HR 102, RR 28, SpO2 99%, Temp 38.0°C, BW 12 kg
PE: clear rhinorrhea, mild pharyngeal erythema, tympanic membranes normal, lungs clear, no LN, normal exam

No medical Hx, vaccines up-to-date'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 6 ปี URI symptoms × 12 วันโดยไม่ดีขึ้น + ปวดที่หน้าผาก + คัดจมูก purulent yellow-green discharge + ไอเรื้อรัง + ไข้ + halitosis + กรอบตาบวมเล็กน้อย morning

V/S: HR 92, RR 22, Temp 38.0°C, BW 22 kg
PE: tender to palpation maxillary + frontal sinuses, purulent nasal discharge, mild periorbital edema (no proptosis or visual disturbance), no other findings

Diagnosis acute bacterial sinusitis based on AAP criteria: persistent symptoms > 10 d without improvement + worsening + severe onset', '[{"label":"A","text":"Antiviral alone"},{"label":"B","text":"Acute Bacterial Sinusitis (criteria AAP"},{"label":"C","text":"Discharge no follow-up"},{"label":"D","text":"Wait 4 weeks"},{"label":"E","text":"Surgery first"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Bacterial Sinusitis (criteria AAP — persistent > 10 d without improvement, OR worsening, OR severe onset with fever > 39°C + purulent discharge ≥ 3 d): antibiotic indicated; AMOXICILLIN 45 mg/kg/d ÷ q12h × 10 d (standard dose first-line) OR HIGH-DOSE AMOXICILLIN-CLAVULANATE 90 mg/kg/d ÷ q12h × 10 d (for: recent antibiotic < 30 d, daycare attendance, < 2 yr, severe disease, persistent症; better coverage of resistant Strep pneumo + H flu + M cat); duration 10 d for uncomplicated; alternatives for true penicillin allergy — cefdinir, cefuroxime, cefpodoxime, levofloxacin (anaphylaxis); supportive — saline nasal irrigation, decongestant short-term (< 5 d, no rebound), analgesia; AVOID antihistamine (thickens secretions), oral decongestant routine; reassess 48-72 hr — if not improving → switch to amox-clav or add 3rd-gen cephalosporin (ceftriaxone IM 50 mg/kg × 1-3 d); RED FLAGS for complications — eye involvement (preseptal vs orbital cellulitis, abscess, vision change, ophthalmoplegia, proptosis = ORBITAL COMPLICATIONS, EMERGENCY imaging + IV antibiotic + ENT/ophthalmology), intracranial complications (severe HA, AMS, focal deficit, fever, seizure = MENINGITIS, ABSCESS, CAVERNOUS SINUS THROMBOSIS); osteomyelitis frontal bone (Pott puffy tumor); admit + IV antibiotic for complications; recurrent sinusitis — workup immunodeficiency, allergy, anatomic abnormality, CF, primary ciliary dyskinesia

---

Acute bacterial sinusitis criteria AAP. Amoxicillin standard OR amox-clav for risk factors. Duration 10 d. Watch for orbital + intracranial complications (eye signs, neuro signs = emergency). Recurrent = workup underlying.', NULL,
  'easy', 'id', 'review',
  'pediatrics', 'clinical_decision', 'id', 'peds',
  'AAP Clinical Practice Guideline Acute Bacterial Sinusitis 2013', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 6 ปี URI symptoms × 12 วันโดยไม่ดีขึ้น + ปวดที่หน้าผาก + คัดจมูก purulent yellow-green discharge + ไอเรื้อรัง + ไข้ + halitosis + กรอบตาบวมเล็กน้อย morning

V/S: HR 92, RR 22, Temp 38.0°C, BW 22 kg
PE: tender to palpation maxillary + frontal sinuses, purulent nasal discharge, mild periorbital edema (no proptosis or visual disturbance), no other findings

Diagnosis acute bacterial sinusitis based on AAP criteria: persistent symptoms > 10 d without improvement + worsening + severe onset'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 3 ปี วันที่ 2 ของไข้ต่ำ + เจ็บปาก + ปฏิเสธอาหาร + พบ vesicles ในปาก + บริเวณฝ่ามือ ฝ่าเท้า + ก้น well-appearing แต่กินไม่ค่อย

V/S: HR 102, Temp 38.2°C, BW 14 kg, no dehydration
PE: ulcerative vesicular lesions oral mucosa (palate, tongue, buccal), papulovesicular rash hands + feet + buttocks, no rash on trunk, no respiratory distress, no neuro deficit

Daycare outbreak; suspected Coxsackie A16 or Enterovirus 71 (EV-71 higher complications)', '[{"label":"A","text":"Antibiotic"},{"label":"B","text":"Hand-Foot-Mouth Disease (HFMD, enterovirus most commonly Coxsackie A16, also A6 atypical severe, EV-71 with neurological complications)"},{"label":"C","text":"Steroid"},{"label":"D","text":"Antifungal"},{"label":"E","text":"Discharge no education"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hand-Foot-Mouth Disease (HFMD, enterovirus most commonly Coxsackie A16, also A6 atypical severe, EV-71 with neurological complications): supportive care — viral self-limited 7-10 d; hydration KEY (oral aversion from painful oral ulcers — offer cold liquids, popsicles, smooth food, avoid acidic/spicy); PAIN — acetaminophen + ibuprofen; topical analgesic — viscous lidocaine (CAUTION young child — local application only, not ''magic mouthwash'' with diphenhydramine due to systemic toxicity in young kids — recently FDA warned); cool foods (ice cream, smoothies, popsicles, yogurt); soft bland diet; SCHOOL/DAYCARE — exclude until fever resolved + lesions crusted (drooling/lesion contagious, fecal-oral persists weeks); CONTACT precautions + hand hygiene + sanitize toys/surfaces; usually no specific antiviral (investigational pleconaril); MONITOR for COMPLICATIONS (mostly EV-71) — neurological (aseptic meningitis, encephalitis, brainstem encephalitis, polio-like paralysis, AFM acute flaccid myelitis), cardiorespiratory (pulmonary edema, myocarditis can be fatal), dehydration from poor oral intake; admit if: severe dehydration, neurological symptoms, persistent high fever, age < 6 mo, immunocompromised, refusal of liquids; ATYPICAL HFMD (Coxsackie A6) — more severe vesicles widespread + onychomadesis (nail shedding) weeks later; EV-71 outbreaks Asia + Australia 2010s significant; EV-71 vaccine in development + available China; reportable in some regions; PRIMARY PREVENTION — handwashing + hygiene + disinfection; secondary attack rate in households high

---

HFMD = enterovirus (Coxsackie A16 common; EV-71 severe with neurological + cardiopulmonary complications). Supportive + hydration + pain. Daycare/school exclusion fever-free + lesions. Watch EV-71 complications (encephalitis, AFM, pulmonary edema). Hygiene prevention.', NULL,
  'easy', 'id', 'review',
  'pediatrics', 'clinical_decision', 'id', 'peds',
  'AAP Red Book 2024 Enteroviruses', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 3 ปี วันที่ 2 ของไข้ต่ำ + เจ็บปาก + ปฏิเสธอาหาร + พบ vesicles ในปาก + บริเวณฝ่ามือ ฝ่าเท้า + ก้น well-appearing แต่กินไม่ค่อย

V/S: HR 102, Temp 38.2°C, BW 14 kg, no dehydration
PE: ulcerative vesicular lesions oral mucosa (palate, tongue, buccal), papulovesicular rash hands + feet + buttocks, no rash on trunk, no respiratory distress, no neuro deficit

Daycare outbreak; suspected Coxsackie A16 or Enterovirus 71 (EV-71 higher complications)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกชายอายุ 3 mo BW 5.5 kg ไข้ต่ำ + ไอ + ดูดนมน้อยลง 24 ชม ก่อนหน้า 4 วัน เป็นหวัด พี่ที่บ้านเพิ่งเป็น URI

V/S: HR 162, RR 56, SpO2 95% room air, Temp 37.6°C
Gen: alert, มี wheeze เบา + few crackles bilateral, mild retraction subcostal, no nasal flaring severe, no cyanosis, no apnea, taking 70% normal feed orally

CBC routine not necessary; CXR not routine indicated; RSV antigen + (not required for diagnosis)
Severity: MILD bronchiolitis', '[{"label":"A","text":"Routine bronchodilator + steroid"},{"label":"B","text":"Mild Bronchiolitis (alert + feeding > 50% + no severe distress + SpO2 ≥ 92% + age > 3 mo with no apnea)"},{"label":"C","text":"Antibiotic IV"},{"label":"D","text":"Chest physiotherapy"},{"label":"E","text":"Hospitalization always"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mild Bronchiolitis (alert + feeding > 50% + no severe distress + SpO2 ≥ 92% + age > 3 mo with no apnea): outpatient management appropriate — supportive care mainstay per AAP 2014 guideline; reassure family — typical course 5-7 days symptoms peak day 3-5, total 14-21 days cough lingers, self-limited; nasal saline drops/spray + gentle bulb suction before feeds + sleep — opens nasal airway (infant obligate nasal breather), improves feeding + sleep; humidified air; CONTINUE breastfeeding/formula — small frequent feeds; tylenol/ibuprofen for fever > 6 mo (only acetaminophen < 6 mo); AVOID per AAP 2014 — routine bronchodilator (no benefit shown), routine steroid (no benefit + concerns), antibiotic (viral + no benefit), chest physiotherapy (no benefit + may distress), epinephrine nebulizer (limited benefit), hypertonic saline (mixed evidence outpatient); RETURN PRECAUTIONS — increased work of breathing/retractions, RR > 60-70, decreased feeding < 50%, dehydration, apnea, cyanosis, lethargy, fever > 38.5 persistent, age < 3 mo, immunocompromised, chronic medical condition; OFFICE FOLLOW-UP 24-48 hr if concern; PREVENTION — RSV palivizumab prophylaxis for high-risk (preterm, BPD, CHD, immunocompromised) during RSV season; NIRSEVIMAB (new RSV monoclonal antibody) FDA-approved for ALL infants in first RSV season — single SC dose, broader use than palivizumab; maternal RSV vaccination during pregnancy 32-36 wk protects infant; handwashing + smoke avoidance; admit if: severe distress, hypoxia < 92%, dehydration, apnea, < 3 mo high-risk, poor caregiver capacity

---

Mild bronchiolitis = outpatient + supportive. AAP 2014: NO routine bronchodilator/steroid/antibiotic/chest PT. Saline nasal + suction + small frequent feeds. Education + return precautions. NEW prevention: nirsevimab (broader than palivizumab) all infants + maternal RSV vaccine.', NULL,
  'easy', 'respiratory', 'review',
  'pediatrics', 'clinical_decision', 'respiratory', 'peds',
  'AAP Clinical Practice Guideline Bronchiolitis 2014; AAP RSV Prophylaxis 2023 Nirsevimab', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกชายอายุ 3 mo BW 5.5 kg ไข้ต่ำ + ไอ + ดูดนมน้อยลง 24 ชม ก่อนหน้า 4 วัน เป็นหวัด พี่ที่บ้านเพิ่งเป็น URI

V/S: HR 162, RR 56, SpO2 95% room air, Temp 37.6°C
Gen: alert, มี wheeze เบา + few crackles bilateral, mild retraction subcostal, no nasal flaring severe, no cyanosis, no apnea, taking 70% normal feed orally

CBC routine not necessary; CXR not routine indicated; RSV antigen + (not required for diagnosis)
Severity: MILD bronchiolitis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 5 ปี ตื่นเช้ามาตาแฉะ + ขี้ตาเป็น crust + ตาแดง 2 ข้าง 2 d ก่อน + URI ตอนนี้ asymptomatic อื่น ๆ ดี ไม่มีไข้ ไม่มีปวด ไม่เห็นไม่ดีลง daycare + เพื่อนคนหนึ่งเป็นเหมือนกัน

V/S: ปกติ, BW 20 kg
PE: bilateral conjunctival injection + mucopurulent discharge mild + crust eyelid (worst morning) + preauricular LN absent, no proptosis, no photophobia, visual acuity normal, no foreign body sensation, no contact lens use
No signs systemic — measles, KD, herpes', '[{"label":"A","text":"Wait — observe + no education"},{"label":"B","text":"Conjunctivitis pediatric"},{"label":"C","text":"Topical steroid alone"},{"label":"D","text":"Surgical eye procedure"},{"label":"E","text":"Antifungal drops first-line"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Conjunctivitis pediatric — bacterial vs viral approach: most pediatric conjunctivitis bacterial (Strep pneumo, H. influenzae most, especially with concurrent AOM = ''conjunctivitis-otitis syndrome'') vs adult viral predominance; bacterial features — mucopurulent discharge prominent + matted lids especially morning, can be bilateral; viral features — clear/watery discharge + preauricular adenopathy + concurrent URI; in pediatric, EMPIRIC TOPICAL ANTIBIOTIC commonly used (although meta-analyses suggest most bacterial self-resolve, antibiotic shortens duration + return to school + treats concurrent OM if missed) — ERYTHROMYCIN ophthalmic ointment 0.5% ¼ inch ribbon to lower lid 4-6× daily × 5-7 d OR Polymyxin B/trimethoprim ophthalmic drops 1 drop q4-6h × 5-7 d OR Sulfacetamide drops × 5-7 d; AZITHROMYCIN 1% drops 1 drop BID × 2 d then daily × 5 d; fluoroquinolone drops for severe/contact lens; AVOID — Neomycin (allergy frequency), steroid drops (NO STEROID in conjunctivitis EVER without ophthalmology — masks HSV/bacterial worsening); EYE HYGIENE — warm compress + gentle wipe with sterile saline cotton; remove + DISCARD contact lenses; HANDWASHING + no eye rubbing + own towel/pillowcase; RETURN TO SCHOOL — 24 hr after antibiotic start typically (varies by school) + crusting clears; OPHTHALMOLOGY REFERRAL — moderate-severe pain, photophobia, visual changes, contact lens wear, foreign body, copious discharge (gonorrhea — STAT), unilateral, allergic refractory, neonatal conjunctivitis (different — silver nitrate or erythromycin prophylaxis newborn standard, gonorrhea/chlamydia in newborn), HSV (vesicles + corneal involvement); ALLERGIC conjunctivitis — bilateral + intense itching + clear watery + tearing + concurrent rhinitis — treat with antihistamine drops

---

Pediatric conjunctivitis = often bacterial (vs adult viral). Bacterial — purulent + matted lids. Empiric topical antibiotic (erythromycin, polymyxin/trimethoprim, azithromycin) shortens course. AVOID topical steroid (masks HSV). Refer if severe/contact lens/visual change/atypical.', NULL,
  'easy', 'id', 'review',
  'pediatrics', 'clinical_decision', 'id', 'peds',
  'AAO Conjunctivitis Preferred Practice Pattern 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 5 ปี ตื่นเช้ามาตาแฉะ + ขี้ตาเป็น crust + ตาแดง 2 ข้าง 2 d ก่อน + URI ตอนนี้ asymptomatic อื่น ๆ ดี ไม่มีไข้ ไม่มีปวด ไม่เห็นไม่ดีลง daycare + เพื่อนคนหนึ่งเป็นเหมือนกัน

V/S: ปกติ, BW 20 kg
PE: bilateral conjunctival injection + mucopurulent discharge mild + crust eyelid (worst morning) + preauricular LN absent, no proptosis, no photophobia, visual acuity normal, no foreign body sensation, no contact lens use
No signs systemic — measles, KD, herpes'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกชายอายุ 8 wk BW 4 kg ก่อนคลอดครบกำหนด แต่มาด้วย apnea + severe respiratory distress + cyanosis + dehydration + ไอ 5 วันแล้ว วันแรก RSV positive

V/S: HR 188, RR 78 (then apneic pauses 20 sec), SpO2 84% RA → 92% on 2 L NC, Temp 36.5°C
Gen: lethargic, severe retraction, nasal flaring, grunting, mild cyanosis perioral, decreased UO past 12 hr

CBC: WBC normal, CRP slightly elevated
CXR: hyperinflation + scattered atelectasis bilateral + perihilar infiltrate (RSV pattern)
ABG: pH 7.30, PaCO2 50 (rising), PaO2 62 on FiO2 0.40', '[{"label":"A","text":"Outpatient observation"},{"label":"B","text":"Severe Bronchiolitis + apnea + impending failure (high-risk profile"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Antiviral oseltamivir"},{"label":"E","text":"Steroid IV high dose"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe Bronchiolitis + apnea + impending failure (high-risk profile: < 12 wk, apnea, severe distress, hypoxia, dehydration, rising PaCO2): admit ICU; close monitoring continuous SpO2 + cardiac + respiratory; HFNC HIGH-FLOW NASAL CANNULA 1-2 L/kg/min FiO2 titrated (first-line respiratory support, reduces intubation 30-50% per recent peds trials, especially severe bronchiolitis) — better than standard low-flow O2 or face mask; nasal CPAP if HFNC insufficient (5-7 cmH2O); INTUBATION + MECHANICAL VENTILATION if HFNC/CPAP fails — gentle ventilation strategy (permissive hypercapnia OK, avoid volutrauma), low TV 5-6 mL/kg + PEEP titrated + low Pplat < 30 + heat-moisture exchanger; FLUID — IV maintenance + cautious correction of dehydration (avoid SIADH-related hyponatremia → use isotonic ASPEN 2023, avoid hypotonic, monitor Na q6-12 h, target 1-1.25× maintenance until tolerating PO); SUCTION nasal/oral; supplemental O2 to SpO2 ≥ 90% AAP (some target ≥ 92% for younger/severe); AVOID per AAP 2014 — routine bronchodilator/steroid/antibiotic; HYPERTONIC SALINE 3% nebulizer — selected (mixed evidence for inpatient bronchiolitis — modest benefit), 4-6 mL q4h; consider EPI nebulizer trial selected; ANTIBIOTIC empiric if signs concurrent bacterial pneumonia/sepsis (rare); palivizumab/nirsevimab for prevention not treatment; ECMO selected — refractory hypoxemia/CO2 retention/cardiac failure (PPHN can develop); contact + droplet isolation (RSV); reassessment regular; transfer pediatric ICU if not at one already; FAMILY support + counsel; AAP RSV prophylaxis update — nirsevimab single dose for infants first RSV season highly effective preventing severe bronchiolitis 80% reduction

---

Severe bronchiolitis = ICU + respiratory support escalation (HFNC → CPAP → mechanical ventilation). Watch for apnea (young infants, premature), respiratory failure. NO routine bronchodilator/steroid/antibiotic (AAP 2014). Hypertonic saline selective. Nirsevimab prevention. ECMO for refractory.', NULL,
  'medium', 'respiratory', 'review',
  'pediatrics', 'clinical_decision', 'respiratory', 'peds',
  'AAP Bronchiolitis 2014; HFNC Pediatric Trials', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกชายอายุ 8 wk BW 4 kg ก่อนคลอดครบกำหนด แต่มาด้วย apnea + severe respiratory distress + cyanosis + dehydration + ไอ 5 วันแล้ว วันแรก RSV positive

V/S: HR 188, RR 78 (then apneic pauses 20 sec), SpO2 84% RA → 92% on 2 L NC, Temp 36.5°C
Gen: lethargic, severe retraction, nasal flaring, grunting, mild cyanosis perioral, decreased UO past 12 hr

CBC: WBC normal, CRP slightly elevated
CXR: hyperinflation + scattered atelectasis bilateral + perihilar infiltrate (RSV pattern)
ABG: pH 7.30, PaCO2 50 (rising), PaO2 62 on FiO2 0.40'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 14 ปี (post-menarche 2 yr, tampon use last menses 5 d ago, removed 24 hr ago) ตอนนี้ ไข้สูง 40°C ฉับพลัน + ผื่นแดง diffuse macular + คลื่นไส้ + อาเจียน + ปวดเมื่อย muscle + ความดันต่ำ confused 6 hr

V/S: HR 142, BP 78/42, RR 28, SpO2 96%, Temp 40°C, BW 45 kg
Gen: ill-appearing, generalized erythroderma + diffuse macular rash (sunburn-like), mucous membrane hyperemia (strawberry tongue + conjunctival injection), no signs meningitis, capillary refill 4 sec

Lab: WBC 22,500 (left shift), Plt 65,000, Cr 1.8 (AKI), AST/ALT elevated, CK 1,800 (myositis), CPR 285, lactate 4.2, INR 1.4
Cultures pending; pelvic exam — find retained tampon piece! source identified', '[{"label":"A","text":"Antiviral alone"},{"label":"B","text":"Staphylococcal Toxic Shock Syndrome (TSST-1 superantigen-mediated, classic tampon-associated menstrual TSS"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Steroid alone"},{"label":"E","text":"Diuretic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Staphylococcal Toxic Shock Syndrome (TSST-1 superantigen-mediated, classic tampon-associated menstrual TSS — CDC criteria: fever ≥ 38.9, diffuse macular rash, hypotension, multisystem involvement ≥ 3 organs, desquamation 1-2 wk later): ICU admission + multidisciplinary; ABC + aggressive RESUSCITATION — IV crystalloid 20 mL/kg bolus repeat to restore perfusion (often need MASSIVE volume — capillary leak), vasopressor norepinephrine + epinephrine for cold/warm shock; SOURCE CONTROL — REMOVE TAMPON (retained foreign body source) IMMEDIATELY, irrigate vagina, examine for retained pieces; EMPIRIC ANTIBIOTIC — combination: 1) Clindamycin 40 mg/kg/d ÷ q6-8h IV (PROTEIN SYNTHESIS INHIBITOR — turns OFF toxin production, critical addition) + 2) Vancomycin 60 mg/kg/d ÷ q6h IV (cover MRSA + Staph aureus, until MRSA excluded) OR Oxacillin/Nafcillin if MSSA + non-MRSA region; alternative — linezolid (also turns off protein synthesis); duration 10-14 d IV → oral; if GAS-associated streptococcal TSS = penicillin G + clindamycin (similar combo); IVIG 1-2 g/kg single dose — recommended (binds + neutralizes superantigen toxins, evidence supportive); supportive — manage AKI (consider CRRT), liver dysfunction, DIC (replace fibrinogen + platelet if bleed), respiratory failure (intubation + ARDS strategy), aggressive supportive (electrolytes, glucose, nutrition); monitor for COMPLICATIONS — MOFS, AKI, DIC, ARDS, mortality 5-15%; DESQUAMATION on palms + soles 1-2 wk later (pathognomonic); recurrence risk if persists tampon use + persistent colonization — counsel avoidance of high-absorbency tampons + frequent change + alternate methods; EDUCATION + reportable disease (cluster surveillance, although now uncommon); pediatric infectious disease + gynecology consultation; psychiatric/social — adolescent + understanding precautions

---

TSS = superantigen-mediated (TSST-1 staph, scarlet fever toxin GAS). Menstrual + non-menstrual forms. CDC criteria. Multisystem failure. ABC + source control + clinda (protein synthesis = toxin OFF) + anti-staph (vanc/oxacillin) + IVIG. ICU. Education prevention. Desquamation pathognomonic 1-2 wk.', NULL,
  'hard', 'id', 'review',
  'pediatrics', 'clinical_decision', 'id', 'peds',
  'CDC TSS Case Definition; AAP Red Book TSS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 14 ปี (post-menarche 2 yr, tampon use last menses 5 d ago, removed 24 hr ago) ตอนนี้ ไข้สูง 40°C ฉับพลัน + ผื่นแดง diffuse macular + คลื่นไส้ + อาเจียน + ปวดเมื่อย muscle + ความดันต่ำ confused 6 hr

V/S: HR 142, BP 78/42, RR 28, SpO2 96%, Temp 40°C, BW 45 kg
Gen: ill-appearing, generalized erythroderma + diffuse macular rash (sunburn-like), mucous membrane hyperemia (strawberry tongue + conjunctival injection), no signs meningitis, capillary refill 4 sec

Lab: WBC 22,500 (left shift), Plt 65,000, Cr 1.8 (AKI), AST/ALT elevated, CK 1,800 (myositis), CPR 285, lactate 4.2, INR 1.4
Cultures pending; pelvic exam — find retained tampon piece! source identified'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกชายอายุ 4 mo recurrent oral candidiasis (thrush) + chronic diarrhea + failure to thrive (BW 4 kg < 3rd %ile) + persistent pneumonia × 2 episodes + chronic cough; ครอบครัว uncle (mother''s brother) died age 6 mo from infection

PE: cachectic, oral thrush, mild rales, hepatomegaly mild, NO PALPABLE THYMUS/LN/TONSILS
CXR: no thymic shadow + bilateral patchy infiltrate (consider PCP)

CBC: lymphocyte count 280 (severe lymphopenia — < 2,800 abnormal infant, < 500 critical), Hb normal, neutrophils normal
Flow cytometry: very low T cells, low B cells (variable), normal NK cells — suggests T-B-NK+ SCID = ADA deficiency OR XL-SCID T-B+NK-
SCID TREC newborn screening positive on review (low TREC)
NB: NBS for SCID standard in many states/Thailand emerging', '[{"label":"A","text":"Routine vaccinations"},{"label":"B","text":"Severe Combined Immunodeficiency (SCID, multiple genetic forms"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Steroid alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe Combined Immunodeficiency (SCID, multiple genetic forms — X-linked common gamma chain, ADA deficiency, others) — pediatric emergency, no immune system, fatal first year if untreated: admit + ISOLATION strict protective (HEPA filtered room, no live exposures); HCT transplantation (HEMATOPOIETIC STEM CELL TRANSPLANT) — DEFINITIVE treatment, BEST outcomes if performed EARLY (< 3.5 mo of age, no prior infection — > 90% survival; older + infected — declining survival); urgent referral to pediatric immunology + transplant center; HLA-matched sibling donor preferred (best outcomes); haploidentical parent or matched unrelated donor alternative; GENE THERAPY — approved/clinical trial for specific genotype — ADA deficiency (Strimvelis EU approved, US compassionate use), X-linked SCID gene therapy emerging; ENZYME REPLACEMENT — for ADA-SCID — PEG-ADA (Adagen, polyethylene glycol-conjugated bovine adenosine deaminase) IM weekly until HSCT or gene therapy possible; SUPPORTIVE pre-HSCT — PCP PROPHYLAXIS TMP-SMX 5 mg/kg/d trimethoprim 3×/wk (CRITICAL — Pneumocystis jirovecii pneumonia common in SCID and lethal); IVIG REPLACEMENT 400-600 mg/kg q3-4 wk IV (replace humoral immunity); FUNGAL prophylaxis fluconazole; AVOID ALL LIVE VACCINES — BCG, rotavirus, MMR, varicella (can cause disease in SCID); use INACTIVATED only; treat infections aggressively + early; AVOID NON-IRRADIATED BLOOD PRODUCTS (GVHD risk) — use IRRADIATED + CMV-negative + leukoreduced + filtered; nutritional support — TPN if FTT; family genetic counseling + screening relatives + prenatal/PGD; document allergy + immune status; transition to long-term immunology follow-up post-HSCT (chronic GVHD, immune reconstitution, fertility, secondary malignancy); important for newborn screening to identify before infection — improves outcome dramatically

---

SCID = pediatric immunology emergency. Recurrent severe infections + FTT + lymphopenia + absent thymus = work-up urgent. HSCT < 3.5 mo + uninfected = best outcome > 90%. ADA gene therapy. PCP prophylaxis + IVIG + isolation + IRRADIATED blood + NO live vaccines. NBS screening identifies early.', NULL,
  'hard', 'id', 'review',
  'pediatrics', 'clinical_decision', 'id', 'peds',
  'PIDTC SCID Protocols; Newborn Screening TREC; CIBMTR', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารกชายอายุ 4 mo recurrent oral candidiasis (thrush) + chronic diarrhea + failure to thrive (BW 4 kg < 3rd %ile) + persistent pneumonia × 2 episodes + chronic cough; ครอบครัว uncle (mother''s brother) died age 6 mo from infection

PE: cachectic, oral thrush, mild rales, hepatomegaly mild, NO PALPABLE THYMUS/LN/TONSILS
CXR: no thymic shadow + bilateral patchy infiltrate (consider PCP)

CBC: lymphocyte count 280 (severe lymphopenia — < 2,800 abnormal infant, < 500 critical), Hb normal, neutrophils normal
Flow cytometry: very low T cells, low B cells (variable), normal NK cells — suggests T-B-NK+ SCID = ADA deficiency OR XL-SCID T-B+NK-
SCID TREC newborn screening positive on review (low TREC)
NB: NBS for SCID standard in many states/Thailand emerging'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 4 ปี ก่อนหน้านี้ healthy เพิ่งเป็น viral gastroenteritis 1 wk ก่อน หลังจากนั้น lethargic + ตัวเหลือง + คลื่นไส้อาเจียน + ปวดท้อง 3 วัน + สับสน + asterixis + petechiae + เลือดออกตามไรฟัน ตอนนี้

V/S: HR 122, BP 98/62, RR 22, Temp 37.4°C, BW 16 kg
Gen: jaundice severe, drowsy, confused, asterixis, petechiae, mild hepatomegaly (small actually — shrinking liver = ominous), no ascites yet

Lab: ALT 4,820, AST 5,640 (very high), Bilirubin total 22 (direct 14), INR 4.8 (severe coagulopathy), glucose 38 (hypoglycemia), NH3 220, albumin 2.4, lactate 5.8, Cr 1.6
UA + urine drug screen + acetaminophen level pending; viral hepatitis serology pending; ceruloplasmin + urine copper pending (Wilson); autoimmune workup pending', '[{"label":"A","text":"Discharge home"},{"label":"B","text":"Pediatric Acute Liver Failure (PALF"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Steroid alone"},{"label":"E","text":"Wait — observe"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Acute Liver Failure (PALF — INR > 1.5 with encephalopathy OR > 2 without encephalopathy + no chronic liver disease): ICU + pediatric hepatology + transplant center referral IMMEDIATE; SUPPORTIVE — multiorgan management; HYPOGLYCEMIA — continuous D10W or D15W IV infusion + serial glucose q1-2 hr (severe risk + brain damage); CORRECT COAGULOPATHY — VITAMIN K IV 5-10 mg single dose (rule out vitamin K deficiency component); FFP/cryoprecipitate/PCC only for active bleeding or invasive procedures (treating INR alone obscures prognostication); manage CEREBRAL EDEMA + ICP — most feared complication encephalopathy grade 3-4 (head of bed 30°, normothermia, sedation propofol + fentanyl, intubation if grade 3+ encephalopathy + mannitol/hypertonic saline for ICP, target Na 145-155, consider ICP monitor selective, AVOID hyperventilation prolonged); NUTRITION — IV dextrose with limited amino acids ammonia management; rifaximin + lactulose ammonia (efficacy lower in pediatric ALF); manage AKI (CRRT) + sepsis (broad-spectrum antibiotic — ceftriaxone with cultures); FLUID — careful, avoid hyponatremia (cerebral edema); IDENTIFY CAUSE — acetaminophen (use NAC EMPIRICALLY in PALF of UNKNOWN cause — proven benefit even non-APAP), drug-induced (review all meds), viral hepatitis (HAV/HBV/HCV/HEV serology + EBV/CMV/HSV/parvovirus PCR), autoimmune (ANA, SMA, LKM1), Wilson disease (ceruloplasmin, urine copper, slit-lamp KF rings, ATP7B testing — adolescent), metabolic (galactosemia, tyrosinemia, mitochondrial — especially infants), Reye (aspirin Hx), HLH (ferritin extreme); CONSIDER PALF Registry; LIVER TRANSPLANT EVALUATION URGENT — KING''S COLLEGE CRITERIA in peds for transplant listing (etiology-specific or combination of pH < 7.3 / INR > 6.5 / Cr > 3.4 + grade III/IV encephalopathy); PALF prognosis 60% spontaneous recovery, 25-30% transplant, 10-15% death — depends on cause + severity + age; family education + intense psychosocial support

---

Pediatric Acute Liver Failure = ICU + transplant center. Manage hypoglycemia + coagulopathy + cerebral edema (#1 fatal). Empiric NAC for unknown cause (proven benefit non-APAP too). Identify cause (extensive workup). King''s College criteria + PALF Registry guide transplant. Mortality high without transplant.', NULL,
  'hard', 'gi', 'review',
  'pediatrics', 'clinical_decision', 'gi', 'peds',
  'NASPGHAN PALF Registry; AASLD Pediatric Liver', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 4 ปี ก่อนหน้านี้ healthy เพิ่งเป็น viral gastroenteritis 1 wk ก่อน หลังจากนั้น lethargic + ตัวเหลือง + คลื่นไส้อาเจียน + ปวดท้อง 3 วัน + สับสน + asterixis + petechiae + เลือดออกตามไรฟัน ตอนนี้

V/S: HR 122, BP 98/62, RR 22, Temp 37.4°C, BW 16 kg
Gen: jaundice severe, drowsy, confused, asterixis, petechiae, mild hepatomegaly (small actually — shrinking liver = ominous), no ascites yet

Lab: ALT 4,820, AST 5,640 (very high), Bilirubin total 22 (direct 14), INR 4.8 (severe coagulopathy), glucose 38 (hypoglycemia), NH3 220, albumin 2.4, lactate 5.8, Cr 1.6
UA + urine drug screen + acetaminophen level pending; viral hepatitis serology pending; ceruloplasmin + urine copper pending (Wilson); autoimmune workup pending'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 12 ปี known Kawasaki disease 5 ปีก่อนมี giant coronary aneurysms (LAD + RCA) ตอนนี้กำลังเล่นกีฬาเริ่มเจ็บอกรุนแรง + คลื่นไส้ + sweating + เริ่ม dyspnea 1 ชม. ก่อน — ECG ED ที่มา

V/S: HR 102, BP 92/58, RR 28, SpO2 96%, BW 36 kg
Gen: distress, diaphoretic, mild distress

ECG: anterior ST elevation V1-V4 + Q waves emerging; cardiac enzymes — troponin 5.6 (high), CK-MB elevated
Echo: anterior wall hypokinesis (new) + visible giant LAD aneurysm + thrombus seen + EF 38%
Diagnosis: STEMI in adolescent with Kawasaki coronary aneurysm thrombosis', '[{"label":"A","text":"Discharge home"},{"label":"B","text":"Pediatric STEMI (rare, mostly secondary to Kawasaki coronary aneurysm thrombosis, also congenital anomalies, drug-induced, hypercoagulable, vasculitis)"},{"label":"C","text":"Antibiotic"},{"label":"D","text":"Antiviral"},{"label":"E","text":"Wait — observe"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric STEMI (rare, mostly secondary to Kawasaki coronary aneurysm thrombosis, also congenital anomalies, drug-induced, hypercoagulable, vasculitis): immediate cardiology + interventional cardiology + ICU; SUPPORTIVE — oxygen titrated to SpO2 ≥ 94%, IV access + monitoring, MONA-B adapted (Morphine, Oxygen, Nitrate, Aspirin, Beta-blocker but cautious in peds): ASPIRIN 81-162 mg PO chewed STAT (anti-platelet) + clopidogrel/ticagrelor loading; ANTICOAGULATION — heparin (UFH or LMWH) + maintain therapeutic; nitrate if BP allows; beta-blocker (metoprolol) if stable; pain management (morphine — caution in non-evidence pediatric); STATIN early; ESC/AHA: PRIMARY PCI (preferred reperfusion if available within 90-120 min) — pediatric coronary PCI by experienced interventional pediatric cardiologist (adult-trained, specialized centers); ALTERNATIVE thrombolysis (alteplase IV) if PCI not available within 120 min, no contraindication — pediatric data limited, extrapolated from adult; KD-related thrombosis — combined antiplatelet + anticoagulation often used long-term; CABG considered if multivessel or complex anatomy; ICU monitoring + arrhythmia management (ventricular arrhythmia post-MI), congestive heart failure management (inotrope, diuretic, fluid balance); SECONDARY PREVENTION — long-term aspirin + clopidogrel/warfarin (DAPT or triple if anticoagulation, balance bleeding) + beta-blocker + ACEI + statin + cardiac rehabilitation; LIFESTYLE — avoid contact sports (per AHA Kawasaki long-term), regular cardiology follow-up, serial echo + cardiac MRI/stress test; psychosocial support; transition adult; KD-with-giant aneurysm = highest cardiac risk subset — IVIG + ASA acute KD reduce aneurysm 25→5% but giant aneurysms persist + carry lifelong risk (MI, sudden death); coronary CTA/MRI angiogram serial monitoring; gene therapy + organ transplant for end-stage HF; long-term mortality elevated

---

Pediatric STEMI = rare. KD-coronary aneurysm thrombosis = leading cause adolescent MI. Primary PCI preferred reperfusion (within 90-120 min) by experienced peds interventional cardiologist. DAPT + anticoagulation + supportive. Lifelong KD coronary surveillance. Avoid contact sports. Transition adult cardiology.', NULL,
  'hard', 'cardiovascular', 'review',
  'pediatrics', 'clinical_decision', 'cardiovascular', 'peds',
  'AHA Kawasaki Long-term Management 2017; ESC STEMI Guideline (Adult)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 12 ปี known Kawasaki disease 5 ปีก่อนมี giant coronary aneurysms (LAD + RCA) ตอนนี้กำลังเล่นกีฬาเริ่มเจ็บอกรุนแรง + คลื่นไส้ + sweating + เริ่ม dyspnea 1 ชม. ก่อน — ECG ED ที่มา

V/S: HR 102, BP 92/58, RR 28, SpO2 96%, BW 36 kg
Gen: distress, diaphoretic, mild distress

ECG: anterior ST elevation V1-V4 + Q waves emerging; cardiac enzymes — troponin 5.6 (high), CK-MB elevated
Echo: anterior wall hypokinesis (new) + visible giant LAD aneurysm + thrombus seen + EF 38%
Diagnosis: STEMI in adolescent with Kawasaki coronary aneurysm thrombosis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 9 ปี BW 30 kg ก่อนหน้านี้ 2 ชม. มี anaphylaxis severe จากการกิน peanut — IM Epi 0.15 mg ที่ ED → resolved fully within 30 min + observed 2 ชม. asymptomatic ขณะ ED ไม่มี wheeze, BP normal

ณ moment ที่ family กำลังจะกลับบ้าน — เด็กกลับมา wheeze severe + facial swelling + urticaria generalized + BP 88/52 + เหนื่อย anaphylactic shock again', '[{"label":"A","text":"Wait — observe"},{"label":"B","text":"Biphasic Anaphylaxis recurrence (5-20% incidence, typically 4-12 hr after initial reaction, occurs even with adequate initial treatment)"},{"label":"C","text":"Discharge home immediately"},{"label":"D","text":"Antibiotic"},{"label":"E","text":"Antiviral"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Biphasic Anaphylaxis recurrence (5-20% incidence, typically 4-12 hr after initial reaction, occurs even with adequate initial treatment): IMMEDIATE IM Epinephrine 0.01 mg/kg (0.3 mg in 30 kg child) lateral thigh REPEAT q5-15 min as needed (3-4 doses possible); IV access established + crystalloid bolus 20 mL/kg if hypotension; supplemental O2; supine position (Trendelenburg if hypotension); BRONCHODILATOR albuterol nebulizer for wheeze; ANTIHISTAMINE H1 (diphenhydramine 1 mg/kg IV) + H2 (ranitidine/famotidine) — secondary, NOT replacing epi; CORTICOSTEROID (methylprednisolone 1-2 mg/kg IV) — once thought to prevent biphasic but RECENT EVIDENCE shows steroid does NOT reliably prevent biphasic — still given but not ''lifesaving''; admit + monitor minimum 6-24 hr post-resolution (longer observation for high-risk: severe initial, multiple doses epinephrine, asthmatic, history of biphasic); ICU if respiratory compromise/multidose epi needed/hypotension; KNOW RISK FACTORS FOR BIPHASIC — multiple doses initial epinephrine, delayed initial epinephrine administration, asthma, severe initial reaction, broad-area cutaneous, GI/respiratory predominate symptoms, oral allergen (vs IV/sting); discharge planning — written EMERGENCY ACTION PLAN, prescribe TWO EpiPen Jr 0.15 mg (< 25 kg) OR EpiPen 0.3 mg (≥ 25 kg) — carry both at all times (school + activities), instruct USE FOR ANY anaphylaxis suspicion (don''t wait), thigh IM, after EpiPen use → call EMS regardless of improvement (biphasic risk); ALLERGIST referral within 1-4 wk; identify trigger + avoidance education; consider oral immunotherapy long-term (Palforzia FDA-approved); school 504 plan; medical alert bracelet; family + child education + practice + emotional support; food allergy registries; emerging — omalizumab adjunct (recent FDA approval 2024 food allergy); long-term: persistent allergy 80% peanut (vs 50% egg/milk)

---

Biphasic anaphylaxis = recurrent reaction without re-exposure (5-20%, typically 4-12 hr). Risk factors include severe initial, multi-dose epi, delayed treatment, asthma. Same management as initial. Observation 6-24 hr (longer high-risk). Steroid doesn''t reliably prevent. Two EpiPen + allergist + action plan.', NULL,
  'hard', 'id', 'review',
  'pediatrics', 'clinical_decision', 'id', 'peds',
  'WAO Anaphylaxis Guidelines 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 9 ปี BW 30 kg ก่อนหน้านี้ 2 ชม. มี anaphylaxis severe จากการกิน peanut — IM Epi 0.15 mg ที่ ED → resolved fully within 30 min + observed 2 ชม. asymptomatic ขณะ ED ไม่มี wheeze, BP normal

ณ moment ที่ family กำลังจะกลับบ้าน — เด็กกลับมา wheeze severe + facial swelling + urticaria generalized + BP 88/52 + เหนื่อย anaphylactic shock again'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 13 ปี BW 38 kg ตื่นเช้ามาด้วย ปวดอัณฑะข้างขวารุนแรง + คลื่นไส้อาเจียน 2 ชม ก่อน — ก่อนหน้านี้ไม่มี trauma, no STI Hx, sexually inactive

V/S: HR 102, BP 110/72, BW 38 kg
PE: right scrotal swelling + tender + high-riding testis + horizontal lie + absent cremasteric reflex + diffuse tenderness; left testis normal; no signs UTI/STI; abdomen non-tender, no inguinal hernia

US scrotum + Doppler: decreased blood flow right testicle + ''whirlpool sign'' spermatic cord = testicular torsion (right side)
CBC + UA normal
Duration 2 hr from symptom onset (early)', '[{"label":"A","text":"Observation"},{"label":"B","text":"Testicular Torsion (urological emergency, time-critical for testicle salvage"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Aspirin"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Testicular Torsion (urological emergency, time-critical for testicle salvage — 90% salvage if < 6 hr, 50% < 12 hr, < 10% > 24 hr): pediatric urology IMMEDIATE consultation + OR booking; do not delay surgery for imaging if clinical Dx strong (US helpful but not mandatory in clear cases — saves time); PREPARE FOR OR — NPO, IV fluid, analgesia (IV morphine 0.05-0.1 mg/kg), antiemetic; SCROTAL EXPLORATION + DETORSION + BILATERAL ORCHIOPEXY — emergent surgical exploration via scrotal/inguinal incision; detort affected testicle (typically rotated medially — ''open book'' technique) + assess viability (color, perfusion, ICG/Doppler intra-op) — if viable → orchiopexy fixation (3 points, non-absorbable suture or scrotal sac fixation); if non-viable necrotic → ORCHIECTOMY; CONTRALATERAL orchiopexy MANDATORY (bell-clapper deformity often bilateral congenital anatomy — 70-80% — fix contralateral to prevent future torsion); MANUAL DETORSION attempted in ED — bridge if surgery delay (rotate testicle laterally ''open book'' from medial to lateral 540-720°, success unpredictable, MUST still go to OR for fixation); follow-up — testicular self-exam + counsel future torsion contralateral 1-2%; long-term — fertility may be affected even after successful detorsion (controversial — antibody mechanism), counsel adolescent + future reproductive plans; psychosocial support — orchiectomy + prosthesis option for cosmetic + psychological; education — testicular pain = urology emergency, prompt evaluation; DIFFERENTIAL DDx of acute scrotum — torsion of appendix testis (less urgent, conservative), epididymitis (older boys, STI in adolescent), hernia, hydrocele, trauma, hemorrhage, tumor, Henoch-Schonlein scrotum — but DO NOT delay if torsion suspected!

---

Testicular torsion = time-critical urological emergency. < 6 hr = 90% salvage. Clinical Dx + urgent surgical exploration (do not delay for imaging). Bilateral orchiopexy mandatory (anatomical predisposition). Manual detorsion bridge. Long-term fertility concern + contralateral risk monitoring.', NULL,
  'hard', 'renal_gu', 'review',
  'pediatrics', 'clinical_decision', 'renal_gu', 'peds',
  'AUA Testicular Torsion Guidelines; Pediatric Urology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 13 ปี BW 38 kg ตื่นเช้ามาด้วย ปวดอัณฑะข้างขวารุนแรง + คลื่นไส้อาเจียน 2 ชม ก่อน — ก่อนหน้านี้ไม่มี trauma, no STI Hx, sexually inactive

V/S: HR 102, BP 110/72, BW 38 kg
PE: right scrotal swelling + tender + high-riding testis + horizontal lie + absent cremasteric reflex + diffuse tenderness; left testis normal; no signs UTI/STI; abdomen non-tender, no inguinal hernia

US scrotum + Doppler: decreased blood flow right testicle + ''whirlpool sign'' spermatic cord = testicular torsion (right side)
CBC + UA normal
Duration 2 hr from symptom onset (early)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 16 ปี BW 65 kg ออกกำลังกายหนักในที่ร้อน (football practice in heat, dehydrated) 6 ชม + เริ่มปวดกล้ามเนื้อรุนแรง + ปัสสาวะสีโคล่า dark + ปริมาณน้อย + คลื่นไส้ + อ่อนเพลีย

V/S: HR 122, BP 132/82, Temp 38.0°C, BW 65 kg (มี dehydration)
Gen: alert, generalized muscle tenderness + cramping, dark cola-colored urine, oliguric

Lab: CK 84,500 (very high — > 5× normal), myoglobinuria + (urine dipstick blood + but no RBC microscopy), K 6.2 (high), P 8.2 (high), Ca 7.4 (low), uric acid 14, lactate 4.8, AGMA pH 7.28
Cr 2.8 (baseline 0.9 → AKI Stage 3), BUN 42; UA: ''blood'' +++ but no RBC + myoglobin positive on dipstick + granular casts', '[{"label":"A","text":"Outpatient PO hydration"},{"label":"B","text":"Severe Rhabdomyolysis (CK > 5× normal, often > 5,000) with AKI + Hyperkalemia + Electrolyte derangement"},{"label":"C","text":"Diuretic alone"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe Rhabdomyolysis (CK > 5× normal, often > 5,000) with AKI + Hyperkalemia + Electrolyte derangement: admit + ICU monitoring; AGGRESSIVE IV FLUID RESUSCITATION — primary intervention — isotonic crystalloid 1-2 L bolus then continuous infusion 200-500 mL/hr (high rate to target UO ≥ 1-2 mL/kg/hr to flush myoglobin + maintain perfusion) — most important intervention; ALKALINIZATION of urine — sodium bicarbonate IV continuous infusion target urine pH > 6.5 (controversial mixed evidence, may help reduce myoglobin precipitation in tubules but caution metabolic alkalosis + hypocalcemia worsening tetany) — recent guidelines selective use; MANNITOL (osmotic diuresis) — controversial, no clear benefit, AVOID in oliguric AKI (can worsen); MANAGE HYPERKALEMIA — calcium gluconate cardiac protection if ECG changes, insulin + glucose, albuterol, sodium bicarb (with caution Ca), sodium polystyrene resin selective, DIALYSIS if refractory; manage hyperphosphatemia (binders selectively, but Ca worsening); manage hypocalcemia (only if symptomatic — treating before resolution can worsen Ca-P precipitation); HEMODIALYSIS / CRRT — indications: AKI with severe hyperkalemia refractory, severe acidosis, uremia, fluid overload, severe hyperphosphatemia + symptomatic hypocalcemia — myoglobin clearance by dialysis controversial (large molecule, removal limited); IDENTIFY + REMOVE TRIGGER — exertional (most common adolescent — heat, exercise), trauma/crush, drug-induced (statin, fibrate, cocaine, MDMA, alcohol), infection, electrolyte derangement, genetic (McArdle, CPT II, malignant hyperthermia susceptibility — workup if recurrent), neuroleptic malignant syndrome, viral myositis; SYMPTOM management — analgesia, antiemetic, monitor compartment syndrome (limb pain + tense + neurovascular changes = surgical fasciotomy); REST + activity restriction × 2-4 wk; education — heat acclimatization, hydration, avoid hard exercise without conditioning, sports clearance gradual; nephrology + cardiology + neurology follow-up; chronic kidney disease risk monitoring; recurrent → workup metabolic muscle disease

---

Rhabdomyolysis = muscle injury → myoglobin → AKI + hyperK + hyperP + hypoCa + acidosis. Adolescent exertional heat-related common. Aggressive IV fluid + electrolyte management + dialysis selective. Alkalinization controversial. Compartment syndrome watch. Workup recurrent genetic. Long-term CKD risk monitoring.', NULL,
  'hard', 'renal_gu', 'review',
  'pediatrics', 'clinical_decision', 'renal_gu', 'peds',
  'Pediatric Critical Care; KDIGO AKI', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 16 ปี BW 65 kg ออกกำลังกายหนักในที่ร้อน (football practice in heat, dehydrated) 6 ชม + เริ่มปวดกล้ามเนื้อรุนแรง + ปัสสาวะสีโคล่า dark + ปริมาณน้อย + คลื่นไส้ + อ่อนเพลีย

V/S: HR 122, BP 132/82, Temp 38.0°C, BW 65 kg (มี dehydration)
Gen: alert, generalized muscle tenderness + cramping, dark cola-colored urine, oliguric

Lab: CK 84,500 (very high — > 5× normal), myoglobinuria + (urine dipstick blood + but no RBC microscopy), K 6.2 (high), P 8.2 (high), Ca 7.4 (low), uric acid 14, lactate 4.8, AGMA pH 7.28
Cr 2.8 (baseline 0.9 → AKI Stage 3), BUN 42; UA: ''blood'' +++ but no RBC + myoglobin positive on dipstick + granular casts'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 12 ปี recurrent gross hematuria episodes — เป็น 1-3 d ระหว่าง URI episodes, ระหว่าง episodes UA — persistent microscopic hematuria + mild proteinuria; ตอนนี้ URI ครั้งที่ 4 ใน 1 ปี + gross hematuria again + BP rising 138/86

Family: father had similar in childhood — eventually ESRD age 40
PE: BP 138/86, BW 36 kg, no edema currently, mild flank tenderness

Lab: Hb normal, Plt normal, complement NORMAL (excludes lupus, PSGN, MPGN), anti-streptolysin normal
UP/UCr 0.8, Cr 0.8 (baseline), no other autoimmune workup positive
Renal biopsy: mesangial IgA + C3 deposits + mesangial proliferation = IgA Nephropathy (Berger disease) — most common primary GN worldwide', '[{"label":"A","text":"No treatment"},{"label":"B","text":"IgA Nephropathy (Berger disease, most common primary glomerular disease worldwide, autosomal dominant with variable expression"},{"label":"C","text":"Steroid pulse routine all"},{"label":"D","text":"Discharge no treatment"},{"label":"E","text":"Antibiotic chronic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** IgA Nephropathy (Berger disease, most common primary glomerular disease worldwide, autosomal dominant with variable expression — long-term progression to ESRD 20-40% within 20 yr without treatment): pediatric nephrology follow-up; RISK STRATIFICATION (Oxford-MEST-C classification + clinical factors) for progression risk — proteinuria > 0.5-1 g/d, HT, reduced GFR, severe pathology features (cellular crescents); STANDARD CARE for ALL — BP control (target < 90th percentile/130/80), low salt diet, RAAS BLOCKADE with ACEI (lisinopril, enalapril) or ARB (losartan) titrated to maximum tolerated dose to reduce proteinuria + slow progression (first-line for all with proteinuria); FOR HIGH-RISK PROGRESSION (persistent proteinuria > 1 g/d despite RAAS, reduced GFR, severe biopsy) — additional immunosuppression: corticosteroid 6 mo regimen (Pozzi protocol or STOP-IgAN — controversial mixed evidence in modern era, KDIGO 2021 recommends only if persistent proteinuria + supportive care optimized); MMF or cyclophosphamide for severe; SGLT2 INHIBITORS (dapagliflozin) — newer evidence reduces progression in IgA nephropathy + other CKD per DAPA-CKD/EMPA-KIDNEY (pediatric data emerging); TARGETED RELEASE BUDESONIDE (Nefecon — newer FDA-approved 2023 for IgA nephropathy targeting gut Peyer''s patches where pathogenic IgA originates) — adult, pediatric trials emerging; AVOID nephrotoxin (NSAID); manage CV risk (BP + lipid + lifestyle); MONITORING — BP + UA + Cr + UP/UCr q3-6 mo; long-term — many progress, some stable, individual variation; family history + screen relatives (familial component); ADULT — kidney transplant possible (IgA recurrence post-transplant 30-50% but slow + manageable); GENETIC counseling familial cases; emerging therapy — IgA-specific therapies in trial (sparsentan endothelin antagonist)

---

IgA nephropathy = most common primary GN worldwide. Episodic gross hematuria post-URI + persistent microscopic. Biopsy mesangial IgA. Long-term progression risk. Supportive care + ACEI/ARB BP/proteinuria control + risk-stratified immunosuppression. SGLT2i + targeted budesonide emerging. Family screen.', NULL,
  'medium', 'renal_gu', 'review',
  'pediatrics', 'clinical_decision', 'renal_gu', 'peds',
  'KDIGO Glomerular Diseases Guideline 2021; STOP-IgAN + TESTING trials', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 12 ปี recurrent gross hematuria episodes — เป็น 1-3 d ระหว่าง URI episodes, ระหว่าง episodes UA — persistent microscopic hematuria + mild proteinuria; ตอนนี้ URI ครั้งที่ 4 ใน 1 ปี + gross hematuria again + BP rising 138/86

Family: father had similar in childhood — eventually ESRD age 40
PE: BP 138/86, BW 36 kg, no edema currently, mild flank tenderness

Lab: Hb normal, Plt normal, complement NORMAL (excludes lupus, PSGN, MPGN), anti-streptolysin normal
UP/UCr 0.8, Cr 0.8 (baseline), no other autoimmune workup positive
Renal biopsy: mesangial IgA + C3 deposits + mesangial proliferation = IgA Nephropathy (Berger disease) — most common primary GN worldwide'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารก term GA 38 wk BW 2,400 g (small) คลอดที่บ้าน ผู้ทำคลอดไม่ได้ขยายส่งโรงพยาบาลทันที 4 ชม. มาถึง ED มา ED ตอนนี้ลำตัวเย็น + ซึม + breathing shallow + bradycardia + ไม่ดูดนม

V/S: HR 88 (bradycardia for newborn), RR 32, SpO2 88% room air, Temp axillary 32.4°C (severe hypothermia, normal 36.5-37.5°C, mild 32-36, moderate < 32, severe < 28)
Gen: lethargic, cold to touch, mottled, weak pulses, sclerema (waxy stiff skin from fat)

Lab: glucose 28 (hypoglycemia), Hb 17 (polycythemia common cold-stressed), Plt low 80,000, lactate elevated, mild metabolic acidosis pH 7.25', '[{"label":"A","text":"Active rapid rewarming with very hot bottle"},{"label":"B","text":"Severe Neonatal Hypothermia + Cold Stress Syndrome with multiple complications (sclerema, hypoglycemia, polycythemia, metabolic acidosis, possible DIC + sepsis)"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Antibiotic alone without rewarming"},{"label":"E","text":"Antiviral"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe Neonatal Hypothermia + Cold Stress Syndrome with multiple complications (sclerema, hypoglycemia, polycythemia, metabolic acidosis, possible DIC + sepsis): admit NICU + multidisciplinary; ACTIVE EXTERNAL REWARMING gentle — 0.5-1°C/hr (NOT > 1°C/hr — avoid rebound hypotension/arrhythmia) — radiant warmer/incubator + skin-to-skin care with mother + warm dry blanket + warm humidified O2 + warmed IV fluid 37°C + plastic wrap reduce evaporation + cover head (large surface area newborn head); INVASIVE rewarming for very severe — warm peritoneal lavage, hemodialysis warmed circuit selected — rarely needed neonates if not arrested; CORRECT HYPOGLYCEMIA — D10W 2 mL/kg IV bolus + continuous infusion at GIR 6-8 mg/kg/min (cold stress depletes glucose); FLUID RESUSCITATION — careful — cold-stressed infants may have shock + acidosis; antibiotic empiric (ampicillin + gentamicin) cover sepsis — cold stress + sepsis often coexist (hypothermia common sepsis sign); correct ACIDOSIS — usually self-correct with rewarming + perfusion (avoid bicarb routine); correct COAGULOPATHY — vitamin K + monitor for DIC (cold + sepsis); manage POLYCYTHEMIA — partial exchange transfusion if Hct > 65 + symptomatic; cardiovascular support — vasopressor if shock persists despite rewarming + fluid + correction; SCLEREMA = ominous sign (severe disease + high mortality); MONITOR continuously — temp q5-15 min during rewarming + glucose q hourly + electrolytes + cardiac/respiratory; identify CAUSE — home birth without warmth, sepsis, hypothyroidism (delayed cord clamping or delivery in cold environment most common), hypothalamic injury, narcotic exposure; long-term — neurodevelopmental follow-up + cold-stress sequelae; FAMILY/system education + improve home delivery practices (cocoon + skin-to-skin + delayed bath + heated room) + Thai PHC programs to support home delivery with warmth chain (WHO/UNICEF Warm Chain 10 steps); psychosocial support family + counseling

---

Severe neonatal hypothermia = emergency, multiple complications (hypoglycemia, acidosis, sepsis, DIC, polycythemia, sclerema). Gradual rewarming 0.5-1°C/hr + correct hypoglycemia + sepsis coverage + supportive. Sclerema ominous. WHO Warm Chain prevention. Address home delivery practices.', NULL,
  'hard', 'endocrine_metabolic', 'review',
  'pediatrics', 'clinical_decision', 'endocrine_metabolic', 'peds',
  'WHO/UNICEF Warm Chain; AAP NRP Hypothermia', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'ทารก term GA 38 wk BW 2,400 g (small) คลอดที่บ้าน ผู้ทำคลอดไม่ได้ขยายส่งโรงพยาบาลทันที 4 ชม. มาถึง ED มา ED ตอนนี้ลำตัวเย็น + ซึม + breathing shallow + bradycardia + ไม่ดูดนม

V/S: HR 88 (bradycardia for newborn), RR 32, SpO2 88% room air, Temp axillary 32.4°C (severe hypothermia, normal 36.5-37.5°C, mild 32-36, moderate < 32, severe < 28)
Gen: lethargic, cold to touch, mottled, weak pulses, sclerema (waxy stiff skin from fat)

Lab: glucose 28 (hypoglycemia), Hb 17 (polycythemia common cold-stressed), Plt low 80,000, lactate elevated, mild metabolic acidosis pH 7.25'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 6 ปี BW 22 kg admitted ICU with severe community-acquired pneumonia (Spn + Influenza A coinfection) + sepsis 48 ชม + progressive respiratory failure → intubated + ventilated → ARDS developing

V/S: HR 142, BP 92/58 on epinephrine, intubated FiO2 0.8 PEEP 8 + ventilated
Gen: sedated + intubated, ARDS picture

Lab: pH 7.28, PaO2 62 → P/F 78 (severe ARDS PARDS, < 100), CXR: bilateral diffuse opacities, normal cardiac silhouette, no atelectasis explanation alone
Lactate 4.8, on antibiotic + antiviral + supportive', '[{"label":"A","text":"High tidal volume + low PEEP"},{"label":"B","text":"Pediatric ARDS (PARDS, PALICC criteria"},{"label":"C","text":"High tidal volume aggressive"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Stop all support"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric ARDS (PARDS, PALICC criteria — non-cardiogenic bilateral infiltrate + hypoxemia + acute onset) severe (P/F < 100 or OI > 16) — lung-protective ventilation + supportive: VENTILATION strategy — LOW TIDAL VOLUME 5-6 mL/kg predicted body weight (lung-protective, prevent volutrauma + barotrauma); PERMISSIVE HYPERCAPNIA — accept PaCO2 60-80 to allow lower TV/PEEP unless brain injury/PHT; PEEP TITRATION + recruitment (lower PEEP for less severe, higher PEEP for severe to recruit + maintain) per PEEP/FiO2 table or esophageal pressure-guided; PLATEAU PRESSURE < 28-32 cmH2O target (limit transpulmonary pressure); FiO2 minimum to maintain SpO2 88-92% acceptable (avoid hyperoxia); MONITOR oxygenation — P/F ratio, OI (oxygenation index for peds), SpO2; CONSERVATIVE FLUID balance (avoid net positive) — diuretic if hemodynamically stable + ARDS — FACTT-Lung guides; prone positioning — improves oxygenation in moderate-severe PARDS (extrapolated adult, peds emerging evidence positive, 12-16 hr prone session if tolerated); NEUROMUSCULAR BLOCKADE (rocuronium, cisatracurium) — controversial routine, may improve oxygenation in severe ARDS (ACURASYS adult); recruitment maneuvers selective; SEDATION protocol — interruption + daily SAT/SBT; oxygen alternatives — HFOV (high-frequency oscillatory ventilation) — older protocol, recent OSCILLATE/OSCAR negative in adults, peds uncertain — selective use refractory severe; iNO inhaled nitric oxide — PARDS with pulmonary HT, transient improvement, not survival benefit; ECMO — refractory severe PARDS (P/F < 80 on max settings, OI > 35-40) — transfer ECMO center; SUPPORTIVE — sepsis source control (ID + antibiotic + antiviral as identified — ongoing here), hemodynamic support (vasopressor, fluid balance), nutrition early enteral, glucose control, stress ulcer prophylaxis, DVT prophylaxis (per peds CHEST guidelines age-appropriate), prevent VAP (HOB 30, oral care, daily SBT, weaning); FAMILY-CENTERED communication + psychosocial; outcome — pediatric ARDS mortality 20-30% (better than adult); long-term — pulmonary function recovery + neurocognitive long-term follow-up, post-ICU PTSD + depression families + child

---

Pediatric ARDS = PALICC criteria. Lung-protective ventilation (low TV 5-6 mL/kg, PEEP titrated, permissive hypercapnia, plateau < 28-32). Prone positioning moderate-severe. Conservative fluid. ECMO refractory. Treat underlying. Long-term pulmonary + neurocognitive follow-up. Family-centered.', NULL,
  'hard', 'respiratory', 'review',
  'pediatrics', 'clinical_decision', 'respiratory', 'peds',
  'PALICC 2 PARDS Guidelines 2023', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 6 ปี BW 22 kg admitted ICU with severe community-acquired pneumonia (Spn + Influenza A coinfection) + sepsis 48 ชม + progressive respiratory failure → intubated + ventilated → ARDS developing

V/S: HR 142, BP 92/58 on epinephrine, intubated FiO2 0.8 PEEP 8 + ventilated
Gen: sedated + intubated, ARDS picture

Lab: pH 7.28, PaO2 62 → P/F 78 (severe ARDS PARDS, < 100), CXR: bilateral diffuse opacities, normal cardiac silhouette, no atelectasis explanation alone
Lactate 4.8, on antibiotic + antiviral + supportive'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 6 ปี เริ่ม URI + sinusitis 4 d ก่อน + ตอนนี้ปวดตา + บวมแดงรอบตา left + ตามองเห็นเริ่มจะลด + ตาเคลื่อนไหวเจ็บ + diplopia + ตาโปนเล็กน้อย + ไข้ 39.0°C

V/S: HR 122, BP 102/68, Temp 39.0°C, BW 22 kg
PE: marked periorbital erythema + edema + warm + tender, mild proptosis left, restricted EOM all directions painful, decreased visual acuity 20/40 → 20/100, mild RAPD, conjunctival injection; no Roth spots, no obvious sinusitis discharge externally but CT might show

CBC: WBC 22,000 (left shift), CRP 285
CT orbits + sinuses: opacification ethmoid sinus + subperiosteal abscess medial orbit + lateralization globe = orbital cellulitis with abscess + ethmoid sinusitis source', '[{"label":"A","text":"Outpatient oral antibiotic"},{"label":"B","text":"Orbital Cellulitis with Subperiosteal Abscess (POST-septal infection"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Antiviral alone"},{"label":"E","text":"Antifungal alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Orbital Cellulitis with Subperiosteal Abscess (POST-septal infection — emergency, vision-threatening, life-threatening intracranial spread): immediate admit + IV antibiotic + ophthalmology + ENT + (neurosurgery if intracranial concern); SUPPORTIVE — bed rest + head elevation + warm compress + analgesia + antipyretic; EMPIRIC IV ANTIBIOTIC broad-spectrum cover (Strep pneumo, Strep + GAS, Staph aureus including MRSA, H flu, anaerobes from sinus, gram-negative) — Vancomycin (60 mg/kg/d ÷ q6h) + Ceftriaxone (50-75 mg/kg/d) + Metronidazole (30 mg/kg/d ÷ q6h) for anaerobic coverage; alternative pip-tazo + vanc; duration IV 1-2 wk → oral × 2-4 wk total; SURGICAL DRAINAGE — INDICATIONS for subperiosteal abscess: > 1 cm size, optic neuropathy, complete ophthalmoplegia, large abscess, frontal involvement, no improvement after 24-48 hr IV antibiotic, intracranial extension, immunocompromised, age > 9 yr (less likely respond to medical alone) — ENT/oculoplastic surgery for endoscopic sinus surgery + drainage of orbital abscess + culture; medical management trial for small abscess + no optic compromise + < 9 yr — observe 24-48 hr + escalate if no improvement; OPHTHALMOLOGY SERIAL exams — visual acuity, color vision (early optic nerve compromise), pupil reactivity (RAPD = optic nerve), proptosis measure, ROM; CT/MRI sinus + orbit + brain (rule out cavernous sinus thrombosis, intracranial extension — meningitis, brain abscess, cavernous sinus thrombosis — CRITICAL detection); MEDICAL emergency for vision (optic nerve compression irreversible) + LIFE-threatening intracranial complications; SUPPORTIVE — anticoagulation considered if cavernous sinus thrombosis (controversial), corticosteroid AVOID routine (may worsen infection unless adjunct in late phase); culture + sensitivity guided; topical antibiotic eye drop if conjunctival; long-term — recurrence if persistent sinusitis, optic nerve dysfunction, scarring; pediatric ID + ophtho + ENT follow-up + image; CHANDLER classification of orbital infection — preseptal (I) < subperiosteal abscess (III) < orbital abscess (IV) < cavernous sinus thrombosis (V); preseptal cellulitis (anterior to orbital septum) = milder, often outpatient oral antibiotic

---

Orbital cellulitis = post-septal, vision + life-threatening, sinus source. Distinguish from preseptal (anterior to septum, mild). Chandler classification I-V. IV broad-spectrum (vanc + ceftriaxone + metronidazole) + surgical drainage selected. Watch optic nerve + intracranial complications. ENT + ophtho + ID coordinated.', NULL,
  'hard', 'id', 'review',
  'pediatrics', 'clinical_decision', 'id', 'peds',
  'AAO Orbital Cellulitis; AAP Sinusitis Complications', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 6 ปี เริ่ม URI + sinusitis 4 d ก่อน + ตอนนี้ปวดตา + บวมแดงรอบตา left + ตามองเห็นเริ่มจะลด + ตาเคลื่อนไหวเจ็บ + diplopia + ตาโปนเล็กน้อย + ไข้ 39.0°C

V/S: HR 122, BP 102/68, Temp 39.0°C, BW 22 kg
PE: marked periorbital erythema + edema + warm + tender, mild proptosis left, restricted EOM all directions painful, decreased visual acuity 20/40 → 20/100, mild RAPD, conjunctival injection; no Roth spots, no obvious sinusitis discharge externally but CT might show

CBC: WBC 22,000 (left shift), CRP 285
CT orbits + sinuses: opacification ethmoid sinus + subperiosteal abscess medial orbit + lateralization globe = orbital cellulitis with abscess + ethmoid sinusitis source'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 14 ปี BW 60 kg admit hospital สำหรับ Crohn disease flare 7 d + central line femoral + on TPN + immobilized + ใช้ COC mother + bed-bound largely. วันนี้เริ่มหอบเหนื่อยฉับพลัน + เจ็บอกที่เพิ่ม inspiration + ใจสั่น + bilateral leg swelling left worse + tender

V/S: HR 132, BP 102/68, RR 32, SpO2 88% room air → 95% on 4 L NC, Temp 37.4°C
Gen: distress, anxious, mild cyanosis, pleuritic chest pain, left leg swelling thigh circumference 6 cm > right + tender + warm + skin discoloration

Lab: D-dimer extremely elevated > 5,000, CBC mild leukocytosis, BNP elevated, troponin slightly elevated; ECG sinus tachycardia + S1Q3T3 pattern
US lower extremity Doppler: large DVT left common femoral + iliac extension
CT PE protocol: bilateral pulmonary emboli with right > left + mild right heart strain (RV dilatation)', '[{"label":"A","text":"Wait + observe"},{"label":"B","text":"Pediatric Deep Vein Thrombosis + Pulmonary Embolism (rising incidence, multifactorial risk factors here"},{"label":"C","text":"Aspirin alone"},{"label":"D","text":"Antibiotic alone"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric Deep Vein Thrombosis + Pulmonary Embolism (rising incidence, multifactorial risk factors here — central line, immobility, IBD, OCP from family — none actually, but adolescent IBD acute inflammation high VTE risk): admit ICU + cardiology/pulmonology + hematology + IR consultation; RISK STRATIFICATION — hemodynamically stable vs unstable (this patient is stable but with RV strain — submassive); SUPPORTIVE — oxygen titrated to SpO2 ≥ 92%, fluid resuscitation if hypotension (caution — RV preload-dependent in PE, avoid over-resuscitation, vasopressor preferred), analgesia; ANTICOAGULATION — start immediately if no contraindication: LMW HEPARIN (enoxaparin) 1 mg/kg SC q12h (preferred in stable pediatric — outpatient convertible) titrated to anti-Xa level 0.5-1.0 IU/mL (peds dosing per nomogram); OR UNFRACTIONATED HEPARIN IV bolus 75 U/kg + infusion 20 U/kg/hr titrated to PTT 60-85 sec (preferred if unstable, renal failure, or procedure planned); transition to DOAC (rivaroxaban approved peds, dabigatran emerging) OR warfarin (INR 2-3) for longer-term oral therapy; SYSTEMIC THROMBOLYSIS (tPA) — INDICATED for hemodynamically UNSTABLE PE (massive — shock, sustained hypotension, cardiac arrest) — dose alteplase 0.5-1 mg/kg over 2 hr (extrapolated adult); high bleeding risk weigh; CATHETER-DIRECTED THROMBOLYSIS / mechanical thrombectomy — for selected submassive (this patient could be candidate) — direct catheter to clot + lower dose tPA + mechanical fragmentation — emerging in pediatric IR; SURGICAL EMBOLECTOMY — refractory + experienced center; IVC FILTER selected (recurrent PE despite anticoagulation, contraindication anticoagulation — but problematic kids — long-term thrombosis around filter); REMOVE OFFENDING — REMOVE central venous catheter (if no longer needed) — major risk factor; immobility — early mobilization once anticoagulated; IDENTIFY UNDERLYING — thrombophilia workup (after acute, may be falsely positive during) — protein C/S, antithrombin, factor V Leiden, prothrombin gene, APS, MTHFR; treat underlying disease (IBD optimization); DURATION anticoagulation — 3-6 mo for provoked PE; longer for unprovoked or thrombophilia/recurrent; long-term monitoring — recurrence + post-thrombotic syndrome (chronic limb swelling/discomfort 25-50%) + pulmonary HT (rare CTEPH); compression stockings post-DVT for PTS prevention; psychosocial + transition adult; PEDIATRIC PE/DVT rising — central lines + obesity + IBD + sickle + cancer + adolescent OCP all common risk factors

---

Pediatric DVT/PE rising — central line + IBD + immobility + OCP + cancer + obesity risk factors. Anticoagulation (LMWH first-line stable, UFH if unstable). Submassive PE with RV strain = consider catheter-directed thrombolysis. Massive = systemic tPA. Long-term: thrombophilia workup, duration 3-6 mo, post-thrombotic syndrome, transition adult.', NULL,
  'hard', 'hematology', 'review',
  'pediatrics', 'clinical_decision', 'hematology', 'peds',
  'ASH 2018 + 2023 VTE Treatment in Children; CHEST 11th ed', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 14 ปี BW 60 kg admit hospital สำหรับ Crohn disease flare 7 d + central line femoral + on TPN + immobilized + ใช้ COC mother + bed-bound largely. วันนี้เริ่มหอบเหนื่อยฉับพลัน + เจ็บอกที่เพิ่ม inspiration + ใจสั่น + bilateral leg swelling left worse + tender

V/S: HR 132, BP 102/68, RR 32, SpO2 88% room air → 95% on 4 L NC, Temp 37.4°C
Gen: distress, anxious, mild cyanosis, pleuritic chest pain, left leg swelling thigh circumference 6 cm > right + tender + warm + skin discoloration

Lab: D-dimer extremely elevated > 5,000, CBC mild leukocytosis, BNP elevated, troponin slightly elevated; ECG sinus tachycardia + S1Q3T3 pattern
US lower extremity Doppler: large DVT left common femoral + iliac extension
CT PE protocol: bilateral pulmonary emboli with right > left + mild right heart strain (RV dilatation)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 13 ปี ก่อนหน้านี้ healthy 4 wk ก่อน มี viral-like illness + flu symptoms ตอนนี้ ผิดปกติ behavioral + psychiatric (paranoia, hallucinations, mood lability) + abnormal movements (orofacial dyskinesia, choreoathetosis) + dysautonomia (HR fluctuation 60-180, BP swings) + seizures + sleep disturbance + decreased consciousness progressive

V/S: HR variable 60-160, BP variable 90/50 to 160/100, RR variable, Temp 37.0°C, BW 42 kg
Gen: alert with severe disorganization, agitation, orofacial movements, intermittent posturing

Lab: CBC + CMP normal; CSF — lymphocytic pleocytosis 25 + protein 80 + glucose normal + oligoclonal bands present
Viral PCR negative HSV/VZV/EV; brain MRI: subtle FLAIR changes hippocampi bilateral mild
EEG: extreme delta brush pattern (highly suggestive)
Anti-NMDA receptor antibodies POSITIVE serum + CSF (high titer)
Pelvic US + MRI: ovarian teratoma left (paraneoplastic in ~50% of females anti-NMDA — must search)', '[{"label":"A","text":"Steroid only"},{"label":"B","text":"Anti-NMDA Receptor Encephalitis (autoimmune encephalitis, often paraneoplastic in females with ovarian teratoma, mostly idiopathic in younger kids)"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Antifungal alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Anti-NMDA Receptor Encephalitis (autoimmune encephalitis, often paraneoplastic in females with ovarian teratoma, mostly idiopathic in younger kids): pediatric neurology + neuro-immunology + oncology + ICU coordinated; FIRST-LINE IMMUNOTHERAPY combination: 1) HIGH-DOSE METHYLPREDNISOLONE 30 mg/kg/d IV × 5 d (pulse) followed by oral prednisone taper, 2) IVIG 2 g/kg total over 2-5 days, 3) PLASMAPHERESIS / plasma exchange alternative or adjunct (especially severe/refractory); REMOVE TUMOR — surgical resection of ovarian teratoma (if present — paraneoplastic in 50% females, removal frequently rapid response improvement); SECOND-LINE (refractory to first-line after 2 wk OR severe disease) — RITUXIMAB 375 mg/m² weekly × 4 doses (deplete B cells, mainstay) AND/OR CYCLOPHOSPHAMIDE IV monthly × 6 cycles; emerging options: bortezomib, tocilizumab, daratumumab for refractory; SUPPORTIVE — ICU monitoring (dysautonomia + seizures), antiepileptic for seizures (levetiracetam preferred), symptomatic management for movements (clonazepam, benzo) + behavior (low-dose atypical antipsychotic + caution; or none — symptoms often paradoxical worsen with neuroleptics), dysautonomia management (avoid wild HR/BP swings — beta-blocker + alpha-2 agonist + careful), nutrition (NG/G-tube during severe phase, may need 6-12 mo); REHABILITATION — long, intensive multidisciplinary (PT, OT, speech, neuropsych) — recovery slow over months-years; LONG-TERM — relapse 20% (especially without tumor removal/no rituximab), monitor antibody titers + clinical, continued immunosuppression depending; OUTCOMES — 75% substantial recovery (slow + incomplete), 10% death/severe disability — early diagnosis + early treatment = best outcomes; PSYCHOSOCIAL — family + child + transition return to school + academic accommodation; OTHER autoimmune encephalitides (anti-LGI1, anti-CASPR2, anti-GABA-B, anti-AMPA) treatable similar approach; differential important — HSV encephalitis (treat empirically with acyclovir until ruled out!), neuroleptic malignant syndrome, primary psychiatric (PEDS!)

---

Anti-NMDA encephalitis = treatable autoimmune encephalitis. Female + ovarian teratoma association (~50%). Multi-modal first-line (steroid + IVIG + plasmapheresis) + tumor removal + escalation rituximab/cyclophosphamide for refractory. Prolonged rehab. Differential includes HSV encephalitis (empiric acyclovir). Long-term 75% recovery if treated early.', NULL,
  'hard', 'neurology', 'review',
  'pediatrics', 'clinical_decision', 'neurology', 'peds',
  'Dalmau Lancet Neurology 2008 + 2011; International Autoimmune Encephalitis Consensus', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กหญิงอายุ 13 ปี ก่อนหน้านี้ healthy 4 wk ก่อน มี viral-like illness + flu symptoms ตอนนี้ ผิดปกติ behavioral + psychiatric (paranoia, hallucinations, mood lability) + abnormal movements (orofacial dyskinesia, choreoathetosis) + dysautonomia (HR fluctuation 60-180, BP swings) + seizures + sleep disturbance + decreased consciousness progressive

V/S: HR variable 60-160, BP variable 90/50 to 160/100, RR variable, Temp 37.0°C, BW 42 kg
Gen: alert with severe disorganization, agitation, orofacial movements, intermittent posturing

Lab: CBC + CMP normal; CSF — lymphocytic pleocytosis 25 + protein 80 + glucose normal + oligoclonal bands present
Viral PCR negative HSV/VZV/EV; brain MRI: subtle FLAIR changes hippocampi bilateral mild
EEG: extreme delta brush pattern (highly suggestive)
Anti-NMDA receptor antibodies POSITIVE serum + CSF (high titer)
Pelvic US + MRI: ovarian teratoma left (paraneoplastic in ~50% of females anti-NMDA — must search)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 6 ปี known glioblastoma multiforme brainstem (DIPG — diffuse intrinsic pontine glioma) ได้ chemo + radiation 1 yr ago + progression ปัจจุบัน. ตอนนี้ 18 mo since diagnosis (median survival DIPG 9-11 mo) + multiple symptoms — ปวดศีรษะ + อาเจียน + dysphagia + drooling + dyspnea + agitation + bed-bound + cannot speak

V/S: HR 102, RR 22 irregular, SpO2 92% RA, BP 102/68, BW 18 kg (decreased from 22 kg)
Family wishes — discussed extensively — comfort care, no further oncologic treatment
Goals — minimize suffering, allow death with dignity, maintain quality of remaining time

MRI: progression of tumor — no further oncologic treatment options', '[{"label":"A","text":"Continue aggressive chemo"},{"label":"B","text":"Pediatric End-of-life Palliative Care for DIPG (universally fatal pediatric tumor"},{"label":"C","text":"Refuse pain medication"},{"label":"D","text":"Continue intensive ICU care"},{"label":"E","text":"No family communication"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pediatric End-of-life Palliative Care for DIPG (universally fatal pediatric tumor — median survival 9-11 mo) — comprehensive family-centered approach: multidisciplinary palliative team — pediatric palliative + oncology + neurology + chaplain + child life + psychology + social work + nursing; ESTABLISH GOALS OF CARE — confirm family understanding + wishes + child if developmentally able (assent vs consent considerations) + advance directives + DNR/DNI orders + location of care preference (home, hospice, hospital); SYMPTOM MANAGEMENT comprehensive: PAIN — opioid (morphine 0.1-0.2 mg/kg PO/IV/SC q4h titrated + breakthrough q1-2 hr 10% of total daily) + adjuvants (acetaminophen, NSAID, gabapentin for neuropathic, methadone or hydromorphone if morphine inadequate), AVOID undertreatment (peds often undertreated); NAUSEA/VOMITING — ondansetron, dexamethasone, prochlorperazine, scopolamine patch; DYSPNEA — opioid (low-dose morphine helps subjective dyspnea + reduces work of breathing in dying), oxygen for comfort (not necessarily SpO2 target), fan, repositioning; SECRETIONS — glycopyrrolate, scopolamine (less sedating), suctioning gentle; SEIZURES — benzo PRN, may need continuous if frequent; AGITATION — benzo (midazolam, lorazepam, diazepam), antipsychotic if delirium, AVOID restraints; CONSTIPATION — laxative ALWAYS with opioid (osmotic + stimulant); NUTRITION — small frequent comfort feeds as tolerated, NG/G-tube usually NOT initiated late, may stop existing feeds if not desired/causing discomfort; FAMILY-CENTERED — frequent communication + emotional support + sibling support + bereavement counseling; child life specialist + chaplain + memory making + legacy projects (handprints, letters, photo books); HOME hospice if family prefers + supported (preferred most families when feasible — peds home hospice programs); pediatric hospice services (community Children''s Hospice International); BEREAVEMENT — anticipatory grief support before death, ongoing after, support groups; spirituality + cultural considerations + rituals; SCHOOL — communication with school + classmates appropriate developmental level; DONATION discussed if family wishes (organ — usually not possible DIPG); legal documentation; long-term — family grief counseling extends years; siblings — high risk for complicated grief + behavioral issues, support school + mental health; staff support — burnout + moral distress; education + advocacy + pediatric palliative care expanding; clinical research participation + tissue donation for research (PCBT — Pacific Coast Brain Tumor); GENERAL PRINCIPLES from AAP statement on pediatric palliative + WHO end-of-life: dignity + comfort + family + presence + adequate symptom management + concurrent care (palliative + disease-directed not exclusive) early integrated

---

Pediatric palliative care = comprehensive comfort + family-centered + symptom management + spiritual/emotional support. For DIPG (universally fatal), focus on quality of remaining time. Opioids + adjuvants for pain (avoid undertreatment). Address ALL symptoms. Multidisciplinary team. Home/hospice if preferred. Bereavement support extends post-death. Concurrent palliative + disease-directed care model.', NULL,
  'hard', 'psych_behavior', 'review',
  'pediatrics', 'clinical_decision', 'psych_behavior', 'peds',
  'AAP Clinical Report Palliative Care 2013; WHO Pediatric Palliative Care', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'peds_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'pediatrics'
      and q.scenario = 'เด็กชายอายุ 6 ปี known glioblastoma multiforme brainstem (DIPG — diffuse intrinsic pontine glioma) ได้ chemo + radiation 1 yr ago + progression ปัจจุบัน. ตอนนี้ 18 mo since diagnosis (median survival DIPG 9-11 mo) + multiple symptoms — ปวดศีรษะ + อาเจียน + dysphagia + drooling + dyspnea + agitation + bed-bound + cannot speak

V/S: HR 102, RR 22 irregular, SpO2 92% RA, BP 102/68, BW 18 kg (decreased from 22 kg)
Family wishes — discussed extensively — comfort care, no further oncologic treatment
Goals — minimize suffering, allow death with dignity, maintain quality of remaining time

MRI: progression of tumor — no further oncologic treatment options'
  );

commit;

