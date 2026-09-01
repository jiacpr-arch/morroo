-- ===============================================================
-- UPDATE chunk 5/8: psychiatry (25 questions)
-- ===============================================================

begin;

update public.mcq_questions
set choices = '[{"label":"A","text":"Punishment"},{"label":"B","text":"Desmopressin (DDAVP)"},{"label":"C","text":"Long-term TCA only"},{"label":"D","text":"Surgery"},{"label":"E","text":"Diaper indefinitely"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Primary Nocturnal Enuresis (DSM-5: repeated voiding into bed or clothes ≥ 2×/wk × 3 mo + chronologic age ≥ 5 yo + functional impairment + not due to medical condition): (1) Education + reassurance — common (15% age 5, 5% age 10), often familial, usually outgrown; reduce blame + shame; (2) Behavioral first-line: - **Enuresis alarm** = most effective long-term (cure rate 60-70%); requires motivation + consistency × 8-16 weeks; relapse rate low; - Fluid restriction evening; - Scheduled bathroom; - Reward system (star chart); - Constipation treatment (often comorbid); (3) **Medication** if alarm fails or short-term need (sleepovers, camp): - **Desmopressin (DDAVP)** — oral or sublingual; mimics ADH; effective acutely but high relapse on discontinuation; risk hyponatremia (limit fluids); - **Imipramine (TCA)** — historical; cardiotoxicity in overdose; less preferred; (4) Address comorbidity: constipation, ADHD (high comorbid), psychological/family stress; (5) Distinguish: - Primary (never dry) vs secondary (regression after 6 mo dryness) — secondary suggests stressor, abuse, medical (DM, UTI, OSA, neurologic); - Monosymptomatic (nocturnal only) vs polysymptomatic (urgency, frequency, daytime); (6) Workup: UA + culture, evaluate for constipation, OSA screening; further if secondary or atypical; (7) Family support + education; (8) Long-term: spontaneous resolution common; treatment hastens; (9) Multidisciplinary if complex: pediatrics, pediatric urology, child psychiatry if behavioral/family

---

Primary Nocturnal Enuresis: common, often familial, usually outgrown. Education + reassurance. Enuresis alarm = most effective long-term. Desmopressin for short-term/refractory. Address constipation + ADHD comorbidity. Distinguish primary vs secondary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'เด็กชายอายุ 7 ปี — nocturnal bedwetting ≥ 2×/wk × 6 เดือน, no daytime symptoms (primary nocturnal enuresis — never been dry for 6 mo); developing self-esteem impact + missing sleepovers

No UTI, no DM, no structural anomaly
Neurologic exam normal, no constipation
Family hx: father had bedwetting until age 9';

update public.mcq_questions
set choices = '[{"label":"A","text":"Punishment"},{"label":"B","text":"Functional Encopresis with Constipation + Overflow Incontinence (DSM-5: repeated passage of feces in inappropriate places ≥ 1×/mo × 3 mo + age ≥ 4 yo + not due to medical or substance)"},{"label":"C","text":"Single dose laxative only"},{"label":"D","text":"Surgery"},{"label":"E","text":"No treatment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Functional Encopresis with Constipation + Overflow Incontinence (DSM-5: repeated passage of feces in inappropriate places ≥ 1×/mo × 3 mo + age ≥ 4 yo + not due to medical or substance): (1) **Medical disimpaction first** — clear stool retention before maintenance; options: - Oral PEG (polyethylene glycol — Miralax) — high-dose × 3-5 days; well-tolerated; - Enema (saline, mineral oil) if oral fails; - Manual disimpaction rarely; (2) **Maintenance laxative** for 6 mo+ (often 1-2 yr): - PEG daily (titrate to soft daily BM); - Lactulose alternative; - Continue until pattern stable + child''s confidence restored; (3) **Behavioral interventions**: - Scheduled toilet sitting after meals (gastrocolic reflex); - Reward system (star chart); - Education about anatomy + reassurance (it''s not their fault); - Reduce shame + blame; (4) Dietary: fiber, fluids; not primary intervention but supportive; (5) Address psychological component: anxiety, school avoidance, family stress, abuse if suggested by secondary onset; (6) Distinguish: - Primary (never trained) vs secondary (regression — consider stressor); - With/without constipation; - Behavioral retention (toilet phobia, withholding); (7) Education key — sustained treatment often needed; relapse common if treatment stopped early; (8) Multidisciplinary: pediatrics, pediatric GI if refractory, child psychiatry if behavioral, OT/behavioral specialist; (9) Long-term: most resolve with sustained treatment; gradual normalization; (10) Family support + education

---

Functional Encopresis: usually with constipation + overflow. Medical disimpaction → maintenance laxative (months-years) + behavioral (scheduled toileting, reward, education). Address shame + blame. Relapse common if stopped early. Distinguish primary vs secondary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'เด็กชายอายุ 6 ปี × 8 เดือน — repeated involuntary passage of feces into clothing ≥ 1×/mo, often hard stools followed by leakage of looser stool (overflow incontinence); history of constipation + painful BM × 1 ปี; stool withholding behavior; social distress

Physical exam: palpable fecal mass abdomen, normal anus + neuro
No medical disease';

update public.mcq_questions
set choices = '[{"label":"A","text":"Punishment"},{"label":"B","text":"Stable, sensitive, responsive caregiving = primary ''treatment''"},{"label":"C","text":"Coercive attachment therapy (rebirthing)"},{"label":"D","text":"Surgery"},{"label":"E","text":"Return to institution"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Reactive Attachment Disorder (DSM-5: pattern of inhibited + emotionally withdrawn behavior toward caregivers + minimal social-emotional responsiveness + insufficient care history; before age 5; developmental age ≥ 9 mo): (1) **Stable, sensitive, responsive caregiving = primary ''treatment''** — child needs sustained, predictable, attuned caregiver; (2) **Attachment-based therapies** — evidence-based: - **Attachment + Biobehavioral Catch-up (ABC)** — coaches caregivers in following child''s lead, nurturance; - **Child-Parent Psychotherapy (CPP)** — dyadic; - **Parent-Child Interaction Therapy (PCIT) adapted**; - AVOID coercive ''attachment therapies'' (rebirthing, holding therapy — harmful, not evidence-based, deaths reported); (3) Trauma-focused CBT if old enough + indicated; (4) Address developmental delays — early intervention services, speech, OT, PT; (5) Address caregiver capacity + support — caregiver education, mental health support for adoptive parents, respite care; (6) Distinguish: - Autism (social communication deficits across all settings vs RAD specific to attachment + improves with caregiver); - Depression; - Disinhibited Social Engagement Disorder (DSED — overly familiar with strangers — different presentation of similar history of insufficient care); (7) Long-term: improvement with stable caregiving but may have residual attachment difficulties + risk of psychiatric disorders; (8) Educational + social support; (9) Multidisciplinary: child psychiatry, child psychologist, pediatrics, social work, school, family

---

Reactive Attachment Disorder: inhibited + withdrawn + insufficient care history. Stable responsive caregiving = primary. Attachment-based therapies (ABC, CPP). AVOID coercive ''attachment therapies'' (harmful). Distinguish from autism (across all settings). Long-term improvement possible.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'เด็กชายอายุ 4 ปี — adopted at age 2 จาก orphanage (institutionalized 0-2 yo, neglected) — pattern of inhibited + emotionally withdrawn behavior toward caregivers, minimal seeking of comfort when distressed, minimal response to comfort, minimal positive affect, episodes of unexplained irritability, sadness; insufficient care history confirmed

Not meeting autism criteria
Developmental milestones delayed but improving
Adoptive family loving + committed';

