-- ===============================================================
-- UPDATE chunk 2/8: ob_gyn (25 questions)
-- ===============================================================

begin;

update public.mcq_questions
set choices = '[{"label":"A","text":"Traditional restrictive recovery"},{"label":"B","text":"Enhanced Recovery After Cesarean (ERAC)"},{"label":"C","text":"Bed rest 5 days"},{"label":"D","text":"Opioid-only analgesia"},{"label":"E","text":"Restrict fluid intake"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Enhanced Recovery After Cesarean (ERAC) — multimodal evidence-based: (1) Pre-op: counseling, no prolonged fasting (clear fluids until 2h, carb loading 2h pre-op), antibiotic prophylaxis 60 min pre-op (cefazolin + azithromycin), VTE prophylaxis (mechanical + LMWH start 6-12h post-op), normothermia, chlorhexidine skin prep; (2) Intra-op: neuraxial anesthesia preferred (spinal/CSE), multimodal analgesia (intrathecal morphine + IV acetaminophen + NSAID), minimize opioid use, restrictive IV fluid, blunt expansion of uterine incision (less blood loss), uterotonic at delivery (oxytocin); (3) Post-op: early oral diet (within 1h), early ambulation (within 6h), Foley removal 12h, opioid-sparing analgesia (acetaminophen + NSAID + TAP block + low-dose opioid PRN), thromboprophylaxis continued, breastfeeding support, mental health screening; (4) Discharge planning early; (5) Outcomes: reduced LOS (1-2 days), opioid use ↓ 50%, complications ↓, breastfeeding rates ↑, patient satisfaction ↑; (6) SOGC + ERAS Society + Cooper Medical Center publications; (7) Implementation requires multidisciplinary team + audit + continuous improvement

---

ERAC = ERAS principles applied to cesarean. Evidence: shorter LOS, less opioid use, better breastfeeding, less morbidity, higher satisfaction. Multimodal pain management (intrathecal morphine + NSAID + acetaminophen + TAP block + minimal opioid) — opioid-sparing reduces side effects + neonatal exposure (in breastfeeding). Early diet + ambulation + Foley removal. Counseling + family-centered care. Quality improvement driven.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Hospital implements ERAS protocol for elective C-section — Enhanced Recovery After Cesarean (ERAC)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Pediatric + obstetric work separately"},{"label":"B","text":"Perinatal Care Integration"},{"label":"C","text":"Single specialty handles all"},{"label":"D","text":"Avoid newborn screening"},{"label":"E","text":"Discharge immediately"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Perinatal Care Integration — multidisciplinary obstetric + neonatal collaboration: (1) Pre-pregnancy: optimization (chronic disease, vaccinations, mental health, nutrition); (2) Antenatal: shared risk assessment, antenatal corticosteroid for preterm, MgSO4 for neuroprotection, GBS prophylaxis, level of care matching; (3) Intrapartum: skilled birth attendant, intermittent vs continuous monitoring, neonatal team alert for high-risk; (4) Delayed cord clamping 30-60 sec (improves iron stores, NEC, IVH); (5) Immediate skin-to-skin + early breastfeeding initiation; (6) Neonatal resuscitation if needed (NRP); (7) Newborn screening: pulse oximetry (CHD), hearing, blood spot (PKU, hypothyroid, CF, sickle cell, etc.), bilirubin; (8) NICU criteria + family involvement; (9) Postpartum: maternal screening (preeclampsia, depression, thyroid, infection, VTE, hemorrhage), breastfeeding support, contraception counseling; (10) Quality metrics: perinatal mortality rate, neonatal mortality, NICU admission, breastfeeding rates, preterm rate, c-section rate, severe morbidity; (11) Multidisciplinary team: obstetricians, midwives, neonatologists, anesthesia, lactation, social work, mental health, family medicine; (12) Continuity of care + transition

---

Perinatal care = integrative obstetric + neonatal + pediatric. Whole pregnancy journey + postpartum. Multidisciplinary team. Quality metrics. Outcomes improve with integrated care. Thai perinatal/neonatal mortality improving with system development. Family-centered. Continuous quality improvement.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Pediatric/Obstetric collaboration — reducing perinatal mortality + improving newborn outcomes';

update public.mcq_questions
set choices = '[{"label":"A","text":"Standard prenatal care"},{"label":"B","text":"SLE + APS Pregnancy — Multidisciplinary Integrative High-Risk Care"},{"label":"C","text":"Single specialty"},{"label":"D","text":"Stop all medications"},{"label":"E","text":"Termination"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** SLE + APS Pregnancy — Multidisciplinary Integrative High-Risk Care: (1) **Pre-conception**: disease optimization (low/no activity 6 mo before conception), medication review (continue HCQ — prevents flares + congenital heart block; avoid teratogenic — MMF, MTX, cyclophosphamide; corticosteroid OK; AZA OK; tacrolimus OK), folate, vaccination updates; (2) **Antenatal**: combined obstetric + rheumatology + maternal-fetal medicine clinic; (3) APS treatment: **low-dose aspirin** (start pre-conception or early pregnancy) + **prophylactic LMWH** (start positive pregnancy test) — reduces miscarriage, preeclampsia, IUGR risk; therapeutic LMWH if prior thrombosis history; (4) Monitor for SLE flare; (5) Lupus nephritis surveillance — proteinuria, Cr, complements; (6) Anti-Ro/SSA + Anti-La/SSB — congenital heart block + neonatal lupus risk — fetal echo monitoring weekly 16-26 wk; (7) Preeclampsia prevention — aspirin 81-150mg (high-risk indication), Ca, BP monitoring; (8) IUGR surveillance — serial growth US, umbilical Doppler; (9) Mental health support; (10) Delivery planning + timing (often induced/scheduled 37-39 wk based on activity + complications); (11) Postpartum: continue medications, flare risk highest, contraception (avoid estrogen in APS — VTE risk, OK with HCQ on activity controlled lupus), breastfeeding — most meds compatible; (12) Long-term follow-up with rheumatology

---

SLE + APS pregnancy = high-risk integrative care. Pre-conception optimization + medication review (HCQ continue, avoid teratogens). Combined MFM + rheumatology. APS — aspirin + LMWH. Monitor flares + complications (preeclampsia, IUGR, flare). Anti-Ro+/La+ — fetal heart block monitoring. Multidisciplinary. Outcomes excellent with optimized care vs poor without. Modern integrated care improves outcomes.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 35 ปี G2P1 GA 28 wk underlying SLE on hydroxychloroquine + low-dose prednisolone + APS (antiphospholipid syndrome) — history of recurrent miscarriage + DVT 2 ปีที่แล้ว

