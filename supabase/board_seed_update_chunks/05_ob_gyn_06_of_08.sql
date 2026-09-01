-- ===============================================================
-- UPDATE chunk 6/8: ob_gyn (25 questions)
-- ===============================================================

begin;

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

commit;
