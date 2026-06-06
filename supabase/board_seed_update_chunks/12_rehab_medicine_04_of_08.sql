-- ===============================================================
-- UPDATE chunk 4/8: rehab_medicine (25 questions)
-- ===============================================================

begin;

update public.mcq_questions
set choices = '[{"label":"A","text":"No exercise — too dangerous"},{"label":"B","text":"HF Cardiac Rehab — HF-ACTION Lessons"},{"label":"C","text":"Maximum intensity always"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Discharge"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** HF Cardiac Rehab — HF-ACTION Lessons: (1) **HF-ACTION trial**: safe + modestly effective in HFrEF (trend mortality reduction, improved QOL + exercise capacity); cardiac rehab Class I HFrEF NYHA II-III on GDMT; (2) **Evaluation**: clinical status (stable + euvolemic), CPET, echo + functional status; coordinate w/ HF team; (3) **Exercise prescription**: - Aerobic: 60-70% HRR or RPE 11-13; intervals selected; 30-40 min; 3-5×/wk; - Resistance: low-mod intensity, 1-2 sets, avoid Valsalva; - Progress gradually; - Inspiratory muscle training (IMT) adjunct evidence; (4) **GDMT optimization** (4 pillars HFrEF): ARNI/ACEi/ARB + BB + MRA + SGLT2i; up-titrate before/during rehab; (5) **Monitoring**: weight (daily home), symptoms (DOE, edema, fatigue), HR, BP, ECG; recognize decompensation; (6) **Patient education**: HF (low-Na diet, fluid restriction, daily weights), meds, signs/symptoms (when call), self-care; (7) **Comorbidities**: DM, CKD, AF, COPD — addressed; (8) **Psychosocial**: depression (high in HF), anxiety, social — CBT, screen + treat; (9) **Devices**: ICD, CRT, LVAD — modifications; (10) **Advance care planning**: appropriate stage; (11) **Outcomes**: VO2, 6MWT, QOL (KCCQ, MLHFQ), hospitalization; **Modern**: home-based + telerehab + GDMT integration + HFpEF emerging evidence

---

HFrEF cardiac rehab Class I (HF-ACTION). CPET-guided 60-70% HRR. Aerobic + resistance (low Valsalva). IMT adjunct. GDMT 4 pillars optimization. Monitor decompensation. Psychosocial. Modern: home/telerehab.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วย HFrEF (EF 30%) NYHA III — referred cardiac rehab';

update public.mcq_questions
set choices = '[{"label":"A","text":"No precautions immediately"},{"label":"B","text":"Post-Sternotomy Precautions + Phase I/II"},{"label":"C","text":"Bedrest 6 wk"},{"label":"D","text":"Full lifting day 1"},{"label":"E","text":"Hospice"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-Sternotomy Precautions + Phase I/II: (1) **Sternotomy precautions** (vary by institution but typical 6-8 wk): - No lifting > 5-10 lb; - No pushing/pulling heavy; - No driving 4-6 wk; - Avoid arms overhead aggressive; - No pulling self up using arms (use "snake-out" technique — log roll + use legs); - Cough w/ pillow splint; - Maintain incision care; (2) "Move in the Tube" / "Keep Your Move in the Tube" emerging — less restrictive, allows functional UE within pain-free arc; evidence supports earlier UE use w/o sternal complications; (3) **Phase I (inpatient)**: early mobilization, education, IS use, gradual ambulation, family education; (4) **Phase II (outpatient)**: structured exercise, risk factor modification, education, psychosocial; (5) **Exercise prescription**: see standard cardiac rehab; modifications during sternotomy healing phase (UE limited initially); (6) **Wound care + monitoring**: sternal dehiscence (rare), infection (DM, obesity, smoking risk), arrhythmia (postop AF common); (7) **Pain management**: multimodal opioid-sparing; (8) **Psychosocial**: postop depression + cognitive changes (post-pump); (9) **Education**: meds (anticoagulation, antiplatelet, statin, BB, ACEi), lifestyle, when call physician; (10) **Long-term**: lifelong secondary prevention; **Modern**: ERAS cardiac + earlier mobilization + less restrictive precautions evidence

---

Post-CABG: sternal precautions 6-8 wk (no >5-10 lb, no heavy push/pull, snake-out, splint cough). "Tube" emerging less restrictive. Phase I→II. Monitor dehiscence/AF. Multimodal pain. Long-term prevention.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วย post-CABG 2 wk — sternotomy precautions + Phase I/II transition';

update public.mcq_questions
set choices = '[{"label":"A","text":"Use HR targets standard"},{"label":"B","text":"Heart Transplant Cardiac Rehab"},{"label":"C","text":"No exercise"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Discharge — no rehab"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Heart Transplant Cardiac Rehab: (1) **Unique physiology**: denervated heart — no vagal/sympathetic intrinsic response; resting HR elevated (90-110), slow rise + slow recovery w/ exercise; rely on circulating catecholamines (humoral); altered HR response — use RPE > HR target alone; (2) **Exercise prescription**: - **Use RPE primary** (11-14); - Extended warm-up + cool-down (slow HR adaptation); - Aerobic + resistance progressing; - Monitor signs/symptoms; (3) **Outcomes**: VO2 peak improves but blunted vs normal — typically 50-70% predicted; (4) **Medications + considerations**: - Immunosuppressants (calcineurin inhibitors — nephrotoxicity, HTN, DM; mycophenolate, prednisone), monitor SE; - Steroid effects (myopathy, osteopenia — resistance training important, bone health); - Antimicrobial prophylaxis; (5) **Rejection surveillance**: biopsy, echo, BNP; new symptoms → urgent eval; (6) **CV vasculopathy** (CAV — late complication): silent ischemia (denervated — no chest pain), screening; (7) **Infection precautions** during immunosuppression: handwashing, vaccinations (no live), exposure avoidance; (8) **Comorbidities**: HTN, DM, CKD, dyslipidemia — manage; (9) **Psychosocial**: post-transplant adjustment + survivor concerns + family + return to activity/work; (10) **Long-term**: malignancy risk + skin checks; **Modern**: cardiac rehab improves outcomes post-transplant + lifelong integration

---

Heart transplant rehab: denervated heart — use RPE, extended warm/cool, blunted VO2. Immunosuppression considerations + steroid SE + rejection + CAV + infection. Comorbidities. Psychosocial. Modern integrated.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วย post heart transplant 8 wk — cardiac rehab considerations';

