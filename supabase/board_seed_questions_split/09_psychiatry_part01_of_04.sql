-- ===============================================================
-- หมอรู้ — Board seed: จิตเวชศาสตร์ (psychiatry) — part 1/4 (50 MCQs)
-- Safe to paste into Supabase SQL Editor. Re-runnable.
-- ===============================================================

begin;

-- mcq_subjects for this specialty (idempotent)
insert into public.mcq_subjects
  (name, name_th, icon, audience, board_specialty, exam_type, question_count)
values
  ('psych_clinical_decision', 'จิตเวชศาสตร์ · การตัดสินใจทางเวชกรรม', '🩺', 'board', 'psychiatry', NULL, 0),
  ('psych_basic_science', 'จิตเวชศาสตร์ · วิทยาศาสตร์การแพทย์พื้นฐาน', '🧬', 'board', 'psychiatry', NULL, 0),
  ('psych_ems_mgmt', 'จิตเวชศาสตร์ · การจัดการระบบบริการการแพทย์ฉุกเฉิน', '🚨', 'board', 'psychiatry', NULL, 0),
  ('psych_integrative', 'จิตเวชศาสตร์ · ข้อสอบบูรณาการ', '🧩', 'board', 'psychiatry', NULL, 0)
on conflict (name) do nothing;

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 22 ปี นำส่งโดยพ่อแม่ — เริ่มแยกตัวจากเพื่อน, พูดเรื่องคนตามมาจะฆ่า, ได้ยินเสียงสั่งให้ทำร้ายตัวเอง × 6 เดือน, ผลการเรียนตก, ไม่อาบน้ำ

No medical illness, no substance use, no family history clear
V/S: ปกติ
MSE: thought disorganized, auditory hallucinations (commanding), persecutory delusions, blunt affect, alogia, GAF 35

