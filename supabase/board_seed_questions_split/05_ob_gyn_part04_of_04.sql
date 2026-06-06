-- ===============================================================
-- หมอรู้ — Board seed: สูติศาสตร์-นรีเวชวิทยา (ob_gyn) — part 4/4 (50 MCQs)
-- Safe to paste into Supabase SQL Editor. Re-runnable.
-- ===============================================================

begin;

-- mcq_subjects for this specialty (idempotent)
insert into public.mcq_subjects
  (name, name_th, icon, audience, board_specialty, exam_type, question_count)
values
  ('obg_clinical_decision', 'สูติศาสตร์-นรีเวชวิทยา · การตัดสินใจทางเวชกรรม', '🩺', 'board', 'ob_gyn', NULL, 0),
  ('obg_basic_science', 'สูติศาสตร์-นรีเวชวิทยา · วิทยาศาสตร์การแพทย์พื้นฐาน', '🧬', 'board', 'ob_gyn', NULL, 0),
  ('obg_ems_mgmt', 'สูติศาสตร์-นรีเวชวิทยา · การจัดการระบบบริการการแพทย์ฉุกเฉิน', '🚨', 'board', 'ob_gyn', NULL, 0),
  ('obg_integrative', 'สูติศาสตร์-นรีเวชวิทยา · ข้อสอบบูรณาการ', '🧩', 'board', 'ob_gyn', NULL, 0)
on conflict (name) do nothing;

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Trans-masculine person (assigned female at birth, identifies as male) age 28, taking testosterone for gender-affirming therapy × 3 yr, monthly period stopped, partnered with cis-male, planning pregnancy together via discontinuation of testosterone