update public.mcq_questions
set choices = '[{"label":"A","text":"Reinforce indiscriminate friendliness"},{"label":"B","text":"Disinhibited Social Engagement Disorder (DSED"},{"label":"C","text":"No intervention"},{"label":"D","text":"Surgery"},{"label":"E","text":"Punishment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Disinhibited Social Engagement Disorder (DSED — DSM-5: pattern of overly familiar behavior with unfamiliar adults + insufficient care history; developmental age ≥ 9 mo): (1) Stable + consistent caregiving — same as RAD; (2) Safety priority — child at risk going with strangers, abduction risk — caregiver vigilance, education on safety boundaries; (3) Behavioral interventions teaching appropriate social boundaries — physical proximity, who is family/friend, stranger awareness; (4) Attachment-based interventions: ABC, CPP, PCIT adapted; (5) Address comorbid developmental delays, ADHD (high comorbidity); (6) AVOID coercive attachment therapies; (7) Distinguish from: - RAD (inhibited/withdrawn — both reflect insufficient care, different presentations); - ADHD impulsivity (treat both if present); - Autism (social communication deficits broader, restricted interests); - Williams syndrome (excessive friendliness — genetic); (8) Long-term: may persist into adolescence + adulthood with continued indiscriminate friendliness, attention-seeking, difficulty with intimate relationships; ongoing intervention helpful; (9) Educational + social skills training; (10) Multidisciplinary: child psychiatry, child psychologist, pediatrics, special education, social work, family

---

Disinhibited Social Engagement Disorder: overly familiar with strangers + insufficient care history. Safety priority (stranger danger). Stable caregiving + behavioral teaching boundaries. Attachment-based. Distinguish RAD (inhibited) vs DSED (disinhibited) vs autism vs ADHD vs Williams.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'เด็กหญิงอายุ 5 ปี — adopted at 3 จาก orphanage (institutionalized 0-3 yo) — overly familiar with unfamiliar adults (will go with strangers without hesitation, hugs strangers, lacks normal stranger anxiety) + reduced reticence; persists 2 ปี post-adoption

Not meeting autism criteria
Developmentally appropriate other areas';

update public.mcq_questions
set choices = '[{"label":"A","text":"Haloperidol for hallucinations"},{"label":"B","text":"AVOID typical antipsychotics + most atypicals"},{"label":"C","text":"Typical antipsychotic"},{"label":"D","text":"Surgery"},{"label":"E","text":"Discharge"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Dementia with Lewy Bodies (DLB) — DSM-5 Major Neurocognitive Disorder due to Lewy body disease (core features: fluctuating cognition, visual hallucinations, parkinsonism, REM sleep behavior disorder; supportive: severe neuroleptic sensitivity, DAT scan abnormality, autonomic dysfunction): (1) **Cholinesterase inhibitor** — rivastigmine (best evidence) or donepezil — may improve cognition + reduce hallucinations + behavior; (2) **AVOID typical antipsychotics + most atypicals** (severe neuroleptic sensitivity → worsen parkinsonism, NMS, sudden death): - If absolutely needed for severe psychosis — **quetiapine** lowest dose or **pimavanserin** (5-HT2A inverse agonist — FDA approved Parkinson''s psychosis, used off-label DLB); - Clozapine low-dose alternative; (3) **REM sleep behavior disorder**: melatonin 3-12 mg HS first-line; clonazepam alternative; (4) **Parkinsonism**: carbidopa-levodopa cautious (may worsen psychosis); lower dose than PD; (5) Non-pharmacologic for behaviors: structured environment, address triggers; (6) Autonomic dysfunction: orthostasis (compression stockings, fluid, salt, midodrine, droxidopa), constipation, urinary; (7) Caregiver education + support — DLB different from AD; (8) Distinguish: - Parkinson''s disease dementia (PDD — same pathology, dementia > 1 yr after motor sx; DLB — cognitive onset before or within 1 yr of motor); - Alzheimer''s (less hallucinations, less parkinsonism, less fluctuation); - Vascular dementia; - FTD; (9) Multidisciplinary: neurology, psychiatry, sleep medicine, primary care, family; (10) Long-term: progressive; survival often 5-8 yr

---

Dementia with Lewy Bodies: fluctuating cognition + visual hallucinations + parkinsonism + RBD. Cholinesterase inhibitor (rivastigmine). AVOID typical/most atypical antipsychotics (severe neuroleptic sensitivity). Quetiapine/pimavanserin if essential. Melatonin for RBD. Levodopa cautious.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 72 ปี × 18 เดือน — progressive cognitive decline with fluctuating attention/alertness, prominent visual hallucinations (small animals, children — well-formed), parkinsonism (bradykinesia, rest tremor, rigidity), REM sleep behavior disorder (acting out dreams), severe sensitivity to antipsychotics tried for hallucinations (developed severe parkinsonism with risperidone)

MMSE 22
DAT scan abnormal (low striatal uptake)
No stroke, no major depression';

update public.mcq_questions
set choices = '[{"label":"A","text":"Ignore vascular risk factors"},{"label":"B","text":"Vascular Dementia / Vascular Cognitive Impairment (DSM-5 Major Neurocognitive Disorder due to vascular disease)"},{"label":"C","text":"Discharge no treatment"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Vascular Dementia / Vascular Cognitive Impairment (DSM-5 Major Neurocognitive Disorder due to vascular disease): (1) **Vascular risk factor modification = mainstay** (prevents progression): - **BP control** (target < 130/80 generally; individualize elderly); - **Glycemic control** in DM; - **Lipid management** (statin); - **Antiplatelet** (aspirin) for secondary prevention if applicable; - **Anticoagulation** if AFib (CHA2DS2-VASc); - **Smoking cessation**; - **Exercise + diet + weight + sleep**; (2) Cholinesterase inhibitor — modest benefit (less evidence than AD); donepezil, galantamine; memantine modest; (3) Treat depression (vascular depression common — frontal subcortical pattern); SSRI; (4) Non-pharmacologic: cognitive stimulation, structured routine, physical activity; (5) Address comorbid AD pathology (mixed dementia very common — most ''pure'' vascular has AD component); (6) Fall prevention (gait, urinary urgency); (7) Caregiver education + support; (8) Advance planning + safety + driving assessment; (9) Long-term: progressive — stepwise (vascular events) or gradual (small vessel disease); (10) Multidisciplinary: neurology, primary care, geriatric, PT/OT, social work, caregiver; (11) Distinguish: Alzheimer''s (insidious, episodic memory prominent); DLB (hallucinations, parkinsonism, fluctuations); FTD (behavioral/language)

---

Vascular Dementia: stepwise + risk factors. Vascular risk factor modification mainstay. Cholinesterase inhibitor modest. Treat vascular depression. Mixed dementia (AD + vascular) very common. Distinguish from AD/DLB/FTD.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 68 ปี — stepwise cognitive decline × 2 ปี (sudden worsening then plateaus, repeated 3 ครั้ง) — executive dysfunction prominent (planning, organization), gait disturbance (small-stepped, magnetic), urinary incontinence; history of multiple TIAs, HTN, DM, hyperlipidemia, smoker

MMSE 21 (frontal-subcortical pattern: poor word generation, set-shifting)
MRI: multiple lacunar infarcts + extensive periventricular white matter disease';

update public.mcq_questions
set choices = '[{"label":"A","text":"Cholinesterase inhibitor (donepezil)"},{"label":"B","text":"NO disease-modifying treatment"},{"label":"C","text":"Memantine"},{"label":"D","text":"Surgery"},{"label":"E","text":"No treatment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Frontotemporal Dementia (FTD) — DSM-5 Major Neurocognitive Disorder due to FTD (behavioral variant — bvFTD: disinhibition, apathy, loss of empathy, perseveration/compulsions, dietary changes, executive dysfunction; primary progressive aphasia variants — semantic + non-fluent): (1) Confirm diagnosis: clinical + MRI/PET (frontotemporal atrophy/hypometabolism) + neuropsych testing + rule out psychiatric disorders (often misdiagnosed as depression, BP, OCD initially); (2) **NO disease-modifying treatment** — symptomatic only; (3) Symptomatic medication: - **SSRI** for behavioral symptoms (disinhibition, compulsive behaviors, irritability) — first-line; - **Trazodone** for behavior + sleep; - **Atypical antipsychotic** for severe behavioral (last-line — black box mortality elderly dementia); - **AVOID cholinesterase inhibitors** (not effective, may worsen) and **memantine** (not effective for FTD — unlike AD); (4) Non-pharmacologic: behavioral + environmental management (structure, routine, addressing triggers, redirecting), caregiver coaching; (5) Caregiver support essential — behavioral changes very challenging; FTD caregivers high burnout; FTD Association resources; (6) Safety: driving cessation (often impulsive), financial protection (impaired judgment), supervision, wandering; (7) Speech-language therapy for PPA variants; (8) Advance planning urgent — younger onset, rapid progression; capacity assessment; (9) Genetic counseling (30-50% familial — C9orf72, GRN, MAPT genes); (10) Multidisciplinary: behavioral neurology, psychiatry, speech-language, social work, caregiver support; (11) Long-term: progressive 5-10 yr; some forms shorter (ALS-FTD)

