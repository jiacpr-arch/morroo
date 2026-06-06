-- ===============================================================
-- UPDATE: ob_gyn (200 questions)
-- ===============================================================

begin;

update public.mcq_questions
set choices = '[{"label":"A","text":"Observation outpatient"},{"label":"B","text":"Severe Preeclampsia with HELLP syndrome (BP severe + end-organ dysfunction)"},{"label":"C","text":"Wait until 40 weeks"},{"label":"D","text":"Anti-hypertensive only without delivery"},{"label":"E","text":"Aspirin only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe Preeclampsia with HELLP syndrome (BP severe + end-organ dysfunction): admit; IV magnesium sulfate 4-6g loading then 1-2g/hr × 24h (seizure prophylaxis); antihypertensive — IV labetalol 20-80mg or hydralazine 5-10mg or oral nifedipine 10-20mg (target BP 140-150/90-100, not normal — placental perfusion); corticosteroid betamethasone 12mg IM × 2 (fetal lung maturity even at 36 wk if preterm) — but at 36 wk + HELLP = expedite delivery; **expedite delivery** is definitive treatment (HELLP + severe features → delivery regardless of GA after stabilization); mode (vaginal vs c-section) per obstetric indication; postpartum: continue magnesium 24h after delivery, BP monitoring, may need antihypertensive 6 wk

---

Preeclampsia: BP ≥ 140/90 + proteinuria (or end-organ dysfunction without proteinuria) after 20 wk. Severe features: BP ≥ 160/110, plt < 100K, LFT 2× ULN, Cr > 1.1, pulmonary edema, visual/cerebral symptoms. HELLP: hemolysis + elevated LFT + low platelets. Delivery is definitive Rx. Magnesium for seizure prophylaxis (eclampsia). BP control (avoid maternal stroke; don''t over-correct — placental perfusion). Steroid if < 34 wk. Postpartum continue Mg + monitor.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงตั้งครรภ์ GA 36 wk G1P0 มา ANC ตรวจ BP 162/108 (สูงต่อเนื่อง 3 ครั้ง ห่าง 4 ชม) + proteinuria 3+ + edema + ปวดศีรษะ + เห็นแสงวาบ

Lab: Plt 88,000, AST 188, ALT 142, LDH 685, Cr 1.2, Total protein 5.8, Uric acid 7.8
Urine protein/Cr 4.2 g/g, 24h urine protein 5.2 g';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge home"},{"label":"B","text":"Preterm Labor"},{"label":"C","text":"Cesarean immediately"},{"label":"D","text":"Antibiotic only"},{"label":"E","text":"Discharge with progesterone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Preterm Labor: admit + assess; tocolytics — nifedipine 20-30mg PO loading then 10-20mg q4-6h (preferred, calcium channel blocker) OR indomethacin (< 32 wk only — ductus arteriosus closure risk); other options atosiban (oxytocin antagonist), magnesium (also neuroprotection); duration 48h to allow steroid + transfer; antenatal corticosteroid betamethasone 12mg IM × 2 doses 24h apart (mature fetal lung — reduces RDS, IVH, NEC, mortality 30-50% per Cochrane); magnesium sulfate 4-6g loading then 1-2g/hr for fetal neuroprotection (< 32 wk); GBS prophylaxis if positive or unknown; do NOT tocolyze if: chorioamnionitis, severe preeclampsia/eclampsia, abruption, IUFD, lethal anomaly, advanced labor > 5cm; counsel for NICU; consider transfer to tertiary if level 3 NICU not available

---

Preterm labor: contractions + cervical change before 37 wk. Management focus: delay birth 48h for steroids + neuroprotection + transfer. Tocolytics (nifedipine first-line, atosiban, MgSO4, indomethacin < 32 wk). Antenatal steroids — Liggins 1972 — major mortality reduction. Magnesium for fetal neuroprotection < 32 wk. GBS prophylaxis. Don''t tocolyze if contraindicated. Transfer to tertiary if possible.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงตั้งครรภ์ GA 32 wk G2P1 มาห้องฉุกเฉินด้วย contractions ทุก 5 นาที × 2 ชม + กระเป๋าน้ำคร่ำไม่แตก

Cervix exam: 2 cm dilated, 80% effaced, ทารก vertex
Fetal heart rate: 142 reassuring
US: ทารกประมาณ 1,800g, AFI ปกติ, placenta upper segment';

update public.mcq_questions
set choices = '[{"label":"A","text":"Observation + IV fluid only"},{"label":"B","text":"Postpartum Hemorrhage (PPH > 500mL NSD, > 1000mL C/S, or any with hypovolemia) from uterine atony (most common cause"},{"label":"C","text":"Hysterectomy immediately"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Anticoagulation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Postpartum Hemorrhage (PPH > 500mL NSD, > 1000mL C/S, or any with hypovolemia) from uterine atony (most common cause — 70%): activate massive transfusion protocol if needed; uterine massage (bimanual); empty bladder (catheter); IV oxytocin 10-40 units in 1L NSS infusion (first-line — already given postpartum); second-line uterotonics: methylergonovine 0.2mg IM (CI in HT/preeclampsia), carboprost (15-methyl PGF2α) 250mcg IM (CI in asthma), misoprostol 800-1000mcg PR; tranexamic acid 1g IV (WOMAN trial); blood products with MTP protocol 1:1:1; balloon tamponade (Bakri); uterine artery embolization (IR); surgical: B-Lynch suture, uterine artery ligation, hysterectomy (last resort); identify 4 T''s: Tone (atony), Trauma (laceration), Tissue (retained), Thrombin (coagulopathy)

---

PPH = leading cause of maternal mortality globally. 4 T''s: **T**one (atony 70% — most common), **T**rauma (laceration, hematoma), **T**issue (retained products), **T**hrombin (coagulopathy). Atony management: massage + uterotonics (oxytocin first-line, then methylergonovine, carboprost, misoprostol) + balloon tamponade + uterine artery embolization + surgical options. TXA within 3h reduces mortality (WOMAN trial). Blood products 1:1:1. Hysterectomy last resort. Active management of 3rd stage (oxytocin) reduces PPH.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 28 ปี G2P1 GA 39 wk normal delivery NSD 2 ชม ก่อน อยู่หลังคลอด มาด้วยอาการ heavy bleeding + uterus boggy + ปวดท้อง

V/S: BP 88/52, HR 132, RR 24
Gen: pale, anxious
Uterus: 4 finger breadths above umbilicus, soft + boggy
Bleeding: heavy ongoing ~ 1L estimated

Hb 6.4 (baseline 11), Plt 178K, INR 1.2
Cervix exam: no laceration, placenta delivered complete';

update public.mcq_questions
set choices = '[{"label":"A","text":"Ignore — manage after delivery"},{"label":"B","text":"Gestational Diabetes Mellitus (GDM) management"},{"label":"C","text":"Insulin without diet education"},{"label":"D","text":"Cesarean immediately"},{"label":"E","text":"Restrict carbohydrate completely"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Gestational Diabetes Mellitus (GDM) management: (1) Medical nutrition therapy first-line (registered dietitian — 40-50% calories from carb, 20% protein, 30-40% fat, distributed 3 meals + 2-3 snacks); (2) Exercise 30 min/d if no contraindication; (3) Self-monitor blood glucose 4×/d (fasting + 1 or 2h postprandial) — targets: fasting < 95, 1h < 140, 2h < 120; (4) Pharmacotherapy if MNT fail (target not met 50% of time after 1-2 wk): **insulin** preferred (does not cross placenta — long-acting NPH/detemir/glargine + rapid lispro/aspart); metformin/glyburide alternatives (cross placenta, ACOG accepts but insulin preferred); (5) Antepartum surveillance — NST + AFI weekly from 32-34 wk; (6) Delivery timing — 39-40 wk uncomplicated GDM on diet; 39 wk if on medication well-controlled; earlier if complications; (7) Intrapartum: glucose control 70-110, insulin drip if needed; (8) Postpartum: usually return to normal; OGTT 6-12 wk postpartum (50% develop T2DM lifetime); (9) Lifestyle: weight, exercise, prevention; (10) Recurrence high in future pregnancies

---

GDM: glucose intolerance first recognized in pregnancy. Screening 24-28 wk (1-step OGTT 75g or 2-step). Management: MNT first, insulin if MNT fail (insulin preferred — no placental crossing). Surveillance + delivery timing. Macrosomia, shoulder dystocia, preeclampsia, NICU risks. Postpartum OGTT — 50% develop T2DM. Lifestyle modification reduces.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 32 ปี G3P2 GA 28 wk ANC ตรวจพบ GDM screening positive (OGTT fasting 105, 1h 195, 2h 168 — meets ADA/ACOG criteria)

ก่อนหน้านี้ลูก 1 คนเป็น macrosomia 4.2kg shoulder dystocia
Family history: father DM type 2';

update public.mcq_questions
set choices = '[{"label":"A","text":"Observation"},{"label":"B","text":"Ectopic Pregnancy (high suspicion: β-hCG > 1500 + empty uterus + adnexal mass + free fluid): IV access × 2 + type & cross; consult OB-GYN immediately; treatment options"},{"label":"C","text":"Misoprostol for missed abortion"},{"label":"D","text":"Continue current pregnancy support"},{"label":"E","text":"Discharge with iron supplement"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Ectopic Pregnancy (high suspicion: β-hCG > 1500 + empty uterus + adnexal mass + free fluid): IV access × 2 + type & cross; consult OB-GYN immediately; treatment options: (1) **Methotrexate** (medical management) — criteria: hemodynamically stable, β-hCG < 5000, ectopic < 3.5cm, no fetal heart, no rupture; protocol single-dose 50 mg/m² IM, follow β-hCG day 4 + 7 (expect 15% decline), repeat if needed; (2) **Surgical** — laparoscopic salpingostomy (preserve tube) or salpingectomy (remove tube — if extensive damage, contralateral healthy tube, no future fertility plan) — indications: hemodynamic instability, rupture, methotrexate CI, large mass, fetal heart, β-hCG > 5000; (3) **Expectant management** — selected very low β-hCG declining; (4) Rh(D)-negative + bleeding → Anti-D Ig 50-300 mcg; (5) Contraception + future fertility counseling; (6) **Differential**: PID, ovarian cyst, appendicitis, threatened abortion

---

Ectopic pregnancy: implantation outside uterine cavity (95% tubal). Suspicion: positive β-hCG + abdominal pain + bleeding + adnexal mass. Discriminatory zone: β-hCG > 1500-2000 + no IUP on TVS = ectopic likely. Methotrexate vs surgery decision: hemodynamics, β-hCG, size, fetal heart, patient factors. Rupture = surgical emergency. Future fertility preserved better with conservative management. Counsel + contraception + future fertility.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 22 ปี LMP 6 สัปดาห์ที่แล้ว มาห้องฉุกเฉินด้วยอาการ acute onset ปวดท้องน้อยขวา + vaginal spotting 12 ชม

V/S: BP 96/62, HR 108
Gen: pale, anxious
Abdomen: RLQ + suprapubic tenderness, guarding +
Pelvic: cervical motion tenderness +, right adnexal mass + tenderness

β-hCG quantitative 4,800 mIU/mL
US pelvis: empty uterus + right adnexal complex mass 3.5cm + free fluid in pelvis (moderate)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Observation"},{"label":"B","text":"Placental Abruption (premature separation) with developing DIC + non-reassuring fetal status"},{"label":"C","text":"Vaginal delivery induction"},{"label":"D","text":"Tocolytic"},{"label":"E","text":"Discharge"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Placental Abruption (premature separation) with developing DIC + non-reassuring fetal status: emergency C-section delivery (immediate — both mother + fetus at risk); concurrent: IV access × 2 large bore + type & cross 4 units PRC + 4 FFP; correct coagulopathy (FFP, cryoprecipitate for fibrinogen < 200, platelets if < 50K, PRBCs); manage shock; massive transfusion protocol if needed; tranexamic acid (WOMAN); anesthesia consultation; NICU notification; postpartum: monitor for PPH (uterine atony commonly follows), continue coagulopathy correction, monitor Hb, may need ICU; counsel: 5-15% recurrence next pregnancy; risk factors: HT, smoking, cocaine, trauma, prior abruption, advanced maternal age, multiple gestation

---

Placental abruption: premature separation. Spectrum from mild to catastrophic. Severe: pain + bleeding + uterine tetany + DIC + fetal distress. Risk factors: HT, smoking, cocaine, trauma, prior abruption. Imaging: US often misses (only sees if large clot). Diagnosis often clinical. Management: stabilize + deliver (C-section if non-reassuring fetal status or maternal compromise; vaginal if reassuring + stable + advanced labor). Major bleeding + DIC complication. PPH common. Recurrence risk 5-15%.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 35 ปี G2P1 GA 38 wk มา L/R complaining of decreased fetal movement × 12 ชม + small amount vaginal bleeding

V/S: BP 112/72, HR 92, RR 16
Abdomen: tense + tender + palpable contractions painful
Fetal heart: 110 (mild bradycardia)
Cervix: closed, no advanced labor

US: placental abruption suspected (retroplacental clot + abnormal placental edge)
Lab: Hb 10.4, Plt 162K, Fibrinogen 220 (low), INR 1.6 (high) — DIC features developing';

update public.mcq_questions
set choices = '[{"label":"A","text":"Hysterectomy alone"},{"label":"B","text":"Treatment of hyperplasia without atypia"},{"label":"C","text":"Observation only"},{"label":"D","text":"Total pelvic radiation"},{"label":"E","text":"Chemotherapy"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Abnormal Uterine Bleeding (AUB) — PALM-COEIN classification: structural (P-polyp, A-adenomyosis, L-leiomyoma, M-malignancy/hyperplasia) + non-structural (C-coagulopathy, O-ovulatory dysfunction, E-endometrial, I-iatrogenic, N-not classified); this patient: leiomyoma + complex hyperplasia: (1) **Iron supplement** for anemia; (2) **Treatment of hyperplasia without atypia**: progestin (LNG-IUD preferred — Mirena 90% effective + provides contraception + treats heavy bleeding; or oral medroxyprogesterone, micronized progesterone, megestrol) × 3-6 mo then repeat biopsy; if complex with atypia → hysterectomy preferred (high cancer risk); (3) **Treatment of fibroids causing AUB**: - Medical: LNG-IUD, combined OCP, NSAIDs, tranexamic acid acute (Lukes JAMA 2010), GnRH agonist temporary (suppress to operate), GnRH antagonist (elagolix); - Procedural: uterine artery embolization (UAE — preserves uterus, fibroid shrink), myomectomy (preserves uterus + fertility — open, laparoscopic, hysteroscopic for submucosal); hysterectomy (definitive — for refractory + completed childbearing or large symptomatic); endometrial ablation (alternative); (4) Counseling: future fertility, recurrence (fibroids), follow-up; (5) Surveillance for hyperplasia progression + endometrial cancer

---

AUB workup: PALM-COEIN classification (Munro AOG 2011). Structural causes more common with age. Endometrial sampling required for risk factors (age > 45, persistent AUB, obesity, anovulation, HRT). Hyperplasia without atypia: progestin Rx + reassess. Hyperplasia with atypia: hysterectomy preferred (40% concurrent cancer). Fibroid management: medical + procedural + surgical based on size, location, symptoms, fertility desires. LNG-IUD highly effective for heavy menstrual bleeding.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 45 ปี มา OPD ด้วยอาการเลือดประจำเดือนผิดปกติ — heavy menstrual bleeding + intermenstrual spotting × 6 เดือน + น้ำหนักลด 3 kg

LMP irregular last 4 months
No dyspareunia, no fever

V/S: ปกติ
Pelvic exam: enlarged uterus 14 wk size + irregular contour
No cervical lesion, no adnexal mass

Lab: Hb 9.2 (anemia), TSH normal
US: multiple uterine fibroids (intramural + submucosal) largest 6cm + endometrial thickening 14mm
Endometrial biopsy: complex hyperplasia without atypia';

update public.mcq_questions
set choices = '[{"label":"A","text":"Observe + repeat in 5 years"},{"label":"B","text":"Cervical CIN 2-3 (high-grade) — pre-cancerous lesion requiring treatment"},{"label":"C","text":"Total hysterectomy"},{"label":"D","text":"Chemotherapy"},{"label":"E","text":"Stop screening"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cervical CIN 2-3 (high-grade) — pre-cancerous lesion requiring treatment: (1) **Excisional treatment preferred** over ablation: LEEP (loop electrosurgical excision procedure) — most common, outpatient, can do cone biopsy at same time; cold-knife conization (CKC) — for endocervical lesion, possible micro-invasion; (2) **Ablative treatment** alternative (cryotherapy, laser) — only for selected (visible squamocolumnar junction, no glandular involvement, no suspicion for invasion); (3) **Post-treatment surveillance**: cytology + HPV co-testing 6 + 18 months + annually × 3 years then routine if normal; (4) Margin status: if positive endocervical margin → repeat excision or close follow-up; (5) **Pregnancy considerations**: LEEP/CKC increase preterm birth risk slightly; defer if pregnant unless invasive; (6) **HPV vaccination** for partner, future children (HPV vaccine for women 9-26 routinely, 27-45 selective; nonavalent vaccine covers 90% cervical cancers); (7) Counseling: HPV common, often clears, treatable lesion not cancer, importance of follow-up; (8) Sexual partner — no specific testing; (9) Smoking cessation (smoking accelerates CIN progression); (10) Long-term: HPV co-testing q 3-5 years standard cervical cancer screening

---

Cervical cancer prevention: HPV vaccination + screening + treat precancers. HPV 16, 18 cause 70% cervical cancers. CIN 2-3 = high-grade precancer → 30% progress to cancer if untreated. Treatment: excisional (LEEP, CKC) preferred. ASCCP risk-based management guidelines. Post-treatment surveillance critical. HPV vaccine effective for prevention. Modern: HPV primary screening replacing cytology in many settings. WHO target — eliminate cervical cancer.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 26 ปี ไม่มีโรคประจำตัว มาตรวจคัดกรอง pap smear (cervical cytology) ผลเป็น HSIL (high-grade squamous intraepithelial lesion)

Follow-up colposcopy: CIN 2-3 confirmed by biopsy
HPV testing: positive HPV 16 + 18

ไม่มีอาการ, sexually active, ไม่ pregnant';

update public.mcq_questions
set choices = '[{"label":"A","text":"Observation"},{"label":"B","text":"Endometrial Adenocarcinoma Stage I (presumed — endometrioid, low grade) — surgical staging primary"},{"label":"C","text":"Hormone replacement therapy"},{"label":"D","text":"Discharge — physiologic bleeding"},{"label":"E","text":"Pap smear only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Endometrial Adenocarcinoma Stage I (presumed — endometrioid, low grade) — surgical staging primary: (1) **Surgical staging** = standard of care — laparoscopic, robotic, or open total hysterectomy + bilateral salpingo-oophorectomy + lymphadenectomy (sentinel node biopsy increasingly used vs full pelvic + para-aortic dissection); peritoneal washings, omentectomy in selected; (2) **Final stage** determined by surgical pathology — FIGO 2009 + 2023 updates; (3) **Adjuvant therapy** based on risk: Stage IA Grade 1-2: no adjuvant; Stage IA Grade 3 or IB: vaginal brachytherapy +/- chemotherapy; Stage II-III: external beam RT + chemotherapy (carboplatin + paclitaxel); (4) **Molecular classification** (TCGA): POLE-ultramutated (good prognosis), MSI-high, copy-number low/p53 wild-type, copy-number high/p53 mutant (worst); guides therapy increasingly; (5) **Hormonal therapy** (selected): progestin for poor surgical candidates or fertility preservation in Grade 1; (6) **Targeted therapy**: pembrolizumab + lenvatinib for advanced/recurrent (KEYNOTE-775); (7) **Lifestyle**: weight loss, glycemic control, exercise; (8) **Genetic counseling**: Lynch syndrome screening (3-5% of endometrial cancers, age < 50, family history); (9) **Survivorship**: surveillance pelvic exam, symptoms monitoring; (10) **Multidisciplinary**: GYN-oncology, radiation oncology, medical oncology

---

Postmenopausal bleeding ALWAYS requires evaluation — endometrial cancer until proven otherwise. Type I (endometrioid, estrogen-dependent — obesity, DM, nulliparity, late menopause, tamoxifen) vs Type II (serous, clear cell — older, p53). Surgical staging standard. Molecular classification (TCGA) emerging. Lynch syndrome screening — implications for family. Adjuvant therapy stage + grade + molecular based. Survival good if early (Stage I > 90% 5-year).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 58 ปี postmenopausal × 7 ปี ก่อนหน้านี้ healthy มาด้วยอาการ vaginal bleeding ผิดปกติ 2 สัปดาห์ — เลือดออกเล็กน้อยติดต่อกัน

BMI 32 (obese), DM type 2, HT, ไม่เคยตั้งครรภ์

V/S: BP 142/88, HR 78
Gen: well, slightly obese
Pelvic exam: ปกติ external + cervix
No adnexal mass

US: endometrial thickness 18mm (postmenopausal > 4 mm requires evaluation)
Endometrial biopsy: endometrioid adenocarcinoma, Grade 1, hormone receptor positive';

update public.mcq_questions
set choices = '[{"label":"A","text":"No screening needed"},{"label":"B","text":"Comprehensive First Trimester Care"},{"label":"C","text":"Cesarean planned at 39 wk"},{"label":"D","text":"Single visit follow-up"},{"label":"E","text":"No vaccination"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Comprehensive First Trimester Care: (1) **History + examination**: comprehensive including obstetric, medical, surgical, family, social, drug, allergy, mental health, IPV screening; (2) **Vital signs + BMI + edema baseline**; (3) **Lab tests**: CBC, blood group + Rh + antibody screen, hepatitis B sAg, syphilis (VDRL/RPR), HIV (opt-out), rubella IgG, varicella IgG if no history, urine culture + UA, Pap smear if due (per cervical screening guideline), GBS at 36-37 wk; (4) **Genetic screening (offered to all regardless of age — ACOG 2020)**: first trimester combined screen (PAPP-A + free β-hCG + NT US at 11-13+6 wk — detects 85% Down with 5% FPR); cell-free DNA / NIPT (cfDNA from maternal blood — detects 99% Down, also 18, 13, sex chromosomes, increasingly accurate, growing standard); quad screen 15-20 wk if not first; diagnostic — CVS 10-13 wk (1% miscarriage), amniocentesis 15-20 wk (0.5% miscarriage) — for positive screen or specific risk; (5) **Carrier screening** (offered all): cystic fibrosis, spinal muscular atrophy, hemoglobinopathies (thalassemia in Asian — Thai high risk!), fragile X, Ashkenazi panel, expanded carrier; (6) **Vaccinations**: Tdap (27-36 wk), flu (any time), COVID, RSV (32-36 wk new); (7) **Counseling**: nutrition (folate 400 mcg + iron + calcium + DHA), exercise (moderate OK), avoid alcohol/smoking/illicit, medications review (teratogens), seafood, listeria foods, hot tubs, travel; (8) **Schedule prenatal visits** per gestational age; (9) **Mental health screening**: depression, anxiety; (10) **Anticipatory guidance** + birth plan; (11) **Confirm IUP + viability** US

---

Comprehensive first trimester prenatal care = foundation. Universal genetic screening offered (ACOG 2020 update — previously only AMA). NIPT increasingly standard. Carrier screening — Thai population specific (thalassemia high prevalence). Vaccinations (Tdap, flu, COVID, RSV). Nutrition + lifestyle counseling. Mental health screening. Multidisciplinary if high-risk. Quality care = better outcomes (Thai maternal mortality improving over decades).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 32 ปี ตั้งครรภ์ GA 12 wk G1P0 มาตรวจ ANC ครั้งแรก — counseling on prenatal genetic screening + first trimester care

No family history concerning, no consanguinity
Maternal age 32 (not advanced maternal age which is 35+)
No medical comorbidity';

update public.mcq_questions
set choices = '[{"label":"A","text":"Induce labor immediately"},{"label":"B","text":"PPROM (Preterm PROM) at 33 weeks"},{"label":"C","text":"Tocolyze long-term"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Cesarean immediately"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** PPROM (Preterm PROM) at 33 weeks: admit; expectant management to 34 wk if uncomplicated (balance prematurity vs infection risk); GBS prophylaxis (penicillin or alternatives); broad-spectrum antibiotic course — ampicillin + erythromycin (or azithromycin) × 7 days reduces chorioamnionitis + delivery latency (NICHD); antenatal corticosteroids (betamethasone × 2 doses) — fetal lung maturity; magnesium sulfate for neuroprotection < 32 wk; serial monitoring — fetal heart rate, uterine contractions, infection markers (WBC, CRP, fever), fluid color; delivery if: chorioamnionitis (fever, fetal tachycardia, uterine tenderness, foul fluid), non-reassuring fetal status, abruption, advanced labor, or reaching 34 wk; counsel; NICU notification

---

PPROM 24-34 wk: expectant management with surveillance, steroids, antibiotics, MgSO4 (neuroprotection < 32 wk). Antibiotic course (ampicillin + erythromycin or azithromycin × 7 days per NICHD/ORACLE) reduces chorioamnionitis + delays delivery. Deliver at 34 wk or if complications. Maternal/fetal surveillance critical. NICU planning.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงตั้งครรภ์ GA 33 wk G3P2 มาห้องฉุกเฉินด้วยอาการน้ำคร่ำแตก 6 ชม ก่อน ไม่มีการเจ็บครรภ์

V/S: BP 122/74, HR 88, RR 16, Temp 37.4°C
Vaginal exam: pooling of fluid in posterior fornix, nitrazine + (alkaline), ferning + on microscopy
Fetal heart 142 reassuring, no contractions
Cervix closed';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge with paracetamol"},{"label":"B","text":"Thiamine before glucose"},{"label":"C","text":"Termination of pregnancy"},{"label":"D","text":"Antibiotic"},{"label":"E","text":"High-fat diet"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hyperemesis Gravidarum (HG) — severe N/V + dehydration + ketonuria + weight loss > 5%: admit; IV rehydration NSS or LR + dextrose, correct K + Mg; **Thiamine before glucose** (prevent Wernicke); antiemetics — first-line vitamin B6 (pyridoxine) + doxylamine; second-line metoclopramide, promethazine, ondansetron (caution Q-T prolongation + cleft palate risk 1st trimester — recent reassuring data); steroid (methylprednisolone) refractory cases; PPI for reflux; enteral nutrition (NG, J-tube) or TPN if severe + cannot tolerate PO; monitor electrolytes, ketones, weight; psychological support (devastating illness); rule out molar pregnancy (US done), thyroid storm (suppressed TSH due to β-hCG cross-reactivity = transient gestational thyrotoxicosis usually self-limiting); follow-up close

---

Hyperemesis Gravidarum: severe N/V > 5% weight loss + dehydration + electrolyte derangement + ketonuria. Peak 9 wk. Usually resolves by 20 wk. Stepwise treatment: pyridoxine + doxylamine first, then metoclopramide/promethazine, then ondansetron, then steroid. Thiamine before glucose (Wernicke). IV fluid + electrolyte correction. Severe: enteral or TPN. Transient gestational thyrotoxicosis common (β-hCG cross-reacts with TSH receptor) — usually no treatment. Psychological support critical. Rule out hydatidiform mole.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 30 ปี G1P0 GA 8 wk มาด้วยอาการอาเจียนไม่หยุด > 10 ครั้ง/วัน × 1 สัปดาห์ ดื่มน้ำไม่ได้ น้ำหนักลด 3 kg

V/S: BP 96/62, HR 112, RR 18, Temp 36.8°C
Gen: dehydrated, ketones +

Lab: Na 134, K 3.0, Cl 92, HCO3 32, Glucose 78, ketonuria 3+, TSH 0.3 (low), Free T4 1.1 (normal)
US: viable IUP single, no molar pregnancy';

update public.mcq_questions
set choices = '[{"label":"A","text":"No treatment needed"},{"label":"B","text":"Pelvic Inflammatory Disease (PID"},{"label":"C","text":"Acyclovir"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Antifungal only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pelvic Inflammatory Disease (PID — mild-moderate): empirical antibiotic (CDC 2021 + ACOG): outpatient — ceftriaxone 500mg IM single dose + doxycycline 100mg PO BID × 14 days + metronidazole 500mg PO BID × 14 days (anaerobic coverage); inpatient (more severe, pregnant, TOA, severe N/V, failed outpatient, immunocompromised) — IV cefoxitin or cefotetan + doxycycline OR clindamycin + gentamicin; treat sexual partners (within 60 days — also for GC/CT, doxycycline or treat presumptive); test for HIV + syphilis + hepatitis B + C; consent → STI counseling, contraception, safer sex education; follow-up 72h to confirm improvement; complications: tubo-ovarian abscess (TOA — may need drainage if > 4-5cm or not improving), chronic pelvic pain, infertility, ectopic pregnancy; long-term: counseling about reproductive consequences

---

PID: ascending infection of upper genital tract — N. gonorrhoeae, C. trachomatis, anaerobes. Diagnosis CDC: minimum criteria = uterine, adnexal, or CMT tenderness in sexually active woman. Treatment empirical covering GC/CT + anaerobes. Outpatient acceptable for mild-moderate; inpatient for severe, TOA, pregnancy. Partner treatment. STI + HIV + syphilis screening. Complications: TOA, infertility (12% after 1 episode, 50% after 3), chronic pelvic pain, ectopic pregnancy.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 24 ปี มาห้องฉุกเฉินด้วยอาการปวดท้องน้อย + ไข้ + ตกขาวเหลืองมีกลิ่น × 5 วัน + dyspareunia

LMP 1 สัปดาห์ที่แล้ว ปกติ
Sexually active, 2 partners last year, ไม่ใช้ condom

V/S: BP 118/72, HR 102, RR 18, Temp 38.4°C
Abdomen: lower abdominal tenderness bilaterally, no rebound
Pelvic: cervical motion tenderness +, uterine + bilateral adnexal tenderness, mucopurulent endocervical discharge

Lab: WBC 14,500, CRP 88, β-hCG negative, NAAT for GC/CT pending
US: thickened endometrium + small bilateral hydrosalpinx
No tubo-ovarian abscess';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait for vaginal delivery"},{"label":"B","text":"emergent cesarean delivery"},{"label":"C","text":"Increase oxytocin"},{"label":"D","text":"Discharge for outpatient delivery"},{"label":"E","text":"Stop fetal monitoring"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Non-Reassuring Fetal Status (NRFS) / Category III tracing — immediate intervention required: (1) Intrauterine resuscitation: change maternal position (left lateral preferred — relieves IVC + improves placental flow), O2 supplement, stop oxytocin if running, IV fluid bolus, correct hypotension (if epidural-related), tocolytic (terbutaline) if uterine hyperstimulation; (2) Vaginal exam — assess for cord prolapse, advanced labor; (3) Re-evaluate FHR after measures × 5-10 min; (4) If no improvement or worsening → **emergent cesarean delivery** within 30 min (or operative vaginal — vacuum/forceps if fully dilated + low station + experienced operator); (5) Continuous monitoring; (6) Neonatal team for resuscitation; (7) Document carefully — medico-legal; (8) Post-delivery: cord blood gas (acidosis), NICU assessment if needed, family discussion; (9) Categories: I = normal, II = indeterminate (need attention + workup), III = abnormal (recurrent late decel + minimal variability OR sinusoidal OR bradycardia + minimal variability) — high acidemia/CP risk → urgent delivery

---

Fetal heart rate monitoring categories (ACOG/NICHD): I normal (baseline 110-160 + moderate variability + no late/variable decel), II indeterminate (most tracings — variable abnormalities), III abnormal (recurrent late decel + minimal var OR sinusoidal OR bradycardia + minimal var). Category III = urgent intervention or delivery. Intrauterine resuscitation: position, O2, IV fluid, stop oxytocin, treat hyperstim. If no improvement → emergent C-section within 30 min. NICU. Document carefully.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 28 ปี G1P0 GA 39 wk มา L/R for elective induction of labor for postdates

Labor progression: spontaneous labor begins, contractions every 3 min, cervix 6cm dilated, 100% effaced, fetal head -2 station

Fetal heart monitoring: late decelerations occurring with contractions, baseline 140, variability minimal × 30 min

Maternal V/S: stable
Fetal scalp pH: 7.18 (acidotic)

Category III fetal heart rate tracing per ACOG';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge with oral antibiotic"},{"label":"B","text":"Postpartum Endometritis + Wound Infection (post-C-section infection"},{"label":"C","text":"Hysterectomy"},{"label":"D","text":"NSAIDs only"},{"label":"E","text":"No treatment needed"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Postpartum Endometritis + Wound Infection (post-C-section infection — common): admit; IV broad-spectrum antibiotic — clindamycin 900mg q8h + gentamicin 7mg/kg q24h (gold standard combination — Cochrane evidence superior coverage of anaerobes + GBS); add ampicillin or vancomycin if no response 48-72h (for enterococcus); wound — open + drain if abscess, debride + irrigate, allow secondary intention healing or delayed primary closure, daily dressing changes; remove staples/sutures over infected area; antibiotic continue until afebrile 24-48h + clinical improvement; thromboprophylaxis (high VTE risk postpartum); monitor for complications — septic pelvic thrombophlebitis (persistent fever despite antibiotic — anticoagulation indicated), abscess, peritonitis; counsel breastfeeding compatible antibiotics; postpartum depression screening; follow-up wound care + complete resolution

---

Postpartum endometritis 1-3% post-vaginal, 5-15% post-C-section. Polymicrobial (anaerobes, GBS, gram-neg, enterococcus). IV clindamycin + gentamicin gold standard. Add ampicillin if no response (enterococcus). Wound infection: drain + debride + secondary healing. Septic pelvic thrombophlebitis if persistent fever despite antibiotics — anticoagulation. Complications: abscess, peritonitis, sepsis. Postpartum visit, follow-up.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 26 ปี G2P1 ทำ Cesarean delivery 5 วันก่อนเนื่องจาก non-reassuring fetal status มาห้องฉุกเฉินด้วยอาการ ไข้สูง 39.2°C + ปวด wound + ตกขาวเหลืองมีกลิ่น + abdominal tenderness

V/S: BP 102/68, HR 122, RR 22, Temp 39.2°C
Gen: ill
C-section wound: erythematous + warm + discharge purulent at lower edge
Uterus: tender + boggy, foul-smelling lochia
Adnexa: not tender

Lab: WBC 19,500 (left shift), CRP 245, lactate 2.4
Wound + uterine cultures: pending';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue trying naturally"},{"label":"B","text":"Treatment for tubal factor"},{"label":"C","text":"Hysterectomy"},{"label":"D","text":"OCP"},{"label":"E","text":"Stop trying"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Infertility (failure to conceive 12 mo unprotected intercourse) — bilateral tubal disease: (1) Diagnostic workup done — male factor normal (normal SA), female ovulatory (regular cycle + d21 P4 > 3), tubal blockage on HSG; (2) **Treatment for tubal factor**: IVF (in vitro fertilization) is treatment of choice — best success rate; alternative — tubal microsurgical repair (less effective in distal blockage with damaged tubes — increases ectopic risk); (3) IVF process: controlled ovarian hyperstimulation (gonadotropin) + monitoring + egg retrieval + fertilization + embryo transfer + luteal support; (4) Preimplantation genetic testing (PGT) optional for selected; (5) Risks/counseling: multiple gestation (encourage single embryo transfer — eSET), OHSS (ovarian hyperstimulation syndrome — severe potential), procedural risks, financial cost, emotional burden; (6) Success rates per age: < 35 yo ~ 40% live birth per cycle; (7) Lifestyle: weight, smoking cessation, alcohol moderation, folate; (8) Psychological support; (9) Alternative: adoption, donor gametes, surrogacy depending on situation; (10) Tubal disease etiology: prior PID, endometriosis, prior tubal surgery, congenital — counseling + STI prevention

---

Infertility = failure to conceive 12 mo (6 mo if > 35 yo) of unprotected intercourse. Female factor 40%, male factor 30-40%, both/unexplained 20-30%. Female: ovulatory (cycle, d21 P4), tubal (HSG), structural (US, sono-HSG). Male: SA. Tubal disease → IVF first-line. Counseling psychological + financial. Lifestyle. eSET to reduce multiple gestation. Modern IVF success: 40% < 35 yo per cycle.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 32 ปี G0P0 trying to conceive × 18 เดือน no success มา OPD

Menstrual: regular cycle 28 days, normal flow, mild dysmenorrhea
History: no PID, no STIs, BMI 23
Husband: 35 yo, healthy, normal semen analysis (concentration 80M, motility 60%, normal morphology 8%)

Exam: normal pelvic, no masses

Lab: TSH 2.4, Prolactin normal, day 3 FSH 6.8, AMH 3.2 (normal), day 21 progesterone 12.8 (suggests ovulation)
HSG (hysterosalpingography): bilateral tubal obstruction at distal ends';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge — normal variation"},{"label":"B","text":"Polycystic Ovary Syndrome (PCOS) — Rotterdam criteria (2/3): oligo/anovulation + clinical or biochem hyperandrogenism + polycystic ovaries; this patient meets all 3"},{"label":"C","text":"Hysterectomy"},{"label":"D","text":"Antidepressant only"},{"label":"E","text":"Ignore"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Polycystic Ovary Syndrome (PCOS) — Rotterdam criteria (2/3): oligo/anovulation + clinical or biochem hyperandrogenism + polycystic ovaries; this patient meets all 3: (1) **Lifestyle modification** (foundation) — weight loss 5-10% improves cycles, fertility, metabolic — diet (Mediterranean) + exercise 150 min/wk; (2) **Menstrual regulation**: combined OCP (low-dose, antiandrogenic progestin — drospirenone/cyproterone preferred) — first-line for non-fertility seeking; cyclic progestin alternative; (3) **Hyperandrogenism**: OCP for hirsutism + acne (slow effect 3-6 mo); spironolactone + OCP (antiandrogen); mechanical hair removal (laser, electrolysis); topical eflornithine; (4) **Metabolic**: metformin for insulin resistance (improves metabolic + may improve ovulation/cycle); statin if dyslipidemia; (5) **Fertility (when desired)**: weight loss first, letrozole first-line (PPCOS-II trial superior to clomiphene), clomiphene, metformin adjunct, gonadotropin if resistant, ovarian drilling, IVF; (6) **Endometrial protection**: chronic anovulation → endometrial hyperplasia/cancer risk — progestin (cyclic or LNG-IUD), OCP, induce withdrawal bleeding regularly; (7) **Screen for**: T2DM (OGTT annually), HT, dyslipidemia, OSA, depression, eating disorder, NAFLD; (8) **Long-term**: increased CV, T2DM, endometrial cancer risk — annual screening + risk modification; (9) Multidisciplinary: GYN, endocrine, dietitian, dermatology, mental health

---

PCOS: Rotterdam criteria (2/3 — oligo/anovulation, hyperandrogenism, polycystic ovaries). Common (10% reproductive age). Metabolic syndrome features (obesity, insulin resistance, dyslipidemia, T2DM, CV risk). Endometrial cancer risk (chronic anovulation → unopposed estrogen). Management: lifestyle first + symptom-based + metabolic risk modification + endometrial protection. Fertility: letrozole first-line per PPCOS-II. Multidisciplinary care.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 26 ปี ไม่มีโรคประจำตัว มา OPD ด้วยอาการประจำเดือนผิดปกติ (5-6 รอบ/ปี), น้ำหนักเพิ่ม 8 kg ใน 1 ปี, สิวที่หน้า + ผมหลังคอ + acanthosis nigricans, ขนหนาบริเวณคาง + แขน

BMI 32 (obese), BP 132/85
Pelvic: ปกติ
Hair growth Ferriman-Gallwey score 12 (hirsutism)

Lab: TSH normal, Prolactin normal, 17-OHP normal, DHEAS slightly high, Testosterone 70 ng/dL (slightly high), Insulin fasting 22 (elevated), HbA1c 5.9% (prediabetes), Lipid: TG 220, HDL 35
US: bilateral polycystic ovaries + 12+ small follicles each + increased ovarian volume';

update public.mcq_questions
set choices = '[{"label":"A","text":"Observation"},{"label":"B","text":"Treatment options based on resectability"},{"label":"C","text":"Hysterectomy alone"},{"label":"D","text":"Hormone replacement therapy"},{"label":"E","text":"Conservative"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Advanced Ovarian Cancer (Stage III likely) + BRCA1 positive — multidisciplinary GYN-oncology management: (1) Confirm tissue diagnosis — paracentesis cytology, image-guided biopsy of omental disease, or laparoscopy; (2) **Treatment options based on resectability**: - **Primary debulking surgery (PDS)** + adjuvant chemo if optimal cytoreduction (R0/R1, no residual > 1cm) achievable AND fit patient (NCCN preferred); - **Neoadjuvant chemo (NACT) + interval debulking surgery + completion chemo** for not initially resectable, poor performance status, very advanced disease (EORTC + CHORUS trials — non-inferior + less morbidity); (3) **Chemotherapy regimen**: carboplatin + paclitaxel × 6 cycles; consider bevacizumab maintenance; **PARP inhibitor maintenance (olaparib, niraparib, rucaparib)** — major benefit in BRCA1/2 mutated (PFS improvement substantial — SOLO-1, PRIMA trials); (4) **Genetic testing already done** — BRCA1 → counseling for breast cancer surveillance, risk-reducing mastectomy considerations (already have ovarian Ca); family genetic counseling; (5) Surveillance: clinical + CA-125 + imaging q3-6 mo × 2 yr, q6-12 mo × 3 yr; (6) Palliative care concurrent; (7) Outcomes: stage III 5-year survival 30-40%, improved with PARP inhibitor era; (8) Recurrent disease: platinum-sensitive → re-challenge; platinum-resistant → other agents (bevacizumab, doxorubicin liposomal, gemcitabine, topotecan); (9) Lifelong follow-up + survivorship; (10) Multidisciplinary: GYN-oncology, medical oncology, palliative, genetics, social work, nutrition

---

Ovarian cancer: vague symptoms (bloating, early satiety, pelvic pain, urinary) — "silent" but actually symptomatic. Often advanced at presentation. CA-125 + HE4 + ROMA. Imaging + tissue diagnosis. Multidisciplinary GYN-onc management. PDS vs NACT decision. Adjuvant chemo carboplatin + paclitaxel. PARP inhibitor maintenance major advance for BRCA mutation. Genetic testing standard for all ovarian Ca (10-15% BRCA, Lynch). Family screening. Survival improving with modern Rx.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 65 ปี postmenopausal × 12 ปี มา OPD ด้วยอาการ chronic abdominal bloating + early satiety + ปวดท้องน้อยเล็กน้อย × 3 เดือน + น้ำหนักลด 4 kg + ปัสสาวะบ่อย

Family: น้องสาวเป็น breast cancer อายุ 48
Genetic: BRCA1 testing positive (familial)

V/S: BP 132/82, BMI 24
Abdomen: distended + ascites (shifting dullness +)
Pelvic: bilateral adnexal mass palpable

Lab: CA-125 685 (very high), CEA normal, HE4 elevated
ROMA index high
US pelvis: bilateral complex ovarian masses + ascites
CT abdomen/pelvis: bilateral ovarian masses (8 + 10 cm) + peritoneal carcinomatosis + omental caking + ascites
No distant metastases on imaging';

update public.mcq_questions
set choices = '[{"label":"A","text":"No treatment — symptoms self-limited"},{"label":"B","text":"Menopausal Symptoms — comprehensive management"},{"label":"C","text":"Total hysterectomy"},{"label":"D","text":"Antidepressants only without other therapy"},{"label":"E","text":"Ignore symptoms"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Menopausal Symptoms — comprehensive management: (1) **Lifestyle**: cool environment, layered clothing, avoid triggers (alcohol, spicy), exercise, weight management, stress reduction, smoking cessation; (2) **MHT (Menopausal Hormone Therapy)** decision — risk-benefit individualized: indication = significant vasomotor symptoms (mod-severe), GSM, early menopause; - Estrogen + progestogen (if intact uterus) — combined; estrogen alone if hysterectomy; - Routes: oral (more VTE risk), transdermal (preferred — less VTE risk per most data), vaginal (for GSM only); - Dose: lowest effective for shortest duration but no arbitrary stop; - Contraindications: estrogen-receptor cancer, active VTE/stroke/CV disease, undiagnosed bleeding; relative — migraine with aura, high VTE risk, gallbladder disease; - Risks: breast Ca (long-term combined modestly increased), VTE (oral more), CV (early menopause may benefit), endometrial Ca (if unopposed estrogen with uterus); - Benefits: symptoms, bone, GSM, possible CV in early menopause; (3) **GSM-specific**: vaginal estrogen (very low systemic absorption), moisturizers, lubricants, ospemifene, prasterone; (4) **Non-hormonal alternatives**: SSRIs/SNRIs (paroxetine, venlafaxine), gabapentin, oxybutynin, cognitive-behavioral therapy, clonidine; (5) **Bone health**: calcium + vitamin D, weight-bearing exercise, bisphosphonate if T-score -2.5 or fragility fracture (DEXA already shows osteopenia, FRAX assessment); (6) **CV risk**: lifestyle, statin per LDL; (7) **Cancer screening**: continued mammogram, Pap, colonoscopy per guidelines; (8) **Shared decision-making + reassessment annually**; (9) Genitourinary syndrome of menopause (GSM) — chronic — local estrogen safe long-term; (10) Mental health support if depression/anxiety

---

Menopause: cessation of menses > 12 mo (avg 51 yo). Vasomotor, GSM, mood, sleep, bone, CV changes. MHT for moderate-severe symptoms — risk-benefit individualized. Transdermal preferred (less VTE). GSM treated with vaginal estrogen (safe). Non-hormonal: SSRI/SNRI, gabapentin, CBT. Bone health: Ca/vit D + DEXA + bisphosphonate threshold. CV risk modification. Cancer screening continues. Shared decision-making + reassessment annually.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 52 ปี perimenopausal × 1 ปี มาด้วยอาการ vasomotor (hot flashes, night sweats) ทำให้นอนไม่หลับ + mood disturbance + vaginal dryness + dyspareunia

LMP 4 เดือนที่แล้ว
BMI 26, BP 132/82
Family: mother breast cancer at 65, father MI at 70

Lab: FSH 65 (high — menopausal), Estradiol 8 (low)
Mammogram: normal, Pap normal
Bone DEXA: T-score -1.8 (osteopenia)
Lipid: TC 245, LDL 158
No personal history breast or VTE or stroke';

update public.mcq_questions
set choices = '[{"label":"A","text":"Reassure as anxiety attack"},{"label":"B","text":"PE in pregnancy — pregnancy = hypercoagulable state (4-5× VTE risk)"},{"label":"C","text":"Anxiety treatment with benzodiazepine"},{"label":"D","text":"Beta-blocker only"},{"label":"E","text":"Discharge home"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** PE in pregnancy — pregnancy = hypercoagulable state (4-5× VTE risk): (1) **Anticoagulation immediately** — LMWH (enoxaparin) IV/SC weight-based or therapeutic UFH bolus → infusion; LMWH preferred — does not cross placenta, safer, easier dosing; (2) **Pregnancy-specific considerations**: avoid warfarin (teratogenic 6-12 wk, fetal bleeding); avoid DOACs (cross placenta — insufficient safety data); LMWH continued through pregnancy + 6 weeks postpartum (6 mo total); (3) **Around delivery**: switch to IV heparin 24-36h before planned induction/C-section (shorter half-life, reversible); discontinue heparin 4-6h before neuraxial anesthesia; restart after delivery if hemostasis adequate; (4) **Severity stratification**: hemodynamically stable here — anticoagulation alone; if massive (hemodynamic instability) — consider thrombolysis (life-saving for mother), surgical/catheter embolectomy, ECMO; (5) Continuous monitoring fetal + maternal; (6) **Identify cause**: pregnancy + immobilization + obesity + thrombophilia — screen prior episodes, family history; (7) Counsel: VTE risk in subsequent pregnancies (prophylaxis next pregnancy); avoid OCP; long-term anticoagulation only if unprovoked or persistent risk; (8) Multidisciplinary: MFM, hematology, anesthesia, OB, internal medicine; (9) Postpartum follow-up + reassessment; (10) Anti-Xa monitoring for therapeutic LMWH in selected

---

Pregnancy = 4-5× VTE risk (hypercoagulable, venous stasis, vascular injury). PE leading cause of maternal mortality. Diagnosis: clinical + imaging (V/Q scan or CTPA — both acceptable, CTPA growing standard, lower fetal radiation than thought, breast shielding for mother). Treatment: LMWH first-line (does not cross placenta). Warfarin teratogenic + fetal bleeding. DOACs cross placenta — avoid. Switch to IV heparin around delivery. Multidisciplinary care. Subsequent pregnancy prophylaxis. Counseling.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 28 ปี G2P1 ตั้งครรภ์ GA 38 wk มาห้องฉุกเฉินด้วยอาการ acute onset chest pain + ตื่นกลัว + เหงื่อแตก + แน่นหน้าอก + รู้สึกหวาดกลัวจะตาย × 6 ชม

Family history: no cardiac history

V/S: BP 154/96, HR 132, RR 28, SpO2 96%, Temp 36.8°C
Gen: anxious, restless, diaphoretic, alert
Lungs: clear, no crackles
Cardiac: tachycardia, no murmurs

EKG: sinus tachycardia 132, no ST changes
Lab: Troponin slightly elevated 0.06, BNP 280, D-dimer high (pregnancy alters), TSH normal
US Fetal: alive, normal growth, no abruption
Obstetric exam: not in labor

CT pulmonary angiogram: positive for pulmonary embolism in segmental branch';

update public.mcq_questions
set choices = '[{"label":"A","text":"No significant changes"},{"label":"B","text":"Pregnancy Physiologic Adaptations"},{"label":"C","text":"BP increases"},{"label":"D","text":"GFR decreases"},{"label":"E","text":"Hypercoagulable state unchanged"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pregnancy Physiologic Adaptations: Cardiovascular — plasma volume ↑ 40-50%, RBC mass ↑ 20-30% (physiologic anemia from dilution), CO ↑ 30-50% (HR + SV both), SVR ↓ → BP nadir mid-pregnancy then rise; Respiratory — minute ventilation ↑ 40% (TV not RR), respiratory alkalosis compensated by renal HCO3 excretion, functional residual capacity ↓; Renal — GFR ↑ 50%, Cr decreases (normal pregnancy < 0.8), glycosuria more common; Hematologic — hypercoagulable (↑ factors I, VII, VIII, IX, X, plasminogen, ↓ protein S), VTE risk; Endocrine — progesterone (smooth muscle relaxation), estrogen, hCG (early luteal support), prolactin (lactation), HPL (insulin antagonism — GDM risk), thyroid (TBG ↑ binding, total T4 ↑ but free T4 normal), cortisol ↑; GI — gastric motility ↓ (reflux), constipation; Musculoskeletal — relaxin (joint laxity, lordosis); Immune — Th2 shift (autoimmune disease may improve)

---

Pregnancy adaptations affect every organ. Key: ↑ plasma volume + CO, ↓ SVR + BP nadir mid-trimester, ↑ GFR, hypercoagulable, respiratory alkalosis, insulin resistance (GDM). Understanding essential for: interpreting normal labs, managing pre-existing conditions in pregnancy, recognizing pathology. Modern obstetric care builds on physiology.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'อาจารย์อธิบาย physiology — pregnancy adaptations + key hemodynamic + endocrine changes';

update public.mcq_questions
set choices = '[{"label":"A","text":"All drugs safe in pregnancy"},{"label":"B","text":"Teratogenic Medications + Pregnancy Considerations"},{"label":"C","text":"No need for caution"},{"label":"D","text":"All antibiotics safe"},{"label":"E","text":"Stop all medications"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Teratogenic Medications + Pregnancy Considerations: (1) FDA categories replaced by PLLR (Pregnancy and Lactation Labeling Rule) — narrative risk; (2) Known teratogens to avoid: ACEi/ARB (renal dysgenesis, oligohydramnios 2nd-3rd trimester), warfarin (6-12 wk window — chondrodysplasia, microcephaly, fetal bleeding throughout), isotretinoin (multiple), valproic acid (NTD, autism, low IQ), phenytoin (fetal hydantoin syndrome), carbamazepine (NTD), lithium (Ebstein anomaly — relative risk), methotrexate (multiple), thalidomide (limb), DES (clear cell adenocarcinoma in offspring), tetracycline (tooth, bone), aminoglycosides (ototoxicity), fluconazole (multiple), live vaccines (theoretical, avoid), androgens, NSAIDs (avoid 3rd trimester — ductus arteriosus closure, oligohydramnios); (3) Generally safer alternatives: penicillins, cephalosporins (most), acetaminophen, methyldopa (HT), labetalol (HT), nifedipine (HT, tocolysis), insulin (DM), heparin/LMWH (anticoagulation), levothyroxine (hypothyroid); (4) Timing matters — organogenesis 3-8 weeks most vulnerable; (5) Risk-benefit individualized — uncontrolled disease may harm more than medication; (6) Resources: REPROTOX, TERIS, OTIS/MotherToBaby; (7) Folate before + during pregnancy (NTD prevention); (8) Pre-conception counseling for chronic conditions

---

Teratogen awareness critical. Major: ACEi/ARB, warfarin, isotretinoin, valproate, thalidomide, methotrexate. Generally safer: penicillins, acetaminophen, methyldopa, labetalol, insulin, heparin, levothyroxine. Timing of exposure matters. Risk-benefit individualized. Resources: REPROTOX, TERIS, OTIS. Pre-conception counseling + medication review. Folate pre-conception NTD prevention.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Resident ถามอาจารย์เรื่อง pharmacology — teratogenic medications + FDA pregnancy category';

update public.mcq_questions
set choices = '[{"label":"A","text":"No physiological coordination"},{"label":"B","text":"Labor Physiology"},{"label":"C","text":"Random uterine activity"},{"label":"D","text":"No hormonal control"},{"label":"E","text":"Same throughout pregnancy"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Labor Physiology — coordinated uterine activity: (1) Hormonal: ↑ estrogen + ↓ progesterone (functional withdrawal) → increased gap junction (connexin-43) → coordinated contractions; PGE2/F2α uterotonic + cervical ripening; oxytocin from posterior pituitary + receptors upregulated in myometrium late pregnancy; (2) Three phases of cervical change: cervical ripening (softening, late pregnancy), effacement, dilation; (3) Three phases of labor: latent (slow dilation, 0-6 cm), active (6-10 cm, ~1 cm/hr nulli, 1.5 cm/hr multi), 2nd stage (full dilation to delivery — pushing), 3rd stage (delivery of placenta); modern: latent up to 6 cm (vs old 4 cm — Friedman curve revised, Zhang); (4) Cardinal movements of labor (head): engagement → descent → flexion → internal rotation → extension → external rotation → expulsion; (5) Power, passenger, passage (Three P''s) determine progress; abnormal labor: protraction, arrest of dilation/descent; (6) Pain control: epidural (lumbar L3-4, blocks T10-L1 + S2-4 — ESM block), spinal, combined, opioids, nitrous oxide, non-pharmacologic; (7) Monitoring: intermittent vs continuous FHR (NICE — intermittent for low-risk; continuous if risk factors); (8) Augmentation: amniotomy, oxytocin titration; (9) Cesarean indications: NRFS, labor dystocia, abnormal presentation, placenta previa, etc.

---

Labor = coordinated uterine activity through hormonal + neurogenic + mechanical factors. Modern understanding (Zhang vs Friedman) — latent labor longer than thought, active phase begins ~ 6 cm. Cardinal movements describe fetal navigation through pelvis. Power/passenger/passage analysis identifies dystocia. Pain management options + risks. Continuous vs intermittent monitoring based on risk. Modern labor management = patient-centered + evidence-based.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'อาจารย์อธิบาย physiology — labor + delivery + uterine contraction';

update public.mcq_questions
set choices = '[{"label":"A","text":"Only OCP available"},{"label":"B","text":"Contraception — tiered approach by effectiveness (CDC + WHO MEC — Medical Eligibility Criteria)"},{"label":"C","text":"All same effectiveness"},{"label":"D","text":"No medical conditions matter"},{"label":"E","text":"Hormones only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Contraception — tiered approach by effectiveness (CDC + WHO MEC — Medical Eligibility Criteria): (1) **Most effective (< 1% failure)**: LARCs (Long-Acting Reversible Contraception) — implant (etonogestrel — Nexplanon, 3 yr, < 0.1% failure), IUDs (LNG-IUD — Mirena/Liletta/Skyla/Kyleena, 3-8 yr, also treats heavy bleeding; copper IUD — ParaGard, 10 yr, no hormones — useful for emergency contraception); sterilization (vasectomy, tubal ligation/Essure withdrawn); (2) **Very effective (6-9%)**: depot medroxyprogesterone (Depo-Provera 3 mo IM); OCPs (combined estrogen + progestin — many options, also non-contraceptive benefits — cycle regulation, menorrhagia, acne, ovarian/endometrial cancer risk reduction); progestin-only pill (POP — Norethindrone, also breastfeeding); patch (combined); ring (combined NuvaRing/Annovera); (3) **Moderately effective (18%)**: male condom (also STI protection), diaphragm + spermicide; (4) **Less effective (24-28%)**: spermicide, sponge, withdrawal, fertility awareness; (5) **Emergency contraception**: copper IUD (most effective, up to 5 days), ulipristal acetate (5 days), levonorgestrel (3-5 days, less effective); (6) **Mechanisms**: hormonal — suppress LH/FSH (no ovulation), thicken cervical mucus, change endometrium; copper IUD — spermicidal + inflammatory; barrier — physical block; (7) **Choice based on**: patient values, medical history (WHO MEC categories 1-4), STI risk, fertility plans, side effect tolerance

---

Contraception counseling = patient-centered + evidence-based. Tier 1 = LARC (most effective, increasingly first-line). WHO MEC categorizes eligibility per medical conditions. Estrogen contraindications: VTE history, migraine with aura, stroke, MI, BC < 5 yr, advanced liver, smoking > 35 yo. POP/LARC alternatives. Emergency contraception (copper IUD most effective, ulipristal, LNG). Modern approach: LARC first; respect patient preferences.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'อาจารย์อธิบาย contraception methods + mechanisms';

update public.mcq_questions
set choices = '[{"label":"A","text":"Single intervention"},{"label":"B","text":"Maternal Quality Improvement Program"},{"label":"C","text":"Single specialty manages"},{"label":"D","text":"No data collection"},{"label":"E","text":"Avoid drills"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Maternal Quality Improvement Program: (1) Maternal Early Warning Systems (MEWS) — track vital signs trigger response (BP > 160/110, RR > 30, HR > 130, SpO2 < 95%, oliguria, AMS) → rapid response team activation; (2) Standardized bundles (AIM — Alliance for Innovation on Maternal Health): hypertension bundle, hemorrhage bundle, VTE bundle, sepsis bundle, maternal mental health, peripartum racial/ethnic disparities, severe maternal morbidity review; (3) Hemorrhage bundle: risk assessment, recognition + response, hemorrhage cart, MTP, drills; (4) Hypertensive bundle: severe range BP management protocols, MgSO4 use, transfer criteria; (5) Multidisciplinary simulations + drills (shoulder dystocia, hemorrhage, eclampsia, cardiac arrest); (6) Severe maternal morbidity (SMM) review committees + root cause analysis; (7) Levels of maternal care designation (similar to trauma — Level I-IV); (8) Continuous improvement + audit; (9) Address social determinants + disparities (Black women 3-4× maternal mortality in US); (10) Family/support involvement; (11) Mental health screening + treatment; (12) Quality metrics: maternal mortality ratio, SMM rate, blood transfusion rate, NICU admission, c-section rate, breastfeeding initiation, postpartum visit attendance

---

Maternal mortality reduction = system-level multidisciplinary effort. MEWS for early recognition. Bundles standardize evidence-based care. Drills + simulations improve readiness. SMM review identifies improvement opportunities. Levels of maternal care match risk to capability. AIM + ACOG + national initiatives. Address disparities. Maternal mortality preventable in majority of cases — system improvement saves lives.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Hospital wants to reduce maternal mortality + improve obstetric outcomes — implement Maternal Early Warning Systems';

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

update public.mcq_questions
set choices = '[{"label":"A","text":"Cardiac output ลดลง 30% ตลอดการตั้งครรภ์"},{"label":"B","text":"Maternal hemodynamic changes in pregnancy"},{"label":"C","text":"BP rises throughout pregnancy"},{"label":"D","text":"Plasma volume decreases 20%"},{"label":"E","text":"Cardiac output unchanged"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Maternal hemodynamic changes in pregnancy: (1) **plasma volume** ↑ 40-50% (peak 32-34 wk); (2) **RBC mass** ↑ 20-30% — net = physiologic anemia of pregnancy (dilutional, Hb nadir 28-32 wk ~ 10.5-11 g/dL); (3) **cardiac output** ↑ 30-50% (↑ HR 10-20 bpm + ↑ stroke volume), peaks ~ 32 wk, sustained through delivery; CO ↑ acutely 60-80% in labor + immediate postpartum (autotransfusion); (4) **systemic vascular resistance** ↓ 30-40% (progesterone, NO, prostacyclin) → BP nadir 24-28 wk, returns to baseline by term; (5) supine hypotension after 20 wk — aortocaval compression by gravid uterus → left lateral tilt 15-30° during procedures, CPR (LUD); (6) **GFR** ↑ 50% (Cr falls to ~ 0.5, BUN falls); (7) **respiratory** — tidal volume ↑ 30-40% (progesterone-driven), MV ↑, respiratory alkalosis (PaCO2 28-32), compensated metabolic; (8) **hypercoagulable** — ↑ factors I, VII, VIII, IX, X, fibrinogen; ↓ protein S, antithrombin; ↑ PAI-1 — VTE risk 4-5× elevated; (9) **GI** — delayed gastric emptying, ↓ LES tone (reflux); (10) endocrine: hCG, hPL, progesterone, estrogen, prolactin, cortisol all ↑

---

Pregnancy hemodynamic adaptations — critical for understanding pathology. Plasma > RBC = dilutional anemia. CO up = ↑ HR + SV. SVR down = BP drop trimester 2 then recover. GFR up = lower Cr. Hypercoagulable = VTE risk. Aortocaval compression = LUD after 20 wk.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Resident ถามอาจารย์เรื่อง physiology — maternal cardiovascular adaptations in pregnancy';

update public.mcq_questions
set choices = '[{"label":"A","text":"Implantation เกิดที่ fallopian tube หลัง fertilization 7 วัน"},{"label":"B","text":"Reproductive embryology key points"},{"label":"C","text":"Cleavage starts after implantation"},{"label":"D","text":"Sperm capacitation in epididymis only"},{"label":"E","text":"Placenta forms after 20 weeks"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Reproductive embryology key points: (1) **oogenesis** — primary oocytes arrested in meiosis I prophase before birth (~ 1-2 million at birth, ~ 400 ovulated lifetime); meiosis I completes at ovulation (LH surge), meiosis II arrests at metaphase II until fertilization; (2) **spermatogenesis** — continuous from puberty, ~ 64 d cycle, ~ 100 million/d; capacitation in female tract enables fertilization; (3) **fertilization** — ampulla of fallopian tube within 12-24 hr of ovulation; sperm penetrates zona pellucida (acrosome reaction), cortical reaction prevents polyspermy; (4) **zygote** → cleavage → morula (~ d 3-4) → blastocyst (~ d 5) with inner cell mass + trophectoderm; (5) **implantation** — d 6-10 in uterine endometrium (decidualized) — apposition, adhesion, invasion; (6) **trophoblast** differentiates into cytotrophoblast (inner) + syncytiotrophoblast (outer, invasive, hCG-producing); (7) **placenta** — chorionic villi form by week 3; uteroplacental circulation established by week 12 (spiral artery remodeling — failure = preeclampsia/FGR); (8) **organogenesis** — week 3-8 (most teratogen-vulnerable); (9) **fetal period** — week 9 onward (growth + maturation); (10) viability ~ 22-24 wk (lung surfactant)

---

Reproductive biology basics. Meiotic arrest oocyte = clinically relevant (advanced maternal age aneuploidy). Implantation d 6-10 post-fert. Trophoblast invasion + spiral artery remodeling failure = preeclampsia. Organogenesis week 3-8 = teratogen window.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Resident ถามอาจารย์เรื่อง embryology — gametogenesis + fertilization + early implantation';

update public.mcq_questions
set choices = '[{"label":"A","text":"Oxytocin ทำหน้าที่ relax uterus"},{"label":"B","text":"Uterotonics + tocolytics: Uterotonics —"},{"label":"C","text":"Magnesium causes uterine contraction"},{"label":"D","text":"Nifedipine is a uterotonic"},{"label":"E","text":"Indomethacin is safe at term"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Uterotonics + tocolytics: **Uterotonics** — (1) **oxytocin** — binds GPCR → ↑ IP3/DAG → ↑ Ca²⁺ → smooth muscle contraction; first-line PPH prophylaxis + treatment; side effect: water intoxication (ADH-like), hypotension if rapid bolus; (2) **methylergonovine** (ergot) — α-adrenergic + 5-HT receptor agonist, sustained tetanic contraction; CI in HT, preeclampsia, CAD (vasospasm); (3) **carboprost (15-methyl PGF2α)** — prostaglandin receptor agonist, smooth muscle contraction; CI in asthma (bronchospasm), use cautious in HT; (4) **misoprostol (PGE1)** — PR/SL/PO/PV; cervical ripening + uterotonic + abortifacient + ulcer prevention; **Tocolytics** — (1) **nifedipine** (CCB) — blocks L-type Ca²⁺ channel → ↓ Ca²⁺ → smooth muscle relaxation; first-line PTL; SE hypotension, headache; (2) **atosiban** (oxytocin antagonist) — receptor competitive; expensive, few side effects; (3) **magnesium sulfate** — Ca²⁺ antagonist + neuroprotection; SE flushing, respiratory depression, antidote Ca gluconate; (4) **indomethacin** (NSAID) — COX inhibitor ↓ PG; < 32 wk only (ductus arteriosus closure, oligohydramnios); (5) **β-agonists** (terbutaline) — β2 → cAMP → relaxation; SE tachycardia, hyperglycemia, pulmonary edema (limited use)

---

Uterotonic + tocolytic pharm — critical board content. Know mechanism, indication, contraindication, side effect for each drug.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Resident ถามอาจารย์เรื่อง pharmacology — uterotonics + tocolytics mechanisms';

update public.mcq_questions
set choices = '[{"label":"A","text":"LH surge หลัง progesterone peak"},{"label":"B","text":"Follicular phase (d 1-14)"},{"label":"C","text":"Estrogen falls during follicular phase"},{"label":"D","text":"Corpus luteum produces FSH"},{"label":"E","text":"Progesterone causes proliferative endometrium"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Menstrual cycle (28 d typical): **Follicular phase (d 1-14)** — (1) GnRH pulsatile from hypothalamus → ant pituitary FSH/LH; (2) FSH → recruits cohort of antral follicles → granulosa cells produce estradiol (aromatase converts androstenedione/testosterone from theca cells under LH); (3) dominant follicle selection by d 7-8 (high estradiol + ↑ FSH receptors); (4) estradiol → endometrial proliferation (proliferative phase); (5) estradiol > 200 pg/mL × 48 hr → **positive feedback** on hypothalamus/pituitary → **LH surge** (d 13-14) → **ovulation** within 36 hr; (6) basal body temp ↑ 0.5°C post-ovulation (progesterone-mediated); **Luteal phase (d 14-28)** — (1) ruptured follicle becomes corpus luteum → produces progesterone (+ estradiol); (2) progesterone → secretory endometrium (glycogen, glandular); (3) progesterone negative feedback on GnRH/LH/FSH → no further ovulation; (4) ถ้า fertilization → hCG from trophoblast rescues corpus luteum → maintains progesterone until placenta takes over ~ 8-10 wk; (5) no fertilization → corpus luteum regresses (~ d 26) → progesterone + estradiol fall → endometrial shedding (menstruation, d 28 = d 1 next cycle); LH/FSH rise restarts cycle

---

HPO axis + menstrual cycle = foundation for AUB, contraception, infertility. Know follicular + ovulatory + luteal phase events. LH surge = estrogen positive feedback. Progesterone = secretory endometrium + temp rise. hCG = corpus luteum rescue.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Resident ถามอาจารย์เรื่อง physiology — menstrual cycle + HPO axis';

update public.mcq_questions
set choices = '[{"label":"A","text":"Foramen ovale ปิดในครรภ์"},{"label":"B","text":"placenta = gas exchange"},{"label":"C","text":"Lungs are primary gas exchange in utero"},{"label":"D","text":"Umbilical arteries carry oxygenated blood"},{"label":"E","text":"Ductus arteriosus closes during fetal life"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Fetal circulation: (1) **placenta = gas exchange** organ (lungs collapsed, not used); (2) oxygenated blood from placenta via **umbilical vein** (PaO2 ~ 30-35 mmHg — highest in fetal circulation); (3) ~ 50% bypasses liver via **ductus venosus** → IVC; (4) blood enters right atrium → preferential streaming through **foramen ovale** (right-to-left atrial shunt) → left atrium → LV → ascending aorta → coronaries + brain (highest O2); (5) deoxygenated SVC blood → RA → RV → pulmonary artery → mostly bypasses lungs via **ductus arteriosus** (PGE2-maintained patency) → descending aorta → lower body + **umbilical arteries** (2) → placenta; (6) high pulmonary vascular resistance (collapsed alveoli) drives right-to-left shunting; **At birth** — (1) clamp cord → loss of low-resistance placental circuit → ↑ SVR; (2) first breath → ↓ pulmonary vascular resistance → ↑ pulmonary blood flow → ↑ left atrial pressure → **functional closure of foramen ovale** (anatomical months later); (3) ↑ PaO2 + ↓ PGE2 → **ductus arteriosus closes** functionally 10-15 hr, anatomically 2-3 wk → ligamentum arteriosum; (4) ductus venosus closes → ligamentum venosum; (5) umbilical arteries → medial umbilical ligaments; umbilical vein → ligamentum teres; (6) persistent fetal circulation = PPHN (meconium, sepsis, asphyxia)

---

Fetal circulation: 3 shunts (ductus venosus, foramen ovale, ductus arteriosus). Placenta = gas exchange. Highest O2 in umbilical vein → brain/heart preferential. PGE2 keeps DA open. Transition at birth: ↑ SVR, ↓ PVR, shunt closure. PDA reopened with PGE1 in cyanotic CHD; closed with indomethacin/ibuprofen.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Resident ถามอาจารย์เรื่อง physiology — fetal circulation + transition at birth';

update public.mcq_questions
set choices = '[{"label":"A","text":"Just hire more doctors"},{"label":"B","text":"Maternal mortality reduction bundle approach (AIM/ACOG safety bundles)"},{"label":"C","text":"Reduce nurse staffing"},{"label":"D","text":"Eliminate fetal monitoring"},{"label":"E","text":"Wait for symptoms before intervention"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Maternal mortality reduction bundle approach (AIM/ACOG safety bundles): (1) **Obstetric Hemorrhage Bundle** — readiness (hemorrhage cart, MTP protocol, blood bank, response team), recognition + prevention (risk assessment every patient — low/medium/high; active management 3rd stage; quantitative blood loss QBL not visual estimation), response (stage-based protocol — stage 0-3 algorithm; uterotonics; balloon; surgical), reporting + systems learning (debriefs, M&M, simulation drills); (2) **Severe HTN/Preeclampsia Bundle** — antihypertensive within 60 min for severe-range BP, MgSO4 for severe features, debrief, patient/family education postpartum; (3) **Sepsis Bundle** — early recognition (MEWS), Hour-1 bundle (cultures, broad-spectrum abx, lactate, fluid, source control); (4) **Maternal Early Warning System (MEWS)** — vital sign-based escalation; (5) **simulation training** — high-fidelity drills (shoulder dystocia, eclampsia, hemorrhage, cord prolapse, OB code); (6) **multidisciplinary rounds + huddles** (OB, anesthesia, nursing, NICU); (7) **levels of maternal care** (per ACOG/SMFM — basic, specialty, subspecialty, regional); (8) **review every severe morbidity/mortality** (M&M conference, root cause analysis); (9) culture of safety — psychological safety + speak-up; (10) patient-centered + equity — address racial/SES disparities

---

AIM (Alliance for Innovation on Maternal Health) safety bundles — evidence-based standardized response. Hemorrhage, HTN, sepsis, VTE, opioid use, postpartum care. Stage-based hemorrhage protocol. MEWS. Simulation. Levels of maternal care. Equity focus. ACOG/SMFM partnership.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Hospital obstetric unit wants to reduce maternal mortality from hemorrhage + sepsis + HTN crisis';

update public.mcq_questions
set choices = '[{"label":"A","text":"Communication is unnecessary"},{"label":"B","text":"TeamSTEPPS"},{"label":"C","text":"Hierarchy prevents speak-up"},{"label":"D","text":"SBAR only for nurses"},{"label":"E","text":"Eliminate handoffs"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** TeamSTEPPS + SBAR implementation: **TeamSTEPPS** (AHRQ) — evidence-based teamwork system: (1) Team Structure (defined roles); (2) Leadership (briefs, huddles, debriefs); (3) Situation Monitoring (cross-monitoring, STEP — Status of patient, Team members, Environment, Progress toward goals); (4) Mutual Support (task assistance, advocacy, DESC script for conflict); (5) Communication (SBAR, call-out, check-back, handoff — I PASS THE BATON); **SBAR** structured handoff: **S**ituation (concise present problem), **B**ackground (relevant history), **A**ssessment (clinical judgment), **R**ecommendation (specific action requested); example for severe preeclampsia: ''S: 32 wk gravida with BP 178/118 + headache; B: chronic HT, missed last 2 ANC; A: severe-range BP with cerebral symptom — suspected severe preeclampsia, eclampsia risk; R: I am giving labetalol 20 mg IV and MgSO4 bolus, please come now to evaluate for delivery''; **closed-loop communication** — sender states message, receiver repeats back, sender confirms; **call-outs** during emergencies (drug doses, vital signs); **CUS words** — ''I am **C**oncerned, **U**ncomfortable, this is a **S**afety issue''; psychological safety + speak-up culture; routine simulation training; debriefs after every emergency

---

TeamSTEPPS + SBAR = patient safety standard. Communication failures = root cause of most sentinel events. SBAR structured handoff. Closed-loop confirms understanding. CUS escalation. Psychological safety + flattened hierarchy. AHRQ evidence-based.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Labor + delivery unit implementing TeamSTEPPS + SBAR communication after sentinel event missed eclampsia';

update public.mcq_questions
set choices = '[{"label":"A","text":"Vital signs are not predictive"},{"label":"B","text":"document + review"},{"label":"C","text":"MEOWS only for ICU"},{"label":"D","text":"Vital signs ignored"},{"label":"E","text":"No protocol needed"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Maternal Early Warning Score (MEWS/MEOWS) — track-and-trigger: (1) routine maternal vital sign monitoring (NIBP, HR, RR, SpO2, temp, GCS/AVPU) at defined intervals; (2) **trigger criteria** (single trigger requires bedside evaluation): SBP < 90 or > 160, DBP > 100, HR < 50 or > 120, RR < 10 or > 30, SpO2 < 95% on air, oliguria < 35 mL/hr × 2 hr, altered mentation, fever > 38, persistent headache/visual symptoms, breathlessness; (3) **escalation pathway** — RN re-checks → MD bedside eval within 30 min → senior OB/MFM/anesthesia/ICU as needed; (4) **document + review** every trigger; (5) **rapid response team (OB-RRT / code OB)** activated for unstable; (6) targeted workup — preeclampsia, sepsis, hemorrhage, VTE, cardiac, anaphylaxis, AFE; (7) **MEOWS chart** color-coded (green/yellow/red zones) → visual prompt for action; (8) staff education + drills; (9) integrate with EMR alerts; (10) **outcomes**: MEOWS reduces maternal morbidity (RCOG, Saving Mothers Lives UK); (11) extends from antepartum through 6 wk postpartum (delayed presentation common); compare to NEWS2 (general) adapted for pregnancy physiology (lower BP normal, higher HR normal, respiratory alkalosis)

---

MEWS/MEOWS = early warning for maternal deterioration. Triggers + escalation pathway. RRT activation. Adapted for pregnancy physiology. Reduces maternal morbidity. Saving Mothers Lives UK evidence base. AIM bundle integration.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Hospital implements Maternal Early Warning Criteria (MEWC/MEOWS) for early sepsis + hemorrhage detection';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue warfarin throughout pregnancy"},{"label":"B","text":"Mechanical heart valve in pregnancy — anticoagulation strategy + multidisciplinary care (cardio-obstetric team)"},{"label":"C","text":"Stop all anticoagulation"},{"label":"D","text":"Terminate pregnancy"},{"label":"E","text":"Replace valve immediately"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mechanical heart valve in pregnancy — anticoagulation strategy + multidisciplinary care (cardio-obstetric team): (1) **warfarin** — most effective for valve thrombosis prevention BUT teratogenic (warfarin embryopathy — nasal hypoplasia, stippled epiphyses, CNS abnormalities — risk dose-dependent, > 5 mg/d highest risk; also fetal hemorrhage); (2) **options 1st trimester** (6-12 wk highest teratogen risk) — (a) **switch to LMWH** (enoxaparin BID, dose-adjusted to anti-Xa peak 1.0-1.2 IU/mL, trough > 0.6) — safer for fetus but higher maternal valve thrombosis risk; (b) continue warfarin ถ้า dose ≤ 5 mg (lower teratogen risk per ESC 2018); (c) UFH IV (alternative) — less reliable; (3) **2nd trimester (13-36 wk)** — warfarin reasonable (lowest fetal risk window); maintain INR 2.5-3.5 per valve type; (4) **at 36 wk** — switch to **LMWH or UFH** (warfarin causes fetal anticoagulation → intracranial hemorrhage during delivery); (5) plan **scheduled delivery** at 37-39 wk — stop LMWH 24 hr before, UFH 4-6 hr; restart 6-12 hr post-delivery + bridge back to warfarin (warfarin safe with breastfeeding); (6) avoid epidural ถ้า therapeutic anticoagulation; (7) endocarditis prophylaxis at delivery (controversial — ACC/AHA selective); (8) ICU/cardio-OB coordination; (9) fetal echo 22 wk; (10) preconception counseling ideal — discuss alternative valves before pregnancy

---

Mechanical valve pregnancy = high-risk integrative. Warfarin teratogenic (esp > 5 mg/d, 1st trimester). LMWH safer fetus but valve thrombosis risk if subtherapeutic. ESC + ACC/AHA guidelines. Cardio-OB multidisciplinary. Timing of switches around delivery critical.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 32 ปี G1P0 GA 16 wk underlying mechanical mitral valve replacement on warfarin 5 mg/d, INR 2.8

V/S: BP 118/72, HR 88, RR 16
Fetal: heart 158, growth appropriate, no anomalies on detailed US (will repeat 20 wk)
Cardiac: prosthetic mitral valve click normal, mild MR, EF 60%';

update public.mcq_questions
set choices = '[{"label":"A","text":"No treatment, wait until 3rd trimester"},{"label":"B","text":"HIV in pregnancy — comprehensive PMTCT (Prevention of Mother-to-Child Transmission)"},{"label":"C","text":"Avoid all medications during pregnancy"},{"label":"D","text":"Cesarean delivery + breastfeed"},{"label":"E","text":"Discontinue follow-up after delivery"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** HIV in pregnancy — comprehensive PMTCT (Prevention of Mother-to-Child Transmission): (1) **start ART immediately** regardless of CD4 or VL — Thai/WHO guidelines: TDF + 3TC (or FTC) + DTG (dolutegravir-based preferred, including 1st trimester per recent data) OR EFV-based alternative; goal — undetectable VL (< 50 copies/mL) at delivery → vertical transmission < 1%; (2) **lab monitoring** — VL every 4-8 wk + 34-36 wk (decides delivery mode), CD4, CBC, LFT, RFT, hepatitis B/C, syphilis, GC/CT screening; (3) **mode of delivery** — **vaginal delivery** safe ถ้า VL < 1,000 at 36 wk on ART; **scheduled cesarean at 38 wk** ถ้า VL > 1,000 or unknown; (4) **intrapartum** — IV zidovudine (AZT) infusion ถ้า VL > 1,000 or unknown at delivery — 2 mg/kg load then 1 mg/kg/hr until delivery; avoid invasive procedures (FSE, fetal scalp blood, AROM unless necessary, episiotomy, operative vaginal); (5) **postpartum infant** — **no breastfeeding** in Thailand/high-income (replacement feeding safe + acceptable + feasible + affordable + sustainable AFASS); WHO recommends breastfeeding + maternal ART in low-resource settings; infant prophylaxis — AZT 4 wk if low-risk, AZT + NVP + 3TC ถ้า high-risk; infant testing PCR at birth, 4-6 wk, 4-6 mo (DNA PCR — confirms negative); (6) ongoing maternal ART lifelong, multidisciplinary (ID, OB, pediatric, social, mental health); (7) disclosure + partner notification + testing + PrEP; (8) postpartum contraception

---

HIV PMTCT: untreated transmission risk 25-40% → < 1% with ART + intrapartum AZT + replacement feeding. DTG-based now preferred (no longer neural tube concern per Tsepamo update). VL-guided delivery mode. Avoid invasive intrapartum procedures. Infant prophylaxis + early PCR testing. Thailand achieved EMTCT status (eliminate mother-to-child transmission).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 35 ปี G2P1 GA 20 wk newly diagnosed HIV — first ANC visit, antiretroviral-naive, CD4 480, viral load 25,000 copies/mL

V/S: BP 116/72, HR 80
Fetal: anatomy scan normal, growth appropriate';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge with strict bed rest only"},{"label":"B","text":"Cervical insufficiency (history-indicated + US-indicated finding) — high recurrence risk; cerclage indicated"},{"label":"C","text":"Misoprostol immediately"},{"label":"D","text":"Cesarean delivery now"},{"label":"E","text":"Methotrexate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Cervical insufficiency** (history-indicated + US-indicated finding) — high recurrence risk; **cerclage** indicated: (1) **history-indicated McDonald cerclage at 12-14 wk** (prior ≥ 1 painless 2nd-trimester losses or short cervix in prior preg) — purse-string suture at cervico-vaginal junction; alternative Shirodkar (transvaginal) or transabdominal (failed transvaginal); (2) **US-indicated** ถ้า CL < 25 mm before 24 wk + history preterm birth → cerclage; (3) **physical exam-indicated ''rescue'' cerclage** ถ้า cervix dilated ≥ 1-2 cm before 24 wk + membranes visible — emergency cerclage 16-23+6 wk ถ้า no infection/labor/abruption (rule out chorioamnionitis first — amniocentesis); (4) **vaginal progesterone 200 mg PV daily** from 16-36 wk for short cervix (CL < 25 mm) — alternative or adjunct (PREGNANT, OPPTIMUM trials); (5) **17-OH progesterone caproate (Makena)** — recently withdrawn FDA 2023 due to PROLONG trial; (6) avoid digital exam unnecessarily; (7) activity restriction controversial — not bed rest; (8) GBS prophylaxis if indicated; (9) remove cerclage at 36-37 wk or with labor; (10) future pregnancies — prior cerclage = recurrence; counsel pre-pregnancy

---

Cervical insufficiency: painless 2nd-trim losses, recurrent. Diagnosis = history + US (CL < 25 mm < 24 wk with history). Cerclage types: history-indicated (12-14 wk), US-indicated, physical exam-indicated (rescue). Vaginal progesterone alternative/adjunct. Bed rest not effective. Rule out infection before rescue cerclage.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 28 ปี G3P0A2 (prior 2 painless 2nd-trimester losses 18-20 wk) GA 14 wk current pregnancy — TVS cervical length 22 mm + funneling

V/S: BP 116/70, HR 78
Fetal: viable, growth appropriate, no anomaly
No contractions, no bleeding';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue expectant management"},{"label":"B","text":"Clinical chorioamnionitis (intraamniotic infection — IAI)"},{"label":"C","text":"Discharge home with PO antibiotic"},{"label":"D","text":"Tocolysis to prolong pregnancy"},{"label":"E","text":"Steroid only without delivery"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Clinical chorioamnionitis (intraamniotic infection — IAI)** in PPROM: criteria — maternal fever ≥ 39.0 once OR 38.0-38.9 × 30 min PLUS one of: fetal tachy > 160, maternal WBC > 15K (no steroid), purulent cervical discharge; (1) **broad-spectrum IV antibiotics** — ampicillin 2 g IV q 6 hr + gentamicin 5 mg/kg q 24 hr (or 2 mg/kg load + 1.5 q 8 hr); add clindamycin 900 mg q 8 hr or metronidazole if C/S delivery (anaerobic coverage); penicillin-allergic: vanc + gent + clinda; (2) **deliver promptly regardless of GA** — chorioamnionitis = indication for delivery (uterine evacuation); vaginal delivery preferred ถ้า safe + reasonable progress; cesarean for usual obstetric indication; (3) antipyretic (acetaminophen); (4) IV fluid; (5) continuous fetal monitoring; (6) **neonatal team** standby — sepsis workup baby (early-onset sepsis high risk), antibiotics + culture; (7) **postpartum** — continue antibiotic until afebrile 24-48 hr + clinically improved (usually 24-48 hr post-delivery), one additional dose post-vaginal vs 24 hr post-C/S per protocol; (8) **placental pathology** for confirmation; (9) PPH risk ↑ (atony from inflammation); (10) sepsis bundle ถ้า severe — Hour-1 bundle, lactate, cultures, fluid, vasopressors ถ้า shock

---

Chorioamnionitis (IAI) = indication for delivery + antibiotics. Criteria — maternal fever + tachy/WBC/discharge. Amp + gent + clinda (if C/S). Vaginal delivery preferred. Neonatal sepsis risk. Postpartum endometritis prophylaxis. Placental path. Sepsis bundle if severe.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 30 ปี G2P1 GA 24 wk PPROM 3 d ago, was managed expectantly. Now มาด้วย fever 38.6, tachy, uterine tenderness + foul vaginal discharge

V/S: BP 110/68, HR 124, RR 22, Temp 38.6
Fetal: FHR 178 tachycardia, no decels yet
Lab: WBC 19,000 with left shift, CRP 95
Uterus: tender';

update public.mcq_questions
set choices = '[{"label":"A","text":"Outpatient ibuprofen"},{"label":"B","text":"Postpartum endometritis (most common cause of postpartum fever — polymicrobial: GBS, anaerobes, gram-negatives, gonorrhea/chlamydia): admit;"},{"label":"C","text":"Hysterectomy"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Antifungal only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Postpartum endometritis** (most common cause of postpartum fever — polymicrobial: GBS, anaerobes, gram-negatives, gonorrhea/chlamydia): admit; (1) **IV broad-spectrum antibiotics** — clindamycin 900 mg IV q 8 hr + gentamicin 5 mg/kg q 24 hr (gold standard, French regimen, > 90% cure) until afebrile 24-48 hr + clinical improvement, then no need oral conversion (vaginal delivery); add ampicillin if enterococcus/GBS suspected; alternative — amp/sulbactam, pip/tazo; (2) **rule out abscess** (US/CT) ถ้า persistent fever > 72 hr — drainage; (3) **rule out septic pelvic thrombophlebitis** (persistent fever despite antibiotics, anticoagulant trial); (4) **retained products** US — D&C if confirmed; (5) breast exam — mastitis/abscess; (6) UA, urine cx — UTI/pyelonephritis; (7) wound exam — surgical site infection; (8) **VTE prophylaxis** (postpartum + sepsis = high risk); (9) blood cx if severe; (10) lactation support if breastfeeding; (11) cesarean delivery endometritis higher risk (intra-op antibiotic prophylaxis pre-skin incision — cefazolin + azithromycin per SCIP/ASCRS reduces endometritis); (12) sepsis bundle if severe; (13) ICU ถ้า septic shock

---

Postpartum endometritis — most common postpartum infection. Risk: C/S (20×), prolonged labor, multiple exams, chorioamnionitis, GBS, low SES. Polymicrobial. Clinda + gent gold standard. Persistent fever → workup abscess, septic pelvic thrombophlebitis, retained products, wound infection. C/S antibiotic prophylaxis pre-incision (cefazolin + azithromycin).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 26 ปี G1P1 NSD 5 วันก่อน มาด้วยอาการ fever 38.8 + ปวดท้องน้อย + foul lochia + uterine tenderness

V/S: BP 118/74, HR 108, RR 18, Temp 38.8
Gen: ill-looking
Uterus: tender, subinvoluted, foul lochia
Lab: WBC 17,500, CRP 88, U/A WNL';

update public.mcq_questions
set choices = '[{"label":"A","text":"Outpatient ibuprofen"},{"label":"B","text":"Postpartum pulmonary embolism + DVT"},{"label":"C","text":"Discharge home with paracetamol"},{"label":"D","text":"Aspirin only"},{"label":"E","text":"Diuretic only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Postpartum pulmonary embolism + DVT** (postpartum hypercoagulable peak first 6 wk; risk 5× ↑ vs non-pregnant, 20× ↑ post-C/S): (1) **immediate stabilization** — O2, IV access, IV fluid careful; (2) **diagnostic imaging** — CT pulmonary angiogram (gold standard; less radiation than V/Q to fetus — and patient is postpartum so fetal not a concern); compression Doppler US lower extremity for DVT (alternative if can''t CT); ECG (S1Q3T3, sinus tachy, RV strain); echo (RV dilation, McConnell sign); (3) **anticoagulation** — start empirically pending workup ถ้า high probability — **LMWH (enoxaparin 1 mg/kg SC q 12 hr)** preferred postpartum (renal-adjusted) OR UFH IV ถ้า hemodynamic instability/thrombolysis planned/renal failure; (4) **massive PE with hemodynamic instability** (SBP < 90, RV failure) → thrombolysis (alteplase 100 mg over 2 hr) — postpartum bleeding risk; surgical embolectomy or catheter-directed thrombolysis alternatives; (5) IVC filter ถ้า contraindication to anticoagulation or recurrent PE; (6) duration — **at least 3 mo, extending 6 wk postpartum minimum**; bridge to warfarin or DOAC; warfarin OK with breastfeeding; DOACs unclear in breastfeeding; (7) workup — thrombophilia testing (postpone until off anticoagulation); (8) future pregnancy: prophylactic LMWH antepartum + postpartum 6 wk

---

VTE = leading cause of maternal mortality high-income. Risk peaks first 6 wk postpartum (esp C/S). PE = dyspnea, pleuritic pain, tachy, hypoxia. CTPA preferred postpartum. LMWH first-line. Massive PE → thrombolysis (postpartum bleed risk). 3 mo treatment + 6 wk minimum postpartum. Future pregnancy LMWH prophylaxis.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 35 ปี G3P3 postpartum d 10 จาก C/S last week — มาด้วย sudden dyspnea + pleuritic chest pain + R leg swelling × 2 d

V/S: BP 102/64, HR 124, RR 28, SpO2 89% RA, Temp 37.4
Gen: distressed, RA + L lower limb edema
Lab: D-dimer 4,500, BNP 280, troponin negative';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge home"},{"label":"B","text":"Amniotic Fluid Embolism (AFE)"},{"label":"C","text":"Discharge with paracetamol"},{"label":"D","text":"Wait + watch only"},{"label":"E","text":"Anticoagulation alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Amniotic Fluid Embolism (AFE)** — rare but catastrophic obstetric emergency (cardiopulmonary collapse + coagulopathy + altered mental status during labor/delivery/immediate postpartum); pathophysiology — anaphylactoid syndrome of pregnancy (immune-mediated, not just embolic); (1) **call code — multidisciplinary** — anesthesia/ICU/OB/hematology/neonatology; (2) **A-B-C — secure airway, intubate + ventilate**; (3) **circulatory support** — IV fluid bolus, vasopressors (norepi + epi), inotropes (dobutamine); avoid fluid overload (RV failure); (4) **CPR + ACLS** ถ้า arrest — left uterine displacement / perimortem C/S within 4 min ถ้า fetus undelivered; (5) **massive transfusion protocol** — PRBC + FFP + plt + cryoprecipitate 1:1:1; **fibrinogen replacement** (cryo or concentrate — target > 200 mg/dL, < 100 ominous); tranexamic acid 1 g IV; (6) **uterine atony management** — uterotonics + balloon + ligation/hysterectomy if needed for hemostasis; (7) **ECMO** — refractory cardiopulmonary collapse, venovenous or venoarterial; (8) supportive care ICU — invasive monitoring, mechanical ventilation, renal replacement, neuroprotection; (9) consider **A-OK regimen** (atropine + ondansetron + ketorolac — anecdotal Clark series); (10) diagnosis = clinical (rule out PE, abruption, sepsis, anaphylaxis, MI, eclampsia); mortality 20-60%, survivors often have neurologic injury; (11) debrief team + family + bereavement

---

AFE: rare (1-12/100,000), high mortality. Triad: cardiopulmonary collapse + coagulopathy + altered mental status. Phase 1 hypoxia/RV failure → Phase 2 LV failure + DIC. Multidisciplinary code response. MTP + fibrinogen. ECMO option. Perimortem C/S within 4 min of arrest. Diagnosis clinical. Survivors neurologic morbidity.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 28 ปี G1P1 NSD 30 นาที, sudden agitation + dyspnea + cyanosis + hypotension immediately after delivery + coagulopathy

V/S: BP 60/30, HR 140, RR 32, SpO2 78%
Gen: cyanotic, altered mental status
Uterus: atonic, heavy bleeding
Lab (stat): plt 45K, INR 2.8, fibrinogen 80, D-dimer > 20,000';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge home"},{"label":"B","text":"Uterine Inversion (rare but life-threatening — fundus inverted through cervix; severe hemorrhage + shock; risk: excessive cord traction, fundal pressure, atony, accreta, short cord)"},{"label":"C","text":"Hysterectomy first"},{"label":"D","text":"Wait + observe"},{"label":"E","text":"Tocolytic without replacement"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Uterine Inversion** (rare but life-threatening — fundus inverted through cervix; severe hemorrhage + shock; risk: excessive cord traction, fundal pressure, atony, accreta, short cord): (1) **call for help — anesthesia + OB**; (2) **immediate manual replacement** — push fundus back via vagina (**Johnson maneuver**) — place placenta in palm, push back through cervix toward umbilicus; do NOT remove placenta until uterus replaced (worsens hemorrhage); (3) **stop uterotonics** + **uterine relaxation** — IV nitroglycerin 50-200 mcg bolus, terbutaline 0.25 mg SC, magnesium, or general anesthesia with halogenated agent (relaxation needed); (4) **once replaced** — bimanual compression, **then start uterotonics** (oxytocin) to maintain tone + prevent re-inversion; (5) **manually remove placenta** if still attached; (6) **IV access × 2 large bore**, type & cross, massive transfusion if needed; (7) **surgical management** ถ้า manual replacement fails — laparotomy — **Huntington procedure** (clamps + traction on round ligaments) or **Haultain procedure** (posterior cervical incision); rarely hysterectomy; (8) postpartum monitoring for recurrence + hemorrhage + DIC; (9) document mechanism + counsel; future pregnancy increased risk recurrence

---

Uterine inversion: rare emergency. Recognize → call help → immediate manual replacement (Johnson) → relaxation → replace → uterotonics. Hemorrhage + shock common. Surgical (Huntington, Haultain) if manual fails. Risk: cord traction, fundal pressure, accreta.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 28 ปี G1P1 immediately after vaginal delivery — sudden hypotension + uterus not palpable abdominally + mass in vagina + heavy bleeding

V/S: BP 78/48, HR 132
Uterus: not palpable on abdominal exam, palpable mass at vagina
Bleeding: heavy ongoing';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait until baby born then start antibiotic"},{"label":"B","text":"Group B Streptococcus (GBS) Intrapartum Prophylaxis"},{"label":"C","text":"Cesarean delivery"},{"label":"D","text":"Topical antibiotic"},{"label":"E","text":"Antifungal"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Group B Streptococcus (GBS) Intrapartum Prophylaxis** (Thai/CDC universal screening at 36+0-37+6 wk; treat: positive culture, prior GBS-affected infant, GBS bacteriuria current pregnancy, unknown status with risk factors — < 37 wk, ROM > 18 hr, fever ≥ 38, intrapartum NAAT positive): (1) **penicillin G 5 million U IV load then 2.5-3 million U IV q 4 hr** until delivery (first-line; ≥ 4 hr before delivery for adequacy); alternative ampicillin 2 g IV load then 1 g q 4 hr; (2) **non-anaphylactic penicillin allergy** (mild rash) → cefazolin 2 g IV load then 1 g q 8 hr; (3) **severe penicillin allergy (anaphylaxis, angioedema, urticaria)** → clindamycin 900 mg IV q 8 hr ถ้า isolate sensitive (request susceptibility); vancomycin 20 mg/kg IV q 8 hr (max 2 g/dose) ถ้า clinda-resistant; (4) **goal** — ≥ 2 doses or ≥ 4 hr before delivery for optimal effect; (5) prevents early-onset neonatal GBS sepsis (50-80% reduction); does NOT prevent late-onset (after 7 d); (6) cesarean before labor + intact membranes — NOT needed; (7) **PPROM < 37 wk** — start antibiotics including GBS coverage (ampicillin); (8) document GBS status + antibiotic timing — neonatal team uses for newborn risk stratification

---

GBS prophylaxis: universal screen 36-37+6 wk. PCN G first-line. Allergy → cefazolin, clinda (if sensitive), vanc. ≥ 4 hr before delivery optimal. Reduces early-onset neonatal GBS sepsis. Not for elective C/S with intact membranes.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 26 ปี G1P0 GA 36 wk GBS-positive at 36 wk screening — มาในระยะ labor, contractions q 4 นาที, cervix 4 cm dilated, ROM 2 hr ago

V/S: BP 118/72, HR 92, Temp 37.0
Fetal: FHR 142 reactive
No penicillin allergy';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge home with PRN antiemetic"},{"label":"B","text":"admit + IV hydration"},{"label":"C","text":"Cesarean immediately"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Discharge with PO antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Hyperemesis Gravidarum** (severe N/V > 5% weight loss + dehydration + electrolyte/acid-base abnormalities + ketonuria; biochemical hyperthyroidism common — hCG cross-reacts TSH receptor — usually transient, NO antithyroid needed unless persistent + clinical signs): (1) **admit + IV hydration** — NS or LR with **dextrose** + potassium replacement (K 2.8 = severe) — careful potassium repletion 20-40 mEq/L; correct Na slowly (avoid CPM); (2) **thiamine 100 mg IV before dextrose** (Wernicke prophylaxis); (3) **antiemetics** — stepwise: (a) pyridoxine (B6) 10-25 mg q 6-8 hr ± doxylamine 12.5-20 mg (Diclegis/Bonjesta — first-line); (b) add dimenhydrinate, diphenhydramine, prochlorperazine, promethazine; (c) **ondansetron** 4-8 mg IV/PO (avoid first trimester ideally — small cleft palate signal; usually OK if needed); (d) **metoclopramide** 10 mg IV/PO; (e) **methylprednisolone** 16 mg IV/PO q 8 hr (refractory); (4) NPO → clears → small frequent bland meals (BRAT, dry crackers in morning); (5) thiamine, multivitamin (folate); (6) **rule out** — molar pregnancy (US, hCG very high), multifetal (US), hyperthyroid (Graves vs hCG-mediated — if T3 high + TRAb +, treat with PTU first trimester then methimazole 2nd-3rd), DKA, UTI, hepatitis, pancreatitis, gastroenteritis; (7) NG/TPN refractory cases (rare); (8) social support + counseling (psych comorbidity); (9) ginger, acupressure, lifestyle complementary

---

HEG vs morning sickness — severity. Dx: > 5% weight loss + dehydration + ketonuria + electrolyte imbalance. Transient hyperthyroidism (hCG-mediated) — no antithyroid usually. Stepwise antiemetic. IV thiamine before dextrose (Wernicke). Rule out molar, multifetal, hyperthyroid, etc. Hospital ถ้า severe.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 26 ปี G1P0 GA 10 wk มาด้วยอาการอาเจียนรุนแรง > 15 ครั้ง/วัน × 1 สัปดาห์ ไม่กินอาหารได้, weight loss 4 kg (8% body weight)

V/S: BP 96/60, HR 116, RR 18
Gen: dehydrated, dry mucous membranes
Lab: Na 132, K 2.8, Cl 88, HCO3 32, BUN 28, Cr 0.9, ketone 3+ urine, TSH 0.05, free T4 normal, US: singleton, no molar';

update public.mcq_questions
set choices = '[{"label":"A","text":"Hysterectomy เลย"},{"label":"B","text":"PALM = structural"},{"label":"C","text":"Antibiotic only"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Wait + observe only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Symptomatic uterine fibroids (PALM-COEIN: **PALM = structural** — Polyp, Adenomyosis, Leiomyoma, Malignancy; **COEIN = non-structural** — Coagulopathy, Ovulatory, Endometrial, Iatrogenic, Not yet classified) + iron-deficiency anemia: stepwise management individualized to fertility desire, size, symptoms: (1) **medical** — (a) iron supplementation (PO ferrous sulfate 200 mg TID or IV iron sucrose ถ้า PO intolerant/severe); (b) **GnRH agonist (leuprolide)** — temporary fibroid shrinkage + amenorrhea preoperative (3-6 mo, add-back therapy); (c) **GnRH antagonist (elagolix/relugolix)** + add-back — newer oral options; (d) **ulipristal acetate** — selective progesterone receptor modulator (restricted hepatotoxicity); (e) **LNG-IUD** ถ้า uterus < 12 wk + fibroid not distorting cavity — reduces HMB; (f) tranexamic acid 1 g TID during menses; (g) NSAIDs; (h) combined OCP / progestin for cycle control; (2) **procedural** — (a) **hysteroscopic myomectomy** for submucosal — first choice for submucosal symptomatic fibroids if fertility desired; (b) **uterine artery embolization (UAE)** — radiologic, preserves uterus, not first choice if fertility planned; (c) **MRI-guided focused US (MRgFUS)**; (d) **myomectomy (lap/open/robotic)** — fertility preservation; (e) **endometrial ablation** ถ้า no fertility + no submucosal large; (3) **definitive — hysterectomy** ถ้า complete + done childbearing + symptoms refractory; (4) discuss morcellation risk (occult sarcoma); (5) Thai context — endometrial biopsy ก่อน 45+ to rule out hyperplasia/cancer in AUB

---

AUB-L (leiomyoma) in PALM-COEIN. Fibroids: submucosal causes HMB, intramural may, subserosal less. Management individualized: fertility, size, symptoms. Hysteroscopic for submucosal. UAE preserves uterus. Hysterectomy definitive. AUB age > 45 → endometrial biopsy.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 42 ปี G0P0 มา OPD ด้วยอาการประจำเดือนผิดปกติ — heavy + irregular × 8 เดือน, intermenstrual spotting, ปวด pelvic chronic

V/S: BP 124/76, HR 84
Pelvic: enlarged irregular uterus 14-week size, no adnexal mass
US: multiple intramural + submucosal fibroids, largest 6 cm submucosal
Lab: Hb 8.4, ferritin 8, TSH normal, β-hCG negative, endometrial biopsy: benign proliferative';

update public.mcq_questions
set choices = '[{"label":"A","text":"Reassurance only"},{"label":"B","text":"NSAIDs + combined OCP"},{"label":"C","text":"Cesarean delivery"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Endometriosis (ectopic endometrial-like tissue outside uterus — peritoneum, ovaries, deep infiltrating in rectovaginal septum/bowel/bladder/diaphragm; ASRM staging I-IV; cause: retrograde menstruation + others; diagnosis: clinical + imaging + laparoscopy with biopsy gold standard): stepwise treatment by symptoms + fertility goals: (1) **medical (pain)** — first-line **NSAIDs + combined OCP** (cyclic or continuous) suppresses ovulation; second-line **progestin-only** (norethindrone, DMPA, LNG-IUD, dienogest); third-line **GnRH agonist (leuprolide)** + add-back therapy (HRT) to mitigate hypoestrogenic SE; **GnRH antagonist** (elagolix) oral; aromatase inhibitor letrozole adjunct refractory; (2) **surgical** — laparoscopy excision/ablation of endometriotic implants + cystectomy for endometrioma (improves pain + fertility; but ovarian reserve risk with cystectomy); deep infiltrating endometriosis often multidisciplinary (colorectal/urology); hysterectomy ± BSO definitive if completed childbearing + refractory; (3) **infertility** — referral REI; **IVF** highly effective (endometriosis may have ovarian factor + tubal factor + peritoneal); ovarian stimulation + IUI in mild-moderate; surgical excision of endometrioma controversial pre-IVF (may ↓ AMH); (4) **lifestyle** — exercise, diet, mind-body; (5) chronic pain — multidisciplinary pain mgmt, PFPT, neuropathic agents; (6) follow long-term — recurrence common; (7) cancer risk slightly ↑ (clear cell, endometrioid ovarian)

---

Endometriosis: pelvic pain + dysmenorrhea + dyspareunia + infertility. Laparoscopy = gold standard dx. NSAIDs + OCP first-line. Surgical excision + IVF for infertility. Recurrence common. CA-125 nonspecific. ASRM staging.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 30 ปี G0P0 มา OPD ด้วยอาการ chronic pelvic pain + dysmenorrhea progressive × 5 ปี + dyspareunia + cyclic dyschezia + infertility 2 ปี

V/S: BP 116/72, HR 80
Pelvic: tender uterosacral ligament + nodularity, fixed retroverted uterus, R adnexal tenderness
US TV: R ovarian endometrioma 4 cm + deep infiltrating endometriosis suspected on rectovaginal septum
CA-125 78';

update public.mcq_questions
set choices = '[{"label":"A","text":"Reassurance — try harder"},{"label":"B","text":"Polycystic Ovary Syndrome (PCOS)"},{"label":"C","text":"Cesarean delivery"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Polycystic Ovary Syndrome (PCOS)** — Rotterdam criteria (need ≥ 2 of 3): (a) oligo/anovulation, (b) clinical/biochemical hyperandrogenism, (c) polycystic ovaries on US; exclude other causes (thyroid, prolactin, CAH 17-OHP, Cushing, androgen-secreting tumor); (1) **lifestyle** — weight loss 5-10% improves cycles + ovulation + insulin resistance + metabolic; diet + exercise; (2) **metabolic workup** — fasting glucose / OGTT (T2DM risk 2-4×), lipid panel, BP, LFT (NAFLD); (3) **endometrial protection** (anovulation → unopposed estrogen → hyperplasia/cancer risk); cyclic progestin (medroxyprogesterone 10 mg × 12 d every 1-3 mo) or COCP or LNG-IUD; **endometrial biopsy ถ้า prolonged amenorrhea > 1 yr or endometrium > 7-10 mm**; (4) **cycle regulation + hyperandrogenism** — COCP (esp with drospirenone — anti-mineralocorticoid + androgenic ↓); spironolactone 50-200 mg/d for hirsutism (after 6 mo COCP if persistent); add COCP with spironolactone (avoid pregnancy on spironolactone); cosmetic — laser, eflornithine; (5) **ovulation induction for fertility** — letrozole 2.5-7.5 mg d 3-7 (first-line per PCOS network — superior to clomiphene); clomiphene citrate; metformin adjunct or alone (esp obese, insulin resistant); gonadotropins or IVF if refractory; **laparoscopic ovarian drilling** alternative; (6) metformin for metabolic + DM prevention; (7) screen depression/anxiety (common); (8) sleep apnea; (9) long-term — DM, CVD, endometrial cancer surveillance; (10) preconception counseling

---

PCOS Rotterdam criteria (Thai/AE-PCOS adopted). Manifestations: oligomenorrhea, hyperandrogenism, PCO morphology, insulin resistance, metabolic syndrome. Lifestyle first. COCP cycle + hyperandrogenism. Letrozole first-line ovulation. Metformin metabolic. Endometrial protection. Long-term metabolic + cancer surveillance.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 26 ปี G0P0 มา OPD ด้วยอาการประจำเดือนมาไม่สม่ำเสมอ (oligomenorrhea — 4-6 cycles/yr) + hirsutism + acne + obesity (BMI 32) × 5 ปี + difficulty conceiving 1 ปี

V/S: BP 126/82, HR 84
Gen: acanthosis nigricans, hirsutism (mFG 12)
Lab: testosterone total 78 (mildly elevated), DHEAS WNL, 17-OHP normal, prolactin normal, TSH normal, FSH 5, LH 14 (ratio 2.8), AMH 8.5
US TV: bilateral polycystic ovaries (> 20 follicles per ovary 2-9 mm + volume 12 mL) + endometrium 4 mm, last menses 3 mo ago';

update public.mcq_questions
set choices = '[{"label":"A","text":"Conceive naturally — wait more 6 mo"},{"label":"B","text":"ovulation induction + IUI 3-6 cycles"},{"label":"C","text":"Cesarean immediately"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Methotrexate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Infertility workup** (failure to conceive after 12 mo unprotected intercourse; or 6 mo if ≥ 35 yr or known risk): with normal AMH/FSH (ovarian reserve OK), regular cycles (likely ovulatory), patent tubes (HSG normal), normal semen — unexplained infertility (~ 15%); confirm: (1) **ovulation** — day 21 (mid-luteal) progesterone > 3 ng/mL = ovulatory; basal body temp, OPK (LH surge); (2) **ovarian reserve** — AMH (anti-Müllerian hormone), antral follicle count (AFC), day 3 FSH/E2 — AMH 2.1 = adequate; (3) **tubal patency** — HSG or HyCoSy; sonohysterography for cavity; (4) **semen analysis** — WHO 2021 ref values (concentration > 16 million/mL, motility > 42%, normal morphology > 4%) — this is normal; repeat 2-3 mo apart; (5) **uterine cavity** — saline infusion sonography or hysteroscopy; (6) **management** — start with **ovulation induction + IUI 3-6 cycles** for unexplained infertility (letrozole or clomiphene + IUI); if fail → **IVF** (35+ — go to IVF sooner); (7) lifestyle — folic acid 400-800 mcg, healthy weight, no smoking/alcohol, manage stress; (8) genetic counseling ถ้า history; (9) **emotional support** — psych counseling, infertility-related distress common; (10) explain stepwise: IUI → IVF → donor gametes → adoption per couple preference + finances + Thai laws

---

Infertility workup. Female: ovulation, ovarian reserve, tubal, uterine. Male: SA WHO 2021. Lifestyle. Unexplained: 3-6 cycles OI/IUI → IVF. Age 35+ shorten timeline. AMH + AFC predict response. Emotional support critical.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'คู่สามีภรรยา หญิงอายุ 32 ชาย 34 trying to conceive × 18 เดือน — failed; หญิง cycles regular 28 d, BMI 22, prior healthy; ชาย no comorbidity

V/S: BP 110/68, HR 76
Pelvic exam: normal
Lab: TSH normal, prolactin normal, AMH 2.1, FSH d3 7.8, semen analysis: volume 2.5 mL, concentration 22 million/mL, motility 48%, normal morphology 6%
HSG: bilateral tubal patency, normal cavity';

update public.mcq_questions
set choices = '[{"label":"A","text":"Only OCP available"},{"label":"B","text":"Contraception counseling — tiered effectiveness approach (CDC/WHO)"},{"label":"C","text":"Cesarean delivery"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Contraception counseling — tiered effectiveness approach (CDC/WHO)**: discuss all reversible methods, allow informed choice: (1) **most effective (LARC)** — **levonorgestrel IUD** (Mirena 5-8 yr; Kyleena 5 yr; Skyla 3 yr) — failure < 1%; reduces menstrual blood loss; **copper IUD** (Paragard 10-12 yr) — non-hormonal, emergency contraception within 5 d; **etonogestrel implant** (Nexplanon 3-5 yr per evidence) — failure < 1%; (2) **highly effective** — **DMPA injection** q 3 mo (delayed return to fertility, bone density caution); **combined hormonal** — COCP (estrogen + progestin, daily); transdermal patch (weekly); vaginal ring (monthly); failure 7% typical use; **progestin-only pill** — strict timing; (3) **less effective** — diaphragm, sponge, cervical cap, male condom (also STI), female condom, withdrawal, fertility awareness; (4) **permanent** — tubal ligation/Essure (discontinued), vasectomy; (5) **emergency contraception** — copper IUD (most effective, 0.1%), ulipristal acetate 30 mg PO (up to 5 d), levonorgestrel 1.5 mg (up to 3 d, less effective if obese); (6) **U.S. MEC** — categories 1-4 contraindications (e.g., estrogen contraindicated < 6 wk postpartum breastfeeding, > 35 + smoking > 15 cigs, migraine with aura, history VTE, uncontrolled HT, recent VTE, breast cancer); (7) **counseling** — failure rates, return to fertility, STI protection (only condoms), side effects, cost, ease; (8) **shared decision-making**; (9) screening Thai guidelines: pap, STI; (10) preconception planning given 2-yr horizon — LARC easily removed when ready (immediate return to fertility), IUD or implant first-line recommendation per CDC tiered counseling

---

Tiered contraception counseling — start with most effective (LARC). U.S. MEC contraindications. Informed choice. LARC: IUD (LNG, Cu), implant. Highly effective: DMPA, COCP, ring, patch. Less: barrier, fertility awareness. Emergency contraception: Cu IUD > UPA > LNG. Return to fertility.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 24 ปี LMP regular 28 d cycles, มา OPD ขอ contraception — no contraindication, no smoking, BMI 22, planning conception ใน 2 ปี

V/S: BP 116/72, HR 76
Gen: well
Pap smear normal 1 yr ago';

update public.mcq_questions
set choices = '[{"label":"A","text":"Misoprostol high dose"},{"label":"B","text":"Emergency Contraception options (most → least effective)"},{"label":"C","text":"Antibiotic"},{"label":"D","text":"Wait + see"},{"label":"E","text":"Misoprostol abortion"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Emergency Contraception options (most → least effective): (1) **Copper IUD** — most effective EC (failure < 0.1%), insert within 120 hr (5 d) post-intercourse; provides ongoing contraception 10-12 yr; not affected by BMI; rule out current pregnancy + STI screen; (2) **Ulipristal Acetate (UPA, Ella) 30 mg PO single dose** — selective progesterone receptor modulator, effective up to 5 d; superior to LNG especially day 4-5; effective in higher BMI; available Thailand; delay start of hormonal contraception 5 d after UPA; (3) **LNG-IUD (Mirena 52 mg)** — recently shown non-inferior to copper IUD in EC trial; (4) **Levonorgestrel 1.5 mg PO single dose (Postinor)** — most accessible, up to 72 hr (declining efficacy day 3-5); less effective if BMI > 25-30; OTC in Thailand; can be repeated; (5) **Yuzpe regimen** — combined estrogen-progestin (high dose COCP) — older, more nausea, less effective; **management** — assess timing of intercourse, LMP, BMI, future contraception plan; pregnancy test if delay or late period; STI screen if risk; **transition** — start ongoing contraception immediately after LNG (or 5 d after UPA); offer LARC discussion; **counsel** — EC reduces but does not eliminate risk, no protection against future intercourse, no STI protection, side effects (nausea, irregular bleeding), follow-up if no menses in 3 wk

---

EC: Cu IUD > UPA > LNG-IUD ≈ UPA > LNG > Yuzpe. Timing critical — Cu IUD/UPA effective up to 5 d. Counsel ongoing contraception. STI screen. Pregnancy test if late. BMI affects LNG efficacy. UPA may delay ovulation more effectively. Thailand: LNG OTC.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 19 ปี nulliparous มาที่ห้องฉุกเฉินด้วยอาการ unprotected intercourse 18 ชั่วโมงก่อน — ขอ emergency contraception

V/S: BP 116/72, HR 84
Gen: well, no symptoms
LMP 14 d ago, mid-cycle (high pregnancy risk)
No current contraception, no STI risk factors stated';

update public.mcq_questions
set choices = '[{"label":"A","text":"Reassurance only"},{"label":"B","text":"Endometrial hyperplasia WITHOUT atypia"},{"label":"C","text":"Hysterectomy without trial of progestin"},{"label":"D","text":"Antibiotic"},{"label":"E","text":"Wait until menopause"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Endometrial hyperplasia WITHOUT atypia** (low progression risk to endometrioid endometrial cancer ~ 1-3% over 20 yr; vs **WITH atypia** = endometrial intraepithelial neoplasia EIN ~ 30% concurrent or progression cancer): management: (1) **identify + correct risk factors** — obesity (weight loss), unopposed estrogen, anovulation (PCOS), tamoxifen, HRT, Lynch syndrome; (2) **first-line — progestin therapy** — **LNG-IUD (Mirena)** preferred (regression > 90%, fewer side effects) × 6 mo then re-biopsy; (3) **alternative oral progestins** — medroxyprogesterone acetate 10-20 mg daily continuous or cyclic 12-14 d/mo, megestrol acetate 40-80 mg/d, norethindrone; (4) **follow-up** — endometrial biopsy every 6 mo until 2 consecutive negative; (5) **persistence/progression** → hysterectomy ถ้า no fertility desire OR atypia develops; (6) **atypia (EIN)** — hysterectomy preferred (definitive, ~ 30% concurrent cancer); progestin if fertility-sparing (LNG-IUD or megestrol) + sampling q 3 mo; (7) treat anemia — iron, transfusion if severe; (8) genetic counseling — Lynch syndrome screening (universal in endometrial cancer; family history); (9) Thai AUB-PALM-COEIN — perimenopausal AUB → endometrial sampling mandatory (rule out hyperplasia/cancer); (10) lifestyle — weight loss reduces estrogen + recurrence

---

Endometrial hyperplasia: WITHOUT atypia 1-3% cancer risk; WITH atypia (EIN) 30% concurrent cancer → hysterectomy first-line (or fertility-sparing progestin). Without atypia: LNG-IUD first-line. Follow biopsy q 6 mo. Risk factors: obesity, unopposed estrogen, anovulation, tamoxifen. Lynch screening.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 48 ปี perimenopausal มา OPD ด้วยอาการ heavy menstrual bleeding (HMB) + occasional intermenstrual bleeding × 6 เดือน, soaking pads, Hb 9.2, weight 78 kg BMI 30

V/S: BP 132/82, HR 86
Pelvic: uterus 8 wk size, no adnexal mass
US: endometrium 12 mm thickened, irregular
Endometrial biopsy: complex endometrial hyperplasia WITHOUT atypia';

update public.mcq_questions
set choices = '[{"label":"A","text":"Repeat Pap in 6 months"},{"label":"B","text":"ASCUS Pap + HPV high-risk positive (per ASCCP 2019 risk-based guidelines)"},{"label":"C","text":"Discharge — no follow-up"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Methotrexate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** ASCUS Pap + HPV high-risk positive (per ASCCP 2019 risk-based guidelines): (1) **colposcopy** indicated (≥ 4% immediate CIN3+ risk); biopsy any visible lesion + ECC if no lesion seen; (2) **colposcopy findings → management**: (a) CIN1 → conservative observation, repeat HPV+cyto 1 yr (most regress); (b) CIN2 → reasonable to treat or observe (CIN2 = intermediate, often regresses esp in young women); (c) CIN2 + age < 25 → observe with cyto + colpo q 6 mo × 2 yr; (d) CIN3 → treatment — excision (LEEP, cold knife cone, laser) preferred over ablation; **HPV 16 → higher risk + immediate colposcopy** even with negative cyto in some scenarios; (3) **HPV 16/18 with abnormal cyto** → expedited treatment (LEEP) without biopsy may be considered in select adults (not pregnant, not young); (4) **post-treatment surveillance** — HPV + cyto co-test 6 mo + 12 mo + 24 mo, then q 3 yr for 25 yr; (5) **pregnancy considerations** — colposcopy safe; defer treatment unless invasive cancer suspected; ECC contraindicated; (6) **HPV vaccination** — Thailand free for girls grade 5 (Gardasil 9 or 4-valent); vaccinate up to age 26 catch-up, up to 45 individualized; vaccination after treatment reduces recurrence; (7) **risk factors** — smoking, HIV/immunosuppression, multiple partners, early sexual debut, OCP > 5 yr

---

ASCCP 2019 risk-based management. ASCUS + HPV+ → colposcopy. CIN1 observe, CIN2 treat or observe (young), CIN3 treat (excision). HPV 16 expedited treatment select. Post-treatment surveillance long-term. HPV vaccine prevention + post-treatment recurrence reduction.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 32 ปี G2P2 พบ Pap smear ASCUS, HPV reflex positive (high-risk types incl 16/18 — not specified), no symptoms

V/S: BP 116/72, HR 80
Pelvic exam: WNL, no visible lesion';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue pregnancy with observation"},{"label":"B","text":"Complete Hydatidiform Mole"},{"label":"C","text":"Continue pregnancy + watch"},{"label":"D","text":"Methotrexate alone without evacuation"},{"label":"E","text":"Hysterectomy first-line"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Complete Hydatidiform Mole** (Gestational Trophoblastic Disease — GTD): (1) **suction D&C** — definitive treatment under GA with oxytocin (started AFTER cervix dilated to reduce trophoblast embolization); send products for histology + ploidy (complete = diploid 46XX/46XY paternal origin; partial = triploid); (2) **Rh-Ig** if Rh-negative; (3) **β-hCG monitoring weekly until 3 consecutive negative → monthly × 6 mo** — surveillance for post-molar gestational trophoblastic neoplasia (GTN — 15-20% complete mole, 1-5% partial); (4) **effective contraception during surveillance** (avoid new pregnancy confusing β-hCG); avoid IUD until uterus involuted; OCP safe; (5) **hyperthyroidism (hCG cross-reaction)** — usually resolves after evacuation; β-blocker (propranolol) for symptoms; avoid thyrotoxic crisis during evacuation; (6) **theca lutein cysts** — resolve spontaneously over months; (7) **early-onset preeclampsia < 20 wk** = mole red flag (hCG); (8) **post-molar GTN diagnosis** (FIGO 2000): plateau hCG × 4 wk, rise × 3 wk, > 6 mo persistent hCG, or histology choriocarcinoma → **chemotherapy** (methotrexate ± actinomycin D for low-risk; EMA-CO for high-risk); FIGO/WHO risk score determines regimen; (9) **referral** — gestational trophoblastic disease center; (10) future pregnancy — recurrence ~ 1-2% — early US first trimester; histology of products

---

Complete hydatidiform mole: snowstorm US, very high hCG, hyperthyroid (hCG-TSH cross), early HTN, hyperemesis, theca lutein cysts. Suction D&C + β-hCG surveillance + contraception. Post-molar GTN 15-20% complete → chemo. Partial mole < 5% GTN risk. Choriocarcinoma highly chemo-sensitive.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 28 ปี G1P0 GA 10 wk LMP, β-hCG 250,000 (uterine size GA 18 wk discrepancy), severe hyperemesis + early-onset hypertension + hyperthyroid symptoms

V/S: BP 158/96, HR 118 (resting tachy), Temp 37.2
Gen: tremor, sweating
Fetal: US: no fetus, snowstorm/multivesicular uterine cavity, theca lutein cysts bilateral 6 cm, no metastasis seen on CXR/abdo US
Lab: TSH 0.02, FT4 elevated, β-hCG 350,000';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge — observation"},{"label":"B","text":"Endometrial adenocarcinoma"},{"label":"C","text":"Antibiotic only"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Wait + repeat biopsy 6 mo"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Endometrial adenocarcinoma** (most common gynecologic malignancy in developed countries; Thai 2nd-3rd most common GYN; type I endometrioid — estrogen-related, well-differentiated, better prognosis; type II serous/clear cell — non-estrogen, worse prognosis): (1) **staging workup** — pelvic MRI (myometrial invasion, cervical), CT chest/abdo/pelvis (or PET-CT), CA-125, CBC/CMP, EKG, anesthesia eval; Lynch syndrome screening universal (MSI/IHC tumor) → genetic counseling; (2) **surgical staging — gold standard** — **total hysterectomy + bilateral salpingo-oophorectomy + sentinel lymph node biopsy** (or pelvic ± paraaortic lymphadenectomy in high-risk); peritoneal cytology no longer formal staging but recorded; minimally invasive (lap or robotic) preferred — equivalent oncologic + less morbidity (LAP2/LACE); (3) **adjuvant therapy** based on FIGO stage + risk: (a) Stage IA, grade 1-2 — observation often; (b) IA grade 3 / IB / II — vaginal brachytherapy ± EBRT; (c) Stage III-IVA — pelvic EBRT + chemo (carbo/paclitaxel); (d) Stage IV/recurrent — chemo + immunotherapy (pembrolizumab + lenvatinib for MSI-H or pMMR); (4) **fertility-sparing** (rare in this patient given age + grade 1 but for younger women with stage IA grade 1) — high-dose progestin (LNG-IUD + megestrol) + sampling q 3 mo; (5) **co-morbidities management** — DM, HT, weight loss; (6) **surveillance** — exam + symptoms q 3-6 mo × 2 yr, then q 6 mo × 3 yr, then annual; imaging if symptoms; (7) **prognosis** — 5-yr survival stage I ~ 85-95%, stage III 50-65%, stage IV 15-20%

---

Endometrial cancer: postmenopausal bleeding = cancer until proven otherwise. Endometrial biopsy/D&C diagnostic. Surgical staging TH-BSO + SLN. Type I endometrioid majority. Adjuvant per stage/grade. Lynch screening universal. New: pembro + lenvatinib for MSI-H/pMMR.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 56 ปี postmenopausal × 5 yr มาด้วย postmenopausal bleeding × 2 mo, no HRT use

V/S: BP 138/84, HR 78
Gen: BMI 35, hypertension, T2DM
Pelvic: vagina atrophic, cervix benign, uterus 6 wk size, no adnexal mass
US: endometrium 15 mm with irregular cystic areas
Endometrial biopsy: endometrioid adenocarcinoma grade 1';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge — observation"},{"label":"B","text":"Suspected advanced ovarian cancer"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Hysterectomy only without staging"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Suspected advanced ovarian cancer** (epithelial — high-grade serous most common; Stage IIIC-IV by CT findings): (1) **pre-treatment workup** — paracentesis for cytology, CT or PET-CT, CA-125 + HE4 + ROMA; rule out non-gynecologic primary (GI scope if mucinous, breast exam, CEA, CA 19-9); (2) **multidisciplinary team** — GYN-onc, medical onc, radiology, pathology, palliative care; (3) **two strategies**: (a) **primary debulking surgery (PDS)** if optimal cytoreduction feasible (no residual disease ideal — R0) + medically fit — laparotomy, TH + BSO, omentectomy, lymphadenectomy, peritoneal stripping, bowel/diaphragm/splenectomy as needed; (b) **neoadjuvant chemo (NACT) + interval debulking surgery (IDS)** — preferred ถ้า extensive disease + poor PS + comorbidities (CHORUS, EORTC trials show non-inferior in suboptimal candidates with less morbidity); 3 cycles carbo/paclitaxel → IDS → 3 more cycles; (4) **maintenance therapy** — PARP inhibitors (olaparib, niraparib) for BRCA1/2 mutation OR HRD-positive (homologous recombination deficiency); bevacizumab in maintenance; pembrolizumab in select; (5) **genetic testing** — BRCA1/2 germline + somatic, HRD, cascade family testing (Lynch panel); (6) **palliative care integration** — early integration improves outcomes (Temel NEJM 2010 ovarian); (7) **surveillance** — exam, CA-125, imaging if symptoms; (8) Thai/RTCOG protocols + multidisciplinary; (9) **prognosis** — stage IIIC 5-yr ~ 30-40%, stage IV ~ 20%; (10) recurrence common — platinum-sensitive vs resistant defines second-line; (11) clinical trial enrollment

---

Advanced ovarian cancer: bloating, early satiety, ascites, bilateral masses, ↑ CA-125. PDS vs NACT-IDS. Optimal debulking (R0 ideal) prognostic. Carbo/pacli first-line. PARP inhibitor maintenance for BRCA/HRD. Genetic testing universal. Palliative integration. 5-yr survival 30-40% stage III, 20% stage IV.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 64 ปี postmenopausal × 12 yr มาด้วย bloating + early satiety + weight loss 5 kg × 3 mo + chronic pelvic discomfort

V/S: BP 124/76, HR 88
Gen: thin, ascites + on exam
Pelvic: bilateral fixed adnexal masses 10-12 cm, nodularity in cul-de-sac
US: bilateral complex adnexal masses + ascites + omental thickening
CA-125 850, CEA 12, β-hCG negative
CT C/A/P: bilateral ovarian masses + omental caking + ascites + peritoneal carcinomatosis';

update public.mcq_questions
set choices = '[{"label":"A","text":"Refuse — no treatment available"},{"label":"B","text":"Perimenopausal symptoms management"},{"label":"C","text":"Hysterectomy"},{"label":"D","text":"Antibiotic alone"},{"label":"E","text":"Methotrexate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Perimenopausal symptoms management** — shared decision-making: (1) **vasomotor symptoms (VMS) first-line — Menopausal Hormone Therapy (MHT)** — most effective for VMS; (a) **estrogen + progestin** if intact uterus (combined continuous or cyclic) — oral conjugated equine estrogen or estradiol, transdermal estradiol patch preferred (less VTE/stroke risk); progestin to prevent endometrial hyperplasia (medroxyprogesterone, micronized progesterone — preferred for safer breast profile, dydrogesterone); (b) **estrogen-only** if hysterectomy; (c) start at lowest effective dose, shortest duration; (d) **risks** — VTE (transdermal lower), breast cancer (combined > estrogen-only, time-dependent), stroke; reassess annually; (2) **non-hormonal alternatives** for VMS — SSRIs/SNRIs (paroxetine, venlafaxine, escitalopram), gabapentin, oxybutynin, clonidine, fezolinetant (new NK3 antagonist 2023); (3) **genitourinary syndrome of menopause (GSM)** — **vaginal estrogen** (cream, ring, tablet) — minimal systemic absorption, safe even with progestin-free; vaginal moisturizers + lubricants; ospemifene (SERM); DHEA vaginal; (4) **bone health** — DEXA at 65 (or earlier if risk), calcium + vit D, weight-bearing exercise; bisphosphonate / denosumab if osteoporosis; (5) **CV risk** — manage HT, lipids, DM, smoking; (6) **sleep, mood, libido** — CBT, mindfulness, exercise; (7) **counseling** — reassess MHT every 1-2 yr; menopause average age 51 Thai; risks/benefits individualized; (8) **contraindications MHT** — breast/endometrial cancer, undiagnosed bleeding, VTE history, recent MI/stroke, liver disease, severe migraine with aura, smoker > 35; (9) **WHI study reinterpretation** — risk-benefit balance more favorable in younger women within 10 yr of menopause

---

MHT for VMS — most effective. Transdermal lower VTE. Combined if uterus intact (progestin protect endometrium). Vaginal estrogen for GSM (safe). Non-hormonal: SSRI/SNRI, gabapentin, fezolinetant. Bone: Ca/vitD, DEXA, bisphosphonate. Individualized risk-benefit. WHI early initiation < 60/within 10 yr more favorable.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 47 ปี perimenopausal มาด้วยอาการ vasomotor (hot flashes 8/d, night sweats), poor sleep, mood lability, vaginal dryness + dyspareunia + decreased libido × 1 yr, last menses 8 mo ago

V/S: BP 124/78, HR 80
Gen: no breast mass, normal pelvic
Lab: FSH 78, estradiol 12, TSH normal, lipid + glucose normal
No history of CV disease, breast cancer, VTE, stroke, liver disease';

update public.mcq_questions
set choices = '[{"label":"A","text":"Refuse — discuss only adoption"},{"label":"B","text":"Medical Abortion < 12 weeks"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Methotrexate-only abortion"},{"label":"E","text":"Wait until 20 wk"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Medical Abortion < 12 weeks** (Thai legal framework after 2021 Constitutional Court + Criminal Code amendment — abortion legal up to 12 wk on request, 13-20 wk with conditions, > 20 wk only medical indications): (1) **counseling** — confirm voluntary decision, explore options (continue + parent, adoption, terminate), informed consent, future contraception; (2) **regimen — Mifepristone + Misoprostol** (gold standard, WHO/FIGO/SOMS/RTCOG): (a) **mifepristone 200 mg PO** day 1 (anti-progesterone); (b) **misoprostol 800 mcg buccal/sublingual/vaginal** 24-48 hr later (PG); (3) **misoprostol-only regimen** ถ้า mife not available (Thailand had limited access — improving) — misoprostol 800 mcg PV/SL q 3 hr × up to 3 doses; (4) success ~ 95-98% combined regimen, ~ 85% miso-only; (5) **expected** — cramping + bleeding within hours; expulsion within 24-48 hr; (6) **follow-up** — US or β-hCG 1-2 wk to confirm complete; declining β-hCG > 80% or empty uterus on US; (7) **complications** (rare) — incomplete (~ 2-5%, may need vacuum aspiration), hemorrhage, infection, continuing pregnancy; (8) **Rh-Ig** ถ้า Rh-negative; (9) **post-abortion contraception** — IUD or implant immediately, COCP, DMPA — return to fertility immediate; (10) **emotional support** + counseling; (11) **surgical alternative** — vacuum aspiration (manual MVA or electric EVA) — fast, > 99% effective, requires clinic; (12) Thailand: 1663 abortion hotline, RSA network for referrals; (13) **NEVER** unsafe methods (unregulated drugs, abdominal injury) — counsel safe options

---

Thai law 2021: abortion legal < 12 wk on request, 13-20 wk with conditions. Mife + miso gold standard, > 95% efficacy. Miso-only alternative. Rh-Ig. Immediate contraception. Counseling + follow-up. Safe abortion access reduces maternal mortality. RSA Thailand referral network.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 32 ปี มา OPD ขอ medical termination of pregnancy — GA 7 wk LMP, confirmed IUP US (gestational sac + yolk sac + early embryo + FH), uncomplicated, legally eligible per Thai law 2021 amendment (TOP < 12 wk on request)

V/S: BP 116/72, HR 80
Gen: well
Lab: β-hCG 28,000, Hb 12.4, blood group A Rh+
No contraindication (no allergy, no IUD, no ectopic, no anticoag, no severe anemia, no chronic adrenal failure, no porphyria)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Placenta produces only progesterone"},{"label":"B","text":"Placental hormone physiology"},{"label":"C","text":"hCG doubles q 24 hr in viable IUP"},{"label":"D","text":"Progesterone causes uterine contraction"},{"label":"E","text":"hPL increases insulin sensitivity"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Placental hormone physiology: (1) **hCG** — produced by syncytiotrophoblast from implantation; peaks 9-10 wk (~100,000), then declines to plateau; **functions** — maintains corpus luteum → progesterone (until placenta takes over ~ 8-10 wk); stimulates fetal Leydig → testosterone (male sex differentiation); thyrotropic (cross-reacts TSH-R — transient hyperthyroidism in HEG/mole); doubles q 48-72 hr in early viable IUP; (2) **hPL (human Placental Lactogen)** = chorionic somatomammotropin — produced by syncytiotrophoblast from week 5, rises throughout pregnancy; **functions** — anti-insulin (maternal insulin resistance → ensures fetal glucose supply — also drives GDM); lipolysis (free fatty acids for maternal energy); mammary development; (3) **progesterone** — corpus luteum early then placenta takes over (8-10 wk = luteo-placental shift); maintains pregnancy (endometrium decidualization, uterine quiescence — ↓ contractility, immune tolerance, prevents lactation); produced from maternal cholesterol; (4) **estrogen (estriol E3)** — fetoplacental unit (DHEAS from fetal adrenal → fetal liver 16α-hydroxylation → placenta aromatase → E3); marker of fetal well-being (low in fetal demise, anencephaly); promotes uteroplacental blood flow, breast development; (5) **CRH** — placental CRH ↑ near term → triggers labor cascade (cortisol, prostaglandins); (6) **relaxin** — corpus luteum + placenta; ligament softening (esp pelvic), cervical ripening; (7) **prostaglandins** — local action, labor initiation; (8) interpretation — declining hCG = nonviable; very high = mole, multifetal; rising hPL = placental sufficiency

---

Placental hormones: hCG (maintains CL early; peak 10 wk; cross-reacts TSH), hPL (insulin resistance, lipolysis, GDM mechanism), progesterone (luteo-placental shift 8-10 wk; uterine quiescence), estrogen (fetoplacental unit, E3 marker), CRH (labor), relaxin (cervical ripening). Diagnostic interpretation: doubling hCG q 48 hr, declining = nonviable.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Resident ถามอาจารย์เรื่อง placental physiology + hormones — hCG/hPL/estrogen/progesterone roles';

update public.mcq_questions
set choices = '[{"label":"A","text":"Prolactin causes ejection of milk"},{"label":"B","text":"Lactogenesis II"},{"label":"C","text":"Prolactin causes uterine contraction"},{"label":"D","text":"Oxytocin produces milk"},{"label":"E","text":"Lactation stops with first menses"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Lactation physiology: (1) **mammary development** — estrogen (ductal proliferation), progesterone (lobuloalveolar), prolactin, hPL, cortisol, insulin during pregnancy; (2) **lactogenesis stages**: (a) **Lactogenesis I** — late pregnancy, colostrum production begins (IgA, IgG, leukocytes, growth factors), inhibited by high progesterone; (b) **Lactogenesis II** — abrupt fall in progesterone with placental delivery (within 30-72 hr postpartum) → milk production initiated; delayed in DM, obesity, retained placenta, stress, C/S; (c) **Lactogenesis III (galactopoiesis)** — maintenance, autocrine control by demand-supply (Feedback Inhibitor of Lactation — FIL); (3) **prolactin** — anterior pituitary lactotrophs; **production of milk**; suppresses GnRH (lactational amenorrhea/contraception — LAM 98% effective < 6 mo + amenorrhea + exclusive breastfeeding); levels stimulated by suckling (neural reflex); (4) **oxytocin** — posterior pituitary; **let-down (milk ejection)** — contraction of myoepithelial cells around alveoli + smooth muscle of ducts; uterine contraction (involution); stimulated by suckling, conditioned by infant cry/sight; (5) **milk composition** — colostrum (high IgA, protein), transitional, mature (lactose, fat, protein, immune factors); (6) **benefits** — infant (immunity, gut maturation, ↓ infections, ↓ SIDS, ↓ atopic, neurocognitive), maternal (↓ PPH involution, ↓ breast/ovarian cancer, ↓ DM, weight loss, bonding); (7) **WHO recommendation** — exclusive 6 mo + continued to 2 yr; (8) **medications + lactation** — most safe; LactMed reference; (9) Thai context: rooming-in, BFHI baby-friendly initiative

---

Lactation: lactogenesis I-III. Prolactin (production), oxytocin (ejection). Suckling → both. Progesterone drop → onset milk. Autocrine FIL controls supply. LAM contraception. WHO breastfeed 6 mo exclusive + 2 yr. Most meds safe — LactMed.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Resident ถามอาจารย์เรื่อง lactation physiology + hormones';

update public.mcq_questions
set choices = '[{"label":"A","text":"All women have Müllerian agenesis"},{"label":"B","text":"Embryology of female reproductive tract"},{"label":"C","text":"Müllerian ducts develop into testes"},{"label":"D","text":"Bicornuate is the most common Müllerian anomaly"},{"label":"E","text":"Septate uterus cannot be treated"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Embryology of female reproductive tract: (1) **paramesonephric (Müllerian) ducts** — develop in 6th week from coelomic epithelium lateral to mesonephric (Wolffian); regress in male due to **anti-Müllerian hormone (AMH)** from fetal Sertoli cells; (2) **female differentiation (default)** — absence of AMH + absence of testosterone → Müllerian ducts persist + Wolffian regress; (3) **Müllerian development** — fuse caudally to form **uterus, fallopian tubes (cranial unfused), cervix, upper 2/3 vagina**; lower 1/3 vagina + vestibule from urogenital sinus (endoderm); (4) **stages**: (a) organogenesis (separate tubes), (b) fusion (midline), (c) canalization, (d) septum resorption; failure each stage → anomalies; (5) **ASRM/AFS classification of Müllerian anomalies**: I — segmental agenesis (MRKH); II — unicornuate; III — uterus didelphys (complete failure of fusion); IV — bicornuate (partial fusion); V — septate (failure of resorption — **most common** + most surgically treatable + worst OB outcomes if untreated); VI — arcuate; VII — DES-related; (6) **MRKH (Mayer-Rokitansky-Küster-Hauser)** — Müllerian agenesis with normal ovaries + 46XX + normal external genitalia + absent/rudimentary uterus + vaginal agenesis; primary amenorrhea + normal secondary sex characteristics; associated renal anomalies (40%), skeletal; management — vaginal dilation or surgical neovagina + counseling + ART/surrogacy; (7) **DES-exposed daughters** — T-shaped uterus, cervical hood, clear cell adenocarcinoma vagina; (8) **clinical implications** — recurrent pregnancy loss (esp septate — best surgical outcome with hysteroscopic septum resection), preterm birth, malpresentation, infertility; (9) **workup** — 3D US/MRI > HSG > hysteroscopy + laparoscopy; (10) **renal US** mandatory (associated anomalies)

---

Müllerian anomalies — ASRM classification I-VII. Septate most common + surgically treatable (hysteroscopic resection). MRKH = Müllerian agenesis. Renal anomalies associated 40% — always image kidneys. Workup 3D US/MRI. Clinical: RPL, preterm, malpresentation, infertility.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Resident ถามอาจารย์เรื่อง embryology — Müllerian + Wolffian duct + congenital anomalies';

update public.mcq_questions
set choices = '[{"label":"A","text":"Amniocentesis at 8 weeks"},{"label":"B","text":"Aneuploidy screening + diagnosis"},{"label":"C","text":"Quad screen at 30 weeks"},{"label":"D","text":"NIPT cannot detect sex chromosome"},{"label":"E","text":"CVS preferred 30 weeks"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Aneuploidy screening + diagnosis: (1) **screening** (probabilistic, no risk to fetus) — (a) **First-trimester combined** 11-13+6 wk — NT + PAPP-A + free β-hCG → risk for T21, T18, T13 (detection 85%, FPR 5%); (b) **Second-trimester quad screen** 15-22 wk — AFP, hCG, uE3, inhibin A (detection T21 ~80%); (c) **Integrated/sequential** — combines first + quad; (d) **Cell-free DNA (NIPT)** from 10 wk — analyzes placental DNA in maternal blood — detection T21 > 99%, T18/T13 ~ 98%, sex chromosome aneuploidy; can detect microdeletions but lower performance; available all maternal ages now (USPSTF); confirmatory invasive testing for positives (5% false positive); (2) **soft markers on US** — nuchal thickness, absent nasal bone, echogenic intracardiac focus, echogenic bowel, choroid plexus cyst, single umbilical artery — modify risk; (3) **definitive (diagnostic) — invasive**: (a) **CVS** 11-13+6 wk — transabdominal or transcervical, sample chorionic villi → karyotype + microarray; risk 0.2% loss; mosaicism issue (placental vs fetal); (b) **amniocentesis** 15+ wk — sample amniotic fluid → karyotype, microarray (chromosomal microarray CMA preferred — detects copy number variants), FISH (rapid 24-72 hr for common aneuploidy), AFAFP for NTD; risk 0.1-0.3% loss; (4) **counseling pre-test** — risks + limitations + decisional outcomes + alternatives + reproductive choices; (5) **post-positive screen** — confirmatory diagnostic invasive testing; (6) **Thai context** — first-trimester combined widely available; NIPT increasingly accessible; (7) **age cutoff** — historic age 35 = AMA → universal screening offered all (current); (8) **other genetic** — preconception carrier screening (thalassemia, cystic fibrosis, SMA), expanded carrier panels

---

Aneuploidy screening: combined 1st-tri, quad 2nd-tri, NIPT (cffDNA) > 10 wk highest detection. Confirmatory: CVS 11-13 wk, amnio 15+ wk → karyotype/CMA. Universal screening offered all ages. Counseling critical. Thai: combined common, NIPT growing. Preconception carrier screening (Thai: thalassemia).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Resident ถามอาจารย์เรื่อง genetics — aneuploidy screening + diagnosis';

update public.mcq_questions
set choices = '[{"label":"A","text":"Estrogen comes from theca cells"},{"label":"B","text":"Ovarian steroidogenesis (two-cell two-gonadotropin theory)"},{"label":"C","text":"Aromatase converts estrogen to testosterone"},{"label":"D","text":"Granulosa makes androgens"},{"label":"E","text":"LH stimulates granulosa to make estrogen"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Ovarian steroidogenesis (two-cell two-gonadotropin theory): (1) **theca cells** under **LH** stimulation — express LH receptor + steroidogenic enzymes (StAR, CYP11A1, CYP17A1, 3β-HSD); convert cholesterol → pregnenolone → progesterone → 17-OH progesterone → **androstenedione + testosterone** (cannot aromatize — no CYP19); (2) **granulosa cells** under **FSH** stimulation — express FSH receptor + **aromatase (CYP19)**; take theca-derived androgens → **estrone (E1) + estradiol (E2)**; (3) cyclic regulation — see menstrual cycle Q; (4) **dominant follicle** — high estradiol → positive feedback → LH surge → ovulation; corpus luteum makes progesterone primarily; (5) **adrenal steroidogenesis** — fasciculata (cortisol — 17-OH pathway), reticularis (DHEAS — androgens), glomerulosa (aldosterone — 18-hydroxylase); (6) **fetoplacental unit** — placenta lacks 17-hydroxylase + 17,20-lyase + DHEA synthesis → relies on fetal adrenal DHEAS → fetal liver 16α-hydroxylation → placenta aromatase → estriol; (7) **enzyme deficiencies (CAH)** — 21-hydroxylase (most common, salt-wasting, virilization), 11β-hydroxylase (HT, virilization), 17α-hydroxylase (HT, hypogonadism), 3β-HSD; CAH workup — basal + ACTH-stim 17-OHP; (8) **steroid receptors** — ER (α, β), PR (A, B), AR — nuclear receptors, ligand-dependent transcription; ER-α major in uterus, breast, hypothalamus; tissue-specific receptor expression → selective effects; (9) **SERMs** — tamoxifen (breast antagonist, endometrial agonist), raloxifene (breast antagonist, bone agonist), ospemifene (vaginal agonist); (10) **clinical** — letrozole = aromatase inhibitor (ovulation induction); finasteride = 5α-reductase inhibitor; spironolactone = AR antagonist; combination informs management of PCOS, infertility, breast cancer

---

Two-cell two-gonadotropin: theca/LH (androgens) → granulosa/FSH (aromatase → estrogen). Steroid synthesis pathway: cholesterol → preg → prog → androgens → estrogens. CAH enzyme defects. Receptors nuclear. SERMs tissue-selective. AI letrozole. Clinical relevance: PCOS, infertility, oncology.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Resident ถามอาจารย์เรื่อง reproductive endocrinology — sex steroid biosynthesis + steroid receptors';

update public.mcq_questions
set choices = '[{"label":"A","text":"Hide errors from staff"},{"label":"B","text":"OB M&M + SMM review system"},{"label":"C","text":"Blame individual"},{"label":"D","text":"Skip review"},{"label":"E","text":"Only physician review"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** OB M&M + SMM review system: (1) **Severe Maternal Morbidity (SMM)** definition — CDC: 21 indicators (e.g., eclampsia, hysterectomy, mechanical ventilation, ICU admission, blood transfusion ≥ 4 U, AKI, MI, sepsis, shock, cardiac arrest, etc.); review all cases for system + provider opportunities; (2) **Maternal Mortality Review Committee (MMRC)** — state/national level; pregnancy-related death within 1 yr; review cause + preventability + recommendations; (3) **case review process** — (a) identify case via screening (ICD codes, manual flag, audit), (b) abstract chart + interviews, (c) multidisciplinary team review (OB, anesthesia, nursing, midwifery, social work, pathology, leadership, sometimes external), (d) classify preventability + factors (patient, provider, facility, system), (e) identify opportunities for improvement, (f) propose + implement actions, (g) track outcomes; (4) **Just Culture** framework — distinguish human error (console) vs at-risk behavior (coach) vs reckless behavior (discipline); not blame-focused; (5) **psychological safety** — confidential, non-punitive, learning-focused; (6) **action items** — protocol updates, simulation training, equipment, communication tools, escalation pathways, debriefs; (7) **transparency** — share lessons; equity lens (racial/SES disparities); patient/family engagement; (8) **AIM bundles + SMM dashboard** monitor improvement; (9) **second victim support** — providers involved in serious events need psychological support; (10) link to **patient safety + quality improvement + risk management + medical liability** (peer review protection variable by state/country)

---

M&M + SMM review = patient safety standard. CDC 21 SMM indicators. MMRC for mortality. Just Culture. Multidisciplinary. Equity. Second victim support. AIM bundles. Confidential. Action-oriented + tracked outcomes.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Hospital establishes systematic OB Morbidity & Mortality (M&M) conference + Severe Maternal Morbidity (SMM) review';

update public.mcq_questions
set choices = '[{"label":"A","text":"Skip consent in emergency"},{"label":"B","text":"Informed consent for high-risk OB procedures"},{"label":"C","text":"Verbal only without documentation"},{"label":"D","text":"Family decides for adult patient"},{"label":"E","text":"Forced procedure"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Informed consent for high-risk OB procedures: (1) **elements of informed consent** — (a) **capacity** assessment, (b) **disclosure** — nature of procedure, **purpose, alternatives** (including no treatment), **risks** (common + serious — quantified when possible), **benefits**, (c) **comprehension** check (teach-back), (d) **voluntary decision** (no coercion), (e) documentation + signature; (2) **shared decision-making** — partnership of clinician expertise + patient values/preferences; tools: decision aids, video, written materials in patient language; (3) **specific examples**: (a) **TOLAC vs ERCD** — discuss uterine rupture 0.5-1%, success 60-80%, future pregnancy, neonatal outcomes, hospital factors (availability of immediate C/S); (b) **operative vaginal** — vacuum vs forceps, indications, alternatives, neonatal risks (cephalohematoma, subgaleal, brachial plexus), maternal risks (laceration, sphincter injury, hemorrhage); (c) **placenta accreta hysterectomy** — pre-op MDT discussion, blood products, ICU, future fertility loss, urology involvement; (4) **emergency consent** — if life-threatening + patient unable + surrogate unavailable → implied consent for life-saving (document); (5) **language + cultural** — qualified medical interpreter required (not family member for sensitive); cultural humility; (6) **special populations** — minors (assent + parent), pregnant minors (varies by state/country), patients with disabilities; (7) **Thai law + Medical Council** — written consent for surgery, anesthesia; documentation key; (8) **refusal of treatment** — respect autonomy except court-ordered C/S (rare, controversial); (9) **incorporate in advance discussions** during ANC (birth plan, preferences); (10) **continuous process** — not one-time; revisit as condition evolves

---

Informed consent: capacity, disclosure, comprehension, voluntary, documented. Shared decision-making. Specific OB procedures need detailed risk discussion. Interpreters. Decision aids. Emergency: implied consent for life-saving. Continuous process throughout pregnancy. Respect autonomy.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'OB unit develops informed consent process for high-risk procedures (TOLAC, operative vaginal, cesarean hysterectomy in placenta accreta)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Ignore — not our problem"},{"label":"B","text":"Intimate Partner Violence (IPV) screening + response in OB"},{"label":"C","text":"Confront the partner"},{"label":"D","text":"Hide the bruises"},{"label":"E","text":"Ignore the situation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Intimate Partner Violence (IPV) screening + response in OB** — universal screening recommended (USPSTF Grade B, ACOG): (1) **screen all women of reproductive age** at routine visits, including each trimester ANC + postpartum; (2) **private setting** — partner/family NOT present; if partner won''t leave → reschedule or use covert signals; (3) **validated tools** — HITS, WAST, AAS (Abuse Assessment Screen), HARK; ask directly: ''Has your partner ever hurt or threatened you?''; (4) **non-judgmental + supportive** approach; (5) **if positive** — (a) validate (believe + affirm: ''this is not your fault''), (b) assess **immediate safety** (Danger Assessment — weapons, escalation, recent severe violence, strangulation = high lethality), (c) acute injury — treat + document, (d) **safety planning** — code word, escape route, important docs, emergency contacts, shelter, (e) **resources** — Thai hotline 1300 (One Stop Crisis Center), shelters, legal aid, social worker, mental health; (6) **mandatory reporting** varies — Thai law: report child abuse mandatory; IPV not mandatory (respect patient autonomy + safety); (7) **documentation** — photos with consent, body diagrams, exact quotes (medical-legal); (8) **pregnancy-specific risks** — IPV ↑ during pregnancy; ↑ preterm birth, abruption, LBW, depression, fetal injury; (9) **postpartum** — risk persists + may escalate; postpartum depression + IPV bidirectional; (10) **multidisciplinary** — social worker, mental health, advocate; warm handoffs; follow-up next visit; (11) **trauma-informed care** — recognize trauma history, choice + control, peer support; (12) **provider education** + simulation training; safety for staff also

---

IPV screening universal (USPSTF B, ACOG). Private setting, validated tools, supportive. Safety planning + resources. Documentation. Thai 1300 OSCC. Pregnancy ↑ IPV risk. Mandatory reporting child abuse only. Trauma-informed care. Multidisciplinary. Provider education.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงตั้งครรภ์มา ANC พบ bruising patterns + delayed care-seeking — staff sensitive screening for intimate partner violence (IPV)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Stop levothyroxine"},{"label":"B","text":"Hypothyroidism in pregnancy management"},{"label":"C","text":"Reduce levothyroxine 50%"},{"label":"D","text":"Cesarean delivery"},{"label":"E","text":"Methotrexate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hypothyroidism in pregnancy management: (1) **trimester-specific TSH targets** — < 2.5 mIU/L 1st trimester, < 3.0 2nd-3rd (or use lab-specific reference); (2) **immediately ↑ levothyroxine dose by 20-30%** when pregnancy confirmed (Endocrine Society/ATA) — automatic dose adjustment commonly 2 extra doses/week; this patient TSH 4.8 = under-replaced → increase to 125 mcg or by 25-30%; (3) **recheck TSH q 4 wk** until 20 wk, then q 4-6 wk; (4) **why ↑ requirement** — ↑ TBG (estrogen-driven), placental D3 deiodinase, transplacental transfer for fetal brain development (critical first 12 wk before fetal thyroid functions); (5) **timing levothyroxine** — empty stomach, 30-60 min before food, separate from iron/calcium/PPI; (6) **subclinical hypothyroidism** (TSH elevated + FT4 normal) — treat if TPO+ (Hashimoto) or TSH > 10; benefit on obstetric outcomes mixed; (7) **overt hypothyroidism** — clearly treat — associated with miscarriage, preeclampsia, abruption, preterm birth, LBW, fetal neurodevelopmental impairment; (8) **iodine** — 250 mcg/d in pregnancy (Thai dietary salt iodination); (9) **postpartum** — return to pre-pregnancy dose; recheck 6 wk postpartum; **postpartum thyroiditis** — hyperthyroid 1-6 mo then hypo phase then resolution; TPO+ at risk; (10) **TPO Ab+ even with normal TSH** — ↑ miscarriage + preterm + postpartum thyroiditis risk; consider treating subclinical or monitoring; (11) **breastfeeding** — levothyroxine safe; (12) **future pregnancy** — preconception TSH optimization (< 2.5)

---

Hypothyroid pregnancy: ↑ levothyroxine 20-30% on confirmation. Target TSH < 2.5 (1st) / < 3.0 (2nd-3rd). Recheck q 4 wk. Untreated → miscarriage, PE, neurodevelopment. TPO+ ↑ risk. Postpartum return to baseline dose + 6 wk check. Postpartum thyroiditis. Iodine 250 mcg.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 28 ปี G1P0 GA 16 wk underlying hypothyroidism — was on levothyroxine 100 mcg/d pre-pregnancy, last TSH 4.8 (elevated)

V/S: BP 116/74, HR 80
Gen: well, mild fatigue
Fetal: heart 152, growth appropriate
Lab: TSH 4.8 (trimester-specific upper limit < 2.5 1st trimester, < 3.0 2nd-3rd), FT4 low-normal, TPO Ab positive (Hashimoto)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Reassurance only — stress is normal"},{"label":"B","text":"Severe MDD in pregnancy with suicidal ideation — multidisciplinary perinatal mental health care"},{"label":"C","text":"Refuse all medication during pregnancy"},{"label":"D","text":"Cesarean immediately"},{"label":"E","text":"Stop all care + counseling"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe MDD in pregnancy with suicidal ideation — multidisciplinary perinatal mental health care: (1) **safety first** — assess suicide risk (SAD PERSONS, ideation/plan/intent/means); active SI = psychiatric emergency → **psychiatric consultation immediately**; consider voluntary admission for safety + treatment initiation; (2) **risk-benefit of treatment** — untreated severe depression → preterm birth, LBW, preeclampsia, GDM, postpartum depression, suicide, infant neurodevelopmental impact; vs medication risks; (3) **SSRI safe in pregnancy** — sertraline first-line (low transfer, evidence safe in pregnancy + lactation); escitalopram, citalopram also reasonable; **AVOID paroxetine** (cardiac defects ~ 2× baseline — small absolute increase) — relative; fluoxetine OK but long half-life (transfer to fetus/breastmilk); (4) **considerations** — late-pregnancy SSRI → poor neonatal adaptation syndrome (transient, supportive care), small ↑ PPHN risk (rare); benefit usually outweighs; (5) **psychotherapy** — CBT, IPT (interpersonal — strong evidence perinatal) — first-line for mild-moderate, adjunct severe; (6) **ECT** — safe + effective in severe perinatal depression refractory to/intolerant of medication; (7) **lifestyle** — exercise, sleep, nutrition, social support; (8) **screening** — Edinburgh Postnatal Depression Scale (EPDS), PHQ-9 at every visit antepartum + postpartum × 1 yr; (9) **postpartum planning** — relapse risk high in postpartum; continue medication; psychotherapy + peer support; lactation — sertraline preferred (low milk transfer); (10) **psychiatric emergency** support: Thai 1323 mental health hotline, ER psychiatry; (11) **multidisciplinary team** — OB, psych, social worker, pediatrics, lactation; (12) **partner involvement** + family support; (13) **trauma-informed**; (14) **suicide** = leading cause of maternal death in some HIC

---

Perinatal depression: untreated severe → adverse outcomes including suicide (leading cause). Sertraline first-line. Avoid paroxetine. CBT/IPT psychotherapy. ECT safe in pregnancy. EPDS/PHQ-9 screening. Postpartum relapse risk. Multidisciplinary. Suicide screen + emergency care. Breastfeeding safe with sertraline.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 32 ปี G1P0 GA 28 wk underlying severe major depressive disorder + suicidal ideation 1 wk — on no medication (stopped fluoxetine when pregnancy known)

V/S: BP 118/72, HR 88
Gen: tearful, psychomotor retardation, expressed hopelessness, denies plan but has thoughts of self-harm
Fetal: heart 144 reactive, growth appropriate
No psychotic features, no substance use, supportive partner';

update public.mcq_questions
set choices = '[{"label":"A","text":"Just oxytocin + observe"},{"label":"B","text":"genital tract trauma"},{"label":"C","text":"Hysterectomy"},{"label":"D","text":"Discharge home without repair"},{"label":"E","text":"Methotrexate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** PPH from **genital tract trauma** (T = Trauma in 4 T''s of PPH): (1) systematic exam under good lighting + adequate analgesia/anesthesia — assess cervix, vaginal walls, perineum (4 degrees), periurethral; (2) **identify + repair sources** — cervical lacerations (sponge stick traction, suture if bleeding/> 1 cm), vaginal walls (running interlocking absorbable), perineal — repair in layers; (3) **4° laceration repair** — multidisciplinary (colorectal/urology if available, OB skilled): (a) **rectal mucosa** — interrupted or continuous fine absorbable (4-0 polyglactin/PDS), submucosal, knots away from lumen; (b) **internal anal sphincter** — separate repair (figure-of-8 or end-to-end with delayed absorbable); (c) **external anal sphincter** — overlapping or end-to-end with 2-0 PDS; (d) perineal body + vaginal mucosa + skin; (4) **antibiotics** — single dose cefazolin pre-repair (reduces wound complications); (5) **stool softeners + sitz bath** + analgesia + avoid constipation 6 wk; (6) **follow-up** — pelvic floor physical therapy, anal incontinence assessment 6 wk + 3-6 mo (manometry/endoanal US ถ้า symptoms); (7) **future delivery** — counsel risk recurrence ~ 7-15%; option C/S vs vaginal individualized; (8) hemodynamic resuscitation — IV fluid, blood products as needed; ongoing PPH protocol; (9) **document** — degree, repair technique, antibiotic, plan

---

OASIS (Obstetric Anal Sphincter Injury) — 4° = full thickness through rectal mucosa. Repair layered + antibiotic prophylaxis + stool softener + PFPT + follow-up incontinence assessment. Future delivery counseling. Vacuum/forceps + episiotomy + macrosomia + nulliparous = risk factors.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 24 ปี G1P1 NSD 30 นาที, episiotomy + vacuum extraction. Bleeding 1.2 L, uterus contracted firm, placenta complete

V/S: BP 96/58, HR 116
Perineum exam: 4° laceration extending through anal sphincter + rectal mucosa
Uterus: firm, fundus at umbilicus, no atony
Bleeding from vaginal vault + cervix';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue vaginal delivery"},{"label":"B","text":"Vasa Previa rupture"},{"label":"C","text":"Tocolysis"},{"label":"D","text":"Discharge home — observation"},{"label":"E","text":"Wait for natural delivery"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Vasa Previa rupture** (fetal vessels crossing or within 2 cm of internal os, unsupported by placenta or cord — ruptures with membranes → fetal exsanguination, fetal mortality > 50-95% if not recognized; risk: velamentous cord insertion, succenturiate/bilobed placenta, multifetal, IVF): (1) **emergency cesarean delivery** — fetal blood loss = imminent demise (small fetal blood volume ~ 80-90 mL/kg); decision-to-incision < 10 min; (2) **neonatal resuscitation team** ready — transfusion (O-negative emergency blood, type-specific ASAP); cord blood gas; (3) **prevention** — antenatal diagnosis on US (transvaginal Doppler — color flow over os) → planned admission at 30-34 wk, **antenatal corticosteroids 28-32 wk**, scheduled C/S 34-37 wk before ROM; (4) Apt test (HbF) — can confirm fetal blood (alkali-resistant) if doubt; (5) **post-delivery** — neonatal ICU care + transfusion; (6) **outcomes** — with antenatal dx + planned C/S → survival > 95%; without dx → mortality very high; (7) document + risk management; counsel future pregnancies + early US

---

Vasa previa: fetal vessels over cervical os. Rupture = fetal exsanguination. Antenatal diagnosis (transvaginal color Doppler) → planned C/S 34-37 wk = > 95% survival. Without dx = catastrophic. Risk: velamentous cord, succenturiate lobe, IVF. Emergency C/S < 10 min.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงตั้งครรภ์ G1P0 GA 38 wk SROM ที่บ้าน — sudden painless heavy bright red bleeding ทันที + fetal bradycardia within minutes

V/S: BP 100/68, HR 110
Fetal: FHR 65 bradycardia
US done in prenatal — velamentous cord insertion + vessels crossing internal os (vasa previa) — was identified ANC at 30 wk but mother went into labor unexpectedly';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue routine ANC"},{"label":"B","text":"Twin-to-Twin Transfusion Syndrome (TTTS)"},{"label":"C","text":"Cesarean immediately at 22 wk"},{"label":"D","text":"Terminate both twins"},{"label":"E","text":"Discharge home"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Twin-to-Twin Transfusion Syndrome (TTTS)** — Quintero stage II (donor with no bladder, but normal Doppler) — in MCDA pregnancy only (shared placental vascular anastomoses): donor → recipient through unbalanced AV anastomoses → recipient polyhydramnios + bladder distention + ↑ cardiac volume; donor oligohydramnios + small bladder + IUGR; (1) **refer fetal therapy center**; (2) **Quintero staging** — I (oligo/poly + visible donor bladder); II (no visible donor bladder); III (abnormal Doppler — UA AEDV/REDV, DV reversal); IV (hydrops); V (demise); (3) **treatment — fetoscopic laser photocoagulation** of placental vascular anastomoses (Solomon technique — equator dichorionizing) — gold standard for stage II-IV at 16-26 wk; survival of at least 1 twin ~ 85%, both ~ 70%; superior to amnioreduction (Eurofoetus trial); (4) **amnioreduction** (large-volume) — alternative for early/late or refractory; (5) **selective reduction** (radiofrequency, bipolar cord coagulation) — single twin demise ถ้า one severely compromised; (6) **expectant** — observation late presentation > 26 wk + planned early delivery; (7) **antenatal corticosteroids** if preterm delivery anticipated; (8) **post-laser** — serial US (TAPS — twin anemia-polycythemia sequence; recurrent TTTS), MCA Doppler, growth, BPP; (9) **co-twin demise** — surviving twin risk neurologic injury (15-25%) + death from acute exsanguination through anastomoses; brain MRI follow-up; (10) **delivery** — typically 34-37 wk for MCDA TTTS treated; (11) counsel: complex, fetal therapy referral promptly

---

TTTS in MCDA twins. Quintero staging I-V. Fetoscopic laser ablation = standard 16-26 wk (Eurofoetus). Post-treatment: TAPS, recurrence, surviving twin neuro risk if co-twin demise. Antenatal dichorionic vs monochorionic critical — different management. Delivery 34-37 wk MCDA.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงตั้งครรภ์ GA 22 wk twin pregnancy MCDA (monochorionic-diamniotic) — routine US shows twin A polyhydramnios (DVP 9 cm, AFI 28) + twin B oligohydramnios (DVP 1.5 cm, ''stuck twin''), Twin A bladder visible distended, Twin B bladder not visible, both alive

V/S: BP 118/74, HR 88
Fetal: both alive, FHR Twin A 148, Twin B 152
Doppler: Twin B umbilical artery normal flow';

update public.mcq_questions
set choices = '[{"label":"A","text":"Suction trachea aggressively first"},{"label":"B","text":"Neonatal resuscitation (NRP 8e — Thai/AAP/AHA)"},{"label":"C","text":"Discharge to nursery"},{"label":"D","text":"Wait for spontaneous breathing 10 min"},{"label":"E","text":"Continue stimulation only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neonatal resuscitation (NRP 8e — Thai/AAP/AHA): (1) **initial rapid assessment** — term? tone? breathing/crying? — if YES routine, if NO → resuscitation; (2) **Golden Minute** — warm, dry, stimulate, position airway, suction only if obstructing (no longer routine for MSAF non-vigorous per NRP 8e — 2020 change); (3) **assess HR + respirations** at 30 sec; **HR < 100 or apnea/gasping → PPV** with bag-mask 21% O2 (term), 30 breaths/min, 20-25 cm H2O initial PIP — MR SOPA if not effective (Mask, Reposition, Suction, Open mouth, Pressure ↑, Alternative airway); (4) **HR < 60 despite effective PPV × 30 sec → intubate + chest compressions** 3:1 ratio (90 compressions + 30 breaths/min), 100% O2, depth 1/3 AP chest; (5) **HR still < 60 after 60 sec compressions + PPV → IV access** umbilical vein + **epinephrine** 0.01-0.03 mg/kg (1:10,000) IV or 0.05-0.1 mg/kg ETT every 3-5 min; **volume** (NS 10 mL/kg) if blood loss; (6) **MSAF non-vigorous** — initiate PPV at 1 min if not breathing (do not routinely suction trachea — NRP 8e changed); intubation + tracheal suction only if airway obstructed; (7) **post-resuscitation** — therapeutic hypothermia 33-34°C × 72 hr for moderate-severe HIE (GA ≥ 36 wk, criteria met) — neuroprotection; (8) **document** Apgar 1, 5, 10 min + resuscitative actions + interventions; (9) family update + transfer NICU; (10) debrief team

---

NRP 8e Golden Minute. Initial: warm/dry/stimulate. PPV if apnea/HR<100. Compressions + PPV if HR<60. Intubate + epi if persistent. MSAF non-vigorous: PPV not routine tracheal suction (NRP 8e change). Therapeutic hypothermia for HIE (≥ 36 wk, criteria). Apgar + cord blood gas document.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงตั้งครรภ์ G1P0 GA 39 wk NSD with thick meconium-stained fluid — depressed neonate at delivery, HR 60, no respiratory effort, limp, no cry

Maternal V/S: BP 122/76, HR 92 stable
Fetal: just delivered, Apgar 1 min: 1 (HR < 100, no respiration, limp, no reflex, blue)
Cord blood gas pH 6.95, base deficit 16';

update public.mcq_questions
set choices = '[{"label":"A","text":"Forceps delivery at 4 cm"},{"label":"B","text":"Suspected fetal macrosomia (EFW ≥ 4,000-4,500 g) management"},{"label":"C","text":"Cesarean immediately"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Methotrexate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Suspected fetal macrosomia (EFW ≥ 4,000-4,500 g) management: (1) **caveats** — US EFW imprecise (±10-15% error), tends to over-estimate at term; clinical exam (Leopold) also imprecise; (2) **C/S consideration**: (a) **EFW > 5,000 g in non-diabetic** OR **> 4,500 g in diabetic** → ACOG suggests offering elective C/S (shoulder dystocia + brachial plexus risk); (b) **prior shoulder dystocia + macrosomia** → individualized; (3) this patient EFW 4,500 + GDM well-controlled, no prior dystocia → **shared decision**; reasonable trial of labor with: (4) **anticipatory planning**: (a) experienced operator + L&R team aware, (b) extra personnel available (anesthesia, additional OB, pediatric resuscitation), (c) bed at low height for McRoberts, (d) review HELPERR algorithm; (5) **labor progress** — adequately monitor, recognize protraction/arrest disorders; (6) **operative vaginal delivery cautious** — vacuum + macrosomia + protracted 2nd stage = ↑ dystocia risk; (7) **2nd stage** — controlled delivery of head, immediate assessment for shoulder dystocia (turtle sign), HELPERR ready; (8) **postpartum** — NICU eval (hypoglycemia, polycythemia, jaundice, RDS); maternal — PPH risk (overdistended uterus), 3-4° laceration risk; (9) **counsel patient** — risks both routes, individualized decision; (10) future pregnancies: GDM screening, weight management

---

Macrosomia: EFW ≥ 4,000 (non-DM) / ≥ 4,500 (DM). US imprecise. C/S offer: > 5,000 non-DM or > 4,500 DM. Otherwise trial of labor with anticipatory shoulder dystocia preparation. Limit operative vaginal. NICU eval newborn. Shared decision counseling.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 32 ปี G2P1 GA 38 wk in labor, dilation 4 cm. Suspect macrosomia — fundal height 41 cm, EFW 4,500 g on US, GDM well-controlled

V/S: BP 120/74, HR 86
Fetal: FHR 140 reassuring
No prior shoulder dystocia, normal pelvis exam';

update public.mcq_questions
set choices = '[{"label":"A","text":"Cesarean immediately"},{"label":"B","text":"External Cephalic Version (ECV)"},{"label":"C","text":"Vaginal breech delivery without consent"},{"label":"D","text":"Discharge home for spontaneous version"},{"label":"E","text":"Methotrexate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **External Cephalic Version (ECV)** for breech at term (≥ 36-37 wk): (1) **criteria** — singleton breech ≥ 37 wk, no contraindication (no previa, no abruption, no fetal anomaly preventing version, no severe FGR/abnormal CTG, no oligohydramnios/PPROM, no multifetal, no uterine anomaly, no nuchal cord seen, mother stable, fetus reactive); (2) **pre-procedure** — confirm presentation US, NST reactive, IV access, type & screen, consent; (3) **tocolysis** — terbutaline 0.25 mg SC (most evidence), nifedipine, NTG to ↑ success; (4) **regional anesthesia** (epidural/spinal) may ↑ success + maternal comfort (controversial benefit, may use selectively); (5) **technique** — forward roll preferred; gentle continuous pressure; ≤ 2 attempts; ultrasound guidance; (6) **success rate** ~ 60% (lower if anterior placenta, nullip, low EFW, deep engagement); ~ 50% deliver vaginally cephalic after ECV; (7) **monitor post-ECV** — CTG 30-60 min, ensure reassuring; rule out abruption + fetal distress; (8) **complications** — transient FHR abnormality (most), abruption (rare), PPROM, FMH (give **Anti-D 300 mcg if Rh-negative**), emergent C/S need; (9) **fail** → schedule C/S vs repeat trial vs vaginal breech if criteria met (skilled provider, frank breech, head not hyperextended, EFW 2,500-4,000); (10) outpatient ECV vs admit per institution; (11) Thai context — ECV underutilized; promote training

---

Breech 3-4% at term. ECV at 37 wk → success ~ 60% → reduces C/S. Criteria + contraindications. Tocolysis. Monitor post-ECV. Anti-D if Rh-neg. PROBE/Term Breech Trial established C/S for breech as safer but ECV reduces need. Vaginal breech selective + skilled.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงตั้งครรภ์ G1P0 GA 37 wk fetus breech presentation (frank breech) — multiparous, no contraindication to ECV

V/S: BP 116/72, HR 78
Fetal: FHR 144, EFW 2,800 g, AFI normal, placenta posterior fundal (not previa)
No abruption, no prior C/S, no anomaly, no oligohydramnios, no labor';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge — no action needed"},{"label":"B","text":"Severe hypertension in pregnancy without preeclampsia features (chronic HT severe range BP ≥ 160/110) — urgent BP control to prevent stroke while continuing to investigate"},{"label":"C","text":"Wait until 40 wk"},{"label":"D","text":"Cesarean immediately"},{"label":"E","text":"Aspirin alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Severe hypertension in pregnancy without preeclampsia features (chronic HT severe range BP ≥ 160/110) — **urgent BP control to prevent stroke** while continuing to investigate: (1) **measure BP × 15 min apart** to confirm persistence; (2) **acute treatment for severe-range BP within 30-60 min** (AIM bundle): (a) **IV labetalol** 20 mg → if no response 10 min → 40 mg → 80 mg → 80 mg (max 220-300 mg) — avoid in asthma, CHF, bradycardia; (b) **IV hydralazine** 5-10 mg → repeat 20-40 min → max 30 mg — SE reflex tachy, headache; (c) **oral nifedipine immediate-release** 10-20 mg → repeat 20-30 min — alternative oral if no IV; (3) **target BP** — < 140-150 / 90-100 (don''t over-correct → placental hypoperfusion); (4) **rule out preeclampsia** — repeat urine protein/Cr, LFT, plt, Cr, LDH, uric acid; symptom review; (5) ongoing antihypertensive: labetalol, nifedipine ER, methyldopa (avoid ACEI/ARB, atenolol); CHAP trial supports target < 140/90; (6) **MgSO4** ถ้า any features of severe preeclampsia (HELLP, cerebral/visual, RUQ, pulm edema); (7) **fetal surveillance** — NST/BPP, serial growth; (8) **delivery indication** — uncontrolled severe HT, end-organ damage, preeclampsia features → deliver ≥ 34 wk; (9) **debrief** + safety bundle compliance; (10) follow-up postpartum (rebound HT)

---

Severe-range BP in pregnancy (≥ 160/110) → urgent treatment within 30-60 min to prevent stroke (leading cause of maternal mortality from HTN). IV labetalol/hydralazine or oral nifedipine. CHAP trial < 140/90. Rule out preeclampsia. MgSO4 if severe features. AIM bundle compliance.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงตั้งครรภ์ GA 32 wk underlying chronic HT มา ANC — current BP 158/106 outpatient, no proteinuria, no symptoms

V/S: BP 158/106, HR 90, RR 18
Fetal: FHR 144 reactive, EFW 1,650 g (50th), AFI normal
Lab: Cr 0.7, plt 240K, AST/ALT WNL, uric acid 4.2, urine protein/Cr 0.18 (negative for preeclampsia)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge home with ANC referral"},{"label":"B","text":"complete preeclampsia workup"},{"label":"C","text":"Cesarean immediately"},{"label":"D","text":"Tocolysis to delay"},{"label":"E","text":"Outpatient observation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Late presentation severe preeclampsia + FGR — comprehensive admit: (1) immediate **stabilization** — BP control (IV labetalol/hydralazine), MgSO4 seizure prophylaxis 4-6 g load + 1-2 g/hr; (2) **complete preeclampsia workup** — CBC, CMP (Cr, LFT), uric acid, LDH, peripheral smear (schistocytes), urine protein/Cr or 24-hr, coag; (3) **fetal evaluation** — detailed US (anomaly missed, EFW, AFI), Doppler (umbilical, MCA), NST, BPP; ANC missed = unknown anomalies, growth, dating; (4) **antenatal steroids** betamethasone 12 mg IM × 2 doses 24 hr apart (late preterm 34-37 wk benefit per ALPS trial); GA 36 = borderline benefit + risk hypoglycemia neonate; (5) **delivery timing** — severe preeclampsia at 34+0 wk → **deliver after stabilization** (no need to wait for steroids if maternal/fetal instability; ALPS for 34-36+6 elective); (6) **mode** — vaginal preferred if favorable cervix + stable; cervical ripening with Foley/PG; oxytocin; C/S for usual obstetric indication; continuous EFM; (7) **postpartum** — MgSO4 24 hr, BP monitoring, may need antihypertensive 6-12 wk; PE labs may worsen 48 hr postpartum; (8) social work + WCC/social determinants — late presentation often = SES/access barriers; education + support + transition care; (9) Anti-D if Rh-neg + bleeding; (10) postpartum contraception + future pregnancy aspirin

---

Late ANC + severe preeclampsia + FGR: stabilize, workup, deliver. Steroids ALPS for late preterm. Severe PE at 34+0 deliver. Social determinants → SBIRT, social work, equity. Postpartum surveillance. Future pregnancy aspirin. Universal screening + early access addresses equity.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงตั้งครรภ์ G2P1 GA 36 wk previously healthy มา OPD — first ANC อยู่ไกล, มาด้วยอาการเหนื่อยง่าย + เท้าบวม + ปวดศีรษะ 1 สัปดาห์, no prior care

V/S: BP 168/110, HR 92, RR 18
Gen: +2 edema legs + face, hyperreflexia 3+
Fetal: FHR 144 reactive, fundal height 33 cm (small for GA 36)
Lab pending: STAT — plt 95K, AST 120, Cr 1.0, urine 3+ protein, uric acid 7.8, HBs Ag negative, VDRL non-reactive, HIV negative';

update public.mcq_questions
set choices = '[{"label":"A","text":"No treatment needed"},{"label":"B","text":"Syphilis in pregnancy management (Treponema pallidum — congenital syphilis prevention)"},{"label":"C","text":"Doxycycline"},{"label":"D","text":"Discharge — wait until delivery"},{"label":"E","text":"Methotrexate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Syphilis in pregnancy management (Treponema pallidum — congenital syphilis prevention): (1) **diagnosis** — confirmed (RPR/VDRL + treponemal FTA-ABS or TP-PA positive); titer 1:64 = active; stage by clinical + serology — likely early latent (< 1 yr) or late latent (unknown duration → treat as late); (2) **treatment**: (a) **early latent (< 1 yr) — Benzathine Penicillin G 2.4 million U IM single dose**; (b) **late latent or unknown duration — Benzathine Penicillin G 2.4 million U IM × 3 doses 1 wk apart** (total 7.2 million U); (3) **penicillin allergy** — **desensitization required** (penicillin only proven prevention of congenital syphilis — no alternative in pregnancy; doxycycline contraindicated, erythromycin doesn''t cross placenta well); inpatient desensitization protocol then PCN treatment; (4) **Jarisch-Herxheimer reaction** — fever/chills/uterine contractions after first dose (~ 6-12 hr) — monitor + supportive (acetaminophen); rare preterm labor; (5) **partner notification + treatment** — contact tracing essential (Thai DDC, anonymous partner services); (6) **follow-up** — quantitative non-treponemal titer (RPR/VDRL) at 3, 6, 12 mo expecting 4-fold ↓; if no decline → re-evaluate (HIV, persistent, reinfection); (7) **fetal evaluation** — US for stigmata (hepatomegaly, ascites, hydrops, placentomegaly); (8) **neonatal evaluation** — IgM, exam, dark-field of lesions, LP, long bone X-ray, CBC, CSF VDRL; treat per CDC criteria; (9) **HIV + co-infection screening** mandatory; other STIs (GC, CT, HBV, HCV); (10) **prevention** — universal first trimester + 28 wk + delivery screening in Thai/CDC high-risk areas; condoms; education

---

Syphilis in pregnancy: BPG only proven prevention congenital syphilis. PCN allergy → desensitize. Stage to determine dose. Partner notification. Follow-up titer 4-fold ↓ at 6-12 mo. Newborn eval + treatment. Universal screening 1st trimester + 28 wk + delivery (Thai). Co-infection HIV.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 25 ปี G2P1 GA 16 wk first ANC — Lab returned: VDRL positive 1:64, FTA-ABS positive, no symptoms, no prior history of syphilis or treatment

V/S: BP 118/72, HR 80
Gen: well, no rash, no chancre
Partner status unknown';

update public.mcq_questions
set choices = '[{"label":"A","text":"Allow vaginal delivery"},{"label":"B","text":"Genital HSV with active outbreak in labor → Cesarean delivery"},{"label":"C","text":"Forceps delivery"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Antibiotic only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Genital HSV with active outbreak in labor → Cesarean delivery** to prevent neonatal HSV (devastating CNS/disseminated disease, mortality 30-60%): (1) **indication for C/S** — active genital lesions OR **prodromal symptoms** at onset of labor → C/S preferred (even if ROM); ACOG; (2) **prevention** — suppressive **acyclovir 400 mg PO TID** OR **valacyclovir 500 mg PO BID** from 36 wk to delivery for women with recurrent genital HSV (reduces outbreaks + viral shedding + C/S need); (3) **PPROM management** — individualized: if active lesions + preterm + benefit of prolonging > risk neonatal HSV → continue expectant with acyclovir; if term with active lesions → C/S; (4) **avoid invasive procedures** — fetal scalp electrode, fetal scalp blood, instrumented delivery (vacuum/forceps in labor; vacuum/forceps for C/S OK); (5) **counsel patient** — risk neonatal HSV with active primary lesions in labor ~ 30-50%; recurrent ~ 1-3% (lower because of maternal antibody); (6) **first episode (primary)** during pregnancy → highest risk neonatal HSV → treat acyclovir 400 mg TID × 7-10 d, suppression from 36 wk, C/S in active labor; (7) **neonatal management** — culture (skin, eyes, mouth, NP, rectum), HSV PCR, exam q shift; preemptive acyclovir if exposed + symptomatic; (8) **breastfeeding** — safe unless breast lesions; (9) **partner counseling** + STI screen + condoms + suppression for prevention of transmission

---

Genital HSV + active outbreak in labor = C/S. Suppression acyclovir/valacyclovir 36 wk → delivery reduces outbreaks. Primary episode highest risk neonatal HSV. Avoid invasive procedures. Neonatal eval. Breastfeeding safe (no breast lesions). Partner counseling.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงตั้งครรภ์ G1P0 GA 38 wk underlying genital HSV-2 with active recurrent outbreak (genital ulcers + vesicles) detected at L&R when contractions started

V/S: BP 122/74, HR 92, Temp 37.0
Gen: vulvar vesicles + ulcers visible, painful
Fetal: FHR 144, contractions q 5 min, cervix 2 cm';

update public.mcq_questions
set choices = '[{"label":"A","text":"Stop all asthma medication"},{"label":"B","text":"Asthma in pregnancy management (poorly-controlled asthma → preterm birth, FGR, preeclampsia, perinatal mortality — RISK > medication risk)"},{"label":"C","text":"Cesarean immediately"},{"label":"D","text":"Use only oxygen"},{"label":"E","text":"Methotrexate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Asthma in pregnancy management (poorly-controlled asthma → preterm birth, FGR, preeclampsia, perinatal mortality — RISK > medication risk): (1) **continue + optimize medications** — pregnancy-safe: inhaled corticosteroids first-line (**budesonide** most data, fluticasone OK); SABA (albuterol/salbutamol) for rescue; LABA (salmeterol, formoterol) add-on; (2) **step-up therapy** for poor control — increase ICS dose, add LABA, add LTRA (montelukast), oral steroid burst (prednisolone) for exacerbations; (3) **monitor** — peak flow daily, symptom diary, ACT (Asthma Control Test); decline 20% needs action; (4) **trigger avoidance** — smoking cessation + secondhand smoke, allergens, infections (flu + COVID + Tdap vaccines indicated); (5) **acute exacerbation in pregnancy** — same as non-pregnant + lower threshold to admit; SpO2 target ≥ 95% (fetal); nebulized albuterol q 20 min × 3, ipratropium, IV magnesium, systemic steroid (methylprednisolone 60-125 mg IV or prednisolone 40-60 mg PO), O2; severe — ICU + ventilator; (6) **labor + delivery** — continue asthma meds; if on oral steroid > 2 wk in last year → stress dose hydrocortisone 100 mg IV q 8 hr in labor; avoid PGF2α (carboprost → bronchospasm), opioid morphine (histamine), aspirin (sensitive); preferred uterotonics oxytocin, misoprostol, methylergonovine (HT caution); (7) **fetal surveillance** — growth + NST if poorly controlled; (8) **lactation** — all asthma meds safe; (9) **postpartum** — continue therapy; (10) **multidisciplinary** — OB + pulm/allergy + primary care

---

Asthma pregnancy: 1/3 better, 1/3 worse, 1/3 same. Poor control > medication risk. Budesonide preferred ICS. Step up if poor control. Avoid PGF2α (bronchospasm) for PPH. Vaccines flu/COVID/Tdap. Stress dose steroid if chronic. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 28 ปี G1P0 GA 16 wk pre-existing asthma, on inhaled budesonide + salbutamol PRN — has been having ↑ exacerbations recently, peak flow declining 80% → 60% best

V/S: BP 116/72, HR 90, RR 22
Gen: wheezing, accessory muscle use mild
Lab: SpO2 95% RA, no fever
Fetal: FHR 152 reactive';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge home + observe"},{"label":"B","text":"Trauma in pregnancy"},{"label":"C","text":"Cesarean immediately without trauma workup"},{"label":"D","text":"Refuse imaging"},{"label":"E","text":"Tocolytic only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Trauma in pregnancy** — leading cause of non-obstetric maternal death; manage with **standard ATLS + pregnancy modifications**: (1) **primary survey ABCDE** — airway (intubation as needed), breathing (O2, chest tube), circulation (large-bore IV ×2, crystalloid → blood; aim for normal pre-pregnancy targets), **left lateral tilt 15-30°** (LUD) after 20 wk to relieve aortocaval compression during resuscitation/CPR; (2) **disability** — GCS, glucose; (3) **exposure** — remove clothing, log roll, examine; (4) **secondary survey** — head-to-toe + obstetric (fundal tenderness, vaginal bleeding, ROM, FHR, contractions, fetal movement); pelvic + speculum exam; (5) **investigations** — CBC, type & cross, **Kleihauer-Betke** (FMH quantification → Anti-D dose calculation if Rh-neg; even trauma without bleeding can cause FMH), coag, lactate, **FAST exam** + radiology as indicated (don''t withhold imaging if needed — fetus tolerates well under 5-10 rad cumulative, especially first trimester avoiding pelvis if possible); CT chest/abdomen/pelvis if indicated — risk-benefit; shield uterus when feasible; (6) **fetal monitoring** — continuous EFM **minimum 4 hr** for trauma all gestations ≥ 20-24 wk (longer ≥ 24 hr if contractions > 6/hr, ROM, tenderness, vaginal bleeding, abnormal FHR, abnormal KB); category II/III FHR → consider abruption; (7) **resuscitative hysterotomy / perimortem C/S** — start within **4 min of arrest** if ≥ 23-24 wk for maternal + fetal benefit; (8) **rule out abruption** — abdominal pain, vaginal bleeding, contractions > 6/hr, abnormal FHR, hypertonic uterus, ↑ KB; up to 24 hr presentation; (9) **DV/IPV** — screen — trauma in pregnancy often domestic; (10) **Anti-D Ig** if Rh-negative + any abdominal trauma (even no bleeding — silent FMH possible); (11) **MDT** — trauma + OB + anesthesia + NICU + social

---

Trauma in pregnancy: ATLS + LUD + fetal monitoring ≥ 4 hr (longer if abnormalities). KB test for FMH + Anti-D. CT if indicated — don''t withhold. Abruption presentation up to 24 hr. Perimortem C/S < 4 min of arrest ≥ 24 wk. IPV screening — common cause. MDT.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงตั้งครรภ์ G2P1 GA 26 wk MVC trauma — driver, restrained, airbag deployed, abdominal blunt trauma + bilateral chest contusion

V/S: BP 110/72, HR 110, RR 22, SpO2 96%
Gen: alert, abdominal tenderness diffuse + uterine tenderness
Fetal: FHR 160 (tachy) with minimal variability
US pelvis: placenta posterior (not previa), AFI normal, no obvious abruption seen
Lab pending: CBC, type & screen, Kleihauer-Betke, coag';

update public.mcq_questions
set choices = '[{"label":"A","text":"Antibiotic only"},{"label":"B","text":"Stress urinary incontinence (SUI) + pelvic organ prolapse (POP) — comprehensive management"},{"label":"C","text":"Cesarean delivery"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Antibiotic only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Stress urinary incontinence (SUI) + pelvic organ prolapse (POP) — comprehensive management: (1) **lifestyle + behavioral** first-line — weight loss, fluid management, treat constipation, smoking cessation; **pelvic floor muscle training (Kegel) supervised by PFPT** — strong evidence for SUI + POP; (2) **pessary** — supportive vaginal device for POP + SUI (ring, Gellhorn, donut, incontinence pessary) — non-surgical, fit clinic, change/clean q 3 mo, watch for erosion/discharge; (3) **vaginal estrogen** ถ้า GSM + atrophy (cream, ring, tablet) — improves tissue + symptoms; (4) **bladder training** + scheduled voiding; (5) **medications for SUI** — **duloxetine** (SNRI — modest effect, GI side effects); no other SUI-specific oral; for **urge incontinence** (different) — anticholinergic, mirabegron; (6) **surgical SUI** — **midurethral sling** (TVT/TOT) — gold standard; pubovaginal sling autologous fascia; Burch colposuspension; bulking agents (urethral injection); (7) **surgical POP** — vaginal hysterectomy + USLS (uterosacral ligament suspension) or sacrospinous ligament fixation; **sacrocolpopexy** (abdominal/lap/robotic) — gold standard apical support; native tissue repair anterior/posterior; **mesh** vaginal — restricted/banned in many countries; **colpocleisis** (Le Fort) — obliterative for elderly + frail; (8) **shared decision-making** — sexual activity desire, surgical risk; (9) follow-up + counsel recurrence; (10) workup before surgery — urodynamics (controversial routine), cystoscopy if indicated, PVR

---

SUI/POP management: lifestyle + PFPT + pessary + vaginal estrogen (1st line). Sling for SUI. Sacrocolpopexy gold standard apical POP. Mesh vaginal controversial. Colpocleisis frail elderly. Shared decision. Vaginal estrogen for atrophy.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 52 ปี postmenopausal × 2 yr มาด้วยอาการ stress urinary incontinence (leak with cough/sneeze/exercise) + pelvic pressure × 6 mo, ไม่มี dysuria

V/S: BP 132/82, HR 78
Pelvic: bulge of anterior vaginal wall to introitus on Valsalva (POP-Q stage 2 cystocele), Q-tip test angle 45° with Valsalva, no UTI, post-void residual 30 mL
Urine analysis: WNL
Cough stress test: positive';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge — observation"},{"label":"B","text":"Early-stage cervical cancer (FIGO 2018 IB1, tumor < 2 cm; this case IB2 tumor 2-4 cm)"},{"label":"C","text":"Antibiotic alone"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Hysterectomy without staging"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Early-stage cervical cancer (FIGO 2018 IB1, tumor < 2 cm; this case IB2 tumor 2-4 cm)** — review FIGO 2018: IA microscopic; IB1 < 2 cm; IB2 2-4 cm; IB3 > 4 cm; II beyond uterus but not pelvic wall/lower vagina; III pelvic wall/hydronephrosis/lower vagina; IV beyond pelvis; (1) **staging gold standard** — clinical + imaging (MRI for local extent, PET-CT for nodes/distant), surgical staging optional; (2) **treatment options for IB1-IB2** (≤ 4 cm, lymph node negative): (a) **radical hysterectomy + bilateral pelvic lymphadenectomy** (Type C — Querleu-Morrow) — fertility loss; preferred if completed childbearing; sentinel LN biopsy increasingly used; **LACC trial 2018 — open approach superior to minimally invasive** (MIS had worse DFS + OS — paradigm shift away from lap/robotic for cervical cancer); (b) **chemoradiation** — alternative, similar survival, different morbidity (vaginal stenosis, bowel/bladder); (c) **fertility-sparing — radical trachelectomy** (vaginal Dargent or abdominal) + pelvic lymphadenectomy ถ้า tumor < 2 cm + no LVSI + no metastasis + desires fertility; cervical cerclage placed; future pregnancy high-risk preterm + need C/S; (3) **adjuvant therapy** — pelvic RT + concurrent platinum chemo (cisplatin) if intermediate (large tumor, deep stromal invasion, LVSI) or high risk (positive margin, parametrial, LN+); (4) **HPV vaccination** — primary prevention + post-treatment recurrence reduction (controversial); (5) **screening** — Thai universal cervical cancer screening (Pap or HPV); (6) **follow-up** — exam + cytology + HPV q 3-6 mo × 2 yr, then q 6-12 mo × 3 yr, then annual × 5 yr; imaging if symptoms; (7) **prognosis** — 5-yr stage IB1 > 90%, IB2 70-80%, IB3 60-70%, II 50-60%, III 30-40%, IV < 20%; (8) Thai context — RTCOG + Royal Thai GYN-Onc Society protocols

---

Cervical cancer FIGO 2018 staging. Early stage: radical hysterectomy or chemoradiation. LACC trial — OPEN approach (not lap/robotic) for radical hysterectomy. Fertility-sparing trachelectomy < 2 cm. Adjuvant RT-chemo for intermediate/high risk. HPV vaccine prevention. Thai protocols.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 35 ปี Pap smear + colposcopy + biopsy = cervical cancer SCC invasive — staging FIGO IB1 (tumor 3 cm confined to cervix, no parametrial invasion, no nodes)

V/S: BP 122/76, HR 80
Gen: well, no symptoms
MRI pelvis: 3 cm cervical mass, no parametrial/nodal involvement
PET-CT: no distant metastasis';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge — wait + see"},{"label":"B","text":"Prolactinoma (macroadenoma > 10 mm) with mass effect (visual field defect)"},{"label":"C","text":"Cesarean delivery"},{"label":"D","text":"Antibiotic alone"},{"label":"E","text":"Hysterectomy"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Prolactinoma (macroadenoma > 10 mm) with mass effect (visual field defect)** — endocrine + visual emergency: (1) **referral neurosurgery + endocrinology + neuro-ophthalmology** urgent; (2) **first-line — dopamine agonist** — even for macroadenoma with mass effect (medication can rapidly shrink tumor): (a) **cabergoline** 0.25-0.5 mg PO twice weekly, titrate up — preferred (better efficacy + tolerability + less valvular risk at low dose); (b) bromocriptine alternative; (3) **monitor** — prolactin level + MRI in 1-3 mo + repeat visual field; expect rapid normalization prolactin + tumor shrinkage 30-50% within months; vision recovery often rapid; (4) **surgical (transsphenoidal)** — second-line if medical fails or intolerance, or apoplexy, or CSF leak; (5) **radiation** — last resort; (6) **rule out hypopituitarism** — cortisol, ACTH, TSH/FT4, FSH/LH/E2, GH/IGF-1; treat as needed; (7) **etiology hyperprolactinemia** ddx — physiologic (pregnancy/lactation/stress/sleep/sex), medications (antipsychotics, metoclopramide, opioids, methyldopa), hypothyroidism (always check TSH), renal failure, hepatic, chest wall stim, idiopathic, macroadenoma; (8) **fertility** — restore ovulation usually with treatment; pregnancy possible — cabergoline can be continued if needed (older data bromocriptine more data — switch when pregnancy planned); microadenoma low risk in pregnancy (monitor visual field); macroadenoma may need surgical resection pre-pregnancy or close monitoring; (9) **counseling** — long-term often required (may discontinue if normalized > 2 yr + tumor shrunk)

---

Prolactinoma: dopamine agonist first-line even macroadenoma with mass effect. Cabergoline preferred. Rapid tumor shrinkage + vision recovery. Workup hyperprolactinemia ddx (meds, hypothyroid). Restore fertility. Pregnancy considerations. Surgery second-line.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 19 ปี nulligravid มา OPD ด้วยอาการประจำเดือนไม่มา 4 เดือน + galactorrhea + bilateral spontaneous nipple discharge + ปวดศีรษะ + bitemporal hemianopia

V/S: BP 116/72, HR 80
Gen: alert, no Cushingoid, no acromegaly, visual field defect on confrontation
Lab: β-hCG negative, prolactin 220 (very high), TSH 2.4 normal, FT4 normal, FSH/LH suppressed
MRI pituitary: 2.0 cm pituitary macroadenoma compressing optic chiasm';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge without follow-up"},{"label":"B","text":"Adolescent pregnancy (especially with late ANC + small for GA + anemia + social vulnerability) — multidisciplinary comprehensive care"},{"label":"C","text":"Cesarean immediately"},{"label":"D","text":"Refuse care"},{"label":"E","text":"Methotrexate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Adolescent pregnancy** (especially with late ANC + small for GA + anemia + social vulnerability) — multidisciplinary comprehensive care: (1) **non-judgmental + youth-friendly approach** — confidentiality, autonomy, trust-building; (2) **medical** — iron supplementation (ferrous sulfate + vit C; consider IV iron if intolerance/severe), nutritional counseling, weight gain target (BMI 18 underweight — recommend 12.5-18 kg gain), folic acid, calcium, fetal surveillance + growth US q 3-4 wk + Doppler if FGR, NST/BPP from 32 wk; (3) **risk awareness** — teen pregnancy ↑ preterm, PE, LBW, anemia, depression, social isolation; FGR present → workup placental insufficiency, smoking/substance, hypertension, infection; (4) **STI/HIV/hepatitis screening complete** + repeat 3rd trimester; **immunization** — Tdap 27-36 wk, flu, COVID; (5) **mental health** — PHQ-9/EPDS, screen depression + anxiety + IPV + self-harm; (6) **social work** — housing, food security, family support, legal (parental notification varies by jurisdiction — Thai law: under 18 needs parental consent for some decisions but ANC + emergency confidentiality), education continuation, financial support (Thai government child allowance), enrollment in maternal-child health programs; (7) **birth preparation** — childbirth education, breastfeeding counseling, doula/support person; (8) **delivery + postpartum** — vaginal delivery favored if no obstetric contra; teen pelvis usually adequate; postpartum contraception **LARC (implant, IUD)** at delivery — reduces repeat teen pregnancy (highest-impact intervention); (9) **breastfeeding** support; (10) **infant care** + home visiting nurse + pediatric follow-up; (11) Thai context — 1663 hotline; teen-friendly clinics; school continuation policies; (12) **prevent recurrence** — comprehensive sex ed + LARC promotion

---

Adolescent pregnancy: multidisciplinary. Late ANC + FGR + anemia + social risk. Youth-friendly. Iron + nutrition + growth surveillance. STI/HIV. Mental health. Social work + education. Postpartum LARC reduces repeat. Thai 1663 hotline + teen clinics + child allowance. Prevention: sex ed.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 16 ปี G1P0 GA 32 wk teen pregnancy — มา ANC ครั้งแรก ตอน 32 wk, no prior care, denies STIs/substance use, lives with grandmother (parents absent), high school dropped out, anemia

V/S: BP 108/68, HR 88
Gen: thin, BMI 18
Fetal: FHR 148, fundal height 28 cm (small for GA)
Lab: Hb 8.2, MCV 78, ferritin 9, β-hCG positive (already known), VDRL negative, HIV negative, HBsAg negative, urine WNL
US: singleton, EFW 1,300 g (< 5th percentile), AFI 8, no anomaly';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge with PO aspirin"},{"label":"B","text":"DVT in pregnancy"},{"label":"C","text":"Aspirin alone"},{"label":"D","text":"Discharge — observe"},{"label":"E","text":"Methotrexate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **DVT in pregnancy** — anticoagulation **LMWH** (does NOT cross placenta, safer than warfarin in pregnancy): (1) **anticoagulation initiation** — **LMWH enoxaparin 1 mg/kg SC BID** (therapeutic) — weight-based, adjust anti-Xa levels (peak 4 hr post-dose target 0.6-1.0 IU/mL prophylactic; 0.8-1.2 therapeutic); (2) **alternatives** — UFH IV (if labor imminent, renal failure, thrombolysis planned); avoid warfarin (teratogenic, fetal hemorrhage); avoid DOACs in pregnancy (insufficient data); (3) **rule out PE** — clinical assessment, oxygenation, ECG; CTPA if suspected (lower fetal radiation than V/Q); (4) **duration** — minimum 3 mo + continue through pregnancy + **6 wk postpartum** (overall ≥ 6 mo treatment); (5) **adjustments** — postpartum can transition to warfarin (safe in breastfeeding) bridge with LMWH × 5 d + INR therapeutic; (6) **delivery planning** — switch LMWH to UFH at 36-37 wk for flexibility (UFH t½ shorter, reversible with protamine, allows regional anesthesia); plan induction; **hold LMWH 24 hr before scheduled procedure** (12 hr prophylactic, 24 hr therapeutic); resume 6-12 hr postpartum if hemostatic; (7) **regional anesthesia** — wait 24 hr after therapeutic LMWH; (8) **mechanical** — early ambulation, compression stockings; (9) **thrombolysis** — massive PE only (postpartum bleed risk); IVC filter if anticoagulation contraindicated; (10) **workup thrombophilia** — postpartum off anticoagulation (pregnancy makes results unreliable); future pregnancies → prophylaxis LMWH; (11) **family** counseling + bleeding precautions

---

DVT pregnancy: LMWH therapeutic (1 mg/kg BID). Avoid warfarin (teratogen) + DOACs (no data). Duration: 3 mo + through pregnancy + 6 wk postpartum. Switch UFH at 36-37 wk. Hold for delivery. Regional anesthesia 24 hr off LMWH. Postpartum bridge to warfarin (safe breastfeeding). Future pregnancy prophylaxis.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 30 ปี G2P1 GA 28 wk ลื่นล้มเดิน + leg DVT acute — R leg painful + swollen + warmth × 2 d

V/S: BP 116/72, HR 92, RR 18, SpO2 98% RA
Gen: R lower limb edema + erythema + Homan''s sign +
Fetal: FHR 144 reactive
Doppler US: R popliteal + femoral DVT extending to iliac
Lab: CBC normal, no coagulopathy, D-dimer 4,200';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue losartan"},{"label":"B","text":"CKD in pregnancy"},{"label":"C","text":"Continue all meds without change"},{"label":"D","text":"Cesarean immediately at 12 wk"},{"label":"E","text":"Methotrexate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **CKD in pregnancy** — high-risk, multidisciplinary (nephrology + MFM): (1) **stop teratogenic medications** — **discontinue losartan (ARB) immediately** — ACEI/ARB cause fetal renal dysgenesis + oligohydramnios + skull hypoplasia + fetal death (2nd-3rd trimester especially; even 1st trimester risk); switch to **safe antihypertensive** — labetalol, nifedipine ER, methyldopa; target BP 110-140/85 (CHAP); (2) **assess baseline + monitor** — eGFR, urine protein/Cr or 24-hr, K, P, Ca, Hb, BP; serial monitoring q 2-4 wk early then more frequent; (3) **risk stratification** — Cr > 1.4 mg/dL = ↑ risk progression CKD + adverse OB outcomes (preeclampsia, FGR, preterm, perinatal mortality); dialysis-dependent — fertility lower, very high-risk pregnancy; (4) **aspirin 81-150 mg/d from 12-16 wk to delivery** — preeclampsia prevention (CKD = high risk); (5) **proteinuria** — distinguish baseline vs preeclampsia (new doubling, severe features); (6) **anemia** — iron + ESA (erythropoietin safe); (7) **fetal surveillance** — anatomy scan, serial growth q 4 wk, NST/BPP from 28-32 wk; (8) **delivery timing** — individualized based on maternal-fetal status; aim for term if stable; earlier if maternal deterioration or fetal compromise; (9) **postpartum** — kidney function reassess; may resume ACEI/ARB postpartum (avoid in breastfeeding — though enalapril/captopril considered compatible by Hale''s); (10) **dialysis pregnancy** — intensify hemodialysis (> 36 hr/wk improves outcomes); (11) **preconception counseling** ideal — optimize BP + proteinuria + transplantation; (12) **post-transplant pregnancy** — wait 1-2 yr, stable function, switch teratogenic immunosuppressants (mycophenolate → azathioprine)

---

CKD pregnancy: stop ACEI/ARB (teratogenic). Switch to labetalol/nifedipine/methyldopa. Aspirin PE prevention. Cr > 1.4 high risk. Monitor closely. Preconception counseling. Dialysis intensify. Post-transplant: 1-2 yr after, stable, change immunosuppressants. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 30 ปี G3P2 GA 12 wk underlying CKD stage 3a (baseline Cr 1.6, eGFR 45), pre-existing proteinuria 1+ baseline, hypertension on losartan 50 mg/d pre-pregnancy

V/S: BP 138/86, HR 76
Gen: well
Fetal: heart present, dating CRL matches LMP
Lab: Cr 1.7, eGFR 42, urine protein/Cr 0.9, K 4.2, Hb 10.5, no preeclampsia features';

update public.mcq_questions
set choices = '[{"label":"A","text":"Surfactant produced from week 12"},{"label":"B","text":"Fetal lung development + surfactant"},{"label":"C","text":"Type I pneumocytes produce surfactant"},{"label":"D","text":"L/S ratio mature at 1"},{"label":"E","text":"Surfactant unrelated to RDS"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Fetal lung development + surfactant: (1) **stages**: (a) embryonic 4-6 wk (lung bud), (b) pseudoglandular 5-17 wk (airways branching), (c) canalicular 16-25 wk (vascularization, terminal sacs, first surfactant ~ 24 wk), (d) saccular 24-40 wk (alveolar precursors), (e) alveolar 36 wk → 8 yr (alveolarization continues); (2) **surfactant** — produced by **type II pneumocytes** from ~ 24 wk, mature production by 35-36 wk; (3) **composition** — 90% phospholipids (primarily **DPPC — dipalmitoylphosphatidylcholine = lecithin**), 10% proteins (SP-A, B, C, D — B + C surface activity, A + D innate immunity), small amount neutral lipids; (4) **function** — reduces alveolar surface tension → prevents alveolar collapse on expiration + ↓ work of breathing + maintains FRC + improves compliance; (5) **fetal lung maturity tests** (mostly historical now): **L/S ratio** (lecithin/sphingomyelin) ≥ 2 = mature; **phosphatidylglycerol** (PG) presence = mature even in DM; **TDx-FLM**; foam stability index — modern obstetrics uses GA + amniocentesis only for select cases; (6) **antenatal corticosteroids (betamethasone)** induce type II pneumocyte surfactant production + alveolar maturation + edema clearance → reduces RDS, IVH, NEC, mortality (Liggins 1972; Cochrane meta-analysis); (7) **postnatal surfactant therapy** — exogenous (Survanta/poractant) intratracheal for RDS/preterm; (8) **RDS pathophysiology** — surfactant deficiency → alveolar collapse → V/Q mismatch → hypoxia + hypercarbia + acidosis + hyaline membrane formation; X-ray: ground-glass + air bronchograms + low volume; (9) **prevention** — antenatal steroids 24-34 wk (extend to 34-36+6 wk ALPS trial); avoid unnecessary late preterm/term elective delivery; (10) maternal DM → delayed lung maturity (hyperinsulinemia inhibits surfactant) — PG important marker

---

Fetal lung dev stages. Surfactant from type II pneumocytes from 24 wk. DPPC + proteins SP-A/B/C/D. Reduces surface tension. Antenatal steroids mature lungs. RDS = surfactant deficiency. L/S ratio + PG historic markers. DM delays maturity. ALPS late preterm steroids 34-36+6 wk.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Resident ถามอาจารย์เรื่อง fetal lung development + surfactant + RDS pathophysiology';

update public.mcq_questions
set choices = '[{"label":"A","text":"Caldwell-Moloy: 3 types only"},{"label":"B","text":"Pelvic anatomy + obstetric planes"},{"label":"C","text":"Pelvic outlet has 5 types"},{"label":"D","text":"Diagonal conjugate is the shortest diameter"},{"label":"E","text":"Android most common pelvis type"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pelvic anatomy + obstetric planes: (1) **bony pelvis** — false pelvis (above linea terminalis, supports abdo) + true pelvis (below — birth canal); (2) **pelvic inlet** — boundaries: sacral promontory, alae, linea terminalis, pubic crest; transverse ~ 13.5 cm, AP (true conjugate ~ 11 cm); important: **obstetric conjugate** ~ 10 cm (shortest AP — promontory to inner pubic symphysis); **diagonal conjugate** (clinically measured: lower symphysis to promontory, normal ≥ 11.5 cm); (3) **midpelvis** — narrowest plane; ischial spines (transverse 10 cm); **interspinous diameter ≥ 10 cm** for vaginal delivery; (4) **pelvic outlet** — pubic arch, ischial tuberosities (transverse ~ 11 cm), tip of coccyx; subpubic angle > 90° favorable; (5) **Caldwell-Moloy classification** (4 types based on inlet): (a) **gynecoid** (50%) — round inlet, wide subpubic angle, best for vaginal delivery; (b) **android** (30%, male-type) — heart-shaped, narrow subpubic, prominent spines, ↑ arrest of labor + OP; (c) **anthropoid** (25%) — AP > transverse oval, narrow transverse, OP/OA presentations common, often allows vaginal; (d) **platypelloid** (3%) — flat, wide transverse + narrow AP, transverse arrest, often C/S; (6) **clinical pelvimetry** — diagonal conjugate, ischial spine prominence, subpubic angle, sacrum curvature, sidewalls; not predictive enough for routine C/S decision — trial of labor; (7) **cardinal movements of labor** — engagement, descent, flexion, internal rotation, extension, restitution, external rotation, expulsion; (8) **station** — ischial spines = 0; -5 high to +5 crowning; (9) **soft tissues** — pelvic floor muscles (levator ani — pubococcygeus, iliococcygeus, puborectalis) + perineal membrane + supportive ligaments; (10) **abnormalities** — contracted inlet (< 10 cm conjugate), midpelvis, outlet → may need C/S

---

Pelvic anatomy: inlet/mid/outlet planes. Obstetric conjugate shortest AP. Caldwell-Moloy 4 types — gynecoid best. Cardinal movements 8. Station ischial spines. Pelvic floor levator ani. Soft tissue + bony assessment.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Resident ถามอาจารย์เรื่อง pelvic anatomy + planes of labor + Caldwell-Moloy pelvis types';

update public.mcq_questions
set choices = '[{"label":"A","text":"All medications equally safe in pregnancy"},{"label":"B","text":"stage of development"},{"label":"C","text":"Warfarin is safe in pregnancy"},{"label":"D","text":"Ace inhibitors are safe in pregnancy"},{"label":"E","text":"Valproate is safest antiepileptic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Teratology principles: (1) **6 principles (Wilson)**: (a) **genotype** of conceptus + interaction with environment; (b) **stage of development** at exposure — fertilization (all-or-none), embryonic period 3-8 wk (organogenesis — highest risk structural), fetal period (functional + growth); (c) **mechanism** specific (folate antagonist, DNA damage, receptor); (d) **agent type** + chemical/biologic properties; (e) **dose-dependent** + threshold (some); (f) **manifestations** — death, malformation, growth restriction, functional disorder; (2) **FDA categories obsolete (A/B/C/D/X)** — replaced 2015 by **Pregnancy + Lactation Labeling Rule (PLLR)** — narrative summary of risk; (3) **common teratogens + effects**: (a) **alcohol** — fetal alcohol spectrum disorder (FAS — short palpebral fissures, smooth philtrum, thin upper lip, growth, CNS); no safe dose; (b) **isotretinoin** — high risk craniofacial, cardiac, CNS, abortion; iPledge program; (c) **valproate** — NTD, cleft lip/palate, cardiac, neurodevelopmental; switch preconception; (d) **warfarin** — embryopathy (nasal hypoplasia, stippled epiphyses); fetal hemorrhage; (e) **ACEI/ARB** — renal dysgenesis, oligohydramnios, skull hypoplasia (2nd-3rd trimester); (f) **lithium** — Ebstein anomaly (cardiac); risk vs untreated bipolar; (g) **methotrexate, mycophenolate, cyclophosphamide** — abortion, malformation; (h) **phenytoin** — fetal hydantoin syndrome; (i) **tetracycline, doxycycline** — teeth staining + bone (after 14 wk); (j) **streptomycin/gentamicin** — ototoxicity; (k) **fluoroquinolone** — cartilage (mostly animal data, generally avoid); (l) **statins** — controversial, recently relabeled less risk; (m) **misoprostol** — Möbius sequence; (n) **DES** — vaginal clear cell, T-shaped uterus; (o) **thalidomide** — limb phocomelia; (p) **NSAIDs** — DA closure 3rd trimester, oligohydramnios; (q) **paroxetine** — small ↑ cardiac defects; (4) **infections** — TORCH (toxo, rubella, CMV, HSV, syphilis, Zika, VZV, parvovirus B19); (5) **maternal disease** — DM (cardiac, NTD, caudal regression), PKU (CHD, microcephaly), thyroid; (6) **environmental** — radiation (high dose), lead, mercury; (7) **preconception counseling** — medication review, optimize disease, folate; (8) resources — Mother to Baby (MotherToBaby), LactMed, Reprotox

---

Teratology: Wilson''s 6 principles. PLLR replaced FDA categories. Common teratogens — alcohol, isotretinoin, valproate, warfarin, ACEI/ARB, lithium, methotrexate. TORCH infections. DM, PKU. Preconception counseling. MotherToBaby resource.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Resident ถามอาจารย์เรื่อง teratology — principles + medication categories + common teratogens';

update public.mcq_questions
set choices = '[{"label":"A","text":"Estrogen increases bone resorption"},{"label":"B","text":"Bone metabolism + menopause + osteoporosis"},{"label":"C","text":"Bisphosphonate stimulates osteoblast"},{"label":"D","text":"Osteoporosis T-score > 2.5"},{"label":"E","text":"Calcitonin is first-line"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bone metabolism + menopause + osteoporosis: (1) **bone remodeling** — continuous balance of osteoclast resorption + osteoblast formation; coupled cycle; (2) **estrogen role** — **inhibits osteoclast activity** (via RANKL/OPG balance), promotes osteoblast survival, ↓ inflammatory cytokines (IL-6, TNF); menopause → estrogen withdrawal → ↑ osteoclast → ↑ resorption → rapid trabecular bone loss especially first 5 yr (~ 2-3%/yr) then 1%/yr; (3) **peak bone mass** — achieved by age 25-30; influenced by genetics, nutrition (calcium, vit D), exercise, hormonal status; (4) **osteoporosis** — T-score ≤ -2.5 on DEXA (lumbar spine, hip, distal radius); osteopenia T-score -1.0 to -2.5; (5) **risk factors** — age, female, postmenopausal, low BMI, family history, smoking, alcohol, glucocorticoid, anticonvulsant, GnRH agonist (chronic), aromatase inhibitor, early menopause, hypogonadism, hyperparathyroid, hyperthyroid, hypovitamin D, malabsorption, RA, CKD; (6) **fracture risk** — vertebral, hip, distal radius (Colles); FRAX 10-yr risk; (7) **screening DEXA** — women ≥ 65, postmenopausal < 65 with risk factors (USPSTF); Thai recommendations similar; (8) **prevention** — calcium 1,200 mg/d + vit D 800-1,000 IU/d, weight-bearing exercise, smoking/alcohol cessation, fall prevention; (9) **pharmacologic treatment** — (a) **bisphosphonates** (alendronate, risedronate, zoledronate) — first-line — antiresorptive; (b) **denosumab** — monoclonal Ab against RANKL — antiresorptive; (c) **raloxifene** (SERM) — bone + breast cancer prevention, ↑ VTE; (d) **teriparatide, abaloparatide** — PTH analog anabolic; (e) **romosozumab** — sclerostin antibody anabolic + antiresorptive; (f) **MHT** — estrogen for menopausal symptoms + bone (not first-line for osteoporosis alone post WHI); (g) **calcitonin** — limited; (10) **monitoring** — DEXA q 1-2 yr on therapy; (11) Thai context — RTCOG osteoporosis guidelines; calcium dietary often low

---

Bone metabolism: estrogen inhibits osteoclasts (RANKL/OPG). Menopause → bone loss. Osteoporosis T ≤ -2.5. DEXA screening ≥ 65 (or earlier with risk). Prevention: Ca/vit D + exercise. Bisphosphonate first-line. Denosumab, teriparatide, romosozumab newer. MHT for menopause symptoms + bone benefit.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Resident ถามอาจารย์เรื่อง bone metabolism + menopause + osteoporosis pathophysiology';

update public.mcq_questions
set choices = '[{"label":"A","text":"Telemedicine is not feasible"},{"label":"B","text":"Telemedicine in OB"},{"label":"C","text":"Eliminate in-person ANC entirely"},{"label":"D","text":"Use only paper records"},{"label":"E","text":"Refuse new technology"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Telemedicine in OB** — expanded access + quality: (1) **synchronous video consultations** with MFM/specialty for high-risk pregnancies — diabetes, HTN, cardiac, complex anomalies; (2) **remote US interpretation** — tele-ultrasound — local sonographer scans, expert remote review (real-time or store-and-forward); (3) **continuous monitoring** — wearables (BP, glucose), home NST devices, remote PT monitoring; (4) **ANC visit modifications** — hybrid model — fewer in-person + telehealth for routine visits in low-risk pregnancies; (5) **postpartum + lactation support** virtual; (6) **rural + underserved access** — reduces travel + costs + improves equity; (7) **mental health** — perinatal psychiatry telehealth; (8) **education** — virtual childbirth classes, BF support groups; (9) **considerations**: (a) ensure adequate technology + bandwidth + privacy/security (HIPAA equivalent), (b) appropriate triage — some visits need in-person (BP, fundal height, fetal heart, exam, US), (c) clear protocols for escalation, (d) cultural + language considerations, (e) reimbursement structure, (f) provider training, (g) patient acceptance + technology literacy; (10) **evidence** — COVID-era data — telemedicine ANC non-inferior in low-risk + improves attendance; (11) **Thai context** — National Telemedicine Policy 2020; Bumrungrad/Bangkok hospitals leaders; expansion to rural areas via Ministry of Public Health (สอ./รพ.สต.); (12) **integration** — with EMR, regional health systems, referral network

---

Telemedicine in OB: ANC for low-risk hybrid, MFM consults, tele-US, remote monitoring, postpartum, mental health. Equity + access. Safeguards: technology, privacy, escalation, training. Thai context: National Telemedicine Policy, rural expansion. Evidence COVID-era favorable.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Rural Thai hospital implements telemedicine for ANC consultation with MFM + remote OB ultrasound interpretation';

update public.mcq_questions
set choices = '[{"label":"A","text":"Skip handoffs"},{"label":"B","text":"I-PASS handoff"},{"label":"C","text":"Use only verbal informal"},{"label":"D","text":"Skip patient summary"},{"label":"E","text":"No standardization"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **I-PASS handoff** (structured handoff communication, evidence reduces preventable adverse events ~ 30%): (1) **I — Illness severity** — sick/getting sick/watcher/stable; (2) **P — Patient summary** — concise SBAR-like summary; (3) **A — Action list** — to-do items with owners + timeline; (4) **S — Situation awareness + contingency planning** — anticipated problems + ''if-then'' plans; (5) **S — Synthesis by receiver** — receiver summarizes + asks clarifying questions (closed-loop); **implementation OB**: (a) shift change L&D + antepartum + postpartum + nursery; (b) standardized template/checklist embedded in EMR; (c) protected time + minimize interruptions; (d) bedside huddles + bedside handoffs (''hello to patient''); (e) simulation training + champions + audit; (6) **specific OB high-risk handoff scenarios** — laboring patient changing shift, OR-to-PACU, antepartum-to-L&D, L&D-to-postpartum, postpartum-to-newborn nursery; (7) **emergency code handoffs** — closed-loop SBAR; (8) **measurement** — observed handoff quality, miscommunication rate, adverse events, near-misses; (9) **culture** — psychological safety, speak-up; (10) **special — pregnant patient transfer between hospitals** — clear documentation + advance call + accepting MD + transfer summary + accompanying staff per acuity

---

I-PASS handoff: Illness severity, Patient summary, Action list, Situation awareness, Synthesis. Evidence reduces adverse events ~ 30%. OB-specific scenarios — shift change, OR-to-PACU, transfers. Embedded in EMR. Bedside. Simulation. Measurement. Culture of safety.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Hospital implements I-PASS handoff bundle on Labor & Delivery to reduce harm from communication failures';

update public.mcq_questions
set choices = '[{"label":"A","text":"All hospitals equal capability"},{"label":"B","text":"Levels of Maternal Care"},{"label":"C","text":"Eliminate referral system"},{"label":"D","text":"All low-risk to tertiary"},{"label":"E","text":"Skip transfers"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Levels of Maternal Care** (ACOG/SMFM 2019 / WHO regionalization): standardizes facility capability + matches patient acuity → improves outcomes (similar concept to neonatal levels): (1) **Birth Center / Level I (Basic Care)** — uncomplicated, low-risk, term singleton vertex; immediate stabilization + transfer for complications; midwifery model; (2) **Level I (Basic Hospital)** — care of low to moderate-risk pregnancies; 24/7 OB/midwife + anesthesia available; ability to perform emergency C/S; immediate transfer for higher levels; (3) **Level II (Specialty)** — high-risk including moderate complications (e.g., GDM on insulin, mild preeclampsia); 24/7 obstetrician + anesthesia + level II NICU (≥ 32 wk); MFM consultation available; (4) **Level III (Subspecialty)** — comprehensive — major maternal medical conditions, severe obstetric complications; 24/7 MFM + anesthesia + level III NICU + adult ICU + medical specialists; surgical capability including cesarean hysterectomy; blood bank + IR; (5) **Level IV (Regional Perinatal Health Care Centers)** — most complex — placenta accreta spectrum, complex cardiac, transplant, ECMO; on-site full subspecialty; training + research + outreach; (6) **transfer criteria + system** — early transfer better than late (in-utero transfer when possible); referral network; bidirectional (back-transport stable to home hospital); (7) **regulations + verification** — facility self-attestation + accreditation; (8) **Thai context** — Health Ministry levels (สถานีอนามัย/รพ.สต. → รพ.ชุมชน → รพ.ทั่วไป → รพ.ศูนย์ → รพ.มหาวิทยาลัย); MCH boards; (9) **equity** — geographic + financial access; (10) **outcomes** — improved when matched care; sentinel events with mismatch; (11) **research/data sharing**; (12) **drills + simulation** + interfacility coordination

---

Levels of Maternal Care: birth center, Level I-IV. Match acuity to capability. In-utero transfer preferable. Regional Perinatal Centers most complex. Thai system: รพ.ศูนย์/มหาวิทยาลัย. Accreditation + verification. Outcomes improved with matched care.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Ministry establishes levels of maternal care system to match patient acuity to facility capability';

update public.mcq_questions
set choices = '[{"label":"A","text":"Increase C-sections"},{"label":"B","text":"NTSV C-section rate reduction"},{"label":"C","text":"Eliminate fetal monitoring"},{"label":"D","text":"Force vaginal delivery without consent"},{"label":"E","text":"Cesarean for all"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **NTSV C-section rate reduction** (CMS quality measure; benchmark ≤ 23.6% target; safe vaginal birth + reduce primary C/S → reduces subsequent C/S + accreta): evidence-based interventions: (1) **labor management** — (a) **adopt Friedman → newer labor curves (Consortium on Safe Labor, Zhang 2010)** — active labor starts at 6 cm not 4 cm; allow more time before diagnosing arrest disorders; (b) **arrest of dilation criteria** — no progress 4 hr adequate contractions OR 6 hr inadequate contractions after 6 cm dilation (ACOG/SMFM Safe Prevention of Primary C-Section); (c) **arrest of descent** — push 3 hr nullip with epidural (4 hr possible) before C/S; (2) **induction of labor** — (a) allow latent phase 24 hr in induced labor before failure dx; (b) ARRIVE trial — IOL at 39 wk in low-risk nullip doesn''t ↑ C/S; (3) **continuous labor support** — doulas/midwifery model reduces C/S; (4) **fetal heart rate** — accurate NICHD interpretation, intrauterine resuscitation, scalp stim, fetal scalp blood, restrict cesarean to category III + persistent II; (5) **breech** — offer ECV at 37 wk; vaginal breech selective; (6) **TOLAC** — appropriate selection + availability; (7) **prenatal education** — preferences, expectations, when to come in (4-1-1 rule), avoid early labor admission; (8) **provider feedback + audit** — share NTSV rates by provider + practice; (9) **culture** — patient choice, shared decision; (10) **data systems** — collaborative (CMQCC, ACOG Council); (11) **payment reform** — bundled payment removing financial incentive C/S; (12) **simulation + workforce** — vaginal breech, operative vaginal skills

---

Reduce NTSV C/S: Zhang labor curves (active labor 6 cm), longer latent + active + 2nd stage tolerance, ARRIVE 39-wk IOL, continuous support, NICHD CTG, ECV breech, TOLAC, education. Provider audit + culture + payment reform. CMQCC + CMS measure benchmark.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Quality improvement project — reducing primary C-section rate (NTSV — nulliparous term singleton vertex) without compromising safety';

update public.mcq_questions
set choices = '[{"label":"A","text":"Stop all medications"},{"label":"B","text":"SLE in pregnancy"},{"label":"C","text":"Cesarean immediately"},{"label":"D","text":"Stop HCQ"},{"label":"E","text":"Methotrexate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **SLE in pregnancy** — high-risk multidisciplinary (rheumatology + MFM + neonatology): (1) **preconception planning** — disease quiescent ≥ 6 mo, no active nephritis, controlled HT, safe medications, normal renal function; (2) **continue safe medications** — **HCQ continue** (reduces flares + congenital heart block + neonatal lupus + thrombosis + preeclampsia); **low-dose prednisone** (< 20 mg/d) if needed; **azathioprine** if more immunosuppression; **avoid** — mycophenolate (teratogen — switch to azathioprine), cyclophosphamide, methotrexate; (3) **flare management** — distinguish from preeclampsia (often difficult — both can have proteinuria, HT, low plt); ↑ prednisone for flare; pulse methylprednisolone severe; (4) **APS (antiphospholipid syndrome) workup** — lupus anticoagulant, anti-cardiolipin IgG/IgM, anti-β2GP1; **if positive** — aspirin + prophylactic LMWH (history thrombosis) or aspirin alone (no thrombosis); (5) **preeclampsia prevention** — **aspirin 81-150 mg/d from 12-16 wk** (high-risk); (6) **anti-Ro/La positive** → fetal echo serial (q 1-2 wk from 16-28 wk) for **congenital heart block + neonatal lupus**; if 1°-2° AV block → consider dexamethasone + IVIG (controversial); 3° AV block irreversible; (7) **fetal surveillance** — anatomy scan, growth, NST/BPP; FGR + preterm risk; (8) **delivery timing** — 38-39 wk uncomplicated; earlier if maternal/fetal compromise; vaginal preferred; (9) **postpartum** — **flare risk** common — continue therapy; breastfeeding compatible with HCQ, low-dose prednisone, azathioprine; (10) **monitor** — labs q 4-6 wk (CBC, Cr, urine protein/Cr, anti-dsDNA, C3/C4, LFT); BP; (11) future pregnancy planning + contraception (avoid estrogen if APS+; progestin OK; IUD OK); (12) Thai SLE community + support

---

SLE pregnancy: HCQ continue (vital), prednisone low-dose, azathioprine if needed. Avoid MMF/cyclophosphamide/MTX. Aspirin PE prevention. APS workup + treatment. Anti-Ro/La → fetal echo congenital heart block. Multidisciplinary. Postpartum flare. Breastfeeding safe with most. Distinguish flare vs PE difficult.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 26 ปี G2P1 GA 12 wk underlying SLE on HCQ + low-dose prednisone, recently flared with arthritis + proteinuria 1g/d + ANA + anti-dsDNA + low C3 — on stable doses

V/S: BP 138/86, HR 92
Gen: malar rash + arthritis active
Fetal: heart present, dating correct, normal early US
Lab: Hb 10.8, plt 145K, Cr 0.8, urine protein/Cr 0.9, anti-dsDNA elevated, low C3, anti-Ro/La positive, antiphospholipid Ab negative';

update public.mcq_questions
set choices = '[{"label":"A","text":"Refuse care + discharge"},{"label":"B","text":"Substance use disorder (SUD) in pregnancy"},{"label":"C","text":"Force C-section"},{"label":"D","text":"Discharge without follow-up"},{"label":"E","text":"Methotrexate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Substance use disorder (SUD) in pregnancy** — comprehensive harm-reduction + treatment + non-judgmental + multidisciplinary: (1) **opioid use disorder (OUD)** — **medication for opioid use disorder (MOUD)** — **methadone** (clinic-based, daily; safe + recommended in pregnancy; stabilizes mother + fetus; reduces overdose, illicit use, transmission; safe in lactation; can ↑ dose 2nd-3rd trimester due to metabolism) OR **buprenorphine** (now first-line option per recent ACOG — outpatient prescribing; better neonatal outcomes — shorter NAS, less severe; mono product preferred over combo with naloxone — though combo now considered acceptable); (2) **AVOID detoxification/withdrawal during pregnancy** — high relapse + overdose risk; agonist therapy preferred; (3) **prenatal care comprehensive** — frequent visits, social work, addiction medicine, mental health, peer support; (4) **infection screening** — HIV, HBV, HCV, syphilis, GC/CT, TB; treatment per status; HBV vaccination if susceptible; HCV — DAA postpartum (some safety in pregnancy now); (5) **other substances** — alcohol (no safe — refer SBIRT, AA, naltrexone postpartum), cannabis (avoid — neurodevelopmental); cocaine/meth (avoid — abruption, FGR, vasoconstriction); benzo (taper carefully); tobacco (NRT, varenicline limited data, contingency); (6) **fetal surveillance** — growth + NST/BPP (FGR risk); (7) **labor management** — continue MOUD; avoid agonist-antagonist (precipitates withdrawal); adequate analgesia (will need higher doses opioid for pain on top of maintenance — non-opioid adjuncts); epidural OK; (8) **neonatal** — **Neonatal Abstinence Syndrome (NAS) / NOWS** — eat-sleep-console approach + morphine/methadone PRN; rooming-in + breastfeeding (if mother stable on MOUD + not using illicit) reduces NAS severity; (9) **postpartum** — high relapse + overdose mortality risk — continuity + naloxone Rx + harm reduction + LARC contraception; (10) **legal** — Thai law: not mandatory reporting SUD pregnancy but DCFS varies; offer voluntary treatment, support family; (11) **stigma reduction** — language (''person with SUD'' not ''addict''); (12) **Thailand resources** — Thanyarak Institute, Princess Mother addiction centers

---

OUD pregnancy: MOUD (methadone or bupe). AVOID detox. Comprehensive prenatal + addiction + mental health. STI screening. Other substances. Labor: continue MOUD + adequate analgesia. NAS — eat-sleep-console. Postpartum overdose risk high. LARC. Stigma reduction. Thai Thanyarak.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 24 ปี G1P0 GA 28 wk active opioid use disorder (heroin daily) + alcohol + cannabis use, IDU history, no recent overdose, HIV/HCV unknown

V/S: BP 122/76, HR 102, RR 18
Gen: track marks both forearms, dental decay, withdrawal signs mild
Fetal: FHR 158 reactive, EFW 1,100 g (10th percentile)
Lab: urine tox positive opioid + cannabis + cocaine, anti-HIV + HCV Ab pending, HBsAg pending, TSH normal, syphilis VDRL pending';

update public.mcq_questions
set choices = '[{"label":"A","text":"No treatment"},{"label":"B","text":"Peripartum Cardiomyopathy (PPCM)"},{"label":"C","text":"Cesarean immediately"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Methotrexate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Peripartum Cardiomyopathy (PPCM)** — heart failure with reduced EF (< 45%) in late pregnancy or up to 5 mo postpartum without other cause; multidisciplinary cardiology + MFM + anesthesia: (1) **diagnosis** — exclude other causes (CAD, valvular, congenital, hypertensive, etc.); echo + biomarkers (BNP); cardiac MRI; (2) **medical therapy — pregnancy-modified heart failure**: (a) **avoid in pregnancy** — ACEI/ARB (teratogenic — switch postpartum), aldosterone antagonists, ARNI; (b) **safe during pregnancy** — **hydralazine + isosorbide dinitrate** (afterload reduction), **β-blocker (metoprolol succinate, bisoprolol, labetalol)** — heart rate + remodeling; (c) **diuretic** (furosemide) for congestion — careful avoiding placental hypoperfusion; (d) **digoxin** for symptoms; (e) **anticoagulation** if EF < 35% (LV thrombus risk) — LMWH; (f) **bromocriptine** — controversial — may improve EF by inhibiting prolactin (German + Brazilian studies); standard care varies; need anticoagulation if given; (3) **arrhythmia management** — β-blocker; cardioversion safe in pregnancy; ICD if criteria; (4) **delivery timing + mode** — multidisciplinary; vaginal delivery preferred (reduce hemodynamic stress) with epidural + assisted 2nd stage (passive descent + operative vaginal if needed); C/S for obstetric indication or severe decompensation; (5) **anesthesia** — epidural preferred (reduces preload + afterload smoothly), avoid spinal (rapid changes); (6) **postpartum** — fluid shifts; risk of decompensation; continue therapy; switch to ACEI/ARB postpartum; (7) **recovery + prognosis** — 50-70% recover EF over 6-12 mo; 20-30% chronic HF; 5-10% mortality; future pregnancy risk recurrence + worsening — counsel re: avoidance especially if EF unrecovered; (8) **breastfeeding** — most cardiac meds compatible; bromocriptine suppresses; (9) **mechanical support** — refractory cases (IABP, ECMO, LVAD, transplant); (10) **screen family** — sometimes genetic dilated CM

---

PPCM: HF reduced EF late pregnancy → 5 mo postpartum. Multidisciplinary cardio-OB. Pregnancy-safe HF meds (hydralazine + nitrate, β-blocker, diuretic, digoxin); avoid ACEI/ARB until postpartum. Anticoagulation if EF < 35%. Bromocriptine controversial. Vaginal delivery + epidural preferred. 50-70% recover. Future pregnancy risk.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 35 ปี G2P1 GA 30 wk underlying cardiac — peripartum cardiomyopathy diagnosed at 30 wk based on symptoms + echo EF 35% + no other cause

V/S: BP 110/70, HR 110, RR 22, SpO2 95% RA
Gen: dyspnea NYHA III, mild edema legs + JVP elevated
Fetal: FHR 150 reactive, growth appropriate
Lab: BNP 1,800, troponin negative
Echo: dilated LV, EF 35%, no valvular, no other cause';

update public.mcq_questions
set choices = '[{"label":"A","text":"Terminate pregnancy"},{"label":"B","text":"Breast cancer in pregnancy"},{"label":"C","text":"Stop all care"},{"label":"D","text":"Cesarean at 16 weeks for treatment"},{"label":"E","text":"Methotrexate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Breast cancer in pregnancy** — second most common malignancy in pregnancy; preserve maternal + fetal outcomes — multidisciplinary (oncology, OB-MFM, breast surgery, radiation onc, neonatology, psychology, genetics): (1) **counseling** — termination not required for treatment; outcomes maternal similar to non-pregnant matched; pregnancy not contraindication to most treatment; (2) **staging** — breast US + mammography (shielded), liver US, CXR shielded; AVOID PET + CT abdomen pelvis where possible (radiation); MRI without gadolinium safe (gadolinium avoid); breast MRI (no gadolinium suboptimal but possible); (3) **surgery** — **safe in pregnancy** — modified radical mastectomy or breast-conserving surgery (BCS); sentinel lymph node biopsy with technetium-99m safe (avoid blue dye — fetal); (4) **chemotherapy** — **avoid 1st trimester** (organogenesis); **2nd-3rd trimester safe** — anthracycline (doxorubicin, epirubicin) + cyclophosphamide + 5-FU (FAC/FEC) or AC regimen; taxanes (paclitaxel) less data but safe 2nd-3rd; (5) **AVOID in pregnancy** — **trastuzumab** (anti-HER2 — oligohydramnios + renal/pulmonary), endocrine therapy **(tamoxifen, AI)** — defer to postpartum; (6) **radiation** — avoid in pregnancy (esp upper abdomen, but breast/chest can be considered with shielding 3rd trimester if essential — usually defer to postpartum); (7) **delivery timing** — aim term (37+) for best neonatal outcomes; stop chemo 3 wk before delivery to allow marrow recovery + reduce neonatal myelosuppression; (8) **breastfeeding** — from treated breast may not be possible; non-treated breast OK during treatment if no chemo; pump + discard during chemo; (9) **postpartum complete treatment** — radiation, endocrine therapy, targeted therapy; (10) **genetic counseling** — BRCA testing — guides surgery + family; (11) **psychological + family support**; (12) Thai context — Royal Thai breast onc + MFM collaboration

---

Breast cancer in pregnancy: surgery safe, chemo 2nd-3rd trimester safe (anthracycline + cyclophosphamide), avoid trastuzumab + tamoxifen + AI until postpartum, radiation defer. Stop chemo 3 wk pre-delivery. Term delivery. Counsel — termination not required. BRCA testing.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 30 ปี G1P0 GA 16 wk recent diagnosis breast cancer ER+ PR+ HER2- T2N0 — multidisciplinary discussion of treatment options during pregnancy

V/S: BP 116/72, HR 80
Gen: 3 cm left breast mass, no node
Fetal: heart present, dating correct, anatomy scan planned 20 wk
Lab: routine WNL
Pathology: invasive ductal carcinoma, ER+ PR+ HER2-, Ki-67 30%';

update public.mcq_questions
set choices = '[{"label":"A","text":"Just keep trying without workup"},{"label":"B","text":"Recurrent Pregnancy Loss (RPL) workup (ASRM/ESHRE: ≥ 2 consecutive pregnancy losses; expand workup ≥ 3)"},{"label":"C","text":"Hysterectomy"},{"label":"D","text":"Antibiotic alone"},{"label":"E","text":"Methotrexate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Recurrent Pregnancy Loss (RPL) workup (ASRM/ESHRE: ≥ 2 consecutive pregnancy losses; expand workup ≥ 3): (1) **genetic** — **parental karyotype** both partners (translocation, inversion, especially balanced reciprocal); offer **POC (products of conception) karyotype** on miscarriage tissue (CMA preferred — copy number variants); (2) **anatomic** — **saline infusion sonography or hysteroscopy** (preferred — direct visualization + treat); **3D US/MRI** alternative; rule out **septate uterus** (most common Müllerian RPL, treatable hysteroscopic resection), polyps, fibroids submucosal, intrauterine adhesions (Asherman), bicornuate; (3) **endocrine** — **TSH** (subclinical hypothyroid + TPO ab+ associated), **prolactin**, **HbA1c** (DM), ovarian reserve (AMH); progesterone less helpful; (4) **antiphospholipid syndrome (APS)** — lupus anticoagulant, anti-cardiolipin IgG/IgM (≥ 40), anti-β2GP1 — 2 occasions 12 wk apart; ≥ 3 consecutive 1st-trimester losses or fetal death > 10 wk OR preeclampsia/preterm < 34 wk; treat with **aspirin + prophylactic LMWH** for future pregnancy; (5) **thrombophilia** — controversial — Factor V Leiden, prothrombin gene, antithrombin/protein C/S not routine unless personal/family VTE history; (6) **immunology + allo-immune** — controversial, IVIG/intralipid not standard; (7) **infection** — TORCH not routine unless suggestive; bacterial vaginosis controversial; (8) **lifestyle + environment** — smoking, alcohol, caffeine, weight (BMI > 35 ↑ risk), occupation; (9) **male factor** — semen DNA fragmentation; (10) **management of next pregnancy** — early dating, β-hCG surveillance, supportive counseling (''tender loving care'' improves outcomes), low-dose aspirin if APS, treat hypothyroid, progesterone supplement (controversial — PROMISE trial mostly negative, may help with bleeding history), close monitoring; (11) **emotional support** — counseling, peer groups; (12) Thai context — RTCOG/Thai Fertility Society

---

RPL workup: parental karyotype + POC genetics, anatomy (hysteroscopy/SIS), endocrine (TSH/prolactin/A1c), APS, lifestyle. APS treat aspirin + LMWH. Septate uterus hysteroscopic resection. Treat hypothyroid. Tender loving care. 50% RPL unexplained.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 32 ปี มา OPD ปรึกษา recurrent pregnancy loss — 3 consecutive miscarriages all 1st trimester (8, 9, 10 wk), ไม่มี induced abortion, normal cycle

V/S: BP 118/74, HR 80
Gen: well, no thyroid/hirsutism
Pelvic: WNL
Partner: healthy, no consanguinity
No systemic disease';

update public.mcq_questions
set choices = '[{"label":"A","text":"No treatment in pregnancy"},{"label":"B","text":"Bacterial Vaginosis (BV) in pregnancy"},{"label":"C","text":"Antifungal only"},{"label":"D","text":"Discharge — no treatment"},{"label":"E","text":"Methotrexate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Bacterial Vaginosis (BV) in pregnancy** — Amsel criteria (need 3 of 4): (a) thin gray-white discharge, (b) pH > 4.5, (c) positive whiff test (KOH), (d) clue cells > 20%; or Nugent score on Gram stain; (1) **treat symptomatic BV in pregnancy** — associated ↑ preterm birth, PPROM, chorioamnionitis, endometritis, low birth weight — though treatment of asymptomatic BV not shown to reduce preterm birth in low-risk; (2) **regimens (CDC)**: (a) **metronidazole 500 mg PO BID × 7 d** OR (b) **metronidazole 250 mg PO TID × 7 d** OR (c) **clindamycin 300 mg PO BID × 7 d** (alternative); intravaginal preparations (metronidazole gel, clindamycin cream) acceptable for symptomatic — but oral may be preferred in pregnancy for systemic effect to prevent OB complications; (3) **screen + treat** asymptomatic BV in **history of preterm birth** (some guidelines) but recent evidence less supportive of universal screening; (4) **partner treatment** not routinely recommended (BV not classically STI); (5) **alcohol caution** with metronidazole (disulfiram reaction, controversial newer evidence); (6) **follow-up** — repeat exam 1 mo postpartum; recurrence common; (7) **probiotics** — limited evidence; (8) **avoid douching** — disrupts microbiome; (9) **co-infections** — screen Trichomonas, GC/CT, syphilis, HIV; (10) **counseling** — natural history, recurrence, lifestyle; **trichomoniasis** alternative dx — single-dose metronidazole 2 g (or 500 mg BID × 7 d in pregnancy — preferred by some); **candida** — topical azole (clotrimazole/miconazole) safe in pregnancy (oral fluconazole avoid in 1st tri — small cleft palate signal)

---

BV in pregnancy: Amsel criteria. Metronidazole PO 500 mg BID × 7 d. Associated preterm birth. Treat symptomatic. Universal screening asymptomatic controversial. Partner not treated. Trichomoniasis — metronidazole 2 g single dose or 7 d in pregnancy. Candida — topical azole safe.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงตั้งครรภ์ G2P1 GA 24 wk มาด้วยตกขาวมีกลิ่นปลา + ตรวจตกขาว gray homogeneous discharge, vaginal pH 5.0, whiff test + (fishy odor with KOH), clue cells > 20% on wet mount

V/S: BP 116/72, HR 80
Fetal: FHR 144, no contractions
No symptoms otherwise, no STI risk factors';

update public.mcq_questions
set choices = '[{"label":"A","text":"Oral antibiotic only"},{"label":"B","text":"Bartholin Gland Abscess"},{"label":"C","text":"Hysterectomy"},{"label":"D","text":"Discharge home without treatment"},{"label":"E","text":"Methotrexate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Bartholin Gland Abscess** — obstruction of duct → cyst → infection (often polymicrobial — gram-negative, anaerobes, sometimes GC/CT): (1) **diagnosis** — clinical + visualization fluctuant tender vulvar mass at posterior vestibule (4 or 8 o''clock); (2) **management — drainage + marsupialization or Word catheter**: (a) **incision + drainage (I&D)** alone — high recurrence; (b) **Word catheter placement** — preferred outpatient procedure: incise abscess with #11 blade ~ 5 mm vertical inside hymenal ring (not on labium), drain pus, insert Word catheter (small inflatable Foley-like), inflate balloon, leave in place 4-6 wk for epithelialization (creates permanent drainage tract — prevents recurrence); (c) **marsupialization** — alternative surgical: make 1-2 cm incision through skin + cyst wall, suture cyst wall to skin edges with absorbable suture → creates permanent opening; preferred for recurrent cysts; (3) **antibiotics** — **empirical broad-spectrum** if cellulitis, systemic signs, immunocompromised, MRSA-prevalent area, or no improvement after drainage: amoxicillin-clavulanate or TMP-SMX (MRSA coverage); add metronidazole for anaerobic; routine antibiotics with drainage in healthy patient not always needed (controversial); (4) **STI screening** — GC/CT, syphilis, HIV — culture aspirate; (5) **sitz baths** after drainage; (6) **gland excision** — for recurrent disease or suspected cancer; (7) **biopsy/cancer concern** — older woman (> 40) or atypical → consider Bartholin gland adenocarcinoma (rare) — biopsy + refer onc; (8) **follow-up** + remove Word catheter 4-6 wk; (9) **prevention** — none specific; treat sitz bath for cyst before infection

---

Bartholin abscess: Word catheter or marsupialization preferred (lower recurrence than I&D alone). Antibiotics if cellulitis/systemic. STI screen. Older patient or atypical → biopsy r/o cancer. Sitz bath. Recurrent → excision.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 32 ปี มาห้องฉุกเฉินด้วยอาการ vulvar mass painful 5 cm + redness + heat + difficulty walking + sitting × 3 d

V/S: BP 122/80, HR 92, Temp 38.1
Gen: appears in pain
Vulva: 5 cm tender fluctuant mass at 5 o''clock at posterior vestibule (Bartholin''s gland location), erythema + warmth + induration
No systemic infection, no STI symptoms';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge — early menopause is normal"},{"label":"B","text":"Premature Ovarian Insufficiency (POI)"},{"label":"C","text":"Cesarean delivery"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Premature Ovarian Insufficiency (POI)** — primary ovarian failure < 40 yr (formerly POF); diagnosis: amenorrhea ≥ 4 mo + 2 elevated FSH > 25-40 mIU/mL at least 1 mo apart; spontaneous (idiopathic 80%) or known cause: (1) **etiology workup** — (a) **karyotype** (Turner 45,X; mosaicism; structural X abnormalities), (b) **fragile X premutation (FMR1)** — most common known genetic cause, family history of FXTAS / intellectual disability, (c) **autoimmune** — anti-adrenal/oophoritis (Addison''s risk — STEROID-21-OH Ab), anti-thyroid, type 1 DM, vitiligo, RA, SLE, MG, autoimmune polyglandular syndrome, (d) **iatrogenic** — chemo/radiation/oophorectomy/embolization, (e) **galactosemia, mumps oophoritis** rare, (f) **idiopathic**; (2) **hormone replacement therapy** — **estrogen + progestin (with intact uterus)** until average age of menopause (51) — physiologic replacement, prevents bone loss (osteoporosis), cardiovascular, cognitive, sexual; this is NOT the same as menopausal HRT risk-benefit (younger patients benefit clearly); transdermal estradiol patch + cyclic progestin OR COCP (also acceptable, may be preferred for contraception aspect); (3) **fertility** — spontaneous pregnancy rare (5-10%); **donor egg + IVF** for desired pregnancy; cryopreservation if known cause beforehand; (4) **adrenal insufficiency screen** — esp if autoimmune (cortisol, ACTH-stim); replace if Addison''s; (5) **bone health** — DEXA, Ca/vit D, exercise; HRT prevents loss; (6) **cardiovascular** — lipid, BP, glucose screening; (7) **psychological** — significant emotional impact + identity + sexual + fertility concerns; counseling + peer support; (8) **family screening** — fragile X cascade, autoimmune; (9) **follow-up** — annual + lifestyle + symptoms; (10) Thai context — Thai Menopause Society POI guidelines

---

POI: < 40 yr ovarian failure. Workup karyotype, FMR1, autoimmune. HRT until 51 (physiologic replacement, bone + CV + cognitive). Egg donation for fertility. Bone DEXA. Adrenal screen if AI. Psychological support. Family screen.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 28 ปี มา OPD ด้วยอาการประจำเดือนไม่มา 8 mo + hot flashes + night sweats + vaginal dryness + decreased libido + mood lability

V/S: BP 118/74, HR 80
Gen: thin, no galactorrhea
Lab: FSH 65 (3 occasions ≥ 1 mo apart), estradiol 12, β-hCG negative, prolactin normal, TSH normal, karyotype 46XX, autoimmune panel negative, fragile X carrier negative, AMH undetectable';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge — normal"},{"label":"B","text":"Turner Syndrome (45,XO and variants) — primary amenorrhea + delayed puberty + somatic features"},{"label":"C","text":"Hysterectomy"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Turner Syndrome (45,XO and variants) — primary amenorrhea + delayed puberty + somatic features** — multidisciplinary lifelong care: (1) **diagnostic** — karyotype (standard 45,X + variants — mosaicism 45,X/46,XX; isochromosome Xq; ring X; Y-containing — risk gonadoblastoma → prophylactic gonadectomy); (2) **growth** — **recombinant human growth hormone (rhGH)** during childhood to maximize adult height (start when below 5th percentile or growth velocity declines); (3) **pubertal induction** — **estrogen replacement** start at age 11-12 (or when puberty would be expected) with low-dose transdermal estradiol → titrate up over 2-3 yr → add progestin once breakthrough bleeding or 2 yr → continue lifelong HRT until average menopause age; preserves bone + uterus + sexual; (4) **fertility** — almost universally infertile; counseling — donor egg + IVF possible; cardiac evaluation pre-pregnancy mandatory (aortic dissection risk!!); (5) **cardiovascular** — bicuspid aortic valve (~ 30%), aortic coarctation (~ 10%), aortic root dilation — **echo + cardiac MRI** baseline + serial monitoring; cardiology lifelong; **pregnancy contraindicated if significant aortic enlargement** (dissection risk 100×); (6) **renal** — horseshoe kidney, duplicate ureters, collecting system — renal US baseline; (7) **endocrine** — autoimmune thyroid, T2DM, dyslipidemia screen; (8) **bone** — DEXA, Ca/vit D; (9) **hearing** — chronic otitis media, sensorineural hearing loss — audiology; (10) **gonadectomy** — if Y-chromosome material → prophylactic gonadectomy for gonadoblastoma prevention; (11) **psychological + cognitive** — verbal IQ usually normal, visuospatial weakness; school support + counseling; (12) **transition adult care** + lifelong follow-up; (13) Thai Turner Syndrome family + endocrine clinic

---

Turner 45,XO: primary amenorrhea, short stature, webbed neck, BAV, coarctation, streak ovaries. Multidisciplinary lifelong. rhGH growth, estrogen pubertal induction, lifelong HRT, cardiac (aortic dissection risk pregnancy!), renal, endocrine, hearing, gonadectomy if Y-material, donor egg fertility.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 16 ปี nulliparous มา OPD ด้วยอาการประจำเดือนไม่เคยมา + short stature + webbed neck + shield chest + cubitus valgus + sexual development Tanner 1 breast + sparse pubic hair

V/S: BP 138/82 (R arm), HR 80, height 145 cm (< 3rd %)
Gen: short stature, webbed neck, low hairline, lymphedema feet history, no goiter
Lab: FSH 80, LH 50, estradiol < 20, TSH normal
Karyotype: 45,XO (Turner syndrome)
Echo: bicuspid aortic valve + mild coarctation
US pelvis: streak ovaries + small uterus';

update public.mcq_questions
set choices = '[{"label":"A","text":"Ignore symptoms"},{"label":"B","text":"Adenomyosis (endometrial glands + stroma within myometrium; classification: diffuse vs focal/adenomyoma; AUB-A in PALM-COEIN; pelvic pain + HMB + enlarged uterus + dysmenorrhea + dyspareunia)"},{"label":"C","text":"Hysterectomy without trial of medical therapy"},{"label":"D","text":"Antibiotic alone"},{"label":"E","text":"Methotrexate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Adenomyosis** (endometrial glands + stroma within myometrium; classification: diffuse vs focal/adenomyoma; AUB-A in PALM-COEIN; pelvic pain + HMB + enlarged uterus + dysmenorrhea + dyspareunia): (1) **diagnosis** — clinical + **US (TV)** — asymmetric myometrial wall, myometrial cysts, linear striations, junctional zone thickening; **MRI** — junctional zone > 12 mm characteristic; definitive = histology (hysterectomy specimen historically); (2) **medical management** — symptom-directed: (a) **NSAIDs** for dysmenorrhea; (b) **LNG-IUD (Mirena)** — significant ↓ HMB + dysmenorrhea — first-line uterus-preserving option; (c) **COCP** continuous or cyclic; (d) **progestin** (dienogest, norethindrone, DMPA); (e) **GnRH agonist** (leuprolide) — temporary improvement; **GnRH antagonist (relugolix combo)** new option; (f) **aromatase inhibitor** (letrozole) adjunct; (g) **danazol** historic; (h) **tranexamic acid** for HMB; (3) **conservative surgical** — **uterine artery embolization** (effective + uterus-preserving), **MRgFUS, HIFU**; **adenomyomectomy** (if focal) — fertility-preserving but technically challenging; (4) **definitive — hysterectomy** — for refractory + completed childbearing; can preserve ovaries; (5) **fertility considerations** — adenomyosis associated with subfertility, miscarriage, preterm birth, preeclampsia; pre-IVF GnRH agonist pretreatment may improve outcomes; (6) **shared decision** — fertility desire, age, severity; (7) **multidisciplinary** for severe cases; (8) **iron supplementation** for anemia

---

Adenomyosis: AUB-A. Diffuse vs focal. US/MRI (junctional zone). LNG-IUD first-line uterus-preserving. UAE, MRgFUS alternatives. Hysterectomy definitive. Subfertility + preterm + preeclampsia association. Fertility considerations.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 42 ปี G3P3 มา OPD ด้วยอาการประจำเดือนผิดปกติ — HMB progressively × 2 yr + severe dysmenorrhea + chronic pelvic pain + uterus diffusely enlarged tender on exam

V/S: BP 122/76, HR 80
Pelvic: globular uterus 12 wk size, tender, no adnexal mass
US TV: uterus enlarged + asymmetric thickening of myometrium + ill-defined myometrial cysts + linear striations (heterogeneous) — suggesting **adenomyosis**
MRI: diffuse adenomyosis junctional zone > 12 mm
Endometrial biopsy: benign proliferative';

update public.mcq_questions
set choices = '[{"label":"A","text":"Stop breastfeeding R breast"},{"label":"B","text":"Lactational Mastitis (most commonly Staph aureus including MRSA)"},{"label":"C","text":"Hysterectomy"},{"label":"D","text":"Discharge home — no antibiotic"},{"label":"E","text":"Methotrexate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Lactational Mastitis** (most commonly Staph aureus including MRSA): (1) **continue breastfeeding** — frequent emptying critical; affected breast first to ensure complete drainage; baby safe to feed; pump if too painful; (2) **antibiotics** — empirical anti-staph: (a) **dicloxacillin 500 mg PO QID × 10-14 d** or (b) **cephalexin 500 mg PO QID × 10-14 d** first-line; (c) **MRSA suspected/known** → **TMP-SMX, clindamycin 300 mg PO QID** (caution TMP-SMX with newborn < 1 mo old + jaundice/G6PD); (d) penicillin-allergic — clindamycin, erythromycin; (3) **supportive** — warm compresses + frequent feeding/pumping + NSAIDs (ibuprofen safe + reduces inflammation) + acetaminophen + hydration + rest; (4) **rule out abscess** — fluctuance + fever despite 48-72 hr antibiotics + US → drainage; (5) **breast abscess management** — **US-guided needle aspiration** first (may need repeated) + antibiotics; **I&D** if large, multiloculated, failed aspiration; can continue breastfeeding even with abscess (or pump from affected breast); (6) **predisposing** — cracked nipples, milk stasis, poor latch, oversupply, infrequent feeding, weaning abruptly, immunosuppression; (7) **lactation consultant** — latch + position correction; (8) **inflammatory breast cancer differential** — if recurrent, non-resolving, > 6 wk, peau d''orange → biopsy (IBC mimics mastitis); (9) **prevention** — proper latch, complete emptying, gradual weaning, treat early plugged duct; (10) **counseling** — encourage continued breastfeeding, dispel myth that mastitis requires stopping

---

Lactational mastitis: S aureus often. Continue breastfeeding + empty often. Dicloxacillin/cephalexin 10-14 d. MRSA → clinda/TMP-SMX. Rule out abscess (fluctuance + US). Aspirate abscess. NSAIDs. Lactation consultant. Recurrent → IBC rule out. Don''t stop BF.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 28 ปี G1P1 postpartum d 14 — breastfeeding มาด้วยอาการ painful red swollen R breast + fever 38.5 + chills

V/S: BP 118/74, HR 102, Temp 38.5
Gen: ill-looking
R breast: erythema + warmth + induration + tender wedge-shaped area, no fluctuance
No abscess on US';

update public.mcq_questions
set choices = '[{"label":"A","text":"Start methimazole"},{"label":"B","text":"Postpartum Thyroiditis (PPT)"},{"label":"C","text":"PTU + methimazole combined"},{"label":"D","text":"Radioactive iodine ablation"},{"label":"E","text":"Hysterectomy"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Postpartum Thyroiditis (PPT)** — autoimmune destructive thyroiditis 5-9% of postpartum women within 12 mo postpartum — triphasic pattern (hyperthyroid 1-6 mo → euthyroid → hypothyroid 4-12 mo → permanent in ~ 20-40%); differentiated from **Graves''** by: **low RAIU (PPT)** vs **high RAIU (Graves)**; **TPO Ab+** (PPT); **TRAb negative** (PPT) vs TRAb+ (Graves); (1) **hyperthyroid phase** — usually **mild + transient** — **β-blocker (propranolol 20-40 mg q 6-8 hr)** for symptoms only; **NO antithyroid drugs** (PTU/methimazole) — destructive process, not synthetic excess; (2) **euthyroid intermediate** — observe; (3) **hypothyroid phase** — many transient; **levothyroxine if symptomatic** or planning future pregnancy; recheck off therapy at 6-12 mo; (4) **20-40% develop permanent hypothyroidism** — lifelong levothyroxine; (5) **recurrence** in subsequent pregnancies up to 70% — counsel + screen postpartum; (6) **breastfeeding** — propranolol safe (minimally excreted); levothyroxine safe; methimazole if needed in Graves'' (up to 20 mg/d safe BF); (7) **rule out Graves''** clinically — orbitopathy, large goiter with bruit, TRAb+, high RAIU; Graves'' postpartum needs antithyroid therapy + may impact baby (TRAb crosses placenta); (8) **screening** — TSH at 6 mo postpartum in TPO+ women; pre-conception counseling; (9) **postpartum depression** overlap — thyroid affects mood — screen both; (10) **anemia, weight, fatigue postpartum** — workup thyroid

---

Postpartum thyroiditis: 5-9%. Triphasic pattern. Low RAIU + TPO+ + TRAb- distinguishes from Graves''. Hyper phase: β-blocker only — no antithyroid. Hypo phase: levothyroxine if symptomatic. 20-40% permanent hypothyroid. Recurrence 70%. Breastfeeding safe.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 32 ปี G1P1 4 mo postpartum — มาด้วยอาการน้ำหนักลด + heat intolerance + ใจสั่น + tremor × 2 mo, no goiter

V/S: BP 132/82, HR 116, RR 18, Temp 36.9
Gen: tremor, warm skin, no exophthalmos
Lab: TSH < 0.01, FT4 high, T3 high, TPO Ab positive, TRAb negative, RAIU low (1%), Thyroid US: small + mildly hypoechoic + no nodule';

update public.mcq_questions
set choices = '[{"label":"A","text":"Reassurance — postpartum blues"},{"label":"B","text":"psychiatric emergency — immediate hospitalization"},{"label":"C","text":"Discharge home — observation"},{"label":"D","text":"ECT inappropriate"},{"label":"E","text":"Methotrexate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Postpartum Psychosis** (rare 1-2/1,000 births; psychiatric emergency, suicide + infanticide risk); distinguish from **postpartum blues** (50-80%, mild, transient < 2 wk) and **postpartum depression** (10-15%, > 2 wk, no psychosis): (1) **psychiatric emergency — immediate hospitalization** (psychiatric inpatient, separate mother from infant for safety unless mother-baby unit); (2) **safety assessment** — suicidal + infanticidal risk high (4% suicide, 4% infanticide); never leave alone with baby until risk resolved; (3) **medical workup** — rule out organic — infection, electrolyte, thyroid storm, postpartum eclampsia, autoimmune encephalitis (NMDA-R antibodies — newer recognition), drug withdrawal/intoxication, sleep deprivation; (4) **treatment**: (a) **antipsychotic** — second-generation (olanzapine, quetiapine, risperidone) first-line; (b) **mood stabilizer** — lithium (effective for postpartum mania-psychosis; consider breastfeeding — older guidance avoid, newer monitoring acceptable in select), valproate (avoid in childbearing — teratogenic for future pregnancy), lamotrigine; (c) **ECT** — highly effective, safe in postpartum + breastfeeding — consider for refractory or severe; (d) benzodiazepine for agitation/insomnia short-term; (5) **breastfeeding** — depends on medications + infant safety; some compatible (olanzapine, quetiapine, sertraline); pump + discard while on incompatible; (6) **family + partner involvement** — support, education, safety planning, sleep protection; (7) **discharge planning** — close psychiatric follow-up, family supervision, no driving, safety plan, gradual baby contact; (8) **future pregnancy** — very high recurrence (30-50%); prophylactic mood stabilizer (lithium) starting at delivery; (9) **bipolar disorder** often underlying — long-term psychiatric care; (10) **Thai resources** — 1323 mental health hotline, psychiatric emergency

---

Postpartum psychosis: rare, emergency. Psychiatric hospitalization. Suicide + infanticide risk. Antipsychotic + lithium (or ECT). Rule out organic. Distinguish blues (mild < 2 wk) vs depression (> 2 wk) vs psychosis (delusions, hallucinations, disorientation). 30-50% recurrence next pregnancy → prophylaxis lithium.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 28 ปี G2P2 postpartum d 21 — depression + suicidal ideation + delusions about baby + insomnia + agitation + mood lability

V/S: BP 122/76, HR 90
Gen: agitated, disoriented to time, paranoid affect; expresses ''baby is evil'' delusional belief; suicidal + thoughts of harming baby
No substance use, no fever, neuro exam non-focal
Lab: TSH normal, glucose normal, electrolytes normal, no infection';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge home + observation"},{"label":"B","text":"Severe Ovarian Hyperstimulation Syndrome (OHSS)"},{"label":"C","text":"Diuretic + ignore"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Severe Ovarian Hyperstimulation Syndrome (OHSS)** — iatrogenic complication of ART (gonadotropins + hCG trigger); hCG → ↑ VEGF → vascular permeability → fluid shift third space → hypovolemia + ascites/effusion + hemoconcentration + electrolyte abnormalities + thrombosis + AKI + ARDS + ovarian torsion; pregnancy → endogenous hCG → worsening: (1) **classification**: mild (ovarian enlargement + abdo discomfort), moderate (US ascites + N/V), **severe (clinical ascites, hemoconcentration Hct > 45%, WBC > 15K, Cr > 1.2, AKI, ARDS, VTE)**, critical (tense ascites, severe AKI/ARDS, severe coag, VTE, hemoconcentration Hct > 55%); (2) **admit + treat**: (a) **IV crystalloid** carefully — avoid overload; albumin/HES (controversial); maintain UOP > 0.5 mL/kg/hr; (b) **paracentesis** for tense ascites + dyspnea — symptomatic relief + improves renal/hemodynamics; (c) **thromboprophylaxis** — **LMWH** (high VTE risk) — continue 6 wk postpartum if pregnancy continues; (d) **electrolyte correction** + monitor renal/hepatic; (e) **avoid pelvic exam** (rupture); (f) avoid pregnancy hCG support if not necessary (in this case pregnancy already established); (g) **dopamine agonist (cabergoline)** preventive at trigger reduces severity; (3) **outpatient management** mild-moderate; admit severe; ICU critical; (4) **complications** — VTE (arterial + venous), pleural effusion + ARDS, AKI, hepatic, hemorrhage from rupture ovarian cyst, torsion; (5) **prevention** in future cycles — antagonist protocol, agonist trigger (vs hCG), cycle cancellation if high risk, embryo freeze + transfer in later cycle, lower starting gonadotropin dose; (6) **counseling** — high-risk pregnancy, multidisciplinary

---

Severe OHSS: iatrogenic ART complication. VEGF-mediated capillary leak. Pregnancy worsens (endogenous hCG). Treatment: IV fluid, paracentesis, LMWH thromboprophylaxis (high VTE!), electrolyte, monitor. Critical → ICU. Prevent: antagonist protocol, agonist trigger, freeze-all, cabergoline.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 32 ปี G0P0 trying to conceive 2 yr — diagnosed unexplained infertility, ovarian stimulation with gonadotropins + IVF — มาด้วยอาการ abdominal distention + nausea/vomiting + dyspnea 5 d after egg retrieval

V/S: BP 96/62, HR 110, RR 22, SpO2 95%
Gen: tense ascites + dyspnea
Lab: Hct 50% (hemoconcentration), WBC 16K, Na 132, K 5.2, Cr 1.4 (up from baseline 0.8), AST/ALT mildly elevated, β-hCG 320 (early pregnancy)
US: massively enlarged ovaries 14 cm bilateral + ascites moderate + pleural effusion R';

update public.mcq_questions
set choices = '[{"label":"A","text":"Refuse sterilization"},{"label":"B","text":"Permanent contraception (sterilization) counseling"},{"label":"C","text":"Force sterilization without consent"},{"label":"D","text":"Hysterectomy as sterilization"},{"label":"E","text":"Methotrexate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Permanent contraception (sterilization) counseling** — informed consent for irreversible procedure: (1) **for the woman — tubal sterilization**: (a) **postpartum (immediately after vaginal or C/S delivery)** — bilateral partial salpingectomy (Pomeroy, Parkland) or **bilateral salpingectomy** (preferred now — also reduces ovarian cancer risk, more effective); (b) **interval (not pregnant)** — **laparoscopic bilateral salpingectomy** preferred (gold standard now per ACOG — replaces clip/ring/coag because of ovarian cancer prevention + lower failure); minimally invasive; (c) **Essure (hysteroscopic)** — discontinued 2018 (high complications); (d) Filshie clip, Falope ring, electrocoagulation — older methods; (2) **for the man — vasectomy** — outpatient, less invasive, more effective, faster recovery, lower complication than female sterilization; needs 2-3 mo + semen analysis to confirm azoospermia; (3) **counseling**: (a) **irreversibility** — emphasize permanent; reversal possible but expensive + variable success; (b) **failure rate** — tubal ~ 5/1,000 lifetime (ectopic if fail!); vasectomy ~ 1/2,000; (c) **regret risk** — younger (< 30) higher regret rate; counsel; (d) **alternatives** — LARC (IUD, implant) — > 99% effective, reversible; (e) **STI protection** — neither protects against STI; (f) **no protection from cancer** — except salpingectomy → ovarian cancer reduction; (4) **legal + cultural** — Thai informed consent for sterilization; shared decision; (5) **timing** — postpartum logistically convenient; interval allows reflection; (6) **alternatives discussion** — LARC if any ambivalence; (7) **costs + insurance coverage**; (8) **future fertility considerations** — IVF if regret; (9) **postoperative care** + return to activity

---

Sterilization counseling: irreversibility, failure rate, regret. Bilateral salpingectomy preferred (ovarian cancer prevention). Vasectomy lower risk than female. LARC equally effective + reversible. Thai informed consent. Shared decision. Younger age higher regret.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'คู่สามีภรรยา หญิงอายุ 36 ชาย 38, มี 3 บุตรครบครันถ้วน, มาขอ permanent sterilization counseling — discussing options for husband + wife

V/S: BP 124/76, HR 78
Gen: well, no contraindication
No psychiatric, no coercion, financial situation stable';

update public.mcq_questions
set choices = '[{"label":"A","text":"Observation"},{"label":"B","text":"Vulvar cancer (rare, mostly SCC; subtypes: HPV-related (younger, multifocal) vs non-HPV (lichen sclerosus-related, older); FIGO 2009/2021 staging)"},{"label":"C","text":"Discharge — observation"},{"label":"D","text":"Antibiotic alone"},{"label":"E","text":"Methotrexate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Vulvar cancer** (rare, mostly SCC; subtypes: HPV-related (younger, multifocal) vs non-HPV (lichen sclerosus-related, older); FIGO 2009/2021 staging): (1) **diagnosis** — biopsy of all suspicious vulvar lesions (don''t excise without biopsy first); (2) **staging workup** — exam, vulvar mapping, inguinal node assessment (clinical + US ± FNA), pelvic exam, MRI pelvis/groin, CT chest/abdo/pelvis for advanced; (3) **treatment by stage**: (a) **early (Stage IA — tumor ≤ 2 cm + invasion ≤ 1 mm)** — wide local excision (1 cm margin); no LN dissection (very low risk); (b) **Stage IB-II (> 1 mm invasion or > 2 cm)** — **radical local excision + inguinofemoral lymphadenectomy** (unilateral if tumor lateralized, bilateral if midline within 1 cm or B/L); **sentinel lymph node biopsy** acceptable for tumor < 4 cm + clinically node-negative (GROINSS-V trial); (c) **Stage III-IVA** — multimodal — preop chemoradiation (cisplatin) → less radical surgery; or radical surgery + adjuvant CRT; (d) **Stage IVB** — palliative chemo (cisplatin + paclitaxel) + RT; (4) **adjuvant** — RT if positive margin, LVSI, deep invasion, LN+; (5) **vulvar reconstruction** + multidisciplinary; (6) **HPV vaccination** — primary prevention; (7) **screening + prevention** — treat VIN (vulvar intraepithelial neoplasia), lichen sclerosus monitoring; (8) **follow-up** — exam + lymph node q 3-6 mo × 2 yr, then q 6 mo × 3 yr; (9) **prognosis** — stage-dependent: I 5-yr > 90%, II 80%, III 50-60%, IV 15-30%; nodal involvement major prognostic factor; (10) **counseling** — body image + sexual function + lymphedema + supportive

---

Vulvar cancer: SCC most. Biopsy first. Wide local excision + sentinel/inguinofemoral LN. CRT for advanced. GROINSS-V SLN if < 4 cm + cN0. HPV-related vs non-HPV (lichen sclerosus). Vaccination + VIN treatment prevention. Multidisciplinary + supportive.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 68 ปี postmenopausal มาด้วยอาการ vulvar pruritus + vulvar lesion 2 cm raised + ulcerated × 3 mo, no STI, no rash systemic

V/S: BP 132/82, HR 78
Gen: well, weight stable
Vulva: 2 cm raised ulcerated lesion on R labium majora + groin lymph node mildly palpable R
Biopsy: invasive squamous cell carcinoma (SCC), HPV-related on p16+';

update public.mcq_questions
set choices = '[{"label":"A","text":"Observation"},{"label":"B","text":"Gestational Trophoblastic Neoplasia (GTN) — post-molar"},{"label":"C","text":"Hysterectomy without chemotherapy"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Methotrexate × 1 dose without follow-up"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Gestational Trophoblastic Neoplasia (GTN) — post-molar** — diagnosis (FIGO 2000): (a) plateau hCG × 4 wk, (b) rise hCG × 3 wk, (c) hCG > 6 mo persistent post-evacuation, (d) histology choriocarcinoma; FIGO **stage** I (uterus), II (genital outside uterus), III (lung metastasis), IV (other distant); **WHO/FIGO prognostic score** 0-25+: low risk ≤ 6, high risk ≥ 7 (age, antecedent pregnancy, time interval, pretreatment hCG, tumor size, metastasis location/number, prior failed chemo); (1) **workup** — exam, β-hCG quantitative, CBC/CMP/LFT/Cr/TFT, CXR (lung most common metastasis), CT chest, MRI brain + abdo/pelvis if metastatic, US pelvis; (2) **low-risk GTN (stage I-III + score ≤ 6)** — **single-agent chemotherapy**: (a) **methotrexate** 50 mg/m² IM weekly OR 1 mg/kg IM days 1,3,5,7 + leucovorin rescue days 2,4,6,8 q 2 wk; (b) **actinomycin D** alternative or salvage; ~ 80-90% cure single-agent first-line, salvage second-line; (3) **high-risk GTN (score ≥ 7, stage IV)** — **multi-agent chemotherapy — EMA-CO** (etoposide, methotrexate, actinomycin D, cyclophosphamide, vincristine); EMA-EP for resistant (paclitaxel-platinum); 80-90% cure; (4) **surgery** — hysterectomy for chemo-resistant disease in completed-family women; metastectomy for resistant; (5) **brain metastasis** — high-dose MTX + WBRT + craniotomy (selective); (6) **β-hCG monitoring during/after treatment** — weekly until 3 consecutive negative → monthly × 12 mo; effective contraception throughout; (7) **fertility** — preserved in most after chemo; future pregnancies → early US (recurrence risk ~ 1-2%); (8) **placental site trophoblastic tumor (PSTT)** + epithelioid TT — less chemo-sensitive, surgical management primarily; (9) **referral to GTN center** — Thai network

---

Post-molar GTN: plateau/rise hCG/persistent or choriocarcinoma. FIGO staging + WHO score. Low-risk: MTX or Act-D single-agent. High-risk: EMA-CO. Surveillance β-hCG weekly → monthly × 12 mo. Contraception. Highly chemo-sensitive — > 90% cure. Refer GTN center.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 30 ปี G1P0 mole evacuation 4 mo ago — β-hCG plateau 3,500 × 4 weeks then increased to 4,800, CXR: bilateral pulmonary nodules 1-2 cm, no neurological symptoms

V/S: BP 122/76, HR 88
Gen: well
Lab: β-hCG 4,800, CBC normal, LFT normal, Cr 0.7, CXR: nodules, MRI brain: no metastasis, US pelvis: small uterine echogenic lesions';

update public.mcq_questions
set choices = '[{"label":"A","text":"Cesarean immediately"},{"label":"B","text":"Induction of labor (IOL) with unfavorable cervix Bishop ≤ 6 → cervical ripening"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Antibiotic only"},{"label":"E","text":"Methotrexate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Induction of labor (IOL) with unfavorable cervix Bishop ≤ 6 → cervical ripening** then oxytocin: (1) **mechanical methods** — **transcervical Foley balloon catheter (30-60 mL)** — placed via cervix + inflated; safe, effective, no hyperstimulation risk; outpatient possible; alternative Cook double balloon; combine with oxytocin or misoprostol (FOMO trial — combined faster); (2) **pharmacologic methods** — (a) **prostaglandin E2 (PGE2 dinoprostone)** — vaginal insert (Cervidil 10 mg slow-release × 12 hr) or vaginal gel (Prepidil 0.5 mg q 6 hr × 3 doses); avoid in TOLAC (uterine rupture); (b) **prostaglandin E1 (misoprostol PGE1)** — vaginal 25 mcg q 3-6 hr or oral 25-50 mcg q 2-6 hr — cheaper, effective; AVOID in TOLAC (high rupture risk); start oxytocin at least 4 hr after last dose; (3) **after cervix favorable Bishop > 6** → **oxytocin** infusion start 1-2 mU/min, increase 1-2 mU q 15-30 min, max 30-40 mU/min, titrate to 3-5 strong contractions / 10 min + cervical change; (4) **amniotomy (ARM)** — once cervix favorable + station appropriate; combined with oxytocin shortens labor; (5) **monitoring** — continuous fetal monitoring during IOL; assess contraction pattern, FHR, Bishop progression; (6) **failed IOL** — definitions vary but generally: 24 hr latent failure or 12 hr active + ROM + adequate contractions without progress; consider repeat ripening or C/S based on clinical; (7) **risks** — hyperstimulation (tachysystole > 5 contractions/10 min) + FHR abnormality, uterine rupture (esp prior C/S + PG), longer hospital, infection; (8) **contraindications IOL** — placenta previa, vasa previa, cord prolapse, classical C/S, prior rupture, prior reconstructive surgery, malpresentation, fetal distress; (9) **ARRIVE trial** supports IOL at 39 wk low-risk nullip — does not ↑ C/S

---

IOL unfavorable cervix: ripening (Foley balloon, PGE2, PGE1 miso) → oxytocin + ARM. Continuous monitoring. Failed IOL definitions. ARRIVE supports 39-wk IOL low-risk nullip. Contraindications. Avoid PG in TOLAC. Tachysystole risk.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 30 ปี G1P0 GA 41 wk Bishop score 3 (closed, posterior, 1 cm long, soft, station -3), AFI 8, fetus well, no contraindication to vaginal delivery, no contractions, no ROM

V/S: BP 118/72, HR 86
Fetal: FHR 144, EFW 3,400 g vertex
No prior C/S, no malpresentation, no obstetric indication for C/S';

update public.mcq_questions
set choices = '[{"label":"A","text":"Hysterectomy"},{"label":"B","text":"Anovulatory AUB (AUB-O) — adolescent/young adult"},{"label":"C","text":"Antibiotic only"},{"label":"D","text":"Wait without workup"},{"label":"E","text":"Methotrexate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Anovulatory AUB (AUB-O) — adolescent/young adult**: PALM-COEIN non-structural cause **O = ovulatory dysfunction**; most common AUB in adolescents (immature HPO axis) + perimenopausal; (1) **etiology** — physiologic immature HPO axis (adolescent first 2-3 yr post-menarche), PCOS, hypothalamic dysfunction (stress, exercise, weight), hyperprolactinemia, thyroid (hyper/hypo), early menopause, eating disorders, chronic disease; (2) **workup** — exclude pregnancy (β-hCG), pelvic exam, TSH, prolactin, FSH/LH/E2, total/free testosterone if hirsutism, US, CBC for anemia, coagulopathy in HMB esp adolescent (vWD 13%); (3) **management** — (a) **cycle regulation + prevent endometrial overgrowth** — **cyclic progestin** (medroxyprogesterone 5-10 mg × 10-14 d/mo) or **COCP** (continuous or cyclic — also contraception); (b) **LNG-IUD** for HMB + contraception; (c) **acute HMB** — high-dose estrogen (Premarin 25 mg IV q 4 hr × 24 hr) or high-dose progestin (megestrol 80 mg BID, MPA 20 mg TID), tranexamic acid; (d) **mild** — observation if young + stable + no anemia; (e) **PCOS** management (lifestyle, metformin if indicated); (f) **iron** if anemia; (4) **endometrial sampling** — AUB-O in **women < 45 yr generally not needed** unless persistent (1+ yr unopposed estrogen) or risk factors (obesity, DM, tamoxifen, Lynch); > 45 yr → endometrial biopsy; (5) **counseling** — natural history (immature HPO → resolves over 1-2 yr), avoid endometrial cancer risk by ensuring cyclic shedding; (6) **fertility** — when desired, induce ovulation; (7) **reassurance** for adolescent + parent

---

AUB-O: most common AUB adolescent + perimenopause. PCOS common. Workup: β-hCG, TSH, prolactin, FSH/LH, androgens, US, coag (vWD adolescent). Management: cyclic progestin or COCP. LNG-IUD. Acute HMB: estrogen or progestin. Sampling > 45 or risk factors. Reassurance adolescent immature HPO.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 22 ปี G0P0 มา OPD ด้วยประจำเดือนผิดปกติ — irregular cycles 35-60 d × 2 yr + occasional HMB + no other concerning features, BMI 22, no acne/hirsutism, no galactorrhea

V/S: BP 116/72, HR 76
Gen: well
Lab: β-hCG negative, TSH normal, prolactin normal, FSH 6, LH 5, androgens normal, AMH 3.5 normal, US: normal
Endometrial biopsy: secretory pattern in luteal phase (ovulation occurred but irregular)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Cesarean immediately"},{"label":"B","text":"Slow latent phase / prolonged labor"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Antibiotic only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Slow latent phase / prolonged labor** — Zhang labor curves: active phase = 6 cm, before 6 cm slower; criteria for arrest disorders apply only after 6 cm: (1) **assessment** — confirm contractions adequate (IUPC > 200 MVU/10 min ideal), cervix progress, fetal position, station, suspected CPD; (2) **at 4 cm in IOL with ROM + adequate contractions × 4 hr — not yet arrest by ACOG/SMFM Safe Prevention of Primary C-Section** — active labor starts at 6 cm; allow more time before C/S diagnosis; (3) **continue IOL** — optimize: (a) titrate **oxytocin** to adequate contractions (3-5 in 10 min, > 200 MVU IUPC); (b) **amniotomy** already done; (c) reposition (left lateral, ambulation, peanut ball, position changes); (d) hydration; (e) analgesia (epidural may relax pelvic floor); (4) **continuous fetal monitoring**; (5) **arrest of dilation criteria (ACOG/SMFM)** — **6 cm or more + no cervical change × 4 hr adequate contractions OR 6 hr inadequate contractions** → primary C/S indicated; (6) **failed IOL definitions** — failure to reach active labor after 24 hr ripening + ROM + 12-18 hr oxytocin; (7) **arrest of descent** — fully dilated + push 3-4 hr nullip with epidural (4 multip with epi) before C/S; consider operative vaginal if criteria met; (8) **infection** monitoring — chorioamnionitis with prolonged ROM; (9) **document labor progression + interventions**; (10) **counseling patient** + family about plan

---

Labor arrest definitions per Zhang curves + ACOG/SMFM Safe Prevention. Active labor 6 cm. Arrest dilation at 6+ cm × 4 hr (adequate) or 6 hr (inadequate). Latent phase prolonged ≠ arrest. Failed IOL after adequate trial. Optimize contractions, position, ROM, analgesia. Operative vaginal vs C/S decision.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงตั้งครรภ์ G1P0 GA 39+5 wk on IOL 14 hr — cervix progression latent phase 1 cm → 3 cm over 6 hr → 4 cm at 12 hr → 4 cm at 14 hr (no progression × 4 hr despite adequate contractions q 2-3 min, ROM present 8 hr ago), no signs of infection

V/S: BP 122/76, HR 96, Temp 37.0
Fetal: FHR 144 reactive, station -1, OA
No malpresentation, no obstetric indication for C/S yet';

update public.mcq_questions
set choices = '[{"label":"A","text":"Refuse — old people don''t have sex"},{"label":"B","text":"Female Sexual Dysfunction + Genitourinary Syndrome of Menopause (GSM)"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Refuse — old people don''t have sex"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Female Sexual Dysfunction + Genitourinary Syndrome of Menopause (GSM)** — multifactorial — biopsychosocial approach: (1) **assess** — type (desire/arousal/orgasm/pain), duration, partner factors, stress, mood, libido medications, chronic disease, relationship; PISQ-12 or FSFI for QoL; (2) **GSM (atrophic vaginitis + urinary symptoms)** — first-line management: (a) **vaginal lubricants** (silicone, water-based) — coital; (b) **vaginal moisturizers** (Replens, hyaluronic acid) — regular non-coital use; (c) **vaginal estrogen** (cream, ring, tablet) — most effective for atrophy + dryness; **safe even with breast cancer hx after MDT discussion**; minimal systemic absorption; no need progestin; (d) **DHEA vaginal (prasterone)** — alternative; (e) **ospemifene** SERM oral; (f) **vaginal CO2/Er:YAG laser** — controversial — FDA warning unproven for GSM; (3) **MHT** — systemic HT for vasomotor + GSM + bone (if not contraindicated); (4) **desire/arousal** — flibanserin (premenopausal HSDD), bremelanotide (premenopausal HSDD), testosterone (off-label, low-dose, monitor); (5) **psychosocial** — couple''s therapy, sex therapy (CBT, mindfulness, sensate focus), education, communication; (6) **address contributing factors** — depression (SSRI may ↓ libido — consider bupropion/mirtazapine alternative), chronic disease (DM, thyroid, CV), medications, alcohol, sleep, stress; (7) **pelvic floor PT** — for pain (vaginismus, vulvodynia); (8) **partner factors** — partner ED, communication; (9) **normalize discussion** — sexuality healthy lifelong; respectful inclusive approach (LGBTQ+, single, divorced); (10) **counseling**

---

Female sexual dysfunction + GSM: biopsychosocial. Vaginal estrogen first-line GSM (safe even breast cancer). Lubricants + moisturizers. MHT systemic. Desire: flibanserin, bremelanotide, testosterone off-label. Address mood, meds, relationship. Sex therapy. Normalize discussion lifelong.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 55 ปี postmenopausal × 3 yr มาด้วยอาการ dyspareunia + vaginal dryness + decreased libido + decreased lubrication + orgasm difficulty × 6 mo, partner supportive, relationship stable

V/S: BP 122/74, HR 78
Gen: well, no chronic disease
Pelvic: atrophic vagina + pale mucosa + thin epithelium + decreased rugation + reduced lubrication
No bleeding, no mass
No depression, no anxiety, no SSRI use';

update public.mcq_questions
set choices = '[{"label":"A","text":"Refuse counseling"},{"label":"B","text":"Chorionic Villus Sampling (CVS) counseling"},{"label":"C","text":"Discharge home — no need for screening"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Chorionic Villus Sampling (CVS) counseling** — invasive prenatal diagnostic procedure: (1) **indications** — advanced maternal age, prior chromosomal abnormality, parental balanced translocation, positive screening (NIPT/combined), abnormal US finding, single gene disorders, biochemical disorders, paternity testing; (2) **timing** — 10-13+6 wk (earlier than amniocentesis); (3) **technique** — transabdominal (preferred) or transcervical, US-guided needle to chorionic villi, aspirate 10-25 mg; (4) **testing** — karyotype, FISH (rapid 24-72 hr), **chromosomal microarray (CMA)** preferred (copy number variants), single gene testing, biochemical; (5) **counseling — risks + benefits**: (a) **procedure-related loss** ~ 0.2% (~ 1/500); operator experience-dependent; (b) **bleeding, ROM, infection, FMH** rare; (c) **mosaicism** — placental vs fetal — may require amniocentesis confirmation; (d) **vertical transmission of HIV/HBV/HCV** — risk-benefit, antiretroviral coverage; (e) **maternal isoimmunization** — Anti-D Ig if Rh-negative; (f) **earlier vs amniocentesis** — earlier results allow earlier reproductive decisions, but slightly higher procedure loss; (6) **alternatives** — NIPT (screening only, > 99% T21 detection, lower invasive procedure rate downstream), amniocentesis at 15+ wk (lower loss 0.1%), no testing; (7) **post-CVS care** — rest, watch for bleeding/leaking/cramping/fever, follow-up; (8) **results discussion** — preparation for normal vs abnormal results + reproductive options (continue, prepare, termination — legal in Thailand for fetal genetic disorders per Medical Council); (9) **multidisciplinary** — genetics + MFM + emotional support; (10) **informed consent** documented

---

CVS: 10-13+6 wk, transabdominal preferred. Indications AMA, prior abnormality, screening positive, parental translocation. Karyotype + CMA + FISH. Risks: ~ 0.2% loss, mosaicism. Anti-D if Rh-neg. Alternatives NIPT, amnio. Multidisciplinary + informed consent. Reproductive options including termination legal in Thailand.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงตั้งครรภ์ G2P1 GA 11 wk advanced maternal age 38 + prior child with chromosome translocation — counseled CVS for prenatal diagnosis

V/S: BP 116/74, HR 80
Gen: well
Fetal: heart 158, CRL appropriate, NT not done yet
Lab: blood group A Rh+, normal CBC, no anticoag';

update public.mcq_questions
set choices = '[{"label":"A","text":"Mendelian = only autosomal recessive"},{"label":"B","text":"Inheritance patterns — important for genetic counseling"},{"label":"C","text":"X-linked recessive — only females affected"},{"label":"D","text":"Mitochondrial paternally inherited"},{"label":"E","text":"Imprinting — same expression both parents"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Inheritance patterns** — important for genetic counseling: (1) **autosomal dominant (AD)** — affected parent → 50% offspring affected (vertical transmission); variable expressivity, incomplete penetrance, anticipation; examples: Marfan, NF1, achondroplasia, Huntington''s, BRCA1/2, Lynch syndrome; (2) **autosomal recessive (AR)** — both carriers (heterozygous) → 25% affected (homozygous), 50% carriers, 25% unaffected; horizontal transmission (siblings); examples: cystic fibrosis, thalassemia, sickle cell, SMA, PKU, Tay-Sachs; consanguinity ↑ risk; (3) **X-linked recessive** — males affected, females carriers; no father-to-son transmission; obligate carrier daughters of affected father; examples: hemophilia A/B, DMD, color blindness, fragile X (males more severely affected), G6PD; (4) **X-linked dominant** — affected females + males; lethal in males some; examples: Rett, vitamin D-resistant rickets, incontinentia pigmenti, fragile X (some); (5) **Y-linked** — father to all sons; rare; (6) **mitochondrial inheritance** — maternal transmission (mitochondria from egg cytoplasm); heteroplasmy → variable expression; examples: MELAS, MERRF, Leber optic neuropathy, mitochondrial myopathy; (7) **imprinting** — parent-of-origin specific expression; **Prader-Willi (paternal 15q11-13 deletion or maternal UPD)** vs **Angelman (maternal del or paternal UPD)** — same locus, different parent; **Beckwith-Wiedemann (11p15)**; UPD = uniparental disomy; (8) **microdeletion syndromes** — sub-microscopic deletions detected by FISH/CMA: **22q11.2 (DiGeorge — cardiac, parathyroid, thymus, palate)**, Williams (7q11), Cri-du-chat (5p-), Smith-Magenis, Miller-Dieker, NF1, WAGR; (9) **CMA (chromosomal microarray)** detects CNV (copy number variants — sub-microscopic) → preferred over karyotype for unexplained intellectual disability/multiple congenital anomalies/AUC; (10) **whole exome sequencing (WES)** — single gene + de novo; (11) **multifactorial/polygenic** — NTD, cardiac defects, cleft lip/palate; recurrence based on empiric data + ethnicity; (12) **genetic counseling** — pedigree, risk assessment, education, reproductive options

---

Inheritance patterns: AD, AR, X-linked rec/dom, Y, mitochondrial (maternal), imprinting (Prader-Willi vs Angelman), microdeletion (22q11.2 DiGeorge). CMA detects CNV preferred over karyotype for unexplained syndromes. WES single gene. Multifactorial empiric. Genetic counseling.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Resident ถามอาจารย์เรื่อง genetics — Mendelian inheritance + X-linked + mitochondrial + imprinting + microdeletion';

update public.mcq_questions
set choices = '[{"label":"A","text":"All antibiotics safe in pregnancy"},{"label":"B","text":"Antimicrobial safety in pregnancy"},{"label":"C","text":"Doxycycline safe throughout"},{"label":"D","text":"Fluoroquinolone preferred"},{"label":"E","text":"TMP-SMX safe 1st trimester"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Antimicrobial safety in pregnancy: (1) **β-lactams** — **safest class** in pregnancy + lactation; penicillins, cephalosporins, carbapenems; treatment of choice for many infections — UTI, GBS, syphilis, chorioamnionitis, endometritis; (2) **macrolides** — **azithromycin** (preferred — best safety; cesarean adjunctive prophylaxis per Tita), erythromycin (estolate ester ↑ cholestatic hepatitis — avoid); clarithromycin avoided 1st trimester (animal teratogenicity); (3) **clindamycin** — safe; useful for endometritis, GBS allergy, anaerobic; (4) **metronidazole** — safe (older 1st trimester caution disproven); BV, trichomoniasis, anaerobic, C diff; alcohol caution disulfiram; (5) **nitrofurantoin** — safe in pregnancy except **avoid at term (36+ wk) + risk neonatal hemolysis G6PD**; UTI/asymptomatic bacteriuria; (6) **TMP-SMX** — **avoid 1st trimester** (folate antagonist — NTD) + **avoid near term** (kernicterus); 2nd trimester ok if indicated (PCP prophylaxis HIV); (7) **fluoroquinolones (cipro, levofloxacin)** — avoid (animal cartilage toxicity, limited human data); use only if no alternative; (8) **tetracyclines (doxycycline)** — **avoid after 14 wk** (teeth staining + bone); short course 1st trimester ok (no fetal calcification yet); (9) **aminoglycosides (gentamicin)** — fetal nephrotoxicity + ototoxicity (streptomycin highest risk) — use when benefit > risk (chorioamnionitis); single daily dosing + therapeutic monitoring; (10) **vancomycin** — safe; GBS allergic + MRSA; (11) **antifungals** — topical azole (clotrimazole, miconazole) safe; **avoid oral fluconazole 1st trimester** (small ↑ cleft palate); amphotericin B safe for systemic; (12) **antiparasitic** — chloroquine + mefloquine safe (malaria prophylaxis/treatment); avoid primaquine + artemisinin 1st trimester; **albendazole/mebendazole** avoid 1st trimester (deworming postpone); (13) **antivirals** — acyclovir/valacyclovir safe (HSV); tenofovir/3TC HIV; oseltamivir flu; remdesivir COVID; (14) **antimycobacterial** — INH, rifampin, ethambutol, pyrazinamide safe (TB); add B6 with INH; streptomycin avoid; (15) **lactation safety** — most safe — LactMed; doxycycline limited use, fluoroquinolones use cautiously

---

Antimicrobials in pregnancy: β-lactams safest. Azithromycin > erythromycin. Clinda + metro safe. Nitrofurantoin avoid at term. TMP-SMX avoid 1st + last trimester. Fluoroquinolone avoid. Doxy avoid > 14 wk. Aminoglycoside risk-benefit. Topical azole safe; oral fluconazole avoid 1st tri. Acyclovir safe. TB drugs safe except streptomycin.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Resident ถามอาจารย์เรื่อง antimicrobials in pregnancy + safety profile';

update public.mcq_questions
set choices = '[{"label":"A","text":"Pelvic floor = only skin"},{"label":"B","text":"Pelvic floor anatomy + childbirth injury"},{"label":"C","text":"Levator ani innervated by sciatic"},{"label":"D","text":"DeLancey level I = distal vagina"},{"label":"E","text":"Perineal body irrelevant"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pelvic floor anatomy + childbirth injury: (1) **pelvic floor (urogenital + pelvic diaphragm)**: (a) **levator ani** (innervation S3-S5) — **pubococcygeus, puborectalis, iliococcygeus** — sling support of pelvic organs; (b) **coccygeus** — completes pelvic diaphragm; (c) **deep perineal pouch** — urogenital diaphragm (deep transverse perineal, sphincter urethrae); (d) **superficial perineal** — bulbospongiosus, ischiocavernosus, superficial transverse perineal; (e) **perineal body** — fibromuscular pyramid where multiple muscles converge (key support); (f) **endopelvic fascia** — supports bladder, urethra, rectum, uterus (cardinal, uterosacral, pubourethral ligaments); (2) **DeLancey levels of support**: (a) **Level I** — apical (cardinal + uterosacral) → upper vagina + cervix; failure = uterine/vault prolapse; (b) **Level II** — lateral attachment (paravaginal to arcus tendineus fasciae pelvis ATFP) → midvagina; failure = anterior (cystocele) + posterior (rectocele) compartment; (c) **Level III** — distal (urogenital diaphragm + perineal body) → distal vagina; failure = SUI + perineal descent; (3) **anal sphincter complex** — internal anal sphincter (smooth muscle, autonomic) + external anal sphincter (skeletal, pudendal nerve); (4) **innervation** — pudendal nerve (S2-S4) — main somatic supply pelvic floor + external genitalia; autonomic for bladder/bowel/sexual; (5) **childbirth injury** — pudendal nerve stretch + compression (anal incontinence, urinary incontinence); levator ani avulsion from pubic bone (anterior/posterior prolapse, SUI); perineal lacerations (1st-4th degree); episiotomy controversial (routine not recommended; selective); OASIS (3-4° tears); (6) **risk factors childbirth injury** — operative vaginal (especially forceps), macrosomia, prolonged 2nd stage, midline episiotomy, OP position, Asian ethnicity (smaller introitus); (7) **prevention** — perineal massage antepartum, warm compress 2nd stage, controlled delivery of head, evidence for restrictive episiotomy; (8) **postpartum recovery** — PFPT helps; recovery 3-6 mo; (9) **clinical relevance** — POP, SUI, fecal incontinence, dyspareunia; (10) **imaging** — 3D/4D US, MRI

---

Pelvic floor: levator ani (S3-S5), perineal body. DeLancey 3 levels — I apical (USL/cardinal — vault prolapse), II lateral (ATFP — cystocele/rectocele), III distal (UGD + perineal — SUI). Pudendal S2-S4. Childbirth injury: levator avulsion + pudendal stretch + OASIS. Prevention: warm compress, restrictive episiotomy. PFPT recovery.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Resident ถามอาจารย์เรื่อง pelvic floor anatomy + childbirth-related injury';

update public.mcq_questions
set choices = '[{"label":"A","text":"All imaging contraindicated in pregnancy"},{"label":"B","text":"Imaging in pregnancy"},{"label":"C","text":"Avoid all CT scans"},{"label":"D","text":"MRI uses ionizing radiation"},{"label":"E","text":"Gadolinium safe in pregnancy"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Imaging in pregnancy** — risk-benefit + maternal indication often supersedes fetal concern: (1) **ultrasound** — safest, no ionizing radiation; ALARA principle (minimize thermal/mechanical); first-line for OB + many maternal indications; (2) **MRI** — no ionizing radiation; safe in pregnancy all trimesters per ACOG/ACR (no demonstrated harm); 1.5T or 3T; **gadolinium contrast — avoid in pregnancy** (crosses placenta, gadolinium retention, fetal effects unclear — use only if essential + no alternative); breastfeeding compatible (minimal transfer); (3) **ionizing radiation (X-ray, CT, fluoroscopy, nuclear medicine)**: (a) **risks** — teratogenicity, growth, cancer (LCR — leukemia); (b) **dose thresholds** — < 50 mGy (< 5 rad) — no demonstrated fetal harm (deterministic); cumulative cumulative dose during organogenesis (2-15 wk) matters; (c) **typical doses fetal** (single study): CXR < 0.01 mGy, CT head 0, CT chest 0.1, **CT pulmonary angiogram 0.2-0.7 mGy**, CT abdo/pelvis 8-50 mGy, fluoroscopy variable, mammography 0.4 mGy; (d) **shielding when feasible** (limited utility, more for dose reassurance); (4) **PE workup pregnancy** — CTPA vs V/Q scan — CTPA lower fetal dose, higher maternal breast dose; V/Q higher fetal dose but lower maternal breast dose; both acceptable, individual; (5) **iodinated contrast** — safe in pregnancy + breastfeeding (small theoretical neonatal hypothyroidism — TSH at 2 wk recommended); (6) **gadolinium** — avoid except critical maternal indication (newer studies suggested possible link to stillbirth + childhood inflammatory conditions); (7) **nuclear medicine** — case-by-case; iodine-131 contraindicated (thyroid); (8) **ALARA** — appropriate test, technical optimization (low-dose protocols, fewer phases), shielding; (9) **counseling** — abdominal CT for trauma — benefit overwhelms theoretical risk; **never withhold maternal-indicated imaging**; (10) **breastfeeding** — most contrast safe + minimal transfer; many recommend continue without interruption

---

Imaging pregnancy: US + MRI safe (no radiation). Ionizing < 50 mGy no harm. CT pulm angio fetal dose low. CTPA preferred PE. Iodinated contrast safe; gadolinium avoid. ALARA. Don''t withhold maternal-indicated imaging. Breastfeeding most contrast safe.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Resident ถามอาจารย์เรื่อง imaging in pregnancy — radiation safety + MRI + contrast';

update public.mcq_questions
set choices = '[{"label":"A","text":"Checklists are unnecessary"},{"label":"B","text":"WHO Surgical Safety Checklist"},{"label":"C","text":"Skip checklists"},{"label":"D","text":"Only physicians check"},{"label":"E","text":"Use only in emergency"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **WHO Surgical Safety Checklist** (Haynes NEJM 2009 — reduces mortality + complications ~ 40%) — adapted for OB/cesarean: (1) **Sign In** (before anesthesia induction): (a) patient identity + procedure + consent confirmed, (b) site marked if applicable, (c) anesthesia safety check, (d) pulse ox functioning, (e) **allergies known**, (f) difficult airway/aspiration risk, (g) **blood loss > 500 mL risk** + adequate IV access + blood available (high risk: placenta previa/accreta, prior C/S, twin, macrosomia, anemia); (2) **Time Out** (before skin incision): (a) all team members introduce by name + role, (b) confirm patient + procedure + site + position, (c) anticipated critical events — surgeon (length, blood loss, special equipment), anesthesia (concerns), nursing (sterility, equipment), (d) **antibiotic prophylaxis given within 60 min before incision** (cefazolin pre-skin incision reduces endometritis + wound — pre-incision change in 2010 ACOG; add azithromycin for non-elective C/S — Tita NEJM 2016), (e) essential imaging displayed; (3) **Sign Out** (before patient leaves OR): (a) nurse confirms procedure recorded, (b) instrument/sponge/needle count correct, (c) specimens labeled correctly, (d) equipment problems addressed, (e) recovery + key concerns communicated; (4) **OB-specific modifications**: (a) **fetal status** confirmed pre-incision, (b) **newborn resuscitation team** ready + identified, (c) **uterotonic plan** + PPH risk, (d) **bowel + bladder injury** awareness, (e) **VTE prophylaxis plan**; (5) **culture of safety** — flat hierarchy, speak-up encouraged; (6) **measurement + audit** of checklist compliance + outcomes; (7) **TeamSTEPPS integration**; (8) **debrief** at end of case for learning

---

WHO Surgical Safety Checklist 3 phases: Sign In, Time Out, Sign Out. Reduces mortality + complications. OB modifications: fetal status, NICU team, uterotonic plan, PPH risk. Antibiotic pre-incision cefazolin + azithromycin (non-elective C/S). Culture of safety. Audit. Debrief.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Hospital implements WHO Surgical Safety Checklist on OB unit (cesarean delivery)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Inequities are inevitable"},{"label":"B","text":"Health equity + addressing disparities in OB"},{"label":"C","text":"Refuse non-Thai patients"},{"label":"D","text":"Treat everyone identically without addressing barriers"},{"label":"E","text":"Discharge non-paying patients"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Health equity + addressing disparities in OB**: (1) **acknowledge disparities** — US data: Black maternal mortality 3-4× white; Indigenous high; structural racism + social determinants of health (SDOH) → access, quality, bias; Thailand: rural-urban gap, migrant workers, hill tribes, refugees; (2) **structural racism + implicit bias** — provider education + training (Harvard Implicit Association Test); standardized care reduces variation; (3) **SDOH screening + addressing** — housing, food security, transportation, employment, education, insurance, IPV, immigration status; (4) **language services** — qualified medical interpreter (not family members); written materials in patient language; cultural humility; (5) **community partnership** — doulas (improve outcomes especially marginalized), community health workers, peer support; doula coverage Medicaid expansion; (6) **standardized care + bundles** — AIM safety bundles reduce disparities (uniform application); (7) **respectful maternity care** — WHO statement; patient-centered; consent; cultural sensitivity; (8) **workforce diversity** — recruit + retain underrepresented providers (better outcomes when concordance); (9) **maternal mortality review committees** — disaggregate by race/ethnicity/SES; identify systemic factors; (10) **mental health + substance use** integrated; (11) **immigration + uninsured** — access to ANC; emergency Medicaid; charity care; (12) **LGBTQ+ inclusivity** — transgender pregnancy, lesbian/bi pregnancy, gender-affirming care; (13) **disability** — accessible care; (14) **interpregnancy + postpartum care** — extend Medicaid 1 yr postpartum (US recent expansion); (15) **rural access** — telehealth, regional perinatal centers, transport; (16) **research equity** — include diverse populations; (17) Thai context — National Health Coverage 30-baht universal coverage; migrant workers access challenges; village health volunteers อสม.; (18) **measure + report** disparities; accountability

---

Equity in OB: address disparities, SDOH, language, doulas, community, standardized care + bundles, respectful maternity, workforce diversity, MMRC disaggregated. Postpartum Medicaid extension. Telehealth rural. Thai: 30-baht universal, อสม., migrant access. Measure + report. Implicit bias training.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Initiative addresses disparities + equity in maternal health (racial/socioeconomic disparities in maternal mortality + morbidity)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Skip training"},{"label":"B","text":"Obstetric simulation training"},{"label":"C","text":"Use only didactic teaching"},{"label":"D","text":"Senior staff don''t need training"},{"label":"E","text":"Skip debrief"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Obstetric simulation training** — evidence improves team performance + clinical outcomes: (1) **high-fidelity simulators** — birthing mannequins (SimMom, NoelleS), task trainers (PPH, vacuum, suture), VR; (2) **scenarios**: (a) **shoulder dystocia** — HELPERR drill, team roles, time-keeper, documentation; (b) **eclampsia** — magnesium administration, BP control, airway, fetal monitoring; (c) **massive hemorrhage** — stage-based protocol, uterotonics, balloon, transfusion, surgical; (d) **cord prolapse** — elevation, position, cesarean; (e) **maternal cardiac arrest** — perimortem C/S < 4 min, LUD, ACLS; (f) **shoulder dystocia, OB anesthesia emergencies** (high spinal, LAST, failed intubation), (g) chorioamnionitis sepsis; (3) **debrief after each scenario** — structured, learner-centered (gather/analyze/summarize); psychological safety; identify gaps; (4) **multidisciplinary teams** — obstetricians, midwives, nurses, anesthesia, pediatrics, ancillary; in situ (own units) more transferable; (5) **TeamSTEPPS principles** integrated — closed-loop communication, SBAR, CUS, mutual support; (6) **frequency** — regular (quarterly per ACOG); annual at minimum; new staff orientation; (7) **measurement** — checklists, time to action, communication, outcomes (CMQCC, AIM); link to actual clinical outcomes; (8) **systems learning** — drills uncover equipment, protocol, environment issues — fix → re-test; (9) **simulation faculty training** + curriculum development; (10) **PRACTICE — PRactical Obstetric Multi-Professional Training (PROMPT)** — UK-developed, evidence reduces neonatal HIE, brachial plexus injury, severe shoulder dystocia; (11) **ALSO course** (Advanced Life Support in Obstetrics) — AAFP/ACOG; (12) **evidence** — Bristol PROMPT randomized cluster trial → ↓ adverse outcomes; (13) Thai context — RTCOG, simulation centers (Siriraj, Ramathibodi); national OB simulation initiative

---

OB simulation: high-fidelity scenarios (dystocia, eclampsia, hemorrhage, prolapse, cardiac arrest). Multidisciplinary teams. In situ. Debrief structured + psychological safety. TeamSTEPPS. Regular frequency. PROMPT + ALSO courses. Evidence reduces adverse outcomes (Bristol PROMPT). System learning. Thai simulation centers.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Hospital develops obstetric simulation program — high-fidelity drills for shoulder dystocia, eclampsia, hemorrhage';

update public.mcq_questions
set choices = '[{"label":"A","text":"No intervention needed"},{"label":"B","text":"HBV in pregnancy"},{"label":"C","text":"Cesarean reduces transmission"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Methotrexate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **HBV in pregnancy** — focus on preventing mother-to-child transmission (MTCT): (1) **infant prevention** — **HBV vaccine + HBIG within 12 hr of birth** to all infants of HBsAg+ mothers → reduces transmission > 90%; HBV vaccine series continued (0, 1, 6 mo); post-vaccination serology at 9-12 mo; (2) **maternal antiviral therapy to reduce MTCT** — indicated if **HBV DNA > 200,000 IU/mL (2 × 10^5) in 3rd trimester** (high viral load = ↑ transmission despite immunoprophylaxis); start **tenofovir disoproxil fumarate (TDF) 300 mg/d** from 28-32 wk through delivery + 1-3 mo postpartum (per AASLD); this patient HBV DNA 1.2 × 10^4 → not above threshold but should monitor + recheck 3rd trimester; (3) **monitor** — HBV DNA + ALT each trimester + postpartum (postpartum hepatitis flares — up to 25%, may need antiviral); (4) **avoid invasive intrapartum procedures** — fetal scalp electrode, fetal scalp blood, but C/S not routinely indicated to prevent transmission with immunoprophylaxis + low VL; (5) **breastfeeding safe** with HBV (even with TDF — minimal transfer); reduce nipple cracks (theoretical blood); (6) **partner + family** — screen, vaccinate if susceptible; (7) **HCC surveillance + liver care** — q 6 mo US + AFP (Asian women > 20-30 yr); long-term hepatology; (8) **co-infection screen** — HIV, HCV, HDV (delta), HAV vaccination; (9) **avoid hepatotoxic medications**; (10) **postpartum** — continue antiviral if started; monitor for flare 3-6 mo; (11) Thai context — Universal HBV vaccination birth dose at 0, 2, 4, 6 mo; HBIG availability variable; antiviral access through NHSO; (12) **vertical transmission rates** — HBeAg+ high VL untreated ~ 90%; with prophylaxis vaccine + HBIG + antiviral if high VL → < 1%

---

HBV pregnancy: HBV vaccine + HBIG to infant < 12 hr (universal HBsAg+ mothers). TDF for mother if HBV DNA > 200,000 IU/mL from 28-32 wk. Avoid invasive intrapartum. Breastfeeding safe. C/S doesn''t ↓ MTCT. Postpartum flare risk. HCC surveillance. Family screening + vaccine. Thai universal vaccination 0/2/4/6 mo.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงตั้งครรภ์ G2P1 GA 12 wk first ANC — HBsAg positive (chronic HBV carrier inactive), HBeAg negative, HBV DNA 1.2 × 10^4 IU/mL, ALT WNL, no cirrhosis, no decompensation

V/S: BP 116/72, HR 80
Gen: well
Lab: HBsAg+, HBeAg-, HBV DNA 1.2 × 10^4, anti-HBe+, ALT 28, AST 22, plt 240K, INR 1.0, bilirubin 0.6, US: no cirrhosis';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge — no treatment"},{"label":"B","text":"Active Pulmonary TB in pregnancy"},{"label":"C","text":"Cesarean for everyone"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Methotrexate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Active Pulmonary TB in pregnancy** — treat — untreated TB → worse outcomes (preterm, LBW, transmission, congenital TB rare but devastating): (1) **multidisciplinary** — OB + ID/TB clinic + public health; (2) **isolation** initially until non-infectious (negative pressure room, N95 visitors, until sputum smear negative ~ 2 wk treatment + symptomatic improvement); (3) **first-line antitubercular therapy — RIPE (rifampin, isoniazid, pyrazinamide, ethambutol)** — **safe in pregnancy** (long-standing experience, benefit > risk); 2 mo intensive + 4 mo continuation (rifampin + INH); pyrazinamide standard in pregnancy per WHO (US CDC reserves PZA controversial but trending toward use); (4) **pyridoxine (B6) 25-50 mg/d** with INH (prevents peripheral neuropathy + may help fetal); (5) **streptomycin AVOID** (fetal ototoxicity); other aminoglycosides too; (6) **MDR-TB** — multidisciplinary, second-line drugs with greater toxicity, individualized; bedaquiline + delamanid emerging; (7) **monitoring** — LFT monthly (RIF + INH + PZA hepatotoxic; pregnancy ↑ risk), sputum smear monthly until negative; weight, symptoms; (8) **fetal monitoring** — growth + NST; (9) **delivery** — vaginal preferred; mask if still infectious at delivery (rare with treatment); (10) **neonatal** — examine for congenital TB (rare); if mother infectious at delivery → IPT (isoniazid preventive therapy) + delayed BCG; isolate mother briefly; if mother non-infectious → BCG at birth Thai schedule; (11) **breastfeeding** — safe + encouraged (medications transfer minimal); (12) **postpartum** — continue treatment; postpartum unmasking of HIV-related TB; **screen HIV** mandatory; (13) **contact tracing** — household, workplace; (14) **DOT (directly observed therapy)** for adherence; (15) Thai context — National TB Program + universal access through NHSO + DOTS; refugee + migrant + prison populations elevated risk

---

Active TB in pregnancy: treat with RIPE (rifampin, INH, PZA, ethambutol) — safe. Add B6 with INH. Avoid streptomycin. Monitor LFT. Vaginal delivery + mask if infectious. Neonatal IPT + delayed BCG if mother infectious. Breastfeeding safe. HIV screen. Contact tracing. DOT. Thai National TB Program.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงตั้งครรภ์ G1P0 GA 24 wk first ANC ตอน 24 wk — มาด้วยอาการ chronic cough + weight loss + night sweats + low-grade fever × 2 mo, no foreign travel

V/S: BP 116/72, HR 92, RR 18, Temp 37.4
Gen: thin, BMI 17, no LAN
Fetal: FHR 144, EFW 600 g (50th)
Lab: HIV negative, Sputum AFB smear 3+, Xpert MTB/RIF positive — rifampin-sensitive, CXR: bilateral upper lobe infiltrates + cavities + no effusion
TST/IGRA positive';

update public.mcq_questions
set choices = '[{"label":"A","text":"Stop all medications"},{"label":"B","text":"Epilepsy in pregnancy"},{"label":"C","text":"Cesarean immediately"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Methotrexate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Epilepsy in pregnancy** — multidisciplinary (neurology + MFM): (1) **risk-benefit** — uncontrolled seizures ↑ maternal/fetal harm (status epilepticus, trauma, SUDEP, hypoxia); medications carry teratogenic risk; (2) **medication review** — **valproate teratogenic** (4-10% major congenital malformations — NTD, cardiac, cleft, neurodevelopmental — autism + lower IQ); **AVOID valproate in women of childbearing age** when possible; in this patient already pregnant + 14 wk past organogenesis (3-8 wk) — damage may be done if going to occur; can switch postpartum + future pregnancies but acute switching mid-pregnancy may destabilize control; (3) **safer AEDs in pregnancy** — **lamotrigine, levetiracetam** lowest teratogenic risk; carbamazepine intermediate; (4) **preconception counseling ideal** — monotherapy lowest effective dose, switch from valproate if possible at least 6-12 mo before, optimize seizure control 9-12 mo seizure-free; (5) **folate supplementation** — **high-dose 4-5 mg/d** from preconception (1 mg/d at minimum here as already pregnant — too late for NTD primary prevention but continue); (6) **detailed anatomy scan at 18-22 wk** + fetal echo (cardiac); MSAFP for NTD; (7) **AED levels monitoring** — pregnancy ↓ levels (especially lamotrigine — increased clearance, levetiracetam) → adjust dose based on level + clinical to maintain seizure control; (8) **vitamin K** late pregnancy 10 mg/d (controversial for enzyme-inducing AEDs); (9) **labor** — continue AED; risk of seizure during labor; IV access; if seizes → lorazepam IV + magnesium not first choice (unless eclampsia); (10) **delivery** — vaginal usually; epidural OK; avoid pethidine (lowers threshold); (11) **postpartum** — sleep deprivation seizure trigger — partner support; ensure safe baby care plans during seizure; continue AED; level may need adjustment again (rises back); (12) **breastfeeding** — most AEDs compatible (lamotrigine + levetiracetam + carbamazepine OK; valproate also OK; phenobarbital + benzo sedation concern); (13) **neonatal** — withdrawal possible, monitor; vitamin K at birth; (14) **future pregnancy** — switch off valproate to safer AED preconception ideally; switch to monotherapy

---

Epilepsy pregnancy: don''t stop AEDs (uncontrolled seizures > med risk). Valproate teratogenic — switch ideally preconception. Lamotrigine + levetiracetam safest. High-dose folate. Detailed US + fetal echo. AED levels (lamotrigine ↓ in pregnancy). Vit K late. Postpartum sleep + adjust dose. Breastfeeding mostly safe.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 26 ปี G1P0 GA 14 wk underlying generalized tonic-clonic epilepsy on lamotrigine 200 mg BID + valproate 500 mg BID for 5 yr (was on valproate-only initially, lamotrigine added), seizure-free × 2 yr, came for ANC late

V/S: BP 116/72, HR 80
Gen: well
Fetal: heart present, anatomy not yet done
Lab: lamotrigine level adequate, valproate level adequate, folate level low, no anomalies seen on routine US so far';

update public.mcq_questions
set choices = '[{"label":"A","text":"Stop all immunosuppressants"},{"label":"B","text":"IBD (Crohn''s disease) in pregnancy with active flare"},{"label":"C","text":"Cesarean immediately"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Discharge home without action"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **IBD (Crohn''s disease) in pregnancy with active flare** — multidisciplinary (GI + MFM): (1) **principle: active disease ≥ medication risk** — uncontrolled IBD → preterm birth, LBW, FGR, PROM, preeclampsia; aim deep remission preconception + maintain through pregnancy; (2) **continue biologics + immunomodulators** — **infliximab, adalimumab, certolizumab** — safe in pregnancy + relatively safe for newborn (continue throughout — newer data); placental transfer increases 3rd trimester; consider stopping/delaying last dose late pregnancy if disease quiet (timing varies by drug); **vedolizumab, ustekinumab** also acceptable; **azathioprine + 6-MP — continue** (long safety record in pregnancy IBD/transplant); (3) **AVOID** — **methotrexate (teratogen — abortifacient — stop 3 mo before conception)**, **tofacitinib** (no data; avoid); thalidomide; (4) **acute flare management** — corticosteroid (prednisolone or budesonide for ileal Crohn''s), 5-ASA (mesalamine safe), antibiotics carefully (metronidazole short course OK, avoid quinolone), bowel rest if needed; rule out infection (C diff, CMV) — stool culture + C diff PCR; (5) **surgical** — for refractory + complications (abscess, perforation, fistula) — multidisciplinary; (6) **nutrition** — protein, iron, folate (esp on sulfasalazine), B12 (terminal ileal resection), vit D, exclusive enteral or parenteral nutrition if severe; (7) **fetal surveillance** — growth + NST/BPP; (8) **delivery** — **vaginal delivery acceptable** for inactive disease; **C/S** for active perianal disease/rectovaginal fistula; consider for active proctitis (sphincter integrity); (9) **postpartum** — continue medications; flare risk if abruptly stopped; (10) **breastfeeding** — most IBD meds safe (biologics minimal transfer); MTX contraindicated; (11) **newborn live vaccines** — delay rotavirus + BCG if mother was on biologics late pregnancy (live vaccine immunosuppression); other vaccines OK; (12) **counseling** — family planning + recurrence + breastfeeding

---

IBD pregnancy: maintain remission > med risk. Continue biologics (infliximab, adalimumab, vedolizumab, ustekinumab), azathioprine. Avoid MTX + tofacitinib. Flare: steroid, 5-ASA, treat infection (C diff). Vaginal usually; C/S if perianal/rectovaginal. Postpartum continue. Breastfeeding mostly safe. Delay live vaccines if biologic late.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 30 ปี G1P0 GA 24 wk underlying Crohn''s disease in remission on infliximab + azathioprine — มาด้วย mild abdominal pain + bloody diarrhea (3 times/d) × 1 wk

V/S: BP 118/72, HR 88, Temp 37.3
Gen: well-appearing
Abdomen: mild RLQ tenderness, no peritonitis
Fetal: FHR 148 reactive, EFW 600 g
Lab: CBC: Hb 10.5, WBC 9.2, CRP 18, fecal calprotectin 280, stool culture pending
MRI abdomen: terminal ileal active inflammation';

update public.mcq_questions
set choices = '[{"label":"A","text":"Refuse care — only women can be pregnant"},{"label":"B","text":"Transgender + gender-diverse people in OB/GYN care + pregnancy"},{"label":"C","text":"Refuse care"},{"label":"D","text":"Cesarean only"},{"label":"E","text":"Methotrexate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Transgender + gender-diverse people in OB/GYN care + pregnancy** — affirming, evidence-based, individualized: (1) **language + respect** — use chosen name + pronouns; document gender identity + sex assigned at birth + anatomy; gender-neutral language (''pregnant person'', ''chestfeeding''); ask preferences for body parts; (2) **preconception planning** — multidisciplinary (gender-affirming care provider + OB + MFM + mental health); (3) **discontinue testosterone** before conception attempts (testosterone teratogenic — virilizing female fetus; also gonadal suppression); typically stop 3-6 mo before conception; menses + ovulation usually return within months; (4) **fertility preservation** — discuss before initiating hormones if wants biological children — oocyte/embryo cryopreservation; (5) **conception** — natural with male partner OR donor sperm + insemination/IVF + reciprocal IVF (partner egg into trans-man uterus); (6) **prenatal care** — same evidence-based ANC; pelvic exam may be traumatic (chest binders, prior surgery, dysphoria) — trauma-informed care + minimize unnecessary exam + accommodations; mental health screen (high rates depression/anxiety); chest dysphoria + chest binding during pregnancy; (7) **previous chest masculinization (top surgery)** — may preclude chestfeeding; assess + counsel; (8) **delivery** — preferred environment (room placement, staff briefed, name/pronouns); same OB indications for vaginal vs C/S; (9) **postpartum + chestfeeding** — chestfeeding possible if breast tissue retained; testosterone resumption depends on chestfeeding plans (transfers to milk); (10) **mental health support** — postpartum + identity; (11) **legal + insurance** — gender markers on records affect coverage; advocate for patient; (12) **provider education + bias reduction** — training, allyship, system inclusion; (13) **AAP + ACOG + WPATH SOC 8** — affirming care position; (14) Thai context — emerging legal recognition + growing trans-inclusive clinics; advocacy ongoing

---

Transgender OB care: affirming, individualized, multidisciplinary. Discontinue T pre-conception (teratogenic). Preserve fertility before hormones. Trauma-informed exam. Chest dysphoria. Chestfeeding possible. Mental health support. Provider education. Pronouns + name. WPATH SOC 8 + ACOG + AAP affirming.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Trans-masculine person (assigned female at birth, identifies as male) age 28, taking testosterone for gender-affirming therapy × 3 yr, monthly period stopped, partnered with cis-male, planning pregnancy together via discontinuation of testosterone

V/S: BP 120/74, HR 76
Gen: well
Exam: deferred gender-affirming exam, intact uterus + ovaries + functional, has discussed with partner
Lab: testosterone 320 (mid-range male), normal CBC/CMP
No medical contraindications to pregnancy';

update public.mcq_questions
set choices = '[{"label":"A","text":"Just get pregnant — sort it out later"},{"label":"B","text":"Preconception counseling — optimize health 3-12 mo before pregnancy"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Preconception counseling** — optimize health 3-12 mo before pregnancy: (1) **lifestyle** — **weight loss** (target BMI < 30 ideal — reduces GDM, PE, macrosomia, C/S, anomalies, stillbirth); **smoking cessation** (nicotine, varenicline, NRT acceptable preconception, ↓ preterm + LBW + abruption + IUFD); **alcohol cessation** (no safe amount in pregnancy); avoid recreational drugs; **regular exercise** 150 min/wk; nutrition (Mediterranean diet); (2) **folate supplementation** — **0.4-0.8 mg/d** start ≥ 1-3 mo before conception (prevents NTD by 50-70%); **4-5 mg/d** if prior NTD-affected pregnancy, AED use, diabetes, obesity (some recommendations), malabsorption; (3) **vaccinations** — MMR (4 wk before pregnancy — live), VZV (4 wk before — live), HBV, HPV, Tdap, flu, COVID; (4) **screen + manage chronic conditions**: (a) **HT** — optimize (target < 140/90 or < 130/80) — switch ACEI/ARB/teratogen to labetalol/nifedipine/methyldopa; (b) **DM/prediabetes** — optimize A1c < 6.5%; dietary, metformin if needed, weight loss; (c) **thyroid** — TSH < 2.5; (d) **mental health** — screen + treat depression; (e) **STI screening** — HIV, syphilis, HBV, HCV, GC/CT; (f) anemia + thalassemia screen; (g) cervical cancer screening up-to-date; (4) **family history + genetic carrier screening** — Tay-Sachs, CF, SMA, thalassemia (Thai universal), Hb E, hemoglobinopathies, fragile X; **expanded carrier panel** option; (5) **medication review** — teratogens (warfarin, ACEI/ARB, valproate, isotretinoin, statins — though newer less concerning, methotrexate, etc.) → switch to safer; (6) **dental** — cleaning + treatment (periodontal disease association preterm); (7) **environmental** — toxic exposures, occupation, fish/mercury; (8) **partner involvement** — health, genetic, support; (9) **fertility awareness** — cycle, ovulation, timing; (10) **financial + social** — insurance, leave, support system; (11) **age-related** — AMA counseling; (12) Thai context — RTCOG/MOPH preconception guidelines; thalassemia screening priority

---

Preconception: lifestyle (weight, smoking, alcohol, exercise), folate 0.4-0.8 mg (4-5 if NTD risk), vaccines, chronic disease optimization, genetic carrier screen, medication review (switch teratogens), STI + screening, fertility awareness, partner involvement. Thai: thalassemia screening priority.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 30 ปี G0P0 มา OPD เพื่อปรึกษา preconception care — planning pregnancy ปีนี้ มี chronic conditions: BMI 32, mild HT (130/85 no medication), prediabetes A1c 6.0, smoker 5 cigs/d, occasional alcohol, no folate currently

V/S: BP 132/86, HR 80
Gen: BMI 32
Lab: A1c 6.0, lipid mildly elevated, TSH 2.4 normal, no anemia';

update public.mcq_questions
set choices = '[{"label":"A","text":"No treatment — asymptomatic"},{"label":"B","text":"Asymptomatic Bacteriuria (ASB) in pregnancy"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Wait until 3rd trimester"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Asymptomatic Bacteriuria (ASB) in pregnancy** — treat to prevent pyelonephritis + preterm + LBW: (1) **screen** all pregnant women — urine culture at first ANC visit or 12-16 wk (Thai/USPSTF/ACOG); (2) **criteria** — single voided culture > 100,000 CFU/mL of uropathogen (or > 10,000 in catheter specimen); (3) **treat 5-7 days antibiotic** (not single dose for ASB or cystitis in pregnancy unlike non-pregnant); (a) **nitrofurantoin 100 mg PO q 6 hr × 5-7 d** — **avoid at term (≥ 36 wk) — neonatal hemolysis G6PD risk**; (b) **amoxicillin 500 mg PO TID × 7 d** if sensitive; (c) **cephalexin 500 mg PO QID × 7 d**; (d) **TMP-SMX** — **avoid 1st trimester (NTD)** + near term (kernicterus); 2nd trimester OK; (e) **fosfomycin 3 g single dose** — acceptable single-dose alternative; (4) **rationale to treat** — untreated ASB → 25-30% develop pyelonephritis (vs < 5% with treatment); pyelonephritis → preterm, LBW, ARDS, sepsis; (5) **test of cure** urine culture 1-2 wk post-treatment; if positive → repeat treatment; (6) **recurrent UTI** — suppression nitrofurantoin 100 mg QHS for remainder of pregnancy; (7) **acute cystitis** (symptomatic — dysuria, frequency, urgency, no fever/flank pain) — same antibiotic choices, 5-7 d; (8) **group B Strep bacteriuria** — treat at time of detection + GBS prophylaxis in labor + no need to retreat just before delivery; (9) **education** — increased fluids, void after intercourse, wiping front-to-back, cranberry insufficient evidence; (10) **complicated** — diabetic, renal disease, immunocompromised — more careful follow-up + extended treatment

---

ASB in pregnancy: screen + treat to prevent pyelonephritis. 5-7 d antibiotic. Nitrofurantoin (avoid term), amoxicillin, cephalexin, TMP-SMX (avoid 1st tri + term), fosfomycin single. Test of cure. GBS bacteriuria = treat + intrapartum prophylaxis. Recurrent → suppression.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงตั้งครรภ์ G2P1 GA 16 wk ANC routine — urine culture: E. coli > 100,000 CFU/mL — no symptoms (no dysuria, frequency, flank pain), prior history of UTI

V/S: BP 116/72, HR 80, Temp 36.9
Gen: well, no CVA tenderness
Fetal: FHR 144, growth appropriate
U/A: nitrite+, leukocyte+, no hematuria';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge home with PO antibiotic"},{"label":"B","text":"Acute Pyelonephritis in pregnancy"},{"label":"C","text":"Outpatient PO TMP-SMX"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Methotrexate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Acute Pyelonephritis in pregnancy** — admit (high risk maternal sepsis + preterm labor + ARDS): (1) **admit** + IV access + isotonic fluid resuscitation + monitor maternal vitals + uterine activity (toco) + fetal heart rate (NST); (2) **labs** — CBC, CMP, blood + urine cultures pre-antibiotic, lactate, β-hCG (confirm), CRP; (3) **empirical IV antibiotics** within 1 hr (sepsis bundle): (a) **ceftriaxone 1-2 g IV q 24 hr** (first-line, pregnancy-safe, covers most enterobacteriaceae) OR (b) **cefazolin** 1-2 g q 8 hr OR (c) **ampicillin + gentamicin** (broader, watch fetal nephrotoxicity); (d) **avoid fluoroquinolones** (cartilage); (4) **continue IV antibiotic until afebrile 24-48 hr + clinical improvement** → transition to PO based on culture sensitivities (cephalexin, amoxicillin-clav, nitrofurantoin if not late preg) to complete **10-14 d total**; (5) **suppressive nitrofurantoin** for remainder of pregnancy (recurrence > 20%); (6) **tocolytic CAUTION** — preterm contractions may be irritative from pyelo — treat infection + hydration first; avoid β-mimetics (worsens pulmonary edema risk in pyelo); (7) **complications watch** — **ARDS** (15% pyelo pregnancy → respiratory failure — early ICU), septic shock, AKI, abruption, preterm labor; (8) **renal US** if no improvement 48-72 hr (rule out obstruction/abscess/stone — pregnancy hydroureter normal); (9) **follow-up** — test of cure urine cx 1-2 wk after; (10) **recurrence** — investigate structural anomaly (VCUG/US postpartum); (11) **steroids if preterm + delivery imminent**; **MgSO4 neuroprotection if < 32 wk**; (12) Thai universal access through NHSO; admit threshold lower in 1st-2nd trimester

---

Pyelonephritis pregnancy: admit + IV ceftriaxone + supportive. 10-14 d antibiotic. Watch ARDS (15%!), sepsis, preterm. Continue suppression rest of pregnancy. Test of cure. Avoid fluoroquinolones. Renal US if no improvement.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงตั้งครรภ์ G2P1 GA 26 wk มาห้องฉุกเฉินด้วย R flank pain + fever 39.0 + N/V + dysuria × 2 d

V/S: BP 110/68, HR 124, RR 22, Temp 39.0
Gen: ill-looking + R CVA tenderness ++
Fetal: FHR 158 tachycardia
Lab: WBC 18K with left shift, Cr 0.9, BUN 18, CRP 95, lactate 2.4
U/A: nitrite+, leukocyte+, WBC many, RBC few
Urine cx pending';

update public.mcq_questions
set choices = '[{"label":"A","text":"Cesarean immediately"},{"label":"B","text":"ITP in pregnancy"},{"label":"C","text":"Hysterectomy"},{"label":"D","text":"Discharge home — no follow-up"},{"label":"E","text":"Methotrexate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **ITP in pregnancy** (autoimmune anti-platelet Ab destruction; distinguish from gestational thrombocytopenia (mild, plt > 70K, late pregnancy, normalizes postpartum), preeclampsia/HELLP, TTP/HUS, AFLP, DIC, HIV-related): (1) **diagnosis of exclusion** — CBC + smear + LFT + Cr + coag + autoimmune + HIV/HCV; bone marrow not routine (used historically if refractory or atypical); (2) **management by platelet count + bleeding**: (a) **mild (plt > 50K, no bleeding)** — observation + serial monitoring + delivery planning; (b) **moderate-severe (plt < 30K or bleeding)** — treat: **first-line corticosteroid (prednisolone 1 mg/kg/d)** or **IVIG 1 g/kg × 1-2 doses** (faster response, useful pre-delivery); (c) refractory — anti-D (if Rh+), rituximab (case-by-case), splenectomy (2nd trimester safest if needed); (d) **TPO receptor agonist (eltrombopag, romiplostim)** limited data — use cautiously; (3) **delivery threshold platelets**: > 50K for vaginal delivery, > 80K for cesarean, > 80K for epidural/spinal (anesthesia preference, varies — some accept 70K); platelet transfusion if low + bleeding/procedure (less effective in ITP — use IVIG); (4) **mode of delivery** — **maternal indication only** for C/S (ITP not indication); **avoid invasive procedures**: fetal scalp electrode, fetal scalp blood, operative vaginal vacuum (subgaleal hemorrhage in thrombocytopenic neonate); (5) **neonatal — fetal/neonatal alloimmune thrombocytopenia (NAIT) is different**; ITP — maternal Ab crosses placenta — **neonatal thrombocytopenia in 10-30%** of ITP babies; check cord blood plt + serial for 1 wk; treat severe with IVIG + plt transfusion; (6) **delivery in tertiary center** with NICU + blood bank; (7) **avoid NSAIDs** in mother + neonate; (8) **breastfeeding** safe; (9) **future pregnancy** — recurrence; preconception optimization

---

ITP pregnancy: exclude other thrombocytopenia causes. Treat if plt < 30K or bleeding — steroid or IVIG. Delivery: plt > 50K vaginal, > 80K C/S + epidural. Maternal indication for C/S only. Avoid scalp electrode + operative vaginal in thrombocytopenic. 10-30% neonatal thrombocytopenia — monitor + IVIG if severe.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงตั้งครรภ์ G2P1 GA 30 wk มาด้วย easy bruising + petechiae × 2 wk, no recent infection, no medications

V/S: BP 118/72, HR 84
Gen: petechiae lower extremities + buccal mucosa, no bleeding from gums
Fetal: FHR 144 reactive
Lab: Hb 11.2, plt 38K (was 220K pre-pregnancy), WBC normal, peripheral smear: low platelets no schistocytes no immature forms, LFT normal, Cr normal, coag normal, ANA negative, HIV negative, HCV negative, no preeclampsia features
Dx: ITP (immune thrombocytopenia)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue hydroxyurea"},{"label":"B","text":"Sickle Cell Disease (SCD) in pregnancy"},{"label":"C","text":"Hysterectomy"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Discharge — no follow-up"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Sickle Cell Disease (SCD) in pregnancy** — high-risk multidisciplinary (hematology + MFM): (1) **complications** ↑ in pregnancy — vaso-occlusive crisis, acute chest syndrome, infection (encapsulated org), VTE, preeclampsia/HT, FGR, preterm, stillbirth, maternal mortality; (2) **medication review**: (a) **hydroxyurea — discontinue** preconception or at conception (teratogen — limit data, some recent reassuring); (b) **iron chelators** — discontinue (deferasirox teratogen; transition to deferoxamine if needed); (c) **folate 4-5 mg/d** (high turnover); (d) **penicillin prophylaxis** — continue (functional asplenia); (e) **vaccines** — pneumo, Hib, meningo, flu, COVID, Tdap; (3) **transfusion** — **chronic simple/exchange transfusion** if prior severe complication, current complication, IUGR, recurrent crises, prior stroke; goal HbS < 30%; (4) **anticoagulation** — VTE risk — prophylactic LMWH if additional risk (hospitalization, immobility); (5) **fetal surveillance** — anatomy scan, **growth US q 4 wk from 24 wk**, NST/BPP from 28-32 wk (FGR/stillbirth risk); Doppler if FGR; (6) **delivery timing** — 37-39 wk; vaginal preferred + epidural early (pain control + avoid GA — sickling); avoid prolonged labor; (7) **intrapartum** — IV hydration (avoid dehydration), O2, warm, blood available, prophylactic transfusion if low Hb; treat crisis with hydration + analgesia + O2; (8) **infection screening** — sepsis risk; (9) **preeclampsia prevention** — aspirin 81-150 mg/d from 12 wk; (10) **acute chest syndrome** — fever + chest pain + new infiltrate — exchange transfusion + antibiotic + supportive; high mortality if missed; (11) **postpartum** — continue prophylaxis; restart hydroxyurea + chelators; counsel breastfeeding (hydroxyurea avoid); contraception (progestin-only safer; estrogen ↑ VTE — relative contraindication); (12) **neonatal** — newborn screen (in Thailand if available + parental partner status — heterozygous risk for sickle trait baby vs disease); genetic counseling + cascade

---

SCD pregnancy: high-risk. Stop hydroxyurea + chelators. Folate 4-5 mg. Penicillin prophylaxis. Vaccines. Transfusion as needed. VTE prophylaxis. Growth US q 4 wk + NST. Aspirin PE prevention. ACS = exchange transfusion. Delivery 37-39 wk + epidural. Postpartum: restart HU, progestin contraception, genetic counseling.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 26 ปี G1P0 GA 24 wk underlying sickle cell disease (HbSS) on hydroxyurea pre-pregnancy (stopped at conception), prior frequent crises

V/S: BP 118/72, HR 92, Temp 36.9
Gen: well at baseline, no acute crisis
Fetal: FHR 144 reactive, EFW 600 g (50th)
Lab: Hb 7.8, MCV 88, retic 8%, LFT WNL, Cr 0.8, urine protein/Cr 0.18, no infection';

update public.mcq_questions
set choices = '[{"label":"A","text":"Skip all screening"},{"label":"B","text":"Aneuploidy screening counseling"},{"label":"C","text":"Force amniocentesis"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Hysterectomy"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Aneuploidy screening counseling** — pros + cons of each option: (1) **first-trimester combined** (NT + PAPP-A + free β-hCG, 11-13+6 wk) — detection T21 ~ 85%, FPR 5%; widely available + cheaper than NIPT; bonus: NT > 3.5 mm also screens for cardiac defects + other syndromes; PAPP-A low predicts preeclampsia/FGR; provides individualized risk; (2) **second-trimester quad screen** (AFP, hCG, uE3, inhibin A, 15-22 wk) — detection T21 ~ 80%; also AFP for NTD; (3) **integrated/sequential** — combines 1st + quad → highest combined detection; (4) **cell-free DNA (NIPT)** from 10 wk — placental DNA in maternal blood; detection T21 > 99%, T18/T13 ~ 98%; sex chromosome aneuploidies; microdeletions limited; **lower false positive rate** (< 0.5%); cost: more expensive but increasingly available in Thai private; some hospitals offer through NHSO/insurance; **considerations** — fetal fraction (low in obesity, early GA → indeterminate result), mosaicism, twin pregnancies (works but slightly different); (5) **diagnostic testing** — **CVS 11-13+6 wk** or **amniocentesis 15+ wk** — definitive, karyotype + CMA + FISH; ~ 0.1-0.2% loss; (6) **soft markers on US** — nuchal thickness, nasal bone, echogenic intracardiac focus, echogenic bowel, choroid plexus cyst, single umbilical artery — modify risk; (7) **counseling** — discuss: (a) information desired, (b) decision possible based on result, (c) risk willingness, (d) financial, (e) reproductive option preferences (continue, prepare, terminate — legal in Thailand for genetic disorders); (8) **for this patient** — age 32 (intermediate risk), no family history → reasonable options: combined 1st-tri (cheaper, available) + offer NIPT if combined high-risk OR NIPT primary if budget allows; informed shared decision; (9) **follow positive result** with diagnostic CVS/amnio; (10) **don''t pressure**, respect autonomy + ethics

---

Aneuploidy screening choices: combined 1st-tri (NT/PAPP-A/βhCG, 85% T21), quad 2nd-tri (80%), integrated, NIPT (>99% T21, lower FPR, more $). Diagnostic: CVS, amnio. Soft markers. Counseling — informed choice, autonomy. Thai access varies. Follow positive → diagnostic.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงตั้งครรภ์ G1P0 GA 10 wk first ANC — มาขอ aneuploidy screening options ตัดสินใจระหว่าง combined first trimester + NIPT — งบประมาณจำกัด, ไม่มี family history

V/S: BP 116/72, HR 80
Gen: well
Fetal: heart 162, dating consistent
Age 32, no prior abnormal pregnancy';

update public.mcq_questions
set choices = '[{"label":"A","text":"Cesarean for all twins"},{"label":"B","text":"Twin labor + delivery management"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Methotrexate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Twin labor + delivery management** — vertex-vertex twins (DCDA or DCMA) — can attempt vaginal delivery: (1) **planning** — adequate experience operator + team (anesthesia, pediatric × 2, OR ready ถ้า need emergency C/S), IV × 2 large bore, type & cross, blood available, US in room; (2) **continuous CTG** for both twins (dual monitors); (3) **epidural anesthesia recommended** (allows intrauterine manipulation if needed for twin B); (4) **Twin A delivery** — same as singleton vertex; cord clamped; (5) **Twin B management** (critical period): (a) **immediate assessment** — US to confirm presentation (may change after twin A out), FHR, station, position; (b) **if remains vertex + favorable** → ARM + augment + vaginal delivery; (c) **if breech / transverse / non-engaged** → options: (i) **external cephalic version (ECV)** to vertex (50-70% success), (ii) **internal podalic version + breech extraction** (skilled operator, single fetus, intact membranes preferred), (iii) **assisted breech delivery** (frank + complete acceptable; footling less), (iv) **C/S for twin B** — combined vaginal + C/S — minority of cases; (d) **Twin Birth Study (Barrett 2013)** — planned vaginal vs C/S for first twin vertex 32-38 wk — no difference in primary outcome (composite mortality/morbidity); supports planned vaginal; (6) **timing** — deliver twin B within 30 min if possible (cord prolapse, placental separation, fetal distress risks); but no fixed limit if reassuring; (7) **uterotonics** + **active management 3rd stage** (atony + retained placenta risks ↑ in twins); (8) **non-vertex twin A** → planned C/S (cannot deliver vaginally — locked twins risk); (9) **monoamniotic** (MA) twins → planned C/S 32-34 wk (cord entanglement); **MCDA non-TTTS** → planned delivery 36-37 wk; **DCDA** → 38 wk; (10) **counseling** — share Twin Birth Study findings + individualized

---

Twin labor vertex-vertex: vaginal delivery acceptable per Twin Birth Study. Continuous CTG both. Epidural. Twin B: vertex → vaginal; non-vertex → ECV, internal podalic + breech extraction, or C/S. Timing flexible if reassuring. Uterotonics + active 3rd stage. Non-vertex twin A → C/S. MA twins → C/S.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงตั้งครรภ์ GA 38 wk twin pregnancy DCDA, twin A vertex + twin B vertex, both 2,800 g, no other complications

V/S: BP 124/76, HR 84
Fetal: Twin A FHR 144, Twin B FHR 148, both reactive
Cervix: 4 cm dilated, contractions q 3 min — in labor
No prior C/S, no contraindication';

update public.mcq_questions
set choices = '[{"label":"A","text":"Cesarean only — no VBAC discussion"},{"label":"B","text":"VBAC (TOLAC) counseling"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Discharge — no plan"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **VBAC (TOLAC) counseling** — shared decision-making: (1) **success rate ~ 60-80%** with prior LSCS for non-recurring indication (non-reassuring CTG, breech) > 60-70%; lower if prior C/S for arrest disorders, no prior vaginal delivery, BMI > 30, induction needed, > 40 yr; **VBAC calculator** (MFMU) for individualized estimate; (2) **eligibility criteria** — prior **1-2 LSCS low transverse** (or low vertical if known + uncomplicated); singleton; vertex; no other contraindication to vaginal delivery; **adequate facility** — 24/7 OB + anesthesia + OR readiness (decision-to-incision < 30 min); patient preference; (3) **contraindications** — prior classical/T-incision uterine surgery, prior uterine rupture, contraindication to vaginal delivery (previa, vasa previa, malpresentation), unable to access immediate C/S; (4) **risks**: (a) **uterine rupture** ~ 0.5-1% (low transverse 1 prior); ↑ with induction (especially PG), augmentation, > 1 prior C/S, short interpregnancy < 18 mo; classical 4-9%; (b) **failed TOLAC** — emergency C/S ↑ morbidity vs scheduled; (c) **maternal hemorrhage, infection, hysterectomy, transfusion** rates similar to scheduled C/S if successful; higher if failed; (d) **perinatal HIE/death** ~ 0.2% (acute event); vs background; (5) **ERCD risks** — surgical morbidity, longer recovery, future placenta accreta/previa increasing risk each C/S, delayed initial BF, neonatal TTN; (6) **management** — labor in hospital with continuous EFM, IV access, type & screen, immediate C/S available; avoid PG ripening (uterine rupture risk) — use Foley balloon mechanical or oxytocin; cautious oxytocin augmentation; epidural acceptable (doesn''t mask rupture); (7) **signs of rupture** — sudden FHR abnormality (most), abdominal pain, loss of station, vaginal bleeding, hemodynamic instability; (8) **shared decision** — value preferences, future fertility, support; (9) **inter-pregnancy interval** > 18 mo recommended; (10) **uterine scar US**: lower segment thickness ≥ 2.5-3 mm predicts intact (research, not routine)

---

VBAC/TOLAC: success 60-80%. Eligible 1-2 prior LSCS low transverse + singleton vertex + facility ready. Risks: rupture 0.5-1%, failed TOLAC. Calculator individualizes. Avoid PG (use mechanical/oxytocin). Continuous EFM. Sudden FHR abnormality = rupture. Shared decision. IPI > 18 mo.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 28 ปี G2P1 prior LSCS 1 ปี ago — มาขอปรึกษา VBAC ใน pregnancy ใหม่ GA 8 wk, single fetus, no complication

V/S: BP 116/72, HR 76
Gen: well
Prior C/S: low transverse for non-reassuring CTG ใน 1st labor, full-term, recovered uneventfully
BMI 25, no other comorbidity';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue infusion"},{"label":"B","text":"Maternal hypotension after epidural → uteroplacental hypoperfusion → fetal bradycardia"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Methotrexate"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Maternal hypotension after epidural → uteroplacental hypoperfusion → fetal bradycardia** — common epidural side effect from sympathetic blockade: (1) **immediate intrauterine resuscitation** — (a) **left lateral position** (LUD — relieve aortocaval), (b) **IV fluid bolus 500-1,000 mL** crystalloid, (c) **vasopressor** — **phenylephrine 50-100 mcg IV bolus** (preferred — preserves placental flow per current evidence vs ephedrine) OR **ephedrine 5-10 mg IV bolus**; (d) **O2** (controversial — limit), (e) **stop epidural infusion** temporarily; (f) **check** — block level (high spinal? — respiratory failure); (g) **assess for other causes** — abruption (pain, bleeding), uterine rupture if VBAC, cord prolapse, tachysystole; (h) **vaginal exam** — rule out cord, assess progress; (2) **if persistent FHR abnormality > 5-10 min despite resuscitation** → consider expedite delivery (operative vaginal if station + dilation appropriate; C/S otherwise); (3) **prevention** — IV fluid preload + phenylephrine infusion prophylactically (per recent obstetric anesthesia guidelines); slow titration epidural dose; positioning; (4) **other epidural complications** to recognize: (a) **high/total spinal** — respiratory + cardiovascular collapse — intubate, support, fluid, vasopressor; (b) **local anesthetic systemic toxicity (LAST)** — CNS (seizure, AMS) + cardiovascular — **lipid emulsion 20% 1.5 mL/kg IV bolus then infusion** + supportive; (c) **post-dural puncture headache (PDPH)** — positional headache 24-72 hr post-procedure — bed rest + hydration + caffeine + acetaminophen + epidural blood patch ถ้า severe; (d) **epidural hematoma** — back pain + neurologic deficit — emergency MRI + decompression; (e) **infection — abscess, meningitis**; (f) **failed/patchy block** — replace; (g) **shivering, pruritus, urinary retention, fever** common; (5) document + debrief

---

Epidural hypotension → fetal bradycardia: LUD + fluid + phenylephrine (preferred over ephedrine). Stop infusion. Other complications: high spinal, LAST (lipid emulsion), PDPH (blood patch), hematoma, infection, failed block. Document + debrief. Prevention: fluid coload + prophylactic vasopressor.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงตั้งครรภ์ G1P0 GA 38 wk in labor with epidural placed by anesthesia — sudden BP drop, fetal bradycardia

V/S: BP 78/45, HR 105 (post-epidural), RR 18, SpO2 99%
Fetal: FHR 70 bradycardia × 5 min
Cervix: 5 cm dilated, vertex station -1
No bleeding, uterus relaxed';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge home — observation"},{"label":"B","text":"Post-Dural Puncture Headache (PDPH)"},{"label":"C","text":"Hysterectomy"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Post-Dural Puncture Headache (PDPH)** — characteristic postural headache (worse upright, better supine) after dural puncture (spinal anesthesia, accidental dural puncture during epidural, LP, intrathecal injection); ↑ risk with **larger gauge needle, cutting (Quincke) needle vs pencil-point (Whitacre, Sprotte), multiple attempts, younger age, female, lower BMI**; (1) **diagnosis clinical** — postural + frontal/occipital + neck stiffness/photophobia/tinnitus/nausea — typically 24-72 hr post-procedure; (2) **exclude differential** — preeclampsia (BP, proteinuria, vision/RUQ — postpartum can happen up to 6 wk), CVST (cortical vein thrombosis — fixed, no postural), meningitis (fever, neck stiff, AMS — LP if uncertain), subarachnoid hemorrhage, migraine, sinusitis, infection, intracranial mass; (3) **conservative management 24-48 hr** — bed rest, hydration (oral/IV), caffeine 200-300 mg PO BID, analgesia (acetaminophen, NSAIDs, sometimes opioids), antiemetic; abdominal binder; (4) **epidural blood patch (EBP)** — definitive treatment for moderate-severe persistent PDPH (≥ 48-72 hr or earlier if severe disability) — under sterile conditions, inject 15-20 mL autologous blood into epidural space at or just below puncture site → seals dural leak; ~ 70-90% effective first patch; may repeat if needed; (5) **avoid** — diuresis, dehydration; (6) **complications EBP** — back pain, transient infection, rare neurologic; (7) **prevention** — small-gauge pencil-point needles for spinal, careful technique for epidural, identify epidural with loss-of-resistance saline not air (controversial), recognize wet tap promptly + manage; (8) **other measures** — sphenopalatine ganglion block (lidocaine-soaked cotton, minimal risk), occipital nerve block, sumatriptan, hydrocortisone (limited evidence); (9) **follow-up** — most resolve days to weeks; chronic PDPH rare → re-evaluate; (10) document + counsel

---

PDPH: postural HA after dural puncture. Pencil-point needles ↓ risk. Conservative + EBP definitive. Exclude PE, CVST, meningitis. EBP 15-20 mL autologous blood. 70-90% response. Repeat if needed. Bed rest + caffeine + hydration adjunct. Postpartum CVST is critical differential — non-postural HA + neuro signs → imaging.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 28 ปี G1P1 postpartum d 2 — มาด้วยปวดศีรษะรุนแรง postural ↑ when sitting/standing ↓ supine + neck stiffness + photophobia × 24 ชม. Received spinal anesthesia for C/S 2 d ago

V/S: BP 122/76, HR 88, Temp 37.0
Gen: prefer supine, photophobic
Neuro: no focal deficit, no meningismus, no fever, no rash
Lab: WBC 9, CRP normal, LP not done (suspected PDPH not meningitis)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge — observation"},{"label":"B","text":"Vulvar Lichen Sclerosus (LS)"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Vulvar Lichen Sclerosus (LS)** — chronic inflammatory dermatosis, most common postmenopausal women + some prepubertal girls; ~ 5% lifetime risk of vulvar SCC: (1) **first-line — high-potency topical corticosteroid**: **clobetasol propionate 0.05% ointment** — apply nightly × 6-12 wk → taper to 1-2×/wk maintenance; controls itch + inflammation + may reverse architectural changes; (2) **alternative** — tacrolimus or pimecrolimus (topical calcineurin inhibitors) for steroid-sparing maintenance; (3) **avoid** — irritants (perfumed soap, detergents), tight clothing, wipes; cotton underwear; (4) **emollients** (Vaseline) + mild cleansers + sitz baths; (5) **vaginal estrogen** for concurrent GSM (different pathology but coexists); (6) **follow-up** + biopsy + new/persistent/non-responding lesions → rule out **vulvar SCC** (5% lifetime risk); annual gyn exam; (7) **surgery NOT first-line** — destroys tissue; only for adhesions, severe phimosis affecting urination, or biopsy-proven malignancy; (8) **sexual function** — counseling, lubricants, gentle dilation; (9) **psychosocial** — significant QoL impact; support; (10) **prepubertal LS** — also clobetasol; usually improves at puberty; differential — sexual abuse (overlap appearance, evaluate); (11) **co-existing** autoimmune (thyroid, vitiligo, alopecia, pernicious anemia) — screen; (12) **other vulvar dermatoses** ddx — lichen planus (oral, vulvar with vaginal involvement), lichen simplex chronicus, candida, psoriasis, contact dermatitis, EMP, Paget — different management

---

Lichen sclerosus: postmenopausal, vulvar/perianal white plaques + architectural change. Clobetasol nightly → maintenance. Tacrolimus alternative. Avoid irritants. SCC risk 5% — biopsy concerning. No surgery first-line. Co-existing autoimmune screen. Counseling + emollients.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 65 ปี postmenopausal มาด้วย vulvar pruritus + white patches + thinning skin + dyspareunia × 1 yr — examined

V/S: BP 130/82, HR 78
Gen: well
Vulva: well-demarcated white plaques + atrophic thin skin + figure-of-8 pattern around vulva + perianal + loss of architecture (clitoral hood resorption + labia minora fusion partial)
Biopsy: lichen sclerosus (LS) — thin epidermis + hyalinization of upper dermis + lymphocytic infiltrate, no atypia';

update public.mcq_questions
set choices = '[{"label":"A","text":"Ignore — no current cancer"},{"label":"B","text":"Hereditary Breast/Ovarian Cancer Syndrome (HBOC) — BRCA1 mutation"},{"label":"C","text":"Hysterectomy without considering options"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Refuse all care"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Hereditary Breast/Ovarian Cancer Syndrome (HBOC) — BRCA1 mutation** — lifetime risks: breast 50-85%, ovarian 40-60% (BRCA1) or 15-30% (BRCA2); also pancreatic, prostate, melanoma; (1) **multidisciplinary** — genetics + breast onc + gyn-onc + psychiatry; (2) **risk-reducing surgery — BSO**: (a) **risk-reducing salpingo-oophorectomy (RRSO)** recommended at age **35-40 (BRCA1)** or **40-45 (BRCA2)** after childbearing — reduces ovarian cancer 80-95%, breast 50%, all-cause mortality; (b) **risk-reducing mastectomy** option — reduces breast cancer > 90%; psychologic + cosmetic considerations; (3) **surveillance** if surgery deferred or before: (a) breast — clinical exam q 6-12 mo + annual MRI + mammography (alternating) from age 25-30 (start 5-10 yr before youngest family case); (b) ovarian — transvaginal US + CA-125 q 6 mo from 30-35 — limited sensitivity for early ovarian cancer (controversial — RRSO preferred when ready); (4) **chemoprevention** — tamoxifen (BRCA2 more benefit), aromatase inhibitor postmenopause; (5) **lifestyle** — exercise, weight, alcohol moderation, breastfeeding (if pregnancies); (6) **HRT post-RRSO** — for surgical menopause symptoms; short-term estrogen typically OK if no breast cancer (controversial — limited data; counseled benefit/risk); BSO before natural menopause → bone + CV + cognitive impact — HRT until natural menopause age commonly; (7) **reproductive options** — preserve fertility before surgery; **preimplantation genetic testing (PGT-M)** to avoid transmission; (8) **cascade testing** — first-degree relatives 50% risk; offer testing; (9) **insurance + employment** — discrimination concerns (US GINA; Thai variable); (10) **psychological support** + decision aids; (11) **other syndromes** — Lynch (endometrial + ovarian + colon), Li-Fraumeni (TP53), Cowden (PTEN), PALB2, ATM, CHEK2 — moderate-penetrance; (12) Thai context — National Cancer Institute genetic services growing

---

BRCA1 HBOC: lifetime breast 50-85% + ovarian 40-60%. Multidisciplinary. RRSO 35-40 BRCA1 / 40-45 BRCA2 after childbearing. Risk-reducing mastectomy option. Surveillance breast MRI + mammo + CA-125/US. Chemoprevention. HRT post-RRSO. PGT-M. Cascade testing.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 32 ปี nulliparous มา OPD ตรวจคัดกรอง — family history sister breast cancer 38 yr + mother ovarian cancer 52 + maternal aunt breast cancer 45 — genetic testing pending

V/S: BP 118/74, HR 80
Gen: well, no breast mass, no adnexal mass
Mammogram + breast US: normal
Genetic testing (panel): BRCA1 pathogenic mutation positive';

update public.mcq_questions
set choices = '[{"label":"A","text":"No screening needed"},{"label":"B","text":"Cervical cancer screening intervals — ASCCP/USPSTF/Thai guidelines"},{"label":"C","text":"Hysterectomy"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Discharge — no need"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Cervical cancer screening intervals — ASCCP/USPSTF/Thai guidelines**: (1) **screening strategies**: (a) **HPV primary** (preferred USPSTF + WHO) — HPV every 5 yr; (b) **co-testing (HPV + cytology)** every 5 yr; (c) **cytology alone** every 3 yr (alternative); (2) **age**: (a) **start at 21 (cytology) or 25 (HPV primary per ASCCP 2019)**; (b) **stop at 65** if adequate prior negative screening + no high-risk history; (c) **post-hysterectomy** with cervix removed + no history CIN2+ — discontinue; (d) **HIV/immunocompromised** — annual cytology from sexual debut to 65 then individualized; (3) **Thai screening** — Pap or HPV test as part of National Health Coverage; women 30-60 yr; some areas using HPV self-sampling pilots; VIA acceptable alternative low-resource (Thai also use); (4) **for this patient** (40 yr, normal Pap + HPV negative 5 yr ago) — **due for screening now** — HPV (preferred) or co-test; if negative → next in 5 yr; (5) **HPV vaccination** — primary prevention; Thai national program 9-valent or 4-valent for girls grade 5 (~ 11 yr); catch-up to 26; individualized 27-45; reduces high-grade disease; (6) **risk stratification** ASCCP 2019 — risk-based management; (7) **HPV test types** — high-risk genotypes 14 (16, 18, 31, 33, 35, 39, 45, 51, 52, 56, 58, 59, 66, 68); HPV 16/18 separate identification more aggressive workup; (8) **abnormal results** management — colposcopy + biopsy + treatment (LEEP, cone, ablation) per ASCCP risk; (9) **follow-up post-treatment CIN** — HPV + cytology q 6 mo × 2, then annual; (10) **future** — HPV self-sampling, DNA methylation, AI-assisted cytology emerging

---

Cervical cancer screening: HPV primary (preferred) or co-test every 5 yr 25-65 (or cyto alone q 3 yr from 21). Stop 65 if adequate negative + no risk. HIV annual. HPV vaccine prevention. ASCCP risk-based. Thai NHCo. VIA option low-resource. HPV self-sampling emerging.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 40 ปี nulliparous มา OPD ตรวจคัดกรอง cervical cancer — last screening 5 yr ago normal Pap + HPV negative, no symptoms, well

V/S: BP 118/74, HR 80
Gen: well
Pelvic: WNL
Sexual history: monogamous × 10 yr';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge — observation"},{"label":"B","text":"Endometrial Polyp (AUB-P)"},{"label":"C","text":"Hysterectomy"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Endometrial Polyp (AUB-P)** — focal benign overgrowth of endometrial tissue; risk factors: tamoxifen, HRT, obesity, HT, age; symptoms — AUB, intermenstrual, postmenopausal bleeding, infertility (interferes implantation): (1) **diagnosis** — TVS (focal thickening, vascular pedicle), SIS (saline infusion sono — most sensitive), hysteroscopy + biopsy (gold standard); (2) **management** — (a) **hysteroscopic polypectomy** — first-line treatment (diagnostic + therapeutic in one step); send for histology; (b) blind D&C — older + may miss polyp + leave tissue → not recommended; (c) **observation** acceptable for small (< 1 cm) asymptomatic, premenopausal — may regress; (3) **histology** — most benign (~ 95%); **malignancy risk**: ~ 1-2% premenopausal symptomatic, ~ 5-10% postmenopausal symptomatic + ↑ with age, size > 1.5 cm, HT, DM, tamoxifen; → all postmenopausal + symptomatic should be removed; (4) **infertility** — polypectomy improves implantation rates pre-IVF; (5) **AUB workup** — also consider PALM-COEIN — coagulopathy (vWD), ovulatory, endometrial (hyperplasia/cancer), iatrogenic (anticoagulants, IUD), structural; (6) **endometrial sampling** — postmenopausal bleeding any thickness or premenopausal AUB > 45 yr or risk factors → sample; (7) **recurrence** — ~ 13-43%; surveillance; (8) **adjuvant** — LNG-IUD reduces recurrence in tamoxifen-treated patients; (9) **counseling** — explain benign nature, malignancy ddx, future fertility, follow-up; (10) **other PALM-COEIN AUB causes**: A (adenomyosis), L (leiomyoma), M (malignancy + hyperplasia)

---

Endometrial polyp: AUB-P. SIS most sensitive. Hysteroscopic polypectomy diagnostic + therapeutic. Malignancy risk 1-10% (↑ postmenopausal). Tamoxifen-related — LNG-IUD reduces. Recurrence common. PALM-COEIN AUB workup including sampling > 45 yr or postmenopausal.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 48 ปี perimenopausal มา OPD ด้วยอาการ intermenstrual bleeding + heavy menses × 4 mo, no postcoital bleeding, no pelvic pain

V/S: BP 124/78, HR 80
Gen: well
Pelvic: uterus normal size, no adnexal mass
US TV: endometrium 7 mm with focal thickening 8 mm + hyperechoic + intracavitary lesion 1.5 cm visible, no fibroid
SIS (saline infusion sono): confirms endometrial polyp 1.5 cm
Endometrial biopsy: secretory endometrium fragments + polyp fragment without atypia';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge — observation"},{"label":"B","text":"staging FIGO"},{"label":"C","text":"Hysterectomy without staging"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Vaginal cancer** (rare — ~ 1-2% of GYN malignancies; primary vagina = no involvement of cervix or vulva; SCC most common ~ 85%; adenocarcinoma DES-related historically; clear cell DES exposure; melanoma; sarcoma): (1) **staging FIGO**: I — vaginal wall; II — paravaginal; III — pelvic sidewall; IVA — bladder/rectum; IVB — distant; (2) **risk factors** — HPV (high-risk genotypes), prior cervical/vulvar cancer or VAIN, DES (clear cell), smoking, immunosuppression, age; (3) **management by stage + location**: (a) **stage I upper third** — partial vaginectomy + lymphadenectomy (similar to cervical cancer) OR brachytherapy; (b) **stage I lower third** — wide excision + inguinal lymphadenectomy; (c) **stage II-IVA** — **concurrent chemoradiation (CRT)** — external beam pelvic + brachytherapy + cisplatin chemo (similar to cervical cancer); (d) **stage IVB** — palliative chemo + RT; (4) **fertility-sparing** — limited options given typical demographics; (5) **HPV vaccination** — primary prevention; (6) **VAIN treatment** prevents progression — topical 5-FU, laser, excision; (7) **follow-up** — exam + symptoms q 3-6 mo × 2 yr → q 6 mo × 3 yr → annual; (8) **prognosis** — stage I 5-yr ~ 80%, II ~ 50-60%, III ~ 30-40%, IV ~ 10-20%; (9) **multidisciplinary** + supportive care; (10) **vaginal fibrosis + stenosis** post-RT — dilator + vaginal estrogen; (11) **prevention** — HPV vaccine + cervical/vaginal screening; pelvic exam in DES daughters at higher risk

---

Vaginal cancer: rare. HPV-related SCC. FIGO staging. Stage I — surgery or brachytherapy; II-IVA — CRT (similar to cervical). Multidisciplinary. HPV vaccination prevention. VAIN treatment. Post-RT: vaginal dilator + estrogen.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 70 ปี postmenopausal มาด้วยอาการ vaginal bleeding + mass — biopsy: vaginal SCC stage II (involves paravaginal tissue) — pelvic exam tumor 3 cm distal vagina + parametrial involvement clinical

V/S: BP 134/82, HR 80
Gen: well
MRI: 3 cm distal vagina + paravaginal tissue + no nodes
CT: no metastasis';

update public.mcq_questions
set choices = '[{"label":"A","text":"No examination needed"},{"label":"B","text":"Postpartum 6-week visit"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Postpartum 6-week visit** (the ''4th trimester'' — comprehensive postpartum care): (1) **maternal physical** — (a) **BP** + screen postpartum HT (esp if had HT/PE), continue antihypertensive if needed; (b) **uterine involution** — normal size by 6 wk; (c) **lochia** completed; (d) **perineum + C/S incision** healed; (e) **breast** — exam, lactation; (f) **pelvic exam** if indicated (POP, dyspareunia, healing); (2) **mental health screening** — **Edinburgh Postnatal Depression Scale (EPDS)** or PHQ-9 — postpartum depression 10-15%, anxiety, PTSD, psychosis (rare); refer if positive; (3) **contraception** — discuss options: LARC (IUD/implant insertion at this visit common), DMPA, POP, COCP (if not breastfeeding < 6 wk; relative contraindication if exclusive breastfeeding < 6 mo due to milk supply concern), barrier, sterilization; LAM if exclusive BF + amenorrhea + < 6 mo; (4) **breastfeeding** support — supply, latch, problems, weaning plans; lactation consultant; (5) **sexual health** — resumption, dyspareunia (atrophy if breastfeeding — vaginal lubricant), libido, intimate partner relationship; (6) **interpregnancy interval** counseling — optimum > 18-24 mo between pregnancies (reduces preterm, FGR, abruption); (7) **chronic disease follow-up**: (a) **GDM** — 6-12 wk OGTT + lifelong T2DM screening + lifestyle modification; (b) **HT/PE** — BP monitoring + CV risk counseling (4× future CVD); (c) **pregnancy complication** — counseling future pregnancy management (recurrent PE, preterm); (8) **immunizations** — Tdap if not given in pregnancy, MMR/VZV (if non-immune, not while breastfeeding limit), HPV if eligible, COVID/flu; (9) **return to work + childcare** + sleep + social support; (10) **screening** — cervical, breast self-awareness, intimate partner violence, social determinants; (11) **infant** referral — pediatric well-child care, immunizations; (12) **transition to primary care** + reproductive life planning; (13) **ACOG redefines** as transition with earlier visit 2-3 wk + comprehensive 12-wk visit instead of just one 6-wk visit

---

Postpartum 4th-trimester visit: comprehensive — BP, mental health (EPDS), contraception (LARC + LAM), breastfeeding, sex, IPI counseling, chronic disease (GDM OGTT, HT), vaccines, infant care, primary care transition. ACOG now recommends earlier 2-3 wk visit + comprehensive 12 wk.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 30 ปี G2P2 NSD 6 wk postpartum มา OPD ตรวจ postpartum visit — no complaints, breastfeeding well

V/S: BP 122/76, HR 76
Gen: well, healed perineal repair
Fetal/Baby: thriving, breastfeeding well
No bleeding, no infection';

update public.mcq_questions
set choices = '[{"label":"A","text":"No treatment"},{"label":"B","text":"PCOS infertility — ovulation induction"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Discharge — never can conceive"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **PCOS infertility — ovulation induction**: (1) **lifestyle** — **weight loss 5-10%** improves cycles + ovulation + insulin resistance + pregnancy outcomes — first-line; supervised diet + exercise; (2) **first-line ovulation induction — letrozole** 2.5-7.5 mg/d × 5 days (d 3-7 or 2-6) — PCOS Network/ASRM/ACOG preferred over clomiphene (PPCOS II — letrozole superior ovulation + live birth in PCOS); aromatase inhibitor → ↓ estrogen → ↑ FSH → follicular recruitment; (3) **clomiphene citrate** 50-150 mg/d × 5 d — SERM, antiestrogen — alternative; ↓ live birth than letrozole in PCOS; clomiphene-resistant ~ 25%; (4) **metformin** — alone or adjunct — modest effect in PCOS; helpful if insulin resistance, weight loss adjunct; not significantly improve live birth alone; combination with letrozole/clomiphene may help in some; (5) **gonadotropins (FSH ± LH)** — for letrozole/clomiphene failure — risk OHSS + multiple gestation — close monitoring (US + estradiol); (6) **laparoscopic ovarian drilling** — alternative for clomiphene-resistant PCOS; reduces androgen production, restores ovulation; reduces multiple gestation risk vs gonadotropins; (7) **IVF** — for failure of above, age, other infertility factors, OHSS prevention with antagonist protocol + agonist trigger + freeze-all; (8) **monitoring** — US follicle tracking + ovulation confirmation; pregnancy testing; (9) **risks** — OHSS, multiple gestation (especially gonadotropins), pregnancy in PCOS — ↑ GDM, PE, miscarriage, preterm, macrosomia; (10) **counseling** — realistic expectations, stress management, partner involvement; (11) **once pregnant** — early US (dating, viability), GDM screening 24-28 wk + earlier if high risk, growth surveillance

---

PCOS infertility: weight loss first. Letrozole first-line OI (PPCOS II) > clomiphene. Metformin adjunct esp obese/IR. Gonadotropins if fail (OHSS + multiple risk). Ovarian drilling alternative. IVF refractory + freeze-all OHSS prevention. PCOS pregnancy ↑ GDM/PE.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 28 ปี G0P0 PCOS oligomenorrhea + obesity (BMI 32) + insulin resistance + infertility 18 mo — couple ready for ovulation induction

V/S: BP 124/78, HR 80
Gen: BMI 32, hirsutism, acanthosis nigricans
Lab: T total mildly high, FSH 5, LH 12, AMH 8 (high), TSH normal, prolactin normal
Partner semen analysis normal
HSG bilateral tubal patency';

update public.mcq_questions
set choices = '[{"label":"A","text":"Terminate pregnancy"},{"label":"B","text":"Congenital Diaphragmatic Hernia (CDH)"},{"label":"C","text":"Cesarean immediately"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Hysterectomy"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Congenital Diaphragmatic Hernia (CDH)** — abdominal contents herniate into thorax through diaphragmatic defect (Bochdalek 90% posterolateral, Morgagni 10% anterior); pulmonary hypoplasia + pulmonary HT = main mortality drivers: (1) **prenatal counseling — multidisciplinary** (MFM + neonatology + pediatric surgery + cardiac + genetics + ethics + family); (2) **assessment severity** — **LHR (lung-area-to-head circumference ratio) observed/expected** — o/e LHR < 25% severe, 25-45% moderate, > 45% mild; liver position (up = worse), MRI fetal lung volume, side (left more common, less severe than right), associated anomalies (karyotype, CMA — 30-40% genetic syndromes); (3) **outcomes counseling** — survival depends on severity + center experience; severe LHR o/e < 25% historic survival 10-30%; with **fetoscopic endoluminal tracheal occlusion (FETO)** — RCTs (TOTAL trial 2021) show improved survival in severe left CDH; in fetal therapy centers; (4) **antenatal management** — serial growth + monitoring; corticosteroid if preterm; FETO if eligible + severe; (5) **delivery planning** — **tertiary center with ECMO + ped surgery + NICU**; usually term unless complications; vaginal acceptable; immediate neonatal team; (6) **immediate neonatal management** — **DO NOT use bag-mask ventilation** (inflates stomach in thorax — worsens lung compression); **immediate intubation** + gentle ventilation + decompress stomach with NG; permissive hypercapnia, lung-protective strategy; pulmonary HT management (iNO, sildenafil, milrinone); ECMO if refractory; (7) **surgery** — delayed (after stabilization, typically days to 2 wk) — repair defect ± patch; multidisciplinary timing; (8) **prognosis** — pulmonary hypoplasia + PH degree; long-term: feeding issues, GERD, scoliosis, neurodevelopmental, recurrent infections; (9) **counseling** — termination remains option per Thai legal framework for severe anomalies; continue with comfort/palliative if family prefers; (10) **support groups + family resources**

---

Fetal CDH: pulmonary hypoplasia + PH = mortality. LHR o/e severity assessment. FETO (TOTAL trial) improves survival severe left CDH. Delivery tertiary with ECMO + ped surgery. NO bag-mask at birth (stomach inflates). Immediate intubation + decompress + gentle ventilation. Delayed surgical repair. Multidisciplinary counseling including termination option.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงตั้งครรภ์ G1P0 GA 22 wk routine anatomy US — fetal congenital diaphragmatic hernia (CDH) — left-sided, liver up, lung-to-head ratio (LHR) o/e 35% (severe)

V/S: BP 116/72, HR 80
Gen: well
Fetal: heart 144, otherwise normal anatomy except CDH, no other anomalies, normal karyotype + microarray
MRI fetal: confirms CDH + lung volumes';

update public.mcq_questions
set choices = '[{"label":"A","text":"Terminate without counseling"},{"label":"B","text":"Fetal myelomeningocele (open spina bifida)"},{"label":"C","text":"Cesarean immediately"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Hysterectomy"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Fetal myelomeningocele (open spina bifida)** — counseling + intervention options: (1) **multidisciplinary counseling** — MFM + neurosurgery + pediatric surgery + neonatology + genetics + rehabilitation + family — discuss natural history, outcomes, options; (2) **natural history** — Chiari II malformation + hydrocephalus (~ 80% need shunt) + variable lower extremity weakness + neurogenic bladder/bowel + skin issues + cognitive (often normal IQ but learning disabilities); life expectancy improving; (3) **options**: (a) **continuation with planned cesarean at term + postnatal surgical closure within 48 hr** — traditional; (b) **fetal surgery (MOMS trial) — prenatal MMC repair** at 19-25+6 wk in select cases — **reduces need for shunt (40% vs 82%) + improves motor function + improves Chiari II + reverses hindbrain herniation**; criteria — singleton, GA 19-25+6 wk, lesion T1-S1, no kyphosis > 30°, no other anomalies, normal karyotype, no maternal contraindication (BMI < 35, no prior preterm < 37 wk); risks: preterm birth, ROM, uterine dehiscence, future C/S only; (c) **termination of pregnancy** — legal in Thailand for severe fetal anomalies per Medical Council; (d) **expectant + palliative** if family chooses; (4) **fetal surgery centers** — limited in Thailand, may refer regional/international; (5) **delivery** — planned cesarean at term (38 wk) to protect spine if fetal surgery not done or hadn''t done well; vaginal acceptable per some data if not large lesion + no other indication; (6) **prevention** — **folic acid 4-5 mg/d preconception** (high-dose because high risk recurrence); reduces 70% NTD; (7) **postnatal management** — multidisciplinary lifelong (neurosurgery shunt, urology, ortho, PT, education); (8) **recurrence** — 3-4% next pregnancy → high-dose folate + early US + AFP/amnio; (9) **counseling** — informed choice, autonomy, no coercion; (10) MOMS trial criteria + fetal therapy referral if interested

---

Open MMC: multidisciplinary counseling. Options: postnatal repair, prenatal fetal surgery (MOMS trial — reduces shunt + improves motor + Chiari), termination, palliative. Prenatal surgery 19-25+6 wk select criteria. Planned C/S term if postnatal. High-dose folate prevention + next pregnancy. Lifelong multidisciplinary care.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงตั้งครรภ์ G1P0 GA 18 wk — anatomy scan: open spina bifida (myelomeningocele) at L5-S1 + Chiari II + ventriculomegaly + lemon sign (frontal bone deformity) + banana sign (cerebellum)

V/S: BP 116/72, HR 78
Gen: well
Fetal: confirmed open MMC, otherwise normal anatomy, normal karyotype + AFAFP elevated
No other anomalies';

update public.mcq_questions
set choices = '[{"label":"A","text":"Hysterectomy"},{"label":"B","text":"Adolescent HMB with von Willebrand disease (vWD type 1)"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Adolescent HMB with von Willebrand disease (vWD type 1)** — most common bleeding disorder (1%), often underdiagnosed in HMB; ~ 13% of adolescents with HMB have bleeding disorder: (1) **multidisciplinary** — Adolescent Gyn + Hematology; (2) **acute HMB management** — high-dose hormonal: **COCP (continuous high-dose pill — 1 pill BID-TID × 7 d then taper)** OR **high-dose oral progestin** (MPA 20 mg TID × 7 d then taper); **tranexamic acid 1 g PO TID** (effective in vWD + HMB — antifibrinolytic, safe); **IV conjugated estrogen 25 mg q 4-6 hr × 24 hr** for severe; iron supplementation; transfusion if needed; (3) **vWD-specific therapy** for severe bleeding or surgery — **DDAVP (desmopressin) 0.3 mcg/kg IV/SC** — releases vWF from endothelium (effective in type 1; not type 3, variable type 2); **vWF concentrate (Humate-P)** for severe; (4) **maintenance therapy** — (a) **LNG-IUD (Mirena)** — first-line for chronic HMB even in nullip adolescents; ↓ blood loss > 90%; placement may need anesthesia in virgin adolescent; (b) **COCP** continuous or extended cycle — also contraception + cycle regulation; (c) **progestin-only** (POP, DMPA, implant) — if estrogen contraindicated; (d) **tranexamic acid during menses** 1 g TID × 5 d; (5) **family screening** — vWD autosomal dominant; cascade testing first-degree relatives; (6) **lifestyle** — avoid NSAIDs (worsen bleeding — use acetaminophen for dysmenorrhea), aspirin, anticoagulants; medical alert; (7) **pre-procedure/surgery planning** — hematology consult; pre-op DDAVP/vWF concentrate; tranexamic acid; (8) **adolescent-friendly + confidential** + parent involvement; (9) **education** — bleeding disorder, future pregnancy management, dental care; (10) **iron** — PO + IV; (11) **long-term follow-up** — gynecology + hematology

---

Adolescent HMB: workup for bleeding disorder (vWD ~ 13%). Acute: COCP/progestin high-dose, TXA, IV estrogen severe. vWD-specific: DDAVP, vWF concentrate. Maintenance: LNG-IUD, COCP, TXA. Family screening. Avoid NSAIDs/aspirin. Multidisciplinary. Adolescent-friendly.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 14 ปี nulligravid มา OPD ด้วยอาการประจำเดือนผิดปกติ — irregular cycles since menarche 2 yr ago + HMB + dysmenorrhea + 1 month soaking pads + Hb 8.2

V/S: BP 102/68, HR 100
Gen: pallor, no acne/hirsutism, no thyroid
Pelvic: deferred (virgin) — exam external WNL
Lab: β-hCG negative, TSH normal, prolactin normal, vWF Ag + factor VIII + ristocetin cofactor: vWF Ag 35% (mildly low) + RistoCof 32% (low) → von Willebrand disease type 1';

update public.mcq_questions
set choices = '[{"label":"A","text":"BP and CO unchanged in labor"},{"label":"B","text":"Peripartum hemodynamic shifts"},{"label":"C","text":"Spinal anesthesia reduces hemodynamic stress"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Uterine atony improves CO"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Peripartum hemodynamic shifts: (1) **labor 1st stage** — uterine contractions → 300-500 mL blood **autotransfused from uterus to circulation** with each contraction; ↑ cardiac output ~ 20% during contraction; ↑ BP 10-20 mmHg with each contraction; ↑ HR; sympathetic + pain + anxiety contribute; epidural blunts; (2) **labor 2nd stage** — Valsalva pushing → fluctuating preload/afterload; pain → catecholamines; cumulative CO ↑ ~ 50% above pre-pregnancy; (3) **immediately after delivery (3rd stage + early 4th stage)** — placental delivery → loss of low-resistance uteroplacental circuit → ↑ SVR; **autotransfusion 500 mL from contracted uterus → preload increase**; ↑ CO acutely 60-80% above pre-pregnancy for ~ 10-30 min; aortocaval compression relieved (return preload further); **risk decompensation in cardiac disease** here (highest risk delivery + immediate postpartum); (4) **first 24-48 hr postpartum** — diuresis (mobilization of third-space fluid) + lochia + insensible loss; gradual ↓ CO + BP back toward baseline; **risk pulmonary edema in heart disease/severe preeclampsia 24-72 hr postpartum**; (5) **HR** — gradual return to baseline over 1-2 wk; CO returns by 2 wk; (6) **postpartum 1-6 wk** — gradual return of plasma volume, RBC mass, SVR, hormones; uterine involution complete 6 wk; (7) **clinical implications**: (a) **cardiac disease delivery planning** — multidisciplinary, epidural (smooth hemodynamics + assisted 2nd stage to limit Valsalva), avoid aortocaval (LUD), avoid rapid bolus, careful uterotonics (ergometrine vasoconstriction CI in HT/preeclampsia/CAD; carboprost bronchospasm asthma); (b) **postpartum monitoring** — high risk first 24-72 hr — fluid balance, BP, oxygenation, telemetry; (c) **pulmonary edema** risk peripartum; (d) **VTE highest risk first 6 wk postpartum**; (8) **postpartum cardiomyopathy** — present anywhere from late pregnancy to 5 mo postpartum

---

Peripartum hemodynamics: CO ↑ during labor (autotransfusion + sympathetic), peaks immediately postpartum (loss of placental circuit + autotransfusion + relief aortocaval). Risk of cardiac decompensation + pulmonary edema highest in immediate postpartum. Cardiac disease — epidural + assisted 2nd stage + multidisciplinary + monitor 24-72 hr. VTE risk first 6 wk.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Resident ถามอาจารย์เรื่อง peripartum hemodynamics — labor + immediate postpartum cardiovascular changes';

update public.mcq_questions
set choices = '[{"label":"A","text":"Insulin sensitivity unchanged"},{"label":"B","text":"Glucose metabolism in pregnancy"},{"label":"C","text":"GDM caused by maternal insulin overproduction"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"No fetal effect of hyperglycemia"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Glucose metabolism in pregnancy: (1) **early pregnancy** — ↑ insulin sensitivity + ↑ insulin secretion → maternal glycogen + fat storage; fasting glucose ↓ slightly (~ 5-10 mg/dL — fetal/placental glucose demand); (2) **late 2nd-3rd trimester — insulin resistance ↑ 2-3×** due to **placental hormones**: human placental lactogen (hPL), progesterone, prolactin, cortisol, TNF-α, leptin; (3) **normal compensation** — β-cell hyperplasia + insulin secretion ↑ 2-3×; maintains normoglycemia; (4) **GDM** — inadequate β-cell compensation for insulin resistance → hyperglycemia in late pregnancy; risk factors: prior GDM, family DM, obesity, age > 35, ethnicity (Asian ↑), PCOS, prior macrosomia, polyhydramnios; (5) **fetal effects** — maternal hyperglycemia → fetal hyperglycemia (placental glucose transport) → fetal hyperinsulinemia → macrosomia (insulin = anabolic growth factor) + organomegaly + delayed lung maturation (insulin antagonizes cortisol → ↓ surfactant) + neonatal hypoglycemia (insulin persists after birth without glucose supply) + polycythemia (chronic hypoxia stimulates erythropoiesis) + hypocalcemia + hyperbilirubinemia; **stillbirth** risk in poorly controlled; **congenital anomalies** mostly with pregestational DM (organogenesis before GDM dx); (6) **screening** — universal 24-28 wk; (a) 1-step 75g OGTT (IADPSG/ADA — fasting ≥ 92, 1h ≥ 180, 2h ≥ 153 — any 1) — broader detection; (b) 2-step: 50g GCT non-fasting → if abnormal → 100g 3h OGTT (Carpenter-Coustan or NDDG); Thai widely use 100g 3h after 50g screen; (7) **management** — MNT + exercise → insulin if MNT fails; targets fasting < 95, 1h < 140, 2h < 120; (8) **postpartum OGTT 6-12 wk** — 50% develop T2DM lifetime → lifestyle + screen annually; future GDM recurrence; (9) **pregnancy DM2 first dx pregnancy** — may be preexisting unrecognized; ADA recommends 1st-trimester A1c in high-risk; (10) **macrosomia threshold + shoulder dystocia + C/S risks**

---

Pregnancy glucose: early ↑ sensitivity; late insulin resistance from placental hormones (hPL, etc.). GDM = inadequate β-cell compensation. Fetal hyperinsulinemia → macrosomia, hypoglycemia, polycythemia, delayed lung. Screening 24-28 wk OGTT. MNT first, insulin if fail. Postpartum OGTT 6-12 wk. T2DM risk.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Resident ถามอาจารย์เรื่อง glucose metabolism in pregnancy + GDM pathophysiology';

update public.mcq_questions
set choices = '[{"label":"A","text":"Cervical ripening is purely mechanical"},{"label":"B","text":"Cervical ripening + labor initiation"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Oxytocin causes ripening directly"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cervical ripening + labor initiation: (1) **cervix** anatomy — mostly extracellular matrix (collagen I + III, proteoglycans, water); rich in inflammatory cells late pregnancy; transforms from firm closed barrier to soft compliant tube; (2) **late pregnancy biochemical changes** — collagen degradation (↑ matrix metalloproteinases MMP-1, MMP-8), ↓ collagen cross-linking, ↑ glycosaminoglycans (hyaluronan, decorin), inflammatory infiltrate (neutrophils, macrophages → cytokines), water content ↑; (3) **hormones**: (a) **progesterone withdrawal** (relative — functional via PR isoforms) — uterine quiescence ↓, cervix ripens; (b) **estrogen** — ↑ oxytocin receptor + connexin-43 (gap junctions) + PG synthesis; (c) **prostaglandins** (PGE2, PGF2α) — cervical softening + uterine contraction; (d) **CRH** placental → cortisol → cascade; (e) **oxytocin + receptor density** ↑ near term + labor; (4) **stages of cervical change**: softening (consistency), ripening (collagen + water), dilation (active labor); Bishop score quantifies; (5) **labor initiation** — multifactorial; (a) **fetal endocrine signal** — fetal hypothalamic-pituitary-adrenal axis → cortisol → placental ↑ CRH + estriol; (b) **uterine stretch** — gap junctions + receptors; (c) **inflammation** — local + systemic; (d) **circadian** — labor more often at night (melatonin); (6) **uterine contractility** — Ca²⁺-mediated; gap junctions (connexin-43) synchronize myocytes → coordinated contractions; oxytocin + PG amplify; (7) **clinical induction** — **Foley balloon** (mechanical — stretch + PG release endogenous), **PG analogs** (misoprostol, dinoprostone — pharmacologic ripening), **oxytocin** (after favorable cervix); **mifepristone (anti-progesterone)** used for IUFD induction; (8) **Bishop score components** — dilation, effacement, station, consistency, position; > 6-8 favorable; (9) **research** — biomarkers of imminent labor (cervical length, fFN, cytokines, lipidomics)

---

Cervical ripening: collagen breakdown + hyaluronan + inflammation. Labor: progesterone withdrawal + estrogen + PG + CRH cascade + fetal HPA. Multifactorial. Clinical induction: Foley, PG, oxytocin. Bishop score predicts success. Connexin-43 gap junctions coordinate myometrium.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Resident ถามอาจารย์เรื่อง cervical ripening + labor initiation physiology';

update public.mcq_questions
set choices = '[{"label":"A","text":"All hormones equally safe"},{"label":"B","text":"Menopausal HT pharmacology"},{"label":"C","text":"Tamoxifen agonist in breast"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"SERMs all the same"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Menopausal HT pharmacology** + SERMs/SPRMs: (1) **estrogens**: (a) **conjugated equine estrogen (Premarin)** — oral, mixed estrogenic, weak androgens; (b) **estradiol** (oral, transdermal patch, gel, spray, vaginal); transdermal preferred — bypass first-pass hepatic, lower VTE/stroke risk; (c) **vaginal** (cream, ring, tablet, DHEA prasterone) — local for GSM, minimal systemic; (2) **progestins** (essential with intact uterus to oppose estrogen → prevent hyperplasia/cancer): (a) **micronized progesterone** (Prometrium) — preferred safety profile (breast, CV, sleep); (b) **medroxyprogesterone acetate (MPA)** — older synthetic, WHI used; (c) **norethindrone, dydrogesterone** also used; **LNG-IUD** as progestin component option; (3) **combination products** — patches (e.g., Combipatch); pill regimens (cyclic vs continuous); (4) **SERMs (Selective Estrogen Receptor Modulators)** — tissue-specific agonist/antagonist: (a) **tamoxifen** — breast antagonist (cancer treatment + prevention high-risk); endometrial AGONIST (→ ↑ endometrial cancer + polyps + sarcoma — monitor); bone agonist (postmenopausal); ↑ VTE + stroke; vasomotor symptoms ↑; (b) **raloxifene** — breast antagonist (cancer prevention high-risk postmenopausal); bone agonist (osteoporosis); endometrial neutral; ↑ VTE; vasomotor symptoms; (c) **ospemifene** — vaginal AGONIST (GSM dyspareunia treatment); endometrial slight agonist (monitor); (d) **bazedoxifene + CEE (Duavee)** — combined for menopausal + bone; no progestin needed; (5) **SPRMs (Selective Progesterone Receptor Modulators)**: (a) **ulipristal acetate** — emergency contraception + fibroid (hepatotoxicity restriction); (b) **mifepristone** — abortion + Cushing; (6) **bisphosphonates** + **denosumab** + **teriparatide** + **romosozumab** — bone (covered separately); (7) **non-hormonal VMS**: SSRIs/SNRIs (paroxetine, venlafaxine), gabapentin, oxybutynin, clonidine, **fezolinetant** (NK3R antagonist — new 2023); (8) **testosterone** — off-label for female HSDD postmenopausal — low dose, monitor; (9) **risks** — VTE (oral > transdermal), stroke, breast (combined > estrogen only), gallbladder; (10) **WHI reinterpretation** — early initiation (within 10 yr of menopause / < 60 yr) more favorable risk-benefit; individualized

---

Menopausal HT: estrogen (oral + transdermal + vaginal) + progestin (micronized preferred) for uterus. Transdermal lower VTE. SERMs tissue-selective: tamoxifen (breast antagonist + endometrial agonist), raloxifene (breast + endometrial neutral + bone), ospemifene (vaginal). SPRMs: ulipristal, mifepristone. Non-hormonal VMS: SSRIs, gabapentin, fezolinetant. Individualized.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Resident ถามอาจารย์เรื่อง pharmacology — menopausal HT + selective receptor modulators (SERMs, SPRMs)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Maternal immune system rejects fetus"},{"label":"B","text":"Maternal-fetal immunology"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"All autoimmune worsens in pregnancy"},{"label":"E","text":"Hysterectomy"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Maternal-fetal immunology: (1) **fetus = semi-allograft** (50% paternal antigens); maternal immune system tolerates rather than rejects via multiple mechanisms; (2) **maternal-fetal interface** — trophoblast (no classical HLA-A/B, expresses HLA-G/E/F + non-classical), decidua (specialized immune cells), syncytiotrophoblast barrier; (3) **immune tolerance mechanisms**: (a) **regulatory T cells (Tregs)** ↑ — anti-inflammatory; (b) **Th1/Th2 shift** — Th2-biased (anti-inflammatory) during pregnancy; (c) **HLA-G on trophoblast** — inhibits NK + T cells; (d) **uterine NK cells** (uNK — different from peripheral NK) — promote spiral artery remodeling, support not attack trophoblast; (e) **indoleamine 2,3-dioxygenase (IDO)** — depletes tryptophan, inhibits T cell; (f) **progesterone** — immunomodulatory (PIBF, regulates cytokines); (g) **complement regulation** — DAF, MCP, CD59 on trophoblast prevent complement-mediated damage; (4) **trimester immune phases** — 1st trimester pro-inflammatory (implantation), 2nd trimester anti-inflammatory (growth), 3rd trimester pro-inflammatory (labor preparation); (5) **autoimmune diseases** — variable: (a) **flare/improve** — RA often improves (Th2 shift), SLE variable, MS often improves, AS may worsen; (b) **postpartum flares common** — return to baseline immune state; (c) **thyroiditis postpartum** common; (6) **alloimmune complications**: (a) **Rh isoimmunization** — IgG anti-D crosses placenta — hemolytic disease of newborn; (b) **fetal/neonatal alloimmune thrombocytopenia (FNAIT)** — anti-HPA-1a IgG; (c) **neonatal lupus** — anti-Ro/La cross placenta — congenital heart block; (d) **antiphospholipid syndrome (APS)** — recurrent loss, thrombosis; (7) **infection susceptibility** — pregnancy ↑ severity of certain (influenza, varicella, listeria, malaria, COVID-19) due to altered immunity; (8) **vaccines** — inactivated safe (flu, Tdap, COVID); live attenuated avoided (MMR, varicella — pre-pregnancy or postpartum); (9) **HIV** — pregnancy doesn''t worsen disease; vertical transmission key concern; (10) **HELLP/preeclampsia** — abnormal trophoblast invasion + immune dysregulation

---

Maternal-fetal immunology: tolerance via Tregs, Th2 shift, HLA-G, uNK, IDO, progesterone, complement regulation. Trophoblast invasion. Trimester phases. Autoimmune variable in pregnancy; postpartum flares. Alloimmune: Rh, FNAIT, neonatal lupus, APS. Infection susceptibility (flu, listeria, COVID). Inactivated vaccines safe.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Resident ถามอาจารย์เรื่อง maternal immunology + tolerance of fetus + autoimmune in pregnancy';

update public.mcq_questions
set choices = '[{"label":"A","text":"Skip data collection"},{"label":"B","text":"Maternal Mortality + Severe Morbidity Review systems"},{"label":"C","text":"Hide data"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Refuse review"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Maternal Mortality + Severe Morbidity Review systems**: (1) **Maternal Mortality Review Committee (MMRC)** — multidisciplinary committee (OB, midwife, anesthesia, ICU, pathology, public health, social work, community); review all maternal deaths within 1 yr of pregnancy; (2) **case identification** — ICD coding, hospital reports, death certificates, vital statistics linkage, lay report; (3) **review process** — abstract chart + interviews (clinicians, family if appropriate), classify cause + pregnancy-relatedness + preventability + contributing factors (clinician, system, patient, social), identify opportunities + recommendations, track implementation; (4) **classification systems** — WHO ICD-MM (direct, indirect, incidental, unspecified); pregnancy-related vs pregnancy-associated (any cause, expanded definition); (5) **WHO ''Three Delays'' framework** — delay seeking care (knowledge, finances, family), delay reaching care (transport, distance), delay receiving care (facility readiness, staff, supplies); guide system interventions; (6) **near-miss + severe maternal morbidity (SMM)** also reviewed — wider lens for learning (deaths small numerator); (7) **data registry** — standardized variables, anonymized, secure, longitudinal, linked to vital records + neonatal outcomes; (8) **public reporting + accountability** — disaggregated by region/SES/race/ethnicity; address disparities; (9) **action-oriented** — implementation, training, policy change, AIM bundle adoption, telemedicine, transport network; (10) **legal protections** — peer review + confidentiality + immunity from discoverability (varies by jurisdiction; Thai context evolving); (11) **WHO ICD-MM coding standardization**; (12) **integration with global** — Maternal Mortality Estimation Inter-agency Group (MMEIG), UN SDG 3.1 (reduce maternal mortality < 70/100,000 by 2030); Thai progress noted; (13) **community engagement + family disclosure** ethically; (14) **continuous quality improvement cycle (PDSA)** — review → recommendations → implement → measure → re-review

---

MMRC: multidisciplinary review of maternal deaths + SMM. WHO Three Delays framework. Identify preventable + system factors. Data registry. Public reporting + equity. Action-oriented. Legal protections. SDG 3.1 target. Continuous quality improvement.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Thai Ministry establishes National Maternal Mortality Review Committee (MMRC) + perinatal data registry';

update public.mcq_questions
set choices = '[{"label":"A","text":"Quality measures useless"},{"label":"B","text":"Obstetric Quality Measures + Performance Dashboards"},{"label":"C","text":"Hide data from clinicians"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Refuse measurement"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Obstetric Quality Measures + Performance Dashboards**: (1) **rationale** — what''s measured improves; benchmarking; transparency + accountability + patient choice; reimbursement (US — value-based purchasing); (2) **process measures** — antenatal steroids for preterm, GBS prophylaxis, antibiotic timing pre-incision C/S, immediate postpartum LARC, prenatal CRT/PE workup, screening (depression, IPV, GDM); (3) **outcome measures** — NTSV C-section rate (CMS benchmark < 23.6%), VBAC rate, episiotomy rate (Cochrane → restrictive), birth trauma, OASIS, postpartum hemorrhage > 1500 mL, blood transfusion, severe maternal morbidity (CDC 21 indicators), maternal mortality, ICU admission, exclusive breastfeeding rate, neonatal Apgar < 7, NICU admission, perinatal mortality, severe HT treatment within 60 min, ECV success; (4) **balancing measures** — ensure no unintended harm (e.g., reducing C/S doesn''t ↑ perinatal mortality); (5) **patient-reported** — Patient-Reported Outcome Measures (PROM) — birth experience, postpartum recovery, breastfeeding satisfaction; (6) **safety culture** — AHRQ Safety Attitudes Questionnaire; (7) **collaboratives** — California Maternal Quality Care Collaborative (CMQCC) — AIM bundle implementation + benchmarking; AIM nationwide; Joint Commission Perinatal Care measures; Leapfrog; (8) **data governance** — definitions standardized (NTSV = nulliparous + term + singleton + vertex, denominator), risk adjustment, data quality audit; (9) **public reporting** — Hospital Compare (US); CMS Hospital Compare; (10) **provider feedback** — individual + group; bell curve discussions; coaching; (11) **PDSA cycles** — small tests of change; (12) **dashboards real-time** — EMR integration, alerts; (13) **Thai context** — RTCOG quality initiatives, MOPH HA accreditation; (14) **equity** — disaggregate by sociodemographic; address disparities; (15) **rewards/recognition** + financial alignment

---

OB quality measures: process + outcome + balancing + patient-reported. NTSV C/S, severe HT timing, exclusive BF, OASIS, transfusion, SMM. CMQCC + AIM + Joint Commission. Dashboards + real-time + risk adjusted. Feedback + PDSA. Equity disaggregation. Thai HA accreditation.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Hospital implements obstetric quality measure dashboards (NTSV C-section, episiotomy, blood transfusion, severe hypertension treatment timeliness, exclusive breastfeeding)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Cesarean immediately"},{"label":"B","text":"Distinguishing SLE flare vs preeclampsia in pregnancy"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Hysterectomy"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Distinguishing SLE flare vs preeclampsia in pregnancy** — both can present with HT + proteinuria + thrombocytopenia + renal dysfunction — but management + prognosis differ; **may co-exist** — treat both: (1) **features favoring SLE flare**: (a) **complement low (C3/C4)** — falls in active SLE; complement usually NORMAL or ↑ in preeclampsia; (b) **anti-dsDNA rising** — SLE; (c) **active extra-renal manifestations** — arthritis, rash, serositis, hematologic; (d) **urine sediment active** — cellular casts (red cell, granular), dysmorphic RBC; (e) **uric acid normal-to-low** in SLE vs ↑ in preeclampsia; (f) **timing** — can occur any gestation in SLE; preeclampsia after 20 wk; (g) **hypertension less prominent** in flare; (2) **features favoring preeclampsia**: (a) **uric acid markedly elevated**; (b) **normal/↑ complement**; (c) **AST/ALT ↑** (HELLP), LDH ↑ (hemolysis), low fibrinogen; (d) **no active SLE serology**; (e) **fetal growth restriction** with abnormal Doppler; (f) **after 20 wk**; (g) **sFlt-1/PlGF ratio elevated** > 38 (helpful biomarker); (3) **this patient** — low complement + ↑ anti-dsDNA + active SLE serology + uric acid 7.5 borderline → favors **flare more than pure preeclampsia, but may co-exist + severe HT**; (4) **management** — (a) **treat HT** acutely — labetalol/hydralazine; (b) **MgSO4** seizure prophylaxis (if severe features), neuroprotection (< 32 wk); (c) **↑ immunosuppression for flare** — pulse methylprednisolone 500-1000 mg × 3 d if severe lupus nephritis; ↑ azathioprine; continue HCQ + low-dose prednisone; cyclophosphamide avoided pregnancy; mycophenolate avoided; (d) **renal biopsy** rarely needed pregnancy — defer if possible; (e) **fetal surveillance** + delivery planning — at 26 wk balance prematurity vs disease — steroid course + may extend stabilization, but deliver if maternal/fetal deterioration; (f) **postpartum** — high flare risk continues; continue immunosuppression; (5) **multidisciplinary** — rheum + MFM + nephrology + neonatology; (6) **future pregnancy** — preconception planning + control × 6 mo + safer meds + aspirin

---

SLE flare vs preeclampsia: low complement + ↑ anti-dsDNA + active SLE serology + normal uric acid → flare. ↑ uric acid + AST/ALT + sFlt-1/PlGF + abnormal Dopplers → preeclampsia. May co-exist. Treat both. Pulse steroid for flare. MgSO4 + antihypertensive for PE. Multidisciplinary. Preconception planning future.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงตั้งครรภ์ G2P1 GA 26 wk underlying SLE on stable HCQ + low-dose prednisone — มาด้วยอาการ acute new onset BP 160/100, proteinuria 4+, severe headache, plt 110K + Cr 1.1 — รบกวน distinction between SLE flare vs preeclampsia

V/S: BP 160/100, HR 96, RR 18
Gen: malar rash unchanged + arthritis mild active
Fetal: FHR 144 reactive, EFW 750 g (10th percentile — borderline)
Lab: plt 110 (down from 240 baseline), AST/ALT WNL, Cr 1.1, uric acid 7.5, urine protein/Cr 4.5, anti-dsDNA elevated × 3-fold from baseline, low C3/C4, anti-Ro/La positive (known), aPL negative';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge home"},{"label":"B","text":"Postpartum stroke (ischemic) with large vessel occlusion"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Refuse imaging"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Postpartum stroke (ischemic) with large vessel occlusion** — postpartum hypercoagulable + preeclampsia/eclampsia/HT + cardiac (PPCM) + autoimmune + amniotic fluid embolism + cervical artery dissection (Valsalva push) + RCVS + cerebral venous sinus thrombosis (CVST): (1) **time-critical activation ''stroke code''**; (2) **ischemic stroke + large vessel occlusion + within window**: (a) **IV thrombolysis (tPA alteplase)** — within 4.5 hr — postpartum bleeding contraindication relative (consider risk-benefit); MTP 6 d post-delivery → caution; (b) **endovascular thrombectomy** — within 6-24 hr (DAWN/DEFUSE-3); preferred in postpartum (avoids systemic lysis); (3) **manage BP** — permissive HT up to 220/120 if not thrombolysis candidate (avoid hypoperfusion); if thrombolysis < 185/110; (4) **rule out + treat alternative causes**: (a) **postpartum cerebral angiopathy / reversible cerebral vasoconstriction syndrome (RCVS)** — thunderclap headache, segmental vasoconstriction, calcium channel blocker; (b) **cerebral venous sinus thrombosis (CVST)** — headache + papilledema + seizure → CTV/MRV → anticoagulation LMWH; (c) **PRES (posterior reversible encephalopathy)** — HT + visual + seizure + occipital edema → control BP + seizure; (d) **eclampsia** even postpartum (up to 6 wk); MgSO4 + BP; (5) **workup** — echo (cardiac embolic source — PPCM, valve), Doppler carotid, hypercoagulable + APS, autoimmune; (6) **anticoagulation** — depends on etiology (CVST yes, embolic source yes after acute, aspirin for non-cardioembolic ischemic); LMWH postpartum preferred; (7) **rehabilitation** — early; long-term recovery; (8) **breastfeeding** — most meds compatible; (9) **psychosocial + childcare** — significant family impact; social work; (10) **future pregnancy** — recurrence risk; multidisciplinary planning + LMWH thromboprophylaxis; (11) Thai stroke network + EMS

---

Postpartum stroke: ischemic + hemorrhagic; ↑ risk first 6 wk. Causes — HT/PE, hypercoag, PPCM, AFE, RCVS, dissection, CVST. Stroke code. tPA + thrombectomy (postpartum bleed risk — risk-benefit). Distinguish RCVS, CVST, PRES, eclampsia. Anticoag depends on etiology. Breastfeeding mostly compatible. Future pregnancy planning.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 28 ปี G1P1 NSD 5 d ago — มาห้องฉุกเฉินด้วยอาการอ่อนแรงครึ่งซีก L + พูดไม่ชัด + ปวดศีรษะรุนแรง + ตามัวข้างซ้าย

V/S: BP 168/108, HR 96, RR 18
Gen: alert but confused
Neuro: L hemiparesis + dysarthria + L homonymous hemianopia
Fetal/Baby: at home with family, breastfeeding
CT brain: R MCA territory hypodense + no hemorrhage
CTA: R MCA M1 occlusion';

update public.mcq_questions
set choices = '[{"label":"A","text":"Force termination"},{"label":"B","text":"Perinatal palliative care for lethal fetal anomaly"},{"label":"C","text":"Hysterectomy"},{"label":"D","text":"Methotrexate"},{"label":"E","text":"Refuse care"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Perinatal palliative care for lethal fetal anomaly** — family-centered, individualized: (1) **multidisciplinary team** — MFM + neonatology + nursing + chaplain + social worker + bereavement counselor + perinatal palliative care specialist if available + family; (2) **respectful counseling** — present options (termination if legal + within Thai law, continue with palliative perinatal care); validate choice; explore meaning + values; (3) **birth plan creation** — preferences for delivery (vaginal preferred, avoid C/S for non-survivable, except maternal indication), pain management, monitoring during labor (limited interventions per family), presence of family, religious/cultural rituals, memory making (footprints, photos, memory box), naming, baptism/blessing, breastfeeding/colostrum if desired; (4) **maternal care** — routine ANC with attention to maternal complications (polyhydramnios from anencephaly — preterm labor, PROM, dystocia), maternal mental health (high risk depression + PTSD + grief), social support; (5) **monitoring** — minimal fetal monitoring (no interventions for fetal distress); maternal monitoring intact; (6) **labor + delivery** — usually term but may be earlier; vaginal delivery preferred; consider amnioreduction if symptomatic polyhydramnios; oxytocin + epidural standard; avoid C/S unless maternal indication (no fetal benefit); (7) **at birth** — focus on comfort + family bonding; no resuscitation per advance plan; warm wrap, hold, time as long as desired; pain management for infant (morphine, comfort); allow death naturally with dignity; (8) **postpartum** — lactation suppression options (or donor milk if desired), bereavement support, memorial, follow-up; future pregnancy counseling — recurrence risk + folate 4 mg + screening; (9) **community + cultural** — Thai Buddhist rituals, family practices, respectful integration; (10) **bereavement counseling** — perinatal loss support groups; complicated grief screening; (11) **multidisciplinary debrief** + staff support (moral distress); (12) **legal/documentation** — birth + death certificates, autopsy if family wishes, genetic counseling; (13) **whole family** — siblings, grandparents — pediatric/child life support

---

Perinatal palliative care: multidisciplinary, family-centered. Birth plan, memory making, comfort care at birth. Vaginal delivery preferred; avoid C/S without maternal indication. Polyhydramnios mgmt for symptomatic. Bereavement + future pregnancy counseling (recurrence + folate). Cultural integration. Staff support for moral distress.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 28 ปี G2P1 GA 24 wk — fetal anencephaly (lethal anomaly) confirmed on US — couple opts to continue pregnancy with palliative perinatal care

V/S: BP 116/72, HR 76
Gen: well, supportive partner + family
Fetal: confirmed anencephaly + acrania + polyhydramnios mild + otherwise grossly normal
Lab: amniotic fluid AFP high, no other anomaly';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge home"},{"label":"B","text":"Acute Fatty Liver of Pregnancy (AFLP)"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Wait for liver to recover before delivery"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Acute Fatty Liver of Pregnancy (AFLP)** — rare but life-threatening (mortality 10-20% maternal, 20-30% perinatal) — microvesicular fatty infiltration of hepatocytes; 3rd trimester typically; associated with **fetal LCHAD deficiency** (long-chain 3-hydroxyacyl-CoA dehydrogenase — fetal fatty acid oxidation defect → toxic intermediates to mother); **Swansea criteria** (≥ 6 of 14): vomiting, abdominal pain, polydipsia/polyuria, encephalopathy, ↑ bilirubin, hypoglycemia, ↑ urate, leukocytosis, ascites/bright liver, ↑ transaminases, ↑ ammonia, ↑ Cr, coagulopathy, microvesicular steatosis on biopsy; (1) **differential** — HELLP (overlapping), severe preeclampsia, viral hepatitis (AVH), drug-induced, TTP, intrahepatic cholestasis of pregnancy (ICP — usually milder), acute viral hepatitis; (2) **management — STAT delivery** is definitive (do not delay for steroids in stable; deliver promptly): (a) **stabilize** — correct hypoglycemia (D10 infusion), correct coagulopathy (FFP, cryo, plt, vit K), correct electrolytes, blood products; (b) **MgSO4** seizure prophylaxis (often co-exists with preeclampsia features); (c) **antihypertensive** if needed; (d) **deliver** — mode per obstetric — vaginal if feasible + safe, C/S if compromised; consider preinduction maternal stabilization; (e) **multidisciplinary** — MFM + hepatology + ICU + neonatology; (3) **postpartum** — supportive in ICU; usually improves over days-weeks; liver transplant for fulminant failure (rare); monitor + correct coagulopathy; (4) **neonatal — test for LCHAD deficiency** — newborn screen + acylcarnitine + genetic; if affected → MCT-based diet + restriction long-chain fatty acids; (5) **future pregnancy** — recurrence ~ 20-70% if mother heterozygous + partner heterozygous + fetus homozygous → counsel + prenatal testing; (6) **counseling** + family support

---

AFLP: rare, life-threatening. Hypoglycemia + coagulopathy + ↑ bilirubin/transaminases + ↑ urate + AKI. Swansea criteria. Fetal LCHAD deficiency association. STAT delivery is definitive after stabilization. Correct hypoglycemia + coagulopathy. ICU. Neonatal LCHAD screen. Recurrence ~ 20-70%.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงตั้งครรภ์ G2P1 GA 32 wk underlying chronic HT + GDM — มาด้วยอาการ malaise + nausea + ปวด RUQ × 3 d + jaundice mild × 1 d

V/S: BP 138/86, HR 102, RR 18, Temp 37.0
Gen: jaundiced + RUQ tenderness + no encephalopathy
Fetal: FHR 158 reactive, EFW 1,650 g (50th)
Lab: AST 580, ALT 480, total bilirubin 5.2, glucose 52 (hypoglycemia!), plt 95K, INR 1.6, fibrinogen 180, Cr 1.3, uric acid 8.5, urine protein 1+
US abdomen: liver echogenic (fatty)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Cesarean immediately without TPE"},{"label":"B","text":"Thrombotic Thrombocytopenic Purpura (TTP) in pregnancy"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Hysterectomy"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Thrombotic Thrombocytopenic Purpura (TTP) in pregnancy** — pentad: hemolytic anemia + thrombocytopenia + neurologic + renal + fever (often incomplete); **ADAMTS13 < 10% activity** + anti-ADAMTS13 IgG → acquired (immune-mediated) TTP; distinguish from severe preeclampsia/HELLP, AFLP, HUS, DIC, sepsis-DIC, APS catastrophic — overlapping features but ADAMTS13 deficit pathognomonic; (1) **STAT plasma exchange (TPE)** — daily 1.5× plasma volume with FFP replacement → removes anti-ADAMTS13 Ab + replaces ADAMTS13 + vWF cleaving; continue until plt > 150K × 2 d + clinical improvement; (2) **corticosteroid** (prednisolone 1 mg/kg/d) — adjunct immunosuppression; (3) **caplacizumab** (anti-vWF nanobody) — new effective; pregnancy data limited, individual risk-benefit; (4) **rituximab** — for refractory + relapsing — used in pregnancy with consideration; (5) **avoid platelet transfusion** unless life-threatening bleeding (theoretical worsens microthrombi); RBC + FFP OK; (6) **fetal monitoring**; (7) **delivery timing** — TTP itself not indication for delivery; treat TTP first; deliver per obstetric indications; if fetal compromise + TTP severe → multidisciplinary decision; (8) **multidisciplinary** — hematology + MFM + nephrology + neuro + ICU; (9) **postpartum** — continue treatment; recurrence ~ 30% in next pregnancy → close monitoring + prophylactic plasma infusion; (10) **congenital TTP (Upshaw-Schulman)** — inherited ADAMTS13 deficit — recurrent in pregnancy → prophylactic FFP infusion; (11) **differential** — preeclampsia/HELLP improves with delivery (TTP usually doesn''t); AFLP has hypoglycemia + coagulopathy; HUS — Shiga toxin or atypical (complement-mediated); APS — antiphospholipid Ab; (12) **mortality** untreated > 90%, with TPE < 20%

---

TTP in pregnancy: pentad (anemia + thrombocytopenia + neuro + renal + fever — often incomplete). ADAMTS13 < 10% + Ab → acquired TTP. STAT TPE + steroid (+ caplacizumab/rituximab). Avoid plt transfusion. Distinguish from HELLP/AFLP/HUS/DIC. Delivery per obstetric — not TTP indication. Recurrence high. Mortality high untreated.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 26 ปี G1P0 GA 28 wk underlying healthy — มาด้วย hemolytic anemia + thrombocytopenia + AKI + altered mental status

V/S: BP 132/82, HR 110, Temp 37.4
Gen: petechiae + jaundice + altered mental status (confused)
Fetal: FHR 144 reactive
Lab: Hb 7.2, MCV 90, retic 8%, schistocytes ++, plt 15K, LDH 1,800, haptoglobin < 8, indirect bilirubin 4.5, Cr 2.8 (was 0.6), ADAMTS13 activity < 10% (severely reduced), anti-ADAMTS13 IgG positive, AST/ALT mildly ↑, INR normal, fibrinogen 320';

update public.mcq_questions
set choices = '[{"label":"A","text":"Forced termination"},{"label":"B","text":"Cervical cancer in pregnancy"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Discharge — wait until delivery without further workup"},{"label":"E","text":"Hysterectomy at 18 wk without considering options"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Cervical cancer in pregnancy** — multidisciplinary GYN-onc + MFM + neonatology + family — individualized: (1) **multidisciplinary discussion + patient preference** (desire to continue pregnancy, GA, stage, growth pattern); (2) **early pregnancy (< 22-24 wk) with early-stage**: (a) **delay treatment to fetal viability** if microscopic/early IA-IB1 stable + close monitoring (clinical + MRI q 4-8 wk); deliver 34-37 wk + post-delivery definitive surgery (radical hysterectomy or CRT); (b) **immediate treatment** (treatment supersedes pregnancy) for advanced or rapidly progressive — chemotherapy 2nd-3rd trimester (cisplatin + paclitaxel safer than CRT in pregnancy) → delay surgery to postpartum + adjuvant; (c) **termination if family chooses** + definitive treatment; (3) **later pregnancy (≥ 22-24 wk)**: (a) wait for fetal lung maturity, antenatal steroids 24-34 wk, deliver 34-37 wk (or earlier ถ้า progression) → C/S + radical hysterectomy en bloc at same operation, or staged; (b) avoid radiation in pregnancy ถ้า possible; (4) **fertility-sparing trachelectomy** — not feasible during pregnancy typically; (5) **delivery mode** — **cesarean** preferred to avoid vaginal birth (theoretical tumor seeding + bleeding); vaginal previously thought OK for very early lesion but C/S safer; (6) **at C/S** — radical hysterectomy + pelvic lymphadenectomy + BSO consideration based on age + path (preserve ovaries young if reasonable); send ovarian mass to frozen — likely benign physiologic at this GA; (7) **adjuvant** — RT + cisplatin per indications postpartum; (8) **lymph node assessment during pregnancy** — sentinel LN (technetium-99m safe), pelvic LND if needed; some delay; (9) **counseling** — survival similar to non-pregnant matched; fetal outcomes good with planned management; psychological + multidisciplinary support; (10) **chemotherapy in pregnancy 2nd-3rd trimester** — generally accepted safety for limited regimens (cisplatin, paclitaxel)

---

Cervical cancer in pregnancy: multidisciplinary + individualized. Early GA + early stage: delay until viability, antenatal steroid, C/S + radical hysterectomy. Chemo 2nd-3rd tri (cisplatin/paclitaxel) if needed. Avoid RT pregnancy. C/S preferred mode. Sentinel LN. Counseling + family choice — termination option.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 34 ปี G1P0 GA 18 wk routine US — finding ovarian mass 6 cm complex on R + Pap smear last year ASCUS HPV+, colposcopy + biopsy: invasive SCC of cervix Stage IB1 (tumor 2.5 cm)

V/S: BP 116/72, HR 80
Gen: well
Fetal: anatomy scan normal otherwise, growth appropriate
MRI pelvis: cervical tumor 2.5 cm, no parametrial involvement, no nodal involvement; ovarian mass complex 6 cm — separately, R, likely physiologic vs benign
No metastasis on CXR';

update public.mcq_questions
set choices = '[{"label":"A","text":"Hysterectomy"},{"label":"B","text":"Asherman Syndrome (intrauterine adhesions)"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Asherman Syndrome (intrauterine adhesions)** — fibrous bands in endometrial cavity → menstrual abnormalities, infertility, pregnancy complications; etiology: D&C (most common, esp post-miscarriage/postpartum), infection (TB, schistosomiasis), surgery, radiation: (1) **classification** — March/AFS (mild/moderate/severe by extent + type); ESH/Hamou; (2) **diagnosis** — HSG (filling defects), SIS, **hysteroscopy gold standard** (direct + treatment); (3) **treatment — hysteroscopic adhesiolysis** — scissors, hook, monopolar/bipolar — preserve healthy endometrium; outpatient or staged for extensive; (4) **prevention of recurrence post-adhesiolysis** — variable methods (no single proven best): (a) **intrauterine device/balloon** — Foley balloon or IUD for 1-2 wk to keep walls separated; (b) **hyaluronic acid gel** intracavitary; (c) **estrogen therapy** — high-dose estrogen (conjugated estrogen 5 mg/d or estradiol 4 mg/d) × 4-8 wk → stimulate endometrial regrowth; (d) **second-look hysteroscopy** at 6-8 wk to lyse new adhesions; (5) **stem cell / G-CSF** — emerging therapies for endometrial regeneration; (6) **fertility outcomes** — depend on severity + initial endometrial damage; ~ 60-90% restoration of menses; pregnancy 30-70%; (7) **pregnancy complications post-Asherman** — preterm, FGR, abnormal placentation (accreta — implantation on scar), abortion → close monitoring; (8) **counseling** — recurrence, fertility outcomes, alternative parenthood options (gestational surrogacy if severe); (9) **prevention** — D&C avoidance when possible (use medical management for early miscarriage), gentle technique, postpartum care; (10) **co-existing infertility workup** — semen, ovulation, tubes

---

Asherman: intrauterine adhesions from D&C/infection. Diagnosis: hysteroscopy. Treatment: hysteroscopic adhesiolysis + prevent recurrence (balloon, hyaluronic gel, estrogen, second-look). Pregnancy complications: preterm, FGR, accreta. Prevention: avoid unnecessary D&C, gentle technique. Surrogacy if severe.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 32 ปี G2P0A2 prior 2 D&C for missed abortion — มาด้วยอาการประจำเดือนไม่มา 1 yr post-D&C + cyclic pelvic pain + infertility, β-hCG negative

V/S: BP 116/72, HR 78
Gen: well
Pelvic: WNL
Lab: TSH normal, prolactin normal, FSH 6, LH 4, AMH 3.2 normal, β-hCG negative
HSG: filling defects + irregular cavity outline (suggesting adhesions)
Hysteroscopy: extensive intrauterine adhesions involving > 75% cavity';

update public.mcq_questions
set choices = '[{"label":"A","text":"Methotrexate"},{"label":"B","text":"Hyperandrogenism with virilization + ovarian mass"},{"label":"C","text":"PCOS — treat with COCP"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Hyperandrogenism with virilization + ovarian mass** — workup for **androgen-secreting tumor** (ovarian or adrenal); high testosterone + virilization signs (rapid onset, deep voice, clitoromegaly, balding) → likely ovarian: (1) **differential**: (a) **ovarian — Sertoli-Leydig cell tumor (most common androgen-secreting), thecoma, hilus cell tumor, granulosa cell**; (b) **adrenal — adenoma, carcinoma**; (c) **PCOS** — typically lower T < 150, slower onset, no virilization; (d) **non-classic CAH** — 17-OHP elevated post-ACTH stim; (e) **Cushing''s** — cortisol; (f) **exogenous** — anabolic steroids, DHEA supplements; (2) **workup** — **DHEAS high → adrenal**; **testosterone very high → ovarian**; both → adrenal carcinoma; **17-OHP basal + ACTH-stim** for CAH; **dexamethasone suppression test** for Cushing; (3) **imaging** — TVS + MRI pelvis (ovarian); CT/MRI adrenal; sometimes selective venous sampling for occult source; (4) **management — surgical removal**: (a) **ovarian Sertoli-Leydig** — unilateral salpingo-oophorectomy + staging (frozen section); fertility-sparing in young; (b) bilateral if perimenopausal/completed family; (c) **adrenal mass** — adrenalectomy with workup of malignancy; (d) **histology** — guides adjuvant; (5) **post-removal** — androgens normalize within weeks; virilization improves but voice + balding may not regress fully; (6) **counseling** — fertility preservation (egg cryopreservation if anticipated bilateral surgery), psychological support; (7) **follow-up** — recurrence + tumor markers (inhibin); (8) **cosmetic + dermatology** — laser hair removal, eflornithine cream for residual hirsutism; (9) **HRT** if surgical menopause; (10) Sertoli-Leydig — DICER1 mutation association → genetic counseling

---

Severe hyperandrogenism with virilization + rapid onset + T > 150 → androgen-secreting tumor (Sertoli-Leydig ovarian or adrenal). Workup DHEAS, testosterone, 17-OHP, dexamethasone. Imaging. Surgical removal. Sertoli-Leydig DICER1 association. Fertility preservation. Cosmetic adjunct. Distinguish from PCOS (lower T, slow onset, no virilization).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 24 ปี nulligravid มา OPD ด้วยอาการ hirsutism progressive + acne refractory + voice deepening + clitoromegaly + amenorrhea 6 mo × 1 yr

V/S: BP 134/86, HR 80
Gen: temporal balding, deep voice, hirsutism Ferriman-Gallwey 18, clitoromegaly mild
Lab: testosterone total 220 (markedly elevated; PCOS usually < 150), DHEAS WNL, 17-OHP normal, β-hCG negative, TSH normal, prolactin normal, FSH 5, LH 8, cortisol normal, ACTH-stim 17-OHP normal
US pelvis: R ovarian mass 4 cm solid + hypervascular
MRI: R ovarian solid mass with vascular pedicle, no metastasis';

update public.mcq_questions
set choices = '[{"label":"A","text":"Refuse care"},{"label":"B","text":"Vulvodynia (vulvar pain without identifiable cause ≥ 3 mo)"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Vulvodynia (vulvar pain without identifiable cause ≥ 3 mo)** — diagnosis of exclusion; subtypes: (a) **localized provoked vestibulodynia (LPV)** — pain at vestibule with provocation (Q-tip, intercourse); (b) **generalized unprovoked** — burning vulva; mixed; (1) **diagnosis** — clinical + exclude infection (culture, wet mount), dermatosis, hormonal, neuropathic, neoplasia, trauma; (2) **multimodal management — biopsychosocial**: (a) **vulvar care** — avoid irritants (perfumed soap, panty liners, tight clothes), cotton underwear, lubricants, sitz baths; (b) **topical** — lidocaine 5% ointment (esp before intercourse), topical estrogen (if atrophy), topical compounded amitriptyline-baclofen-gabapentin; (c) **systemic** — TCAs (amitriptyline 10-50 mg QHS), SNRIs (duloxetine, venlafaxine), gabapentin/pregabalin (titrate, slow) — for neuropathic; (d) **pelvic floor physical therapy** — high-evidence intervention — relieve hypertonic pelvic floor; biofeedback; dilators; (e) **psychotherapy** — CBT, mindfulness, sex therapy, couples therapy; address coping + relationship; (f) **interventional** — pudendal nerve block, trigger point injection, **Botox injection** (refractory); (g) **surgical — vestibulectomy** for refractory LPV (success ~ 70-90% select cases) — partial vestibulectomy + perineorrhaphy; (h) **complementary** — acupuncture, hypnotherapy; (3) **chronic pain syndromes co-occur** — IBS, fibromyalgia, IC/PBS, endometriosis, vaginismus, chronic fatigue → comprehensive approach; (4) **mental health screening** — depression, anxiety, sexual abuse history; (5) **counseling + education** — validate, partner involvement; (6) **multidisciplinary** — gyn + PFPT + mental health + pain specialist; (7) **support groups** — National Vulvodynia Association; (8) **NEVER** dismiss as psychological — real pain disorder

---

Vulvodynia: diagnosis of exclusion. LPV vs generalized. Multimodal: vulvar care, topical lidocaine, TCAs/SNRIs/gabapentin, PFPT (high evidence), CBT/sex therapy, Botox/vestibulectomy refractory. Mental health screening + chronic pain comorbidity. Validate + multidisciplinary. Don''t dismiss.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 38 ปี nulligravid มา OPD ด้วยอาการ vulvar burning pain × 6 mo + dyspareunia + tender to touch + no visible lesion + Q-tip test positive at vestibule + no infection + no skin disease

V/S: BP 122/76, HR 78
Gen: anxiety, no depression
Vulva: normal-appearing, no erythema/lesion, Q-tip test exquisitely tender at vestibule
Wet mount: WNL, KOH negative, culture negative';

update public.mcq_questions
set choices = '[{"label":"A","text":"One dose OTC cream + done"},{"label":"B","text":"Recurrent Vulvovaginal Candidiasis (RVVC, ≥ 4 episodes/yr)"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Antibiotic broad-spectrum"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Recurrent Vulvovaginal Candidiasis (RVVC, ≥ 4 episodes/yr)** — distinguish from uncomplicated/single episode; identify species (C. albicans 80-90%, others — C. glabrata, krusei — fluconazole resistance): (1) **confirm diagnosis** — wet mount + KOH + **culture** for species + sensitivity (esp recurrent); (2) **rule out predisposing factors** — uncontrolled diabetes (HbA1c), HIV/immunosuppression, recent broad-spectrum antibiotics, COCP (mild risk), pregnancy, douching, vaginal irritants, tight clothing; (3) **induction therapy** — extended course: (a) **fluconazole 150 mg PO q 72 hr × 3 doses** (or 100-200 mg/d × 14 d); OR (b) **topical azole (miconazole, clotrimazole, terconazole)** × 7-14 days; (4) **maintenance therapy** — **fluconazole 150 mg PO weekly × 6 mo** (CDC, ACOG); alternative: clotrimazole 500 mg PV weekly; (5) **C. glabrata** — fluconazole-resistant — treat with **boric acid 600 mg PV daily × 14 d** (compounded) OR nystatin PV; (6) **C. albicans azole-resistant** rare — boric acid or oteseconazole (newer); (7) **partner treatment** — not routinely indicated (yeast not classically STI); treat partner ถ้า symptomatic; (8) **lifestyle** — cotton underwear, avoid tight, less douching, manage moisture, avoid panty liners daily, consider probiotic Lactobacillus (mixed evidence); (9) **follow-up** — culture + symptom assessment q 3 mo; (10) **post-maintenance** ~ 50% recurrence after stopping — reassess + discuss longer maintenance vs alternative therapies; (11) **specific scenarios** — **pregnancy** topical azole 7 d (avoid oral fluconazole 1st tri); diabetic — optimize glucose; HIV — treat as RVVC + manage immune; (12) **counseling** — natural history, lifestyle, expectations

---

RVVC: ≥ 4 episodes/yr. Culture for species + sensitivity. Rule out DM/HIV/antibiotic predisposition. Induction: fluconazole 150 mg q 72 hr × 3 (or topical 7-14 d). Maintenance: fluconazole 150 mg weekly × 6 mo. C. glabrata: boric acid 14 d. Lifestyle. Counseling.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 24 ปี G0P0 มา OPD ด้วยอาการ recurrent vaginal yeast infection × 6 episodes/yr × 2 yr, ทุกครั้งหายเองหลังครีม OTC แต่กลับมา

V/S: BP 116/72, HR 78
Gen: well
Vagina: erythema mild + curdy discharge
Wet mount: yeast + pseudohyphae
Culture: Candida albicans
Fasting glucose normal, HbA1c 5.4, HIV negative, no immunosuppression, no recent antibiotics';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge home + observation"},{"label":"B","text":"Pelvic Inflammatory Disease (PID)"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Antifungal alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Pelvic Inflammatory Disease (PID)** — polymicrobial (GC, CT, anaerobes, gardnerella, mycoplasma); long-term sequelae: tubal infertility, ectopic, chronic pelvic pain (CPP): (1) **diagnosis CDC** — sexually active reproductive-age woman + lower abdominal/pelvic pain + 1+ of (a) cervical motion tenderness, (b) uterine tenderness, (c) adnexal tenderness; low threshold to treat empirically (often subtle); supportive: fever, purulent discharge, ↑ ESR/CRP, GC/CT NAAT positive, US findings; (2) **outpatient treatment (mild-moderate)**: (a) **ceftriaxone 500 mg IM × 1** + **doxycycline 100 mg PO BID × 14 d** + **metronidazole 500 mg PO BID × 14 d** (CDC 2021 updated); (b) follow-up 72 hr; (3) **inpatient treatment indications** — pregnancy, severe illness (high fever, vomiting), tubo-ovarian abscess (TOA), failure outpatient, immunocompromised, surgical emergency cannot exclude, unable to tolerate oral, non-adherence: (a) **cefotetan/cefoxitin 2 g IV q 12 hr + doxycycline 100 mg PO/IV q 12 hr** OR (b) **clindamycin + gentamicin** OR (c) **ampicillin/sulbactam + doxycycline**; transition to oral after improvement to complete 14 d (with metronidazole for anaerobic); (4) **TOA** — admit, IV antibiotics, percutaneous drainage if not resolving 48-72 hr or large (> 7-9 cm), surgery if rupture/sepsis; (5) **partner notification + treatment** — sexual partners last 60 d → empirical GC/CT treatment (DOXY-PEP rationale, expedited partner therapy); abstain until treatment complete; (6) **STI screening** — HIV, syphilis, HBV, HCV, GC/CT, trichomoniasis; (7) **IUD considerations** — recent IUD insertion ↑ PID risk; if IUD-related PID, leave IUD unless no improvement 48-72 hr antibiotic; (8) **education + prevention** — condoms, limit partners, regular STI testing, HPV vaccine, vaccination Hep A/B; (9) **HIV PrEP** consideration if high risk; (10) **follow-up** — 3 mo STI rescreen + symptom check + sequelae assessment

---

PID: CDC criteria + low threshold treatment. Outpatient: ceftriaxone IM + doxycycline + metronidazole × 14 d. Inpatient if severe/TOA/pregnancy/fail. Treat partners + STI screen. IUD-related PID — leave IUD unless no improvement. Sequelae: tubal infertility, ectopic, CPP. Prevention: condoms, vaccination.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 25 ปี nulligravid มา OPD ด้วยอาการปวด lower abdomen ค่อยๆ + ตกขาวเหลืองหนา + ปัสสาวะแสบ × 5 d + ไข้ low-grade + sexually active multiple partners + no condom

V/S: BP 118/74, HR 92, Temp 37.8
Gen: ill-looking mild
Pelvic: cervical motion tenderness, adnexal tenderness bilateral, purulent cervical discharge, no mass
Lab: WBC 13.5K, CRP 42, β-hCG negative, NAAT GC + CT positive, HIV negative, syphilis VDRL negative
US: thickened tube + adnexal complexity bilateral but no abscess';

update public.mcq_questions
set choices = '[{"label":"A","text":"Outpatient management"},{"label":"B","text":"Postpartum Preeclampsia / Severe HT crisis"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Cesarean (already delivered)"},{"label":"E","text":"Hysterectomy"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Postpartum Preeclampsia / Severe HT crisis** — preeclampsia can present **up to 6 wk postpartum** (new onset or worsening of antepartum); same severity criteria + management as antepartum: (1) **immediate admission** + IV access; (2) **antihypertensive within 30-60 min** for severe-range BP — **IV labetalol 20-40-80 mg q 10 min** (max 220-300 mg) or **IV hydralazine 5-10 mg q 20 min** or **oral nifedipine immediate-release 10-20 mg q 30 min**; target BP < 150/100; AIM bundle; (3) **MgSO4** for seizure prophylaxis (severe features present — thrombocytopenia, transaminitis, cerebral symptoms) — 4-6 g loading + 1-2 g/hr × 24 hr; (4) **rule out other causes** — postpartum cardiomyopathy (echo, BNP), PRES, stroke, RCVS, eclampsia, sepsis, AFLP late, TTP/HUS, drug effects; (5) **NSAIDs** controversial — generally OK in HT, but caution + acetaminophen preferred; (6) **maintenance antihypertensive** — labetalol 200-800 mg q 8-12 hr, nifedipine ER 30-120 mg/d, hydralazine, methyldopa; ACEI/ARB now OK postpartum (and breastfeeding — enalapril/captopril preferred; lisinopril etc. — Hale L3 compatible); (7) **monitor labs** — CBC + LFT + Cr + urine — often worsens 24-72 hr postpartum then improves; (8) **discharge planning** — BP daily home for 7-10 d + weekly + recheck PE labs; education for warning signs (HA, vision, RUQ pain, swelling, SOB, AMS — return for evaluation); (9) **breastfeeding** — all common antihypertensives compatible; (10) **future pregnancy** — recurrence 15-65% (depending on severity); preconception planning + aspirin 81-150 mg from 12 wk; (11) **lifelong CV risk** — postpartum PE = 2-4× lifelong CV disease + HT + stroke risk → cardiology referral + lifestyle modification; (12) **postpartum follow-up** — close, especially first 2 wk highest risk; consider home BP monitoring + telehealth check-ins; (13) **psychosocial** — childcare support + breastfeeding support; (14) **document + counsel**

---

Postpartum preeclampsia: up to 6 wk. Treat severe HT < 30-60 min (AIM). MgSO4 if severe features. Rule out PPCM, stroke, PRES, TTP/HUS. ACEI/ARB OK postpartum + breastfeeding (enalapril/captopril preferred). Future pregnancy aspirin + recurrence. Lifelong CV risk 2-4×.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 32 ปี G1P1 NSD 7 d ago — มาด้วย postpartum hypertensive crisis BP 188/118 + severe headache + visual disturbance + epigastric pain, mom is at home with newborn

V/S: BP 188/118, HR 96, RR 22
Gen: hyperreflexia 4+, photophobia
Fetal/Baby: at home with grandmother, breastfeeding
Lab: plt 95K, AST 145, Cr 1.2, urine protein 3+, LDH 580';

update public.mcq_questions
set choices = '[{"label":"A","text":"Hysterectomy without considering options"},{"label":"B","text":"Fertility-sparing management for early-stage endometrial cancer"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Refuse fertility consideration"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Fertility-sparing management for early-stage endometrial cancer** — strict criteria + multidisciplinary GYN-onc + REI + counseling: (1) **criteria for fertility-sparing**: (a) endometrioid type, **grade 1**, (b) **stage IA** + **NO myometrial invasion** on MRI, (c) **NO LVSI**, (d) **NO extrauterine disease**, (e) reproductive age + strong fertility desire, (f) **Rh ER/PR positive** (predicts response), (g) understands risks + agrees close surveillance + hysterectomy after childbearing; (2) **first-line treatment — high-dose progestin**: (a) **LNG-IUD (Mirena)** — local high-dose progestin — increasingly preferred (less systemic SE; effective; can combine with oral); (b) **megestrol acetate 160-320 mg/d PO** OR **medroxyprogesterone acetate 200-600 mg/d PO**; (c) duration 6-12 mo with re-evaluation; (3) **GnRH agonist** — adjunct or alternative for obesity/PCOS; (4) **metformin** — adjunct for obesity/insulin resistance; (5) **weight loss** — bariatric surgery if BMI > 40 — reduces recurrence + improves response; (6) **surveillance during treatment** — **endometrial sampling (hysteroscopy + biopsy) every 3 mo** until complete response (CR — no carcinoma or atypical hyperplasia on biopsy); usually 6-9 mo; (7) **after CR** — proceed to fertility treatment (often need ART/IVF — 50-60% pregnancy success); maintenance progestin until pregnancy attempted; (8) **after childbearing complete — definitive hysterectomy** (high recurrence risk if uterus retained) + consider BSO based on age + Lynch screening; (9) **recurrence rate** — 30-40% after initial CR; close monitoring; re-treat or definitive; (10) **multidisciplinary** + counseling — risks + outcomes + lifelong surveillance even after hysterectomy; (11) **Lynch syndrome universal screening** (MSI/IHC) — affects family + future cancer surveillance; (12) **contraindication fertility-sparing** — high-grade, deep myometrial invasion, LVSI, extrauterine, non-endometrioid

---

Fertility-sparing endometrial cancer: strict criteria (grade 1, stage IA, no myometrial/LVSI, ER/PR+, fertility desire). LNG-IUD + megestrol high-dose progestin. Sampling q 3 mo until CR. Then fertility treatment (IVF often). Definitive hysterectomy after childbearing. Recurrence 30-40%. Lynch screen. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 35 ปี G0P0 ตัดสินใจ desire fertility-sparing — diagnosed early endometrial cancer Stage IA grade 1 endometrioid + no myometrial invasion + no LVSI + no nodal involvement, BMI 35

V/S: BP 132/82, HR 80
Gen: BMI 35, mild hirsutism
MRI: no myometrial invasion, no nodal involvement
Endometrial biopsy: endometrioid grade 1 + ER/PR strongly positive + no atypical features';

update public.mcq_questions
set choices = '[{"label":"A","text":"Ignore — pain is normal"},{"label":"B","text":"first-line — NSAIDs"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Primary dysmenorrhea** (no underlying pathology — cyclic prostaglandin-mediated uterine cramping) — most common in adolescents, peak 16-25 yr; vs **secondary** (endometriosis, adenomyosis, fibroids, PID, obstructed Müllerian — bicornuate with non-communicating horn — etc.): (1) **first-line — NSAIDs** — **mefenamic acid 500 mg q 6 hr** or **ibuprofen 400-800 mg q 6 hr** or **naproxen 220-500 mg q 8-12 hr** — start 1-2 d before expected menses + continue through pain; prevent prostaglandin synthesis at source; (2) **second-line — hormonal**: (a) **combined OCP** (cyclic or continuous) — suppresses ovulation + thins endometrium → ↓ PG production + cramping; also contraception (relevant if becomes sexually active); (b) **progestin alone** — POP, DMPA, implant (Nexplanon — adolescent option, no estrogen concern); (c) **LNG-IUD (Mirena)** — also adolescent option per ACOG/AAP (lower failure, reduces HMB + dysmenorrhea + endometriosis); (3) **non-pharmacological adjuncts** — heat (heating pad), exercise, dietary (omega-3, magnesium — limited evidence), TENS, yoga, acupuncture, stress management, sleep; (4) **refractory dysmenorrhea or atypical features** → consider **secondary dysmenorrhea** workup — endometriosis (suspect if pain worsening, dyspareunia, dyschezia, infertility), Müllerian anomaly (obstructed) — TVS/MRI, **diagnostic laparoscopy**; (5) **endometriosis treatment** — covered separately (NSAIDs + COCP + progestin + GnRH agonist if refractory); (6) **adolescent endometriosis** — increasingly recognized; refer if refractory; (7) **education + reassurance** — primary dysmenorrhea common + treatable; menstrual hygiene + tracking + cycle predictability; (8) **school accommodation** — emphasize importance of not missing school; pain management ahead of menses; (9) **mental health screening** — anxiety + depression often co-occur; (10) **parental involvement** + adolescent autonomy; (11) Thai school health programs + youth-friendly clinics

---

Primary dysmenorrhea: NSAIDs first-line (start before menses), COCP/progestin/LNG-IUD second. Adolescent-friendly. Refractory → suspect endometriosis or anomaly (US/MRI + laparoscopy). Non-pharma adjuncts. Education + school accommodation. Mental health. Adolescent endometriosis increasingly recognized.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 14 ปี nulliparous มา OPD ด้วยอาการปวดประจำเดือนรุนแรงตอน menses + ปวดท้อง + คลื่นไส้ + อาเจียน + ขาดเรียน × 1 yr ตั้งแต่ menarche 2 ปีก่อน, no pelvic pathology suspected, sexually inactive

V/S: BP 110/68, HR 80
Gen: well, no signs PCOS
Pelvic: external exam normal
US TV: deferred (virgin); abdominal US WNL';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge home with PO antibiotic"},{"label":"B","text":"Tubo-Ovarian Abscess (TOA)"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Antibiotic outpatient"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Tubo-Ovarian Abscess (TOA)** — complication of PID with abscess formation; polymicrobial (GC, CT, anaerobes, gram-negatives): (1) **admit + IV access + IV antibiotics**: (a) **cefoxitin/cefotetan 2 g IV q 12 hr + doxycycline 100 mg IV/PO q 12 hr** OR (b) **clindamycin 900 mg IV q 8 hr + gentamicin 5 mg/kg q 24 hr** OR (c) **ampicillin-sulbactam 3 g IV q 6 hr + doxycycline**; (2) **continue IV** until afebrile + improving 24-48 hr, then transition to **oral × 14 d total** with metronidazole 500 mg BID + doxycycline; (3) **drainage**: (a) **percutaneous (IR-guided)** — preferred for abscess > 7-9 cm + accessible + no improvement on antibiotics 48-72 hr OR initially for large abscess; minimally invasive; (b) **transvaginal drainage** alternative; (c) **surgical (laparoscopic or open)** — for rupture, sepsis, failed minimally invasive, or large unresponsive; (4) **IUD management** — IUD-associated TOA — leave IUD initially if responding to antibiotics, remove if not improving 48-72 hr or recurrent (CDC); (5) **STI screen + partner notification + treatment** (GC/CT empirically partners; HIV/syphilis/hepatitis screen); (6) **monitor** — temperature, WBC, CRP, abdo exam, US/CT q 48-72 hr to assess abscess size; (7) **complications** — sepsis, rupture (surgical emergency), chronic pelvic pain, infertility (tubal damage), ectopic risk; (8) **education** — STI prevention, condoms, regular screening, follow-up; (9) **discharge** when afebrile + improving + tolerate oral + arranged follow-up; (10) **outpatient** — complete antibiotic, follow-up 3 mo for symptom + STI re-screen + sequelae; (11) **prevention** — condoms, vaccination (HPV, Hep B), regular STI screen high-risk populations; (12) **counseling** — fertility implications; STI partner + Thai DDC reporting (some)

---

TOA: hospitalize + IV antibiotic (cefoxitin + doxycycline or clinda + gent or amp-sulb + doxy). Drainage for > 7-9 cm or no improvement 48-72 hr (IR-guided percutaneous preferred). Surgery if rupture/sepsis. IUD — leave if responding. STI + partner + screen. Complications: rupture, infertility. Total 14 d antibiotic with metronidazole.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 32 ปี nulligravid IUD copper × 5 yr มา OPD ด้วยอาการ acute lower abdominal pain + fever 38.6 + N/V + RLQ pain + peritonitis × 2 d

V/S: BP 102/68, HR 124, Temp 38.8, RR 22
Gen: ill, peritonitis lower abdomen
Pelvic: cervical motion + adnexal tenderness, R adnexal mass 7 cm tender
Lab: WBC 22K with left shift, CRP 120, β-hCG negative, NAAT GC + CT positive, lactate 2.4
US: complex adnexal mass 7 cm with debris suggesting **tubo-ovarian abscess (TOA)**';

update public.mcq_questions
set choices = '[{"label":"A","text":"Refuse all treatment"},{"label":"B","text":"Severe vasomotor symptoms (VMS) in breast cancer survivor"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Antibiotic alone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Severe vasomotor symptoms (VMS) in breast cancer survivor** — MHT contraindicated; **non-hormonal management**: (1) **first-line non-hormonal pharmacotherapy**: (a) **SSRIs/SNRIs** — **paroxetine 7.5 mg/d** (FDA-approved for VMS), **venlafaxine ER 37.5-150 mg/d**, escitalopram, citalopram, desvenlafaxine; **avoid paroxetine + fluoxetine with tamoxifen** (strong CYP2D6 inhibitors — ↓ active metabolite; consider venlafaxine/escitalopram instead with tamoxifen — but this patient on aromatase inhibitor not tamoxifen so paroxetine OK); (b) **gabapentin 300-900 mg QHS** — also helps sleep; (c) **pregabalin** alternative; (d) **clonidine** — limited effect, SE; (e) **oxybutynin 2.5-5 mg BID** — anticholinergic; (f) **fezolinetant** — new (2023) neurokinin-3 (NK3) receptor antagonist — FDA-approved VMS, hormonal pathway-independent — promising for cancer survivors; (2) **non-pharmacologic**: (a) **CBT** — strong evidence — symptom + sleep + mood; (b) **mindfulness-based stress reduction (MBSR)**; (c) **clinical hypnosis** — moderate evidence; (d) **acupuncture** — limited evidence; (e) **lifestyle** — cool environment, layered clothing, avoid triggers (hot drinks, spicy, alcohol, caffeine), weight management, exercise (paradoxical short-term ↑ but long-term improvement), smoking cessation; (3) **vaginal estrogen** for GSM — controversial in breast cancer history → MDT discussion with oncology — low-dose vaginal estrogen (esp non-systemic forms — DHEA prasterone, ospemifene) generally acceptable after counseling + MDT; (4) **other** — black cohosh + soy isoflavone — mixed evidence + concern in ER+; (5) **sleep hygiene** + treatment of insomnia (CBT-I, melatonin); (6) **mood + anxiety screening** (often comorbid); (7) **support groups** + counseling; (8) **switching aromatase inhibitor** to alternative (anastrozole vs letrozole vs exemestane) sometimes helps; oncology consult; (9) **bone health** — DEXA, Ca/vit D, bisphosphonate (AI ↑ bone loss); (10) **lifelong oncology surveillance + survivorship care**

---

Breast cancer survivor + severe VMS: non-hormonal pharmacotherapy (SSRI/SNRI, gabapentin, clonidine, oxybutynin, fezolinetant new). CBT + MBSR + hypnosis + lifestyle. Avoid paroxetine + fluoxetine with tamoxifen (CYP2D6). Vaginal estrogen for GSM after MDT discussion. Bone surveillance + AI. Survivorship care.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงอายุ 56 ปี postmenopausal × 4 yr มาด้วย hot flashes severe 15+/d + night sweats + insomnia, ก่อนหน้านี้ history of breast cancer ER+ × 4 yr ago, completed tamoxifen, currently NED, on aromatase inhibitor anastrozole — exacerbating VMS

V/S: BP 124/76, HR 78
Gen: well, distressed by VMS
Lab: no current cancer findings, mammogram recent normal
No CV disease, no VTE history';

update public.mcq_questions
set choices = '[{"label":"A","text":"Fetal thyroid produces TSH from gestation"},{"label":"B","text":"fetal hypothalamus-pituitary axis"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Maternal T4 doesn''t cross placenta"},{"label":"E","text":"Hysterectomy"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Fetal endocrinology: (1) **fetal hypothalamus-pituitary axis** develops 8-12 wk; (2) **fetal thyroid** — synthesizes hormones from ~ 10-12 wk; before that **maternal T4 critical** (crosses placenta — T4 > T3); maternal hypothyroidism untreated → fetal neurodevelopmental impairment (1st trimester critical); (3) **maternal iodine** — ↑ requirement 250 mcg/d (Thai dietary salt iodination); deficiency → cretinism; (4) **fetal thyroid hormones** — TBG synthesized fetal liver; T4 rises through gestation; **TSH** detectable from ~ 12 wk + rises late; (5) **at birth** — TSH surge (newborn screen at 48-72 hr), T4 ↑ acutely; newborn screening for **congenital hypothyroidism (CH)** mandatory (Thai national program; ~ 1/3,000); cretinism preventable; (6) **anti-thyroid drugs maternal** — PTU + methimazole cross placenta; PTU preferred 1st trimester (less teratogenic than methimazole — aplasia cutis, choanal/esophageal atresia); methimazole 2nd-3rd; (7) **Graves'' with TRAb +** — crosses placenta → fetal Graves'' (tachy, IUGR, goiter, craniosynostosis) — monitor fetal HR + thyroid US; (8) **fetal adrenal** — large in 2nd-3rd trimester (fetal zone — makes DHEAS → estriol via fetoplacental unit); regresses postnatally; (9) **cortisol from fetal adrenal** — required for lung maturation (surfactant), gut, brain; ↑ at birth helps lung; (10) **antenatal corticosteroid (betamethasone/dexamethasone)** — crosses placenta — accelerates fetal lung maturation + reduces RDS, IVH, NEC, mortality — 24-34 wk routinely (extend 34-36+6 wk ALPS); (11) **maternal cortisol** ↑ in pregnancy (estrogen ↑ CBG + free; physiologic hypercortisolism); usually not Cushingoid; (12) **CAH** — fetal 21-hydroxylase deficiency → virilization (female fetus) — prenatal dexamethasone to suppress fetal HPA controversial (rare research-protocol); (13) **fetal pancreas** — insulin from ~ 12 wk; **fetal hyperinsulinemia** in maternal hyperglycemia → macrosomia + hypoglycemia at birth

---

Fetal endocrinology: maternal T4 critical 1st trimester (fetal thyroid from 10-12 wk); newborn screen TSH at 48-72 hr (CH 1/3,000). Iodine 250 mcg. PTU 1st trimester, methimazole 2nd-3rd. Graves TRAb crosses → fetal Graves. Fetal adrenal large (DHEAS → estriol). Antenatal corticosteroid → lung maturation. CAH. Fetal insulin → macrosomia.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Resident ถามอาจารย์เรื่อง fetal endocrinology + maternal-fetal thyroid + adrenal axis';

update public.mcq_questions
set choices = '[{"label":"A","text":"GFR decreases in pregnancy"},{"label":"B","text":"Renal physiology in pregnancy"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Cr 0.9 normal in pregnancy"},{"label":"E","text":"Hysterectomy"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Renal physiology in pregnancy: (1) **anatomic changes** — kidney enlarges ~ 1-1.5 cm (vascular + interstitial); **physiologic hydroureter + hydronephrosis** (R > L due to dextrorotation of uterus; progesterone smooth muscle relaxation) — late 1st trimester onward; persists 4-6 wk postpartum; can mimic obstruction; (2) **renal plasma flow** ↑ 60-80% by 2nd trimester; (3) **GFR** ↑ 50% by mid-pregnancy (peak ~ 200 mL/min from baseline ~ 120); via ↑ renal plasma flow + ↑ filtration fraction; (4) **lab implications**: (a) **serum creatinine ↓** to 0.4-0.7 (lab upper limit pregnancy ~ 0.8); **Cr 0.9-1.0 considered abnormal in pregnancy** (impaired renal function); (b) **BUN ↓** to ~ 8-10; (c) **uric acid ↓** in early pregnancy → rises slightly late; ↑ in preeclampsia; (d) **proteinuria** — physiologic up to 300 mg/24 hr; > 300 mg/24 hr or urine protein/Cr > 0.3 = pathologic (preeclampsia, renal disease); urine dipstick poor; (e) **glycosuria** — common (↓ tubular reabsorption + ↑ GFR) — physiologic; not always GDM; (f) **bicarbonate ↓** to ~ 19-22 (compensated respiratory alkalosis from ↑ tidal volume); (5) **water + electrolyte** — Na ↓ slightly (135-138), osmolality ↓ 5-10 mOsm/kg (resetting osmostat by hCG/relaxin); RAAS activated (↑ renin/angiotensin/aldosterone) — paradoxical hypervolemia with low colloid pressure; (6) **acid-base** — compensated respiratory alkalosis (PaCO2 28-32, HCO3 19-22); (7) **clinical implications**: (a) drugs renally cleared — adjust doses (LMWH, magnesium, gentamicin); (b) **CKD pregnancy** — Cr > 1.4 = ↑ risk progression + adverse outcomes; (c) **AKI in pregnancy** — preeclampsia/HELLP, AFLP, sepsis, hemorrhage, TTP/HUS, pyelonephritis, obstruction; (d) **preeclampsia** — endotheliosis, glomerular swelling, podocyte injury, proteinuria; (e) **postpartum AKI** — can be sentinel for atypical HUS (complement-mediated); (f) **dialysis pregnancy** — possible but complex; (8) **chronic HT/PE/preeclampsia long-term renal risk**

---

Pregnancy renal: GFR ↑ 50%, RPF ↑ 60-80%. Cr ↓ to 0.4-0.7 — Cr 0.9 abnormal pregnancy. Proteinuria > 300 mg/24h pathologic. Glycosuria common. Hydronephrosis R > L physiologic. Compensated respiratory alkalosis. Drug dosing adjusted. CKD Cr > 1.4 high-risk. AKI causes: PE/HELLP/AFLP/sepsis/TTP-HUS.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Resident ถามอาจารย์เรื่อง renal physiology in pregnancy + interpretation of labs';

update public.mcq_questions
set choices = '[{"label":"A","text":"Vaginal flora not important"},{"label":"B","text":"Vaginal microbiome + immunology"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Hysterectomy"},{"label":"E","text":"Antibiotic continuously"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Vaginal microbiome + immunology**: (1) **normal vaginal flora** — dominated by **Lactobacillus** (L. crispatus most protective, L. gasseri, L. jensenii, L. iners less so); produce **lactic acid** + H2O2 → **acidic pH (3.8-4.5)** → inhibits pathogens; bacteriocins, biosurfactants; (2) **community state types (CSTs)**: I (L. crispatus), II (L. gasseri), III (L. iners — less stable), IV (diverse anaerobes, gardnerella — dysbiosis); (3) **dysbiosis** — ↓ Lactobacillus + ↑ anaerobes (Gardnerella, Atopobium, Mobiluncus, Prevotella) → BV, ↑ STI susceptibility, ↑ preterm birth, ↑ PID; (4) **hormonal influences** — estrogen ↑ glycogen in epithelium → Lactobacillus substrate; **postmenopause** ↓ estrogen → ↓ glycogen → ↓ Lactobacillus → ↑ pH 5-7 → atrophy, ↑ UTI/BV; pregnancy → ↑ Lactobacillus dominance (estrogen effect); (5) **factors disrupting** — douching, antibiotics, intercourse (semen alkaline), menstruation, smoking, IUD insertion (transient), STIs; (6) **innate immunity in genital tract** — antimicrobial peptides (defensins, cathelicidin, lactoferrin, lysozyme, SLPI, elafin); IgA + IgG mucosal Ab; mucus barrier; cervical plug (pregnancy); macrophages, DCs; PRRs (TLRs) recognize PAMPs; (7) **adaptive** — mucosal IgA + tissue-resident memory T cells; (8) **clinical correlates**: (a) **BV diagnosis + treatment** — covered separately; (b) **probiotics** — Lactobacillus crispatus + reuteri studied for BV recurrence + UTI prevention — mixed evidence; (c) **vaginal microbiome transplant (VMT)** — research for recurrent BV; (d) **HIV transmission** — dysbiotic flora ↑ susceptibility; (e) **preterm birth** — dysbiosis association with PTB; investigating screening + treatment; (f) **fertility + IVF** — dysbiosis may impair; (9) **prevention** — avoid douching, manage estrogen (postmenopause local estrogen), condom use, treat partners selectively, treat BV; (10) **research** — microbiome modulation therapies

---

Vaginal microbiome: Lactobacillus dominant → lactic acid + acidic pH protective. CST I (crispatus) most stable. Dysbiosis (CST IV) → BV, STI, preterm. Estrogen → glycogen → Lactobacillus. Postmenopausal ↓ flora. Innate immunity (defensins, IgA, mucus). Probiotics + VMT research. Prevention: avoid douching, condom, treat BV.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Resident ถามอาจารย์เรื่อง vaginal microbiome + immunology + dysbiosis';

update public.mcq_questions
set choices = '[{"label":"A","text":"Provider decides everything"},{"label":"B","text":"Shared decision-making (SDM) + patient-centered care in OB"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Discharge if patient disagrees"},{"label":"E","text":"Hysterectomy"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Shared decision-making (SDM) + patient-centered care in OB**: (1) **definition** — collaborative process where patient + provider make decisions together based on best evidence + patient values/preferences/circumstances; (2) **elements (Charles)** — both parties involved, information sharing both ways, deliberation, decision; (3) **components**: (a) discuss decision needed; (b) present **best evidence options + risks + benefits + uncertainty**; (c) elicit patient values + preferences; (d) deliberate + decide; (e) review/revisit; (4) **tools**: (a) **decision aids** — written, video, interactive (e.g., MFMU VBAC calculator, BWH decision aids, BabyCenter); (b) **birth plans** — preferences documented (positions, pain mgmt, monitoring, support, episiotomy, immediate skin-to-skin, delayed cord clamping, breastfeeding, family); written + flexible; (c) **OPTION scale** for measurement; (5) **specific OB SDM opportunities** — TOLAC vs ERCD, IOL vs expectant, prenatal screening (NIPT, amnio), epidural choice, induction methods, mode of breech delivery, fertility-sparing cancer options, postpartum contraception, breastfeeding decisions, advance directives (rare); (6) **respectful maternity care** — WHO statement — autonomy, consent, dignity, no abuse/coercion/discrimination; (7) **informed consent** continuous, not one-time; (8) **trauma-informed care** — recognize prior trauma + adjust approach; (9) **cultural humility** — language, beliefs, family roles; medical interpreters; (10) **doulas + companions** — improve outcomes + experience; ACOG endorses; Medicaid coverage expanding; (11) **patient-reported outcomes** + experience measures (PROMs, PREMs); (12) **provider training** — communication skills, SDM-OPTION, motivational interviewing; (13) **system support** — time, EMR tools, scheduling, decision-aid distribution; (14) **balance** — SDM doesn''t mean patient decides alone — guidance from provider; emergency situations differ; (15) Thai context — patient rights expanding; transition from paternalistic to partnership model

---

SDM in OB: collaborative — both parties — info + values + deliberation. Decision aids + birth plans + OPTION scale. Specific opportunities: TOLAC, IOL, screening, contraception, breech. Respectful maternity care (WHO). Trauma-informed + cultural humility + doulas. Provider training + system support. Balance — not abdication of expertise.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'OB unit implements shared decision-making (SDM) tools + birth plans + patient-centered care for delivery preferences';

update public.mcq_questions
set choices = '[{"label":"A","text":"Hide and deny"},{"label":"B","text":"Disclosure + apology + just culture after adverse outcome"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Refuse to discuss"},{"label":"E","text":"Hysterectomy"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **Disclosure + apology + just culture after adverse outcome**: (1) **Patient + family disclosure** — ethical + many jurisdictions legal requirement: (a) timely (within 24-48 hr after event), (b) honest factual account, (c) acknowledge harm + expression of empathy/apology, (d) commitment to investigation + sharing findings, (e) ongoing support; (2) **''Apology laws''** — many US states protect expressions of sympathy from being used as admissions of liability — encourage transparency; Thai legal landscape — encourage open disclosure; (3) **Communication and Resolution Programs (CRPs)** — institutional approach (Michigan model, AHRQ CANDOR toolkit) — investigate + disclose + compensate when appropriate → reduces litigation + costs vs deny-defend; (4) **second victims** — providers + staff involved in adverse events suffer psychological harm — provide peer support, employee assistance, debriefing; (5) **investigation**: (a) **Root Cause Analysis (RCA)** — systematic identification of contributing factors (system, communication, equipment, training, fatigue, cognitive bias); (b) **fishbone, 5-whys** tools; (c) **avoid blame** — Just Culture framework; (6) **Just Culture** — distinguish: (a) human error (console + system fix), (b) at-risk behavior (coach), (c) reckless behavior (discipline); (7) **implementation of corrective actions** — protocol changes, equipment, training, simulation; track outcomes; (8) **morbidity + mortality (M&M) conferences** — confidential learning forum; (9) **patient safety culture** — Safety Attitudes Questionnaire; psychological safety; (10) **ongoing care + support** — continuity of care for harmed patient + family; mental health; spiritual support; (11) **bereavement + perinatal loss** — comprehensive support; (12) **legal counsel** — institutional; risk management; (13) **document** factually; (14) **share learning broadly** — lessons → other institutions; (15) **measure** — disclosure + resolution outcomes; (16) Thai context — Medical Council ethical guidelines + Thai Patient Safety Goals (2P safety, 3P safety frameworks)

---

Disclosure + apology: timely, honest, empathetic, ongoing. CRP institutional approach (CANDOR) — reduces litigation. Second victim support. RCA + Just Culture (human error vs at-risk vs reckless). M&M. Corrective actions + tracked. Safety culture. Bereavement support. Thai Patient Safety Goals. Share learning.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'Hospital reviews disclosure + apology after adverse outcome — neonatal HIE following missed CTG abnormality leading to delayed C/S';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge home"},{"label":"B","text":"COVID-19 in pregnancy with moderate-severe disease"},{"label":"C","text":"Methotrexate"},{"label":"D","text":"Refuse all treatment"},{"label":"E","text":"Hysterectomy"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** **COVID-19 in pregnancy with moderate-severe disease** — pregnancy ↑ risk severe + adverse outcomes (preterm, stillbirth, ICU, mortality, VTE): (1) **admit + supportive care** + multidisciplinary (MFM + ID + pulmonary + ICU); (2) **oxygen** — target SpO2 ≥ 95% for fetal well-being; nasal cannula → HFNC → NIV → intubation as needed; awake proning encouraged (oxygenation + delays intubation); LUD when supine; (3) **antiviral** — **remdesivir** safe in pregnancy (acceptable per CDC/IDSA — limited but reassuring data) — 5-d course for moderate-severe; **nirmatrelvir-ritonavir (Paxlovid)** for mild-moderate outpatient if early (within 5 d) + risk factors — limited pregnancy data but generally acceptable per IDSA/RECOVERY; (4) **dexamethasone** — recommended for severe (requiring O2) per RECOVERY trial — improves mortality; cross placenta but benefit > risk in severe maternal disease; consider standard antenatal corticosteroid course concurrently if preterm risk (24-34 wk); (5) **anticoagulation** — VTE risk markedly ↑ in COVID + pregnancy — **prophylactic LMWH** for all hospitalized; therapeutic for confirmed VTE; (6) **immunomodulators** — **tocilizumab** (IL-6 inhibitor) for severe + escalating O2 needs — limited pregnancy data but RECOVERY/REMAP-CAP support; baricitinib alternative; (7) **antibiotics** — only if bacterial coinfection (procalcitonin); (8) **fetal monitoring** — continuous EFM, daily NST, growth + Doppler if FGR; (9) **delivery considerations** — COVID not indication for delivery; deliver per obstetric indication or maternal deterioration; if maternal ICU + respiratory failure → may improve respiratory status with delivery (controversial); preterm delivery for failing maternal status; (10) **mode of delivery** — vaginal preferred unless obstetric indication; PPE for staff; (11) **postpartum** — continue treatment + monitor; thromboprophylaxis 6 wk postpartum; (12) **breastfeeding** — encouraged with precautions (mask, hand hygiene; SARS-CoV-2 not transmitted via milk; antibodies transferred); (13) **vaccination** — recommend mRNA COVID vaccine + boosters in pregnancy + postpartum + breastfeeding (CDC/ACOG); (14) **neonatal** — monitor + universal precautions; (15) **mental health + family support** + telehealth follow-up

---

COVID-19 pregnancy moderate-severe: admit + multidisciplinary. O2 target ≥ 95%. Remdesivir + dexamethasone (severe) + LMWH prophylaxis. Tocilizumab severe. Continuous fetal monitoring. Not indication for delivery — per obstetric. Vaginal preferred. Vaccine recommended pregnancy + postpartum. Breastfeeding safe with precautions. VTE 6 wk postpartum. Awake proning.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'ob_gyn'
  and scenario = 'หญิงตั้งครรภ์ G2P1 GA 28 wk underlying healthy — มาห้องฉุกเฉินด้วย acute COVID-19 (PCR-confirmed) — moderate-severe symptoms (SpO2 91% on RA, dyspnea, fever, fatigue) + bilateral infiltrates on CXR

V/S: BP 118/72, HR 110, RR 26, Temp 38.6, SpO2 91% RA
Gen: dyspneic, distressed
Fetal: FHR 158 reactive, no contractions
Lab: WBC 10K, CRP 95, D-dimer 2,400, ferritin 950, LDH 380, lymphocytes 0.8
CXR: bilateral ground-glass + lower lobe infiltrates
No prior COVID vaccination';

commit;