V/S: BP 120/74, HR 76
Gen: well
Exam: deferred gender-affirming exam, intact uterus + ovaries + functional, has discussed with partner
Lab: testosterone 320 (mid-range male), normal CBC/CMP
No medical contraindications to pregnancy', '[{"label":"A","text":"Refuse care — only women can be pregnant"},{"label":"B","text":"Transgender + gender-diverse people in OB/GYN care + pregnancy"},{"label":"C","text":"Refuse care"},{"label":"D","text":"Cesarean only"},{"label":"E","text":"Methotrexate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Transgender + gender-diverse people in OB/GYN care + pregnancy** — affirming, evidence-based, individualized: (1) **language + respect** — use chosen name + pronouns; document gender identity + sex assigned at birth + anatomy; gender-neutral language (''pregnant person'', ''chestfeeding''); ask preferences for body parts; (2) **preconception planning** — multidisciplinary (gender-affirming care provider + OB + MFM + mental health); (3) **discontinue testosterone** before conception attempts (testosterone teratogenic — virilizing female fetus; also gonadal suppression); typically stop 3-6 mo before conception; menses + ovulation usually return within months; (4) **fertility preservation** — discuss before initiating hormones if wants biological children — oocyte/embryo cryopreservation; (5) **conception** — natural with male partner OR donor sperm + insemination/IVF + reciprocal IVF (partner egg into trans-man uterus); (6) **prenatal care** — same evidence-based ANC; pelvic exam may be traumatic (chest binders, prior surgery, dysphoria) — trauma-informed care + minimize unnecessary exam + accommodations; mental health screen (high rates depression/anxiety); chest dysphoria + chest binding during pregnancy; (7) **previous chest masculinization (top surgery)** — may preclude chestfeeding; assess + counsel; (8) **delivery** — preferred environment (room placement, staff briefed, name/pronouns); same OB indications for vaginal vs C/S; (9) **postpartum + chestfeeding** — chestfeeding possible if breast tissue retained; testosterone resumption depends on chestfeeding plans (transfers to milk); (10) **mental health support** — postpartum + identity; (11) **legal + insurance** — gender markers on records affect coverage; advocate for patient; (12) **provider education + bias reduction** — training, allyship, system inclusion; (13) **AAP + ACOG + WPATH SOC 8** — affirming care position; (14) Thai context — emerging legal recognition + growing trans-inclusive clinics; advocacy ongoing

---

Transgender OB care: affirming, individualized, multidisciplinary. Discontinue T pre-conception (teratogenic). Preserve fertility before hormones. Trauma-informed exam. Chest dysphoria. Chestfeeding possible. Mental health support. Provider education. Pronouns + name. WPATH SOC 8 + ACOG + AAP affirming.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'integrative', 'obgyn', 'adult',
  'ACOG Committee Opinion 823: Health Care for Transgender Individuals; WPATH SOC 8 2022', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Trans-masculine person (assigned female at birth, identifies as male) age 28, taking testosterone for gender-affirming therapy × 3 yr, monthly period stopped, partnered with cis-male, planning pregnancy together via discontinuation of testosterone

V/S: BP 120/74, HR 76
Gen: well
Exam: deferred gender-affirming exam, intact uterus + ovaries + functional, has discussed with partner
Lab: testosterone 320 (mid-range male), normal CBC/CMP
No medical contraindications to pregnancy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 30 ปี G0P0 มา OPD เพื่อปรึกษา preconception care — planning pregnancy ปีนี้ มี chronic conditions: BMI 32, mild HT (130/85 no medication), prediabetes A1c 6.0, smoker 5 cigs/d, occasional alcohol, no folate currently

V/S: BP 132/86, HR 80
Gen: BMI 32
Lab: A1c 6.0, lipid mildly elevated, TSH 2.4 normal, no anemia', '[{"label":"A","text":"Just get pregnant — sort it out later"},{"label":"B","text":"Preconception counseling — optimize health 3-12 mo before pregnancy"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Preconception counseling** — optimize health 3-12 mo before pregnancy: (1) **lifestyle** — **weight loss** (target BMI < 30 ideal — reduces GDM, PE, macrosomia, C/S, anomalies, stillbirth); **smoking cessation** (nicotine, varenicline, NRT acceptable preconception, ↓ preterm + LBW + abruption + IUFD); **alcohol cessation** (no safe amount in pregnancy); avoid recreational drugs; **regular exercise** 150 min/wk; nutrition (Mediterranean diet); (2) **folate supplementation** — **0.4-0.8 mg/d** start ≥ 1-3 mo before conception (prevents NTD by 50-70%); **4-5 mg/d** if prior NTD-affected pregnancy, AED use, diabetes, obesity (some recommendations), malabsorption; (3) **vaccinations** — MMR (4 wk before pregnancy — live), VZV (4 wk before — live), HBV, HPV, Tdap, flu, COVID; (4) **screen + manage chronic conditions**: (a) **HT** — optimize (target < 140/90 or < 130/80) — switch ACEI/ARB/teratogen to labetalol/nifedipine/methyldopa; (b) **DM/prediabetes** — optimize A1c < 6.5%; dietary, metformin if needed, weight loss; (c) **thyroid** — TSH < 2.5; (d) **mental health** — screen + treat depression; (e) **STI screening** — HIV, syphilis, HBV, HCV, GC/CT; (f) anemia + thalassemia screen; (g) cervical cancer screening up-to-date; (4) **family history + genetic carrier screening** — Tay-Sachs, CF, SMA, thalassemia (Thai universal), Hb E, hemoglobinopathies, fragile X; **expanded carrier panel** option; (5) **medication review** — teratogens (warfarin, ACEI/ARB, valproate, isotretinoin, statins — though newer less concerning, methotrexate, etc.) → switch to safer; (6) **dental** — cleaning + treatment (periodontal disease association preterm); (7) **environmental** — toxic exposures, occupation, fish/mercury; (8) **partner involvement** — health, genetic, support; (9) **fertility awareness** — cycle, ovulation, timing; (10) **financial + social** — insurance, leave, support system; (11) **age-related** — AMA counseling; (12) Thai context — RTCOG/MOPH preconception guidelines; thalassemia screening priority

---

Preconception: lifestyle (weight, smoking, alcohol, exercise), folate 0.4-0.8 mg (4-5 if NTD risk), vaccines, chronic disease optimization, genetic carrier screen, medication review (switch teratogens), STI + screening, fertility awareness, partner involvement. Thai: thalassemia screening priority.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Committee Opinion 762: Prepregnancy Counseling; CDC Preconception Health', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 30 ปี G0P0 มา OPD เพื่อปรึกษา preconception care — planning pregnancy ปีนี้ มี chronic conditions: BMI 32, mild HT (130/85 no medication), prediabetes A1c 6.0, smoker 5 cigs/d, occasional alcohol, no folate currently

V/S: BP 132/86, HR 80
Gen: BMI 32
Lab: A1c 6.0, lipid mildly elevated, TSH 2.4 normal, no anemia'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงตั้งครรภ์ G2P1 GA 16 wk ANC routine — urine culture: E. coli > 100,000 CFU/mL — no symptoms (no dysuria, frequency, flank pain), prior history of UTI

V/S: BP 116/72, HR 80, Temp 36.9
Gen: well, no CVA tenderness
Fetal: FHR 144, growth appropriate
U/A: nitrite+, leukocyte+, no hematuria', '[{"label":"A","text":"No treatment — asymptomatic"},{"label":"B","text":"Asymptomatic Bacteriuria (ASB) in pregnancy"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Wait until 3rd trimester"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Asymptomatic Bacteriuria (ASB) in pregnancy** — treat to prevent pyelonephritis + preterm + LBW: (1) **screen** all pregnant women — urine culture at first ANC visit or 12-16 wk (Thai/USPSTF/ACOG); (2) **criteria** — single voided culture > 100,000 CFU/mL of uropathogen (or > 10,000 in catheter specimen); (3) **treat 5-7 days antibiotic** (not single dose for ASB or cystitis in pregnancy unlike non-pregnant); (a) **nitrofurantoin 100 mg PO q 6 hr × 5-7 d** — **avoid at term (≥ 36 wk) — neonatal hemolysis G6PD risk**; (b) **amoxicillin 500 mg PO TID × 7 d** if sensitive; (c) **cephalexin 500 mg PO QID × 7 d**; (d) **TMP-SMX** — **avoid 1st trimester (NTD)** + near term (kernicterus); 2nd trimester OK; (e) **fosfomycin 3 g single dose** — acceptable single-dose alternative; (4) **rationale to treat** — untreated ASB → 25-30% develop pyelonephritis (vs < 5% with treatment); pyelonephritis → preterm, LBW, ARDS, sepsis; (5) **test of cure** urine culture 1-2 wk post-treatment; if positive → repeat treatment; (6) **recurrent UTI** — suppression nitrofurantoin 100 mg QHS for remainder of pregnancy; (7) **acute cystitis** (symptomatic — dysuria, frequency, urgency, no fever/flank pain) — same antibiotic choices, 5-7 d; (8) **group B Strep bacteriuria** — treat at time of detection + GBS prophylaxis in labor + no need to retreat just before delivery; (9) **education** — increased fluids, void after intercourse, wiping front-to-back, cranberry insufficient evidence; (10) **complicated** — diabetic, renal disease, immunocompromised — more careful follow-up + extended treatment

---

ASB in pregnancy: screen + treat to prevent pyelonephritis. 5-7 d antibiotic. Nitrofurantoin (avoid term), amoxicillin, cephalexin, TMP-SMX (avoid 1st tri + term), fosfomycin single. Test of cure. GBS bacteriuria = treat + intrapartum prophylaxis. Recurrent → suppression.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'USPSTF ASB Screening 2019; ACOG Committee Opinion UTI in Pregnancy', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงตั้งครรภ์ G2P1 GA 16 wk ANC routine — urine culture: E. coli > 100,000 CFU/mL — no symptoms (no dysuria, frequency, flank pain), prior history of UTI

V/S: BP 116/72, HR 80, Temp 36.9
Gen: well, no CVA tenderness
Fetal: FHR 144, growth appropriate
U/A: nitrite+, leukocyte+, no hematuria'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงตั้งครรภ์ G2P1 GA 26 wk มาห้องฉุกเฉินด้วย R flank pain + fever 39.0 + N/V + dysuria × 2 d

V/S: BP 110/68, HR 124, RR 22, Temp 39.0
Gen: ill-looking + R CVA tenderness ++
Fetal: FHR 158 tachycardia
Lab: WBC 18K with left shift, Cr 0.9, BUN 18, CRP 95, lactate 2.4
U/A: nitrite+, leukocyte+, WBC many, RBC few
Urine cx pending', '[{"label":"A","text":"Discharge home with PO antibiotic"},{"label":"B","text":"Acute Pyelonephritis in pregnancy"},{"label":"C","text":"Outpatient PO TMP-SMX"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Methotrexate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Acute Pyelonephritis in pregnancy** — admit (high risk maternal sepsis + preterm labor + ARDS): (1) **admit** + IV access + isotonic fluid resuscitation + monitor maternal vitals + uterine activity (toco) + fetal heart rate (NST); (2) **labs** — CBC, CMP, blood + urine cultures pre-antibiotic, lactate, β-hCG (confirm), CRP; (3) **empirical IV antibiotics** within 1 hr (sepsis bundle): (a) **ceftriaxone 1-2 g IV q 24 hr** (first-line, pregnancy-safe, covers most enterobacteriaceae) OR (b) **cefazolin** 1-2 g q 8 hr OR (c) **ampicillin + gentamicin** (broader, watch fetal nephrotoxicity); (d) **avoid fluoroquinolones** (cartilage); (4) **continue IV antibiotic until afebrile 24-48 hr + clinical improvement** → transition to PO based on culture sensitivities (cephalexin, amoxicillin-clav, nitrofurantoin if not late preg) to complete **10-14 d total**; (5) **suppressive nitrofurantoin** for remainder of pregnancy (recurrence > 20%); (6) **tocolytic CAUTION** — preterm contractions may be irritative from pyelo — treat infection + hydration first; avoid β-mimetics (worsens pulmonary edema risk in pyelo); (7) **complications watch** — **ARDS** (15% pyelo pregnancy → respiratory failure — early ICU), septic shock, AKI, abruption, preterm labor; (8) **renal US** if no improvement 48-72 hr (rule out obstruction/abscess/stone — pregnancy hydroureter normal); (9) **follow-up** — test of cure urine cx 1-2 wk after; (10) **recurrence** — investigate structural anomaly (VCUG/US postpartum); (11) **steroids if preterm + delivery imminent**; **MgSO4 neuroprotection if < 32 wk**; (12) Thai universal access through NHSO; admit threshold lower in 1st-2nd trimester

---

Pyelonephritis pregnancy: admit + IV ceftriaxone + supportive. 10-14 d antibiotic. Watch ARDS (15%!), sepsis, preterm. Continue suppression rest of pregnancy. Test of cure. Avoid fluoroquinolones. Renal US if no improvement.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin 196: UTI; SMFM Pyelonephritis in Pregnancy', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงตั้งครรภ์ G2P1 GA 26 wk มาห้องฉุกเฉินด้วย R flank pain + fever 39.0 + N/V + dysuria × 2 d

V/S: BP 110/68, HR 124, RR 22, Temp 39.0
Gen: ill-looking + R CVA tenderness ++
Fetal: FHR 158 tachycardia
Lab: WBC 18K with left shift, Cr 0.9, BUN 18, CRP 95, lactate 2.4
U/A: nitrite+, leukocyte+, WBC many, RBC few
Urine cx pending'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงตั้งครรภ์ G2P1 GA 30 wk มาด้วย easy bruising + petechiae × 2 wk, no recent infection, no medications

V/S: BP 118/72, HR 84
Gen: petechiae lower extremities + buccal mucosa, no bleeding from gums
Fetal: FHR 144 reactive
Lab: Hb 11.2, plt 38K (was 220K pre-pregnancy), WBC normal, peripheral smear: low platelets no schistocytes no immature forms, LFT normal, Cr normal, coag normal, ANA negative, HIV negative, HCV negative, no preeclampsia features
Dx: ITP (immune thrombocytopenia)', '[{"label":"A","text":"Cesarean immediately"},{"label":"B","text":"ITP in pregnancy"},{"label":"C","text":"Hysterectomy"},{"label":"D","text":"Discharge home — no follow-up"},{"label":"E","text":"Methotrexate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **ITP in pregnancy** (autoimmune anti-platelet Ab destruction; distinguish from gestational thrombocytopenia (mild, plt > 70K, late pregnancy, normalizes postpartum), preeclampsia/HELLP, TTP/HUS, AFLP, DIC, HIV-related): (1) **diagnosis of exclusion** — CBC + smear + LFT + Cr + coag + autoimmune + HIV/HCV; bone marrow not routine (used historically if refractory or atypical); (2) **management by platelet count + bleeding**: (a) **mild (plt > 50K, no bleeding)** — observation + serial monitoring + delivery planning; (b) **moderate-severe (plt < 30K or bleeding)** — treat: **first-line corticosteroid (prednisolone 1 mg/kg/d)** or **IVIG 1 g/kg × 1-2 doses** (faster response, useful pre-delivery); (c) refractory — anti-D (if Rh+), rituximab (case-by-case), splenectomy (2nd trimester safest if needed); (d) **TPO receptor agonist (eltrombopag, romiplostim)** limited data — use cautiously; (3) **delivery threshold platelets**: > 50K for vaginal delivery, > 80K for cesarean, > 80K for epidural/spinal (anesthesia preference, varies — some accept 70K); platelet transfusion if low + bleeding/procedure (less effective in ITP — use IVIG); (4) **mode of delivery** — **maternal indication only** for C/S (ITP not indication); **avoid invasive procedures**: fetal scalp electrode, fetal scalp blood, operative vaginal vacuum (subgaleal hemorrhage in thrombocytopenic neonate); (5) **neonatal — fetal/neonatal alloimmune thrombocytopenia (NAIT) is different**; ITP — maternal Ab crosses placenta — **neonatal thrombocytopenia in 10-30%** of ITP babies; check cord blood plt + serial for 1 wk; treat severe with IVIG + plt transfusion; (6) **delivery in tertiary center** with NICU + blood bank; (7) **avoid NSAIDs** in mother + neonate; (8) **breastfeeding** safe; (9) **future pregnancy** — recurrence; preconception optimization

---

ITP pregnancy: exclude other thrombocytopenia causes. Treat if plt < 30K or bleeding — steroid or IVIG. Delivery: plt > 50K vaginal, > 80K C/S + epidural. Maternal indication for C/S only. Avoid scalp electrode + operative vaginal in thrombocytopenic. 10-30% neonatal thrombocytopenia — monitor + IVIG if severe.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ASH ITP 2019; ACOG Practice Bulletin 207', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงตั้งครรภ์ G2P1 GA 30 wk มาด้วย easy bruising + petechiae × 2 wk, no recent infection, no medications

V/S: BP 118/72, HR 84
Gen: petechiae lower extremities + buccal mucosa, no bleeding from gums
Fetal: FHR 144 reactive
Lab: Hb 11.2, plt 38K (was 220K pre-pregnancy), WBC normal, peripheral smear: low platelets no schistocytes no immature forms, LFT normal, Cr normal, coag normal, ANA negative, HIV negative, HCV negative, no preeclampsia features
Dx: ITP (immune thrombocytopenia)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 26 ปี G1P0 GA 24 wk underlying sickle cell disease (HbSS) on hydroxyurea pre-pregnancy (stopped at conception), prior frequent crises

V/S: BP 118/72, HR 92, Temp 36.9
Gen: well at baseline, no acute crisis
Fetal: FHR 144 reactive, EFW 600 g (50th)
Lab: Hb 7.8, MCV 88, retic 8%, LFT WNL, Cr 0.8, urine protein/Cr 0.18, no infection', '[{"label":"A","text":"Continue hydroxyurea"},{"label":"B","text":"Sickle Cell Disease (SCD) in pregnancy"},{"label":"C","text":"Hysterectomy"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Discharge — no follow-up"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Sickle Cell Disease (SCD) in pregnancy** — high-risk multidisciplinary (hematology + MFM): (1) **complications** ↑ in pregnancy — vaso-occlusive crisis, acute chest syndrome, infection (encapsulated org), VTE, preeclampsia/HT, FGR, preterm, stillbirth, maternal mortality; (2) **medication review**: (a) **hydroxyurea — discontinue** preconception or at conception (teratogen — limit data, some recent reassuring); (b) **iron chelators** — discontinue (deferasirox teratogen; transition to deferoxamine if needed); (c) **folate 4-5 mg/d** (high turnover); (d) **penicillin prophylaxis** — continue (functional asplenia); (e) **vaccines** — pneumo, Hib, meningo, flu, COVID, Tdap; (3) **transfusion** — **chronic simple/exchange transfusion** if prior severe complication, current complication, IUGR, recurrent crises, prior stroke; goal HbS < 30%; (4) **anticoagulation** — VTE risk — prophylactic LMWH if additional risk (hospitalization, immobility); (5) **fetal surveillance** — anatomy scan, **growth US q 4 wk from 24 wk**, NST/BPP from 28-32 wk (FGR/stillbirth risk); Doppler if FGR; (6) **delivery timing** — 37-39 wk; vaginal preferred + epidural early (pain control + avoid GA — sickling); avoid prolonged labor; (7) **intrapartum** — IV hydration (avoid dehydration), O2, warm, blood available, prophylactic transfusion if low Hb; treat crisis with hydration + analgesia + O2; (8) **infection screening** — sepsis risk; (9) **preeclampsia prevention** — aspirin 81-150 mg/d from 12 wk; (10) **acute chest syndrome** — fever + chest pain + new infiltrate — exchange transfusion + antibiotic + supportive; high mortality if missed; (11) **postpartum** — continue prophylaxis; restart hydroxyurea + chelators; counsel breastfeeding (hydroxyurea avoid); contraception (progestin-only safer; estrogen ↑ VTE — relative contraindication); (12) **neonatal** — newborn screen (in Thailand if available + parental partner status — heterozygous risk for sickle trait baby vs disease); genetic counseling + cascade

---

SCD pregnancy: high-risk. Stop hydroxyurea + chelators. Folate 4-5 mg. Penicillin prophylaxis. Vaccines. Transfusion as needed. VTE prophylaxis. Growth US q 4 wk + NST. Aspirin PE prevention. ACS = exchange transfusion. Delivery 37-39 wk + epidural. Postpartum: restart HU, progestin contraception, genetic counseling.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ASH SCD Pregnancy 2020; RCOG Green-top 61', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 26 ปี G1P0 GA 24 wk underlying sickle cell disease (HbSS) on hydroxyurea pre-pregnancy (stopped at conception), prior frequent crises

V/S: BP 118/72, HR 92, Temp 36.9
Gen: well at baseline, no acute crisis
Fetal: FHR 144 reactive, EFW 600 g (50th)
Lab: Hb 7.8, MCV 88, retic 8%, LFT WNL, Cr 0.8, urine protein/Cr 0.18, no infection'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงตั้งครรภ์ G1P0 GA 10 wk first ANC — มาขอ aneuploidy screening options ตัดสินใจระหว่าง combined first trimester + NIPT — งบประมาณจำกัด, ไม่มี family history

V/S: BP 116/72, HR 80
Gen: well
Fetal: heart 162, dating consistent
Age 32, no prior abnormal pregnancy', '[{"label":"A","text":"Skip all screening"},{"label":"B","text":"Aneuploidy screening counseling"},{"label":"C","text":"Force amniocentesis"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Hysterectomy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Aneuploidy screening counseling** — pros + cons of each option: (1) **first-trimester combined** (NT + PAPP-A + free β-hCG, 11-13+6 wk) — detection T21 ~ 85%, FPR 5%; widely available + cheaper than NIPT; bonus: NT > 3.5 mm also screens for cardiac defects + other syndromes; PAPP-A low predicts preeclampsia/FGR; provides individualized risk; (2) **second-trimester quad screen** (AFP, hCG, uE3, inhibin A, 15-22 wk) — detection T21 ~ 80%; also AFP for NTD; (3) **integrated/sequential** — combines 1st + quad → highest combined detection; (4) **cell-free DNA (NIPT)** from 10 wk — placental DNA in maternal blood; detection T21 > 99%, T18/T13 ~ 98%; sex chromosome aneuploidies; microdeletions limited; **lower false positive rate** (< 0.5%); cost: more expensive but increasingly available in Thai private; some hospitals offer through NHSO/insurance; **considerations** — fetal fraction (low in obesity, early GA → indeterminate result), mosaicism, twin pregnancies (works but slightly different); (5) **diagnostic testing** — **CVS 11-13+6 wk** or **amniocentesis 15+ wk** — definitive, karyotype + CMA + FISH; ~ 0.1-0.2% loss; (6) **soft markers on US** — nuchal thickness, nasal bone, echogenic intracardiac focus, echogenic bowel, choroid plexus cyst, single umbilical artery — modify risk; (7) **counseling** — discuss: (a) information desired, (b) decision possible based on result, (c) risk willingness, (d) financial, (e) reproductive option preferences (continue, prepare, terminate — legal in Thailand for genetic disorders); (8) **for this patient** — age 32 (intermediate risk), no family history → reasonable options: combined 1st-tri (cheaper, available) + offer NIPT if combined high-risk OR NIPT primary if budget allows; informed shared decision; (9) **follow positive result** with diagnostic CVS/amnio; (10) **don''t pressure**, respect autonomy + ethics

---

Aneuploidy screening choices: combined 1st-tri (NT/PAPP-A/βhCG, 85% T21), quad 2nd-tri (80%), integrated, NIPT (>99% T21, lower FPR, more $). Diagnostic: CVS, amnio. Soft markers. Counseling — informed choice, autonomy. Thai access varies. Follow positive → diagnostic.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin 226: Screening for Fetal Chromosomal Abnormalities 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงตั้งครรภ์ G1P0 GA 10 wk first ANC — มาขอ aneuploidy screening options ตัดสินใจระหว่าง combined first trimester + NIPT — งบประมาณจำกัด, ไม่มี family history

V/S: BP 116/72, HR 80
Gen: well
Fetal: heart 162, dating consistent
Age 32, no prior abnormal pregnancy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงตั้งครรภ์ GA 38 wk twin pregnancy DCDA, twin A vertex + twin B vertex, both 2,800 g, no other complications

V/S: BP 124/76, HR 84
Fetal: Twin A FHR 144, Twin B FHR 148, both reactive
Cervix: 4 cm dilated, contractions q 3 min — in labor
No prior C/S, no contraindication', '[{"label":"A","text":"Cesarean for all twins"},{"label":"B","text":"Twin labor + delivery management"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Methotrexate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Twin labor + delivery management** — vertex-vertex twins (DCDA or DCMA) — can attempt vaginal delivery: (1) **planning** — adequate experience operator + team (anesthesia, pediatric × 2, OR ready ถ้า need emergency C/S), IV × 2 large bore, type & cross, blood available, US in room; (2) **continuous CTG** for both twins (dual monitors); (3) **epidural anesthesia recommended** (allows intrauterine manipulation if needed for twin B); (4) **Twin A delivery** — same as singleton vertex; cord clamped; (5) **Twin B management** (critical period): (a) **immediate assessment** — US to confirm presentation (may change after twin A out), FHR, station, position; (b) **if remains vertex + favorable** → ARM + augment + vaginal delivery; (c) **if breech / transverse / non-engaged** → options: (i) **external cephalic version (ECV)** to vertex (50-70% success), (ii) **internal podalic version + breech extraction** (skilled operator, single fetus, intact membranes preferred), (iii) **assisted breech delivery** (frank + complete acceptable; footling less), (iv) **C/S for twin B** — combined vaginal + C/S — minority of cases; (d) **Twin Birth Study (Barrett 2013)** — planned vaginal vs C/S for first twin vertex 32-38 wk — no difference in primary outcome (composite mortality/morbidity); supports planned vaginal; (6) **timing** — deliver twin B within 30 min if possible (cord prolapse, placental separation, fetal distress risks); but no fixed limit if reassuring; (7) **uterotonics** + **active management 3rd stage** (atony + retained placenta risks ↑ in twins); (8) **non-vertex twin A** → planned C/S (cannot deliver vaginally — locked twins risk); (9) **monoamniotic** (MA) twins → planned C/S 32-34 wk (cord entanglement); **MCDA non-TTTS** → planned delivery 36-37 wk; **DCDA** → 38 wk; (10) **counseling** — share Twin Birth Study findings + individualized

---

Twin labor vertex-vertex: vaginal delivery acceptable per Twin Birth Study. Continuous CTG both. Epidural. Twin B: vertex → vaginal; non-vertex → ECV, internal podalic + breech extraction, or C/S. Timing flexible if reassuring. Uterotonics + active 3rd stage. Non-vertex twin A → C/S. MA twins → C/S.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'Twin Birth Study Barrett NEJM 2013; ACOG/SMFM Twin Pregnancy', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงตั้งครรภ์ GA 38 wk twin pregnancy DCDA, twin A vertex + twin B vertex, both 2,800 g, no other complications

V/S: BP 124/76, HR 84
Fetal: Twin A FHR 144, Twin B FHR 148, both reactive
Cervix: 4 cm dilated, contractions q 3 min — in labor
No prior C/S, no contraindication'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 28 ปี G2P1 prior LSCS 1 ปี ago — มาขอปรึกษา VBAC ใน pregnancy ใหม่ GA 8 wk, single fetus, no complication

V/S: BP 116/72, HR 76
Gen: well
Prior C/S: low transverse for non-reassuring CTG ใน 1st labor, full-term, recovered uneventfully
BMI 25, no other comorbidity', '[{"label":"A","text":"Cesarean only — no VBAC discussion"},{"label":"B","text":"VBAC (TOLAC) counseling"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Discharge — no plan"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **VBAC (TOLAC) counseling** — shared decision-making: (1) **success rate ~ 60-80%** with prior LSCS for non-recurring indication (non-reassuring CTG, breech) > 60-70%; lower if prior C/S for arrest disorders, no prior vaginal delivery, BMI > 30, induction needed, > 40 yr; **VBAC calculator** (MFMU) for individualized estimate; (2) **eligibility criteria** — prior **1-2 LSCS low transverse** (or low vertical if known + uncomplicated); singleton; vertex; no other contraindication to vaginal delivery; **adequate facility** — 24/7 OB + anesthesia + OR readiness (decision-to-incision < 30 min); patient preference; (3) **contraindications** — prior classical/T-incision uterine surgery, prior uterine rupture, contraindication to vaginal delivery (previa, vasa previa, malpresentation), unable to access immediate C/S; (4) **risks**: (a) **uterine rupture** ~ 0.5-1% (low transverse 1 prior); ↑ with induction (especially PG), augmentation, > 1 prior C/S, short interpregnancy < 18 mo; classical 4-9%; (b) **failed TOLAC** — emergency C/S ↑ morbidity vs scheduled; (c) **maternal hemorrhage, infection, hysterectomy, transfusion** rates similar to scheduled C/S if successful; higher if failed; (d) **perinatal HIE/death** ~ 0.2% (acute event); vs background; (5) **ERCD risks** — surgical morbidity, longer recovery, future placenta accreta/previa increasing risk each C/S, delayed initial BF, neonatal TTN; (6) **management** — labor in hospital with continuous EFM, IV access, type & screen, immediate C/S available; avoid PG ripening (uterine rupture risk) — use Foley balloon mechanical or oxytocin; cautious oxytocin augmentation; epidural acceptable (doesn''t mask rupture); (7) **signs of rupture** — sudden FHR abnormality (most), abdominal pain, loss of station, vaginal bleeding, hemodynamic instability; (8) **shared decision** — value preferences, future fertility, support; (9) **inter-pregnancy interval** > 18 mo recommended; (10) **uterine scar US**: lower segment thickness ≥ 2.5-3 mm predicts intact (research, not routine)

---

VBAC/TOLAC: success 60-80%. Eligible 1-2 prior LSCS low transverse + singleton vertex + facility ready. Risks: rupture 0.5-1%, failed TOLAC. Calculator individualizes. Avoid PG (use mechanical/oxytocin). Continuous EFM. Sudden FHR abnormality = rupture. Shared decision. IPI > 18 mo.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin 205: VBAC 2019', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 28 ปี G2P1 prior LSCS 1 ปี ago — มาขอปรึกษา VBAC ใน pregnancy ใหม่ GA 8 wk, single fetus, no complication

V/S: BP 116/72, HR 76
Gen: well
Prior C/S: low transverse for non-reassuring CTG ใน 1st labor, full-term, recovered uneventfully
BMI 25, no other comorbidity'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงตั้งครรภ์ G1P0 GA 38 wk in labor with epidural placed by anesthesia — sudden BP drop, fetal bradycardia

V/S: BP 78/45, HR 105 (post-epidural), RR 18, SpO2 99%
Fetal: FHR 70 bradycardia × 5 min
Cervix: 5 cm dilated, vertex station -1
No bleeding, uterus relaxed', '[{"label":"A","text":"Continue infusion"},{"label":"B","text":"Maternal hypotension after epidural → uteroplacental hypoperfusion → fetal bradycardia"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Methotrexate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Maternal hypotension after epidural → uteroplacental hypoperfusion → fetal bradycardia** — common epidural side effect from sympathetic blockade: (1) **immediate intrauterine resuscitation** — (a) **left lateral position** (LUD — relieve aortocaval), (b) **IV fluid bolus 500-1,000 mL** crystalloid, (c) **vasopressor** — **phenylephrine 50-100 mcg IV bolus** (preferred — preserves placental flow per current evidence vs ephedrine) OR **ephedrine 5-10 mg IV bolus**; (d) **O2** (controversial — limit), (e) **stop epidural infusion** temporarily; (f) **check** — block level (high spinal? — respiratory failure); (g) **assess for other causes** — abruption (pain, bleeding), uterine rupture if VBAC, cord prolapse, tachysystole; (h) **vaginal exam** — rule out cord, assess progress; (2) **if persistent FHR abnormality > 5-10 min despite resuscitation** → consider expedite delivery (operative vaginal if station + dilation appropriate; C/S otherwise); (3) **prevention** — IV fluid preload + phenylephrine infusion prophylactically (per recent obstetric anesthesia guidelines); slow titration epidural dose; positioning; (4) **other epidural complications** to recognize: (a) **high/total spinal** — respiratory + cardiovascular collapse — intubate, support, fluid, vasopressor; (b) **local anesthetic systemic toxicity (LAST)** — CNS (seizure, AMS) + cardiovascular — **lipid emulsion 20% 1.5 mL/kg IV bolus then infusion** + supportive; (c) **post-dural puncture headache (PDPH)** — positional headache 24-72 hr post-procedure — bed rest + hydration + caffeine + acetaminophen + epidural blood patch ถ้า severe; (d) **epidural hematoma** — back pain + neurologic deficit — emergency MRI + decompression; (e) **infection — abscess, meningitis**; (f) **failed/patchy block** — replace; (g) **shivering, pruritus, urinary retention, fever** common; (5) document + debrief

---

Epidural hypotension → fetal bradycardia: LUD + fluid + phenylephrine (preferred over ephedrine). Stop infusion. Other complications: high spinal, LAST (lipid emulsion), PDPH (blood patch), hematoma, infection, failed block. Document + debrief. Prevention: fluid coload + prophylactic vasopressor.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ASA Obstetric Anesthesia 2016; SOAP Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงตั้งครรภ์ G1P0 GA 38 wk in labor with epidural placed by anesthesia — sudden BP drop, fetal bradycardia

V/S: BP 78/45, HR 105 (post-epidural), RR 18, SpO2 99%
Fetal: FHR 70 bradycardia × 5 min
Cervix: 5 cm dilated, vertex station -1
No bleeding, uterus relaxed'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 28 ปี G1P1 postpartum d 2 — มาด้วยปวดศีรษะรุนแรง postural ↑ when sitting/standing ↓ supine + neck stiffness + photophobia × 24 ชม. Received spinal anesthesia for C/S 2 d ago

V/S: BP 122/76, HR 88, Temp 37.0
Gen: prefer supine, photophobic
Neuro: no focal deficit, no meningismus, no fever, no rash
Lab: WBC 9, CRP normal, LP not done (suspected PDPH not meningitis)', '[{"label":"A","text":"Discharge home — observation"},{"label":"B","text":"Post-Dural Puncture Headache (PDPH)"},{"label":"C","text":"Hysterectomy"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Post-Dural Puncture Headache (PDPH)** — characteristic postural headache (worse upright, better supine) after dural puncture (spinal anesthesia, accidental dural puncture during epidural, LP, intrathecal injection); ↑ risk with **larger gauge needle, cutting (Quincke) needle vs pencil-point (Whitacre, Sprotte), multiple attempts, younger age, female, lower BMI**; (1) **diagnosis clinical** — postural + frontal/occipital + neck stiffness/photophobia/tinnitus/nausea — typically 24-72 hr post-procedure; (2) **exclude differential** — preeclampsia (BP, proteinuria, vision/RUQ — postpartum can happen up to 6 wk), CVST (cortical vein thrombosis — fixed, no postural), meningitis (fever, neck stiff, AMS — LP if uncertain), subarachnoid hemorrhage, migraine, sinusitis, infection, intracranial mass; (3) **conservative management 24-48 hr** — bed rest, hydration (oral/IV), caffeine 200-300 mg PO BID, analgesia (acetaminophen, NSAIDs, sometimes opioids), antiemetic; abdominal binder; (4) **epidural blood patch (EBP)** — definitive treatment for moderate-severe persistent PDPH (≥ 48-72 hr or earlier if severe disability) — under sterile conditions, inject 15-20 mL autologous blood into epidural space at or just below puncture site → seals dural leak; ~ 70-90% effective first patch; may repeat if needed; (5) **avoid** — diuresis, dehydration; (6) **complications EBP** — back pain, transient infection, rare neurologic; (7) **prevention** — small-gauge pencil-point needles for spinal, careful technique for epidural, identify epidural with loss-of-resistance saline not air (controversial), recognize wet tap promptly + manage; (8) **other measures** — sphenopalatine ganglion block (lidocaine-soaked cotton, minimal risk), occipital nerve block, sumatriptan, hydrocortisone (limited evidence); (9) **follow-up** — most resolve days to weeks; chronic PDPH rare → re-evaluate; (10) document + counsel

---

PDPH: postural HA after dural puncture. Pencil-point needles ↓ risk. Conservative + EBP definitive. Exclude PE, CVST, meningitis. EBP 15-20 mL autologous blood. 70-90% response. Repeat if needed. Bed rest + caffeine + hydration adjunct. Postpartum CVST is critical differential — non-postural HA + neuro signs → imaging.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ASRA/Russell EBP; SOAP PDPH 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 28 ปี G1P1 postpartum d 2 — มาด้วยปวดศีรษะรุนแรง postural ↑ when sitting/standing ↓ supine + neck stiffness + photophobia × 24 ชม. Received spinal anesthesia for C/S 2 d ago

V/S: BP 122/76, HR 88, Temp 37.0
Gen: prefer supine, photophobic
Neuro: no focal deficit, no meningismus, no fever, no rash
Lab: WBC 9, CRP normal, LP not done (suspected PDPH not meningitis)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 65 ปี postmenopausal มาด้วย vulvar pruritus + white patches + thinning skin + dyspareunia × 1 yr — examined

V/S: BP 130/82, HR 78
Gen: well
Vulva: well-demarcated white plaques + atrophic thin skin + figure-of-8 pattern around vulva + perianal + loss of architecture (clitoral hood resorption + labia minora fusion partial)
Biopsy: lichen sclerosus (LS) — thin epidermis + hyalinization of upper dermis + lymphocytic infiltrate, no atypia', '[{"label":"A","text":"Discharge — observation"},{"label":"B","text":"Vulvar Lichen Sclerosus (LS)"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Vulvar Lichen Sclerosus (LS)** — chronic inflammatory dermatosis, most common postmenopausal women + some prepubertal girls; ~ 5% lifetime risk of vulvar SCC: (1) **first-line — high-potency topical corticosteroid**: **clobetasol propionate 0.05% ointment** — apply nightly × 6-12 wk → taper to 1-2×/wk maintenance; controls itch + inflammation + may reverse architectural changes; (2) **alternative** — tacrolimus or pimecrolimus (topical calcineurin inhibitors) for steroid-sparing maintenance; (3) **avoid** — irritants (perfumed soap, detergents), tight clothing, wipes; cotton underwear; (4) **emollients** (Vaseline) + mild cleansers + sitz baths; (5) **vaginal estrogen** for concurrent GSM (different pathology but coexists); (6) **follow-up** + biopsy + new/persistent/non-responding lesions → rule out **vulvar SCC** (5% lifetime risk); annual gyn exam; (7) **surgery NOT first-line** — destroys tissue; only for adhesions, severe phimosis affecting urination, or biopsy-proven malignancy; (8) **sexual function** — counseling, lubricants, gentle dilation; (9) **psychosocial** — significant QoL impact; support; (10) **prepubertal LS** — also clobetasol; usually improves at puberty; differential — sexual abuse (overlap appearance, evaluate); (11) **co-existing** autoimmune (thyroid, vitiligo, alopecia, pernicious anemia) — screen; (12) **other vulvar dermatoses** ddx — lichen planus (oral, vulvar with vaginal involvement), lichen simplex chronicus, candida, psoriasis, contact dermatitis, EMP, Paget — different management

---

Lichen sclerosus: postmenopausal, vulvar/perianal white plaques + architectural change. Clobetasol nightly → maintenance. Tacrolimus alternative. Avoid irritants. SCC risk 5% — biopsy concerning. No surgery first-line. Co-existing autoimmune screen. Counseling + emollients.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Committee Opinion 673: Vulvar Skin Care; British Association of Dermatologists Lichen Sclerosus', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 65 ปี postmenopausal มาด้วย vulvar pruritus + white patches + thinning skin + dyspareunia × 1 yr — examined

V/S: BP 130/82, HR 78
Gen: well
Vulva: well-demarcated white plaques + atrophic thin skin + figure-of-8 pattern around vulva + perianal + loss of architecture (clitoral hood resorption + labia minora fusion partial)
Biopsy: lichen sclerosus (LS) — thin epidermis + hyalinization of upper dermis + lymphocytic infiltrate, no atypia'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 32 ปี nulliparous มา OPD ตรวจคัดกรอง — family history sister breast cancer 38 yr + mother ovarian cancer 52 + maternal aunt breast cancer 45 — genetic testing pending

V/S: BP 118/74, HR 80
Gen: well, no breast mass, no adnexal mass
Mammogram + breast US: normal
Genetic testing (panel): BRCA1 pathogenic mutation positive', '[{"label":"A","text":"Ignore — no current cancer"},{"label":"B","text":"Hereditary Breast/Ovarian Cancer Syndrome (HBOC) — BRCA1 mutation"},{"label":"C","text":"Hysterectomy without considering options"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Refuse all care"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Hereditary Breast/Ovarian Cancer Syndrome (HBOC) — BRCA1 mutation** — lifetime risks: breast 50-85%, ovarian 40-60% (BRCA1) or 15-30% (BRCA2); also pancreatic, prostate, melanoma; (1) **multidisciplinary** — genetics + breast onc + gyn-onc + psychiatry; (2) **risk-reducing surgery — BSO**: (a) **risk-reducing salpingo-oophorectomy (RRSO)** recommended at age **35-40 (BRCA1)** or **40-45 (BRCA2)** after childbearing — reduces ovarian cancer 80-95%, breast 50%, all-cause mortality; (b) **risk-reducing mastectomy** option — reduces breast cancer > 90%; psychologic + cosmetic considerations; (3) **surveillance** if surgery deferred or before: (a) breast — clinical exam q 6-12 mo + annual MRI + mammography (alternating) from age 25-30 (start 5-10 yr before youngest family case); (b) ovarian — transvaginal US + CA-125 q 6 mo from 30-35 — limited sensitivity for early ovarian cancer (controversial — RRSO preferred when ready); (4) **chemoprevention** — tamoxifen (BRCA2 more benefit), aromatase inhibitor postmenopause; (5) **lifestyle** — exercise, weight, alcohol moderation, breastfeeding (if pregnancies); (6) **HRT post-RRSO** — for surgical menopause symptoms; short-term estrogen typically OK if no breast cancer (controversial — limited data; counseled benefit/risk); BSO before natural menopause → bone + CV + cognitive impact — HRT until natural menopause age commonly; (7) **reproductive options** — preserve fertility before surgery; **preimplantation genetic testing (PGT-M)** to avoid transmission; (8) **cascade testing** — first-degree relatives 50% risk; offer testing; (9) **insurance + employment** — discrimination concerns (US GINA; Thai variable); (10) **psychological support** + decision aids; (11) **other syndromes** — Lynch (endometrial + ovarian + colon), Li-Fraumeni (TP53), Cowden (PTEN), PALB2, ATM, CHEK2 — moderate-penetrance; (12) Thai context — National Cancer Institute genetic services growing

---

BRCA1 HBOC: lifetime breast 50-85% + ovarian 40-60%. Multidisciplinary. RRSO 35-40 BRCA1 / 40-45 BRCA2 after childbearing. Risk-reducing mastectomy option. Surveillance breast MRI + mammo + CA-125/US. Chemoprevention. HRT post-RRSO. PGT-M. Cascade testing.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'NCCN Genetic/Familial High-Risk Breast/Ovarian; ACOG Practice Bulletin 182', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 32 ปี nulliparous มา OPD ตรวจคัดกรอง — family history sister breast cancer 38 yr + mother ovarian cancer 52 + maternal aunt breast cancer 45 — genetic testing pending

V/S: BP 118/74, HR 80
Gen: well, no breast mass, no adnexal mass
Mammogram + breast US: normal
Genetic testing (panel): BRCA1 pathogenic mutation positive'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 40 ปี nulliparous มา OPD ตรวจคัดกรอง cervical cancer — last screening 5 yr ago normal Pap + HPV negative, no symptoms, well

V/S: BP 118/74, HR 80
Gen: well
Pelvic: WNL
Sexual history: monogamous × 10 yr', '[{"label":"A","text":"No screening needed"},{"label":"B","text":"Cervical cancer screening intervals — ASCCP/USPSTF/Thai guidelines"},{"label":"C","text":"Hysterectomy"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Discharge — no need"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Cervical cancer screening intervals — ASCCP/USPSTF/Thai guidelines**: (1) **screening strategies**: (a) **HPV primary** (preferred USPSTF + WHO) — HPV every 5 yr; (b) **co-testing (HPV + cytology)** every 5 yr; (c) **cytology alone** every 3 yr (alternative); (2) **age**: (a) **start at 21 (cytology) or 25 (HPV primary per ASCCP 2019)**; (b) **stop at 65** if adequate prior negative screening + no high-risk history; (c) **post-hysterectomy** with cervix removed + no history CIN2+ — discontinue; (d) **HIV/immunocompromised** — annual cytology from sexual debut to 65 then individualized; (3) **Thai screening** — Pap or HPV test as part of National Health Coverage; women 30-60 yr; some areas using HPV self-sampling pilots; VIA acceptable alternative low-resource (Thai also use); (4) **for this patient** (40 yr, normal Pap + HPV negative 5 yr ago) — **due for screening now** — HPV (preferred) or co-test; if negative → next in 5 yr; (5) **HPV vaccination** — primary prevention; Thai national program 9-valent or 4-valent for girls grade 5 (~ 11 yr); catch-up to 26; individualized 27-45; reduces high-grade disease; (6) **risk stratification** ASCCP 2019 — risk-based management; (7) **HPV test types** — high-risk genotypes 14 (16, 18, 31, 33, 35, 39, 45, 51, 52, 56, 58, 59, 66, 68); HPV 16/18 separate identification more aggressive workup; (8) **abnormal results** management — colposcopy + biopsy + treatment (LEEP, cone, ablation) per ASCCP risk; (9) **follow-up post-treatment CIN** — HPV + cytology q 6 mo × 2, then annual; (10) **future** — HPV self-sampling, DNA methylation, AI-assisted cytology emerging

---

Cervical cancer screening: HPV primary (preferred) or co-test every 5 yr 25-65 (or cyto alone q 3 yr from 21). Stop 65 if adequate negative + no risk. HIV annual. HPV vaccine prevention. ASCCP risk-based. Thai NHCo. VIA option low-resource. HPV self-sampling emerging.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'USPSTF Cervical Cancer Screening 2018; ASCCP 2019; WHO Cervical Cancer Elimination', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 40 ปี nulliparous มา OPD ตรวจคัดกรอง cervical cancer — last screening 5 yr ago normal Pap + HPV negative, no symptoms, well

V/S: BP 118/74, HR 80
Gen: well
Pelvic: WNL
Sexual history: monogamous × 10 yr'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 48 ปี perimenopausal มา OPD ด้วยอาการ intermenstrual bleeding + heavy menses × 4 mo, no postcoital bleeding, no pelvic pain

V/S: BP 124/78, HR 80
Gen: well
Pelvic: uterus normal size, no adnexal mass
US TV: endometrium 7 mm with focal thickening 8 mm + hyperechoic + intracavitary lesion 1.5 cm visible, no fibroid
SIS (saline infusion sono): confirms endometrial polyp 1.5 cm
Endometrial biopsy: secretory endometrium fragments + polyp fragment without atypia', '[{"label":"A","text":"Discharge — observation"},{"label":"B","text":"Endometrial Polyp (AUB-P)"},{"label":"C","text":"Hysterectomy"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Endometrial Polyp (AUB-P)** — focal benign overgrowth of endometrial tissue; risk factors: tamoxifen, HRT, obesity, HT, age; symptoms — AUB, intermenstrual, postmenopausal bleeding, infertility (interferes implantation): (1) **diagnosis** — TVS (focal thickening, vascular pedicle), SIS (saline infusion sono — most sensitive), hysteroscopy + biopsy (gold standard); (2) **management** — (a) **hysteroscopic polypectomy** — first-line treatment (diagnostic + therapeutic in one step); send for histology; (b) blind D&C — older + may miss polyp + leave tissue → not recommended; (c) **observation** acceptable for small (< 1 cm) asymptomatic, premenopausal — may regress; (3) **histology** — most benign (~ 95%); **malignancy risk**: ~ 1-2% premenopausal symptomatic, ~ 5-10% postmenopausal symptomatic + ↑ with age, size > 1.5 cm, HT, DM, tamoxifen; → all postmenopausal + symptomatic should be removed; (4) **infertility** — polypectomy improves implantation rates pre-IVF; (5) **AUB workup** — also consider PALM-COEIN — coagulopathy (vWD), ovulatory, endometrial (hyperplasia/cancer), iatrogenic (anticoagulants, IUD), structural; (6) **endometrial sampling** — postmenopausal bleeding any thickness or premenopausal AUB > 45 yr or risk factors → sample; (7) **recurrence** — ~ 13-43%; surveillance; (8) **adjuvant** — LNG-IUD reduces recurrence in tamoxifen-treated patients; (9) **counseling** — explain benign nature, malignancy ddx, future fertility, follow-up; (10) **other PALM-COEIN AUB causes**: A (adenomyosis), L (leiomyoma), M (malignancy + hyperplasia)

---

Endometrial polyp: AUB-P. SIS most sensitive. Hysteroscopic polypectomy diagnostic + therapeutic. Malignancy risk 1-10% (↑ postmenopausal). Tamoxifen-related — LNG-IUD reduces. Recurrence common. PALM-COEIN AUB workup including sampling > 45 yr or postmenopausal.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'AAGL Practice Report on Endometrial Polyps 2012; FIGO PALM-COEIN', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 48 ปี perimenopausal มา OPD ด้วยอาการ intermenstrual bleeding + heavy menses × 4 mo, no postcoital bleeding, no pelvic pain

V/S: BP 124/78, HR 80
Gen: well
Pelvic: uterus normal size, no adnexal mass
US TV: endometrium 7 mm with focal thickening 8 mm + hyperechoic + intracavitary lesion 1.5 cm visible, no fibroid
SIS (saline infusion sono): confirms endometrial polyp 1.5 cm
Endometrial biopsy: secretory endometrium fragments + polyp fragment without atypia'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 70 ปี postmenopausal มาด้วยอาการ vaginal bleeding + mass — biopsy: vaginal SCC stage II (involves paravaginal tissue) — pelvic exam tumor 3 cm distal vagina + parametrial involvement clinical

V/S: BP 134/82, HR 80
Gen: well
MRI: 3 cm distal vagina + paravaginal tissue + no nodes
CT: no metastasis', '[{"label":"A","text":"Discharge — observation"},{"label":"B","text":"staging FIGO"},{"label":"C","text":"Hysterectomy without staging"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Vaginal cancer** (rare — ~ 1-2% of GYN malignancies; primary vagina = no involvement of cervix or vulva; SCC most common ~ 85%; adenocarcinoma DES-related historically; clear cell DES exposure; melanoma; sarcoma): (1) **staging FIGO**: I — vaginal wall; II — paravaginal; III — pelvic sidewall; IVA — bladder/rectum; IVB — distant; (2) **risk factors** — HPV (high-risk genotypes), prior cervical/vulvar cancer or VAIN, DES (clear cell), smoking, immunosuppression, age; (3) **management by stage + location**: (a) **stage I upper third** — partial vaginectomy + lymphadenectomy (similar to cervical cancer) OR brachytherapy; (b) **stage I lower third** — wide excision + inguinal lymphadenectomy; (c) **stage II-IVA** — **concurrent chemoradiation (CRT)** — external beam pelvic + brachytherapy + cisplatin chemo (similar to cervical cancer); (d) **stage IVB** — palliative chemo + RT; (4) **fertility-sparing** — limited options given typical demographics; (5) **HPV vaccination** — primary prevention; (6) **VAIN treatment** prevents progression — topical 5-FU, laser, excision; (7) **follow-up** — exam + symptoms q 3-6 mo × 2 yr → q 6 mo × 3 yr → annual; (8) **prognosis** — stage I 5-yr ~ 80%, II ~ 50-60%, III ~ 30-40%, IV ~ 10-20%; (9) **multidisciplinary** + supportive care; (10) **vaginal fibrosis + stenosis** post-RT — dilator + vaginal estrogen; (11) **prevention** — HPV vaccine + cervical/vaginal screening; pelvic exam in DES daughters at higher risk

---

Vaginal cancer: rare. HPV-related SCC. FIGO staging. Stage I — surgery or brachytherapy; II-IVA — CRT (similar to cervical). Multidisciplinary. HPV vaccination prevention. VAIN treatment. Post-RT: vaginal dilator + estrogen.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'FIGO Vaginal Cancer Staging; NCCN Vaginal Cancer', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 70 ปี postmenopausal มาด้วยอาการ vaginal bleeding + mass — biopsy: vaginal SCC stage II (involves paravaginal tissue) — pelvic exam tumor 3 cm distal vagina + parametrial involvement clinical

V/S: BP 134/82, HR 80
Gen: well
MRI: 3 cm distal vagina + paravaginal tissue + no nodes
CT: no metastasis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 30 ปี G2P2 NSD 6 wk postpartum มา OPD ตรวจ postpartum visit — no complaints, breastfeeding well

V/S: BP 122/76, HR 76
Gen: well, healed perineal repair
Fetal/Baby: thriving, breastfeeding well
No bleeding, no infection', '[{"label":"A","text":"No examination needed"},{"label":"B","text":"Postpartum 6-week visit"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Postpartum 6-week visit** (the ''4th trimester'' — comprehensive postpartum care): (1) **maternal physical** — (a) **BP** + screen postpartum HT (esp if had HT/PE), continue antihypertensive if needed; (b) **uterine involution** — normal size by 6 wk; (c) **lochia** completed; (d) **perineum + C/S incision** healed; (e) **breast** — exam, lactation; (f) **pelvic exam** if indicated (POP, dyspareunia, healing); (2) **mental health screening** — **Edinburgh Postnatal Depression Scale (EPDS)** or PHQ-9 — postpartum depression 10-15%, anxiety, PTSD, psychosis (rare); refer if positive; (3) **contraception** — discuss options: LARC (IUD/implant insertion at this visit common), DMPA, POP, COCP (if not breastfeeding < 6 wk; relative contraindication if exclusive breastfeeding < 6 mo due to milk supply concern), barrier, sterilization; LAM if exclusive BF + amenorrhea + < 6 mo; (4) **breastfeeding** support — supply, latch, problems, weaning plans; lactation consultant; (5) **sexual health** — resumption, dyspareunia (atrophy if breastfeeding — vaginal lubricant), libido, intimate partner relationship; (6) **interpregnancy interval** counseling — optimum > 18-24 mo between pregnancies (reduces preterm, FGR, abruption); (7) **chronic disease follow-up**: (a) **GDM** — 6-12 wk OGTT + lifelong T2DM screening + lifestyle modification; (b) **HT/PE** — BP monitoring + CV risk counseling (4× future CVD); (c) **pregnancy complication** — counseling future pregnancy management (recurrent PE, preterm); (8) **immunizations** — Tdap if not given in pregnancy, MMR/VZV (if non-immune, not while breastfeeding limit), HPV if eligible, COVID/flu; (9) **return to work + childcare** + sleep + social support; (10) **screening** — cervical, breast self-awareness, intimate partner violence, social determinants; (11) **infant** referral — pediatric well-child care, immunizations; (12) **transition to primary care** + reproductive life planning; (13) **ACOG redefines** as transition with earlier visit 2-3 wk + comprehensive 12-wk visit instead of just one 6-wk visit

---

Postpartum 4th-trimester visit: comprehensive — BP, mental health (EPDS), contraception (LARC + LAM), breastfeeding, sex, IPI counseling, chronic disease (GDM OGTT, HT), vaccines, infant care, primary care transition. ACOG now recommends earlier 2-3 wk visit + comprehensive 12 wk.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Committee Opinion 736: Optimizing Postpartum Care 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 30 ปี G2P2 NSD 6 wk postpartum มา OPD ตรวจ postpartum visit — no complaints, breastfeeding well

V/S: BP 122/76, HR 76
Gen: well, healed perineal repair
Fetal/Baby: thriving, breastfeeding well
No bleeding, no infection'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 28 ปี G0P0 PCOS oligomenorrhea + obesity (BMI 32) + insulin resistance + infertility 18 mo — couple ready for ovulation induction

V/S: BP 124/78, HR 80
Gen: BMI 32, hirsutism, acanthosis nigricans
Lab: T total mildly high, FSH 5, LH 12, AMH 8 (high), TSH normal, prolactin normal
Partner semen analysis normal
HSG bilateral tubal patency', '[{"label":"A","text":"No treatment"},{"label":"B","text":"PCOS infertility — ovulation induction"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Discharge — never can conceive"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **PCOS infertility — ovulation induction**: (1) **lifestyle** — **weight loss 5-10%** improves cycles + ovulation + insulin resistance + pregnancy outcomes — first-line; supervised diet + exercise; (2) **first-line ovulation induction — letrozole** 2.5-7.5 mg/d × 5 days (d 3-7 or 2-6) — PCOS Network/ASRM/ACOG preferred over clomiphene (PPCOS II — letrozole superior ovulation + live birth in PCOS); aromatase inhibitor → ↓ estrogen → ↑ FSH → follicular recruitment; (3) **clomiphene citrate** 50-150 mg/d × 5 d — SERM, antiestrogen — alternative; ↓ live birth than letrozole in PCOS; clomiphene-resistant ~ 25%; (4) **metformin** — alone or adjunct — modest effect in PCOS; helpful if insulin resistance, weight loss adjunct; not significantly improve live birth alone; combination with letrozole/clomiphene may help in some; (5) **gonadotropins (FSH ± LH)** — for letrozole/clomiphene failure — risk OHSS + multiple gestation — close monitoring (US + estradiol); (6) **laparoscopic ovarian drilling** — alternative for clomiphene-resistant PCOS; reduces androgen production, restores ovulation; reduces multiple gestation risk vs gonadotropins; (7) **IVF** — for failure of above, age, other infertility factors, OHSS prevention with antagonist protocol + agonist trigger + freeze-all; (8) **monitoring** — US follicle tracking + ovulation confirmation; pregnancy testing; (9) **risks** — OHSS, multiple gestation (especially gonadotropins), pregnancy in PCOS — ↑ GDM, PE, miscarriage, preterm, macrosomia; (10) **counseling** — realistic expectations, stress management, partner involvement; (11) **once pregnant** — early US (dating, viability), GDM screening 24-28 wk + earlier if high risk, growth surveillance

---

PCOS infertility: weight loss first. Letrozole first-line OI (PPCOS II) > clomiphene. Metformin adjunct esp obese/IR. Gonadotropins if fail (OHSS + multiple risk). Ovarian drilling alternative. IVF refractory + freeze-all OHSS prevention. PCOS pregnancy ↑ GDM/PE.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'International PCOS Guideline 2023; PPCOS II Trial Legro NEJM 2014', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 28 ปี G0P0 PCOS oligomenorrhea + obesity (BMI 32) + insulin resistance + infertility 18 mo — couple ready for ovulation induction

V/S: BP 124/78, HR 80
Gen: BMI 32, hirsutism, acanthosis nigricans
Lab: T total mildly high, FSH 5, LH 12, AMH 8 (high), TSH normal, prolactin normal
Partner semen analysis normal
HSG bilateral tubal patency'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงตั้งครรภ์ G1P0 GA 22 wk routine anatomy US — fetal congenital diaphragmatic hernia (CDH) — left-sided, liver up, lung-to-head ratio (LHR) o/e 35% (severe)

V/S: BP 116/72, HR 80
Gen: well
Fetal: heart 144, otherwise normal anatomy except CDH, no other anomalies, normal karyotype + microarray
MRI fetal: confirms CDH + lung volumes', '[{"label":"A","text":"Terminate pregnancy"},{"label":"B","text":"Congenital Diaphragmatic Hernia (CDH)"},{"label":"C","text":"Cesarean immediately"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Hysterectomy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Congenital Diaphragmatic Hernia (CDH)** — abdominal contents herniate into thorax through diaphragmatic defect (Bochdalek 90% posterolateral, Morgagni 10% anterior); pulmonary hypoplasia + pulmonary HT = main mortality drivers: (1) **prenatal counseling — multidisciplinary** (MFM + neonatology + pediatric surgery + cardiac + genetics + ethics + family); (2) **assessment severity** — **LHR (lung-area-to-head circumference ratio) observed/expected** — o/e LHR < 25% severe, 25-45% moderate, > 45% mild; liver position (up = worse), MRI fetal lung volume, side (left more common, less severe than right), associated anomalies (karyotype, CMA — 30-40% genetic syndromes); (3) **outcomes counseling** — survival depends on severity + center experience; severe LHR o/e < 25% historic survival 10-30%; with **fetoscopic endoluminal tracheal occlusion (FETO)** — RCTs (TOTAL trial 2021) show improved survival in severe left CDH; in fetal therapy centers; (4) **antenatal management** — serial growth + monitoring; corticosteroid if preterm; FETO if eligible + severe; (5) **delivery planning** — **tertiary center with ECMO + ped surgery + NICU**; usually term unless complications; vaginal acceptable; immediate neonatal team; (6) **immediate neonatal management** — **DO NOT use bag-mask ventilation** (inflates stomach in thorax — worsens lung compression); **immediate intubation** + gentle ventilation + decompress stomach with NG; permissive hypercapnia, lung-protective strategy; pulmonary HT management (iNO, sildenafil, milrinone); ECMO if refractory; (7) **surgery** — delayed (after stabilization, typically days to 2 wk) — repair defect ± patch; multidisciplinary timing; (8) **prognosis** — pulmonary hypoplasia + PH degree; long-term: feeding issues, GERD, scoliosis, neurodevelopmental, recurrent infections; (9) **counseling** — termination remains option per Thai legal framework for severe anomalies; continue with comfort/palliative if family prefers; (10) **support groups + family resources**

---

Fetal CDH: pulmonary hypoplasia + PH = mortality. LHR o/e severity assessment. FETO (TOTAL trial) improves survival severe left CDH. Delivery tertiary with ECMO + ped surgery. NO bag-mask at birth (stomach inflates). Immediate intubation + decompress + gentle ventilation. Delayed surgical repair. Multidisciplinary counseling including termination option.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'TOTAL Trial NEJM 2021; CDH EURO Consortium Consensus 2016', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงตั้งครรภ์ G1P0 GA 22 wk routine anatomy US — fetal congenital diaphragmatic hernia (CDH) — left-sided, liver up, lung-to-head ratio (LHR) o/e 35% (severe)

V/S: BP 116/72, HR 80
Gen: well
Fetal: heart 144, otherwise normal anatomy except CDH, no other anomalies, normal karyotype + microarray
MRI fetal: confirms CDH + lung volumes'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงตั้งครรภ์ G1P0 GA 18 wk — anatomy scan: open spina bifida (myelomeningocele) at L5-S1 + Chiari II + ventriculomegaly + lemon sign (frontal bone deformity) + banana sign (cerebellum)

V/S: BP 116/72, HR 78
Gen: well
Fetal: confirmed open MMC, otherwise normal anatomy, normal karyotype + AFAFP elevated
No other anomalies', '[{"label":"A","text":"Terminate without counseling"},{"label":"B","text":"Fetal myelomeningocele (open spina bifida)"},{"label":"C","text":"Cesarean immediately"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Hysterectomy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Fetal myelomeningocele (open spina bifida)** — counseling + intervention options: (1) **multidisciplinary counseling** — MFM + neurosurgery + pediatric surgery + neonatology + genetics + rehabilitation + family — discuss natural history, outcomes, options; (2) **natural history** — Chiari II malformation + hydrocephalus (~ 80% need shunt) + variable lower extremity weakness + neurogenic bladder/bowel + skin issues + cognitive (often normal IQ but learning disabilities); life expectancy improving; (3) **options**: (a) **continuation with planned cesarean at term + postnatal surgical closure within 48 hr** — traditional; (b) **fetal surgery (MOMS trial) — prenatal MMC repair** at 19-25+6 wk in select cases — **reduces need for shunt (40% vs 82%) + improves motor function + improves Chiari II + reverses hindbrain herniation**; criteria — singleton, GA 19-25+6 wk, lesion T1-S1, no kyphosis > 30°, no other anomalies, normal karyotype, no maternal contraindication (BMI < 35, no prior preterm < 37 wk); risks: preterm birth, ROM, uterine dehiscence, future C/S only; (c) **termination of pregnancy** — legal in Thailand for severe fetal anomalies per Medical Council; (d) **expectant + palliative** if family chooses; (4) **fetal surgery centers** — limited in Thailand, may refer regional/international; (5) **delivery** — planned cesarean at term (38 wk) to protect spine if fetal surgery not done or hadn''t done well; vaginal acceptable per some data if not large lesion + no other indication; (6) **prevention** — **folic acid 4-5 mg/d preconception** (high-dose because high risk recurrence); reduces 70% NTD; (7) **postnatal management** — multidisciplinary lifelong (neurosurgery shunt, urology, ortho, PT, education); (8) **recurrence** — 3-4% next pregnancy → high-dose folate + early US + AFP/amnio; (9) **counseling** — informed choice, autonomy, no coercion; (10) MOMS trial criteria + fetal therapy referral if interested

---

Open MMC: multidisciplinary counseling. Options: postnatal repair, prenatal fetal surgery (MOMS trial — reduces shunt + improves motor + Chiari), termination, palliative. Prenatal surgery 19-25+6 wk select criteria. Planned C/S term if postnatal. High-dose folate prevention + next pregnancy. Lifelong multidisciplinary care.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'MOMS Trial NEJM 2011; ACOG Committee Opinion 720: Maternal-Fetal Surgery', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงตั้งครรภ์ G1P0 GA 18 wk — anatomy scan: open spina bifida (myelomeningocele) at L5-S1 + Chiari II + ventriculomegaly + lemon sign (frontal bone deformity) + banana sign (cerebellum)

V/S: BP 116/72, HR 78
Gen: well
Fetal: confirmed open MMC, otherwise normal anatomy, normal karyotype + AFAFP elevated
No other anomalies'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 14 ปี nulligravid มา OPD ด้วยอาการประจำเดือนผิดปกติ — irregular cycles since menarche 2 yr ago + HMB + dysmenorrhea + 1 month soaking pads + Hb 8.2

V/S: BP 102/68, HR 100
Gen: pallor, no acne/hirsutism, no thyroid
Pelvic: deferred (virgin) — exam external WNL
Lab: β-hCG negative, TSH normal, prolactin normal, vWF Ag + factor VIII + ristocetin cofactor: vWF Ag 35% (mildly low) + RistoCof 32% (low) → von Willebrand disease type 1', '[{"label":"A","text":"Hysterectomy"},{"label":"B","text":"Adolescent HMB with von Willebrand disease (vWD type 1)"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Adolescent HMB with von Willebrand disease (vWD type 1)** — most common bleeding disorder (1%), often underdiagnosed in HMB; ~ 13% of adolescents with HMB have bleeding disorder: (1) **multidisciplinary** — Adolescent Gyn + Hematology; (2) **acute HMB management** — high-dose hormonal: **COCP (continuous high-dose pill — 1 pill BID-TID × 7 d then taper)** OR **high-dose oral progestin** (MPA 20 mg TID × 7 d then taper); **tranexamic acid 1 g PO TID** (effective in vWD + HMB — antifibrinolytic, safe); **IV conjugated estrogen 25 mg q 4-6 hr × 24 hr** for severe; iron supplementation; transfusion if needed; (3) **vWD-specific therapy** for severe bleeding or surgery — **DDAVP (desmopressin) 0.3 mcg/kg IV/SC** — releases vWF from endothelium (effective in type 1; not type 3, variable type 2); **vWF concentrate (Humate-P)** for severe; (4) **maintenance therapy** — (a) **LNG-IUD (Mirena)** — first-line for chronic HMB even in nullip adolescents; ↓ blood loss > 90%; placement may need anesthesia in virgin adolescent; (b) **COCP** continuous or extended cycle — also contraception + cycle regulation; (c) **progestin-only** (POP, DMPA, implant) — if estrogen contraindicated; (d) **tranexamic acid during menses** 1 g TID × 5 d; (5) **family screening** — vWD autosomal dominant; cascade testing first-degree relatives; (6) **lifestyle** — avoid NSAIDs (worsen bleeding — use acetaminophen for dysmenorrhea), aspirin, anticoagulants; medical alert; (7) **pre-procedure/surgery planning** — hematology consult; pre-op DDAVP/vWF concentrate; tranexamic acid; (8) **adolescent-friendly + confidential** + parent involvement; (9) **education** — bleeding disorder, future pregnancy management, dental care; (10) **iron** — PO + IV; (11) **long-term follow-up** — gynecology + hematology

---

Adolescent HMB: workup for bleeding disorder (vWD ~ 13%). Acute: COCP/progestin high-dose, TXA, IV estrogen severe. vWD-specific: DDAVP, vWF concentrate. Maintenance: LNG-IUD, COCP, TXA. Family screening. Avoid NSAIDs/aspirin. Multidisciplinary. Adolescent-friendly.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Committee Opinion 580: Von Willebrand Disease in Women; NHF Adolescent vWD', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 14 ปี nulligravid มา OPD ด้วยอาการประจำเดือนผิดปกติ — irregular cycles since menarche 2 yr ago + HMB + dysmenorrhea + 1 month soaking pads + Hb 8.2

V/S: BP 102/68, HR 100
Gen: pallor, no acne/hirsutism, no thyroid
Pelvic: deferred (virgin) — exam external WNL
Lab: β-hCG negative, TSH normal, prolactin normal, vWF Ag + factor VIII + ristocetin cofactor: vWF Ag 35% (mildly low) + RistoCof 32% (low) → von Willebrand disease type 1'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามอาจารย์เรื่อง peripartum hemodynamics — labor + immediate postpartum cardiovascular changes', '[{"label":"A","text":"BP and CO unchanged in labor"},{"label":"B","text":"Peripartum hemodynamic shifts"},{"label":"C","text":"Spinal anesthesia reduces hemodynamic stress"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Uterine atony improves CO"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Peripartum hemodynamic shifts: (1) **labor 1st stage** — uterine contractions → 300-500 mL blood **autotransfused from uterus to circulation** with each contraction; ↑ cardiac output ~ 20% during contraction; ↑ BP 10-20 mmHg with each contraction; ↑ HR; sympathetic + pain + anxiety contribute; epidural blunts; (2) **labor 2nd stage** — Valsalva pushing → fluctuating preload/afterload; pain → catecholamines; cumulative CO ↑ ~ 50% above pre-pregnancy; (3) **immediately after delivery (3rd stage + early 4th stage)** — placental delivery → loss of low-resistance uteroplacental circuit → ↑ SVR; **autotransfusion 500 mL from contracted uterus → preload increase**; ↑ CO acutely 60-80% above pre-pregnancy for ~ 10-30 min; aortocaval compression relieved (return preload further); **risk decompensation in cardiac disease** here (highest risk delivery + immediate postpartum); (4) **first 24-48 hr postpartum** — diuresis (mobilization of third-space fluid) + lochia + insensible loss; gradual ↓ CO + BP back toward baseline; **risk pulmonary edema in heart disease/severe preeclampsia 24-72 hr postpartum**; (5) **HR** — gradual return to baseline over 1-2 wk; CO returns by 2 wk; (6) **postpartum 1-6 wk** — gradual return of plasma volume, RBC mass, SVR, hormones; uterine involution complete 6 wk; (7) **clinical implications**: (a) **cardiac disease delivery planning** — multidisciplinary, epidural (smooth hemodynamics + assisted 2nd stage to limit Valsalva), avoid aortocaval (LUD), avoid rapid bolus, careful uterotonics (ergometrine vasoconstriction CI in HT/preeclampsia/CAD; carboprost bronchospasm asthma); (b) **postpartum monitoring** — high risk first 24-72 hr — fluid balance, BP, oxygenation, telemetry; (c) **pulmonary edema** risk peripartum; (d) **VTE highest risk first 6 wk postpartum**; (8) **postpartum cardiomyopathy** — present anywhere from late pregnancy to 5 mo postpartum

---

Peripartum hemodynamics: CO ↑ during labor (autotransfusion + sympathetic), peaks immediately postpartum (loss of placental circuit + autotransfusion + relief aortocaval). Risk of cardiac decompensation + pulmonary edema highest in immediate postpartum. Cardiac disease — epidural + assisted 2nd stage + multidisciplinary + monitor 24-72 hr. VTE risk first 6 wk.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'basic_science', 'obgyn', 'adult',
  'Williams Obstetrics Ch 4; ESC Pregnancy + Cardiovascular Disease 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Resident ถามอาจารย์เรื่อง peripartum hemodynamics — labor + immediate postpartum cardiovascular changes'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามอาจารย์เรื่อง glucose metabolism in pregnancy + GDM pathophysiology', '[{"label":"A","text":"Insulin sensitivity unchanged"},{"label":"B","text":"Glucose metabolism in pregnancy"},{"label":"C","text":"GDM caused by maternal insulin overproduction"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"No fetal effect of hyperglycemia"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Glucose metabolism in pregnancy: (1) **early pregnancy** — ↑ insulin sensitivity + ↑ insulin secretion → maternal glycogen + fat storage; fasting glucose ↓ slightly (~ 5-10 mg/dL — fetal/placental glucose demand); (2) **late 2nd-3rd trimester — insulin resistance ↑ 2-3×** due to **placental hormones**: human placental lactogen (hPL), progesterone, prolactin, cortisol, TNF-α, leptin; (3) **normal compensation** — β-cell hyperplasia + insulin secretion ↑ 2-3×; maintains normoglycemia; (4) **GDM** — inadequate β-cell compensation for insulin resistance → hyperglycemia in late pregnancy; risk factors: prior GDM, family DM, obesity, age > 35, ethnicity (Asian ↑), PCOS, prior macrosomia, polyhydramnios; (5) **fetal effects** — maternal hyperglycemia → fetal hyperglycemia (placental glucose transport) → fetal hyperinsulinemia → macrosomia (insulin = anabolic growth factor) + organomegaly + delayed lung maturation (insulin antagonizes cortisol → ↓ surfactant) + neonatal hypoglycemia (insulin persists after birth without glucose supply) + polycythemia (chronic hypoxia stimulates erythropoiesis) + hypocalcemia + hyperbilirubinemia; **stillbirth** risk in poorly controlled; **congenital anomalies** mostly with pregestational DM (organogenesis before GDM dx); (6) **screening** — universal 24-28 wk; (a) 1-step 75g OGTT (IADPSG/ADA — fasting ≥ 92, 1h ≥ 180, 2h ≥ 153 — any 1) — broader detection; (b) 2-step: 50g GCT non-fasting → if abnormal → 100g 3h OGTT (Carpenter-Coustan or NDDG); Thai widely use 100g 3h after 50g screen; (7) **management** — MNT + exercise → insulin if MNT fails; targets fasting < 95, 1h < 140, 2h < 120; (8) **postpartum OGTT 6-12 wk** — 50% develop T2DM lifetime → lifestyle + screen annually; future GDM recurrence; (9) **pregnancy DM2 first dx pregnancy** — may be preexisting unrecognized; ADA recommends 1st-trimester A1c in high-risk; (10) **macrosomia threshold + shoulder dystocia + C/S risks**

---

Pregnancy glucose: early ↑ sensitivity; late insulin resistance from placental hormones (hPL, etc.). GDM = inadequate β-cell compensation. Fetal hyperinsulinemia → macrosomia, hypoglycemia, polycythemia, delayed lung. Screening 24-28 wk OGTT. MNT first, insulin if fail. Postpartum OGTT 6-12 wk. T2DM risk.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'basic_science', 'obgyn', 'adult',
  'Williams Obstetrics Ch 57; ADA Standards 2024', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Resident ถามอาจารย์เรื่อง glucose metabolism in pregnancy + GDM pathophysiology'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามอาจารย์เรื่อง cervical ripening + labor initiation physiology', '[{"label":"A","text":"Cervical ripening is purely mechanical"},{"label":"B","text":"Cervical ripening + labor initiation"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Oxytocin causes ripening directly"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cervical ripening + labor initiation: (1) **cervix** anatomy — mostly extracellular matrix (collagen I + III, proteoglycans, water); rich in inflammatory cells late pregnancy; transforms from firm closed barrier to soft compliant tube; (2) **late pregnancy biochemical changes** — collagen degradation (↑ matrix metalloproteinases MMP-1, MMP-8), ↓ collagen cross-linking, ↑ glycosaminoglycans (hyaluronan, decorin), inflammatory infiltrate (neutrophils, macrophages → cytokines), water content ↑; (3) **hormones**: (a) **progesterone withdrawal** (relative — functional via PR isoforms) — uterine quiescence ↓, cervix ripens; (b) **estrogen** — ↑ oxytocin receptor + connexin-43 (gap junctions) + PG synthesis; (c) **prostaglandins** (PGE2, PGF2α) — cervical softening + uterine contraction; (d) **CRH** placental → cortisol → cascade; (e) **oxytocin + receptor density** ↑ near term + labor; (4) **stages of cervical change**: softening (consistency), ripening (collagen + water), dilation (active labor); Bishop score quantifies; (5) **labor initiation** — multifactorial; (a) **fetal endocrine signal** — fetal hypothalamic-pituitary-adrenal axis → cortisol → placental ↑ CRH + estriol; (b) **uterine stretch** — gap junctions + receptors; (c) **inflammation** — local + systemic; (d) **circadian** — labor more often at night (melatonin); (6) **uterine contractility** — Ca²⁺-mediated; gap junctions (connexin-43) synchronize myocytes → coordinated contractions; oxytocin + PG amplify; (7) **clinical induction** — **Foley balloon** (mechanical — stretch + PG release endogenous), **PG analogs** (misoprostol, dinoprostone — pharmacologic ripening), **oxytocin** (after favorable cervix); **mifepristone (anti-progesterone)** used for IUFD induction; (8) **Bishop score components** — dilation, effacement, station, consistency, position; > 6-8 favorable; (9) **research** — biomarkers of imminent labor (cervical length, fFN, cytokines, lipidomics)

---

Cervical ripening: collagen breakdown + hyaluronan + inflammation. Labor: progesterone withdrawal + estrogen + PG + CRH cascade + fetal HPA. Multifactorial. Clinical induction: Foley, PG, oxytocin. Bishop score predicts success. Connexin-43 gap junctions coordinate myometrium.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'basic_science', 'obgyn', 'adult',
  'Williams Obstetrics Ch 21; Norwitz Obstetrics 9e', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Resident ถามอาจารย์เรื่อง cervical ripening + labor initiation physiology'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามอาจารย์เรื่อง pharmacology — menopausal HT + selective receptor modulators (SERMs, SPRMs)', '[{"label":"A","text":"All hormones equally safe"},{"label":"B","text":"Menopausal HT pharmacology"},{"label":"C","text":"Tamoxifen agonist in breast"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"SERMs all the same"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Menopausal HT pharmacology** + SERMs/SPRMs: (1) **estrogens**: (a) **conjugated equine estrogen (Premarin)** — oral, mixed estrogenic, weak androgens; (b) **estradiol** (oral, transdermal patch, gel, spray, vaginal); transdermal preferred — bypass first-pass hepatic, lower VTE/stroke risk; (c) **vaginal** (cream, ring, tablet, DHEA prasterone) — local for GSM, minimal systemic; (2) **progestins** (essential with intact uterus to oppose estrogen → prevent hyperplasia/cancer): (a) **micronized progesterone** (Prometrium) — preferred safety profile (breast, CV, sleep); (b) **medroxyprogesterone acetate (MPA)** — older synthetic, WHI used; (c) **norethindrone, dydrogesterone** also used; **LNG-IUD** as progestin component option; (3) **combination products** — patches (e.g., Combipatch); pill regimens (cyclic vs continuous); (4) **SERMs (Selective Estrogen Receptor Modulators)** — tissue-specific agonist/antagonist: (a) **tamoxifen** — breast antagonist (cancer treatment + prevention high-risk); endometrial AGONIST (→ ↑ endometrial cancer + polyps + sarcoma — monitor); bone agonist (postmenopausal); ↑ VTE + stroke; vasomotor symptoms ↑; (b) **raloxifene** — breast antagonist (cancer prevention high-risk postmenopausal); bone agonist (osteoporosis); endometrial neutral; ↑ VTE; vasomotor symptoms; (c) **ospemifene** — vaginal AGONIST (GSM dyspareunia treatment); endometrial slight agonist (monitor); (d) **bazedoxifene + CEE (Duavee)** — combined for menopausal + bone; no progestin needed; (5) **SPRMs (Selective Progesterone Receptor Modulators)**: (a) **ulipristal acetate** — emergency contraception + fibroid (hepatotoxicity restriction); (b) **mifepristone** — abortion + Cushing; (6) **bisphosphonates** + **denosumab** + **teriparatide** + **romosozumab** — bone (covered separately); (7) **non-hormonal VMS**: SSRIs/SNRIs (paroxetine, venlafaxine), gabapentin, oxybutynin, clonidine, **fezolinetant** (NK3R antagonist — new 2023); (8) **testosterone** — off-label for female HSDD postmenopausal — low dose, monitor; (9) **risks** — VTE (oral > transdermal), stroke, breast (combined > estrogen only), gallbladder; (10) **WHI reinterpretation** — early initiation (within 10 yr of menopause / < 60 yr) more favorable risk-benefit; individualized

---

Menopausal HT: estrogen (oral + transdermal + vaginal) + progestin (micronized preferred) for uterus. Transdermal lower VTE. SERMs tissue-selective: tamoxifen (breast antagonist + endometrial agonist), raloxifene (breast + endometrial neutral + bone), ospemifene (vaginal). SPRMs: ulipristal, mifepristone. Non-hormonal VMS: SSRIs, gabapentin, fezolinetant. Individualized.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'basic_science', 'obgyn', 'adult',
  'NAMS 2022 HT Position Statement; Goodman & Gilman', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Resident ถามอาจารย์เรื่อง pharmacology — menopausal HT + selective receptor modulators (SERMs, SPRMs)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามอาจารย์เรื่อง maternal immunology + tolerance of fetus + autoimmune in pregnancy', '[{"label":"A","text":"Maternal immune system rejects fetus"},{"label":"B","text":"Maternal-fetal immunology"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"All autoimmune worsens in pregnancy"},{"label":"E","text":"Hysterectomy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Maternal-fetal immunology: (1) **fetus = semi-allograft** (50% paternal antigens); maternal immune system tolerates rather than rejects via multiple mechanisms; (2) **maternal-fetal interface** — trophoblast (no classical HLA-A/B, expresses HLA-G/E/F + non-classical), decidua (specialized immune cells), syncytiotrophoblast barrier; (3) **immune tolerance mechanisms**: (a) **regulatory T cells (Tregs)** ↑ — anti-inflammatory; (b) **Th1/Th2 shift** — Th2-biased (anti-inflammatory) during pregnancy; (c) **HLA-G on trophoblast** — inhibits NK + T cells; (d) **uterine NK cells** (uNK — different from peripheral NK) — promote spiral artery remodeling, support not attack trophoblast; (e) **indoleamine 2,3-dioxygenase (IDO)** — depletes tryptophan, inhibits T cell; (f) **progesterone** — immunomodulatory (PIBF, regulates cytokines); (g) **complement regulation** — DAF, MCP, CD59 on trophoblast prevent complement-mediated damage; (4) **trimester immune phases** — 1st trimester pro-inflammatory (implantation), 2nd trimester anti-inflammatory (growth), 3rd trimester pro-inflammatory (labor preparation); (5) **autoimmune diseases** — variable: (a) **flare/improve** — RA often improves (Th2 shift), SLE variable, MS often improves, AS may worsen; (b) **postpartum flares common** — return to baseline immune state; (c) **thyroiditis postpartum** common; (6) **alloimmune complications**: (a) **Rh isoimmunization** — IgG anti-D crosses placenta — hemolytic disease of newborn; (b) **fetal/neonatal alloimmune thrombocytopenia (FNAIT)** — anti-HPA-1a IgG; (c) **neonatal lupus** — anti-Ro/La cross placenta — congenital heart block; (d) **antiphospholipid syndrome (APS)** — recurrent loss, thrombosis; (7) **infection susceptibility** — pregnancy ↑ severity of certain (influenza, varicella, listeria, malaria, COVID-19) due to altered immunity; (8) **vaccines** — inactivated safe (flu, Tdap, COVID); live attenuated avoided (MMR, varicella — pre-pregnancy or postpartum); (9) **HIV** — pregnancy doesn''t worsen disease; vertical transmission key concern; (10) **HELLP/preeclampsia** — abnormal trophoblast invasion + immune dysregulation

---

Maternal-fetal immunology: tolerance via Tregs, Th2 shift, HLA-G, uNK, IDO, progesterone, complement regulation. Trophoblast invasion. Trimester phases. Autoimmune variable in pregnancy; postpartum flares. Alloimmune: Rh, FNAIT, neonatal lupus, APS. Infection susceptibility (flu, listeria, COVID). Inactivated vaccines safe.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'basic_science', 'obgyn', 'adult',
  'Mor Inflammation + Pregnancy; ACOG Immunization in Pregnancy', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Resident ถามอาจารย์เรื่อง maternal immunology + tolerance of fetus + autoimmune in pregnancy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Thai Ministry establishes National Maternal Mortality Review Committee (MMRC) + perinatal data registry', '[{"label":"A","text":"Skip data collection"},{"label":"B","text":"Maternal Mortality + Severe Morbidity Review systems"},{"label":"C","text":"Hide data"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Refuse review"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Maternal Mortality + Severe Morbidity Review systems**: (1) **Maternal Mortality Review Committee (MMRC)** — multidisciplinary committee (OB, midwife, anesthesia, ICU, pathology, public health, social work, community); review all maternal deaths within 1 yr of pregnancy; (2) **case identification** — ICD coding, hospital reports, death certificates, vital statistics linkage, lay report; (3) **review process** — abstract chart + interviews (clinicians, family if appropriate), classify cause + pregnancy-relatedness + preventability + contributing factors (clinician, system, patient, social), identify opportunities + recommendations, track implementation; (4) **classification systems** — WHO ICD-MM (direct, indirect, incidental, unspecified); pregnancy-related vs pregnancy-associated (any cause, expanded definition); (5) **WHO ''Three Delays'' framework** — delay seeking care (knowledge, finances, family), delay reaching care (transport, distance), delay receiving care (facility readiness, staff, supplies); guide system interventions; (6) **near-miss + severe maternal morbidity (SMM)** also reviewed — wider lens for learning (deaths small numerator); (7) **data registry** — standardized variables, anonymized, secure, longitudinal, linked to vital records + neonatal outcomes; (8) **public reporting + accountability** — disaggregated by region/SES/race/ethnicity; address disparities; (9) **action-oriented** — implementation, training, policy change, AIM bundle adoption, telemedicine, transport network; (10) **legal protections** — peer review + confidentiality + immunity from discoverability (varies by jurisdiction; Thai context evolving); (11) **WHO ICD-MM coding standardization**; (12) **integration with global** — Maternal Mortality Estimation Inter-agency Group (MMEIG), UN SDG 3.1 (reduce maternal mortality < 70/100,000 by 2030); Thai progress noted; (13) **community engagement + family disclosure** ethically; (14) **continuous quality improvement cycle (PDSA)** — review → recommendations → implement → measure → re-review

---

MMRC: multidisciplinary review of maternal deaths + SMM. WHO Three Delays framework. Identify preventable + system factors. Data registry. Public reporting + equity. Action-oriented. Legal protections. SDG 3.1 target. Continuous quality improvement.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'ems_mgmt', 'obgyn', 'adult',
  'WHO Maternal Death Surveillance + Response; CDC MMRC; Thai MOPH MCH', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Thai Ministry establishes National Maternal Mortality Review Committee (MMRC) + perinatal data registry'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital implements obstetric quality measure dashboards (NTSV C-section, episiotomy, blood transfusion, severe hypertension treatment timeliness, exclusive breastfeeding)', '[{"label":"A","text":"Quality measures useless"},{"label":"B","text":"Obstetric Quality Measures + Performance Dashboards"},{"label":"C","text":"Hide data from clinicians"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Refuse measurement"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Obstetric Quality Measures + Performance Dashboards**: (1) **rationale** — what''s measured improves; benchmarking; transparency + accountability + patient choice; reimbursement (US — value-based purchasing); (2) **process measures** — antenatal steroids for preterm, GBS prophylaxis, antibiotic timing pre-incision C/S, immediate postpartum LARC, prenatal CRT/PE workup, screening (depression, IPV, GDM); (3) **outcome measures** — NTSV C-section rate (CMS benchmark < 23.6%), VBAC rate, episiotomy rate (Cochrane → restrictive), birth trauma, OASIS, postpartum hemorrhage > 1500 mL, blood transfusion, severe maternal morbidity (CDC 21 indicators), maternal mortality, ICU admission, exclusive breastfeeding rate, neonatal Apgar < 7, NICU admission, perinatal mortality, severe HT treatment within 60 min, ECV success; (4) **balancing measures** — ensure no unintended harm (e.g., reducing C/S doesn''t ↑ perinatal mortality); (5) **patient-reported** — Patient-Reported Outcome Measures (PROM) — birth experience, postpartum recovery, breastfeeding satisfaction; (6) **safety culture** — AHRQ Safety Attitudes Questionnaire; (7) **collaboratives** — California Maternal Quality Care Collaborative (CMQCC) — AIM bundle implementation + benchmarking; AIM nationwide; Joint Commission Perinatal Care measures; Leapfrog; (8) **data governance** — definitions standardized (NTSV = nulliparous + term + singleton + vertex, denominator), risk adjustment, data quality audit; (9) **public reporting** — Hospital Compare (US); CMS Hospital Compare; (10) **provider feedback** — individual + group; bell curve discussions; coaching; (11) **PDSA cycles** — small tests of change; (12) **dashboards real-time** — EMR integration, alerts; (13) **Thai context** — RTCOG quality initiatives, MOPH HA accreditation; (14) **equity** — disaggregate by sociodemographic; address disparities; (15) **rewards/recognition** + financial alignment

---

OB quality measures: process + outcome + balancing + patient-reported. NTSV C/S, severe HT timing, exclusive BF, OASIS, transfusion, SMM. CMQCC + AIM + Joint Commission. Dashboards + real-time + risk adjusted. Feedback + PDSA. Equity disaggregation. Thai HA accreditation.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'ems_mgmt', 'obgyn', 'adult',
  'CMQCC Quality Measures; The Joint Commission Perinatal Care; Leapfrog Hospital Survey', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Hospital implements obstetric quality measure dashboards (NTSV C-section, episiotomy, blood transfusion, severe hypertension treatment timeliness, exclusive breastfeeding)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงตั้งครรภ์ G2P1 GA 26 wk underlying SLE on stable HCQ + low-dose prednisone — มาด้วยอาการ acute new onset BP 160/100, proteinuria 4+, severe headache, plt 110K + Cr 1.1 — รบกวน distinction between SLE flare vs preeclampsia

V/S: BP 160/100, HR 96, RR 18
Gen: malar rash unchanged + arthritis mild active
Fetal: FHR 144 reactive, EFW 750 g (10th percentile — borderline)
Lab: plt 110 (down from 240 baseline), AST/ALT WNL, Cr 1.1, uric acid 7.5, urine protein/Cr 4.5, anti-dsDNA elevated × 3-fold from baseline, low C3/C4, anti-Ro/La positive (known), aPL negative', '[{"label":"A","text":"Cesarean immediately"},{"label":"B","text":"Distinguishing SLE flare vs preeclampsia in pregnancy"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Hysterectomy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Distinguishing SLE flare vs preeclampsia in pregnancy** — both can present with HT + proteinuria + thrombocytopenia + renal dysfunction — but management + prognosis differ; **may co-exist** — treat both: (1) **features favoring SLE flare**: (a) **complement low (C3/C4)** — falls in active SLE; complement usually NORMAL or ↑ in preeclampsia; (b) **anti-dsDNA rising** — SLE; (c) **active extra-renal manifestations** — arthritis, rash, serositis, hematologic; (d) **urine sediment active** — cellular casts (red cell, granular), dysmorphic RBC; (e) **uric acid normal-to-low** in SLE vs ↑ in preeclampsia; (f) **timing** — can occur any gestation in SLE; preeclampsia after 20 wk; (g) **hypertension less prominent** in flare; (2) **features favoring preeclampsia**: (a) **uric acid markedly elevated**; (b) **normal/↑ complement**; (c) **AST/ALT ↑** (HELLP), LDH ↑ (hemolysis), low fibrinogen; (d) **no active SLE serology**; (e) **fetal growth restriction** with abnormal Doppler; (f) **after 20 wk**; (g) **sFlt-1/PlGF ratio elevated** > 38 (helpful biomarker); (3) **this patient** — low complement + ↑ anti-dsDNA + active SLE serology + uric acid 7.5 borderline → favors **flare more than pure preeclampsia, but may co-exist + severe HT**; (4) **management** — (a) **treat HT** acutely — labetalol/hydralazine; (b) **MgSO4** seizure prophylaxis (if severe features), neuroprotection (< 32 wk); (c) **↑ immunosuppression for flare** — pulse methylprednisolone 500-1000 mg × 3 d if severe lupus nephritis; ↑ azathioprine; continue HCQ + low-dose prednisone; cyclophosphamide avoided pregnancy; mycophenolate avoided; (d) **renal biopsy** rarely needed pregnancy — defer if possible; (e) **fetal surveillance** + delivery planning — at 26 wk balance prematurity vs disease — steroid course + may extend stabilization, but deliver if maternal/fetal deterioration; (f) **postpartum** — high flare risk continues; continue immunosuppression; (5) **multidisciplinary** — rheum + MFM + nephrology + neonatology; (6) **future pregnancy** — preconception planning + control × 6 mo + safer meds + aspirin

---

SLE flare vs preeclampsia: low complement + ↑ anti-dsDNA + active SLE serology + normal uric acid → flare. ↑ uric acid + AST/ALT + sFlt-1/PlGF + abnormal Dopplers → preeclampsia. May co-exist. Treat both. Pulse steroid for flare. MgSO4 + antihypertensive for PE. Multidisciplinary. Preconception planning future.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'integrative', 'obgyn', 'adult',
  'EULAR/ACR SLE Pregnancy; Buyon Lupus Nephritis Pregnancy', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงตั้งครรภ์ G2P1 GA 26 wk underlying SLE on stable HCQ + low-dose prednisone — มาด้วยอาการ acute new onset BP 160/100, proteinuria 4+, severe headache, plt 110K + Cr 1.1 — รบกวน distinction between SLE flare vs preeclampsia

V/S: BP 160/100, HR 96, RR 18
Gen: malar rash unchanged + arthritis mild active
Fetal: FHR 144 reactive, EFW 750 g (10th percentile — borderline)
Lab: plt 110 (down from 240 baseline), AST/ALT WNL, Cr 1.1, uric acid 7.5, urine protein/Cr 4.5, anti-dsDNA elevated × 3-fold from baseline, low C3/C4, anti-Ro/La positive (known), aPL negative'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 28 ปี G1P1 NSD 5 d ago — มาห้องฉุกเฉินด้วยอาการอ่อนแรงครึ่งซีก L + พูดไม่ชัด + ปวดศีรษะรุนแรง + ตามัวข้างซ้าย

V/S: BP 168/108, HR 96, RR 18
Gen: alert but confused
Neuro: L hemiparesis + dysarthria + L homonymous hemianopia
Fetal/Baby: at home with family, breastfeeding
CT brain: R MCA territory hypodense + no hemorrhage
CTA: R MCA M1 occlusion', '[{"label":"A","text":"Discharge home"},{"label":"B","text":"Postpartum stroke (ischemic) with large vessel occlusion"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Refuse imaging"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Postpartum stroke (ischemic) with large vessel occlusion** — postpartum hypercoagulable + preeclampsia/eclampsia/HT + cardiac (PPCM) + autoimmune + amniotic fluid embolism + cervical artery dissection (Valsalva push) + RCVS + cerebral venous sinus thrombosis (CVST): (1) **time-critical activation ''stroke code''**; (2) **ischemic stroke + large vessel occlusion + within window**: (a) **IV thrombolysis (tPA alteplase)** — within 4.5 hr — postpartum bleeding contraindication relative (consider risk-benefit); MTP 6 d post-delivery → caution; (b) **endovascular thrombectomy** — within 6-24 hr (DAWN/DEFUSE-3); preferred in postpartum (avoids systemic lysis); (3) **manage BP** — permissive HT up to 220/120 if not thrombolysis candidate (avoid hypoperfusion); if thrombolysis < 185/110; (4) **rule out + treat alternative causes**: (a) **postpartum cerebral angiopathy / reversible cerebral vasoconstriction syndrome (RCVS)** — thunderclap headache, segmental vasoconstriction, calcium channel blocker; (b) **cerebral venous sinus thrombosis (CVST)** — headache + papilledema + seizure → CTV/MRV → anticoagulation LMWH; (c) **PRES (posterior reversible encephalopathy)** — HT + visual + seizure + occipital edema → control BP + seizure; (d) **eclampsia** even postpartum (up to 6 wk); MgSO4 + BP; (5) **workup** — echo (cardiac embolic source — PPCM, valve), Doppler carotid, hypercoagulable + APS, autoimmune; (6) **anticoagulation** — depends on etiology (CVST yes, embolic source yes after acute, aspirin for non-cardioembolic ischemic); LMWH postpartum preferred; (7) **rehabilitation** — early; long-term recovery; (8) **breastfeeding** — most meds compatible; (9) **psychosocial + childcare** — significant family impact; social work; (10) **future pregnancy** — recurrence risk; multidisciplinary planning + LMWH thromboprophylaxis; (11) Thai stroke network + EMS

---

Postpartum stroke: ischemic + hemorrhagic; ↑ risk first 6 wk. Causes — HT/PE, hypercoag, PPCM, AFE, RCVS, dissection, CVST. Stroke code. tPA + thrombectomy (postpartum bleed risk — risk-benefit). Distinguish RCVS, CVST, PRES, eclampsia. Anticoag depends on etiology. Breastfeeding mostly compatible. Future pregnancy planning.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'integrative', 'obgyn', 'adult',
  'AHA/ASA Stroke 2019; Postpartum Stroke Saposnik; ACOG Postpartum Care 736', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 28 ปี G1P1 NSD 5 d ago — มาห้องฉุกเฉินด้วยอาการอ่อนแรงครึ่งซีก L + พูดไม่ชัด + ปวดศีรษะรุนแรง + ตามัวข้างซ้าย

V/S: BP 168/108, HR 96, RR 18
Gen: alert but confused
Neuro: L hemiparesis + dysarthria + L homonymous hemianopia
Fetal/Baby: at home with family, breastfeeding
CT brain: R MCA territory hypodense + no hemorrhage
CTA: R MCA M1 occlusion'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 28 ปี G2P1 GA 24 wk — fetal anencephaly (lethal anomaly) confirmed on US — couple opts to continue pregnancy with palliative perinatal care

V/S: BP 116/72, HR 76
Gen: well, supportive partner + family
Fetal: confirmed anencephaly + acrania + polyhydramnios mild + otherwise grossly normal
Lab: amniotic fluid AFP high, no other anomaly', '[{"label":"A","text":"Force termination"},{"label":"B","text":"Perinatal palliative care for lethal fetal anomaly"},{"label":"C","text":"Hysterectomy"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Refuse care"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Perinatal palliative care for lethal fetal anomaly** — family-centered, individualized: (1) **multidisciplinary team** — MFM + neonatology + nursing + chaplain + social worker + bereavement counselor + perinatal palliative care specialist if available + family; (2) **respectful counseling** — present options (termination if legal + within Thai law, continue with palliative perinatal care); validate choice; explore meaning + values; (3) **birth plan creation** — preferences for delivery (vaginal preferred, avoid C/S for non-survivable, except maternal indication), pain management, monitoring during labor (limited interventions per family), presence of family, religious/cultural rituals, memory making (footprints, photos, memory box), naming, baptism/blessing, breastfeeding/colostrum if desired; (4) **maternal care** — routine ANC with attention to maternal complications (polyhydramnios from anencephaly — preterm labor, PROM, dystocia), maternal mental health (high risk depression + PTSD + grief), social support; (5) **monitoring** — minimal fetal monitoring (no interventions for fetal distress); maternal monitoring intact; (6) **labor + delivery** — usually term but may be earlier; vaginal delivery preferred; consider amnioreduction if symptomatic polyhydramnios; oxytocin + epidural standard; avoid C/S unless maternal indication (no fetal benefit); (7) **at birth** — focus on comfort + family bonding; no resuscitation per advance plan; warm wrap, hold, time as long as desired; pain management for infant (morphine, comfort); allow death naturally with dignity; (8) **postpartum** — lactation suppression options (or donor milk if desired), bereavement support, memorial, follow-up; future pregnancy counseling — recurrence risk + folate 4 mg + screening; (9) **community + cultural** — Thai Buddhist rituals, family practices, respectful integration; (10) **bereavement counseling** — perinatal loss support groups; complicated grief screening; (11) **multidisciplinary debrief** + staff support (moral distress); (12) **legal/documentation** — birth + death certificates, autopsy if family wishes, genetic counseling; (13) **whole family** — siblings, grandparents — pediatric/child life support

---

Perinatal palliative care: multidisciplinary, family-centered. Birth plan, memory making, comfort care at birth. Vaginal delivery preferred; avoid C/S without maternal indication. Polyhydramnios mgmt for symptomatic. Bereavement + future pregnancy counseling (recurrence + folate). Cultural integration. Staff support for moral distress.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'integrative', 'obgyn', 'adult',
  'ACOG Committee Opinion 786: Perinatal Palliative Care 2019', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 28 ปี G2P1 GA 24 wk — fetal anencephaly (lethal anomaly) confirmed on US — couple opts to continue pregnancy with palliative perinatal care

V/S: BP 116/72, HR 76
Gen: well, supportive partner + family
Fetal: confirmed anencephaly + acrania + polyhydramnios mild + otherwise grossly normal
Lab: amniotic fluid AFP high, no other anomaly'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงตั้งครรภ์ G2P1 GA 32 wk underlying chronic HT + GDM — มาด้วยอาการ malaise + nausea + ปวด RUQ × 3 d + jaundice mild × 1 d

V/S: BP 138/86, HR 102, RR 18, Temp 37.0
Gen: jaundiced + RUQ tenderness + no encephalopathy
Fetal: FHR 158 reactive, EFW 1,650 g (50th)
Lab: AST 580, ALT 480, total bilirubin 5.2, glucose 52 (hypoglycemia!), plt 95K, INR 1.6, fibrinogen 180, Cr 1.3, uric acid 8.5, urine protein 1+
US abdomen: liver echogenic (fatty)', '[{"label":"A","text":"Discharge home"},{"label":"B","text":"Acute Fatty Liver of Pregnancy (AFLP)"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Wait for liver to recover before delivery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Acute Fatty Liver of Pregnancy (AFLP)** — rare but life-threatening (mortality 10-20% maternal, 20-30% perinatal) — microvesicular fatty infiltration of hepatocytes; 3rd trimester typically; associated with **fetal LCHAD deficiency** (long-chain 3-hydroxyacyl-CoA dehydrogenase — fetal fatty acid oxidation defect → toxic intermediates to mother); **Swansea criteria** (≥ 6 of 14): vomiting, abdominal pain, polydipsia/polyuria, encephalopathy, ↑ bilirubin, hypoglycemia, ↑ urate, leukocytosis, ascites/bright liver, ↑ transaminases, ↑ ammonia, ↑ Cr, coagulopathy, microvesicular steatosis on biopsy; (1) **differential** — HELLP (overlapping), severe preeclampsia, viral hepatitis (AVH), drug-induced, TTP, intrahepatic cholestasis of pregnancy (ICP — usually milder), acute viral hepatitis; (2) **management — STAT delivery** is definitive (do not delay for steroids in stable; deliver promptly): (a) **stabilize** — correct hypoglycemia (D10 infusion), correct coagulopathy (FFP, cryo, plt, vit K), correct electrolytes, blood products; (b) **MgSO4** seizure prophylaxis (often co-exists with preeclampsia features); (c) **antihypertensive** if needed; (d) **deliver** — mode per obstetric — vaginal if feasible + safe, C/S if compromised; consider preinduction maternal stabilization; (e) **multidisciplinary** — MFM + hepatology + ICU + neonatology; (3) **postpartum** — supportive in ICU; usually improves over days-weeks; liver transplant for fulminant failure (rare); monitor + correct coagulopathy; (4) **neonatal — test for LCHAD deficiency** — newborn screen + acylcarnitine + genetic; if affected → MCT-based diet + restriction long-chain fatty acids; (5) **future pregnancy** — recurrence ~ 20-70% if mother heterozygous + partner heterozygous + fetus homozygous → counsel + prenatal testing; (6) **counseling** + family support

---

AFLP: rare, life-threatening. Hypoglycemia + coagulopathy + ↑ bilirubin/transaminases + ↑ urate + AKI. Swansea criteria. Fetal LCHAD deficiency association. STAT delivery is definitive after stabilization. Correct hypoglycemia + coagulopathy. ICU. Neonatal LCHAD screen. Recurrence ~ 20-70%.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'RCOG Green-top 47: Obstetric Cholestasis; Williams Obstetrics Ch 55', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงตั้งครรภ์ G2P1 GA 32 wk underlying chronic HT + GDM — มาด้วยอาการ malaise + nausea + ปวด RUQ × 3 d + jaundice mild × 1 d

V/S: BP 138/86, HR 102, RR 18, Temp 37.0
Gen: jaundiced + RUQ tenderness + no encephalopathy
Fetal: FHR 158 reactive, EFW 1,650 g (50th)
Lab: AST 580, ALT 480, total bilirubin 5.2, glucose 52 (hypoglycemia!), plt 95K, INR 1.6, fibrinogen 180, Cr 1.3, uric acid 8.5, urine protein 1+
US abdomen: liver echogenic (fatty)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 26 ปี G1P0 GA 28 wk underlying healthy — มาด้วย hemolytic anemia + thrombocytopenia + AKI + altered mental status

V/S: BP 132/82, HR 110, Temp 37.4
Gen: petechiae + jaundice + altered mental status (confused)
Fetal: FHR 144 reactive
Lab: Hb 7.2, MCV 90, retic 8%, schistocytes ++, plt 15K, LDH 1,800, haptoglobin < 8, indirect bilirubin 4.5, Cr 2.8 (was 0.6), ADAMTS13 activity < 10% (severely reduced), anti-ADAMTS13 IgG positive, AST/ALT mildly ↑, INR normal, fibrinogen 320', '[{"label":"A","text":"Cesarean immediately without TPE"},{"label":"B","text":"Thrombotic Thrombocytopenic Purpura (TTP) in pregnancy"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Hysterectomy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Thrombotic Thrombocytopenic Purpura (TTP) in pregnancy** — pentad: hemolytic anemia + thrombocytopenia + neurologic + renal + fever (often incomplete); **ADAMTS13 < 10% activity** + anti-ADAMTS13 IgG → acquired (immune-mediated) TTP; distinguish from severe preeclampsia/HELLP, AFLP, HUS, DIC, sepsis-DIC, APS catastrophic — overlapping features but ADAMTS13 deficit pathognomonic; (1) **STAT plasma exchange (TPE)** — daily 1.5× plasma volume with FFP replacement → removes anti-ADAMTS13 Ab + replaces ADAMTS13 + vWF cleaving; continue until plt > 150K × 2 d + clinical improvement; (2) **corticosteroid** (prednisolone 1 mg/kg/d) — adjunct immunosuppression; (3) **caplacizumab** (anti-vWF nanobody) — new effective; pregnancy data limited, individual risk-benefit; (4) **rituximab** — for refractory + relapsing — used in pregnancy with consideration; (5) **avoid platelet transfusion** unless life-threatening bleeding (theoretical worsens microthrombi); RBC + FFP OK; (6) **fetal monitoring**; (7) **delivery timing** — TTP itself not indication for delivery; treat TTP first; deliver per obstetric indications; if fetal compromise + TTP severe → multidisciplinary decision; (8) **multidisciplinary** — hematology + MFM + nephrology + neuro + ICU; (9) **postpartum** — continue treatment; recurrence ~ 30% in next pregnancy → close monitoring + prophylactic plasma infusion; (10) **congenital TTP (Upshaw-Schulman)** — inherited ADAMTS13 deficit — recurrent in pregnancy → prophylactic FFP infusion; (11) **differential** — preeclampsia/HELLP improves with delivery (TTP usually doesn''t); AFLP has hypoglycemia + coagulopathy; HUS — Shiga toxin or atypical (complement-mediated); APS — antiphospholipid Ab; (12) **mortality** untreated > 90%, with TPE < 20%

---

TTP in pregnancy: pentad (anemia + thrombocytopenia + neuro + renal + fever — often incomplete). ADAMTS13 < 10% + Ab → acquired TTP. STAT TPE + steroid (+ caplacizumab/rituximab). Avoid plt transfusion. Distinguish from HELLP/AFLP/HUS/DIC. Delivery per obstetric — not TTP indication. Recurrence high. Mortality high untreated.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ISTH TTP 2020; Scully Caplacizumab NEJM 2019', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 26 ปี G1P0 GA 28 wk underlying healthy — มาด้วย hemolytic anemia + thrombocytopenia + AKI + altered mental status

V/S: BP 132/82, HR 110, Temp 37.4
Gen: petechiae + jaundice + altered mental status (confused)
Fetal: FHR 144 reactive
Lab: Hb 7.2, MCV 90, retic 8%, schistocytes ++, plt 15K, LDH 1,800, haptoglobin < 8, indirect bilirubin 4.5, Cr 2.8 (was 0.6), ADAMTS13 activity < 10% (severely reduced), anti-ADAMTS13 IgG positive, AST/ALT mildly ↑, INR normal, fibrinogen 320'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 34 ปี G1P0 GA 18 wk routine US — finding ovarian mass 6 cm complex on R + Pap smear last year ASCUS HPV+, colposcopy + biopsy: invasive SCC of cervix Stage IB1 (tumor 2.5 cm)

V/S: BP 116/72, HR 80
Gen: well
Fetal: anatomy scan normal otherwise, growth appropriate
MRI pelvis: cervical tumor 2.5 cm, no parametrial involvement, no nodal involvement; ovarian mass complex 6 cm — separately, R, likely physiologic vs benign
No metastasis on CXR', '[{"label":"A","text":"Forced termination"},{"label":"B","text":"Cervical cancer in pregnancy"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Discharge — wait until delivery without further workup"},{"label":"E","text":"Hysterectomy at 18 wk without considering options"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Cervical cancer in pregnancy** — multidisciplinary GYN-onc + MFM + neonatology + family — individualized: (1) **multidisciplinary discussion + patient preference** (desire to continue pregnancy, GA, stage, growth pattern); (2) **early pregnancy (< 22-24 wk) with early-stage**: (a) **delay treatment to fetal viability** if microscopic/early IA-IB1 stable + close monitoring (clinical + MRI q 4-8 wk); deliver 34-37 wk + post-delivery definitive surgery (radical hysterectomy or CRT); (b) **immediate treatment** (treatment supersedes pregnancy) for advanced or rapidly progressive — chemotherapy 2nd-3rd trimester (cisplatin + paclitaxel safer than CRT in pregnancy) → delay surgery to postpartum + adjuvant; (c) **termination if family chooses** + definitive treatment; (3) **later pregnancy (≥ 22-24 wk)**: (a) wait for fetal lung maturity, antenatal steroids 24-34 wk, deliver 34-37 wk (or earlier ถ้า progression) → C/S + radical hysterectomy en bloc at same operation, or staged; (b) avoid radiation in pregnancy ถ้า possible; (4) **fertility-sparing trachelectomy** — not feasible during pregnancy typically; (5) **delivery mode** — **cesarean** preferred to avoid vaginal birth (theoretical tumor seeding + bleeding); vaginal previously thought OK for very early lesion but C/S safer; (6) **at C/S** — radical hysterectomy + pelvic lymphadenectomy + BSO consideration based on age + path (preserve ovaries young if reasonable); send ovarian mass to frozen — likely benign physiologic at this GA; (7) **adjuvant** — RT + cisplatin per indications postpartum; (8) **lymph node assessment during pregnancy** — sentinel LN (technetium-99m safe), pelvic LND if needed; some delay; (9) **counseling** — survival similar to non-pregnant matched; fetal outcomes good with planned management; psychological + multidisciplinary support; (10) **chemotherapy in pregnancy 2nd-3rd trimester** — generally accepted safety for limited regimens (cisplatin, paclitaxel)

---

Cervical cancer in pregnancy: multidisciplinary + individualized. Early GA + early stage: delay until viability, antenatal steroid, C/S + radical hysterectomy. Chemo 2nd-3rd tri (cisplatin/paclitaxel) if needed. Avoid RT pregnancy. C/S preferred mode. Sentinel LN. Counseling + family choice — termination option.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ESGO Cancer in Pregnancy Consensus 2019; FIGO Cervical Cancer', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 34 ปี G1P0 GA 18 wk routine US — finding ovarian mass 6 cm complex on R + Pap smear last year ASCUS HPV+, colposcopy + biopsy: invasive SCC of cervix Stage IB1 (tumor 2.5 cm)

V/S: BP 116/72, HR 80
Gen: well
Fetal: anatomy scan normal otherwise, growth appropriate
MRI pelvis: cervical tumor 2.5 cm, no parametrial involvement, no nodal involvement; ovarian mass complex 6 cm — separately, R, likely physiologic vs benign
No metastasis on CXR'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 32 ปี G2P0A2 prior 2 D&C for missed abortion — มาด้วยอาการประจำเดือนไม่มา 1 yr post-D&C + cyclic pelvic pain + infertility, β-hCG negative

V/S: BP 116/72, HR 78
Gen: well
Pelvic: WNL
Lab: TSH normal, prolactin normal, FSH 6, LH 4, AMH 3.2 normal, β-hCG negative
HSG: filling defects + irregular cavity outline (suggesting adhesions)
Hysteroscopy: extensive intrauterine adhesions involving > 75% cavity', '[{"label":"A","text":"Hysterectomy"},{"label":"B","text":"Asherman Syndrome (intrauterine adhesions)"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Asherman Syndrome (intrauterine adhesions)** — fibrous bands in endometrial cavity → menstrual abnormalities, infertility, pregnancy complications; etiology: D&C (most common, esp post-miscarriage/postpartum), infection (TB, schistosomiasis), surgery, radiation: (1) **classification** — March/AFS (mild/moderate/severe by extent + type); ESH/Hamou; (2) **diagnosis** — HSG (filling defects), SIS, **hysteroscopy gold standard** (direct + treatment); (3) **treatment — hysteroscopic adhesiolysis** — scissors, hook, monopolar/bipolar — preserve healthy endometrium; outpatient or staged for extensive; (4) **prevention of recurrence post-adhesiolysis** — variable methods (no single proven best): (a) **intrauterine device/balloon** — Foley balloon or IUD for 1-2 wk to keep walls separated; (b) **hyaluronic acid gel** intracavitary; (c) **estrogen therapy** — high-dose estrogen (conjugated estrogen 5 mg/d or estradiol 4 mg/d) × 4-8 wk → stimulate endometrial regrowth; (d) **second-look hysteroscopy** at 6-8 wk to lyse new adhesions; (5) **stem cell / G-CSF** — emerging therapies for endometrial regeneration; (6) **fertility outcomes** — depend on severity + initial endometrial damage; ~ 60-90% restoration of menses; pregnancy 30-70%; (7) **pregnancy complications post-Asherman** — preterm, FGR, abnormal placentation (accreta — implantation on scar), abortion → close monitoring; (8) **counseling** — recurrence, fertility outcomes, alternative parenthood options (gestational surrogacy if severe); (9) **prevention** — D&C avoidance when possible (use medical management for early miscarriage), gentle technique, postpartum care; (10) **co-existing infertility workup** — semen, ovulation, tubes

---

Asherman: intrauterine adhesions from D&C/infection. Diagnosis: hysteroscopy. Treatment: hysteroscopic adhesiolysis + prevent recurrence (balloon, hyaluronic gel, estrogen, second-look). Pregnancy complications: preterm, FGR, accreta. Prevention: avoid unnecessary D&C, gentle technique. Surrogacy if severe.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'AAGL Asherman Syndrome 2017; ESHRE Recurrent Implantation Failure', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 32 ปี G2P0A2 prior 2 D&C for missed abortion — มาด้วยอาการประจำเดือนไม่มา 1 yr post-D&C + cyclic pelvic pain + infertility, β-hCG negative

V/S: BP 116/72, HR 78
Gen: well
Pelvic: WNL
Lab: TSH normal, prolactin normal, FSH 6, LH 4, AMH 3.2 normal, β-hCG negative
HSG: filling defects + irregular cavity outline (suggesting adhesions)
Hysteroscopy: extensive intrauterine adhesions involving > 75% cavity'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 24 ปี nulligravid มา OPD ด้วยอาการ hirsutism progressive + acne refractory + voice deepening + clitoromegaly + amenorrhea 6 mo × 1 yr

V/S: BP 134/86, HR 80
Gen: temporal balding, deep voice, hirsutism Ferriman-Gallwey 18, clitoromegaly mild
Lab: testosterone total 220 (markedly elevated; PCOS usually < 150), DHEAS WNL, 17-OHP normal, β-hCG negative, TSH normal, prolactin normal, FSH 5, LH 8, cortisol normal, ACTH-stim 17-OHP normal
US pelvis: R ovarian mass 4 cm solid + hypervascular
MRI: R ovarian solid mass with vascular pedicle, no metastasis', '[{"label":"A","text":"Methotrexate"},{"label":"B","text":"Hyperandrogenism with virilization + ovarian mass"},{"label":"C","text":"PCOS — treat with COCP"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Hyperandrogenism with virilization + ovarian mass** — workup for **androgen-secreting tumor** (ovarian or adrenal); high testosterone + virilization signs (rapid onset, deep voice, clitoromegaly, balding) → likely ovarian: (1) **differential**: (a) **ovarian — Sertoli-Leydig cell tumor (most common androgen-secreting), thecoma, hilus cell tumor, granulosa cell**; (b) **adrenal — adenoma, carcinoma**; (c) **PCOS** — typically lower T < 150, slower onset, no virilization; (d) **non-classic CAH** — 17-OHP elevated post-ACTH stim; (e) **Cushing''s** — cortisol; (f) **exogenous** — anabolic steroids, DHEA supplements; (2) **workup** — **DHEAS high → adrenal**; **testosterone very high → ovarian**; both → adrenal carcinoma; **17-OHP basal + ACTH-stim** for CAH; **dexamethasone suppression test** for Cushing; (3) **imaging** — TVS + MRI pelvis (ovarian); CT/MRI adrenal; sometimes selective venous sampling for occult source; (4) **management — surgical removal**: (a) **ovarian Sertoli-Leydig** — unilateral salpingo-oophorectomy + staging (frozen section); fertility-sparing in young; (b) bilateral if perimenopausal/completed family; (c) **adrenal mass** — adrenalectomy with workup of malignancy; (d) **histology** — guides adjuvant; (5) **post-removal** — androgens normalize within weeks; virilization improves but voice + balding may not regress fully; (6) **counseling** — fertility preservation (egg cryopreservation if anticipated bilateral surgery), psychological support; (7) **follow-up** — recurrence + tumor markers (inhibin); (8) **cosmetic + dermatology** — laser hair removal, eflornithine cream for residual hirsutism; (9) **HRT** if surgical menopause; (10) Sertoli-Leydig — DICER1 mutation association → genetic counseling

---

Severe hyperandrogenism with virilization + rapid onset + T > 150 → androgen-secreting tumor (Sertoli-Leydig ovarian or adrenal). Workup DHEAS, testosterone, 17-OHP, dexamethasone. Imaging. Surgical removal. Sertoli-Leydig DICER1 association. Fertility preservation. Cosmetic adjunct. Distinguish from PCOS (lower T, slow onset, no virilization).', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'Endocrine Society Hyperandrogenism; NIH PCOS + Differential', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 24 ปี nulligravid มา OPD ด้วยอาการ hirsutism progressive + acne refractory + voice deepening + clitoromegaly + amenorrhea 6 mo × 1 yr

V/S: BP 134/86, HR 80
Gen: temporal balding, deep voice, hirsutism Ferriman-Gallwey 18, clitoromegaly mild
Lab: testosterone total 220 (markedly elevated; PCOS usually < 150), DHEAS WNL, 17-OHP normal, β-hCG negative, TSH normal, prolactin normal, FSH 5, LH 8, cortisol normal, ACTH-stim 17-OHP normal
US pelvis: R ovarian mass 4 cm solid + hypervascular
MRI: R ovarian solid mass with vascular pedicle, no metastasis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 38 ปี nulligravid มา OPD ด้วยอาการ vulvar burning pain × 6 mo + dyspareunia + tender to touch + no visible lesion + Q-tip test positive at vestibule + no infection + no skin disease

V/S: BP 122/76, HR 78
Gen: anxiety, no depression
Vulva: normal-appearing, no erythema/lesion, Q-tip test exquisitely tender at vestibule
Wet mount: WNL, KOH negative, culture negative', '[{"label":"A","text":"Refuse care"},{"label":"B","text":"Vulvodynia (vulvar pain without identifiable cause ≥ 3 mo)"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Vulvodynia (vulvar pain without identifiable cause ≥ 3 mo)** — diagnosis of exclusion; subtypes: (a) **localized provoked vestibulodynia (LPV)** — pain at vestibule with provocation (Q-tip, intercourse); (b) **generalized unprovoked** — burning vulva; mixed; (1) **diagnosis** — clinical + exclude infection (culture, wet mount), dermatosis, hormonal, neuropathic, neoplasia, trauma; (2) **multimodal management — biopsychosocial**: (a) **vulvar care** — avoid irritants (perfumed soap, panty liners, tight clothes), cotton underwear, lubricants, sitz baths; (b) **topical** — lidocaine 5% ointment (esp before intercourse), topical estrogen (if atrophy), topical compounded amitriptyline-baclofen-gabapentin; (c) **systemic** — TCAs (amitriptyline 10-50 mg QHS), SNRIs (duloxetine, venlafaxine), gabapentin/pregabalin (titrate, slow) — for neuropathic; (d) **pelvic floor physical therapy** — high-evidence intervention — relieve hypertonic pelvic floor; biofeedback; dilators; (e) **psychotherapy** — CBT, mindfulness, sex therapy, couples therapy; address coping + relationship; (f) **interventional** — pudendal nerve block, trigger point injection, **Botox injection** (refractory); (g) **surgical — vestibulectomy** for refractory LPV (success ~ 70-90% select cases) — partial vestibulectomy + perineorrhaphy; (h) **complementary** — acupuncture, hypnotherapy; (3) **chronic pain syndromes co-occur** — IBS, fibromyalgia, IC/PBS, endometriosis, vaginismus, chronic fatigue → comprehensive approach; (4) **mental health screening** — depression, anxiety, sexual abuse history; (5) **counseling + education** — validate, partner involvement; (6) **multidisciplinary** — gyn + PFPT + mental health + pain specialist; (7) **support groups** — National Vulvodynia Association; (8) **NEVER** dismiss as psychological — real pain disorder

---

Vulvodynia: diagnosis of exclusion. LPV vs generalized. Multimodal: vulvar care, topical lidocaine, TCAs/SNRIs/gabapentin, PFPT (high evidence), CBT/sex therapy, Botox/vestibulectomy refractory. Mental health screening + chronic pain comorbidity. Validate + multidisciplinary. Don''t dismiss.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin 673: Vulvar Skin Care; NVA Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 38 ปี nulligravid มา OPD ด้วยอาการ vulvar burning pain × 6 mo + dyspareunia + tender to touch + no visible lesion + Q-tip test positive at vestibule + no infection + no skin disease

V/S: BP 122/76, HR 78
Gen: anxiety, no depression
Vulva: normal-appearing, no erythema/lesion, Q-tip test exquisitely tender at vestibule
Wet mount: WNL, KOH negative, culture negative'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 24 ปี G0P0 มา OPD ด้วยอาการ recurrent vaginal yeast infection × 6 episodes/yr × 2 yr, ทุกครั้งหายเองหลังครีม OTC แต่กลับมา

V/S: BP 116/72, HR 78
Gen: well
Vagina: erythema mild + curdy discharge
Wet mount: yeast + pseudohyphae
Culture: Candida albicans
Fasting glucose normal, HbA1c 5.4, HIV negative, no immunosuppression, no recent antibiotics', '[{"label":"A","text":"One dose OTC cream + done"},{"label":"B","text":"Recurrent Vulvovaginal Candidiasis (RVVC, ≥ 4 episodes/yr)"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Antibiotic broad-spectrum"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Recurrent Vulvovaginal Candidiasis (RVVC, ≥ 4 episodes/yr)** — distinguish from uncomplicated/single episode; identify species (C. albicans 80-90%, others — C. glabrata, krusei — fluconazole resistance): (1) **confirm diagnosis** — wet mount + KOH + **culture** for species + sensitivity (esp recurrent); (2) **rule out predisposing factors** — uncontrolled diabetes (HbA1c), HIV/immunosuppression, recent broad-spectrum antibiotics, COCP (mild risk), pregnancy, douching, vaginal irritants, tight clothing; (3) **induction therapy** — extended course: (a) **fluconazole 150 mg PO q 72 hr × 3 doses** (or 100-200 mg/d × 14 d); OR (b) **topical azole (miconazole, clotrimazole, terconazole)** × 7-14 days; (4) **maintenance therapy** — **fluconazole 150 mg PO weekly × 6 mo** (CDC, ACOG); alternative: clotrimazole 500 mg PV weekly; (5) **C. glabrata** — fluconazole-resistant — treat with **boric acid 600 mg PV daily × 14 d** (compounded) OR nystatin PV; (6) **C. albicans azole-resistant** rare — boric acid or oteseconazole (newer); (7) **partner treatment** — not routinely indicated (yeast not classically STI); treat partner ถ้า symptomatic; (8) **lifestyle** — cotton underwear, avoid tight, less douching, manage moisture, avoid panty liners daily, consider probiotic Lactobacillus (mixed evidence); (9) **follow-up** — culture + symptom assessment q 3 mo; (10) **post-maintenance** ~ 50% recurrence after stopping — reassess + discuss longer maintenance vs alternative therapies; (11) **specific scenarios** — **pregnancy** topical azole 7 d (avoid oral fluconazole 1st tri); diabetic — optimize glucose; HIV — treat as RVVC + manage immune; (12) **counseling** — natural history, lifestyle, expectations

---

RVVC: ≥ 4 episodes/yr. Culture for species + sensitivity. Rule out DM/HIV/antibiotic predisposition. Induction: fluconazole 150 mg q 72 hr × 3 (or topical 7-14 d). Maintenance: fluconazole 150 mg weekly × 6 mo. C. glabrata: boric acid 14 d. Lifestyle. Counseling.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'CDC STI Treatment Guidelines 2021; ACOG Vaginitis', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 24 ปี G0P0 มา OPD ด้วยอาการ recurrent vaginal yeast infection × 6 episodes/yr × 2 yr, ทุกครั้งหายเองหลังครีม OTC แต่กลับมา

V/S: BP 116/72, HR 78
Gen: well
Vagina: erythema mild + curdy discharge
Wet mount: yeast + pseudohyphae
Culture: Candida albicans
Fasting glucose normal, HbA1c 5.4, HIV negative, no immunosuppression, no recent antibiotics'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 25 ปี nulligravid มา OPD ด้วยอาการปวด lower abdomen ค่อยๆ + ตกขาวเหลืองหนา + ปัสสาวะแสบ × 5 d + ไข้ low-grade + sexually active multiple partners + no condom

V/S: BP 118/74, HR 92, Temp 37.8
Gen: ill-looking mild
Pelvic: cervical motion tenderness, adnexal tenderness bilateral, purulent cervical discharge, no mass
Lab: WBC 13.5K, CRP 42, β-hCG negative, NAAT GC + CT positive, HIV negative, syphilis VDRL negative
US: thickened tube + adnexal complexity bilateral but no abscess', '[{"label":"A","text":"Discharge home + observation"},{"label":"B","text":"Pelvic Inflammatory Disease (PID)"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Antifungal alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Pelvic Inflammatory Disease (PID)** — polymicrobial (GC, CT, anaerobes, gardnerella, mycoplasma); long-term sequelae: tubal infertility, ectopic, chronic pelvic pain (CPP): (1) **diagnosis CDC** — sexually active reproductive-age woman + lower abdominal/pelvic pain + 1+ of (a) cervical motion tenderness, (b) uterine tenderness, (c) adnexal tenderness; low threshold to treat empirically (often subtle); supportive: fever, purulent discharge, ↑ ESR/CRP, GC/CT NAAT positive, US findings; (2) **outpatient treatment (mild-moderate)**: (a) **ceftriaxone 500 mg IM × 1** + **doxycycline 100 mg PO BID × 14 d** + **metronidazole 500 mg PO BID × 14 d** (CDC 2021 updated); (b) follow-up 72 hr; (3) **inpatient treatment indications** — pregnancy, severe illness (high fever, vomiting), tubo-ovarian abscess (TOA), failure outpatient, immunocompromised, surgical emergency cannot exclude, unable to tolerate oral, non-adherence: (a) **cefotetan/cefoxitin 2 g IV q 12 hr + doxycycline 100 mg PO/IV q 12 hr** OR (b) **clindamycin + gentamicin** OR (c) **ampicillin/sulbactam + doxycycline**; transition to oral after improvement to complete 14 d (with metronidazole for anaerobic); (4) **TOA** — admit, IV antibiotics, percutaneous drainage if not resolving 48-72 hr or large (> 7-9 cm), surgery if rupture/sepsis; (5) **partner notification + treatment** — sexual partners last 60 d → empirical GC/CT treatment (DOXY-PEP rationale, expedited partner therapy); abstain until treatment complete; (6) **STI screening** — HIV, syphilis, HBV, HCV, GC/CT, trichomoniasis; (7) **IUD considerations** — recent IUD insertion ↑ PID risk; if IUD-related PID, leave IUD unless no improvement 48-72 hr antibiotic; (8) **education + prevention** — condoms, limit partners, regular STI testing, HPV vaccine, vaccination Hep A/B; (9) **HIV PrEP** consideration if high risk; (10) **follow-up** — 3 mo STI rescreen + symptom check + sequelae assessment

---

PID: CDC criteria + low threshold treatment. Outpatient: ceftriaxone IM + doxycycline + metronidazole × 14 d. Inpatient if severe/TOA/pregnancy/fail. Treat partners + STI screen. IUD-related PID — leave IUD unless no improvement. Sequelae: tubal infertility, ectopic, CPP. Prevention: condoms, vaccination.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'CDC STI Treatment Guidelines 2021; ACOG PID Practice Bulletin', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 25 ปี nulligravid มา OPD ด้วยอาการปวด lower abdomen ค่อยๆ + ตกขาวเหลืองหนา + ปัสสาวะแสบ × 5 d + ไข้ low-grade + sexually active multiple partners + no condom

V/S: BP 118/74, HR 92, Temp 37.8
Gen: ill-looking mild
Pelvic: cervical motion tenderness, adnexal tenderness bilateral, purulent cervical discharge, no mass
Lab: WBC 13.5K, CRP 42, β-hCG negative, NAAT GC + CT positive, HIV negative, syphilis VDRL negative
US: thickened tube + adnexal complexity bilateral but no abscess'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 32 ปี G1P1 NSD 7 d ago — มาด้วย postpartum hypertensive crisis BP 188/118 + severe headache + visual disturbance + epigastric pain, mom is at home with newborn

V/S: BP 188/118, HR 96, RR 22
Gen: hyperreflexia 4+, photophobia
Fetal/Baby: at home with grandmother, breastfeeding
Lab: plt 95K, AST 145, Cr 1.2, urine protein 3+, LDH 580', '[{"label":"A","text":"Outpatient management"},{"label":"B","text":"Postpartum Preeclampsia / Severe HT crisis"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Cesarean (already delivered)"},{"label":"E","text":"Hysterectomy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Postpartum Preeclampsia / Severe HT crisis** — preeclampsia can present **up to 6 wk postpartum** (new onset or worsening of antepartum); same severity criteria + management as antepartum: (1) **immediate admission** + IV access; (2) **antihypertensive within 30-60 min** for severe-range BP — **IV labetalol 20-40-80 mg q 10 min** (max 220-300 mg) or **IV hydralazine 5-10 mg q 20 min** or **oral nifedipine immediate-release 10-20 mg q 30 min**; target BP < 150/100; AIM bundle; (3) **MgSO4** for seizure prophylaxis (severe features present — thrombocytopenia, transaminitis, cerebral symptoms) — 4-6 g loading + 1-2 g/hr × 24 hr; (4) **rule out other causes** — postpartum cardiomyopathy (echo, BNP), PRES, stroke, RCVS, eclampsia, sepsis, AFLP late, TTP/HUS, drug effects; (5) **NSAIDs** controversial — generally OK in HT, but caution + acetaminophen preferred; (6) **maintenance antihypertensive** — labetalol 200-800 mg q 8-12 hr, nifedipine ER 30-120 mg/d, hydralazine, methyldopa; ACEI/ARB now OK postpartum (and breastfeeding — enalapril/captopril preferred; lisinopril etc. — Hale L3 compatible); (7) **monitor labs** — CBC + LFT + Cr + urine — often worsens 24-72 hr postpartum then improves; (8) **discharge planning** — BP daily home for 7-10 d + weekly + recheck PE labs; education for warning signs (HA, vision, RUQ pain, swelling, SOB, AMS — return for evaluation); (9) **breastfeeding** — all common antihypertensives compatible; (10) **future pregnancy** — recurrence 15-65% (depending on severity); preconception planning + aspirin 81-150 mg from 12 wk; (11) **lifelong CV risk** — postpartum PE = 2-4× lifelong CV disease + HT + stroke risk → cardiology referral + lifestyle modification; (12) **postpartum follow-up** — close, especially first 2 wk highest risk; consider home BP monitoring + telehealth check-ins; (13) **psychosocial** — childcare support + breastfeeding support; (14) **document + counsel**

---

Postpartum preeclampsia: up to 6 wk. Treat severe HT < 30-60 min (AIM). MgSO4 if severe features. Rule out PPCM, stroke, PRES, TTP/HUS. ACEI/ARB OK postpartum + breastfeeding (enalapril/captopril preferred). Future pregnancy aspirin + recurrence. Lifelong CV risk 2-4×.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Hypertension Pregnancy 2020; AIM Severe HT Bundle', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 32 ปี G1P1 NSD 7 d ago — มาด้วย postpartum hypertensive crisis BP 188/118 + severe headache + visual disturbance + epigastric pain, mom is at home with newborn

V/S: BP 188/118, HR 96, RR 22
Gen: hyperreflexia 4+, photophobia
Fetal/Baby: at home with grandmother, breastfeeding
Lab: plt 95K, AST 145, Cr 1.2, urine protein 3+, LDH 580'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 35 ปี G0P0 ตัดสินใจ desire fertility-sparing — diagnosed early endometrial cancer Stage IA grade 1 endometrioid + no myometrial invasion + no LVSI + no nodal involvement, BMI 35

V/S: BP 132/82, HR 80
Gen: BMI 35, mild hirsutism
MRI: no myometrial invasion, no nodal involvement
Endometrial biopsy: endometrioid grade 1 + ER/PR strongly positive + no atypical features', '[{"label":"A","text":"Hysterectomy without considering options"},{"label":"B","text":"Fertility-sparing management for early-stage endometrial cancer"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Refuse fertility consideration"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Fertility-sparing management for early-stage endometrial cancer** — strict criteria + multidisciplinary GYN-onc + REI + counseling: (1) **criteria for fertility-sparing**: (a) endometrioid type, **grade 1**, (b) **stage IA** + **NO myometrial invasion** on MRI, (c) **NO LVSI**, (d) **NO extrauterine disease**, (e) reproductive age + strong fertility desire, (f) **Rh ER/PR positive** (predicts response), (g) understands risks + agrees close surveillance + hysterectomy after childbearing; (2) **first-line treatment — high-dose progestin**: (a) **LNG-IUD (Mirena)** — local high-dose progestin — increasingly preferred (less systemic SE; effective; can combine with oral); (b) **megestrol acetate 160-320 mg/d PO** OR **medroxyprogesterone acetate 200-600 mg/d PO**; (c) duration 6-12 mo with re-evaluation; (3) **GnRH agonist** — adjunct or alternative for obesity/PCOS; (4) **metformin** — adjunct for obesity/insulin resistance; (5) **weight loss** — bariatric surgery if BMI > 40 — reduces recurrence + improves response; (6) **surveillance during treatment** — **endometrial sampling (hysteroscopy + biopsy) every 3 mo** until complete response (CR — no carcinoma or atypical hyperplasia on biopsy); usually 6-9 mo; (7) **after CR** — proceed to fertility treatment (often need ART/IVF — 50-60% pregnancy success); maintenance progestin until pregnancy attempted; (8) **after childbearing complete — definitive hysterectomy** (high recurrence risk if uterus retained) + consider BSO based on age + Lynch screening; (9) **recurrence rate** — 30-40% after initial CR; close monitoring; re-treat or definitive; (10) **multidisciplinary** + counseling — risks + outcomes + lifelong surveillance even after hysterectomy; (11) **Lynch syndrome universal screening** (MSI/IHC) — affects family + future cancer surveillance; (12) **contraindication fertility-sparing** — high-grade, deep myometrial invasion, LVSI, extrauterine, non-endometrioid

---

Fertility-sparing endometrial cancer: strict criteria (grade 1, stage IA, no myometrial/LVSI, ER/PR+, fertility desire). LNG-IUD + megestrol high-dose progestin. Sampling q 3 mo until CR. Then fertility treatment (IVF often). Definitive hysterectomy after childbearing. Recurrence 30-40%. Lynch screen. Multidisciplinary.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'SGO/ASCO Fertility-Sparing Endometrial Cancer; ESGO/ESHRE/ESGE Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 35 ปี G0P0 ตัดสินใจ desire fertility-sparing — diagnosed early endometrial cancer Stage IA grade 1 endometrioid + no myometrial invasion + no LVSI + no nodal involvement, BMI 35

V/S: BP 132/82, HR 80
Gen: BMI 35, mild hirsutism
MRI: no myometrial invasion, no nodal involvement
Endometrial biopsy: endometrioid grade 1 + ER/PR strongly positive + no atypical features'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 14 ปี nulliparous มา OPD ด้วยอาการปวดประจำเดือนรุนแรงตอน menses + ปวดท้อง + คลื่นไส้ + อาเจียน + ขาดเรียน × 1 yr ตั้งแต่ menarche 2 ปีก่อน, no pelvic pathology suspected, sexually inactive

V/S: BP 110/68, HR 80
Gen: well, no signs PCOS
Pelvic: external exam normal
US TV: deferred (virgin); abdominal US WNL', '[{"label":"A","text":"Ignore — pain is normal"},{"label":"B","text":"first-line — NSAIDs"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Primary dysmenorrhea** (no underlying pathology — cyclic prostaglandin-mediated uterine cramping) — most common in adolescents, peak 16-25 yr; vs **secondary** (endometriosis, adenomyosis, fibroids, PID, obstructed Müllerian — bicornuate with non-communicating horn — etc.): (1) **first-line — NSAIDs** — **mefenamic acid 500 mg q 6 hr** or **ibuprofen 400-800 mg q 6 hr** or **naproxen 220-500 mg q 8-12 hr** — start 1-2 d before expected menses + continue through pain; prevent prostaglandin synthesis at source; (2) **second-line — hormonal**: (a) **combined OCP** (cyclic or continuous) — suppresses ovulation + thins endometrium → ↓ PG production + cramping; also contraception (relevant if becomes sexually active); (b) **progestin alone** — POP, DMPA, implant (Nexplanon — adolescent option, no estrogen concern); (c) **LNG-IUD (Mirena)** — also adolescent option per ACOG/AAP (lower failure, reduces HMB + dysmenorrhea + endometriosis); (3) **non-pharmacological adjuncts** — heat (heating pad), exercise, dietary (omega-3, magnesium — limited evidence), TENS, yoga, acupuncture, stress management, sleep; (4) **refractory dysmenorrhea or atypical features** → consider **secondary dysmenorrhea** workup — endometriosis (suspect if pain worsening, dyspareunia, dyschezia, infertility), Müllerian anomaly (obstructed) — TVS/MRI, **diagnostic laparoscopy**; (5) **endometriosis treatment** — covered separately (NSAIDs + COCP + progestin + GnRH agonist if refractory); (6) **adolescent endometriosis** — increasingly recognized; refer if refractory; (7) **education + reassurance** — primary dysmenorrhea common + treatable; menstrual hygiene + tracking + cycle predictability; (8) **school accommodation** — emphasize importance of not missing school; pain management ahead of menses; (9) **mental health screening** — anxiety + depression often co-occur; (10) **parental involvement** + adolescent autonomy; (11) Thai school health programs + youth-friendly clinics

---

Primary dysmenorrhea: NSAIDs first-line (start before menses), COCP/progestin/LNG-IUD second. Adolescent-friendly. Refractory → suspect endometriosis or anomaly (US/MRI + laparoscopy). Non-pharma adjuncts. Education + school accommodation. Mental health. Adolescent endometriosis increasingly recognized.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Committee Opinion 760: Dysmenorrhea + Endometriosis Adolescent; NASPAG', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 14 ปี nulliparous มา OPD ด้วยอาการปวดประจำเดือนรุนแรงตอน menses + ปวดท้อง + คลื่นไส้ + อาเจียน + ขาดเรียน × 1 yr ตั้งแต่ menarche 2 ปีก่อน, no pelvic pathology suspected, sexually inactive

V/S: BP 110/68, HR 80
Gen: well, no signs PCOS
Pelvic: external exam normal
US TV: deferred (virgin); abdominal US WNL'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 32 ปี nulligravid IUD copper × 5 yr มา OPD ด้วยอาการ acute lower abdominal pain + fever 38.6 + N/V + RLQ pain + peritonitis × 2 d

V/S: BP 102/68, HR 124, Temp 38.8, RR 22
Gen: ill, peritonitis lower abdomen
Pelvic: cervical motion + adnexal tenderness, R adnexal mass 7 cm tender
Lab: WBC 22K with left shift, CRP 120, β-hCG negative, NAAT GC + CT positive, lactate 2.4
US: complex adnexal mass 7 cm with debris suggesting **tubo-ovarian abscess (TOA)**', '[{"label":"A","text":"Discharge home with PO antibiotic"},{"label":"B","text":"Tubo-Ovarian Abscess (TOA)"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Antibiotic outpatient"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Tubo-Ovarian Abscess (TOA)** — complication of PID with abscess formation; polymicrobial (GC, CT, anaerobes, gram-negatives): (1) **admit + IV access + IV antibiotics**: (a) **cefoxitin/cefotetan 2 g IV q 12 hr + doxycycline 100 mg IV/PO q 12 hr** OR (b) **clindamycin 900 mg IV q 8 hr + gentamicin 5 mg/kg q 24 hr** OR (c) **ampicillin-sulbactam 3 g IV q 6 hr + doxycycline**; (2) **continue IV** until afebrile + improving 24-48 hr, then transition to **oral × 14 d total** with metronidazole 500 mg BID + doxycycline; (3) **drainage**: (a) **percutaneous (IR-guided)** — preferred for abscess > 7-9 cm + accessible + no improvement on antibiotics 48-72 hr OR initially for large abscess; minimally invasive; (b) **transvaginal drainage** alternative; (c) **surgical (laparoscopic or open)** — for rupture, sepsis, failed minimally invasive, or large unresponsive; (4) **IUD management** — IUD-associated TOA — leave IUD initially if responding to antibiotics, remove if not improving 48-72 hr or recurrent (CDC); (5) **STI screen + partner notification + treatment** (GC/CT empirically partners; HIV/syphilis/hepatitis screen); (6) **monitor** — temperature, WBC, CRP, abdo exam, US/CT q 48-72 hr to assess abscess size; (7) **complications** — sepsis, rupture (surgical emergency), chronic pelvic pain, infertility (tubal damage), ectopic risk; (8) **education** — STI prevention, condoms, regular screening, follow-up; (9) **discharge** when afebrile + improving + tolerate oral + arranged follow-up; (10) **outpatient** — complete antibiotic, follow-up 3 mo for symptom + STI re-screen + sequelae; (11) **prevention** — condoms, vaccination (HPV, Hep B), regular STI screen high-risk populations; (12) **counseling** — fertility implications; STI partner + Thai DDC reporting (some)

---

TOA: hospitalize + IV antibiotic (cefoxitin + doxycycline or clinda + gent or amp-sulb + doxy). Drainage for > 7-9 cm or no improvement 48-72 hr (IR-guided percutaneous preferred). Surgery if rupture/sepsis. IUD — leave if responding. STI + partner + screen. Complications: rupture, infertility. Total 14 d antibiotic with metronidazole.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'CDC STI 2021; ACOG PID; SGO Pelvic Inflammatory Disease', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 32 ปี nulligravid IUD copper × 5 yr มา OPD ด้วยอาการ acute lower abdominal pain + fever 38.6 + N/V + RLQ pain + peritonitis × 2 d

V/S: BP 102/68, HR 124, Temp 38.8, RR 22
Gen: ill, peritonitis lower abdomen
Pelvic: cervical motion + adnexal tenderness, R adnexal mass 7 cm tender
Lab: WBC 22K with left shift, CRP 120, β-hCG negative, NAAT GC + CT positive, lactate 2.4
US: complex adnexal mass 7 cm with debris suggesting **tubo-ovarian abscess (TOA)**'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 56 ปี postmenopausal × 4 yr มาด้วย hot flashes severe 15+/d + night sweats + insomnia, ก่อนหน้านี้ history of breast cancer ER+ × 4 yr ago, completed tamoxifen, currently NED, on aromatase inhibitor anastrozole — exacerbating VMS

V/S: BP 124/76, HR 78
Gen: well, distressed by VMS
Lab: no current cancer findings, mammogram recent normal
No CV disease, no VTE history', '[{"label":"A","text":"Refuse all treatment"},{"label":"B","text":"Severe vasomotor symptoms (VMS) in breast cancer survivor"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Severe vasomotor symptoms (VMS) in breast cancer survivor** — MHT contraindicated; **non-hormonal management**: (1) **first-line non-hormonal pharmacotherapy**: (a) **SSRIs/SNRIs** — **paroxetine 7.5 mg/d** (FDA-approved for VMS), **venlafaxine ER 37.5-150 mg/d**, escitalopram, citalopram, desvenlafaxine; **avoid paroxetine + fluoxetine with tamoxifen** (strong CYP2D6 inhibitors — ↓ active metabolite; consider venlafaxine/escitalopram instead with tamoxifen — but this patient on aromatase inhibitor not tamoxifen so paroxetine OK); (b) **gabapentin 300-900 mg QHS** — also helps sleep; (c) **pregabalin** alternative; (d) **clonidine** — limited effect, SE; (e) **oxybutynin 2.5-5 mg BID** — anticholinergic; (f) **fezolinetant** — new (2023) neurokinin-3 (NK3) receptor antagonist — FDA-approved VMS, hormonal pathway-independent — promising for cancer survivors; (2) **non-pharmacologic**: (a) **CBT** — strong evidence — symptom + sleep + mood; (b) **mindfulness-based stress reduction (MBSR)**; (c) **clinical hypnosis** — moderate evidence; (d) **acupuncture** — limited evidence; (e) **lifestyle** — cool environment, layered clothing, avoid triggers (hot drinks, spicy, alcohol, caffeine), weight management, exercise (paradoxical short-term ↑ but long-term improvement), smoking cessation; (3) **vaginal estrogen** for GSM — controversial in breast cancer history → MDT discussion with oncology — low-dose vaginal estrogen (esp non-systemic forms — DHEA prasterone, ospemifene) generally acceptable after counseling + MDT; (4) **other** — black cohosh + soy isoflavone — mixed evidence + concern in ER+; (5) **sleep hygiene** + treatment of insomnia (CBT-I, melatonin); (6) **mood + anxiety screening** (often comorbid); (7) **support groups** + counseling; (8) **switching aromatase inhibitor** to alternative (anastrozole vs letrozole vs exemestane) sometimes helps; oncology consult; (9) **bone health** — DEXA, Ca/vit D, bisphosphonate (AI ↑ bone loss); (10) **lifelong oncology surveillance + survivorship care**

---

Breast cancer survivor + severe VMS: non-hormonal pharmacotherapy (SSRI/SNRI, gabapentin, clonidine, oxybutynin, fezolinetant new). CBT + MBSR + hypnosis + lifestyle. Avoid paroxetine + fluoxetine with tamoxifen (CYP2D6). Vaginal estrogen for GSM after MDT discussion. Bone surveillance + AI. Survivorship care.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'NAMS Non-hormonal Treatment VMS 2023; NCCN Survivorship', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 56 ปี postmenopausal × 4 yr มาด้วย hot flashes severe 15+/d + night sweats + insomnia, ก่อนหน้านี้ history of breast cancer ER+ × 4 yr ago, completed tamoxifen, currently NED, on aromatase inhibitor anastrozole — exacerbating VMS

V/S: BP 124/76, HR 78
Gen: well, distressed by VMS
Lab: no current cancer findings, mammogram recent normal
No CV disease, no VTE history'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามอาจารย์เรื่อง fetal endocrinology + maternal-fetal thyroid + adrenal axis', '[{"label":"A","text":"Fetal thyroid produces TSH from gestation"},{"label":"B","text":"fetal hypothalamus-pituitary axis"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Maternal T4 doesn''t cross placenta"},{"label":"E","text":"Hysterectomy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Fetal endocrinology: (1) **fetal hypothalamus-pituitary axis** develops 8-12 wk; (2) **fetal thyroid** — synthesizes hormones from ~ 10-12 wk; before that **maternal T4 critical** (crosses placenta — T4 > T3); maternal hypothyroidism untreated → fetal neurodevelopmental impairment (1st trimester critical); (3) **maternal iodine** — ↑ requirement 250 mcg/d (Thai dietary salt iodination); deficiency → cretinism; (4) **fetal thyroid hormones** — TBG synthesized fetal liver; T4 rises through gestation; **TSH** detectable from ~ 12 wk + rises late; (5) **at birth** — TSH surge (newborn screen at 48-72 hr), T4 ↑ acutely; newborn screening for **congenital hypothyroidism (CH)** mandatory (Thai national program; ~ 1/3,000); cretinism preventable; (6) **anti-thyroid drugs maternal** — PTU + methimazole cross placenta; PTU preferred 1st trimester (less teratogenic than methimazole — aplasia cutis, choanal/esophageal atresia); methimazole 2nd-3rd; (7) **Graves'' with TRAb +** — crosses placenta → fetal Graves'' (tachy, IUGR, goiter, craniosynostosis) — monitor fetal HR + thyroid US; (8) **fetal adrenal** — large in 2nd-3rd trimester (fetal zone — makes DHEAS → estriol via fetoplacental unit); regresses postnatally; (9) **cortisol from fetal adrenal** — required for lung maturation (surfactant), gut, brain; ↑ at birth helps lung; (10) **antenatal corticosteroid (betamethasone/dexamethasone)** — crosses placenta — accelerates fetal lung maturation + reduces RDS, IVH, NEC, mortality — 24-34 wk routinely (extend 34-36+6 wk ALPS); (11) **maternal cortisol** ↑ in pregnancy (estrogen ↑ CBG + free; physiologic hypercortisolism); usually not Cushingoid; (12) **CAH** — fetal 21-hydroxylase deficiency → virilization (female fetus) — prenatal dexamethasone to suppress fetal HPA controversial (rare research-protocol); (13) **fetal pancreas** — insulin from ~ 12 wk; **fetal hyperinsulinemia** in maternal hyperglycemia → macrosomia + hypoglycemia at birth

---

Fetal endocrinology: maternal T4 critical 1st trimester (fetal thyroid from 10-12 wk); newborn screen TSH at 48-72 hr (CH 1/3,000). Iodine 250 mcg. PTU 1st trimester, methimazole 2nd-3rd. Graves TRAb crosses → fetal Graves. Fetal adrenal large (DHEAS → estriol). Antenatal corticosteroid → lung maturation. CAH. Fetal insulin → macrosomia.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'basic_science', 'obgyn', 'adult',
  'Williams Obstetrics Ch 7 + 58; ATA Pregnancy Thyroid', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Resident ถามอาจารย์เรื่อง fetal endocrinology + maternal-fetal thyroid + adrenal axis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามอาจารย์เรื่อง renal physiology in pregnancy + interpretation of labs', '[{"label":"A","text":"GFR decreases in pregnancy"},{"label":"B","text":"Renal physiology in pregnancy"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Cr 0.9 normal in pregnancy"},{"label":"E","text":"Hysterectomy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Renal physiology in pregnancy: (1) **anatomic changes** — kidney enlarges ~ 1-1.5 cm (vascular + interstitial); **physiologic hydroureter + hydronephrosis** (R > L due to dextrorotation of uterus; progesterone smooth muscle relaxation) — late 1st trimester onward; persists 4-6 wk postpartum; can mimic obstruction; (2) **renal plasma flow** ↑ 60-80% by 2nd trimester; (3) **GFR** ↑ 50% by mid-pregnancy (peak ~ 200 mL/min from baseline ~ 120); via ↑ renal plasma flow + ↑ filtration fraction; (4) **lab implications**: (a) **serum creatinine ↓** to 0.4-0.7 (lab upper limit pregnancy ~ 0.8); **Cr 0.9-1.0 considered abnormal in pregnancy** (impaired renal function); (b) **BUN ↓** to ~ 8-10; (c) **uric acid ↓** in early pregnancy → rises slightly late; ↑ in preeclampsia; (d) **proteinuria** — physiologic up to 300 mg/24 hr; > 300 mg/24 hr or urine protein/Cr > 0.3 = pathologic (preeclampsia, renal disease); urine dipstick poor; (e) **glycosuria** — common (↓ tubular reabsorption + ↑ GFR) — physiologic; not always GDM; (f) **bicarbonate ↓** to ~ 19-22 (compensated respiratory alkalosis from ↑ tidal volume); (5) **water + electrolyte** — Na ↓ slightly (135-138), osmolality ↓ 5-10 mOsm/kg (resetting osmostat by hCG/relaxin); RAAS activated (↑ renin/angiotensin/aldosterone) — paradoxical hypervolemia with low colloid pressure; (6) **acid-base** — compensated respiratory alkalosis (PaCO2 28-32, HCO3 19-22); (7) **clinical implications**: (a) drugs renally cleared — adjust doses (LMWH, magnesium, gentamicin); (b) **CKD pregnancy** — Cr > 1.4 = ↑ risk progression + adverse outcomes; (c) **AKI in pregnancy** — preeclampsia/HELLP, AFLP, sepsis, hemorrhage, TTP/HUS, pyelonephritis, obstruction; (d) **preeclampsia** — endotheliosis, glomerular swelling, podocyte injury, proteinuria; (e) **postpartum AKI** — can be sentinel for atypical HUS (complement-mediated); (f) **dialysis pregnancy** — possible but complex; (8) **chronic HT/PE/preeclampsia long-term renal risk**

---

Pregnancy renal: GFR ↑ 50%, RPF ↑ 60-80%. Cr ↓ to 0.4-0.7 — Cr 0.9 abnormal pregnancy. Proteinuria > 300 mg/24h pathologic. Glycosuria common. Hydronephrosis R > L physiologic. Compensated respiratory alkalosis. Drug dosing adjusted. CKD Cr > 1.4 high-risk. AKI causes: PE/HELLP/AFLP/sepsis/TTP-HUS.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'basic_science', 'obgyn', 'adult',
  'Williams Obstetrics Ch 4; KDIGO Pregnancy + CKD', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Resident ถามอาจารย์เรื่อง renal physiology in pregnancy + interpretation of labs'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามอาจารย์เรื่อง vaginal microbiome + immunology + dysbiosis', '[{"label":"A","text":"Vaginal flora not important"},{"label":"B","text":"Vaginal microbiome + immunology"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Antibiotic continuously"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Vaginal microbiome + immunology**: (1) **normal vaginal flora** — dominated by **Lactobacillus** (L. crispatus most protective, L. gasseri, L. jensenii, L. iners less so); produce **lactic acid** + H2O2 → **acidic pH (3.8-4.5)** → inhibits pathogens; bacteriocins, biosurfactants; (2) **community state types (CSTs)**: I (L. crispatus), II (L. gasseri), III (L. iners — less stable), IV (diverse anaerobes, gardnerella — dysbiosis); (3) **dysbiosis** — ↓ Lactobacillus + ↑ anaerobes (Gardnerella, Atopobium, Mobiluncus, Prevotella) → BV, ↑ STI susceptibility, ↑ preterm birth, ↑ PID; (4) **hormonal influences** — estrogen ↑ glycogen in epithelium → Lactobacillus substrate; **postmenopause** ↓ estrogen → ↓ glycogen → ↓ Lactobacillus → ↑ pH 5-7 → atrophy, ↑ UTI/BV; pregnancy → ↑ Lactobacillus dominance (estrogen effect); (5) **factors disrupting** — douching, antibiotics, intercourse (semen alkaline), menstruation, smoking, IUD insertion (transient), STIs; (6) **innate immunity in genital tract** — antimicrobial peptides (defensins, cathelicidin, lactoferrin, lysozyme, SLPI, elafin); IgA + IgG mucosal Ab; mucus barrier; cervical plug (pregnancy); macrophages, DCs; PRRs (TLRs) recognize PAMPs; (7) **adaptive** — mucosal IgA + tissue-resident memory T cells; (8) **clinical correlates**: (a) **BV diagnosis + treatment** — covered separately; (b) **probiotics** — Lactobacillus crispatus + reuteri studied for BV recurrence + UTI prevention — mixed evidence; (c) **vaginal microbiome transplant (VMT)** — research for recurrent BV; (d) **HIV transmission** — dysbiotic flora ↑ susceptibility; (e) **preterm birth** — dysbiosis association with PTB; investigating screening + treatment; (f) **fertility + IVF** — dysbiosis may impair; (9) **prevention** — avoid douching, manage estrogen (postmenopause local estrogen), condom use, treat partners selectively, treat BV; (10) **research** — microbiome modulation therapies

---

Vaginal microbiome: Lactobacillus dominant → lactic acid + acidic pH protective. CST I (crispatus) most stable. Dysbiosis (CST IV) → BV, STI, preterm. Estrogen → glycogen → Lactobacillus. Postmenopausal ↓ flora. Innate immunity (defensins, IgA, mucus). Probiotics + VMT research. Prevention: avoid douching, condom, treat BV.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'basic_science', 'obgyn', 'adult',
  'Ravel Vaginal Microbiome PNAS 2011; SMFM Microbiome', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Resident ถามอาจารย์เรื่อง vaginal microbiome + immunology + dysbiosis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'OB unit implements shared decision-making (SDM) tools + birth plans + patient-centered care for delivery preferences', '[{"label":"A","text":"Provider decides everything"},{"label":"B","text":"Shared decision-making (SDM) + patient-centered care in OB"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Discharge if patient disagrees"},{"label":"E","text":"Hysterectomy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Shared decision-making (SDM) + patient-centered care in OB**: (1) **definition** — collaborative process where patient + provider make decisions together based on best evidence + patient values/preferences/circumstances; (2) **elements (Charles)** — both parties involved, information sharing both ways, deliberation, decision; (3) **components**: (a) discuss decision needed; (b) present **best evidence options + risks + benefits + uncertainty**; (c) elicit patient values + preferences; (d) deliberate + decide; (e) review/revisit; (4) **tools**: (a) **decision aids** — written, video, interactive (e.g., MFMU VBAC calculator, BWH decision aids, BabyCenter); (b) **birth plans** — preferences documented (positions, pain mgmt, monitoring, support, episiotomy, immediate skin-to-skin, delayed cord clamping, breastfeeding, family); written + flexible; (c) **OPTION scale** for measurement; (5) **specific OB SDM opportunities** — TOLAC vs ERCD, IOL vs expectant, prenatal screening (NIPT, amnio), epidural choice, induction methods, mode of breech delivery, fertility-sparing cancer options, postpartum contraception, breastfeeding decisions, advance directives (rare); (6) **respectful maternity care** — WHO statement — autonomy, consent, dignity, no abuse/coercion/discrimination; (7) **informed consent** continuous, not one-time; (8) **trauma-informed care** — recognize prior trauma + adjust approach; (9) **cultural humility** — language, beliefs, family roles; medical interpreters; (10) **doulas + companions** — improve outcomes + experience; ACOG endorses; Medicaid coverage expanding; (11) **patient-reported outcomes** + experience measures (PROMs, PREMs); (12) **provider training** — communication skills, SDM-OPTION, motivational interviewing; (13) **system support** — time, EMR tools, scheduling, decision-aid distribution; (14) **balance** — SDM doesn''t mean patient decides alone — guidance from provider; emergency situations differ; (15) Thai context — patient rights expanding; transition from paternalistic to partnership model

---

SDM in OB: collaborative — both parties — info + values + deliberation. Decision aids + birth plans + OPTION scale. Specific opportunities: TOLAC, IOL, screening, contraception, breech. Respectful maternity care (WHO). Trauma-informed + cultural humility + doulas. Provider training + system support. Balance — not abdication of expertise.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'ems_mgmt', 'obgyn', 'adult',
  'ACOG Committee Opinion 819: Informed Consent + SDM; WHO Respectful Maternity Care', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'OB unit implements shared decision-making (SDM) tools + birth plans + patient-centered care for delivery preferences'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital reviews disclosure + apology after adverse outcome — neonatal HIE following missed CTG abnormality leading to delayed C/S', '[{"label":"A","text":"Hide and deny"},{"label":"B","text":"Disclosure + apology + just culture after adverse outcome"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Refuse to discuss"},{"label":"E","text":"Hysterectomy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Disclosure + apology + just culture after adverse outcome**: (1) **Patient + family disclosure** — ethical + many jurisdictions legal requirement: (a) timely (within 24-48 hr after event), (b) honest factual account, (c) acknowledge harm + expression of empathy/apology, (d) commitment to investigation + sharing findings, (e) ongoing support; (2) **''Apology laws''** — many US states protect expressions of sympathy from being used as admissions of liability — encourage transparency; Thai legal landscape — encourage open disclosure; (3) **Communication and Resolution Programs (CRPs)** — institutional approach (Michigan model, AHRQ CANDOR toolkit) — investigate + disclose + compensate when appropriate → reduces litigation + costs vs deny-defend; (4) **second victims** — providers + staff involved in adverse events suffer psychological harm — provide peer support, employee assistance, debriefing; (5) **investigation**: (a) **Root Cause Analysis (RCA)** — systematic identification of contributing factors (system, communication, equipment, training, fatigue, cognitive bias); (b) **fishbone, 5-whys** tools; (c) **avoid blame** — Just Culture framework; (6) **Just Culture** — distinguish: (a) human error (console + system fix), (b) at-risk behavior (coach), (c) reckless behavior (discipline); (7) **implementation of corrective actions** — protocol changes, equipment, training, simulation; track outcomes; (8) **morbidity + mortality (M&M) conferences** — confidential learning forum; (9) **patient safety culture** — Safety Attitudes Questionnaire; psychological safety; (10) **ongoing care + support** — continuity of care for harmed patient + family; mental health; spiritual support; (11) **bereavement + perinatal loss** — comprehensive support; (12) **legal counsel** — institutional; risk management; (13) **document** factually; (14) **share learning broadly** — lessons → other institutions; (15) **measure** — disclosure + resolution outcomes; (16) Thai context — Medical Council ethical guidelines + Thai Patient Safety Goals (2P safety, 3P safety frameworks)

---

Disclosure + apology: timely, honest, empathetic, ongoing. CRP institutional approach (CANDOR) — reduces litigation. Second victim support. RCA + Just Culture (human error vs at-risk vs reckless). M&M. Corrective actions + tracked. Safety culture. Bereavement support. Thai Patient Safety Goals. Share learning.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'ems_mgmt', 'obgyn', 'adult',
  'AHRQ CANDOR Toolkit; ACOG Committee Opinion 681: Disclosure + Discussion of Adverse Events', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Hospital reviews disclosure + apology after adverse outcome — neonatal HIE following missed CTG abnormality leading to delayed C/S'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงตั้งครรภ์ G2P1 GA 28 wk underlying healthy — มาห้องฉุกเฉินด้วย acute COVID-19 (PCR-confirmed) — moderate-severe symptoms (SpO2 91% on RA, dyspnea, fever, fatigue) + bilateral infiltrates on CXR

V/S: BP 118/72, HR 110, RR 26, Temp 38.6, SpO2 91% RA
Gen: dyspneic, distressed
Fetal: FHR 158 reactive, no contractions
Lab: WBC 10K, CRP 95, D-dimer 2,400, ferritin 950, LDH 380, lymphocytes 0.8
CXR: bilateral ground-glass + lower lobe infiltrates
No prior COVID vaccination', '[{"label":"A","text":"Discharge home"},{"label":"B","text":"COVID-19 in pregnancy with moderate-severe disease"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Refuse all treatment"},{"label":"E","text":"Hysterectomy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **COVID-19 in pregnancy with moderate-severe disease** — pregnancy ↑ risk severe + adverse outcomes (preterm, stillbirth, ICU, mortality, VTE): (1) **admit + supportive care** + multidisciplinary (MFM + ID + pulmonary + ICU); (2) **oxygen** — target SpO2 ≥ 95% for fetal well-being; nasal cannula → HFNC → NIV → intubation as needed; awake proning encouraged (oxygenation + delays intubation); LUD when supine; (3) **antiviral** — **remdesivir** safe in pregnancy (acceptable per CDC/IDSA — limited but reassuring data) — 5-d course for moderate-severe; **nirmatrelvir-ritonavir (Paxlovid)** for mild-moderate outpatient if early (within 5 d) + risk factors — limited pregnancy data but generally acceptable per IDSA/RECOVERY; (4) **dexamethasone** — recommended for severe (requiring O2) per RECOVERY trial — improves mortality; cross placenta but benefit > risk in severe maternal disease; consider standard antenatal corticosteroid course concurrently if preterm risk (24-34 wk); (5) **anticoagulation** — VTE risk markedly ↑ in COVID + pregnancy — **prophylactic LMWH** for all hospitalized; therapeutic for confirmed VTE; (6) **immunomodulators** — **tocilizumab** (IL-6 inhibitor) for severe + escalating O2 needs — limited pregnancy data but RECOVERY/REMAP-CAP support; baricitinib alternative; (7) **antibiotics** — only if bacterial coinfection (procalcitonin); (8) **fetal monitoring** — continuous EFM, daily NST, growth + Doppler if FGR; (9) **delivery considerations** — COVID not indication for delivery; deliver per obstetric indication or maternal deterioration; if maternal ICU + respiratory failure → may improve respiratory status with delivery (controversial); preterm delivery for failing maternal status; (10) **mode of delivery** — vaginal preferred unless obstetric indication; PPE for staff; (11) **postpartum** — continue treatment + monitor; thromboprophylaxis 6 wk postpartum; (12) **breastfeeding** — encouraged with precautions (mask, hand hygiene; SARS-CoV-2 not transmitted via milk; antibodies transferred); (13) **vaccination** — recommend mRNA COVID vaccine + boosters in pregnancy + postpartum + breastfeeding (CDC/ACOG); (14) **neonatal** — monitor + universal precautions; (15) **mental health + family support** + telehealth follow-up

---

COVID-19 pregnancy moderate-severe: admit + multidisciplinary. O2 target ≥ 95%. Remdesivir + dexamethasone (severe) + LMWH prophylaxis. Tocilizumab severe. Continuous fetal monitoring. Not indication for delivery — per obstetric. Vaginal preferred. Vaccine recommended pregnancy + postpartum. Breastfeeding safe with precautions. VTE 6 wk postpartum. Awake proning.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'integrative', 'obgyn', 'adult',
  'RECOVERY Trial; CDC/ACOG COVID-19 Pregnancy Guidance; SMFM COVID Updates', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงตั้งครรภ์ G2P1 GA 28 wk underlying healthy — มาห้องฉุกเฉินด้วย acute COVID-19 (PCR-confirmed) — moderate-severe symptoms (SpO2 91% on RA, dyspnea, fever, fatigue) + bilateral infiltrates on CXR

V/S: BP 118/72, HR 110, RR 26, Temp 38.6, SpO2 91% RA
Gen: dyspneic, distressed
Fetal: FHR 158 reactive, no contractions
Lab: WBC 10K, CRP 95, D-dimer 2,400, ferritin 950, LDH 380, lymphocytes 0.8
CXR: bilateral ground-glass + lower lobe infiltrates
No prior COVID vaccination'
  );

commit;

