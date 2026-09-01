-- ===============================================================
-- หมอรู้ — Board seed: จิตเวชศาสตร์ (psychiatry) — part 2/4 (50 MCQs)
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
  s.id, 'board', NULL, 'ชายไทยอายุ 35 ปี งานถูก layoff 1 เดือนที่แล้ว — ตั้งแต่นั้น mood ตก, นอนไม่หลับ, กังวล, irritable, withdrawal จาก social — but ไม่ครบเกณฑ์ MDD (no anhedonia, no SI, no significant weight change), no panic

PHQ-9: 11 (moderate sx but not full MDD criteria)
Functional impairment present (job search difficulty)
No prior psychiatric history', '[{"label":"A","text":"Long-term SSRI"},{"label":"B","text":"Adjustment Disorder (DSM-5"},{"label":"C","text":"Hospitalization"},{"label":"D","text":"Surgery"},{"label":"E","text":"No treatment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Adjustment Disorder (DSM-5: emotional/behavioral sx in response to identifiable stressor within 3 mo + clinically significant + does not meet other disorder criteria + does not persist > 6 mo after stressor + consequences resolved): (1) Psychotherapy first-line — supportive therapy, brief CBT, problem-solving therapy; address stressor + coping; (2) Medication usually NOT first-line — limited evidence; short-term SSRI/anxiolytic if severe symptoms or comorbidity; (3) Practical support — employment counseling, financial counseling, social work referral; (4) Identify + leverage social support (family, peers, community); (5) Stress management + lifestyle (exercise, sleep, mindfulness); (6) Distinguish from: MDD (criteria not met), bereavement (different category), normal stress response, PTSD (trauma criterion); (7) Time-limited by definition (≤ 6 mo after stressor resolution); chronic if stressor persists; (8) Suicide risk — adjustment disorder elevated (especially adolescents) — assess; (9) Subtypes: with depressed mood, with anxiety, mixed, with conduct disturbance, with mixed disturbance

---

Adjustment Disorder: sx in response to identifiable stressor < 3 mo + does not meet other disorder + does not persist > 6 mo after stressor resolves. Psychotherapy first-line (supportive, brief CBT). Practical support. Limited medication role. Suicide risk assessment.', NULL,
  'easy', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'DSM-5-TR; Strain Adjustment Disorder', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ชายไทยอายุ 35 ปี งานถูก layoff 1 เดือนที่แล้ว — ตั้งแต่นั้น mood ตก, นอนไม่หลับ, กังวล, irritable, withdrawal จาก social — but ไม่ครบเกณฑ์ MDD (no anhedonia, no SI, no significant weight change), no panic

PHQ-9: 11 (moderate sx but not full MDD criteria)
Functional impairment present (job search difficulty)
No prior psychiatric history'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 30 ปี รอดจาก motor vehicle accident 2 สัปดาห์ที่แล้ว (passenger of car hit head-on; driver dead) — ตั้งแต่นั้น recurrent intrusive memories, nightmares, flashbacks, avoidance ของ driving, hypervigilance, sleep disturbance, dissociative sx (feeling unreal), irritability

Sx ≥ 3 วัน, < 1 month duration
MSE: anxious, intrusive sx visible
No psychotic features', '[{"label":"A","text":"Forced ''debriefing'' early"},{"label":"B","text":"Acute Stress Disorder (DSM-5"},{"label":"C","text":"Long-term benzodiazepine"},{"label":"D","text":"Surgery"},{"label":"E","text":"No follow-up"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Stress Disorder (DSM-5: trauma exposure + ≥ 9 sx จาก 5 categories ใน intrusion/negative mood/dissociation/avoidance/arousal; 3 days - 1 mo): (1) Trauma-focused CBT first-line — brief course (5-12 sessions); reduces PTSD development; (2) Psychological First Aid — early; assess + safety + connect to resources + practical help — avoid forced disclosure (e.g., ''debriefing'' shown ineffective + may harm); (3) Sleep + nightmare management — prazosin for nightmares if severe; sleep hygiene; (4) Avoid benzodiazepines (may increase PTSD risk); (5) SSRI not routinely indicated acute — if persistent comorbid sx; (6) Address comorbidity: depression, substance use; (7) Bereavement support (driver died) + grief; (8) Practical support: legal, insurance, family; (9) Distinguish from PTSD (≥ 1 mo): ASD predicts PTSD but not all develop PTSD; many recover spontaneously; (10) Follow-up: assess at 1 mo for PTSD; (11) Multidisciplinary: psychiatry/psychology, primary care, social work, peer support

---

Acute Stress Disorder: trauma + sx 3 days - 1 mo. Trauma-focused CBT first-line (brief). Psychological First Aid. AVOID forced debriefing + benzodiazepine. Predicts PTSD — follow at 1 mo.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'DSM-5-TR; NICE PTSD; Bryant ASD', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 30 ปี รอดจาก motor vehicle accident 2 สัปดาห์ที่แล้ว (passenger of car hit head-on; driver dead) — ตั้งแต่นั้น recurrent intrusive memories, nightmares, flashbacks, avoidance ของ driving, hypervigilance, sleep disturbance, dissociative sx (feeling unreal), irritability

Sx ≥ 3 วัน, < 1 month duration
MSE: anxious, intrusive sx visible
No psychotic features'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 55 ปี สามีเสียชีวิต 16 เดือนที่แล้ว — ปกติ grief process แต่ตั้งแต่ 8 เดือนที่ผ่านมา persistent intense yearning, preoccupation with deceased, inability to accept death, avoidance of reminders, feelings of meaninglessness, withdrawal from social activities — sx persist + interfere with functioning

Not meeting MDD criteria fully
No psychotic features', '[{"label":"A","text":"No treatment — natural grief"},{"label":"B","text":"Prolonged Grief Disorder (DSM-5-TR new diagnosis 2022"},{"label":"C","text":"Long-term benzodiazepine"},{"label":"D","text":"Surgery"},{"label":"E","text":"Avoid all reminders"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Prolonged Grief Disorder (DSM-5-TR new diagnosis 2022: persistent grief responses ≥ 12 mo adults / 6 mo children + ≥ 3 sx + impairment + exceed cultural norm): (1) Complicated Grief Treatment (CGT — Shear) first-line — adapted CBT specific to prolonged grief; (2) Components: education about grief, exposure to avoided cues, restoration of life goals, working through specific painful memories, building social connections; (3) Distinguish from MDD (overlap but distinct — bereavement-specific yearning + preoccupation with deceased); (4) Antidepressant if comorbid MDD — does NOT specifically treat grief but helps depression; (5) Group therapy + bereavement support groups + peer support; (6) Cultural + religious considerations — grief expression varies; (7) Suicide risk elevated (especially first year + complicated grief); (8) Address comorbidity: depression, PTSD (if traumatic loss), substance use, anxiety; (9) Distinguish: normal grief (recovery without specific treatment in most), bereavement (now included in MDD criteria DSM-5 — no longer excludes), complicated grief = pathological extension

---

Prolonged Grief Disorder (DSM-5-TR 2022): grief ≥ 12 mo + functional impairment. Complicated Grief Treatment (Shear) first-line. Distinguish from normal grief, MDD. Suicide risk elevated. Cultural considerations.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'DSM-5-TR 2022; Shear Complicated Grief', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 55 ปี สามีเสียชีวิต 16 เดือนที่แล้ว — ปกติ grief process แต่ตั้งแต่ 8 เดือนที่ผ่านมา persistent intense yearning, preoccupation with deceased, inability to accept death, avoidance of reminders, feelings of meaninglessness, withdrawal from social activities — sx persist + interfere with functioning

Not meeting MDD criteria fully
No psychotic features'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 22 ปี × 4 ปี — preoccupied กับ perceived defect ของ nose (มองไม่เห็นโดย others; รูปจริงปกติ) — กระจกหลายชั่วโมง/วัน, มี multiple consultations กับ plastic surgeon, refused surgery มาแล้ว 3 ครั้ง, social withdrawal, ขาดเรียน

No other psychiatric, recognizes preoccupation excessive sometimes but not always
No psychotic features (delusional intensity in 30% but not now)', '[{"label":"A","text":"Cosmetic surgery"},{"label":"B","text":"Body Dysmorphic Disorder (DSM-5 OC-spectrum"},{"label":"C","text":"Reassurance only"},{"label":"D","text":"No treatment"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Body Dysmorphic Disorder (DSM-5 OC-spectrum: preoccupation with perceived flaw not observable to others + repetitive behaviors + > 1h/d + distress/impairment): (1) CBT with ERP (Exposure + Response Prevention) first-line — exposure to feared situations + prevent compulsions (mirror checking, reassurance seeking, comparison); cognitive restructuring about appearance beliefs; (2) SSRI first-line medication — HIGHER doses + longer duration (like OCD): fluoxetine 60-80mg, sertraline 200mg, escitalopram 30mg; clomipramine alternative; (3) Combination CBT + SSRI for severe; (4) AVOID cosmetic surgery — rarely satisfied, often worsens; new focus elsewhere; surgical request = red flag; (5) Address comorbidity high: depression (75%), social anxiety, OCD, substance use; (6) Suicide risk very high (~ 25% lifetime attempt); (7) Education about disorder + that subjective perception ≠ reality; (8) Family education + support; (9) Long-term: chronic + waxing/waning; maintenance treatment often needed; (10) Variants: muscle dysmorphia (preoccupation with insufficient muscularity)

---

BDD: preoccupation with perceived flaw + repetitive behaviors. CBT with ERP + SSRI (higher doses, like OCD). AVOID cosmetic surgery (rarely satisfied, worsens). Suicide risk very high (25% lifetime). Comorbid depression common.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'Phillips BDD; APA OCD Guidelines', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 22 ปี × 4 ปี — preoccupied กับ perceived defect ของ nose (มองไม่เห็นโดย others; รูปจริงปกติ) — กระจกหลายชั่วโมง/วัน, มี multiple consultations กับ plastic surgeon, refused surgery มาแล้ว 3 ครั้ง, social withdrawal, ขาดเรียน

No other psychiatric, recognizes preoccupation excessive sometimes but not always
No psychotic features (delusional intensity in 30% but not now)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 62 ปี ลูกพามา — สะสมหนังสือพิมพ์ + ของเก่า + สัตว์ × 20 ปี — บ้านเต็มไปด้วยของจนใช้ห้องไม่ได้ — ห้องน้ำใช้ไม่ได้, ครัวใช้ไม่ได้, นอนบนเก้าอี้, รู้สึกหวงทุกชิ้น + distress มากเมื่อต้องทิ้ง; เมียทิ้งไปเพราะเรื่องนี้

MSE: insight partial; recognizes problem but resists discarding
Mobile but living conditions hazardous (fire risk, sanitation)
No psychosis, mild cognitive impairment MMSE 28', '[{"label":"A","text":"Forced cleanout"},{"label":"B","text":"Hoarding Disorder (DSM-5 OC-spectrum"},{"label":"C","text":"Eviction"},{"label":"D","text":"No treatment"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Hoarding Disorder (DSM-5 OC-spectrum: persistent difficulty discarding + distress with discarding + accumulation + clutter compromising use + impairment): (1) Specialized CBT for hoarding (Steketee + Frost manual) first-line — motivational enhancement, cognitive restructuring, skills training (sorting, organizing, decision-making), in-home work, exposure to discarding + not acquiring; intensive + lengthy; (2) Group therapy + peer support; (3) SSRI — moderate evidence (fluoxetine, paroxetine, venlafaxine) — less robust than for OCD; some help; (4) Avoid forced clear-outs by family/officials — high relapse + traumatic + does not address underlying; (5) Comorbidity assessment: depression, anxiety, ADHD (very common — executive function), OCD, autism; (6) Safety + harm reduction — fire hazard, falls, sanitation, animal welfare (animal hoarding — separate issue), evictions; coordinate กับ public health + housing; (7) Family education + support — reduce blame; (8) Multidisciplinary: psychiatry, behavioral therapist, OT (organizing skills), case management, social work, public health; (9) Long-term: chronic; gradual progress; relapse common; (10) Late-onset + cognitive decline — rule out dementia (FTD) or stroke

---

Hoarding Disorder (DSM-5): persistent difficulty discarding + accumulation impairing living. Specialized CBT (Steketee + Frost) first-line. SSRI moderate evidence. AVOID forced clear-outs. Address ADHD + executive dysfunction comorbidity. Multidisciplinary including OT.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'Steketee + Frost Hoarding; DSM-5-TR', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ชายไทยอายุ 62 ปี ลูกพามา — สะสมหนังสือพิมพ์ + ของเก่า + สัตว์ × 20 ปี — บ้านเต็มไปด้วยของจนใช้ห้องไม่ได้ — ห้องน้ำใช้ไม่ได้, ครัวใช้ไม่ได้, นอนบนเก้าอี้, รู้สึกหวงทุกชิ้น + distress มากเมื่อต้องทิ้ง; เมียทิ้งไปเพราะเรื่องนี้

MSE: insight partial; recognizes problem but resists discarding
Mobile but living conditions hazardous (fire risk, sanitation)
No psychosis, mild cognitive impairment MMSE 28'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 19 ปี × 4 ปี — recurrent hair pulling จาก scalp + eyebrows → visible alopecia, attempts to stop unsuccessful, ทำลึก ๆ ขณะ studying/stressed, distress + embarrassment, wears scarf, social withdrawal

No skin disease, no psychotic features
MSE: alert, distressed about behavior, attempts to conceal', '[{"label":"A","text":"No treatment"},{"label":"B","text":"Trichotillomania (DSM-5 OC-spectrum"},{"label":"C","text":"Surgery"},{"label":"D","text":"Antibiotic"},{"label":"E","text":"Wig only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Trichotillomania (DSM-5 OC-spectrum: recurrent hair pulling → hair loss + attempts to stop + distress/impairment): (1) Habit Reversal Training (HRT) — first-line; awareness training + competing response (e.g., clench fists when urge) + stimulus control + relaxation; effective + durable; (2) ACT (Acceptance + Commitment Therapy) + dialectical behavior therapy adaptations effective; (3) N-acetylcysteine (NAC) — 1200-2400 mg/day; modulates glutamate; modest evidence; well-tolerated; (4) SSRI — limited evidence (unlike OCD); some respond; (5) Atypical antipsychotic adjunctive in refractory; (6) Avoid: punishment, hats only (don''t address); shaving (often resumes); (7) Comorbidity: depression, anxiety, OCD; (8) Self-help resources + support groups (TLC Foundation for BFRBs); (9) Skin/scalp examination + dermatology if scarring or infection; (10) Related Body-Focused Repetitive Behaviors (BFRBs): skin picking (excoriation), nail biting; (11) Long-term: chronic + waxing/waning; (12) Multidisciplinary

---

Trichotillomania (DSM-5 OC-spectrum): hair pulling + functional impairment. HRT (Habit Reversal Training) first-line. NAC modest evidence. SSRI limited (unlike OCD). Related BFRBs (skin picking).', NULL,
  'easy', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'TLC Foundation BFRB; Grant Trichotillomania', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 19 ปี × 4 ปี — recurrent hair pulling จาก scalp + eyebrows → visible alopecia, attempts to stop unsuccessful, ทำลึก ๆ ขณะ studying/stressed, distress + embarrassment, wears scarf, social withdrawal

No skin disease, no psychotic features
MSE: alert, distressed about behavior, attempts to conceal'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 30 ปี recurrent skin picking × 8 ปี — picks ที่ face/arms ทำให้เกิด scarring + open wounds + infection; tries to stop หลายครั้ง; picks ขณะ stressed/bored; impairment ทาง social (embarrassment) + occupational

Dermatology workup: lesions consistent กับ self-induced; no primary dermatologic condition
No psychosis', '[{"label":"A","text":"Topical steroid only"},{"label":"B","text":"Excoriation (Skin-Picking) Disorder (DSM-5 OC-spectrum 2013 addition"},{"label":"C","text":"Restraints"},{"label":"D","text":"Surgery"},{"label":"E","text":"No treatment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Excoriation (Skin-Picking) Disorder (DSM-5 OC-spectrum 2013 addition: recurrent skin picking → skin lesions + attempts to stop + distress/impairment): (1) Habit Reversal Training (HRT) — first-line, similar to trichotillomania; awareness, competing response, stimulus control; (2) CBT — broader cognitive + behavioral; (3) ACT effective; (4) N-acetylcysteine (NAC) — modest evidence; (5) SSRI — limited evidence; some respond (escitalopram, fluoxetine); (6) Avoid topical treatment alone — doesn''t address behavior; (7) Wound care + infection treatment as needed; barriers (gloves, bandages) as stimulus control; (8) Comorbidity: depression, anxiety, OCD, BDD; (9) Distinguish from: dermatologic disease, scabies, drug-induced, delusional infestation; (10) Address self-stigma + shame — common in BFRBs; (11) Self-help + support groups (TLC Foundation); (12) Multidisciplinary: psychiatry, behavioral therapist, dermatology

---

Excoriation (Skin-Picking) Disorder: DSM-5 OC-spectrum (2013). HRT first-line. NAC modest. SSRI limited evidence. Address shame + multidisciplinary including dermatology. Related to other BFRBs.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'DSM-5-TR; Grant Skin Picking', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 30 ปี recurrent skin picking × 8 ปี — picks ที่ face/arms ทำให้เกิด scarring + open wounds + infection; tries to stop หลายครั้ง; picks ขณะ stressed/bored; impairment ทาง social (embarrassment) + occupational

Dermatology workup: lesions consistent กับ self-induced; no primary dermatologic condition
No psychosis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 28 ปี G2P1 postpartum 10 days — ก่อนคลอด healthy, no psychiatric hx; ตอนนี้ rapid onset (3 วัน) ของ confusion, mood lability, delusions (เชื่อว่าทารกถูกสับเปลี่ยน, ได้ยินเสียงสั่งให้ทำร้ายทารก), insomnia, agitation

MSE: disoriented, command auditory hallucinations + delusions, labile affect
Vitals: stable, no fever
Workup: TSH, B12, CBC, infection workup pending
Husband present, concerned about safety of mother + baby', '[{"label":"A","text":"Outpatient management"},{"label":"B","text":"Postpartum Psychosis"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Watchful waiting"},{"label":"E","text":"Antibiotic only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Postpartum Psychosis — PSYCHIATRIC EMERGENCY (rare 0.1-0.2% but devastating; high infanticide + suicide risk; often onset within 2 wk postpartum): (1) Immediate hospitalization (involuntary if needed) — separate from infant initially or supervised contact; (2) Safety: 1:1 observation, both maternal suicide + infanticide risk; specialized mother-baby unit if available; (3) Antipsychotic + mood stabilizer or BZD — quetiapine, olanzapine, risperidone; lithium effective if bipolar (most postpartum psychosis = BP spectrum); (4) ECT highly effective for postpartum psychosis — consider early, especially with food refusal, severe SI, infanticide ideation, lactation considerations (compatible); (5) Rule out organic: thyroid storm, sepsis, eclampsia/PRES, autoimmune encephalitis, infection, drug withdrawal, sleep deprivation severe; (6) Breastfeeding decisions individualized — most psychiatric medications compatible (consult LactMed); separation may be necessary acutely; (7) Long-term: 30-50% recurrence with subsequent pregnancies — prophylactic mood stabilizer postpartum next pregnancy; (8) Distinguish from postpartum blues (transient, no psychosis) + postpartum depression (no psychosis); (9) Multidisciplinary: perinatal psychiatry, OB-GYN, pediatrics, social work, family; (10) Family education + support

---

Postpartum Psychosis: EMERGENCY. Rare (0.1-0.2%) but high infanticide + suicide risk. Often BP spectrum. Hospitalize. Antipsychotic + mood stabilizer; ECT highly effective. Recurrence 30-50% — prophylaxis next pregnancy. Distinguish from blues + PPD.', NULL,
  'hard', 'obgyn', 'review',
  'psychiatry', 'clinical_decision', 'obgyn', 'adult',
  'Sit Postpartum Psychosis; APA Perinatal', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 28 ปี G2P1 postpartum 10 days — ก่อนคลอด healthy, no psychiatric hx; ตอนนี้ rapid onset (3 วัน) ของ confusion, mood lability, delusions (เชื่อว่าทารกถูกสับเปลี่ยน, ได้ยินเสียงสั่งให้ทำร้ายทารก), insomnia, agitation

MSE: disoriented, command auditory hallucinations + delusions, labile affect
Vitals: stable, no fever
Workup: TSH, B12, CBC, infection workup pending
Husband present, concerned about safety of mother + baby'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 38 ปี recurrent ER visits × 6 episodes — palpitations + chest pain + SOB + diaphoresis + sense of doom, lasting 10-15 min; every workup negative (ECG, trop, echo, stress test, holter, TSH); attacks now triggered by going to mall + driving + occur unpredictably; avoids these situations

Family hx of MI age 50
Intense fear of having heart attack', '[{"label":"A","text":"Repeat cardiac testing each visit"},{"label":"B","text":"Panic Disorder + Health Anxiety (DSM-5"},{"label":"C","text":"Long-term benzodiazepine"},{"label":"D","text":"Surgery"},{"label":"E","text":"Avoid all activity"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Panic Disorder + Health Anxiety (DSM-5: recurrent unexpected panic attacks + ≥ 1 mo worry/behavior change; medical workup negative): (1) Education first — explain physiology of panic (fight-flight false alarm, sympathetic activation, hyperventilation, catastrophic interpretation of normal sensations) + reassurance based on negative workup; (2) CBT first-line — cognitive restructuring (catastrophic thoughts about chest pain ≠ MI), interoceptive exposure (induce sensations safely to extinguish fear), in vivo exposure (return to avoided situations — mall, driving) prevents agoraphobia; (3) SSRI first-line medication (sertraline, paroxetine, escitalopram) — start low (panic patients sensitive); (4) Limit ER visits + repeat cardiac testing (reinforces illness behavior + iatrogenic anxiety); coordinate care; (5) Avoid long-term benzodiazepine — short-term bridging while SSRI titrating ok; (6) Address family history concern — modify cardiovascular risk factors + reassurance; (7) Comorbid health anxiety (illness anxiety disorder) — CBT for health anxiety; (8) Lifestyle: caffeine, alcohol, exercise, sleep; (9) Multidisciplinary: psychiatry, primary care (single source) to coordinate; (10) Treatment outcomes good (60-80%)

---

Panic Disorder + Health Anxiety: education + CBT + SSRI first-line. Interoceptive + in vivo exposure prevents agoraphobia. Limit ER + repeat testing (reinforces). AVOID long-term benzodiazepine. Coordinated care.', NULL,
  'easy', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'APA Panic Guideline; Barlow Anxiety + Its Disorders', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ชายไทยอายุ 38 ปี recurrent ER visits × 6 episodes — palpitations + chest pain + SOB + diaphoresis + sense of doom, lasting 10-15 min; every workup negative (ECG, trop, echo, stress test, holter, TSH); attacks now triggered by going to mall + driving + occur unpredictably; avoids these situations

Family hx of MI age 50
Intense fear of having heart attack'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 45 ปี × 3 ปี — preoccupied กับ having serious illness แม้ workup negative + reassurance หลายครั้ง — แปลความ minor body sensations เป็น cancer; doctor shopping × 8 specialists; reads medical websites; high distress; impairs daily life

No somatic sx prominently (mild aches normal) — focus is fear of disease, not physical complaints
Differential: somatic symptom disorder (somatic sx prominent) vs IAD (fear without significant somatic sx)', '[{"label":"A","text":"Repeat workup each visit"},{"label":"B","text":"Illness Anxiety Disorder (DSM-5"},{"label":"C","text":"Avoid all medical care"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Illness Anxiety Disorder (DSM-5: preoccupation with having serious illness + minimal somatic sx + high anxiety + excessive health-related behaviors or avoidance + ≥ 6 mo): (1) CBT for health anxiety first-line — cognitive restructuring of catastrophic interpretation, behavioral experiments, exposure (reduce reassurance seeking + checking + avoidance); (2) SSRI second-line or for severe (paroxetine, fluoxetine evidence); (3) Establish single primary care provider — limit doctor shopping + repeat testing (reinforces); regular scheduled visits (not symptom-driven); (4) Educate + validate concern — avoid dismissing ''all in your head''; (5) Limit reassurance seeking (paradoxical reinforcer of anxiety); (6) Address comorbidity: depression, GAD, OCD; (7) Distinguish from: somatic symptom disorder (somatic sx prominent), conversion disorder (neurological), factitious (intentional), malingering (external incentive); (8) Family education; (9) Lifestyle: stress management, mindfulness; (10) Long-term — chronic illness pattern; care coordination critical

---

Illness Anxiety Disorder (DSM-5): preoccupation with illness + minimal somatic sx + behaviors. CBT first-line. Single PCP + limit repeat testing/reassurance. SSRI for severe. Distinguish from somatic symptom disorder + factitious + malingering.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'DSM-5-TR; APA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 45 ปี × 3 ปี — preoccupied กับ having serious illness แม้ workup negative + reassurance หลายครั้ง — แปลความ minor body sensations เป็น cancer; doctor shopping × 8 specialists; reads medical websites; high distress; impairs daily life

No somatic sx prominently (mild aches normal) — focus is fear of disease, not physical complaints
Differential: somatic symptom disorder (somatic sx prominent) vs IAD (fear without significant somatic sx)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 30 ปี × 3 ปี — chronic auditory hallucinations + persecutory delusions present continuously even when mood stable, แต่ก่อนหน้านี้ 1 ปี มี major depressive episode × 4 เดือน + manic episode × 6 wk — ขณะนี้ stable mood แต่ psychosis ยังคงอยู่

No substance use
MSE: prominent psychosis even when euthymic; mood currently stable', '[{"label":"A","text":"Antidepressant monotherapy"},{"label":"B","text":"Schizoaffective Disorder, Bipolar Type (DSM-5"},{"label":"C","text":"No treatment"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Schizoaffective Disorder, Bipolar Type (DSM-5: uninterrupted illness with major mood episode concurrent with active phase psychosis + delusions/hallucinations ≥ 2 wk WITHOUT major mood sx + mood sx prominent majority of total illness): (1) Combination — antipsychotic + mood stabilizer (or antipsychotic alone if mood stabilized) — Paliperidone is only FDA-approved specifically for schizoaffective; (2) Mood stabilizer: lithium (bipolar type) or lamotrigine; valproate; (3) For depressive type: antidepressant cautiously + antipsychotic; (4) Clozapine for treatment-resistant + suicide risk; (5) Psychosocial — same as schizophrenia + bipolar (psychoeducation, family-focused, CBTp, supported employment); (6) Long-term maintenance medication essential; (7) Suicide risk high (between schizophrenia + bipolar); (8) Comorbidity: substance use, anxiety, metabolic; (9) Distinguish: schizophrenia with mood symptoms vs mood disorder with psychotic features vs schizoaffective (requires both — psychosis without mood + mood prominent majority of illness); (10) Multidisciplinary

---

Schizoaffective Disorder: psychosis ≥ 2 wk without mood + mood prominent majority of illness. Paliperidone only FDA-approved. Combination antipsychotic + mood stabilizer. Clozapine for refractory. Suicide risk between schizophrenia + bipolar.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'DSM-5-TR; Paliperidone schizoaffective FDA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 30 ปี × 3 ปี — chronic auditory hallucinations + persecutory delusions present continuously even when mood stable, แต่ก่อนหน้านี้ 1 ปี มี major depressive episode × 4 เดือน + manic episode × 6 wk — ขณะนี้ stable mood แต่ psychosis ยังคงอยู่

No substance use
MSE: prominent psychosis even when euthymic; mood currently stable'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 55 ปี × 3 ปี — เชื่อว่าเพื่อนบ้านกำลังวางยาพิษอาหารเขา; ค้นบ้านบ่อย, install CCTV, complained to police × 8 ครั้ง — but otherwise functions normally at work + relationships; no hallucinations, no other psychotic sx, no mood disorder, no substance use

MSE: well-groomed, employed, lucid + organized — delusion encapsulated, intense conviction
No cognitive impairment', '[{"label":"A","text":"Confront the delusion directly"},{"label":"B","text":"Delusional Disorder, Persecutory Type (DSM-5"},{"label":"C","text":"Surgery"},{"label":"D","text":"No treatment"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Delusional Disorder, Persecutory Type (DSM-5: ≥ 1 delusion ≥ 1 mo + criterion A for schizophrenia NOT met + functioning not markedly impaired apart from delusion + duration > 1 mo): (1) Therapeutic alliance is paramount — patients often poor insight, distrustful, treatment-resistant; engagement first; (2) Antipsychotic — limited evidence but considered first-line: low-dose atypical (risperidone, olanzapine, aripiprazole); response modest (50% improvement at best); (3) CBT for psychosis (CBTp) — engage gently, explore evidence + alternative explanations, NEVER directly confront delusion (ruptures alliance); (4) Address comorbid depression (50%); (5) Subtypes (DSM-5): erotomanic, grandiose, jealous, persecutory (most common), somatic, mixed; (6) Distinguish from: paranoid schizophrenia (bizarre delusions, hallucinations, negative sx), paranoid PD (long-standing trait), shared psychotic disorder (folie à deux), substance/medical; (7) Forensic considerations: stalking, violence (esp jealous + persecutory subtypes); (8) Long-term: chronic, partial response common; functional preservation is hallmark; (9) Family education + safety planning if risk to self/others

---

Delusional Disorder: ≥ 1 non-bizarre delusion ≥ 1 mo + criterion A schizophrenia NOT met + functioning preserved apart from delusion. Antipsychotic + CBT for psychosis — never confront directly. Functional preservation is hallmark. Forensic risk (jealous, persecutory).', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'DSM-5-TR; Munro Delusional Disorder', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ชายไทยอายุ 55 ปี × 3 ปี — เชื่อว่าเพื่อนบ้านกำลังวางยาพิษอาหารเขา; ค้นบ้านบ่อย, install CCTV, complained to police × 8 ครั้ง — but otherwise functions normally at work + relationships; no hallucinations, no other psychotic sx, no mood disorder, no substance use

MSE: well-groomed, employed, lucid + organized — delusion encapsulated, intense conviction
No cognitive impairment'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 25 ปี G1P0 GA 38 wk — sudden onset psychotic sx (acute delusions of being followed, brief auditory hallucinations, disorganized speech, behavioral disturbance) × 5 วัน หลัง major stressor (พ่อเสียชีวิต) — no prior psychiatric history, no substance use

MSE: psychotic features, oriented x3
Workup: TSH normal, no metabolic, no infection, no neuro deficit', '[{"label":"A","text":"Long-term antipsychotic immediately"},{"label":"B","text":"Brief Psychotic Disorder (DSM-5"},{"label":"C","text":"No treatment"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Brief Psychotic Disorder (DSM-5: ≥ 1 of delusions/hallucinations/disorganized speech/grossly disorganized + 1 day - 1 mo + full return to premorbid level; specifier — with marked stressor): (1) Hospitalization usually indicated — safety, observation, evaluate course; (2) Short-term antipsychotic (atypical low-dose) + benzodiazepine for acute agitation; (3) Address precipitant — supportive psychotherapy + grief work + social support; (4) Pregnancy — coordinate OB + delivery planning; perinatal psychiatry consultation; medication safety in late pregnancy; (5) After resolution — taper antipsychotic over months (typical 1-3 mo course); some discontinue without need for maintenance; (6) Distinguish: schizophreniform (1-6 mo), schizophrenia (≥ 6 mo), postpartum psychosis (specific to postpartum), substance/medical-induced; (7) Long-term: ~ 50% have single episode + full recovery; ~ 50% progress to mood or psychotic disorder — follow longitudinally; (8) Suicide risk — assess; (9) Family education; (10) Multidisciplinary: psychiatry, OB, social work

---

Brief Psychotic Disorder (DSM-5): psychotic sx 1 day - 1 mo + full return. Stressor specifier common. Short-term antipsychotic + supportive therapy. ~ 50% single episode; ~ 50% progress. Distinguish from schizophreniform/schizophrenia by duration. Pregnancy — coordinated care.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'DSM-5-TR; Pillmann Brief Psychosis', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 25 ปี G1P0 GA 38 wk — sudden onset psychotic sx (acute delusions of being followed, brief auditory hallucinations, disorganized speech, behavioral disturbance) × 5 วัน หลัง major stressor (พ่อเสียชีวิต) — no prior psychiatric history, no substance use

MSE: psychotic features, oriented x3
Workup: TSH normal, no metabolic, no infection, no neuro deficit'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 21 ปี × 3 เดือน — persistent delusions + auditory hallucinations + negative sx (alogia, blunt affect) + functional decline — meet schizophrenia criterion A but duration 3 เดือน (1 mo - 6 mo)

No substance use, no medical cause
MSE: prominent psychotic features', '[{"label":"A","text":"No treatment until 6 months passes"},{"label":"B","text":"Schizophreniform Disorder (DSM-5"},{"label":"C","text":"Surgery"},{"label":"D","text":"Antibiotic"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Schizophreniform Disorder (DSM-5: criteria A, D, E ของ schizophrenia met + duration ≥ 1 mo but < 6 mo): (1) Atypical antipsychotic — same as schizophrenia (risperidone, olanzapine, aripiprazole, etc.); start low + titrate; (2) Early intervention services — first-episode psychosis (FEP) programs (Coordinated Specialty Care — CSC, OnTrackNY, EASA model) — reduce duration of untreated psychosis (DUP — predicts outcome); CBT for psychosis, supported employment/education, family education, low-dose antipsychotic, peer support, case management; (3) Family education + support (NEAP — National Alliance on Mental Illness Family-to-Family); (4) Cognitive behavioral therapy for psychosis (CBTp); (5) Address substance use comorbidity (often cannabis); (6) Workup: medical (thyroid, B12, drug screen, infectious, autoimmune — anti-NMDA receptor encephalitis in young), neuroimaging; (7) Course: - ~ 60% progress to schizophrenia; - ~ 30% recover (good prognostic — acute onset, prominent affective sx, confusion, no negative sx, return to premorbid); (8) Long-term medication often needed; (9) Multidisciplinary; (10) Suicide risk + assessment

---

Schizophreniform: schizophrenia criteria but 1-6 mo duration. Treat same as schizophrenia — antipsychotic + early intervention services. Reduce DUP. ~ 60% progress to schizophrenia. Workup including anti-NMDA encephalitis in young.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'DSM-5-TR; EPPIC; OnTrackNY', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ชายไทยอายุ 21 ปี × 3 เดือน — persistent delusions + auditory hallucinations + negative sx (alogia, blunt affect) + functional decline — meet schizophrenia criterion A but duration 3 เดือน (1 mo - 6 mo)

No substance use, no medical cause
MSE: prominent psychotic features'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'วัยรุ่นชายอายุ 17 ปี × 8 เดือน — subtle changes: social withdrawal, declining school performance, brief attenuated psychotic-like experiences (unusual perceptual phenomena, magical thinking — recognized as unusual), brief intermittent suspiciousness, sleep disturbance — but NOT meeting full psychotic disorder criteria

Family hx: uncle with schizophrenia
SIPS positive for clinical high risk (CHR-P)', '[{"label":"A","text":"Immediate antipsychotic for prevention"},{"label":"B","text":"Clinical High Risk for Psychosis (CHR-P; also Attenuated Psychosis Syndrome"},{"label":"C","text":"No intervention until psychotic"},{"label":"D","text":"Surgery"},{"label":"E","text":"Cannabis to relax"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Clinical High Risk for Psychosis (CHR-P; also Attenuated Psychosis Syndrome — DSM-5 Section III research): (1) Early intervention essential — reduce conversion to psychosis + functional decline; (2) Specialized CHR services where available (e.g., PACE, OASIS, NEPTUNE); (3) Psychotherapy — CBT for CHR (evidence reduces conversion + improves functioning); supportive; family work; (4) AVOID routine antipsychotic — risk-benefit unfavorable for prevention; reserve for emerging full psychosis or severe sx; some evidence for omega-3 (modest); (5) Address comorbidity — depression (60%), anxiety (40%), substance use (cannabis especially — discourage strongly, increases conversion); (6) Treat comorbid conditions — SSRI for depression/anxiety; (7) Psychoeducation + family education; (8) Monitor closely — regular follow-up; assess emerging full psychosis; (9) Cannabis cessation — major modifiable risk factor; (10) Address school + functioning + social engagement; (11) Conversion rate to full psychosis ~ 20-30% over 2-3 years; majority do NOT convert — important to convey; (12) Multidisciplinary

---

Clinical High Risk for Psychosis (CHR-P): attenuated/intermittent psychotic sx, NOT full criteria. CBT first-line; AVOID routine antipsychotic. Address cannabis (modifiable risk). Treat comorbid depression/anxiety. ~ 20-30% convert over 2-3 yr. Early intervention.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'peds',
  'DSM-5-TR Section III; McGorry PACE; NAPLS', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'วัยรุ่นชายอายุ 17 ปี × 8 เดือน — subtle changes: social withdrawal, declining school performance, brief attenuated psychotic-like experiences (unusual perceptual phenomena, magical thinking — recognized as unusual), brief intermittent suspiciousness, sleep disturbance — but NOT meeting full psychotic disorder criteria

Family hx: uncle with schizophrenia
SIPS positive for clinical high risk (CHR-P)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 32 ปี schizophrenia × 10 ปี — failed adequate trials (≥ 6 wk, therapeutic dose, adherence verified) ของ risperidone, olanzapine, aripiprazole — ขณะนี้ persistent positive sx + functional impairment + 2 prior suicide attempts

No medical contraindication
WBC + ANC normal
No CV disease', '[{"label":"A","text":"Another non-clozapine antipsychotic"},{"label":"B","text":"Treatment-Resistant Schizophrenia (TRS"},{"label":"C","text":"Stop all medication"},{"label":"D","text":"Surgery"},{"label":"E","text":"ECT alone without medication"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Treatment-Resistant Schizophrenia (TRS — failure ≥ 2 antipsychotics adequate trial) — Clozapine: (1) Clozapine is ONLY antipsychotic FDA-approved for TRS + only antipsychotic with mortality reduction + reduces suicide in schizophrenia; (2) Initiation: slow titration (12.5 → 25 → 50 → 100 mg over weeks); target 300-450 mg/day; therapeutic level 350-600 ng/mL; (3) Mandatory monitoring: - CBC with ANC weekly × 6 mo → biweekly × 6 mo → monthly thereafter (agranulocytosis ~ 0.4%, mortality if missed); REMS program (US); discontinue if ANC < 1000/μL; - rechallenge if mild neutropenia + ANC recovers; (4) Side effects: agranulocytosis, myocarditis (especially first 8 wk — check troponin, CRP, ECG, HR if symptoms), seizure (dose-related, prophylactic AED at high dose), sialorrhea (anticholinergic adjunct, glycopyrrolate, ipratropium), constipation (bowel monitoring — ileus risk, fatal), weight gain + metabolic, sedation, orthostasis, urinary retention, fever (benign vs NMS); (5) Drug interactions: smoking induces metabolism (level fluctuates), caffeine, fluvoxamine inhibits; (6) Augmentation if partial response — add another antipsychotic, ECT effective adjunct; (7) Reduces suicide attempts + completed suicide; (8) Long-term — chronic medication, lifelong; (9) Multidisciplinary

---

Treatment-Resistant Schizophrenia: failure ≥ 2 antipsychotics. Clozapine = only FDA-approved + only antipsychotic with mortality + suicide reduction. Mandatory ANC monitoring (agranulocytosis). Watch myocarditis, seizure, ileus, metabolic. Underutilized despite evidence.', NULL,
  'hard', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'CATIE; Tiihonen; APA Schizophrenia 2020', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ชายไทยอายุ 32 ปี schizophrenia × 10 ปี — failed adequate trials (≥ 6 wk, therapeutic dose, adherence verified) ของ risperidone, olanzapine, aripiprazole — ขณะนี้ persistent positive sx + functional impairment + 2 prior suicide attempts

No medical contraindication
WBC + ANC normal
No CV disease'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 35 ปี newly initiated haloperidol 10 mg × 3 วัน สำหรับ psychosis — มาด้วย hyperthermia 40°C, severe muscle rigidity (lead-pipe), altered mental status, autonomic instability (BP fluctuating, tachycardia 130, diaphoresis), CK 12,500 (markedly elevated), leukocytosis 18,000

No serotonergic medications, no infection localized', '[{"label":"A","text":"Continue antipsychotic"},{"label":"B","text":"Bromocriptine or amantadine"},{"label":"C","text":"Higher dose antipsychotic"},{"label":"D","text":"Antibiotic monotherapy"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Neuroleptic Malignant Syndrome (NMS — idiopathic, life-threatening; antipsychotic — typical > atypical, rapid titration, high potency, dehydration, agitation, male, young) — EMERGENCY: (1) STOP antipsychotic immediately; ICU admission; (2) Supportive: aggressive IV fluid resuscitation, cooling, electrolyte correction, monitor for rhabdomyolysis (CK, urine output, K), DIC, renal failure, respiratory failure, VTE prophylaxis (immobility); (3) Specific: - **Dantrolene** (muscle relaxant — direct skeletal muscle Ca release); - **Bromocriptine or amantadine** (dopamine agonist — addresses D2 blockade pathophysiology); - **Benzodiazepines** for agitation + sedation; - (Mild cases — may resolve with supportive alone); (4) ECT for refractory NMS + post-NMS psychosis (cannot restart antipsychotic safely acutely); (5) Distinguish from: serotonin syndrome (hyperreflexia, clonus, recent serotonergic), malignant hyperthermia (anesthetic trigger, family hx), heat stroke, anticholinergic toxicity, septic encephalopathy, malignant catatonia (similar — overlap); (6) After resolution: wait ≥ 2 weeks before rechallenge with different (low-potency or atypical) antipsychotic; risk of recurrence; (7) Multidisciplinary: psychiatry, ICU, neurology; (8) Education + medical alert documentation

---

Neuroleptic Malignant Syndrome: hyperthermia + rigidity + AMS + autonomic + elevated CK. Stop antipsychotic, ICU, supportive + dantrolene + bromocriptine/amantadine + BZD. ECT for refractory. Distinguish from serotonin syndrome (hyperreflexia/clonus). Wait ≥ 2 wk before rechallenge.', NULL,
  'hard', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'Levenson NMS; Pelonero Crit Care', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ชายไทยอายุ 35 ปี newly initiated haloperidol 10 mg × 3 วัน สำหรับ psychosis — มาด้วย hyperthermia 40°C, severe muscle rigidity (lead-pipe), altered mental status, autonomic instability (BP fluctuating, tachycardia 130, diaphoresis), CK 12,500 (markedly elevated), leukocytosis 18,000

No serotonergic medications, no infection localized'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 60 ปี chronic schizophrenia × 25 ปี on haloperidol long-term — ขณะนี้ มี involuntary movements: choreoathetoid movements of tongue + face (lip smacking, tongue protrusion, chewing) + occasional finger movements — present ≥ 6 เดือน, ผู้ป่วยรู้ตัว, ขัดต่อการกินอาหาร

DISCUS/AIMS score elevated
No recent dose change', '[{"label":"A","text":"Anticholinergic to treat TD"},{"label":"B","text":"Tardive Dyskinesia (TD"},{"label":"C","text":"Higher dose haloperidol"},{"label":"D","text":"Surgery"},{"label":"E","text":"No treatment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Tardive Dyskinesia (TD — late-onset, persistent involuntary movement after chronic antipsychotic exposure; typical > atypical, female, elderly, long duration, mood disorder, DM): (1) Reassess need for antipsychotic; switch from typical to atypical (lower TD risk) — but discontinuing antipsychotic may unmask TD initially (withdrawal dyskinesia); cautious dose reduction; (2) VMAT2 inhibitors (FDA approved 2017 — first effective TD treatment): - **Valbenazine** (Ingrezza) 40-80 mg/day; - **Deutetrabenazine** (Austedo) 24-48 mg/day; - mechanism: reversibly inhibit vesicular monoamine transporter → reduce dopamine release; side effects: somnolence, parkinsonism, depression/SI, QTc; (3) Clozapine — lower TD risk + treats TD in some patients; consider switch for severe TD + treatment-resistant schizophrenia; (4) Older agents historically: benzodiazepines, vitamin E (modest), ginkgo biloba (limited); (5) Anticholinergic — does NOT help TD (helps acute dystonia + EPS — different mechanism); may worsen TD; (6) Monitoring: AIMS scale every 6 mo on antipsychotic; (7) Prevention: lowest effective dose, atypical preference, monitor; (8) Education + informed consent before initiating long-term antipsychotic; (9) Multidisciplinary; (10) TD often irreversible — early detection + treatment important

---

Tardive Dyskinesia: late-onset, persistent. Risk: typical, elderly, female, duration, mood. VMAT2 inhibitors (valbenazine, deutetrabenazine) FDA approved 2017. Switch to atypical/clozapine. AIMS monitoring. Anticholinergic does NOT help TD (worsens). Often irreversible.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'Caroff TD; AAN TD Guideline; FDA VMAT2', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 60 ปี chronic schizophrenia × 25 ปี on haloperidol long-term — ขณะนี้ มี involuntary movements: choreoathetoid movements of tongue + face (lip smacking, tongue protrusion, chewing) + occasional finger movements — present ≥ 6 เดือน, ผู้ป่วยรู้ตัว, ขัดต่อการกินอาหาร

DISCUS/AIMS score elevated
No recent dose change'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 22 ปี เริ่ม haloperidol 10mg IM ใน ED สำหรับ agitation — 6 ชั่วโมงต่อมามาด้วย sudden onset painful sustained muscle contractions: torticollis + oculogyric crisis (eyes deviated upward + fixed) + jaw rigidity + slight respiratory distress

Vitals stable, no fever
MSE: alert, distressed but oriented', '[{"label":"A","text":"Continue haloperidol higher dose"},{"label":"B","text":"Acute Dystonia (extrapyramidal side effect — within hours-days of antipsychotic; young male, high-potency typical, IM administration — risk factors)"},{"label":"C","text":"No treatment"},{"label":"D","text":"Anticonvulsant"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Acute Dystonia (extrapyramidal side effect — within hours-days of antipsychotic; young male, high-potency typical, IM administration — risk factors): (1) **Benztropine 1-2 mg IM/IV** or **diphenhydramine 25-50 mg IM/IV** — rapid relief (minutes to 1 h); (2) Continue oral anticholinergic prophylaxis × several days while assessing antipsychotic adjustment; (3) Reduce dose, switch to atypical (lower EPS risk), or change route; (4) Laryngeal dystonia = airway emergency — secure airway + benztropine; (5) Distinguish from: oculogyric crisis (eye-specific dystonia), seizure, tetanus, catatonia, conversion; (6) Differential EPS: - **Acute dystonia** (hours-days, sustained contraction); - **Akathisia** (motor restlessness, urge to move — propranolol, benzodiazepine, mirtazapine, cyproheptadine; reduce antipsychotic); - **Parkinsonism** (tremor, rigidity, bradykinesia — anticholinergic, amantadine; reduce dose; switch atypical); - **Tardive dyskinesia** (late onset — see separate); (7) Education + medical alert; (8) Consider atypical for future to reduce EPS risk; (9) Multidisciplinary

---

Acute Dystonia: hours-days post-antipsychotic. Risk: young male, high-potency typical, IM. Treatment: benztropine or diphenhydramine IM/IV — rapid response. Continue oral prophylaxis. Laryngeal = airway emergency. EPS spectrum: dystonia → akathisia → parkinsonism → TD (late).', NULL,
  'easy', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'APA Schizophrenia Guideline; Stahl', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ชายไทยอายุ 22 ปี เริ่ม haloperidol 10mg IM ใน ED สำหรับ agitation — 6 ชั่วโมงต่อมามาด้วย sudden onset painful sustained muscle contractions: torticollis + oculogyric crisis (eyes deviated upward + fixed) + jaw rigidity + slight respiratory distress

Vitals stable, no fever
MSE: alert, distressed but oriented'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 28 ปี on risperidone 4 mg × 6 เดือน สำหรับ schizophrenia — ขณะนี้ amenorrhea × 4 mo + galactorrhea + decreased libido + breast tenderness

Lab: prolactin 145 ng/mL (normal < 25 ในผู้หญิง); pregnancy test negative; TSH normal
MRI pituitary normal', '[{"label":"A","text":"Increase risperidone"},{"label":"B","text":"Antipsychotic-Induced Hyperprolactinemia (D2 blockade in tuberoinfundibular pathway"},{"label":"C","text":"Add estrogen replacement first-line"},{"label":"D","text":"Surgery on pituitary"},{"label":"E","text":"No action"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Antipsychotic-Induced Hyperprolactinemia (D2 blockade in tuberoinfundibular pathway — risperidone, paliperidone, haloperidol most; aripiprazole partial agonist may LOWER): (1) Verify etiology — rule out pregnancy (must), hypothyroidism, prolactinoma (MRI), medications (other dopamine antagonists, estrogens); (2) Reduce dose if possible while maintaining efficacy; (3) Switch to prolactin-sparing antipsychotic — aripiprazole (partial agonist, often lowers prolactin), quetiapine, olanzapine (less effect), clozapine; (4) Add adjunctive aripiprazole (low-dose) to current antipsychotic — lowers prolactin without losing efficacy; evidence growing; (5) Long-term consequences: amenorrhea + hypoestrogenism → bone loss/osteoporosis (especially long-term + young women), infertility, sexual dysfunction, gynecomastia (men); (6) Bone density monitoring if chronic; calcium + vitamin D; (7) Estrogen replacement controversial — usually not first choice; (8) Reproductive counseling — restoration of fertility + need for contraception when prolactin normalizes; (9) Tamoxifen or bromocriptine NOT routinely used (dopamine agonist may worsen psychosis); (10) Multidisciplinary: psychiatry, endocrinology, gynecology

---

Antipsychotic-induced hyperprolactinemia: D2 blockade tuberoinfundibular. Risperidone, paliperidone, haloperidol highest; aripiprazole partial agonist lowers. Switch to prolactin-sparing or add aripiprazole adjunct. Long-term: bone loss, infertility, sexual dysfunction. Rule out pregnancy, prolactinoma.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'Inder Mol Cell Endocrinol; APA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 28 ปี on risperidone 4 mg × 6 เดือน สำหรับ schizophrenia — ขณะนี้ amenorrhea × 4 mo + galactorrhea + decreased libido + breast tenderness

Lab: prolactin 145 ng/mL (normal < 25 ในผู้หญิง); pregnancy test negative; TSH normal
MRI pituitary normal'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 28 ปี methamphetamine use × 4 ปี (smoked) — มา ED ด้วย acute paranoid psychosis + agitation + tachycardia + hypertension; UDS positive methamphetamine; last use 8 ชั่วโมงก่อน; chronic users — weight loss, dental decay (meth mouth), poor hygiene; family wants treatment

No other substance use
No prior psychiatric hx', '[{"label":"A","text":"High-dose haloperidol monotherapy"},{"label":"B","text":"Stimulant Use Disorder (Methamphetamine) + Substance-Induced Psychosis"},{"label":"C","text":"No treatment"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Stimulant Use Disorder (Methamphetamine) + Substance-Induced Psychosis: (1) Acute management: - Safety + agitation — benzodiazepine (lorazepam) preferred (calms + reduces CV stress) ± low-dose antipsychotic for psychosis; avoid haloperidol high-dose IM only (long QT, sympathetic); - IV fluids, cooling if hyperthermic, monitor for hypertensive emergency, MI, stroke, arrhythmia; - Workup: ECG, troponin if chest pain, CT brain if focal/severe headache; (2) Withdrawal: no acute medical emergency typically; depressive sx, hypersomnia, increased appetite, anhedonia, dysphoria — supportive; suicide risk during withdrawal; (3) Long-term — NO FDA-approved medication for stimulant use disorder (active research — bupropion + naltrexone combination, contingency management most effective behavioral); (4) Behavioral: **Contingency Management** = most evidence-based for stimulant use disorder (rewards for abstinence verified by UDS); CBT, Matrix Model (integrated), motivational interviewing, 12-step (Crystal Meth Anonymous); (5) Stimulant-induced psychosis: usually resolves with abstinence within days-weeks; if persists > 1 mo think primary psychotic disorder; antipsychotic short-term if needed; (6) Comorbid: HIV (sex + injection), HCV, dental, cardiovascular, depression, anxiety; (7) Multidisciplinary: addiction medicine, psychiatry, primary care, infectious disease, dental, social work; (8) Harm reduction: safer use, naloxone if also opioid, HIV testing, fentanyl test strips

---

Stimulant Use Disorder: NO FDA-approved medication. Contingency Management = most evidence-based. CBT + Matrix Model. Acute: benzodiazepine for agitation/CV stress + low-dose antipsychotic. Comorbid HIV, HCV, dental, CV. Psychosis usually resolves with abstinence.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'ASAM Stimulant Use; SAMHSA TIP 33', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ชายไทยอายุ 28 ปี methamphetamine use × 4 ปี (smoked) — มา ED ด้วย acute paranoid psychosis + agitation + tachycardia + hypertension; UDS positive methamphetamine; last use 8 ชั่วโมงก่อน; chronic users — weight loss, dental decay (meth mouth), poor hygiene; family wants treatment

No other substance use
No prior psychiatric hx'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 32 ปี cocaine use disorder × 6 ปี — มา ED ด้วย acute chest pain + diaphoresis + agitation 1 ชั่วโมง หลัง snorting cocaine; ECG ST changes; troponin pending; BP 195/110

No prior MI, smoker
MSE: agitated, anxious', '[{"label":"A","text":"Beta-blocker first-line for HTN"},{"label":"B","text":"AVOID beta-blockers"},{"label":"C","text":"No intervention"},{"label":"D","text":"Surgery only"},{"label":"E","text":"Discharge home"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cocaine-Induced Chest Pain / Possible ACS + Use Disorder: (1) Acute: - **AVOID beta-blockers** (unopposed alpha agonism → worsen vasoconstriction + hypertension); historical controversy, generally avoid alone; - **Benzodiazepine** first-line for agitation + indirectly reduces cardiac strain; - **Nitroglycerin + calcium channel blocker** for chest pain + HTN (verapamil, diltiazem); - **Aspirin** standard; - **Heparin/anticoagulation** as per ACS protocol; - PCI/cath if STEMI or persistent symptoms with troponin elevation; (2) Cocaine vasospasm + accelerated atherosclerosis + thrombosis mechanisms; MI risk × 20-30 within hours of use; (3) Distinguish: ACS (often), aortic dissection (severe ripping pain, BP discrepancy — cocaine increases risk), arrhythmia, anxiety; (4) Long-term: stimulant use disorder treatment — NO FDA-approved; contingency management most effective; CBT, motivational interviewing, 12-step; (5) Behavioral: similar to methamphetamine; (6) Comorbid: cardiovascular damage (cardiomyopathy, accelerated CAD), seizure, stroke, nasal septum (snorting), HIV/HCV (if injection), other substances; (7) Cocaethylene with concurrent alcohol — more cardiotoxic; advise both stop; (8) Naloxone availability — fentanyl-contaminated cocaine increasing; (9) Multidisciplinary: cardiology, addiction medicine, psychiatry

---

Cocaine ACS: AVOID beta-blockers (unopposed alpha). Benzodiazepine + nitroglycerin + CCB + aspirin + anticoagulation. MI risk × 20-30. Cocaethylene with alcohol more cardiotoxic. Long-term: no FDA medication; contingency management.', NULL,
  'hard', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'AHA Cocaine MI; ASAM Stimulants', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ชายไทยอายุ 32 ปี cocaine use disorder × 6 ปี — มา ED ด้วย acute chest pain + diaphoresis + agitation 1 ชั่วโมง หลัง snorting cocaine; ECG ST changes; troponin pending; BP 195/110

No prior MI, smoker
MSE: agitated, anxious'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 50 ปี alprazolam 2 mg QID × 5 ปี (initially for panic, escalated; obtained from multiple doctors) — abrupt cessation 2 วันที่แล้ว — มา ED ด้วย tremor, severe anxiety, insomnia, perceptual disturbance, autonomic hyperactivity (HR 115, BP 165/95, diaphoresis), brief generalized tonic-clonic seizure × 1 ใน ED

No other substance use
UDS: positive benzodiazepine only', '[{"label":"A","text":"Abrupt cessation continue"},{"label":"B","text":"DO NOT"},{"label":"C","text":"Resume same dose immediately"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Benzodiazepine Use Disorder + Severe Withdrawal (seizure-life-threatening; alprazolam especially severe withdrawal — short half-life + high potency): (1) Acute: - **DO NOT** abruptly resume same agent at same dose (lost dependence partial — could overshoot); resume at appropriate equivalent dose; - **Long-acting benzodiazepine substitution** (diazepam or chlordiazepoxide) — easier taper; - Anti-seizure prophylaxis with adequate benzodiazepine; phenobarbital alternative; - ICU monitoring for severe (seizure, autonomic instability, delirium tremens-like syndrome); - IV fluids, monitor electrolytes; (2) Gradual taper — months long; 10-25% reduction every 1-2 weeks; slow at end (small doses cause disproportionate withdrawal); (3) Long-term: - CBT for anxiety + insomnia (replace function of BZD); - SSRI/SNRI for underlying anxiety/depression; - Buspirone, pregabalin alternatives; - Avoid restarting BZD; (4) Behavioral: motivational interviewing, support; (5) Address underlying anxiety/insomnia — usually inadequately treated reason for chronic BZD; (6) Multidisciplinary: addiction medicine, psychiatry, primary care; (7) Education: physiological dependence after chronic use even at therapeutic dose; (8) Beers criteria — avoid BZD elderly; (9) Long-term BZD risks: cognitive impairment, falls/fractures, dementia association (controversial), overdose with opioids (CDC warning)

---

Benzodiazepine Withdrawal: life-threatening (seizure, DT-like). Alprazolam severe (short half-life, high potency). Long-acting substitution (diazepam) + gradual taper over months. Phenobarbital alternative. Underlying anxiety/insomnia — treat with non-BZD long-term (CBT, SSRI, buspirone).', NULL,
  'hard', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'ASAM Sedative Withdrawal; Ashton Manual', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 50 ปี alprazolam 2 mg QID × 5 ปี (initially for panic, escalated; obtained from multiple doctors) — abrupt cessation 2 วันที่แล้ว — มา ED ด้วย tremor, severe anxiety, insomnia, perceptual disturbance, autonomic hyperactivity (HR 115, BP 165/95, diaphoresis), brief generalized tonic-clonic seizure × 1 ใน ED

No other substance use
UDS: positive benzodiazepine only'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'วัยรุ่นชายอายุ 17 ปี cannabis daily × 2 ปี (high-potency dabs concentrate) — declining school performance, decreased motivation, social withdrawal, irritability เมื่อ cannot use; cannabis-induced anxiety + transient psychotic-like sx เกิดบางครั้ง — parents brought for evaluation

No other substance use
No prior psychiatric hx
MSE: alert, somewhat amotivated, no acute psychosis', '[{"label":"A","text":"No treatment — cannabis is harmless"},{"label":"B","text":"Cannabis Use Disorder (DSM-5"},{"label":"C","text":"Long-term benzodiazepine"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Cannabis Use Disorder (DSM-5: ≥ 2/11 criteria within 12 mo) — adolescent + heavy use + high-potency: (1) NO FDA-approved medication for cannabis use disorder — supportive + behavioral; (2) **Behavioral first-line**: - Motivational Enhancement Therapy + CBT + Contingency Management combination most effective; - Adolescent-specific: Family-based (Multidimensional Family Therapy — MDFT), CRAFT, A-CRA; - 12-step (Marijuana Anonymous, NA); (3) Address comorbidity: anxiety (common — cannabis-induced + underlying), depression, ADHD (high comorbidity), other substance use, conduct disorder, learning issues, school problems; (4) Withdrawal syndrome (recognized DSM-5): irritability, anxiety, sleep disturbance, decreased appetite, restlessness, depressed mood — peaks day 2-6, resolves 1-2 weeks; supportive (sleep hygiene, exercise, hydration, distraction); off-label gabapentin, NAC studied; (5) Education: - High-potency concentrates (dabs, wax) → higher addiction + psychosis risk; - Cannabis-induced psychosis + risk of conversion to schizophrenia (especially with family hx, early use, high potency); - Adolescent brain effects (executive function, memory, motivation); - Cognitive impairment may partially reverse with abstinence; (6) Family involvement essential for adolescent; (7) School-based intervention; (8) Long-term: ~ 9% adult users develop dependence; ~ 17% if start in adolescence; (9) Multidisciplinary

---

Cannabis Use Disorder: NO FDA-approved medication. Behavioral (MET + CBT + Contingency Management) first-line. Adolescent: family-based (MDFT). Withdrawal syndrome real (DSM-5). High-potency concentrates ↑ psychosis + addiction. Adolescent brain effects + psychosis risk.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'peds',
  'ASAM Cannabis; AACAP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'วัยรุ่นชายอายุ 17 ปี cannabis daily × 2 ปี (high-potency dabs concentrate) — declining school performance, decreased motivation, social withdrawal, irritability เมื่อ cannot use; cannabis-induced anxiety + transient psychotic-like sx เกิดบางครั้ง — parents brought for evaluation

No other substance use
No prior psychiatric hx
MSE: alert, somewhat amotivated, no acute psychosis'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 25 ปี acute presentation — agitated, paranoid, dissociated, hypertensive (BP 180/105), HR 110, mydriasis, vertical + horizontal nystagmus, ataxia; reports using ''crystal'' (ketamine + PCP analog); intermittent violence + unpredictable behavior

UDS: positive PCP
No trauma evident', '[{"label":"A","text":"High-dose haloperidol IM monotherapy"},{"label":"B","text":"Phencyclidine (PCP) Intoxication"},{"label":"C","text":"Discharge home"},{"label":"D","text":"Surgery"},{"label":"E","text":"Beta-blocker first-line"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Phencyclidine (PCP) Intoxication — Dangerous (unpredictable violence, dissociative anesthetic, anti-NMDA): (1) Safety — staff + patient — restraint if needed, low stimulation environment (''talk down'' may not work, unlike LSD); (2) Benzodiazepine first-line for agitation (lorazepam, midazolam); avoid antipsychotic acutely if possible (PCP can lower seizure threshold + extrapyramidal risk); haloperidol can be used if needed; (3) Supportive: monitor BP, cardiac, temperature (hyperthermia possible), urine output (rhabdomyolysis); IV fluids; acidification of urine NOT recommended (myoglobinuric AKI risk); (4) Workup: ECG, CK, urinalysis, electrolytes, CT head if trauma/seizure/focal; (5) Distinguishing from other agitated presentations: nystagmus (especially vertical) + dissociation + violence cluster suggests PCP/ketamine; (6) Hallucinogen use disorder: NO FDA-approved meds; behavioral + supportive; (7) Hallucinogen Persisting Perception Disorder (HPPD) — recurrent perceptual disturbances (visual snow, flashes) — rare; (8) Long-term: PCP psychotic features can persist weeks-months; address ongoing psychosis with antipsychotic; (9) Modern emerging: psilocybin + LSD therapeutic research (controlled settings) — distinguish from recreational misuse; ketamine medical use (depression, anesthesia) vs recreational; (10) Comorbidity assessment, harm reduction, multidisciplinary

---

PCP Intoxication: unpredictable violence + dissociation + vertical nystagmus + HTN. Benzodiazepine first-line for agitation. Low stimulation. AVOID urine acidification (rhabdo + AKI). Hallucinogen Use Disorder: no FDA medication; behavioral. HPPD rare persistent.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'ASAM Hallucinogens; UpToDate PCP', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ชายไทยอายุ 25 ปี acute presentation — agitated, paranoid, dissociated, hypertensive (BP 180/105), HR 110, mydriasis, vertical + horizontal nystagmus, ataxia; reports using ''crystal'' (ketamine + PCP analog); intermittent violence + unpredictable behavior

UDS: positive PCP
No trauma evident'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 45 ปี smokes 1.5 packs/day × 25 ปี — ต้องการเลิก, prior attempts failed (relapsed within weeks); morning craving + craving with coffee + after meals strong; HSI score high; comorbid HTN, beginning COPD; ไม่มี active psychiatric disorder

Motivated, family support, no contraindications', '[{"label":"A","text":"Cold turkey without support"},{"label":"B","text":"First-line pharmacotherapy"},{"label":"C","text":"E-cigarettes as long-term replacement"},{"label":"D","text":"Surgery"},{"label":"E","text":"No treatment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Tobacco Use Disorder — Comprehensive Smoking Cessation: (1) Combination behavioral + pharmacotherapy = most effective; (2) **First-line pharmacotherapy** (FDA approved): - **Varenicline** (Chantix) — partial agonist α4β2 nicotinic; most effective single agent; start 1 wk before quit date, titrate to 1mg BID × 12 wk (extend if needed); side effects: nausea, vivid dreams, sleep disturbance, neuropsychiatric warning removed (EAGLES trial reassured); reduces craving + reduces reward; - **Nicotine Replacement Therapy (NRT)** — patch + short-acting (gum, lozenge, inhaler, nasal spray) combination superior to single; safe in most CV disease; can start before quit date; - **Bupropion SR** — dopaminergic + noradrenergic; effective; reduces craving + weight gain; AVOID seizure history, eating disorders; (3) Combination — varenicline + NRT OR varenicline + bupropion = superior to single (some studies); (4) **Behavioral first-line**: - Brief counseling at every healthcare visit (5As: Ask, Advise, Assess, Assist, Arrange); - Quitlines (1-800-QUIT-NOW), text messaging programs (SmokefreeTXT), apps, web programs; - Group counseling, individual; - Motivational interviewing; (5) Address triggers + replacements + coping; (6) Treatment duration ≥ 12 weeks; extended (6 mo) reduces relapse; (7) **Special populations**: - Pregnancy — NRT cautiously (preferred over smoking); behavioral primary; - Psychiatric — varenicline safe per EAGLES; address depression + anxiety; high smoking rates in mental illness (50-90%); - Adolescents — behavioral + cautious NRT; (8) Address e-cigarettes / vaping — not approved smoking cessation; harm reduction debate; nicotine-containing; respiratory effects; (9) Comorbidity: CV disease, COPD, cancer screening; (10) Multidisciplinary: primary care, pulmonology, psychiatry if comorbid

---

Tobacco Use Disorder: combination behavioral + pharmacotherapy most effective. Varenicline most effective single agent (EAGLES safety reassured). NRT combination (patch + short-acting). Bupropion. Counseling at every visit (5As). Special: pregnancy, psychiatric (high comorbid), adolescent.', NULL,
  'easy', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'USPSTF; Cochrane Varenicline; EAGLES', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ชายไทยอายุ 45 ปี smokes 1.5 packs/day × 25 ปี — ต้องการเลิก, prior attempts failed (relapsed within weeks); morning craving + craving with coffee + after meals strong; HSI score high; comorbid HTN, beginning COPD; ไม่มี active psychiatric disorder

Motivated, family support, no contraindications'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'วัยรุ่นชายอายุ 14 ปี — มา ED ด้วย sudden cardiac arrest at gathering; resuscitated; admits inhaling toluene from spray cans ''huffing'' × past year; school problems, low SES, easy access to inhalants

Lab: hepatic enzymes elevated, mild renal dysfunction, anion gap metabolic acidosis
Mother concerned', '[{"label":"A","text":"No treatment"},{"label":"B","text":"Inhalant Use Disorder"},{"label":"C","text":"Catecholamines for cardiac arrest"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Inhalant Use Disorder — High Morbidity + Mortality (Sudden Sniffing Death — cardiac arrhythmia; multi-organ toxicity): (1) Acute: monitor cardiac (arrhythmia — sensitization to catecholamines), respiratory, neurological (encephalopathy), hepatic, renal; supportive; (2) AVOID catecholamines (epinephrine sensitization with inhalants → arrhythmia) — use beta-blocker for arrhythmia in this setting (atypical from cocaine context); (3) NO FDA-approved medication; (4) Behavioral first-line: family-based + CBT + school + community intervention; address access; (5) Comorbidity: conduct disorder, ADHD, depression, substance use, trauma, low SES; (6) Long-term toxicity: leukoencephalopathy (white matter — toluene), peripheral neuropathy, cerebellar dysfunction, hepatorenal, hearing loss, bone marrow (benzene); (7) Adolescent + pediatric population predominantly; access (household products); (8) Education + prevention essential — community-level intervention; (9) Family + social work involvement; (10) Multidisciplinary: pediatrics, psychiatry, neurology, social work, school personnel; (11) Mortality reduction through harm reduction + abstinence

---

Inhalant Use Disorder: ''huffing'' — Sudden Sniffing Death (arrhythmia). AVOID catecholamines (sensitization). Multi-organ toxicity (CNS leukoencephalopathy, hepatorenal). NO FDA medication. Adolescent — family + school + community. Address access.', NULL,
  'hard', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'peds',
  'ASAM Inhalants; SAMHSA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'วัยรุ่นชายอายุ 14 ปี — มา ED ด้วย sudden cardiac arrest at gathering; resuscitated; admits inhaling toluene from spray cans ''huffing'' × past year; school problems, low SES, easy access to inhalants

Lab: hepatic enzymes elevated, mild renal dysfunction, anion gap metabolic acidosis
Mother concerned'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 28 ปี nyu admitted ระหว่าง legal proceedings for assault — history of multiple arrests since age 16, repeated lying, irresponsible (frequently fired), aggressive (multiple fights), reckless (DUI × 3), no remorse for harm caused — childhood: conduct disorder before 15 yo

No psychosis, no mood disorder; substance use comorbid (alcohol, cocaine)
DSM-5 ASPD criteria met', '[{"label":"A","text":"Punishment alone"},{"label":"B","text":"Antisocial Personality Disorder (DSM-5"},{"label":"C","text":"No treatment"},{"label":"D","text":"Cure with single intervention"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Antisocial Personality Disorder (DSM-5: pervasive disregard for + violation of rights of others since age 15 + ≥ 3 of 7 criteria + conduct disorder before age 15 + age ≥ 18 + not solely during schizophrenia/BP): (1) Challenging to treat — limited evidence + low treatment engagement; (2) Approach realistic expectations + boundaries; (3) Treat comorbidity: substance use disorder (very high comorbid — focus often more productive), depression, anxiety; (4) Psychotherapy: - CBT for specific behaviors (anger management, impulse control); - Schema-focused therapy + MBT studied; - Therapeutic communities; - Avoid expectation of full personality change; - Focus on behavioral outcomes (reduced violence, substance use, employment); (5) Medication targets specific symptoms — no medication for ASPD itself: - SSRI for impulsivity, aggression (moderate); - Mood stabilizer for aggression; - Atypical antipsychotic for severe aggression; - AVOID benzodiazepine + stimulants (disinhibition + abuse); (6) Forensic considerations — legal involvement common; competency, sentencing, supervision; assess violence risk (HCR-20, VRAG); (7) Distinguish: - Conduct disorder (< 18); - Psychopathy (overlap, Hare PCL-R, more severe); - Narcissistic PD (lacks ASPD childhood conduct disorder); - Substance-induced (resolves with sobriety); (8) Long-term: chronic; some ''burnout'' with age — reduced criminality after 40s; (9) Multidisciplinary including criminal justice + family + employment; (10) Provider safety + self-care — engagement can be exhausting

---

Antisocial PD: pervasive violation of rights + childhood conduct disorder. Treat comorbid substance use (often more productive). CBT for specific behaviors. Medication targets symptoms (no medication for ASPD itself). AVOID BZD + stimulants. Forensic risk assessment. Realistic expectations.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'DSM-5-TR; Hare PCL-R', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ชายไทยอายุ 28 ปี nyu admitted ระหว่าง legal proceedings for assault — history of multiple arrests since age 16, repeated lying, irresponsible (frequently fired), aggressive (multiple fights), reckless (DUI × 3), no remorse for harm caused — childhood: conduct disorder before 15 yo

No psychosis, no mood disorder; substance use comorbid (alcohol, cocaine)
DSM-5 ASPD criteria met'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 45 ปี executive — มา OPD ตาม spouse''s insistence; pattern × decades — grandiosity, need for admiration, lack of empathy, sense of entitlement, exploits relationships for own gain, envy + believes others envy him, arrogant; recent failures + marriage in crisis triggered moderate depression (PHQ-9 14)

No psychosis, no manic episodes', '[{"label":"A","text":"Confront grandiosity directly"},{"label":"B","text":"Narcissistic Personality Disorder (DSM-5"},{"label":"C","text":"No treatment"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Narcissistic Personality Disorder (DSM-5: pervasive grandiosity + need for admiration + lack of empathy + ≥ 5/9 criteria): (1) Treatment engagement often poor (denial, externalization); (2) Address presenting concern (depression here) — entry point + alliance; (3) Psychotherapy long-term: - Psychodynamic (Kohut Self-Psychology, Kernberg, TFP — Transference-Focused Psychotherapy); - Schema-focused; - CBT for specific symptoms; - Mentalization-Based Treatment (MBT); - Therapeutic alliance challenging — narcissistic injury common; (4) Address: relationship pattern, work issues, anger management, empathy development, vulnerability tolerance; (5) Subtypes: - **Grandiose** (overt, exhibitionist — classical); - **Vulnerable** (covert, hypersensitive, depression, shame-prone) — more common presentation in clinical setting; (6) Comorbidity: depression (especially with life setbacks, narcissistic injury), substance use, anxiety, other PDs; (7) Medication: target symptoms (SSRI for depression, anxiety); no medication for NPD itself; (8) Suicide risk — narcissistic injury + depression elevated; (9) Couples/family therapy often helpful — relationship dimension prominent; (10) Long-term — chronic, gradual change possible; some improvement with age + maturation; (11) Provider self-awareness — countertransference (idealization → devaluation cycle)

---

Narcissistic PD: grandiosity + need for admiration + lack of empathy. Engagement through presenting concern. Long-term psychotherapy (Kohut, Kernberg, TFP, schema). Grandiose vs vulnerable subtypes. Suicide risk with injury. No specific medication. Countertransference common.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'DSM-5-TR; Kernberg; Kohut', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ชายไทยอายุ 45 ปี executive — มา OPD ตาม spouse''s insistence; pattern × decades — grandiosity, need for admiration, lack of empathy, sense of entitlement, exploits relationships for own gain, envy + believes others envy him, arrogant; recent failures + marriage in crisis triggered moderate depression (PHQ-9 14)

No psychosis, no manic episodes'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 30 ปี × lifelong — avoids social/occupational activities requiring interpersonal contact, unwilling to engage unless certain of being liked, restraint in intimate relationships, preoccupied with criticism + rejection, views self as socially inept, reluctant to take risks; functional but limited socially + occupationally — entry-level job, no close friends, single

No MDD/psychosis acute
Longstanding pattern since teenage
Attended counseling reluctantly', '[{"label":"A","text":"Forced exposure without preparation"},{"label":"B","text":"Avoidant Personality Disorder (DSM-5"},{"label":"C","text":"No treatment"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Avoidant Personality Disorder (DSM-5: pervasive social inhibition + feelings of inadequacy + hypersensitivity to negative evaluation + ≥ 4/7 criteria): (1) CBT first-line — graded exposure to feared situations (similar to social anxiety), cognitive restructuring of self-views + others'' judgments, behavioral activation, social skills training; (2) Group therapy provides natural exposure; (3) Schema-focused therapy + Dialectical Behavior Therapy adaptations; (4) Mentalization-Based Treatment; (5) SSRI for comorbid social anxiety + depression — common overlap with social anxiety disorder (high; conceptual debate whether separate or severe end of social anxiety spectrum); (6) Comorbidity: social anxiety (very high overlap), depression, other anxiety, substance use; (7) Long-term — chronic; CBT shows durable improvement; (8) Distinguish from: - Social anxiety disorder (overlapping, perhaps continuum); - Schizoid PD (no desire for relationships vs avoidant desires but avoids due to fear); - Dependent PD (clings to relationships); (9) Therapeutic alliance carefully — sensitivity to perceived criticism; (10) Multidisciplinary

---

Avoidant PD: social inhibition + inadequacy + hypersensitivity to evaluation. CBT (graded exposure + cognitive restructuring) first-line. SSRI for comorbid social anxiety. Overlap with social anxiety. Distinguish from schizoid (no desire) + dependent (clings).', NULL,
  'easy', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'DSM-5-TR; Beck PD', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ชายไทยอายุ 30 ปี × lifelong — avoids social/occupational activities requiring interpersonal contact, unwilling to engage unless certain of being liked, restraint in intimate relationships, preoccupied with criticism + rejection, views self as socially inept, reluctant to take risks; functional but limited socially + occupationally — entry-level job, no close friends, single

No MDD/psychosis acute
Longstanding pattern since teenage
Attended counseling reluctantly'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 35 ปี — pattern × adulthood — difficulty making everyday decisions without excessive advice, needs others to assume responsibility, difficulty expressing disagreement, difficulty initiating projects alone, goes to excessive lengths to obtain nurturance/support, feels helpless when alone, urgently seeks new relationship when one ends; in abusive relationship × 10 ปี, cannot leave

MSE: depressed mood, low self-esteem', '[{"label":"A","text":"Continue current dependence"},{"label":"B","text":"Dependent Personality Disorder (DSM-5"},{"label":"C","text":"No treatment"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Dependent Personality Disorder (DSM-5: pervasive + excessive need to be taken care of → submissive + clinging + fears of separation; ≥ 5/8 criteria): (1) Psychotherapy — CBT, psychodynamic, schema-focused — focus on assertiveness training, independent decision-making, building self-efficacy, identifying own preferences/values, healthy relationships; (2) Address abusive relationship — safety planning (separate issue beyond PD), domestic violence resources, gradual empowerment (often complex — patient may resist leaving abuser she depends on); (3) Group therapy provides interpersonal feedback; (4) SSRI for comorbid depression, anxiety, panic (common); (5) Comorbidity: depression, anxiety, somatic, other PDs (especially borderline, avoidant, histrionic); (6) Long-term — chronic; gradual improvement with sustained treatment; (7) Distinguish from: avoidant PD (avoids relationships due to fear vs dependent seeks them desperately), borderline PD (unstable relationships vs dependent clings), histrionic PD (attention-seeking vs nurturance-seeking); (8) Therapeutic relationship — risk of patient becoming dependent on therapist — encourage autonomy; (9) Cultural sensitivity — some interdependence is cultural norm, distinguish pathology; (10) Multidisciplinary including DV resources if applicable

---

Dependent PD: excessive need to be cared for + submissive + clinging + fear of separation. Psychotherapy — assertiveness training, decision-making, self-efficacy. Address abusive relationship (DV resources). SSRI for comorbid depression. Cultural sensitivity.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'DSM-5-TR', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 35 ปี — pattern × adulthood — difficulty making everyday decisions without excessive advice, needs others to assume responsibility, difficulty expressing disagreement, difficulty initiating projects alone, goes to excessive lengths to obtain nurturance/support, feels helpless when alone, urgently seeks new relationship when one ends; in abusive relationship × 10 ปี, cannot leave

MSE: depressed mood, low self-esteem'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 50 ปี high-functioning accountant — มา OPD ด้วย work stress + marital issues; pattern × decades — preoccupied with details/rules/lists, perfectionism interferes with task completion, overly conscientious + scrupulous, unable to discard worn-out objects, reluctance to delegate, miserly, rigid + stubborn — distinct from OCD (no obsessions/compulsions, ego-syntonic)

No true obsessions/compulsions
No significant depression/anxiety currently', '[{"label":"A","text":"Treat as OCD with SSRI high dose + ERP"},{"label":"B","text":"Obsessive-Compulsive Personality Disorder (DSM-5"},{"label":"C","text":"No treatment"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Obsessive-Compulsive Personality Disorder (DSM-5: pervasive preoccupation with orderliness, perfectionism, mental + interpersonal control at expense of flexibility, openness, efficiency; ≥ 4/8 criteria): (1) Distinct from OCD — OCPD is ego-syntonic (patient sees traits as desirable), no specific obsessions/compulsions; OCD ego-dystonic; ~ 20% comorbidity; (2) Psychotherapy: - CBT for specific issues (perfectionism, rigidity, procrastination from over-planning, work-life balance); - Psychodynamic; - Schema-focused; - Address rigidity in relationships, control issues, emotional expression; (3) Couples/family therapy — relational issues prominent; (4) Address comorbid depression (anhedonia, exhaustion from over-conscientiousness); (5) SSRI for comorbid depression/anxiety; (6) Long-term — relatively stable; high functioning often (especially in structured work — may be adaptive in some careers); (7) Distinguish: - OCD (egodystonic, obsessions/compulsions); - Narcissistic PD (entitlement vs OCPD duty-bound); - Autism (social communication deficits); (8) Approach therapeutically — patient often comes for relationship/depression rather than personality complaint; engage gradually with traits; (9) Modern view — perfectionism + control are functional in some contexts, dysfunctional when excessive; help develop flexibility

---

OCPD: pervasive perfectionism + rigidity + control. Ego-syntonic (distinct from OCD ego-dystonic). Psychotherapy + address comorbid depression. Couples therapy. Often high-functioning. SSRI for comorbid only. Distinguish from OCD, narcissistic, autism.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'DSM-5-TR', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ชายไทยอายุ 50 ปี high-functioning accountant — มา OPD ด้วย work stress + marital issues; pattern × decades — preoccupied with details/rules/lists, perfectionism interferes with task completion, overly conscientious + scrupulous, unable to discard worn-out objects, reluctance to delegate, miserly, rigid + stubborn — distinct from OCD (no obsessions/compulsions, ego-syntonic)

No true obsessions/compulsions
No significant depression/anxiety currently'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 38 ปี — chronic — odd beliefs/magical thinking (interprets coincidences as personal signs), unusual perceptual experiences (sees aura around people occasionally), suspicious + mild paranoid ideation, odd speech (vague, circumstantial), constricted affect, no close friends, social anxiety not improving — but no full psychotic episodes

Family hx: brother with schizophrenia
Functional but isolated', '[{"label":"A","text":"High-dose typical antipsychotic"},{"label":"B","text":"Schizotypal Personality Disorder (DSM-5"},{"label":"C","text":"No treatment"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Schizotypal Personality Disorder (DSM-5: pervasive social + interpersonal deficits + cognitive/perceptual distortions + eccentricities; ≥ 5/9 criteria; Cluster A): (1) Considered schizophrenia-spectrum — genetically related; (2) Psychotherapy: - Supportive + social skills training; - CBT for specific symptoms (paranoid ideation, social anxiety); - Avoid intense psychodynamic exploration (may worsen psychotic-like sx); (3) Low-dose atypical antipsychotic (risperidone, aripiprazole) for cognitive-perceptual sx + helps anxiety + social functioning; modest evidence; (4) SSRI for comorbid anxiety + depression — common; (5) Address comorbidity: depression, anxiety, substance use, other PDs (paranoid, schizoid); (6) Distinguish: - Schizophrenia (full psychotic episodes); - Paranoid PD (pervasive distrust but less cognitive/perceptual); - Schizoid PD (lacks interest in relationships, no cognitive/perceptual distortions); - Autism spectrum (social communication deficits, restricted interests vs schizotypal odd beliefs); (7) Long-term — chronic; ~ 25% develop schizophrenia; longitudinal monitoring; (8) Family involvement (genetic counseling, education); (9) Multidisciplinary

---

Schizotypal PD: pervasive social deficit + cognitive-perceptual distortions + eccentricities (Cluster A, schizophrenia-spectrum). Low-dose atypical antipsychotic + SSRI + supportive therapy. ~ 25% develop schizophrenia. Distinguish from schizophrenia, paranoid, schizoid PD, autism.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'DSM-5-TR; Siever Schizotypal', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ชายไทยอายุ 38 ปี — chronic — odd beliefs/magical thinking (interprets coincidences as personal signs), unusual perceptual experiences (sees aura around people occasionally), suspicious + mild paranoid ideation, odd speech (vague, circumstantial), constricted affect, no close friends, social anxiety not improving — but no full psychotic episodes

Family hx: brother with schizophrenia
Functional but isolated'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 50 ปี — lifelong pattern of distrust + suspiciousness of others — interprets benign motives as malicious, doubts loyalty of friends/family, reluctant to confide (fears used against him), holds grudges, perceives attacks on character + reacts angrily; no psychotic episodes, no formal delusions; intact reality testing

No substance use, no other psychiatric
MSE: guarded, suspicious of interviewer; otherwise oriented + logical', '[{"label":"A","text":"Confront paranoid interpretations"},{"label":"B","text":"Paranoid Personality Disorder (DSM-5"},{"label":"C","text":"Long-term benzodiazepine"},{"label":"D","text":"Surgery"},{"label":"E","text":"No treatment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Paranoid Personality Disorder (DSM-5: pervasive distrust + suspiciousness + interpret others'' motives as malevolent; ≥ 4/7 criteria; Cluster A): (1) Treatment engagement challenging — distrust extends to providers; (2) Psychotherapy — supportive + collaborative; reliable + predictable + transparent approach; NEVER confront paranoid interpretations directly (alliance rupture); explore evidence gently with cognitive techniques; (3) Build alliance gradually; (4) Address presenting concerns (relationship issues, work conflict, depression); (5) Medication targets symptoms — SSRI for comorbid depression/anxiety; low-dose atypical antipsychotic for severe paranoid sx without psychosis (limited evidence); (6) AVOID benzodiazepine (disinhibition possible); (7) Comorbidity: depression, anxiety, substance use, other PDs (schizotypal, schizoid, narcissistic, avoidant); (8) Distinguish: - Schizophrenia paranoid type (psychosis, hallucinations, delusions); - Delusional disorder (specific delusion); - Schizotypal PD (cognitive/perceptual distortions); - Antisocial PD (different pattern); (9) Long-term — chronic + stable; gradual improvement with sustained therapy; (10) Provider self-awareness — distrust pattern may evoke defensiveness — maintain professional consistency

---

Paranoid PD: pervasive distrust + suspiciousness (Cluster A). Supportive + collaborative approach; NEVER confront directly. SSRI for comorbid. Build alliance gradually. AVOID BZD. Distinguish from psychosis (no hallucinations/delusions) + schizotypal.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'DSM-5-TR', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ชายไทยอายุ 50 ปี — lifelong pattern of distrust + suspiciousness of others — interprets benign motives as malicious, doubts loyalty of friends/family, reluctant to confide (fears used against him), holds grudges, perceives attacks on character + reacts angrily; no psychotic episodes, no formal delusions; intact reality testing

No substance use, no other psychiatric
MSE: guarded, suspicious of interviewer; otherwise oriented + logical'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 40 ปี IT — มาเมื่อ employer ส่ง เนื่องจากกังวล social withdrawal — lifelong pattern of detachment from relationships, prefers solitary activities, little interest in close relationships (including family), no sexual experiences (no desire), takes pleasure in few activities, appears emotionally cold + indifferent to praise/criticism; high-functioning in independent work

No psychotic features, no cognitive/perceptual distortions
No depression/anxiety', '[{"label":"A","text":"Force social engagement"},{"label":"B","text":"Schizoid Personality Disorder (DSM-5"},{"label":"C","text":"Long-term antipsychotic"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Schizoid Personality Disorder (DSM-5: pervasive detachment from social relationships + restricted range of emotional expression; ≥ 4/7 criteria; Cluster A): (1) Treatment often not sought — patient may not see problem (ego-syntonic); reason for referral usually work/family concern; (2) Respect patient''s preferred level of social engagement — pathologizing introversion is wrong; only intervene if functional impairment + patient distress; (3) Psychotherapy if engaged — supportive, gradual social skills exploration if patient wants; do not force social engagement against preference; (4) Address comorbidity if present (rare): depression, anxiety; (5) Medication targets specific symptoms; no medication for schizoid PD itself; (6) Distinguish: - Avoidant PD (DESIRES relationships but avoids due to fear vs schizoid lacks desire); - Schizotypal PD (cognitive/perceptual distortions); - Autism (social communication deficits, restricted interests vs schizoid emotional detachment without intent); - Normal introversion (preference vs pervasive impairment); (7) Long-term — chronic + stable pattern; (8) Modern: emphasize quality of life by patient''s own values; don''t pathologize introversion; (9) If work requires more interaction — career counseling; (10) Family education + support

---

Schizoid PD: pervasive detachment + restricted emotion (Cluster A). Often ego-syntonic, treatment limited. Respect preference; distinguish from introversion. Distinguish from avoidant (desires relationships), schizotypal (cognitive distortions), autism. No specific medication.', NULL,
  'easy', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'DSM-5-TR', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ชายไทยอายุ 40 ปี IT — มาเมื่อ employer ส่ง เนื่องจากกังวล social withdrawal — lifelong pattern of detachment from relationships, prefers solitary activities, little interest in close relationships (including family), no sexual experiences (no desire), takes pleasure in few activities, appears emotionally cold + indifferent to praise/criticism; high-functioning in independent work

No psychotic features, no cognitive/perceptual distortions
No depression/anxiety'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 32 ปี actress — มา OPD ด้วย depressed mood หลัง breakup; pattern × adulthood — uncomfortable when not center of attention, sexually provocative/seductive interactions, rapidly shifting + shallow emotions, uses physical appearance to draw attention, impressionistic speech style (vague), theatrical + exaggerated emotional expression, suggestible, considers relationships more intimate than they are

MSE: dramatic, flirtatious with interviewer, tearful then laughing quickly', '[{"label":"A","text":"Reinforce attention-seeking"},{"label":"B","text":"Histrionic Personality Disorder (DSM-5"},{"label":"C","text":"Long-term benzodiazepine"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Histrionic Personality Disorder (DSM-5: pervasive + excessive emotionality + attention seeking; ≥ 5/8 criteria; Cluster B): (1) Psychotherapy — psychodynamic (insight into use of dramatic display, dependency), CBT (skills, more meaningful self-presentation), supportive; (2) Group therapy — interpersonal feedback; (3) Address comorbidity: depression (high — narcissistic injury, abandonment), substance use, somatic, conversion sx; (4) SSRI for comorbid depression/anxiety; (5) Therapeutic alliance — patient may seek therapist approval/attention — maintain professional boundaries; (6) Address dependency on others'' attention; develop more genuine connections + self-worth not contingent on attention; (7) Distinguish: - Borderline PD (abandonment fear, identity disturbance, self-harm — overlap exists); - Narcissistic PD (grandiosity + entitlement vs histrionic centrality + attention); - Dependent PD (clings for nurturance); - Antisocial PD (manipulative for gain vs histrionic for attention); (8) Long-term — chronic; some improvement with age; (9) Cultural + gender considerations — emotional expression varies; avoid gender bias in diagnosis; (10) Multidisciplinary; (11) Modern: DSM-5 emphasizes dimensional view — overlap with borderline frequently

---

Histrionic PD: excessive emotionality + attention-seeking (Cluster B). Psychotherapy (psychodynamic, CBT, supportive). Address comorbid depression. SSRI for comorbidity. Distinguish from borderline (overlap), narcissistic, dependent. Cultural + gender considerations.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'DSM-5-TR', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 32 ปี actress — มา OPD ด้วย depressed mood หลัง breakup; pattern × adulthood — uncomfortable when not center of attention, sexually provocative/seductive interactions, rapidly shifting + shallow emotions, uses physical appearance to draw attention, impressionistic speech style (vague), theatrical + exaggerated emotional expression, suggestible, considers relationships more intimate than they are

MSE: dramatic, flirtatious with interviewer, tearful then laughing quickly'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 55 ปี admitted for elective surgery; chronic heavy alcohol use × 30 ปี (5 drinks/day) — last drink 48 ชั่วโมงก่อนเข้า รพ; ขณะนี้ tremor severe, agitation, diaphoresis, HR 130, BP 175/100, fever 38.2°C, visual hallucinations (sees bugs), disorientation, brief generalized seizure × 1

CIWA-Ar 28 (severe)
Lab: K 3.0, Mg 1.3, low phos
No head trauma, no infection', '[{"label":"A","text":"Beta-blocker monotherapy"},{"label":"B","text":"Thiamine 100mg IV BEFORE glucose"},{"label":"C","text":"Phenytoin for seizure prophylaxis"},{"label":"D","text":"Discharge home"},{"label":"E","text":"Antibiotic only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Alcohol Withdrawal — Severe with Delirium Tremens (mortality 5-15% if untreated) — EMERGENCY: (1) ICU monitoring — autonomic instability, seizure, arrhythmia, electrolyte; (2) **Benzodiazepine** — backbone of treatment: - Symptom-triggered (CIWA-Ar based — better outcomes vs fixed schedule); - Diazepam or chlordiazepoxide (long-acting — auto-taper) preferred; - Lorazepam IV/IM if liver impairment (no active metabolites); - Loading dose for severe; phenobarbital if BZD-refractory; - Continuous infusion lorazepam/midazolam ICU if needed; (3) **Thiamine 100mg IV BEFORE glucose** — prevent Wernicke; followed by folate, multivitamin; (4) Correct electrolytes: K, Mg, phos (refeeding-like); (5) IV fluids — maintenance + replacement (cautious — cardiac); (6) Seizure: usually BZD prevents; if active — IV BZD; phenytoin NOT effective for alcohol withdrawal seizures (use BZD); (7) Hallucinations + agitation: BZD primary; low-dose haloperidol adjunct if severely agitated (lowers seizure threshold — caution); (8) Distinguish DTs: hyperactive autonomic, severe tremor, hallucinations (often visual), delirium — peaks 48-96 h post last drink; alcoholic hallucinosis — hallucinations without delirium/autonomic; (9) After acute: AUD treatment (MAT — naltrexone, acamprosate, disulfiram; behavioral; AA); (10) Multidisciplinary: ICU/medicine, psychiatry, addiction medicine

---

Delirium Tremens: mortality 5-15%. ICU + symptom-triggered benzodiazepine (long-acting; lorazepam in liver disease). Thiamine BEFORE glucose. Correct K/Mg/phos. Phenytoin NOT effective for alcohol withdrawal seizure. Peak 48-96h. AUD treatment after acute.', NULL,
  'hard', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'ASAM Alcohol Withdrawal; CIWA-Ar', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ชายไทยอายุ 55 ปี admitted for elective surgery; chronic heavy alcohol use × 30 ปี (5 drinks/day) — last drink 48 ชั่วโมงก่อนเข้า รพ; ขณะนี้ tremor severe, agitation, diaphoresis, HR 130, BP 175/100, fever 38.2°C, visual hallucinations (sees bugs), disorientation, brief generalized seizure × 1

CIWA-Ar 28 (severe)
Lab: K 3.0, Mg 1.3, low phos
No head trauma, no infection'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 60 ปี chronic AUD × 35 ปี — มา ED ด้วย ataxia (wide-based gait, falls), confusion + disorientation, ophthalmoplegia (lateral rectus weakness, nystagmus), peripheral neuropathy; over past months developed inability to form new memories + confabulation

Malnourished, BMI 18
Lab: low albumin, normal B12, MCV 105
MRI: bilateral mammillary body atrophy', '[{"label":"A","text":"Glucose IV first"},{"label":"B","text":"Thiamine 500 mg IV TID × 2 days"},{"label":"C","text":"Low-dose oral thiamine only"},{"label":"D","text":"Surgery"},{"label":"E","text":"Discharge"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Wernicke Encephalopathy + Korsakoff Syndrome (Wernicke-Korsakoff Syndrome — thiamine deficiency; classic triad: ophthalmoplegia + ataxia + confusion — only ~ 30% have all three; Korsakoff = chronic anterograde amnesia + confabulation): (1) **Thiamine 500 mg IV TID × 2 days** — high-dose parenteral; then 250mg IV/IM daily × 5 days; then oral 100mg daily; (2) **BEFORE any IV glucose** — glucose can precipitate Wernicke in thiamine-deficient; even routine IVF dextrose dangerous; (3) Magnesium replacement (thiamine requires Mg as cofactor — coexists in AUD); (4) Multivitamin + folate; (5) Treat underlying AUD — abstinence, MAT, behavioral; (6) Recovery: Wernicke acute features often reversible with prompt thiamine; Korsakoff (chronic memory loss + confabulation) often permanent — only 20% full recovery; (7) Long-term: cognitive rehabilitation, supportive environment, social work, possible nursing home/supported living if severe; (8) Nutritional rehabilitation — broader malnutrition addressed; (9) Other AUD complications screen: liver, cardiac (alcoholic cardiomyopathy), pancreatitis, peripheral neuropathy, cerebellar atrophy, cancer; (10) Multidisciplinary: neurology, internal medicine, psychiatry, addiction medicine, PT/OT, social work, nutrition; (11) Prevention key in AUD population — high-dose thiamine in ED + admission protocols

---

Wernicke-Korsakoff: thiamine deficiency. Triad (ophthalmoplegia, ataxia, confusion) — only 30% all. HIGH-DOSE PARENTERAL thiamine BEFORE glucose (glucose precipitates Wernicke). Korsakoff (chronic memory + confabulation) often permanent. Prevention protocols in AUD.', NULL,
  'hard', 'neurology', 'review',
  'psychiatry', 'clinical_decision', 'neurology', 'adult',
  'EFNS Wernicke; Caine criteria', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ชายไทยอายุ 60 ปี chronic AUD × 35 ปี — มา ED ด้วย ataxia (wide-based gait, falls), confusion + disorientation, ophthalmoplegia (lateral rectus weakness, nystagmus), peripheral neuropathy; over past months developed inability to form new memories + confabulation

Malnourished, BMI 18
Lab: low albumin, normal B12, MCV 105
MRI: bilateral mammillary body atrophy'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 26 ปี (known BPD, in DBT × 6 เดือน) มา ED ด้วย acute crisis หลังทะเลาะกับ partner — overdosed 20 acetaminophen 4 ชั่วโมงก่อน, brought by friend; ขณะนี้ stable medically (acetylcysteine started); ปฏิเสธ admission, wants to leave

Alert, oriented, fluctuating between anger + tearfulness
No psychosis, no SI currently after intervention
Distress over relationship', '[{"label":"A","text":"Discharge against medical advice immediately"},{"label":"B","text":"BPD Crisis with Recent Suicide Attempt — Acute Management"},{"label":"C","text":"Long-term hospitalization"},{"label":"D","text":"Surgery"},{"label":"E","text":"Add benzodiazepine"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** BPD Crisis with Recent Suicide Attempt — Acute Management: (1) **Medical stabilization first** — acetaminophen overdose protocol (NAC, monitor LFT, INR, lactate; transfer to hepatology if hepatotoxicity); (2) **Capacity assessment** — current psychiatric status, impaired by recent attempt; (3) **Brief hospitalization indicated** for safety + acute crisis intervention, NOT for chronic suicidality treatment (extended hospitalization can regress BPD); (4) **DBT skills coaching crisis intervention** if DBT-trained therapist available — between-session coaching protocol; (5) **Coordinate with outpatient DBT therapist** + treatment team; do not undermine existing alliance; (6) Safety planning (Stanley-Brown) — warning signs, internal coping, social distractions, contacts, professional help, means restriction; (7) Identify precipitant (relationship conflict) + DBT skills (distress tolerance, interpersonal effectiveness); (8) Brief intervention rather than rehospitalization for chronic suicidality (long admission may worsen); (9) Outpatient follow-up within 24-48 hours; (10) Address means restriction — limit access to medications, large quantities; (11) Family/partner education + support; (12) AVOID adding new medications during crisis unless indicated; benzodiazepines avoid (disinhibition); SSRI continuation; (13) Document carefully; (14) Multidisciplinary; (15) Distinguish chronic from acute risk change — distinct intervention strategies

---

BPD crisis: brief hospitalization for safety, NOT extended (regression). DBT coaching + coordinate outpatient therapist. Safety planning + means restriction. AVOID BZD (disinhibition). Distinguish acute change from chronic suicidality. Follow-up 24-48h.', NULL,
  'hard', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'Linehan DBT; APA Borderline', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 26 ปี (known BPD, in DBT × 6 เดือน) มา ED ด้วย acute crisis หลังทะเลาะกับ partner — overdosed 20 acetaminophen 4 ชั่วโมงก่อน, brought by friend; ขณะนี้ stable medically (acetylcysteine started); ปฏิเสธ admission, wants to leave

Alert, oriented, fluctuating between anger + tearfulness
No psychosis, no SI currently after intervention
Distress over relationship'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 30 ปี BPD + comorbid AUD + bulimia nervosa + chronic SI + history of trauma (childhood sexual abuse) — มา OPD เพื่อ comprehensive treatment planning

Unstable housing, intermittent employment
Failed standard CBT × 2 prior
Mother supportive, sister has similar issues', '[{"label":"A","text":"Single specialist treatment"},{"label":"B","text":"Complex BPD + Comorbidities — Integrated Multidisciplinary Approach"},{"label":"C","text":"Long-term benzodiazepine"},{"label":"D","text":"Surgery"},{"label":"E","text":"No treatment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Complex BPD + Comorbidities — Integrated Multidisciplinary Approach: (1) **DBT** as primary modality — addresses BPD core + SI + emotion regulation; comprehensive program (skills group + individual therapy + phone coaching + consultation team); (2) **Address trauma** — once stabilized (DBT Stage 2 — trauma-focused work after behavioral stabilization in Stage 1); PE, CPT, EMDR for PTSD; (3) **AUD** — integrated dual diagnosis treatment (separate treatment historically less effective); MAT (naltrexone particularly — affects reward + emotion regulation, FDA approved AUD); concurrent with mental health treatment; AA optional; (4) **Bulimia** — CBT-E (Enhanced) ideal; combined with DBT may be needed; SSRI fluoxetine (FDA approved); nutritional support; medical monitoring (electrolytes, dental, cardiac); (5) **Medication adjuncts**: SSRI (depression, anxiety, bulimia), low-dose mood stabilizer (lamotrigine — emotion regulation), low-dose atypical antipsychotic (severe affective + cognitive sx); AVOID benzodiazepines (disinhibition + AUD); AVOID stimulants; (6) **Social determinants**: housing (Housing First model), employment (supported employment), legal, financial; (7) **Family education + family DBT** if available; sister assessment + treatment; (8) **Trauma-informed care** throughout; (9) **Crisis planning**: ED, hotline, friends/family, therapist coaching; (10) **Long-term** — treatment is years; gradual improvement; 50% BPD remit at 10 yr; (11) Multidisciplinary: DBT therapist, psychiatrist, addiction medicine, eating disorder specialist, primary care, social work, peer support

---

Complex BPD: integrated treatment. DBT primary + trauma-focused (after stabilization) + integrated dual diagnosis (AUD + bulimia) + medication adjuncts + social determinants + trauma-informed. AVOID BZD + stimulants. Multidisciplinary, long-term. 50% remit at 10 yr.', NULL,
  'hard', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'Linehan DBT; ASAM Dual Diagnosis', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 30 ปี BPD + comorbid AUD + bulimia nervosa + chronic SI + history of trauma (childhood sexual abuse) — มา OPD เพื่อ comprehensive treatment planning

Unstable housing, intermittent employment
Failed standard CBT × 2 prior
Mother supportive, sister has similar issues'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 22 ปี × 3 ปี — recurrent binge eating (large quantity + loss of control) + compensatory behaviors (self-induced vomiting, laxatives) ≥ 1×/wk × 6 เดือน; weight: BMI 22 (normal); shape + weight overly influence self-evaluation

Lab: K 3.0, mild metabolic alkalosis, dental erosion, parotid swelling, Russell''s sign (knuckle calluses)
No binge/purge during AN episode', '[{"label":"A","text":"Bupropion first-line"},{"label":"B","text":"Bulimia Nervosa (DSM-5: binge + inappropriate compensatory ≥ 1×/wk × 3 mo + self-evaluation overly influenced + not exclusively during AN)"},{"label":"C","text":"No treatment"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic only"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Bulimia Nervosa (DSM-5: binge + inappropriate compensatory ≥ 1×/wk × 3 mo + self-evaluation overly influenced + not exclusively during AN): (1) **CBT-E (Enhanced CBT) for eating disorders** = first-line — gold standard for BN; (2) **Fluoxetine 60 mg/day** — FDA-approved for BN; higher dose than depression; reduces binge + purge frequency; (3) **Combination CBT + fluoxetine** for severe/incomplete response; (4) IPT alternative — slower onset; DBT for emotion regulation; (5) Nutritional rehabilitation + regular eating pattern; reduce dietary restriction → reduces binge cycle; (6) Address medical complications: - Electrolytes (hypokalemia → cardiac arrhythmia); - Dental erosion + parotitis (acid exposure); - Esophagitis, Mallory-Weiss tears; - Ipecac toxicity (cardiomyopathy historical); - Laxative abuse → bowel dysfunction; (7) Comorbidity high: depression, anxiety, substance use, BPD, OCD, PTSD; (8) Family-based treatment (FBT) for adolescents — also effective; (9) AVOID: bupropion (seizure risk in eating disorders); benzodiazepine; (10) Long-term: 50-70% recovery; relapse common; maintenance + relapse prevention; (11) Multidisciplinary: psychiatry, eating disorder specialist therapist, dietitian, primary care, dental

---

Bulimia Nervosa: binge + compensatory + body image. CBT-E first-line. Fluoxetine 60mg FDA approved. Combination for severe. Address electrolytes + dental. AVOID bupropion (seizure). Multidisciplinary.', NULL,
  'easy', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'APA Eating Disorders 2023; CBT-E Fairburn', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 22 ปี × 3 ปี — recurrent binge eating (large quantity + loss of control) + compensatory behaviors (self-induced vomiting, laxatives) ≥ 1×/wk × 6 เดือน; weight: BMI 22 (normal); shape + weight overly influence self-evaluation

Lab: K 3.0, mild metabolic alkalosis, dental erosion, parotid swelling, Russell''s sign (knuckle calluses)
No binge/purge during AN episode'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'หญิงไทยอายุ 38 ปี × 5 ปี — recurrent binge eating (large quantity + loss of control + eats rapidly, until uncomfortably full, when not hungry, alone due to embarrassment, disgust after) ≥ 1×/wk × 6 เดือน — NO compensatory behaviors

BMI 35 (obese), comorbid HTN, dyslipidemia, T2DM
Shame + distress about binges', '[{"label":"A","text":"Bariatric surgery without treatment"},{"label":"B","text":"Binge Eating Disorder (DSM-5: recurrent binge + ≥ 3 features + ≥ 1×/wk × 3 mo + marked distress + NO compensatory behaviors)"},{"label":"C","text":"No treatment"},{"label":"D","text":"Long-term benzodiazepine"},{"label":"E","text":"Bupropion first-line"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Binge Eating Disorder (DSM-5: recurrent binge + ≥ 3 features + ≥ 1×/wk × 3 mo + marked distress + NO compensatory behaviors): (1) **CBT-E** for BED = first-line; reduces binge frequency + improves comorbidity; (2) **Lisdexamfetamine (Vyvanse) 30-70 mg/day** — FDA approved for BED (only stimulant approved); reduces binge episodes; monitor CV, abuse potential; (3) **Topiramate** — reduces binges + weight; cognitive side effects + kidney stones; (4) **SSRI** — modest benefit; for comorbid depression/anxiety; (5) Behavioral weight loss programs combined with CBT-BED (vs alone); (6) IPT, DBT alternatives; (7) Address obesity comorbidity: T2DM, HTN, dyslipidemia, OSA, MASLD; weight loss medications considered (semaglutide, etc. — emerging evidence with BED); bariatric surgery requires careful BED screening (BED is NOT contraindication but requires treatment + ongoing monitoring); (8) Comorbidity: depression, anxiety, substance use, ADHD (common — addressed by lisdexamfetamine partially); (9) Group therapy + support; (10) Long-term: chronic with relapses; maintenance; (11) Distinguish from BN (no compensatory) + obesity without binge eating; (12) Multidisciplinary: psychiatry, dietitian, primary care, possibly bariatric, exercise specialist

---

Binge Eating Disorder: binge + distress + NO compensatory. CBT-E first-line. Lisdexamfetamine FDA approved. Topiramate. Treat obesity comorbidity. BED screening before bariatric surgery. Multidisciplinary.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'APA Eating Disorders 2023; FDA lisdexamfetamine BED', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'หญิงไทยอายุ 38 ปี × 5 ปี — recurrent binge eating (large quantity + loss of control + eats rapidly, until uncomfortably full, when not hungry, alone due to embarrassment, disgust after) ≥ 1×/wk × 6 เดือน — NO compensatory behaviors

BMI 35 (obese), comorbid HTN, dyslipidemia, T2DM
Shame + distress about binges'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 11 ปี — significant weight loss + failure to gain expected weight × 18 เดือน + nutritional deficiency (iron, vitamin D) + dependence on supplements — restriction based on sensory characteristics (texture, smell — only eats white foods, soft textures) + lack of interest in eating, NOT due to body image concerns

No body image disturbance, no fear of weight gain
Autism spectrum traits present
No medical cause identified', '[{"label":"A","text":"Force feeding"},{"label":"B","text":"Avoidant/Restrictive Food Intake Disorder (ARFID"},{"label":"C","text":"No treatment"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Avoidant/Restrictive Food Intake Disorder (ARFID — DSM-5 2013 new dx; food avoidance/restriction → weight loss / nutritional deficiency / feeding tube dependence / psychosocial impairment + NOT due to body image or AN/BN): (1) Multidisciplinary treatment essential — pediatrics, child psychiatry, dietitian, feeding therapist, OT, family therapy; (2) Subtypes: - Sensory (texture, taste, smell aversion — common with autism); - Lack of interest (low appetite/drive); - Fear of aversive consequences (choking, vomiting fear after event); (3) Feeding therapy / behavioral: - Sensory-based exposure (graduated exposure to new textures/flavors); - Systematic desensitization; - Positive reinforcement; - Parent training + meal structure; - Family-based treatment adapted for ARFID; (4) CBT for ARFID (older children + adolescents); (5) Address comorbidity: anxiety (very common), autism spectrum (common), ADHD, OCD; (6) Medication: limited evidence; SSRI for comorbid anxiety/OCD; mirtazapine appetite stimulation off-label; cyproheptadine appetite stimulation; (7) Nutritional rehabilitation + supplementation; (8) Long-term: chronic course with sensory subtype + autism; gradual broadening of diet; (9) Distinguish from picky eating (normal developmental, no medical/psychosocial impairment); (10) Address feeding tube weaning if applicable

---

ARFID (DSM-5 2013): food restriction NOT due to body image → weight/nutrition/psychosocial impairment. Subtypes: sensory, lack of interest, fear of consequences. Multidisciplinary feeding therapy + behavioral. Address comorbid autism/anxiety. Distinguish from picky eating.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'peds',
  'DSM-5-TR; Thomas ARFID', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'เด็กชายอายุ 11 ปี — significant weight loss + failure to gain expected weight × 18 เดือน + nutritional deficiency (iron, vitamin D) + dependence on supplements — restriction based on sensory characteristics (texture, smell — only eats white foods, soft textures) + lack of interest in eating, NOT due to body image concerns

No body image disturbance, no fear of weight gain
Autism spectrum traits present
No medical cause identified'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 6 ปี + autism spectrum + intellectual disability — eating non-nutritive substances (dirt, paint chips, fabric, hair) × 1 ปี — developmentally inappropriate; mother concerned; recent elevated blood lead level

Lab: Hgb 9 (low — iron deficient), Pb 22 μg/dL (elevated)
Dental damage
No evidence of malnutrition', '[{"label":"A","text":"No treatment"},{"label":"B","text":"Lead poisoning workup + treatment"},{"label":"C","text":"Punishment"},{"label":"D","text":"Surgery"},{"label":"E","text":"SSRI alone"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Pica (DSM-5: persistent eating non-nutritive non-food substances ≥ 1 mo + developmentally inappropriate + not culturally sanctioned): (1) Medical evaluation + treatment: - **Lead poisoning workup + treatment** (chelation if severe — succimer, EDTA per Pb level + age); environmental abatement; - Iron deficiency (often comorbid — may drive pica per ''iron deficiency hypothesis''); supplement; - Parasitic infection (geophagia → helminthiasis); - Dental injury, intestinal obstruction/perforation, electrolyte imbalance, infections; (2) Behavioral interventions: - Functional analysis (sensory, attention, escape, automatic); - Environment management (remove access to ingested substances); - Differential reinforcement (preferred items contingent on not eating non-food); - Response interruption + redirection; - Pediatric/developmental behavioral specialists; (3) Comorbidity: autism, intellectual disability, schizophrenia, OCD, trichophagia/trichobezoar; (4) Common in pregnancy (geophagia, ice — pagophagia) — usually transient + benign if not toxic substance; (5) Iron + zinc supplementation in some cases; (6) Family education + safety; (7) Long-term: often resolves in childhood; persistent with autism/ID; (8) Multidisciplinary: pediatrics, child psychiatry, behavioral therapist, developmental specialist, family

---

Pica: persistent non-food ingestion. Medical eval (lead, iron, parasites, GI). Behavioral functional analysis. Common with autism/ID. Iron deficiency may drive (hypothesis). Pregnancy variant. Multidisciplinary.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'peds',
  'DSM-5-TR', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'เด็กหญิงอายุ 6 ปี + autism spectrum + intellectual disability — eating non-nutritive substances (dirt, paint chips, fabric, hair) × 1 ปี — developmentally inappropriate; mother concerned; recent elevated blood lead level

Lab: Hgb 9 (low — iron deficient), Pb 22 μg/dL (elevated)
Dental damage
No evidence of malnutrition'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ทารกอายุ 14 เดือน — repeated regurgitation of food (without nausea, retching) followed by re-chewing + re-swallowing × 4 เดือน, weight loss, failure to thrive

No GERD per workup
No gastrointestinal disorder identified
Mother + infant interaction: mother appears withdrawn, postpartum depression', '[{"label":"A","text":"No treatment"},{"label":"B","text":"Rumination Disorder (DSM-5"},{"label":"C","text":"Fundoplication surgery first"},{"label":"D","text":"PPI alone"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Rumination Disorder (DSM-5: repeated regurgitation ≥ 1 mo + not due to medical condition + not exclusively during ARFID/AN/BN/BED): (1) Medical workup first — rule out GERD, eosinophilic esophagitis, pyloric stenosis, neurologic, metabolic; (2) Infants — feeding interaction + caregiver assessment essential (maternal depression here): - Treat postpartum depression (SSRI — sertraline preferred; CBT/IPT; social support); - Improve mother-infant bonding (parent-infant psychotherapy, attachment-focused); - Feeding practices (positioning, post-feeding handling); - Sensory input + alternative stimulation; (3) Behavioral interventions for older children/adults: - Diaphragmatic breathing (most effective — competing response — first-line for adults/older children); - Habit reversal; - Functional analysis (sensory, self-stimulatory, attention); - Differential reinforcement; (4) Nutritional support — adequate caloric intake; (5) Comorbidity assessment: anxiety, depression, intellectual disability, autism; (6) Family + caregiver support + education; (7) Multidisciplinary: pediatrics, child psychiatry, GI, behavioral therapist, social work, lactation; (8) Distinguish from: GERD, cyclic vomiting, bulimia (deliberate self-induced), anorexia

---

Rumination Disorder: regurgitation + re-chewing/swallowing. Medical rule-out first. Infants: address caregiver + bonding (postpartum depression here). Older: diaphragmatic breathing first-line. Distinguish from GERD + bulimia. Multidisciplinary.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'peds',
  'DSM-5-TR; Rome Criteria', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ทารกอายุ 14 เดือน — repeated regurgitation of food (without nausea, retching) followed by re-chewing + re-swallowing × 4 เดือน, weight loss, failure to thrive

No GERD per workup
No gastrointestinal disorder identified
Mother + infant interaction: mother appears withdrawn, postpartum depression'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'ชายไทยอายุ 30 ปี — chronic difficulty with attention, organization, time management, procrastination, missed deadlines × adulthood, but more apparent since starting graduate school; reports similar issues since childhood (forgetful, lost things, restless) — confirmed by mother + school records

No medical cause, no other psychiatric, no substance use
ASRS-v1.1 elevated
DSM-5 ADHD criteria met (≥ 5 sx adult; onset < 12 yo)', '[{"label":"A","text":"No treatment — adults don''t have ADHD"},{"label":"B","text":"Adult ADHD"},{"label":"C","text":"Long-term benzodiazepine"},{"label":"D","text":"Surgery"},{"label":"E","text":"Antibiotic"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Adult ADHD — Combined Type (DSM-5 — onset before 12, ≥ 5 sx in adults inattention or hyperactive-impulsive, ≥ 2 settings, impairment): (1) Combination treatment most effective: medication + behavioral; (2) **Medication first-line**: - **Stimulants** (methylphenidate, amphetamine — long-acting preferred — Concerta, Vyvanse) — 70% response rate; controlled substance — diversion monitoring; - **Non-stimulants**: atomoxetine (Strattera — SNRI), guanfacine ER, clonidine ER — slower onset but useful with substance use hx, comorbid anxiety, contraindication to stimulant; (3) **Behavioral interventions**: - CBT for ADHD (Safren) — executive function strategies, organization, time management, distraction control; - Coaching; - Mindfulness; - Skills training; (4) Address comorbidity (75% adults have at least one): depression, anxiety, substance use, learning disorders, sleep, ASD; (5) Accommodations: workplace + academic (extended time, quiet environment, written instructions); (6) Lifestyle: structure + routine, exercise, sleep, limit distractions, time management tools; (7) Couples therapy if relational impact; (8) Medication monitoring: BP, HR (stimulants), height/weight (children less issue adults), cardiac if risk factors, mental health; (9) Misuse + diversion screening — abuse potential of stimulants; (10) Long-term: chronic; gradual learning of skills; medication often continued; (11) Multidisciplinary

---

Adult ADHD: onset < 12, ≥ 5 sx adults, ≥ 2 settings, impairment. Combination medication + behavioral. Stimulants 70% response. Non-stimulants for comorbidity/abuse risk. CBT for ADHD. High comorbidity. Workplace accommodations.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'adult',
  'AAP/AACAP; CADDRA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'ชายไทยอายุ 30 ปี — chronic difficulty with attention, organization, time management, procrastination, missed deadlines × adulthood, but more apparent since starting graduate school; reports similar issues since childhood (forgetful, lost things, restless) — confirmed by mother + school records

No medical cause, no other psychiatric, no substance use
ASRS-v1.1 elevated
DSM-5 ADHD criteria met (≥ 5 sx adult; onset < 12 yo)'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'วัยรุ่นชายอายุ 15 ปี — pattern × 18 เดือน — aggression to people + animals (bullies, fights, weapons), destruction of property (setting fires, vandalism), deceitfulness/theft (stolen items, lying), serious violation of rules (curfew, truancy, runaway) — onset 12 yo

Family: chaotic, parental DV, low SES
No substance use disorder
No psychotic disorder
No intellectual disability
DSM-5 conduct disorder criteria met — adolescent-onset', '[{"label":"A","text":"Punishment alone"},{"label":"B","text":"Multimodal evidence-based interventions"},{"label":"C","text":"Incarceration only"},{"label":"D","text":"No treatment"},{"label":"E","text":"Surgery"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Conduct Disorder, Adolescent-Onset (DSM-5: ≥ 3 of 15 criteria in 12 mo + ≥ 1 in past 6 mo; pattern violating rights or major norms; adolescent-onset = no criteria before 10 yo, better prognosis than childhood-onset): (1) **Multimodal evidence-based interventions**: - **Multisystemic Therapy (MST)** — intensive family + community-based; reduces recidivism + out-of-home placement; - **Functional Family Therapy (FFT)** — family-focused; - **Multidimensional Treatment Foster Care (MTFC)** — for severe; - Parent Management Training; - CBT — anger management, problem-solving; (2) Address comorbidity high: ADHD (50%), depression, anxiety, substance use, learning disorders, trauma (often); (3) ADHD treatment improves conduct sx — stimulants for comorbid; (4) Medication targets specific sx: - Atypical antipsychotic (risperidone) for severe aggression — last-line, side effects; - Mood stabilizer for aggression; - SSRI for comorbid depression/anxiety; - AVOID benzodiazepine + stimulants in misuse risk; (5) School + community involvement; address truancy; alternative educational programs; (6) Social services + child welfare — address abuse/neglect if present; family support; (7) Juvenile justice coordination; restorative justice approaches; (8) Long-term prognosis: - Adolescent-onset — often resolves into adulthood (better); - Childhood-onset — progress to ASPD (~ 40%); (9) Multidisciplinary: child + adolescent psychiatry, family therapy, school, juvenile justice, social work, primary care

---

Conduct Disorder: ≥ 3/15 criteria. Adolescent-onset (no criteria < 10) better prognosis. MST/FFT/MTFC evidence-based. CBT + parent training. Address ADHD + trauma + family. Medication targets sx. Adolescent-onset often resolves; childhood-onset → 40% ASPD.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'peds',
  'AACAP Conduct Disorder; MST Henggeler', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'วัยรุ่นชายอายุ 15 ปี — pattern × 18 เดือน — aggression to people + animals (bullies, fights, weapons), destruction of property (setting fires, vandalism), deceitfulness/theft (stolen items, lying), serious violation of rules (curfew, truancy, runaway) — onset 12 yo

Family: chaotic, parental DV, low SES
No substance use disorder
No psychotic disorder
No intellectual disability
DSM-5 conduct disorder criteria met — adolescent-onset'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 8 ปี × 12 เดือน — frequent loss of temper, easily annoyed, angry/resentful, argues with adults, defies adult requests, deliberately annoys, blames others, spiteful/vindictive × 2-3 episodes/wk — pattern at home + school + with peers

No aggression to people/animals + no destruction of property + no theft (would suggest conduct disorder)
Not during depressive/psychotic episode
DSM-5 ODD criteria met', '[{"label":"A","text":"Punishment only"},{"label":"B","text":"Oppositional Defiant Disorder (DSM-5"},{"label":"C","text":"Long-term benzodiazepine"},{"label":"D","text":"Surgery"},{"label":"E","text":"No treatment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Oppositional Defiant Disorder (DSM-5: pattern of angry/irritable mood + argumentative/defiant behavior + vindictiveness ≥ 6 mo + ≥ 4 of 8 sx + functional impairment): (1) Behavioral parent training first-line — PCIT (Parent-Child Interaction Therapy, age 2-7), Triple P, Incredible Years, Defiant Children program; (2) CBT — problem-solving, anger management; (3) Family therapy + school-based interventions; (4) Address comorbidity (high): - ADHD (very common — treat to reduce ODD sx); - Depression, anxiety; - Learning disorders; - DMDD (chronic irritability); (5) Medication adjunctive for severe + comorbidity: - Stimulants for ADHD comorbidity → ODD improves; - SSRI for depression/anxiety; - Atypical antipsychotic for severe aggression (last-line — risperidone, aripiprazole); - AVOID benzodiazepine; (6) School-based: behavioral plan, 504/IEP if needed; (7) Distinguish: - Conduct disorder (more severe — aggression to people/animals, property destruction, theft); - DMDD (chronic irritability + severe outbursts); - Normal developmental defiance; (8) Long-term: 30% progress to conduct disorder; ODD predicts adult depression, anxiety, substance use; (9) Multidisciplinary: child psychiatry, behavioral therapist, school, family

---

ODD: angry/irritable + argumentative/defiant + vindictive ≥ 6 mo. Parent training first-line (PCIT, Triple P). Address ADHD comorbidity (very common). Distinguish from conduct disorder (more severe) + DMDD (chronic irritability). 30% progress to conduct disorder.', NULL,
  'easy', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'peds',
  'AACAP ODD; PCIT Eyberg', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'เด็กชายอายุ 8 ปี × 12 เดือน — frequent loss of temper, easily annoyed, angry/resentful, argues with adults, defies adult requests, deliberately annoys, blames others, spiteful/vindictive × 2-3 episodes/wk — pattern at home + school + with peers

No aggression to people/animals + no destruction of property + no theft (would suggest conduct disorder)
Not during depressive/psychotic episode
DSM-5 ODD criteria met'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กชายอายุ 7 ปี — developmental delay since infancy, IQ 55 (mild intellectual disability), adaptive functioning impaired (conceptual, social, practical), school behind grade level; parents seeking comprehensive plan; family hx: maternal cousin with similar issues; Fragile X testing pending

No seizures, normal hearing/vision
Behavioral issues: occasional tantrums, social difficulties', '[{"label":"A","text":"No intervention"},{"label":"B","text":"IEP/504 special education"},{"label":"C","text":"Institutionalization"},{"label":"D","text":"Surgery"},{"label":"E","text":"Punishment"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Intellectual Disability (Intellectual Developmental Disorder), Mild (DSM-5: deficits in intellectual + adaptive functioning + onset during developmental period; severity based on adaptive functioning, not IQ alone): (1) Comprehensive evaluation: - **Etiologic workup**: chromosomal microarray (first-line), Fragile X testing (most common inherited cause), targeted gene panel if features, WES emerging, metabolic if features, neuroimaging if exam abnormal, lead if pica/risk; - Hearing/vision; - Medical comorbidities; (2) Educational supports: - **IEP/504 special education** — IDEA Part B; - Adaptive functioning focus + life skills; - Inclusion when possible with supports; - Vocational training (transition planning starting at 14-16 yo); (3) Behavioral interventions for behavioral issues; applied behavior analysis; positive behavioral supports; (4) Speech-language therapy + OT/PT as needed; (5) Address comorbid psychiatric disorders (high rates — 30-50%): ADHD, anxiety, depression, autism, psychotic disorders; treatment same as general population but lower medication doses + sensitive to side effects; (6) **Family support + education + genetic counseling**; reproductive recurrence risk; respite care; sibling support; (7) Transition planning to adulthood: guardianship (vs supported decision-making — modern approach), residential, vocational, healthcare, social security; (8) Sexuality + relationship education adapted; (9) Address discrimination + advocacy; (10) Multidisciplinary: developmental pediatrics, child psychiatry, neurology, genetics, school, OT/PT/SLP, social work, family

---

Intellectual Disability (DSM-5 IDD): intellectual + adaptive deficit + developmental onset. Etiologic workup (chromosomal microarray, Fragile X). Educational supports (IEP). Behavioral interventions. Address comorbid psychiatric (high). Family + genetic counseling. Multidisciplinary lifelong.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'peds',
  'DSM-5-TR; AAIDD', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'เด็กชายอายุ 7 ปี — developmental delay since infancy, IQ 55 (mild intellectual disability), adaptive functioning impaired (conceptual, social, practical), school behind grade level; parents seeking comprehensive plan; family hx: maternal cousin with similar issues; Fragile X testing pending

No seizures, normal hearing/vision
Behavioral issues: occasional tantrums, social difficulties'
  );

insert into public.mcq_questions (
  subject_id, audience, exam_type, scenario, choices, correct_answer,
  explanation, detailed_explanation, difficulty, topic, status,
  board_specialty, board_section, board_topic, board_age_group,
  reference_source, exam_source, is_ai_enhanced, ai_notes
)
select
  s.id, 'board', NULL, 'เด็กหญิงอายุ 9 ปี grade 3 — persistent difficulty with reading (slow, inaccurate, effortful word reading; poor comprehension despite adequate instruction × 18 เดือน) — IQ normal (95), no sensory impairment, no neurologic disorder, attended school regularly

Family hx: father had reading difficulty
Frustrated, beginning school avoidance, mild anxiety', '[{"label":"A","text":"Punishment for poor reading"},{"label":"B","text":"Educational intervention first-line"},{"label":"C","text":"No intervention — wait"},{"label":"D","text":"Surgery"},{"label":"E","text":"Lower expectations"}]'::jsonb,
  'B', '<!-- choice-detail --> **ตัวเลือก B (รายละเอียด):** Specific Learning Disorder, with impairment in reading (Dyslexia) — DSM-5: difficulties learning + using academic skills ≥ 6 mo despite intervention + below age-expected + not better explained by ID, sensory, neurologic, lack of instruction): (1) **Educational intervention first-line**: - Evidence-based reading instruction — **structured literacy** (Orton-Gillingham, Wilson, LiPS) — explicit, systematic phonics-based; - **IEP/504** with specific reading goals + accommodations (extended time, text-to-speech, audiobooks, modified assignments); - Intensity matters — 1:1 or small group, frequent; - Special education or reading specialist; (2) Comprehensive evaluation: - Psychoeducational testing (academic + cognitive); - Language assessment; - Hearing/vision; - Rule out other learning disorders + comorbidity; (3) Address comorbidity: ADHD (very common — 30-40%), anxiety, depression (especially school avoidance), other SLDs; (4) Treat comorbid ADHD with medication if present (improves attention + learning capacity); (5) Address anxiety + self-esteem — reading difficulty stigma; CBT if significant; (6) Family education + advocacy (parents'' rights under IDEA + ADA); (7) Long-term: persistent challenge; compensatory strategies improve; technology (text-to-speech, audiobooks) for lifelong support; many achieve academic + occupational success; (8) Multidisciplinary: psychology, special education, reading specialist, speech-language, primary care, child psychiatry if comorbid; (9) Subtypes (specifiers): reading, written expression, mathematics (dyscalculia)

---

Specific Learning Disorder (Dyslexia): persistent reading difficulty despite instruction + intact IQ. Structured literacy (Orton-Gillingham) evidence-based. IEP/504 + accommodations. Address ADHD comorbidity (30-40%). Long-term — compensatory + technology. Family advocacy.', NULL,
  'medium', 'psych_behavior', 'review',
  'psychiatry', 'clinical_decision', 'psych_behavior', 'peds',
  'DSM-5-TR; IDA; IDEA', 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'
from public.mcq_subjects s
where s.name = 'psych_clinical_decision'
  and s.audience = 'board'
  and not exists (
    select 1 from public.mcq_questions q
    where q.exam_source = 'AI-generated-board-seed'
      and q.board_specialty = 'psychiatry'
      and q.scenario = 'เด็กหญิงอายุ 9 ปี grade 3 — persistent difficulty with reading (slow, inaccurate, effortful word reading; poor comprehension despite adequate instruction × 18 เดือน) — IQ normal (95), no sensory impairment, no neurologic disorder, attended school regularly

Family hx: father had reading difficulty
Frustrated, beginning school avoidance, mild anxiety'
  );

commit;