ADD ลูกคนที่แล้ว: IUGR + preeclampsia + small for gestational age

คำถาม: high-risk pregnancy multidisciplinary management';

update public.mcq_questions
set choices = '[{"label":"A","text":"Stop all medications + therapy"},{"label":"B","text":"Perinatal Mental Health"},{"label":"C","text":"Refuse all psychiatric care"},{"label":"D","text":"Pregnancy termination"},{"label":"E","text":"Single specialist"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Perinatal Mental Health — Integrative Care: (1) Pre-conception: counseling, medication review (most SSRIs OK — sertraline preferred; avoid paroxetine for new starts though not absolutely; counsel benefit-risk); (2) Continue treatment during pregnancy if beneficial — untreated depression has its own risks (preterm, LBW, postpartum depression, suicide, impaired bonding); (3) Multidisciplinary: OB + perinatal psychiatry + therapist + social work + primary care + lactation; (4) Monitor depression scores (EPDS, PHQ-9) throughout; (5) Address psychosocial stressors (intimate partner violence screening, financial, support); (6) **Postpartum**: highest risk period — postpartum blues (50-80%, < 2 wk, no Rx), postpartum depression (15-20%, treatment), postpartum psychosis (rare 0.1%, emergency); (7) Breastfeeding considerations — sertraline + paroxetine preferred (low milk transfer); (8) Support network — family, friends, support groups (mom support groups, online communities); (9) Screening tools: EPDS at every visit including postpartum, PHQ-9 alternatives; (10) Suicide risk assessment — leading cause maternal mortality some series (Ko JY MMWR 2017); (11) Pediatric outcomes follow-up — child development, attachment, behavior issues higher with untreated maternal depression; (12) ACOG + APA + AAP guidance — treatment generally outweighs medication risk in moderate-severe depression; (13) Trauma-informed care; (14) Continued care planning + transitions; (15) Family + partner involvement

---

Perinatal mental health = integrative multidisciplinary care. Untreated depression = significant risk (preterm, LBW, postpartum depression, suicide). SSRIs generally OK (sertraline preferred). Continue beneficial treatment. Postpartum highest risk period. Suicide leading maternal mortality cause in some series. Screen routinely (EPDS, PHQ-9). Multidisciplinary care + family support + breastfeeding considerations. Modern integrated care.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 28 ปี G1P0 GA 36 wk underlying severe depression + anxiety on sertraline 100 mg + receiving CBT therapy + family stress

คำถาม: perinatal mental health integrative management';

update public.mcq_questions
set choices = '[{"label":"A","text":"Chemotherapy alone"},{"label":"B","text":"Gynecologic Cancer Survivorship Integrative Care"},{"label":"C","text":"Stop all treatment"},{"label":"D","text":"Avoid follow-up"},{"label":"E","text":"Hospice only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Gynecologic Cancer Survivorship Integrative Care: (1) Active treatment: oncology team coordinated care, side effect management (nausea/vomiting, neuropathy, fatigue, alopecia, infection prevention, growth factors), nutritional support, exercise programs (improves outcomes), psychological + spiritual support; (2) Long-term survivorship (modern: many survive significantly with better Rx): - surveillance (clinical, CA-125, imaging) for recurrence; - PARP inhibitor maintenance if BRCA+; - secondary cancer screening; - cardiovascular monitoring (cardiotoxicity from some chemo); - bone health (DEXA, calcium, vitamin D); - sexual health (vaginal estrogen for GSM safe in non-hormone responsive cancers, lubricants, sexual therapy); - reproductive (premature ovarian failure if young — hormone considerations); - emotional/psychological (PTSD, anxiety, depression — high prevalence); - financial toxicity counseling; - return to work/role; (3) Survivorship care plan — written summary + plan provided; (4) Multidisciplinary: oncology, primary care, social work, psychology, nutrition, physical therapy, sexual health; (5) Family/caregiver support + bereavement preparation; (6) Palliative care integration (early palliative + curative treatment — Temel; recurrent disease — symptom + QOL focus); (7) End-of-life if appropriate — advance care planning, hospice; (8) Patient advocacy + support groups; (9) Genetic counseling — family screening for inherited cancer; (10) Equity in care + cultural competence

---

Cancer survivorship integrative care = multidisciplinary + lifelong. Modern ovarian cancer outcomes improving (PARP inhibitors). Survivorship care plan (IOM 2006). Multiple domains: surveillance, late effects, sexual health, mental health, return to function, financial, family. Integrated palliative care from diagnosis (Temel — improves QOL + survival). Family + caregiver support. Genetic counseling — implications for family. Continuous quality of life focus.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 65 ปี recently diagnosed advanced ovarian cancer (Stage IIIC) on chemotherapy — counsel + integrative care across cancer survivorship';

update public.mcq_questions
set choices = '[{"label":"A","text":"ส่ง dating US + first-trimester combined screening (PAPP-A + free β-hCG + NT) 11-13+6 wk เท่านั้น ไม่ต้องตรวจ lab อื่น"},{"label":"B","text":"First ANC visit"},{"label":"C","text":"ตรวจเฉพาะ ultrasound + folic acid + กลับมาใหม่ 28 wk"},{"label":"D","text":"ส่ง amniocentesis เพื่อ karyotype ทุกรายโดยไม่ดู risk"},{"label":"E","text":"เริ่ม insulin prophylaxis ทุกราย"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** First ANC visit: confirm pregnancy + dating US (CRL ที่ 11-13+6 wk เป็น gold standard); routine labs CBC, blood group/Rh, indirect Coombs, VDRL, anti-HIV, HBsAg, rubella IgG, urinalysis, urine culture; thalassemia screening (MCV, MCH, DCIP, Hb typing) — Thai high prevalence; first-trimester aneuploidy screening (combined test NT + PAPP-A + free β-hCG ที่ 11-13+6 wk) optional หรือ NIPT; folic acid 400-800 mcg/d, iodine 150 mcg, iron supplement; lifestyle counseling, avoid alcohol/smoking, food safety, vaccination (flu, Tdap 27-36 wk); calculate EDD by LMP vs CRL (LMP unreliable ถ้า CRL discrepancy > 7 d ใน first trimester ให้ใช้ US); risk assessment (chronic HT, DM, preeclampsia risk → aspirin 81-150 mg/d ตั้งแต่ 12-16 wk ถ้า high risk)

---

First ANC visit (ideal < 12 wk): dating, baseline risks, screening labs, vaccination, supplementation. Dating ด้วย CRL ใน first trimester accuracy ±5-7 วัน. Thai context: thalassemia screening + Hb E + DCIP. Aspirin 81-150 mg เริ่ม 12-16 wk ในกลุ่ม high risk preeclampsia (USPSTF 2021, ACOG).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงตั้งครรภ์ G1P0 GA 11 wk มา ANC ครั้งแรก ไม่มีโรคประจำตัว

