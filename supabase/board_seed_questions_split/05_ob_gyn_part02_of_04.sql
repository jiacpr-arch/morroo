-- ===============================================================
-- หมอรู้ — Board seed: สูติศาสตร์-นรีเวชวิทยา (ob_gyn) — part 2/4 (50 MCQs)
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
  s.id, 'board', NULL, 'Resident ถามอาจารย์เรื่อง physiology — maternal cardiovascular adaptations in pregnancy', '[{"label":"A","text":"Cardiac output ลดลง 30% ตลอดการตั้งครรภ์"},{"label":"B","text":"Maternal hemodynamic changes in pregnancy"},{"label":"C","text":"BP rises throughout pregnancy"},{"label":"D","text":"Plasma volume decreases 20%"},{"label":"E","text":"Cardiac output unchanged"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Maternal hemodynamic changes in pregnancy: (1) **plasma volume** ↑ 40-50% (peak 32-34 wk); (2) **RBC mass** ↑ 20-30% — net = physiologic anemia of pregnancy (dilutional, Hb nadir 28-32 wk ~ 10.5-11 g/dL); (3) **cardiac output** ↑ 30-50% (↑ HR 10-20 bpm + ↑ stroke volume), peaks ~ 32 wk, sustained through delivery; CO ↑ acutely 60-80% in labor + immediate postpartum (autotransfusion); (4) **systemic vascular resistance** ↓ 30-40% (progesterone, NO, prostacyclin) → BP nadir 24-28 wk, returns to baseline by term; (5) supine hypotension after 20 wk — aortocaval compression by gravid uterus → left lateral tilt 15-30° during procedures, CPR (LUD); (6) **GFR** ↑ 50% (Cr falls to ~ 0.5, BUN falls); (7) **respiratory** — tidal volume ↑ 30-40% (progesterone-driven), MV ↑, respiratory alkalosis (PaCO2 28-32), compensated metabolic; (8) **hypercoagulable** — ↑ factors I, VII, VIII, IX, X, fibrinogen; ↓ protein S, antithrombin; ↑ PAI-1 — VTE risk 4-5× elevated; (9) **GI** — delayed gastric emptying, ↓ LES tone (reflux); (10) endocrine: hCG, hPL, progesterone, estrogen, prolactin, cortisol all ↑

---

Pregnancy hemodynamic adaptations — critical for understanding pathology. Plasma > RBC = dilutional anemia. CO up = ↑ HR + SV. SVR down = BP drop trimester 2 then recover. GFR up = lower Cr. Hypercoagulable = VTE risk. Aortocaval compression = LUD after 20 wk.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'basic_science', 'obgyn', 'adult',
  'Williams Obstetrics 26e Ch 4; Cunningham''s Maternal Physiology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Resident ถามอาจารย์เรื่อง physiology — maternal cardiovascular adaptations in pregnancy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามอาจารย์เรื่อง embryology — gametogenesis + fertilization + early implantation', '[{"label":"A","text":"Implantation เกิดที่ fallopian tube หลัง fertilization 7 วัน"},{"label":"B","text":"Reproductive embryology key points"},{"label":"C","text":"Cleavage starts after implantation"},{"label":"D","text":"Sperm capacitation in epididymis only"},{"label":"E","text":"Placenta forms after 20 weeks"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Reproductive embryology key points: (1) **oogenesis** — primary oocytes arrested in meiosis I prophase before birth (~ 1-2 million at birth, ~ 400 ovulated lifetime); meiosis I completes at ovulation (LH surge), meiosis II arrests at metaphase II until fertilization; (2) **spermatogenesis** — continuous from puberty, ~ 64 d cycle, ~ 100 million/d; capacitation in female tract enables fertilization; (3) **fertilization** — ampulla of fallopian tube within 12-24 hr of ovulation; sperm penetrates zona pellucida (acrosome reaction), cortical reaction prevents polyspermy; (4) **zygote** → cleavage → morula (~ d 3-4) → blastocyst (~ d 5) with inner cell mass + trophectoderm; (5) **implantation** — d 6-10 in uterine endometrium (decidualized) — apposition, adhesion, invasion; (6) **trophoblast** differentiates into cytotrophoblast (inner) + syncytiotrophoblast (outer, invasive, hCG-producing); (7) **placenta** — chorionic villi form by week 3; uteroplacental circulation established by week 12 (spiral artery remodeling — failure = preeclampsia/FGR); (8) **organogenesis** — week 3-8 (most teratogen-vulnerable); (9) **fetal period** — week 9 onward (growth + maturation); (10) viability ~ 22-24 wk (lung surfactant)

---

Reproductive biology basics. Meiotic arrest oocyte = clinically relevant (advanced maternal age aneuploidy). Implantation d 6-10 post-fert. Trophoblast invasion + spiral artery remodeling failure = preeclampsia. Organogenesis week 3-8 = teratogen window.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'basic_science', 'obgyn', 'adult',
  'Langman''s Medical Embryology 14e; Moore''s Developing Human 11e', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Resident ถามอาจารย์เรื่อง embryology — gametogenesis + fertilization + early implantation'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามอาจารย์เรื่อง pharmacology — uterotonics + tocolytics mechanisms', '[{"label":"A","text":"Oxytocin ทำหน้าที่ relax uterus"},{"label":"B","text":"Uterotonics + tocolytics: Uterotonics —"},{"label":"C","text":"Magnesium causes uterine contraction"},{"label":"D","text":"Nifedipine is a uterotonic"},{"label":"E","text":"Indomethacin is safe at term"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Uterotonics + tocolytics: **Uterotonics** — (1) **oxytocin** — binds GPCR → ↑ IP3/DAG → ↑ Ca²⁺ → smooth muscle contraction; first-line PPH prophylaxis + treatment; side effect: water intoxication (ADH-like), hypotension if rapid bolus; (2) **methylergonovine** (ergot) — α-adrenergic + 5-HT receptor agonist, sustained tetanic contraction; CI in HT, preeclampsia, CAD (vasospasm); (3) **carboprost (15-methyl PGF2α)** — prostaglandin receptor agonist, smooth muscle contraction; CI in asthma (bronchospasm), use cautious in HT; (4) **misoprostol (PGE1)** — PR/SL/PO/PV; cervical ripening + uterotonic + abortifacient + ulcer prevention; **Tocolytics** — (1) **nifedipine** (CCB) — blocks L-type Ca²⁺ channel → ↓ Ca²⁺ → smooth muscle relaxation; first-line PTL; SE hypotension, headache; (2) **atosiban** (oxytocin antagonist) — receptor competitive; expensive, few side effects; (3) **magnesium sulfate** — Ca²⁺ antagonist + neuroprotection; SE flushing, respiratory depression, antidote Ca gluconate; (4) **indomethacin** (NSAID) — COX inhibitor ↓ PG; < 32 wk only (ductus arteriosus closure, oligohydramnios); (5) **β-agonists** (terbutaline) — β2 → cAMP → relaxation; SE tachycardia, hyperglycemia, pulmonary edema (limited use)

---

Uterotonic + tocolytic pharm — critical board content. Know mechanism, indication, contraindication, side effect for each drug.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'basic_science', 'obgyn', 'adult',
  'Goodman & Gilman 14e; ACOG Practice Bulletins', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Resident ถามอาจารย์เรื่อง pharmacology — uterotonics + tocolytics mechanisms'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามอาจารย์เรื่อง physiology — menstrual cycle + HPO axis', '[{"label":"A","text":"LH surge หลัง progesterone peak"},{"label":"B","text":"Follicular phase (d 1-14)"},{"label":"C","text":"Estrogen falls during follicular phase"},{"label":"D","text":"Corpus luteum produces FSH"},{"label":"E","text":"Progesterone causes proliferative endometrium"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Menstrual cycle (28 d typical): **Follicular phase (d 1-14)** — (1) GnRH pulsatile from hypothalamus → ant pituitary FSH/LH; (2) FSH → recruits cohort of antral follicles → granulosa cells produce estradiol (aromatase converts androstenedione/testosterone from theca cells under LH); (3) dominant follicle selection by d 7-8 (high estradiol + ↑ FSH receptors); (4) estradiol → endometrial proliferation (proliferative phase); (5) estradiol > 200 pg/mL × 48 hr → **positive feedback** on hypothalamus/pituitary → **LH surge** (d 13-14) → **ovulation** within 36 hr; (6) basal body temp ↑ 0.5°C post-ovulation (progesterone-mediated); **Luteal phase (d 14-28)** — (1) ruptured follicle becomes corpus luteum → produces progesterone (+ estradiol); (2) progesterone → secretory endometrium (glycogen, glandular); (3) progesterone negative feedback on GnRH/LH/FSH → no further ovulation; (4) ถ้า fertilization → hCG from trophoblast rescues corpus luteum → maintains progesterone until placenta takes over ~ 8-10 wk; (5) no fertilization → corpus luteum regresses (~ d 26) → progesterone + estradiol fall → endometrial shedding (menstruation, d 28 = d 1 next cycle); LH/FSH rise restarts cycle

---

