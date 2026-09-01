-- ===============================================================
-- UPDATE chunk 1/8: ob_gyn (25 questions)
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

commit;