---

Frontotemporal Dementia: behavioral variant (disinhibition, apathy, perseveration, hyperorality) or PPA. NO disease-modifying. SSRI/trazodone for behavior. AVOID cholinesterase inhibitor + memantine (not effective). Caregiver support critical. Genetic counseling (30-50% familial).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 60 ปี × 2 ปี — early behavioral changes (disinhibition, socially inappropriate behavior, loss of empathy, apathy, perseveration, hyperorality — overeating sweets + new dietary preferences); memory + visuospatial relatively preserved early; family describes ''personality change''

MMSE 25 (memory preserved early)
MRI: frontotemporal atrophy
No stroke, no major depression';

update public.mcq_questions
set choices = '[{"label":"A","text":"Haloperidol IM"},{"label":"B","text":"Parkinson''s Disease Psychosis (PDP — common in PD with cognitive impairment + dopaminergic therapy)"},{"label":"C","text":"Stop carbidopa-levodopa"},{"label":"D","text":"Surgery"},{"label":"E","text":"Risperidone"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Parkinson''s Disease Psychosis (PDP — common in PD with cognitive impairment + dopaminergic therapy): (1) **Rule out delirium first** — infection, electrolytes, urinary retention, dehydration, polypharmacy; (2) **Medication review** — reduce or stop most likely offenders in this order: anticholinergics → amantadine → dopamine agonists (pramipexole, ropinirole) → MAO-B inhibitors → COMT inhibitors → minimize levodopa last (essential for motor); (3) **Optimize cognition**: cholinesterase inhibitor (rivastigmine — FDA approved PDD; reduces hallucinations + improves cognition); (4) **Antipsychotic only if essential**: - **Pimavanserin** (5-HT2A inverse agonist) — FDA approved for PDP — does NOT worsen motor — first-line; - **Quetiapine** low-dose alternative; - **Clozapine** low-dose effective but monitoring requirements; - **AVOID** typical antipsychotics + risperidone + olanzapine + most atypicals (worsen parkinsonism); (5) Non-pharmacologic: lighting (reduce shadows), simple environment, reassurance, caregiver education; (6) Comorbid: PDD (Parkinson''s disease dementia — overlap with DLB pathology); depression (40-50% PD); anxiety; RBD; (7) Multidisciplinary: neurology (movement disorders), psychiatry, primary care; (8) Caregiver support; (9) Long-term: progressive; psychosis predicts nursing home placement

---

Parkinson''s Disease Psychosis: rule out delirium → reduce offending medications in order → optimize cognition (rivastigmine) → antipsychotic only if essential (pimavanserin first-line, quetiapine/clozapine; AVOID typical/most atypical — worsen motor).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 75 ปี Parkinson''s disease × 8 ปี on carbidopa-levodopa + pramipexole — ขณะนี้มี visual hallucinations (sees people in house at night, recognizes them not real — minor hallucinations initially, progressing) + paranoid ideation (someone stealing things)

MMSE 24 (mild cognitive impairment)
No delirium, no infection, no recent medication changes
No depression';

update public.mcq_questions
set choices = '[{"label":"A","text":"No treatment — natural grief"},{"label":"B","text":"SSRI first-line"},{"label":"C","text":"TCA monotherapy"},{"label":"D","text":"Surgery"},{"label":"E","text":"Long-term benzodiazepine"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Late-Life Depression (MDD in elderly — often presents with somatic complaints, cognitive complaints — ''pseudodementia'', anhedonia more than sadness): (1) Comprehensive workup: - Medical (TSH, B12, folate, electrolytes, CBC, renal/hepatic, vitamin D, medication review — many cause depression); - Cognitive assessment (depression can cause pseudodementia — reversible — but also coexist with dementia); - Distinguish from grief; (2) **SSRI first-line** — sertraline, escitalopram, mirtazapine (insomnia + weight loss bonus elderly); avoid paroxetine (anticholinergic) + citalopram > 20mg (QT, hyponatremia, elderly cap); SNRI also; bupropion alternative; **Start LOW, GO SLOW**; full effect 6-12 wk in elderly (longer than adult); (3) Psychotherapy — IPT (especially for late-life grief + role transition), CBT, problem-solving therapy, behavioral activation; effective for elderly (despite stereotypes); (4) ECT highly effective + safe in elderly + first-line for severe + suicidal + psychotic + medical instability; (5) Address comorbid medical conditions; treat pain; (6) Suicide risk **HIGH in elderly** (especially older men) — assess; (7) Social interventions: connection, peer support, senior centers; (8) Hyponatremia risk with SSRI in elderly (SIADH) — monitor Na; (9) Fall risk monitoring (SSRI, sedating meds); (10) Multidisciplinary: geriatric psychiatry, primary care, social work; (11) Long-term: maintenance often longer than younger adults; relapse high

---

Late-Life Depression: often somatic + cognitive complaints + anhedonia. Comprehensive workup. SSRI first-line — start LOW, go SLOW. Watch hyponatremia, fall risk, anticholinergic. ECT very effective elderly. Suicide risk HIGH. Psychotherapy effective. Distinguish from dementia (can coexist).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 78 ปี recently widowed (6 mo ago) — depressed mood, anhedonia, fatigue, sleep disturbance, decreased appetite + weight loss 5kg, somatic complaints (pain, GI), social withdrawal, complaints of memory + concentration; passive SI

No prior psychiatric history
Medical: HTN, DM (on metformin), mild CKD
MMSE 26 (mild cognitive concerns)
No psychotic features
GDS 12 (severe)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Discharge home without intervention"},{"label":"B","text":"Elderly Suicide Risk — Multiple Risk Factors (older men HIGHEST suicide rate of any demographic; firearms predominant method)"},{"label":"C","text":"Allow firearm in home"},{"label":"D","text":"No follow-up"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Elderly Suicide Risk — Multiple Risk Factors (older men HIGHEST suicide rate of any demographic; firearms predominant method): (1) **Comprehensive risk assessment** — protective + risk factors: - **Risk**: prior attempts, depression, chronic illness, pain, cognitive decline, social isolation, recent loss, hopelessness, burden perception, access to means (firearm here); - **Protective**: family connections (engage), purpose, religious beliefs, treatment engagement; (2) **Means restriction** = most evidence-based — **remove firearm from home** immediately (have family member temporarily store, gun safe with combination by other person, voluntary surrender to law enforcement); medication storage; (3) **Treat depression aggressively**: SSRI first-line + psychotherapy (IPT, CBT); ECT for severe; (4) **Address chronic pain**: integrative pain management, physical therapy, non-opioid medications, psychological strategies; (5) **Address social isolation**: senior community programs, family engagement, peer support, meaningful activities, volunteer; (6) **Address medical decline**: optimize care, palliative care if appropriate, advance care planning; (7) **Reduce burden perception**: family communication, find meaningful role, life review; (8) **Caregiver involvement**: education on warning signs, communication, removal of means; (9) **Safety planning** (Stanley-Brown): warning signs, internal coping, social distractions, contacts, professionals, means restriction; (10) **Frequent follow-up**; (11) Hospitalize if active ideation + plan + access; (12) **Address pain + dignity + autonomy** — palliative + hospice if terminal; (13) **Multidisciplinary**: geriatric psychiatry, primary care, social work, family, palliative care, pain medicine