update public.mcq_questions
set choices = '[{"label":"A","text":"Avoid exercise"},{"label":"B","text":"PAD Supervised Exercise Therapy (SET)"},{"label":"C","text":"Rest until pain-free always"},{"label":"D","text":"Single session"},{"label":"E","text":"Surgery first-line all"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** PAD Supervised Exercise Therapy (SET): (1) **Evidence**: SET first-line for IC — improves walking distance + QOL > meds + placebo; Class IA recommendation (AHA/ACC, ESC); CMS coverage for PAD SET (USA) since 2017; (2) **Protocol** (Gardner-Skinner type): - 3 sessions/wk × 12 wk supervised; - Treadmill walking — walk until moderate-severe claudication (3-4/5), rest until resolved, repeat; total 30-60 min including rest; - Gradual progression speed + grade; (3) **Mechanisms**: collateral development, mitochondrial/metabolic, endothelial, muscle adaptations, gait economy; (4) **Home-based** alternative: structured + monitored — emerging evidence comparable selected patients; (5) **Walking impairment** assessment: WIQ (Walking Impairment Questionnaire), treadmill (Gardner protocol — max walking distance MWD + pain-free PFD), 6MWT; (6) **CV risk reduction** (key): - Smoking cessation; - Statin (high-intensity); - Antiplatelet (aspirin or clopidogrel); - BP + DM control; - Mediterranean diet; - Vorapaxar/rivaroxaban selected; (7) **Revascularization** for severe/disabling — endovascular or open; (8) **Multidisciplinary**: vascular + PCP + cardiology + PT + dietitian; (9) **Foot care + ulcer prevention** in DM PAD; (10) **CLI/CLTI** — limb-threatening — urgent revascularization; **Modern**: SET + CV risk reduction integrated, home-based emerging

---

PAD: SET first-line Class IA (AHA/ACC). 3×/wk × 12 wk treadmill walk to claudication. CV risk reduction critical (statin, antiplatelet, smoking). Home-based emerging. Multidisciplinary. Foot care.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วย PAD intermittent claudication — referred supervised exercise therapy';

update public.mcq_questions
set choices = '[{"label":"A","text":"Exclude — too frail"},{"label":"B","text":"Older + Frail Cardiac Rehab — Inclusion + Adaptation"},{"label":"C","text":"Standard prescription same as young"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Hospice"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Older + Frail Cardiac Rehab — Inclusion + Adaptation: (1) **Underutilization**: frail/older underrefferred despite benefit; equity gap; aim to INCLUDE w/ adaptations; (2) **Risk stratification** + comprehensive geriatric assessment: function (gait, balance, ADL), cognition, mood, sensory, polypharmacy, social; CFS (Clinical Frailty Scale), CHAMPS; (3) **Adapted exercise prescription**: - Lower starting intensity (40-60% HRR or RPE 9-11); - Shorter duration → progress; - Include balance + strength + flexibility (functional focus); - Tai Chi, chair-based, recumbent options; - Fall prevention integrated; (4) **Address contributors**: pain, sleep, depression, anemia, sarcopenia; (5) **Nutrition**: protein 1.2-1.5 g/kg + Mediterranean; (6) **Polypharmacy management**: Beers + STOPP/START + deprescribing; (7) **Cognitive + delirium prevention**; (8) **Multidisciplinary**: cardiology + geriatrics + physiatrist + PT + OT + dietitian + pharmacy + social work; (9) **Home-based + telerehab** options for transportation barriers; (10) **Goals of care + shared decision**: function, QOL focus; advance care planning; (11) **Caregiver involvement**; (12) **Outcomes**: function (SPPB, gait speed), QOL, falls; **Modern**: equity-focused inclusion + adaptations + integrated geriatric cardiology

---

Frail/older cardiac rehab: INCLUDE w/ adaptations. CGA. Lower starting intensity + functional focus + balance/strength + fall prevention. Address contributors + polypharmacy. Multidisciplinary. Telerehab. Equity.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วยอายุ 78 ปี post-MI — frail + multimorbid — "too sick" for cardiac rehab? — referral question';

update public.mcq_questions
set choices = '[{"label":"A","text":"Single discipline only"},{"label":"B","text":"Pulmonary Rehabilitation — COPD"},{"label":"C","text":"Surgery first-line"},{"label":"D","text":"Discharge no rehab"},{"label":"E","text":"Bed rest"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pulmonary Rehabilitation — COPD: (1) **Evidence**: PR is Grade A recommendation for symptomatic COPD (mMRC ≥ 2 or post-exacerbation) — improves dyspnea, exercise capacity, QOL, reduces hospitalizations; cost-effective; underutilized; (2) **Indications**: COPD + other chronic respiratory (ILD, bronchiectasis, asthma, pulm HTN, lung Ca, pre/post lung transplant/resection); (3) **Pre-PR evaluation**: medical + exercise (6MWT or CPET) + PROs (CAT, mMRC, SGRQ); (4) **Exercise component (FITT-VP)**: - Aerobic: 60-80% peak (RPE 4-6/10 dyspnea); 20-60 min; 3-5×/wk; cycle/treadmill/walking; - Resistance: 1-3 sets, 8-15 reps, focus large muscle groups, RPE moderate; - Interval training: HIIT alternative — less dyspnea limitation; - Inspiratory Muscle Training (IMT) adjunct selected (low MIP); - Functional + balance; (5) **Duration**: 6-12 wk minimum + maintenance; (6) **Multidisciplinary**: respiratory therapist + PT + OT + nutrition + nurse + psychologist + physician; (7) **Education**: disease, meds (inhaler technique), oxygen, action plan, smoking cessation, nutrition; (8) **Psychosocial**: anxiety + depression screening + treatment; (9) **O2 supplementation** during exercise if desat (SpO2 < 88%); (10) **Smoking cessation** integrated; (11) **Post-exacerbation PR** especially effective; (12) **Home-based + tele-PR** alternatives for access; **Modern**: post-exacerbation + tele-PR + integrated chronic disease

---

PR for COPD: Grade A. Aerobic + resistance + IMT + functional. 6-12 wk. Multidisciplinary. Education + meds + O2 + smoking cessation + psychosocial. Post-exacerbation key. Tele-PR access. Modern integrated.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วย COPD GOLD III — mMRC 3 — referred pulmonary rehab';