V/S: BP 118/72, HR 84, RR 18, Temp 36.8
Fetal: FHR 162 (Doppler)
Lab pending: CBC, blood group, VDRL, HBsAg, Anti-HIV, rubella IgG, urinalysis';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discontinue all medications, observe only"},{"label":"B","text":"nifedipine ER"},{"label":"C","text":"Begin IV magnesium prophylaxis ทันที"},{"label":"D","text":"Cesarean immediately"},{"label":"E","text":"Atenolol + ACEI combination"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Chronic HT in pregnancy (BP ≥ 140/90 ก่อน 20 wk หรือก่อนตั้งครรภ์): target BP 110-135/85 (CHAP trial 2022 — tight control reduces preeclampsia + preterm + SGA โดยไม่เพิ่ม fetal harm); first-line agents safe: **labetalol** 100-400 mg BID-TID, **nifedipine ER** 30-90 mg/d, **methyldopa** 250-500 mg TID; AVOID ACEI/ARB (renal dysgenesis), atenolol (IUGR); aspirin 81-150 mg ตั้งแต่ 12 wk (preeclampsia prevention); serial growth US q 3-4 wk (IUGR risk); BP self-monitor + urine protein dipstick; surveillance for superimposed preeclampsia (sudden BP rise, new proteinuria, end-organ dysfunction); antenatal testing (NST/BPP) จาก 32-34 wk; delivery 38-39+6 wk ถ้า well-controlled, earlier ถ้า complications

---

Chronic HT พบ 1-5% ของการตั้งครรภ์. CHAP trial (NEJM 2022) — target < 140/90 เทียบกับ 160/110 ลด adverse outcomes โดยไม่เพิ่ม SGA. Drugs of choice: labetalol, nifedipine, methyldopa. ACEI/ARB contraindicated. Aspirin prevention + serial growth + monitor superimposed preeclampsia.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงตั้งครรภ์ G2P1 GA 28 wk underlying chronic HT มา ANC routine — no symptoms

V/S: BP 148/94 (clinic + home consistent), HR 88, RR 18
Fetal: FHR 144, fundal height appropriate, EFW 1,150 g (15th percentile)
Lab: Cr 0.8, AST/ALT WNL, Plt 240K, urine protein/Cr 0.18 (negative), uric acid 4.6';

update public.mcq_questions
set choices = '[{"label":"A","text":"Perform digital cervical exam immediately"},{"label":"B","text":"NO digital/speculum vaginal exam"},{"label":"C","text":"Vaginal delivery induction with oxytocin"},{"label":"D","text":"Discharge home with rest"},{"label":"E","text":"Misoprostol for cervical ripening"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Complete placenta previa with antepartum hemorrhage: **NO digital/speculum vaginal exam** until previa excluded (provoke hemorrhage); admit, IV access × 2 large-bore, type & cross 2-4 units, CBC + coag + Kleihauer-Betke (if Rh-); continuous fetal monitoring; Rh-immunoglobulin if Rh-negative; corticosteroid betamethasone 12 mg IM × 2 (GA < 34 wk) — ที่ 34 wk ยังพิจารณาได้ใน late preterm (ALPS trial); magnesium neuroprotection ถ้า < 32 wk; **tocolytics cautious** (nifedipine) ถ้า preterm + stable; cesarean delivery planned 36-37+6 wk สำหรับ complete previa (uncomplicated); emergency C/S ถ้า hemorrhage uncontrolled, fetal distress, labor; pelvic rest, no intercourse, counsel for re-bleed; consider transfer tertiary center with NICU + blood bank

---

Placenta previa: placenta over/near cervical os. Painless bright red bleeding 3rd trimester = classic. DO NOT perform digital exam (provokes bleed). US confirms position. Plan C/S 36-37+6 wk uncomplicated; emergency ถ้าเลือดออกมาก. Steroid + Rh-Ig + transfer. Placenta accreta spectrum risk (prior C/S).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงตั้งครรภ์ GA 34 wk G1P0 มาด้วย vaginal bleeding 200 mL bright red, ไม่มีปวดท้อง, ไม่มี contraction

V/S: BP 110/68, HR 96, RR 18
Fetal: FHR 148 reassuring, no contractions on toco
US: placenta covering internal os completely (complete placenta previa), AFI normal, EFW 2,100 g';

update public.mcq_questions
set choices = '[{"label":"A","text":"Expectant management — observe 24 hr"},{"label":"B","text":"emergency cesarean delivery"},{"label":"C","text":"Tocolytic to prolong pregnancy"},{"label":"D","text":"Discharge with pelvic rest"},{"label":"E","text":"Vacuum extraction"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Placental Abruption (premature separation of placenta — pain + dark bleeding + hypertonic uterus + fetal distress; risk factors: HT, trauma, cocaine, smoking, PPROM, multifetal, prior abruption): activate massive transfusion protocol; IV access × 2; type & cross 4 U PRBC + FFP + plt + cryo (DIC risk); CBC, coag, fibrinogen (< 200 ominous), Kleihauer-Betke; **emergency cesarean delivery** สำหรับ non-reassuring fetal status / maternal instability / abruption with viable fetus + fetal compromise; vaginal delivery ถ้า dead fetus + maternal stable (faster sometimes); manage hemorrhagic shock; DIC monitoring + correction; postpartum: anticipate PPH (Couvelaire uterus), uterotonics + balloon ± hysterectomy; Anti-D ถ้า Rh-negative; debrief + recurrence counseling (10-25% recurrence)

---

Abruptio placentae: separation of normally implanted placenta before delivery. Pain + dark bleeding + hypertonic/tender uterus + fetal distress = classic. Concealed hemorrhage = bleeding underestimated. Couvelaire uterus + DIC + AKI + fetal demise. HT/preeclampsia is leading risk. Emergency C/S ถ้า fetal viable + distress.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงตั้งครรภ์ GA 36 wk G3P2 prior 2 NSD มาด้วย sudden severe abdominal pain + dark vaginal bleeding 150 mL, hypertonic uterus

