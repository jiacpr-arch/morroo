-- ===============================================================
-- UPDATE chunk 3/8: psychiatry (25 questions)
-- ===============================================================

begin;

update public.mcq_questions
set choices = '[{"label":"A","text":"Long-term SSRI"},{"label":"B","text":"Adjustment Disorder (DSM-5"},{"label":"C","text":"Hospitalization"},{"label":"D","text":"Surgery"},{"label":"E","text":"No treatment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Adjustment Disorder (DSM-5: emotional/behavioral sx in response to identifiable stressor within 3 mo + clinically significant + does not meet other disorder criteria + does not persist > 6 mo after stressor + consequences resolved): (1) Psychotherapy first-line — supportive therapy, brief CBT, problem-solving therapy; address stressor + coping; (2) Medication usually NOT first-line — limited evidence; short-term SSRI/anxiolytic if severe symptoms or comorbidity; (3) Practical support — employment counseling, financial counseling, social work referral; (4) Identify + leverage social support (family, peers, community); (5) Stress management + lifestyle (exercise, sleep, mindfulness); (6) Distinguish from: MDD (criteria not met), bereavement (different category), normal stress response, PTSD (trauma criterion); (7) Time-limited by definition (≤ 6 mo after stressor resolution); chronic if stressor persists; (8) Suicide risk — adjustment disorder elevated (especially adolescents) — assess; (9) Subtypes: with depressed mood, with anxiety, mixed, with conduct disturbance, with mixed disturbance

---

Adjustment Disorder: sx in response to identifiable stressor < 3 mo + does not meet other disorder + does not persist > 6 mo after stressor resolves. Psychotherapy first-line (supportive, brief CBT). Practical support. Limited medication role. Suicide risk assessment.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 35 ปี งานถูก layoff 1 เดือนที่แล้ว — ตั้งแต่นั้น mood ตก, นอนไม่หลับ, กังวล, irritable, withdrawal จาก social — but ไม่ครบเกณฑ์ MDD (no anhedonia, no SI, no significant weight change), no panic

PHQ-9: 11 (moderate sx but not full MDD criteria)
Functional impairment present (job search difficulty)
No prior psychiatric history';

update public.mcq_questions
set choices = '[{"label":"A","text":"Forced ''debriefing'' early"},{"label":"B","text":"Acute Stress Disorder (DSM-5"},{"label":"C","text":"Long-term benzodiazepine"},{"label":"D","text":"Surgery"},{"label":"E","text":"No follow-up"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Stress Disorder (DSM-5: trauma exposure + ≥ 9 sx จาก 5 categories ใน intrusion/negative mood/dissociation/avoidance/arousal; 3 days - 1 mo): (1) Trauma-focused CBT first-line — brief course (5-12 sessions); reduces PTSD development; (2) Psychological First Aid — early; assess + safety + connect to resources + practical help — avoid forced disclosure (e.g., ''debriefing'' shown ineffective + may harm); (3) Sleep + nightmare management — prazosin for nightmares if severe; sleep hygiene; (4) Avoid benzodiazepines (may increase PTSD risk); (5) SSRI not routinely indicated acute — if persistent comorbid sx; (6) Address comorbidity: depression, substance use; (7) Bereavement support (driver died) + grief; (8) Practical support: legal, insurance, family; (9) Distinguish from PTSD (≥ 1 mo): ASD predicts PTSD but not all develop PTSD; many recover spontaneously; (10) Follow-up: assess at 1 mo for PTSD; (11) Multidisciplinary: psychiatry/psychology, primary care, social work, peer support

---

Acute Stress Disorder: trauma + sx 3 days - 1 mo. Trauma-focused CBT first-line (brief). Psychological First Aid. AVOID forced debriefing + benzodiazepine. Predicts PTSD — follow at 1 mo.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 30 ปี รอดจาก motor vehicle accident 2 สัปดาห์ที่แล้ว (passenger of car hit head-on; driver dead) — ตั้งแต่นั้น recurrent intrusive memories, nightmares, flashbacks, avoidance ของ driving, hypervigilance, sleep disturbance, dissociative sx (feeling unreal), irritability

Sx ≥ 3 วัน, < 1 month duration
MSE: anxious, intrusive sx visible
No psychotic features';

update public.mcq_questions
set choices = '[{"label":"A","text":"No treatment — natural grief"},{"label":"B","text":"Prolonged Grief Disorder (DSM-5-TR new diagnosis 2022"},{"label":"C","text":"Long-term benzodiazepine"},{"label":"D","text":"Surgery"},{"label":"E","text":"Avoid all reminders"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Prolonged Grief Disorder (DSM-5-TR new diagnosis 2022: persistent grief responses ≥ 12 mo adults / 6 mo children + ≥ 3 sx + impairment + exceed cultural norm): (1) Complicated Grief Treatment (CGT — Shear) first-line — adapted CBT specific to prolonged grief; (2) Components: education about grief, exposure to avoided cues, restoration of life goals, working through specific painful memories, building social connections; (3) Distinguish from MDD (overlap but distinct — bereavement-specific yearning + preoccupation with deceased); (4) Antidepressant if comorbid MDD — does NOT specifically treat grief but helps depression; (5) Group therapy + bereavement support groups + peer support; (6) Cultural + religious considerations — grief expression varies; (7) Suicide risk elevated (especially first year + complicated grief); (8) Address comorbidity: depression, PTSD (if traumatic loss), substance use, anxiety; (9) Distinguish: normal grief (recovery without specific treatment in most), bereavement (now included in MDD criteria DSM-5 — no longer excludes), complicated grief = pathological extension

---

Prolonged Grief Disorder (DSM-5-TR 2022): grief ≥ 12 mo + functional impairment. Complicated Grief Treatment (Shear) first-line. Distinguish from normal grief, MDD. Suicide risk elevated. Cultural considerations.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 55 ปี สามีเสียชีวิต 16 เดือนที่แล้ว — ปกติ grief process แต่ตั้งแต่ 8 เดือนที่ผ่านมา persistent intense yearning, preoccupation with deceased, inability to accept death, avoidance of reminders, feelings of meaninglessness, withdrawal from social activities — sx persist + interfere with functioning

Not meeting MDD criteria fully
No psychotic features';