update public.mcq_questions
set choices = '[{"label":"A","text":"Aggressive GET — push through symptoms"},{"label":"B","text":"Post-COVID-19 Rehabilitation"},{"label":"C","text":"No rehab — wait"},{"label":"D","text":"Bedrest 1 yr"},{"label":"E","text":"Discharge"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-COVID-19 Rehabilitation: (1) **Heterogeneous presentation**: pulmonary, cardiac (myocarditis, POTS), neurologic (cognitive, neuropathy), MSK (deconditioning, myopathy), psychiatric (anxiety, PTSD), autonomic, ME/CFS-like; (2) **Assessment**: comprehensive — cardiopulmonary (CPET, echo, PFT), neurocognitive, autonomic (tilt table, HUTT), MSK, psychosocial; rule out persistent organ damage; (3) **PESE (Post-Exertional Symptom Exacerbation)** screen — if present, AVOID standard graded exercise therapy (GET) — can worsen; use **pacing** + symptom-titrated activity; (4) **Pulmonary rehab elements**: breathing exercises (diaphragmatic, pursed-lip), aerobic if tolerated, IMT, education; (5) **Cardiac rehab elements**: for POTS — recumbent → upright progression (CHOP protocol), volume expansion (fluid + salt), compression, fludrocortisone/midodrine/IVA selected; (6) **Cognitive rehab**: external aids, paced cognitive activity, treat sleep + mood; (7) **PT**: graded mobility, strength, balance — SYMPTOM-TITRATED; (8) **Psychological**: CBT, ACT, mindfulness for symptom coping (not implying psychogenic); (9) **Sleep, nutrition, energy management**: pacing strategies, activity diary; (10) **Multidisciplinary clinic**: physiatry + pulm + cardio + neuro + psych + PT + OT + SLP + social work; (11) **Patient + family education + advocacy**: validate experience; (12) **Return-to-activity**: gradual + paced; return-to-sport criteria; **Modern**: PESE-aware + multidisciplinary post-COVID clinics + pacing

---

Post-COVID rehab: heterogeneous. SCREEN for PESE — avoid GET if present, use pacing. POTS protocols. Pulm + cardiac + cognitive + MSK + psych elements. Multidisciplinary clinic. Validate + family. Modern: pacing.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วย post-acute COVID-19 (long COVID) 4 mo — dyspnea + fatigue + exercise intolerance';

update public.mcq_questions
set choices = '[{"label":"A","text":"No rehab post-transplant"},{"label":"B","text":"Post-Lung Transplant Pulmonary Rehab"},{"label":"C","text":"Bedrest"},{"label":"D","text":"Maximum intensity immediately"},{"label":"E","text":"Discharge — wait rejection"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-Lung Transplant Pulmonary Rehab: (1) **Pre-transplant** "prehab": maintain exercise tolerance + nutrition + strength — predicts outcomes; (2) **Early post-transplant** (inpatient): mobilization day 1-2 if stable, IS, airway clearance, breathing exercises, gradual ambulation; (3) **Outpatient PR** (typically 4-12 wk post-transplant when stable): - Aerobic (treadmill, cycle); - Resistance — important due to steroid myopathy + critical illness; - IMT adjunct; - Education on meds + signs of rejection + infection; (4) **Exercise prescription**: HR less reliable (denervation, meds — use RPE); start moderate progress; monitor SpO2 + symptoms; (5) **Immunosuppression effects**: steroid myopathy + osteopenia (resistance training + Ca/vit D + bisphosphonate selected), DM, HTN, nephrotoxicity, infection risk; (6) **Rejection** surveillance (bronchoscopy + biopsy + PFTs) — patient watches for ↓SpO2, dyspnea, fever, FEV1 drop; (7) **CLAD/BOS** (chronic lung allograft dysfunction): ongoing concern — PR ongoing; (8) **Infection precautions** w/ immunosuppression: handwashing, vaccinations (no live), avoid exposure, mask in crowded; (9) **Psychosocial**: post-transplant adjustment, survivor concerns, family + return to work; (10) **Long-term**: lifelong PR + comprehensive care + skin cancer screening + malignancy risk; **Modern**: integrated transplant + rehab + tele-PR

---

Lung transplant PR: prehab + early mobilization + outpatient program. RPE-guided (denervation). Resistance for steroid myopathy. Immunosuppression considerations + rejection + CLAD/BOS + infection + psychosocial. Lifelong.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วย post-lung transplant 6 wk — pulmonary rehab planning';

update public.mcq_questions
set choices = '[{"label":"A","text":"Bedrest 4 wk"},{"label":"B","text":"Post-ICU Rehab — ICU-Acquired Weakness + PICS"},{"label":"C","text":"Single discipline"},{"label":"D","text":"Discharge home no services"},{"label":"E","text":"Hospice"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-ICU Rehab — ICU-Acquired Weakness + PICS: (1) **Post-Intensive Care Syndrome (PICS)**: physical (ICU-AW — critical illness polyneuropathy + myopathy), cognitive impairment, psychiatric (anxiety, depression, PTSD); family — PICS-F; (2) **Assessment**: MRC sum score (muscle strength), 6MWT, FIM, neurocog (MoCA), HADS, IES-R (PTSD); pulmonary, swallow (high dysphagia rate post-intubation); (3) **Early mobilization in ICU** (prevention) — evidence + safe (TEAM RCT mixed, but generally beneficial w/ protocol); (4) **Rehab interventions**: - PT: progressive mobility (bed → edge → stand → ambulation), strengthening, endurance; - OT: ADLs + adaptive equipment; - SLP: swallow + voice (post-intubation) + cognitive; - RT: airway clearance, IS, IMT; - Nutrition: protein-rich, calorie adequate, address sarcopenia; - Cognitive rehab + sleep + mood + family; (5) **Delirium** ongoing management — environment, sleep, sensory, address meds, treat contributors; (6) **Pulmonary**: weaning trach, IMT, breathing exercises; (7) **Address: pain, sleep, nutrition, mood, family** all contributors; (8) **Multidisciplinary IRF or LTAC** based on intensity needs; (9) **Long-term PICS clinic**: outcomes track years post-discharge; (10) **Family education + support — PICS-F**; **Modern**: ICU mobility + post-ICU clinics + integrated rehab

---

Post-ICU: PICS triad. Early ICU mobilization. Assessment MRC/6MWT/FIM/MoCA. PT + OT + SLP + RT + nutrition + cognitive + family. IRF/LTAC. Long-term PICS clinic. Family PICS-F. Modern integrated.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วยอายุ 70 ปี post-acute respiratory failure ICU 3 wk — ICU-acquired weakness + delirium — transferring rehab';

