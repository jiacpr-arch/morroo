-- ===============================================================
-- หมอรู้ — Board seed: สูติศาสตร์-นรีเวชวิทยา (ob_gyn) — part 3/4 (50 MCQs)
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
  s.id, 'board', NULL, 'หญิงตั้งครรภ์ G1P0 GA 38 wk underlying genital HSV-2 with active recurrent outbreak (genital ulcers + vesicles) detected at L&R when contractions started

V/S: BP 122/74, HR 92, Temp 37.0
Gen: vulvar vesicles + ulcers visible, painful
Fetal: FHR 144, contractions q 5 min, cervix 2 cm', '[{"label":"A","text":"Allow vaginal delivery"},{"label":"B","text":"Genital HSV with active outbreak in labor → Cesarean delivery"},{"label":"C","text":"Forceps delivery"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Antibiotic only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Genital HSV with active outbreak in labor → Cesarean delivery** to prevent neonatal HSV (devastating CNS/disseminated disease, mortality 30-60%): (1) **indication for C/S** — active genital lesions OR **prodromal symptoms** at onset of labor → C/S preferred (even if ROM); ACOG; (2) **prevention** — suppressive **acyclovir 400 mg PO TID** OR **valacyclovir 500 mg PO BID** from 36 wk to delivery for women with recurrent genital HSV (reduces outbreaks + viral shedding + C/S need); (3) **PPROM management** — individualized: if active lesions + preterm + benefit of prolonging > risk neonatal HSV → continue expectant with acyclovir; if term with active lesions → C/S; (4) **avoid invasive procedures** — fetal scalp electrode, fetal scalp blood, instrumented delivery (vacuum/forceps in labor; vacuum/forceps for C/S OK); (5) **counsel patient** — risk neonatal HSV with active primary lesions in labor ~ 30-50%; recurrent ~ 1-3% (lower because of maternal antibody); (6) **first episode (primary)** during pregnancy → highest risk neonatal HSV → treat acyclovir 400 mg TID × 7-10 d, suppression from 36 wk, C/S in active labor; (7) **neonatal management** — culture (skin, eyes, mouth, NP, rectum), HSV PCR, exam q shift; preemptive acyclovir if exposed + symptomatic; (8) **breastfeeding** — safe unless breast lesions; (9) **partner counseling** + STI screen + condoms + suppression for prevention of transmission

---

Genital HSV + active outbreak in labor = C/S. Suppression acyclovir/valacyclovir 36 wk → delivery reduces outbreaks. Primary episode highest risk neonatal HSV. Avoid invasive procedures. Neonatal eval. Breastfeeding safe (no breast lesions). Partner counseling.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin 220: Management of Genital Herpes in Pregnancy 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงตั้งครรภ์ G1P0 GA 38 wk underlying genital HSV-2 with active recurrent outbreak (genital ulcers + vesicles) detected at L&R when contractions started

V/S: BP 122/74, HR 92, Temp 37.0
Gen: vulvar vesicles + ulcers visible, painful
Fetal: FHR 144, contractions q 5 min, cervix 2 cm'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 28 ปี G1P0 GA 16 wk pre-existing asthma, on inhaled budesonide + salbutamol PRN — has been having ↑ exacerbations recently, peak flow declining 80% → 60% best

V/S: BP 116/72, HR 90, RR 22
Gen: wheezing, accessory muscle use mild
Lab: SpO2 95% RA, no fever
Fetal: FHR 152 reactive', '[{"label":"A","text":"Stop all asthma medication"},{"label":"B","text":"Asthma in pregnancy management (poorly-controlled asthma → preterm birth, FGR, preeclampsia, perinatal mortality — RISK > medication risk)"},{"label":"C","text":"Cesarean immediately"},{"label":"D","text":"Use only oxygen"},{"label":"E","text":"Methotrexate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Asthma in pregnancy management (poorly-controlled asthma → preterm birth, FGR, preeclampsia, perinatal mortality — RISK > medication risk): (1) **continue + optimize medications** — pregnancy-safe: inhaled corticosteroids first-line (**budesonide** most data, fluticasone OK); SABA (albuterol/salbutamol) for rescue; LABA (salmeterol, formoterol) add-on; (2) **step-up therapy** for poor control — increase ICS dose, add LABA, add LTRA (montelukast), oral steroid burst (prednisolone) for exacerbations; (3) **monitor** — peak flow daily, symptom diary, ACT (Asthma Control Test); decline 20% needs action; (4) **trigger avoidance** — smoking cessation + secondhand smoke, allergens, infections (flu + COVID + Tdap vaccines indicated); (5) **acute exacerbation in pregnancy** — same as non-pregnant + lower threshold to admit; SpO2 target ≥ 95% (fetal); nebulized albuterol q 20 min × 3, ipratropium, IV magnesium, systemic steroid (methylprednisolone 60-125 mg IV or prednisolone 40-60 mg PO), O2; severe — ICU + ventilator; (6) **labor + delivery** — continue asthma meds; if on oral steroid > 2 wk in last year → stress dose hydrocortisone 100 mg IV q 8 hr in labor; avoid PGF2α (carboprost → bronchospasm), opioid morphine (histamine), aspirin (sensitive); preferred uterotonics oxytocin, misoprostol, methylergonovine (HT caution); (7) **fetal surveillance** — growth + NST if poorly controlled; (8) **lactation** — all asthma meds safe; (9) **postpartum** — continue therapy; (10) **multidisciplinary** — OB + pulm/allergy + primary care

---

Asthma pregnancy: 1/3 better, 1/3 worse, 1/3 same. Poor control > medication risk. Budesonide preferred ICS. Step up if poor control. Avoid PGF2α (bronchospasm) for PPH. Vaccines flu/COVID/Tdap. Stress dose steroid if chronic. Multidisciplinary.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'GINA Asthma Guidelines 2024; ACOG Asthma in Pregnancy', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 28 ปี G1P0 GA 16 wk pre-existing asthma, on inhaled budesonide + salbutamol PRN — has been having ↑ exacerbations recently, peak flow declining 80% → 60% best

V/S: BP 116/72, HR 90, RR 22
Gen: wheezing, accessory muscle use mild
Lab: SpO2 95% RA, no fever
Fetal: FHR 152 reactive'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงตั้งครรภ์ G2P1 GA 26 wk MVC trauma — driver, restrained, airbag deployed, abdominal blunt trauma + bilateral chest contusion

V/S: BP 110/72, HR 110, RR 22, SpO2 96%
Gen: alert, abdominal tenderness diffuse + uterine tenderness
Fetal: FHR 160 (tachy) with minimal variability
US pelvis: placenta posterior (not previa), AFI normal, no obvious abruption seen
Lab pending: CBC, type & screen, Kleihauer-Betke, coag', '[{"label":"A","text":"Discharge home + observe"},{"label":"B","text":"Trauma in pregnancy"},{"label":"C","text":"Cesarean immediately without trauma workup"},{"label":"D","text":"Refuse imaging"},{"label":"E","text":"Tocolytic only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Trauma in pregnancy** — leading cause of non-obstetric maternal death; manage with **standard ATLS + pregnancy modifications**: (1) **primary survey ABCDE** — airway (intubation as needed), breathing (O2, chest tube), circulation (large-bore IV ×2, crystalloid → blood; aim for normal pre-pregnancy targets), **left lateral tilt 15-30°** (LUD) after 20 wk to relieve aortocaval compression during resuscitation/CPR; (2) **disability** — GCS, glucose; (3) **exposure** — remove clothing, log roll, examine; (4) **secondary survey** — head-to-toe + obstetric (fundal tenderness, vaginal bleeding, ROM, FHR, contractions, fetal movement); pelvic + speculum exam; (5) **investigations** — CBC, type & cross, **Kleihauer-Betke** (FMH quantification → Anti-D dose calculation if Rh-neg; even trauma without bleeding can cause FMH), coag, lactate, **FAST exam** + radiology as indicated (don''t withhold imaging if needed — fetus tolerates well under 5-10 rad cumulative, especially first trimester avoiding pelvis if possible); CT chest/abdomen/pelvis if indicated — risk-benefit; shield uterus when feasible; (6) **fetal monitoring** — continuous EFM **minimum 4 hr** for trauma all gestations ≥ 20-24 wk (longer ≥ 24 hr if contractions > 6/hr, ROM, tenderness, vaginal bleeding, abnormal FHR, abnormal KB); category II/III FHR → consider abruption; (7) **resuscitative hysterotomy / perimortem C/S** — start within **4 min of arrest** if ≥ 23-24 wk for maternal + fetal benefit; (8) **rule out abruption** — abdominal pain, vaginal bleeding, contractions > 6/hr, abnormal FHR, hypertonic uterus, ↑ KB; up to 24 hr presentation; (9) **DV/IPV** — screen — trauma in pregnancy often domestic; (10) **Anti-D Ig** if Rh-negative + any abdominal trauma (even no bleeding — silent FMH possible); (11) **MDT** — trauma + OB + anesthesia + NICU + social

---

Trauma in pregnancy: ATLS + LUD + fetal monitoring ≥ 4 hr (longer if abnormalities). KB test for FMH + Anti-D. CT if indicated — don''t withhold. Abruption presentation up to 24 hr. Perimortem C/S < 4 min of arrest ≥ 24 wk. IPV screening — common cause. MDT.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Committee Opinion 518/667 Trauma in Pregnancy; Eastern Association Trauma Pregnancy', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงตั้งครรภ์ G2P1 GA 26 wk MVC trauma — driver, restrained, airbag deployed, abdominal blunt trauma + bilateral chest contusion

V/S: BP 110/72, HR 110, RR 22, SpO2 96%
Gen: alert, abdominal tenderness diffuse + uterine tenderness
Fetal: FHR 160 (tachy) with minimal variability
US pelvis: placenta posterior (not previa), AFI normal, no obvious abruption seen
Lab pending: CBC, type & screen, Kleihauer-Betke, coag'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 52 ปี postmenopausal × 2 yr มาด้วยอาการ stress urinary incontinence (leak with cough/sneeze/exercise) + pelvic pressure × 6 mo, ไม่มี dysuria

V/S: BP 132/82, HR 78
Pelvic: bulge of anterior vaginal wall to introitus on Valsalva (POP-Q stage 2 cystocele), Q-tip test angle 45° with Valsalva, no UTI, post-void residual 30 mL
Urine analysis: WNL
Cough stress test: positive', '[{"label":"A","text":"Antibiotic only"},{"label":"B","text":"Stress urinary incontinence (SUI) + pelvic organ prolapse (POP) — comprehensive management"},{"label":"C","text":"Cesarean delivery"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Antibiotic only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Stress urinary incontinence (SUI) + pelvic organ prolapse (POP) — comprehensive management: (1) **lifestyle + behavioral** first-line — weight loss, fluid management, treat constipation, smoking cessation; **pelvic floor muscle training (Kegel) supervised by PFPT** — strong evidence for SUI + POP; (2) **pessary** — supportive vaginal device for POP + SUI (ring, Gellhorn, donut, incontinence pessary) — non-surgical, fit clinic, change/clean q 3 mo, watch for erosion/discharge; (3) **vaginal estrogen** ถ้า GSM + atrophy (cream, ring, tablet) — improves tissue + symptoms; (4) **bladder training** + scheduled voiding; (5) **medications for SUI** — **duloxetine** (SNRI — modest effect, GI side effects); no other SUI-specific oral; for **urge incontinence** (different) — anticholinergic, mirabegron; (6) **surgical SUI** — **midurethral sling** (TVT/TOT) — gold standard; pubovaginal sling autologous fascia; Burch colposuspension; bulking agents (urethral injection); (7) **surgical POP** — vaginal hysterectomy + USLS (uterosacral ligament suspension) or sacrospinous ligament fixation; **sacrocolpopexy** (abdominal/lap/robotic) — gold standard apical support; native tissue repair anterior/posterior; **mesh** vaginal — restricted/banned in many countries; **colpocleisis** (Le Fort) — obliterative for elderly + frail; (8) **shared decision-making** — sexual activity desire, surgical risk; (9) follow-up + counsel recurrence; (10) workup before surgery — urodynamics (controversial routine), cystoscopy if indicated, PVR

---

SUI/POP management: lifestyle + PFPT + pessary + vaginal estrogen (1st line). Sling for SUI. Sacrocolpopexy gold standard apical POP. Mesh vaginal controversial. Colpocleisis frail elderly. Shared decision. Vaginal estrogen for atrophy.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'AUGS/ACOG SUI Practice Bulletin 155; AUGS Pelvic Organ Prolapse Practice Bulletin 214', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 52 ปี postmenopausal × 2 yr มาด้วยอาการ stress urinary incontinence (leak with cough/sneeze/exercise) + pelvic pressure × 6 mo, ไม่มี dysuria

V/S: BP 132/82, HR 78
Pelvic: bulge of anterior vaginal wall to introitus on Valsalva (POP-Q stage 2 cystocele), Q-tip test angle 45° with Valsalva, no UTI, post-void residual 30 mL
Urine analysis: WNL
Cough stress test: positive'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 35 ปี Pap smear + colposcopy + biopsy = cervical cancer SCC invasive — staging FIGO IB1 (tumor 3 cm confined to cervix, no parametrial invasion, no nodes)

V/S: BP 122/76, HR 80
Gen: well, no symptoms
MRI pelvis: 3 cm cervical mass, no parametrial/nodal involvement
PET-CT: no distant metastasis', '[{"label":"A","text":"Discharge — observation"},{"label":"B","text":"Early-stage cervical cancer (FIGO 2018 IB1, tumor < 2 cm; this case IB2 tumor 2-4 cm)"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Hysterectomy without staging"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Early-stage cervical cancer (FIGO 2018 IB1, tumor < 2 cm; this case IB2 tumor 2-4 cm)** — review FIGO 2018: IA microscopic; IB1 < 2 cm; IB2 2-4 cm; IB3 > 4 cm; II beyond uterus but not pelvic wall/lower vagina; III pelvic wall/hydronephrosis/lower vagina; IV beyond pelvis; (1) **staging gold standard** — clinical + imaging (MRI for local extent, PET-CT for nodes/distant), surgical staging optional; (2) **treatment options for IB1-IB2** (≤ 4 cm, lymph node negative): (a) **radical hysterectomy + bilateral pelvic lymphadenectomy** (Type C — Querleu-Morrow) — fertility loss; preferred if completed childbearing; sentinel LN biopsy increasingly used; **LACC trial 2018 — open approach superior to minimally invasive** (MIS had worse DFS + OS — paradigm shift away from lap/robotic for cervical cancer); (b) **chemoradiation** — alternative, similar survival, different morbidity (vaginal stenosis, bowel/bladder); (c) **fertility-sparing — radical trachelectomy** (vaginal Dargent or abdominal) + pelvic lymphadenectomy ถ้า tumor < 2 cm + no LVSI + no metastasis + desires fertility; cervical cerclage placed; future pregnancy high-risk preterm + need C/S; (3) **adjuvant therapy** — pelvic RT + concurrent platinum chemo (cisplatin) if intermediate (large tumor, deep stromal invasion, LVSI) or high risk (positive margin, parametrial, LN+); (4) **HPV vaccination** — primary prevention + post-treatment recurrence reduction (controversial); (5) **screening** — Thai universal cervical cancer screening (Pap or HPV); (6) **follow-up** — exam + cytology + HPV q 3-6 mo × 2 yr, then q 6-12 mo × 3 yr, then annual × 5 yr; imaging if symptoms; (7) **prognosis** — 5-yr stage IB1 > 90%, IB2 70-80%, IB3 60-70%, II 50-60%, III 30-40%, IV < 20%; (8) Thai context — RTCOG + Royal Thai GYN-Onc Society protocols

---

Cervical cancer FIGO 2018 staging. Early stage: radical hysterectomy or chemoradiation. LACC trial — OPEN approach (not lap/robotic) for radical hysterectomy. Fertility-sparing trachelectomy < 2 cm. Adjuvant RT-chemo for intermediate/high risk. HPV vaccine prevention. Thai protocols.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'FIGO Cervical Cancer Staging 2018; LACC Trial NEJM 2018; NCCN Cervical Cancer', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 35 ปี Pap smear + colposcopy + biopsy = cervical cancer SCC invasive — staging FIGO IB1 (tumor 3 cm confined to cervix, no parametrial invasion, no nodes)

V/S: BP 122/76, HR 80
Gen: well, no symptoms
MRI pelvis: 3 cm cervical mass, no parametrial/nodal involvement
PET-CT: no distant metastasis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 19 ปี nulligravid มา OPD ด้วยอาการประจำเดือนไม่มา 4 เดือน + galactorrhea + bilateral spontaneous nipple discharge + ปวดศีรษะ + bitemporal hemianopia

V/S: BP 116/72, HR 80
Gen: alert, no Cushingoid, no acromegaly, visual field defect on confrontation
Lab: β-hCG negative, prolactin 220 (very high), TSH 2.4 normal, FT4 normal, FSH/LH suppressed
MRI pituitary: 2.0 cm pituitary macroadenoma compressing optic chiasm', '[{"label":"A","text":"Discharge — wait + see"},{"label":"B","text":"Prolactinoma (macroadenoma > 10 mm) with mass effect (visual field defect)"},{"label":"C","text":"Cesarean delivery"},{"label":"D","text":"Antibiotic alone"},{"label":"E","text":"Hysterectomy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Prolactinoma (macroadenoma > 10 mm) with mass effect (visual field defect)** — endocrine + visual emergency: (1) **referral neurosurgery + endocrinology + neuro-ophthalmology** urgent; (2) **first-line — dopamine agonist** — even for macroadenoma with mass effect (medication can rapidly shrink tumor): (a) **cabergoline** 0.25-0.5 mg PO twice weekly, titrate up — preferred (better efficacy + tolerability + less valvular risk at low dose); (b) bromocriptine alternative; (3) **monitor** — prolactin level + MRI in 1-3 mo + repeat visual field; expect rapid normalization prolactin + tumor shrinkage 30-50% within months; vision recovery often rapid; (4) **surgical (transsphenoidal)** — second-line if medical fails or intolerance, or apoplexy, or CSF leak; (5) **radiation** — last resort; (6) **rule out hypopituitarism** — cortisol, ACTH, TSH/FT4, FSH/LH/E2, GH/IGF-1; treat as needed; (7) **etiology hyperprolactinemia** ddx — physiologic (pregnancy/lactation/stress/sleep/sex), medications (antipsychotics, metoclopramide, opioids, methyldopa), hypothyroidism (always check TSH), renal failure, hepatic, chest wall stim, idiopathic, macroadenoma; (8) **fertility** — restore ovulation usually with treatment; pregnancy possible — cabergoline can be continued if needed (older data bromocriptine more data — switch when pregnancy planned); microadenoma low risk in pregnancy (monitor visual field); macroadenoma may need surgical resection pre-pregnancy or close monitoring; (9) **counseling** — long-term often required (may discontinue if normalized > 2 yr + tumor shrunk)

---

Prolactinoma: dopamine agonist first-line even macroadenoma with mass effect. Cabergoline preferred. Rapid tumor shrinkage + vision recovery. Workup hyperprolactinemia ddx (meds, hypothyroid). Restore fertility. Pregnancy considerations. Surgery second-line.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'Endocrine Society Hyperprolactinemia 2011; Pituitary Society 2023', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 19 ปี nulligravid มา OPD ด้วยอาการประจำเดือนไม่มา 4 เดือน + galactorrhea + bilateral spontaneous nipple discharge + ปวดศีรษะ + bitemporal hemianopia

V/S: BP 116/72, HR 80
Gen: alert, no Cushingoid, no acromegaly, visual field defect on confrontation
Lab: β-hCG negative, prolactin 220 (very high), TSH 2.4 normal, FT4 normal, FSH/LH suppressed
MRI pituitary: 2.0 cm pituitary macroadenoma compressing optic chiasm'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 16 ปี G1P0 GA 32 wk teen pregnancy — มา ANC ครั้งแรก ตอน 32 wk, no prior care, denies STIs/substance use, lives with grandmother (parents absent), high school dropped out, anemia

V/S: BP 108/68, HR 88
Gen: thin, BMI 18
Fetal: FHR 148, fundal height 28 cm (small for GA)
Lab: Hb 8.2, MCV 78, ferritin 9, β-hCG positive (already known), VDRL negative, HIV negative, HBsAg negative, urine WNL
US: singleton, EFW 1,300 g (< 5th percentile), AFI 8, no anomaly', '[{"label":"A","text":"Discharge without follow-up"},{"label":"B","text":"Adolescent pregnancy (especially with late ANC + small for GA + anemia + social vulnerability) — multidisciplinary comprehensive care"},{"label":"C","text":"Cesarean immediately"},{"label":"D","text":"Refuse care"},{"label":"E","text":"Methotrexate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Adolescent pregnancy** (especially with late ANC + small for GA + anemia + social vulnerability) — multidisciplinary comprehensive care: (1) **non-judgmental + youth-friendly approach** — confidentiality, autonomy, trust-building; (2) **medical** — iron supplementation (ferrous sulfate + vit C; consider IV iron if intolerance/severe), nutritional counseling, weight gain target (BMI 18 underweight — recommend 12.5-18 kg gain), folic acid, calcium, fetal surveillance + growth US q 3-4 wk + Doppler if FGR, NST/BPP from 32 wk; (3) **risk awareness** — teen pregnancy ↑ preterm, PE, LBW, anemia, depression, social isolation; FGR present → workup placental insufficiency, smoking/substance, hypertension, infection; (4) **STI/HIV/hepatitis screening complete** + repeat 3rd trimester; **immunization** — Tdap 27-36 wk, flu, COVID; (5) **mental health** — PHQ-9/EPDS, screen depression + anxiety + IPV + self-harm; (6) **social work** — housing, food security, family support, legal (parental notification varies by jurisdiction — Thai law: under 18 needs parental consent for some decisions but ANC + emergency confidentiality), education continuation, financial support (Thai government child allowance), enrollment in maternal-child health programs; (7) **birth preparation** — childbirth education, breastfeeding counseling, doula/support person; (8) **delivery + postpartum** — vaginal delivery favored if no obstetric contra; teen pelvis usually adequate; postpartum contraception **LARC (implant, IUD)** at delivery — reduces repeat teen pregnancy (highest-impact intervention); (9) **breastfeeding** support; (10) **infant care** + home visiting nurse + pediatric follow-up; (11) Thai context — 1663 hotline; teen-friendly clinics; school continuation policies; (12) **prevent recurrence** — comprehensive sex ed + LARC promotion

---

Adolescent pregnancy: multidisciplinary. Late ANC + FGR + anemia + social risk. Youth-friendly. Iron + nutrition + growth surveillance. STI/HIV. Mental health. Social work + education. Postpartum LARC reduces repeat. Thai 1663 hotline + teen clinics + child allowance. Prevention: sex ed.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Committee Opinion 803: Teen Pregnancy; SAHM Adolescent Pregnancy Care', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 16 ปี G1P0 GA 32 wk teen pregnancy — มา ANC ครั้งแรก ตอน 32 wk, no prior care, denies STIs/substance use, lives with grandmother (parents absent), high school dropped out, anemia

V/S: BP 108/68, HR 88
Gen: thin, BMI 18
Fetal: FHR 148, fundal height 28 cm (small for GA)
Lab: Hb 8.2, MCV 78, ferritin 9, β-hCG positive (already known), VDRL negative, HIV negative, HBsAg negative, urine WNL
US: singleton, EFW 1,300 g (< 5th percentile), AFI 8, no anomaly'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 30 ปี G2P1 GA 28 wk ลื่นล้มเดิน + leg DVT acute — R leg painful + swollen + warmth × 2 d

V/S: BP 116/72, HR 92, RR 18, SpO2 98% RA
Gen: R lower limb edema + erythema + Homan''s sign +
Fetal: FHR 144 reactive
Doppler US: R popliteal + femoral DVT extending to iliac
Lab: CBC normal, no coagulopathy, D-dimer 4,200', '[{"label":"A","text":"Discharge with PO aspirin"},{"label":"B","text":"DVT in pregnancy"},{"label":"C","text":"Aspirin alone"},{"label":"D","text":"Discharge — observe"},{"label":"E","text":"Methotrexate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **DVT in pregnancy** — anticoagulation **LMWH** (does NOT cross placenta, safer than warfarin in pregnancy): (1) **anticoagulation initiation** — **LMWH enoxaparin 1 mg/kg SC BID** (therapeutic) — weight-based, adjust anti-Xa levels (peak 4 hr post-dose target 0.6-1.0 IU/mL prophylactic; 0.8-1.2 therapeutic); (2) **alternatives** — UFH IV (if labor imminent, renal failure, thrombolysis planned); avoid warfarin (teratogenic, fetal hemorrhage); avoid DOACs in pregnancy (insufficient data); (3) **rule out PE** — clinical assessment, oxygenation, ECG; CTPA if suspected (lower fetal radiation than V/Q); (4) **duration** — minimum 3 mo + continue through pregnancy + **6 wk postpartum** (overall ≥ 6 mo treatment); (5) **adjustments** — postpartum can transition to warfarin (safe in breastfeeding) bridge with LMWH × 5 d + INR therapeutic; (6) **delivery planning** — switch LMWH to UFH at 36-37 wk for flexibility (UFH t½ shorter, reversible with protamine, allows regional anesthesia); plan induction; **hold LMWH 24 hr before scheduled procedure** (12 hr prophylactic, 24 hr therapeutic); resume 6-12 hr postpartum if hemostatic; (7) **regional anesthesia** — wait 24 hr after therapeutic LMWH; (8) **mechanical** — early ambulation, compression stockings; (9) **thrombolysis** — massive PE only (postpartum bleed risk); IVC filter if anticoagulation contraindicated; (10) **workup thrombophilia** — postpartum off anticoagulation (pregnancy makes results unreliable); future pregnancies → prophylaxis LMWH; (11) **family** counseling + bleeding precautions

---

DVT pregnancy: LMWH therapeutic (1 mg/kg BID). Avoid warfarin (teratogen) + DOACs (no data). Duration: 3 mo + through pregnancy + 6 wk postpartum. Switch UFH at 36-37 wk. Hold for delivery. Regional anesthesia 24 hr off LMWH. Postpartum bridge to warfarin (safe breastfeeding). Future pregnancy prophylaxis.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin 196: Thromboembolism in Pregnancy; ASH 2018 VTE in Pregnancy', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 30 ปี G2P1 GA 28 wk ลื่นล้มเดิน + leg DVT acute — R leg painful + swollen + warmth × 2 d

V/S: BP 116/72, HR 92, RR 18, SpO2 98% RA
Gen: R lower limb edema + erythema + Homan''s sign +
Fetal: FHR 144 reactive
Doppler US: R popliteal + femoral DVT extending to iliac
Lab: CBC normal, no coagulopathy, D-dimer 4,200'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 30 ปี G3P2 GA 12 wk underlying CKD stage 3a (baseline Cr 1.6, eGFR 45), pre-existing proteinuria 1+ baseline, hypertension on losartan 50 mg/d pre-pregnancy

V/S: BP 138/86, HR 76
Gen: well
Fetal: heart present, dating CRL matches LMP
Lab: Cr 1.7, eGFR 42, urine protein/Cr 0.9, K 4.2, Hb 10.5, no preeclampsia features', '[{"label":"A","text":"Continue losartan"},{"label":"B","text":"CKD in pregnancy"},{"label":"C","text":"Continue all meds without change"},{"label":"D","text":"Cesarean immediately at 12 wk"},{"label":"E","text":"Methotrexate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **CKD in pregnancy** — high-risk, multidisciplinary (nephrology + MFM): (1) **stop teratogenic medications** — **discontinue losartan (ARB) immediately** — ACEI/ARB cause fetal renal dysgenesis + oligohydramnios + skull hypoplasia + fetal death (2nd-3rd trimester especially; even 1st trimester risk); switch to **safe antihypertensive** — labetalol, nifedipine ER, methyldopa; target BP 110-140/85 (CHAP); (2) **assess baseline + monitor** — eGFR, urine protein/Cr or 24-hr, K, P, Ca, Hb, BP; serial monitoring q 2-4 wk early then more frequent; (3) **risk stratification** — Cr > 1.4 mg/dL = ↑ risk progression CKD + adverse OB outcomes (preeclampsia, FGR, preterm, perinatal mortality); dialysis-dependent — fertility lower, very high-risk pregnancy; (4) **aspirin 81-150 mg/d from 12-16 wk to delivery** — preeclampsia prevention (CKD = high risk); (5) **proteinuria** — distinguish baseline vs preeclampsia (new doubling, severe features); (6) **anemia** — iron + ESA (erythropoietin safe); (7) **fetal surveillance** — anatomy scan, serial growth q 4 wk, NST/BPP from 28-32 wk; (8) **delivery timing** — individualized based on maternal-fetal status; aim for term if stable; earlier if maternal deterioration or fetal compromise; (9) **postpartum** — kidney function reassess; may resume ACEI/ARB postpartum (avoid in breastfeeding — though enalapril/captopril considered compatible by Hale''s); (10) **dialysis pregnancy** — intensify hemodialysis (> 36 hr/wk improves outcomes); (11) **preconception counseling** ideal — optimize BP + proteinuria + transplantation; (12) **post-transplant pregnancy** — wait 1-2 yr, stable function, switch teratogenic immunosuppressants (mycophenolate → azathioprine)

---

CKD pregnancy: stop ACEI/ARB (teratogenic). Switch to labetalol/nifedipine/methyldopa. Aspirin PE prevention. Cr > 1.4 high risk. Monitor closely. Preconception counseling. Dialysis intensify. Post-transplant: 1-2 yr after, stable, change immunosuppressants. Multidisciplinary.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin 202: Pregnancy in Women with Renal Disease; KDIGO Pregnancy + CKD', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 30 ปี G3P2 GA 12 wk underlying CKD stage 3a (baseline Cr 1.6, eGFR 45), pre-existing proteinuria 1+ baseline, hypertension on losartan 50 mg/d pre-pregnancy

V/S: BP 138/86, HR 76
Gen: well
Fetal: heart present, dating CRL matches LMP
Lab: Cr 1.7, eGFR 42, urine protein/Cr 0.9, K 4.2, Hb 10.5, no preeclampsia features'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามอาจารย์เรื่อง fetal lung development + surfactant + RDS pathophysiology', '[{"label":"A","text":"Surfactant produced from week 12"},{"label":"B","text":"Fetal lung development + surfactant"},{"label":"C","text":"Type I pneumocytes produce surfactant"},{"label":"D","text":"L/S ratio mature at 1"},{"label":"E","text":"Surfactant unrelated to RDS"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Fetal lung development + surfactant: (1) **stages**: (a) embryonic 4-6 wk (lung bud), (b) pseudoglandular 5-17 wk (airways branching), (c) canalicular 16-25 wk (vascularization, terminal sacs, first surfactant ~ 24 wk), (d) saccular 24-40 wk (alveolar precursors), (e) alveolar 36 wk → 8 yr (alveolarization continues); (2) **surfactant** — produced by **type II pneumocytes** from ~ 24 wk, mature production by 35-36 wk; (3) **composition** — 90% phospholipids (primarily **DPPC — dipalmitoylphosphatidylcholine = lecithin**), 10% proteins (SP-A, B, C, D — B + C surface activity, A + D innate immunity), small amount neutral lipids; (4) **function** — reduces alveolar surface tension → prevents alveolar collapse on expiration + ↓ work of breathing + maintains FRC + improves compliance; (5) **fetal lung maturity tests** (mostly historical now): **L/S ratio** (lecithin/sphingomyelin) ≥ 2 = mature; **phosphatidylglycerol** (PG) presence = mature even in DM; **TDx-FLM**; foam stability index — modern obstetrics uses GA + amniocentesis only for select cases; (6) **antenatal corticosteroids (betamethasone)** induce type II pneumocyte surfactant production + alveolar maturation + edema clearance → reduces RDS, IVH, NEC, mortality (Liggins 1972; Cochrane meta-analysis); (7) **postnatal surfactant therapy** — exogenous (Survanta/poractant) intratracheal for RDS/preterm; (8) **RDS pathophysiology** — surfactant deficiency → alveolar collapse → V/Q mismatch → hypoxia + hypercarbia + acidosis + hyaline membrane formation; X-ray: ground-glass + air bronchograms + low volume; (9) **prevention** — antenatal steroids 24-34 wk (extend to 34-36+6 wk ALPS trial); avoid unnecessary late preterm/term elective delivery; (10) maternal DM → delayed lung maturity (hyperinsulinemia inhibits surfactant) — PG important marker

---

Fetal lung dev stages. Surfactant from type II pneumocytes from 24 wk. DPPC + proteins SP-A/B/C/D. Reduces surface tension. Antenatal steroids mature lungs. RDS = surfactant deficiency. L/S ratio + PG historic markers. DM delays maturity. ALPS late preterm steroids 34-36+6 wk.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'basic_science', 'obgyn', 'adult',
  'Avery Diseases of the Newborn 10e; ACOG Antenatal Corticosteroids 713', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Resident ถามอาจารย์เรื่อง fetal lung development + surfactant + RDS pathophysiology'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามอาจารย์เรื่อง pelvic anatomy + planes of labor + Caldwell-Moloy pelvis types', '[{"label":"A","text":"Caldwell-Moloy: 3 types only"},{"label":"B","text":"Pelvic anatomy + obstetric planes"},{"label":"C","text":"Pelvic outlet has 5 types"},{"label":"D","text":"Diagonal conjugate is the shortest diameter"},{"label":"E","text":"Android most common pelvis type"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pelvic anatomy + obstetric planes: (1) **bony pelvis** — false pelvis (above linea terminalis, supports abdo) + true pelvis (below — birth canal); (2) **pelvic inlet** — boundaries: sacral promontory, alae, linea terminalis, pubic crest; transverse ~ 13.5 cm, AP (true conjugate ~ 11 cm); important: **obstetric conjugate** ~ 10 cm (shortest AP — promontory to inner pubic symphysis); **diagonal conjugate** (clinically measured: lower symphysis to promontory, normal ≥ 11.5 cm); (3) **midpelvis** — narrowest plane; ischial spines (transverse 10 cm); **interspinous diameter ≥ 10 cm** for vaginal delivery; (4) **pelvic outlet** — pubic arch, ischial tuberosities (transverse ~ 11 cm), tip of coccyx; subpubic angle > 90° favorable; (5) **Caldwell-Moloy classification** (4 types based on inlet): (a) **gynecoid** (50%) — round inlet, wide subpubic angle, best for vaginal delivery; (b) **android** (30%, male-type) — heart-shaped, narrow subpubic, prominent spines, ↑ arrest of labor + OP; (c) **anthropoid** (25%) — AP > transverse oval, narrow transverse, OP/OA presentations common, often allows vaginal; (d) **platypelloid** (3%) — flat, wide transverse + narrow AP, transverse arrest, often C/S; (6) **clinical pelvimetry** — diagonal conjugate, ischial spine prominence, subpubic angle, sacrum curvature, sidewalls; not predictive enough for routine C/S decision — trial of labor; (7) **cardinal movements of labor** — engagement, descent, flexion, internal rotation, extension, restitution, external rotation, expulsion; (8) **station** — ischial spines = 0; -5 high to +5 crowning; (9) **soft tissues** — pelvic floor muscles (levator ani — pubococcygeus, iliococcygeus, puborectalis) + perineal membrane + supportive ligaments; (10) **abnormalities** — contracted inlet (< 10 cm conjugate), midpelvis, outlet → may need C/S

---

Pelvic anatomy: inlet/mid/outlet planes. Obstetric conjugate shortest AP. Caldwell-Moloy 4 types — gynecoid best. Cardinal movements 8. Station ischial spines. Pelvic floor levator ani. Soft tissue + bony assessment.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'basic_science', 'obgyn', 'adult',
  'Williams Obstetrics 26e Ch 2; Cunningham Anatomy', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Resident ถามอาจารย์เรื่อง pelvic anatomy + planes of labor + Caldwell-Moloy pelvis types'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามอาจารย์เรื่อง teratology — principles + medication categories + common teratogens', '[{"label":"A","text":"All medications equally safe in pregnancy"},{"label":"B","text":"stage of development"},{"label":"C","text":"Warfarin is safe in pregnancy"},{"label":"D","text":"Ace inhibitors are safe in pregnancy"},{"label":"E","text":"Valproate is safest antiepileptic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Teratology principles: (1) **6 principles (Wilson)**: (a) **genotype** of conceptus + interaction with environment; (b) **stage of development** at exposure — fertilization (all-or-none), embryonic period 3-8 wk (organogenesis — highest risk structural), fetal period (functional + growth); (c) **mechanism** specific (folate antagonist, DNA damage, receptor); (d) **agent type** + chemical/biologic properties; (e) **dose-dependent** + threshold (some); (f) **manifestations** — death, malformation, growth restriction, functional disorder; (2) **FDA categories obsolete (A/B/C/D/X)** — replaced 2015 by **Pregnancy + Lactation Labeling Rule (PLLR)** — narrative summary of risk; (3) **common teratogens + effects**: (a) **alcohol** — fetal alcohol spectrum disorder (FAS — short palpebral fissures, smooth philtrum, thin upper lip, growth, CNS); no safe dose; (b) **isotretinoin** — high risk craniofacial, cardiac, CNS, abortion; iPledge program; (c) **valproate** — NTD, cleft lip/palate, cardiac, neurodevelopmental; switch preconception; (d) **warfarin** — embryopathy (nasal hypoplasia, stippled epiphyses); fetal hemorrhage; (e) **ACEI/ARB** — renal dysgenesis, oligohydramnios, skull hypoplasia (2nd-3rd trimester); (f) **lithium** — Ebstein anomaly (cardiac); risk vs untreated bipolar; (g) **methotrexate, mycophenolate, cyclophosphamide** — abortion, malformation; (h) **phenytoin** — fetal hydantoin syndrome; (i) **tetracycline, doxycycline** — teeth staining + bone (after 14 wk); (j) **streptomycin/gentamicin** — ototoxicity; (k) **fluoroquinolone** — cartilage (mostly animal data, generally avoid); (l) **statins** — controversial, recently relabeled less risk; (m) **misoprostol** — Möbius sequence; (n) **DES** — vaginal clear cell, T-shaped uterus; (o) **thalidomide** — limb phocomelia; (p) **NSAIDs** — DA closure 3rd trimester, oligohydramnios; (q) **paroxetine** — small ↑ cardiac defects; (4) **infections** — TORCH (toxo, rubella, CMV, HSV, syphilis, Zika, VZV, parvovirus B19); (5) **maternal disease** — DM (cardiac, NTD, caudal regression), PKU (CHD, microcephaly), thyroid; (6) **environmental** — radiation (high dose), lead, mercury; (7) **preconception counseling** — medication review, optimize disease, folate; (8) resources — Mother to Baby (MotherToBaby), LactMed, Reprotox

---

Teratology: Wilson''s 6 principles. PLLR replaced FDA categories. Common teratogens — alcohol, isotretinoin, valproate, warfarin, ACEI/ARB, lithium, methotrexate. TORCH infections. DM, PKU. Preconception counseling. MotherToBaby resource.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'basic_science', 'obgyn', 'adult',
  'Cunningham Williams Obstetrics; FDA PLLR 2015; Briggs Drugs in Pregnancy', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Resident ถามอาจารย์เรื่อง teratology — principles + medication categories + common teratogens'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามอาจารย์เรื่อง bone metabolism + menopause + osteoporosis pathophysiology', '[{"label":"A","text":"Estrogen increases bone resorption"},{"label":"B","text":"Bone metabolism + menopause + osteoporosis"},{"label":"C","text":"Bisphosphonate stimulates osteoblast"},{"label":"D","text":"Osteoporosis T-score > 2.5"},{"label":"E","text":"Calcitonin is first-line"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bone metabolism + menopause + osteoporosis: (1) **bone remodeling** — continuous balance of osteoclast resorption + osteoblast formation; coupled cycle; (2) **estrogen role** — **inhibits osteoclast activity** (via RANKL/OPG balance), promotes osteoblast survival, ↓ inflammatory cytokines (IL-6, TNF); menopause → estrogen withdrawal → ↑ osteoclast → ↑ resorption → rapid trabecular bone loss especially first 5 yr (~ 2-3%/yr) then 1%/yr; (3) **peak bone mass** — achieved by age 25-30; influenced by genetics, nutrition (calcium, vit D), exercise, hormonal status; (4) **osteoporosis** — T-score ≤ -2.5 on DEXA (lumbar spine, hip, distal radius); osteopenia T-score -1.0 to -2.5; (5) **risk factors** — age, female, postmenopausal, low BMI, family history, smoking, alcohol, glucocorticoid, anticonvulsant, GnRH agonist (chronic), aromatase inhibitor, early menopause, hypogonadism, hyperparathyroid, hyperthyroid, hypovitamin D, malabsorption, RA, CKD; (6) **fracture risk** — vertebral, hip, distal radius (Colles); FRAX 10-yr risk; (7) **screening DEXA** — women ≥ 65, postmenopausal < 65 with risk factors (USPSTF); Thai recommendations similar; (8) **prevention** — calcium 1,200 mg/d + vit D 800-1,000 IU/d, weight-bearing exercise, smoking/alcohol cessation, fall prevention; (9) **pharmacologic treatment** — (a) **bisphosphonates** (alendronate, risedronate, zoledronate) — first-line — antiresorptive; (b) **denosumab** — monoclonal Ab against RANKL — antiresorptive; (c) **raloxifene** (SERM) — bone + breast cancer prevention, ↑ VTE; (d) **teriparatide, abaloparatide** — PTH analog anabolic; (e) **romosozumab** — sclerostin antibody anabolic + antiresorptive; (f) **MHT** — estrogen for menopausal symptoms + bone (not first-line for osteoporosis alone post WHI); (g) **calcitonin** — limited; (10) **monitoring** — DEXA q 1-2 yr on therapy; (11) Thai context — RTCOG osteoporosis guidelines; calcium dietary often low

---

Bone metabolism: estrogen inhibits osteoclasts (RANKL/OPG). Menopause → bone loss. Osteoporosis T ≤ -2.5. DEXA screening ≥ 65 (or earlier with risk). Prevention: Ca/vit D + exercise. Bisphosphonate first-line. Denosumab, teriparatide, romosozumab newer. MHT for menopause symptoms + bone benefit.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'basic_science', 'obgyn', 'adult',
  'NAMS Position Statement; AACE/ACE Osteoporosis 2020; NOF Clinician Guide', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Resident ถามอาจารย์เรื่อง bone metabolism + menopause + osteoporosis pathophysiology'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Rural Thai hospital implements telemedicine for ANC consultation with MFM + remote OB ultrasound interpretation', '[{"label":"A","text":"Telemedicine is not feasible"},{"label":"B","text":"Telemedicine in OB"},{"label":"C","text":"Eliminate in-person ANC entirely"},{"label":"D","text":"Use only paper records"},{"label":"E","text":"Refuse new technology"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Telemedicine in OB** — expanded access + quality: (1) **synchronous video consultations** with MFM/specialty for high-risk pregnancies — diabetes, HTN, cardiac, complex anomalies; (2) **remote US interpretation** — tele-ultrasound — local sonographer scans, expert remote review (real-time or store-and-forward); (3) **continuous monitoring** — wearables (BP, glucose), home NST devices, remote PT monitoring; (4) **ANC visit modifications** — hybrid model — fewer in-person + telehealth for routine visits in low-risk pregnancies; (5) **postpartum + lactation support** virtual; (6) **rural + underserved access** — reduces travel + costs + improves equity; (7) **mental health** — perinatal psychiatry telehealth; (8) **education** — virtual childbirth classes, BF support groups; (9) **considerations**: (a) ensure adequate technology + bandwidth + privacy/security (HIPAA equivalent), (b) appropriate triage — some visits need in-person (BP, fundal height, fetal heart, exam, US), (c) clear protocols for escalation, (d) cultural + language considerations, (e) reimbursement structure, (f) provider training, (g) patient acceptance + technology literacy; (10) **evidence** — COVID-era data — telemedicine ANC non-inferior in low-risk + improves attendance; (11) **Thai context** — National Telemedicine Policy 2020; Bumrungrad/Bangkok hospitals leaders; expansion to rural areas via Ministry of Public Health (สอ./รพ.สต.); (12) **integration** — with EMR, regional health systems, referral network

---

Telemedicine in OB: ANC for low-risk hybrid, MFM consults, tele-US, remote monitoring, postpartum, mental health. Equity + access. Safeguards: technology, privacy, escalation, training. Thai context: National Telemedicine Policy, rural expansion. Evidence COVID-era favorable.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'ems_mgmt', 'obgyn', 'adult',
  'ACOG Committee Opinion 798: Telehealth; Thai MOPH Telemedicine Policy', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Rural Thai hospital implements telemedicine for ANC consultation with MFM + remote OB ultrasound interpretation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital implements I-PASS handoff bundle on Labor & Delivery to reduce harm from communication failures', '[{"label":"A","text":"Skip handoffs"},{"label":"B","text":"I-PASS handoff"},{"label":"C","text":"Use only verbal informal"},{"label":"D","text":"Skip patient summary"},{"label":"E","text":"No standardization"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **I-PASS handoff** (structured handoff communication, evidence reduces preventable adverse events ~ 30%): (1) **I — Illness severity** — sick/getting sick/watcher/stable; (2) **P — Patient summary** — concise SBAR-like summary; (3) **A — Action list** — to-do items with owners + timeline; (4) **S — Situation awareness + contingency planning** — anticipated problems + ''if-then'' plans; (5) **S — Synthesis by receiver** — receiver summarizes + asks clarifying questions (closed-loop); **implementation OB**: (a) shift change L&D + antepartum + postpartum + nursery; (b) standardized template/checklist embedded in EMR; (c) protected time + minimize interruptions; (d) bedside huddles + bedside handoffs (''hello to patient''); (e) simulation training + champions + audit; (6) **specific OB high-risk handoff scenarios** — laboring patient changing shift, OR-to-PACU, antepartum-to-L&D, L&D-to-postpartum, postpartum-to-newborn nursery; (7) **emergency code handoffs** — closed-loop SBAR; (8) **measurement** — observed handoff quality, miscommunication rate, adverse events, near-misses; (9) **culture** — psychological safety, speak-up; (10) **special — pregnant patient transfer between hospitals** — clear documentation + advance call + accepting MD + transfer summary + accompanying staff per acuity

---

I-PASS handoff: Illness severity, Patient summary, Action list, Situation awareness, Synthesis. Evidence reduces adverse events ~ 30%. OB-specific scenarios — shift change, OR-to-PACU, transfers. Embedded in EMR. Bedside. Simulation. Measurement. Culture of safety.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'ems_mgmt', 'obgyn', 'adult',
  'I-PASS Handoff Bundle Starmer NEJM 2014; ACGME Common Program Requirements', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Hospital implements I-PASS handoff bundle on Labor & Delivery to reduce harm from communication failures'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Ministry establishes levels of maternal care system to match patient acuity to facility capability', '[{"label":"A","text":"All hospitals equal capability"},{"label":"B","text":"Levels of Maternal Care"},{"label":"C","text":"Eliminate referral system"},{"label":"D","text":"All low-risk to tertiary"},{"label":"E","text":"Skip transfers"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Levels of Maternal Care** (ACOG/SMFM 2019 / WHO regionalization): standardizes facility capability + matches patient acuity → improves outcomes (similar concept to neonatal levels): (1) **Birth Center / Level I (Basic Care)** — uncomplicated, low-risk, term singleton vertex; immediate stabilization + transfer for complications; midwifery model; (2) **Level I (Basic Hospital)** — care of low to moderate-risk pregnancies; 24/7 OB/midwife + anesthesia available; ability to perform emergency C/S; immediate transfer for higher levels; (3) **Level II (Specialty)** — high-risk including moderate complications (e.g., GDM on insulin, mild preeclampsia); 24/7 obstetrician + anesthesia + level II NICU (≥ 32 wk); MFM consultation available; (4) **Level III (Subspecialty)** — comprehensive — major maternal medical conditions, severe obstetric complications; 24/7 MFM + anesthesia + level III NICU + adult ICU + medical specialists; surgical capability including cesarean hysterectomy; blood bank + IR; (5) **Level IV (Regional Perinatal Health Care Centers)** — most complex — placenta accreta spectrum, complex cardiac, transplant, ECMO; on-site full subspecialty; training + research + outreach; (6) **transfer criteria + system** — early transfer better than late (in-utero transfer when possible); referral network; bidirectional (back-transport stable to home hospital); (7) **regulations + verification** — facility self-attestation + accreditation; (8) **Thai context** — Health Ministry levels (สถานีอนามัย/รพ.สต. → รพ.ชุมชน → รพ.ทั่วไป → รพ.ศูนย์ → รพ.มหาวิทยาลัย); MCH boards; (9) **equity** — geographic + financial access; (10) **outcomes** — improved when matched care; sentinel events with mismatch; (11) **research/data sharing**; (12) **drills + simulation** + interfacility coordination

---

Levels of Maternal Care: birth center, Level I-IV. Match acuity to capability. In-utero transfer preferable. Regional Perinatal Centers most complex. Thai system: รพ.ศูนย์/มหาวิทยาลัย. Accreditation + verification. Outcomes improved with matched care.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'ems_mgmt', 'obgyn', 'adult',
  'ACOG/SMFM Obstetric Care Consensus 9: Levels of Maternal Care 2019', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Ministry establishes levels of maternal care system to match patient acuity to facility capability'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Quality improvement project — reducing primary C-section rate (NTSV — nulliparous term singleton vertex) without compromising safety', '[{"label":"A","text":"Increase C-sections"},{"label":"B","text":"NTSV C-section rate reduction"},{"label":"C","text":"Eliminate fetal monitoring"},{"label":"D","text":"Force vaginal delivery without consent"},{"label":"E","text":"Cesarean for all"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **NTSV C-section rate reduction** (CMS quality measure; benchmark ≤ 23.6% target; safe vaginal birth + reduce primary C/S → reduces subsequent C/S + accreta): evidence-based interventions: (1) **labor management** — (a) **adopt Friedman → newer labor curves (Consortium on Safe Labor, Zhang 2010)** — active labor starts at 6 cm not 4 cm; allow more time before diagnosing arrest disorders; (b) **arrest of dilation criteria** — no progress 4 hr adequate contractions OR 6 hr inadequate contractions after 6 cm dilation (ACOG/SMFM Safe Prevention of Primary C-Section); (c) **arrest of descent** — push 3 hr nullip with epidural (4 hr possible) before C/S; (2) **induction of labor** — (a) allow latent phase 24 hr in induced labor before failure dx; (b) ARRIVE trial — IOL at 39 wk in low-risk nullip doesn''t ↑ C/S; (3) **continuous labor support** — doulas/midwifery model reduces C/S; (4) **fetal heart rate** — accurate NICHD interpretation, intrauterine resuscitation, scalp stim, fetal scalp blood, restrict cesarean to category III + persistent II; (5) **breech** — offer ECV at 37 wk; vaginal breech selective; (6) **TOLAC** — appropriate selection + availability; (7) **prenatal education** — preferences, expectations, when to come in (4-1-1 rule), avoid early labor admission; (8) **provider feedback + audit** — share NTSV rates by provider + practice; (9) **culture** — patient choice, shared decision; (10) **data systems** — collaborative (CMQCC, ACOG Council); (11) **payment reform** — bundled payment removing financial incentive C/S; (12) **simulation + workforce** — vaginal breech, operative vaginal skills

---

Reduce NTSV C/S: Zhang labor curves (active labor 6 cm), longer latent + active + 2nd stage tolerance, ARRIVE 39-wk IOL, continuous support, NICHD CTG, ECV breech, TOLAC, education. Provider audit + culture + payment reform. CMQCC + CMS measure benchmark.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'ems_mgmt', 'obgyn', 'adult',
  'ACOG/SMFM Safe Prevention of Primary C-Section Care Consensus 1 2014; CMQCC Toolkit', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Quality improvement project — reducing primary C-section rate (NTSV — nulliparous term singleton vertex) without compromising safety'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 26 ปี G2P1 GA 12 wk underlying SLE on HCQ + low-dose prednisone, recently flared with arthritis + proteinuria 1g/d + ANA + anti-dsDNA + low C3 — on stable doses

V/S: BP 138/86, HR 92
Gen: malar rash + arthritis active
Fetal: heart present, dating correct, normal early US
Lab: Hb 10.8, plt 145K, Cr 0.8, urine protein/Cr 0.9, anti-dsDNA elevated, low C3, anti-Ro/La positive, antiphospholipid Ab negative', '[{"label":"A","text":"Stop all medications"},{"label":"B","text":"SLE in pregnancy"},{"label":"C","text":"Cesarean immediately"},{"label":"D","text":"Stop HCQ"},{"label":"E","text":"Methotrexate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **SLE in pregnancy** — high-risk multidisciplinary (rheumatology + MFM + neonatology): (1) **preconception planning** — disease quiescent ≥ 6 mo, no active nephritis, controlled HT, safe medications, normal renal function; (2) **continue safe medications** — **HCQ continue** (reduces flares + congenital heart block + neonatal lupus + thrombosis + preeclampsia); **low-dose prednisone** (< 20 mg/d) if needed; **azathioprine** if more immunosuppression; **avoid** — mycophenolate (teratogen — switch to azathioprine), cyclophosphamide, methotrexate; (3) **flare management** — distinguish from preeclampsia (often difficult — both can have proteinuria, HT, low plt); ↑ prednisone for flare; pulse methylprednisolone severe; (4) **APS (antiphospholipid syndrome) workup** — lupus anticoagulant, anti-cardiolipin IgG/IgM, anti-β2GP1; **if positive** — aspirin + prophylactic LMWH (history thrombosis) or aspirin alone (no thrombosis); (5) **preeclampsia prevention** — **aspirin 81-150 mg/d from 12-16 wk** (high-risk); (6) **anti-Ro/La positive** → fetal echo serial (q 1-2 wk from 16-28 wk) for **congenital heart block + neonatal lupus**; if 1°-2° AV block → consider dexamethasone + IVIG (controversial); 3° AV block irreversible; (7) **fetal surveillance** — anatomy scan, growth, NST/BPP; FGR + preterm risk; (8) **delivery timing** — 38-39 wk uncomplicated; earlier if maternal/fetal compromise; vaginal preferred; (9) **postpartum** — **flare risk** common — continue therapy; breastfeeding compatible with HCQ, low-dose prednisone, azathioprine; (10) **monitor** — labs q 4-6 wk (CBC, Cr, urine protein/Cr, anti-dsDNA, C3/C4, LFT); BP; (11) future pregnancy planning + contraception (avoid estrogen if APS+; progestin OK; IUD OK); (12) Thai SLE community + support

---

SLE pregnancy: HCQ continue (vital), prednisone low-dose, azathioprine if needed. Avoid MMF/cyclophosphamide/MTX. Aspirin PE prevention. APS workup + treatment. Anti-Ro/La → fetal echo congenital heart block. Multidisciplinary. Postpartum flare. Breastfeeding safe with most. Distinguish flare vs PE difficult.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'integrative', 'obgyn', 'adult',
  'EULAR/ACR SLE in Pregnancy 2020; ACOG Practice Bulletin 234', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 26 ปี G2P1 GA 12 wk underlying SLE on HCQ + low-dose prednisone, recently flared with arthritis + proteinuria 1g/d + ANA + anti-dsDNA + low C3 — on stable doses

V/S: BP 138/86, HR 92
Gen: malar rash + arthritis active
Fetal: heart present, dating correct, normal early US
Lab: Hb 10.8, plt 145K, Cr 0.8, urine protein/Cr 0.9, anti-dsDNA elevated, low C3, anti-Ro/La positive, antiphospholipid Ab negative'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 24 ปี G1P0 GA 28 wk active opioid use disorder (heroin daily) + alcohol + cannabis use, IDU history, no recent overdose, HIV/HCV unknown

V/S: BP 122/76, HR 102, RR 18
Gen: track marks both forearms, dental decay, withdrawal signs mild
Fetal: FHR 158 reactive, EFW 1,100 g (10th percentile)
Lab: urine tox positive opioid + cannabis + cocaine, anti-HIV + HCV Ab pending, HBsAg pending, TSH normal, syphilis VDRL pending', '[{"label":"A","text":"Refuse care + discharge"},{"label":"B","text":"Substance use disorder (SUD) in pregnancy"},{"label":"C","text":"Force C-section"},{"label":"D","text":"Discharge without follow-up"},{"label":"E","text":"Methotrexate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Substance use disorder (SUD) in pregnancy** — comprehensive harm-reduction + treatment + non-judgmental + multidisciplinary: (1) **opioid use disorder (OUD)** — **medication for opioid use disorder (MOUD)** — **methadone** (clinic-based, daily; safe + recommended in pregnancy; stabilizes mother + fetus; reduces overdose, illicit use, transmission; safe in lactation; can ↑ dose 2nd-3rd trimester due to metabolism) OR **buprenorphine** (now first-line option per recent ACOG — outpatient prescribing; better neonatal outcomes — shorter NAS, less severe; mono product preferred over combo with naloxone — though combo now considered acceptable); (2) **AVOID detoxification/withdrawal during pregnancy** — high relapse + overdose risk; agonist therapy preferred; (3) **prenatal care comprehensive** — frequent visits, social work, addiction medicine, mental health, peer support; (4) **infection screening** — HIV, HBV, HCV, syphilis, GC/CT, TB; treatment per status; HBV vaccination if susceptible; HCV — DAA postpartum (some safety in pregnancy now); (5) **other substances** — alcohol (no safe — refer SBIRT, AA, naltrexone postpartum), cannabis (avoid — neurodevelopmental); cocaine/meth (avoid — abruption, FGR, vasoconstriction); benzo (taper carefully); tobacco (NRT, varenicline limited data, contingency); (6) **fetal surveillance** — growth + NST/BPP (FGR risk); (7) **labor management** — continue MOUD; avoid agonist-antagonist (precipitates withdrawal); adequate analgesia (will need higher doses opioid for pain on top of maintenance — non-opioid adjuncts); epidural OK; (8) **neonatal** — **Neonatal Abstinence Syndrome (NAS) / NOWS** — eat-sleep-console approach + morphine/methadone PRN; rooming-in + breastfeeding (if mother stable on MOUD + not using illicit) reduces NAS severity; (9) **postpartum** — high relapse + overdose mortality risk — continuity + naloxone Rx + harm reduction + LARC contraception; (10) **legal** — Thai law: not mandatory reporting SUD pregnancy but DCFS varies; offer voluntary treatment, support family; (11) **stigma reduction** — language (''person with SUD'' not ''addict''); (12) **Thailand resources** — Thanyarak Institute, Princess Mother addiction centers

---

OUD pregnancy: MOUD (methadone or bupe). AVOID detox. Comprehensive prenatal + addiction + mental health. STI screening. Other substances. Labor: continue MOUD + adequate analgesia. NAS — eat-sleep-console. Postpartum overdose risk high. LARC. Stigma reduction. Thai Thanyarak.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'integrative', 'obgyn', 'adult',
  'ACOG Committee Opinion 711: OUD in Pregnancy; ASAM/AAFP/SMFM Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 24 ปี G1P0 GA 28 wk active opioid use disorder (heroin daily) + alcohol + cannabis use, IDU history, no recent overdose, HIV/HCV unknown

V/S: BP 122/76, HR 102, RR 18
Gen: track marks both forearms, dental decay, withdrawal signs mild
Fetal: FHR 158 reactive, EFW 1,100 g (10th percentile)
Lab: urine tox positive opioid + cannabis + cocaine, anti-HIV + HCV Ab pending, HBsAg pending, TSH normal, syphilis VDRL pending'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 35 ปี G2P1 GA 30 wk underlying cardiac — peripartum cardiomyopathy diagnosed at 30 wk based on symptoms + echo EF 35% + no other cause

V/S: BP 110/70, HR 110, RR 22, SpO2 95% RA
Gen: dyspnea NYHA III, mild edema legs + JVP elevated
Fetal: FHR 150 reactive, growth appropriate
Lab: BNP 1,800, troponin negative
Echo: dilated LV, EF 35%, no valvular, no other cause', '[{"label":"A","text":"No treatment"},{"label":"B","text":"Peripartum Cardiomyopathy (PPCM)"},{"label":"C","text":"Cesarean immediately"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Methotrexate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Peripartum Cardiomyopathy (PPCM)** — heart failure with reduced EF (< 45%) in late pregnancy or up to 5 mo postpartum without other cause; multidisciplinary cardiology + MFM + anesthesia: (1) **diagnosis** — exclude other causes (CAD, valvular, congenital, hypertensive, etc.); echo + biomarkers (BNP); cardiac MRI; (2) **medical therapy — pregnancy-modified heart failure**: (a) **avoid in pregnancy** — ACEI/ARB (teratogenic — switch postpartum), aldosterone antagonists, ARNI; (b) **safe during pregnancy** — **hydralazine + isosorbide dinitrate** (afterload reduction), **β-blocker (metoprolol succinate, bisoprolol, labetalol)** — heart rate + remodeling; (c) **diuretic** (furosemide) for congestion — careful avoiding placental hypoperfusion; (d) **digoxin** for symptoms; (e) **anticoagulation** if EF < 35% (LV thrombus risk) — LMWH; (f) **bromocriptine** — controversial — may improve EF by inhibiting prolactin (German + Brazilian studies); standard care varies; need anticoagulation if given; (3) **arrhythmia management** — β-blocker; cardioversion safe in pregnancy; ICD if criteria; (4) **delivery timing + mode** — multidisciplinary; vaginal delivery preferred (reduce hemodynamic stress) with epidural + assisted 2nd stage (passive descent + operative vaginal if needed); C/S for obstetric indication or severe decompensation; (5) **anesthesia** — epidural preferred (reduces preload + afterload smoothly), avoid spinal (rapid changes); (6) **postpartum** — fluid shifts; risk of decompensation; continue therapy; switch to ACEI/ARB postpartum; (7) **recovery + prognosis** — 50-70% recover EF over 6-12 mo; 20-30% chronic HF; 5-10% mortality; future pregnancy risk recurrence + worsening — counsel re: avoidance especially if EF unrecovered; (8) **breastfeeding** — most cardiac meds compatible; bromocriptine suppresses; (9) **mechanical support** — refractory cases (IABP, ECMO, LVAD, transplant); (10) **screen family** — sometimes genetic dilated CM

---

PPCM: HF reduced EF late pregnancy → 5 mo postpartum. Multidisciplinary cardio-OB. Pregnancy-safe HF meds (hydralazine + nitrate, β-blocker, diuretic, digoxin); avoid ACEI/ARB until postpartum. Anticoagulation if EF < 35%. Bromocriptine controversial. Vaginal delivery + epidural preferred. 50-70% recover. Future pregnancy risk.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'integrative', 'obgyn', 'adult',
  'ESC PPCM Position Statement 2019; AHA Cardiovascular Disease in Pregnancy', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 35 ปี G2P1 GA 30 wk underlying cardiac — peripartum cardiomyopathy diagnosed at 30 wk based on symptoms + echo EF 35% + no other cause

V/S: BP 110/70, HR 110, RR 22, SpO2 95% RA
Gen: dyspnea NYHA III, mild edema legs + JVP elevated
Fetal: FHR 150 reactive, growth appropriate
Lab: BNP 1,800, troponin negative
Echo: dilated LV, EF 35%, no valvular, no other cause'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 30 ปี G1P0 GA 16 wk recent diagnosis breast cancer ER+ PR+ HER2- T2N0 — multidisciplinary discussion of treatment options during pregnancy

V/S: BP 116/72, HR 80
Gen: 3 cm left breast mass, no node
Fetal: heart present, dating correct, anatomy scan planned 20 wk
Lab: routine WNL
Pathology: invasive ductal carcinoma, ER+ PR+ HER2-, Ki-67 30%', '[{"label":"A","text":"Terminate pregnancy"},{"label":"B","text":"Breast cancer in pregnancy"},{"label":"C","text":"Stop all care"},{"label":"D","text":"Cesarean at 16 weeks for treatment"},{"label":"E","text":"Methotrexate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Breast cancer in pregnancy** — second most common malignancy in pregnancy; preserve maternal + fetal outcomes — multidisciplinary (oncology, OB-MFM, breast surgery, radiation onc, neonatology, psychology, genetics): (1) **counseling** — termination not required for treatment; outcomes maternal similar to non-pregnant matched; pregnancy not contraindication to most treatment; (2) **staging** — breast US + mammography (shielded), liver US, CXR shielded; AVOID PET + CT abdomen pelvis where possible (radiation); MRI without gadolinium safe (gadolinium avoid); breast MRI (no gadolinium suboptimal but possible); (3) **surgery** — **safe in pregnancy** — modified radical mastectomy or breast-conserving surgery (BCS); sentinel lymph node biopsy with technetium-99m safe (avoid blue dye — fetal); (4) **chemotherapy** — **avoid 1st trimester** (organogenesis); **2nd-3rd trimester safe** — anthracycline (doxorubicin, epirubicin) + cyclophosphamide + 5-FU (FAC/FEC) or AC regimen; taxanes (paclitaxel) less data but safe 2nd-3rd; (5) **AVOID in pregnancy** — **trastuzumab** (anti-HER2 — oligohydramnios + renal/pulmonary), endocrine therapy **(tamoxifen, AI)** — defer to postpartum; (6) **radiation** — avoid in pregnancy (esp upper abdomen, but breast/chest can be considered with shielding 3rd trimester if essential — usually defer to postpartum); (7) **delivery timing** — aim term (37+) for best neonatal outcomes; stop chemo 3 wk before delivery to allow marrow recovery + reduce neonatal myelosuppression; (8) **breastfeeding** — from treated breast may not be possible; non-treated breast OK during treatment if no chemo; pump + discard during chemo; (9) **postpartum complete treatment** — radiation, endocrine therapy, targeted therapy; (10) **genetic counseling** — BRCA testing — guides surgery + family; (11) **psychological + family support**; (12) Thai context — Royal Thai breast onc + MFM collaboration

---

Breast cancer in pregnancy: surgery safe, chemo 2nd-3rd trimester safe (anthracycline + cyclophosphamide), avoid trastuzumab + tamoxifen + AI until postpartum, radiation defer. Stop chemo 3 wk pre-delivery. Term delivery. Counsel — termination not required. BRCA testing.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'integrative', 'obgyn', 'adult',
  'ESMO Cancer in Pregnancy 2013; NCCN Breast Cancer; Loibl Cancer 2012', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 30 ปี G1P0 GA 16 wk recent diagnosis breast cancer ER+ PR+ HER2- T2N0 — multidisciplinary discussion of treatment options during pregnancy

V/S: BP 116/72, HR 80
Gen: 3 cm left breast mass, no node
Fetal: heart present, dating correct, anatomy scan planned 20 wk
Lab: routine WNL
Pathology: invasive ductal carcinoma, ER+ PR+ HER2-, Ki-67 30%'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 32 ปี มา OPD ปรึกษา recurrent pregnancy loss — 3 consecutive miscarriages all 1st trimester (8, 9, 10 wk), ไม่มี induced abortion, normal cycle

V/S: BP 118/74, HR 80
Gen: well, no thyroid/hirsutism
Pelvic: WNL
Partner: healthy, no consanguinity
No systemic disease', '[{"label":"A","text":"Just keep trying without workup"},{"label":"B","text":"Recurrent Pregnancy Loss (RPL) workup (ASRM/ESHRE: ≥ 2 consecutive pregnancy losses; expand workup ≥ 3)"},{"label":"C","text":"Hysterectomy"},{"label":"D","text":"Antibiotic alone"},{"label":"E","text":"Methotrexate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Recurrent Pregnancy Loss (RPL) workup (ASRM/ESHRE: ≥ 2 consecutive pregnancy losses; expand workup ≥ 3): (1) **genetic** — **parental karyotype** both partners (translocation, inversion, especially balanced reciprocal); offer **POC (products of conception) karyotype** on miscarriage tissue (CMA preferred — copy number variants); (2) **anatomic** — **saline infusion sonography or hysteroscopy** (preferred — direct visualization + treat); **3D US/MRI** alternative; rule out **septate uterus** (most common Müllerian RPL, treatable hysteroscopic resection), polyps, fibroids submucosal, intrauterine adhesions (Asherman), bicornuate; (3) **endocrine** — **TSH** (subclinical hypothyroid + TPO ab+ associated), **prolactin**, **HbA1c** (DM), ovarian reserve (AMH); progesterone less helpful; (4) **antiphospholipid syndrome (APS)** — lupus anticoagulant, anti-cardiolipin IgG/IgM (≥ 40), anti-β2GP1 — 2 occasions 12 wk apart; ≥ 3 consecutive 1st-trimester losses or fetal death > 10 wk OR preeclampsia/preterm < 34 wk; treat with **aspirin + prophylactic LMWH** for future pregnancy; (5) **thrombophilia** — controversial — Factor V Leiden, prothrombin gene, antithrombin/protein C/S not routine unless personal/family VTE history; (6) **immunology + allo-immune** — controversial, IVIG/intralipid not standard; (7) **infection** — TORCH not routine unless suggestive; bacterial vaginosis controversial; (8) **lifestyle + environment** — smoking, alcohol, caffeine, weight (BMI > 35 ↑ risk), occupation; (9) **male factor** — semen DNA fragmentation; (10) **management of next pregnancy** — early dating, β-hCG surveillance, supportive counseling (''tender loving care'' improves outcomes), low-dose aspirin if APS, treat hypothyroid, progesterone supplement (controversial — PROMISE trial mostly negative, may help with bleeding history), close monitoring; (11) **emotional support** — counseling, peer groups; (12) Thai context — RTCOG/Thai Fertility Society

---

RPL workup: parental karyotype + POC genetics, anatomy (hysteroscopy/SIS), endocrine (TSH/prolactin/A1c), APS, lifestyle. APS treat aspirin + LMWH. Septate uterus hysteroscopic resection. Treat hypothyroid. Tender loving care. 50% RPL unexplained.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ASRM RPL Practice Bulletin; ESHRE Recurrent Pregnancy Loss 2017', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 32 ปี มา OPD ปรึกษา recurrent pregnancy loss — 3 consecutive miscarriages all 1st trimester (8, 9, 10 wk), ไม่มี induced abortion, normal cycle

V/S: BP 118/74, HR 80
Gen: well, no thyroid/hirsutism
Pelvic: WNL
Partner: healthy, no consanguinity
No systemic disease'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงตั้งครรภ์ G2P1 GA 24 wk มาด้วยตกขาวมีกลิ่นปลา + ตรวจตกขาว gray homogeneous discharge, vaginal pH 5.0, whiff test + (fishy odor with KOH), clue cells > 20% on wet mount

V/S: BP 116/72, HR 80
Fetal: FHR 144, no contractions
No symptoms otherwise, no STI risk factors', '[{"label":"A","text":"No treatment in pregnancy"},{"label":"B","text":"Bacterial Vaginosis (BV) in pregnancy"},{"label":"C","text":"Antifungal only"},{"label":"D","text":"Discharge — no treatment"},{"label":"E","text":"Methotrexate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Bacterial Vaginosis (BV) in pregnancy** — Amsel criteria (need 3 of 4): (a) thin gray-white discharge, (b) pH > 4.5, (c) positive whiff test (KOH), (d) clue cells > 20%; or Nugent score on Gram stain; (1) **treat symptomatic BV in pregnancy** — associated ↑ preterm birth, PPROM, chorioamnionitis, endometritis, low birth weight — though treatment of asymptomatic BV not shown to reduce preterm birth in low-risk; (2) **regimens (CDC)**: (a) **metronidazole 500 mg PO BID × 7 d** OR (b) **metronidazole 250 mg PO TID × 7 d** OR (c) **clindamycin 300 mg PO BID × 7 d** (alternative); intravaginal preparations (metronidazole gel, clindamycin cream) acceptable for symptomatic — but oral may be preferred in pregnancy for systemic effect to prevent OB complications; (3) **screen + treat** asymptomatic BV in **history of preterm birth** (some guidelines) but recent evidence less supportive of universal screening; (4) **partner treatment** not routinely recommended (BV not classically STI); (5) **alcohol caution** with metronidazole (disulfiram reaction, controversial newer evidence); (6) **follow-up** — repeat exam 1 mo postpartum; recurrence common; (7) **probiotics** — limited evidence; (8) **avoid douching** — disrupts microbiome; (9) **co-infections** — screen Trichomonas, GC/CT, syphilis, HIV; (10) **counseling** — natural history, recurrence, lifestyle; **trichomoniasis** alternative dx — single-dose metronidazole 2 g (or 500 mg BID × 7 d in pregnancy — preferred by some); **candida** — topical azole (clotrimazole/miconazole) safe in pregnancy (oral fluconazole avoid in 1st tri — small cleft palate signal)

---

BV in pregnancy: Amsel criteria. Metronidazole PO 500 mg BID × 7 d. Associated preterm birth. Treat symptomatic. Universal screening asymptomatic controversial. Partner not treated. Trichomoniasis — metronidazole 2 g single dose or 7 d in pregnancy. Candida — topical azole safe.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'CDC STI Treatment Guidelines 2021; ACOG Vaginitis 215', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงตั้งครรภ์ G2P1 GA 24 wk มาด้วยตกขาวมีกลิ่นปลา + ตรวจตกขาว gray homogeneous discharge, vaginal pH 5.0, whiff test + (fishy odor with KOH), clue cells > 20% on wet mount

V/S: BP 116/72, HR 80
Fetal: FHR 144, no contractions
No symptoms otherwise, no STI risk factors'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 32 ปี มาห้องฉุกเฉินด้วยอาการ vulvar mass painful 5 cm + redness + heat + difficulty walking + sitting × 3 d

V/S: BP 122/80, HR 92, Temp 38.1
Gen: appears in pain
Vulva: 5 cm tender fluctuant mass at 5 o''clock at posterior vestibule (Bartholin''s gland location), erythema + warmth + induration
No systemic infection, no STI symptoms', '[{"label":"A","text":"Oral antibiotic only"},{"label":"B","text":"Bartholin Gland Abscess"},{"label":"C","text":"Hysterectomy"},{"label":"D","text":"Discharge home without treatment"},{"label":"E","text":"Methotrexate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Bartholin Gland Abscess** — obstruction of duct → cyst → infection (often polymicrobial — gram-negative, anaerobes, sometimes GC/CT): (1) **diagnosis** — clinical + visualization fluctuant tender vulvar mass at posterior vestibule (4 or 8 o''clock); (2) **management — drainage + marsupialization or Word catheter**: (a) **incision + drainage (I&D)** alone — high recurrence; (b) **Word catheter placement** — preferred outpatient procedure: incise abscess with #11 blade ~ 5 mm vertical inside hymenal ring (not on labium), drain pus, insert Word catheter (small inflatable Foley-like), inflate balloon, leave in place 4-6 wk for epithelialization (creates permanent drainage tract — prevents recurrence); (c) **marsupialization** — alternative surgical: make 1-2 cm incision through skin + cyst wall, suture cyst wall to skin edges with absorbable suture → creates permanent opening; preferred for recurrent cysts; (3) **antibiotics** — **empirical broad-spectrum** if cellulitis, systemic signs, immunocompromised, MRSA-prevalent area, or no improvement after drainage: amoxicillin-clavulanate or TMP-SMX (MRSA coverage); add metronidazole for anaerobic; routine antibiotics with drainage in healthy patient not always needed (controversial); (4) **STI screening** — GC/CT, syphilis, HIV — culture aspirate; (5) **sitz baths** after drainage; (6) **gland excision** — for recurrent disease or suspected cancer; (7) **biopsy/cancer concern** — older woman (> 40) or atypical → consider Bartholin gland adenocarcinoma (rare) — biopsy + refer onc; (8) **follow-up** + remove Word catheter 4-6 wk; (9) **prevention** — none specific; treat sitz bath for cyst before infection

---

Bartholin abscess: Word catheter or marsupialization preferred (lower recurrence than I&D alone). Antibiotics if cellulitis/systemic. STI screen. Older patient or atypical → biopsy r/o cancer. Sitz bath. Recurrent → excision.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin 174: Evaluation + Management of Vulvar Mass', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 32 ปี มาห้องฉุกเฉินด้วยอาการ vulvar mass painful 5 cm + redness + heat + difficulty walking + sitting × 3 d

V/S: BP 122/80, HR 92, Temp 38.1
Gen: appears in pain
Vulva: 5 cm tender fluctuant mass at 5 o''clock at posterior vestibule (Bartholin''s gland location), erythema + warmth + induration
No systemic infection, no STI symptoms'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 28 ปี มา OPD ด้วยอาการประจำเดือนไม่มา 8 mo + hot flashes + night sweats + vaginal dryness + decreased libido + mood lability

V/S: BP 118/74, HR 80
Gen: thin, no galactorrhea
Lab: FSH 65 (3 occasions ≥ 1 mo apart), estradiol 12, β-hCG negative, prolactin normal, TSH normal, karyotype 46XX, autoimmune panel negative, fragile X carrier negative, AMH undetectable', '[{"label":"A","text":"Discharge — early menopause is normal"},{"label":"B","text":"Premature Ovarian Insufficiency (POI)"},{"label":"C","text":"Cesarean delivery"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Premature Ovarian Insufficiency (POI)** — primary ovarian failure < 40 yr (formerly POF); diagnosis: amenorrhea ≥ 4 mo + 2 elevated FSH > 25-40 mIU/mL at least 1 mo apart; spontaneous (idiopathic 80%) or known cause: (1) **etiology workup** — (a) **karyotype** (Turner 45,X; mosaicism; structural X abnormalities), (b) **fragile X premutation (FMR1)** — most common known genetic cause, family history of FXTAS / intellectual disability, (c) **autoimmune** — anti-adrenal/oophoritis (Addison''s risk — STEROID-21-OH Ab), anti-thyroid, type 1 DM, vitiligo, RA, SLE, MG, autoimmune polyglandular syndrome, (d) **iatrogenic** — chemo/radiation/oophorectomy/embolization, (e) **galactosemia, mumps oophoritis** rare, (f) **idiopathic**; (2) **hormone replacement therapy** — **estrogen + progestin (with intact uterus)** until average age of menopause (51) — physiologic replacement, prevents bone loss (osteoporosis), cardiovascular, cognitive, sexual; this is NOT the same as menopausal HRT risk-benefit (younger patients benefit clearly); transdermal estradiol patch + cyclic progestin OR COCP (also acceptable, may be preferred for contraception aspect); (3) **fertility** — spontaneous pregnancy rare (5-10%); **donor egg + IVF** for desired pregnancy; cryopreservation if known cause beforehand; (4) **adrenal insufficiency screen** — esp if autoimmune (cortisol, ACTH-stim); replace if Addison''s; (5) **bone health** — DEXA, Ca/vit D, exercise; HRT prevents loss; (6) **cardiovascular** — lipid, BP, glucose screening; (7) **psychological** — significant emotional impact + identity + sexual + fertility concerns; counseling + peer support; (8) **family screening** — fragile X cascade, autoimmune; (9) **follow-up** — annual + lifestyle + symptoms; (10) Thai context — Thai Menopause Society POI guidelines

---

POI: < 40 yr ovarian failure. Workup karyotype, FMR1, autoimmune. HRT until 51 (physiologic replacement, bone + CV + cognitive). Egg donation for fertility. Bone DEXA. Adrenal screen if AI. Psychological support. Family screen.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ASRM POI 2022; ACOG Practice Bulletin 698', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 28 ปี มา OPD ด้วยอาการประจำเดือนไม่มา 8 mo + hot flashes + night sweats + vaginal dryness + decreased libido + mood lability

V/S: BP 118/74, HR 80
Gen: thin, no galactorrhea
Lab: FSH 65 (3 occasions ≥ 1 mo apart), estradiol 12, β-hCG negative, prolactin normal, TSH normal, karyotype 46XX, autoimmune panel negative, fragile X carrier negative, AMH undetectable'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 16 ปี nulliparous มา OPD ด้วยอาการประจำเดือนไม่เคยมา + short stature + webbed neck + shield chest + cubitus valgus + sexual development Tanner 1 breast + sparse pubic hair

V/S: BP 138/82 (R arm), HR 80, height 145 cm (< 3rd %)
Gen: short stature, webbed neck, low hairline, lymphedema feet history, no goiter
Lab: FSH 80, LH 50, estradiol < 20, TSH normal
Karyotype: 45,XO (Turner syndrome)
Echo: bicuspid aortic valve + mild coarctation
US pelvis: streak ovaries + small uterus', '[{"label":"A","text":"Discharge — normal"},{"label":"B","text":"Turner Syndrome (45,XO and variants) — primary amenorrhea + delayed puberty + somatic features"},{"label":"C","text":"Hysterectomy"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Turner Syndrome (45,XO and variants) — primary amenorrhea + delayed puberty + somatic features** — multidisciplinary lifelong care: (1) **diagnostic** — karyotype (standard 45,X + variants — mosaicism 45,X/46,XX; isochromosome Xq; ring X; Y-containing — risk gonadoblastoma → prophylactic gonadectomy); (2) **growth** — **recombinant human growth hormone (rhGH)** during childhood to maximize adult height (start when below 5th percentile or growth velocity declines); (3) **pubertal induction** — **estrogen replacement** start at age 11-12 (or when puberty would be expected) with low-dose transdermal estradiol → titrate up over 2-3 yr → add progestin once breakthrough bleeding or 2 yr → continue lifelong HRT until average menopause age; preserves bone + uterus + sexual; (4) **fertility** — almost universally infertile; counseling — donor egg + IVF possible; cardiac evaluation pre-pregnancy mandatory (aortic dissection risk!!); (5) **cardiovascular** — bicuspid aortic valve (~ 30%), aortic coarctation (~ 10%), aortic root dilation — **echo + cardiac MRI** baseline + serial monitoring; cardiology lifelong; **pregnancy contraindicated if significant aortic enlargement** (dissection risk 100×); (6) **renal** — horseshoe kidney, duplicate ureters, collecting system — renal US baseline; (7) **endocrine** — autoimmune thyroid, T2DM, dyslipidemia screen; (8) **bone** — DEXA, Ca/vit D; (9) **hearing** — chronic otitis media, sensorineural hearing loss — audiology; (10) **gonadectomy** — if Y-chromosome material → prophylactic gonadectomy for gonadoblastoma prevention; (11) **psychological + cognitive** — verbal IQ usually normal, visuospatial weakness; school support + counseling; (12) **transition adult care** + lifelong follow-up; (13) Thai Turner Syndrome family + endocrine clinic

---

Turner 45,XO: primary amenorrhea, short stature, webbed neck, BAV, coarctation, streak ovaries. Multidisciplinary lifelong. rhGH growth, estrogen pubertal induction, lifelong HRT, cardiac (aortic dissection risk pregnancy!), renal, endocrine, hearing, gonadectomy if Y-material, donor egg fertility.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'Bondy Clinical Practice Guidelines Turner Syndrome 2017; PES Turner Syndrome Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 16 ปี nulliparous มา OPD ด้วยอาการประจำเดือนไม่เคยมา + short stature + webbed neck + shield chest + cubitus valgus + sexual development Tanner 1 breast + sparse pubic hair

V/S: BP 138/82 (R arm), HR 80, height 145 cm (< 3rd %)
Gen: short stature, webbed neck, low hairline, lymphedema feet history, no goiter
Lab: FSH 80, LH 50, estradiol < 20, TSH normal
Karyotype: 45,XO (Turner syndrome)
Echo: bicuspid aortic valve + mild coarctation
US pelvis: streak ovaries + small uterus'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 42 ปี G3P3 มา OPD ด้วยอาการประจำเดือนผิดปกติ — HMB progressively × 2 yr + severe dysmenorrhea + chronic pelvic pain + uterus diffusely enlarged tender on exam

V/S: BP 122/76, HR 80
Pelvic: globular uterus 12 wk size, tender, no adnexal mass
US TV: uterus enlarged + asymmetric thickening of myometrium + ill-defined myometrial cysts + linear striations (heterogeneous) — suggesting **adenomyosis**
MRI: diffuse adenomyosis junctional zone > 12 mm
Endometrial biopsy: benign proliferative', '[{"label":"A","text":"Ignore symptoms"},{"label":"B","text":"Adenomyosis (endometrial glands + stroma within myometrium; classification: diffuse vs focal/adenomyoma; AUB-A in PALM-COEIN; pelvic pain + HMB + enlarged uterus + dysmenorrhea + dyspareunia)"},{"label":"C","text":"Hysterectomy without trial of medical therapy"},{"label":"D","text":"Antibiotic alone"},{"label":"E","text":"Methotrexate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Adenomyosis** (endometrial glands + stroma within myometrium; classification: diffuse vs focal/adenomyoma; AUB-A in PALM-COEIN; pelvic pain + HMB + enlarged uterus + dysmenorrhea + dyspareunia): (1) **diagnosis** — clinical + **US (TV)** — asymmetric myometrial wall, myometrial cysts, linear striations, junctional zone thickening; **MRI** — junctional zone > 12 mm characteristic; definitive = histology (hysterectomy specimen historically); (2) **medical management** — symptom-directed: (a) **NSAIDs** for dysmenorrhea; (b) **LNG-IUD (Mirena)** — significant ↓ HMB + dysmenorrhea — first-line uterus-preserving option; (c) **COCP** continuous or cyclic; (d) **progestin** (dienogest, norethindrone, DMPA); (e) **GnRH agonist** (leuprolide) — temporary improvement; **GnRH antagonist (relugolix combo)** new option; (f) **aromatase inhibitor** (letrozole) adjunct; (g) **danazol** historic; (h) **tranexamic acid** for HMB; (3) **conservative surgical** — **uterine artery embolization** (effective + uterus-preserving), **MRgFUS, HIFU**; **adenomyomectomy** (if focal) — fertility-preserving but technically challenging; (4) **definitive — hysterectomy** — for refractory + completed childbearing; can preserve ovaries; (5) **fertility considerations** — adenomyosis associated with subfertility, miscarriage, preterm birth, preeclampsia; pre-IVF GnRH agonist pretreatment may improve outcomes; (6) **shared decision** — fertility desire, age, severity; (7) **multidisciplinary** for severe cases; (8) **iron supplementation** for anemia

---

Adenomyosis: AUB-A. Diffuse vs focal. US/MRI (junctional zone). LNG-IUD first-line uterus-preserving. UAE, MRgFUS alternatives. Hysterectomy definitive. Subfertility + preterm + preeclampsia association. Fertility considerations.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Committee Opinion 821: Adenomyosis; Bird FIGO Adenomyosis 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 42 ปี G3P3 มา OPD ด้วยอาการประจำเดือนผิดปกติ — HMB progressively × 2 yr + severe dysmenorrhea + chronic pelvic pain + uterus diffusely enlarged tender on exam

V/S: BP 122/76, HR 80
Pelvic: globular uterus 12 wk size, tender, no adnexal mass
US TV: uterus enlarged + asymmetric thickening of myometrium + ill-defined myometrial cysts + linear striations (heterogeneous) — suggesting **adenomyosis**
MRI: diffuse adenomyosis junctional zone > 12 mm
Endometrial biopsy: benign proliferative'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 28 ปี G1P1 postpartum d 14 — breastfeeding มาด้วยอาการ painful red swollen R breast + fever 38.5 + chills

V/S: BP 118/74, HR 102, Temp 38.5
Gen: ill-looking
R breast: erythema + warmth + induration + tender wedge-shaped area, no fluctuance
No abscess on US', '[{"label":"A","text":"Stop breastfeeding R breast"},{"label":"B","text":"Lactational Mastitis (most commonly Staph aureus including MRSA)"},{"label":"C","text":"Hysterectomy"},{"label":"D","text":"Discharge home — no antibiotic"},{"label":"E","text":"Methotrexate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Lactational Mastitis** (most commonly Staph aureus including MRSA): (1) **continue breastfeeding** — frequent emptying critical; affected breast first to ensure complete drainage; baby safe to feed; pump if too painful; (2) **antibiotics** — empirical anti-staph: (a) **dicloxacillin 500 mg PO QID × 10-14 d** or (b) **cephalexin 500 mg PO QID × 10-14 d** first-line; (c) **MRSA suspected/known** → **TMP-SMX, clindamycin 300 mg PO QID** (caution TMP-SMX with newborn < 1 mo old + jaundice/G6PD); (d) penicillin-allergic — clindamycin, erythromycin; (3) **supportive** — warm compresses + frequent feeding/pumping + NSAIDs (ibuprofen safe + reduces inflammation) + acetaminophen + hydration + rest; (4) **rule out abscess** — fluctuance + fever despite 48-72 hr antibiotics + US → drainage; (5) **breast abscess management** — **US-guided needle aspiration** first (may need repeated) + antibiotics; **I&D** if large, multiloculated, failed aspiration; can continue breastfeeding even with abscess (or pump from affected breast); (6) **predisposing** — cracked nipples, milk stasis, poor latch, oversupply, infrequent feeding, weaning abruptly, immunosuppression; (7) **lactation consultant** — latch + position correction; (8) **inflammatory breast cancer differential** — if recurrent, non-resolving, > 6 wk, peau d''orange → biopsy (IBC mimics mastitis); (9) **prevention** — proper latch, complete emptying, gradual weaning, treat early plugged duct; (10) **counseling** — encourage continued breastfeeding, dispel myth that mastitis requires stopping

---

Lactational mastitis: S aureus often. Continue breastfeeding + empty often. Dicloxacillin/cephalexin 10-14 d. MRSA → clinda/TMP-SMX. Rule out abscess (fluctuance + US). Aspirate abscess. NSAIDs. Lactation consultant. Recurrent → IBC rule out. Don''t stop BF.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ABM Protocol 36: Mastitis 2022; ACOG Breastfeeding Toolkit', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 28 ปี G1P1 postpartum d 14 — breastfeeding มาด้วยอาการ painful red swollen R breast + fever 38.5 + chills

V/S: BP 118/74, HR 102, Temp 38.5
Gen: ill-looking
R breast: erythema + warmth + induration + tender wedge-shaped area, no fluctuance
No abscess on US'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 32 ปี G1P1 4 mo postpartum — มาด้วยอาการน้ำหนักลด + heat intolerance + ใจสั่น + tremor × 2 mo, no goiter

V/S: BP 132/82, HR 116, RR 18, Temp 36.9
Gen: tremor, warm skin, no exophthalmos
Lab: TSH < 0.01, FT4 high, T3 high, TPO Ab positive, TRAb negative, RAIU low (1%), Thyroid US: small + mildly hypoechoic + no nodule', '[{"label":"A","text":"Start methimazole"},{"label":"B","text":"Postpartum Thyroiditis (PPT)"},{"label":"C","text":"PTU + methimazole combined"},{"label":"D","text":"Radioactive iodine ablation"},{"label":"E","text":"Hysterectomy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Postpartum Thyroiditis (PPT)** — autoimmune destructive thyroiditis 5-9% of postpartum women within 12 mo postpartum — triphasic pattern (hyperthyroid 1-6 mo → euthyroid → hypothyroid 4-12 mo → permanent in ~ 20-40%); differentiated from **Graves''** by: **low RAIU (PPT)** vs **high RAIU (Graves)**; **TPO Ab+** (PPT); **TRAb negative** (PPT) vs TRAb+ (Graves); (1) **hyperthyroid phase** — usually **mild + transient** — **β-blocker (propranolol 20-40 mg q 6-8 hr)** for symptoms only; **NO antithyroid drugs** (PTU/methimazole) — destructive process, not synthetic excess; (2) **euthyroid intermediate** — observe; (3) **hypothyroid phase** — many transient; **levothyroxine if symptomatic** or planning future pregnancy; recheck off therapy at 6-12 mo; (4) **20-40% develop permanent hypothyroidism** — lifelong levothyroxine; (5) **recurrence** in subsequent pregnancies up to 70% — counsel + screen postpartum; (6) **breastfeeding** — propranolol safe (minimally excreted); levothyroxine safe; methimazole if needed in Graves'' (up to 20 mg/d safe BF); (7) **rule out Graves''** clinically — orbitopathy, large goiter with bruit, TRAb+, high RAIU; Graves'' postpartum needs antithyroid therapy + may impact baby (TRAb crosses placenta); (8) **screening** — TSH at 6 mo postpartum in TPO+ women; pre-conception counseling; (9) **postpartum depression** overlap — thyroid affects mood — screen both; (10) **anemia, weight, fatigue postpartum** — workup thyroid

---

Postpartum thyroiditis: 5-9%. Triphasic pattern. Low RAIU + TPO+ + TRAb- distinguishes from Graves''. Hyper phase: β-blocker only — no antithyroid. Hypo phase: levothyroxine if symptomatic. 20-40% permanent hypothyroid. Recurrence 70%. Breastfeeding safe.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ATA Postpartum Thyroiditis 2017; Endocrine Society Postpartum Thyroid Disease', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 32 ปี G1P1 4 mo postpartum — มาด้วยอาการน้ำหนักลด + heat intolerance + ใจสั่น + tremor × 2 mo, no goiter

V/S: BP 132/82, HR 116, RR 18, Temp 36.9
Gen: tremor, warm skin, no exophthalmos
Lab: TSH < 0.01, FT4 high, T3 high, TPO Ab positive, TRAb negative, RAIU low (1%), Thyroid US: small + mildly hypoechoic + no nodule'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 28 ปี G2P2 postpartum d 21 — depression + suicidal ideation + delusions about baby + insomnia + agitation + mood lability

V/S: BP 122/76, HR 90
Gen: agitated, disoriented to time, paranoid affect; expresses ''baby is evil'' delusional belief; suicidal + thoughts of harming baby
No substance use, no fever, neuro exam non-focal
Lab: TSH normal, glucose normal, electrolytes normal, no infection', '[{"label":"A","text":"Reassurance — postpartum blues"},{"label":"B","text":"psychiatric emergency — immediate hospitalization"},{"label":"C","text":"Discharge home — observation"},{"label":"D","text":"ECT inappropriate"},{"label":"E","text":"Methotrexate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Postpartum Psychosis** (rare 1-2/1,000 births; psychiatric emergency, suicide + infanticide risk); distinguish from **postpartum blues** (50-80%, mild, transient < 2 wk) and **postpartum depression** (10-15%, > 2 wk, no psychosis): (1) **psychiatric emergency — immediate hospitalization** (psychiatric inpatient, separate mother from infant for safety unless mother-baby unit); (2) **safety assessment** — suicidal + infanticidal risk high (4% suicide, 4% infanticide); never leave alone with baby until risk resolved; (3) **medical workup** — rule out organic — infection, electrolyte, thyroid storm, postpartum eclampsia, autoimmune encephalitis (NMDA-R antibodies — newer recognition), drug withdrawal/intoxication, sleep deprivation; (4) **treatment**: (a) **antipsychotic** — second-generation (olanzapine, quetiapine, risperidone) first-line; (b) **mood stabilizer** — lithium (effective for postpartum mania-psychosis; consider breastfeeding — older guidance avoid, newer monitoring acceptable in select), valproate (avoid in childbearing — teratogenic for future pregnancy), lamotrigine; (c) **ECT** — highly effective, safe in postpartum + breastfeeding — consider for refractory or severe; (d) benzodiazepine for agitation/insomnia short-term; (5) **breastfeeding** — depends on medications + infant safety; some compatible (olanzapine, quetiapine, sertraline); pump + discard while on incompatible; (6) **family + partner involvement** — support, education, safety planning, sleep protection; (7) **discharge planning** — close psychiatric follow-up, family supervision, no driving, safety plan, gradual baby contact; (8) **future pregnancy** — very high recurrence (30-50%); prophylactic mood stabilizer (lithium) starting at delivery; (9) **bipolar disorder** often underlying — long-term psychiatric care; (10) **Thai resources** — 1323 mental health hotline, psychiatric emergency

---

Postpartum psychosis: rare, emergency. Psychiatric hospitalization. Suicide + infanticide risk. Antipsychotic + lithium (or ECT). Rule out organic. Distinguish blues (mild < 2 wk) vs depression (> 2 wk) vs psychosis (delusions, hallucinations, disorientation). 30-50% recurrence next pregnancy → prophylaxis lithium.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Committee Opinion 757: Perinatal Mental Health; APA Postpartum Psychosis', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 28 ปี G2P2 postpartum d 21 — depression + suicidal ideation + delusions about baby + insomnia + agitation + mood lability

V/S: BP 122/76, HR 90
Gen: agitated, disoriented to time, paranoid affect; expresses ''baby is evil'' delusional belief; suicidal + thoughts of harming baby
No substance use, no fever, neuro exam non-focal
Lab: TSH normal, glucose normal, electrolytes normal, no infection'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 32 ปี G0P0 trying to conceive 2 yr — diagnosed unexplained infertility, ovarian stimulation with gonadotropins + IVF — มาด้วยอาการ abdominal distention + nausea/vomiting + dyspnea 5 d after egg retrieval

V/S: BP 96/62, HR 110, RR 22, SpO2 95%
Gen: tense ascites + dyspnea
Lab: Hct 50% (hemoconcentration), WBC 16K, Na 132, K 5.2, Cr 1.4 (up from baseline 0.8), AST/ALT mildly elevated, β-hCG 320 (early pregnancy)
US: massively enlarged ovaries 14 cm bilateral + ascites moderate + pleural effusion R', '[{"label":"A","text":"Discharge home + observation"},{"label":"B","text":"Severe Ovarian Hyperstimulation Syndrome (OHSS)"},{"label":"C","text":"Diuretic + ignore"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Severe Ovarian Hyperstimulation Syndrome (OHSS)** — iatrogenic complication of ART (gonadotropins + hCG trigger); hCG → ↑ VEGF → vascular permeability → fluid shift third space → hypovolemia + ascites/effusion + hemoconcentration + electrolyte abnormalities + thrombosis + AKI + ARDS + ovarian torsion; pregnancy → endogenous hCG → worsening: (1) **classification**: mild (ovarian enlargement + abdo discomfort), moderate (US ascites + N/V), **severe (clinical ascites, hemoconcentration Hct > 45%, WBC > 15K, Cr > 1.2, AKI, ARDS, VTE)**, critical (tense ascites, severe AKI/ARDS, severe coag, VTE, hemoconcentration Hct > 55%); (2) **admit + treat**: (a) **IV crystalloid** carefully — avoid overload; albumin/HES (controversial); maintain UOP > 0.5 mL/kg/hr; (b) **paracentesis** for tense ascites + dyspnea — symptomatic relief + improves renal/hemodynamics; (c) **thromboprophylaxis** — **LMWH** (high VTE risk) — continue 6 wk postpartum if pregnancy continues; (d) **electrolyte correction** + monitor renal/hepatic; (e) **avoid pelvic exam** (rupture); (f) avoid pregnancy hCG support if not necessary (in this case pregnancy already established); (g) **dopamine agonist (cabergoline)** preventive at trigger reduces severity; (3) **outpatient management** mild-moderate; admit severe; ICU critical; (4) **complications** — VTE (arterial + venous), pleural effusion + ARDS, AKI, hepatic, hemorrhage from rupture ovarian cyst, torsion; (5) **prevention** in future cycles — antagonist protocol, agonist trigger (vs hCG), cycle cancellation if high risk, embryo freeze + transfer in later cycle, lower starting gonadotropin dose; (6) **counseling** — high-risk pregnancy, multidisciplinary

---

Severe OHSS: iatrogenic ART complication. VEGF-mediated capillary leak. Pregnancy worsens (endogenous hCG). Treatment: IV fluid, paracentesis, LMWH thromboprophylaxis (high VTE!), electrolyte, monitor. Critical → ICU. Prevent: antagonist protocol, agonist trigger, freeze-all, cabergoline.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ASRM/SART OHSS Practice Bulletin; RCOG Green-top 5', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 32 ปี G0P0 trying to conceive 2 yr — diagnosed unexplained infertility, ovarian stimulation with gonadotropins + IVF — มาด้วยอาการ abdominal distention + nausea/vomiting + dyspnea 5 d after egg retrieval

V/S: BP 96/62, HR 110, RR 22, SpO2 95%
Gen: tense ascites + dyspnea
Lab: Hct 50% (hemoconcentration), WBC 16K, Na 132, K 5.2, Cr 1.4 (up from baseline 0.8), AST/ALT mildly elevated, β-hCG 320 (early pregnancy)
US: massively enlarged ovaries 14 cm bilateral + ascites moderate + pleural effusion R'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'คู่สามีภรรยา หญิงอายุ 36 ชาย 38, มี 3 บุตรครบครันถ้วน, มาขอ permanent sterilization counseling — discussing options for husband + wife

V/S: BP 124/76, HR 78
Gen: well, no contraindication
No psychiatric, no coercion, financial situation stable', '[{"label":"A","text":"Refuse sterilization"},{"label":"B","text":"Permanent contraception (sterilization) counseling"},{"label":"C","text":"Force sterilization without consent"},{"label":"D","text":"Hysterectomy as sterilization"},{"label":"E","text":"Methotrexate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Permanent contraception (sterilization) counseling** — informed consent for irreversible procedure: (1) **for the woman — tubal sterilization**: (a) **postpartum (immediately after vaginal or C/S delivery)** — bilateral partial salpingectomy (Pomeroy, Parkland) or **bilateral salpingectomy** (preferred now — also reduces ovarian cancer risk, more effective); (b) **interval (not pregnant)** — **laparoscopic bilateral salpingectomy** preferred (gold standard now per ACOG — replaces clip/ring/coag because of ovarian cancer prevention + lower failure); minimally invasive; (c) **Essure (hysteroscopic)** — discontinued 2018 (high complications); (d) Filshie clip, Falope ring, electrocoagulation — older methods; (2) **for the man — vasectomy** — outpatient, less invasive, more effective, faster recovery, lower complication than female sterilization; needs 2-3 mo + semen analysis to confirm azoospermia; (3) **counseling**: (a) **irreversibility** — emphasize permanent; reversal possible but expensive + variable success; (b) **failure rate** — tubal ~ 5/1,000 lifetime (ectopic if fail!); vasectomy ~ 1/2,000; (c) **regret risk** — younger (< 30) higher regret rate; counsel; (d) **alternatives** — LARC (IUD, implant) — > 99% effective, reversible; (e) **STI protection** — neither protects against STI; (f) **no protection from cancer** — except salpingectomy → ovarian cancer reduction; (4) **legal + cultural** — Thai informed consent for sterilization; shared decision; (5) **timing** — postpartum logistically convenient; interval allows reflection; (6) **alternatives discussion** — LARC if any ambivalence; (7) **costs + insurance coverage**; (8) **future fertility considerations** — IVF if regret; (9) **postoperative care** + return to activity

---

Sterilization counseling: irreversibility, failure rate, regret. Bilateral salpingectomy preferred (ovarian cancer prevention). Vasectomy lower risk than female. LARC equally effective + reversible. Thai informed consent. Shared decision. Younger age higher regret.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Committee Opinion 774: Opportunistic Salpingectomy; SGO Salpingectomy', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'คู่สามีภรรยา หญิงอายุ 36 ชาย 38, มี 3 บุตรครบครันถ้วน, มาขอ permanent sterilization counseling — discussing options for husband + wife

V/S: BP 124/76, HR 78
Gen: well, no contraindication
No psychiatric, no coercion, financial situation stable'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 68 ปี postmenopausal มาด้วยอาการ vulvar pruritus + vulvar lesion 2 cm raised + ulcerated × 3 mo, no STI, no rash systemic

V/S: BP 132/82, HR 78
Gen: well, weight stable
Vulva: 2 cm raised ulcerated lesion on R labium majora + groin lymph node mildly palpable R
Biopsy: invasive squamous cell carcinoma (SCC), HPV-related on p16+', '[{"label":"A","text":"Observation"},{"label":"B","text":"Vulvar cancer (rare, mostly SCC; subtypes: HPV-related (younger, multifocal) vs non-HPV (lichen sclerosus-related, older); FIGO 2009/2021 staging)"},{"label":"C","text":"Discharge — observation"},{"label":"D","text":"Antibiotic alone"},{"label":"E","text":"Methotrexate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Vulvar cancer** (rare, mostly SCC; subtypes: HPV-related (younger, multifocal) vs non-HPV (lichen sclerosus-related, older); FIGO 2009/2021 staging): (1) **diagnosis** — biopsy of all suspicious vulvar lesions (don''t excise without biopsy first); (2) **staging workup** — exam, vulvar mapping, inguinal node assessment (clinical + US ± FNA), pelvic exam, MRI pelvis/groin, CT chest/abdo/pelvis for advanced; (3) **treatment by stage**: (a) **early (Stage IA — tumor ≤ 2 cm + invasion ≤ 1 mm)** — wide local excision (1 cm margin); no LN dissection (very low risk); (b) **Stage IB-II (> 1 mm invasion or > 2 cm)** — **radical local excision + inguinofemoral lymphadenectomy** (unilateral if tumor lateralized, bilateral if midline within 1 cm or B/L); **sentinel lymph node biopsy** acceptable for tumor < 4 cm + clinically node-negative (GROINSS-V trial); (c) **Stage III-IVA** — multimodal — preop chemoradiation (cisplatin) → less radical surgery; or radical surgery + adjuvant CRT; (d) **Stage IVB** — palliative chemo (cisplatin + paclitaxel) + RT; (4) **adjuvant** — RT if positive margin, LVSI, deep invasion, LN+; (5) **vulvar reconstruction** + multidisciplinary; (6) **HPV vaccination** — primary prevention; (7) **screening + prevention** — treat VIN (vulvar intraepithelial neoplasia), lichen sclerosus monitoring; (8) **follow-up** — exam + lymph node q 3-6 mo × 2 yr, then q 6 mo × 3 yr; (9) **prognosis** — stage-dependent: I 5-yr > 90%, II 80%, III 50-60%, IV 15-30%; nodal involvement major prognostic factor; (10) **counseling** — body image + sexual function + lymphedema + supportive

---

Vulvar cancer: SCC most. Biopsy first. Wide local excision + sentinel/inguinofemoral LN. CRT for advanced. GROINSS-V SLN if < 4 cm + cN0. HPV-related vs non-HPV (lichen sclerosus). Vaccination + VIN treatment prevention. Multidisciplinary + supportive.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'FIGO Vulvar Cancer Staging 2021; NCCN Vulvar Cancer', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 68 ปี postmenopausal มาด้วยอาการ vulvar pruritus + vulvar lesion 2 cm raised + ulcerated × 3 mo, no STI, no rash systemic

V/S: BP 132/82, HR 78
Gen: well, weight stable
Vulva: 2 cm raised ulcerated lesion on R labium majora + groin lymph node mildly palpable R
Biopsy: invasive squamous cell carcinoma (SCC), HPV-related on p16+'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 30 ปี G1P0 mole evacuation 4 mo ago — β-hCG plateau 3,500 × 4 weeks then increased to 4,800, CXR: bilateral pulmonary nodules 1-2 cm, no neurological symptoms

V/S: BP 122/76, HR 88
Gen: well
Lab: β-hCG 4,800, CBC normal, LFT normal, Cr 0.7, CXR: nodules, MRI brain: no metastasis, US pelvis: small uterine echogenic lesions', '[{"label":"A","text":"Observation"},{"label":"B","text":"Gestational Trophoblastic Neoplasia (GTN) — post-molar"},{"label":"C","text":"Hysterectomy without chemotherapy"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Methotrexate × 1 dose without follow-up"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Gestational Trophoblastic Neoplasia (GTN) — post-molar** — diagnosis (FIGO 2000): (a) plateau hCG × 4 wk, (b) rise hCG × 3 wk, (c) hCG > 6 mo persistent post-evacuation, (d) histology choriocarcinoma; FIGO **stage** I (uterus), II (genital outside uterus), III (lung metastasis), IV (other distant); **WHO/FIGO prognostic score** 0-25+: low risk ≤ 6, high risk ≥ 7 (age, antecedent pregnancy, time interval, pretreatment hCG, tumor size, metastasis location/number, prior failed chemo); (1) **workup** — exam, β-hCG quantitative, CBC/CMP/LFT/Cr/TFT, CXR (lung most common metastasis), CT chest, MRI brain + abdo/pelvis if metastatic, US pelvis; (2) **low-risk GTN (stage I-III + score ≤ 6)** — **single-agent chemotherapy**: (a) **methotrexate** 50 mg/m² IM weekly OR 1 mg/kg IM days 1,3,5,7 + leucovorin rescue days 2,4,6,8 q 2 wk; (b) **actinomycin D** alternative or salvage; ~ 80-90% cure single-agent first-line, salvage second-line; (3) **high-risk GTN (score ≥ 7, stage IV)** — **multi-agent chemotherapy — EMA-CO** (etoposide, methotrexate, actinomycin D, cyclophosphamide, vincristine); EMA-EP for resistant (paclitaxel-platinum); 80-90% cure; (4) **surgery** — hysterectomy for chemo-resistant disease in completed-family women; metastectomy for resistant; (5) **brain metastasis** — high-dose MTX + WBRT + craniotomy (selective); (6) **β-hCG monitoring during/after treatment** — weekly until 3 consecutive negative → monthly × 12 mo; effective contraception throughout; (7) **fertility** — preserved in most after chemo; future pregnancies → early US (recurrence risk ~ 1-2%); (8) **placental site trophoblastic tumor (PSTT)** + epithelioid TT — less chemo-sensitive, surgical management primarily; (9) **referral to GTN center** — Thai network

---

Post-molar GTN: plateau/rise hCG/persistent or choriocarcinoma. FIGO staging + WHO score. Low-risk: MTX or Act-D single-agent. High-risk: EMA-CO. Surveillance β-hCG weekly → monthly × 12 mo. Contraception. Highly chemo-sensitive — > 90% cure. Refer GTN center.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'FIGO Cancer Report GTD 2021; Charing Cross GTN Algorithm; RCOG Green-top 38', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 30 ปี G1P0 mole evacuation 4 mo ago — β-hCG plateau 3,500 × 4 weeks then increased to 4,800, CXR: bilateral pulmonary nodules 1-2 cm, no neurological symptoms

V/S: BP 122/76, HR 88
Gen: well
Lab: β-hCG 4,800, CBC normal, LFT normal, Cr 0.7, CXR: nodules, MRI brain: no metastasis, US pelvis: small uterine echogenic lesions'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 30 ปี G1P0 GA 41 wk Bishop score 3 (closed, posterior, 1 cm long, soft, station -3), AFI 8, fetus well, no contraindication to vaginal delivery, no contractions, no ROM

V/S: BP 118/72, HR 86
Fetal: FHR 144, EFW 3,400 g vertex
No prior C/S, no malpresentation, no obstetric indication for C/S', '[{"label":"A","text":"Cesarean immediately"},{"label":"B","text":"Induction of labor (IOL) with unfavorable cervix Bishop ≤ 6 → cervical ripening"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Antibiotic only"},{"label":"E","text":"Methotrexate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Induction of labor (IOL) with unfavorable cervix Bishop ≤ 6 → cervical ripening** then oxytocin: (1) **mechanical methods** — **transcervical Foley balloon catheter (30-60 mL)** — placed via cervix + inflated; safe, effective, no hyperstimulation risk; outpatient possible; alternative Cook double balloon; combine with oxytocin or misoprostol (FOMO trial — combined faster); (2) **pharmacologic methods** — (a) **prostaglandin E2 (PGE2 dinoprostone)** — vaginal insert (Cervidil 10 mg slow-release × 12 hr) or vaginal gel (Prepidil 0.5 mg q 6 hr × 3 doses); avoid in TOLAC (uterine rupture); (b) **prostaglandin E1 (misoprostol PGE1)** — vaginal 25 mcg q 3-6 hr or oral 25-50 mcg q 2-6 hr — cheaper, effective; AVOID in TOLAC (high rupture risk); start oxytocin at least 4 hr after last dose; (3) **after cervix favorable Bishop > 6** → **oxytocin** infusion start 1-2 mU/min, increase 1-2 mU q 15-30 min, max 30-40 mU/min, titrate to 3-5 strong contractions / 10 min + cervical change; (4) **amniotomy (ARM)** — once cervix favorable + station appropriate; combined with oxytocin shortens labor; (5) **monitoring** — continuous fetal monitoring during IOL; assess contraction pattern, FHR, Bishop progression; (6) **failed IOL** — definitions vary but generally: 24 hr latent failure or 12 hr active + ROM + adequate contractions without progress; consider repeat ripening or C/S based on clinical; (7) **risks** — hyperstimulation (tachysystole > 5 contractions/10 min) + FHR abnormality, uterine rupture (esp prior C/S + PG), longer hospital, infection; (8) **contraindications IOL** — placenta previa, vasa previa, cord prolapse, classical C/S, prior rupture, prior reconstructive surgery, malpresentation, fetal distress; (9) **ARRIVE trial** supports IOL at 39 wk low-risk nullip — does not ↑ C/S

---

IOL unfavorable cervix: ripening (Foley balloon, PGE2, PGE1 miso) → oxytocin + ARM. Continuous monitoring. Failed IOL definitions. ARRIVE supports 39-wk IOL low-risk nullip. Contraindications. Avoid PG in TOLAC. Tachysystole risk.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin 107: Induction of Labor; ARRIVE Trial NEJM 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 30 ปี G1P0 GA 41 wk Bishop score 3 (closed, posterior, 1 cm long, soft, station -3), AFI 8, fetus well, no contraindication to vaginal delivery, no contractions, no ROM

V/S: BP 118/72, HR 86
Fetal: FHR 144, EFW 3,400 g vertex
No prior C/S, no malpresentation, no obstetric indication for C/S'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 22 ปี G0P0 มา OPD ด้วยประจำเดือนผิดปกติ — irregular cycles 35-60 d × 2 yr + occasional HMB + no other concerning features, BMI 22, no acne/hirsutism, no galactorrhea

V/S: BP 116/72, HR 76
Gen: well
Lab: β-hCG negative, TSH normal, prolactin normal, FSH 6, LH 5, androgens normal, AMH 3.5 normal, US: normal
Endometrial biopsy: secretory pattern in luteal phase (ovulation occurred but irregular)', '[{"label":"A","text":"Hysterectomy"},{"label":"B","text":"Anovulatory AUB (AUB-O) — adolescent/young adult"},{"label":"C","text":"Antibiotic only"},{"label":"D","text":"Wait without workup"},{"label":"E","text":"Methotrexate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Anovulatory AUB (AUB-O) — adolescent/young adult**: PALM-COEIN non-structural cause **O = ovulatory dysfunction**; most common AUB in adolescents (immature HPO axis) + perimenopausal; (1) **etiology** — physiologic immature HPO axis (adolescent first 2-3 yr post-menarche), PCOS, hypothalamic dysfunction (stress, exercise, weight), hyperprolactinemia, thyroid (hyper/hypo), early menopause, eating disorders, chronic disease; (2) **workup** — exclude pregnancy (β-hCG), pelvic exam, TSH, prolactin, FSH/LH/E2, total/free testosterone if hirsutism, US, CBC for anemia, coagulopathy in HMB esp adolescent (vWD 13%); (3) **management** — (a) **cycle regulation + prevent endometrial overgrowth** — **cyclic progestin** (medroxyprogesterone 5-10 mg × 10-14 d/mo) or **COCP** (continuous or cyclic — also contraception); (b) **LNG-IUD** for HMB + contraception; (c) **acute HMB** — high-dose estrogen (Premarin 25 mg IV q 4 hr × 24 hr) or high-dose progestin (megestrol 80 mg BID, MPA 20 mg TID), tranexamic acid; (d) **mild** — observation if young + stable + no anemia; (e) **PCOS** management (lifestyle, metformin if indicated); (f) **iron** if anemia; (4) **endometrial sampling** — AUB-O in **women < 45 yr generally not needed** unless persistent (1+ yr unopposed estrogen) or risk factors (obesity, DM, tamoxifen, Lynch); > 45 yr → endometrial biopsy; (5) **counseling** — natural history (immature HPO → resolves over 1-2 yr), avoid endometrial cancer risk by ensuring cyclic shedding; (6) **fertility** — when desired, induce ovulation; (7) **reassurance** for adolescent + parent

---

AUB-O: most common AUB adolescent + perimenopause. PCOS common. Workup: β-hCG, TSH, prolactin, FSH/LH, androgens, US, coag (vWD adolescent). Management: cyclic progestin or COCP. LNG-IUD. Acute HMB: estrogen or progestin. Sampling > 45 or risk factors. Reassurance adolescent immature HPO.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin 136: AUB; FIGO PALM-COEIN', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 22 ปี G0P0 มา OPD ด้วยประจำเดือนผิดปกติ — irregular cycles 35-60 d × 2 yr + occasional HMB + no other concerning features, BMI 22, no acne/hirsutism, no galactorrhea

V/S: BP 116/72, HR 76
Gen: well
Lab: β-hCG negative, TSH normal, prolactin normal, FSH 6, LH 5, androgens normal, AMH 3.5 normal, US: normal
Endometrial biopsy: secretory pattern in luteal phase (ovulation occurred but irregular)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงตั้งครรภ์ G1P0 GA 39+5 wk on IOL 14 hr — cervix progression latent phase 1 cm → 3 cm over 6 hr → 4 cm at 12 hr → 4 cm at 14 hr (no progression × 4 hr despite adequate contractions q 2-3 min, ROM present 8 hr ago), no signs of infection

V/S: BP 122/76, HR 96, Temp 37.0
Fetal: FHR 144 reactive, station -1, OA
No malpresentation, no obstetric indication for C/S yet', '[{"label":"A","text":"Cesarean immediately"},{"label":"B","text":"Slow latent phase / prolonged labor"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Antibiotic only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Slow latent phase / prolonged labor** — Zhang labor curves: active phase = 6 cm, before 6 cm slower; criteria for arrest disorders apply only after 6 cm: (1) **assessment** — confirm contractions adequate (IUPC > 200 MVU/10 min ideal), cervix progress, fetal position, station, suspected CPD; (2) **at 4 cm in IOL with ROM + adequate contractions × 4 hr — not yet arrest by ACOG/SMFM Safe Prevention of Primary C-Section** — active labor starts at 6 cm; allow more time before C/S diagnosis; (3) **continue IOL** — optimize: (a) titrate **oxytocin** to adequate contractions (3-5 in 10 min, > 200 MVU IUPC); (b) **amniotomy** already done; (c) reposition (left lateral, ambulation, peanut ball, position changes); (d) hydration; (e) analgesia (epidural may relax pelvic floor); (4) **continuous fetal monitoring**; (5) **arrest of dilation criteria (ACOG/SMFM)** — **6 cm or more + no cervical change × 4 hr adequate contractions OR 6 hr inadequate contractions** → primary C/S indicated; (6) **failed IOL definitions** — failure to reach active labor after 24 hr ripening + ROM + 12-18 hr oxytocin; (7) **arrest of descent** — fully dilated + push 3-4 hr nullip with epidural (4 multip with epi) before C/S; consider operative vaginal if criteria met; (8) **infection** monitoring — chorioamnionitis with prolonged ROM; (9) **document labor progression + interventions**; (10) **counseling patient** + family about plan

---

Labor arrest definitions per Zhang curves + ACOG/SMFM Safe Prevention. Active labor 6 cm. Arrest dilation at 6+ cm × 4 hr (adequate) or 6 hr (inadequate). Latent phase prolonged ≠ arrest. Failed IOL after adequate trial. Optimize contractions, position, ROM, analgesia. Operative vaginal vs C/S decision.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG/SMFM Care Consensus 1: Safe Prevention of Primary C-Section 2014', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงตั้งครรภ์ G1P0 GA 39+5 wk on IOL 14 hr — cervix progression latent phase 1 cm → 3 cm over 6 hr → 4 cm at 12 hr → 4 cm at 14 hr (no progression × 4 hr despite adequate contractions q 2-3 min, ROM present 8 hr ago), no signs of infection

V/S: BP 122/76, HR 96, Temp 37.0
Fetal: FHR 144 reactive, station -1, OA
No malpresentation, no obstetric indication for C/S yet'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 55 ปี postmenopausal × 3 yr มาด้วยอาการ dyspareunia + vaginal dryness + decreased libido + decreased lubrication + orgasm difficulty × 6 mo, partner supportive, relationship stable

V/S: BP 122/74, HR 78
Gen: well, no chronic disease
Pelvic: atrophic vagina + pale mucosa + thin epithelium + decreased rugation + reduced lubrication
No bleeding, no mass
No depression, no anxiety, no SSRI use', '[{"label":"A","text":"Refuse — old people don''t have sex"},{"label":"B","text":"Female Sexual Dysfunction + Genitourinary Syndrome of Menopause (GSM)"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Refuse — old people don''t have sex"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Female Sexual Dysfunction + Genitourinary Syndrome of Menopause (GSM)** — multifactorial — biopsychosocial approach: (1) **assess** — type (desire/arousal/orgasm/pain), duration, partner factors, stress, mood, libido medications, chronic disease, relationship; PISQ-12 or FSFI for QoL; (2) **GSM (atrophic vaginitis + urinary symptoms)** — first-line management: (a) **vaginal lubricants** (silicone, water-based) — coital; (b) **vaginal moisturizers** (Replens, hyaluronic acid) — regular non-coital use; (c) **vaginal estrogen** (cream, ring, tablet) — most effective for atrophy + dryness; **safe even with breast cancer hx after MDT discussion**; minimal systemic absorption; no need progestin; (d) **DHEA vaginal (prasterone)** — alternative; (e) **ospemifene** SERM oral; (f) **vaginal CO2/Er:YAG laser** — controversial — FDA warning unproven for GSM; (3) **MHT** — systemic HT for vasomotor + GSM + bone (if not contraindicated); (4) **desire/arousal** — flibanserin (premenopausal HSDD), bremelanotide (premenopausal HSDD), testosterone (off-label, low-dose, monitor); (5) **psychosocial** — couple''s therapy, sex therapy (CBT, mindfulness, sensate focus), education, communication; (6) **address contributing factors** — depression (SSRI may ↓ libido — consider bupropion/mirtazapine alternative), chronic disease (DM, thyroid, CV), medications, alcohol, sleep, stress; (7) **pelvic floor PT** — for pain (vaginismus, vulvodynia); (8) **partner factors** — partner ED, communication; (9) **normalize discussion** — sexuality healthy lifelong; respectful inclusive approach (LGBTQ+, single, divorced); (10) **counseling**

---

Female sexual dysfunction + GSM: biopsychosocial. Vaginal estrogen first-line GSM (safe even breast cancer). Lubricants + moisturizers. MHT systemic. Desire: flibanserin, bremelanotide, testosterone off-label. Address mood, meds, relationship. Sex therapy. Normalize discussion lifelong.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'NAMS GSM Position Statement 2020; ACOG Practice Bulletin 213: Female Sexual Dysfunction', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 55 ปี postmenopausal × 3 yr มาด้วยอาการ dyspareunia + vaginal dryness + decreased libido + decreased lubrication + orgasm difficulty × 6 mo, partner supportive, relationship stable

V/S: BP 122/74, HR 78
Gen: well, no chronic disease
Pelvic: atrophic vagina + pale mucosa + thin epithelium + decreased rugation + reduced lubrication
No bleeding, no mass
No depression, no anxiety, no SSRI use'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงตั้งครรภ์ G2P1 GA 11 wk advanced maternal age 38 + prior child with chromosome translocation — counseled CVS for prenatal diagnosis

V/S: BP 116/74, HR 80
Gen: well
Fetal: heart 158, CRL appropriate, NT not done yet
Lab: blood group A Rh+, normal CBC, no anticoag', '[{"label":"A","text":"Refuse counseling"},{"label":"B","text":"Chorionic Villus Sampling (CVS) counseling"},{"label":"C","text":"Discharge home — no need for screening"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Chorionic Villus Sampling (CVS) counseling** — invasive prenatal diagnostic procedure: (1) **indications** — advanced maternal age, prior chromosomal abnormality, parental balanced translocation, positive screening (NIPT/combined), abnormal US finding, single gene disorders, biochemical disorders, paternity testing; (2) **timing** — 10-13+6 wk (earlier than amniocentesis); (3) **technique** — transabdominal (preferred) or transcervical, US-guided needle to chorionic villi, aspirate 10-25 mg; (4) **testing** — karyotype, FISH (rapid 24-72 hr), **chromosomal microarray (CMA)** preferred (copy number variants), single gene testing, biochemical; (5) **counseling — risks + benefits**: (a) **procedure-related loss** ~ 0.2% (~ 1/500); operator experience-dependent; (b) **bleeding, ROM, infection, FMH** rare; (c) **mosaicism** — placental vs fetal — may require amniocentesis confirmation; (d) **vertical transmission of HIV/HBV/HCV** — risk-benefit, antiretroviral coverage; (e) **maternal isoimmunization** — Anti-D Ig if Rh-negative; (f) **earlier vs amniocentesis** — earlier results allow earlier reproductive decisions, but slightly higher procedure loss; (6) **alternatives** — NIPT (screening only, > 99% T21 detection, lower invasive procedure rate downstream), amniocentesis at 15+ wk (lower loss 0.1%), no testing; (7) **post-CVS care** — rest, watch for bleeding/leaking/cramping/fever, follow-up; (8) **results discussion** — preparation for normal vs abnormal results + reproductive options (continue, prepare, termination — legal in Thailand for fetal genetic disorders per Medical Council); (9) **multidisciplinary** — genetics + MFM + emotional support; (10) **informed consent** documented

---

CVS: 10-13+6 wk, transabdominal preferred. Indications AMA, prior abnormality, screening positive, parental translocation. Karyotype + CMA + FISH. Risks: ~ 0.2% loss, mosaicism. Anti-D if Rh-neg. Alternatives NIPT, amnio. Multidisciplinary + informed consent. Reproductive options including termination legal in Thailand.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin 162: Prenatal Diagnostic Testing; SMFM Statement', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงตั้งครรภ์ G2P1 GA 11 wk advanced maternal age 38 + prior child with chromosome translocation — counseled CVS for prenatal diagnosis

V/S: BP 116/74, HR 80
Gen: well
Fetal: heart 158, CRL appropriate, NT not done yet
Lab: blood group A Rh+, normal CBC, no anticoag'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามอาจารย์เรื่อง genetics — Mendelian inheritance + X-linked + mitochondrial + imprinting + microdeletion', '[{"label":"A","text":"Mendelian = only autosomal recessive"},{"label":"B","text":"Inheritance patterns — important for genetic counseling"},{"label":"C","text":"X-linked recessive — only females affected"},{"label":"D","text":"Mitochondrial paternally inherited"},{"label":"E","text":"Imprinting — same expression both parents"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Inheritance patterns** — important for genetic counseling: (1) **autosomal dominant (AD)** — affected parent → 50% offspring affected (vertical transmission); variable expressivity, incomplete penetrance, anticipation; examples: Marfan, NF1, achondroplasia, Huntington''s, BRCA1/2, Lynch syndrome; (2) **autosomal recessive (AR)** — both carriers (heterozygous) → 25% affected (homozygous), 50% carriers, 25% unaffected; horizontal transmission (siblings); examples: cystic fibrosis, thalassemia, sickle cell, SMA, PKU, Tay-Sachs; consanguinity ↑ risk; (3) **X-linked recessive** — males affected, females carriers; no father-to-son transmission; obligate carrier daughters of affected father; examples: hemophilia A/B, DMD, color blindness, fragile X (males more severely affected), G6PD; (4) **X-linked dominant** — affected females + males; lethal in males some; examples: Rett, vitamin D-resistant rickets, incontinentia pigmenti, fragile X (some); (5) **Y-linked** — father to all sons; rare; (6) **mitochondrial inheritance** — maternal transmission (mitochondria from egg cytoplasm); heteroplasmy → variable expression; examples: MELAS, MERRF, Leber optic neuropathy, mitochondrial myopathy; (7) **imprinting** — parent-of-origin specific expression; **Prader-Willi (paternal 15q11-13 deletion or maternal UPD)** vs **Angelman (maternal del or paternal UPD)** — same locus, different parent; **Beckwith-Wiedemann (11p15)**; UPD = uniparental disomy; (8) **microdeletion syndromes** — sub-microscopic deletions detected by FISH/CMA: **22q11.2 (DiGeorge — cardiac, parathyroid, thymus, palate)**, Williams (7q11), Cri-du-chat (5p-), Smith-Magenis, Miller-Dieker, NF1, WAGR; (9) **CMA (chromosomal microarray)** detects CNV (copy number variants — sub-microscopic) → preferred over karyotype for unexplained intellectual disability/multiple congenital anomalies/AUC; (10) **whole exome sequencing (WES)** — single gene + de novo; (11) **multifactorial/polygenic** — NTD, cardiac defects, cleft lip/palate; recurrence based on empiric data + ethnicity; (12) **genetic counseling** — pedigree, risk assessment, education, reproductive options

---

Inheritance patterns: AD, AR, X-linked rec/dom, Y, mitochondrial (maternal), imprinting (Prader-Willi vs Angelman), microdeletion (22q11.2 DiGeorge). CMA detects CNV preferred over karyotype for unexplained syndromes. WES single gene. Multifactorial empiric. Genetic counseling.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'basic_science', 'obgyn', 'adult',
  'Thompson & Thompson Genetics in Medicine 8e; ACOG Genetic Counseling', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Resident ถามอาจารย์เรื่อง genetics — Mendelian inheritance + X-linked + mitochondrial + imprinting + microdeletion'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามอาจารย์เรื่อง antimicrobials in pregnancy + safety profile', '[{"label":"A","text":"All antibiotics safe in pregnancy"},{"label":"B","text":"Antimicrobial safety in pregnancy"},{"label":"C","text":"Doxycycline safe throughout"},{"label":"D","text":"Fluoroquinolone preferred"},{"label":"E","text":"TMP-SMX safe 1st trimester"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Antimicrobial safety in pregnancy: (1) **β-lactams** — **safest class** in pregnancy + lactation; penicillins, cephalosporins, carbapenems; treatment of choice for many infections — UTI, GBS, syphilis, chorioamnionitis, endometritis; (2) **macrolides** — **azithromycin** (preferred — best safety; cesarean adjunctive prophylaxis per Tita), erythromycin (estolate ester ↑ cholestatic hepatitis — avoid); clarithromycin avoided 1st trimester (animal teratogenicity); (3) **clindamycin** — safe; useful for endometritis, GBS allergy, anaerobic; (4) **metronidazole** — safe (older 1st trimester caution disproven); BV, trichomoniasis, anaerobic, C diff; alcohol caution disulfiram; (5) **nitrofurantoin** — safe in pregnancy except **avoid at term (36+ wk) + risk neonatal hemolysis G6PD**; UTI/asymptomatic bacteriuria; (6) **TMP-SMX** — **avoid 1st trimester** (folate antagonist — NTD) + **avoid near term** (kernicterus); 2nd trimester ok if indicated (PCP prophylaxis HIV); (7) **fluoroquinolones (cipro, levofloxacin)** — avoid (animal cartilage toxicity, limited human data); use only if no alternative; (8) **tetracyclines (doxycycline)** — **avoid after 14 wk** (teeth staining + bone); short course 1st trimester ok (no fetal calcification yet); (9) **aminoglycosides (gentamicin)** — fetal nephrotoxicity + ototoxicity (streptomycin highest risk) — use when benefit > risk (chorioamnionitis); single daily dosing + therapeutic monitoring; (10) **vancomycin** — safe; GBS allergic + MRSA; (11) **antifungals** — topical azole (clotrimazole, miconazole) safe; **avoid oral fluconazole 1st trimester** (small ↑ cleft palate); amphotericin B safe for systemic; (12) **antiparasitic** — chloroquine + mefloquine safe (malaria prophylaxis/treatment); avoid primaquine + artemisinin 1st trimester; **albendazole/mebendazole** avoid 1st trimester (deworming postpone); (13) **antivirals** — acyclovir/valacyclovir safe (HSV); tenofovir/3TC HIV; oseltamivir flu; remdesivir COVID; (14) **antimycobacterial** — INH, rifampin, ethambutol, pyrazinamide safe (TB); add B6 with INH; streptomycin avoid; (15) **lactation safety** — most safe — LactMed; doxycycline limited use, fluoroquinolones use cautiously

---

Antimicrobials in pregnancy: β-lactams safest. Azithromycin > erythromycin. Clinda + metro safe. Nitrofurantoin avoid at term. TMP-SMX avoid 1st + last trimester. Fluoroquinolone avoid. Doxy avoid > 14 wk. Aminoglycoside risk-benefit. Topical azole safe; oral fluconazole avoid 1st tri. Acyclovir safe. TB drugs safe except streptomycin.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'basic_science', 'obgyn', 'adult',
  'Briggs Drugs in Pregnancy 12e; CDC STI Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Resident ถามอาจารย์เรื่อง antimicrobials in pregnancy + safety profile'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามอาจารย์เรื่อง pelvic floor anatomy + childbirth-related injury', '[{"label":"A","text":"Pelvic floor = only skin"},{"label":"B","text":"Pelvic floor anatomy + childbirth injury"},{"label":"C","text":"Levator ani innervated by sciatic"},{"label":"D","text":"DeLancey level I = distal vagina"},{"label":"E","text":"Perineal body irrelevant"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pelvic floor anatomy + childbirth injury: (1) **pelvic floor (urogenital + pelvic diaphragm)**: (a) **levator ani** (innervation S3-S5) — **pubococcygeus, puborectalis, iliococcygeus** — sling support of pelvic organs; (b) **coccygeus** — completes pelvic diaphragm; (c) **deep perineal pouch** — urogenital diaphragm (deep transverse perineal, sphincter urethrae); (d) **superficial perineal** — bulbospongiosus, ischiocavernosus, superficial transverse perineal; (e) **perineal body** — fibromuscular pyramid where multiple muscles converge (key support); (f) **endopelvic fascia** — supports bladder, urethra, rectum, uterus (cardinal, uterosacral, pubourethral ligaments); (2) **DeLancey levels of support**: (a) **Level I** — apical (cardinal + uterosacral) → upper vagina + cervix; failure = uterine/vault prolapse; (b) **Level II** — lateral attachment (paravaginal to arcus tendineus fasciae pelvis ATFP) → midvagina; failure = anterior (cystocele) + posterior (rectocele) compartment; (c) **Level III** — distal (urogenital diaphragm + perineal body) → distal vagina; failure = SUI + perineal descent; (3) **anal sphincter complex** — internal anal sphincter (smooth muscle, autonomic) + external anal sphincter (skeletal, pudendal nerve); (4) **innervation** — pudendal nerve (S2-S4) — main somatic supply pelvic floor + external genitalia; autonomic for bladder/bowel/sexual; (5) **childbirth injury** — pudendal nerve stretch + compression (anal incontinence, urinary incontinence); levator ani avulsion from pubic bone (anterior/posterior prolapse, SUI); perineal lacerations (1st-4th degree); episiotomy controversial (routine not recommended; selective); OASIS (3-4° tears); (6) **risk factors childbirth injury** — operative vaginal (especially forceps), macrosomia, prolonged 2nd stage, midline episiotomy, OP position, Asian ethnicity (smaller introitus); (7) **prevention** — perineal massage antepartum, warm compress 2nd stage, controlled delivery of head, evidence for restrictive episiotomy; (8) **postpartum recovery** — PFPT helps; recovery 3-6 mo; (9) **clinical relevance** — POP, SUI, fecal incontinence, dyspareunia; (10) **imaging** — 3D/4D US, MRI

---

Pelvic floor: levator ani (S3-S5), perineal body. DeLancey 3 levels — I apical (USL/cardinal — vault prolapse), II lateral (ATFP — cystocele/rectocele), III distal (UGD + perineal — SUI). Pudendal S2-S4. Childbirth injury: levator avulsion + pudendal stretch + OASIS. Prevention: warm compress, restrictive episiotomy. PFPT recovery.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'basic_science', 'obgyn', 'adult',
  'DeLancey Pelvic Floor Support 1992; Williams Gynecology 4e Ch 41', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Resident ถามอาจารย์เรื่อง pelvic floor anatomy + childbirth-related injury'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามอาจารย์เรื่อง imaging in pregnancy — radiation safety + MRI + contrast', '[{"label":"A","text":"All imaging contraindicated in pregnancy"},{"label":"B","text":"Imaging in pregnancy"},{"label":"C","text":"Avoid all CT scans"},{"label":"D","text":"MRI uses ionizing radiation"},{"label":"E","text":"Gadolinium safe in pregnancy"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Imaging in pregnancy** — risk-benefit + maternal indication often supersedes fetal concern: (1) **ultrasound** — safest, no ionizing radiation; ALARA principle (minimize thermal/mechanical); first-line for OB + many maternal indications; (2) **MRI** — no ionizing radiation; safe in pregnancy all trimesters per ACOG/ACR (no demonstrated harm); 1.5T or 3T; **gadolinium contrast — avoid in pregnancy** (crosses placenta, gadolinium retention, fetal effects unclear — use only if essential + no alternative); breastfeeding compatible (minimal transfer); (3) **ionizing radiation (X-ray, CT, fluoroscopy, nuclear medicine)**: (a) **risks** — teratogenicity, growth, cancer (LCR — leukemia); (b) **dose thresholds** — < 50 mGy (< 5 rad) — no demonstrated fetal harm (deterministic); cumulative cumulative dose during organogenesis (2-15 wk) matters; (c) **typical doses fetal** (single study): CXR < 0.01 mGy, CT head 0, CT chest 0.1, **CT pulmonary angiogram 0.2-0.7 mGy**, CT abdo/pelvis 8-50 mGy, fluoroscopy variable, mammography 0.4 mGy; (d) **shielding when feasible** (limited utility, more for dose reassurance); (4) **PE workup pregnancy** — CTPA vs V/Q scan — CTPA lower fetal dose, higher maternal breast dose; V/Q higher fetal dose but lower maternal breast dose; both acceptable, individual; (5) **iodinated contrast** — safe in pregnancy + breastfeeding (small theoretical neonatal hypothyroidism — TSH at 2 wk recommended); (6) **gadolinium** — avoid except critical maternal indication (newer studies suggested possible link to stillbirth + childhood inflammatory conditions); (7) **nuclear medicine** — case-by-case; iodine-131 contraindicated (thyroid); (8) **ALARA** — appropriate test, technical optimization (low-dose protocols, fewer phases), shielding; (9) **counseling** — abdominal CT for trauma — benefit overwhelms theoretical risk; **never withhold maternal-indicated imaging**; (10) **breastfeeding** — most contrast safe + minimal transfer; many recommend continue without interruption

---

Imaging pregnancy: US + MRI safe (no radiation). Ionizing < 50 mGy no harm. CT pulm angio fetal dose low. CTPA preferred PE. Iodinated contrast safe; gadolinium avoid. ALARA. Don''t withhold maternal-indicated imaging. Breastfeeding most contrast safe.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'basic_science', 'obgyn', 'adult',
  'ACOG Committee Opinion 723: Guidelines for Diagnostic Imaging in Pregnancy 2017', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Resident ถามอาจารย์เรื่อง imaging in pregnancy — radiation safety + MRI + contrast'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital implements WHO Surgical Safety Checklist on OB unit (cesarean delivery)', '[{"label":"A","text":"Checklists are unnecessary"},{"label":"B","text":"WHO Surgical Safety Checklist"},{"label":"C","text":"Skip checklists"},{"label":"D","text":"Only physicians check"},{"label":"E","text":"Use only in emergency"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **WHO Surgical Safety Checklist** (Haynes NEJM 2009 — reduces mortality + complications ~ 40%) — adapted for OB/cesarean: (1) **Sign In** (before anesthesia induction): (a) patient identity + procedure + consent confirmed, (b) site marked if applicable, (c) anesthesia safety check, (d) pulse ox functioning, (e) **allergies known**, (f) difficult airway/aspiration risk, (g) **blood loss > 500 mL risk** + adequate IV access + blood available (high risk: placenta previa/accreta, prior C/S, twin, macrosomia, anemia); (2) **Time Out** (before skin incision): (a) all team members introduce by name + role, (b) confirm patient + procedure + site + position, (c) anticipated critical events — surgeon (length, blood loss, special equipment), anesthesia (concerns), nursing (sterility, equipment), (d) **antibiotic prophylaxis given within 60 min before incision** (cefazolin pre-skin incision reduces endometritis + wound — pre-incision change in 2010 ACOG; add azithromycin for non-elective C/S — Tita NEJM 2016), (e) essential imaging displayed; (3) **Sign Out** (before patient leaves OR): (a) nurse confirms procedure recorded, (b) instrument/sponge/needle count correct, (c) specimens labeled correctly, (d) equipment problems addressed, (e) recovery + key concerns communicated; (4) **OB-specific modifications**: (a) **fetal status** confirmed pre-incision, (b) **newborn resuscitation team** ready + identified, (c) **uterotonic plan** + PPH risk, (d) **bowel + bladder injury** awareness, (e) **VTE prophylaxis plan**; (5) **culture of safety** — flat hierarchy, speak-up encouraged; (6) **measurement + audit** of checklist compliance + outcomes; (7) **TeamSTEPPS integration**; (8) **debrief** at end of case for learning

---

WHO Surgical Safety Checklist 3 phases: Sign In, Time Out, Sign Out. Reduces mortality + complications. OB modifications: fetal status, NICU team, uterotonic plan, PPH risk. Antibiotic pre-incision cefazolin + azithromycin (non-elective C/S). Culture of safety. Audit. Debrief.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'ems_mgmt', 'obgyn', 'adult',
  'WHO Surgical Safety Checklist 2009; ACOG Patient Safety Series', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Hospital implements WHO Surgical Safety Checklist on OB unit (cesarean delivery)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Initiative addresses disparities + equity in maternal health (racial/socioeconomic disparities in maternal mortality + morbidity)', '[{"label":"A","text":"Inequities are inevitable"},{"label":"B","text":"Health equity + addressing disparities in OB"},{"label":"C","text":"Refuse non-Thai patients"},{"label":"D","text":"Treat everyone identically without addressing barriers"},{"label":"E","text":"Discharge non-paying patients"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Health equity + addressing disparities in OB**: (1) **acknowledge disparities** — US data: Black maternal mortality 3-4× white; Indigenous high; structural racism + social determinants of health (SDOH) → access, quality, bias; Thailand: rural-urban gap, migrant workers, hill tribes, refugees; (2) **structural racism + implicit bias** — provider education + training (Harvard Implicit Association Test); standardized care reduces variation; (3) **SDOH screening + addressing** — housing, food security, transportation, employment, education, insurance, IPV, immigration status; (4) **language services** — qualified medical interpreter (not family members); written materials in patient language; cultural humility; (5) **community partnership** — doulas (improve outcomes especially marginalized), community health workers, peer support; doula coverage Medicaid expansion; (6) **standardized care + bundles** — AIM safety bundles reduce disparities (uniform application); (7) **respectful maternity care** — WHO statement; patient-centered; consent; cultural sensitivity; (8) **workforce diversity** — recruit + retain underrepresented providers (better outcomes when concordance); (9) **maternal mortality review committees** — disaggregate by race/ethnicity/SES; identify systemic factors; (10) **mental health + substance use** integrated; (11) **immigration + uninsured** — access to ANC; emergency Medicaid; charity care; (12) **LGBTQ+ inclusivity** — transgender pregnancy, lesbian/bi pregnancy, gender-affirming care; (13) **disability** — accessible care; (14) **interpregnancy + postpartum care** — extend Medicaid 1 yr postpartum (US recent expansion); (15) **rural access** — telehealth, regional perinatal centers, transport; (16) **research equity** — include diverse populations; (17) Thai context — National Health Coverage 30-baht universal coverage; migrant workers access challenges; village health volunteers อสม.; (18) **measure + report** disparities; accountability

---

Equity in OB: address disparities, SDOH, language, doulas, community, standardized care + bundles, respectful maternity, workforce diversity, MMRC disaggregated. Postpartum Medicaid extension. Telehealth rural. Thai: 30-baht universal, อสม., migrant access. Measure + report. Implicit bias training.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'ems_mgmt', 'obgyn', 'adult',
  'ACOG Committee Opinion 729: Importance of Social Determinants; SMFM Health Equity', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Initiative addresses disparities + equity in maternal health (racial/socioeconomic disparities in maternal mortality + morbidity)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital develops obstetric simulation program — high-fidelity drills for shoulder dystocia, eclampsia, hemorrhage', '[{"label":"A","text":"Skip training"},{"label":"B","text":"Obstetric simulation training"},{"label":"C","text":"Use only didactic teaching"},{"label":"D","text":"Senior staff don''t need training"},{"label":"E","text":"Skip debrief"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Obstetric simulation training** — evidence improves team performance + clinical outcomes: (1) **high-fidelity simulators** — birthing mannequins (SimMom, NoelleS), task trainers (PPH, vacuum, suture), VR; (2) **scenarios**: (a) **shoulder dystocia** — HELPERR drill, team roles, time-keeper, documentation; (b) **eclampsia** — magnesium administration, BP control, airway, fetal monitoring; (c) **massive hemorrhage** — stage-based protocol, uterotonics, balloon, transfusion, surgical; (d) **cord prolapse** — elevation, position, cesarean; (e) **maternal cardiac arrest** — perimortem C/S < 4 min, LUD, ACLS; (f) **shoulder dystocia, OB anesthesia emergencies** (high spinal, LAST, failed intubation), (g) chorioamnionitis sepsis; (3) **debrief after each scenario** — structured, learner-centered (gather/analyze/summarize); psychological safety; identify gaps; (4) **multidisciplinary teams** — obstetricians, midwives, nurses, anesthesia, pediatrics, ancillary; in situ (own units) more transferable; (5) **TeamSTEPPS principles** integrated — closed-loop communication, SBAR, CUS, mutual support; (6) **frequency** — regular (quarterly per ACOG); annual at minimum; new staff orientation; (7) **measurement** — checklists, time to action, communication, outcomes (CMQCC, AIM); link to actual clinical outcomes; (8) **systems learning** — drills uncover equipment, protocol, environment issues — fix → re-test; (9) **simulation faculty training** + curriculum development; (10) **PRACTICE — PRactical Obstetric Multi-Professional Training (PROMPT)** — UK-developed, evidence reduces neonatal HIE, brachial plexus injury, severe shoulder dystocia; (11) **ALSO course** (Advanced Life Support in Obstetrics) — AAFP/ACOG; (12) **evidence** — Bristol PROMPT randomized cluster trial → ↓ adverse outcomes; (13) Thai context — RTCOG, simulation centers (Siriraj, Ramathibodi); national OB simulation initiative

---

OB simulation: high-fidelity scenarios (dystocia, eclampsia, hemorrhage, prolapse, cardiac arrest). Multidisciplinary teams. In situ. Debrief structured + psychological safety. TeamSTEPPS. Regular frequency. PROMPT + ALSO courses. Evidence reduces adverse outcomes (Bristol PROMPT). System learning. Thai simulation centers.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'ems_mgmt', 'obgyn', 'adult',
  'PROMPT-Maternity Foundation; ACOG Patient Safety Series; ALSO/AAFP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Hospital develops obstetric simulation program — high-fidelity drills for shoulder dystocia, eclampsia, hemorrhage'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงตั้งครรภ์ G2P1 GA 12 wk first ANC — HBsAg positive (chronic HBV carrier inactive), HBeAg negative, HBV DNA 1.2 × 10^4 IU/mL, ALT WNL, no cirrhosis, no decompensation

V/S: BP 116/72, HR 80
Gen: well
Lab: HBsAg+, HBeAg-, HBV DNA 1.2 × 10^4, anti-HBe+, ALT 28, AST 22, plt 240K, INR 1.0, bilirubin 0.6, US: no cirrhosis', '[{"label":"A","text":"No intervention needed"},{"label":"B","text":"HBV in pregnancy"},{"label":"C","text":"Cesarean reduces transmission"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Methotrexate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **HBV in pregnancy** — focus on preventing mother-to-child transmission (MTCT): (1) **infant prevention** — **HBV vaccine + HBIG within 12 hr of birth** to all infants of HBsAg+ mothers → reduces transmission > 90%; HBV vaccine series continued (0, 1, 6 mo); post-vaccination serology at 9-12 mo; (2) **maternal antiviral therapy to reduce MTCT** — indicated if **HBV DNA > 200,000 IU/mL (2 × 10^5) in 3rd trimester** (high viral load = ↑ transmission despite immunoprophylaxis); start **tenofovir disoproxil fumarate (TDF) 300 mg/d** from 28-32 wk through delivery + 1-3 mo postpartum (per AASLD); this patient HBV DNA 1.2 × 10^4 → not above threshold but should monitor + recheck 3rd trimester; (3) **monitor** — HBV DNA + ALT each trimester + postpartum (postpartum hepatitis flares — up to 25%, may need antiviral); (4) **avoid invasive intrapartum procedures** — fetal scalp electrode, fetal scalp blood, but C/S not routinely indicated to prevent transmission with immunoprophylaxis + low VL; (5) **breastfeeding safe** with HBV (even with TDF — minimal transfer); reduce nipple cracks (theoretical blood); (6) **partner + family** — screen, vaccinate if susceptible; (7) **HCC surveillance + liver care** — q 6 mo US + AFP (Asian women > 20-30 yr); long-term hepatology; (8) **co-infection screen** — HIV, HCV, HDV (delta), HAV vaccination; (9) **avoid hepatotoxic medications**; (10) **postpartum** — continue antiviral if started; monitor for flare 3-6 mo; (11) Thai context — Universal HBV vaccination birth dose at 0, 2, 4, 6 mo; HBIG availability variable; antiviral access through NHSO; (12) **vertical transmission rates** — HBeAg+ high VL untreated ~ 90%; with prophylaxis vaccine + HBIG + antiviral if high VL → < 1%

---

HBV pregnancy: HBV vaccine + HBIG to infant < 12 hr (universal HBsAg+ mothers). TDF for mother if HBV DNA > 200,000 IU/mL from 28-32 wk. Avoid invasive intrapartum. Breastfeeding safe. C/S doesn''t ↓ MTCT. Postpartum flare risk. HCC surveillance. Family screening + vaccine. Thai universal vaccination 0/2/4/6 mo.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'integrative', 'obgyn', 'adult',
  'AASLD HBV Pregnancy Guideline 2018; SMFM Statement HBV; Thai HBV Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงตั้งครรภ์ G2P1 GA 12 wk first ANC — HBsAg positive (chronic HBV carrier inactive), HBeAg negative, HBV DNA 1.2 × 10^4 IU/mL, ALT WNL, no cirrhosis, no decompensation

V/S: BP 116/72, HR 80
Gen: well
Lab: HBsAg+, HBeAg-, HBV DNA 1.2 × 10^4, anti-HBe+, ALT 28, AST 22, plt 240K, INR 1.0, bilirubin 0.6, US: no cirrhosis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงตั้งครรภ์ G1P0 GA 24 wk first ANC ตอน 24 wk — มาด้วยอาการ chronic cough + weight loss + night sweats + low-grade fever × 2 mo, no foreign travel

V/S: BP 116/72, HR 92, RR 18, Temp 37.4
Gen: thin, BMI 17, no LAN
Fetal: FHR 144, EFW 600 g (50th)
Lab: HIV negative, Sputum AFB smear 3+, Xpert MTB/RIF positive — rifampin-sensitive, CXR: bilateral upper lobe infiltrates + cavities + no effusion
TST/IGRA positive', '[{"label":"A","text":"Discharge — no treatment"},{"label":"B","text":"Active Pulmonary TB in pregnancy"},{"label":"C","text":"Cesarean for everyone"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Methotrexate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Active Pulmonary TB in pregnancy** — treat — untreated TB → worse outcomes (preterm, LBW, transmission, congenital TB rare but devastating): (1) **multidisciplinary** — OB + ID/TB clinic + public health; (2) **isolation** initially until non-infectious (negative pressure room, N95 visitors, until sputum smear negative ~ 2 wk treatment + symptomatic improvement); (3) **first-line antitubercular therapy — RIPE (rifampin, isoniazid, pyrazinamide, ethambutol)** — **safe in pregnancy** (long-standing experience, benefit > risk); 2 mo intensive + 4 mo continuation (rifampin + INH); pyrazinamide standard in pregnancy per WHO (US CDC reserves PZA controversial but trending toward use); (4) **pyridoxine (B6) 25-50 mg/d** with INH (prevents peripheral neuropathy + may help fetal); (5) **streptomycin AVOID** (fetal ototoxicity); other aminoglycosides too; (6) **MDR-TB** — multidisciplinary, second-line drugs with greater toxicity, individualized; bedaquiline + delamanid emerging; (7) **monitoring** — LFT monthly (RIF + INH + PZA hepatotoxic; pregnancy ↑ risk), sputum smear monthly until negative; weight, symptoms; (8) **fetal monitoring** — growth + NST; (9) **delivery** — vaginal preferred; mask if still infectious at delivery (rare with treatment); (10) **neonatal** — examine for congenital TB (rare); if mother infectious at delivery → IPT (isoniazid preventive therapy) + delayed BCG; isolate mother briefly; if mother non-infectious → BCG at birth Thai schedule; (11) **breastfeeding** — safe + encouraged (medications transfer minimal); (12) **postpartum** — continue treatment; postpartum unmasking of HIV-related TB; **screen HIV** mandatory; (13) **contact tracing** — household, workplace; (14) **DOT (directly observed therapy)** for adherence; (15) Thai context — National TB Program + universal access through NHSO + DOTS; refugee + migrant + prison populations elevated risk

---

Active TB in pregnancy: treat with RIPE (rifampin, INH, PZA, ethambutol) — safe. Add B6 with INH. Avoid streptomycin. Monitor LFT. Vaginal delivery + mask if infectious. Neonatal IPT + delayed BCG if mother infectious. Breastfeeding safe. HIV screen. Contact tracing. DOT. Thai National TB Program.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'integrative', 'obgyn', 'adult',
  'WHO TB in Pregnancy Guidelines; Thai National TB Program; CDC TB Pregnancy', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงตั้งครรภ์ G1P0 GA 24 wk first ANC ตอน 24 wk — มาด้วยอาการ chronic cough + weight loss + night sweats + low-grade fever × 2 mo, no foreign travel

V/S: BP 116/72, HR 92, RR 18, Temp 37.4
Gen: thin, BMI 17, no LAN
Fetal: FHR 144, EFW 600 g (50th)
Lab: HIV negative, Sputum AFB smear 3+, Xpert MTB/RIF positive — rifampin-sensitive, CXR: bilateral upper lobe infiltrates + cavities + no effusion
TST/IGRA positive'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 26 ปี G1P0 GA 14 wk underlying generalized tonic-clonic epilepsy on lamotrigine 200 mg BID + valproate 500 mg BID for 5 yr (was on valproate-only initially, lamotrigine added), seizure-free × 2 yr, came for ANC late

V/S: BP 116/72, HR 80
Gen: well
Fetal: heart present, anatomy not yet done
Lab: lamotrigine level adequate, valproate level adequate, folate level low, no anomalies seen on routine US so far', '[{"label":"A","text":"Stop all medications"},{"label":"B","text":"Epilepsy in pregnancy"},{"label":"C","text":"Cesarean immediately"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Methotrexate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Epilepsy in pregnancy** — multidisciplinary (neurology + MFM): (1) **risk-benefit** — uncontrolled seizures ↑ maternal/fetal harm (status epilepticus, trauma, SUDEP, hypoxia); medications carry teratogenic risk; (2) **medication review** — **valproate teratogenic** (4-10% major congenital malformations — NTD, cardiac, cleft, neurodevelopmental — autism + lower IQ); **AVOID valproate in women of childbearing age** when possible; in this patient already pregnant + 14 wk past organogenesis (3-8 wk) — damage may be done if going to occur; can switch postpartum + future pregnancies but acute switching mid-pregnancy may destabilize control; (3) **safer AEDs in pregnancy** — **lamotrigine, levetiracetam** lowest teratogenic risk; carbamazepine intermediate; (4) **preconception counseling ideal** — monotherapy lowest effective dose, switch from valproate if possible at least 6-12 mo before, optimize seizure control 9-12 mo seizure-free; (5) **folate supplementation** — **high-dose 4-5 mg/d** from preconception (1 mg/d at minimum here as already pregnant — too late for NTD primary prevention but continue); (6) **detailed anatomy scan at 18-22 wk** + fetal echo (cardiac); MSAFP for NTD; (7) **AED levels monitoring** — pregnancy ↓ levels (especially lamotrigine — increased clearance, levetiracetam) → adjust dose based on level + clinical to maintain seizure control; (8) **vitamin K** late pregnancy 10 mg/d (controversial for enzyme-inducing AEDs); (9) **labor** — continue AED; risk of seizure during labor; IV access; if seizes → lorazepam IV + magnesium not first choice (unless eclampsia); (10) **delivery** — vaginal usually; epidural OK; avoid pethidine (lowers threshold); (11) **postpartum** — sleep deprivation seizure trigger — partner support; ensure safe baby care plans during seizure; continue AED; level may need adjustment again (rises back); (12) **breastfeeding** — most AEDs compatible (lamotrigine + levetiracetam + carbamazepine OK; valproate also OK; phenobarbital + benzo sedation concern); (13) **neonatal** — withdrawal possible, monitor; vitamin K at birth; (14) **future pregnancy** — switch off valproate to safer AED preconception ideally; switch to monotherapy

---

Epilepsy pregnancy: don''t stop AEDs (uncontrolled seizures > med risk). Valproate teratogenic — switch ideally preconception. Lamotrigine + levetiracetam safest. High-dose folate. Detailed US + fetal echo. AED levels (lamotrigine ↓ in pregnancy). Vit K late. Postpartum sleep + adjust dose. Breastfeeding mostly safe.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'integrative', 'obgyn', 'adult',
  'ILAE/ACOG Epilepsy + Pregnancy; ACOG Practice Bulletin 234', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 26 ปี G1P0 GA 14 wk underlying generalized tonic-clonic epilepsy on lamotrigine 200 mg BID + valproate 500 mg BID for 5 yr (was on valproate-only initially, lamotrigine added), seizure-free × 2 yr, came for ANC late

V/S: BP 116/72, HR 80
Gen: well
Fetal: heart present, anatomy not yet done
Lab: lamotrigine level adequate, valproate level adequate, folate level low, no anomalies seen on routine US so far'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 30 ปี G1P0 GA 24 wk underlying Crohn''s disease in remission on infliximab + azathioprine — มาด้วย mild abdominal pain + bloody diarrhea (3 times/d) × 1 wk

V/S: BP 118/72, HR 88, Temp 37.3
Gen: well-appearing
Abdomen: mild RLQ tenderness, no peritonitis
Fetal: FHR 148 reactive, EFW 600 g
Lab: CBC: Hb 10.5, WBC 9.2, CRP 18, fecal calprotectin 280, stool culture pending
MRI abdomen: terminal ileal active inflammation', '[{"label":"A","text":"Stop all immunosuppressants"},{"label":"B","text":"IBD (Crohn''s disease) in pregnancy with active flare"},{"label":"C","text":"Cesarean immediately"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Discharge home without action"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **IBD (Crohn''s disease) in pregnancy with active flare** — multidisciplinary (GI + MFM): (1) **principle: active disease ≥ medication risk** — uncontrolled IBD → preterm birth, LBW, FGR, PROM, preeclampsia; aim deep remission preconception + maintain through pregnancy; (2) **continue biologics + immunomodulators** — **infliximab, adalimumab, certolizumab** — safe in pregnancy + relatively safe for newborn (continue throughout — newer data); placental transfer increases 3rd trimester; consider stopping/delaying last dose late pregnancy if disease quiet (timing varies by drug); **vedolizumab, ustekinumab** also acceptable; **azathioprine + 6-MP — continue** (long safety record in pregnancy IBD/transplant); (3) **AVOID** — **methotrexate (teratogen — abortifacient — stop 3 mo before conception)**, **tofacitinib** (no data; avoid); thalidomide; (4) **acute flare management** — corticosteroid (prednisolone or budesonide for ileal Crohn''s), 5-ASA (mesalamine safe), antibiotics carefully (metronidazole short course OK, avoid quinolone), bowel rest if needed; rule out infection (C diff, CMV) — stool culture + C diff PCR; (5) **surgical** — for refractory + complications (abscess, perforation, fistula) — multidisciplinary; (6) **nutrition** — protein, iron, folate (esp on sulfasalazine), B12 (terminal ileal resection), vit D, exclusive enteral or parenteral nutrition if severe; (7) **fetal surveillance** — growth + NST/BPP; (8) **delivery** — **vaginal delivery acceptable** for inactive disease; **C/S** for active perianal disease/rectovaginal fistula; consider for active proctitis (sphincter integrity); (9) **postpartum** — continue medications; flare risk if abruptly stopped; (10) **breastfeeding** — most IBD meds safe (biologics minimal transfer); MTX contraindicated; (11) **newborn live vaccines** — delay rotavirus + BCG if mother was on biologics late pregnancy (live vaccine immunosuppression); other vaccines OK; (12) **counseling** — family planning + recurrence + breastfeeding

---

IBD pregnancy: maintain remission > med risk. Continue biologics (infliximab, adalimumab, vedolizumab, ustekinumab), azathioprine. Avoid MTX + tofacitinib. Flare: steroid, 5-ASA, treat infection (C diff). Vaginal usually; C/S if perianal/rectovaginal. Postpartum continue. Breastfeeding mostly safe. Delay live vaccines if biologic late.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'integrative', 'obgyn', 'adult',
  'AGA IBD Pregnancy Care Pathway; PIANO Registry', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 30 ปี G1P0 GA 24 wk underlying Crohn''s disease in remission on infliximab + azathioprine — มาด้วย mild abdominal pain + bloody diarrhea (3 times/d) × 1 wk

V/S: BP 118/72, HR 88, Temp 37.3
Gen: well-appearing
Abdomen: mild RLQ tenderness, no peritonitis
Fetal: FHR 148 reactive, EFW 600 g
Lab: CBC: Hb 10.5, WBC 9.2, CRP 18, fecal calprotectin 280, stool culture pending
MRI abdomen: terminal ileal active inflammation'
  );

commit;