V/S: BP 158/96 (chronic HT history), HR 118, RR 24
Fetal: FHR baseline 100 with late decelerations
Abdomen: tense, board-like, fundal height > expected, tender
US: retroplacental hematoma 8×4 cm';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue routine ANC, repeat US 4 wk"},{"label":"B","text":"Selective IUGR in DCDA twin pregnancy (EFW < 10th percentile + discordance > 20-25% + abnormal Doppler)"},{"label":"C","text":"Immediate delivery at 32 wk regardless of Doppler"},{"label":"D","text":"Terminate pregnancy"},{"label":"E","text":"Discharge home, follow up 4 wk"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Selective IUGR in DCDA twin pregnancy (EFW < 10th percentile + discordance > 20-25% + abnormal Doppler): admit / close surveillance; serial US biweekly EFW + Doppler (umbilical artery, MCA, ductus venosus); NST/BPP twice weekly; corticosteroid betamethasone 12 mg IM × 2 (GA 32 wk = preterm); magnesium neuroprotection ถ้า delivery imminent < 32 wk; **delivery timing** balance prematurity vs stillbirth — for DCDA selective IUGR consider delivery 34-36 wk หรือ earlier ถ้า ductus venosus a-wave reversal/absent, BPP abnormal, oligohydramnios severe; mode cesarean preferred ถ้า twin A non-vertex; continuous monitoring during labor; NICU available; postnatal: SGA care, hypoglycemia screen

---

Twin pregnancies + selective IUGR (DCDA): one twin SGA, abnormal Doppler. Types I-III by umbilical artery Doppler pattern. DCDA = lower risk than MCDA (no shared circulation). Surveillance + steroids + plan delivery 34-36 wk uncomplicated, earlier ถ้า abnormal DV/BPP. MCDA monochorionic more complex (TTTS, sIUGR types).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 36 ปี G2P1 GA 32 wk twin pregnancy DCDA มา ANC — fundal height ตามอายุครรภ์, US: twin A 1,650 g (50th), twin B 1,180 g (5th percentile), EFW discordance 28%, twin B umbilical artery pulsatility index > 95th percentile, AFI twin A normal, twin B oligohydramnios

V/S: BP 124/78, HR 88
Fetal: NST twin A reactive, twin B reactive with variable decelerations';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue waiting until 43 wk"},{"label":"B","text":"induction of labor at 41+0 wk"},{"label":"C","text":"Cesarean immediately"},{"label":"D","text":"Discharge with weekly follow-up"},{"label":"E","text":"Wait for spontaneous labor 43 wk"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Postdates pregnancy (≥ 42+0 wk) approaching — ACOG/ARRIVE supports **induction of labor at 41+0 wk** to reduce stillbirth + meconium + macrosomia; current GA 41+3 + borderline AFI = induce; unfavorable cervix Bishop ≤ 6 → **cervical ripening** first: mechanical (Foley/Cook catheter, intracervical balloon) or pharmacological (PGE2 dinoprostone vaginal insert, or misoprostol PO/PV 25 mcg q 3-6 hr) → reassess Bishop → oxytocin augmentation ถ้า membranes ruptured / Bishop favorable; continuous EFM; AROM ถ้า progress; surveillance for meconium, fetal distress, shoulder dystocia (macrosomia risk); plan vaginal delivery uncomplicated; cesarean ถ้า failure of induction / fetal distress / arrest disorder; antenatal surveillance (NST/BPP twice weekly) จาก 41 wk ถ้า expectant (now obsolete with ARRIVE)

---

Postterm (≥ 42+0). Induce at 41+0 wk reduces stillbirth (ARRIVE trial — 39 wk elective IOL in low-risk nullip not harmful). Bishop score predicts IOL success. Cervical ripening (mechanical/PG) ถ้า unfavorable. Risks postterm: stillbirth, macrosomia, meconium, oligohydramnios, placental insufficiency.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 30 ปี G2P1 GA 41+3 wk — postdates pregnancy, ไม่มี contraction, ANC ปกติทั้งหมด, fetal movement count ปกติ

V/S: BP 122/76, HR 84
Fetal: FHR 148, NST reactive, AFI 6 (oligohydramnios — < 5 oligo; 5-8 borderline)
Cervix exam: Bishop score 4 (closed, posterior, 1 cm long, soft, station -2)
US: EFW 3,400 g, vertex';

update public.mcq_questions
set choices = '[{"label":"A","text":"Repeat US in 4 weeks"},{"label":"B","text":"delivery timing per TRUFFLE/GRIT"},{"label":"C","text":"Discharge with weekly ANC"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Increase maternal caloric intake — observe only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe early-onset FGR (< 3rd percentile + abnormal Doppler + oligohydramnios + maternal HT — likely placental insufficiency, possibly evolving preeclampsia): admit tertiary center; serial Doppler 2-3×/wk (umbilical, MCA, DV); NST/BPP daily; antihypertensive (labetalol/nifedipine) ถ้า BP ≥ 140/90; antenatal corticosteroid betamethasone 12 mg IM × 2 (GA 30 wk = preterm benefit); magnesium sulfate neuroprotection (GA < 32 wk); workup preeclampsia + sFlt-1/PlGF ratio ถ้า available; **delivery timing per TRUFFLE/GRIT**: at 30 wk, deliver ถ้า DV a-wave absent/reversed, repetitive late/variable decels, BPP ≤ 4, oligohydramnios severe + cessation of growth; otherwise continue with surveillance to 32-34 wk; cesarean preferred (fetal compromise + unfavorable cervix); NICU ready; counsel parents prematurity outcomes

---

Fetal Growth Restriction (FGR): EFW or AC < 10th percentile (ISUOG/Delphi consensus). Severe < 3rd or < 10th + abnormal Doppler. Cause = placental insufficiency (most), genetic, infection (TORCH). Doppler progression: umbilical PI → AEDV → REDV; MCA brain-sparing; DV a-wave abnormal = imminent. TRUFFLE — ductus venosus monitoring delivery timing in early FGR.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 24 ปี G1P0 GA 30 wk มา L&R for routine US — fetal biometry: HC 50th, AC 3rd percentile, FL 25th, EFW 950 g (< 3rd percentile)

V/S: BP 138/86, HR 90
Fetal: FHR 144 reactive, MCA PI 5th percentile, umbilical artery PI > 95th, ductus venosus normal a-wave, AFI 4 (oligohydramnios)
Lab: uric acid 6.2, plt 165K, AST/ALT WNL, urine protein/Cr 0.5';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue waiting and increase oxytocin"},{"label":"B","text":"Category II tracing with late decels (repetitive, persistent)"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Maternal pain control only"},{"label":"E","text":"Antibiotics only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Category II tracing with late decels (repetitive, persistent)** → intrauterine resuscitation: (1) reposition mother left lateral; (2) stop oxytocin; (3) IV fluid bolus 500-1000 mL; (4) O2 10 L NRB (controversial — limit); (5) check BP, treat hypotension (ephedrine/phenylephrine ถ้า epidural-induced); (6) vaginal exam — rule out cord prolapse, assess progress; (7) consider terbutaline 0.25 mg SC for tachysystole; (8) if no improvement 20-30 min OR Category III tracing (absent variability + recurrent late/variable/bradycardia, or sinusoidal) → **expedite delivery** — operative vaginal (vacuum/forceps) ถ้า fully dilated + station ≥ +2 OR emergency cesarean; intrauterine resuscitation continued during transfer; pediatric team standby; cord blood gas at delivery; document NICHD category timely