update public.mcq_questions
set choices = '[{"label":"A","text":"Bedrest"},{"label":"B","text":"CF Comprehensive Rehab"},{"label":"C","text":"No ACT"},{"label":"D","text":"Single discipline"},{"label":"E","text":"Discharge — no follow-up"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** CF Comprehensive Rehab: (1) **Multidisciplinary CF center**: pulm + RT + PT + dietitian + nurse + social work + psychologist + family; (2) **Airway clearance techniques (ACT)** daily core: - Active Cycle of Breathing Technique (ACBT); - Autogenic drainage; - PEP (positive expiratory pressure) — flutter, acapella, PARI PEP; - High-frequency chest wall oscillation (HFCWO — vest); - Postural drainage + percussion (less common now); - Adjunct nebulized hypertonic saline 7% + dornase alfa; (3) **Exercise**: aerobic + resistance — improves FEV1, QOL, BMD, mucus clearance; integrated as ACT; tailored intensity; (4) **CFTR modulators** (game-changing): elexacaftor/tezacaftor/ivacaftor (Trikafta) for eligible mutations — dramatically improves outcomes; (5) **Nutrition**: high-calorie + protein + fat + supplements (ADEK vitamins); BMI target; pancreatic enzyme replacement (PERT); (6) **CFRD** (CF-related diabetes) screening + management; (7) **Infections** — culture-directed antibiotics (P. aeruginosa, B. cepacia, MRSA, NTM); infection control between CF patients (segregation); (8) **Mental health**: depression + anxiety high prevalence; screen + treat (CF Foundation Mental Health Guidelines); (9) **Bone health, fertility, transition adult care**; (10) **Pre/post lung transplant rehab**; **Modern**: CFTR modulators + integrated multidisciplinary + telemedicine

---

CF: multidisciplinary center. ACT daily + exercise. CFTR modulators (Trikafta) game-changing. Nutrition + PERT + CFRD. Infection control. Mental health. Long-term care + transition + transplant. Modern integrated.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วย cystic fibrosis อายุ 22 ปี — chronic productive cough + declining FEV1 — airway clearance + exercise';

update public.mcq_questions
set choices = '[{"label":"A","text":"Avoid all exercise"},{"label":"B","text":"Breast Cancer-Related Lymphedema (BCRL)"},{"label":"C","text":"Just monitor — no Tx"},{"label":"D","text":"Diuretic alone"},{"label":"E","text":"Discharge"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Breast Cancer-Related Lymphedema (BCRL): (1) **Risk**: ~20% post-ALND + radiation; reduced w/ SLN biopsy + axillary reverse mapping; (2) **Staging (ISL)**: Stage 0 (subclinical) → I (reversible) → II (irreversible) → III (lymphostatic elephantiasis); (3) **Assessment**: limb volume (perometer, water displacement, circumferential), bioimpedance (L-Dex — early detection), symptoms, function, ROM, strength; rule out DVT, infection, recurrence; (4) **Complete Decongestive Therapy (CDT) — gold standard**: - **Phase 1 (intensive 2-4 wk)**: MLD (manual lymphatic drainage), multilayer short-stretch bandaging, exercise w/ bandage, skin care; - **Phase 2 (maintenance lifelong)**: compression garment (custom or off-shelf — Class 2-3), self-MLD, exercise, skin care; (5) **Compression**: garment 24-h or daytime + night bandaging/Tribute selected; (6) **Pneumatic compression pumps**: adjunct; (7) **Exercise** SAFE: strengthening (PAL trial — weights safe and helpful), aerobic; (8) **Surgical**: vascularized lymph node transfer, lympho-venous anastomosis, liposuction — selected refractory/stage II-III; (9) **Skin care**: prevent infection — moisturize, avoid trauma, treat promptly; lifelong cellulitis risk; (10) **Education + adherence + psychosocial**; (11) **CLT** (certified lymphedema therapist) PT/OT specialty; **Modern**: early detection (L-Dex) + early intervention + surgical advances

---

BCRL: 20% ALND risk. ISL staging. CDT gold standard (MLD + bandaging + exercise + skin care intensive → garment maintenance). Exercise safe (PAL). Surgical for refractory. Early detection (L-Dex) + lifelong.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วยอายุ 55 ปี post-breast Ca + axillary node dissection 6 mo — มี ipsilateral upper limb lymphedema';

update public.mcq_questions
set choices = '[{"label":"A","text":"Bedrest before surgery"},{"label":"B","text":"Prehabilitation — Oncologic"},{"label":"C","text":"No prehab"},{"label":"D","text":"Surgery delay 1 yr"},{"label":"E","text":"Hospice"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Prehabilitation — Oncologic: (1) **Concept**: optimize pre-treatment functional status to improve outcomes (postoperative morbidity, length of stay, QOL, treatment tolerance); (2) **Multimodal prehab** (most evidence): exercise + nutrition + psychological + smoking cessation + alcohol reduction; (3) **Exercise**: aerobic + resistance + IMT — 4 wk minimum often, longer better; CPET-guided when possible; (4) **Nutrition**: optimize protein, address sarcopenia + malnutrition, immunonutrition (selected — arginine, omega-3, nucleotides), pre + post; (5) **Smoking cessation**: ideally 4-8 wk pre-op — reduces pulm complications, wound; (6) **Alcohol reduction**: 4 wk pre-op recommended; (7) **Psychological**: anxiety + depression screen + treat, mindfulness, CBT; (8) **Comorbidity optimization**: DM (A1c), CV, COPD/anemia/cardiac eval; (9) **Multidisciplinary**: surgery + oncology + physiatry + PT + dietitian + psychology + smoking cessation; (10) **Evidence**: meta-analyses show reduced postop complications, shorter LOS, faster functional recovery (especially abdominal, thoracic surgery); (11) **Logistics**: prehab clinics, home-based, telerehab — increase access; (12) **Continuation**: prehab → rehab postop continuum; (13) **ERAS integration**; **Modern**: multimodal multidisciplinary + technology-enabled access

---

Prehab: optimize pre-Tx — multimodal exercise + nutrition + psych + smoking + alcohol + comorbidity. CPET-guided. Multidisciplinary. Evidence reduced complications + LOS. ERAS integration. Modern multimodal.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วยอายุ 65 ปี post-lung Ca resection (lobectomy) — chemo planning — "prehabilitation" question';

update public.mcq_questions
set choices = '[{"label":"A","text":"Opioid only escalating"},{"label":"B","text":"CIPN Management"},{"label":"C","text":"No intervention"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Discharge"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** CIPN Management: (1) **Common offenders**: platinum (cisplatin, oxaliplatin), taxanes (paclitaxel), vinca (vincristine), bortezomib, thalidomide; mechanism varies (oxaliplatin acute cold-induced + chronic, taxane axonal); (2) **Assessment**: clinical exam (sensory, motor, autonomic), PROs (CIPN20, FACT/GOG-Ntx), QST, NCS selected, functional (balance, hand function); CTCAE grading; (3) **Prevention**: limited proven — duloxetine NOT prevention; cryotherapy (taxane hand/foot — limited evidence); dose modification when CTCAE Gr 2-3; (4) **Treatment**: - **Duloxetine** — ONLY agent w/ Grade A evidence (Smith JAMA 2013) for painful CIPN; - Limited evidence: gabapentin, pregabalin, TCA, topical (capsaicin, lidocaine, ketamine/amitriptyline compound); - AVOID opioid escalation chronic; (5) **Non-pharmacologic**: - **Exercise** evidence growing — balance, sensorimotor, aerobic, resistance; - **PT/OT**: balance training, functional, adaptive equipment, fall prevention; - **Acupuncture** selected (mixed evidence); - **Scrambler therapy** — emerging; - **TENS, mind-body**; (6) **Multidisciplinary**: oncology + physiatry + neurology + PT + OT + pain medicine + behavioral; (7) **Address contributors**: B12 deficiency (metformin), DM, alcohol; (8) **Functional + safety**: fall prevention, equipment, modifications; (9) **Patient education + survivorship integration**; **Modern**: exercise + duloxetine + multimodal + survivorship clinics

