-- ===============================================================
-- UPDATE chunk 5/8: ob_gyn (25 questions)
-- ===============================================================

begin;

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

commit;