---

NICHD 3-tier system: Cat I normal, Cat II indeterminate (most), Cat III abnormal (act). Late decel = uteroplacental insufficiency (hypoxia). Variable = cord compression. Intrauterine resus: position, fluid, stop oxytocin, O2 (limit). Operative delivery vs C/S per progress + station.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 28 ปี G1P0 GA 39 wk in labor, dilation 6 cm. Contraction q 3 นาที × 60 วินาที strong. CTG: baseline 145, variability moderate, accelerations present, repetitive late decelerations เริ่มมา 30 นาที

V/S: BP 122/76, HR 92, Temp 37.0
Fetal: scalp pH not done, EFW 3,200 g, vertex station 0';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait for spontaneous reduction"},{"label":"B","text":"call for help, activate code emergency cesarean"},{"label":"C","text":"Vaginal delivery with augmentation"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Conservative observation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Umbilical Cord Prolapse (obstetric emergency — cord through cervix, compressed by presenting part): **call for help, activate code emergency cesarean**; (1) examiner''s hand in vagina — **elevate presenting part off cord** continuously (do not remove until delivery!); (2) maternal position — knee-chest หรือ steep Trendelenburg or left lateral; (3) bladder filling with 500-700 mL NSS via Foley → elevates head (can replace hand temporarily); (4) tocolytic terbutaline 0.25 mg SC to reduce contractions; (5) O2, IV fluid; (6) prepare for stat C/S — decision-to-delivery < 30 min ideally, ASAP; (7) cord exposed: keep moist with warm saline, avoid handling (vasospasm); (8) if fully dilated + station low + skilled operator → operative vaginal delivery (vacuum/forceps) faster; (9) document timeline + outcomes; counsel postpartum

---

Cord prolapse = obstetric emergency, fetal mortality high without immediate action. Risk: malpresentation, polyhydramnios, prematurity, multifetal, ARM with high station, long cord. Manage: relieve compression (elevate head, bladder fill, position), tocolytic, immediate C/S unless vaginal delivery imminent.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 33 ปี G3P2 GA 39+4 wk in labor, dilation 9 cm, contraction strong q 2 นาที. Suddenly บีบอวัยวะเพศพบ umbilical cord prolapse, FHR drops to 70

V/S: BP 118/72, HR 110
Fetal: FHR baseline 70 (severe bradycardia)
Cervix: 9 cm, vertex station -2';

update public.mcq_questions
set choices = '[{"label":"A","text":"Pull hard on the head + cut episiotomy deeply"},{"label":"B","text":"HELPERR mnemonic"},{"label":"C","text":"Cesarean delivery after head delivery"},{"label":"D","text":"Forceps to abdomen"},{"label":"E","text":"Continue observation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Shoulder Dystocia (failure of shoulder delivery + gentle traction failed) — **HELPERR mnemonic** in 60 sec increments: **H** — call for Help (additional OB, anesthesia, pediatrics, time-keeper); **E** — **Evaluate for Episiotomy** (does NOT relieve bony obstruction — only if needed for room for maneuvers); **L** — Legs (**McRoberts maneuver** — hyperflex thighs onto abdomen) — most effective single maneuver, success > 40%; **P** — **suprapubic Pressure** (NOT fundal — fundal worsens impaction) — Rubin I; **E** — Enter (internal rotational maneuvers: Rubin II, Wood''s screw, reverse Wood''s screw) — rotate posterior shoulder to oblique; **R** — **Remove** posterior arm (sweep across chest); **R** — Roll (Gaskin maneuver — all-fours position); last resort: Zavanelli (cephalic replacement + C/S), symphysiotomy, clavicular fracture; **AVOID excessive traction + fundal pressure** (brachial plexus injury — Erb''s palsy); document timing + maneuvers; postpartum: PPH, 4° laceration, neonatal Erb''s palsy, fracture

---

Shoulder dystocia = obstetric emergency. Anterior shoulder impacted on symphysis. Risk: macrosomia, DM, prior dystocia, postdates, prolonged 2nd stage, operative vaginal. HELPERR ordered maneuvers. McRoberts + suprapubic pressure resolve 50-60%. Complication: Erb''s palsy, clavicle fracture, asphyxia, PPH, perineal trauma.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 36 ปี G2P1 GA 40 wk in labor, head delivered แต่ shoulder ติด — shoulder dystocia recognized (turtle sign)

V/S: BP 130/80, HR 100
Fetal: head delivered 1 นาทีที่แล้ว, ไม่สามารถ deliver shoulder ได้ ด้วย gentle downward traction
EFW estimated 4,300 g, maternal DM2 history';

update public.mcq_questions
set choices = '[{"label":"A","text":"Immediate cesarean delivery"},{"label":"B","text":"PPROM at 28 wk (preterm, no infection) — expectant management: admit, bed rest;"},{"label":"C","text":"Discharge home with oral antibiotics"},{"label":"D","text":"Immediate IOL with oxytocin"},{"label":"E","text":"Methotrexate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** PPROM at 28 wk (preterm, no infection) — **expectant management**: admit, bed rest; (1) **antibiotic prophylaxis** — ampicillin 2 g IV q 6 hr + erythromycin 250 mg IV q 6 hr × 48 hr then amoxicillin 250 mg PO + erythromycin 333 mg PO × 5 d (MRC ORACLE) — prolongs latency, reduces chorioamnionitis + neonatal morbidity; (2) **antenatal corticosteroid** betamethasone 12 mg IM × 2 doses 24 hr apart — fetal lung maturity; (3) **magnesium sulfate neuroprotection** (GA < 32 wk) — 4-6 g loading then 1 g/hr; (4) **GBS prophylaxis** ใน labor; (5) NO tocolytics routinely (controversial — short-term ok for steroid completion); (6) surveillance — temp q 4 hr, CBC q 24-48 hr, fetal monitoring daily NST, US weekly (AFI, growth); (7) deliver ถ้า chorioamnionitis (fever, tachy, fundal pain, foul fluid), abruption, fetal compromise, labor; (8) deliver at 34+0 wk per ACOG (expectant vs delivery balance); counsel parents prematurity + cerebral palsy + lung disease

---

