-- ===============================================================
-- UPDATE chunk 3/8: ob_gyn (25 questions)
-- ===============================================================

begin;

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

commit;
