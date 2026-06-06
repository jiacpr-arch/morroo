-- ===============================================================
-- UPDATE chunk 4/8: ob_gyn (25 questions)
-- ===============================================================

begin;

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

commit;
