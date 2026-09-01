-- ===============================================================
-- UPDATE chunk 7/8: ob_gyn (25 questions)
-- ===============================================================

begin;

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

commit;