update public.mcq_questions
set choices = '[{"label":"A","text":"Cosmetic surgery"},{"label":"B","text":"Body Dysmorphic Disorder (DSM-5 OC-spectrum"},{"label":"C","text":"Reassurance only"},{"label":"D","text":"No treatment"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Body Dysmorphic Disorder (DSM-5 OC-spectrum: preoccupation with perceived flaw not observable to others + repetitive behaviors + > 1h/d + distress/impairment): (1) CBT with ERP (Exposure + Response Prevention) first-line — exposure to feared situations + prevent compulsions (mirror checking, reassurance seeking, comparison); cognitive restructuring about appearance beliefs; (2) SSRI first-line medication — HIGHER doses + longer duration (like OCD): fluoxetine 60-80mg, sertraline 200mg, escitalopram 30mg; clomipramine alternative; (3) Combination CBT + SSRI for severe; (4) AVOID cosmetic surgery — rarely satisfied, often worsens; new focus elsewhere; surgical request = red flag; (5) Address comorbidity high: depression (75%), social anxiety, OCD, substance use; (6) Suicide risk very high (~ 25% lifetime attempt); (7) Education about disorder + that subjective perception ≠ reality; (8) Family education + support; (9) Long-term: chronic + waxing/waning; maintenance treatment often needed; (10) Variants: muscle dysmorphia (preoccupation with insufficient muscularity)

---

BDD: preoccupation with perceived flaw + repetitive behaviors. CBT with ERP + SSRI (higher doses, like OCD). AVOID cosmetic surgery (rarely satisfied, worsens). Suicide risk very high (25% lifetime). Comorbid depression common.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 22 ปี × 4 ปี — preoccupied กับ perceived defect ของ nose (มองไม่เห็นโดย others; รูปจริงปกติ) — กระจกหลายชั่วโมง/วัน, มี multiple consultations กับ plastic surgeon, refused surgery มาแล้ว 3 ครั้ง, social withdrawal, ขาดเรียน