---

Elderly Suicide: older men HIGHEST rate. Firearms predominant. Means restriction (remove firearm) most evidence-based. Treat depression aggressively (SSRI, ECT). Address pain, isolation, burden perception. Safety planning. Multidisciplinary. Caregiver involvement.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 75 ปี recently retired, wife died 1 ปี ago, social isolation, chronic pain (osteoarthritis), declining health (recent CHF diagnosis), beginning cognitive concerns — มา OPD ตามที่ลูกพา; ผู้ป่วยกล่าว ''I''m a burden, family would be better off without me''; firearm in home

PHQ-9: 18, GDS-15: 12
No specific plan but passive SI present';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue alprazolam at higher dose"},{"label":"B","text":"Generalized Anxiety + Inappropriate Benzodiazepine in Elderly (Beers Criteria — avoid BZD in elderly: falls, cognitive impairment, dependence)"},{"label":"C","text":"Long-term Z-drug"},{"label":"D","text":"Surgery"},{"label":"E","text":"No treatment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Generalized Anxiety + Inappropriate Benzodiazepine in Elderly (Beers Criteria — avoid BZD in elderly: falls, cognitive impairment, dependence): (1) **Taper benzodiazepine gradually** — long-term BZD in elderly increases falls, fractures, cognitive impairment, motor vehicle accidents, dependence; gradual taper 10-25% reduction every 2 weeks (longer if longer use); (2) **CBT for anxiety** in elderly — modified for cognitive + sensory needs; effective; (3) **SSRI/SNRI** as alternative — escitalopram, sertraline (lower fall risk, no dependence); start LOW go SLOW; (4) Buspirone alternative — no dependence, no sedation; slower onset; (5) Pregabalin alternative; (6) Address sleep — CBT-I; melatonin agonist; trazodone low-dose; AVOID Z-drugs (zolpidem — same risks as BZD in elderly); (7) Address underlying contributors: pain, medical conditions, medications causing anxiety (steroids, decongestants, caffeine), social isolation; (8) Lifestyle: exercise (gentle — tai chi, yoga, walking), relaxation, social engagement; (9) Comorbidity: depression (40%), cognitive impairment (anxiety can mimic + coexist), other anxiety disorders; (10) Family education + support; (11) Multidisciplinary: geriatric psychiatry, primary care, physical therapy (fall prevention), social work; (12) Long-term: chronic but treatable; avoid lifelong BZD

---

Geriatric Anxiety + inappropriate BZD: Beers criteria avoid BZD elderly (falls, cognition, dependence). Taper gradually. CBT + SSRI/SNRI/buspirone alternatives. CBT-I for sleep (AVOID Z-drugs same risks). Multidisciplinary including fall prevention.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 75 ปี — chronic generalized anxiety × 2 ปี — excessive worry about health, family, finances; somatic sx (palpitations, GI, headache); poor sleep; PCP started alprazolam 0.5 mg TID 6 เดือนก่อน — ขณะนี้มี fall × 2, fracture wrist, cognitive complaints, family concerned

GAD-7: 14
MMSE 26 (mild)
No MDD criteria met
Beers criteria flag benzodiazepine in elderly';

update public.mcq_questions
set choices = '[{"label":"A","text":"First-line haloperidol IM"},{"label":"B","text":"Behavioral + Psychological Symptoms of Dementia (BPSD) — Non-Pharmacologic First-Line"},{"label":"C","text":"Long-term benzodiazepine"},{"label":"D","text":"Surgery"},{"label":"E","text":"Restraints"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Behavioral + Psychological Symptoms of Dementia (BPSD) — Non-Pharmacologic First-Line: (1) **Comprehensive assessment**: - **Medical**: rule out delirium (infection, electrolytes, urinary retention, pain, constipation, medication side effects, dehydration); - **Functional**: triggers (care procedures, time of day — sundowning, environment, sensory); - **Psychiatric**: depression (often presents as agitation in dementia), psychosis, anxiety; - **DICE algorithm**: Describe, Investigate, Create, Evaluate; (2) **Non-pharmacologic = first-line** (essential; reduces medication use): - **Address triggers** — care procedures gentle, predictable, explain, choice when possible; - **Environmental**: lighting (day/night cycle), noise reduction, familiar objects, structure; - **Music therapy** (personalized — strong evidence); - **Reminiscence**, art, pet therapy; - **Exercise**, walking, gardening; - **Caregiver training** — communication, validation, redirection; - **Sleep hygiene** (sundowning); (3) Address pain (often missed in dementia — assess + treat scheduled if suspected); (4) Address depression (SSRI — citalopram CitAD trial); (5) **Pharmacologic only if severe + non-pharmacologic insufficient + danger** (NEVER first-line): - **SSRI** (citalopram — modest evidence); - **Trazodone** for sleep + agitation; - **Atypical antipsychotic** (risperidone, olanzapine, quetiapine) for severe — **BLACK BOX warning increased mortality elderly with dementia** — risk-benefit + family discussion + lowest dose + shortest time + reassess; - **Brexpiprazole** FDA approved 2023 specifically for AD agitation; - **AVOID benzodiazepines** (worsen cognition, falls, paradoxical agitation); - **AVOID anticholinergics**; (6) Caregiver support + education + respite; (7) Multidisciplinary: geriatric psychiatry, primary care, nursing, OT, social work, family

---

BPSD: non-pharmacologic FIRST (rule out delirium, address triggers, environment, music therapy, caregiver training, treat pain). Pharmacologic only if essential — atypical antipsychotic black box mortality. Brexpiprazole FDA approved 2023 AD agitation. AVOID BZD + anticholinergic.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 82 ปี Alzheimer''s dementia (MMSE 14) ใน nursing home — recent escalation in agitation: yelling, hitting staff during care (bathing, dressing), wandering at night, pacing; family + staff requesting management

No acute medical change (UA negative, no constipation, no pain identified, no medication change recent)
No psychosis acutely';

update public.mcq_questions
set choices = '[{"label":"A","text":"Antipsychotic monotherapy without immunotherapy"},{"label":"B","text":"Anti-NMDA Receptor Encephalitis — Autoimmune Encephalitis Mimicking Psychiatric Disorder (young women predominantly, often paraneoplastic — ovarian teratoma; treatable)"},{"label":"C","text":"Discharge with first episode psychosis dx"},{"label":"D","text":"Surgery only without immunotherapy"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Anti-NMDA Receptor Encephalitis — Autoimmune Encephalitis Mimicking Psychiatric Disorder (young women predominantly, often paraneoplastic — ovarian teratoma; treatable): (1) **Tumor removal** — ovarian teratoma resection is curative + diagnostic confirmation in paraneoplastic cases; full search (transvaginal US, CT/MRI pelvis); (2) **Immunotherapy first-line**: - **IV methylprednisolone** 1g × 5 days; - **IVIG** 2g/kg over 5 days; - **Plasmapheresis** alternative; - first-line usually combined with steroid; (3) **Second-line if first-line fails (50%)**: rituximab, cyclophosphamide; (4) Long-term: mycophenolate, azathioprine; (5) **Symptomatic management**: - Antipsychotic for psychosis (BUT severe sensitivity to neuroleptics + NMS risk — careful, lowest dose, often quetiapine); - Benzodiazepine for catatonia + seizures; - Anti-epileptic for seizures; - Supportive ICU for autonomic instability; (6) **Diagnostic workup** all young patients with new-onset psychosis + neurological features: - Anti-NMDA antibodies (CSF more sensitive than serum); - Other autoimmune encephalitis antibodies; - LP, MRI, EEG; - Tumor workup (pelvic in women); (7) Recovery: prolonged (months-years); ~ 75% substantial recovery with treatment; (8) Multidisciplinary: neurology, psychiatry, ICU, gynecology, oncology; (9) Education: psychiatric sx can be initial presentation of organic disease

---