---

CIPN: platinum + taxane common. CTCAE grading. Duloxetine Grade A for painful CIPN. Exercise emerging. PT/OT balance + fall prevention. Avoid opioid escalation. Multidisciplinary. Survivorship integration.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วยอายุ 60 ปี post-chemo (taxane + platinum) — chemotherapy-induced peripheral neuropathy (CIPN) — function limited';

update public.mcq_questions
set choices = '[{"label":"A","text":"Single discipline only"},{"label":"B","text":"Head & Neck Cancer Rehab"},{"label":"C","text":"Bedrest"},{"label":"D","text":"Discharge"},{"label":"E","text":"Hospice"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Head & Neck Cancer Rehab: (1) **Multimodal late effects from surgery + radiation + chemo**: dysphagia, trismus, neck/shoulder dysfunction (spinal accessory nerve), xerostomia, dental, taste/smell, voice/speech, lymphedema (face/neck), pain, fatigue, psychosocial; (2) **Multidisciplinary**: ENT + radiation oncology + medical oncology + physiatrist + SLP + PT + OT + dentistry + nutrition + lymphedema therapist + psychology; (3) **Dysphagia**: SLP — VFSS/FEES; exercises (Mendelsohn, effortful swallow, Shaker, Masako, McNeill); diet modification (IDDSI); PEG transitional; pre-treatment swallowing exercises ("prophylactic") improves outcomes; (4) **Trismus**: jaw stretching devices (TheraBite, Dynasplint), passive + active ROM, manual; (5) **Spinal accessory nerve dysfunction (post-neck dissection)**: shoulder pain + dysfunction (trap weakness) — PT scapular + RC, posture, education; (6) **H&N lymphedema**: MLD + compression face/neck (specialized therapist + garments), self-management; (7) **Xerostomia**: saliva substitutes, pilocarpine, hydration, dental fluoride; (8) **Voice**: SLP; (9) **Pain**: multimodal (neuropathic + nociceptive); (10) **Nutrition**: high-protein, supplements, PEG transitional; (11) **Dental**: pre-radiation dental clearance + fluoride trays + osteoradionecrosis prevention; (12) **Psychosocial + survivorship**; **Modern**: prehab swallowing + multidisciplinary survivorship

---

H&N cancer rehab: multimodal late effects. Multidisciplinary. Dysphagia (prophylactic exercises evidence) + trismus + SA nerve + lymphedema + xerostomia + voice + pain + nutrition + dental + psychosocial.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วยอายุ 50 ปี post-head and neck cancer (radiation + neck dissection) — dysphagia + trismus + neck pain + lymphedema';

update public.mcq_questions
set choices = '[{"label":"A","text":"Aggressive rehab — restore baseline"},{"label":"B","text":"Palliative + Hospice Rehab"},{"label":"C","text":"No rehab — hospice only"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Single discipline"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Palliative + Hospice Rehab: (1) **Definition**: rehab in life-limiting illness — goal: maximize function + QOL + dignity + symptom control; align w/ patient goals + prognosis; (2) **Integration w/ palliative care**: physiatrist + palliative care + oncology + PT + OT + SLP + chaplain + social work + family; (3) **Cancer cachexia**: complex syndrome (anorexia, weight loss, muscle wasting, inflammation); not reversed by nutrition alone; multimodal — exercise (preserves muscle), nutrition (high-protein), pharmacology (megestrol, olanzapine, corticosteroid short-term, anamorelin selected); (4) **Symptom management**: pain (multimodal), dyspnea, fatigue, nausea, anxiety, depression, delirium; (5) **Function-focused goals**: ADL preservation, mobility, transfers, falls prevention; energy conservation (4 P''s: pacing, planning, prioritizing, positioning); equipment (W/C, walker, raised toilet, shower chair, hospital bed home); (6) **Caregiver education + support**: training, respite, anticipatory grief; (7) **Communication + GoC**: prognostic awareness, advance directives, hospice transition; (8) **Discharge planning** + home health + DME; (9) **Outcomes**: function-focused (Karnofsky, PPS — palliative performance scale), symptoms (ESAS), QOL; (10) **Hospice rehab**: focus comfort + dignity + family; (11) **Bereavement support**; **Modern**: integrated rehab + palliative care + family-centered + value-based

---

Palliative rehab: function + QOL + dignity. Multidisciplinary + palliative care. Cachexia multimodal (exercise + nutrition + pharma). Symptom mgmt. Energy conservation 4P. Caregiver + GoC + hospice. Family.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วยอายุ 70 ปี advanced cancer + cachexia + functional decline — palliative rehab planning';

update public.mcq_questions
set choices = '[{"label":"A","text":"Bedrest 1 yr"},{"label":"B","text":"Post-HSCT Rehab"},{"label":"C","text":"No rehab post-HSCT"},{"label":"D","text":"Single discipline"},{"label":"E","text":"Discharge"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-HSCT Rehab: (1) **Pre-HSCT prehab**: optimize function + nutrition + psych; (2) **Inpatient post-HSCT** (during neutropenia): - In-room therapy (PT, OT) maintain mobility + strength + endurance; - Isolation/protective considerations; - Address fatigue, mucositis, GI, infection; - Bedside cycle ergometer; (3) **Early post-discharge**: progressive aerobic + resistance + flexibility — evidence improves outcomes; supervised initially; (4) **Acute GVHD** manifestations + rehab implications: skin, GI, liver — symptom mgmt + nutrition + skin care; immunosuppressant effects (steroid myopathy → resistance training important); (5) **Chronic GVHD** (3 mo+): skin (sclerodermatous → ROM + stretching + scar management), oral (dryness, ROM, sicca, dental), ocular (sicca, drops), pulmonary (BOS — pulm rehab), MSK (myositis, fasciitis, contractures), genital — multidisciplinary + targeted rehab; (6) **Long-term effects**: cardiac, endocrine, secondary malignancy, cognitive (chemo-fog), psychosocial, sexual; (7) **Multidisciplinary**: BMT + physiatry + PT + OT + SLP + nutrition + behavioral + survivorship; (8) **Vaccination + infection precautions** (re-vaccination schedule); (9) **Survivorship clinic** + lifelong follow-up; (10) **Return to work + school**: graded; **Modern**: prehab + in-room ICU mobilization + tele-PR + integrated survivorship

