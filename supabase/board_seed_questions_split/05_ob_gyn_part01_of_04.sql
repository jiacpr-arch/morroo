-- ===============================================================
-- หมอรู้ — Board seed: สูติศาสตร์-นรีเวชวิทยา (ob_gyn) — part 1/4 (50 MCQs)
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
  s.id, 'board', NULL, 'หญิงตั้งครรภ์ GA 36 wk G1P0 มา ANC ตรวจ BP 162/108 (สูงต่อเนื่อง 3 ครั้ง ห่าง 4 ชม) + proteinuria 3+ + edema + ปวดศีรษะ + เห็นแสงวาบ

Lab: Plt 88,000, AST 188, ALT 142, LDH 685, Cr 1.2, Total protein 5.8, Uric acid 7.8
Urine protein/Cr 4.2 g/g, 24h urine protein 5.2 g', '[{"label":"A","text":"Observation outpatient"},{"label":"B","text":"Severe Preeclampsia with HELLP syndrome (BP severe + end-organ dysfunction)"},{"label":"C","text":"Wait until 40 weeks"},{"label":"D","text":"Anti-hypertensive only without delivery"},{"label":"E","text":"Aspirin only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe Preeclampsia with HELLP syndrome (BP severe + end-organ dysfunction): admit; IV magnesium sulfate 4-6g loading then 1-2g/hr × 24h (seizure prophylaxis); antihypertensive — IV labetalol 20-80mg or hydralazine 5-10mg or oral nifedipine 10-20mg (target BP 140-150/90-100, not normal — placental perfusion); corticosteroid betamethasone 12mg IM × 2 (fetal lung maturity even at 36 wk if preterm) — but at 36 wk + HELLP = expedite delivery; **expedite delivery** is definitive treatment (HELLP + severe features → delivery regardless of GA after stabilization); mode (vaginal vs c-section) per obstetric indication; postpartum: continue magnesium 24h after delivery, BP monitoring, may need antihypertensive 6 wk

---

Preeclampsia: BP ≥ 140/90 + proteinuria (or end-organ dysfunction without proteinuria) after 20 wk. Severe features: BP ≥ 160/110, plt < 100K, LFT 2× ULN, Cr > 1.1, pulmonary edema, visual/cerebral symptoms. HELLP: hemolysis + elevated LFT + low platelets. Delivery is definitive Rx. Magnesium for seizure prophylaxis (eclampsia). BP control (avoid maternal stroke; don''t over-correct — placental perfusion). Steroid if < 34 wk. Postpartum continue Mg + monitor.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin: Gestational HTN + Preeclampsia 2020; SMFM Consult Series; ISSHP 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงตั้งครรภ์ GA 36 wk G1P0 มา ANC ตรวจ BP 162/108 (สูงต่อเนื่อง 3 ครั้ง ห่าง 4 ชม) + proteinuria 3+ + edema + ปวดศีรษะ + เห็นแสงวาบ

Lab: Plt 88,000, AST 188, ALT 142, LDH 685, Cr 1.2, Total protein 5.8, Uric acid 7.8
Urine protein/Cr 4.2 g/g, 24h urine protein 5.2 g'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงตั้งครรภ์ GA 32 wk G2P1 มาห้องฉุกเฉินด้วย contractions ทุก 5 นาที × 2 ชม + กระเป๋าน้ำคร่ำไม่แตก

Cervix exam: 2 cm dilated, 80% effaced, ทารก vertex
Fetal heart rate: 142 reassuring
US: ทารกประมาณ 1,800g, AFI ปกติ, placenta upper segment', '[{"label":"A","text":"Discharge home"},{"label":"B","text":"Preterm Labor"},{"label":"C","text":"Cesarean immediately"},{"label":"D","text":"Antibiotic only"},{"label":"E","text":"Discharge with progesterone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Preterm Labor: admit + assess; tocolytics — nifedipine 20-30mg PO loading then 10-20mg q4-6h (preferred, calcium channel blocker) OR indomethacin (< 32 wk only — ductus arteriosus closure risk); other options atosiban (oxytocin antagonist), magnesium (also neuroprotection); duration 48h to allow steroid + transfer; antenatal corticosteroid betamethasone 12mg IM × 2 doses 24h apart (mature fetal lung — reduces RDS, IVH, NEC, mortality 30-50% per Cochrane); magnesium sulfate 4-6g loading then 1-2g/hr for fetal neuroprotection (< 32 wk); GBS prophylaxis if positive or unknown; do NOT tocolyze if: chorioamnionitis, severe preeclampsia/eclampsia, abruption, IUFD, lethal anomaly, advanced labor > 5cm; counsel for NICU; consider transfer to tertiary if level 3 NICU not available

---

Preterm labor: contractions + cervical change before 37 wk. Management focus: delay birth 48h for steroids + neuroprotection + transfer. Tocolytics (nifedipine first-line, atosiban, MgSO4, indomethacin < 32 wk). Antenatal steroids — Liggins 1972 — major mortality reduction. Magnesium for fetal neuroprotection < 32 wk. GBS prophylaxis. Don''t tocolyze if contraindicated. Transfer to tertiary if possible.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin: Management of Preterm Labor 2016; Cochrane Reviews', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงตั้งครรภ์ GA 32 wk G2P1 มาห้องฉุกเฉินด้วย contractions ทุก 5 นาที × 2 ชม + กระเป๋าน้ำคร่ำไม่แตก

Cervix exam: 2 cm dilated, 80% effaced, ทารก vertex
Fetal heart rate: 142 reassuring
US: ทารกประมาณ 1,800g, AFI ปกติ, placenta upper segment'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 28 ปี G2P1 GA 39 wk normal delivery NSD 2 ชม ก่อน อยู่หลังคลอด มาด้วยอาการ heavy bleeding + uterus boggy + ปวดท้อง

V/S: BP 88/52, HR 132, RR 24
Gen: pale, anxious
Uterus: 4 finger breadths above umbilicus, soft + boggy
Bleeding: heavy ongoing ~ 1L estimated

Hb 6.4 (baseline 11), Plt 178K, INR 1.2
Cervix exam: no laceration, placenta delivered complete', '[{"label":"A","text":"Observation + IV fluid only"},{"label":"B","text":"Postpartum Hemorrhage (PPH > 500mL NSD, > 1000mL C/S, or any with hypovolemia) from uterine atony (most common cause"},{"label":"C","text":"Hysterectomy immediately"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Anticoagulation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Postpartum Hemorrhage (PPH > 500mL NSD, > 1000mL C/S, or any with hypovolemia) from uterine atony (most common cause — 70%): activate massive transfusion protocol if needed; uterine massage (bimanual); empty bladder (catheter); IV oxytocin 10-40 units in 1L NSS infusion (first-line — already given postpartum); second-line uterotonics: methylergonovine 0.2mg IM (CI in HT/preeclampsia), carboprost (15-methyl PGF2α) 250mcg IM (CI in asthma), misoprostol 800-1000mcg PR; tranexamic acid 1g IV (WOMAN trial); blood products with MTP protocol 1:1:1; balloon tamponade (Bakri); uterine artery embolization (IR); surgical: B-Lynch suture, uterine artery ligation, hysterectomy (last resort); identify 4 T''s: Tone (atony), Trauma (laceration), Tissue (retained), Thrombin (coagulopathy)

---

PPH = leading cause of maternal mortality globally. 4 T''s: **T**one (atony 70% — most common), **T**rauma (laceration, hematoma), **T**issue (retained products), **T**hrombin (coagulopathy). Atony management: massage + uterotonics (oxytocin first-line, then methylergonovine, carboprost, misoprostol) + balloon tamponade + uterine artery embolization + surgical options. TXA within 3h reduces mortality (WOMAN trial). Blood products 1:1:1. Hysterectomy last resort. Active management of 3rd stage (oxytocin) reduces PPH.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin: Postpartum Hemorrhage 2017; WHO PPH Guidelines; WOMAN Trial Lancet 2017', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 28 ปี G2P1 GA 39 wk normal delivery NSD 2 ชม ก่อน อยู่หลังคลอด มาด้วยอาการ heavy bleeding + uterus boggy + ปวดท้อง

V/S: BP 88/52, HR 132, RR 24
Gen: pale, anxious
Uterus: 4 finger breadths above umbilicus, soft + boggy
Bleeding: heavy ongoing ~ 1L estimated

Hb 6.4 (baseline 11), Plt 178K, INR 1.2
Cervix exam: no laceration, placenta delivered complete'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 32 ปี G3P2 GA 28 wk ANC ตรวจพบ GDM screening positive (OGTT fasting 105, 1h 195, 2h 168 — meets ADA/ACOG criteria)

ก่อนหน้านี้ลูก 1 คนเป็น macrosomia 4.2kg shoulder dystocia
Family history: father DM type 2', '[{"label":"A","text":"Ignore — manage after delivery"},{"label":"B","text":"Gestational Diabetes Mellitus (GDM) management"},{"label":"C","text":"Insulin without diet education"},{"label":"D","text":"Cesarean immediately"},{"label":"E","text":"Restrict carbohydrate completely"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Gestational Diabetes Mellitus (GDM) management: (1) Medical nutrition therapy first-line (registered dietitian — 40-50% calories from carb, 20% protein, 30-40% fat, distributed 3 meals + 2-3 snacks); (2) Exercise 30 min/d if no contraindication; (3) Self-monitor blood glucose 4×/d (fasting + 1 or 2h postprandial) — targets: fasting < 95, 1h < 140, 2h < 120; (4) Pharmacotherapy if MNT fail (target not met 50% of time after 1-2 wk): **insulin** preferred (does not cross placenta — long-acting NPH/detemir/glargine + rapid lispro/aspart); metformin/glyburide alternatives (cross placenta, ACOG accepts but insulin preferred); (5) Antepartum surveillance — NST + AFI weekly from 32-34 wk; (6) Delivery timing — 39-40 wk uncomplicated GDM on diet; 39 wk if on medication well-controlled; earlier if complications; (7) Intrapartum: glucose control 70-110, insulin drip if needed; (8) Postpartum: usually return to normal; OGTT 6-12 wk postpartum (50% develop T2DM lifetime); (9) Lifestyle: weight, exercise, prevention; (10) Recurrence high in future pregnancies

---

GDM: glucose intolerance first recognized in pregnancy. Screening 24-28 wk (1-step OGTT 75g or 2-step). Management: MNT first, insulin if MNT fail (insulin preferred — no placental crossing). Surveillance + delivery timing. Macrosomia, shoulder dystocia, preeclampsia, NICU risks. Postpartum OGTT — 50% develop T2DM. Lifestyle modification reduces.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin: Gestational Diabetes Mellitus 2018; ADA Standards of Care 2024', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 32 ปี G3P2 GA 28 wk ANC ตรวจพบ GDM screening positive (OGTT fasting 105, 1h 195, 2h 168 — meets ADA/ACOG criteria)

ก่อนหน้านี้ลูก 1 คนเป็น macrosomia 4.2kg shoulder dystocia
Family history: father DM type 2'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 22 ปี LMP 6 สัปดาห์ที่แล้ว มาห้องฉุกเฉินด้วยอาการ acute onset ปวดท้องน้อยขวา + vaginal spotting 12 ชม

V/S: BP 96/62, HR 108
Gen: pale, anxious
Abdomen: RLQ + suprapubic tenderness, guarding +
Pelvic: cervical motion tenderness +, right adnexal mass + tenderness

β-hCG quantitative 4,800 mIU/mL
US pelvis: empty uterus + right adnexal complex mass 3.5cm + free fluid in pelvis (moderate)', '[{"label":"A","text":"Observation"},{"label":"B","text":"Ectopic Pregnancy (high suspicion: β-hCG > 1500 + empty uterus + adnexal mass + free fluid): IV access × 2 + type & cross; consult OB-GYN immediately; treatment options"},{"label":"C","text":"Misoprostol for missed abortion"},{"label":"D","text":"Continue current pregnancy support"},{"label":"E","text":"Discharge with iron supplement"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Ectopic Pregnancy (high suspicion: β-hCG > 1500 + empty uterus + adnexal mass + free fluid): IV access × 2 + type & cross; consult OB-GYN immediately; treatment options: (1) **Methotrexate** (medical management) — criteria: hemodynamically stable, β-hCG < 5000, ectopic < 3.5cm, no fetal heart, no rupture; protocol single-dose 50 mg/m² IM, follow β-hCG day 4 + 7 (expect 15% decline), repeat if needed; (2) **Surgical** — laparoscopic salpingostomy (preserve tube) or salpingectomy (remove tube — if extensive damage, contralateral healthy tube, no future fertility plan) — indications: hemodynamic instability, rupture, methotrexate CI, large mass, fetal heart, β-hCG > 5000; (3) **Expectant management** — selected very low β-hCG declining; (4) Rh(D)-negative + bleeding → Anti-D Ig 50-300 mcg; (5) Contraception + future fertility counseling; (6) **Differential**: PID, ovarian cyst, appendicitis, threatened abortion

---

Ectopic pregnancy: implantation outside uterine cavity (95% tubal). Suspicion: positive β-hCG + abdominal pain + bleeding + adnexal mass. Discriminatory zone: β-hCG > 1500-2000 + no IUP on TVS = ectopic likely. Methotrexate vs surgery decision: hemodynamics, β-hCG, size, fetal heart, patient factors. Rupture = surgical emergency. Future fertility preserved better with conservative management. Counsel + contraception + future fertility.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin: Tubal Ectopic Pregnancy 2018; ASRM Practice Committee', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 22 ปี LMP 6 สัปดาห์ที่แล้ว มาห้องฉุกเฉินด้วยอาการ acute onset ปวดท้องน้อยขวา + vaginal spotting 12 ชม

V/S: BP 96/62, HR 108
Gen: pale, anxious
Abdomen: RLQ + suprapubic tenderness, guarding +
Pelvic: cervical motion tenderness +, right adnexal mass + tenderness

β-hCG quantitative 4,800 mIU/mL
US pelvis: empty uterus + right adnexal complex mass 3.5cm + free fluid in pelvis (moderate)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 35 ปี G2P1 GA 38 wk มา L/R complaining of decreased fetal movement × 12 ชม + small amount vaginal bleeding

V/S: BP 112/72, HR 92, RR 16
Abdomen: tense + tender + palpable contractions painful
Fetal heart: 110 (mild bradycardia)
Cervix: closed, no advanced labor

US: placental abruption suspected (retroplacental clot + abnormal placental edge)
Lab: Hb 10.4, Plt 162K, Fibrinogen 220 (low), INR 1.6 (high) — DIC features developing', '[{"label":"A","text":"Observation"},{"label":"B","text":"Placental Abruption (premature separation) with developing DIC + non-reassuring fetal status"},{"label":"C","text":"Vaginal delivery induction"},{"label":"D","text":"Tocolytic"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Placental Abruption (premature separation) with developing DIC + non-reassuring fetal status: emergency C-section delivery (immediate — both mother + fetus at risk); concurrent: IV access × 2 large bore + type & cross 4 units PRC + 4 FFP; correct coagulopathy (FFP, cryoprecipitate for fibrinogen < 200, platelets if < 50K, PRBCs); manage shock; massive transfusion protocol if needed; tranexamic acid (WOMAN); anesthesia consultation; NICU notification; postpartum: monitor for PPH (uterine atony commonly follows), continue coagulopathy correction, monitor Hb, may need ICU; counsel: 5-15% recurrence next pregnancy; risk factors: HT, smoking, cocaine, trauma, prior abruption, advanced maternal age, multiple gestation

---

Placental abruption: premature separation. Spectrum from mild to catastrophic. Severe: pain + bleeding + uterine tetany + DIC + fetal distress. Risk factors: HT, smoking, cocaine, trauma, prior abruption. Imaging: US often misses (only sees if large clot). Diagnosis often clinical. Management: stabilize + deliver (C-section if non-reassuring fetal status or maternal compromise; vaginal if reassuring + stable + advanced labor). Major bleeding + DIC complication. PPH common. Recurrence risk 5-15%.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin: Placental Abruption 2006 (reaffirmed); Williams Obstetrics 26th ed', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 35 ปี G2P1 GA 38 wk มา L/R complaining of decreased fetal movement × 12 ชม + small amount vaginal bleeding

V/S: BP 112/72, HR 92, RR 16
Abdomen: tense + tender + palpable contractions painful
Fetal heart: 110 (mild bradycardia)
Cervix: closed, no advanced labor

US: placental abruption suspected (retroplacental clot + abnormal placental edge)
Lab: Hb 10.4, Plt 162K, Fibrinogen 220 (low), INR 1.6 (high) — DIC features developing'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 45 ปี มา OPD ด้วยอาการเลือดประจำเดือนผิดปกติ — heavy menstrual bleeding + intermenstrual spotting × 6 เดือน + น้ำหนักลด 3 kg

LMP irregular last 4 months
No dyspareunia, no fever

V/S: ปกติ
Pelvic exam: enlarged uterus 14 wk size + irregular contour
No cervical lesion, no adnexal mass

Lab: Hb 9.2 (anemia), TSH normal
US: multiple uterine fibroids (intramural + submucosal) largest 6cm + endometrial thickening 14mm
Endometrial biopsy: complex hyperplasia without atypia', '[{"label":"A","text":"Hysterectomy alone"},{"label":"B","text":"Treatment of hyperplasia without atypia"},{"label":"C","text":"Observation only"},{"label":"D","text":"Total pelvic radiation"},{"label":"E","text":"Chemotherapy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Abnormal Uterine Bleeding (AUB) — PALM-COEIN classification: structural (P-polyp, A-adenomyosis, L-leiomyoma, M-malignancy/hyperplasia) + non-structural (C-coagulopathy, O-ovulatory dysfunction, E-endometrial, I-iatrogenic, N-not classified); this patient: leiomyoma + complex hyperplasia: (1) **Iron supplement** for anemia; (2) **Treatment of hyperplasia without atypia**: progestin (LNG-IUD preferred — Mirena 90% effective + provides contraception + treats heavy bleeding; or oral medroxyprogesterone, micronized progesterone, megestrol) × 3-6 mo then repeat biopsy; if complex with atypia → hysterectomy preferred (high cancer risk); (3) **Treatment of fibroids causing AUB**: - Medical: LNG-IUD, combined OCP, NSAIDs, tranexamic acid acute (Lukes JAMA 2010), GnRH agonist temporary (suppress to operate), GnRH antagonist (elagolix); - Procedural: uterine artery embolization (UAE — preserves uterus, fibroid shrink), myomectomy (preserves uterus + fertility — open, laparoscopic, hysteroscopic for submucosal); hysterectomy (definitive — for refractory + completed childbearing or large symptomatic); endometrial ablation (alternative); (4) Counseling: future fertility, recurrence (fibroids), follow-up; (5) Surveillance for hyperplasia progression + endometrial cancer

---

AUB workup: PALM-COEIN classification (Munro AOG 2011). Structural causes more common with age. Endometrial sampling required for risk factors (age > 45, persistent AUB, obesity, anovulation, HRT). Hyperplasia without atypia: progestin Rx + reassess. Hyperplasia with atypia: hysterectomy preferred (40% concurrent cancer). Fibroid management: medical + procedural + surgical based on size, location, symptoms, fertility desires. LNG-IUD highly effective for heavy menstrual bleeding.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Committee Opinion: Endometrial Intraepithelial Neoplasia 2015; FIGO PALM-COEIN 2018; ACOG Practice Bulletin: Management of Symptomatic Uterine Leiomyomas', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 45 ปี มา OPD ด้วยอาการเลือดประจำเดือนผิดปกติ — heavy menstrual bleeding + intermenstrual spotting × 6 เดือน + น้ำหนักลด 3 kg

LMP irregular last 4 months
No dyspareunia, no fever

V/S: ปกติ
Pelvic exam: enlarged uterus 14 wk size + irregular contour
No cervical lesion, no adnexal mass

Lab: Hb 9.2 (anemia), TSH normal
US: multiple uterine fibroids (intramural + submucosal) largest 6cm + endometrial thickening 14mm
Endometrial biopsy: complex hyperplasia without atypia'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 26 ปี ไม่มีโรคประจำตัว มาตรวจคัดกรอง pap smear (cervical cytology) ผลเป็น HSIL (high-grade squamous intraepithelial lesion)

Follow-up colposcopy: CIN 2-3 confirmed by biopsy
HPV testing: positive HPV 16 + 18

ไม่มีอาการ, sexually active, ไม่ pregnant', '[{"label":"A","text":"Observe + repeat in 5 years"},{"label":"B","text":"Cervical CIN 2-3 (high-grade) — pre-cancerous lesion requiring treatment"},{"label":"C","text":"Total hysterectomy"},{"label":"D","text":"Chemotherapy"},{"label":"E","text":"Stop screening"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cervical CIN 2-3 (high-grade) — pre-cancerous lesion requiring treatment: (1) **Excisional treatment preferred** over ablation: LEEP (loop electrosurgical excision procedure) — most common, outpatient, can do cone biopsy at same time; cold-knife conization (CKC) — for endocervical lesion, possible micro-invasion; (2) **Ablative treatment** alternative (cryotherapy, laser) — only for selected (visible squamocolumnar junction, no glandular involvement, no suspicion for invasion); (3) **Post-treatment surveillance**: cytology + HPV co-testing 6 + 18 months + annually × 3 years then routine if normal; (4) Margin status: if positive endocervical margin → repeat excision or close follow-up; (5) **Pregnancy considerations**: LEEP/CKC increase preterm birth risk slightly; defer if pregnant unless invasive; (6) **HPV vaccination** for partner, future children (HPV vaccine for women 9-26 routinely, 27-45 selective; nonavalent vaccine covers 90% cervical cancers); (7) Counseling: HPV common, often clears, treatable lesion not cancer, importance of follow-up; (8) Sexual partner — no specific testing; (9) Smoking cessation (smoking accelerates CIN progression); (10) Long-term: HPV co-testing q 3-5 years standard cervical cancer screening

---

Cervical cancer prevention: HPV vaccination + screening + treat precancers. HPV 16, 18 cause 70% cervical cancers. CIN 2-3 = high-grade precancer → 30% progress to cancer if untreated. Treatment: excisional (LEEP, CKC) preferred. ASCCP risk-based management guidelines. Post-treatment surveillance critical. HPV vaccine effective for prevention. Modern: HPV primary screening replacing cytology in many settings. WHO target — eliminate cervical cancer.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin: Management of Abnormal Cervical Cancer Screening Tests 2020; ASCCP Risk-Based Management Consensus Guidelines 2019', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 26 ปี ไม่มีโรคประจำตัว มาตรวจคัดกรอง pap smear (cervical cytology) ผลเป็น HSIL (high-grade squamous intraepithelial lesion)

Follow-up colposcopy: CIN 2-3 confirmed by biopsy
HPV testing: positive HPV 16 + 18

ไม่มีอาการ, sexually active, ไม่ pregnant'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 58 ปี postmenopausal × 7 ปี ก่อนหน้านี้ healthy มาด้วยอาการ vaginal bleeding ผิดปกติ 2 สัปดาห์ — เลือดออกเล็กน้อยติดต่อกัน

BMI 32 (obese), DM type 2, HT, ไม่เคยตั้งครรภ์

V/S: BP 142/88, HR 78
Gen: well, slightly obese
Pelvic exam: ปกติ external + cervix
No adnexal mass

US: endometrial thickness 18mm (postmenopausal > 4 mm requires evaluation)
Endometrial biopsy: endometrioid adenocarcinoma, Grade 1, hormone receptor positive', '[{"label":"A","text":"Observation"},{"label":"B","text":"Endometrial Adenocarcinoma Stage I (presumed — endometrioid, low grade) — surgical staging primary"},{"label":"C","text":"Hormone replacement therapy"},{"label":"D","text":"Discharge — physiologic bleeding"},{"label":"E","text":"Pap smear only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Endometrial Adenocarcinoma Stage I (presumed — endometrioid, low grade) — surgical staging primary: (1) **Surgical staging** = standard of care — laparoscopic, robotic, or open total hysterectomy + bilateral salpingo-oophorectomy + lymphadenectomy (sentinel node biopsy increasingly used vs full pelvic + para-aortic dissection); peritoneal washings, omentectomy in selected; (2) **Final stage** determined by surgical pathology — FIGO 2009 + 2023 updates; (3) **Adjuvant therapy** based on risk: Stage IA Grade 1-2: no adjuvant; Stage IA Grade 3 or IB: vaginal brachytherapy +/- chemotherapy; Stage II-III: external beam RT + chemotherapy (carboplatin + paclitaxel); (4) **Molecular classification** (TCGA): POLE-ultramutated (good prognosis), MSI-high, copy-number low/p53 wild-type, copy-number high/p53 mutant (worst); guides therapy increasingly; (5) **Hormonal therapy** (selected): progestin for poor surgical candidates or fertility preservation in Grade 1; (6) **Targeted therapy**: pembrolizumab + lenvatinib for advanced/recurrent (KEYNOTE-775); (7) **Lifestyle**: weight loss, glycemic control, exercise; (8) **Genetic counseling**: Lynch syndrome screening (3-5% of endometrial cancers, age < 50, family history); (9) **Survivorship**: surveillance pelvic exam, symptoms monitoring; (10) **Multidisciplinary**: GYN-oncology, radiation oncology, medical oncology

---

Postmenopausal bleeding ALWAYS requires evaluation — endometrial cancer until proven otherwise. Type I (endometrioid, estrogen-dependent — obesity, DM, nulliparity, late menopause, tamoxifen) vs Type II (serous, clear cell — older, p53). Surgical staging standard. Molecular classification (TCGA) emerging. Lynch syndrome screening — implications for family. Adjuvant therapy stage + grade + molecular based. Survival good if early (Stage I > 90% 5-year).', NULL,
  'medium', 'hemato_onco', 'review',
  'ob_gyn', 'clinical_decision', 'hemato_onco', 'adult',
  'ACOG Committee Opinion: Endometrial Cancer 2015 + updates; NCCN Uterine Cancer 2024; ESGO/ESTRO/ESP Guidelines 2021', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 58 ปี postmenopausal × 7 ปี ก่อนหน้านี้ healthy มาด้วยอาการ vaginal bleeding ผิดปกติ 2 สัปดาห์ — เลือดออกเล็กน้อยติดต่อกัน

BMI 32 (obese), DM type 2, HT, ไม่เคยตั้งครรภ์

V/S: BP 142/88, HR 78
Gen: well, slightly obese
Pelvic exam: ปกติ external + cervix
No adnexal mass

US: endometrial thickness 18mm (postmenopausal > 4 mm requires evaluation)
Endometrial biopsy: endometrioid adenocarcinoma, Grade 1, hormone receptor positive'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 32 ปี ตั้งครรภ์ GA 12 wk G1P0 มาตรวจ ANC ครั้งแรก — counseling on prenatal genetic screening + first trimester care

No family history concerning, no consanguinity
Maternal age 32 (not advanced maternal age which is 35+)
No medical comorbidity', '[{"label":"A","text":"No screening needed"},{"label":"B","text":"Comprehensive First Trimester Care"},{"label":"C","text":"Cesarean planned at 39 wk"},{"label":"D","text":"Single visit follow-up"},{"label":"E","text":"No vaccination"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Comprehensive First Trimester Care: (1) **History + examination**: comprehensive including obstetric, medical, surgical, family, social, drug, allergy, mental health, IPV screening; (2) **Vital signs + BMI + edema baseline**; (3) **Lab tests**: CBC, blood group + Rh + antibody screen, hepatitis B sAg, syphilis (VDRL/RPR), HIV (opt-out), rubella IgG, varicella IgG if no history, urine culture + UA, Pap smear if due (per cervical screening guideline), GBS at 36-37 wk; (4) **Genetic screening (offered to all regardless of age — ACOG 2020)**: first trimester combined screen (PAPP-A + free β-hCG + NT US at 11-13+6 wk — detects 85% Down with 5% FPR); cell-free DNA / NIPT (cfDNA from maternal blood — detects 99% Down, also 18, 13, sex chromosomes, increasingly accurate, growing standard); quad screen 15-20 wk if not first; diagnostic — CVS 10-13 wk (1% miscarriage), amniocentesis 15-20 wk (0.5% miscarriage) — for positive screen or specific risk; (5) **Carrier screening** (offered all): cystic fibrosis, spinal muscular atrophy, hemoglobinopathies (thalassemia in Asian — Thai high risk!), fragile X, Ashkenazi panel, expanded carrier; (6) **Vaccinations**: Tdap (27-36 wk), flu (any time), COVID, RSV (32-36 wk new); (7) **Counseling**: nutrition (folate 400 mcg + iron + calcium + DHA), exercise (moderate OK), avoid alcohol/smoking/illicit, medications review (teratogens), seafood, listeria foods, hot tubs, travel; (8) **Schedule prenatal visits** per gestational age; (9) **Mental health screening**: depression, anxiety; (10) **Anticipatory guidance** + birth plan; (11) **Confirm IUP + viability** US

---

Comprehensive first trimester prenatal care = foundation. Universal genetic screening offered (ACOG 2020 update — previously only AMA). NIPT increasingly standard. Carrier screening — Thai population specific (thalassemia high prevalence). Vaccinations (Tdap, flu, COVID, RSV). Nutrition + lifestyle counseling. Mental health screening. Multidisciplinary if high-risk. Quality care = better outcomes (Thai maternal mortality improving over decades).', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Committee Opinion: Screening for Fetal Chromosomal Abnormalities 2020; ACOG Guidelines for Perinatal Care', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 32 ปี ตั้งครรภ์ GA 12 wk G1P0 มาตรวจ ANC ครั้งแรก — counseling on prenatal genetic screening + first trimester care

No family history concerning, no consanguinity
Maternal age 32 (not advanced maternal age which is 35+)
No medical comorbidity'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงตั้งครรภ์ GA 33 wk G3P2 มาห้องฉุกเฉินด้วยอาการน้ำคร่ำแตก 6 ชม ก่อน ไม่มีการเจ็บครรภ์

V/S: BP 122/74, HR 88, RR 16, Temp 37.4°C
Vaginal exam: pooling of fluid in posterior fornix, nitrazine + (alkaline), ferning + on microscopy
Fetal heart 142 reassuring, no contractions
Cervix closed', '[{"label":"A","text":"Induce labor immediately"},{"label":"B","text":"PPROM (Preterm PROM) at 33 weeks"},{"label":"C","text":"Tocolyze long-term"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Cesarean immediately"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** PPROM (Preterm PROM) at 33 weeks: admit; expectant management to 34 wk if uncomplicated (balance prematurity vs infection risk); GBS prophylaxis (penicillin or alternatives); broad-spectrum antibiotic course — ampicillin + erythromycin (or azithromycin) × 7 days reduces chorioamnionitis + delivery latency (NICHD); antenatal corticosteroids (betamethasone × 2 doses) — fetal lung maturity; magnesium sulfate for neuroprotection < 32 wk; serial monitoring — fetal heart rate, uterine contractions, infection markers (WBC, CRP, fever), fluid color; delivery if: chorioamnionitis (fever, fetal tachycardia, uterine tenderness, foul fluid), non-reassuring fetal status, abruption, advanced labor, or reaching 34 wk; counsel; NICU notification

---

PPROM 24-34 wk: expectant management with surveillance, steroids, antibiotics, MgSO4 (neuroprotection < 32 wk). Antibiotic course (ampicillin + erythromycin or azithromycin × 7 days per NICHD/ORACLE) reduces chorioamnionitis + delays delivery. Deliver at 34 wk or if complications. Maternal/fetal surveillance critical. NICU planning.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin: PROM 2020; NICHD Maternal-Fetal Medicine Network', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงตั้งครรภ์ GA 33 wk G3P2 มาห้องฉุกเฉินด้วยอาการน้ำคร่ำแตก 6 ชม ก่อน ไม่มีการเจ็บครรภ์

V/S: BP 122/74, HR 88, RR 16, Temp 37.4°C
Vaginal exam: pooling of fluid in posterior fornix, nitrazine + (alkaline), ferning + on microscopy
Fetal heart 142 reassuring, no contractions
Cervix closed'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 30 ปี G1P0 GA 8 wk มาด้วยอาการอาเจียนไม่หยุด > 10 ครั้ง/วัน × 1 สัปดาห์ ดื่มน้ำไม่ได้ น้ำหนักลด 3 kg

V/S: BP 96/62, HR 112, RR 18, Temp 36.8°C
Gen: dehydrated, ketones +

Lab: Na 134, K 3.0, Cl 92, HCO3 32, Glucose 78, ketonuria 3+, TSH 0.3 (low), Free T4 1.1 (normal)
US: viable IUP single, no molar pregnancy', '[{"label":"A","text":"Discharge with paracetamol"},{"label":"B","text":"Thiamine before glucose"},{"label":"C","text":"Termination of pregnancy"},{"label":"D","text":"Antibiotic"},{"label":"E","text":"High-fat diet"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hyperemesis Gravidarum (HG) — severe N/V + dehydration + ketonuria + weight loss > 5%: admit; IV rehydration NSS or LR + dextrose, correct K + Mg; **Thiamine before glucose** (prevent Wernicke); antiemetics — first-line vitamin B6 (pyridoxine) + doxylamine; second-line metoclopramide, promethazine, ondansetron (caution Q-T prolongation + cleft palate risk 1st trimester — recent reassuring data); steroid (methylprednisolone) refractory cases; PPI for reflux; enteral nutrition (NG, J-tube) or TPN if severe + cannot tolerate PO; monitor electrolytes, ketones, weight; psychological support (devastating illness); rule out molar pregnancy (US done), thyroid storm (suppressed TSH due to β-hCG cross-reactivity = transient gestational thyrotoxicosis usually self-limiting); follow-up close

---

Hyperemesis Gravidarum: severe N/V > 5% weight loss + dehydration + electrolyte derangement + ketonuria. Peak 9 wk. Usually resolves by 20 wk. Stepwise treatment: pyridoxine + doxylamine first, then metoclopramide/promethazine, then ondansetron, then steroid. Thiamine before glucose (Wernicke). IV fluid + electrolyte correction. Severe: enteral or TPN. Transient gestational thyrotoxicosis common (β-hCG cross-reacts with TSH receptor) — usually no treatment. Psychological support critical. Rule out hydatidiform mole.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin: Nausea + Vomiting of Pregnancy 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 30 ปี G1P0 GA 8 wk มาด้วยอาการอาเจียนไม่หยุด > 10 ครั้ง/วัน × 1 สัปดาห์ ดื่มน้ำไม่ได้ น้ำหนักลด 3 kg

V/S: BP 96/62, HR 112, RR 18, Temp 36.8°C
Gen: dehydrated, ketones +

Lab: Na 134, K 3.0, Cl 92, HCO3 32, Glucose 78, ketonuria 3+, TSH 0.3 (low), Free T4 1.1 (normal)
US: viable IUP single, no molar pregnancy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 24 ปี มาห้องฉุกเฉินด้วยอาการปวดท้องน้อย + ไข้ + ตกขาวเหลืองมีกลิ่น × 5 วัน + dyspareunia

LMP 1 สัปดาห์ที่แล้ว ปกติ
Sexually active, 2 partners last year, ไม่ใช้ condom

V/S: BP 118/72, HR 102, RR 18, Temp 38.4°C
Abdomen: lower abdominal tenderness bilaterally, no rebound
Pelvic: cervical motion tenderness +, uterine + bilateral adnexal tenderness, mucopurulent endocervical discharge

Lab: WBC 14,500, CRP 88, β-hCG negative, NAAT for GC/CT pending
US: thickened endometrium + small bilateral hydrosalpinx
No tubo-ovarian abscess', '[{"label":"A","text":"No treatment needed"},{"label":"B","text":"Pelvic Inflammatory Disease (PID"},{"label":"C","text":"Acyclovir"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Antifungal only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pelvic Inflammatory Disease (PID — mild-moderate): empirical antibiotic (CDC 2021 + ACOG): outpatient — ceftriaxone 500mg IM single dose + doxycycline 100mg PO BID × 14 days + metronidazole 500mg PO BID × 14 days (anaerobic coverage); inpatient (more severe, pregnant, TOA, severe N/V, failed outpatient, immunocompromised) — IV cefoxitin or cefotetan + doxycycline OR clindamycin + gentamicin; treat sexual partners (within 60 days — also for GC/CT, doxycycline or treat presumptive); test for HIV + syphilis + hepatitis B + C; consent → STI counseling, contraception, safer sex education; follow-up 72h to confirm improvement; complications: tubo-ovarian abscess (TOA — may need drainage if > 4-5cm or not improving), chronic pelvic pain, infertility, ectopic pregnancy; long-term: counseling about reproductive consequences

---

PID: ascending infection of upper genital tract — N. gonorrhoeae, C. trachomatis, anaerobes. Diagnosis CDC: minimum criteria = uterine, adnexal, or CMT tenderness in sexually active woman. Treatment empirical covering GC/CT + anaerobes. Outpatient acceptable for mild-moderate; inpatient for severe, TOA, pregnancy. Partner treatment. STI + HIV + syphilis screening. Complications: TOA, infertility (12% after 1 episode, 50% after 3), chronic pelvic pain, ectopic pregnancy.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'CDC STI Treatment Guidelines 2021; ACOG Practice Bulletin: Pelvic Inflammatory Disease 2010', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 24 ปี มาห้องฉุกเฉินด้วยอาการปวดท้องน้อย + ไข้ + ตกขาวเหลืองมีกลิ่น × 5 วัน + dyspareunia

LMP 1 สัปดาห์ที่แล้ว ปกติ
Sexually active, 2 partners last year, ไม่ใช้ condom

V/S: BP 118/72, HR 102, RR 18, Temp 38.4°C
Abdomen: lower abdominal tenderness bilaterally, no rebound
Pelvic: cervical motion tenderness +, uterine + bilateral adnexal tenderness, mucopurulent endocervical discharge

Lab: WBC 14,500, CRP 88, β-hCG negative, NAAT for GC/CT pending
US: thickened endometrium + small bilateral hydrosalpinx
No tubo-ovarian abscess'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 28 ปี G1P0 GA 39 wk มา L/R for elective induction of labor for postdates

Labor progression: spontaneous labor begins, contractions every 3 min, cervix 6cm dilated, 100% effaced, fetal head -2 station

Fetal heart monitoring: late decelerations occurring with contractions, baseline 140, variability minimal × 30 min

Maternal V/S: stable
Fetal scalp pH: 7.18 (acidotic)

Category III fetal heart rate tracing per ACOG', '[{"label":"A","text":"Wait for vaginal delivery"},{"label":"B","text":"emergent cesarean delivery"},{"label":"C","text":"Increase oxytocin"},{"label":"D","text":"Discharge for outpatient delivery"},{"label":"E","text":"Stop fetal monitoring"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Non-Reassuring Fetal Status (NRFS) / Category III tracing — immediate intervention required: (1) Intrauterine resuscitation: change maternal position (left lateral preferred — relieves IVC + improves placental flow), O2 supplement, stop oxytocin if running, IV fluid bolus, correct hypotension (if epidural-related), tocolytic (terbutaline) if uterine hyperstimulation; (2) Vaginal exam — assess for cord prolapse, advanced labor; (3) Re-evaluate FHR after measures × 5-10 min; (4) If no improvement or worsening → **emergent cesarean delivery** within 30 min (or operative vaginal — vacuum/forceps if fully dilated + low station + experienced operator); (5) Continuous monitoring; (6) Neonatal team for resuscitation; (7) Document carefully — medico-legal; (8) Post-delivery: cord blood gas (acidosis), NICU assessment if needed, family discussion; (9) Categories: I = normal, II = indeterminate (need attention + workup), III = abnormal (recurrent late decel + minimal variability OR sinusoidal OR bradycardia + minimal variability) — high acidemia/CP risk → urgent delivery

---

Fetal heart rate monitoring categories (ACOG/NICHD): I normal (baseline 110-160 + moderate variability + no late/variable decel), II indeterminate (most tracings — variable abnormalities), III abnormal (recurrent late decel + minimal var OR sinusoidal OR bradycardia + minimal var). Category III = urgent intervention or delivery. Intrauterine resuscitation: position, O2, IV fluid, stop oxytocin, treat hyperstim. If no improvement → emergent C-section within 30 min. NICU. Document carefully.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin: Intrapartum Fetal Heart Rate Monitoring 2009; NICHD 2008 Workshop on EFM', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 28 ปี G1P0 GA 39 wk มา L/R for elective induction of labor for postdates

Labor progression: spontaneous labor begins, contractions every 3 min, cervix 6cm dilated, 100% effaced, fetal head -2 station

Fetal heart monitoring: late decelerations occurring with contractions, baseline 140, variability minimal × 30 min

Maternal V/S: stable
Fetal scalp pH: 7.18 (acidotic)

Category III fetal heart rate tracing per ACOG'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 26 ปี G2P1 ทำ Cesarean delivery 5 วันก่อนเนื่องจาก non-reassuring fetal status มาห้องฉุกเฉินด้วยอาการ ไข้สูง 39.2°C + ปวด wound + ตกขาวเหลืองมีกลิ่น + abdominal tenderness

V/S: BP 102/68, HR 122, RR 22, Temp 39.2°C
Gen: ill
C-section wound: erythematous + warm + discharge purulent at lower edge
Uterus: tender + boggy, foul-smelling lochia
Adnexa: not tender

Lab: WBC 19,500 (left shift), CRP 245, lactate 2.4
Wound + uterine cultures: pending', '[{"label":"A","text":"Discharge with oral antibiotic"},{"label":"B","text":"Postpartum Endometritis + Wound Infection (post-C-section infection"},{"label":"C","text":"Hysterectomy"},{"label":"D","text":"NSAIDs only"},{"label":"E","text":"No treatment needed"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Postpartum Endometritis + Wound Infection (post-C-section infection — common): admit; IV broad-spectrum antibiotic — clindamycin 900mg q8h + gentamicin 7mg/kg q24h (gold standard combination — Cochrane evidence superior coverage of anaerobes + GBS); add ampicillin or vancomycin if no response 48-72h (for enterococcus); wound — open + drain if abscess, debride + irrigate, allow secondary intention healing or delayed primary closure, daily dressing changes; remove staples/sutures over infected area; antibiotic continue until afebrile 24-48h + clinical improvement; thromboprophylaxis (high VTE risk postpartum); monitor for complications — septic pelvic thrombophlebitis (persistent fever despite antibiotic — anticoagulation indicated), abscess, peritonitis; counsel breastfeeding compatible antibiotics; postpartum depression screening; follow-up wound care + complete resolution

---

Postpartum endometritis 1-3% post-vaginal, 5-15% post-C-section. Polymicrobial (anaerobes, GBS, gram-neg, enterococcus). IV clindamycin + gentamicin gold standard. Add ampicillin if no response (enterococcus). Wound infection: drain + debride + secondary healing. Septic pelvic thrombophlebitis if persistent fever despite antibiotics — anticoagulation. Complications: abscess, peritonitis, sepsis. Postpartum visit, follow-up.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin: Use of Prophylactic Antibiotics in Labor and Delivery 2018; Williams Obstetrics', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 26 ปี G2P1 ทำ Cesarean delivery 5 วันก่อนเนื่องจาก non-reassuring fetal status มาห้องฉุกเฉินด้วยอาการ ไข้สูง 39.2°C + ปวด wound + ตกขาวเหลืองมีกลิ่น + abdominal tenderness

V/S: BP 102/68, HR 122, RR 22, Temp 39.2°C
Gen: ill
C-section wound: erythematous + warm + discharge purulent at lower edge
Uterus: tender + boggy, foul-smelling lochia
Adnexa: not tender

Lab: WBC 19,500 (left shift), CRP 245, lactate 2.4
Wound + uterine cultures: pending'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 32 ปี G0P0 trying to conceive × 18 เดือน no success มา OPD

Menstrual: regular cycle 28 days, normal flow, mild dysmenorrhea
History: no PID, no STIs, BMI 23
Husband: 35 yo, healthy, normal semen analysis (concentration 80M, motility 60%, normal morphology 8%)

Exam: normal pelvic, no masses

Lab: TSH 2.4, Prolactin normal, day 3 FSH 6.8, AMH 3.2 (normal), day 21 progesterone 12.8 (suggests ovulation)
HSG (hysterosalpingography): bilateral tubal obstruction at distal ends', '[{"label":"A","text":"Continue trying naturally"},{"label":"B","text":"Treatment for tubal factor"},{"label":"C","text":"Hysterectomy"},{"label":"D","text":"OCP"},{"label":"E","text":"Stop trying"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Infertility (failure to conceive 12 mo unprotected intercourse) — bilateral tubal disease: (1) Diagnostic workup done — male factor normal (normal SA), female ovulatory (regular cycle + d21 P4 > 3), tubal blockage on HSG; (2) **Treatment for tubal factor**: IVF (in vitro fertilization) is treatment of choice — best success rate; alternative — tubal microsurgical repair (less effective in distal blockage with damaged tubes — increases ectopic risk); (3) IVF process: controlled ovarian hyperstimulation (gonadotropin) + monitoring + egg retrieval + fertilization + embryo transfer + luteal support; (4) Preimplantation genetic testing (PGT) optional for selected; (5) Risks/counseling: multiple gestation (encourage single embryo transfer — eSET), OHSS (ovarian hyperstimulation syndrome — severe potential), procedural risks, financial cost, emotional burden; (6) Success rates per age: < 35 yo ~ 40% live birth per cycle; (7) Lifestyle: weight, smoking cessation, alcohol moderation, folate; (8) Psychological support; (9) Alternative: adoption, donor gametes, surrogacy depending on situation; (10) Tubal disease etiology: prior PID, endometriosis, prior tubal surgery, congenital — counseling + STI prevention

---

Infertility = failure to conceive 12 mo (6 mo if > 35 yo) of unprotected intercourse. Female factor 40%, male factor 30-40%, both/unexplained 20-30%. Female: ovulatory (cycle, d21 P4), tubal (HSG), structural (US, sono-HSG). Male: SA. Tubal disease → IVF first-line. Counseling psychological + financial. Lifestyle. eSET to reduce multiple gestation. Modern IVF success: 40% < 35 yo per cycle.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ASRM Practice Committee: Optimal Evaluation of Infertile Female 2015; ESHRE Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 32 ปี G0P0 trying to conceive × 18 เดือน no success มา OPD

Menstrual: regular cycle 28 days, normal flow, mild dysmenorrhea
History: no PID, no STIs, BMI 23
Husband: 35 yo, healthy, normal semen analysis (concentration 80M, motility 60%, normal morphology 8%)

Exam: normal pelvic, no masses

Lab: TSH 2.4, Prolactin normal, day 3 FSH 6.8, AMH 3.2 (normal), day 21 progesterone 12.8 (suggests ovulation)
HSG (hysterosalpingography): bilateral tubal obstruction at distal ends'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 26 ปี ไม่มีโรคประจำตัว มา OPD ด้วยอาการประจำเดือนผิดปกติ (5-6 รอบ/ปี), น้ำหนักเพิ่ม 8 kg ใน 1 ปี, สิวที่หน้า + ผมหลังคอ + acanthosis nigricans, ขนหนาบริเวณคาง + แขน

BMI 32 (obese), BP 132/85
Pelvic: ปกติ
Hair growth Ferriman-Gallwey score 12 (hirsutism)

Lab: TSH normal, Prolactin normal, 17-OHP normal, DHEAS slightly high, Testosterone 70 ng/dL (slightly high), Insulin fasting 22 (elevated), HbA1c 5.9% (prediabetes), Lipid: TG 220, HDL 35
US: bilateral polycystic ovaries + 12+ small follicles each + increased ovarian volume', '[{"label":"A","text":"Discharge — normal variation"},{"label":"B","text":"Polycystic Ovary Syndrome (PCOS) — Rotterdam criteria (2/3): oligo/anovulation + clinical or biochem hyperandrogenism + polycystic ovaries; this patient meets all 3"},{"label":"C","text":"Hysterectomy"},{"label":"D","text":"Antidepressant only"},{"label":"E","text":"Ignore"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Polycystic Ovary Syndrome (PCOS) — Rotterdam criteria (2/3): oligo/anovulation + clinical or biochem hyperandrogenism + polycystic ovaries; this patient meets all 3: (1) **Lifestyle modification** (foundation) — weight loss 5-10% improves cycles, fertility, metabolic — diet (Mediterranean) + exercise 150 min/wk; (2) **Menstrual regulation**: combined OCP (low-dose, antiandrogenic progestin — drospirenone/cyproterone preferred) — first-line for non-fertility seeking; cyclic progestin alternative; (3) **Hyperandrogenism**: OCP for hirsutism + acne (slow effect 3-6 mo); spironolactone + OCP (antiandrogen); mechanical hair removal (laser, electrolysis); topical eflornithine; (4) **Metabolic**: metformin for insulin resistance (improves metabolic + may improve ovulation/cycle); statin if dyslipidemia; (5) **Fertility (when desired)**: weight loss first, letrozole first-line (PPCOS-II trial superior to clomiphene), clomiphene, metformin adjunct, gonadotropin if resistant, ovarian drilling, IVF; (6) **Endometrial protection**: chronic anovulation → endometrial hyperplasia/cancer risk — progestin (cyclic or LNG-IUD), OCP, induce withdrawal bleeding regularly; (7) **Screen for**: T2DM (OGTT annually), HT, dyslipidemia, OSA, depression, eating disorder, NAFLD; (8) **Long-term**: increased CV, T2DM, endometrial cancer risk — annual screening + risk modification; (9) Multidisciplinary: GYN, endocrine, dietitian, dermatology, mental health

---

PCOS: Rotterdam criteria (2/3 — oligo/anovulation, hyperandrogenism, polycystic ovaries). Common (10% reproductive age). Metabolic syndrome features (obesity, insulin resistance, dyslipidemia, T2DM, CV risk). Endometrial cancer risk (chronic anovulation → unopposed estrogen). Management: lifestyle first + symptom-based + metabolic risk modification + endometrial protection. Fertility: letrozole first-line per PPCOS-II. Multidisciplinary care.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'International Evidence-Based Guideline for Assessment + Management of PCOS 2018, updated 2023; ESHRE/ASRM 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 26 ปี ไม่มีโรคประจำตัว มา OPD ด้วยอาการประจำเดือนผิดปกติ (5-6 รอบ/ปี), น้ำหนักเพิ่ม 8 kg ใน 1 ปี, สิวที่หน้า + ผมหลังคอ + acanthosis nigricans, ขนหนาบริเวณคาง + แขน

BMI 32 (obese), BP 132/85
Pelvic: ปกติ
Hair growth Ferriman-Gallwey score 12 (hirsutism)

Lab: TSH normal, Prolactin normal, 17-OHP normal, DHEAS slightly high, Testosterone 70 ng/dL (slightly high), Insulin fasting 22 (elevated), HbA1c 5.9% (prediabetes), Lipid: TG 220, HDL 35
US: bilateral polycystic ovaries + 12+ small follicles each + increased ovarian volume'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 65 ปี postmenopausal × 12 ปี มา OPD ด้วยอาการ chronic abdominal bloating + early satiety + ปวดท้องน้อยเล็กน้อย × 3 เดือน + น้ำหนักลด 4 kg + ปัสสาวะบ่อย

Family: น้องสาวเป็น breast cancer อายุ 48
Genetic: BRCA1 testing positive (familial)

V/S: BP 132/82, BMI 24
Abdomen: distended + ascites (shifting dullness +)
Pelvic: bilateral adnexal mass palpable

Lab: CA-125 685 (very high), CEA normal, HE4 elevated
ROMA index high
US pelvis: bilateral complex ovarian masses + ascites
CT abdomen/pelvis: bilateral ovarian masses (8 + 10 cm) + peritoneal carcinomatosis + omental caking + ascites
No distant metastases on imaging', '[{"label":"A","text":"Observation"},{"label":"B","text":"Treatment options based on resectability"},{"label":"C","text":"Hysterectomy alone"},{"label":"D","text":"Hormone replacement therapy"},{"label":"E","text":"Conservative"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Advanced Ovarian Cancer (Stage III likely) + BRCA1 positive — multidisciplinary GYN-oncology management: (1) Confirm tissue diagnosis — paracentesis cytology, image-guided biopsy of omental disease, or laparoscopy; (2) **Treatment options based on resectability**: - **Primary debulking surgery (PDS)** + adjuvant chemo if optimal cytoreduction (R0/R1, no residual > 1cm) achievable AND fit patient (NCCN preferred); - **Neoadjuvant chemo (NACT) + interval debulking surgery + completion chemo** for not initially resectable, poor performance status, very advanced disease (EORTC + CHORUS trials — non-inferior + less morbidity); (3) **Chemotherapy regimen**: carboplatin + paclitaxel × 6 cycles; consider bevacizumab maintenance; **PARP inhibitor maintenance (olaparib, niraparib, rucaparib)** — major benefit in BRCA1/2 mutated (PFS improvement substantial — SOLO-1, PRIMA trials); (4) **Genetic testing already done** — BRCA1 → counseling for breast cancer surveillance, risk-reducing mastectomy considerations (already have ovarian Ca); family genetic counseling; (5) Surveillance: clinical + CA-125 + imaging q3-6 mo × 2 yr, q6-12 mo × 3 yr; (6) Palliative care concurrent; (7) Outcomes: stage III 5-year survival 30-40%, improved with PARP inhibitor era; (8) Recurrent disease: platinum-sensitive → re-challenge; platinum-resistant → other agents (bevacizumab, doxorubicin liposomal, gemcitabine, topotecan); (9) Lifelong follow-up + survivorship; (10) Multidisciplinary: GYN-oncology, medical oncology, palliative, genetics, social work, nutrition

---

Ovarian cancer: vague symptoms (bloating, early satiety, pelvic pain, urinary) — "silent" but actually symptomatic. Often advanced at presentation. CA-125 + HE4 + ROMA. Imaging + tissue diagnosis. Multidisciplinary GYN-onc management. PDS vs NACT decision. Adjuvant chemo carboplatin + paclitaxel. PARP inhibitor maintenance major advance for BRCA mutation. Genetic testing standard for all ovarian Ca (10-15% BRCA, Lynch). Family screening. Survival improving with modern Rx.', NULL,
  'hard', 'hemato_onco', 'review',
  'ob_gyn', 'clinical_decision', 'hemato_onco', 'adult',
  'NCCN Ovarian Cancer 2024; ASCO Clinical Practice Guidelines; SOLO-1 NEJM 2018; PRIMA NEJM 2019', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 65 ปี postmenopausal × 12 ปี มา OPD ด้วยอาการ chronic abdominal bloating + early satiety + ปวดท้องน้อยเล็กน้อย × 3 เดือน + น้ำหนักลด 4 kg + ปัสสาวะบ่อย

Family: น้องสาวเป็น breast cancer อายุ 48
Genetic: BRCA1 testing positive (familial)

V/S: BP 132/82, BMI 24
Abdomen: distended + ascites (shifting dullness +)
Pelvic: bilateral adnexal mass palpable

Lab: CA-125 685 (very high), CEA normal, HE4 elevated
ROMA index high
US pelvis: bilateral complex ovarian masses + ascites
CT abdomen/pelvis: bilateral ovarian masses (8 + 10 cm) + peritoneal carcinomatosis + omental caking + ascites
No distant metastases on imaging'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 52 ปี perimenopausal × 1 ปี มาด้วยอาการ vasomotor (hot flashes, night sweats) ทำให้นอนไม่หลับ + mood disturbance + vaginal dryness + dyspareunia

LMP 4 เดือนที่แล้ว
BMI 26, BP 132/82
Family: mother breast cancer at 65, father MI at 70

Lab: FSH 65 (high — menopausal), Estradiol 8 (low)
Mammogram: normal, Pap normal
Bone DEXA: T-score -1.8 (osteopenia)
Lipid: TC 245, LDL 158
No personal history breast or VTE or stroke', '[{"label":"A","text":"No treatment — symptoms self-limited"},{"label":"B","text":"Menopausal Symptoms — comprehensive management"},{"label":"C","text":"Total hysterectomy"},{"label":"D","text":"Antidepressants only without other therapy"},{"label":"E","text":"Ignore symptoms"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Menopausal Symptoms — comprehensive management: (1) **Lifestyle**: cool environment, layered clothing, avoid triggers (alcohol, spicy), exercise, weight management, stress reduction, smoking cessation; (2) **MHT (Menopausal Hormone Therapy)** decision — risk-benefit individualized: indication = significant vasomotor symptoms (mod-severe), GSM, early menopause; - Estrogen + progestogen (if intact uterus) — combined; estrogen alone if hysterectomy; - Routes: oral (more VTE risk), transdermal (preferred — less VTE risk per most data), vaginal (for GSM only); - Dose: lowest effective for shortest duration but no arbitrary stop; - Contraindications: estrogen-receptor cancer, active VTE/stroke/CV disease, undiagnosed bleeding; relative — migraine with aura, high VTE risk, gallbladder disease; - Risks: breast Ca (long-term combined modestly increased), VTE (oral more), CV (early menopause may benefit), endometrial Ca (if unopposed estrogen with uterus); - Benefits: symptoms, bone, GSM, possible CV in early menopause; (3) **GSM-specific**: vaginal estrogen (very low systemic absorption), moisturizers, lubricants, ospemifene, prasterone; (4) **Non-hormonal alternatives**: SSRIs/SNRIs (paroxetine, venlafaxine), gabapentin, oxybutynin, cognitive-behavioral therapy, clonidine; (5) **Bone health**: calcium + vitamin D, weight-bearing exercise, bisphosphonate if T-score -2.5 or fragility fracture (DEXA already shows osteopenia, FRAX assessment); (6) **CV risk**: lifestyle, statin per LDL; (7) **Cancer screening**: continued mammogram, Pap, colonoscopy per guidelines; (8) **Shared decision-making + reassessment annually**; (9) Genitourinary syndrome of menopause (GSM) — chronic — local estrogen safe long-term; (10) Mental health support if depression/anxiety

---

Menopause: cessation of menses > 12 mo (avg 51 yo). Vasomotor, GSM, mood, sleep, bone, CV changes. MHT for moderate-severe symptoms — risk-benefit individualized. Transdermal preferred (less VTE). GSM treated with vaginal estrogen (safe). Non-hormonal: SSRI/SNRI, gabapentin, CBT. Bone health: Ca/vit D + DEXA + bisphosphonate threshold. CV risk modification. Cancer screening continues. Shared decision-making + reassessment annually.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'NAMS 2022 Hormone Therapy Position Statement; ACOG Practice Bulletin: Menopause; Endocrine Society Treatment of Symptoms of the Menopause 2015', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 52 ปี perimenopausal × 1 ปี มาด้วยอาการ vasomotor (hot flashes, night sweats) ทำให้นอนไม่หลับ + mood disturbance + vaginal dryness + dyspareunia

LMP 4 เดือนที่แล้ว
BMI 26, BP 132/82
Family: mother breast cancer at 65, father MI at 70

Lab: FSH 65 (high — menopausal), Estradiol 8 (low)
Mammogram: normal, Pap normal
Bone DEXA: T-score -1.8 (osteopenia)
Lipid: TC 245, LDL 158
No personal history breast or VTE or stroke'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 28 ปี G2P1 ตั้งครรภ์ GA 38 wk มาห้องฉุกเฉินด้วยอาการ acute onset chest pain + ตื่นกลัว + เหงื่อแตก + แน่นหน้าอก + รู้สึกหวาดกลัวจะตาย × 6 ชม

Family history: no cardiac history

V/S: BP 154/96, HR 132, RR 28, SpO2 96%, Temp 36.8°C
Gen: anxious, restless, diaphoretic, alert
Lungs: clear, no crackles
Cardiac: tachycardia, no murmurs

EKG: sinus tachycardia 132, no ST changes
Lab: Troponin slightly elevated 0.06, BNP 280, D-dimer high (pregnancy alters), TSH normal
US Fetal: alive, normal growth, no abruption
Obstetric exam: not in labor

CT pulmonary angiogram: positive for pulmonary embolism in segmental branch', '[{"label":"A","text":"Reassure as anxiety attack"},{"label":"B","text":"PE in pregnancy — pregnancy = hypercoagulable state (4-5× VTE risk)"},{"label":"C","text":"Anxiety treatment with benzodiazepine"},{"label":"D","text":"Beta-blocker only"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** PE in pregnancy — pregnancy = hypercoagulable state (4-5× VTE risk): (1) **Anticoagulation immediately** — LMWH (enoxaparin) IV/SC weight-based or therapeutic UFH bolus → infusion; LMWH preferred — does not cross placenta, safer, easier dosing; (2) **Pregnancy-specific considerations**: avoid warfarin (teratogenic 6-12 wk, fetal bleeding); avoid DOACs (cross placenta — insufficient safety data); LMWH continued through pregnancy + 6 weeks postpartum (6 mo total); (3) **Around delivery**: switch to IV heparin 24-36h before planned induction/C-section (shorter half-life, reversible); discontinue heparin 4-6h before neuraxial anesthesia; restart after delivery if hemostasis adequate; (4) **Severity stratification**: hemodynamically stable here — anticoagulation alone; if massive (hemodynamic instability) — consider thrombolysis (life-saving for mother), surgical/catheter embolectomy, ECMO; (5) Continuous monitoring fetal + maternal; (6) **Identify cause**: pregnancy + immobilization + obesity + thrombophilia — screen prior episodes, family history; (7) Counsel: VTE risk in subsequent pregnancies (prophylaxis next pregnancy); avoid OCP; long-term anticoagulation only if unprovoked or persistent risk; (8) Multidisciplinary: MFM, hematology, anesthesia, OB, internal medicine; (9) Postpartum follow-up + reassessment; (10) Anti-Xa monitoring for therapeutic LMWH in selected

---

Pregnancy = 4-5× VTE risk (hypercoagulable, venous stasis, vascular injury). PE leading cause of maternal mortality. Diagnosis: clinical + imaging (V/Q scan or CTPA — both acceptable, CTPA growing standard, lower fetal radiation than thought, breast shielding for mother). Treatment: LMWH first-line (does not cross placenta). Warfarin teratogenic + fetal bleeding. DOACs cross placenta — avoid. Switch to IV heparin around delivery. Multidisciplinary care. Subsequent pregnancy prophylaxis. Counseling.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin: Thromboembolism in Pregnancy 2018; ACCP CHEST Antithrombotic Therapy in VTE 2016', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 28 ปี G2P1 ตั้งครรภ์ GA 38 wk มาห้องฉุกเฉินด้วยอาการ acute onset chest pain + ตื่นกลัว + เหงื่อแตก + แน่นหน้าอก + รู้สึกหวาดกลัวจะตาย × 6 ชม

Family history: no cardiac history

V/S: BP 154/96, HR 132, RR 28, SpO2 96%, Temp 36.8°C
Gen: anxious, restless, diaphoretic, alert
Lungs: clear, no crackles
Cardiac: tachycardia, no murmurs

EKG: sinus tachycardia 132, no ST changes
Lab: Troponin slightly elevated 0.06, BNP 280, D-dimer high (pregnancy alters), TSH normal
US Fetal: alive, normal growth, no abruption
Obstetric exam: not in labor

CT pulmonary angiogram: positive for pulmonary embolism in segmental branch'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'อาจารย์อธิบาย physiology — pregnancy adaptations + key hemodynamic + endocrine changes', '[{"label":"A","text":"No significant changes"},{"label":"B","text":"Pregnancy Physiologic Adaptations"},{"label":"C","text":"BP increases"},{"label":"D","text":"GFR decreases"},{"label":"E","text":"Hypercoagulable state unchanged"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pregnancy Physiologic Adaptations: Cardiovascular — plasma volume ↑ 40-50%, RBC mass ↑ 20-30% (physiologic anemia from dilution), CO ↑ 30-50% (HR + SV both), SVR ↓ → BP nadir mid-pregnancy then rise; Respiratory — minute ventilation ↑ 40% (TV not RR), respiratory alkalosis compensated by renal HCO3 excretion, functional residual capacity ↓; Renal — GFR ↑ 50%, Cr decreases (normal pregnancy < 0.8), glycosuria more common; Hematologic — hypercoagulable (↑ factors I, VII, VIII, IX, X, plasminogen, ↓ protein S), VTE risk; Endocrine — progesterone (smooth muscle relaxation), estrogen, hCG (early luteal support), prolactin (lactation), HPL (insulin antagonism — GDM risk), thyroid (TBG ↑ binding, total T4 ↑ but free T4 normal), cortisol ↑; GI — gastric motility ↓ (reflux), constipation; Musculoskeletal — relaxin (joint laxity, lordosis); Immune — Th2 shift (autoimmune disease may improve)

---

Pregnancy adaptations affect every organ. Key: ↑ plasma volume + CO, ↓ SVR + BP nadir mid-trimester, ↑ GFR, hypercoagulable, respiratory alkalosis, insulin resistance (GDM). Understanding essential for: interpreting normal labs, managing pre-existing conditions in pregnancy, recognizing pathology. Modern obstetric care builds on physiology.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'basic_science', 'obgyn', 'adult',
  'Williams Obstetrics 26th ed Ch. 4 (Maternal Physiology); Sanghavi M Circulation 2014', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'อาจารย์อธิบาย physiology — pregnancy adaptations + key hemodynamic + endocrine changes'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามอาจารย์เรื่อง pharmacology — teratogenic medications + FDA pregnancy category', '[{"label":"A","text":"All drugs safe in pregnancy"},{"label":"B","text":"Teratogenic Medications + Pregnancy Considerations"},{"label":"C","text":"No need for caution"},{"label":"D","text":"All antibiotics safe"},{"label":"E","text":"Stop all medications"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Teratogenic Medications + Pregnancy Considerations: (1) FDA categories replaced by PLLR (Pregnancy and Lactation Labeling Rule) — narrative risk; (2) Known teratogens to avoid: ACEi/ARB (renal dysgenesis, oligohydramnios 2nd-3rd trimester), warfarin (6-12 wk window — chondrodysplasia, microcephaly, fetal bleeding throughout), isotretinoin (multiple), valproic acid (NTD, autism, low IQ), phenytoin (fetal hydantoin syndrome), carbamazepine (NTD), lithium (Ebstein anomaly — relative risk), methotrexate (multiple), thalidomide (limb), DES (clear cell adenocarcinoma in offspring), tetracycline (tooth, bone), aminoglycosides (ototoxicity), fluconazole (multiple), live vaccines (theoretical, avoid), androgens, NSAIDs (avoid 3rd trimester — ductus arteriosus closure, oligohydramnios); (3) Generally safer alternatives: penicillins, cephalosporins (most), acetaminophen, methyldopa (HT), labetalol (HT), nifedipine (HT, tocolysis), insulin (DM), heparin/LMWH (anticoagulation), levothyroxine (hypothyroid); (4) Timing matters — organogenesis 3-8 weeks most vulnerable; (5) Risk-benefit individualized — uncontrolled disease may harm more than medication; (6) Resources: REPROTOX, TERIS, OTIS/MotherToBaby; (7) Folate before + during pregnancy (NTD prevention); (8) Pre-conception counseling for chronic conditions

---

Teratogen awareness critical. Major: ACEi/ARB, warfarin, isotretinoin, valproate, thalidomide, methotrexate. Generally safer: penicillins, acetaminophen, methyldopa, labetalol, insulin, heparin, levothyroxine. Timing of exposure matters. Risk-benefit individualized. Resources: REPROTOX, TERIS, OTIS. Pre-conception counseling + medication review. Folate pre-conception NTD prevention.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'basic_science', 'obgyn', 'adult',
  'FDA Pregnancy and Lactation Labeling Rule (PLLR); REPROTOX; TERIS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Resident ถามอาจารย์เรื่อง pharmacology — teratogenic medications + FDA pregnancy category'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'อาจารย์อธิบาย physiology — labor + delivery + uterine contraction', '[{"label":"A","text":"No physiological coordination"},{"label":"B","text":"Labor Physiology"},{"label":"C","text":"Random uterine activity"},{"label":"D","text":"No hormonal control"},{"label":"E","text":"Same throughout pregnancy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Labor Physiology — coordinated uterine activity: (1) Hormonal: ↑ estrogen + ↓ progesterone (functional withdrawal) → increased gap junction (connexin-43) → coordinated contractions; PGE2/F2α uterotonic + cervical ripening; oxytocin from posterior pituitary + receptors upregulated in myometrium late pregnancy; (2) Three phases of cervical change: cervical ripening (softening, late pregnancy), effacement, dilation; (3) Three phases of labor: latent (slow dilation, 0-6 cm), active (6-10 cm, ~1 cm/hr nulli, 1.5 cm/hr multi), 2nd stage (full dilation to delivery — pushing), 3rd stage (delivery of placenta); modern: latent up to 6 cm (vs old 4 cm — Friedman curve revised, Zhang); (4) Cardinal movements of labor (head): engagement → descent → flexion → internal rotation → extension → external rotation → expulsion; (5) Power, passenger, passage (Three P''s) determine progress; abnormal labor: protraction, arrest of dilation/descent; (6) Pain control: epidural (lumbar L3-4, blocks T10-L1 + S2-4 — ESM block), spinal, combined, opioids, nitrous oxide, non-pharmacologic; (7) Monitoring: intermittent vs continuous FHR (NICE — intermittent for low-risk; continuous if risk factors); (8) Augmentation: amniotomy, oxytocin titration; (9) Cesarean indications: NRFS, labor dystocia, abnormal presentation, placenta previa, etc.

---

Labor = coordinated uterine activity through hormonal + neurogenic + mechanical factors. Modern understanding (Zhang vs Friedman) — latent labor longer than thought, active phase begins ~ 6 cm. Cardinal movements describe fetal navigation through pelvis. Power/passenger/passage analysis identifies dystocia. Pain management options + risks. Continuous vs intermittent monitoring based on risk. Modern labor management = patient-centered + evidence-based.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'basic_science', 'obgyn', 'adult',
  'Williams Obstetrics 26th ed Ch. 21-22; Zhang J et al. Obstet Gynecol 2010 (Modern Labor Curve)', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'อาจารย์อธิบาย physiology — labor + delivery + uterine contraction'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'อาจารย์อธิบาย contraception methods + mechanisms', '[{"label":"A","text":"Only OCP available"},{"label":"B","text":"Contraception — tiered approach by effectiveness (CDC + WHO MEC — Medical Eligibility Criteria)"},{"label":"C","text":"All same effectiveness"},{"label":"D","text":"No medical conditions matter"},{"label":"E","text":"Hormones only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Contraception — tiered approach by effectiveness (CDC + WHO MEC — Medical Eligibility Criteria): (1) **Most effective (< 1% failure)**: LARCs (Long-Acting Reversible Contraception) — implant (etonogestrel — Nexplanon, 3 yr, < 0.1% failure), IUDs (LNG-IUD — Mirena/Liletta/Skyla/Kyleena, 3-8 yr, also treats heavy bleeding; copper IUD — ParaGard, 10 yr, no hormones — useful for emergency contraception); sterilization (vasectomy, tubal ligation/Essure withdrawn); (2) **Very effective (6-9%)**: depot medroxyprogesterone (Depo-Provera 3 mo IM); OCPs (combined estrogen + progestin — many options, also non-contraceptive benefits — cycle regulation, menorrhagia, acne, ovarian/endometrial cancer risk reduction); progestin-only pill (POP — Norethindrone, also breastfeeding); patch (combined); ring (combined NuvaRing/Annovera); (3) **Moderately effective (18%)**: male condom (also STI protection), diaphragm + spermicide; (4) **Less effective (24-28%)**: spermicide, sponge, withdrawal, fertility awareness; (5) **Emergency contraception**: copper IUD (most effective, up to 5 days), ulipristal acetate (5 days), levonorgestrel (3-5 days, less effective); (6) **Mechanisms**: hormonal — suppress LH/FSH (no ovulation), thicken cervical mucus, change endometrium; copper IUD — spermicidal + inflammatory; barrier — physical block; (7) **Choice based on**: patient values, medical history (WHO MEC categories 1-4), STI risk, fertility plans, side effect tolerance

---

Contraception counseling = patient-centered + evidence-based. Tier 1 = LARC (most effective, increasingly first-line). WHO MEC categorizes eligibility per medical conditions. Estrogen contraindications: VTE history, migraine with aura, stroke, MI, BC < 5 yr, advanced liver, smoking > 35 yo. POP/LARC alternatives. Emergency contraception (copper IUD most effective, ulipristal, LNG). Modern approach: LARC first; respect patient preferences.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'basic_science', 'obgyn', 'adult',
  'CDC US Medical Eligibility Criteria for Contraceptive Use 2016; WHO MEC 5th edition', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'อาจารย์อธิบาย contraception methods + mechanisms'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital wants to reduce maternal mortality + improve obstetric outcomes — implement Maternal Early Warning Systems', '[{"label":"A","text":"Single intervention"},{"label":"B","text":"Maternal Quality Improvement Program"},{"label":"C","text":"Single specialty manages"},{"label":"D","text":"No data collection"},{"label":"E","text":"Avoid drills"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Maternal Quality Improvement Program: (1) Maternal Early Warning Systems (MEWS) — track vital signs trigger response (BP > 160/110, RR > 30, HR > 130, SpO2 < 95%, oliguria, AMS) → rapid response team activation; (2) Standardized bundles (AIM — Alliance for Innovation on Maternal Health): hypertension bundle, hemorrhage bundle, VTE bundle, sepsis bundle, maternal mental health, peripartum racial/ethnic disparities, severe maternal morbidity review; (3) Hemorrhage bundle: risk assessment, recognition + response, hemorrhage cart, MTP, drills; (4) Hypertensive bundle: severe range BP management protocols, MgSO4 use, transfer criteria; (5) Multidisciplinary simulations + drills (shoulder dystocia, hemorrhage, eclampsia, cardiac arrest); (6) Severe maternal morbidity (SMM) review committees + root cause analysis; (7) Levels of maternal care designation (similar to trauma — Level I-IV); (8) Continuous improvement + audit; (9) Address social determinants + disparities (Black women 3-4× maternal mortality in US); (10) Family/support involvement; (11) Mental health screening + treatment; (12) Quality metrics: maternal mortality ratio, SMM rate, blood transfusion rate, NICU admission, c-section rate, breastfeeding initiation, postpartum visit attendance

---

Maternal mortality reduction = system-level multidisciplinary effort. MEWS for early recognition. Bundles standardize evidence-based care. Drills + simulations improve readiness. SMM review identifies improvement opportunities. Levels of maternal care match risk to capability. AIM + ACOG + national initiatives. Address disparities. Maternal mortality preventable in majority of cases — system improvement saves lives.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'ems_mgmt', 'obgyn', 'adult',
  'Alliance for Innovation on Maternal Health (AIM); ACOG Obstetric Care Consensus on Levels of Maternal Care 2019', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Hospital wants to reduce maternal mortality + improve obstetric outcomes — implement Maternal Early Warning Systems'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital implements ERAS protocol for elective C-section — Enhanced Recovery After Cesarean (ERAC)', '[{"label":"A","text":"Traditional restrictive recovery"},{"label":"B","text":"Enhanced Recovery After Cesarean (ERAC)"},{"label":"C","text":"Bed rest 5 days"},{"label":"D","text":"Opioid-only analgesia"},{"label":"E","text":"Restrict fluid intake"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Enhanced Recovery After Cesarean (ERAC) — multimodal evidence-based: (1) Pre-op: counseling, no prolonged fasting (clear fluids until 2h, carb loading 2h pre-op), antibiotic prophylaxis 60 min pre-op (cefazolin + azithromycin), VTE prophylaxis (mechanical + LMWH start 6-12h post-op), normothermia, chlorhexidine skin prep; (2) Intra-op: neuraxial anesthesia preferred (spinal/CSE), multimodal analgesia (intrathecal morphine + IV acetaminophen + NSAID), minimize opioid use, restrictive IV fluid, blunt expansion of uterine incision (less blood loss), uterotonic at delivery (oxytocin); (3) Post-op: early oral diet (within 1h), early ambulation (within 6h), Foley removal 12h, opioid-sparing analgesia (acetaminophen + NSAID + TAP block + low-dose opioid PRN), thromboprophylaxis continued, breastfeeding support, mental health screening; (4) Discharge planning early; (5) Outcomes: reduced LOS (1-2 days), opioid use ↓ 50%, complications ↓, breastfeeding rates ↑, patient satisfaction ↑; (6) SOGC + ERAS Society + Cooper Medical Center publications; (7) Implementation requires multidisciplinary team + audit + continuous improvement

---

ERAC = ERAS principles applied to cesarean. Evidence: shorter LOS, less opioid use, better breastfeeding, less morbidity, higher satisfaction. Multimodal pain management (intrathecal morphine + NSAID + acetaminophen + TAP block + minimal opioid) — opioid-sparing reduces side effects + neonatal exposure (in breastfeeding). Early diet + ambulation + Foley removal. Counseling + family-centered care. Quality improvement driven.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'ems_mgmt', 'obgyn', 'adult',
  'ERAS Society Guidelines for Cesarean Delivery 2018-2019; Wilson RD et al. Am J Obstet Gynecol 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Hospital implements ERAS protocol for elective C-section — Enhanced Recovery After Cesarean (ERAC)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Pediatric/Obstetric collaboration — reducing perinatal mortality + improving newborn outcomes', '[{"label":"A","text":"Pediatric + obstetric work separately"},{"label":"B","text":"Perinatal Care Integration"},{"label":"C","text":"Single specialty handles all"},{"label":"D","text":"Avoid newborn screening"},{"label":"E","text":"Discharge immediately"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Perinatal Care Integration — multidisciplinary obstetric + neonatal collaboration: (1) Pre-pregnancy: optimization (chronic disease, vaccinations, mental health, nutrition); (2) Antenatal: shared risk assessment, antenatal corticosteroid for preterm, MgSO4 for neuroprotection, GBS prophylaxis, level of care matching; (3) Intrapartum: skilled birth attendant, intermittent vs continuous monitoring, neonatal team alert for high-risk; (4) Delayed cord clamping 30-60 sec (improves iron stores, NEC, IVH); (5) Immediate skin-to-skin + early breastfeeding initiation; (6) Neonatal resuscitation if needed (NRP); (7) Newborn screening: pulse oximetry (CHD), hearing, blood spot (PKU, hypothyroid, CF, sickle cell, etc.), bilirubin; (8) NICU criteria + family involvement; (9) Postpartum: maternal screening (preeclampsia, depression, thyroid, infection, VTE, hemorrhage), breastfeeding support, contraception counseling; (10) Quality metrics: perinatal mortality rate, neonatal mortality, NICU admission, breastfeeding rates, preterm rate, c-section rate, severe morbidity; (11) Multidisciplinary team: obstetricians, midwives, neonatologists, anesthesia, lactation, social work, mental health, family medicine; (12) Continuity of care + transition

---

Perinatal care = integrative obstetric + neonatal + pediatric. Whole pregnancy journey + postpartum. Multidisciplinary team. Quality metrics. Outcomes improve with integrated care. Thai perinatal/neonatal mortality improving with system development. Family-centered. Continuous quality improvement.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'ems_mgmt', 'obgyn', 'adult',
  'WHO Standards for Improving Quality of Maternal and Newborn Care; ACOG/AAP Guidelines for Perinatal Care', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Pediatric/Obstetric collaboration — reducing perinatal mortality + improving newborn outcomes'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 35 ปี G2P1 GA 28 wk underlying SLE on hydroxychloroquine + low-dose prednisolone + APS (antiphospholipid syndrome) — history of recurrent miscarriage + DVT 2 ปีที่แล้ว

ADD ลูกคนที่แล้ว: IUGR + preeclampsia + small for gestational age

คำถาม: high-risk pregnancy multidisciplinary management', '[{"label":"A","text":"Standard prenatal care"},{"label":"B","text":"SLE + APS Pregnancy — Multidisciplinary Integrative High-Risk Care"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Stop all medications"},{"label":"E","text":"Termination"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** SLE + APS Pregnancy — Multidisciplinary Integrative High-Risk Care: (1) **Pre-conception**: disease optimization (low/no activity 6 mo before conception), medication review (continue HCQ — prevents flares + congenital heart block; avoid teratogenic — MMF, MTX, cyclophosphamide; corticosteroid OK; AZA OK; tacrolimus OK), folate, vaccination updates; (2) **Antenatal**: combined obstetric + rheumatology + maternal-fetal medicine clinic; (3) APS treatment: **low-dose aspirin** (start pre-conception or early pregnancy) + **prophylactic LMWH** (start positive pregnancy test) — reduces miscarriage, preeclampsia, IUGR risk; therapeutic LMWH if prior thrombosis history; (4) Monitor for SLE flare; (5) Lupus nephritis surveillance — proteinuria, Cr, complements; (6) Anti-Ro/SSA + Anti-La/SSB — congenital heart block + neonatal lupus risk — fetal echo monitoring weekly 16-26 wk; (7) Preeclampsia prevention — aspirin 81-150mg (high-risk indication), Ca, BP monitoring; (8) IUGR surveillance — serial growth US, umbilical Doppler; (9) Mental health support; (10) Delivery planning + timing (often induced/scheduled 37-39 wk based on activity + complications); (11) Postpartum: continue medications, flare risk highest, contraception (avoid estrogen in APS — VTE risk, OK with HCQ on activity controlled lupus), breastfeeding — most meds compatible; (12) Long-term follow-up with rheumatology

---

SLE + APS pregnancy = high-risk integrative care. Pre-conception optimization + medication review (HCQ continue, avoid teratogens). Combined MFM + rheumatology. APS — aspirin + LMWH. Monitor flares + complications (preeclampsia, IUGR, flare). Anti-Ro+/La+ — fetal heart block monitoring. Multidisciplinary. Outcomes excellent with optimized care vs poor without. Modern integrated care improves outcomes.', NULL,
  'hard', 'rheumatology', 'review',
  'ob_gyn', 'integrative', 'rheumatology', 'adult',
  'EULAR Recommendations: Pregnancy + Lupus + APS 2017; ACOG Practice Bulletin Antiphospholipid Syndrome', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 35 ปี G2P1 GA 28 wk underlying SLE on hydroxychloroquine + low-dose prednisolone + APS (antiphospholipid syndrome) — history of recurrent miscarriage + DVT 2 ปีที่แล้ว

ADD ลูกคนที่แล้ว: IUGR + preeclampsia + small for gestational age

คำถาม: high-risk pregnancy multidisciplinary management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 28 ปี G1P0 GA 36 wk underlying severe depression + anxiety on sertraline 100 mg + receiving CBT therapy + family stress

คำถาม: perinatal mental health integrative management', '[{"label":"A","text":"Stop all medications + therapy"},{"label":"B","text":"Perinatal Mental Health"},{"label":"C","text":"Refuse all psychiatric care"},{"label":"D","text":"Pregnancy termination"},{"label":"E","text":"Single specialist"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Perinatal Mental Health — Integrative Care: (1) Pre-conception: counseling, medication review (most SSRIs OK — sertraline preferred; avoid paroxetine for new starts though not absolutely; counsel benefit-risk); (2) Continue treatment during pregnancy if beneficial — untreated depression has its own risks (preterm, LBW, postpartum depression, suicide, impaired bonding); (3) Multidisciplinary: OB + perinatal psychiatry + therapist + social work + primary care + lactation; (4) Monitor depression scores (EPDS, PHQ-9) throughout; (5) Address psychosocial stressors (intimate partner violence screening, financial, support); (6) **Postpartum**: highest risk period — postpartum blues (50-80%, < 2 wk, no Rx), postpartum depression (15-20%, treatment), postpartum psychosis (rare 0.1%, emergency); (7) Breastfeeding considerations — sertraline + paroxetine preferred (low milk transfer); (8) Support network — family, friends, support groups (mom support groups, online communities); (9) Screening tools: EPDS at every visit including postpartum, PHQ-9 alternatives; (10) Suicide risk assessment — leading cause maternal mortality some series (Ko JY MMWR 2017); (11) Pediatric outcomes follow-up — child development, attachment, behavior issues higher with untreated maternal depression; (12) ACOG + APA + AAP guidance — treatment generally outweighs medication risk in moderate-severe depression; (13) Trauma-informed care; (14) Continued care planning + transitions; (15) Family + partner involvement

---

Perinatal mental health = integrative multidisciplinary care. Untreated depression = significant risk (preterm, LBW, postpartum depression, suicide). SSRIs generally OK (sertraline preferred). Continue beneficial treatment. Postpartum highest risk period. Suicide leading maternal mortality cause in some series. Screen routinely (EPDS, PHQ-9). Multidisciplinary care + family support + breastfeeding considerations. Modern integrated care.', NULL,
  'medium', 'psych_behavior', 'review',
  'ob_gyn', 'integrative', 'psych_behavior', 'adult',
  'ACOG Committee Opinion: Screening for Perinatal Depression 2018; American Psychiatric Association Perinatal MH', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 28 ปี G1P0 GA 36 wk underlying severe depression + anxiety on sertraline 100 mg + receiving CBT therapy + family stress

คำถาม: perinatal mental health integrative management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 65 ปี recently diagnosed advanced ovarian cancer (Stage IIIC) on chemotherapy — counsel + integrative care across cancer survivorship', '[{"label":"A","text":"Chemotherapy alone"},{"label":"B","text":"Gynecologic Cancer Survivorship Integrative Care"},{"label":"C","text":"Stop all treatment"},{"label":"D","text":"Avoid follow-up"},{"label":"E","text":"Hospice only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Gynecologic Cancer Survivorship Integrative Care: (1) Active treatment: oncology team coordinated care, side effect management (nausea/vomiting, neuropathy, fatigue, alopecia, infection prevention, growth factors), nutritional support, exercise programs (improves outcomes), psychological + spiritual support; (2) Long-term survivorship (modern: many survive significantly with better Rx): - surveillance (clinical, CA-125, imaging) for recurrence; - PARP inhibitor maintenance if BRCA+; - secondary cancer screening; - cardiovascular monitoring (cardiotoxicity from some chemo); - bone health (DEXA, calcium, vitamin D); - sexual health (vaginal estrogen for GSM safe in non-hormone responsive cancers, lubricants, sexual therapy); - reproductive (premature ovarian failure if young — hormone considerations); - emotional/psychological (PTSD, anxiety, depression — high prevalence); - financial toxicity counseling; - return to work/role; (3) Survivorship care plan — written summary + plan provided; (4) Multidisciplinary: oncology, primary care, social work, psychology, nutrition, physical therapy, sexual health; (5) Family/caregiver support + bereavement preparation; (6) Palliative care integration (early palliative + curative treatment — Temel; recurrent disease — symptom + QOL focus); (7) End-of-life if appropriate — advance care planning, hospice; (8) Patient advocacy + support groups; (9) Genetic counseling — family screening for inherited cancer; (10) Equity in care + cultural competence

---

Cancer survivorship integrative care = multidisciplinary + lifelong. Modern ovarian cancer outcomes improving (PARP inhibitors). Survivorship care plan (IOM 2006). Multiple domains: surveillance, late effects, sexual health, mental health, return to function, financial, family. Integrated palliative care from diagnosis (Temel — improves QOL + survival). Family + caregiver support. Genetic counseling — implications for family. Continuous quality of life focus.', NULL,
  'hard', 'hemato_onco', 'review',
  'ob_gyn', 'integrative', 'hemato_onco', 'adult',
  'ASCO Cancer Survivorship Care Planning; IOM From Cancer Patient to Cancer Survivor 2006; NCCN Survivorship Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 65 ปี recently diagnosed advanced ovarian cancer (Stage IIIC) on chemotherapy — counsel + integrative care across cancer survivorship'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงตั้งครรภ์ G1P0 GA 11 wk มา ANC ครั้งแรก ไม่มีโรคประจำตัว

V/S: BP 118/72, HR 84, RR 18, Temp 36.8
Fetal: FHR 162 (Doppler)
Lab pending: CBC, blood group, VDRL, HBsAg, Anti-HIV, rubella IgG, urinalysis', '[{"label":"A","text":"ส่ง dating US + first-trimester combined screening (PAPP-A + free β-hCG + NT) 11-13+6 wk เท่านั้น ไม่ต้องตรวจ lab อื่น"},{"label":"B","text":"First ANC visit"},{"label":"C","text":"ตรวจเฉพาะ ultrasound + folic acid + กลับมาใหม่ 28 wk"},{"label":"D","text":"ส่ง amniocentesis เพื่อ karyotype ทุกรายโดยไม่ดู risk"},{"label":"E","text":"เริ่ม insulin prophylaxis ทุกราย"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** First ANC visit: confirm pregnancy + dating US (CRL ที่ 11-13+6 wk เป็น gold standard); routine labs CBC, blood group/Rh, indirect Coombs, VDRL, anti-HIV, HBsAg, rubella IgG, urinalysis, urine culture; thalassemia screening (MCV, MCH, DCIP, Hb typing) — Thai high prevalence; first-trimester aneuploidy screening (combined test NT + PAPP-A + free β-hCG ที่ 11-13+6 wk) optional หรือ NIPT; folic acid 400-800 mcg/d, iodine 150 mcg, iron supplement; lifestyle counseling, avoid alcohol/smoking, food safety, vaccination (flu, Tdap 27-36 wk); calculate EDD by LMP vs CRL (LMP unreliable ถ้า CRL discrepancy > 7 d ใน first trimester ให้ใช้ US); risk assessment (chronic HT, DM, preeclampsia risk → aspirin 81-150 mg/d ตั้งแต่ 12-16 wk ถ้า high risk)

---

First ANC visit (ideal < 12 wk): dating, baseline risks, screening labs, vaccination, supplementation. Dating ด้วย CRL ใน first trimester accuracy ±5-7 วัน. Thai context: thalassemia screening + Hb E + DCIP. Aspirin 81-150 mg เริ่ม 12-16 wk ในกลุ่ม high risk preeclampsia (USPSTF 2021, ACOG).', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Committee Opinion 700: Methods for EDD; RTCOG ANC guideline 2021; USPSTF Aspirin Preeclampsia 2021', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงตั้งครรภ์ G1P0 GA 11 wk มา ANC ครั้งแรก ไม่มีโรคประจำตัว

V/S: BP 118/72, HR 84, RR 18, Temp 36.8
Fetal: FHR 162 (Doppler)
Lab pending: CBC, blood group, VDRL, HBsAg, Anti-HIV, rubella IgG, urinalysis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงตั้งครรภ์ G2P1 GA 28 wk underlying chronic HT มา ANC routine — no symptoms

V/S: BP 148/94 (clinic + home consistent), HR 88, RR 18
Fetal: FHR 144, fundal height appropriate, EFW 1,150 g (15th percentile)
Lab: Cr 0.8, AST/ALT WNL, Plt 240K, urine protein/Cr 0.18 (negative), uric acid 4.6', '[{"label":"A","text":"Discontinue all medications, observe only"},{"label":"B","text":"nifedipine ER"},{"label":"C","text":"Begin IV magnesium prophylaxis ทันที"},{"label":"D","text":"Cesarean immediately"},{"label":"E","text":"Atenolol + ACEI combination"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Chronic HT in pregnancy (BP ≥ 140/90 ก่อน 20 wk หรือก่อนตั้งครรภ์): target BP 110-135/85 (CHAP trial 2022 — tight control reduces preeclampsia + preterm + SGA โดยไม่เพิ่ม fetal harm); first-line agents safe: **labetalol** 100-400 mg BID-TID, **nifedipine ER** 30-90 mg/d, **methyldopa** 250-500 mg TID; AVOID ACEI/ARB (renal dysgenesis), atenolol (IUGR); aspirin 81-150 mg ตั้งแต่ 12 wk (preeclampsia prevention); serial growth US q 3-4 wk (IUGR risk); BP self-monitor + urine protein dipstick; surveillance for superimposed preeclampsia (sudden BP rise, new proteinuria, end-organ dysfunction); antenatal testing (NST/BPP) จาก 32-34 wk; delivery 38-39+6 wk ถ้า well-controlled, earlier ถ้า complications

---

Chronic HT พบ 1-5% ของการตั้งครรภ์. CHAP trial (NEJM 2022) — target < 140/90 เทียบกับ 160/110 ลด adverse outcomes โดยไม่เพิ่ม SGA. Drugs of choice: labetalol, nifedipine, methyldopa. ACEI/ARB contraindicated. Aspirin prevention + serial growth + monitor superimposed preeclampsia.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'CHAP Trial NEJM 2022; ACOG Practice Bulletin 203: Chronic HT in Pregnancy', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงตั้งครรภ์ G2P1 GA 28 wk underlying chronic HT มา ANC routine — no symptoms

V/S: BP 148/94 (clinic + home consistent), HR 88, RR 18
Fetal: FHR 144, fundal height appropriate, EFW 1,150 g (15th percentile)
Lab: Cr 0.8, AST/ALT WNL, Plt 240K, urine protein/Cr 0.18 (negative), uric acid 4.6'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงตั้งครรภ์ GA 34 wk G1P0 มาด้วย vaginal bleeding 200 mL bright red, ไม่มีปวดท้อง, ไม่มี contraction

V/S: BP 110/68, HR 96, RR 18
Fetal: FHR 148 reassuring, no contractions on toco
US: placenta covering internal os completely (complete placenta previa), AFI normal, EFW 2,100 g', '[{"label":"A","text":"Perform digital cervical exam immediately"},{"label":"B","text":"NO digital/speculum vaginal exam"},{"label":"C","text":"Vaginal delivery induction with oxytocin"},{"label":"D","text":"Discharge home with rest"},{"label":"E","text":"Misoprostol for cervical ripening"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Complete placenta previa with antepartum hemorrhage: **NO digital/speculum vaginal exam** until previa excluded (provoke hemorrhage); admit, IV access × 2 large-bore, type & cross 2-4 units, CBC + coag + Kleihauer-Betke (if Rh-); continuous fetal monitoring; Rh-immunoglobulin if Rh-negative; corticosteroid betamethasone 12 mg IM × 2 (GA < 34 wk) — ที่ 34 wk ยังพิจารณาได้ใน late preterm (ALPS trial); magnesium neuroprotection ถ้า < 32 wk; **tocolytics cautious** (nifedipine) ถ้า preterm + stable; cesarean delivery planned 36-37+6 wk สำหรับ complete previa (uncomplicated); emergency C/S ถ้า hemorrhage uncontrolled, fetal distress, labor; pelvic rest, no intercourse, counsel for re-bleed; consider transfer tertiary center with NICU + blood bank

---

Placenta previa: placenta over/near cervical os. Painless bright red bleeding 3rd trimester = classic. DO NOT perform digital exam (provokes bleed). US confirms position. Plan C/S 36-37+6 wk uncomplicated; emergency ถ้าเลือดออกมาก. Steroid + Rh-Ig + transfer. Placenta accreta spectrum risk (prior C/S).', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin 234: Placenta Accreta Spectrum; SMFM Consult Series 44: Previa', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงตั้งครรภ์ GA 34 wk G1P0 มาด้วย vaginal bleeding 200 mL bright red, ไม่มีปวดท้อง, ไม่มี contraction

V/S: BP 110/68, HR 96, RR 18
Fetal: FHR 148 reassuring, no contractions on toco
US: placenta covering internal os completely (complete placenta previa), AFI normal, EFW 2,100 g'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงตั้งครรภ์ GA 36 wk G3P2 prior 2 NSD มาด้วย sudden severe abdominal pain + dark vaginal bleeding 150 mL, hypertonic uterus

V/S: BP 158/96 (chronic HT history), HR 118, RR 24
Fetal: FHR baseline 100 with late decelerations
Abdomen: tense, board-like, fundal height > expected, tender
US: retroplacental hematoma 8×4 cm', '[{"label":"A","text":"Expectant management — observe 24 hr"},{"label":"B","text":"emergency cesarean delivery"},{"label":"C","text":"Tocolytic to prolong pregnancy"},{"label":"D","text":"Discharge with pelvic rest"},{"label":"E","text":"Vacuum extraction"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Placental Abruption (premature separation of placenta — pain + dark bleeding + hypertonic uterus + fetal distress; risk factors: HT, trauma, cocaine, smoking, PPROM, multifetal, prior abruption): activate massive transfusion protocol; IV access × 2; type & cross 4 U PRBC + FFP + plt + cryo (DIC risk); CBC, coag, fibrinogen (< 200 ominous), Kleihauer-Betke; **emergency cesarean delivery** สำหรับ non-reassuring fetal status / maternal instability / abruption with viable fetus + fetal compromise; vaginal delivery ถ้า dead fetus + maternal stable (faster sometimes); manage hemorrhagic shock; DIC monitoring + correction; postpartum: anticipate PPH (Couvelaire uterus), uterotonics + balloon ± hysterectomy; Anti-D ถ้า Rh-negative; debrief + recurrence counseling (10-25% recurrence)

---

Abruptio placentae: separation of normally implanted placenta before delivery. Pain + dark bleeding + hypertonic/tender uterus + fetal distress = classic. Concealed hemorrhage = bleeding underestimated. Couvelaire uterus + DIC + AKI + fetal demise. HT/preeclampsia is leading risk. Emergency C/S ถ้า fetal viable + distress.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG: Antepartum Hemorrhage; Williams Obstetrics 26e Ch 41', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงตั้งครรภ์ GA 36 wk G3P2 prior 2 NSD มาด้วย sudden severe abdominal pain + dark vaginal bleeding 150 mL, hypertonic uterus

V/S: BP 158/96 (chronic HT history), HR 118, RR 24
Fetal: FHR baseline 100 with late decelerations
Abdomen: tense, board-like, fundal height > expected, tender
US: retroplacental hematoma 8×4 cm'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 36 ปี G2P1 GA 32 wk twin pregnancy DCDA มา ANC — fundal height ตามอายุครรภ์, US: twin A 1,650 g (50th), twin B 1,180 g (5th percentile), EFW discordance 28%, twin B umbilical artery pulsatility index > 95th percentile, AFI twin A normal, twin B oligohydramnios

V/S: BP 124/78, HR 88
Fetal: NST twin A reactive, twin B reactive with variable decelerations', '[{"label":"A","text":"Continue routine ANC, repeat US 4 wk"},{"label":"B","text":"Selective IUGR in DCDA twin pregnancy (EFW < 10th percentile + discordance > 20-25% + abnormal Doppler)"},{"label":"C","text":"Immediate delivery at 32 wk regardless of Doppler"},{"label":"D","text":"Terminate pregnancy"},{"label":"E","text":"Discharge home, follow up 4 wk"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Selective IUGR in DCDA twin pregnancy (EFW < 10th percentile + discordance > 20-25% + abnormal Doppler): admit / close surveillance; serial US biweekly EFW + Doppler (umbilical artery, MCA, ductus venosus); NST/BPP twice weekly; corticosteroid betamethasone 12 mg IM × 2 (GA 32 wk = preterm); magnesium neuroprotection ถ้า delivery imminent < 32 wk; **delivery timing** balance prematurity vs stillbirth — for DCDA selective IUGR consider delivery 34-36 wk หรือ earlier ถ้า ductus venosus a-wave reversal/absent, BPP abnormal, oligohydramnios severe; mode cesarean preferred ถ้า twin A non-vertex; continuous monitoring during labor; NICU available; postnatal: SGA care, hypoglycemia screen

---

Twin pregnancies + selective IUGR (DCDA): one twin SGA, abnormal Doppler. Types I-III by umbilical artery Doppler pattern. DCDA = lower risk than MCDA (no shared circulation). Surveillance + steroids + plan delivery 34-36 wk uncomplicated, earlier ถ้า abnormal DV/BPP. MCDA monochorionic more complex (TTTS, sIUGR types).', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ISUOG Practice Guidelines Twin Pregnancy 2016; SMFM Consult Series 53', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 36 ปี G2P1 GA 32 wk twin pregnancy DCDA มา ANC — fundal height ตามอายุครรภ์, US: twin A 1,650 g (50th), twin B 1,180 g (5th percentile), EFW discordance 28%, twin B umbilical artery pulsatility index > 95th percentile, AFI twin A normal, twin B oligohydramnios

V/S: BP 124/78, HR 88
Fetal: NST twin A reactive, twin B reactive with variable decelerations'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 30 ปี G2P1 GA 41+3 wk — postdates pregnancy, ไม่มี contraction, ANC ปกติทั้งหมด, fetal movement count ปกติ

V/S: BP 122/76, HR 84
Fetal: FHR 148, NST reactive, AFI 6 (oligohydramnios — < 5 oligo; 5-8 borderline)
Cervix exam: Bishop score 4 (closed, posterior, 1 cm long, soft, station -2)
US: EFW 3,400 g, vertex', '[{"label":"A","text":"Continue waiting until 43 wk"},{"label":"B","text":"induction of labor at 41+0 wk"},{"label":"C","text":"Cesarean immediately"},{"label":"D","text":"Discharge with weekly follow-up"},{"label":"E","text":"Wait for spontaneous labor 43 wk"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Postdates pregnancy (≥ 42+0 wk) approaching — ACOG/ARRIVE supports **induction of labor at 41+0 wk** to reduce stillbirth + meconium + macrosomia; current GA 41+3 + borderline AFI = induce; unfavorable cervix Bishop ≤ 6 → **cervical ripening** first: mechanical (Foley/Cook catheter, intracervical balloon) or pharmacological (PGE2 dinoprostone vaginal insert, or misoprostol PO/PV 25 mcg q 3-6 hr) → reassess Bishop → oxytocin augmentation ถ้า membranes ruptured / Bishop favorable; continuous EFM; AROM ถ้า progress; surveillance for meconium, fetal distress, shoulder dystocia (macrosomia risk); plan vaginal delivery uncomplicated; cesarean ถ้า failure of induction / fetal distress / arrest disorder; antenatal surveillance (NST/BPP twice weekly) จาก 41 wk ถ้า expectant (now obsolete with ARRIVE)

---

Postterm (≥ 42+0). Induce at 41+0 wk reduces stillbirth (ARRIVE trial — 39 wk elective IOL in low-risk nullip not harmful). Bishop score predicts IOL success. Cervical ripening (mechanical/PG) ถ้า unfavorable. Risks postterm: stillbirth, macrosomia, meconium, oligohydramnios, placental insufficiency.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin 146: Late-Term + Postterm; ARRIVE Trial NEJM 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 30 ปี G2P1 GA 41+3 wk — postdates pregnancy, ไม่มี contraction, ANC ปกติทั้งหมด, fetal movement count ปกติ

V/S: BP 122/76, HR 84
Fetal: FHR 148, NST reactive, AFI 6 (oligohydramnios — < 5 oligo; 5-8 borderline)
Cervix exam: Bishop score 4 (closed, posterior, 1 cm long, soft, station -2)
US: EFW 3,400 g, vertex'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 24 ปี G1P0 GA 30 wk มา L&R for routine US — fetal biometry: HC 50th, AC 3rd percentile, FL 25th, EFW 950 g (< 3rd percentile)

V/S: BP 138/86, HR 90
Fetal: FHR 144 reactive, MCA PI 5th percentile, umbilical artery PI > 95th, ductus venosus normal a-wave, AFI 4 (oligohydramnios)
Lab: uric acid 6.2, plt 165K, AST/ALT WNL, urine protein/Cr 0.5', '[{"label":"A","text":"Repeat US in 4 weeks"},{"label":"B","text":"delivery timing per TRUFFLE/GRIT"},{"label":"C","text":"Discharge with weekly ANC"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Increase maternal caloric intake — observe only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe early-onset FGR (< 3rd percentile + abnormal Doppler + oligohydramnios + maternal HT — likely placental insufficiency, possibly evolving preeclampsia): admit tertiary center; serial Doppler 2-3×/wk (umbilical, MCA, DV); NST/BPP daily; antihypertensive (labetalol/nifedipine) ถ้า BP ≥ 140/90; antenatal corticosteroid betamethasone 12 mg IM × 2 (GA 30 wk = preterm benefit); magnesium sulfate neuroprotection (GA < 32 wk); workup preeclampsia + sFlt-1/PlGF ratio ถ้า available; **delivery timing per TRUFFLE/GRIT**: at 30 wk, deliver ถ้า DV a-wave absent/reversed, repetitive late/variable decels, BPP ≤ 4, oligohydramnios severe + cessation of growth; otherwise continue with surveillance to 32-34 wk; cesarean preferred (fetal compromise + unfavorable cervix); NICU ready; counsel parents prematurity outcomes

---

Fetal Growth Restriction (FGR): EFW or AC < 10th percentile (ISUOG/Delphi consensus). Severe < 3rd or < 10th + abnormal Doppler. Cause = placental insufficiency (most), genetic, infection (TORCH). Doppler progression: umbilical PI → AEDV → REDV; MCA brain-sparing; DV a-wave abnormal = imminent. TRUFFLE — ductus venosus monitoring delivery timing in early FGR.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG/SMFM FGR 2020; ISUOG Practice Guidelines 2020; TRUFFLE Lancet 2015', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 24 ปี G1P0 GA 30 wk มา L&R for routine US — fetal biometry: HC 50th, AC 3rd percentile, FL 25th, EFW 950 g (< 3rd percentile)

V/S: BP 138/86, HR 90
Fetal: FHR 144 reactive, MCA PI 5th percentile, umbilical artery PI > 95th, ductus venosus normal a-wave, AFI 4 (oligohydramnios)
Lab: uric acid 6.2, plt 165K, AST/ALT WNL, urine protein/Cr 0.5'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 28 ปี G1P0 GA 39 wk in labor, dilation 6 cm. Contraction q 3 นาที × 60 วินาที strong. CTG: baseline 145, variability moderate, accelerations present, repetitive late decelerations เริ่มมา 30 นาที

V/S: BP 122/76, HR 92, Temp 37.0
Fetal: scalp pH not done, EFW 3,200 g, vertex station 0', '[{"label":"A","text":"Continue waiting and increase oxytocin"},{"label":"B","text":"Category II tracing with late decels (repetitive, persistent)"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Maternal pain control only"},{"label":"E","text":"Antibiotics only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Category II tracing with late decels (repetitive, persistent)** → intrauterine resuscitation: (1) reposition mother left lateral; (2) stop oxytocin; (3) IV fluid bolus 500-1000 mL; (4) O2 10 L NRB (controversial — limit); (5) check BP, treat hypotension (ephedrine/phenylephrine ถ้า epidural-induced); (6) vaginal exam — rule out cord prolapse, assess progress; (7) consider terbutaline 0.25 mg SC for tachysystole; (8) if no improvement 20-30 min OR Category III tracing (absent variability + recurrent late/variable/bradycardia, or sinusoidal) → **expedite delivery** — operative vaginal (vacuum/forceps) ถ้า fully dilated + station ≥ +2 OR emergency cesarean; intrauterine resuscitation continued during transfer; pediatric team standby; cord blood gas at delivery; document NICHD category timely

---

NICHD 3-tier system: Cat I normal, Cat II indeterminate (most), Cat III abnormal (act). Late decel = uteroplacental insufficiency (hypoxia). Variable = cord compression. Intrauterine resus: position, fluid, stop oxytocin, O2 (limit). Operative delivery vs C/S per progress + station.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin 106 + 116: Fetal Heart Rate Monitoring; NICHD 2008', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 28 ปี G1P0 GA 39 wk in labor, dilation 6 cm. Contraction q 3 นาที × 60 วินาที strong. CTG: baseline 145, variability moderate, accelerations present, repetitive late decelerations เริ่มมา 30 นาที

V/S: BP 122/76, HR 92, Temp 37.0
Fetal: scalp pH not done, EFW 3,200 g, vertex station 0'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 33 ปี G3P2 GA 39+4 wk in labor, dilation 9 cm, contraction strong q 2 นาที. Suddenly บีบอวัยวะเพศพบ umbilical cord prolapse, FHR drops to 70

V/S: BP 118/72, HR 110
Fetal: FHR baseline 70 (severe bradycardia)
Cervix: 9 cm, vertex station -2', '[{"label":"A","text":"Wait for spontaneous reduction"},{"label":"B","text":"call for help, activate code emergency cesarean"},{"label":"C","text":"Vaginal delivery with augmentation"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Conservative observation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Umbilical Cord Prolapse (obstetric emergency — cord through cervix, compressed by presenting part): **call for help, activate code emergency cesarean**; (1) examiner''s hand in vagina — **elevate presenting part off cord** continuously (do not remove until delivery!); (2) maternal position — knee-chest หรือ steep Trendelenburg or left lateral; (3) bladder filling with 500-700 mL NSS via Foley → elevates head (can replace hand temporarily); (4) tocolytic terbutaline 0.25 mg SC to reduce contractions; (5) O2, IV fluid; (6) prepare for stat C/S — decision-to-delivery < 30 min ideally, ASAP; (7) cord exposed: keep moist with warm saline, avoid handling (vasospasm); (8) if fully dilated + station low + skilled operator → operative vaginal delivery (vacuum/forceps) faster; (9) document timeline + outcomes; counsel postpartum

---

Cord prolapse = obstetric emergency, fetal mortality high without immediate action. Risk: malpresentation, polyhydramnios, prematurity, multifetal, ARM with high station, long cord. Manage: relieve compression (elevate head, bladder fill, position), tocolytic, immediate C/S unless vaginal delivery imminent.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'RCOG Green-top 50: Umbilical Cord Prolapse 2014', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 33 ปี G3P2 GA 39+4 wk in labor, dilation 9 cm, contraction strong q 2 นาที. Suddenly บีบอวัยวะเพศพบ umbilical cord prolapse, FHR drops to 70

V/S: BP 118/72, HR 110
Fetal: FHR baseline 70 (severe bradycardia)
Cervix: 9 cm, vertex station -2'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 36 ปี G2P1 GA 40 wk in labor, head delivered แต่ shoulder ติด — shoulder dystocia recognized (turtle sign)

V/S: BP 130/80, HR 100
Fetal: head delivered 1 นาทีที่แล้ว, ไม่สามารถ deliver shoulder ได้ ด้วย gentle downward traction
EFW estimated 4,300 g, maternal DM2 history', '[{"label":"A","text":"Pull hard on the head + cut episiotomy deeply"},{"label":"B","text":"HELPERR mnemonic"},{"label":"C","text":"Cesarean delivery after head delivery"},{"label":"D","text":"Forceps to abdomen"},{"label":"E","text":"Continue observation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Shoulder Dystocia (failure of shoulder delivery + gentle traction failed) — **HELPERR mnemonic** in 60 sec increments: **H** — call for Help (additional OB, anesthesia, pediatrics, time-keeper); **E** — **Evaluate for Episiotomy** (does NOT relieve bony obstruction — only if needed for room for maneuvers); **L** — Legs (**McRoberts maneuver** — hyperflex thighs onto abdomen) — most effective single maneuver, success > 40%; **P** — **suprapubic Pressure** (NOT fundal — fundal worsens impaction) — Rubin I; **E** — Enter (internal rotational maneuvers: Rubin II, Wood''s screw, reverse Wood''s screw) — rotate posterior shoulder to oblique; **R** — **Remove** posterior arm (sweep across chest); **R** — Roll (Gaskin maneuver — all-fours position); last resort: Zavanelli (cephalic replacement + C/S), symphysiotomy, clavicular fracture; **AVOID excessive traction + fundal pressure** (brachial plexus injury — Erb''s palsy); document timing + maneuvers; postpartum: PPH, 4° laceration, neonatal Erb''s palsy, fracture

---

Shoulder dystocia = obstetric emergency. Anterior shoulder impacted on symphysis. Risk: macrosomia, DM, prior dystocia, postdates, prolonged 2nd stage, operative vaginal. HELPERR ordered maneuvers. McRoberts + suprapubic pressure resolve 50-60%. Complication: Erb''s palsy, clavicle fracture, asphyxia, PPH, perineal trauma.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin 178: Shoulder Dystocia 2017; ALSO course', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 36 ปี G2P1 GA 40 wk in labor, head delivered แต่ shoulder ติด — shoulder dystocia recognized (turtle sign)

V/S: BP 130/80, HR 100
Fetal: head delivered 1 นาทีที่แล้ว, ไม่สามารถ deliver shoulder ได้ ด้วย gentle downward traction
EFW estimated 4,300 g, maternal DM2 history'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 27 ปี G2P1 GA 28 wk PPROM 8 ชม ago — clear fluid leakage, no chorioamnionitis signs

V/S: BP 120/74, HR 92, Temp 37.1
Fetal: FHR 152 reactive, no contractions on toco
US: AFI 4 (oligohydramnios), EFW 1,150 g (50th), no abruption
Lab: WBC 11,000 (no left shift), CRP 8', '[{"label":"A","text":"Immediate cesarean delivery"},{"label":"B","text":"PPROM at 28 wk (preterm, no infection) — expectant management: admit, bed rest;"},{"label":"C","text":"Discharge home with oral antibiotics"},{"label":"D","text":"Immediate IOL with oxytocin"},{"label":"E","text":"Methotrexate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** PPROM at 28 wk (preterm, no infection) — **expectant management**: admit, bed rest; (1) **antibiotic prophylaxis** — ampicillin 2 g IV q 6 hr + erythromycin 250 mg IV q 6 hr × 48 hr then amoxicillin 250 mg PO + erythromycin 333 mg PO × 5 d (MRC ORACLE) — prolongs latency, reduces chorioamnionitis + neonatal morbidity; (2) **antenatal corticosteroid** betamethasone 12 mg IM × 2 doses 24 hr apart — fetal lung maturity; (3) **magnesium sulfate neuroprotection** (GA < 32 wk) — 4-6 g loading then 1 g/hr; (4) **GBS prophylaxis** ใน labor; (5) NO tocolytics routinely (controversial — short-term ok for steroid completion); (6) surveillance — temp q 4 hr, CBC q 24-48 hr, fetal monitoring daily NST, US weekly (AFI, growth); (7) deliver ถ้า chorioamnionitis (fever, tachy, fundal pain, foul fluid), abruption, fetal compromise, labor; (8) deliver at 34+0 wk per ACOG (expectant vs delivery balance); counsel parents prematurity + cerebral palsy + lung disease

---

PPROM (< 37 wk) — leading cause of preterm birth. Diagnosis: pooling, nitrazine, ferning, AmniSure/ROM Plus. Risks: chorioamnionitis, abruption, cord prolapse, pulmonary hypoplasia (< 24 wk), prematurity. Antibiotic (latency), steroid, MgSO4 < 32 wk, deliver 34+0 wk uncomplicated or earlier ถ้า infection/distress.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin 217: Prelabor Rupture of Membranes 2020; MRC ORACLE Lancet 2001', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 27 ปี G2P1 GA 28 wk PPROM 8 ชม ago — clear fluid leakage, no chorioamnionitis signs

V/S: BP 120/74, HR 92, Temp 37.1
Fetal: FHR 152 reactive, no contractions on toco
US: AFI 4 (oligohydramnios), EFW 1,150 g (50th), no abruption
Lab: WBC 11,000 (no left shift), CRP 8'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 30 ปี G3P2 GA 38 wk attempted VBAC after 1 prior low transverse cesarean. In active labor 6 cm, suddenly ปวดท้องเฉียบพลัน + loss of fetal station + abnormal CTG

V/S: BP 92/56, HR 128, RR 26
Fetal: FHR 70 bradycardia, loss of contractions on toco
Abdomen: tender + suprapubic palpable fetal parts', '[{"label":"A","text":"Continue augmentation"},{"label":"B","text":"STAT emergency cesarean delivery"},{"label":"C","text":"Increase oxytocin"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Observation 30 min"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Uterine Rupture (rare but catastrophic — sudden pain, loss of station, fetal distress/bradycardia, hemodynamic instability, fetal parts palpable in abdomen) — **STAT emergency cesarean delivery** (decision-to-incision < 10-15 min for fetal survival); concurrent: activate MTP, IV access × 2 large bore, type & cross 4-6 U PRBC + FFP + plt; aggressive fluid resuscitation; surgical management — laparotomy, deliver fetus + placenta, repair uterine rupture (primary repair ถ้า possible — single layer หรือ double layer; hysterectomy ถ้า extensive injury, hemorrhage uncontrolled, vascular damage, future fertility not desired); inspect bladder + ureter (often involved at lower segment); broad-spectrum antibiotics; postpartum: ICU, hemodynamic monitoring, blood products, DIC management; counsel future pregnancies — recurrent rupture risk ~10-30%, **no future VBAC**, elective cesarean 36-37 wk; document + risk management

---

Uterine rupture: TOLAC risk 0.5-1% (low transverse 1 prior); classic vertical 4-9%. Signs: pain, FHR abnormality (most common — bradycardia), loss of station, vaginal bleeding, hemodynamic instability, fetal parts palpable. Time-critical = emergency C/S < 30 min ideal. Repair vs hysterectomy. Counsel future planned delivery 36-37 wk no labor.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin 205: VBAC; SMFM Statement Uterine Rupture', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 30 ปี G3P2 GA 38 wk attempted VBAC after 1 prior low transverse cesarean. In active labor 6 cm, suddenly ปวดท้องเฉียบพลัน + loss of fetal station + abnormal CTG

V/S: BP 92/56, HR 128, RR 26
Fetal: FHR 70 bradycardia, loss of contractions on toco
Abdomen: tender + suprapubic palpable fetal parts'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 26 ปี G2P1 GA 38 wk normal labor, NSD เด็ก 3,200g 30 นาที — placenta ไม่หลุดออก, traction gentle ไม่หลุด, no excessive bleeding

V/S: BP 118/74, HR 86
Fundus: still high, soft', '[{"label":"A","text":"Discharge home, return tomorrow"},{"label":"B","text":"Retained placenta (> 30 min after delivery 3rd stage)"},{"label":"C","text":"Hysterectomy immediately"},{"label":"D","text":"Continue waiting 4 hr"},{"label":"E","text":"Misoprostol PR alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Retained placenta (> 30 min after delivery 3rd stage)** management: (1) IV access + uterotonics — oxytocin infusion (active management); ensure bladder empty (Foley); (2) **controlled cord traction with counter-pressure** (Brandt-Andrews); (3) consider umbilical vein injection oxytocin 20 U in 20 mL NSS (limited evidence); (4) if fails → **manual removal of placenta** under analgesia/anesthesia (regional preferred, or GA, or IV opioid + sedation) — sterile technique, hand in uterus, develop cleavage plane, remove + inspect for completeness; (5) prophylactic antibiotic single dose ampicillin or cefazolin; (6) post-removal: oxytocin infusion, monitor for PPH (atony, retained fragments); (7) examine placenta for completeness — if incomplete → uterine curettage; (8) suspect **placenta accreta spectrum** ถ้า unable to develop plane, profuse bleeding → consider hysterectomy/conservative management + IR embolization; (9) Anti-D ถ้า Rh-negative; counsel + iron

---

Retained placenta = > 30 min 3rd stage (active mgmt); risk PPH, infection. Management: uterotonics, bladder empty, cord traction, manual removal under anesthesia, antibiotic prophylaxis. Suspect accreta ถ้า no cleavage plane. Hysterectomy last resort.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'WHO PPH Guidelines; RCOG Green-top 52: PPH', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 26 ปี G2P1 GA 38 wk normal labor, NSD เด็ก 3,200g 30 นาที — placenta ไม่หลุดออก, traction gentle ไม่หลุด, no excessive bleeding

V/S: BP 118/74, HR 86
Fundus: still high, soft'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 38 ปี G4P3 GA 35 wk prior 2 cesarean + 1 NSD, placenta previa anterior covering os + lacunae + loss of clear zone + bladder wall interrupted on US

V/S: BP 124/76, HR 88
Fetal: FHR 144 reactive, EFW 2,400 g', '[{"label":"A","text":"Attempt vaginal delivery"},{"label":"B","text":"Placenta Accreta Spectrum (PAS — accreta/increta/percreta)"},{"label":"C","text":"Manual removal of placenta vaginally"},{"label":"D","text":"Wait until 40 wk"},{"label":"E","text":"Methotrexate to dissolve placenta"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Suspected **Placenta Accreta Spectrum (PAS — accreta/increta/percreta)** in setting of prior multiple C/S + previa: refer **tertiary center with multidisciplinary team** (MFM, GYN-oncology, urology, IR, anesthesia, NICU, blood bank); MRI to confirm + map extent (bladder involvement = percreta); blood products available (6-10 U PRBC + FFP + plt); IR consultation — preoperative ureteral stents + balloon catheters (internal iliac); plan **scheduled cesarean hysterectomy at 34-35+6 wk** before labor/bleeding (anterior previa + multiple C/S = high suspicion); antenatal corticosteroid; skin incision midline vertical, hysterotomy classical (avoid placenta), deliver fetus, **leave placenta in situ + immediate hysterectomy** (do not attempt to remove placenta — massive hemorrhage); urology for bladder repair if percreta; postoperative ICU; counsel future fertility loss; psychological support

---

Placenta accreta spectrum: abnormal trophoblast invasion. Risk: prior C/S + previa (compounding — each prior C/S ↑ risk). US signs: lacunae, loss of clear zone, bladder line interruption, increased vascularity. Plan delivery 34-35+6 wk multidisciplinary tertiary center. Cesarean hysterectomy + leave placenta in situ standard. Massive PPH risk.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'FIGO Consensus PAS 2018; ACOG/SMFM Obstet Care Consensus 7 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 38 ปี G4P3 GA 35 wk prior 2 cesarean + 1 NSD, placenta previa anterior covering os + lacunae + loss of clear zone + bladder wall interrupted on US

V/S: BP 124/76, HR 88
Fetal: FHR 144 reactive, EFW 2,400 g'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงตั้งครรภ์ G2P1 GA 40+5 wk in labor, prolonged 2nd stage 3 hr with epidural, fetal station +2, OP position, maternal exhaustion, FHR cat II with variable decels

V/S: BP 118/72, HR 102, mother exhausted
Fetal: FHR 150 variable decels recovering, station +2, OP position
Cervix: fully dilated, no caput excessive, EFW 3,500 g', '[{"label":"A","text":"Immediate cesarean"},{"label":"B","text":"NICHD ABCDEFGHIJ"},{"label":"C","text":"Continue pushing 2 more hr"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Vaginal misoprostol"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Operative Vaginal Delivery (vacuum or forceps) — criteria met: fully dilated, ruptured membranes, known position, station ≥ +2 (low or outlet), adequate analgesia, empty bladder, experienced operator, NICU available, willing consent; **vacuum extraction** — silastic/Kiwi cup, place over flexion point (3 cm anterior to posterior fontanelle); pull with contraction + maternal effort; max 3 pulls, 3 pop-offs, 15-20 min total; **forceps** — better for OP/asynclitic (manual rotation Kielland); contraindications: < 34 wk (vacuum), bleeding disorder, face/breech presentation, cephalopelvic disproportion suspected; **NICHD ABCDEFGHIJ** safety checklist (Address consent, BP, contractions, dilation, equipment, fetal position, gentleness, halt if no progress, incision/episiotomy, jaw — for shoulder dystocia preparation); post-delivery: assess for lacerations + episiotomy, infant scalp/cephalohematoma/subgaleal monitoring, NICU eval; failure → cesarean (do not attempt other instrument)

---

Operative vaginal delivery: vacuum or forceps in 2nd stage. Prolonged 2nd stage: nullip > 3 hr (epidural) or 2 hr; multip > 2 hr (epidural) or 1 hr. Indications: prolonged 2nd stage, fetal distress, maternal exhaustion/cardiac. Vacuum risks: cephalohematoma, subgaleal hemorrhage, retinal hemorrhage. Forceps: facial nerve palsy, lacerations.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin 219: Operative Vaginal Birth', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงตั้งครรภ์ G2P1 GA 40+5 wk in labor, prolonged 2nd stage 3 hr with epidural, fetal station +2, OP position, maternal exhaustion, FHR cat II with variable decels

V/S: BP 118/72, HR 102, mother exhausted
Fetal: FHR 150 variable decels recovering, station +2, OP position
Cervix: fully dilated, no caput excessive, EFW 3,500 g'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 32 ปี G3P2 GA 26 wk มาด้วยอาการ severe headache + epigastric pain + RUQ pain + ตามัว 2 ชม

V/S: BP 178/118, HR 102, RR 22
Gen: hyperreflexia 4+, clonus +
Fetal: FHR 140, no contractions
Lab: plt 65K, AST 320, ALT 280, LDH 720, Cr 1.5, urine protein 4+, hemoglobin 9.8, schistocytes +', '[{"label":"A","text":"Observation 24 hr"},{"label":"B","text":"Severe Preeclampsia with HELLP — imminent eclampsia (premonitory symptoms)"},{"label":"C","text":"Discharge home with antihypertensive"},{"label":"D","text":"Continue pregnancy without delivery"},{"label":"E","text":"Aspirin alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe Preeclampsia with HELLP — imminent eclampsia (premonitory symptoms): (1) **magnesium sulfate** 4-6 g IV loading over 15-20 min then 1-2 g/hr infusion × 24 hr postpartum — seizure prophylaxis (Pritchard or Zuspan); monitor reflexes + RR + urine output + Mg level (therapeutic 4.8-8.4 mg/dL); antidote calcium gluconate 1 g IV ถ้า toxicity; (2) **antihypertensive** — IV labetalol 20-40-80 mg q 10 min (max 220 mg) or hydralazine 5-10 mg q 20 min or oral nifedipine 10-20 mg q 30 min — target BP 140-150/90-100 (avoid over-correction — placental); (3) **antenatal corticosteroid** betamethasone 12 mg IM × 2 (GA 26 wk extreme preterm); (4) **stabilize then deliver** — at 26 wk consider expectant 24-48 hr for steroid completion ถ้า maternal/fetal stable, but HELLP + severe features → delivery (mode per obstetric); (5) ICU + multidisciplinary; (6) postpartum: continue Mg 24 hr, monitor BP + organ function, HELLP may worsen 48 hr postpartum; (7) eclamptic seizure protocol: ABC, left lateral, Mg, control airway

---

Severe preeclampsia features: BP ≥ 160/110, plt < 100K, LFT 2× ULN, Cr > 1.1, pulmonary edema, cerebral/visual symptoms, RUQ pain. HELLP = hemolysis (LDH, schistocytes) + elevated LFT + low plt. MgSO4 = seizure prophylaxis (gold standard, Magpie trial). Delivery is definitive. At extreme preterm (24-26 wk) brief stabilization 48 hr for steroid ถ้า possible — but HELLP often progresses → expedite.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin 222 + Hypertensive Disorders Task Force; MAGPIE Trial Lancet 2002', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 32 ปี G3P2 GA 26 wk มาด้วยอาการ severe headache + epigastric pain + RUQ pain + ตามัว 2 ชม

V/S: BP 178/118, HR 102, RR 22
Gen: hyperreflexia 4+, clonus +
Fetal: FHR 140, no contractions
Lab: plt 65K, AST 320, ALT 280, LDH 720, Cr 1.5, urine protein 4+, hemoglobin 9.8, schistocytes +'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 38 ปี G2P1 GA 32 wk gestational HT ตอน 30 wk — มาตอนนี้ BP 168/112 + new proteinuria 2+ + plt 105K + AST 95 + Cr 1.0 + ปวดศีรษะ

V/S: BP 168/112, HR 96
Fetal: FHR 144, EFW 1,650 g (30th), AFI 8, NST reactive', '[{"label":"A","text":"Continue outpatient management"},{"label":"B","text":"expectant management may be considered briefly 24-48 hr for steroid completion"},{"label":"C","text":"Wait until 40 wk"},{"label":"D","text":"Cesarean immediately at 32 wk"},{"label":"E","text":"Discharge with aspirin only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Late Preterm Severe Preeclampsia at 32 wk (severe BP + thrombocytopenia + transaminitis = severe features) — admit, **expectant management may be considered briefly 24-48 hr for steroid completion** ถ้า fetal/maternal stable: (1) betamethasone 12 mg IM × 2 doses 24 hr apart (most benefit); (2) magnesium sulfate for seizure prophylaxis + neuroprotection; (3) antihypertensive — labetalol/nifedipine/hydralazine, target 140-150/90-100; (4) close maternal monitoring (vitals q 4 hr, labs q 12-24 hr — Hb, plt, LFT, Cr, LDH); (5) continuous fetal monitoring, daily NST + BPP; (6) **deliver at 34+0 wk OR earlier if** — uncontrollable BP, eclampsia, abruption, DIC, pulmonary edema, AKI, HELLP progression, non-reassuring fetal status, abnormal Doppler severe, IUFD; (7) mode of delivery per obstetric indication (vaginal preferred ถ้า favorable cervix); (8) postpartum: Mg 24 hr, BP monitoring, may need antihypertensive 6-12 wk; (9) future pregnancy counseling: recurrence + aspirin prophylaxis

---

Late preterm severe preeclampsia (34+0 wk) — deliver after steroid stabilization. Earlier (< 34) brief expectant for steroid + transfer ถ้า stable, deliver any GA ถ้า severe complications. Severity criteria: BP ≥ 160/110, plt < 100, LFT 2× ULN, Cr > 1.1, pulm edema, cerebral/visual.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Hypertension in Pregnancy 2020; HYPITAT-II Lancet 2015', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 38 ปี G2P1 GA 32 wk gestational HT ตอน 30 wk — มาตอนนี้ BP 168/112 + new proteinuria 2+ + plt 105K + AST 95 + Cr 1.0 + ปวดศีรษะ

V/S: BP 168/112, HR 96
Fetal: FHR 144, EFW 1,650 g (30th), AFI 8, NST reactive'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 24 ปี G1P0 GA 14 wk มา ANC ตรวจ thalassemia screening MCV 65, Hb typing: AE Bart''s. Husband MCV 68, Hb typing: AE Bart''s

V/S: BP 110/70, HR 80
Fetal: heart present 158 BPM', '[{"label":"A","text":"ไม่ต้องตรวจเพิ่ม — เด็กจะปกติ"},{"label":"B","text":"Hb Bart''s hydrops fetalis (homozygous α-thalassemia-1, --/-- )"},{"label":"C","text":"Cesarean immediately"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Refer to oncology"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Both parents are α-thalassemia-1 carriers (Hb Bart''s = γ4, suggests --SEA deletion / α0-thalassemia; coexisting Hb E from β-globin) — at-risk couple for **Hb Bart''s hydrops fetalis (homozygous α-thalassemia-1, --/-- )** in 25% offspring (lethal — fetal hydrops, severe anemia, IUFD, maternal preeclampsia-like syndrome ''mirror syndrome''); workup: (1) confirm parental genotypes — **PCR for α-globin gene deletions** (SEA, Thai, FIL); (2) genetic counseling — explain 25% risk hydrops, 50% carrier, 25% normal; (3) offer **prenatal diagnosis** — chorionic villus sampling (CVS) at 11-13 wk or **amniocentesis** at 16-18 wk for fetal α-globin genotype (PCR); (4) options if affected fetus: termination of pregnancy (legal in Thailand for severe genetic disease per Medical Council), continue pregnancy with comfort care; (5) maternal risk if continued affected pregnancy: severe preeclampsia, hemorrhage, polyhydramnios; (6) folic acid supplementation; (7) iron only ถ้า iron deficiency confirmed (avoid iron overload in thal); (8) future pregnancy: preimplantation genetic testing (PGT-M)

---

Thailand thalassemia high prevalence — α-thal-1 carrier 4-14% in some regions. Hb Bart''s hydrops fetalis = homozygous α0/α0 (--/--), lethal. Couple both α-thal-1 carriers = 25% affected. Screen MCV, MCH, OF/DCIP test, Hb typing; confirm PCR for deletions. Prenatal diagnosis via CVS/amnio + PCR. Genetic counseling + reproductive options.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'RTCOG Thalassemia in Pregnancy 2016; Thai Ministry of Public Health Prevention + Control of Thalassemia', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 24 ปี G1P0 GA 14 wk มา ANC ตรวจ thalassemia screening MCV 65, Hb typing: AE Bart''s. Husband MCV 68, Hb typing: AE Bart''s

V/S: BP 110/70, HR 80
Fetal: heart present 158 BPM'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 28 ปี G2P1 GA 28 wk type 1 DM since age 15, current HbA1c 7.2%, on insulin basal-bolus. Pre-pregnancy A1c 6.8%

V/S: BP 122/74, HR 88
Fetal: FHR 148, EFW 1,400 g (75th percentile — slight LGA), AFI 22 (mild polyhydramnios), no congenital anomalies on detailed US', '[{"label":"A","text":"Stop insulin"},{"label":"B","text":"Pregestational T1DM in pregnancy — comprehensive management"},{"label":"C","text":"Switch to oral metformin only"},{"label":"D","text":"Cesarean immediately at 28 wk"},{"label":"E","text":"Stop all surveillance"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pregestational T1DM in pregnancy — comprehensive management: (1) **glycemic targets** — fasting 70-95, 1h PP < 140, 2h PP < 120, A1c < 6.5% (if achievable safely); basal-bolus insulin — adjust doses (requirements ↑ 2-3× by 3rd trimester); CGM preferred (CONCEPTT trial — improved outcomes); (2) **ANC visits** every 1-2 wk; (3) **fetal surveillance** — detailed anomaly scan 18-22 wk (cardiac, neural tube — 3-4× risk), fetal echo 22-26 wk, serial growth US q 4 wk (macrosomia + polyhydramnios + IUGR with vasculopathy); (4) NST + BPP twice weekly from 32 wk; (5) **maternal complications** — DKA, hypoglycemia, retinopathy progression (dilated eye exam each trimester), nephropathy (urine ACR), preeclampsia (aspirin 81-150 mg from 12 wk), infection; (6) **delivery timing** — 39+0 wk uncomplicated well-controlled; 36-39 wk if vascular complications/poor control/macrosomia; (7) intrapartum — insulin drip to maintain BG 70-110; consider C/S if EFW > 4,500 g; (8) postpartum — insulin requirement ↓ dramatically; continue breastfeeding (↓ requirements); neonatal — hypoglycemia/RDS/polycythemia/hypocalcemia

---

Pregestational DM higher risks than GDM. Preconception A1c < 6.5% ideal — reduce congenital anomalies (cardiac, NTD, caudal regression). Aspirin preeclampsia prevention. Polyhydramnios = hyperglycemia → fetal polyuria. Macrosomia + shoulder dystocia. Insulin requirements rise (placental hormones). Postpartum drop dramatic.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin 201: Pregestational DM 2018; ADA Standards of Care 2024', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 28 ปี G2P1 GA 28 wk type 1 DM since age 15, current HbA1c 7.2%, on insulin basal-bolus. Pre-pregnancy A1c 6.8%

V/S: BP 122/74, HR 88
Fetal: FHR 148, EFW 1,400 g (75th percentile — slight LGA), AFI 22 (mild polyhydramnios), no congenital anomalies on detailed US'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 26 ปี G1P0 GA 28 wk previously healthy มา OPD ตรวจ ANC routine — Rh-negative (mother), Rh-positive (father). Indirect Coombs negative ใน first trimester

V/S: BP 118/72, HR 84
Fetal: FHR 152, growth appropriate', '[{"label":"A","text":"Do nothing — wait until delivery"},{"label":"B","text":"antenatal anti-D immunoglobulin (RhoGAM) 300 mcg IM at 28 wk"},{"label":"C","text":"Cesarean delivery"},{"label":"D","text":"Stop pregnancy"},{"label":"E","text":"Methotrexate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Rh isoimmunization prophylaxis (mother Rh-negative + father Rh-positive or unknown + Coombs negative): **antenatal anti-D immunoglobulin (RhoGAM) 300 mcg IM at 28 wk** — prevents sensitization from silent fetomaternal hemorrhage in 3rd trimester (~1.5% sensitization risk without prophylaxis); repeat **postpartum 300 mcg IM within 72 hr ถ้า baby Rh-positive**; **Kleihauer-Betke test** ถ้า significant fetomaternal hemorrhage suspected (abruption, trauma, fetal-maternal hemorrhage > 30 mL → larger dose: 300 mcg per 30 mL fetal blood); additional 50-300 mcg doses for sensitizing events: spontaneous/induced abortion, ectopic pregnancy, CVS/amniocentesis, external cephalic version, trauma, antepartum bleeding; if **already sensitized** (Coombs positive) — anti-D Ig does NOT help; manage with serial antibody titers, MCA Doppler (peak systolic velocity > 1.5 MoM = severe fetal anemia), intrauterine transfusion (IUT) PUBS; non-invasive fetal RhD genotyping (cell-free DNA) — limit prophylaxis ถ้า fetus Rh-negative (Europe practice)

---

Anti-D prophylaxis: 28 wk routine + postpartum + sensitizing events. Sensitization → next pregnancy hemolytic disease (hydrops fetalis). Monitor sensitized: titers, MCA-PSV > 1.5 MoM, IUT. Non-invasive cffDNA fetal RhD typing increasingly used.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin 192: Management of Alloimmunization 2018; RCOG Green-top 22', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 26 ปี G1P0 GA 28 wk previously healthy มา OPD ตรวจ ANC routine — Rh-negative (mother), Rh-positive (father). Indirect Coombs negative ใน first trimester

V/S: BP 118/72, HR 84
Fetal: FHR 152, growth appropriate'
  );

commit;