PPROM (< 37 wk) — leading cause of preterm birth. Diagnosis: pooling, nitrazine, ferning, AmniSure/ROM Plus. Risks: chorioamnionitis, abruption, cord prolapse, pulmonary hypoplasia (< 24 wk), prematurity. Antibiotic (latency), steroid, MgSO4 < 32 wk, deliver 34+0 wk uncomplicated or earlier ถ้า infection/distress.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 27 ปี G2P1 GA 28 wk PPROM 8 ชม ago — clear fluid leakage, no chorioamnionitis signs

V/S: BP 120/74, HR 92, Temp 37.1
Fetal: FHR 152 reactive, no contractions on toco
US: AFI 4 (oligohydramnios), EFW 1,150 g (50th), no abruption
Lab: WBC 11,000 (no left shift), CRP 8';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue augmentation"},{"label":"B","text":"STAT emergency cesarean delivery"},{"label":"C","text":"Increase oxytocin"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Observation 30 min"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Uterine Rupture (rare but catastrophic — sudden pain, loss of station, fetal distress/bradycardia, hemodynamic instability, fetal parts palpable in abdomen) — **STAT emergency cesarean delivery** (decision-to-incision < 10-15 min for fetal survival); concurrent: activate MTP, IV access × 2 large bore, type & cross 4-6 U PRBC + FFP + plt; aggressive fluid resuscitation; surgical management — laparotomy, deliver fetus + placenta, repair uterine rupture (primary repair ถ้า possible — single layer หรือ double layer; hysterectomy ถ้า extensive injury, hemorrhage uncontrolled, vascular damage, future fertility not desired); inspect bladder + ureter (often involved at lower segment); broad-spectrum antibiotics; postpartum: ICU, hemodynamic monitoring, blood products, DIC management; counsel future pregnancies — recurrent rupture risk ~10-30%, **no future VBAC**, elective cesarean 36-37 wk; document + risk management

---

Uterine rupture: TOLAC risk 0.5-1% (low transverse 1 prior); classic vertical 4-9%. Signs: pain, FHR abnormality (most common — bradycardia), loss of station, vaginal bleeding, hemodynamic instability, fetal parts palpable. Time-critical = emergency C/S < 30 min ideal. Repair vs hysterectomy. Counsel future planned delivery 36-37 wk no labor.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 30 ปี G3P2 GA 38 wk attempted VBAC after 1 prior low transverse cesarean. In active labor 6 cm, suddenly ปวดท้องเฉียบพลัน + loss of fetal station + abnormal CTG

V/S: BP 92/56, HR 128, RR 26
Fetal: FHR 70 bradycardia, loss of contractions on toco
Abdomen: tender + suprapubic palpable fetal parts';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge home, return tomorrow"},{"label":"B","text":"Retained placenta (> 30 min after delivery 3rd stage)"},{"label":"C","text":"Hysterectomy immediately"},{"label":"D","text":"Continue waiting 4 hr"},{"label":"E","text":"Misoprostol PR alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Retained placenta (> 30 min after delivery 3rd stage)** management: (1) IV access + uterotonics — oxytocin infusion (active management); ensure bladder empty (Foley); (2) **controlled cord traction with counter-pressure** (Brandt-Andrews); (3) consider umbilical vein injection oxytocin 20 U in 20 mL NSS (limited evidence); (4) if fails → **manual removal of placenta** under analgesia/anesthesia (regional preferred, or GA, or IV opioid + sedation) — sterile technique, hand in uterus, develop cleavage plane, remove + inspect for completeness; (5) prophylactic antibiotic single dose ampicillin or cefazolin; (6) post-removal: oxytocin infusion, monitor for PPH (atony, retained fragments); (7) examine placenta for completeness — if incomplete → uterine curettage; (8) suspect **placenta accreta spectrum** ถ้า unable to develop plane, profuse bleeding → consider hysterectomy/conservative management + IR embolization; (9) Anti-D ถ้า Rh-negative; counsel + iron

---

Retained placenta = > 30 min 3rd stage (active mgmt); risk PPH, infection. Management: uterotonics, bladder empty, cord traction, manual removal under anesthesia, antibiotic prophylaxis. Suspect accreta ถ้า no cleavage plane. Hysterectomy last resort.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 26 ปี G2P1 GA 38 wk normal labor, NSD เด็ก 3,200g 30 นาที — placenta ไม่หลุดออก, traction gentle ไม่หลุด, no excessive bleeding

V/S: BP 118/74, HR 86
Fundus: still high, soft';

update public.mcq_questions
set choices = '[{"label":"A","text":"Attempt vaginal delivery"},{"label":"B","text":"Placenta Accreta Spectrum (PAS — accreta/increta/percreta)"},{"label":"C","text":"Manual removal of placenta vaginally"},{"label":"D","text":"Wait until 40 wk"},{"label":"E","text":"Methotrexate to dissolve placenta"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Suspected **Placenta Accreta Spectrum (PAS — accreta/increta/percreta)** in setting of prior multiple C/S + previa: refer **tertiary center with multidisciplinary team** (MFM, GYN-oncology, urology, IR, anesthesia, NICU, blood bank); MRI to confirm + map extent (bladder involvement = percreta); blood products available (6-10 U PRBC + FFP + plt); IR consultation — preoperative ureteral stents + balloon catheters (internal iliac); plan **scheduled cesarean hysterectomy at 34-35+6 wk** before labor/bleeding (anterior previa + multiple C/S = high suspicion); antenatal corticosteroid; skin incision midline vertical, hysterotomy classical (avoid placenta), deliver fetus, **leave placenta in situ + immediate hysterectomy** (do not attempt to remove placenta — massive hemorrhage); urology for bladder repair if percreta; postoperative ICU; counsel future fertility loss; psychological support

---

Placenta accreta spectrum: abnormal trophoblast invasion. Risk: prior C/S + previa (compounding — each prior C/S ↑ risk). US signs: lacunae, loss of clear zone, bladder line interruption, increased vascularity. Plan delivery 34-35+6 wk multidisciplinary tertiary center. Cesarean hysterectomy + leave placenta in situ standard. Massive PPH risk.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 38 ปี G4P3 GA 35 wk prior 2 cesarean + 1 NSD, placenta previa anterior covering os + lacunae + loss of clear zone + bladder wall interrupted on US

V/S: BP 124/76, HR 88
Fetal: FHR 144 reactive, EFW 2,400 g';