---

Post-HSCT rehab: prehab + inpatient in-room + early outpatient. Acute + chronic GVHD multidisciplinary targeted. Long-term effects + survivorship. Vaccination + infection. Return-to-work. Modern integrated.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วยอายุ 45 ปี post-hematopoietic stem cell transplant (HSCT) 6 wk — deconditioning + GVHD risk';

update public.mcq_questions
set choices = '[{"label":"A","text":"Opioid escalation"},{"label":"B","text":"Interdisciplinary Pain Rehabilitation Program (IPRP)"},{"label":"C","text":"Surgery"},{"label":"D","text":"Single discipline PT"},{"label":"E","text":"Discharge"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Interdisciplinary Pain Rehabilitation Program (IPRP): (1) **Concept**: comprehensive biopsychosocial chronic pain rehab — integrated team — addresses pain + function + behavior simultaneously; Cochrane + meta-analyses strong evidence improves function + QOL > usual care; (2) **Team**: physiatrist (pain medicine board) + psychologist + PT + OT + nursing + pharmacist + social work + chaplain selected; (3) **Components**: - **Education**: pain neuroscience (PNE — explains pain physiology, central sensitization, reduces fear); - **PT**: graded exercise, functional restoration, pacing, posture, ergonomics, conditioning; - **OT**: ADLs, work simulation, ergonomics, energy conservation; - **Psychological**: CBT (cognitive restructuring, behavioral activation), ACT, mindfulness, exposure for fear-avoidance, sleep, stress; biofeedback; - **Medication management**: rationalize, opioid tapering, optimize adjuvants; - **Vocational**: return to work focus; (4) **Format**: typically 3-4 wk full-day intensive; outpatient or residential; (5) **Outcomes**: pain (not elimination but reduction), function (PROs — ODI, PROMIS), mood, sleep, opioid reduction, return to work; cost-effective; (6) **Selection**: motivation + multidisciplinary candidate; not for active substance use without addressing, severe psychiatric uncontrolled; (7) **Less effective**: passive treatments alone, opioid escalation, single-discipline; (8) **Coverage challenge** US insurance — underutilized; **Modern**: biopsychosocial + tele-IPRP emerging + value-based

---

Chronic pain IPRP: comprehensive biopsychosocial. Team. CBT/ACT + PNE + graded exercise + meds rationalize + vocational. 3-4 wk intensive. Function-focused outcomes. Strong evidence. Modern: tele-IPRP.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วยอายุ 50 ปี chronic low back pain 2 yr — failed PT + meds — interdisciplinary pain program eligibility';

update public.mcq_questions
set choices = '[{"label":"A","text":"Bedrest + immobilization"},{"label":"B","text":"Complex Regional Pain Syndrome (CRPS) — Multimodal"},{"label":"C","text":"Opioid only"},{"label":"D","text":"Sympathectomy first-line"},{"label":"E","text":"Amputation"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Complex Regional Pain Syndrome (CRPS) — Multimodal: (1) **Budapest criteria** (dx): continuing pain disproportionate, w/ symptoms + signs in ≥ 3-4 categories (sensory — hyperalgesia/allodynia; vasomotor — temp/color; sudomotor/edema; motor/trophic) + no alternative dx; (2) **Multimodal** (interdisciplinary key): - **PT/OT** EARLY + intensive: graded motor imagery (GMI: laterality → imagined → mirror therapy — strong evidence), desensitization, ROM (active), strengthening, functional, mirror therapy, pool therapy; AVOID overly aggressive passive; - **Pharmacology**: bisphosphonate (alendronate, pamidronate IV — evidence in early CRPS), corticosteroid (short-course early), gabapentin/pregabalin, TCA, ketamine (IV selected), IV lidocaine selected, vit C (preventive evidence post-wrist fx — Zollinger); - **Procedures**: sympathetic block (stellate UE, lumbar LE) — diagnostic + therapeutic; SCS (selected, evidence in chronic refractory); intrathecal therapy selected; - **Psychological**: CBT, ACT, mindfulness, biofeedback, trauma-focused; - **Behavioral activation**; (3) **Early diagnosis + treatment** key; chronic refractory difficult; (4) **Education**: pain neuroscience + active rehab + function focus; (5) **Address contributors**: sleep, mood, social, work; (6) **Outcomes**: pain reduction + function + QOL; (7) **Multidisciplinary team essential**; **Modern**: early Dx + GMI + interventional adjuncts

---

CRPS: Budapest criteria. EARLY interdisciplinary. GMI + desensitization + active PT/OT (avoid aggressive passive). Bisphosphonate + corticosteroid + neuropathic. SCS refractory. Psychological. Modern: early multimodal.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วยอายุ 60 ปี chronic CRPS-I L lower limb 8 mo post-ankle sprain — burning + allodynia + skin changes';

update public.mcq_questions
set choices = '[{"label":"A","text":"Opioid escalation"},{"label":"B","text":"Fibromyalgia + Central Sensitization Rehab"},{"label":"C","text":"Bed rest"},{"label":"D","text":"Single discipline only"},{"label":"E","text":"Discharge"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Fibromyalgia + Central Sensitization Rehab: (1) **2016 ACR criteria**: WPI ≥ 7 + SS ≥ 5 OR WPI 3-6 + SS ≥ 9 + symptoms ≥ 3 mo + no alternative; (2) **Multidisciplinary** approach: physiatrist + rheumatology + PT + OT + psychology + sleep medicine + pain medicine; (3) **Education**: pain neuroscience (validate + explain central sensitization, not "in head") — reduces catastrophizing + improves engagement; (4) **Exercise** (strongest evidence): - Aerobic (low-impact: walking, cycling, aquatic) gradual progression; - Resistance training; - Mind-body (yoga, Tai Chi — evidence); - START LOW + go slow + sustain; (5) **Pharmacology** (FDA-approved): - Duloxetine (SNRI), milnacipran (SNRI), pregabalin — modest effect; - Amitriptyline (off-label, evidence); - AVOID opioids (limited evidence + central sensitization risk); (6) **CBT** + ACT + mindfulness — evidence; (7) **Sleep**: address — restorative sleep important; CBT-I; (8) **Address comorbidities**: depression, anxiety, IBS, migraine, autonomic; (9) **Adjuncts**: acupuncture, TENS, balneotherapy — modest; (10) **Self-management** + pacing + activity diary; (11) **Function-focus** (not pain elimination): PROs FIQ, PROMIS; (12) **Multidisciplinary education programs**; **Modern**: biopsychosocial + central sensitization framework + self-management