HPO axis + menstrual cycle = foundation for AUB, contraception, infertility. Know follicular + ovulatory + luteal phase events. LH surge = estrogen positive feedback. Progesterone = secretory endometrium + temp rise. hCG = corpus luteum rescue.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'basic_science', 'obgyn', 'adult',
  'Speroff''s Clinical Gynecologic Endocrinology 9e', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Resident ถามอาจารย์เรื่อง physiology — menstrual cycle + HPO axis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามอาจารย์เรื่อง physiology — fetal circulation + transition at birth', '[{"label":"A","text":"Foramen ovale ปิดในครรภ์"},{"label":"B","text":"placenta = gas exchange"},{"label":"C","text":"Lungs are primary gas exchange in utero"},{"label":"D","text":"Umbilical arteries carry oxygenated blood"},{"label":"E","text":"Ductus arteriosus closes during fetal life"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Fetal circulation: (1) **placenta = gas exchange** organ (lungs collapsed, not used); (2) oxygenated blood from placenta via **umbilical vein** (PaO2 ~ 30-35 mmHg — highest in fetal circulation); (3) ~ 50% bypasses liver via **ductus venosus** → IVC; (4) blood enters right atrium → preferential streaming through **foramen ovale** (right-to-left atrial shunt) → left atrium → LV → ascending aorta → coronaries + brain (highest O2); (5) deoxygenated SVC blood → RA → RV → pulmonary artery → mostly bypasses lungs via **ductus arteriosus** (PGE2-maintained patency) → descending aorta → lower body + **umbilical arteries** (2) → placenta; (6) high pulmonary vascular resistance (collapsed alveoli) drives right-to-left shunting; **At birth** — (1) clamp cord → loss of low-resistance placental circuit → ↑ SVR; (2) first breath → ↓ pulmonary vascular resistance → ↑ pulmonary blood flow → ↑ left atrial pressure → **functional closure of foramen ovale** (anatomical months later); (3) ↑ PaO2 + ↓ PGE2 → **ductus arteriosus closes** functionally 10-15 hr, anatomically 2-3 wk → ligamentum arteriosum; (4) ductus venosus closes → ligamentum venosum; (5) umbilical arteries → medial umbilical ligaments; umbilical vein → ligamentum teres; (6) persistent fetal circulation = PPHN (meconium, sepsis, asphyxia)

---

Fetal circulation: 3 shunts (ductus venosus, foramen ovale, ductus arteriosus). Placenta = gas exchange. Highest O2 in umbilical vein → brain/heart preferential. PGE2 keeps DA open. Transition at birth: ↑ SVR, ↓ PVR, shunt closure. PDA reopened with PGE1 in cyanotic CHD; closed with indomethacin/ibuprofen.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'basic_science', 'obgyn', 'adult',
  'Williams Obstetrics 26e Ch 7; Nelson Pediatrics', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Resident ถามอาจารย์เรื่อง physiology — fetal circulation + transition at birth'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital obstetric unit wants to reduce maternal mortality from hemorrhage + sepsis + HTN crisis', '[{"label":"A","text":"Just hire more doctors"},{"label":"B","text":"Maternal mortality reduction bundle approach (AIM/ACOG safety bundles)"},{"label":"C","text":"Reduce nurse staffing"},{"label":"D","text":"Eliminate fetal monitoring"},{"label":"E","text":"Wait for symptoms before intervention"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Maternal mortality reduction bundle approach (AIM/ACOG safety bundles): (1) **Obstetric Hemorrhage Bundle** — readiness (hemorrhage cart, MTP protocol, blood bank, response team), recognition + prevention (risk assessment every patient — low/medium/high; active management 3rd stage; quantitative blood loss QBL not visual estimation), response (stage-based protocol — stage 0-3 algorithm; uterotonics; balloon; surgical), reporting + systems learning (debriefs, M&M, simulation drills); (2) **Severe HTN/Preeclampsia Bundle** — antihypertensive within 60 min for severe-range BP, MgSO4 for severe features, debrief, patient/family education postpartum; (3) **Sepsis Bundle** — early recognition (MEWS), Hour-1 bundle (cultures, broad-spectrum abx, lactate, fluid, source control); (4) **Maternal Early Warning System (MEWS)** — vital sign-based escalation; (5) **simulation training** — high-fidelity drills (shoulder dystocia, eclampsia, hemorrhage, cord prolapse, OB code); (6) **multidisciplinary rounds + huddles** (OB, anesthesia, nursing, NICU); (7) **levels of maternal care** (per ACOG/SMFM — basic, specialty, subspecialty, regional); (8) **review every severe morbidity/mortality** (M&M conference, root cause analysis); (9) culture of safety — psychological safety + speak-up; (10) patient-centered + equity — address racial/SES disparities

---

AIM (Alliance for Innovation on Maternal Health) safety bundles — evidence-based standardized response. Hemorrhage, HTN, sepsis, VTE, opioid use, postpartum care. Stage-based hemorrhage protocol. MEWS. Simulation. Levels of maternal care. Equity focus. ACOG/SMFM partnership.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'ems_mgmt', 'obgyn', 'adult',
  'ACOG/AIM Safety Bundles; Council on Patient Safety in Women''s Health', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Hospital obstetric unit wants to reduce maternal mortality from hemorrhage + sepsis + HTN crisis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Labor + delivery unit implementing TeamSTEPPS + SBAR communication after sentinel event missed eclampsia', '[{"label":"A","text":"Communication is unnecessary"},{"label":"B","text":"TeamSTEPPS"},{"label":"C","text":"Hierarchy prevents speak-up"},{"label":"D","text":"SBAR only for nurses"},{"label":"E","text":"Eliminate handoffs"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** TeamSTEPPS + SBAR implementation: **TeamSTEPPS** (AHRQ) — evidence-based teamwork system: (1) Team Structure (defined roles); (2) Leadership (briefs, huddles, debriefs); (3) Situation Monitoring (cross-monitoring, STEP — Status of patient, Team members, Environment, Progress toward goals); (4) Mutual Support (task assistance, advocacy, DESC script for conflict); (5) Communication (SBAR, call-out, check-back, handoff — I PASS THE BATON); **SBAR** structured handoff: **S**ituation (concise present problem), **B**ackground (relevant history), **A**ssessment (clinical judgment), **R**ecommendation (specific action requested); example for severe preeclampsia: ''S: 32 wk gravida with BP 178/118 + headache; B: chronic HT, missed last 2 ANC; A: severe-range BP with cerebral symptom — suspected severe preeclampsia, eclampsia risk; R: I am giving labetalol 20 mg IV and MgSO4 bolus, please come now to evaluate for delivery''; **closed-loop communication** — sender states message, receiver repeats back, sender confirms; **call-outs** during emergencies (drug doses, vital signs); **CUS words** — ''I am **C**oncerned, **U**ncomfortable, this is a **S**afety issue''; psychological safety + speak-up culture; routine simulation training; debriefs after every emergency

---

TeamSTEPPS + SBAR = patient safety standard. Communication failures = root cause of most sentinel events. SBAR structured handoff. Closed-loop confirms understanding. CUS escalation. Psychological safety + flattened hierarchy. AHRQ evidence-based.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'ems_mgmt', 'obgyn', 'adult',
  'AHRQ TeamSTEPPS 2.0; Joint Commission Sentinel Event Alerts', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Labor + delivery unit implementing TeamSTEPPS + SBAR communication after sentinel event missed eclampsia'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital implements Maternal Early Warning Criteria (MEWC/MEOWS) for early sepsis + hemorrhage detection', '[{"label":"A","text":"Vital signs are not predictive"},{"label":"B","text":"document + review"},{"label":"C","text":"MEOWS only for ICU"},{"label":"D","text":"Vital signs ignored"},{"label":"E","text":"No protocol needed"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Maternal Early Warning Score (MEWS/MEOWS) — track-and-trigger: (1) routine maternal vital sign monitoring (NIBP, HR, RR, SpO2, temp, GCS/AVPU) at defined intervals; (2) **trigger criteria** (single trigger requires bedside evaluation): SBP < 90 or > 160, DBP > 100, HR < 50 or > 120, RR < 10 or > 30, SpO2 < 95% on air, oliguria < 35 mL/hr × 2 hr, altered mentation, fever > 38, persistent headache/visual symptoms, breathlessness; (3) **escalation pathway** — RN re-checks → MD bedside eval within 30 min → senior OB/MFM/anesthesia/ICU as needed; (4) **document + review** every trigger; (5) **rapid response team (OB-RRT / code OB)** activated for unstable; (6) targeted workup — preeclampsia, sepsis, hemorrhage, VTE, cardiac, anaphylaxis, AFE; (7) **MEOWS chart** color-coded (green/yellow/red zones) → visual prompt for action; (8) staff education + drills; (9) integrate with EMR alerts; (10) **outcomes**: MEOWS reduces maternal morbidity (RCOG, Saving Mothers Lives UK); (11) extends from antepartum through 6 wk postpartum (delayed presentation common); compare to NEWS2 (general) adapted for pregnancy physiology (lower BP normal, higher HR normal, respiratory alkalosis)

---

MEWS/MEOWS = early warning for maternal deterioration. Triggers + escalation pathway. RRT activation. Adapted for pregnancy physiology. Reduces maternal morbidity. Saving Mothers Lives UK evidence base. AIM bundle integration.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'ems_mgmt', 'obgyn', 'adult',
  'RCOG Saving Mothers'' Lives MBRRACE-UK; AIM Severe Hypertension Bundle', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Hospital implements Maternal Early Warning Criteria (MEWC/MEOWS) for early sepsis + hemorrhage detection'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 32 ปี G1P0 GA 16 wk underlying mechanical mitral valve replacement on warfarin 5 mg/d, INR 2.8

V/S: BP 118/72, HR 88, RR 16
Fetal: heart 158, growth appropriate, no anomalies on detailed US (will repeat 20 wk)
Cardiac: prosthetic mitral valve click normal, mild MR, EF 60%', '[{"label":"A","text":"Continue warfarin throughout pregnancy"},{"label":"B","text":"Mechanical heart valve in pregnancy — anticoagulation strategy + multidisciplinary care (cardio-obstetric team)"},{"label":"C","text":"Stop all anticoagulation"},{"label":"D","text":"Terminate pregnancy"},{"label":"E","text":"Replace valve immediately"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mechanical heart valve in pregnancy — anticoagulation strategy + multidisciplinary care (cardio-obstetric team): (1) **warfarin** — most effective for valve thrombosis prevention BUT teratogenic (warfarin embryopathy — nasal hypoplasia, stippled epiphyses, CNS abnormalities — risk dose-dependent, > 5 mg/d highest risk; also fetal hemorrhage); (2) **options 1st trimester** (6-12 wk highest teratogen risk) — (a) **switch to LMWH** (enoxaparin BID, dose-adjusted to anti-Xa peak 1.0-1.2 IU/mL, trough > 0.6) — safer for fetus but higher maternal valve thrombosis risk; (b) continue warfarin ถ้า dose ≤ 5 mg (lower teratogen risk per ESC 2018); (c) UFH IV (alternative) — less reliable; (3) **2nd trimester (13-36 wk)** — warfarin reasonable (lowest fetal risk window); maintain INR 2.5-3.5 per valve type; (4) **at 36 wk** — switch to **LMWH or UFH** (warfarin causes fetal anticoagulation → intracranial hemorrhage during delivery); (5) plan **scheduled delivery** at 37-39 wk — stop LMWH 24 hr before, UFH 4-6 hr; restart 6-12 hr post-delivery + bridge back to warfarin (warfarin safe with breastfeeding); (6) avoid epidural ถ้า therapeutic anticoagulation; (7) endocarditis prophylaxis at delivery (controversial — ACC/AHA selective); (8) ICU/cardio-OB coordination; (9) fetal echo 22 wk; (10) preconception counseling ideal — discuss alternative valves before pregnancy

---

Mechanical valve pregnancy = high-risk integrative. Warfarin teratogenic (esp > 5 mg/d, 1st trimester). LMWH safer fetus but valve thrombosis risk if subtherapeutic. ESC + ACC/AHA guidelines. Cardio-OB multidisciplinary. Timing of switches around delivery critical.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'integrative', 'obgyn', 'adult',
  'ESC Guidelines on Cardiovascular Disease in Pregnancy 2018; ACC/AHA Valvular Heart Disease 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 32 ปี G1P0 GA 16 wk underlying mechanical mitral valve replacement on warfarin 5 mg/d, INR 2.8

V/S: BP 118/72, HR 88, RR 16
Fetal: heart 158, growth appropriate, no anomalies on detailed US (will repeat 20 wk)
Cardiac: prosthetic mitral valve click normal, mild MR, EF 60%'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 35 ปี G2P1 GA 20 wk newly diagnosed HIV — first ANC visit, antiretroviral-naive, CD4 480, viral load 25,000 copies/mL

V/S: BP 116/72, HR 80
Fetal: anatomy scan normal, growth appropriate', '[{"label":"A","text":"No treatment, wait until 3rd trimester"},{"label":"B","text":"HIV in pregnancy — comprehensive PMTCT (Prevention of Mother-to-Child Transmission)"},{"label":"C","text":"Avoid all medications during pregnancy"},{"label":"D","text":"Cesarean delivery + breastfeed"},{"label":"E","text":"Discontinue follow-up after delivery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** HIV in pregnancy — comprehensive PMTCT (Prevention of Mother-to-Child Transmission): (1) **start ART immediately** regardless of CD4 or VL — Thai/WHO guidelines: TDF + 3TC (or FTC) + DTG (dolutegravir-based preferred, including 1st trimester per recent data) OR EFV-based alternative; goal — undetectable VL (< 50 copies/mL) at delivery → vertical transmission < 1%; (2) **lab monitoring** — VL every 4-8 wk + 34-36 wk (decides delivery mode), CD4, CBC, LFT, RFT, hepatitis B/C, syphilis, GC/CT screening; (3) **mode of delivery** — **vaginal delivery** safe ถ้า VL < 1,000 at 36 wk on ART; **scheduled cesarean at 38 wk** ถ้า VL > 1,000 or unknown; (4) **intrapartum** — IV zidovudine (AZT) infusion ถ้า VL > 1,000 or unknown at delivery — 2 mg/kg load then 1 mg/kg/hr until delivery; avoid invasive procedures (FSE, fetal scalp blood, AROM unless necessary, episiotomy, operative vaginal); (5) **postpartum infant** — **no breastfeeding** in Thailand/high-income (replacement feeding safe + acceptable + feasible + affordable + sustainable AFASS); WHO recommends breastfeeding + maternal ART in low-resource settings; infant prophylaxis — AZT 4 wk if low-risk, AZT + NVP + 3TC ถ้า high-risk; infant testing PCR at birth, 4-6 wk, 4-6 mo (DNA PCR — confirms negative); (6) ongoing maternal ART lifelong, multidisciplinary (ID, OB, pediatric, social, mental health); (7) disclosure + partner notification + testing + PrEP; (8) postpartum contraception

---

HIV PMTCT: untreated transmission risk 25-40% → < 1% with ART + intrapartum AZT + replacement feeding. DTG-based now preferred (no longer neural tube concern per Tsepamo update). VL-guided delivery mode. Avoid invasive intrapartum procedures. Infant prophylaxis + early PCR testing. Thailand achieved EMTCT status (eliminate mother-to-child transmission).', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'integrative', 'obgyn', 'adult',
  'Thai National HIV Treatment Guidelines 2021; WHO Consolidated HIV Guidelines 2021; ACOG Practice Bulletin 234', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 35 ปี G2P1 GA 20 wk newly diagnosed HIV — first ANC visit, antiretroviral-naive, CD4 480, viral load 25,000 copies/mL

V/S: BP 116/72, HR 80
Fetal: anatomy scan normal, growth appropriate'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 28 ปี G3P0A2 (prior 2 painless 2nd-trimester losses 18-20 wk) GA 14 wk current pregnancy — TVS cervical length 22 mm + funneling

V/S: BP 116/70, HR 78
Fetal: viable, growth appropriate, no anomaly
No contractions, no bleeding', '[{"label":"A","text":"Discharge with strict bed rest only"},{"label":"B","text":"Cervical insufficiency (history-indicated + US-indicated finding) — high recurrence risk; cerclage indicated"},{"label":"C","text":"Misoprostol immediately"},{"label":"D","text":"Cesarean delivery now"},{"label":"E","text":"Methotrexate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Cervical insufficiency** (history-indicated + US-indicated finding) — high recurrence risk; **cerclage** indicated: (1) **history-indicated McDonald cerclage at 12-14 wk** (prior ≥ 1 painless 2nd-trimester losses or short cervix in prior preg) — purse-string suture at cervico-vaginal junction; alternative Shirodkar (transvaginal) or transabdominal (failed transvaginal); (2) **US-indicated** ถ้า CL < 25 mm before 24 wk + history preterm birth → cerclage; (3) **physical exam-indicated ''rescue'' cerclage** ถ้า cervix dilated ≥ 1-2 cm before 24 wk + membranes visible — emergency cerclage 16-23+6 wk ถ้า no infection/labor/abruption (rule out chorioamnionitis first — amniocentesis); (4) **vaginal progesterone 200 mg PV daily** from 16-36 wk for short cervix (CL < 25 mm) — alternative or adjunct (PREGNANT, OPPTIMUM trials); (5) **17-OH progesterone caproate (Makena)** — recently withdrawn FDA 2023 due to PROLONG trial; (6) avoid digital exam unnecessarily; (7) activity restriction controversial — not bed rest; (8) GBS prophylaxis if indicated; (9) remove cerclage at 36-37 wk or with labor; (10) future pregnancies — prior cerclage = recurrence; counsel pre-pregnancy

---

Cervical insufficiency: painless 2nd-trim losses, recurrent. Diagnosis = history + US (CL < 25 mm < 24 wk with history). Cerclage types: history-indicated (12-14 wk), US-indicated, physical exam-indicated (rescue). Vaginal progesterone alternative/adjunct. Bed rest not effective. Rule out infection before rescue cerclage.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin 234: Cerclage 2014/Reaffirmed; SMFM Consult Series 53', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 28 ปี G3P0A2 (prior 2 painless 2nd-trimester losses 18-20 wk) GA 14 wk current pregnancy — TVS cervical length 22 mm + funneling

V/S: BP 116/70, HR 78
Fetal: viable, growth appropriate, no anomaly
No contractions, no bleeding'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 30 ปี G2P1 GA 24 wk PPROM 3 d ago, was managed expectantly. Now มาด้วย fever 38.6, tachy, uterine tenderness + foul vaginal discharge

V/S: BP 110/68, HR 124, RR 22, Temp 38.6
Fetal: FHR 178 tachycardia, no decels yet
Lab: WBC 19,000 with left shift, CRP 95
Uterus: tender', '[{"label":"A","text":"Continue expectant management"},{"label":"B","text":"Clinical chorioamnionitis (intraamniotic infection — IAI)"},{"label":"C","text":"Discharge home with PO antibiotic"},{"label":"D","text":"Tocolysis to prolong pregnancy"},{"label":"E","text":"Steroid only without delivery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Clinical chorioamnionitis (intraamniotic infection — IAI)** in PPROM: criteria — maternal fever ≥ 39.0 once OR 38.0-38.9 × 30 min PLUS one of: fetal tachy > 160, maternal WBC > 15K (no steroid), purulent cervical discharge; (1) **broad-spectrum IV antibiotics** — ampicillin 2 g IV q 6 hr + gentamicin 5 mg/kg q 24 hr (or 2 mg/kg load + 1.5 q 8 hr); add clindamycin 900 mg q 8 hr or metronidazole if C/S delivery (anaerobic coverage); penicillin-allergic: vanc + gent + clinda; (2) **deliver promptly regardless of GA** — chorioamnionitis = indication for delivery (uterine evacuation); vaginal delivery preferred ถ้า safe + reasonable progress; cesarean for usual obstetric indication; (3) antipyretic (acetaminophen); (4) IV fluid; (5) continuous fetal monitoring; (6) **neonatal team** standby — sepsis workup baby (early-onset sepsis high risk), antibiotics + culture; (7) **postpartum** — continue antibiotic until afebrile 24-48 hr + clinically improved (usually 24-48 hr post-delivery), one additional dose post-vaginal vs 24 hr post-C/S per protocol; (8) **placental pathology** for confirmation; (9) PPH risk ↑ (atony from inflammation); (10) sepsis bundle ถ้า severe — Hour-1 bundle, lactate, cultures, fluid, vasopressors ถ้า shock

---

Chorioamnionitis (IAI) = indication for delivery + antibiotics. Criteria — maternal fever + tachy/WBC/discharge. Amp + gent + clinda (if C/S). Vaginal delivery preferred. Neonatal sepsis risk. Postpartum endometritis prophylaxis. Placental path. Sepsis bundle if severe.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Committee Opinion 712: Intrapartum Management of Intraamniotic Infection 2017', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 30 ปี G2P1 GA 24 wk PPROM 3 d ago, was managed expectantly. Now มาด้วย fever 38.6, tachy, uterine tenderness + foul vaginal discharge

V/S: BP 110/68, HR 124, RR 22, Temp 38.6
Fetal: FHR 178 tachycardia, no decels yet
Lab: WBC 19,000 with left shift, CRP 95
Uterus: tender'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 26 ปี G1P1 NSD 5 วันก่อน มาด้วยอาการ fever 38.8 + ปวดท้องน้อย + foul lochia + uterine tenderness

V/S: BP 118/74, HR 108, RR 18, Temp 38.8
Gen: ill-looking
Uterus: tender, subinvoluted, foul lochia
Lab: WBC 17,500, CRP 88, U/A WNL', '[{"label":"A","text":"Outpatient ibuprofen"},{"label":"B","text":"Postpartum endometritis (most common cause of postpartum fever — polymicrobial: GBS, anaerobes, gram-negatives, gonorrhea/chlamydia): admit;"},{"label":"C","text":"Hysterectomy"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Antifungal only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Postpartum endometritis** (most common cause of postpartum fever — polymicrobial: GBS, anaerobes, gram-negatives, gonorrhea/chlamydia): admit; (1) **IV broad-spectrum antibiotics** — clindamycin 900 mg IV q 8 hr + gentamicin 5 mg/kg q 24 hr (gold standard, French regimen, > 90% cure) until afebrile 24-48 hr + clinical improvement, then no need oral conversion (vaginal delivery); add ampicillin if enterococcus/GBS suspected; alternative — amp/sulbactam, pip/tazo; (2) **rule out abscess** (US/CT) ถ้า persistent fever > 72 hr — drainage; (3) **rule out septic pelvic thrombophlebitis** (persistent fever despite antibiotics, anticoagulant trial); (4) **retained products** US — D&C if confirmed; (5) breast exam — mastitis/abscess; (6) UA, urine cx — UTI/pyelonephritis; (7) wound exam — surgical site infection; (8) **VTE prophylaxis** (postpartum + sepsis = high risk); (9) blood cx if severe; (10) lactation support if breastfeeding; (11) cesarean delivery endometritis higher risk (intra-op antibiotic prophylaxis pre-skin incision — cefazolin + azithromycin per SCIP/ASCRS reduces endometritis); (12) sepsis bundle if severe; (13) ICU ถ้า septic shock

---

Postpartum endometritis — most common postpartum infection. Risk: C/S (20×), prolonged labor, multiple exams, chorioamnionitis, GBS, low SES. Polymicrobial. Clinda + gent gold standard. Persistent fever → workup abscess, septic pelvic thrombophlebitis, retained products, wound infection. C/S antibiotic prophylaxis pre-incision (cefazolin + azithromycin).', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin 199: Use of Prophylactic Antibiotics in Labor and Delivery', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 26 ปี G1P1 NSD 5 วันก่อน มาด้วยอาการ fever 38.8 + ปวดท้องน้อย + foul lochia + uterine tenderness

V/S: BP 118/74, HR 108, RR 18, Temp 38.8
Gen: ill-looking
Uterus: tender, subinvoluted, foul lochia
Lab: WBC 17,500, CRP 88, U/A WNL'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 35 ปี G3P3 postpartum d 10 จาก C/S last week — มาด้วย sudden dyspnea + pleuritic chest pain + R leg swelling × 2 d

V/S: BP 102/64, HR 124, RR 28, SpO2 89% RA, Temp 37.4
Gen: distressed, RA + L lower limb edema
Lab: D-dimer 4,500, BNP 280, troponin negative', '[{"label":"A","text":"Outpatient ibuprofen"},{"label":"B","text":"Postpartum pulmonary embolism + DVT"},{"label":"C","text":"Discharge home with paracetamol"},{"label":"D","text":"Aspirin only"},{"label":"E","text":"Diuretic only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Postpartum pulmonary embolism + DVT** (postpartum hypercoagulable peak first 6 wk; risk 5× ↑ vs non-pregnant, 20× ↑ post-C/S): (1) **immediate stabilization** — O2, IV access, IV fluid careful; (2) **diagnostic imaging** — CT pulmonary angiogram (gold standard; less radiation than V/Q to fetus — and patient is postpartum so fetal not a concern); compression Doppler US lower extremity for DVT (alternative if can''t CT); ECG (S1Q3T3, sinus tachy, RV strain); echo (RV dilation, McConnell sign); (3) **anticoagulation** — start empirically pending workup ถ้า high probability — **LMWH (enoxaparin 1 mg/kg SC q 12 hr)** preferred postpartum (renal-adjusted) OR UFH IV ถ้า hemodynamic instability/thrombolysis planned/renal failure; (4) **massive PE with hemodynamic instability** (SBP < 90, RV failure) → thrombolysis (alteplase 100 mg over 2 hr) — postpartum bleeding risk; surgical embolectomy or catheter-directed thrombolysis alternatives; (5) IVC filter ถ้า contraindication to anticoagulation or recurrent PE; (6) duration — **at least 3 mo, extending 6 wk postpartum minimum**; bridge to warfarin or DOAC; warfarin OK with breastfeeding; DOACs unclear in breastfeeding; (7) workup — thrombophilia testing (postpone until off anticoagulation); (8) future pregnancy: prophylactic LMWH antepartum + postpartum 6 wk

---

VTE = leading cause of maternal mortality high-income. Risk peaks first 6 wk postpartum (esp C/S). PE = dyspnea, pleuritic pain, tachy, hypoxia. CTPA preferred postpartum. LMWH first-line. Massive PE → thrombolysis (postpartum bleed risk). 3 mo treatment + 6 wk minimum postpartum. Future pregnancy LMWH prophylaxis.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin 196: Thromboembolism in Pregnancy; RCOG Green-top 37a', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 35 ปี G3P3 postpartum d 10 จาก C/S last week — มาด้วย sudden dyspnea + pleuritic chest pain + R leg swelling × 2 d

V/S: BP 102/64, HR 124, RR 28, SpO2 89% RA, Temp 37.4
Gen: distressed, RA + L lower limb edema
Lab: D-dimer 4,500, BNP 280, troponin negative'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 28 ปี G1P1 NSD 30 นาที, sudden agitation + dyspnea + cyanosis + hypotension immediately after delivery + coagulopathy

V/S: BP 60/30, HR 140, RR 32, SpO2 78%
Gen: cyanotic, altered mental status
Uterus: atonic, heavy bleeding
Lab (stat): plt 45K, INR 2.8, fibrinogen 80, D-dimer > 20,000', '[{"label":"A","text":"Discharge home"},{"label":"B","text":"Amniotic Fluid Embolism (AFE)"},{"label":"C","text":"Discharge with paracetamol"},{"label":"D","text":"Wait + watch only"},{"label":"E","text":"Anticoagulation alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Amniotic Fluid Embolism (AFE)** — rare but catastrophic obstetric emergency (cardiopulmonary collapse + coagulopathy + altered mental status during labor/delivery/immediate postpartum); pathophysiology — anaphylactoid syndrome of pregnancy (immune-mediated, not just embolic); (1) **call code — multidisciplinary** — anesthesia/ICU/OB/hematology/neonatology; (2) **A-B-C — secure airway, intubate + ventilate**; (3) **circulatory support** — IV fluid bolus, vasopressors (norepi + epi), inotropes (dobutamine); avoid fluid overload (RV failure); (4) **CPR + ACLS** ถ้า arrest — left uterine displacement / perimortem C/S within 4 min ถ้า fetus undelivered; (5) **massive transfusion protocol** — PRBC + FFP + plt + cryoprecipitate 1:1:1; **fibrinogen replacement** (cryo or concentrate — target > 200 mg/dL, < 100 ominous); tranexamic acid 1 g IV; (6) **uterine atony management** — uterotonics + balloon + ligation/hysterectomy if needed for hemostasis; (7) **ECMO** — refractory cardiopulmonary collapse, venovenous or venoarterial; (8) supportive care ICU — invasive monitoring, mechanical ventilation, renal replacement, neuroprotection; (9) consider **A-OK regimen** (atropine + ondansetron + ketorolac — anecdotal Clark series); (10) diagnosis = clinical (rule out PE, abruption, sepsis, anaphylaxis, MI, eclampsia); mortality 20-60%, survivors often have neurologic injury; (11) debrief team + family + bereavement

---

AFE: rare (1-12/100,000), high mortality. Triad: cardiopulmonary collapse + coagulopathy + altered mental status. Phase 1 hypoxia/RV failure → Phase 2 LV failure + DIC. Multidisciplinary code response. MTP + fibrinogen. ECMO option. Perimortem C/S within 4 min of arrest. Diagnosis clinical. Survivors neurologic morbidity.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'AFE Foundation Diagnosis Criteria; SOAP Consensus on AFE 2016', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 28 ปี G1P1 NSD 30 นาที, sudden agitation + dyspnea + cyanosis + hypotension immediately after delivery + coagulopathy

V/S: BP 60/30, HR 140, RR 32, SpO2 78%
Gen: cyanotic, altered mental status
Uterus: atonic, heavy bleeding
Lab (stat): plt 45K, INR 2.8, fibrinogen 80, D-dimer > 20,000'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 28 ปี G1P1 immediately after vaginal delivery — sudden hypotension + uterus not palpable abdominally + mass in vagina + heavy bleeding

V/S: BP 78/48, HR 132
Uterus: not palpable on abdominal exam, palpable mass at vagina
Bleeding: heavy ongoing', '[{"label":"A","text":"Discharge home"},{"label":"B","text":"Uterine Inversion (rare but life-threatening — fundus inverted through cervix; severe hemorrhage + shock; risk: excessive cord traction, fundal pressure, atony, accreta, short cord)"},{"label":"C","text":"Hysterectomy first"},{"label":"D","text":"Wait + observe"},{"label":"E","text":"Tocolytic without replacement"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Uterine Inversion** (rare but life-threatening — fundus inverted through cervix; severe hemorrhage + shock; risk: excessive cord traction, fundal pressure, atony, accreta, short cord): (1) **call for help — anesthesia + OB**; (2) **immediate manual replacement** — push fundus back via vagina (**Johnson maneuver**) — place placenta in palm, push back through cervix toward umbilicus; do NOT remove placenta until uterus replaced (worsens hemorrhage); (3) **stop uterotonics** + **uterine relaxation** — IV nitroglycerin 50-200 mcg bolus, terbutaline 0.25 mg SC, magnesium, or general anesthesia with halogenated agent (relaxation needed); (4) **once replaced** — bimanual compression, **then start uterotonics** (oxytocin) to maintain tone + prevent re-inversion; (5) **manually remove placenta** if still attached; (6) **IV access × 2 large bore**, type & cross, massive transfusion if needed; (7) **surgical management** ถ้า manual replacement fails — laparotomy — **Huntington procedure** (clamps + traction on round ligaments) or **Haultain procedure** (posterior cervical incision); rarely hysterectomy; (8) postpartum monitoring for recurrence + hemorrhage + DIC; (9) document mechanism + counsel; future pregnancy increased risk recurrence

---

Uterine inversion: rare emergency. Recognize → call help → immediate manual replacement (Johnson) → relaxation → replace → uterotonics. Hemorrhage + shock common. Surgical (Huntington, Haultain) if manual fails. Risk: cord traction, fundal pressure, accreta.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'Williams Obstetrics 26e Ch 41; ALSO course', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 28 ปี G1P1 immediately after vaginal delivery — sudden hypotension + uterus not palpable abdominally + mass in vagina + heavy bleeding

V/S: BP 78/48, HR 132
Uterus: not palpable on abdominal exam, palpable mass at vagina
Bleeding: heavy ongoing'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 26 ปี G1P0 GA 36 wk GBS-positive at 36 wk screening — มาในระยะ labor, contractions q 4 นาที, cervix 4 cm dilated, ROM 2 hr ago

V/S: BP 118/72, HR 92, Temp 37.0
Fetal: FHR 142 reactive
No penicillin allergy', '[{"label":"A","text":"Wait until baby born then start antibiotic"},{"label":"B","text":"Group B Streptococcus (GBS) Intrapartum Prophylaxis"},{"label":"C","text":"Cesarean delivery"},{"label":"D","text":"Topical antibiotic"},{"label":"E","text":"Antifungal"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Group B Streptococcus (GBS) Intrapartum Prophylaxis** (Thai/CDC universal screening at 36+0-37+6 wk; treat: positive culture, prior GBS-affected infant, GBS bacteriuria current pregnancy, unknown status with risk factors — < 37 wk, ROM > 18 hr, fever ≥ 38, intrapartum NAAT positive): (1) **penicillin G 5 million U IV load then 2.5-3 million U IV q 4 hr** until delivery (first-line; ≥ 4 hr before delivery for adequacy); alternative ampicillin 2 g IV load then 1 g q 4 hr; (2) **non-anaphylactic penicillin allergy** (mild rash) → cefazolin 2 g IV load then 1 g q 8 hr; (3) **severe penicillin allergy (anaphylaxis, angioedema, urticaria)** → clindamycin 900 mg IV q 8 hr ถ้า isolate sensitive (request susceptibility); vancomycin 20 mg/kg IV q 8 hr (max 2 g/dose) ถ้า clinda-resistant; (4) **goal** — ≥ 2 doses or ≥ 4 hr before delivery for optimal effect; (5) prevents early-onset neonatal GBS sepsis (50-80% reduction); does NOT prevent late-onset (after 7 d); (6) cesarean before labor + intact membranes — NOT needed; (7) **PPROM < 37 wk** — start antibiotics including GBS coverage (ampicillin); (8) document GBS status + antibiotic timing — neonatal team uses for newborn risk stratification

---

GBS prophylaxis: universal screen 36-37+6 wk. PCN G first-line. Allergy → cefazolin, clinda (if sensitive), vanc. ≥ 4 hr before delivery optimal. Reduces early-onset neonatal GBS sepsis. Not for elective C/S with intact membranes.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Committee Opinion 797: Prevention of GBS Early-Onset Disease 2020; CDC 2019', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 26 ปี G1P0 GA 36 wk GBS-positive at 36 wk screening — มาในระยะ labor, contractions q 4 นาที, cervix 4 cm dilated, ROM 2 hr ago

V/S: BP 118/72, HR 92, Temp 37.0
Fetal: FHR 142 reactive
No penicillin allergy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 26 ปี G1P0 GA 10 wk มาด้วยอาการอาเจียนรุนแรง > 15 ครั้ง/วัน × 1 สัปดาห์ ไม่กินอาหารได้, weight loss 4 kg (8% body weight)

V/S: BP 96/60, HR 116, RR 18
Gen: dehydrated, dry mucous membranes
Lab: Na 132, K 2.8, Cl 88, HCO3 32, BUN 28, Cr 0.9, ketone 3+ urine, TSH 0.05, free T4 normal, US: singleton, no molar', '[{"label":"A","text":"Discharge home with PRN antiemetic"},{"label":"B","text":"admit + IV hydration"},{"label":"C","text":"Cesarean immediately"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Discharge with PO antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Hyperemesis Gravidarum** (severe N/V > 5% weight loss + dehydration + electrolyte/acid-base abnormalities + ketonuria; biochemical hyperthyroidism common — hCG cross-reacts TSH receptor — usually transient, NO antithyroid needed unless persistent + clinical signs): (1) **admit + IV hydration** — NS or LR with **dextrose** + potassium replacement (K 2.8 = severe) — careful potassium repletion 20-40 mEq/L; correct Na slowly (avoid CPM); (2) **thiamine 100 mg IV before dextrose** (Wernicke prophylaxis); (3) **antiemetics** — stepwise: (a) pyridoxine (B6) 10-25 mg q 6-8 hr ± doxylamine 12.5-20 mg (Diclegis/Bonjesta — first-line); (b) add dimenhydrinate, diphenhydramine, prochlorperazine, promethazine; (c) **ondansetron** 4-8 mg IV/PO (avoid first trimester ideally — small cleft palate signal; usually OK if needed); (d) **metoclopramide** 10 mg IV/PO; (e) **methylprednisolone** 16 mg IV/PO q 8 hr (refractory); (4) NPO → clears → small frequent bland meals (BRAT, dry crackers in morning); (5) thiamine, multivitamin (folate); (6) **rule out** — molar pregnancy (US, hCG very high), multifetal (US), hyperthyroid (Graves vs hCG-mediated — if T3 high + TRAb +, treat with PTU first trimester then methimazole 2nd-3rd), DKA, UTI, hepatitis, pancreatitis, gastroenteritis; (7) NG/TPN refractory cases (rare); (8) social support + counseling (psych comorbidity); (9) ginger, acupressure, lifestyle complementary

---

HEG vs morning sickness — severity. Dx: > 5% weight loss + dehydration + ketonuria + electrolyte imbalance. Transient hyperthyroidism (hCG-mediated) — no antithyroid usually. Stepwise antiemetic. IV thiamine before dextrose (Wernicke). Rule out molar, multifetal, hyperthyroid, etc. Hospital ถ้า severe.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin 189: Nausea and Vomiting of Pregnancy 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 26 ปี G1P0 GA 10 wk มาด้วยอาการอาเจียนรุนแรง > 15 ครั้ง/วัน × 1 สัปดาห์ ไม่กินอาหารได้, weight loss 4 kg (8% body weight)

V/S: BP 96/60, HR 116, RR 18
Gen: dehydrated, dry mucous membranes
Lab: Na 132, K 2.8, Cl 88, HCO3 32, BUN 28, Cr 0.9, ketone 3+ urine, TSH 0.05, free T4 normal, US: singleton, no molar'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 42 ปี G0P0 มา OPD ด้วยอาการประจำเดือนผิดปกติ — heavy + irregular × 8 เดือน, intermenstrual spotting, ปวด pelvic chronic

V/S: BP 124/76, HR 84
Pelvic: enlarged irregular uterus 14-week size, no adnexal mass
US: multiple intramural + submucosal fibroids, largest 6 cm submucosal
Lab: Hb 8.4, ferritin 8, TSH normal, β-hCG negative, endometrial biopsy: benign proliferative', '[{"label":"A","text":"Hysterectomy เลย"},{"label":"B","text":"PALM = structural"},{"label":"C","text":"Antibiotic only"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Wait + observe only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Symptomatic uterine fibroids (PALM-COEIN: **PALM = structural** — Polyp, Adenomyosis, Leiomyoma, Malignancy; **COEIN = non-structural** — Coagulopathy, Ovulatory, Endometrial, Iatrogenic, Not yet classified) + iron-deficiency anemia: stepwise management individualized to fertility desire, size, symptoms: (1) **medical** — (a) iron supplementation (PO ferrous sulfate 200 mg TID or IV iron sucrose ถ้า PO intolerant/severe); (b) **GnRH agonist (leuprolide)** — temporary fibroid shrinkage + amenorrhea preoperative (3-6 mo, add-back therapy); (c) **GnRH antagonist (elagolix/relugolix)** + add-back — newer oral options; (d) **ulipristal acetate** — selective progesterone receptor modulator (restricted hepatotoxicity); (e) **LNG-IUD** ถ้า uterus < 12 wk + fibroid not distorting cavity — reduces HMB; (f) tranexamic acid 1 g TID during menses; (g) NSAIDs; (h) combined OCP / progestin for cycle control; (2) **procedural** — (a) **hysteroscopic myomectomy** for submucosal — first choice for submucosal symptomatic fibroids if fertility desired; (b) **uterine artery embolization (UAE)** — radiologic, preserves uterus, not first choice if fertility planned; (c) **MRI-guided focused US (MRgFUS)**; (d) **myomectomy (lap/open/robotic)** — fertility preservation; (e) **endometrial ablation** ถ้า no fertility + no submucosal large; (3) **definitive — hysterectomy** ถ้า complete + done childbearing + symptoms refractory; (4) discuss morcellation risk (occult sarcoma); (5) Thai context — endometrial biopsy ก่อน 45+ to rule out hyperplasia/cancer in AUB

---

AUB-L (leiomyoma) in PALM-COEIN. Fibroids: submucosal causes HMB, intramural may, subserosal less. Management individualized: fertility, size, symptoms. Hysteroscopic for submucosal. UAE preserves uterus. Hysterectomy definitive. AUB age > 45 → endometrial biopsy.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'FIGO PALM-COEIN; ACOG Practice Bulletin 228: Management of Symptomatic Uterine Leiomyomas 2021', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 42 ปี G0P0 มา OPD ด้วยอาการประจำเดือนผิดปกติ — heavy + irregular × 8 เดือน, intermenstrual spotting, ปวด pelvic chronic

V/S: BP 124/76, HR 84
Pelvic: enlarged irregular uterus 14-week size, no adnexal mass
US: multiple intramural + submucosal fibroids, largest 6 cm submucosal
Lab: Hb 8.4, ferritin 8, TSH normal, β-hCG negative, endometrial biopsy: benign proliferative'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 30 ปี G0P0 มา OPD ด้วยอาการ chronic pelvic pain + dysmenorrhea progressive × 5 ปี + dyspareunia + cyclic dyschezia + infertility 2 ปี

V/S: BP 116/72, HR 80
Pelvic: tender uterosacral ligament + nodularity, fixed retroverted uterus, R adnexal tenderness
US TV: R ovarian endometrioma 4 cm + deep infiltrating endometriosis suspected on rectovaginal septum
CA-125 78', '[{"label":"A","text":"Reassurance only"},{"label":"B","text":"NSAIDs + combined OCP"},{"label":"C","text":"Cesarean delivery"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Endometriosis (ectopic endometrial-like tissue outside uterus — peritoneum, ovaries, deep infiltrating in rectovaginal septum/bowel/bladder/diaphragm; ASRM staging I-IV; cause: retrograde menstruation + others; diagnosis: clinical + imaging + laparoscopy with biopsy gold standard): stepwise treatment by symptoms + fertility goals: (1) **medical (pain)** — first-line **NSAIDs + combined OCP** (cyclic or continuous) suppresses ovulation; second-line **progestin-only** (norethindrone, DMPA, LNG-IUD, dienogest); third-line **GnRH agonist (leuprolide)** + add-back therapy (HRT) to mitigate hypoestrogenic SE; **GnRH antagonist** (elagolix) oral; aromatase inhibitor letrozole adjunct refractory; (2) **surgical** — laparoscopy excision/ablation of endometriotic implants + cystectomy for endometrioma (improves pain + fertility; but ovarian reserve risk with cystectomy); deep infiltrating endometriosis often multidisciplinary (colorectal/urology); hysterectomy ± BSO definitive if completed childbearing + refractory; (3) **infertility** — referral REI; **IVF** highly effective (endometriosis may have ovarian factor + tubal factor + peritoneal); ovarian stimulation + IUI in mild-moderate; surgical excision of endometrioma controversial pre-IVF (may ↓ AMH); (4) **lifestyle** — exercise, diet, mind-body; (5) chronic pain — multidisciplinary pain mgmt, PFPT, neuropathic agents; (6) follow long-term — recurrence common; (7) cancer risk slightly ↑ (clear cell, endometrioid ovarian)

---

Endometriosis: pelvic pain + dysmenorrhea + dyspareunia + infertility. Laparoscopy = gold standard dx. NSAIDs + OCP first-line. Surgical excision + IVF for infertility. Recurrence common. CA-125 nonspecific. ASRM staging.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin 114: Management of Endometriosis; ESHRE Guideline Endometriosis 2022', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 30 ปี G0P0 มา OPD ด้วยอาการ chronic pelvic pain + dysmenorrhea progressive × 5 ปี + dyspareunia + cyclic dyschezia + infertility 2 ปี

V/S: BP 116/72, HR 80
Pelvic: tender uterosacral ligament + nodularity, fixed retroverted uterus, R adnexal tenderness
US TV: R ovarian endometrioma 4 cm + deep infiltrating endometriosis suspected on rectovaginal septum
CA-125 78'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 26 ปี G0P0 มา OPD ด้วยอาการประจำเดือนมาไม่สม่ำเสมอ (oligomenorrhea — 4-6 cycles/yr) + hirsutism + acne + obesity (BMI 32) × 5 ปี + difficulty conceiving 1 ปี

V/S: BP 126/82, HR 84
Gen: acanthosis nigricans, hirsutism (mFG 12)
Lab: testosterone total 78 (mildly elevated), DHEAS WNL, 17-OHP normal, prolactin normal, TSH normal, FSH 5, LH 14 (ratio 2.8), AMH 8.5
US TV: bilateral polycystic ovaries (> 20 follicles per ovary 2-9 mm + volume 12 mL) + endometrium 4 mm, last menses 3 mo ago', '[{"label":"A","text":"Reassurance — try harder"},{"label":"B","text":"Polycystic Ovary Syndrome (PCOS)"},{"label":"C","text":"Cesarean delivery"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Polycystic Ovary Syndrome (PCOS)** — Rotterdam criteria (need ≥ 2 of 3): (a) oligo/anovulation, (b) clinical/biochemical hyperandrogenism, (c) polycystic ovaries on US; exclude other causes (thyroid, prolactin, CAH 17-OHP, Cushing, androgen-secreting tumor); (1) **lifestyle** — weight loss 5-10% improves cycles + ovulation + insulin resistance + metabolic; diet + exercise; (2) **metabolic workup** — fasting glucose / OGTT (T2DM risk 2-4×), lipid panel, BP, LFT (NAFLD); (3) **endometrial protection** (anovulation → unopposed estrogen → hyperplasia/cancer risk); cyclic progestin (medroxyprogesterone 10 mg × 12 d every 1-3 mo) or COCP or LNG-IUD; **endometrial biopsy ถ้า prolonged amenorrhea > 1 yr or endometrium > 7-10 mm**; (4) **cycle regulation + hyperandrogenism** — COCP (esp with drospirenone — anti-mineralocorticoid + androgenic ↓); spironolactone 50-200 mg/d for hirsutism (after 6 mo COCP if persistent); add COCP with spironolactone (avoid pregnancy on spironolactone); cosmetic — laser, eflornithine; (5) **ovulation induction for fertility** — letrozole 2.5-7.5 mg d 3-7 (first-line per PCOS network — superior to clomiphene); clomiphene citrate; metformin adjunct or alone (esp obese, insulin resistant); gonadotropins or IVF if refractory; **laparoscopic ovarian drilling** alternative; (6) metformin for metabolic + DM prevention; (7) screen depression/anxiety (common); (8) sleep apnea; (9) long-term — DM, CVD, endometrial cancer surveillance; (10) preconception counseling

---

PCOS Rotterdam criteria (Thai/AE-PCOS adopted). Manifestations: oligomenorrhea, hyperandrogenism, PCO morphology, insulin resistance, metabolic syndrome. Lifestyle first. COCP cycle + hyperandrogenism. Letrozole first-line ovulation. Metformin metabolic. Endometrial protection. Long-term metabolic + cancer surveillance.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'International PCOS Guideline 2023; ACOG Practice Bulletin 194', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 26 ปี G0P0 มา OPD ด้วยอาการประจำเดือนมาไม่สม่ำเสมอ (oligomenorrhea — 4-6 cycles/yr) + hirsutism + acne + obesity (BMI 32) × 5 ปี + difficulty conceiving 1 ปี

V/S: BP 126/82, HR 84
Gen: acanthosis nigricans, hirsutism (mFG 12)
Lab: testosterone total 78 (mildly elevated), DHEAS WNL, 17-OHP normal, prolactin normal, TSH normal, FSH 5, LH 14 (ratio 2.8), AMH 8.5
US TV: bilateral polycystic ovaries (> 20 follicles per ovary 2-9 mm + volume 12 mL) + endometrium 4 mm, last menses 3 mo ago'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'คู่สามีภรรยา หญิงอายุ 32 ชาย 34 trying to conceive × 18 เดือน — failed; หญิง cycles regular 28 d, BMI 22, prior healthy; ชาย no comorbidity

V/S: BP 110/68, HR 76
Pelvic exam: normal
Lab: TSH normal, prolactin normal, AMH 2.1, FSH d3 7.8, semen analysis: volume 2.5 mL, concentration 22 million/mL, motility 48%, normal morphology 6%
HSG: bilateral tubal patency, normal cavity', '[{"label":"A","text":"Conceive naturally — wait more 6 mo"},{"label":"B","text":"ovulation induction + IUI 3-6 cycles"},{"label":"C","text":"Cesarean immediately"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Methotrexate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Infertility workup** (failure to conceive after 12 mo unprotected intercourse; or 6 mo if ≥ 35 yr or known risk): with normal AMH/FSH (ovarian reserve OK), regular cycles (likely ovulatory), patent tubes (HSG normal), normal semen — unexplained infertility (~ 15%); confirm: (1) **ovulation** — day 21 (mid-luteal) progesterone > 3 ng/mL = ovulatory; basal body temp, OPK (LH surge); (2) **ovarian reserve** — AMH (anti-Müllerian hormone), antral follicle count (AFC), day 3 FSH/E2 — AMH 2.1 = adequate; (3) **tubal patency** — HSG or HyCoSy; sonohysterography for cavity; (4) **semen analysis** — WHO 2021 ref values (concentration > 16 million/mL, motility > 42%, normal morphology > 4%) — this is normal; repeat 2-3 mo apart; (5) **uterine cavity** — saline infusion sonography or hysteroscopy; (6) **management** — start with **ovulation induction + IUI 3-6 cycles** for unexplained infertility (letrozole or clomiphene + IUI); if fail → **IVF** (35+ — go to IVF sooner); (7) lifestyle — folic acid 400-800 mcg, healthy weight, no smoking/alcohol, manage stress; (8) genetic counseling ถ้า history; (9) **emotional support** — psych counseling, infertility-related distress common; (10) explain stepwise: IUI → IVF → donor gametes → adoption per couple preference + finances + Thai laws

---

Infertility workup. Female: ovulation, ovarian reserve, tubal, uterine. Male: SA WHO 2021. Lifestyle. Unexplained: 3-6 cycles OI/IUI → IVF. Age 35+ shorten timeline. AMH + AFC predict response. Emotional support critical.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ASRM Practice Committee Reports; WHO Semen Analysis 6e 2021', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'คู่สามีภรรยา หญิงอายุ 32 ชาย 34 trying to conceive × 18 เดือน — failed; หญิง cycles regular 28 d, BMI 22, prior healthy; ชาย no comorbidity

V/S: BP 110/68, HR 76
Pelvic exam: normal
Lab: TSH normal, prolactin normal, AMH 2.1, FSH d3 7.8, semen analysis: volume 2.5 mL, concentration 22 million/mL, motility 48%, normal morphology 6%
HSG: bilateral tubal patency, normal cavity'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 24 ปี LMP regular 28 d cycles, มา OPD ขอ contraception — no contraindication, no smoking, BMI 22, planning conception ใน 2 ปี

V/S: BP 116/72, HR 76
Gen: well
Pap smear normal 1 yr ago', '[{"label":"A","text":"Only OCP available"},{"label":"B","text":"Contraception counseling — tiered effectiveness approach (CDC/WHO)"},{"label":"C","text":"Cesarean delivery"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Contraception counseling — tiered effectiveness approach (CDC/WHO)**: discuss all reversible methods, allow informed choice: (1) **most effective (LARC)** — **levonorgestrel IUD** (Mirena 5-8 yr; Kyleena 5 yr; Skyla 3 yr) — failure < 1%; reduces menstrual blood loss; **copper IUD** (Paragard 10-12 yr) — non-hormonal, emergency contraception within 5 d; **etonogestrel implant** (Nexplanon 3-5 yr per evidence) — failure < 1%; (2) **highly effective** — **DMPA injection** q 3 mo (delayed return to fertility, bone density caution); **combined hormonal** — COCP (estrogen + progestin, daily); transdermal patch (weekly); vaginal ring (monthly); failure 7% typical use; **progestin-only pill** — strict timing; (3) **less effective** — diaphragm, sponge, cervical cap, male condom (also STI), female condom, withdrawal, fertility awareness; (4) **permanent** — tubal ligation/Essure (discontinued), vasectomy; (5) **emergency contraception** — copper IUD (most effective, 0.1%), ulipristal acetate 30 mg PO (up to 5 d), levonorgestrel 1.5 mg (up to 3 d, less effective if obese); (6) **U.S. MEC** — categories 1-4 contraindications (e.g., estrogen contraindicated < 6 wk postpartum breastfeeding, > 35 + smoking > 15 cigs, migraine with aura, history VTE, uncontrolled HT, recent VTE, breast cancer); (7) **counseling** — failure rates, return to fertility, STI protection (only condoms), side effects, cost, ease; (8) **shared decision-making**; (9) screening Thai guidelines: pap, STI; (10) preconception planning given 2-yr horizon — LARC easily removed when ready (immediate return to fertility), IUD or implant first-line recommendation per CDC tiered counseling

---

Tiered contraception counseling — start with most effective (LARC). U.S. MEC contraindications. Informed choice. LARC: IUD (LNG, Cu), implant. Highly effective: DMPA, COCP, ring, patch. Less: barrier, fertility awareness. Emergency contraception: Cu IUD > UPA > LNG. Return to fertility.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'CDC US Medical Eligibility Criteria 2016/2024 updates; ACOG LARC Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 24 ปี LMP regular 28 d cycles, มา OPD ขอ contraception — no contraindication, no smoking, BMI 22, planning conception ใน 2 ปี

V/S: BP 116/72, HR 76
Gen: well
Pap smear normal 1 yr ago'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 19 ปี nulliparous มาที่ห้องฉุกเฉินด้วยอาการ unprotected intercourse 18 ชั่วโมงก่อน — ขอ emergency contraception

V/S: BP 116/72, HR 84
Gen: well, no symptoms
LMP 14 d ago, mid-cycle (high pregnancy risk)
No current contraception, no STI risk factors stated', '[{"label":"A","text":"Misoprostol high dose"},{"label":"B","text":"Emergency Contraception options (most → least effective)"},{"label":"C","text":"Antibiotic"},{"label":"D","text":"Wait + see"},{"label":"E","text":"Misoprostol abortion"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Emergency Contraception options (most → least effective): (1) **Copper IUD** — most effective EC (failure < 0.1%), insert within 120 hr (5 d) post-intercourse; provides ongoing contraception 10-12 yr; not affected by BMI; rule out current pregnancy + STI screen; (2) **Ulipristal Acetate (UPA, Ella) 30 mg PO single dose** — selective progesterone receptor modulator, effective up to 5 d; superior to LNG especially day 4-5; effective in higher BMI; available Thailand; delay start of hormonal contraception 5 d after UPA; (3) **LNG-IUD (Mirena 52 mg)** — recently shown non-inferior to copper IUD in EC trial; (4) **Levonorgestrel 1.5 mg PO single dose (Postinor)** — most accessible, up to 72 hr (declining efficacy day 3-5); less effective if BMI > 25-30; OTC in Thailand; can be repeated; (5) **Yuzpe regimen** — combined estrogen-progestin (high dose COCP) — older, more nausea, less effective; **management** — assess timing of intercourse, LMP, BMI, future contraception plan; pregnancy test if delay or late period; STI screen if risk; **transition** — start ongoing contraception immediately after LNG (or 5 d after UPA); offer LARC discussion; **counsel** — EC reduces but does not eliminate risk, no protection against future intercourse, no STI protection, side effects (nausea, irregular bleeding), follow-up if no menses in 3 wk

---

EC: Cu IUD > UPA > LNG-IUD ≈ UPA > LNG > Yuzpe. Timing critical — Cu IUD/UPA effective up to 5 d. Counsel ongoing contraception. STI screen. Pregnancy test if late. BMI affects LNG efficacy. UPA may delay ovulation more effectively. Thailand: LNG OTC.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'WHO Emergency Contraception 2018; CDC US SPR Contraceptive Use', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 19 ปี nulliparous มาที่ห้องฉุกเฉินด้วยอาการ unprotected intercourse 18 ชั่วโมงก่อน — ขอ emergency contraception

V/S: BP 116/72, HR 84
Gen: well, no symptoms
LMP 14 d ago, mid-cycle (high pregnancy risk)
No current contraception, no STI risk factors stated'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 48 ปี perimenopausal มา OPD ด้วยอาการ heavy menstrual bleeding (HMB) + occasional intermenstrual bleeding × 6 เดือน, soaking pads, Hb 9.2, weight 78 kg BMI 30

V/S: BP 132/82, HR 86
Pelvic: uterus 8 wk size, no adnexal mass
US: endometrium 12 mm thickened, irregular
Endometrial biopsy: complex endometrial hyperplasia WITHOUT atypia', '[{"label":"A","text":"Reassurance only"},{"label":"B","text":"Endometrial hyperplasia WITHOUT atypia"},{"label":"C","text":"Hysterectomy without trial of progestin"},{"label":"D","text":"Antibiotic"},{"label":"E","text":"Wait until menopause"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Endometrial hyperplasia WITHOUT atypia** (low progression risk to endometrioid endometrial cancer ~ 1-3% over 20 yr; vs **WITH atypia** = endometrial intraepithelial neoplasia EIN ~ 30% concurrent or progression cancer): management: (1) **identify + correct risk factors** — obesity (weight loss), unopposed estrogen, anovulation (PCOS), tamoxifen, HRT, Lynch syndrome; (2) **first-line — progestin therapy** — **LNG-IUD (Mirena)** preferred (regression > 90%, fewer side effects) × 6 mo then re-biopsy; (3) **alternative oral progestins** — medroxyprogesterone acetate 10-20 mg daily continuous or cyclic 12-14 d/mo, megestrol acetate 40-80 mg/d, norethindrone; (4) **follow-up** — endometrial biopsy every 6 mo until 2 consecutive negative; (5) **persistence/progression** → hysterectomy ถ้า no fertility desire OR atypia develops; (6) **atypia (EIN)** — hysterectomy preferred (definitive, ~ 30% concurrent cancer); progestin if fertility-sparing (LNG-IUD or megestrol) + sampling q 3 mo; (7) treat anemia — iron, transfusion if severe; (8) genetic counseling — Lynch syndrome screening (universal in endometrial cancer; family history); (9) Thai AUB-PALM-COEIN — perimenopausal AUB → endometrial sampling mandatory (rule out hyperplasia/cancer); (10) lifestyle — weight loss reduces estrogen + recurrence

---

Endometrial hyperplasia: WITHOUT atypia 1-3% cancer risk; WITH atypia (EIN) 30% concurrent cancer → hysterectomy first-line (or fertility-sparing progestin). Without atypia: LNG-IUD first-line. Follow biopsy q 6 mo. Risk factors: obesity, unopposed estrogen, anovulation, tamoxifen. Lynch screening.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Committee Opinion 631: Endometrial Intraepithelial Neoplasia; SGO/ASCCP Endometrial Hyperplasia', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 48 ปี perimenopausal มา OPD ด้วยอาการ heavy menstrual bleeding (HMB) + occasional intermenstrual bleeding × 6 เดือน, soaking pads, Hb 9.2, weight 78 kg BMI 30

V/S: BP 132/82, HR 86
Pelvic: uterus 8 wk size, no adnexal mass
US: endometrium 12 mm thickened, irregular
Endometrial biopsy: complex endometrial hyperplasia WITHOUT atypia'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 32 ปี G2P2 พบ Pap smear ASCUS, HPV reflex positive (high-risk types incl 16/18 — not specified), no symptoms

V/S: BP 116/72, HR 80
Pelvic exam: WNL, no visible lesion', '[{"label":"A","text":"Repeat Pap in 6 months"},{"label":"B","text":"ASCUS Pap + HPV high-risk positive (per ASCCP 2019 risk-based guidelines)"},{"label":"C","text":"Discharge — no follow-up"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Methotrexate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** ASCUS Pap + HPV high-risk positive (per ASCCP 2019 risk-based guidelines): (1) **colposcopy** indicated (≥ 4% immediate CIN3+ risk); biopsy any visible lesion + ECC if no lesion seen; (2) **colposcopy findings → management**: (a) CIN1 → conservative observation, repeat HPV+cyto 1 yr (most regress); (b) CIN2 → reasonable to treat or observe (CIN2 = intermediate, often regresses esp in young women); (c) CIN2 + age < 25 → observe with cyto + colpo q 6 mo × 2 yr; (d) CIN3 → treatment — excision (LEEP, cold knife cone, laser) preferred over ablation; **HPV 16 → higher risk + immediate colposcopy** even with negative cyto in some scenarios; (3) **HPV 16/18 with abnormal cyto** → expedited treatment (LEEP) without biopsy may be considered in select adults (not pregnant, not young); (4) **post-treatment surveillance** — HPV + cyto co-test 6 mo + 12 mo + 24 mo, then q 3 yr for 25 yr; (5) **pregnancy considerations** — colposcopy safe; defer treatment unless invasive cancer suspected; ECC contraindicated; (6) **HPV vaccination** — Thailand free for girls grade 5 (Gardasil 9 or 4-valent); vaccinate up to age 26 catch-up, up to 45 individualized; vaccination after treatment reduces recurrence; (7) **risk factors** — smoking, HIV/immunosuppression, multiple partners, early sexual debut, OCP > 5 yr

---

ASCCP 2019 risk-based management. ASCUS + HPV+ → colposcopy. CIN1 observe, CIN2 treat or observe (young), CIN3 treat (excision). HPV 16 expedited treatment select. Post-treatment surveillance long-term. HPV vaccine prevention + post-treatment recurrence reduction.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ASCCP Risk-Based Management 2019; Thai Cervical Cancer Screening Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 32 ปี G2P2 พบ Pap smear ASCUS, HPV reflex positive (high-risk types incl 16/18 — not specified), no symptoms

V/S: BP 116/72, HR 80
Pelvic exam: WNL, no visible lesion'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 28 ปี G1P0 GA 10 wk LMP, β-hCG 250,000 (uterine size GA 18 wk discrepancy), severe hyperemesis + early-onset hypertension + hyperthyroid symptoms

V/S: BP 158/96, HR 118 (resting tachy), Temp 37.2
Gen: tremor, sweating
Fetal: US: no fetus, snowstorm/multivesicular uterine cavity, theca lutein cysts bilateral 6 cm, no metastasis seen on CXR/abdo US
Lab: TSH 0.02, FT4 elevated, β-hCG 350,000', '[{"label":"A","text":"Continue pregnancy with observation"},{"label":"B","text":"Complete Hydatidiform Mole"},{"label":"C","text":"Continue pregnancy + watch"},{"label":"D","text":"Methotrexate alone without evacuation"},{"label":"E","text":"Hysterectomy first-line"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Complete Hydatidiform Mole** (Gestational Trophoblastic Disease — GTD): (1) **suction D&C** — definitive treatment under GA with oxytocin (started AFTER cervix dilated to reduce trophoblast embolization); send products for histology + ploidy (complete = diploid 46XX/46XY paternal origin; partial = triploid); (2) **Rh-Ig** if Rh-negative; (3) **β-hCG monitoring weekly until 3 consecutive negative → monthly × 6 mo** — surveillance for post-molar gestational trophoblastic neoplasia (GTN — 15-20% complete mole, 1-5% partial); (4) **effective contraception during surveillance** (avoid new pregnancy confusing β-hCG); avoid IUD until uterus involuted; OCP safe; (5) **hyperthyroidism (hCG cross-reaction)** — usually resolves after evacuation; β-blocker (propranolol) for symptoms; avoid thyrotoxic crisis during evacuation; (6) **theca lutein cysts** — resolve spontaneously over months; (7) **early-onset preeclampsia < 20 wk** = mole red flag (hCG); (8) **post-molar GTN diagnosis** (FIGO 2000): plateau hCG × 4 wk, rise × 3 wk, > 6 mo persistent hCG, or histology choriocarcinoma → **chemotherapy** (methotrexate ± actinomycin D for low-risk; EMA-CO for high-risk); FIGO/WHO risk score determines regimen; (9) **referral** — gestational trophoblastic disease center; (10) future pregnancy — recurrence ~ 1-2% — early US first trimester; histology of products

---

Complete hydatidiform mole: snowstorm US, very high hCG, hyperthyroid (hCG-TSH cross), early HTN, hyperemesis, theca lutein cysts. Suction D&C + β-hCG surveillance + contraception. Post-molar GTN 15-20% complete → chemo. Partial mole < 5% GTN risk. Choriocarcinoma highly chemo-sensitive.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'FIGO Cancer Report GTD 2021; RCOG Green-top 38 GTD', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 28 ปี G1P0 GA 10 wk LMP, β-hCG 250,000 (uterine size GA 18 wk discrepancy), severe hyperemesis + early-onset hypertension + hyperthyroid symptoms

V/S: BP 158/96, HR 118 (resting tachy), Temp 37.2
Gen: tremor, sweating
Fetal: US: no fetus, snowstorm/multivesicular uterine cavity, theca lutein cysts bilateral 6 cm, no metastasis seen on CXR/abdo US
Lab: TSH 0.02, FT4 elevated, β-hCG 350,000'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 56 ปี postmenopausal × 5 yr มาด้วย postmenopausal bleeding × 2 mo, no HRT use

V/S: BP 138/84, HR 78
Gen: BMI 35, hypertension, T2DM
Pelvic: vagina atrophic, cervix benign, uterus 6 wk size, no adnexal mass
US: endometrium 15 mm with irregular cystic areas
Endometrial biopsy: endometrioid adenocarcinoma grade 1', '[{"label":"A","text":"Discharge — observation"},{"label":"B","text":"Endometrial adenocarcinoma"},{"label":"C","text":"Antibiotic only"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Wait + repeat biopsy 6 mo"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Endometrial adenocarcinoma** (most common gynecologic malignancy in developed countries; Thai 2nd-3rd most common GYN; type I endometrioid — estrogen-related, well-differentiated, better prognosis; type II serous/clear cell — non-estrogen, worse prognosis): (1) **staging workup** — pelvic MRI (myometrial invasion, cervical), CT chest/abdo/pelvis (or PET-CT), CA-125, CBC/CMP, EKG, anesthesia eval; Lynch syndrome screening universal (MSI/IHC tumor) → genetic counseling; (2) **surgical staging — gold standard** — **total hysterectomy + bilateral salpingo-oophorectomy + sentinel lymph node biopsy** (or pelvic ± paraaortic lymphadenectomy in high-risk); peritoneal cytology no longer formal staging but recorded; minimally invasive (lap or robotic) preferred — equivalent oncologic + less morbidity (LAP2/LACE); (3) **adjuvant therapy** based on FIGO stage + risk: (a) Stage IA, grade 1-2 — observation often; (b) IA grade 3 / IB / II — vaginal brachytherapy ± EBRT; (c) Stage III-IVA — pelvic EBRT + chemo (carbo/paclitaxel); (d) Stage IV/recurrent — chemo + immunotherapy (pembrolizumab + lenvatinib for MSI-H or pMMR); (4) **fertility-sparing** (rare in this patient given age + grade 1 but for younger women with stage IA grade 1) — high-dose progestin (LNG-IUD + megestrol) + sampling q 3 mo; (5) **co-morbidities management** — DM, HT, weight loss; (6) **surveillance** — exam + symptoms q 3-6 mo × 2 yr, then q 6 mo × 3 yr, then annual; imaging if symptoms; (7) **prognosis** — 5-yr survival stage I ~ 85-95%, stage III 50-65%, stage IV 15-20%

---

Endometrial cancer: postmenopausal bleeding = cancer until proven otherwise. Endometrial biopsy/D&C diagnostic. Surgical staging TH-BSO + SLN. Type I endometrioid majority. Adjuvant per stage/grade. Lynch screening universal. New: pembro + lenvatinib for MSI-H/pMMR.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'FIGO Cancer Report Endometrial Cancer 2021; NCCN Uterine Neoplasms', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 56 ปี postmenopausal × 5 yr มาด้วย postmenopausal bleeding × 2 mo, no HRT use

V/S: BP 138/84, HR 78
Gen: BMI 35, hypertension, T2DM
Pelvic: vagina atrophic, cervix benign, uterus 6 wk size, no adnexal mass
US: endometrium 15 mm with irregular cystic areas
Endometrial biopsy: endometrioid adenocarcinoma grade 1'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 64 ปี postmenopausal × 12 yr มาด้วย bloating + early satiety + weight loss 5 kg × 3 mo + chronic pelvic discomfort

V/S: BP 124/76, HR 88
Gen: thin, ascites + on exam
Pelvic: bilateral fixed adnexal masses 10-12 cm, nodularity in cul-de-sac
US: bilateral complex adnexal masses + ascites + omental thickening
CA-125 850, CEA 12, β-hCG negative
CT C/A/P: bilateral ovarian masses + omental caking + ascites + peritoneal carcinomatosis', '[{"label":"A","text":"Discharge — observation"},{"label":"B","text":"Suspected advanced ovarian cancer"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Hysterectomy only without staging"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Suspected advanced ovarian cancer** (epithelial — high-grade serous most common; Stage IIIC-IV by CT findings): (1) **pre-treatment workup** — paracentesis for cytology, CT or PET-CT, CA-125 + HE4 + ROMA; rule out non-gynecologic primary (GI scope if mucinous, breast exam, CEA, CA 19-9); (2) **multidisciplinary team** — GYN-onc, medical onc, radiology, pathology, palliative care; (3) **two strategies**: (a) **primary debulking surgery (PDS)** if optimal cytoreduction feasible (no residual disease ideal — R0) + medically fit — laparotomy, TH + BSO, omentectomy, lymphadenectomy, peritoneal stripping, bowel/diaphragm/splenectomy as needed; (b) **neoadjuvant chemo (NACT) + interval debulking surgery (IDS)** — preferred ถ้า extensive disease + poor PS + comorbidities (CHORUS, EORTC trials show non-inferior in suboptimal candidates with less morbidity); 3 cycles carbo/paclitaxel → IDS → 3 more cycles; (4) **maintenance therapy** — PARP inhibitors (olaparib, niraparib) for BRCA1/2 mutation OR HRD-positive (homologous recombination deficiency); bevacizumab in maintenance; pembrolizumab in select; (5) **genetic testing** — BRCA1/2 germline + somatic, HRD, cascade family testing (Lynch panel); (6) **palliative care integration** — early integration improves outcomes (Temel NEJM 2010 ovarian); (7) **surveillance** — exam, CA-125, imaging if symptoms; (8) Thai/RTCOG protocols + multidisciplinary; (9) **prognosis** — stage IIIC 5-yr ~ 30-40%, stage IV ~ 20%; (10) recurrence common — platinum-sensitive vs resistant defines second-line; (11) clinical trial enrollment

---

Advanced ovarian cancer: bloating, early satiety, ascites, bilateral masses, ↑ CA-125. PDS vs NACT-IDS. Optimal debulking (R0 ideal) prognostic. Carbo/pacli first-line. PARP inhibitor maintenance for BRCA/HRD. Genetic testing universal. Palliative integration. 5-yr survival 30-40% stage III, 20% stage IV.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'FIGO Cancer Report Ovarian Cancer 2021; ESMO/NCCN Ovarian Cancer Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 64 ปี postmenopausal × 12 yr มาด้วย bloating + early satiety + weight loss 5 kg × 3 mo + chronic pelvic discomfort

V/S: BP 124/76, HR 88
Gen: thin, ascites + on exam
Pelvic: bilateral fixed adnexal masses 10-12 cm, nodularity in cul-de-sac
US: bilateral complex adnexal masses + ascites + omental thickening
CA-125 850, CEA 12, β-hCG negative
CT C/A/P: bilateral ovarian masses + omental caking + ascites + peritoneal carcinomatosis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 47 ปี perimenopausal มาด้วยอาการ vasomotor (hot flashes 8/d, night sweats), poor sleep, mood lability, vaginal dryness + dyspareunia + decreased libido × 1 yr, last menses 8 mo ago

V/S: BP 124/78, HR 80
Gen: no breast mass, normal pelvic
Lab: FSH 78, estradiol 12, TSH normal, lipid + glucose normal
No history of CV disease, breast cancer, VTE, stroke, liver disease', '[{"label":"A","text":"Refuse — no treatment available"},{"label":"B","text":"Perimenopausal symptoms management"},{"label":"C","text":"Hysterectomy"},{"label":"D","text":"Antibiotic alone"},{"label":"E","text":"Methotrexate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Perimenopausal symptoms management** — shared decision-making: (1) **vasomotor symptoms (VMS) first-line — Menopausal Hormone Therapy (MHT)** — most effective for VMS; (a) **estrogen + progestin** if intact uterus (combined continuous or cyclic) — oral conjugated equine estrogen or estradiol, transdermal estradiol patch preferred (less VTE/stroke risk); progestin to prevent endometrial hyperplasia (medroxyprogesterone, micronized progesterone — preferred for safer breast profile, dydrogesterone); (b) **estrogen-only** if hysterectomy; (c) start at lowest effective dose, shortest duration; (d) **risks** — VTE (transdermal lower), breast cancer (combined > estrogen-only, time-dependent), stroke; reassess annually; (2) **non-hormonal alternatives** for VMS — SSRIs/SNRIs (paroxetine, venlafaxine, escitalopram), gabapentin, oxybutynin, clonidine, fezolinetant (new NK3 antagonist 2023); (3) **genitourinary syndrome of menopause (GSM)** — **vaginal estrogen** (cream, ring, tablet) — minimal systemic absorption, safe even with progestin-free; vaginal moisturizers + lubricants; ospemifene (SERM); DHEA vaginal; (4) **bone health** — DEXA at 65 (or earlier if risk), calcium + vit D, weight-bearing exercise; bisphosphonate / denosumab if osteoporosis; (5) **CV risk** — manage HT, lipids, DM, smoking; (6) **sleep, mood, libido** — CBT, mindfulness, exercise; (7) **counseling** — reassess MHT every 1-2 yr; menopause average age 51 Thai; risks/benefits individualized; (8) **contraindications MHT** — breast/endometrial cancer, undiagnosed bleeding, VTE history, recent MI/stroke, liver disease, severe migraine with aura, smoker > 35; (9) **WHI study reinterpretation** — risk-benefit balance more favorable in younger women within 10 yr of menopause

---

MHT for VMS — most effective. Transdermal lower VTE. Combined if uterus intact (progestin protect endometrium). Vaginal estrogen for GSM (safe). Non-hormonal: SSRI/SNRI, gabapentin, fezolinetant. Bone: Ca/vitD, DEXA, bisphosphonate. Individualized risk-benefit. WHI early initiation < 60/within 10 yr more favorable.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'NAMS 2022 Hormone Therapy Position Statement; ACOG Practice Bulletin 141', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 47 ปี perimenopausal มาด้วยอาการ vasomotor (hot flashes 8/d, night sweats), poor sleep, mood lability, vaginal dryness + dyspareunia + decreased libido × 1 yr, last menses 8 mo ago

V/S: BP 124/78, HR 80
Gen: no breast mass, normal pelvic
Lab: FSH 78, estradiol 12, TSH normal, lipid + glucose normal
No history of CV disease, breast cancer, VTE, stroke, liver disease'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 32 ปี มา OPD ขอ medical termination of pregnancy — GA 7 wk LMP, confirmed IUP US (gestational sac + yolk sac + early embryo + FH), uncomplicated, legally eligible per Thai law 2021 amendment (TOP < 12 wk on request)

V/S: BP 116/72, HR 80
Gen: well
Lab: β-hCG 28,000, Hb 12.4, blood group A Rh+
No contraindication (no allergy, no IUD, no ectopic, no anticoag, no severe anemia, no chronic adrenal failure, no porphyria)', '[{"label":"A","text":"Refuse — discuss only adoption"},{"label":"B","text":"Medical Abortion < 12 weeks"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Methotrexate-only abortion"},{"label":"E","text":"Wait until 20 wk"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Medical Abortion < 12 weeks** (Thai legal framework after 2021 Constitutional Court + Criminal Code amendment — abortion legal up to 12 wk on request, 13-20 wk with conditions, > 20 wk only medical indications): (1) **counseling** — confirm voluntary decision, explore options (continue + parent, adoption, terminate), informed consent, future contraception; (2) **regimen — Mifepristone + Misoprostol** (gold standard, WHO/FIGO/SOMS/RTCOG): (a) **mifepristone 200 mg PO** day 1 (anti-progesterone); (b) **misoprostol 800 mcg buccal/sublingual/vaginal** 24-48 hr later (PG); (3) **misoprostol-only regimen** ถ้า mife not available (Thailand had limited access — improving) — misoprostol 800 mcg PV/SL q 3 hr × up to 3 doses; (4) success ~ 95-98% combined regimen, ~ 85% miso-only; (5) **expected** — cramping + bleeding within hours; expulsion within 24-48 hr; (6) **follow-up** — US or β-hCG 1-2 wk to confirm complete; declining β-hCG > 80% or empty uterus on US; (7) **complications** (rare) — incomplete (~ 2-5%, may need vacuum aspiration), hemorrhage, infection, continuing pregnancy; (8) **Rh-Ig** ถ้า Rh-negative; (9) **post-abortion contraception** — IUD or implant immediately, COCP, DMPA — return to fertility immediate; (10) **emotional support** + counseling; (11) **surgical alternative** — vacuum aspiration (manual MVA or electric EVA) — fast, > 99% effective, requires clinic; (12) Thailand: 1663 abortion hotline, RSA network for referrals; (13) **NEVER** unsafe methods (unregulated drugs, abdominal injury) — counsel safe options

---

Thai law 2021: abortion legal < 12 wk on request, 13-20 wk with conditions. Mife + miso gold standard, > 95% efficacy. Miso-only alternative. Rh-Ig. Immediate contraception. Counseling + follow-up. Safe abortion access reduces maternal mortality. RSA Thailand referral network.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'WHO Abortion Care Guideline 2022; Thai Medical Council Notification on Abortion 2022', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 32 ปี มา OPD ขอ medical termination of pregnancy — GA 7 wk LMP, confirmed IUP US (gestational sac + yolk sac + early embryo + FH), uncomplicated, legally eligible per Thai law 2021 amendment (TOP < 12 wk on request)

V/S: BP 116/72, HR 80
Gen: well
Lab: β-hCG 28,000, Hb 12.4, blood group A Rh+
No contraindication (no allergy, no IUD, no ectopic, no anticoag, no severe anemia, no chronic adrenal failure, no porphyria)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามอาจารย์เรื่อง placental physiology + hormones — hCG/hPL/estrogen/progesterone roles', '[{"label":"A","text":"Placenta produces only progesterone"},{"label":"B","text":"Placental hormone physiology"},{"label":"C","text":"hCG doubles q 24 hr in viable IUP"},{"label":"D","text":"Progesterone causes uterine contraction"},{"label":"E","text":"hPL increases insulin sensitivity"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Placental hormone physiology: (1) **hCG** — produced by syncytiotrophoblast from implantation; peaks 9-10 wk (~100,000), then declines to plateau; **functions** — maintains corpus luteum → progesterone (until placenta takes over ~ 8-10 wk); stimulates fetal Leydig → testosterone (male sex differentiation); thyrotropic (cross-reacts TSH-R — transient hyperthyroidism in HEG/mole); doubles q 48-72 hr in early viable IUP; (2) **hPL (human Placental Lactogen)** = chorionic somatomammotropin — produced by syncytiotrophoblast from week 5, rises throughout pregnancy; **functions** — anti-insulin (maternal insulin resistance → ensures fetal glucose supply — also drives GDM); lipolysis (free fatty acids for maternal energy); mammary development; (3) **progesterone** — corpus luteum early then placenta takes over (8-10 wk = luteo-placental shift); maintains pregnancy (endometrium decidualization, uterine quiescence — ↓ contractility, immune tolerance, prevents lactation); produced from maternal cholesterol; (4) **estrogen (estriol E3)** — fetoplacental unit (DHEAS from fetal adrenal → fetal liver 16α-hydroxylation → placenta aromatase → E3); marker of fetal well-being (low in fetal demise, anencephaly); promotes uteroplacental blood flow, breast development; (5) **CRH** — placental CRH ↑ near term → triggers labor cascade (cortisol, prostaglandins); (6) **relaxin** — corpus luteum + placenta; ligament softening (esp pelvic), cervical ripening; (7) **prostaglandins** — local action, labor initiation; (8) interpretation — declining hCG = nonviable; very high = mole, multifetal; rising hPL = placental sufficiency

---

Placental hormones: hCG (maintains CL early; peak 10 wk; cross-reacts TSH), hPL (insulin resistance, lipolysis, GDM mechanism), progesterone (luteo-placental shift 8-10 wk; uterine quiescence), estrogen (fetoplacental unit, E3 marker), CRH (labor), relaxin (cervical ripening). Diagnostic interpretation: doubling hCG q 48 hr, declining = nonviable.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'basic_science', 'obgyn', 'adult',
  'Williams Obstetrics 26e Ch 5; Speroff Clinical Gyn Endo 9e', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Resident ถามอาจารย์เรื่อง placental physiology + hormones — hCG/hPL/estrogen/progesterone roles'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามอาจารย์เรื่อง lactation physiology + hormones', '[{"label":"A","text":"Prolactin causes ejection of milk"},{"label":"B","text":"Lactogenesis II"},{"label":"C","text":"Prolactin causes uterine contraction"},{"label":"D","text":"Oxytocin produces milk"},{"label":"E","text":"Lactation stops with first menses"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Lactation physiology: (1) **mammary development** — estrogen (ductal proliferation), progesterone (lobuloalveolar), prolactin, hPL, cortisol, insulin during pregnancy; (2) **lactogenesis stages**: (a) **Lactogenesis I** — late pregnancy, colostrum production begins (IgA, IgG, leukocytes, growth factors), inhibited by high progesterone; (b) **Lactogenesis II** — abrupt fall in progesterone with placental delivery (within 30-72 hr postpartum) → milk production initiated; delayed in DM, obesity, retained placenta, stress, C/S; (c) **Lactogenesis III (galactopoiesis)** — maintenance, autocrine control by demand-supply (Feedback Inhibitor of Lactation — FIL); (3) **prolactin** — anterior pituitary lactotrophs; **production of milk**; suppresses GnRH (lactational amenorrhea/contraception — LAM 98% effective < 6 mo + amenorrhea + exclusive breastfeeding); levels stimulated by suckling (neural reflex); (4) **oxytocin** — posterior pituitary; **let-down (milk ejection)** — contraction of myoepithelial cells around alveoli + smooth muscle of ducts; uterine contraction (involution); stimulated by suckling, conditioned by infant cry/sight; (5) **milk composition** — colostrum (high IgA, protein), transitional, mature (lactose, fat, protein, immune factors); (6) **benefits** — infant (immunity, gut maturation, ↓ infections, ↓ SIDS, ↓ atopic, neurocognitive), maternal (↓ PPH involution, ↓ breast/ovarian cancer, ↓ DM, weight loss, bonding); (7) **WHO recommendation** — exclusive 6 mo + continued to 2 yr; (8) **medications + lactation** — most safe; LactMed reference; (9) Thai context: rooming-in, BFHI baby-friendly initiative

---

Lactation: lactogenesis I-III. Prolactin (production), oxytocin (ejection). Suckling → both. Progesterone drop → onset milk. Autocrine FIL controls supply. LAM contraception. WHO breastfeed 6 mo exclusive + 2 yr. Most meds safe — LactMed.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'basic_science', 'obgyn', 'adult',
  'Lawrence Breastfeeding 9e; WHO Infant Feeding', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Resident ถามอาจารย์เรื่อง lactation physiology + hormones'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามอาจารย์เรื่อง embryology — Müllerian + Wolffian duct + congenital anomalies', '[{"label":"A","text":"All women have Müllerian agenesis"},{"label":"B","text":"Embryology of female reproductive tract"},{"label":"C","text":"Müllerian ducts develop into testes"},{"label":"D","text":"Bicornuate is the most common Müllerian anomaly"},{"label":"E","text":"Septate uterus cannot be treated"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Embryology of female reproductive tract: (1) **paramesonephric (Müllerian) ducts** — develop in 6th week from coelomic epithelium lateral to mesonephric (Wolffian); regress in male due to **anti-Müllerian hormone (AMH)** from fetal Sertoli cells; (2) **female differentiation (default)** — absence of AMH + absence of testosterone → Müllerian ducts persist + Wolffian regress; (3) **Müllerian development** — fuse caudally to form **uterus, fallopian tubes (cranial unfused), cervix, upper 2/3 vagina**; lower 1/3 vagina + vestibule from urogenital sinus (endoderm); (4) **stages**: (a) organogenesis (separate tubes), (b) fusion (midline), (c) canalization, (d) septum resorption; failure each stage → anomalies; (5) **ASRM/AFS classification of Müllerian anomalies**: I — segmental agenesis (MRKH); II — unicornuate; III — uterus didelphys (complete failure of fusion); IV — bicornuate (partial fusion); V — septate (failure of resorption — **most common** + most surgically treatable + worst OB outcomes if untreated); VI — arcuate; VII — DES-related; (6) **MRKH (Mayer-Rokitansky-Küster-Hauser)** — Müllerian agenesis with normal ovaries + 46XX + normal external genitalia + absent/rudimentary uterus + vaginal agenesis; primary amenorrhea + normal secondary sex characteristics; associated renal anomalies (40%), skeletal; management — vaginal dilation or surgical neovagina + counseling + ART/surrogacy; (7) **DES-exposed daughters** — T-shaped uterus, cervical hood, clear cell adenocarcinoma vagina; (8) **clinical implications** — recurrent pregnancy loss (esp septate — best surgical outcome with hysteroscopic septum resection), preterm birth, malpresentation, infertility; (9) **workup** — 3D US/MRI > HSG > hysteroscopy + laparoscopy; (10) **renal US** mandatory (associated anomalies)

---

Müllerian anomalies — ASRM classification I-VII. Septate most common + surgically treatable (hysteroscopic resection). MRKH = Müllerian agenesis. Renal anomalies associated 40% — always image kidneys. Workup 3D US/MRI. Clinical: RPL, preterm, malpresentation, infertility.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'basic_science', 'obgyn', 'adult',
  'ASRM Müllerian Anomalies Classification 2021; Speroff Clinical Gyn Endo 9e', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Resident ถามอาจารย์เรื่อง embryology — Müllerian + Wolffian duct + congenital anomalies'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามอาจารย์เรื่อง genetics — aneuploidy screening + diagnosis', '[{"label":"A","text":"Amniocentesis at 8 weeks"},{"label":"B","text":"Aneuploidy screening + diagnosis"},{"label":"C","text":"Quad screen at 30 weeks"},{"label":"D","text":"NIPT cannot detect sex chromosome"},{"label":"E","text":"CVS preferred 30 weeks"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Aneuploidy screening + diagnosis: (1) **screening** (probabilistic, no risk to fetus) — (a) **First-trimester combined** 11-13+6 wk — NT + PAPP-A + free β-hCG → risk for T21, T18, T13 (detection 85%, FPR 5%); (b) **Second-trimester quad screen** 15-22 wk — AFP, hCG, uE3, inhibin A (detection T21 ~80%); (c) **Integrated/sequential** — combines first + quad; (d) **Cell-free DNA (NIPT)** from 10 wk — analyzes placental DNA in maternal blood — detection T21 > 99%, T18/T13 ~ 98%, sex chromosome aneuploidy; can detect microdeletions but lower performance; available all maternal ages now (USPSTF); confirmatory invasive testing for positives (5% false positive); (2) **soft markers on US** — nuchal thickness, absent nasal bone, echogenic intracardiac focus, echogenic bowel, choroid plexus cyst, single umbilical artery — modify risk; (3) **definitive (diagnostic) — invasive**: (a) **CVS** 11-13+6 wk — transabdominal or transcervical, sample chorionic villi → karyotype + microarray; risk 0.2% loss; mosaicism issue (placental vs fetal); (b) **amniocentesis** 15+ wk — sample amniotic fluid → karyotype, microarray (chromosomal microarray CMA preferred — detects copy number variants), FISH (rapid 24-72 hr for common aneuploidy), AFAFP for NTD; risk 0.1-0.3% loss; (4) **counseling pre-test** — risks + limitations + decisional outcomes + alternatives + reproductive choices; (5) **post-positive screen** — confirmatory diagnostic invasive testing; (6) **Thai context** — first-trimester combined widely available; NIPT increasingly accessible; (7) **age cutoff** — historic age 35 = AMA → universal screening offered all (current); (8) **other genetic** — preconception carrier screening (thalassemia, cystic fibrosis, SMA), expanded carrier panels

---

Aneuploidy screening: combined 1st-tri, quad 2nd-tri, NIPT (cffDNA) > 10 wk highest detection. Confirmatory: CVS 11-13 wk, amnio 15+ wk → karyotype/CMA. Universal screening offered all ages. Counseling critical. Thai: combined common, NIPT growing. Preconception carrier screening (Thai: thalassemia).', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'basic_science', 'obgyn', 'adult',
  'ACOG Practice Bulletin 226: Screening for Fetal Chromosomal Abnormalities 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Resident ถามอาจารย์เรื่อง genetics — aneuploidy screening + diagnosis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามอาจารย์เรื่อง reproductive endocrinology — sex steroid biosynthesis + steroid receptors', '[{"label":"A","text":"Estrogen comes from theca cells"},{"label":"B","text":"Ovarian steroidogenesis (two-cell two-gonadotropin theory)"},{"label":"C","text":"Aromatase converts estrogen to testosterone"},{"label":"D","text":"Granulosa makes androgens"},{"label":"E","text":"LH stimulates granulosa to make estrogen"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Ovarian steroidogenesis (two-cell two-gonadotropin theory): (1) **theca cells** under **LH** stimulation — express LH receptor + steroidogenic enzymes (StAR, CYP11A1, CYP17A1, 3β-HSD); convert cholesterol → pregnenolone → progesterone → 17-OH progesterone → **androstenedione + testosterone** (cannot aromatize — no CYP19); (2) **granulosa cells** under **FSH** stimulation — express FSH receptor + **aromatase (CYP19)**; take theca-derived androgens → **estrone (E1) + estradiol (E2)**; (3) cyclic regulation — see menstrual cycle Q; (4) **dominant follicle** — high estradiol → positive feedback → LH surge → ovulation; corpus luteum makes progesterone primarily; (5) **adrenal steroidogenesis** — fasciculata (cortisol — 17-OH pathway), reticularis (DHEAS — androgens), glomerulosa (aldosterone — 18-hydroxylase); (6) **fetoplacental unit** — placenta lacks 17-hydroxylase + 17,20-lyase + DHEA synthesis → relies on fetal adrenal DHEAS → fetal liver 16α-hydroxylation → placenta aromatase → estriol; (7) **enzyme deficiencies (CAH)** — 21-hydroxylase (most common, salt-wasting, virilization), 11β-hydroxylase (HT, virilization), 17α-hydroxylase (HT, hypogonadism), 3β-HSD; CAH workup — basal + ACTH-stim 17-OHP; (8) **steroid receptors** — ER (α, β), PR (A, B), AR — nuclear receptors, ligand-dependent transcription; ER-α major in uterus, breast, hypothalamus; tissue-specific receptor expression → selective effects; (9) **SERMs** — tamoxifen (breast antagonist, endometrial agonist), raloxifene (breast antagonist, bone agonist), ospemifene (vaginal agonist); (10) **clinical** — letrozole = aromatase inhibitor (ovulation induction); finasteride = 5α-reductase inhibitor; spironolactone = AR antagonist; combination informs management of PCOS, infertility, breast cancer

---

Two-cell two-gonadotropin: theca/LH (androgens) → granulosa/FSH (aromatase → estrogen). Steroid synthesis pathway: cholesterol → preg → prog → androgens → estrogens. CAH enzyme defects. Receptors nuclear. SERMs tissue-selective. AI letrozole. Clinical relevance: PCOS, infertility, oncology.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'basic_science', 'obgyn', 'adult',
  'Speroff Clinical Gyn Endo 9e Ch 2; Williams Endocrinology 14e', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Resident ถามอาจารย์เรื่อง reproductive endocrinology — sex steroid biosynthesis + steroid receptors'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital establishes systematic OB Morbidity & Mortality (M&M) conference + Severe Maternal Morbidity (SMM) review', '[{"label":"A","text":"Hide errors from staff"},{"label":"B","text":"OB M&M + SMM review system"},{"label":"C","text":"Blame individual"},{"label":"D","text":"Skip review"},{"label":"E","text":"Only physician review"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** OB M&M + SMM review system: (1) **Severe Maternal Morbidity (SMM)** definition — CDC: 21 indicators (e.g., eclampsia, hysterectomy, mechanical ventilation, ICU admission, blood transfusion ≥ 4 U, AKI, MI, sepsis, shock, cardiac arrest, etc.); review all cases for system + provider opportunities; (2) **Maternal Mortality Review Committee (MMRC)** — state/national level; pregnancy-related death within 1 yr; review cause + preventability + recommendations; (3) **case review process** — (a) identify case via screening (ICD codes, manual flag, audit), (b) abstract chart + interviews, (c) multidisciplinary team review (OB, anesthesia, nursing, midwifery, social work, pathology, leadership, sometimes external), (d) classify preventability + factors (patient, provider, facility, system), (e) identify opportunities for improvement, (f) propose + implement actions, (g) track outcomes; (4) **Just Culture** framework — distinguish human error (console) vs at-risk behavior (coach) vs reckless behavior (discipline); not blame-focused; (5) **psychological safety** — confidential, non-punitive, learning-focused; (6) **action items** — protocol updates, simulation training, equipment, communication tools, escalation pathways, debriefs; (7) **transparency** — share lessons; equity lens (racial/SES disparities); patient/family engagement; (8) **AIM bundles + SMM dashboard** monitor improvement; (9) **second victim support** — providers involved in serious events need psychological support; (10) link to **patient safety + quality improvement + risk management + medical liability** (peer review protection variable by state/country)

---

M&M + SMM review = patient safety standard. CDC 21 SMM indicators. MMRC for mortality. Just Culture. Multidisciplinary. Equity. Second victim support. AIM bundles. Confidential. Action-oriented + tracked outcomes.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'ems_mgmt', 'obgyn', 'adult',
  'CDC SMM Indicators; ACOG/SMFM/AIM Levels of Maternal Care + Severe Maternal Morbidity Review', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'Hospital establishes systematic OB Morbidity & Mortality (M&M) conference + Severe Maternal Morbidity (SMM) review'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'OB unit develops informed consent process for high-risk procedures (TOLAC, operative vaginal, cesarean hysterectomy in placenta accreta)', '[{"label":"A","text":"Skip consent in emergency"},{"label":"B","text":"Informed consent for high-risk OB procedures"},{"label":"C","text":"Verbal only without documentation"},{"label":"D","text":"Family decides for adult patient"},{"label":"E","text":"Forced procedure"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Informed consent for high-risk OB procedures: (1) **elements of informed consent** — (a) **capacity** assessment, (b) **disclosure** — nature of procedure, **purpose, alternatives** (including no treatment), **risks** (common + serious — quantified when possible), **benefits**, (c) **comprehension** check (teach-back), (d) **voluntary decision** (no coercion), (e) documentation + signature; (2) **shared decision-making** — partnership of clinician expertise + patient values/preferences; tools: decision aids, video, written materials in patient language; (3) **specific examples**: (a) **TOLAC vs ERCD** — discuss uterine rupture 0.5-1%, success 60-80%, future pregnancy, neonatal outcomes, hospital factors (availability of immediate C/S); (b) **operative vaginal** — vacuum vs forceps, indications, alternatives, neonatal risks (cephalohematoma, subgaleal, brachial plexus), maternal risks (laceration, sphincter injury, hemorrhage); (c) **placenta accreta hysterectomy** — pre-op MDT discussion, blood products, ICU, future fertility loss, urology involvement; (4) **emergency consent** — if life-threatening + patient unable + surrogate unavailable → implied consent for life-saving (document); (5) **language + cultural** — qualified medical interpreter required (not family member for sensitive); cultural humility; (6) **special populations** — minors (assent + parent), pregnant minors (varies by state/country), patients with disabilities; (7) **Thai law + Medical Council** — written consent for surgery, anesthesia; documentation key; (8) **refusal of treatment** — respect autonomy except court-ordered C/S (rare, controversial); (9) **incorporate in advance discussions** during ANC (birth plan, preferences); (10) **continuous process** — not one-time; revisit as condition evolves

---

Informed consent: capacity, disclosure, comprehension, voluntary, documented. Shared decision-making. Specific OB procedures need detailed risk discussion. Interpreters. Decision aids. Emergency: implied consent for life-saving. Continuous process throughout pregnancy. Respect autonomy.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'ems_mgmt', 'obgyn', 'adult',
  'ACOG Committee Opinion 819: Informed Consent and Shared Decision Making in Obstetrics and Gynecology 2021', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'OB unit develops informed consent process for high-risk procedures (TOLAC, operative vaginal, cesarean hysterectomy in placenta accreta)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงตั้งครรภ์มา ANC พบ bruising patterns + delayed care-seeking — staff sensitive screening for intimate partner violence (IPV)', '[{"label":"A","text":"Ignore — not our problem"},{"label":"B","text":"Intimate Partner Violence (IPV) screening + response in OB"},{"label":"C","text":"Confront the partner"},{"label":"D","text":"Hide the bruises"},{"label":"E","text":"Ignore the situation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Intimate Partner Violence (IPV) screening + response in OB** — universal screening recommended (USPSTF Grade B, ACOG): (1) **screen all women of reproductive age** at routine visits, including each trimester ANC + postpartum; (2) **private setting** — partner/family NOT present; if partner won''t leave → reschedule or use covert signals; (3) **validated tools** — HITS, WAST, AAS (Abuse Assessment Screen), HARK; ask directly: ''Has your partner ever hurt or threatened you?''; (4) **non-judgmental + supportive** approach; (5) **if positive** — (a) validate (believe + affirm: ''this is not your fault''), (b) assess **immediate safety** (Danger Assessment — weapons, escalation, recent severe violence, strangulation = high lethality), (c) acute injury — treat + document, (d) **safety planning** — code word, escape route, important docs, emergency contacts, shelter, (e) **resources** — Thai hotline 1300 (One Stop Crisis Center), shelters, legal aid, social worker, mental health; (6) **mandatory reporting** varies — Thai law: report child abuse mandatory; IPV not mandatory (respect patient autonomy + safety); (7) **documentation** — photos with consent, body diagrams, exact quotes (medical-legal); (8) **pregnancy-specific risks** — IPV ↑ during pregnancy; ↑ preterm birth, abruption, LBW, depression, fetal injury; (9) **postpartum** — risk persists + may escalate; postpartum depression + IPV bidirectional; (10) **multidisciplinary** — social worker, mental health, advocate; warm handoffs; follow-up next visit; (11) **trauma-informed care** — recognize trauma history, choice + control, peer support; (12) **provider education** + simulation training; safety for staff also

---

IPV screening universal (USPSTF B, ACOG). Private setting, validated tools, supportive. Safety planning + resources. Documentation. Thai 1300 OSCC. Pregnancy ↑ IPV risk. Mandatory reporting child abuse only. Trauma-informed care. Multidisciplinary. Provider education.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'ems_mgmt', 'obgyn', 'adult',
  'ACOG Committee Opinion 518: IPV; USPSTF IPV Screening 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงตั้งครรภ์มา ANC พบ bruising patterns + delayed care-seeking — staff sensitive screening for intimate partner violence (IPV)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 28 ปี G1P0 GA 16 wk underlying hypothyroidism — was on levothyroxine 100 mcg/d pre-pregnancy, last TSH 4.8 (elevated)

V/S: BP 116/74, HR 80
Gen: well, mild fatigue
Fetal: heart 152, growth appropriate
Lab: TSH 4.8 (trimester-specific upper limit < 2.5 1st trimester, < 3.0 2nd-3rd), FT4 low-normal, TPO Ab positive (Hashimoto)', '[{"label":"A","text":"Stop levothyroxine"},{"label":"B","text":"Hypothyroidism in pregnancy management"},{"label":"C","text":"Reduce levothyroxine 50%"},{"label":"D","text":"Cesarean delivery"},{"label":"E","text":"Methotrexate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hypothyroidism in pregnancy management: (1) **trimester-specific TSH targets** — < 2.5 mIU/L 1st trimester, < 3.0 2nd-3rd (or use lab-specific reference); (2) **immediately ↑ levothyroxine dose by 20-30%** when pregnancy confirmed (Endocrine Society/ATA) — automatic dose adjustment commonly 2 extra doses/week; this patient TSH 4.8 = under-replaced → increase to 125 mcg or by 25-30%; (3) **recheck TSH q 4 wk** until 20 wk, then q 4-6 wk; (4) **why ↑ requirement** — ↑ TBG (estrogen-driven), placental D3 deiodinase, transplacental transfer for fetal brain development (critical first 12 wk before fetal thyroid functions); (5) **timing levothyroxine** — empty stomach, 30-60 min before food, separate from iron/calcium/PPI; (6) **subclinical hypothyroidism** (TSH elevated + FT4 normal) — treat if TPO+ (Hashimoto) or TSH > 10; benefit on obstetric outcomes mixed; (7) **overt hypothyroidism** — clearly treat — associated with miscarriage, preeclampsia, abruption, preterm birth, LBW, fetal neurodevelopmental impairment; (8) **iodine** — 250 mcg/d in pregnancy (Thai dietary salt iodination); (9) **postpartum** — return to pre-pregnancy dose; recheck 6 wk postpartum; **postpartum thyroiditis** — hyperthyroid 1-6 mo then hypo phase then resolution; TPO+ at risk; (10) **TPO Ab+ even with normal TSH** — ↑ miscarriage + preterm + postpartum thyroiditis risk; consider treating subclinical or monitoring; (11) **breastfeeding** — levothyroxine safe; (12) **future pregnancy** — preconception TSH optimization (< 2.5)

---

Hypothyroid pregnancy: ↑ levothyroxine 20-30% on confirmation. Target TSH < 2.5 (1st) / < 3.0 (2nd-3rd). Recheck q 4 wk. Untreated → miscarriage, PE, neurodevelopment. TPO+ ↑ risk. Postpartum return to baseline dose + 6 wk check. Postpartum thyroiditis. Iodine 250 mcg.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'integrative', 'obgyn', 'adult',
  'ATA Thyroid Disease in Pregnancy 2017; Endocrine Society Hypothyroidism Pregnancy 2012', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 28 ปี G1P0 GA 16 wk underlying hypothyroidism — was on levothyroxine 100 mcg/d pre-pregnancy, last TSH 4.8 (elevated)

V/S: BP 116/74, HR 80
Gen: well, mild fatigue
Fetal: heart 152, growth appropriate
Lab: TSH 4.8 (trimester-specific upper limit < 2.5 1st trimester, < 3.0 2nd-3rd), FT4 low-normal, TPO Ab positive (Hashimoto)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 32 ปี G1P0 GA 28 wk underlying severe major depressive disorder + suicidal ideation 1 wk — on no medication (stopped fluoxetine when pregnancy known)

V/S: BP 118/72, HR 88
Gen: tearful, psychomotor retardation, expressed hopelessness, denies plan but has thoughts of self-harm
Fetal: heart 144 reactive, growth appropriate
No psychotic features, no substance use, supportive partner', '[{"label":"A","text":"Reassurance only — stress is normal"},{"label":"B","text":"Severe MDD in pregnancy with suicidal ideation — multidisciplinary perinatal mental health care"},{"label":"C","text":"Refuse all medication during pregnancy"},{"label":"D","text":"Cesarean immediately"},{"label":"E","text":"Stop all care + counseling"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe MDD in pregnancy with suicidal ideation — multidisciplinary perinatal mental health care: (1) **safety first** — assess suicide risk (SAD PERSONS, ideation/plan/intent/means); active SI = psychiatric emergency → **psychiatric consultation immediately**; consider voluntary admission for safety + treatment initiation; (2) **risk-benefit of treatment** — untreated severe depression → preterm birth, LBW, preeclampsia, GDM, postpartum depression, suicide, infant neurodevelopmental impact; vs medication risks; (3) **SSRI safe in pregnancy** — sertraline first-line (low transfer, evidence safe in pregnancy + lactation); escitalopram, citalopram also reasonable; **AVOID paroxetine** (cardiac defects ~ 2× baseline — small absolute increase) — relative; fluoxetine OK but long half-life (transfer to fetus/breastmilk); (4) **considerations** — late-pregnancy SSRI → poor neonatal adaptation syndrome (transient, supportive care), small ↑ PPHN risk (rare); benefit usually outweighs; (5) **psychotherapy** — CBT, IPT (interpersonal — strong evidence perinatal) — first-line for mild-moderate, adjunct severe; (6) **ECT** — safe + effective in severe perinatal depression refractory to/intolerant of medication; (7) **lifestyle** — exercise, sleep, nutrition, social support; (8) **screening** — Edinburgh Postnatal Depression Scale (EPDS), PHQ-9 at every visit antepartum + postpartum × 1 yr; (9) **postpartum planning** — relapse risk high in postpartum; continue medication; psychotherapy + peer support; lactation — sertraline preferred (low milk transfer); (10) **psychiatric emergency** support: Thai 1323 mental health hotline, ER psychiatry; (11) **multidisciplinary team** — OB, psych, social worker, pediatrics, lactation; (12) **partner involvement** + family support; (13) **trauma-informed**; (14) **suicide** = leading cause of maternal death in some HIC

---

Perinatal depression: untreated severe → adverse outcomes including suicide (leading cause). Sertraline first-line. Avoid paroxetine. CBT/IPT psychotherapy. ECT safe in pregnancy. EPDS/PHQ-9 screening. Postpartum relapse risk. Multidisciplinary. Suicide screen + emergency care. Breastfeeding safe with sertraline.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'integrative', 'obgyn', 'adult',
  'ACOG Committee Opinion 757: Screening for Perinatal Depression; APA Perinatal Mental Health Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 32 ปี G1P0 GA 28 wk underlying severe major depressive disorder + suicidal ideation 1 wk — on no medication (stopped fluoxetine when pregnancy known)

V/S: BP 118/72, HR 88
Gen: tearful, psychomotor retardation, expressed hopelessness, denies plan but has thoughts of self-harm
Fetal: heart 144 reactive, growth appropriate
No psychotic features, no substance use, supportive partner'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 24 ปี G1P1 NSD 30 นาที, episiotomy + vacuum extraction. Bleeding 1.2 L, uterus contracted firm, placenta complete

V/S: BP 96/58, HR 116
Perineum exam: 4° laceration extending through anal sphincter + rectal mucosa
Uterus: firm, fundus at umbilicus, no atony
Bleeding from vaginal vault + cervix', '[{"label":"A","text":"Just oxytocin + observe"},{"label":"B","text":"genital tract trauma"},{"label":"C","text":"Hysterectomy"},{"label":"D","text":"Discharge home without repair"},{"label":"E","text":"Methotrexate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** PPH from **genital tract trauma** (T = Trauma in 4 T''s of PPH): (1) systematic exam under good lighting + adequate analgesia/anesthesia — assess cervix, vaginal walls, perineum (4 degrees), periurethral; (2) **identify + repair sources** — cervical lacerations (sponge stick traction, suture if bleeding/> 1 cm), vaginal walls (running interlocking absorbable), perineal — repair in layers; (3) **4° laceration repair** — multidisciplinary (colorectal/urology if available, OB skilled): (a) **rectal mucosa** — interrupted or continuous fine absorbable (4-0 polyglactin/PDS), submucosal, knots away from lumen; (b) **internal anal sphincter** — separate repair (figure-of-8 or end-to-end with delayed absorbable); (c) **external anal sphincter** — overlapping or end-to-end with 2-0 PDS; (d) perineal body + vaginal mucosa + skin; (4) **antibiotics** — single dose cefazolin pre-repair (reduces wound complications); (5) **stool softeners + sitz bath** + analgesia + avoid constipation 6 wk; (6) **follow-up** — pelvic floor physical therapy, anal incontinence assessment 6 wk + 3-6 mo (manometry/endoanal US ถ้า symptoms); (7) **future delivery** — counsel risk recurrence ~ 7-15%; option C/S vs vaginal individualized; (8) hemodynamic resuscitation — IV fluid, blood products as needed; ongoing PPH protocol; (9) **document** — degree, repair technique, antibiotic, plan

---

OASIS (Obstetric Anal Sphincter Injury) — 4° = full thickness through rectal mucosa. Repair layered + antibiotic prophylaxis + stool softener + PFPT + follow-up incontinence assessment. Future delivery counseling. Vacuum/forceps + episiotomy + macrosomia + nulliparous = risk factors.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'RCOG Green-top 29: Management of Third- and Fourth-Degree Perineal Tears 2015', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 24 ปี G1P1 NSD 30 นาที, episiotomy + vacuum extraction. Bleeding 1.2 L, uterus contracted firm, placenta complete

V/S: BP 96/58, HR 116
Perineum exam: 4° laceration extending through anal sphincter + rectal mucosa
Uterus: firm, fundus at umbilicus, no atony
Bleeding from vaginal vault + cervix'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงตั้งครรภ์ G1P0 GA 38 wk SROM ที่บ้าน — sudden painless heavy bright red bleeding ทันที + fetal bradycardia within minutes

V/S: BP 100/68, HR 110
Fetal: FHR 65 bradycardia
US done in prenatal — velamentous cord insertion + vessels crossing internal os (vasa previa) — was identified ANC at 30 wk but mother went into labor unexpectedly', '[{"label":"A","text":"Continue vaginal delivery"},{"label":"B","text":"Vasa Previa rupture"},{"label":"C","text":"Tocolysis"},{"label":"D","text":"Discharge home — observation"},{"label":"E","text":"Wait for natural delivery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Vasa Previa rupture** (fetal vessels crossing or within 2 cm of internal os, unsupported by placenta or cord — ruptures with membranes → fetal exsanguination, fetal mortality > 50-95% if not recognized; risk: velamentous cord insertion, succenturiate/bilobed placenta, multifetal, IVF): (1) **emergency cesarean delivery** — fetal blood loss = imminent demise (small fetal blood volume ~ 80-90 mL/kg); decision-to-incision < 10 min; (2) **neonatal resuscitation team** ready — transfusion (O-negative emergency blood, type-specific ASAP); cord blood gas; (3) **prevention** — antenatal diagnosis on US (transvaginal Doppler — color flow over os) → planned admission at 30-34 wk, **antenatal corticosteroids 28-32 wk**, scheduled C/S 34-37 wk before ROM; (4) Apt test (HbF) — can confirm fetal blood (alkali-resistant) if doubt; (5) **post-delivery** — neonatal ICU care + transfusion; (6) **outcomes** — with antenatal dx + planned C/S → survival > 95%; without dx → mortality very high; (7) document + risk management; counsel future pregnancies + early US

---

Vasa previa: fetal vessels over cervical os. Rupture = fetal exsanguination. Antenatal diagnosis (transvaginal color Doppler) → planned C/S 34-37 wk = > 95% survival. Without dx = catastrophic. Risk: velamentous cord, succenturiate lobe, IVF. Emergency C/S < 10 min.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'SMFM Consult Series 37: Vasa Previa; RCOG Green-top 27b', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงตั้งครรภ์ G1P0 GA 38 wk SROM ที่บ้าน — sudden painless heavy bright red bleeding ทันที + fetal bradycardia within minutes

V/S: BP 100/68, HR 110
Fetal: FHR 65 bradycardia
US done in prenatal — velamentous cord insertion + vessels crossing internal os (vasa previa) — was identified ANC at 30 wk but mother went into labor unexpectedly'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงตั้งครรภ์ GA 22 wk twin pregnancy MCDA (monochorionic-diamniotic) — routine US shows twin A polyhydramnios (DVP 9 cm, AFI 28) + twin B oligohydramnios (DVP 1.5 cm, ''stuck twin''), Twin A bladder visible distended, Twin B bladder not visible, both alive

V/S: BP 118/74, HR 88
Fetal: both alive, FHR Twin A 148, Twin B 152
Doppler: Twin B umbilical artery normal flow', '[{"label":"A","text":"Continue routine ANC"},{"label":"B","text":"Twin-to-Twin Transfusion Syndrome (TTTS)"},{"label":"C","text":"Cesarean immediately at 22 wk"},{"label":"D","text":"Terminate both twins"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Twin-to-Twin Transfusion Syndrome (TTTS)** — Quintero stage II (donor with no bladder, but normal Doppler) — in MCDA pregnancy only (shared placental vascular anastomoses): donor → recipient through unbalanced AV anastomoses → recipient polyhydramnios + bladder distention + ↑ cardiac volume; donor oligohydramnios + small bladder + IUGR; (1) **refer fetal therapy center**; (2) **Quintero staging** — I (oligo/poly + visible donor bladder); II (no visible donor bladder); III (abnormal Doppler — UA AEDV/REDV, DV reversal); IV (hydrops); V (demise); (3) **treatment — fetoscopic laser photocoagulation** of placental vascular anastomoses (Solomon technique — equator dichorionizing) — gold standard for stage II-IV at 16-26 wk; survival of at least 1 twin ~ 85%, both ~ 70%; superior to amnioreduction (Eurofoetus trial); (4) **amnioreduction** (large-volume) — alternative for early/late or refractory; (5) **selective reduction** (radiofrequency, bipolar cord coagulation) — single twin demise ถ้า one severely compromised; (6) **expectant** — observation late presentation > 26 wk + planned early delivery; (7) **antenatal corticosteroids** if preterm delivery anticipated; (8) **post-laser** — serial US (TAPS — twin anemia-polycythemia sequence; recurrent TTTS), MCA Doppler, growth, BPP; (9) **co-twin demise** — surviving twin risk neurologic injury (15-25%) + death from acute exsanguination through anastomoses; brain MRI follow-up; (10) **delivery** — typically 34-37 wk for MCDA TTTS treated; (11) counsel: complex, fetal therapy referral promptly

---

TTTS in MCDA twins. Quintero staging I-V. Fetoscopic laser ablation = standard 16-26 wk (Eurofoetus). Post-treatment: TAPS, recurrence, surviving twin neuro risk if co-twin demise. Antenatal dichorionic vs monochorionic critical — different management. Delivery 34-37 wk MCDA.', NULL,
  'hard', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'NAFTNet TTTS Management Guidelines; ISUOG Twin Pregnancies 2016', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงตั้งครรภ์ GA 22 wk twin pregnancy MCDA (monochorionic-diamniotic) — routine US shows twin A polyhydramnios (DVP 9 cm, AFI 28) + twin B oligohydramnios (DVP 1.5 cm, ''stuck twin''), Twin A bladder visible distended, Twin B bladder not visible, both alive

V/S: BP 118/74, HR 88
Fetal: both alive, FHR Twin A 148, Twin B 152
Doppler: Twin B umbilical artery normal flow'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงตั้งครรภ์ G1P0 GA 39 wk NSD with thick meconium-stained fluid — depressed neonate at delivery, HR 60, no respiratory effort, limp, no cry

Maternal V/S: BP 122/76, HR 92 stable
Fetal: just delivered, Apgar 1 min: 1 (HR < 100, no respiration, limp, no reflex, blue)
Cord blood gas pH 6.95, base deficit 16', '[{"label":"A","text":"Suction trachea aggressively first"},{"label":"B","text":"Neonatal resuscitation (NRP 8e — Thai/AAP/AHA)"},{"label":"C","text":"Discharge to nursery"},{"label":"D","text":"Wait for spontaneous breathing 10 min"},{"label":"E","text":"Continue stimulation only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neonatal resuscitation (NRP 8e — Thai/AAP/AHA): (1) **initial rapid assessment** — term? tone? breathing/crying? — if YES routine, if NO → resuscitation; (2) **Golden Minute** — warm, dry, stimulate, position airway, suction only if obstructing (no longer routine for MSAF non-vigorous per NRP 8e — 2020 change); (3) **assess HR + respirations** at 30 sec; **HR < 100 or apnea/gasping → PPV** with bag-mask 21% O2 (term), 30 breaths/min, 20-25 cm H2O initial PIP — MR SOPA if not effective (Mask, Reposition, Suction, Open mouth, Pressure ↑, Alternative airway); (4) **HR < 60 despite effective PPV × 30 sec → intubate + chest compressions** 3:1 ratio (90 compressions + 30 breaths/min), 100% O2, depth 1/3 AP chest; (5) **HR still < 60 after 60 sec compressions + PPV → IV access** umbilical vein + **epinephrine** 0.01-0.03 mg/kg (1:10,000) IV or 0.05-0.1 mg/kg ETT every 3-5 min; **volume** (NS 10 mL/kg) if blood loss; (6) **MSAF non-vigorous** — initiate PPV at 1 min if not breathing (do not routinely suction trachea — NRP 8e changed); intubation + tracheal suction only if airway obstructed; (7) **post-resuscitation** — therapeutic hypothermia 33-34°C × 72 hr for moderate-severe HIE (GA ≥ 36 wk, criteria met) — neuroprotection; (8) **document** Apgar 1, 5, 10 min + resuscitative actions + interventions; (9) family update + transfer NICU; (10) debrief team

---

NRP 8e Golden Minute. Initial: warm/dry/stimulate. PPV if apnea/HR<100. Compressions + PPV if HR<60. Intubate + epi if persistent. MSAF non-vigorous: PPV not routine tracheal suction (NRP 8e change). Therapeutic hypothermia for HIE (≥ 36 wk, criteria). Apgar + cord blood gas document.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'AAP/AHA Neonatal Resuscitation Program (NRP) 8e 2020; ILCOR 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงตั้งครรภ์ G1P0 GA 39 wk NSD with thick meconium-stained fluid — depressed neonate at delivery, HR 60, no respiratory effort, limp, no cry

Maternal V/S: BP 122/76, HR 92 stable
Fetal: just delivered, Apgar 1 min: 1 (HR < 100, no respiration, limp, no reflex, blue)
Cord blood gas pH 6.95, base deficit 16'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 32 ปี G2P1 GA 38 wk in labor, dilation 4 cm. Suspect macrosomia — fundal height 41 cm, EFW 4,500 g on US, GDM well-controlled

V/S: BP 120/74, HR 86
Fetal: FHR 140 reassuring
No prior shoulder dystocia, normal pelvis exam', '[{"label":"A","text":"Forceps delivery at 4 cm"},{"label":"B","text":"Suspected fetal macrosomia (EFW ≥ 4,000-4,500 g) management"},{"label":"C","text":"Cesarean immediately"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Methotrexate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Suspected fetal macrosomia (EFW ≥ 4,000-4,500 g) management: (1) **caveats** — US EFW imprecise (±10-15% error), tends to over-estimate at term; clinical exam (Leopold) also imprecise; (2) **C/S consideration**: (a) **EFW > 5,000 g in non-diabetic** OR **> 4,500 g in diabetic** → ACOG suggests offering elective C/S (shoulder dystocia + brachial plexus risk); (b) **prior shoulder dystocia + macrosomia** → individualized; (3) this patient EFW 4,500 + GDM well-controlled, no prior dystocia → **shared decision**; reasonable trial of labor with: (4) **anticipatory planning**: (a) experienced operator + L&R team aware, (b) extra personnel available (anesthesia, additional OB, pediatric resuscitation), (c) bed at low height for McRoberts, (d) review HELPERR algorithm; (5) **labor progress** — adequately monitor, recognize protraction/arrest disorders; (6) **operative vaginal delivery cautious** — vacuum + macrosomia + protracted 2nd stage = ↑ dystocia risk; (7) **2nd stage** — controlled delivery of head, immediate assessment for shoulder dystocia (turtle sign), HELPERR ready; (8) **postpartum** — NICU eval (hypoglycemia, polycythemia, jaundice, RDS); maternal — PPH risk (overdistended uterus), 3-4° laceration risk; (9) **counsel patient** — risks both routes, individualized decision; (10) future pregnancies: GDM screening, weight management

---

Macrosomia: EFW ≥ 4,000 (non-DM) / ≥ 4,500 (DM). US imprecise. C/S offer: > 5,000 non-DM or > 4,500 DM. Otherwise trial of labor with anticipatory shoulder dystocia preparation. Limit operative vaginal. NICU eval newborn. Shared decision counseling.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin 216: Macrosomia 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 32 ปี G2P1 GA 38 wk in labor, dilation 4 cm. Suspect macrosomia — fundal height 41 cm, EFW 4,500 g on US, GDM well-controlled

V/S: BP 120/74, HR 86
Fetal: FHR 140 reassuring
No prior shoulder dystocia, normal pelvis exam'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงตั้งครรภ์ G1P0 GA 37 wk fetus breech presentation (frank breech) — multiparous, no contraindication to ECV

V/S: BP 116/72, HR 78
Fetal: FHR 144, EFW 2,800 g, AFI normal, placenta posterior fundal (not previa)
No abruption, no prior C/S, no anomaly, no oligohydramnios, no labor', '[{"label":"A","text":"Cesarean immediately"},{"label":"B","text":"External Cephalic Version (ECV)"},{"label":"C","text":"Vaginal breech delivery without consent"},{"label":"D","text":"Discharge home for spontaneous version"},{"label":"E","text":"Methotrexate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **External Cephalic Version (ECV)** for breech at term (≥ 36-37 wk): (1) **criteria** — singleton breech ≥ 37 wk, no contraindication (no previa, no abruption, no fetal anomaly preventing version, no severe FGR/abnormal CTG, no oligohydramnios/PPROM, no multifetal, no uterine anomaly, no nuchal cord seen, mother stable, fetus reactive); (2) **pre-procedure** — confirm presentation US, NST reactive, IV access, type & screen, consent; (3) **tocolysis** — terbutaline 0.25 mg SC (most evidence), nifedipine, NTG to ↑ success; (4) **regional anesthesia** (epidural/spinal) may ↑ success + maternal comfort (controversial benefit, may use selectively); (5) **technique** — forward roll preferred; gentle continuous pressure; ≤ 2 attempts; ultrasound guidance; (6) **success rate** ~ 60% (lower if anterior placenta, nullip, low EFW, deep engagement); ~ 50% deliver vaginally cephalic after ECV; (7) **monitor post-ECV** — CTG 30-60 min, ensure reassuring; rule out abruption + fetal distress; (8) **complications** — transient FHR abnormality (most), abruption (rare), PPROM, FMH (give **Anti-D 300 mcg if Rh-negative**), emergent C/S need; (9) **fail** → schedule C/S vs repeat trial vs vaginal breech if criteria met (skilled provider, frank breech, head not hyperextended, EFW 2,500-4,000); (10) outpatient ECV vs admit per institution; (11) Thai context — ECV underutilized; promote training

---

Breech 3-4% at term. ECV at 37 wk → success ~ 60% → reduces C/S. Criteria + contraindications. Tocolysis. Monitor post-ECV. Anti-D if Rh-neg. PROBE/Term Breech Trial established C/S for breech as safer but ECV reduces need. Vaginal breech selective + skilled.', NULL,
  'easy', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Practice Bulletin 221: ECV; RCOG Green-top 20a/b', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงตั้งครรภ์ G1P0 GA 37 wk fetus breech presentation (frank breech) — multiparous, no contraindication to ECV

V/S: BP 116/72, HR 78
Fetal: FHR 144, EFW 2,800 g, AFI normal, placenta posterior fundal (not previa)
No abruption, no prior C/S, no anomaly, no oligohydramnios, no labor'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงตั้งครรภ์ GA 32 wk underlying chronic HT มา ANC — current BP 158/106 outpatient, no proteinuria, no symptoms

V/S: BP 158/106, HR 90, RR 18
Fetal: FHR 144 reactive, EFW 1,650 g (50th), AFI normal
Lab: Cr 0.7, plt 240K, AST/ALT WNL, uric acid 4.2, urine protein/Cr 0.18 (negative for preeclampsia)', '[{"label":"A","text":"Discharge — no action needed"},{"label":"B","text":"Severe hypertension in pregnancy without preeclampsia features (chronic HT severe range BP ≥ 160/110) — urgent BP control to prevent stroke while continuing to investigate"},{"label":"C","text":"Wait until 40 wk"},{"label":"D","text":"Cesarean immediately"},{"label":"E","text":"Aspirin alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe hypertension in pregnancy without preeclampsia features (chronic HT severe range BP ≥ 160/110) — **urgent BP control to prevent stroke** while continuing to investigate: (1) **measure BP × 15 min apart** to confirm persistence; (2) **acute treatment for severe-range BP within 30-60 min** (AIM bundle): (a) **IV labetalol** 20 mg → if no response 10 min → 40 mg → 80 mg → 80 mg (max 220-300 mg) — avoid in asthma, CHF, bradycardia; (b) **IV hydralazine** 5-10 mg → repeat 20-40 min → max 30 mg — SE reflex tachy, headache; (c) **oral nifedipine immediate-release** 10-20 mg → repeat 20-30 min — alternative oral if no IV; (3) **target BP** — < 140-150 / 90-100 (don''t over-correct → placental hypoperfusion); (4) **rule out preeclampsia** — repeat urine protein/Cr, LFT, plt, Cr, LDH, uric acid; symptom review; (5) ongoing antihypertensive: labetalol, nifedipine ER, methyldopa (avoid ACEI/ARB, atenolol); CHAP trial supports target < 140/90; (6) **MgSO4** ถ้า any features of severe preeclampsia (HELLP, cerebral/visual, RUQ, pulm edema); (7) **fetal surveillance** — NST/BPP, serial growth; (8) **delivery indication** — uncontrolled severe HT, end-organ damage, preeclampsia features → deliver ≥ 34 wk; (9) **debrief** + safety bundle compliance; (10) follow-up postpartum (rebound HT)

---

Severe-range BP in pregnancy (≥ 160/110) → urgent treatment within 30-60 min to prevent stroke (leading cause of maternal mortality from HTN). IV labetalol/hydralazine or oral nifedipine. CHAP trial < 140/90. Rule out preeclampsia. MgSO4 if severe features. AIM bundle compliance.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Committee Opinion 767: Emergent Therapy for Acute-Onset Severe HT 2019; AIM Bundle', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงตั้งครรภ์ GA 32 wk underlying chronic HT มา ANC — current BP 158/106 outpatient, no proteinuria, no symptoms

V/S: BP 158/106, HR 90, RR 18
Fetal: FHR 144 reactive, EFW 1,650 g (50th), AFI normal
Lab: Cr 0.7, plt 240K, AST/ALT WNL, uric acid 4.2, urine protein/Cr 0.18 (negative for preeclampsia)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงตั้งครรภ์ G2P1 GA 36 wk previously healthy มา OPD — first ANC อยู่ไกล, มาด้วยอาการเหนื่อยง่าย + เท้าบวม + ปวดศีรษะ 1 สัปดาห์, no prior care

V/S: BP 168/110, HR 92, RR 18
Gen: +2 edema legs + face, hyperreflexia 3+
Fetal: FHR 144 reactive, fundal height 33 cm (small for GA 36)
Lab pending: STAT — plt 95K, AST 120, Cr 1.0, urine 3+ protein, uric acid 7.8, HBs Ag negative, VDRL non-reactive, HIV negative', '[{"label":"A","text":"Discharge home with ANC referral"},{"label":"B","text":"complete preeclampsia workup"},{"label":"C","text":"Cesarean immediately"},{"label":"D","text":"Tocolysis to delay"},{"label":"E","text":"Outpatient observation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Late presentation severe preeclampsia + FGR — comprehensive admit: (1) immediate **stabilization** — BP control (IV labetalol/hydralazine), MgSO4 seizure prophylaxis 4-6 g load + 1-2 g/hr; (2) **complete preeclampsia workup** — CBC, CMP (Cr, LFT), uric acid, LDH, peripheral smear (schistocytes), urine protein/Cr or 24-hr, coag; (3) **fetal evaluation** — detailed US (anomaly missed, EFW, AFI), Doppler (umbilical, MCA), NST, BPP; ANC missed = unknown anomalies, growth, dating; (4) **antenatal steroids** betamethasone 12 mg IM × 2 doses 24 hr apart (late preterm 34-37 wk benefit per ALPS trial); GA 36 = borderline benefit + risk hypoglycemia neonate; (5) **delivery timing** — severe preeclampsia at 34+0 wk → **deliver after stabilization** (no need to wait for steroids if maternal/fetal instability; ALPS for 34-36+6 elective); (6) **mode** — vaginal preferred if favorable cervix + stable; cervical ripening with Foley/PG; oxytocin; C/S for usual obstetric indication; continuous EFM; (7) **postpartum** — MgSO4 24 hr, BP monitoring, may need antihypertensive 6-12 wk; PE labs may worsen 48 hr postpartum; (8) social work + WCC/social determinants — late presentation often = SES/access barriers; education + support + transition care; (9) Anti-D if Rh-neg + bleeding; (10) postpartum contraception + future pregnancy aspirin

---

Late ANC + severe preeclampsia + FGR: stabilize, workup, deliver. Steroids ALPS for late preterm. Severe PE at 34+0 deliver. Social determinants → SBIRT, social work, equity. Postpartum surveillance. Future pregnancy aspirin. Universal screening + early access addresses equity.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Hypertension in Pregnancy 2020; ALPS Trial Antenatal Late Preterm Steroids 2016', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงตั้งครรภ์ G2P1 GA 36 wk previously healthy มา OPD — first ANC อยู่ไกล, มาด้วยอาการเหนื่อยง่าย + เท้าบวม + ปวดศีรษะ 1 สัปดาห์, no prior care

V/S: BP 168/110, HR 92, RR 18
Gen: +2 edema legs + face, hyperreflexia 3+
Fetal: FHR 144 reactive, fundal height 33 cm (small for GA 36)
Lab pending: STAT — plt 95K, AST 120, Cr 1.0, urine 3+ protein, uric acid 7.8, HBs Ag negative, VDRL non-reactive, HIV negative'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงอายุ 25 ปี G2P1 GA 16 wk first ANC — Lab returned: VDRL positive 1:64, FTA-ABS positive, no symptoms, no prior history of syphilis or treatment

V/S: BP 118/72, HR 80
Gen: well, no rash, no chancre
Partner status unknown', '[{"label":"A","text":"No treatment needed"},{"label":"B","text":"Syphilis in pregnancy management (Treponema pallidum — congenital syphilis prevention)"},{"label":"C","text":"Doxycycline"},{"label":"D","text":"Discharge — wait until delivery"},{"label":"E","text":"Methotrexate"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Syphilis in pregnancy management (Treponema pallidum — congenital syphilis prevention): (1) **diagnosis** — confirmed (RPR/VDRL + treponemal FTA-ABS or TP-PA positive); titer 1:64 = active; stage by clinical + serology — likely early latent (< 1 yr) or late latent (unknown duration → treat as late); (2) **treatment**: (a) **early latent (< 1 yr) — Benzathine Penicillin G 2.4 million U IM single dose**; (b) **late latent or unknown duration — Benzathine Penicillin G 2.4 million U IM × 3 doses 1 wk apart** (total 7.2 million U); (3) **penicillin allergy** — **desensitization required** (penicillin only proven prevention of congenital syphilis — no alternative in pregnancy; doxycycline contraindicated, erythromycin doesn''t cross placenta well); inpatient desensitization protocol then PCN treatment; (4) **Jarisch-Herxheimer reaction** — fever/chills/uterine contractions after first dose (~ 6-12 hr) — monitor + supportive (acetaminophen); rare preterm labor; (5) **partner notification + treatment** — contact tracing essential (Thai DDC, anonymous partner services); (6) **follow-up** — quantitative non-treponemal titer (RPR/VDRL) at 3, 6, 12 mo expecting 4-fold ↓; if no decline → re-evaluate (HIV, persistent, reinfection); (7) **fetal evaluation** — US for stigmata (hepatomegaly, ascites, hydrops, placentomegaly); (8) **neonatal evaluation** — IgM, exam, dark-field of lesions, LP, long bone X-ray, CBC, CSF VDRL; treat per CDC criteria; (9) **HIV + co-infection screening** mandatory; other STIs (GC, CT, HBV, HCV); (10) **prevention** — universal first trimester + 28 wk + delivery screening in Thai/CDC high-risk areas; condoms; education

---

Syphilis in pregnancy: BPG only proven prevention congenital syphilis. PCN allergy → desensitize. Stage to determine dose. Partner notification. Follow-up titer 4-fold ↓ at 6-12 mo. Newborn eval + treatment. Universal screening 1st trimester + 28 wk + delivery (Thai). Co-infection HIV.', NULL,
  'medium', 'obgyn', 'review',
  'ob_gyn', 'clinical_decision', 'obgyn', 'adult',
  'CDC STI Treatment Guidelines 2021; WHO Syphilis Pregnancy', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'obg_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'ob_gyn'
      and q.scenario = 'หญิงอายุ 25 ปี G2P1 GA 16 wk first ANC — Lab returned: VDRL positive 1:64, FTA-ABS positive, no symptoms, no prior history of syphilis or treatment

V/S: BP 118/72, HR 80
Gen: well, no rash, no chancre
Partner status unknown'
  );

commit;