UDS negative, TSH normal, CT brain normal', '[{"label":"A","text":"Observation only"},{"label":"B","text":"Side effect monitoring"},{"label":"C","text":"Refer for surgical evaluation"},{"label":"D","text":"Hospice"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** First Episode Psychosis / Schizophrenia (DSM-5: positive sx + negative sx + functional decline + > 6 mo): (1) Safety assessment + admit if dangerous; (2) **Atypical antipsychotic** first-line (lower EPS than typical): risperidone, olanzapine, aripiprazole, quetiapine; start low + titrate; (3) Clozapine reserved for treatment-resistant (failed ≥ 2 antipsychotics); requires CBC monitoring (agranulocytosis); (4) Long-acting injectable (LAI) for adherence concerns; (5) Adjuncts: benzodiazepine short-term for agitation; (6) **Psychosocial**: family education + support (NEAP — National Education + Awareness Program), CBT for psychosis, vocational rehab, supported employment, case management, peer support; (7) Early intervention services improve outcomes; (8) **Comorbidity**: depression (suicide risk high), substance use, anxiety, metabolic syndrome (antipsychotic side effect); (9) **Side effect monitoring**: weight + lipids + glucose (metabolic syndrome — olanzapine + clozapine worst), EPS, tardive dyskinesia, prolactin, QTc; (10) **Long-term**: 50-80% recurrence within 5 yr without treatment — continue medication ≥ 1-2 yr after stabilization, often lifelong; (11) Multidisciplinary: psychiatry, primary care, social work, family, vocational

---

Schizophrenia: positive (hallucinations, delusions, disorganized thought/behavior) + negative (alogia, anhedonia, asociality, avolition, affective flattening) + cognitive symptoms + functional decline. Onset late teens-20s (men earlier). Treatment: antipsychotic + psychosocial. Atypical first-line. Clozapine for treatment-resistant. Long-term medication essential. Multidisciplinary care. Early intervention improves outcomes. Recovery possible.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'APA Practice Guideline: Schizophrenia 2020; NICE CG178', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ชายไทยอายุ 22 ปี นำส่งโดยพ่อแม่ — เริ่มแยกตัวจากเพื่อน, พูดเรื่องคนตามมาจะฆ่า, ได้ยินเสียงสั่งให้ทำร้ายตัวเอง × 6 เดือน, ผลการเรียนตก, ไม่อาบน้ำ

No medical illness, no substance use, no family history clear
V/S: ปกติ
MSE: thought disorganized, auditory hallucinations (commanding), persecutory delusions, blunt affect, alogia, GAF 35

UDS negative, TSH normal, CT brain normal'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 35 ปี G2P1 postpartum 6 weeks มา OPD ด้วยอาการ low mood, loss of interest, fatigue, insomnia, poor appetite, weight loss 5kg, suicidal ideation × 4 weeks, difficulty bonding with baby

No psychiatric history
No substance use
Thyroid: TSH normal, anemia: Hb 11.0
EPDS score: 22 (very high)
PHQ-9: 18 (severe)', '[{"label":"A","text":"Discharge — postpartum blues will resolve"},{"label":"B","text":"Postpartum Major Depression with Suicidal Ideation"},{"label":"C","text":"Antibiotic"},{"label":"D","text":"Surgery"},{"label":"E","text":"Wait + see"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Postpartum Major Depression with Suicidal Ideation: (1) **Safety assessment first** — suicidal ideation requires immediate evaluation: plan, intent, means, protective factors; assess for infanticide thoughts (rare but devastating); hospitalize if active suicidal/infanticidal/inability to care for self/baby; (2) **Treatment**: SSRI first-line — sertraline preferred (low milk transfer, evidence-based) or paroxetine; alternatives — escitalopram, venlafaxine; brexanolone IV (FDA approved postpartum depression — limited availability); zuranolone oral (FDA approved 2023 postpartum depression — 2-week course); (3) **Psychotherapy**: CBT, IPT (interpersonal — specifically for postpartum), peer support; (4) **Breastfeeding considerations**: most SSRIs low milk transfer + acceptable; benefits of treatment outweigh; (5) **Social support**: family involvement, partner education, mother support groups, public health nurse visits, child care assistance; (6) **Multidisciplinary**: OB-GYN, psychiatry, primary care, pediatrician, social work, lactation; (7) **Follow-up**: close (weekly initially); (8) **Family education**: depression is medical illness, NOT character flaw — reduce stigma + guilt; (9) **Untreated risks**: maternal suicide, infanticide, impaired bonding, child development issues, future pregnancy depression, marital issues; (10) **Differential**: postpartum blues (50-80%, < 2 wk, mild, self-limited), postpartum psychosis (0.1-0.2%, EMERGENCY — high infanticide risk), other secondary causes (thyroid, anemia)

---

Postpartum Depression: 10-20% of women. Distinct from postpartum blues (50-80%, < 2 wk, mild). Risk factors: prior depression, life stressors, lack of support, complications. Suicide leading cause of maternal mortality some series. Differential: postpartum psychosis (0.1-0.2%) — emergency, infanticide risk. Treatment: SSRI + psychotherapy + social support. Brexanolone + zuranolone new FDA-approved options. Multidisciplinary. Safety paramount.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'ACOG Committee Opinion: Screening for Perinatal Depression 2018; APA Practice Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 35 ปี G2P1 postpartum 6 weeks มา OPD ด้วยอาการ low mood, loss of interest, fatigue, insomnia, poor appetite, weight loss 5kg, suicidal ideation × 4 weeks, difficulty bonding with baby

No psychiatric history
No substance use
Thyroid: TSH normal, anemia: Hb 11.0
EPDS score: 22 (very high)
PHQ-9: 18 (severe)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 26 ปี มาห้องฉุกเฉินด้วยอาการ ตื่นเต้น พูดเร็ว ความคิดเร็ว ไม่นอน 3 คืน ใช้เงินซื้อของแพง ๆ มากกว่ารายได้ + แผนใหญ่ทำธุรกิจ + irritable + sexual disinhibition

ก่อนหน้านี้ 6 เดือนเคยมี depressive episode รุนแรง (treated by previous psychiatrist with SSRI)

MSE: pressured speech, flight of ideas, grandiose delusions, elevated mood, distractible, decreased need for sleep
No substance use detected (UDS negative)
TSH normal

DSM-5 criteria for manic episode met', '[{"label":"A","text":"SSRI alone"},{"label":"B","text":"Stop SSRI"},{"label":"C","text":"Antibiotic"},{"label":"D","text":"Surgery"},{"label":"E","text":"Discharge — overworked"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bipolar I Disorder Manic Episode (after recent SSRI for depression — possible SSRI-induced mania revealing Bipolar) — DSM-5: distinct period elevated/irritable + ≥ 3 sx (DIG FAST: Distractibility, Indiscretion, Grandiosity, Flight of ideas, Activity ↑, Sleep ↓, Talkativeness) ≥ 1 week: (1) **Stop SSRI** (may have triggered mania — antidepressants in unrecognized bipolar can cause manic switch; SSRI alone in bipolar increases cycling); (2) **Acute mania treatment**: - **Lithium** (effective + reduces suicide risk uniquely; monitor levels 0.8-1.2, renal, thyroid); - **Valproate/Divalproex** (loading dose available, faster onset; teratogenic — avoid in women of reproductive age, NTD); - **Atypical antipsychotic** (risperidone, olanzapine, quetiapine, aripiprazole, asenapine, cariprazine — multiple FDA approved); - Combination — mood stabilizer + atypical for severe; (3) **Safety**: hospitalize if dangerous (poor judgment, psychotic, suicidal, financial/legal risk); (4) **Adjuncts**: benzodiazepine for agitation/insomnia short-term; restraint last resort; (5) **Long-term maintenance**: lithium gold standard; alternatives — valproate, lamotrigine (depression-focused), quetiapine, aripiprazole LAI; (6) **Psychotherapy**: CBT, family-focused, IPSRT (interpersonal + social rhythm therapy — sleep + routine focus), psychoeducation; (7) **Monitor**: side effects (lithium — renal, thyroid; valproate — liver, weight, polycystic ovaries; atypical — metabolic, EPS); (8) **Comorbidity high**: substance use, anxiety, ADHD, suicide (15× general); (9) **Family**: education, support, genetics counseling; (10) **Long-term**: chronic illness, recurrent episodes, maintenance medication essential

---

Bipolar I = ≥ 1 manic episode (depression not required for diagnosis but common). Mania DSM-5: elevated/irritable mood + ≥ 3 sx ≥ 7 days (or any duration if hospitalization). SSRI in undiagnosed bipolar may trigger mania (''switch''). Treatment: stop SSRI, mood stabilizer + atypical antipsychotic. Lithium gold standard (unique suicide reduction). Long-term maintenance essential. Comorbidity + suicide risk high. Psychotherapy + family support. Recovery possible with treatment.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'APA Practice Guideline: Bipolar Disorder; CANMAT/ISBD 2018 Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ชายไทยอายุ 26 ปี มาห้องฉุกเฉินด้วยอาการ ตื่นเต้น พูดเร็ว ความคิดเร็ว ไม่นอน 3 คืน ใช้เงินซื้อของแพง ๆ มากกว่ารายได้ + แผนใหญ่ทำธุรกิจ + irritable + sexual disinhibition

ก่อนหน้านี้ 6 เดือนเคยมี depressive episode รุนแรง (treated by previous psychiatrist with SSRI)

MSE: pressured speech, flight of ideas, grandiose delusions, elevated mood, distractible, decreased need for sleep
No substance use detected (UDS negative)
TSH normal

DSM-5 criteria for manic episode met'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 28 ปี มา OPD ด้วยอาการ recurrent panic attacks 6 เดือน — palpitations, sweating, trembling, SOB, chest discomfort, fear of dying — last 10-20 min then resolve; เริ่มกลัวที่จะออกจากบ้าน (agoraphobia)

Medical workup: ECG normal, echo normal, TSH normal, holter normal, no medical cause
No substance use

MSE: anxious, well-oriented, no psychotic symptoms', '[{"label":"A","text":"Surgery"},{"label":"B","text":"Panic Disorder with Agoraphobia (DSM-5)"},{"label":"C","text":"Aspirin"},{"label":"D","text":"Beta-blocker only"},{"label":"E","text":"Avoid all activity"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Panic Disorder with Agoraphobia (DSM-5): (1) **Psychoeducation**: explain physiology of panic (fight-or-flight false alarm), normalize, reduce catastrophic interpretation; (2) **CBT** — first-line (Cochrane evidence; equivalent to medication, durable): - cognitive restructuring (challenge catastrophic thoughts); - interoceptive exposure (induce sensations safely — spinning, breath holding — habituate); - in vivo exposure (graduated exposure to feared situations — overcome avoidance + agoraphobia); - relaxation; (3) **Medication**: SSRI first-line (sertraline, paroxetine, fluoxetine, escitalopram) — start low (panic patients sensitive to side effects), titrate up over weeks; SNRI alternative; clomipramine (TCA — effective but side effects); (4) **Avoid benzodiazepines long-term** (effective acutely but tolerance, dependence, withdrawal; useful short-term during SSRI initiation 4-6 weeks); (5) **Treatment duration**: SSRI continue 12 months after remission then taper; CBT skills lifelong; (6) **Comorbidity**: depression, other anxiety disorders, substance use; (7) **Lifestyle**: avoid caffeine, alcohol, stimulants; regular exercise; sleep hygiene; (8) **Self-help resources**: books, apps, peer support; (9) **Outcomes**: 50-70% achieve full remission with treatment; (10) **Multidisciplinary**: psychiatry, primary care, mental health counseling

---

Panic Disorder: recurrent unexpected panic attacks + persistent worry. Often agoraphobia. Treatment: CBT + SSRI (combination most effective; either alone effective). Avoid long-term benzodiazepines. Treatment duration extended. Comorbidity common. Lifestyle modification. Outcomes 50-70% remission. Self-management skills lifelong. Multidisciplinary.', NULL,
  'easy', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'APA Practice Guideline: Panic Disorder; NICE CG113', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 28 ปี มา OPD ด้วยอาการ recurrent panic attacks 6 เดือน — palpitations, sweating, trembling, SOB, chest discomfort, fear of dying — last 10-20 min then resolve; เริ่มกลัวที่จะออกจากบ้าน (agoraphobia)

Medical workup: ECG normal, echo normal, TSH normal, holter normal, no medical cause
No substance use

MSE: anxious, well-oriented, no psychotic symptoms'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 32 ปี ทหารผ่านศึก กลับจากสงคราม 2 ปี + มาด้วยอาการ flashbacks, nightmares, hypervigilance, avoidance of triggers, irritability, sleep disturbance, dissociation — เกิดหลังเหตุการณ์รุนแรง × 18 เดือน

No substance use disorder
MSE: anxious, hypervigilant, intrusive thoughts visible during interview
CAPS-5 score: 65 (severe)', '[{"label":"A","text":"Avoid all therapy"},{"label":"B","text":"Post-Traumatic Stress Disorder (PTSD) — DSM-5: exposure + intrusion + avoidance + negative cognitions/mood + hyperarousal > 1 month + functional impairment"},{"label":"C","text":"Antibiotic"},{"label":"D","text":"Surgery"},{"label":"E","text":"Refuse treatment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Post-Traumatic Stress Disorder (PTSD) — DSM-5: exposure + intrusion + avoidance + negative cognitions/mood + hyperarousal > 1 month + functional impairment: (1) **Psychotherapy first-line — trauma-focused** (Cochrane + ISTSS evidence): - **Prolonged Exposure (PE)**: gradual exposure to trauma memories + cues; - **Cognitive Processing Therapy (CPT)**: address maladaptive cognitions about trauma; - **EMDR (Eye Movement Desensitization + Reprocessing)**: bilateral stimulation while recalling trauma; - **Trauma-focused CBT**: integrates exposure + cognitive components; (2) **Pharmacotherapy**: SSRI first-line (sertraline + paroxetine FDA approved); SNRI alternative (venlafaxine); other — prazosin for nightmares; (3) **Avoid**: benzodiazepines (worsen PTSD outcomes per evidence), atypical antipsychotic as monotherapy; (4) **Adjunct**: MDMA-assisted therapy (FDA approval pending — research promising — MAPS); ketamine (research), psilocybin (research); cannabis controversial; (5) **Comorbidity** common: depression, substance use, anxiety, sleep, suicidality; (6) **Peer support**: veteran groups (Wounded Warrior, VA), support groups; (7) **Family/relationship therapy**: secondary impact on family; (8) **Vocational support**: return to work, disability benefits; (9) **Suicide assessment**: PTSD increases risk substantially; (10) **Multidisciplinary**: psychiatry, primary care, social work, addiction medicine, family therapy, vocational rehab; (11) **Self-care**: exercise, sleep, mindfulness, limiting substances

---

PTSD: exposure to traumatic event + persistent re-experiencing + avoidance + negative cognitions/mood + hyperarousal > 1 month + functional impairment. Treatment: trauma-focused psychotherapy first-line (PE, CPT, EMDR). SSRI/SNRI medication. AVOID benzodiazepines. Emerging: MDMA-assisted therapy. Comorbidity common. Suicide risk increased. Multidisciplinary care. Recovery possible.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'APA Practice Guideline: PTSD 2017; VA/DoD Clinical Practice Guideline 2017', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ชายไทยอายุ 32 ปี ทหารผ่านศึก กลับจากสงคราม 2 ปี + มาด้วยอาการ flashbacks, nightmares, hypervigilance, avoidance of triggers, irritability, sleep disturbance, dissociation — เกิดหลังเหตุการณ์รุนแรง × 18 เดือน

No substance use disorder
MSE: anxious, hypervigilant, intrusive thoughts visible during interview
CAPS-5 score: 65 (severe)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 45 ปี ดื่มสุราหนัก × 20 ปี — มา OPD ปรึกษาเรื่องเลิกเหล้า, ดื่มวันละ ~ 12 standard drinks, ไม่สามารถหยุดได้ ก่อนหน้านี้พยายามหยุดแล้วเกิด tremor + กระสับกระส่าย

Lab: AST 145, ALT 88 (AST > ALT classic), MCV 102 (high), GGT 285, low platelets, low albumin — fatty liver, possibly early cirrhosis
AUDIT score 28 (severe AUD)
No other substance use
Depression PHQ-9 14', '[{"label":"A","text":"Stop drinking immediately at home alone"},{"label":"B","text":"Alcohol Use Disorder (AUD) Severe + Comorbid Depression"},{"label":"C","text":"Surgery"},{"label":"D","text":"Ignore"},{"label":"E","text":"Antibiotic only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Alcohol Use Disorder (AUD) Severe + Comorbid Depression: (1) **Withdrawal management**: supervised detox preferred due to severity + comorbidity — admit or close outpatient monitoring; **benzodiazepine** (lorazepam, oxazepam — short-acting safer in liver disease) per CIWA-Ar protocol; **thiamine 100mg IV/IM BEFORE glucose** (prevent Wernicke); folate, multivitamin; correct K, Mg, phos; monitor for DTs (peak 48-96h after last drink); (2) **MAT (Medication-Assisted Treatment) for AUD long-term**: - **Naltrexone** (oral 50mg or LAI 380mg monthly — reduces cravings + reward, contraindication current opioid use, liver caution); - **Acamprosate** (333mg TID — reduces craving, safer in liver disease, renal adjustment); - **Disulfiram** (aversion — limited evidence, last-line, motivated patients); - **Topiramate, gabapentin, baclofen** (off-label, evidence base growing); (3) **Behavioral**: CBT, motivational interviewing, contingency management, AA + 12-step (free, accessible), SMART recovery; (4) **Comorbid depression**: SSRI (sertraline preferred — less hepatic + safe); often improves with sobriety + treatment; (5) **Medical workup + management**: liver disease (LFT, fibroscan, hepatitis B/C/HIV screening), nutrition, cardiac, pancreatic, neurological (Wernicke-Korsakoff, peripheral neuropathy), cancer screening; (6) **Social**: family education, social work, financial counseling, legal issues, vocational; (7) **Relapse prevention**: triggers, coping skills, support network; (8) **Multidisciplinary**: addiction medicine, psychiatry, primary care, hepatology, social work, peer support; (9) **Trauma history common** (PTSD overlap) — address

---

AUD = chronic relapsing brain disease. Severe AUD + abrupt cessation = withdrawal (tremor, agitation, autonomic, seizure, DTs — mortality if untreated). Supervised detox + thiamine before glucose. Long-term MAT (naltrexone, acamprosate, disulfiram, topiramate). Behavioral therapy + 12-step. Comorbid depression treatment. Multidisciplinary. Liver disease workup. Modern: addiction = medical illness, treat without stigma.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'ASAM/APA AUD Practice Guidelines; SAMHSA Treatment Improvement Protocols', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ชายไทยอายุ 45 ปี ดื่มสุราหนัก × 20 ปี — มา OPD ปรึกษาเรื่องเลิกเหล้า, ดื่มวันละ ~ 12 standard drinks, ไม่สามารถหยุดได้ ก่อนหน้านี้พยายามหยุดแล้วเกิด tremor + กระสับกระส่าย

Lab: AST 145, ALT 88 (AST > ALT classic), MCV 102 (high), GGT 285, low platelets, low albumin — fatty liver, possibly early cirrhosis
AUDIT score 28 (severe AUD)
No other substance use
Depression PHQ-9 14'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 18 ปี นำส่งโดยพ่อแม่ — น้ำหนัก 38 kg (BMI 14.2), ปฏิเสธว่าตัวเองอ้วน, จำกัดอาหารอย่างรุนแรง, ออกกำลังกายมาก, primary amenorrhea เริ่ม 12 เดือน

V/S: BP 84/52 (low), HR 48 (bradycardia), Temp 36.0°C (low)
Gen: cachectic, lanugo hair, dry skin
Lab: K 2.8 (low), Mg 1.4 (low), phos 1.8 (low), low T3, low albumin, mild anemia
EKG: prolonged QTc 478 ms', '[{"label":"A","text":"Discharge — lifestyle choice"},{"label":"B","text":"Anorexia Nervosa, Restricting Type (DSM-5: restriction → significantly low body weight + intense fear weight gain + body image disturbance) — Severe + Medically Unstable"},{"label":"C","text":"Refuse care"},{"label":"D","text":"Surgery"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Anorexia Nervosa, Restricting Type (DSM-5: restriction → significantly low body weight + intense fear weight gain + body image disturbance) — Severe + Medically Unstable: (1) **Inpatient medical stabilization** (criteria for hospitalization met — vital signs, electrolytes, severe weight loss): cardiac monitoring (arrhythmia risk — bradycardia, QTc prolongation, sudden death), correct electrolytes (K, Mg, phos), maintain warmth; (2) **Refeeding syndrome prevention** — major risk: start low calorie 1000-1200 kcal/d + advance slowly + phosphate/Mg/K supplementation + thiamine + close monitoring; phosphorus drops on refeeding (life-threatening); (3) **Nutritional rehabilitation**: registered dietitian, structured meals, gradual weight restoration goal (~ 1 lb/wk inpatient, 0.5-1 lb/wk outpatient); (4) **Psychotherapy**: family-based treatment (FBT/Maudsley) — first-line for adolescents (parents take active role); CBT-E (eating disorder); IPT; (5) **Medication**: no FDA-approved for AN; SSRI for comorbid depression/anxiety (after weight restoration — less effective when underweight); olanzapine (limited evidence — weight gain + reduce obsessions); (6) **Multidisciplinary essential**: psychiatry, primary care, dietitian, family therapy, individual therapy, medical monitoring; (7) **Stepwise care**: inpatient → residential → PHP → IOP → outpatient — based on stability; (8) **Long-term**: chronic illness, relapse common, mortality 5-10% (highest psychiatric mortality), need lifelong follow-up; (9) **Family education + support**: not patient''s fault, illness behavior, recovery long; (10) **Suicide risk** elevated; (11) **Outcomes**: 50% full recovery, 25% partial, 25% chronic; early intervention improves

---

Anorexia Nervosa: significantly low body weight + intense fear gain + body image disturbance. Restricting vs binge-purge subtypes. Medical complications life-threatening: cardiac (arrhythmia, sudden death), electrolyte (refeeding syndrome), endocrine (amenorrhea, osteoporosis), GI, neurological. Treatment: medical stabilization + nutritional rehab + psychotherapy (FBT for adolescents). Multidisciplinary. Highest psychiatric mortality. Long-term care. Recovery possible.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'APA Practice Guideline: Eating Disorders 2023; AED + AAP Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 18 ปี นำส่งโดยพ่อแม่ — น้ำหนัก 38 kg (BMI 14.2), ปฏิเสธว่าตัวเองอ้วน, จำกัดอาหารอย่างรุนแรง, ออกกำลังกายมาก, primary amenorrhea เริ่ม 12 เดือน

V/S: BP 84/52 (low), HR 48 (bradycardia), Temp 36.0°C (low)
Gen: cachectic, lanugo hair, dry skin
Lab: K 2.8 (low), Mg 1.4 (low), phos 1.8 (low), low T3, low albumin, mild anemia
EKG: prolonged QTc 478 ms'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 8 ปี นำส่งโดยพ่อแม่และครู — มีปัญหาที่โรงเรียน: ไม่นั่งนิ่ง, รบกวนเพื่อน, ไม่ทำงาน, ไม่ฟังคำสั่ง, ทำงานไม่เสร็จ, สับสน × 2 ปี

No trauma, no developmental delay, regular school, BMI normal
ADHD Rating Scale (Parent + Teacher) elevated
DSM-5 criteria for ADHD met (combined type): ≥ 6 inattention sx + ≥ 6 hyperactive-impulsive sx + onset < 12 yo + > 6 mo + 2 settings + impairment', '[{"label":"A","text":"Disciplinary action only"},{"label":"B","text":"ADHD Combined Type — Comprehensive Multimodal Treatment"},{"label":"C","text":"Surgery"},{"label":"D","text":"Ignore"},{"label":"E","text":"Punishment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** ADHD Combined Type — Comprehensive Multimodal Treatment: (1) **Psychoeducation**: ADHD = neurodevelopmental disorder, not character flaw; understand behaviors; (2) **Behavioral interventions first-line** for preschool, **first-line or in combination** for school-age: parent training in behavior management (PCIT, behavioral parent training), school accommodations (504/IEP), classroom management, behavioral therapy; (3) **Medication** for school-age + adolescents (NICE: behavioral first for younger; combination for moderate-severe): - **Stimulants** first-line (most effective): methylphenidate (Ritalin, Concerta), amphetamine (Adderall, Vyvanse) — 70% response; side effects: appetite suppression, sleep disturbance, growth concerns (mild), tics, mood, rebound; titrate to optimal dose; - **Non-stimulants** alternative: atomoxetine (SNRI for ADHD), guanfacine ER, clonidine ER — slower onset but useful when stimulants problematic; (4) **Comorbidity** common (50-60%): learning disorders, anxiety, depression, ODD, conduct, sleep — address separately; (5) **School support**: 504 plan or IEP, modifications, IDEA services if eligible; (6) **Family**: parent training (most effective behavioral intervention), siblings, family stress; (7) **Lifestyle**: sleep, exercise, structured routine, limited screen, healthy diet; (8) **Follow-up regular**: medication titration, side effects, growth, academic + social progress; (9) **Long-term**: 50% persist into adulthood; teaches lifelong skills; (10) **Multidisciplinary**: pediatrician/psychiatrist, school psychologist, teachers, family, sometimes neuropsychology, OT for sensory

---

ADHD: neurodevelopmental disorder. Common (5-10% children). DSM-5 criteria. Treatment: multimodal — psychoeducation + behavioral (first-line young children; combination school-age) + medication (stimulants > non-stimulants). School accommodations. Comorbidity common — treat separately. Family + parent training. Long-term: 50% persist; early intervention improves outcomes. Multidisciplinary.', NULL,
  'easy', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'peds',
  'AAP ADHD Clinical Practice Guideline 2019; AACAP Practice Parameters', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'เด็กชายอายุ 8 ปี นำส่งโดยพ่อแม่และครู — มีปัญหาที่โรงเรียน: ไม่นั่งนิ่ง, รบกวนเพื่อน, ไม่ทำงาน, ไม่ฟังคำสั่ง, ทำงานไม่เสร็จ, สับสน × 2 ปี

No trauma, no developmental delay, regular school, BMI normal
ADHD Rating Scale (Parent + Teacher) elevated
DSM-5 criteria for ADHD met (combined type): ≥ 6 inattention sx + ≥ 6 hyperactive-impulsive sx + onset < 12 yo + > 6 mo + 2 settings + impairment'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 78 ปี ก่อนหน้านี้ healthy + active สังคม มาห้องฉุกเฉินด้วยอาการ acute confusion 6 ชั่วโมง — disoriented, agitated, fluctuating, hallucinations visual, ลูกบอกว่ารู้สึก like grandfather suddenly

ก่อนหน้านี้ 2 วัน ใช้ยา anticholinergic สำหรับ urinary urgency
No prior dementia
V/S: BP 134/82, HR 102, Temp 38.4°C
MSE: fluctuating consciousness, inattention, disorganized thinking, perceptual disturbance

CAM positive (Confusion Assessment Method)
UA + culture: UTI (E. coli growing)', '[{"label":"A","text":"Ignore — old age"},{"label":"B","text":"Delirium (acute fluctuating altered cognition + inattention + organic cause) — common in hospitalized elderly"},{"label":"C","text":"Restraint + sedation"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Delirium (acute fluctuating altered cognition + inattention + organic cause) — common in hospitalized elderly: (1) **Identify + treat underlying cause(s)** — multifactorial (often): - **Infection** (UTI here, pneumonia, sepsis); - **Medications** (anticholinergic, opioids, benzodiazepines, sedatives — Beers List); - **Metabolic** (electrolytes, glucose, Ca, hypoxia, hypercapnia); - **Withdrawal** (alcohol, benzo); - **Pain**; - **Constipation/urinary retention**; - **Sleep deprivation**; - **CNS** (stroke, seizure, hemorrhage); (2) **Workup**: full medical, medication review, infection workup, labs, neuro exam, possibly imaging; (3) **Non-pharmacologic management (essential)**: re-orientation (clock, calendar, names), familiar objects, family presence, hearing/vision aids, sleep hygiene, minimize tethers (lines, restraints), mobility, hydration, optimize environment (lighting day/night), avoid restraints; (4) **Pharmacologic only for severe agitation/danger**: low-dose haloperidol or quetiapine; AVOID benzodiazepines (worsen delirium except alcohol/benzo withdrawal); avoid restraints; (5) **Treat infection**: appropriate antibiotic per culture sensitivity; (6) **Multidisciplinary**: geriatric medicine consultation, nursing, family; (7) **Family education**: temporary usually, not dementia, can take weeks-months to fully resolve; (8) **Prevention** going forward: HELP Hospital Elder Life Program, comprehensive geriatric assessment, deprescribing, mobility, sleep hygiene, hearing/vision; (9) **Long-term**: persistent cognitive impairment possible (40% have some sustained changes — "never fully recover"); risk factor for future dementia + functional decline + mortality

---

Delirium: acute fluctuating altered cognition with inattention + organic cause. Common in hospitalized elderly. Multifactorial usually. CAM diagnostic tool. Identify + treat causes. Non-pharmacologic management primary. Pharmacologic for severe agitation only (low-dose antipsychotic; AVOID benzodiazepines except withdrawal). HELP program prevents delirium. Long-term consequences (cognitive decline, functional impairment, mortality).', NULL,
  'easy', 'neurology', 'review',
  'psychiatry', 'clinical_decision', 'neurology', 'adult',
  'AGS Beers Criteria 2023; HELP Program; Inouye SK NEJM 2014', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ชายไทยอายุ 78 ปี ก่อนหน้านี้ healthy + active สังคม มาห้องฉุกเฉินด้วยอาการ acute confusion 6 ชั่วโมง — disoriented, agitated, fluctuating, hallucinations visual, ลูกบอกว่ารู้สึก like grandfather suddenly

ก่อนหน้านี้ 2 วัน ใช้ยา anticholinergic สำหรับ urinary urgency
No prior dementia
V/S: BP 134/82, HR 102, Temp 38.4°C
MSE: fluctuating consciousness, inattention, disorganized thinking, perceptual disturbance

CAM positive (Confusion Assessment Method)
UA + culture: UTI (E. coli growing)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 30 ปี มาด้วยอาการ persistent low mood + anhedonia + fatigue + insomnia + decreased appetite + weight loss 5kg + difficulty concentrating + thoughts of death × 6 weeks

ก่อนหน้านี้ no psychiatric history
No substance use
Medical workup: TSH normal, B12/folate normal, CBC normal
PHQ-9: 16 (moderate-severe)
No suicidal plan + protective factors present

DSM-5 criteria for MDD met', '[{"label":"A","text":"Ignore — stress"},{"label":"B","text":"Major Depressive Disorder, Moderate-Severe — Comprehensive Treatment"},{"label":"C","text":"Surgery"},{"label":"D","text":"Refuse care"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Major Depressive Disorder, Moderate-Severe — Comprehensive Treatment: (1) **Safety assessment first** (suicide screening — Columbia Suicide Severity Rating Scale); (2) **Combination therapy most effective**: psychotherapy + medication; (3) **Psychotherapy first-line**: CBT (cognitive behavioral therapy — most studied, evidence-based, durable), IPT (interpersonal therapy), behavioral activation, problem-solving therapy; (4) **Medication**: SSRI first-line (sertraline, escitalopram, fluoxetine, paroxetine) — best tolerated, similar efficacy; SNRI alternative (venlafaxine, duloxetine); bupropion (sexual side effects less, activating, no weight gain); mirtazapine (insomnia + weight loss issues); TCA + MAOI reserved; (5) **Onset of medication**: 4-6 weeks for full effect; titrate to target dose; continue 6-12 months after remission then taper carefully; (6) **Augmentation** if partial response: add second medication, lithium, thyroid (T3), atypical antipsychotic (aripiprazole, brexpiprazole — FDA approved adjunct), exercise, light therapy (especially seasonal); (7) **Treatment-resistant depression**: psychotherapy + medication failed × 2; consider — TMS (transcranial magnetic stimulation — FDA approved), ECT (electroconvulsive therapy — most effective, esp severe/psychotic/catatonic/pregnancy), ketamine/esketamine (FDA approved 2019 — rapid effect), psilocybin/MDMA (research); (8) **Lifestyle**: exercise (effective antidepressant), sleep hygiene, nutrition, social engagement, mindfulness, limit alcohol; (9) **Family/social support**: education, involvement; (10) **Comorbidity**: anxiety, substance use, chronic pain, medical illness — treat together; (11) **Follow-up close**: weekly to start, monitor response + side effects + suicidality; (12) **Outcomes**: 60-80% respond to treatment; (13) **Relapse prevention** education + maintenance

---

MDD: ≥ 5 sx (incl depressed mood or anhedonia) × 2 wk + functional impairment. Treatment: psychotherapy + medication combination most effective. CBT + SSRI typical first-line. Multiple options for treatment-resistant (TMS, ECT, ketamine, augmentation). Lifestyle + support critical. Treatment continued 6-12 months after remission. Outcomes 60-80% respond. Multidisciplinary care.', NULL,
  'easy', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'APA Practice Guideline: MDD; NICE CG90; CANMAT 2016', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 30 ปี มาด้วยอาการ persistent low mood + anhedonia + fatigue + insomnia + decreased appetite + weight loss 5kg + difficulty concentrating + thoughts of death × 6 weeks

ก่อนหน้านี้ no psychiatric history
No substance use
Medical workup: TSH normal, B12/folate normal, CBC normal
PHQ-9: 16 (moderate-severe)
No suicidal plan + protective factors present

DSM-5 criteria for MDD met'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 28 ปี — recurrent intrusive obsessive thoughts (contamination) × 3 years + repetitive hand washing 2-3 hours/day + cannot stop + functional impairment (cannot work) + recognizes irrationality

YBOCS score 28 (severe)
No psychotic features
No substance use', '[{"label":"A","text":"Ignore"},{"label":"B","text":"Obsessive-Compulsive Disorder (OCD) — DSM-5: obsessions + compulsions + time-consuming (> 1h/d) + distress + functional impairment"},{"label":"C","text":"Surgery"},{"label":"D","text":"Refuse care"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Obsessive-Compulsive Disorder (OCD) — DSM-5: obsessions + compulsions + time-consuming (> 1h/d) + distress + functional impairment: (1) **CBT with ERP (Exposure + Response Prevention) first-line** — most effective intervention: graded exposure to feared stimulus + prevent compulsive response; (2) **Medication**: SSRI first-line — higher doses + longer duration than depression (sertraline 200, fluoxetine 60-80, fluvoxamine 200-300, escitalopram 30, paroxetine 60); response 6-12 weeks; clomipramine TCA effective alternative (cardiac, anticholinergic side effects); (3) **Combination CBT + SSRI** for severe; (4) **Augmentation if partial response**: atypical antipsychotic (aripiprazole, risperidone — adjunctive low-dose), glutamatergic agents (memantine, riluzole), DBS for refractory; (5) **Comorbid conditions** common: depression, anxiety, tic disorders, eating disorders, hoarding; (6) **Family/relationship education**: accommodation behaviors (family doing compulsions) — discourage; (7) **Long-term**: chronic + waxing/waning; lifelong medication often; (8) **Multidisciplinary**: psychiatrist + therapist + family; (9) **Treatment-resistant**: combination CBT + SSRI + atypical + clomipramine; consider rTMS, DBS, neurosurgery rare cases

---

OCD: obsessions (intrusive thoughts) + compulsions (repetitive behaviors to neutralize anxiety) + functional impairment. CBT with ERP first-line. SSRIs at HIGHER doses than depression + longer trials (12 weeks). Combination treatment for severe. Augmentation strategies. Chronic illness. Family accommodation behaviors discourage. Multidisciplinary care. Treatment-resistant: multiple options.', NULL,
  'easy', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'APA Practice Guideline: OCD 2010; International OCD Foundation', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 28 ปี — recurrent intrusive obsessive thoughts (contamination) × 3 years + repetitive hand washing 2-3 hours/day + cannot stop + functional impairment (cannot work) + recognizes irrationality

YBOCS score 28 (severe)
No psychotic features
No substance use'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 75 ปี ลูกสาวพามา — สามีบอกว่าผู้ป่วยเริ่มลืมเหตุการณ์ที่เพิ่งเกิดขึ้น × 2 ปี ค่อย ๆ แย่ลง, หลงทางในซอยที่บ้าน, ลืมชื่อหลาน, ทำอาหารไหม้, repetitive questions, agitation บางครั้ง

Family history: mother had "forgetfulness" in 80s
No recent illness, no acute change

V/S: ปกติ
MMSE 18/30 (cognitive impairment), MoCA 14/30
CT brain: cortical + hippocampal atrophy without acute lesion
Lab: TSH normal, B12 normal, no metabolic cause', '[{"label":"A","text":"Ignore"},{"label":"B","text":"Alzheimer''s Dementia (insidious progressive cognitive decline + supportive imaging + ruling out reversible causes) — Comprehensive Management"},{"label":"C","text":"Surgery"},{"label":"D","text":"Discharge"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Alzheimer''s Dementia (insidious progressive cognitive decline + supportive imaging + ruling out reversible causes) — Comprehensive Management: (1) **Confirm diagnosis**: rule out reversible (B12, TSH, neurosyphilis, depression — pseudodementia), structural (CT/MRI), other dementias (Lewy body, FTD, vascular); biomarkers (amyloid PET, CSF Aβ + tau) emerging for atypical cases; (2) **Pharmacologic** (modest benefit, may delay progression): - **Cholinesterase inhibitors** (donepezil, rivastigmine, galantamine) for mild-moderate; - **Memantine** (NMDA antagonist) for moderate-severe; combination acceptable; - **Anti-amyloid mAbs** (aducanumab, lecanemab, donanemab) — FDA approved for early AD with amyloid confirmed — slow progression modestly + ARIA (amyloid-related imaging abnormality) side effect; selected patients; very expensive; (3) **Non-pharmacologic (cornerstone)**: cognitive stimulation, structured routine, physical activity, social engagement, music therapy, art therapy, reminiscence, environment modification, fall prevention; (4) **Behavioral symptoms** (BPSD — behavioral + psychological sx of dementia): non-pharmacologic first (identify triggers, environment, communication); medications cautiously (atypical antipsychotic for severe agitation — black box warning increased mortality elderly with dementia — use lowest dose shortest time; SSRI for depression/anxiety; trazodone/melatonin for sleep; avoid benzodiazepines); (5) **Caregiver support essential**: education, support groups, respite care, caregiver burnout prevention, mental health support; (6) **Advance directives + planning**: while patient has capacity — POA, advance directive, financial, end-of-life wishes, driving cessation; (7) **Safety**: wandering (ID bracelet, GPS), driving assessment, falls, medication mismanagement, finances; (8) **Multidisciplinary**: geriatric medicine, neurology, psychiatry, social work, OT, family, primary care; (9) **Long-term**: progressive — early/middle/late stages — adjust care; eventually nursing home consideration; palliative + hospice end-stage; (10) **Lifestyle prevention**: cardiovascular health, exercise, social engagement, cognitive stimulation, sleep, MIND diet — may delay onset

---

Alzheimer''s: most common dementia. Insidious progressive cognitive decline. Diagnosis: clinical + biomarkers (emerging) + exclude reversible. Treatment: cholinesterase inhibitor + memantine + emerging anti-amyloid mAbs + non-pharmacologic. BPSD: non-pharm first; atypical antipsychotic cautiously (mortality risk). Caregiver support essential. Advance planning. Multidisciplinary. Lifestyle prevention. Long-term progressive — palliative + hospice end-stage.', NULL,
  'medium', 'neurology', 'review',
  'psychiatry', 'clinical_decision', 'neurology', 'adult',
  'AAN Dementia Guidelines; APA + Alzheimer''s Association', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 75 ปี ลูกสาวพามา — สามีบอกว่าผู้ป่วยเริ่มลืมเหตุการณ์ที่เพิ่งเกิดขึ้น × 2 ปี ค่อย ๆ แย่ลง, หลงทางในซอยที่บ้าน, ลืมชื่อหลาน, ทำอาหารไหม้, repetitive questions, agitation บางครั้ง

Family history: mother had "forgetfulness" in 80s
No recent illness, no acute change

V/S: ปกติ
MMSE 18/30 (cognitive impairment), MoCA 14/30
CT brain: cortical + hippocampal atrophy without acute lesion
Lab: TSH normal, B12 normal, no metabolic cause'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 35 ปี opioid use disorder, IV heroin × 8 ปี, mother brought to clinic seeking treatment

Last use 18 hours ago, มี withdrawal symptoms — anxiety, sweating, runny nose, abdominal cramps, body aches, nausea, dilated pupils, gooseflesh

COWS score 22 (moderate-severe withdrawal)
HIV negative, HCV positive (chronic), Hep B vaccinated
No psychiatric comorbidity acutely
Motivated for treatment + family support present', '[{"label":"A","text":"Surgery"},{"label":"B","text":"Opioid Use Disorder (OUD) — Comprehensive Treatment"},{"label":"C","text":"Detox + discharge"},{"label":"D","text":"Refuse care"},{"label":"E","text":"Ignore"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Opioid Use Disorder (OUD) — Comprehensive Treatment: (1) **Withdrawal management**: - **Buprenorphine/naloxone (Suboxone)** initiation — start when in moderate withdrawal (COWS > 12) to avoid precipitated withdrawal; 4-8mg sublingual initial, titrate; - **Methadone** — opioid replacement, requires DEA-licensed clinic; - **Symptomatic** — clonidine (autonomic), loperamide (diarrhea), NSAIDs, ondansetron; (2) **MAT (Medication for Addiction Treatment) — gold standard**: long-term reduces mortality 50% + cravings + relapse: - **Buprenorphine**: partial mu agonist, office-based, sublingual or LAI (Sublocade monthly SC); ceiling effect on respiratory depression — safer; - **Methadone**: full mu agonist, clinic-based daily dosing; effective but more risks; - **Naltrexone**: mu antagonist; XR-NTX (Vivitrol) monthly IM — must be opioid-free 7-10 days first to avoid precipitated withdrawal; (3) **Behavioral**: motivational interviewing, CBT, contingency management, 12-step (NA), peer recovery support; (4) **Harm reduction**: needle exchange, naloxone education + distribution (overdose prevention), safer use education if not abstinent; (5) **Comorbidity management**: HCV treatment (DAAs effective + curative — important to treat regardless of active use), HIV care, mental health (PTSD, depression common), other substance use; (6) **Vaccinations**: hepatitis A/B, others; (7) **Social**: family education + support, housing, employment, legal, relationships; (8) **Multidisciplinary**: addiction medicine, psychiatry, primary care, infectious disease, social work, peer support; (9) **Long-term**: chronic relapsing brain disease — ongoing care; (10) **Pregnancy**: methadone or buprenorphine during pregnancy (NOT naltrexone, NOT detox alone — high relapse + harm)

---

OUD: chronic relapsing brain disease — opioid epidemic. MAT (buprenorphine, methadone, naltrexone) reduces mortality 50%. Behavioral therapy + peer support + harm reduction. HCV treatment regardless of active use. Naloxone for overdose prevention. Pregnancy: methadone/buprenorphine (not detox alone). Multidisciplinary care. Modern: addiction = medical illness, evidence-based treatment.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'ASAM Opioid Use Disorder Guidelines; SAMHSA TIP 63; CDC', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ชายไทยอายุ 35 ปี opioid use disorder, IV heroin × 8 ปี, mother brought to clinic seeking treatment

Last use 18 hours ago, มี withdrawal symptoms — anxiety, sweating, runny nose, abdominal cramps, body aches, nausea, dilated pupils, gooseflesh

COWS score 22 (moderate-severe withdrawal)
HIV negative, HCV positive (chronic), Hep B vaccinated
No psychiatric comorbidity acutely
Motivated for treatment + family support present'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 4 ปี นำส่งโดยพ่อแม่ — concerns about development: not talking, no eye contact, repetitive behaviors (hand-flapping, lining up toys), distressed by changes in routine, sensory sensitivities (loud noises, certain textures)

Vaccinations up to date
No perinatal complications
Family history: father has "shy + quirky" similar pattern in childhood

M-CHAT-R/F positive
Developmental evaluation: ADOS-2 + ADI-R: meets criteria for ASD', '[{"label":"A","text":"Vaccines cause autism"},{"label":"B","text":"Autism Spectrum Disorder (ASD) — Comprehensive Multidisciplinary Care"},{"label":"C","text":"Bleach treatment"},{"label":"D","text":"Surgery"},{"label":"E","text":"Avoid all interaction"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Autism Spectrum Disorder (ASD) — Comprehensive Multidisciplinary Care: (1) **Early intervention essential**: Applied Behavior Analysis (ABA) — most studied + endorsed; speech therapy; occupational therapy (sensory + motor); social skills training; (2) **Early intervention services through IDEA Part C (< 3 yo) → Part B school services (3+ yo)** — IEP, related services; (3) **Educational placement**: continuum — inclusion + support → resource → specialized; (4) **Medication** (for specific symptoms, NOT core ASD): - Atypical antipsychotic (risperidone, aripiprazole — FDA approved) for severe irritability/aggression; - Stimulants or atomoxetine for ADHD comorbidity; - SSRI for anxiety/depression (caution — activation effects); - Melatonin for sleep; - Avoid polypharmacy; (5) **Family education + support**: ASD support groups, parent training, sibling support, respite care, financial planning, advocacy; (6) **Comorbidity screening + management**: ADHD (30-50%), anxiety (40%), depression, OCD, epilepsy (20-30%), GI, sleep disorders, sensory issues; (7) **Medical workup**: hearing, vision, genetic testing (chromosomal microarray, Fragile X first; targeted gene panel if syndromic; WES emerging); metabolic if features present; lead if pica; (8) **Transition planning**: adolescence + adulthood (housing, vocational, sexual education, mental health, medical home); (9) **AAP recommends**: universal autism screening 18 + 24 months; (10) **NOT proven causes**: vaccines (Wakefield study disproven + retracted), parenting, single foods; (11) **Multidisciplinary team**: developmental pediatrician, child psychiatry, speech-language pathology, OT, behavioral analyst, special education, primary care, family; (12) **Long-term outcomes vary widely**: some achieve independent adulthood; some require lifelong support; early intervention improves outcomes significantly

---

ASD: neurodevelopmental disorder — social communication + restricted/repetitive behaviors. Early intervention critical. Multimodal — ABA + speech + OT + special education + family support + medication for comorbid symptoms (NOT core ASD). Vaccines DO NOT cause autism (extensive evidence). Universal screening at 18 + 24 mo. Multidisciplinary lifelong. Outcomes variable. Modern: neurodiversity perspective + acceptance + accommodation alongside treatment.', NULL,
  'easy', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'peds',
  'AAP Practice Guideline: ASD 2020; AACAP Practice Parameters', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'เด็กชายอายุ 4 ปี นำส่งโดยพ่อแม่ — concerns about development: not talking, no eye contact, repetitive behaviors (hand-flapping, lining up toys), distressed by changes in routine, sensory sensitivities (loud noises, certain textures)

Vaccinations up to date
No perinatal complications
Family history: father has "shy + quirky" similar pattern in childhood

M-CHAT-R/F positive
Developmental evaluation: ADOS-2 + ADI-R: meets criteria for ASD'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 23 ปี recurrent ED visits for self-harm (cutting, overdose attempts), unstable relationships, intense anger, impulsivity (sex, substance, spending), chronic emptiness, fear of abandonment + 6 months

MSE: cooperative initially then becomes hostile when limits set
No psychotic features, no manic episodes
No substance use disorder (uses occasionally)
Family: mother had similar issues + child abuse history

DSM-5: 6/9 BPD criteria met', '[{"label":"A","text":"Refuse care"},{"label":"B","text":"Borderline Personality Disorder (BPD) — Comprehensive Treatment"},{"label":"C","text":"Surgery"},{"label":"D","text":"Ignore"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Borderline Personality Disorder (BPD) — Comprehensive Treatment: (1) **Therapy is mainstay**: - **Dialectical Behavior Therapy (DBT) first-line** — Linehan, evidence-based: skills training (mindfulness, distress tolerance, emotion regulation, interpersonal effectiveness), individual therapy, phone coaching; reduces self-harm + suicide attempts + ED visits; - **Mentalization-Based Treatment (MBT)** alternative; - **Transference-Focused Psychotherapy (TFP)** psychodynamic; - **STEPPS** (Systems Training for Emotional Predictability + Problem Solving) — adjunct; (2) **Medication** — adjunctive only (no FDA approved for BPD itself): SSRI for depression/anxiety (low dose, careful response); mood stabilizer (lamotrigine, valproate) for affective instability; atypical antipsychotic (quetiapine, aripiprazole) for cognitive-perceptual + impulsive sx; AVOID benzodiazepines (disinhibition, dependence); minimize polypharmacy; (3) **Safety**: chronic suicidality common — distinguish chronic from acute change; therapeutic limits + clear plan; brief hospitalization for acute danger but not extended (regression risk); (4) **ED visits**: collaborative crisis plan, validate, problem-solve, avoid reinforcing maladaptive patterns; (5) **Comorbidity** very common: depression (most), substance use, eating disorders, PTSD, anxiety; treat together; (6) **Trauma history**: childhood abuse + neglect common — trauma-informed care; (7) **Family + relationship education**: support, boundaries, family therapy; (8) **Long-term**: improves with treatment; 50% remit over 10 years (Zanarini); chronic but treatable; (9) **Multidisciplinary**: DBT-trained therapist, psychiatrist, primary care; (10) **Stigma**: prone — emphasize illness, recovery possible, dignity

---

BPD: pervasive instability of relationships + self-image + affects + impulsivity + functional impairment. DBT first-line, evidence-based. Medication adjunctive only. AVOID benzodiazepines. Trauma history common — trauma-informed care. Chronic suicidality requires individualized risk management. Recovery possible — 50% remit over 10 years. Multidisciplinary. Stigma + treatment access challenges.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'APA + NICE BPD Guidelines; Linehan DBT', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 23 ปี recurrent ED visits for self-harm (cutting, overdose attempts), unstable relationships, intense anger, impulsivity (sex, substance, spending), chronic emptiness, fear of abandonment + 6 months

MSE: cooperative initially then becomes hostile when limits set
No psychotic features, no manic episodes
No substance use disorder (uses occasionally)
Family: mother had similar issues + child abuse history

DSM-5: 6/9 BPD criteria met'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 50 ปี chronic insomnia × 6 เดือน — sleep latency 45-60 min, frequent awakenings, total sleep 4-5 hours/night + impaired daytime function — work performance suffering

No medical illness, no psychiatric comorbidity acute (some chronic stress)
No substance use
Sleep diary kept × 2 weeks
Differential ruled out: sleep apnea (no snoring, BMI 24, partner reports no apnea), restless legs (no symptoms), circadian rhythm disorder

DSM-5: criteria for Insomnia Disorder met', '[{"label":"A","text":"Long-term benzodiazepine"},{"label":"B","text":"Chronic Insomnia Disorder"},{"label":"C","text":"Surgery"},{"label":"D","text":"No treatment"},{"label":"E","text":"Avoid sleep"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Chronic Insomnia Disorder: (1) **CBT-I (Cognitive Behavioral Therapy for Insomnia) — gold standard first-line**: - sleep restriction; - stimulus control (bed only for sleep + sex); - cognitive restructuring; - relaxation training; - sleep hygiene education; - effective + durable + no side effects; available in-person, online (CBT-I apps — Sleepio, SHUTi, etc.); (2) **Sleep hygiene**: consistent schedule, no caffeine after noon, no alcohol pre-sleep (disrupts), exercise (not late), cool dark quiet room, no electronics 1h pre-sleep, light in morning; (3) **Identify + treat contributors**: stress, depression, anxiety, medical (pain, GERD, BPH, hot flashes), medications (steroids, decongestants, some antidepressants), poor sleep environment; (4) **Medications** — used judiciously, short-term, not first-line: - **Melatonin agonists** (ramelteon — safe in elderly, no abuse potential); melatonin OTC may help (especially circadian rhythm component); - **DORA** (Dual Orexin Receptor Antagonist — suvorexant, lemborexant, daridorexant) — newer, less side effects; - **Non-BZD hypnotics** (zolpidem, eszopiclone, zaleplon) — short-term + sleep-related behaviors risk; - **Sedating antidepressants** (trazodone, mirtazapine, doxepin — low dose 3-6mg) — for chronic without depression; - **AVOID benzodiazepines** long-term (tolerance, dependence, falls, cognition, AVOID in elderly per Beers); - AVOID over-the-counter sleep aids long-term (anticholinergic — older first-gen antihistamines); (5) **Comorbid mental health**: treat depression/anxiety; (6) **Long-term**: chronic + recurring; CBT-I skills lifelong; (7) **Outcomes**: CBT-I superior to medication long-term

---

Chronic insomnia: CBT-I first-line gold standard. Multicomponent — sleep restriction, stimulus control, cognitive restructuring, relaxation. Available online. Sleep hygiene + identifying contributors. Medications selective + short-term — DORA + melatonin agonist safer. AVOID long-term benzodiazepines (Beers in elderly). Sedating antidepressants low-dose. Lifestyle modification. Treat comorbid.', NULL,
  'easy', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'AASM Clinical Practice Guideline 2021 (Insomnia); ACP Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 50 ปี chronic insomnia × 6 เดือน — sleep latency 45-60 min, frequent awakenings, total sleep 4-5 hours/night + impaired daytime function — work performance suffering

No medical illness, no psychiatric comorbidity acute (some chronic stress)
No substance use
Sleep diary kept × 2 weeks
Differential ruled out: sleep apnea (no snoring, BMI 24, partner reports no apnea), restless legs (no symptoms), circadian rhythm disorder

DSM-5: criteria for Insomnia Disorder met'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 25 ปี history of schizophrenia + recent medication non-adherence — มา ED ด้วยอาการ rigid posturing, mutism, refusal to eat/drink × 3 days, immobile, waxy flexibility on exam

V/S: BP 138/85, HR 110, RR 18, Temp 38.4°C, mild dehydration
UDS: negative
Blood: CK 1,850 (elevated), Na 138, K 4.0, normal other electrolytes

MSE: catatonic features — mutism + immobility + waxy flexibility + negativism

Bush-Francis Catatonia Rating Scale: severe', '[{"label":"A","text":"Surgery"},{"label":"B","text":"Catatonia (DSM-5 category — can occur in mood, psychotic, medical, neurological)"},{"label":"C","text":"Higher dose antipsychotic"},{"label":"D","text":"Discharge"},{"label":"E","text":"Refuse treatment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Catatonia (DSM-5 category — can occur in mood, psychotic, medical, neurological): (1) **Rule out medical causes**: NMS (neuroleptic malignant syndrome — fever + rigidity + autonomic + CK + leukocytosis — high suspicion in antipsychotic patient), malignant catatonia, encephalitis (NMDA receptor encephalitis especially in young women), seizure (subclinical), metabolic; (2) **First-line treatment — Lorazepam challenge** (2mg IV/IM/PO) — both diagnostic + therapeutic: 60-80% rapid response in catatonia (within hours); if responds, continue scheduled lorazepam (8-24mg/day divided); (3) **ECT** if lorazepam fails or malignant catatonia — highly effective + can be life-saving; (4) **Discontinue antipsychotic** if suspected NMS (also possible — autonomic + fever); (5) **Supportive care**: IV fluids (dehydration), VTE prophylaxis (immobility), nutrition (NG if needed), pressure injury prevention, careful monitoring vital signs; (6) **Identify + treat underlying**: psychiatric (mood, psychotic), medical (autoimmune encephalitis if features), neurologic; (7) **Multidisciplinary**: psychiatry, neurology, internal medicine, ICU if severe; (8) **NMDA receptor encephalitis workup** in young patients with catatonia + psychiatric features — anti-NMDA antibodies (CSF + serum) — treatable with immunotherapy + tumor removal (ovarian teratoma in young women); (9) **Long-term**: addresses underlying disorder; medication adherence

---

Catatonia: distinct syndrome — multiple causes (psychiatric, medical, neurological). DSM-5 specifier. Lorazepam challenge first-line (60-80% response, diagnostic + therapeutic). ECT if refractory. Differential: NMS (similar features in antipsychotic patient — discontinue antipsychotic), encephalitis (NMDA receptor — workup in young women), malignant catatonia. Supportive care + treat underlying. Multidisciplinary.', NULL,
  'hard', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'APA Catatonia Guidelines; Fink + Taylor Catatonia', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ชายไทยอายุ 25 ปี history of schizophrenia + recent medication non-adherence — มา ED ด้วยอาการ rigid posturing, mutism, refusal to eat/drink × 3 days, immobile, waxy flexibility on exam

V/S: BP 138/85, HR 110, RR 18, Temp 38.4°C, mild dehydration
UDS: negative
Blood: CK 1,850 (elevated), Na 138, K 4.0, normal other electrolytes

MSE: catatonic features — mutism + immobility + waxy flexibility + negativism

Bush-Francis Catatonia Rating Scale: severe'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 9 ปี — multiple motor tics (eye blinking, head jerking) + vocal tics (throat clearing, occasional inappropriate word — coprolalia) × 1 year + worse with stress + better with concentration

No other psychiatric symptoms, normal development
Family: father had childhood tics that diminished by adulthood
MSE: alert, normal cognition, tics visible during interview

DSM-5: Tourette syndrome (multiple motor + ≥ 1 vocal tic > 1 year, onset < 18, not substance)', '[{"label":"A","text":"Tell child to stop tics"},{"label":"B","text":"Tourette Syndrome — Comprehensive Care"},{"label":"C","text":"Surgery"},{"label":"D","text":"Punishment"},{"label":"E","text":"Ignore comorbidities"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Tourette Syndrome — Comprehensive Care: (1) **Psychoeducation**: explain to patient + family + school + peers — tics are involuntary, not behavior choice; reduce stigma; (2) **Behavioral therapy first-line** for moderate-severe tics: **Comprehensive Behavioral Intervention for Tics (CBIT)** — habit reversal training + relaxation + functional intervention; effective + no medication side effects; (3) **Medication** when tics functionally impairing + behavioral therapy fails: - **Alpha-2 agonists** (clonidine, guanfacine) first-line — also help ADHD comorbidity; - **Antipsychotics** (haloperidol, pimozide, risperidone, aripiprazole — VMAT2 inhibitor tetrabenazine, deutetrabenazine) — effective but side effects (EPS, weight gain, sedation, metabolic); use lowest effective dose; - **Topiramate** alternative; (4) **Comorbidity** very common (90%): ADHD (50%), OCD (50%), anxiety, depression, learning disorders, sleep, autism — treat separately; (5) **Family + school support**: education, accommodations (504), reduce stigma, peer education; (6) **Long-term**: tics often improve in adolescence + adulthood (50% diminished significantly by adulthood); chronic but variable course; (7) **Multidisciplinary**: pediatric neurology or psychiatry, behavioral therapist, school psychologist, family; (8) **Avoid stimulants if exacerbate tics** (some children) — try non-stimulant or low-dose stimulant; (9) **Resources**: Tourette Association of America, support groups

---

Tourette syndrome: motor + vocal tics > 1 year onset < 18 yo. Behavioral therapy (CBIT) first-line. Medication when functionally impairing. Comorbidity common (ADHD, OCD, anxiety). Often improves in adulthood (50%). Multidisciplinary care. School support + family education. Avoid stigma. Long-term but variable.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'peds',
  'AAN Tourette Syndrome Guidelines 2019; Tourette Association of America', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'เด็กชายอายุ 9 ปี — multiple motor tics (eye blinking, head jerking) + vocal tics (throat clearing, occasional inappropriate word — coprolalia) × 1 year + worse with stress + better with concentration

No other psychiatric symptoms, normal development
Family: father had childhood tics that diminished by adulthood
MSE: alert, normal cognition, tics visible during interview

DSM-5: Tourette syndrome (multiple motor + ≥ 1 vocal tic > 1 year, onset < 18, not substance)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 28 ปี recent breakup + new job loss + financial difficulty + history of depression + previous SI without attempt × 2 ปี

Now presents with statement to therapist: ''I can''t go on. I have a plan to end it. I have means at home.'' Plan: specific method + access to means + timeline (next few days)

No psychosis
No intoxication
Family strained (just broken up with girlfriend)
No prior suicide attempt', '[{"label":"A","text":"Discharge with outpatient"},{"label":"B","text":"Suicide Risk Assessment + Management — Active Suicidal Ideation with Plan + Means + Timeline = HIGH ACUTE RISK"},{"label":"C","text":"Surgery"},{"label":"D","text":"Refuse to assess"},{"label":"E","text":"Ignore"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Suicide Risk Assessment + Management — Active Suicidal Ideation with Plan + Means + Timeline = HIGH ACUTE RISK: (1) **Immediate hospitalization** (involuntary if needed — laws vary by jurisdiction; in Thailand, mental health act applies); (2) **Ensure safety**: restrict access to means (means restriction is the most evidence-based intervention — remove guns, medications, weapons, etc.), constant observation; (3) **Comprehensive evaluation**: history, MSE, comorbidity, substance use, medical workup, collateral information; (4) **Risk + protective factors**: Risk — prior attempts (biggest predictor), mental illness, substance use, social isolation, hopelessness, recent loss, access to means, family history, chronic pain, LGBTQ+ youth, military, healthcare workers; Protective — children at home, religious beliefs, future-oriented, social support, treatment engagement; (5) **Treat underlying**: depression (SSRI, ECT for severe), other psychiatric, substance use, sleep, pain; **Lithium uniquely reduces suicide** in bipolar + unipolar; **clozapine reduces suicide** in schizophrenia; (6) **Therapy**: Cognitive Therapy for Suicide Prevention (CT-SP), DBT for those with chronic suicidality, Crisis Response Plan; (7) **Family + social support**: education, involve in safety plan, communication; (8) **Safety plan**: written, individualized — warning signs, internal coping, social distractions, contacts, professionals, means restriction (Stanley-Brown Safety Planning Intervention); (9) **Follow-up close**: within 24-48 hours of discharge, then weekly initially — transition periods highest risk; (10) **Crisis resources**: hotlines (988 US, 1323 Thailand), text lines, online resources; (11) **Multidisciplinary**: psychiatry, primary care, social work, family, peer support; (12) **Document carefully**: assessment, plan, rationale

---

Suicide risk assessment: complex + individualized. Active SI + plan + means + timeline = high acute risk → hospitalization. Means restriction most evidence-based intervention. Safety plan (Stanley-Brown). Treat underlying. Lithium + clozapine unique anti-suicide effects. Close follow-up after discharge (highest risk period). Multidisciplinary care. Documentation critical.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'Columbia Suicide Severity Rating Scale; Stanley + Brown Safety Planning; APA Practice Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ชายไทยอายุ 28 ปี recent breakup + new job loss + financial difficulty + history of depression + previous SI without attempt × 2 ปี

Now presents with statement to therapist: ''I can''t go on. I have a plan to end it. I have means at home.'' Plan: specific method + access to means + timeline (next few days)

No psychosis
No intoxication
Family strained (just broken up with girlfriend)
No prior suicide attempt'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 32 ปี G1P0 GA 28 wk underlying severe MDD on sertraline 100mg currently — concerns about medication safety in pregnancy + breastfeeding plans', '[{"label":"A","text":"Stop all medications"},{"label":"B","text":"Perinatal Psychiatric Pharmacology — Comprehensive Risk-Benefit"},{"label":"C","text":"Surgery"},{"label":"D","text":"Ignore medication"},{"label":"E","text":"Refuse all care"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Perinatal Psychiatric Pharmacology — Comprehensive Risk-Benefit: (1) **Foundational principle**: untreated maternal depression has risks (preterm, LBW, postpartum depression, suicide, impaired bonding, infant development); treatment risks (medication exposure, withdrawal) — balance individualized; (2) **SSRI in pregnancy**: - Sertraline preferred (extensive safety data, low milk transfer, evidence-based for postpartum); - Paroxetine — historical concern Ebstein cardiac anomaly (low absolute risk, controversial); avoid initiating in pregnancy but if effective + stable consider continue; - Fluoxetine + others generally acceptable; - Fluoxetine longer half-life affects newborn longer; (3) **Late pregnancy SSRI**: 30% have neonatal adaptation syndrome (transient irritability, feeding, sleep — resolves days-weeks); PPHN (persistent pulmonary HT) slight ↑ risk; do NOT routinely discontinue (relapse risk > NAS); (4) **Other antidepressants**: SNRI (venlafaxine, duloxetine) generally acceptable; bupropion (limited but no clear teratogenicity); mirtazapine acceptable; TCA + MAOI rare use; (5) **Mood stabilizers**: lithium (Ebstein anomaly — small absolute risk; if essential, monitor closely + neonatal monitoring), valproate AVOID (NTD + cognitive — high risk), lamotrigine acceptable; carbamazepine NTD + facial anomalies; (6) **Antipsychotics**: typical + atypical generally acceptable; lower risk than mood stabilizers; quetiapine + olanzapine common — gestational diabetes monitor; (7) **Benzodiazepines**: avoid 1st trimester (cleft palate small risk); late pregnancy = floppy infant + withdrawal; if essential, short-term lowest dose; (8) **Breastfeeding**: most SSRIs (sertraline, paroxetine) low transfer + acceptable; benefits of breastfeeding generally outweigh; resources LactMed; (9) **Multidisciplinary care**: OB, psychiatry, primary care, pediatrician, lactation; (10) **Shared decision-making**; (11) **Postpartum highest risk for relapse** — close monitoring + medication continuation often important; (12) **Resources**: REPROTOX, MotherToBaby, LactMed

---

Perinatal psychiatric pharmacology: balance untreated illness vs medication exposure. SSRI usually continued (sertraline preferred — low milk transfer). Untreated depression has serious risks. Postpartum highest risk period. Multidisciplinary care. Resources: MotherToBaby, LactMed. Shared decision-making. Modern: many medications acceptable with informed consent + monitoring.', NULL,
  'medium', 'obgyn', 'review',
  'psychiatry', 'clinical_decision', 'obgyn', 'adult',
  'ACOG Committee Opinion; APA Perinatal Psychiatry; LactMed; MotherToBaby', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 32 ปี G1P0 GA 28 wk underlying severe MDD on sertraline 100mg currently — concerns about medication safety in pregnancy + breastfeeding plans'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามอาจารย์เรื่อง neurobiology of mental illness — neurotransmitters + circuits', '[{"label":"A","text":"No biology relevant"},{"label":"B","text":"Psychiatric Neurobiology Foundation"},{"label":"C","text":"Only behavior matters"},{"label":"D","text":"Random biology"},{"label":"E","text":"No mechanism"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Psychiatric Neurobiology Foundation: (1) **Key neurotransmitters**: serotonin (5-HT — mood, anxiety, OCD, eating, sleep, aggression — SSRI/SNRI target), norepinephrine (alertness, anxiety, mood — SNRI, atomoxetine target), dopamine (motivation, reward, psychosis — D2 blockade for antipsychotic + addiction), GABA (inhibitory, anxiety, sleep — benzodiazepine target), glutamate (excitatory, ketamine/memantine target — NMDA receptor), acetylcholine (memory, cognition — cholinesterase inhibitor for AD); (2) **Brain circuits + psychiatric disorders**: prefrontal cortex (executive function, depression, ADHD), limbic system (amygdala — fear, mood; hippocampus — memory, PTSD, depression), basal ganglia (movement, OCD, Tourette, schizophrenia), default mode network (depression, rumination); (3) **HPA axis**: stress response, depression dysregulation (high cortisol), CRH; (4) **Genetics + epigenetics**: polygenic risk (no single gene for major psychiatric), gene-environment interaction, trauma + early adversity affect gene expression; (5) **Inflammation hypothesis**: cytokines, depression-inflammation link, sickness behavior overlap; (6) **Neuroplasticity**: BDNF (brain-derived neurotrophic factor) — antidepressants increase; ketamine rapid synaptic plasticity; exercise; (7) **Mechanism examples**: SSRI = serotonin reuptake inhibition → increased synaptic 5-HT → downstream receptor + intracellular changes → clinical effect 2-4 weeks (longer than receptor effect — neuroplasticity hypothesis); antipsychotic = D2 blockade in mesolimbic + mesocortical; ECT mechanism uncertain but BDNF, neurogenesis; psychedelics emerging — serotonin 2A receptors, rapid plasticity

---

Psychiatric neurobiology: multiple neurotransmitter systems + brain circuits + HPA axis + genetics + inflammation + neuroplasticity. Major treatments target these (SSRI, SNRI, antipsychotic, mood stabilizer, ketamine). Mechanism understanding evolving. Modern psychiatry = biopsychosocial.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'basic_science', 'psych_behavior', 'adult',
  'Kandel Principles of Neural Science; APA Textbook of Psychiatry', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Resident ถามอาจารย์เรื่อง neurobiology of mental illness — neurotransmitters + circuits'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง psychopharmacology — antidepressant choices + mechanisms', '[{"label":"A","text":"All same"},{"label":"B","text":"Antidepressants — Mechanisms + Clinical Use"},{"label":"C","text":"Random selection"},{"label":"D","text":"Single agent only"},{"label":"E","text":"No mechanism"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Antidepressants — Mechanisms + Clinical Use: (1) **SSRIs** (sertraline, fluoxetine, paroxetine, escitalopram, citalopram, fluvoxamine) — first-line for MDD, anxiety disorders; mechanism: serotonin reuptake inhibition; side effects: GI, sexual dysfunction, insomnia/somnolence, weight changes, QTc (citalopram > 40mg risk), discontinuation syndrome (especially paroxetine — short half-life); (2) **SNRIs** (venlafaxine, duloxetine, desvenlafaxine, levomilnacipran) — depression + chronic pain + anxiety; mechanism: serotonin + norepinephrine reuptake inhibition; side effects: similar to SSRIs + BP elevation, sweating; (3) **Bupropion** — depression + smoking cessation; norepinephrine + dopamine reuptake; no sexual dysfunction or weight gain; SEIZURE LOWERING (avoid in eating disorders, seizure history); activating; (4) **Mirtazapine** — depression with insomnia/weight loss; alpha-2 antagonist + 5-HT2/3 antagonist; weight gain, sedation; (5) **Trazodone** — sleep + depression; serotonin antagonist + reuptake inhibitor; orthostatic, priapism rare; (6) **TCAs** (amitriptyline, nortriptyline, clomipramine, imipramine, desipramine) — second-line; serotonin + norepinephrine reuptake + anticholinergic + antihistaminergic + alpha-1 + sodium channels; lethal in overdose (cardiac); chronic pain (low dose); OCD (clomipramine); (7) **MAOIs** (phenelzine, tranylcypromine, selegiline) — refractory; irreversible MAO inhibition (transdermal selegiline less); tyramine reaction (hypertensive crisis), serotonin syndrome (mixing with serotonergic); (8) **Atypical**: vortioxetine (multimodal), vilazodone (SSRI + 5-HT1A partial agonist), nefazodone, mianserin; (9) **Newer**: esketamine (S-ketamine — FDA approved 2019 treatment-resistant depression — rapid onset); auvelity (dextromethorphan + bupropion); (10) **Selection factors**: comorbidity, side effect profile, drug interactions, prior response, family history, patient preference, cost, pregnancy/lactation; (11) **General**: 4-6 weeks for full effect; titrate slowly initially; monitor for activation/SI; combine with psychotherapy

---

Antidepressants: multiple classes + mechanisms. SSRI/SNRI first-line. Selection based on patient factors + comorbidity + side effects. Newer: ketamine/esketamine + atypical agents. Combine with psychotherapy. 4-6 weeks for full effect. Modern psychopharmacology: precision + individualized.', NULL,
  'easy', 'psych_behavior', 'review',
  'psychiatry', 'basic_science', 'psych_behavior', 'adult',
  'APA Practice Guidelines; Stahl''s Essential Psychopharmacology', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Resident ถามเรื่อง psychopharmacology — antidepressant choices + mechanisms'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง therapy modalities — psychotherapy approaches + evidence', '[{"label":"A","text":"No therapy effective"},{"label":"B","text":"Evidence-Based Psychotherapy"},{"label":"C","text":"Surgery only"},{"label":"D","text":"Medication alone"},{"label":"E","text":"Random approaches"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Evidence-Based Psychotherapy: (1) **CBT (Cognitive Behavioral Therapy)** — most studied + applied; cognitive restructuring + behavioral; effective for MDD, anxiety disorders, OCD, PTSD, eating disorders, insomnia, psychosis; (2) **DBT (Dialectical Behavior Therapy)** — Linehan; BPD, chronic suicidality, eating disorders; skills training (mindfulness, distress tolerance, emotion regulation, interpersonal effectiveness) + individual + phone coaching + consultation team; (3) **IPT (Interpersonal Therapy)** — Klerman; depression (postpartum especially), grief; focus on interpersonal stressors; (4) **Psychodynamic therapy** — insight-oriented; transference + countertransference; longer duration; depression, anxiety, personality disorders; (5) **MBT (Mentalization-Based Treatment)** — BPD; understand own + others mental states; (6) **PE (Prolonged Exposure)** + **CPT (Cognitive Processing Therapy)** — PTSD; (7) **EMDR (Eye Movement Desensitization + Reprocessing)** — PTSD; (8) **Family-Based Treatment (Maudsley)** — eating disorders adolescents; (9) **Motivational Interviewing** — substance use, change; (10) **Behavior therapy** — habit reversal, ERP, behavioral activation; (11) **Mindfulness-based therapies**: MBCT (depression relapse prevention), MBSR (stress), ACT (acceptance + commitment); (12) **Group therapy** — interpersonal, skills, support; (13) **Family therapy** — systemic; (14) **Couples therapy** — Gottman, EFT; (15) **Telepsychiatry** — increasingly accepted modality; (16) **Selection**: patient preference, severity, comorbidity, evidence base; (17) **Combination with medication** often most effective; (18) **Therapist training + alliance** crucial; (19) **Cultural adaptation** important

---

Psychotherapy: evidence-based modalities for specific disorders. CBT most studied, broadly applicable. DBT for BPD. IPT for depression + grief. Trauma-focused for PTSD. Family-based for eating disorders adolescents. Combination with medication often most effective. Therapist training + alliance critical. Cultural adaptation important. Telepsychiatry growing.', NULL,
  'easy', 'psych_behavior', 'review',
  'psychiatry', 'basic_science', 'psych_behavior', 'adult',
  'Empirically Supported Treatments — APA Division 12', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Resident ถามเรื่อง therapy modalities — psychotherapy approaches + evidence'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Resident ถามเรื่อง stigma + mental health epidemiology in Thailand', '[{"label":"A","text":"No stigma exists"},{"label":"B","text":"Mental Health Epidemiology + Stigma"},{"label":"C","text":"Mental health irrelevant"},{"label":"D","text":"Stigma helpful"},{"label":"E","text":"No treatment exists"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Mental Health Epidemiology + Stigma: (1) **Thai mental health prevalence**: depression ~ 5-8%, anxiety disorders ~ 7-10%, substance use disorders ~ 2-3%, schizophrenia ~ 1%, dementia ~ 5-10% > 65 yo; suicide rate ~ 6-7 per 100,000 (lower than many countries but underreported); (2) **Treatment gap**: 70-80% of people with mental illness do NOT receive treatment (WHO); barriers — stigma, awareness, access, cost, capacity (limited psychiatrists especially rural); (3) **Stigma**: public stigma (others'' negative attitudes), self-stigma (internalized), structural stigma (policies); effects: delay treatment, employment + housing discrimination, social isolation; (4) **Anti-stigma interventions**: education (knowledge), contact (with affected individuals), advocacy, media + storytelling, language (''person with schizophrenia'' not ''schizophrenic''), workplace mental health programs; (5) **Thai cultural factors**: Buddhist concepts (karma, suffering), family-centered care, stigma especially severe mental illness; (6) **Mental Health Act Thailand 2008**: legal framework for involuntary treatment; (7) **Mental health policy + system**: limited workforce, primary care integration efforts, community mental health, telepsychiatry growing, school mental health, workplace; (8) **Vulnerable populations**: refugees + displaced, sexual minorities (high stigma in some communities), elderly, youth (high suicide), military, healthcare workers, women (postpartum); (9) **Global mental health priority** — WHO target — universal mental health coverage; (10) **Multidisciplinary + community approach** essential

---

Mental health epidemiology + stigma: significant burden + treatment gap in Thailand + globally. Stigma major barrier. Anti-stigma interventions multiple. Cultural sensitivity. Vulnerable populations. Mental Health Act framework. Modern: integration with primary care + community + telepsychiatry + multidisciplinary care + advocacy.', NULL,
  'easy', 'psych_behavior', 'review',
  'psychiatry', 'basic_science', 'psych_behavior', 'adult',
  'WHO Mental Health Atlas; Thailand Department of Mental Health', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_basic_science'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Resident ถามเรื่อง stigma + mental health epidemiology in Thailand'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital wants to integrate behavioral health into primary care + reduce barriers to mental health care', '[{"label":"A","text":"Specialty referral only"},{"label":"B","text":"Patient-centered team-based care"},{"label":"C","text":"Avoid mental health"},{"label":"D","text":"Surgery"},{"label":"E","text":"Random approach"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Collaborative Care Model (Wagner Chronic Care + Unützer IMPACT): (1) Integration of mental health into primary care; (2) Components: - **Patient-centered team-based care**; - **Population-based care** (registry, measurement-based care); - **Measurement-based treatment** (PHQ-9, GAD-7 routine); - **Evidence-based treatments** (CBT, IPT, medication algorithms); - **Behavioral health care manager** (nurse, social worker, psychologist) — central coordination role; - **Psychiatric consultant** (caseload review, recommendations, complex cases); (3) **Stepped care**: severity-based intensity of intervention; brief interventions for mild, more intensive for severe; (4) **Universal screening** for depression, anxiety, substance use; (5) **Same-day or warm handoff** to behavioral health team; (6) **Multiple modalities**: in-person, telephone, video, asynchronous, group; (7) **Outcomes**: IMPACT trial (Unützer JAMA 2002) — collaborative care 2× improvement vs usual care for depression; cost-effective; (8) **Mental health workforce** training: brief therapy, problem-solving, motivational interviewing; (9) **Substance use integration** — SBIRT (Screening, Brief Intervention, Referral to Treatment); (10) **Pediatric integration** (school-based, peds primary care); (11) **Geriatric integration** (HELP program, dementia care); (12) **Specialty referral** for complex cases — psychiatry, specialty programs; (13) **Telepsychiatry** to extend specialist reach especially rural; (14) **Quality metrics**: screening rate, treatment initiation, follow-up, response rate, suicide risk follow-up; (15) **Cultural + linguistic adaptation**; (16) **Family + peer support**

---

Collaborative Care Model (Wagner Chronic Care + IMPACT): evidence-based — integrate mental health into primary care. Components: care manager, registry, psychiatric consultant, measurement-based care, evidence-based treatments. Outcomes 2× better than usual care + cost-effective. Stepped care + universal screening + warm handoff. Modern: expanding to telepsychiatry + specialty programs.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'ems_mgmt', 'psych_behavior', 'adult',
  'Unützer J et al. JAMA 2002 (IMPACT); AIMS Center; SAMHSA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Hospital wants to integrate behavioral health into primary care + reduce barriers to mental health care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital implements suicide prevention program — public health approach', '[{"label":"A","text":"No prevention possible"},{"label":"B","text":"Comprehensive Suicide Prevention Program — Public Health Approach"},{"label":"C","text":"Ignore"},{"label":"D","text":"Surgery"},{"label":"E","text":"Single intervention"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Comprehensive Suicide Prevention Program — Public Health Approach: (1) **Universal prevention**: public education, stigma reduction, mental health literacy, school-based programs, media reporting guidelines (avoid copycat effect — WHO + Suicide Prevention Resource Center guidelines), safe firearm/medication storage; (2) **Selective prevention**: gatekeeper training (teachers, clergy, military, healthcare — recognize warning signs + refer); workplace programs; veteran programs; LGBTQ+ youth support; (3) **Indicated prevention**: screening high-risk (Columbia Suicide Severity Rating Scale), brief interventions, safety planning (Stanley-Brown), means restriction; (4) **Treatment access**: integrated primary care behavioral health, telepsychiatry, crisis services, hotlines (988 US, 1323 Thailand), text/chat services; (5) **Treatment of underlying**: mental health, substance use; lithium + clozapine unique anti-suicide effects; (6) **Crisis services**: 24/7 hotlines, mobile crisis teams, crisis stabilization units, peer-run respite, ED + hospital follow-up; (7) **Means restriction**: most evidence-based — counsel + restrict access (especially firearms, medications, jumping locations, pesticides — major in Asia); coalition with families, employers, communities; (8) **Postvention**: support for survivors of suicide loss (bereavement groups, individual therapy) + traumatic events (school suicide clusters); (9) **System changes**: Zero Suicide initiative (healthcare organization commitment); transitions of care critical (post-discharge highest risk); follow-up (caring contacts — postcards, calls reduce reattempts); (10) **Research + data**: surveillance, evaluation; (11) **Multidisciplinary + multisector**: healthcare, schools, workplaces, military, criminal justice, faith communities, government; (12) **Equity**: address disparities (LGBTQ+, indigenous, youth, military veterans, rural)

---

Suicide prevention: public health approach — universal + selective + indicated. Means restriction most evidence-based. Zero Suicide initiative. Crisis services + hotlines. Treatment access + transitions of care. Postvention. Multidisciplinary + multisector. Equity. Modern: data-driven + comprehensive. Many lives can be saved.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'ems_mgmt', 'psych_behavior', 'adult',
  'WHO Suicide Prevention; Zero Suicide; SAMHSA SPRC', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Hospital implements suicide prevention program — public health approach'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Hospital wants to expand telepsychiatry + reduce mental health workforce gap', '[{"label":"A","text":"Avoid technology"},{"label":"B","text":"Telepsychiatry Implementation — Expands Access + Capacity"},{"label":"C","text":"In-person only"},{"label":"D","text":"Ignore technology"},{"label":"E","text":"Random approach"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Telepsychiatry Implementation — Expands Access + Capacity: (1) **Modalities**: synchronous video (most common), telephone, asynchronous (consult, secure messaging), eConsult, hybrid models; (2) **Equipment + technology**: secure HIPAA-compliant platforms, basic hardware (camera, microphone, screen), bandwidth, backup options; (3) **Use cases**: routine outpatient visits, ED consultation (psychiatrists scarce), inpatient psychiatry consultation in non-psych hospitals, school-based, primary care integration, rural communities, correctional facilities, group therapy, family + couples therapy; (4) **Patient population**: most effective comparable to in-person care for most disorders (depression, anxiety, PTSD, ADHD, substance use disorder); some limitations — severe psychosis requiring physical exam, certain ages (very young), elderly with cognitive impairment, technology access; (5) **Special considerations**: emergency protocols (safety plan, local emergency contacts, hospital), documentation, prescription regulations (controlled substances rules — DEA Ryan Haight Act + COVID waivers); (6) **Licensing + credentialing**: state-by-state in US, interstate compacts emerging; Thailand — increasing regulation + acceptance; (7) **Reimbursement**: parity laws, payer coverage expanding post-COVID; (8) **Quality**: training in telehealth-specific skills, patient assessment + safety, technical + therapeutic competence; (9) **Equity**: digital divide concerns (rural, elderly, low-income, language barriers — provide alternatives); (10) **Modern**: collaborative care, eConsults, peer support, asynchronous apps for self-management (Headspace, Calm, BetterHelp); (11) **Multidisciplinary integration**: primary care, specialty, schools, employers; (12) **Outcomes research**: similar to in-person + improved access

---

Telepsychiatry: expands access + workforce capacity. Multiple modalities. Effective for most disorders comparable to in-person. Safety + emergency protocols essential. Licensing + reimbursement evolving. Equity — digital divide. Modern: integrated with collaborative care + asynchronous apps + peer support. COVID accelerated adoption.', NULL,
  'easy', 'psych_behavior', 'review',
  'psychiatry', 'ems_mgmt', 'psych_behavior', 'adult',
  'American Telemedicine Association; APA Telepsychiatry Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_ems_mgmt'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Hospital wants to expand telepsychiatry + reduce mental health workforce gap'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 55 ปี chronic pain (low back) + depression + opioid use disorder + chronic insomnia — multidisciplinary integrative management', '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Chronic Pain + Depression + OUD + Insomnia — Integrative Multidisciplinary Care"},{"label":"C","text":"More opioids"},{"label":"D","text":"Bedrest"},{"label":"E","text":"Single specialist"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Chronic Pain + Depression + OUD + Insomnia — Integrative Multidisciplinary Care: (1) **Bidirectional relationship**: chronic pain + depression — each worsens other; chronic pain + opioid use → addiction risk + hyperalgesia + worsens depression + sleep; (2) **Multidisciplinary team**: pain medicine, addiction medicine, psychiatry, primary care, PT, OT, behavioral health, social work, possibly anesthesia/interventional; (3) **OUD treatment first** (often) — initiating buprenorphine treats addiction + provides analgesia + can replace opioid analgesics; methadone similar; addresses primary risk; (4) **Chronic pain non-pharmacologic + non-opioid pharmacologic**: - CBT for chronic pain (evidence-based); - PT + graded exercise; - Mindfulness-based stress reduction; - Acceptance + commitment therapy; - SNRIs (duloxetine — both pain + depression); - SSRIs (less for pain but treat depression); - Anticonvulsants (gabapentin, pregabalin — caution misuse potential); - Topical agents (capsaicin, lidocaine); - Procedures (steroid injection, RFA, spinal cord stimulator selected); - Avoid escalating opioids; (5) **Depression treatment**: SSRI/SNRI (duloxetine excellent — dual purpose), CBT, behavioral activation, exercise; (6) **Insomnia**: CBT-I gold standard; avoid benzodiazepines + nightly opioids; consider melatonin agonist, low-dose trazodone, DORA; sleep hygiene; (7) **Address comorbidity**: anxiety, substance use, trauma history; (8) **Functional goals**: return to meaningful activity > pain elimination; (9) **Patient education + self-management**; (10) **Family + social support**: care navigation, support groups; (11) **Avoid harm**: monitoring, PDMP (prescription drug monitoring program), urine drug screens, naloxone, safety planning; (12) **Whole-person care**: holistic + biopsychosocial model

---

Chronic pain + depression + OUD + insomnia = quintessential integrative + multidisciplinary case. Treat OUD first often (buprenorphine multipurpose). Chronic pain — non-pharm + non-opioid (CBT, PT, SNRI). Depression treatment overlaps. CBT-I for insomnia. Functional goals over pain elimination. Whole-person care. Modern pain medicine: biopsychosocial + non-opioid focus.', NULL,
  'hard', 'psych_behavior', 'review',
  'psychiatry', 'integrative', 'psych_behavior', 'adult',
  'CDC Pain Guidelines 2022; ASAM Opioid Use Disorder Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ผู้ป่วยอายุ 55 ปี chronic pain (low back) + depression + opioid use disorder + chronic insomnia — multidisciplinary integrative management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ผู้ป่วยอายุ 28 ปี — schizophrenia + cannabis use disorder + metabolic syndrome on olanzapine + family stress — multidisciplinary integrative care', '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Schizophrenia + Substance Use + Metabolic Syndrome — Integrative Multidisciplinary Care"},{"label":"C","text":"Single drug only"},{"label":"D","text":"Refuse care"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Schizophrenia + Substance Use + Metabolic Syndrome — Integrative Multidisciplinary Care: (1) **Mental health treatment** continuation + optimization: antipsychotic adherence (LAI consideration — risperidone, paliperidone, aripiprazole, olanzapine LAIs); switch to less metabolic agent (aripiprazole, ziprasidone, lurasidone, cariprazine) given metabolic syndrome — but balance with effectiveness; (2) **Co-occurring substance use disorder**: integrated dual diagnosis treatment (separate treatment historically less effective); motivational interviewing + CBT; cannabis use disorder — no FDA-approved meds, supportive therapy + harm reduction; cannabis exacerbates psychosis + increases relapse — important to address; (3) **Metabolic syndrome management**: lifestyle (diet, exercise, weight), screen + treat (HbA1c, lipids, BP); switch antipsychotic if possible; metformin for weight gain (off-label use, modest benefit); statin if indicated; (4) **Psychosocial**: assertive community treatment (ACT) for severe persistent; supportive employment; supportive housing; CBT for psychosis (CBTp) — emerging evidence; (5) **Family education + support**: NAMI Family-to-Family, support groups, education about illness + reduce expressed emotion (high EE associated with relapse); (6) **Social determinants**: housing, employment, income, education, social network; (7) **Physical health**: people with schizophrenia 15-20 years reduced life expectancy — mostly cardiovascular + metabolic; aggressive prevention + treatment; (8) **Smoking** common (60-90%) — increases mortality + drug interactions; cessation programs; (9) **Multidisciplinary team**: psychiatry, addiction medicine, primary care, nursing, social work, vocational rehab, peer support, family; (10) **Treatment resistance** (~30%): clozapine after 2 failed antipsychotics — only antipsychotic with mortality reduction; (11) **Quality + outcomes**: SAMHSA + WHO + AIMS Center models

---

Schizophrenia + SUD + metabolic syndrome = complex chronic illness requiring integrative multidisciplinary care. Integrated dual diagnosis treatment. Metabolic syndrome major contributor to mortality — aggressive prevention + treatment + antipsychotic choice. Smoking cessation. Family education + support. Social determinants. Treatment-resistant — clozapine (unique mortality reduction). Multidisciplinary lifelong care.', NULL,
  'hard', 'psych_behavior', 'review',
  'psychiatry', 'integrative', 'psych_behavior', 'adult',
  'APA Schizophrenia 2020; NAMI; SAMHSA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ผู้ป่วยอายุ 28 ปี — schizophrenia + cannabis use disorder + metabolic syndrome on olanzapine + family stress — multidisciplinary integrative care'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'Adolescent อายุ 16 ปี — eating disorder (anorexia nervosa) + depression + cutting + family conflict + school refusal — multidisciplinary integrative management', '[{"label":"A","text":"Single specialty"},{"label":"B","text":"Adolescent Eating Disorder + Depression + Self-Harm + Family Conflict — Integrative Multidisciplinary Care"},{"label":"C","text":"Single specialist"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Adolescent Eating Disorder + Depression + Self-Harm + Family Conflict — Integrative Multidisciplinary Care: (1) **Safety assessment** + level of care: AN with medical instability → inpatient medical; otherwise residential, PHP, IOP, outpatient by severity; (2) **Family-Based Treatment (FBT/Maudsley) first-line for adolescent AN** — parents take active role in refeeding + recovery; (3) **Multidisciplinary**: adolescent medicine, child + adolescent psychiatry, dietitian, individual therapy, family therapy, school liaison; (4) **Concurrent depression**: treat with SSRI (caution — FDA boxed warning increased SI in adolescents but benefits outweigh; close monitoring); CBT or DBT; (5) **Self-harm (cutting)**: DBT-A (DBT for adolescents) — skills, family component; address function (emotion regulation usually); reduce access to means; safety plan; (6) **Family conflict**: family therapy + parental support; reduce blame + criticism; consistency; education about adolescent development; (7) **School refusal**: gradual exposure + return; school accommodations; address bullying, learning disorders, anxiety; school nurse + counselor coordination; (8) **Adolescent development considerations**: identity, peer relationships, autonomy + parental support balance, social media + body image; (9) **LGBTQ+ assessment** + support if applicable (high suicide + eating disorder risk if minority stress); (10) **Suicide risk** elevated — assess + safety plan; (11) **Long-term**: chronic illness for some; relapse common; ongoing care + transition to adult system; (12) **Outcomes**: with comprehensive care 50% full recovery, 25% partial, 25% chronic; (13) **Multidisciplinary team**: child + adolescent psychiatry, adolescent medicine, dietitian, individual therapist, family therapist, school personnel, primary care; family-centered

---

Adolescent multiple psychiatric comorbidities = integrative + multidisciplinary + family-centered. FBT for adolescent AN. SSRI + CBT/DBT for depression + self-harm. Family therapy + school re-integration. Adolescent development considerations. Suicide risk elevated. Long-term care + transition. Multidisciplinary essential. Outcomes improve with comprehensive care.', NULL,
  'hard', 'psych_behavior', 'review',
  'psychiatry', 'integrative', 'psych_behavior', 'peds',
  'AACAP Practice Parameters; APA Eating Disorders Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_integrative'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'Adolescent อายุ 16 ปี — eating disorder (anorexia nervosa) + depression + cutting + family conflict + school refusal — multidisciplinary integrative management'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 42 ปี เคยมี depressive episode 2 ครั้งก่อนหน้านี้ (response ดีต่อ sertraline; หยุดยาเองหลัง 4 เดือน) — ขณะนี้กลับมามีอาการ depressed mood + anhedonia + insomnia + fatigue + guilt + decreased concentration + passive SI × 8 สัปดาห์

No psychotic features, no manic history
PHQ-9: 19 (severe)
TSH, B12, CBC normal
No substance use', '[{"label":"A","text":"Observation only — let it resolve"},{"label":"B","text":"Recurrent MDD, severe"},{"label":"C","text":"Stop all medications permanently"},{"label":"D","text":"Benzodiazepine monotherapy long-term"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Recurrent MDD, severe — DSM-5 ≥ 5 sx > 2 wk + functional impairment + ≥ 2 prior episodes: (1) Restart SSRI ที่เคย response (sertraline) — same agent ที่เคยใช้ได้ผล มีโอกาส response ซ้ำสูง; titrate to therapeutic dose; (2) Concurrent psychotherapy (CBT or IPT) — combination ดีกว่า monotherapy ใน recurrent/severe; (3) Maintenance phase: หลัง remission ต้อง continue ≥ 2 ปี (recurrent — 3 prior episodes = lifelong maintenance per APA); (4) Education: นี่คือ chronic recurrent illness, ห้ามหยุดยาเอง; relapse rate 50% off-medication; (5) Safety: assess SI ทุก visit; (6) Monitor side effects + adherence; measurement-based care (PHQ-9 ทุก 2-4 wk); (7) Lifestyle: exercise, sleep hygiene, social activation

---

Recurrent MDD: ≥ 2 episodes. Prior response to specific SSRI predicts re-response — restart same agent. Combination therapy (SSRI + CBT/IPT) most effective in recurrent. Maintenance phase critical — ≥ 3 episodes = often lifelong. Premature discontinuation = relapse. Measurement-based care (PHQ-9).', NULL,
  'easy', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'APA MDD Guideline 2010; CANMAT 2016', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 42 ปี เคยมี depressive episode 2 ครั้งก่อนหน้านี้ (response ดีต่อ sertraline; หยุดยาเองหลัง 4 เดือน) — ขณะนี้กลับมามีอาการ depressed mood + anhedonia + insomnia + fatigue + guilt + decreased concentration + passive SI × 8 สัปดาห์

No psychotic features, no manic history
PHQ-9: 19 (severe)
TSH, B12, CBC normal
No substance use'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 58 ปี depressed × 6 สัปดาห์ — anhedonia ที่ pervasive (ไม่มีอะไรทำให้ดีขึ้นแม้แต่ชั่วคราว) + early morning awakening 3am + diurnal variation (แย่ตอนเช้า) + 8 kg weight loss + psychomotor retardation + excessive guilt

MSE: psychomotor slow, masked affect, latency of response
No psychotic sx, no prior bipolar', '[{"label":"A","text":"Watchful waiting"},{"label":"B","text":"MDD with melancholic features (DSM-5 specifier"},{"label":"C","text":"Bupropion monotherapy"},{"label":"D","text":"Benzodiazepine only"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** MDD with melancholic features (DSM-5 specifier — loss of pleasure in all/almost all activities + lack of reactivity + ≥ 3: distinct quality of mood, worse AM, early morning awakening, marked psychomotor change, significant weight loss, excessive guilt): (1) Pharmacotherapy first-line — melancholic responds well to TCA + SNRI; SSRI also effective แต่ severe melancholic อาจ response ต่ำกว่า; consider venlafaxine, duloxetine, nortriptyline; (2) ECT highly effective for severe melancholic/psychomotor retardation — consider early ถ้า severe, suicidal, food/fluid refusal, ก่อนหน้า ECT response; (3) Augmentation: lithium, T3, atypical antipsychotic; (4) Psychotherapy adjunctive (severe melancholic อาจ respond ต่อ medication ดีกว่า psychotherapy alone); (5) Safety: suicide risk high (severe + guilt + hopelessness); (6) Monitor weight, nutrition, hydration

---

Melancholic MDD specifier: severe biological depression — TCA/SNRI/ECT particularly effective. Suicide risk high. ECT consideration early for severe/refractory/suicidal.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'APA MDD Guideline; Parker Melancholia', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 58 ปี depressed × 6 สัปดาห์ — anhedonia ที่ pervasive (ไม่มีอะไรทำให้ดีขึ้นแม้แต่ชั่วคราว) + early morning awakening 3am + diurnal variation (แย่ตอนเช้า) + 8 kg weight loss + psychomotor retardation + excessive guilt

MSE: psychomotor slow, masked affect, latency of response
No psychotic sx, no prior bipolar'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 26 ปี depressed × 4 เดือน — mood improves with positive events (mood reactivity), hypersomnia (sleep 12h), hyperphagia (น้ำหนักขึ้น 6kg), leaden paralysis (heavy limbs), long-standing interpersonal rejection sensitivity

PHQ-9: 16', '[{"label":"A","text":"No treatment"},{"label":"B","text":"MDD with atypical features (DSM-5"},{"label":"C","text":"TCA only"},{"label":"D","text":"Antipsychotic monotherapy"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** MDD with atypical features (DSM-5: mood reactivity + ≥ 2 of: weight gain/↑appetite, hypersomnia, leaden paralysis, interpersonal rejection sensitivity): (1) SSRI first-line (modern data — historical MAOI preference largely superseded); sertraline, fluoxetine, escitalopram; (2) MAOI (phenelzine) classic effective สำหรับ atypical แต่ side effects + diet restrictions; reserve for refractory; (3) CBT, IPT — effective adjunct/alternative; (4) Bupropion อาจช่วย hypersomnia + weight (activating); (5) Lifestyle: structured sleep, exercise, light therapy ถ้า seasonal component; (6) Address interpersonal rejection sensitivity — overlap กับ borderline traits, evaluate; (7) Comorbidity: anxiety + somatic symptoms common

---

Atypical MDD: mood reactivity + reverse vegetative (hypersomnia, hyperphagia) + leaden paralysis + rejection sensitivity. Historically MAOI > TCA; modern SSRI first-line. Bupropion can help with sedation/weight.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'DSM-5-TR; Stewart Atypical Depression', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 26 ปี depressed × 4 เดือน — mood improves with positive events (mood reactivity), hypersomnia (sleep 12h), hyperphagia (น้ำหนักขึ้น 6kg), leaden paralysis (heavy limbs), long-standing interpersonal rejection sensitivity

PHQ-9: 16'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 65 ปี severe depressed × 3 เดือน + recent onset — เชื่อว่าตัวเองทำบาปร้ายแรงที่ทำให้ทั้งครอบครัวจะถูกลงโทษ (mood-congruent guilt delusion), บางครั้งได้ยินเสียงด่าตัวเอง, ปฏิเสธอาหาร 5 วัน (กลัวเป็นบาปกิน), น้ำหนักลด 7kg, immobile/mute บางช่วง

No prior psychotic disorder, no substance use, MMSE 26/30
Lab: Na 138, BUN 28 (mild dehydration), Cr 1.0', '[{"label":"A","text":"SSRI monotherapy"},{"label":"B","text":"MDD with psychotic features (DSM-5 specifier; severe + mood-congruent delusions/hallucinations)"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Watchful waiting"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** MDD with psychotic features (DSM-5 specifier; severe + mood-congruent delusions/hallucinations) — high acuity: (1) Admit — food refusal + dehydration + psychotic risk; (2) Treatment: antidepressant + antipsychotic combination (SSRI/SNRI + atypical antipsychotic เช่น olanzapine, quetiapine, aripiprazole) — combination superior to either monotherapy (STOP-PD trial); (3) ECT first-line consideration — highly effective for psychotic depression (response rate 80-90%), faster than medication, lifesaving in food refusal/severe SI/catatonic features; (4) IV hydration + nutrition support (NG ถ้าจำเป็น); (5) Safety: suicide risk very high (psychotic depression × 5 risk); 1:1 observation; (6) Avoid antidepressant monotherapy (less effective + may worsen); (7) Maintenance: continue both medications post-remission; relapse risk high; (8) Multidisciplinary: psychiatry, internal medicine, nursing

---

Psychotic MDD: severe depression + mood-congruent (or incongruent) psychotic features. ECT first-line (response 80-90%). Pharmacological: antidepressant + antipsychotic combination (STOP-PD). Avoid monotherapy. Suicide risk × 5. Admit for safety + medical stabilization.', NULL,
  'hard', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'STOP-PD trial; APA MDD Guideline; Rothschild Psychotic Depression', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ชายไทยอายุ 65 ปี severe depressed × 3 เดือน + recent onset — เชื่อว่าตัวเองทำบาปร้ายแรงที่ทำให้ทั้งครอบครัวจะถูกลงโทษ (mood-congruent guilt delusion), บางครั้งได้ยินเสียงด่าตัวเอง, ปฏิเสธอาหาร 5 วัน (กลัวเป็นบาปกิน), น้ำหนักลด 7kg, immobile/mute บางช่วง

No prior psychotic disorder, no substance use, MMSE 26/30
Lab: Na 138, BUN 28 (mild dehydration), Cr 1.0'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 52 ปี severe MDD × 18 เดือน — failed adequate trials (≥ 6 wk at therapeutic dose) ของ sertraline, venlafaxine, bupropion, mirtazapine; CBT × 16 sessions; lithium + T3 augmentation; ขณะนี้ severely depressed, weight loss 10kg, active SI with plan

No psychotic features, no substance use
Medical workup: stable, no contraindications
Family ขอ recommendations', '[{"label":"A","text":"Continue same regimen"},{"label":"B","text":"Treatment-Resistant Depression (TRD"},{"label":"C","text":"Discharge home with outpatient follow-up"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Treatment-Resistant Depression (TRD — failure ≥ 2 adequate trials) — ECT indicated: (1) ECT first-line สำหรับ TRD + severe depression + active SI — most effective antidepressant (response 60-80% TRD; > 80% psychotic depression); (2) Indications: severe MDD, suicidal, catatonic, psychotic, food refusal, prior ECT response, pregnancy (safe); (3) Procedure: bilateral or right unilateral high-dose; brief-pulse; 6-12 treatments acute course (3×/wk); muscle relaxant (succinylcholine) + brief anesthesia (methohexital); seizure 25-60 sec induced; (4) Side effects: transient cognitive (anterograde + retrograde amnesia — right unilateral less); headache, myalgia; no significant long-term cognitive deficit in most; (5) Contraindications relative: increased ICP, recent MI/stroke (consult cardiology/neurology); (6) Continuation/maintenance ECT prevents relapse; concurrent maintenance medication; (7) Alternatives ถ้า ECT not feasible: ketamine/esketamine IV/IN (rapid onset, FDA approved esketamine), TMS (less invasive, less effective for severe), psilocybin (research); (8) Multidisciplinary: psychiatry, anesthesia, nursing, family education (reduce stigma)

---

Treatment-Resistant Depression (TRD): failure ≥ 2 adequate trials. ECT most effective antidepressant — response 60-80% TRD. Indications: severe, suicidal, psychotic, catatonic, food refusal. Cognitive side effects transient. Continuation/maintenance ECT + medication prevents relapse. Alternatives: ketamine/esketamine, TMS.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'APA Task Force ECT 2001; ISEN; STAR*D', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 52 ปี severe MDD × 18 เดือน — failed adequate trials (≥ 6 wk at therapeutic dose) ของ sertraline, venlafaxine, bupropion, mirtazapine; CBT × 16 sessions; lithium + T3 augmentation; ขณะนี้ severely depressed, weight loss 10kg, active SI with plan

No psychotic features, no substance use
Medical workup: stable, no contraindications
Family ขอ recommendations'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 45 ปี TRD — failed 4 antidepressants + augmentation + CBT; ECT ผู้ป่วยปฏิเสธ; ขณะนี้ severe SI ไม่มี plan, urgent need สำหรับ rapid intervention

No psychotic features, no substance use, no cardiovascular contraindications
BP 128/78', '[{"label":"A","text":"Continue failed agents"},{"label":"B","text":"Esketamine (intranasal) + oral antidepressant"},{"label":"C","text":"Stop all treatment"},{"label":"D","text":"Surgery"},{"label":"E","text":"Hospice"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Esketamine (intranasal) + oral antidepressant — FDA approved 2019 TRD + 2020 MDD with acute SI: (1) Mechanism: NMDA receptor antagonist → rapid synaptic plasticity, BDNF; effect within hours-days (vs weeks for SSRI); (2) Dosing: esketamine intranasal 56-84mg twice weekly × 4 wk induction, then weekly/biweekly maintenance; concurrent oral antidepressant required; (3) REMS program — administer in healthcare setting + observation 2h post (dissociation, BP elevation, sedation); cannot drive same day; (4) Side effects: dissociation (transient), BP increase (monitor), sedation, dizziness, nausea, urinary issues with chronic use; abuse potential — controlled substance; (5) Racemic ketamine IV (off-label) — similar mechanism, used in clinical practice + research; lower cost; less regulated; (6) Contraindications: aneurysm, AVM, intracerebral hemorrhage, hypertensive emergency, history of psychosis; (7) Combination with antidepressant + psychotherapy; (8) Long-term safety data evolving — limit duration when possible; (9) Multidisciplinary: psychiatry, nursing, ongoing antidepressant management

---

Esketamine (intranasal) — FDA approved 2019 TRD, 2020 acute SI. Rapid onset (hours-days). NMDA antagonist. Requires REMS program (in-clinic + 2h observation). Must combine with oral antidepressant. Side effects: dissociation, BP, abuse potential. Racemic IV ketamine off-label alternative.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'FDA esketamine approval; Daly et al. JAMA Psych 2018', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ชายไทยอายุ 45 ปี TRD — failed 4 antidepressants + augmentation + CBT; ECT ผู้ป่วยปฏิเสธ; ขณะนี้ severe SI ไม่มี plan, urgent need สำหรับ rapid intervention

No psychotic features, no substance use, no cardiovascular contraindications
BP 128/78'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 38 ปี moderate MDD × 1 ปี — failed 2 SSRI trials adequate dose/duration + CBT × 12 sessions; ผู้ป่วยกังวล side effects ของ medication เพิ่ม, ไม่ต้องการ ECT; ทำงานเต็มเวลา, ต้องการ outpatient option

No seizure history, no metallic implant in head, no recent MI', '[{"label":"A","text":"Continue failed treatment"},{"label":"B","text":"Repetitive Transcranial Magnetic Stimulation (rTMS)"},{"label":"C","text":"ECT only"},{"label":"D","text":"No further treatment"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Repetitive Transcranial Magnetic Stimulation (rTMS) — FDA approved 2008 TRD: (1) Mechanism: magnetic field induces electric current in left dorsolateral prefrontal cortex → modulate mood circuits; (2) Protocol: typically 5×/wk × 4-6 wk (20-30 sessions); each ~ 20-40 min; outpatient; no anesthesia; (3) Stimulation: high-frequency (10 Hz) left DLPFC excitatory; low-frequency right DLPFC inhibitory; iTBS (intermittent theta burst) accelerated protocol — 3 min sessions; (4) Response rate 30-40% TRD; remission 20-30%; less effective than ECT but better tolerated; (5) Side effects: scalp discomfort, headache (transient), rare seizure (0.1%); contraindications — seizure disorder, metallic head implants (cochlear, deep brain stimulator), recent MI; (6) Combine กับ antidepressant; (7) Maintenance protocols emerging; (8) Indications expanding: OCD (FDA approved 2018), smoking cessation, anxiety; (9) Advantages: no anesthesia, no cognitive side effects, continue daily activities; (10) Multidisciplinary: psychiatry, technician

---

rTMS: FDA approved 2008 TRD. Left DLPFC stimulation. Outpatient, no anesthesia, 4-6 wk. Response 30-40%, less than ECT but better tolerated. Side effects: scalp discomfort, rare seizure. Contraindications: seizure, metallic head implants. iTBS accelerated. Expanding indications (OCD).', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'FDA TMS approval; O''Reardon Biol Psychiatry 2007', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 38 ปี moderate MDD × 1 ปี — failed 2 SSRI trials adequate dose/duration + CBT × 12 sessions; ผู้ป่วยกังวล side effects ของ medication เพิ่ม, ไม่ต้องการ ECT; ทำงานเต็มเวลา, ต้องการ outpatient option

No seizure history, no metallic implant in head, no recent MI'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 29 ปี recurrent depressive episodes × 5 ปี — ก่อนหน้านี้รักษาด้วย SSRI หลายตัว; mother reports periods of '' more energy, productive, less sleep, sociable, talkative'' lasting 5-7 วัน × 3-4 ครั้งต่อปี — มี subjective feeling of being ''high'' but not impaired functionally

No hospitalization, no psychosis
No manic episodes met full criteria
DSM-5 hypomania criteria met (≥ 4 days, observable change)', '[{"label":"A","text":"SSRI monotherapy"},{"label":"B","text":"Bipolar II Disorder (DSM-5"},{"label":"C","text":"No treatment"},{"label":"D","text":"Antibiotic"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bipolar II Disorder (DSM-5: ≥ 1 hypomanic + ≥ 1 MDD episode; never met manic episode criteria): (1) Mood stabilizer first-line — lithium (effective + reduces suicide), lamotrigine (excellent for bipolar depression — first-line BP-II depression — slow titration to avoid SJS), quetiapine (FDA approved BP depression), lurasidone (FDA approved); (2) Avoid antidepressant monotherapy — risk of cycle acceleration + manic switch; ถ้าจำเป็น combine กับ mood stabilizer; (3) Acute hypomanic episode: usually no hospitalization; mood stabilizer + temporary sleep aid; (4) Depression dominates clinical picture ใน BP-II — focus on bipolar depression treatment; (5) Psychotherapy: CBT, IPSRT (sleep + social rhythm), family-focused; (6) Long-term maintenance essential; (7) Comorbidity: anxiety (40-50%), substance use, ADHD; (8) Suicide risk high (similar to BP-I); (9) Psychoeducation: recognize prodromes, sleep regulation, avoid triggers; (10) Pregnancy planning + medication management

---

Bipolar II: ≥ 1 hypomania (4 days, observable, non-impairing/hospitalizing) + ≥ 1 MDD. Mood stabilizer first-line — lamotrigine for BP depression, lithium, quetiapine, lurasidone. Avoid antidepressant monotherapy. Depression dominates. Long-term maintenance. Suicide risk high.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'CANMAT/ISBD 2018; APA Bipolar', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 29 ปี recurrent depressive episodes × 5 ปี — ก่อนหน้านี้รักษาด้วย SSRI หลายตัว; mother reports periods of '' more energy, productive, less sleep, sociable, talkative'' lasting 5-7 วัน × 3-4 ครั้งต่อปี — มี subjective feeling of being ''high'' but not impaired functionally

No hospitalization, no psychosis
No manic episodes met full criteria
DSM-5 hypomania criteria met (≥ 4 days, observable change)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 35 ปี BP-I on lithium 900 mg/day × 5 ปี (stable) — เริ่มมี recent diarrhea + nausea × 3 วัน + tremor + ataxia + confusion + slurred speech

ก่อนหน้านี้ 2 สัปดาห์เริ่ม HCTZ for hypertension
V/S: BP 100/65, HR 100, mildly dehydrated
Lab: Na 135, K 3.4, Cr 1.5 (baseline 0.8), lithium level 2.4 mEq/L (therapeutic 0.6-1.2)
ECG: U waves, prolonged QT', '[{"label":"A","text":"Continue lithium"},{"label":"B","text":"Lithium Toxicity (Severe"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Lithium Toxicity (Severe — level > 2.0, neurological signs) — EMERGENCY: (1) Discontinue lithium immediately + thiazide diuretic (HCTZ → reduced renal clearance → toxicity); (2) IV fluid resuscitation — normal saline aggressive (restore volume + renal perfusion + enhance excretion); avoid loop diuretics + further dehydration; (3) Hemodialysis indicated: - level > 4.0 regardless symptoms; - level > 2.5 + severe symptoms; - level > 2.5 + renal failure preventing clearance; - life-threatening symptoms; (4) Cardiac monitoring (arrhythmia, QT); neuro monitoring; (5) Avoid concomitant nephrotoxic + drugs that ↓ clearance (NSAIDs, ACE-I, ARB, thiazide); (6) Education: lithium narrow therapeutic index; dehydration, diet sodium, drug interactions, NSAID/ACE-I/thiazide; recognize early signs (tremor, GI, ataxia); (7) Once recovered, reassess maintenance — alternative mood stabilizer if recurrent toxicity; (8) Long-term effects: chronic toxicity → nephrogenic DI, CKD, hypothyroid, hyperparathyroid — monitor Cr, TSH, Ca; (9) Multidisciplinary: psychiatry, nephrology, ICU if severe

---

Lithium toxicity: narrow therapeutic index. Triggers: dehydration, diuretic (thiazide ↓ clearance), NSAID, ACE-I, low sodium. Manifest: GI + neuro (tremor → ataxia → confusion → seizure → coma). Treatment: stop lithium, IV saline, hemodialysis (level > 4.0 or severe). Monitor long-term renal, thyroid, parathyroid.', NULL,
  'hard', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'AACT Position Paper; Timmer Clin Pharmacokinet', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 35 ปี BP-I on lithium 900 mg/day × 5 ปี (stable) — เริ่มมี recent diarrhea + nausea × 3 วัน + tremor + ataxia + confusion + slurred speech

ก่อนหน้านี้ 2 สัปดาห์เริ่ม HCTZ for hypertension
V/S: BP 100/65, HR 100, mildly dehydrated
Lab: Na 135, K 3.4, Cr 1.5 (baseline 0.8), lithium level 2.4 mEq/L (therapeutic 0.6-1.2)
ECG: U waves, prolonged QT'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 30 ปี BP-I, ขณะนี้ depressed episode × 6 wk — but also มี racing thoughts, distractibility, decreased sleep need (but feel fatigued), agitation, irritability, suicidal ideation

MSE: dysphoric mood + psychomotor agitation + flight of ideas + irritability
Meets DSM-5 criteria for MDD episode + ≥ 3 manic sx — Mixed Features specifier', '[{"label":"A","text":"SSRI monotherapy"},{"label":"B","text":"MDD/BP Depression with Mixed Features (DSM-5"},{"label":"C","text":"Stimulant"},{"label":"D","text":"Discharge"},{"label":"E","text":"Observation"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** MDD/BP Depression with Mixed Features (DSM-5: full episode of one pole + ≥ 3 sx opposite pole — high acuity): (1) Avoid antidepressant monotherapy — high risk of switching, cycle acceleration, suicide; (2) First-line: atypical antipsychotic with mixed features evidence — lurasidone (FDA approved BP depression including mixed), quetiapine, olanzapine; (3) Mood stabilizer — valproate, lithium (less data mixed than pure mania); lamotrigine may help; (4) Combination — mood stabilizer + atypical; (5) Safety: suicide risk very high (mixed features = highest suicide risk in mood disorders) — assess + hospitalize ถ้า needed; (6) Avoid stimulants; (7) Limit benzodiazepine to acute agitation; (8) Psychotherapy: CBT, IPSRT, family-focused; (9) ECT effective for severe mixed; (10) Comorbid substance use common; (11) Long-term: chronic course, frequent recurrences, maintenance essential

---

Mixed features specifier: full episode + ≥ 3 sx opposite pole. Highest suicide risk in mood disorders. AVOID antidepressant monotherapy. Atypical antipsychotic (lurasidone) + mood stabilizer. ECT for severe.', NULL,
  'hard', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'CANMAT/ISBD 2018; DSM-5-TR', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ชายไทยอายุ 30 ปี BP-I, ขณะนี้ depressed episode × 6 wk — but also มี racing thoughts, distractibility, decreased sleep need (but feel fatigued), agitation, irritability, suicidal ideation

MSE: dysphoric mood + psychomotor agitation + flight of ideas + irritability
Meets DSM-5 criteria for MDD episode + ≥ 3 manic sx — Mixed Features specifier'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 25 ปี × 3 ปี has had numerous periods of mild hypomanic-like symptoms (elevated mood, decreased sleep need, increased activity 3-4 วัน) สลับกับ mild depressive symptoms (low mood, fatigue, decreased interest 1-2 weeks) — no period of stability > 2 months

No episode meets full hypomania or MDD criteria
Functional impairment present
No substance use, normal TSH', '[{"label":"A","text":"SSRI monotherapy"},{"label":"B","text":"Cyclothymic Disorder (DSM-5"},{"label":"C","text":"No treatment"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cyclothymic Disorder (DSM-5: numerous hypomanic + depressive sx that don''t meet full criteria × ≥ 2 yr adults, ≥ 1 yr youth; no symptom-free period > 2 mo): (1) Mood stabilizer — lithium, valproate, lamotrigine; lower doses than BP-I อาจเพียงพอ; (2) Limited evidence base — extrapolated from BP-I/II; (3) Psychotherapy: CBT, IPSRT, psychoeducation — emphasize sleep + social rhythm regularity; (4) Avoid antidepressant monotherapy — switch risk + worsen cycling; (5) Long-term — 15-50% progress to full BP-I/II; monitor; (6) Comorbidity: substance use, anxiety, personality features; (7) Lifestyle: sleep regularity, avoid sleep deprivation/circadian disruption, limit substances, structured routine; (8) Education + family support

---

Cyclothymic Disorder: chronic mood instability × ≥ 2 yr (1 yr youth); subsyndromal hypomania + depression. Mood stabilizer (lithium, valproate, lamotrigine). Avoid antidepressant monotherapy. 15-50% progress to full BP. Psychoeducation + social rhythm.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'CANMAT/ISBD 2018; DSM-5-TR', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ชายไทยอายุ 25 ปี × 3 ปี has had numerous periods of mild hypomanic-like symptoms (elevated mood, decreased sleep need, increased activity 3-4 วัน) สลับกับ mild depressive symptoms (low mood, fatigue, decreased interest 1-2 weeks) — no period of stability > 2 months

No episode meets full hypomania or MDD criteria
Functional impairment present
No substance use, normal TSH'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 40 ปี — depressed mood '' most of the day, more days than not'' × 4 ปี — fatigue, low self-esteem, poor concentration, hopelessness, hyperphagia, low energy; functional but suboptimal

No discrete MDD episode meeting criteria
No hypomania/mania
PHQ-9: 12 (moderate)
No substance use', '[{"label":"A","text":"Brief course only"},{"label":"B","text":"Persistent Depressive Disorder (Dysthymia; DSM-5"},{"label":"C","text":"No treatment needed"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Persistent Depressive Disorder (Dysthymia; DSM-5: depressed mood most days × ≥ 2 yr + ≥ 2: appetite, sleep, energy, self-esteem, concentration, hopelessness): (1) Combination treatment best — psychotherapy + antidepressant > monotherapy (CBASP — Cognitive Behavioral Analysis System of Psychotherapy ออกแบบเฉพาะ chronic depression); (2) Antidepressant: SSRI first-line; SNRI, bupropion, mirtazapine alternatives; ตอบสนองช้ากว่า MDD episodic; (3) Psychotherapy: CBASP, CBT, IPT, psychodynamic; (4) Treatment duration extended — chronic course requires ongoing maintenance; (5) Address chronic interpersonal patterns + low self-esteem; (6) Comorbidity: MDD episodes superimposed (''double depression''), anxiety, personality disorders; (7) Lifestyle: exercise, sleep, social engagement; (8) Long-term outcomes: 50-70% improve with sustained treatment; without treatment chronic + impairing

---

Persistent Depressive Disorder (formerly dysthymia + chronic MDD): ≥ 2 yr depressed mood + 2 sx. Combination therapy best — CBASP designed for chronic depression. Long-term maintenance. Double depression common.', NULL,
  'easy', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'DSM-5-TR; CBASP McCullough', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 40 ปี — depressed mood '' most of the day, more days than not'' × 4 ปี — fatigue, low self-esteem, poor concentration, hopelessness, hyperphagia, low energy; functional but suboptimal

No discrete MDD episode meeting criteria
No hypomania/mania
PHQ-9: 12 (moderate)
No substance use'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 32 ปี × 12 เดือน — severe mood symptoms (irritability, anger, mood lability, depression, anxiety) เริ่ม 7-10 วันก่อนประจำเดือน + หาย 1-3 วันหลังเริ่มประจำเดือน — disrupts work + relationships

Prospective daily mood charting × 3 cycles confirms cyclic pattern
No other psychiatric disorder, no medical cause', '[{"label":"A","text":"No treatment"},{"label":"B","text":"Premenstrual Dysphoric Disorder (PMDD; DSM-5"},{"label":"C","text":"Lithium only"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Premenstrual Dysphoric Disorder (PMDD; DSM-5: severe luteal phase mood + behavioral symptoms × most cycles past year, confirmed prospectively, functional impairment): (1) SSRI first-line — fluoxetine, sertraline, paroxetine, escitalopram; FDA approved; (2) Dosing options: - continuous daily; - luteal phase only (14 days before menses to onset of menses) — works for PMDD because rapid onset on serotonin system; - symptom-onset only (start when sx begin); (3) Oral contraceptive containing drospirenone (Yaz) — FDA approved PMDD; alternatives — continuous OCP suppress cycle; (4) GnRH agonist (severe refractory) with add-back hormonal therapy; (5) CBT + lifestyle (exercise, stress reduction, sleep, limit caffeine + alcohol, calcium supplementation moderate evidence); (6) Avoid: alprazolam (limited evidence + dependence risk); diuretics for bloating only; (7) Multidisciplinary: psychiatry, OB-GYN, primary care; (8) Distinguish from premenstrual syndrome (PMS — milder) + premenstrual exacerbation of underlying disorder

---

PMDD: severe luteal-phase mood + behavioral sx + impairment, confirmed prospectively. SSRI first-line (rapid onset luteal). Drospirenone OCP FDA approved. CBT + lifestyle. Distinguish from PMS + premenstrual exacerbation.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'DSM-5-TR; ACOG; ISPMD', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 32 ปี × 12 เดือน — severe mood symptoms (irritability, anger, mood lability, depression, anxiety) เริ่ม 7-10 วันก่อนประจำเดือน + หาย 1-3 วันหลังเริ่มประจำเดือน — disrupts work + relationships

Prospective daily mood charting × 3 cycles confirms cyclic pattern
No other psychiatric disorder, no medical cause'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 9 ปี — severe recurrent temper outbursts (verbal + physical), out of proportion to provocation, ≥ 3×/wk × 18 เดือน + persistent irritable/angry mood between outbursts (''grumpy all the time'') — at home + school + with peers

Onset age 7 ปี
Developmental hx normal, no trauma history
No manic/hypomanic episodes — irritability is chronic, not episodic', '[{"label":"A","text":"Mood stabilizer (lithium/valproate) first-line"},{"label":"B","text":"Disruptive Mood Dysregulation Disorder (DMDD; DSM-5"},{"label":"C","text":"No treatment"},{"label":"D","text":"Punishment focus"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Disruptive Mood Dysregulation Disorder (DMDD; DSM-5: severe recurrent temper outbursts ≥ 3×/wk + persistent irritable mood between outbursts × ≥ 12 mo, in ≥ 2 settings, onset 6-10 yo, dx 6-18 yo — to avoid overdiagnosis of pediatric bipolar): (1) Parent training in behavior management — first-line for irritability + outbursts; (2) CBT — emotion regulation, problem-solving, anger management; DBT for adolescents adapted; (3) Family therapy + family education; (4) School-based intervention + IEP/504; (5) Medication when severe + functional impairment + behavioral failed: - Stimulants for comorbid ADHD (very common); - SSRI for comorbid depression/anxiety; - Atypical antipsychotic (risperidone, aripiprazole) for severe aggression (last-line, side effects monitoring); - Avoid mood stabilizers without bipolar diagnosis; (6) Comorbidity common: ADHD, ODD, anxiety, depression; (7) Long-term: DMDD predicts adult depression + anxiety (NOT bipolar — important distinction from prior ''pediatric bipolar'' overdiagnosis); (8) Multidisciplinary: child psychiatry, behavioral therapist, school personnel, family

---

DMDD: chronic irritability + severe temper outbursts in children — DSM-5 added to prevent overdiagnosis pediatric bipolar. Behavioral parent training + CBT first-line. SSRI/stimulants for comorbidity. NOT bipolar — predicts adult depression/anxiety.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'peds',
  'DSM-5-TR; Leibenluft DMDD', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'เด็กชายอายุ 9 ปี — severe recurrent temper outbursts (verbal + physical), out of proportion to provocation, ≥ 3×/wk × 18 เดือน + persistent irritable/angry mood between outbursts (''grumpy all the time'') — at home + school + with peers

Onset age 7 ปี
Developmental hx normal, no trauma history
No manic/hypomanic episodes — irritability is chronic, not episodic'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 35 ปี ย้ายไป Sweden ทำงาน — recurrent depressive episodes ในฤดูหนาว (Oct-March) × 3 ปี ติดต่อกัน, full remission ฤดูร้อน; hypersomnia, hyperphagia (carbohydrate craving), weight gain, low energy

ก่อนย้ายไม่มี depression
ไม่มี non-seasonal episodes', '[{"label":"A","text":"No treatment — wait for spring"},{"label":"B","text":"Seasonal Affective Disorder (MDD with seasonal pattern; DSM-5 specifier"},{"label":"C","text":"TCA only"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Seasonal Affective Disorder (MDD with seasonal pattern; DSM-5 specifier — temporal relationship × ≥ 2 yr): (1) Bright Light Therapy — first-line: - 10,000 lux × 30 min, morning, daily; - 2,500 lux × 2 hr alternative; - start fall, continue through winter; effect within 1-2 wk; - side effects: eye strain, headache, agitation/hypomania risk in BP; (2) SSRI — fluoxetine FDA approved seasonal; sertraline, escitalopram alternatives; (3) Bupropion XL — FDA approved prevention SAD; start before season; (4) CBT-SAD — specifically adapted; effective + prevents recurrence; (5) Combination — light + medication for severe; (6) Lifestyle: morning outdoor light exposure, exercise, sleep hygiene, vitamin D supplementation moderate evidence; (7) Bipolar specifier — seasonal pattern in BP common — careful with light + antidepressant (switch risk); (8) Prevention: start treatment before symptom onset (autumn); (9) Atypical features common (hypersomnia, hyperphagia); (10) Subsyndromal ''winter blues'' more common than full SAD

---

Seasonal Affective Disorder: MDD with seasonal pattern × ≥ 2 yr. Bright light therapy (10,000 lux × 30 min AM) first-line. Bupropion XL FDA approved prevention. SSRI also. CBT-SAD effective. Start before season. Bipolar caution (switch).', NULL,
  'easy', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'Rosenthal SAD; APA MDD Guideline', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 35 ปี ย้ายไป Sweden ทำงาน — recurrent depressive episodes ในฤดูหนาว (Oct-March) × 3 ปี ติดต่อกัน, full remission ฤดูร้อน; hypersomnia, hyperphagia (carbohydrate craving), weight gain, low energy

ก่อนย้ายไม่มี depression
ไม่มี non-seasonal episodes'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 40 ปี — excessive worry about multiple domains (family, work, finances, health) × 8 เดือน — difficult to control + restlessness, fatigue, difficulty concentrating, irritability, muscle tension, sleep disturbance

GAD-7: 16 (severe)
No panic attacks, no specific phobia
Medical workup negative
No substance use, no caffeine excess', '[{"label":"A","text":"Long-term benzodiazepine monotherapy"},{"label":"B","text":"Generalized Anxiety Disorder (DSM-5"},{"label":"C","text":"No treatment"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Generalized Anxiety Disorder (DSM-5: excessive worry ≥ 6 mo + ≥ 3 sx + impairment): (1) CBT first-line — effective, durable, cognitive restructuring + exposure to uncertainty + relaxation + behavioral activation; (2) Medication first-line — SSRI (escitalopram, sertraline, paroxetine) or SNRI (venlafaxine XR, duloxetine); start low + titrate; full effect 4-6 wk; (3) Buspirone — alternative, no abuse potential, slower onset; (4) Pregabalin — effective + faster onset (Europe approved); (5) Avoid benzodiazepines long-term (tolerance, dependence, cognitive); short-term bridging acceptable; (6) Combination CBT + medication for moderate-severe; (7) Lifestyle: caffeine reduction, exercise, sleep hygiene, mindfulness, limit alcohol; (8) Comorbidity common: depression (60%), other anxiety, substance use; (9) Long-term — chronic illness; relapse common when treatment stopped; continue ≥ 12 mo after remission; (10) Multidisciplinary: primary care, psychiatry, therapist

---

GAD: excessive worry ≥ 6 mo + ≥ 3 sx. CBT + SSRI/SNRI first-line. Buspirone alternative. AVOID long-term benzodiazepine. Combination most effective. Chronic course — long-term treatment.', NULL,
  'easy', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'NICE CG113; APA Anxiety', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 40 ปี — excessive worry about multiple domains (family, work, finances, health) × 8 เดือน — difficult to control + restlessness, fatigue, difficulty concentrating, irritability, muscle tension, sleep disturbance

GAD-7: 16 (severe)
No panic attacks, no specific phobia
Medical workup negative
No substance use, no caffeine excess'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 24 ปี — intense fear of social situations + scrutiny × 6 ปี — avoidance of public speaking, meeting new people, eating in public; physical sx (blushing, sweating, trembling); impairs career advancement; ดื่ม alcohol ก่อน social events เพื่อช่วย

LSAS score 85 (severe)
No psychotic features, recognizes fear excessive
UDS negative drugs', '[{"label":"A","text":"Avoid all social activity"},{"label":"B","text":"Social Anxiety Disorder (DSM-5"},{"label":"C","text":"Long-term benzodiazepine monotherapy"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Social Anxiety Disorder (DSM-5: marked fear of social situations + avoidance + > 6 mo + impairment): (1) CBT with exposure first-line — graded exposure to feared social situations + cognitive restructuring; group CBT particularly effective (provides exposure); (2) SSRI first-line medication (paroxetine, sertraline, escitalopram, fluvoxamine — FDA approved); SNRI alternative (venlafaxine); (3) Combination CBT + SSRI for severe + chronic; (4) Performance-only subtype: beta-blocker (propranolol 10-40mg) PRN before performance — blocks autonomic sx; or short-acting benzodiazepine PRN (limited use, abuse potential); (5) Address alcohol use — self-medication common, AUD comorbidity high — treat both; (6) Avoid benzodiazepine long-term; (7) Long-term: chronic without treatment, often onset adolescence; (8) Comorbidity: depression, other anxiety, AUD; (9) Subtypes: generalized (more impairing) vs performance-only; (10) Multidisciplinary

---

Social Anxiety: marked fear of scrutiny > 6 mo. CBT with exposure + SSRI first-line. Beta-blocker PRN for performance subtype. Address comorbid AUD (common self-medication). AVOID long-term benzodiazepine.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'NICE CG159; Heimberg CBT', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ชายไทยอายุ 24 ปี — intense fear of social situations + scrutiny × 6 ปี — avoidance of public speaking, meeting new people, eating in public; physical sx (blushing, sweating, trembling); impairs career advancement; ดื่ม alcohol ก่อน social events เพื่อช่วย

LSAS score 85 (severe)
No psychotic features, recognizes fear excessive
UDS negative drugs'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 28 ปี กลัวการเจาะเลือด/เข็มฉีดยา ตั้งแต่เด็ก — บริจาคเลือดไม่ได้, หลีกเลี่ยง medical care, เคยเป็นลม (vasovagal) เมื่อเห็นเลือด; ตอนนี้ตั้งครรภ์ + ต้อง prenatal blood draws

MSE: alert, oriented, no other psychiatric symptoms
Functional in other areas', '[{"label":"A","text":"Avoid all procedures"},{"label":"B","text":"Specific Phobia, Blood-Injection-Injury Type (DSM-5"},{"label":"C","text":"Long-term benzodiazepine"},{"label":"D","text":"Surgery"},{"label":"E","text":"No treatment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Specific Phobia, Blood-Injection-Injury Type (DSM-5: marked fear of specific stimulus + avoidance + > 6 mo + impairment): (1) Exposure therapy first-line — gold standard, durable; graded exposure to feared stimulus (e.g., needles in this case) + virtual reality emerging; single-session exposure can be effective; (2) Blood-Injection-Injury subtype unique — biphasic vasovagal response (initial sympathetic then drop → syncope); (3) Applied Tension Technique — specific to BII phobia: tense muscles → maintain BP → prevent syncope during exposure/procedure; (4) Cognitive restructuring + relaxation adjunct; (5) Medication usually NOT first-line for specific phobia — limited evidence; benzodiazepine for procedure if exposure not feasible (one-time); SSRI for severe/comorbid; (6) Pregnancy considerations — needs prenatal care; coordinate with OB + exposure therapist; (7) Self-help + apps for mild; (8) Multidisciplinary if comorbidity

---

Specific Phobia: exposure therapy first-line. BII subtype: biphasic vasovagal — use Applied Tension Technique (tense muscles → maintain BP). Single-session exposure effective. Medication limited role. Pregnancy needs coordinated care.', NULL,
  'easy', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'Öst Applied Tension; DSM-5-TR', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 28 ปี กลัวการเจาะเลือด/เข็มฉีดยา ตั้งแต่เด็ก — บริจาคเลือดไม่ได้, หลีกเลี่ยง medical care, เคยเป็นลม (vasovagal) เมื่อเห็นเลือด; ตอนนี้ตั้งครรภ์ + ต้อง prenatal blood draws

MSE: alert, oriented, no other psychiatric symptoms
Functional in other areas'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 7 ปี เริ่มไม่ยอมไปโรงเรียน × 3 เดือน — กลัวว่า mother จะหายไปหรือมีอันตราย, ฝันร้าย, somatic complaints (stomach ache, headache) ทุกเช้าก่อนไป รร., refuses sleepover, ติดแม่ตลอด, attended school normally ก่อนหน้านี้

No trauma, no recent separation
Developmental hx normal, school performance was good', '[{"label":"A","text":"Permanent home schooling"},{"label":"B","text":"Separation Anxiety Disorder (DSM-5"},{"label":"C","text":"Adult-style benzodiazepine"},{"label":"D","text":"Surgery"},{"label":"E","text":"Punishment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Separation Anxiety Disorder (DSM-5 — moved from peds-only to applies all ages; ≥ 4 wk children, ≥ 6 mo adults): (1) CBT for childhood anxiety first-line — Coping Cat program, parent involvement, exposure to graded separations; (2) Parent training — reduce accommodation behaviors (parents'' avoidance reinforces); reward brave behaviors; (3) School re-entry plan — gradual return, supportive school counselor, address school avoidance — earlier return better outcomes (school refusal becomes harder with time); (4) SSRI if severe + CBT inadequate — sertraline, fluoxetine, fluvoxamine (effective for childhood anxiety per CAMS trial); SSRI + CBT combination most effective; (5) Address comorbidity: other anxiety disorders, depression, learning issues; (6) Family therapy + parent psychoeducation; (7) Rule out: medical causes of somatic sx, bullying at school, learning disorder, trauma; (8) Long-term: SAD predicts adult anxiety; early intervention important; (9) Multidisciplinary: child psychiatry, therapist, pediatrician, school personnel

---

Separation Anxiety Disorder: CBT first-line (Coping Cat). Parent training to reduce accommodation. Gradual school re-entry. SSRI for severe (CAMS — combination best). Early return to school. Multidisciplinary.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'peds',
  'CAMS trial Walkup NEJM 2008; Kendall Coping Cat', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'เด็กหญิงอายุ 7 ปี เริ่มไม่ยอมไปโรงเรียน × 3 เดือน — กลัวว่า mother จะหายไปหรือมีอันตราย, ฝันร้าย, somatic complaints (stomach ache, headache) ทุกเช้าก่อนไป รร., refuses sleepover, ติดแม่ตลอด, attended school normally ก่อนหน้านี้

No trauma, no recent separation
Developmental hx normal, school performance was good'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 5 ปี พูดได้ปกติที่บ้านกับ family แต่ไม่พูดเลยที่ รร. × 18 เดือน — ไม่พูดกับ teacher, peers, ในที่สาธารณะ; ใช้ gesture หรือ point; understanding ภาษาปกติ; bilingual (ไทย + Mandarin)

Developmental hx normal
No trauma
No hearing/speech disorder
Met criteria > 1 mo (not first month of school)', '[{"label":"A","text":"Force child to speak"},{"label":"B","text":"Selective Mutism (DSM-5"},{"label":"C","text":"Punishment"},{"label":"D","text":"Surgery"},{"label":"E","text":"Ignore"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Selective Mutism (DSM-5 — anxiety disorder; failure to speak in specific social situations despite speaking in others, > 1 mo, not just first month of school, not language disorder): (1) Behavioral therapy first-line — exposure-based, stimulus fading (gradually introduce people child can speak in front of), shaping (reward approximations of speech), positive reinforcement; (2) Parent + school collaboration — consistent approach, reduce pressure, accept gestures initially then shape; (3) SSRI (fluoxetine, sertraline) for moderate-severe or treatment-resistant — significant evidence base; combines with behavioral; (4) Avoid: forcing child to speak, punishment, labeling as ''stubborn'', special attention to silence; (5) School interventions: small group integration, supportive teachers, gradual exposure to speaking situations; (6) Distinguish from: shyness (normal), language disorder, ASD, hearing impairment, trauma (mutism after trauma); (7) Multilingual children — higher prevalence + need to assess in both languages; (8) Multidisciplinary: child psychiatry, behavioral therapist, school personnel, speech-language pathologist; (9) Long-term: most improve with treatment; untreated predicts adult anxiety

---

Selective Mutism: anxiety disorder (DSM-5). Behavioral exposure-based + parent/school collaboration first-line. SSRI for moderate-severe (fluoxetine evidence). Multilingual children higher prevalence. Avoid forcing/punishment.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'peds',
  'DSM-5-TR; Bergman Selective Mutism', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'เด็กหญิงอายุ 5 ปี พูดได้ปกติที่บ้านกับ family แต่ไม่พูดเลยที่ รร. × 18 เดือน — ไม่พูดกับ teacher, peers, ในที่สาธารณะ; ใช้ gesture หรือ point; understanding ภาษาปกติ; bilingual (ไทย + Mandarin)

Developmental hx normal
No trauma
No hearing/speech disorder
Met criteria > 1 mo (not first month of school)'
  );

commit;