Anti-NMDA Receptor Encephalitis: autoimmune; young women, often paraneoplastic (ovarian teratoma). Tumor removal + immunotherapy (steroid + IVIG/plasmapheresis). Second-line rituximab. Neuroleptic sensitivity. Workup young psychosis with neuro features. 75% recover.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 22 ปี — subacute onset (3 wk) ของ psychiatric symptoms (psychosis, agitation, mood changes, catatonia) + neurological symptoms (seizures, dyskinesias, autonomic instability — BP fluctuations, hyperthermia, dysautonomia) + cognitive decline; admitted with diagnosis of ''first episode psychosis''

MRI brain: mild abnormalities or normal
LP: mild lymphocytic pleocytosis; CSF anti-NMDA receptor antibodies POSITIVE
Pelvic US: ovarian teratoma identified';

update public.mcq_questions
set choices = '[{"label":"A","text":"No psychiatric treatment"},{"label":"B","text":"Huntington''s Disease — Early Psychiatric + Motor Presentation (autosomal dominant CAG repeat HTT gene; psychiatric sx often precede motor; high suicide rate)"},{"label":"C","text":"Discharge no follow-up"},{"label":"D","text":"Surgery"},{"label":"E","text":"Punishment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Huntington''s Disease — Early Psychiatric + Motor Presentation (autosomal dominant CAG repeat HTT gene; psychiatric sx often precede motor; high suicide rate): (1) **Comprehensive multidisciplinary care**: - **Neurology** (HD specialist); - **Psychiatry** (psychiatric sx mainstay of QoL impact); - Primary care, social work, OT/PT/SLP, genetic counseling, palliative; (2) **Psychiatric management**: - **Depression**: SSRI (sertraline, escitalopram); - **Anxiety**: SSRI; - **Irritability + aggression**: SSRI, mood stabilizer (valproate), atypical antipsychotic (risperidone, olanzapine — also helps chorea); - **Psychosis**: atypical antipsychotic (also chorea benefit); - **OCD**: SSRI (high dose); - **Sleep**: trazodone, melatonin; - **Suicide risk EXTREMELY HIGH** (× 5-10 general — particularly at diagnosis + early disease + just before disability) — assess frequently + safety planning + means restriction + family education + protective hospitalization if needed; (3) **Chorea**: tetrabenazine + deutetrabenazine + valbenazine (VMAT2 — FDA approved); also benefit some psychiatric sx; SE: depression, sedation, parkinsonism; (4) **Cognitive decline**: no specific treatment; supportive; (5) **Genetic counseling**: family planning (50% offspring risk autosomal dominant); pre-symptomatic testing protocols; (6) **Family support**: HDSA resources; sibling at risk; (7) **Advance planning**: while capacity preserved — POA, advance directives, financial; (8) **Palliative care** integration; (9) **Long-term**: progressive 15-20 yr; supportive care + symptom-focused; (10) **Address comorbid alcohol use**, common; (11) Patient + family education

---

Huntington''s Disease: AD CAG repeat HTT; psychiatric sx precede motor often. Multidisciplinary. SSRI for depression/anxiety, atypical antipsychotic for psychosis/aggression + chorea, tetrabenazine for chorea. SUICIDE RISK × 5-10. Genetic counseling. Advance planning.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 42 ปี — father had Huntington''s disease (died age 55); patient genetic test confirmed HD (CAG 45) — มาด้วย early psychiatric symptoms (depression, irritability, impulsivity, executive dysfunction) + early motor (subtle chorea) + cognitive complaints; family history of suicide (father attempted)

No current SI
MMSE 27 (early)';

update public.mcq_questions
set choices = '[{"label":"A","text":"SSRI for depression dose long course"},{"label":"B","text":"Pseudobulbar Affect (PBA — involuntary emotional expression disorder; underlying neurologic injury — stroke, MS, ALS, TBI, dementia, PD)"},{"label":"C","text":"No treatment"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pseudobulbar Affect (PBA — involuntary emotional expression disorder; underlying neurologic injury — stroke, MS, ALS, TBI, dementia, PD): (1) **Dextromethorphan + quinidine (Nuedexta)** — FDA approved 2010 for PBA; quinidine inhibits CYP2D6 → increases dextromethorphan levels; reduces episodes 50%; monitor QT; (2) **SSRI/SNRI alternative** — sertraline, citalopram, fluoxetine; venlafaxine; lower doses than depression often effective; works rapidly (days-weeks unlike depression); (3) **TCA** (nortriptyline, amitriptyline) historical alternative; (4) Patient + family education: distinguishing PBA from depression — important for treatment + reducing stigma + social embarrassment; (5) Distinguish from: - Depression (persistent mood vs episodic outbursts); - Mania; - Anxiety; - Personality change; - Delirium; (6) Address underlying neurologic condition (stroke prevention, MS management, etc.); (7) Counseling for social impact + relationship effects; (8) Workplace/social accommodations if functional impact; (9) Multidisciplinary: neurology, psychiatry, primary care, speech-language (associated dysarthria), social work; (10) Long-term: chronic if underlying condition persists; treatment continues; spontaneous improvement variable

---

Pseudobulbar Affect (PBA): involuntary episodic emotional expression disproportionate to mood, neurologic injury. Dextromethorphan + quinidine (Nuedexta) FDA approved. SSRI/SNRI alternative — rapid effect lower dose. Distinguish from depression (persistent vs episodic). Education + family.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 60 ปี post-stroke (left hemisphere) 8 เดือนก่อน — sudden episodes of laughing or crying disproportionate to mood, triggered by minimal stimuli, distressing socially, not voluntary, mood between episodes essentially normal (not persistent depression)

MRI: old left MCA infarct
Not meeting MDD criteria
Distinguish from depression (mood persistent vs episodic emotional outburst)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Accept patient refusal without assessment"},{"label":"B","text":"Decision-Making Capacity Assessment (capacity = specific decision, not global; can lack capacity for some decisions + retain for others; capacity may fluctuate)"},{"label":"C","text":"Override patient against family"},{"label":"D","text":"Surgery"},{"label":"E","text":"Discharge"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Decision-Making Capacity Assessment (capacity = specific decision, not global; can lack capacity for some decisions + retain for others; capacity may fluctuate): (1) **Four standards** (Appelbaum + Grisso): - **Understanding** — comprehends information about condition + treatment (this patient impaired); - **Appreciation** — recognizes how applies to own situation; - **Reasoning** — weighs risks + benefits + alternatives (impaired here); - **Express a choice** — communicates a stable preference; (2) **Capacity is decision-specific + situation-specific**: this patient may lack capacity to refuse life-saving treatment now but may have capacity for simpler decisions; (3) **Address modifiable factors**: - Treat delirium (sepsis here — patient delirious from medical illness); - Pain management; - Hearing/vision aids; - Family presence; - Simplify language; - Cultural + linguistic adaptation; - Reassess after these; (4) **Surrogate decision-making** if persistently lacks capacity: - **Advance directive** (if exists); - **Healthcare proxy / POA** if designated; - **Substituted judgment** — what would patient choose if able? (preferred standard if known); - **Best interest** standard if unknown; - Family hierarchy varies by jurisdiction; - Ethics consultation if conflict; (5) **Beneficence + autonomy balance**: respect patient values + best interest; (6) **Document carefully**: capacity assessment process, conclusions, surrogate decision-maker; (7) **Multidisciplinary**: psychiatry consultation typical, ethics, palliative care if appropriate; (8) **Court involvement** rare — for guardianship if family conflict, no surrogate, contested

---

Capacity Assessment: decision-specific + situation-specific. Four standards (understanding, appreciation, reasoning, express choice). Address modifiable (delirium, pain, sensory). Surrogate if lacks capacity (advance directive > POA > substituted judgment > best interest). Document. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 70 ปี dementia (MMSE 20) admitted for sepsis from pneumonia — family wants ฟ ER tube + ICU; ผู้ป่วยปฏิเสธ medical care, says ''leave me alone, I want to go home''; medical team questioning capacity to refuse treatment