---

Fibromyalgia: 2016 ACR. Multidisciplinary. Exercise strongest evidence (aerobic + resistance + mind-body, gradual). FDA: duloxetine/milnacipran/pregabalin. AVOID opioids. CBT/ACT/mindfulness. Sleep. Function-focus.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วยอายุ 55 ปี chronic neck pain — central sensitization features — fibromyalgia features — multimodal';

update public.mcq_questions
set choices = '[{"label":"A","text":"Abrupt discontinuation"},{"label":"B","text":"Long-Term Opioid Therapy — Tapering + Multimodal"},{"label":"C","text":"Increase opioid dose"},{"label":"D","text":"Discharge — no follow-up"},{"label":"E","text":"Single discipline"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Long-Term Opioid Therapy — Tapering + Multimodal: (1) **Assessment**: function, pain, mood, OUD (DSM-5 criteria), risk (PDMP, COMM, ORT), benefit, harm; (2) **Indications taper**: lack of meaningful benefit + escalating dose + functional decline + risk (>50 MME, concurrent benzo, mental health, substance hx, advancing age); (3) **CDC + HHS guidelines**: individualized, gradual (10% per wk to month — slower for high dose + long duration), shared decision, monitor + treat withdrawal, monitor mental health; AVOID rapid/forced tapering — increases overdose + suicide; (4) **OUD screening**: if criteria met → buprenorphine/MAT (medication for OUD) referral — pause taper, transition; (5) **Multimodal pain mgmt** in lieu: - Adjuvants (gabapentinoid, TCA, SNRI, topical); - Acetaminophen, NSAID (cautious); - PT + active exercise + functional; - CBT, ACT, mindfulness; - Interventional (selected); - Sleep, mood, social; (6) **Mental health support**: depression, anxiety, PTSD common; CBT, SSRI; (7) **Address sleep, function, social**; (8) **IPRP** referral for complex; (9) **Naloxone** prescription patient + family education; (10) **Patient engagement + trust + shared decision**: avoid abandonment; (11) **Education**: realistic expectations, non-pharm strategies; **Modern**: opioid stewardship + biopsychosocial + harm reduction

---

LTOT taper: shared, individualized, gradual (10%/wk-mo). Screen OUD → MAT. Multimodal non-opioid + PT + CBT + interventional. Mental health. Avoid rapid/abandonment. Naloxone. IPRP. Modern: stewardship + harm reduction.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วยอายุ 65 ปี chronic LBP — opioid 80 MME daily 5 yr — escalating dose + functional decline';

update public.mcq_questions
set choices = '[{"label":"A","text":"Single intervention without evaluation"},{"label":"B","text":"Interventional Pain — Indication-Matched"},{"label":"C","text":"Random injection"},{"label":"D","text":"Surgery first-line all"},{"label":"E","text":"Opioid only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Interventional Pain — Indication-Matched: (1) **Comprehensive eval first**: history + exam + imaging + conservative trial; correlate symptoms to pathology; (2) **Lumbar radicular pain**: - Epidural steroid injection (transforaminal > interlaminar for unilateral; particulate vs non-particulate considerations — non-particulate for cervical/transforaminal to avoid embolic complications); - Short + intermediate-term benefit; - Surgical consideration if neuro deficit/refractory; (3) **Lumbar facet (zygapophyseal) joint pain**: - Dx: medial branch block (MBB) — 2 confirmed positive blocks (controlled prevalence false-positives); - Tx: radiofrequency ablation (RFA) of medial branches — 6-12 mo benefit, repeatable; (4) **Sacroiliac joint pain**: - Dx: SI provocation tests (≥ 3 positive — Laslett cluster) + intra-articular block (gold standard); - Tx: intra-articular steroid, RFA (lateral branches), fusion (selected refractory); (5) **Discogenic pain**: - Provocative discography controversial; - Tx limited interventionally — IDET, biacuplasty — limited evidence; - Surgical (fusion, disc replacement) selected; (6) **Spinal cord stimulation**: FBSS, CRPS, PDPN, IS — Class I evidence selected; (7) **Vertebroplasty/kyphoplasty**: acute osteoporotic compression fracture — selected; (8) **Within multimodal**: not standalone — combined w/ PT + active + psychological; (9) **Risks**: infection, hematoma, neuro, vascular; consent; (10) **Multidisciplinary**: pain medicine + physiatry + PT + behavioral; **Modern**: indication-matched + outcome-driven + multimodal integration

---

Interventional: indication-matched. Radicular → ESI; facet → MBB then RFA; SI → block; discogenic limited; SCS for FBSS/CRPS. Multimodal not standalone. Risks. Modern: outcome-driven + integrated.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วย chronic LBP — เลือก interventional pain procedure — facet vs SI vs epidural';

update public.mcq_questions
set choices = '[{"label":"A","text":"Opioid only escalating"},{"label":"B","text":"Post-Herpetic Neuralgia (PHN) Multimodal"},{"label":"C","text":"Surgery first-line"},{"label":"D","text":"Single discipline"},{"label":"E","text":"Discharge"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-Herpetic Neuralgia (PHN) Multimodal: (1) **Prevention**: shingles vaccine (Shingrix recombinant — efficacious + preferred); early antiviral within 72 h reduces PHN risk; (2) **Diagnosis**: pain in zoster dermatome > 90 d post-rash onset; (3) **First-line pharmacology**: - **Gabapentin or pregabalin** (titrate); - **TCA** (amitriptyline, nortriptyline — anticholinergic + cardiac SE elderly); - **SNRI** (duloxetine); - **Topical lidocaine 5% patch** (well-tolerated); - **Topical capsaicin 8% patch** (Qutenza — single application 30-60 min, lasts months — second/third-line); (4) **Second-line**: opioids (tramadol > strong; limited chronic use); (5) **Interventional**: - Intercostal nerve block (thoracic) — selected; - Epidural steroid — limited evidence chronic PHN; - Sympathetic block; - **Spinal cord stimulation** refractory; - Intrathecal (selected); (6) **Non-pharm**: TENS, acupuncture (limited evidence), PT/OT for function; (7) **Address contributors**: sleep, mood (depression high), social isolation; CBT; (8) **Multidisciplinary** for refractory + functional impact; (9) **Patient education**: prognosis (improves over months-yr in many), self-management; (10) **Functional + QOL focus**; **Modern**: prevention (vaccine) + multimodal + early intervention

---

PHN: prevention (Shingrix). Pharma: gabapentin/pregabalin/TCA/SNRI/lido patch/capsaicin 8%. Opioids limited. SCS refractory. Function + sleep + mood. Multidisciplinary. Modern: prevention + multimodal.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วยอายุ 65 ปี post-herpetic neuralgia thoracic dermatome 4 mo — burning + allodynia';