update public.mcq_questions
set choices = '[{"label":"A","text":"Immediate cesarean"},{"label":"B","text":"NICHD ABCDEFGHIJ"},{"label":"C","text":"Continue pushing 2 more hr"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Vaginal misoprostol"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Operative Vaginal Delivery (vacuum or forceps) — criteria met: fully dilated, ruptured membranes, known position, station ≥ +2 (low or outlet), adequate analgesia, empty bladder, experienced operator, NICU available, willing consent; **vacuum extraction** — silastic/Kiwi cup, place over flexion point (3 cm anterior to posterior fontanelle); pull with contraction + maternal effort; max 3 pulls, 3 pop-offs, 15-20 min total; **forceps** — better for OP/asynclitic (manual rotation Kielland); contraindications: < 34 wk (vacuum), bleeding disorder, face/breech presentation, cephalopelvic disproportion suspected; **NICHD ABCDEFGHIJ** safety checklist (Address consent, BP, contractions, dilation, equipment, fetal position, gentleness, halt if no progress, incision/episiotomy, jaw — for shoulder dystocia preparation); post-delivery: assess for lacerations + episiotomy, infant scalp/cephalohematoma/subgaleal monitoring, NICU eval; failure → cesarean (do not attempt other instrument)

---

Operative vaginal delivery: vacuum or forceps in 2nd stage. Prolonged 2nd stage: nullip > 3 hr (epidural) or 2 hr; multip > 2 hr (epidural) or 1 hr. Indications: prolonged 2nd stage, fetal distress, maternal exhaustion/cardiac. Vacuum risks: cephalohematoma, subgaleal hemorrhage, retinal hemorrhage. Forceps: facial nerve palsy, lacerations.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงตั้งครรภ์ G2P1 GA 40+5 wk in labor, prolonged 2nd stage 3 hr with epidural, fetal station +2, OP position, maternal exhaustion, FHR cat II with variable decels

V/S: BP 118/72, HR 102, mother exhausted
Fetal: FHR 150 variable decels recovering, station +2, OP position
Cervix: fully dilated, no caput excessive, EFW 3,500 g';

update public.mcq_questions
set choices = '[{"label":"A","text":"Observation 24 hr"},{"label":"B","text":"Severe Preeclampsia with HELLP — imminent eclampsia (premonitory symptoms)"},{"label":"C","text":"Discharge home with antihypertensive"},{"label":"D","text":"Continue pregnancy without delivery"},{"label":"E","text":"Aspirin alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe Preeclampsia with HELLP — imminent eclampsia (premonitory symptoms): (1) **magnesium sulfate** 4-6 g IV loading over 15-20 min then 1-2 g/hr infusion × 24 hr postpartum — seizure prophylaxis (Pritchard or Zuspan); monitor reflexes + RR + urine output + Mg level (therapeutic 4.8-8.4 mg/dL); antidote calcium gluconate 1 g IV ถ้า toxicity; (2) **antihypertensive** — IV labetalol 20-40-80 mg q 10 min (max 220 mg) or hydralazine 5-10 mg q 20 min or oral nifedipine 10-20 mg q 30 min — target BP 140-150/90-100 (avoid over-correction — placental); (3) **antenatal corticosteroid** betamethasone 12 mg IM × 2 (GA 26 wk extreme preterm); (4) **stabilize then deliver** — at 26 wk consider expectant 24-48 hr for steroid completion ถ้า maternal/fetal stable, but HELLP + severe features → delivery (mode per obstetric); (5) ICU + multidisciplinary; (6) postpartum: continue Mg 24 hr, monitor BP + organ function, HELLP may worsen 48 hr postpartum; (7) eclamptic seizure protocol: ABC, left lateral, Mg, control airway

---

Severe preeclampsia features: BP ≥ 160/110, plt < 100K, LFT 2× ULN, Cr > 1.1, pulmonary edema, cerebral/visual symptoms, RUQ pain. HELLP = hemolysis (LDH, schistocytes) + elevated LFT + low plt. MgSO4 = seizure prophylaxis (gold standard, Magpie trial). Delivery is definitive. At extreme preterm (24-26 wk) brief stabilization 48 hr for steroid ถ้า possible — but HELLP often progresses → expedite.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 32 ปี G3P2 GA 26 wk มาด้วยอาการ severe headache + epigastric pain + RUQ pain + ตามัว 2 ชม

V/S: BP 178/118, HR 102, RR 22
Gen: hyperreflexia 4+, clonus +
Fetal: FHR 140, no contractions
Lab: plt 65K, AST 320, ALT 280, LDH 720, Cr 1.5, urine protein 4+, hemoglobin 9.8, schistocytes +';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue outpatient management"},{"label":"B","text":"expectant management may be considered briefly 24-48 hr for steroid completion"},{"label":"C","text":"Wait until 40 wk"},{"label":"D","text":"Cesarean immediately at 32 wk"},{"label":"E","text":"Discharge with aspirin only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Late Preterm Severe Preeclampsia at 32 wk (severe BP + thrombocytopenia + transaminitis = severe features) — admit, **expectant management may be considered briefly 24-48 hr for steroid completion** ถ้า fetal/maternal stable: (1) betamethasone 12 mg IM × 2 doses 24 hr apart (most benefit); (2) magnesium sulfate for seizure prophylaxis + neuroprotection; (3) antihypertensive — labetalol/nifedipine/hydralazine, target 140-150/90-100; (4) close maternal monitoring (vitals q 4 hr, labs q 12-24 hr — Hb, plt, LFT, Cr, LDH); (5) continuous fetal monitoring, daily NST + BPP; (6) **deliver at 34+0 wk OR earlier if** — uncontrollable BP, eclampsia, abruption, DIC, pulmonary edema, AKI, HELLP progression, non-reassuring fetal status, abnormal Doppler severe, IUFD; (7) mode of delivery per obstetric indication (vaginal preferred ถ้า favorable cervix); (8) postpartum: Mg 24 hr, BP monitoring, may need antihypertensive 6-12 wk; (9) future pregnancy counseling: recurrence + aspirin prophylaxis

---

Late preterm severe preeclampsia (34+0 wk) — deliver after steroid stabilization. Earlier (< 34) brief expectant for steroid + transfer ถ้า stable, deliver any GA ถ้า severe complications. Severity criteria: BP ≥ 160/110, plt < 100, LFT 2× ULN, Cr > 1.1, pulm edema, cerebral/visual.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 38 ปี G2P1 GA 32 wk gestational HT ตอน 30 wk — มาตอนนี้ BP 168/112 + new proteinuria 2+ + plt 105K + AST 95 + Cr 1.0 + ปวดศีรษะ

V/S: BP 168/112, HR 96
Fetal: FHR 144, EFW 1,650 g (30th), AFI 8, NST reactive';