MSE: oriented x1 (person), some confusion, can verbalize basic wishes but cannot recall information about treatment, cannot weigh risks/benefits';

update public.mcq_questions
set choices = '[{"label":"A","text":"Diagnose dementia + start anti-amyloid without workup"},{"label":"B","text":"Workup for reversible/treatable causes"},{"label":"C","text":"No intervention"},{"label":"D","text":"Surgery"},{"label":"E","text":"Discharge without follow-up"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mild Cognitive Impairment (Mild Neurocognitive Disorder — DSM-5: modest cognitive decline + preserved functional independence + not delirium or other psychiatric — distinct from dementia which has functional impairment): (1) **Workup for reversible/treatable causes**: - **Medical**: TSH, B12, folate, vitamin D, syphilis/HIV if risk, metabolic, depression screen, medication review (anticholinergic burden!); - **Imaging**: MRI brain; - **Biomarkers** if appropriate: amyloid PET, CSF tau/Aβ, blood-based emerging — important for AD vs other; - Genetic testing (APOE) — controversial, mostly research; (2) **Treat reversible**: depression, thyroid, B12, sleep apnea, medications; (3) **Disease-specific treatment if AD biomarker positive**: - **Anti-amyloid mAb** (lecanemab, donanemab — FDA approved early AD with amyloid; slow progression modestly + ARIA risk — careful patient selection); - Cholinesterase inhibitors NOT generally recommended in MCI (not approved, not effective at MCI stage); (4) **Non-pharmacologic**: - **Exercise** (aerobic) — best evidence for cognition; - **Cognitive engagement** + stimulation; - **Mediterranean/MIND diet**; - **Social engagement**; - **Sleep optimization**; - **Manage cardiovascular risk factors** (BP, lipids, glucose, smoking); - **Hearing aids if hearing loss** (modifiable risk per Lancet Commission); - **Limit alcohol**; (5) **Follow longitudinally** — ~ 10-15%/yr progress to dementia; some remain stable or revert; (6) **Advance planning** while capacity preserved: POA, advance directive, financial planning, driving assessment plan; (7) **Family education**; (8) **Multidisciplinary**: primary care, neurology, geriatrics; (9) **Avoid medications worsening cognition**: anticholinergics (TCA, oxybutynin, diphenhydramine, benztropine), benzodiazepines, opioids high-dose

---

Mild Cognitive Impairment: cognitive decline + preserved function. Workup reversible. Biomarkers for AD vs other. Anti-amyloid mAb selected early AD with amyloid+. NO cholinesterase at MCI. Lifestyle (exercise, diet, sleep, social, CV risk). Follow longitudinally. Avoid anticholinergics.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 70 ปี — subjective + objective cognitive complaints × 1 ปี — mild memory difficulties, minor word-finding, no functional impairment in ADL/IADL (still drives, manages finances, takes medications correctly); seeking opinion + intervention

MMSE 27 (mild)
MoCA 24 (mild impairment)
Neuropsychological testing: mild memory below age expected, other domains intact
MRI: mild bilateral hippocampal atrophy, no stroke';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue antidepressant alone — ignore OSA"},{"label":"B","text":"Treatment-Resistant Depression with Underlying Severe Obstructive Sleep Apnea — Address Comorbidity (OSA contributes to depression, treatment resistance, cognition, CV risk)"},{"label":"C","text":"Benzodiazepine for sleep"},{"label":"D","text":"Surgery (UPPP) first-line"},{"label":"E","text":"No treatment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Treatment-Resistant Depression with Underlying Severe Obstructive Sleep Apnea — Address Comorbidity (OSA contributes to depression, treatment resistance, cognition, CV risk): (1) **CPAP therapy** — first-line for severe OSA; titrate; improves depression (effect size moderate), cognition, daytime function, BP, CV outcomes; (2) **Address sleep apnea before/during depression treatment** — TRD may resolve or respond better to antidepressant with OSA treated; (3) **Weight loss** — multimodal (diet, exercise, behavioral) — modest OSA improvement; bariatric surgery for severe obesity; GLP-1 agonists (semaglutide) — emerging evidence improves OSA + weight; (4) **Alternative OSA treatments if CPAP-intolerant**: - Oral appliance (mild-moderate); - Hypoglossal nerve stimulation (Inspire); - Positional therapy (positional OSA); - Surgical (uvulopalatopharyngoplasty — limited efficacy; maxillomandibular advancement effective); (5) **Avoid CNS depressants**: benzodiazepines, opioids, alcohol — worsen OSA + respiratory drive; (6) **Continue antidepressant** — once OSA treated may respond better; consider activating antidepressant (bupropion); (7) **Address comorbid**: HTN, T2DM, CV — high overlap; (8) **Screen all TRD + chronic fatigue patients for OSA** — common + reversible contributor; (9) **Multidisciplinary**: sleep medicine, psychiatry, primary care, ENT/oral surgery if surgical option; (10) Lifestyle: sleep hygiene, exercise, weight

---

OSA + TRD: address OSA — CPAP first-line. Improves depression + cognition + CV. Weight loss adjunct. Alternatives (oral appliance, Inspire). AVOID CNS depressants. Screen TRD/chronic fatigue for OSA. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 50 ปี TRD × 2 ปี — fatigue prominent, daytime sleepiness, morning headache, partner reports loud snoring + observed apneas; BMI 32, neck circumference 17 inch, HTN; depression failed 3 antidepressants

Epworth Sleepiness Scale 18 (severe)
STOP-BANG: 6 (high risk OSA)
Polysomnography: severe OSA, AHI 45';

update public.mcq_questions
set choices = '[{"label":"A","text":"No treatment — naps only"},{"label":"B","text":"Narcolepsy Type 1 (with cataplexy; hypocretin/orexin deficiency — autoimmune destruction of hypothalamic orexin neurons)"},{"label":"C","text":"Long-term benzodiazepine"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Narcolepsy Type 1 (with cataplexy; hypocretin/orexin deficiency — autoimmune destruction of hypothalamic orexin neurons): (1) **Stimulants for daytime sleepiness**: - **Modafinil/armodafinil** — first-line; less abuse potential than amphetamine; - **Stimulants** (methylphenidate, amphetamine — Vyvanse, Adderall) — effective, controlled substance; - **Solriamfetol** — newer DAT/NET inhibitor; - **Pitolisant** — histamine H3 inverse agonist (also helps cataplexy); (2) **Cataplexy treatment**: - **Sodium oxybate (Xyrem) / oxybate** — GHB derivative; FDA approved for cataplexy + EDS; nocturnal dosing; controlled substance, abuse potential; expensive; - **SNRI** (venlafaxine, atomoxetine), **SSRI** (fluoxetine) — REM-suppressing, reduce cataplexy + sleep paralysis + hallucinations; - **TCA** alternative; - **Pitolisant** also; (3) **Scheduled naps** (15-20 min, 1-2×/d) — non-pharmacologic adjunct; (4) **Sleep hygiene** + adequate night sleep; (5) **Driving safety counseling** — sleep attacks + cataplexy risk; legal implications; (6) **Address comorbidity**: depression (common — chronic illness + neurobiology), obesity (high — orexin role in metabolism), CV risk; (7) **Education + support**: Narcolepsy Network; school/workplace accommodations (504/ADA); (8) **Distinguish**: idiopathic hypersomnia, OSA, REM sleep disorders, insufficient sleep, mood disorders; (9) **Multidisciplinary**: sleep medicine, psychiatry, primary care; (10) **Long-term**: chronic; treatment improves QoL substantially; (11) **Pregnancy planning** — medication adjustments needed

---

Narcolepsy Type 1: cataplexy + EDS + hypocretin deficiency. Stimulants/modafinil/pitolisant/solriamfetol for EDS. Oxybate or SNRI/SSRI/TCA for cataplexy. Scheduled naps. Driving safety. Multidisciplinary. Chronic.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 25 ปี × 3 ปี — excessive daytime sleepiness despite adequate night sleep, sudden sleep attacks, episodes of bilateral muscle weakness triggered by laughter/strong emotion (cataplexy — knees buckle, jaw drops, falls), occasional sleep paralysis on waking + hypnagogic hallucinations