update public.mcq_questions
set choices = '[{"label":"A","text":"Single-modality only"},{"label":"B","text":"Biopsychosocial Pain Assessment + Plan"},{"label":"C","text":"Pain medication alone"},{"label":"D","text":"Surgery"},{"label":"E","text":"Discharge"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Biopsychosocial Pain Assessment + Plan: (1) **Comprehensive assessment**: - **Biological**: physical exam, imaging, labs, sleep, comorbidities; - **Psychological**: PHQ-9 (depression), GAD-7 (anxiety), PCL-5 (PTSD), PCS (pain catastrophizing), TSK (kinesiophobia), CSI (central sensitization inventory), substance use, sleep (PSQI, ISI); - **Social**: work, family, finances, support, advocacy, ACEs (adverse childhood experiences); (2) **Multidimensional pain assessment**: NRS, BPI (Brief Pain Inventory), pain diagram, function (ODI, RMDQ, PROMIS); (3) **Function-focused care plan**: SMART goals, return-to-activity gradient; (4) **Multimodal interventions**: - Active PT/OT (graded, functional); - CBT/ACT/mindfulness; - Sleep medicine + CBT-I; - Mood treatment (SSRI/SNRI); - Address substance use; - Vocational rehab; - Pharma rational (adjuvants > opioids); - Interventional selected; (5) **Education**: pain neuroscience (PNE) validates + reduces catastrophizing; (6) **Social work + advocacy**: housing, finances, transportation, employer; (7) **Family + peer support**; (8) **Trauma-informed care**: ACEs + PTSD frequently underlying chronic pain; (9) **Health equity**: address SDOH; (10) **Outcomes**: function + QOL + mood + pain + opioid reduction + RTW; (11) **Care coordination**: IPRP for complex; **Modern**: biopsychosocial + trauma-informed + health equity + value-based

---

Chronic pain biopsychosocial: comprehensive assessment (bio + psych + social) — multidimensional pain + function. Multimodal — active + CBT + sleep + mood + voc + meds + interventional. PNE + trauma-informed + equity.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วยอายุ 40 ปี chronic widespread pain + insomnia + depression + work disability — biopsychosocial assessment';

update public.mcq_questions
set choices = '[{"label":"A","text":"Vestibular suppressant indefinitely"},{"label":"B","text":"BPPV — Diagnosis + Canalith Repositioning"},{"label":"C","text":"Bedrest 2 wk"},{"label":"D","text":"Surgery first-line"},{"label":"E","text":"Discharge"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** BPPV — Diagnosis + Canalith Repositioning: (1) **Most common cause** of vertigo; posterior canal 85-95%; (2) **Diagnosis**: Dix-Hallpike — geotropic torsional + upbeating nystagmus (R post-canal w/ R Dix-Hallpike), latency 5-15 s, duration < 60 s, fatigues; (3) **Treatment**: - **Epley maneuver** (canalith repositioning): 4 positions held 30-60 s each; success > 80% single treatment, > 95% w/ repeated; - **Semont maneuver** alternative; - **Brandt-Daroff** home exercise — habituation if canalith repositioning fails; (4) **Lateral (horizontal) canal BPPV**: supine roll test (Pagnini-McClure) — diagnose; treat — Lempert/Gufoni/BBQ roll; (5) **Anterior canal** rare; (6) **Post-treatment instructions**: positional restrictions controversial — modern evidence does NOT require strict restrictions; (7) **Refractory** consider: alternate canal, recurrence (~50% within years), persistent canalith — repeat maneuvers; rarely posterior canal occlusion surgery for refractory; (8) **DDx**: vestibular neuritis (constant vertigo), Meniere''s (episodic + hearing + tinnitus), migraine vertigo, central (HINTS — Head Impulse, Nystagmus, Test of Skew — central if upright nystagmus + skew + normal HIT); (9) **Education + recurrence prevention**; (10) **Multidisciplinary**: physiatry + ENT + vestibular PT; **Modern**: video Frenzel goggles + VR rehab + remote diagnosis emerging

---

BPPV posterior canal: Dix-Hallpike torsional upbeating geotropic nystagmus. Epley maneuver >80% success. Semont/Brandt-Daroff alternatives. Lateral: roll test + Lempert/BBQ. Recurrence common. Education.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วยอายุ 60 ปี episodic vertigo precipitated by head position changes — 30 sec spinning — Dix-Hallpike positive R posterior canal';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continuous meclizine long-term"},{"label":"B","text":"Unilateral Vestibular Hypofunction — Vestibular Rehab"},{"label":"C","text":"Bedrest"},{"label":"D","text":"Single discipline"},{"label":"E","text":"Surgery"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Unilateral Vestibular Hypofunction — Vestibular Rehab: (1) **Acute phase Tx**: short-course corticosteroid (early < 3 d, evidence modest), vestibular suppressants (meclizine, benzo) short-term ONLY (< 3 d) — prolonged use delays compensation; antiemetics; (2) **Vestibular rehabilitation therapy (VRT)**: evidence-based; promotes compensation: - **Gaze stabilization (VOR x1, x2)**: focus on target while head moves H + V; - **Adaptation** exercises (x1, x2 viewing); - **Substitution** exercises (saccadic, COR, smooth pursuit); - **Habituation** (Norré, Cawthorne-Cooksey) for motion-provoked vertigo; - **Balance + gait training**: static → dynamic, dual-task, surface variations, head turns, eyes-open/closed; - **Functional + sport-specific** progression; (3) **Assessment**: vHIT, caloric, VEMP, posturography, DGI, TUG, mini-BESTest, ABC scale, DHI (Dizziness Handicap Inventory), 10MWT; (4) **Home program**: daily 3-5×, several minutes; intensity-titrated (mild symptoms during/after — adaptive); (5) **Subset**: Persistent Postural-Perceptual Dizziness (PPPD) chronic — VRT + CBT + SSRI; (6) **Outcomes**: DHI, ABC, gait/balance, return to activity; (7) **Multidisciplinary**: vestibular PT + neurology/ENT + physiatry + psychology if PPPD; (8) **Patient education + reassurance + active engagement**; **Modern**: VR-based VRT + telerehab + chronic dizziness as PPPD

---

Unilateral vestib hypofunction VRT: gaze stab + adaptation + substitution + habituation + balance/gait. AVOID prolonged suppressants (delay compensation). Assessment vHIT/caloric + functional. PPPD chronic — CBT + SSRI.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'rehab_medicine'
  and scenario = 'ผู้ป่วยอายุ 55 ปี acute vestibular neuritis 5 d ago — persistent imbalance + chronic dizziness';

commit;