update public.mcq_questions
set choices = '[{"label":"A","text":"ไม่ต้องตรวจเพิ่ม — เด็กจะปกติ"},{"label":"B","text":"Hb Bart''s hydrops fetalis (homozygous α-thalassemia-1, --/-- )"},{"label":"C","text":"Cesarean immediately"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Refer to oncology"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Both parents are α-thalassemia-1 carriers (Hb Bart''s = γ4, suggests --SEA deletion / α0-thalassemia; coexisting Hb E from β-globin) — at-risk couple for **Hb Bart''s hydrops fetalis (homozygous α-thalassemia-1, --/-- )** in 25% offspring (lethal — fetal hydrops, severe anemia, IUFD, maternal preeclampsia-like syndrome ''mirror syndrome''); workup: (1) confirm parental genotypes — **PCR for α-globin gene deletions** (SEA, Thai, FIL); (2) genetic counseling — explain 25% risk hydrops, 50% carrier, 25% normal; (3) offer **prenatal diagnosis** — chorionic villus sampling (CVS) at 11-13 wk or **amniocentesis** at 16-18 wk for fetal α-globin genotype (PCR); (4) options if affected fetus: termination of pregnancy (legal in Thailand for severe genetic disease per Medical Council), continue pregnancy with comfort care; (5) maternal risk if continued affected pregnancy: severe preeclampsia, hemorrhage, polyhydramnios; (6) folic acid supplementation; (7) iron only ถ้า iron deficiency confirmed (avoid iron overload in thal); (8) future pregnancy: preimplantation genetic testing (PGT-M)

---

Thailand thalassemia high prevalence — α-thal-1 carrier 4-14% in some regions. Hb Bart''s hydrops fetalis = homozygous α0/α0 (--/--), lethal. Couple both α-thal-1 carriers = 25% affected. Screen MCV, MCH, OF/DCIP test, Hb typing; confirm PCR for deletions. Prenatal diagnosis via CVS/amnio + PCR. Genetic counseling + reproductive options.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 24 ปี G1P0 GA 14 wk มา ANC ตรวจ thalassemia screening MCV 65, Hb typing: AE Bart''s. Husband MCV 68, Hb typing: AE Bart''s

V/S: BP 110/70, HR 80
Fetal: heart present 158 BPM';

update public.mcq_questions
set choices = '[{"label":"A","text":"Stop insulin"},{"label":"B","text":"Pregestational T1DM in pregnancy — comprehensive management"},{"label":"C","text":"Switch to oral metformin only"},{"label":"D","text":"Cesarean immediately at 28 wk"},{"label":"E","text":"Stop all surveillance"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pregestational T1DM in pregnancy — comprehensive management: (1) **glycemic targets** — fasting 70-95, 1h PP < 140, 2h PP < 120, A1c < 6.5% (if achievable safely); basal-bolus insulin — adjust doses (requirements ↑ 2-3× by 3rd trimester); CGM preferred (CONCEPTT trial — improved outcomes); (2) **ANC visits** every 1-2 wk; (3) **fetal surveillance** — detailed anomaly scan 18-22 wk (cardiac, neural tube — 3-4× risk), fetal echo 22-26 wk, serial growth US q 4 wk (macrosomia + polyhydramnios + IUGR with vasculopathy); (4) NST + BPP twice weekly from 32 wk; (5) **maternal complications** — DKA, hypoglycemia, retinopathy progression (dilated eye exam each trimester), nephropathy (urine ACR), preeclampsia (aspirin 81-150 mg from 12 wk), infection; (6) **delivery timing** — 39+0 wk uncomplicated well-controlled; 36-39 wk if vascular complications/poor control/macrosomia; (7) intrapartum — insulin drip to maintain BG 70-110; consider C/S if EFW > 4,500 g; (8) postpartum — insulin requirement ↓ dramatically; continue breastfeeding (↓ requirements); neonatal — hypoglycemia/RDS/polycythemia/hypocalcemia

---

Pregestational DM higher risks than GDM. Preconception A1c < 6.5% ideal — reduce congenital anomalies (cardiac, NTD, caudal regression). Aspirin preeclampsia prevention. Polyhydramnios = hyperglycemia → fetal polyuria. Macrosomia + shoulder dystocia. Insulin requirements rise (placental hormones). Postpartum drop dramatic.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 28 ปี G2P1 GA 28 wk type 1 DM since age 15, current HbA1c 7.2%, on insulin basal-bolus. Pre-pregnancy A1c 6.8%

V/S: BP 122/74, HR 88
Fetal: FHR 148, EFW 1,400 g (75th percentile — slight LGA), AFI 22 (mild polyhydramnios), no congenital anomalies on detailed US';

update public.mcq_questions
set choices = '[{"label":"A","text":"Do nothing — wait until delivery"},{"label":"B","text":"antenatal anti-D immunoglobulin (RhoGAM) 300 mcg IM at 28 wk"},{"label":"C","text":"Cesarean delivery"},{"label":"D","text":"Stop pregnancy"},{"label":"E","text":"Methotrexate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Rh isoimmunization prophylaxis (mother Rh-negative + father Rh-positive or unknown + Coombs negative): **antenatal anti-D immunoglobulin (RhoGAM) 300 mcg IM at 28 wk** — prevents sensitization from silent fetomaternal hemorrhage in 3rd trimester (~1.5% sensitization risk without prophylaxis); repeat **postpartum 300 mcg IM within 72 hr ถ้า baby Rh-positive**; **Kleihauer-Betke test** ถ้า significant fetomaternal hemorrhage suspected (abruption, trauma, fetal-maternal hemorrhage > 30 mL → larger dose: 300 mcg per 30 mL fetal blood); additional 50-300 mcg doses for sensitizing events: spontaneous/induced abortion, ectopic pregnancy, CVS/amniocentesis, external cephalic version, trauma, antepartum bleeding; if **already sensitized** (Coombs positive) — anti-D Ig does NOT help; manage with serial antibody titers, MCA Doppler (peak systolic velocity > 1.5 MoM = severe fetal anemia), intrauterine transfusion (IUT) PUBS; non-invasive fetal RhD genotyping (cell-free DNA) — limit prophylaxis ถ้า fetus Rh-negative (Europe practice)

---

Anti-D prophylaxis: 28 wk routine + postpartum + sensitizing events. Sensitization → next pregnancy hemolytic disease (hydrops fetalis). Monitor sensitized: titers, MCA-PSV > 1.5 MoM, IUT. Non-invasive cffDNA fetal RhD typing increasingly used.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 26 ปี G1P0 GA 28 wk previously healthy มา OPD ตรวจ ANC routine — Rh-negative (mother), Rh-positive (father). Indirect Coombs negative ใน first trimester

V/S: BP 118/72, HR 84
Fetal: FHR 152, growth appropriate';

commit;