Epworth Sleepiness Scale 18
PSG + MSLT: sleep onset REM periods × 3, mean sleep latency 6 min (< 8) — diagnostic
CSF hypocretin-1 low — confirms type 1';

update public.mcq_questions
set choices = '[{"label":"A","text":"No treatment — let dream out"},{"label":"B","text":"REM Sleep Behavior Disorder (RBD — DSM-5; loss of REM atonia → dream enactment; major prodrome of synucleinopathy — Parkinson''s, DLB, MSA)"},{"label":"C","text":"Long-term high-dose benzodiazepine ignoring elderly risk"},{"label":"D","text":"Surgery"},{"label":"E","text":"Discharge"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** REM Sleep Behavior Disorder (RBD — DSM-5; loss of REM atonia → dream enactment; major prodrome of synucleinopathy — Parkinson''s, DLB, MSA): (1) **Safety measures essential** — partner injury risk + falls + injuries: - **Bedroom safety** — soft objects around bed, padded floor, mattress on floor, remove sharp objects + weapons from room; - **Separate beds/rooms** if injuries; - Bed rails (carefully — can cause more injury); (2) **Medication**: - **Melatonin 3-12 mg HS** — first-line in many guidelines now; safer profile; effective; - **Clonazepam 0.25-2 mg HS** — historically first-line; effective; risks elderly (falls, sedation, cognition); - **Other**: pramipexole limited; rivastigmine (especially with synucleinopathy); (3) **Discontinue contributors**: SSRI, SNRI, MAOI, beta-blockers (worsen RBD); discuss risk-benefit if psychiatric indication strong; (4) **Disclose synucleinopathy risk** — RBD precedes Parkinson''s/DLB/MSA in ≥ 80% of idiopathic RBD over 10-15 yr; sensitive conversation + counseling + lifestyle modifications + monitoring; (5) **Monitor for parkinsonism + cognitive decline** — annual neurologic + cognitive exam; (6) **Address comorbidity**: anxiety/depression, OSA (frequent), sleep hygiene; (7) **Distinguish**: NREM parasomnia (sleepwalking — first half of night, no dream recall), nocturnal seizure, sleep terror, psychogenic; PSG diagnostic; (8) **Multidisciplinary**: sleep medicine, neurology, psychiatry; (9) **Patient + family education**; (10) **Long-term**: chronic; management of behaviors + monitoring for evolving neurodegenerative disease

---

REM Sleep Behavior Disorder: dream enactment, loss of REM atonia, PSG diagnostic. Safety measures essential. Melatonin (now often first-line) or clonazepam. Discontinue SSRI/SNRI contributors. Major synucleinopathy prodrome (Parkinson''s, DLB, MSA — 80% in 10-15 yr). Monitor.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 65 ปี × 2 ปี — bed partner reports patient acting out dreams during sleep (punching, kicking, yelling, falling out of bed) — injuries to self + partner; complex motor behaviors during REM

PSG: REM sleep without atonia + dream enactment behaviors — diagnostic
No recent medication changes
Family noting subtle motor slowing recently
DAT scan abnormal';

update public.mcq_questions
set choices = '[{"label":"A","text":"Wait — depression normal"},{"label":"B","text":"Antidepressant choice considering"},{"label":"C","text":"Avoid antidepressant in cancer"},{"label":"D","text":"Surgery"},{"label":"E","text":"No psychiatric input"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Major Depressive Disorder in Cancer Patient (C-L psychiatry — common, undertreated, affects outcomes): (1) Distinguish from: - Adjustment disorder; - Demoralization; - Cancer-related fatigue (no anhedonia, no hopelessness); - Chemotherapy side effects; - Hypothyroidism (chemo-induced); - Anemia; - Hypercalcemia; - CNS metastases; - Steroid-induced mood disorder; (2) Treat aggressively — depression worsens outcomes, adherence, QoL: (3) **Antidepressant choice considering**: - **Sertraline, escitalopram, mirtazapine** (mirtazapine — appetite + sleep + nausea bonus); - **Avoid drug interactions**: fluoxetine + paroxetine + bupropion = CYP2D6 inhibitors → may reduce tamoxifen → endoxifen conversion (avoid in tamoxifen patients); - **QT prolongation considerations** with chemo (avoid high-dose citalopram); - **Bupropion** — activating, no weight gain, no sexual SE; lower seizure threshold consideration; (4) Psychotherapy: CBT, mindfulness-based, supportive, meaning-centered (Breitbart — specifically advanced cancer); (5) Behavioral: exercise even mild (evidence base); (6) Address symptoms: pain (treat aggressively — methadone overlaps), insomnia, fatigue (psychostimulants methylphenidate adjunct for fatigue + depression in palliative settings); (7) Suicide assessment + safety; cancer + depression increases suicide risk; (8) Family + caregiver support; (9) Multidisciplinary: psycho-oncology, oncology, primary care, palliative care, social work, chaplaincy; (10) Long-term — adjust treatment through cancer journey + survivorship

---

Depression in cancer: undertreated, worsens outcomes. Distinguish from adjustment, demoralization, fatigue, medical causes. Sertraline, mirtazapine common. AVOID fluoxetine/paroxetine/bupropion in tamoxifen patients (CYP2D6 inhibitors reduce endoxifen). Psychotherapy + exercise. Methylphenidate for palliative fatigue. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 55 ปี newly diagnosed breast cancer stage III on chemo — มาด้วย depressed mood, anhedonia, fatigue, sleep disturbance, weight loss, hopelessness, suicidal ideation × 6 wk

PHQ-9: 18
No prior psychiatric hx
Family supportive
Distinguishing depression from cancer/chemo fatigue: anhedonia + hopelessness + guilt distinguish depression';

update public.mcq_questions
set choices = '[{"label":"A","text":"TCA for depression + nighttime sedation"},{"label":"B","text":"Post-MI Depression (depression × 2-3 increased risk after MI; increases mortality 2-3 fold; affects adherence, rehab participation, CV outcomes)"},{"label":"C","text":"No antidepressant"},{"label":"D","text":"Surgery"},{"label":"E","text":"Punishment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-MI Depression (depression × 2-3 increased risk after MI; increases mortality 2-3 fold; affects adherence, rehab participation, CV outcomes): (1) **Treat depression aggressively** — improves CV outcomes + adherence + cardiac rehab participation; (2) **Antidepressant choice — cardiac safety**: - **Sertraline** = first-line (SADHART trial — safe + effective post-MI); - **Escitalopram, citalopram** (citalopram avoid > 20mg elderly QT); - **AVOID**: TCA (anticholinergic, cardiac, conduction — historical concern; not recommended post-MI); high-dose citalopram (QT); MAOI; (3) **CBT** for cardiac patients — first-line; addresses fear, avoidance, deconditioning; CBT specifically adapted for cardiac patients (ENRICHD trial); (4) **Cardiac rehabilitation** — physical + psychological benefit; exercise = antidepressant + cardiac benefit; address fear of activity; (5) **Address fear/anxiety** — common post-MI; PTSD-like sx in some patients; (6) **Couples/family** — adjustment for both patient + family; sexual concerns (medication, fear of activity); (7) **Lifestyle**: smoking cessation aggressively, diet, exercise, weight; (8) **Monitor for medication interactions**: SSRI + antiplatelet bleeding risk modest; SSRI + diuretic hyponatremia; (9) **Sleep apnea screening** common post-MI; (10) **Multidisciplinary**: cardiology, psychiatry, cardiac rehab, primary care, psychology, dietitian, smoking cessation; (11) **Education**: depression is medical illness, treatable, improves CV; (12) **Suicide assessment** — depression + chronic illness elevated

---