No other psychiatric, recognizes preoccupation excessive sometimes but not always
No psychotic features (delusional intensity in 30% but not now)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Forced cleanout"},{"label":"B","text":"Hoarding Disorder (DSM-5 OC-spectrum"},{"label":"C","text":"Eviction"},{"label":"D","text":"No treatment"},{"label":"E","text":"Surgery"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hoarding Disorder (DSM-5 OC-spectrum: persistent difficulty discarding + distress with discarding + accumulation + clutter compromising use + impairment): (1) Specialized CBT for hoarding (Steketee + Frost manual) first-line — motivational enhancement, cognitive restructuring, skills training (sorting, organizing, decision-making), in-home work, exposure to discarding + not acquiring; intensive + lengthy; (2) Group therapy + peer support; (3) SSRI — moderate evidence (fluoxetine, paroxetine, venlafaxine) — less robust than for OCD; some help; (4) Avoid forced clear-outs by family/officials — high relapse + traumatic + does not address underlying; (5) Comorbidity assessment: depression, anxiety, ADHD (very common — executive function), OCD, autism; (6) Safety + harm reduction — fire hazard, falls, sanitation, animal welfare (animal hoarding — separate issue), evictions; coordinate กับ public health + housing; (7) Family education + support — reduce blame; (8) Multidisciplinary: psychiatry, behavioral therapist, OT (organizing skills), case management, social work, public health; (9) Long-term: chronic; gradual progress; relapse common; (10) Late-onset + cognitive decline — rule out dementia (FTD) or stroke

---

Hoarding Disorder (DSM-5): persistent difficulty discarding + accumulation impairing living. Specialized CBT (Steketee + Frost) first-line. SSRI moderate evidence. AVOID forced clear-outs. Address ADHD + executive dysfunction comorbidity. Multidisciplinary including OT.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 62 ปี ลูกพามา — สะสมหนังสือพิมพ์ + ของเก่า + สัตว์ × 20 ปี — บ้านเต็มไปด้วยของจนใช้ห้องไม่ได้ — ห้องน้ำใช้ไม่ได้, ครัวใช้ไม่ได้, นอนบนเก้าอี้, รู้สึกหวงทุกชิ้น + distress มากเมื่อต้องทิ้ง; เมียทิ้งไปเพราะเรื่องนี้

MSE: insight partial; recognizes problem but resists discarding
Mobile but living conditions hazardous (fire risk, sanitation)
No psychosis, mild cognitive impairment MMSE 28';

update public.mcq_questions
set choices = '[{"label":"A","text":"No treatment"},{"label":"B","text":"Trichotillomania (DSM-5 OC-spectrum"},{"label":"C","text":"Surgery"},{"label":"D","text":"Antibiotic"},{"label":"E","text":"Wig only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Trichotillomania (DSM-5 OC-spectrum: recurrent hair pulling → hair loss + attempts to stop + distress/impairment): (1) Habit Reversal Training (HRT) — first-line; awareness training + competing response (e.g., clench fists when urge) + stimulus control + relaxation; effective + durable; (2) ACT (Acceptance + Commitment Therapy) + dialectical behavior therapy adaptations effective; (3) N-acetylcysteine (NAC) — 1200-2400 mg/day; modulates glutamate; modest evidence; well-tolerated; (4) SSRI — limited evidence (unlike OCD); some respond; (5) Atypical antipsychotic adjunctive in refractory; (6) Avoid: punishment, hats only (don''t address); shaving (often resumes); (7) Comorbidity: depression, anxiety, OCD; (8) Self-help resources + support groups (TLC Foundation for BFRBs); (9) Skin/scalp examination + dermatology if scarring or infection; (10) Related Body-Focused Repetitive Behaviors (BFRBs): skin picking (excoriation), nail biting; (11) Long-term: chronic + waxing/waning; (12) Multidisciplinary

---

Trichotillomania (DSM-5 OC-spectrum): hair pulling + functional impairment. HRT (Habit Reversal Training) first-line. NAC modest evidence. SSRI limited (unlike OCD). Related BFRBs (skin picking).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 19 ปี × 4 ปี — recurrent hair pulling จาก scalp + eyebrows → visible alopecia, attempts to stop unsuccessful, ทำลึก ๆ ขณะ studying/stressed, distress + embarrassment, wears scarf, social withdrawal

No skin disease, no psychotic features
MSE: alert, distressed about behavior, attempts to conceal';

update public.mcq_questions
set choices = '[{"label":"A","text":"Topical steroid only"},{"label":"B","text":"Excoriation (Skin-Picking) Disorder (DSM-5 OC-spectrum 2013 addition"},{"label":"C","text":"Restraints"},{"label":"D","text":"Surgery"},{"label":"E","text":"No treatment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Excoriation (Skin-Picking) Disorder (DSM-5 OC-spectrum 2013 addition: recurrent skin picking → skin lesions + attempts to stop + distress/impairment): (1) Habit Reversal Training (HRT) — first-line, similar to trichotillomania; awareness, competing response, stimulus control; (2) CBT — broader cognitive + behavioral; (3) ACT effective; (4) N-acetylcysteine (NAC) — modest evidence; (5) SSRI — limited evidence; some respond (escitalopram, fluoxetine); (6) Avoid topical treatment alone — doesn''t address behavior; (7) Wound care + infection treatment as needed; barriers (gloves, bandages) as stimulus control; (8) Comorbidity: depression, anxiety, OCD, BDD; (9) Distinguish from: dermatologic disease, scabies, drug-induced, delusional infestation; (10) Address self-stigma + shame — common in BFRBs; (11) Self-help + support groups (TLC Foundation); (12) Multidisciplinary: psychiatry, behavioral therapist, dermatology

---

Excoriation (Skin-Picking) Disorder: DSM-5 OC-spectrum (2013). HRT first-line. NAC modest. SSRI limited evidence. Address shame + multidisciplinary including dermatology. Related to other BFRBs.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 30 ปี recurrent skin picking × 8 ปี — picks ที่ face/arms ทำให้เกิด scarring + open wounds + infection; tries to stop หลายครั้ง; picks ขณะ stressed/bored; impairment ทาง social (embarrassment) + occupational

Dermatology workup: lesions consistent กับ self-induced; no primary dermatologic condition
No psychosis';

update public.mcq_questions
set choices = '[{"label":"A","text":"Outpatient management"},{"label":"B","text":"Postpartum Psychosis"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Watchful waiting"},{"label":"E","text":"Antibiotic only"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Postpartum Psychosis — PSYCHIATRIC EMERGENCY (rare 0.1-0.2% but devastating; high infanticide + suicide risk; often onset within 2 wk postpartum): (1) Immediate hospitalization (involuntary if needed) — separate from infant initially or supervised contact; (2) Safety: 1:1 observation, both maternal suicide + infanticide risk; specialized mother-baby unit if available; (3) Antipsychotic + mood stabilizer or BZD — quetiapine, olanzapine, risperidone; lithium effective if bipolar (most postpartum psychosis = BP spectrum); (4) ECT highly effective for postpartum psychosis — consider early, especially with food refusal, severe SI, infanticide ideation, lactation considerations (compatible); (5) Rule out organic: thyroid storm, sepsis, eclampsia/PRES, autoimmune encephalitis, infection, drug withdrawal, sleep deprivation severe; (6) Breastfeeding decisions individualized — most psychiatric medications compatible (consult LactMed); separation may be necessary acutely; (7) Long-term: 30-50% recurrence with subsequent pregnancies — prophylactic mood stabilizer postpartum next pregnancy; (8) Distinguish from postpartum blues (transient, no psychosis) + postpartum depression (no psychosis); (9) Multidisciplinary: perinatal psychiatry, OB-GYN, pediatrics, social work, family; (10) Family education + support

---

Postpartum Psychosis: EMERGENCY. Rare (0.1-0.2%) but high infanticide + suicide risk. Often BP spectrum. Hospitalize. Antipsychotic + mood stabilizer; ECT highly effective. Recurrence 30-50% — prophylaxis next pregnancy. Distinguish from blues + PPD.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 28 ปี G2P1 postpartum 10 days — ก่อนคลอด healthy, no psychiatric hx; ตอนนี้ rapid onset (3 วัน) ของ confusion, mood lability, delusions (เชื่อว่าทารกถูกสับเปลี่ยน, ได้ยินเสียงสั่งให้ทำร้ายทารก), insomnia, agitation

MSE: disoriented, command auditory hallucinations + delusions, labile affect
Vitals: stable, no fever
Workup: TSH, B12, CBC, infection workup pending
Husband present, concerned about safety of mother + baby';

update public.mcq_questions
set choices = '[{"label":"A","text":"Repeat cardiac testing each visit"},{"label":"B","text":"Panic Disorder + Health Anxiety (DSM-5"},{"label":"C","text":"Long-term benzodiazepine"},{"label":"D","text":"Surgery"},{"label":"E","text":"Avoid all activity"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Panic Disorder + Health Anxiety (DSM-5: recurrent unexpected panic attacks + ≥ 1 mo worry/behavior change; medical workup negative): (1) Education first — explain physiology of panic (fight-flight false alarm, sympathetic activation, hyperventilation, catastrophic interpretation of normal sensations) + reassurance based on negative workup; (2) CBT first-line — cognitive restructuring (catastrophic thoughts about chest pain ≠ MI), interoceptive exposure (induce sensations safely to extinguish fear), in vivo exposure (return to avoided situations — mall, driving) prevents agoraphobia; (3) SSRI first-line medication (sertraline, paroxetine, escitalopram) — start low (panic patients sensitive); (4) Limit ER visits + repeat cardiac testing (reinforces illness behavior + iatrogenic anxiety); coordinate care; (5) Avoid long-term benzodiazepine — short-term bridging while SSRI titrating ok; (6) Address family history concern — modify cardiovascular risk factors + reassurance; (7) Comorbid health anxiety (illness anxiety disorder) — CBT for health anxiety; (8) Lifestyle: caffeine, alcohol, exercise, sleep; (9) Multidisciplinary: psychiatry, primary care (single source) to coordinate; (10) Treatment outcomes good (60-80%)

---

Panic Disorder + Health Anxiety: education + CBT + SSRI first-line. Interoceptive + in vivo exposure prevents agoraphobia. Limit ER + repeat testing (reinforces). AVOID long-term benzodiazepine. Coordinated care.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 38 ปี recurrent ER visits × 6 episodes — palpitations + chest pain + SOB + diaphoresis + sense of doom, lasting 10-15 min; every workup negative (ECG, trop, echo, stress test, holter, TSH); attacks now triggered by going to mall + driving + occur unpredictably; avoids these situations

Family hx of MI age 50
Intense fear of having heart attack';

update public.mcq_questions
set choices = '[{"label":"A","text":"Repeat workup each visit"},{"label":"B","text":"Illness Anxiety Disorder (DSM-5"},{"label":"C","text":"Avoid all medical care"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Illness Anxiety Disorder (DSM-5: preoccupation with having serious illness + minimal somatic sx + high anxiety + excessive health-related behaviors or avoidance + ≥ 6 mo): (1) CBT for health anxiety first-line — cognitive restructuring of catastrophic interpretation, behavioral experiments, exposure (reduce reassurance seeking + checking + avoidance); (2) SSRI second-line or for severe (paroxetine, fluoxetine evidence); (3) Establish single primary care provider — limit doctor shopping + repeat testing (reinforces); regular scheduled visits (not symptom-driven); (4) Educate + validate concern — avoid dismissing ''all in your head''; (5) Limit reassurance seeking (paradoxical reinforcer of anxiety); (6) Address comorbidity: depression, GAD, OCD; (7) Distinguish from: somatic symptom disorder (somatic sx prominent), conversion disorder (neurological), factitious (intentional), malingering (external incentive); (8) Family education; (9) Lifestyle: stress management, mindfulness; (10) Long-term — chronic illness pattern; care coordination critical

---

Illness Anxiety Disorder (DSM-5): preoccupation with illness + minimal somatic sx + behaviors. CBT first-line. Single PCP + limit repeat testing/reassurance. SSRI for severe. Distinguish from somatic symptom disorder + factitious + malingering.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 45 ปี × 3 ปี — preoccupied กับ having serious illness แม้ workup negative + reassurance หลายครั้ง — แปลความ minor body sensations เป็น cancer; doctor shopping × 8 specialists; reads medical websites; high distress; impairs daily life

No somatic sx prominently (mild aches normal) — focus is fear of disease, not physical complaints
Differential: somatic symptom disorder (somatic sx prominent) vs IAD (fear without significant somatic sx)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Antidepressant monotherapy"},{"label":"B","text":"Schizoaffective Disorder, Bipolar Type (DSM-5"},{"label":"C","text":"No treatment"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Schizoaffective Disorder, Bipolar Type (DSM-5: uninterrupted illness with major mood episode concurrent with active phase psychosis + delusions/hallucinations ≥ 2 wk WITHOUT major mood sx + mood sx prominent majority of total illness): (1) Combination — antipsychotic + mood stabilizer (or antipsychotic alone if mood stabilized) — Paliperidone is only FDA-approved specifically for schizoaffective; (2) Mood stabilizer: lithium (bipolar type) or lamotrigine; valproate; (3) For depressive type: antidepressant cautiously + antipsychotic; (4) Clozapine for treatment-resistant + suicide risk; (5) Psychosocial — same as schizophrenia + bipolar (psychoeducation, family-focused, CBTp, supported employment); (6) Long-term maintenance medication essential; (7) Suicide risk high (between schizophrenia + bipolar); (8) Comorbidity: substance use, anxiety, metabolic; (9) Distinguish: schizophrenia with mood symptoms vs mood disorder with psychotic features vs schizoaffective (requires both — psychosis without mood + mood prominent majority of illness); (10) Multidisciplinary

---

Schizoaffective Disorder: psychosis ≥ 2 wk without mood + mood prominent majority of illness. Paliperidone only FDA-approved. Combination antipsychotic + mood stabilizer. Clozapine for refractory. Suicide risk between schizophrenia + bipolar.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 30 ปี × 3 ปี — chronic auditory hallucinations + persecutory delusions present continuously even when mood stable, แต่ก่อนหน้านี้ 1 ปี มี major depressive episode × 4 เดือน + manic episode × 6 wk — ขณะนี้ stable mood แต่ psychosis ยังคงอยู่

No substance use
MSE: prominent psychosis even when euthymic; mood currently stable';

update public.mcq_questions
set choices = '[{"label":"A","text":"Confront the delusion directly"},{"label":"B","text":"Delusional Disorder, Persecutory Type (DSM-5"},{"label":"C","text":"Surgery"},{"label":"D","text":"No treatment"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Delusional Disorder, Persecutory Type (DSM-5: ≥ 1 delusion ≥ 1 mo + criterion A for schizophrenia NOT met + functioning not markedly impaired apart from delusion + duration > 1 mo): (1) Therapeutic alliance is paramount — patients often poor insight, distrustful, treatment-resistant; engagement first; (2) Antipsychotic — limited evidence but considered first-line: low-dose atypical (risperidone, olanzapine, aripiprazole); response modest (50% improvement at best); (3) CBT for psychosis (CBTp) — engage gently, explore evidence + alternative explanations, NEVER directly confront delusion (ruptures alliance); (4) Address comorbid depression (50%); (5) Subtypes (DSM-5): erotomanic, grandiose, jealous, persecutory (most common), somatic, mixed; (6) Distinguish from: paranoid schizophrenia (bizarre delusions, hallucinations, negative sx), paranoid PD (long-standing trait), shared psychotic disorder (folie à deux), substance/medical; (7) Forensic considerations: stalking, violence (esp jealous + persecutory subtypes); (8) Long-term: chronic, partial response common; functional preservation is hallmark; (9) Family education + safety planning if risk to self/others

---

Delusional Disorder: ≥ 1 non-bizarre delusion ≥ 1 mo + criterion A schizophrenia NOT met + functioning preserved apart from delusion. Antipsychotic + CBT for psychosis — never confront directly. Functional preservation is hallmark. Forensic risk (jealous, persecutory).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 55 ปี × 3 ปี — เชื่อว่าเพื่อนบ้านกำลังวางยาพิษอาหารเขา; ค้นบ้านบ่อย, install CCTV, complained to police × 8 ครั้ง — but otherwise functions normally at work + relationships; no hallucinations, no other psychotic sx, no mood disorder, no substance use

MSE: well-groomed, employed, lucid + organized — delusion encapsulated, intense conviction
No cognitive impairment';

update public.mcq_questions
set choices = '[{"label":"A","text":"Long-term antipsychotic immediately"},{"label":"B","text":"Brief Psychotic Disorder (DSM-5"},{"label":"C","text":"No treatment"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Brief Psychotic Disorder (DSM-5: ≥ 1 of delusions/hallucinations/disorganized speech/grossly disorganized + 1 day - 1 mo + full return to premorbid level; specifier — with marked stressor): (1) Hospitalization usually indicated — safety, observation, evaluate course; (2) Short-term antipsychotic (atypical low-dose) + benzodiazepine for acute agitation; (3) Address precipitant — supportive psychotherapy + grief work + social support; (4) Pregnancy — coordinate OB + delivery planning; perinatal psychiatry consultation; medication safety in late pregnancy; (5) After resolution — taper antipsychotic over months (typical 1-3 mo course); some discontinue without need for maintenance; (6) Distinguish: schizophreniform (1-6 mo), schizophrenia (≥ 6 mo), postpartum psychosis (specific to postpartum), substance/medical-induced; (7) Long-term: ~ 50% have single episode + full recovery; ~ 50% progress to mood or psychotic disorder — follow longitudinally; (8) Suicide risk — assess; (9) Family education; (10) Multidisciplinary: psychiatry, OB, social work

---

Brief Psychotic Disorder (DSM-5): psychotic sx 1 day - 1 mo + full return. Stressor specifier common. Short-term antipsychotic + supportive therapy. ~ 50% single episode; ~ 50% progress. Distinguish from schizophreniform/schizophrenia by duration. Pregnancy — coordinated care.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 25 ปี G1P0 GA 38 wk — sudden onset psychotic sx (acute delusions of being followed, brief auditory hallucinations, disorganized speech, behavioral disturbance) × 5 วัน หลัง major stressor (พ่อเสียชีวิต) — no prior psychiatric history, no substance use

MSE: psychotic features, oriented x3
Workup: TSH normal, no metabolic, no infection, no neuro deficit';

update public.mcq_questions
set choices = '[{"label":"A","text":"No treatment until 6 months passes"},{"label":"B","text":"Schizophreniform Disorder (DSM-5"},{"label":"C","text":"Surgery"},{"label":"D","text":"Antibiotic"},{"label":"E","text":"Discharge"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Schizophreniform Disorder (DSM-5: criteria A, D, E ของ schizophrenia met + duration ≥ 1 mo but < 6 mo): (1) Atypical antipsychotic — same as schizophrenia (risperidone, olanzapine, aripiprazole, etc.); start low + titrate; (2) Early intervention services — first-episode psychosis (FEP) programs (Coordinated Specialty Care — CSC, OnTrackNY, EASA model) — reduce duration of untreated psychosis (DUP — predicts outcome); CBT for psychosis, supported employment/education, family education, low-dose antipsychotic, peer support, case management; (3) Family education + support (NEAP — National Alliance on Mental Illness Family-to-Family); (4) Cognitive behavioral therapy for psychosis (CBTp); (5) Address substance use comorbidity (often cannabis); (6) Workup: medical (thyroid, B12, drug screen, infectious, autoimmune — anti-NMDA receptor encephalitis in young), neuroimaging; (7) Course: - ~ 60% progress to schizophrenia; - ~ 30% recover (good prognostic — acute onset, prominent affective sx, confusion, no negative sx, return to premorbid); (8) Long-term medication often needed; (9) Multidisciplinary; (10) Suicide risk + assessment

---

Schizophreniform: schizophrenia criteria but 1-6 mo duration. Treat same as schizophrenia — antipsychotic + early intervention services. Reduce DUP. ~ 60% progress to schizophrenia. Workup including anti-NMDA encephalitis in young.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 21 ปี × 3 เดือน — persistent delusions + auditory hallucinations + negative sx (alogia, blunt affect) + functional decline — meet schizophrenia criterion A but duration 3 เดือน (1 mo - 6 mo)

No substance use, no medical cause
MSE: prominent psychotic features';

update public.mcq_questions
set choices = '[{"label":"A","text":"Immediate antipsychotic for prevention"},{"label":"B","text":"Clinical High Risk for Psychosis (CHR-P; also Attenuated Psychosis Syndrome"},{"label":"C","text":"No intervention until psychotic"},{"label":"D","text":"Surgery"},{"label":"E","text":"Cannabis to relax"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Clinical High Risk for Psychosis (CHR-P; also Attenuated Psychosis Syndrome — DSM-5 Section III research): (1) Early intervention essential — reduce conversion to psychosis + functional decline; (2) Specialized CHR services where available (e.g., PACE, OASIS, NEPTUNE); (3) Psychotherapy — CBT for CHR (evidence reduces conversion + improves functioning); supportive; family work; (4) AVOID routine antipsychotic — risk-benefit unfavorable for prevention; reserve for emerging full psychosis or severe sx; some evidence for omega-3 (modest); (5) Address comorbidity — depression (60%), anxiety (40%), substance use (cannabis especially — discourage strongly, increases conversion); (6) Treat comorbid conditions — SSRI for depression/anxiety; (7) Psychoeducation + family education; (8) Monitor closely — regular follow-up; assess emerging full psychosis; (9) Cannabis cessation — major modifiable risk factor; (10) Address school + functioning + social engagement; (11) Conversion rate to full psychosis ~ 20-30% over 2-3 years; majority do NOT convert — important to convey; (12) Multidisciplinary

---

Clinical High Risk for Psychosis (CHR-P): attenuated/intermittent psychotic sx, NOT full criteria. CBT first-line; AVOID routine antipsychotic. Address cannabis (modifiable risk). Treat comorbid depression/anxiety. ~ 20-30% convert over 2-3 yr. Early intervention.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'วัยรุ่นชายอายุ 17 ปี × 8 เดือน — subtle changes: social withdrawal, declining school performance, brief attenuated psychotic-like experiences (unusual perceptual phenomena, magical thinking — recognized as unusual), brief intermittent suspiciousness, sleep disturbance — but NOT meeting full psychotic disorder criteria

Family hx: uncle with schizophrenia
SIPS positive for clinical high risk (CHR-P)';

update public.mcq_questions
set choices = '[{"label":"A","text":"Another non-clozapine antipsychotic"},{"label":"B","text":"Treatment-Resistant Schizophrenia (TRS"},{"label":"C","text":"Stop all medication"},{"label":"D","text":"Surgery"},{"label":"E","text":"ECT alone without medication"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Treatment-Resistant Schizophrenia (TRS — failure ≥ 2 antipsychotics adequate trial) — Clozapine: (1) Clozapine is ONLY antipsychotic FDA-approved for TRS + only antipsychotic with mortality reduction + reduces suicide in schizophrenia; (2) Initiation: slow titration (12.5 → 25 → 50 → 100 mg over weeks); target 300-450 mg/day; therapeutic level 350-600 ng/mL; (3) Mandatory monitoring: - CBC with ANC weekly × 6 mo → biweekly × 6 mo → monthly thereafter (agranulocytosis ~ 0.4%, mortality if missed); REMS program (US); discontinue if ANC < 1000/μL; - rechallenge if mild neutropenia + ANC recovers; (4) Side effects: agranulocytosis, myocarditis (especially first 8 wk — check troponin, CRP, ECG, HR if symptoms), seizure (dose-related, prophylactic AED at high dose), sialorrhea (anticholinergic adjunct, glycopyrrolate, ipratropium), constipation (bowel monitoring — ileus risk, fatal), weight gain + metabolic, sedation, orthostasis, urinary retention, fever (benign vs NMS); (5) Drug interactions: smoking induces metabolism (level fluctuates), caffeine, fluvoxamine inhibits; (6) Augmentation if partial response — add another antipsychotic, ECT effective adjunct; (7) Reduces suicide attempts + completed suicide; (8) Long-term — chronic medication, lifelong; (9) Multidisciplinary

---

Treatment-Resistant Schizophrenia: failure ≥ 2 antipsychotics. Clozapine = only FDA-approved + only antipsychotic with mortality + suicide reduction. Mandatory ANC monitoring (agranulocytosis). Watch myocarditis, seizure, ileus, metabolic. Underutilized despite evidence.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 32 ปี schizophrenia × 10 ปี — failed adequate trials (≥ 6 wk, therapeutic dose, adherence verified) ของ risperidone, olanzapine, aripiprazole — ขณะนี้ persistent positive sx + functional impairment + 2 prior suicide attempts

No medical contraindication
WBC + ANC normal
No CV disease';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue antipsychotic"},{"label":"B","text":"Bromocriptine or amantadine"},{"label":"C","text":"Higher dose antipsychotic"},{"label":"D","text":"Antibiotic monotherapy"},{"label":"E","text":"Discharge home"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neuroleptic Malignant Syndrome (NMS — idiopathic, life-threatening; antipsychotic — typical > atypical, rapid titration, high potency, dehydration, agitation, male, young) — EMERGENCY: (1) STOP antipsychotic immediately; ICU admission; (2) Supportive: aggressive IV fluid resuscitation, cooling, electrolyte correction, monitor for rhabdomyolysis (CK, urine output, K), DIC, renal failure, respiratory failure, VTE prophylaxis (immobility); (3) Specific: - **Dantrolene** (muscle relaxant — direct skeletal muscle Ca release); - **Bromocriptine or amantadine** (dopamine agonist — addresses D2 blockade pathophysiology); - **Benzodiazepines** for agitation + sedation; - (Mild cases — may resolve with supportive alone); (4) ECT for refractory NMS + post-NMS psychosis (cannot restart antipsychotic safely acutely); (5) Distinguish from: serotonin syndrome (hyperreflexia, clonus, recent serotonergic), malignant hyperthermia (anesthetic trigger, family hx), heat stroke, anticholinergic toxicity, septic encephalopathy, malignant catatonia (similar — overlap); (6) After resolution: wait ≥ 2 weeks before rechallenge with different (low-potency or atypical) antipsychotic; risk of recurrence; (7) Multidisciplinary: psychiatry, ICU, neurology; (8) Education + medical alert documentation

---

Neuroleptic Malignant Syndrome: hyperthermia + rigidity + AMS + autonomic + elevated CK. Stop antipsychotic, ICU, supportive + dantrolene + bromocriptine/amantadine + BZD. ECT for refractory. Distinguish from serotonin syndrome (hyperreflexia/clonus). Wait ≥ 2 wk before rechallenge.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 35 ปี newly initiated haloperidol 10 mg × 3 วัน สำหรับ psychosis — มาด้วย hyperthermia 40°C, severe muscle rigidity (lead-pipe), altered mental status, autonomic instability (BP fluctuating, tachycardia 130, diaphoresis), CK 12,500 (markedly elevated), leukocytosis 18,000

No serotonergic medications, no infection localized';

update public.mcq_questions
set choices = '[{"label":"A","text":"Anticholinergic to treat TD"},{"label":"B","text":"Tardive Dyskinesia (TD"},{"label":"C","text":"Higher dose haloperidol"},{"label":"D","text":"Surgery"},{"label":"E","text":"No treatment"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Tardive Dyskinesia (TD — late-onset, persistent involuntary movement after chronic antipsychotic exposure; typical > atypical, female, elderly, long duration, mood disorder, DM): (1) Reassess need for antipsychotic; switch from typical to atypical (lower TD risk) — but discontinuing antipsychotic may unmask TD initially (withdrawal dyskinesia); cautious dose reduction; (2) VMAT2 inhibitors (FDA approved 2017 — first effective TD treatment): - **Valbenazine** (Ingrezza) 40-80 mg/day; - **Deutetrabenazine** (Austedo) 24-48 mg/day; - mechanism: reversibly inhibit vesicular monoamine transporter → reduce dopamine release; side effects: somnolence, parkinsonism, depression/SI, QTc; (3) Clozapine — lower TD risk + treats TD in some patients; consider switch for severe TD + treatment-resistant schizophrenia; (4) Older agents historically: benzodiazepines, vitamin E (modest), ginkgo biloba (limited); (5) Anticholinergic — does NOT help TD (helps acute dystonia + EPS — different mechanism); may worsen TD; (6) Monitoring: AIMS scale every 6 mo on antipsychotic; (7) Prevention: lowest effective dose, atypical preference, monitor; (8) Education + informed consent before initiating long-term antipsychotic; (9) Multidisciplinary; (10) TD often irreversible — early detection + treatment important

---

Tardive Dyskinesia: late-onset, persistent. Risk: typical, elderly, female, duration, mood. VMAT2 inhibitors (valbenazine, deutetrabenazine) FDA approved 2017. Switch to atypical/clozapine. AIMS monitoring. Anticholinergic does NOT help TD (worsens). Often irreversible.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 60 ปี chronic schizophrenia × 25 ปี on haloperidol long-term — ขณะนี้ มี involuntary movements: choreoathetoid movements of tongue + face (lip smacking, tongue protrusion, chewing) + occasional finger movements — present ≥ 6 เดือน, ผู้ป่วยรู้ตัว, ขัดต่อการกินอาหาร

DISCUS/AIMS score elevated
No recent dose change';

update public.mcq_questions
set choices = '[{"label":"A","text":"Continue haloperidol higher dose"},{"label":"B","text":"Acute Dystonia (extrapyramidal side effect — within hours-days of antipsychotic; young male, high-potency typical, IM administration — risk factors)"},{"label":"C","text":"No treatment"},{"label":"D","text":"Anticonvulsant"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Dystonia (extrapyramidal side effect — within hours-days of antipsychotic; young male, high-potency typical, IM administration — risk factors): (1) **Benztropine 1-2 mg IM/IV** or **diphenhydramine 25-50 mg IM/IV** — rapid relief (minutes to 1 h); (2) Continue oral anticholinergic prophylaxis × several days while assessing antipsychotic adjustment; (3) Reduce dose, switch to atypical (lower EPS risk), or change route; (4) Laryngeal dystonia = airway emergency — secure airway + benztropine; (5) Distinguish from: oculogyric crisis (eye-specific dystonia), seizure, tetanus, catatonia, conversion; (6) Differential EPS: - **Acute dystonia** (hours-days, sustained contraction); - **Akathisia** (motor restlessness, urge to move — propranolol, benzodiazepine, mirtazapine, cyproheptadine; reduce antipsychotic); - **Parkinsonism** (tremor, rigidity, bradykinesia — anticholinergic, amantadine; reduce dose; switch atypical); - **Tardive dyskinesia** (late onset — see separate); (7) Education + medical alert; (8) Consider atypical for future to reduce EPS risk; (9) Multidisciplinary

---

Acute Dystonia: hours-days post-antipsychotic. Risk: young male, high-potency typical, IM. Treatment: benztropine or diphenhydramine IM/IV — rapid response. Continue oral prophylaxis. Laryngeal = airway emergency. EPS spectrum: dystonia → akathisia → parkinsonism → TD (late).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 22 ปี เริ่ม haloperidol 10mg IM ใน ED สำหรับ agitation — 6 ชั่วโมงต่อมามาด้วย sudden onset painful sustained muscle contractions: torticollis + oculogyric crisis (eyes deviated upward + fixed) + jaw rigidity + slight respiratory distress

Vitals stable, no fever
MSE: alert, distressed but oriented';

update public.mcq_questions
set choices = '[{"label":"A","text":"Increase risperidone"},{"label":"B","text":"Antipsychotic-Induced Hyperprolactinemia (D2 blockade in tuberoinfundibular pathway"},{"label":"C","text":"Add estrogen replacement first-line"},{"label":"D","text":"Surgery on pituitary"},{"label":"E","text":"No action"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Antipsychotic-Induced Hyperprolactinemia (D2 blockade in tuberoinfundibular pathway — risperidone, paliperidone, haloperidol most; aripiprazole partial agonist may LOWER): (1) Verify etiology — rule out pregnancy (must), hypothyroidism, prolactinoma (MRI), medications (other dopamine antagonists, estrogens); (2) Reduce dose if possible while maintaining efficacy; (3) Switch to prolactin-sparing antipsychotic — aripiprazole (partial agonist, often lowers prolactin), quetiapine, olanzapine (less effect), clozapine; (4) Add adjunctive aripiprazole (low-dose) to current antipsychotic — lowers prolactin without losing efficacy; evidence growing; (5) Long-term consequences: amenorrhea + hypoestrogenism → bone loss/osteoporosis (especially long-term + young women), infertility, sexual dysfunction, gynecomastia (men); (6) Bone density monitoring if chronic; calcium + vitamin D; (7) Estrogen replacement controversial — usually not first choice; (8) Reproductive counseling — restoration of fertility + need for contraception when prolactin normalizes; (9) Tamoxifen or bromocriptine NOT routinely used (dopamine agonist may worsen psychosis); (10) Multidisciplinary: psychiatry, endocrinology, gynecology

---

Antipsychotic-induced hyperprolactinemia: D2 blockade tuberoinfundibular. Risperidone, paliperidone, haloperidol highest; aripiprazole partial agonist lowers. Switch to prolactin-sparing or add aripiprazole adjunct. Long-term: bone loss, infertility, sexual dysfunction. Rule out pregnancy, prolactinoma.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 28 ปี on risperidone 4 mg × 6 เดือน สำหรับ schizophrenia — ขณะนี้ amenorrhea × 4 mo + galactorrhea + decreased libido + breast tenderness

Lab: prolactin 145 ng/mL (normal < 25 ในผู้หญิง); pregnancy test negative; TSH normal
MRI pituitary normal';

update public.mcq_questions
set choices = '[{"label":"A","text":"High-dose haloperidol monotherapy"},{"label":"B","text":"Stimulant Use Disorder (Methamphetamine) + Substance-Induced Psychosis"},{"label":"C","text":"No treatment"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Stimulant Use Disorder (Methamphetamine) + Substance-Induced Psychosis: (1) Acute management: - Safety + agitation — benzodiazepine (lorazepam) preferred (calms + reduces CV stress) ± low-dose antipsychotic for psychosis; avoid haloperidol high-dose IM only (long QT, sympathetic); - IV fluids, cooling if hyperthermic, monitor for hypertensive emergency, MI, stroke, arrhythmia; - Workup: ECG, troponin if chest pain, CT brain if focal/severe headache; (2) Withdrawal: no acute medical emergency typically; depressive sx, hypersomnia, increased appetite, anhedonia, dysphoria — supportive; suicide risk during withdrawal; (3) Long-term — NO FDA-approved medication for stimulant use disorder (active research — bupropion + naltrexone combination, contingency management most effective behavioral); (4) Behavioral: **Contingency Management** = most evidence-based for stimulant use disorder (rewards for abstinence verified by UDS); CBT, Matrix Model (integrated), motivational interviewing, 12-step (Crystal Meth Anonymous); (5) Stimulant-induced psychosis: usually resolves with abstinence within days-weeks; if persists > 1 mo think primary psychotic disorder; antipsychotic short-term if needed; (6) Comorbid: HIV (sex + injection), HCV, dental, cardiovascular, depression, anxiety; (7) Multidisciplinary: addiction medicine, psychiatry, primary care, infectious disease, dental, social work; (8) Harm reduction: safer use, naloxone if also opioid, HIV testing, fentanyl test strips

---

Stimulant Use Disorder: NO FDA-approved medication. Contingency Management = most evidence-based. CBT + Matrix Model. Acute: benzodiazepine for agitation/CV stress + low-dose antipsychotic. Comorbid HIV, HCV, dental, CV. Psychosis usually resolves with abstinence.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 28 ปี methamphetamine use × 4 ปี (smoked) — มา ED ด้วย acute paranoid psychosis + agitation + tachycardia + hypertension; UDS positive methamphetamine; last use 8 ชั่วโมงก่อน; chronic users — weight loss, dental decay (meth mouth), poor hygiene; family wants treatment

No other substance use
No prior psychiatric hx';

update public.mcq_questions
set choices = '[{"label":"A","text":"Beta-blocker first-line for HTN"},{"label":"B","text":"AVOID beta-blockers"},{"label":"C","text":"No intervention"},{"label":"D","text":"Surgery only"},{"label":"E","text":"Discharge home"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cocaine-Induced Chest Pain / Possible ACS + Use Disorder: (1) Acute: - **AVOID beta-blockers** (unopposed alpha agonism → worsen vasoconstriction + hypertension); historical controversy, generally avoid alone; - **Benzodiazepine** first-line for agitation + indirectly reduces cardiac strain; - **Nitroglycerin + calcium channel blocker** for chest pain + HTN (verapamil, diltiazem); - **Aspirin** standard; - **Heparin/anticoagulation** as per ACS protocol; - PCI/cath if STEMI or persistent symptoms with troponin elevation; (2) Cocaine vasospasm + accelerated atherosclerosis + thrombosis mechanisms; MI risk × 20-30 within hours of use; (3) Distinguish: ACS (often), aortic dissection (severe ripping pain, BP discrepancy — cocaine increases risk), arrhythmia, anxiety; (4) Long-term: stimulant use disorder treatment — NO FDA-approved; contingency management most effective; CBT, motivational interviewing, 12-step; (5) Behavioral: similar to methamphetamine; (6) Comorbid: cardiovascular damage (cardiomyopathy, accelerated CAD), seizure, stroke, nasal septum (snorting), HIV/HCV (if injection), other substances; (7) Cocaethylene with concurrent alcohol — more cardiotoxic; advise both stop; (8) Naloxone availability — fentanyl-contaminated cocaine increasing; (9) Multidisciplinary: cardiology, addiction medicine, psychiatry

---

Cocaine ACS: AVOID beta-blockers (unopposed alpha). Benzodiazepine + nitroglycerin + CCB + aspirin + anticoagulation. MI risk × 20-30. Cocaethylene with alcohol more cardiotoxic. Long-term: no FDA medication; contingency management.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 32 ปี cocaine use disorder × 6 ปี — มา ED ด้วย acute chest pain + diaphoresis + agitation 1 ชั่วโมง หลัง snorting cocaine; ECG ST changes; troponin pending; BP 195/110

No prior MI, smoker
MSE: agitated, anxious';

update public.mcq_questions
set choices = '[{"label":"A","text":"Abrupt cessation continue"},{"label":"B","text":"DO NOT"},{"label":"C","text":"Resume same dose immediately"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Benzodiazepine Use Disorder + Severe Withdrawal (seizure-life-threatening; alprazolam especially severe withdrawal — short half-life + high potency): (1) Acute: - **DO NOT** abruptly resume same agent at same dose (lost dependence partial — could overshoot); resume at appropriate equivalent dose; - **Long-acting benzodiazepine substitution** (diazepam or chlordiazepoxide) — easier taper; - Anti-seizure prophylaxis with adequate benzodiazepine; phenobarbital alternative; - ICU monitoring for severe (seizure, autonomic instability, delirium tremens-like syndrome); - IV fluids, monitor electrolytes; (2) Gradual taper — months long; 10-25% reduction every 1-2 weeks; slow at end (small doses cause disproportionate withdrawal); (3) Long-term: - CBT for anxiety + insomnia (replace function of BZD); - SSRI/SNRI for underlying anxiety/depression; - Buspirone, pregabalin alternatives; - Avoid restarting BZD; (4) Behavioral: motivational interviewing, support; (5) Address underlying anxiety/insomnia — usually inadequately treated reason for chronic BZD; (6) Multidisciplinary: addiction medicine, psychiatry, primary care; (7) Education: physiological dependence after chronic use even at therapeutic dose; (8) Beers criteria — avoid BZD elderly; (9) Long-term BZD risks: cognitive impairment, falls/fractures, dementia association (controversial), overdose with opioids (CDC warning)

---

Benzodiazepine Withdrawal: life-threatening (seizure, DT-like). Alprazolam severe (short half-life, high potency). Long-acting substitution (diazepam) + gradual taper over months. Phenobarbital alternative. Underlying anxiety/insomnia — treat with non-BZD long-term (CBT, SSRI, buspirone).'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'หญิงไทยอายุ 50 ปี alprazolam 2 mg QID × 5 ปี (initially for panic, escalated; obtained from multiple doctors) — abrupt cessation 2 วันที่แล้ว — มา ED ด้วย tremor, severe anxiety, insomnia, perceptual disturbance, autonomic hyperactivity (HR 115, BP 165/95, diaphoresis), brief generalized tonic-clonic seizure × 1 ใน ED

No other substance use
UDS: positive benzodiazepine only';

update public.mcq_questions
set choices = '[{"label":"A","text":"No treatment — cannabis is harmless"},{"label":"B","text":"Cannabis Use Disorder (DSM-5"},{"label":"C","text":"Long-term benzodiazepine"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cannabis Use Disorder (DSM-5: ≥ 2/11 criteria within 12 mo) — adolescent + heavy use + high-potency: (1) NO FDA-approved medication for cannabis use disorder — supportive + behavioral; (2) **Behavioral first-line**: - Motivational Enhancement Therapy + CBT + Contingency Management combination most effective; - Adolescent-specific: Family-based (Multidimensional Family Therapy — MDFT), CRAFT, A-CRA; - 12-step (Marijuana Anonymous, NA); (3) Address comorbidity: anxiety (common — cannabis-induced + underlying), depression, ADHD (high comorbidity), other substance use, conduct disorder, learning issues, school problems; (4) Withdrawal syndrome (recognized DSM-5): irritability, anxiety, sleep disturbance, decreased appetite, restlessness, depressed mood — peaks day 2-6, resolves 1-2 weeks; supportive (sleep hygiene, exercise, hydration, distraction); off-label gabapentin, NAC studied; (5) Education: - High-potency concentrates (dabs, wax) → higher addiction + psychosis risk; - Cannabis-induced psychosis + risk of conversion to schizophrenia (especially with family hx, early use, high potency); - Adolescent brain effects (executive function, memory, motivation); - Cognitive impairment may partially reverse with abstinence; (6) Family involvement essential for adolescent; (7) School-based intervention; (8) Long-term: ~ 9% adult users develop dependence; ~ 17% if start in adolescence; (9) Multidisciplinary

---

Cannabis Use Disorder: NO FDA-approved medication. Behavioral (MET + CBT + Contingency Management) first-line. Adolescent: family-based (MDFT). Withdrawal syndrome real (DSM-5). High-potency concentrates ↑ psychosis + addiction. Adolescent brain effects + psychosis risk.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'วัยรุ่นชายอายุ 17 ปี cannabis daily × 2 ปี (high-potency dabs concentrate) — declining school performance, decreased motivation, social withdrawal, irritability เมื่อ cannot use; cannabis-induced anxiety + transient psychotic-like sx เกิดบางครั้ง — parents brought for evaluation

No other substance use
No prior psychiatric hx
MSE: alert, somewhat amotivated, no acute psychosis';

update public.mcq_questions
set choices = '[{"label":"A","text":"High-dose haloperidol IM monotherapy"},{"label":"B","text":"Phencyclidine (PCP) Intoxication"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Surgery"},{"label":"E","text":"Beta-blocker first-line"}]'::jsonb,
    explanation = '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Phencyclidine (PCP) Intoxication — Dangerous (unpredictable violence, dissociative anesthetic, anti-NMDA): (1) Safety — staff + patient — restraint if needed, low stimulation environment (''talk down'' may not work, unlike LSD); (2) Benzodiazepine first-line for agitation (lorazepam, midazolam); avoid antipsychotic acutely if possible (PCP can lower seizure threshold + extrapyramidal risk); haloperidol can be used if needed; (3) Supportive: monitor BP, cardiac, temperature (hyperthermia possible), urine output (rhabdomyolysis); IV fluids; acidification of urine NOT recommended (myoglobinuric AKI risk); (4) Workup: ECG, CK, urinalysis, electrolytes, CT head if trauma/seizure/focal; (5) Distinguishing from other agitated presentations: nystagmus (especially vertical) + dissociation + violence cluster suggests PCP/ketamine; (6) Hallucinogen use disorder: NO FDA-approved meds; behavioral + supportive; (7) Hallucinogen Persisting Perception Disorder (HPPD) — recurrent perceptual disturbances (visual snow, flashes) — rare; (8) Long-term: PCP psychotic features can persist weeks-months; address ongoing psychosis with antipsychotic; (9) Modern emerging: psilocybin + LSD therapeutic research (controlled settings) — distinguish from recreational misuse; ketamine medical use (depression, anesthesia) vs recreational; (10) Comorbidity assessment, harm reduction, multidisciplinary

---

PCP Intoxication: unpredictable violence + dissociation + vertical nystagmus + HTN. Benzodiazepine first-line for agitation. Low stimulation. AVOID urine acidification (rhabdo + AKI). Hallucinogen Use Disorder: no FDA medication; behavioral. HPPD rare persistent.'
where exam_source = 'AI-generated-board-seed'
  and board_specialty = 'psychiatry'
  and scenario = 'ชายไทยอายุ 25 ปี acute presentation — agitated, paranoid, dissociated, hypertensive (BP 180/105), HR 110, mydriasis, vertical + horizontal nystagmus, ataxia; reports using ''crystal'' (ketamine + PCP analog); intermittent violence + unpredictable behavior

UDS: positive PCP
No trauma evident';

commit;