Post-MI Depression: depression × 2-3 risk after MI; ↑ mortality. SADHART trial — sertraline safe + effective. AVOID TCA + high-dose citalopram. CBT (ENRICHD) for cardiac patients. Cardiac rehab + exercise = antidepressant + cardiac benefit. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 60 ปี post-STEMI 2 เดือนก่อน + PCI; ขณะนี้ developed MDD — sad, anhedonic, sleep disturbance, decreased exercise tolerance (deconditioning + avoidance), fearful of activity (fear another MI), PHQ-9: 16

Medications: aspirin, clopidogrel, statin, BB, ACE-I
EF 45%, cardiac rehab attendance poor due to depression';

update public.mcq_questions
set choices = '[{"label":"A","text":"Ignore HIV — treat psych only"},{"label":"B","text":"HIV + Depression + Substance Use + Cognitive Concerns — Comprehensive Care"},{"label":"C","text":"St John''s wort"},{"label":"D","text":"Surgery"},{"label":"E","text":"Discharge"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** HIV + Depression + Substance Use + Cognitive Concerns — Comprehensive Care: (1) **Antidepressant choice** — drug interactions critical: - **Sertraline, escitalopram, mirtazapine** generally safe with most ART; - **Drug interactions**: protease inhibitors (ritonavir) + most antidepressants; efavirenz can interact; check Liverpool HIV interactions checker; - **AVOID**: St John''s wort (induces P450, reduces ART efficacy); methylphenidate caution with stimulant use disorder; (2) **CBT, IPT** psychotherapy; (3) **Address substance use** — integrated treatment; stimulant use disorder (no FDA medication; contingency management); HIV transmission + adherence issues; (4) **Cognitive assessment** — HIV-Associated Neurocognitive Disorder (HAND) spectrum: asymptomatic, mild neurocognitive, HIV-associated dementia (severe rare in modern ART era); workup other causes (syphilis, B12, depression — pseudodementia); neuropsych testing; CNS penetration of ART; (5) **Address comorbidities**: HCV (treat regardless of ART), STIs, mental health screening; cardiovascular, metabolic (some ART), bone density; (6) **Psychosocial**: peer support (HIV+ community), housing, employment, legal, identity-affirming (LGBTQ+ if applicable), stigma reduction, social work; (7) **Adherence support** — depression worsens, treatment improves; pill organizers, reminders, simplification regimen; (8) **Suicide assessment** — HIV+ elevated risk; (9) **Multidisciplinary**: infectious disease, psychiatry, addiction medicine, primary care, social work, peer support; (10) **PrEP discussion for partners**

---

HIV Psychiatric: SSRI choice (sertraline, escitalopram) — check ART interactions. CBT/IPT. Address stimulant use (no FDA med; contingency mgmt). HAND assessment. Comorbidities. Peer support + adherence. Suicide risk. Multidisciplinary.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 35 ปี HIV+ on ART × 3 ปี (viral suppression) — มาด้วย new-onset depression, mild cognitive concerns, insomnia, sexual identity stress, substance use history (methamphetamine), social stigma; CD4 count 380, undetectable viral load

PHQ-9: 16
No psychotic features';

update public.mcq_questions
set choices = '[{"label":"A","text":"Auto-decline AUD patient"},{"label":"B","text":"Transplant Psychiatry Evaluation — Multidimensional Assessment"},{"label":"C","text":"Ignore substance use history"},{"label":"D","text":"Surgery without evaluation"},{"label":"E","text":"No assessment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Transplant Psychiatry Evaluation — Multidimensional Assessment: (1) **Psychosocial evaluation domains**: - **Mental health**: current + past psychiatric, treatment, stability; - **Substance use**: type, duration, severity, recovery, current sobriety, support — most centers require 6-12 mo sobriety for liver/kidney; assess relapse risk; - **Adherence history**: medication, appointments, dietary restrictions; - **Cognitive capacity**: understand transplant process + lifelong adherence requirements; - **Social support**: caregiver(s), housing, finances; - **Coping**: stress management, prior medical adjustment; - **Health behaviors**: smoking, diet, exercise; (2) **Standardized tools**: SIPAT (Stanford Integrated Psychosocial Assessment for Transplantation) — validated; PACT; TERS; (3) **AUD-specific**: - Duration of sobriety (some centers shortened from 6 mo with case-by-case); - Active relapse prevention plan (AA, therapy, MAT — naltrexone post-transplant possible); - PEth blood marker (alcohol biomarker); - Family/caregiver assessment; (4) **Recommendations to transplant team** — list, conditional, defer, decline; (5) **Pre-transplant interventions**: optimize mental health treatment, addiction treatment, social work support; (6) **Post-transplant follow-up**: high adherence stakes (rejection); ongoing psychiatry; depression common post-transplant; (7) **Immunosuppression psychiatric effects**: tacrolimus, steroids — neuropsychiatric SE; (8) **Multidisciplinary transplant committee** — psychiatry recommendation one input; (9) **Equity considerations** — avoid bias; SES, race, addiction stigma; (10) **Education + informed consent**

---

Transplant Psychiatry: multidimensional psychosocial eval (SIPAT). AUD requires sobriety + relapse prevention + support. Adherence capacity. Recommendations to team. Pre-transplant optimization + post-transplant follow-up. Equity considerations.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 50 ปี AUD-related ESLD seeking liver transplant evaluation; sober × 9 เดือน + AA attendance + family support — psychiatry consultation for transplant evaluation

PHQ-9: 8 (mild); GAD-7: 6
Cognitive assessment normal
No other substance use; smoking cessation 1 yr ago';

update public.mcq_questions
set choices = '[{"label":"A","text":"Diagnosis of exclusion alone"},{"label":"B","text":"Diagnosis based on POSITIVE clinical signs"},{"label":"C","text":"Dismissive: ''all in your head''"},{"label":"D","text":"Surgery"},{"label":"E","text":"No treatment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Functional Neurological Symptom Disorder (FND — DSM-5; replaced ''conversion disorder''; positive clinical signs of inconsistency now central — internal inconsistency or incompatibility with neurological disease): (1) **Diagnosis based on POSITIVE clinical signs**: - Hoover''s sign (motor); - Tremor entrainment test; - Hip abductor sign; - Tubular vision; - Drift without pronation; - Inconsistency, distractibility; - NOT diagnosis of exclusion alone — neurologic mimics ruled out + positive signs present; (2) **Communication of diagnosis essential** — confidently explain: ''real condition, not faking, brain function (not structure) problem, treatable''; analogy ''software vs hardware''; show positive signs; avoid dismissive language (''nothing wrong''); (3) **Treatment**: - **Physical therapy** specifically adapted for FND (graded exposure + retraining + motor learning + distraction techniques) — first-line for motor sx; - **CBT** for FND — first-line; understanding symptoms + coping; - **OT, speech therapy** depending on sx; - **Address triggers + stressors**; - **Trauma-focused** if PTSD comorbid (often); (4) **Address comorbid psychiatric**: depression, anxiety, PTSD common — treat; (5) **Avoid iatrogenic harm**: unnecessary testing, immobilization, opioids; (6) **Multidisciplinary**: neurology, psychiatry, PT/OT, speech, primary care; (7) **Long-term**: outcomes vary — early intervention + acceptance of diagnosis improve; chronic in many; (8) **Distinguish from**: - Factitious disorder (intentional sx production for sick role); - Malingering (intentional for external gain); - Both involve intent vs FND which is involuntary; (9) **Modern**: FND is neuropsychiatric disorder, not ''psychogenic''; brain network dysfunction; reduce stigma + dualism

---

Functional Neurological Disorder (DSM-5): positive clinical signs (Hoover''s, tremor entrainment, inconsistency) — NOT exclusion alone. Communication of dx essential. PT for FND + CBT first-line. Address comorbidity. Modern: neuropsychiatric not ''psychogenic''.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 28 ปี acute onset (2 wk) ของ unilateral leg weakness (cannot walk) — no medical explanation; Hoover''s sign positive (contralateral hip extension elicits weakness on testing affected leg), give-way weakness, normal reflexes, no atrophy; recently major life stress (job loss, breakup) and history of childhood trauma

MRI, EMG, NCS: normal
No malingering evident (not consciously feigning)';

commit;
